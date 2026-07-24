/*
 * 临时表
 * 表名: crmdm.tmp_dws_cust_asse_liab_pay_tx
 * 来源: TB.ddl
 */

-- crmdm.tmp_dws_cust_asse_liab_pay_tx 定义

-- Drop table

-- DROP TABLE crmdm.tmp_dws_cust_asse_liab_pay_tx;

CREATE TABLE crmdm.tmp_dws_cust_asse_liab_pay_tx (
    policy_key varchar(200) NULL,
    pay_tx_key varchar(240) NULL,
    tx_dt DATE NULL,
    insur_amt numeric(20,
    2) NULL,
    pay_seq numeric(20,
    2) NULL
);

