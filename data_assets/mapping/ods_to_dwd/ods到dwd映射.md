# ODS到DWD映射 字段映射

## 映射来源

- Excel：`data_assets/mapping/ods_to_dwd/DWD明细层数据模型_CRM_ V1.0.xlsx`
- Excel SHA-256：`2eaa2dd83074013c2054b7a292507282ae0831db5675bf9b8f8c09fdcfb16c01`

## 映射概览

| 目标表 | 字段数 |
|--------|-------:|
| DWD_ACCT_DEPO | 22 |
| DWD_ACCT_FIN | 19 |
| DWD_ACCT_INSUR | 21 |
| DWD_ACCT_LOAN | 19 |
| DWD_CRM_SYS_XTHLCS | 5 |
| DWD_CUST_CTRAKT_INFO | 15 |
| DWD_CUST_INDIV_CRDT | 9 |
| DWD_CUST_INDIV_RISK_INVST | 8 |
| DWD_CUST_INDV_INFO | 39 |
| DWD_CUST_INDV_KYC | 27 |
| DWD_CUST_SIGN_CTRAKT | 9 |
| DWD_PRDKT_INFO | 12 |
| DWD_SYS_ORG | 20 |
| DWD_TX_ASET | 22 |

## 字段映射详情

### DWD_CUST_INDV_INFO

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源表 | 源字段 | 映射规则 |
|----------|----------------|--------------|------|--------|----------|
| CUST_ID | 客户编号 | VARCHAR2(20) | ECIF_T01_P_CUST_INFO | ECIF_CUST_NO |  |
| CUST_NAME | 客户名称 | VARCHAR2(100) | ECIF_T01_P_CUST_INFO | PARTY_NAME |  |
| CERT_TYP | 证件类型 | VARCHAR2(6) | ECIF_T01_P_CUST_INFO | CERT_TYPE |  |
| CERT_ID | 证件号码 | VARCHAR2(32) | ECIF_T01_P_CUST_INFO | CERT_NO |  |
| CERT_PRD_VLID | 证件有效期起 | VARCHAR2(10) | ECIF_T01_P_CUST_INFO | CERT_ISSUE_DATE |  |
| CERT_PRD_VLID_END | 证件有效期止 | VARCHAR2(10) | ECIF_T01_P_CUST_INFO | CERT_DUE_DATE |  |
| CERT_ISSUING_AUTHORITY | 签发机关所在地 | VARCHAR2(100) | ECIF_T01_P_CUST_INFO | CERT_ORG_AREA |  |
| CUST_TYP | 客户类型 | VARCHAR2(2) | ECIF_T01_P_CUST_INFO |  | 1' |
| OPEN_DATE | 开户日期 | VARCHAR2(10) | ECIF_T01_P_CUST_INFO | OPEN_DATE |  |
| OPEN_ORG | 开户机构 | VARCHAR2(20) | ECIF_T01_P_CUST_INFO | OPEN_ORG |  |
| NATIONALITY | 国籍 | VARCHAR2(6) | ECIF_T01_P_CUST_INFO | NAT_CODE |  |
| NATION | 民族 | VARCHAR2(6) | ECIF_T01_P_CUST_INFO | PEOPLE |  |
| MARI_SITU | 婚姻状况 | VARCHAR2(6) | ECIF_T01_P_CUST_INFO | MARITAL_STAT |  |
| MAX_DEG_EDU | 最高学历 | VARCHAR2(6) | ECIF_T01_P_CUST_INFO | HIGHEST_DEGREE |  |
| NOW_ENTER | 现工作单位 | VARCHAR2(120) | ECIF_T01_P_CUST_WORK | WORK_CORP |  |
| OCCU_CLS | 职业分类 | VARCHAR2(6) | ECIF_T01_P_CUST_INFO | PROFESSION |  |
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR2(4) |  |  | 9999' |
| GEND | 性别 | VARCHAR2(2) |  |  | (CASE<br> WHEN T1.GENDER IN ('0') THEN '9'<br> ELSE T1.GENDER<br>END) GEND |
| PHONE_NO | 手机号码 | VARCHAR2(20) | ECIF_T03_A_TELE_INFO | PHONE_NO |  |
| CONTACT_ADDRESS | 联系地址 | VARCHAR2(254) | FLAT_ADDR | CONTACT_ADDRESS |  |
| CONTACT_ADDRESS_DETAIL | 联系地址详细地址 | VARCHAR2(254) | FLAT_ADDR | CONTACT_ADDRESS_DETAIL |  |
| ID_ADDRESS | 证件地址 | VARCHAR2(254) | FLAT_ADDR | ID_ADDRESS |  |
| ID_ADDRESS_DETAIL | 证件地址详细地址 | VARCHAR2(254) | FLAT_ADDR | ID_ADDRESS_DETAIL |  |
| HOME_ADDRESS | 家庭地址 | VARCHAR2(254) | FLAT_ADDR | HOME_ADDRESS |  |
| HOME_ADDRESS_DETAIL | 家庭地址详细地址 | VARCHAR2(254) | FLAT_ADDR | HOME_ADDRESS_DETAIL |  |
| RESIDENCE_ADDRESS | 住宅地址 | VARCHAR2(254) | FLAT_ADDR | RESIDENCE_ADDRESS |  |
| RESIDENCE_ADDRESS_DETAIL | 住宅地址详细地址 | VARCHAR2(254) | FLAT_ADDR | RESIDENCE_ADDRESS_DETAIL |  |
| OFFICE_ADDRESS | 办公地址 | VARCHAR2(254) | FLAT_ADDR | OFFICE_ADDRESS |  |
| OFFICE_ADDRESS_DETAIL | 办公地址详细地址 | VARCHAR2(254) | FLAT_ADDR | OFFICE_ADDRESS_DETAIL |  |
| HOST_CUST_MNGR_POST_ID | 主办客户经理职位编号 | VARCHAR2(20) |  |  |  |
| HOST_CUST_MNGR_NAME | 主办客户经理名称 | VARCHAR2(60) |  |  |  |
| HOST_CUST_MNGR_EMP_ID | 主办客户经理工号 | VARCHAR2(6) |  |  |  |
| ORG_LEAD | 主办机构(归属机构) | VARCHAR2(7) |  |  |  |
| ORG_LEAD_PATH | 主办机构路径 | VARCHAR2(50) |  |  |  |
| COSPSR_CUST_MNGR_POST_ID | 信贷客户经理职位编号 | VARCHAR2(20) |  |  |  |
| COSPSR_CUST_MNGR_NAME | 信贷客户经理名称 | VARCHAR2(60) |  |  |  |
| COSPSR_CUST_MNGR_EMP_ID | 信贷客户经理工号 | VARCHAR2(6) |  |  |  |
| COSPSR_ORG | 信贷机构 | VARCHAR2(7) |  |  |  |
| COSPSR_ORG_PATH | 信贷机构路径 | VARCHAR2(50) |  |  |  |

