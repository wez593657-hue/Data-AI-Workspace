-- crmdm.ecif_t01_p_cust_info 定义

-- Drop table

-- DROP TABLE crmdm.ecif_t01_p_cust_info;

CREATE TABLE crmdm.ecif_t01_p_cust_info (
	party_id bpchar(20) NULL, -- PARTY_ID
	ecif_cust_no varchar(20) NULL, -- ECIF_CUST_NO
	party_name varchar(100) NULL, -- PARTY_NAME
	cert_type varchar(30) NULL, -- CERT_TYPE
	cert_no varchar(30) NULL, -- CERT_NO
	cert_org_area varchar(30) NULL, -- CERT_ORG_AREA
	cert_org_name varchar(100) NULL, -- CERT_ORG_NAME
	cert_issue_date sys."date" NULL, -- CERT_ISSUE_DATE
	cert_due_date sys."date" NULL, -- CERT_DUE_DATE
	cust_enname varchar(100) NULL, -- CUST_ENNAME
	cust_spname varchar(100) NULL, -- CUST_SPNAME
	cust_call varchar(100) NULL, -- CUST_CALL
	gender varchar(30) NULL, -- GENDER
	people varchar(30) NULL, -- PEOPLE
	birth_date sys."date" NULL, -- BIRTH_DATE
	birth_place varchar(60) NULL, -- BIRTH_PLACE
	health_state varchar(30) NULL, -- HEALTH_STATE
	marital_stat varchar(30) NULL, -- MARITAL_STAT
	nat_code varchar(30) NULL, -- NAT_CODE
	native varchar(60) NULL, -- NATIVE
	rgster varchar(100) NULL, -- RGSTER
	"language" varchar(30) NULL, -- LANGUAGE
	hobb_intrst varchar(200) NULL, -- HOBB_INTRST
	relig_code varchar(30) NULL, -- RELIG_CODE
	polit_stat varchar(30) NULL, -- POLIT_STAT
	edu_state varchar(30) NULL, -- EDU_STATE
	highest_degree varchar(30) NULL, -- HIGHEST_DEGREE
	grad_year varchar(30) NULL, -- GRAD_YEAR
	rsdt_type varchar(30) NULL, -- RSDT_TYPE
	pmt_rsdt_flag bpchar(1) NULL, -- PMT_RSDT_FLAG
	country_code varchar(30) NULL, -- COUNTRY_CODE
	area_code varchar(30) NULL, -- AREA_CODE
	reside_start_time sys."date" NULL, -- RESIDE_START_TIME
	livg_condit varchar(30) NULL, -- LIVG_CONDIT
	resdt_type varchar(30) NULL, -- RESDT_TYPE
	idvu_scl_insurs_no varchar(30) NULL, -- IDVU_SCL_INSURS_NO
	idvu_tx_no varchar(30) NULL, -- IDVU_TX_NO
	month_income numeric(20, 2) NULL, -- MONTH_INCOME
	year_salary numeric(20, 2) NULL, -- YEAR_SALARY
	econ_resur varchar(30) NULL, -- ECON_RESUR
	psn_asset_type varchar(30) NULL, -- PSN_ASSET_TYPE
	num_depend varchar(30) NULL, -- NUM_DEPEND
	fam_month numeric(20, 2) NULL, -- FAM_MONTH
	fam_year numeric(20, 2) NULL, -- FAM_YEAR
	fam_assets numeric(20, 2) NULL, -- FAM_ASSETS
	fam_memb_total varchar(30) NULL, -- FAM_MEMB_TOTAL
	unit_name varchar(120) NULL, -- UNIT_NAME
	unit_type varchar(30) NULL, -- UNIT_TYPE
	industry_type varchar(30) NULL, -- INDUSTRY_TYPE
	profession varchar(30) NULL, -- PROFESSION
	job_level varchar(30) NULL, -- JOB_LEVEL
	unit_position varchar(30) NULL, -- UNIT_POSITION
	tech_title varchar(30) NULL, -- TECH_TITLE
	work_stat bpchar(1) NULL, -- WORK_STAT
	qualft_stat varchar(30) NULL, -- QUALFT_STAT
	work_start_date sys."date" NULL, -- WORK_START_DATE
	unit_start_year varchar(10) NULL, -- UNIT_START_YEAR
	bank_rel_code varchar(30) NULL, -- BANK_REL_CODE
	shareholder_flag bpchar(1) NULL, -- SHAREHOLDER_FLAG
	cust_fore_exch_attr bpchar(1) NULL, -- CUST_FORE_EXCH_ATTR
	credit_level varchar(30) NULL, -- CREDIT_LEVEL
	grade_date sys."date" NULL, -- GRADE_DATE
	grade_due_date sys."date" NULL, -- GRADE_DUE_DATE
	bank_svr_grade varchar(30) NULL, -- BANK_SVR_GRADE
	cust_eval_level varchar(30) NULL, -- CUST_EVAL_LEVEL
	best_call_time varchar(30) NULL, -- BEST_CALL_TIME
	cust_level varchar(30) NULL, -- CUST_LEVEL
	cust_manager_no varchar(20) NULL, -- CUST_MANAGER_NO
	cust_mng_name varchar(100) NULL, -- CUST_MNG_NAME
	ide_check_result varchar(30) NULL, -- IDE_CHECK_RESULT
	ide_false_reason varchar(30) NULL, -- IDE_FALSE_REASON
	own_org varchar(20) NULL, -- OWN_ORG
	open_org varchar(20) NULL, -- OPEN_ORG
	open_teller varchar(20) NULL, -- OPEN_TELLER
	open_date sys."date" NULL, -- OPEN_DATE
	real_full_flag bpchar(1) NULL, -- REAL_FULL_FLAG
	cust_status bpchar(1) NULL, -- CUST_STATUS
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
CREATE INDEX index_crmdm_ecif_t01_p_cust_info_index_1 ON crmdm.ecif_t01_p_cust_info USING btree (party_id);
CREATE INDEX index_crmdm_ecif_t01_p_cust_info_index_2 ON crmdm.ecif_t01_p_cust_info USING btree (ecif_cust_no);
CREATE INDEX index_crmdm_ecif_t01_p_cust_info_index_3 ON crmdm.ecif_t01_p_cust_info USING btree (last_updated_ts);

-- Column comments

COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.party_id IS 'PARTY_ID';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.ecif_cust_no IS 'ECIF_CUST_NO';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.party_name IS 'PARTY_NAME';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.cert_type IS 'CERT_TYPE';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.cert_no IS 'CERT_NO';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.cert_org_area IS 'CERT_ORG_AREA';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.cert_org_name IS 'CERT_ORG_NAME';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.cert_issue_date IS 'CERT_ISSUE_DATE';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.cert_due_date IS 'CERT_DUE_DATE';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.cust_enname IS 'CUST_ENNAME';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.cust_spname IS 'CUST_SPNAME';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.cust_call IS 'CUST_CALL';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.gender IS 'GENDER';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.people IS 'PEOPLE';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.birth_date IS 'BIRTH_DATE';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.birth_place IS 'BIRTH_PLACE';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.health_state IS 'HEALTH_STATE';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.marital_stat IS 'MARITAL_STAT';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.nat_code IS 'NAT_CODE';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.native IS 'NATIVE';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.rgster IS 'RGSTER';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info."language" IS 'LANGUAGE';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.hobb_intrst IS 'HOBB_INTRST';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.relig_code IS 'RELIG_CODE';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.polit_stat IS 'POLIT_STAT';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.edu_state IS 'EDU_STATE';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.highest_degree IS 'HIGHEST_DEGREE';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.grad_year IS 'GRAD_YEAR';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.rsdt_type IS 'RSDT_TYPE';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.pmt_rsdt_flag IS 'PMT_RSDT_FLAG';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.country_code IS 'COUNTRY_CODE';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.area_code IS 'AREA_CODE';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.reside_start_time IS 'RESIDE_START_TIME';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.livg_condit IS 'LIVG_CONDIT';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.resdt_type IS 'RESDT_TYPE';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.idvu_scl_insurs_no IS 'IDVU_SCL_INSURS_NO';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.idvu_tx_no IS 'IDVU_TX_NO';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.month_income IS 'MONTH_INCOME';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.year_salary IS 'YEAR_SALARY';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.econ_resur IS 'ECON_RESUR';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.psn_asset_type IS 'PSN_ASSET_TYPE';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.num_depend IS 'NUM_DEPEND';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.fam_month IS 'FAM_MONTH';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.fam_year IS 'FAM_YEAR';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.fam_assets IS 'FAM_ASSETS';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.fam_memb_total IS 'FAM_MEMB_TOTAL';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.unit_name IS 'UNIT_NAME';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.unit_type IS 'UNIT_TYPE';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.industry_type IS 'INDUSTRY_TYPE';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.profession IS 'PROFESSION';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.job_level IS 'JOB_LEVEL';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.unit_position IS 'UNIT_POSITION';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.tech_title IS 'TECH_TITLE';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.work_stat IS 'WORK_STAT';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.qualft_stat IS 'QUALFT_STAT';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.work_start_date IS 'WORK_START_DATE';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.unit_start_year IS 'UNIT_START_YEAR';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.bank_rel_code IS 'BANK_REL_CODE';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.shareholder_flag IS 'SHAREHOLDER_FLAG';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.cust_fore_exch_attr IS 'CUST_FORE_EXCH_ATTR';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.credit_level IS 'CREDIT_LEVEL';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.grade_date IS 'GRADE_DATE';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.grade_due_date IS 'GRADE_DUE_DATE';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.bank_svr_grade IS 'BANK_SVR_GRADE';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.cust_eval_level IS 'CUST_EVAL_LEVEL';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.best_call_time IS 'BEST_CALL_TIME';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.cust_level IS 'CUST_LEVEL';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.cust_manager_no IS 'CUST_MANAGER_NO';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.cust_mng_name IS 'CUST_MNG_NAME';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.ide_check_result IS 'IDE_CHECK_RESULT';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.ide_false_reason IS 'IDE_FALSE_REASON';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.own_org IS 'OWN_ORG';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.open_org IS 'OPEN_ORG';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.open_teller IS 'OPEN_TELLER';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.open_date IS 'OPEN_DATE';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.real_full_flag IS 'REAL_FULL_FLAG';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.cust_status IS 'CUST_STATUS';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.last_updated_te IS 'LAST_UPDATED_TE';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.last_updated_org IS 'LAST_UPDATED_ORG';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.created_ts IS 'CREATED_TS';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.updated_ts IS 'UPDATED_TS';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.init_system_id IS 'INIT_SYSTEM_ID';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.init_created_ts IS 'INIT_CREATED_TS';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.last_system_id IS 'LAST_SYSTEM_ID';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.last_updated_ts IS 'LAST_UPDATED_TS';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.ryzd IS '冗余字段';
