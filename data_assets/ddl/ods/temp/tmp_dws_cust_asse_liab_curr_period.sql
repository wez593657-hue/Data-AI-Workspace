-- crmdm.tmp_dws_cust_asse_liab_curr_period 定义

-- Drop table

-- DROP TABLE crmdm.tmp_dws_cust_asse_liab_curr_period;

CREATE TABLE crmdm.tmp_dws_cust_asse_liab_curr_period (
	policy_key varchar(200) NULL,
	insur_bid_form_no varchar(40) NULL,
	period_no numeric NULL,
	due_dt sys."date" NULL,
	pay_tx_key varchar(200) NULL,
	paid_dt sys."date" NULL,
	paid_amt numeric(20, 2) NULL
);
