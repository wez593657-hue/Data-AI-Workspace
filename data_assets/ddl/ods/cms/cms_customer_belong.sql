-- crmdm.cms_customer_belong 定义

-- Drop table

-- DROP TABLE crmdm.cms_customer_belong;

CREATE TABLE crmdm.cms_customer_belong (
	customerid varchar(40) NOT NULL,
	orgid varchar(40) NOT NULL,
	userid varchar(40) NOT NULL,
	belongattribute varchar(80) NULL,
	belongattribute1 varchar(80) NULL,
	belongattribute2 varchar(80) NULL,
	belongattribute3 varchar(80) NULL,
	belongattribute4 varchar(80) NULL,
	inputuserid varchar(80) NULL,
	inputorgid varchar(80) NULL,
	inputdate varchar(80) NULL,
	updatedate varchar(10) NULL,
	applyattribute varchar(80) NULL,
	applyattribute1 varchar(80) NULL,
	applyattribute2 varchar(80) NULL,
	applyattribute3 varchar(80) NULL,
	applyattribute4 varchar(80) NULL,
	remark varchar(250) NULL,
	applystatus varchar(20) NULL,
	applyreason varchar(500) NULL,
	applyright varchar(20) NULL,
	applytype varchar(20) NULL,
	ryzd varchar(1) NULL
);
CREATE UNIQUE INDEX index_crmdm_cms_customer_belong_index_1 ON crmdm.cms_customer_belong USING btree (customerid, orgid, userid);
