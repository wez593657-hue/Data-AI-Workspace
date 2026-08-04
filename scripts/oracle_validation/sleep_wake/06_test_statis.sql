SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET PAGESIZE 0
SET FEEDBACK OFF
SET VERIFY OFF
SET TRIMSPOOL ON
SET LINESIZE 400

-- ============================================================
-- STATIS Test for 20260801 and 20260802
-- ============================================================

-- ============================================================
-- PHASE 9: Execute STATIS for 20260801
-- ============================================================
BEGIN DBMS_OUTPUT.PUT_LINE('=== STATIS 20260801 ==='); END;
/

DECLARE v_out INTEGER;
BEGIN
  PRC_ADS_CUST_SLEEP_WAKE_STATIS('20260801', v_out);
  DBMS_OUTPUT.PUT_LINE('STATIS 20260801 returned: ' || v_out);
END;
/

SELECT STATIS_OBJ AS OBJ, STATIS_CYCLE AS CYC, 
       CUST_CNT, CNTCT_CUST_CNT AS CNTCT_N, CNTCT_RATE,
       WAKE_CUST_CNT AS WAKE_N, WAKE_RATE
FROM ADS_CUST_SLEEP_WAKE_STATIS
WHERE DATA_DATE = '20260801'
ORDER BY STATIS_OBJ;

DECLARE vc NUMBER;
BEGIN
  SELECT COUNT(*) INTO vc FROM ADS_CUST_SLEEP_WAKE_STATIS WHERE DATA_DATE='20260801';
  DBMS_OUTPUT.PUT_LINE('STATIS 20260801 records: ' || vc);
END;
/

-- ============================================================
-- STATIS Assertions for 20260801
-- ============================================================
BEGIN DBMS_OUTPUT.PUT_LINE(''); DBMS_OUTPUT.PUT_LINE('=== STATIS 20260801 Assertions ==='); END;
/

-- Expected statistics for 20260801 (8 DTL records):
-- C002: CNTCT=0, WAKE=0
-- C004: CNTCT=0, WAKE=1
-- C005: CNTCT=0, WAKE=0
-- C007: CNTCT=0, WAKE=1
-- C008: CNTCT=0, WAKE=1
-- C009: CNTCT=0, WAKE=0
-- C010: CNTCT=0, WAKE=0
-- C012: CNTCT=0, WAKE=1
-- Total: 8, CNTCT=0, WAKE=4, WAKE_RATE=50%

DECLARE
  v_cust_cnt    NUMBER;
  v_cntct_cnt   NUMBER;
  v_wake_cnt    NUMBER;
  v_wake_rate   NUMBER;
  v_result      VARCHAR2(20);
BEGIN
  -- Get manager-level stats (POST_ID = MGR001)
  BEGIN
    SELECT CUST_CNT, CNTCT_CUST_CNT, WAKE_CUST_CNT, WAKE_RATE
    INTO v_cust_cnt, v_cntct_cnt, v_wake_cnt, v_wake_rate
    FROM ADS_CUST_SLEEP_WAKE_STATIS
    WHERE DATA_DATE='20260801' AND STATIS_OBJ='MGR001';
  EXCEPTION WHEN NO_DATA_FOUND THEN
    v_cust_cnt := -1; v_cntct_cnt := -1; v_wake_cnt := -1; v_wake_rate := -1;
  END;
  
  DBMS_OUTPUT.PUT_LINE('Manager MGR001 stats:');
  DBMS_OUTPUT.PUT_LINE('  CUST_CNT='||v_cust_cnt||' (expect 8)');
  DBMS_OUTPUT.PUT_LINE('  CNTCT_CUST_CNT='||v_cntct_cnt||' (expect 0)');
  DBMS_OUTPUT.PUT_LINE('  WAKE_CUST_CNT='||v_wake_cnt||' (expect 4)');
  DBMS_OUTPUT.PUT_LINE('  WAKE_RATE='||v_wake_rate||' (expect 50)');
  
  IF v_cust_cnt = 8 THEN v_result:='PASS'; ELSE v_result:='FAIL'; END IF;
  DBMS_OUTPUT.PUT_LINE('S1 CUST_CNT=8: '||v_result);
  
  IF v_cntct_cnt = 0 THEN v_result:='PASS'; ELSE v_result:='FAIL'; END IF;
  DBMS_OUTPUT.PUT_LINE('S2 CNTCT=0: '||v_result);
  
  IF v_wake_cnt = 4 THEN v_result:='PASS'; ELSE v_result:='FAIL'; END IF;
  DBMS_OUTPUT.PUT_LINE('S3 WAKE=4: '||v_result);
  
  IF v_wake_rate = 50 THEN v_result:='PASS'; ELSE v_result:='FAIL'; END IF;
  DBMS_OUTPUT.PUT_LINE('S4 WAKE_RATE=50: '||v_result);
