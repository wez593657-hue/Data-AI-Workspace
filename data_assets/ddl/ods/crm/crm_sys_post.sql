-- crmdm.crm_sys_post 定义

-- Drop table

-- DROP TABLE crmdm.crm_sys_post;

CREATE TABLE crmdm.crm_sys_post (
	post_id varchar(40) NOT NULL,
	emp_id varchar(40) NULL,
	post_name varchar(64) NULL,
	job_name varchar(64) NULL,
	job_cls varchar(6) NULL,
	post_state varchar(6) NULL,
	biz_line varchar(6) NULL,
	org_id varchar(30) NULL,
	org_cate varchar(6) NULL,
	stat_org_id varchar(30) NULL,
	direct_under_org varchar(40) NULL,
	sup_post_id varchar(40) NULL,
	del_flg varchar(1) NULL,
	usr_name varchar(64) NULL,
	creatr varchar(64) NULL,
	creat_time varchar(20) NULL,
	creat_org varchar(20) NULL,
	updatr varchar(64) NULL,
	upd_time varchar(20) NULL,
	main_pos_flag varchar(1) NULL,
	persn_legal_bk_code varchar(30) NULL,
	CONSTRAINT sys_c0013323 CHECK ((post_id IS NOT NULL))
);
