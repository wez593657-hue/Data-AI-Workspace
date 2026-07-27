-- crmdm.fms_td_prod_limit 定义

-- Drop table

-- DROP TABLE crmdm.fms_td_prod_limit;

CREATE TABLE crmdm.fms_td_prod_limit (
	tano varchar(16) NOT NULL, -- TA代码
	prod_code varchar(32) NOT NULL, -- 产品代码
	share_class bpchar(1) NULL, -- 份额类别
	legal_code varchar(32) NULL, -- 法人代码（多法人模式）
	prod_sale_custom bpchar(2) NULL, -- 销售对象
	first_invest bpchar(1) NULL, -- 首次投资认定标准（-0-零购买：，1-零份额）
	min_asset_limit numeric(32, 2) NULL, -- 最低资产限额: -1为不限
	max_hold_peoples int4 NULL, -- 最高持有人数: -1为不限
	min_hold_peoples int4 NULL, -- 最低持有人数: -1为不限
	max_daily_subs_amt numeric(32, 2) NULL, -- 产品单日累计申购上限: -1为不限
	max_daily_redeem_amt numeric(32, 2) NULL, -- 产品单日累计赎回上限: -1为不限
	max_hold_days int4 NULL, -- 最高持有天数: -1为不限
	min_hold_days int4 NULL, -- 最低持有天数: -1为不限
	min_age int4 NULL, -- 年龄段最大值，-1为不限
	max_age int4 NULL, -- 年龄段最大值，-1为不限
	redeem_mode bpchar(1) NULL, -- 巨额赎回处理方式（0-取消，1-顺延，2-按投资这意愿）
	redeem_ratio numeric(32, 2) NULL, -- 巨额赎回比例，-1为不限
	min_subs_p numeric(32, 2) NULL, -- 个人首次认购最低金额
	step_subs_p numeric(32, 2) NULL, -- 个人认购递增金额
	min_subsend_p numeric(32, 2) NULL, -- 个人追加认购金额
	min_apply_p numeric(32, 2) NULL, -- 个人首次申购最低金额
	step_apply_p numeric(32, 2) NULL, -- 个人申购递增金额
	min_append_p numeric(32, 2) NULL, -- 个人追加申购最低金额
	max_subs_p numeric(32, 2) NULL, -- 个人单笔最大认购金额
	max_apply_p numeric(32, 2) NULL, -- 个人单笔最大申购金额
	max_daily_subs_p numeric(32, 2) NULL, -- 个人单日累计购买上限
	min_hold_p numeric(32, 2) NULL, -- 个人最低持有份额
	min_redeem_p numeric(32, 2) NULL, -- 个人最低赎回份额
	max_redeem_p numeric(32, 2) NULL, -- 个人单笔最大赎回份额
	max_daily_redeem_p numeric(32, 2) NULL, -- 个人单日累计赎回上限
	min_timeing_buy_p numeric(32, 2) NULL, -- 个人定期定额最低金额
	max_timeing_buy_p numeric(32, 2) NULL, -- 个人定期定额最高金额
	max_timeing_redem_p numeric(32, 2) NULL, -- 个人定期定额最低赎回份额
	max_convert_p numeric(32, 2) NULL, -- 个人最低产品转换份额
	max_holdamt_p numeric(32, 2) NULL, -- 个人最高持有金额
	max_holdrate_p numeric(32, 2) NULL, -- 个人最高持有比例
	min_subs_m numeric(32, 2) NULL, -- 机构首次认购最低金额
	step_subs_m numeric(32, 2) NULL, -- 机构认购递增金额
	min_subsend_m numeric(32, 2) NULL, -- 机构追加认购金额
	min_apply_m numeric(32, 2) NULL, -- 机构首次申购最低金额
	step_apply_m numeric(32, 2) NULL, -- 机构申购递增金额
	min_append_m numeric(32, 2) NULL, -- 机构追加申购最低金额
	max_subs_m numeric(32, 2) NULL, -- 机构单笔最大认购金额
	max_apply_m numeric(32, 2) NULL, -- 机构单笔最大申购金额
	max_daily_subs_m numeric(32, 2) NULL, -- 机构单日累计购买上限
	min_hold_m numeric(32, 2) NULL, -- 机构最低持有份额
	min_redeem_m numeric(32, 2) NULL, -- 机构最低赎回份额
	max_redeem_m numeric(32, 2) NULL, -- 机构单笔最大赎回份额
	max_daily_redeem_m numeric(32, 2) NULL, -- 机构单日累计赎回上限
	min_timeing_buy_m numeric(32, 2) NULL, -- 机构定期定额最低金额
	max_timeing_buy_m numeric(32, 2) NULL, -- 机构定期定额最高金额
	max_timeing_redem_m numeric(32, 2) NULL, -- 机构定期定额最低赎回份额
	max_convert_m numeric(32, 2) NULL, -- 机构最低产品转换份额
	max_holdamt_m numeric(32, 2) NULL, -- 机构最高持有金额
	max_holdrate_m numeric(32, 2) NULL, -- 机构最高持有比例
	list_code varchar(8) NULL, -- 名单编号(黑白名单)
	max_cust_offday_redeem_amt numeric(16, 2) NULL, -- 收市后单客户赎回上限
	max_prod_offday_redeem_amt numeric(16, 2) NULL, -- 收市后产品赎回上限
	max_hold_vol_p numeric(32, 2) NULL, -- 个人最高持有限额（客户持有份额+当日申购金额），粗略值，为了增加分销确认成功率
	max_hold_vol_m numeric(32, 2) NULL, -- 机构最高持有限额（客户持有份额+当日申购金额），粗略值，为了增加分销确认成功率
	ryzd varchar(1) NULL,
	CONSTRAINT pk_fms_td_prod_limit PRIMARY KEY (tano, prod_code)
);
COMMENT ON TABLE crmdm.fms_td_prod_limit IS '产品限额表';

