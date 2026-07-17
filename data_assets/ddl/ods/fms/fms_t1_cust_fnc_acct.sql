/*
 * 上游理财系统
 * 表名: crmdm.fms_t1_cust_fnc_acct
 * 来源: TB.ddl
 */

-- crmdm.fms_t1_cust_fnc_acct 定义

-- Drop table

-- DROP TABLE crmdm.fms_t1_cust_fnc_acct;

CREATE TABLE crmdm.fms_t1_cust_fnc_acct (
	fnc_trans_acct_no varchar(17) NULL,
	cust_no varchar(20) NULL,
	card_type varchar(8) NULL,
	card_no varchar(32) NULL,
	acct_no varchar(32) NULL,
	acct_nm varchar(128) NULL,
	sub_acct_no varchar(32) NULL,
	trans_pwd varchar(64) NULL,
	cur varchar(8) NULL,
	cust_level varchar(8) NULL,
	cust_card_type varchar(8) NULL,
	acct_status bpchar(1) NULL,
	bank_code varchar(20) NULL,
	branch_code varchar(20) NULL,
	sub_branch_code varchar(20) NULL,
	inputuser varchar(20) NULL,
	iss_bank_code varchar(20) NULL,
	iss_branch_code varchar(20) NULL,
	iss_sub_branch_code varchar(20) NULL,
	crt_date bpchar(8) NULL,
	crt_time bpchar(6) NULL,
	inv_date bpchar(8) NULL,
	inv_time bpchar(6) NULL,
	remark varchar(255) NULL,
	upd_date bpchar(8) NULL,
	upd_time bpchar(6) NULL,
	tradingmethod varchar(3) NULL,
	legal_code varchar(32) NULL,
	ryzd varchar(1) NULL
);

