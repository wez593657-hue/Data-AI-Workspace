/*
 * 上游智能存款系统
 * 表名: crmdm.cds_tb_interest_prj_detail
 * 来源: TB.ddl
 */

-- crmdm.cds_tb_interest_prj_detail 定义

-- Drop table

-- DROP TABLE crmdm.cds_tb_interest_prj_detail;

CREATE TABLE crmdm.cds_tb_interest_prj_detail (
	interest_no varchar(32) NOT NULL,
	time_step varchar(3) NULL,
	begin_amt numeric(16, 2) NULL,
	end_amt numeric(16, 2) NULL,
	host_rate numeric(12, 5) NULL,
	trans_channel varchar(8) NULL,
	begin_cust_level varchar(8) NULL,
	end_cust_level varchar(8) NULL,
	crt_date bpchar(8) NULL,
	crt_time bpchar(6) NULL,
	upd_date bpchar(8) NULL,
	upd_time bpchar(6) NULL,
	rate numeric(12, 8) NULL,
	ryzd varchar(1) NULL
);

