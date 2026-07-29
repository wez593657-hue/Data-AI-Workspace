-- crmdm.uepp_pay_aml_order_info 定义

-- Drop table

-- DROP TABLE crmdm.uepp_pay_aml_order_info;

CREATE TABLE crmdm.uepp_pay_aml_order_info (
	tr_id varchar(256) NOT NULL, -- 业务识别号（平台订单号）
	tr_dt varchar(48) NULL, -- 交易日期
	tr_tm varchar(48) NULL, -- 交易日期和时间
	tr_no varchar(50) NULL, -- 交易流水号
	rcv_pay_type varchar(2) NULL, -- 收付款方匹配号类型
	rcv_pay_no varchar(200) NULL, -- 收付款方匹配号
	tr_org_id varchar(16) NULL, -- 交易机构编号
	cust_id varchar(32) NULL, -- 客户编号
	cust_name varchar(512) NULL, -- 客户名称
	cust_type varchar(1) NULL, -- 客户类型
	acct_id varchar(64) NULL, -- 账号
	card_no varchar(64) NULL, -- 卡号/折号
	card_style varchar(2) NULL, -- 卡片类型
	oth_card_style varchar(128) NULL, -- 其他卡片类型
	subject_id varchar(20) NULL, -- 科目编号
	prd_id varchar(20) NULL, -- 产品编号
	tr_chnl varchar(32) NULL, -- AML交易渠道
	s_tr_chnl varchar(10) NULL, -- 源系统交易渠道
	tr_cd varchar(4) NULL, -- AML交易代码
	s_tr_cd varchar(10) NULL, -- 源系统交易代码
	biz_type varchar(2) NULL, -- PBC业务类型
	is_cash varchar(2) NULL, -- 现转标志
	pay_type varchar(4) NULL, -- 支付工具及结算方式
	debit_credit varchar(1) NULL, -- 借贷标志
	rcv_pay varchar(2) NULL, -- 收付标志
	curr_cd varchar(3) NULL, -- 币种
	is_local_curr varchar(1) NULL, -- 本外币标志
	tr_amt numeric(30, 4) NULL, -- 原币种交易金额
	tr_cny_amt numeric(30, 4) NULL, -- 折人民币交易金额
	tr_usd_amt numeric(30, 4) NULL, -- 折美元交易金额
	tr_bal_amt numeric(30, 4) NULL, -- 交易余额
	tr_country varchar(3) NULL, -- 交易发生国家
	tr_area varchar(6) NULL, -- 交易发生地区
	fund_use varchar(256) NULL, -- 资金用途和来源
	agent_name varchar(128) NULL, -- 代办人姓名
	agent_nat varchar(3) NULL, -- 代办人国籍
	agent_cert_type varchar(6) NULL, -- 代办人证件种类
	oth_agent_cert_type varchar(128) NULL, -- 代办人其他证件种类
	agent_cert_no varchar(128) NULL, -- 代办人证件号码
	opp_name varchar(128) NULL, -- 对方名称
	opp_acct_id varchar(64) NULL, -- 对方账号
	opp_acct_type varchar(6) NULL, -- 对手PBC账户类型
	opp_is_cust varchar(1) NULL, -- 对方是否我行客户
	opp_cust_id varchar(64) NULL, -- 对方客户编号
	opp_cust_type varchar(1) NULL, -- 对方客户类型
	opp_off_shore varchar(1) NULL, -- 对方是否离岸账户
	opp_card_no varchar(64) NULL, -- 对方卡号/折号
	opp_card_style varchar(2) NULL, -- 对方卡片类型
	oth_opp_card_style varchar(128) NULL, -- 对方其他卡片类型
	opp_cert_type varchar(6) NULL, -- 对方证件类型
	oth_opp_cert_type varchar(128) NULL, -- 对方其他证件类型
	opp_cert_no varchar(128) NULL, -- 对方证件号码
	opp_org_id varchar(16) NULL, -- 对方金融机构编号
	opp_org_name varchar(128) NULL, -- 对方金融机构名称
	opp_org_type varchar(2) NULL, -- 对方金融机构类型
	opp_org_country varchar(3) NULL, -- 对方金融机构网点国家
	opp_org_area varchar(6) NULL, -- 对方金融机构网点地区
	tr_go_country varchar(3) NULL, -- 交易去向国家
	tr_go_area varchar(6) NULL, -- 交易去向地区
	is_cross varchar(1) NULL, -- 是否跨境
	opr_id varchar(32) NULL, -- 交易操作员
	re_opr_id varchar(32) NULL, -- 交易复核员
	rev_cd varchar(1) NULL, -- 冲正标志
	pbc_rltp varchar(15) NULL, -- 金融机构与客户的关系
	pbc_tsct varchar(16) NULL, -- 涉外收支交易代码
	sys_id varchar(32) NULL, -- 发起系统编码
	ip varchar(15) NULL, -- 交易IPv4地址
	tr_ipv6 varchar(32) NULL, -- 交易IPv6地址
	tr_mac varchar(32) NULL, -- 交易MAC地址
	tr_note1 varchar(256) NULL, -- 交易信息备注1
	tr_note2 varchar(256) NULL, -- 交易信息备注2
	bank_pay_cd varchar(128) NULL, -- 银行与支付机构之间的业务交易编码
	eqpt_cd varchar(500) NULL, -- 非柜台交易介质的设备代码
	merch_id varchar(20) NULL, -- 收单商户编码
	merch_type varchar(4) NULL, -- 收单商户类型
	is_3rd_pay varchar(1) NULL, -- 是否第三方支付
	tr_crt_type varchar(1) NULL, -- 交易创建方式
	bh_exec varchar(1) NULL, -- 参与大额计算
	bs_exec varchar(1) NULL, -- 参与可疑计算
	clct_sts varchar(1) NULL, -- 筛查前补录状态
	bh_valid varchar(1) NULL, -- 大额验证
	bs_valid varchar(1) NULL, -- 可疑验证
	due_dt sys."date" NULL, -- 处理期限
	rsrv_01 varchar(48) NULL, -- 备用字段1
	rsrv_02 varchar(48) NULL, -- 备用字段2
	rsrv_03 varchar(48) NULL, -- 备用字段3
	rsrv_04 varchar(48) NULL, -- 备用字段4
	pbc_chnl varchar(50) NULL, -- PBC交易渠道
	non_dept_type varchar(2) NULL, -- 非柜台交易方式
	oth_non_dept_type varchar(64) NULL, -- 非柜台交易方式
	pbc_orgkey varchar(16) NULL, -- 金融机构网点代码
	main_acct_id varchar(64) NULL, -- 主账号
	agent_tel varchar(60) NULL, -- 代理人联系方式
	opp_acct_type1 varchar(6) NULL, -- 对手账户类型1
	pos_owner varchar(40) NULL, -- 信用卡消费商户名称
	is_cadr_trans varchar(2) NULL, -- 是否有卡交易
	cert_no varchar(128) NULL, -- 客户证件号码
	cert_type varchar(6) NULL, -- 客户证件类型
	oth_cert_type varchar(128) NULL, -- 客户其他证件类型
	atm_bank_code varchar(20) NULL, -- atm机具所属行行号
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_uepp_pay_aml_order_info PRIMARY KEY (tr_id)
);

