create table FMS_T5_CUST_TRANS_LOG
(
  TRANS_SERNO         VARCHAR2(32) not null,
  SYS_MBT             VARCHAR2(6),
  BUSI_CODE           VARCHAR2(6) not null,
  CHANNEL_FLAG        VARCHAR2(3) not null,
  CHANNEL_DATE        CHAR(8),
  CHANNEL_TIME        CHAR(6),
  CHANNEL_SERNO       VARCHAR2(32),
  MACDATE             CHAR(8) not null,
  MACTIME             CHAR(6) not null,
  BANK_CODE           VARCHAR2(20) not null,
  BRANCH_CODE         VARCHAR2(20) not null,
  SUB_BRANCH_CODE     VARCHAR2(20) not null,
  INPUTUSER           VARCHAR2(20) not null,
  CHECKUSER           VARCHAR2(20),
  GRANTUSER           VARCHAR2(20),
  DISTRIBUTOR_CODE    VARCHAR2(14),
  ACCT_NO             VARCHAR2(32),
  SUB_ACCT_NO         VARCHAR2(32),
  MATCH_ACCT_NO       VARCHAR2(32),
  CUST_NO             VARCHAR2(20),
  FNC_TRANS_ACCT_NO   VARCHAR2(17),
  SELF_FNC_ACCT_NO    VARCHAR2(12),
  CUST_NAME           VARCHAR2(128),
  ID_TYPE             VARCHAR2(8),
  ID_CODE             VARCHAR2(32),
  HOST_ID_TYPE        VARCHAR2(8),
  CUST_TYPE           VARCHAR2(8),
  CUST_LEVEL          VARCHAR2(8),
  AGENT_NAME          VARCHAR2(128),
  AGENT_ID_TYPE       VARCHAR2(8),
  AGENT_ID_CODE       VARCHAR2(32),
  RISK_MATCH_FLAG     VARCHAR2(1),
  CUST_RISK_LEVEL     VARCHAR2(1),
  PROD_RISK_LEVEL     VARCHAR2(1),
  PROD_CODE           VARCHAR2(32) not null,
  PROD_CHILD_NO       NUMBER(8),
  NAV                 NUMBER(12,6),
  CUR                 VARCHAR2(8),
  APP_AMT             NUMBER(16,2),
  APP_VOL             NUMBER(16,2),
  ACK_AMT             NUMBER(16,2),
  ACK_VOL             NUMBER(16,2),
  DISCOUNT            NUMBER(7,4),
  FEEAMT              NUMBER(16,2),
  BACK_FEE            NUMBER(16,2),
  REDEEM_FEE          NUMBER(16,2),
  INTEREST            NUMBER(16,2),
  INTEREST_TAX        NUMBER(16,2),
  CUST_MANAGER        VARCHAR2(20),
  FM_MANAGER          VARCHAR2(20),
  ORI_TRANS_SERNO     VARCHAR2(32),
  FROZEN_CAUSE        VARCHAR2(1),
  CONTRACT_NO         VARCHAR2(32),
  ELISOR_NAME         VARCHAR2(128),
  FROZEN_ENDDATE      CHAR(8),
  ORI_DIV_METHOD      VARCHAR2(1),
  DIV_METHOD          VARCHAR2(1),
  HAERES_DEPOSIT_ACCT VARCHAR2(32),
  BUYPLAN_NO          VARCHAR2(16),
  SHOULD_EXEC_DATE    CHAR(8),
  ACK_DATE            CHAR(8),
  TRANS_DATE          CHAR(8) not null,
  CAPITAL_STATUS      VARCHAR2(1) not null,
  TRANS_STATUS        VARCHAR2(1) not null,
  RTN_CODE            VARCHAR2(12),
  RTN_DESC            VARCHAR2(255),
  HOST_CODE           VARCHAR2(12),
  HOST_DESC           VARCHAR2(255),
  HOST_TRANS_SERNO    VARCHAR2(32),
  FREEZE_SERNO        VARCHAR2(32),
  CHK_STATUS          VARCHAR2(1) not null,
  CHK_DATE            CHAR(8),
  CERT_SERNO          CHAR(8),
  PRINT_NO            NUMBER(8)  not null,
  REMARK              VARCHAR2(255),
  UPD_DATE            CHAR(8) not null,
  UPD_TIME            CHAR(6) not null,
  CARD_TYPE           VARCHAR2(8),
  CARD_NO             VARCHAR2(32),
  IN_CARD_TYPE        VARCHAR2(8),
  IN_CARD_NO          VARCHAR2(32),
  IN_ACCT_NO          VARCHAR2(32),
  IN_AGENT_NAME       VARCHAR2(128),
  IN_AGENT_ID_TYPE    VARCHAR2(8),
  IN_AGENT_ID_CODE    VARCHAR2(32),
  IN_CUST_NAME        VARCHAR2(128),
  IN_ID_TYPE          VARCHAR2(8),
  IN_ID_CODE          VARCHAR2(32),
  TRANS_DEAL_IP       VARCHAR2(128),
  CHANNEL_IP          VARCHAR2(128),
  CHANNEL_MAC         VARCHAR2(64),
  NEW_CUST_FLAG       VARCHAR2(1),
  RECOMM_PPL          VARCHAR2(15),
  SPECIAL_CODE        VARCHAR2(8),
  FUND_MODE           VARCHAR2(1),
  HUGEREDEEMFLAG      VARCHAR2(1),
  HOST_DATE           CHAR(8),
  BUSI_TYPE           VARCHAR2(1),
  BACKUP_DATE         CHAR(8),
  INCOME              NUMBER(16,2),
  ryzd                varchar(1) NULL
);
comment on table FMS_T5_CUST_TRANS_LOG
  is '客户交易流水表';
