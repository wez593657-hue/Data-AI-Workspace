/*
 * 上游ECIF系统
 * 表名: crmdm.ecif_t01_p_relationer_info
 * 来源: TB.ddl
 */

-- crmdm.ecif_t01_p_relationer_info 定义

-- Drop table

-- DROP TABLE crmdm.ecif_t01_p_relationer_info;

CREATE TABLE crmdm.ecif_t01_p_relationer_info (
    relation_id bpchar(20) NOT NULL,
    cert_issue_date sys."date" NULL,
    cert_expd_date sys."date" NULL,
    cert_org_area varchar(30) NULL,
    nat_code varchar(30) NULL,
    gender varchar(30) NULL,
    birth_date sys."date" NULL,
    educ_sign varchar(30) NULL,
    econ_resur varchar(30) NULL,
    work_corp varchar(120) NULL,
    work_addr varchar(160) NULL,
    unit_type varchar(30) NULL,
    industry_type varchar(30) NULL,
    profession varchar(30) NULL,
    poston varchar(30) NULL,
    tech_title varchar(30) NULL,
    year_salary numeric(20,
    2) NULL,
    home_addr varchar(160) NULL,
    post_cd varchar(6) NULL,
    find_addr varchar(160) NULL,
    findtel_no varchar(36) NULL,
    mobile_no varchar(36) NULL,
    contact_dept varchar(100) NULL,
    fax_no varchar(36) NULL,
    email varchar(160) NULL,
    url_addr varchar(160) NULL,
    oicq_no varchar(20) NULL,
    msg_addr varchar(80) NULL,
    fancy_desc varchar(200) NULL,
    eff_status bpchar(1) NULL,
    last_updated_te varchar(20) NULL,
    last_updated_org varchar(20) NULL,
    created_ts timestamp(6) NULL,
    updated_ts timestamp(6) NULL,
    init_system_id varchar(30) NOT NULL,
    init_created_ts timestamp(6) NULL,
    last_system_id varchar(30) NOT NULL,
    last_updated_ts timestamp(6) NULL,
    ryzd varchar(1) NULL
);