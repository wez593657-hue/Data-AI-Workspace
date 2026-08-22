CREATE OR REPLACE PROCEDURE PRC_ADS_CUST_SLEEP_WAKE_DTL(
    V_SYSDAT IN VARCHAR,        -- 系统跑批日期，格式YYYYMMDD
    OUTCDE   OUT INTEGER        -- 输出状态码: 0=成功，非0=失败
)
AS
  ------------------------------------------------------------------
  -- 存储过程：睡眠户唤醒明细
  -- 处理周期: 日
  -- 适配数据库: Kingbase Oracle 兼容模式
  -- 需求版本: v2.16.2
  -- 关联需求: REQ-CUST-008(睡眠户唤醒), REQ-CUST-028(最新唤醒口径确认)
  -- 变更记录:
  --   v2.1.0-v2.11.0: 见前续版本
  --   v2.12.0(2026-08-04):
  --     唤醒判定重构: IS_WAKE改为账户表日期驱动，新增TMP_ADS_SLEEP_WAKE_PROD
  --   v2.13.0(2026-08-04): 性能优化版
  --     O-01: 新增TMP_ADS_SLEEP_ACTIVE_TXN预聚合主动动账客户，
  --           消除[A][B]步骤中DWD_TX_ASET重复扫描
  --     O-02: 合并[B][C]步骤，[B]直接写入TMP_BASE，移除TMP_CANDIDATE
  --     O-03: [D]步骤拆分为[D1]余额+唤醒更新和[D2]接触状态更新，
  --           消除嵌套子查询LEFT JOIN，改为两个简单UPDATE
  --   v2.14.0(2026-08-04): 模板规范+性能优化
  --     F-1: [B]步骤JOIN DWS_CUST_ASSE_LIAB改为JOIN TMP_ADS_SLEEP_DWS_WAKE，
  --          消除[A0]和[B]对DWS的重复全表扫描
  --     F-2: MKT_TIME/TX_DATE函数转换(TO_DATE)改为字符串范围比较，利用索引
  --     F-3: TMP2拆分为TMP2~TMP8独立步骤，每个临时表段独立编号+日志，
  --          符合模板规则#3/#4/#5
  --     F-5: 日志消息修正: 版本号v2.11.0→v2.14.0，移除废弃[C]引用，
  --          移除多余括号
  --   v2.15.0(2026-08-05): 唤醒按当月新增持有产品业务日期判定，
  --          不再要求历史余额为0或当日余额大于0；同一法人+客户仅对应一个机构。
  --   v2.16.0(2026-08-17): 睡眠户来源切换
  --     S-1: 睡眠户身份唯一来源改为DWS_CUST_DORMANT_ACCOUT(当日快照)，
  --          过程内禁止按资产/交易重算睡眠户；
  --     S-2: 月初取当日快照全量作为当月清单基数，月内取「当日快照存在且
  --          NOT EXISTS当月BASE」的新产生睡眠户追加，清单只增不减；
  --     S-3: 只做个人客户(INNER JOIN DWD_CUST_INDV_INFO)；
  --     S-4: ORG_ID仅由资产快照解析，缺失置空并预警，不兜底；
  --     S-5: TMP3(TMP_ADS_SLEEP_ACTIVE_TXN)下线；
  --     S-6: TMP4新增DORMANT客户UNION补齐分支(F-16-1)；
  --     S-7: [D1] ORG空值安全匹配(F-16-2)。
  --   v2.16.1(2026-08-17): 重构为先身份后属性（R-1）
  --     R-1: 先确定当日全部睡眠户（[A]/[B]仅构建身份+状态），
  --          再按清单客户补余额/等级/名称/管户经理/机构（[D1]属性补全）；
  --     R-2: TMP4(TMP_ADS_SLEEP_DWS_WAKE)下线，消除DWS_CUST_ASSE_LIAB
  --          全表扫描分支；[D1]仅按BASE客户键联查；
  --     R-3: 唤醒判定(WAKE_STATE)由TMP_ADS_SLEEP_WAKE_PROD独立全量更新，
  --          不依赖资产快照匹配，覆盖所有BASE客户且月内不可逆。
  --   v2.16.2(2026-08-17): 属性计算式重构（R-4）
  --     R-4a: TMP_ADS_SLEEP_WAKE_BASE瘦身为仅存身份(法人行+客户号)；
  --     R-4b: 删除[D1]/[D2]的UPDATE，余额/名称/等级/管户经理在第4段
  --          写入目标表时以LEFT JOIN直接计算；
  --     R-4c: 接触状态直接按当月(月初~跑批日)有效接触EXISTS判定；
  --     R-4d: 唤醒状态直接按当月(月初~跑批日)产品新增EXISTS判定。
  ------------------------------------------------------------------
  -- === 输入参数 ===
  -- V_SYSDAT: 系统跑批日期 VARCHAR(8)，取值YYYYMMDD，非NULL且必须为有效日期格式。
  --           作为当日资产、交易和营销数据快照日期，不直接代表数据库当前时间。
  -- OUTCDE:   输出状态码 INTEGER OUT，0=成功，-1=异常；异常时事务回滚并记录日志。
  ------------------------------------------------------------------
  V_PRC_DESC             VARCHAR(100) := '睡眠户唤醒明细处理';        -- 过程描述
  V_PRC_NAME             VARCHAR(64)  := 'PRC_ADS_CUST_SLEEP_WAKE_DTL'; -- 过程名
  V_LOG_MSG              VARCHAR(4000);                               -- 日志消息
  V_LOG_FLG              INTEGER;                                     -- 日志标志(0正常)
  V_LOG_BUTTON           INTEGER := 1;                                -- 日志按钮标识
  V_NO_ID                VARCHAR(10);                                 -- 步骤编号
  V_BGN_DATE             DATE;                                        -- 步骤开始时间
  V_END_DATE             DATE;                                        -- 步骤结束时间
  V_DURA_DATE            INTEGER;                                     -- 步骤耗时(秒)
  V_DATA_DATE            VARCHAR2(8);                                 -- 数据日期，YYYYMMDD，等于V_SYSDAT。
  V_PREV_DAY             VARCHAR2(8);                                 -- 上一日，YYYYMMDD，由sys_fun_deal_date(V_SYSDAT,1)生成。
  V_CURR_MONTH_BEGIN     VARCHAR2(8);                                 -- 当月首日，YYYYMMDD，由sys_fun_deal_date(V_SYSDAT,9)生成。
  V_IS_MONTH_BEGIN       CHAR(1);                                     -- 月首标志，仅允许Y/N；Y时月初重置月度清单。
  V_HISTORY_CUTOFF_DATE  VARCHAR2(8);                                 -- 三年历史清理边界（参数19）
  V_SNAP_CNT             INTEGER;                                      -- DORMANT当日快照记录数（v2.16.0前置校验）
  -- 截断指定临时表
  PROCEDURE TRUNC_TMP(P_TABLE_NAME VARCHAR2) IS
  BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE ' || P_TABLE_NAME;
  END;

