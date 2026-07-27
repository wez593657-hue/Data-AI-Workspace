-- crmdm.cbs_kdpl_zhminx 定义

-- Drop table

-- DROP TABLE crmdm.cbs_kdpl_zhminx;

CREATE TABLE crmdm.cbs_kdpl_zhminx (
	farendma varchar(4) NOT NULL, -- FARENDMA
	zhanghao varchar(40) NOT NULL, -- ZHANGHAO
	zhhuzwmc varchar(500) NOT NULL, -- ZHHUZWMC
	kehuzhlx varchar(1) NULL, -- KEHUZHLX
	yezdminc varchar(32) NOT NULL, -- YEZDMINC
	mxixuhao numeric(19) NOT NULL, -- MXIXUHAO
	jiedaibz varchar(1) NOT NULL, -- JIEDAIBZ
	jiaoybiz varchar(3) NOT NULL, -- JIAOYBIZ
	chaohubz varchar(1) NOT NULL, -- CHAOHUBZ
	jiaoyije numeric(17, 2) NOT NULL, -- JIAOYIJE
	zhanghye numeric(21, 2) NOT NULL, -- ZHANGHYE
	kehuzhao varchar(35) NOT NULL, -- KEHUZHAO
	zhhaoxuh varchar(8) NULL, -- ZHHAOXUH
	shifoudy varchar(1) NULL, -- SHIFOUDY
	zhondhao varchar(200) NULL, -- ZHONDHAO
	butiiibz varchar(1) NULL, -- BUTIIIBZ
	chapbhao varchar(10) NOT NULL, -- CHAPBHAO
	suoshudx varchar(1) NOT NULL, -- SUOSHUDX
	zhqixzhi varchar(6) NULL, -- ZHQIXZHI
	pngzzlei varchar(3) NULL, -- PNGZZLEI
	pngzphao varchar(8) NULL, -- PNGZPHAO
	pngzxhao varchar(18) NULL, -- PNGZXHAO
	zhaiyodm varchar(10) NULL, -- ZHAIYODM
	zhaiyoms varchar(80) NULL, -- ZHAIYOMS
	qdaoleix varchar(7) NULL, -- QDAOLEIX
	wbjoyima varchar(10) NOT NULL, -- WBJOYIMA
	nbjoyima varchar(10) NOT NULL, -- NBJOYIMA
	xianzzbz varchar(1) NOT NULL, -- XIANZZBZ
	duifkhzh varchar(35) NULL, -- DUIFKHZH
	dfzhhxuh varchar(8) NULL, -- DFZHHXUH
	duifxtzh varchar(40) NULL, -- DUIFXTZH
	duifminc varchar(500) NULL, -- DUIFMINC
	duifkhlx varchar(2) NULL, -- DUIFKHLX
	duifjgmc varchar(60) NULL, -- DUIFJGMC
	duifjglx varchar(2) NULL, -- DUIFJGLX
	duifjgdm varchar(20) NULL, -- DUIFJGDM
	dailxinm varchar(500) NULL, -- DAILXINM
	dailzjlx varchar(2) NULL, -- DAILZJLX
	dailzjho varchar(80) NULL, -- DAILZJHO
	dailguoj varchar(10) NULL, -- DAILGUOJ
	zhcphaoo varchar(10) NULL, -- ZHCPHAOO
	zhcpzhao varchar(40) NULL, -- ZHCPZHAO
	yhywbhao varchar(30) NULL, -- YHYWBHAO
	xgywbhao varchar(40) NULL, -- XGYWBHAO
	guiylius varchar(32) NOT NULL, -- GUIYLIUS
	jyyyjigo varchar(10) NOT NULL, -- JYYYJIGO
	kaihjigo varchar(10) NOT NULL, -- KAIHJIGO
	caozguiy varchar(8) NOT NULL, -- CAOZGUIY
	fuheguiy varchar(8) NULL, -- FUHEGUIY
	shoqguiy varchar(8) NULL, -- SHOQGUIY
	jiaoyirq varchar(8) NOT NULL, -- JIAOYIRQ
	jiaoyisj numeric(19) NOT NULL, -- JIAOYISJ
	zhujriqi varchar(8) NULL, -- ZHUJRIQI
	chongzbz varchar(1) NOT NULL, -- CHONGZBZ
	bchongbz varchar(1) NOT NULL, -- BCHONGBZ
	cuozriqi varchar(8) NULL, -- CUOZRIQI
	cuozlius varchar(32) NULL, -- CUOZLIUS
	beizhuuu varchar(200) NULL, -- BEIZHUUU
	jioycffs varchar(1) NULL, -- JIOYCFFS
	dayiyesh numeric(19) NULL, -- DAYIYESH
	weihguiy varchar(8) NOT NULL, -- WEIHGUIY
	weihjigo varchar(10) NOT NULL, -- WEIHJIGO
	weihriqi varchar(8) NOT NULL, -- WEIHRIQI
	weihshij varchar(9) NULL, -- WEIHSHIJ
	shijchuo numeric(19) NOT NULL, -- SHIJCHUO
	jiluztai varchar(1) NOT NULL, -- JILUZTAI
	xnjnxmdm varchar(4) NULL, -- XNJNXMDM
	dailreyw varchar(500) NULL, -- DAILREYW
	dlirdhua varchar(40) NULL, -- DLIRDHUA
	qianfarq varchar(8) NULL, -- QIANFARQ
	doqiriqi varchar(8) NULL, -- DOQIRIQI
	ipdizhii varchar(32) NULL, -- IP地址
	macdizhi varchar(32) NULL, -- MAC地址
	zijnlaiy varchar(200) NULL, -- 资金来源
	qxyongtu varchar(200) NULL, -- 取现用途
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.farendma IS 'FARENDMA';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.zhanghao IS 'ZHANGHAO';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.zhhuzwmc IS 'ZHHUZWMC';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.kehuzhlx IS 'KEHUZHLX';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.yezdminc IS 'YEZDMINC';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.mxixuhao IS 'MXIXUHAO';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.jiedaibz IS 'JIEDAIBZ';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.jiaoybiz IS 'JIAOYBIZ';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.chaohubz IS 'CHAOHUBZ';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.jiaoyije IS 'JIAOYIJE';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.zhanghye IS 'ZHANGHYE';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.kehuzhao IS 'KEHUZHAO';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.zhhaoxuh IS 'ZHHAOXUH';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.shifoudy IS 'SHIFOUDY';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.zhondhao IS 'ZHONDHAO';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.butiiibz IS 'BUTIIIBZ';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.chapbhao IS 'CHAPBHAO';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.suoshudx IS 'SUOSHUDX';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.zhqixzhi IS 'ZHQIXZHI';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.pngzzlei IS 'PNGZZLEI';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.pngzphao IS 'PNGZPHAO';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.pngzxhao IS 'PNGZXHAO';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.zhaiyodm IS 'ZHAIYODM';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.zhaiyoms IS 'ZHAIYOMS';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.qdaoleix IS 'QDAOLEIX';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.wbjoyima IS 'WBJOYIMA';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.nbjoyima IS 'NBJOYIMA';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.xianzzbz IS 'XIANZZBZ';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.duifkhzh IS 'DUIFKHZH';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.dfzhhxuh IS 'DFZHHXUH';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.duifxtzh IS 'DUIFXTZH';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.duifminc IS 'DUIFMINC';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.duifkhlx IS 'DUIFKHLX';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.duifjgmc IS 'DUIFJGMC';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.duifjglx IS 'DUIFJGLX';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.duifjgdm IS 'DUIFJGDM';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.dailxinm IS 'DAILXINM';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.dailzjlx IS 'DAILZJLX';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.dailzjho IS 'DAILZJHO';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.dailguoj IS 'DAILGUOJ';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.zhcphaoo IS 'ZHCPHAOO';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.zhcpzhao IS 'ZHCPZHAO';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.yhywbhao IS 'YHYWBHAO';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.xgywbhao IS 'XGYWBHAO';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.guiylius IS 'GUIYLIUS';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.jyyyjigo IS 'JYYYJIGO';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.kaihjigo IS 'KAIHJIGO';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.caozguiy IS 'CAOZGUIY';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.fuheguiy IS 'FUHEGUIY';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.shoqguiy IS 'SHOQGUIY';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.jiaoyirq IS 'JIAOYIRQ';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.jiaoyisj IS 'JIAOYISJ';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.zhujriqi IS 'ZHUJRIQI';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.chongzbz IS 'CHONGZBZ';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.bchongbz IS 'BCHONGBZ';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.cuozriqi IS 'CUOZRIQI';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.cuozlius IS 'CUOZLIUS';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.beizhuuu IS 'BEIZHUUU';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.jioycffs IS 'JIOYCFFS';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.dayiyesh IS 'DAYIYESH';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.weihguiy IS 'WEIHGUIY';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.weihjigo IS 'WEIHJIGO';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.weihriqi IS 'WEIHRIQI';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.weihshij IS 'WEIHSHIJ';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.shijchuo IS 'SHIJCHUO';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.jiluztai IS 'JILUZTAI';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.xnjnxmdm IS 'XNJNXMDM';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.dailreyw IS 'DAILREYW';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.dlirdhua IS 'DLIRDHUA';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.qianfarq IS 'QIANFARQ';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.doqiriqi IS 'DOQIRIQI';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.ipdizhii IS 'IP地址';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.macdizhi IS 'MAC地址';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.zijnlaiy IS '资金来源';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.qxyongtu IS '取现用途';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.ryzd IS '冗余字段';
