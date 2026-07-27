-- crmdm.cbs_kdpa_zhlldy 定义

-- Drop table

-- DROP TABLE crmdm.cbs_kdpa_zhlldy;

CREATE TABLE crmdm.cbs_kdpa_zhlldy (
	farendma varchar(4) NOT NULL, -- 法人代码
	zhanghao varchar(40) NOT NULL, -- 负债账号
	pcljigoh varchar(10) NULL, -- 批处理机构
	kaihjigo varchar(10) NOT NULL, -- 开户机构
	huobdaih varchar(3) NULL, -- 货币代号
	fzlvleix varchar(8) NOT NULL, -- 负债利率类型
	shunxhao numeric(19) NOT NULL, -- 顺序号
	shezlljh varchar(1) NOT NULL, -- 设置利率计划标志
	lilvbhao varchar(20) NULL, -- 利率编号
	lilvbhlx varchar(1) NULL, -- 利率编号类型
	cencllbh varchar(20) NULL, -- 层次利率编号
	lilvdanc numeric(17, 2) NULL, -- 利率档次
	cencllcq varchar(6) NULL, -- 层次利率存期
	cunqiiii varchar(6) NULL, -- 存期
	lilvcqbz varchar(1) NULL, -- 利率存期标志
	lilvyebz varchar(1) NULL, -- 利率余额标志
	lilvkdfs varchar(1) NOT NULL, -- 利率靠档方式
	shxoriqi varchar(8) NULL, -- 账户利率编号生效日
	llbhsxrq varchar(8) NULL, -- 账户利率编号失效日
	lilvqdrq varchar(1) NULL, -- 利率确定日期
	ymdflagg varchar(1) NULL, -- 开户利率的年月利率标识
	kaihlilv numeric(12, 7) NULL, -- 开户利率
	jizhunll numeric(12, 7) NULL, -- 基准利率
	zhxililv numeric(12, 7) NULL, -- 当前执行利率
	lilvfdbz varchar(1) NOT NULL, -- 利率浮动标志
	llfdonbz varchar(1) NULL, -- 利率浮动标志1
	lilvfdlx varchar(1) NULL, -- 利率浮动类型
	lilvfdsz numeric(12, 7) NULL, -- 利率浮动值
	youhuibz varchar(1) NULL, -- 优惠标志
	youhuilx varchar(1) NULL, -- 优惠类型
	youhuisz numeric(12, 7) NULL, -- 优惠值
	lilvgxpl varchar(8) NULL, -- 利率更新频率
	shcigxrq varchar(8) NOT NULL, -- 利率上次更新日
	xacigxrq varchar(8) NULL, -- 利率下次更新日
	scjitilv numeric(12, 7) NULL, -- 上次计提利率
	tzlixibz varchar(1) NOT NULL, -- 利率变化调整利息标志
	tzlilvbz varchar(1) NOT NULL, -- 利率变化调整利率标志
	lilvdmlx varchar(1) NULL, -- 利率代码类型
	youhtzpl varchar(8) NULL, -- 优惠调整频率
	tzyouhbz varchar(1) NULL, -- 优惠变化调整优惠标志
	yhscriqi varchar(8) NULL, -- 优惠上次更新日
	yhxcriqi varchar(8) NULL, -- 优惠下次更新日
	fencleix varchar(2) NULL, -- 分层类型
	pjyeleix varchar(2) NULL, -- 平均余额类型
	zdqixian varchar(8) NULL, -- 指定期限
	weihguiy varchar(8) NOT NULL, -- 维护柜员
	weihjigo varchar(10) NOT NULL, -- 维护机构
	weihriqi varchar(8) NOT NULL, -- 维护日期
	weihshij varchar(9) NULL, -- 维护时间
	shijchuo numeric(19) NOT NULL, -- 时间戳
	jiluztai varchar(1) NOT NULL, -- 记录状态
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.farendma IS '法人代码';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.zhanghao IS '负债账号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.pcljigoh IS '批处理机构';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.kaihjigo IS '开户机构';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.huobdaih IS '货币代号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.fzlvleix IS '负债利率类型';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.shunxhao IS '顺序号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.shezlljh IS '设置利率计划标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.lilvbhao IS '利率编号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.lilvbhlx IS '利率编号类型';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.cencllbh IS '层次利率编号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.lilvdanc IS '利率档次';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.cencllcq IS '层次利率存期';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.cunqiiii IS '存期';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.lilvcqbz IS '利率存期标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.lilvyebz IS '利率余额标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.lilvkdfs IS '利率靠档方式';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.shxoriqi IS '账户利率编号生效日';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.llbhsxrq IS '账户利率编号失效日';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.lilvqdrq IS '利率确定日期';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.ymdflagg IS '开户利率的年月利率标识';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.kaihlilv IS '开户利率';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.jizhunll IS '基准利率';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.zhxililv IS '当前执行利率';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.lilvfdbz IS '利率浮动标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.llfdonbz IS '利率浮动标志1';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.lilvfdlx IS '利率浮动类型';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.lilvfdsz IS '利率浮动值';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.youhuibz IS '优惠标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.youhuilx IS '优惠类型';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.youhuisz IS '优惠值';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.lilvgxpl IS '利率更新频率';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.shcigxrq IS '利率上次更新日';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.xacigxrq IS '利率下次更新日';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.scjitilv IS '上次计提利率';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.tzlixibz IS '利率变化调整利息标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.tzlilvbz IS '利率变化调整利率标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.lilvdmlx IS '利率代码类型';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.youhtzpl IS '优惠调整频率';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.tzyouhbz IS '优惠变化调整优惠标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.yhscriqi IS '优惠上次更新日';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.yhxcriqi IS '优惠下次更新日';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.fencleix IS '分层类型';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.pjyeleix IS '平均余额类型';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.zdqixian IS '指定期限';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.weihguiy IS '维护柜员';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.weihjigo IS '维护机构';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.weihriqi IS '维护日期';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.weihshij IS '维护时间';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.shijchuo IS '时间戳';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.jiluztai IS '记录状态';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.ryzd IS '冗余字段';
