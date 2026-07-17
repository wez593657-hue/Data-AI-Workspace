/*
 * 上游手机系统
 * 表名: crmdm.mbk_mkp_rebat_recode
 * 来源: TB.ddl
 */

-- crmdm.mbk_mkp_rebat_recode 定义

-- Drop table

-- DROP TABLE crmdm.mbk_mkp_rebat_recode;

CREATE TABLE crmdm.mbk_mkp_rebat_recode (
	acti_no varchar(32) NOT NULL,
	cust_no varchar(32) NULL,
	user_time varchar(32) NULL,
	sence_code varchar(16) NULL,
	rebat_value numeric(22, 2) NULL,
	status bpchar(1) NULL,
	recode_no varchar(32) NOT NULL,
	trans_amt numeric(22, 2) NULL,
	payed_value numeric(22, 2) NULL,
	refund_remark varchar(3000) NULL,
	ryzd varchar(1) NULL,
	CONSTRAINT pk_mbk_mkp_rebat_recode PRIMARY KEY (recode_no)
);

