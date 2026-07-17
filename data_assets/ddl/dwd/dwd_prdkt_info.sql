/*
 * DWD层表
 * 表名: crmdm.dwd_prdkt_info
 * 来源: TB.ddl
 */

-- crmdm.dwd_prdkt_info 定义

-- Drop table

-- DROP TABLE crmdm.dwd_prdkt_info;

CREATE TABLE crmdm.dwd_prdkt_info (
	prdkt_id varchar(40) NOT NULL,
	prdkt_name varchar(100) NULL,
	prdkt_cate_big varchar(10) NULL,
	bgn_date varchar(10) NULL,
	end_date varchar(10) NULL,
	prdkt_line varchar(10) NULL,
	sup_prdkt_id varchar(30) NULL,
	mdl_biz_rate_fee numeric(18, 4) NULL,
	prdkt_rate numeric(18, 4) NULL,
	sys_src varchar(6) NULL,
	prdkt_state varchar(10) NULL,
	persn_legal_bk_code varchar(30) NULL,
	CONSTRAINT sys_c0012861 CHECK ((prdkt_id IS NOT NULL))
);

