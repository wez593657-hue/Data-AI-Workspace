-- crmdm.ibp_sys_dict_data 定义

-- Drop table

-- DROP TABLE crmdm.ibp_sys_dict_data;

CREATE TABLE crmdm.ibp_sys_dict_data (
	dict_code numeric(20) NOT NULL, -- 字典主键seq_sys_dict_data.nextval
	dict_sort numeric(4) NULL, -- 字典排序
	dict_label varchar(100) NULL, -- 字典标签
	dict_value varchar(100) NULL, -- 字典键值
	dict_type varchar(100) NULL, -- 字典类型
	css_class varchar(100) NULL, -- 样式属性（其他样式扩展）
	list_class varchar(100) NULL, -- 表格回显样式
	is_default bpchar(1) NULL, -- 是否默认（Y是 N否）
	status bpchar(1) NULL, -- 状态（0正常 1停用）
	create_by varchar(64) NULL, -- 创建者
	create_time sys."date" NULL, -- 创建时间
	update_by varchar(64) NULL, -- 更新者
	update_time sys."date" NULL, -- 更新时间
	remark varchar(500) NULL, -- 备注
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_ibp_sys_dict_data PRIMARY KEY (dict_code)
);

-- Column comments

COMMENT ON COLUMN crmdm.ibp_sys_dict_data.dict_code IS '字典主键seq_sys_dict_data.nextval';
COMMENT ON COLUMN crmdm.ibp_sys_dict_data.dict_sort IS '字典排序';
COMMENT ON COLUMN crmdm.ibp_sys_dict_data.dict_label IS '字典标签';
COMMENT ON COLUMN crmdm.ibp_sys_dict_data.dict_value IS '字典键值';
COMMENT ON COLUMN crmdm.ibp_sys_dict_data.dict_type IS '字典类型';
COMMENT ON COLUMN crmdm.ibp_sys_dict_data.css_class IS '样式属性（其他样式扩展）';
COMMENT ON COLUMN crmdm.ibp_sys_dict_data.list_class IS '表格回显样式';
COMMENT ON COLUMN crmdm.ibp_sys_dict_data.is_default IS '是否默认（Y是 N否）';
COMMENT ON COLUMN crmdm.ibp_sys_dict_data.status IS '状态（0正常 1停用）';
COMMENT ON COLUMN crmdm.ibp_sys_dict_data.create_by IS '创建者';
COMMENT ON COLUMN crmdm.ibp_sys_dict_data.create_time IS '创建时间';
COMMENT ON COLUMN crmdm.ibp_sys_dict_data.update_by IS '更新者';
COMMENT ON COLUMN crmdm.ibp_sys_dict_data.update_time IS '更新时间';
COMMENT ON COLUMN crmdm.ibp_sys_dict_data.remark IS '备注';
COMMENT ON COLUMN crmdm.ibp_sys_dict_data.ryzd IS '冗余字段';
