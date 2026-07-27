-- crmdm.cms_business_duebill 定义

-- Drop table

-- DROP TABLE crmdm.cms_business_duebill;

CREATE TABLE crmdm.cms_business_duebill (
	serialno varchar(40) NOT NULL, -- 流水号
	relativeserialno1 varchar(40) NULL, -- 相关出账流水号
	relativeserialno2 varchar(40) NULL, -- 相关合同流水号
	subjectno varchar(20) NULL, -- 会计科目
	mfcustomerid varchar(40) NULL, -- 主机客户号
	customerid varchar(40) NULL, -- 客户编号
	customername varchar(80) NULL, -- 客户名称
	businesstype varchar(18) NULL, -- 业务品种代码
	businesssubtype varchar(20) NULL, -- 业务品种子类型
	businessstatus varchar(20) NULL, -- 业务形态
	businesscurrency varchar(20) NULL, -- 币种
	businesssum numeric(24, 6) NULL, -- 借据金额
	putoutdate varchar(10) NULL, -- 发放日期
	maturity varchar(10) NULL, -- 到期日
	actualmaturity varchar(10) NULL, -- 实际到期日
	businessrate numeric(24, 10) NULL, -- 发放利率
	actualbusinessrate numeric(10, 6) NULL, -- 月利率
	ictype varchar(20) NULL, -- 计息方式
	iccyc varchar(20) NULL, -- 计息周期
	paytimes numeric NULL, -- 信用证付款期限
	paycyc varchar(20) NULL, -- 还款周期
	corpuspaymethod varchar(20) NULL, -- 还本方式
	extendtimes numeric NULL, -- 展期次数
	reorgtimes numeric NULL, -- 债务重组次数
	renewtimes numeric NULL, -- 借新还旧次数
	golntimes numeric NULL, -- 还旧借新次数
	balance numeric(24, 6) NULL, -- 借据余额
	normalbalance numeric(24, 6) NULL, -- 正常余额
	overduebalance numeric(24, 6) NULL, -- 逾期余额
	dullbalance numeric(24, 6) NULL, -- 呆滞余额
	badbalance numeric(24, 6) NULL, -- 呆账余额
	interestbalance1 numeric(24, 6) NULL, -- 表内欠息余额
	interestbalance2 numeric(24, 6) NULL, -- 表外欠息余额
	finebalance1 numeric(24, 6) NULL, -- 逾期罚息余额
	finebalance2 numeric(24, 6) NULL, -- 复息余额
	receivebalance numeric(24, 6) NULL, -- 到单金额
	payedbalance numeric(24, 6) NULL, -- 付款金额
	overduedays numeric NULL, -- 逾期天数
	payaccount varchar(40) NULL, -- 存款账号
	putoutaccount varchar(40) NULL, -- 保证金帐号
	paybackaccount varchar(40) NULL, -- 还款帐号
	payinterestaccount varchar(40) NULL, -- 还息帐号
	oweinterestdays numeric NULL, -- 欠息天数
	tabalance numeric(24, 6) NULL, -- 分期业务欠本金
	tainterestbalance numeric(24, 6) NULL, -- 分期业务欠利息
	tatimes numeric(24, 6) NULL, -- 累计欠款期数
	lcatimes numeric(24, 6) NULL, -- 连续欠款期数
	saledate varchar(10) NULL, -- 售出日期
	finishtype varchar(20) NULL, -- 终结类型
	finishdate varchar(10) NULL, -- 终结日期
	mfareaid varchar(20) NULL, -- 主机地区号
	mforgid varchar(20) NULL, -- 主机机构号
	mfuserid varchar(20) NULL, -- 主机柜员号
	operateorgid varchar(20) NULL, -- 经办机构
	operateuserid varchar(20) NULL, -- 经办人
	inputorgid varchar(20) NULL, -- 登记机构
	inputuserid varchar(20) NULL, -- 登记人
	inputdate varchar(10) NULL, -- 登记日期
	updatedate varchar(10) NULL, -- 更新日期
	inoutflag varchar(40) NULL, -- 表内表外标志
	dealflag varchar(1) NULL, -- 处理标志
	occurdate varchar(10) NULL, -- 发生日期
	businessprop numeric(10, 6) NULL, -- 贷款成数
	benefitcorp varchar(40) NULL, -- 受益人
	actualtermmonth numeric NULL, -- 期限
	actualtermday numeric NULL, -- 期限
	baseratetype varchar(20) NULL, -- 基准利率类型
	baserate numeric(24, 6) NULL, -- 基准利率类型
	ratefloattype varchar(20) NULL, -- 利率浮动类型
	ratefloat numeric(24, 6) NULL, -- 利率浮动类型
	timsflag varchar(40) NULL, -- 分期业务标志
	bailratio numeric(10, 6) NULL, -- 保证金比例
	logoutdate varchar(10) NULL, -- 注销日期
	cancellogoutdate varchar(10) NULL, -- 解除注销日期
	bailsum numeric(24, 6) NULL, -- 保证金金额
	bailaccount varchar(40) NULL, -- 保证金账号
	purpose varchar(200) NULL, -- 用途
	advanceflag varchar(20) NULL, -- 垫款标志
	relativeduebillno varchar(40) NULL, -- 相关借据流水号
	actualartificialno varchar(40) NULL, -- 实际合同号
	accountno varchar(40) NULL, -- 结算帐号
	loanaccountno varchar(40) NULL, -- 贷款入账帐号
	secondpayaccount varchar(40) NULL, -- 第二还款帐号
	adjustratetype varchar(20) NULL, -- 利率调整方式
	adjustrateterm varchar(20) NULL, -- 利息调整月数
	overinttype varchar(20) NULL, -- 逾期计息方式
	rateadjustcyc varchar(20) NULL, -- 利率调整日期
	pdgaccountno varchar(40) NULL, -- 手续费支出帐号
	deductdate varchar(10) NULL, -- 扣款日期
	fzanbalance numeric(24, 6) NULL, -- 发展商入账净额
	acceptinttype varchar(20) NULL, -- 收息类型
	ratio numeric(24, 6) NULL, -- 比率
	thirdpartyadd1 varchar(80) NULL, -- 涉及第三方地址1
	thirdpartyzip1 varchar(40) NULL, -- 第三方法人邮编1
	thirdpartyadd2 varchar(80) NULL, -- 涉及第三方地址2
	thirdpartyzip2 varchar(40) NULL, -- 第三方法人邮编2
	termdate1 varchar(10) NULL, -- 最晚装运期
	termdate2 varchar(10) NULL, -- 交单期
	termdate3 varchar(10) NULL, -- 付款期限
	describe2 varchar(200) NULL, -- 描述2
	fixcyc numeric NULL, -- 固定周期
	thirdparty1 varchar(200) NULL, -- 涉及第三方1
	thirdpartyid1 varchar(40) NULL, -- 第三方法人代表1
	thirdparty2 varchar(200) NULL, -- 涉及第三方2
	thirdparty3 varchar(200) NULL, -- 涉及第三方3
	type1 varchar(20) NULL, -- 通知行类型
	type2 varchar(20) NULL, -- 收益行类型
	type3 varchar(20) NULL, -- 议付行类型
	billno varchar(64) NULL, -- 票据号
	flag1 varchar(20) NULL, -- 是否1
	flag2 varchar(20) NULL, -- 是否2
	flag3 varchar(20) NULL, -- 是否3
	thirdpartyregion varchar(20) NULL, -- 涉及第三方所在地区和国家
	thirdpartyaccounts varchar(40) NULL, -- 第三方帐号
	cargoinfo varchar(80) NULL, -- 货物名称
	securitiestype varchar(20) NULL, -- 有价证券类型
	securitiesregion varchar(20) NULL, -- 有价证券发行地
	aboutbankid2 varchar(40) NULL, -- 收益行行号
	aboutbankname2 varchar(80) NULL, -- 收益行行名
	aboutbankid3 varchar(40) NULL, -- 议付行行号
	aboutbankname varchar(80) NULL, -- 收款行行名
	aboutbankid varchar(40) NULL, -- 收款行行号
	oldlctermtype varchar(20) NULL, -- 原信用证期限类型
	negotiateno varchar(40) NULL, -- 押汇编号
	creditkind varchar(20) NULL, -- 货款形式
	gatheringname varchar(80) NULL, -- 收款人户名
	preinttype varchar(20) NULL, -- 预收息标志
	resumeinttype varchar(20) NULL, -- 计复息标志
	guarantyno varchar(40) NULL, -- 抵质押物编号
	pztype varchar(20) NULL, -- 凭证种类
	graceperiod numeric NULL, -- 还款宽限期
	oldlcvaliddate varchar(10) NULL, -- 原信用证有效期
	mfeepaymethod varchar(20) NULL, -- 管理费支付方式
	describe1 varchar(200) NULL, -- 描述1
	tradecontractno varchar(40) NULL, -- 相关贸易合同号
	loantype varchar(20) NULL, -- 贷款类型
	fixterm numeric(24, 6) NULL, -- 周期
	cancelsum numeric(24, 6) NULL, -- 核销金额
	cancelinterest numeric(24, 6) NULL, -- 核销利息
	bailacount varchar(40) NULL, -- 保证金帐号
	classify4 varchar(18) NULL, -- 4级分类
	classifyresult varchar(18) NULL, -- 五级分类结果
	returntype varchar(18) NULL, -- 终结方式
	bailpercent numeric(10, 6) NULL, -- 保证金比例
	paymenttype varchar(18) NULL, -- 信用证付款方式
	termsfreq varchar(18) NULL, -- 还款频率
	overduedate varchar(10) NULL, -- 逾期日期
	oweinterestdate varchar(10) NULL, -- 欠息日期
	lcstatus varchar(18) NULL, -- 信用证状态
	ichangedate varchar(10) NULL, -- 待扩展字段
	vouchtype varchar(10) NULL, -- 担保方式
	executeyearrate numeric(10, 6) NULL, -- 执行年里率
	offsheetflag varchar(6) NULL, -- 表内外标志
	basebusinesstype varchar(18) NULL, -- 基础产品
	interestoverduedate varchar(18) NULL, -- 计算复利日期
	currentrpttermid varchar(32) NULL, -- 当前时点还款方式
	lctermtype varchar(18) NULL, -- 信用证期限类型
	paytype varchar(12) NULL, -- 支付方式 codeNo=PaymentType
	lastclassifyresult varchar(18) NULL, -- 上月五级分类
	sysclassifyresult varchar(10) NULL, -- 系统五级分类结果
	putoutorgid varchar(100) NULL, -- 业务入账机构
	balanceoverduedate varchar(18) NULL, -- 本金逾期日期
	guaranteeway varchar(18) NULL, -- 担保方式(映射科目条件用)
	gjflag varchar(18) NULL, -- 国结标识
	lcno varchar(32) NULL, -- 信用证/保函编号(国结)
	cancleinterestsum2 numeric(24, 6) NULL, -- 核销表外利息
	canclefinesum1 numeric(24, 6) NULL, -- 核销罚息
	canclefinesum2 numeric(24, 6) NULL, -- 核销复利
	canclebalance numeric(24, 6) NULL, -- 核销后本金余额
	cancleinterestbalance2 numeric(24, 6) NULL, -- 核销后表外利息余额
	canclefinebalance1 numeric(24, 6) NULL, -- 核销后罚息余额
	canclefinebalance2 numeric(24, 6) NULL, -- 核销后复利余额
	unacceptbalance numeric(24, 2) NULL, -- 待承兑余额
	dongjbho varchar(40) NULL, -- 保证金冻结编号
	taskflag varchar(2) NULL, -- 五级分类人工调低标识(五级分类批量用)
	yzflag varchar(5) NULL, -- 是否移植数据(1：是)
	ratetermid varchar(20) NULL, -- 利率模式：固定，浮动
	bpratetermid varchar(20) NULL, -- 原利率模式：固定，浮动
	bprateadjustcyc varchar(20) NULL, -- 原利率调整周期
	bpadjustratetype varchar(20) NULL, -- 原利率调整方式
	bpratefloat numeric(10, 6) NULL, -- 原浮动幅度
	bpratefloattype varchar(20) NULL, -- 原利率浮动类型
	bpbaserate numeric(10, 6) NULL, -- 原基准利率
	bpbaseratetype varchar(20) NULL, -- 原基准利率类型
	financebailoutdelay varchar(20) NULL, -- 是否金融纾困延期
	financebailoutdelaymonths numeric NULL, -- 金融纾困延期月数
	iswriteoffaccrualflag varchar(2) NULL, -- 核销后是否计息标志(YesNo)
	loanwriteofftype varchar(10) NULL, -- 核销类型（01-核销（继续清收）；02-核销结清（清收完成））
	observedate varchar(10) NULL, -- 观察期
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_cms_business_duebill PRIMARY KEY (serialno)
);
CREATE INDEX idx1_business_duebill ON crmdm.cms_business_duebill USING btree (relativeserialno2);
CREATE INDEX idx2_business_duebill ON crmdm.cms_business_duebill USING btree (customerid);
CREATE INDEX idx3_business_duebill ON crmdm.cms_business_duebill USING btree (relativeserialno1);
CREATE INDEX idx4_business_duebill ON crmdm.cms_business_duebill USING btree (subjectno, mforgid, businesscurrency);
CREATE INDEX idx5_business_duebill ON crmdm.cms_business_duebill USING btree (actualmaturity, finishdate, balance);
CREATE INDEX idx6_business_duebill ON crmdm.cms_business_duebill USING btree (operateuserid, finishdate, maturity);
CREATE INDEX idx8_business_duebill ON crmdm.cms_business_duebill USING btree (operateorgid);
COMMENT ON TABLE crmdm.cms_business_duebill IS '业务借据(账户)信息';

