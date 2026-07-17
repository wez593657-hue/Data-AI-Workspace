/*
 * DWD层表
 * 表名: crmdm.dwd_cust_indv_info
 * 来源: TB.ddl
 */

-- crmdm.dwd_cust_indv_info 定义

-- Drop table

-- DROP TABLE crmdm.dwd_cust_indv_info;

CREATE TABLE crmdm.dwd_cust_indv_info (
	cust_id varchar(20) NULL,
	cust_name varchar(100) NULL,
	cert_typ varchar(6) NULL,
	cert_id varchar(32) NULL,
	cert_prd_vlid varchar(10) NULL,
	cert_prd_vlid_end varchar(10) NULL,
	cert_issuing_authority varchar(100) NULL,
	cust_typ varchar(2) NULL,
	nationality varchar(6) NULL,
	nation varchar(6) NULL,
	mari_situ varchar(6) NULL,
	max_deg_edu varchar(6) NULL,
	now_enter varchar(120) NULL,
	occu_cls varchar(6) NULL,
	persn_legal_bk_code varchar(4) NULL,
	gend varchar(2) NULL,
	phone_no varchar(20) NULL,
	contact_address varchar(254) NULL,
	contact_address_detail varchar(254) NULL,
	id_address varchar(254) NULL,
	id_address_detail varchar(254) NULL,
	home_address varchar(254) NULL,
	home_address_detail varchar(254) NULL,
	residence_address varchar(254) NULL,
	residence_address_detail varchar(254) NULL,
	office_address varchar(254) NULL,
	office_address_detail varchar(254) NULL
);

