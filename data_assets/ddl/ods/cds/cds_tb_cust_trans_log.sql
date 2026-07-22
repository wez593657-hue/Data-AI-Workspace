/*
 * 上游智能存款系统
 * 表名: crmdm.cds_tb_cust_trans_log
 * 来源: TB.ddl
 */

-- crmdm.cds_tb_cust_trans_log 定义

-- Drop table

-- DROP TABLE crmdm.cds_tb_cust_trans_log;

CREATE TABLE crmdm.cds_tb_cust_trans_log (
    trans_serno varchar(32) NOT NULL,
    trans_date bpchar(8) NOT NULL,
    business_serno varchar(32) NULL,
    channel_serno varchar(32) NULL,
    cash_acct_no varchar(32) NULL,
    reserve varchar(32) NULL,
    trans_type bpchar(2) NOT NULL,
    fnc_trans_acct_no bpchar(17) NULL,
    card_no varchar(32) NULL,
    cust_no bpchar(8) NULL,
    cust_name varchar(128) NULL,
    id_type varchar(2) NULL,
    id_code varchar(32) NULL,
    mobile varchar(20) NULL,
    cust_type bpchar(1) NULL,
    cust_level varchar(8) NULL,
    cust_card_type varchar(8) NULL,
    exclusive_code bpchar(4) NULL,
    ori_trans_serno varchar(32) NULL,
    agr_sav_rate numeric(12,
    5) NULL,
    agr_term varchar(4) NULL,
    term_acct_no varchar(32) NULL,
    buy_type bpchar(1) NULL,
    acct_no varchar(32) NULL,
    trans_amt numeric(16,
    2) NULL,
    prod_code varchar(32) NULL,
    agent_name varchar(128) NULL,
    agent_id_type varchar(2) NULL,
    agent_id_code varchar(32) NULL,
    cust_manager varchar(20) NULL,
    trans_status bpchar(2) NOT NULL,
    rtn_code varchar(16) NULL,
    rtn_desc varchar(256) NULL,
    host_trans_serno varchar(32) NULL,
    host_rtn_code varchar(16) NULL,
    host_rtn_desc varchar(256) NULL,
    oper_teller varchar(20) NOT NULL,
    auth_teller varchar(20) NULL,
    daily_batch bpchar(1) NULL,
    remark varchar(256) NULL,
    capital_status bpchar(2) NOT NULL,
    trans_channel bpchar(1) NOT NULL,
    trans_orgno varchar(20) NOT NULL,
    trans_branch varchar(20) NOT NULL,
    trans_head_office varchar(20) NOT NULL,
    card_orgno varchar(20) NOT NULL,
    card_branch varchar(20) NOT NULL,
    card_head_office varchar(20) NOT NULL,
    exp_date bpchar(8) NULL,
    should_date bpchar(8) NOT NULL,
    term_serial_no varchar(32) NULL,
    card_serno varchar(20) NULL,
    crt_date bpchar(8) NOT NULL,
    crt_time bpchar(6) NOT NULL,
    upd_date bpchar(8) NOT NULL,
    upd_time bpchar(6) NOT NULL,
    oper_orgno varchar(20) NOT NULL,
    agent_phone_num varchar(18) NULL,
    agent_nationality varchar(32) NULL,
    agent_english_name varchar(32) NULL,
    ryzd varchar(1) NULL,
    CONSTRAINT pk_cds_tb_cust_trans_log PRIMARY KEY (trans_serno)
);