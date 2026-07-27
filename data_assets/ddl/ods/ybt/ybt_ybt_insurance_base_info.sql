-- crmdm.ybt_ybt_insurance_base_info 定义

-- Drop table

-- DROP TABLE crmdm.ybt_ybt_insurance_base_info;

CREATE TABLE crmdm.ybt_ybt_insurance_base_info (
	insurance_id varchar(200) NOT NULL, -- 险种ID
	item_id varchar(40) NOT NULL, -- 保险公司编号（项目编号 )
	item_name varchar(800) NOT NULL, -- 保险公司名称（项目名称 )
	insurance_code varchar(200) NOT NULL, -- 险种代码
	main_insurance_code varchar(200) NOT NULL, -- 险种对应的主险种编码
	insurance_name varchar(800) NOT NULL, -- 险种名称
	insurance_type varchar(8) NOT NULL, -- 主附险标志（0：主险，1附加险 )
	insurance_classify varchar(40) NOT NULL, -- 险种分类:详见SYS_DICT_DATA表DICT_VALUE,DICT_LABEL字段,条件DICT_TYPE= sys_bankInsurance_insuranceType
	is_can_payall varchar(8) NOT NULL, -- 是否支持趸交（0：支持，1：不支持 )
	is_can_pay_part varchar(8) NOT NULL, -- 是否支持期交（0：支持，1：不支持 )
	is_part_buy varchar(8) NOT NULL, -- 是否按份购买（0：是，1：不是 )
	lowest_part numeric(10) NOT NULL, -- 最低购买份数
	trial_method varchar(8) NOT NULL, -- 保费试算方式(0：按保费算，1 按保额算  )
	trial_type varchar(8) NOT NULL, -- 保额/保费类型 (0：固定保额/保费,1：最低保额/保费 )
	trialamt numeric(17, 2) NOT NULL, -- 保额/保费
	insurance_status varchar(8) NOT NULL, -- 险种状态（0：正常 ，1 失效 )
	insurance_remark varchar(2000) NULL, -- 险种描述
	create_time sys."date" NULL, -- 新增时间（yyyyMMdd HH:mm:ss )
	create_user varchar(200) NULL, -- 新增用户编号
	create_user_name varchar(800) NULL, -- 新增用户名
	update_time sys."date" NULL, -- 最近一次修改时间（yyyyMMdd HH:mm:ss )
	update_user varchar(200) NULL, -- 最近一次修改用户编号
	update_user_name varchar(800) NULL, -- 最近一次修改用户名
	accumulation_amt numeric(17, 2) NULL, -- 保额/保费单次累加金额
	sttlmnt_pymnt_age varchar(40) NULL, -- 年金起领年龄
	auto_pay_show_flag varchar(40) NULL, -- 垫交方式选择标识
	sttlmnt_pymnt_freq varchar(40) NULL, -- 年金领取频率(弃用,年金信息使用YBT_INSURANCE_STTLMNT_INFO表存储)
	sttlmnt_pymnt_type varchar(40) NULL, -- 年金领取方式(弃用,年金信息使用YBT_INSURANCE_STTLMNT_INFO表存储)
	sttlmnt_pymnt_end_age varchar(40) NULL, -- 年金止领年龄
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.insurance_id IS '险种ID';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.item_id IS '保险公司编号（项目编号 )';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.item_name IS '保险公司名称（项目名称 )';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.insurance_code IS '险种代码';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.main_insurance_code IS '险种对应的主险种编码';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.insurance_name IS '险种名称';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.insurance_type IS '主附险标志（0：主险，1附加险 )';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.insurance_classify IS '险种分类:详见SYS_DICT_DATA表DICT_VALUE,DICT_LABEL字段,条件DICT_TYPE= sys_bankInsurance_insuranceType';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.is_can_payall IS '是否支持趸交（0：支持，1：不支持 )';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.is_can_pay_part IS '是否支持期交（0：支持，1：不支持 )';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.is_part_buy IS '是否按份购买（0：是，1：不是 )';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.lowest_part IS '最低购买份数';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.trial_method IS '保费试算方式(0：按保费算，1 按保额算  )';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.trial_type IS '保额/保费类型 (0：固定保额/保费,1：最低保额/保费 )';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.trialamt IS '保额/保费';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.insurance_status IS '险种状态（0：正常 ，1 失效 )';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.insurance_remark IS '险种描述';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.create_time IS '新增时间（yyyyMMdd HH:mm:ss )';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.create_user IS '新增用户编号';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.create_user_name IS '新增用户名';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.update_time IS '最近一次修改时间（yyyyMMdd HH:mm:ss )';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.update_user IS '最近一次修改用户编号';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.update_user_name IS '最近一次修改用户名';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.accumulation_amt IS '保额/保费单次累加金额';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.sttlmnt_pymnt_age IS '年金起领年龄';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.auto_pay_show_flag IS '垫交方式选择标识';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.sttlmnt_pymnt_freq IS '年金领取频率(弃用,年金信息使用YBT_INSURANCE_STTLMNT_INFO表存储)';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.sttlmnt_pymnt_type IS '年金领取方式(弃用,年金信息使用YBT_INSURANCE_STTLMNT_INFO表存储)';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.sttlmnt_pymnt_end_age IS '年金止领年龄';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.ryzd IS '冗余字段';
