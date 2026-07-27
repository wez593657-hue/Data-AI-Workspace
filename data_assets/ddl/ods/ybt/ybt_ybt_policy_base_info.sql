-- crmdm.ybt_ybt_policy_base_info 定义

-- Drop table

-- DROP TABLE crmdm.ybt_ybt_policy_base_info;

CREATE TABLE crmdm.ybt_ybt_policy_base_info (
	plat_policy_serial varchar(200) NOT NULL, -- 保单平台流水号
	item_id varchar(40) NOT NULL, -- 中间业务缴费项目编号
	is_real varchar(8) NOT NULL, -- 是否是非实时出单:0：是 1：否
	cont_no varchar(200) NULL, -- 保险单号
	proposal_prt_no varchar(200) NOT NULL, -- 投保单号
	cont_prt_no varchar(200) NULL, -- 保单合同印刷号
	accept_date varchar(32) NOT NULL, -- 投保日期(yyyyMMdd )
	appointvali_date varchar(32) NULL, -- 保单预约生效日期(yyyyMMdd )
	vali_date varchar(32) NULL, -- 保单实际生效日期(yyyyMMdd )
	insuend_date varchar(32) NULL, -- 保单满期日期(yyyyMMdd )
	pay_start_date varchar(32) NULL, -- 保单首期缴费日期(yyyyMMdd )
	payend_date varchar(32) NULL, -- 保单缴费满期日期(yyyyMMdd )
	product_id varchar(200) NOT NULL, -- 投保产品Id
	product_name varchar(800) NOT NULL, -- 投保产品名称
	cont_status varchar(8) NOT NULL, -- 保单状态:0：未生效 1：正常（新单承保、正常续期中） 2：失效（当日撤单，犹豫期退保、犹豫期外退保、满期给付、理赔终止、其他终止）
	cont_source varchar(8) NOT NULL, -- 保单来源 :0：柜面 1：手机银行
	risk_grade varchar(8) NOT NULL, -- 最高可承受风险等级：1：极低 2：低 3：中 4：高 5：极高
	commission_type varchar(8) NOT NULL, -- 承保手续费收取方式：0:不涉及 1:按保额收取 2:按保费收取
	commission_ratio numeric(6, 3) NULL, -- 手续费比例(% )
	commissionamt numeric(17, 2) NULL, -- 保单承保手续费
	acc_name varchar(200) NOT NULL, -- 账户姓名
	acc_no varchar(200) NOT NULL, -- 银行账户
	get_pol_mode varchar(8) NULL, -- 保单递送方式：1:邮寄 2:柜面领取 3:上门递送 4:电子保单（针对电子渠道：网银、手机银行、自助终端等） 5:部门发送
	throw_com varchar(200) NOT NULL, -- 投保网点代码
	throw_com_name varchar(800) NULL, -- 投保网点名称
	throw_com_certi_code varchar(200) NULL, -- 投保网点许可证
	teller_name varchar(800) NULL, -- 投保销售人员姓名
	teller_id varchar(80) NULL, -- 投保销售人员工号
	teller_certi_code varchar(200) NULL, -- 投保销售人员资格证
	teller_email varchar(200) NULL, -- 投保销售人员电子邮箱
	manager_no varchar(200) NULL, -- 投保网点分管代理保险负责人工号
	manager_name varchar(800) NULL, -- 投保网点分管代理保险负责人姓名
	agent_code varchar(200) NULL, -- 代理人编码
	agent_name varchar(800) NULL, -- 代理人姓名
	agent_grp_code varchar(200) NULL, -- 代理人组别编码
	agent_grp_name varchar(200) NULL, -- 代理人组别
	agent_com varchar(200) NULL, -- 代理网点编码
	agent_com_name varchar(800) NULL, -- 代理网点名称
	com_code varchar(200) NULL, -- 代理机构编码
	com_location varchar(800) NULL, -- 承保公司地址
	com_name varchar(800) NULL, -- 承保公司名称
	com_zip_code varchar(200) NULL, -- 承保公司邮编
	com_phone varchar(80) NULL, -- 保险公司热线
	job_notice varchar(8) NULL, -- 职业告知(是否从事风险置业): Y-是,N-否
	health_notice varchar(8) NULL, -- 健康告知(是否存在健康风险): Y-是,N-否
	policy_indicator varchar(8) NULL, -- 未成年被保险人在其他保险公司是否有投保Y-有，N-无
	total_faceamount numeric(17, 2) NULL, -- 未成年被保险人在其他保险公司累计投保身故保额
	hesitate_end_date varchar(32) NULL, -- 保单犹豫期结束日期
	acc_transfer_num varchar(200) NULL, -- 客户转账授权码
	acc_eff_date varchar(8) NULL, -- 客户银行卡有效日期
	quality_status varchar(2) NULL, -- 双录状态 0-未检查，1-合规，2-待整改，3-已整改待确认，4-已整改确认，99-新建，1-作废
	session_id varchar(800) NULL, -- 保单可回溯SessionId值
	plat_date varchar(8) NULL, -- 平台日期(yyyyMMdd)
	plat_time varchar(6) NULL, -- 平台时间(HHmmss)
	record_no varchar(256) NULL, -- 双录系统流水号
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_ybt_ybt_policy_base_info PRIMARY KEY (plat_policy_serial)
);

