/*
 * 上游银保通系统
 * 表名: crmdm.ybt_ybt_policy_fee_list
 * 来源: TB.ddl
 */

-- crmdm.ybt_ybt_policy_fee_list 定义

-- Drop table

-- DROP TABLE crmdm.ybt_ybt_policy_fee_list;

CREATE TABLE crmdm.ybt_ybt_policy_fee_list (
    plat_policy_serial varchar(200) NOT NULL,
    cont_no varchar(200) NULL,
    ord_item_id varchar(40) NOT NULL,
    ord_type varchar(16) NOT NULL,
    ord_id varchar(200) NOT NULL,
    ord_ori_id varchar(200) NULL,
    ord_memo varchar(2000) NULL,
    ord_amt numeric(17,
    2) NULL,
    pre_amt numeric(17,
    2) NULL,
    ord_create_date varchar(32) NULL,
    ord_create_time varchar(24) NULL,
    ord_expires_date varchar(32) NULL,
    ord_expires_time varchar(24) NULL,
    ord_pay_serial varchar(200) NULL,
    ord_link_user_name varchar(800) NULL,
    ord_link_user_phone varchar(200) NULL,
    ordpayeracc_no varchar(200) NULL,
    ordpayeracc_name varchar(800) NULL,
    ordpayer_bank_no varchar(200) NULL,
    ordpayer_bank_name varchar(800) NULL,
    ord_payee_acct_no varchar(200) NULL,
    ord_payee_acct_name varchar(800) NULL,
    ord_payee_bank_no varchar(200) NULL,
    ord_payee_bank_name varchar(800) NULL,
    ord_part_pay_flag varchar(8) NULL,
    ord_thr_sum_amt numeric(17,
    2) NULL,
    ord_thr_payed_amt numeric(17,
    2) NOT NULL,
    ord_tran_status varchar(8) NULL,
    tran_type varchar(8) NULL,
    tran_soure varchar(8) NOT NULL,
    prem_text varchar(200) NULL,
    trans_no varchar(200) NULL,
    hole_memo1 varchar(800) NULL,
    hole_memo2 varchar(800) NULL,
    hole_memo3 varchar(800) NULL,
    ryzd varchar(1) NULL,
    CONSTRAINT pk_ybt_ybt_policy_fee_list PRIMARY KEY (plat_policy_serial)
);