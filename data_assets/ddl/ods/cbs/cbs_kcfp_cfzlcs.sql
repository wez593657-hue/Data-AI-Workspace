-- crmdm.cbs_kcfp_cfzlcs 定义

-- Drop table

-- DROP TABLE crmdm.cbs_kcfp_cfzlcs;

CREATE TABLE crmdm.cbs_kcfp_cfzlcs (
	farendma varchar(4) NOT NULL, -- 法人代码
	canshmch varchar(500) NOT NULL, -- 参数名称
	canshuzh varchar(35) NOT NULL, -- 参数值
	cansshju varchar(80) NULL, -- 参数数据
	beiyshju varchar(80) NULL, -- 备用数据
	canshshm varchar(200) NOT NULL, -- 参数说明
	xuliehao varchar(30) NULL, -- 序列号
	weihguiy varchar(8) NOT NULL, -- 维护柜员
	weihjigo varchar(10) NOT NULL, -- 维护机构
	weihriqi varchar(8) NOT NULL, -- 维护日期
	weihshij varchar(9) NULL, -- 维护时间
	shijchuo numeric(19) NOT NULL, -- 时间戳
	jiluztai varchar(1) NOT NULL, -- 记录状态
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.cbs_kcfp_cfzlcs.farendma IS '法人代码';
COMMENT ON COLUMN crmdm.cbs_kcfp_cfzlcs.canshmch IS '参数名称';
COMMENT ON COLUMN crmdm.cbs_kcfp_cfzlcs.canshuzh IS '参数值';
COMMENT ON COLUMN crmdm.cbs_kcfp_cfzlcs.cansshju IS '参数数据';
COMMENT ON COLUMN crmdm.cbs_kcfp_cfzlcs.beiyshju IS '备用数据';
COMMENT ON COLUMN crmdm.cbs_kcfp_cfzlcs.canshshm IS '参数说明';
COMMENT ON COLUMN crmdm.cbs_kcfp_cfzlcs.xuliehao IS '序列号';
COMMENT ON COLUMN crmdm.cbs_kcfp_cfzlcs.weihguiy IS '维护柜员';
COMMENT ON COLUMN crmdm.cbs_kcfp_cfzlcs.weihjigo IS '维护机构';
COMMENT ON COLUMN crmdm.cbs_kcfp_cfzlcs.weihriqi IS '维护日期';
COMMENT ON COLUMN crmdm.cbs_kcfp_cfzlcs.weihshij IS '维护时间';
COMMENT ON COLUMN crmdm.cbs_kcfp_cfzlcs.shijchuo IS '时间戳';
COMMENT ON COLUMN crmdm.cbs_kcfp_cfzlcs.jiluztai IS '记录状态';
COMMENT ON COLUMN crmdm.cbs_kcfp_cfzlcs.ryzd IS '冗余字段';
