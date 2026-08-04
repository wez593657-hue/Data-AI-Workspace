SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET PAGESIZE 0
SET FEEDBACK OFF
SET VERIFY OFF
SET TRIMSPOOL ON
SET LINESIZE 400

-- ============================================================
-- v2.12.0 Test: 定期50→110 (已有50定期, 当月新增60)
-- Wake判定: DWD_ACCT_DEPO.INTRI_BGN_DATE 在当月范围内 → IS_WAKE=1
-- ============================================================

BEGIN DBMS_OUTPUT.PUT_LINE('========== v2.12.0 Scenario: 50 fixd + 60 new fixd =========='); END;
/

-- ============================================================
-- Clean & Setup
-- ============================================================
DELETE FROM ADS_CUST_SLEEP_WAKE_DTL;
DELETE FROM ADS_CUST_SLEEP_WAKE_STATIS;
DELETE FROM DWD_ACCT_DEPO WHERE CUST_ID='C999';
DELETE FROM DWD_ACCT_FIN WHERE CUST_ID='C999';
DELETE FROM DWD_ACCT_INSUR WHERE CUST_ID='C999';
DELETE FROM DWD_CUST_INDV_INFO WHERE CUST_ID='C999';
DELETE FROM DWS_CUST_ASSE_LIAB WHERE CUST_ID='C999';
DELETE FROM DWD_CUST_MAN WHERE CUST_ID='C999';
DELETE FROM DWS_CUST_LVL_INFO WHERE CUST_ID='C999';
DELETE FROM DWD_SYS_ORG WHERE ORG_ID='ORG999';

BEGIN
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_ADS_SLEEP_WAKE_BASE';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_ADS_SLEEP_CANDIDATE';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_ADS_SLEEP_DWS_WAKE';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_ADS_SLEEP_CNTCT';
END;
/

INSERT INTO DWD_SYS_ORG (ORG_ID, SUP_ORG_ID, ORG_NAME, ORG_TYP, ORG_STATE, PERSN_LEGAL_BK_CODE)
VALUES ('ORG999', NULL, 'Test Org', '1', '1', 'BK01');

INSERT INTO DWD_CUST_INDV_INFO (CUST_ID, CUST_NAME, CUST_TYP, OPEN_DATE, OPEN_ORG, PERSN_LEGAL_BK_CODE)
VALUES ('C999', 'Fixd50to110', '01', '20250101', 'ORG999', 'BK01');

INSERT INTO DWS_CUST_LVL_INFO (DATA_DATE, CUST_ID, CUST_LVL, PERSN_LEGAL_BK_CODE)
VALUES ('20260815', 'C999', '01', 'BK01');

INSERT INTO DWD_CUST_MAN (CUST_ID, MNGR_POST_ID, ORG_ID, MNG_TYP, PERSN_LEGAL_BK_CODE)
VALUES ('C999', 'MGR999', 'ORG999', '1', 'BK01');

-- ============================================================
-- T-1 DTL: C999 in sleep list yesterday (AUM=80, FIXD=50)
-- ============================================================
INSERT INTO DWS_CUST_ASSE_LIAB (DATA_DATE, PERSN_LEGAL_BK_CODE, CUST_ID, ORG_ID, BAL_TYPE, AUM_BAL, DEPO_CURNT_DEPO_BAL, FIXD_DEPO_BAL, FIN_BAL, INSUR_BAL)
VALUES ('20260814', 'BK01', 'C999', 'ORG999', '1', 80, 30, 50, 0, 0);

INSERT INTO ADS_CUST_SLEEP_WAKE_DTL (
  PERSN_LEGAL_BK_CODE, DATA_DATE, CUST_ID, CUST_NAME, CUST_LVL,
  DEPO_CURNT_DEPO_BAL, FIXD_DEPO_BAL, FIN_AMT, INSUR_AMT,
  CNTCT_STATE, WAKE_STATE, POST_ID, ORG_ID, STATIS_CYCLE
) VALUES ('BK01', '20260814', 'C999', 'Fixd50to110', '01', 30, 50, 0, 0, '0', '0', 'MGR999', 'ORG999', 'M');

-- ============================================================
-- DWS snapshot today: AUM=140, FIXD=110 (50 old + 60 new)
-- ============================================================
INSERT INTO DWS_CUST_ASSE_LIAB (DATA_DATE, PERSN_LEGAL_BK_CODE, CUST_ID, ORG_ID, BAL_TYPE, AUM_BAL, DEPO_CURNT_DEPO_BAL, FIXD_DEPO_BAL, FIN_BAL, INSUR_BAL)
VALUES ('20260815', 'BK01', 'C999', 'ORG999', '1', 140, 30, 110, 0, 0);

-- ============================================================
-- KEY: DWD_ACCT_DEPO new record with INTRI_BGN_DATE in current month!
-- This is the new 60元 fixd deposit
-- ============================================================
INSERT INTO DWD_ACCT_DEPO (CUST_ID, ACCT_ID, PRDKT_ID, INTRI_BGN_DATE, OPEN_ACCT_ORG, PERSN_LEGAL_BK_CODE, ACCT_STATE, FIX_CURNT_FLG, BAL, RMB_BAL)
VALUES ('C999', 'ACCT999', 'PRD_FIXD_001', '20260810', 'ORG999', 'BK01', '1', '1', 110, 110);

-- Also the old fixd account (opened before this month)
INSERT INTO DWD_ACCT_DEPO (CUST_ID, ACCT_ID, PRDKT_ID, INTRI_BGN_DATE, OPEN_ACCT_ORG, PERSN_LEGAL_BK_CODE, ACCT_STATE, FIX_CURNT_FLG, BAL, RMB_BAL)
VALUES ('C999', 'ACCT998', 'PRD_FIXD_001', '20260701', 'ORG999', 'BK01', '1', '1', 0, 0);

