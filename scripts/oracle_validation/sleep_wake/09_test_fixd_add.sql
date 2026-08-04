SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET PAGESIZE 0
SET FEEDBACK OFF
SET VERIFY OFF
SET TRIMSPOOL ON
SET LINESIZE 400

-- ============================================================
-- Scenario: Customer had 50 fixd at baseline, added 60 more this month
-- C999: baseline FIXD=50 (already held), today FIXD=110 (50+60 new)
-- Test date: 20260815 (non-month-begin, baseline=20260801)
-- ============================================================

BEGIN DBMS_OUTPUT.PUT_LINE('========== Clean & Init =========='); END;
/

DELETE FROM ADS_CUST_SLEEP_WAKE_DTL;
DELETE FROM ADS_CUST_SLEEP_WAKE_STATIS;
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
VALUES ('C999', 'FixdAdd60', '01', '20250101', 'ORG999', 'BK01');

INSERT INTO DWS_CUST_LVL_INFO (DATA_DATE, CUST_ID, CUST_LVL, PERSN_LEGAL_BK_CODE)
VALUES ('20260815', 'C999', '01', 'BK01');
INSERT INTO DWS_CUST_LVL_INFO (DATA_DATE, CUST_ID, CUST_LVL, PERSN_LEGAL_BK_CODE)
VALUES ('20260801', 'C999', '01', 'BK01');

INSERT INTO DWD_CUST_MAN (CUST_ID, MNGR_POST_ID, ORG_ID, MNG_TYP, PERSN_LEGAL_BK_CODE)
VALUES ('C999', 'MGR999', 'ORG999', '1', 'BK01');

-- ============================================================
-- T-1 (20260814): C999 in sleep list, AUM=80 (30 current+50 fixd)
-- ============================================================
INSERT INTO DWS_CUST_ASSE_LIAB (DATA_DATE, PERSN_LEGAL_BK_CODE, CUST_ID, ORG_ID, BAL_TYPE, AUM_BAL, DEPO_CURNT_DEPO_BAL, FIXD_DEPO_BAL, FIN_BAL, INSUR_BAL)
VALUES ('20260814', 'BK01', 'C999', 'ORG999', '1', 80, 30, 50, 0, 0);

INSERT INTO ADS_CUST_SLEEP_WAKE_DTL (
  PERSN_LEGAL_BK_CODE, DATA_DATE, CUST_ID, CUST_NAME, CUST_LVL,
  DEPO_CURNT_DEPO_BAL, FIXD_DEPO_BAL, FIN_AMT, INSUR_AMT,
  CNTCT_STATE, WAKE_STATE, POST_ID, ORG_ID, STATIS_CYCLE
) VALUES ('BK01', '20260814', 'C999', 'FixdAdd60', '01', 30, 50, 0, 0, '0', '0', 'MGR999', 'ORG999', 'M');

BEGIN
  DBMS_OUTPUT.PUT_LINE('T-1(20260814): C999 in sleep list, AUM=80, FIXD=50, WAKE=0');
END;
/

-- ============================================================
-- Baseline (20260801): FIXD=50 (NOT zero! already held at month start)
-- ============================================================
INSERT INTO DWS_CUST_ASSE_LIAB (DATA_DATE, PERSN_LEGAL_BK_CODE, CUST_ID, ORG_ID, BAL_TYPE, AUM_BAL, DEPO_CURNT_DEPO_BAL, FIXD_DEPO_BAL, FIN_BAL, INSUR_BAL)
VALUES ('20260801', 'BK01', 'C999', 'ORG999', '1', 80, 30, 50, 0, 0);

BEGIN
  DBMS_OUTPUT.PUT_LINE('Baseline(20260801): AUM=80, FIXD=50 (NOT zero!)');
END;
/

-- ============================================================
-- Today (20260815): added 60 fixd → FIXD=110, AUM=140
-- ============================================================
INSERT INTO DWS_CUST_ASSE_LIAB (DATA_DATE, PERSN_LEGAL_BK_CODE, CUST_ID, ORG_ID, BAL_TYPE, AUM_BAL, DEPO_CURNT_DEPO_BAL, FIXD_DEPO_BAL, FIN_BAL, INSUR_BAL)
VALUES ('20260815', 'BK01', 'C999', 'ORG999', '1', 140, 30, 110, 0, 0);

COMMIT;

BEGIN
  DBMS_OUTPUT.PUT_LINE('Today(20260815): AUM=140, FIXD=110 (+60 more!)');
  DBMS_OUTPUT.PUT_LINE('');
END;
/

-- ============================================================
-- Execute DTL
-- ============================================================
BEGIN DBMS_OUTPUT.PUT_LINE('========== Execute DTL 20260815 =========='); END;
/
DECLARE v_out INTEGER;
BEGIN PRC_ADS_CUST_SLEEP_WAKE_DTL('20260815', v_out); DBMS_OUTPUT.PUT_LINE('Return: '||v_out); END;
/

