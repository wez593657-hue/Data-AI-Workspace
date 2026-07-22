/*
 * 上游银保通系统
 * 表名: crmdm.ybt_ybt_policy_insurance_info
 * 来源: TB.ddl
 */

-- crmdm.ybt_ybt_policy_insurance_info 定义

-- Drop table

-- DROP TABLE crmdm.ybt_ybt_policy_insurance_info;

CREATE TABLE crmdm.ybt_ybt_policy_insurance_info (
    plat_policy_serial varchar(200) NOT NULL,
    item_id varchar(40) NOT NULL,
    cont_no varchar(200) NULL,
    insurance_id varchar(200) NOT NULL,
    insurance_code varchar(200) NOT NULL,
    main_insurance_code varchar(200) NOT NULL,
    insurance_name varchar(800) NOT NULL,
    insurance_type varchar(8) NOT NULL,
    sum_buy_part numeric(10) NOT NULL,
    sum_pre numeric(17,
    2) NOT NULL,
    sum_cov numeric(17,
    2) NOT NULL,
    pay_type varchar(8) NOT NULL,
    pay_freq varchar(16) NULL,
    pay_per_unit varchar(16) NULL,
    pay_per_num numeric(10) NULL,
    valid_per_unit varchar(16) NOT NULL,
    valid_per_num numeric(10) NOT NULL,
    bonus_get_mode varchar(8) NULL,
    auto_pay_flag varchar(8) NULL,
    lxgetintv varchar(16) NULL,
    sttlmnt_pymnt_age varchar(40) NULL,
    sttlmnt_pymnt_freq varchar(40) NULL,
    sttlmnt_pymnt_type varchar(40) NULL,
    sttlmnt_pymnt_end_age varchar(40) NULL,
    ryzd varchar(1) NULL
);