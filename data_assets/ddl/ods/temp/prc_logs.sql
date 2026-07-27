-- crmdm.prc_logs 定义

-- Drop table

-- DROP TABLE crmdm.prc_logs;

CREATE TABLE crmdm.prc_logs (
	logid numeric(20) NOT NULL,
	prc_name varchar(80) NULL,
	prc_desc varchar(300) NULL,
	logdate varchar(8) NULL,
	no_id varchar(10) NULL,
	bgn_date sys."date" NULL,
	end_date sys."date" NULL,
	dura_date numeric(10) NULL,
	logmsg varchar(1000) NULL,
	log_flg numeric(10) NULL,
	CONSTRAINT pk_prc_logs PRIMARY KEY (logid)
);
