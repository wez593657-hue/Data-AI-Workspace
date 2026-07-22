/*
 * 上游理财系统
 * 表名: crmdm.fms_t5_cust_vol
 * 来源: TB.ddl
 */

-- crmdm.fms_t5_cust_vol 定义

-- Drop table

-- DROP TABLE crmdm.fms_t5_cust_vol;

CREATE TABLE crmdm.fms_t5_cust_vol (
    cust_no varchar(20) NOT NULL,
    fnc_trans_acct_no varchar(17) NOT NULL,
    prod_code varchar(32) NOT NULL,
    distributor_code varchar(14) DEFAULT '0 '::varchar NOT NULL,
    self_fnc_acct_no bpchar(12) NULL,
    total_vol numeric(16,
    2) NOT NULL,
    buy_amt numeric(16,
    2) NOT NULL,
    trans_frozen_vol numeric(16,
    2) NULL,
    abnm_frozen_vol numeric(16,
    2) NULL,
    redeem_amt numeric(16,
    2) NOT NULL,
    unconvert_income numeric(20,
    6) NULL,
    convert_income numeric(20,
    6) NOT NULL,
    crt_date bpchar(8) NOT NULL,
    crt_time bpchar(6) NOT NULL,
    remark varchar(255) NULL,
    upd_date bpchar(8) NOT NULL,
    upd_time bpchar(6) NOT NULL,
    cust_manager varchar(20) NULL,
    fm_manager varchar(20) NULL,
    last_vol_change_date bpchar(8) NOT NULL,
    elisor_frozen_vol numeric(16,
    2) NULL,
    frozen_vol numeric(16,
    2) NULL,
    acc_income numeric(16,
    2) NULL,
    ryzd varchar(1) NULL,
    CONSTRAINT pk_fms_t5_cust_vol PRIMARY KEY (cust_no,
    fnc_trans_acct_no,
    prod_code,
    distributor_code)
);