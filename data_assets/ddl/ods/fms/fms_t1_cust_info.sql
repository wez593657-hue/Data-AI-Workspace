-- crmdm.fms_t1_cust_info 定义

-- Drop table

-- DROP TABLE crmdm.fms_t1_cust_info;

CREATE TABLE crmdm.fms_t1_cust_info (
	cust_no varchar(20) NULL, -- 客户号
	host_cust_no varchar(32) NULL, -- 主机客户号
	id_type varchar(8) NULL, -- 证件类型
	id_code varchar(32) NULL, -- 证件号码
	host_id_type varchar(8) NULL, -- 主机证件类型
	cust_name varchar(128) NULL, -- 客户名称
	cust_type varchar(8) NULL, -- 客户类型
	cust_level varchar(8) NULL, -- 客户级别
	cust_card_type varchar(8) NULL, -- 客户卡类型
	instrepr_name varchar(128) NULL, -- 法人名称
	instrepr_id_type varchar(8) NULL, -- 法人证件类型
	instrepr_id_code varchar(32) NULL, -- 法人证件号码
	agent_name varchar(128) NULL, -- 经办(代理)人姓名
	agent_id_type varchar(8) NULL, -- 经办(代理)人证件类型
	agent_id_code varchar(32) NULL, -- 经办(代理)人证件号码
	birthday bpchar(8) NULL, -- 出生日期
	sex bpchar(1) NULL, -- 性别
	education bpchar(1) NULL, -- 学历
	mobile varchar(20) NULL, -- 手机号码
	home_tel varchar(20) NULL, -- 家庭电话
	office_tel varchar(20) NULL, -- 办公电话
	fax varchar(20) NULL, -- 传真号码
	postcode bpchar(6) NULL, -- 邮政编码
	addr varchar(128) NULL, -- 通信地址
	email varchar(64) NULL, -- 邮箱地址
	cust_manager varchar(20) NULL, -- 客户经理代码
	fnc_manager varchar(20) NULL, -- 理财经理代码
	protocol_serno varchar(32) NULL, -- 协议单号（纸质上显示的编号）
	protocol_status bpchar(1) NULL, -- 协议状态
	bank_code varchar(20) NULL, -- 银行代码-签约总行
	branch_code varchar(20) NULL, -- 分行代码-签约分行
	sub_branch_code varchar(20) NULL, -- 网点代码-签约网点
	inputuser varchar(20) NULL, -- 录入柜员
	crt_date bpchar(8) NULL, -- 创建日期
	crt_time bpchar(6) NULL, -- 创建时间
	inv_date bpchar(8) NULL, -- 注销日期
	inv_time bpchar(6) NULL, -- 注销时间
	remark varchar(255) NULL, -- 备注
	upd_date bpchar(8) NULL, -- 更新日期
	upd_time bpchar(6) NULL, -- 更新时间
	investor_type bpchar(2) NULL, -- 投资者类型
	cust_ename varchar(100) NULL, -- 客户英文名
	cust_cname varchar(100) NULL, -- 客户中文名
	agent_ename varchar(100) NULL, -- 代办人英文名
	agent_cname varchar(100) NULL, -- 代办人中文名
	is_new_cust bpchar(1) NULL, -- 是否新客
	investor_class bpchar(1) NULL, -- 投资者类别
	investor_invalid_date bpchar(8) NULL, -- 合格投资者失效日
	legal_code varchar(32) NULL, -- 法人代码（多法人模式）
	certvaliddate bpchar(8) NULL, -- 证件有效日期（长期有效填写 99991231）
	annualincome numeric(16) NULL, -- 投资人年收入(单位：元)
	nationality varchar(3) NULL, -- 国籍(GB/T 2659-2000中两位英文字母)
	vocationcode varchar(5) NULL, -- 职业代码(01-党政机关、事业单位 02-企业单位 03-自由业主 04-学生 05-军人 06-其他；按人行要求，分类不能有“其它”。)
	specialpersonflag bpchar(1) NULL, -- 特定自然人标识
	fir_investor_type bpchar(1) NULL, -- 个人投资类型
	family_name varchar(100) NULL, -- 英文姓
	first_name varchar(100) NULL, -- 英文名
	living_country varchar(3) NULL, -- 现居国家
	living_province varchar(6) NULL, -- 现居地址-省份
	living_city varchar(6) NULL, -- 现居地址-城市
	living_district varchar(6) NULL, -- 现居地址-县/行政区
	living_address varchar(300) NULL, -- 现居地址-详细地址
	corp_name varchar(40) NULL, -- 工作单位名称
	non_resi_flag varchar(1) NULL, -- 非居民标识
	tax_country varchar(3) NULL, -- 税收居民国 0：仅为中国税收居民 1：仅为非居民 2：同为中国和其它国税收居民 3:不配合客户'
	tax_id varchar(200) NULL -- 纳税人识别号,
	is_dx_new_cust bpchar(1) NULL, -- 是否代销新客;0-否;1-是
	ryzd varchar(1) NULL -- 冗余字段
);
COMMENT ON TABLE crmdm.fms_t1_cust_info IS '客户信息表';

