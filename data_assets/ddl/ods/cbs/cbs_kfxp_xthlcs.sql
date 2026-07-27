-- crmdm.cbs_kfxp_xthlcs 定义

-- Drop table

-- DROP TABLE crmdm.cbs_kfxp_xthlcs;

CREATE TABLE crmdm.cbs_kfxp_xthlcs (
	farendma varchar(4) NOT NULL, -- 法人代码
	shenxriq varchar(8) NOT NULL, -- 生效日期
	shenxshj numeric(19) NOT NULL, -- 生效时间
	huobdaih varchar(3) NOT NULL, -- 货币代号
	pjdanwei numeric(12, 7) NOT NULL, -- 牌价单位
	huobfhao varchar(4) NOT NULL, -- 货币符号
	mairujia numeric(12, 7) NOT NULL, -- 买入价
	maichjia numeric(12, 7) NOT NULL, -- 卖出价
	zhngjjia numeric(12, 7) NOT NULL, -- 中间价
	caomrjia numeric(12, 7) NOT NULL, -- 钞买价
	caomcjia numeric(12, 7) NOT NULL, -- 钞卖价
	ppmrujia numeric(12, 7) NOT NULL, -- 平盘买入价
	ppmchjia numeric(12, 7) NOT NULL, -- 平盘卖出价
	beizhuxx varchar(200) NOT NULL, -- 备注信息
	weihguiy varchar(8) NOT NULL, -- 维护柜员
	weihjigo varchar(10) NOT NULL, -- 维护机构
	weihriqi varchar(8) NOT NULL, -- 维护日期
	weihshij varchar(9) NULL, -- 维护时间
	shijchuo numeric(19) NOT NULL, -- 时间戳
	jiluztai varchar(1) NOT NULL, -- 记录状态
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.cbs_kfxp_xthlcs.farendma IS '法人代码';
COMMENT ON COLUMN crmdm.cbs_kfxp_xthlcs.shenxriq IS '生效日期';
COMMENT ON COLUMN crmdm.cbs_kfxp_xthlcs.shenxshj IS '生效时间';
COMMENT ON COLUMN crmdm.cbs_kfxp_xthlcs.huobdaih IS '货币代号';
COMMENT ON COLUMN crmdm.cbs_kfxp_xthlcs.pjdanwei IS '牌价单位';
COMMENT ON COLUMN crmdm.cbs_kfxp_xthlcs.huobfhao IS '货币符号';
COMMENT ON COLUMN crmdm.cbs_kfxp_xthlcs.mairujia IS '买入价';
COMMENT ON COLUMN crmdm.cbs_kfxp_xthlcs.maichjia IS '卖出价';
COMMENT ON COLUMN crmdm.cbs_kfxp_xthlcs.zhngjjia IS '中间价';
COMMENT ON COLUMN crmdm.cbs_kfxp_xthlcs.caomrjia IS '钞买价';
COMMENT ON COLUMN crmdm.cbs_kfxp_xthlcs.caomcjia IS '钞卖价';
COMMENT ON COLUMN crmdm.cbs_kfxp_xthlcs.ppmrujia IS '平盘买入价';
COMMENT ON COLUMN crmdm.cbs_kfxp_xthlcs.ppmchjia IS '平盘卖出价';
COMMENT ON COLUMN crmdm.cbs_kfxp_xthlcs.beizhuxx IS '备注信息';
COMMENT ON COLUMN crmdm.cbs_kfxp_xthlcs.weihguiy IS '维护柜员';
COMMENT ON COLUMN crmdm.cbs_kfxp_xthlcs.weihjigo IS '维护机构';
COMMENT ON COLUMN crmdm.cbs_kfxp_xthlcs.weihriqi IS '维护日期';
COMMENT ON COLUMN crmdm.cbs_kfxp_xthlcs.weihshij IS '维护时间';
COMMENT ON COLUMN crmdm.cbs_kfxp_xthlcs.shijchuo IS '时间戳';
COMMENT ON COLUMN crmdm.cbs_kfxp_xthlcs.jiluztai IS '记录状态';
COMMENT ON COLUMN crmdm.cbs_kfxp_xthlcs.ryzd IS '冗余字段';
