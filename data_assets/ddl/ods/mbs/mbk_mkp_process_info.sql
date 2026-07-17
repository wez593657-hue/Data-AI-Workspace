/*
 * 上游手机系统
 * 表名: crmdm.mbk_mkp_process_info
 * 来源: TB.ddl
 */

-- crmdm.mbk_mkp_process_info 定义

-- Drop table

-- DROP TABLE crmdm.mbk_mkp_process_info;

CREATE TABLE crmdm.mbk_mkp_process_info (
	trans_sn varchar(128) NOT NULL,
	sence_status varchar(1) NULL,
	sence_code varchar(10) NULL,
	sence_value varchar(10) NULL,
	sence_time varchar(20) NULL,
	cust_no varchar(32) NULL,
	cust_lvl varchar(6) NULL,
	cust_org varchar(20) NULL,
	ryzd varchar(1) NULL,
	CONSTRAINT pk_mbk_mkp_process_info PRIMARY KEY (trans_sn)
);

