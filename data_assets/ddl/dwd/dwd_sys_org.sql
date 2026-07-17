/*
 * DWD层表
 * 表名: crmdm.dwd_sys_org
 * 来源: TB.ddl
 */

-- crmdm.dwd_sys_org 定义

-- Drop table

-- DROP TABLE crmdm.dwd_sys_org;

CREATE TABLE crmdm.dwd_sys_org (
	org_id varchar(7) NOT NULL,
	sup_org_id varchar(7) NULL,
	org_path varchar(200) NULL,
	org_name varchar(100) NULL,
	sup_org_name varchar(100) NULL,
	direct_under_org varchar(7) NULL,
	org_typ varchar(10) NULL,
	org_harcy varchar(10) NULL,
	org_addrs varchar(800) NULL,
	org_state varchar(1) NULL,
	dsply_seq numeric NULL,
	creatr varchar(64) NULL,
	creat_time varchar(20) NULL,
	creat_org varchar(20) NULL,
	persn_legal_bk_code varchar(30) NULL,
	hr_ms_org_id varchar(80) NULL,
	org_lgtud varchar(30) NULL,
	org_lattud varchar(30) NULL,
	org_rsponr varchar(40) NULL,
	org_tel varchar(30) NULL
);

