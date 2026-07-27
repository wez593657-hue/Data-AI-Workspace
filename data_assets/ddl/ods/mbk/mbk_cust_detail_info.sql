-- crmdm.mbk_cust_detail_info 定义

-- Drop table

-- DROP TABLE crmdm.mbk_cust_detail_info;

CREATE TABLE crmdm.mbk_cust_detail_info (
	cust_no varchar(32) NULL,
	ecif_no varchar(32) NULL,
	ecif_mobile varchar(11) NULL,
	idt_end_date varchar(10) NULL,
	cust_eng_name varchar(60) NULL,
	cust_sex bpchar(1) NULL,
	cust_birth varchar(20) NULL,
	cust_contact_tel varchar(20) NULL,
	cust_addr varchar(200) NULL,
	cust_zip_code varchar(6) NULL,
	cust_email varchar(50) NULL,
	cust_is_emp bpchar(1) NULL,
	portrait_url varchar(200) NULL,
	cust_manager varchar(32) NULL,
	cust_mem_lvl varchar(2) NULL,
	cust_growth int4 NULL,
	cust_credit int4 NULL,
	cust_mkt_org_no varchar(16) NULL,
	ryzd varchar(1) NULL
);
