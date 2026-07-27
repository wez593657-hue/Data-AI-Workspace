-- crmdm.cds_tb_interest_prj_detail 定义

-- Drop table

-- DROP TABLE crmdm.cds_tb_interest_prj_detail;

CREATE TABLE crmdm.cds_tb_interest_prj_detail (
	interest_no varchar(32) NOT NULL, -- 方案信息代码
	time_step varchar(3) NULL, -- D1：1天通知存款 D2：7天通知存款 M1：1个月定期存款 M3：3个月定期存款 M6：6个月定期存款 Y1：1年定期存款 Y2：2年定期存款 Y3：3年定期存款 Y5：5年定期存款
	begin_amt numeric(16, 2) NULL, -- 起点金额
	end_amt numeric(16, 2) NULL, -- 截止金额
	host_rate numeric(12, 5) NULL, -- 核心对应档位利率
	trans_channel varchar(8) NULL, -- 交易渠道0-智能存款柜台,1-后台产生,2-银行柜台,3-银行网银, 6-磁盘导入,7-自助终端,8-手机银行,9-微信银行
	begin_cust_level varchar(8) NULL, -- 起始客户级别
	end_cust_level varchar(8) NULL, -- 结束客户级别
	crt_date bpchar(8) NULL, -- 创建日期
	crt_time bpchar(6) NULL, -- 创建时间
	upd_date bpchar(8) NULL, -- 更新日期
	upd_time bpchar(6) NULL, -- 更新时间
	rate numeric(12, 8) NULL, -- RATE
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.cds_tb_interest_prj_detail.interest_no IS '方案信息代码';
COMMENT ON COLUMN crmdm.cds_tb_interest_prj_detail.time_step IS 'D1：1天通知存款 D2：7天通知存款 M1：1个月定期存款 M3：3个月定期存款 M6：6个月定期存款 Y1：1年定期存款 Y2：2年定期存款 Y3：3年定期存款 Y5：5年定期存款';
COMMENT ON COLUMN crmdm.cds_tb_interest_prj_detail.begin_amt IS '起点金额';
COMMENT ON COLUMN crmdm.cds_tb_interest_prj_detail.end_amt IS '截止金额';
COMMENT ON COLUMN crmdm.cds_tb_interest_prj_detail.host_rate IS '核心对应档位利率';
COMMENT ON COLUMN crmdm.cds_tb_interest_prj_detail.trans_channel IS '交易渠道0-智能存款柜台,1-后台产生,2-银行柜台,3-银行网银, 6-磁盘导入,7-自助终端,8-手机银行,9-微信银行';
COMMENT ON COLUMN crmdm.cds_tb_interest_prj_detail.begin_cust_level IS '起始客户级别';
COMMENT ON COLUMN crmdm.cds_tb_interest_prj_detail.end_cust_level IS '结束客户级别';
COMMENT ON COLUMN crmdm.cds_tb_interest_prj_detail.crt_date IS '创建日期';
COMMENT ON COLUMN crmdm.cds_tb_interest_prj_detail.crt_time IS '创建时间';
COMMENT ON COLUMN crmdm.cds_tb_interest_prj_detail.upd_date IS '更新日期';
COMMENT ON COLUMN crmdm.cds_tb_interest_prj_detail.upd_time IS '更新时间';
COMMENT ON COLUMN crmdm.cds_tb_interest_prj_detail.rate IS 'RATE';
COMMENT ON COLUMN crmdm.cds_tb_interest_prj_detail.ryzd IS '冗余字段';
