/*
 * 过程日志
 * 表名: crm_prc_logsq
 * 来源: TB.ddl
 */

-- crm_prc_logsq 定义

-- Drop table

-- DROP TABLE crm_prc_logsq;

CREATE TABLE crm_prc_logsq (
    logid numeric(20) NOT NULL,
    prc_name varchar(80) NULL,
    prc_desc varchar(300) NULL,
    logdate varchar(8) NULL,
    no_id varchar(10) NULL,
    bgn_date DATE NULL,
    end_date DATE NULL,
    dura_date numeric(10) NULL,
    logmsg varchar(1000) NULL,
    log_flg numeric(10) NULL,
    CONSTRAINT pk_prc_logsq PRIMARY KEY (logid)
);