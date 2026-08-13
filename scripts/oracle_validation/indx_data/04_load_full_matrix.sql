WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
SET DEFINE OFF

TRUNCATE TABLE ADS_STAT_INDX_DATA;
TRUNCATE TABLE ADS_STAT_INDX_BASELINE_MEMBER;
TRUNCATE TABLE ADS_STAT_INDX_BASELINE_DTL;
TRUNCATE TABLE ADS_STAT_INDX_BASELINE_SUM;
TRUNCATE TABLE DWD_MKT_ACT_INFO;
TRUNCATE TABLE DWD_MKT_ACT_TARGT;
TRUNCATE TABLE DWD_MKT_TSK_INFO;
TRUNCATE TABLE DWD_MKT_INDX_TSK;
TRUNCATE TABLE DWD_MKT_TSK_INDX_SUB;
TRUNCATE TABLE DWS_CUST_LVL_INFO;
TRUNCATE TABLE DWD_CUST_MAN;
TRUNCATE TABLE DWS_CUST_ASSE_LIAB;
TRUNCATE TABLE DWD_CUST_INDV_INFO;
TRUNCATE TABLE DWD_ACCT_INSUR;
TRUNCATE TABLE DWD_ACCT_DEPO;
TRUNCATE TABLE MBK_CUST_INFO;
TRUNCATE TABLE MBK_CUST_LOG_LOGIN;
TRUNCATE TABLE UEPP_PAY_MCT_INFO;
TRUNCATE TABLE UEPP_PAY_ORDER_INFO;
TRUNCATE TABLE UEPP_PAY_MCT_SETTLE_ACCOUNT;
TRUNCATE TABLE DWD_SYS_ORG;
TRUNCATE TABLE CRM_SYS_POST;
TRUNCATE TABLE DEPO_VALUE_INIT;

INSERT INTO ADS_STAT_INDX_RULE
    (indx_code, indx_name, calc_class, is_enabled, effective_bgn_date,
     effective_end_date, stat_unit, sort_no, remark)
SELECT 'INDX_' || LPAD(TO_CHAR(x.indx_no), 4, '0'),
       'MATRIX_' || x.indx_no, x.calc_class, '1', '20000101', NULL,
       'UNIT', x.indx_no, 'FULL_MATRIX'
  FROM (
    SELECT 46 indx_no, 'BALANCE' calc_class FROM dual UNION ALL SELECT 47, 'BALANCE' FROM dual UNION ALL
    SELECT 48, 'BALANCE' FROM dual UNION ALL SELECT 49, 'BALANCE' FROM dual UNION ALL SELECT 50, 'BALANCE' FROM dual UNION ALL SELECT 51, 'BALANCE' FROM dual UNION ALL
    SELECT 52, 'CUST_STATE' FROM dual UNION ALL SELECT 53, 'CUST_STATE' FROM dual UNION ALL SELECT 54, 'CUST_STATE' FROM dual UNION ALL
    SELECT 55, 'BASELINE_AMOUNT' FROM dual UNION ALL SELECT 56, 'BASELINE_AMOUNT' FROM dual UNION ALL SELECT 58, 'BASELINE_AMOUNT' FROM dual UNION ALL SELECT 59, 'BASELINE_AMOUNT' FROM dual UNION ALL
    SELECT 61, 'EVENT' FROM dual UNION ALL SELECT 62, 'BASELINE_AMOUNT' FROM dual UNION ALL SELECT 63, 'CUST_STATE' FROM dual UNION ALL SELECT 67, 'EVENT' FROM dual UNION ALL
    SELECT 80, 'NEW_CUST' FROM dual UNION ALL SELECT 81, 'MERCHANT_AUM' FROM dual UNION ALL SELECT 82, 'NEW_CUST' FROM dual UNION ALL SELECT 83, 'NEW_CUST' FROM dual
  ) x;

-- Five independent four-level trees: head office -> branch -> sub-branch -> outlet.
-- This verifies recursive roll-up from leaf outlets to every ancestor.
INSERT INTO DWD_SYS_ORG
    (org_id, sup_org_id, org_path, org_name, sup_org_name, direct_under_org,
     org_typ, org_harcy, org_addrs, org_state, dsply_seq, creatr, creat_time,
     creat_org, persn_legal_bk_code, hr_ms_org_id, org_lgtud, org_lattud,
     org_rsponr, org_tel)
