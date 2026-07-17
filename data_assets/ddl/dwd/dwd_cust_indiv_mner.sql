/*
 * DWD层表
 * 表名: crmdm.dwd_cust_indiv_mner
 * 来源: TB.ddl
 */

-- crmdm.dwd_cust_indiv_mner 定义

-- Drop table

-- DROP TABLE crmdm.dwd_cust_indiv_mner;

CREATE TABLE crmdm.dwd_cust_indiv_mner (
	cust_id varchar(20) NULL,
	mber_name varchar(200) NULL,
	mber_rel varchar(6) NULL,
	gend varchar(6) NULL,
	tel_no varchar(32) NULL,
	bk_self_cust_flg varchar(1) NULL,
	inner_bk_cust_id varchar(20) NULL,
	bth_date varchar(10) NULL,
	mari_day_mem varchar(10) NULL,
	cert_id varchar(40) NULL,
	cert_typ varchar(10) NULL,
	sys_src varchar(500) NULL,
	persn_legal_bk_code varchar(4) NULL,
	pk_id varchar(40) NULL,
	post_id varchar(20) NULL,
	remark varchar(200) NULL
);



COMMENT ON TABLE DWD_CUST_INDIV_MNER IS '【待补充】';