END;
/

-- ============================================================
-- PHASE 10: Execute STATIS for 20260802
-- ============================================================
BEGIN
  DBMS_OUTPUT.PUT_LINE('');
  DBMS_OUTPUT.PUT_LINE('=== STATIS 20260802 ===');
END;
/

DECLARE v_out INTEGER;
BEGIN
  PRC_ADS_CUST_SLEEP_WAKE_STATIS('20260802', v_out);
  DBMS_OUTPUT.PUT_LINE('STATIS 20260802 returned: ' || v_out);
END;
/

SELECT STATIS_OBJ AS OBJ, STATIS_CYCLE AS CYC, 
       CUST_CNT, CNTCT_CUST_CNT AS CNTCT_N, CNTCT_RATE,
       WAKE_CUST_CNT AS WAKE_N, WAKE_RATE
FROM ADS_CUST_SLEEP_WAKE_STATIS
WHERE DATA_DATE = '20260802'
ORDER BY STATIS_OBJ;

DECLARE vc NUMBER;
BEGIN
  SELECT COUNT(*) INTO vc FROM ADS_CUST_SLEEP_WAKE_STATIS WHERE DATA_DATE='20260802';
  DBMS_OUTPUT.PUT_LINE('STATIS 20260802 records: ' || vc);
END;
/

-- ============================================================
-- STATIS Assertions for 20260802
-- ============================================================
BEGIN DBMS_OUTPUT.PUT_LINE(''); DBMS_OUTPUT.PUT_LINE('=== STATIS 20260802 Assertions ==='); END;
/

-- Expected for 20260802 (9 DTL records):
-- C002: CNTCT=1, WAKE=0
-- C004: CNTCT=1, WAKE=1
-- C005: CNTCT=0, WAKE=1
-- C007: CNTCT=0, WAKE=1
-- C008: CNTCT=0, WAKE=1
-- C009: CNTCT=0, WAKE=0
-- C010: CNTCT=0, WAKE=0
-- C012: CNTCT=0, WAKE=1
-- C013: CNTCT=0, WAKE=0
-- Total: 9, CNTCT=2, WAKE=5

DECLARE
  v_cust_cnt    NUMBER;
  v_cntct_cnt   NUMBER;
  v_wake_cnt    NUMBER;
  v_wake_rate   NUMBER;
  v_cntct_rate  NUMBER;
  v_result      VARCHAR2(20);
BEGIN
  BEGIN
    SELECT CUST_CNT, CNTCT_CUST_CNT, WAKE_CUST_CNT, WAKE_RATE, CNTCT_RATE
    INTO v_cust_cnt, v_cntct_cnt, v_wake_cnt, v_wake_rate, v_cntct_rate
    FROM ADS_CUST_SLEEP_WAKE_STATIS
    WHERE DATA_DATE='20260802' AND STATIS_OBJ='MGR001';
  EXCEPTION WHEN NO_DATA_FOUND THEN
    v_cust_cnt := -1; v_cntct_cnt := -1; v_wake_cnt := -1; v_wake_rate := -1; v_cntct_rate := -1;
  END;
  
  DBMS_OUTPUT.PUT_LINE('Manager MGR001 stats (day2):');
  DBMS_OUTPUT.PUT_LINE('  CUST_CNT='||v_cust_cnt||' (expect 9)');
  DBMS_OUTPUT.PUT_LINE('  CNTCT_CUST_CNT='||v_cntct_cnt||' (expect 2)');
  DBMS_OUTPUT.PUT_LINE('  WAKE_CUST_CNT='||v_wake_cnt||' (expect 5)');
  DBMS_OUTPUT.PUT_LINE('  CNTCT_RATE='||v_cntct_rate);
  DBMS_OUTPUT.PUT_LINE('  WAKE_RATE='||v_wake_rate);
  
  IF v_cust_cnt = 9 THEN v_result:='PASS'; ELSE v_result:='FAIL'; END IF;
  DBMS_OUTPUT.PUT_LINE('S5 CUST_CNT=9: '||v_result);
  
  IF v_cntct_cnt = 2 THEN v_result:='PASS'; ELSE v_result:='FAIL'; END IF;
  DBMS_OUTPUT.PUT_LINE('S6 CNTCT=2: '||v_result);
  
  IF v_wake_cnt = 5 THEN v_result:='PASS'; ELSE v_result:='FAIL'; END IF;
  DBMS_OUTPUT.PUT_LINE('S7 WAKE=5: '||v_result);
END;
/
