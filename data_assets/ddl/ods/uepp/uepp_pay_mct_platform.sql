-- crmdm.uepp_pay_mct_platform 定义

-- Drop table

-- DROP TABLE crmdm.uepp_pay_mct_platform;

CREATE TABLE crmdm.uepp_pay_mct_platform (
	r_id varchar(40) NOT NULL, -- 平台商户二级商户关联ID
	platform_mct_id varchar(40) NULL, -- 平台商户id
	secondary_mct_id varchar(40) NULL, -- 二级商户id
	secondary_fre_rate numeric(16, 4) NULL, -- 平台分润比例‰
	create_user varchar(40) NULL, -- 创建创建操作人
	create_time varchar(20) NULL, -- 创建时间  yyyyMMDDHHmmssSSS
	update_user varchar(40) NULL, -- 更新操作人
	update_time varchar(20) NULL, -- 更新时间 yyyyMMDDHHmmssSSS
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_uepp_pay_mct_platform PRIMARY KEY (r_id)
);

-- Column comments

COMMENT ON COLUMN crmdm.uepp_pay_mct_platform.r_id IS '平台商户二级商户关联ID';
COMMENT ON COLUMN crmdm.uepp_pay_mct_platform.platform_mct_id IS '平台商户id';
COMMENT ON COLUMN crmdm.uepp_pay_mct_platform.secondary_mct_id IS '二级商户id';
COMMENT ON COLUMN crmdm.uepp_pay_mct_platform.secondary_fre_rate IS '平台分润比例‰';
COMMENT ON COLUMN crmdm.uepp_pay_mct_platform.create_user IS '创建创建操作人';
COMMENT ON COLUMN crmdm.uepp_pay_mct_platform.create_time IS '创建时间  yyyyMMDDHHmmssSSS';
COMMENT ON COLUMN crmdm.uepp_pay_mct_platform.update_user IS '更新操作人';
COMMENT ON COLUMN crmdm.uepp_pay_mct_platform.update_time IS '更新时间 yyyyMMDDHHmmssSSS';
COMMENT ON COLUMN crmdm.uepp_pay_mct_platform.ryzd IS '冗余字段';
