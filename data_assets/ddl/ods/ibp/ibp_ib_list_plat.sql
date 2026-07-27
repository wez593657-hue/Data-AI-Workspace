-- crmdm.ibp_ib_list_plat 定义

-- Drop table

-- DROP TABLE crmdm.ibp_ib_list_plat;

CREATE TABLE crmdm.ibp_ib_list_plat (
	plat_serial varchar(35) NOT NULL, -- 平台流水
	plat_date varchar(8) NOT NULL, -- 交易日期
	plat_time varchar(6) NOT NULL, -- 交易时间
	reverse_flag varchar(1) NOT NULL, -- 是否冲正交易 0:否 1:是
	ori_serial varchar(35) NULL, -- 原交易流水号
	channel_id varchar(4) NOT NULL, -- 渠道号
	service_id varchar(8) NOT NULL, -- 交易码
	channel_serial varchar(40) NOT NULL, -- 渠道流水号
	channel_date varchar(8) NULL, -- 渠道日期
	channel_time varchar(6) NULL, -- 渠道时间
	trans_device_no varchar(40) NULL, -- 交易设备ID
	area_id varchar(4) NULL, -- 交易区域
	branch_code varchar(20) NULL, -- 交易机构
	teller_id varchar(20) NULL, -- 柜员号
	auther_id varchar(20) NULL, -- 授权柜员号
	auther_password varchar(64) NULL, -- 授权密码
	busi_id varchar(24) NOT NULL, -- 业务分类编号
	acct_no varchar(32) NULL, -- 交易账号
	acct_name varchar(1020) NULL, -- 交易账号名称
	trad_type varchar(1) NOT NULL, -- 交易类别 0:现金 1:转账 2:其他
	cry_id varchar(3) NOT NULL, -- 交易币种(CNY，基于ISO 4217)
	amt numeric(16, 2) NOT NULL, -- 交易金额
	amt1 numeric(16, 2) NULL, -- 辅助金额1
	amt2 numeric(16, 2) NULL, -- 辅助金额2
	amt3 numeric(16, 2) NULL, -- 辅助金额3
	trad_abs varchar(800) NULL, -- 交易摘要
	voucher_type varchar(3) NULL, -- 凭证类型
	voucher_no varchar(40) NULL, -- 凭证号码
	opp_acct_no varchar(32) NULL, -- 对手账户
	opp_acct_name varchar(1020) NULL, -- 对手账户名称
	user_id varchar(80) NULL, -- 客户编号
	user_name varchar(800) NULL, -- 客户姓名
	tran_memo varchar(1020) NULL, -- 交易备注信息
	plat_trad_status varchar(1) NOT NULL, -- 平台处理状态 0预计1处理中 2处理成功 3处理失败 4已冲正
	plat_resp_code varchar(12) NULL, -- 平台响应码
	plat_resp_msg varchar(800) NULL, -- 平台响应信息
	core_status varchar(1) NULL, -- 核心处理状态 0预计1处理中 2处理成功 3处理失败 4已冲正
	core_serial_no varchar(40) NULL, -- 核心请求流水号
	core_resp_serial varchar(40) NULL, -- 核心响应流水号
	core_resp_code varchar(20) NULL, -- 核心响应码
	core_resp_msg varchar(800) NULL, -- 核心响应信息
	third_party_status varchar(1) NULL, -- 第三方处理状态 0预计1处理中 2处理成功 3处理失败 4已冲正
	third_party_serial_no varchar(40) NULL, -- 第三方请求流水号
	third_party_resp_serial varchar(40) NULL, -- 第三方响应流水号
	third_party_resp_code varchar(20) NULL, -- 第三方响应码
	third_party_resp_msg varchar(800) NULL, -- 第三方响应信息
	request_add_info varchar(4000) NULL, -- 请求附加域
	resp_add_info varchar(4000) NULL, -- 响应附加域
	chk_flag varchar(1) NOT NULL, -- N 无需对账，0:未对账，1:已对账，2:已生成第三方对账文件，3:处理中
	core_date varchar(8) NULL, -- 核心日期
	third_party_date varchar(8) NULL, -- 第三方日期
	core_time varchar(6) NULL, -- 核心时间
	settle_date varchar(8) NULL, -- 清算日期
	tran_date varchar(8) NOT NULL, -- 交易日期
	item_id varchar(40) NULL, -- 项目分类编号
	rem_amt numeric(16, 2) NULL, -- 剩余可退款金额
	third_party_time varchar(6) NULL, -- 第三方时间
	third_chk_flag varchar(2) NULL, -- 三方对账 N:无需对账 0:未对账 1:已对账 2:对账有差错
	settle_cd_flag varchar(2) NULL, -- 过渡户清算借贷标识 D:借记 C:贷记
	settle_flag varchar(2) NULL, -- 清算标识 N:无需清算 0:未清算 1:已清算 2:清算失败
	settle_amt numeric(16, 2) NULL, -- 清算金额
	d_amt_sum numeric(17, 2) NOT NULL, -- 借方累计金额
	c_amt_sum numeric(17, 2) NOT NULL, -- 贷方累计金额
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.ibp_ib_list_plat.plat_serial IS '平台流水';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.plat_date IS '交易日期';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.plat_time IS '交易时间';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.reverse_flag IS '是否冲正交易 0:否 1:是';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.ori_serial IS '原交易流水号';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.channel_id IS '渠道号';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.service_id IS '交易码';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.channel_serial IS '渠道流水号';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.channel_date IS '渠道日期';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.channel_time IS '渠道时间';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.trans_device_no IS '交易设备ID';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.area_id IS '交易区域';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.branch_code IS '交易机构';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.teller_id IS '柜员号';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.auther_id IS '授权柜员号';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.auther_password IS '授权密码';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.busi_id IS '业务分类编号';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.acct_no IS '交易账号';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.acct_name IS '交易账号名称';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.trad_type IS '交易类别 0:现金 1:转账 2:其他';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.cry_id IS '交易币种(CNY，基于ISO 4217)';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.amt IS '交易金额';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.amt1 IS '辅助金额1';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.amt2 IS '辅助金额2';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.amt3 IS '辅助金额3';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.trad_abs IS '交易摘要';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.voucher_type IS '凭证类型';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.voucher_no IS '凭证号码';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.opp_acct_no IS '对手账户';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.opp_acct_name IS '对手账户名称';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.user_id IS '客户编号';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.user_name IS '客户姓名';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.tran_memo IS '交易备注信息';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.plat_trad_status IS '平台处理状态 0预计1处理中 2处理成功 3处理失败 4已冲正';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.plat_resp_code IS '平台响应码';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.plat_resp_msg IS '平台响应信息';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.core_status IS '核心处理状态 0预计1处理中 2处理成功 3处理失败 4已冲正';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.core_serial_no IS '核心请求流水号';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.core_resp_serial IS '核心响应流水号';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.core_resp_code IS '核心响应码';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.core_resp_msg IS '核心响应信息';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.third_party_status IS '第三方处理状态 0预计1处理中 2处理成功 3处理失败 4已冲正';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.third_party_serial_no IS '第三方请求流水号';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.third_party_resp_serial IS '第三方响应流水号';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.third_party_resp_code IS '第三方响应码';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.third_party_resp_msg IS '第三方响应信息';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.request_add_info IS '请求附加域';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.resp_add_info IS '响应附加域';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.chk_flag IS 'N 无需对账，0:未对账，1:已对账，2:已生成第三方对账文件，3:处理中';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.core_date IS '核心日期';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.third_party_date IS '第三方日期';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.core_time IS '核心时间';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.settle_date IS '清算日期';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.tran_date IS '交易日期';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.item_id IS '项目分类编号';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.rem_amt IS '剩余可退款金额';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.third_party_time IS '第三方时间';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.third_chk_flag IS '三方对账 N:无需对账 0:未对账 1:已对账 2:对账有差错';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.settle_cd_flag IS '过渡户清算借贷标识 D:借记 C:贷记';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.settle_flag IS '清算标识 N:无需清算 0:未清算 1:已清算 2:清算失败';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.settle_amt IS '清算金额';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.d_amt_sum IS '借方累计金额';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.c_amt_sum IS '贷方累计金额';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.ryzd IS '冗余字段';
