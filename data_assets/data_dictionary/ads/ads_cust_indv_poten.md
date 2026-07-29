# 零售潜在客户信息

**表名**: `ADS_CUST_INDV_POTEN`  
**中文名**: 零售潜在客户信息  
**来源**: Mapping Excel (ADS应用层数据模型)  
**更新时间**: 2026-07-29  

## 字段列表

| 字段名 | 数据类型 | 中文名 | 备注 |
|---|---|---|---|
| POTEN_CUST_ID | VARCHAR2(40) | 潜在客户号(自增键) | |
| POTEN_CUST_NAME | VARCHAR2(100) | 潜在客户名称 | |
| POTEN_TYP | VARCHAR2(6) | 潜客类型 | |
| POTEN_CUST_TYP | VARCHAR2(6) | 潜在客户类型 | |
| GENDER | VARCHAR2(6) | 性别 | |
| CERT_TYP | VARCHAR2(6) | 证件类型 | |
| CERT_ID | VARCHAR2(32) | 证件号码 | |
| TEL_NO | VARCHAR2(32) | 联系电话 | |
| INTENT_DSC | VARCHAR2(400) | 备注说明 | |
| DTL_ADDRS | VARCHAR2(400) | 居住地址 | |
| CREATR | VARCHAR2(20) | 创建人 | |
| CREAT_TIME | VARCHAR2(20) | 创建时间 | |
| POTEN_CUST_STATE | VARCHAR2(6) | 潜在客户状态 | |
| LPR_ID | VARCHAR2(4) | 法人行号 | |
| SRC_TYP | VARCHAR2(6) | 来源类型 | |
| MKT_PERSN | VARCHAR2(20) | 客户经理 | |
| ALLO_DATE | VARCHAR2(8) | 分配日期(创建时和创建日期一致) | |
| MKT_ORG | VARCHAR2(7) | 归属机构 | |
| SERV_ENTER | VARCHAR2(200) | 工作单位 | |
| POST | VARCHAR2(6) | 职位 | |
| MTH_INCOM | NUMBER(20,2) | 月收入 | |
| YR_INCOM | NUMBER(20,2) | 年收入 | |
| INF_KLKT_DATE | VARCHAR2(10) | 潜客转化日期 | |
| UNIT_ADDRS | VARCHAR2(200) | 工作单位地址 | |
| INTN_PRDKT | VARCHAR2(60) | 意向产品 | |
| NO_BAT | VARCHAR2(40) | 批次号 | |
| CUST_ID | VARCHAR2(21) | 转化后核心客户号 | |
| POT_CNVRT_PRDKT | VARCHAR2(60) | 潜客转化产品 | |
| POT_CNVRT_ORG | VARCHAR2(6) | 潜客转化机构 | |
