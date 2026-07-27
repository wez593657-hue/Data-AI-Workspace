-- crmdm.tmp_dws_cust_asse_liab_plan_match 定义

-- Drop table

-- DROP TABLE crmdm.tmp_dws_cust_asse_liab_plan_match;

CREATE TABLE crmdm.tmp_dws_cust_asse_liab_plan_match (
	policy_key varchar(200) NULL,
	insur_bid_form_no varchar(40) NULL,
	period_no numeric NULL,
	due_dt sys."date" NULL,
	pay_tx_key varchar(200) NULL,
	paid_dt sys."date" NULL,
	paid_amt numeric(20, 2) NULL
);
