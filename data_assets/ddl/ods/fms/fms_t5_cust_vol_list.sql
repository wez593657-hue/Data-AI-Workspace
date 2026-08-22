-- Create table
create table FMS_T5_CUST_VOL_LIST
(
  TRANS_SERNO       VARCHAR2(32) not null,
  TRANS_DATE        CHAR(8) not null,
  ACK_DATE          CHAR(8) not null,
  BUSI_CODE         VARCHAR2(6),
  DISTRIBUTOR_CODE  VARCHAR2(14) default '0',
  FNC_TRANS_ACCT_NO VARCHAR2(42) not null,
  PROD_CODE         VARCHAR2(32) not null,
  SELF_FNC_ACCT_NO  VARCHAR2(12),
  CUST_NO           VARCHAR2(42) not null,
  CHANNEL_FLAG      VARCHAR2(3) not null,
  VOL               NUMBER(16,2) not null,
  BUY_NAV           NUMBER(12,6),
  BANK_CODE         VARCHAR2(20) not null,
  BRANCH_CODE       VARCHAR2(20) not null,
  SUB_BRANCH_CODE   VARCHAR2(20) not null,
  CUST_MANAGER      VARCHAR2(20),
  FM_MANAGER        VARCHAR2(20),
  CRT_DATE          CHAR(8) not null,
  CRT_TIME          CHAR(6) not null,
  REMARK            VARCHAR2(255),
  UPD_DATE          CHAR(8) not null,
  UPD_TIME          CHAR(6) not null,
  NEW_CUST_FLAG     VARCHAR2(1),
  SPECIAL_CODE      VARCHAR2(1),
  REMAIN_VOL        NUMBER(16,2) not null,
  USE_VOL           NUMBER(16,2) not null,
  FROZEN_VOL        NUMBER(16,2) not null,
  ELISOR_FROZEN_VOL NUMBER(16,2) not null,
  REDEEM_FROZEN_VOL NUMBER(16,2) not null,
  CONVERT_INCOME    NUMBER(20,6) not null,
  ACCRUED_INCOME    NUMBER(20,6) not null,
  CLOSE_END_DATE    CHAR(8),
  CONTRACT_NO       VARCHAR2(42),
  ELISOR_NAME       VARCHAR2(300),
  DEPOSIT_ACCT      VARCHAR2(42),
  BUY_AMT           NUMBER(16,2) not null,
  JUDICIAL_ORGAN    VARCHAR2(42),
  FROZEN_ENDDATE    CHAR(8)
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
comment on table FMS_T5_CUST_VOL_LIST
  is '客户份额明细表';
-- Add comments to the columns 
comment on column FMS_T5_CUST_VOL_LIST.TRANS_SERNO
  is '买入流水号';
comment on column FMS_T5_CUST_VOL_LIST.TRANS_DATE
  is '业务日期';
comment on column FMS_T5_CUST_VOL_LIST.ACK_DATE
  is '确认日期';
comment on column FMS_T5_CUST_VOL_LIST.BUSI_CODE
  is '业务代码';
comment on column FMS_T5_CUST_VOL_LIST.DISTRIBUTOR_CODE
  is '销售商代码（本行销售填0）';
comment on column FMS_T5_CUST_VOL_LIST.FNC_TRANS_ACCT_NO
  is '理财账号';
comment on column FMS_T5_CUST_VOL_LIST.PROD_CODE
  is '产品代码';
comment on column FMS_T5_CUST_VOL_LIST.SELF_FNC_ACCT_NO
  is '自有理财业务账号';
comment on column FMS_T5_CUST_VOL_LIST.CUST_NO
  is '客户号';
comment on column FMS_T5_CUST_VOL_LIST.CHANNEL_FLAG
  is '交易渠道';
comment on column FMS_T5_CUST_VOL_LIST.VOL
  is '确认份额';
comment on column FMS_T5_CUST_VOL_LIST.BUY_NAV
  is '确认净值';
comment on column FMS_T5_CUST_VOL_LIST.BANK_CODE
  is '交易总行代码';
comment on column FMS_T5_CUST_VOL_LIST.BRANCH_CODE
  is '交易分行代码';
comment on column FMS_T5_CUST_VOL_LIST.SUB_BRANCH_CODE
  is '支行网点代码';
comment on column FMS_T5_CUST_VOL_LIST.CUST_MANAGER
  is '客户经理代码';
comment on column FMS_T5_CUST_VOL_LIST.FM_MANAGER
  is '理财经理代码';
comment on column FMS_T5_CUST_VOL_LIST.CRT_DATE
  is '创建日期';
comment on column FMS_T5_CUST_VOL_LIST.CRT_TIME
  is '创建时间';
comment on column FMS_T5_CUST_VOL_LIST.REMARK
  is '备注';
comment on column FMS_T5_CUST_VOL_LIST.UPD_DATE
  is '更新日期';
comment on column FMS_T5_CUST_VOL_LIST.UPD_TIME
  is '更新时间';
comment on column FMS_T5_CUST_VOL_LIST.NEW_CUST_FLAG
  is '新客标识（0：新客;1：老客）';
comment on column FMS_T5_CUST_VOL_LIST.SPECIAL_CODE
  is '尊享码标识（0..无;1..尊享码客户）';
comment on column FMS_T5_CUST_VOL_LIST.REMAIN_VOL
  is '剩余份额';
comment on column FMS_T5_CUST_VOL_LIST.USE_VOL
  is '可用份额;=剩余份额-;质押冻结 -司法冻结-赎回冻结';
comment on column FMS_T5_CUST_VOL_LIST.FROZEN_VOL
  is '质押冻结份额';
comment on column FMS_T5_CUST_VOL_LIST.ELISOR_FROZEN_VOL
  is '司法冻结份额';
comment on column FMS_T5_CUST_VOL_LIST.REDEEM_FROZEN_VOL
  is '赎回冻结';
comment on column FMS_T5_CUST_VOL_LIST.CONVERT_INCOME
  is '已结转收益;累计值';
comment on column FMS_T5_CUST_VOL_LIST.ACCRUED_INCOME
  is '已计提收益;用于收益计题使用;将每工作日计算收益减去已计提收益得到当日计提值，再将当日计提值累加到已计提收益里';
comment on column FMS_T5_CUST_VOL_LIST.CLOSE_END_DATE
  is '封闭截止日;对于开放式设置了客户封闭期的产品;确认时填入封闭截止日';
comment on column FMS_T5_CUST_VOL_LIST.CONTRACT_NO
  is '文案号';
comment on column FMS_T5_CUST_VOL_LIST.ELISOR_NAME
  is '司法名称';
comment on column FMS_T5_CUST_VOL_LIST.DEPOSIT_ACCT
  is '保证金账号';
comment on column FMS_T5_CUST_VOL_LIST.BUY_AMT
  is '购买金额';
comment on column FMS_T5_CUST_VOL_LIST.JUDICIAL_ORGAN
  is '司法机构';
comment on column FMS_T5_CUST_VOL_LIST.FROZEN_ENDDATE
  is '质押截止日期';