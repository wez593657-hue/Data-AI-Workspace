-- crmdm.cbs_kbrp_jycshu 定义

-- Drop table

-- DROP TABLE crmdm.cbs_kbrp_jycshu;

CREATE TABLE crmdm.cbs_kbrp_jycshu (
	farendma varchar(4) NOT NULL, -- 法人代码
	jiaoyima varchar(20) NOT NULL, -- 交易码
	jiaoyimc varchar(200) NULL, -- 交易名称
	fenhfanw varchar(4) NULL, -- 分行范围
	jigoufwe varchar(10) NULL, -- 机构范围
	bizhfanw varchar(2) NULL, -- 币种范围
	chpfawei varchar(10) NULL, -- 产品范围
	qudaofaw varchar(3) NULL, -- 渠道范围
	kehulxfw varchar(2) NULL, -- 客户类型范围
	sfhecalx varchar(1) NULL, -- 身份核查类型
	jiarczbz varchar(1) NULL, -- 假日操作标志
	drmzyxbz varchar(1) NULL, -- 当日抹帐允许标志
	grmzyxbz varchar(1) NULL, -- 隔日抹帐允许标志
	jiaoyifs varchar(1) NULL, -- 交易方式
	jioyzxms varchar(1) NULL, -- 交易执行模式
	qxjcfshi varchar(1) NULL, -- 交易检查标志
	joyizblb varchar(1000) NULL, -- 交易组别列表
	kuajgczb varchar(1) NULL, -- 跨机构操作标志
	shouqzle varchar(1) NULL, -- 授权种类
	bizhsxxx varchar(1) NULL, -- 币种顺序
	qhtsqboz varchar(1) NULL, -- 前后台授权标志
	ercilrbz varchar(1) NULL, -- 授权二次录入标志
	shoqjibe varchar(1) NULL, -- 授权级别
	shoqfans varchar(1) NULL, -- 授权方式
	bendsqcs numeric(19) NULL, -- 本地授权次数
	shoqcjdm varchar(10) NULL, -- 授权层级代码
	jigyyjib varchar(1) NULL, -- 授权机构级别
	shoqjigo varchar(10) NULL, -- 授权机构
	shoqguiy varchar(8) NULL, -- 授权柜员
	kajigoth varchar(1) NULL, -- 机构替换标志
	thzhzidm varchar(20) NULL, -- 替换帐号字段名
	jioyshux varchar(1) NULL, -- 交易属性
	jiaoyleb varchar(1) NULL, -- 交易类别
	guiylslx varchar(1) NULL, -- 柜员流水类型
	fujinejz varchar(1) NULL, -- 负金额记账允许标志
	fuwumasj varchar(20) NULL, -- 服务码
	zjlaiyqx varchar(20) NULL, -- 资金来源去向检查字段名
	jyjdjczd varchar(20) NULL, -- 借贷检查字段名
	jigohozd varchar(20) NULL, -- 机构号检查字段名
	chpjczid varchar(20) NULL, -- 产品代码检查字段名
	kehhjczd varchar(20) NULL, -- 客户号检查字段名
	zhjchazd varchar(20) NULL, -- 帐号检查字段名
	hbdhjczd varchar(20) NULL, -- 货币代号检查字段名
	chhjczid varchar(20) NULL, -- 钞汇检查字段
	zhleixzd varchar(20) NULL, -- 帐号类型检查字段名
	zhxhaozd varchar(20) NULL, -- 帐号序号检查字段名
	qishisji numeric(19) NULL, -- 起始时间
	zhongzsj numeric(19) NULL, -- 终止时间
	yemianfh varchar(1) NULL, -- 页面返回
	beiyngzd varchar(200) NULL, -- 备用字段1
	rowidddd varchar(30) NULL, -- 序列号
	weihguiy varchar(8) NOT NULL, -- 维护柜员
	weihjigo varchar(10) NOT NULL, -- 维护机构
	weihriqi varchar(8) NOT NULL, -- 维护日期
	weihshij varchar(9) NULL, -- 维护时间
	shijchuo numeric(19) NOT NULL, -- 时间戳
	jiluztai varchar(1) NOT NULL, -- 记录状态
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.farendma IS '法人代码';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.jiaoyima IS '交易码';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.jiaoyimc IS '交易名称';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.fenhfanw IS '分行范围';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.jigoufwe IS '机构范围';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.bizhfanw IS '币种范围';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.chpfawei IS '产品范围';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.qudaofaw IS '渠道范围';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.kehulxfw IS '客户类型范围';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.sfhecalx IS '身份核查类型';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.jiarczbz IS '假日操作标志';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.drmzyxbz IS '当日抹帐允许标志';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.grmzyxbz IS '隔日抹帐允许标志';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.jiaoyifs IS '交易方式';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.jioyzxms IS '交易执行模式';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.qxjcfshi IS '交易检查标志';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.joyizblb IS '交易组别列表';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.kuajgczb IS '跨机构操作标志';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.shouqzle IS '授权种类';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.bizhsxxx IS '币种顺序';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.qhtsqboz IS '前后台授权标志';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.ercilrbz IS '授权二次录入标志';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.shoqjibe IS '授权级别';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.shoqfans IS '授权方式';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.bendsqcs IS '本地授权次数';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.shoqcjdm IS '授权层级代码';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.jigyyjib IS '授权机构级别';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.shoqjigo IS '授权机构';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.shoqguiy IS '授权柜员';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.kajigoth IS '机构替换标志';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.thzhzidm IS '替换帐号字段名';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.jioyshux IS '交易属性';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.jiaoyleb IS '交易类别';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.guiylslx IS '柜员流水类型';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.fujinejz IS '负金额记账允许标志';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.fuwumasj IS '服务码';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.zjlaiyqx IS '资金来源去向检查字段名';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.jyjdjczd IS '借贷检查字段名';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.jigohozd IS '机构号检查字段名';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.chpjczid IS '产品代码检查字段名';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.kehhjczd IS '客户号检查字段名';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.zhjchazd IS '帐号检查字段名';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.hbdhjczd IS '货币代号检查字段名';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.chhjczid IS '钞汇检查字段';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.zhleixzd IS '帐号类型检查字段名';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.zhxhaozd IS '帐号序号检查字段名';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.qishisji IS '起始时间';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.zhongzsj IS '终止时间';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.yemianfh IS '页面返回';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.beiyngzd IS '备用字段1';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.rowidddd IS '序列号';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.weihguiy IS '维护柜员';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.weihjigo IS '维护机构';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.weihriqi IS '维护日期';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.weihshij IS '维护时间';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.shijchuo IS '时间戳';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.jiluztai IS '记录状态';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.ryzd IS '冗余字段';
