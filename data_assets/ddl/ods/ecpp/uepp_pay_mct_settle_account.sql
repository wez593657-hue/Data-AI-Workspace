/*
 * 上游网联系统
 * 表名: crmdm.uepp_pay_mct_settle_account
 * 来源: TB.ddl
 */

-- crmdm.uepp_pay_mct_settle_account 定义

-- Drop table

-- DROP TABLE crmdm.uepp_pay_mct_settle_account;

CREATE TABLE crmdm.uepp_pay_mct_settle_account (
	mct_id varchar(40) NOT NULL,
	acct_type varchar(2) NULL,
	bank_account varchar(50) NULL,
	bank_acct_name varchar(100) NULL,
	provice varchar(10) NULL,
	city varchar(10) NULL,
	open_bankno varchar(20) NULL,
	open_bankname varchar(60) NULL,
	is_self varchar(1) NULL,
	cert_phone varchar(11) NULL,
	cert_type varchar(2) NULL,
	cert_no varchar(50) NULL,
	status varchar(1) NULL,
	remark varchar(100) NULL,
	channel varchar(40) NOT NULL,
	create_user varchar(40) NULL,
	create_time varchar(20) NULL,
	update_user varchar(40) NULL,
	update_time varchar(20) NULL,
	check_status varchar(2) NULL,
	check_task_id varchar(40) NULL,
	is_default varchar(1) NULL,
	cust_no varchar(32) NULL,
	cust_cn_name varchar(500) NULL,
	acc_bal varchar(40) NULL,
	old_cust_no varchar(40) NULL,
	ryzd varchar(1) NULL,
	CONSTRAINT pk_uepp_pay_mct_settle_account PRIMARY KEY (mct_id, channel)
);

