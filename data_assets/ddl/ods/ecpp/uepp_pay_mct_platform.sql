/*
 * 上游网联系统
 * 表名: crmdm.uepp_pay_mct_platform
 * 来源: TB.ddl
 */

-- crmdm.uepp_pay_mct_platform 定义

-- Drop table

-- DROP TABLE crmdm.uepp_pay_mct_platform;

CREATE TABLE crmdm.uepp_pay_mct_platform (
	r_id varchar(40) NOT NULL,
	platform_mct_id varchar(40) NULL,
	secondary_mct_id varchar(40) NULL,
	secondary_fre_rate numeric(16, 4) NULL,
	create_user varchar(40) NULL,
	create_time varchar(20) NULL,
	update_user varchar(40) NULL,
	update_time varchar(20) NULL,
	ryzd varchar(1) NULL,
	CONSTRAINT pk_uepp_pay_mct_platform PRIMARY KEY (r_id)
);

