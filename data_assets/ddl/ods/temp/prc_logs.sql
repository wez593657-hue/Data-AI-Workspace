-- crmdm.prc_logs 定义

-- Drop table

-- DROP TABLE crmdm.prc_logs;

CREATE TABLE crmdm.prc_logs (
	logid numeric(20) NOT NULL, -- 日志主键
	prc_name varchar(80) NULL, -- 存储过程名称
	prc_desc varchar(300) NULL, -- 存储过程描述
	logdate varchar(8) NULL, -- 日志日期
	no_id varchar(10) NULL, -- 步骤编号
	bgn_date sys."date" NULL, -- 开始时间
	end_date sys."date" NULL, -- 结束时间
	dura_date numeric(10) NULL, -- 耗时
	logmsg varchar(1000) NULL, -- 日志内容
	log_flg numeric(10) NULL, -- 日志标志
	CONSTRAINT pk_prc_logs PRIMARY KEY (logid)
);
COMMENT ON TABLE crmdm.prc_logs IS '单步调试日志表';

-- Column comments

COMMENT ON COLUMN crmdm.prc_logs.logid IS '日志主键';
COMMENT ON COLUMN crmdm.prc_logs.prc_name IS '存储过程名称';
COMMENT ON COLUMN crmdm.prc_logs.prc_desc IS '存储过程描述';
COMMENT ON COLUMN crmdm.prc_logs.logdate IS '日志日期';
COMMENT ON COLUMN crmdm.prc_logs.no_id IS '步骤编号';
COMMENT ON COLUMN crmdm.prc_logs.bgn_date IS '开始时间';
COMMENT ON COLUMN crmdm.prc_logs.end_date IS '结束时间';
COMMENT ON COLUMN crmdm.prc_logs.dura_date IS '耗时';
COMMENT ON COLUMN crmdm.prc_logs.logmsg IS '日志内容';
COMMENT ON COLUMN crmdm.prc_logs.log_flg IS '日志标志';
