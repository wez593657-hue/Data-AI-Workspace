-- crmdm.tmp_dws_cust_asse_liab_policy_base 定义

-- Drop table

-- DROP TABLE crmdm.tmp_dws_cust_asse_liab_policy_base;

CREATE TABLE crmdm.tmp_dws_cust_asse_liab_policy_base (
	cust_id varchar(20) NULL,
	acct_id varchar(40) NULL,
	prdkt_id varchar(40) NULL,
	prdkt_cate_big varchar(40) NULL,
	insur_bid_form_no varchar(40) NULL,
	policy_key varchar(200) NULL,
	first_tx_dt sys."date" NULL,
	bgn_dt sys."date" NULL,
	cancl_dt sys."date" NULL,
	pay_upto_dt sys."date" NULL,
	pay_patrn varchar(2) NULL,
	pay_period_typ varchar(2) NULL,
	pay_period numeric NULL,
	first_insur_amt numeric(20, 2) NULL
);