SELECT x.org_id,
       x.sup_org_id,
       x.org_path,
       x.org_name,
       x.sup_org_name,
       x.root_org_id,
       x.org_typ,
       x.org_harcy,
       'TEST_ADDRESS_' || x.org_id,
       '1',
       x.dsply_seq,
       'TEST_USER',
       '20260809080000',
       x.root_org_id,
       'L001',
       'HR_' || x.org_id,
       '116.3000',
       '39.9000',
       'TEST_MANAGER',
       '13800000000'
  FROM (
    SELECT 'ORG' || LPAD(TO_CHAR(g), 3, '0') org_id, NULL sup_org_id,
           'ORG' || LPAD(TO_CHAR(g), 3, '0') org_path,
           'HEAD_' || LPAD(TO_CHAR(g), 3, '0') org_name, NULL sup_org_name,
           'ORG' || LPAD(TO_CHAR(g), 3, '0') root_org_id, 'HEAD' org_typ,
           '1' org_harcy, g * 10 + 1 dsply_seq
      FROM (SELECT LEVEL g FROM dual CONNECT BY LEVEL <= 5)
    UNION ALL
    SELECT 'BR' || LPAD(TO_CHAR(g), 4, '0'), 'ORG' || LPAD(TO_CHAR(g), 3, '0'),
           'ORG' || LPAD(TO_CHAR(g), 3, '0') || '/BR' || LPAD(TO_CHAR(g), 4, '0'),
           'BRANCH_' || LPAD(TO_CHAR(g), 3, '0'), 'HEAD_' || LPAD(TO_CHAR(g), 3, '0'),
           'ORG' || LPAD(TO_CHAR(g), 3, '0'), 'BRANCH', '2', g * 10 + 2
      FROM (SELECT LEVEL g FROM dual CONNECT BY LEVEL <= 5)
    UNION ALL
    SELECT 'SB' || LPAD(TO_CHAR(g), 4, '0'), 'BR' || LPAD(TO_CHAR(g), 4, '0'),
           'ORG' || LPAD(TO_CHAR(g), 3, '0') || '/BR' || LPAD(TO_CHAR(g), 4, '0') || '/SB' || LPAD(TO_CHAR(g), 4, '0'),
           'SUB_BRANCH_' || LPAD(TO_CHAR(g), 3, '0'), 'BRANCH_' || LPAD(TO_CHAR(g), 3, '0'),
           'ORG' || LPAD(TO_CHAR(g), 3, '0'), 'SUB_BRANCH', '3', g * 10 + 3
      FROM (SELECT LEVEL g FROM dual CONNECT BY LEVEL <= 5)
    UNION ALL
    SELECT 'OT' || LPAD(TO_CHAR(g), 4, '0'), 'SB' || LPAD(TO_CHAR(g), 4, '0'),
           'ORG' || LPAD(TO_CHAR(g), 3, '0') || '/BR' || LPAD(TO_CHAR(g), 4, '0') || '/SB' || LPAD(TO_CHAR(g), 4, '0') || '/OT' || LPAD(TO_CHAR(g), 4, '0'),
           'OUTLET_' || LPAD(TO_CHAR(g), 3, '0'), 'SUB_BRANCH_' || LPAD(TO_CHAR(g), 3, '0'),
           'ORG' || LPAD(TO_CHAR(g), 3, '0'), 'OUTLET', '4', g * 10 + 4
      FROM (SELECT LEVEL g FROM dual CONNECT BY LEVEL <= 5)
  ) x;
INSERT INTO CRM_SYS_POST (post_id, org_id, job_cls)
SELECT 'MGR' || LPAD(TO_CHAR(LEVEL), 3, '0'), CASE WHEN LEVEL = 1 THEN 'ORG001' ELSE 'ORG002' END, 'C' FROM dual CONNECT BY LEVEL <= 20;

INSERT INTO DWD_MKT_ACT_INFO (mkt_act_id, act_bgn_date, statis_stop_date, camp_act_typ, persn_legal_bk_code)
SELECT CASE WHEN LEVEL = 1 THEN 'ACT001' ELSE 'ACT' || LPAD(TO_CHAR(LEVEL), 3, '0') END,
       CASE WHEN LEVEL = 1 THEN '20260810' ELSE '20250101' END,
       CASE WHEN LEVEL = 1 THEN '20260831' ELSE '20250131' END, '1', 'L001'
  FROM dual CONNECT BY LEVEL <= 20;
