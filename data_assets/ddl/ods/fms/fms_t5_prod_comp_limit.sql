-- crmdm.fms_t5_prod_comp_limit 定义

-- Drop table

-- DROP TABLE crmdm.fms_t5_prod_comp_limit;

CREATE TABLE crmdm.fms_t5_prod_comp_limit (
	prod_code varchar(32) NOT NULL, -- 产品代码
	max_person_no numeric(8) NULL, -- 人数上限
	curr_person_no numeric(8) NULL, -- 当前人数
	min_size numeric(16, 2) NULL, -- 发行规模下限
	cust_max_booking numeric(16, 2) NULL, -- 单客户自助渠道预约上限;-1为不限
	min_subs_p numeric(16, 2) NULL, -- 个人购买起点;必填
	max_subs_p numeric(16, 2) NULL, -- 个人购买最高;-1为不限
	step_subs_p numeric(16, 2) NULL, -- 个人购买递增;必填
	min_subs_m numeric(16, 2) NULL, -- 公司购买起点;必填
	max_subs_m numeric(16, 2) NULL, -- 公司购买最高;-1为不限
	step_subs_m numeric(16, 2) NULL, -- 公司购买递增;必填
	min_pchs_p numeric(16, 2) NULL, -- 单笔申购起点金额（个人）
	max_pchs_p numeric(16, 2) NULL, -- 单笔申购最高金额（个人）
	step_pchs_p numeric(16, 2) NULL, -- 单笔申购递增金额（个人）追加时为最低金额
	min_pchs_m numeric(16, 2) NULL, -- 单笔申购起点金额（机构）
	max_pchs_m numeric(16, 2) NULL, -- 单笔申购最高金额（机构）
	step_pchs_m numeric(16, 2) NULL, -- 单笔申购递增金额（机构）追加时为最低金额
	min_hold_p numeric(16, 2) NULL, -- 个人最低持有;必填
	min_redeem_p numeric(16, 2) NULL, -- 个人单笔最低赎回额;-1为不限
	min_hold_m numeric(16, 2) NULL, -- 公司最低持有;必填
	min_redeem_m numeric(16, 2) NULL, -- 公司最低赎回额;：-1为不限
	redeem_ratio numeric(7, 2) NULL, -- 巨额赎回比例;-1为不限
	min_pchs_fixed numeric(16, 2) NULL, -- 定投申购最低限额
	max_buy_p numeric(16, 2) NULL, -- 累积购买金额上限（个人）
	max_buy_m numeric(16, 2) NULL, -- 累积购买金额上限（机构）
	crt_date bpchar(8) NULL, -- 创建日期
	crt_time bpchar(6) NULL, -- 创建时间
	remark varchar(255) NULL, -- 备注
	upd_date bpchar(8) NULL, -- 更新日期
	upd_time bpchar(6) NULL, -- 更新时间
	min_hold_days numeric(8) NULL, -- 最低持有天数
	p_redeem_ratio numeric(7, 4) NULL, -- 单客户最高赎回比例
	p_redeem_amt numeric(16, 2) NULL, -- 单客户最高赎回金额
	ncount_max_buy numeric(16, 2) NULL, -- 非柜台购买上限
	ncount_cancel_flag bpchar(1) NULL, -- 购买是否可在非柜台撤单;（1-可以；0-不可以）
	ncount_booking_flag bpchar(1) NULL, -- 非柜台是否可预约;（1-可以；0-不可以）
	min_append_m numeric(16, 2) NULL, -- 机构追加起点
	min_append_p numeric(16, 2) NULL, -- 个人追加起点
	step_redeem_p numeric(16, 2) NULL, -- 个人赎回递增;-1为不限
	max_daily_subs_p numeric(16, 2) NULL, -- 个人单日累计购买上限;-1为不限
	max_daily_redeem_p numeric(16, 2) NULL, -- 个人单日累计赎回上限;-1为不限
	step_redeem_m numeric(16, 2) NULL, -- 公司赎回递增;-1为不限
	max_daily_subs_m numeric(16, 2) NULL, -- 公司单日累计购买上限;-1为不限
	max_daily_redeem_m numeric(16, 2) NULL, -- 机构单日累计赎回上限;-1为不限
	redeem_amt numeric(16, 2) NULL, -- 巨额赎回金额;根据上日产品规模和巨额赎回比例计算出来的当前工作日可赎回金额
	apply_ratio numeric(7, 2) NULL, -- 巨额申购比例;-1为不限
	apply_amt numeric(16, 2) NULL, -- 巨额申购金额;根据上日产品规模和巨额申购比例计算出来的当前工作日可申购金额
	three_days_redeem numeric(7, 2) NULL, -- 近3日累计赎回比例;-1为不限
	three_days_redeem_amt numeric(16, 2) NULL, -- 近3日累计巨额赎回金额
	max_hold_peoples numeric(16) NULL, -- 最高持有人数:;-1为不限
	min_hold_peoples numeric(16) NULL, -- 最低持有人数:;-1为不限
	max_daily_subs_amt numeric(16, 2) NULL, -- 产品单日累计购买上限:;-1为不限
	max_daily_redeem_amt numeric(16, 2) NULL, -- 产品单日累计赎回上限:;-1为不限
	low_asset_jud_type bpchar(1) NULL, -- 资产过低判断类型;(0-份额;1-金额)
	min_asset_limit numeric(16, 2) NULL, -- 最低资产限额:;-1为不限
	max_hold_amt numeric(16, 2) NULL, -- 单客户最高持有金额:;-1为不限
	max_hold_ratio numeric(7, 2) NULL, -- 单客户最高持有比例;-1为不限
	max_total_subs_p numeric(16, 2) NULL, -- 个人累计购买金额上限
	max_total_subs_m numeric(16, 2) NULL, -- 机构累计购买金额上限
	max_hold_p numeric(16, 2) NULL, -- 个人最高持有份额
	max_hold_m numeric(16, 2) NULL, -- 机构最高持有份额
	max_age numeric NULL, -- 年龄段最大值;-1为不限
	min_age numeric NULL, -- 年龄段最小值;-1为不限
	ncounter_max_booking numeric(16, 2) NULL, -- 单客户自助渠道预约上限;-1为不限
	ryzd varchar(1) NULL,
	CONSTRAINT pk_fms_t5_prod_comp_limit PRIMARY KEY (prod_code)
);
COMMENT ON TABLE crmdm.fms_t5_prod_comp_limit IS '产品组件-产品限制信息';

