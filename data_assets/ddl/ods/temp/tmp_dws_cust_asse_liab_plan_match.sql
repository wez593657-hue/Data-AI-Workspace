/*
 * 临时表
 * 表名: crmdm.tmp_dws_cust_asse_liab_plan_match
 * 来源: TB.ddl
 */

-- crmdm.tmp_dws_cust_asse_liab_plan_match 定义

-- Drop table

-- DROP TABLE crmdm.tmp_dws_cust_asse_liab_plan_match;

CREATE TABLE crmdm.tmp_dws_cust_asse_liab_plan_match (
    policy_key varchar(200) NULL,
    insur_bid_form_no varchar(40) NULL,
    period_no numeric(20,
    2) NULL,
    due_dt DATE NULL,
    pay_tx_key varchar(240) NULL,
    paid_dt DATE NULL,
    paid_amt numeric(20,
    2) NULL
);

