/*
 * 上游智能存款系统
 * 表名: crmdm.cds_tb_prod_pub_info
 * 来源: TB.ddl
 */

-- crmdm.cds_tb_prod_pub_info 定义

-- Drop table

-- DROP TABLE crmdm.cds_tb_prod_pub_info;

CREATE TABLE crmdm.cds_tb_prod_pub_info (
    prod_code varchar(32) NOT NULL,
    prod_glob_code varchar(32) NULL,
    prod_name varchar(128) NOT NULL,
    prod_status bpchar(1) NOT NULL,
    prod_class bpchar(1) NOT NULL,
    prod_subclass bpchar(1) NOT NULL,
    sale_begin_date bpchar(8) NOT NULL,
    sale_begin_time bpchar(6) NOT NULL,
    sale_end_date bpchar(8) NULL,
    sale_end_time bpchar(6) NULL,
    allow_sale_channel varchar(20) NOT NULL,
    allow_sex_limit varchar(2) NOT NULL,
    allow_cust_type bpchar(1) NOT NULL,
    allow_card_type varchar(20) NULL,
    allow_cust_level varchar(20) NULL,
    allow_white_type varchar(32) NULL,
    allow_max_age numeric(3) NULL,
    allow_min_age numeric(3) NULL,
    sale_org bpchar(1) NULL,
    rate_days bpchar(1) NULL,
    calc_type varchar(3) NOT NULL,
    calc_date bpchar(8) NULL,
    interest_type varchar(3) NOT NULL,
    interest_date bpchar(8) NULL,
    part_draw_interest bpchar(1) NULL,
    account_no varchar(32) NULL,
    is_exclusive bpchar(1) NULL,
    exclusive_count numeric(10) NULL,
    min_deposit_amt numeric(16,
    2) NULL,
    step_amt numeric(16,
    2) NULL,
    min_hold_amt numeric(16,
    2) NULL,
    max_hold_amt numeric(16,
    2) NULL,
    inc_due varchar(4) NULL,
    crt_user varchar(20) NULL,
    crt_orgno varchar(20) NULL,
    draw_due varchar(4) NULL,
    belong_org varchar(20) NULL,
    crt_date bpchar(8) NOT NULL,
    crt_time bpchar(6) NOT NULL,
    upd_date bpchar(8) NOT NULL,
    upd_time bpchar(6) NOT NULL,
    is_boutique bpchar(1) NULL,
    prod_flag bpchar(1) NOT NULL,
    seven_notice_amt numeric(16,
    2) NULL,
    ryzd varchar(1) NULL,
    CONSTRAINT pk_cds_tb_prod_pub_info PRIMARY KEY (prod_code)
);