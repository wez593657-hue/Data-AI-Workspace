-- crmdm.cms_customer_crm_core 定义

-- Drop table

-- DROP TABLE crmdm.cms_customer_crm_core;

CREATE TABLE crmdm.cms_customer_crm_core (
	customerid varchar(32) NULL,
	customeridcore varchar(32) NULL,
	linktime varchar(20) NULL,
	linkuserid varchar(32) NULL
);
CREATE UNIQUE INDEX pk_customer_crm_core ON crmdm.cms_customer_crm_core USING btree (customerid, customeridcore);
