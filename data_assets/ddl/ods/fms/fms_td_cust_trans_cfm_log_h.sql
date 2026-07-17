/*
 * 上游理财系统
 * 表名: crmdm.fms_td_cust_trans_cfm_log_h
 * 来源: TB.ddl
 */

-- crmdm.fms_td_cust_trans_cfm_log_h 定义

-- Drop table

-- DROP TABLE crmdm.fms_td_cust_trans_cfm_log_h;

CREATE TABLE crmdm.fms_td_cust_trans_cfm_log_h (
	back_date varchar(8) NULL,
	app_serno varchar(32) NULL,
	cfm_date varchar(8) NULL,
	ccy varchar(3) NULL,
	app_amt numeric(32, 2) NULL,
	app_vol numeric(32, 2) NULL,
	cfm_amt numeric(32, 2) NULL,
	cfm_vol numeric(32, 2) NULL,
	tano varchar(16) NULL,
	prod_code varchar(32) NULL,
	share_class bpchar(1) NULL,
	lrdm_flag bpchar(1) NULL,
	app_date varchar(8) NULL,
	fnc_trans_acct_no varchar(24) NULL,
	busi_code varchar(3) NULL,
	ta_acct_no varchar(32) NULL,
	ta_cfm_serno varchar(32) NULL,
	busi_finish_flag bpchar(1) NULL,
	cmms_disct numeric(8, 5) NULL,
	charge numeric(32, 2) NULL,
	agen_fee numeric(32, 2) NULL,
	nav numeric(16, 8) NULL,
	ori_app_serno varchar(32) NULL,
	ori_cfm_serno varchar(32) NULL,
	fee_rate numeric(17, 2) NULL,
	bcfee_amt numeric(32, 2) NULL,
	distributor_code varchar(32) NULL,
	tag_distributor_code varchar(32) NULL,
	tag_trans_acct_no varchar(24) NULL,
	def_div_method bpchar(1) NULL,
	sbcp_intrst numeric(17, 2) NULL,
	tax numeric(17, 2) NULL,
	tagt_prod_code varchar(32) NULL,
	tagt_share_class bpchar(1) NULL,
	tagt_nav numeric(16, 8) NULL,
	trans_status bpchar(1) NULL,
	ta_flag bpchar(1) NULL,
	frozen_cause bpchar(1) NULL,
	frozen_ddl varchar(8) NULL,
	rdm_rsn varchar(32) NULL,
	rtn_code varchar(30) NULL,
	legal_code varchar(32) NULL,
	cust_manager varchar(20) NULL,
	windup_frozen_amt numeric(32, 2) NULL,
	tag_ta_acct_no varchar(32) NULL,
	rtn_desc varchar(256) NULL,
	ta_app_serno varchar(32) NULL,
	originalcfmamount numeric(16, 2) NULL,
	ryzd varchar(1) NULL
);

