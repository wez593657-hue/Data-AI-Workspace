-- crmdm.cms_acct_loan 定义

-- Drop table

-- DROP TABLE crmdm.cms_acct_loan;

CREATE TABLE crmdm.cms_acct_loan (
	serialno varchar(40) NOT NULL, -- 贷款账号
	accountno varchar(40) NULL, -- 贷款文本账号
	contractserialno varchar(40) NULL, -- 关联合同号
	customerid varchar(40) NULL, -- 客户编号
	customername varchar(80) NULL, -- 客户名称
	businesstype varchar(40) NULL, -- 业务品种
	productid varchar(40) NULL, -- 产品编号
	specificid varchar(40) NULL, -- 特殊账户编号
	versionid varchar(40) NULL, -- 版本编号
	currency varchar(10) NULL, -- 币种
	businesssum numeric(24, 2) NULL, -- 贷款金额
	putoutdate varchar(10) NULL, -- 贷款发放日期
	maturitydate varchar(10) NULL, -- 贷款到期日
	originalmaturitydate varchar(10) NULL, -- 贷款原始到期日
	operateorgid varchar(40) NULL, -- 经办行号（用做异地支行标识）
	accountingorgid varchar(32) NULL, -- 贷款入账机构
	loanstatus varchar(10) NULL, -- 贷款状态
	finishdate varchar(10) NULL, -- 结清日期
	businessdate varchar(10) NULL, -- 贷款处理日期
	lockflag varchar(10) NULL, -- 锁定标识
	overduedays numeric NULL, -- 逾期天数
	classifyresult varchar(10) NULL, -- 分类结果
	putoutserialno varchar(40) NULL, -- 出账流水号
	approveserialno varchar(40) NULL, -- 审批流水号
	applyserialno varchar(40) NULL, -- 申请流水号
	businessstatus varchar(10) NULL, -- 业务状态
	maxoverduedays numeric NULL, -- 最大逾期天数
	normalbalance numeric(24, 2) NULL, -- 正常本金余额
	overduebalance numeric(24, 2) NULL, -- 逾期本金
	accruedinterest numeric(24, 2) NULL, -- 计提利息
	overdueinterest numeric(24, 2) NULL, -- 逾期利息
	principalpenalty numeric(24, 2) NULL, -- 本金罚息
	interestpenalty numeric(24, 2) NULL, -- 利息罚息
	overduefee numeric(24, 2) NULL, -- 逾期费用
	impairmentflag varchar(10) NULL, -- 减值状态
	graceinteestamt numeric(24, 2) NULL, -- 宽限期利息
	loanratetermid varchar(20) NULL, -- 贷款利率功能组件编号
	gracedays numeric NULL, -- 逾期宽限期天数
	currentrpttermid varchar(32) NULL, -- 当前时点还款方式
	batchno varchar(10) NULL, -- 批扣组号
	occurtype varchar(10) NULL, -- 是否垫款标识
	vouchtype varchar(18) NULL, -- 担保方式
	businessloantype varchar(20) NULL, -- 贷款类型
	lastdaynormalbalance numeric(24, 2) NULL, -- 上日正常本金余额
	lastdayoverduebalance numeric(24, 2) NULL, -- 上日逾期本金余额
	lastdayaccruedinterest numeric(24, 2) NULL, -- 上日计提利息
	lastdayoverdueinterest numeric(24, 2) NULL, -- 上日逾期利息
	lastdayprincipalpenalty numeric(24, 2) NULL, -- 上日本金罚息
	lastdayinterestpenalty numeric(24, 2) NULL, -- 上日利息罚息
	lastdayoverduefee numeric(24, 2) NULL, -- 上日欠费金额
	dongjbho varchar(40) NULL, -- 冻结编号
	corpuspaymethod varchar(20) NULL, -- 还款方式
	autopayflag varchar(20) NULL, -- 批量扣款标识
	nextduedate varchar(20) NULL, -- 下次还款日
	lcatimes numeric(22) NULL, -- 逾期次数
	guaranteeway varchar(18) NULL, -- 担保方式（科目映射使用）
	basebusinesstype varchar(18) NULL, -- 基础产品
	accountflag varchar(10) NULL, -- 科目特殊映射标识
	gjflag varchar(18) NULL, -- 国结标识
	dutyfreecode varchar(2) NULL, -- 免税标识
	batchflag varchar(10) NULL, -- 批量执行标识
	yzflag varchar(2) NULL, -- 移植标识
	iswriteoffaccrualflag varchar(2) NULL, -- 核销后是否计息标志(YesNo)
	loanwriteofftype varchar(10) NULL, -- 核销类型（01-核销（继续清收）；02-核销结清（清收完成））
	xwmsswitchstatus varchar(10) NULL, -- 小微免税考核开关状态
	intpaymode varchar(2) NULL, -- 利息支付方式(码值IntPayMode: 1-核心企业付息; 2-融资申请人付息)
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_cms_acct_loan PRIMARY KEY (serialno)
);
CREATE UNIQUE INDEX pk_acct_loan ON crmdm.cms_acct_loan USING btree (serialno);

-- Column comments

