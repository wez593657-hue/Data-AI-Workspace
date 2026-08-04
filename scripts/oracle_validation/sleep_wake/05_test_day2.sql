SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET PAGESIZE 0
SET FEEDBACK OFF
SET VERIFY OFF
SET TRIMSPOOL ON
SET LINESIZE 400

-- ============================================================
-- Day 2 (20260802) Test: Within-month accumulation
-- Builds on Day 1 (20260801) data from 04_test_scenarios.sql
-- ============================================================

-- ============================================================
-- PHASE 6: Setup 20260802 Data
-- ============================================================
BEGIN DBMS_OUTPUT.PUT_LINE('=== PHASE 6: Setup 20260802 Data ==='); END;
/

-- DWS snapshot for 20260802: C005 AUM increases above 100 (but should still be in DTL)
--                            C002 AUM stays same
--                            C003 has new data (but still has active txn within 365d)
--                            NEW: C013 becomes sleep today
INSERT INTO DWD_CUST_INDV_INFO (CUST_ID, CUST_NAME, CUST_TYP, OPEN_DATE, OPEN_ORG, PERSN_LEGAL_BK_CODE)
VALUES ('C013', 'Day2-NewSleep', '01', '20250101', 'ORG003', 'BK01');

INSERT INTO DWS_CUST_LVL_INFO (DATA_DATE, CUST_ID, CUST_LVL, PERSN_LEGAL_BK_CODE)
VALUES ('20260802', 'C013', '01', 'BK01');

INSERT INTO DWD_CUST_MAN (CUST_ID, MNGR_POST_ID, ORG_ID, MNG_TYP, PERSN_LEGAL_BK_CODE)
VALUES ('C013', 'MGR001', 'ORG003', '1', 'BK01');

-- 20260802 DWS baseline for wake comparison
INSERT INTO DWS_CUST_ASSE_LIAB (DATA_DATE, PERSN_LEGAL_BK_CODE, CUST_ID, ORG_ID, BAL_TYPE, AUM_BAL, DEPO_CURNT_DEPO_BAL, FIXD_DEPO_BAL, FIN_BAL, INSUR_BAL)
SELECT '20260801', 'BK01', CUST_ID, 'ORG003', '1', 0, 0, 0, 0, 0
FROM DWD_CUST_INDV_INFO
WHERE CUST_ID = 'C013';

-- 20260802 DWS snapshot
INSERT INTO DWS_CUST_ASSE_LIAB (DATA_DATE, PERSN_LEGAL_BK_CODE, CUST_ID, ORG_ID, BAL_TYPE, AUM_BAL, DEPO_CURNT_DEPO_BAL, FIXD_DEPO_BAL, FIN_BAL, INSUR_BAL)
SELECT '20260802', 'BK01', CUST_ID, 'ORG003', '1',
  CASE CUST_ID
    WHEN 'C010' THEN 30
    WHEN 'C002' THEN 50
    WHEN 'C004' THEN 30
    WHEN 'C005' THEN 200      -- AUM went from 99.99 to 200 (but should stay in DTL on non-month-begin!)
    WHEN 'C007' THEN 30
    WHEN 'C008' THEN 30
    WHEN 'C009' THEN 0.01
    WHEN 'C013' THEN 40       -- New sleep candidate
    ELSE 0
  END,
  0,
  CASE CUST_ID
    WHEN 'C004' THEN 10000    -- Still has 定期
    WHEN 'C005' THEN 200      -- New 活期 (not wake, just normal)
    ELSE 0
  END,
  CASE CUST_ID
    WHEN 'C007' THEN 5000     -- Still has 理财
    ELSE 0
  END,
  CASE CUST_ID
    WHEN 'C008' THEN 5000     -- Still has 保险
    ELSE 0
  END
FROM DWD_CUST_INDV_INFO
WHERE CUST_ID IN ('C010','C002','C004','C005','C007','C008','C009','C013');

-- Contact records for day 2: C002 and C004 are contacted
INSERT INTO ADS_MKT_REC_INFO (MKT_REC_SEQ_ID, CUST_ID, MKT_TYP, MKT_TIME, MKT_PERSN, PERSN_LEGAL_BK_CODE)
VALUES ('MKT001', 'C002', '1', '2026-08-02T10:00:00', 'MGR001', 'BK01');
INSERT INTO ADS_MKT_REC_INFO (MKT_REC_SEQ_ID, CUST_ID, MKT_TYP, MKT_TIME, MKT_PERSN, PERSN_LEGAL_BK_CODE)
VALUES ('MKT002', 'C004', '1', '2026-08-02T11:00:00', 'MGR001', 'BK01');

COMMIT;

DECLARE v_dws NUMBER; v_mkt NUMBER; v_cust NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_dws FROM DWS_CUST_ASSE_LIAB WHERE DATA_DATE='20260802';
  SELECT COUNT(*) INTO v_mkt FROM ADS_MKT_REC_INFO;
  SELECT COUNT(*) INTO v_cust FROM DWD_CUST_INDV_INFO;
  DBMS_OUTPUT.PUT_LINE('Day2 setup: DWS='||v_dws||', MKT='||v_mkt||', TotalCust='||v_cust);
END;
/

-- ============================================================
-- PHASE 7: Execute DTL for 20260802
-- ============================================================
BEGIN DBMS_OUTPUT.PUT_LINE('=== PHASE 7: Execute DTL 20260802 ==='); END;
/

