-- crmdm.cds_t1_cust_info 定义

-- Drop table

-- DROP TABLE crmdm.cds_t1_cust_info;

CREATE TABLE crmdm.cds_t1_cust_info (
	cust_no bpchar(8) NOT NULL, -- 客户号
	fund_id_type varchar(2) NULL, -- 基金证件类型
	main_trans_acct_no bpchar(17) NULL, -- 主交易账号
	id_type varchar(2) NOT NULL, -- 证件类型（ 1：身份证 2：临时身份证 3：户口簿 4：护照 5：军人证 6：武警证 7：港澳来往通行证 8：台湾来往通行证 9：其他证件 A：营业执照 B：同业机构代码 C：法人登记证 D：证明文件 E：经营许可证 F：组织机构代码证 G：其他 H：基金会 O：开户证明 ）
	id_code varchar(32) NOT NULL, -- 证件号码
	cust_name varchar(128) NOT NULL, -- 客户名称
	cust_type bpchar(1) NOT NULL, -- 客户类型（ 0：企业 1：同业机构（金融业企业） 2：行政机构 3：个人 ）
	cust_level varchar(8) NULL, -- 客户级别
	cust_card_type varchar(8) NULL, -- 客户卡类型（ 0：不限 1：珠联璧合卡 2：握美卡 ）
	instrepr_name varchar(128) NULL, -- 法人名称
	instrepr_id_type varchar(2) NULL, -- 法人证件类型（身份证/护照/军官证/士兵证/回乡证/户口本/外国护照/其它/无/技术监督局代码/营业执照/行政机关/社会团体/军队/武警/下属机构（具有主管单位批文号）/基金会）
	instrepr_id_code varchar(32) NULL, -- 法人证件号码
	agent_name varchar(128) NULL, -- 经办(代理)人姓名
	agent_id_type varchar(2) NULL, -- 经办(代理)人证件类型（ 1：身份证 2：临时身份证 3：户口簿 4：护照 5：军人证 6：武警证 7：港澳来往通行证 8：台湾来往通行证 9：其他证件 ）
	agent_id_code varchar(32) NULL, -- 经办(代理)人证件号码
	birthday bpchar(8) NULL, -- 出生日期
	sex bpchar(1) NULL, -- 性别 0-男 1-女 2-中性
	education bpchar(1) NULL, -- 学历 0-小学 1-初中 2-中技 3-中专 4-大专 5-本科 6-硕士 7-博士
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
	protocol_status bpchar(1) NOT NULL, -- 协议状态 0-正常 1-注销
	bank_code varchar(20) NOT NULL, -- 总行代码
	branch_code varchar(20) NOT NULL, -- 分行代码
	sub_branch_code varchar(20) NOT NULL, -- 网点代码
	inputuser varchar(20) NOT NULL, -- 录入柜员
	crt_date bpchar(8) NOT NULL, -- 创建日期
	crt_time bpchar(6) NOT NULL, -- 创建时间
	inv_date bpchar(8) NULL, -- 注销日期
	inv_time bpchar(6) NULL, -- 注销时间
	remark varchar(255) NULL, -- 备注
	upd_date bpchar(8) NOT NULL, -- 更新日期
	upd_time bpchar(6) NOT NULL, -- 更新时间
	ifemployee bpchar(1) NULL, -- 是否是内部员工（1：是 0：否）
	host_cust_no varchar(32) NULL, -- 核心客户号
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_cds_t1_cust_info PRIMARY KEY (cust_no)
);

-- Column comments

COMMENT ON COLUMN crmdm.cds_t1_cust_info.cust_no IS '客户号';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.fund_id_type IS '基金证件类型';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.main_trans_acct_no IS '主交易账号';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.id_type IS '证件类型（ 1：身份证 2：临时身份证 3：户口簿 4：护照 5：军人证 6：武警证 7：港澳来往通行证 8：台湾来往通行证 9：其他证件 A：营业执照 B：同业机构代码 C：法人登记证 D：证明文件 E：经营许可证 F：组织机构代码证 G：其他 H：基金会 O：开户证明 ）';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.id_code IS '证件号码';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.cust_name IS '客户名称';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.cust_type IS '客户类型（ 0：企业 1：同业机构（金融业企业） 2：行政机构 3：个人 ）';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.cust_level IS '客户级别';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.cust_card_type IS '客户卡类型（ 0：不限 1：珠联璧合卡 2：握美卡 ）';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.instrepr_name IS '法人名称';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.instrepr_id_type IS '法人证件类型（身份证/护照/军官证/士兵证/回乡证/户口本/外国护照/其它/无/技术监督局代码/营业执照/行政机关/社会团体/军队/武警/下属机构（具有主管单位批文号）/基金会）';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.instrepr_id_code IS '法人证件号码';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.agent_name IS '经办(代理)人姓名';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.agent_id_type IS '经办(代理)人证件类型（ 1：身份证 2：临时身份证 3：户口簿 4：护照 5：军人证 6：武警证 7：港澳来往通行证 8：台湾来往通行证 9：其他证件 ）';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.agent_id_code IS '经办(代理)人证件号码';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.birthday IS '出生日期';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.sex IS '性别 0-男 1-女 2-中性';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.education IS '学历 0-小学 1-初中 2-中技 3-中专 4-大专 5-本科 6-硕士 7-博士';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.mobile IS '手机号码';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.home_tel IS '家庭电话';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.office_tel IS '办公电话';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.fax IS '传真号码';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.postcode IS '邮政编码';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.addr IS '通信地址';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.email IS '邮箱地址';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.cust_manager IS '客户经理代码';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.fnc_manager IS '理财经理代码';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.protocol_serno IS '协议单号（纸质上显示的编号）';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.protocol_status IS '协议状态 0-正常 1-注销';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.bank_code IS '总行代码';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.branch_code IS '分行代码';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.sub_branch_code IS '网点代码';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.inputuser IS '录入柜员';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.crt_date IS '创建日期';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.crt_time IS '创建时间';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.inv_date IS '注销日期';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.inv_time IS '注销时间';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.remark IS '备注';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.upd_date IS '更新日期';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.upd_time IS '更新时间';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.ifemployee IS '是否是内部员工（1：是 0：否）';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.host_cust_no IS '核心客户号';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.ryzd IS '冗余字段';
