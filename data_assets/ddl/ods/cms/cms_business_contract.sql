-- crmdm.cms_business_contract 定义

-- Drop table

-- DROP TABLE crmdm.cms_business_contract;

CREATE TABLE crmdm.cms_business_contract (
	serialno varchar(40) NOT NULL, -- 合同编号
	relativeserialno varchar(40) NULL, -- 关联流水号字段
	artificialno varchar(100) NULL, -- 文本合同编号
	occurdate varchar(10) NULL, -- 发生日期
	customerid varchar(32) NULL, -- 客户编号
	customername varchar(80) NULL, -- 客户名称
	businesstype varchar(18) NULL, -- 业务品种
	oldbusinesstype varchar(18) NULL, -- 老业务品种
	businesssubtype varchar(18) NULL, -- 信用证类型
	occurtype varchar(18) NULL, -- 发生类型
	creditdigest varchar(18) NULL, -- 额度是否融通
	creditcycle varchar(18) NULL, -- 是否循环
	credittype varchar(18) NULL, -- 额度品种
	currenylist varchar(18) NULL, -- 其他可融通币种表
	currencymode varchar(18) NULL, -- 汇率计算模式
	businesstypelist varchar(18) NULL, -- 可混用品种表
	calculatemode varchar(18) NULL, -- 金额占用计算模式
	useorglist varchar(18) NULL, -- 额度可使用机构范围
	flowreduceflag varchar(18) NULL, -- 额度是否简化审批流程
	contractflag varchar(18) NULL, -- 是否使用额度
	subcontractflag varchar(18) NULL, -- 项下业务是否签署合同
	selfuseflag varchar(18) NULL, -- 自用额度
	creditindex numeric(10, 6) NULL, -- 额度占用系数
	creditreducesum numeric(24, 6) NULL, -- 额度扣减金额
	limitationterm varchar(10) NULL, -- 额度使用最迟日期
	useterm varchar(10) NULL, -- 到期日期
	creditaggreement varchar(32) NULL, -- 额度协议流水号字段
	relativeagreement varchar(4000) NULL, -- 额度品种
	loanflag varchar(18) NULL, -- 是否可直接申请出账
	totalsum numeric(24, 6) NULL, -- 总金额
	ourrole varchar(18) NULL, -- 额度控制类型
	reversibility varchar(18) NULL, -- 有无追索权
	billnum numeric NULL, -- 票据数量
	housetype varchar(18) NULL, -- 房产类型
	lctermtype varchar(18) NULL, -- 信用证期限类型
	riskattribute varchar(18) NULL, -- 风险类型
	suretype varchar(18) NULL, -- 运单种类
	safeguardtype varchar(18) NULL, -- 保函类型
	creditbusiness varchar(18) NULL, -- 单项额度指定品种
	businesscurrency varchar(18) NULL, -- 币种
	businesssum numeric(24, 6) NULL, -- 合同金额
	businessprop numeric(10, 6) NULL, -- 贷款成数
	termyear numeric NULL, -- 期限（年）
	termmonth numeric NULL, -- 期限
	termday numeric NULL, -- 期限
	lgterm numeric NULL, -- 远期天数
	baseratetype varchar(18) NULL, -- 基准利率类型
	baserate numeric(10, 6) NULL, -- 基准年利率
	ratefloattype varchar(18) NULL, -- 利率浮动方式
	ratefloat numeric(10, 6) NULL, -- 利率浮动值
	businessrate numeric(10, 6) NULL, -- 执行月利率
	ictype varchar(18) NULL, -- 收费方式
	iccyc varchar(18) NULL, -- 计息周期
	pdgratio numeric(10, 6) NULL, -- 费率
	pdgsum numeric(24, 6) NULL, -- 手续费金额
	pdgpaymethod varchar(18) NULL, -- 手续费支付方式
	pdgpayperiod varchar(18) NULL, -- 收费周期
	promisesfeeratio numeric(10, 6) NULL, -- 承诺费率
	promisesfeesum numeric(24, 6) NULL, -- 承诺费
	promisesfeeperiod numeric NULL, -- 承诺费计收期
	promisesfeebegin varchar(10) NULL, -- 承诺费计收起始日
	mfeeratio numeric(10, 6) NULL, -- 管理费率
	mfeesum numeric(24, 6) NULL, -- 管理费金额
	mfeepaymethod varchar(18) NULL, -- 管理费支付方式
	agentfee numeric(24, 6) NULL, -- 代理费
	dealfee numeric(24, 6) NULL, -- 银行费用
	totalcast numeric(24, 6) NULL, -- 总成本
	discountinterest numeric(24, 6) NULL, -- 贴现利息
	purchaserinterest numeric(24, 6) NULL, -- 买方应付贴现利息
	bargainorinterest numeric(24, 6) NULL, -- 卖方应付贴现利息
	discountsum numeric(24, 6) NULL, -- 贴现金额
	bailratio numeric(10, 6) NULL, -- 保证金比例
	bailcurrency varchar(18) NULL, -- 保证金币种
	bailsum numeric(24, 6) NULL, -- 保证金金额
	bailaccount varchar(80) NULL, -- 保证金账号
	fineratetype varchar(18) NULL, -- 罚息利率类型
	finerate numeric(10, 6) NULL, -- 垫款利率
	drawingtype varchar(18) NULL, -- 提款方式
	firstdrawingdate varchar(10) NULL, -- 首次提款日
	drawingperiod numeric NULL, -- 提款期限
	paytimes numeric NULL, -- 还款期数
	paycyc varchar(18) NULL, -- 还本付息方式
	graceperiod numeric NULL, -- 贷款宽限期
	overdraftperiod numeric NULL, -- 连续透支期
	oldlcno varchar(32) NULL, -- 信用证编号
	oldlctermtype varchar(18) NULL, -- 原信用证期限类型
	remitmode varchar(18) NULL, -- 汇款方式
	oldlcsum numeric(24, 6) NULL, -- 原信用证金额"
	oldlcloadingdate varchar(10) NULL, -- 装运日期
	oldlcvaliddate varchar(10) NULL, -- 信用证效期
	direction varchar(18) NULL, -- 行业投向
	purpose varchar(2000) NULL, -- 用途
	planallocation varchar(200) NULL, -- 用款计划
	immediacypaysource varchar(200) NULL, -- 直接还款来源
	paysource varchar(200) NULL, -- 还款说明
	corpuspaymethod varchar(18) NULL, -- 还款方式
	interestpaymethod varchar(18) NULL, -- 利息支付方式
	putoutdate varchar(10) NULL, -- 起始日期
	maturity varchar(10) NULL, -- 到期日期
	thirdparty1 varchar(200) NULL, -- 承兑人名称
	thirdpartyid1 varchar(32) NULL, -- 房屋详址
	thirdparty2 varchar(200) NULL, -- 开发商资质等级
	thirdpartyid2 varchar(32) NULL, -- 受益人所在国家或地区
	thirdparty3 varchar(200) NULL, -- 议付行/寄单行
	thirdpartyid3 varchar(100) NULL, -- 最高成数
	thirdpartyregion varchar(18) NULL, -- 所在国家或地区
	thirdpartyaccounts varchar(32) NULL, -- 委托单位账号
	cargoinfo varchar(80) NULL, -- 进口货物名称
	projectname varchar(80) NULL, -- 项目编号
	operationinfo varchar(400) NULL, -- 参与行情况
	contextinfo varchar(200) NULL, -- 提款说明
	securitiestype varchar(18) NULL, -- 有价证券类型
	securitiesregion varchar(18) NULL, -- 有价证券发行地
	constructionarea numeric(24, 6) NULL, -- 建筑面积
	usearea numeric(24, 6) NULL, -- 使用面积
	flag1 varchar(18) NULL, -- FLAG1
	flag2 varchar(18) NULL, -- FLAG2
	flag3 varchar(18) NULL, -- FLAG3
	tradecontractno varchar(32) NULL, -- 贸易合同号
	invoiceno varchar(32) NULL, -- 增值税发票
	tradecurrency varchar(18) NULL, -- 贸易合同币种
	tradesum numeric(24, 6) NULL, -- 贸易金额
	lcno varchar(32) NULL, -- 信用证编号
	paymentdate varchar(10) NULL, -- 票据查询、回复日期
	operationmode varchar(18) NULL, -- 业务处理方式
	begindate varchar(10) NULL, -- 额度生效日
	enddate varchar(10) NULL, -- 拆借到期日
	vouchclass varchar(18) NULL, -- 担保形式
	vouchtype varchar(18) NULL, -- 主要担保方式
	vouchtype1 varchar(18) NULL, -- 担保方式
	vouchtype2 varchar(18) NULL, -- 担保方式2
	vouchflag varchar(18) NULL, -- 有无其他担保方式
	warrantor varchar(80) NULL, -- 主要担保人
	warrantorid varchar(32) NULL, -- 主要担保人ID
	othercondition varchar(400) NULL, -- 其他条件和要求
	guarantyvalue numeric(24, 6) NULL, -- 担保总价值
	guarantyrate numeric(10, 6) NULL, -- 抵质押率
	baseevaluateresult varchar(18) NULL, -- 基期信用等级
	riskrate numeric(24, 6) NULL, -- 综合风险度
	lowrisk varchar(18) NULL, -- 是否低风险业务
	otherarealoan varchar(18) NULL, -- 是否异地业务
	lowriskbailsum numeric(24, 6) NULL, -- 低风险担保金额
	applytype varchar(18) NULL, -- 申请类型
	originalputoutdate varchar(10) NULL, -- 首次放款日期
	extendtimes numeric NULL, -- 展期次数
	lngotimes numeric NULL, -- 借新还旧次数
	golntimes numeric NULL, -- 还旧借新次数
	drtimes numeric NULL, -- 债务重组次数
	guarantyno varchar(32) NULL, -- 抵质押编号
	putoutsum numeric(24, 6) NULL, -- 放款金额(原币)
	actualputoutsum numeric(24, 6) NULL, -- 实际出账金额
	balance numeric(24, 6) NULL, -- 总余额
	normalbalance numeric(24, 6) NULL, -- 正常余额
	overduebalance numeric(24, 6) NULL, -- 逾期/垫款金额
	dullbalance numeric(24, 6) NULL, -- 呆滞余额
	badbalance numeric(24, 6) NULL, -- 呆账余额
	interestbalance1 numeric(24, 6) NULL, -- 表内欠息
	interestbalance2 numeric(24, 6) NULL, -- 表外欠息余额
	finebalance1 numeric(24, 6) NULL, -- 本金罚息
	finebalance2 numeric(24, 6) NULL, -- 利息罚息
	overduedays numeric NULL, -- 逾期天数
	oweinterestdays numeric NULL, -- 欠息天数
	tabalance numeric(24, 6) NULL, -- 分期业务欠本金
	tainterestbalance numeric(24, 6) NULL, -- 分期业务欠利息
	tatimes numeric NULL, -- 累计欠款期数
	lcatimes numeric(24, 6) NULL, -- 连续欠款期数
	pbinterestsum numeric(24, 6) NULL, -- 累计收回利息
	pbmfeesum numeric(24, 6) NULL, -- 累计收回管理费
	pbpdgsum numeric(24, 6) NULL, -- 累计收回手续费
	pblegalcostsum numeric(24, 6) NULL, -- 累计收回诉讼费
	polegalcostsum numeric(24, 6) NULL, -- 累计付出诉讼费
	originalbaddate varchar(10) NULL, -- 首次认定不良日期
	baseclassifyresult varchar(18) NULL, -- 基期风险分类结果
	classifyresult varchar(80) NULL, -- 当前风险分类结果
	classifytype varchar(18) NULL, -- 最新风险分类方式
	classifydate varchar(10) NULL, -- 风险分类日期
	classifyorgid varchar(32) NULL, -- 分类认定机构
	reservesum numeric(24, 6) NULL, -- 计提准备金额
	expectlosssum numeric(24, 6) NULL, -- 预测损失金额
	bailrate numeric(24, 6) NULL, -- 保证金比率
	finishorg varchar(18) NULL, -- 批复机构
	finishtype varchar(18) NULL, -- 终结类型
	finishdate varchar(10) NULL, -- 终结日期
	describe1 varchar(100) NULL, -- 宽限期期数
	reinforceflag varchar(18) NULL, -- 补登标志
	manageorgid varchar(32) NULL, -- 贷后管理机构
	manageuserid varchar(32) NULL, -- 贷后管理人员
	recoveryorgid varchar(32) NULL, -- 保全管理机构
	recoveryuserid varchar(32) NULL, -- 保全管理人
	statorgid varchar(32) NULL, -- 成本中心机构名称
	statuserid varchar(32) NULL, -- 当前统计人
	operateorgid varchar(32) NULL, -- 经办机构
	operateuserid varchar(32) NULL, -- 经办人
	operatedate varchar(10) NULL, -- 经办时间
	inputorgid varchar(32) NULL, -- 登记机构
	inputuserid varchar(32) NULL, -- 登记人
	inputdate varchar(10) NULL, -- 登记日期
	updatedate varchar(10) NULL, -- 更新日期
	pigeonholedate varchar(10) NULL, -- 归档日期
	remark varchar(400) NULL, -- 备注
	flag4 varchar(18) NULL, -- 交单方式
	paycurrency varchar(18) NULL, -- 单据币种
	paydate varchar(10) NULL, -- 装期
	flag5 varchar(18) NULL, -- 转建行标志
	classifysum1 numeric(24, 6) NULL, -- 最新分类正常金额
	classifysum2 numeric(24, 6) NULL, -- 最新分类关注金额
	classifysum3 numeric(24, 6) NULL, -- 最新分类次级金额
	classifysum4 numeric(24, 6) NULL, -- 最新分类可疑金额
	classifysum5 numeric(24, 6) NULL, -- 最新分类损失金额
	shifttype varchar(18) NULL, -- 移交类型
	operatetype varchar(18) NULL, -- 操作方式
	fundsource varchar(18) NULL, -- 资金来源
	cycleflag varchar(18) NULL, -- 循环标志
	creditfreezeflag varchar(18) NULL, -- 额度是否冻结
	shiftbalance numeric(24, 6) NULL, -- 移交余额
	classifyfrequency numeric NULL, -- 检查频率
	classifylevel varchar(18) NULL, -- 当前认定人员角色
	vouchnewflag varchar(18) NULL, -- 是否新增担保
	actualartificialno varchar(32) NULL, -- 实际合同号
	deleteflag varchar(18) NULL, -- 合并标志
	accountno varchar(32) NULL, -- 结算账号
	loanaccountno varchar(32) NULL, -- 贷款入账账号
	secondpayaccount varchar(32) NULL, -- 第二还款账号
	adjustratetype varchar(18) NULL, -- 利率调整方式
	adjustrateterm varchar(18) NULL, -- 利率调整日月数
	overinttype varchar(18) NULL, -- 逾期计息方式
	rateadjustcyc varchar(18) NULL, -- 利率调整周期
	pdgaccountno varchar(32) NULL, -- 手续费支出帐号
	deductdate varchar(10) NULL, -- 扣款日期
	fzanbalance numeric(24, 6) NULL, -- 到单金额
	acceptinttype varchar(18) NULL, -- 贴现付息方式
	ratio numeric(24, 6) NULL, -- 比例
	thirdpartyadd1 varchar(80) NULL, -- 首付金额
	thirdpartyzip1 varchar(32) NULL, -- 首付比例
	thirdpartyadd2 varchar(80) NULL, -- 首付款来源
	thirdpartyzip2 varchar(32) NULL, -- 按揭贷款成数
	thirdpartyadd3 varchar(80) NULL, -- 发运地
	thirdpartyzip3 varchar(80) NULL, -- 进口许可证(批文)编号
	effectarea varchar(18) NULL, -- 交货地
	termdate1 varchar(10) NULL, -- 期限
	termdate2 varchar(10) NULL, -- 交单期
	termdate3 varchar(10) NULL, -- 申请开证日期
	fixcyc numeric NULL, -- 固定周期
	describe2 varchar(100) NULL, -- 宽限期付息方法
	cancelsum numeric(24, 6) NULL, -- 核销本金
	cancelinterest numeric(24, 6) NULL, -- 核销利息
	loanterm varchar(18) NULL, -- 期限
	putoutorgid varchar(32) NULL, -- 放贷机构
	tempsaveflag varchar(18) NULL, -- 暂存标志
	overduedate varchar(10) NULL, -- 逾期日期
	oweinterestdate varchar(10) NULL, -- 欠息日期
	freezeflag varchar(2) NULL, -- 冻结标志
	approvedate varchar(10) NULL, -- 批复日期
	shiftstatus varchar(18) NULL, -- 不良资产移交状态
	recoverycognorgid varchar(32) NULL, -- 不良资产认定机构
	recoverycognuserid varchar(32) NULL, -- 不良资产认定人员
	shiftdocdescribe varchar(800) NULL, -- 不良资产移交文档清单
	guarantyflag varchar(18) NULL, -- 征信担保标志
	totalbalance numeric(24, 6) NULL, -- 剩余额度
	grouplineid varchar(40) NULL, -- 集团授信额度合同编号
	transformtimes numeric NULL, -- 变更次数
	transformflag varchar(1) NULL, -- 担保合同变更标志
	fundbackaccount varchar(32) NULL, -- 还款准备金账户
	requitalaccount varchar(32) NULL, -- 资金回笼账户
	paymentmode varchar(20) NULL, -- 支付方式
	executeyearrate numeric(10, 6) NULL, -- 执行年利率
	offsheetflag varchar(6) NULL, -- 表内外标志
	paysourcen varchar(18) NULL, -- 还款来源
	returnfrequency varchar(18) NULL, -- 还款频率
	backfrequency varchar(18) NULL, -- 还息频率
	paysourcedetail varchar(200) NULL, -- 还款来源说明
	ishostbank varchar(18) NULL, -- 银团贷款我行是否主办行
	lendaccountno varchar(32) NULL, -- 放款账号
	payaccountno varchar(32) NULL, -- 还款账号
	breachratio numeric(10, 6) NULL, -- 提前还款违约金比例（还款一年内）
	breachratio1 numeric(10, 6) NULL, -- 提前还款违约金比例（还款一年以上）
	havepayplan varchar(2) NULL, -- 是否设定还款计划表
	ipcode varchar(4) NULL, -- 还息频率（日或月）
	frcode varchar(4) NULL, -- 还款频率（日或月）
	breachfinetype varchar(40) NULL, -- 违约罚息方式
	businesssource varchar(6) NULL, -- 业务渠道
	barcode varchar(64) NULL, -- 条形码
	status varchar(32) NULL, -- 合同状态
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
	isfarming varchar(10) NULL, -- 是否涉农
	xwbz varchar(80) NULL, -- 小微备注
	farmorg varchar(50) NULL, -- 所属专合组织名称
	industrialadjust varchar(10) NULL, -- 产业结构调整类型
	industrialupgrading varchar(10) NULL, -- 是否工业转型升级行业
	newindustry varchar(10) NULL, -- 战略新兴产业类型
	firstdrawingterm numeric NULL, -- 首笔提款期
	enddrawingterm numeric NULL, -- 最晚提款期
	enddrawingdate varchar(10) NULL, -- 最晚提款日
	reauditterm numeric NULL, -- 额度下次重审期限
	reauditdate varchar(10) NULL, -- 额度下次重审日
	yz varchar(2) NULL, -- 是否移植数据
	isliquidity varchar(4) NULL, -- 流动资金贷款
	isfixed varchar(4) NULL, -- 固定资产贷款
	isproject varchar(4) NULL, -- 项目融资
	redeclare varchar(10) NULL, -- 是否重新申报额度
	businesssum1 numeric(24, 6) NULL, -- 个人住宅按揭额度
	businesssum2 numeric(24, 6) NULL, -- 个人营业用房按揭额度
	businessproduct varchar(40) NULL, -- 微贷业务产品
	relaserialno varchar(32) NULL, -- 关联流水号
	bridlemark varchar(2000) NULL, -- 审贷约束条件
	linetype varchar(32) NULL, -- 授信条线
	policynumber varchar(20) NULL, -- 保单号
	ispolicyloan varchar(10) NULL, -- 是否保险贷款
	bankvouchtype varchar(18) NULL, -- 担保方式
	isdiscount varchar(10) NULL, -- 属性5
	productid varchar(32) NULL, -- 产品编号
	vouchcompanybailaccount varchar(40) NULL, -- 属性3
	oldputoutdate varchar(20) NULL, -- 原始发放时间
	dealloan varchar(18) NULL, -- 是否经营类贷款
	approveuser varchar(18) NULL, -- 复核人
	paytype varchar(10) NULL, -- 转账标识
	imagebatchno varchar(90) NULL, -- 影像批次号
	oldoccurtype varchar(18) NULL, -- 原发生方式
	oldapplytype varchar(18) NULL, -- 原申请类型
	dutyfreecode varchar(2) NULL, -- 免税标识
	finishuser varchar(32) NULL, -- 终批人
	channel varchar(20) NULL, -- 渠道号
	oldmaturity varchar(20) NULL, -- 原始到期日
	loanpersontype varchar(10) NULL, -- 借款人主体CodeNo:LoanPersonType
	graduatetype varchar(10) NULL, -- 高校毕业生类型CodeNo:GraduateType
	disabletype varchar(10) NULL, -- 是否残疾人
	femaleflag varchar(10) NULL, -- 是否女性人员
	greencredit varchar(10) NULL, -- 是否绿色贷款
	firstloanflag varchar(2) NULL, -- 是否为首套住房贷款
	exposuresum numeric(24, 6) NULL, -- EXPOSURESUM
	ismicropro varchar(32) NOT NULL, -- 是否属于小微批量项目贷款
	microproname varchar(32) NULL, -- 小微批量项目名称
	financebailoutdelay varchar(20) NULL, -- 是否金融纾困延期
	financebailoutdelaymonths numeric NULL, -- 金融纾困延期月数
	creditpromise varchar(20) NULL, -- 授信承诺 CodeNo:CreditPromise
	iscultureindustry varchar(2) NULL, -- 是否文化产业
	isfirstloan varchar(2) NULL, -- 是否首次贷款
	exposuresumauto numeric NULL, -- EXPOSURESUMAUTO
	businesssumauto numeric NULL, -- BUSINESSSUMAUTO
	transno varchar(100) NULL, -- TRANSNO
	isregroup varchar(2) NULL, -- 是否重组贷款
	farmingindicator varchar(20) NULL, -- 涉农附报指标
	observedate varchar(10) NULL, -- 观察期
	czclassifyresult varchar(18) NULL, -- 重组贷款五级分类
	isenforce varchar(2) NULL, -- 是否赋强公证
	myareacode varchar(10) NULL, -- 绵阳一手房按揭区域代码
	isbatchguaranty varchar(2) NULL, -- 是否批量担保业务
	issueforms varchar(2) NULL, -- 开证方式
	gjspprj varchar(3) NULL, -- 个金专案项目
	intpaymode varchar(2) NULL, -- 利息支付方式(码值IntPayMode: 1-核心企业付息; 2-融资申请人付息)
	isspzy varchar(2) NULL, -- 是否商票质押 1=是 2=否
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_cms_business_contract PRIMARY KEY (serialno)
);
CREATE INDEX idx11_business_contract ON crmdm.cms_business_contract USING btree (basebusinesstype);
CREATE INDEX idx12_business_contract ON crmdm.cms_business_contract USING btree (operateuserid1);
CREATE INDEX idx1_business_contract ON crmdm.cms_business_contract USING btree (customerid);
CREATE INDEX idx3_business_contract ON crmdm.cms_business_contract USING btree (relativeserialno);
CREATE INDEX idx4_business_contract ON crmdm.cms_business_contract USING btree (businesstype);
CREATE INDEX idx6_business_contract ON crmdm.cms_business_contract USING btree (manageorgid, manageuserid);
CREATE INDEX idx7_business_contract ON crmdm.cms_business_contract USING btree (creditaggreement);
CREATE INDEX idx8_business_contract ON crmdm.cms_business_contract USING btree (operateuserid, operateorgid);
CREATE INDEX idx9_business_contract ON crmdm.cms_business_contract USING btree (recoveryorgid, recoveryuserid);
COMMENT ON TABLE crmdm.cms_business_contract IS '业务合同信息';