DECLARE v_out INTEGER;
BEGIN
  PRC_ADS_CUST_SLEEP_WAKE_DTL('20260802', v_out);
  DBMS_OUTPUT.PUT_LINE('DTL 20260802 returned: ' || v_out);
END;
/

-- ============================================================
-- PHASE 8: Verify DTL 20260802 Output
-- ============================================================
BEGIN
  DBMS_OUTPUT.PUT_LINE('');
  DBMS_OUTPUT.PUT_LINE('=== PHASE 8: DTL 20260802 Verification ===');
END;
/

SELECT 
  CUST_ID, CUST_NAME,
  FIXD_DEPO_BAL AS FIXD, FIN_AMT AS FIN, INSUR_AMT AS INSUR,
  CNTCT_STATE AS CNTCT, WAKE_STATE AS WAKE
FROM ADS_CUST_SLEEP_WAKE_DTL
WHERE DATA_DATE = '20260802'
ORDER BY CUST_ID;

DECLARE v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count FROM ADS_CUST_SLEEP_WAKE_DTL WHERE DATA_DATE='20260802';
  DBMS_OUTPUT.PUT_LINE('');
  DBMS_OUTPUT.PUT_LINE('Expected: C002,C004,C005,C007,C008,C009,C010,C012,C013 (9 records)');
  DBMS_OUTPUT.PUT_LINE('Actual count: ' || v_count);
END;
/

-- ============================================================
-- Day 2 Assertions
-- ============================================================
BEGIN DBMS_OUTPUT.PUT_LINE(''); DBMS_OUTPUT.PUT_LINE('=== Day 2 Assertions ==='); END;
/

DECLARE
  FUNCTION cnt(p_id VARCHAR2, p_date VARCHAR2 DEFAULT '20260802') RETURN INTEGER IS
    c INTEGER;
  BEGIN
    SELECT COUNT(*) INTO c FROM ADS_CUST_SLEEP_WAKE_DTL WHERE DATA_DATE=p_date AND CUST_ID=p_id;
    RETURN c;
  END;
  FUNCTION w(p_id VARCHAR2) RETURN CHAR IS
    r CHAR(1);
  BEGIN
    BEGIN SELECT MAX(WAKE_STATE) INTO r FROM ADS_CUST_SLEEP_WAKE_DTL WHERE DATA_DATE='20260802' AND CUST_ID=p_id; EXCEPTION WHEN NO_DATA_FOUND THEN r:='X'; END;
    RETURN r;
  END;
  FUNCTION ct(p_id VARCHAR2) RETURN CHAR IS
    r CHAR(1);
  BEGIN
    BEGIN SELECT MAX(CNTCT_STATE) INTO r FROM ADS_CUST_SLEEP_WAKE_DTL WHERE DATA_DATE='20260802' AND CUST_ID=p_id; EXCEPTION WHEN NO_DATA_FOUND THEN r:='X'; END;
    RETURN r;
  END;
  FUNCTION ok(descrip VARCHAR2, exp VARCHAR2, act VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    IF exp=act THEN RETURN 'PASS'; ELSE RETURN 'FAIL(exp='||exp||' act='||act||')'; END IF;
  END;
BEGIN
  -- D1: Contact state accumulation - C002 contacted → CNTCT=1
  DBMS_OUTPUT.PUT_LINE('D1  C002 CNTCT=1 (contacted day2): ' || ok('CNTCT','1',ct('C002')));
  -- D2: Contact state accumulation - C004 contacted → CNTCT=1
  DBMS_OUTPUT.PUT_LINE('D2  C004 CNTCT=1 (contacted day2): ' || ok('CNTCT','1',ct('C004')));
  -- D3: C010 not contacted day2 → CNTCT=0
  DBMS_OUTPUT.PUT_LINE('D3  C010 CNTCT=0 (no contact): ' || ok('CNTCT','0',ct('C010')));
  -- D4: WAKE state persistence - C004 still WAKE=1
  DBMS_OUTPUT.PUT_LINE('D4  C004 WAKE=1 (persisted): ' || ok('WAKE','1',w('C004')));
  -- D5: WAKE state persistence - C012 still WAKE=1
  DBMS_OUTPUT.PUT_LINE('D5  C012 WAKE=1 (persisted): ' || ok('WAKE','1',w('C012')));
  -- D6: C005 still in DTL (AUM now 200, but non-month-begin, only-in never-out)
  DBMS_OUTPUT.PUT_LINE('D6  C005 kept (only-in never-out): ' || ok('CNT','1',CAST(cnt('C005') AS VARCHAR2(1))));
  -- D7: C013 new sleep → in DTL
  DBMS_OUTPUT.PUT_LINE('D7  C013 new sleep (day2): ' || ok('CNT','1',CAST(cnt('C013') AS VARCHAR2(1))));
  -- D8: C010 still in DTL
  DBMS_OUTPUT.PUT_LINE('D8  C010 kept (carryover): ' || ok('CNT','1',CAST(cnt('C010') AS VARCHAR2(1))));
  -- D9: Total count = 9
  DECLARE vc NUMBER; vr VARCHAR2(20);
  BEGIN
    SELECT COUNT(*) INTO vc FROM ADS_CUST_SLEEP_WAKE_DTL WHERE DATA_DATE='20260802';
    IF vc=9 THEN vr:='PASS'; ELSE vr:='FAIL('||vc||')'; END IF;
    DBMS_OUTPUT.PUT_LINE('D9  Total=9: ' || vr);
  END;
END;
/
