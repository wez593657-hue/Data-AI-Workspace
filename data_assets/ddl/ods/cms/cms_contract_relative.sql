-- crmdm.cms_contract_relative 定义

-- Drop table

-- DROP TABLE crmdm.cms_contract_relative;

CREATE TABLE crmdm.cms_contract_relative (
	serialno varchar(40) NOT NULL, -- 合同流水号字段
	objecttype varchar(18) NOT NULL, -- 合同关联对象类型
	objectno varchar(40) NOT NULL, -- 合同关联对象编号
	relativesum numeric(24, 6) NULL, -- 关联金额
	relationstatus varchar(3) NULL, -- 关联状态
	addtype varchar(30) NULL -- 增加标志
);
CREATE INDEX idx1_cms_contract_relative ON crmdm.cms_contract_relative USING btree (objectno, objecttype);
COMMENT ON TABLE crmdm.cms_contract_relative IS '合同关联表';

-- Column comments

COMMENT ON COLUMN crmdm.cms_contract_relative.serialno IS '合同流水号字段';
COMMENT ON COLUMN crmdm.cms_contract_relative.objecttype IS '合同关联对象类型';
COMMENT ON COLUMN crmdm.cms_contract_relative.objectno IS '合同关联对象编号';
COMMENT ON COLUMN crmdm.cms_contract_relative.relativesum IS '关联金额';
COMMENT ON COLUMN crmdm.cms_contract_relative.relationstatus IS '关联状态';
COMMENT ON COLUMN crmdm.cms_contract_relative.addtype IS '增加标志';
