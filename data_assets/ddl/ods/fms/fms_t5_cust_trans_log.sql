-- crmdm.fms_t5_cust_trans_log 定义

-- Drop table

-- DROP TABLE crmdm.fms_t5_cust_trans_log;

CREATE TABLE crmdm.fms_t5_cust_trans_log (
	trans_serno varchar(32) NOT NULL, -- 交易流水号
	sys_mbt varchar(6) NULL, -- 交易编码
	busi_code varchar(6) NOT NULL, -- 业务代码
	channel_flag varchar(3) NOT NULL, -- 渠道标识
	channel_date bpchar(8) NULL, -- 渠道日期
	channel_time bpchar(6) NULL, -- 渠道时间
	channel_serno varchar(32) NULL, -- 渠道流水号
	macdate bpchar(8) NOT NULL, -- 机器日期
	mactime bpchar(6) NOT NULL, -- 机器时间
	bank_code varchar(20) NOT NULL, -- 交易总行代码
	branch_code varchar(20) NOT NULL, -- 交易分行代码
	sub_branch_code varchar(20) NOT NULL, -- 支行网点代码
	inputuser varchar(20) NOT NULL, -- 录入柜员
	checkuser varchar(20) NULL, -- 复核用户
	grantuser varchar(20) NULL, -- 授权用户
	distributor_code varchar(14) NULL, -- 销售商代码
	acct_no varchar(32) NULL, -- 银行账号
	sub_acct_no varchar(32) NULL, -- 子银行账号
	match_acct_no varchar(32) NULL, -- 对手银行账号
	cust_no varchar(20) NULL, -- 客户号
	fnc_trans_acct_no varchar(17) NULL, -- 理财交易账号
	self_fnc_acct_no varchar(12) NULL, -- 自有理财业务账号
	cust_name varchar(128) NULL, -- 客户名称
	id_type varchar(8) NULL, -- 证件类型
	id_code varchar(32) NULL, -- 证件号码
	host_id_type varchar(8) NULL, -- 主机证件类型;（;0：身份证 1：护照 2：军官证 3：士兵证 4：回乡证 5：户口本 6：外国护照 7：其它 8：无 A：技术监督局代码 B：营业执照 C：行政机关 D：社会团体 E；军队 F：武警 G：下属机构（具有主管单位批文号） H：基金会 ）
	cust_type varchar(8) NULL, -- 客户类型
	cust_level varchar(8) NULL, -- 客户级别
	agent_name varchar(128) NULL, -- 经办(代理)人姓名
	agent_id_type varchar(8) NULL, -- 经办(代理)人证件类型
	agent_id_code varchar(32) NULL, -- 经办(代理)人证件号码
	risk_match_flag varchar(1) NULL, -- 是否匹配风险评估;（;Y：是 N：否 ）
	cust_risk_level varchar(1) NULL, -- 客户风险等级;（;0：极低 1：低 2：中 3：高 4：极高 ）
	prod_risk_level varchar(1) NULL, -- 产品风险等级;（;0：极低 1：低 2：中 3：高 4：极高 ）
	prod_code varchar(32) NOT NULL, -- 产品代码
	prod_child_no numeric(8) NULL, -- 产品子序号;（新建产品信息一律填0;滚存型自动增加）
	nav numeric(12, 6) NULL, -- 净值
	cur varchar(8) NULL, -- 币种
	app_amt numeric(16, 2) NULL, -- 申请金额
	app_vol numeric(16, 2) NULL, -- 申请份额
	ack_amt numeric(16, 2) NULL, -- 确认金额
	ack_vol numeric(16, 2) NULL, -- 确认份额
	discount numeric(7, 4) NULL, -- 折扣率
	feeamt numeric(16, 2) NULL, -- 手续费金额
	back_fee numeric(16, 2) NULL, -- 后收手续费
	redeem_fee numeric(16, 2) NULL, -- 赎回费
	interest numeric(16, 2) NULL, -- 利息
	interest_tax numeric(16, 2) NULL, -- 利息税;(扣款模式下由本系统计息时使用)
	cust_manager varchar(20) NULL, -- 客户经理代码
	fm_manager varchar(20) NULL, -- 理财经理代码
	ori_trans_serno varchar(32) NULL, -- 原交易流水号
	frozen_cause varchar(1) NULL, -- 冻结原因;（0：司法冻结1：质押）
	contract_no varchar(32) NULL, -- 文案号
	elisor_name varchar(128) NULL, -- 司法名称
	frozen_enddate bpchar(8) NULL, -- 冻结截止日期
	ori_div_method varchar(1) NULL, -- 原分红方式
	div_method varchar(1) NULL, -- 分红方式
	haeres_deposit_acct varchar(32) NULL, -- 承接方银行结算账号
	buyplan_no varchar(16) NULL, -- 自动理财协议号
	should_exec_date bpchar(8) NULL, -- 应执行日期
	ack_date bpchar(8) NULL, -- 确认日期
	trans_date bpchar(8) NOT NULL, -- 业务日期
	capital_status varchar(1) NOT NULL, -- 资金状态;（0、未处理1、已冻结2、冻结失败3、扣款成功4、扣款失败5、已冲正6、还款成功7、还款失败8、已解冻9、解冻失败A、冲正失败）
	trans_status varchar(1) NOT NULL, -- 交易状态;（U-未处理;B-核心超时;0-申请成功;1-申请失败;2-已撤单;3-确认成功;4-确认失败）
	rtn_code varchar(12) NULL, -- 返回编码
	rtn_desc varchar(255) NULL, -- 返回信息
	host_code varchar(12) NULL, -- 主机返回码
	host_desc varchar(255) NULL, -- 主机返回信息
	host_trans_serno varchar(32) NULL, -- 主机流水号
	freeze_serno varchar(32) NULL, -- 冻结编号（主机）
	chk_status varchar(1) NOT NULL, -- 对账状态;(0-未对账；1-对账相符；2-对账不符；3-已调账；N-不需要对账)
	chk_date bpchar(8) NULL, -- 对账日期
	cert_serno bpchar(8) NULL, -- 凭证序号
	print_no numeric(8) NOT NULL, -- 打印次数;（0表示未打印）
	remark varchar(255) NULL, -- 备注
	upd_date bpchar(8) NOT NULL, -- 更新日期
	upd_time bpchar(6) NOT NULL, -- 更新时间
	card_type varchar(8) NULL, -- 介质类型
	card_no varchar(32) NULL, -- 介质号码
	in_card_type varchar(8) NULL, -- 转入方介质类型
	in_card_no varchar(32) NULL, -- 转入方介质号
	in_acct_no varchar(32) NULL, -- 转入方账号
	in_agent_name varchar(128) NULL, -- 转入方经办人名称
	in_agent_id_type varchar(8) NULL, -- 转入方经办人证件类型
	in_agent_id_code varchar(32) NULL, -- 转入方经办人证件号码
	in_cust_name varchar(128) NULL, -- 转入方客户名称
	in_id_type varchar(8) NULL, -- 输入方证件类型
	in_id_code varchar(32) NULL, -- 输入方证件号码
	trans_deal_ip varchar(128) NULL, -- 交易处理ip
	channel_ip varchar(128) NULL, -- 渠道IP
	channel_mac varchar(64) NULL, -- 渠道mac
	new_cust_flag varchar(1) NULL, -- 新客标识;（0：新客;1：老客）
	recomm_ppl varchar(15) NULL, -- 直销推荐人
	special_code varchar(8) NULL, -- 尊享码标识;（0..无;1..尊享码客户）
	fund_mode varchar(1) NULL, -- 资金处理模式
	hugeredeemflag varchar(1) NULL, -- 巨额赎回处理标志;:0-取消;1-顺延
	host_date bpchar(8) NULL, -- 主机交易日期
	busi_type varchar(1) NULL, -- 业务类型;:0-还款;1-扣款;2-冻结;3-解冻;4-解冻并扣款;5-冲正
	backup_date bpchar(8) NULL, -- 备份日期
	income numeric(16, 2) NULL, -- 收益
	ryzd varchar(1) NULL,
	CONSTRAINT pk_fms_t5_cust_trans_log PRIMARY KEY (trans_serno)
);
CREATE INDEX fms_t5_cust_trans_log_idx01 ON crmdm.fms_t5_cust_trans_log USING btree (cust_no);
CREATE INDEX fms_t5_cust_trans_log_idx02 ON crmdm.fms_t5_cust_trans_log USING btree (macdate);
CREATE INDEX fms_t5_cust_trans_log_idx03 ON crmdm.fms_t5_cust_trans_log USING btree (prod_code);
COMMENT ON TABLE crmdm.fms_t5_cust_trans_log IS '客户交易流水表';

