WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
SET SERVEROUTPUT ON
SET LINESIZE 240
SET PAGESIZE 500

DECLARE
  v_outcde INTEGER;
  v_value NUMBER;
BEGIN
  PRC_ADS_STAT_INDX_DATA('20260810', v_outcde);
  IF v_outcde <> 0 THEN RAISE_APPLICATION_ERROR(-20910, 'snapshot run outcde=' || v_outcde); END IF;

  SELECT curnt_val INTO v_value
    FROM ADS_STAT_INDX_DATA
   WHERE data_date = '20260810' AND statis_dim = 'ACT001'
     AND data_blng = 'ORG_ORG001' AND indx_code = 'INDX_0082';
  IF v_value <> 19 THEN RAISE_APPLICATION_ERROR(-20911, 'duplicate customer dedup expected=19 actual=' || v_value); END IF;
  DBMS_OUTPUT.PUT_LINE('DUPLICATE_DEDUP_PASS INDX_0082=' || v_value);
END;
/

-- Delete one required frozen baseline and assert the started activity is rejected.
DELETE FROM ADS_STAT_INDX_BASELINE_SUM
 WHERE statis_dim = 'ACT001' AND data_blng = 'ORG_ORG001' AND indx_code = 'INDX_0055';
COMMIT;

DECLARE
  v_outcde INTEGER;
BEGIN
  BEGIN
    PRC_ADS_STAT_INDX_DATA('20260810', v_outcde);
    RAISE_APPLICATION_ERROR(-20912, 'missing baseline unexpectedly succeeded');
  EXCEPTION WHEN OTHERS THEN
    IF SQLCODE = -20912 THEN RAISE; END IF;
    DBMS_OUTPUT.PUT_LINE('MISSING_BASELINE_PASS code=' || SQLCODE);
  END;
END;
/

SELECT indx_code, statis_calib, data_blng, curnt_val, term_last_val
  FROM ADS_STAT_INDX_DATA
 WHERE data_date = '20260810'
   AND ((statis_calib = '营销活动' AND statis_dim = 'ACT001' AND data_blng = 'ORG_ORG001')
     OR (statis_calib = '目标任务' AND statis_dim = 'TSK001' AND data_blng = 'ORG_ORG001'))
 ORDER BY indx_code, statis_calib;

EXIT SUCCESS
