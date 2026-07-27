-- crmdm.fms_td_prod_info 定义

-- Drop table

-- DROP TABLE crmdm.fms_td_prod_info;

CREATE TABLE crmdm.fms_td_prod_info (
	tano varchar(16) NULL, -- TA代码
	prod_code varchar(32) NULL, -- 产品代码
	legal_code varchar(32) NULL, -- 法人代码（多法人模式）
	prod_name varchar(400) NULL, -- 产品名称
	prod_name_short varchar(120) NULL, -- 产品简称
	prod_type varchar(2) NULL, -- 产品形态
	share_class bpchar(1) NULL, -- 份额类别
	prod_status bpchar(1) NULL, -- 产品状态
	sale_status bpchar(1) NULL, -- 销售状态
	prod_risk_level bpchar(1) NULL, -- 产品风险等级
	prod_manager varchar(32) NULL, -- 产品管理人
	prod_mandator varchar(32) NULL, -- 托管人
	rasie_type varchar(32) NULL, -- 募集方式
	regist_code varchar(32) NULL, -- 产品登记编码
	benchmarks numeric(11, 8) NULL, -- 业绩基准
	prod_cur varchar(3) NULL, -- 产品币种
	collect_feetype bpchar(1) NULL, -- 交易费计算方式(0-价内费1-价外费)
	redeemfee_backratio numeric(9, 5) NULL, -- 赎回费归理财资产比例
	redeem_feerate numeric(9, 5) NULL, -- 违约赎回费率
	def_div_method bpchar(1) NULL, -- 默认分红方式
	div_chg_flag bpchar(1) NULL, -- 分红方式是否可修改
	price numeric(16, 8) NULL, -- 产品面值（发行价格）
	nav numeric(16, 8) NULL, -- 产品净值
	nav_date varchar(8) NULL, -- 净值日期
	proxy_fee_flag varchar(1) NULL, -- 代理费是否留存
	prod_size numeric(32, 2) NULL, -- 产品发行规模
	quota_ctrl_flag bpchar(1) NULL, -- 是否进行额度限制
	subs_capital_mode bpchar(1) NULL, -- 认购资金处理模式
	subs_capital_type bpchar(1) NULL, -- 认购款到账方式，其中N为认购交收天数
	sub_payback_period numeric(38) NULL, -- 认购退款交收天数
	subs_nextday_cancel bpchar(1) NULL, -- 认购是否支持隔日撤单
	apply_capital_mode bpchar(1) NULL, -- 申购资金处理模式
	apply_pay_period numeric(38) NULL, -- 申购资金交收天数
	first_buy_flag varchar(32) NULL, -- 首次购买判断标准
	convert_status varchar(1) NULL, -- 产品转换状态
	periodic_status varchar(1) NULL, -- 定期定额状态
	transfer_agency_status varchar(1) NULL, -- 转托管状态
	divident_date varchar(8) NULL, -- 分红日/发放日
	registration_date varchar(8) NULL, -- 权益登记日期
	booking_begin_date varchar(8) NULL, -- 预留开始日
	booking_invalid_date varchar(8) NULL, -- 预留失效日
	subs_begin_date varchar(8) NULL, -- 募集开始日
	subs_end_date varchar(8) NULL, -- 募集结束日
	subs_end_time varchar(6) NULL, -- 募集结束时间
	subs_cancel_end_date varchar(8) NULL, -- 认购撤单截止日期
	establish_date varchar(8) NULL, -- 成立日（滚动产品成清算时，将该值更新为下一个周期成立日）
	value_date varchar(8) NULL, -- 收益起始日
	open_begin_date varchar(8) NULL, -- 开放起始日
	open_end_date varchar(8) NULL, -- 开放结束日
	winding_date varchar(8) NULL, -- 到期日（到期日期，滚动产品到期清算时将该值更新）
	close_time varchar(6) NULL, -- 收市时间
	trans_start_time varchar(6) NULL, -- 每日交易允许起始时间
	trans_end_time varchar(6) NULL, -- 每日交易允许结束时间
	period_type bpchar(1) NULL, -- 产品模式
	profit_type varchar(32) NULL, -- 计价类型
	prod_lifecycle bpchar(1) NULL, -- 产品生命周期状态
	redeem_pay_period numeric(38) NULL, -- 赎回资金交收天数
	divide_pay_period numeric(38) NULL, -- 分红资金交收天数
	end_pay_period numeric(38) NULL, -- 产品终止资金交收天数
	apply_cfm_n numeric(38) NULL, -- 申购确认日 (0-T+0、1-T+1、2-T+2)
	redeem_cfm_n numeric(38) NULL, -- 赎回确认日 (0-T+0、1-T+1、2-T+2)
	is_discount varchar(1) NULL, -- 是否允许打折
	can_booking varchar(1) NULL, -- 是否可进行额度预留
	redeem_type bpchar(1) NULL, -- 赎回方式
	can_realtime_redeem varchar(1) NULL, -- 是否允许实时赎回
	realtime_repay_flag bpchar(1) NULL, -- 收市后是否允许实时赎回
	realtime_repay_method bpchar(1) NULL, -- 收市后实时赎回回款方式
	windup_type bpchar(1) NULL, -- 清盘方式
	prod_order numeric(38) NULL, -- 产品序号
	can_frozen varchar(1) NULL, -- 是否允许质押冻结
	can_conv_flag varchar(1) NULL, -- 是否支持份额转让
	recom_flg varchar(1) NULL, -- 推荐标识
	pgmno varchar(32) NULL, -- 产品工作日方案代码
	pre_workday varchar(8) NULL, -- 产品上一工作日
	current_workday varchar(8) NULL, -- 产品当前工作日
	next_workday varchar(8) NULL, -- 产品下一工作日
	min_subs_amt numeric(32, 2) NULL, -- 最低募集额
	max_subs_amt numeric(32, 2) NULL, -- 最高募集金额
	online_date varchar(8) NULL, -- 上线日期
	invest_target bpchar(1) NULL, -- 投资性质
	cash_flag bpchar(1) NULL, -- 钞汇标识
	is_hot_sale bpchar(1) NULL, -- 是否热销产品
	operation_period_day numeric NULL, -- 运作期天数
	max_lock_days numeric(32) NULL, -- 最大持有天数
	benchmarks_text varchar(1536) NULL, -- 预期收益率说明/业绩比较基准
	prod_rate numeric NULL, -- 收益率
	min_hold numeric(38) NULL, -- 最低持有（天）
	prod_days numeric(38) NULL, -- 期限
	channel_show_flag bpchar(1) NULL, -- 渠道端展示标志
	sort_no numeric(8, 4) NULL, -- 排序编号
	apply_begin_date varchar(8) NULL, -- 本期申购开始日
	redeem_begin_date varchar(8) NULL, -- 本期赎回开始日
	prod_template_code varchar(8) NULL, -- 冗余字段
	cycle_days numeric NULL,
	is_dx_new_cust_prod varchar(1) NULL,
	cust_cycle_redeem_type varchar(1) NULL,
	open_notify_flag varchar(1) NULL,
	achievement_show_type varchar(1) NULL,
	show_short_flag varchar(1) NULL,
	workdaytype varchar(1) NULL,
	benchmarkexpiredate varchar(8) NULL,
	ryzd varchar(1) NULL
);
COMMENT ON TABLE crmdm.fms_td_prod_info IS '理财产品信息表';

