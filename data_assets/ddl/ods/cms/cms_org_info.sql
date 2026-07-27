-- crmdm.cms_org_info 定义

-- Drop table

-- DROP TABLE crmdm.cms_org_info;

CREATE TABLE crmdm.cms_org_info (
	orgid varchar(32) NULL, -- 机构编号
	sortno varchar(32) NULL, -- 排序号
	orgname varchar(80) NULL, -- 机构名称
	orglevel varchar(32) NULL, -- 级别
	orgproperty varchar(250) NULL, -- 属性集
	relativeorgid varchar(32) NULL, -- 相关机构代码
	bankid varchar(32) NULL, -- 人行金融机构代码
	banklicense varchar(32) NULL, -- 金融机构许可证
	businesslicense varchar(32) NULL, -- 营业执照
	belongarea varchar(18) NULL, -- 机构辖区
	orgclass varchar(18) NULL, -- 机构类别
	zipcode varchar(18) NULL, -- 邮政编码
	mainframeorgid varchar(32) NULL, -- 网点号
	mainframeexgid varchar(32) NULL, -- 交换号
	orgcode varchar(32) NULL, -- 机构编码
	status varchar(80) NULL, -- 状态
	orgoldname varchar(80) NULL, -- 机构曾用名
	setupdate varchar(10) NULL, -- 成立时间
	orgadd varchar(80) NULL, -- 机构地址
	principal varchar(10) NULL, -- 负责人
	orgtel varchar(80) NULL, -- 联系电话
	branchnum numeric(22) NULL, -- 管辖网点数
	cmnum numeric(22) NULL, -- 客户经理数
	businesshours varchar(80) NULL, -- 营业时间
	inputorg varchar(32) NULL, -- 登记单位
	inputuser varchar(32) NULL, -- 登记人
	inputdate varchar(20) NULL, -- 登记日期
	inputtime varchar(20) NULL, -- 登记时间
	updateuser varchar(32) NULL, -- 更新人
	updatetime varchar(20) NULL, -- 更新时间
	updatedate varchar(20) NULL, -- 更新日期
	remark varchar(250) NULL, -- 备注
	belongorgid varchar(32) NULL, -- 权属机构
	hostno varchar(10) NULL, -- 主机号
	vitualserialno numeric(22) NULL, -- 虚拟流水号
	vitualid varchar(32) NULL, -- 虚拟柜员号
	corporgid varchar(20) NULL, -- 法人机构编号
	corporgname varchar(32) NULL, -- 法人机构名称
	orgfax varchar(32) NULL, -- 机构传真
	clearbankno varchar(32) NULL, -- 大额行号
	accountingorgflag varchar(1) NULL, -- 是否账务机构
	spesubbranchflag varchar(1) NULL, -- 是否特色支行
	corporateorgname varchar(60) NULL, -- 核心机构名称
	ryzd varchar(1) NULL
);
CREATE INDEX index_crmdm_cms_org_info_index_1 ON crmdm.cms_org_info USING btree (orgid);
COMMENT ON TABLE crmdm.cms_org_info IS '信贷机构信息表';

-- Column comments

COMMENT ON COLUMN crmdm.cms_org_info.orgid IS '机构编号        ';
COMMENT ON COLUMN crmdm.cms_org_info.sortno IS '排序号          ';
COMMENT ON COLUMN crmdm.cms_org_info.orgname IS '机构名称        ';
COMMENT ON COLUMN crmdm.cms_org_info.orglevel IS '级别            ';
COMMENT ON COLUMN crmdm.cms_org_info.orgproperty IS '属性集          ';
COMMENT ON COLUMN crmdm.cms_org_info.relativeorgid IS '相关机构代码    ';
COMMENT ON COLUMN crmdm.cms_org_info.bankid IS '人行金融机构代码';
COMMENT ON COLUMN crmdm.cms_org_info.banklicense IS '金融机构许可证  ';
COMMENT ON COLUMN crmdm.cms_org_info.businesslicense IS '营业执照        ';
COMMENT ON COLUMN crmdm.cms_org_info.belongarea IS '机构辖区        ';
COMMENT ON COLUMN crmdm.cms_org_info.orgclass IS '机构类别        ';
COMMENT ON COLUMN crmdm.cms_org_info.zipcode IS '邮政编码        ';
COMMENT ON COLUMN crmdm.cms_org_info.mainframeorgid IS '网点号          ';
COMMENT ON COLUMN crmdm.cms_org_info.mainframeexgid IS '交换号          ';
COMMENT ON COLUMN crmdm.cms_org_info.orgcode IS '机构编码        ';
COMMENT ON COLUMN crmdm.cms_org_info.status IS '状态            ';
COMMENT ON COLUMN crmdm.cms_org_info.orgoldname IS '机构曾用名      ';
COMMENT ON COLUMN crmdm.cms_org_info.setupdate IS '成立时间        ';
COMMENT ON COLUMN crmdm.cms_org_info.orgadd IS '机构地址        ';
COMMENT ON COLUMN crmdm.cms_org_info.principal IS '负责人          ';
COMMENT ON COLUMN crmdm.cms_org_info.orgtel IS '联系电话        ';
COMMENT ON COLUMN crmdm.cms_org_info.branchnum IS '管辖网点数      ';
COMMENT ON COLUMN crmdm.cms_org_info.cmnum IS '客户经理数      ';
COMMENT ON COLUMN crmdm.cms_org_info.businesshours IS '营业时间        ';
COMMENT ON COLUMN crmdm.cms_org_info.inputorg IS '登记单位        ';
COMMENT ON COLUMN crmdm.cms_org_info.inputuser IS '登记人          ';
COMMENT ON COLUMN crmdm.cms_org_info.inputdate IS '登记日期        ';
COMMENT ON COLUMN crmdm.cms_org_info.inputtime IS '登记时间        ';
COMMENT ON COLUMN crmdm.cms_org_info.updateuser IS '更新人          ';
COMMENT ON COLUMN crmdm.cms_org_info.updatetime IS '更新时间        ';
COMMENT ON COLUMN crmdm.cms_org_info.updatedate IS '更新日期        ';
COMMENT ON COLUMN crmdm.cms_org_info.remark IS '备注            ';
COMMENT ON COLUMN crmdm.cms_org_info.belongorgid IS '权属机构        ';
COMMENT ON COLUMN crmdm.cms_org_info.hostno IS '主机号          ';
COMMENT ON COLUMN crmdm.cms_org_info.vitualserialno IS '虚拟流水号      ';
COMMENT ON COLUMN crmdm.cms_org_info.vitualid IS '虚拟柜员号      ';
COMMENT ON COLUMN crmdm.cms_org_info.corporgid IS '法人机构编号    ';
COMMENT ON COLUMN crmdm.cms_org_info.corporgname IS '法人机构名称    ';
COMMENT ON COLUMN crmdm.cms_org_info.orgfax IS '机构传真        ';
COMMENT ON COLUMN crmdm.cms_org_info.clearbankno IS '大额行号        ';
COMMENT ON COLUMN crmdm.cms_org_info.accountingorgflag IS '是否账务机构    ';
COMMENT ON COLUMN crmdm.cms_org_info.spesubbranchflag IS '是否特色支行    ';
COMMENT ON COLUMN crmdm.cms_org_info.corporateorgname IS '核心机构名称    ';
