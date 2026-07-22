/*
 * DWD层表
 * 表名: crmdm.dwd_tmp_jigou_code
 * 来源: TB.ddl
 */

-- crmdm.dwd_tmp_jigou_code 定义

-- Drop table

-- DROP TABLE crmdm.dwd_tmp_jigou_code;

CREATE TABLE crmdm.dwd_tmp_jigou_code (
    org_id varchar(7) NULL,
    sup_org_id varchar(7) NULL,
    org_name varchar(500) NULL,
    direct_under_org varchar(7) NULL,
    org_typ varchar(2) NULL,
    org_addrs varchar(800) NULL,
    org_state varchar(1) NULL,
    dsply_seq numeric(19) NULL,
    creatr varchar(64) NULL,
    creat_time varchar(20) NULL,
    creat_org varchar(7) NULL,
    persn_legal_bk_code varchar(30) NULL,
    hr_ms_org_id varchar(80) NULL,
    org_lgtud varchar(30) NULL,
    org_lattud varchar(30) NULL,
    org_rsponr varchar(40) NULL,
    org_tel varchar(30) NULL
);



COMMENT ON TABLE DWD_TMP_JIGOU_CODE IS '【待补充】';