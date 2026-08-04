CREATE OR REPLACE PROCEDURE PRC_DWS_CUST_ASSE_LIAB_CUMU(
    V_SYSDAT IN VARCHAR,
    OUTCDE   OUT INTEGER
)
AS
  ------------------------------------------------------------------
  -- 报表名称：客户资产负债基数处理
  -- 报表编号：PRC_CUST_ASSE_LIAB_CUMU
  -- 处理周期：日
  -- 过程描述：按客户 + 账户 + 产品 + 日期生成存款、贷款、理财、保险余额基数及月/季/年累计余额基数。
  -- 来源表：DWD_ACCT_DEPO、DWD_ACCT_LOAN、DWD_ACCT_FIN、DWD_ACCT_INSUR(保单级主档)、DWS_CUST_ASSE_LIAB_CUMU_HIS
  -- 目标表：DWS_CUST_ASSE_LIAB_CUMU、DWS_CUST_ASSE_LIAB_CUMU_HIS
  -- 适配数据库：Oracle 兼容模式 / Kingbase Oracle 兼容模式
  -- 变更记录:
  --   v2.1.0 2026-08-03 适配DWD_ACCT_INSUR v1.1.0（TX_TYP置空等，已被v3.0.0取代）
  --   v3.0.0 2026-08-03 保单级主档重构：不再依赖HIS与交易类型；
  --                     状态判定完全基于DWD_ACCT_INSUR.POLICY_STATE(0/1/2)；
  --                     直接聚合INSUR_AMT生成保险余额，删除2.3-2.10中间段
  ------------------------------------------------------------------
  ------------------------------------------------------------------
  --***************************************
  --1.自定义参数区
  --***************************************
  V_PRC_DESC             VARCHAR(100) := '客户资产负债基数处理';
  V_PRC_NAME             VARCHAR(32)  := 'PRC_DWS_CUST_ASSE_LIAB_CUMU';
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
  V_MTH_BEGIN            VARCHAR(8);  -- 当月初（参数9，sys_fun_deal_date）
  V_QRT_BEGIN            VARCHAR(8);  -- 当季初（参数11，sys_fun_deal_date）
  V_YAR_BEGIN            VARCHAR(8);  -- 当年初（参数13，sys_fun_deal_date）
  V_PRE_DATA_DATE        VARCHAR(8);  -- 上一日（参数1，sys_fun_deal_date）
  V_MTH_DAYS             NUMBER(10);
  V_QRT_DAYS             NUMBER(10);
  V_YAR_DAYS             NUMBER(10);
BEGIN
  --***************************************
  -- 2.业务逻辑区
  --***************************************
  V_DATA_DATE := V_SYSDAT;
  V_DT := TO_DATE(V_DATA_DATE, 'YYYYMMDD');
  V_PRE_DATA_DATE := sys_fun_deal_date(V_SYSDAT, 1);   -- 上一日（参数1）
  V_MTH_BEGIN := sys_fun_deal_date(V_SYSDAT, 9);       -- 当月初（参数9）
  V_QRT_BEGIN := sys_fun_deal_date(V_SYSDAT, 11);      -- 当季初（参数11）
  V_YAR_BEGIN := sys_fun_deal_date(V_SYSDAT, 13);      -- 当年初（参数13）
  V_MTH_DAYS := V_DT - TO_DATE(V_MTH_BEGIN, 'YYYYMMDD') + 1;   -- 月已过天数（记录日期运算）
  V_QRT_DAYS := V_DT - TO_DATE(V_QRT_BEGIN, 'YYYYMMDD') + 1;   -- 季已过天数（记录日期运算）
  V_YAR_DAYS := V_DT - TO_DATE(V_YAR_BEGIN, 'YYYYMMDD') + 1;   -- 年已过天数（记录日期运算）
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
  -- 2.2 生成保险当日余额临时表
  -- 作用：v3.0 起直接读取 DWD_ACCT_INSUR 保单级主档；状态判定完全基于 POLICY_STATE，
  --       余额直接取 INSUR_AMT（DWD 已按终止/缴费期满/宽限期规则清零），不再依赖 HIS 与交易类型。
  --***************************************
  V_NO_ID := '2';
  V_BGN_DATE := SYSDATE;

  INSERT INTO TMP_DWS_CUST_ASSE_LIAB_INSUR_BAL (
      DATA_DATE,
      CUST_ID,
      ACCT_ID,
      PRDKT_ID,
      PRDKT_CATE_BIG,
      BAL,
      PERSN_LEGAL_BK_CODE,
      OPRT_ORG
  )
  SELECT
      V_DATA_DATE                                                       AS DATA_DATE,      -- 数据日期
      I.CUST_ID                                                         AS CUST_ID,        -- 客户号
      I.ACCT_ID                                                         AS ACCT_ID,        -- 账号
      I.PRDKT_ID                                                        AS PRDKT_ID,       -- 产品编号
      I.PRDKT_CATE_BIG                                                  AS PRDKT_CATE_BIG, -- 产品大类
      SUM(NVL(I.INSUR_AMT, 0))                                          AS BAL,            -- 保险当日余额(仅有效保单)
      MAX(I.PERSN_LEGAL_BK_CODE)                                        AS PERSN_LEGAL_BK_CODE, -- 法人行号(组内取最大值)
      MAX(I.MKT_ORG)                                                    AS OPRT_ORG        -- 归属机构(同上)
  FROM DWD_ACCT_INSUR I
  WHERE I.POLICY_STATE = '1'          -- 唯一状态判定源：仅正常保单参与(0/2余额已为0)
  GROUP BY
      I.CUST_ID,
      I.ACCT_ID,
      I.PRDKT_ID,
      I.PRDKT_CATE_BIG;

  COMMIT;

  OUTCDE      := 0;
  V_END_DATE  := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG   := '2.2 生成保险当日余额临时表';
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
      I.PERSN_LEGAL_BK_CODE                                             AS PERSN_LEGAL_BK_CODE, -- 法人行号
      I.OPRT_ORG                                                        AS OPRT_ORG,       -- 归属机构
      I.CUST_ID                                                         AS CUST_ID,        -- 客户号
      I.ACCT_ID                                                         AS ACCT_ID,        -- 账号
      I.PRDKT_ID                                                        AS PRDKT_ID,       -- 产品编号
      I.PRDKT_CATE_BIG                                                  AS PRDKT_CATE_BIG, -- 产品大类
      I.BAL                                                             AS BAL,             -- 保险余额
      '4'                                                               AS PRDKT_TYP        -- 产品类型
  FROM TMP_DWS_CUST_ASSE_LIAB_INSUR_BAL I;

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
