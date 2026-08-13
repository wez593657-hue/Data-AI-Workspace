WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
SET SERVEROUTPUT ON
SET LINESIZE 240
SET PAGESIZE 500

DECLARE
  v_depth NUMBER;
  v_org_rows NUMBER;
  v_bad NUMBER;
  v_outcde INTEGER;
BEGIN
  SELECT COUNT(*), MAX(depth)
    INTO v_org_rows, v_depth
    FROM (SELECT org_id, LEVEL depth FROM DWD_SYS_ORG START WITH sup_org_id IS NULL CONNECT BY NOCYCLE PRIOR org_id = sup_org_id);
  IF v_org_rows <> 20 OR v_depth <> 4 THEN RAISE_APPLICATION_ERROR(-20930, 'org tree rows/depth=' || v_org_rows || '/' || v_depth); END IF;

  SELECT COUNT(*) INTO v_bad
    FROM ADS_STAT_INDX_DATA a
   WHERE a.data_date = '20260810'
     AND a.indx_code = 'INDX_0055'
     AND a.data_blng IN ('ORG_ORG001','ORG_BR0001','ORG_SB0001','ORG_OT0001');
  IF v_bad < 4 THEN RAISE_APPLICATION_ERROR(-20931, 'recursive rollup rows=' || v_bad); END IF;

  BEGIN
    PRC_ADS_STAT_INDX_DATA('20261340', v_outcde);
    RAISE_APPLICATION_ERROR(-20932, 'invalid date unexpectedly succeeded');
  EXCEPTION WHEN OTHERS THEN
    IF SQLCODE = -20932 THEN RAISE; END IF;
    DBMS_OUTPUT.PUT_LINE('INVALID_DATE_PASS code=' || SQLCODE);
  END;
  DBMS_OUTPUT.PUT_LINE('RECURSIVE_AND_ERROR_PASS org_rows=' || v_org_rows || ' max_depth=' || v_depth || ' rollup_rows=' || v_bad);
END;
/
EXIT SUCCESS
