/*
 * 上游ECIF系统
 * 表名: crmdm.ecif_t02_a_cust_sign_rel
 * 来源: TB.ddl
 */

-- crmdm.ecif_t02_a_cust_sign_rel 定义

-- Drop table

-- DROP TABLE crmdm.ecif_t02_a_cust_sign_rel;

CREATE TABLE crmdm.ecif_t02_a_cust_sign_rel (
	sign_seq_id bpchar(20) NULL,
	party_id bpchar(20) NULL,
	sign_sys_no varchar(30) NULL,
	acc_sign_no varchar(20) NULL,
	sign_type varchar(30) NULL,
	sign_edit varchar(30) NULL,
	sign_acc_type varchar(30) NULL,
	sign_acc_no varchar(40) NULL,
	old_sign_acc varchar(40) NULL,
	init_sign_acc varchar(40) NULL,
	sign_prd_no varchar(200) NULL,
	sign_prd_desc varchar(200) NULL,
	sign_main_prd_flg bpchar(1) NULL,
	sign_arr_no varchar(100) NULL,
	sign_state bpchar(1) NULL,
	acc_sign_id bpchar(20) NULL,
	sign_tab_id bpchar(8) NULL,
	role_id bpchar(20) NULL,
	role_tab_id bpchar(8) NULL,
	acc_name varchar(200) NULL,
	expd_date sys."date" NULL,
	sign_info_ext_1 varchar(30) NULL,
	sign_info_ext_2 varchar(30) NULL,
	sign_info_ext_3 varchar(30) NULL,
	sign_info_ext_4 varchar(512) NULL,
	sign_info_ext_5 varchar(512) NULL,
	last_updated_te varchar(20) NULL,
	last_updated_org varchar(20) NULL,
	created_ts timestamp(6) NULL,
	updated_ts timestamp(6) NULL,
	init_system_id varchar(30) NULL,
	init_created_ts timestamp(6) NULL,
	last_system_id varchar(30) NULL,
	last_updated_ts timestamp(6) NULL,
	ryzd varchar(1) NULL
);