BEGIN
  ------------------------------------------------------------------
  -- 步骤1: 参数校验与日期变量初始化
  ------------------------------------------------------------------
  V_NO_ID := '1';
  V_BGN_DATE := SYSDATE;

  -- 参数校验：V_SYSDAT必须为8位数字
  IF V_SYSDAT IS NULL OR NOT REGEXP_LIKE(V_SYSDAT, '^[0-9]{8}$') THEN
    RAISE_APPLICATION_ERROR(-20001, 'V_SYSDAT必须为YYYYMMDD格式');
  END IF;

  V_DATA_DATE       := V_SYSDAT;
  V_PREV_DAY        := sys_fun_deal_date(V_SYSDAT, 1);             -- T-1日（参数1）
  V_CURR_MONTH_BEGIN:= sys_fun_deal_date(V_SYSDAT, 9);             -- 当月首日（参数9）
  V_HISTORY_CUTOFF_DATE := sys_fun_deal_date(V_SYSDAT, 19);        -- 三年历史清理边界（参数19）
  -- 判断月首日：
  --   月首日：[A]读昨日DTL作为上月末基石
  --   非月首：[A]读昨日DTL继续累积
  IF V_DATA_DATE = V_CURR_MONTH_BEGIN THEN
    V_IS_MONTH_BEGIN := 'Y';
  ELSE
    V_IS_MONTH_BEGIN := 'N';
  END IF;

  -- v2.16.0 S-1前置校验: DORMANT当日快照必须就绪，未就绪直接终止（不回退T-1）
  SELECT COUNT(*)
    INTO V_SNAP_CNT
    FROM DWS_CUST_DORMANT_ACCOUT
   WHERE DATA_DATE = V_DATA_DATE;
  IF V_SNAP_CNT = 0 THEN
    RAISE_APPLICATION_ERROR(-20003, 'DWS_CUST_DORMANT_ACCOUT当日快照未就绪: ' || V_DATA_DATE);
  END IF;

  ------------------------------------------------------------------
  -- 步骤2: 清理当日目标数据、三年前历史数据、所有TMP临时表
  ------------------------------------------------------------------
  DELETE FROM ADS_CUST_SLEEP_WAKE_DTL D
   WHERE D.DATA_DATE = V_DATA_DATE;                                  -- 当日(支持重跑)

  DELETE FROM ADS_CUST_SLEEP_WAKE_DTL D
   WHERE D.DATA_DATE < V_HISTORY_CUTOFF_DATE;

  TRUNC_TMP('TMP_ADS_SLEEP_WAKE_BASE');
  TRUNC_TMP('TMP_ADS_SLEEP_DWS_WAKE');                              -- v2.16.1已下线，保留清理用于对账
  TRUNC_TMP('TMP_ADS_SLEEP_CNTCT');
  TRUNC_TMP('TMP_ADS_SLEEP_WAKE_PROD');
  TRUNC_TMP('TMP_ADS_SLEEP_ACTIVE_TXN');                              -- v2.16.0已下线，保留清理用于对账
  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := '1 完成: 清理目标数据+TMP表; 月首=' || V_IS_MONTH_BEGIN;
  V_LOG_FLG := OUTCDE;
  SYS_PRC_STEP_LOGS(V_SYSDAT,V_PRC_NAME,V_PRC_DESC,V_NO_ID,
      V_BGN_DATE,V_END_DATE,V_DURA_DATE,V_LOG_MSG,V_LOG_FLG,V_LOG_BUTTON);

  ------------------------------------------------------------------
  -- 步骤3: 预聚合 + 身份清单 + 目标表写入 (v2.16.2)
  --   '2'  预聚合当月产品新增客户 → TMP_ADS_SLEEP_WAKE_PROD（唤醒源）
  --   '3'  预计算当月已接触客户 → TMP_ADS_SLEEP_CNTCT（接触判定源）
  --   '4'  身份清单基底: 月初=DORMANT当日全量，月内=昨日DTL继承（仅客户号+法人行）
  --   '5'  当日新产生睡眠户追加（DORMANT当日增量，仅客户号+法人行）
  --   '6'  目标表写入: 属性LEFT JOIN计算 + 接触/唤醒当月窗口EXISTS判定
  --   （TMP3/TMP4/TMP8等下线步骤占位已移除，详见变更记录）
  ------------------------------------------------------------------
  V_NO_ID := '2';
  V_BGN_DATE := SYSDATE;

  -- ================================================================
  -- [A0a] 预聚合当月产品新增客户 → TMP_ADS_SLEEP_WAKE_PROD
  --      从三张账户表按日期范围聚合有新增的客户，供[A0]步骤IS_WAKE判断。
  --      v2.12.0: 消除[A0]中三个EXISTS子查询，提升可读性和性能。
  -- ================================================================
  INSERT INTO TMP_ADS_SLEEP_WAKE_PROD (PERSN_LEGAL_BK_CODE, CUST_ID)
  SELECT DISTINCT d.PERSN_LEGAL_BK_CODE, d.CUST_ID
    FROM DWD_ACCT_DEPO d
   WHERE d.INTRI_BGN_DATE >= V_CURR_MONTH_BEGIN                          -- 定期起息日在当月范围内
     AND d.INTRI_BGN_DATE <= V_DATA_DATE
     AND d.FIX_CURNT_FLG = '1'                                           -- 定期
  UNION
  SELECT DISTINCT f.PERSN_LEGAL_BK_CODE, f.CUST_ID
    FROM DWD_ACCT_FIN f
   WHERE f.ISSU_DATE >= V_CURR_MONTH_BEGIN                               -- 理财办理日在当月范围内
     AND f.ISSU_DATE <= V_DATA_DATE
  UNION
  SELECT DISTINCT i.PERSN_LEGAL_BK_CODE, i.CUST_ID
    FROM DWD_ACCT_INSUR i
   WHERE i.LAST_TX_DATE >= V_CURR_MONTH_BEGIN                            -- 保险最近交易日在当月范围内
     AND i.LAST_TX_DATE <= V_DATA_DATE;
  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := '2 完成: 预聚合当月产品新增客户(定期+理财+保险)';
  V_LOG_FLG := OUTCDE;
  SYS_PRC_STEP_LOGS(V_SYSDAT,V_PRC_NAME,V_PRC_DESC,V_NO_ID,
      V_BGN_DATE,V_END_DATE,V_DURA_DATE,V_LOG_MSG,V_LOG_FLG,V_LOG_BUTTON);

  -- ================================================================
  -- [A1] 预计算当月已接触客户 → TMP_ADS_SLEEP_CNTCT
  --     当月(V_CURR_MONTH_BEGIN~V_DATA_DATE)有有效接触(MKT_TYP IN 1/2/3/4)
  --     的客户-管户经理组合，供[D]步骤LEFT JOIN判断接触状态(F-05)。
  --     v2.14.0 F-2: MKT_TIME字符串范围比较利用索引。
  -- ================================================================
  V_NO_ID := '3';
  V_BGN_DATE := SYSDATE;
  INSERT INTO TMP_ADS_SLEEP_CNTCT (
      PERSN_LEGAL_BK_CODE, CUST_ID, MKT_PERSN
  )
  SELECT DISTINCT r.PERSN_LEGAL_BK_CODE,                               -- 法人行号
                  r.CUST_ID,                                            -- 客户号
                  r.MKT_PERSN                                           -- 管户经理(=POST_ID)
    FROM ADS_MKT_REC_INFO r
   WHERE r.MKT_TYP IN ('1','2','3','4')                                -- 有效接触类型
     AND r.MKT_TIME IS NOT NULL
     AND r.MKT_TIME >= SUBSTR(V_CURR_MONTH_BEGIN,1,4) || '-' ||
                       SUBSTR(V_CURR_MONTH_BEGIN,5,2) || '-' ||
                       SUBSTR(V_CURR_MONTH_BEGIN,7,2)                     -- v2.14.0 F-2: 字符串范围比较利用索引
     AND r.MKT_TIME <= SUBSTR(V_DATA_DATE,1,4) || '-' ||
                       SUBSTR(V_DATA_DATE,5,2) || '-' ||
                       SUBSTR(V_DATA_DATE,7,2);
  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := '3 完成: 预聚合当月已接触客户';
  V_LOG_FLG := OUTCDE;
  SYS_PRC_STEP_LOGS(V_SYSDAT,V_PRC_NAME,V_PRC_DESC,V_NO_ID,
      V_BGN_DATE,V_END_DATE,V_DURA_DATE,V_LOG_MSG,V_LOG_FLG,V_LOG_BUTTON);

  -- ================================================================
  -- [A] 当日身份清单基底构建 (v2.16.2)
  --     仅获取睡眠户身份(客户号+法人行号)；属性(余额/名称/等级/管户经理)
  --     与状态(接触/唤醒)均在步骤'6'写入目标表时直接计算，不使用UPDATE。
  --     月初：DORMANT当日快照全量作为当月清单基数；
  --     月内：昨日DTL身份继承（清单只增不减）。
  --     所有睡眠户一律出自DORMANT表，过程内不再按资产/交易重算。
  -- ================================================================
  V_NO_ID := '4';
  V_BGN_DATE := SYSDATE;

  IF V_IS_MONTH_BEGIN = 'Y' THEN
    -- 月初: DORMANT当日快照全量，仅身份
    INSERT INTO TMP_ADS_SLEEP_WAKE_BASE (PERSN_LEGAL_BK_CODE, CUST_ID)
    SELECT d.PERSN_LEGAL_BK_CODE, d.CUST_ID
      FROM DWS_CUST_DORMANT_ACCOUT d
     WHERE d.DATA_DATE = V_DATA_DATE;
  ELSE
    -- 月内: 昨日DTL身份继承（清单只增不减）
    INSERT INTO TMP_ADS_SLEEP_WAKE_BASE (PERSN_LEGAL_BK_CODE, CUST_ID)
    SELECT y.PERSN_LEGAL_BK_CODE, y.CUST_ID
      FROM ADS_CUST_SLEEP_WAKE_DTL y
     WHERE y.DATA_DATE = V_PREV_DAY
       AND y.STATIS_CYCLE = 'M';
  END IF;
  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := '4 完成: 身份清单基底构建(客户号+法人行); 月首=' || V_IS_MONTH_BEGIN;
  V_LOG_FLG := OUTCDE;
  SYS_PRC_STEP_LOGS(V_SYSDAT,V_PRC_NAME,V_PRC_DESC,V_NO_ID,
      V_BGN_DATE,V_END_DATE,V_DURA_DATE,V_LOG_MSG,V_LOG_FLG,V_LOG_BUTTON);

  -- ================================================================
  -- [B] 当日新产生睡眠户追加 (v2.16.2)
  --     仅身份(客户号+法人行号)；增量=当日快照存在且NOT EXISTS当月BASE
  -- ================================================================
  V_NO_ID := '5';
  V_BGN_DATE := SYSDATE;
  INSERT INTO TMP_ADS_SLEEP_WAKE_BASE (PERSN_LEGAL_BK_CODE, CUST_ID)
  SELECT d.PERSN_LEGAL_BK_CODE, d.CUST_ID
    FROM DWS_CUST_DORMANT_ACCOUT d
   WHERE d.DATA_DATE = V_DATA_DATE                                   -- 当日快照
     AND NOT EXISTS (                                                -- 增量: 不在当月清单
           SELECT 1 FROM TMP_ADS_SLEEP_WAKE_BASE b
            WHERE b.CUST_ID = d.CUST_ID
              AND b.PERSN_LEGAL_BK_CODE = d.PERSN_LEGAL_BK_CODE
        );
  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := '5 完成: 当日新产生睡眠户身份追加';
  V_LOG_FLG := OUTCDE;
  SYS_PRC_STEP_LOGS(V_SYSDAT,V_PRC_NAME,V_PRC_DESC,V_NO_ID,
      V_BGN_DATE,V_END_DATE,V_DURA_DATE,V_LOG_MSG,V_LOG_FLG,V_LOG_BUTTON);

  -- ================================================================
  ------------------------------------------------------------------
  -- 步骤6: 目标表写入 — 身份BASE + 属性联查 + 接触/唤醒直接判定
  --   v2.16.2 R-4b/R-4c/R-4d: 不使用UPDATE；
  --   余额/名称/等级/管户经理/ORG 以LEFT JOIN直接计算（缺失按0/空）；
  --   接触 = 当月(月初~跑批日)有效接触EXISTS（TMP5预聚合）；
  --   唤醒 = 当月(月初~跑批日)产品新增EXISTS（TMP2预聚合）。
  ------------------------------------------------------------------
  V_NO_ID := '6';
  V_BGN_DATE := SYSDATE;

  INSERT INTO ADS_CUST_SLEEP_WAKE_DTL (
      PERSN_LEGAL_BK_CODE, DATA_DATE, CUST_ID, CUST_NAME, CUST_LVL,
      DEPO_CURNT_DEPO_BAL, FIXD_DEPO_BAL, FIN_AMT, INSUR_AMT,
      CNTCT_STATE, WAKE_STATE, POST_ID, ORG_ID, STATIS_CYCLE
  )
  SELECT b.PERSN_LEGAL_BK_CODE,                                       -- 法人行号
         V_DATA_DATE,                                                  -- 数据日期
         b.CUST_ID,                                                    -- 客户号
         NVL(c.CUST_NAME, ''),                                         -- 客户名称（客户信息表）
         l.CUST_LVL,                                                   -- 客户等级（等级快照）
         NVL(w.DEPO_CURNT_DEPO_BAL, 0),                                -- 活期余额（资产快照，缺失按0）
         NVL(w.FIXD_DEPO_BAL, 0),                                      -- 定期余额
         NVL(w.FIN_BAL, 0),                                            -- 理财余额
         NVL(w.INSUR_BAL, 0),                                          -- 保险余额
         CASE WHEN EXISTS (                                            -- 接触: 当月窗口直接判定
                 SELECT 1 FROM TMP_ADS_SLEEP_CNTCT ct
                  WHERE ct.CUST_ID = b.CUST_ID
                    AND ct.PERSN_LEGAL_BK_CODE = b.PERSN_LEGAL_BK_CODE
                    AND ct.MKT_PERSN = m.MNGR_POST_ID
              ) THEN '1' ELSE '0' END AS CNTCT_STATE,
         CASE WHEN EXISTS (                                            -- 唤醒: 当月窗口直接判定
                 SELECT 1 FROM TMP_ADS_SLEEP_WAKE_PROD p
                  WHERE p.CUST_ID = b.CUST_ID
                    AND p.PERSN_LEGAL_BK_CODE = b.PERSN_LEGAL_BK_CODE
              ) THEN '1' ELSE '0' END AS WAKE_STATE,
         m.MNGR_POST_ID,                                               -- 理财管户经理
         w.ORG_ID,                                                     -- 归属机构（资产快照，可为空）
         'M'                                                           -- 统计周期(M=月度)
    FROM TMP_ADS_SLEEP_WAKE_BASE b                                    -- 身份清单（仅客户号+法人行）
    LEFT JOIN DWD_CUST_INDV_INFO c
      ON c.CUST_ID = b.CUST_ID
     AND c.PERSN_LEGAL_BK_CODE = b.PERSN_LEGAL_BK_CODE
    LEFT JOIN DWS_CUST_LVL_INFO l
      ON l.CUST_ID = b.CUST_ID
     AND l.PERSN_LEGAL_BK_CODE = b.PERSN_LEGAL_BK_CODE
     AND l.DATA_DATE = V_DATA_DATE
    LEFT JOIN DWS_CUST_ASSE_LIAB w
      ON w.CUST_ID = b.CUST_ID
     AND w.PERSN_LEGAL_BK_CODE = b.PERSN_LEGAL_BK_CODE
     AND w.DATA_DATE = V_DATA_DATE
     AND w.BAL_TYPE = '1'
    LEFT JOIN DWD_CUST_MAN m
      ON m.CUST_ID = b.CUST_ID
     AND m.PERSN_LEGAL_BK_CODE = b.PERSN_LEGAL_BK_CODE
     AND m.MNG_TYP = '1'                                              -- 仅理财管户
     AND (m.ORG_ID = w.ORG_ID OR (m.ORG_ID IS NULL AND w.ORG_ID IS NULL));
  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := '第6段完成: 写入睡眠户唤醒明细(v2.16.2 属性计算式)';
  V_LOG_FLG := OUTCDE;
  SYS_PRC_STEP_LOGS(V_SYSDAT,V_PRC_NAME,V_PRC_DESC,V_NO_ID,
      V_BGN_DATE,V_END_DATE,V_DURA_DATE,V_LOG_MSG,V_LOG_FLG,V_LOG_BUTTON);

EXCEPTION
  WHEN OTHERS THEN
    OUTCDE := -1;
    ROLLBACK;
    V_END_DATE := SYSDATE;
    V_DURA_DATE := CASE WHEN V_BGN_DATE IS NOT NULL AND V_END_DATE IS NOT NULL
                        THEN TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60) END;
    V_LOG_MSG := SUBSTR(SQLERRM, 1, 1000);
    V_LOG_FLG := OUTCDE;
    SYS_PRC_STEP_LOGS(V_SYSDAT,V_PRC_NAME,V_PRC_DESC,V_NO_ID,
        V_BGN_DATE,V_END_DATE,V_DURA_DATE,V_LOG_MSG,V_LOG_FLG,V_LOG_BUTTON);
    RAISE;
END;
/
