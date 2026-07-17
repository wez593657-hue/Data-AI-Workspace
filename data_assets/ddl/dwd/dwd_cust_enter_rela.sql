/*
 * DWD层表
 * 表名: crmdm.dwd_cust_enter_rela
 * 来源: TB.ddl
 */

-- crmdm.dwd_cust_enter_rela 定义

-- Drop table

-- DROP TABLE crmdm.dwd_cust_enter_rela;

CREATE TABLE crmdm.dwd_cust_enter_rela (
	cust_id varchar(20) NULL,
	rel_typ varchar(1) NULL,
	rel_cust_id varchar(20) NULL,
	rel_cust_name varchar(100) NULL,
	rel_val numeric NULL,
	bk_self_cust_flg varchar(1) NULL,
	rel_inf varchar(800) NULL,
	persn_legal_bk_code varchar(4) NULL
);

