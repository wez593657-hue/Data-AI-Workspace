# 到期承接统计表

**表名**: `ADS_CUST_DEADLINE_RMND_STATIS`  
**中文名**: 到期承接统计表  
**来源**: Mapping Excel (ADS应用层数据模型)  
**更新时间**: 2026-07-29  

## 字段列表

| 字段名 | 数据类型 | 中文名 | 备注 |
|---|---|---|---|
| PERSN_LEGAL_BK_CODE | VARCHAR2(4) | 法人行号 | |
| DATA_DATE | VARCHAR2(8) | 数据日期 | |
| STATIS_OBJ | VARCHAR2(20) | 统计对象 | |
| STATIS_CYCLE | VARCHAR2(2) | 统计周期 | |
| STATIS_TYP | VARCHAR2(2) | 承接类型1-存款2-理财 | |
| EXPR_CUST_CNT | NUMBER(8) | 已到期客户数 | |
| TTL_EXPR_CUST_CNT | NUMBER(8) | 总到期客户数 | |
| EXPR_AMT | NUMBER(20,2) | 已到期金额 | |
| TTL_EXPR_AMT | NUMBER(20,2) | 总到期金额 | |
| CUST_UNDTAKE_RATE | NUMBER(20,2) | 客户承接率 | |
| ASSET_KEEP_RATE | NUMBER(20,2) | 资产留存率 | |
| ASSET_UNDTAKE_RATE | NUMBER(20,2) | 资产承接率 | |
| DEPO_TO_FIN_CONVRS_RATE | NUMBER(20,2) | 存款转理财转化率 | |
| INSUR_CONVRS_RATE | NUMBER(20,2) | 保险转化率 | |
| FIN_TO_DEPO_CONVRS_RATE | NUMBER(20,2) | 理财转存款转化率 | |
