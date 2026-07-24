/*
 * 临时表
 * 表名: crmdm.tmp_dws_cust_asse_liab_insur_bal
 * 来源: TB.ddl
 */

-- crmdm.tmp_dws_cust_asse_liab_insur_bal 定义

-- Drop table

-- DROP TABLE crmdm.tmp_dws_cust_asse_liab_insur_bal;

CREATE TABLE crmdm.tmp_dws_cust_asse_liab_insur_bal (
    data_date varchar(8) NULL,
    cust_id varchar(20) NULL,
    acct_id varchar(40) NULL,
    prdkt_id varchar(40) NULL,
    prdkt_cate_big varchar(40) NULL,
    bal numeric(20,
    2) NULL
);

