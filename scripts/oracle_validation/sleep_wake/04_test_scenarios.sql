SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET PAGESIZE 0
SET FEEDBACK OFF
SET VERIFY OFF
SET TRIMSPOOL ON
SET LINESIZE 400

-- ============================================================
-- Sleep Wake v2.11.0 Comprehensive Test Script
-- ============================================================

-- ============================================================
-- PHASE 0: Clean all test data
-- ============================================================
BEGIN DBMS_OUTPUT.PUT_LINE('=== PHASE 0: Clean All Test Data ==='); END;
/

DELETE FROM ADS_CUST_SLEEP_WAKE_DTL;
DELETE FROM ADS_CUST_SLEEP_WAKE_STATIS;
DELETE FROM DWD_CUST_INDV_INFO;
DELETE FROM DWS_CUST_ASSE_LIAB;
DELETE FROM DWD_TX_ASET;
DELETE FROM DWD_CUST_MAN;
DELETE FROM DWS_CUST_LVL_INFO;
DELETE FROM DWD_SYS_ORG;
DELETE FROM ADS_MKT_REC_INFO;
COMMIT;

BEGIN
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_ADS_SLEEP_WAKE_BASE';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_ADS_SLEEP_CANDIDATE';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_ADS_SLEEP_STAT_SRC';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_ADS_SLEEP_DWS_WAKE';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_ADS_SLEEP_CNTCT';
END;
/

-- ============================================================
-- PHASE 1: Setup Base Data
-- ============================================================
BEGIN DBMS_OUTPUT.PUT_LINE('=== PHASE 1: Setup Base Data ==='); END;
/

-- Org hierarchy
INSERT INTO DWD_SYS_ORG (ORG_ID, SUP_ORG_ID, ORG_NAME, ORG_TYP, ORG_STATE, PERSN_LEGAL_BK_CODE)
VALUES ('ORG001', NULL, 'Root Org', '1', '1', 'BK01');
INSERT INTO DWD_SYS_ORG (ORG_ID, SUP_ORG_ID, ORG_NAME, ORG_TYP, ORG_STATE, PERSN_LEGAL_BK_CODE)
VALUES ('ORG002', 'ORG001', 'Mid Org', '2', '1', 'BK01');
INSERT INTO DWD_SYS_ORG (ORG_ID, SUP_ORG_ID, ORG_NAME, ORG_TYP, ORG_STATE, PERSN_LEGAL_BK_CODE)
VALUES ('ORG003', 'ORG002', 'Leaf Org', '3', '1', 'BK01');

