/*
 * 上游中间业务系统
 * 表名: crmdm.ibp_ybt_insurance_base_info
 * 来源: TB.ddl
 */

-- crmdm.ibp_ybt_insurance_base_info 定义

-- Drop table

-- DROP TABLE crmdm.ibp_ybt_insurance_base_info;

CREATE TABLE crmdm.ibp_ybt_insurance_base_info (
	insurance_id varchar(200) NOT NULL,
	item_id varchar(40) NOT NULL,
	item_name varchar(800) NOT NULL,
	insurance_code varchar(200) NOT NULL,
	main_insurance_code varchar(200) NOT NULL,
	insurance_name varchar(800) NOT NULL,
	insurance_type varchar(8) NOT NULL,
	insurance_classify varchar(40) NOT NULL,
	is_can_payall varchar(8) NOT NULL,
	is_can_pay_part varchar(8) NOT NULL,
	is_part_buy varchar(8) NOT NULL,
	lowest_part numeric(10) NOT NULL,
	trial_method varchar(8) NOT NULL,
	trial_type varchar(8) NOT NULL,
	trialamt numeric(17, 2) NOT NULL,
	insurance_status varchar(8) NOT NULL,
	insurance_remark varchar(2000) NULL,
	create_time sys."date" NULL,
	create_user varchar(200) NULL,
	create_user_name varchar(800) NULL,
	update_time sys."date" NULL,
	update_user varchar(200) NULL,
	update_user_name varchar(800) NULL,
	accumulation_amt numeric(17, 2) NULL,
	sttlmnt_pymnt_age varchar(40) NULL,
	auto_pay_show_flag varchar(40) NULL,
	sttlmnt_pymnt_freq varchar(40) NULL,
	sttlmnt_pymnt_type varchar(40) NULL,
	sttlmnt_pymnt_end_age varchar(40) NULL,
	ryzd varchar(1) NULL
);

