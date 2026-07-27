-- crmdm.mbk_cust_detail_info 定义

-- Drop table

-- DROP TABLE crmdm.mbk_cust_detail_info;

CREATE TABLE crmdm.mbk_cust_detail_info (
	cust_no varchar(32) NULL, -- 电子银行客户号
	ecif_no varchar(32) NULL, -- ECIF客户号
	ecif_mobile varchar(11) NULL, -- ECIF手机号
	idt_end_date varchar(10) NULL, -- 证件到期日
	cust_eng_name varchar(60) NULL, -- 英文名
	cust_sex bpchar(1) NULL, -- 性别
	cust_birth varchar(20) NULL, -- 出生日期
	cust_contact_tel varchar(20) NULL, -- 联系电话
	cust_addr varchar(200) NULL, -- 联系地址
	cust_zip_code varchar(6) NULL, -- 邮编
	cust_email varchar(50) NULL, -- 电子邮箱
	cust_is_emp bpchar(1) NULL, -- 员工标识
	portrait_url varchar(200) NULL, -- 上传头像URL
	cust_manager varchar(32) NULL, -- 客户经理编号
	cust_mem_lvl varchar(2) NULL, -- 客户会员等级
	cust_growth int4 NULL, -- 客户成长值
	cust_credit int4 NULL, -- 客户信用度
	cust_mkt_org_no varchar(16) NULL, -- 客户营销机构
	ryzd varchar(1) NULL
);
COMMENT ON TABLE crmdm.mbk_cust_detail_info IS '客户详细信息';

-- Column comments

COMMENT ON COLUMN crmdm.mbk_cust_detail_info.cust_no IS '电子银行客户号';
COMMENT ON COLUMN crmdm.mbk_cust_detail_info.ecif_no IS 'ECIF客户号    ';
COMMENT ON COLUMN crmdm.mbk_cust_detail_info.ecif_mobile IS 'ECIF手机号    ';
COMMENT ON COLUMN crmdm.mbk_cust_detail_info.idt_end_date IS '证件到期日    ';
COMMENT ON COLUMN crmdm.mbk_cust_detail_info.cust_eng_name IS '英文名        ';
COMMENT ON COLUMN crmdm.mbk_cust_detail_info.cust_sex IS '性别          ';
COMMENT ON COLUMN crmdm.mbk_cust_detail_info.cust_birth IS '出生日期      ';
COMMENT ON COLUMN crmdm.mbk_cust_detail_info.cust_contact_tel IS '联系电话      ';
COMMENT ON COLUMN crmdm.mbk_cust_detail_info.cust_addr IS '联系地址      ';
COMMENT ON COLUMN crmdm.mbk_cust_detail_info.cust_zip_code IS '邮编          ';
COMMENT ON COLUMN crmdm.mbk_cust_detail_info.cust_email IS '电子邮箱      ';
COMMENT ON COLUMN crmdm.mbk_cust_detail_info.cust_is_emp IS '员工标识      ';
COMMENT ON COLUMN crmdm.mbk_cust_detail_info.portrait_url IS '上传头像URL   ';
COMMENT ON COLUMN crmdm.mbk_cust_detail_info.cust_manager IS '客户经理编号  ';
COMMENT ON COLUMN crmdm.mbk_cust_detail_info.cust_mem_lvl IS '客户会员等级  ';
COMMENT ON COLUMN crmdm.mbk_cust_detail_info.cust_growth IS '客户成长值    ';
COMMENT ON COLUMN crmdm.mbk_cust_detail_info.cust_credit IS '客户信用度    ';
COMMENT ON COLUMN crmdm.mbk_cust_detail_info.cust_mkt_org_no IS '客户营销机构  ';
