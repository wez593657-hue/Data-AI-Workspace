/*
 * 上游理财系统
 * 表名: crmdm.fms_td_cust_vol
 * 来源: TB.ddl
 */

-- crmdm.fms_td_cust_vol 定义

-- Drop table

-- DROP TABLE crmdm.fms_td_cust_vol;

CREATE TABLE crmdm.fms_td_cust_vol (
    fnc_trans_acct_no varchar(24) NULL,
    ta_acct_no varchar(32) NULL,
    tano varchar(16) NULL,
    prod_code varchar(32) NULL,
    share_class bpchar(1) NULL,
    cust_no varchar(32) NULL,
    total_amt numeric(32,
    2) NULL,
    total_vol numeric(32,
    2) NULL,
    trans_frozen_vol numeric(32,
    2) NULL,
    elisor_frozen_vol numeric(32,
    2) NULL,
    abn_frozen_vol numeric(32,
    2) NULL,
    ta_frozen_vol numeric(32,
    2) NULL,
    undistribute_monetary_income numeric(32,
    2) NULL,
    hold_cost numeric(32,
    2) NULL,
    upd_date varchar(8) NULL,
    upd_time varchar(6) NULL,
    legal_code varchar(32) NULL,
    attorn_out_vol numeric(32,
    2) NULL,
    attorn_into_vol numeric(32,
    2) NULL,
    attorn_into_frozen_vol numeric(32,
    2) NULL,
    trans_redem_vol numeric(32,
    2) NULL,
    total_buy_amt numeric(32,
    2) NULL,
    total_buy_vol numeric(32,
    2) NULL,
    total_redeem_amt numeric(32,
    2) NULL,
    total_redeem_vol numeric(32,
    2) NULL,
    total_income_amt numeric(32,
    2) NULL,
    total_income_cash numeric(32,
    2) NULL,
    total_income_reinvestment numeric(32,
    2) NULL,
    ryzd varchar(1) NULL
);