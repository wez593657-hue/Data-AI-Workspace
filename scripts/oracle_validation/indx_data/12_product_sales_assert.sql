-- 0057/0060 理财产品销量拆分过程回归。
-- 前置条件：已执行 01_setup_tables.sql，并按拆分过程依赖顺序编译
-- prc_ads_stat_indx_product_baseline.sql 和 sys_fun_deal_date.sql。
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
SET SERVEROUTPUT ON

DELETE FROM TMP_STAT_INDX_SCOPE;
DELETE FROM TMP_STAT_INDX_AGGR;
DELETE FROM DWD_ACCT_FIN;
DELETE FROM DWD_MKT_TSK_INFO;
DELETE FROM DWS_CUST_LVL_INFO;
DELETE FROM DWD_CUST_MAN;

-- A路径：同一客户多产品、窗口首日、窗口末日、窗口外、空金额、非8位日期和非法日期格式。
INSERT INTO TMP_STAT_INDX_SCOPE VALUES ('A', 'ACT0057', 'INDX_0057', 'ORG_O1', 'O', 'O1', '20260801', 'L001');
INSERT INTO TMP_STAT_INDX_SCOPE VALUES ('A', 'ACT0060', 'INDX_0060', 'ORG_O1', 'O', 'O1', '20260801', 'L001');
INSERT INTO DWD_MKT_TSK_INFO (mkt_act_id, cust_id, mkt_persn_org, persn_legal_bk_code, data_date)
VALUES ('ACT0057', 'C001', 'O1', 'L001', '20260810');
INSERT INTO DWD_MKT_TSK_INFO (mkt_act_id, cust_id, mkt_persn_org, persn_legal_bk_code, data_date)
VALUES ('ACT0060', 'C001', 'O1', 'L001', '20260810');

INSERT INTO DWD_ACCT_FIN VALUES ('C001', '1', 'A001', 'CARD001', 'P001', '产品1', '3', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'L001', NULL, '20260801', NULL, 100);
INSERT INTO DWD_ACCT_FIN VALUES ('C001', '1', 'A002', 'CARD002', 'P002', '产品2', '1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'L001', NULL, '2026-08-10', NULL, 200);
INSERT INTO DWD_ACCT_FIN VALUES ('C001', '1', 'A003', 'CARD003', 'P003', '产品3', '2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'L001', NULL, '20260805', NULL, NULL);
INSERT INTO DWD_ACCT_FIN VALUES ('C001', '1', 'A004', 'CARD004', 'P004', '产品4', '1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'L001', NULL, '20260731', NULL, 500);
INSERT INTO DWD_ACCT_FIN VALUES ('C001', '1', 'A005', 'CARD005', 'P005', '产品5', '1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'L001', NULL, 'INVALID', NULL, 700);
INSERT INTO DWD_ACCT_FIN VALUES ('C001', '1', 'A008', 'CARD008', 'P008', '产品8', '1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'L001', NULL, '20260810', NULL, 250);

-- B路径：机构客户和客户经理客户均应计入；0060只统计大类1、2。
INSERT INTO TMP_STAT_INDX_SCOPE VALUES ('B', 'TSK0057', 'INDX_0057', 'ORG_O2', 'O', 'O2', '20260801', 'L001');
INSERT INTO TMP_STAT_INDX_SCOPE VALUES ('B', 'TSK0060', 'INDX_0060', 'MGR_M2', 'M', 'M2', '20260801', 'L001');
INSERT INTO DWS_CUST_LVL_INFO VALUES ('L001', '20260810', 'C002', '3', 'O2', NULL);
INSERT INTO DWD_CUST_MAN (cust_id, mngr_post_id, org_id, mng_typ, modf_time, persn_legal_bk_code)
VALUES ('C003', 'M2', 'O2', '1', '20260810', 'L001');
INSERT INTO DWD_ACCT_FIN VALUES ('C002', '1', 'A006', 'CARD006', 'P006', '产品6', '4', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'L001', NULL, '20260802', NULL, 300);
INSERT INTO DWD_ACCT_FIN VALUES ('C003', '1', 'A007', 'CARD007', 'P007', '产品7', '2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'L001', NULL, '20260803', NULL, 400);

DECLARE
  v_row_count INTEGER;
  v_actual NUMBER;
  PROCEDURE assert_value(
      p_path_code VARCHAR2,
      p_statis_dim VARCHAR2,
      p_indx_code VARCHAR2,
      p_data_blng VARCHAR2,
      p_expected NUMBER
  ) IS
  BEGIN
    SELECT a.curnt_val INTO v_actual
      FROM TMP_STAT_INDX_AGGR a
     WHERE a.path_code = p_path_code
       AND a.statis_dim = p_statis_dim
       AND a.indx_code = p_indx_code
       AND a.data_blng = p_data_blng
       AND a.persn_legal_bk_code = 'L001';
    IF v_actual <> p_expected THEN
      RAISE_APPLICATION_ERROR(-20957,
        p_path_code || ':' || p_statis_dim || ':' || p_indx_code
        || ' expected=' || p_expected || ', actual=' || v_actual);
    END IF;
  END;
BEGIN
  PRC_ADS_STAT_INDX_PRODUCT_BASELINE('20260810', v_row_count);
  assert_value('A', 'ACT0057', 'INDX_0057', 'ORG_O1', 350);
  assert_value('A', 'ACT0060', 'INDX_0060', 'ORG_O1', 250);
  assert_value('B', 'TSK0057', 'INDX_0057', 'ORG_O2', 300);
  assert_value('B', 'TSK0060', 'INDX_0060', 'MGR_M2', 400);
  DBMS_OUTPUT.PUT_LINE('PRODUCT_SALES_PASS');
END;
/

ROLLBACK;
EXIT SUCCESS
