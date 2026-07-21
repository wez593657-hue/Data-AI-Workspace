/*
 * 上游智能存款系统
 * 表名: crmdm.cds_t1_cust_info
 * 来源: TB.ddl
 */

-- crmdm.cds_t1_cust_info 定义

-- Drop table

-- DROP TABLE crmdm.cds_t1_cust_info;

CREATE TABLE crmdm.cds_t1_cust_info (
    cust_no bpchar(8) NOT NULL,
    fund_id_type varchar(2) NULL,
    main_trans_acct_no bpchar(17) NULL,
    id_type varchar(2) NOT NULL,
    id_code varchar(32) NOT NULL,
    cust_name varchar(128) NOT NULL,
    cust_type bpchar(1) NOT NULL,
    cust_level varchar(8) NULL,
    cust_card_type varchar(8) NULL,
    instrepr_name varchar(128) NULL,
    instrepr_id_type varchar(2) NULL,
    instrepr_id_code varchar(32) NULL,
    agent_name varchar(128) NULL,
    agent_id_type varchar(2) NULL,
    agent_id_code varchar(32) NULL,
    birthday bpchar(8) NULL,
    sex bpchar(1) NULL,
    education bpchar(1) NULL,
    mobile varchar(20) NULL,
    home_tel varchar(20) NULL,
    office_tel varchar(20) NULL,
    fax varchar(20) NULL,
    postcode bpchar(6) NULL,
    addr varchar(128) NULL,
    email varchar(64) NULL,
    cust_manager varchar(20) NULL,
    fnc_manager varchar(20) NULL,
    protocol_serno varchar(32) NULL,
    protocol_status bpchar(1) NOT NULL,
    bank_code varchar(20) NOT NULL,
    branch_code varchar(20) NOT NULL,
    sub_branch_code varchar(20) NOT NULL,
    inputuser varchar(20) NOT NULL,
    crt_date bpchar(8) NOT NULL,
    crt_time bpchar(6) NOT NULL,
    inv_date bpchar(8) NULL,
    inv_time bpchar(6) NULL,
    remark varchar(255) NULL,
    upd_date bpchar(8) NOT NULL,
    upd_time bpchar(6) NOT NULL,
    ifemployee bpchar(1) NULL,
    host_cust_no varchar(32) NULL,
    ryzd varchar(1) NULL,
    CONSTRAINT pk_cds_t1_cust_info PRIMARY KEY (cust_no)
);