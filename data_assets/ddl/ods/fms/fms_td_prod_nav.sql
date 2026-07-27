-- crmdm.fms_td_prod_nav 定义

-- Drop table

-- DROP TABLE crmdm.fms_td_prod_nav;

CREATE TABLE crmdm.fms_td_prod_nav (
	tano varchar(16) NOT NULL, -- TA代码
	prod_code varchar(32) NOT NULL, -- 产品代码
	share_class bpchar(1) NULL, -- 份额类别
	net_value_type varchar(1) NOT NULL, -- 净值类型
	nav_date varchar(8) NOT NULL, -- 净值日期
	nav numeric(16, 8) NULL, -- 单位净值
	total_nav numeric(16, 8) NULL, -- 累计净值
	ten_thousand_income_amt numeric(16, 8) NULL, -- 万份收益
	seven_days_income_rate numeric(17, 8) NULL, -- 近七日年化收益率
	import_date varchar(8) NULL, -- 导入日期
	legal_code varchar(32) NULL, -- 法人代码（多法人模式）
	dayclientratio numeric(16, 8) NULL, -- 日年化收益率
	monthclientratio numeric(16, 8) NULL, -- 近一月年化收益率
	quarterclientratio numeric(16, 8) NULL, -- 近一季年化收益率
	semiannualclientratio numeric(16, 8) NULL, -- 近半年以来年化收益率
	yearclientratio numeric(16, 8) NULL, -- 近一年年化收益率
	cycleclientratio numeric(16, 8) NULL, -- 上周期化收益率
	twoyearclientratio numeric(16, 8) NULL, -- 近二年以来年化收益率
	threeyearclientratio numeric(16, 8) NULL, -- 近三年以来年化收益率
	tonowclientratio numeric(16, 8) NULL, -- 成立以来参考年化收益率
	remark varchar(200) NULL, -- 备注
	adjustednav numeric(16, 2) NULL, -- 复权净值
	ryzd varchar(1) NULL
);
COMMENT ON TABLE crmdm.fms_td_prod_nav IS '理财产品行情表';

-- Column comments

COMMENT ON COLUMN crmdm.fms_td_prod_nav.tano IS 'TA代码';
COMMENT ON COLUMN crmdm.fms_td_prod_nav.prod_code IS '产品代码';
COMMENT ON COLUMN crmdm.fms_td_prod_nav.share_class IS '份额类别';
COMMENT ON COLUMN crmdm.fms_td_prod_nav.net_value_type IS '净值类型';
COMMENT ON COLUMN crmdm.fms_td_prod_nav.nav_date IS '净值日期';
COMMENT ON COLUMN crmdm.fms_td_prod_nav.nav IS '单位净值';
COMMENT ON COLUMN crmdm.fms_td_prod_nav.total_nav IS '累计净值';
COMMENT ON COLUMN crmdm.fms_td_prod_nav.ten_thousand_income_amt IS '万份收益';
COMMENT ON COLUMN crmdm.fms_td_prod_nav.seven_days_income_rate IS '近七日年化收益率';
COMMENT ON COLUMN crmdm.fms_td_prod_nav.import_date IS '导入日期';
COMMENT ON COLUMN crmdm.fms_td_prod_nav.legal_code IS '法人代码（多法人模式）';
COMMENT ON COLUMN crmdm.fms_td_prod_nav.dayclientratio IS '日年化收益率';
COMMENT ON COLUMN crmdm.fms_td_prod_nav.monthclientratio IS '近一月年化收益率';
COMMENT ON COLUMN crmdm.fms_td_prod_nav.quarterclientratio IS '近一季年化收益率';
COMMENT ON COLUMN crmdm.fms_td_prod_nav.semiannualclientratio IS '近半年以来年化收益率';
COMMENT ON COLUMN crmdm.fms_td_prod_nav.yearclientratio IS '近一年年化收益率';
COMMENT ON COLUMN crmdm.fms_td_prod_nav.cycleclientratio IS '上周期化收益率';
COMMENT ON COLUMN crmdm.fms_td_prod_nav.twoyearclientratio IS '近二年以来年化收益率';
COMMENT ON COLUMN crmdm.fms_td_prod_nav.threeyearclientratio IS '近三年以来年化收益率';
COMMENT ON COLUMN crmdm.fms_td_prod_nav.tonowclientratio IS '成立以来参考年化收益率';
COMMENT ON COLUMN crmdm.fms_td_prod_nav.remark IS '备注';
COMMENT ON COLUMN crmdm.fms_td_prod_nav.adjustednav IS '复权净值';