-- Add comments to the columns 
comment on column FMS_T5_CUST_TRANS_LOG.TRANS_SERNO
  is '交易流水号';
comment on column FMS_T5_CUST_TRANS_LOG.SYS_MBT
  is '交易编码';
comment on column FMS_T5_CUST_TRANS_LOG.BUSI_CODE
  is '业务代码';
comment on column FMS_T5_CUST_TRANS_LOG.CHANNEL_FLAG
  is '渠道标识';
comment on column FMS_T5_CUST_TRANS_LOG.CHANNEL_DATE
  is '渠道日期';
comment on column FMS_T5_CUST_TRANS_LOG.CHANNEL_TIME
  is '渠道时间';
comment on column FMS_T5_CUST_TRANS_LOG.CHANNEL_SERNO
  is '渠道流水号';
comment on column FMS_T5_CUST_TRANS_LOG.MACDATE
  is '机器日期';
comment on column FMS_T5_CUST_TRANS_LOG.MACTIME
  is '机器时间';
comment on column FMS_T5_CUST_TRANS_LOG.BANK_CODE
  is '交易总行代码';
comment on column FMS_T5_CUST_TRANS_LOG.BRANCH_CODE
  is '交易分行代码';
comment on column FMS_T5_CUST_TRANS_LOG.SUB_BRANCH_CODE
  is '支行网点代码';
comment on column FMS_T5_CUST_TRANS_LOG.INPUTUSER
  is '录入柜员';
comment on column FMS_T5_CUST_TRANS_LOG.CHECKUSER
  is '复核用户';
comment on column FMS_T5_CUST_TRANS_LOG.GRANTUSER
  is '授权用户';
comment on column FMS_T5_CUST_TRANS_LOG.DISTRIBUTOR_CODE
  is '销售商代码';
comment on column FMS_T5_CUST_TRANS_LOG.ACCT_NO
  is '银行账号';
comment on column FMS_T5_CUST_TRANS_LOG.SUB_ACCT_NO
  is '子银行账号';
comment on column FMS_T5_CUST_TRANS_LOG.MATCH_ACCT_NO
  is '对手银行账号';
comment on column FMS_T5_CUST_TRANS_LOG.CUST_NO
  is '客户号';
comment on column FMS_T5_CUST_TRANS_LOG.FNC_TRANS_ACCT_NO
  is '理财交易账号';
comment on column FMS_T5_CUST_TRANS_LOG.SELF_FNC_ACCT_NO
  is '自有理财业务账号';
comment on column FMS_T5_CUST_TRANS_LOG.CUST_NAME
  is '客户名称';
comment on column FMS_T5_CUST_TRANS_LOG.ID_TYPE
  is '证件类型';
comment on column FMS_T5_CUST_TRANS_LOG.ID_CODE
  is '证件号码';
comment on column FMS_T5_CUST_TRANS_LOG.HOST_ID_TYPE
  is '主机证件类型;（;0：身份证 1：护照 2：军官证 3：士兵证 4：回乡证 5：户口本 6：外国护照 7：其它 8：无 A：技术监督局代码 B：营业执照 C：行政机关 D：社会团体 E；军队 F：武警 G：下属机构（具有主管单位批文号） H：基金会 ）';
comment on column FMS_T5_CUST_TRANS_LOG.CUST_TYPE
  is '客户类型';
