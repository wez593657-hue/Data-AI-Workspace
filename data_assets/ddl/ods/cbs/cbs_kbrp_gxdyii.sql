-- crmdm.cbs_kbrp_gxdyii 定义

-- Drop table

-- DROP TABLE crmdm.cbs_kbrp_gxdyii;

CREATE TABLE crmdm.cbs_kbrp_gxdyii (
	farendma varchar(4) NOT NULL, -- 法人代码
	guanxizl varchar(2) NOT NULL, -- 关系种类
	relnamee varchar(6) NOT NULL, -- 业务关系名
	yewugxms varchar(200) NOT NULL, -- 关系描述
	yewugxzl varchar(6) NULL, -- 业务关系种类
	guanxbzg varchar(1) NULL, -- 关系币种规则
	guanxshj varchar(1) NULL, -- 关系多上级
	guxiqxjc varchar(1) NULL, -- 关系权限继承
	moduleee varchar(2) NULL, -- 模块
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

COMMENT ON COLUMN crmdm.cbs_kbrp_gxdyii.farendma IS '法人代码';
COMMENT ON COLUMN crmdm.cbs_kbrp_gxdyii.guanxizl IS '关系种类';
COMMENT ON COLUMN crmdm.cbs_kbrp_gxdyii.relnamee IS '业务关系名';
COMMENT ON COLUMN crmdm.cbs_kbrp_gxdyii.yewugxms IS '关系描述';
COMMENT ON COLUMN crmdm.cbs_kbrp_gxdyii.yewugxzl IS '业务关系种类';
COMMENT ON COLUMN crmdm.cbs_kbrp_gxdyii.guanxbzg IS '关系币种规则';
COMMENT ON COLUMN crmdm.cbs_kbrp_gxdyii.guanxshj IS '关系多上级';
COMMENT ON COLUMN crmdm.cbs_kbrp_gxdyii.guxiqxjc IS '关系权限继承';
COMMENT ON COLUMN crmdm.cbs_kbrp_gxdyii.moduleee IS '模块';
COMMENT ON COLUMN crmdm.cbs_kbrp_gxdyii.shenming IS '说明';
COMMENT ON COLUMN crmdm.cbs_kbrp_gxdyii.beiyngzd IS '备用字段';
COMMENT ON COLUMN crmdm.cbs_kbrp_gxdyii.rowidddd IS '序列号';
COMMENT ON COLUMN crmdm.cbs_kbrp_gxdyii.weihguiy IS '维护柜员';
COMMENT ON COLUMN crmdm.cbs_kbrp_gxdyii.weihjigo IS '维护机构';
COMMENT ON COLUMN crmdm.cbs_kbrp_gxdyii.weihriqi IS '维护日期';
COMMENT ON COLUMN crmdm.cbs_kbrp_gxdyii.weihshij IS '维护时间';
COMMENT ON COLUMN crmdm.cbs_kbrp_gxdyii.shijchuo IS '时间戳';
COMMENT ON COLUMN crmdm.cbs_kbrp_gxdyii.jiluztai IS '记录状态';
COMMENT ON COLUMN crmdm.cbs_kbrp_gxdyii.ryzd IS '冗余字段';
