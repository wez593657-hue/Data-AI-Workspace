-- crmdm.cms_ent_info 定义

-- Drop table

-- DROP TABLE crmdm.cms_ent_info;

CREATE TABLE crmdm.cms_ent_info (
	customerid varchar(40) NOT NULL, -- 客户编号
	corpid varchar(32) NULL, -- 证件号码
	enterprisename varchar(80) NULL, -- 客户名称
	englishname varchar(80) NULL, -- 客户英文名
	fictitiousperson varchar(80) NULL, -- 法定代表人
	orgnature varchar(18) NULL, -- 机构类型
	financetype varchar(18) NULL, -- 金融机构类型
	enterprisebelong varchar(18) NULL, -- 企业隶属
	industrytype varchar(18) NULL, -- 国标行业分类
	industrytype1 varchar(18) NULL, -- 行业类型一
	industrytype2 varchar(18) NULL, -- 行业类型二
	private varchar(18) NULL, -- 民营标志
	economytype varchar(18) NULL, -- 经济类型
	orgtype varchar(18) NULL, -- 企业类型
	mostbusiness varchar(1600) NULL, -- 经营范围
	budgettype varchar(18) NULL, -- 预算管理类型
	rccurrency varchar(18) NULL, -- 注册资本币种
	registercapital numeric(24, 6) NULL, -- 注册资本
	pccurrency varchar(18) NULL, -- 实收资本币种
	paiclupcapital numeric(24, 6) NULL, -- 实收资本
	fundsource varchar(200) NULL, -- 经费来源
	totalassets numeric(24, 6) NULL, -- 总资产
	netassets numeric(24, 6) NULL, -- 净资产
	annualincome numeric(24, 6) NULL, -- 年收入
	"scope" varchar(18) NULL, -- 企业规模
	creditdate varchar(10) NULL, -- 与我行建立信贷关系时间
	licenseno varchar(32) NULL, -- 工商营业执照号码
	licensedate varchar(10) NULL, -- 营业执照登记日
	licensematurity varchar(10) NULL, -- 营业执照到期日
	setupdate varchar(10) NULL, -- 企业成立日期
	inspectionyear varchar(10) NULL, -- 工商执照最新年检年份
	locksituation varchar(200) NULL, -- 工商局锁定情况
	taxno varchar(32) NULL, -- 税务登记证号(国税)
	banklicense varchar(32) NULL, -- 金融机构许可证代码
	managearea varchar(200) NULL, -- 金融机构经营区域范围
	banchamount numeric NULL, -- 金融机构一级分支机构数量
	exchangeid varchar(32) NULL, -- 交换号
	registeradd varchar(160) NULL, -- 注册地址
	chargedepartment varchar(80) NULL, -- 上级主管单位
	officeadd varchar(160) NULL, -- 办公地址
	officezip varchar(32) NULL, -- 注册地址邮政编码
	countrycode varchar(18) NULL, -- 所在国家(地区)
	regioncode varchar(18) NULL, -- 省份、直辖市、自治区
	villagecode varchar(18) NULL, -- 所属乡镇代码
	villagename varchar(80) NULL, -- 所属乡镇名称
	relativetype varchar(200) NULL, -- 机构电话
	officetel varchar(32) NULL, -- 联系电话
	officefax varchar(32) NULL, -- 传真电话
	webadd varchar(80) NULL, -- 公司网址
	emailadd varchar(80) NULL, -- 公司E－Mail
	employeenumber numeric NULL, -- 职工人数
	mainproduction varchar(800) NULL, -- 主要产品情况
	newtechcorpornot varchar(18) NULL, -- 是否高新技术企业
	listingcorpornot varchar(18) NULL, -- 上市公司类型
	hasieright varchar(18) NULL, -- 有无进出口经营权
	hasdirectorate varchar(18) NULL, -- 有无董事会
	basicbank varchar(80) NULL, -- 基本帐户行
	basicaccount varchar(32) NULL, -- 基本帐户号
	manageinfo varchar(800) NULL, -- 合法经营情况
	customerhistory varchar(800) NULL, -- 客户历史沿革、管理水平简介
	projectflag varchar(18) NULL, -- 企业目前是否有项目
	realtyflag varchar(18) NULL, -- 是否从事房地产开发
	workfieldarea numeric NULL, -- 经营场地面积
	workfieldfee varchar(18) NULL, -- 经营场地所有权
	accountdate varchar(10) NULL, -- 在我行首次开立账户时间
	loancardno varchar(32) NULL, -- 贷款卡号
	loancardpassword varchar(32) NULL, -- 贷款卡密码
	loancardinsyear varchar(10) NULL, -- 贷款卡最新年审年份
	loancardinsresult varchar(200) NULL, -- 贷款卡最新年审结果
	loanflag varchar(18) NULL, -- 贷款卡是否有效
	financeornot varchar(18) NULL, -- 是否无需提供财报
	financebelong varchar(18) NULL, -- 财务报表类型
	creditbelong varchar(18) NULL, -- 信用等级评估模板名称
	creditlevel varchar(80) NULL, -- 本行即期信用等级
	evaluatedate varchar(10) NULL, -- 评估日期
	othercreditlevel varchar(80) NULL, -- 外部机构评级结果
	otherevaluatedate varchar(10) NULL, -- 外部机构评级日期
	otherorgname varchar(80) NULL, -- 外部评级机构名称
	inputorgid varchar(32) NULL, -- 登记机构
	inputuserid varchar(32) NULL, -- 登记人
	inputdate varchar(10) NULL, -- 登记日期
	updateorgid varchar(32) NULL, -- 更新机构
	updateuserid varchar(32) NULL, -- 更新人员
	updatedate varchar(10) NULL, -- 更新日期
	remark varchar(200) NULL, -- 备注
	taxno1 varchar(32) NULL, -- 税务登记证号(地税)
	fictitiouspersonid varchar(32) NULL, -- 法定代表人身份证号码
	groupflag varchar(18) NULL, -- 集团客户标志
	evaluatelevel varchar(18) NULL, -- 评估级别
	mybank varchar(80) NULL, -- 我行开户行
	mybankaccount varchar(32) NULL, -- 我行开户帐号
	otherbank varchar(80) NULL, -- 他行开户行
	otherbankaccount varchar(32) NULL, -- 他行开户帐号
	tempsaveflag varchar(18) NULL, -- 暂存标志
	financedepttel varchar(32) NULL, -- 财务部联系电话
	ecgroupflag varchar(18) NULL, -- 是否征信标准集团客户
	supercorpname varchar(80) NULL, -- 上级公司名称
	superloancardno varchar(32) NULL, -- 上级公司贷款卡编号
	supercerttype varchar(18) NULL, -- 上级公司证件类型
	smeindustrytype varchar(10) NULL, -- 中小企业行业类型
	sellsum numeric(24, 6) NULL, -- 年销售额
	supercertid varchar(32) NULL, -- 上级公司组织机构代码
	officecountrycode varchar(18) NULL, -- 办公地址所在国家
	officeregioncode varchar(18) NULL, -- 办公地址所在省市区
	registerzip varchar(32) NULL, -- 注册地邮编
	limitck numeric(24, 6) NULL, -- 最高限额参考
	sillerent varchar(2) NULL, -- 资金公司
	industrialadjust varchar(10) NULL, -- 工业调整
	industrialupgrading varchar(10) NULL, -- 是否企业调整
	newindustry varchar(10) NULL, -- 新企业
	czcountryent varchar(10) NULL, -- 所处国家
	isfarming varchar(10) NULL, -- 是否产业
	czareaname varchar(50) NULL, -- 区域的名称
	registeraddecifid varchar(20) NULL, -- 注册地址ECIFID
	officeaddecifid varchar(20) NULL, -- 办公地址ECIFID
	officetelecifid varchar(20) NULL, -- 联系电话ECIFID
	officefaxecifid varchar(20) NULL, -- 传真电话ECIFID
	relativetypeecifid varchar(20) NULL, -- 机构电话ECIFID
	emailaddecifid varchar(20) NULL, -- 公司E－MailECIFID
	webaddecifid varchar(20) NULL, -- 公司网址ECIFID
	unitycreditcode varchar(32) NULL, -- 社会统一信用代码
	entnature varchar(32) NULL, -- 企业性质
	otherreceivables numeric(24, 6) NULL, -- 关联证书
	czarea varchar(18) NULL, -- 所处区域
	listingtype varchar(10) NULL, -- 上市类型
	listingcountry varchar(10) NULL, -- 上市国家
	listingcorpnumber varchar(10) NULL, -- 上市机构
	financedate varchar(18) NULL, -- 上市时间
	totaldebt numeric(24, 6) NULL, -- 总资产
	officeaddcode varchar(10) NULL, -- 办公地址所在国家
	jxscope varchar(18) NULL, -- 公司领域
	openaccontlicense varchar(32) NULL, -- 开户许可证号
	regulatoryrating varchar(10) NULL, -- 监管评级结果
	ratingfirmriting varchar(10) NULL, -- 评级公司评级结果
	bankshareholder varchar(10) NULL, -- 是否本行股东
	listingplace varchar(50) NULL, -- 上市地点
	interbankquota numeric(24, 6) NULL, -- 人民银行同意开办同业拆借的额度
	taxpayerid varchar(50) NULL, -- 纳税人识别号
	standardevlaresult varchar(10) NULL, -- 标普评级结果
	moodyevlaresult varchar(10) NULL, -- 穆迪评级结果
	otherevlaresult varchar(10) NULL, -- 其他可参考评级结果
	bankid varchar(32) NULL, -- 金融机构代码
	regdate varchar(10) NULL, -- 金融机构代码
	fitchratresult varchar(10) NULL, -- 惠誉评级结果
	hightechent varchar(10) NULL, -- 是否高科技企业
	accountbussdate varchar(10) NULL, -- 首次发起业务的时间
	otherreceive numeric(24, 6) NULL, -- 其他应收款项
	department varchar(80) NULL, -- 主管单位
	interregion varchar(18) NULL, -- 所在国内地区
	countryrisk varchar(18) NULL, -- 国别风险
	certificatenum varchar(32) NULL, -- 法人证书编号
	isfirstloanuser varchar(2) NULL, -- 是否首贷户
	firstloandate varchar(10) NULL, -- 首贷年月
	lastyearemployees numeric(24, 6) NULL, -- 上年末从业人数（个）
	lastyearbusinessincome numeric(24, 6) NULL, -- 上年度营业收入（元）
	lastyeartotalassets numeric(24, 6) NULL, -- 上年末资产总额（元）
	systemscope varchar(10) NULL, -- 系统企业规模
	isspecialandnew varchar(2) NULL, -- 是否专精特新
	belonggroupname varchar(80) NULL, -- 客户所属集团名称
	isnewagriculture varchar(2) NULL, -- 是否新型农业经营主体
	tjaddrcode varchar(20) NULL, -- 注册地址统计用行政区划代码
	isfarmer varchar(8) NULL, -- 个体工商户是否农户(2-否 1-是)
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_cms_ent_info PRIMARY KEY (customerid)
);