### DWD_TX_ASET

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源表 | 源字段 | 映射规则 |
|----------|----------------|--------------|------|--------|----------|
| SEQ_ID | 流水号 | VARCHAR2(40) |  |  | T1.ZHANGHAO + T1.MXIXUHAO |
| CUST_ID | 客户编号 | VARCHAR2(21) | CBS_KDPA_ZHXINX | KEHUHAOO |  |
| CUST_TYP | 客户类型 | VARCHAR2(4) |  |  | 1' |
| ACCT_ID | 账户 | VARCHAR2(40) | CBS_KDPL_ZHMINX | ZHANGHAO |  |
| PRDKT_ID | 产品ID | VARCHAR2(40) | CBS_KDPL_ZHMINX | CHAPBHAO |  |
| TX_CHNL | 交易渠道 | VARCHAR2(10) | CBS_KDPL_ZHMINX | QDAOLEIX |  |
| TX_DATE | 交易日期 | VARCHAR2(10) | CBS_KDPL_ZHMINX | JIAOYIRQ |  |
| TX_TIME | 交易时间 | VARCHAR2(20) | CBS_KDPL_ZHMINX | JIAOYISJ |  |
| CCY_CD | 币种 | VARCHAR2(6) | CBS_KDPL_ZHMINX | JIAOYBIZ |  |
| AMT | 发生额 | NUMBER(18,4) | CBS_KDPL_ZHMINX | JIAOYIJE |  |
| TX_ORG | 交易机构 | VARCHAR2(20) | CBS_KDPL_ZHMINX | JYYYJIGO |  |
| OPRTR | 经办人 | VARCHAR2(20) | CBS_KDPL_ZHMINX | CAOZGUIY |  |
| LOAN_FLG | 借贷标识 | VARCHAR2(3) | CBS_KDPL_ZHMINX | JIEDAIBZ |  |
| ACCT_BAL | 账户余额 | NUMBER(18,4) | CBS_KDPL_ZHMINX | ZHANGHYE |  |
| TX_DSC | 交易说明 | VARCHAR2(200) | CBS_KDPL_ZHMINX | BEIZHUUU |  |
| OPNT_ACCT | 对方账户 | VARCHAR2(32) | CBS_KDPL_ZHMINX | DUIFKHZH |  |
| OPNT_ACCT_NAME_FST | 对方户名 | VARCHAR2(200) | CBS_KDPL_ZHMINX | DUIFMINC |  |
| OPNT_BK_KEEP | 对方行 | VARCHAR2(20) | CBS_KDPL_ZHMINX | DUIFJGDM |  |
| OPNT_NAME_BK | 对方行名 | VARCHAR2(200) | CBS_KDPL_ZHMINX | DUIFJGMC |  |
| ACCT_BLNG_ORG | 账户归属机构 | VARCHAR2(20) | CBS_KDPL_ZHMINX | KAIHJIGO |  |
| CARD_NO | 卡/折号 | VARCHAR2(30) | CBS_KDPL_ZHMINX | KEHUZHAO |  |
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR2(30) |  |  | 9999' |

