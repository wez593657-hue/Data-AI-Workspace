# ODS到DWD映射 字段映射

## 映射概览

| 目标表 | 目标表中文名 | 源表 | 源表中文名 |
|--------|-------------|------|------------|
| DWD_CUST_INDV_INFO | 客户基本信息 | ECIF_CUST_NO |  |
| DWD_TX_ASET | 资产类交易 | TRANS_SERNO |  |
| DWD_ACCT_DEPO | 存款账户信息表 | host_cust_no |  |
| DWD_ACCT_LOAN | 贷款账户 | MFCUSTOMERID |  |
| DWD_ACCT_FIN | 理财账户信息 | host_cust_no |  |
| DWD_ACCT_INSUR | 保险账户信息 | b.user_id |  |
| DWD_CUST_SIGN_CTRAKT | 客户签约信息 | t0.ECIF_CUST_NO |  |
| DWD_CUST_INDIV_CRDT | 个人客户授信信息 | MFCUSTOMERID |  |
| DWD_CUST_CTRAKT_INFO | 客户合同信息 | MFCUSTOMERID |  |
| DWD_CUST_INDIV_RISK_INVST | 客户风险评估 | host_cust_no |  |

## 字段映射详情

### DWD_CUST_INDV_INFO (客户基本信息)

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源系统 | 源表 | 源字段 | 映射规则 |
|----------|---------------|--------------|--------|------|--------|----------|
| CUST_ID | 客户编号 | VARCHAR2(20) | - | - | ECIF_CUST_NO | - |
| CUST_NAME | 客户名称 | VARCHAR2(100) | - | - | PARTY_NAME | - |
| CERT_TYP | 证件类型 | VARCHAR2(6) | - | - | CERT_TYPE | - |
| CERT_ID | 证件号码 | VARCHAR2(32) | - | - | CERT_NO | - |
| CERT_PRD_VLID | 证件有效期起 | VARCHAR2(10) | - | - | CERT_ISSUE_DATE | - |
| CERT_PRD_VLID_END | 证件有效期止 | VARCHAR2(10) | - | - | CERT_DUE_DATE | - |
| CERT_ISSUING_AUTHORITY | 签发机关所在地 | VARCHAR2(100) | - | - | CERT_ORG_AREA | - |
| CUST_TYP | 客户类型 | VARCHAR2(2) | - | - |  | - |
| NATIONALITY | 国籍 | VARCHAR2(6) | - | - | NAT_CODE | - |
| NATION | 民族 | VARCHAR2(6) | - | - | PEOPLE | - |
| MARI_SITU | 婚姻状况 | VARCHAR2(6) | - | - | MARITAL_STAT | - |
| MAX_DEG_EDU | 最高学历 | VARCHAR2(6) | - | - | HIGHEST_DEGREE | - |
| NOW_ENTER | 现工作单位 | VARCHAR2(120) | - | - | WORK_CORP | - |
| OCCU_CLS | 职业分类 | VARCHAR2(6) | - | - | PROFESSION | - |
| CUST_HRAKY | 客户等级 | VARCHAR2(2) | - | - |  | - |
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR2(4) | - | - |  | - |
| GEND | 性别 | VARCHAR2(2) | - | - | GENDER | - |
| PHONE_NO | 手机号码 | VARCHAR2(20) | - | - | PHONE_NO | - |
| CONTACT_ADDRESS | 联系地址 | VARCHAR2(254) | - | - |  | - |
| CONTACT_ADDRESS_DETAIL | 联系地址详细地址 | VARCHAR2(254) | - | - | ADDR_LINE | - |
| ID_ADDRESS | 证件地址 | VARCHAR2(254) | - | - |  | - |
| ID_ADDRESS_DETAIL | 证件地址详细地址 | VARCHAR2(254) | - | - | ADDR_LINE | - |
| HOME_ADDRESS | 家庭地址 | VARCHAR2(254) | - | - |  | - |
| HOME_ADDRESS_DETAIL | 家庭地址详细地址 | VARCHAR2(254) | - | - | ADDR_LINE | - |
| RESIDENCE_ADDRESS | 住宅地址 | VARCHAR2(254) | - | - |  | - |
| RESIDENCE_ADDRESS_DETAIL | 住宅地址详细地址 | VARCHAR2(254) | - | - | ADDR_LINE | - |
| OFFICE_ADDRESS | 办公地址 | VARCHAR2(254) | - | - |  | - |
| OFFICE_ADDRESS_DETAIL | 办公地址详细地址 | VARCHAR2(254) | - | - | ADDR_LINE | - |
| HOST_CUST_MNGR_POST_ID | 主办客户经理职位编号 | VARCHAR2(20) | - | - |  | - |
| HOST_CUST_MNGR_NAME | 主办客户经理名称 | VARCHAR2(60) | - | - |  | - |
| HOST_CUST_MNGR_EMP_ID | 主办客户经理工号 | VARCHAR2(6) | - | - |  | - |
| ORG_LEAD | 主办机构(归属机构) | VARCHAR2(6) | - | - |  | - |
| ORG_LEAD_PATH | 主办机构路径 | VARCHAR2(50) | - | - |  | - |
| COSPSR_CUST_MNGR_POST_ID | 信贷客户经理职位编号 | VARCHAR2(20) | - | - |  | - |
| COSPSR_CUST_MNGR_NAME | 信贷客户经理名称 | VARCHAR2(60) | - | - |  | - |
| COSPSR_CUST_MNGR_EMP_ID | 信贷客户经理工号 | VARCHAR2(6) | - | - |  | - |
| COSPSR_ORG | 信贷机构 | VARCHAR2(6) | - | - |  | - |
| COSPSR_ORG_PATH | 信贷机构路径 | VARCHAR2(50) | - | - |  | - |

