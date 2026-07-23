CREATE OR REPLACE PROCEDURE PRC_DWD_CUST_INDIV_RISK_INVST(
    V_SYSDAT IN VARCHAR,
    OUTCDE   OUT INTEGER
)
AS
  ------------------------------------------------------------------
  -- \uFFFD\u6D22\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD: \uFFFD\u037B\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD
  -- \uFFFD\u6D22\uFFFD\uFFFD\uFFFD\u0331\uFFFD\uFFFD: PRC_DWD_CUST_INDIV_RISK_INVST
  -- \uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD: \uFFFD\uFFFD
  -- \uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD: \uFFFD\uFFFD\uFFFD\uFFFD FMS_T4_CUST_RISK_ASSESS_INFO \u04F3\uFFFD\uFFFD\uFFFD\u03F5\uFFFD\uFFFD\uFFFD\u027F\u037B\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\u03E2
  -- \uFFFD\uFFFD\u0534\uFFFD\uFFFD: FMS_T4_CUST_RISK_ASSESS_INFO(\uFFFD\u037B\uFFFD\uFFFD\uFFFD\uFFFD\u0573\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\u03E2\uFFFD\uFFFD)
  -- \u013F\uFFFD\uFFFD\uFFFD: DWD_CUST_INDIV_RISK_INVST(\uFFFD\u037B\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD)
  -- author :
  -- date   : 2026-07-15
  -- \uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\u077F\uFFFD: \uFFFD\u02F4\uFFFD\uFFFD\uFFFD Oracle \uFFFD\uFFFD\uFFFD\uFFFD\u0123\u02BD
  ------------------------------------------------------------------
  ------------------------------------------------------------------
  --***************************************
  --1.\uFFFD\u0536\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD
  --***************************************
  V_PRC_DESC             VARCHAR(100) := '\uFFFD\u037B\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD';
  V_PRC_NAME             VARCHAR(32)  := 'PRC_DWD_CUST_INDIV_RISK_INVST';
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
  -- 2. \u04B5\uFFFD\uFFFD\uFFFD\u07FC\uFFFD\uFFFD\uFFFD
  --***************************************
  V_START_DT := SYSDATE;
  V_SYSDAT2 := TO_CHAR(TO_DATE(V_SYSDAT, 'yyyymmdd'), 'yyyy-mm-dd');
  P_INTERVAL_START_DATE := TO_CHAR(TO_DATE(V_SYSDAT, 'yyyymmdd') - 30, 'yyyymmdd');
  P_INTERVAL_END_DATE   := V_SYSDAT;

  EXECUTE IMMEDIATE 'TRUNCATE TABLE DWD_CUST_CTRAKT_INFO';

  --***************************************
  -- 2.1 \uFFFD\uFFFD\uFFFD-\uFFFD\u037B\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD
  --***************************************
  V_NO_ID := '1';
  V_BGN_DATE := SYSDATE;

  INSERT INTO DWD_CUST_INDIV_RISK_INVST (
      CUST_ID,
      INVEST_TYP,
      ESTIM_RSLT,
      SCORE,
      RISK_LVL,
      ESTIM_DATE,
      EXPR_DATE,
      PERSN_LEGAL_BK_CODE
  )
  SELECT
      host_cust_no	  AS CUST_ID,   --\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\u037B\uFFFD\uFFFD\uFFFD     
      '3'            AS INVEST_TYP,--\u0376\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD	                          
      NULL	          AS ESTIM_RSLT,--\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD
      NULL	          AS SCORE,     --\uFFFD\uFFFD\uFFFD\uFFFD
      CUST_RISK_LEVEL	AS RISK_LVL,  --\uFFFD\uFFFD\uFFFD\u0573\uFFFD\uFFFD\u0735\u023C\uFFFD
      ASSESS_DATE	    AS ESTIM_DATE,--\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD        
      INVALID_DATE	  AS EXPR_DATE, --\u02A7\u0427\uFFFD\uFFFD\uFFFD\uFFFD      
      '9999'          AS PERSN_LEGAL_BK_CODE \uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\u043A\uFFFD
    FROM T4_CUST_RISK_ASSESS_INFO	; -- \uFFFD\u037B\uFFFD\uFFFD\uFFFD\uFFFD\u0573\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\u03E2\uFFFD\uFFFD

  COMMIT;

  OUTCDE := 0;
  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG := '2.1 \uFFFD\uFFFD\uFFFD-\uFFFD\u037B\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD';
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

  --***************************************
  -- 2.2 \uFFFD\uFFFD\uFFFD\uFFFD-\uFFFD\u037B\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD
  --***************************************
  V_NO_ID := '2';
  V_BGN_DATE := SYSDATE;
/*9\uFFFD\u00B1\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\u07FA\uFFFD*/
  OUTCDE := 0;
  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG := '2.1 \uFFFD\uFFFD\uFFFD\uFFFD-\uFFFD\u037B\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD';
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

  --***************************************
  -- 3. \uFFFD\uCCE3\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uBCA2\uFFFD\uFFFD\u00BC\uFFFD\uFFFD\u03F8\uFFFD\uFFFD\u05BE\uFFFD\uFFFD
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
