/*
 * 上游手机系统
 * 表名: crmdm.mbk_cust_info
 * 来源: TB.ddl
 */

-- crmdm.mbk_cust_info 定义

-- Drop table

-- DROP TABLE crmdm.mbk_cust_info;

CREATE TABLE crmdm.mbk_cust_info (
	cust_no varchar(32) NOT NULL,
	cert_id varchar(64) NULL,
	incorp_no varchar(16) NULL,
	cust_core_no varchar(16) NULL,
	cust_name varchar(64) NULL,
	cust_cert_type varchar(6) NULL,
	cust_cert_no varchar(80) NULL,
	cust_mobile varchar(11) NOT NULL,
	cust_lgn_name varchar(32) NULL,
	cust_cap_lvl varchar(2) NOT NULL,
	cust_is_idtfy_verify bpchar(1) NOT NULL,
	cust_org_no varchar(16) NULL,
	cust_open_date varchar(10) NOT NULL,
	cust_open_time varchar(8) NOT NULL,
	cust_open_chnl varchar(3) NOT NULL,
	cust_status bpchar(1) NOT NULL,
	cust_freeze_date varchar(10) NULL,
	cust_freeze_time varchar(8) NULL,
	cust_close_date varchar(10) NULL,
	cust_close_time varchar(8) NULL,
	cust_idtfy_verify_num varchar(10) NULL,
	cust_is_old bpchar(1) NULL,
	cust_old_password bpchar(1) NULL,
	encrypt_type bpchar(1) NULL,
	is_first varchar(1) NULL,
	user_last_login_date varchar(10) NULL,
	ryzd varchar(1) NULL,
	CONSTRAINT pk_mbk_cust_info PRIMARY KEY (cust_no)
);

