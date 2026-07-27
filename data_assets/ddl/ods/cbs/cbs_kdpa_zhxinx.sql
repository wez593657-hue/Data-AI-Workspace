-- crmdm.cbs_kdpa_zhxinx 定义

-- Drop table

-- DROP TABLE crmdm.cbs_kdpa_zhxinx;

CREATE TABLE crmdm.cbs_kdpa_zhxinx (
	farendma varchar(4) NOT NULL, -- 法人代码
	zhanghao varchar(40) NOT NULL, -- 负债账号
	zhhuzwmc varchar(500) NOT NULL, -- 账户名称
	kehuhaoo varchar(16) NOT NULL, -- 客户号
	guobdaim varchar(10) NULL, -- 国别代码
	huobdaih varchar(3) NOT NULL, -- 货币代号
	chaohubz varchar(1) NOT NULL, -- 账户钞汇标志
	cunqiiii varchar(6) NOT NULL, -- 存期
	doqiriqi varchar(8) NULL, -- 到期日期
	qixifans varchar(1) NOT NULL, -- 起息方式
	csqixirq varchar(8) NOT NULL, -- 初始起息日期
	csdoqirq varchar(8) NULL, -- 初始到期日期
	yewudhao varchar(6) NULL, -- 业务代号
	pcljigoh varchar(10) NULL, -- 批处理机构
	zhujigoh varchar(10) NULL, -- 账户所属机构
	kaihjigo varchar(10) NOT NULL, -- 开户机构
	kaihriqi varchar(8) NOT NULL, -- 开户日期
	kaihguiy varchar(8) NOT NULL, -- 账户开户柜员
	xiohjigo varchar(10) NULL, -- 账户销户机构
	xiohriqi varchar(8) NULL, -- 账户销户日期
	xiohguiy varchar(10) NULL, -- 账户销户柜员
	lancreny varchar(500) NULL, -- 揽存人员
	lancrymc varchar(500) NULL, -- 账户经理名称
	youxriqi varchar(8) NULL, -- 账户有效期
	weiyxuho numeric(19) NULL, -- 当前未用序号
	zhhuyuee numeric(21, 2) NOT NULL, -- 当前账户余额
	shrizhye numeric(21, 2) NOT NULL, -- 上日账户余额
	yegxriqi varchar(8) NOT NULL, -- 余额最近更新日期
	sccrriqi varchar(8) NULL, -- 首次存入日期
	scywriqi varchar(8) NULL, -- 上次业务日期
	scsfriqi varchar(8) NULL, -- 上次代收付日期
	chapbhao varchar(10) NOT NULL, -- 产品编号
	fzcpleix varchar(1) NOT NULL, -- 负债产品类型
	suoshudx varchar(1) NOT NULL, -- 产品所属对象
	zhufldm1 varchar(10) NULL, -- 账户分类代码1
	zhufldm2 varchar(10) NULL, -- 账户分类代码2
	zhufldm3 varchar(10) NULL, -- 账户分类代码3
	huansbiz varchar(3) NOT NULL, -- 换算币种
	zuidlcye numeric(21, 2) NULL, -- 最大留存余额
	zuixlcye numeric(21, 2) NULL, -- 最小留存余额
	cunrkzhi varchar(1) NOT NULL, -- 存入控制方式
	cunrkzff varchar(1) NULL, -- 存入控制方法
	cunrclsx varchar(32) NOT NULL, -- 存入处理顺序
	zhiqkzfs varchar(1) NOT NULL, -- 支取控制方式
	zhiqkzff varchar(1) NULL, -- 支取控制方法
	zdzqkzfs varchar(4) NULL, -- 自定义支取控制方式
	kehuzhao varchar(35) NOT NULL, -- 客户账号
	zhcunfsh varchar(1) NULL, -- 转存方式
	beiyjine numeric(21, 2) NULL, -- 备用金额
	kaihjine numeric(21, 2) NULL, -- 开户金额
	cunkzlei varchar(2) NOT NULL, -- 存款种类
	zhhuztai varchar(1) NOT NULL, -- 账户状态
	yezztbbz varchar(1) NOT NULL, -- 余额与总账同步标志
	zhcphaoo varchar(10) NULL, -- 组合产品号
	zhcpxuho varchar(8) NULL, -- 组合产品序号
	zhcpmuzh varchar(35) NULL, -- 组合产品母账户号
	zhzhleix varchar(1) NULL, -- 组合账户类型
	zhhuxzbz varchar(1) NOT NULL, -- 账户限制标志
	xzhileix varchar(1) NULL, -- 限制类型
	xunhdkbz varchar(1) NOT NULL, -- 循环贷款标志
	zhbhgxbz varchar(1) NOT NULL, -- 账户保护关系标志
	zhiqbhsx varchar(32) NOT NULL, -- 支取保护顺序
	gltouzbz varchar(1) NOT NULL, -- 关联透支标志
	xtaizybz varchar(1) NOT NULL, -- 形态转移标志
	budhjzch varchar(20) NULL, -- BUDHJZCH
	dghushux varchar(1) NULL, -- 对公活期户属性
	jinkzhbz varchar(1) NOT NULL, -- 监控账户标志
	yuxutzbz varchar(1) NOT NULL, -- 允许透支标志
	waihjgbz varchar(1) NOT NULL, -- 外汇监管标志ABOQ
	waihhcbz varchar(1) NOT NULL, -- 外汇核查标志
	jieszhbz varchar(1) NOT NULL, -- 结算账户标志
	qyuelxbz varchar(1) NOT NULL, -- 签约理财标志
	yxxjzqbz varchar(1) NOT NULL, -- 允许现金支取标志
	yxzzzqbz varchar(1) NOT NULL, -- 允许转账支取标志
	yxxjcrbz varchar(1) NOT NULL, -- 允许现金存入标志
	yxzzcrbz varchar(1) NOT NULL, -- 允许转账存入标志
	xiedckbz varchar(1) NOT NULL, -- 协定存款标志
	shfojdjx varchar(1) NOT NULL, -- 是否简单计息
	sfdylxjh varchar(1) NOT NULL, -- 是否定义利息计划
	lxzffans varchar(1) NOT NULL, -- 利息支付方式
	shcifxri varchar(8) NULL, -- 上次付息日
	xiacfxri varchar(8) NULL, -- 下次付息日
	fuxipinl varchar(8) NULL, -- 付息频率
	shcijxri varchar(8) NULL, -- 上次计息日
	xiacjxri varchar(8) NULL, -- 下次计息日
	jixipnlv varchar(8) NULL, -- 计息频率
	tzlixibz varchar(1) NULL, -- 利率变化调整利息标志
	lilvbhao varchar(20) NULL, -- 利率编号
	zhixlilv numeric(12, 7) NULL, -- 执行利率
	lilvsffd varchar(1) NOT NULL, -- 利率是否浮动
	leijlixi numeric(20, 7) NULL, -- 累计利息
	jishuuuu numeric(21, 2) NULL, -- 积数
	yjyjlixi numeric(20, 7) NULL, -- 应加/减利息
	yjyjjish numeric(21, 2) NULL, -- 应加/减积数
	shfoyouz varchar(1) NOT NULL, -- 是否有折标志
	shishbbz varchar(1) NOT NULL, -- 实时划拨标志
	yueegjbz varchar(1) NOT NULL, -- 余额归集标志
	zhjedjbz varchar(1) NOT NULL, -- 账户金额冻结标志
	zhfbdjbz varchar(1) NOT NULL, -- 账户封闭冻结标志
	zhzsbfbz varchar(1) NOT NULL, -- 账户只收不付标志
	zhzfbsbz varchar(1) NOT NULL, -- 账户只付不收标志
	jiaoyanm varchar(200) NULL, -- 校验码
	beiyzd01 varchar(50) NULL, -- 备用字段01
	beiyzd02 varchar(50) NULL, -- 备用字段02
	beiyzd03 varchar(50) NULL, -- 备用字段03
	beiyye01 numeric(21, 2) NULL, -- 备用余额01
	beiyrq01 varchar(8) NULL, -- 备用日期1
	kaihuqud varchar(7) NULL, -- 开户渠道
	jitiywbm varchar(32) NULL, -- 计提业务编码
	sffydszh varchar(1) NULL, -- 是否反应到实账户
	zhhuztzd varchar(50) NULL, -- 账户状态字段
	plcffzzh varchar(16) NOT NULL, -- 批量拆分组号
	fsfyuerq varchar(8) NULL, -- 非收费余额更新日期
	weihguiy varchar(8) NOT NULL, -- 维护柜员
	weihjigo varchar(10) NOT NULL, -- 维护机构
	weihriqi varchar(8) NOT NULL, -- 维护日期
	weihshij varchar(9) NULL, -- 维护时间
	shijchuo numeric(19) NOT NULL, -- 时间戳
	jiluztai varchar(1) NOT NULL, -- 记录状态
	khzjlyzh varchar(40) NULL, -- KHZJLYZH
	bjlxzrzh varchar(35) NULL, -- 本金/利息转入账号
	bxzrzhao varchar(40) NULL, -- 本金/利息转入系统账号
	drjfxjje numeric(21, 2) NULL, -- 当日借方现金金额
	drjfzzje numeric(21, 2) NULL, -- 当日借方转账金额
	drdfxjje numeric(21, 2) NULL, -- 当日贷方现金金额
	drdfzzje numeric(21, 2) NULL, -- 当日贷方转账金额
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.farendma IS '法人代码';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.zhanghao IS '负债账号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.zhhuzwmc IS '账户名称';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.kehuhaoo IS '客户号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.guobdaim IS '国别代码';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.huobdaih IS '货币代号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.chaohubz IS '账户钞汇标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.cunqiiii IS '存期';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.doqiriqi IS '到期日期';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.qixifans IS '起息方式';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.csqixirq IS '初始起息日期';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.csdoqirq IS '初始到期日期';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.yewudhao IS '业务代号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.pcljigoh IS '批处理机构';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.zhujigoh IS '账户所属机构';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.kaihjigo IS '开户机构';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.kaihriqi IS '开户日期';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.kaihguiy IS '账户开户柜员';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.xiohjigo IS '账户销户机构';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.xiohriqi IS '账户销户日期';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.xiohguiy IS '账户销户柜员';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.lancreny IS '揽存人员';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.lancrymc IS '账户经理名称';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.youxriqi IS '账户有效期';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.weiyxuho IS '当前未用序号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.zhhuyuee IS '当前账户余额';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.shrizhye IS '上日账户余额';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.yegxriqi IS '余额最近更新日期';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.sccrriqi IS '首次存入日期';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.scywriqi IS '上次业务日期';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.scsfriqi IS '上次代收付日期';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.chapbhao IS '产品编号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.fzcpleix IS '负债产品类型';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.suoshudx IS '产品所属对象';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.zhufldm1 IS '账户分类代码1';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.zhufldm2 IS '账户分类代码2';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.zhufldm3 IS '账户分类代码3';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.huansbiz IS '换算币种';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.zuidlcye IS '最大留存余额';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.zuixlcye IS '最小留存余额';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.cunrkzhi IS '存入控制方式';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.cunrkzff IS '存入控制方法';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.cunrclsx IS '存入处理顺序';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.zhiqkzfs IS '支取控制方式';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.zhiqkzff IS '支取控制方法';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.zdzqkzfs IS '自定义支取控制方式';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.kehuzhao IS '客户账号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.zhcunfsh IS '转存方式';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.beiyjine IS '备用金额';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.kaihjine IS '开户金额';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.cunkzlei IS '存款种类';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.zhhuztai IS '账户状态';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.yezztbbz IS '余额与总账同步标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.zhcphaoo IS '组合产品号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.zhcpxuho IS '组合产品序号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.zhcpmuzh IS '组合产品母账户号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.zhzhleix IS '组合账户类型';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.zhhuxzbz IS '账户限制标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.xzhileix IS '限制类型';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.xunhdkbz IS '循环贷款标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.zhbhgxbz IS '账户保护关系标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.zhiqbhsx IS '支取保护顺序';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.gltouzbz IS '关联透支标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.xtaizybz IS '形态转移标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.budhjzch IS 'BUDHJZCH';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.dghushux IS '对公活期户属性';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.jinkzhbz IS '监控账户标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.yuxutzbz IS '允许透支标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.waihjgbz IS '外汇监管标志ABOQ';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.waihhcbz IS '外汇核查标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.jieszhbz IS '结算账户标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.qyuelxbz IS '签约理财标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.yxxjzqbz IS '允许现金支取标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.yxzzzqbz IS '允许转账支取标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.yxxjcrbz IS '允许现金存入标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.yxzzcrbz IS '允许转账存入标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.xiedckbz IS '协定存款标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.shfojdjx IS '是否简单计息';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.sfdylxjh IS '是否定义利息计划';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.lxzffans IS '利息支付方式';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.shcifxri IS '上次付息日';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.xiacfxri IS '下次付息日';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.fuxipinl IS '付息频率';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.shcijxri IS '上次计息日';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.xiacjxri IS '下次计息日';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.jixipnlv IS '计息频率';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.tzlixibz IS '利率变化调整利息标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.lilvbhao IS '利率编号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.zhixlilv IS '执行利率';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.lilvsffd IS '利率是否浮动';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.leijlixi IS '累计利息';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.jishuuuu IS '积数';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.yjyjlixi IS '应加/减利息';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.yjyjjish IS '应加/减积数';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.shfoyouz IS '是否有折标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.shishbbz IS '实时划拨标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.yueegjbz IS '余额归集标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.zhjedjbz IS '账户金额冻结标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.zhfbdjbz IS '账户封闭冻结标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.zhzsbfbz IS '账户只收不付标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.zhzfbsbz IS '账户只付不收标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.jiaoyanm IS '校验码';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.beiyzd01 IS '备用字段01';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.beiyzd02 IS '备用字段02';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.beiyzd03 IS '备用字段03';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.beiyye01 IS '备用余额01';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.beiyrq01 IS '备用日期1';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.kaihuqud IS '开户渠道';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.jitiywbm IS '计提业务编码';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.sffydszh IS '是否反应到实账户';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.zhhuztzd IS '账户状态字段';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.plcffzzh IS '批量拆分组号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.fsfyuerq IS '非收费余额更新日期';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.weihguiy IS '维护柜员';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.weihjigo IS '维护机构';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.weihriqi IS '维护日期';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.weihshij IS '维护时间';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.shijchuo IS '时间戳';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.jiluztai IS '记录状态';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.khzjlyzh IS 'KHZJLYZH';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.bjlxzrzh IS '本金/利息转入账号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.bxzrzhao IS '本金/利息转入系统账号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.drjfxjje IS '当日借方现金金额';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.drjfzzje IS '当日借方转账金额';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.drdfxjje IS '当日贷方现金金额';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.drdfzzje IS '当日贷方转账金额';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.ryzd IS '冗余字段';
