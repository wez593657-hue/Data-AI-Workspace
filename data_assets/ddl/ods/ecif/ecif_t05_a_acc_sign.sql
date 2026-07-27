-- crmdm.ecif_t05_a_acc_sign 定义

-- Drop table

-- DROP TABLE crmdm.ecif_t05_a_acc_sign;

CREATE TABLE crmdm.ecif_t05_a_acc_sign (
	acc_sign_id bpchar(20) NOT NULL, -- 账户签约ID
	sign_prd_2 varchar(200) NULL, -- 签约产品2
	sign_prd_3 varchar(200) NULL, -- 签约产品3
	balance_dis_flag bpchar(1) NULL, -- 账户余额显示标志 C009
	sign_org varchar(20) NULL, -- 签约机构
	sign_oper varchar(30) NULL, -- 签约柜员
	sign_date sys."date" NULL, -- 签约日期
	close_org varchar(20) NULL, -- 解约机构
	close_oper varchar(30) NULL, -- 解约柜员
	close_date sys."date" NULL, -- 解约日期
	sign_rel_addr varchar(160) NULL, -- 联系地址
	sign_rel_phone varchar(36) NULL, -- 联系电话
	sign_rel_name varchar(120) NULL, -- 联系人名称
	attn_name varchar(120) NULL, -- 经办人名称
	attn_cert_type varchar(30) NULL, -- 经办人证件类型 C001
	attn_cert_no varchar(30) NULL, -- 经办人证件号码
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

COMMENT ON COLUMN crmdm.ecif_t05_a_acc_sign.acc_sign_id IS '账户签约ID';
COMMENT ON COLUMN crmdm.ecif_t05_a_acc_sign.sign_prd_2 IS '签约产品2';
COMMENT ON COLUMN crmdm.ecif_t05_a_acc_sign.sign_prd_3 IS '签约产品3';
COMMENT ON COLUMN crmdm.ecif_t05_a_acc_sign.balance_dis_flag IS '账户余额显示标志 C009';
COMMENT ON COLUMN crmdm.ecif_t05_a_acc_sign.sign_org IS '签约机构';
COMMENT ON COLUMN crmdm.ecif_t05_a_acc_sign.sign_oper IS '签约柜员';
COMMENT ON COLUMN crmdm.ecif_t05_a_acc_sign.sign_date IS '签约日期';
COMMENT ON COLUMN crmdm.ecif_t05_a_acc_sign.close_org IS '解约机构';
COMMENT ON COLUMN crmdm.ecif_t05_a_acc_sign.close_oper IS '解约柜员';
COMMENT ON COLUMN crmdm.ecif_t05_a_acc_sign.close_date IS '解约日期';
COMMENT ON COLUMN crmdm.ecif_t05_a_acc_sign.sign_rel_addr IS '联系地址';
COMMENT ON COLUMN crmdm.ecif_t05_a_acc_sign.sign_rel_phone IS '联系电话';
COMMENT ON COLUMN crmdm.ecif_t05_a_acc_sign.sign_rel_name IS '联系人名称';
COMMENT ON COLUMN crmdm.ecif_t05_a_acc_sign.attn_name IS '经办人名称';
COMMENT ON COLUMN crmdm.ecif_t05_a_acc_sign.attn_cert_type IS '经办人证件类型 C001';
COMMENT ON COLUMN crmdm.ecif_t05_a_acc_sign.attn_cert_no IS '经办人证件号码';
COMMENT ON COLUMN crmdm.ecif_t05_a_acc_sign.last_updated_te IS '更新柜员';
COMMENT ON COLUMN crmdm.ecif_t05_a_acc_sign.last_updated_org IS '更新机构号';
COMMENT ON COLUMN crmdm.ecif_t05_a_acc_sign.created_ts IS '进入ECIF的时间';
COMMENT ON COLUMN crmdm.ecif_t05_a_acc_sign.updated_ts IS '在ECIF中更新的时间';
COMMENT ON COLUMN crmdm.ecif_t05_a_acc_sign.init_system_id IS '创建渠道 C019';
COMMENT ON COLUMN crmdm.ecif_t05_a_acc_sign.init_created_ts IS '源系统创建时间';
COMMENT ON COLUMN crmdm.ecif_t05_a_acc_sign.last_system_id IS '最新更新渠道 C019';
COMMENT ON COLUMN crmdm.ecif_t05_a_acc_sign.last_updated_ts IS '最新更新时间';
COMMENT ON COLUMN crmdm.ecif_t05_a_acc_sign.ryzd IS '冗余字段';
