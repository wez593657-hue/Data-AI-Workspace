-- crmdm.fms_td_cust_trans_req_log 定义

-- Drop table

-- DROP TABLE crmdm.fms_td_cust_trans_req_log;

CREATE TABLE crmdm.fms_td_cust_trans_req_log (
	app_serno varchar(32) NOT NULL, -- 交易申请流水号
	busi_code varchar(3) NOT NULL, -- 业务代码
	trans_code varchar(8) NULL, -- 交易代码
	fnc_trans_acct_no varchar(24) NOT NULL, -- 理财交易账号
	tano varchar(16) NOT NULL, -- TA代码
	prod_code varchar(32) NOT NULL, -- 产品代码
	share_class bpchar(1) NULL, -- 份额类别
	cust_no varchar(32) NOT NULL, -- 客户号
	cust_type varchar(3) NOT NULL, -- 客户类型
	ta_acct_no varchar(32) NULL, -- TA账号
	ta_cfm_serno varchar(32) NULL, -- TA确认流水
	card_no varchar(32) NULL, -- 凭证号
	card_type varchar(2) NULL, -- 凭证类型
	acct_no varchar(32) NOT NULL, -- 银行账号
	app_date varchar(8) NOT NULL, -- 交易申请业务日期
	cfm_date varchar(8) NULL, -- 交易确认业务日期
	ccy varchar(3) NULL, -- 币种
	app_amt numeric(32, 2) NULL, -- 交易申请金额
	app_vol numeric(32, 2) NULL, -- 交易申请份额
	cfm_amt numeric(32, 2) NULL, -- 交易确认金额
	cfm_vol numeric(32, 2) NULL, -- 交易确认份额
	charge numeric(32, 2) NULL, -- 手续费
	cmms_disct numeric(8, 5) NULL, -- 销售佣金折扣率
	ta_flag bpchar(1) NULL, -- TA发起业务标识
	lrdm_flag bpchar(1) NULL, -- 巨额赎回标识
	channel varchar(8) NULL, -- 渠道
	channel_serno varchar(32) NULL, -- 渠道流水号
	channel_date varchar(8) NULL, -- 渠道日期
	channel_time varchar(8) NULL, -- 渠道时间
	bank_code varchar(16) NULL, -- 交易总行代码
	branch_code varchar(16) NULL, -- 交易分行代码
	trans_orgno varchar(16) NULL, -- 交易机构
	inputuser varchar(10) NULL, -- 交易柜员
	grantuser varchar(8) NULL, -- 授权柜员
	agent_name varchar(128) NULL, -- 经办(代理)人姓名
	agent_id_type varchar(8) NULL, -- 经办(代理)人证件类型
	agent_id_code varchar(32) NULL, -- 经办(代理)人证件号码
	nav numeric(16, 8) NULL, -- 净值
	nav_date varchar(8) NULL, -- 净值日期
	tag_trans_acct_no varchar(24) NULL, -- 对方理财交易账号
	tag_distributorcode varchar(9) NULL, -- 对方销售人代码
	tag_ta_acct_no varchar(16) NULL, -- 对方TA账号
	tag_prod_code varchar(32) NULL, -- 对方产品代码
	tag_share_class bpchar(1) NULL, -- 对方份额类别
	frozen_cause bpchar(1) NULL, -- 冻结原因
	frozen_ddl varchar(8) NULL, -- 冻结截止日期
	ori_app_serno varchar(32) NULL, -- 交易申请流水号原
	def_div_method bpchar(1) NULL, -- 默认分红方式
	trans_status bpchar(1) NULL, -- 交易状态(U-未处理; B-核心超时; C-TA超时; 0-申请成功; 1-申请失败; 2-已撤单; 3-确认成功; 4-确认失败; D-TA成功核心失败; E-TA失败核心成功;F-挂单成功;G部分确认（确认中）)';
	capital_status varchar(1) NULL -- 资金状态(0-未处理;1-已冻结;2-冻结失败;3-冻结超时;4-已扣款;5-扣款失败;6-扣款超时;7-已解冻;8-解冻失败;9-解冻超时;A-已冲正;B-冲正失败;C-冲正超时;D-已还款;E-还款失败;F-还款超时;H-解冻扣款成功;I-解冻扣款失败;J-解冻扣款失败但解冻成功;),
	capital_type varchar(1) NULL, -- 资金处理类型（0-冻结;1-扣款;2-解冻;3-还款;4-冲正;5-解冻并扣款;）
	rtn_code varchar(30) NULL, -- 返回码
	rtn_desc varchar(512) NULL, -- 返回描述
	mac_date varchar(8) NOT NULL, -- 机器日期
	mac_time varchar(8) NOT NULL, -- 机器时间
	legal_code varchar(32) NULL, -- 法人代码（多法人模式）
	host_trans_serno varchar(32) NULL, -- 核心流水号
	update_date varchar(8) NULL, -- 更新日期
	update_time varchar(8) NULL, -- 更新时间
	sys_date varchar(8) NULL, -- 系统日期(系统工作日)
	cust_manager varchar(20) NULL, -- 客户经理代码
	ext_sub_branch_code varchar(16) NULL, -- 推广机构
	frozen_no varchar(32) NULL, -- 理财份额冻结编号
	deposit_acct varchar(32) NULL, -- 保证金账户
	cust_risk_level bpchar(1) NULL, -- 客户风险承受等级
	prod_risk_level bpchar(1) NULL, -- 产品风险等级
	tag_acct_no varchar(32) NULL, -- 对方银行账号
	tag_card_no varchar(32) NULL, -- 对方凭证号
	tag_card_type varchar(1) NULL, -- 对方凭证类型
	tag_agent_name varchar(128) NULL, -- 转入方经办人名称
	tag_agent_id_type varchar(8) NULL, -- 转入方经办人证件类型
	tag_agent_id_code varchar(32) NULL, -- 转入方经办人证件号码
	tag_cust_name varchar(128) NULL, -- 转入方客户名称
	tag_id_type varchar(8) NULL, -- 输入方证件类型
	tag_id_code varchar(32) NULL, -- 输入方证件号码
	is_first bpchar(1) NULL, -- 是否首次购买（1-是 0-否）
	ta_batch varchar(16) NULL, -- TA文件批次号（即文件名尾部的001、002，中登2.2接口允许发送多批次文件）
	ta_app_serno varchar(32) NULL, -- TA确认记录的申请流水号（非TA发起交易的交易时应该与app_serno一致）
	ori_ta_cfm_serno varchar(32) NULL, -- 原TA确认编号（032解冻时需要上送031冻结成功的确认流水号）
	src_serno varchar(32) NULL, -- 全局流水号
	print_count varchar(2) NULL, -- 补打次数
	account_date varchar(8) NULL, -- 预计到账日期
	trans_deal_ip varchar(128) NULL, -- 交易处理ip
	channel_ip varchar(128) NULL, -- 渠道IP
	channel_mac varchar(64) NULL, -- 渠道mac
	recomm_ppl varchar(32) NULL, -- 推荐人
	session_id varchar(32) NULL, -- 回溯码
	ryzd varchar(1) NULL
);
COMMENT ON TABLE crmdm.fms_td_cust_trans_req_log IS '理财交易申请流水表';

