/*
 * 上游核心系统
 * 表名: crmdm.cbs_kfxp_xthlcs
 * 来源: TB.ddl
 */

-- crmdm.cbs_kfxp_xthlcs 定义

-- Drop table

-- DROP TABLE crmdm.cbs_kfxp_xthlcs;

CREATE TABLE crmdm.cbs_kfxp_xthlcs (
    farendma varchar(4) NOT NULL,
    shenxriq varchar(8) NOT NULL,
    shenxshj numeric(19) NOT NULL,
    huobdaih varchar(3) NOT NULL,
    pjdanwei numeric(12,
    7) NOT NULL,
    huobfhao varchar(4) NOT NULL,
    mairujia numeric(12,
    7) NOT NULL,
    maichjia numeric(12,
    7) NOT NULL,
    zhngjjia numeric(12,
    7) NOT NULL,
    caomrjia numeric(12,
    7) NOT NULL,
    caomcjia numeric(12,
    7) NOT NULL,
    ppmrujia numeric(12,
    7) NOT NULL,
    ppmchjia numeric(12,
    7) NOT NULL,
    beizhuxx varchar(200) NOT NULL,
    weihguiy varchar(8) NOT NULL,
    weihjigo varchar(10) NOT NULL,
    weihriqi varchar(8) NOT NULL,
    weihshij varchar(9) NULL,
    shijchuo numeric(19) NOT NULL,
    jiluztai varchar(1) NOT NULL,
    ryzd varchar(1) NULL
);