create table FMS_TD_CUST_TRANS_REQ_LOG
(
  APP_SERNO           VARCHAR2(32) not null,
  BUSI_CODE           VARCHAR2(3) not null,
  TRANS_CODE          VARCHAR2(8),
  FNC_TRANS_ACCT_NO   VARCHAR2(24) not null,
  TANO                VARCHAR2(16) not null,
  PROD_CODE           VARCHAR2(32) not null,
  SHARE_CLASS         CHAR(1),
  CUST_NO             VARCHAR2(32) not null,
  CUST_TYPE           VARCHAR2(3) not null,
  TA_ACCT_NO          VARCHAR2(32),
  TA_CFM_SERNO        VARCHAR2(32),
  CARD_NO             VARCHAR2(32),
  CARD_TYPE           VARCHAR2(2),
  ACCT_NO             VARCHAR2(32) not null,
  APP_DATE            VARCHAR2(8) not null,
  CFM_DATE            VARCHAR2(8),
  CCY                 VARCHAR2(3),
  APP_AMT             NUMBER(32,2),
  APP_VOL             NUMBER(32,2),
  CFM_AMT             NUMBER(32,2),
  CFM_VOL             NUMBER(32,2),
  CHARGE              NUMBER(32,2),
  CMMS_DISCT          NUMBER(8,5),
  TA_FLAG             CHAR(1),
  LRDM_FLAG           CHAR(1),
  CHANNEL             VARCHAR2(8),
  CHANNEL_SERNO       VARCHAR2(32),
  CHANNEL_DATE        VARCHAR2(8),
  CHANNEL_TIME        VARCHAR2(8),
  BANK_CODE           VARCHAR2(16),
  BRANCH_CODE         VARCHAR2(16),
  TRANS_ORGNO         VARCHAR2(16),
  INPUTUSER           VARCHAR2(10),
  GRANTUSER           VARCHAR2(8),
  AGENT_NAME          VARCHAR2(128),
  AGENT_ID_TYPE       VARCHAR2(8),
  AGENT_ID_CODE       VARCHAR2(32),
  NAV                 NUMBER(16,8),
  NAV_DATE            VARCHAR2(8),
  TAG_TRANS_ACCT_NO   VARCHAR2(24),
  TAG_DISTRIBUTORCODE VARCHAR2(9),
  TAG_TA_ACCT_NO      VARCHAR2(16),
  TAG_PROD_CODE       VARCHAR2(32),
  TAG_SHARE_CLASS     CHAR(1),
  FROZEN_CAUSE        CHAR(1),
  FROZEN_DDL          VARCHAR2(8),
  ORI_APP_SERNO       VARCHAR2(32),
  DEF_DIV_METHOD      CHAR(1),
  TRANS_STATUS        CHAR(1),
  CAPITAL_STATUS      VARCHAR2(1),
  CAPITAL_TYPE        VARCHAR2(1),
  RTN_CODE            VARCHAR2(30),
  RTN_DESC            NVARCHAR2(512),
  MAC_DATE            VARCHAR2(8) not null,
  MAC_TIME            VARCHAR2(8) not null,
  LEGAL_CODE          VARCHAR2(32),
  HOST_TRANS_SERNO    VARCHAR2(32),
  UPDATE_DATE         VARCHAR2(8),
  UPDATE_TIME         VARCHAR2(8),
  SYS_DATE            VARCHAR2(8),
  CUST_MANAGER        VARCHAR2(20),
  EXT_SUB_BRANCH_CODE VARCHAR2(16),
  FROZEN_NO           VARCHAR2(32),
  DEPOSIT_ACCT        VARCHAR2(32),
  CUST_RISK_LEVEL     CHAR(1),
  PROD_RISK_LEVEL     CHAR(1),
  TAG_ACCT_NO         VARCHAR2(32),
  TAG_CARD_NO         VARCHAR2(32),
  TAG_CARD_TYPE       VARCHAR2(1),
  TAG_AGENT_NAME      VARCHAR2(128),
  TAG_AGENT_ID_TYPE   VARCHAR2(8),
  TAG_AGENT_ID_CODE   VARCHAR2(32),
  TAG_CUST_NAME       VARCHAR2(128),
  TAG_ID_TYPE         VARCHAR2(8),
  TAG_ID_CODE         VARCHAR2(32),
  IS_FIRST            CHAR(1),
  TA_BATCH            VARCHAR2(16),
  TA_APP_SERNO        VARCHAR2(32),
  ORI_TA_CFM_SERNO    VARCHAR2(32),
  SRC_SERNO           VARCHAR2(32),
  PRINT_COUNT         VARCHAR2(2) ,
  ACCOUNT_DATE        VARCHAR2(8),
  TRANS_DEAL_IP       VARCHAR2(128),
  CHANNEL_IP          VARCHAR2(128),
  CHANNEL_MAC         VARCHAR2(64),
  RECOMM_PPL          VARCHAR2(32),
  SESSION_ID          VARCHAR2(32),
  ryzd                varchar(1) NULL
);
comment on table FMS_TD_CUST_TRANS_REQ_LOG
  is '理财交易申请流水表';
