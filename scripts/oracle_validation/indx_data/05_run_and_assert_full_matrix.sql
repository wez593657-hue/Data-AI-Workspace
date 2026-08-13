WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
SET SERVEROUTPUT ON
SET LINESIZE 240
SET PAGESIZE 500

DECLARE
  v_outcde INTEGER;
  v_cnt INTEGER;
  v_indicator_count INTEGER;
  v_missing INTEGER;
  v_bad INTEGER;
  v_baseline_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO v_baseline_count
    FROM ADS_STAT_INDX_BASELINE_SUM b
   WHERE b.statis_calib = '营销活动'
     AND b.statis_dim = 'ACT001'
     AND b.indx_code = 'INDX_0055'
     AND b.data_blng = 'ORG_ORG001'
     AND b.base_data_date = '20260809'
     AND b.base_run_date = '20260809';
  IF v_baseline_count <> 1 THEN
    RAISE_APPLICATION_ERROR(-20909, 'start-minus-one baseline not frozen exactly once');
  END IF;

  PRC_ADS_STAT_INDX_DATA('20260810', v_outcde);
  IF v_outcde <> 0 THEN
    RAISE_APPLICATION_ERROR(-20900, 'normal run outcde=' || v_outcde);
  END IF;

  SELECT COUNT(DISTINCT indx_code) INTO v_indicator_count
    FROM ADS_STAT_INDX_DATA
   WHERE data_date = '20260810';
  IF v_indicator_count <> 21 THEN
    RAISE_APPLICATION_ERROR(-20901, 'expected 21 indicators, actual=' || v_indicator_count);
  END IF;

  SELECT COUNT(*) INTO v_missing
    FROM (SELECT 'INDX_' || LPAD(TO_CHAR(n),4,'0') code FROM (SELECT 46 n FROM dual UNION ALL SELECT 47 FROM dual UNION ALL SELECT 48 FROM dual UNION ALL SELECT 49 FROM dual UNION ALL SELECT 50 FROM dual UNION ALL SELECT 51 FROM dual UNION ALL SELECT 52 FROM dual UNION ALL SELECT 53 FROM dual UNION ALL SELECT 54 FROM dual UNION ALL SELECT 55 FROM dual UNION ALL SELECT 56 FROM dual UNION ALL SELECT 58 FROM dual UNION ALL SELECT 59 FROM dual UNION ALL SELECT 61 FROM dual UNION ALL SELECT 62 FROM dual UNION ALL SELECT 63 FROM dual UNION ALL SELECT 67 FROM dual UNION ALL SELECT 80 FROM dual UNION ALL SELECT 81 FROM dual UNION ALL SELECT 82 FROM dual UNION ALL SELECT 83 FROM dual)) e
   WHERE NOT EXISTS (SELECT 1 FROM ADS_STAT_INDX_DATA a WHERE a.data_date = '20260810' AND a.indx_code = e.code);
  IF v_missing <> 0 THEN
    RAISE_APPLICATION_ERROR(-20902, 'missing indicator rows=' || v_missing);
  END IF;

  SELECT COUNT(*) INTO v_bad FROM ADS_STAT_INDX_DATA WHERE data_date = '20260810' AND (data_blng IS NULL OR statis_dim IS NULL OR indx_code IS NULL OR persn_legal_bk_code IS NULL);
  IF v_bad <> 0 THEN
    RAISE_APPLICATION_ERROR(-20903, 'invalid result keys=' || v_bad);
  END IF;

  SELECT MAX(curnt_val) INTO v_cnt FROM ADS_STAT_INDX_DATA WHERE data_date = '20260810' AND indx_code = 'INDX_0081';
  IF NVL(v_cnt, 0) <= 0 THEN RAISE_APPLICATION_ERROR(-20906, 'INDX_0081 positive merchant scenario not produced'); END IF;
  SELECT MAX(curnt_val) INTO v_cnt FROM ADS_STAT_INDX_DATA WHERE data_date = '20260810' AND indx_code = 'INDX_0055';
  IF NVL(v_cnt, 0) <= 0 THEN RAISE_APPLICATION_ERROR(-20907, 'INDX_0055 positive baseline increment not produced'); END IF;
  SELECT MAX(curnt_val) INTO v_cnt FROM ADS_STAT_INDX_DATA WHERE data_date = '20260810' AND indx_code = 'INDX_0052';
  IF NVL(v_cnt, 0) <= 0 THEN RAISE_APPLICATION_ERROR(-20908, 'INDX_0052 positive customer upgrade not produced'); END IF;

  DBMS_OUTPUT.PUT_LINE('DATE_BOUNDARY_PASS baseline=20260809,current=20260810');
  DBMS_OUTPUT.PUT_LINE('NORMAL_MATRIX_PASS indicators=' || v_indicator_count);
END;
/

-- Invalid date must fail and return no successful status.
DECLARE
  v_outcde INTEGER;
BEGIN
  BEGIN
    PRC_ADS_STAT_INDX_DATA('20261340', v_outcde);
    RAISE_APPLICATION_ERROR(-20905, 'invalid date unexpectedly succeeded');
  EXCEPTION WHEN OTHERS THEN
    IF SQLCODE = -20905 THEN RAISE; END IF;
    DBMS_OUTPUT.PUT_LINE('INVALID_DATE_PASS code=' || SQLCODE);
  END;
END;
/

ROLLBACK;
EXIT SUCCESS
