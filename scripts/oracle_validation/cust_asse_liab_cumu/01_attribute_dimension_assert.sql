-- ============================================================
-- DWS_CUST_ASSE_LIAB_CUMU attribute dimension assertions
-- Scope: SCOTT test schema only. Do not execute against crmdm.
-- Prerequisite: create SCOTT copies of the involved DWD/DWS/TMP tables
--               and compile the converted procedure in SCOTT.
-- ============================================================

-- 1. Two active insurance policies with the same customer/account/product but
--    different policy numbers must remain separate rows.
SELECT CASE WHEN COUNT(*) = 2 THEN 'PASS' ELSE 'FAIL' END AS policy_dimension_result
  FROM DWS_CUST_ASSE_LIAB_CUMU C
 WHERE C.DATA_DATE = '20260813'
   AND C.CUST_ID = 'C_INSUR_01'
   AND C.ACCT_ID = 'A_INSUR_01'
   AND C.PRDKT_ID = 'P_INSUR_01'
   AND C.PRDKT_TYP = '4'
   AND C.IOU_NO IN ('POLICY_001', 'POLICY_002');

-- 2. Channel or issue-date differences are independent insurance dimensions.
SELECT CASE WHEN COUNT(*) = 2 THEN 'PASS' ELSE 'FAIL' END AS channel_date_dimension_result
  FROM DWS_CUST_ASSE_LIAB_CUMU C
 WHERE C.DATA_DATE = '20260813'
   AND C.CUST_ID = 'C_INSUR_02'
   AND C.ACCT_ID = 'A_INSUR_02'
   AND C.PRDKT_ID = 'P_INSUR_02'
   AND C.PRDKT_TYP = '4'
   AND ((C.CHNL_NO = 'MOB' AND C.ISSU_DATE = '20260801')
     OR (C.CHNL_NO = 'BRN' AND C.ISSU_DATE = '20260802'));

-- 3. Loan IOU_NO is a dimension and must prevent separate loan contracts
--    from being merged.
SELECT CASE WHEN COUNT(*) = 2 THEN 'PASS' ELSE 'FAIL' END AS loan_iou_dimension_result
  FROM DWS_CUST_ASSE_LIAB_CUMU C
 WHERE C.DATA_DATE = '20260813'
   AND C.CUST_ID = 'C_LOAN_01'
   AND C.ACCT_ID = 'A_LOAN_01'
   AND C.PRDKT_ID = 'P_LOAN_01'
   AND C.PRDKT_TYP = '2'
   AND C.IOU_NO IN ('IOU_001', 'IOU_002');

-- 4. Financial-product channel and issue date must be propagated unchanged.
SELECT CASE WHEN COUNT(*) = 1 THEN 'PASS' ELSE 'FAIL' END AS financial_attribute_result
  FROM DWS_CUST_ASSE_LIAB_CUMU C
 WHERE C.DATA_DATE = '20260813'
   AND C.CUST_ID = 'C_FIN_01'
   AND C.ACCT_ID = 'A_FIN_01'
   AND C.PRDKT_ID = 'P_FIN_01'
   AND C.PRDKT_TYP = '3'
   AND C.CHNL_NO = 'MOB'
   AND C.ISSU_DATE = '20260810'
   AND C.IOU_NO IS NULL;

-- 5. On a consecutive normal day, same full dimension accumulates from history.
SELECT CASE WHEN C.MTH_BAL = 300 AND C.QRT_BAL = 300 AND C.YAR_BAL = 300
            THEN 'PASS' ELSE 'FAIL' END AS consecutive_day_accumulation_result
  FROM DWS_CUST_ASSE_LIAB_CUMU C
 WHERE C.DATA_DATE = '20260814'
   AND C.CUST_ID = 'C_INSUR_01'
   AND C.ACCT_ID = 'A_INSUR_01'
   AND C.PRDKT_ID = 'P_INSUR_01'
   AND C.CHNL_NO = 'MOB'
   AND C.ISSU_DATE = '20260801'
   AND C.IOU_NO = 'POLICY_001'
   AND C.PRDKT_TYP = '4';

-- 6. At month start, monthly accumulated amount resets while quarter/year
--    behavior follows the procedure's existing calendar rules.
SELECT CASE WHEN C.MTH_BAL = C.BAL THEN 'PASS' ELSE 'FAIL' END AS month_start_reset_result
  FROM DWS_CUST_ASSE_LIAB_CUMU C
 WHERE C.DATA_DATE = '20260901'
   AND C.CUST_ID = 'C_INSUR_01'
   AND C.ACCT_ID = 'A_INSUR_01'
   AND C.PRDKT_ID = 'P_INSUR_01'
   AND C.CHNL_NO = 'MOB'
   AND C.ISSU_DATE = '20260801'
   AND C.IOU_NO = 'POLICY_001'
   AND C.PRDKT_TYP = '4';

-- 7. Same-date rerun must not produce duplicate rows in either current or history table.
SELECT CASE WHEN COUNT(*) = 1 THEN 'PASS' ELSE 'FAIL' END AS current_rerun_dedup_result
  FROM DWS_CUST_ASSE_LIAB_CUMU C
 WHERE C.DATA_DATE = '20260813'
   AND C.CUST_ID = 'C_INSUR_01'
   AND C.ACCT_ID = 'A_INSUR_01'
   AND C.PRDKT_ID = 'P_INSUR_01'
   AND C.CHNL_NO = 'MOB'
   AND C.ISSU_DATE = '20260801'
   AND C.IOU_NO = 'POLICY_001'
   AND C.PRDKT_TYP = '4';

SELECT CASE WHEN COUNT(*) = 1 THEN 'PASS' ELSE 'FAIL' END AS history_rerun_dedup_result
  FROM DWS_CUST_ASSE_LIAB_CUMU_HIS H
 WHERE H.DATA_DATE = '20260813'
   AND H.CUST_ID = 'C_INSUR_01'
   AND H.ACCT_ID = 'A_INSUR_01'
   AND H.PRDKT_ID = 'P_INSUR_01'
   AND H.CHNL_NO = 'MOB'
   AND H.ISSU_DATE = '20260801'
   AND H.IOU_NO = 'POLICY_001'
   AND H.PRDKT_TYP = '4';
