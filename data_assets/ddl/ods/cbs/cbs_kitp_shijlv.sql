-- crmdm.cbs_kitp_shijlv 定义
-- 资产入库: 2026-08-26, 需求版本 REQ-RCMD-001 (V1.0.2)
-- 来源: reference_logic/ALL_TB.sql 行7019 (DWD_PRDKT_INFO_ZB 加工依赖源表)

-- DROP TABLE crmdm.cbs_kitp_shijlv;

CREATE TABLE crmdm.cbs_kitp_shijlv (
	farendma varchar(4) NOT NULL, -- 法人行号
	fenhdaim varchar(4) NOT NULL, -- 分行代码
	yngyjigo varchar(12) NOT NULL, -- 营业机构
	lilvdama varchar(20) NOT NULL, -- 利率代码(关联cbs_kdpf_lilvdy.lilvbhao)
	lilvbhlx varchar(1) NOT NULL, -- 利率编号类型
	shengxrq varchar(8) NOT NULL, -- 生效日期(取<=跑批日最新一条)
	bizhongg varchar(3) NOT NULL, -- 币种
	cunqiiii varchar(6) NOT NULL, -- 实际存期
	jizhlldc numeric(17, 2) NOT NULL, -- 基准利率档次
	lilvcslx varchar(1) NULL, -- 利率参数类型
	nylilvbz varchar(1) NULL, -- 年月利率标志
	jizhlldm varchar(20) NULL, -- 基准利率代码
	jizhunll numeric(12, 7) NULL, -- 基准利率
	lilvfdlx varchar(1) NULL, -- 浮动类型
	lilvfdzh numeric(17, 2) NULL, -- 利率浮动值
	lilvfdbl numeric(17, 2) NULL, -- 利率浮动比例
	shijilvl numeric(12, 7) NULL, -- 实际利率(ZB表PRDKT_RATE取此字段)
	llsfzdds numeric(21, 2) NULL, -- 利率上浮最大点数
	llxfzdds numeric(21, 2) NULL, -- 利率下浮最大点数
	llsfbfbi numeric(21, 2) NULL, -- 利率上浮最大百分比
	llxfbfbi numeric(21, 2) NULL, -- 利率下浮最大百分比
	zuidlilv numeric(12, 7) NULL, -- 最大利率
	zuixlilv numeric(12, 7) NULL, -- 最小利率
	yunxuyhu varchar(1) NULL, -- 是否允许优惠
	yhgzsyfs varchar(1) NULL, -- 优惠规则适用方式
	shuoming varchar(200) NULL, -- 说明
	beiyngzd varchar(200) NULL, -- 备用字段
	weihguiy varchar(8) NULL, -- 维护柜员
	weihjigo varchar(10) NULL, -- 维护机构
	weihriqi varchar(8) NULL, -- 维护日期
	weihshij varchar(9) NULL, -- 维护时间
	shijchuo numeric(20) NULL, -- 时间戳
	jiluztai varchar(1) NULL, -- 记录状态
	ryzd varchar(1) NULL -- 冗余字段
);
COMMENT ON TABLE crmdm.cbs_kitp_shijlv IS '实际利率表';

-- Column comments

COMMENT ON COLUMN crmdm.cbs_kitp_shijlv.farendma IS '法人行号';
COMMENT ON COLUMN crmdm.cbs_kitp_shijlv.fenhdaim IS '分行代码';
COMMENT ON COLUMN crmdm.cbs_kitp_shijlv.yngyjigo IS '营业机构';
COMMENT ON COLUMN crmdm.cbs_kitp_shijlv.lilvdama IS '利率代码(关联cbs_kdpf_lilvdy.lilvbhao)';
COMMENT ON COLUMN crmdm.cbs_kitp_shijlv.lilvbhlx IS '利率编号类型';
COMMENT ON COLUMN crmdm.cbs_kitp_shijlv.shengxrq IS '生效日期(取<=跑批日最新一条)';
COMMENT ON COLUMN crmdm.cbs_kitp_shijlv.bizhongg IS '币种';
COMMENT ON COLUMN crmdm.cbs_kitp_shijlv.cunqiiii IS '实际存期';
COMMENT ON COLUMN crmdm.cbs_kitp_shijlv.jizhlldc IS '基准利率档次';
COMMENT ON COLUMN crmdm.cbs_kitp_shijlv.lilvcslx IS '利率参数类型';
COMMENT ON COLUMN crmdm.cbs_kitp_shijlv.nylilvbz IS '年月利率标志';
COMMENT ON COLUMN crmdm.cbs_kitp_shijlv.jizhlldm IS '基准利率代码';
COMMENT ON COLUMN crmdm.cbs_kitp_shijlv.jizhunll IS '基准利率';
COMMENT ON COLUMN crmdm.cbs_kitp_shijlv.lilvfdlx IS '浮动类型';
COMMENT ON COLUMN crmdm.cbs_kitp_shijlv.lilvfdzh IS '利率浮动值';
COMMENT ON COLUMN crmdm.cbs_kitp_shijlv.lilvfdbl IS '利率浮动比例';
COMMENT ON COLUMN crmdm.cbs_kitp_shijlv.shijilvl IS '实际利率(ZB表PRDKT_RATE取此字段)';
COMMENT ON COLUMN crmdm.cbs_kitp_shijlv.llsfzdds IS '利率上浮最大点数';
COMMENT ON COLUMN crmdm.cbs_kitp_shijlv.llxfzdds IS '利率下浮最大点数';
COMMENT ON COLUMN crmdm.cbs_kitp_shijlv.llsfbfbi IS '利率上浮最大百分比';
COMMENT ON COLUMN crmdm.cbs_kitp_shijlv.llxfbfbi IS '利率下浮最大百分比';
COMMENT ON COLUMN crmdm.cbs_kitp_shijlv.zuidlilv IS '最大利率';
COMMENT ON COLUMN crmdm.cbs_kitp_shijlv.zuixlilv IS '最小利率';
COMMENT ON COLUMN crmdm.cbs_kitp_shijlv.yunxuyhu IS '是否允许优惠';
COMMENT ON COLUMN crmdm.cbs_kitp_shijlv.yhgzsyfs IS '优惠规则适用方式';
COMMENT ON COLUMN crmdm.cbs_kitp_shijlv.shuoming IS '说明';
COMMENT ON COLUMN crmdm.cbs_kitp_shijlv.beiyngzd IS '备用字段';
COMMENT ON COLUMN crmdm.cbs_kitp_shijlv.weihguiy IS '维护柜员';
COMMENT ON COLUMN crmdm.cbs_kitp_shijlv.weihjigo IS '维护机构';
COMMENT ON COLUMN crmdm.cbs_kitp_shijlv.weihriqi IS '维护日期';
COMMENT ON COLUMN crmdm.cbs_kitp_shijlv.weihshij IS '维护时间';
COMMENT ON COLUMN crmdm.cbs_kitp_shijlv.shijchuo IS '时间戳';
COMMENT ON COLUMN crmdm.cbs_kitp_shijlv.jiluztai IS '记录状态';
