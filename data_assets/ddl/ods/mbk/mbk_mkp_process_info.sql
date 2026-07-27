-- crmdm.mbk_mkp_process_info 定义

-- Drop table

-- DROP TABLE crmdm.mbk_mkp_process_info;

CREATE TABLE crmdm.mbk_mkp_process_info (
	trans_sn varchar(128) NOT NULL, -- 交易流水号
	sence_status varchar(1) NULL, -- 场景状态
	sence_code varchar(10) NULL, -- 场景码
	sence_value varchar(10) NULL, -- 场景值
	sence_time varchar(20) NULL, -- 场景时间
	cust_no varchar(32) NULL, -- 客户号
	cust_lvl varchar(6) NULL, -- 客户等级
	cust_org varchar(20) NULL, -- 客户归属机构
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_mbk_mkp_process_info PRIMARY KEY (trans_sn)
);

-- Column comments

COMMENT ON COLUMN crmdm.mbk_mkp_process_info.trans_sn IS '交易流水号';
COMMENT ON COLUMN crmdm.mbk_mkp_process_info.sence_status IS '场景状态';
COMMENT ON COLUMN crmdm.mbk_mkp_process_info.sence_code IS '场景码';
COMMENT ON COLUMN crmdm.mbk_mkp_process_info.sence_value IS '场景值';
COMMENT ON COLUMN crmdm.mbk_mkp_process_info.sence_time IS '场景时间';
COMMENT ON COLUMN crmdm.mbk_mkp_process_info.cust_no IS '客户号';
COMMENT ON COLUMN crmdm.mbk_mkp_process_info.cust_lvl IS '客户等级';
COMMENT ON COLUMN crmdm.mbk_mkp_process_info.cust_org IS '客户归属机构';
COMMENT ON COLUMN crmdm.mbk_mkp_process_info.ryzd IS '冗余字段';
