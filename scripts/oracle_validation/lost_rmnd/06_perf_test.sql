-- ============================================================
-- Performance test: DTL + STATIS under 10k / 30k / 50k customers
-- ============================================================
SET SERVEROUTPUT ON
SET PAGESIZE 200
SET LINESIZE 200

DECLARE
  v_rc   NUMBER;
  v_t1   NUMBER;
  v_t2   NUMBER;
  v_dtl  NUMBER;
  v_stat NUMBER;
  v_d0   NUMBER;
  v_s0   NUMBER;
  v_batch VARCHAR2(8) := '20260630';
BEGIN
  FOR rec IN (SELECT 10000 AS n FROM dual UNION ALL
              SELECT 30000 FROM dual UNION ALL
              SELECT 50000 FROM dual) LOOP
    EXECUTE IMMEDIATE 'TRUNCATE TABLE DWD_CUST_INDV_INFO';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE DWS_CUST_LVL_INFO';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE DWS_CUST_ASSE_LIAB';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE ADS_CUST_LOST_DTL';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE ADS_CUST_LOST_STATIS';

    EXECUTE IMMEDIATE
      'INSERT INTO DWD_CUST_INDV_INFO(CUST_ID, CUST_NAME, CUST_TYP, PERSN_LEGAL_BK_CODE, ORG_LEAD, HOST_CUST_MNGR_POST_ID)
       SELECT ''PERF''||LPAD(LEVEL,8,''0''), ''C''||LEVEL, ''1'', ''BK10'',
              CASE MOD(LEVEL,3) WHEN 0 THEN ''ORG102'' WHEN 1 THEN ''ORG101'' ELSE ''ORG100'' END,
              CASE WHEN MOD(LEVEL,10)=0 THEN NULL ELSE ''PM1''||MOD(LEVEL,3) END
         FROM dual CONNECT BY LEVEL <= ' || rec.n;

    EXECUTE IMMEDIATE
      'INSERT INTO DWS_CUST_LVL_INFO(DATA_DATE, CUST_ID, CUST_LVL, PERSN_LEGAL_BK_CODE)
       SELECT ''20260531'', ''PERF''||LPAD(LEVEL,8,''0''), CASE MOD(LEVEL,7) WHEN 0 THEN ''07'' ELSE ''04'' END, ''BK10''
         FROM dual CONNECT BY LEVEL <= ' || rec.n;

    -- prev month-end monthly avg (BAL_TYPE=2) around threshold -> most become lost candidates
    EXECUTE IMMEDIATE
      'INSERT INTO DWS_CUST_ASSE_LIAB(DATA_DATE, PERSN_LEGAL_BK_CODE, CUST_ID, ORG_ID, BAL_TYPE, AUM_BAL)
       SELECT ''20260531'', ''BK10'', ''PERF''||LPAD(LEVEL,8,''0''),
              CASE MOD(LEVEL,3) WHEN 0 THEN ''ORG102'' WHEN 1 THEN ''ORG101'' ELSE ''ORG100'' END,
              ''2'', 45000 + MOD(LEVEL, 10000)
         FROM dual CONNECT BY LEVEL <= ' || rec.n;
    -- prev month-end point-in-time below threshold
    EXECUTE IMMEDIATE
      'INSERT INTO DWS_CUST_ASSE_LIAB(DATA_DATE, PERSN_LEGAL_BK_CODE, CUST_ID, ORG_ID, BAL_TYPE, AUM_BAL)
       SELECT ''20260531'', ''BK10'', ''PERF''||LPAD(LEVEL,8,''0''),
              CASE MOD(LEVEL,3) WHEN 0 THEN ''ORG102'' WHEN 1 THEN ''ORG101'' ELSE ''ORG100'' END,
              ''1'', 40000 + MOD(LEVEL, 9000)
         FROM dual CONNECT BY LEVEL <= ' || rec.n;
    -- T-1 point-in-time
    EXECUTE IMMEDIATE
      'INSERT INTO DWS_CUST_ASSE_LIAB(DATA_DATE, PERSN_LEGAL_BK_CODE, CUST_ID, ORG_ID, BAL_TYPE, AUM_BAL)
       SELECT ''20260630'', ''BK10'', ''PERF''||LPAD(LEVEL,8,''0''),
              CASE MOD(LEVEL,3) WHEN 0 THEN ''ORG102'' WHEN 1 THEN ''ORG101'' ELSE ''ORG100'' END,
              ''1'', 40000 + MOD(LEVEL, 60000)
         FROM dual CONNECT BY LEVEL <= ' || rec.n;

    v_t1 := DBMS_UTILITY.GET_TIME;
    PRC_ADS_CUST_LOST_DTL(v_batch, v_rc);
    v_t2 := DBMS_UTILITY.GET_TIME;
    v_dtl := (v_t2 - v_t1) / 100;

    v_t1 := DBMS_UTILITY.GET_TIME;
    PRC_ADS_CUST_LOST_STATIS(v_batch, v_rc);
    v_t2 := DBMS_UTILITY.GET_TIME;
    v_stat := (v_t2 - v_t1) / 100;

    SELECT COUNT(*) INTO v_d0 FROM ADS_CUST_LOST_DTL;
    SELECT COUNT(*) INTO v_s0 FROM ADS_CUST_LOST_STATIS;
    DBMS_OUTPUT.PUT_LINE('N='||rec.n||' | DTL_SEC='||ROUND(v_dtl,3)||
                         ' | STATIS_SEC='||ROUND(v_stat,3)||
                         ' | DTL_ROWS='||v_d0||' | STATIS_ROWS='||v_s0);
  END LOOP;
END;
/

EXIT
