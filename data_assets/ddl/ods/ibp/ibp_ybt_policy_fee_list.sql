-- crmdm.ibp_ybt_policy_fee_list 定义

-- Drop table

-- DROP TABLE crmdm.ibp_ybt_policy_fee_list;

CREATE TABLE crmdm.ibp_ybt_policy_fee_list (
	plat_policy_serial varchar(200) NOT NULL, -- 保单平台流水号
	cont_no varchar(200) NULL, -- 保险单号
	ord_item_id varchar(40) NOT NULL, -- 中间业务缴费项目编号：104001：大家  104002：和谐 104003：太平洋 104004：中国人寿
	ord_type varchar(16) NOT NULL, -- 中间业务订单类型:PY-消费,RE-退款
	ord_id varchar(200) NOT NULL, -- 中间业务订单号
	ord_ori_id varchar(200) NULL, -- 中间业务原订单号
	ord_memo varchar(2000) NULL, -- 中间业务订单描述
	ord_amt numeric(17, 2) NULL, -- 订单总保费
	pre_amt numeric(17, 2) NULL, -- 中间业务订单总保额
	ord_create_date varchar(32) NULL, -- 中间业务订单创建日期
	ord_create_time varchar(24) NULL, -- 中间业务订单创建时间
	ord_expires_date varchar(32) NULL, -- 中间业务订单过期日期
	ord_expires_time varchar(24) NULL, -- 中间业务订单过期时间
	ord_pay_serial varchar(200) NULL, -- 中间业务订单支付/退款流水号
	ord_link_user_name varchar(800) NULL, -- 中间业务订单用户名称
	ord_link_user_phone varchar(200) NULL, -- 中间业务订单用户联系方式
	ordpayeracc_no varchar(200) NULL, -- 付款账户
	ordpayeracc_name varchar(800) NULL, -- 付款账户名称
	ordpayer_bank_no varchar(200) NULL, -- 付款银行行号
	ordpayer_bank_name varchar(800) NULL, -- 付款银行名称
	ord_payee_acct_no varchar(200) NULL, -- 中间业务订单收款账户
	ord_payee_acct_name varchar(800) NULL, -- 中间业务订单收款账户名称
	ord_payee_bank_no varchar(200) NULL, -- 付款银行行号
	ord_payee_bank_name varchar(800) NULL, -- 付款银行名称
	ord_part_pay_flag varchar(8) NULL, -- 中间业务订单允许部分支付标识:0-不允许,1-允许
	ord_thr_sum_amt numeric(17, 2) NULL, -- 中间业务订单关联的第三方订单/缴费号的总金额
	ord_thr_payed_amt numeric(17, 2) NOT NULL, -- 中间业务订单关联的第三方订单/缴费号的已支付金额
	ord_tran_status varchar(8) NULL, -- 交易状态：0:未缴费 1:缴费处理中 2:缴费成功 3:缴费失败
	tran_type varchar(8) NULL, -- 交易类型：0:新单承保 1:续期缴费 2:已当日撤单 3:犹豫期退保 4:犹豫期外退保 5:满期给付 6:理赔终止 7保险公司其他保全 8：终止撤销 9：复效
	tran_soure varchar(8) NOT NULL, -- 交易渠道：1：柜面 2：手机银行 3：保险公司
	prem_text varchar(200) NULL, -- 交易金额大写
	trans_no varchar(200) NULL, -- 保险公司交易流水号
	hole_memo1 varchar(800) NULL, -- 备用字段1
	hole_memo2 varchar(800) NULL, -- 备用字段2
	hole_memo3 varchar(800) NULL, -- 备用字段3
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_ibp_ybt_policy_fee_list PRIMARY KEY (plat_policy_serial)
);

-- Column comments

COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.plat_policy_serial IS '保单平台流水号';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.cont_no IS '保险单号';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.ord_item_id IS '中间业务缴费项目编号：104001：大家  104002：和谐 104003：太平洋 104004：中国人寿';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.ord_type IS '中间业务订单类型:PY-消费,RE-退款';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.ord_id IS '中间业务订单号';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.ord_ori_id IS '中间业务原订单号';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.ord_memo IS '中间业务订单描述';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.ord_amt IS '订单总保费';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.pre_amt IS '中间业务订单总保额';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.ord_create_date IS '中间业务订单创建日期';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.ord_create_time IS '中间业务订单创建时间';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.ord_expires_date IS '中间业务订单过期日期';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.ord_expires_time IS '中间业务订单过期时间';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.ord_pay_serial IS '中间业务订单支付/退款流水号';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.ord_link_user_name IS '中间业务订单用户名称';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.ord_link_user_phone IS '中间业务订单用户联系方式';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.ordpayeracc_no IS '付款账户';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.ordpayeracc_name IS '付款账户名称';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.ordpayer_bank_no IS '付款银行行号';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.ordpayer_bank_name IS '付款银行名称';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.ord_payee_acct_no IS '中间业务订单收款账户';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.ord_payee_acct_name IS '中间业务订单收款账户名称';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.ord_payee_bank_no IS '付款银行行号';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.ord_payee_bank_name IS '付款银行名称';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.ord_part_pay_flag IS '中间业务订单允许部分支付标识:0-不允许,1-允许';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.ord_thr_sum_amt IS '中间业务订单关联的第三方订单/缴费号的总金额';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.ord_thr_payed_amt IS '中间业务订单关联的第三方订单/缴费号的已支付金额';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.ord_tran_status IS '交易状态：0:未缴费 1:缴费处理中 2:缴费成功 3:缴费失败';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.tran_type IS '交易类型：0:新单承保 1:续期缴费 2:已当日撤单 3:犹豫期退保 4:犹豫期外退保 5:满期给付 6:理赔终止 7保险公司其他保全 8：终止撤销 9：复效';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.tran_soure IS '交易渠道：1：柜面 2：手机银行 3：保险公司';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.prem_text IS '交易金额大写';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.trans_no IS '保险公司交易流水号';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.hole_memo1 IS '备用字段1';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.hole_memo2 IS '备用字段2';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.hole_memo3 IS '备用字段3';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.ryzd IS '冗余字段';
