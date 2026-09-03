-- crmdm.cbs_kdpf_cunqkz 定义
-- 资产入库: 2026-08-26, 需求版本 REQ-RCMD-001 (V1.0.2)
-- 来源: reference_logic/ALL_TB.sql 行6320 (DWD_PRDKT_INFO_ZB 加工依赖源表)

-- DROP TABLE crmdm.cbs_kdpf_cunqkz;

CREATE TABLE crmdm.cbs_kdpf_cunqkz (
	farendma varchar(4) NOT NULL, -- 法人行号
	chapbhao varchar(100) NOT NULL, -- 产品编号
	huobdaih varchar(3) NOT NULL, -- 货币代号
	cunqiiii varchar(6) NOT NULL, -- 存期
	shengxzt varchar(1) NULL, -- 生效状态 0-无效 1-有效 2-待生效
	weihguiy varchar(8) NULL, -- 维护柜员
	weihjigo varchar(10) NULL, -- 维护机构
	weihriqi varchar(8) NULL, -- 维护日期
	weihshij varchar(9) NULL, -- 维护时间
	shijchuo numeric(20) NULL, -- 时间戳
	jiluztai varchar(1) NULL, -- 记录状态
	ryzd varchar(1) NULL -- 冗余字段
);
COMMENT ON TABLE crmdm.cbs_kdpf_cunqkz IS '产品存期控制表';

-- Column comments

COMMENT ON COLUMN crmdm.cbs_kdpf_cunqkz.farendma IS '法人行号';
COMMENT ON COLUMN crmdm.cbs_kdpf_cunqkz.chapbhao IS '产品编号';
COMMENT ON COLUMN crmdm.cbs_kdpf_cunqkz.huobdaih IS '货币代号';
COMMENT ON COLUMN crmdm.cbs_kdpf_cunqkz.cunqiiii IS '存期';
COMMENT ON COLUMN crmdm.cbs_kdpf_cunqkz.shengxzt IS '生效状态 0-无效 1-有效 2-待生效';
COMMENT ON COLUMN crmdm.cbs_kdpf_cunqkz.weihguiy IS '维护柜员';
COMMENT ON COLUMN crmdm.cbs_kdpf_cunqkz.weihjigo IS '维护机构';
COMMENT ON COLUMN crmdm.cbs_kdpf_cunqkz.weihriqi IS '维护日期';
COMMENT ON COLUMN crmdm.cbs_kdpf_cunqkz.weihshij IS '维护时间';
COMMENT ON COLUMN crmdm.cbs_kdpf_cunqkz.shijchuo IS '时间戳';
COMMENT ON COLUMN crmdm.cbs_kdpf_cunqkz.jiluztai IS '记录状态';
COMMENT ON COLUMN crmdm.cbs_kdpf_cunqkz.ryzd IS '冗余字段';
