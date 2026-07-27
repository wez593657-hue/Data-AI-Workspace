-- crmdm.ibp_ybt_product_branch 定义

-- Drop table

-- DROP TABLE crmdm.ibp_ybt_product_branch;

CREATE TABLE crmdm.ibp_ybt_product_branch (
	product_id varchar(200) NOT NULL, -- 产品ID
	branch_no varchar(200) NOT NULL, -- 网点编码
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.ibp_ybt_product_branch.product_id IS '产品ID';
COMMENT ON COLUMN crmdm.ibp_ybt_product_branch.branch_no IS '网点编码';
COMMENT ON COLUMN crmdm.ibp_ybt_product_branch.ryzd IS '冗余字段';
