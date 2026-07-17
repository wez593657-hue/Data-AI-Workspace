/*
 * 上游理财系统
 * 表名: crmdm.fms_td_prod_limit
 * 来源: TB.ddl
 */

-- crmdm.fms_td_prod_limit 定义

-- Drop table

-- DROP TABLE crmdm.fms_td_prod_limit;

CREATE TABLE crmdm.fms_td_prod_limit (
	tano varchar(16) NOT NULL,
	prod_code varchar(32) NOT NULL,
	share_class bpchar(1) NULL,
	legal_code varchar(32) NULL,
	prod_sale_custom bpchar(2) NULL,
	first_invest bpchar(1) NULL,
	min_asset_limit numeric(32, 2) NULL,
	max_hold_peoples int4 NULL,
	min_hold_peoples int4 NULL,
	max_daily_subs_amt numeric(32, 2) NULL,
	max_daily_redeem_amt numeric(32, 2) NULL,
	max_hold_days int4 NULL,
	min_hold_days int4 NULL,
	min_age int4 NULL,
	max_age int4 NULL,
	redeem_mode bpchar(1) NULL,
	redeem_ratio numeric(32, 2) NULL,
	min_subs_p numeric(32, 2) NULL,
	step_subs_p numeric(32, 2) NULL,
	min_subsend_p numeric(32, 2) NULL,
	min_apply_p numeric(32, 2) NULL,
	step_apply_p numeric(32, 2) NULL,
	min_append_p numeric(32, 2) NULL,
	max_subs_p numeric(32, 2) NULL,
	max_apply_p numeric(32, 2) NULL,
	max_daily_subs_p numeric(32, 2) NULL,
	min_hold_p numeric(32, 2) NULL,
	min_redeem_p numeric(32, 2) NULL,
	max_redeem_p numeric(32, 2) NULL,
	max_daily_redeem_p numeric(32, 2) NULL,
	min_timeing_buy_p numeric(32, 2) NULL,
	max_timeing_buy_p numeric(32, 2) NULL,
	max_timeing_redem_p numeric(32, 2) NULL,
	max_convert_p numeric(32, 2) NULL,
	max_holdamt_p numeric(32, 2) NULL,
	max_holdrate_p numeric(32, 2) NULL,
	min_subs_m numeric(32, 2) NULL,
	step_subs_m numeric(32, 2) NULL,
	min_subsend_m numeric(32, 2) NULL,
	min_apply_m numeric(32, 2) NULL,
	step_apply_m numeric(32, 2) NULL,
	min_append_m numeric(32, 2) NULL,
	max_subs_m numeric(32, 2) NULL,
	max_apply_m numeric(32, 2) NULL,
	max_daily_subs_m numeric(32, 2) NULL,
	min_hold_m numeric(32, 2) NULL,
	min_redeem_m numeric(32, 2) NULL,
	max_redeem_m numeric(32, 2) NULL,
	max_daily_redeem_m numeric(32, 2) NULL,
	min_timeing_buy_m numeric(32, 2) NULL,
	max_timeing_buy_m numeric(32, 2) NULL,
	max_timeing_redem_m numeric(32, 2) NULL,
	max_convert_m numeric(32, 2) NULL,
	max_holdamt_m numeric(32, 2) NULL,
	max_holdrate_m numeric(32, 2) NULL,
	list_code varchar(8) NULL,
	max_cust_offday_redeem_amt numeric(16, 2) NULL,
	max_prod_offday_redeem_amt numeric(16, 2) NULL,
	max_hold_vol_p numeric(32, 2) NULL,
	max_hold_vol_m numeric(32, 2) NULL,
	ryzd varchar(1) NULL,
	CONSTRAINT pk_fms_td_prod_limit PRIMARY KEY (tano, prod_code)
);

