/*
 * 上游中间业务系统
 * 表名: crmdm.ibp_scsb_bat_detail
 * 来源: TB.ddl
 */

-- crmdm.ibp_scsb_bat_detail 定义

-- Drop table

-- DROP TABLE crmdm.ibp_scsb_bat_detail;

CREATE TABLE crmdm.ibp_scsb_bat_detail (
    bat_no varchar(18) NOT NULL,
    det_no varchar(10) NOT NULL,
    sb_no varchar(20) NOT NULL,
    "name" varchar(400) NULL,
    acct varchar(30) NOT NULL,
    id_no varchar(18) NULL,
    id_type varchar(2) NULL,
    amt numeric(17,
    2) NOT NULL,
    memo varchar(200) NULL,
    bank_no varchar(20) NULL,
    sb_serial varchar(20) NULL,
    payee_type varchar(2) NOT NULL,
    is_other_bank varchar(2) NOT NULL,
    core_send_serial varchar(32) NULL,
    core_ref_serial varchar(32) NULL,
    pay_send_serial varchar(32) NULL,
    pay_ref_serial varchar(32) NULL,
    rst_memo varchar(512) NULL,
    status varchar(1) NOT NULL,
    re_status varchar(1) NOT NULL,
    remark varchar(128) NULL,
    addtional varchar(128) NULL,
    tran_channel varchar(10) NULL,
    back_status varchar(1) NULL,
    bank_name varchar(400) NULL,
    ignore_limit varchar(1) NULL,
    ryzd varchar(1) NULL,
    CONSTRAINT pk_ibp_scsb_bat_detail PRIMARY KEY (bat_no,
    det_no)
);