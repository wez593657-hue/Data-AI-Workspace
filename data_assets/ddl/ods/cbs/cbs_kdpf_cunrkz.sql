-- crmdm.cbs_kdpf_cunrkz 定义
-- 资产入库: 2026-08-26, 需求版本 REQ-RCMD-001 (V1.0.2)
-- 来源: reference_logic/ALL_TB.sql 行6357 (DWD_PRDKT_INFO_ZB 加工依赖源表)

-- DROP TABLE crmdm.cbs_kdpf_cunrkz;

CREATE TABLE crmdm.cbs_kdpf_cunrkz (
	farendma varchar(4) NOT NULL, -- 法人行号
	chapbhao varchar(100) NOT NULL, -- 产品编号
	huobdaih varchar(3) NOT NULL, -- 货币代号
	xianjncr varchar(1) NULL, -- 现金存入标志
	zhuanzcr varchar(1) NULL, -- 转账存入标志
	cunrkzhi varchar(1) NULL, -- 存入控制方式
	cunrkzff varchar(1) NULL, -- 存入控制方法
	crjekzfs varchar(1) NULL, -- 存入金额控制方式
	dccrzxje numeric(17, 2) NULL, -- 单次存入最小金额(ZB表PRDKT_LIMIT_AMT取此字段)
	dccrzdje numeric(17, 2) NULL, -- 单次存入最大金额
	cishkzfs varchar(1) NULL, -- 存入次数控制方式
	zuixcrcs numeric(19) NULL, -- 最小存入次数
	zuidcrcs numeric(19) NULL, -- 最大存入次数
	shezcrjh varchar(1) NULL, -- 设置存入计划标志
	crjhtzfs varchar(1) NULL, -- 存入计划调整方式
	crjhtzzq varchar(8) NULL, -- 存入计划调整周期
	crjhjsrq varchar(1) NULL, -- 存入计划结束日期方式
	crjhscfs varchar(1) NULL, -- 存入计划生成方式
	lcbzkxqi varchar(8) NULL, -- 漏存补足宽限期
	loucbqfs varchar(1) NULL, -- 存入漏补方式
	zdbzcshu numeric(19) NULL, -- 最大补足次数
	cunrwybz varchar(1) NULL, -- 存入违约标准
	lcuncshu numeric(19) NULL, -- 漏存次数
	crwyclfs varchar(1) NULL, -- 存入违约处理方式
	cunrkzfs varchar(1) NULL, -- 存入计划控制方式
	cunrclsx varchar(32) NULL, -- 存入处理顺序
	cunrzxje numeric(17, 2) NULL, -- 首次存入最小金额
	sccrjezl numeric(17, 2) NULL, -- 首次存入金额增量
	liuczdye numeric(21, 2) NULL, -- 账户留存最大余额
	cunruplv varchar(8) NULL, -- 存入频率
	weihguiy varchar(8) NULL, -- 维护柜员
	weihjigo varchar(10) NULL, -- 维护机构
	weihriqi varchar(8) NULL, -- 维护日期
	weihshij varchar(9) NULL, -- 维护时间
	shijchuo numeric(20) NULL, -- 时间戳
	jiluztai varchar(1) NULL, -- 记录状态
	ryzd varchar(1) NULL -- 冗余字段
);
COMMENT ON TABLE crmdm.cbs_kdpf_cunrkz IS '产品存入控制表';

-- Column comments