-- Column comments

COMMENT ON COLUMN crmdm.fms_td_prod_info.tano IS 'TA代码';
COMMENT ON COLUMN crmdm.fms_td_prod_info.prod_code IS '产品代码';
COMMENT ON COLUMN crmdm.fms_td_prod_info.legal_code IS '法人代码（多法人模式）';
COMMENT ON COLUMN crmdm.fms_td_prod_info.prod_name IS '产品名称';
COMMENT ON COLUMN crmdm.fms_td_prod_info.prod_name_short IS '产品简称';
COMMENT ON COLUMN crmdm.fms_td_prod_info.prod_type IS '产品形态';
COMMENT ON COLUMN crmdm.fms_td_prod_info.share_class IS '份额类别';
COMMENT ON COLUMN crmdm.fms_td_prod_info.prod_status IS '产品状态';
COMMENT ON COLUMN crmdm.fms_td_prod_info.sale_status IS '销售状态';
COMMENT ON COLUMN crmdm.fms_td_prod_info.prod_risk_level IS '产品风险等级';
COMMENT ON COLUMN crmdm.fms_td_prod_info.prod_manager IS '产品管理人';
COMMENT ON COLUMN crmdm.fms_td_prod_info.prod_mandator IS '托管人';
COMMENT ON COLUMN crmdm.fms_td_prod_info.rasie_type IS '募集方式';
COMMENT ON COLUMN crmdm.fms_td_prod_info.regist_code IS '产品登记编码';
COMMENT ON COLUMN crmdm.fms_td_prod_info.benchmarks IS '业绩基准';
COMMENT ON COLUMN crmdm.fms_td_prod_info.prod_cur IS '产品币种';
COMMENT ON COLUMN crmdm.fms_td_prod_info.collect_feetype IS '交易费计算方式(0-价内费1-价外费)';
COMMENT ON COLUMN crmdm.fms_td_prod_info.redeemfee_backratio IS '赎回费归理财资产比例';
COMMENT ON COLUMN crmdm.fms_td_prod_info.redeem_feerate IS '违约赎回费率';
COMMENT ON COLUMN crmdm.fms_td_prod_info.def_div_method IS '默认分红方式';
COMMENT ON COLUMN crmdm.fms_td_prod_info.div_chg_flag IS '分红方式是否可修改';
COMMENT ON COLUMN crmdm.fms_td_prod_info.price IS '产品面值（发行价格）';
COMMENT ON COLUMN crmdm.fms_td_prod_info.nav IS '产品净值';
COMMENT ON COLUMN crmdm.fms_td_prod_info.nav_date IS '净值日期';
COMMENT ON COLUMN crmdm.fms_td_prod_info.proxy_fee_flag IS '代理费是否留存';
COMMENT ON COLUMN crmdm.fms_td_prod_info.prod_size IS '产品发行规模';
COMMENT ON COLUMN crmdm.fms_td_prod_info.quota_ctrl_flag IS '是否进行额度限制';
COMMENT ON COLUMN crmdm.fms_td_prod_info.subs_capital_mode IS '认购资金处理模式';
COMMENT ON COLUMN crmdm.fms_td_prod_info.subs_capital_type IS '认购款到账方式，其中N为认购交收天数';
COMMENT ON COLUMN crmdm.fms_td_prod_info.sub_payback_period IS '认购退款交收天数';
COMMENT ON COLUMN crmdm.fms_td_prod_info.subs_nextday_cancel IS '认购是否支持隔日撤单';
COMMENT ON COLUMN crmdm.fms_td_prod_info.apply_capital_mode IS '申购资金处理模式';
COMMENT ON COLUMN crmdm.fms_td_prod_info.apply_pay_period IS '申购资金交收天数';
COMMENT ON COLUMN crmdm.fms_td_prod_info.first_buy_flag IS '首次购买判断标准';
COMMENT ON COLUMN crmdm.fms_td_prod_info.convert_status IS '产品转换状态';
COMMENT ON COLUMN crmdm.fms_td_prod_info.periodic_status IS '定期定额状态';
COMMENT ON COLUMN crmdm.fms_td_prod_info.transfer_agency_status IS '转托管状态';
COMMENT ON COLUMN crmdm.fms_td_prod_info.divident_date IS '分红日/发放日';
COMMENT ON COLUMN crmdm.fms_td_prod_info.registration_date IS '权益登记日期';
COMMENT ON COLUMN crmdm.fms_td_prod_info.booking_begin_date IS '预留开始日';
COMMENT ON COLUMN crmdm.fms_td_prod_info.booking_invalid_date IS '预留失效日';
COMMENT ON COLUMN crmdm.fms_td_prod_info.subs_begin_date IS '募集开始日';
COMMENT ON COLUMN crmdm.fms_td_prod_info.subs_end_date IS '募集结束日';
COMMENT ON COLUMN crmdm.fms_td_prod_info.subs_end_time IS '募集结束时间';
COMMENT ON COLUMN crmdm.fms_td_prod_info.subs_cancel_end_date IS '认购撤单截止日期';
COMMENT ON COLUMN crmdm.fms_td_prod_info.establish_date IS '成立日（滚动产品成清算时，将该值更新为下一个周期成立日）';
COMMENT ON COLUMN crmdm.fms_td_prod_info.value_date IS '收益起始日';
COMMENT ON COLUMN crmdm.fms_td_prod_info.open_begin_date IS '开放起始日';
COMMENT ON COLUMN crmdm.fms_td_prod_info.open_end_date IS '开放结束日';
COMMENT ON COLUMN crmdm.fms_td_prod_info.winding_date IS '到期日（到期日期，滚动产品到期清算时将该值更新）';
COMMENT ON COLUMN crmdm.fms_td_prod_info.close_time IS '收市时间';
COMMENT ON COLUMN crmdm.fms_td_prod_info.trans_start_time IS '每日交易允许起始时间';
COMMENT ON COLUMN crmdm.fms_td_prod_info.trans_end_time IS '每日交易允许结束时间';
COMMENT ON COLUMN crmdm.fms_td_prod_info.period_type IS '产品模式';
COMMENT ON COLUMN crmdm.fms_td_prod_info.profit_type IS '计价类型';
COMMENT ON COLUMN crmdm.fms_td_prod_info.prod_lifecycle IS '产品生命周期状态';
COMMENT ON COLUMN crmdm.fms_td_prod_info.redeem_pay_period IS '赎回资金交收天数';
COMMENT ON COLUMN crmdm.fms_td_prod_info.divide_pay_period IS '分红资金交收天数';
COMMENT ON COLUMN crmdm.fms_td_prod_info.end_pay_period IS '产品终止资金交收天数';
COMMENT ON COLUMN crmdm.fms_td_prod_info.apply_cfm_n IS '申购确认日 (0-T+0、1-T+1、2-T+2)';
COMMENT ON COLUMN crmdm.fms_td_prod_info.redeem_cfm_n IS '赎回确认日 (0-T+0、1-T+1、2-T+2)';
COMMENT ON COLUMN crmdm.fms_td_prod_info.is_discount IS '是否允许打折';
COMMENT ON COLUMN crmdm.fms_td_prod_info.can_booking IS '是否可进行额度预留';
COMMENT ON COLUMN crmdm.fms_td_prod_info.redeem_type IS '赎回方式';
COMMENT ON COLUMN crmdm.fms_td_prod_info.can_realtime_redeem IS '是否允许实时赎回';
COMMENT ON COLUMN crmdm.fms_td_prod_info.realtime_repay_flag IS '收市后是否允许实时赎回';
COMMENT ON COLUMN crmdm.fms_td_prod_info.realtime_repay_method IS '收市后实时赎回回款方式';
COMMENT ON COLUMN crmdm.fms_td_prod_info.windup_type IS '清盘方式';
COMMENT ON COLUMN crmdm.fms_td_prod_info.prod_order IS '产品序号';
COMMENT ON COLUMN crmdm.fms_td_prod_info.can_frozen IS '是否允许质押冻结';
COMMENT ON COLUMN crmdm.fms_td_prod_info.can_conv_flag IS '是否支持份额转让';
COMMENT ON COLUMN crmdm.fms_td_prod_info.recom_flg IS '推荐标识';
COMMENT ON COLUMN crmdm.fms_td_prod_info.pgmno IS '产品工作日方案代码';
COMMENT ON COLUMN crmdm.fms_td_prod_info.pre_workday IS '产品上一工作日';
COMMENT ON COLUMN crmdm.fms_td_prod_info.current_workday IS '产品当前工作日';
COMMENT ON COLUMN crmdm.fms_td_prod_info.next_workday IS '产品下一工作日';
COMMENT ON COLUMN crmdm.fms_td_prod_info.min_subs_amt IS '最低募集额';
COMMENT ON COLUMN crmdm.fms_td_prod_info.max_subs_amt IS '最高募集金额';
COMMENT ON COLUMN crmdm.fms_td_prod_info.online_date IS '上线日期';
COMMENT ON COLUMN crmdm.fms_td_prod_info.invest_target IS '投资性质';
COMMENT ON COLUMN crmdm.fms_td_prod_info.cash_flag IS '钞汇标识';
COMMENT ON COLUMN crmdm.fms_td_prod_info.is_hot_sale IS '是否热销产品';
COMMENT ON COLUMN crmdm.fms_td_prod_info.operation_period_day IS '运作期天数';
COMMENT ON COLUMN crmdm.fms_td_prod_info.max_lock_days IS '最大持有天数';
COMMENT ON COLUMN crmdm.fms_td_prod_info.benchmarks_text IS '预期收益率说明/业绩比较基准';
COMMENT ON COLUMN crmdm.fms_td_prod_info.prod_rate IS '收益率';
COMMENT ON COLUMN crmdm.fms_td_prod_info.min_hold IS '最低持有（天）';
COMMENT ON COLUMN crmdm.fms_td_prod_info.prod_days IS '期限';
COMMENT ON COLUMN crmdm.fms_td_prod_info.channel_show_flag IS '渠道端展示标志';
COMMENT ON COLUMN crmdm.fms_td_prod_info.sort_no IS '排序编号';
COMMENT ON COLUMN crmdm.fms_td_prod_info.apply_begin_date IS '本期申购开始日';
COMMENT ON COLUMN crmdm.fms_td_prod_info.redeem_begin_date IS '本期赎回开始日';
COMMENT ON COLUMN crmdm.fms_td_prod_info.prod_template_code IS '冗余字段';
