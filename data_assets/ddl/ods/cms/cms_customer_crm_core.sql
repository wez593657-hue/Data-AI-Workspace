/*
 * 上游信贷系统
 * 表名: crmdm.cms_customer_crm_core
 * 来源: TB.ddl
 */

-- crmdm.cms_customer_crm_core 定义

-- Drop table

-- DROP TABLE crmdm.cms_customer_crm_core;

CREATE TABLE crmdm.cms_customer_crm_core (
    customerid varchar(32) NULL,
    customeridcore varchar(32) NULL,
    linktime varchar(20) NULL,
    linkuserid varchar(32) NULL
);