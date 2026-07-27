-- crmdm.fms_t5_prod_info 定义

-- Drop table

-- DROP TABLE crmdm.fms_t5_prod_info;

CREATE TABLE crmdm.fms_t5_prod_info (
	prod_code varchar(32) NOT NULL, -- 产品代码
	prod_name varchar(256) NOT NULL, -- 产品名称
	prod_name_short varchar(68) NULL, -- 产品简称
	parent_prod_code varchar(32) NULL, -- 父产品代码
	prod_type bpchar(1) NULL, -- 产品类型;(0-自营，;1-代销，2-分销，3-自营+分销)
	prod_mode bpchar(2) NOT NULL, -- 产品模式;(1-产品模式一;2-产品模式二)
	period_type bpchar(1) NOT NULL, -- 周期类型;; 0-开放型；1-封闭型 2-周期型 3-净值归一
	prod_cur varchar(3) NOT NULL, -- 产品币种;（01-人民币；02-港元；03-美元）
	prod_risk_level bpchar(1) NOT NULL, -- 风险等级;（01-极低；02-低；03-中；04-高；05-极高）
	orgno varchar(10) NOT NULL, -- 发行机构
	legal_code varchar(32) NULL, -- 法人代码;多法人模式下的发行机构的法人代码
	def_div_method bpchar(1) NULL, -- 默认分红方式;：0-红利再投；1-现金分红（目前只能使用现金）
	div_chg_flag bpchar(1) NULL, -- 分红方式是否可修改;：0-不可;1-可，默认不可修改
	min_div_amt numeric(16, 2) NULL, -- 最小现金分红
	max_size numeric(16, 2) NULL, -- 规模上限;产品总额度
	min_size numeric(16, 2) NULL, -- 规模下限;最低规模条件;如果赎回导致底于下限则拒绝赎回
	hold_quota numeric(16, 2) NULL, -- 保留额度
	quota_dime varchar(20) NULL, -- 额度维度;(1-客户类型、2-客户级别、;3-机构、 4-渠道、5-金额),多维组合如 "123"
	sale_status bpchar(1) NOT NULL, -- 销售状态;0-不可;1-可销售
	can_booking bpchar(1) NULL, -- 是否可预留额度;0-否;1-是
	can_order bpchar(1) NULL, -- 是否可预约认购;0-否;1-是
	can_subs bpchar(1) NULL, -- 是否可认购;0-否;1-是
	can_apply bpchar(1) NULL, -- 是否可申购;0-否;1-是
	can_redeem bpchar(1) NULL, -- 是否可赎回;0-否;1-是
	can_frozen bpchar(1) NOT NULL, -- 是否可质押;0-否;1-是
	start_buy_time bpchar(6) NULL, -- 允许购买开始时间;：9999为不限如果不限;则结束时间也必须不限
	end_buy_time bpchar(6) NULL, -- 允许购买结束时间;：9999为不限如果不限;则开始时间也必须不限
	publish_code varchar(10) NOT NULL, -- 管理人代码;代销产品使用;非代销产品填‘0’
	income_characteristic bpchar(1) NOT NULL, -- 收益特点
	prod_lifecycle bpchar(1) NOT NULL, -- 产品状态;（0：设计1：发行前2：发行3：发行失败4：成立5：封闭6：开放7：清盘8：终止）
	regist_code varchar(32) NULL, -- 中登编号（中债登记编号）
	pay_check_acct_no varchar(32) NULL, -- 还款检查余额账号
	cust_type varchar(16) NULL, -- 客户类型;：0-同业；1-个人；2-机构
	subs_capital_model bpchar(1) NULL, -- 认购资金处理模式;：0-冻结；1-扣款;-1-不限
	subs_income_deal_type bpchar(1) NULL, -- 认购利息处理方式
	series_code varchar(32) NULL, -- 系列代码
	series_num numeric NULL, -- 期数
	profit_type bpchar(1) NOT NULL, -- 计价类型;（0-净值；1-收益）
	nav numeric(12, 6) NULL, -- 净值
	nav_date bpchar(8) NULL, -- 净值日期
	auto_winding_flag bpchar(1) NULL, -- 清盘日是否到期自动清盘;（1-是;0-否）
	rasie_type bpchar(1) NULL, -- 募集类型;（0-公募;1-私募）
	subs_quota numeric(16, 2) NULL, -- 认购额度
	apply_quota numeric(16, 2) NULL, -- 申购额度
	redeem_quota numeric(16, 2) NULL, -- 赎回额度
	recover_apply_quota bpchar(1) NULL, -- 恢复申购额度方式;（0-自动恢复1-手工恢复）
	recover_redeem_quota bpchar(1) NULL, -- 恢复赎回额度方式;（0-自动恢复1-手工恢复）
	cust_group bpchar(1) NULL, -- 客户组别
	prod_quota numeric(16, 2) NULL, -- 产品额度
	subs_redeem_flag bpchar(1) NULL, -- 认购可撤单标识;（0-否1-是）
	winding_pay_date bpchar(8) NULL, -- 到期实际兑付日期
	winding_pay_days varchar(32) NULL, -- 到期兑付交收天数
	specification_status bpchar(1) NULL, -- 说明书状态
	protocol_status bpchar(1) NULL, -- 协议说明书状态
	rasie_quota numeric(16, 2) NULL, -- 募集额度
	money_pay_day varchar(1) NULL, -- 资金兑付标准日
	has_waver_period bpchar(1) NULL, -- 是否有冷静期
	prod_comp_type varchar(1) NULL, -- 产品组合类型
	update_prod_date varchar(8) NULL, -- 产品信息更新日期
	update_prod_time varchar(6) NULL, -- 产品信息更新时间
	ryzd varchar(1) NULL
);
COMMENT ON TABLE crmdm.fms_t5_prod_info IS '产品信息表';