-- Column comments

COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.tr_id IS '业务识别号（平台订单号）';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.tr_dt IS '交易日期';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.tr_tm IS '交易日期和时间';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.tr_no IS '交易流水号';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.rcv_pay_type IS '收付款方匹配号类型';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.rcv_pay_no IS '收付款方匹配号';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.tr_org_id IS '交易机构编号';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.cust_id IS '客户编号';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.cust_name IS '客户名称';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.cust_type IS '客户类型';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.acct_id IS '账号';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.card_no IS '卡号/折号';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.card_style IS '卡片类型';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.oth_card_style IS '其他卡片类型';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.subject_id IS '科目编号';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.prd_id IS '产品编号';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.tr_chnl IS 'AML交易渠道';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.s_tr_chnl IS '源系统交易渠道';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.tr_cd IS 'AML交易代码';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.s_tr_cd IS '源系统交易代码';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.biz_type IS 'PBC业务类型';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.is_cash IS '现转标志';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.pay_type IS '支付工具及结算方式';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.debit_credit IS '借贷标志';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.rcv_pay IS '收付标志';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.curr_cd IS '币种';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.is_local_curr IS '本外币标志';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.tr_amt IS '原币种交易金额';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.tr_cny_amt IS '折人民币交易金额';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.tr_usd_amt IS '折美元交易金额';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.tr_bal_amt IS '交易余额';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.tr_country IS '交易发生国家';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.tr_area IS '交易发生地区';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.fund_use IS '资金用途和来源';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.agent_name IS '代办人姓名';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.agent_nat IS '代办人国籍';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.agent_cert_type IS '代办人证件种类';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.oth_agent_cert_type IS '代办人其他证件种类';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.agent_cert_no IS '代办人证件号码';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.opp_name IS '对方名称';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.opp_acct_id IS '对方账号';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.opp_acct_type IS '对手PBC账户类型';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.opp_is_cust IS '对方是否我行客户';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.opp_cust_id IS '对方客户编号';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.opp_cust_type IS '对方客户类型';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.opp_off_shore IS '对方是否离岸账户';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.opp_card_no IS '对方卡号/折号';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.opp_card_style IS '对方卡片类型';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.oth_opp_card_style IS '对方其他卡片类型';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.opp_cert_type IS '对方证件类型';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.oth_opp_cert_type IS '对方其他证件类型';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.opp_cert_no IS '对方证件号码';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.opp_org_id IS '对方金融机构编号';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.opp_org_name IS '对方金融机构名称';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.opp_org_type IS '对方金融机构类型';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.opp_org_country IS '对方金融机构网点国家';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.opp_org_area IS '对方金融机构网点地区';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.tr_go_country IS '交易去向国家';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.tr_go_area IS '交易去向地区';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.is_cross IS '是否跨境';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.opr_id IS '交易操作员';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.re_opr_id IS '交易复核员';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.rev_cd IS '冲正标志';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.pbc_rltp IS '金融机构与客户的关系';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.pbc_tsct IS '涉外收支交易代码';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.sys_id IS '发起系统编码';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.ip IS '交易IPv4地址';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.tr_ipv6 IS '交易IPv6地址';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.tr_mac IS '交易MAC地址';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.tr_note1 IS '交易信息备注1';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.tr_note2 IS '交易信息备注2';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.bank_pay_cd IS '银行与支付机构之间的业务交易编码';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.eqpt_cd IS '非柜台交易介质的设备代码';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.merch_id IS '收单商户编码';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.merch_type IS '收单商户类型';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.is_3rd_pay IS '是否第三方支付';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.tr_crt_type IS '交易创建方式';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.bh_exec IS '参与大额计算';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.bs_exec IS '参与可疑计算';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.clct_sts IS '筛查前补录状态';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.bh_valid IS '大额验证';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.bs_valid IS '可疑验证';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.due_dt IS '处理期限';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.rsrv_01 IS '备用字段1';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.rsrv_02 IS '备用字段2';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.rsrv_03 IS '备用字段3';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.rsrv_04 IS '备用字段4';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.pbc_chnl IS 'PBC交易渠道';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.non_dept_type IS '非柜台交易方式';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.oth_non_dept_type IS '非柜台交易方式';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.pbc_orgkey IS '金融机构网点代码';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.main_acct_id IS '主账号';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.agent_tel IS '代理人联系方式';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.opp_acct_type1 IS '对手账户类型1';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.pos_owner IS '信用卡消费商户名称';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.is_cadr_trans IS '是否有卡交易';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.cert_no IS '客户证件号码';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.cert_type IS '客户证件类型';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.oth_cert_type IS '客户其他证件类型';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.atm_bank_code IS 'atm机具所属行行号';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.ryzd IS '冗余字段';