COMMENT ON COLUMN crmdm.cbs_kdpf_cunrkz.farendma IS '法人行号';
COMMENT ON COLUMN crmdm.cbs_kdpf_cunrkz.chapbhao IS '产品编号';
COMMENT ON COLUMN crmdm.cbs_kdpf_cunrkz.huobdaih IS '货币代号';
COMMENT ON COLUMN crmdm.cbs_kdpf_cunrkz.xianjncr IS '现金存入标志';
COMMENT ON COLUMN crmdm.cbs_kdpf_cunrkz.zhuanzcr IS '转账存入标志';
COMMENT ON COLUMN crmdm.cbs_kdpf_cunrkz.cunrkzhi IS '存入控制方式';
COMMENT ON COLUMN crmdm.cbs_kdpf_cunrkz.cunrkzff IS '存入控制方法';
COMMENT ON COLUMN crmdm.cbs_kdpf_cunrkz.crjekzfs IS '存入金额控制方式';
COMMENT ON COLUMN crmdm.cbs_kdpf_cunrkz.dccrzxje IS '单次存入最小金额(ZB表PRDKT_LIMIT_AMT取此字段)';
COMMENT ON COLUMN crmdm.cbs_kdpf_cunrkz.dccrzdje IS '单次存入最大金额';
COMMENT ON COLUMN crmdm.cbs_kdpf_cunrkz.cishkzfs IS '存入次数控制方式';
COMMENT ON COLUMN crmdm.cbs_kdpf_cunrkz.zuixcrcs IS '最小存入次数';
COMMENT ON COLUMN crmdm.cbs_kdpf_cunrkz.zuidcrcs IS '最大存入次数';
COMMENT ON COLUMN crmdm.cbs_kdpf_cunrkz.shezcrjh IS '设置存入计划标志';
COMMENT ON COLUMN crmdm.cbs_kdpf_cunrkz.crjhtzfs IS '存入计划调整方式';
COMMENT ON COLUMN crmdm.cbs_kdpf_cunrkz.crjhtzzq IS '存入计划调整周期';
COMMENT ON COLUMN crmdm.cbs_kdpf_cunrkz.crjhjsrq IS '存入计划结束日期方式';
COMMENT ON COLUMN crmdm.cbs_kdpf_cunrkz.crjhscfs IS '存入计划生成方式';
COMMENT ON COLUMN crmdm.cbs_kdpf_cunrkz.lcbzkxqi IS '漏存补足宽限期';
COMMENT ON COLUMN crmdm.cbs_kdpf_cunrkz.loucbqfs IS '存入漏补方式';
COMMENT ON COLUMN crmdm.cbs_kdpf_cunrkz.zdbzcshu IS '最大补足次数';
COMMENT ON COLUMN crmdm.cbs_kdpf_cunrkz.cunrwybz IS '存入违约标准';
COMMENT ON COLUMN crmdm.cbs_kdpf_cunrkz.lcuncshu IS '漏存次数';
COMMENT ON COLUMN crmdm.cbs_kdpf_cunrkz.crwyclfs IS '存入违约处理方式';
COMMENT ON COLUMN crmdm.cbs_kdpf_cunrkz.cunrkzfs IS '存入计划控制方式';
COMMENT ON COLUMN crmdm.cbs_kdpf_cunrkz.cunrclsx IS '存入处理顺序';
COMMENT ON COLUMN crmdm.cbs_kdpf_cunrkz.cunrzxje IS '首次存入最小金额';
COMMENT ON COLUMN crmdm.cbs_kdpf_cunrkz.sccrjezl IS '首次存入金额增量';
COMMENT ON COLUMN crmdm.cbs_kdpf_cunrkz.liuczdye IS '账户留存最大余额';
COMMENT ON COLUMN crmdm.cbs_kdpf_cunrkz.cunruplv IS '存入频率';
COMMENT ON COLUMN crmdm.cbs_kdpf_cunrkz.weihguiy IS '维护柜员';
COMMENT ON COLUMN crmdm.cbs_kdpf_cunrkz.weihjigo IS '维护机构';
COMMENT ON COLUMN crmdm.cbs_kdpf_cunrkz.weihriqi IS '维护日期';
COMMENT ON COLUMN crmdm.cbs_kdpf_cunrkz.weihshij IS '维护时间';
COMMENT ON COLUMN crmdm.cbs_kdpf_cunrkz.shijchuo IS '时间戳';
COMMENT ON COLUMN crmdm.cbs_kdpf_cunrkz.jiluztai IS '记录状态';