-- Column comments

COMMENT ON COLUMN crmdm.cms_business_duebill.serialno IS '流水号';
COMMENT ON COLUMN crmdm.cms_business_duebill.relativeserialno1 IS '相关出账流水号';
COMMENT ON COLUMN crmdm.cms_business_duebill.relativeserialno2 IS '相关合同流水号';
COMMENT ON COLUMN crmdm.cms_business_duebill.subjectno IS '会计科目';
COMMENT ON COLUMN crmdm.cms_business_duebill.mfcustomerid IS '主机客户号';
COMMENT ON COLUMN crmdm.cms_business_duebill.customerid IS '客户编号';
COMMENT ON COLUMN crmdm.cms_business_duebill.customername IS '客户名称';
COMMENT ON COLUMN crmdm.cms_business_duebill.businesstype IS '业务品种代码';
COMMENT ON COLUMN crmdm.cms_business_duebill.businesssubtype IS '业务品种子类型';
COMMENT ON COLUMN crmdm.cms_business_duebill.businessstatus IS '业务形态';
COMMENT ON COLUMN crmdm.cms_business_duebill.businesscurrency IS '币种';
COMMENT ON COLUMN crmdm.cms_business_duebill.businesssum IS '借据金额';
COMMENT ON COLUMN crmdm.cms_business_duebill.putoutdate IS '发放日期';
COMMENT ON COLUMN crmdm.cms_business_duebill.maturity IS '到期日';
COMMENT ON COLUMN crmdm.cms_business_duebill.actualmaturity IS '实际到期日';
COMMENT ON COLUMN crmdm.cms_business_duebill.businessrate IS '发放利率';
COMMENT ON COLUMN crmdm.cms_business_duebill.actualbusinessrate IS '月利率';
COMMENT ON COLUMN crmdm.cms_business_duebill.ictype IS '计息方式';
COMMENT ON COLUMN crmdm.cms_business_duebill.iccyc IS '计息周期';
COMMENT ON COLUMN crmdm.cms_business_duebill.paytimes IS '信用证付款期限';
COMMENT ON COLUMN crmdm.cms_business_duebill.paycyc IS '还款周期';
COMMENT ON COLUMN crmdm.cms_business_duebill.corpuspaymethod IS '还本方式';
COMMENT ON COLUMN crmdm.cms_business_duebill.extendtimes IS '展期次数';
COMMENT ON COLUMN crmdm.cms_business_duebill.reorgtimes IS '债务重组次数';
COMMENT ON COLUMN crmdm.cms_business_duebill.renewtimes IS '借新还旧次数';
COMMENT ON COLUMN crmdm.cms_business_duebill.golntimes IS '还旧借新次数';
COMMENT ON COLUMN crmdm.cms_business_duebill.balance IS '借据余额';
COMMENT ON COLUMN crmdm.cms_business_duebill.normalbalance IS '正常余额';
COMMENT ON COLUMN crmdm.cms_business_duebill.overduebalance IS '逾期余额';
COMMENT ON COLUMN crmdm.cms_business_duebill.dullbalance IS '呆滞余额';
COMMENT ON COLUMN crmdm.cms_business_duebill.badbalance IS '呆账余额';
COMMENT ON COLUMN crmdm.cms_business_duebill.interestbalance1 IS '表内欠息余额';
COMMENT ON COLUMN crmdm.cms_business_duebill.interestbalance2 IS '表外欠息余额';
COMMENT ON COLUMN crmdm.cms_business_duebill.finebalance1 IS '逾期罚息余额';
COMMENT ON COLUMN crmdm.cms_business_duebill.finebalance2 IS '复息余额';
COMMENT ON COLUMN crmdm.cms_business_duebill.receivebalance IS '到单金额';
COMMENT ON COLUMN crmdm.cms_business_duebill.payedbalance IS '付款金额';
COMMENT ON COLUMN crmdm.cms_business_duebill.overduedays IS '逾期天数';
COMMENT ON COLUMN crmdm.cms_business_duebill.payaccount IS '存款账号';
COMMENT ON COLUMN crmdm.cms_business_duebill.putoutaccount IS '保证金帐号';
COMMENT ON COLUMN crmdm.cms_business_duebill.paybackaccount IS '还款帐号';
COMMENT ON COLUMN crmdm.cms_business_duebill.payinterestaccount IS '还息帐号';
COMMENT ON COLUMN crmdm.cms_business_duebill.oweinterestdays IS '欠息天数';
COMMENT ON COLUMN crmdm.cms_business_duebill.tabalance IS '分期业务欠本金';
COMMENT ON COLUMN crmdm.cms_business_duebill.tainterestbalance IS '分期业务欠利息';
COMMENT ON COLUMN crmdm.cms_business_duebill.tatimes IS '累计欠款期数';
COMMENT ON COLUMN crmdm.cms_business_duebill.lcatimes IS '连续欠款期数';
COMMENT ON COLUMN crmdm.cms_business_duebill.saledate IS '售出日期';
COMMENT ON COLUMN crmdm.cms_business_duebill.finishtype IS '终结类型';
COMMENT ON COLUMN crmdm.cms_business_duebill.finishdate IS '终结日期';
COMMENT ON COLUMN crmdm.cms_business_duebill.mfareaid IS '主机地区号';
COMMENT ON COLUMN crmdm.cms_business_duebill.mforgid IS '主机机构号';
COMMENT ON COLUMN crmdm.cms_business_duebill.mfuserid IS '主机柜员号';
COMMENT ON COLUMN crmdm.cms_business_duebill.operateorgid IS '经办机构';
COMMENT ON COLUMN crmdm.cms_business_duebill.operateuserid IS '经办人';
COMMENT ON COLUMN crmdm.cms_business_duebill.inputorgid IS '登记机构';
COMMENT ON COLUMN crmdm.cms_business_duebill.inputuserid IS '登记人';
COMMENT ON COLUMN crmdm.cms_business_duebill.inputdate IS '登记日期';
COMMENT ON COLUMN crmdm.cms_business_duebill.updatedate IS '更新日期';
COMMENT ON COLUMN crmdm.cms_business_duebill.inoutflag IS '表内表外标志';
COMMENT ON COLUMN crmdm.cms_business_duebill.dealflag IS '处理标志';
COMMENT ON COLUMN crmdm.cms_business_duebill.occurdate IS '发生日期';
COMMENT ON COLUMN crmdm.cms_business_duebill.businessprop IS '贷款成数';
COMMENT ON COLUMN crmdm.cms_business_duebill.benefitcorp IS '受益人';
COMMENT ON COLUMN crmdm.cms_business_duebill.actualtermmonth IS '期限';
COMMENT ON COLUMN crmdm.cms_business_duebill.actualtermday IS '期限';
COMMENT ON COLUMN crmdm.cms_business_duebill.baseratetype IS '基准利率类型';
COMMENT ON COLUMN crmdm.cms_business_duebill.baserate IS '基准利率类型';
COMMENT ON COLUMN crmdm.cms_business_duebill.ratefloattype IS '利率浮动类型';
COMMENT ON COLUMN crmdm.cms_business_duebill.ratefloat IS '利率浮动类型';
COMMENT ON COLUMN crmdm.cms_business_duebill.timsflag IS '分期业务标志';
COMMENT ON COLUMN crmdm.cms_business_duebill.bailratio IS '保证金比例';
COMMENT ON COLUMN crmdm.cms_business_duebill.logoutdate IS '注销日期';
COMMENT ON COLUMN crmdm.cms_business_duebill.cancellogoutdate IS '解除注销日期';
COMMENT ON COLUMN crmdm.cms_business_duebill.bailsum IS '保证金金额';
COMMENT ON COLUMN crmdm.cms_business_duebill.bailaccount IS '保证金账号';
COMMENT ON COLUMN crmdm.cms_business_duebill.purpose IS '用途';
COMMENT ON COLUMN crmdm.cms_business_duebill.advanceflag IS '垫款标志';
COMMENT ON COLUMN crmdm.cms_business_duebill.relativeduebillno IS '相关借据流水号';
COMMENT ON COLUMN crmdm.cms_business_duebill.actualartificialno IS '实际合同号';
COMMENT ON COLUMN crmdm.cms_business_duebill.accountno IS '结算帐号';
COMMENT ON COLUMN crmdm.cms_business_duebill.loanaccountno IS '贷款入账帐号';
COMMENT ON COLUMN crmdm.cms_business_duebill.secondpayaccount IS '第二还款帐号';
COMMENT ON COLUMN crmdm.cms_business_duebill.adjustratetype IS '利率调整方式';
COMMENT ON COLUMN crmdm.cms_business_duebill.adjustrateterm IS '利息调整月数';
COMMENT ON COLUMN crmdm.cms_business_duebill.overinttype IS '逾期计息方式';
COMMENT ON COLUMN crmdm.cms_business_duebill.rateadjustcyc IS '利率调整日期';
COMMENT ON COLUMN crmdm.cms_business_duebill.pdgaccountno IS '手续费支出帐号';
COMMENT ON COLUMN crmdm.cms_business_duebill.deductdate IS '扣款日期';
COMMENT ON COLUMN crmdm.cms_business_duebill.fzanbalance IS '发展商入账净额';
COMMENT ON COLUMN crmdm.cms_business_duebill.acceptinttype IS '收息类型';
COMMENT ON COLUMN crmdm.cms_business_duebill.ratio IS '比率';
COMMENT ON COLUMN crmdm.cms_business_duebill.thirdpartyadd1 IS '涉及第三方地址1';
COMMENT ON COLUMN crmdm.cms_business_duebill.thirdpartyzip1 IS '第三方法人邮编1';
COMMENT ON COLUMN crmdm.cms_business_duebill.thirdpartyadd2 IS '涉及第三方地址2';
COMMENT ON COLUMN crmdm.cms_business_duebill.thirdpartyzip2 IS '第三方法人邮编2';
COMMENT ON COLUMN crmdm.cms_business_duebill.termdate1 IS '最晚装运期';
COMMENT ON COLUMN crmdm.cms_business_duebill.termdate2 IS '交单期';
COMMENT ON COLUMN crmdm.cms_business_duebill.termdate3 IS '付款期限';
COMMENT ON COLUMN crmdm.cms_business_duebill.describe2 IS '描述2';
COMMENT ON COLUMN crmdm.cms_business_duebill.fixcyc IS '固定周期';
COMMENT ON COLUMN crmdm.cms_business_duebill.thirdparty1 IS '涉及第三方1';
COMMENT ON COLUMN crmdm.cms_business_duebill.thirdpartyid1 IS '第三方法人代表1';
COMMENT ON COLUMN crmdm.cms_business_duebill.thirdparty2 IS '涉及第三方2';
COMMENT ON COLUMN crmdm.cms_business_duebill.thirdparty3 IS '涉及第三方3';
COMMENT ON COLUMN crmdm.cms_business_duebill.type1 IS '通知行类型';
COMMENT ON COLUMN crmdm.cms_business_duebill.type2 IS '收益行类型';
COMMENT ON COLUMN crmdm.cms_business_duebill.type3 IS '议付行类型';
COMMENT ON COLUMN crmdm.cms_business_duebill.billno IS '票据号';
COMMENT ON COLUMN crmdm.cms_business_duebill.flag1 IS '是否1';
COMMENT ON COLUMN crmdm.cms_business_duebill.flag2 IS '是否2';
COMMENT ON COLUMN crmdm.cms_business_duebill.flag3 IS '是否3';
COMMENT ON COLUMN crmdm.cms_business_duebill.thirdpartyregion IS '涉及第三方所在地区和国家';
COMMENT ON COLUMN crmdm.cms_business_duebill.thirdpartyaccounts IS '第三方帐号';
COMMENT ON COLUMN crmdm.cms_business_duebill.cargoinfo IS '货物名称';
COMMENT ON COLUMN crmdm.cms_business_duebill.securitiestype IS '有价证券类型';
COMMENT ON COLUMN crmdm.cms_business_duebill.securitiesregion IS '有价证券发行地';
COMMENT ON COLUMN crmdm.cms_business_duebill.aboutbankid2 IS '收益行行号';
COMMENT ON COLUMN crmdm.cms_business_duebill.aboutbankname2 IS '收益行行名';
COMMENT ON COLUMN crmdm.cms_business_duebill.aboutbankid3 IS '议付行行号';
COMMENT ON COLUMN crmdm.cms_business_duebill.aboutbankname IS '收款行行名';
COMMENT ON COLUMN crmdm.cms_business_duebill.aboutbankid IS '收款行行号';
COMMENT ON COLUMN crmdm.cms_business_duebill.oldlctermtype IS '原信用证期限类型';
COMMENT ON COLUMN crmdm.cms_business_duebill.negotiateno IS '押汇编号';
COMMENT ON COLUMN crmdm.cms_business_duebill.creditkind IS '货款形式';
COMMENT ON COLUMN crmdm.cms_business_duebill.gatheringname IS '收款人户名';
COMMENT ON COLUMN crmdm.cms_business_duebill.preinttype IS '预收息标志';
COMMENT ON COLUMN crmdm.cms_business_duebill.resumeinttype IS '计复息标志';
COMMENT ON COLUMN crmdm.cms_business_duebill.guarantyno IS '抵质押物编号';
COMMENT ON COLUMN crmdm.cms_business_duebill.pztype IS '凭证种类';
COMMENT ON COLUMN crmdm.cms_business_duebill.graceperiod IS '还款宽限期';
COMMENT ON COLUMN crmdm.cms_business_duebill.oldlcvaliddate IS '原信用证有效期';
COMMENT ON COLUMN crmdm.cms_business_duebill.mfeepaymethod IS '管理费支付方式';
COMMENT ON COLUMN crmdm.cms_business_duebill.describe1 IS '描述1';
COMMENT ON COLUMN crmdm.cms_business_duebill.tradecontractno IS '相关贸易合同号';
COMMENT ON COLUMN crmdm.cms_business_duebill.loantype IS '贷款类型';
COMMENT ON COLUMN crmdm.cms_business_duebill.fixterm IS '周期';
COMMENT ON COLUMN crmdm.cms_business_duebill.cancelsum IS '核销金额';
COMMENT ON COLUMN crmdm.cms_business_duebill.cancelinterest IS '核销利息';
COMMENT ON COLUMN crmdm.cms_business_duebill.bailacount IS '保证金帐号';
COMMENT ON COLUMN crmdm.cms_business_duebill.classify4 IS '4级分类';
COMMENT ON COLUMN crmdm.cms_business_duebill.classifyresult IS '五级分类结果';
COMMENT ON COLUMN crmdm.cms_business_duebill.returntype IS '终结方式';
COMMENT ON COLUMN crmdm.cms_business_duebill.bailpercent IS '保证金比例';
COMMENT ON COLUMN crmdm.cms_business_duebill.paymenttype IS '信用证付款方式';
COMMENT ON COLUMN crmdm.cms_business_duebill.termsfreq IS '还款频率';
COMMENT ON COLUMN crmdm.cms_business_duebill.overduedate IS '逾期日期';
COMMENT ON COLUMN crmdm.cms_business_duebill.oweinterestdate IS '欠息日期';
COMMENT ON COLUMN crmdm.cms_business_duebill.lcstatus IS '信用证状态';
COMMENT ON COLUMN crmdm.cms_business_duebill.ichangedate IS '待扩展字段';
COMMENT ON COLUMN crmdm.cms_business_duebill.vouchtype IS '担保方式';
COMMENT ON COLUMN crmdm.cms_business_duebill.executeyearrate IS '执行年里率';
COMMENT ON COLUMN crmdm.cms_business_duebill.offsheetflag IS '表内外标志';
COMMENT ON COLUMN crmdm.cms_business_duebill.basebusinesstype IS '基础产品';
COMMENT ON COLUMN crmdm.cms_business_duebill.interestoverduedate IS '计算复利日期';
COMMENT ON COLUMN crmdm.cms_business_duebill.currentrpttermid IS '当前时点还款方式';
COMMENT ON COLUMN crmdm.cms_business_duebill.lctermtype IS '信用证期限类型';
COMMENT ON COLUMN crmdm.cms_business_duebill.paytype IS '支付方式 codeNo=PaymentType';
COMMENT ON COLUMN crmdm.cms_business_duebill.lastclassifyresult IS '上月五级分类';
COMMENT ON COLUMN crmdm.cms_business_duebill.sysclassifyresult IS '系统五级分类结果';
COMMENT ON COLUMN crmdm.cms_business_duebill.putoutorgid IS '业务入账机构';
COMMENT ON COLUMN crmdm.cms_business_duebill.balanceoverduedate IS '本金逾期日期';
COMMENT ON COLUMN crmdm.cms_business_duebill.guaranteeway IS '担保方式(映射科目条件用)';
COMMENT ON COLUMN crmdm.cms_business_duebill.gjflag IS '国结标识';
COMMENT ON COLUMN crmdm.cms_business_duebill.lcno IS '信用证/保函编号(国结)';
COMMENT ON COLUMN crmdm.cms_business_duebill.cancleinterestsum2 IS '核销表外利息';
COMMENT ON COLUMN crmdm.cms_business_duebill.canclefinesum1 IS '核销罚息';
COMMENT ON COLUMN crmdm.cms_business_duebill.canclefinesum2 IS '核销复利';
COMMENT ON COLUMN crmdm.cms_business_duebill.canclebalance IS '核销后本金余额';
COMMENT ON COLUMN crmdm.cms_business_duebill.cancleinterestbalance2 IS '核销后表外利息余额';
COMMENT ON COLUMN crmdm.cms_business_duebill.canclefinebalance1 IS '核销后罚息余额';
COMMENT ON COLUMN crmdm.cms_business_duebill.canclefinebalance2 IS '核销后复利余额';
COMMENT ON COLUMN crmdm.cms_business_duebill.unacceptbalance IS '待承兑余额';
COMMENT ON COLUMN crmdm.cms_business_duebill.dongjbho IS '保证金冻结编号';
COMMENT ON COLUMN crmdm.cms_business_duebill.taskflag IS '五级分类人工调低标识(五级分类批量用)';
COMMENT ON COLUMN crmdm.cms_business_duebill.yzflag IS '是否移植数据(1：是)';
COMMENT ON COLUMN crmdm.cms_business_duebill.ratetermid IS '利率模式：固定，浮动';
COMMENT ON COLUMN crmdm.cms_business_duebill.bpratetermid IS '原利率模式：固定，浮动';
COMMENT ON COLUMN crmdm.cms_business_duebill.bprateadjustcyc IS '原利率调整周期';
COMMENT ON COLUMN crmdm.cms_business_duebill.bpadjustratetype IS '原利率调整方式';
COMMENT ON COLUMN crmdm.cms_business_duebill.bpratefloat IS '原浮动幅度';
COMMENT ON COLUMN crmdm.cms_business_duebill.bpratefloattype IS '原利率浮动类型';
COMMENT ON COLUMN crmdm.cms_business_duebill.bpbaserate IS '原基准利率';
COMMENT ON COLUMN crmdm.cms_business_duebill.bpbaseratetype IS '原基准利率类型';
COMMENT ON COLUMN crmdm.cms_business_duebill.financebailoutdelay IS '是否金融纾困延期';
COMMENT ON COLUMN crmdm.cms_business_duebill.financebailoutdelaymonths IS '金融纾困延期月数';
COMMENT ON COLUMN crmdm.cms_business_duebill.iswriteoffaccrualflag IS '核销后是否计息标志(YesNo)';
COMMENT ON COLUMN crmdm.cms_business_duebill.loanwriteofftype IS '核销类型（01-核销（继续清收）；02-核销结清（清收完成））';
COMMENT ON COLUMN crmdm.cms_business_duebill.observedate IS '观察期';
COMMENT ON COLUMN crmdm.cms_business_duebill.ryzd IS '冗余字段';