INSERT INTO DWD_MKT_ACT_TARGT (mkt_act_id, indx_id, prtspt_org)
SELECT 'ACT001', 'INDX_' || LPAD(TO_CHAR(x.indx_no), 4, '0'), 'ORG001'
  FROM (SELECT 46 indx_no FROM dual UNION ALL SELECT 47 FROM dual UNION ALL SELECT 48 FROM dual UNION ALL SELECT 49 FROM dual UNION ALL SELECT 50 FROM dual UNION ALL SELECT 51 FROM dual UNION ALL
        SELECT 52 FROM dual UNION ALL SELECT 53 FROM dual UNION ALL SELECT 54 FROM dual UNION ALL SELECT 55 FROM dual UNION ALL SELECT 56 FROM dual UNION ALL SELECT 58 FROM dual UNION ALL SELECT 59 FROM dual UNION ALL
        SELECT 61 FROM dual UNION ALL SELECT 62 FROM dual UNION ALL SELECT 63 FROM dual UNION ALL SELECT 67 FROM dual UNION ALL SELECT 80 FROM dual UNION ALL SELECT 81 FROM dual UNION ALL SELECT 82 FROM dual UNION ALL SELECT 83 FROM dual) x;
INSERT INTO DWD_MKT_TSK_INFO (mkt_act_id, cust_id, mkt_persn, mkt_persn_org, persn_legal_bk_code, data_date)
SELECT 'ACT001', 'C' || LPAD(TO_CHAR(MOD(LEVEL - 1, 20) + 1), 3, '0'), 'MGR001', 'ORG001', 'L001', CASE WHEN LEVEL <= 20 THEN '20260809' ELSE '20260810' END
  FROM dual CONNECT BY LEVEL <= 40;

INSERT INTO DWD_MKT_INDX_TSK (tsk_id, rsv_obj, rsv_obj_id, persn_legal_bk_code)
SELECT 'TSK' || LPAD(TO_CHAR(LEVEL), 3, '0'), CASE WHEN LEVEL = 1 THEN '0' ELSE '1' END, CASE WHEN LEVEL = 1 THEN 'ORG001' ELSE 'MGR001' END, 'L001'
  FROM dual CONNECT BY LEVEL <= 20;
INSERT INTO DWD_MKT_TSK_INDX_SUB (tsk_id, indx_id, tsk_bgn_date, tsk_end_date, persn_legal_bk_code)
SELECT 'TSK001', 'INDX_' || LPAD(TO_CHAR(x.indx_no), 4, '0'), '20260810', '20260831', 'L001'
  FROM (SELECT 46 indx_no FROM dual UNION ALL SELECT 47 FROM dual UNION ALL SELECT 48 FROM dual UNION ALL SELECT 49 FROM dual UNION ALL SELECT 50 FROM dual UNION ALL SELECT 51 FROM dual UNION ALL
        SELECT 52 FROM dual UNION ALL SELECT 53 FROM dual UNION ALL SELECT 54 FROM dual UNION ALL SELECT 55 FROM dual UNION ALL SELECT 56 FROM dual UNION ALL SELECT 58 FROM dual UNION ALL SELECT 59 FROM dual UNION ALL
        SELECT 61 FROM dual UNION ALL SELECT 62 FROM dual UNION ALL SELECT 63 FROM dual UNION ALL SELECT 67 FROM dual UNION ALL SELECT 80 FROM dual UNION ALL SELECT 81 FROM dual UNION ALL SELECT 82 FROM dual UNION ALL SELECT 83 FROM dual) x;
INSERT INTO DWD_MKT_TSK_INDX_SUB (tsk_id, indx_id, tsk_bgn_date, tsk_end_date, persn_legal_bk_code)
SELECT 'TSK' || LPAD(TO_CHAR(LEVEL), 3, '0'), 'INDX_0046', '20260810', '20260831', 'L001' FROM dual CONNECT BY LEVEL <= 19;

INSERT INTO DWD_CUST_MAN
    (cust_id, mngr_post_id, org_id, mng_typ, modf_time, modf_typ, data_src, valid_date, persn_legal_bk_code)
SELECT 'C' || LPAD(TO_CHAR(LEVEL), 3, '0'), 'MGR001', 'OT0001', '1',
       '20260810080000', 'I', 'TEST', '20260810', 'L001'
  FROM dual CONNECT BY LEVEL <= 20;
INSERT INTO DWS_CUST_LVL_INFO (data_date, cust_id, cust_lvl, org_id, persn_legal_bk_code)
SELECT d.data_date, 'C' || LPAD(TO_CHAR(c.n), 3, '0'),
       CASE WHEN d.data_date = '20260809' AND c.n <= 4 THEN '3'
            WHEN d.data_date = '20260810' AND c.n <= 4 THEN '4'
            WHEN d.data_date = '20260809' AND c.n BETWEEN 5 AND 8 THEN '5'
            WHEN d.data_date = '20260810' AND c.n BETWEEN 5 AND 8 THEN '6'
            WHEN d.data_date = '20260809' AND c.n BETWEEN 9 AND 12 THEN '6'
            WHEN d.data_date = '20260810' AND c.n BETWEEN 9 AND 12 THEN '7'
            WHEN c.n <= 16 THEN '7' ELSE '1' END, 'ORG001', 'L001'
  FROM (SELECT '20260809' data_date FROM dual UNION ALL SELECT '20260810' FROM dual) d CROSS JOIN (SELECT LEVEL n FROM dual CONNECT BY LEVEL <= 20) c;
