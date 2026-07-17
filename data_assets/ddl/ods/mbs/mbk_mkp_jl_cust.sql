/*
 * 上游手机系统
 * 表名: crmdm.mbk_mkp_jl_cust
 * 来源: TB.ddl
 */

-- crmdm.mbk_mkp_jl_cust 定义

-- Drop table

-- DROP TABLE crmdm.mbk_mkp_jl_cust;

CREATE TABLE crmdm.mbk_mkp_jl_cust (
	ecif_no varchar(16) NOT NULL,
	user_id varchar(64) NOT NULL,
	tran_date varchar(10) NULL,
	tran_time varchar(10) NULL,
	ryzd varchar(1) NULL,
	CONSTRAINT pk_mbk_mkp_jl_cust PRIMARY KEY (ecif_no)
);

