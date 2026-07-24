/*
 * 临时表
 * 表名: crmdm.tmp_dws_cust_asse_liab_his_agg
 * 来源: TB.ddl
 */

-- crmdm.tmp_dws_cust_asse_liab_his_agg 定义

-- Drop table

-- DROP TABLE crmdm.tmp_dws_cust_asse_liab_his_agg;

CREATE TABLE crmdm.tmp_dws_cust_asse_liab_his_agg (
    cust_id varchar(20) NULL,
    acct_id varchar(40) NULL,
    prdkt_id varchar(40) NULL,
    prdkt_cate_big varchar(40) NULL,
    prdkt_typ varchar(1) NULL,
    his_mth_bal numeric(20,
    2) NULL,
    his_qrt_bal numeric(20,
    2) NULL,
    his_yar_bal numeric(20,
    2) NULL
);

