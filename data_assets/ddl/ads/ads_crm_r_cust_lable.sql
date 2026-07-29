/*
 * ADS_CRM_R_CUST_LABLE
 * 中文名称: 对私客户标签表
 * 版本: v1.1.0
 * 创建时间: 2026-07-29
 * 变更: v1.1.0 移除DATA_DATE字段（用户确认），全量快照模式
 * 来源: Mapping Excel (ADS应用层数据模型)
 */

CREATE TABLE IF NOT EXISTS ADS_CRM_R_CUST_LABLE (
    PERSN_LEGAL_BK_CODE                    VARCHAR2, -- 法人行号
    CUST_ID                                VARCHAR2, -- 核心客户号
    CUST_NAME                              VARCHAR2, -- 客户名称
    CERT_TYP                               VARCHAR2, -- 证件类型
    CERT_ID                                VARCHAR2, -- 证件号码
    GEND                                   VARCHAR2, -- 性别
    AGE                                    NUMBER  , -- 年龄
    NATION                                 VARCHAR2, -- 民族
    MARI_SITU                              VARCHAR2, -- 婚姻状况
    PHONE_NO                               VARCHAR2, -- 手机号码
    MAX_DEG_EDU                            VARCHAR2, -- 最高学历
    OCCU_CLS                               VARCHAR2, -- 职业分类
    HOST_CUST_MNGR_POST_ID                 VARCHAR2, -- 主办客户经理职位编号
    HOST_CUST_MNGR_NAME                    VARCHAR2, -- 主办客户经理名称
    HOST_CUST_MNGR_EMP_ID                  VARCHAR2, -- 主办客户经理工号
    ORG_LEAD                               VARCHAR2, -- 主办机构(归属机构)
    ORG_LEAD_PATH                          VARCHAR2, -- 主办机构路径
    COSPSR_CUST_MNGR_POST_ID               VARCHAR2, -- 信贷客户经理职位编号
    COSPSR_CUST_MNGR_NAME                  VARCHAR2, -- 信贷客户经理名称
    COSPSR_CUST_MNGR_EMP_ID                VARCHAR2, -- 信贷客户经理工号
    COSPSR_ORG                             VARCHAR2, -- 信贷机构
    COSPSR_ORG_PATH                        VARCHAR2, -- 信贷机构路径
    IS_NOT_INDIV_BIZ_ACCT                  VARCHAR2, -- 是否一码付商户
    IS_NOT_MINOR_ENTER_MAIN                VARCHAR2, -- 是否小微企业主
    NEAR_YR_HF_AVG_MTH_INCOM               NUMBER  , -- 近半年月均收入
    INDIV_ESTIM_YR_INCOM                   NUMBER  , -- 个人年收入
    FUND_ACUM_DEPO_NUM_BASE                NUMBER  , -- 公积金缴存基数
    SOCIAL_WELF_PAY_NUM_BASE               NUMBER  , -- 社保缴存基数
    IS_NOT_PURE_NEW_CUST                   VARCHAR2, -- 纯新户开户标志
    IS_NOT_BK_SELF_EMP                     VARCHAR2, -- 是否本行员工
    IS_NOT_SLEEP_ACCT                      VARCHAR2, -- 是否睡眠户
    CUST_HRAKY                             VARCHAR2, -- 客户层级
    CUST_LVL                               VARCHAR2, -- 客户等级
    LIFE_CYC                               VARCHAR2, -- 生命周期
    AUM                                    NUMBER  , -- AUM余额
    AUM_MTH_AVG                            NUMBER  , -- AUM月日均
    AUM_QRT_AVG                            NUMBER  , -- AUM季日均
    AUM_YR_AVG                             NUMBER  , -- AUM年日均
    IS_NOT_DEPO                            CHAR    , -- 是否持有存款产品
    DEPO_BAL                               NUMBER  , -- 存款余额
    DEPO_MTH_AVG                           NUMBER  , -- 存款月日均
    DEPO_QRT_AVG                           NUMBER  , -- 存款季日均
    DEPO_YR_AVG                            NUMBER  , -- 存款年日均
    DEPO_CURNT_DEPO_BAL                    NUMBER  , -- 活期存款余额
    DEPO_CURNT_DEPO_BAL_MTH_CURNT_AVG_DAY  NUMBER  , -- 活期存款日均余额
    IS_NOT_HIST_FIXD_DEPO_FLAG             VARCHAR2, -- 是否历史持有定期存款产品
    IS_NOT_FIXD_DEPO                       VARCHAR2, -- 是否持有定期存款产品
    FIX_DEPO_BAL                           NUMBER  , -- 定期存款余额
    FIX_DEPO_MTH_AVG                       NUMBER  , -- 定期存款月日均
    FIX_DEPO_QRT_AVG                       NUMBER  , -- 定期存款季日均
    FIX_DEPO_YR_AVG                        NUMBER  , -- 定期存款年日均
    IS_NOT_HIST_LUMPSUM_FIXD_FLAG          VARCHAR2, -- 是否历史持有整存整取定期存款
    IS_NOT_LUMPSUM_FIXD                    VARCHAR2, -- 是否持有整存整取定期存款
    LUMPSUM_FIXD_DEPO_BAL                  NUMBER  , -- 整存整取定期存款余额
    IS_NOT_HIST_LEHUI_FLAG                 VARCHAR2, -- 是否历史持有乐惠存产品
    IS_NOT_LEHUI                           VARCHAR2, -- 是否持有乐惠存产品
    LEHUI_BAL                              NUMBER  , -- 乐惠存产品余额
    LEHUI_MTH_AVG_DAY                      NUMBER  , -- 乐惠存产品月日均余额
    RCNT_FIXD_DEPO_MATURE_DAYS             NUMBER  , -- 最近一笔定期存款到期天数
    RCNT_FIXD_DEPO_MATURE_AMT              NUMBER  , -- 最近一笔定期存款到期金额
    IS_NOT_HIST_LARGEDP_FLAG               VARCHAR2, -- 是否历史持有大额存单
    IS_NOT_LARGEDP                         VARCHAR2, -- 是否持有大额存单
    LARGEDP_BAL                            NUMBER  , -- 大额存单余额
    LARGEDP_MTH_AVG_DAY                    NUMBER  , -- 大额存单月日均余额
    IS_NOT_FIN_CTRAKT                      VARCHAR2, -- 是否理财签约
    IS_NOT_HIST_FIN_FLAG                   VARCHAR2, -- 是否历史持有理财产品
    IS_NOT_FIN                             VARCHAR2, -- 是否持有理财产品
    RCNT_FIN_MATURE_DAYS                   NUMBER  , -- 最近一笔理财到期天数
    RCNT_FIN_MATURE_AMT                    NUMBER  , -- 最近一笔理财到期金额
    FIN_AMT                                NUMBER  , -- 理财余额
    FIN_MTH_AVG                            NUMBER  , -- 理财月日均
    FIN_QRT_AVG                            NUMBER  , -- 理财季日均
    FIN_YR_AVG                             NUMBER  , -- 理财年日均
    IS_NOT_HIST_OPEN_FIN_FLAG              VARCHAR2, -- 是否历史持有开放式理财产品
    IS_NOT_OPEN_FIN                        VARCHAR2, -- 是否持有开放式理财产品
    OPEN_FIN_BAL                           NUMBER  , -- 开放式理财产品余额
    OPEN_FIN_MTH_AVG_DAY                   NUMBER  , -- 开放式理财产品月日均余额
    IS_NOT_HIST_CLOSE_FIN_FLAG             VARCHAR2, -- 是否历史持有封闭式理财产品
    IS_NOT_CLOSE_FIN                       VARCHAR2, -- 是否持有封闭式理财产品
    CLOSE_FIN_BAL                          NUMBER  , -- 封闭式理财产品余额
    CLOSE_FIN_MTH_AVG_DAY                  NUMBER  , -- 封闭式理财产品月日均余额
    IS_NOT_HIST_AGT_FIN_FLAG               VARCHAR2, -- 是否历史持有代销理财产品
    IS_NOT_AGT_FIN                         VARCHAR2, -- 是否持有代销理财产品
    AGT_FIN_BAL                            NUMBER  , -- 代销理财产品余额
    AGT_FIN_MTH_AVG_DAY                    NUMBER  , -- 代销理财产品月日均余额
    IS_NOT_LOAN_CUST                       VARCHAR2, -- 是否贷款客户
    IS_NOT_HIST_LOAN_FLAG                  VARCHAR2, -- 是否历史贷款客户
    LOAN_BAL                               NUMBER  , -- 贷款余额
    IS_NOT_PAYROL_BK                       VARCHAR2, -- 是否代发户
    IS_NOT_SALRY_PAYROL_BK                 VARCHAR2, -- 是否代发工资客户
    BK_SALRY_AMT_MTH_LAST                  NUMBER  , -- 上月代发工资金额
    RCNT_TIME_ONE_PAYROL_BK_SALRY_DATE     DATE    , -- 最近一次代发工资日期
    PAYROL_BK_SALRY_AMT                    NUMBER  , -- 最近一次代发工资金额
    PAYROL_SALRY_TTL                       NUMBER  , -- 代发工资累计金额
    CONTI_PAYROL_BK_MTHS                   NUMBER  , -- 连续稳定代发工资月数
    DCARD_TYPE                             VARCHAR2, -- 借记卡类型
    IS_NOT_BK_SELF_SSCARD                  CHAR    , -- 是否我行社保卡
    IS_NOT_BK_SELF_CGZJ                    CHAR    , -- 是否我行川工之家客户
    CGZJ_ACCT_WELF_BAL                     NUMBER  , -- 川工之家账户福利资金余额
    IS_NOT_SELF_REG_MBANK                  CHAR    , -- 是否自助注册手机银行
    IS_NOT_KTER_CTRAKT_MBANK               CHAR    , -- 是否柜面签约手机银行
    NEAR_MTH_TX_CNT                        NUMBER  , -- 近1月累计交易笔数
    NEAR_MTH_TX_AMT                        NUMBER  , -- 近1月累计交易金额
    NEAR_MTH_MBANK_TX_CNT                  NUMBER  , -- 近1月手机银行累计交易笔数
    NEAR_MTH_MBANK_TX_AMT                  NUMBER  , -- 近1月手机银行累计交易金额
    NEAR_MTH_MBANK_TX_AMT_BK_OUTER         NUMBER  , -- 近1月手机银行行外入账金额
    IS_NOT_SFZF                            CHAR    , -- 是否签约三方支付
    NEAR_MTH_THIRD_PAY_OUT_CNT             NUMBER  , -- 近1月第三方支付累计转出笔数
    NEAR_MTH_THIRD_PAY_OUT_AMT             NUMBER  , -- 近1月第三方支付累计转出金额
    IS_NOT_BILL_RSV_MINOR_MKNT             CHAR    , -- 是否收单商户小微商户
    IS_NOT_BILL_RSV_INDIV_MKNT             CHAR    , -- 是否收单商户个体商户
    BILL_RSV_MKNT_CNT_MTH_LAST             NUMBER  , -- 收单商户上月交易笔数
    BILL_RSV_MKNT_AMT_MTH_LAST             NUMBER  , -- 收单商户上月交易金额
    IS_NOT_BILL_RSV_VAL_MKNT               CHAR    , -- 是否收单价值商户
    IS_NOT_BK_SELF_FUND_PASS_BY_ACCT       CHAR    , -- 是否我行资金过路户
    IS_NOT_RGLAR_TRANS_BK_OTHER_SAMENAME   CHAR    , -- 是否向他行同名户规律转出
    MBANK_CONTI_LOGIN_DAYS                 NUMBER  , -- 连续登录手机银行天数
    IS_NOT_BK_PHONE_ACTV_CUST              CHAR    , -- 是否手机银行活跃客户
    IS_NOT_BK_SELF_LOAN_DUE_OVER_CUST      CHAR    , -- 行内贷款是否逾期
    NEAR_24MTH_OVERDUE_FLAG                CHAR    , -- 行内近24月内是否存在贷款逾期
    CRDT_DUE_OVER_CNT                      NUMBER  , -- 征信逾期次数
    EXIST_BADLOAN_REC                      CHAR    , -- 征信是否存在不良贷款记录
    IS_NOT_INSUR                           CHAR    , -- 是否持有保险产品
    INSUR_FRST_PREM_AMT                    NUMBER  , -- 保险产品首期保费
    INSUR_BAL                              NUMBER  , -- 保险余额
    INSUR_MTH_AVG                          NUMBER  , -- 保险月日均
    INSUR_QRT_AVG                          NUMBER  , -- 保险季日均
    INSUR_YR_AVG                           NUMBER  , -- 保险年日均
    NEAR_3_MTH_MIN_BENEFIT_LVL             VARCHAR2, -- 近三个月最低权益等级
    NEAR_6_MTH_MIN_BENEFIT_LVL             VARCHAR2, -- 近六个月最低权益等级
    NEAR_9_MTH_MIN_BENEFIT_LVL             VARCHAR2, -- 近九个月最低权益等级
    NEAR_12_MTH_MIN_BENEFIT_LVL            VARCHAR2, -- 近十二个月最低权益等级
    IS_NOT_YR_FRST_LVL_UPG_CUST            CHAR    , -- 是否当年首次等级升级客户
    FRST_UPG_CUST_UPG_LVL                  VARCHAR2, -- 首次升级客户升级等级
    IS_NOT_YR_LVL_DWN_CUST                 CHAR    , -- 是否当年等级降级客户
    DWN_CUST_LVL_BF_AF                     VARCHAR2, -- 降级客户降级前后等级
    IS_NOT_HIGH_WORTH_CRIT_CUST            CHAR    , -- 是否为高净值临界客户
    IS_NOT_MBANK_BIND_CARD                 CHAR    , -- 是否登录手机银行并完成绑卡客户
    REG_LOGIN_BK_PHONE_CUST_DAYS           NUMBER  , -- 注册并登录手机银行客户的天数
    MTH_LOGIN_MBANK_CNT                    NUMBER  , -- 当月登录手机银行次数
    IS_NOT_3RD_PAY_BIND_CARD_DONE          CHAR    , -- 是否完成三方支付绑卡
    YR_CAMPUS_PAY_CNT                      NUMBER  , -- 当年校园缴费笔数
    YR_HOT_ACTV_CNT                        NUMBER  , -- 当年参与热门活动次数
    MTH_UTIL_PAY_TRAN_AMT                  NUMBER  , -- 当月完成水电气缴费交易金额
    MTH_UTIL_PAY_TRAN_CNT                  NUMBER  , -- 当月完成水电气缴费交易笔数
    TRAN_CHAN_PREF                         VARCHAR2, -- 交易渠道偏好
    IS_NOT_WECHAT_TRAN_MTH_ACTIVE          CHAR    , -- 是否为微信绑卡交易月活跃客户
    PRDKT_PREF                             VARCHAR2, -- 储蓄产品偏好
    VERIFIED_BADGE                         VARCHAR2, -- 企微客户认证标志
    DEPO_TERM_PREF                         VARCHAR2, -- 储蓄产品期限偏好
    IS_NOT_WB_LOAN                         VARCHAR2, -- 是否微粒贷客户
    IS_NOT_MT_LOAN                         VARCHAR2, -- 是否美团贷款客户
    ORG_PATH                               VARCHAR2, -- 机构路径
    CONTR_AMT                              NUMBER  , -- 总合同额度
    DCARD_LVL                              VARCHAR2  -- 借记卡等级
);

