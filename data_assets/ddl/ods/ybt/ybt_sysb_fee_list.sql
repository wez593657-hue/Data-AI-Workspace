/*
 * 上游银保通系统
 * 表名: crmdm.ybt_sysb_fee_list
 * 来源: TB.ddl
 */

-- crmdm.ybt_sysb_fee_list 定义

-- Drop table

-- DROP TABLE crmdm.ybt_sysb_fee_list;

CREATE TABLE crmdm.ybt_sysb_fee_list (
    query_serial varchar(120) NOT NULL,
    pay_serial varchar(120) NULL,
    service_id varchar(20) NOT NULL,
    batch_no varchar(32) NULL,
    item_id varchar(40) NOT NULL,
    id_type varchar(3) NOT NULL,
    id_no varchar(88) NOT NULL,
    user_name varchar(200) NULL,
    user_id varchar(120) NULL,
    user_type varchar(1) NULL,
    user_insurance_type varchar(5) NULL,
    pay_type varchar(1) NULL,
    pay_acct_no varchar(200) NULL,
    pay_acct_name varchar(400) NULL,
    total_amt numeric(18,
    2) NOT NULL,
    pay_date varchar(4) NULL,
    start_date varchar(6) NULL,
    end_date varchar(6) NULL,
    base_amt numeric(18,
    2) NULL,
    amt numeric(18,
    2) NULL,
    tax_serial varchar(80) NULL,
    bank_serial varchar(160) NULL,
    print_count varchar(50) NULL,
    vor_type varchar(1) NULL,
    det_count numeric NULL,
    ac_bank_type varchar(4) NULL,
    ac_bank_code varchar(12) NULL,
    ac_bank_name varchar(320) NULL,
    sett_date varchar(8) NULL,
    sett_bank_type varchar(4) NULL,
    sett_bank_code varchar(12) NULL,
    sett_bank_name varchar(320) NULL,
    sett_bank_account varchar(50) NULL,
    tax_no varchar(30) NULL,
    ret_code varchar(12) NULL,
    ret_msg varchar(500) NULL,
    ac_branch varchar(8) NULL,
    sett_branch varchar(8) NULL,
    zhaiyoms varchar(1200) NULL,
    ori_acct_no varchar(200) NULL,
    swjgmc varchar(400) NULL,
    swjgdm varchar(20) NULL,
    dcmc varchar(120) NULL,
    chk_status varchar(1) NULL,
    trans_type varchar(10) NULL,
    chk_amt numeric(18,
    2) NULL,
    chk_date varchar(8) NULL,
    chk_memo varchar(800) NULL,
    phone varchar(60) NULL,
    address varchar(300) NULL,
    ryzd varchar(1) NULL,
    CONSTRAINT pk_ybt_sysb_fee_list PRIMARY KEY (query_serial)
);