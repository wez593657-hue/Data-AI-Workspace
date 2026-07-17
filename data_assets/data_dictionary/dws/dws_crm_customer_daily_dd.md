# DWS 层数据字典 - CRM 客户日汇总表

## 表信息

| 属性 | 值 |
|------|------|
| 表名 | dws_crm_customer_daily |
| 中文名称 | DWS_CRM客户日汇总表 |
| 描述 | 按天汇总的CRM客户统计数据 |
| 数据来源 | DWD层 dwd_crm_customer |
| 负责人 | 【待确认】 |
| 更新时间 | 2026-07-17 |

## 字段列表

| 字段名 | 字段中文说明 | 数据类型 | 长度 | 是否为空 | 默认值 | 主键 | 外键 | 枚举说明 | 数据来源 | 负责人 | 更新时间 |
|--------|-------------|----------|------|----------|--------|------|------|----------|----------|--------|----------|
| stat_date | 统计日期 | DATE | - | NOT NULL | - | PRIMARY KEY | - | - | 系统自动 | 【待确认】 | 2026-07-17 |
| total_count | 客户总数 | INT | - | NULL | 0 | - | - | - | dwd_crm_customer | 【待确认】 | 2026-07-17 |
| active_count | 活跃客户数 | INT | - | NULL | 0 | - | - | - | dwd_crm_customer (customer_status='ACTIVE') | 【待确认】 | 2026-07-17 |
| inactive_count | 非活跃客户数 | INT | - | NULL | 0 | - | - | - | dwd_crm_customer (customer_status='INACTIVE') | 【待确认】 | 2026-07-17 |
| personal_count | 个人客户数 | INT | - | NULL | 0 | - | - | - | dwd_crm_customer (customer_type='PERSONAL') | 【待确认】 | 2026-07-17 |
| enterprise_count | 企业客户数 | INT | - | NULL | 0 | - | - | - | dwd_crm_customer (customer_type='ENTERPRISE') | 【待确认】 | 2026-07-17 |
| new_add_count | 新增客户数 | INT | - | NULL | 0 | - | - | - | dwd_crm_customer (create_time=stat_date) | 【待确认】 | 2026-07-17 |
| lost_count | 流失客户数 | INT | - | NULL | 0 | - | - | - | dwd_crm_customer (customer_status变更为INACTIVE) | 【待确认】 | 2026-07-17 |
| avg_region_count | 平均区域客户数 | DECIMAL | 10,2 | NULL | - | - | - | - | 计算字段 | 【待确认】 | 2026-07-17 |
| etl_time | ETL时间 | TIMESTAMP | - | NULL | NULL | - | - | - | 系统自动 | 【待确认】 | 2026-07-17 |
| etl_batch_id | ETL批次ID | VARCHAR | 50 | NULL | - | - | - | - | 系统自动 | 【待确认】 | 2026-07-17 |