### DWD_TX_ASET (资产类交易)

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源系统 | 源表 | 源字段 | 映射规则 |
|----------|---------------|--------------|--------|------|--------|----------|
| SEQ_ID | 流水号 | VARCHAR2(40) | - | - | TRANS_SERNO | - |
| CUST_ID | 客户编号 | VARCHAR2(21) | - | - | host_cust_no | - |
| CUST_TYP | 客户类型 | VARCHAR2(4) | - | - | cust_type | - |
| ACCT_ID | 账户 | VARCHAR2(40) | - | - | TERM_ACCT_NO | - |
| PRDKT_CATE_BIG | 产品大类 | VARCHAR2(6) | - | - | PROD_CLASS | - |
| PRDKT_ID | 产品ID | VARCHAR2(40) | - | - | PROD_CODE | - |
| TX_CHNL | 交易渠道 | VARCHAR2(10) | - | - | TRANS_CHANNEL | - |
| TX_DATE | 交易日期 | VARCHAR2(10) | - | - | TRANS_DATE | - |
| TX_TIME | 交易时间 | VARCHAR2(20) | - | - | TRANS_TIME | - |
| CCY_CD | 币种 | VARCHAR2(6) | - | - |  | - |
| TX_TYP | 交易类型 | VARCHAR2(6) | - | - | TRANS_TYPE | - |
| AMT | 发生额 | NUMBER(18,4) | - | - | TRANS_AMT | - |
| TX_TYP_NAME | 交易类型名称 | VARCHAR2(80) | - | - |  | - |
| TX_ORG | 交易机构 | VARCHAR2(20) | - | - | TRANS_ORGNO | - |
| OPRTR | 经办人 | VARCHAR2(20) | - | - |  | - |
| LOAN_FLG | 借贷标识 | VARCHAR2(3) | - | - |  | - |
| ACCT_BAL | 账户余额 | NUMBER(18,4) | - | - | BALANCE | - |
| TX_DSC | 交易说明 | VARCHAR2(200) | - | - |  | - |
| OPNT_ACCT | 对方账户 | VARCHAR2(32) | - | - |  | - |
| OPNT_ACCT_NAME_FST | 对方户名 | VARCHAR2(200) | - | - |  | - |
| OPNT_BK_KEEP | 对方行 | VARCHAR2(20) | - | - |  | - |
| OPNT_NAME_BK | 对方行名 | VARCHAR2(200) | - | - |  | - |
| FEE_HAND | 手续费 | NUMBER(18,4) | - | - |  | - |
| ACCT_BLNG_ORG | 账户归属机构 | VARCHAR2(20) | - | - | CARD_ORGNO | - |
| CARD_NO | 卡/折号 | VARCHAR2(30) | - | - | TERM_ACCT_NO | - |
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR2(30) | - | - |  | - |