COMMENT ON COLUMN crmdm.cms_acct_loan.serialno IS '贷款账号                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.accountno IS '贷款文本账号                ';
COMMENT ON COLUMN crmdm.cms_acct_loan.contractserialno IS '关联合同号                  ';
COMMENT ON COLUMN crmdm.cms_acct_loan.customerid IS '客户编号                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.customername IS '客户名称                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.businesstype IS '业务品种                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.productid IS '产品编号                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.specificid IS '特殊账户编号                ';
COMMENT ON COLUMN crmdm.cms_acct_loan.versionid IS '版本编号                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.currency IS '币种                        ';
COMMENT ON COLUMN crmdm.cms_acct_loan.businesssum IS '贷款金额                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.putoutdate IS '贷款发放日期                ';
COMMENT ON COLUMN crmdm.cms_acct_loan.maturitydate IS '贷款到期日                  ';
COMMENT ON COLUMN crmdm.cms_acct_loan.originalmaturitydate IS '贷款原始到期日              ';
COMMENT ON COLUMN crmdm.cms_acct_loan.operateorgid IS '经办行号（用做异地支行标识）';
COMMENT ON COLUMN crmdm.cms_acct_loan.accountingorgid IS '贷款入账机构                ';
COMMENT ON COLUMN crmdm.cms_acct_loan.loanstatus IS '贷款状态                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.finishdate IS '结清日期                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.businessdate IS '贷款处理日期                ';
COMMENT ON COLUMN crmdm.cms_acct_loan.lockflag IS '锁定标识                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.overduedays IS '逾期天数                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.classifyresult IS '分类结果                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.putoutserialno IS '出账流水号                  ';
COMMENT ON COLUMN crmdm.cms_acct_loan.approveserialno IS '审批流水号                  ';
COMMENT ON COLUMN crmdm.cms_acct_loan.applyserialno IS '申请流水号                  ';
COMMENT ON COLUMN crmdm.cms_acct_loan.businessstatus IS '业务状态                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.maxoverduedays IS '最大逾期天数                ';
COMMENT ON COLUMN crmdm.cms_acct_loan.normalbalance IS '正常本金余额                ';
COMMENT ON COLUMN crmdm.cms_acct_loan.overduebalance IS '逾期本金                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.accruedinterest IS '计提利息                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.overdueinterest IS '逾期利息                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.principalpenalty IS '本金罚息                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.interestpenalty IS '利息罚息                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.overduefee IS '逾期费用                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.impairmentflag IS '减值状态                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.graceinteestamt IS '宽限期利息                  ';
COMMENT ON COLUMN crmdm.cms_acct_loan.loanratetermid IS '贷款利率功能组件编号        ';
COMMENT ON COLUMN crmdm.cms_acct_loan.gracedays IS '逾期宽限期天数              ';
COMMENT ON COLUMN crmdm.cms_acct_loan.currentrpttermid IS '当前时点还款方式            ';
COMMENT ON COLUMN crmdm.cms_acct_loan.batchno IS '批扣组号                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.occurtype IS '是否垫款标识                ';
COMMENT ON COLUMN crmdm.cms_acct_loan.vouchtype IS '担保方式                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.businessloantype IS '贷款类型                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.lastdaynormalbalance IS '上日正常本金余额            ';
COMMENT ON COLUMN crmdm.cms_acct_loan.lastdayoverduebalance IS '上日逾期本金余额            ';
COMMENT ON COLUMN crmdm.cms_acct_loan.lastdayaccruedinterest IS '上日计提利息                ';
COMMENT ON COLUMN crmdm.cms_acct_loan.lastdayoverdueinterest IS '上日逾期利息                ';
COMMENT ON COLUMN crmdm.cms_acct_loan.lastdayprincipalpenalty IS '上日本金罚息                ';
COMMENT ON COLUMN crmdm.cms_acct_loan.lastdayinterestpenalty IS '上日利息罚息                ';
COMMENT ON COLUMN crmdm.cms_acct_loan.lastdayoverduefee IS '上日欠费金额                ';
COMMENT ON COLUMN crmdm.cms_acct_loan.dongjbho IS '冻结编号                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.corpuspaymethod IS '还款方式                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.autopayflag IS '批量扣款标识                ';
COMMENT ON COLUMN crmdm.cms_acct_loan.nextduedate IS '下次还款日                  ';
COMMENT ON COLUMN crmdm.cms_acct_loan.lcatimes IS '逾期次数                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.guaranteeway IS '担保方式（科目映射使用）    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.basebusinesstype IS '基础产品                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.accountflag IS '科目特殊映射标识            ';
COMMENT ON COLUMN crmdm.cms_acct_loan.gjflag IS '国结标识                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.dutyfreecode IS '免税标识                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.batchflag IS '批量执行标识                ';
COMMENT ON COLUMN crmdm.cms_acct_loan.yzflag IS '移植标识                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.iswriteoffaccrualflag IS '核销后是否计息标志(YesNo)';
COMMENT ON COLUMN crmdm.cms_acct_loan.loanwriteofftype IS '核销类型（01-核销（继续清收）；02-核销结清（清收完成））';
COMMENT ON COLUMN crmdm.cms_acct_loan.xwmsswitchstatus IS '小微免税考核开关状态';
COMMENT ON COLUMN crmdm.cms_acct_loan.intpaymode IS '利息支付方式(码值IntPayMode: 1-核心企业付息; 2-融资申请人付息)';
COMMENT ON COLUMN crmdm.cms_acct_loan.ryzd IS '冗余字段';
