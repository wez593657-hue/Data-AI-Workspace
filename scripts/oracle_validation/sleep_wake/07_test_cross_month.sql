SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET PAGESIZE 0
SET FEEDBACK OFF
SET VERIFY OFF
SET TRIMSPOOL ON
SET LINESIZE 400

-- ============================================================
-- Cross-Month Boundary Test: 20260901 (Next Month Begin)
-- ============================================================

-- ============================================================
-- Setup 20260831 (last day of August) DWS data
-- ============================================================
BEGIN DBMS_OUTPUT.PUT_LINE('=== Cross-Month Setup: 20260831 ==='); END;
/

-- T-1 for 20260901 is 20260831: DWS baseline for wake comparison
INSERT INTO DWS_CUST_ASSE_LIAB (DATA_DATE, PERSN_LEGAL_BK_CODE, CUST_ID, ORG_ID, BAL_TYPE, AUM_BAL, DEPO_CURNT_DEPO_BAL, FIXD_DEPO_BAL, FIN_BAL, INSUR_BAL)
SELECT '20260831', 'BK01', CUST_ID, 'ORG003', '1',
  CASE CUST_ID
    WHEN 'C010' THEN 30       -- Still sleep
    WHEN 'C002' THEN 500      -- No longer sleep (AUM grew to 500)
    WHEN 'C004' THEN 30       -- Still sleep, had 定期 on day1 but baseline is month-begin
    WHEN 'C005' THEN 200      -- Above 100, had FIXD
    WHEN 'C007' THEN 30       -- Has FIN
    WHEN 'C008' THEN 30       -- Has INSUR
    WHEN 'C009' THEN 0.01
    WHEN 'C012' THEN 500      -- Still above 100
    WHEN 'C013' THEN 40
    ELSE 0
  END,
  0,
  CASE CUST_ID
    WHEN 'C004' THEN 10000    -- Still has 定期
    WHEN 'C005' THEN 200      -- Has 定期
    ELSE 0
  END,
  CASE CUST_ID
    WHEN 'C007' THEN 5000     -- Has 理财
    ELSE 0
  END,
  CASE CUST_ID
    WHEN 'C008' THEN 5000     -- Has 保险
    ELSE 0
  END
FROM DWD_CUST_INDV_INFO
WHERE CUST_ID IN ('C010','C002','C004','C005','C007','C008','C009','C012','C013');

-- 20260901 DWS data: some customers change
INSERT INTO DWS_CUST_ASSE_LIAB (DATA_DATE, PERSN_LEGAL_BK_CODE, CUST_ID, ORG_ID, BAL_TYPE, AUM_BAL, DEPO_CURNT_DEPO_BAL, FIXD_DEPO_BAL, FIN_BAL, INSUR_BAL)
SELECT '20260901', 'BK01', CUST_ID, 'ORG003', '1',
  CASE CUST_ID
    WHEN 'C010' THEN 35       -- Still sleep (AUM still <100)
    WHEN 'C002' THEN 500      -- No longer sleep, no wake products
    WHEN 'C004' THEN 30       -- Still sleep
    WHEN 'C005' THEN 300      -- Above 100, has 定期 (was woken last month, but month reset)
    WHEN 'C007' THEN 30       -- Has 理财
    WHEN 'C008' THEN 30       -- Has 保险
    WHEN 'C009' THEN 0.01     -- Still sleep
    WHEN 'C012' THEN 600      -- Above 100, has 定期 (was woken last month)
    WHEN 'C013' THEN 50       -- Still sleep (AUM still <100)
  END,
  0,
  CASE CUST_ID
    WHEN 'C004' THEN 10000    -- Baseline=10000 (already had at month-end) → today still=10000 → NOT wake (no increment)
    WHEN 'C005' THEN 200      -- Same as baseline → not wake
    WHEN 'C012' THEN 5000     -- Same → not wake
    ELSE 0
  END,
  CASE CUST_ID
    WHEN 'C007' THEN 5000     -- Same → not wake
    ELSE 0
  END,
  CASE CUST_ID
    WHEN 'C008' THEN 5000     -- Same → not wake
    ELSE 0
  END
FROM DWD_CUST_INDV_INFO
WHERE CUST_ID IN ('C010','C002','C004','C005','C007','C008','C009','C012','C013');

COMMIT;

DECLARE v31 NUMBER; v01 NUMBER;
BEGIN
  SELECT COUNT(*) INTO v31 FROM DWS_CUST_ASSE_LIAB WHERE DATA_DATE='20260831';
  SELECT COUNT(*) INTO v01 FROM DWS_CUST_ASSE_LIAB WHERE DATA_DATE='20260901';
  DBMS_OUTPUT.PUT_LINE('Cross-month: DWS 0831='||v31||', 0901='||v01);
END;
/

-- ============================================================
-- Execute DTL for 20260901 (Month Begin)
-- ============================================================
BEGIN DBMS_OUTPUT.PUT_LINE('=== Execute DTL 20260901 (Next Month Begin) ==='); END;
/

DECLARE v_out INTEGER;
BEGIN
  PRC_ADS_CUST_SLEEP_WAKE_DTL('20260901', v_out);
  DBMS_OUTPUT.PUT_LINE('DTL 20260901 returned: ' || v_out);
END;
/

-- ============================================================
-- Cross-Month Verification
-- ============================================================
SELECT 
  CUST_ID, CUST_NAME,
  FIXD_DEPO_BAL AS FIXD, FIN_AMT AS FIN, INSUR_AMT AS INSUR,
  CNTCT_STATE AS CNTCT, WAKE_STATE AS WAKE