-- Column comments

COMMENT ON COLUMN crmdm.fms_t5_prod_info.prod_code IS '产品代码';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.prod_name IS '产品名称';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.prod_name_short IS '产品简称';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.parent_prod_code IS '父产品代码';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.prod_type IS '产品类型;(0-自营，;1-代销，2-分销，3-自营+分销)';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.prod_mode IS '产品模式;(1-产品模式一;2-产品模式二)';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.period_type IS '周期类型;; 0-开放型；1-封闭型 2-周期型 3-净值归一';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.prod_cur IS '产品币种;（01-人民币；02-港元；03-美元）';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.prod_risk_level IS '风险等级;（01-极低；02-低；03-中；04-高；05-极高）';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.orgno IS '发行机构';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.legal_code IS '法人代码;多法人模式下的发行机构的法人代码';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.def_div_method IS '默认分红方式;：0-红利再投；1-现金分红（目前只能使用现金）';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.div_chg_flag IS '分红方式是否可修改;：0-不可;1-可，默认不可修改';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.min_div_amt IS '最小现金分红';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.max_size IS '规模上限;产品总额度';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.min_size IS '规模下限;最低规模条件;如果赎回导致底于下限则拒绝赎回';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.hold_quota IS '保留额度';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.quota_dime IS '额度维度;(1-客户类型、2-客户级别、;3-机构、 4-渠道、5-金额),多维组合如 "123"';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.sale_status IS '销售状态;0-不可;1-可销售';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.can_booking IS '是否可预留额度;0-否;1-是';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.can_order IS '是否可预约认购;0-否;1-是';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.can_subs IS '是否可认购;0-否;1-是';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.can_apply IS '是否可申购;0-否;1-是';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.can_redeem IS '是否可赎回;0-否;1-是';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.can_frozen IS '是否可质押;0-否;1-是';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.start_buy_time IS '允许购买开始时间;：9999为不限如果不限;则结束时间也必须不限';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.end_buy_time IS '允许购买结束时间;：9999为不限如果不限;则开始时间也必须不限';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.publish_code IS '管理人代码;代销产品使用;非代销产品填‘0’';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.income_characteristic IS '收益特点';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.prod_lifecycle IS '产品状态;（0：设计1：发行前2：发行3：发行失败4：成立5：封闭6：开放7：清盘8：终止）';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.regist_code IS '中登编号（中债登记编号）';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.pay_check_acct_no IS '还款检查余额账号';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.cust_type IS '客户类型;：0-同业；1-个人；2-机构';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.subs_capital_model IS '认购资金处理模式;：0-冻结；1-扣款;-1-不限';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.subs_income_deal_type IS '认购利息处理方式';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.series_code IS '系列代码';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.series_num IS '期数';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.profit_type IS '计价类型;（0-净值；1-收益）';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.nav IS '净值';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.nav_date IS '净值日期';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.auto_winding_flag IS '清盘日是否到期自动清盘;（1-是;0-否）';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.rasie_type IS '募集类型;（0-公募;1-私募）';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.subs_quota IS '认购额度';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.apply_quota IS '申购额度';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.redeem_quota IS '赎回额度';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.recover_apply_quota IS '恢复申购额度方式;（0-自动恢复1-手工恢复）';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.recover_redeem_quota IS '恢复赎回额度方式;（0-自动恢复1-手工恢复）';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.cust_group IS '客户组别';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.prod_quota IS '产品额度';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.subs_redeem_flag IS '认购可撤单标识;（0-否1-是）';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.winding_pay_date IS '到期实际兑付日期';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.winding_pay_days IS '到期兑付交收天数';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.specification_status IS '说明书状态';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.protocol_status IS '协议说明书状态';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.rasie_quota IS '募集额度';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.money_pay_day IS '资金兑付标准日';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.has_waver_period IS '是否有冷静期';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.prod_comp_type IS '产品组合类型';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.update_prod_date IS '产品信息更新日期';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.update_prod_time IS '产品信息更新时间';
