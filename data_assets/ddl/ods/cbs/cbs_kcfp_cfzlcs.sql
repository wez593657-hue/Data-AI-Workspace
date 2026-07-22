/*
 * 上游核心系统
 * 表名: crmdm.cbs_kcfp_cfzlcs
 * 来源: TB.ddl
 */

-- crmdm.cbs_kcfp_cfzlcs 定义

-- Drop table

-- DROP TABLE crmdm.cbs_kcfp_cfzlcs;

CREATE TABLE crmdm.cbs_kcfp_cfzlcs (
    farendma varchar(4) NOT NULL,
    canshmch varchar(500) NOT NULL,
    canshuzh varchar(35) NOT NULL,
    cansshju varchar(80) NULL,
    beiyshju varchar(80) NULL,
    canshshm varchar(200) NOT NULL,
    xuliehao varchar(30) NULL,
    weihguiy varchar(8) NOT NULL,
    weihjigo varchar(10) NOT NULL,
    weihriqi varchar(8) NOT NULL,
    weihshij varchar(9) NULL,
    shijchuo numeric(19) NOT NULL,
    jiluztai varchar(1) NOT NULL,
    ryzd varchar(1) NULL
);