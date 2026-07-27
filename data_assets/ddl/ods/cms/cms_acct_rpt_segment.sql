-- crmdm.cms_acct_rpt_segment 定义

-- Drop table

-- DROP TABLE crmdm.cms_acct_rpt_segment;

CREATE TABLE crmdm.cms_acct_rpt_segment (
	serialno varchar(40) NOT NULL, -- 流水号
	objectno varchar(40) NULL, -- 对象编号
	objecttype varchar(40) NULL, -- 对象类型
	pstype varchar(10) NULL, -- 还款计划类型
	termid varchar(10) NULL, -- 组件编号
	segno numeric NULL, -- 区段序号
	segname varchar(120) NULL, -- 区段名称
	termruleid varchar(10) NULL, -- 组件编号
	segtermid varchar(10) NULL, -- 组件编号
	segfromdate varchar(10) NULL, -- 区段生效日期
	segtodate varchar(10) NULL, -- 区段结束日期
	segfromstage numeric NULL, -- 区段生效期次
	segtostage numeric NULL, -- 区段结束期次
	segstages numeric NULL, -- 区段持续期次
	status varchar(10) NULL, -- 状态
	segtermflag varchar(10) NULL, -- 区段期限标志
	segtermunit varchar(10) NULL, -- 指定区段期限单位，默认为月M
	segterm numeric NULL, -- 指定区段期限
	firstduedate varchar(10) NULL, -- 首次还款日
	defaultdueday varchar(2) NULL, -- 默认还款日
	lastduedate varchar(10) NULL, -- 上次还款日
	nextduedate varchar(10) NULL, -- 下次还款日
	totalperiod numeric NULL, -- 总期次
	currentperiod numeric NULL, -- 当前期次
	gaincyc numeric NULL, -- 递变周期
	gainamount numeric(24, 2) NULL, -- 递变幅度
	payfrequencytype varchar(10) NULL, -- 还款周期
	payfrequencyunit varchar(10) NULL, -- 指定还款周期单位
	payfrequency varchar(10) NULL, -- 指定还款周期
	segrptamountflag varchar(20) NULL, -- 指定区段金额标志
	segrptamount numeric(24, 2) NULL, -- 指定区段拟还本金金额
	segrptpercent numeric(5, 2) NULL, -- 指定区段拟还本金比例
	seginstalmentamt numeric(24, 2) NULL, -- 期供金额
	segrptbalance numeric(24, 2) NULL, -- 本区段剩余待归还本金
	firstinstalmentflag varchar(10) NULL, -- 首次还款金额标识
	finalinstalmentflag varchar(10) NULL, -- 末次还款金额标识
	gracedays numeric NULL, -- 宽限期天数
	autopayflag varchar(10) NULL, -- 自动扣款标识
	remark varchar(200) NULL, -- 备注
	psrestructureflag varchar(10) NULL, -- 更新期供标示(0 不生成还款计划也不重算期供，1 只算还款计划不计算期供，2 还款计划期供都算)
	postponerule varchar(200) NULL, -- 逾期延期规则
	transserialno varchar(40) NULL, -- 交易流水号
	gracedaysaccrualflag varchar(2) NULL, -- 宽限期计息标志
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_cms_acct_rpt_segment PRIMARY KEY (serialno)
);

-- Column comments

COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.serialno IS '流水号';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.objectno IS '对象编号';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.objecttype IS '对象类型';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.pstype IS '还款计划类型';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.termid IS '组件编号';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.segno IS '区段序号';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.segname IS '区段名称';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.termruleid IS '组件编号';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.segtermid IS '组件编号';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.segfromdate IS '区段生效日期';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.segtodate IS '区段结束日期';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.segfromstage IS '区段生效期次';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.segtostage IS '区段结束期次';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.segstages IS '区段持续期次';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.status IS '状态';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.segtermflag IS '区段期限标志';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.segtermunit IS '指定区段期限单位，默认为月M';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.segterm IS '指定区段期限';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.firstduedate IS '首次还款日';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.defaultdueday IS '默认还款日';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.lastduedate IS '上次还款日';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.nextduedate IS '下次还款日';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.totalperiod IS '总期次';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.currentperiod IS '当前期次';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.gaincyc IS '递变周期';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.gainamount IS '递变幅度';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.payfrequencytype IS '还款周期';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.payfrequencyunit IS '指定还款周期单位';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.payfrequency IS '指定还款周期';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.segrptamountflag IS '指定区段金额标志';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.segrptamount IS '指定区段拟还本金金额';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.segrptpercent IS '指定区段拟还本金比例';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.seginstalmentamt IS '期供金额';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.segrptbalance IS '本区段剩余待归还本金';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.firstinstalmentflag IS '首次还款金额标识';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.finalinstalmentflag IS '末次还款金额标识';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.gracedays IS '宽限期天数';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.autopayflag IS '自动扣款标识';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.remark IS '备注';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.psrestructureflag IS '更新期供标示(0 不生成还款计划也不重算期供，1 只算还款计划不计算期供，2 还款计划期供都算)';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.postponerule IS '逾期延期规则';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.transserialno IS '交易流水号';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.gracedaysaccrualflag IS '宽限期计息标志';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.ryzd IS '冗余字段';
