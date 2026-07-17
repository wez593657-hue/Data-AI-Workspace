/*
 * 上游核心系统
 * 表名: crmdm.cbs_kdpb_kouhua
 * 来源: TB.ddl
 */

-- crmdm.cbs_kdpb_kouhua 定义

-- Drop table

-- DROP TABLE crmdm.cbs_kdpb_kouhua;

CREATE TABLE crmdm.cbs_kdpb_kouhua (
	farendma varchar(4) NOT NULL,
	kouhabho varchar(32) NOT NULL,
	kouhuafs varchar(1) NOT NULL,
	dongjbho varchar(32) NULL,
	kehuzhao varchar(35) NOT NULL,
	zhanghao varchar(40) NULL,
	kouhuaje numeric(17, 2) NOT NULL,
	dxzhxhao varchar(40) NULL,
	skrkhuzh varchar(35) NULL,
	skzhxuho varchar(8) NULL,
	zfbmleix varchar(1) NULL,
	khbmenmc varchar(100) NULL,
	khwshaoo varchar(200) NULL,
	khryzle1 varchar(2) NULL,
	khryzjh1 varchar(80) NULL,
	khryzle3 varchar(2) NULL,
	khryzjh3 varchar(80) NULL,
	khryxmm1 varchar(500) NULL,
	khryzle2 varchar(2) NULL,
	khryzjh2 varchar(80) NULL,
	khryzle4 varchar(2) NULL,
	khryzjh4 varchar(80) NULL,
	khryxmm2 varchar(500) NULL,
	zhaiyoms varchar(80) NULL,
	jiaoyijg varchar(10) NOT NULL,
	jinbguiy varchar(8) NOT NULL,
	fuheguiy varchar(8) NULL,
	shnpguiy varchar(8) NULL,
	wbjoyima varchar(20) NOT NULL,
	nbjoyima varchar(20) NOT NULL,
	jiaoyirq varchar(8) NULL,
	jiaoyisj numeric(19) NULL,
	guiylius varchar(32) NULL,
	weihguiy varchar(8) NOT NULL,
	weihjigo varchar(10) NOT NULL,
	weihriqi varchar(8) NOT NULL,
	weihshij varchar(9) NULL,
	shijchuo numeric(19) NOT NULL,
	jiluztai varchar(1) NOT NULL,
	khrywmc1 varchar(500) NULL,
	ryzd varchar(1) NULL
);

