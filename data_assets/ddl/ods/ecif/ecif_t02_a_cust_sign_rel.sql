-- crmdm.ecif_t02_a_cust_sign_rel 定义

-- Drop table

-- DROP TABLE crmdm.ecif_t02_a_cust_sign_rel;

CREATE TABLE crmdm.ecif_t02_a_cust_sign_rel (
	sign_seq_id bpchar(20) NULL, -- 签约记录编号
	party_id bpchar(20) NULL, -- 参与人ID
	sign_sys_no varchar(30) NULL, -- 签约系统编号 C019
	acc_sign_no varchar(20) NULL, -- 签约编号
	sign_type varchar(30) NULL, -- 签约类型 C029
	sign_edit varchar(30) NULL, -- 签约版本 C034
	sign_acc_type varchar(30) NULL, -- 签约账户类型 C027
	sign_acc_no varchar(40) NULL, -- 签约客户账号
	old_sign_acc varchar(40) NULL, -- 原签约账号
	init_sign_acc varchar(40) NULL, -- 初始签约账号
	sign_prd_no varchar(200) NULL, -- 签约主产品
	sign_prd_desc varchar(200) NULL, -- 签约主产品描述
	sign_main_prd_flg bpchar(1) NULL, -- 签约主产品标志 C009
	sign_arr_no varchar(100) NULL, -- 签约协议号
	sign_state bpchar(1) NULL, -- 签约状态
	acc_sign_id bpchar(20) NULL, -- 账户签约ID
	sign_tab_id bpchar(8) NULL, -- 签约表ID
	role_id bpchar(20) NULL, -- 签约角色ID
	role_tab_id bpchar(8) NULL, -- 签约角色表ID
	acc_name varchar(200) NULL, -- 签约账户名称
	expd_date sys."date" NULL, -- 过期日期
	sign_info_ext_1 varchar(30) NULL, -- 签约信息扩展1
	sign_info_ext_2 varchar(30) NULL, -- 签约信息扩展2
	sign_info_ext_3 varchar(30) NULL, -- 签约信息扩展3
	sign_info_ext_4 varchar(512) NULL, -- 签约信息扩展4
	sign_info_ext_5 varchar(512) NULL, -- 签约信息扩展5
	last_updated_te varchar(20) NULL, -- 更新柜员
	last_updated_org varchar(20) NULL, -- 更新机构号
	created_ts timestamp(6) NULL, -- 进入ECIF的时间
	updated_ts timestamp(6) NULL, -- 在ECIF中更新的时间
	init_system_id varchar(30) NULL, -- 创建渠道 C019
	init_created_ts timestamp(6) NULL, -- 源系统创建时间
	last_system_id varchar(30) NULL, -- 最新更新渠道 C019
	last_updated_ts timestamp(6) NULL, -- 最新更新时间
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.sign_seq_id IS '签约记录编号';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.party_id IS '参与人ID';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.sign_sys_no IS '签约系统编号 C019';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.acc_sign_no IS '签约编号';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.sign_type IS '签约类型 C029';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.sign_edit IS '签约版本 C034';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.sign_acc_type IS '签约账户类型 C027';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.sign_acc_no IS '签约客户账号';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.old_sign_acc IS '原签约账号';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.init_sign_acc IS '初始签约账号';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.sign_prd_no IS '签约主产品';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.sign_prd_desc IS '签约主产品描述';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.sign_main_prd_flg IS '签约主产品标志 C009';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.sign_arr_no IS '签约协议号';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.sign_state IS '签约状态';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.acc_sign_id IS '账户签约ID';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.sign_tab_id IS '签约表ID';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.role_id IS '签约角色ID';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.role_tab_id IS '签约角色表ID';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.acc_name IS '签约账户名称';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.expd_date IS '过期日期';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.sign_info_ext_1 IS '签约信息扩展1';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.sign_info_ext_2 IS '签约信息扩展2';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.sign_info_ext_3 IS '签约信息扩展3';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.sign_info_ext_4 IS '签约信息扩展4';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.sign_info_ext_5 IS '签约信息扩展5';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.last_updated_te IS '更新柜员';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.last_updated_org IS '更新机构号';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.created_ts IS '进入ECIF的时间';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.updated_ts IS '在ECIF中更新的时间';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.init_system_id IS '创建渠道 C019';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.init_created_ts IS '源系统创建时间';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.last_system_id IS '最新更新渠道 C019';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.last_updated_ts IS '最新更新时间';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.ryzd IS '冗余字段';
