# DWS → ADS Mapping - CRM 客户报表

## Mapping 信息

| 属性 | 值 |
|------|------|
| 来源层级 | DWS |
| 来源表 | dws_crm_customer_daily |
| 目标层级 | ADS |
| 目标表 | ads_crm_customer_report |
| 同步方式 | 按周期汇总（日/周/月/季/年） |
| 负责人 | 【待确认】 |
| 更新时间 | 2026-07-17 |

## 字段 Mapping

| 序号 | 来源表 | 来源字段 | 目标表 | 目标字段 | 转换规则 | 默认值 | 是否允许为空 | 上游来源 | 下游影响 |
|------|--------|----------|--------|----------|----------|--------|--------------|----------|----------|
| 1 | - | - | ads_crm_customer_report | report_date | 系统参数，报表日期 | - | NOT NULL | 系统自动 | 报表筛选 |
| 2 | - | - | ads_crm_customer_report | period_type | 系统参数，周期类型 | - | NOT NULL | 系统参数 | 报表周期切换 |
| 3 | dws_crm_customer_daily | total_count | ads_crm_customer_report | total_customer | 周期内SUM(total_count) | 0 | NULL | dws_crm_customer_daily | 客户总数指标 |
| 4 | dws_crm_customer_daily | active_count | ads_crm_customer_report | active_customer | 周期内SUM(active_count) | 0 | NULL | dws_crm_customer_daily | 活跃客户指标 |
| 5 | dws_crm_customer_daily | total_count | ads_crm_customer_report | customer_growth_rate | (本期total_count - 上期total_count) / 上期total_count | - | NULL | dws_crm_customer_daily | 增长率指标 |
| 6 | dwd_crm_order | order_amount | ads_crm_customer_report | avg_customer_value | 关联订单表计算平均客单价 | - | NULL | dwd_crm_order | 客户价值指标 |
| 7 | dwd_crm_customer | region | ads_crm_customer_report | top_region | 周期内客户数最多的区域 | - | NULL | dwd_crm_customer | 区域排行 |
| 8 | dwd_crm_customer | industry | ads_crm_customer_report | top_industry | 周期内客户数最多的行业 | - | NULL | dwd_crm_customer | 行业排行 |
| 9 | - | - | ads_crm_customer_report | monthly_target_achievement | 实际值/目标值（目标值从配置表获取） | - | NULL | 配置表 | 目标达成率 |
| 10 | - | - | ads_crm_customer_report | create_time | ETL执行时设置为当前时间 | NOW() | NOT NULL | 系统自动 | 审计日志 |
| 11 | - | - | ads_crm_customer_report | etl_batch_id | ETL批次ID | - | NULL | 系统自动 | ETL追踪 |
