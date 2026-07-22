/*
 * 上游理财系统
 * 表名: crmdm.fms_t4_cust_risk_assess_info
 * 来源: TB.ddl
 */

-- crmdm.fms_t4_cust_risk_assess_info 定义

-- Drop table

-- DROP TABLE crmdm.fms_t4_cust_risk_assess_info;

CREATE TABLE crmdm.fms_t4_cust_risk_assess_info (
    host_cust_no varchar(32) NULL,
    cust_no varchar(20) NULL,
    cust_type varchar(8) NULL,
    cust_risk_level bpchar(1) NULL,
    assess_date bpchar(8) NULL,
    trans_serno varchar(32) NULL,
    remark varchar(255) NULL,
    upd_date bpchar(8) NULL,
    upd_time bpchar(6) NULL,
    id_type varchar(8) NULL,
    id_code varchar(32) NULL,
    invalid_date bpchar(8) NULL,
    publish_code varchar(8) NULL,
    print_no varchar(8) NULL,
    counter_assed bpchar(1) NULL,
    inputuser varchar(20) NULL,
    cust_name varchar(128) NULL,
    sub_branch_code varchar(20) NULL,
    risk_channeled varchar(32) NULL,
    ryzd varchar(1) NULL
);