-- ============================================================
-- [A0] TMP_ADS_SLEEP_DWS_WAKE - THE KEY STEP
-- ============================================================
BEGIN
  DBMS_OUTPUT.PUT_LINE('');
  DBMS_OUTPUT.PUT_LINE('========== [A0] TMP_ADS_SLEEP_DWS_WAKE ==========');
  DBMS_OUTPUT.PUT_LINE('IS_WAKE = CASE WHEN (baseline.FIXD=0 AND today.FIXD>0) ...');
  DBMS_OUTPUT.PUT_LINE('baseline.FIXD=50, today.FIXD=110');
  DBMS_OUTPUT.PUT_LINE('→ 50=0? FALSE → NOT wake!');
END;
/
SELECT CUST_ID, AUM_BAL, FIXD_DEPO_BAL AS FIXD, FIN_BAL AS FIN, INSUR_BAL AS INSUR, IS_WAKE
FROM TMP_ADS_SLEEP_DWS_WAKE WHERE CUST_ID='C999';

-- ============================================================
-- [D] TMP_BASE after unified UPDATE
-- ============================================================
BEGIN
  DBMS_OUTPUT.PUT_LINE('');
  DBMS_OUTPUT.PUT_LINE('========== [D] TMP_BASE after update ==========');
  DBMS_OUTPUT.PUT_LINE('WAKE_STATE = CASE WHEN b.WAKE=1 THEN 1 WHEN sw.IS_WAKE=1 THEN 1 ELSE 0');
END;
/
SELECT CUST_ID, FIXD_DEPO_BAL AS FIXD, CNTCT_STATE AS CNTCT, WAKE_STATE AS WAKE
FROM TMP_ADS_SLEEP_WAKE_BASE WHERE CUST_ID='C999';

-- ============================================================
-- Final DTL output
-- ============================================================
BEGIN
  DBMS_OUTPUT.PUT_LINE('');
  DBMS_OUTPUT.PUT_LINE('========== ADS_CUST_SLEEP_WAKE_DTL ==========');
END;
/
SELECT CUST_ID, CUST_NAME, DEPO_CURNT_DEPO_BAL AS DEPO, FIXD_DEPO_BAL AS FIXD,
       FIN_AMT AS FIN, INSUR_AMT AS INSUR, CNTCT_STATE AS CNTCT, WAKE_STATE AS WAKE
FROM ADS_CUST_SLEEP_WAKE_DTL WHERE DATA_DATE='20260815';

-- ============================================================
-- Assertions
-- ============================================================
DECLARE
  v_fixd  NUMBER; v_wake CHAR(1); v_cnt   INTEGER;
  v_pass  INTEGER := 0; v_fail INTEGER := 0;
  PROCEDURE chk(label VARCHAR2, exp VARCHAR2, act VARCHAR2) IS
  BEGIN
    IF exp = act THEN
      DBMS_OUTPUT.PUT_LINE('PASS: ' || label || ' = ' || act);
      v_pass := v_pass + 1;
    ELSE
      DBMS_OUTPUT.PUT_LINE('FAIL: ' || label || ' exp=' || exp || ' act=' || act);
      v_fail := v_fail + 1;
    END IF;
  END;
BEGIN
  DBMS_OUTPUT.PUT_LINE('');
  DBMS_OUTPUT.PUT_LINE('========== Assertions ==========');

  -- IS_WAKE from A0
  DECLARE v_iw NUMBER;
  BEGIN
    SELECT IS_WAKE INTO v_iw FROM TMP_ADS_SLEEP_DWS_WAKE WHERE CUST_ID='C999';
    DBMS_OUTPUT.PUT_LINE('--- [A0] IS_WAKE ---');
    chk('IS_WAKE=0 (baseline.FIXD=50!=0)', '0', CAST(v_iw AS VARCHAR2(1)));
  END;

  -- Final DTL
  SELECT FIXD_DEPO_BAL, WAKE_STATE INTO v_fixd, v_wake
  FROM ADS_CUST_SLEEP_WAKE_DTL WHERE DATA_DATE='20260815' AND CUST_ID='C999';

  DBMS_OUTPUT.PUT_LINE('--- DTL Result ---');
  chk('FIXD_DEPO_BAL=110 (updated)', '110', CAST(v_fixd AS VARCHAR2(10)));
  chk('WAKE_STATE=0 (NOT woken)', '0', v_wake);

  -- Count
  SELECT COUNT(*) INTO v_cnt FROM ADS_CUST_SLEEP_WAKE_DTL WHERE DATA_DATE='20260815';
  DBMS_OUTPUT.PUT_LINE('--- Count ---');
  chk('DTL count=1 (still in list)', '1', CAST(v_cnt AS VARCHAR2(2)));

  DBMS_OUTPUT.PUT_LINE('');
  DBMS_OUTPUT.PUT_LINE('Total: ' || v_pass || ' PASS / ' || v_fail || ' FAIL');
END;
/

-- ============================================================
-- STATIS
-- ============================================================
BEGIN DBMS_OUTPUT.PUT_LINE(''); DBMS_OUTPUT.PUT_LINE('========== STATIS =========='); END;
/
DECLARE v_out INTEGER;
BEGIN PRC_ADS_CUST_SLEEP_WAKE_STATIS('20260815', v_out); END;
/
SELECT STATIS_OBJ, CUST_CNT, WAKE_CUST_CNT AS WAKE_CNT
FROM ADS_CUST_SLEEP_WAKE_STATIS WHERE DATA_DATE='20260815';
