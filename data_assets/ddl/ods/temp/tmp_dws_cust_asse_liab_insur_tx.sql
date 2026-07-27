-- crmdm.tmp_dws_cust_asse_liab_insur_tx 定义

-- Drop table

-- DROP TABLE crmdm.tmp_dws_cust_asse_liab_insur_tx;

CREATE TABLE crmdm.tmp_dws_cust_asse_liab_insur_tx (
	cust_id varchar(20) NULL,
	acct_id varchar(40) NULL,
	prdkt_id varchar(40) NULL,
	prdkt_cate_big varchar(40) NULL,
	insur_bid_form_no varchar(40) NULL,
	tx_typ varchar(2) NULL,
	tx_dt sys."date" NULL,
	bgn_dt sys."date" NULL,
	cancl_dt sys."date" NULL,
	pay_upto_dt sys."date" NULL,
	pay_patrn varchar(2) NULL,
	pay_period_typ varchar(2) NULL,
	pay_period numeric NULL,
	insur_amt numeric(20, 2) NULL,
	policy_key varchar(200) NULL,
	tx_seq numeric NULL,
	tx_key varchar(200) NULL
);
