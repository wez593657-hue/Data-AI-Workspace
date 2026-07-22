/*
 * 上游银保通系统
 * 表名: crmdm.ybt_ybt_product_branch
 * 来源: TB.ddl
 */

-- crmdm.ybt_ybt_product_branch 定义

-- Drop table

-- DROP TABLE crmdm.ybt_ybt_product_branch;

CREATE TABLE crmdm.ybt_ybt_product_branch (
    product_id varchar(200) NOT NULL,
    branch_no varchar(200) NOT NULL,
    ryzd varchar(1) NULL
);