-- Column comments

COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.app_serno IS '交易申请流水号';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.busi_code IS '业务代码';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.trans_code IS '交易代码';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.fnc_trans_acct_no IS '理财交易账号';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.tano IS 'TA代码';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.prod_code IS '产品代码';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.share_class IS '份额类别';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.cust_no IS '客户号';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.cust_type IS '客户类型';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.ta_acct_no IS 'TA账号';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.ta_cfm_serno IS 'TA确认流水';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.card_no IS '凭证号';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.card_type IS '凭证类型';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.acct_no IS '银行账号';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.app_date IS '交易申请业务日期';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.cfm_date IS '交易确认业务日期';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.ccy IS '币种';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.app_amt IS '交易申请金额';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.app_vol IS '交易申请份额';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.cfm_amt IS '交易确认金额';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.cfm_vol IS '交易确认份额';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.charge IS '手续费';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.cmms_disct IS '销售佣金折扣率';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.ta_flag IS 'TA发起业务标识';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.lrdm_flag IS '巨额赎回标识';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.channel IS '渠道';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.channel_serno IS '渠道流水号';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.channel_date IS '渠道日期';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.channel_time IS '渠道时间';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.bank_code IS '交易总行代码';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.branch_code IS '交易分行代码';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.trans_orgno IS '交易机构';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.inputuser IS '交易柜员';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.grantuser IS '授权柜员';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.agent_name IS '经办(代理)人姓名';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.agent_id_type IS '经办(代理)人证件类型';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.agent_id_code IS '经办(代理)人证件号码';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.nav IS '净值';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.nav_date IS '净值日期';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.tag_trans_acct_no IS '对方理财交易账号';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.tag_distributorcode IS '对方销售人代码';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.tag_ta_acct_no IS '对方TA账号';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.tag_prod_code IS '对方产品代码';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.tag_share_class IS '对方份额类别';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.frozen_cause IS '冻结原因';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.frozen_ddl IS '冻结截止日期';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.ori_app_serno IS '交易申请流水号原';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.def_div_method IS '默认分红方式';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.trans_status IS '交易状态(U-未处理; B-核心超时; C-TA超时; 0-申请成功; 1-申请失败; 2-已撤单; 3-确认成功; 4-确认失败; D-TA成功核心失败; E-TA失败核心成功;F-挂单成功;G部分确认（确认中）)'';';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.capital_status IS '资金状态(0-未处理;1-已冻结;2-冻结失败;3-冻结超时;4-已扣款;5-扣款失败;6-扣款超时;7-已解冻;8-解冻失败;9-解冻超时;A-已冲正;B-冲正失败;C-冲正超时;D-已还款;E-还款失败;F-还款超时;H-解冻扣款成功;I-解冻扣款失败;J-解冻扣款失败但解冻成功;)';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.capital_type IS '资金处理类型（0-冻结;1-扣款;2-解冻;3-还款;4-冲正;5-解冻并扣款;）';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.rtn_code IS '返回码';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.rtn_desc IS '返回描述';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.mac_date IS '机器日期';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.mac_time IS '机器时间';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.legal_code IS '法人代码（多法人模式）';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.host_trans_serno IS '核心流水号';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.update_date IS '更新日期';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.update_time IS '更新时间';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.sys_date IS '系统日期(系统工作日)';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.cust_manager IS '客户经理代码';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.ext_sub_branch_code IS '推广机构';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.frozen_no IS '理财份额冻结编号';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.deposit_acct IS '保证金账户';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.cust_risk_level IS '客户风险承受等级';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.prod_risk_level IS '产品风险等级';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.tag_acct_no IS '对方银行账号';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.tag_card_no IS '对方凭证号';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.tag_card_type IS '对方凭证类型';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.tag_agent_name IS '转入方经办人名称';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.tag_agent_id_type IS '转入方经办人证件类型';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.tag_agent_id_code IS '转入方经办人证件号码';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.tag_cust_name IS '转入方客户名称';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.tag_id_type IS '输入方证件类型';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.tag_id_code IS '输入方证件号码';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.is_first IS '是否首次购买（1-是 0-否）';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.ta_batch IS 'TA文件批次号（即文件名尾部的001、002，中登2.2接口允许发送多批次文件）';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.ta_app_serno IS 'TA确认记录的申请流水号（非TA发起交易的交易时应该与app_serno一致）';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.ori_ta_cfm_serno IS '原TA确认编号（032解冻时需要上送031冻结成功的确认流水号）';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.src_serno IS '全局流水号';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.print_count IS '补打次数';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.account_date IS '预计到账日期';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.trans_deal_ip IS '交易处理ip';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.channel_ip IS '渠道IP';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.channel_mac IS '渠道mac';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.recomm_ppl IS '推荐人';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.session_id IS '回溯码';
