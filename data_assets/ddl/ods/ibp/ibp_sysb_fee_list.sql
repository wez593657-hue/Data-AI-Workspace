-- crmdm.ibp_sysb_fee_list 定义

-- Drop table

-- DROP TABLE crmdm.ibp_sysb_fee_list;

CREATE TABLE crmdm.ibp_sysb_fee_list (
	query_serial varchar(120) NOT NULL, -- 查询流水
	pay_serial varchar(120) NULL, -- 缴费流水
	service_id varchar(20) NOT NULL, -- 服务ID
	batch_no varchar(32) NULL, -- 批次号
	item_id varchar(40) NOT NULL, -- 项目编号
	id_type varchar(3) NOT NULL, -- 证件类型
	id_no varchar(88) NOT NULL, -- 证件号码
	user_name varchar(200) NULL, -- 姓名
	user_id varchar(120) NULL, -- 人员编码
	user_type varchar(1) NULL, -- 缴费人员类型  0：城乡居民  1：灵活就业人员
	user_insurance_type varchar(5) NULL, -- 险种： 00000 代表全部险种 10210 城乡居民养老保险 10212 城乡居民医疗保险 10201养老保险 10203医疗保险
	pay_type varchar(1) NULL, -- 缴费类型：0现金；1转账
	pay_acct_no varchar(200) NULL, -- 付款账号
	pay_acct_name varchar(400) NULL, -- 付款账号名称
	total_amt numeric(18, 2) NOT NULL, -- 总金额
	pay_date varchar(4) NULL, -- 缴费年份
	start_date varchar(6) NULL, -- 费款所属期起
	end_date varchar(6) NULL, -- 费款所属期止
	base_amt numeric(18, 2) NULL, -- 缴费基数
	amt numeric(18, 2) NULL, -- 缴费档次金额
	tax_serial varchar(80) NULL, -- 税务交易流水
	bank_serial varchar(160) NULL, -- 银行缴费流水号
	print_count varchar(50) NULL, -- 打印次数
	vor_type varchar(1) NULL, -- 凭证类型
	det_count numeric NULL, -- 总数量
	ac_bank_type varchar(4) NULL, -- 经办银行种类代码
	ac_bank_code varchar(12) NULL, -- 经办银行代码
	ac_bank_name varchar(320) NULL, -- 经办银行名称
	sett_date varchar(8) NULL, -- 日切日期
	sett_bank_type varchar(4) NULL, -- 结算银行种类代码
	sett_bank_code varchar(12) NULL, -- 结算银行代码
	sett_bank_name varchar(320) NULL, -- 结算银行名称
	sett_bank_account varchar(50) NULL, -- 结算银行帐号
	tax_no varchar(30) NULL, -- 税票号码
	ret_code varchar(12) NULL, -- 返回结果
	ret_msg varchar(500) NULL, -- 返回信息
	ac_branch varchar(8) NULL, -- 经办机构
	sett_branch varchar(8) NULL, -- 结算机构
	zhaiyoms varchar(1200) NULL, -- 短信摘要描述
	ori_acct_no varchar(200) NULL, -- 原付款账号
	swjgmc varchar(400) NULL, -- 税务机关名称
	swjgdm varchar(20) NULL, -- 税务机关代码
	dcmc varchar(120) NULL, -- 档次名称
	chk_status varchar(1) NULL, -- 核对状态
	trans_type varchar(10) NULL, -- "交易类型：01：个人税务批扣缴费； 02：个人税务实时缴费； 03：个人银行查询缴费 "
	chk_amt numeric(18, 2) NULL, -- 核对金额
	chk_date varchar(8) NULL, -- 扣款日期
	chk_memo varchar(800) NULL, -- 失败原因
	phone varchar(60) NULL, -- 手机号码
	address varchar(300) NULL, -- 联系地址
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_ibp_sysb_fee_list PRIMARY KEY (query_serial)
);

-- Column comments

COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.query_serial IS '查询流水';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.pay_serial IS '缴费流水';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.service_id IS '服务ID';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.batch_no IS '批次号';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.item_id IS '项目编号';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.id_type IS '证件类型';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.id_no IS '证件号码';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.user_name IS '姓名';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.user_id IS '人员编码';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.user_type IS '缴费人员类型  0：城乡居民  1：灵活就业人员';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.user_insurance_type IS '险种： 00000 代表全部险种 10210 城乡居民养老保险 10212 城乡居民医疗保险 10201养老保险 10203医疗保险';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.pay_type IS '缴费类型：0现金；1转账';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.pay_acct_no IS '付款账号';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.pay_acct_name IS '付款账号名称';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.total_amt IS '总金额';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.pay_date IS '缴费年份';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.start_date IS '费款所属期起';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.end_date IS '费款所属期止';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.base_amt IS '缴费基数';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.amt IS '缴费档次金额';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.tax_serial IS '税务交易流水';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.bank_serial IS '银行缴费流水号';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.print_count IS '打印次数';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.vor_type IS '凭证类型';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.det_count IS '总数量';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.ac_bank_type IS '经办银行种类代码';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.ac_bank_code IS '经办银行代码';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.ac_bank_name IS '经办银行名称';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.sett_date IS '日切日期';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.sett_bank_type IS '结算银行种类代码';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.sett_bank_code IS '结算银行代码';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.sett_bank_name IS '结算银行名称';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.sett_bank_account IS '结算银行帐号';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.tax_no IS '税票号码';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.ret_code IS '返回结果';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.ret_msg IS '返回信息';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.ac_branch IS '经办机构';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.sett_branch IS '结算机构';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.zhaiyoms IS '短信摘要描述';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.ori_acct_no IS '原付款账号';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.swjgmc IS '税务机关名称';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.swjgdm IS '税务机关代码';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.dcmc IS '档次名称';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.chk_status IS '核对状态';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.trans_type IS '"交易类型：01：个人税务批扣缴费； 02：个人税务实时缴费； 03：个人银行查询缴费 "';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.chk_amt IS '核对金额';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.chk_date IS '扣款日期';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.chk_memo IS '失败原因';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.phone IS '手机号码';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.address IS '联系地址';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.ryzd IS '冗余字段';
