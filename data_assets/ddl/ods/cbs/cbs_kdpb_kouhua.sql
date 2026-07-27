-- crmdm.cbs_kdpb_kouhua 定义

-- Drop table

-- DROP TABLE crmdm.cbs_kdpb_kouhua;

CREATE TABLE crmdm.cbs_kdpb_kouhua (
	farendma varchar(4) NOT NULL, -- 法人代码
	kouhabho varchar(32) NOT NULL, -- 扣划编号
	kouhuafs varchar(1) NOT NULL, -- 扣划方式
	dongjbho varchar(32) NULL, -- 冻结编号
	kehuzhao varchar(35) NOT NULL, -- 客户账号
	zhanghao varchar(40) NULL, -- 负债账号
	kouhuaje numeric(17, 2) NOT NULL, -- 扣划金额
	dxzhxhao varchar(40) NULL, -- 待销账序号
	skrkhuzh varchar(35) NULL, -- 收款人客户账号
	skzhxuho varchar(8) NULL, -- 收款人子账户序号
	zfbmleix varchar(1) NULL, -- 执法部门
	khbmenmc varchar(100) NULL, -- 扣划部门名称
	khwshaoo varchar(200) NULL, -- 扣划文书号
	khryzle1 varchar(2) NULL, -- 扣划人员1证件种类
	khryzjh1 varchar(80) NULL, -- 扣划人员1证件号码
	khryzle3 varchar(2) NULL, -- 扣划人员1证件种类2
	khryzjh3 varchar(80) NULL, -- 扣划人员1证件号码2
	khryxmm1 varchar(500) NULL, -- 扣划人员1姓名
	khryzle2 varchar(2) NULL, -- 扣划人员2证件种类
	khryzjh2 varchar(80) NULL, -- 扣划人员2证件号码
	khryzle4 varchar(2) NULL, -- 扣划人员2证件种类2
	khryzjh4 varchar(80) NULL, -- 扣划人员2证件号码2
	khryxmm2 varchar(500) NULL, -- 扣划人员2姓名
	zhaiyoms varchar(80) NULL, -- 摘要描述
	jiaoyijg varchar(10) NOT NULL, -- 交易机构
	jinbguiy varchar(8) NOT NULL, -- 经办人
	fuheguiy varchar(8) NULL, -- 复核人
	shnpguiy varchar(8) NULL, -- 审批人
	wbjoyima varchar(20) NOT NULL, -- 外部交易码
	nbjoyima varchar(20) NOT NULL, -- 内部交易码
	jiaoyirq varchar(8) NULL, -- 交易日期
	jiaoyisj numeric(19) NULL, -- 交易时间
	guiylius varchar(32) NULL, -- 柜员流水号
	weihguiy varchar(8) NOT NULL, -- 维护柜员
	weihjigo varchar(10) NOT NULL, -- 维护机构
	weihriqi varchar(8) NOT NULL, -- 维护日期
	weihshij varchar(9) NULL, -- 维护时间
	shijchuo numeric(19) NOT NULL, -- 时间戳
	jiluztai varchar(1) NOT NULL, -- 记录状态
	khrywmc1 varchar(500) NULL, -- 扣划人员1英文名
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.farendma IS '法人代码';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.kouhabho IS '扣划编号';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.kouhuafs IS '扣划方式';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.dongjbho IS '冻结编号';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.kehuzhao IS '客户账号';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.zhanghao IS '负债账号';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.kouhuaje IS '扣划金额';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.dxzhxhao IS '待销账序号';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.skrkhuzh IS '收款人客户账号';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.skzhxuho IS '收款人子账户序号';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.zfbmleix IS '执法部门';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.khbmenmc IS '扣划部门名称';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.khwshaoo IS '扣划文书号';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.khryzle1 IS '扣划人员1证件种类';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.khryzjh1 IS '扣划人员1证件号码';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.khryzle3 IS '扣划人员1证件种类2';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.khryzjh3 IS '扣划人员1证件号码2';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.khryxmm1 IS '扣划人员1姓名';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.khryzle2 IS '扣划人员2证件种类';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.khryzjh2 IS '扣划人员2证件号码';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.khryzle4 IS '扣划人员2证件种类2';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.khryzjh4 IS '扣划人员2证件号码2';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.khryxmm2 IS '扣划人员2姓名';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.zhaiyoms IS '摘要描述';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.jiaoyijg IS '交易机构';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.jinbguiy IS '经办人';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.fuheguiy IS '复核人';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.shnpguiy IS '审批人';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.wbjoyima IS '外部交易码';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.nbjoyima IS '内部交易码';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.jiaoyirq IS '交易日期';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.jiaoyisj IS '交易时间';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.guiylius IS '柜员流水号';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.weihguiy IS '维护柜员';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.weihjigo IS '维护机构';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.weihriqi IS '维护日期';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.weihshij IS '维护时间';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.shijchuo IS '时间戳';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.jiluztai IS '记录状态';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.khrywmc1 IS '扣划人员1英文名';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.ryzd IS '冗余字段';
