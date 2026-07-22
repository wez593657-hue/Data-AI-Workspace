/*
 * DWS层表
 * 表名: crmdm.dws_cust_asse_liab_cumu_his
 * 来源: TB.ddl
 */

-- crmdm.dws_cust_asse_liab_cumu_his 定义

-- Drop table

-- DROP TABLE crmdm.dws_cust_asse_liab_cumu_his;

CREATE TABLE crmdm.dws_cust_asse_liab_cumu_his (
    data_date varchar(8) NOT NULL,
    persn_legal_bk_code varchar(7) NULL,
    oprt_org varchar(7) NULL,
    cust_id varchar(20) NOT NULL,
    acct_id varchar(40) NOT NULL,
    prdkt_id varchar(40) NOT NULL,
    prdkt_cate_big varchar(40) NULL,
    prdkt_typ varchar(1) NULL,
    bal numeric(20,
    2) NULL,
    mth_bal numeric(20,
    2) NULL,
    qrt_bal numeric(20,
    2) NULL,
    yar_bal numeric(20,
    2) NULL,
    mth_days numeric(20,
    2) NULL,
    qrt_days numeric(20,
    2) NULL,
    yar_days numeric(20,
    2) NULL
);



COMMENT ON TABLE DWS_CUST_ASSE_LIAB_CUMU_HIS IS '【待补充】';