### DWD_ACCT_DEPO (存款账户信息表)

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源系统 | 源表 | 源字段 | 映射规则 |
|----------|---------------|--------------|--------|------|--------|----------|
| CUST_ID | 客户编号 | VARCHAR2(20) | - | - | host_cust_no | - |
| CUST_TYP | 客户类型 | VARCHAR2(2) | - | - |  | - |
| ACCT_ID | 账户 | VARCHAR2(40) | - | - | term_acct_no | - |
| CARD_NO | 卡/折号 | VARCHAR2(40) | - | - | term_acct_no | - |
| PRDKT_ID | 产品编号 | VARCHAR2(30) | - | - | prod_code | - |
| PRDKT_NAME | 产品名称 | VARCHAR2(200) | - | - | prod_name | - |
| PRDKT_CATE_BIG | 产品大类 | VARCHAR2(64) | - | - |  | - |
| ACCT_TYP | 账户类型 | VARCHAR2(10) | - | - |  | - |
| CCY_CD | 币种 | VARCHAR2(4) | - | - |  | - |
| BAL | 余额 | NUMBER(20,2) | - | - | BALANCE | - |
| RMB_BAL | 折人民币余额 | NUMBER(20,2) | - | - |  | - |
| OPEN_ACCT_ORG | 归属机构 | VARCHAR2(6) | - | - | CARD_ORGNO | - |
| OPEN_DATE | 开户日期 | VARCHAR2(10) | - | - | CARRY_INTEREST_DATE | - |
| RATE_INTRI | 利率 | NUMBER(20,2) | - | - | rate | - |
| INTRI_BGN_DATE | 起息日期 | VARCHAR2(10) | - | - | CARRY_INTEREST_DATE | - |
| EXPR_DATE | 到期日期 | VARCHAR2(10) | - | - | EXPIRE_DATE | - |
| ACCT_CLOZ_DATE | 销户日期 | VARCHAR2(10) | - | - |  | - |
| ACCT_STATE | 账户状态 | VARCHAR2(10) | - | - |  | - |
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR2(4) | - | - | inc_due | - |
| VCHR_TYP | 凭证类型 | VARCHAR2(10) | - | - |  | - |
| CUNQ | 存期 | VARCHAR2(10) | - | - |  | - |
| FIX_CURNT_FLG | 定活标志 | VARCHAR2(1) | - | - |  | - |