-- Column comments

COMMENT ON COLUMN crmdm.cms_business_contract.serialno IS '合同编号';
COMMENT ON COLUMN crmdm.cms_business_contract.relativeserialno IS '关联流水号字段';
COMMENT ON COLUMN crmdm.cms_business_contract.artificialno IS '文本合同编号';
COMMENT ON COLUMN crmdm.cms_business_contract.occurdate IS '发生日期';
COMMENT ON COLUMN crmdm.cms_business_contract.customerid IS '客户编号';
COMMENT ON COLUMN crmdm.cms_business_contract.customername IS '客户名称';
COMMENT ON COLUMN crmdm.cms_business_contract.businesstype IS '业务品种';
COMMENT ON COLUMN crmdm.cms_business_contract.oldbusinesstype IS '老业务品种';
COMMENT ON COLUMN crmdm.cms_business_contract.businesssubtype IS '信用证类型';
COMMENT ON COLUMN crmdm.cms_business_contract.occurtype IS '发生类型';
COMMENT ON COLUMN crmdm.cms_business_contract.creditdigest IS '额度是否融通';
COMMENT ON COLUMN crmdm.cms_business_contract.creditcycle IS '是否循环';
COMMENT ON COLUMN crmdm.cms_business_contract.credittype IS '额度品种';
COMMENT ON COLUMN crmdm.cms_business_contract.currenylist IS '其他可融通币种表';
COMMENT ON COLUMN crmdm.cms_business_contract.currencymode IS '汇率计算模式';
COMMENT ON COLUMN crmdm.cms_business_contract.businesstypelist IS '可混用品种表';
COMMENT ON COLUMN crmdm.cms_business_contract.calculatemode IS '金额占用计算模式';
COMMENT ON COLUMN crmdm.cms_business_contract.useorglist IS '额度可使用机构范围';
COMMENT ON COLUMN crmdm.cms_business_contract.flowreduceflag IS '额度是否简化审批流程';
COMMENT ON COLUMN crmdm.cms_business_contract.contractflag IS '是否使用额度';
COMMENT ON COLUMN crmdm.cms_business_contract.subcontractflag IS '项下业务是否签署合同';
COMMENT ON COLUMN crmdm.cms_business_contract.selfuseflag IS '自用额度';
COMMENT ON COLUMN crmdm.cms_business_contract.creditindex IS '额度占用系数';
COMMENT ON COLUMN crmdm.cms_business_contract.creditreducesum IS '额度扣减金额';
COMMENT ON COLUMN crmdm.cms_business_contract.limitationterm IS '额度使用最迟日期';
COMMENT ON COLUMN crmdm.cms_business_contract.useterm IS '到期日期';
COMMENT ON COLUMN crmdm.cms_business_contract.creditaggreement IS '额度协议流水号字段';
COMMENT ON COLUMN crmdm.cms_business_contract.relativeagreement IS '额度品种';
COMMENT ON COLUMN crmdm.cms_business_contract.loanflag IS '是否可直接申请出账';
COMMENT ON COLUMN crmdm.cms_business_contract.totalsum IS '总金额';
COMMENT ON COLUMN crmdm.cms_business_contract.ourrole IS '额度控制类型';
COMMENT ON COLUMN crmdm.cms_business_contract.reversibility IS '有无追索权';
COMMENT ON COLUMN crmdm.cms_business_contract.billnum IS '票据数量';
COMMENT ON COLUMN crmdm.cms_business_contract.housetype IS '房产类型';
COMMENT ON COLUMN crmdm.cms_business_contract.lctermtype IS '信用证期限类型';
COMMENT ON COLUMN crmdm.cms_business_contract.riskattribute IS '风险类型';
COMMENT ON COLUMN crmdm.cms_business_contract.suretype IS '运单种类';
COMMENT ON COLUMN crmdm.cms_business_contract.safeguardtype IS '保函类型';
COMMENT ON COLUMN crmdm.cms_business_contract.creditbusiness IS '单项额度指定品种';
COMMENT ON COLUMN crmdm.cms_business_contract.businesscurrency IS '币种';
COMMENT ON COLUMN crmdm.cms_business_contract.businesssum IS '合同金额';
COMMENT ON COLUMN crmdm.cms_business_contract.businessprop IS '贷款成数';
COMMENT ON COLUMN crmdm.cms_business_contract.termyear IS '期限（年）';
COMMENT ON COLUMN crmdm.cms_business_contract.termmonth IS '期限';
COMMENT ON COLUMN crmdm.cms_business_contract.termday IS '期限';
COMMENT ON COLUMN crmdm.cms_business_contract.lgterm IS '远期天数';
COMMENT ON COLUMN crmdm.cms_business_contract.baseratetype IS '基准利率类型';
COMMENT ON COLUMN crmdm.cms_business_contract.baserate IS '基准年利率';
COMMENT ON COLUMN crmdm.cms_business_contract.ratefloattype IS '利率浮动方式';
COMMENT ON COLUMN crmdm.cms_business_contract.ratefloat IS '利率浮动值';
COMMENT ON COLUMN crmdm.cms_business_contract.businessrate IS '执行月利率';
COMMENT ON COLUMN crmdm.cms_business_contract.ictype IS '收费方式';
COMMENT ON COLUMN crmdm.cms_business_contract.iccyc IS '计息周期';
COMMENT ON COLUMN crmdm.cms_business_contract.pdgratio IS '费率';
COMMENT ON COLUMN crmdm.cms_business_contract.pdgsum IS '手续费金额';
COMMENT ON COLUMN crmdm.cms_business_contract.pdgpaymethod IS '手续费支付方式';
COMMENT ON COLUMN crmdm.cms_business_contract.pdgpayperiod IS '收费周期';
COMMENT ON COLUMN crmdm.cms_business_contract.promisesfeeratio IS '承诺费率';
COMMENT ON COLUMN crmdm.cms_business_contract.promisesfeesum IS '承诺费';
COMMENT ON COLUMN crmdm.cms_business_contract.promisesfeeperiod IS '承诺费计收期';
COMMENT ON COLUMN crmdm.cms_business_contract.promisesfeebegin IS '承诺费计收起始日';
COMMENT ON COLUMN crmdm.cms_business_contract.mfeeratio IS '管理费率';
COMMENT ON COLUMN crmdm.cms_business_contract.mfeesum IS '管理费金额';
COMMENT ON COLUMN crmdm.cms_business_contract.mfeepaymethod IS '管理费支付方式';
COMMENT ON COLUMN crmdm.cms_business_contract.agentfee IS '代理费';
COMMENT ON COLUMN crmdm.cms_business_contract.dealfee IS '银行费用';
COMMENT ON COLUMN crmdm.cms_business_contract.totalcast IS '总成本';
COMMENT ON COLUMN crmdm.cms_business_contract.discountinterest IS '贴现利息';
COMMENT ON COLUMN crmdm.cms_business_contract.purchaserinterest IS '买方应付贴现利息';
COMMENT ON COLUMN crmdm.cms_business_contract.bargainorinterest IS '卖方应付贴现利息';
COMMENT ON COLUMN crmdm.cms_business_contract.discountsum IS '贴现金额';
COMMENT ON COLUMN crmdm.cms_business_contract.bailratio IS '保证金比例';
COMMENT ON COLUMN crmdm.cms_business_contract.bailcurrency IS '保证金币种';
COMMENT ON COLUMN crmdm.cms_business_contract.bailsum IS '保证金金额';
COMMENT ON COLUMN crmdm.cms_business_contract.bailaccount IS '保证金账号';
COMMENT ON COLUMN crmdm.cms_business_contract.fineratetype IS '罚息利率类型';
COMMENT ON COLUMN crmdm.cms_business_contract.finerate IS '垫款利率';
COMMENT ON COLUMN crmdm.cms_business_contract.drawingtype IS '提款方式';
COMMENT ON COLUMN crmdm.cms_business_contract.firstdrawingdate IS '首次提款日';
COMMENT ON COLUMN crmdm.cms_business_contract.drawingperiod IS '提款期限';
COMMENT ON COLUMN crmdm.cms_business_contract.paytimes IS '还款期数';
COMMENT ON COLUMN crmdm.cms_business_contract.paycyc IS '还本付息方式';
COMMENT ON COLUMN crmdm.cms_business_contract.graceperiod IS '贷款宽限期';
COMMENT ON COLUMN crmdm.cms_business_contract.overdraftperiod IS '连续透支期';
COMMENT ON COLUMN crmdm.cms_business_contract.oldlcno IS '信用证编号';
COMMENT ON COLUMN crmdm.cms_business_contract.oldlctermtype IS '原信用证期限类型';
COMMENT ON COLUMN crmdm.cms_business_contract.remitmode IS '汇款方式';
COMMENT ON COLUMN crmdm.cms_business_contract.oldlcsum IS '原信用证金额"';
COMMENT ON COLUMN crmdm.cms_business_contract.oldlcloadingdate IS '装运日期';
COMMENT ON COLUMN crmdm.cms_business_contract.oldlcvaliddate IS '信用证效期';
COMMENT ON COLUMN crmdm.cms_business_contract.direction IS '行业投向';
COMMENT ON COLUMN crmdm.cms_business_contract.purpose IS '用途';
COMMENT ON COLUMN crmdm.cms_business_contract.planallocation IS '用款计划';
COMMENT ON COLUMN crmdm.cms_business_contract.immediacypaysource IS '直接还款来源';
COMMENT ON COLUMN crmdm.cms_business_contract.paysource IS '还款说明';
COMMENT ON COLUMN crmdm.cms_business_contract.corpuspaymethod IS '还款方式';
COMMENT ON COLUMN crmdm.cms_business_contract.interestpaymethod IS '利息支付方式';
COMMENT ON COLUMN crmdm.cms_business_contract.putoutdate IS '起始日期';
COMMENT ON COLUMN crmdm.cms_business_contract.maturity IS '到期日期';
COMMENT ON COLUMN crmdm.cms_business_contract.thirdparty1 IS '承兑人名称';
COMMENT ON COLUMN crmdm.cms_business_contract.thirdpartyid1 IS '房屋详址';
COMMENT ON COLUMN crmdm.cms_business_contract.thirdparty2 IS '开发商资质等级';
COMMENT ON COLUMN crmdm.cms_business_contract.thirdpartyid2 IS '受益人所在国家或地区';
COMMENT ON COLUMN crmdm.cms_business_contract.thirdparty3 IS '议付行/寄单行';
COMMENT ON COLUMN crmdm.cms_business_contract.thirdpartyid3 IS '最高成数';
COMMENT ON COLUMN crmdm.cms_business_contract.thirdpartyregion IS '所在国家或地区';
COMMENT ON COLUMN crmdm.cms_business_contract.thirdpartyaccounts IS '委托单位账号';
COMMENT ON COLUMN crmdm.cms_business_contract.cargoinfo IS '进口货物名称';
COMMENT ON COLUMN crmdm.cms_business_contract.projectname IS '项目编号';
COMMENT ON COLUMN crmdm.cms_business_contract.operationinfo IS '参与行情况';
COMMENT ON COLUMN crmdm.cms_business_contract.contextinfo IS '提款说明';
COMMENT ON COLUMN crmdm.cms_business_contract.securitiestype IS '有价证券类型';
COMMENT ON COLUMN crmdm.cms_business_contract.securitiesregion IS '有价证券发行地';
COMMENT ON COLUMN crmdm.cms_business_contract.constructionarea IS '建筑面积';
COMMENT ON COLUMN crmdm.cms_business_contract.usearea IS '使用面积';
COMMENT ON COLUMN crmdm.cms_business_contract.flag1 IS 'FLAG1';
COMMENT ON COLUMN crmdm.cms_business_contract.flag2 IS 'FLAG2';
COMMENT ON COLUMN crmdm.cms_business_contract.flag3 IS 'FLAG3';
COMMENT ON COLUMN crmdm.cms_business_contract.tradecontractno IS '贸易合同号';
COMMENT ON COLUMN crmdm.cms_business_contract.invoiceno IS '增值税发票';
COMMENT ON COLUMN crmdm.cms_business_contract.tradecurrency IS '贸易合同币种';
COMMENT ON COLUMN crmdm.cms_business_contract.tradesum IS '贸易金额';
COMMENT ON COLUMN crmdm.cms_business_contract.lcno IS '信用证编号';
COMMENT ON COLUMN crmdm.cms_business_contract.paymentdate IS '票据查询、回复日期';
COMMENT ON COLUMN crmdm.cms_business_contract.operationmode IS '业务处理方式';
COMMENT ON COLUMN crmdm.cms_business_contract.begindate IS '额度生效日';
COMMENT ON COLUMN crmdm.cms_business_contract.enddate IS '拆借到期日';
COMMENT ON COLUMN crmdm.cms_business_contract.vouchclass IS '担保形式';
COMMENT ON COLUMN crmdm.cms_business_contract.vouchtype IS '主要担保方式';
COMMENT ON COLUMN crmdm.cms_business_contract.vouchtype1 IS '担保方式';
COMMENT ON COLUMN crmdm.cms_business_contract.vouchtype2 IS '担保方式2';
COMMENT ON COLUMN crmdm.cms_business_contract.vouchflag IS '有无其他担保方式';
COMMENT ON COLUMN crmdm.cms_business_contract.warrantor IS '主要担保人';
COMMENT ON COLUMN crmdm.cms_business_contract.warrantorid IS '主要担保人ID';
COMMENT ON COLUMN crmdm.cms_business_contract.othercondition IS '其他条件和要求';
COMMENT ON COLUMN crmdm.cms_business_contract.guarantyvalue IS '担保总价值';
COMMENT ON COLUMN crmdm.cms_business_contract.guarantyrate IS '抵质押率';
COMMENT ON COLUMN crmdm.cms_business_contract.baseevaluateresult IS '基期信用等级';
COMMENT ON COLUMN crmdm.cms_business_contract.riskrate IS '综合风险度';
COMMENT ON COLUMN crmdm.cms_business_contract.lowrisk IS '是否低风险业务';
COMMENT ON COLUMN crmdm.cms_business_contract.otherarealoan IS '是否异地业务';
COMMENT ON COLUMN crmdm.cms_business_contract.lowriskbailsum IS '低风险担保金额';
COMMENT ON COLUMN crmdm.cms_business_contract.applytype IS '申请类型';
COMMENT ON COLUMN crmdm.cms_business_contract.originalputoutdate IS '首次放款日期';
COMMENT ON COLUMN crmdm.cms_business_contract.extendtimes IS '展期次数';
COMMENT ON COLUMN crmdm.cms_business_contract.lngotimes IS '借新还旧次数';
COMMENT ON COLUMN crmdm.cms_business_contract.golntimes IS '还旧借新次数';
COMMENT ON COLUMN crmdm.cms_business_contract.drtimes IS '债务重组次数';
COMMENT ON COLUMN crmdm.cms_business_contract.guarantyno IS '抵质押编号';
COMMENT ON COLUMN crmdm.cms_business_contract.putoutsum IS '放款金额(原币)';
COMMENT ON COLUMN crmdm.cms_business_contract.actualputoutsum IS '实际出账金额';
COMMENT ON COLUMN crmdm.cms_business_contract.balance IS '总余额';
COMMENT ON COLUMN crmdm.cms_business_contract.normalbalance IS '正常余额';
COMMENT ON COLUMN crmdm.cms_business_contract.overduebalance IS '逾期/垫款金额';
COMMENT ON COLUMN crmdm.cms_business_contract.dullbalance IS '呆滞余额';
COMMENT ON COLUMN crmdm.cms_business_contract.badbalance IS '呆账余额';
COMMENT ON COLUMN crmdm.cms_business_contract.interestbalance1 IS '表内欠息';
COMMENT ON COLUMN crmdm.cms_business_contract.interestbalance2 IS '表外欠息余额';
COMMENT ON COLUMN crmdm.cms_business_contract.finebalance1 IS '本金罚息';
COMMENT ON COLUMN crmdm.cms_business_contract.finebalance2 IS '利息罚息';
COMMENT ON COLUMN crmdm.cms_business_contract.overduedays IS '逾期天数';
COMMENT ON COLUMN crmdm.cms_business_contract.oweinterestdays IS '欠息天数';
COMMENT ON COLUMN crmdm.cms_business_contract.tabalance IS '分期业务欠本金';
COMMENT ON COLUMN crmdm.cms_business_contract.tainterestbalance IS '分期业务欠利息';
COMMENT ON COLUMN crmdm.cms_business_contract.tatimes IS '累计欠款期数';
COMMENT ON COLUMN crmdm.cms_business_contract.lcatimes IS '连续欠款期数';
COMMENT ON COLUMN crmdm.cms_business_contract.pbinterestsum IS '累计收回利息';
COMMENT ON COLUMN crmdm.cms_business_contract.pbmfeesum IS '累计收回管理费';
COMMENT ON COLUMN crmdm.cms_business_contract.pbpdgsum IS '累计收回手续费';
COMMENT ON COLUMN crmdm.cms_business_contract.pblegalcostsum IS '累计收回诉讼费';
COMMENT ON COLUMN crmdm.cms_business_contract.polegalcostsum IS '累计付出诉讼费';
COMMENT ON COLUMN crmdm.cms_business_contract.originalbaddate IS '首次认定不良日期';
COMMENT ON COLUMN crmdm.cms_business_contract.baseclassifyresult IS '基期风险分类结果';
COMMENT ON COLUMN crmdm.cms_business_contract.classifyresult IS '当前风险分类结果';
COMMENT ON COLUMN crmdm.cms_business_contract.classifytype IS '最新风险分类方式';
COMMENT ON COLUMN crmdm.cms_business_contract.classifydate IS '风险分类日期';
COMMENT ON COLUMN crmdm.cms_business_contract.classifyorgid IS '分类认定机构';
COMMENT ON COLUMN crmdm.cms_business_contract.reservesum IS '计提准备金额';
COMMENT ON COLUMN crmdm.cms_business_contract.expectlosssum IS '预测损失金额';
COMMENT ON COLUMN crmdm.cms_business_contract.bailrate IS '保证金比率';
COMMENT ON COLUMN crmdm.cms_business_contract.finishorg IS '批复机构';
COMMENT ON COLUMN crmdm.cms_business_contract.finishtype IS '终结类型';
COMMENT ON COLUMN crmdm.cms_business_contract.finishdate IS '终结日期';
COMMENT ON COLUMN crmdm.cms_business_contract.describe1 IS '宽限期期数';
COMMENT ON COLUMN crmdm.cms_business_contract.reinforceflag IS '补登标志';
COMMENT ON COLUMN crmdm.cms_business_contract.manageorgid IS '贷后管理机构';
COMMENT ON COLUMN crmdm.cms_business_contract.manageuserid IS '贷后管理人员';
COMMENT ON COLUMN crmdm.cms_business_contract.recoveryorgid IS '保全管理机构';
COMMENT ON COLUMN crmdm.cms_business_contract.recoveryuserid IS '保全管理人';
COMMENT ON COLUMN crmdm.cms_business_contract.statorgid IS '成本中心机构名称';
COMMENT ON COLUMN crmdm.cms_business_contract.statuserid IS '当前统计人';
COMMENT ON COLUMN crmdm.cms_business_contract.operateorgid IS '经办机构';
COMMENT ON COLUMN crmdm.cms_business_contract.operateuserid IS '经办人';
COMMENT ON COLUMN crmdm.cms_business_contract.operatedate IS '经办时间';
COMMENT ON COLUMN crmdm.cms_business_contract.inputorgid IS '登记机构';
COMMENT ON COLUMN crmdm.cms_business_contract.inputuserid IS '登记人';
COMMENT ON COLUMN crmdm.cms_business_contract.inputdate IS '登记日期';
COMMENT ON COLUMN crmdm.cms_business_contract.updatedate IS '更新日期';
COMMENT ON COLUMN crmdm.cms_business_contract.pigeonholedate IS '归档日期';
COMMENT ON COLUMN crmdm.cms_business_contract.remark IS '备注';
COMMENT ON COLUMN crmdm.cms_business_contract.flag4 IS '交单方式';
COMMENT ON COLUMN crmdm.cms_business_contract.paycurrency IS '单据币种';
COMMENT ON COLUMN crmdm.cms_business_contract.paydate IS '装期';
COMMENT ON COLUMN crmdm.cms_business_contract.flag5 IS '转建行标志';
COMMENT ON COLUMN crmdm.cms_business_contract.classifysum1 IS '最新分类正常金额';
COMMENT ON COLUMN crmdm.cms_business_contract.classifysum2 IS '最新分类关注金额';
COMMENT ON COLUMN crmdm.cms_business_contract.classifysum3 IS '最新分类次级金额';
COMMENT ON COLUMN crmdm.cms_business_contract.classifysum4 IS '最新分类可疑金额';
COMMENT ON COLUMN crmdm.cms_business_contract.classifysum5 IS '最新分类损失金额';
COMMENT ON COLUMN crmdm.cms_business_contract.shifttype IS '移交类型';
COMMENT ON COLUMN crmdm.cms_business_contract.operatetype IS '操作方式';
COMMENT ON COLUMN crmdm.cms_business_contract.fundsource IS '资金来源';
COMMENT ON COLUMN crmdm.cms_business_contract.cycleflag IS '循环标志';
COMMENT ON COLUMN crmdm.cms_business_contract.creditfreezeflag IS '额度是否冻结';
COMMENT ON COLUMN crmdm.cms_business_contract.shiftbalance IS '移交余额';
COMMENT ON COLUMN crmdm.cms_business_contract.classifyfrequency IS '检查频率';
COMMENT ON COLUMN crmdm.cms_business_contract.classifylevel IS '当前认定人员角色';
COMMENT ON COLUMN crmdm.cms_business_contract.vouchnewflag IS '是否新增担保';
COMMENT ON COLUMN crmdm.cms_business_contract.actualartificialno IS '实际合同号';
COMMENT ON COLUMN crmdm.cms_business_contract.deleteflag IS '合并标志';
COMMENT ON COLUMN crmdm.cms_business_contract.accountno IS '结算账号';
COMMENT ON COLUMN crmdm.cms_business_contract.loanaccountno IS '贷款入账账号';
COMMENT ON COLUMN crmdm.cms_business_contract.secondpayaccount IS '第二还款账号';
COMMENT ON COLUMN crmdm.cms_business_contract.adjustratetype IS '利率调整方式';
COMMENT ON COLUMN crmdm.cms_business_contract.adjustrateterm IS '利率调整日月数';
COMMENT ON COLUMN crmdm.cms_business_contract.overinttype IS '逾期计息方式';
COMMENT ON COLUMN crmdm.cms_business_contract.rateadjustcyc IS '利率调整周期';
COMMENT ON COLUMN crmdm.cms_business_contract.pdgaccountno IS '手续费支出帐号';
COMMENT ON COLUMN crmdm.cms_business_contract.deductdate IS '扣款日期';
COMMENT ON COLUMN crmdm.cms_business_contract.fzanbalance IS '到单金额';
COMMENT ON COLUMN crmdm.cms_business_contract.acceptinttype IS '贴现付息方式';
COMMENT ON COLUMN crmdm.cms_business_contract.ratio IS '比例';
COMMENT ON COLUMN crmdm.cms_business_contract.thirdpartyadd1 IS '首付金额';
COMMENT ON COLUMN crmdm.cms_business_contract.thirdpartyzip1 IS '首付比例';
COMMENT ON COLUMN crmdm.cms_business_contract.thirdpartyadd2 IS '首付款来源';
COMMENT ON COLUMN crmdm.cms_business_contract.thirdpartyzip2 IS '按揭贷款成数';
COMMENT ON COLUMN crmdm.cms_business_contract.thirdpartyadd3 IS '发运地';
COMMENT ON COLUMN crmdm.cms_business_contract.thirdpartyzip3 IS '进口许可证(批文)编号';
COMMENT ON COLUMN crmdm.cms_business_contract.effectarea IS '交货地';
COMMENT ON COLUMN crmdm.cms_business_contract.termdate1 IS '期限';
COMMENT ON COLUMN crmdm.cms_business_contract.termdate2 IS '交单期';
COMMENT ON COLUMN crmdm.cms_business_contract.termdate3 IS '申请开证日期';
COMMENT ON COLUMN crmdm.cms_business_contract.fixcyc IS '固定周期';
COMMENT ON COLUMN crmdm.cms_business_contract.describe2 IS '宽限期付息方法';
COMMENT ON COLUMN crmdm.cms_business_contract.cancelsum IS '核销本金';
COMMENT ON COLUMN crmdm.cms_business_contract.cancelinterest IS '核销利息';
COMMENT ON COLUMN crmdm.cms_business_contract.loanterm IS '期限';
COMMENT ON COLUMN crmdm.cms_business_contract.putoutorgid IS '放贷机构';
COMMENT ON COLUMN crmdm.cms_business_contract.tempsaveflag IS '暂存标志';
COMMENT ON COLUMN crmdm.cms_business_contract.overduedate IS '逾期日期';
COMMENT ON COLUMN crmdm.cms_business_contract.oweinterestdate IS '欠息日期';
COMMENT ON COLUMN crmdm.cms_business_contract.freezeflag IS '冻结标志';
COMMENT ON COLUMN crmdm.cms_business_contract.approvedate IS '批复日期';
COMMENT ON COLUMN crmdm.cms_business_contract.shiftstatus IS '不良资产移交状态';
COMMENT ON COLUMN crmdm.cms_business_contract.recoverycognorgid IS '不良资产认定机构';
COMMENT ON COLUMN crmdm.cms_business_contract.recoverycognuserid IS '不良资产认定人员';
COMMENT ON COLUMN crmdm.cms_business_contract.shiftdocdescribe IS '不良资产移交文档清单';
COMMENT ON COLUMN crmdm.cms_business_contract.guarantyflag IS '征信担保标志';
COMMENT ON COLUMN crmdm.cms_business_contract.totalbalance IS '剩余额度';
COMMENT ON COLUMN crmdm.cms_business_contract.grouplineid IS '集团授信额度合同编号';
COMMENT ON COLUMN crmdm.cms_business_contract.transformtimes IS '变更次数';
COMMENT ON COLUMN crmdm.cms_business_contract.transformflag IS '担保合同变更标志';
COMMENT ON COLUMN crmdm.cms_business_contract.fundbackaccount IS '还款准备金账户';
COMMENT ON COLUMN crmdm.cms_business_contract.requitalaccount IS '资金回笼账户';
COMMENT ON COLUMN crmdm.cms_business_contract.paymentmode IS '支付方式';
COMMENT ON COLUMN crmdm.cms_business_contract.executeyearrate IS '执行年利率';
COMMENT ON COLUMN crmdm.cms_business_contract.offsheetflag IS '表内外标志';
COMMENT ON COLUMN crmdm.cms_business_contract.paysourcen IS '还款来源';
COMMENT ON COLUMN crmdm.cms_business_contract.returnfrequency IS '还款频率';
COMMENT ON COLUMN crmdm.cms_business_contract.backfrequency IS '还息频率';
COMMENT ON COLUMN crmdm.cms_business_contract.paysourcedetail IS '还款来源说明';
COMMENT ON COLUMN crmdm.cms_business_contract.ishostbank IS '银团贷款我行是否主办行';
COMMENT ON COLUMN crmdm.cms_business_contract.lendaccountno IS '放款账号';
COMMENT ON COLUMN crmdm.cms_business_contract.payaccountno IS '还款账号';
COMMENT ON COLUMN crmdm.cms_business_contract.breachratio IS '提前还款违约金比例（还款一年内）';
COMMENT ON COLUMN crmdm.cms_business_contract.breachratio1 IS '提前还款违约金比例（还款一年以上）';
COMMENT ON COLUMN crmdm.cms_business_contract.havepayplan IS '是否设定还款计划表';
COMMENT ON COLUMN crmdm.cms_business_contract.ipcode IS '还息频率（日或月）';
COMMENT ON COLUMN crmdm.cms_business_contract.frcode IS '还款频率（日或月）';
COMMENT ON COLUMN crmdm.cms_business_contract.breachfinetype IS '违约罚息方式';
COMMENT ON COLUMN crmdm.cms_business_contract.businesssource IS '业务渠道';
COMMENT ON COLUMN crmdm.cms_business_contract.barcode IS '条形码';
COMMENT ON COLUMN crmdm.cms_business_contract.status IS '合同状态';
COMMENT ON COLUMN crmdm.cms_business_contract.creditmethod IS '授信模式';
COMMENT ON COLUMN crmdm.cms_business_contract.titularsum1 IS '名义金额1';
COMMENT ON COLUMN crmdm.cms_business_contract.titularsum2 IS '名义金额2';
COMMENT ON COLUMN crmdm.cms_business_contract.titularsum3 IS '名义金额3';
COMMENT ON COLUMN crmdm.cms_business_contract.titularsum4 IS '名义金额4';
COMMENT ON COLUMN crmdm.cms_business_contract.titularsum5 IS '名义金额5';
COMMENT ON COLUMN crmdm.cms_business_contract.exposuresum1 IS '敞口金额1';
COMMENT ON COLUMN crmdm.cms_business_contract.exposuresum2 IS '敞口金额2';
COMMENT ON COLUMN crmdm.cms_business_contract.exposuresum3 IS '敞口金额3';
COMMENT ON COLUMN crmdm.cms_business_contract.exposuresum4 IS '敞口金额4';
COMMENT ON COLUMN crmdm.cms_business_contract.exposuresum5 IS '敞口金额5';
COMMENT ON COLUMN crmdm.cms_business_contract.overagesum1 IS '敞口余额1';
COMMENT ON COLUMN crmdm.cms_business_contract.overagesum2 IS '敞口余额2';
COMMENT ON COLUMN crmdm.cms_business_contract.overagesum3 IS '敞口余额3';
COMMENT ON COLUMN crmdm.cms_business_contract.operateuserid1 IS '辅办客户经理';
COMMENT ON COLUMN crmdm.cms_business_contract.reapply IS '复议标志(Code:ReApply)';
COMMENT ON COLUMN crmdm.cms_business_contract.usedepositpile IS '存款积数';
COMMENT ON COLUMN crmdm.cms_business_contract.depositpilesum IS '本次所使用存款积数';
COMMENT ON COLUMN crmdm.cms_business_contract.preappno IS '预审号';
COMMENT ON COLUMN crmdm.cms_business_contract.direction1 IS '本行行业分类';
COMMENT ON COLUMN crmdm.cms_business_contract.billtype IS '票据类型';
COMMENT ON COLUMN crmdm.cms_business_contract.basebusinesstype IS '基础产品';
COMMENT ON COLUMN crmdm.cms_business_contract.investedcapital IS '项目总投资额';
COMMENT ON COLUMN crmdm.cms_business_contract.promisesfeetype IS '承诺费支付方式';
COMMENT ON COLUMN crmdm.cms_business_contract.issuetype IS '签发类型';
COMMENT ON COLUMN crmdm.cms_business_contract.issuebankname IS '代签银行名称';
COMMENT ON COLUMN crmdm.cms_business_contract.isinsurance IS '是否保险贷款';
COMMENT ON COLUMN crmdm.cms_business_contract.extend IS '单价（元/平米）';
COMMENT ON COLUMN crmdm.cms_business_contract.extend1 IS '购房合同号';
COMMENT ON COLUMN crmdm.cms_business_contract.businessloantype IS '贷款类型';
COMMENT ON COLUMN crmdm.cms_business_contract.extend3 IS '目前客户名下房屋数量';
COMMENT ON COLUMN crmdm.cms_business_contract.extend4 IS '借款人月收入';
COMMENT ON COLUMN crmdm.cms_business_contract.isfarming IS '是否涉农';
COMMENT ON COLUMN crmdm.cms_business_contract.xwbz IS '小微备注';
COMMENT ON COLUMN crmdm.cms_business_contract.farmorg IS '所属专合组织名称';
COMMENT ON COLUMN crmdm.cms_business_contract.industrialadjust IS '产业结构调整类型';
COMMENT ON COLUMN crmdm.cms_business_contract.industrialupgrading IS '是否工业转型升级行业';
COMMENT ON COLUMN crmdm.cms_business_contract.newindustry IS '战略新兴产业类型';
COMMENT ON COLUMN crmdm.cms_business_contract.firstdrawingterm IS '首笔提款期';
COMMENT ON COLUMN crmdm.cms_business_contract.enddrawingterm IS '最晚提款期';
COMMENT ON COLUMN crmdm.cms_business_contract.enddrawingdate IS '最晚提款日';
COMMENT ON COLUMN crmdm.cms_business_contract.reauditterm IS '额度下次重审期限';
COMMENT ON COLUMN crmdm.cms_business_contract.reauditdate IS '额度下次重审日';
COMMENT ON COLUMN crmdm.cms_business_contract.yz IS '是否移植数据';
COMMENT ON COLUMN crmdm.cms_business_contract.isliquidity IS '流动资金贷款';
COMMENT ON COLUMN crmdm.cms_business_contract.isfixed IS '固定资产贷款';
COMMENT ON COLUMN crmdm.cms_business_contract.isproject IS '项目融资';
COMMENT ON COLUMN crmdm.cms_business_contract.redeclare IS '是否重新申报额度';
COMMENT ON COLUMN crmdm.cms_business_contract.businesssum1 IS '个人住宅按揭额度';
COMMENT ON COLUMN crmdm.cms_business_contract.businesssum2 IS '个人营业用房按揭额度';
COMMENT ON COLUMN crmdm.cms_business_contract.businessproduct IS '微贷业务产品';
COMMENT ON COLUMN crmdm.cms_business_contract.relaserialno IS '关联流水号';
COMMENT ON COLUMN crmdm.cms_business_contract.bridlemark IS '审贷约束条件';
COMMENT ON COLUMN crmdm.cms_business_contract.linetype IS '授信条线';
COMMENT ON COLUMN crmdm.cms_business_contract.policynumber IS '保单号';
COMMENT ON COLUMN crmdm.cms_business_contract.ispolicyloan IS '是否保险贷款';
COMMENT ON COLUMN crmdm.cms_business_contract.bankvouchtype IS '担保方式';
COMMENT ON COLUMN crmdm.cms_business_contract.isdiscount IS '属性5';
COMMENT ON COLUMN crmdm.cms_business_contract.productid IS '产品编号';
COMMENT ON COLUMN crmdm.cms_business_contract.vouchcompanybailaccount IS '属性3';
COMMENT ON COLUMN crmdm.cms_business_contract.oldputoutdate IS '原始发放时间';
COMMENT ON COLUMN crmdm.cms_business_contract.dealloan IS '是否经营类贷款';
COMMENT ON COLUMN crmdm.cms_business_contract.approveuser IS '复核人';
COMMENT ON COLUMN crmdm.cms_business_contract.paytype IS '转账标识';
COMMENT ON COLUMN crmdm.cms_business_contract.imagebatchno IS '影像批次号';
COMMENT ON COLUMN crmdm.cms_business_contract.oldoccurtype IS '原发生方式';
COMMENT ON COLUMN crmdm.cms_business_contract.oldapplytype IS '原申请类型';
COMMENT ON COLUMN crmdm.cms_business_contract.dutyfreecode IS '免税标识';
COMMENT ON COLUMN crmdm.cms_business_contract.finishuser IS '终批人';
COMMENT ON COLUMN crmdm.cms_business_contract.channel IS '渠道号';
COMMENT ON COLUMN crmdm.cms_business_contract.oldmaturity IS '原始到期日';
COMMENT ON COLUMN crmdm.cms_business_contract.loanpersontype IS '借款人主体CodeNo:LoanPersonType';
COMMENT ON COLUMN crmdm.cms_business_contract.graduatetype IS '高校毕业生类型CodeNo:GraduateType';
COMMENT ON COLUMN crmdm.cms_business_contract.disabletype IS '是否残疾人';
COMMENT ON COLUMN crmdm.cms_business_contract.femaleflag IS '是否女性人员';
COMMENT ON COLUMN crmdm.cms_business_contract.greencredit IS '是否绿色贷款';
COMMENT ON COLUMN crmdm.cms_business_contract.firstloanflag IS '是否为首套住房贷款';
COMMENT ON COLUMN crmdm.cms_business_contract.exposuresum IS 'EXPOSURESUM';
COMMENT ON COLUMN crmdm.cms_business_contract.ismicropro IS '是否属于小微批量项目贷款';
COMMENT ON COLUMN crmdm.cms_business_contract.microproname IS '小微批量项目名称';
COMMENT ON COLUMN crmdm.cms_business_contract.financebailoutdelay IS '是否金融纾困延期';
COMMENT ON COLUMN crmdm.cms_business_contract.financebailoutdelaymonths IS '金融纾困延期月数';
COMMENT ON COLUMN crmdm.cms_business_contract.creditpromise IS '授信承诺 CodeNo:CreditPromise';
COMMENT ON COLUMN crmdm.cms_business_contract.iscultureindustry IS '是否文化产业';
COMMENT ON COLUMN crmdm.cms_business_contract.isfirstloan IS '是否首次贷款';
COMMENT ON COLUMN crmdm.cms_business_contract.exposuresumauto IS 'EXPOSURESUMAUTO';
COMMENT ON COLUMN crmdm.cms_business_contract.businesssumauto IS 'BUSINESSSUMAUTO';
COMMENT ON COLUMN crmdm.cms_business_contract.transno IS 'TRANSNO';
COMMENT ON COLUMN crmdm.cms_business_contract.isregroup IS '是否重组贷款';
COMMENT ON COLUMN crmdm.cms_business_contract.farmingindicator IS '涉农附报指标';
COMMENT ON COLUMN crmdm.cms_business_contract.observedate IS '观察期';
COMMENT ON COLUMN crmdm.cms_business_contract.czclassifyresult IS '重组贷款五级分类';
COMMENT ON COLUMN crmdm.cms_business_contract.isenforce IS '是否赋强公证';
COMMENT ON COLUMN crmdm.cms_business_contract.myareacode IS '绵阳一手房按揭区域代码';
COMMENT ON COLUMN crmdm.cms_business_contract.isbatchguaranty IS '是否批量担保业务';
COMMENT ON COLUMN crmdm.cms_business_contract.issueforms IS '开证方式';
COMMENT ON COLUMN crmdm.cms_business_contract.gjspprj IS '个金专案项目';
COMMENT ON COLUMN crmdm.cms_business_contract.intpaymode IS '利息支付方式(码值IntPayMode: 1-核心企业付息; 2-融资申请人付息)';
COMMENT ON COLUMN crmdm.cms_business_contract.isspzy IS '是否商票质押 1=是 2=否';
COMMENT ON COLUMN crmdm.cms_business_contract.ryzd IS '冗余字段';
