CREATE TABLE crmdm."ECPP_E_TXN_SIGN" (
    "TRX_ID"            VARCHAR(80)  NULL,  -- 交易ID
    "ISSR_ID"           VARCHAR(28)  NULL,  -- 发行者ID
    "TRX_DT_TM"         VARCHAR(40)  NULL,  -- 交易日期时间
    "TRX_CTGY"          VARCHAR(8)   NULL,  -- 交易类别
    "TXN_DATE"          VARCHAR(16)  NULL,  -- 交易日期
    "TXN_TIME"          VARCHAR(12)  NULL,  -- 交易时间
    "STATUS"            VARCHAR(4)   NULL,  -- 状态
    "INSTG_ID"          VARCHAR(28)  NULL,  -- 机构ID
    "INSTG_ACCT_DE"     VARCHAR(128) NULL,  -- 机构账户描述
    "SGN_ACCT_ISSR_ID"  VARCHAR(28)  NULL,  -- 签约账户发行者ID
    "SGN_ACCT_TP"       VARCHAR(4)   NULL,  -- 签约账户类型
    "SGN_ACCT_ID_DE"    VARCHAR(128) NULL,  -- 签约账户ID描述
    "SGN_ACCT_NM_DE"    VARCHAR(480) NULL,  -- 签约账户名称描述
    "ID_TP"             VARCHAR(4)   NULL,  -- 证件类型
    "ID_NO_DE"          VARCHAR(88)  NULL,  -- 证件号描述
    "MOB_NO_DE"         VARCHAR(48)  NULL,  -- 手机号描述
    "SGN_ACCT_LVL"      VARCHAR(2)   NULL,  -- 签约账户等级
    "BIZ_STS_CD"        VARCHAR(20)  NULL,  -- 业务状态码
    "BIZ_STS_DESC"      VARCHAR(480) NULL,  -- 业务状态描述
    "SYS_RTN_CD"        VARCHAR(20)  NULL,  -- 系统返回码
    "SYS_RTN_DESC"      VARCHAR(480) NULL,  -- 系统返回描述
    "SYS_RTN_TM"        VARCHAR(40)  NULL,  -- 系统返回时间
    "INSERT_TIME"       VARCHAR(28)  NULL,  -- 插入时间
    "UPDATE_TIME"       VARCHAR(28)  NULL,  -- 更新时间
    "REMARK"            VARCHAR(400) NULL,  -- 备注
    "CLBCK_URL"         VARCHAR(256) NULL,  -- 回调URL
    "RDRCT_URL"         VARCHAR(256) NULL,  -- 重定向URL
    "SGN_ACCT_SHRT_ID"  VARCHAR(4)   NULL,  -- 签约账户短ID
    "RYZD"              VARCHAR(1)   NULL   -- 冗余字段
);

-- 添加表注释
COMMENT ON TABLE crmdm."ECPP_E_TXN_SIGN" IS '电子签约交易签名表';

-- 添加字段注释
COMMENT ON COLUMN crmdm."ECPP_E_TXN_SIGN"."TRX_ID"            IS '交易ID';
COMMENT ON COLUMN crmdm."ECPP_E_TXN_SIGN"."ISSR_ID"           IS '发行者ID';
COMMENT ON COLUMN crmdm."ECPP_E_TXN_SIGN"."TRX_DT_TM"         IS '交易日期时间';
COMMENT ON COLUMN crmdm."ECPP_E_TXN_SIGN"."TRX_CTGY"          IS '交易类别';
COMMENT ON COLUMN crmdm."ECPP_E_TXN_SIGN"."TXN_DATE"          IS '交易日期';
COMMENT ON COLUMN crmdm."ECPP_E_TXN_SIGN"."TXN_TIME"          IS '交易时间';
COMMENT ON COLUMN crmdm."ECPP_E_TXN_SIGN"."STATUS"            IS '状态';
COMMENT ON COLUMN crmdm."ECPP_E_TXN_SIGN"."INSTG_ID"          IS '机构ID';
COMMENT ON COLUMN crmdm."ECPP_E_TXN_SIGN"."INSTG_ACCT_DE"     IS '机构账户描述';
COMMENT ON COLUMN crmdm."ECPP_E_TXN_SIGN"."SGN_ACCT_ISSR_ID"  IS '签约账户发行者ID';
COMMENT ON COLUMN crmdm."ECPP_E_TXN_SIGN"."SGN_ACCT_TP"       IS '签约账户类型';
COMMENT ON COLUMN crmdm."ECPP_E_TXN_SIGN"."SGN_ACCT_ID_DE"    IS '签约账户ID描述';
COMMENT ON COLUMN crmdm."ECPP_E_TXN_SIGN"."SGN_ACCT_NM_DE"    IS '签约账户名称描述';
COMMENT ON COLUMN crmdm."ECPP_E_TXN_SIGN"."ID_TP"             IS '证件类型';
COMMENT ON COLUMN crmdm."ECPP_E_TXN_SIGN"."ID_NO_DE"          IS '证件号描述';
COMMENT ON COLUMN crmdm."ECPP_E_TXN_SIGN"."MOB_NO_DE"         IS '手机号描述';
COMMENT ON COLUMN crmdm."ECPP_E_TXN_SIGN"."SGN_ACCT_LVL"      IS '签约账户等级';
COMMENT ON COLUMN crmdm."ECPP_E_TXN_SIGN"."BIZ_STS_CD"        IS '业务状态码';
COMMENT ON COLUMN crmdm."ECPP_E_TXN_SIGN"."BIZ_STS_DESC"      IS '业务状态描述';
COMMENT ON COLUMN crmdm."ECPP_E_TXN_SIGN"."SYS_RTN_CD"        IS '系统返回码';
COMMENT ON COLUMN crmdm."ECPP_E_TXN_SIGN"."SYS_RTN_DESC"      IS '系统返回描述';
COMMENT ON COLUMN crmdm."ECPP_E_TXN_SIGN"."SYS_RTN_TM"        IS '系统返回时间';
COMMENT ON COLUMN crmdm."ECPP_E_TXN_SIGN"."INSERT_TIME"       IS '插入时间';
COMMENT ON COLUMN crmdm."ECPP_E_TXN_SIGN"."UPDATE_TIME"       IS '更新时间';
COMMENT ON COLUMN crmdm."ECPP_E_TXN_SIGN"."REMARK"            IS '备注';
COMMENT ON COLUMN crmdm."ECPP_E_TXN_SIGN"."CLBCK_URL"         IS '回调URL';
COMMENT ON COLUMN crmdm."ECPP_E_TXN_SIGN"."RDRCT_URL"         IS '重定向URL';
COMMENT ON COLUMN crmdm."ECPP_E_TXN_SIGN"."SGN_ACCT_SHRT_ID"  IS '签约账户短ID';
COMMENT ON COLUMN crmdm."ECPP_E_TXN_SIGN"."RYZD"              IS '冗余字段';