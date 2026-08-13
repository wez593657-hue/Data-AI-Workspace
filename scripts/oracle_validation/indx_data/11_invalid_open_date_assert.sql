WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
SET SERVEROUTPUT ON

-- Invalid source dates must be ignored by 0080/0082/0083, not terminate the batch.
DECLARE
  v_outcde INTEGER;
  v_before_new_cust NUMBER;
  v_before_new_card NUMBER;
  v_after_new_cust NUMBER;
  v_after_new_card NUMBER;
BEGIN
  SELECT a.curnt_val INTO v_before_new_cust
    FROM ADS_STAT_INDX_DATA a
   WHERE a.data_date = '20260810'
     AND a.statis_dim = 'ACT001'
     AND a.statis_calib = '营销活动'
     AND a.indx_code = 'INDX_0082'
     AND a.data_blng = 'ORG_ORG001';

  SELECT a.curnt_val INTO v_before_new_card
    FROM ADS_STAT_INDX_DATA a
   WHERE a.data_date = '20260810'
     AND a.statis_dim = 'ACT001'
     AND a.statis_calib = '营销活动'
     AND a.indx_code = 'INDX_0083'
     AND a.data_blng = 'ORG_ORG001';

  UPDATE DWD_CUST_INDV_INFO
     SET open_date = '2026-99-99'
   WHERE cust_id = 'C001';

  UPDATE DWD_ACCT_DEPO
     SET open_date = '2026-99-99'
   WHERE cust_id = 'C001';
  COMMIT;

  PRC_ADS_STAT_INDX_DATA('20260810', v_outcde);
  IF v_outcde <> 0 THEN
    RAISE_APPLICATION_ERROR(-20940, 'invalid open date run outcde=' || v_outcde);
  END IF;

  SELECT a.curnt_val INTO v_after_new_cust
    FROM ADS_STAT_INDX_DATA a
   WHERE a.data_date = '20260810'
     AND a.statis_dim = 'ACT001'
     AND a.statis_calib = '营销活动'
     AND a.indx_code = 'INDX_0082'
     AND a.data_blng = 'ORG_ORG001';

  SELECT a.curnt_val INTO v_after_new_card
    FROM ADS_STAT_INDX_DATA a
   WHERE a.data_date = '20260810'
     AND a.statis_dim = 'ACT001'
     AND a.statis_calib = '营销活动'
     AND a.indx_code = 'INDX_0083'
     AND a.data_blng = 'ORG_ORG001';

  IF v_after_new_cust <> v_before_new_cust - 1
     OR v_after_new_card <> v_before_new_card - 1 THEN
    RAISE_APPLICATION_ERROR(
      -20941,
      'invalid dates were not excluded: new_cust=' || v_before_new_cust || '/' || v_after_new_cust
      || ', new_card=' || v_before_new_card || '/' || v_after_new_card
    );
  END IF;
  DBMS_OUTPUT.PUT_LINE('INVALID_OPEN_DATE_PASS new_cust=' || v_after_new_cust || ', new_card=' || v_after_new_card);
END;
/

EXIT SUCCESS