-- Add comments to the columns 
comment on column FMS_TD_CUST_TRANS_REQ_LOG.APP_SERNO
  is '交易申请流水号';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.BUSI_CODE
  is '业务代码';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.TRANS_CODE
  is '交易代码';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.FNC_TRANS_ACCT_NO
  is '理财交易账号';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.TANO
  is 'TA代码';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.PROD_CODE
  is '产品代码';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.SHARE_CLASS
  is '份额类别';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.CUST_NO
  is '客户号';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.CUST_TYPE
  is '客户类型';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.TA_ACCT_NO
  is 'TA账号';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.TA_CFM_SERNO
  is 'TA确认流水';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.CARD_NO
  is '凭证号';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.CARD_TYPE
  is '凭证类型';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.ACCT_NO
  is '银行账号';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.APP_DATE
  is '交易申请业务日期';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.CFM_DATE
  is '交易确认业务日期';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.CCY
  is '币种';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.APP_AMT
  is '交易申请金额';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.APP_VOL
  is '交易申请份额';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.CFM_AMT
  is '交易确认金额';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.CFM_VOL
  is '交易确认份额';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.CHARGE
  is '手续费';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.CMMS_DISCT
  is '销售佣金折扣率';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.TA_FLAG
  is 'TA发起业务标识';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.LRDM_FLAG
  is '巨额赎回标识';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.CHANNEL
  is '渠道';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.CHANNEL_SERNO
  is '渠道流水号';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.CHANNEL_DATE
  is '渠道日期';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.CHANNEL_TIME
  is '渠道时间';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.BANK_CODE
  is '交易总行代码';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.BRANCH_CODE
  is '交易分行代码';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.TRANS_ORGNO
  is '交易机构';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.INPUTUSER
  is '交易柜员';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.GRANTUSER
  is '授权柜员';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.AGENT_NAME
  is '经办(代理)人姓名';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.AGENT_ID_TYPE
  is '经办(代理)人证件类型';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.AGENT_ID_CODE
  is '经办(代理)人证件号码';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.NAV
  is '净值';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.NAV_DATE
  is '净值日期';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.TAG_TRANS_ACCT_NO
  is '对方理财交易账号';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.TAG_DISTRIBUTORCODE
  is '对方销售人代码';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.TAG_TA_ACCT_NO
  is '对方TA账号';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.TAG_PROD_CODE
  is '对方产品代码';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.TAG_SHARE_CLASS
  is '对方份额类别';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.FROZEN_CAUSE
  is '冻结原因';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.FROZEN_DDL
  is '冻结截止日期';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.ORI_APP_SERNO
  is '交易申请流水号原';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.DEF_DIV_METHOD
  is '默认分红方式';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.TRANS_STATUS
  is '交易状态(U-未处理; B-核心超时; C-TA超时; 0-申请成功; 1-申请失败; 2-已撤单; 3-确认成功; 4-确认失败; D-TA成功核心失败; E-TA失败核心成功;F-挂单成功;G部分确认（确认中）)'';';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.CAPITAL_STATUS
  is '资金状态(0-未处理;1-已冻结;2-冻结失败;3-冻结超时;4-已扣款;5-扣款失败;6-扣款超时;7-已解冻;8-解冻失败;9-解冻超时;A-已冲正;B-冲正失败;C-冲正超时;D-已还款;E-还款失败;F-还款超时;H-解冻扣款成功;I-解冻扣款失败;J-解冻扣款失败但解冻成功;)';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.CAPITAL_TYPE
  is '资金处理类型（0-冻结;1-扣款;2-解冻;3-还款;4-冲正;5-解冻并扣款;）';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.RTN_CODE
  is '返回码';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.RTN_DESC
  is '返回描述';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.MAC_DATE
  is '机器日期';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.MAC_TIME
  is '机器时间';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.LEGAL_CODE
  is '法人代码（多法人模式）';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.HOST_TRANS_SERNO
  is '核心流水号';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.UPDATE_DATE
  is '更新日期';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.UPDATE_TIME
  is '更新时间';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.SYS_DATE
  is '系统日期(系统工作日)';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.CUST_MANAGER
  is '客户经理代码';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.EXT_SUB_BRANCH_CODE
  is '推广机构';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.FROZEN_NO
  is '理财份额冻结编号';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.DEPOSIT_ACCT
  is '保证金账户';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.CUST_RISK_LEVEL
  is '客户风险承受等级';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.PROD_RISK_LEVEL
  is '产品风险等级';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.TAG_ACCT_NO
  is '对方银行账号';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.TAG_CARD_NO
  is '对方凭证号';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.TAG_CARD_TYPE
  is '对方凭证类型';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.TAG_AGENT_NAME
  is '转入方经办人名称';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.TAG_AGENT_ID_TYPE
  is '转入方经办人证件类型';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.TAG_AGENT_ID_CODE
  is '转入方经办人证件号码';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.TAG_CUST_NAME
  is '转入方客户名称';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.TAG_ID_TYPE
  is '输入方证件类型';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.TAG_ID_CODE
  is '输入方证件号码';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.IS_FIRST
  is '是否首次购买（1-是 0-否）';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.TA_BATCH
  is 'TA文件批次号（即文件名尾部的001、002，中登2.2接口允许发送多批次文件）';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.TA_APP_SERNO
  is 'TA确认记录的申请流水号（非TA发起交易的交易时应该与app_serno一致）';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.ORI_TA_CFM_SERNO
  is '原TA确认编号（032解冻时需要上送031冻结成功的确认流水号）';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.SRC_SERNO
  is '全局流水号';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.PRINT_COUNT
  is '补打次数';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.ACCOUNT_DATE
  is '预计到账日期';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.TRANS_DEAL_IP
  is '交易处理ip';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.CHANNEL_IP
  is '渠道IP';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.CHANNEL_MAC
  is '渠道mac';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.RECOMM_PPL
  is '推荐人';
comment on column FMS_TD_CUST_TRANS_REQ_LOG.SESSION_ID
  is '回溯码';
