-- crmdm.cms_acct_rate_segment 定义

-- Drop table

-- DROP TABLE crmdm.cms_acct_rate_segment;

CREATE TABLE crmdm.cms_acct_rate_segment (
	serialno varchar(40) NOT NULL, -- 流水号
	objectno varchar(40) NULL, -- 对象类型
	objecttype varchar(40) NULL, -- 对象编号
	segno numeric NULL, -- 区段序号
	segfromdate varchar(10) NULL, -- 区段生效日期
	segtodate varchar(10) NULL, -- 区段结束日期
	segfromstage numeric NULL, -- 区段生效期次
	segtostage numeric NULL, -- 区段结束期次
	segstages numeric NULL, -- 区段持续期次
	termid varchar(20) NULL, -- 组件编号
	ratetype varchar(20) NULL, -- 利率类型
	rateunit varchar(10) NULL, -- 利率单位
	baserategrade varchar(10) NULL, -- 基准利率档次
	baseratetype varchar(10) NULL, -- 基准利率类型
	baserate numeric(12, 8) NULL, -- 基准利率
	ratefloattype varchar(10) NULL, -- 利率浮动类型
	ratefloat numeric(10, 6) NULL, -- 浮动幅度
	businessrate numeric(12, 8) NULL, -- 执行利率
	repricetype varchar(4) NULL, -- 利率调整方式
	repricetermunit varchar(10) NULL, -- 利率调整周期单位
	repriceterm numeric NULL, -- 利率调整周期
	defaultrepricedate varchar(10) NULL, -- 指定利率调整日期
	lastrepricedate varchar(10) NULL, -- 上次利率调整日期
	nextrepricedate varchar(10) NULL, -- 下次利率调整日期
	remark varchar(400) NULL, -- 备注
	status varchar(10) NULL, -- 状态
	segname varchar(120) NULL, -- 区段名称
	segtermid varchar(20) NULL, -- 组件编号
	yearbaseday numeric NULL, -- 年基准天数
	transserialno varchar(40) NULL, -- 交易流水号
	splitmethod varchar(10) NULL, -- 拆分方式
	accrueinteflag varchar(10) NULL, -- 是否计收利息(Code:YsesNo)
	accruecompflag varchar(10) NULL, -- 是否收取复利(Code:YsesNo)
	accruefineflag varchar(10) NULL, -- 是否收取罚利(Code:YsesNo)
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_cms_acct_rate_segment PRIMARY KEY (serialno)
);

-- Column comments

COMMENT ON COLUMN crmdm.cms_acct_rate_segment.serialno IS '流水号';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.objectno IS '对象类型';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.objecttype IS '对象编号';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.segno IS '区段序号';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.segfromdate IS '区段生效日期';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.segtodate IS '区段结束日期';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.segfromstage IS '区段生效期次';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.segtostage IS '区段结束期次';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.segstages IS '区段持续期次';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.termid IS '组件编号';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.ratetype IS '利率类型';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.rateunit IS '利率单位';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.baserategrade IS '基准利率档次';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.baseratetype IS '基准利率类型';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.baserate IS '基准利率';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.ratefloattype IS '利率浮动类型';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.ratefloat IS '浮动幅度';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.businessrate IS '执行利率';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.repricetype IS '利率调整方式';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.repricetermunit IS '利率调整周期单位';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.repriceterm IS '利率调整周期';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.defaultrepricedate IS '指定利率调整日期';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.lastrepricedate IS '上次利率调整日期';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.nextrepricedate IS '下次利率调整日期';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.remark IS '备注';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.status IS '状态';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.segname IS '区段名称';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.segtermid IS '组件编号';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.yearbaseday IS '年基准天数';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.transserialno IS '交易流水号';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.splitmethod IS '拆分方式';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.accrueinteflag IS '是否计收利息(Code:YsesNo)';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.accruecompflag IS '是否收取复利(Code:YsesNo)';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.accruefineflag IS '是否收取罚利(Code:YsesNo)';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.ryzd IS '冗余字段';
