-- crmdm.cms_cl_info 定义

-- Drop table

-- DROP TABLE crmdm.cms_cl_info;

CREATE TABLE crmdm.cms_cl_info (
	lineid varchar(32) NULL, -- 额度编号
	cltypeid varchar(32) NULL, -- 额度类型编号
	cltypename varchar(80) NULL, -- 额度类型名称
	applyserialno varchar(32) NULL, -- 申请流水号
	approveserialno varchar(32) NULL, -- 最终审批意见流水号
	bcserialno varchar(32) NULL, -- 合同流水号
	linecontractno varchar(32) NULL, -- 合同编号
	customerid varchar(32) NULL, -- 客户编号
	customername varchar(80) NULL, -- 客户名称
	linesum1 numeric(24, 6) NULL, -- 额度金额
	linesum2 numeric(24, 6) NULL, -- 额度名义金额
	linesum3 numeric(24, 6) NULL, -- 额度敞口金额
	currency varchar(18) NULL, -- 币种
	lineeffdate varchar(10) NULL, -- 生效日
	lineeffflag varchar(1) NULL, -- 是否有效
	putoutdeadline varchar(10) NULL, -- 最后期限
	maturitydeadline varchar(10) NULL, -- 到期日
	rotative varchar(18) NULL, -- 是否循环
	approvalpolicy varchar(18) NULL, -- 审批政策
	freezeflag varchar(1) NULL, -- 是否冻结
	recentcheck varchar(32) NULL, -- 最近检查
	recentcheckstatus varchar(1) NULL, -- 最近检查状态
	checkresult varchar(1) NULL, -- 检查结果
	overflowtype varchar(200) NULL, -- 溢出类型
	inputuser varchar(32) NULL, -- 登记人
	inputorg varchar(32) NULL, -- 登记机构
	inputtime varchar(20) NULL, -- 登记时间
	updatetime varchar(20) NULL, -- 更新时间
	begindate varchar(10) NULL, -- 开始日期
	enddate varchar(10) NULL, -- 结束日期
	parentlineid varchar(32) NULL, -- 父额度编号
	useorgid varchar(32) NULL, -- 使用机构
	useorgname varchar(80) NULL, -- 使用机构名称
	bailratio numeric(10, 6) NULL, -- 保证金比例
	businesstype varchar(32) NULL, -- 业务品种
	usedsum numeric(24, 6) NULL, -- 已用金额
	usablesum numeric(24, 6) NULL, -- 可用金额
	calculatetime varchar(20) NULL -- 计算时间
);
COMMENT ON TABLE crmdm.cms_cl_info IS '额度信息';

-- Column comments

COMMENT ON COLUMN crmdm.cms_cl_info.lineid IS '额度编号';
COMMENT ON COLUMN crmdm.cms_cl_info.cltypeid IS '额度类型编号';
COMMENT ON COLUMN crmdm.cms_cl_info.cltypename IS '额度类型名称';
COMMENT ON COLUMN crmdm.cms_cl_info.applyserialno IS '申请流水号';
COMMENT ON COLUMN crmdm.cms_cl_info.approveserialno IS '最终审批意见流水号';
COMMENT ON COLUMN crmdm.cms_cl_info.bcserialno IS '合同流水号';
COMMENT ON COLUMN crmdm.cms_cl_info.linecontractno IS '合同编号';
COMMENT ON COLUMN crmdm.cms_cl_info.customerid IS '客户编号';
COMMENT ON COLUMN crmdm.cms_cl_info.customername IS '客户名称';
COMMENT ON COLUMN crmdm.cms_cl_info.linesum1 IS '额度金额';
COMMENT ON COLUMN crmdm.cms_cl_info.linesum2 IS '额度名义金额';
COMMENT ON COLUMN crmdm.cms_cl_info.linesum3 IS '额度敞口金额';
COMMENT ON COLUMN crmdm.cms_cl_info.currency IS '币种';
COMMENT ON COLUMN crmdm.cms_cl_info.lineeffdate IS '生效日';
COMMENT ON COLUMN crmdm.cms_cl_info.lineeffflag IS '是否有效';
COMMENT ON COLUMN crmdm.cms_cl_info.putoutdeadline IS '最后期限';
COMMENT ON COLUMN crmdm.cms_cl_info.maturitydeadline IS '到期日';
COMMENT ON COLUMN crmdm.cms_cl_info.rotative IS '是否循环';
COMMENT ON COLUMN crmdm.cms_cl_info.approvalpolicy IS '审批政策';
COMMENT ON COLUMN crmdm.cms_cl_info.freezeflag IS '是否冻结';
COMMENT ON COLUMN crmdm.cms_cl_info.recentcheck IS '最近检查';
COMMENT ON COLUMN crmdm.cms_cl_info.recentcheckstatus IS '最近检查状态';
COMMENT ON COLUMN crmdm.cms_cl_info.checkresult IS '检查结果';
COMMENT ON COLUMN crmdm.cms_cl_info.overflowtype IS '溢出类型';
COMMENT ON COLUMN crmdm.cms_cl_info.inputuser IS '登记人';
COMMENT ON COLUMN crmdm.cms_cl_info.inputorg IS '登记机构';
COMMENT ON COLUMN crmdm.cms_cl_info.inputtime IS '登记时间';
COMMENT ON COLUMN crmdm.cms_cl_info.updatetime IS '更新时间';
COMMENT ON COLUMN crmdm.cms_cl_info.begindate IS '开始日期';
COMMENT ON COLUMN crmdm.cms_cl_info.enddate IS '结束日期';
COMMENT ON COLUMN crmdm.cms_cl_info.parentlineid IS '父额度编号';
COMMENT ON COLUMN crmdm.cms_cl_info.useorgid IS '使用机构';
COMMENT ON COLUMN crmdm.cms_cl_info.useorgname IS '使用机构名称';
COMMENT ON COLUMN crmdm.cms_cl_info.bailratio IS '保证金比例';
COMMENT ON COLUMN crmdm.cms_cl_info.businesstype IS '业务品种';
COMMENT ON COLUMN crmdm.cms_cl_info.usedsum IS '已用金额';
COMMENT ON COLUMN crmdm.cms_cl_info.usablesum IS '可用金额';
COMMENT ON COLUMN crmdm.cms_cl_info.calculatetime IS '计算时间';