FROM ADS_CUST_SLEEP_WAKE_DTL
WHERE DATA_DATE = '20260901'
ORDER BY CUST_ID;

DECLARE v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count FROM ADS_CUST_SLEEP_WAKE_DTL WHERE DATA_DATE='20260901';
  DBMS_OUTPUT.PUT_LINE('');
  DBMS_OUTPUT.PUT_LINE('20260901 DTL count: ' || v_count);
  DBMS_OUTPUT.PUT_LINE('Expected: C004,C007,C008,C009,C010,C013 (6 records)');
  DBMS_OUTPUT.PUT_LINE('Reasoning:');
  DBMS_OUTPUT.PUT_LINE('  C010: still sleep (AUM=35<100) → KEPT');
  DBMS_OUTPUT.PUT_LINE('  C002: AUM=500>=100, no wake → REMOVED');
  DBMS_OUTPUT.PUT_LINE('  C004: AUM=30, 定期 baseline=10000 today=10000 → no increment → NOT wake → still sleep → KEPT');
  DBMS_OUTPUT.PUT_LINE('  C005: AUM=300>=100, 定期 baseline=200 today=200 → no wake → REMOVED');
  DBMS_OUTPUT.PUT_LINE('  C007: AUM=30, 理财 baseline=5000 today=5000 → no wake → still sleep → KEPT');
  DBMS_OUTPUT.PUT_LINE('  C008: AUM=30, 保险 baseline=5000 today=5000 → no wake → still sleep → KEPT');
  DBMS_OUTPUT.PUT_LINE('  C009: AUM=0.01<100 → KEPT');
  DBMS_OUTPUT.PUT_LINE('  C012: AUM=600>=100, 定期 baseline=5000 today=5000 → no wake → REMOVED');
  DBMS_OUTPUT.PUT_LINE('  C013: AUM=50<100 → KEPT');
END;
/

-- ============================================================
-- Cross-Month Assertions
-- ============================================================
BEGIN DBMS_OUTPUT.PUT_LINE(''); DBMS_OUTPUT.PUT_LINE('=== Cross-Month Assertions ==='); END;
/

DECLARE
  FUNCTION c(p_id VARCHAR2) RETURN INTEGER IS
    r INTEGER;
  BEGIN
    SELECT COUNT(*) INTO r FROM ADS_CUST_SLEEP_WAKE_DTL WHERE DATA_DATE='20260901' AND CUST_ID=p_id;
    RETURN r;
  END;
  FUNCTION w(p_id VARCHAR2) RETURN CHAR IS
    r CHAR(1);
  BEGIN
    BEGIN SELECT MAX(WAKE_STATE) INTO r FROM ADS_CUST_SLEEP_WAKE_DTL WHERE DATA_DATE='20260901' AND CUST_ID=p_id; EXCEPTION WHEN NO_DATA_FOUND THEN r:='X'; END;
    RETURN r;
  END;
  FUNCTION t(p_id VARCHAR2) RETURN CHAR IS
    r CHAR(1);
  BEGIN
    BEGIN SELECT MAX(CNTCT_STATE) INTO r FROM ADS_CUST_SLEEP_WAKE_DTL WHERE DATA_DATE='20260901' AND CUST_ID=p_id; EXCEPTION WHEN NO_DATA_FOUND THEN r:='X'; END;
    RETURN r;
  END;
  PROCEDURE assert(label VARCHAR2, exp_cnt INTEGER, exp_wake CHAR, exp_cntct CHAR, p_id VARCHAR2) IS
    vc INTEGER; vw CHAR(1); vt CHAR(1); vr VARCHAR2(20);
  BEGIN
    vc := c(p_id); vw := w(p_id); vt := t(p_id);
    DBMS_OUTPUT.PUT_LINE(label || ': cnt=' || vc || '(exp='||exp_cnt||') wake='||vw||'(exp='||exp_wake||') cntct='||vt||'(exp='||exp_cntct||')');
    IF vc=exp_cnt AND vw=exp_wake AND vt=exp_cntct THEN
      DBMS_OUTPUT.PUT_LINE('  → PASS');
    ELSE
      DBMS_OUTPUT.PUT_LINE('  → FAIL');
    END IF;
  END;
  vc NUMBER; vr VARCHAR2(20);
BEGIN
  assert('CM1  C010 still sleep', 1, '0', '0', 'C010');
  assert('CM2  C002 removed', 0, 'X', 'X', 'C002');
  assert('CM3  C004 kept (sleep)', 1, '0', '0', 'C004');
  assert('CM4  C005 removed', 0, 'X', 'X', 'C005');
  assert('CM5  C007 kept (sleep)', 1, '0', '0', 'C007');
  assert('CM6  C008 kept (sleep)', 1, '0', '0', 'C008');
  assert('CM7  C009 kept', 1, '0', '0', 'C009');
  assert('CM8  C012 removed', 0, 'X', 'X', 'C012');
  assert('CM9  C013 kept', 1, '0', '0', 'C013');
  
  SELECT COUNT(*) INTO vc FROM ADS_CUST_SLEEP_WAKE_DTL WHERE DATA_DATE='20260901';
  IF vc=6 THEN vr:='PASS'; ELSE vr:='FAIL('||vc||')'; END IF;
  DBMS_OUTPUT.PUT_LINE('CM10 Total=6: ' || vr);
END;
/
