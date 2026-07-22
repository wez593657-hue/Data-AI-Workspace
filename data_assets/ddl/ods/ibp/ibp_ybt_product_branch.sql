/*
 * 上游中间业务系统
 * 表名: crmdm.ibp_ybt_product_branch
 * 来源: TB.ddl
 */

-- crmdm.ibp_ybt_product_branch 定义

-- Drop table

-- DROP TABLE crmdm.ibp_ybt_product_branch;

CREATE TABLE crmdm.ibp_ybt_product_branch (
    product_id varchar(200) NOT NULL,
    branch_no varchar(200) NOT NULL,
    ryzd varchar(1) NULL
);