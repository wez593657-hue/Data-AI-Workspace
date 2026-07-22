/*
 * 上游银保通系统
 * 表名: crmdm.ybt_lssb_trans_detail
 * 来源: TB.ddl
 */

-- crmdm.ybt_lssb_trans_detail 定义

-- Drop table

-- DROP TABLE crmdm.ybt_lssb_trans_detail;

CREATE TABLE crmdm.ybt_lssb_trans_detail (
    plat_serial varchar(20) NOT NULL,
    tran_code varchar(8) NULL,
    batch_no varchar(18) NULL,
    id varchar(32) NULL,
    batch_message varchar(128) NULL,
    "type" varchar(3) NULL,
    branch_code varchar(8) NULL,
    soc_no varchar(20) NULL,
    idno varchar(20) NOT NULL,
    "name" varchar(100) NULL,
    billno varchar(32) NOT NULL,
    bank_code varchar(8) NULL,
    pboc_code varchar(16) NULL,
    pboc_name varchar(128) NULL,
    acct_name varchar(100) NULL,
    acct_no varchar(32) NULL,
    socs_branch_code varchar(8) NULL,
    socs_acct_name varchar(100) NULL,
    socs_acct_no varchar(32) NULL,
    date_no varchar(10) NULL,
    tran_amt numeric(12,
    2) NULL,
    remark varchar(100) NULL,
    core_send_serial varchar(32) NULL,
    core_ref_serial varchar(32) NULL,
    rst_memo varchar(500) NULL,
    status varchar(1) NULL,
    tran_channel varchar(32) NULL,
    ryzd varchar(1) NULL
);