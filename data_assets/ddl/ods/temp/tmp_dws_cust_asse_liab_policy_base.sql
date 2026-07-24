/*
 * 临时表
 * 表名: crmdm.tmp_dws_cust_asse_liab_policy_base
 * 来源: TB.ddl
 */

-- crmdm.tmp_dws_cust_asse_liab_policy_base 定义

-- Drop table

-- DROP TABLE crmdm.tmp_dws_cust_asse_liab_policy_base;

CREATE TABLE crmdm.tmp_dws_cust_asse_liab_policy_base (
    cust_id varchar(20) NULL,
    acct_id varchar(40) NULL,
    prdkt_id varchar(40) NULL,
    prdkt_cate_big varchar(40) NULL,
    insur_bid_form_no varchar(40) NULL,
    policy_key varchar(200) NULL,
    first_tx_dt DATE NULL,
    bgn_dt DATE NULL,
    cancl_dt DATE NULL,
    pay_upto_dt DATE NULL,
    pay_patrn varchar(2) NULL,
    pay_period_typ varchar(2) NULL,
    pay_period numeric(20,
    2) NULL,
    first_insur_amt numeric(20,
    2) NULL
);

