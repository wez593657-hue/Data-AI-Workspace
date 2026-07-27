-- crmdm.ecif_t01_p_rel_com_info 定义

-- Drop table

-- DROP TABLE crmdm.ecif_t01_p_rel_com_info;

CREATE TABLE crmdm.ecif_t01_p_rel_com_info (
	relation_id bpchar(20) NOT NULL, -- 关系人ID
	cert_expd_date sys."date" NULL, -- 证件到期日期
	govn_cert_no varchar(30) NULL, -- 营业执照号码
	govn_efft_date sys."date" NULL, -- 营业执照生效日期
	govn_expd_date sys."date" NULL, -- 营业执照有效日期
	acct_lic_no varchar(30) NULL, -- 开户许可证编号
	loan_card_no varchar(30) NULL, -- 贷款卡号
	org_code varchar(20) NULL, -- 组织机构代码
	unit_credit_code varchar(30) NULL, -- 机构信用代码
	reg_date sys."date" NULL, -- 注册日期(企业成立日期)
	reg_cptl numeric(20, 2) NULL, -- 注册资本(元)
	reg_cptl_curr varchar(30) NULL, -- 注册资本币别 C008
	paid_cptl numeric(20, 2) NULL, -- 实收资本(元)
	paid_cptl_curr varchar(30) NULL, -- 实收资本币别 C008
	comp_size varchar(30) NULL, -- 企业规模 C204
	register_add varchar(160) NULL, -- 注册地址
	comp_type varchar(30) NULL, -- 企业类型 C202
	industry_type varchar(30) NULL, -- 行业类别 C004
	econ_kind varchar(30) NULL, -- 经济性质 C203
	admn_type varchar(1600) NULL, -- 经营范围
	tax_reg_no varchar(30) NULL, -- 税务登记编号(国税)
	tax_area_no varchar(30) NULL, -- 税务登记编号(地税)
	legal_name varchar(100) NULL, -- 法定代表人姓名
	legal_cert_type varchar(30) NULL, -- 法人证件种类 C001
	legal_cert_no varchar(30) NULL, -- 法人证件号码
	legal_cert_expd_date sys."date" NULL, -- 法人证件到期日
	post_cd varchar(6) NULL, -- 邮政编码
	region_code varchar(30) NULL, -- 所在行政区域 C007
	office_tel varchar(36) NULL, -- 联系电话
	office_fax varchar(36) NULL, -- 传真号码
	web_add varchar(160) NULL, -- 公司网址
	email_add varchar(160) NULL, -- 公司邮件地址
	com_add varchar(160) NULL, -- 公司地址
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

COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.relation_id IS '关系人ID';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.cert_expd_date IS '证件到期日期';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.govn_cert_no IS '营业执照号码';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.govn_efft_date IS '营业执照生效日期';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.govn_expd_date IS '营业执照有效日期';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.acct_lic_no IS '开户许可证编号';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.loan_card_no IS '贷款卡号';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.org_code IS '组织机构代码';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.unit_credit_code IS '机构信用代码';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.reg_date IS '注册日期(企业成立日期)';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.reg_cptl IS '注册资本(元)';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.reg_cptl_curr IS '注册资本币别 C008';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.paid_cptl IS '实收资本(元)';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.paid_cptl_curr IS '实收资本币别 C008';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.comp_size IS '企业规模 C204';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.register_add IS '注册地址';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.comp_type IS '企业类型 C202';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.industry_type IS '行业类别 C004';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.econ_kind IS '经济性质 C203';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.admn_type IS '经营范围';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.tax_reg_no IS '税务登记编号(国税)';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.tax_area_no IS '税务登记编号(地税)';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.legal_name IS '法定代表人姓名';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.legal_cert_type IS '法人证件种类 C001';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.legal_cert_no IS '法人证件号码';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.legal_cert_expd_date IS '法人证件到期日';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.post_cd IS '邮政编码';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.region_code IS '所在行政区域 C007';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.office_tel IS '联系电话';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.office_fax IS '传真号码';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.web_add IS '公司网址';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.email_add IS '公司邮件地址';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.com_add IS '公司地址';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.eff_status IS '有效标志';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.last_updated_te IS '更新柜员';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.last_updated_org IS '更新机构号';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.created_ts IS '进入ECIF的时间';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.updated_ts IS '在ECIF中更新的时间';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.init_system_id IS '创建渠道 C019';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.init_created_ts IS '源系统创建时间';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.last_system_id IS '最新更新渠道 C019';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.last_updated_ts IS '最新更新时间';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.ryzd IS '冗余字段';
