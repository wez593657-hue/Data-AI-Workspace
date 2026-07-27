-- crmdm.ecif_t01_c_party_resolve 定义

-- Drop table

-- DROP TABLE crmdm.ecif_t01_c_party_resolve;

CREATE TABLE crmdm.ecif_t01_c_party_resolve (
	party_resolve_id bpchar(20) NULL, -- PARTY_RESOLVE_ID
	party_id bpchar(20) NULL, -- PARTY_ID
	cert_type varchar(30) NULL, -- CERT_TYPE
	cert_no varchar(30) NULL, -- CERT_NO
	cert_issue_org varchar(60) NULL, -- CERT_ISSUE_ORG
	cert_issue_date sys."date" NULL, -- CERT_ISSUE_DATE
	cert_expd_date sys."date" NULL, -- CERT_EXPD_DATE
	main_cert_flag bpchar(1) NULL, -- MAIN_CERT_FLAG
	cust_flag varchar(30) NULL, -- CUST_FLAG
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

-- Column comments

COMMENT ON COLUMN crmdm.ecif_t01_c_party_resolve.party_resolve_id IS 'PARTY_RESOLVE_ID';
COMMENT ON COLUMN crmdm.ecif_t01_c_party_resolve.party_id IS 'PARTY_ID';
COMMENT ON COLUMN crmdm.ecif_t01_c_party_resolve.cert_type IS 'CERT_TYPE';
COMMENT ON COLUMN crmdm.ecif_t01_c_party_resolve.cert_no IS 'CERT_NO';
COMMENT ON COLUMN crmdm.ecif_t01_c_party_resolve.cert_issue_org IS 'CERT_ISSUE_ORG';
COMMENT ON COLUMN crmdm.ecif_t01_c_party_resolve.cert_issue_date IS 'CERT_ISSUE_DATE';
COMMENT ON COLUMN crmdm.ecif_t01_c_party_resolve.cert_expd_date IS 'CERT_EXPD_DATE';
COMMENT ON COLUMN crmdm.ecif_t01_c_party_resolve.main_cert_flag IS 'MAIN_CERT_FLAG';
COMMENT ON COLUMN crmdm.ecif_t01_c_party_resolve.cust_flag IS 'CUST_FLAG';
COMMENT ON COLUMN crmdm.ecif_t01_c_party_resolve.last_updated_te IS 'LAST_UPDATED_TE';
COMMENT ON COLUMN crmdm.ecif_t01_c_party_resolve.last_updated_org IS 'LAST_UPDATED_ORG';
COMMENT ON COLUMN crmdm.ecif_t01_c_party_resolve.created_ts IS 'CREATED_TS';
COMMENT ON COLUMN crmdm.ecif_t01_c_party_resolve.updated_ts IS 'UPDATED_TS';
COMMENT ON COLUMN crmdm.ecif_t01_c_party_resolve.init_system_id IS 'INIT_SYSTEM_ID';
COMMENT ON COLUMN crmdm.ecif_t01_c_party_resolve.init_created_ts IS 'INIT_CREATED_TS';
COMMENT ON COLUMN crmdm.ecif_t01_c_party_resolve.last_system_id IS 'LAST_SYSTEM_ID';
COMMENT ON COLUMN crmdm.ecif_t01_c_party_resolve.last_updated_ts IS 'LAST_UPDATED_TS';
COMMENT ON COLUMN crmdm.ecif_t01_c_party_resolve.ryzd IS '冗余字段';
