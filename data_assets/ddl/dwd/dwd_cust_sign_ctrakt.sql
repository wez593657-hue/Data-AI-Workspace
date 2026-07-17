/*
 * DWD层表
 * 表名: crmdm.dwd_cust_sign_ctrakt
 * 来源: TB.ddl
 */

-- crmdm.dwd_cust_sign_ctrakt 定义

-- Drop table

-- DROP TABLE crmdm.dwd_cust_sign_ctrakt;

CREATE TABLE crmdm.dwd_cust_sign_ctrakt (
	cust_id varchar(21) NULL,
	ctrakt_acct varchar(40) NULL,
	ctrakt_typ varchar(6) NULL,
	ctrakt_date varchar(10) NULL,
	phone_no varchar(32) NULL,
	ctrakt_org varchar(30) NULL,
	ctrakt_oprtr varchar(64) NULL,
	ctrakt_state varchar(6) NULL,
	persn_legal_bk_code varchar(30) NULL
);

