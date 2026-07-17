/*
 * 上游手机系统
 * 表名: crmdm.mbk_cust_log_login
 * 来源: TB.ddl
 */

-- crmdm.mbk_cust_log_login 定义

-- Drop table

-- DROP TABLE crmdm.mbk_cust_log_login;

CREATE TABLE crmdm.mbk_cust_log_login (
	tran_sn varchar(32) NOT NULL,
	cust_no varchar(32) NOT NULL,
	lgn_date varchar(10) NOT NULL,
	lgn_time varchar(8) NOT NULL,
	lgt_date_time varchar(20) NULL,
	lgt_type varchar(6) NULL,
	lgn_status varchar(2) NOT NULL,
	lgn_err_code varchar(32) NULL,
	lgn_err_msg varchar(150) NULL,
	lgn_chnl varchar(3) NULL,
	lgn_addr varchar(64) NULL,
	lgn_ip varchar(15) NULL,
	lgn_mac varchar(128) NULL,
	lgn_client_id varchar(128) NULL,
	lgn_sess_id varchar(64) NULL,
	lgn_os varchar(64) NULL,
	lgn_client_type bpchar(1) NULL,
	lgn_client_ver varchar(10) NULL,
	lgn_x_line varchar(10) NULL,
	lgn_y_line varchar(10) NULL,
	ryzd varchar(1) NULL,
	CONSTRAINT pk_mbk_cust_log_login PRIMARY KEY (tran_sn, cust_no)
);

