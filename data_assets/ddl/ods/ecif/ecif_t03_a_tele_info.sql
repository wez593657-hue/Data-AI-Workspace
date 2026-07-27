-- crmdm.ecif_t03_a_tele_info 定义

-- Drop table

-- DROP TABLE crmdm.ecif_t03_a_tele_info;

CREATE TABLE crmdm.ecif_t03_a_tele_info (
	tele_id bpchar(20) NULL, -- TELE_ID
	country_no varchar(6) NULL, -- COUNTRY_NO
	area_no varchar(6) NULL, -- AREA_NO
	phone_no varchar(36) NULL, -- PHONE_NO
	ext_no varchar(6) NULL, -- EXT_NO
	addr_desc varchar(200) NULL, -- ADDR_DESC
	last_updated_te varchar(20) NULL, -- LAST_UPDATED_TE
	last_updated_org varchar(20) NULL, -- LAST_UPDATED_ORG
	created_ts timestamp(6) NULL, -- CREATED_TS
	updated_ts timestamp(6) NULL, -- UPDATED_TS
	init_system_id varchar(30) NULL, -- INIT_SYSTEM_ID
	init_created_ts timestamp(6) NULL, -- INIT_CREATED_TS
	last_system_id varchar(30) NULL, -- LAST_SYSTEM_ID
	last_updated_ts timestamp(6) NULL, -- LAST_UPDATED_TS
	ryzd varchar(1) NULL -- 冗余字段
);
CREATE INDEX index_crmdm_ecif_t03_a_tele_info_index_1 ON crmdm.ecif_t03_a_tele_info USING btree (tele_id);

-- Column comments

COMMENT ON COLUMN crmdm.ecif_t03_a_tele_info.tele_id IS 'TELE_ID';
COMMENT ON COLUMN crmdm.ecif_t03_a_tele_info.country_no IS 'COUNTRY_NO';
COMMENT ON COLUMN crmdm.ecif_t03_a_tele_info.area_no IS 'AREA_NO';
COMMENT ON COLUMN crmdm.ecif_t03_a_tele_info.phone_no IS 'PHONE_NO';
COMMENT ON COLUMN crmdm.ecif_t03_a_tele_info.ext_no IS 'EXT_NO';
COMMENT ON COLUMN crmdm.ecif_t03_a_tele_info.addr_desc IS 'ADDR_DESC';
COMMENT ON COLUMN crmdm.ecif_t03_a_tele_info.last_updated_te IS 'LAST_UPDATED_TE';
COMMENT ON COLUMN crmdm.ecif_t03_a_tele_info.last_updated_org IS 'LAST_UPDATED_ORG';
COMMENT ON COLUMN crmdm.ecif_t03_a_tele_info.created_ts IS 'CREATED_TS';
COMMENT ON COLUMN crmdm.ecif_t03_a_tele_info.updated_ts IS 'UPDATED_TS';
COMMENT ON COLUMN crmdm.ecif_t03_a_tele_info.init_system_id IS 'INIT_SYSTEM_ID';
COMMENT ON COLUMN crmdm.ecif_t03_a_tele_info.init_created_ts IS 'INIT_CREATED_TS';
COMMENT ON COLUMN crmdm.ecif_t03_a_tele_info.last_system_id IS 'LAST_SYSTEM_ID';
COMMENT ON COLUMN crmdm.ecif_t03_a_tele_info.last_updated_ts IS 'LAST_UPDATED_TS';
COMMENT ON COLUMN crmdm.ecif_t03_a_tele_info.ryzd IS '冗余字段';
