CREATE OR REPLACE PROCEDURE PRO_CUST_ASSE_LIAB_CUMU(
    V_SYSDAT IN VARCHAR,
    OUTCDE   OUT INTEGER
)
AS
  ------------------------------------------------------------------
  -- 报表名称: 客户资产负债基数处理
  -- 报表编号: PRO_CUST_ASSE_LIAB_CUMU
  -- 处理周期: 日
  -- 过程描述: 按客户+账户+产品+日期生成存款、贷款、理财、保险日余额基数及月/季/年累计基数
  -- 来源表：ACCT_DEPO(存款账户表)、ACCT_LOAN(贷款账户)、ACCT_FIN(理财账户)、ACCT_INSUR(保险账户信息)、
  --         DWD_ACCT_INSUR_HIS(保险账户历史表)、CUST_ASSE_LIAB_CUMU_HIS(客户资产负债基数历史表)
  -- 目标表：CUST_ASSE_LIAB_CUMU(客户资产负债基数表)、CUST_ASSE_LIAB_CUMU_HIS(客户资产负债基数历史表)
  -- 说明    ：本过程使用 CUST_ASSE_LIAB_*_TMP 中间表承接各段结果，便于跑批后排查每一步数据。
  -- author :
  -- date   : 2026-07-13
  -- 适配数据库: 人大金仓 Oracle 兼容模式
  ------------------------------------------------------------------
  ------------------------------------------------------------------
  --***************************************
  --1.自定义参数区
  --***************************************
  V_PRC_DESC             VARCHAR(100) := '客户资产负债基数处理';
  V_PRC_NAME             VARCHAR(32)  := 'PRO_CUST_ASSE_LIAB_CUMU';
  V_SYSDAT2              VARCHAR(10);
  V_SQL                  VARCHAR(4000);
  V_LOG_MSG              VARCHAR(4000);
  V_START_DT             DATE;
  V_LOG_FLG              INTEGER;
  V_LOG_BUTTON           INTEGER := 1;
  V_NO_ID                VARCHAR(10);
  V_BGN_DATE             DATE;
  V_END_DATE             DATE;
  V_DURA_DATE            INTEGER;
  P_INTERVAL_START_DATE  VARCHAR(8);
  P_INTERVAL_END_DATE    VARCHAR(8);

  -- 参数日期统一在自定义参数区声明，业务逻辑区初始化后全程复用。
  V_DATA_DATE            VARCHAR(8);
  V_DT                   DATE;
  V_MTH_BEGIN            VARCHAR(8);
  V_QRT_BEGIN            VARCHAR(8);
  V_YAR_BEGIN            VARCHAR(8);
  V_PRE_DATA_DATE        VARCHAR(8);
  V_MTH_DAYS             NUMBER(10);
  V_QRT_DAYS             NUMBER(10);
  V_YAR_DAYS             NUMBER(10);
