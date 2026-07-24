/*
 * 临时表
 * 表名: crmdm.tmp_dws_cust_asse_liab_last_paid
 * 来源: TB.ddl
 */

-- crmdm.tmp_dws_cust_asse_liab_last_paid 定义

-- Drop table

-- DROP TABLE crmdm.tmp_dws_cust_asse_liab_last_paid;

CREATE TABLE crmdm.tmp_dws_cust_asse_liab_last_paid (
    policy_key varchar(200) NULL,
    last_paid_amt numeric(20,
    2) NULL
);

