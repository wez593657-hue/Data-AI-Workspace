-- crmdm.cms_customer_belong 定义

-- Drop table

-- DROP TABLE crmdm.cms_customer_belong;

CREATE TABLE crmdm.cms_customer_belong (
	customerid varchar(40) NOT NULL, -- 客户编号
	orgid varchar(40) NOT NULL, -- 所属机构
	userid varchar(40) NOT NULL, -- 用户编号
	belongattribute varchar(80) NULL, -- 客户主办权
	belongattribute1 varchar(80) NULL, -- 信息查看权
	belongattribute2 varchar(80) NULL, -- 信息维护权
	belongattribute3 varchar(80) NULL, -- 业务申办权
	belongattribute4 varchar(80) NULL, -- 低风险业务办理权
	inputuserid varchar(80) NULL, -- 输入用户编号
	inputorgid varchar(80) NULL, -- 输入机构编号
	inputdate varchar(80) NULL, -- 输入日期
	updatedate varchar(10) NULL, -- 更新日期
	applyattribute varchar(80) NULL, -- 是否申请信息主办权
	applyattribute1 varchar(80) NULL, -- 是否申请信息查看权
	applyattribute2 varchar(80) NULL, -- 是否申请信息维护权
	applyattribute3 varchar(80) NULL, -- 是否申请业务申办权
	applyattribute4 varchar(80) NULL, -- 申请属性4
	remark varchar(250) NULL, -- 备注
	applystatus varchar(20) NULL, -- 权限申请状态
	applyreason varchar(500) NULL, -- 申请理由
	applyright varchar(20) NULL, -- 审批机构号
	applytype varchar(20) NULL, -- 申请类型
	ryzd varchar(1) NULL
);
CREATE UNIQUE INDEX index_crmdm_cms_customer_belong_index_1 ON crmdm.cms_customer_belong USING btree (customerid, orgid, userid);

-- Column comments

COMMENT ON COLUMN crmdm.cms_customer_belong.customerid IS '客户编号';
COMMENT ON COLUMN crmdm.cms_customer_belong.orgid IS '所属机构';
COMMENT ON COLUMN crmdm.cms_customer_belong.userid IS '用户编号';
COMMENT ON COLUMN crmdm.cms_customer_belong.belongattribute IS '客户主办权';
COMMENT ON COLUMN crmdm.cms_customer_belong.belongattribute1 IS '信息查看权';
COMMENT ON COLUMN crmdm.cms_customer_belong.belongattribute2 IS '信息维护权';
COMMENT ON COLUMN crmdm.cms_customer_belong.belongattribute3 IS '业务申办权';
COMMENT ON COLUMN crmdm.cms_customer_belong.belongattribute4 IS '低风险业务办理权';
COMMENT ON COLUMN crmdm.cms_customer_belong.inputuserid IS '输入用户编号';
COMMENT ON COLUMN crmdm.cms_customer_belong.inputorgid IS '输入机构编号';
COMMENT ON COLUMN crmdm.cms_customer_belong.inputdate IS '输入日期';
COMMENT ON COLUMN crmdm.cms_customer_belong.updatedate IS '更新日期';
COMMENT ON COLUMN crmdm.cms_customer_belong.applyattribute IS '是否申请信息主办权';
COMMENT ON COLUMN crmdm.cms_customer_belong.applyattribute1 IS '是否申请信息查看权';
COMMENT ON COLUMN crmdm.cms_customer_belong.applyattribute2 IS '是否申请信息维护权';
COMMENT ON COLUMN crmdm.cms_customer_belong.applyattribute3 IS '是否申请业务申办权';
COMMENT ON COLUMN crmdm.cms_customer_belong.applyattribute4 IS '申请属性4';
COMMENT ON COLUMN crmdm.cms_customer_belong.remark IS '备注';
COMMENT ON COLUMN crmdm.cms_customer_belong.applystatus IS '权限申请状态';
COMMENT ON COLUMN crmdm.cms_customer_belong.applyreason IS '申请理由';
COMMENT ON COLUMN crmdm.cms_customer_belong.applyright IS '审批机构号';
COMMENT ON COLUMN crmdm.cms_customer_belong.applytype IS '申请类型';
