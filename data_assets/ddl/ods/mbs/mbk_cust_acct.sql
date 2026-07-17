/*
 * 上游手机系统
 * 表名: crmdm.mbk_cust_acct
 * 来源: TB.ddl
 */

-- crmdm.mbk_cust_acct 定义

-- Drop table

-- DROP TABLE crmdm.mbk_cust_acct;

CREATE TABLE crmdm.mbk_cust_acct (
	cust_no varchar(32) NOT NULL,
	acct varchar(32) NOT NULL,
	acct_lvl varchar(2) NOT NULL,
	acct_open_org varchar(16) NULL,
	acct_type bpchar(1) NOT NULL,
	acct_alias varchar(64) NULL,
	is_deft_acct bpchar(1) NOT NULL,
	acct_sort numeric NOT NULL,
	sub_acct varchar(32) NULL,
	acct_open_way bpchar(1) NOT NULL,
	acct_add_chnl varchar(3) NOT NULL,
	acct_add_date varchar(10) NOT NULL,
	acct_add_time varchar(8) NOT NULL,
	is_town bpchar(1) NULL,
	is_sign bpchar(1) NOT NULL,
	ryzd varchar(1) NULL,
	CONSTRAINT pk_mbk_cust_acct PRIMARY KEY (cust_no, acct)
);

