/*
 * 上游ECIF系统
 * 表名: crmdm.ecif_t03_a_tele_info
 * 来源: TB.ddl
 */

-- crmdm.ecif_t03_a_tele_info 定义

-- Drop table

-- DROP TABLE crmdm.ecif_t03_a_tele_info;

CREATE TABLE crmdm.ecif_t03_a_tele_info (
    tele_id bpchar(20) NULL,
    country_no varchar(6) NULL,
    area_no varchar(6) NULL,
    phone_no varchar(36) NULL,
    ext_no varchar(6) NULL,
    addr_desc varchar(200) NULL,
    last_updated_te varchar(20) NULL,
    last_updated_org varchar(20) NULL,
    created_ts timestamp(6) NULL,
    updated_ts timestamp(6) NULL,
    init_system_id varchar(30) NULL,
    init_created_ts timestamp(6) NULL,
    last_system_id varchar(30) NULL,
    last_updated_ts timestamp(6) NULL,
    ryzd varchar(1) NULL
);