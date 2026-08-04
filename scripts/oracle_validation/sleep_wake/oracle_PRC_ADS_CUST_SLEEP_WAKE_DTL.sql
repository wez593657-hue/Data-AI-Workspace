CREATE OR REPLACE PROCEDURE PRC_ADS_CUST_SLEEP_WAKE_DTL(
    V_SYSDAT IN VARCHAR,        -- 系统跑批日期，格式YYYYMMDD
    OUTCDE   OUT INTEGER        -- 输出状态码: 0=成功，非0=失败
)
AS
  ------------------------------------------------------------------
  -- 存储过程：睡眠户唤醒明细
  -- 处理周期: 日
  -- 适配数据库: Kingbase Oracle 兼容模式
  -- 需求版本: v2.10.0
  -- 关联需求: REQ-CUST-008(睡眠户唤醒), REQ-CUST-022(INSUR_AMT+注释同步)
  -- 变更记录:
  --   v2.1.0-v2.8.1: 见前续版本
  --   v2.9.0(2026-07-30): P0修复：
  --                       ① 新增INSUR_AMT列到所有INSERT/UPDATE（消除"幽灵唤醒"）；
  --                       ② 统一唤醒定义：增量对比（基线=0 AND 当日>0），与设计说明书一致；
  --                       ③ 修正V_IS_MONTH_BEGIN过期注释
  --   v2.10.0(2026-07-31): 月首日复核上月末清单；重置月度接触/唤醒状态；
  --                        保留月首日新增睡眠户和当日唤醒判断；增加快照和机构粒度保护
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
  V_IS_MONTH_BEGIN       CHAR(1);                                     -- 月首标志，仅允许Y/N；Y时复核上月末清单并重置月度状态。
  V_WAKE_BASELINE_DATE   VARCHAR2(8);                                 -- 唤醒基线日期；月首为上月末，非月首为当月首日。
  V_HISTORY_CUTOFF_DATE  VARCHAR2(8);                                 -- 三年历史清理边界（参数19）
  V_365D_WINDOW_BEGIN    VARCHAR2(8);                                 -- 365天动账窗口开始日（参数22）
  -- 截断指定临时表
  PROCEDURE TRUNC_TMP(P_TABLE_NAME VARCHAR2) IS
  BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE ' || P_TABLE_NAME;
  END;

