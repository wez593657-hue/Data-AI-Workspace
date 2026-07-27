-- crmdm.ecif_t02_p_par_to_par_rel 定义

-- Drop table

-- DROP TABLE crmdm.ecif_t02_p_par_to_par_rel;

CREATE TABLE crmdm.ecif_t02_p_par_to_par_rel (
	par_seq_id bpchar(20) NULL, -- 关联关系记录编号
	party_id bpchar(20) NULL, -- 参与人ID
	relation_type varchar(30) NULL, -- 关联关系类型 C022
	relation_id bpchar(20) NULL, -- 关系人ID
	relation_tab_id bpchar(8) NULL, -- 关系人信息表ID
	role_type varchar(30) NULL, -- 参与人角色类型
	role_id bpchar(20) NULL, -- 参与人角色ID
	role_tab_id bpchar(8) NULL, -- 参与人角色表ID
	rel_name varchar(200) NULL, -- 关系人名称
	rel_cert_type varchar(30) NULL, -- 关系人证件类型 C001
	rel_cert_no varchar(30) NULL, -- 关系人证件号码
	other_desc varchar(200) NULL, -- 其它说明
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
CREATE INDEX index_crmdm_ecif_t02_p_par_to_par_rel_index_1 ON crmdm.ecif_t02_p_par_to_par_rel USING btree (party_id);
CREATE INDEX index_crmdm_ecif_t02_p_par_to_par_rel_index_2 ON crmdm.ecif_t02_p_par_to_par_rel USING btree (relation_id);
CREATE INDEX index_crmdm_ecif_t02_p_par_to_par_rel_index_3 ON crmdm.ecif_t02_p_par_to_par_rel USING btree (relation_type);

-- Column comments

COMMENT ON COLUMN crmdm.ecif_t02_p_par_to_par_rel.par_seq_id IS '关联关系记录编号';
COMMENT ON COLUMN crmdm.ecif_t02_p_par_to_par_rel.party_id IS '参与人ID';
COMMENT ON COLUMN crmdm.ecif_t02_p_par_to_par_rel.relation_type IS '关联关系类型 C022';
COMMENT ON COLUMN crmdm.ecif_t02_p_par_to_par_rel.relation_id IS '关系人ID';
COMMENT ON COLUMN crmdm.ecif_t02_p_par_to_par_rel.relation_tab_id IS '关系人信息表ID';
COMMENT ON COLUMN crmdm.ecif_t02_p_par_to_par_rel.role_type IS '参与人角色类型';
COMMENT ON COLUMN crmdm.ecif_t02_p_par_to_par_rel.role_id IS '参与人角色ID';
COMMENT ON COLUMN crmdm.ecif_t02_p_par_to_par_rel.role_tab_id IS '参与人角色表ID';
COMMENT ON COLUMN crmdm.ecif_t02_p_par_to_par_rel.rel_name IS '关系人名称';
COMMENT ON COLUMN crmdm.ecif_t02_p_par_to_par_rel.rel_cert_type IS '关系人证件类型 C001';
COMMENT ON COLUMN crmdm.ecif_t02_p_par_to_par_rel.rel_cert_no IS '关系人证件号码';
COMMENT ON COLUMN crmdm.ecif_t02_p_par_to_par_rel.other_desc IS '其它说明';
COMMENT ON COLUMN crmdm.ecif_t02_p_par_to_par_rel.last_updated_te IS '更新柜员';
COMMENT ON COLUMN crmdm.ecif_t02_p_par_to_par_rel.last_updated_org IS '更新机构号';
COMMENT ON COLUMN crmdm.ecif_t02_p_par_to_par_rel.created_ts IS '进入ECIF的时间';
COMMENT ON COLUMN crmdm.ecif_t02_p_par_to_par_rel.updated_ts IS '在ECIF中更新的时间';
COMMENT ON COLUMN crmdm.ecif_t02_p_par_to_par_rel.init_system_id IS '创建渠道 C019';
COMMENT ON COLUMN crmdm.ecif_t02_p_par_to_par_rel.init_created_ts IS '源系统创建时间';
COMMENT ON COLUMN crmdm.ecif_t02_p_par_to_par_rel.last_system_id IS '最新更新渠道 C019';
COMMENT ON COLUMN crmdm.ecif_t02_p_par_to_par_rel.last_updated_ts IS '最新更新时间';
COMMENT ON COLUMN crmdm.ecif_t02_p_par_to_par_rel.ryzd IS '冗余字段';