INSERT INTO DWD_CUST_INDV_INFO (cust_id, cust_name, open_date, open_org, persn_legal_bk_code, gend, phone_no, org_lead, org_lead_path)
SELECT 'C' || LPAD(TO_CHAR(LEVEL), 3, '0'), 'TEST_CUST_' || LPAD(TO_CHAR(LEVEL), 3, '0'),
       CASE WHEN LEVEL = 20 THEN '20260809' ELSE '20260810' END,
       'OT0001', 'L001', '1', '1380000' || LPAD(TO_CHAR(LEVEL), 4, '0'), 'OT0001', 'ORG001/BR0001/SB0001/OT0001'
  FROM dual CONNECT BY LEVEL <= 20;
INSERT INTO MBK_CUST_INFO (cust_no, cust_core_no, cust_mobile, cust_cap_lvl, cust_is_idtfy_verify, cust_open_date, cust_open_time, cust_open_chnl, cust_status)
SELECT 'MBK' || LPAD(TO_CHAR(LEVEL), 3, '0'), 'C' || LPAD(TO_CHAR(LEVEL), 3, '0'),
       '1390000' || LPAD(TO_CHAR(LEVEL), 4, '0'), '01', '1', '2026-08-10', '080000', 'MB', '1'
  FROM dual CONNECT BY LEVEL <= 20;
INSERT INTO MBK_CUST_LOG_LOGIN (tran_sn, cust_no, lgn_date, lgn_time, lgn_status)
SELECT 'LOGIN' || LPAD(TO_CHAR(LEVEL), 3, '0'), 'MBK' || LPAD(TO_CHAR(LEVEL), 3, '0'),
       '2026-08-' || LPAD(TO_CHAR(MOD(LEVEL, 10) + 1), 2, '0'), '12:00:00', '1'
  FROM dual CONNECT BY LEVEL <= 20;
UPDATE MBK_CUST_LOG_LOGIN
   SET lgn_date = '2026-08-20'
 WHERE cust_no = 'MBK001';

INSERT INTO DWS_CUST_ASSE_LIAB (data_date, cust_id, org_id, persn_legal_bk_code, bal_type, aum_bal, depo_curnt_depo_bal, fixd_depo_bal, fin_bal, loan_bal, close_agen_fin_bal, open_agen_fin_bal)
SELECT d.data_date, 'C' || LPAD(TO_CHAR(c.n), 3, '0'), 'ORG001', 'L001', t.bal_type,
       CASE WHEN t.bal_type = '2' AND c.n = 17 AND d.data_date = '20260809' THEN 60000
            WHEN t.bal_type = '2' AND c.n = 17 AND d.data_date = '20260810' THEN 45000
            WHEN d.data_date = '20260810' THEN 1000 + c.n ELSE 900 + c.n END,
       CASE WHEN d.data_date = '20260810' AND c.n = 20 THEN 99 ELSE 100 + c.n END,
       CASE WHEN c.n = 19 THEN 1 ELSE 0 END,
       CASE WHEN t.bal_type IN ('2','4') THEN 200 + c.n + CASE WHEN d.data_date = '20260810' THEN 25 ELSE 0 END ELSE 0 END,
       CASE WHEN t.bal_type = '1' THEN 300 + c.n + CASE WHEN d.data_date = '20260810' THEN 25 ELSE 0 END ELSE 0 END,
       CASE WHEN t.bal_type IN ('2','4') THEN 50 + c.n + CASE WHEN d.data_date = '20260810' THEN 10 ELSE 0 END ELSE 0 END,
       CASE WHEN t.bal_type IN ('2','4') THEN 25 + c.n + CASE WHEN d.data_date = '20260810' THEN 5 ELSE 0 END ELSE 0 END
  FROM (SELECT '20260809' data_date FROM dual UNION ALL SELECT '20260810' FROM dual UNION ALL SELECT '20260101' FROM dual UNION ALL SELECT '20251231' FROM dual UNION ALL SELECT '20260731' FROM dual UNION ALL SELECT '20260630' FROM dual UNION ALL SELECT '20260430' FROM dual) d
 CROSS JOIN (SELECT LEVEL n FROM dual CONNECT BY LEVEL <= 20) c
 CROSS JOIN (SELECT '1' bal_type FROM dual UNION ALL SELECT '2' FROM dual UNION ALL SELECT '4' FROM dual) t;