### DWD_ACCT_LOAN (贷款账户)

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源系统 | 源表 | 源字段 | 映射规则 |
|----------|---------------|--------------|--------|------|--------|----------|
| CUST_ID | 客户编号 | VARCHAR2(20) | - | - | MFCUSTOMERID | - |
| CUST_TYP | 客户类型 | VARCHAR2(6) | - | - |  | - |
| ACCT_ID | 账号 | VARCHAR2(40) | - | - | AccountNo | - |
| PRDKT_ID | 产品编号 | VARCHAR2(40) | - | - | BusinessType | - |
| PRDKT_NAME | 产品名称 | VARCHAR2(100) | - | - | TypeName | - |
| PRDKT_CATE_BIG | 产品大类 | VARCHAR2(60) | - | - | BaseTypeNo | - |
| LOAN_ISSU_AMT | 借据金额 | NUMBER(20,2) | - | - | BusinessSum | - |
| LOAN_ISSU_DATE | 贷款发放日期 | VARCHAR2(10) | - | - | PutoutDate | - |
| BAL | 余额 | NUMBER(20,2) | - | - | NormalBalance+OverdueBalance | - |
| RATE_INTRI | 利率 | NUMBER(10,4) | - | - | BusinessRate | - |
| EXPR_DATE | 到期日期 | VARCHAR2(10) | - | - | MaturityDate | - |
| ACCT_STATE | 账户状态 | VARCHAR2(10) | - | - | LoanStatus | - |
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR2(4) | - | - |  | - |
| OPRT_ORG | 经办机构 | VARCHAR2(6) | - | - |  | - |
| IOU_NO | 借据号 | VARCHAR2(100) | - | - | SerialNo | - |
| INT_ARREARS_TTL | 欠息(合计) | NUMBER(20,2) | - | - | ACCRUEDINTEREST
OVERDUEINTEREST
PRINCIPALPENALTY
INTERESTPENALTY | - |
| REPAY_TYP | 还款方式 | VARCHAR2(4) | - | - | TermID | - |
| REPAY_ACCT_NO | 还款账号 | VARCHAR2(30) | - | - | AccountNo | - |
| CATE_5LVL | 五级分类 | VARCHAR2(2) | - | - | ClassifyResult | - |

### DWD_PRDKT_INFO (产品信息表)

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源系统 | 源表 | 源字段 | 映射规则 |
|----------|---------------|--------------|--------|------|--------|----------|
| PRDKT_ID | 产品编号 | VARCHAR2(40) | - | - |  | - |
| PRDKT_NAME | 产品名称 | VARCHAR2(100) | - | - |  | - |
| PRDKT_CATE_BIG | 产品大类 | VARCHAR2(10) | - | - |  | - |
| BGN_DATE | 开始日期 | VARCHAR2(10) | - | - |  | - |
| END_DATE | 结束日期 | VARCHAR2(10) | - | - |  | - |
| PRDKT_LINE | 产品条线 | VARCHAR2(10) | - | - |  | - |
| SUP_PRDKT_ID | 上级产品编号 | VARCHAR2(30) | - | - |  | - |
| MDL_BIZ_RATE_FEE | 中间业务费率 | NUMBER(18,4) | - | - |  | - |
| PRDKT_RATE | 产品利率 | NUMBER(18,4) | - | - |  | - |
| SYS_SRC | 系统来源 | VARCHAR2(6) | - | - |  | - |
| PRDKT_STATE | 产品状态(在售/停售) | VARCHAR2(10) | - | - |  | - |
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR2(30) | - | - |  | - |

