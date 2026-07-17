<!--
 * Mapping 示例: SAP 客户数据同步到 CRM
 * 参考文档: docs/08_Mapping.md
 -->

========================================
来源系统: SAP
来源表: sap_customer
目标系统: CRM
目标表: crm_customer
========================================
描述: 客户信息从 SAP 系统同步到 CRM 系统
同步方式: 增量同步（基于 UPDATE_TIME）
负责人: 【待确认】
更新时间: 2026-07-17

| 序号 | 来源系统 | 来源表 | 来源字段 | 目标表 | 目标字段 | 转换规则 | 默认值 | 是否允许为空 | 上游来源 | 下游影响 |
|------|----------|--------|----------|--------|----------|----------|--------|--------------|----------|----------|
| 1 | SAP | sap_customer | cust_id | crm_customer | customer_id | 直接映射，去除前后空格 | - | NOT NULL | SAP → sap_customer → cust_id | crm_order, crm_payment, crm_contact, crm_address |
| 2 | SAP | sap_customer | cust_name | crm_customer | customer_name | 直接映射，去除前后空格 | - | NOT NULL | SAP → sap_customer → cust_name | 报表系统, 客户分析 |
| 3 | SAP | sap_customer | cust_code | crm_customer | customer_code | 直接映射，去除前后空格 | - | NOT NULL | SAP → sap_customer → cust_code | 唯一索引 |
| 4 | SAP | sap_customer | cust_type | crm_customer | customer_type | 'P'→'PERSONAL', 'E'→'ENTERPRISE', 其他→'UNKNOWN' | PERSONAL | NULL | SAP → sap_customer → cust_type | 客户分类统计 |
| 5 | SAP | sap_customer | cust_status | crm_customer | customer_status | 'Y'→'ACTIVE', 'N'→'INACTIVE', 其他→'UNKNOWN' | ACTIVE | NULL | SAP → sap_customer → cust_status | 业务查询, 订单筛选 |
| 6 | SAP | sap_customer | industry | crm_customer | industry | 直接映射，去除前后空格 | - | NULL | SAP → sap_customer → industry | 行业分析 |
| 7 | SAP | sap_customer | region | crm_customer | region | 直接映射，去除前后空格 | - | NULL | SAP → sap_customer → region | 区域分析 |
| 8 | SAP | sap_customer | contact_phone | crm_customer | contact_phone | 直接映射，去除前后空格 | - | NULL | SAP → sap_customer → contact_phone | 客户联系 |
| 9 | SAP | sap_customer | contact_email | crm_customer | contact_email | 直接映射，去除前后空格 | - | NULL | SAP → sap_customer → contact_email | 客户联系 |
| 10 | SAP | sap_customer | create_time | crm_customer | create_time | 格式转换 'YYYY/MM/DD HH24:MI:SS' → TIMESTAMP | NOW() | NOT NULL | SAP → sap_customer → create_time | 数据审计 |
| 11 | SAP | sap_customer | update_time | crm_customer | update_time | 格式转换 'YYYY/MM/DD HH24:MI:SS' → TIMESTAMP | NULL | NULL | SAP → sap_customer → update_time | 增量同步 |
| 12 | 系统自动 | - | - | crm_customer | etl_time | ETL 执行时设置为当前时间 | NULL | NULL | 系统自动 | ETL 监控 |
