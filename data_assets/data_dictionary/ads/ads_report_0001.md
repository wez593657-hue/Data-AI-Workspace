# 机构客户层级资产月报表

**表名**: `ADS_REPORT_0001`  
**中文名**: 机构客户层级资产月报表  
**来源**: Mapping Excel (ADS应用层数据模型)  
**更新时间**: 2026-07-29  

## 字段列表

| 字段名 | 数据类型 | 中文名 | 备注 |
|---|---|---|---|
| DATA_DATE | VARCHAR2(8) | 数据日期 | |
| BLNG_BRCH | VARCHAR2(7) | 所属分行 | |
| BLNG_BRCH_SUB | VARCHAR2(7) | 所属支行 | |
| BLNG_BRCH_NET | VARCHAR2(7) | 所属网点 | |
| ORG_PATH | VARCHAR2(20) | 机构路径 | |
| CUST_LVL | VARCHAR2(2) | 客户等级 | |
| CUST_CNT | NUMBER(8) | 客户数 | |
| AUM_BAL | NUMBER(20,2) | AUM余额 | |
| AUM_MTH_AVG | NUMBER(20,2) | AUM月日均 | |
| COMN_FIXD_BAL | NUMBER(20,2) | 普通定期余额 | |
| LEHUI_BAL | NUMBER(20,2) | 乐惠存余额 | |
| LARGEDP_BAL | NUMBER(20,2) | 大额存单余额 | |
| FIXD_SUM | NUMBER(20,2) | 定期合计 | |
| DEPO_CURNT_DEPO_BAL | NUMBER(20,2) | 活期余额 | |
| DEPO_SUM | NUMBER(20,2) | 存款合计 | |
| BIZ_SELF_FIN_BAL | NUMBER(20,2) | 自营理财余额 | |
| PROXY_SELL_FIN_BAL | NUMBER(20,2) | 代销理财余额 | |
| FIN_BAL_SUM | NUMBER(20,2) | 理财余额合计 | |
| INSUR_BAL | NUMBER(20,2) | 保险余额 | |
| LOAN_BAL | NUMBER(20,2) | 贷款余额 | |
