/*
 * 上游智能存款系统
 * 表名: crmdm.cds_tb_cash_acct_info
 * 来源: TB.ddl
 */

-- crmdm.cds_tb_cash_acct_info 定义

-- Drop table

-- DROP TABLE crmdm.cds_tb_cash_acct_info;

CREATE TABLE crmdm.cds_tb_cash_acct_info (
	cash_acct_no varchar(32) NOT NULL,
	fnc_trans_acct_no bpchar(17) NOT NULL,
	cust_no bpchar(8) NOT NULL,
	cust_level varchar(8) NULL,
	acct_type bpchar(2) NULL,
	status bpchar(1) NULL,
	prod_code varchar(32) NULL,
	prod_class bpchar(1) NULL,
	prod_subclass bpchar(1) NULL,
	carry_interest_date bpchar(8) NOT NULL,
	expire_date bpchar(8) NULL,
	buy_amt numeric(16, 2) NULL,
	buy_type bpchar(1) NULL,
	balance numeric(16, 2) NULL,
	cumulative numeric(16, 2) NULL,
	balance_pay_interest numeric(16, 2) NULL,
	interest_no varchar(32) NULL,
	reach_avg_balance numeric(16, 2) NULL,
	total_interest numeric(16, 2) NULL,
	interest numeric(16, 2) NULL,
	pay_interest numeric(16, 2) NULL,
	sign_interest numeric(16, 2) NULL,
	draw_interest numeric(16, 2) NULL,
	draw_interest_no varchar(32) NULL,
	calc_amt numeric(16, 2) NULL,
	draw_seri_no numeric(3) NOT NULL,
	drawed_times numeric(2) NULL,
	trans_orgno varchar(20) NOT NULL,
	trans_branch varchar(20) NOT NULL,
	trans_head_office varchar(20) NOT NULL,
	card_orgno varchar(20) NOT NULL,
	card_branch varchar(20) NOT NULL,
	card_head_office varchar(20) NOT NULL,
	term_acct_no varchar(32) NULL,
	agr_sav_rate numeric(12, 5) NULL,
	agr_term varchar(4) NULL,
	agr_amt numeric(16, 2) NULL,
	calc_date bpchar(8) NULL,
	interest_date bpchar(8) NULL,
	term_serial_no varchar(32) NULL,
	ret_interest numeric(16, 2) NULL,
	trans_channel varchar(2) NULL,
	crt_date bpchar(8) NOT NULL,
	crt_time bpchar(6) NOT NULL,
	upd_date bpchar(8) NOT NULL,
	upd_time bpchar(6) NOT NULL,
	no_ret_interest numeric(16, 2) NULL,
	ryzd varchar(1) NULL,
	CONSTRAINT pk_cds_tb_cash_acct_info PRIMARY KEY (cash_acct_no)
);

