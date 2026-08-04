CREATE OR REPLACE PROCEDURE PRC_ADS_CUST_SLEEP_WAKE_DTL(
    V_SYSDAT IN VARCHAR,        -- 系统跑批日期，格式YYYYMMDD
    OUTCDE   OUT INTEGER        -- 输出状态码: 0=成功，非0=失败
)
AS
  ------------------------------------------------------------------
  -- 存储过程：睡眠户唤醒明细
  -- 处理周期: 日
  -- 适配数据库: Kingbase Oracle 兼容模式
  -- 需求版本: v2.11.0
  -- 关联需求: REQ-CUST-008(睡眠户唤醒), REQ-CUST-023(月首复核)
  -- 变更记录:
  --   v2.1.0-v2.10.0: 见前续版本
  --   v2.11.0(2026-08-04):
  --     F-01: [A]月首复核NOT EXISTS补充PERSN_LEGAL_BK_CODE关联键
  --     F-04: 新增TMP_ADS_SLEEP_DWS_WAKE预聚合当日DWS快照(含IS_WAKE)，
  --           消除[D]步骤DWS重复扫描
  --     F-05: 新增TMP_ADS_SLEEP_CNTCT预计算当月已接触客户，
  --           [D]步骤改LEFT JOIN消除逐行EXISTS扫描ADS_MKT_REC_INFO
  --     F-07: 步骤4日志消息版本号同步至v2.11.0
  --     F-10: [A]月首复核额外保留被唤醒客户(基线产品=0且当日>0，
  --           即使AUM≥100仍保留在清单内以统计唤醒指标)
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
  TRUNC_TMP('TMP_ADS_SLEEP_DWS_WAKE');                               -- F-04新增预聚合临时表
  TRUNC_TMP('TMP_ADS_SLEEP_CNTCT');                                  -- F-05新增预聚合临时表
  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := 'TMP1 完成: 清理目标数据+TMP表; 月首=' || V_IS_MONTH_BEGIN;
  V_LOG_FLG := OUTCDE;
  SYS_PRC_STEP_LOGS(V_SYSDAT,V_PRC_NAME,V_PRC_DESC,V_NO_ID,
      V_BGN_DATE,V_END_DATE,V_DURA_DATE,V_LOG_MSG,V_LOG_FLG,V_LOG_BUTTON);

  ------------------------------------------------------------------
  -- 步骤3: TMP2 — 预聚合 + 四步流水生成今日睡眠客户清单
  --   [A0] 预聚合当日DWS快照+唤醒基线IS_WAKE → TMP_ADS_SLEEP_DWS_WAKE
  --   [A1] 预计算当月已接触客户 → TMP_ADS_SLEEP_CNTCT
  --   [A]  写入昨日DTL清单到TMP_BASE（月首复核引用[A0]判断睡眠/唤醒）
  --   [B]  写入当日睡眠候选到TMP_CANDIDATE（排除已在BASE中）
  --   [C]  TMP_CANDIDATE合并入TMP_BASE
  --   [D]  一体化更新：余额快照 + 接触状态 + 唤醒判定（JOIN [A0][A1]临时表）
  ------------------------------------------------------------------
  V_NO_ID := 'TMP2';
  V_BGN_DATE := SYSDATE;

  -- ================================================================
  -- [A0] 预聚合当日DWS快照 + 唤醒基线IS_WAKE → TMP_ADS_SLEEP_DWS_WAKE
  --     一次扫描DWS当日快照，LEFT JOIN唤醒基线快照计算IS_WAKE标志。
  --     供[A]月首复核和[D]一体化更新共用，消除DWS重复扫描(F-04)。
  -- ================================================================
  INSERT INTO TMP_ADS_SLEEP_DWS_WAKE (
        PERSN_LEGAL_BK_CODE, CUST_ID, ORG_ID, AUM_BAL,
        DEPO_CURNT_DEPO_BAL, FIXD_DEPO_BAL, FIN_BAL, INSUR_BAL, IS_WAKE
    )
    SELECT a2.PERSN_LEGAL_BK_CODE,                                     -- 法人行号
           a2.CUST_ID,                                                  -- 客户号
           a2.ORG_ID,                                                   -- 归属机构
           a2.AUM_BAL,                                                  -- 当日AUM余额
           a2.DEPO_CURNT_DEPO_BAL,                                      -- 活期余额
           a2.FIXD_DEPO_BAL,                                            -- 定期余额
           a2.FIN_BAL,                                                  -- 理财余额
           a2.INSUR_BAL,                                                -- 保险余额
           CASE WHEN (NVL(mb.FIXD_DEPO_BAL,0)=0 AND NVL(a2.FIXD_DEPO_BAL,0)>0)
                 OR (NVL(mb.FIN_BAL,0)=0 AND NVL(a2.FIN_BAL,0)>0)
                 OR (NVL(mb.INSUR_BAL,0)=0 AND NVL(a2.INSUR_BAL,0)>0)
                THEN 1 ELSE 0
           END AS IS_WAKE                                               -- 唤醒标志:基线=0且当日>0
      FROM DWS_CUST_ASSE_LIAB a2                                        -- 当日快照
      LEFT JOIN DWS_CUST_ASSE_LIAB mb                                   -- 唤醒基线快照
        ON mb.CUST_ID = a2.CUST_ID
       AND mb.PERSN_LEGAL_BK_CODE = a2.PERSN_LEGAL_BK_CODE
       AND mb.ORG_ID = a2.ORG_ID
       AND mb.DATA_DATE = V_WAKE_BASELINE_DATE                          -- 月首=T-1/非月首=当月首日
       AND mb.BAL_TYPE = '1'
     WHERE a2.DATA_DATE = V_DATA_DATE
       AND a2.BAL_TYPE = '1';
  COMMIT;

  -- ================================================================
  -- [A1] 预计算当月已接触客户 → TMP_ADS_SLEEP_CNTCT
  --     当月(V_CURR_MONTH_BEGIN~V_DATA_DATE)有有效接触(MKT_TYP IN 1/2/3/4)
  --     的客户-管户经理组合，供[D]步骤LEFT JOIN判断接触状态(F-05)。
  -- ================================================================
  INSERT INTO TMP_ADS_SLEEP_CNTCT (
      PERSN_LEGAL_BK_CODE, CUST_ID, MKT_PERSN
  )
  SELECT DISTINCT r.PERSN_LEGAL_BK_CODE,                               -- 法人行号
                  r.CUST_ID,                                            -- 客户号
                  r.MKT_PERSN                                           -- 管户经理(=POST_ID)
    FROM ADS_MKT_REC_INFO r
   WHERE r.MKT_TYP IN ('1','2','3','4')                                -- 有效接触类型
     AND r.MKT_TIME IS NOT NULL
     AND TO_DATE(REPLACE(SUBSTR(r.MKT_TIME,1,10),'-',''),'YYYYMMDD')
         BETWEEN TO_DATE(V_CURR_MONTH_BEGIN,'YYYYMMDD')
             AND TO_DATE(V_DATA_DATE,'YYYYMMDD');
  COMMIT;

  -- ================================================================
  -- [A] 昨日DTL清单写入TMP_BASE（每天执行，含月首日）
  --     月首日：上月末DTL按当日条件复核后作为当月清单基数；
  --             复核条件 = 仍满足睡眠(AUM<100 AND 无主动动账)
  --                         OR 被唤醒(基线产品=0 AND 当日>0，IS_WAKE=1)
  --                         (F-10: 被唤醒客户即使AUM≥100也保留以统计唤醒指标)
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
      LEFT JOIN TMP_ADS_SLEEP_DWS_WAKE w                               -- F-04: 预聚合DWS快照
        ON w.CUST_ID = y.CUST_ID
       AND w.PERSN_LEGAL_BK_CODE = y.PERSN_LEGAL_BK_CODE
       AND w.ORG_ID = y.ORG_ID
     WHERE y.DATA_DATE = V_PREV_DAY                                    -- 昨日数据，YYYYMMDD。
       AND y.STATIS_CYCLE = 'M'                                        -- 仅处理月度周期。
       AND (
             V_IS_MONTH_BEGIN = 'N'                                     -- 非月首: 全部保留
             OR (
                  -- 月首复核: 有当日快照 AND (仍满足睡眠条件 OR 被唤醒)
                  w.CUST_ID IS NOT NULL
                  AND (
                       -- 条件1: 仍满足睡眠(AUM<100 AND 近365天无主动动账)
                       ( NVL(w.AUM_BAL, 0) < 100
                         AND NOT EXISTS (
                             SELECT 1
                               FROM DWD_TX_ASET t0
                              WHERE t0.CUST_ID = y.CUST_ID
                                AND t0.PERSN_LEGAL_BK_CODE = y.PERSN_LEGAL_BK_CODE  -- F-01: 补充法人行关联
                                AND TO_DATE(REPLACE(SUBSTR(t0.TX_DATE, 1, 10), '-', ''), 'YYYYMMDD')
                                    BETWEEN TO_DATE(V_365D_WINDOW_BEGIN, 'YYYYMMDD')
                                        AND TO_DATE(V_DATA_DATE, 'YYYYMMDD')
                                AND t0.JIOYCFFS = '0'
                         )
                       )
                       -- 条件2: 被唤醒(F-10: 基线产品=0且当日>0，即使AUM≥100也保留)
                       OR NVL(w.IS_WAKE, 0) = 1
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
  --     F-04: JOIN TMP_ADS_SLEEP_DWS_WAKE 取余额和IS_WAKE(消除DWS重复扫描)
  --     F-05: LEFT JOIN TMP_ADS_SLEEP_CNTCT 判断接触(消除逐行EXISTS)
  -- ================================================================
  UPDATE TMP_ADS_SLEEP_WAKE_BASE b
     SET (b.DEPO_CURNT_DEPO_BAL, b.FIXD_DEPO_BAL, b.FIN_AMT, b.INSUR_AMT,
          b.CNTCT_STATE, b.WAKE_STATE) =
         (SELECT NVL(w.DEPO_CURNT_DEPO_BAL, b.DEPO_CURNT_DEPO_BAL),    -- 活期(保留遗值)
                 NVL(w.FIXD_DEPO_BAL, b.FIXD_DEPO_BAL),                -- 定期
                 NVL(w.FIN_BAL, b.FIN_AMT),                             -- 理财
                 NVL(w.INSUR_BAL, b.INSUR_AMT),                         -- 保险
                 CASE WHEN b.CNTCT_STATE = '1' OR ct.CUST_ID IS NOT NULL
                      THEN '1' ELSE '0'                                 -- 接触状态:月内累计OR预聚合接触表命中
                 END,
                 CASE WHEN b.WAKE_STATE = '1' THEN '1'                 -- 已唤醒保持
                      WHEN NVL(w.IS_WAKE, 0) = 1 THEN '1'              -- 新增持有→已唤醒
                      ELSE '0'
                 END
            FROM TMP_ADS_SLEEP_DWS_WAKE w                               -- F-04: 预聚合DWS快照
            LEFT JOIN TMP_ADS_SLEEP_CNTCT ct                            -- F-05: 预聚合接触表
              ON ct.CUST_ID = b.CUST_ID
             AND ct.PERSN_LEGAL_BK_CODE = b.PERSN_LEGAL_BK_CODE
             AND ct.MKT_PERSN = b.POST_ID
           WHERE w.CUST_ID = b.CUST_ID
             AND w.PERSN_LEGAL_BK_CODE = b.PERSN_LEGAL_BK_CODE
             AND w.ORG_ID = b.ORG_ID
         )
   WHERE EXISTS (
         SELECT 1
           FROM TMP_ADS_SLEEP_DWS_WAKE w2                               -- F-04: 引用预聚合表
          WHERE w2.CUST_ID = b.CUST_ID
            AND w2.PERSN_LEGAL_BK_CODE = b.PERSN_LEGAL_BK_CODE
            AND w2.ORG_ID = b.ORG_ID
       );
  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := 'TMP2 完成: 预聚合+[A]转入+[B]候选+[C]合并+[D]一体化更新; 月首='
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
  V_LOG_MSG := '第3段完成: 写入睡眠户唤醒明细(v2.11.0 预聚合+月首唤醒保留, 月首='
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
