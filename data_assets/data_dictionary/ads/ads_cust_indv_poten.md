# ADS数据字典 - ADS_CUST_INDV_POTEN

## 表信息

| 属性 | 值 |
|------|------|
| 层级 | ADS - 应用数据层 |
| 表名 | ADS_CUST_INDV_POTEN |
| 中文名称 | 零售潜在客户信息 |
| 更新时间 | 2026-07-17 |

## 字段列表

| 字段名 | 字段中文说明 | 数据类型 | 长度 | 是否为空 | 默认值 | 主键 | 外键 | 枚举说明 | 业务含义 |
|--------|-------------|----------|------|----------|--------|------|------|----------|----------|
| POTEN_CUST_ID | 潜在客户号(自增键) | VARCHAR2(40) | - | - | - | - | - | - | - |
| POTEN_CUST_NAME | 潜在客户名称 | VARCHAR2(100) | - | - | - | - | - | - | - |
| POTEN_TYP | 潜客类型 | VARCHAR2(6) | - | - | - | - | - | - | - |
| POTEN_CUST_TYP | 潜在客户类型 | VARCHAR2(6) | - | - | - | - | - | - | - |
| GENDER | 性别 | VARCHAR2(6) | - | - | - | - | - | - | - |
| CERT_TYP | 证件类型 | VARCHAR2(6) | - | - | - | - | - | - | - |
| CERT_ID | 证件号码 | VARCHAR2(32) | - | - | - | - | - | - | - |
| TEL_NO | 联系电话 | VARCHAR2(32) | - | - | - | - | - | - | - |
| INTENT_DSC | 备注说明 | VARCHAR2(400) | - | - | - | - | - | - | - |
| DTL_ADDRS | 居住地址 | VARCHAR2(400) | - | - | - | - | - | - | - |
| CREATR | 创建人 | VARCHAR2(20) | - | - | - | - | - | - | - |
| CREAT_TIME | 创建时间 | VARCHAR2(20) | - | - | - | - | - | - | - |
| POTEN_CUST_STATE | 潜在客户状态 | VARCHAR2(6) | - | - | - | - | - | - | - |
| LPR_ID | 法人行号 | VARCHAR2(4) | - | - | - | - | - | - | - |
| SRC_TYP | 来源类型 | VARCHAR2(6) | - | - | - | - | - | - | - |
| MKT_PERSN | 客户经理 | VARCHAR2(20) | - | - | - | - | - | - | - |
| ALLO_DATE | 分配日期(创建时和创建日期一致) | VARCHAR2(8) | - | - | - | - | - | - | - |
| MKT_ORG | 归属机构 | VARCHAR2(6) | - | - | - | - | - | - | - |
| SERV_ENTER | 工作单位 | VARCHAR2(200) | - | - | - | - | - | - | - |
| POST | 职位 | VARCHAR2(6) | - | - | - | - | - | - | - |
| MTH_INCOM | 月收入 | NUMBER(20,2) | - | - | - | - | - | - | - |
| YR_INCOM | 年收入 | NUMBER(20,2) | - | - | - | - | - | - | - |
| RMARK | 备注 | VARCHAR2(400) | - | - | - | - | - | - | - |
| INF_KLKT_DATE | 潜客转化日期 | VARCHAR2(10) | - | - | - | - | - | - | - |
| UNIT_ADDRS | 工作单位地址 | VARCHAR2(200) | - | - | - | - | - | - | - |
| INTN_PRDKT | 意向产品 | VARCHAR2(60) | - | - | - | - | - | - | - |
| NO_BAT | 批次号 | VARCHAR2(40) | - | - | - | - | - | - | - |
| CUST_ID | 转化后核心客户号 | VARCHAR2(21) | - | - | - | - | - | - | - |
| POT_CNVRT_PRDKT | 潜客转化产品 | VARCHAR2(60) | - | - | - | - | - | - | - |
| POT_CNVRT_ORG | 潜客转化机构 | VARCHAR2(6) | - | - | - | - | - | - | - |

---
*数据字典版本: v1.0 | 生成时间: 2026-07-17*
