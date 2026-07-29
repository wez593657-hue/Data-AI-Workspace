-- crmdm.uepp_pay_aml_mer_info 定义

-- Drop table

-- DROP TABLE crmdm.uepp_pay_aml_mer_info;

CREATE TABLE crmdm.uepp_pay_aml_mer_info (
	merch_id varchar(20) NOT NULL, -- 商户编号
	merch_name varchar(200) NULL, -- 商户名称
	merch_tel varchar(32) NULL, -- 营业电话号码（客服电话）
	merch_addr varchar(200) NULL, -- 商户地址
	merch_org_id varchar(20) NULL, -- 签约机构代码
	in_bank varchar(1) NULL, -- 结算账号是否本行开户
	acct_id varchar(64) NULL, -- 结算账号
	is_cust varchar(1) NULL, -- 是否本行商户
	cust_id varchar(32) NULL, -- 本行客户号
	merch_mcc varchar(4) NULL, -- 商户类型
	linkman varchar(96) NULL, -- 联系人姓名
	link_cert_type varchar(48) NULL, -- 联系人证件类型
	link_cert_no varchar(60) NULL, -- 联系人证件号码
	link_tel varchar(32) NULL, -- 联系人电话号码
	link_cell varchar(32) NULL, -- 联系人移动电话号码
	rsrv_01 varchar(32) NULL, -- 备用字段1
	rsrv_02 varchar(32) NULL, -- 备用字段2
	rsrv_03 varchar(32) NULL, -- 备用字段3
	rsrv_04 varchar(32) NULL, -- 备用字段4
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_uepp_pay_aml_mer_info PRIMARY KEY (merch_id)
);

-- Column comments

COMMENT ON COLUMN crmdm.uepp_pay_aml_mer_info.merch_id IS '商户编号';
COMMENT ON COLUMN crmdm.uepp_pay_aml_mer_info.merch_name IS '商户名称';
COMMENT ON COLUMN crmdm.uepp_pay_aml_mer_info.merch_tel IS '营业电话号码（客服电话）';
COMMENT ON COLUMN crmdm.uepp_pay_aml_mer_info.merch_addr IS '商户地址';
COMMENT ON COLUMN crmdm.uepp_pay_aml_mer_info.merch_org_id IS '签约机构代码';
COMMENT ON COLUMN crmdm.uepp_pay_aml_mer_info.in_bank IS '结算账号是否本行开户';
COMMENT ON COLUMN crmdm.uepp_pay_aml_mer_info.acct_id IS '结算账号';
COMMENT ON COLUMN crmdm.uepp_pay_aml_mer_info.is_cust IS '是否本行商户';
COMMENT ON COLUMN crmdm.uepp_pay_aml_mer_info.cust_id IS '本行客户号';
COMMENT ON COLUMN crmdm.uepp_pay_aml_mer_info.merch_mcc IS '商户类型';
COMMENT ON COLUMN crmdm.uepp_pay_aml_mer_info.linkman IS '联系人姓名';
COMMENT ON COLUMN crmdm.uepp_pay_aml_mer_info.link_cert_type IS '联系人证件类型';
COMMENT ON COLUMN crmdm.uepp_pay_aml_mer_info.link_cert_no IS '联系人证件号码';
COMMENT ON COLUMN crmdm.uepp_pay_aml_mer_info.link_tel IS '联系人电话号码';
COMMENT ON COLUMN crmdm.uepp_pay_aml_mer_info.link_cell IS '联系人移动电话号码';
COMMENT ON COLUMN crmdm.uepp_pay_aml_mer_info.rsrv_01 IS '备用字段1';
COMMENT ON COLUMN crmdm.uepp_pay_aml_mer_info.rsrv_02 IS '备用字段2';
COMMENT ON COLUMN crmdm.uepp_pay_aml_mer_info.rsrv_03 IS '备用字段3';
COMMENT ON COLUMN crmdm.uepp_pay_aml_mer_info.rsrv_04 IS '备用字段4';
COMMENT ON COLUMN crmdm.uepp_pay_aml_mer_info.ryzd IS '冗余字段';
