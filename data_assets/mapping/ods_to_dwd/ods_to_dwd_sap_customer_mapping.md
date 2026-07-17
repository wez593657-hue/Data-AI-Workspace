# ODS → DWD Mapping - SAP 客户信息

## Mapping 信息

| 属性 | 值 |
|------|------|
| 来源系统 | SAP |
| 来源层级 | ODS |
| 来源表 | ods_sap_customer |
| 目标层级 | DWD |
| 目标表 | dwd_crm_customer |
| 同步方式 | 增量同步（基于 UPDATE_TIME） |
| 负责人 | 【待确认】 |
| 更新时间 | 2026-07-17 |

## 字段 Mapping

| 序号 | 来源系统 | 来源表 | 来源字段 | 目标表 | 目标字段 | 转换规则 | 默认值 | 是否允许为空 | 上游来源 | 下游影响 |
|------|----------|--------|----------|--------|----------|----------|--------|--------------|----------|----------|
| 1 | SAP | ods_sap_customer | CUST_ID | dwd_crm_customer | customer_id | 直接映射，去除前后空格 | - | NOT NULL | SAP → S_CUSTOMER → CUST_ID | dwd_crm_order, dwd_crm_payment |
| 2 | SAP | ods_sap_customer | CUST_NAME | dwd_crm_customer | customer_name | 直接映射，去除前后空格 | - | NOT NULL | SAP → S_CUSTOMER → CUST_NAME | 报表系统, 客户分析 |
| 3 | SAP | ods_sap_customer | CUST_CODE | dwd_crm_customer | customer_code | 直接映射，去除前后空格 | - | NOT NULL | SAP → S_CUSTOMER → CUST_CODE | 唯一索引 |
| 4 | SAP | ods_sap_customer | CUST_TYPE | dwd_crm_customer | customer_type | 'P'→'PERSONAL', 'E'→'ENTERPRISE', 其他→'UNKNOWN' | PERSONAL | NULL | SAP → S_CUSTOMER → CUST_TYPE | 客户分类统计 |
| 5 | SAP | ods_sap_customer | CUST_STATUS | dwd_crm_customer | customer_status | 'Y'→'ACTIVE', 'N'→'INACTIVE', 其他→'UNKNOWN' | ACTIVE | NULL | SAP → S_CUSTOMER → CUST_STATUS | 业务查询, 订单筛选 |
| 6 | SAP | ods_sap_customer | INDUSTRY | dwd_crm_customer | industry | 直接映射，去除前后空格 | - | NULL | SAP → S_CUSTOMER → INDUSTRY | 行业分析 |
| 7 | SAP | ods_sap_customer | REGION | dwd_crm_customer | region | 直接映射，去除前后空格 | - | NULL | SAP → S_CUSTOMER → REGION | 区域分析 |
| 8 | SAP | ods_sap_customer | CONTACT_PHONE | dwd_crm_customer | contact_phone | 直接映射，去除前后空格 | - | NULL | SAP → S_CUSTOMER → CONTACT_PHONE | 客户联系 |
| 9 | SAP | ods_sap_customer | CONTACT_EMAIL | dwd_crm_customer | contact_email | 直接映射，去除前后空格 | - | NULL | SAP → S_CUSTOMER → CONTACT_EMAIL | 客户联系 |
| 10 | SAP | ods_sap_customer | CREATE_TIME | dwd_crm_customer | create_time | 格式转换 'YYYY/MM/DD HH24:MI:SS' → TIMESTAMP | NOW() | NOT NULL | SAP → S_CUSTOMER → CREATE_TIME | 数据审计 |
| 11 | SAP | ods_sap_customer | UPDATE_TIME | dwd_crm_customer | update_time | 格式转换 'YYYY/MM/DD HH24:MI:SS' → TIMESTAMP | NULL | NULL | SAP → S_CUSTOMER → UPDATE_TIME | 增量同步 |
| 12 | 系统自动 | - | - | dwd_crm_customer | etl_time | ETL执行时设置为当前时间 | NULL | NULL | 系统自动 | ETL监控 |
| 13 | 系统自动 | - | - | dwd_crm_customer | etl_batch_id | ETL批次ID | - | NULL | 系统自动 | ETL追踪 |