BEGIN
  ------------------------------------------------------------------
  -- 步骤1: 参数校验与日期变量初始化
  ------------------------------------------------------------------
  V_NO_ID := 'TMP1';
  V_BGN_DATE := SYSDATE;

  -- 参数校验：V_SYSDAT必须为8位数字
  IF V_SYSDAT IS NULL OR NOT REGEXP_LIKE(V_SYSDAT, '^[0-9]{8}$') THEN
    RAISE_APPLICATION_ERROR(-20001, 'V_SYSDAT必须为YYYYMMDD格式');
  END IF;

  V_DATA_DATE       := V_SYSDAT;
  V_PREV_DAY        := sys_fun_deal_date(V_SYSDAT, 1);             -- T-1日（参数1）
  V_CURR_MONTH_BEGIN:= sys_fun_deal_date(V_SYSDAT, 9);             -- 当月首日（参数9）
  V_HISTORY_CUTOFF_DATE := sys_fun_deal_date(V_SYSDAT, 19);        -- 三年历史清理边界（参数19）
  V_365D_WINDOW_BEGIN   := sys_fun_deal_date(V_SYSDAT, 22);        -- 365天动账窗口开始日（参数22）
  -- 判断月首日并确定唤醒基线：
  --   月首日：[A]读昨日DTL作为上月末基石，唤醒基线用T-1(上月末快照做增量对比)
  --   非月首：[A]读昨日DTL继续累积，      唤醒基线用当月首日
  IF V_DATA_DATE = V_CURR_MONTH_BEGIN THEN
    V_IS_MONTH_BEGIN := 'Y';
    V_WAKE_BASELINE_DATE := V_PREV_DAY;
  ELSE
    V_IS_MONTH_BEGIN := 'N';
    V_WAKE_BASELINE_DATE := V_CURR_MONTH_BEGIN;
  END IF;

  ------------------------------------------------------------------
  -- 步骤2: 清理当日目标数据、三年前历史数据、所有TMP临时表
  ------------------------------------------------------------------
  DELETE FROM ADS_CUST_SLEEP_WAKE_DTL D
   WHERE D.DATA_DATE = V_DATA_DATE;                                  -- 当日(支持重跑)

  DELETE FROM ADS_CUST_SLEEP_WAKE_DTL D
   WHERE D.DATA_DATE < V_HISTORY_CUTOFF_DATE;

  TRUNC_TMP('TMP_ADS_SLEEP_WAKE_BASE');
  TRUNC_TMP('TMP_ADS_SLEEP_CANDIDATE');
  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := 'TMP1 完成: 清理目标数据+TMP表; 月首=' || V_IS_MONTH_BEGIN;
  V_LOG_FLG := OUTCDE;
  SYS_PRC_STEP_LOGS(V_SYSDAT,V_PRC_NAME,V_PRC_DESC,V_NO_ID,
      V_BGN_DATE,V_END_DATE,V_DURA_DATE,V_LOG_MSG,V_LOG_FLG,V_LOG_BUTTON);

  ------------------------------------------------------------------
  -- 步骤3: TMP2 — 四步流水生成今日睡眠客户清单
  --   [A] 写入昨日DTL清单到TMP_BASE（当月只增不减；月首先按当日条件复核）
  --   [B] 写入当日睡眠候选到TMP_CANDIDATE（排除已在BASE中）
  --   [C] TMP_CANDIDATE合并入TMP_BASE
  --   [D] 一体化更新：余额快照 + 接触状态 + 唤醒判定
  ------------------------------------------------------------------
  V_NO_ID := 'TMP2';
  V_BGN_DATE := SYSDATE;

  -- ================================================================
  -- [A] 昨日DTL清单写入TMP_BASE（每天执行，含月首日）
  --     月首日：上月末DTL按当日AUM/主动动账条件复核后作为当月清单基数；
  --             同时继续执行[B]，不能遗漏月首日新增睡眠户和当日唤醒客户。
  --     非月首：昨日DTL = 当日基底，逐步累积
  -- ================================================================
  INSERT INTO TMP_ADS_SLEEP_WAKE_BASE (
        PERSN_LEGAL_BK_CODE, CUST_ID, CUST_NAME, CUST_LVL,
        DEPO_CURNT_DEPO_BAL, FIXD_DEPO_BAL, FIN_AMT, INSUR_AMT,
        CNTCT_STATE, WAKE_STATE, POST_ID, ORG_ID
    )
    SELECT y.PERSN_LEGAL_BK_CODE,                                     -- 法人行号
           y.CUST_ID,                                                  -- 客户号
           y.CUST_NAME,                                                -- 客户名称
           y.CUST_LVL,                                                 -- 客户等级
           y.DEPO_CURNT_DEPO_BAL,                                      -- 活期余额
           y.FIXD_DEPO_BAL,                                            -- 定期余额
           y.FIN_AMT,                                                  -- 理财余额
           y.INSUR_AMT,                                                -- 保险余额
           CASE WHEN V_IS_MONTH_BEGIN = 'Y' THEN '0' ELSE y.CNTCT_STATE END,
                                                                        -- 接触状态：月首重置，月内继承。
           CASE WHEN V_IS_MONTH_BEGIN = 'Y' THEN '0' ELSE y.WAKE_STATE END,
                                                                        -- 唤醒状态：按月统计，月首重置。
           y.POST_ID,                                                  -- 管户经理
           y.ORG_ID                                                    -- 归属机构
      FROM ADS_CUST_SLEEP_WAKE_DTL y                                   -- 昨日目标表
     WHERE y.DATA_DATE = V_PREV_DAY                                    -- 昨日数据，YYYYMMDD。
       AND y.STATIS_CYCLE = 'M'                                        -- 仅处理月度周期。
       AND (
             V_IS_MONTH_BEGIN = 'N'
             OR (
                  EXISTS (
                      SELECT 1
                        FROM DWS_CUST_ASSE_LIAB a0
                       WHERE a0.CUST_ID = y.CUST_ID
                         AND a0.PERSN_LEGAL_BK_CODE = y.PERSN_LEGAL_BK_CODE
                         AND a0.DATA_DATE = V_DATA_DATE
                         AND a0.BAL_TYPE = '1'
                         AND NVL(a0.AUM_BAL, 0) < 100
                  )
                  AND NOT EXISTS (
                      SELECT 1
                        FROM DWD_TX_ASET t0
                       WHERE t0.CUST_ID = y.CUST_ID
                          AND TO_DATE(REPLACE(SUBSTR(t0.TX_DATE, 1, 10), '-', ''), 'YYYYMMDD')
                              BETWEEN TO_DATE(V_365D_WINDOW_BEGIN, 'YYYYMMDD')
                                  AND TO_DATE(V_DATA_DATE, 'YYYYMMDD')
                         AND t0.JIOYCFFS = '0'
                  )
             )
       );
  COMMIT;

  -- ================================================================
  -- [B] 写入当日睡眠候选到TMP_CANDIDATE
  --     睡眠条件: AUM日余额<100 + 近365天无主动动账(JIOYCFFS='0')
  --     排除已在BASE中的客户（防止重复）
  -- ================================================================
  INSERT INTO TMP_ADS_SLEEP_CANDIDATE (
      PERSN_LEGAL_BK_CODE, CUST_ID, CUST_NAME, CUST_LVL,
      DEPO_CURNT_DEPO_BAL, FIXD_DEPO_BAL, FIN_AMT, INSUR_AMT,
      POST_ID, ORG_ID
  )
  SELECT a.PERSN_LEGAL_BK_CODE,                                       -- 法人行号
         c.CUST_ID,                                                    -- 客户号
         c.CUST_NAME,                                                  -- 客户名称
         l.CUST_LVL,                                                   -- 客户等级
         NVL(a.DEPO_CURNT_DEPO_BAL, 0),                                -- 活期余额
         NVL(a.FIXD_DEPO_BAL, 0),                                      -- 定期余额
         NVL(a.FIN_BAL, 0),                                            -- 理财余额
         NVL(a.INSUR_BAL, 0),                                          -- 保险余额
         m.MNGR_POST_ID,                                               -- 理财管户经理
         a.ORG_ID                                                       -- 归属机构，以资产快照为准
    FROM DWD_CUST_INDV_INFO c                                          -- 客户基本信息(驱动)
    JOIN DWS_CUST_ASSE_LIAB a                                          -- 当日资产负债快照
      ON a.CUST_ID = c.CUST_ID
     AND a.PERSN_LEGAL_BK_CODE = c.PERSN_LEGAL_BK_CODE
     AND a.DATA_DATE = V_DATA_DATE                                     -- 当日快照
     AND a.BAL_TYPE = '1'                                              -- 日余额
      LEFT JOIN DWD_CUST_MAN m                                           -- 管户关系
      ON m.CUST_ID = c.CUST_ID
     AND m.PERSN_LEGAL_BK_CODE = a.PERSN_LEGAL_BK_CODE
     AND m.ORG_ID = a.ORG_ID
     AND m.MNG_TYP = '1'                                               -- 仅理财管户
    LEFT JOIN DWS_CUST_LVL_INFO l                                      -- 客户等级
      ON l.CUST_ID = c.CUST_ID
     AND l.PERSN_LEGAL_BK_CODE = a.PERSN_LEGAL_BK_CODE
     AND l.DATA_DATE = V_DATA_DATE
   WHERE NVL(a.AUM_BAL, 0) < 100                                       -- 条件1: AUM<100
     AND NOT EXISTS (                                                  -- 条件2: 近365天无主动动账
           SELECT 1 FROM DWD_TX_ASET t
           WHERE t.CUST_ID = c.CUST_ID
              AND t.PERSN_LEGAL_BK_CODE = a.PERSN_LEGAL_BK_CODE
              AND TO_DATE(REPLACE(SUBSTR(t.TX_DATE,1,10),'-',''),'YYYYMMDD')
                  BETWEEN TO_DATE(V_365D_WINDOW_BEGIN,'YYYYMMDD')
                      AND TO_DATE(V_DATA_DATE,'YYYYMMDD')
              AND t.JIOYCFFS = '0'                                    -- 主动动账标识
         )
     AND NOT EXISTS (                                                -- 排除已在BASE中（昨日清单+已有积累）
           SELECT 1 FROM TMP_ADS_SLEEP_WAKE_BASE b
            WHERE b.CUST_ID = c.CUST_ID
              AND b.PERSN_LEGAL_BK_CODE = a.PERSN_LEGAL_BK_CODE
         );
  COMMIT;

  -- ================================================================
  -- [C] TMP_CANDIDATE合并入TMP_BASE（新入客户默认未接触、未唤醒）
  -- ================================================================
  INSERT INTO TMP_ADS_SLEEP_WAKE_BASE (
      PERSN_LEGAL_BK_CODE, CUST_ID, CUST_NAME, CUST_LVL,
      DEPO_CURNT_DEPO_BAL, FIXD_DEPO_BAL, FIN_AMT, INSUR_AMT,
      CNTCT_STATE, WAKE_STATE, POST_ID, ORG_ID
  )
  SELECT ca.PERSN_LEGAL_BK_CODE,                                       -- 法人行号
         ca.CUST_ID,                                                    -- 客户号
         ca.CUST_NAME,                                                  -- 客户名称
         ca.CUST_LVL,                                                   -- 客户等级
         ca.DEPO_CURNT_DEPO_BAL,                                        -- 活期余额
         ca.FIXD_DEPO_BAL,                                              -- 定期余额
         ca.FIN_AMT,                                                    -- 理财余额
         ca.INSUR_AMT,                                                  -- 保险余额
         '0',                                                           -- CNTCT_STATE: 新入默认未接触
         '0',                                                           -- WAKE_STATE:  新入默认未唤醒
         ca.POST_ID,                                                    -- 管户经理
         ca.ORG_ID                                                      -- 归属机构
    FROM TMP_ADS_SLEEP_CANDIDATE ca;
  COMMIT;

  -- ================================================================
  -- [D] 一体化更新：余额快照 + 接触状态 + 唤醒判定
  --     一次DWS_CUST_ASSE_LIAB扫描完成，IS_WAKE标志消除三产品条件重复
  -- ================================================================
  UPDATE TMP_ADS_SLEEP_WAKE_BASE b
     SET (b.DEPO_CURNT_DEPO_BAL, b.FIXD_DEPO_BAL, b.FIN_AMT, b.INSUR_AMT,
          b.CNTCT_STATE, b.WAKE_STATE) =
         (SELECT NVL(sw.DEPO_CURNT_DEPO_BAL, b.DEPO_CURNT_DEPO_BAL),    -- 活期(保留遗值)
                 NVL(sw.FIXD_DEPO_BAL, b.FIXD_DEPO_BAL),                -- 定期
                 NVL(sw.FIN_BAL, b.FIN_AMT),                             -- 理财
                 NVL(sw.INSUR_BAL, b.INSUR_AMT),                         -- 保险
                 CASE WHEN b.CNTCT_STATE = '1' OR EXISTS (              -- 接触状态：月内累计
                        SELECT 1 FROM ADS_MKT_REC_INFO r
                         WHERE r.CUST_ID = b.CUST_ID
                           AND r.PERSN_LEGAL_BK_CODE = b.PERSN_LEGAL_BK_CODE
                           AND r.MKT_PERSN = b.POST_ID
                           AND r.MKT_TYP IN ('1','2','3','4')          -- 有效接触类型
                           AND r.MKT_TIME IS NOT NULL
                          AND TO_DATE(REPLACE(SUBSTR(r.MKT_TIME,1,10),'-',''),'YYYYMMDD')
                              BETWEEN TO_DATE(V_CURR_MONTH_BEGIN,'YYYYMMDD')
                                  AND TO_DATE(V_DATA_DATE,'YYYYMMDD')
                      ) THEN '1' ELSE '0'
                 END,
                 CASE WHEN b.WAKE_STATE = '1' THEN '1'                 -- 已唤醒保持
                      WHEN sw.IS_WAKE = 1      THEN '1'                -- 新增持有→已唤醒
                      ELSE '0'
                 END
            FROM (SELECT a2.CUST_ID, a2.PERSN_LEGAL_BK_CODE, a2.ORG_ID,
                         -- 唤醒标志: 基线产品=0 且 当日>0
                         CASE WHEN (NVL(mb.FIXD_DEPO_BAL,0)=0 AND NVL(a2.FIXD_DEPO_BAL,0)>0)
                               OR (NVL(mb.FIN_BAL,0)=0 AND NVL(a2.FIN_BAL,0)>0)
                               OR (NVL(mb.INSUR_BAL,0)=0 AND NVL(a2.INSUR_BAL,0)>0)
                              THEN 1 ELSE 0
                         END AS IS_WAKE,
                         a2.DEPO_CURNT_DEPO_BAL,
                         a2.FIXD_DEPO_BAL,
                         a2.FIN_BAL,
                         a2.INSUR_BAL
                    FROM DWS_CUST_ASSE_LIAB a2                           -- 当日快照
                    LEFT JOIN DWS_CUST_ASSE_LIAB mb                       -- 唤醒基线快照
                     ON mb.CUST_ID = a2.CUST_ID
                     AND mb.PERSN_LEGAL_BK_CODE = a2.PERSN_LEGAL_BK_CODE
                     AND mb.ORG_ID = a2.ORG_ID
                     AND mb.DATA_DATE = V_WAKE_BASELINE_DATE         -- 月首=T-1/非月首=当月首日
                     AND mb.BAL_TYPE = '1'
                   WHERE a2.DATA_DATE = V_DATA_DATE
                     AND a2.BAL_TYPE = '1'
                 ) sw
           WHERE sw.CUST_ID = b.CUST_ID
             AND sw.PERSN_LEGAL_BK_CODE = b.PERSN_LEGAL_BK_CODE
             AND sw.ORG_ID = b.ORG_ID
         )
   WHERE EXISTS (
         SELECT 1
           FROM DWS_CUST_ASSE_LIAB a3
          WHERE a3.CUST_ID = b.CUST_ID
            AND a3.PERSN_LEGAL_BK_CODE = b.PERSN_LEGAL_BK_CODE
            AND a3.ORG_ID = b.ORG_ID
            AND a3.DATA_DATE = V_DATA_DATE
            AND a3.BAL_TYPE = '1'
       );
  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := 'TMP2 完成: 四步流水([A]转入 [B]候选 [C]合并 [D]一体化更新); 月首='
    || V_IS_MONTH_BEGIN;
  V_LOG_FLG := OUTCDE;
  SYS_PRC_STEP_LOGS(V_SYSDAT,V_PRC_NAME,V_PRC_DESC,V_NO_ID,
      V_BGN_DATE,V_END_DATE,V_DURA_DATE,V_LOG_MSG,V_LOG_FLG,V_LOG_BUTTON);

  ------------------------------------------------------------------
  -- 步骤4: 目标表写入 — TMP_BASE → ADS_CUST_SLEEP_WAKE_DTL（仅M月度周期）
  ------------------------------------------------------------------
  V_NO_ID := '3';
  V_BGN_DATE := SYSDATE;

  INSERT INTO ADS_CUST_SLEEP_WAKE_DTL (
      PERSN_LEGAL_BK_CODE, DATA_DATE, CUST_ID, CUST_NAME, CUST_LVL,
      DEPO_CURNT_DEPO_BAL, FIXD_DEPO_BAL, FIN_AMT, INSUR_AMT,
      CNTCT_STATE, WAKE_STATE, POST_ID, ORG_ID, STATIS_CYCLE
  )
  SELECT b.PERSN_LEGAL_BK_CODE,                                       -- 法人行号
         V_DATA_DATE,                                                  -- 数据日期
         b.CUST_ID,                                                    -- 客户号
         b.CUST_NAME,                                                  -- 客户名称
         b.CUST_LVL,                                                   -- 客户等级
         b.DEPO_CURNT_DEPO_BAL,                                        -- 活期余额
         b.FIXD_DEPO_BAL,                                              -- 定期余额
         b.FIN_AMT,                                                    -- 理财余额
         b.INSUR_AMT,                                                  -- 保险余额
         b.CNTCT_STATE,                                                -- 接触状态
         b.WAKE_STATE,                                                 -- 唤醒状态
         b.POST_ID,                                                    -- 管户经理
         b.ORG_ID,                                                     -- 归属机构
         'M'                                                           -- 统计周期(M=月度)
    FROM TMP_ADS_SLEEP_WAKE_BASE b;
  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := '第3段完成: 写入睡眠户唤醒明细(v2.9.0 INSUR修复, 月首='
    || V_IS_MONTH_BEGIN || ')';
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
