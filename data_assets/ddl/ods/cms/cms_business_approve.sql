-- crmdm.cms_business_approve 定义

-- Drop table

-- DROP TABLE crmdm.cms_business_approve;

CREATE TABLE crmdm.cms_business_approve (
	serialno varchar(32) NOT NULL, -- 流水号字段
	relativeserialno varchar(40) NULL, -- 关联流水号字段
	occurdate varchar(10) NULL, -- 发生日期
	customerid varchar(32) NULL, -- 客户编号
	customername varchar(120) NULL, -- 客户名称
	businesstype varchar(18) NULL, -- 业务品种
	businesssubtype varchar(18) NULL, -- 保理类型
	occurtype varchar(18) NULL, -- 发生类型
	currenylist varchar(18) NULL, -- 其他可融通币种表
	currencymode varchar(18) NULL, -- 汇率计算模式
	businesstypelist varchar(18) NULL, -- 可混用品种表
	calculatemode varchar(18) NULL, -- 金额占用计算模式
	useorglist varchar(18) NULL, -- 额度可使用机构范围
	flowreduceflag varchar(18) NULL, -- 额度是否简化审批流程
	contractflag varchar(18) NULL, -- 是否使用额度
	subcontractflag varchar(18) NULL, -- 额度下业务是否需要签署合同
	selfuseflag varchar(18) NULL, -- 自用额度
	creditaggreement varchar(32) NULL, -- 额度协议流水号字段
	relativeagreement varchar(32) NULL, -- 额度品种
	loanflag varchar(18) NULL, -- 是否可直接申请出账
	totalsum numeric(24, 6) NULL, -- 展期前金额
	ourrole varchar(18) NULL, -- 额度控制类型
	reversibility varchar(18) NULL, -- 有无追索权
	billnum int4 NULL, -- 票据数量
	housetype varchar(18) NULL, -- 房产类型
	lctermtype varchar(18) NULL, -- 信用证期限类型
	riskattribute varchar(18) NULL, -- 风险类型
	suretype varchar(18) NULL, -- 运单种类
	safeguardtype varchar(18) NULL, -- 保函类型
	creditbusiness varchar(18) NULL, -- 单项额度指定品种
	businesscurrency varchar(18) NULL, -- 业务品种
	businesssum numeric(24, 6) NULL, -- 金额
	businessprop numeric(10, 6) NULL, -- 贷款成数
	termyear int4 NULL, -- 期限
	termmonth int4 NULL, -- 期限
	termday int4 NULL, -- 期限
	lgterm int4 NULL, -- 远期天数
	baseratetype varchar(18) NULL, -- 基准利率类型
	baserate numeric(10, 6) NULL, -- 基准年利率
	ratefloattype varchar(18) NULL, -- 利率浮动方式
	ratefloat numeric(10, 6) NULL, -- 利率浮动值
	businessrate numeric(10, 6) NULL, -- 执行月利率
	ictype varchar(18) NULL, -- 收费方式
	iccyc varchar(18) NULL, -- 计息周期
	pdgratio numeric(10, 6) NULL, -- 手续费率
	pdgsum numeric(24, 6) NULL, -- 手续费金额
	pdgpaymethod varchar(18) NULL, -- 手续费支付方式
	pdgpayperiod varchar(18) NULL, -- 收费周期
	promisesfeeratio numeric(10, 6) NULL, -- 承诺费率
	promisesfeesum numeric(24, 6) NULL, -- 承诺费
	promisesfeeperiod int4 NULL, -- 承诺费计收期
	promisesfeebegin varchar(10) NULL, -- 承诺费计收起始日
	mfeeratio numeric(10, 6) NULL, -- 管理费率
	mfeesum numeric(24, 6) NULL, -- 管理费金额
	mfeepaymethod varchar(18) NULL, -- 管理费支付方式
	agentfee numeric(24, 6) NULL, -- 代理费/单据处理费（元）
	dealfee numeric(24, 6) NULL, -- 银行费用
	totalcast numeric(24, 6) NULL, -- 总成本
	discountinterest numeric(24, 6) NULL, -- 贴现利息
	purchaserinterest numeric(24, 6) NULL, -- 买房应付贴现利息
	bargainorinterest numeric(24, 6) NULL, -- 卖方应付贴现利息
	discountsum numeric(24, 6) NULL, -- 实付贴现金额
	bailratio numeric(10, 6) NULL, -- 保证金比例/要求保证金比例(%)
	bailcurrency varchar(18) NULL, -- 保证金币种
	bailsum numeric(24, 6) NULL, -- 保证金金额/要求保证金金额
	bailaccount varchar(80) NULL, -- 保证金账号
	fineratetype varchar(18) NULL, -- 罚息利率类型
	finerate numeric(10, 6) NULL, -- 垫款利率
	drawingtype varchar(18) NULL, -- 提款方式
	firstdrawingdate varchar(10) NULL, -- 首次提款日
	drawingperiod int4 NULL, -- 提款期限
	paytimes int4 NULL, -- 还款期数
	paycyc varchar(18) NULL, -- 还本付息方式
	graceperiod int4 NULL, -- 贷款宽限期
	overdraftperiod int4 NULL, -- 连续透支期
	oldlcno varchar(32) NULL, -- 信用证编号
	oldlctermtype varchar(18) NULL, -- 原信用证期限类型
	remitmode varchar(18) NULL, -- 汇款方式
	oldlcsum numeric(24, 6) NULL, -- 原信用证金额
	oldlcloadingdate varchar(10) NULL, -- 信用证装期
	oldlcvaliddate varchar(10) NULL, -- 信用证效期
	direction varchar(18) NULL, -- 行业投向
	purpose varchar(2000) NULL, -- 用途
	planallocation varchar(300) NULL, -- 用款计划
	immediacypaysource varchar(300) NULL, -- 重组条件（直接还款来源）
	paysource varchar(300) NULL, -- 还款来源
	corpuspaymethod varchar(18) NULL, -- 还款方式
	interestpaymethod varchar(18) NULL, -- 利息支付方式
	thirdparty1 varchar(300) NULL, -- 承兑人名称
	thirdpartyid1 varchar(60) NULL, -- 房屋详址
	thirdparty2 varchar(300) NULL, -- 开发商资质等级
	thirdpartyid2 varchar(60) NULL, -- 受益人所在国家或地区
	thirdparty3 varchar(300) NULL, -- 议付行/寄单行
	thirdpartyid3 varchar(32) NULL, -- 最高成数
	thirdpartyregion varchar(18) NULL, -- 所在国家或地区
	thirdpartyaccounts varchar(32) NULL, -- 单据号
	cargoinfo varchar(80) NULL, -- 进口货物名称
	projectname varchar(120) NULL, -- 项目名称
	operationinfo varchar(600) NULL, -- 房产地址
	contextinfo varchar(300) NULL, -- 提款说明
	securitiestype varchar(18) NULL, -- 有价证券类型
	securitiesregion varchar(18) NULL, -- 有价证券发行地
	constructionarea numeric(24, 6) NULL, -- 建筑面积
	usearea numeric(24, 6) NULL, -- 面积
	flag1 varchar(18) NULL, -- FLAG1
	flag2 varchar(18) NULL, -- FLAG1
	flag3 varchar(18) NULL, -- FLAG1
	tradecontractno varchar(60) NULL, -- 相关贸易合同号码
	invoiceno varchar(32) NULL, -- 发票号
	tradecurrency varchar(18) NULL, -- 贸易合同币种
	tradesum numeric(24, 6) NULL, -- 贸易合同金额
	paymentdate varchar(10) NULL, -- 票据查询、回复日期
	operationmode varchar(18) NULL, -- 业务处理方式
	vouchclass varchar(18) NULL, -- 担保形式
	vouchtype varchar(18) NULL, -- 主要担保方式
	vouchtype1 varchar(18) NULL, -- 其他担保方式
	vouchtype2 varchar(18) NULL, -- 担保方式2
	vouchflag varchar(18) NULL, -- 有无其他担保方式
	warrantor varchar(80) NULL, -- 担保人
	warrantorid varchar(32) NULL, -- 担保人编号
	othercondition varchar(600) NULL, -- 其他条件和要求
	guarantyvalue numeric(24, 6) NULL, -- 担保总价值
	guarantyrate numeric(10, 6) NULL, -- 担保率
	baseevaluateresult varchar(18) NULL, -- 基期信用等级
	riskrate numeric(24, 6) NULL, -- 综合风险度
	lowrisk varchar(18) NULL, -- 是否低风险业务
	otherarealoan varchar(18) NULL, -- 是否异地业务
	lowriskbailsum numeric(24, 6) NULL, -- 低风险担保金额
	originalputoutdate varchar(10) NULL, -- 首次放款日期
	extendtimes int4 NULL, -- 展期次数
	lngotimes int4 NULL, -- 借新还旧次数
	golntimes int4 NULL, -- 还旧借新次数
	drtimes int4 NULL, -- 债务重组次数
	baseclassifyresult varchar(18) NULL, -- 基期分类结果
	applytype varchar(18) NULL, -- 申请类型
	bailrate numeric(24, 6) NULL, -- 保证金比例
	finishorg varchar(18) NULL, -- 终批机构
	describe1 varchar(300) NULL, -- 宽限期期数
	operateorgid varchar(32) NULL, -- 经办机构
	operateuserid varchar(32) NULL, -- 经办人
	operatedate varchar(10) NULL, -- 经办日期
	inputorgid varchar(32) NULL, -- 登记机构
	inputuserid varchar(32) NULL, -- 登记人
	inputdate varchar(20) NULL, -- 登记日期
	updatedate varchar(10) NULL, -- 更新日期
	pigeonholedate varchar(10) NULL, -- 归档日期
	remark varchar(600) NULL, -- 备注
	paycurrency varchar(18) NULL, -- 单据币种
	paydate varchar(10) NULL, -- 装期
	flag4 varchar(18) NULL, -- 交单方式
	fundsource varchar(18) NULL, -- 资金来源
	operatetype varchar(18) NULL, -- 操作方式
	approvetype varchar(20) NULL, -- 最终审批意见类型
	cycleflag varchar(20) NULL, -- 是否循环
	classifyresult varchar(80) NULL, -- 当前风险分类结果
	classifydate varchar(10) NULL, -- 风险分类日期
	classifyfrequency int4 NULL, -- 检查频率
	vouchnewflag varchar(20) NULL, -- 是否新增担保
	adjustratetype varchar(18) NULL, -- 利率调整方式/宽限期还款法
	adjustrateterm varchar(18) NULL, -- 利率调整日月数
	rateadjustcyc varchar(18) NULL, -- 利率调整周期
	fzanbalance numeric(24, 6) NULL, -- 单据金额
	acceptinttype varchar(18) NULL, -- 收息类型
	ratio numeric(24, 6) NULL, -- 押汇比例
	thirdpartyadd1 varchar(160) NULL, -- 首付金额
	thirdpartyzip1 varchar(32) NULL, -- 首付比例
	thirdpartyadd2 varchar(80) NULL, -- 首付款来源
	thirdpartyzip2 varchar(32) NULL, -- 按揭贷款成数
	thirdpartyadd3 varchar(80) NULL, -- 发运地
	thirdpartyzip3 varchar(50) NULL, -- 进口许可证(批文)编号
	effectarea varchar(18) NULL, -- 交货地
	termdate1 varchar(10) NULL, -- 到期日
	termdate2 varchar(10) NULL, -- 交单期
	termdate3 varchar(10) NULL, -- 申请开证日期
	fixcyc int4 NULL, -- 固定周期
	describe2 varchar(300) NULL, -- 宽限期付息方法
	approveopinion varchar(300) NULL, -- 最终审批意见
	tempsaveflag varchar(18) NULL, -- 暂存标志
	approvedate varchar(10) NULL, -- 批复日期
	flag5 varchar(18) NULL, -- 关联状态
	creditcycle varchar(18) NULL, -- 是否循环
	guarantyflag varchar(18) NULL, -- 征信担保标志
	executeyearrate numeric(10, 6) NULL, -- 执行年利率
	paysourcen varchar(18) NULL, -- 还款来源
	returnfrequency varchar(18) NULL, -- 还款频率
	backfrequency varchar(18) NULL, -- 还息频率
	ishostbank varchar(18) NULL, -- 银团贷款我行是否主办行
	havepayplan varchar(2) NULL, -- 是否设定还款计划表
	ipcode varchar(4) NULL, -- 还息频率（日或月）
	frcode varchar(4) NULL, -- 还款频率（日或月）
	paysourcedetail varchar(300) NULL, -- 还款来源说明
	businesssource varchar(6) NULL, -- 业务渠道
	barcode varchar(64) NULL, -- 条形码
	creditmethod varchar(18) NULL, -- 授信模式
	titularsum1 numeric(24, 6) NULL, -- 名义金额1
	titularsum2 numeric(24, 6) NULL, -- 名义金额2
	titularsum3 numeric(24, 6) NULL, -- 名义金额3
	titularsum4 numeric(24, 6) NULL, -- 名义金额4
	titularsum5 numeric(24, 6) NULL, -- 名义金额5
	exposuresum1 numeric(24, 6) NULL, -- 敞口金额1
	exposuresum2 numeric(24, 6) NULL, -- 敞口金额2
	exposuresum3 numeric(24, 6) NULL, -- 敞口金额3
	exposuresum4 numeric(24, 6) NULL, -- 敞口金额4
	exposuresum5 numeric(24, 6) NULL, -- 敞口金额5
	overagesum1 numeric(24, 6) NULL, -- 敞口余额1
	overagesum2 numeric(24, 6) NULL, -- 敞口余额2
	overagesum3 numeric(24, 6) NULL, -- 敞口余额3
	operateuserid1 varchar(32) NULL, -- 辅办客户经理
	reapply varchar(18) NULL, -- 复议标志(Code:ReApply)
	usedepositpile varchar(4) NULL, -- 存款积数
	depositpilesum numeric(24, 6) NULL, -- 本次所使用存款积数
	preappno varchar(32) NULL, -- 预审号
	direction1 varchar(18) NULL, -- 本行行业分类
	billtype varchar(4) NULL, -- 票据类型
	basebusinesstype varchar(18) NULL, -- 基础产品
	investedcapital numeric(24, 6) NULL, -- 项目总投资额
	promisesfeetype varchar(18) NULL, -- 承诺费支付方式
	issuetype varchar(20) NULL, -- 签发类型
	issuebankname varchar(90) NULL, -- 代签银行名称
	isinsurance varchar(4) NULL, -- 是否保险贷款
	extend numeric(24, 6) NULL, -- 单价（元/平米）
	extend1 varchar(80) NULL, -- 购房合同号
	businessloantype varchar(20) NULL, -- 贷款类型
	extend3 varchar(20) NULL, -- 目前客户名下房屋数量
	extend4 numeric(24, 6) NULL, -- 借款人月收入
	approveartificialno varchar(60) NULL, -- 批复文本号
	isfarming varchar(10) NULL, -- 是否涉农
	xwbz varchar(80) NULL, -- 小微备注
	farmorg varchar(50) NULL, -- 所属专合组织名称
	industrialadjust varchar(10) NULL, -- 产业结构调整类型
	industrialupgrading varchar(10) NULL, -- 是否工业转型升级行业
	newindustry varchar(10) NULL, -- 战略新兴产业类型
	firstdrawingterm int4 NULL, -- 首笔提款期
	enddrawingterm int4 NULL, -- 最晚提款期
	enddrawingdate varchar(10) NULL, -- 最晚提款日
	reauditterm int4 NULL, -- 额度下次重审期限
	reauditdate varchar(10) NULL, -- 额度下次重审日
	yz varchar(2) NULL, -- 是否移植数据
	redeclare varchar(10) NULL, -- 是否重新申报额度
	businesssum1 numeric(24, 6) NULL, -- 个人住宅按揭额度
	businesssum2 numeric(24, 6) NULL, -- 个人营业用房按揭额度
	relaserialno varchar(32) NULL, -- 关联流水号
	bridlemark varchar(4000) NULL, -- 审贷约束条件
	linetype varchar(32) NULL, -- 授信条线
	ispolicyloan varchar(10) NULL, -- 是否保险贷款
	bankvouchtype varchar(18) NULL, -- 担保方式
	productid varchar(32) NULL, -- 产品编号
	isdiscount varchar(10) NULL, -- ISDISCOUNT
	vouchcompanybailaccount varchar(40) NULL, -- VOUCHCOMPANYBAILACCOUNT
	oldputoutdate varchar(20) NULL, -- 原始发放时间
	approveuser varchar(18) NULL, -- APPROVEUSER
	imagebatchno varchar(90) NULL, -- 影像批次号
	oldoccurtype varchar(18) NULL, -- 原发生方式
	oldapplytype varchar(18) NULL, -- 原申请类型
	finishuser varchar(32) NULL, -- 终批人
	channel varchar(20) NULL, -- 渠道号
	oldmaturity varchar(20) NULL, -- 原始到期日
	loanpersontype varchar(10) NULL, -- 借款人主体CodeNo:LoanPersonType
	graduatetype varchar(10) NULL, -- 高校毕业生类型CodeNo:GraduateType
	disabletype varchar(10) NULL, -- 是否残疾人
	femaleflag varchar(10) NULL, -- 是否女性人员
	greencredit varchar(15) NULL, -- 是否绿色贷款
	exposuresum numeric(24, 6) NULL
);
CREATE INDEX idx1_business_approve ON crmdm.cms_business_approve USING btree (customerid);
CREATE INDEX idx2_business_approve ON crmdm.cms_business_approve USING btree (businesstype);
CREATE INDEX idx3_business_approve ON crmdm.cms_business_approve USING btree (relativeserialno);
CREATE INDEX idx4_business_approve ON crmdm.cms_business_approve USING btree (operateuserid, operateorgid);
CREATE INDEX idx6_business_approve ON crmdm.cms_business_approve USING btree (operateorgid);
COMMENT ON TABLE crmdm.cms_business_approve IS '业务批准信息';