### DWD_ACCT_DEPO

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源表 | 源字段 | 映射规则 |
|----------|----------------|--------------|------|--------|----------|
| CUST_ID | 客户编号 | VARCHAR2(20) | CBS_KDPA_ZHXINX | KEHUHAOO |  |
| CUST_TYP | 客户类型 | VARCHAR2(2) |  |  | 1' |
| ACCT_ID | 账户 | VARCHAR2(40) | CBS_KDPA_ZHXINX | ZHANGHAO |  |
| CARD_NO | 卡/折号 | VARCHAR2(40) | CBS_KDPA_ZHXINX | KEHUZHAO |  |
| PRDKT_ID | 产品编号 | VARCHAR2(30) | CBS_KDPF_CHPSHX | CHAPBHAO |  |
| PRDKT_NAME | 产品名称 | VARCHAR2(200) | CBS_KDPF_CHPSHX | CHANPSHM |  |
| PRDKT_CATE_BIG | 产品大类 | VARCHAR2(64) |  |  | (CASE<br>           WHEN T1.CUNKZLEI = '00' THEN '01'<br>           WHEN T1.CUNKZLEI IN ('01', '02', '03', '04','06','07','12','13','15','19','24','25') THEN '02'<br>           WHEN T1.CUNKZLEI = '29' THEN '03'<br>           WHEN T1.CUNKZLEI = '05' THEN '04'<br>           WHEN T1.CUNKZLEI = '26' THEN '05'<br>           ELSE T1.CUNKZLEI<br> END) PRDKT_CATE_BIG |
| ACCT_TYP | 账户类型 | VARCHAR2(10) | CBS_KDPA_KEHUZH | ZHHUFENL | (CASE<br>           WHEN T5.ZHHUFENL = '1' THEN '01'<br>           WHEN T5.ZHHUFENL = '2' THEN '02'<br>           WHEN T5.ZHHUFENL = '3' THEN '03'<br>           WHEN T5.ZHHUFENL = '4' THEN '04'<br>           ELSE T5.ZHHUFENL<br> END) ZHHUFENL |
| CCY_CD | 币种 | VARCHAR2(4) | CBS_KDPA_ZHXINX | HUOBDAIH |  |
| BAL | 余额 | NUMBER(20,2) | CBS_KDPA_ZHXINX | ZHHUYUEE |  |
| RMB_BAL | 折人民币余额 | NUMBER(20,2) | CRM_SYS_XTHLCS |  | T1.ZHHUYUEE * T4.HL |
| OPEN_ACCT_ORG | 归属机构 | VARCHAR2(6) | CBS_KDPA_ZHXINX | KAIHJIGO |  |
| OPEN_DATE | 开户日期 | VARCHAR2(10) | CBS_KDPA_ZHXINX | KAIHRIQI |  |
| RATE_INTRI | 利率 | NUMBER(20,2) | CBS_KDPA_ZHXINX | ZHIXLILV |  |
| INTRI_BGN_DATE | 起息日期 | VARCHAR2(10) | CBS_KDPA_ZHXINX | CSQIXIRQ |  |
| EXPR_DATE | 到期日期 | VARCHAR2(10) | CBS_KDPA_ZHXINX | DOQIRIQI |  |
| ACCT_CLOZ_DATE | 销户日期 | VARCHAR2(10) | CBS_KDPA_ZHXINX | XIOHRIQI |  |
| ACCT_STATE | 账户状态 | VARCHAR2(10) | CBS_KDPA_ZHXINX | ZHHUZTAI |  |
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR2(4) |  |  | 9999' |
| VCHR_TYP | 凭证类型 | VARCHAR2(10) | CBS_KCEV_KHPZHE | PINGZHZL |  |
| CUNQ | 存期 | VARCHAR2(10) | CBS_KDPA_ZHXINX | CUNQIIII |  |
| FIX_CURNT_FLG | 定活标志 | VARCHAR2(1) | CBS_KDPA_ZHXINX | FZCPLEIX |  |

