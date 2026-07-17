/*
 * 上游中间业务系统
 * 表名: crmdm.ibp_ybt_policy_base_info
 * 来源: TB.ddl
 */

-- crmdm.ibp_ybt_policy_base_info 定义

-- Drop table

-- DROP TABLE crmdm.ibp_ybt_policy_base_info;

CREATE TABLE crmdm.ibp_ybt_policy_base_info (
	plat_policy_serial varchar(200) NOT NULL,
	item_id varchar(40) NOT NULL,
	is_real varchar(8) NOT NULL,
	cont_no varchar(200) NULL,
	proposal_prt_no varchar(200) NOT NULL,
	cont_prt_no varchar(200) NULL,
	accept_date varchar(32) NOT NULL,
	appointvali_date varchar(32) NULL,
	vali_date varchar(32) NULL,
	insuend_date varchar(32) NULL,
	pay_start_date varchar(32) NULL,
	payend_date varchar(32) NULL,
	product_id varchar(200) NOT NULL,
	product_name varchar(800) NOT NULL,
	cont_status varchar(8) NOT NULL,
	cont_source varchar(8) NOT NULL,
	risk_grade varchar(8) NOT NULL,
	commission_type varchar(8) NOT NULL,
	commission_ratio numeric(6, 3) NULL,
	commissionamt numeric(17, 2) NULL,
	acc_name varchar(200) NOT NULL,
	acc_no varchar(200) NOT NULL,
	get_pol_mode varchar(8) NULL,
	throw_com varchar(200) NOT NULL,
	throw_com_name varchar(800) NULL,
	throw_com_certi_code varchar(200) NULL,
	teller_name varchar(800) NULL,
	teller_id varchar(80) NULL,
	teller_certi_code varchar(200) NULL,
	teller_email varchar(200) NULL,
	manager_no varchar(200) NULL,
	manager_name varchar(800) NULL,
	agent_code varchar(200) NULL,
	agent_name varchar(800) NULL,
	agent_grp_code varchar(200) NULL,
	agent_grp_name varchar(200) NULL,
	agent_com varchar(200) NULL,
	agent_com_name varchar(800) NULL,
	com_code varchar(200) NULL,
	com_location varchar(800) NULL,
	com_name varchar(800) NULL,
	com_zip_code varchar(200) NULL,
	com_phone varchar(80) NULL,
	job_notice varchar(8) NULL,
	health_notice varchar(8) NULL,
	policy_indicator varchar(8) NULL,
	total_faceamount numeric(17, 2) NULL,
	hesitate_end_date varchar(32) NULL,
	acc_transfer_num varchar(200) NULL,
	acc_eff_date varchar(8) NULL,
	quality_status varchar(2) NULL,
	session_id varchar(800) NULL,
	plat_date varchar(8) NULL,
	plat_time varchar(6) NULL,
	record_no varchar(256) NULL,
	ryzd varchar(1) NULL,
	CONSTRAINT pk_ibp_ybt_policy_base_info PRIMARY KEY (plat_policy_serial)
);

