-- crmdm.ecif_t01_p_relationer_info 定义

-- Drop table

-- DROP TABLE crmdm.ecif_t01_p_relationer_info;

CREATE TABLE crmdm.ecif_t01_p_relationer_info (
	relation_id bpchar(20) NOT NULL, -- 关系人ID
	cert_issue_date sys."date" NULL, -- 证件核发日期
	cert_expd_date sys."date" NULL, -- 证件有效日期
	cert_org_area varchar(30) NULL, -- 发证机关所在地
	nat_code varchar(30) NULL, -- 国籍 C003
	gender varchar(30) NULL, -- 性别 C101
	birth_date sys."date" NULL, -- 出生日期
	educ_sign varchar(30) NULL, -- 最高学历 C106
	econ_resur varchar(30) NULL, -- 主要经济来源 C124
	work_corp varchar(120) NULL, -- 工作单位
	work_addr varchar(160) NULL, -- 单位地址
	unit_type varchar(30) NULL, -- 单位分类 C117
	industry_type varchar(30) NULL, -- 从事行业类型 C004
	profession varchar(30) NULL, -- 职业 C111
	poston varchar(30) NULL, -- 职务 C113
	tech_title varchar(30) NULL, -- 职称 C114
	year_salary numeric(20, 2) NULL, -- 个人年收入
	home_addr varchar(160) NULL, -- 家庭地址
	post_cd varchar(6) NULL, -- 邮政编码
	find_addr varchar(160) NULL, -- 联系地址
	findtel_no varchar(36) NULL, -- 联系电话
	mobile_no varchar(36) NULL, -- 手机号码
	contact_dept varchar(100) NULL, -- 联系部门
	fax_no varchar(36) NULL, -- 传真号码
	email varchar(160) NULL, -- 电子邮件
	url_addr varchar(160) NULL, -- 网址
	oicq_no varchar(20) NULL, -- QQ号码
	msg_addr varchar(80) NULL, -- 微信号码
	fancy_desc varchar(200) NULL, -- 个人爱好
	eff_status bpchar(1) NULL, -- 有效标志
	last_updated_te varchar(20) NULL, -- 更新柜员
	last_updated_org varchar(20) NULL, -- 更新机构号
	created_ts timestamp(6) NULL, -- 进入ECIF的时间
	updated_ts timestamp(6) NULL, -- 在ECIF中更新的时间
	init_system_id varchar(30) NOT NULL, -- 创建渠道 C019
	init_created_ts timestamp(6) NULL, -- 源系统创建时间
	last_system_id varchar(30) NOT NULL, -- 最新更新渠道 C019
	last_updated_ts timestamp(6) NULL, -- 最新更新时间
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.relation_id IS '关系人ID';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.cert_issue_date IS '证件核发日期';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.cert_expd_date IS '证件有效日期';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.cert_org_area IS '发证机关所在地';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.nat_code IS '国籍 C003';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.gender IS '性别 C101';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.birth_date IS '出生日期';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.educ_sign IS '最高学历 C106';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.econ_resur IS '主要经济来源 C124';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.work_corp IS '工作单位';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.work_addr IS '单位地址';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.unit_type IS '单位分类 C117';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.industry_type IS '从事行业类型 C004';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.profession IS '职业 C111';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.poston IS '职务 C113';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.tech_title IS '职称 C114';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.year_salary IS '个人年收入';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.home_addr IS '家庭地址';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.post_cd IS '邮政编码';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.find_addr IS '联系地址';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.findtel_no IS '联系电话';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.mobile_no IS '手机号码';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.contact_dept IS '联系部门';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.fax_no IS '传真号码';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.email IS '电子邮件';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.url_addr IS '网址';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.oicq_no IS 'QQ号码';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.msg_addr IS '微信号码';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.fancy_desc IS '个人爱好';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.eff_status IS '有效标志';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.last_updated_te IS '更新柜员';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.last_updated_org IS '更新机构号';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.created_ts IS '进入ECIF的时间';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.updated_ts IS '在ECIF中更新的时间';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.init_system_id IS '创建渠道 C019';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.init_created_ts IS '源系统创建时间';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.last_system_id IS '最新更新渠道 C019';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.last_updated_ts IS '最新更新时间';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.ryzd IS '冗余字段';
