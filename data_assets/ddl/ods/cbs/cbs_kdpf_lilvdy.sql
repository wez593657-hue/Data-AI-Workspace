-- crmdm.cbs_kdpf_lilvdy 定义
-- 资产入库: 2026-08-26, 需求版本 REQ-RCMD-001 (V1.0.2)
-- 来源: reference_logic/ALL_TB.sql 行6443 (DWD_PRDKT_INFO_ZB 加工依赖源表)

-- DROP TABLE crmdm.cbs_kdpf_lilvdy;

CREATE TABLE crmdm.cbs_kdpf_lilvdy (
	farendma varchar(4) NOT NULL, -- 法人行号
	chapbhao varchar(100) NOT NULL, -- 产品编号
	huobdaih varchar(3) NOT NULL, -- 货币代号
	fzlvleix varchar(8) NULL, -- 负债利率类型(取ZHENLXLV真实利率型)
	lilvkdfs varchar(1) NULL, -- 利率靠档方式
	lilvbhao varchar(20) NULL, -- 利率编号(关联cbs_kitp_shijlv.lilvdama)
	lilvbhlx varchar(1) NULL, -- 利率编号类型
	lilvcunq varchar(6) NULL, -- 利率存期
	lilvcqbz varchar(1) NULL, -- 利率存期标志
	lilvyebz varchar(1) NULL, -- 利率余额标志
	lilvqdrq varchar(1) NULL, -- 利率确定日期
	lilvqdfs varchar(1) NULL, -- 利率确定方式
	lilvtzpl varchar(8) NULL, -- 利率调整频率
	tzlilvbz varchar(1) NULL, -- 利率变化调整利率标志
	tzlixibz varchar(1) NULL, -- 利率变化调整利息标志
	youhtzpl varchar(8) NULL, -- 优惠调整频率
	tzyouhbz varchar(1) NULL, -- 优惠变化调整优惠标志
	pjyeleix varchar(2) NULL, -- 平均余额类型
	zdqixian varchar(8) NULL, -- 指定期限
	weihguiy varchar(8) NULL, -- 维护柜员
	weihjigo varchar(10) NULL, -- 维护机构
	weihriqi varchar(8) NULL, -- 维护日期
	weihshij varchar(9) NULL, -- 维护时间
	shijchuo numeric(20) NULL, -- 时间戳
	jiluztai varchar(1) NULL, -- 记录状态
	ryzd varchar(1) NULL -- 冗余字段
);
COMMENT ON TABLE crmdm.cbs_kdpf_lilvdy IS '产品利率定义表';

-- Column comments

COMMENT ON COLUMN crmdm.cbs_kdpf_lilvdy.farendma IS '法人行号';
COMMENT ON COLUMN crmdm.cbs_kdpf_lilvdy.chapbhao IS '产品编号';
COMMENT ON COLUMN crmdm.cbs_kdpf_lilvdy.huobdaih IS '货币代号';
COMMENT ON COLUMN crmdm.cbs_kdpf_lilvdy.fzlvleix IS '负债利率类型(取ZHENLXLV真实利率型)';
COMMENT ON COLUMN crmdm.cbs_kdpf_lilvdy.lilvkdfs IS '利率靠档方式';
COMMENT ON COLUMN crmdm.cbs_kdpf_lilvdy.lilvbhao IS '利率编号(关联cbs_kitp_shijlv.lilvdama)';
COMMENT ON COLUMN crmdm.cbs_kdpf_lilvdy.lilvbhlx IS '利率编号类型';
COMMENT ON COLUMN crmdm.cbs_kdpf_lilvdy.lilvcunq IS '利率存期';
COMMENT ON COLUMN crmdm.cbs_kdpf_lilvdy.lilvcqbz IS '利率存期标志';
COMMENT ON COLUMN crmdm.cbs_kdpf_lilvdy.lilvyebz IS '利率余额标志';
COMMENT ON COLUMN crmdm.cbs_kdpf_lilvdy.lilvqdrq IS '利率确定日期';
COMMENT ON COLUMN crmdm.cbs_kdpf_lilvdy.lilvqdfs IS '利率确定方式';
COMMENT ON COLUMN crmdm.cbs_kdpf_lilvdy.lilvtzpl IS '利率调整频率';
COMMENT ON COLUMN crmdm.cbs_kdpf_lilvdy.tzlilvbz IS '利率变化调整利率标志';
COMMENT ON COLUMN crmdm.cbs_kdpf_lilvdy.tzlixibz IS '利率变化调整利息标志';
COMMENT ON COLUMN crmdm.cbs_kdpf_lilvdy.youhtzpl IS '优惠调整频率';
COMMENT ON COLUMN crmdm.cbs_kdpf_lilvdy.tzyouhbz IS '优惠变化调整优惠标志';
COMMENT ON COLUMN crmdm.cbs_kdpf_lilvdy.pjyeleix IS '平均余额类型';
COMMENT ON COLUMN crmdm.cbs_kdpf_lilvdy.zdqixian IS '指定期限';
COMMENT ON COLUMN crmdm.cbs_kdpf_lilvdy.weihguiy IS '维护柜员';
COMMENT ON COLUMN crmdm.cbs_kdpf_lilvdy.weihjigo IS '维护机构';
COMMENT ON COLUMN crmdm.cbs_kdpf_lilvdy.weihriqi IS '维护日期';
COMMENT ON COLUMN crmdm.cbs_kdpf_lilvdy.weihshij IS '维护时间';
COMMENT ON COLUMN crmdm.cbs_kdpf_lilvdy.shijchuo IS '时间戳';
COMMENT ON COLUMN crmdm.cbs_kdpf_lilvdy.jiluztai IS '记录状态';
COMMENT ON COLUMN crmdm.cbs_kdpf_lilvdy.ryzd IS '冗余字段';
