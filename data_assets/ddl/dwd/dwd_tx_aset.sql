/*
 * DWD层表
 * 表名: crmdm.dwd_tx_aset
 * 来源: TB.ddl
 */

-- crmdm.dwd_tx_aset 定义

-- Drop table

-- DROP TABLE crmdm.dwd_tx_aset;

CREATE TABLE crmdm.dwd_tx_aset (
	seq_id varchar(40) NOT NULL,
	cust_id varchar(21) NULL,
	cust_typ varchar(4) NULL,
	acct_id varchar(40) NULL,
	prdkt_id varchar(40) NULL,
	tx_chnl varchar(10) NULL,
	tx_date varchar(10) NULL,
	tx_time varchar(20) NULL,
	ccy_cd varchar(6) NULL,
	amt numeric(18, 4) NULL,
	tx_org varchar(20) NULL,
	oprtr varchar(20) NULL,
	loan_flg varchar(3) NULL,
	acct_bal numeric(18, 4) NULL,
	tx_dsc varchar(200) NULL,
	opnt_acct varchar(32) NULL,
	opnt_acct_name_fst varchar(200) NULL,
	opnt_bk_keep varchar(20) NULL,
	opnt_name_bk varchar(200) NULL,
	acct_blng_org varchar(20) NULL,
	card_no varchar(30) NULL,
	persn_legal_bk_code varchar(30) NULL,
	CONSTRAINT pk_dwd_tx_aset PRIMARY KEY (seq_id)
);

