-- crmdm.cds_tb_cash_acct_info 定义

-- Drop table

-- DROP TABLE crmdm.cds_tb_cash_acct_info;

CREATE TABLE crmdm.cds_tb_cash_acct_info (
	cash_acct_no varchar(32) NOT NULL, -- 虚拟账户编号
	fnc_trans_acct_no bpchar(17) NOT NULL, -- 理财交易账号
	cust_no bpchar(8) NOT NULL, -- 客户号
	cust_level varchar(8) NULL, -- 客户级别
	acct_type bpchar(2) NULL, -- 账户类型 （00：活期留存 01：冻结金额 02：活期增值 03：定期增值 04:核心计息账户）
	status bpchar(1) NULL, -- 账户状态 （ 0:正常 1:关户 2：等待结息）
	prod_code varchar(32) NULL, -- 产品代码
	prod_class bpchar(1) NULL, -- 产品大类 （0：活期 1：定期）
	prod_subclass bpchar(1) NULL, -- 产品子类( 0：活期日终型 2：活期日均型 3：协定活期型  4：定期型 5：大额存单 6：协定定期型）
	carry_interest_date bpchar(8) NOT NULL, -- 起息日期
	expire_date bpchar(8) NULL, -- 到期日期
	buy_amt numeric(16, 2) NULL, -- 购买金额
	buy_type bpchar(1) NULL, -- 定期购买方式0-活期账号购买1-定期账号购买
	balance numeric(16, 2) NULL, -- 余额
	cumulative numeric(16, 2) NULL, -- 金额积数 （定期不累计；活期累计）
	balance_pay_interest numeric(16, 2) NULL, -- 当前余额已付利息
	interest_no varchar(32) NULL, -- 计息方案代码
	reach_avg_balance numeric(16, 2) NULL, -- 达标日均余额
	total_interest numeric(16, 2) NULL, -- 总利息
	interest numeric(16, 2) NULL, -- 利息 （推到重算覆盖）
	pay_interest numeric(16, 2) NULL, -- 已付利息（累计）
	sign_interest numeric(16, 2) NULL, -- 签约未付利息
	draw_interest numeric(16, 2) NULL, -- 支取未付利息
	draw_interest_no varchar(32) NULL, -- 支取计息方案代码
	calc_amt numeric(16, 2) NULL, -- 已计提金额 （累计）
	draw_seri_no numeric(3) NOT NULL, -- 支取顺序号 （支取时，判断支取顺序）
	drawed_times numeric(2) NULL, -- 已支取次数
	trans_orgno varchar(20) NOT NULL, -- 交易机构
	trans_branch varchar(20) NOT NULL, -- 交易机构所属分行
	trans_head_office varchar(20) NOT NULL, -- 交易机构所属总行
	card_orgno varchar(20) NOT NULL, -- 开户机构
	card_branch varchar(20) NOT NULL, -- 开户机构所属分行
	card_head_office varchar(20) NOT NULL, -- 开户机构所属总行
	term_acct_no varchar(32) NULL, -- 定期、专户账户
	agr_sav_rate numeric(12, 5) NULL, -- 协定利率 (协定产品)
	agr_term varchar(4) NULL, -- 协定存期 (协定产品)
	agr_amt numeric(16, 2) NULL, -- 协定金额
	calc_date bpchar(8) NULL, -- 计提日期
	interest_date bpchar(8) NULL, -- 结息日期
	term_serial_no varchar(32) NULL, -- 定期/专账序号
	ret_interest numeric(16, 2) NULL, -- 返息金额
	trans_channel varchar(2) NULL, -- 交易渠道
	crt_date bpchar(8) NOT NULL, -- 创建日期
	crt_time bpchar(6) NOT NULL, -- 创建时间
	upd_date bpchar(8) NOT NULL, -- 更新日期
	upd_time bpchar(6) NOT NULL, -- 更新时间
	no_ret_interest numeric(16, 2) NULL, -- 无法补扣金额
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_cds_tb_cash_acct_info PRIMARY KEY (cash_acct_no)
);

-- Column comments

COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.cash_acct_no IS '虚拟账户编号';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.fnc_trans_acct_no IS '理财交易账号';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.cust_no IS '客户号';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.cust_level IS '客户级别';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.acct_type IS '账户类型 （00：活期留存 01：冻结金额 02：活期增值 03：定期增值 04:核心计息账户）';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.status IS '账户状态 （ 0:正常 1:关户 2：等待结息）';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.prod_code IS '产品代码';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.prod_class IS '产品大类 （0：活期 1：定期）';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.prod_subclass IS '产品子类( 0：活期日终型 2：活期日均型 3：协定活期型  4：定期型 5：大额存单 6：协定定期型）';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.carry_interest_date IS '起息日期';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.expire_date IS '到期日期';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.buy_amt IS '购买金额';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.buy_type IS '定期购买方式0-活期账号购买1-定期账号购买';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.balance IS '余额';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.cumulative IS '金额积数 （定期不累计；活期累计）';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.balance_pay_interest IS '当前余额已付利息';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.interest_no IS '计息方案代码';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.reach_avg_balance IS '达标日均余额';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.total_interest IS '总利息';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.interest IS '利息 （推到重算覆盖）';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.pay_interest IS '已付利息（累计）';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.sign_interest IS '签约未付利息';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.draw_interest IS '支取未付利息';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.draw_interest_no IS '支取计息方案代码';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.calc_amt IS '已计提金额 （累计）';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.draw_seri_no IS '支取顺序号 （支取时，判断支取顺序）';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.drawed_times IS '已支取次数';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.trans_orgno IS '交易机构';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.trans_branch IS '交易机构所属分行';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.trans_head_office IS '交易机构所属总行';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.card_orgno IS '开户机构';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.card_branch IS '开户机构所属分行';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.card_head_office IS '开户机构所属总行';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.term_acct_no IS '定期、专户账户';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.agr_sav_rate IS '协定利率 (协定产品)';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.agr_term IS '协定存期 (协定产品)';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.agr_amt IS '协定金额';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.calc_date IS '计提日期';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.interest_date IS '结息日期';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.term_serial_no IS '定期/专账序号';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.ret_interest IS '返息金额';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.trans_channel IS '交易渠道';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.crt_date IS '创建日期';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.crt_time IS '创建时间';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.upd_date IS '更新日期';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.upd_time IS '更新时间';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.no_ret_interest IS '无法补扣金额';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.ryzd IS '冗余字段';
