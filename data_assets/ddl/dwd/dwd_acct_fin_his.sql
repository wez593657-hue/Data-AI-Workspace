/*
 * DWD层表
 * 表名: crmdm.dwd_acct_fin_his
 * 来源: TB.ddl
 */

-- crmdm.dwd_acct_fin_his 定义

-- Drop table

-- DROP TABLE crmdm.dwd_acct_fin_his;

CREATE TABLE crmdm.dwd_acct_fin_his (
    cust_id varchar(21) NULL,
    cust_typ varchar(4) NULL,
    acct_id varchar(40) NULL,
    card_no varchar(30) NULL,
    prdkt_id varchar(40) NULL,
    prdkt_name varchar(100) NULL,
    prdkt_cate_big varchar(64) NULL,
    estab_date varchar(10) NULL,
    fin_amt numeric(18,
    4) NULL,
    rate_intri numeric(18,
    4) NULL,
    acct_state varchar(10) NULL,
    intri_bgn_date varchar(10) NULL,
    expr_date varchar(10) NULL,
    oprt_org varchar(7) NULL,
    chnl_no varchar(10) NULL,
    persn_legal_bk_code varchar(30) NULL,
    issu_org varchar(30) NULL,
    issu_date varchar(10) NULL,
    risk_lvl varchar(10) NULL
);



COMMENT ON TABLE DWD_ACCT_FIN_HIS IS '【待补充】';