INSERT INTO DEPO_VALUE_INIT (org_id, mngr_post_id, persn_legal_bk_code, value_init)
SELECT CASE WHEN LEVEL = 1 THEN 'ORG001' ELSE 'ORG002' END, CASE WHEN LEVEL = 1 THEN NULL ELSE 'MGR001' END, 'L001', 800 + LEVEL FROM dual CONNECT BY LEVEL <= 20;
INSERT INTO DWD_ACCT_DEPO (cust_id, persn_legal_bk_code, acct_id, card_no, acct_typ, open_date)
SELECT 'C' || LPAD(TO_CHAR(LEVEL), 3, '0'), 'L001', 'ACCT' || LPAD(TO_CHAR(LEVEL), 3, '0'), 'CARD' || LPAD(TO_CHAR(LEVEL), 3, '0'), CASE WHEN MOD(LEVEL, 3) = 0 THEN '03' WHEN MOD(LEVEL, 2) = 0 THEN '02' ELSE '01' END, '20260810' FROM dual CONNECT BY LEVEL <= 20;
INSERT INTO DWD_ACCT_INSUR
    (cust_id, cust_typ, acct_id, prdkt_id, prdkt_name, prdkt_cate_big,
     insur_bid_form_no, tx_date, tx_org, tx_chnl, mkt_org, bgn_insur_date,
     pay_upto_date, insur_period_typ, insur_period, pay_period_typ,
     pay_period, pay_patrn, insur_amt, policy_state, tx_typ,
     persn_legal_bk_code, last_tx_date, new_insur_amt)
SELECT 'C' || LPAD(TO_CHAR(LEVEL), 3, '0'), '1',
       'INS_ACCT_' || LPAD(TO_CHAR(LEVEL), 3, '0'),
       'INS_PRD_' || LPAD(TO_CHAR(LEVEL), 3, '0'), 'TEST_INS_PRODUCT', 'LIFE',
       'POLICY_' || LPAD(TO_CHAR(LEVEL), 3, '0'), '20260810', 'OT0001', 'APP', 'OT0001', '20260810',
       '20270810', '1', '12', '1', '12', '1', 1000 + LEVEL * 10,
       CASE WHEN MOD(LEVEL, 5) = 0 THEN '0' ELSE '1' END, '1', 'L001', '20260810', 1000 + LEVEL * 10
  FROM dual CONNECT BY LEVEL <= 20;

INSERT INTO UEPP_PAY_MCT_INFO (mct_id, short_name, mct_type, org_id, job_id, status, check_status, create_time)
SELECT 'MCT' || LPAD(TO_CHAR(LEVEL), 3, '0'), 'TEST_MCT_' || LPAD(TO_CHAR(LEVEL), 3, '0'),
       CASE WHEN LEVEL <= 10 THEN 'personage' ELSE 'enterprise' END,
       'OT0001', 'MGR001', '0', '03', '20260810080000'
  FROM dual CONNECT BY LEVEL <= 20;
INSERT INTO UEPP_PAY_MCT_SETTLE_ACCOUNT (mct_id, channel, cust_no)
SELECT 'MCT' || LPAD(TO_CHAR(LEVEL), 3, '0'), 'CH' || LPAD(TO_CHAR(LEVEL), 3, '0'), 'C' || LPAD(TO_CHAR(LEVEL), 3, '0') FROM dual CONNECT BY LEVEL <= 20;
INSERT INTO UEPP_PAY_ORDER_INFO (order_id, order_type, mct_id, dit_id, order_amt, status, pay_time, consumer_id, create_time)
SELECT 'ORD' || LPAD(TO_CHAR(LEVEL), 3, '0'), '00', 'MCT' || LPAD(TO_CHAR(LEVEL), 3, '0'),
       'DIT001', CASE WHEN LEVEL = 10 THEN 50 ELSE 50 + LEVEL * 50 END,
       '02', '20260810120000', 'C999', '20260810120000'
  FROM dual CONNECT BY LEVEL <= 20;

COMMIT;

-- Baseline run: activity/task start date minus one day.
DECLARE
  v_outcde INTEGER;
BEGIN
  PRC_ADS_STAT_INDX_DATA('20260809', v_outcde);
  IF v_outcde <> 0 THEN
    RAISE_APPLICATION_ERROR(-20910, 'baseline run outcde=' || v_outcde);
  END IF;
END;
/
COMMIT;