-- Column comments

COMMENT ON COLUMN crmdm.fms_td_prod_limit.tano IS 'TA代码';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.prod_code IS '产品代码';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.share_class IS '份额类别';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.legal_code IS '法人代码（多法人模式）';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.prod_sale_custom IS '销售对象';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.first_invest IS '首次投资认定标准（-0-零购买：，1-零份额）';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.min_asset_limit IS '最低资产限额: -1为不限';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_hold_peoples IS '最高持有人数: -1为不限';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.min_hold_peoples IS '最低持有人数: -1为不限';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_daily_subs_amt IS '产品单日累计申购上限: -1为不限';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_daily_redeem_amt IS '产品单日累计赎回上限: -1为不限';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_hold_days IS '最高持有天数: -1为不限';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.min_hold_days IS '最低持有天数: -1为不限';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.min_age IS '年龄段最大值，-1为不限';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_age IS '年龄段最大值，-1为不限';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.redeem_mode IS '巨额赎回处理方式（0-取消，1-顺延，2-按投资这意愿）';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.redeem_ratio IS '巨额赎回比例，-1为不限';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.min_subs_p IS '个人首次认购最低金额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.step_subs_p IS '个人认购递增金额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.min_subsend_p IS '个人追加认购金额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.min_apply_p IS '个人首次申购最低金额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.step_apply_p IS '个人申购递增金额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.min_append_p IS '个人追加申购最低金额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_subs_p IS '个人单笔最大认购金额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_apply_p IS '个人单笔最大申购金额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_daily_subs_p IS '个人单日累计购买上限';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.min_hold_p IS '个人最低持有份额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.min_redeem_p IS '个人最低赎回份额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_redeem_p IS '个人单笔最大赎回份额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_daily_redeem_p IS '个人单日累计赎回上限';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.min_timeing_buy_p IS '个人定期定额最低金额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_timeing_buy_p IS '个人定期定额最高金额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_timeing_redem_p IS '个人定期定额最低赎回份额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_convert_p IS '个人最低产品转换份额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_holdamt_p IS '个人最高持有金额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_holdrate_p IS '个人最高持有比例';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.min_subs_m IS '机构首次认购最低金额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.step_subs_m IS '机构认购递增金额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.min_subsend_m IS '机构追加认购金额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.min_apply_m IS '机构首次申购最低金额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.step_apply_m IS '机构申购递增金额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.min_append_m IS '机构追加申购最低金额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_subs_m IS '机构单笔最大认购金额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_apply_m IS '机构单笔最大申购金额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_daily_subs_m IS '机构单日累计购买上限';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.min_hold_m IS '机构最低持有份额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.min_redeem_m IS '机构最低赎回份额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_redeem_m IS '机构单笔最大赎回份额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_daily_redeem_m IS '机构单日累计赎回上限';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.min_timeing_buy_m IS '机构定期定额最低金额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_timeing_buy_m IS '机构定期定额最高金额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_timeing_redem_m IS '机构定期定额最低赎回份额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_convert_m IS '机构最低产品转换份额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_holdamt_m IS '机构最高持有金额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_holdrate_m IS '机构最高持有比例';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.list_code IS '名单编号(黑白名单)';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_cust_offday_redeem_amt IS '收市后单客户赎回上限';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_prod_offday_redeem_amt IS '收市后产品赎回上限';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_hold_vol_p IS '个人最高持有限额（客户持有份额+当日申购金额），粗略值，为了增加分销确认成功率';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_hold_vol_m IS '机构最高持有限额（客户持有份额+当日申购金额），粗略值，为了增加分销确认成功率';
