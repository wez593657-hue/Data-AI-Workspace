-- crmdm.uepp_pay_order_info 定义

-- Drop table

-- DROP TABLE crmdm.uepp_pay_order_info;

CREATE TABLE crmdm.uepp_pay_order_info (
	order_id varchar(40) NOT NULL, -- 平台订单号
	order_type varchar(10) NULL, -- 订单类型 00-支付交易  01-退款交易
	channel varchar(40) NULL, -- 支付通道
	pay_type varchar(40) NULL, -- 支付类型
	mct_id varchar(40) NOT NULL, -- 平台商户号  如果是门店则是门店的商户号
	dit_id varchar(40) NOT NULL, -- 平台渠道商ID
	order_amt numeric(16, 2) NOT NULL, -- 订单金额（给商户清算金额 支付交易的支付金额   退款交易的退款金额）
	pay_amt numeric(16, 2) NULL, -- 平台实际支付金额（传给第三方支付平台的金额=订单金额-优惠金额）
	dis_amt numeric(16, 2) NULL, -- 优惠金额
	dis_auth_id varchar(40) NULL, -- 优惠凭证
	pay_time varchar(20) NULL, -- 支付时间(调用支付接口的时间)
	jungle_type varchar(2) NULL, -- 分润方式 见 PAY_DIT_INFO 表 JUNGLE_TYPE
	jungle_amt numeric(16, 2) NULL, -- 分润金额
	server_id varchar(40) NULL, -- 服务商资质ID
	mct_fee numeric(16, 2) NULL, -- 应收商户手续费
	dit_fee numeric(16, 2) NULL, -- 收渠道商手续费 收渠道商的钱
	buyer_pay_amt numeric(16, 2) NULL, -- 买家实际支付金额(第三方支付平台返回)
	buyer_user_id varchar(200) NULL, -- 买家用户ID(第三方支付平台返回  也是微信的openid)
	third_mch_id varchar(40) NULL, -- 第三方商户号（银行服务商在第三方支付系统商户号或机构号）
	third_sub_mch_id varchar(40) NULL, -- 第三方子商户号（该商户在第三方支付系统的商户号）
	third_pay_fee numeric(16, 2) NULL, -- 成本手续费
	third_trade_no varchar(40) NULL, -- 第三方支付平台支付订单号
	third_end_time varchar(20) NULL, -- 交易完成时间/退款完成时间(支付完成时间、退款完成时间 第三方支付平台返回)
	settle_date varchar(8) NULL, -- 账单日期  第三方返回（属于哪天对账的日期）
	timeout_express varchar(20) NULL, -- 该笔订单允许的最晚付款时间，逾期将关闭交易，从生成二维码开始计时。取值范围：1m～15d。m-分钟，h-小时，d-天，1c-当天（1c-当天的情况下，无论交易何时创建，都在0点关闭）。 该参数数值不接受小数点， 如 1.5h，可转换为 90m。
	limit_pay varchar(20) NULL, -- 是否限制不让使用信用卡  只有微信
	out_trade_no varchar(40) NULL, -- 商户订单号（外部系统接入时的订单号）
	or_order_id varchar(40) NULL, -- 原平台订单号（退款交易时有）
	web_notify_url varchar(256) NULL, -- 前端跳转地址
	notify_url varchar(500) NULL, -- 交易结果通知地址
	order_body varchar(200) NULL, -- 商品描述/名称
	order_detail varchar(1000) NULL, -- 商品详细描述
	term_id varchar(100) NULL, -- 终端标识
	dev_info varchar(500) NULL, -- 主扫支付时二维码信息  被扫支付时设备信息
	auth_code varchar(200) NULL, -- 被扫支付授权码
	qr_code varchar(300) NULL, -- 平台订单号
	"attach" varchar(500) NULL, -- 附加信息
	remark varchar(300) NULL, -- 备注  可以填写错误返回信息
	status varchar(2) NULL, -- 订单状态  00：待付款  01：处理中 02：交易成功 03：交易失败  04：已关闭  05：已撤销  90:超时 91:异常  98：预下单  99：日终失效
	create_user varchar(40) NULL, -- 创建创建操作人  操作员  默认商户号 如果是店员则是店员编号
	create_time varchar(20) NULL, -- 创建时间  yyyyMMDDHHmmssSSS
	update_user varchar(40) NULL, -- 更新操作人
	update_time varchar(20) NULL, -- 更新时间 yyyyMMDDHHmmssSSS
	buyer_user_name varchar(200) NULL, -- 买家用户名称
	pay_card_type varchar(2) NULL, -- 支付卡类型 01-借记卡  02-贷记卡
	client_id varchar(40) NULL, -- 客户端ID（系统内部APP_ID）
	client_info varchar(300) NULL, -- 终端信息（如手机型号、客户端浏览器信息等）
	cost_rate numeric(16, 4) NULL, -- 成本费率(第三方收服务商的费率) 单位：‰
	dit_fee_rate numeric(16, 4) NULL, -- 渠道商费率（服务商收渠道商的纯利润费率，纯利润费率即扣除成本费率之后的费率） 单位：‰
	mct_fee_rate numeric(16, 4) NULL, -- 商户费率（渠道商收商户费率） 单位：‰
	settle_flag varchar(2) NULL, -- 清算标识  1-商户清算成功 0-商户未清算  2-商户清算中  9-门店清算失败 11-门店清算成功 10-门店未清算  12-门店清算中  19-门店清算失败
	bala_flag varchar(1) NULL, -- 对账标识 0:未对账1:对账成功2:平台少账3:平台多张4:金额不符
	settle_serial_no varchar(40) NULL, -- 清算时的流水号
	settle_update_date varchar(8) NULL, -- 清算更新日期
	bala_update_date varchar(8) NULL, -- 实际更新日期
	settle_type varchar(2) NULL, -- 清算类型 T0：T+0当日清算  T1：T+1下日清算
	activity_rate numeric(16, 4) NULL, -- 活动费率:商户参加活动的最低活动费率，若商户参加活动则有值，单位：‰
	activity_fee numeric(16, 2) NULL, -- 活动手续费:商户参加活动的最低手续费，若商户参加活动则有值
	mct_real_fee numeric(16, 2) NULL, -- 实收商户手续费:为【应收商户手续费】和【活动手续费】较小值
	activity_id varchar(32) NULL, -- 活动ID:该笔订单参加的活动ID
	isscode varchar(11) NULL, -- 发卡机构代码
	ip varchar(16) NULL, -- 交易IPv4地址
	tr_mac varchar(32) NULL, -- 交易MAC地址
	core_id varchar(40) NULL, -- 快捷支付核心流水号
	mct_related_id varchar(32) NULL, -- 商户活动编号
	consumer_id varchar(40) NULL, -- 客户ID
	idc_flag varchar(10) NULL, -- 网联idc标识
	device_ip varchar(64) NULL, -- 绑卡设备（付款APP）所在的公网ip，可用于定位所属地区，不是wifi连接时的局域网ip。
	device_location varchar(32) NULL, -- (付款APP)设备GPS位置，格式为纬度/经度，+表示北纬、东经，-表示南纬西经。
	user_id varchar(128) NULL, -- 微信用户唯一标识码
	is_next_refund varchar(10) NULL, -- 是否是隔日退款 0 - 不是  1 - 是
	store_id varchar(40) NULL, -- 门店号
	wal_acct_amt numeric(16, 2) NULL, -- 电子钱包支付金额
	wal_acct_status varchar(2) NULL, -- 电子钱包支付状态 00-待支付 , 01-支付成功 , 03-支付失败 , 04-冲正处理中 , 05-冲正成功 , 06-冲正失败
	wal_acct_no varchar(40) NULL, -- 所使用电子钱包账户
	refund_mode varchar(2) NULL, -- 退款模式  00-余额模式 01-待清算模式
	pay_zh varchar(2) NULL, -- 组合支付判断标识 1 - 支付宝钱包组合 2 - 本行卡钱包组合
	wal_trade_no varchar(40) NULL, -- 电子钱包支付订单号
	wal_end_time varchar(20) NULL, -- 交易完成时间/退款完成时间(支付完成时间、退款完成时间 钱包支付平台返回)
	wal_bala_flag varchar(1) NULL, -- 电子钱包对账标识 0:未对账1:对账成功2:平台少账3:平台多张4:金额不符
	calc_fee_flag varchar(2) NULL, -- 计算手续费标识 0待计算 1计算中 2计算完成
	mct_real_fee_type varchar(2) NULL, -- 0:旧费率,1:白名单0费率,2:免收期费率,3:起征点内费率,4:白名单非0费率,5:额度内费率,6:额度外费率
	app_refundable_flag varchar(1) NULL, -- 1:不允许app退款
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_uepp_pay_order_info PRIMARY KEY (order_id)
);