### DWD_ACCT_FIN (理财账户信息)

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源系统 | 源表 | 源字段 | 映射规则 |
|----------|---------------|--------------|--------|------|--------|----------|
| CUST_ID | 客户编号 | VARCHAR2(20) | - | - | host_cust_no | - |
| CUST_TYP | 客户类型 | VARCHAR2(2) | - | - |  | - |
| ACCT_ID | 账户 | VARCHAR2(40) | - | - | acct_no | - |
| CARD_NO | 卡/折号 | VARCHAR2(30) | - | - | card_no | - |
| PRDKT_ID | 产品ID | VARCHAR2(40) | - | - | REGIST_CODE | - |
| PRDKT_NAME | 产品名称 | VARCHAR2(100) | - | - | prod_name | - |
| PRDKT_CATE_BIG | 产品大类 | VARCHAR2(64) | - | - | PROD_TYPE | - |
| ESTAB_DATE | 成立日期 | VARCHAR2(10) | - | - | ESTABLISH_DATE | - |
| FIN_AMT | 理财余额 | NUMBER(20,2) | - | - | remain_vol | - |
| RATE_INTRI | 收益率 | NUMBER(20,2) | - | - | TONOWCLIENTRATIO | - |
| ACCT_STATE | 状态 | VARCHAR2(10) | - | - | ACCT_STATUS | - |
| INTRI_BGN_DATE | 起息日期 | VARCHAR2(10) | - | - | VALUE_DATE | - |
| EXPR_DATE | 到期日期 | VARCHAR2(10) | - | - | WINDING_DATE | - |
| OPRT_ORG | 归属机构 | VARCHAR2(6) | - | - | TANO | - |
| CHNL_NO | 办理渠道 | VARCHAR2(10) | - | - | ISS_BANK_CODE | - |
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR2(4) | - | - |  | - |
| ISSU_ORG | 发行机构 | VARCHAR2(6) | - | - | TANO | - |
| ISSU_DATE | 办理日期 | VARCHAR2(10) | - | - | CRT_DATE | - |
| RISK_LVL | 风险等级 | VARCHAR2(2) | - | - | PROD_RISK_LEVEL | - |
| CUST_ID | 客户编号 | VARCHAR2(20) | - | - | host_cust_no | - |
| CUST_TYP | 客户类型 | VARCHAR2(2) | - | - |  | - |
| ACCT_ID | 账户 | VARCHAR2(40) | - | - | acct_no | - |
| CARD_NO | 卡/折号 | VARCHAR2(30) | - | - | card_no | - |
| PRDKT_ID | 产品ID | VARCHAR2(40) | - | - | REGIST_CODE | - |
| PRDKT_NAME | 产品名称 | VARCHAR2(100) | - | - | prod_name | - |
| PRDKT_CATE_BIG | 产品大类 | VARCHAR2(64) | - | - | PERIOD_TYPE | - |
| ESTAB_DATE | 成立日期 | VARCHAR2(10) | - | - | ESTABLISH_DATE | - |
| FIN_AMT | 理财余额 | NUMBER(20,2) | - | - | TOTAL_VOL | - |
| FIN_MTH_AVG | 理财月日均 | NUMBER(20,2) | - | - |  | - |
| FIN_QRT_AVG | 理财季日均 | NUMBER(20,2) | - | - |  | - |
| FIN_YR_AVG | 理财年日均 | NUMBER(20,2) | - | - |  | - |
| RATE_INTRI | 收益率 | NUMBER(20,2) | - | - | SEVEN_DAYS_INCOME | - |
| ACCT_STATE | 状态 | VARCHAR2(10) | - | - | ACCT_STATUS | - |
| INTRI_BGN_DATE | 起息日期 | VARCHAR2(10) | - | - | VALUE_DATE | - |
| EXPR_DATE | 到期日期 | VARCHAR2(10) | - | - | WINDING_DATE | - |
| OPRT_ORG | 归属机构 | VARCHAR2(6) | - | - |  | - |
| CHNL_NO | 办理渠道 | VARCHAR2(10) | - | - |  | - |
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR2(4) | - | - |  | - |
| ISSU_ORG | 发行机构 | VARCHAR2(6) | - | - |  | - |
| ISSU_DATE | 办理日期 | VARCHAR2(10) | - | - | CRT_DATE | - |
| RISK_LVL | 风险等级 | VARCHAR2(2) | - | - | PROD_RISK_LEVEL | - |

