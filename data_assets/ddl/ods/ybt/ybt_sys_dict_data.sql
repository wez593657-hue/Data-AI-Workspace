/*
 * 上游银保通系统
 * 表名: crmdm.ybt_sys_dict_data
 * 来源: TB.ddl
 */

-- crmdm.ybt_sys_dict_data 定义

-- Drop table

-- DROP TABLE crmdm.ybt_sys_dict_data;

CREATE TABLE crmdm.ybt_sys_dict_data (
    dict_code numeric(20) NOT NULL,
    dict_sort numeric(4) NULL,
    dict_label varchar(100) NULL,
    dict_value varchar(100) NULL,
    dict_type varchar(100) NULL,
    css_class varchar(100) NULL,
    list_class varchar(100) NULL,
    is_default bpchar(1) NULL,
    status bpchar(1) NULL,
    create_by varchar(64) NULL,
    create_time DATE NULL,
    update_by varchar(64) NULL,
    update_time DATE NULL,
    remark varchar(500) NULL,
    ryzd varchar(1) NULL,
    CONSTRAINT pk_ybt_sys_dict_data PRIMARY KEY (dict_code)
);