-- Column comments

COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.prod_code IS '产品代码';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.max_person_no IS '人数上限';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.curr_person_no IS '当前人数';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.min_size IS '发行规模下限';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.cust_max_booking IS '单客户自助渠道预约上限;-1为不限';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.min_subs_p IS '个人购买起点;必填';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.max_subs_p IS '个人购买最高;-1为不限';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.step_subs_p IS '个人购买递增;必填';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.min_subs_m IS '公司购买起点;必填';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.max_subs_m IS '公司购买最高;-1为不限';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.step_subs_m IS '公司购买递增;必填';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.min_pchs_p IS '单笔申购起点金额（个人）';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.max_pchs_p IS '单笔申购最高金额（个人）';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.step_pchs_p IS '单笔申购递增金额（个人）追加时为最低金额';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.min_pchs_m IS '单笔申购起点金额（机构）';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.max_pchs_m IS '单笔申购最高金额（机构）';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.step_pchs_m IS '单笔申购递增金额（机构）追加时为最低金额';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.min_hold_p IS '个人最低持有;必填';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.min_redeem_p IS '个人单笔最低赎回额;-1为不限';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.min_hold_m IS '公司最低持有;必填';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.min_redeem_m IS '公司最低赎回额;：-1为不限';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.redeem_ratio IS '巨额赎回比例;-1为不限';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.min_pchs_fixed IS '定投申购最低限额';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.max_buy_p IS '累积购买金额上限（个人）';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.max_buy_m IS '累积购买金额上限（机构）';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.crt_date IS '创建日期';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.crt_time IS '创建时间';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.remark IS '备注';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.upd_date IS '更新日期';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.upd_time IS '更新时间';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.min_hold_days IS '最低持有天数';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.p_redeem_ratio IS '单客户最高赎回比例';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.p_redeem_amt IS '单客户最高赎回金额';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.ncount_max_buy IS '非柜台购买上限';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.ncount_cancel_flag IS '购买是否可在非柜台撤单;（1-可以；0-不可以）';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.ncount_booking_flag IS '非柜台是否可预约;（1-可以；0-不可以）';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.min_append_m IS '机构追加起点';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.min_append_p IS '个人追加起点';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.step_redeem_p IS '个人赎回递增;-1为不限';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.max_daily_subs_p IS '个人单日累计购买上限;-1为不限';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.max_daily_redeem_p IS '个人单日累计赎回上限;-1为不限';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.step_redeem_m IS '公司赎回递增;-1为不限';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.max_daily_subs_m IS '公司单日累计购买上限;-1为不限';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.max_daily_redeem_m IS '机构单日累计赎回上限;-1为不限';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.redeem_amt IS '巨额赎回金额;根据上日产品规模和巨额赎回比例计算出来的当前工作日可赎回金额';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.apply_ratio IS '巨额申购比例;-1为不限';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.apply_amt IS '巨额申购金额;根据上日产品规模和巨额申购比例计算出来的当前工作日可申购金额';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.three_days_redeem IS '近3日累计赎回比例;-1为不限';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.three_days_redeem_amt IS '近3日累计巨额赎回金额';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.max_hold_peoples IS '最高持有人数:;-1为不限';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.min_hold_peoples IS '最低持有人数:;-1为不限';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.max_daily_subs_amt IS '产品单日累计购买上限:;-1为不限';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.max_daily_redeem_amt IS '产品单日累计赎回上限:;-1为不限';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.low_asset_jud_type IS '资产过低判断类型;(0-份额;1-金额)';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.min_asset_limit IS '最低资产限额:;-1为不限';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.max_hold_amt IS '单客户最高持有金额:;-1为不限';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.max_hold_ratio IS '单客户最高持有比例;-1为不限';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.max_total_subs_p IS '个人累计购买金额上限';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.max_total_subs_m IS '机构累计购买金额上限';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.max_hold_p IS '个人最高持有份额';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.max_hold_m IS '机构最高持有份额';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.max_age IS '年龄段最大值;-1为不限';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.min_age IS '年龄段最小值;-1为不限';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.ncounter_max_booking IS '单客户自助渠道预约上限;-1为不限';
