/*
 * DWD层表
 * 表名: crmdm.dwd_acct_depo
 * 来源: TB.ddl
 */

-- crmdm.dwd_acct_depo 定义

-- Drop table

-- DROP TABLE crmdm.dwd_acct_depo;

CREATE TABLE crmdm.dwd_acct_depo (
	cust_id varchar(20) NOT NULL,
	cust_typ varchar(2) NULL,
	acct_id varchar(40) NOT NULL,
	card_no varchar(40) NOT NULL,
	prdkt_id varchar(30) NULL,
	prdkt_name varchar(200) NULL,
	prdkt_cate_big varchar(64) NULL,
	acct_typ varchar(10) NULL,
	ccy_cd varchar(4) NULL,
	bal numeric(20, 2) NULL,
	rmb_bal numeric(20, 2) NULL,
	open_acct_org varchar(6) NULL,
	open_date varchar(10) NULL,
	rate_intri numeric(20, 2) NULL,
	intri_bgn_date varchar(10) NULL,
	expr_date varchar(10) NULL,
	acct_cloz_date varchar(10) NULL,
	acct_state varchar(10) NULL,
	persn_legal_bk_code varchar(4) NULL,
	vchr_typ varchar(10) NULL,
	cunq varchar(10) NULL,
	fix_curnt_flg varchar(1) NULL,
	CONSTRAINT pk_dwd_acct_depo PRIMARY KEY (cust_id, acct_id, card_no)
);

