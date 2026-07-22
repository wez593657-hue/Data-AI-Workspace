/*
 * 上游信贷系统
 * 表名: crmdm.cms_customer_realty
 * 来源: TB.ddl
 */

-- crmdm.cms_customer_realty 定义

-- Drop table

-- DROP TABLE crmdm.cms_customer_realty;

CREATE TABLE crmdm.cms_customer_realty (
    customerid varchar(40) NOT NULL,
    serialno varchar(32) NOT NULL,
    certificateno varchar(50) NULL,
    realtyname varchar(100) NULL,
    realtyattribute varchar(18) NULL,
    realtyarea numeric(24,
    6) NULL,
    realtyadd varchar(120) NULL,
    buildprice numeric(24,
    6) NULL,
    evaluateprice numeric(24,
    6) NULL,
    shareprop numeric(10,
    6) NULL,
    purchasedate varchar(10) NULL,
    saledate varchar(10) NULL,
    mortagage varchar(18) NULL,
    uptodate varchar(10) NULL,
    inputorgid varchar(32) NULL,
    inputuserid varchar(32) NULL,
    inputdate varchar(10) NULL,
    updatedate varchar(10) NULL,
    remark varchar(300) NULL,
    realtycontractno varchar(20) NULL,
    realtyformat varchar(32) NULL,
    realtyrank varchar(32) NULL,
    realtyunitprice numeric(24,
    6) NULL,
    completedate varchar(10) NULL,
    downpayment numeric(24,
    6) NULL,
    downpaymentrate numeric(10,
    6) NULL,
    downpaymentsource varchar(32) NULL,
    realtyprovider varchar(60) NULL,
    buildstructure varchar(80) NULL
);