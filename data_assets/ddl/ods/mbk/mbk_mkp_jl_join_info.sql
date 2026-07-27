-- crmdm.mbk_mkp_jl_join_info 定义

-- Drop table

-- DROP TABLE crmdm.mbk_mkp_jl_join_info;

CREATE TABLE crmdm.mbk_mkp_jl_join_info (
	tran_no varchar(32) NOT NULL, -- 记录流水号
	order_id varchar(64) NOT NULL, -- 订单号
	user_id varchar(64) NULL, -- 用户id
	tran_date varchar(10) NULL, -- 日期
	tran_time varchar(10) NULL, -- 时间
	acti_no varchar(64) NULL, -- 活动编号
	chnl varchar(6) NULL, -- 渠道
	crm_lvl varchar(20) NULL, -- CRM等级
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_mbk_mkp_jl_join_info PRIMARY KEY (order_id)
);

-- Column comments

COMMENT ON COLUMN crmdm.mbk_mkp_jl_join_info.tran_no IS '记录流水号';
COMMENT ON COLUMN crmdm.mbk_mkp_jl_join_info.order_id IS '订单号';
COMMENT ON COLUMN crmdm.mbk_mkp_jl_join_info.user_id IS '用户id';
COMMENT ON COLUMN crmdm.mbk_mkp_jl_join_info.tran_date IS '日期';
COMMENT ON COLUMN crmdm.mbk_mkp_jl_join_info.tran_time IS '时间';
COMMENT ON COLUMN crmdm.mbk_mkp_jl_join_info.acti_no IS '活动编号';
COMMENT ON COLUMN crmdm.mbk_mkp_jl_join_info.chnl IS '渠道';
COMMENT ON COLUMN crmdm.mbk_mkp_jl_join_info.crm_lvl IS 'CRM等级';
COMMENT ON COLUMN crmdm.mbk_mkp_jl_join_info.ryzd IS '冗余字段';
