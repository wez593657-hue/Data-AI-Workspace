-- crmdm.ecif_t02_a_cust_addr_rel 定义

-- Drop table

-- DROP TABLE crmdm.ecif_t02_a_cust_addr_rel;

CREATE TABLE crmdm.ecif_t02_a_cust_addr_rel (
	addr_seq_id bpchar(20) NOT NULL, -- 地址关系记录编号
	party_id bpchar(20) NOT NULL, -- 参与人ID
	addr_type varchar(30) NOT NULL, -- 地址类型 C023
	addr_id bpchar(20) NULL, -- 联系地址ID
	addr_tab_id bpchar(8) NULL, -- 地址表ID
	role_id bpchar(20) NULL, -- 地址角色ID
	role_tab_id bpchar(8) NULL, -- 地址角色表ID
	last_updated_te varchar(20) NULL, -- 更新柜员
	last_updated_org varchar(20) NULL, -- 更新机构号
	created_ts timestamp(6) NULL, -- 进入ECIF的时间
	updated_ts timestamp(6) NULL, -- 在ECIF中更新的时间
	init_system_id varchar(30) NOT NULL, -- 创建渠道 C019
	init_created_ts timestamp(6) NULL, -- 源系统创建时间
	last_system_id varchar(30) NOT NULL, -- 最新更新渠道 C019
	last_updated_ts timestamp(6) NULL, -- 最新更新时间
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.ecif_t02_a_cust_addr_rel.addr_seq_id IS '地址关系记录编号';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_addr_rel.party_id IS '参与人ID';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_addr_rel.addr_type IS '地址类型 C023';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_addr_rel.addr_id IS '联系地址ID';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_addr_rel.addr_tab_id IS '地址表ID';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_addr_rel.role_id IS '地址角色ID';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_addr_rel.role_tab_id IS '地址角色表ID';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_addr_rel.last_updated_te IS '更新柜员';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_addr_rel.last_updated_org IS '更新机构号';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_addr_rel.created_ts IS '进入ECIF的时间';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_addr_rel.updated_ts IS '在ECIF中更新的时间';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_addr_rel.init_system_id IS '创建渠道 C019';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_addr_rel.init_created_ts IS '源系统创建时间';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_addr_rel.last_system_id IS '最新更新渠道 C019';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_addr_rel.last_updated_ts IS '最新更新时间';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_addr_rel.ryzd IS '冗余字段';
