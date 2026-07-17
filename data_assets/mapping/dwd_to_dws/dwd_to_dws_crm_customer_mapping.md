# DWD → DWS Mapping - CRM 客户日汇总

## Mapping 信息

| 属性 | 值 |
|------|------|
| 来源层级 | DWD |
| 来源表 | dwd_crm_customer |
| 目标层级 | DWS |
| 目标表 | dws_crm_customer_daily |
| 同步方式 | 每日增量汇总 |
| 负责人 | 【待确认】 |
| 更新时间 | 2026-07-17 |

## 字段 Mapping

| 序号 | 来源表 | 来源字段 | 目标表 | 目标字段 | 转换规则 | 默认值 | 是否允许为空 | 上游来源 | 下游影响 |
|------|--------|----------|--------|----------|----------|--------|--------------|----------|----------|
| 1 | - | - | dws_crm_customer_daily | stat_date | 系统参数，统计日期 | - | NOT NULL | 系统自动 | 报表筛选 |
| 2 | dwd_crm_customer | customer_id | dws_crm_customer_daily | total_count | COUNT(DISTINCT customer_id) | 0 | NULL | dwd_crm_customer | 客户总数统计 |
| 3 | dwd_crm_customer | customer_status | dws_crm_customer_daily | active_count | COUNT(DISTINCT customer_id) WHERE customer_status='ACTIVE' | 0 | NULL | dwd_crm_customer | 活跃客户统计 |
| 4 | dwd_crm_customer | customer_status | dws_crm_customer_daily | inactive_count | COUNT(DISTINCT customer_id) WHERE customer_status='INACTIVE' | 0 | NULL | dwd_crm_customer | 非活跃客户统计 |
| 5 | dwd_crm_customer | customer_type | dws_crm_customer_daily | personal_count | COUNT(DISTINCT customer_id) WHERE customer_type='PERSONAL' | 0 | NULL | dwd_crm_customer | 个人客户统计 |
| 6 | dwd_crm_customer | customer_type | dws_crm_customer_daily | enterprise_count | COUNT(DISTINCT customer_id) WHERE customer_type='ENTERPRISE' | 0 | NULL | dwd_crm_customer | 企业客户统计 |
| 7 | dwd_crm_customer | create_time | dws_crm_customer_daily | new_add_count | COUNT(DISTINCT customer_id) WHERE DATE(create_time)=stat_date | 0 | NULL | dwd_crm_customer | 新增客户统计 |
| 8 | dwd_crm_customer | customer_status | dws_crm_customer_daily | lost_count | COUNT(DISTINCT customer_id) WHERE customer_status变更为INACTIVE | 0 | NULL | dwd_crm_customer | 流失客户统计 |
| 9 | dwd_crm_customer | region | dws_crm_customer_daily | avg_region_count | total_count / COUNT(DISTINCT region) | - | NULL | dwd_crm_customer | 区域分布分析 |
| 10 | - | - | dws_crm_customer_daily | etl_time | ETL执行时设置为当前时间 | NULL | NULL | 系统自动 | ETL监控 |
| 11 | - | - | dws_crm_customer_daily | etl_batch_id | ETL批次ID | - | NULL | 系统自动 | ETL追踪 |