### DWD_ACCT_LOAN

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源表 | 源字段 | 映射规则 |
|----------|----------------|--------------|------|--------|----------|
| CUST_ID | 客户编号 | VARCHAR2(20) | CUSTOMER_INFO | MFCUSTOMERID |  |
| CUST_TYP | 客户类型 | VARCHAR2(6) |  |  |  |
| ACCT_ID | 账号 | VARCHAR2(40) | ACCT_BUSINESS_ACCOUNT | AccountNo |  |
| PRDKT_ID | 产品编号 | VARCHAR2(40) | ACCT_LOAN | BusinessType |  |
| PRDKT_NAME | 产品名称 | VARCHAR2(100) | BUSINESS_TYPE | TypeName |  |
| PRDKT_CATE_BIG | 产品大类 | VARCHAR2(60) | BUSINESS_TYPE | BaseTypeNo |  |
| LOAN_ISSU_AMT | 借据金额 | NUMBER(20,2) | ACCT_LOAN | BusinessSum |  |
| LOAN_ISSU_DATE | 贷款发放日期 | VARCHAR2(10) | ACCT_LOAN | PutoutDate |  |
| BAL | 余额 | NUMBER(20,2) | ACCT_LOAN | NormalBalance+OverdueBalance |  |
| RATE_INTRI | 利率 | NUMBER(10,4) | ACCT_RATE_SEGMENT | BusinessRate |  |
| EXPR_DATE | 到期日期 | VARCHAR2(10) | ACCT_LOAN | MaturityDate |  |
| ACCT_STATE | 账户状态 | VARCHAR2(10) | ACCT_LOAN | LoanStatus |  |
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR2(4) |  |  |  |
| OPRT_ORG | 经办机构 | VARCHAR2(7) |  |  |  |
| IOU_NO | 借据号 | VARCHAR2(100) | ACCT_LOAN | SerialNo |  |
| INT_ARREARS_TTL | 欠息(合计) | NUMBER(20,2) | ACCT_LOAN | ACCRUEDINTEREST<br>OVERDUEINTEREST<br>PRINCIPALPENALTY<br>INTERESTPENALTY |  |
| REPAY_TYP | 还款方式 | VARCHAR2(4) | ACCT_RPT_SEGMENT | TermID |  |
| REPAY_ACCT_NO | 还款账号 | VARCHAR2(30) | ACCT_BUSINESS_ACCOUNT | AccountNo |  |
| CATE_5LVL | 五级分类 | VARCHAR2(2) | ACCT_LOAN | ClassifyResult |  |

