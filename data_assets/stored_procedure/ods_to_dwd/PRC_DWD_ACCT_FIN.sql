CREATE OR REPLACE PROCEDURE PRC_DWD_ACCT_FIN(
    V_SYSDAT IN VARCHAR,
    OUTCDE   OUT INTEGER
)
AS
  ------------------------------------------------------------------
  -- 报表名称: 理财账户
  -- 报表编号: PRC_DWD_ACCT_FIN
  -- 处理周期: 日
  -- 过程描述: 理财账户生成逻辑
  -- 来源表:
  --   2.1: FMS_T1_CUST_INFO, FMS_T1_CUST_FNC_ACCT, FMS_TD_CUST_VOL,
  --        FMS_TD_PROD_INFO, FMS_TD_PROD_NAV
  --   2.2: FMS_T1_CUST_INFO, FMS_T1_CUST_FNC_ACCT, FMS_T5_CUST_VOL,
  --        FMS_T5_PROD_INFO, FMS_T5_PROD_NAV, FMS_T5_PROD_PERIOD
  -- 目标表: DWD_ACCT_FIN
  -- date   : 2026-07-10
  ------------------------------------------------------------------
  V_PRC_DESC             VARCHAR(100) := '理财账户处理';
  V_PRC_NAME             VARCHAR(32)  := 'PRC_DWD_ACCT_FIN';
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
BEGIN
  --***************************************
  -- 2. 业务逻辑区
  --***************************************
  V_START_DT := SYSDATE;
  V_SYSDAT2 := TO_CHAR(TO_DATE(V_SYSDAT, 'yyyymmdd'), 'yyyy-mm-dd');
  P_INTERVAL_START_DATE := TO_CHAR(TO_DATE(V_SYSDAT, 'yyyymmdd') - 30, 'yyyymmdd');
  P_INTERVAL_END_DATE   := V_SYSDAT;

  --***************************************
  -- 2.1 代销理财账户落库
  --***************************************
  V_NO_ID := '1';
  V_BGN_DATE := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE DWD_ACCT_FIN';

  INSERT INTO DWD_ACCT_FIN (
      CUST_ID,
      CUST_TYP,
      ACCT_ID,
      CARD_NO,
      PRDKT_ID,
      PRDKT_NAME,
      PRDKT_CATE_BIG,
      ESTAB_DATE,
      FIN_AMT,
      RATE_INTRI,
      ACCT_STATE,
      INTRI_BGN_DATE,
      EXPR_DATE,
      OPRT_ORG,
      CHNL_NO,
      PERSN_LEGAL_BK_CODE,
      ISSU_ORG,
      ISSU_DATE,
      RISK_LVL
  )
  SELECT
      ci.HOST_CUST_NO                        AS CUST_ID,              -- 核心客户号
      '1'                                    AS CUST_TYP,             -- 客户类型
      fa.ACCT_NO                             AS ACCT_ID,              -- 理财账户
      fa.CARD_NO                             AS CARD_NO,              -- 卡折号
      pi.REGIST_CODE                         AS PRDKT_ID,             -- 理财产品编号
      pi.PROD_NAME                           AS PRDKT_NAME,           -- 理财产品名称
      case when pi.PROD_TYPE in ('2','3') 
           then '1' else '2' end             AS PRDKT_CATE_BIG,       -- 理财产品大类 1代销-开放 2代销-封闭  3自营-开放 4自营-封闭
      pi.ESTABLISH_DATE                      AS ESTAB_DATE,           -- 理财产品成立日
      NVL(pn.NAV, 0) * NVL(cv.TOTAL_VOL, 0)  AS FIN_AMT,              -- 理财余额=净值*份额
      pn.TONOWCLIENTRATIO                    AS RATE_INTRI,           -- 成立以来参考年化收益率
      fa.ACCT_STATUS                         AS ACCT_STATE,           -- 理财账户状态
      pi.VALUE_DATE                          AS INTRI_BGN_DATE,       -- 起息日期
      pi.WINDING_DATE                        AS EXPR_DATE,            -- 到期日期
      pi.TANO                                AS OPRT_ORG,             -- 理财归属机构
      fa.ISS_BANK_CODE                       AS CHNL_NO,              -- 办理渠道
      NULL                                   AS PERSN_LEGAL_BK_CODE,  -- 法人行号
      pi.TANO                                AS ISSU_ORG,             -- 发行机构
      fa.CRT_DATE                            AS ISSU_DATE,            -- 办理日期
      pi.PROD_RISK_LEVEL                     AS RISK_LVL              -- 风险等级
    FROM FMS_TD_CUST_VOL cv                                          -- 理财客户份额表
    INNER JOIN FMS_T1_CUST_FNC_ACCT fa                               -- 客户理财交易账号表
      ON fa.CUST_NO           = cv.CUST_NO
     AND fa.FNC_TRANS_ACCT_NO = cv.FNC_TRANS_ACCT_NO
    INNER JOIN FMS_T1_CUST_INFO ci                                   -- 客户信息表
      ON ci.CUST_NO = fa.CUST_NO
    INNER JOIN FMS_TD_PROD_INFO pi                                   -- 理财产品信息表
      ON cv.TANO                   = pi.TANO
     AND cv.PROD_CODE              = pi.PROD_CODE
     AND NVL(cv.SHARE_CLASS, '~')  = NVL(pi.SHARE_CLASS, '~')
    INNER JOIN (
        SELECT
            x.TANO,
            x.PROD_CODE,
            x.SHARE_CLASS,
            x.NAV,
            x.TONOWCLIENTRATIO,
            ROW_NUMBER() OVER (
                PARTITION BY x.TANO, x.PROD_CODE, x.SHARE_CLASS
                ORDER BY x.NAV_DATE DESC
            ) AS RN
        FROM FMS_TD_PROD_NAV x                                       -- 理财产品行情表
       WHERE x.NET_VALUE_TYPE = '0'
    ) pn
      ON cv.TANO                   = pn.TANO
     AND cv.PROD_CODE              = pn.PROD_CODE
     AND NVL(cv.SHARE_CLASS, '~')  = NVL(pn.SHARE_CLASS, '~')
     AND pn.RN = 1
   WHERE NVL(cv.TOTAL_VOL, 0) <> 0;
  COMMIT;

  OUTCDE      := 0;
  V_END_DATE  := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG   := '2.1 代销理财账户落库';
  V_LOG_FLG   := OUTCDE;

  SYS_PRC_STEP_LOGS(
      V_SYSDAT,
      V_PRC_NAME,
      V_PRC_DESC,
      V_NO_ID,
      V_BGN_DATE,
      V_END_DATE,
      V_DURA_DATE,
      V_LOG_MSG,
      V_LOG_FLG,
      V_LOG_BUTTON
  );

  --***************************************
  -- 2.2 自营理财账户落库
  --***************************************
  V_NO_ID := '2';
  V_BGN_DATE := SYSDATE;

  INSERT INTO DWD_ACCT_FIN (
      CUST_ID,
      CUST_TYP,
      ACCT_ID,
      CARD_NO,
      PRDKT_ID,
      PRDKT_NAME,
      PRDKT_CATE_BIG,
      ESTAB_DATE,
      FIN_AMT,
      RATE_INTRI,
      ACCT_STATE,
      INTRI_BGN_DATE,
      EXPR_DATE,
      OPRT_ORG,
      CHNL_NO,
      PERSN_LEGAL_BK_CODE,
      ISSU_ORG,
      ISSU_DATE,
      RISK_LVL
  )
  SELECT
      ci.HOST_CUST_NO                        AS CUST_ID,              -- 核心客户号
      '1'                                    AS CUST_TYP,             -- 客户类型
      fa.ACCT_NO                             AS ACCT_ID,              -- 理财账户
      fa.CARD_NO                             AS CARD_NO,              -- 卡折号
      pi.REGIST_CODE                         AS PRDKT_ID,             -- 理财产品编号
      pi.PROD_NAME                           AS PRDKT_NAME,           -- 理财产品名称
      case when pi.PERIOD_TYPE = '0' 
           then '3' else '4' end             AS PRDKT_CATE_BIG,       -- 理财产品大类 1代销-开放 2代销-封闭  3自营-开放 4自营-封闭
      pp.ESTABLISH_DATE                      AS ESTAB_DATE,           -- 理财产品成立日
      NVL(pn.NAV, 0) * NVL(cv.TOTAL_VOL, 0)  AS FIN_AMT,              -- 理财余额=净值*份额
      pn.SEVEN_DAYS_INCOME                   AS RATE_INTRI,           -- 7日年化收益率
      fa.ACCT_STATUS                         AS ACCT_STATE,           -- 理财账户状态
      pp.VALUE_DATE                          AS INTRI_BGN_DATE,       -- 起息日期
      pp.WINDING_DATE                        AS EXPR_DATE,            -- 到期日期
      fa.SUB_BRANCH_CODE                     AS OPRT_ORG,             -- 理财归属机构
      fa.TRADINGMETHOD                       AS CHNL_NO,              -- 办理渠道
      NULL                                   AS PERSN_LEGAL_BK_CODE,  -- 法人行号
      pi.ORGNO                               AS ISSU_ORG,             -- 发行机构
      fa.CRT_DATE                            AS ISSU_DATE,            -- 办理日期
      pi.PROD_RISK_LEVEL                     AS RISK_LVL              -- 风险等级
    FROM FMS_T5_CUST_VOL cv                                          -- 客户份额汇总表
    INNER JOIN FMS_T1_CUST_FNC_ACCT fa                               -- 客户理财交易账号表
      ON fa.CUST_NO           = cv.CUST_NO
     AND fa.FNC_TRANS_ACCT_NO = cv.FNC_TRANS_ACCT_NO
    INNER JOIN FMS_T1_CUST_INFO ci                                   -- 客户信息表
      ON ci.CUST_NO = fa.CUST_NO
    INNER JOIN (
        SELECT
            x.PROD_CODE,
            x.REGIST_CODE,
            x.PROD_NAME,
            x.PERIOD_TYPE,
            x.ORGNO,
            x.PROD_RISK_LEVEL,
            ROW_NUMBER() OVER (
                PARTITION BY x.PROD_CODE
                ORDER BY NVL(x.UPDATE_PROD_DATE, '00000000') DESC,
                         NVL(x.UPDATE_PROD_TIME, '000000') DESC,
                         NVL(x.NAV_DATE, '00000000') DESC
            ) AS RN
        FROM FMS_T5_PROD_INFO x                                      -- 产品信息表
    ) pi
      ON cv.PROD_CODE = pi.PROD_CODE
     AND pi.RN = 1
    INNER JOIN (
        SELECT
            x.PROD_CODE,
            x.ESTABLISH_DATE,
            x.VALUE_DATE,
            x.WINDING_DATE,
            ROW_NUMBER() OVER (
                PARTITION BY x.PROD_CODE
                ORDER BY x.ESTABLISH_DATE DESC
            ) AS RN
        FROM FMS_T5_PROD_PERIOD x                                    -- 产品周期信息表
    ) pp
      ON pi.PROD_CODE = pp.PROD_CODE
     AND pp.RN = 1
    INNER JOIN (
        SELECT
            x.PROD_CODE,
            x.NAV,
            x.SEVEN_DAYS_INCOME,
            ROW_NUMBER() OVER (
                PARTITION BY x.PROD_CODE
                ORDER BY x.NAV_DATE DESC
            ) AS RN
        FROM FMS_T5_PROD_NAV x                                       -- 产品净值信息表
    ) pn
      ON pi.PROD_CODE = pn.PROD_CODE
     AND pn.RN = 1
   WHERE NVL(cv.TOTAL_VOL, 0) <> 0;
  COMMIT;

  OUTCDE      := 0;
  V_END_DATE  := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG   := '2.2 自营理财账户落库';
  V_LOG_FLG   := OUTCDE;

  SYS_PRC_STEP_LOGS(
      V_SYSDAT,
      V_PRC_NAME,
      V_PRC_DESC,
      V_NO_ID,
      V_BGN_DATE,
      V_END_DATE,
      V_DURA_DATE,
      V_LOG_MSG,
      V_LOG_FLG,
      V_LOG_BUTTON
  );

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
    SYS_PRC_STEP_LOGS(
        V_SYSDAT,
        V_PRC_NAME,
        V_PRC_DESC,
        V_NO_ID,
        V_BGN_DATE,
        V_END_DATE,
        V_DURA_DATE,
        V_LOG_MSG,
        V_LOG_FLG,
        V_LOG_BUTTON
    );
    RAISE;
END;
/
