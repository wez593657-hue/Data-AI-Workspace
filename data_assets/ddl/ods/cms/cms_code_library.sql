/*
 * 上游信贷系统
 * 表名: crmdm.cms_code_library
 * 来源: TB.ddl
 */

-- crmdm.cms_code_library 定义

-- Drop table

-- DROP TABLE crmdm.cms_code_library;

CREATE TABLE crmdm.cms_code_library (
    codeno varchar(32) NOT NULL,
    itemno varchar(32) NOT NULL,
    itemname varchar(250) NULL,
    bankno varchar(32) NULL,
    sortno varchar(32) NULL,
    isinuse varchar(18) NULL,
    itemdescribe varchar(800) NULL,
    itemattribute varchar(800) NULL,
    relativecode varchar(4000) NULL,
    attribute1 varchar(800) NULL,
    attribute2 varchar(800) NULL,
    attribute3 varchar(800) NULL,
    attribute4 varchar(4000) NULL,
    attribute5 varchar(250) NULL,
    attribute6 varchar(250) NULL,
    attribute7 varchar(250) NULL,
    attribute8 varchar(250) NULL,
    inputuser varchar(32) NULL,
    inputorg varchar(32) NULL,
    inputtime varchar(20) NULL,
    updateuser varchar(32) NULL,
    updatetime varchar(20) NULL,
    remark varchar(250) NULL,
    helptext varchar(250) NULL,
    relativeno varchar(32) NULL,
    hxcode varchar(32) NULL,
    ryzd varchar(1) NULL,
    CONSTRAINT pk_cms_code_library PRIMARY KEY (codeno,
    itemno)
);