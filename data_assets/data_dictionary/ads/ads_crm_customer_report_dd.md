# ADS 层数据字典 - CRM 客户报表表

## 表信息

| 属性 | 值 |
|------|------|
| 表名 | ads_crm_customer_report |
| 中文名称 | ADS_CRM客户报表表 |
| 描述 | 面向业务报表的客户分析数据 |
| 数据来源 | DWS层 dws_crm_customer_daily |
| 负责人 | 【待确认】 |
| 更新时间 | 2026-07-17 |

## 字段列表

| 字段名 | 字段中文说明 | 数据类型 | 长度 | 是否为空 | 默认值 | 主键 | 外键 | 枚举说明 | 数据来源 | 负责人 | 更新时间 |
|--------|-------------|----------|------|----------|--------|------|------|----------|----------|--------|----------|
| report_date | 报表日期 | DATE | - | NOT NULL | - | PRIMARY KEY | - | - | 系统自动 | 【待确认】 | 2026-07-17 |
| period_type | 周期类型 | VARCHAR | 10 | NOT NULL | - | PRIMARY KEY | - | DAY-日, WEEK-周, MONTH-月, QUARTER-季度, YEAR-年度 | 系统参数 | 【待确认】 | 2026-07-17 |
| total_customer | 客户总数 | INT | - | NULL | 0 | - | - | - | dws_crm_customer_daily.total_count | 【待确认】 | 2026-07-17 |
| active_customer | 活跃客户数 | INT | - | NULL | 0 | - | - | - | dws_crm_customer_daily.active_count | 【待确认】 | 2026-07-17 |
| customer_growth_rate | 客户增长率 | DECIMAL | 10,4 | NULL | - | - | - | - | 计算字段 (本期-上期)/上期 | 【待确认】 | 2026-07-17 |
| avg_customer_value | 平均客户价值 | DECIMAL | 18,2 | NULL | - | - | - | - | 关联订单表计算 | 【待确认】 | 2026-07-17 |
| top_region | 客户最多区域 | VARCHAR | 100 | NULL | - | - | - | - | 区域统计 | 【待确认】 | 2026-07-17 |
| top_industry | 客户最多行业 | VARCHAR | 100 | NULL | - | - | - | - | 行业统计 | 【待确认】 | 2026-07-17 |
| monthly_target_achievement | 月度目标达成率 | DECIMAL | 10,4 | NULL | - | - | - | - | 实际/目标 | 【待确认】 | 2026-07-17 |
| create_time | 创建时间 | TIMESTAMP | - | NOT NULL | NOW() | - | - | - | 系统自动 | 【待确认】 | 2026-07-17 |
| etl_batch_id | ETL批次ID | VARCHAR | 50 | NULL | - | - | - | - | 系统自动 | 【待确认】 | 2026-07-17 |
