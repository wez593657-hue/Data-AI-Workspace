-- crmdm.mbk_cust_log_fee 定义

-- Drop table

-- DROP TABLE crmdm.mbk_cust_log_fee;

CREATE TABLE crmdm.mbk_cust_log_fee (
	tran_sn varchar(32) NOT NULL, -- 交易流水号
	cust_name varchar(64) NULL, -- 客户名称
	item_id varchar(100) NULL, -- 项目编号
	tran_type varchar(5) NULL, -- 0:水电气1:校园缴费2:小程序3:社保 4:党员缴费5:非税6:校园一卡通7:资金维修11:非税
	ccy varchar(30) NOT NULL, -- 币种
	tran_date varchar(10) NULL, -- 交易日期
	tran_time varchar(8) NULL, -- 交易时间
	acct varchar(32) NULL, -- 卡号
	tran_amt varchar(20) NULL, -- 金额
	tran_method bpchar(1) NULL, -- 充值方式,0:现金1:转账
	discount_num varchar(50) NULL, -- 优惠号码
	tran_status varchar(2) NULL, -- 交易状态 1-成功2-失败3-状态未知
	discount_type varchar(20) NULL, -- 优惠类型
	discount_amt varchar(20) NULL, -- 优惠金额
	discount_remark varchar(100) NULL, -- 优惠描述
	cust_no varchar(32) NULL, -- 客户号
	dept_id varchar(50) NULL, -- 机构ID
	order_no varchar(50) NULL, -- 订单号
	prod_id varchar(60) NULL, -- 商品ID
	prod_name varchar(60) NULL, -- 商品名称
	student_name varchar(20) NULL, -- 学生姓名（校园缴费）
	pay_name varchar(20) NULL, -- 缴费户名
	pay_no varchar(40) NULL, -- 缴费户号
	pay_sub varchar(5) NULL, -- 党费缴费记录版本区别标识：1-新版本记录
	pay_term varchar(20) NULL, -- 缴费期次
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_mbk_cust_log_fee PRIMARY KEY (tran_sn)
);

-- Column comments

COMMENT ON COLUMN crmdm.mbk_cust_log_fee.tran_sn IS '交易流水号';
COMMENT ON COLUMN crmdm.mbk_cust_log_fee.cust_name IS '客户名称';
COMMENT ON COLUMN crmdm.mbk_cust_log_fee.item_id IS '项目编号';
COMMENT ON COLUMN crmdm.mbk_cust_log_fee.tran_type IS '0:水电气1:校园缴费2:小程序3:社保 4:党员缴费5:非税6:校园一卡通7:资金维修11:非税';
COMMENT ON COLUMN crmdm.mbk_cust_log_fee.ccy IS '币种';
COMMENT ON COLUMN crmdm.mbk_cust_log_fee.tran_date IS '交易日期';
COMMENT ON COLUMN crmdm.mbk_cust_log_fee.tran_time IS '交易时间';
COMMENT ON COLUMN crmdm.mbk_cust_log_fee.acct IS '卡号';
COMMENT ON COLUMN crmdm.mbk_cust_log_fee.tran_amt IS '金额';
COMMENT ON COLUMN crmdm.mbk_cust_log_fee.tran_method IS '充值方式,0:现金1:转账';
COMMENT ON COLUMN crmdm.mbk_cust_log_fee.discount_num IS '优惠号码';
COMMENT ON COLUMN crmdm.mbk_cust_log_fee.tran_status IS '交易状态 1-成功2-失败3-状态未知';
COMMENT ON COLUMN crmdm.mbk_cust_log_fee.discount_type IS '优惠类型';
COMMENT ON COLUMN crmdm.mbk_cust_log_fee.discount_amt IS '优惠金额';
COMMENT ON COLUMN crmdm.mbk_cust_log_fee.discount_remark IS '优惠描述';
COMMENT ON COLUMN crmdm.mbk_cust_log_fee.cust_no IS '客户号';
COMMENT ON COLUMN crmdm.mbk_cust_log_fee.dept_id IS '机构ID';
COMMENT ON COLUMN crmdm.mbk_cust_log_fee.order_no IS '订单号';
COMMENT ON COLUMN crmdm.mbk_cust_log_fee.prod_id IS '商品ID';
COMMENT ON COLUMN crmdm.mbk_cust_log_fee.prod_name IS '商品名称';
COMMENT ON COLUMN crmdm.mbk_cust_log_fee.student_name IS '学生姓名（校园缴费）';
COMMENT ON COLUMN crmdm.mbk_cust_log_fee.pay_name IS '缴费户名';
COMMENT ON COLUMN crmdm.mbk_cust_log_fee.pay_no IS '缴费户号';
COMMENT ON COLUMN crmdm.mbk_cust_log_fee.pay_sub IS '党费缴费记录版本区别标识：1-新版本记录';
COMMENT ON COLUMN crmdm.mbk_cust_log_fee.pay_term IS '缴费期次';
COMMENT ON COLUMN crmdm.mbk_cust_log_fee.ryzd IS '冗余字段';
