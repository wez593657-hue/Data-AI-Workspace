/*
 * 上游网联系统
 * 表名: crmdm.uepp_pay_mct_channel_info
 * 来源: TB.ddl
 */

-- crmdm.uepp_pay_mct_channel_info 定义

-- Drop table

-- DROP TABLE crmdm.uepp_pay_mct_channel_info;

CREATE TABLE crmdm.uepp_pay_mct_channel_info (
    channel varchar(40) NOT NULL,
    pay_type varchar(40) NOT NULL,
    mct_id varchar(40) NOT NULL,
    fee_rate numeric(16,
    4) NULL,
    server_id varchar(40) NULL,
    amt_limit_min numeric(16,
    2) NULL,
    amt_limit_max numeric(16,
    2) NULL,
    pay_submct_id varchar(40) NULL,
    remark varchar(300) NULL,
    limit_pay varchar(40) NULL,
    status varchar(2) NULL,
    create_user varchar(40) NULL,
    create_time varchar(20) NULL,
    update_user varchar(40) NULL,
    update_time varchar(20) NULL,
    feetype varchar(2) NULL,
    fee_rate_credit_smallamt numeric(16,
    4) NULL,
    fee_rate_credit_largeamt numeric(16,
    4) NULL,
    fee_rate_debit_smallamt numeric(16,
    4) NULL,
    fee_rate_debit_largeamt numeric(16,
    4) NULL,
    check_status varchar(2) NULL,
    line_type varchar(10) NOT NULL,
    check_task_id varchar(40) NULL,
    nu_submct_id varchar(40) NULL,
    pay_submct_id_netunion varchar(40) NULL,
    ryzd varchar(1) NULL,
    CONSTRAINT pk_uepp_pay_mct_channel_info PRIMARY KEY (pay_type,
    mct_id,
    line_type)
);