### DWD_PRDKT_INFO

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源表 | 源字段 | 映射规则 |
|----------|----------------|--------------|------|--------|----------|
| PRDKT_ID | 产品编号 | VARCHAR2(40) |  |  |  |
| PRDKT_NAME | 产品名称 | VARCHAR2(100) |  |  |  |
| PRDKT_CATE_BIG | 产品大类 | VARCHAR2(10) |  |  |  |
| BGN_DATE | 开始日期 | VARCHAR2(10) |  |  |  |
| END_DATE | 结束日期 | VARCHAR2(10) |  |  |  |
| PRDKT_LINE | 产品条线 | VARCHAR2(10) |  |  |  |
| SUP_PRDKT_ID | 上级产品编号 | VARCHAR2(30) |  |  |  |
| MDL_BIZ_RATE_FEE | 中间业务费率 | NUMBER(18,4) |  |  |  |
| PRDKT_RATE | 产品利率 | NUMBER(18,4) |  |  |  |
| SYS_SRC | 系统来源 | VARCHAR2(6) |  |  |  |
| PRDKT_STATE | 产品状态(在售/停售) | VARCHAR2(10) |  |  |  |
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR2(30) |  |  |  |

### DWD_ACCT_FIN

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源表 | 源字段 | 映射规则 |
|----------|----------------|--------------|------|--------|----------|
| CUST_ID | 客户编号 | VARCHAR2(20) | t1_cust_info | host_cust_no |  |
| CUST_TYP | 客户类型 | VARCHAR2(2) |  |  |  |
| ACCT_ID | 账户 | VARCHAR2(40) | t1_cust_fnc_acct | acct_no |  |
| CARD_NO | 卡/折号 | VARCHAR2(30) | t1_cust_fnc_acct | card_no |  |
| PRDKT_ID | 产品ID | VARCHAR2(40) | td_prod_info | REGIST_CODE |  |
| PRDKT_NAME | 产品名称 | VARCHAR2(100) | td_prod_info | prod_name |  |
| PRDKT_CATE_BIG | 产品大类 | VARCHAR2(64) | td_prod_info | PROD_TYPE |  |
| ESTAB_DATE | 成立日期 | VARCHAR2(10) | td_prod_info | ESTABLISH_DATE |  |
| FIN_AMT | 理财余额 | NUMBER(20,2) | td_cust_vol | remain_vol |  |
| RATE_INTRI | 收益率 | NUMBER(20,2) | TD_PROD_NAV | TONOWCLIENTRATIO |  |
| ACCT_STATE | 状态 | VARCHAR2(10) | t1_cust_fnc_acct | ACCT_STATUS |  |
| INTRI_BGN_DATE | 起息日期 | VARCHAR2(10) | TD_PROD_INFO | VALUE_DATE |  |
| EXPR_DATE | 到期日期 | VARCHAR2(10) | TD_PROD_INFO | WINDING_DATE |  |
| OPRT_ORG | 归属机构 | VARCHAR2(7) | TD_PROD_INFO | TANO |  |
| CHNL_NO | 办理渠道 | VARCHAR2(10) | T1_CUST_FNC_ACCT | ISS_BANK_CODE |  |
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR2(4) |  |  |  |
| ISSU_ORG | 发行机构 | VARCHAR2(6) | TD_PROD_INFO | TANO |  |
| ISSU_DATE | 办理日期 | VARCHAR2(10) | T1_CUST_FNC_ACCT | CRT_DATE |  |
| RISK_LVL | 风险等级 | VARCHAR2(2) | TD_PROD_INFO | PROD_RISK_LEVEL |  |

