-- crmdm.ibp_ybt_product_info 定义

-- Drop table

-- DROP TABLE crmdm.ibp_ybt_product_info;

CREATE TABLE crmdm.ibp_ybt_product_info (
	product_id varchar(200) NOT NULL, -- 产品ID
	item_id varchar(40) NOT NULL, -- 保险公司编号(项目编号）
	item_name varchar(800) NOT NULL, -- 保险公司名称(项目名称）
	product_name varchar(800) NOT NULL, -- 产品名称
	commission_type varchar(8) NOT NULL, -- 收取类型：0-不涉及,1-按保额收取,2-按保费收取
	commission_ratio numeric(6, 3) NOT NULL, -- 手续费比例(%）
	risk_grade varchar(8) NOT NULL, -- 产品风险等级
	product_big_type varchar(40) NOT NULL, -- 产品监管大分类编码
	product_lit_type varchar(40) NOT NULL, -- 产品监管小分类编码
	product_remark varchar(2000) NULL, -- 产品描述
	product_status varchar(8) NOT NULL, -- 产品状态:0-正常,1-失效
	create_time sys."date" NULL, -- 新增时间(yyyyMMdd HH:mm:ss）
	create_user varchar(200) NOT NULL, -- 新增用户编号
	create_user_name varchar(800) NULL, -- 新增用户名
	update_time sys."date" NULL, -- 最近一次修改时间(yyyyMMdd HH:mm:ss）
	update_user varchar(200) NULL, -- 最近一次修改用户编号
	update_user_name varchar(800) NULL, -- 最近一次修改用户名
	is_recommend varchar(2) NULL, -- 是否主推产品: 1:是 0:否
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.ibp_ybt_product_info.product_id IS '产品ID';
COMMENT ON COLUMN crmdm.ibp_ybt_product_info.item_id IS '保险公司编号(项目编号）';
COMMENT ON COLUMN crmdm.ibp_ybt_product_info.item_name IS '保险公司名称(项目名称）';
COMMENT ON COLUMN crmdm.ibp_ybt_product_info.product_name IS '产品名称';
COMMENT ON COLUMN crmdm.ibp_ybt_product_info.commission_type IS '收取类型：0-不涉及,1-按保额收取,2-按保费收取';
COMMENT ON COLUMN crmdm.ibp_ybt_product_info.commission_ratio IS '手续费比例(%）';
COMMENT ON COLUMN crmdm.ibp_ybt_product_info.risk_grade IS '产品风险等级';
COMMENT ON COLUMN crmdm.ibp_ybt_product_info.product_big_type IS '产品监管大分类编码';
COMMENT ON COLUMN crmdm.ibp_ybt_product_info.product_lit_type IS '产品监管小分类编码';
COMMENT ON COLUMN crmdm.ibp_ybt_product_info.product_remark IS '产品描述';
COMMENT ON COLUMN crmdm.ibp_ybt_product_info.product_status IS '产品状态:0-正常,1-失效';
COMMENT ON COLUMN crmdm.ibp_ybt_product_info.create_time IS '新增时间(yyyyMMdd HH:mm:ss）';
COMMENT ON COLUMN crmdm.ibp_ybt_product_info.create_user IS '新增用户编号';
COMMENT ON COLUMN crmdm.ibp_ybt_product_info.create_user_name IS '新增用户名';
COMMENT ON COLUMN crmdm.ibp_ybt_product_info.update_time IS '最近一次修改时间(yyyyMMdd HH:mm:ss）';
COMMENT ON COLUMN crmdm.ibp_ybt_product_info.update_user IS '最近一次修改用户编号';
COMMENT ON COLUMN crmdm.ibp_ybt_product_info.update_user_name IS '最近一次修改用户名';
COMMENT ON COLUMN crmdm.ibp_ybt_product_info.is_recommend IS '是否主推产品: 1:是 0:否';
COMMENT ON COLUMN crmdm.ibp_ybt_product_info.ryzd IS '冗余字段';