-- Customers: all under BK01/ORG003
-- C010: Month-begin review - still sleep (was in T-1 DTL, AUM still <100)
-- C011: Month-begin review - no longer sleep (was in T-1 DTL, AUM now >=100, no wake)
-- C012: Month-begin review - woken (was in T-1 DTL, AUM>=100 but with new products, F-10)
-- C001: Never sleep (AUM high)
-- C002: New sleep candidate (AUM<100, no active txn)
-- C003: Has active txn (AUM<100 but JIOYCFFS=0 in 365d) → NOT sleep
-- C004: New sleep + wake by FIXD_DEPO (AUM=30, FIXD 0→10000)
-- C005: AUM edge 99.99 (should be sleep)
-- C006: AUM edge 100.00 (should NOT be sleep)
-- C007: New sleep + wake by FIN_BAL (AUM=30, FIN 0→5000)
-- C008: New sleep + wake by INSUR_BAL (AUM=30, INSUR 0→5000)
-- C009: AUM edge 0.01 (near zero)
INSERT INTO DWD_CUST_INDV_INFO (CUST_ID, CUST_NAME, CUST_TYP, OPEN_DATE, OPEN_ORG, PERSN_LEGAL_BK_CODE)
VALUES ('C010', 'MthBegin-StillSleep', '01', '20250101', 'ORG003', 'BK01');
INSERT INTO DWD_CUST_INDV_INFO (CUST_ID, CUST_NAME, CUST_TYP, OPEN_DATE, OPEN_ORG, PERSN_LEGAL_BK_CODE)
VALUES ('C011', 'MthBegin-NoLongerSleep', '01', '20250101', 'ORG003', 'BK01');
INSERT INTO DWD_CUST_INDV_INFO (CUST_ID, CUST_NAME, CUST_TYP, OPEN_DATE, OPEN_ORG, PERSN_LEGAL_BK_CODE)
VALUES ('C012', 'MthBegin-Woken-F10', '01', '20250101', 'ORG003', 'BK01');
INSERT INTO DWD_CUST_INDV_INFO (CUST_ID, CUST_NAME, CUST_TYP, OPEN_DATE, OPEN_ORG, PERSN_LEGAL_BK_CODE)
VALUES ('C001', 'NonSleep-HighAUM', '01', '20250101', 'ORG003', 'BK01');
INSERT INTO DWD_CUST_INDV_INFO (CUST_ID, CUST_NAME, CUST_TYP, OPEN_DATE, OPEN_ORG, PERSN_LEGAL_BK_CODE)
VALUES ('C002', 'Day1-NewSleep', '01', '20250101', 'ORG003', 'BK01');
INSERT INTO DWD_CUST_INDV_INFO (CUST_ID, CUST_NAME, CUST_TYP, OPEN_DATE, OPEN_ORG, PERSN_LEGAL_BK_CODE)
VALUES ('C003', 'Day1-HasActiveTxn', '01', '20250101', 'ORG003', 'BK01');
INSERT INTO DWD_CUST_INDV_INFO (CUST_ID, CUST_NAME, CUST_TYP, OPEN_DATE, OPEN_ORG, PERSN_LEGAL_BK_CODE)
VALUES ('C004', 'Day1-WakeByFixd', '01', '20250101', 'ORG003', 'BK01');
INSERT INTO DWD_CUST_INDV_INFO (CUST_ID, CUST_NAME, CUST_TYP, OPEN_DATE, OPEN_ORG, PERSN_LEGAL_BK_CODE)
VALUES ('C005', 'Day1-AUM-Edge-99', '01', '20250101', 'ORG003', 'BK01');
INSERT INTO DWD_CUST_INDV_INFO (CUST_ID, CUST_NAME, CUST_TYP, OPEN_DATE, OPEN_ORG, PERSN_LEGAL_BK_CODE)
VALUES ('C006', 'Day1-AUM-Edge-100', '01', '20250101', 'ORG003', 'BK01');
INSERT INTO DWD_CUST_INDV_INFO (CUST_ID, CUST_NAME, CUST_TYP, OPEN_DATE, OPEN_ORG, PERSN_LEGAL_BK_CODE)
VALUES ('C007', 'Day1-WakeByFin', '01', '20250101', 'ORG003', 'BK01');
INSERT INTO DWD_CUST_INDV_INFO (CUST_ID, CUST_NAME, CUST_TYP, OPEN_DATE, OPEN_ORG, PERSN_LEGAL_BK_CODE)
VALUES ('C008', 'Day1-WakeByInsur', '01', '20250101', 'ORG003', 'BK01');
INSERT INTO DWD_CUST_INDV_INFO (CUST_ID, CUST_NAME, CUST_TYP, OPEN_DATE, OPEN_ORG, PERSN_LEGAL_BK_CODE)
VALUES ('C009', 'Day1-AUM-Edge-001', '01', '20250101', 'ORG003', 'BK01');

-- Customer levels
INSERT INTO DWS_CUST_LVL_INFO (DATA_DATE, CUST_ID, CUST_LVL, PERSN_LEGAL_BK_CODE)
SELECT '20260801', CUST_ID, '01', 'BK01' FROM DWD_CUST_INDV_INFO;

-- Manager relationships
INSERT INTO DWD_CUST_MAN (CUST_ID, MNGR_POST_ID, ORG_ID, MNG_TYP, PERSN_LEGAL_BK_CODE)
SELECT CUST_ID, 'MGR001', 'ORG003', '1', 'BK01' FROM DWD_CUST_INDV_INFO;

COMMIT;

DECLARE
  v_cust_cnt NUMBER;
  v_org_cnt  NUMBER;
  v_mgr_cnt  NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_cust_cnt FROM DWD_CUST_INDV_INFO;
  SELECT COUNT(*) INTO v_org_cnt FROM DWD_SYS_ORG;
  SELECT COUNT(*) INTO v_mgr_cnt FROM DWD_CUST_MAN;
  DBMS_OUTPUT.PUT_LINE('Base data: Customers=' || v_cust_cnt || ', Org=' || v_org_cnt || ', Manager=' || v_mgr_cnt);
END;
/

-- ============================================================
-- PHASE 2: Setup T-1 (20260731) Data
-- ============================================================
BEGIN DBMS_OUTPUT.PUT_LINE('=== PHASE 2: Setup T-1 (20260731) ==='); END;
/

