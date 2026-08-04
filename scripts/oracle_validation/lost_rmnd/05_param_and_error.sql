-- ============================================================
-- Parameter validation & error handling tests
-- ============================================================
SET SERVEROUTPUT ON
SET PAGESIZE 200
SET LINESIZE 200

PROMPT ============ P1 Parameter validation (DTL & STATIS) ============
DECLARE
  PROCEDURE t_case(p_name VARCHAR2, p_val VARCHAR2, p_proc VARCHAR2) IS
    v_rc NUMBER;
  BEGIN
    BEGIN
      IF p_proc = 'DTL' THEN
        PRC_ADS_CUST_LOST_DTL(p_val, v_rc);
      ELSE
        PRC_ADS_CUST_LOST_STATIS(p_val, v_rc);
      END IF;
      DBMS_OUTPUT.PUT_LINE(p_name||' | '||p_proc||' | NO_ERROR rc='||v_rc);
    EXCEPTION WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(p_name||' | '||p_proc||' | '||SQLCODE||' '||SUBSTR(SQLERRM,1,70));
    END;
  END;
BEGIN
  t_case('NULL','', 'DTL');
  t_case('7digit','2026063','DTL');
  t_case('alpha','ABCDEFGH','DTL');
  t_case('space','2026 630','DTL');
  t_case('invalid_date','20260230','DTL');
  t_case('NULL','', 'STAT');
  t_case('7digit','2026063','STAT');
  t_case('alpha','ABCDEFGH','STAT');
  t_case('invalid_date','20260230','STAT');
END;
/

PROMPT ============ P2 Valid batch returns RC=0 ============
DECLARE
  v_rc NUMBER;
BEGIN
  PRC_ADS_CUST_LOST_DTL('20260630', v_rc);
  DBMS_OUTPUT.PUT_LINE('DTL valid rc='||v_rc);
  PRC_ADS_CUST_LOST_STATIS('20260630', v_rc);
  DBMS_OUTPUT.PUT_LINE('STAT valid rc='||v_rc);
END;
/

PROMPT ============ P3 Error handling: missing temp table ============
DROP TABLE TMP_ADS_LOST_BASE;
DECLARE
  v_rc NUMBER;
BEGIN
  BEGIN
    PRC_ADS_CUST_LOST_DTL('20260630', v_rc);
    DBMS_OUTPUT.PUT_LINE('UNEXPECTED_SUCCESS rc='||v_rc);
  EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('CAUGHT '||SQLCODE||' '||SUBSTR(SQLERRM,1,70));
  END;
END;
/
PROMPT -- failure log evidence
SELECT DATA_DATE, PRC_NAME, STEP_NO, LOG_FLG, SUBSTR(LOG_MSG,1,70) AS LOG_MSG
  FROM SYS_PRC_STEP_LOG
 WHERE PRC_NAME LIKE 'PRC_ADS_CUST_LOST%' AND LOG_FLG < 0
   AND ROWNUM <= 3
 ORDER BY BGN_DATE DESC;

CREATE TABLE TMP_ADS_LOST_BASE (
    PERSN_LEGAL_BK_CODE     VARCHAR2(4),
    CUST_ID                 VARCHAR2(20),
    CUST_NAME               VARCHAR2(100),
    CUST_LVL                VARCHAR2(2),
    LVL_CHURN               VARCHAR2(2),
    DEPO_CURNT_DEPO_BAL     NUMBER(20,2),
    FIXD_DEPO_BAL           NUMBER(20,2),
    FIN_AMT                 NUMBER(20,2),
    CNTCT_STATE_M           VARCHAR2(1),
    RESCUE_STATE            VARCHAR2(1),
    CUR_AUM_BAL             NUMBER(20,2),
    LAST_MONTH_END_AUM_BAL  NUMBER(20,2),
    POST_ID                 VARCHAR2(20),
    ORG_ID                  VARCHAR2(7)
);

PROMPT ============ P4 Recovery after restore ============
DECLARE
  v_rc NUMBER;
BEGIN
  PRC_ADS_CUST_LOST_DTL('20260630', v_rc);
  DBMS_OUTPUT.PUT_LINE('DTL recovered rc='||v_rc);
  PRC_ADS_CUST_LOST_STATIS('20260630', v_rc);
  DBMS_OUTPUT.PUT_LINE('STAT recovered rc='||v_rc);
END;
/

EXIT
