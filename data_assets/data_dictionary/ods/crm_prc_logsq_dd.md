# ODS 层数据字典 - crm_prc_logsq

## 表信息

| 属性 | 值 |
|------|----|
| 表名 | crm_prc_logsq |
| 中文名称 | 过程日志表 |
| 描述 | 存储过程执行日志表，用于记录存储过程的执行步骤、开始时间、结束时间、耗时和日志消息 |
| 数据来源 | DDL: crm_prc_logsq |
| 负责人 | 【待确认】 |
| 更新时间 | 2026-07-22 |

## 字段列表

| 字段名 | 字段中文说明 | 数据类型 | 长度 | 是否为空 | 默认值 | 主键 | 外键 | 枚举说明 | 数据来源 | 负责人 | 更新时间 |
|--------|--------------|----------|------|----------|--------|------|------|----------|----------|--------|----------|
| logid | 日志ID | NUMERIC | 20 | NOT NULL | - | YES | - | - | crm_prc_logsq.logid | 【待确认】 | 2026-07-22 |
| prc_name | 过程名称 | VARCHAR | 80 | NULL | - | - | - | - | crm_prc_logsq.prc_name | 【待确认】 | 2026-07-22 |
| prc_desc | 过程描述 | VARCHAR | 300 | NULL | - | - | - | - | crm_prc_logsq.prc_desc | 【待确认】 | 2026-07-22 |
| logdate | 日志日期 | VARCHAR | 8 | NULL | - | - | - | - | crm_prc_logsq.logdate | 【待确认】 | 2026-07-22 |
| no_id | 步骤编号 | VARCHAR | 10 | NULL | - | - | - | - | crm_prc_logsq.no_id | 【待确认】 | 2026-07-22 |
| bgn_date | 开始日期 | sys.date | - | NULL | - | - | - | - | crm_prc_logsq.bgn_date | 【待确认】 | 2026-07-22 |
| end_date | 结束日期 | sys.date | - | NULL | - | - | - | - | crm_prc_logsq.end_date | 【待确认】 | 2026-07-22 |
| dura_date | 耗时 | NUMERIC | 10 | NULL | - | - | - | - | crm_prc_logsq.dura_date | 【待确认】 | 2026-07-22 |
| logmsg | 日志消息 | VARCHAR | 1000 | NULL | - | - | - | - | crm_prc_logsq.logmsg | 【待确认】 | 2026-07-22 |
| log_flg | 日志标志 | NUMERIC | 10 | NULL | - | - | - | - | crm_prc_logsq.log_flg | 【待确认】 | 2026-07-22 |