BEGIN
  --***************************************
  -- 2. 业务逻辑区
  --***************************************
  V_START_DT := SYSDATE;
  V_DATA_DATE := V_SYSDAT;
  V_DT := TO_DATE(V_DATA_DATE, 'yyyymmdd');
  V_SYSDAT2 := TO_CHAR(V_DT, 'yyyy-mm-dd');
  V_MTH_BEGIN := TO_CHAR(TRUNC(V_DT, 'MM'), 'yyyymmdd');
  V_QRT_BEGIN := TO_CHAR(TRUNC(V_DT, 'Q'), 'yyyymmdd');
  V_YAR_BEGIN := TO_CHAR(TRUNC(V_DT, 'YYYY'), 'yyyymmdd');
  V_PRE_DATA_DATE := TO_CHAR(V_DT - 1, 'yyyymmdd');
  V_MTH_DAYS := V_DT - TRUNC(V_DT, 'MM') + 1;
  V_QRT_DAYS := V_DT - TRUNC(V_DT, 'Q') + 1;
  V_YAR_DAYS := V_DT - TRUNC(V_DT, 'YYYY') + 1;
  P_INTERVAL_START_DATE := V_YAR_BEGIN;
  P_INTERVAL_END_DATE   := V_DATA_DATE;

  --***************************************
  -- 2.1 清理当天目标表和所有中间排查表
  -- 作用：保证过程幂等；当天重复跑批时，主表、历史表和 _TMP 表均为本次结果。
  --***************************************
  V_NO_ID := '1';
  V_BGN_DATE := SYSDATE;

  DELETE FROM DWS_CUST_ASSE_LIAB_CUMU
   WHERE DATA_DATE = V_DATA_DATE;

  DELETE FROM DWS_CUST_ASSE_LIAB_CUMU_HIS
   WHERE DATA_DATE = V_DATA_DATE;

  EXECUTE IMMEDIATE 'TRUNCATE TABLE DWS_CUST_ASSE_LIAB_INSUR_TX_TMP';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE DWS_CUST_ASSE_LIAB_POLICY_BASE_TMP';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE DWS_CUST_ASSE_LIAB_LAST_STATUS_TMP';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE DWS_CUST_ASSE_LIAB_PAY_PLAN_TMP';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE DWS_CUST_ASSE_LIAB_PAY_TX_TMP';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE DWS_CUST_ASSE_LIAB_PLAN_MATCH_TMP';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE DWS_CUST_ASSE_LIAB_CURR_PERIOD_TMP';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE DWS_CUST_ASSE_LIAB_LAST_PAID_TMP';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE DWS_CUST_ASSE_LIAB_INSUR_BAL_TMP';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE DWS_CUST_ASSE_LIAB_TODAY_BAL_TMP';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE DWS_CUST_ASSE_LIAB_TODAY_AGG_TMP';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE DWS_CUST_ASSE_LIAB_KEY_SET_TMP';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE DWS_CUST_ASSE_LIAB_HIS_AGG_TMP';

  COMMIT;

  OUTCDE      := 0;
  V_END_DATE  := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG   := '2.1 清理当天目标表和所有中间排查表';
  V_LOG_FLG   := OUTCDE;

  SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

  --***************************************
  -- 2.2 生成保险历史交易临时表
  -- 作用：从保险账户历史表取截至加工日的交易记录，并标准化日期、缴费期间、保单分组键和交易级排查键。
  --***************************************
  V_NO_ID := '2';
  V_BGN_DATE := SYSDATE;

  INSERT INTO DWS_CUST_ASSE_LIAB_INSUR_TX_TMP (
      CUST_ID,
      ACCT_ID,
      PRDKT_ID,
      PRDKT_CATE_BIG,
      INSUR_BID_FORM_NO,
      TX_TYP,
      TX_DT,
      BGN_DT,
      CANCL_DT,
      PAY_PATRN,
      PAY_PERIOD_TYP,
      PAY_PERIOD,
      INSUR_AMT,
      POLICY_KEY,
      TX_SEQ,
      TX_KEY
  )
  SELECT
      X.CUST_ID                                                        AS CUST_ID,           -- 客户号
      X.ACCT_ID                                                        AS ACCT_ID,           -- 账号
      X.PRDKT_ID                                                       AS PRDKT_ID,          -- 产品编号
      X.PRDKT_CATE_BIG                                                 AS PRDKT_CATE_BIG,    -- 产品大类
      X.INSUR_BID_FORM_NO                                              AS INSUR_BID_FORM_NO, -- 投保单号
      X.TX_TYP                                                         AS TX_TYP,            -- 交易类型
      X.TX_DT                                                          AS TX_DT,             -- 交易日期
      X.BGN_DT                                                         AS BGN_DT,            -- 起保日期
      X.CANCL_DT                                                       AS CANCL_DT,          -- 退保/终止日期
      X.PAY_PATRN                                                      AS PAY_PATRN,         -- 缴费方式
      X.PAY_PERIOD_TYP                                                 AS PAY_PERIOD_TYP,    -- 缴费期间类型
      X.PAY_PERIOD                                                     AS PAY_PERIOD,        -- 缴费期间值
      X.INSUR_AMT                                                      AS INSUR_AMT,         -- 保费金额
      X.POLICY_KEY                                                     AS POLICY_KEY,        -- 保单分组键，同一保单期缴交易会重复
      X.TX_SEQ                                                         AS TX_SEQ,            -- 保单内交易序号
      X.POLICY_KEY || '|' || LPAD(X.TX_SEQ, 8, '0')                    AS TX_KEY             -- 交易级排查键
  FROM (
      SELECT
          T.CUST_ID                                                    AS CUST_ID,
          T.ACCT_ID                                                    AS ACCT_ID,
          T.PRDKT_ID                                                   AS PRDKT_ID,
          COALESCE(T.PRDKT_CATE_BIG, 'INSUR')                          AS PRDKT_CATE_BIG,
          T.INSUR_BID_FORM_NO                                          AS INSUR_BID_FORM_NO,
          T.TX_TYP                                                     AS TX_TYP,
          CASE WHEN T.TX_DATE IS NULL THEN NULL
               ELSE TO_DATE(REPLACE(SUBSTR(T.TX_DATE, 1, 10), '-', ''), 'YYYYMMDD')
          END                                                          AS TX_DT,
          CASE WHEN T.BGN_INSUR_DATE IS NULL THEN NULL
               ELSE TO_DATE(REPLACE(SUBSTR(T.BGN_INSUR_DATE, 1, 10), '-', ''), 'YYYYMMDD')
          END                                                          AS BGN_DT,
          CASE WHEN T.CANCL_INSUR_DATE IS NULL THEN NULL
               ELSE TO_DATE(REPLACE(SUBSTR(T.CANCL_INSUR_DATE, 1, 10), '-', ''), 'YYYYMMDD')
          END                                                          AS CANCL_DT,
          T.PAY_PATRN                                                  AS PAY_PATRN,
          T.PAY_PERIOD_TYP                                             AS PAY_PERIOD_TYP,
          CASE WHEN REGEXP_LIKE(T.PAY_PERIOD, '^\d+$') THEN TO_NUMBER(T.PAY_PERIOD)
               ELSE NULL
          END                                                          AS PAY_PERIOD,
          NVL(T.INSUR_AMT, 0)                                           AS INSUR_AMT,
          T.CUST_ID || '|' || T.ACCT_ID || '|' || T.PRDKT_ID || '|' ||
          T.INSUR_BID_FORM_NO                                          AS POLICY_KEY,
          ROW_NUMBER() OVER (
              PARTITION BY T.CUST_ID, T.ACCT_ID, T.PRDKT_ID, T.INSUR_BID_FORM_NO
              ORDER BY
                  CASE WHEN T.TX_DATE IS NULL THEN NULL
                       ELSE TO_DATE(REPLACE(SUBSTR(T.TX_DATE, 1, 10), '-', ''), 'YYYYMMDD')
                  END,
                  T.TX_TYP,
                  NVL(T.INSUR_AMT, 0)
          )                                                            AS TX_SEQ
      FROM DWD_ACCT_INSUR_HIS T                                                                   -- 保险账户历史表
      WHERE T.DATA_DATE <= V_DATA_DATE
        AND T.CUST_ID IS NOT NULL
        AND T.ACCT_ID IS NOT NULL
        AND T.PRDKT_ID IS NOT NULL
        AND T.INSUR_BID_FORM_NO IS NOT NULL
  ) X;

  COMMIT;

  OUTCDE      := 0;
  V_END_DATE  := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG   := '2.2 生成保险历史交易临时表';
  V_LOG_FLG   := OUTCDE;

  SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

  --***************************************
  -- 2.3 生成保单基础临时表
  -- 作用：按保单唯一键汇总首期承保日、缴费方式、缴费期间、首期保费等基础信息。
  --***************************************
  V_NO_ID := '3';
  V_BGN_DATE := SYSDATE;

  INSERT INTO DWS_CUST_ASSE_LIAB_POLICY_BASE_TMP (
      CUST_ID,
      ACCT_ID,
      PRDKT_ID,
      PRDKT_CATE_BIG,
      INSUR_BID_FORM_NO,
      POLICY_KEY,
      FIRST_TX_DT,
      BGN_DT,
      CANCL_DT,
      PAY_PATRN,
      PAY_PERIOD_TYP,
      PAY_PERIOD,
      FIRST_INSUR_AMT
  )
  SELECT
      T.CUST_ID                                                        AS CUST_ID,           -- 客户号
      T.ACCT_ID                                                        AS ACCT_ID,           -- 账号
      T.PRDKT_ID                                                       AS PRDKT_ID,          -- 产品编号
      T.PRDKT_CATE_BIG                                                 AS PRDKT_CATE_BIG,    -- 产品大类
      T.INSUR_BID_FORM_NO                                              AS INSUR_BID_FORM_NO, -- 投保单号
      T.POLICY_KEY                                                     AS POLICY_KEY,        -- 保单分组键
      MIN(CASE WHEN T.TX_TYP = '0' THEN T.TX_DT END)                   AS FIRST_TX_DT,       -- 新单承保日期
      MIN(T.BGN_DT)                                                    AS BGN_DT,            -- 最早起保日期
      MAX(T.CANCL_DT)                                                  AS CANCL_DT,          -- 退保/终止日期
      MAX(T.PAY_PATRN) KEEP (DENSE_RANK LAST ORDER BY T.TX_DT)         AS PAY_PATRN,         -- 最新缴费方式
      MAX(T.PAY_PERIOD_TYP) KEEP (DENSE_RANK LAST ORDER BY T.TX_DT)    AS PAY_PERIOD_TYP,    -- 最新缴费期间类型
      MAX(T.PAY_PERIOD) KEEP (DENSE_RANK LAST ORDER BY T.TX_DT)        AS PAY_PERIOD,        -- 最新缴费期间值
      MAX(CASE WHEN T.TX_TYP = '0' THEN T.INSUR_AMT END)               AS FIRST_INSUR_AMT    -- 首期保费金额
  FROM DWS_CUST_ASSE_LIAB_INSUR_TX_TMP T
  GROUP BY
      T.CUST_ID,
      T.ACCT_ID,
      T.PRDKT_ID,
      T.PRDKT_CATE_BIG,
      T.INSUR_BID_FORM_NO,
      T.POLICY_KEY;

  COMMIT;

  OUTCDE      := 0;
  V_END_DATE  := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG   := '2.3 生成保单基础临时表';
  V_LOG_FLG   := OUTCDE;

  SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

  --***************************************
  -- 2.4 生成保险最后状态临时表
  -- 作用：识别每张保单截至加工日最后一笔终止、撤销或复效类状态交易。
  --***************************************
  V_NO_ID := '4';
  V_BGN_DATE := SYSDATE;

  INSERT INTO DWS_CUST_ASSE_LIAB_LAST_STATUS_TMP (
      POLICY_KEY,
      LAST_STATUS_TX_TYP,
      LAST_STATUS_DT
  )
  SELECT
      X.POLICY_KEY                                                     AS POLICY_KEY,         -- 保单分组键
      X.LAST_STATUS_TX_TYP                                             AS LAST_STATUS_TX_TYP, -- 截至当天最后状态交易类型
      X.LAST_STATUS_DT                                                 AS LAST_STATUS_DT      -- 截至当天最后状态交易日期
  FROM (
      SELECT
          T.POLICY_KEY                                                 AS POLICY_KEY,
          T.TX_TYP                                                     AS LAST_STATUS_TX_TYP,
          T.TX_DT                                                      AS LAST_STATUS_DT,
          ROW_NUMBER() OVER (
              PARTITION BY T.POLICY_KEY
              ORDER BY T.TX_DT DESC
          )                                                            AS RN
      FROM DWS_CUST_ASSE_LIAB_INSUR_TX_TMP T
      WHERE T.TX_TYP IN ('2', '3', '4', '5', '6', '8', '9')
        AND T.TX_DT <= V_DT
  ) X
  WHERE X.RN = 1;

  COMMIT;

  OUTCDE      := 0;
  V_END_DATE  := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG   := '2.4 生成保险最后状态临时表';
  V_LOG_FLG   := OUTCDE;

  SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

  --***************************************
  -- 2.5 生成保险应缴计划临时表
  -- 作用：根据新单承保日期、缴费期间类型和缴费期间值推算每一期应缴日期。
  --***************************************
  V_NO_ID := '5';
  V_BGN_DATE := SYSDATE;

  INSERT INTO DWS_CUST_ASSE_LIAB_PAY_PLAN_TMP (
      POLICY_KEY,
      INSUR_BID_FORM_NO,
      PERIOD_NO,
      DUE_DT
  )
  SELECT
      B.POLICY_KEY                                                     AS POLICY_KEY,         -- 保单分组键
      B.INSUR_BID_FORM_NO                                              AS INSUR_BID_FORM_NO,  -- 投保单号
      LEVEL                                                            AS PERIOD_NO,          -- 应缴期数
      CASE
          WHEN B.PAY_PERIOD_TYP = '12' THEN ADD_MONTHS(B.FIRST_TX_DT, (LEVEL - 1) * 12)
          WHEN B.PAY_PERIOD_TYP = '1'  THEN ADD_MONTHS(B.FIRST_TX_DT, LEVEL - 1)
          WHEN B.PAY_PERIOD_TYP = '2'  THEN B.FIRST_TX_DT + LEVEL - 1
          WHEN B.PAY_PERIOD_TYP IN ('0', '-1') THEN B.FIRST_TX_DT
      END                                                              AS DUE_DT              -- 本期应缴日期
  FROM DWS_CUST_ASSE_LIAB_POLICY_BASE_TMP B
  WHERE B.PAY_PATRN = '1'
    AND B.FIRST_TX_DT IS NOT NULL
  CONNECT BY
      PRIOR B.POLICY_KEY = B.POLICY_KEY
      AND PRIOR SYS_GUID() IS NOT NULL
      AND LEVEL <= CASE
                     WHEN B.PAY_PERIOD_TYP IN ('12', '1', '2') THEN NVL(B.PAY_PERIOD, 1)
                     ELSE 1
                   END;

  COMMIT;

  OUTCDE      := 0;
  V_END_DATE  := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG   := '2.5 生成保险应缴计划临时表';
  V_LOG_FLG   := OUTCDE;

  SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

  --***************************************
  -- 2.6 生成保险缴费交易序号临时表
  -- 作用：按保单和缴费日期给新单承保、续期缴费排序，用于支持提前缴费匹配。
  --***************************************
  V_NO_ID := '6';
  V_BGN_DATE := SYSDATE;

  INSERT INTO DWS_CUST_ASSE_LIAB_PAY_TX_TMP (
      POLICY_KEY,
      PAY_TX_KEY,
      TX_DT,
      INSUR_AMT,
      PAY_SEQ
  )
  SELECT
      T.POLICY_KEY                                                     AS POLICY_KEY, -- 保单分组键
      T.TX_KEY                                                         AS PAY_TX_KEY, -- 缴费交易级排查键
      T.TX_DT                                                          AS TX_DT,      -- 缴费交易日期
      T.INSUR_AMT                                                      AS INSUR_AMT,  -- 缴费金额
      ROW_NUMBER() OVER (
          PARTITION BY T.POLICY_KEY
          ORDER BY T.TX_DT, T.TX_TYP, T.TX_KEY
      )                                                                AS PAY_SEQ     -- 缴费交易序号，用于支持提前缴费匹配
  FROM DWS_CUST_ASSE_LIAB_INSUR_TX_TMP T
  WHERE T.TX_TYP IN ('0', '1')
    AND T.TX_DT <= V_DT;

  COMMIT;

  OUTCDE      := 0;
  V_END_DATE  := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG   := '2.6 生成保险缴费交易序号临时表';
  V_LOG_FLG   := OUTCDE;

  SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

  --***************************************
  -- 2.7 生成保险应缴计划与实缴匹配临时表
  -- 作用：按期数把应缴计划与缴费交易匹配，识别当前期是否已缴及缴费金额。
  --***************************************
  V_NO_ID := '7';
  V_BGN_DATE := SYSDATE;

  INSERT INTO DWS_CUST_ASSE_LIAB_PLAN_MATCH_TMP (
      POLICY_KEY,
      INSUR_BID_FORM_NO,
      PERIOD_NO,
      DUE_DT,
      PAY_TX_KEY,
      PAID_DT,
      PAID_AMT
  )
  SELECT
      PP.POLICY_KEY                                                    AS POLICY_KEY,        -- 保单分组键
      PP.INSUR_BID_FORM_NO                                             AS INSUR_BID_FORM_NO, -- 投保单号
      PP.PERIOD_NO                                                     AS PERIOD_NO,         -- 应缴期数
      PP.DUE_DT                                                        AS DUE_DT,            -- 本期应缴日期
      PT.PAY_TX_KEY                                                    AS PAY_TX_KEY,        -- 匹配缴费交易级排查键
      PT.TX_DT                                                         AS PAID_DT,           -- 匹配缴费日期
      PT.INSUR_AMT                                                     AS PAID_AMT           -- 匹配缴费金额
  FROM DWS_CUST_ASSE_LIAB_PAY_PLAN_TMP PP
  LEFT JOIN DWS_CUST_ASSE_LIAB_PAY_TX_TMP PT
    ON PP.POLICY_KEY = PT.POLICY_KEY
   AND PP.PERIOD_NO = PT.PAY_SEQ;

  COMMIT;

  OUTCDE      := 0;
  V_END_DATE  := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG   := '2.7 生成保险应缴计划与实缴匹配临时表';
  V_LOG_FLG   := OUTCDE;

  SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

  --***************************************
  -- 2.8 生成保险当前应缴期临时表
  -- 作用：取截至加工日最近一期应缴计划，作为期缴宽限期与断缴判断依据。
  --***************************************
  V_NO_ID := '8';
  V_BGN_DATE := SYSDATE;

  INSERT INTO DWS_CUST_ASSE_LIAB_CURR_PERIOD_TMP (
      POLICY_KEY,
      INSUR_BID_FORM_NO,
      PERIOD_NO,
      DUE_DT,
      PAY_TX_KEY,
      PAID_DT,
      PAID_AMT
  )
  SELECT
      X.POLICY_KEY                                                     AS POLICY_KEY,        -- 保单分组键
      X.INSUR_BID_FORM_NO                                              AS INSUR_BID_FORM_NO, -- 投保单号
      X.PERIOD_NO                                                      AS PERIOD_NO,         -- 当前应缴期数
      X.DUE_DT                                                         AS DUE_DT,            -- 当前应缴日期
      X.PAY_TX_KEY                                                     AS PAY_TX_KEY,        -- 当前期缴费交易级排查键
      X.PAID_DT                                                        AS PAID_DT,           -- 当前期缴费日期
      X.PAID_AMT                                                       AS PAID_AMT           -- 当前期缴费金额
  FROM (
      SELECT
          M.*,
          ROW_NUMBER() OVER (
              PARTITION BY M.POLICY_KEY
              ORDER BY M.DUE_DT DESC
          )                                                            AS RN
      FROM DWS_CUST_ASSE_LIAB_PLAN_MATCH_TMP M
      WHERE M.DUE_DT <= V_DT
  ) X
  WHERE X.RN = 1;

  COMMIT;

  OUTCDE      := 0;
  V_END_DATE  := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG   := '2.8 生成保险当前应缴期临时表';
  V_LOG_FLG   := OUTCDE;

  SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

  --***************************************
  -- 2.9 生成保险最近有效缴费金额临时表
  -- 作用：取截至加工日最近一次已匹配缴费金额，用于当前期未缴但仍在宽限期内沿用。
  --***************************************
  V_NO_ID := '9';
  V_BGN_DATE := SYSDATE;

  INSERT INTO DWS_CUST_ASSE_LIAB_LAST_PAID_TMP (
      POLICY_KEY,
      LAST_PAID_AMT
  )
  SELECT
      M.POLICY_KEY                                                     AS POLICY_KEY,     -- 保单分组键
      MAX(M.PAID_AMT) KEEP (DENSE_RANK LAST ORDER BY M.PERIOD_NO)      AS LAST_PAID_AMT   -- 最近一次有效缴费金额
  FROM DWS_CUST_ASSE_LIAB_PLAN_MATCH_TMP M
  WHERE M.PAID_DT IS NOT NULL
    AND M.PAID_DT <= V_DT
  GROUP BY M.POLICY_KEY;

  COMMIT;

  OUTCDE      := 0;
  V_END_DATE  := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG   := '2.9 生成保险最近有效缴费金额临时表';
  V_LOG_FLG   := OUTCDE;

  SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

  --***************************************
  -- 2.10 生成保险当日余额临时表
  -- 作用：按照趸缴、期缴、宽限期、断缴、终止/复效口径计算保险产品当天基数。
  --***************************************
  V_NO_ID := '10';
  V_BGN_DATE := SYSDATE;

  INSERT INTO DWS_CUST_ASSE_LIAB_INSUR_BAL_TMP (
      DATA_DATE,
      CUST_ID,
      ACCT_ID,
      PRDKT_ID,
      PRDKT_CATE_BIG,
      BAL
  )
  SELECT
      V_DATA_DATE                                                       AS DATA_DATE,      -- 数据日期
      B.CUST_ID                                                         AS CUST_ID,        -- 客户号
      B.ACCT_ID                                                         AS ACCT_ID,        -- 账号
      B.PRDKT_ID                                                        AS PRDKT_ID,       -- 产品编号
      B.PRDKT_CATE_BIG                                                  AS PRDKT_CATE_BIG, -- 产品大类
      CASE
          WHEN B.FIRST_TX_DT IS NULL THEN 0
          WHEN B.CANCL_DT IS NOT NULL AND B.CANCL_DT <= V_DT THEN 0
          WHEN LS.LAST_STATUS_TX_TYP IN ('2', '3', '4', '5', '6') THEN 0
          WHEN B.PAY_PATRN = '0'
           AND V_DT >= B.FIRST_TX_DT
          THEN NVL(B.FIRST_INSUR_AMT, 0)
          WHEN B.PAY_PATRN = '1'
           AND CP.PAID_DT IS NOT NULL
          THEN NVL(CP.PAID_AMT, 0)
          WHEN B.PAY_PATRN = '1'
           AND CP.PAID_DT IS NULL
           AND V_DT <= CP.DUE_DT + 60
          THEN NVL(LP.LAST_PAID_AMT, NVL(B.FIRST_INSUR_AMT, 0))
          WHEN B.PAY_PATRN = '1'
           AND CP.PAID_DT IS NULL
           AND V_DT > CP.DUE_DT + 60
          THEN 0
          ELSE 0
      END                                                               AS BAL             -- 保险当日余额基数
  FROM DWS_CUST_ASSE_LIAB_POLICY_BASE_TMP B
  LEFT JOIN DWS_CUST_ASSE_LIAB_LAST_STATUS_TMP LS
    ON B.POLICY_KEY = LS.POLICY_KEY
  LEFT JOIN DWS_CUST_ASSE_LIAB_CURR_PERIOD_TMP CP
    ON B.POLICY_KEY = CP.POLICY_KEY
  LEFT JOIN DWS_CUST_ASSE_LIAB_LAST_PAID_TMP LP
    ON B.POLICY_KEY = LP.POLICY_KEY;

  COMMIT;

  OUTCDE      := 0;
  V_END_DATE  := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG   := '2.10 生成保险当日余额临时表';
  V_LOG_FLG   := OUTCDE;

  SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

  --***************************************
  -- 2.11 生成四类产品当日余额统一临时表
  -- 作用：把存款、贷款、理财、保险统一为客户+账户+产品+日期粒度的日余额。
  --***************************************
  V_NO_ID := '11';
  V_BGN_DATE := SYSDATE;

  INSERT INTO DWS_CUST_ASSE_LIAB_TODAY_BAL_TMP (
      DATA_DATE,
      CUST_ID,
      ACCT_ID,
      PRDKT_ID,
      PRDKT_CATE_BIG,
      BAL
  )
  SELECT
      V_DATA_DATE                                                       AS DATA_DATE,      -- 数据日期
      D.CUST_ID                                                         AS CUST_ID,        -- 客户号
      D.ACCT_ID                                                         AS ACCT_ID,        -- 账号
      D.PRDKT_ID                                                        AS PRDKT_ID,       -- 产品编号
      COALESCE(D.PRDKT_CATE_BIG, 'DEP')                                 AS PRDKT_CATE_BIG, -- 产品大类
      NVL(D.BAL, 0)                                                     AS BAL             -- 存款余额
  FROM DWD_ACCT_DEPO D                                                                            -- 存款账户表
  WHERE D.CUST_ID IS NOT NULL
    AND D.ACCT_ID IS NOT NULL

  UNION ALL

  SELECT
      V_DATA_DATE                                                       AS DATA_DATE,      -- 数据日期
      L.CUST_ID                                                         AS CUST_ID,        -- 客户号
      L.ACCT_ID                                                         AS ACCT_ID,        -- 账号
      L.PRDKT_ID                                                        AS PRDKT_ID,       -- 产品编号
      COALESCE(L.PRDKT_CATE_BIG, 'LOAN')                                AS PRDKT_CATE_BIG, -- 产品大类
      NVL(L.BAL, 0)                                                     AS BAL             -- 贷款本金余额
  FROM DWD_ACCT_LOAN L                                                                            -- 贷款账户
  WHERE L.CUST_ID IS NOT NULL
    AND L.ACCT_ID IS NOT NULL

  UNION ALL

  SELECT
      V_DATA_DATE                                                       AS DATA_DATE,      -- 数据日期
      F.CUST_ID                                                         AS CUST_ID,        -- 客户号
      F.ACCT_ID                                                         AS ACCT_ID,        -- 账号
      F.PRDKT_ID                                                        AS PRDKT_ID,       -- 产品编号
      COALESCE(F.PRDKT_CATE_BIG, 'FIN')                                 AS PRDKT_CATE_BIG, -- 产品大类
      NVL(F.FIN_AMT, 0)                                                  AS BAL             -- 理财余额
  FROM DWD_ACCT_FIN F                                                                             -- 理财账户
  WHERE F.CUST_ID IS NOT NULL
    AND F.ACCT_ID IS NOT NULL

  UNION ALL

  SELECT
      I.DATA_DATE                                                       AS DATA_DATE,      -- 数据日期
      I.CUST_ID                                                         AS CUST_ID,        -- 客户号
      I.ACCT_ID                                                         AS ACCT_ID,        -- 账号
      I.PRDKT_ID                                                        AS PRDKT_ID,       -- 产品编号
      I.PRDKT_CATE_BIG                                                  AS PRDKT_CATE_BIG, -- 产品大类
      I.BAL                                                             AS BAL             -- 保险余额
  FROM DWS_CUST_ASSE_LIAB_INSUR_BAL_TMP I;                                                        -- 保险当日余额临时表

  COMMIT;

  OUTCDE      := 0;
  V_END_DATE  := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG   := '2.11 生成四类产品当日余额统一临时表';
  V_LOG_FLG   := OUTCDE;

  SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

  --***************************************
  -- 2.12 生成当日余额聚合临时表
  -- 作用：将四类产品当日余额按客户、账户、产品、产品大类聚合到统一粒度。
  --***************************************
  V_NO_ID := '12';
  V_BGN_DATE := SYSDATE;

  INSERT INTO DWS_CUST_ASSE_LIAB_TODAY_AGG_TMP (
      DATA_DATE,
      CUST_ID,
      ACCT_ID,
      PRDKT_ID,
      PRDKT_CATE_BIG,
      BAL
  )
  SELECT
      T.DATA_DATE                                                       AS DATA_DATE,      -- 数据日期
      T.CUST_ID                                                         AS CUST_ID,        -- 客户号
      T.ACCT_ID                                                         AS ACCT_ID,        -- 账号
      T.PRDKT_ID                                                        AS PRDKT_ID,       -- 产品编号
      T.PRDKT_CATE_BIG                                                  AS PRDKT_CATE_BIG, -- 产品大类
      SUM(NVL(T.BAL, 0))                                                AS BAL             -- 聚合后日余额
  FROM DWS_CUST_ASSE_LIAB_TODAY_BAL_TMP T
  GROUP BY
      T.DATA_DATE,
      T.CUST_ID,
      T.ACCT_ID,
      T.PRDKT_ID,
      T.PRDKT_CATE_BIG;

  COMMIT;

  OUTCDE      := 0;
  V_END_DATE  := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG   := '2.12 生成当日余额聚合临时表';
  V_LOG_FLG   := OUTCDE;

  SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

  --***************************************
  -- 2.13 生成历史补零 key 临时表
  -- 作用：合并当日账户产品和本年历史账户产品，保证销户、结清、赎回后仍按 0 余额参与日均。
  --***************************************
  V_NO_ID := '13';
  V_BGN_DATE := SYSDATE;

  INSERT INTO DWS_CUST_ASSE_LIAB_KEY_SET_TMP (
      CUST_ID,
      ACCT_ID,
      PRDKT_ID,
      PRDKT_CATE_BIG
  )
  SELECT
      A.CUST_ID                                                         AS CUST_ID,        -- 客户号
      A.ACCT_ID                                                         AS ACCT_ID,        -- 账号
      A.PRDKT_ID                                                        AS PRDKT_ID,       -- 产品编号
      A.PRDKT_CATE_BIG                                                  AS PRDKT_CATE_BIG  -- 产品大类
  FROM DWS_CUST_ASSE_LIAB_TODAY_AGG_TMP A
  UNION
  SELECT
      H.CUST_ID                                                         AS CUST_ID,        -- 客户号
      H.ACCT_ID                                                         AS ACCT_ID,        -- 账号
      H.PRDKT_ID                                                        AS PRDKT_ID,       -- 产品编号
      H.PRDKT_CATE_BIG                                                  AS PRDKT_CATE_BIG  -- 产品大类
  FROM DWS_CUST_ASSE_LIAB_CUMU_HIS H                                                              -- 客户资产负债基数历史表
  WHERE H.DATA_DATE >= V_YAR_BEGIN
    AND H.DATA_DATE <  V_DATA_DATE;

  COMMIT;

  OUTCDE      := 0;
  V_END_DATE  := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG   := '2.13 生成历史补零 key 临时表';
  V_LOG_FLG   := OUTCDE;

  SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

  --***************************************
  -- 2.14 生成历史累计余额临时表
  -- 作用：直接取上一天快照中的月/季/年累计余额基数；月初、季初、年初对应累计清零。
  --***************************************
  V_NO_ID := '14';
  V_BGN_DATE := SYSDATE;

  INSERT INTO DWS_CUST_ASSE_LIAB_HIS_AGG_TMP (
      CUST_ID,
      ACCT_ID,
      PRDKT_ID,
      PRDKT_CATE_BIG,
      HIS_MTH_BAL,
      HIS_QRT_BAL,
      HIS_YAR_BAL
  )
  SELECT
      H.CUST_ID                                                         AS CUST_ID,        -- 客户号
      H.ACCT_ID                                                         AS ACCT_ID,        -- 账号
      H.PRDKT_ID                                                        AS PRDKT_ID,       -- 产品编号
      H.PRDKT_CATE_BIG                                                  AS PRDKT_CATE_BIG, -- 产品大类
      CASE WHEN V_DATA_DATE = V_MTH_BEGIN THEN 0 ELSE NVL(H.MTH_BAL, 0) END AS HIS_MTH_BAL, -- 上日月累计余额
      CASE WHEN V_DATA_DATE = V_QRT_BEGIN THEN 0 ELSE NVL(H.QRT_BAL, 0) END AS HIS_QRT_BAL, -- 上日季累计余额
      CASE WHEN V_DATA_DATE = V_YAR_BEGIN THEN 0 ELSE NVL(H.YAR_BAL, 0) END AS HIS_YAR_BAL  -- 上日年累计余额
  FROM DWS_CUST_ASSE_LIAB_CUMU_HIS H                                                              -- 客户资产负债基数历史表
  WHERE H.DATA_DATE = V_PRE_DATA_DATE;

  COMMIT;

  OUTCDE      := 0;
  V_END_DATE  := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG   := '2.14 生成历史累计余额临时表';
  V_LOG_FLG   := OUTCDE;

  SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

  --***************************************
  -- 2.15 客户资产负债基数主表落库
  -- 作用：以 key 集为准补齐当日不存在的历史账户产品，补 0 后生成日余额和月/季/年累计基数。
  --***************************************
  V_NO_ID := '15';
  V_BGN_DATE := SYSDATE;

  INSERT INTO DWS_CUST_ASSE_LIAB_CUMU (
      DATA_DATE,
      CUST_ID,
      ACCT_ID,
      PRDKT_ID,
      PRDKT_CATE_BIG,
      BAL,
      MTH_BAL,
      QRT_BAL,
      YAR_BAL,
      MTH_DAYS,
      QRT_DAYS,
      YAR_DAYS
  )
  SELECT
      V_DATA_DATE                                                       AS DATA_DATE,      -- 数据日期
      K.CUST_ID                                                         AS CUST_ID,        -- 客户号
      K.ACCT_ID                                                         AS ACCT_ID,        -- 账号
      K.PRDKT_ID                                                        AS PRDKT_ID,       -- 产品编号
      K.PRDKT_CATE_BIG                                                  AS PRDKT_CATE_BIG, -- 产品大类
      NVL(A.BAL, 0)                                                     AS BAL,            -- 日余额
      NVL(H.HIS_MTH_BAL, 0) + NVL(A.BAL, 0)                             AS MTH_BAL,        -- 月累计余额基数
      NVL(H.HIS_QRT_BAL, 0) + NVL(A.BAL, 0)                             AS QRT_BAL,        -- 季累计余额基数
      NVL(H.HIS_YAR_BAL, 0) + NVL(A.BAL, 0)                             AS YAR_BAL,        -- 年累计余额基数
      V_MTH_DAYS                                                        AS MTH_DAYS,       -- 月自然日天数
      V_QRT_DAYS                                                        AS QRT_DAYS,       -- 季自然日天数
      V_YAR_DAYS                                                        AS YAR_DAYS        -- 年自然日天数
  FROM DWS_CUST_ASSE_LIAB_KEY_SET_TMP K
  LEFT JOIN DWS_CUST_ASSE_LIAB_TODAY_AGG_TMP A
    ON K.CUST_ID = A.CUST_ID
   AND K.ACCT_ID = A.ACCT_ID
   AND K.PRDKT_ID = A.PRDKT_ID
   AND K.PRDKT_CATE_BIG = A.PRDKT_CATE_BIG
  LEFT JOIN DWS_CUST_ASSE_LIAB_HIS_AGG_TMP H
    ON K.CUST_ID = H.CUST_ID
   AND K.ACCT_ID = H.ACCT_ID
   AND K.PRDKT_ID = H.PRDKT_ID
   AND K.PRDKT_CATE_BIG = H.PRDKT_CATE_BIG;

  COMMIT;

  OUTCDE      := 0;
  V_END_DATE  := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG   := '2.15 客户资产负债基数主表落库';
  V_LOG_FLG   := OUTCDE;

  SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

  --***************************************
  -- 2.16 同步当天结果到客户资产负债基数历史表
  -- 作用：将主表当天完整 key 快照写入历史表，作为后续自然日均累计和补零依据。
  --***************************************
  V_NO_ID := '16';
  V_BGN_DATE := SYSDATE;

  INSERT INTO DWS_CUST_ASSE_LIAB_CUMU_HIS (
      DATA_DATE,
      CUST_ID,
      ACCT_ID,
      PRDKT_ID,
      PRDKT_CATE_BIG,
      BAL,
      MTH_BAL,
      QRT_BAL,
      YAR_BAL,
      MTH_DAYS,
      QRT_DAYS,
      YAR_DAYS
  )
  SELECT
      C.DATA_DATE                                                       AS DATA_DATE,      -- 数据日期
      C.CUST_ID                                                         AS CUST_ID,        -- 客户号
      C.ACCT_ID                                                         AS ACCT_ID,        -- 账号
      C.PRDKT_ID                                                        AS PRDKT_ID,       -- 产品编号
      C.PRDKT_CATE_BIG                                                  AS PRDKT_CATE_BIG, -- 产品大类
      C.BAL                                                             AS BAL,            -- 日余额
      C.MTH_BAL                                                         AS MTH_BAL,        -- 月累计余额基数
      C.QRT_BAL                                                         AS QRT_BAL,        -- 季累计余额基数
      C.YAR_BAL                                                         AS YAR_BAL,        -- 年累计余额基数
      C.MTH_DAYS                                                        AS MTH_DAYS,       -- 月自然日天数
      C.QRT_DAYS                                                        AS QRT_DAYS,       -- 季自然日天数
      C.YAR_DAYS                                                        AS YAR_DAYS        -- 年自然日天数
  FROM DWS_CUST_ASSE_LIAB_CUMU C
  WHERE C.DATA_DATE = V_DATA_DATE;

  COMMIT;

  OUTCDE      := 0;
  V_END_DATE  := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG   := '2.16 同步当天结果到客户资产负债基数历史表';
  V_LOG_FLG   := OUTCDE;

  SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

  OUTCDE := 0;

  -- ***************************************
  -- 3. 异常处理区（捕获错误码并记录详细日志）
  -- ***************************************
EXCEPTION
  WHEN OTHERS THEN
    OUTCDE := -1;
    ROLLBACK;
    V_END_DATE := SYSDATE;
    V_DURA_DATE := CASE
                     WHEN V_BGN_DATE IS NULL OR V_END_DATE IS NULL THEN NULL
                     ELSE TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60)
                   END;
    V_LOG_MSG := SUBSTR(SQLERRM, 1, 1000);
    V_LOG_FLG := OUTCDE;
    SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);
    RAISE;
END;
/
