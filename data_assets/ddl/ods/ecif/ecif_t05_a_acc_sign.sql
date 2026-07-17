/*
 * 上游ECIF系统
 * 表名: crmdm.ecif_t05_a_acc_sign
 * 来源: TB.ddl
 */

-- crmdm.ecif_t05_a_acc_sign 定义

-- Drop table

-- DROP TABLE crmdm.ecif_t05_a_acc_sign;

CREATE TABLE crmdm.ecif_t05_a_acc_sign (
	acc_sign_id bpchar(20) NOT NULL,
	sign_prd_2 varchar(200) NULL,
	sign_prd_3 varchar(200) NULL,
	balance_dis_flag bpchar(1) NULL,
	sign_org varchar(20) NULL,
	sign_oper varchar(30) NULL,
	sign_date sys."date" NULL,
	close_org varchar(20) NULL,
	close_oper varchar(30) NULL,
	close_date sys."date" NULL,
	sign_rel_addr varchar(160) NULL,
	sign_rel_phone varchar(36) NULL,
	sign_rel_name varchar(120) NULL,
	attn_name varchar(120) NULL,
	attn_cert_type varchar(30) NULL,
	attn_cert_no varchar(30) NULL,
	last_updated_te varchar(20) NULL,
	last_updated_org varchar(20) NULL,
	created_ts timestamp(6) NULL,
	updated_ts timestamp(6) NULL,
	init_system_id varchar(30) NOT NULL,
	init_created_ts timestamp(6) NULL,
	last_system_id varchar(30) NOT NULL,
	last_updated_ts timestamp(6) NULL,
	ryzd varchar(1) NULL
);