-- T-1 DWS baseline (20260731): all products=0 for wake comparison
INSERT INTO DWS_CUST_ASSE_LIAB (DATA_DATE, PERSN_LEGAL_BK_CODE, CUST_ID, ORG_ID, BAL_TYPE, AUM_BAL, DEPO_CURNT_DEPO_BAL, FIXD_DEPO_BAL, FIN_BAL, INSUR_BAL)
SELECT '20260731', 'BK01', CUST_ID, 'ORG003', '1',
  CASE CUST_ID
    WHEN 'C001' THEN 50000
    WHEN 'C010' THEN 30
    WHEN 'C011' THEN 30
    WHEN 'C012' THEN 30
    ELSE 0
  END, 0, 0, 0, 0
FROM DWD_CUST_INDV_INFO;

-- T-1 DTL: C010, C011, C012 were sleep on 20260731
INSERT INTO ADS_CUST_SLEEP_WAKE_DTL (
  PERSN_LEGAL_BK_CODE, DATA_DATE, CUST_ID, CUST_NAME, CUST_LVL,
  DEPO_CURNT_DEPO_BAL, FIXD_DEPO_BAL, FIN_AMT, INSUR_AMT,
  CNTCT_STATE, WAKE_STATE, POST_ID, ORG_ID, STATIS_CYCLE
)
SELECT 'BK01', '20260731', c.CUST_ID, c.CUST_NAME, '01',
  0, 0, 0, 0,
  CASE c.CUST_ID WHEN 'C010' THEN '1' ELSE '0' END, '0',
  'MGR001', 'ORG003', 'M'
FROM DWD_CUST_INDV_INFO c
WHERE c.CUST_ID IN ('C010', 'C011', 'C012');

COMMIT;

DECLARE
  v_dtl_cnt NUMBER;
  v_dws_cnt NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_dtl_cnt FROM ADS_CUST_SLEEP_WAKE_DTL;
  SELECT COUNT(*) INTO v_dws_cnt FROM DWS_CUST_ASSE_LIAB WHERE DATA_DATE='20260731';
  DBMS_OUTPUT.PUT_LINE('T-1: DTL=' || v_dtl_cnt || ', DWS=' || v_dws_cnt);
END;
/

-- ============================================================
-- PHASE 3: Setup 20260801 Data
-- ============================================================
BEGIN DBMS_OUTPUT.PUT_LINE('=== PHASE 3: Setup 20260801 Data ==='); END;
/

INSERT INTO DWS_CUST_ASSE_LIAB (DATA_DATE, PERSN_LEGAL_BK_CODE, CUST_ID, ORG_ID, BAL_TYPE, AUM_BAL, DEPO_CURNT_DEPO_BAL, FIXD_DEPO_BAL, FIN_BAL, INSUR_BAL)
SELECT '20260801', 'BK01', CUST_ID, 'ORG003', '1',
  CASE CUST_ID
    WHEN 'C001' THEN 50000
    WHEN 'C010' THEN 30
    WHEN 'C011' THEN 500
    WHEN 'C012' THEN 500
    WHEN 'C002' THEN 50
    WHEN 'C003' THEN 30
    WHEN 'C004' THEN 30
    WHEN 'C005' THEN 99.99
    WHEN 'C006' THEN 100.00
    WHEN 'C007' THEN 30
    WHEN 'C008' THEN 30
    WHEN 'C009' THEN 0.01
  END,
  CASE CUST_ID
    WHEN 'C011' THEN 500
    WHEN 'C012' THEN 500
    ELSE 0
  END,
  CASE CUST_ID
    WHEN 'C012' THEN 5000
    WHEN 'C004' THEN 10000
    ELSE 0
  END,
  CASE CUST_ID
    WHEN 'C007' THEN 5000
    ELSE 0
  END,
  CASE CUST_ID
    WHEN 'C008' THEN 5000
    ELSE 0
  END
FROM DWD_CUST_INDV_INFO
WHERE NOT EXISTS (
  SELECT 1 FROM DWS_CUST_ASSE_LIAB a WHERE a.DATA_DATE='20260801' AND a.CUST_ID=DWD_CUST_INDV_INFO.CUST_ID
);

-- C003 has active txn (JIOYCFFS='0') in last 365 days → NOT sleep
INSERT INTO DWD_TX_ASET (SEQ_ID, CUST_ID, TX_DATE, JIOYCFFS, PERSN_LEGAL_BK_CODE, AMT)
VALUES ('TX001', 'C003', '2026-08-01', '0', 'BK01', 100);