COMMENT ON TABLE ADS_CRM_R_CUST_LABLE IS '对私客户标签表';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.PERSN_LEGAL_BK_CODE IS '法人行号';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.CUST_ID IS '核心客户号';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.CUST_NAME IS '客户名称';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.CERT_TYP IS '证件类型';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.CERT_ID IS '证件号码';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.GEND IS '性别';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.AGE IS '年龄';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.NATION IS '民族';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.MARI_SITU IS '婚姻状况';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.PHONE_NO IS '手机号码';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.MAX_DEG_EDU IS '最高学历';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.OCCU_CLS IS '职业分类';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.HOST_CUST_MNGR_POST_ID IS '主办客户经理职位编号';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.HOST_CUST_MNGR_NAME IS '主办客户经理名称';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.HOST_CUST_MNGR_EMP_ID IS '主办客户经理工号';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.ORG_LEAD IS '主办机构(归属机构)';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.ORG_LEAD_PATH IS '主办机构路径';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.COSPSR_CUST_MNGR_POST_ID IS '信贷客户经理职位编号';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.COSPSR_CUST_MNGR_NAME IS '信贷客户经理名称';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.COSPSR_CUST_MNGR_EMP_ID IS '信贷客户经理工号';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.COSPSR_ORG IS '信贷机构';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.COSPSR_ORG_PATH IS '信贷机构路径';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.IS_NOT_INDIV_BIZ_ACCT IS '是否一码付商户';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.IS_NOT_MINOR_ENTER_MAIN IS '是否小微企业主';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.NEAR_YR_HF_AVG_MTH_INCOM IS '近半年月均收入';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.INDIV_ESTIM_YR_INCOM IS '个人年收入';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.FUND_ACUM_DEPO_NUM_BASE IS '公积金缴存基数';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.SOCIAL_WELF_PAY_NUM_BASE IS '社保缴存基数';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.IS_NOT_PURE_NEW_CUST IS '纯新户开户标志';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.IS_NOT_BK_SELF_EMP IS '是否本行员工';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.IS_NOT_SLEEP_ACCT IS '是否睡眠户';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.CUST_HRAKY IS '客户层级';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.CUST_LVL IS '客户等级';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.LIFE_CYC IS '生命周期';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.AUM IS 'AUM余额';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.AUM_MTH_AVG IS 'AUM月日均';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.AUM_QRT_AVG IS 'AUM季日均';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.AUM_YR_AVG IS 'AUM年日均';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.IS_NOT_DEPO IS '是否持有存款产品';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.DEPO_BAL IS '存款余额';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.DEPO_MTH_AVG IS '存款月日均';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.DEPO_QRT_AVG IS '存款季日均';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.DEPO_YR_AVG IS '存款年日均';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.DEPO_CURNT_DEPO_BAL IS '活期存款余额';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.DEPO_CURNT_DEPO_BAL_MTH_CURNT_AVG_DAY IS '活期存款日均余额';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.IS_NOT_HIST_FIXD_DEPO_FLAG IS '是否历史持有定期存款产品';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.IS_NOT_FIXD_DEPO IS '是否持有定期存款产品';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.FIX_DEPO_BAL IS '定期存款余额';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.FIX_DEPO_MTH_AVG IS '定期存款月日均';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.FIX_DEPO_QRT_AVG IS '定期存款季日均';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.FIX_DEPO_YR_AVG IS '定期存款年日均';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.IS_NOT_HIST_LUMPSUM_FIXD_FLAG IS '是否历史持有整存整取定期存款';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.IS_NOT_LUMPSUM_FIXD IS '是否持有整存整取定期存款';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.LUMPSUM_FIXD_DEPO_BAL IS '整存整取定期存款余额';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.IS_NOT_HIST_LEHUI_FLAG IS '是否历史持有乐惠存产品';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.IS_NOT_LEHUI IS '是否持有乐惠存产品';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.LEHUI_BAL IS '乐惠存产品余额';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.LEHUI_MTH_AVG_DAY IS '乐惠存产品月日均余额';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.RCNT_FIXD_DEPO_MATURE_DAYS IS '最近一笔定期存款到期天数';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.RCNT_FIXD_DEPO_MATURE_AMT IS '最近一笔定期存款到期金额';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.IS_NOT_HIST_LARGEDP_FLAG IS '是否历史持有大额存单';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.IS_NOT_LARGEDP IS '是否持有大额存单';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.LARGEDP_BAL IS '大额存单余额';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.LARGEDP_MTH_AVG_DAY IS '大额存单月日均余额';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.IS_NOT_FIN_CTRAKT IS '是否理财签约';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.IS_NOT_HIST_FIN_FLAG IS '是否历史持有理财产品';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.IS_NOT_FIN IS '是否持有理财产品';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.RCNT_FIN_MATURE_DAYS IS '最近一笔理财到期天数';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.RCNT_FIN_MATURE_AMT IS '最近一笔理财到期金额';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.FIN_AMT IS '理财余额';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.FIN_MTH_AVG IS '理财月日均';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.FIN_QRT_AVG IS '理财季日均';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.FIN_YR_AVG IS '理财年日均';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.IS_NOT_HIST_OPEN_FIN_FLAG IS '是否历史持有开放式理财产品';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.IS_NOT_OPEN_FIN IS '是否持有开放式理财产品';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.OPEN_FIN_BAL IS '开放式理财产品余额';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.OPEN_FIN_MTH_AVG_DAY IS '开放式理财产品月日均余额';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.IS_NOT_HIST_CLOSE_FIN_FLAG IS '是否历史持有封闭式理财产品';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.IS_NOT_CLOSE_FIN IS '是否持有封闭式理财产品';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.CLOSE_FIN_BAL IS '封闭式理财产品余额';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.CLOSE_FIN_MTH_AVG_DAY IS '封闭式理财产品月日均余额';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.IS_NOT_HIST_AGT_FIN_FLAG IS '是否历史持有代销理财产品';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.IS_NOT_AGT_FIN IS '是否持有代销理财产品';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.AGT_FIN_BAL IS '代销理财产品余额';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.AGT_FIN_MTH_AVG_DAY IS '代销理财产品月日均余额';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.IS_NOT_LOAN_CUST IS '是否贷款客户';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.IS_NOT_HIST_LOAN_FLAG IS '是否历史贷款客户';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.LOAN_BAL IS '贷款余额';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.IS_NOT_PAYROL_BK IS '是否代发户';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.IS_NOT_SALRY_PAYROL_BK IS '是否代发工资客户';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.BK_SALRY_AMT_MTH_LAST IS '上月代发工资金额';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.RCNT_TIME_ONE_PAYROL_BK_SALRY_DATE IS '最近一次代发工资日期';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.PAYROL_BK_SALRY_AMT IS '最近一次代发工资金额';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.PAYROL_SALRY_TTL IS '代发工资累计金额';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.CONTI_PAYROL_BK_MTHS IS '连续稳定代发工资月数';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.DCARD_TYPE IS '借记卡类型';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.IS_NOT_BK_SELF_SSCARD IS '是否我行社保卡';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.IS_NOT_BK_SELF_CGZJ IS '是否我行川工之家客户';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.CGZJ_ACCT_WELF_BAL IS '川工之家账户福利资金余额';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.IS_NOT_SELF_REG_MBANK IS '是否自助注册手机银行';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.IS_NOT_KTER_CTRAKT_MBANK IS '是否柜面签约手机银行';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.NEAR_MTH_TX_CNT IS '近1月累计交易笔数';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.NEAR_MTH_TX_AMT IS '近1月累计交易金额';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.NEAR_MTH_MBANK_TX_CNT IS '近1月手机银行累计交易笔数';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.NEAR_MTH_MBANK_TX_AMT IS '近1月手机银行累计交易金额';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.NEAR_MTH_MBANK_TX_AMT_BK_OUTER IS '近1月手机银行行外入账金额';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.IS_NOT_SFZF IS '是否签约三方支付';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.NEAR_MTH_THIRD_PAY_OUT_CNT IS '近1月第三方支付累计转出笔数';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.NEAR_MTH_THIRD_PAY_OUT_AMT IS '近1月第三方支付累计转出金额';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.IS_NOT_BILL_RSV_MINOR_MKNT IS '是否收单商户小微商户';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.IS_NOT_BILL_RSV_INDIV_MKNT IS '是否收单商户个体商户';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.BILL_RSV_MKNT_CNT_MTH_LAST IS '收单商户上月交易笔数';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.BILL_RSV_MKNT_AMT_MTH_LAST IS '收单商户上月交易金额';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.IS_NOT_BILL_RSV_VAL_MKNT IS '是否收单价值商户';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.IS_NOT_BK_SELF_FUND_PASS_BY_ACCT IS '是否我行资金过路户';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.IS_NOT_RGLAR_TRANS_BK_OTHER_SAMENAME IS '是否向他行同名户规律转出';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.MBANK_CONTI_LOGIN_DAYS IS '连续登录手机银行天数';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.IS_NOT_BK_PHONE_ACTV_CUST IS '是否手机银行活跃客户';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.IS_NOT_BK_SELF_LOAN_DUE_OVER_CUST IS '行内贷款是否逾期';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.NEAR_24MTH_OVERDUE_FLAG IS '行内近24月内是否存在贷款逾期';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.CRDT_DUE_OVER_CNT IS '征信逾期次数';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.EXIST_BADLOAN_REC IS '征信是否存在不良贷款记录';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.IS_NOT_INSUR IS '是否持有保险产品';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.INSUR_FRST_PREM_AMT IS '保险产品首期保费';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.INSUR_BAL IS '保险余额';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.INSUR_MTH_AVG IS '保险月日均';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.INSUR_QRT_AVG IS '保险季日均';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.INSUR_YR_AVG IS '保险年日均';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.NEAR_3_MTH_MIN_BENEFIT_LVL IS '近三个月最低权益等级';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.NEAR_6_MTH_MIN_BENEFIT_LVL IS '近六个月最低权益等级';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.NEAR_9_MTH_MIN_BENEFIT_LVL IS '近九个月最低权益等级';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.NEAR_12_MTH_MIN_BENEFIT_LVL IS '近十二个月最低权益等级';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.IS_NOT_YR_FRST_LVL_UPG_CUST IS '是否当年首次等级升级客户';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.FRST_UPG_CUST_UPG_LVL IS '首次升级客户升级等级';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.IS_NOT_YR_LVL_DWN_CUST IS '是否当年等级降级客户';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.DWN_CUST_LVL_BF_AF IS '降级客户降级前后等级';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.IS_NOT_HIGH_WORTH_CRIT_CUST IS '是否为高净值临界客户';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.IS_NOT_MBANK_BIND_CARD IS '是否登录手机银行并完成绑卡客户';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.REG_LOGIN_BK_PHONE_CUST_DAYS IS '注册并登录手机银行客户的天数';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.MTH_LOGIN_MBANK_CNT IS '当月登录手机银行次数';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.IS_NOT_3RD_PAY_BIND_CARD_DONE IS '是否完成三方支付绑卡';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.YR_CAMPUS_PAY_CNT IS '当年校园缴费笔数';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.YR_HOT_ACTV_CNT IS '当年参与热门活动次数';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.MTH_UTIL_PAY_TRAN_AMT IS '当月完成水电气缴费交易金额';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.MTH_UTIL_PAY_TRAN_CNT IS '当月完成水电气缴费交易笔数';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.TRAN_CHAN_PREF IS '交易渠道偏好';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.IS_NOT_WECHAT_TRAN_MTH_ACTIVE IS '是否为微信绑卡交易月活跃客户';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.PRDKT_PREF IS '储蓄产品偏好';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.VERIFIED_BADGE IS '企微客户认证标志';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.DEPO_TERM_PREF IS '储蓄产品期限偏好';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.IS_NOT_WB_LOAN IS '是否微粒贷客户';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.IS_NOT_MT_LOAN IS '是否美团贷款客户';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.ORG_PATH IS '机构路径';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.CONTR_AMT IS '总合同额度';
COMMENT ON COLUMN ADS_CRM_R_CUST_LABLE.DCARD_LVL IS '借记卡等级';

