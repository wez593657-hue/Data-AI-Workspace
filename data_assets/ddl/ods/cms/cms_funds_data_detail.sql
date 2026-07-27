-- crmdm.cms_funds_data_detail 定义

-- Drop table

-- DROP TABLE crmdm.cms_funds_data_detail;

CREATE TABLE crmdm.cms_funds_data_detail (
	serialno varchar(32) NOT NULL, -- 流水号
	relativeserialno varchar(32) NOT NULL, -- 关联流水号
	zhaiyao varchar(50) NULL, -- 最近12期汇缴明细(账户流水信息表中备注)
	jkfse numeric(24, 6) NULL -- 最近12期缴存明细
);
COMMENT ON TABLE crmdm.cms_funds_data_detail IS '公积金汇缴详情信息表';

-- Column comments

COMMENT ON COLUMN crmdm.cms_funds_data_detail.serialno IS '流水号';
COMMENT ON COLUMN crmdm.cms_funds_data_detail.relativeserialno IS '关联流水号';
COMMENT ON COLUMN crmdm.cms_funds_data_detail.zhaiyao IS '最近12期汇缴明细(账户流水信息表中备注)';
COMMENT ON COLUMN crmdm.cms_funds_data_detail.jkfse IS '最近12期缴存明细';
