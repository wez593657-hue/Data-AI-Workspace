-- crmdm.ibp_ybt_policy_insurance_info 定义

-- Drop table

-- DROP TABLE crmdm.ibp_ybt_policy_insurance_info;

CREATE TABLE crmdm.ibp_ybt_policy_insurance_info (
	plat_policy_serial varchar(200) NOT NULL, -- 保单平台流水号
	item_id varchar(40) NOT NULL, -- 中间业务缴费项目编号
	cont_no varchar(200) NULL, -- 保险单号
	insurance_id varchar(200) NOT NULL, -- 险种ID
	insurance_code varchar(200) NOT NULL, -- 险种代码
	main_insurance_code varchar(200) NOT NULL, -- 险种对应的主险种编码
	insurance_name varchar(800) NOT NULL, -- 险种名称
	insurance_type varchar(8) NOT NULL, -- 主附险标志
	sum_buy_part numeric(10) NOT NULL, -- 投保份数
	sum_pre numeric(17, 2) NOT NULL, -- 险种总保额
	sum_cov numeric(17, 2) NOT NULL, -- 险种总保费
	pay_type varchar(8) NOT NULL, -- 缴费类型:0-趸交,1-期缴
	pay_freq varchar(16) NULL, -- 期缴缴费频次(缴费类型为趸交时无值):12-年交,6-半年交,3-季交,1-月交,-1-不定期交
	pay_per_unit varchar(16) NULL, -- 期缴缴费周期计算单位(缴费类型为趸交时无值):12-按年计算,1-按月计算,2-按日计算,0-交至某确定年龄,-1-终生交费
	pay_per_num numeric(10) NULL, -- 期缴缴费周期计算数量
	valid_per_unit varchar(16) NOT NULL, -- 保险周期计算单位:12-按年计算,1-按月保计算,2-按日计算,0-保至某确定年龄,-1-保终身
	valid_per_num numeric(10) NOT NULL, -- 保险周期计算数量
	bonus_get_mode varchar(8) NULL, -- 红利领取方式:1-累计生息,3-抵交保费,4-现金领取,5-增额交清
	auto_pay_flag varchar(8) NULL, -- 自动垫交标志:0-否,1-是
	lxgetintv varchar(16) NULL, -- 万能险领取方式:0-趸领,1-月领,12-年领
	sttlmnt_pymnt_age varchar(40) NULL, -- 年金起领年龄
	sttlmnt_pymnt_freq varchar(40) NULL, -- 年金领取频率:使用YBT_INSURANCE_STTLMNT_INFO表存储
	sttlmnt_pymnt_type varchar(40) NULL, -- 年金领取方式:使用YBT_INSURANCE_STTLMNT_INFO表存储
	sttlmnt_pymnt_end_age varchar(40) NULL, -- 年金止领年龄
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.ibp_ybt_policy_insurance_info.plat_policy_serial IS '保单平台流水号';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_insurance_info.item_id IS '中间业务缴费项目编号';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_insurance_info.cont_no IS '保险单号';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_insurance_info.insurance_id IS '险种ID';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_insurance_info.insurance_code IS '险种代码';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_insurance_info.main_insurance_code IS '险种对应的主险种编码';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_insurance_info.insurance_name IS '险种名称';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_insurance_info.insurance_type IS '主附险标志';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_insurance_info.sum_buy_part IS '投保份数';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_insurance_info.sum_pre IS '险种总保额';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_insurance_info.sum_cov IS '险种总保费';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_insurance_info.pay_type IS '缴费类型:0-趸交,1-期缴';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_insurance_info.pay_freq IS '期缴缴费频次(缴费类型为趸交时无值):12-年交,6-半年交,3-季交,1-月交,-1-不定期交';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_insurance_info.pay_per_unit IS '期缴缴费周期计算单位(缴费类型为趸交时无值):12-按年计算,1-按月计算,2-按日计算,0-交至某确定年龄,-1-终生交费';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_insurance_info.pay_per_num IS '期缴缴费周期计算数量';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_insurance_info.valid_per_unit IS '保险周期计算单位:12-按年计算,1-按月保计算,2-按日计算,0-保至某确定年龄,-1-保终身';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_insurance_info.valid_per_num IS '保险周期计算数量';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_insurance_info.bonus_get_mode IS '红利领取方式:1-累计生息,3-抵交保费,4-现金领取,5-增额交清';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_insurance_info.auto_pay_flag IS '自动垫交标志:0-否,1-是';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_insurance_info.lxgetintv IS '万能险领取方式:0-趸领,1-月领,12-年领';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_insurance_info.sttlmnt_pymnt_age IS '年金起领年龄';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_insurance_info.sttlmnt_pymnt_freq IS '年金领取频率:使用YBT_INSURANCE_STTLMNT_INFO表存储';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_insurance_info.sttlmnt_pymnt_type IS '年金领取方式:使用YBT_INSURANCE_STTLMNT_INFO表存储';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_insurance_info.sttlmnt_pymnt_end_age IS '年金止领年龄';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_insurance_info.ryzd IS '冗余字段';