### DWD_ACCT_INSUR

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源表 | 源字段 | 映射规则 |
|----------|----------------|--------------|------|--------|----------|
| CUST_ID | 客户编号 | VARCHAR2(20) | ib_list_plat | b.user_id |  |
| CUST_TYP | 客户类型 | VARCHAR2(4) |  |  |  |
| ACCT_ID | 账户 | VARCHAR2(40) | YBT_POLICY_BASE_INFO | c.ACC_NO |  |
| PRDKT_ID | 产品ID | VARCHAR2(40) | YBT_PRODUCT_INFO | e.PRODUCT_ID |  |
| PRDKT_NAME | 产品名称 | VARCHAR2(100) | YBT_PRODUCT_INFO | e.PRODUCT_NAME |  |
| PRDKT_CATE_BIG | 产品大类 | VARCHAR2(64) | YBT_PRODUCT_INFO | e.PRODUCT_BIG_TYPE |  |
| INSUR_BID_FORM_NO | 投保单号 | VARCHAR2(40) | YBT_POLICY_BASE_INFO | c.CONT_NO |  |
| TX_DATE | 交易日期 | VARCHAR2(10) | YBT_POLICY_BASE_INFO | c.ACCEPT_DATE |  |
| TX_ORG | 交易机构 | VARCHAR2(7) | YBT_POLICY_BASE_INFO | c.THROW_COM |  |
| TX_CHNL | 交易渠道 | VARCHAR2(10) | YBT_POLICY_BASE_INFO | c.CONT_SOURCE |  |
| MKT_ORG | 归属机构 | VARCHAR2(7) | YBT_POLICY_BASE_INFO | c.THROW_COM |  |
| BGN_INSUR_DATE | 起保日期 | VARCHAR2(10) | YBT_POLICY_BASE_INFO | c.VALI_DATE |  |
| CANCL_INSUR_DATE | 退保日期 | VARCHAR2(10) |  |  |  |
| INSUR_PERIOD_TYP | 保险期间类型 | VARCHAR2(2) | YBT_POLICY_INSURANCE_INFO | d.PAY_PER_UNIT |  |
| INSUR_PERIOD | 保险期间值 | VARCHAR2(6) | YBT_POLICY_INSURANCE_INFO | d.PAY_PER_NUM |  |
| PAY_PERIOD_TYP | 缴费期间类型 | VARCHAR2(2) | YBT_POLICY_INSURANCE_INFO | d.VALID_PER_UNIT |  |
| PAY_PERIOD | 缴费期间值 | VARCHAR2(6) | YBT_POLICY_INSURANCE_INFO | d.VALID_PER_NUM |  |
| PAY_PATRN | 缴费方式 | VARCHAR2(2) | YBT_POLICY_INSURANCE_INFO | d.PAY_TYPE |  |
| INSUR_AMT | 保费金额 | NUMBER(20,2) | YBT_POLICY_FEE_LIST | a.ORD_AMT |  |
| POLICY_STATE | 保单状态 | VARCHAR2(10) | YBT_POLICY_BASE_INFO | c.CONT_STATUS |  |
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR2(4) | YBT_POLICY_FEE_LIST | a.TRAN_TYPE |  |

### DWD_CUST_SIGN_CTRAKT

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源表 | 源字段 | 映射规则 |
|----------|----------------|--------------|------|--------|----------|
| CUST_ID | 客户编号 | VARCHAR2(20) | T01_P_CUST_INFO | t0.ECIF_CUST_NO |  |
| CTRAKT_ACCT | 签约账户 | VARCHAR2(40) | T02_A_CUST_SIGN_REL | t1.SIGN_ACC_NO |  |
| CTRAKT_TYP | 签约类型 | VARCHAR2(6) | T02_A_CUST_SIGN_REL | t1.SIGN_TYPE |  |
| CTRAKT_DATE | 签约日期 | VARCHAR2(10) | T05_A_ACC_SIGN | t2.SIGN_DATE |  |
| PHONE_NO | 手机号 | VARCHAR2(32) | T05_A_ACC_SIGN | t2.SIGN_REL_PHONE |  |
| CTRAKT_ORG | 签约机构 | VARCHAR2(6) | T05_A_ACC_SIGN | t2.SIGN_ORG |  |
| CTRAKT_OPRTR | 签约经办人 | VARCHAR2(20) | T05_A_ACC_SIGN | t2.ATTN_NAME |  |
| CTRAKT_STATE | 签约状态 | VARCHAR2(2) | T02_A_CUST_SIGN_REL | t1.SIGN_STATE |  |
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR2(4) |  |  |  |

### DWD_CUST_INDIV_CRDT

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源表 | 源字段 | 映射规则 |
|----------|----------------|--------------|------|--------|----------|
| CUST_ID | 客户编号 | VARCHAR2(21) | CUSTOMER_INFO | MFCUSTOMERID |  |
| CUST_NAME | 客户名称 | VARCHAR2(200) | CUSTOMER_INFO | CustomerName |  |
| CRDT_AGRE_NO | 授信协议号 | VARCHAR2(40) | BUSINESS_CONTRACT | Serialno |  |
| CRDT_AGRE_TYP | 授信协议类型 | VARCHAR2(20) |  |  |  |
| CRDT_TTL_LMT | 授信额度 | NUMBER(18,4) | BUSINESS_CONTRACT | BusienssSum |  |
| BGN_DATE | 开始日期 | VARCHAR2(10) | BUSINESS_CONTRACT | PutoutDate |  |
| EXPR_DATE | 到期日期 | VARCHAR2(10) | BUSINESS_CONTRACT | MaturityDate |  |
| CRDT_STATUS | 授信状态 | VARCHAR2(20) |  |  |  |
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR2(30) |  |  |  |

