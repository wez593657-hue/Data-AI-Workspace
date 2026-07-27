-- crmdm.cds_tb_prod_pub_info 定义

-- Drop table

-- DROP TABLE crmdm.cds_tb_prod_pub_info;

CREATE TABLE crmdm.cds_tb_prod_pub_info (
	prod_code varchar(32) NOT NULL, -- 产品代码
	prod_glob_code varchar(32) NULL, -- 全国唯一编码
	prod_name varchar(128) NOT NULL, -- 产品名称
	prod_status bpchar(1) NOT NULL, -- 产品状态（0：待售 1：开始销售 2：停止销售）
	prod_class bpchar(1) NOT NULL, -- 产品大类（0：活期 1：定期）
	prod_subclass bpchar(1) NOT NULL, -- 产品子类( 0：活期日终型 1：活期日均型 2：协定活期型  3：定期型 4：大额存单 5：协定定期型）
	sale_begin_date bpchar(8) NOT NULL, -- 销售日期
	sale_begin_time bpchar(6) NOT NULL, -- 销售时间
	sale_end_date bpchar(8) NULL, -- 停售日期
	sale_end_time bpchar(6) NULL, -- 停售时间
	allow_sale_channel varchar(20) NOT NULL, -- 允许交易渠道 （0：银行柜台 1：银行网银 2：ATM 3：电话银行 4：手机银行）-1为不限制(多选)
	allow_sex_limit varchar(2) NOT NULL, -- 允许交易性别（单选）0:男 1:女 -1:不限
	allow_cust_type bpchar(1) NOT NULL, -- 允许交易客户类型 （0：企业客户 3：个人客户）（单选）
	allow_card_type varchar(20) NULL, -- 允许交易卡类型(多选)-1为不限制
	allow_cust_level varchar(20) NULL, -- 允许交易客户级别(多选)-1为不限制
	allow_white_type varchar(32) NULL, -- 允许交易白名单编号 -1为不限制
	allow_max_age numeric(3) NULL, -- 允许交易年龄上限 -1为不限
	allow_min_age numeric(3) NULL, -- 允许交易年龄下限 -1为不限制
	sale_org bpchar(1) NULL, -- 销售机构范围（0：不限制 1：限制）
	rate_days bpchar(1) NULL, -- 年天数(0：360 1：365 2：366)
	calc_type varchar(3) NOT NULL, -- 计提频率（D1-每天、M1-每月、M3-每季、Z-到期、Z0-不计提）
	calc_date bpchar(8) NULL, -- 计提日期（计提周期为每月、每季时填写）
	interest_type varchar(3) NOT NULL, -- 结息频率（D1-每天、M1-每月、M3-每季、Z-到期）
	interest_date bpchar(8) NULL, -- 结息日期（当计提周期为每月、每季时，并且为产品子类为“日终型”，为必填项。其他产品类型不填写。）
	part_draw_interest bpchar(1) NULL, -- 部分支取是否结息 （1 是 0 否 协定型、日均型不支持提前支取，这两种产品不填。）
	account_no varchar(32) NULL, -- 计提结息会计分录方案编号
	is_exclusive bpchar(1) NULL, -- 是否为专享产品 1是 0否
	exclusive_count numeric(10) NULL, -- 专享码数量 (为专享产品时，为产品生产对应数目的专享码)
	min_deposit_amt numeric(16, 2) NULL, -- 起存金额 (活期型：账户在满足留存金额的前提下，需要达到增值收益的起点为起存金额。（即生成第一个增值账户的起点）定期型：每一次定期购买的金额最低额度)
	step_amt numeric(16, 2) NULL, -- 递增减基数金额（活期型：生成第一个增值账户以后，后续生成增值账户按照递增减基数金额得出增值本金。定期型：超过起存金额部分，必须按照递增减基数金额进入增值本金。）
	min_hold_amt numeric(16, 2) NULL, -- 最低持有金额 (发生支取时，判断是否继续增值收益。活期型：所有增值账户的增值本金汇总最低额度。定期型：针对每一个定期发生支取之后的金额最低额度。)
	max_hold_amt numeric(16, 2) NULL, -- 最高持有金额 （活期型：所有增值账户的增值本金汇总最高额度定期型：针对每一个定期购买的金额最高额度。）
	inc_due varchar(4) NULL, -- 增值期限 日终、定期：每一个增值账户期限。日均：日均余额的考核周期。协定：最大协定期限。D1：一天 D7：七天 M1：一个月 M3:三个月M6：六个月 Y1：一年Y2：两年Y3：三年Y5：五年(自定义期限通过数据字典配置)
	crt_user varchar(20) NULL, -- 创建用户
	crt_orgno varchar(20) NULL, -- 创建机构
	draw_due varchar(4) NULL, -- 支取期限 （1-1月、2-2月、3-3月、4-4月、5-5月、6-6月、7-7月、8-8月、9-9月、10-10月、11-11月、12-12月）
	belong_org varchar(20) NULL, -- 归属机构
	crt_date bpchar(8) NOT NULL, -- 创建日期
	crt_time bpchar(6) NOT NULL, -- 创建时间
	upd_date bpchar(8) NOT NULL, -- 更新日期
	upd_time bpchar(6) NOT NULL, -- 更新时间
	is_boutique bpchar(1) NULL, -- 是否是精品推荐产品(1-是 0-否)
	prod_flag bpchar(1) NOT NULL, -- 产品标记 1普通2尊享码3白名单
	seven_notice_amt numeric(16, 2) NULL, -- 七天通知金额
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_cds_tb_prod_pub_info PRIMARY KEY (prod_code)
);

-- Column comments

COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.prod_code IS '产品代码';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.prod_glob_code IS '全国唯一编码';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.prod_name IS '产品名称';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.prod_status IS '产品状态（0：待售 1：开始销售 2：停止销售）';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.prod_class IS '产品大类（0：活期 1：定期）';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.prod_subclass IS '产品子类( 0：活期日终型 1：活期日均型 2：协定活期型  3：定期型 4：大额存单 5：协定定期型）';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.sale_begin_date IS '销售日期';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.sale_begin_time IS '销售时间';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.sale_end_date IS '停售日期';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.sale_end_time IS '停售时间';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.allow_sale_channel IS '允许交易渠道 （0：银行柜台 1：银行网银 2：ATM 3：电话银行 4：手机银行）-1为不限制(多选)';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.allow_sex_limit IS '允许交易性别（单选）0:男 1:女 -1:不限';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.allow_cust_type IS '允许交易客户类型 （0：企业客户 3：个人客户）（单选）';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.allow_card_type IS '允许交易卡类型(多选)-1为不限制';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.allow_cust_level IS '允许交易客户级别(多选)-1为不限制';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.allow_white_type IS '允许交易白名单编号 -1为不限制';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.allow_max_age IS '允许交易年龄上限 -1为不限';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.allow_min_age IS '允许交易年龄下限 -1为不限制';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.sale_org IS '销售机构范围（0：不限制 1：限制）';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.rate_days IS '年天数(0：360 1：365 2：366)';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.calc_type IS '计提频率（D1-每天、M1-每月、M3-每季、Z-到期、Z0-不计提）';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.calc_date IS '计提日期（计提周期为每月、每季时填写）';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.interest_type IS '结息频率（D1-每天、M1-每月、M3-每季、Z-到期）';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.interest_date IS '结息日期（当计提周期为每月、每季时，并且为产品子类为“日终型”，为必填项。其他产品类型不填写。）';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.part_draw_interest IS '部分支取是否结息 （1 是 0 否 协定型、日均型不支持提前支取，这两种产品不填。）';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.account_no IS '计提结息会计分录方案编号';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.is_exclusive IS '是否为专享产品 1是 0否';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.exclusive_count IS '专享码数量 (为专享产品时，为产品生产对应数目的专享码)';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.min_deposit_amt IS '起存金额 (活期型：账户在满足留存金额的前提下，需要达到增值收益的起点为起存金额。（即生成第一个增值账户的起点）定期型：每一次定期购买的金额最低额度)';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.step_amt IS '递增减基数金额（活期型：生成第一个增值账户以后，后续生成增值账户按照递增减基数金额得出增值本金。定期型：超过起存金额部分，必须按照递增减基数金额进入增值本金。）';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.min_hold_amt IS '最低持有金额 (发生支取时，判断是否继续增值收益。活期型：所有增值账户的增值本金汇总最低额度。定期型：针对每一个定期发生支取之后的金额最低额度。)';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.max_hold_amt IS '最高持有金额 （活期型：所有增值账户的增值本金汇总最高额度定期型：针对每一个定期购买的金额最高额度。）';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.inc_due IS '增值期限 日终、定期：每一个增值账户期限。日均：日均余额的考核周期。协定：最大协定期限。D1：一天 D7：七天 M1：一个月 M3:三个月M6：六个月 Y1：一年Y2：两年Y3：三年Y5：五年(自定义期限通过数据字典配置)';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.crt_user IS '创建用户';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.crt_orgno IS '创建机构';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.draw_due IS '支取期限 （1-1月、2-2月、3-3月、4-4月、5-5月、6-6月、7-7月、8-8月、9-9月、10-10月、11-11月、12-12月）';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.belong_org IS '归属机构';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.crt_date IS '创建日期';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.crt_time IS '创建时间';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.upd_date IS '更新日期';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.upd_time IS '更新时间';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.is_boutique IS '是否是精品推荐产品(1-是 0-否)';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.prod_flag IS '产品标记 1普通2尊享码3白名单';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.seven_notice_amt IS '七天通知金额';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.ryzd IS '冗余字段';
