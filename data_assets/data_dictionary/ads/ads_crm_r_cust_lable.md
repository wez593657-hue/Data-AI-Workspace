# ADS数据字典 - ADS_CRM_R_CUST_LABLE

## 表信息

| 属性 | 值 |
| --- | --- |
| 层级 | ADS - 应用数据层 |
| 表名 | ADS_CRM_R_CUST_LABLE |
| 中文名称 | 对私客户标签表 |
| 来源模型 | ADS应用层数据模型_CRM_ V1.0.xlsx / 对私客户标签表 |
| 更新时间 | 2026-07-29 |

## 字段列表

| 字段名 | 字段中文说明 | 数据类型 | 长度 | 是否为空 | 默认值 | 主键 | 外键 | 枚举说明 | 业务含义 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR2 | 4 | 【待确认】 | - | - | - | - | 法人行号 |
| CUST_ID | 核心客户号 | VARCHAR2 | 20 | 【待确认】 | - | - | - | - | 核心客户号 |
| CUST_NAME | 客户名称 | VARCHAR2 | 100 | 【待确认】 | - | - | - | - | 客户名称 |
| CERT_TYP | 证件类型 | VARCHAR2 | 6 | 【待确认】 | - | - | - | - | 证件类型 |
| CERT_ID | 证件号码 | VARCHAR2 | 40 | 【待确认】 | - | - | - | - | 证件号码 |
| GEND | 性别 | VARCHAR2 | 2 | 【待确认】 | - | - | - | - | 性别 |
| AGE | 年龄 | NUMBER | 5 | 【待确认】 | - | - | - | - | 年龄 |
| NATION | 民族 | VARCHAR2 | 30 | 【待确认】 | - | - | - | - | 民族 |
| MARI_SITU | 婚姻状况 | VARCHAR2 | 2 | 【待确认】 | - | - | - | - | 婚姻状况 |
| PHONE_NO | 手机号码 | VARCHAR2 | 30 | 【待确认】 | - | - | - | - | 手机号码 |
| MAX_DEG_EDU | 最高学历 | VARCHAR2 | 30 | 【待确认】 | - | - | - | - | 最高学历 |
| OCCU_CLS | 职业分类 | VARCHAR2 | 6 | 【待确认】 | - | - | - | - | 职业分类 |
| HOST_CUST_MNGR_POST_ID | 主办客户经理职位编号 | VARCHAR2 | 20 | 【待确认】 | - | - | - | - | 主办客户经理职位编号 |
| HOST_CUST_MNGR_NAME | 主办客户经理名称 | VARCHAR2 | 100 | 【待确认】 | - | - | - | - | 主办客户经理名称 |
| HOST_CUST_MNGR_EMP_ID | 主办客户经理工号 | VARCHAR2 | 6 | 【待确认】 | - | - | - | - | 主办客户经理工号 |
| ORG_LEAD | 主办机构(归属机构) | VARCHAR2 | 6 | 【待确认】 | - | - | - | - | 主办机构(归属机构) |
| ORG_LEAD_PATH | 主办机构路径 | VARCHAR2 | 30 | 【待确认】 | - | - | - | - | 主办机构路径 |
| COSPSR_CUST_MNGR_POST_ID | 信贷客户经理职位编号 | VARCHAR2 | 20 | 【待确认】 | - | - | - | - | 信贷客户经理职位编号 |
| COSPSR_CUST_MNGR_NAME | 信贷客户经理名称 | VARCHAR2 | 100 | 【待确认】 | - | - | - | - | 信贷客户经理名称 |
| COSPSR_CUST_MNGR_EMP_ID | 信贷客户经理工号 | VARCHAR2 | 6 | 【待确认】 | - | - | - | - | 信贷客户经理工号 |
| COSPSR_ORG | 信贷机构 | VARCHAR2 | 100 | 【待确认】 | - | - | - | - | 信贷机构 |
| COSPSR_ORG_PATH | 信贷机构路径 | VARCHAR2 | 300 | 【待确认】 | - | - | - | - | 信贷机构路径 |
| IS_NOT_INDIV_BIZ_ACCT | 是否一码付商户 | VARCHAR2 | 1 | 【待确认】 | - | - | - | - | 是否一码付商户 |
| IS_NOT_MINOR_ENTER_MAIN | 是否小微企业主 | VARCHAR2 | 1 | 【待确认】 | - | - | - | - | 是否小微企业主 |
| NEAR_YR_HF_AVG_MTH_INCOM | 近半年月均收入 | NUMBER | 20 | 【待确认】 | - | - | - | - | 近半年月均收入 |
| INDIV_ESTIM_YR_INCOM | 个人年收入 | NUMBER | 20 | 【待确认】 | - | - | - | - | 个人年收入 |
| FUND_ACUM_DEPO_NUM_BASE | 公积金缴存基数 | NUMBER | 20 | 【待确认】 | - | - | - | - | 公积金缴存基数 |
| SOCIAL_WELF_PAY_NUM_BASE | 社保缴存基数 | NUMBER | 20 | 【待确认】 | - | - | - | - | 社保缴存基数 |
| IS_NOT_PURE_NEW_CUST | 纯新户开户标志 | VARCHAR2 | 1 | 【待确认】 | - | - | - | - | 纯新户开户标志 |
| IS_NOT_BK_SELF_EMP | 是否本行员工 | VARCHAR2 | 1 | 【待确认】 | - | - | - | - | 是否本行员工 |
| IS_NOT_SLEEP_ACCT | 是否睡眠户 | VARCHAR2 | 1 | 【待确认】 | - | - | - | - | 是否睡眠户 |
| CUST_HRAKY | 客户层级 | VARCHAR2 | 2 | 【待确认】 | - | - | - | - | 客户层级 |
| CUST_LVL | 客户等级 | VARCHAR2 | 2 | 【待确认】 | - | - | - | - | 客户等级 |
| LIFE_CYC | 生命周期 | VARCHAR2 | 2 | 【待确认】 | - | - | - | - | 生命周期 |
| AUM | AUM余额 | NUMBER | 20 | 【待确认】 | - | - | - | - | AUM余额 |
| AUM_MTH_AVG | AUM月日均 | NUMBER | 20 | 【待确认】 | - | - | - | - | AUM月日均 |
| AUM_QRT_AVG | AUM季日均 | NUMBER | 20 | 【待确认】 | - | - | - | - | AUM季日均 |
| AUM_YR_AVG | AUM年日均 | NUMBER | 20 | 【待确认】 | - | - | - | - | AUM年日均 |
| IS_NOT_DEPO | 是否持有存款产品 | CHAR | 1 | 【待确认】 | - | - | - | - | 是否持有存款产品 |
| DEPO_BAL | 存款余额 | NUMBER | 20 | 【待确认】 | - | - | - | - | 存款余额 |
| DEPO_MTH_AVG | 存款月日均 | NUMBER | 20 | 【待确认】 | - | - | - | - | 存款月日均 |
| DEPO_QRT_AVG | 存款季日均 | NUMBER | 20 | 【待确认】 | - | - | - | - | 存款季日均 |
| DEPO_YR_AVG | 存款年日均 | NUMBER | 20 | 【待确认】 | - | - | - | - | 存款年日均 |
| DEPO_CURNT_DEPO_BAL | 活期存款余额 | NUMBER | 20 | 【待确认】 | - | - | - | - | 活期存款余额 |
| DEPO_CURNT_DEPO_BAL_MTH_CURNT_AVG_DAY | 活期存款日均余额 | NUMBER | 20 | 【待确认】 | - | - | - | - | 活期存款日均余额 |
| IS_NOT_HIST_FIXD_DEPO_FLAG | 是否历史持有定期存款产品 | VARCHAR2 | 1 | 【待确认】 | - | - | - | - | 是否历史持有定期存款产品 |
| IS_NOT_FIXD_DEPO | 是否持有定期存款产品 | VARCHAR2 | 1 | 【待确认】 | - | - | - | - | 是否持有定期存款产品 |
| FIX_DEPO_BAL | 定期存款余额 | NUMBER | 20 | 【待确认】 | - | - | - | - | 定期存款余额 |
| FIX_DEPO_MTH_AVG | 定期存款月日均 | NUMBER | 20 | 【待确认】 | - | - | - | - | 定期存款月日均 |
| FIX_DEPO_QRT_AVG | 定期存款季日均 | NUMBER | 20 | 【待确认】 | - | - | - | - | 定期存款季日均 |
| FIX_DEPO_YR_AVG | 定期存款年日均 | NUMBER | 20 | 【待确认】 | - | - | - | - | 定期存款年日均 |
| IS_NOT_HIST_LUMPSUM_FIXD_FLAG | 是否历史持有整存整取定期存款 | VARCHAR2 | 1 | 【待确认】 | - | - | - | - | 是否历史持有整存整取定期存款 |
| IS_NOT_LUMPSUM_FIXD | 是否持有整存整取定期存款 | VARCHAR2 | 1 | 【待确认】 | - | - | - | - | 是否持有整存整取定期存款 |
| LUMPSUM_FIXD_DEPO_BAL | 整存整取定期存款余额 | NUMBER | 20 | 【待确认】 | - | - | - | - | 整存整取定期存款余额 |
| IS_NOT_HIST_LEHUI_FLAG | 是否历史持有乐惠存产品 | VARCHAR2 | 1 | 【待确认】 | - | - | - | - | 是否历史持有乐惠存产品 |
| IS_NOT_LEHUI | 是否持有乐惠存产品 | VARCHAR2 | 1 | 【待确认】 | - | - | - | - | 是否持有乐惠存产品 |
| LEHUI_BAL | 乐惠存产品余额 | NUMBER | 20 | 【待确认】 | - | - | - | - | 乐惠存产品余额 |
| LEHUI_MTH_AVG_DAY | 乐惠存产品月日均余额 | NUMBER | 20 | 【待确认】 | - | - | - | - | 乐惠存产品月日均余额 |
| RCNT_FIXD_DEPO_MATURE_DAYS | 最近一笔定期存款到期天数 | NUMBER | 4 | 【待确认】 | - | - | - | - | 最近一笔定期存款到期天数 |
| RCNT_FIXD_DEPO_MATURE_AMT | 最近一笔定期存款到期金额 | NUMBER | 20 | 【待确认】 | - | - | - | - | 最近一笔定期存款到期金额 |
| IS_NOT_HIST_LARGEDP_FLAG | 是否历史持有大额存单 | VARCHAR2 | 1 | 【待确认】 | - | - | - | - | 是否历史持有大额存单 |
| IS_NOT_LARGEDP | 是否持有大额存单 | VARCHAR2 | 1 | 【待确认】 | - | - | - | - | 是否持有大额存单 |
| LARGEDP_BAL | 大额存单余额 | NUMBER | 20 | 【待确认】 | - | - | - | - | 大额存单余额 |
| LARGEDP_MTH_AVG_DAY | 大额存单月日均余额 | NUMBER | 20 | 【待确认】 | - | - | - | - | 大额存单月日均余额 |
| IS_NOT_FIN_CTRAKT | 是否理财签约 | VARCHAR2 | 1 | 【待确认】 | - | - | - | - | 是否理财签约 |
| IS_NOT_HIST_FIN_FLAG | 是否历史持有理财产品 | VARCHAR2 | 1 | 【待确认】 | - | - | - | - | 是否历史持有理财产品 |
| IS_NOT_FIN | 是否持有理财产品 | VARCHAR2 | 1 | 【待确认】 | - | - | - | - | 是否持有理财产品 |
| RCNT_FIN_MATURE_DAYS | 最近一笔理财到期天数 | NUMBER | 4 | 【待确认】 | - | - | - | - | 最近一笔理财到期天数 |
| RCNT_FIN_MATURE_AMT | 最近一笔理财到期金额 | NUMBER | 20 | 【待确认】 | - | - | - | - | 最近一笔理财到期金额 |
| FIN_AMT | 理财余额 | NUMBER | 20 | 【待确认】 | - | - | - | - | 理财余额 |
| FIN_MTH_AVG | 理财月日均 | NUMBER | 20 | 【待确认】 | - | - | - | - | 理财月日均 |
| FIN_QRT_AVG | 理财季日均 | NUMBER | 20 | 【待确认】 | - | - | - | - | 理财季日均 |
| FIN_YR_AVG | 理财年日均 | NUMBER | 20 | 【待确认】 | - | - | - | - | 理财年日均 |
| IS_NOT_HIST_OPEN_FIN_FLAG | 是否历史持有开放式理财产品 | VARCHAR2 | 1 | 【待确认】 | - | - | - | - | 是否历史持有开放式理财产品 |
| IS_NOT_OPEN_FIN | 是否持有开放式理财产品 | VARCHAR2 | 1 | 【待确认】 | - | - | - | - | 是否持有开放式理财产品 |
| OPEN_FIN_BAL | 开放式理财产品余额 | NUMBER | 20 | 【待确认】 | - | - | - | - | 开放式理财产品余额 |
| OPEN_FIN_MTH_AVG_DAY | 开放式理财产品月日均余额 | NUMBER | 20 | 【待确认】 | - | - | - | - | 开放式理财产品月日均余额 |
| IS_NOT_HIST_CLOSE_FIN_FLAG | 是否历史持有封闭式理财产品 | VARCHAR2 | 1 | 【待确认】 | - | - | - | - | 是否历史持有封闭式理财产品 |
| IS_NOT_CLOSE_FIN | 是否持有封闭式理财产品 | VARCHAR2 | 1 | 【待确认】 | - | - | - | - | 是否持有封闭式理财产品 |
| CLOSE_FIN_BAL | 封闭式理财产品余额 | NUMBER | 20 | 【待确认】 | - | - | - | - | 封闭式理财产品余额 |
| CLOSE_FIN_MTH_AVG_DAY | 封闭式理财产品月日均余额 | NUMBER | 20 | 【待确认】 | - | - | - | - | 封闭式理财产品月日均余额 |
| IS_NOT_HIST_AGT_FIN_FLAG | 是否历史持有代销理财产品 | VARCHAR2 | 1 | 【待确认】 | - | - | - | - | 是否历史持有代销理财产品 |
| IS_NOT_AGT_FIN | 是否持有代销理财产品 | VARCHAR2 | 1 | 【待确认】 | - | - | - | - | 是否持有代销理财产品 |
| AGT_FIN_BAL | 代销理财产品余额 | NUMBER | 20 | 【待确认】 | - | - | - | - | 代销理财产品余额 |
| AGT_FIN_MTH_AVG_DAY | 代销理财产品月日均余额 | NUMBER | 20 | 【待确认】 | - | - | - | - | 代销理财产品月日均余额 |
| IS_NOT_LOAN_CUST | 是否贷款客户 | VARCHAR2 | 1 | 【待确认】 | - | - | - | - | 是否贷款客户 |
| IS_NOT_HIST_LOAN_FLAG | 是否历史贷款客户 | VARCHAR2 | 1 | 【待确认】 | - | - | - | - | 是否历史贷款客户 |
| LOAN_BAL | 贷款余额 | NUMBER | 20 | 【待确认】 | - | - | - | - | 贷款余额 |
| IS_NOT_PAYROL_BK | 是否代发户 | VARCHAR2 | 1 | 【待确认】 | - | - | - | - | 是否代发户 |
| IS_NOT_SALRY_PAYROL_BK | 是否代发工资客户 | VARCHAR2 | 1 | 【待确认】 | - | - | - | - | 是否代发工资客户 |
| BK_SALRY_AMT_MTH_LAST | 上月代发工资金额 | NUMBER | 20 | 【待确认】 | - | - | - | - | 上月代发工资金额 |
| RCNT_TIME_ONE_PAYROL_BK_SALRY_DATE | 最近一次代发工资日期 | DATE | - | 【待确认】 | - | - | - | - | 最近一次代发工资日期 |
| PAYROL_BK_SALRY_AMT | 最近一次代发工资金额 | NUMBER | 20 | 【待确认】 | - | - | - | - | 最近一次代发工资金额 |
| PAYROL_SALRY_TTL | 代发工资累计金额 | NUMBER | 20 | 【待确认】 | - | - | - | - | 代发工资累计金额 |
| CONTI_PAYROL_BK_MTHS | 连续稳定代发工资月数 | NUMBER | 4 | 【待确认】 | - | - | - | - | 连续稳定代发工资月数 |
| DCARD_TYPE | 借记卡类型 | VARCHAR2 | 4 | 【待确认】 | - | - | - | - | 借记卡类型 |
| IS_NOT_BK_SELF_SSCARD | 是否我行社保卡 | CHAR | 1 | 【待确认】 | - | - | - | - | 是否我行社保卡 |
| IS_NOT_BK_SELF_CGZJ | 是否我行川工之家客户 | CHAR | 1 | 【待确认】 | - | - | - | - | 是否我行川工之家客户 |
| CGZJ_ACCT_WELF_BAL | 川工之家账户福利资金余额 | NUMBER | 20 | 【待确认】 | - | - | - | - | 川工之家账户福利资金余额 |
| IS_NOT_SELF_REG_MBANK | 是否自助注册手机银行 | CHAR | 1 | 【待确认】 | - | - | - | - | 是否自助注册手机银行 |
| IS_NOT_KTER_CTRAKT_MBANK | 是否柜面签约手机银行 | CHAR | 1 | 【待确认】 | - | - | - | - | 是否柜面签约手机银行 |
| NEAR_MTH_TX_CNT | 近1月累计交易笔数 | NUMBER | 10 | 【待确认】 | - | - | - | - | 近1月累计交易笔数 |
| NEAR_MTH_TX_AMT | 近1月累计交易金额 | NUMBER | 20 | 【待确认】 | - | - | - | - | 近1月累计交易金额 |
| NEAR_MTH_MBANK_TX_CNT | 近1月手机银行累计交易笔数 | NUMBER | 10 | 【待确认】 | - | - | - | - | 近1月手机银行累计交易笔数 |
| NEAR_MTH_MBANK_TX_AMT | 近1月手机银行累计交易金额 | NUMBER | 20 | 【待确认】 | - | - | - | - | 近1月手机银行累计交易金额 |
| NEAR_MTH_MBANK_TX_AMT_BK_OUTER | 近1月手机银行行外入账金额 | NUMBER | 20 | 【待确认】 | - | - | - | - | 近1月手机银行行外入账金额 |
| IS_NOT_SFZF | 是否签约三方支付 | CHAR | 1 | 【待确认】 | - | - | - | - | 是否签约三方支付 |
| NEAR_MTH_THIRD_PAY_OUT_CNT | 近1月第三方支付累计转出笔数 | NUMBER | 10 | 【待确认】 | - | - | - | - | 近1月第三方支付累计转出笔数 |
| NEAR_MTH_THIRD_PAY_OUT_AMT | 近1月第三方支付累计转出金额 | NUMBER | 20 | 【待确认】 | - | - | - | - | 近1月第三方支付累计转出金额 |
| IS_NOT_BILL_RSV_MINOR_MKNT | 是否收单商户小微商户 | CHAR | 1 | 【待确认】 | - | - | - | - | 是否收单商户小微商户 |
| IS_NOT_BILL_RSV_INDIV_MKNT | 是否收单商户个体商户 | CHAR | 1 | 【待确认】 | - | - | - | - | 是否收单商户个体商户 |
| BILL_RSV_MKNT_CNT_MTH_LAST | 收单商户上月交易笔数 | NUMBER | 10 | 【待确认】 | - | - | - | - | 收单商户上月交易笔数 |
| BILL_RSV_MKNT_AMT_MTH_LAST | 收单商户上月交易金额 | NUMBER | 20 | 【待确认】 | - | - | - | - | 收单商户上月交易金额 |
| IS_NOT_BILL_RSV_VAL_MKNT | 是否收单价值商户 | CHAR | 1 | 【待确认】 | - | - | - | - | 是否收单价值商户 |
| IS_NOT_BK_SELF_FUND_PASS_BY_ACCT | 是否我行资金过路户 | CHAR | 1 | 【待确认】 | - | - | - | - | 是否我行资金过路户 |
| IS_NOT_RGLAR_TRANS_BK_OTHER_SAMENAME | 是否向他行同名户规律转出 | CHAR | 1 | 【待确认】 | - | - | - | - | 是否向他行同名户规律转出 |
| MBANK_CONTI_LOGIN_DAYS | 连续登录手机银行天数 | NUMBER | 10 | 【待确认】 | - | - | - | - | 连续登录手机银行天数 |
| IS_NOT_BK_PHONE_ACTV_CUST | 是否手机银行活跃客户 | CHAR | 1 | 【待确认】 | - | - | - | - | 是否手机银行活跃客户 |
| IS_NOT_BK_SELF_LOAN_DUE_OVER_CUST | 行内贷款是否逾期 | CHAR | 1 | 【待确认】 | - | - | - | - | 行内贷款是否逾期 |
| NEAR_24MTH_OVERDUE_FLAG | 行内近24月内是否存在贷款逾期 | CHAR | 1 | 【待确认】 | - | - | - | - | 行内近24月内是否存在贷款逾期 |
| CRDT_DUE_OVER_CNT | 征信逾期次数 | NUMBER | 10 | 【待确认】 | - | - | - | - | 征信逾期次数 |
| EXIST_BADLOAN_REC | 征信是否存在不良贷款记录 | CHAR | 1 | 【待确认】 | - | - | - | - | 征信是否存在不良贷款记录 |
| IS_NOT_INSUR | 是否持有保险产品 | CHAR | 1 | 【待确认】 | - | - | - | - | 是否持有保险产品 |
| INSUR_FRST_PREM_AMT | 保险产品首期保费 | NUMBER | 20 | 【待确认】 | - | - | - | - | 保险产品首期保费 |
| INSUR_BAL | 保险余额 | NUMBER | 20 | 【待确认】 | - | - | - | - | 保险余额 |
| INSUR_MTH_AVG | 保险月日均 | NUMBER | 20 | 【待确认】 | - | - | - | - | 保险月日均 |
| INSUR_QRT_AVG | 保险季日均 | NUMBER | 20 | 【待确认】 | - | - | - | - | 保险季日均 |
| INSUR_YR_AVG | 保险年日均 | NUMBER | 20 | 【待确认】 | - | - | - | - | 保险年日均 |
| NEAR_3_MTH_MIN_BENEFIT_LVL | 近三个月最低权益等级 | VARCHAR2 | 2 | 【待确认】 | - | - | - | - | 近三个月最低权益等级 |
| NEAR_6_MTH_MIN_BENEFIT_LVL | 近六个月最低权益等级 | VARCHAR2 | 2 | 【待确认】 | - | - | - | - | 近六个月最低权益等级 |
| NEAR_9_MTH_MIN_BENEFIT_LVL | 近九个月最低权益等级 | VARCHAR2 | 2 | 【待确认】 | - | - | - | - | 近九个月最低权益等级 |
| NEAR_12_MTH_MIN_BENEFIT_LVL | 近十二个月最低权益等级 | VARCHAR2 | 2 | 【待确认】 | - | - | - | - | 近十二个月最低权益等级 |
| IS_NOT_YR_FRST_LVL_UPG_CUST | 是否当年首次等级升级客户 | CHAR | 1 | 【待确认】 | - | - | - | - | 是否当年首次等级升级客户 |
| FRST_UPG_CUST_UPG_LVL | 首次升级客户升级等级 | VARCHAR2 | 2 | 【待确认】 | - | - | - | - | 首次升级客户升级等级 |
| IS_NOT_YR_LVL_DWN_CUST | 是否当年等级降级客户 | CHAR | 1 | 【待确认】 | - | - | - | - | 是否当年等级降级客户 |
| DWN_CUST_LVL_BF_AF | 降级客户降级前后等级 | VARCHAR2 | 5 | 【待确认】 | - | - | - | - | 降级客户降级前后等级 |
| IS_NOT_HIGH_WORTH_CRIT_CUST | 是否为高净值临界客户 | CHAR | 1 | 【待确认】 | - | - | - | - | 是否为高净值临界客户 |
| IS_NOT_MBANK_BIND_CARD | 是否登录手机银行并完成绑卡客户 | CHAR | 1 | 【待确认】 | - | - | - | - | 是否登录手机银行并完成绑卡客户 |
| REG_LOGIN_BK_PHONE_CUST_DAYS | 注册并登录手机银行客户的天数 | NUMBER | 10 | 【待确认】 | - | - | - | - | 注册并登录手机银行客户的天数 |
| MTH_LOGIN_MBANK_CNT | 当月登录手机银行次数 | NUMBER | 10 | 【待确认】 | - | - | - | - | 当月登录手机银行次数 |
| IS_NOT_3RD_PAY_BIND_CARD_DONE | 是否完成三方支付绑卡 | CHAR | 1 | 【待确认】 | - | - | - | - | 是否完成三方支付绑卡 |
| YR_CAMPUS_PAY_CNT | 当年校园缴费笔数 | NUMBER | 10 | 【待确认】 | - | - | - | - | 当年校园缴费笔数 |
| YR_HOT_ACTV_CNT | 当年参与热门活动次数 | NUMBER | 10 | 【待确认】 | - | - | - | - | 当年参与热门活动次数 |
| MTH_UTIL_PAY_TRAN_AMT | 当月完成水电气缴费交易金额 | NUMBER | 20 | 【待确认】 | - | - | - | - | 当月完成水电气缴费交易金额 |
| MTH_UTIL_PAY_TRAN_CNT | 当月完成水电气缴费交易笔数 | NUMBER | 10 | 【待确认】 | - | - | - | - | 当月完成水电气缴费交易笔数 |
| TRAN_CHAN_PREF | 交易渠道偏好 | VARCHAR2 | 2 | 【待确认】 | - | - | - | - | 交易渠道偏好 |
| IS_NOT_WECHAT_TRAN_MTH_ACTIVE | 是否为微信绑卡交易月活跃客户 | CHAR | 1 | 【待确认】 | - | - | - | - | 是否为微信绑卡交易月活跃客户 |
| PRDKT_PREF | 储蓄产品偏好 | VARCHAR2 | 20 | 【待确认】 | - | - | - | - | 储蓄产品偏好 |
| VERIFIED_BADGE | 企微客户认证标志 | VARCHAR2 | 1 | 【待确认】 | - | - | - | - | 企微客户认证标志 |
| DEPO_TERM_PREF | 储蓄产品期限偏好 | VARCHAR2 | 20 | 【待确认】 | - | - | - | - | 储蓄产品期限偏好 |
| IS_NOT_WB_LOAN | 是否微粒贷客户 | VARCHAR2 | 1 | 【待确认】 | - | - | - | - | 是否微粒贷客户 |
| IS_NOT_MT_LOAN | 是否美团贷款客户 | VARCHAR2 | 1 | 【待确认】 | - | - | - | - | 是否美团贷款客户 |
| ORG_PATH | 机构路径 | VARCHAR2 | 100 | 【待确认】 | - | - | - | - | 机构路径 |
| CONTR_AMT | 总合同额度 | NUMBER | 20 | 【待确认】 | - | - | - | - | 总合同额度 |
| DCARD_LVL | 借记卡等级 | VARCHAR2 | 4 | 【待确认】 | - | - | - | - | 借记卡等级 |

---

*数据字典版本: v1.0 | 生成时间: 2026-07-29*
