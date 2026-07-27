-- crmdm.cms_customer_info 定义

-- Drop table

-- DROP TABLE crmdm.cms_customer_info;

CREATE TABLE crmdm.cms_customer_info (
	customerid varchar(40) NOT NULL, -- 客户编号
	customername varchar(80) NULL, -- 客户名称
	customertype varchar(20) NULL, -- 客户类型
	certtype varchar(20) NULL, -- 证件类型
	certid varchar(40) NULL, -- 证据号
	customerpassword varchar(20) NULL, -- 客户口令
	inputorgid varchar(32) NULL, -- 登记机构
	inputuserid varchar(32) NULL, -- 登记人
	inputdate varchar(10) NULL, -- 登记日期
	remark varchar(250) NULL, -- 备注
	mfcustomerid varchar(40) NULL, -- 核心客户号
	status varchar(20) NULL, -- 认定状态
	belonggroupid varchar(40) NULL, -- 所属集团编号
	channel varchar(18) NULL, -- 来源渠道
	loancardno varchar(32) NULL, -- 贷款卡编号
	customerscale varchar(20) NULL, -- 客户规模（区分中小企业）
	nationcode varchar(40) NULL, -- 证件国别
	forbidstatus varchar(12) NULL, -- 状态
	counterpartytype varchar(10) NULL, -- 交易对手类型
	taxpayertype varchar(10) NULL, -- 纳税人类型
	mystocker varchar(10) NULL, -- 是否我行股东
	oldmfcustomerid varchar(40) NULL, -- 老核心客户号
	isrelacustomer varchar(10) NULL, -- 是否我行关联方
	custriskleve varchar(10) NULL, -- 客户预警等级
	checkbasedate varchar(10) NULL, -- 定期检查基准日
	creditsum numeric(24, 4) NULL, -- 授信金额
	classifyresult varchar(200) NULL, -- 客户风险分类
	linetype varchar(32) NULL, -- 客户条线
	titularsum2 numeric(24, 4) NULL, -- 非传统授信金额
	titularsum1 numeric(24, 4) NULL, -- 传统授信金额
	nominalcreditsum numeric(24, 4) NULL, -- 客户名义授信总额
	nominalcreditbalance numeric(24, 4) NULL, -- 客户名义授信余额
	exposurecreditsum numeric(24, 4) NULL, -- 客户敞口授信总额
	exposurecreditbalance numeric(24, 4) NULL, -- 客户敞口授信余额
	smesystemflag varchar(4) NULL, -- 系统认定条线Codeno：SMESystemFlag
	finalsmeflag varchar(4) NULL, -- 最终认定条线Codeno：SMESystemFlag
	checkbaseriskdate varchar(20) NULL, -- CHECKBASERISKDATE
	onemtotenmflag varchar(10) NULL, -- 单户名义金额在百万至千万间标志
	onemtotenmtime varchar(40) NULL, -- 单户名义金额在百万至千万间判断的时间
	morethantenmflag varchar(10) NULL, -- 单户名义金额大于千万标志
	morethantenmtime varchar(40) NULL, -- 单户名义金额大于千万判断的时间
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_cms_customer_info PRIMARY KEY (customerid)
);

-- Column comments

