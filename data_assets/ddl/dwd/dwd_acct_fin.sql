/*
 * DWD层表
 * 表名: crmdm.dwd_acct_fin
 * 来源: TB.ddl
 */

-- crmdm.dwd_acct_fin 定义

-- Drop table

-- DROP TABLE crmdm.dwd_acct_fin;

CREATE TABLE crmdm.dwd_acct_fin (
	cust_id varchar(21) NOT NULL,
	cust_typ varchar(4) NOT NULL,
	acct_id varchar(40) NOT NULL,
	card_no varchar(30) NOT NULL,
	prdkt_id varchar(40) NOT NULL,
	prdkt_name varchar(100) NULL,
	prdkt_cate_big varchar(64) NULL,
	estab_date varchar(10) NULL,
	fin_amt numeric(18, 4) NULL,
	rate_intri numeric(18, 4) NULL,
	acct_state varchar(10) NULL,
	intri_bgn_date varchar(10) NULL,
	expr_date varchar(10) NULL,
	oprt_org varchar(40) NULL,
	chnl_no varchar(10) NULL,
	persn_legal_bk_code varchar(30) NULL,
	issu_org varchar(30) NULL,
	issu_date varchar(10) NULL,
	risk_lvl varchar(10) NULL
);