-- C002 has passive txn (JIOYCFFS!='0') → still sleep
INSERT INTO DWD_TX_ASET (SEQ_ID, CUST_ID, TX_DATE, JIOYCFFS, PERSN_LEGAL_BK_CODE, AMT)
VALUES ('TX002', 'C002', '2026-07-30', '1', 'BK01', 50);

COMMIT;

DECLARE
  v_dws_cnt NUMBER;
  v_tx_cnt  NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_dws_cnt FROM DWS_CUST_ASSE_LIAB WHERE DATA_DATE='20260801';
  SELECT COUNT(*) INTO v_tx_cnt FROM DWD_TX_ASET;
  DBMS_OUTPUT.PUT_LINE('20260801: DWS=' || v_dws_cnt || ', TX_ASET=' || v_tx_cnt);
END;
/

-- ============================================================
-- PHASE 4: Execute DTL for 20260801 (Month Begin)
-- ============================================================
BEGIN DBMS_OUTPUT.PUT_LINE('=== PHASE 4: Execute DTL 20260801 ==='); END;
/

DECLARE
  v_out INTEGER;
BEGIN
  PRC_ADS_CUST_SLEEP_WAKE_DTL('20260801', v_out);
  DBMS_OUTPUT.PUT_LINE('DTL returned: ' || v_out);
END;
/

-- ============================================================
-- PHASE 5: Verify DTL Output
-- ============================================================
BEGIN
  DBMS_OUTPUT.PUT_LINE('');
  DBMS_OUTPUT.PUT_LINE('=== PHASE 5: DTL Verification ===');
  DBMS_OUTPUT.PUT_LINE('');
END;
/

SELECT 
  CUST_ID,
  CUST_NAME,
  DEPO_CURNT_DEPO_BAL AS DEPO,
  FIXD_DEPO_BAL AS FIXD,
  FIN_AMT AS FIN,
  INSUR_AMT AS INSUR,
  CNTCT_STATE AS CNTCT,
  WAKE_STATE AS WAKE,
  STATIS_CYCLE AS CYCLE
FROM ADS_CUST_SLEEP_WAKE_DTL
WHERE DATA_DATE = '20260801'
ORDER BY CUST_ID;

DECLARE
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count FROM ADS_CUST_SLEEP_WAKE_DTL WHERE DATA_DATE='20260801';
  DBMS_OUTPUT.PUT_LINE('');
  DBMS_OUTPUT.PUT_LINE('Expected DTL customers: C002,C004,C005,C007,C008,C009,C010,C012 (8 records)');
  DBMS_OUTPUT.PUT_LINE('Actual DTL count: ' || v_count);
END;
/

-- ============================================================
-- Assertions
-- ============================================================
BEGIN
  DBMS_OUTPUT.PUT_LINE('');
  DBMS_OUTPUT.PUT_LINE('=== Assertions ===');
END;
/

-- Helper: check existence and return PASS/FAIL
DECLARE
  v_cnt   INTEGER;
  v_wake  CHAR(1);
  v_val   NUMBER;
  v_result VARCHAR2(10);
  FUNCTION check_cnt(p_cust_id VARCHAR2, p_expected INTEGER) RETURN VARCHAR2 IS
    c INTEGER;
  BEGIN
    SELECT COUNT(*) INTO c FROM ADS_CUST_SLEEP_WAKE_DTL WHERE DATA_DATE='20260801' AND CUST_ID=p_cust_id;
    IF c = p_expected THEN RETURN 'PASS'; ELSE RETURN 'FAIL('||c||')'; END IF;
  END;
  FUNCTION check_wake(p_cust_id VARCHAR2, p_expected CHAR) RETURN VARCHAR2 IS
    w CHAR(1);
  BEGIN
    BEGIN SELECT MAX(WAKE_STATE) INTO w FROM ADS_CUST_SLEEP_WAKE_DTL WHERE DATA_DATE='20260801' AND CUST_ID=p_cust_id; EXCEPTION WHEN NO_DATA_FOUND THEN w := 'X'; END;
    IF w = p_expected OR (w IS NULL AND p_expected='X') THEN RETURN 'PASS'; ELSE RETURN 'FAIL('||w||')'; END IF;
  END;
  FUNCTION check_cntct(p_cust_id VARCHAR2, p_expected CHAR) RETURN VARCHAR2 IS
    ct CHAR(1);
  BEGIN
    BEGIN SELECT MAX(CNTCT_STATE) INTO ct FROM ADS_CUST_SLEEP_WAKE_DTL WHERE DATA_DATE='20260801' AND CUST_ID=p_cust_id; EXCEPTION WHEN NO_DATA_FOUND THEN ct := 'X'; END;
    IF ct = p_expected OR (ct IS NULL AND p_expected='X') THEN RETURN 'PASS'; ELSE RETURN 'FAIL('||ct||')'; END IF;
  END;