### DWD_ACCT_INSUR (保险账户信息)

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源系统 | 源表 | 源字段 | 映射规则 |
|----------|---------------|--------------|--------|------|--------|----------|
| CUST_ID | 客户编号 | VARCHAR2(20) | - | - | b.user_id | - |
| CUST_TYP | 客户类型 | VARCHAR2(4) | - | - |  | - |
| ACCT_ID | 账户 | VARCHAR2(40) | - | - | c.ACC_NO | - |
| PRDKT_ID | 产品ID | VARCHAR2(40) | - | - | e.PRODUCT_ID | - |
| PRDKT_NAME | 产品名称 | VARCHAR2(100) | - | - | e.PRODUCT_NAME | - |
| PRDKT_CATE_BIG | 产品大类 | VARCHAR2(64) | - | - | e.PRODUCT_BIG_TYPE | - |
| INSUR_BID_FORM_NO | 投保单号 | VARCHAR2(40) | - | - | c.CONT_NO | - |
| TX_DATE | 交易日期 | VARCHAR2(10) | - | - | c.ACCEPT_DATE | - |
| TX_ORG | 交易机构 | VARCHAR2(6) | - | - | c.THROW_COM | - |
| TX_CHNL | 交易渠道 | VARCHAR2(10) | - | - | c.CONT_SOURCE | - |
| MKT_ORG | 归属机构 | VARCHAR2(6) | - | - | c.THROW_COM | - |
| BGN_INSUR_DATE | 起保日期 | VARCHAR2(10) | - | - | c.VALI_DATE | - |
| CANCL_INSUR_DATE | 退保日期 | VARCHAR2(10) | - | - |  | - |
| INSUR_PERIOD_TYP | 保险期间类型 | VARCHAR2(2) | - | - | d.PAY_PER_UNIT | - |
| INSUR_PERIOD | 保险期间值 | VARCHAR2(6) | - | - | d.PAY_PER_NUM | - |
| PAY_PERIOD_TYP | 缴费期间类型 | VARCHAR2(2) | - | - | d.VALID_PER_UNIT | - |
| PAY_PERIOD | 缴费期间值 | VARCHAR2(6) | - | - | d.VALID_PER_NUM | - |
| PAY_PATRN | 缴费方式 | VARCHAR2(2) | - | - | d.PAY_TYPE | - |
| INSUR_AMT | 保费金额 | NUMBER(20,2) | - | - | a.ORD_AMT | - |
| POLICY_STATE | 保单状态 | VARCHAR2(10) | - | - | c.CONT_STATUS | - |
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR2(4) | - | - | a.TRAN_TYPE | - |

### DWD_CUST_SIGN_CTRAKT (客户签约信息)

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源系统 | 源表 | 源字段 | 映射规则 |
|----------|---------------|--------------|--------|------|--------|----------|
| CUST_ID | 客户编号 | VARCHAR2(20) | - | - | t0.ECIF_CUST_NO | - |
| CTRAKT_ACCT | 签约账户 | VARCHAR2(40) | - | - | t1.SIGN_ACC_NO | - |
| CTRAKT_TYP | 签约类型 | VARCHAR2(6) | - | - | t1.SIGN_TYPE | - |
| CTRAKT_DATE | 签约日期 | VARCHAR2(10) | - | - | t2.SIGN_DATE | - |
| PHONE_NO | 手机号 | VARCHAR2(32) | - | - | t2.SIGN_REL_PHONE | - |
| CTRAKT_ORG | 签约机构 | VARCHAR2(6) | - | - | t2.SIGN_ORG | - |
| CTRAKT_OPRTR | 签约经办人 | VARCHAR2(20) | - | - | t2.ATTN_NAME | - |
| CTRAKT_STATE | 签约状态 | VARCHAR2(2) | - | - | t1.SIGN_STATE | - |
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR2(4) | - | - |  | - |

### DWD_CUST_INDIV_CRDT (个人客户授信信息)

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源系统 | 源表 | 源字段 | 映射规则 |
|----------|---------------|--------------|--------|------|--------|----------|
| CUST_ID | 客户编号 | VARCHAR(100) | - | - | MFCUSTOMERID | - |
| CUST_NAME | 客户名称 | VARCHAR(100) | - | - | CustomerName | - |
| CRDT_AGRE_NO | 授信协议号 | VARCHAR(100) | - | - | Serialno | - |
| CRDT_AGRE_TYP | 授信协议类型 | VARCHAR(100) | - | - |  | - |
| CRDT_TTL_LMT | 授信额度 | VARCHAR(100) | - | - | BusienssSum | - |
| BGN_DATE | 开始日期 | VARCHAR(100) | - | - | PutoutDate | - |
| EXPR_DATE | 到期日期 | VARCHAR(100) | - | - | MaturityDate | - |
| CRDT_STATUS | 授信状态 | VARCHAR(100) | - | - |  | - |
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR(100) | - | - |  | - |

