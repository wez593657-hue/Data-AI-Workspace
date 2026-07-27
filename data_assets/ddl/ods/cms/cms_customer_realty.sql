-- crmdm.cms_customer_realty 定义

-- Drop table

-- DROP TABLE crmdm.cms_customer_realty;

CREATE TABLE crmdm.cms_customer_realty (
	customerid varchar(40) NOT NULL, -- 客户编号
	serialno varchar(32) NOT NULL, -- 流水号
	certificateno varchar(50) NULL, -- 产权证号
	realtyname varchar(100) NULL, -- 房屋名称
	realtyattribute varchar(18) NULL, -- 房屋性质
	realtyarea numeric(24, 6) NULL, -- 房屋面积
	realtyadd varchar(120) NULL, -- 房屋地址
	buildprice numeric(24, 6) NULL, -- 建购价格
	evaluateprice numeric(24, 6) NULL, -- 评估价格
	shareprop numeric(10, 6) NULL, -- 所占份额
	purchasedate varchar(10) NULL, -- 买入日期
	saledate varchar(10) NULL, -- 卖出日期
	mortagage varchar(18) NULL, -- 房产抵押情况
	uptodate varchar(10) NULL, -- 统计截止日期
	inputorgid varchar(32) NULL, -- 登记机构编号
	inputuserid varchar(32) NULL, -- 登记人编号
	inputdate varchar(10) NULL, -- 登记日期
	updatedate varchar(10) NULL, -- 更新日期
	remark varchar(300) NULL, -- 备注
	realtycontractno varchar(20) NULL, -- 购房合同号
	realtyformat varchar(32) NULL, -- 房屋形式
	realtyrank varchar(32) NULL, -- 购家庭第几套房
	realtyunitprice numeric(24, 6) NULL, -- 单价
	completedate varchar(10) NULL, -- 建成时间
	downpayment numeric(24, 6) NULL, -- 首付金额
	downpaymentrate numeric(10, 6) NULL, -- 首付比例
	downpaymentsource varchar(32) NULL, -- 首付款来源
	realtyprovider varchar(60) NULL, -- 开发商名称
	buildstructure varchar(80) NULL -- 建构架构
);
COMMENT ON TABLE crmdm.cms_customer_realty IS '客户房产资产信息';

-- Column comments

COMMENT ON COLUMN crmdm.cms_customer_realty.customerid IS '客户编号';
COMMENT ON COLUMN crmdm.cms_customer_realty.serialno IS '流水号';
COMMENT ON COLUMN crmdm.cms_customer_realty.certificateno IS '产权证号';
COMMENT ON COLUMN crmdm.cms_customer_realty.realtyname IS '房屋名称';
COMMENT ON COLUMN crmdm.cms_customer_realty.realtyattribute IS '房屋性质';
COMMENT ON COLUMN crmdm.cms_customer_realty.realtyarea IS '房屋面积';
COMMENT ON COLUMN crmdm.cms_customer_realty.realtyadd IS '房屋地址';
COMMENT ON COLUMN crmdm.cms_customer_realty.buildprice IS '建购价格';
COMMENT ON COLUMN crmdm.cms_customer_realty.evaluateprice IS '评估价格';
COMMENT ON COLUMN crmdm.cms_customer_realty.shareprop IS '所占份额';
COMMENT ON COLUMN crmdm.cms_customer_realty.purchasedate IS '买入日期';
COMMENT ON COLUMN crmdm.cms_customer_realty.saledate IS '卖出日期';
COMMENT ON COLUMN crmdm.cms_customer_realty.mortagage IS '房产抵押情况';
COMMENT ON COLUMN crmdm.cms_customer_realty.uptodate IS '统计截止日期';
COMMENT ON COLUMN crmdm.cms_customer_realty.inputorgid IS '登记机构编号';
COMMENT ON COLUMN crmdm.cms_customer_realty.inputuserid IS '登记人编号';
COMMENT ON COLUMN crmdm.cms_customer_realty.inputdate IS '登记日期';
COMMENT ON COLUMN crmdm.cms_customer_realty.updatedate IS '更新日期';
COMMENT ON COLUMN crmdm.cms_customer_realty.remark IS '备注';
COMMENT ON COLUMN crmdm.cms_customer_realty.realtycontractno IS '购房合同号';
COMMENT ON COLUMN crmdm.cms_customer_realty.realtyformat IS '房屋形式';
COMMENT ON COLUMN crmdm.cms_customer_realty.realtyrank IS '购家庭第几套房';
COMMENT ON COLUMN crmdm.cms_customer_realty.realtyunitprice IS '单价';
COMMENT ON COLUMN crmdm.cms_customer_realty.completedate IS '建成时间';
COMMENT ON COLUMN crmdm.cms_customer_realty.downpayment IS '首付金额';
COMMENT ON COLUMN crmdm.cms_customer_realty.downpaymentrate IS '首付比例';
COMMENT ON COLUMN crmdm.cms_customer_realty.downpaymentsource IS '首付款来源';
COMMENT ON COLUMN crmdm.cms_customer_realty.realtyprovider IS '开发商名称';
COMMENT ON COLUMN crmdm.cms_customer_realty.buildstructure IS '建构架构';
