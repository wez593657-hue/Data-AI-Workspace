/*
 * 上游中间业务系统
 * 表名: crmdm.ibp_ybt_product_info
 * 来源: TB.ddl
 */

-- crmdm.ibp_ybt_product_info 定义

-- Drop table

-- DROP TABLE crmdm.ibp_ybt_product_info;

CREATE TABLE crmdm.ibp_ybt_product_info (
	product_id varchar(200) NOT NULL,
	item_id varchar(40) NOT NULL,
	item_name varchar(800) NOT NULL,
	product_name varchar(800) NOT NULL,
	commission_type varchar(8) NOT NULL,
	commission_ratio numeric(6, 3) NOT NULL,
	risk_grade varchar(8) NOT NULL,
	product_big_type varchar(40) NOT NULL,
	product_lit_type varchar(40) NOT NULL,
	product_remark varchar(2000) NULL,
	product_status varchar(8) NOT NULL,
	create_time sys."date" NULL,
	create_user varchar(200) NOT NULL,
	create_user_name varchar(800) NULL,
	update_time sys."date" NULL,
	update_user varchar(200) NULL,
	update_user_name varchar(800) NULL,
	is_recommend varchar(2) NULL,
	ryzd varchar(1) NULL
);

