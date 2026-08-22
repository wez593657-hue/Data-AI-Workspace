-- Create table
create table FMS_TD_CUST_VOL_DETAIL
(
  FNC_TRANS_ACCT_NO        VARCHAR2(24) not null,
  TA_ACCT_NO               VARCHAR2(32) not null,
  TANO                     VARCHAR2(16) not null,
  PROD_CODE                VARCHAR2(32) not null,
  SHARE_CLASS              CHAR(1),
  CUST_NO                  VARCHAR2(32),
  TA_CFM_SERNO             VARCHAR2(32) not null,
  BUSI_CODE                VARCHAR2(3),
  REGISTER_DATE            VARCHAR2(8),
  NAV                      NUMBER(16,8),
  NAV_DATE                 VARCHAR2(8),
  CFM_VOL                  NUMBER(32,2),
  REMAIN_VOL               NUMBER(32,2),
  UPD_DATE                 VARCHAR2(8) not null,
  UPD_TIME                 VARCHAR2(6) not null,
  LEGAL_CODE               VARCHAR2(32),
  CUST_MANAGER             VARCHAR2(20),
  CHANNEL                  VARCHAR2(8),
  TRANS_ORGNO              VARCHAR2(16),
  FROZEN_VOL               NUMBER(32,2),
  ALLOW_REDEMPT_DATE       CHAR(8) not null,
  ELISOR_FROZEN_VOL        NUMBER(16,2),
  ABN_FROZEN_VOL           NUMBER(16,2),
  ALLOWREDEMPTDEADLINEDATE VARCHAR2(8)
)
tablespace TS_NFMS_TAB
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64
    next 1
    minextents 1
    maxextents unlimited
  );
-- Add comments to the table 
comment on table FMS_TD_CUST_VOL_DETAIL
  is '代销理财客户份额明细表';
-- Add comments to the columns 
comment on column FMS_TD_CUST_VOL_DETAIL.FNC_TRANS_ACCT_NO
  is '理财交易账号';
comment on column FMS_TD_CUST_VOL_DETAIL.TA_ACCT_NO
  is 'TA账号';
comment on column FMS_TD_CUST_VOL_DETAIL.TANO
  is 'TA代码';
comment on column FMS_TD_CUST_VOL_DETAIL.PROD_CODE
  is '产品代码';
comment on column FMS_TD_CUST_VOL_DETAIL.SHARE_CLASS
  is '份额类别';
comment on column FMS_TD_CUST_VOL_DETAIL.CUST_NO
  is '客户号';
comment on column FMS_TD_CUST_VOL_DETAIL.TA_CFM_SERNO
  is 'TA确认流水';
comment on column FMS_TD_CUST_VOL_DETAIL.BUSI_CODE
  is '业务代码';
comment on column FMS_TD_CUST_VOL_DETAIL.REGISTER_DATE
  is '份额注册日期';
comment on column FMS_TD_CUST_VOL_DETAIL.NAV
  is '净值';
comment on column FMS_TD_CUST_VOL_DETAIL.NAV_DATE
  is '净值日期';
comment on column FMS_TD_CUST_VOL_DETAIL.CFM_VOL
  is '确认份额';
comment on column FMS_TD_CUST_VOL_DETAIL.REMAIN_VOL
  is '剩余份额（含冻结份额）';
comment on column FMS_TD_CUST_VOL_DETAIL.UPD_DATE
  is '更新日期';
comment on column FMS_TD_CUST_VOL_DETAIL.UPD_TIME
  is '更新时间';
comment on column FMS_TD_CUST_VOL_DETAIL.LEGAL_CODE
  is '法人代码（多法人模式）';
comment on column FMS_TD_CUST_VOL_DETAIL.CUST_MANAGER
  is '客户经理代码';
comment on column FMS_TD_CUST_VOL_DETAIL.CHANNEL
  is '渠道代码';
comment on column FMS_TD_CUST_VOL_DETAIL.TRANS_ORGNO
  is '交易机构';
comment on column FMS_TD_CUST_VOL_DETAIL.FROZEN_VOL
  is '冻结份额';
comment on column FMS_TD_CUST_VOL_DETAIL.ALLOW_REDEMPT_DATE
  is '允许赎回日期';
comment on column FMS_TD_CUST_VOL_DETAIL.ELISOR_FROZEN_VOL
  is '司法冻结份额';
comment on column FMS_TD_CUST_VOL_DETAIL.ABN_FROZEN_VOL
  is '质押冻结份额';
comment on column FMS_TD_CUST_VOL_DETAIL.ALLOWREDEMPTDEADLINEDATE
  is '可赎回截止日期';
