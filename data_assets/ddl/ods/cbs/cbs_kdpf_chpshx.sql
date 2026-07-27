-- crmdm.cbs_kdpf_chpshx 定义

-- Drop table

-- DROP TABLE crmdm.cbs_kdpf_chpshx;

CREATE TABLE crmdm.cbs_kdpf_chpshx (
	farendma varchar(4) NOT NULL, -- 法人代码
	chapbhao varchar(10) NOT NULL, -- 产品编号
	chanpshm varchar(200) NULL, -- 产品说明
	yinxoshm varchar(200) NULL, -- 产品营销说明
	shenxriq varchar(8) NULL, -- 生效日期
	shixriqi varchar(8) NULL, -- 负债产品失效日
	dinhuobz varchar(1) NULL, -- 产品定活标志 :0-活期产品,1-定期产品
	suoshudx varchar(1) NULL, -- 产品所属对象 :1-对私存款产品,2-对公存款产品,3-同业存款产品
	chapleix varchar(1) NULL, -- 产品类型 :0-传统产品,1-扩展产品
	chapbizh varchar(3) NULL, -- 产品默认币种 :01-人民币,12-英镑,13-港币,14-美元,15-瑞士法郎,27-日元,28-加拿大元,29-澳大利亚元,18-新加坡元,38-欧元,43-韩元,81-澳门元,82-新台币,83-津巴布韦币,99-所有币种,98-所有外币
	xnjntdbz varchar(1) NULL, -- 现金通兑标志 :1-是,0-否
	zhnztdbz varchar(1) NULL, -- 转账通兑标志 :1-是,0-否
	tduifwei varchar(1) NULL, -- 通兑范围 :0-不通兑,1-分行通兑,2-全行通兑
	tcunfwei varchar(1) NULL, -- 通存范围 :0-开户机构通存,1-分行通存,2-全行通存
	qudknzbz varchar(1) NULL, -- 渠道控制标志 :0-不控制,1-限制控制,2-排除控制
	bizhkzbz varchar(1) NULL, -- 币种控制标志 :0-不控制,1-限制控制,2-排除控制
	jigknzbz varchar(1) NULL, -- 机构控制标志 :0-不控制,1-限制控制,2-排除控制
	kehknzbz varchar(1) NULL, -- 客户控制标志 :0-不控制,1-限制控制,2-排除控制
	zhhuflbz varchar(1) NULL, -- 账户分类标志 :1-是,0-否
	pngzkzbz varchar(1) NULL, -- 凭证控制标志 :0-不控制,1-限制控制,2-排除控制
	cunqkzfs varchar(1) NULL, -- 存期控制方式 :0-不定存期,1-产品控制存期,2-自定义存期
	morzhhlx varchar(2) NULL, -- 默认账户类型
	chapzhut varchar(1) NULL, -- 产品状态 :0-正常,1-待生效,2-注销
	shfodqdy varchar(1) NULL, -- 是否到期定义 :1-是,0-否
	shfotzdy varchar(1) NULL, -- 是否透支定义 :1-是,0-否
	shfosfdy varchar(1) NULL, -- 是否收费定义 :1-是,0-否
	shfojdjx varchar(1) NULL, -- 是否简单计息 :1-是,0-否
	shfojshu varchar(1) NULL, -- 是否结算户 :1-是,0-否
	zidojhbz varchar(1) NULL, -- 自动结汇标志 :0-不自动,1-自动
	zidoshbz varchar(1) NULL, -- 自动售汇标志 :0-不自动,1-自动
	yxjiehbz varchar(1) NULL, -- 允许结汇标志 :0-不允许,1-允许
	yezztbbz varchar(1) NULL, -- 余额与总账同步标志 :1-是,0-否
	shfoxtzy varchar(1) NULL, -- 是否形态转移定义 :1-是,0-否
	zongeduu numeric(17, 2) NULL, -- 总额度
	jimbiaoz varchar(1) NULL, -- 记名标志 :0-不记名,1-记名
	chenbzhx varchar(4) NULL, -- 成本中心
	cunkzlei varchar(2) NULL, -- 存款种类 :00-普通活期,01-整存整取,02-定活两便,03-存本取息,04-零存整取,05-通知存款,06-教育储蓄,07-整存零取,08-协议存款,09-协定存款,10-通知理财,11-对公活期,12-对公整存整取,13-对公通知存款,14-对公活期保证金,15-对公定期保证金,16-对私活期保证金,17-对私定期保证金,18-同业活期存款,19-同业定期存款,20-同业通知存款,21-财政存款,22-对公理财,23-同业活期保证金,24-同业定期保证金,25-对私理财,26-大额存单,27-账户透支
	huansbiz varchar(3) NULL, -- 换算币种 :01-人民币,12-英镑,13-港币,14-美元,15-瑞士法郎,27-日元,28-加拿大元,29-澳大利亚元,18-新加坡元,38-欧元,43-韩元,81-澳门元,82-新台币,83-津巴布韦币,99-所有币种,98-所有外币
	weihguiy varchar(8) NOT NULL, -- 维护柜员
	weihjigo varchar(10) NOT NULL, -- 维护机构
	weihriqi varchar(8) NOT NULL, -- 维护日期
	weihshij varchar(9) NULL, -- 维护时间
	shijchuo numeric(19) NOT NULL, -- 时间戳
	jiluztai varchar(1) NOT NULL, -- 记录状态 :0-正常,1-删除
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.farendma IS '法人代码';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.chapbhao IS '产品编号';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.chanpshm IS '产品说明';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.yinxoshm IS '产品营销说明';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.shenxriq IS '生效日期';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.shixriqi IS '负债产品失效日';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.dinhuobz IS '产品定活标志 :0-活期产品,1-定期产品';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.suoshudx IS '产品所属对象 :1-对私存款产品,2-对公存款产品,3-同业存款产品';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.chapleix IS '产品类型 :0-传统产品,1-扩展产品';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.chapbizh IS '产品默认币种 :01-人民币,12-英镑,13-港币,14-美元,15-瑞士法郎,27-日元,28-加拿大元,29-澳大利亚元,18-新加坡元,38-欧元,43-韩元,81-澳门元,82-新台币,83-津巴布韦币,99-所有币种,98-所有外币';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.xnjntdbz IS '现金通兑标志 :1-是,0-否';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.zhnztdbz IS '转账通兑标志 :1-是,0-否';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.tduifwei IS '通兑范围 :0-不通兑,1-分行通兑,2-全行通兑';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.tcunfwei IS '通存范围 :0-开户机构通存,1-分行通存,2-全行通存';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.qudknzbz IS '渠道控制标志 :0-不控制,1-限制控制,2-排除控制';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.bizhkzbz IS '币种控制标志 :0-不控制,1-限制控制,2-排除控制';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.jigknzbz IS '机构控制标志 :0-不控制,1-限制控制,2-排除控制';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.kehknzbz IS '客户控制标志 :0-不控制,1-限制控制,2-排除控制';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.zhhuflbz IS '账户分类标志 :1-是,0-否';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.pngzkzbz IS '凭证控制标志 :0-不控制,1-限制控制,2-排除控制';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.cunqkzfs IS '存期控制方式 :0-不定存期,1-产品控制存期,2-自定义存期';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.morzhhlx IS '默认账户类型';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.chapzhut IS '产品状态 :0-正常,1-待生效,2-注销';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.shfodqdy IS '是否到期定义 :1-是,0-否';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.shfotzdy IS '是否透支定义 :1-是,0-否';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.shfosfdy IS '是否收费定义 :1-是,0-否';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.shfojdjx IS '是否简单计息 :1-是,0-否';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.shfojshu IS '是否结算户 :1-是,0-否';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.zidojhbz IS '自动结汇标志 :0-不自动,1-自动';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.zidoshbz IS '自动售汇标志 :0-不自动,1-自动';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.yxjiehbz IS '允许结汇标志 :0-不允许,1-允许';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.yezztbbz IS '余额与总账同步标志 :1-是,0-否';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.shfoxtzy IS '是否形态转移定义 :1-是,0-否';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.zongeduu IS '总额度';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.jimbiaoz IS '记名标志 :0-不记名,1-记名';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.chenbzhx IS '成本中心';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.cunkzlei IS '存款种类 :00-普通活期,01-整存整取,02-定活两便,03-存本取息,04-零存整取,05-通知存款,06-教育储蓄,07-整存零取,08-协议存款,09-协定存款,10-通知理财,11-对公活期,12-对公整存整取,13-对公通知存款,14-对公活期保证金,15-对公定期保证金,16-对私活期保证金,17-对私定期保证金,18-同业活期存款,19-同业定期存款,20-同业通知存款,21-财政存款,22-对公理财,23-同业活期保证金,24-同业定期保证金,25-对私理财,26-大额存单,27-账户透支';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.huansbiz IS '换算币种 :01-人民币,12-英镑,13-港币,14-美元,15-瑞士法郎,27-日元,28-加拿大元,29-澳大利亚元,18-新加坡元,38-欧元,43-韩元,81-澳门元,82-新台币,83-津巴布韦币,99-所有币种,98-所有外币';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.weihguiy IS '维护柜员';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.weihjigo IS '维护机构';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.weihriqi IS '维护日期';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.weihshij IS '维护时间';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.shijchuo IS '时间戳';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.jiluztai IS '记录状态 :0-正常,1-删除';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.ryzd IS '冗余字段';
