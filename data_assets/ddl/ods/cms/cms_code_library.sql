-- crmdm.cms_code_library 定义

-- Drop table

-- DROP TABLE crmdm.cms_code_library;

CREATE TABLE crmdm.cms_code_library (
	codeno varchar(32) NOT NULL, -- 代码编号
	itemno varchar(32) NOT NULL, -- 代码项编号
	itemname varchar(250) NULL, -- 项目名称
	bankno varchar(32) NULL, -- 征信代码
	sortno varchar(32) NULL, -- 排序号
	isinuse varchar(18) NULL, -- 是否使用
	itemdescribe varchar(800) NULL, -- 项目描述
	itemattribute varchar(800) NULL, -- 项目属性
	relativecode varchar(4000) NULL, -- 关联代码
	attribute1 varchar(800) NULL, -- 属性1
	attribute2 varchar(800) NULL, -- 属性2
	attribute3 varchar(800) NULL, -- 属性3
	attribute4 varchar(4000) NULL, -- 属性4
	attribute5 varchar(250) NULL, -- 属性5
	attribute6 varchar(250) NULL, -- 属性6
	attribute7 varchar(250) NULL, -- 属性7
	attribute8 varchar(250) NULL, -- 属性8
	inputuser varchar(32) NULL, -- 录入人
	inputorg varchar(32) NULL, -- 录入机构
	inputtime varchar(20) NULL, -- 录入时间
	updateuser varchar(32) NULL, -- 更新人
	updatetime varchar(20) NULL, -- 更新时间
	remark varchar(250) NULL, -- 备注
	helptext varchar(250) NULL, -- 帮助
	relativeno varchar(32) NULL, -- ECIF代码
	hxcode varchar(32) NULL, -- 核心代码
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_cms_code_library PRIMARY KEY (codeno, itemno)
);

-- Column comments

COMMENT ON COLUMN crmdm.cms_code_library.codeno IS '代码编号';
COMMENT ON COLUMN crmdm.cms_code_library.itemno IS '代码项编号';
COMMENT ON COLUMN crmdm.cms_code_library.itemname IS '项目名称';
COMMENT ON COLUMN crmdm.cms_code_library.bankno IS '征信代码';
COMMENT ON COLUMN crmdm.cms_code_library.sortno IS '排序号';
COMMENT ON COLUMN crmdm.cms_code_library.isinuse IS '是否使用';
COMMENT ON COLUMN crmdm.cms_code_library.itemdescribe IS '项目描述';
COMMENT ON COLUMN crmdm.cms_code_library.itemattribute IS '项目属性';
COMMENT ON COLUMN crmdm.cms_code_library.relativecode IS '关联代码';
COMMENT ON COLUMN crmdm.cms_code_library.attribute1 IS '属性1';
COMMENT ON COLUMN crmdm.cms_code_library.attribute2 IS '属性2';
COMMENT ON COLUMN crmdm.cms_code_library.attribute3 IS '属性3';
COMMENT ON COLUMN crmdm.cms_code_library.attribute4 IS '属性4';
COMMENT ON COLUMN crmdm.cms_code_library.attribute5 IS '属性5';
COMMENT ON COLUMN crmdm.cms_code_library.attribute6 IS '属性6';
COMMENT ON COLUMN crmdm.cms_code_library.attribute7 IS '属性7';
COMMENT ON COLUMN crmdm.cms_code_library.attribute8 IS '属性8';
COMMENT ON COLUMN crmdm.cms_code_library.inputuser IS '录入人';
COMMENT ON COLUMN crmdm.cms_code_library.inputorg IS '录入机构';
COMMENT ON COLUMN crmdm.cms_code_library.inputtime IS '录入时间';
COMMENT ON COLUMN crmdm.cms_code_library.updateuser IS '更新人';
COMMENT ON COLUMN crmdm.cms_code_library.updatetime IS '更新时间';
COMMENT ON COLUMN crmdm.cms_code_library.remark IS '备注';
COMMENT ON COLUMN crmdm.cms_code_library.helptext IS '帮助';
COMMENT ON COLUMN crmdm.cms_code_library.relativeno IS 'ECIF代码';
COMMENT ON COLUMN crmdm.cms_code_library.hxcode IS '核心代码';
COMMENT ON COLUMN crmdm.cms_code_library.ryzd IS '冗余字段';
