-- SCOTT-only integration test for configured INDX_0080 through INDX_0083.
-- Prerequisite: run 01_setup_tables.sql and oracle_PRC_ADS_STAT_INDX_DATA.sql.
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

INSERT INTO DWD_MKT_ACT_INFO (mkt_act_id, act_bgn_date, statis_stop_date, camp_act_typ, persn_legal_bk_code)
VALUES ('ACT_008X', '20260810', '20260831', '1', 'L001');

INSERT INTO DWD_MKT_ACT_TARGT (mkt_act_id, indx_id, prtspt_org)
SELECT 'ACT_008X', 'INDX_0080', 'O1' FROM dual UNION ALL
SELECT 'ACT_008X', 'INDX_0081', 'O1' FROM dual UNION ALL
SELECT 'ACT_008X', 'INDX_0082', 'O1' FROM dual UNION ALL
SELECT 'ACT_008X', 'INDX_0083', 'O1' FROM dual;

INSERT INTO DWD_MKT_TSK_INFO (mkt_act_id, cust_id, mkt_persn, mkt_persn_org, persn_legal_bk_code, data_date)
VALUES ('ACT_008X', 'C001', 'M1', 'O1', 'L001', '20260810');

INSERT INTO DWD_CUST_INDV_INFO (cust_id, open_date) VALUES ('C001', '20260810');
INSERT INTO MBK_CUST_INFO (cust_no, cust_core_no, cust_status) VALUES ('MBK001', 'C001', '1');
INSERT INTO DWS_CUST_ASSE_LIAB (data_date, cust_id, org_id, persn_legal_bk_code, bal_type, aum_bal, depo_curnt_depo_bal, fixd_depo_bal, fin_bal, loan_bal, close_agen_fin_bal, open_agen_fin_bal)
VALUES ('20260810', 'C001', 'O1', 'L001', '1', 1000, 100, 0, 0, 0, 0, 0);
INSERT INTO DWS_CUST_ASSE_LIAB (data_date, cust_id, org_id, persn_legal_bk_code, bal_type, aum_bal, depo_curnt_depo_bal, fixd_depo_bal, fin_bal, loan_bal, close_agen_fin_bal, open_agen_fin_bal)
VALUES ('20260810', 'C001', 'O1', 'L001', '4', 1000, 0, 0, 0, 0, 0, 0);
INSERT INTO DWD_ACCT_DEPO (cust_id, persn_legal_bk_code, acct_id, card_no, acct_typ, open_date)
VALUES ('C001', 'L001', 'A001', 'CARD001', '01', '20260810');
INSERT INTO UEPP_PAY_MCT_INFO (mct_id, mct_type, org_id, job_id) VALUES ('MC001', 'personage', 'O1', 'M1');
INSERT INTO UEPP_PAY_MCT_SETTLE_ACCOUNT (mct_id, channel, cust_no) VALUES ('MC001', 'all', 'C001');
INSERT INTO UEPP_PAY_ORDER_INFO (order_id, mct_id, consumer_id, order_type, status, pay_time, order_amt)
VALUES ('ORD001', 'MC001', 'C999', '00', '02', '20260810120000', 500);
INSERT INTO DWD_SYS_ORG (org_id, sup_org_id) VALUES ('O1', NULL);
COMMIT;

DECLARE
  v_outcde INTEGER;
  v_actual NUMBER;
  PROCEDURE ASSERT_VALUE(p_indx_code VARCHAR2, p_expected NUMBER) IS
  BEGIN
    SELECT a.curnt_val INTO v_actual
      FROM ADS_STAT_INDX_DATA a
     WHERE a.data_date = '20260810'
       AND a.statis_dim = 'ACT_008X'
       AND a.statis_calib = '营销活动'
       AND a.indx_code = p_indx_code
       AND a.data_blng = 'ORG_O1'
       AND a.persn_legal_bk_code = 'L001';
    IF v_actual <> p_expected THEN
      RAISE_APPLICATION_ERROR(-20901, p_indx_code || ' expected=' || p_expected || ', actual=' || v_actual);
    END IF;
  END;
BEGIN
  PRC_ADS_STAT_INDX_DATA('20260810', v_outcde);
  IF v_outcde <> 0 THEN
    RAISE_APPLICATION_ERROR(-20900, 'Procedure outcde=' || v_outcde);
  END IF;
  ASSERT_VALUE('INDX_0080', 1);
  ASSERT_VALUE('INDX_0081', 200);
  ASSERT_VALUE('INDX_0082', 1);
  ASSERT_VALUE('INDX_0083', 1);
END;
/

ROLLBACK;
EXIT SUCCESS