-- Column comments

COMMENT ON COLUMN crmdm.cms_ent_info.customerid IS '客户编号';
COMMENT ON COLUMN crmdm.cms_ent_info.corpid IS '证件号码';
COMMENT ON COLUMN crmdm.cms_ent_info.enterprisename IS '客户名称';
COMMENT ON COLUMN crmdm.cms_ent_info.englishname IS '客户英文名';
COMMENT ON COLUMN crmdm.cms_ent_info.fictitiousperson IS '法定代表人';
COMMENT ON COLUMN crmdm.cms_ent_info.orgnature IS '机构类型';
COMMENT ON COLUMN crmdm.cms_ent_info.financetype IS '金融机构类型';
COMMENT ON COLUMN crmdm.cms_ent_info.enterprisebelong IS '企业隶属';
COMMENT ON COLUMN crmdm.cms_ent_info.industrytype IS '国标行业分类';
COMMENT ON COLUMN crmdm.cms_ent_info.industrytype1 IS '行业类型一';
COMMENT ON COLUMN crmdm.cms_ent_info.industrytype2 IS '行业类型二';
COMMENT ON COLUMN crmdm.cms_ent_info.private IS '民营标志';
COMMENT ON COLUMN crmdm.cms_ent_info.economytype IS '经济类型';
COMMENT ON COLUMN crmdm.cms_ent_info.orgtype IS '企业类型';
COMMENT ON COLUMN crmdm.cms_ent_info.mostbusiness IS '经营范围';
COMMENT ON COLUMN crmdm.cms_ent_info.budgettype IS '预算管理类型';
COMMENT ON COLUMN crmdm.cms_ent_info.rccurrency IS '注册资本币种';
COMMENT ON COLUMN crmdm.cms_ent_info.registercapital IS '注册资本';
COMMENT ON COLUMN crmdm.cms_ent_info.pccurrency IS '实收资本币种';
COMMENT ON COLUMN crmdm.cms_ent_info.paiclupcapital IS '实收资本';
COMMENT ON COLUMN crmdm.cms_ent_info.fundsource IS '经费来源';
COMMENT ON COLUMN crmdm.cms_ent_info.totalassets IS '总资产';
COMMENT ON COLUMN crmdm.cms_ent_info.netassets IS '净资产';
COMMENT ON COLUMN crmdm.cms_ent_info.annualincome IS '年收入';
COMMENT ON COLUMN crmdm.cms_ent_info."scope" IS '企业规模';
COMMENT ON COLUMN crmdm.cms_ent_info.creditdate IS '与我行建立信贷关系时间';
COMMENT ON COLUMN crmdm.cms_ent_info.licenseno IS '工商营业执照号码';
COMMENT ON COLUMN crmdm.cms_ent_info.licensedate IS '营业执照登记日';
COMMENT ON COLUMN crmdm.cms_ent_info.licensematurity IS '营业执照到期日';
COMMENT ON COLUMN crmdm.cms_ent_info.setupdate IS '企业成立日期';
COMMENT ON COLUMN crmdm.cms_ent_info.inspectionyear IS '工商执照最新年检年份';
COMMENT ON COLUMN crmdm.cms_ent_info.locksituation IS '工商局锁定情况';
COMMENT ON COLUMN crmdm.cms_ent_info.taxno IS '税务登记证号(国税)';
COMMENT ON COLUMN crmdm.cms_ent_info.banklicense IS '金融机构许可证代码';
COMMENT ON COLUMN crmdm.cms_ent_info.managearea IS '金融机构经营区域范围';
COMMENT ON COLUMN crmdm.cms_ent_info.banchamount IS '金融机构一级分支机构数量';
COMMENT ON COLUMN crmdm.cms_ent_info.exchangeid IS '交换号';
COMMENT ON COLUMN crmdm.cms_ent_info.registeradd IS '注册地址';
COMMENT ON COLUMN crmdm.cms_ent_info.chargedepartment IS '上级主管单位';
COMMENT ON COLUMN crmdm.cms_ent_info.officeadd IS '办公地址';
COMMENT ON COLUMN crmdm.cms_ent_info.officezip IS '注册地址邮政编码';
COMMENT ON COLUMN crmdm.cms_ent_info.countrycode IS '所在国家(地区)';
COMMENT ON COLUMN crmdm.cms_ent_info.regioncode IS '省份、直辖市、自治区';
COMMENT ON COLUMN crmdm.cms_ent_info.villagecode IS '所属乡镇代码';
COMMENT ON COLUMN crmdm.cms_ent_info.villagename IS '所属乡镇名称';
COMMENT ON COLUMN crmdm.cms_ent_info.relativetype IS '机构电话';
COMMENT ON COLUMN crmdm.cms_ent_info.officetel IS '联系电话';
COMMENT ON COLUMN crmdm.cms_ent_info.officefax IS '传真电话';
COMMENT ON COLUMN crmdm.cms_ent_info.webadd IS '公司网址';
COMMENT ON COLUMN crmdm.cms_ent_info.emailadd IS '公司E－Mail';
COMMENT ON COLUMN crmdm.cms_ent_info.employeenumber IS '职工人数';
COMMENT ON COLUMN crmdm.cms_ent_info.mainproduction IS '主要产品情况';
COMMENT ON COLUMN crmdm.cms_ent_info.newtechcorpornot IS '是否高新技术企业';
COMMENT ON COLUMN crmdm.cms_ent_info.listingcorpornot IS '上市公司类型';
COMMENT ON COLUMN crmdm.cms_ent_info.hasieright IS '有无进出口经营权';
COMMENT ON COLUMN crmdm.cms_ent_info.hasdirectorate IS '有无董事会';
COMMENT ON COLUMN crmdm.cms_ent_info.basicbank IS '基本帐户行';
COMMENT ON COLUMN crmdm.cms_ent_info.basicaccount IS '基本帐户号';
COMMENT ON COLUMN crmdm.cms_ent_info.manageinfo IS '合法经营情况';
COMMENT ON COLUMN crmdm.cms_ent_info.customerhistory IS '客户历史沿革、管理水平简介';
COMMENT ON COLUMN crmdm.cms_ent_info.projectflag IS '企业目前是否有项目';
COMMENT ON COLUMN crmdm.cms_ent_info.realtyflag IS '是否从事房地产开发';
COMMENT ON COLUMN crmdm.cms_ent_info.workfieldarea IS '经营场地面积';
COMMENT ON COLUMN crmdm.cms_ent_info.workfieldfee IS '经营场地所有权';
COMMENT ON COLUMN crmdm.cms_ent_info.accountdate IS '在我行首次开立账户时间';
COMMENT ON COLUMN crmdm.cms_ent_info.loancardno IS '贷款卡号';
COMMENT ON COLUMN crmdm.cms_ent_info.loancardpassword IS '贷款卡密码';
COMMENT ON COLUMN crmdm.cms_ent_info.loancardinsyear IS '贷款卡最新年审年份';
COMMENT ON COLUMN crmdm.cms_ent_info.loancardinsresult IS '贷款卡最新年审结果';
COMMENT ON COLUMN crmdm.cms_ent_info.loanflag IS '贷款卡是否有效';
COMMENT ON COLUMN crmdm.cms_ent_info.financeornot IS '是否无需提供财报';
COMMENT ON COLUMN crmdm.cms_ent_info.financebelong IS '财务报表类型';
COMMENT ON COLUMN crmdm.cms_ent_info.creditbelong IS '信用等级评估模板名称';
COMMENT ON COLUMN crmdm.cms_ent_info.creditlevel IS '本行即期信用等级';
COMMENT ON COLUMN crmdm.cms_ent_info.evaluatedate IS '评估日期';
COMMENT ON COLUMN crmdm.cms_ent_info.othercreditlevel IS '外部机构评级结果';
COMMENT ON COLUMN crmdm.cms_ent_info.otherevaluatedate IS '外部机构评级日期';
COMMENT ON COLUMN crmdm.cms_ent_info.otherorgname IS '外部评级机构名称';
COMMENT ON COLUMN crmdm.cms_ent_info.inputorgid IS '登记机构';
COMMENT ON COLUMN crmdm.cms_ent_info.inputuserid IS '登记人';
COMMENT ON COLUMN crmdm.cms_ent_info.inputdate IS '登记日期';
COMMENT ON COLUMN crmdm.cms_ent_info.updateorgid IS '更新机构';
COMMENT ON COLUMN crmdm.cms_ent_info.updateuserid IS '更新人员';
COMMENT ON COLUMN crmdm.cms_ent_info.updatedate IS '更新日期';
COMMENT ON COLUMN crmdm.cms_ent_info.remark IS '备注';
COMMENT ON COLUMN crmdm.cms_ent_info.taxno1 IS '税务登记证号(地税)';
COMMENT ON COLUMN crmdm.cms_ent_info.fictitiouspersonid IS '法定代表人身份证号码';
COMMENT ON COLUMN crmdm.cms_ent_info.groupflag IS '集团客户标志';
COMMENT ON COLUMN crmdm.cms_ent_info.evaluatelevel IS '评估级别';
COMMENT ON COLUMN crmdm.cms_ent_info.mybank IS '我行开户行';
COMMENT ON COLUMN crmdm.cms_ent_info.mybankaccount IS '我行开户帐号';
COMMENT ON COLUMN crmdm.cms_ent_info.otherbank IS '他行开户行';
COMMENT ON COLUMN crmdm.cms_ent_info.otherbankaccount IS '他行开户帐号';
COMMENT ON COLUMN crmdm.cms_ent_info.tempsaveflag IS '暂存标志';
COMMENT ON COLUMN crmdm.cms_ent_info.financedepttel IS '财务部联系电话';
COMMENT ON COLUMN crmdm.cms_ent_info.ecgroupflag IS '是否征信标准集团客户';
COMMENT ON COLUMN crmdm.cms_ent_info.supercorpname IS '上级公司名称';
COMMENT ON COLUMN crmdm.cms_ent_info.superloancardno IS '上级公司贷款卡编号';
COMMENT ON COLUMN crmdm.cms_ent_info.supercerttype IS '上级公司证件类型';
COMMENT ON COLUMN crmdm.cms_ent_info.smeindustrytype IS '中小企业行业类型';
COMMENT ON COLUMN crmdm.cms_ent_info.sellsum IS '年销售额';
COMMENT ON COLUMN crmdm.cms_ent_info.supercertid IS '上级公司组织机构代码';
COMMENT ON COLUMN crmdm.cms_ent_info.officecountrycode IS '办公地址所在国家';
COMMENT ON COLUMN crmdm.cms_ent_info.officeregioncode IS '办公地址所在省市区';
COMMENT ON COLUMN crmdm.cms_ent_info.registerzip IS '注册地邮编';
COMMENT ON COLUMN crmdm.cms_ent_info.limitck IS '最高限额参考';
COMMENT ON COLUMN crmdm.cms_ent_info.sillerent IS '资金公司';
COMMENT ON COLUMN crmdm.cms_ent_info.industrialadjust IS '工业调整';
COMMENT ON COLUMN crmdm.cms_ent_info.industrialupgrading IS '是否企业调整';
COMMENT ON COLUMN crmdm.cms_ent_info.newindustry IS '新企业';
COMMENT ON COLUMN crmdm.cms_ent_info.czcountryent IS '所处国家';
COMMENT ON COLUMN crmdm.cms_ent_info.isfarming IS '是否产业';
COMMENT ON COLUMN crmdm.cms_ent_info.czareaname IS '区域的名称';
COMMENT ON COLUMN crmdm.cms_ent_info.registeraddecifid IS '注册地址ECIFID';
COMMENT ON COLUMN crmdm.cms_ent_info.officeaddecifid IS '办公地址ECIFID';
COMMENT ON COLUMN crmdm.cms_ent_info.officetelecifid IS '联系电话ECIFID';
COMMENT ON COLUMN crmdm.cms_ent_info.officefaxecifid IS '传真电话ECIFID';
COMMENT ON COLUMN crmdm.cms_ent_info.relativetypeecifid IS '机构电话ECIFID';
COMMENT ON COLUMN crmdm.cms_ent_info.emailaddecifid IS '公司E－MailECIFID';
COMMENT ON COLUMN crmdm.cms_ent_info.webaddecifid IS '公司网址ECIFID';
COMMENT ON COLUMN crmdm.cms_ent_info.unitycreditcode IS '社会统一信用代码';
COMMENT ON COLUMN crmdm.cms_ent_info.entnature IS '企业性质';
COMMENT ON COLUMN crmdm.cms_ent_info.otherreceivables IS '关联证书';
COMMENT ON COLUMN crmdm.cms_ent_info.czarea IS '所处区域';
COMMENT ON COLUMN crmdm.cms_ent_info.listingtype IS '上市类型';
COMMENT ON COLUMN crmdm.cms_ent_info.listingcountry IS '上市国家';
COMMENT ON COLUMN crmdm.cms_ent_info.listingcorpnumber IS '上市机构';
COMMENT ON COLUMN crmdm.cms_ent_info.financedate IS '上市时间';
COMMENT ON COLUMN crmdm.cms_ent_info.totaldebt IS '总资产';
COMMENT ON COLUMN crmdm.cms_ent_info.officeaddcode IS '办公地址所在国家';
COMMENT ON COLUMN crmdm.cms_ent_info.jxscope IS '公司领域';
COMMENT ON COLUMN crmdm.cms_ent_info.openaccontlicense IS '开户许可证号';
COMMENT ON COLUMN crmdm.cms_ent_info.regulatoryrating IS '监管评级结果';
COMMENT ON COLUMN crmdm.cms_ent_info.ratingfirmriting IS '评级公司评级结果';
COMMENT ON COLUMN crmdm.cms_ent_info.bankshareholder IS '是否本行股东';
COMMENT ON COLUMN crmdm.cms_ent_info.listingplace IS '上市地点';
COMMENT ON COLUMN crmdm.cms_ent_info.interbankquota IS '人民银行同意开办同业拆借的额度';
COMMENT ON COLUMN crmdm.cms_ent_info.taxpayerid IS '纳税人识别号';
COMMENT ON COLUMN crmdm.cms_ent_info.standardevlaresult IS '标普评级结果';
COMMENT ON COLUMN crmdm.cms_ent_info.moodyevlaresult IS '穆迪评级结果';
COMMENT ON COLUMN crmdm.cms_ent_info.otherevlaresult IS '其他可参考评级结果';
COMMENT ON COLUMN crmdm.cms_ent_info.bankid IS '金融机构代码';
COMMENT ON COLUMN crmdm.cms_ent_info.regdate IS '金融机构代码';
COMMENT ON COLUMN crmdm.cms_ent_info.fitchratresult IS '惠誉评级结果';
COMMENT ON COLUMN crmdm.cms_ent_info.hightechent IS '是否高科技企业';
COMMENT ON COLUMN crmdm.cms_ent_info.accountbussdate IS '首次发起业务的时间';
COMMENT ON COLUMN crmdm.cms_ent_info.otherreceive IS '其他应收款项';
COMMENT ON COLUMN crmdm.cms_ent_info.department IS '主管单位';
COMMENT ON COLUMN crmdm.cms_ent_info.interregion IS '所在国内地区';
COMMENT ON COLUMN crmdm.cms_ent_info.countryrisk IS '国别风险';
COMMENT ON COLUMN crmdm.cms_ent_info.certificatenum IS '法人证书编号';
COMMENT ON COLUMN crmdm.cms_ent_info.isfirstloanuser IS '是否首贷户';
COMMENT ON COLUMN crmdm.cms_ent_info.firstloandate IS '首贷年月';
COMMENT ON COLUMN crmdm.cms_ent_info.lastyearemployees IS '上年末从业人数（个）';
COMMENT ON COLUMN crmdm.cms_ent_info.lastyearbusinessincome IS '上年度营业收入（元）';
COMMENT ON COLUMN crmdm.cms_ent_info.lastyeartotalassets IS '上年末资产总额（元）';
COMMENT ON COLUMN crmdm.cms_ent_info.systemscope IS '系统企业规模';
COMMENT ON COLUMN crmdm.cms_ent_info.isspecialandnew IS '是否专精特新';
COMMENT ON COLUMN crmdm.cms_ent_info.belonggroupname IS '客户所属集团名称';
COMMENT ON COLUMN crmdm.cms_ent_info.isnewagriculture IS '是否新型农业经营主体';
COMMENT ON COLUMN crmdm.cms_ent_info.tjaddrcode IS '注册地址统计用行政区划代码';
COMMENT ON COLUMN crmdm.cms_ent_info.isfarmer IS '个体工商户是否农户(2-否 1-是)';
COMMENT ON COLUMN crmdm.cms_ent_info.ryzd IS '冗余字段';
