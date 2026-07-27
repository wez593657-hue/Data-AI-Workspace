-- crmdm.mbk_mkp_jl_cust 定义

-- Drop table

-- DROP TABLE crmdm.mbk_mkp_jl_cust;

CREATE TABLE crmdm.mbk_mkp_jl_cust (
	ecif_no varchar(16) NOT NULL, -- 核心客户号
	user_id varchar(64) NOT NULL, -- 权益用户号
	tran_date varchar(10) NULL, -- 获取日期
	tran_time varchar(10) NULL, -- 获取时间
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_mbk_mkp_jl_cust PRIMARY KEY (ecif_no)
);

-- Column comments

COMMENT ON COLUMN crmdm.mbk_mkp_jl_cust.ecif_no IS '核心客户号';
COMMENT ON COLUMN crmdm.mbk_mkp_jl_cust.user_id IS '权益用户号';
COMMENT ON COLUMN crmdm.mbk_mkp_jl_cust.tran_date IS '获取日期';
COMMENT ON COLUMN crmdm.mbk_mkp_jl_cust.tran_time IS '获取时间';
COMMENT ON COLUMN crmdm.mbk_mkp_jl_cust.ryzd IS '冗余字段';
