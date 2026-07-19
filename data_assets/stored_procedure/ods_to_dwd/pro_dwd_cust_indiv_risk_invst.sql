CREATE OR REPLACE PROCEDURE pro_dwd_cust_indiv_risk_invst(
    V_SYSDAT IN VARCHAR,
    OUTCDE   OUT INTEGER
)
AS
  V_PRC_DESC             VARCHAR(100) := '客户风险评估';
  V_PRC_NAME             VARCHAR(32)  := 'pro_dwd_cust_indiv_risk_invst';
  V_LOG_MSG              VARCHAR(4000);
  V_LOG_FLG              INTEGER;
  V_LOG_BUTTON           INTEGER := 1;
  V_NO_ID                VARCHAR(10);
  V_BGN_DATE             DATE;
  V_END_DATE             DATE;
  V_DURA_DATE            INTEGER;
BEGIN
  IF V_SYSDAT IS NULL
     OR NOT V_SYSDAT ~ '^[0-9]{8}$'
  THEN
    RAISE EXCEPTION 'V_SYSDAT must be in YYYYMMDD format';
  END IF;

  V_END_DATE := TO_DATE(V_SYSDAT, 'YYYYMMDD');

  DELETE FROM DWD_CUST_INDIV_RISK_INVST;
  COMMIT;

  V_NO_ID := '1';
  V_BGN_DATE := NOW();
  V_END_DATE := NOW();
  V_DURA_DATE := EXTRACT(EPOCH FROM (V_END_DATE - V_BGN_DATE))::INTEGER;
  OUTCDE := 0;
  V_LOG_MSG := '清理目标表完成';
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

  V_NO_ID := '2';
  V_BGN_DATE := NOW();

  INSERT INTO DWD_CUST_INDIV_RISK_INVST (
      CUST_ID,
      FIN_INVEST_TYP,
      FIN_ESTIM_RSLT,
      FIN_SCORE,
      FIN_RISK_LVL,
      FIN_ESTIM_DATE,
      FIN_EXPR_DATE,
      INS_INVEST_TYP,
      INS_ESTIM_RSLT,
      INS_SCORE,
      INS_RISK_LVL,
      INS_ESTIM_DATE,
      INS_EXPR_DATE,
      PERSN_LEGAL_BK_CODE
  )
  SELECT 
      COALESCE(f.host_cust_no, i.host_cust_no) AS CUST_ID,
      f.invest_typ AS FIN_INVEST_TYP,
      f.cust_risk_level AS FIN_ESTIM_RSLT,
      f.cust_eval_level AS FIN_SCORE,
      f.cust_risk_level AS FIN_RISK_LVL,
      f.assess_date AS FIN_ESTIM_DATE,
      f.invalid_date AS FIN_EXPR_DATE,
      i.invest_typ AS INS_INVEST_TYP,
      i.cust_risk_level AS INS_ESTIM_RSLT,
      i.cust_eval_level AS INS_SCORE,
      i.cust_risk_level AS INS_RISK_LVL,
      i.assess_date AS INS_ESTIM_DATE,
      i.invalid_date AS INS_EXPR_DATE,
      COALESCE(f.persn_legal_bk_code, i.persn_legal_bk_code) AS PERSN_LEGAL_BK_CODE
  FROM mbk_cust_risk_invst f
  FULL JOIN mbk_cust_risk_invst_ins i ON f.host_cust_no = i.host_cust_no;

  COMMIT;

  V_END_DATE := NOW();
  V_DURA_DATE := EXTRACT(EPOCH FROM (V_END_DATE - V_BGN_DATE))::INTEGER;
  OUTCDE := 0;
  V_LOG_MSG := '第2个业务处理段完成，插入记录数: ' || SQL%ROWCOUNT;
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

EXCEPTION
  WHEN OTHERS THEN
    OUTCDE := -1;
    ROLLBACK;

    V_END_DATE := NOW();
    V_DURA_DATE := CASE
                     WHEN V_BGN_DATE IS NULL OR V_END_DATE IS NULL THEN NULL
                     ELSE EXTRACT(EPOCH FROM (V_END_DATE - V_BGN_DATE))::INTEGER
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