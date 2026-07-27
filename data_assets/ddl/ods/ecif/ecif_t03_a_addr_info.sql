-- crmdm.ecif_t03_a_addr_info 定义

-- Drop table

-- DROP TABLE crmdm.ecif_t03_a_addr_info;

CREATE TABLE crmdm.ecif_t03_a_addr_info (
	addr_id bpchar(20) NULL, -- 联系地址ID
	post_cd varchar(6) NULL, -- 邮政编码
	nation varchar(30) NULL, -- 国家 C003
	province varchar(30) NULL, -- 省、直辖市、自治区 C005
	city varchar(30) NULL, -- 城市 C006
	county varchar(30) NULL, -- 县、区 C007
	street varchar(80) NULL, -- 街道
	addr_line varchar(160) NULL, -- 详细地址
	addr_desc varchar(200) NULL, -- 地址描述
	last_updated_te varchar(20) NULL, -- 更新柜员
	last_updated_org varchar(20) NULL, -- 更新机构号
	created_ts timestamp(6) NULL, -- 进入ECIF的时间
	updated_ts timestamp(6) NULL, -- 在ECIF中更新的时间
	init_system_id varchar(30) NULL, -- 创建渠道 C019
	init_created_ts timestamp(6) NULL, -- 源系统创建时间
	last_system_id varchar(30) NULL, -- 最新更新渠道 C019
	last_updated_ts timestamp(6) NULL, -- 最新更新时间
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.ecif_t03_a_addr_info.addr_id IS '联系地址ID';
COMMENT ON COLUMN crmdm.ecif_t03_a_addr_info.post_cd IS '邮政编码';
COMMENT ON COLUMN crmdm.ecif_t03_a_addr_info.nation IS '国家 C003';
COMMENT ON COLUMN crmdm.ecif_t03_a_addr_info.province IS '省、直辖市、自治区 C005';
COMMENT ON COLUMN crmdm.ecif_t03_a_addr_info.city IS '城市 C006';
COMMENT ON COLUMN crmdm.ecif_t03_a_addr_info.county IS '县、区 C007';
COMMENT ON COLUMN crmdm.ecif_t03_a_addr_info.street IS '街道';
COMMENT ON COLUMN crmdm.ecif_t03_a_addr_info.addr_line IS '详细地址';
COMMENT ON COLUMN crmdm.ecif_t03_a_addr_info.addr_desc IS '地址描述';
COMMENT ON COLUMN crmdm.ecif_t03_a_addr_info.last_updated_te IS '更新柜员';
COMMENT ON COLUMN crmdm.ecif_t03_a_addr_info.last_updated_org IS '更新机构号';
COMMENT ON COLUMN crmdm.ecif_t03_a_addr_info.created_ts IS '进入ECIF的时间';
COMMENT ON COLUMN crmdm.ecif_t03_a_addr_info.updated_ts IS '在ECIF中更新的时间';
COMMENT ON COLUMN crmdm.ecif_t03_a_addr_info.init_system_id IS '创建渠道 C019';
COMMENT ON COLUMN crmdm.ecif_t03_a_addr_info.init_created_ts IS '源系统创建时间';
COMMENT ON COLUMN crmdm.ecif_t03_a_addr_info.last_system_id IS '最新更新渠道 C019';
COMMENT ON COLUMN crmdm.ecif_t03_a_addr_info.last_updated_ts IS '最新更新时间';
COMMENT ON COLUMN crmdm.ecif_t03_a_addr_info.ryzd IS '冗余字段';