### DWD_CUST_CTRAKT_INFO

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源表 | 源字段 | 映射规则 |
|----------|----------------|--------------|------|--------|----------|
| CUST_ID | 客户编号 | VARCHAR2(21) | CUSTOMER_INFO | MFCUSTOMERID |  |
| CTRAKT_ID | 合同编号 | VARCHAR2(60) | BUSINESS_CONTRACT | Serialno |  |
| LOAN_ACCT | 贷款账号 | VARCHAR2(80) |  |  |  |
| CRDT_LMT | 授信额度 | NUMBER(24,4) | BUSINESS_CONTRACT | BusienssSum |  |
| LOAN_BAL | 贷款余额 | NUMBER(24,4) | BUSINESS_CONTRACT | Balance |  |
| GUARANT_MODE | 担保方式 | VARCHAR2(80) | BUSINESS_CONTRACT | VouchType |  |
| CATE_5LVL | 五级分类 | VARCHAR2(30) | BUSINESS_CONTRACT | ClassifyResult |  |
| CCY_CD | 币种 | VARCHAR2(10) | BUSINESS_CONTRACT | BusinessCurrency |  |
| RATE_INTRI | 利率 | NUMBER(18,4) | ACCT_RATE_SEGMENT | BusinessRate |  |
| CONTR_AMT | 合同金额 | NUMBER(18,4) | BUSINESS_CONTRACT | BusienssSum |  |
| BGN_DATE | 发放日期 | VARCHAR2(10) | BUSINESS_CONTRACT | PutoutDate |  |
| END_DATE | 结束日期 | VARCHAR2(10) | BUSINESS_CONTRACT | MaturityDate |  |
| OPRTR | 经办人 | VARCHAR2(30) | BUSINESS_CONTRACT | ManageUserID |  |
| OPRT_ORG | 经办机构 | VARCHAR2(7) | BUSINESS_CONTRACT | ManageOrgID |  |
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR2(30) |  |  |  |

### DWD_CUST_INDIV_RISK_INVST

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源表 | 源字段 | 映射规则 |
|----------|----------------|--------------|------|--------|----------|
| CUST_ID | 客户编号 | VARCHAR2(21) | T4_CUST_RISK_ASSESS_INFO | host_cust_no |  |
| INVEST_TYP | 投资类型 | VARCHAR2(6) |  |  |  |
| ESTIM_RSLT | 评估结果 | VARCHAR2(6) | T4_CUST_RISK_ASSESS_INFO | CUST_RISK_LEVEL |  |
| SCORE | 分数 | NUMBER(22) | T01_P_CUST_INFO | CUST_EVAL_LEVEL |  |
| RISK_LVL | 风险级别 | VARCHAR2(6) | T4_CUST_RISK_ASSESS_INFO | CUST_RISK_LEVEL |  |
| ESTIM_DATE | 评估日期 | VARCHAR2(10) | T4_CUST_RISK_ASSESS_INFO | ASSESS_DATE |  |
| EXPR_DATE | 到期日期 | VARCHAR2(10) | T4_CUST_RISK_ASSESS_INFO | INVALID_DATE |  |
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR2(30) |  |  |  |

