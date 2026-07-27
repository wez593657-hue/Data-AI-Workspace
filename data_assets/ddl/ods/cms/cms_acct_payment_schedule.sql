-- crmdm.cms_acct_payment_schedule 定义

-- Drop table

-- DROP TABLE crmdm.cms_acct_payment_schedule;

CREATE TABLE crmdm.cms_acct_payment_schedule (
	serialno varchar(40) NOT NULL, -- 流水号
	parentserialno varchar(40) NULL, -- 父还款计划流水号
	objecttype varchar(40) NULL, -- 还款日志关联对象类型
	objectno varchar(40) NULL, -- 还款日志关联对象编号
	relativeobjecttype varchar(40) NULL, -- 还款主体对象类型
	relativeobjectno varchar(40) NULL, -- 还款主体对象编号
	periodno int4 NULL, -- 期次
	paydate varchar(10) NULL, -- 应还日期
	pstype varchar(10) NULL, -- 偿付类型
	payitemcode varchar(10) NULL, -- 还款项目
	intedate varchar(10) NULL, -- 节假日及宽限期顺延后的还款日期
	holidayintedate varchar(10) NULL, -- 节假日顺延后的还款日
	graceintedate varchar(10) NULL, -- 宽限期顺延后的还款日期（开始计算罚息的日期）
	settledate varchar(10) NULL, -- 结算日
	autopayflag varchar(10) NULL, -- 自动扣款标识
	currency varchar(10) NULL, -- 币种
	fixpayprincipalamt numeric(24, 2) NULL, -- 手工指定当期还款额
	fixpayinstalmentamt numeric(24, 2) NULL, -- 手工指定当期本金还款额
	payprincipalamt numeric(24, 2) DEFAULT 0.00 NULL, -- 应还本金
	actualpayprincipalamt numeric(24, 2) DEFAULT 0.00 NULL, -- 实还本金
	waiveprincipalamt numeric(24, 2) DEFAULT 0.00 NULL, -- 减免本金金额
	principalbalance numeric(24, 2) DEFAULT 0.00 NULL, -- 剩余本金余额
	payinterestamt numeric(24, 2) DEFAULT 0.00 NULL, -- 应还利息
	actualpayinterestamt numeric(24, 2) DEFAULT 0.00 NULL, -- 实还利息
	waiveinterestamt numeric(24, 2) DEFAULT 0.00 NULL, -- 减免利息金额
	payprincipalpenaltyamt numeric(24, 2) DEFAULT 0.00 NULL, -- 应还本金罚息
	actualpayprincipalpenaltyamt numeric(24, 2) DEFAULT 0.00 NULL, -- 实还本金罚息
	waiveprincipalpenaltyamt numeric(24, 2) DEFAULT 0.00 NULL, -- 减免本金罚息
	payinterestpenaltyamt numeric(24, 2) DEFAULT 0.00 NULL, -- 应还利息罚息
	actualpayinterestpenaltyamt numeric(24, 2) DEFAULT 0.00 NULL, -- 实还利息罚息
	waiveinterestpenaltyamt numeric(24, 2) DEFAULT 0.00 NULL, -- 减免利息罚息
	status varchar(10) NULL, -- 状态
	finishdate varchar(10) NULL, -- 结清日期
	remark varchar(400) NULL, -- 备注
	direction varchar(10) NULL, -- 收付方向
	payfeeamt numeric(24, 2) DEFAULT 0.00 NULL, -- 应还费用
	actualpayfeeamt numeric(24, 2) DEFAULT 0.00 NULL, -- 实还费用
	waivefeeamt numeric(24, 2) DEFAULT 0.00 NULL, -- 减免费用
	fixpayinterestflag varchar(10) NULL, -- 当期是否还息
	fixpayprincipaldate varchar(10) NULL, -- 当期指定还本日期
	paygraceinteamt numeric(24, 2) DEFAULT 0.00 NULL, -- 应还宽限期利息
	actualpaygraceinteamt numeric(24, 2) DEFAULT 0.00 NULL, -- 实还宽限期利息
	waivegraceinteamt numeric(24, 2) DEFAULT 0.00 NULL, -- 减免宽限期利息
	oldpstype varchar(2) NULL -- 老系统计划类型
);
CREATE INDEX idx_payment_schedule_1 ON crmdm.cms_acct_payment_schedule USING btree (objectno, objecttype);
CREATE INDEX idx_payment_schedule_2 ON crmdm.cms_acct_payment_schedule USING btree (relativeobjectno, relativeobjecttype);
CREATE INDEX idx_payment_schedule_3 ON crmdm.cms_acct_payment_schedule USING btree (paydate, pstype);
COMMENT ON TABLE crmdm.cms_acct_payment_schedule IS '贷款-还款日志';

-- Column comments

COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.serialno IS '流水号';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.parentserialno IS '父还款计划流水号';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.objecttype IS '还款日志关联对象类型';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.objectno IS '还款日志关联对象编号';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.relativeobjecttype IS '还款主体对象类型';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.relativeobjectno IS '还款主体对象编号';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.periodno IS '期次';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.paydate IS '应还日期';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.pstype IS '偿付类型';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.payitemcode IS '还款项目';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.intedate IS '节假日及宽限期顺延后的还款日期';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.holidayintedate IS '节假日顺延后的还款日';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.graceintedate IS '宽限期顺延后的还款日期（开始计算罚息的日期）';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.settledate IS '结算日';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.autopayflag IS '自动扣款标识';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.currency IS '币种';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.fixpayprincipalamt IS '手工指定当期还款额';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.fixpayinstalmentamt IS '手工指定当期本金还款额';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.payprincipalamt IS '应还本金';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.actualpayprincipalamt IS '实还本金';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.waiveprincipalamt IS '减免本金金额';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.principalbalance IS '剩余本金余额';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.payinterestamt IS '应还利息';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.actualpayinterestamt IS '实还利息';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.waiveinterestamt IS '减免利息金额';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.payprincipalpenaltyamt IS '应还本金罚息';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.actualpayprincipalpenaltyamt IS '实还本金罚息';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.waiveprincipalpenaltyamt IS '减免本金罚息';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.payinterestpenaltyamt IS '应还利息罚息';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.actualpayinterestpenaltyamt IS '实还利息罚息';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.waiveinterestpenaltyamt IS '减免利息罚息';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.status IS '状态';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.finishdate IS '结清日期';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.remark IS '备注';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.direction IS '收付方向';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.payfeeamt IS '应还费用';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.actualpayfeeamt IS '实还费用';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.waivefeeamt IS '减免费用';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.fixpayinterestflag IS '当期是否还息';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.fixpayprincipaldate IS '当期指定还本日期';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.paygraceinteamt IS '应还宽限期利息';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.actualpaygraceinteamt IS '实还宽限期利息';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.waivegraceinteamt IS '减免宽限期利息';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.oldpstype IS '老系统计划类型';
