-- crmdm.cms_acct_business_account 定义

-- Drop table

-- DROP TABLE crmdm.cms_acct_business_account;

CREATE TABLE crmdm.cms_acct_business_account (
	serialno varchar(40) NOT NULL, -- 流水号
	objecttype varchar(40) NULL, -- 对象类型
	objectno varchar(40) NULL, -- 对象编号
	accountindicator varchar(10) NULL, -- 账户性质（系统内使用）
	priorityflag varchar(10) NULL, -- 优先级（Code:PRI）
	accountflag varchar(10) NULL, -- 存款账户标示（多存款系统使用）
	accounttype varchar(10) NULL, -- 存款账户类型(Code:AccountType)
	accountno varchar(40) NULL, -- 存款账户账号
	accountcurrency varchar(10) NULL, -- 存款账户币种
	accountname varchar(80) NULL, -- 存款账户名称
	accountorgid varchar(32) NULL, -- 存款账号核心机构号
	status varchar(10) NULL, -- 状态（0:无效,1:有效）
	mfcustomerid varchar(32) NULL, -- MFCUSTOMERID
	suoshudx varchar(12) NULL, -- 所属对象
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_cms_acct_business_account PRIMARY KEY (serialno)
);

-- Column comments

COMMENT ON COLUMN crmdm.cms_acct_business_account.serialno IS '流水号';
COMMENT ON COLUMN crmdm.cms_acct_business_account.objecttype IS '对象类型';
COMMENT ON COLUMN crmdm.cms_acct_business_account.objectno IS '对象编号';
COMMENT ON COLUMN crmdm.cms_acct_business_account.accountindicator IS '账户性质（系统内使用）';
COMMENT ON COLUMN crmdm.cms_acct_business_account.priorityflag IS '优先级（Code:PRI）';
COMMENT ON COLUMN crmdm.cms_acct_business_account.accountflag IS '存款账户标示（多存款系统使用）';
COMMENT ON COLUMN crmdm.cms_acct_business_account.accounttype IS '存款账户类型(Code:AccountType)';
COMMENT ON COLUMN crmdm.cms_acct_business_account.accountno IS '存款账户账号';
COMMENT ON COLUMN crmdm.cms_acct_business_account.accountcurrency IS '存款账户币种';
COMMENT ON COLUMN crmdm.cms_acct_business_account.accountname IS '存款账户名称';
COMMENT ON COLUMN crmdm.cms_acct_business_account.accountorgid IS '存款账号核心机构号';
COMMENT ON COLUMN crmdm.cms_acct_business_account.status IS '状态（0:无效,1:有效）';
COMMENT ON COLUMN crmdm.cms_acct_business_account.mfcustomerid IS 'MFCUSTOMERID';
COMMENT ON COLUMN crmdm.cms_acct_business_account.suoshudx IS '所属对象';
COMMENT ON COLUMN crmdm.cms_acct_business_account.ryzd IS '冗余字段';