### DWD_SYS_ORG

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源表 | 源字段 | 映射规则 |
|----------|----------------|--------------|------|--------|----------|
| ORG_ID | 机构编号 | VARCHAR2 |  |  |  |
| SUP_ORG_ID | 上级机构编号 | VARCHAR2 |  |  |  |
| ORG_PATH | 机构路径 | VARCHAR2 |  |  |  |
| ORG_NAME | 机构名称 | VARCHAR2 |  |  |  |
| SUP_ORG_NAME | 上级机构名称 | VARCHAR2 |  |  |  |
| DIRECT_UNDER_ORG | 直属机构 | VARCHAR2 |  |  |  |
| ORG_TYP | 机构类型 | VARCHAR2 |  |  |  |
| ORG_HARCY | 机构层级 | VARCHAR2 |  |  |  |
| ORG_ADDRS | 机构地址 | VARCHAR2 |  |  |  |
| ORG_STATE | 机构状态 | VARCHAR2 |  |  |  |
| DSPLY_SEQ | 显示顺序 | NUMBER |  |  |  |
| CREATR | 创建人 | VARCHAR2 | SYS_ORG | CREATR |  |
| CREAT_TIME | 创建时间 | VARCHAR2 |  |  |  |
| CREAT_ORG | 创建机构 | VARCHAR2 |  |  |  |
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR2 |  |  |  |
| HR_MS_ORG_ID | 人力资源系统机构号 | VARCHAR2 |  |  |  |
| ORG_LGTUD | 机构经度 | VARCHAR2 |  |  |  |
| ORG_LATTUD | 机构纬度 | VARCHAR2 |  |  |  |
| ORG_RSPONR | 机构负责人 | VARCHAR2 |  |  |  |
| ORG_TEL | 机构电话 | VARCHAR2 |  |  |  |

### DWD_CRM_SYS_XTHLCS

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源表 | 源字段 | 映射规则 |
|----------|----------------|--------------|------|--------|----------|
| HUOBDAIH | 货币代号 | VARCHAR2 |  |  |  |
| PJDANWEI | 牌价单位 | NUMBER |  |  |  |
| HUOBFHAO | 货币符号 | VARCHAR2 |  |  |  |
| ZHNGJJIA | 中间价 | NUMBER |  |  |  |
| HL | 汇率 | NUMBER |  |  |  |

### DWD_CUST_INDV_KYC

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源表 | 源字段 | 映射规则 |
|----------|----------------|--------------|------|--------|----------|
| CUST_ID | 客户编号 | VARCHAR2 |  |  |  |
| CUST_NM | 客户名称 | VARCHAR2 |  |  |  |
| BK_OUTER_DEPO | 行外存款 | NUMBER |  |  |  |
| BK_OUTER_FIN | 行外理财 | NUMBER |  |  |  |
| BK_OUTER_FUND | 行外基金 | NUMBER |  |  |  |
| BK_OUTER_INSUR | 行外保险 | NUMBER |  |  |  |
| BK_OUTER_GOLD | 行外贵金属 | NUMBER |  |  |  |
| STK_INVEST | 股票投资 | VARCHAR2 |  |  |  |
| ESTT_INF | 住宅信息 | VARCHAR2 |  |  |  |
| PROP_OWNER_CERT_NO | 房产证号 | VARCHAR2 |  |  |  |
| HOUSE_AREA | 面积 | NUMBER |  |  |  |
| IS_HOUSE_MORTGAGED | 是否抵押 | VARCHAR2 |  |  |  |
| RES_ADDRS | 地址 | VARCHAR2 |  |  |  |
| SHOP_INVEST | 商铺投资 | VARCHAR2 |  |  |  |
| VIKL_INF | 车辆信息 | VARCHAR2 |  |  |  |
| VEHICLE_PLATE_NO | 车牌号 | VARCHAR2 |  |  |  |
| USAGE_NATURE | 使用性质 | VARCHAR2 |  |  |  |
| IS_CAR_LOAN | 是否有车贷 | VARCHAR2 |  |  |  |
| IS_CAR_MORTGAGED | 是否抵押 | VARCHAR2 |  |  |  |
| MTH_INCOM | 月收入 | NUMBER |  |  |  |
| YR_INCOM | 年收入 | NUMBER |  |  |  |
| BK_OUTER_LOAN_BAL | 行外贷款余额 | NUMBER |  |  |  |
| BK_OUTER_CRDT_LMT | 行外授信额度 | NUMBER |  |  |  |
| AVAIL_LMT | 可用额度 | NUMBER |  |  |  |
| CREATR | 创建人 | VARCHAR2 |  |  |  |
| CREAT_ORG | 创建机构 | VARCHAR2 |  |  |  |
| CREAT_TIME | 创建时间 | VARCHAR2 |  |  |  |

---

*本文件由对应 Excel 模型同步生成；Excel 更新后必须重新生成本文件。
