-- crmdm.ecif_t01_c_cust_info 定义

-- Drop table

-- DROP TABLE crmdm.ecif_t01_c_cust_info;

CREATE TABLE crmdm.ecif_t01_c_cust_info (
	party_id bpchar(20) NULL, -- PARTY_ID
	ecif_cust_no varchar(20) NULL, -- ECIF_CUST_NO
	cust_type varchar(30) NULL, -- CUST_TYPE
	party_name varchar(200) NULL, -- PARTY_NAME
	cust_shtname varchar(100) NULL, -- CUST_SHTNAME
	cust_enname varchar(200) NULL, -- CUST_ENNAME
	cust_spname varchar(200) NULL, -- CUST_SPNAME
	govn_cert_no varchar(30) NULL, -- GOVN_CERT_NO
	govn_efft_date sys."date" NULL, -- GOVN_EFFT_DATE
	govn_expd_date sys."date" NULL, -- GOVN_EXPD_DATE
	govn_review_year varchar(10) NULL, -- GOVN_REVIEW_YEAR
	org_code varchar(20) NULL, -- ORG_CODE
	org_code_issu varchar(60) NULL, -- ORG_CODE_ISSU
	org_code_iss_date sys."date" NULL, -- ORG_CODE_ISS_DATE
	org_code_due_date sys."date" NULL, -- ORG_CODE_DUE_DATE
	reg_org varchar(60) NULL, -- REG_ORG
	reg_country varchar(30) NULL, -- REG_COUNTRY
	reg_province varchar(30) NULL, -- REG_PROVINCE
	reg_area_code varchar(30) NULL, -- REG_AREA_CODE
	reg_date sys."date" NULL, -- REG_DATE
	reg_cptl numeric(20, 2) NULL, -- REG_CPTL
	reg_cptl_curr varchar(30) NULL, -- REG_CPTL_CURR
	paid_cptl numeric(20, 2) NULL, -- PAID_CPTL
	paid_cptl_curr varchar(30) NULL, -- PAID_CPTL_CURR
	org_type varchar(30) NULL, -- ORG_TYPE
	corp_attr varchar(30) NULL, -- CORP_ATTR
	comp_attr varchar(30) NULL, -- COMP_ATTR
	pay_no varchar(30) NULL, -- PAY_NO
	spe_inst_code varchar(20) NULL, -- SPE_INST_CODE
	tax_reg_no varchar(30) NULL, -- TAX_REG_NO
	reg_expd_date sys."date" NULL, -- REG_EXPD_DATE
	tax_area_no varchar(30) NULL, -- TAX_AREA_NO
	area_expd_date sys."date" NULL, -- AREA_EXPD_DATE
	tax_org varchar(60) NULL, -- TAX_ORG
	loan_card_flag bpchar(1) NULL, -- LOAN_CARD_FLAG
	loan_card_no varchar(20) NULL, -- LOAN_CARD_NO
	loan_card_due_date sys."date" NULL, -- LOAN_CARD_DUE_DATE
	loan_card_chk_date sys."date" NULL, -- LOAN_CARD_CHK_DATE
	unit_credit_code varchar(30) NULL, -- UNIT_CREDIT_CODE
	mang_dept varchar(30) NULL, -- MANG_DEPT
	corp_subj varchar(30) NULL, -- CORP_SUBJ
	industry_type varchar(30) NULL, -- INDUSTRY_TYPE
	econ_kind varchar(30) NULL, -- ECON_KIND
	basic_acc_lic_no varchar(30) NULL, -- BASIC_ACC_LIC_NO
	basic_acc_permit_no varchar(30) NULL, -- BASIC_ACC_PERMIT_NO
	basic_acc_bank_no varchar(30) NULL, -- BASIC_ACC_BANK_NO
	basic_acc_open_bank varchar(80) NULL, -- BASIC_ACC_OPEN_BANK
	basic_acc_no varchar(30) NULL, -- BASIC_ACC_NO
	busi_lic_no varchar(30) NULL, -- BUSI_LIC_NO
	admn_type varchar(1600) NULL, -- ADMN_TYPE
	side_type varchar(200) NULL, -- SIDE_TYPE
	country_mng varchar(30) NULL, -- COUNTRY_MNG
	province_mng varchar(30) NULL, -- PROVINCE_MNG
	mng_situation varchar(30) NULL, -- MNG_SITUATION
	mng_operate_area numeric(10) NULL, -- MNG_OPERATE_AREA
	mng_operate_ownership varchar(30) NULL, -- MNG_OPERATE_OWNERSHIP
	comp_size varchar(30) NULL, -- COMP_SIZE
	emp_num numeric(10) NULL, -- EMP_NUM
	total_assets numeric(20, 2) NULL, -- TOTAL_ASSETS
	net_assets numeric(20, 2) NULL, -- NET_ASSETS
	sell_sum numeric(20, 2) NULL, -- SELL_SUM
	annual_income numeric(20, 2) NULL, -- ANNUAL_INCOME
	free_tax_flag bpchar(1) NULL, -- FREE_TAX_FLAG
	free_tax_limit varchar(10) NULL, -- FREE_TAX_LIMIT
	private_flag bpchar(1) NULL, -- PRIVATE_FLAG
	listed_flag bpchar(1) NULL, -- LISTED_FLAG
	listed_on varchar(30) NULL, -- LISTED_ON
	stock_code varchar(30) NULL, -- STOCK_CODE
	holding_type varchar(30) NULL, -- HOLDING_TYPE
	actual_controller varchar(200) NULL, -- ACTUAL_CONTROLLER
	new_tech_corpornot bpchar(1) NULL, -- NEW_TECH_CORPORNOT
	spe_industry_flag bpchar(1) NULL, -- SPE_INDUSTRY_FLAG
	spe_industry_lic varchar(30) NULL, -- SPE_INDUSTRY_LIC
	imex_mana_ind bpchar(1) NULL, -- IMEX_MANA_IND
	fin_cust_type varchar(30) NULL, -- FIN_CUST_TYPE
	fin_org_type varchar(30) NULL, -- FIN_ORG_TYPE
	swift_no varchar(20) NULL, -- SWIFT_NO
	fin_lic_no varchar(30) NULL, -- FIN_LIC_NO
	fin_org_cd varchar(30) NULL, -- FIN_ORG_CD
	fin_manage_area varchar(200) NULL, -- FIN_MANAGE_AREA
	busi_area_code varchar(30) NULL, -- BUSI_AREA_CODE
	cust_fore_exch_attr bpchar(1) NULL, -- CUST_FORE_EXCH_ATTR
	nra_flag bpchar(1) NULL, -- NRA_FLAG
	fore_cust_type varchar(30) NULL, -- FORE_CUST_TYPE
	fore_exch_lic_no varchar(30) NULL, -- FORE_EXCH_LIC_NO
	busi_site_code varchar(30) NULL, -- BUSI_SITE_CODE
	res_country varchar(30) NULL, -- RES_COUNTRY
	fore_basic_acc_bank varchar(60) NULL, -- FORE_BASIC_ACC_BANK
	fore_basic_acc varchar(30) NULL, -- FORE_BASIC_ACC
	fore_inv_country varchar(30) NULL, -- FORE_INV_COUNTRY
	spe_econ_inst_flag bpchar(1) NULL, -- SPE_ECON_INST_FLAG
	spe_econ_inst_type varchar(30) NULL, -- SPE_ECON_INST_TYPE
	pay_lis_flag bpchar(1) NULL, -- PAY_LIS_FLAG
	fore_safe_no varchar(30) NULL, -- FORE_SAFE_NO
	fore_industry_type varchar(30) NULL, -- FORE_INDUSTRY_TYPE
	fore_econ_type varchar(30) NULL, -- FORE_ECON_TYPE
	fore_first_name varchar(200) NULL, -- FORE_FIRST_NAME
	fore_second_name varchar(200) NULL, -- FORE_SECOND_NAME
	bank_rel_flag varchar(30) NULL, -- BANK_REL_FLAG
	shareholder_flag bpchar(1) NULL, -- SHAREHOLDER_FLAG
	bank_svr_grade varchar(30) NULL, -- BANK_SVR_GRADE
	cust_eval_level varchar(30) NULL, -- CUST_EVAL_LEVEL
	credit_level varchar(30) NULL, -- CREDIT_LEVEL
	evaluate_date sys."date" NULL, -- EVALUATE_DATE
	other_credit_level varchar(30) NULL, -- OTHER_CREDIT_LEVEL
	other_evaluate_date sys."date" NULL, -- OTHER_EVALUATE_DATE
	other_org_name varchar(100) NULL, -- OTHER_ORG_NAME
	evaluate_level varchar(30) NULL, -- EVALUATE_LEVEL
	cust_level varchar(30) NULL, -- CUST_LEVEL
	cust_manager_no varchar(20) NULL, -- CUST_MANAGER_NO
	cust_mng_name varchar(100) NULL, -- CUST_MNG_NAME
	own_org varchar(20) NULL, -- OWN_ORG
	open_org varchar(20) NULL, -- OPEN_ORG
	open_teller varchar(20) NULL, -- OPEN_TELLER
	open_date varchar(50) NULL, -- OPEN_DATE
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

-- Column comments

COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.party_id IS 'PARTY_ID';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.ecif_cust_no IS 'ECIF_CUST_NO';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.cust_type IS 'CUST_TYPE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.party_name IS 'PARTY_NAME';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.cust_shtname IS 'CUST_SHTNAME';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.cust_enname IS 'CUST_ENNAME';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.cust_spname IS 'CUST_SPNAME';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.govn_cert_no IS 'GOVN_CERT_NO';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.govn_efft_date IS 'GOVN_EFFT_DATE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.govn_expd_date IS 'GOVN_EXPD_DATE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.govn_review_year IS 'GOVN_REVIEW_YEAR';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.org_code IS 'ORG_CODE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.org_code_issu IS 'ORG_CODE_ISSU';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.org_code_iss_date IS 'ORG_CODE_ISS_DATE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.org_code_due_date IS 'ORG_CODE_DUE_DATE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.reg_org IS 'REG_ORG';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.reg_country IS 'REG_COUNTRY';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.reg_province IS 'REG_PROVINCE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.reg_area_code IS 'REG_AREA_CODE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.reg_date IS 'REG_DATE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.reg_cptl IS 'REG_CPTL';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.reg_cptl_curr IS 'REG_CPTL_CURR';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.paid_cptl IS 'PAID_CPTL';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.paid_cptl_curr IS 'PAID_CPTL_CURR';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.org_type IS 'ORG_TYPE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.corp_attr IS 'CORP_ATTR';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.comp_attr IS 'COMP_ATTR';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.pay_no IS 'PAY_NO';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.spe_inst_code IS 'SPE_INST_CODE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.tax_reg_no IS 'TAX_REG_NO';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.reg_expd_date IS 'REG_EXPD_DATE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.tax_area_no IS 'TAX_AREA_NO';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.area_expd_date IS 'AREA_EXPD_DATE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.tax_org IS 'TAX_ORG';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.loan_card_flag IS 'LOAN_CARD_FLAG';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.loan_card_no IS 'LOAN_CARD_NO';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.loan_card_due_date IS 'LOAN_CARD_DUE_DATE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.loan_card_chk_date IS 'LOAN_CARD_CHK_DATE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.unit_credit_code IS 'UNIT_CREDIT_CODE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.mang_dept IS 'MANG_DEPT';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.corp_subj IS 'CORP_SUBJ';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.industry_type IS 'INDUSTRY_TYPE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.econ_kind IS 'ECON_KIND';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.basic_acc_lic_no IS 'BASIC_ACC_LIC_NO';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.basic_acc_permit_no IS 'BASIC_ACC_PERMIT_NO';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.basic_acc_bank_no IS 'BASIC_ACC_BANK_NO';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.basic_acc_open_bank IS 'BASIC_ACC_OPEN_BANK';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.basic_acc_no IS 'BASIC_ACC_NO';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.busi_lic_no IS 'BUSI_LIC_NO';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.admn_type IS 'ADMN_TYPE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.side_type IS 'SIDE_TYPE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.country_mng IS 'COUNTRY_MNG';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.province_mng IS 'PROVINCE_MNG';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.mng_situation IS 'MNG_SITUATION';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.mng_operate_area IS 'MNG_OPERATE_AREA';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.mng_operate_ownership IS 'MNG_OPERATE_OWNERSHIP';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.comp_size IS 'COMP_SIZE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.emp_num IS 'EMP_NUM';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.total_assets IS 'TOTAL_ASSETS';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.net_assets IS 'NET_ASSETS';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.sell_sum IS 'SELL_SUM';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.annual_income IS 'ANNUAL_INCOME';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.free_tax_flag IS 'FREE_TAX_FLAG';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.free_tax_limit IS 'FREE_TAX_LIMIT';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.private_flag IS 'PRIVATE_FLAG';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.listed_flag IS 'LISTED_FLAG';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.listed_on IS 'LISTED_ON';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.stock_code IS 'STOCK_CODE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.holding_type IS 'HOLDING_TYPE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.actual_controller IS 'ACTUAL_CONTROLLER';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.new_tech_corpornot IS 'NEW_TECH_CORPORNOT';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.spe_industry_flag IS 'SPE_INDUSTRY_FLAG';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.spe_industry_lic IS 'SPE_INDUSTRY_LIC';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.imex_mana_ind IS 'IMEX_MANA_IND';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.fin_cust_type IS 'FIN_CUST_TYPE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.fin_org_type IS 'FIN_ORG_TYPE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.swift_no IS 'SWIFT_NO';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.fin_lic_no IS 'FIN_LIC_NO';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.fin_org_cd IS 'FIN_ORG_CD';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.fin_manage_area IS 'FIN_MANAGE_AREA';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.busi_area_code IS 'BUSI_AREA_CODE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.cust_fore_exch_attr IS 'CUST_FORE_EXCH_ATTR';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.nra_flag IS 'NRA_FLAG';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.fore_cust_type IS 'FORE_CUST_TYPE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.fore_exch_lic_no IS 'FORE_EXCH_LIC_NO';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.busi_site_code IS 'BUSI_SITE_CODE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.res_country IS 'RES_COUNTRY';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.fore_basic_acc_bank IS 'FORE_BASIC_ACC_BANK';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.fore_basic_acc IS 'FORE_BASIC_ACC';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.fore_inv_country IS 'FORE_INV_COUNTRY';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.spe_econ_inst_flag IS 'SPE_ECON_INST_FLAG';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.spe_econ_inst_type IS 'SPE_ECON_INST_TYPE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.pay_lis_flag IS 'PAY_LIS_FLAG';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.fore_safe_no IS 'FORE_SAFE_NO';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.fore_industry_type IS 'FORE_INDUSTRY_TYPE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.fore_econ_type IS 'FORE_ECON_TYPE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.fore_first_name IS 'FORE_FIRST_NAME';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.fore_second_name IS 'FORE_SECOND_NAME';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.bank_rel_flag IS 'BANK_REL_FLAG';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.shareholder_flag IS 'SHAREHOLDER_FLAG';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.bank_svr_grade IS 'BANK_SVR_GRADE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.cust_eval_level IS 'CUST_EVAL_LEVEL';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.credit_level IS 'CREDIT_LEVEL';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.evaluate_date IS 'EVALUATE_DATE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.other_credit_level IS 'OTHER_CREDIT_LEVEL';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.other_evaluate_date IS 'OTHER_EVALUATE_DATE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.other_org_name IS 'OTHER_ORG_NAME';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.evaluate_level IS 'EVALUATE_LEVEL';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.cust_level IS 'CUST_LEVEL';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.cust_manager_no IS 'CUST_MANAGER_NO';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.cust_mng_name IS 'CUST_MNG_NAME';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.own_org IS 'OWN_ORG';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.open_org IS 'OPEN_ORG';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.open_teller IS 'OPEN_TELLER';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.open_date IS 'OPEN_DATE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.cust_status IS 'CUST_STATUS';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.last_updated_te IS 'LAST_UPDATED_TE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.last_updated_org IS 'LAST_UPDATED_ORG';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.created_ts IS 'CREATED_TS';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.updated_ts IS 'UPDATED_TS';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.init_system_id IS 'INIT_SYSTEM_ID';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.init_created_ts IS 'INIT_CREATED_TS';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.last_system_id IS 'LAST_SYSTEM_ID';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.last_updated_ts IS 'LAST_UPDATED_TS';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.ryzd IS '冗余字段';
