/*
 * 上游理财系统
 * 表名: crmdm.fms_t5_prod_comp_limit
 * 来源: TB.ddl
 */

-- crmdm.fms_t5_prod_comp_limit 定义

-- Drop table

-- DROP TABLE crmdm.fms_t5_prod_comp_limit;

CREATE TABLE crmdm.fms_t5_prod_comp_limit (
	prod_code varchar(32) NOT NULL,
	max_person_no numeric(8) NULL,
	curr_person_no numeric(8) NULL,
	min_size numeric(16, 2) NULL,
	cust_max_booking numeric(16, 2) NULL,
	min_subs_p numeric(16, 2) NULL,
	max_subs_p numeric(16, 2) NULL,
	step_subs_p numeric(16, 2) NULL,
	min_subs_m numeric(16, 2) NULL,
	max_subs_m numeric(16, 2) NULL,
	step_subs_m numeric(16, 2) NULL,
	min_pchs_p numeric(16, 2) NULL,
	max_pchs_p numeric(16, 2) NULL,
	step_pchs_p numeric(16, 2) NULL,
	min_pchs_m numeric(16, 2) NULL,
	max_pchs_m numeric(16, 2) NULL,
	step_pchs_m numeric(16, 2) NULL,
	min_hold_p numeric(16, 2) NULL,
	min_redeem_p numeric(16, 2) NULL,
	min_hold_m numeric(16, 2) NULL,
	min_redeem_m numeric(16, 2) NULL,
	redeem_ratio numeric(7, 2) NULL,
	min_pchs_fixed numeric(16, 2) NULL,
	max_buy_p numeric(16, 2) NULL,
	max_buy_m numeric(16, 2) NULL,
	crt_date bpchar(8) NULL,
	crt_time bpchar(6) NULL,
	remark varchar(255) NULL,
	upd_date bpchar(8) NULL,
	upd_time bpchar(6) NULL,
	min_hold_days numeric(8) NULL,
	p_redeem_ratio numeric(7, 4) NULL,
	p_redeem_amt numeric(16, 2) NULL,
	ncount_max_buy numeric(16, 2) NULL,
	ncount_cancel_flag bpchar(1) NULL,
	ncount_booking_flag bpchar(1) NULL,
	min_append_m numeric(16, 2) NULL,
	min_append_p numeric(16, 2) NULL,
	step_redeem_p numeric(16, 2) NULL,
	max_daily_subs_p numeric(16, 2) NULL,
	max_daily_redeem_p numeric(16, 2) NULL,
	step_redeem_m numeric(16, 2) NULL,
	max_daily_subs_m numeric(16, 2) NULL,
	max_daily_redeem_m numeric(16, 2) NULL,
	redeem_amt numeric(16, 2) NULL,
	apply_ratio numeric(7, 2) NULL,
	apply_amt numeric(16, 2) NULL,
	three_days_redeem numeric(7, 2) NULL,
	three_days_redeem_amt numeric(16, 2) NULL,
	max_hold_peoples numeric(16) NULL,
	min_hold_peoples numeric(16) NULL,
	max_daily_subs_amt numeric(16, 2) NULL,
	max_daily_redeem_amt numeric(16, 2) NULL,
	low_asset_jud_type bpchar(1) NULL,
	min_asset_limit numeric(16, 2) NULL,
	max_hold_amt numeric(16, 2) NULL,
	max_hold_ratio numeric(7, 2) NULL,
	max_total_subs_p numeric(16, 2) NULL,
	max_total_subs_m numeric(16, 2) NULL,
	max_hold_p numeric(16, 2) NULL,
	max_hold_m numeric(16, 2) NULL,
	max_age numeric NULL,
	min_age numeric NULL,
	ncounter_max_booking numeric(16, 2) NULL,
	ryzd varchar(1) NULL,
	CONSTRAINT pk_fms_t5_prod_comp_limit PRIMARY KEY (prod_code)
);

