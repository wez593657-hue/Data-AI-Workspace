-- crmdm.cbs_kdpa_zhduiz 定义

-- Drop table

-- DROP TABLE crmdm.cbs_kdpa_zhduiz;

CREATE TABLE crmdm.cbs_kdpa_zhduiz (
	farendma varchar(4) NOT NULL, -- 法人代码
	kehuzhao varchar(35) NOT NULL, -- 客户账号
	zhhaoxuh varchar(8) NOT NULL, -- 子账户序号
	kehuzhlx varchar(1) NOT NULL, -- 客户账号类型
	zhanghao varchar(40) NOT NULL, -- 负债账号
	zhhuxinz varchar(4) NULL, -- 账户性质
	huobdaih varchar(3) NOT NULL, -- 货币代号
	chaohubz varchar(1) NOT NULL, -- 账户钞汇标志
	mingxxuh numeric(19) NULL, -- 负债账号明细序号
	sfyzbzhi varchar(1) NULL, -- 是否有折标志
	zhhuztai varchar(1) NOT NULL, -- 账户状态
	weihguiy varchar(8) NOT NULL, -- 维护柜员
	weihjigo varchar(10) NOT NULL, -- 维护机构
	weihriqi varchar(8) NOT NULL, -- 维护日期
	weihshij varchar(9) NULL, -- 维护时间
	shijchuo numeric(19) NOT NULL, -- 时间戳
	jiluztai varchar(1) NOT NULL, -- 记录状态
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.cbs_kdpa_zhduiz.farendma IS '法人代码';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhduiz.kehuzhao IS '客户账号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhduiz.zhhaoxuh IS '子账户序号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhduiz.kehuzhlx IS '客户账号类型';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhduiz.zhanghao IS '负债账号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhduiz.zhhuxinz IS '账户性质';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhduiz.huobdaih IS '货币代号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhduiz.chaohubz IS '账户钞汇标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhduiz.mingxxuh IS '负债账号明细序号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhduiz.sfyzbzhi IS '是否有折标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhduiz.zhhuztai IS '账户状态';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhduiz.weihguiy IS '维护柜员';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhduiz.weihjigo IS '维护机构';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhduiz.weihriqi IS '维护日期';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhduiz.weihshij IS '维护时间';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhduiz.shijchuo IS '时间戳';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhduiz.jiluztai IS '记录状态';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhduiz.ryzd IS '冗余字段';