-- Column comments

COMMENT ON COLUMN crmdm.cms_business_approve.serialno IS '流水号字段';
COMMENT ON COLUMN crmdm.cms_business_approve.relativeserialno IS '关联流水号字段';
COMMENT ON COLUMN crmdm.cms_business_approve.occurdate IS '发生日期';
COMMENT ON COLUMN crmdm.cms_business_approve.customerid IS '客户编号';
COMMENT ON COLUMN crmdm.cms_business_approve.customername IS '客户名称';
COMMENT ON COLUMN crmdm.cms_business_approve.businesstype IS '业务品种';
COMMENT ON COLUMN crmdm.cms_business_approve.businesssubtype IS '保理类型';
COMMENT ON COLUMN crmdm.cms_business_approve.occurtype IS '发生类型';
COMMENT ON COLUMN crmdm.cms_business_approve.currenylist IS '其他可融通币种表';
COMMENT ON COLUMN crmdm.cms_business_approve.currencymode IS '汇率计算模式';
COMMENT ON COLUMN crmdm.cms_business_approve.businesstypelist IS '可混用品种表';
COMMENT ON COLUMN crmdm.cms_business_approve.calculatemode IS '金额占用计算模式';
COMMENT ON COLUMN crmdm.cms_business_approve.useorglist IS '额度可使用机构范围';
COMMENT ON COLUMN crmdm.cms_business_approve.flowreduceflag IS '额度是否简化审批流程';
COMMENT ON COLUMN crmdm.cms_business_approve.contractflag IS '是否使用额度';
COMMENT ON COLUMN crmdm.cms_business_approve.subcontractflag IS '额度下业务是否需要签署合同';
COMMENT ON COLUMN crmdm.cms_business_approve.selfuseflag IS '自用额度';
COMMENT ON COLUMN crmdm.cms_business_approve.creditaggreement IS '额度协议流水号字段';
COMMENT ON COLUMN crmdm.cms_business_approve.relativeagreement IS '额度品种';
COMMENT ON COLUMN crmdm.cms_business_approve.loanflag IS '是否可直接申请出账';
COMMENT ON COLUMN crmdm.cms_business_approve.totalsum IS '展期前金额';
COMMENT ON COLUMN crmdm.cms_business_approve.ourrole IS '额度控制类型';
COMMENT ON COLUMN crmdm.cms_business_approve.reversibility IS '有无追索权';
COMMENT ON COLUMN crmdm.cms_business_approve.billnum IS '票据数量';
COMMENT ON COLUMN crmdm.cms_business_approve.housetype IS '房产类型';
COMMENT ON COLUMN crmdm.cms_business_approve.lctermtype IS '信用证期限类型';
COMMENT ON COLUMN crmdm.cms_business_approve.riskattribute IS '风险类型';
COMMENT ON COLUMN crmdm.cms_business_approve.suretype IS '运单种类';
COMMENT ON COLUMN crmdm.cms_business_approve.safeguardtype IS '保函类型';
COMMENT ON COLUMN crmdm.cms_business_approve.creditbusiness IS '单项额度指定品种';
COMMENT ON COLUMN crmdm.cms_business_approve.businesscurrency IS '业务品种';
COMMENT ON COLUMN crmdm.cms_business_approve.businesssum IS '金额';
COMMENT ON COLUMN crmdm.cms_business_approve.businessprop IS '贷款成数';
COMMENT ON COLUMN crmdm.cms_business_approve.termyear IS '期限';
COMMENT ON COLUMN crmdm.cms_business_approve.termmonth IS '期限';
COMMENT ON COLUMN crmdm.cms_business_approve.termday IS '期限';
COMMENT ON COLUMN crmdm.cms_business_approve.lgterm IS '远期天数';
COMMENT ON COLUMN crmdm.cms_business_approve.baseratetype IS '基准利率类型';
COMMENT ON COLUMN crmdm.cms_business_approve.baserate IS '基准年利率';
COMMENT ON COLUMN crmdm.cms_business_approve.ratefloattype IS '利率浮动方式';
COMMENT ON COLUMN crmdm.cms_business_approve.ratefloat IS '利率浮动值';
COMMENT ON COLUMN crmdm.cms_business_approve.businessrate IS '执行月利率';
COMMENT ON COLUMN crmdm.cms_business_approve.ictype IS '收费方式';
COMMENT ON COLUMN crmdm.cms_business_approve.iccyc IS '计息周期';
COMMENT ON COLUMN crmdm.cms_business_approve.pdgratio IS '手续费率';
COMMENT ON COLUMN crmdm.cms_business_approve.pdgsum IS '手续费金额';
COMMENT ON COLUMN crmdm.cms_business_approve.pdgpaymethod IS '手续费支付方式';
COMMENT ON COLUMN crmdm.cms_business_approve.pdgpayperiod IS '收费周期';
COMMENT ON COLUMN crmdm.cms_business_approve.promisesfeeratio IS '承诺费率';
COMMENT ON COLUMN crmdm.cms_business_approve.promisesfeesum IS '承诺费';
COMMENT ON COLUMN crmdm.cms_business_approve.promisesfeeperiod IS '承诺费计收期';
COMMENT ON COLUMN crmdm.cms_business_approve.promisesfeebegin IS '承诺费计收起始日';
COMMENT ON COLUMN crmdm.cms_business_approve.mfeeratio IS '管理费率';
COMMENT ON COLUMN crmdm.cms_business_approve.mfeesum IS '管理费金额';
COMMENT ON COLUMN crmdm.cms_business_approve.mfeepaymethod IS '管理费支付方式';
COMMENT ON COLUMN crmdm.cms_business_approve.agentfee IS '代理费/单据处理费（元）';
COMMENT ON COLUMN crmdm.cms_business_approve.dealfee IS '银行费用';
COMMENT ON COLUMN crmdm.cms_business_approve.totalcast IS '总成本';
COMMENT ON COLUMN crmdm.cms_business_approve.discountinterest IS '贴现利息';
COMMENT ON COLUMN crmdm.cms_business_approve.purchaserinterest IS '买房应付贴现利息';
COMMENT ON COLUMN crmdm.cms_business_approve.bargainorinterest IS '卖方应付贴现利息';
COMMENT ON COLUMN crmdm.cms_business_approve.discountsum IS '实付贴现金额';
COMMENT ON COLUMN crmdm.cms_business_approve.bailratio IS '保证金比例/要求保证金比例(%)';
COMMENT ON COLUMN crmdm.cms_business_approve.bailcurrency IS '保证金币种';
COMMENT ON COLUMN crmdm.cms_business_approve.bailsum IS '保证金金额/要求保证金金额';
COMMENT ON COLUMN crmdm.cms_business_approve.bailaccount IS '保证金账号';
COMMENT ON COLUMN crmdm.cms_business_approve.fineratetype IS '罚息利率类型';
COMMENT ON COLUMN crmdm.cms_business_approve.finerate IS '垫款利率';
COMMENT ON COLUMN crmdm.cms_business_approve.drawingtype IS '提款方式';
COMMENT ON COLUMN crmdm.cms_business_approve.firstdrawingdate IS '首次提款日';
COMMENT ON COLUMN crmdm.cms_business_approve.drawingperiod IS '提款期限';
COMMENT ON COLUMN crmdm.cms_business_approve.paytimes IS '还款期数';
COMMENT ON COLUMN crmdm.cms_business_approve.paycyc IS '还本付息方式';
COMMENT ON COLUMN crmdm.cms_business_approve.graceperiod IS '贷款宽限期';
COMMENT ON COLUMN crmdm.cms_business_approve.overdraftperiod IS '连续透支期';
COMMENT ON COLUMN crmdm.cms_business_approve.oldlcno IS '信用证编号';
COMMENT ON COLUMN crmdm.cms_business_approve.oldlctermtype IS '原信用证期限类型';
COMMENT ON COLUMN crmdm.cms_business_approve.remitmode IS '汇款方式';
COMMENT ON COLUMN crmdm.cms_business_approve.oldlcsum IS '原信用证金额';
COMMENT ON COLUMN crmdm.cms_business_approve.oldlcloadingdate IS '信用证装期';
COMMENT ON COLUMN crmdm.cms_business_approve.oldlcvaliddate IS '信用证效期';
COMMENT ON COLUMN crmdm.cms_business_approve.direction IS '行业投向';
COMMENT ON COLUMN crmdm.cms_business_approve.purpose IS '用途';
COMMENT ON COLUMN crmdm.cms_business_approve.planallocation IS '用款计划';
COMMENT ON COLUMN crmdm.cms_business_approve.immediacypaysource IS '重组条件（直接还款来源）';
COMMENT ON COLUMN crmdm.cms_business_approve.paysource IS '还款来源';
COMMENT ON COLUMN crmdm.cms_business_approve.corpuspaymethod IS '还款方式';
COMMENT ON COLUMN crmdm.cms_business_approve.interestpaymethod IS '利息支付方式';
COMMENT ON COLUMN crmdm.cms_business_approve.thirdparty1 IS '承兑人名称';
COMMENT ON COLUMN crmdm.cms_business_approve.thirdpartyid1 IS '房屋详址';
COMMENT ON COLUMN crmdm.cms_business_approve.thirdparty2 IS '开发商资质等级';
COMMENT ON COLUMN crmdm.cms_business_approve.thirdpartyid2 IS '受益人所在国家或地区';
COMMENT ON COLUMN crmdm.cms_business_approve.thirdparty3 IS '议付行/寄单行';
COMMENT ON COLUMN crmdm.cms_business_approve.thirdpartyid3 IS '最高成数';
COMMENT ON COLUMN crmdm.cms_business_approve.thirdpartyregion IS '所在国家或地区';
COMMENT ON COLUMN crmdm.cms_business_approve.thirdpartyaccounts IS '单据号';
COMMENT ON COLUMN crmdm.cms_business_approve.cargoinfo IS '进口货物名称';
COMMENT ON COLUMN crmdm.cms_business_approve.projectname IS '项目名称';
COMMENT ON COLUMN crmdm.cms_business_approve.operationinfo IS '房产地址';
COMMENT ON COLUMN crmdm.cms_business_approve.contextinfo IS '提款说明';
COMMENT ON COLUMN crmdm.cms_business_approve.securitiestype IS '有价证券类型';
COMMENT ON COLUMN crmdm.cms_business_approve.securitiesregion IS '有价证券发行地';
COMMENT ON COLUMN crmdm.cms_business_approve.constructionarea IS '建筑面积';
COMMENT ON COLUMN crmdm.cms_business_approve.usearea IS '面积';
COMMENT ON COLUMN crmdm.cms_business_approve.flag1 IS 'FLAG1';
COMMENT ON COLUMN crmdm.cms_business_approve.flag2 IS 'FLAG1';
COMMENT ON COLUMN crmdm.cms_business_approve.flag3 IS 'FLAG1';
COMMENT ON COLUMN crmdm.cms_business_approve.tradecontractno IS '相关贸易合同号码';
COMMENT ON COLUMN crmdm.cms_business_approve.invoiceno IS '发票号';
COMMENT ON COLUMN crmdm.cms_business_approve.tradecurrency IS '贸易合同币种';
COMMENT ON COLUMN crmdm.cms_business_approve.tradesum IS '贸易合同金额';
COMMENT ON COLUMN crmdm.cms_business_approve.paymentdate IS '票据查询、回复日期';
COMMENT ON COLUMN crmdm.cms_business_approve.operationmode IS '业务处理方式';
COMMENT ON COLUMN crmdm.cms_business_approve.vouchclass IS '担保形式';
COMMENT ON COLUMN crmdm.cms_business_approve.vouchtype IS '主要担保方式';
COMMENT ON COLUMN crmdm.cms_business_approve.vouchtype1 IS '其他担保方式';
COMMENT ON COLUMN crmdm.cms_business_approve.vouchtype2 IS '担保方式2';
COMMENT ON COLUMN crmdm.cms_business_approve.vouchflag IS '有无其他担保方式';
COMMENT ON COLUMN crmdm.cms_business_approve.warrantor IS '担保人';
COMMENT ON COLUMN crmdm.cms_business_approve.warrantorid IS '担保人编号';
COMMENT ON COLUMN crmdm.cms_business_approve.othercondition IS '其他条件和要求';
COMMENT ON COLUMN crmdm.cms_business_approve.guarantyvalue IS '担保总价值';
COMMENT ON COLUMN crmdm.cms_business_approve.guarantyrate IS '担保率';
COMMENT ON COLUMN crmdm.cms_business_approve.baseevaluateresult IS '基期信用等级';
COMMENT ON COLUMN crmdm.cms_business_approve.riskrate IS '综合风险度';
COMMENT ON COLUMN crmdm.cms_business_approve.lowrisk IS '是否低风险业务';
COMMENT ON COLUMN crmdm.cms_business_approve.otherarealoan IS '是否异地业务';
COMMENT ON COLUMN crmdm.cms_business_approve.lowriskbailsum IS '低风险担保金额';
COMMENT ON COLUMN crmdm.cms_business_approve.originalputoutdate IS '首次放款日期';
COMMENT ON COLUMN crmdm.cms_business_approve.extendtimes IS '展期次数';
COMMENT ON COLUMN crmdm.cms_business_approve.lngotimes IS '借新还旧次数';
COMMENT ON COLUMN crmdm.cms_business_approve.golntimes IS '还旧借新次数';
COMMENT ON COLUMN crmdm.cms_business_approve.drtimes IS '债务重组次数';
COMMENT ON COLUMN crmdm.cms_business_approve.baseclassifyresult IS '基期分类结果';
COMMENT ON COLUMN crmdm.cms_business_approve.applytype IS '申请类型';
COMMENT ON COLUMN crmdm.cms_business_approve.bailrate IS '保证金比例';
COMMENT ON COLUMN crmdm.cms_business_approve.finishorg IS '终批机构';
COMMENT ON COLUMN crmdm.cms_business_approve.describe1 IS '宽限期期数';
COMMENT ON COLUMN crmdm.cms_business_approve.operateorgid IS '经办机构';
COMMENT ON COLUMN crmdm.cms_business_approve.operateuserid IS '经办人';
COMMENT ON COLUMN crmdm.cms_business_approve.operatedate IS '经办日期';
COMMENT ON COLUMN crmdm.cms_business_approve.inputorgid IS '登记机构';
COMMENT ON COLUMN crmdm.cms_business_approve.inputuserid IS '登记人';
COMMENT ON COLUMN crmdm.cms_business_approve.inputdate IS '登记日期';
COMMENT ON COLUMN crmdm.cms_business_approve.updatedate IS '更新日期';
COMMENT ON COLUMN crmdm.cms_business_approve.pigeonholedate IS '归档日期';
COMMENT ON COLUMN crmdm.cms_business_approve.remark IS '备注';
COMMENT ON COLUMN crmdm.cms_business_approve.paycurrency IS '单据币种';
COMMENT ON COLUMN crmdm.cms_business_approve.paydate IS '装期';
COMMENT ON COLUMN crmdm.cms_business_approve.flag4 IS '交单方式';
COMMENT ON COLUMN crmdm.cms_business_approve.fundsource IS '资金来源';
COMMENT ON COLUMN crmdm.cms_business_approve.operatetype IS '操作方式';
COMMENT ON COLUMN crmdm.cms_business_approve.approvetype IS '最终审批意见类型';
COMMENT ON COLUMN crmdm.cms_business_approve.cycleflag IS '是否循环';
COMMENT ON COLUMN crmdm.cms_business_approve.classifyresult IS '当前风险分类结果';
COMMENT ON COLUMN crmdm.cms_business_approve.classifydate IS '风险分类日期';
COMMENT ON COLUMN crmdm.cms_business_approve.classifyfrequency IS '检查频率';
COMMENT ON COLUMN crmdm.cms_business_approve.vouchnewflag IS '是否新增担保';
COMMENT ON COLUMN crmdm.cms_business_approve.adjustratetype IS '利率调整方式/宽限期还款法';
COMMENT ON COLUMN crmdm.cms_business_approve.adjustrateterm IS '利率调整日月数';
COMMENT ON COLUMN crmdm.cms_business_approve.rateadjustcyc IS '利率调整周期';
COMMENT ON COLUMN crmdm.cms_business_approve.fzanbalance IS '单据金额';
COMMENT ON COLUMN crmdm.cms_business_approve.acceptinttype IS '收息类型';
COMMENT ON COLUMN crmdm.cms_business_approve.ratio IS '押汇比例';
COMMENT ON COLUMN crmdm.cms_business_approve.thirdpartyadd1 IS '首付金额';
COMMENT ON COLUMN crmdm.cms_business_approve.thirdpartyzip1 IS '首付比例';
COMMENT ON COLUMN crmdm.cms_business_approve.thirdpartyadd2 IS '首付款来源';
COMMENT ON COLUMN crmdm.cms_business_approve.thirdpartyzip2 IS '按揭贷款成数';
COMMENT ON COLUMN crmdm.cms_business_approve.thirdpartyadd3 IS '发运地';
COMMENT ON COLUMN crmdm.cms_business_approve.thirdpartyzip3 IS '进口许可证(批文)编号';
COMMENT ON COLUMN crmdm.cms_business_approve.effectarea IS '交货地';
COMMENT ON COLUMN crmdm.cms_business_approve.termdate1 IS '到期日';
COMMENT ON COLUMN crmdm.cms_business_approve.termdate2 IS '交单期';
COMMENT ON COLUMN crmdm.cms_business_approve.termdate3 IS '申请开证日期';
COMMENT ON COLUMN crmdm.cms_business_approve.fixcyc IS '固定周期';
COMMENT ON COLUMN crmdm.cms_business_approve.describe2 IS '宽限期付息方法';
COMMENT ON COLUMN crmdm.cms_business_approve.approveopinion IS '最终审批意见';
COMMENT ON COLUMN crmdm.cms_business_approve.tempsaveflag IS '暂存标志';
COMMENT ON COLUMN crmdm.cms_business_approve.approvedate IS '批复日期';
COMMENT ON COLUMN crmdm.cms_business_approve.flag5 IS '关联状态';
COMMENT ON COLUMN crmdm.cms_business_approve.creditcycle IS '是否循环';
COMMENT ON COLUMN crmdm.cms_business_approve.guarantyflag IS '征信担保标志';
COMMENT ON COLUMN crmdm.cms_business_approve.executeyearrate IS '执行年利率';
COMMENT ON COLUMN crmdm.cms_business_approve.paysourcen IS '还款来源';
COMMENT ON COLUMN crmdm.cms_business_approve.returnfrequency IS '还款频率';
COMMENT ON COLUMN crmdm.cms_business_approve.backfrequency IS '还息频率';
COMMENT ON COLUMN crmdm.cms_business_approve.ishostbank IS '银团贷款我行是否主办行';
COMMENT ON COLUMN crmdm.cms_business_approve.havepayplan IS '是否设定还款计划表';
COMMENT ON COLUMN crmdm.cms_business_approve.ipcode IS '还息频率（日或月）';
COMMENT ON COLUMN crmdm.cms_business_approve.frcode IS '还款频率（日或月）';
COMMENT ON COLUMN crmdm.cms_business_approve.paysourcedetail IS '还款来源说明';
COMMENT ON COLUMN crmdm.cms_business_approve.businesssource IS '业务渠道';
COMMENT ON COLUMN crmdm.cms_business_approve.barcode IS '条形码';
COMMENT ON COLUMN crmdm.cms_business_approve.creditmethod IS '授信模式';
COMMENT ON COLUMN crmdm.cms_business_approve.titularsum1 IS '名义金额1';
COMMENT ON COLUMN crmdm.cms_business_approve.titularsum2 IS '名义金额2';
COMMENT ON COLUMN crmdm.cms_business_approve.titularsum3 IS '名义金额3';
COMMENT ON COLUMN crmdm.cms_business_approve.titularsum4 IS '名义金额4';
COMMENT ON COLUMN crmdm.cms_business_approve.titularsum5 IS '名义金额5';
COMMENT ON COLUMN crmdm.cms_business_approve.exposuresum1 IS '敞口金额1';
COMMENT ON COLUMN crmdm.cms_business_approve.exposuresum2 IS '敞口金额2';
COMMENT ON COLUMN crmdm.cms_business_approve.exposuresum3 IS '敞口金额3';
COMMENT ON COLUMN crmdm.cms_business_approve.exposuresum4 IS '敞口金额4';
COMMENT ON COLUMN crmdm.cms_business_approve.exposuresum5 IS '敞口金额5';
COMMENT ON COLUMN crmdm.cms_business_approve.overagesum1 IS '敞口余额1';
COMMENT ON COLUMN crmdm.cms_business_approve.overagesum2 IS '敞口余额2';
COMMENT ON COLUMN crmdm.cms_business_approve.overagesum3 IS '敞口余额3';
COMMENT ON COLUMN crmdm.cms_business_approve.operateuserid1 IS '辅办客户经理';
COMMENT ON COLUMN crmdm.cms_business_approve.reapply IS '复议标志(Code:ReApply)';
COMMENT ON COLUMN crmdm.cms_business_approve.usedepositpile IS '存款积数';
COMMENT ON COLUMN crmdm.cms_business_approve.depositpilesum IS '本次所使用存款积数';
COMMENT ON COLUMN crmdm.cms_business_approve.preappno IS '预审号';
COMMENT ON COLUMN crmdm.cms_business_approve.direction1 IS '本行行业分类';
COMMENT ON COLUMN crmdm.cms_business_approve.billtype IS '票据类型';
COMMENT ON COLUMN crmdm.cms_business_approve.basebusinesstype IS '基础产品';
COMMENT ON COLUMN crmdm.cms_business_approve.investedcapital IS '项目总投资额';
COMMENT ON COLUMN crmdm.cms_business_approve.promisesfeetype IS '承诺费支付方式';
COMMENT ON COLUMN crmdm.cms_business_approve.issuetype IS '签发类型';
COMMENT ON COLUMN crmdm.cms_business_approve.issuebankname IS '代签银行名称';
COMMENT ON COLUMN crmdm.cms_business_approve.isinsurance IS '是否保险贷款';
COMMENT ON COLUMN crmdm.cms_business_approve.extend IS '单价（元/平米）';
COMMENT ON COLUMN crmdm.cms_business_approve.extend1 IS '购房合同号';
COMMENT ON COLUMN crmdm.cms_business_approve.businessloantype IS '贷款类型';
COMMENT ON COLUMN crmdm.cms_business_approve.extend3 IS '目前客户名下房屋数量';
COMMENT ON COLUMN crmdm.cms_business_approve.extend4 IS '借款人月收入';
COMMENT ON COLUMN crmdm.cms_business_approve.approveartificialno IS '批复文本号';
COMMENT ON COLUMN crmdm.cms_business_approve.isfarming IS '是否涉农';
COMMENT ON COLUMN crmdm.cms_business_approve.xwbz IS '小微备注';
COMMENT ON COLUMN crmdm.cms_business_approve.farmorg IS '所属专合组织名称';
COMMENT ON COLUMN crmdm.cms_business_approve.industrialadjust IS '产业结构调整类型';
COMMENT ON COLUMN crmdm.cms_business_approve.industrialupgrading IS '是否工业转型升级行业';
COMMENT ON COLUMN crmdm.cms_business_approve.newindustry IS '战略新兴产业类型';
COMMENT ON COLUMN crmdm.cms_business_approve.firstdrawingterm IS '首笔提款期';
COMMENT ON COLUMN crmdm.cms_business_approve.enddrawingterm IS '最晚提款期';
COMMENT ON COLUMN crmdm.cms_business_approve.enddrawingdate IS '最晚提款日';
COMMENT ON COLUMN crmdm.cms_business_approve.reauditterm IS '额度下次重审期限';
COMMENT ON COLUMN crmdm.cms_business_approve.reauditdate IS '额度下次重审日';
COMMENT ON COLUMN crmdm.cms_business_approve.yz IS '是否移植数据';
COMMENT ON COLUMN crmdm.cms_business_approve.redeclare IS '是否重新申报额度';
COMMENT ON COLUMN crmdm.cms_business_approve.businesssum1 IS '个人住宅按揭额度';
COMMENT ON COLUMN crmdm.cms_business_approve.businesssum2 IS '个人营业用房按揭额度';
COMMENT ON COLUMN crmdm.cms_business_approve.relaserialno IS '关联流水号';
COMMENT ON COLUMN crmdm.cms_business_approve.bridlemark IS '审贷约束条件';
COMMENT ON COLUMN crmdm.cms_business_approve.linetype IS '授信条线';
COMMENT ON COLUMN crmdm.cms_business_approve.ispolicyloan IS '是否保险贷款';
COMMENT ON COLUMN crmdm.cms_business_approve.bankvouchtype IS '担保方式';
COMMENT ON COLUMN crmdm.cms_business_approve.productid IS '产品编号';
COMMENT ON COLUMN crmdm.cms_business_approve.isdiscount IS 'ISDISCOUNT';
COMMENT ON COLUMN crmdm.cms_business_approve.vouchcompanybailaccount IS 'VOUCHCOMPANYBAILACCOUNT';
COMMENT ON COLUMN crmdm.cms_business_approve.oldputoutdate IS '原始发放时间';
COMMENT ON COLUMN crmdm.cms_business_approve.approveuser IS 'APPROVEUSER';
COMMENT ON COLUMN crmdm.cms_business_approve.imagebatchno IS '影像批次号';
COMMENT ON COLUMN crmdm.cms_business_approve.oldoccurtype IS '原发生方式';
COMMENT ON COLUMN crmdm.cms_business_approve.oldapplytype IS '原申请类型';
COMMENT ON COLUMN crmdm.cms_business_approve.finishuser IS '终批人';
COMMENT ON COLUMN crmdm.cms_business_approve.channel IS '渠道号';
COMMENT ON COLUMN crmdm.cms_business_approve.oldmaturity IS '原始到期日';
COMMENT ON COLUMN crmdm.cms_business_approve.loanpersontype IS '借款人主体CodeNo:LoanPersonType';
COMMENT ON COLUMN crmdm.cms_business_approve.graduatetype IS '高校毕业生类型CodeNo:GraduateType';
COMMENT ON COLUMN crmdm.cms_business_approve.disabletype IS '是否残疾人';
COMMENT ON COLUMN crmdm.cms_business_approve.femaleflag IS '是否女性人员';
COMMENT ON COLUMN crmdm.cms_business_approve.greencredit IS '是否绿色贷款';
