-- crmdm.cms_funds_data 定义

-- Drop table

-- DROP TABLE crmdm.cms_funds_data;

CREATE TABLE crmdm.cms_funds_data (
	serialno varchar(32) NOT NULL, -- 流水号
	xingming varchar(120) NULL, -- 客户姓名
	zjlx varchar(2) NULL, -- 证件类型
	zjhm varchar(18) NULL, -- 证件号码
	dwmc varchar(255) NULL, -- 单位名称
	dwzh varchar(100) NULL, -- 单位账号
	khrq varchar(30) NULL, -- 账户的开户日期
	grzhzt varchar(2) NULL, -- 个人帐户状态
	grjcjs numeric(18, 2) NULL, -- 个人缴存基数
	grjcbl numeric(4, 2) NULL, -- 个人缴存比例
	yje numeric(18, 2) NULL, -- 公积金月缴存
	jzny varchar(10) NULL, -- 缴至年月
	grzhye numeric(18, 2) NULL, -- 个人账户余额
	fwzj numeric(18, 2) NULL, -- 公积金贷款房屋总额
	htdkje numeric(18, 2) NULL, -- 公积金贷款金额
	dkqs int4 NULL, -- 贷款期数
	zxll numeric(8, 7) NULL, -- 利率
	yhke numeric(18, 2) NULL, -- 月还款额
	yqzt varchar(6) NULL, -- 当期逾期状态
	dkye numeric(18, 2) NULL, -- 公积金贷款余额
	inputdate varchar(10) NULL -- 录入日期
);
COMMENT ON TABLE crmdm.cms_funds_data IS '公积金数据表';

-- Column comments

COMMENT ON COLUMN crmdm.cms_funds_data.serialno IS '流水号';
COMMENT ON COLUMN crmdm.cms_funds_data.xingming IS '客户姓名';
COMMENT ON COLUMN crmdm.cms_funds_data.zjlx IS '证件类型';
COMMENT ON COLUMN crmdm.cms_funds_data.zjhm IS '证件号码';
COMMENT ON COLUMN crmdm.cms_funds_data.dwmc IS '单位名称';
COMMENT ON COLUMN crmdm.cms_funds_data.dwzh IS '单位账号';
COMMENT ON COLUMN crmdm.cms_funds_data.khrq IS '账户的开户日期';
COMMENT ON COLUMN crmdm.cms_funds_data.grzhzt IS '个人帐户状态';
COMMENT ON COLUMN crmdm.cms_funds_data.grjcjs IS '个人缴存基数';
COMMENT ON COLUMN crmdm.cms_funds_data.grjcbl IS '个人缴存比例';
COMMENT ON COLUMN crmdm.cms_funds_data.yje IS '公积金月缴存';
COMMENT ON COLUMN crmdm.cms_funds_data.jzny IS '缴至年月';
COMMENT ON COLUMN crmdm.cms_funds_data.grzhye IS '个人账户余额';
COMMENT ON COLUMN crmdm.cms_funds_data.fwzj IS '公积金贷款房屋总额';
COMMENT ON COLUMN crmdm.cms_funds_data.htdkje IS '公积金贷款金额';
COMMENT ON COLUMN crmdm.cms_funds_data.dkqs IS '贷款期数';
COMMENT ON COLUMN crmdm.cms_funds_data.zxll IS '利率';
COMMENT ON COLUMN crmdm.cms_funds_data.yhke IS '月还款额';
COMMENT ON COLUMN crmdm.cms_funds_data.yqzt IS '当期逾期状态';
COMMENT ON COLUMN crmdm.cms_funds_data.dkye IS '公积金贷款余额';
COMMENT ON COLUMN crmdm.cms_funds_data.inputdate IS '录入日期';
