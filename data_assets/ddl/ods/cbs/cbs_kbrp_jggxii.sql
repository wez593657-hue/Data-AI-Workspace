-- crmdm.cbs_kbrp_jggxii 定义

-- Drop table

-- DROP TABLE crmdm.cbs_kbrp_jggxii;

CREATE TABLE crmdm.cbs_kbrp_jggxii (
	farendma varchar(4) NOT NULL, -- 法人代码
	jigouhao varchar(10) NOT NULL, -- 机构号
	yewugxzl varchar(6) NOT NULL, -- 业务关系种类
	bizhjihe varchar(3) NOT NULL, -- 币种集合
	yewugxjg varchar(10) NOT NULL, -- 业务关系机构
	yewugxjb varchar(1) NOT NULL, -- 业务关系级别
	guxiqxjg varchar(10) NULL, -- 关系权限机构
	shenming varchar(200) NULL, -- 说明
	beiyngzd varchar(200) NULL, -- 备用字段
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

COMMENT ON COLUMN crmdm.cbs_kbrp_jggxii.farendma IS '法人代码';
COMMENT ON COLUMN crmdm.cbs_kbrp_jggxii.jigouhao IS '机构号';
COMMENT ON COLUMN crmdm.cbs_kbrp_jggxii.yewugxzl IS '业务关系种类';
COMMENT ON COLUMN crmdm.cbs_kbrp_jggxii.bizhjihe IS '币种集合';
COMMENT ON COLUMN crmdm.cbs_kbrp_jggxii.yewugxjg IS '业务关系机构';
COMMENT ON COLUMN crmdm.cbs_kbrp_jggxii.yewugxjb IS '业务关系级别';
COMMENT ON COLUMN crmdm.cbs_kbrp_jggxii.guxiqxjg IS '关系权限机构';
COMMENT ON COLUMN crmdm.cbs_kbrp_jggxii.shenming IS '说明';
COMMENT ON COLUMN crmdm.cbs_kbrp_jggxii.beiyngzd IS '备用字段';
COMMENT ON COLUMN crmdm.cbs_kbrp_jggxii.rowidddd IS '序列号';
COMMENT ON COLUMN crmdm.cbs_kbrp_jggxii.weihguiy IS '维护柜员';
COMMENT ON COLUMN crmdm.cbs_kbrp_jggxii.weihjigo IS '维护机构';
COMMENT ON COLUMN crmdm.cbs_kbrp_jggxii.weihriqi IS '维护日期';
COMMENT ON COLUMN crmdm.cbs_kbrp_jggxii.weihshij IS '维护时间';
COMMENT ON COLUMN crmdm.cbs_kbrp_jggxii.shijchuo IS '时间戳';
COMMENT ON COLUMN crmdm.cbs_kbrp_jggxii.jiluztai IS '记录状态';
COMMENT ON COLUMN crmdm.cbs_kbrp_jggxii.ryzd IS '冗余字段';
