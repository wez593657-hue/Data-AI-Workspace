/*
 * 临时表
 * 表名: crmdm.tmp_dws_cust_asse_liab_insur_tx
 * 来源: TB.ddl
 */

-- crmdm.tmp_dws_cust_asse_liab_insur_tx 定义

-- Drop table

-- DROP TABLE crmdm.tmp_dws_cust_asse_liab_insur_tx;

CREATE TABLE crmdm.tmp_dws_cust_asse_liab_insur_tx (
    cust_id varchar(20) NULL,
    acct_id varchar(40) NULL,
    prdkt_id varchar(40) NULL,
    prdkt_cate_big varchar(40) NULL,
    insur_bid_form_no varchar(40) NULL,
    tx_typ varchar(10) NULL,
    tx_dt DATE NULL,
    bgn_dt DATE NULL,
    cancl_dt DATE NULL,
    pay_upto_dt DATE NULL,
    pay_patrn varchar(2) NULL,
    pay_period_typ varchar(2) NULL,
    pay_period numeric(20,
    2) NULL,
    insur_amt numeric(20,
    2) NULL,
    policy_key varchar(200) NULL,
    tx_seq numeric(20,
    2) NULL,
    tx_key varchar(240) NULL
);