comment on column FMS_T5_CUST_TRANS_LOG.CUST_LEVEL
  is '客户级别';
comment on column FMS_T5_CUST_TRANS_LOG.AGENT_NAME
  is '经办(代理)人姓名';
comment on column FMS_T5_CUST_TRANS_LOG.AGENT_ID_TYPE
  is '经办(代理)人证件类型';
comment on column FMS_T5_CUST_TRANS_LOG.AGENT_ID_CODE
  is '经办(代理)人证件号码';
comment on column FMS_T5_CUST_TRANS_LOG.RISK_MATCH_FLAG
  is '是否匹配风险评估;（;Y：是 N：否 ）';
comment on column FMS_T5_CUST_TRANS_LOG.CUST_RISK_LEVEL
  is '客户风险等级;（;0：极低 1：低 2：中 3：高 4：极高 ）';
comment on column FMS_T5_CUST_TRANS_LOG.PROD_RISK_LEVEL
  is '产品风险等级;（;0：极低 1：低 2：中 3：高 4：极高 ）';
comment on column FMS_T5_CUST_TRANS_LOG.PROD_CODE
  is '产品代码';
comment on column FMS_T5_CUST_TRANS_LOG.PROD_CHILD_NO
  is '产品子序号;（新建产品信息一律填0;滚存型自动增加）';
comment on column FMS_T5_CUST_TRANS_LOG.NAV
  is '净值';
comment on column FMS_T5_CUST_TRANS_LOG.CUR
  is '币种';
comment on column FMS_T5_CUST_TRANS_LOG.APP_AMT
  is '申请金额';
comment on column FMS_T5_CUST_TRANS_LOG.APP_VOL
  is '申请份额';
comment on column FMS_T5_CUST_TRANS_LOG.ACK_AMT
  is '确认金额';
comment on column FMS_T5_CUST_TRANS_LOG.ACK_VOL
  is '确认份额';
comment on column FMS_T5_CUST_TRANS_LOG.DISCOUNT
  is '折扣率';
comment on column FMS_T5_CUST_TRANS_LOG.FEEAMT
  is '手续费金额';
comment on column FMS_T5_CUST_TRANS_LOG.BACK_FEE
  is '后收手续费';
comment on column FMS_T5_CUST_TRANS_LOG.REDEEM_FEE
  is '赎回费';
comment on column FMS_T5_CUST_TRANS_LOG.INTEREST
  is '利息';
comment on column FMS_T5_CUST_TRANS_LOG.INTEREST_TAX
  is '利息税;(扣款模式下由本系统计息时使用)';
comment on column FMS_T5_CUST_TRANS_LOG.CUST_MANAGER
  is '客户经理代码';
comment on column FMS_T5_CUST_TRANS_LOG.FM_MANAGER
  is '理财经理代码';
comment on column FMS_T5_CUST_TRANS_LOG.ORI_TRANS_SERNO
  is '原交易流水号';
comment on column FMS_T5_CUST_TRANS_LOG.FROZEN_CAUSE
  is '冻结原因;（0：司法冻结1：质押）';
comment on column FMS_T5_CUST_TRANS_LOG.CONTRACT_NO
  is '文案号';
comment on column FMS_T5_CUST_TRANS_LOG.ELISOR_NAME
  is '司法名称';
comment on column FMS_T5_CUST_TRANS_LOG.FROZEN_ENDDATE
  is '冻结截止日期';
comment on column FMS_T5_CUST_TRANS_LOG.ORI_DIV_METHOD
  is '原分红方式';
comment on column FMS_T5_CUST_TRANS_LOG.DIV_METHOD
  is '分红方式';
comment on column FMS_T5_CUST_TRANS_LOG.HAERES_DEPOSIT_ACCT
  is '承接方银行结算账号';
comment on column FMS_T5_CUST_TRANS_LOG.BUYPLAN_NO
  is '自动理财协议号';
comment on column FMS_T5_CUST_TRANS_LOG.SHOULD_EXEC_DATE
  is '应执行日期';
comment on column FMS_T5_CUST_TRANS_LOG.ACK_DATE
  is '确认日期';
comment on column FMS_T5_CUST_TRANS_LOG.TRANS_DATE
  is '业务日期';
comment on column FMS_T5_CUST_TRANS_LOG.CAPITAL_STATUS
  is '资金状态;（0、未处理1、已冻结2、冻结失败3、扣款成功4、扣款失败5、已冲正6、还款成功7、还款失败8、已解冻9、解冻失败A、冲正失败）';
