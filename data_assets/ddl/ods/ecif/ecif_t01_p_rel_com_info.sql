/*
 * 上游ECIF系统
 * 表名: crmdm.ecif_t01_p_rel_com_info
 * 来源: TB.ddl
 */

-- crmdm.ecif_t01_p_rel_com_info 定义

-- Drop table

-- DROP TABLE crmdm.ecif_t01_p_rel_com_info;

CREATE TABLE crmdm.ecif_t01_p_rel_com_info (
    relation_id bpchar(20) NOT NULL,
    cert_expd_date DATE NULL,
    govn_cert_no varchar(30) NULL,
    govn_efft_date DATE NULL,
    govn_expd_date DATE NULL,
    acct_lic_no varchar(30) NULL,
    loan_card_no varchar(30) NULL,
    org_code varchar(20) NULL,
    unit_credit_code varchar(30) NULL,
    reg_date DATE NULL,
    reg_cptl numeric(20,
    2) NULL,
    reg_cptl_curr varchar(30) NULL,
    paid_cptl numeric(20,
    2) NULL,
    paid_cptl_curr varchar(30) NULL,
    comp_size varchar(30) NULL,
    register_add varchar(160) NULL,
    comp_type varchar(30) NULL,
    industry_type varchar(30) NULL,
    econ_kind varchar(30) NULL,
    admn_type varchar(1600) NULL,
    tax_reg_no varchar(30) NULL,
    tax_area_no varchar(30) NULL,
    legal_name varchar(100) NULL,
    legal_cert_type varchar(30) NULL,
    legal_cert_no varchar(30) NULL,
    legal_cert_expd_date DATE NULL,
    post_cd varchar(6) NULL,
    region_code varchar(30) NULL,
    office_tel varchar(36) NULL,
    office_fax varchar(36) NULL,
    web_add varchar(160) NULL,
    email_add varchar(160) NULL,
    com_add varchar(160) NULL,
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