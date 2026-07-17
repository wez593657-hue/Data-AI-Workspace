/*
 * DWD层表
 * 表名: crmdm.dwd_prdkt_catlog
 * 来源: TB.ddl
 */

-- crmdm.dwd_prdkt_catlog 定义

-- Drop table

-- DROP TABLE crmdm.dwd_prdkt_catlog;

CREATE TABLE crmdm.dwd_prdkt_catlog (
	prdkt_catlog_id varchar(40) NOT NULL,
	persn_legal_bk_code varchar(30) NULL,
	prdkt_cls_id varchar(40) NULL,
	prdkt_cls_name varchar(100) NULL,
	prdkt_catlog_path varchar(200) NOT NULL,
	prdkt_line varchar(6) NULL,
	sup_prdkt_cls_id varchar(40) NULL,
	prdkt_id varchar(40) NULL,
	curnt_hraky_seq_id numeric NULL,
	curnt_calib_statis_flg varchar(1) NULL,
	statis_calib varchar(6) NULL,
	prdkt_state varchar(6) NULL,
	send_chnl varchar(20) NULL,
	obj_typ varchar(2) NULL,
	is_rcmd varchar(20) NULL,
	water_print_addrs varchar(20) NULL,
	hot_date varchar(20) NULL,
	rcmd_date varchar(20) NULL,
	is_hot varchar(2) NULL,
	mdl_biz_rate_fee numeric(18, 5) NULL,
	prdkt_state1 varchar(10) NULL,
	CONSTRAINT pk_dwd_prdkt_catlog PRIMARY KEY (prdkt_catlog_id)
);



COMMENT ON TABLE DWD_PRDKT_CATLOG IS '【待补充】';