comment on column FMS_T5_CUST_TRANS_LOG.TRANS_STATUS
  is '交易状态;（U-未处理;B-核心超时;0-申请成功;1-申请失败;2-已撤单;3-确认成功;4-确认失败）';
comment on column FMS_T5_CUST_TRANS_LOG.RTN_CODE
  is '返回编码';
comment on column FMS_T5_CUST_TRANS_LOG.RTN_DESC
  is '返回信息';
comment on column FMS_T5_CUST_TRANS_LOG.HOST_CODE
  is '主机返回码';
comment on column FMS_T5_CUST_TRANS_LOG.HOST_DESC
  is '主机返回信息';
comment on column FMS_T5_CUST_TRANS_LOG.HOST_TRANS_SERNO
  is '主机流水号';
comment on column FMS_T5_CUST_TRANS_LOG.FREEZE_SERNO
  is '冻结编号（主机）';
comment on column FMS_T5_CUST_TRANS_LOG.CHK_STATUS
  is '对账状态;(0-未对账；1-对账相符；2-对账不符；3-已调账；N-不需要对账)';
comment on column FMS_T5_CUST_TRANS_LOG.CHK_DATE
  is '对账日期';
comment on column FMS_T5_CUST_TRANS_LOG.CERT_SERNO
  is '凭证序号';
comment on column FMS_T5_CUST_TRANS_LOG.PRINT_NO
  is '打印次数;（0表示未打印）';
comment on column FMS_T5_CUST_TRANS_LOG.REMARK
  is '备注';
comment on column FMS_T5_CUST_TRANS_LOG.UPD_DATE
  is '更新日期';
comment on column FMS_T5_CUST_TRANS_LOG.UPD_TIME
  is '更新时间';
comment on column FMS_T5_CUST_TRANS_LOG.CARD_TYPE
  is '介质类型';
comment on column FMS_T5_CUST_TRANS_LOG.CARD_NO
  is '介质号码';
comment on column FMS_T5_CUST_TRANS_LOG.IN_CARD_TYPE
  is '转入方介质类型';
comment on column FMS_T5_CUST_TRANS_LOG.IN_CARD_NO
  is '转入方介质号';
comment on column FMS_T5_CUST_TRANS_LOG.IN_ACCT_NO
  is '转入方账号';
comment on column FMS_T5_CUST_TRANS_LOG.IN_AGENT_NAME
  is '转入方经办人名称';
comment on column FMS_T5_CUST_TRANS_LOG.IN_AGENT_ID_TYPE
  is '转入方经办人证件类型';
comment on column FMS_T5_CUST_TRANS_LOG.IN_AGENT_ID_CODE
  is '转入方经办人证件号码';
comment on column FMS_T5_CUST_TRANS_LOG.IN_CUST_NAME
  is '转入方客户名称';
comment on column FMS_T5_CUST_TRANS_LOG.IN_ID_TYPE
  is '输入方证件类型';
comment on column FMS_T5_CUST_TRANS_LOG.IN_ID_CODE
  is '输入方证件号码';
comment on column FMS_T5_CUST_TRANS_LOG.TRANS_DEAL_IP
  is '交易处理ip';
comment on column FMS_T5_CUST_TRANS_LOG.CHANNEL_IP
  is '渠道IP';
comment on column FMS_T5_CUST_TRANS_LOG.CHANNEL_MAC
  is '渠道mac';
comment on column FMS_T5_CUST_TRANS_LOG.NEW_CUST_FLAG
  is '新客标识;（0：新客;1：老客）';
comment on column FMS_T5_CUST_TRANS_LOG.RECOMM_PPL
  is '直销推荐人';
comment on column FMS_T5_CUST_TRANS_LOG.SPECIAL_CODE
  is '尊享码标识;（0..无;1..尊享码客户）';
comment on column FMS_T5_CUST_TRANS_LOG.FUND_MODE
  is '资金处理模式';
comment on column FMS_T5_CUST_TRANS_LOG.HUGEREDEEMFLAG
  is '巨额赎回处理标志;:0-取消;1-顺延';
comment on column FMS_T5_CUST_TRANS_LOG.HOST_DATE
  is '主机交易日期';
comment on column FMS_T5_CUST_TRANS_LOG.BUSI_TYPE
  is '业务类型;:0-还款;1-扣款;2-冻结;3-解冻;4-解冻并扣款;5-冲正';
comment on column FMS_T5_CUST_TRANS_LOG.BACKUP_DATE
  is '备份日期';
comment on column FMS_T5_CUST_TRANS_LOG.INCOME
  is '收益';