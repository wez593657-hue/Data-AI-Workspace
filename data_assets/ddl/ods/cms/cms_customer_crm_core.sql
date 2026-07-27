-- crmdm.cms_customer_crm_core 定义

-- Drop table

-- DROP TABLE crmdm.cms_customer_crm_core;

CREATE TABLE crmdm.cms_customer_crm_core (
	customerid varchar(32) NULL, -- 客户编号
	customeridcore varchar(32) NULL, -- 核心客户号
	linktime varchar(20) NULL, -- 关联时间
	linkuserid varchar(32) NULL -- 关联操作人
);
CREATE UNIQUE INDEX pk_customer_crm_core ON crmdm.cms_customer_crm_core USING btree (customerid, customeridcore);

-- Column comments

COMMENT ON COLUMN crmdm.cms_customer_crm_core.customerid IS '客户编号';
COMMENT ON COLUMN crmdm.cms_customer_crm_core.customeridcore IS '核心客户号';
COMMENT ON COLUMN crmdm.cms_customer_crm_core.linktime IS '关联时间';
COMMENT ON COLUMN crmdm.cms_customer_crm_core.linkuserid IS '关联操作人';
