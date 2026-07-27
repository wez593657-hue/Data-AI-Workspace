-- crmdm.cbs_kcda_pzjcxx 定义

-- Drop table

-- DROP TABLE crmdm.cbs_kcda_pzjcxx;

CREATE TABLE crmdm.cbs_kcda_pzjcxx (
	farendma varchar(4) NOT NULL, -- 法人代码
	kahaoooo varchar(35) NOT NULL, -- 卡号
	kehuhaoo varchar(16) NULL, -- 客户号
	chanphao varchar(10) NOT NULL, -- 产品编号
	kaxingzh varchar(1) NOT NULL, -- 卡种性质
	kazhongl varchar(1) NOT NULL, -- 卡种类
	kajiezhi varchar(1) NOT NULL, -- 卡介质
	kadxiang varchar(1) NOT NULL, -- 卡对象
	ckrzwenm varchar(500) NULL, -- 持卡人中文名
	ckrmpyin varchar(500) NULL, -- 持卡人姓名拼音
	kadengji varchar(1) NOT NULL, -- 卡等级
	zhukahao varchar(35) NULL, -- 主卡号
	youwuzbz varchar(10) NULL, -- 有无折标志
	ksqjigou varchar(10) NULL, -- 卡申请机构
	ksqriqii varchar(8) NULL, -- 卡申请日期
	fakajigo varchar(10) NULL, -- 发卡机构
	fakariqi varchar(8) NULL, -- 发卡日期
	fakaguiy varchar(8) NULL, -- 发卡柜员
	fakafngs varchar(1) NULL, -- 发卡方式
	hxiojigo varchar(10) NULL, -- 核销机构
	hxioriqi varchar(8) NULL, -- 核销日期
	hxioguiy varchar(8) NULL, -- 核销柜员
	xlaommbz varchar(1) NULL, -- 新老密码标志
	youxriqi varchar(200) NULL, -- 有效日期
	pzsyztai varchar(1) NOT NULL, -- 凭证使用状态
	sfymmfbz varchar(1) NOT NULL, -- 需要密码封标志
	fakaqdao varchar(7) NULL, -- 发卡渠道
	fkalxren varchar(500) NULL, -- 发卡联系人
	weixjigo varchar(10) NULL, -- 尾箱账务机构
	jccvnnbz varchar(1) NULL, -- 检查CVN标志
	gnkzhibz varchar(1) NULL, -- 功能控制标志
	yuxhriqi varchar(8) NULL, -- 预销户日期
	vipptkbz varchar(2) NULL, -- VIP/普卡标志
	ygkbiaoz varchar(1) NULL, -- 员工卡标志
	sfzdxqbz varchar(1) NULL, -- 自动续期标志
	sfzdxkbz varchar(1) NULL, -- 自动续卡标志
	sfcszdbz varchar(1) NULL, -- 产生对账单标志
	gjkbiaoz varchar(1) NULL, -- 国际卡标志
	yikatobz varchar(1) NULL, -- 一卡通标志
	xlaokabz varchar(1) NULL, -- 新老卡标志
	sbkbiaoz varchar(1) NULL, -- 社保卡标志
	gzkbiaoz varchar(1) NULL, -- 工资卡标志
	mnnfqiii varchar(8) NULL, -- 免年费期
	weihguiy varchar(8) NOT NULL, -- 维护柜员
	weihjigo varchar(10) NOT NULL, -- 维护机构
	weihriqi varchar(8) NOT NULL, -- 维护日期
	weihshij varchar(9) NULL, -- 维护时间
	shijchuo numeric(19) NOT NULL, -- 时间戳
	jiluztai varchar(1) NOT NULL, -- 记录状态
	shifskbz varchar(1) NULL, -- 是否锁卡标志
	gmjmjioy varchar(10) NULL, -- 国密加密校验位
	gmmacjyw varchar(10) NULL, -- 国密MAC校验位
	gmmaczxx varchar(2000) NULL, -- 国密MAC值信息
	gmzjmipz varchar(2000) NULL, -- 国密四级字段转加密配置
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.farendma IS '法人代码';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.kahaoooo IS '卡号';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.kehuhaoo IS '客户号';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.chanphao IS '产品编号';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.kaxingzh IS '卡种性质';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.kazhongl IS '卡种类';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.kajiezhi IS '卡介质';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.kadxiang IS '卡对象';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.ckrzwenm IS '持卡人中文名';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.ckrmpyin IS '持卡人姓名拼音';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.kadengji IS '卡等级';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.zhukahao IS '主卡号';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.youwuzbz IS '有无折标志';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.ksqjigou IS '卡申请机构';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.ksqriqii IS '卡申请日期';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.fakajigo IS '发卡机构';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.fakariqi IS '发卡日期';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.fakaguiy IS '发卡柜员';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.fakafngs IS '发卡方式';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.hxiojigo IS '核销机构';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.hxioriqi IS '核销日期';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.hxioguiy IS '核销柜员';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.xlaommbz IS '新老密码标志';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.youxriqi IS '有效日期';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.pzsyztai IS '凭证使用状态';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.sfymmfbz IS '需要密码封标志';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.fakaqdao IS '发卡渠道';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.fkalxren IS '发卡联系人';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.weixjigo IS '尾箱账务机构';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.jccvnnbz IS '检查CVN标志';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.gnkzhibz IS '功能控制标志';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.yuxhriqi IS '预销户日期';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.vipptkbz IS 'VIP/普卡标志';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.ygkbiaoz IS '员工卡标志';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.sfzdxqbz IS '自动续期标志';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.sfzdxkbz IS '自动续卡标志';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.sfcszdbz IS '产生对账单标志';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.gjkbiaoz IS '国际卡标志';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.yikatobz IS '一卡通标志';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.xlaokabz IS '新老卡标志';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.sbkbiaoz IS '社保卡标志';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.gzkbiaoz IS '工资卡标志';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.mnnfqiii IS '免年费期';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.weihguiy IS '维护柜员';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.weihjigo IS '维护机构';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.weihriqi IS '维护日期';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.weihshij IS '维护时间';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.shijchuo IS '时间戳';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.jiluztai IS '记录状态';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.shifskbz IS '是否锁卡标志';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.gmjmjioy IS '国密加密校验位';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.gmmacjyw IS '国密MAC校验位';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.gmmaczxx IS '国密MAC值信息';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.gmzjmipz IS '国密四级字段转加密配置';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.ryzd IS '冗余字段';
