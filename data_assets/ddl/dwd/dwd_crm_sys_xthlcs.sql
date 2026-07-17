/*
 * DWD层表
 * 表名: crmdm.dwd_crm_sys_xthlcs
 * 来源: TB.ddl
 */

-- crmdm.dwd_crm_sys_xthlcs 定义

-- Drop table

-- DROP TABLE crmdm.dwd_crm_sys_xthlcs;

CREATE TABLE crmdm.dwd_crm_sys_xthlcs (
	huobdaih varchar(6) NOT NULL,
	pjdanwei numeric(20, 7) NOT NULL,
	huobfhao varchar(8) NULL,
	zhngjjia numeric(20, 7) NULL,
	hl numeric(20, 7) NULL
);



COMMENT ON TABLE DWD_CRM_SYS_XTHLCS IS '【待补充】';
