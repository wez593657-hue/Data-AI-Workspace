-- crmdm.cbs_kbrp_jgcshu 定义

-- Drop table

-- DROP TABLE crmdm.cbs_kbrp_jgcshu;

CREATE TABLE crmdm.cbs_kbrp_jgcshu (
	farendma varchar(4) NOT NULL, -- 法人代码
	jigouhao varchar(10) NOT NULL, -- 营业机构号
	fenhdaim varchar(4) NOT NULL, -- 分行代码
	jigoleix varchar(1) NOT NULL, -- 机构类型
	jigouzwm varchar(500) NULL, -- 机构中文名称
	jigoujch varchar(50) NULL, -- 机构简称
	jigouywm varchar(500) NULL, -- 机构英文名称
	jigoujpi varchar(50) NULL, -- 机构简拼
	diqdaima varchar(20) NULL, -- 地区代号
	shengquh varchar(20) NULL, -- 省区代号
	dizhiiii varchar(500) NULL, -- 地址
	yinwendz varchar(200) NULL, -- 英文地址
	youzhnbm varchar(10) NULL, -- 邮政编码
	dianhhma varchar(20) NULL, -- 电话号码
	chunzhen varchar(40) NULL, -- 传真号码
	dbguahao varchar(20) NULL, -- 金融许可证号
	lianxirm varchar(500) NULL, -- 联系人
	lnxrdhua varchar(40) NULL, -- 联系人电话
	emaildiz varchar(200) NULL, -- email地址
	wangzhii varchar(200) NULL, -- 网址
	songbsbm varchar(20) NULL, -- 设备名
	dyduilmc varchar(20) NULL, -- 报表队列名
	fenhipdz varchar(32) NULL, -- 分行ip地址
	fenhport varchar(4) NULL, -- 分行port号
	cunzyhbz varchar(1) NULL, -- 村镇银行村志
	zmaoqubz varchar(1) NULL, -- 自贸区标志
	jgfwqdzm varchar(500) NULL, -- 机构服务器地址名称
	qiyongrq varchar(8) NULL, -- 启用
	beiyngzd varchar(200) NULL, -- 备用字段
	rowidddd varchar(30) NULL, -- 序列号
	weihguiy varchar(8) NOT NULL, -- 维护柜员
	weihjigo varchar(10) NOT NULL, -- 维护机构
	weihriqi varchar(8) NOT NULL, -- 维护日期
	weihshij varchar(9) NULL, -- 维护时间
	shijchuo numeric(19) NOT NULL, -- 时间戳
	jiluztai varchar(1) NOT NULL, -- 记录状态
	zjgcbibz varchar(1) NULL, -- 整机构撤并标志
	jingduxx varchar(200) NULL, -- 经度
	weiduxxz varchar(200) NULL, -- 纬度
	dgyiyesj varchar(200) NULL, -- 对公营业时间
	dsyiyesj varchar(200) NULL, -- 个人营业时间
	ssdiqudm varchar(12) NULL, -- 行政区划代码
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.farendma IS '法人代码';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.jigouhao IS '营业机构号';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.fenhdaim IS '分行代码';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.jigoleix IS '机构类型';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.jigouzwm IS '机构中文名称';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.jigoujch IS '机构简称';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.jigouywm IS '机构英文名称';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.jigoujpi IS '机构简拼';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.diqdaima IS '地区代号';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.shengquh IS '省区代号';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.dizhiiii IS '地址';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.yinwendz IS '英文地址';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.youzhnbm IS '邮政编码';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.dianhhma IS '电话号码';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.chunzhen IS '传真号码';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.dbguahao IS '金融许可证号';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.lianxirm IS '联系人';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.lnxrdhua IS '联系人电话';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.emaildiz IS 'email地址';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.wangzhii IS '网址';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.songbsbm IS '设备名';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.dyduilmc IS '报表队列名';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.fenhipdz IS '分行ip地址';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.fenhport IS '分行port号';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.cunzyhbz IS '村镇银行村志';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.zmaoqubz IS '自贸区标志';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.jgfwqdzm IS '机构服务器地址名称';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.qiyongrq IS '启用';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.beiyngzd IS '备用字段';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.rowidddd IS '序列号';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.weihguiy IS '维护柜员';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.weihjigo IS '维护机构';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.weihriqi IS '维护日期';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.weihshij IS '维护时间';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.shijchuo IS '时间戳';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.jiluztai IS '记录状态';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.zjgcbibz IS '整机构撤并标志';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.jingduxx IS '经度';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.weiduxxz IS '纬度';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.dgyiyesj IS '对公营业时间';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.dsyiyesj IS '个人营业时间';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.ssdiqudm IS '行政区划代码';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.ryzd IS '冗余字段';
