/*
 * 上游手机系统
 * 表名: crmdm.mbk_cust_log_fee
 * 来源: TB.ddl
 */

-- crmdm.mbk_cust_log_fee 定义

-- Drop table

-- DROP TABLE crmdm.mbk_cust_log_fee;

CREATE TABLE crmdm.mbk_cust_log_fee (
    tran_sn varchar(32) NOT NULL,
    cust_name varchar(64) NULL,
    item_id varchar(100) NULL,
    tran_type varchar(5) NULL,
    ccy varchar(30) NOT NULL,
    tran_date varchar(10) NULL,
    tran_time varchar(8) NULL,
    acct varchar(32) NULL,
    tran_amt varchar(20) NULL,
    tran_method bpchar(1) NULL,
    discount_num varchar(50) NULL,
    tran_status varchar(2) NULL,
    discount_type varchar(20) NULL,
    discount_amt varchar(20) NULL,
    discount_remark varchar(100) NULL,
    cust_no varchar(32) NULL,
    dept_id varchar(50) NULL,
    order_no varchar(50) NULL,
    prod_id varchar(60) NULL,
    prod_name varchar(60) NULL,
    student_name varchar(20) NULL,
    pay_name varchar(20) NULL,
    pay_no varchar(40) NULL,
    pay_sub varchar(5) NULL,
    pay_term varchar(20) NULL,
    ryzd varchar(1) NULL,
    CONSTRAINT pk_mbk_cust_log_fee PRIMARY KEY (tran_sn)
);