-- Column comments

COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.trans_serno IS '交易流水号';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.sys_mbt IS '交易编码';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.busi_code IS '业务代码';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.channel_flag IS '渠道标识';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.channel_date IS '渠道日期';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.channel_time IS '渠道时间';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.channel_serno IS '渠道流水号';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.macdate IS '机器日期';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.mactime IS '机器时间';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.bank_code IS '交易总行代码';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.branch_code IS '交易分行代码';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.sub_branch_code IS '支行网点代码';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.inputuser IS '录入柜员';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.checkuser IS '复核用户';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.grantuser IS '授权用户';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.distributor_code IS '销售商代码';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.acct_no IS '银行账号';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.sub_acct_no IS '子银行账号';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.match_acct_no IS '对手银行账号';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.cust_no IS '客户号';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.fnc_trans_acct_no IS '理财交易账号';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.self_fnc_acct_no IS '自有理财业务账号';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.cust_name IS '客户名称';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.id_type IS '证件类型';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.id_code IS '证件号码';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.host_id_type IS '主机证件类型;（;0：身份证 1：护照 2：军官证 3：士兵证 4：回乡证 5：户口本 6：外国护照 7：其它 8：无 A：技术监督局代码 B：营业执照 C：行政机关 D：社会团体 E；军队 F：武警 G：下属机构（具有主管单位批文号） H：基金会 ）';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.cust_type IS '客户类型';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.cust_level IS '客户级别';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.agent_name IS '经办(代理)人姓名';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.agent_id_type IS '经办(代理)人证件类型';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.agent_id_code IS '经办(代理)人证件号码';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.risk_match_flag IS '是否匹配风险评估;（;Y：是 N：否 ）';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.cust_risk_level IS '客户风险等级;（;0：极低 1：低 2：中 3：高 4：极高 ）';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.prod_risk_level IS '产品风险等级;（;0：极低 1：低 2：中 3：高 4：极高 ）';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.prod_code IS '产品代码';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.prod_child_no IS '产品子序号;（新建产品信息一律填0;滚存型自动增加）';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.nav IS '净值';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.cur IS '币种';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.app_amt IS '申请金额';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.app_vol IS '申请份额';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.ack_amt IS '确认金额';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.ack_vol IS '确认份额';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.discount IS '折扣率';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.feeamt IS '手续费金额';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.back_fee IS '后收手续费';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.redeem_fee IS '赎回费';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.interest IS '利息';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.interest_tax IS '利息税;(扣款模式下由本系统计息时使用)';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.cust_manager IS '客户经理代码';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.fm_manager IS '理财经理代码';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.ori_trans_serno IS '原交易流水号';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.frozen_cause IS '冻结原因;（0：司法冻结1：质押）';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.contract_no IS '文案号';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.elisor_name IS '司法名称';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.frozen_enddate IS '冻结截止日期';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.ori_div_method IS '原分红方式';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.div_method IS '分红方式';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.haeres_deposit_acct IS '承接方银行结算账号';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.buyplan_no IS '自动理财协议号';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.should_exec_date IS '应执行日期';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.ack_date IS '确认日期';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.trans_date IS '业务日期';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.capital_status IS '资金状态;（0、未处理1、已冻结2、冻结失败3、扣款成功4、扣款失败5、已冲正6、还款成功7、还款失败8、已解冻9、解冻失败A、冲正失败）';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.trans_status IS '交易状态;（U-未处理;B-核心超时;0-申请成功;1-申请失败;2-已撤单;3-确认成功;4-确认失败）';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.rtn_code IS '返回编码';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.rtn_desc IS '返回信息';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.host_code IS '主机返回码';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.host_desc IS '主机返回信息';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.host_trans_serno IS '主机流水号';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.freeze_serno IS '冻结编号（主机）';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.chk_status IS '对账状态;(0-未对账；1-对账相符；2-对账不符；3-已调账；N-不需要对账)';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.chk_date IS '对账日期';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.cert_serno IS '凭证序号';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.print_no IS '打印次数;（0表示未打印）';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.remark IS '备注';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.upd_date IS '更新日期';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.upd_time IS '更新时间';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.card_type IS '介质类型';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.card_no IS '介质号码';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.in_card_type IS '转入方介质类型';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.in_card_no IS '转入方介质号';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.in_acct_no IS '转入方账号';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.in_agent_name IS '转入方经办人名称';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.in_agent_id_type IS '转入方经办人证件类型';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.in_agent_id_code IS '转入方经办人证件号码';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.in_cust_name IS '转入方客户名称';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.in_id_type IS '输入方证件类型';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.in_id_code IS '输入方证件号码';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.trans_deal_ip IS '交易处理ip';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.channel_ip IS '渠道IP';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.channel_mac IS '渠道mac';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.new_cust_flag IS '新客标识;（0：新客;1：老客）';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.recomm_ppl IS '直销推荐人';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.special_code IS '尊享码标识;（0..无;1..尊享码客户）';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.fund_mode IS '资金处理模式';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.hugeredeemflag IS '巨额赎回处理标志;:0-取消;1-顺延';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.host_date IS '主机交易日期';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.busi_type IS '业务类型;:0-还款;1-扣款;2-冻结;3-解冻;4-解冻并扣款;5-冲正';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.backup_date IS '备份日期';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.income IS '收益';