### DWD_CUST_CTRAKT_INFO (客户合同信息)

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源系统 | 源表 | 源字段 | 映射规则 |
|----------|---------------|--------------|--------|------|--------|----------|
| CUST_ID | 客户编号 | VARCHAR(100) | - | - | MFCUSTOMERID | - |
| CTRAKT_ID | 合同编号 | VARCHAR(100) | - | - | Serialno | - |
| LOAN_ACCT | 贷款账号 | VARCHAR(100) | - | - |  | - |
| CRDT_LMT | 授信额度 | VARCHAR(100) | - | - | BusienssSum | - |
| LOAN_BAL | 贷款余额 | VARCHAR(100) | - | - | Balance | - |
| GUARANT_MODE | 担保方式 | VARCHAR(100) | - | - | VouchType | - |
| CATE_5LVL | 五级分类 | VARCHAR(100) | - | - | ClassifyResult | - |
| CCY_CD | 币种 | VARCHAR(100) | - | - | BusinessCurrency | - |
| RATE_INTRI | 利率 | VARCHAR(100) | - | - | BusinessRate | - |
| CONTR_AMT | 合同金额 | VARCHAR(100) | - | - | BusienssSum | - |
| BGN_DATE | 发放日期 | VARCHAR(100) | - | - | PutoutDate | - |
| END_DATE | 结束日期 | VARCHAR(100) | - | - | MaturityDate | - |
| OPRTR | 经办人 | VARCHAR(100) | - | - | ManageUserID | - |
| OPRT_ORG | 经办机构 | VARCHAR(100) | - | - | ManageOrgID | - |
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR(100) | - | - |  | - |

### DWD_CUST_INDIV_RISK_INVST (客户风险评估)

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源系统 | 源表 | 源字段 | 映射规则 |
|----------|---------------|--------------|--------|------|--------|----------|
| CUST_ID | 客户编号 | VARCHAR(100) | - | - | host_cust_no | - |
| INVEST_TYP | 投资类型 | VARCHAR(100) | - | - |  | - |
| ESTIM_RSLT | 评估结果 | VARCHAR(100) | - | - | CUST_RISK_LEVEL | - |
| SCORE | 分数 | VARCHAR(100) | - | - | CUST_RISK_LEVEL | - |
| RISK_LVL | 风险级别 | VARCHAR(100) | - | - | CUST_RISK_LEVEL | - |
| ESTIM_DATE | 评估日期 | VARCHAR(100) | - | - | ASSESS_DATE | - |
| EXPR_DATE | 到期日期 | VARCHAR(100) | - | - | INVALID_DATE | - |
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR(100) | - | - |  | - |
| CUST_ID | 客户编号 | VARCHAR(100) | - | - |  | - |
| INVEST_TYP | 投资类型 | VARCHAR(100) | - | - |  | - |
| ESTIM_RSLT | 评估结果 | VARCHAR(100) | - | - |  | - |
| SCORE | 分数 | VARCHAR(100) | - | - |  | - |
| RISK_LVL | 风险级别 | VARCHAR(100) | - | - |  | - |
| ESTIM_DATE | 评估日期 | VARCHAR(100) | - | - |  | - |
| EXPR_DATE | 到期日期 | VARCHAR(100) | - | - |  | - |
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR(100) | - | - |  | - |


---
*Mapping版本: v1.0 | 生成时间: 2026-07-17*