COMMIT;

BEGIN
  DBMS_OUTPUT.PUT_LINE('Setup complete.');
  DBMS_OUTPUT.PUT_LINE('DWD_ACCT_DEPO ACCT999: INTRI_BGN_DATE=20260810 (in month!)');
  DBMS_OUTPUT.PUT_LINE('DWD_ACCT_DEPO ACCT998: INTRI_BGN_DATE=20260701 (before month)');
  DBMS_OUTPUT.PUT_LINE('DWS today: AUM=140, FIXD=110');
END;
/

-- ============================================================
-- Execute DTL
-- ============================================================
BEGIN DBMS_OUTPUT.PUT_LINE(''); DBMS_OUTPUT.PUT_LINE('========== Execute DTL 20260815 =========='); END;
/
DECLARE v_out INTEGER;
BEGIN PRC_ADS_CUST_SLEEP_WAKE_DTL('20260815', v_out); DBMS_OUTPUT.PUT_LINE('Return: '||v_out); END;
/

-- ============================================================
-- [A0] TMP_ADS_SLEEP_DWS_WAKE - IS_WAKE
-- ============================================================
BEGIN
  DBMS_OUTPUT.PUT_LINE('');
  DBMS_OUTPUT.PUT_LINE('========== [A0] IS_WAKE ==========');
  DBMS_OUTPUT.PUT_LINE('DWD_ACCT_DEPO.INTRI_BGN_DATE=20260810 IN [20260801,20260815]');
  DBMS_OUTPUT.PUT_LINE('→ EXISTS = TRUE → IS_WAKE=1');
END;
/
SELECT CUST_ID, AUM_BAL, FIXD_DEPO_BAL AS FIXD, FIN_BAL AS FIN, INSUR_BAL AS INSUR, IS_WAKE
FROM TMP_ADS_SLEEP_DWS_WAKE WHERE CUST_ID='C999';

-- ============================================================
-- Final DTL
-- ============================================================
BEGIN
  DBMS_OUTPUT.PUT_LINE('');
  DBMS_OUTPUT.PUT_LINE('========== ADS_CUST_SLEEP_WAKE_DTL ==========');
END;
/
SELECT CUST_ID, DEPO_CURNT_DEPO_BAL AS DEPO, FIXD_DEPO_BAL AS FIXD,
       FIN_AMT AS FIN, INSUR_AMT AS INSUR, CNTCT_STATE AS CNTCT, WAKE_STATE AS WAKE
FROM ADS_CUST_SLEEP_WAKE_DTL WHERE DATA_DATE='20260815';

-- ============================================================
-- Assertions
-- ============================================================
DECLARE
  v_is_wake NUMBER; v_wake CHAR(1); v_fixd NUMBER;
  v_pass INTEGER := 0; v_fail INTEGER := 0;
BEGIN
  DBMS_OUTPUT.PUT_LINE('');
  DBMS_OUTPUT.PUT_LINE('========== Assertions ==========');

  SELECT IS_WAKE INTO v_is_wake FROM TMP_ADS_SLEEP_DWS_WAKE WHERE CUST_ID='C999';
  IF v_is_wake = 1 THEN
    DBMS_OUTPUT.PUT_LINE('PASS: [A0] IS_WAKE=1 (account INTRI_BGN_DATE in month range)');
    v_pass := v_pass + 1;
  ELSE
    DBMS_OUTPUT.PUT_LINE('FAIL: [A0] IS_WAKE=' || v_is_wake || ' (expected 1)');
    v_fail := v_fail + 1;
  END IF;

  SELECT FIXD_DEPO_BAL, WAKE_STATE INTO v_fixd, v_wake
  FROM ADS_CUST_SLEEP_WAKE_DTL WHERE DATA_DATE='20260815' AND CUST_ID='C999';
  
  IF v_fixd = 110 THEN
    DBMS_OUTPUT.PUT_LINE('PASS: FIXD_DEPO_BAL=110 (balance updated)');
    v_pass := v_pass + 1;
  ELSE
    DBMS_OUTPUT.PUT_LINE('FAIL: FIXD=' || v_fixd || ' (expected 110)');
    v_fail := v_fail + 1;
  END IF;

  IF v_wake = '1' THEN
    DBMS_OUTPUT.PUT_LINE('PASS: WAKE_STATE=1 (50→110 triggered WAKE in v2.12.0!)');
    v_pass := v_pass + 1;
  ELSE
    DBMS_OUTPUT.PUT_LINE('FAIL: WAKE_STATE=' || v_wake || ' (expected 1)');
    v_fail := v_fail + 1;
  END IF;

  DBMS_OUTPUT.PUT_LINE('');
  DBMS_OUTPUT.PUT_LINE('Total: ' || v_pass || ' PASS / ' || v_fail || ' FAIL');
  IF v_fail > 0 THEN RAISE_APPLICATION_ERROR(-20001, 'FAILED'); END IF;
END;
/

-- ============================================================
-- Compare: v2.11.0 vs v2.12.0
-- ============================================================
BEGIN
  DBMS_OUTPUT.PUT_LINE('');
  DBMS_OUTPUT.PUT_LINE('========== Version Comparison ==========');
  DBMS_OUTPUT.PUT_LINE('v2.11.0: 50→110 → IS_WAKE=0 (50!=0, no first-time trigger)');
  DBMS_OUTPUT.PUT_LINE('v2.12.0: 50→110 → IS_WAKE=1 (INTRI_BGN_DATE in month → new tx exists)');
  DBMS_OUTPUT.PUT_LINE('Change: from "DWS balance first-time" to "account table date-driven"');
END;
/