-- Column comments

COMMENT ON COLUMN crmdm.uepp_pay_order_info.order_id IS '平台订单号';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.order_type IS '订单类型 00-支付交易  01-退款交易';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.channel IS '支付通道';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.pay_type IS '支付类型';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.mct_id IS '平台商户号  如果是门店则是门店的商户号';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.dit_id IS '平台渠道商ID';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.order_amt IS '订单金额（给商户清算金额 支付交易的支付金额   退款交易的退款金额）';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.pay_amt IS '平台实际支付金额（传给第三方支付平台的金额=订单金额-优惠金额）';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.dis_amt IS '优惠金额';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.dis_auth_id IS '优惠凭证';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.pay_time IS '支付时间(调用支付接口的时间)';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.jungle_type IS '分润方式 见 PAY_DIT_INFO 表 JUNGLE_TYPE';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.jungle_amt IS '分润金额';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.server_id IS '服务商资质ID';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.mct_fee IS '应收商户手续费';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.dit_fee IS '收渠道商手续费 收渠道商的钱';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.buyer_pay_amt IS '买家实际支付金额(第三方支付平台返回)';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.buyer_user_id IS '买家用户ID(第三方支付平台返回  也是微信的openid)';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.third_mch_id IS '第三方商户号（银行服务商在第三方支付系统商户号或机构号）';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.third_sub_mch_id IS '第三方子商户号（该商户在第三方支付系统的商户号）';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.third_pay_fee IS '成本手续费';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.third_trade_no IS '第三方支付平台支付订单号';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.third_end_time IS '交易完成时间/退款完成时间(支付完成时间、退款完成时间 第三方支付平台返回)';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.settle_date IS '账单日期  第三方返回（属于哪天对账的日期）';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.timeout_express IS '该笔订单允许的最晚付款时间，逾期将关闭交易，从生成二维码开始计时。取值范围：1m～15d。m-分钟，h-小时，d-天，1c-当天（1c-当天的情况下，无论交易何时创建，都在0点关闭）。 该参数数值不接受小数点， 如 1.5h，可转换为 90m。';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.limit_pay IS '是否限制不让使用信用卡  只有微信';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.out_trade_no IS '商户订单号（外部系统接入时的订单号）';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.or_order_id IS '原平台订单号（退款交易时有）';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.web_notify_url IS '前端跳转地址';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.notify_url IS '交易结果通知地址';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.order_body IS '商品描述/名称';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.order_detail IS '商品详细描述';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.term_id IS '终端标识';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.dev_info IS '主扫支付时二维码信息  被扫支付时设备信息';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.auth_code IS '被扫支付授权码';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.qr_code IS '平台订单号';
COMMENT ON COLUMN crmdm.uepp_pay_order_info."attach" IS '附加信息';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.remark IS '备注  可以填写错误返回信息';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.status IS '订单状态  00：待付款  01：处理中 02：交易成功 03：交易失败  04：已关闭  05：已撤销  90:超时 91:异常  98：预下单  99：日终失效';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.create_user IS '创建创建操作人  操作员  默认商户号 如果是店员则是店员编号';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.create_time IS '创建时间  yyyyMMDDHHmmssSSS';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.update_user IS '更新操作人';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.update_time IS '更新时间 yyyyMMDDHHmmssSSS';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.buyer_user_name IS '买家用户名称';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.pay_card_type IS '支付卡类型 01-借记卡  02-贷记卡';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.client_id IS '客户端ID（系统内部APP_ID）';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.client_info IS '终端信息（如手机型号、客户端浏览器信息等）';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.cost_rate IS '成本费率(第三方收服务商的费率) 单位：‰';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.dit_fee_rate IS '渠道商费率（服务商收渠道商的纯利润费率，纯利润费率即扣除成本费率之后的费率） 单位：‰';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.mct_fee_rate IS '商户费率（渠道商收商户费率） 单位：‰';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.settle_flag IS '清算标识  1-商户清算成功 0-商户未清算  2-商户清算中  9-门店清算失败 11-门店清算成功 10-门店未清算  12-门店清算中  19-门店清算失败';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.bala_flag IS '对账标识 0:未对账1:对账成功2:平台少账3:平台多张4:金额不符';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.settle_serial_no IS '清算时的流水号';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.settle_update_date IS '清算更新日期';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.bala_update_date IS '实际更新日期';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.settle_type IS '清算类型 T0：T+0当日清算  T1：T+1下日清算';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.activity_rate IS '活动费率:商户参加活动的最低活动费率，若商户参加活动则有值，单位：‰';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.activity_fee IS '活动手续费:商户参加活动的最低手续费，若商户参加活动则有值';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.mct_real_fee IS '实收商户手续费:为【应收商户手续费】和【活动手续费】较小值';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.activity_id IS '活动ID:该笔订单参加的活动ID';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.isscode IS '发卡机构代码';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.ip IS '交易IPv4地址';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.tr_mac IS '交易MAC地址';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.core_id IS '快捷支付核心流水号';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.mct_related_id IS '商户活动编号';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.consumer_id IS '客户ID';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.idc_flag IS '网联idc标识';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.device_ip IS '绑卡设备（付款APP）所在的公网ip，可用于定位所属地区，不是wifi连接时的局域网ip。';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.device_location IS '(付款APP)设备GPS位置，格式为纬度/经度，+表示北纬、东经，-表示南纬西经。';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.user_id IS '微信用户唯一标识码';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.is_next_refund IS '是否是隔日退款 0 - 不是  1 - 是';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.store_id IS '门店号';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.wal_acct_amt IS '电子钱包支付金额';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.wal_acct_status IS '电子钱包支付状态 00-待支付 , 01-支付成功 , 03-支付失败 , 04-冲正处理中 , 05-冲正成功 , 06-冲正失败';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.wal_acct_no IS '所使用电子钱包账户';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.refund_mode IS '退款模式  00-余额模式 01-待清算模式';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.pay_zh IS '组合支付判断标识 1 - 支付宝钱包组合 2 - 本行卡钱包组合';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.wal_trade_no IS '电子钱包支付订单号';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.wal_end_time IS '交易完成时间/退款完成时间(支付完成时间、退款完成时间 钱包支付平台返回)';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.wal_bala_flag IS '电子钱包对账标识 0:未对账1:对账成功2:平台少账3:平台多张4:金额不符';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.calc_fee_flag IS '计算手续费标识 0待计算 1计算中 2计算完成';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.mct_real_fee_type IS '0:旧费率,1:白名单0费率,2:免收期费率,3:起征点内费率,4:白名单非0费率,5:额度内费率,6:额度外费率';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.app_refundable_flag IS '1:不允许app退款';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.ryzd IS '冗余字段';
