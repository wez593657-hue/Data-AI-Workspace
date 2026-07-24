/*
 * 临时表
 * 表名: crmdm.tmp_dws_cust_asse_liab_last_status
 * 来源: TB.ddl
 */

-- crmdm.tmp_dws_cust_asse_liab_last_status 定义

-- Drop table

-- DROP TABLE crmdm.tmp_dws_cust_asse_liab_last_status;

CREATE TABLE crmdm.tmp_dws_cust_asse_liab_last_status (
    policy_key varchar(200) NULL,
    last_status_tx_typ varchar(10) NULL,
    last_status_dt DATE NULL
);

