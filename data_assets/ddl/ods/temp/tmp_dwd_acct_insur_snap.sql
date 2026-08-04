-- crmdm.tmp_dwd_acct_insur_snap 定义
-- 用途：PRC_DWD_ACCT_INSUR 保单聚合快照临时表
--       一次计算保单级主档快照，供新增(INS)/更新(UPD)两个独立过程复用，
--       避免新增与更新各自重复扫描 ODS 聚合。
-- 结构：与 DWD_ACCT_INSUR 26 列一致，四键主键保证快照内保单唯一。

-- Drop table

-- DROP TABLE crmdm.tmp_dwd_acct_insur_snap;

CREATE TABLE crmdm.tmp_dwd_acct_insur_snap (
	cust_id varchar(20) NOT NULL,           -- 客户编号
	cust_typ varchar(4) NULL,               -- 客户类型
	acct_id varchar(40) NOT NULL,           -- 账户
	prdkt_id varchar(40) NOT NULL,          -- 产品ID
	prdkt_name varchar(100) NULL,           -- 产品名称
	prdkt_cate_big varchar(64) NULL,        -- 产品大类
	insur_bid_form_no varchar(40) NOT NULL, -- 投保单号
	tx_date varchar(8) NULL,                -- 首次交易日期(YYYYMMDD)
	last_tx_date varchar(8) NULL,           -- 最近交易日期(YYYYMMDD)
	tx_org varchar(7) NULL,                 -- 交易机构
	tx_chnl varchar(10) NULL,               -- 交易渠道
	mkt_org varchar(7) NULL,                -- 归属机构
	bgn_insur_date varchar(10) NULL,        -- 起保日期(兼首期承保基准)
	cancl_insur_date varchar(10) NULL,      -- 保险期间结束日期(推算值,仅参考)
	actl_term_date varchar(8) NULL,         -- 实际终止日期(YYYYMMDD)
	pay_upto_date varchar(8) NULL,          -- 缴费截止日期
	insur_period_typ varchar(2) NULL,       -- 保险期间类型
	insur_period varchar(6) NULL,           -- 保险期间值
	pay_period_typ varchar(2) NULL,         -- 缴费期间类型
	pay_period varchar(6) NULL,             -- 缴费期间值
	pay_patrn varchar(2) NULL,              -- 缴费方式(0趸缴/1期缴)
	new_insur_amt numeric(20, 2) NULL,      -- 首期保费(新单保费)
	insur_amt numeric(20, 2) NULL,          -- 当前保险金额(终止/缴费期满/宽限期过=0)
	policy_state varchar(8) NOT NULL,       -- 保单状态: 0未生效/1正常/2失效
	tx_typ varchar(1) NULL,                 -- 交易类型(统一置空)
	persn_legal_bk_code varchar(4) NULL,    -- 法人行号
	PRIMARY KEY (cust_id, acct_id, prdkt_id, insur_bid_form_no)
);
