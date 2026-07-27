-- crmdm.uepp_pay_mct_channel_info 定义

-- Drop table

-- DROP TABLE crmdm.uepp_pay_mct_channel_info;

CREATE TABLE crmdm.uepp_pay_mct_channel_info (
	channel varchar(40) NOT NULL, -- 支付通道
	pay_type varchar(40) NOT NULL, -- 支付类型
	mct_id varchar(40) NOT NULL, -- 商户ID
	fee_rate numeric(16, 4) NULL, -- 费率 单位：‰
	server_id varchar(40) NULL, -- 服务商资质ID
	amt_limit_min numeric(16, 2) NULL, -- 单笔最小
	amt_limit_max numeric(16, 2) NULL, -- 单笔最大
	pay_submct_id varchar(40) NULL, -- 第三方支付子商户号
	remark varchar(300) NULL, -- 备注
	limit_pay varchar(40) NULL -- no_limit-不限   no_credit, --指定不能使用信用卡支付
	status varchar(2) NULL, -- 状态 0-正常（可交易） 1-未生效 2-禁用 9-注销 商户注销时才改成该状态
	create_user varchar(40) NULL, -- 创建创建操作人
	create_time varchar(20) NULL, -- 创建时间  yyyyMMDDHHmmssSSS
	update_user varchar(40) NULL, -- 更新操作人
	update_time varchar(20) NULL, -- 更新时间 yyyyMMDDHHmmssSSS
	feetype varchar(2) NULL, -- 费率类型   01-单一费率  02-多费率  目前只有银联支持多费率 ；微信、支付宝仅支持单一费率
	fee_rate_credit_smallamt numeric(16, 4) NULL, -- 贷记卡小金额费率  交易金额<=1000的贷记卡费率  单位：‰
	fee_rate_credit_largeamt numeric(16, 4) NULL, -- 贷记卡大金额费率  交易金额>1000的贷记卡费率  单位：‰
	fee_rate_debit_smallamt numeric(16, 4) NULL, -- 借记卡小金额费率  交易金额<=1000的借记卡费率  单位：‰
	fee_rate_debit_largeamt numeric(16, 4) NULL, -- 借记卡大金额费率  交易金额>1000的借记卡费率  单位：‰
	check_status varchar(2) NULL, -- 审核状态 00：待审核 01:审核中 02：审核不通过 03：审核通过
	line_type varchar(10) NOT NULL, -- 渠道类型 offline-线下渠道  online-线上渠道
	check_task_id varchar(40) NULL, -- 当前审核任务ID
	nu_submct_id varchar(40) NULL, -- 网联子商户号
	pay_submct_id_netunion varchar(40) NULL, -- 第三方支付子商户号（网联）
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_uepp_pay_mct_channel_info PRIMARY KEY (pay_type, mct_id, line_type)
);

-- Column comments

COMMENT ON COLUMN crmdm.uepp_pay_mct_channel_info.channel IS '支付通道';
COMMENT ON COLUMN crmdm.uepp_pay_mct_channel_info.pay_type IS '支付类型';
COMMENT ON COLUMN crmdm.uepp_pay_mct_channel_info.mct_id IS '商户ID';
COMMENT ON COLUMN crmdm.uepp_pay_mct_channel_info.fee_rate IS '费率 单位：‰';
COMMENT ON COLUMN crmdm.uepp_pay_mct_channel_info.server_id IS '服务商资质ID';
COMMENT ON COLUMN crmdm.uepp_pay_mct_channel_info.amt_limit_min IS '单笔最小';
COMMENT ON COLUMN crmdm.uepp_pay_mct_channel_info.amt_limit_max IS '单笔最大';
COMMENT ON COLUMN crmdm.uepp_pay_mct_channel_info.pay_submct_id IS '第三方支付子商户号';
COMMENT ON COLUMN crmdm.uepp_pay_mct_channel_info.remark IS '备注';
COMMENT ON COLUMN crmdm.uepp_pay_mct_channel_info.limit_pay IS 'no_limit-不限   no_credit --指定不能使用信用卡支付';
COMMENT ON COLUMN crmdm.uepp_pay_mct_channel_info.status IS '状态 0-正常（可交易） 1-未生效 2-禁用 9-注销 商户注销时才改成该状态';
COMMENT ON COLUMN crmdm.uepp_pay_mct_channel_info.create_user IS '创建创建操作人';
COMMENT ON COLUMN crmdm.uepp_pay_mct_channel_info.create_time IS '创建时间  yyyyMMDDHHmmssSSS';
COMMENT ON COLUMN crmdm.uepp_pay_mct_channel_info.update_user IS '更新操作人';
COMMENT ON COLUMN crmdm.uepp_pay_mct_channel_info.update_time IS '更新时间 yyyyMMDDHHmmssSSS';
COMMENT ON COLUMN crmdm.uepp_pay_mct_channel_info.feetype IS '费率类型   01-单一费率  02-多费率  目前只有银联支持多费率 ；微信、支付宝仅支持单一费率';
COMMENT ON COLUMN crmdm.uepp_pay_mct_channel_info.fee_rate_credit_smallamt IS '贷记卡小金额费率  交易金额<=1000的贷记卡费率  单位：‰';
COMMENT ON COLUMN crmdm.uepp_pay_mct_channel_info.fee_rate_credit_largeamt IS '贷记卡大金额费率  交易金额>1000的贷记卡费率  单位：‰';
COMMENT ON COLUMN crmdm.uepp_pay_mct_channel_info.fee_rate_debit_smallamt IS '借记卡小金额费率  交易金额<=1000的借记卡费率  单位：‰';
COMMENT ON COLUMN crmdm.uepp_pay_mct_channel_info.fee_rate_debit_largeamt IS '借记卡大金额费率  交易金额>1000的借记卡费率  单位：‰';
COMMENT ON COLUMN crmdm.uepp_pay_mct_channel_info.check_status IS '审核状态 00：待审核 01:审核中 02：审核不通过 03：审核通过';
COMMENT ON COLUMN crmdm.uepp_pay_mct_channel_info.line_type IS '渠道类型 offline-线下渠道  online-线上渠道';
COMMENT ON COLUMN crmdm.uepp_pay_mct_channel_info.check_task_id IS '当前审核任务ID';
COMMENT ON COLUMN crmdm.uepp_pay_mct_channel_info.nu_submct_id IS '网联子商户号';
COMMENT ON COLUMN crmdm.uepp_pay_mct_channel_info.pay_submct_id_netunion IS '第三方支付子商户号（网联）';
COMMENT ON COLUMN crmdm.uepp_pay_mct_channel_info.ryzd IS '冗余字段';
