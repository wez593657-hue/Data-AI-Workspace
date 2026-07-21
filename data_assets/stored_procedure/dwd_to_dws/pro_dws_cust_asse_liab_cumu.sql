CREATE OR REPLACE PROCEDURE PRO_DWS_CUST_ASSE_LIAB_CUMU(
    V_SYSDAT IN VARCHAR,
    OUTCDE   OUT INTEGER
)
AS
  ------------------------------------------------------------------
  -- 报表名称：客户资产负债基数处理
  -- 报表编号：PRO_CUST_ASSE_LIAB_CUMU
  -- 处理周期：日
  -- 过程描述：按客户 + 账户 + 产品 + 日期生成存款、贷款、理财、保险余额基数及月/季/年累计余额基数。
  -- 来源表：DWD_ACCT_DEPO、DWD_ACCT_LOAN、DWD_ACCT_FIN、DWD_ACCT_INSUR、DWD_ACCT_INSUR_HIS、DWS_CUST_ASSE_LIAB_CUMU_HIS
  -- 目标表：DWS_CUST_ASSE_LIAB_CUMU、DWS_CUST_ASSE_LIAB_CUMU_HIS
  -- 适配数据库：Oracle 兼容模式 / Kingbase Oracle 兼容模式
  ------------------------------------------------------------------
  ------------------------------------------------------------------
  --***************************************
  --1.自定义参数区
  --***************************************
  V_PRC_DESC             VARCHAR(100) := '客户资产负债基数处理';
  V_PRC_NAME             VARCHAR(32)  := 'PRO_CUST_ASSE_LIAB_CUMU';
  V_SYSDAT2              VARCHAR(10);
  V_LOG_MSG              VARCHAR(4000);
  V_LOG_FLG              INTEGER;
  V_LOG_BUTTON           INTEGER := 1;
  V_NO_ID                VARCHAR(10);
  V_BGN_DATE             DATE;
  V_END_DATE             DATE;
  V_DURA_DATE            INTEGER;
  P_INTERVAL_START_DATE  VARCHAR(8);
  P_INTERVAL_END_DATE    VARCHAR(8);
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
  -- 2.业务逻辑区
  --***************************************
  V_DATA_DATE := V_SYSDAT;
  V_DT := TO_DATE(V_DATA_DATE, 'YYYYMMDD');
  V_SYSDAT2 := TO_CHAR(V_DT, 'YYYY-MM-DD');
  V_MTH_BEGIN := TO_CHAR(TRUNC(V_DT, 'MM'), 'YYYYMMDD');
  V_QRT_BEGIN := TO_CHAR(TRUNC(V_DT, 'Q'), 'YYYYMMDD');
  V_YAR_BEGIN := TO_CHAR(TRUNC(V_DT, 'YYYY'), 'YYYYMMDD');
  V_PRE_DATA_DATE := TO_CHAR(V_DT - 1, 'YYYYMMDD');
  V_MTH_DAYS := V_DT - TRUNC(V_DT, 'MM') + 1;
  V_QRT_DAYS := V_DT - TRUNC(V_DT, 'Q') + 1;
  V_YAR_DAYS := V_DT - TRUNC(V_DT, 'YYYY') + 1;
  P_INTERVAL_START_DATE := V_YAR_BEGIN;
  P_INTERVAL_END_DATE   := V_DATA_DATE;

  --***************************************
  -- 2.1 清理当日目标数据和排查临时表
  -- 作用：重跑同一数据日期时先清理当日结果，并清空每段逻辑使用的中间排查表。
  --***************************************
  V_NO_ID := '1';
  V_BGN_DATE := SYSDATE;

  DELETE FROM DWS_CUST_ASSE_LIAB_CUMU
   WHERE DATA_DATE = V_DATA_DATE;

  DELETE FROM DWS_CUST_ASSE_LIAB_CUMU_HIS
   WHERE DATA_DATE = V_DATA_DATE;

  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_DWS_CUST_ASSE_LIAB_INSUR_TX';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_DWS_CUST_ASSE_LIAB_POLICY_BASE';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_DWS_CUST_ASSE_LIAB_LAST_STATUS';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_DWS_CUST_ASSE_LIAB_PAY_PLAN';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_DWS_CUST_ASSE_LIAB_PAY_TX';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_DWS_CUST_ASSE_LIAB_PLAN_MATCH';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_DWS_CUST_ASSE_LIAB_CURR_PERIOD';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_DWS_CUST_ASSE_LIAB_LAST_PAID';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_DWS_CUST_ASSE_LIAB_INSUR_BAL';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_DWS_CUST_ASSE_LIAB_TODAY_BAL';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_DWS_CUST_ASSE_LIAB_TODAY_AGG';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_DWS_CUST_ASSE_LIAB_KEY_SET';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_DWS_CUST_ASSE_LIAB_HIS_AGG';

  COMMIT;

  OUTCDE      := 0;
  V_END_DATE  := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG   := '2.1 清理当日目标数据和排查临时表';
  V_LOG_FLG   := OUTCDE;

  SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

  --***************************************
  -- 2.2 生成保险历史交易临时表
  -- 作用：历史表只取交易流水、交易类型、交易金额；保单当前属性优先从当前保险账户表去重后取得。
  --***************************************
  V_NO_ID := '2';
  V_BGN_DATE := SYSDATE;

  INSERT INTO TMP_DWS_CUST_ASSE_LIAB_INSUR_TX (
      CUST_ID,
      ACCT_ID,
      PRDKT_ID,
      PRDKT_CATE_BIG,
      INSUR_BID_FORM_NO,
      TX_TYP,
      TX_DT,
      BGN_DT,
      CANCL_DT,
      PAY_UPTO_DT,
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
      X.CANCL_DT                                                       AS CANCL_DT,          -- 退保或终止日期
      X.PAY_UPTO_DT                                                    AS PAY_UPTO_DT,       -- 缴费截止日期
      X.PAY_PATRN                                                      AS PAY_PATRN,         -- 缴费方式
      X.PAY_PERIOD_TYP                                                 AS PAY_PERIOD_TYP,    -- 缴费期间类型
      X.PAY_PERIOD                                                     AS PAY_PERIOD,        -- 缴费期间值
      X.INSUR_AMT                                                      AS INSUR_AMT,         -- 保费金额
      X.POLICY_KEY                                                     AS POLICY_KEY,        -- 保单分组键
      X.TX_SEQ                                                         AS TX_SEQ,            -- 保单内交易序号
      X.POLICY_KEY || '|' || LPAD(X.TX_SEQ, 8, '0')                    AS TX_KEY             -- 交易级排查键
  FROM (
      SELECT
          T.CUST_ID                                                    AS CUST_ID,
          T.ACCT_ID                                                    AS ACCT_ID,
          T.PRDKT_ID                                                   AS PRDKT_ID,
          COALESCE(C.PRDKT_CATE_BIG, T.PRDKT_CATE_BIG, 'INSUR')        AS PRDKT_CATE_BIG,
          T.INSUR_BID_FORM_NO                                          AS INSUR_BID_FORM_NO,
          T.TX_TYP                                                     AS TX_TYP,
          CASE
              WHEN T.TX_DATE IS NOT NULL
               AND REGEXP_LIKE(REPLACE(SUBSTR(T.TX_DATE, 1, 10), '-', ''), '^[0-9]{8}$')
              THEN TO_DATE(REPLACE(SUBSTR(T.TX_DATE, 1, 10), '-', ''), 'YYYYMMDD')
          END                                                          AS TX_DT,
          CASE
              WHEN COALESCE(C.BGN_INSUR_DATE, T.BGN_INSUR_DATE) IS NOT NULL
               AND REGEXP_LIKE(REPLACE(SUBSTR(COALESCE(C.BGN_INSUR_DATE, T.BGN_INSUR_DATE), 1, 10), '-', ''), '^[0-9]{8}$')
              THEN TO_DATE(REPLACE(SUBSTR(COALESCE(C.BGN_INSUR_DATE, T.BGN_INSUR_DATE), 1, 10), '-', ''), 'YYYYMMDD')
          END                                                          AS BGN_DT,
          CASE
              WHEN COALESCE(C.CANCL_INSUR_DATE, T.CANCL_INSUR_DATE) IS NOT NULL
               AND REGEXP_LIKE(REPLACE(SUBSTR(COALESCE(C.CANCL_INSUR_DATE, T.CANCL_INSUR_DATE), 1, 10), '-', ''), '^[0-9]{8}$')
              THEN TO_DATE(REPLACE(SUBSTR(COALESCE(C.CANCL_INSUR_DATE, T.CANCL_INSUR_DATE), 1, 10), '-', ''), 'YYYYMMDD')
          END                                                          AS CANCL_DT,
          CASE
              WHEN C.PAY_UPTO_DATE IS NOT NULL
               AND REGEXP_LIKE(REPLACE(SUBSTR(C.PAY_UPTO_DATE, 1, 10), '-', ''), '^[0-9]{8}$')
              THEN TO_DATE(REPLACE(SUBSTR(C.PAY_UPTO_DATE, 1, 10), '-', ''), 'YYYYMMDD')
          END                                                          AS PAY_UPTO_DT,
          COALESCE(C.PAY_PATRN, T.PAY_PATRN)                           AS PAY_PATRN,
          COALESCE(C.PAY_PERIOD_TYP, T.PAY_PERIOD_TYP)                 AS PAY_PERIOD_TYP,
          CASE
              WHEN REGEXP_LIKE(COALESCE(TO_CHAR(C.PAY_PERIOD), TO_CHAR(T.PAY_PERIOD)), '^[0-9]+$')
              THEN TO_NUMBER(COALESCE(TO_CHAR(C.PAY_PERIOD), TO_CHAR(T.PAY_PERIOD)))
          END                                                          AS PAY_PERIOD,
          NVL(T.INSUR_AMT, 0)                                           AS INSUR_AMT,
          T.CUST_ID || '|' || T.ACCT_ID || '|' || T.PRDKT_ID || '|' ||
          T.INSUR_BID_FORM_NO                                          AS POLICY_KEY,
          ROW_NUMBER() OVER (
              PARTITION BY T.CUST_ID, T.ACCT_ID, T.PRDKT_ID, T.INSUR_BID_FORM_NO
              ORDER BY
                  CASE
                      WHEN T.TX_DATE IS NOT NULL
                       AND REGEXP_LIKE(REPLACE(SUBSTR(T.TX_DATE, 1, 10), '-', ''), '^[0-9]{8}$')
                      THEN TO_DATE(REPLACE(SUBSTR(T.TX_DATE, 1, 10), '-', ''), 'YYYYMMDD')
                  END,
                  T.TX_TYP,
                  NVL(T.INSUR_AMT, 0)
          )                                                            AS TX_SEQ
      FROM (
          SELECT
              H.CUST_ID,
              H.ACCT_ID,
              H.PRDKT_ID,
              H.PRDKT_CATE_BIG,
              H.INSUR_BID_FORM_NO,
              H.TX_TYP,
              H.TX_DATE,
              H.BGN_INSUR_DATE,
              H.CANCL_INSUR_DATE,
              H.PAY_PATRN,
              H.PAY_PERIOD_TYP,
              H.PAY_PERIOD,
              H.INSUR_AMT
          FROM DWD_ACCT_INSUR_HIS H
          WHERE H.DATA_DATE <= V_DATA_DATE
            AND H.CUST_ID IS NOT NULL
            AND H.ACCT_ID IS NOT NULL
            AND H.PRDKT_ID IS NOT NULL
            AND H.INSUR_BID_FORM_NO IS NOT NULL
          GROUP BY
              H.CUST_ID,
              H.ACCT_ID,
              H.PRDKT_ID,
              H.PRDKT_CATE_BIG,
              H.INSUR_BID_FORM_NO,
              H.TX_TYP,
              H.TX_DATE,
              H.BGN_INSUR_DATE,
              H.CANCL_INSUR_DATE,
              H.PAY_PATRN,
              H.PAY_PERIOD_TYP,
              H.PAY_PERIOD,
              H.INSUR_AMT
      ) T
      LEFT JOIN (
          SELECT
              C1.CUST_ID,
              C1.ACCT_ID,
              C1.PRDKT_ID,
              C1.PRDKT_CATE_BIG,
              C1.INSUR_BID_FORM_NO,
              C1.BGN_INSUR_DATE,
              C1.CANCL_INSUR_DATE,
              C1.PAY_UPTO_DATE,
              C1.PAY_PATRN,
              C1.PAY_PERIOD_TYP,
              C1.PAY_PERIOD
          FROM (
              SELECT
                  C0.*,
                  ROW_NUMBER() OVER (
                      PARTITION BY C0.CUST_ID, C0.ACCT_ID, C0.PRDKT_ID, C0.INSUR_BID_FORM_NO
                      ORDER BY C0.TX_DATE DESC, C0.TX_TYP DESC
                  )                                                    AS RN
              FROM DWD_ACCT_INSUR C0
              WHERE C0.CUST_ID IS NOT NULL
                AND C0.ACCT_ID IS NOT NULL
                AND C0.PRDKT_ID IS NOT NULL
                AND C0.INSUR_BID_FORM_NO IS NOT NULL
          ) C1
          WHERE C1.RN = 1
      ) C
        ON T.CUST_ID = C.CUST_ID
       AND T.ACCT_ID = C.ACCT_ID
       AND T.PRDKT_ID = C.PRDKT_ID
       AND T.INSUR_BID_FORM_NO = C.INSUR_BID_FORM_NO
      WHERE T.CUST_ID IS NOT NULL
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
  -- 作用：按保单分组键汇总首期承保日期、缴费截止日期、缴费方式、缴费期间、首期保费等基础信息。
  --***************************************
  V_NO_ID := '3';
  V_BGN_DATE := SYSDATE;

  INSERT INTO TMP_DWS_CUST_ASSE_LIAB_POLICY_BASE (
      CUST_ID,
      ACCT_ID,
      PRDKT_ID,
      PRDKT_CATE_BIG,
      INSUR_BID_FORM_NO,
      POLICY_KEY,
      FIRST_TX_DT,
      BGN_DT,
      CANCL_DT,
      PAY_UPTO_DT,
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
      MAX(T.CANCL_DT)                                                  AS CANCL_DT,          -- 退保或终止日期
      MAX(T.PAY_UPTO_DT)                                               AS PAY_UPTO_DT,       -- 缴费截止日期
      MAX(T.PAY_PATRN)                                                 AS PAY_PATRN,         -- 最新缴费方式
      MAX(T.PAY_PERIOD_TYP)                                            AS PAY_PERIOD_TYP,    -- 最新缴费期间类型
      MAX(T.PAY_PERIOD)                                                AS PAY_PERIOD,        -- 最新缴费期间值
      MAX(CASE WHEN T.TX_TYP = '0' THEN T.INSUR_AMT END)               AS FIRST_INSUR_AMT    -- 首期保费金额
  FROM TMP_DWS_CUST_ASSE_LIAB_INSUR_TX T
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
  -- 作用：识别截至加工日最后一笔撤单、退保、满期、理赔终止、终止撤销等状态交易。
  --***************************************
  V_NO_ID := '4';
  V_BGN_DATE := SYSDATE;

  INSERT INTO TMP_DWS_CUST_ASSE_LIAB_LAST_STATUS (
      POLICY_KEY,
      LAST_STATUS_TX_TYP,
      LAST_STATUS_DT
  )
  SELECT
      X.POLICY_KEY                                                     AS POLICY_KEY,         -- 保单分组键
      X.LAST_STATUS_TX_TYP                                             AS LAST_STATUS_TX_TYP, -- 最后状态交易类型
      X.LAST_STATUS_DT                                                 AS LAST_STATUS_DT      -- 最后状态交易日期
  FROM (
      SELECT
          T.POLICY_KEY                                                 AS POLICY_KEY,
          T.TX_TYP                                                     AS LAST_STATUS_TX_TYP,
          T.TX_DT                                                      AS LAST_STATUS_DT,
          ROW_NUMBER() OVER (
              PARTITION BY T.POLICY_KEY
              ORDER BY T.TX_DT DESC, T.TX_KEY DESC
          )                                                            AS RN
      FROM TMP_DWS_CUST_ASSE_LIAB_INSUR_TX T
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
  -- 作用：根据新单承保日期和缴费期间类型生成期缴保单各期应缴日期。
  --***************************************
  V_NO_ID := '5';
  V_BGN_DATE := SYSDATE;

  INSERT INTO TMP_DWS_CUST_ASSE_LIAB_PAY_PLAN (
      POLICY_KEY,
      INSUR_BID_FORM_NO,
      PERIOD_NO,
      DUE_DT
  )
  SELECT
      B.POLICY_KEY                                                     AS POLICY_KEY,        -- 保单分组键
      B.INSUR_BID_FORM_NO                                              AS INSUR_BID_FORM_NO, -- 投保单号
      LEVEL                                                            AS PERIOD_NO,         -- 应缴期数
      CASE
          WHEN B.PAY_PERIOD_TYP = '12' THEN ADD_MONTHS(B.FIRST_TX_DT, (LEVEL - 1) * 12)
          WHEN B.PAY_PERIOD_TYP = '1'  THEN ADD_MONTHS(B.FIRST_TX_DT, LEVEL - 1)
          WHEN B.PAY_PERIOD_TYP = '2'  THEN B.FIRST_TX_DT + LEVEL - 1
          WHEN B.PAY_PERIOD_TYP IN ('0', '-1') THEN B.FIRST_TX_DT
      END                                                              AS DUE_DT             -- 本期应缴日期
  FROM TMP_DWS_CUST_ASSE_LIAB_POLICY_BASE B
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
  -- 作用：把新单承保和续期缴费交易按保单内日期顺序编号，用于与应缴计划逐期匹配。
  --***************************************
  V_NO_ID := '6';
  V_BGN_DATE := SYSDATE;

  INSERT INTO TMP_DWS_CUST_ASSE_LIAB_PAY_TX (
      POLICY_KEY,
      PAY_TX_KEY,
      TX_DT,
      INSUR_AMT,
      PAY_SEQ
  )
  SELECT
      T.POLICY_KEY                                                     AS POLICY_KEY, -- 保单分组键
      T.TX_KEY                                                         AS PAY_TX_KEY, -- 缴费交易排查键
      T.TX_DT                                                          AS TX_DT,      -- 缴费交易日期
      T.INSUR_AMT                                                      AS INSUR_AMT,  -- 缴费金额
      ROW_NUMBER() OVER (
          PARTITION BY T.POLICY_KEY
          ORDER BY T.TX_DT, T.TX_TYP, T.TX_KEY
      )                                                                AS PAY_SEQ     -- 缴费交易序号
  FROM TMP_DWS_CUST_ASSE_LIAB_INSUR_TX T
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
  -- 作用：按保单内期数把每期应缴计划与已发生缴费交易匹配，支持提前缴费识别。
  --***************************************
  V_NO_ID := '7';
  V_BGN_DATE := SYSDATE;

  INSERT INTO TMP_DWS_CUST_ASSE_LIAB_PLAN_MATCH (
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
      PT.PAY_TX_KEY                                                    AS PAY_TX_KEY,        -- 匹配缴费交易排查键
      PT.TX_DT                                                         AS PAID_DT,           -- 匹配缴费日期
      PT.INSUR_AMT                                                     AS PAID_AMT           -- 匹配缴费金额
  FROM TMP_DWS_CUST_ASSE_LIAB_PAY_PLAN PP
  LEFT JOIN TMP_DWS_CUST_ASSE_LIAB_PAY_TX PT
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
  -- 作用：取加工日之前最近一期应缴计划，判断当前期是否已缴、是否仍在60天宽限期内。
  --***************************************
  V_NO_ID := '8';
  V_BGN_DATE := SYSDATE;

  INSERT INTO TMP_DWS_CUST_ASSE_LIAB_CURR_PERIOD (
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
      X.PAY_TX_KEY                                                     AS PAY_TX_KEY,        -- 当前期缴费交易排查键
      X.PAID_DT                                                        AS PAID_DT,           -- 当前期缴费日期
      X.PAID_AMT                                                       AS PAID_AMT           -- 当前期缴费金额
  FROM (
      SELECT
          M.POLICY_KEY,
          M.INSUR_BID_FORM_NO,
          M.PERIOD_NO,
          M.DUE_DT,
          M.PAY_TX_KEY,
          M.PAID_DT,
          M.PAID_AMT,
          ROW_NUMBER() OVER (
              PARTITION BY M.POLICY_KEY
              ORDER BY M.DUE_DT DESC, M.PERIOD_NO DESC
          )                                                            AS RN
      FROM TMP_DWS_CUST_ASSE_LIAB_PLAN_MATCH M
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
  -- 作用：取截至加工日最近一次已缴金额，当前期未缴但仍在宽限期内时用于余额沿用。
  --***************************************
  V_NO_ID := '9';
  V_BGN_DATE := SYSDATE;

  INSERT INTO TMP_DWS_CUST_ASSE_LIAB_LAST_PAID (
      POLICY_KEY,
      LAST_PAID_AMT
  )
  SELECT
      X.POLICY_KEY                                                     AS POLICY_KEY,    -- 保单分组键
      X.LAST_PAID_AMT                                                  AS LAST_PAID_AMT  -- 最近有效缴费金额
  FROM (
      SELECT
          M.POLICY_KEY                                                 AS POLICY_KEY,
          M.PAID_AMT                                                   AS LAST_PAID_AMT,
          ROW_NUMBER() OVER (
              PARTITION BY M.POLICY_KEY
              ORDER BY M.PERIOD_NO DESC
          )                                                            AS RN
      FROM TMP_DWS_CUST_ASSE_LIAB_PLAN_MATCH M
      WHERE M.PAID_DT IS NOT NULL
        AND M.PAID_DT <= V_DT
  ) X
  WHERE X.RN = 1;

  COMMIT;

  OUTCDE      := 0;
  V_END_DATE  := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG   := '2.9 生成保险最近有效缴费金额临时表';
  V_LOG_FLG   := OUTCDE;

  SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

  --***************************************
  -- 2.10 生成保险当日余额临时表
  -- 作用：按趸交一年后清零、期缴60天宽限期、最后一期缴清后再过一个缴费期间清零等规则生成保险余额基数。
  --***************************************
  V_NO_ID := '10';
  V_BGN_DATE := SYSDATE;

  INSERT INTO TMP_DWS_CUST_ASSE_LIAB_INSUR_BAL (
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
           AND V_DT < ADD_MONTHS(B.FIRST_TX_DT, 12)
          THEN NVL(B.FIRST_INSUR_AMT, 0)
          WHEN B.PAY_PATRN = '0'
           AND V_DT >= ADD_MONTHS(B.FIRST_TX_DT, 12)
          THEN 0
          WHEN B.PAY_PATRN = '1'
           AND B.PAY_UPTO_DT IS NOT NULL
           AND V_DT >= CASE
                         WHEN B.PAY_PERIOD_TYP = '12' THEN ADD_MONTHS(B.PAY_UPTO_DT, 12)
                         WHEN B.PAY_PERIOD_TYP = '1'  THEN ADD_MONTHS(B.PAY_UPTO_DT, 1)
                         WHEN B.PAY_PERIOD_TYP = '2'  THEN B.PAY_UPTO_DT + 1
                       END
           AND EXISTS (
                 SELECT 1
                 FROM TMP_DWS_CUST_ASSE_LIAB_PLAN_MATCH FM
                 WHERE FM.POLICY_KEY = B.POLICY_KEY
                   AND FM.PAID_DT IS NOT NULL
                   AND FM.PAID_DT <= V_DT
                   AND FM.DUE_DT = (
                       SELECT MAX(FM2.DUE_DT)
                       FROM TMP_DWS_CUST_ASSE_LIAB_PLAN_MATCH FM2
                       WHERE FM2.POLICY_KEY = B.POLICY_KEY
                         AND FM2.DUE_DT <= NVL(B.PAY_UPTO_DT, FM2.DUE_DT)
                   )
             )
          THEN 0
          WHEN B.PAY_PATRN = '1'
           AND CP.PAID_DT IS NOT NULL
          THEN NVL(CP.PAID_AMT, 0)
          WHEN B.PAY_PATRN = '1'
           AND CP.PAID_DT IS NULL
           AND CP.DUE_DT IS NOT NULL
           AND V_DT <= CP.DUE_DT + 60
          THEN NVL(LP.LAST_PAID_AMT, NVL(B.FIRST_INSUR_AMT, 0))
          WHEN B.PAY_PATRN = '1'
           AND CP.PAID_DT IS NULL
           AND CP.DUE_DT IS NOT NULL
           AND V_DT > CP.DUE_DT + 60
          THEN 0
          ELSE 0
      END                                                               AS BAL             -- 保险当日余额基数
  FROM TMP_DWS_CUST_ASSE_LIAB_POLICY_BASE B
  LEFT JOIN TMP_DWS_CUST_ASSE_LIAB_LAST_STATUS LS
    ON B.POLICY_KEY = LS.POLICY_KEY
  LEFT JOIN TMP_DWS_CUST_ASSE_LIAB_CURR_PERIOD CP
    ON B.POLICY_KEY = CP.POLICY_KEY
  LEFT JOIN TMP_DWS_CUST_ASSE_LIAB_LAST_PAID LP
    ON B.POLICY_KEY = LP.POLICY_KEY;

  COMMIT;

  OUTCDE      := 0;
  V_END_DATE  := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG   := '2.10 生成保险当日余额临时表';
  V_LOG_FLG   := OUTCDE;

  SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

  --***************************************
  -- 2.11 生成四类产品当日余额明细临时表
  -- 作用：存款、贷款、理财优先从当前账户表取当日余额，保险取前序规则计算后的余额。
  --***************************************
  V_NO_ID := '11';
  V_BGN_DATE := SYSDATE;

  INSERT INTO TMP_DWS_CUST_ASSE_LIAB_TODAY_BAL (
      DATA_DATE,
      PERSN_LEGAL_BK_CODE,
      OPRT_ORG,
      CUST_ID,
      ACCT_ID,
      PRDKT_ID,
      PRDKT_CATE_BIG,
      BAL,
      PRDKT_TYP
  )
  SELECT
      V_DATA_DATE                                                       AS DATA_DATE,      -- 数据日期
      D.PERSN_LEGAL_BK_CODE                                             AS PERSN_LEGAL_BK_CODE, -- 法人行号
      D.OPEN_ACCT_ORG                                                   AS OPRT_ORG,       -- 归属机构
      D.CUST_ID                                                         AS CUST_ID,        -- 客户号
      D.ACCT_ID                                                         AS ACCT_ID,        -- 账号
      D.PRDKT_ID                                                        AS PRDKT_ID,       -- 产品编号
      COALESCE(D.PRDKT_CATE_BIG, 'DEP')                                 AS PRDKT_CATE_BIG, -- 产品大类
      NVL(D.BAL, 0)                                                     AS BAL,            -- 存款余额
      '1'                                                               AS PRDKT_TYP        -- 产品类型
  FROM DWD_ACCT_DEPO D
  WHERE D.CUST_ID IS NOT NULL
    AND D.ACCT_ID IS NOT NULL

  UNION ALL

  SELECT
      V_DATA_DATE                                                       AS DATA_DATE,      -- 数据日期
      L.PERSN_LEGAL_BK_CODE                                             AS PERSN_LEGAL_BK_CODE, -- 法人行号
      L.OPRT_ORG                                                        AS OPRT_ORG,       -- 经办机构
      L.CUST_ID                                                         AS CUST_ID,        -- 客户号
      L.ACCT_ID                                                         AS ACCT_ID,        -- 账号
      L.PRDKT_ID                                                        AS PRDKT_ID,       -- 产品编号
      COALESCE(L.PRDKT_CATE_BIG, 'LOAN')                                AS PRDKT_CATE_BIG, -- 产品大类
      NVL(L.BAL, 0)                                                     AS BAL,             -- 贷款余额
      '2'                                                               AS PRDKT_TYP        -- 产品类型
  FROM DWD_ACCT_LOAN L
  WHERE L.CUST_ID IS NOT NULL
    AND L.ACCT_ID IS NOT NULL

  UNION ALL

  SELECT
      V_DATA_DATE                                                       AS DATA_DATE,      -- 数据日期
      F.PERSN_LEGAL_BK_CODE                                             AS PERSN_LEGAL_BK_CODE, -- 法人行号
      F.OPRT_ORG                                                        AS OPRT_ORG,       -- 归属机构
      F.CUST_ID                                                         AS CUST_ID,        -- 客户号
      F.ACCT_ID                                                         AS ACCT_ID,        -- 账号
      F.PRDKT_ID                                                        AS PRDKT_ID,       -- 产品编号
      COALESCE(F.PRDKT_CATE_BIG, 'FIN')                                 AS PRDKT_CATE_BIG, -- 产品大类
      NVL(F.FIN_AMT, 0)                                                 AS BAL,            -- 理财余额，已为份额乘净值后的结果值
      '3'                                                               AS PRDKT_TYP        -- 产品类型
  FROM DWD_ACCT_FIN F
  WHERE F.CUST_ID IS NOT NULL
    AND F.ACCT_ID IS NOT NULL

  UNION ALL

  SELECT
      I.DATA_DATE                                                       AS DATA_DATE,      -- 数据日期
      C.PERSN_LEGAL_BK_CODE                                             AS PERSN_LEGAL_BK_CODE, -- 法人行号
      C.MKT_ORG                                                         AS OPRT_ORG,       -- 归属机构
      I.CUST_ID                                                         AS CUST_ID,        -- 客户号
      I.ACCT_ID                                                         AS ACCT_ID,        -- 账号
      I.PRDKT_ID                                                        AS PRDKT_ID,       -- 产品编号
      I.PRDKT_CATE_BIG                                                  AS PRDKT_CATE_BIG, -- 产品大类
      I.BAL                                                             AS BAL,             -- 保险余额
      '4'                                                               AS PRDKT_TYP        -- 产品类型
  FROM TMP_DWS_CUST_ASSE_LIAB_INSUR_BAL I
  LEFT JOIN DWD_ACCT_INSUR C
    ON I.CUST_ID = C.CUST_ID
   AND I.ACCT_ID = C.ACCT_ID
   AND I.PRDKT_ID = C.PRDKT_ID;

  COMMIT;

  OUTCDE      := 0;
  V_END_DATE  := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG   := '2.11 生成四类产品当日余额明细临时表';
  V_LOG_FLG   := OUTCDE;

  SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

  --***************************************
  -- 2.12 生成当日余额聚合临时表
  -- 作用：按客户 + 账户 + 产品 + 产品大类汇总同日余额，避免同一维度多笔明细重复输出。
  --***************************************
  V_NO_ID := '12';
  V_BGN_DATE := SYSDATE;

  INSERT INTO TMP_DWS_CUST_ASSE_LIAB_TODAY_AGG (
      DATA_DATE,
      PERSN_LEGAL_BK_CODE,
      OPRT_ORG,
      CUST_ID,
      ACCT_ID,
      PRDKT_ID,
      PRDKT_CATE_BIG,
      BAL,
      PRDKT_TYP
  )
  SELECT
      T.DATA_DATE                                                       AS DATA_DATE,      -- 数据日期
      T.PERSN_LEGAL_BK_CODE                                             AS PERSN_LEGAL_BK_CODE, -- 法人行号
      T.OPRT_ORG                                                        AS OPRT_ORG,       -- 归属机构
      T.CUST_ID                                                         AS CUST_ID,        -- 客户号
      T.ACCT_ID                                                         AS ACCT_ID,        -- 账号
      T.PRDKT_ID                                                        AS PRDKT_ID,       -- 产品编号
      T.PRDKT_CATE_BIG                                                  AS PRDKT_CATE_BIG, -- 产品大类
      SUM(NVL(T.BAL, 0))                                                AS BAL,            -- 聚合后当日余额
      PRDKT_TYP
  FROM TMP_DWS_CUST_ASSE_LIAB_TODAY_BAL T
  GROUP BY
      T.DATA_DATE,
      T.PERSN_LEGAL_BK_CODE,
      T.OPRT_ORG,
      T.CUST_ID,
      T.ACCT_ID,
      T.PRDKT_ID,
      T.PRDKT_CATE_BIG,
      PRDKT_TYP;

  COMMIT;

  OUTCDE      := 0;
  V_END_DATE  := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG   := '2.12 生成当日余额聚合临时表';
  V_LOG_FLG   := OUTCDE;

  SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

  --***************************************
  -- 2.13 生成结果补零KEY临时表
  -- 作用：合并当日有余额的KEY和年内历史存在的KEY，确保余额清零后的产品仍能输出0并参与累计。
  --***************************************
  V_NO_ID := '13';
  V_BGN_DATE := SYSDATE;

  INSERT INTO TMP_DWS_CUST_ASSE_LIAB_KEY_SET (
      PERSN_LEGAL_BK_CODE,
      OPRT_ORG,
      CUST_ID,
      ACCT_ID,
      PRDKT_ID,
      PRDKT_CATE_BIG,
      PRDKT_TYP
  )
  SELECT
      A.PERSN_LEGAL_BK_CODE                                             AS PERSN_LEGAL_BK_CODE, -- 法人行号
      A.OPRT_ORG                                                        AS OPRT_ORG,       -- 归属机构
      A.CUST_ID                                                         AS CUST_ID,        -- 客户号
      A.ACCT_ID                                                         AS ACCT_ID,        -- 账号
      A.PRDKT_ID                                                        AS PRDKT_ID,       -- 产品编号
      A.PRDKT_CATE_BIG                                                  AS PRDKT_CATE_BIG, -- 产品大类
      A.PRDKT_TYP                                                        AS PRDKT_TYP        -- 产品类型
  FROM TMP_DWS_CUST_ASSE_LIAB_TODAY_AGG A
  UNION
  SELECT
      H.PERSN_LEGAL_BK_CODE                                             AS PERSN_LEGAL_BK_CODE, -- 法人行号
      H.OPRT_ORG                                                        AS OPRT_ORG,       -- 归属机构
      H.CUST_ID                                                         AS CUST_ID,        -- 客户号
      H.ACCT_ID                                                         AS ACCT_ID,        -- 账号
      H.PRDKT_ID                                                        AS PRDKT_ID,       -- 产品编号
      H.PRDKT_CATE_BIG                                                  AS PRDKT_CATE_BIG,  -- 产品大类
      H.PRDKT_TYP                                                        AS PRDKT_TYP        -- 产品类型
  FROM DWS_CUST_ASSE_LIAB_CUMU_HIS H
  WHERE H.DATA_DATE >= V_YAR_BEGIN
    AND H.DATA_DATE <  V_DATA_DATE;

  COMMIT;

  OUTCDE      := 0;
  V_END_DATE  := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG   := '2.13 生成结果补零KEY临时表';
  V_LOG_FLG   := OUTCDE;

  SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

  --***************************************
  -- 2.14 生成历史累计余额临时表
  -- 作用：直接取上一数据日期的月累计、季累计、年累计余额基数，月初/季初/年初分别重置为0。
  --***************************************
  V_NO_ID := '14';
  V_BGN_DATE := SYSDATE;

  INSERT INTO TMP_DWS_CUST_ASSE_LIAB_HIS_AGG (
      PERSN_LEGAL_BK_CODE,
      OPRT_ORG,
      CUST_ID,
      ACCT_ID,
      PRDKT_ID,
      PRDKT_CATE_BIG,
      PRDKT_TYP,
      HIS_MTH_BAL,
      HIS_QRT_BAL,
      HIS_YAR_BAL
  )
  SELECT
      H.PERSN_LEGAL_BK_CODE                                             AS PERSN_LEGAL_BK_CODE, -- 法人行号
      H.OPRT_ORG                                                        AS OPRT_ORG,       -- 归属机构
      H.CUST_ID                                                         AS CUST_ID,        -- 客户号
      H.ACCT_ID                                                         AS ACCT_ID,        -- 账号
      H.PRDKT_ID                                                        AS PRDKT_ID,       -- 产品编号
      H.PRDKT_CATE_BIG                                                  AS PRDKT_CATE_BIG, -- 产品大类
      H.PRDKT_TYP                                                        AS PRDKT_TYP,       -- 产品类型
      CASE WHEN V_DATA_DATE = V_MTH_BEGIN THEN 0 ELSE NVL(H.MTH_BAL, 0) END AS HIS_MTH_BAL, -- 上日月累计余额
      CASE WHEN V_DATA_DATE = V_QRT_BEGIN THEN 0 ELSE NVL(H.QRT_BAL, 0) END AS HIS_QRT_BAL, -- 上日季累计余额
      CASE WHEN V_DATA_DATE = V_YAR_BEGIN THEN 0 ELSE NVL(H.YAR_BAL, 0) END AS HIS_YAR_BAL -- 上日年累计余额
  FROM DWS_CUST_ASSE_LIAB_CUMU_HIS H
  WHERE H.DATA_DATE = V_PRE_DATA_DATE;

  COMMIT;

  OUTCDE      := 0;
  V_END_DATE  := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG   := '2.14 生成历史累计余额临时表';
  V_LOG_FLG   := OUTCDE;

  SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

  --***************************************
  -- 2.15 生成客户资产负债基数当前表
  -- 作用：将当日余额与上一日累计余额合并，生成月/季/年累计余额基数。
  --***************************************
  V_NO_ID := '15';
  V_BGN_DATE := SYSDATE;

  INSERT INTO DWS_CUST_ASSE_LIAB_CUMU (
      DATA_DATE,
      PERSN_LEGAL_BK_CODE,
      OPRT_ORG,
      CUST_ID,
      ACCT_ID,
      PRDKT_ID,
      PRDKT_CATE_BIG,
      PRDKT_TYP,
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
      K.PERSN_LEGAL_BK_CODE                                             AS PERSN_LEGAL_BK_CODE, -- 法人行号
      K.OPRT_ORG                                                        AS OPRT_ORG,       -- 归属机构
      K.CUST_ID                                                         AS CUST_ID,        -- 客户号
      K.ACCT_ID                                                         AS ACCT_ID,        -- 账号
      K.PRDKT_ID                                                        AS PRDKT_ID,       -- 产品编号
      K.PRDKT_CATE_BIG                                                  AS PRDKT_CATE_BIG, -- 产品大类
      K.PRDKT_TYP                                                        AS PRDKT_TYP,       -- 产品类型
      NVL(A.BAL, 0)                                                     AS BAL,            -- 当日余额
      NVL(H.HIS_MTH_BAL, 0) + NVL(A.BAL, 0)                             AS MTH_BAL,        -- 月累计余额
      NVL(H.HIS_QRT_BAL, 0) + NVL(A.BAL, 0)                             AS QRT_BAL,        -- 季累计余额
      NVL(H.HIS_YAR_BAL, 0) + NVL(A.BAL, 0)                             AS YAR_BAL,        -- 年累计余额
      V_MTH_DAYS                                                        AS MTH_DAYS,       -- 月已过天数
      V_QRT_DAYS                                                        AS QRT_DAYS,       -- 季已过天数
      V_YAR_DAYS                                                        AS YAR_DAYS        -- 年已过天数
  FROM TMP_DWS_CUST_ASSE_LIAB_KEY_SET K
  LEFT JOIN TMP_DWS_CUST_ASSE_LIAB_TODAY_AGG A
    ON K.PERSN_LEGAL_BK_CODE = A.PERSN_LEGAL_BK_CODE
   AND K.OPRT_ORG = A.OPRT_ORG
   AND K.CUST_ID = A.CUST_ID
   AND K.ACCT_ID = A.ACCT_ID
   AND K.PRDKT_ID = A.PRDKT_ID
   AND K.PRDKT_CATE_BIG = A.PRDKT_CATE_BIG
   AND K.PRDKT_TYP = A.PRDKT_TYP
  LEFT JOIN TMP_DWS_CUST_ASSE_LIAB_HIS_AGG H
    ON K.PERSN_LEGAL_BK_CODE = H.PERSN_LEGAL_BK_CODE
   AND K.OPRT_ORG = H.OPRT_ORG
   AND K.CUST_ID = H.CUST_ID
   AND K.ACCT_ID = H.ACCT_ID
   AND K.PRDKT_ID = H.PRDKT_ID
   AND K.PRDKT_CATE_BIG = H.PRDKT_CATE_BIG
   AND K.PRDKT_TYP = H.PRDKT_TYP;

  COMMIT;

  OUTCDE      := 0;
  V_END_DATE  := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG   := '2.15 生成客户资产负债基数当前表';
  V_LOG_FLG   := OUTCDE;

  SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

  --***************************************
  -- 2.16 写入客户资产负债基数历史表
  -- 作用：把当日当前表结果同步写入历史表，供后续日期直接取上一日累计余额。
  --***************************************
  V_NO_ID := '16';
  V_BGN_DATE := SYSDATE;

  INSERT INTO DWS_CUST_ASSE_LIAB_CUMU_HIS (
      DATA_DATE,
      PERSN_LEGAL_BK_CODE,
      OPRT_ORG,
      CUST_ID,
      ACCT_ID,
      PRDKT_ID,
      PRDKT_CATE_BIG,
      PRDKT_TYP,
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
      C.PERSN_LEGAL_BK_CODE                                             AS PERSN_LEGAL_BK_CODE, -- 法人行号
      C.OPRT_ORG                                                        AS OPRT_ORG,       -- 归属机构
      C.CUST_ID                                                         AS CUST_ID,        -- 客户号
      C.ACCT_ID                                                         AS ACCT_ID,        -- 账号
      C.PRDKT_ID                                                        AS PRDKT_ID,       -- 产品编号
      C.PRDKT_CATE_BIG                                                  AS PRDKT_CATE_BIG, -- 产品大类
      C.PRDKT_TYP                                                        AS PRDKT_TYP,       -- 产品类型      
      C.BAL                                                             AS BAL,            -- 当日余额
      C.MTH_BAL                                                         AS MTH_BAL,        -- 月累计余额
      C.QRT_BAL                                                         AS QRT_BAL,        -- 季累计余额
      C.YAR_BAL                                                         AS YAR_BAL,        -- 年累计余额
      C.MTH_DAYS                                                        AS MTH_DAYS,       -- 月已过天数
      C.QRT_DAYS                                                        AS QRT_DAYS,       -- 季已过天数
      C.YAR_DAYS                                                        AS YAR_DAYS        -- 年已过天数
  FROM DWS_CUST_ASSE_LIAB_CUMU C
  WHERE C.DATA_DATE = V_DATA_DATE;

  COMMIT;

  OUTCDE      := 0;
  V_END_DATE  := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG   := '2.16 写入客户资产负债基数历史表';
  V_LOG_FLG   := OUTCDE;

  SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

  OUTCDE := 0;

  --***************************************
  -- 3.异常处理区
  --***************************************
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
