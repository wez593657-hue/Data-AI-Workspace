# 到期承接明细表

**表名**: `ADS_CUST_DEADLINE_RMND_DTL`  
**中文名**: 到期承接明细表  
**来源**: Mapping Excel (ADS应用层数据模型)  
**更新时间**: 2026-07-29  

## 字段列表

| 字段名 | 数据类型 | 中文名 | 备注 |
|---|---|---|---|
| PERSN_LEGAL_BK_CODE | VARCHAR2(4) | 法人行号 | |
| DATA_DATE | VARCHAR2(8) | 数据日期 | |
| CUST_ID | VARCHAR2(20) | 客户编号 | |
| CUST_NAME | VARCHAR2(100) | 客户名称 | |
| CUST_LVL | VARCHAR2(2) | 客户等级 | |
| DEPO_CURNT_DEPO_BAL | NUMBER(20,2) | 活期余额 | |
| FIXD_DEPO_BAL | NUMBER(20,2) | 定期余额 | |
| FIN_AMT | NUMBER(20,2) | 理财余额 | |
| STAT_PERD | VARCHAR2(2) | 统计周期 | |
| STATIS_TYP | VARCHAR2(2) | 承接类型1-存款2-理财 | |
| EXPR_AMT | NUMBER(20,2) | 到期金额 | |
| MATURE_TTL_AMT | NUMBER(20,2) | 到期总金额 | |
| TAKE_RATE | NUMBER(10,2) | 承接率 | |
| FIX_DEPO_MATURE_AMT | NUMBER(20,2) | 定期存款到期金额 | |
| FIX_DEPO_MATURE_TTL_AMT | NUMBER(20,2) | 定期存款到期总金额 | |
| FIX_DEPO_TAKE_RATE | NUMBER(10,2) | 定期存款承接率 | |
| CNTCT_STATE | VARCHAR2(1) | 接触状态 | |
| UNDTAKE_STATE | VARCHAR2(1) | 承接状态 | |
| FIXED_FIN_MATURE_TRAN_INSUR_AMT | NUMBER(20,2) | 定期理财到期转保险金额 | |
| FIN_MATURE_TRAN_FIXED_AMT | NUMBER(20,2) | 理财到期转定期金额 | |
| FIXED_MATURE_TRAN_FIN_AMT | NUMBER(20,2) | 定期到期转理财金额 | |
| FRST_MATURE_PK_BF_DAY_AUM_BAL | NUMBER(20,2) | 本期第一笔到期产品前一日AUM余额 | |
| LAST_END_DATE | VARCHAR2(8) | 本期最后一笔到期产品日期 | |
| POST_ID | VARCHAR2(20) | 管户经理 | |
| ORG_ID | VARCHAR2(7) | 归属机构 | |
