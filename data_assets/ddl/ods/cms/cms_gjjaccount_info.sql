-- crmdm.cms_gjjaccount_info 定义

-- Drop table

-- DROP TABLE crmdm.cms_gjjaccount_info;

CREATE TABLE crmdm.cms_gjjaccount_info (
	relativeno varchar(40) NULL, -- 编号
	certtype varchar(8) NULL, -- CERTTYPE
	authpersonid varchar(18) NULL, -- AUTHPERSONID
	etpscode varchar(32) NULL, -- 单位客户号
	etpsname varchar(128) NULL, -- 单位客户名称
	depmonth varchar(12) NULL, -- 缴存至年月
	depamt varchar(18) NULL, -- 个人缴存基数
	etpsdepamt varchar(18) NULL, -- 单位月缴存额
	indvdepamt varchar(18) NULL, -- 个人月缴存额
	etpsdeprat varchar(6) NULL, -- 单位缴存比例
	indvdeprat varchar(6) NULL, -- 个人缴存比例
	opendate varchar(12) NULL, -- 开户日期
	lastyearbal varchar(18) NULL, -- 上年度余额
	thisyearbal varchar(18) NULL, -- 个人账户余额
	acctflag varchar(8) NULL, -- 缴存状态
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.cms_gjjaccount_info.relativeno IS '编号';
COMMENT ON COLUMN crmdm.cms_gjjaccount_info.certtype IS 'CERTTYPE';
COMMENT ON COLUMN crmdm.cms_gjjaccount_info.authpersonid IS 'AUTHPERSONID';
COMMENT ON COLUMN crmdm.cms_gjjaccount_info.etpscode IS '单位客户号';
COMMENT ON COLUMN crmdm.cms_gjjaccount_info.etpsname IS '单位客户名称';
COMMENT ON COLUMN crmdm.cms_gjjaccount_info.depmonth IS '缴存至年月';
COMMENT ON COLUMN crmdm.cms_gjjaccount_info.depamt IS '个人缴存基数';
COMMENT ON COLUMN crmdm.cms_gjjaccount_info.etpsdepamt IS '单位月缴存额';
COMMENT ON COLUMN crmdm.cms_gjjaccount_info.indvdepamt IS '个人月缴存额';
COMMENT ON COLUMN crmdm.cms_gjjaccount_info.etpsdeprat IS '单位缴存比例';
COMMENT ON COLUMN crmdm.cms_gjjaccount_info.indvdeprat IS '个人缴存比例';
COMMENT ON COLUMN crmdm.cms_gjjaccount_info.opendate IS '开户日期';
COMMENT ON COLUMN crmdm.cms_gjjaccount_info.lastyearbal IS '上年度余额';
COMMENT ON COLUMN crmdm.cms_gjjaccount_info.thisyearbal IS '个人账户余额';
COMMENT ON COLUMN crmdm.cms_gjjaccount_info.acctflag IS '缴存状态';
COMMENT ON COLUMN crmdm.cms_gjjaccount_info.ryzd IS '冗余字段';
