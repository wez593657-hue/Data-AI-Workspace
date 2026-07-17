/*
 * DWD层表
 * 表名: crmdm.dwd_tmp_jigou_base
 * 来源: TB.ddl
 */

-- crmdm.dwd_tmp_jigou_base 定义

-- Drop table

-- DROP TABLE crmdm.dwd_tmp_jigou_base;

CREATE TABLE crmdm.dwd_tmp_jigou_base (
	jigouhao varchar(10) NOT NULL,
	farendma varchar(4) NOT NULL,
	fenhdaim varchar(30) NOT NULL,
	jigoleix varchar(30) NOT NULL,
	jigouzwm varchar(500) NULL,
	dizhiiii varchar(500) NULL,
	youzhnbm varchar(10) NULL,
	dianhhma varchar(20) NULL,
	weihriqi varchar(8) NULL,
	weihshij varchar(9) NULL,
	jingduxx varchar(30) NULL,
	weiduxxz varchar(30) NULL,
	yewugxjg varchar(30) NULL,
	yewugxjb numeric(3) NULL
);



COMMENT ON TABLE DWD_TMP_JIGOU_BASE IS '【待补充】';
