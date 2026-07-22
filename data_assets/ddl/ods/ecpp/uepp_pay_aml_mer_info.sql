/*
 * 上游网联系统
 * 表名: crmdm.uepp_pay_aml_mer_info
 * 来源: TB.ddl
 */

-- crmdm.uepp_pay_aml_mer_info 定义

-- Drop table

-- DROP TABLE crmdm.uepp_pay_aml_mer_info;

CREATE TABLE crmdm.uepp_pay_aml_mer_info (
    merch_id varchar(20) NOT NULL,
    merch_name varchar(200) NULL,
    merch_tel varchar(32) NULL,
    merch_addr varchar(200) NULL,
    merch_org_id varchar(20) NULL,
    in_bank varchar(1) NULL,
    acct_id varchar(64) NULL,
    is_cust varchar(1) NULL,
    cust_id varchar(32) NULL,
    merch_mcc varchar(4) NULL,
    linkman varchar(96) NULL,
    link_cert_type varchar(48) NULL,
    link_cert_no varchar(60) NULL,
    link_tel varchar(32) NULL,
    link_cell varchar(32) NULL,
    rsrv_01 varchar(32) NULL,
    rsrv_02 varchar(32) NULL,
    rsrv_03 varchar(32) NULL,
    rsrv_04 varchar(32) NULL,
    ryzd varchar(1) NULL,
    CONSTRAINT pk_uepp_pay_aml_mer_info PRIMARY KEY (merch_id)
);