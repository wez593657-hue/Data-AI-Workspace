-- crmdm.mbk_cust_info 定义

-- Drop table

-- DROP TABLE crmdm.mbk_cust_info;

CREATE TABLE crmdm.mbk_cust_info (
	cust_no varchar(32) NOT NULL, -- 客户号
	cert_id varchar(64) NULL, -- 证书ID
	incorp_no varchar(16) NULL, -- 法人编号
	cust_core_no varchar(16) NULL, -- 核心客户号
	cust_name varchar(64) NULL, -- 客户姓名
	cust_cert_type varchar(6) NULL, -- 证件类型（建议按照核心或ECIF证件类型规则）
	cust_cert_no varchar(80) NULL, -- 证件号码
	cust_mobile varchar(11) NOT NULL, -- 签约手机号(交易认证使用)
	cust_lgn_name varchar(32) NULL, -- 登录用户名
	cust_cap_lvl varchar(2) NOT NULL, -- 客户等级 01-1级 02-2级 03-3级
	cust_is_idtfy_verify bpchar(1) NOT NULL, -- 是否实名认证/是否开通网银(Y-是;N-否)
	cust_org_no varchar(16) NULL, -- 客户归属机构
	cust_open_date varchar(10) NOT NULL, -- 客户开通日期
	cust_open_time varchar(8) NOT NULL, -- 客户开通时间
	cust_open_chnl varchar(3) NOT NULL, -- 首次开通渠道MB:手机 NB:网银 TB:柜面 DB:直销银行
	cust_status bpchar(1) NOT NULL, -- 客户状态(0:注销1: 正常2: 累计密码错误冻结3： 柜面冻结4: 被占用（手机号被重复注册时用）)
	cust_freeze_date varchar(10) NULL, -- 冻结日期
	cust_freeze_time varchar(8) NULL, -- 冻结时间
	cust_close_date varchar(10) NULL, -- 注销日期
	cust_close_time varchar(8) NULL, -- 注销时间
	cust_idtfy_verify_num varchar(10) NULL, -- 实名认证错误次数
	cust_is_old bpchar(1) NULL, -- 是否为老用户(0:是 1:否 2:柜面)
	cust_old_password bpchar(1) NULL, -- 旧密码是否更新(0:是 1:否)
	encrypt_type bpchar(1) NULL, -- 加密方式1:SM3 2:MD5 3:INIT
	is_first varchar(1) NULL, -- 第一次使用互转Y:是N:否
	user_last_login_date varchar(10) NULL, -- 最近登录日期
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_mbk_cust_info PRIMARY KEY (cust_no)
);

-- Column comments

COMMENT ON COLUMN crmdm.mbk_cust_info.cust_no IS '客户号';
COMMENT ON COLUMN crmdm.mbk_cust_info.cert_id IS '证书ID';
COMMENT ON COLUMN crmdm.mbk_cust_info.incorp_no IS '法人编号';
COMMENT ON COLUMN crmdm.mbk_cust_info.cust_core_no IS '核心客户号';
COMMENT ON COLUMN crmdm.mbk_cust_info.cust_name IS '客户姓名';
COMMENT ON COLUMN crmdm.mbk_cust_info.cust_cert_type IS '证件类型（建议按照核心或ECIF证件类型规则）';
COMMENT ON COLUMN crmdm.mbk_cust_info.cust_cert_no IS '证件号码';
COMMENT ON COLUMN crmdm.mbk_cust_info.cust_mobile IS '签约手机号(交易认证使用)';
COMMENT ON COLUMN crmdm.mbk_cust_info.cust_lgn_name IS '登录用户名';
COMMENT ON COLUMN crmdm.mbk_cust_info.cust_cap_lvl IS '客户等级 01-1级 02-2级 03-3级';
COMMENT ON COLUMN crmdm.mbk_cust_info.cust_is_idtfy_verify IS '是否实名认证/是否开通网银(Y-是;N-否)';
COMMENT ON COLUMN crmdm.mbk_cust_info.cust_org_no IS '客户归属机构';
COMMENT ON COLUMN crmdm.mbk_cust_info.cust_open_date IS '客户开通日期';
COMMENT ON COLUMN crmdm.mbk_cust_info.cust_open_time IS '客户开通时间';
COMMENT ON COLUMN crmdm.mbk_cust_info.cust_open_chnl IS '首次开通渠道MB:手机 NB:网银 TB:柜面 DB:直销银行';
COMMENT ON COLUMN crmdm.mbk_cust_info.cust_status IS '客户状态(0:注销1: 正常2: 累计密码错误冻结3： 柜面冻结4: 被占用（手机号被重复注册时用）)';
COMMENT ON COLUMN crmdm.mbk_cust_info.cust_freeze_date IS '冻结日期';
COMMENT ON COLUMN crmdm.mbk_cust_info.cust_freeze_time IS '冻结时间';
COMMENT ON COLUMN crmdm.mbk_cust_info.cust_close_date IS '注销日期';
COMMENT ON COLUMN crmdm.mbk_cust_info.cust_close_time IS '注销时间';
COMMENT ON COLUMN crmdm.mbk_cust_info.cust_idtfy_verify_num IS '实名认证错误次数';
COMMENT ON COLUMN crmdm.mbk_cust_info.cust_is_old IS '是否为老用户(0:是 1:否 2:柜面)';
COMMENT ON COLUMN crmdm.mbk_cust_info.cust_old_password IS '旧密码是否更新(0:是 1:否)';
COMMENT ON COLUMN crmdm.mbk_cust_info.encrypt_type IS '加密方式1:SM3 2:MD5 3:INIT';
COMMENT ON COLUMN crmdm.mbk_cust_info.is_first IS '第一次使用互转Y:是N:否';
COMMENT ON COLUMN crmdm.mbk_cust_info.user_last_login_date IS '最近登录日期';
COMMENT ON COLUMN crmdm.mbk_cust_info.ryzd IS '冗余字段';