BEGIN
  -- A1: C011 removed (no longer sleep, AUM>=100, no wake)
  DBMS_OUTPUT.PUT_LINE('A1  C011 removed (AUM>=100,no wake): ' || check_cnt('C011',0));
  
  -- A2: C010 retained (still sleep, AUM=30<100)
  DBMS_OUTPUT.PUT_LINE('A2  C010 kept (still sleep): ' || check_cnt('C010',1));
  DBMS_OUTPUT.PUT_LINE('A2b C010 WAKE=0: ' || check_wake('C010','0'));
  DBMS_OUTPUT.PUT_LINE('A2c C010 CNTCT reset(month): ' || check_cntct('C010','0'));
  
  -- A3: C012 retained with WAKE=1 (F-10: woken, AUM>=100 but baseline=0→today>0)
  DBMS_OUTPUT.PUT_LINE('A3  C012 kept (F-10 wake): ' || check_cnt('C012',1));
  DBMS_OUTPUT.PUT_LINE('A3b C012 WAKE=1: ' || check_wake('C012','1'));
  
  -- A4: C001 not in DTL (AUM=50000)
  DBMS_OUTPUT.PUT_LINE('A4  C001 not in DTL: ' || check_cnt('C001',0));
  
  -- A5: C002 in DTL (new sleep, AUM=50, only passive txn)
  DBMS_OUTPUT.PUT_LINE('A5  C002 in DTL (AUM=50): ' || check_cnt('C002',1));
  DBMS_OUTPUT.PUT_LINE('A5b C002 WAKE=0: ' || check_wake('C002','0'));
  
  -- A6: C003 not in DTL (AUM<100 but active txn in 365d)
  DBMS_OUTPUT.PUT_LINE('A6  C003 not in DTL (active txn): ' || check_cnt('C003',0));
  
  -- A7: C004 in DTL with WAKE=1 (定期 wake)
  DBMS_OUTPUT.PUT_LINE('A7  C004 in DTL (wake by FIXD): ' || check_cnt('C004',1));
  DBMS_OUTPUT.PUT_LINE('A7b C004 WAKE=1: ' || check_wake('C004','1'));
  
  -- A8: C005 in DTL (AUM=99.99, edge <100)
  DBMS_OUTPUT.PUT_LINE('A8  C005 in DTL (AUM=99.99): ' || check_cnt('C005',1));
  
  -- A9: C006 not in DTL (AUM=100.00, NOT <100)
  DBMS_OUTPUT.PUT_LINE('A9  C006 not in DTL (AUM=100): ' || check_cnt('C006',0));
  
  -- A10: C007 in DTL with WAKE=1 (理财 wake, AUM=30)
  DBMS_OUTPUT.PUT_LINE('A10 C007 in DTL (wake by FIN): ' || check_cnt('C007',1));
  DBMS_OUTPUT.PUT_LINE('A10b C007 WAKE=1: ' || check_wake('C007','1'));
  
  -- A11: C008 in DTL with WAKE=1 (保险 wake, AUM=30)
  DBMS_OUTPUT.PUT_LINE('A11 C008 in DTL (wake by INSUR): ' || check_cnt('C008',1));
  DBMS_OUTPUT.PUT_LINE('A11b C008 WAKE=1: ' || check_wake('C008','1'));
  
  -- A12: C009 in DTL (AUM=0.01, edge near 0)
  DBMS_OUTPUT.PUT_LINE('A12 C009 in DTL (AUM=0.01): ' || check_cnt('C009',1));
  
  -- A13: Total = 8
  SELECT COUNT(*) INTO v_cnt FROM ADS_CUST_SLEEP_WAKE_DTL WHERE DATA_DATE='20260801';
  IF v_cnt = 8 THEN v_result := 'PASS'; ELSE v_result := 'FAIL('||v_cnt||')'; END IF;
  DBMS_OUTPUT.PUT_LINE('A13 Total=8: ' || v_result);
END;
/
