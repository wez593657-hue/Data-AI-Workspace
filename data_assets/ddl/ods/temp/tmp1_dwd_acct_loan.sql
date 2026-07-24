/*
 * 临时表
 * 表名: crmdm.tmp1_dwd_acct_loan
 * 来源: TB.ddl
 */

-- crmdm.tmp1_dwd_acct_loan 定义

-- Drop table

-- DROP TABLE crmdm.tmp1_dwd_acct_loan;

CREATE TABLE crmdm.tmp1_dwd_acct_loan (
    iou_no varchar(40) NULL,
    prdkt_id varchar(40) NULL,
    loan_issu_amt numeric(24,
    2) NULL,
    loan_issu_date varchar(10) NULL,
    bal numeric NULL,
    expr_date varchar(10) NULL,
    acct_state varchar(10) NULL,
    persn_legal_bk_code text NULL,
    repay_typ varchar(32) NULL,
    cate_5lvl varchar(10) NULL,
    int_arrears_ttl numeric NULL,
    customerid varchar(40) NULL,
    productid varchar(40) NULL,
    contractserialno varchar(40) NULL
);

