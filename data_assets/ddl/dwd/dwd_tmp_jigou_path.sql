/*
 * DWD层表
 * 表名: crmdm.dwd_tmp_jigou_path
 * 来源: TB.ddl
 */

-- crmdm.dwd_tmp_jigou_path 定义

-- Drop table

-- DROP TABLE crmdm.dwd_tmp_jigou_path;

CREATE TABLE crmdm.dwd_tmp_jigou_path (
    org_id varchar(7) NULL,
    sup_org_id varchar(7) NULL,
    org_path varchar(200) NULL,
    org_harcy varchar(10) NULL
);



COMMENT ON TABLE DWD_TMP_JIGOU_PATH IS '【待补充】';