COMMENT ON COLUMN crmdm.cms_customer_info.customerid IS '客户编号                ';
COMMENT ON COLUMN crmdm.cms_customer_info.customername IS '客户名称                ';
COMMENT ON COLUMN crmdm.cms_customer_info.customertype IS '客户类型                ';
COMMENT ON COLUMN crmdm.cms_customer_info.certtype IS '证件类型                ';
COMMENT ON COLUMN crmdm.cms_customer_info.certid IS '证据号                  ';
COMMENT ON COLUMN crmdm.cms_customer_info.customerpassword IS '客户口令                ';
COMMENT ON COLUMN crmdm.cms_customer_info.inputorgid IS '登记机构                ';
COMMENT ON COLUMN crmdm.cms_customer_info.inputuserid IS '登记人                  ';
COMMENT ON COLUMN crmdm.cms_customer_info.inputdate IS '登记日期                ';
COMMENT ON COLUMN crmdm.cms_customer_info.remark IS '备注                    ';
COMMENT ON COLUMN crmdm.cms_customer_info.mfcustomerid IS '核心客户号              ';
COMMENT ON COLUMN crmdm.cms_customer_info.status IS '认定状态                ';
COMMENT ON COLUMN crmdm.cms_customer_info.belonggroupid IS '所属集团编号            ';
COMMENT ON COLUMN crmdm.cms_customer_info.channel IS '来源渠道                ';
COMMENT ON COLUMN crmdm.cms_customer_info.loancardno IS '贷款卡编号              ';
COMMENT ON COLUMN crmdm.cms_customer_info.customerscale IS '客户规模（区分中小企业）';
COMMENT ON COLUMN crmdm.cms_customer_info.nationcode IS '证件国别                ';
COMMENT ON COLUMN crmdm.cms_customer_info.forbidstatus IS '状态                    ';
COMMENT ON COLUMN crmdm.cms_customer_info.counterpartytype IS '交易对手类型            ';
COMMENT ON COLUMN crmdm.cms_customer_info.taxpayertype IS '纳税人类型              ';
COMMENT ON COLUMN crmdm.cms_customer_info.mystocker IS '是否我行股东            ';
COMMENT ON COLUMN crmdm.cms_customer_info.oldmfcustomerid IS '老核心客户号            ';
COMMENT ON COLUMN crmdm.cms_customer_info.isrelacustomer IS '是否我行关联方          ';
COMMENT ON COLUMN crmdm.cms_customer_info.custriskleve IS '客户预警等级            ';
COMMENT ON COLUMN crmdm.cms_customer_info.checkbasedate IS '定期检查基准日          ';
COMMENT ON COLUMN crmdm.cms_customer_info.creditsum IS '授信金额                ';
COMMENT ON COLUMN crmdm.cms_customer_info.classifyresult IS '客户风险分类            ';
COMMENT ON COLUMN crmdm.cms_customer_info.linetype IS '客户条线                ';
COMMENT ON COLUMN crmdm.cms_customer_info.titularsum2 IS '非传统授信金额          ';
COMMENT ON COLUMN crmdm.cms_customer_info.titularsum1 IS '传统授信金额            ';
COMMENT ON COLUMN crmdm.cms_customer_info.nominalcreditsum IS '客户名义授信总额        ';
COMMENT ON COLUMN crmdm.cms_customer_info.nominalcreditbalance IS '客户名义授信余额        ';
COMMENT ON COLUMN crmdm.cms_customer_info.exposurecreditsum IS '客户敞口授信总额        ';
COMMENT ON COLUMN crmdm.cms_customer_info.exposurecreditbalance IS '客户敞口授信余额        ';
COMMENT ON COLUMN crmdm.cms_customer_info.smesystemflag IS '系统认定条线Codeno：SMESystemFlag';
COMMENT ON COLUMN crmdm.cms_customer_info.finalsmeflag IS '最终认定条线Codeno：SMESystemFlag';
COMMENT ON COLUMN crmdm.cms_customer_info.checkbaseriskdate IS 'CHECKBASERISKDATE';
COMMENT ON COLUMN crmdm.cms_customer_info.onemtotenmflag IS '单户名义金额在百万至千万间标志';
COMMENT ON COLUMN crmdm.cms_customer_info.onemtotenmtime IS '单户名义金额在百万至千万间判断的时间';
COMMENT ON COLUMN crmdm.cms_customer_info.morethantenmflag IS '单户名义金额大于千万标志';
COMMENT ON COLUMN crmdm.cms_customer_info.morethantenmtime IS '单户名义金额大于千万判断的时间';
COMMENT ON COLUMN crmdm.cms_customer_info.ryzd IS '冗余字段';
