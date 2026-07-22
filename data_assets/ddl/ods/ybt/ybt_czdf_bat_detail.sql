/*
 * 上游银保通系统
 * 表名: crmdm.ybt_czdf_bat_detail
 * 来源: TB.ddl
 */

-- crmdm.ybt_czdf_bat_detail 定义

-- Drop table

-- DROP TABLE crmdm.ybt_czdf_bat_detail;

CREATE TABLE crmdm.ybt_czdf_bat_detail (
    batch_no varchar(30) NOT NULL,
    serial_id varchar(12) NOT NULL,
    bank_name varchar(400) NULL,
    payee_id varchar(32) NULL,
    payee_name varchar(128) NULL,
    coll_account varchar(20) NULL,
    amt numeric(20,
    2) NOT NULL,
    remark varchar(240) NULL,
    core_send_serial varchar(32) NULL,
    core_ref_serial varchar(32) NULL,
    status varchar(1) NOT NULL,
    rst_memo varchar(400) NULL,
    tran_channel varchar(32) NULL,
    bank_acct_no varchar(80) NULL,
    third_batch varchar(30) NULL,
    is_other_bank varchar(1) NULL,
    tel varchar(50) NULL,
    ryzd varchar(1) NULL,
    CONSTRAINT pk_ybt_czdf_bat_detail PRIMARY KEY (serial_id)
);