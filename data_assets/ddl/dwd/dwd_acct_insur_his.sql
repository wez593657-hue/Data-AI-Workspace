/*
 * DWD层表
 * 表名: crmdm.dwd_acct_insur_his
 * 来源: TB.ddl
 */

-- crmdm.dwd_acct_insur_his 定义

-- Drop table

-- DROP TABLE crmdm.dwd_acct_insur_his;

CREATE TABLE crmdm.dwd_acct_insur_his (
	data_date varchar(10) NULL,
	cust_id varchar(20) NULL,
	cust_typ varchar(4) NULL,
	acct_id varchar(40) NULL,
	prdkt_id varchar(40) NULL,
	prdkt_name varchar(100) NULL,
	prdkt_cate_big varchar(64) NULL,
	insur_bid_form_no varchar(40) NULL,
	tx_date varchar(10) NULL,
	tx_org varchar(6) NULL,
	tx_chnl varchar(10) NULL,
	mkt_org varchar(6) NULL,
	bgn_insur_date varchar(10) NULL,
	cancl_insur_date varchar(10) NULL,
	pay_upto_date varchar(10) NULL,
	insur_period_typ varchar(2) NULL,
	insur_period varchar(6) NULL,
	pay_period_typ varchar(2) NULL,
	pay_period varchar(6) NULL,
	pay_patrn varchar(2) NULL,
	insur_amt numeric(20, 2) NULL,
	policy_state varchar(10) NULL,
	tx_typ varchar(6) NULL,
	persn_legal_bk_code varchar(4) NULL
);



COMMENT ON TABLE DWD_ACCT_INSUR_HIS IS '【待补充】';
