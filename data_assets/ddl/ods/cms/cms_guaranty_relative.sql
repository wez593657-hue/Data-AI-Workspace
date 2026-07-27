-- crmdm.cms_guaranty_relative 定义

-- Drop table

-- DROP TABLE crmdm.cms_guaranty_relative;

CREATE TABLE crmdm.cms_guaranty_relative (
	objecttype varchar(30) NOT NULL, -- 担保关联对象类型
	objectno varchar(40) NOT NULL, -- 担保关联对象编号
	contractno varchar(40) NOT NULL, -- 担保合同流水号字段
	guarantyid varchar(40) NOT NULL, -- 抵质押物编号
	channel varchar(18) NULL, -- 关联关系来源渠道
	status varchar(18) NULL, -- 有效标志
	othersrightid varchar(32) NULL, -- 他项权证号
	guarantysum varchar(32) NULL, -- 担保债权金额
	payorder varchar(18) NULL, -- 受偿次序
	"type" varchar(18) NULL, -- 数据来源类型
	relationstatus varchar(3) NULL, -- 关联有效标志
	describea varchar(250) NULL -- 描述
);
CREATE INDEX idx1_cms_guaranty_relative ON crmdm.cms_guaranty_relative USING btree (objectno, objecttype);
CREATE INDEX idx2_cms_guaranty_relative ON crmdm.cms_guaranty_relative USING btree (contractno);
COMMENT ON TABLE crmdm.cms_guaranty_relative IS '业务合同、担保合同与担保物关联表';

-- Column comments

COMMENT ON COLUMN crmdm.cms_guaranty_relative.objecttype IS '担保关联对象类型';
COMMENT ON COLUMN crmdm.cms_guaranty_relative.objectno IS '担保关联对象编号';
COMMENT ON COLUMN crmdm.cms_guaranty_relative.contractno IS '担保合同流水号字段';
COMMENT ON COLUMN crmdm.cms_guaranty_relative.guarantyid IS '抵质押物编号';
COMMENT ON COLUMN crmdm.cms_guaranty_relative.channel IS '关联关系来源渠道';
COMMENT ON COLUMN crmdm.cms_guaranty_relative.status IS '有效标志';
COMMENT ON COLUMN crmdm.cms_guaranty_relative.othersrightid IS '他项权证号';
COMMENT ON COLUMN crmdm.cms_guaranty_relative.guarantysum IS '担保债权金额';
COMMENT ON COLUMN crmdm.cms_guaranty_relative.payorder IS '受偿次序';
COMMENT ON COLUMN crmdm.cms_guaranty_relative."type" IS '数据来源类型';
COMMENT ON COLUMN crmdm.cms_guaranty_relative.relationstatus IS '关联有效标志';
COMMENT ON COLUMN crmdm.cms_guaranty_relative.describea IS '描述';
