/*
 * 上游ECIF系统
 * 表名: crmdm.ecif_t03_a_addr_info
 * 来源: TB.ddl
 */

-- crmdm.ecif_t03_a_addr_info 定义

-- Drop table

-- DROP TABLE crmdm.ecif_t03_a_addr_info;

CREATE TABLE crmdm.ecif_t03_a_addr_info (
	addr_id bpchar(20) NULL,
	post_cd varchar(6) NULL,
	nation varchar(30) NULL,
	province varchar(30) NULL,
	city varchar(30) NULL,
	county varchar(30) NULL,
	street varchar(80) NULL,
	addr_line varchar(160) NULL,
	addr_desc varchar(200) NULL,
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

