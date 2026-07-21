/*
 * 上游ECIF系统
 * 表名: crmdm.ecif_t01_c_party_resolve
 * 来源: TB.ddl
 */

-- crmdm.ecif_t01_c_party_resolve 定义

-- Drop table

-- DROP TABLE crmdm.ecif_t01_c_party_resolve;

CREATE TABLE crmdm.ecif_t01_c_party_resolve (
    party_resolve_id bpchar(20) NULL,
    party_id bpchar(20) NULL,
    cert_type varchar(30) NULL,
    cert_no varchar(30) NULL,
    cert_issue_org varchar(60) NULL,
    cert_issue_date sys."date" NULL,
    cert_expd_date sys."date" NULL,
    main_cert_flag bpchar(1) NULL,
    cust_flag varchar(30) NULL,
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