-- Column comments

COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.plat_policy_serial IS '保单平台流水号';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.item_id IS '中间业务缴费项目编号';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.is_real IS '是否是非实时出单:0：是 1：否';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.cont_no IS '保险单号';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.proposal_prt_no IS '投保单号';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.cont_prt_no IS '保单合同印刷号';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.accept_date IS '投保日期(yyyyMMdd )';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.appointvali_date IS '保单预约生效日期(yyyyMMdd )';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.vali_date IS '保单实际生效日期(yyyyMMdd )';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.insuend_date IS '保单满期日期(yyyyMMdd )';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.pay_start_date IS '保单首期缴费日期(yyyyMMdd )';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.payend_date IS '保单缴费满期日期(yyyyMMdd )';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.product_id IS '投保产品Id';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.product_name IS '投保产品名称';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.cont_status IS '保单状态:0：未生效 1：正常（新单承保、正常续期中） 2：失效（当日撤单，犹豫期退保、犹豫期外退保、满期给付、理赔终止、其他终止）';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.cont_source IS '保单来源 :0：柜面 1：手机银行';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.risk_grade IS '最高可承受风险等级：1：极低 2：低 3：中 4：高 5：极高';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.commission_type IS '承保手续费收取方式：0:不涉及 1:按保额收取 2:按保费收取';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.commission_ratio IS '手续费比例(% )';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.commissionamt IS '保单承保手续费';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.acc_name IS '账户姓名';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.acc_no IS '银行账户';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.get_pol_mode IS '保单递送方式：1:邮寄 2:柜面领取 3:上门递送 4:电子保单（针对电子渠道：网银、手机银行、自助终端等） 5:部门发送';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.throw_com IS '投保网点代码';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.throw_com_name IS '投保网点名称';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.throw_com_certi_code IS '投保网点许可证';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.teller_name IS '投保销售人员姓名';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.teller_id IS '投保销售人员工号';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.teller_certi_code IS '投保销售人员资格证';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.teller_email IS '投保销售人员电子邮箱';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.manager_no IS '投保网点分管代理保险负责人工号';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.manager_name IS '投保网点分管代理保险负责人姓名';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.agent_code IS '代理人编码';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.agent_name IS '代理人姓名';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.agent_grp_code IS '代理人组别编码';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.agent_grp_name IS '代理人组别';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.agent_com IS '代理网点编码';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.agent_com_name IS '代理网点名称';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.com_code IS '代理机构编码';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.com_location IS '承保公司地址';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.com_name IS '承保公司名称';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.com_zip_code IS '承保公司邮编';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.com_phone IS '保险公司热线';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.job_notice IS '职业告知(是否从事风险置业): Y-是,N-否';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.health_notice IS '健康告知(是否存在健康风险): Y-是,N-否';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.policy_indicator IS '未成年被保险人在其他保险公司是否有投保Y-有，N-无';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.total_faceamount IS '未成年被保险人在其他保险公司累计投保身故保额';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.hesitate_end_date IS '保单犹豫期结束日期';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.acc_transfer_num IS '客户转账授权码';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.acc_eff_date IS '客户银行卡有效日期';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.quality_status IS '双录状态 0-未检查，1-合规，2-待整改，3-已整改待确认，4-已整改确认，99-新建，1-作废';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.session_id IS '保单可回溯SessionId值';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.plat_date IS '平台日期(yyyyMMdd)';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.plat_time IS '平台时间(HHmmss)';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.record_no IS '双录系统流水号';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.ryzd IS '冗余字段';