-- Column comments

COMMENT ON COLUMN crmdm.fms_t1_cust_info.cust_no IS '客户号';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.host_cust_no IS '主机客户号';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.id_type IS '证件类型';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.id_code IS '证件号码';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.host_id_type IS '主机证件类型';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.cust_name IS '客户名称';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.cust_type IS '客户类型';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.cust_level IS '客户级别';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.cust_card_type IS '客户卡类型';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.instrepr_name IS '法人名称';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.instrepr_id_type IS '法人证件类型';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.instrepr_id_code IS '法人证件号码';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.agent_name IS '经办(代理)人姓名';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.agent_id_type IS '经办(代理)人证件类型';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.agent_id_code IS '经办(代理)人证件号码';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.birthday IS '出生日期';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.sex IS '性别';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.education IS '学历';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.mobile IS '手机号码';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.home_tel IS '家庭电话';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.office_tel IS '办公电话';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.fax IS '传真号码';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.postcode IS '邮政编码';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.addr IS '通信地址';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.email IS '邮箱地址';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.cust_manager IS '客户经理代码';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.fnc_manager IS '理财经理代码';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.protocol_serno IS '协议单号（纸质上显示的编号）';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.protocol_status IS '协议状态';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.bank_code IS '银行代码-签约总行';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.branch_code IS '分行代码-签约分行';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.sub_branch_code IS '网点代码-签约网点';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.inputuser IS '录入柜员';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.crt_date IS '创建日期';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.crt_time IS '创建时间';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.inv_date IS '注销日期';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.inv_time IS '注销时间';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.remark IS '备注';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.upd_date IS '更新日期';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.upd_time IS '更新时间';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.investor_type IS '投资者类型';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.cust_ename IS '客户英文名';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.cust_cname IS '客户中文名';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.agent_ename IS '代办人英文名';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.agent_cname IS '代办人中文名';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.is_new_cust IS '是否新客';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.investor_class IS '投资者类别';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.investor_invalid_date IS '合格投资者失效日';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.legal_code IS '法人代码（多法人模式）';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.certvaliddate IS '证件有效日期（长期有效填写 99991231）';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.annualincome IS '投资人年收入(单位：元)';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.nationality IS '国籍(GB/T 2659-2000中两位英文字母)';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.vocationcode IS '职业代码(01-党政机关、事业单位 02-企业单位 03-自由业主 04-学生 05-军人 06-其他；按人行要求，分类不能有“其它”。)';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.specialpersonflag IS '特定自然人标识';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.fir_investor_type IS '个人投资类型';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.family_name IS '英文姓';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.first_name IS '英文名';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.living_country IS '现居国家';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.living_province IS '现居地址-省份';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.living_city IS '现居地址-城市';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.living_district IS '现居地址-县/行政区';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.living_address IS '现居地址-详细地址';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.corp_name IS '工作单位名称';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.non_resi_flag IS '非居民标识';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.tax_country IS '税收居民国 0：仅为中国税收居民 1：仅为非居民 2：同为中国和其它国税收居民 3:不配合客户''';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.tax_id IS '纳税人识别号';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.is_dx_new_cust IS '是否代销新客;0-否;1-是';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.ryzd IS '冗余字段';
