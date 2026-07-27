-- crmdm.mbk_cust_acct 定义

-- Drop table

-- DROP TABLE crmdm.mbk_cust_acct;

CREATE TABLE crmdm.mbk_cust_acct (
	cust_no varchar(32) NOT NULL, -- 电子银行客户号
	acct varchar(32) NOT NULL, -- 卡号
	acct_lvl varchar(2) NOT NULL, -- 账户等级 1：一类户（电子账户），借记卡默认为一类户 2：二类户（电子账户） 3：三类户（电子账户）
	acct_open_org varchar(16) NULL, -- 账户开户机构
	acct_type bpchar(1) NOT NULL, -- 账户类型(卡折标识) 1：借记卡 2：电子账户 3：信用卡 4：账户（可能有些行支持存折加挂）
	acct_alias varchar(64) NULL, -- 账户别名
	is_deft_acct bpchar(1) NOT NULL, -- 是否默认账户 N：非默认账户 Y：默认账号
	acct_sort numeric NOT NULL, -- 账户显示排序
	sub_acct varchar(32) NULL, -- 活期主账号（有些系统可能会需要存储卡号对应的活期账户）
	acct_open_way bpchar(1) NOT NULL, -- 开通方式：1借记卡验密绑定（借记卡）  2-柜面 3-线上人脸识别（电子账户）、4-线上VTM（电子账户）
	acct_add_chnl varchar(3) NOT NULL, -- 下挂渠道:MB手机银行TB柜面
	acct_add_date varchar(10) NOT NULL, -- 下挂日期
	acct_add_time varchar(8) NOT NULL, -- 下挂时间
	is_town bpchar(1) NULL, -- 村镇银行标识 0:非村镇银行1:村镇银行
	is_sign bpchar(1) NOT NULL, -- 是否签约短信通1-签约 0-没签约
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_mbk_cust_acct PRIMARY KEY (cust_no, acct)
);

-- Column comments

COMMENT ON COLUMN crmdm.mbk_cust_acct.cust_no IS '电子银行客户号';
COMMENT ON COLUMN crmdm.mbk_cust_acct.acct IS '卡号';
COMMENT ON COLUMN crmdm.mbk_cust_acct.acct_lvl IS '账户等级 1：一类户（电子账户），借记卡默认为一类户 2：二类户（电子账户） 3：三类户（电子账户）';
COMMENT ON COLUMN crmdm.mbk_cust_acct.acct_open_org IS '账户开户机构';
COMMENT ON COLUMN crmdm.mbk_cust_acct.acct_type IS '账户类型(卡折标识) 1：借记卡 2：电子账户 3：信用卡 4：账户（可能有些行支持存折加挂）';
COMMENT ON COLUMN crmdm.mbk_cust_acct.acct_alias IS '账户别名';
COMMENT ON COLUMN crmdm.mbk_cust_acct.is_deft_acct IS '是否默认账户 N：非默认账户 Y：默认账号';
COMMENT ON COLUMN crmdm.mbk_cust_acct.acct_sort IS '账户显示排序';
COMMENT ON COLUMN crmdm.mbk_cust_acct.sub_acct IS '活期主账号（有些系统可能会需要存储卡号对应的活期账户）';
COMMENT ON COLUMN crmdm.mbk_cust_acct.acct_open_way IS '开通方式：1借记卡验密绑定（借记卡）  2-柜面 3-线上人脸识别（电子账户）、4-线上VTM（电子账户）';
COMMENT ON COLUMN crmdm.mbk_cust_acct.acct_add_chnl IS '下挂渠道:MB手机银行TB柜面';
COMMENT ON COLUMN crmdm.mbk_cust_acct.acct_add_date IS '下挂日期';
COMMENT ON COLUMN crmdm.mbk_cust_acct.acct_add_time IS '下挂时间';
COMMENT ON COLUMN crmdm.mbk_cust_acct.is_town IS '村镇银行标识 0:非村镇银行1:村镇银行';
COMMENT ON COLUMN crmdm.mbk_cust_acct.is_sign IS '是否签约短信通1-签约 0-没签约';
COMMENT ON COLUMN crmdm.mbk_cust_acct.ryzd IS '冗余字段';
