-- ============================================================
-- Performance test: DTL + STATIS under 10k / 30k / 50k customers
-- ============================================================
SET SERVEROUTPUT ON
SET PAGESIZE 200
SET LINESIZE 200

DECLARE
  v_rc    NUMBER;
  v_t1    NUMBER;
  v_t2    NUMBER;
  v_dtl   NUMBER;
  v_stat  NUMBER;
  v_dtl0  NUMBER;
  v_stat0 NUMBER;
  v_batch VARCHAR2(8) := '20260630';
BEGIN
  FOR rec IN (SELECT 10000 AS n FROM dual UNION ALL
              SELECT 30000 FROM dual UNION ALL
              SELECT 50000 FROM dual) LOOP

    EXECUTE IMMEDIATE 'TRUNCATE TABLE DWD_CUST_INDV_INFO';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE DWS_CUST_ASSE_LIAB';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE ADS_CUST_POTN_UPGRADE_CUST_DTL';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE ADS_CUST_POTN_UPGRADE_STATIS';

    -- customers
    EXECUTE IMMEDIATE
      'INSERT INTO DWD_CUST_INDV_INFO(CUST_ID, CUST_NAME, CUST_TYP, PERSN_LEGAL_BK_CODE, ORG_LEAD)
       SELECT ''PERF''||LPAD(LEVEL,8,''0''), ''C''||LEVEL, ''1'', ''BK10'', CASE MOD(LEVEL,3) WHEN 0 THEN ''ORG102'' WHEN 1 THEN ''ORG101'' ELSE ''ORG100'' END
         FROM dual CONNECT BY LEVEL <= ' || rec.n;

    -- previous month-end monthly avg (drives LVL_CRIT across 5 bands)
    EXECUTE IMMEDIATE
      'INSERT INTO DWS_CUST_ASSE_LIAB(DATA_DATE, PERSN_LEGAL_BK_CODE, CUST_ID, ORG_ID, BAL_TYPE, AUM_BAL)
       SELECT ''20260531'', ''BK10'', ''PERF''||LPAD(LEVEL,8,''0''),
              CASE MOD(LEVEL,3) WHEN 0 THEN ''ORG102'' WHEN 1 THEN ''ORG101'' ELSE ''ORG100'' END,
              ''2'',
              CASE MOD(LEVEL,5)
                WHEN 0 THEN 45000 + MOD(LEVEL,5000)
                WHEN 1 THEN 270000 + MOD(LEVEL,30000)
                WHEN 2 THEN 450000 + MOD(LEVEL,50000)
                WHEN 3 THEN 900000 + MOD(LEVEL,100000)
                ELSE        2700000 + MOD(LEVEL,300000)
              END
         FROM dual CONNECT BY LEVEL <= ' || rec.n;

    -- T-1 point-in-time (BAL_TYPE=1) and current monthly avg (BAL_TYPE=2)
    EXECUTE IMMEDIATE
      'INSERT INTO DWS_CUST_ASSE_LIAB(DATA_DATE, PERSN_LEGAL_BK_CODE, CUST_ID, ORG_ID, BAL_TYPE, AUM_BAL)
       SELECT ''20260630'', ''BK10'', ''PERF''||LPAD(LEVEL,8,''0''),
              CASE MOD(LEVEL,3) WHEN 0 THEN ''ORG102'' WHEN 1 THEN ''ORG101'' ELSE ''ORG100'' END,
              ''1'', 45000 + MOD(LEVEL, 3500000)
         FROM dual CONNECT BY LEVEL <= ' || rec.n;
    EXECUTE IMMEDIATE
      'INSERT INTO DWS_CUST_ASSE_LIAB(DATA_DATE, PERSN_LEGAL_BK_CODE, CUST_ID, ORG_ID, BAL_TYPE, AUM_BAL)
       SELECT ''20260630'', ''BK10'', ''PERF''||LPAD(LEVEL,8,''0''),
              CASE MOD(LEVEL,3) WHEN 0 THEN ''ORG102'' WHEN 1 THEN ''ORG101'' ELSE ''ORG100'' END,
              ''2'', 45000 + MOD(LEVEL, 3500000)
         FROM dual CONNECT BY LEVEL <= ' || rec.n;

    -- warm-up baseline (truncate target tables again)
    EXECUTE IMMEDIATE 'TRUNCATE TABLE ADS_CUST_POTN_UPGRADE_CUST_DTL';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE ADS_CUST_POTN_UPGRADE_STATIS';

    v_t1 := DBMS_UTILITY.GET_TIME;
    PRC_ADS_CUST_POTN_UPGRADE_DTL(v_batch, v_rc);
    v_t2 := DBMS_UTILITY.GET_TIME;
    v_dtl := (v_t2 - v_t1) / 100;

    v_t1 := DBMS_UTILITY.GET_TIME;
    PRC_ADS_CUST_POTN_UPGRADE_STAT(v_batch, v_rc);
    v_t2 := DBMS_UTILITY.GET_TIME;
    v_stat := (v_t2 - v_t1) / 100;

    SELECT COUNT(*) INTO v_dtl0 FROM ADS_CUST_POTN_UPGRADE_CUST_DTL;
    SELECT COUNT(*) INTO v_stat0 FROM ADS_CUST_POTN_UPGRADE_STATIS;

    DBMS_OUTPUT.PUT_LINE('N='||rec.n||' | DTL_SEC='||ROUND(v_dtl,3)||
                         ' | STATIS_SEC='||ROUND(v_stat,3)||
                         ' | DTL_ROWS='||v_dtl0||' | STATIS_ROWS='||v_stat0);
  END LOOP;
END;
/

EXIT
