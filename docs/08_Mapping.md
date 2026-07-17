# 08 Mapping 规范

## 8.1 概述

Mapping 是字段从来源系统到目标系统转换规则的唯一记录，是项目最高保护对象。任何修改必须保持一致性与可追溯性。

## 8.2 Mapping 必须包含的字段

| 字段名 | 说明 | 示例 |
|--------|------|------|
| 来源系统 | 数据来源系统名称 | `SAP` |
| 来源表 | 来源系统中的表名 | `S_CUSTOMER` |
| 来源字段 | 来源系统中的字段名 | `CUST_ID` |
| 目标表 | 目标系统中的表名 | `crm_customer` |
| 目标字段 | 目标系统中的字段名 | `customer_id` |
| 转换规则 | 字段转换逻辑 | `直接映射` |
| 默认值 | 目标字段默认值 | `NULL` |
| 是否允许为空 | 目标字段是否允许为空 | `NOT NULL` |
| 上游来源 | 上游数据追溯路径 | `SAP → S_CUSTOMER → CUST_ID` |
| 下游影响 | 下游依赖此字段的模块 | 【待确认】 |

## 8.3 Mapping 模板

### 8.3.1 表级别 Mapping

```text
========================================
来源系统: SAP
来源表: S_CUSTOMER
目标系统: CRM
目标表: crm_customer
========================================
描述: 客户信息从 SAP 同步到 CRM
同步方式: 增量同步（基于 UPDATE_TIME）
负责人: 【待确认】
更新时间: 2024-01-15

字段 Mapping:
```

### 8.3.2 字段级别 Mapping

| 序号 | 来源系统 | 来源表 | 来源字段 | 目标表 | 目标字段 | 转换规则 | 默认值 | 是否允许为空 | 上游来源 | 下游影响 |
|------|----------|--------|----------|--------|----------|----------|--------|--------------|----------|----------|
| 1 | SAP | S_CUSTOMER | CUST_ID | crm_customer | customer_id | 直接映射，去除前后空格 | - | NOT NULL | SAP → S_CUSTOMER → CUST_ID | crm_order, crm_payment |
| 2 | SAP | S_CUSTOMER | CUST_NAME | crm_customer | customer_name | 直接映射，去除前后空格 | - | NOT NULL | SAP → S_CUSTOMER → CUST_NAME | 报表系统 |
| 3 | SAP | S_CUSTOMER | CUST_CODE | crm_customer | customer_code | 直接映射 | - | NOT NULL | SAP → S_CUSTOMER → CUST_CODE | 唯一索引 |
| 4 | SAP | S_CUSTOMER | CUST_STATUS | crm_customer | customer_status | 'Y'→'ACTIVE', 'N'→'INACTIVE', 其他→'UNKNOWN' | ACTIVE | NULL | SAP → S_CUSTOMER → CUST_STATUS | 业务查询 |
| 5 | 系统自动 | - | - | crm_customer | create_time | 首次同步时设置为当前时间 | NOW() | NOT NULL | 系统自动 | 审计日志 |
| 6 | 系统自动 | - | - | crm_customer | update_time | 每次同步时更新为当前时间 | NULL | NULL | 系统自动 | 增量同步 |

## 8.4 转换规则类型

| 转换类型 | 说明 | 示例 |
|----------|------|------|
| 直接映射 | 字段值直接复制 | `CUST_ID` → `customer_id` |
| 格式转换 | 数据格式转换 | `'2024/01/01'` → `'2024-01-01'` |
| 类型转换 | 数据类型转换 | `VARCHAR` → `INT` |
| 枚举映射 | 枚举值转换 | `'Y'` → `'ACTIVE'` |
| 计算转换 | 字段计算 | `QUANTITY * PRICE` → `amount` |
| 拼接转换 | 多字段拼接 | `FIRST_NAME + ' ' + LAST_NAME` → `full_name` |
| 默认值填充 | NULL 值填充 | NULL → `'UNKNOWN'` |
| 条件转换 | 条件判断 | `IF amount > 100 THEN 'HIGH' ELSE 'LOW'` |

## 8.5 Mapping 与其他文档的关系

```
Mapping
    │
    ├── 依赖数据字典（07_Data_Dictionary.md）
    │       └── 目标字段必须在数据字典中定义
    │
    ├── 驱动 SQL（02_SQL_Standard.md）
    │       └── SQL 中的转换逻辑必须与 Mapping 一致
    │
    └── 驱动 ETL（06_ETL_Standard.md）
            └── ETL 的转换规则必须与 Mapping 一致
```

## 8.6 Mapping 管理规范

### 8.6.1 创建流程

```
需求分析 → 数据字典确认 → Mapping 设计 → 审核确认 → 实施
```

### 8.6.2 修改流程

```
变更申请 → 影响评估 → Mapping 更新 → 数据字典同步 → SQL 更新 → ETL 更新 → 审核确认 → 上线
```

### 8.6.3 数据分层 Mapping 规范

数据仓库采用分层架构，Mapping 需按层间转换关系管理：

| 转换方向 | 目录 | 命名规范 | 说明 |
|----------|------|----------|------|
| ODS → DWD | `data_assets/mapping/ods_to_dwd/` | `ods_to_dwd_{系统}_{表名}_mapping.md` | 原始数据到明细数据的转换规则 |
| DWD → DWS | `data_assets/mapping/dwd_to_dws/` | `dwd_to_dws_{业务域}_{表名}_mapping.md` | 明细数据到汇总数据的转换规则 |
| DWS → ADS | `data_assets/mapping/dws_to_ads/` | `dws_to_ads_{业务域}_{表名}_mapping.md` | 汇总数据到报表数据的转换规则 |

**分层 Mapping 模板**:

```text
========================================
来源层级: ODS
来源表: ods_sap_customer
目标层级: DWD
目标表: dwd_crm_customer
========================================
描述: SAP客户数据清洗转换到CRM客户明细表
同步方式: 增量同步（基于 UPDATE_TIME）
负责人: 【待确认】
更新时间: 2026-07-17

字段 Mapping:
```

**字段级别 Mapping 扩展**:

| 序号 | 来源层级 | 来源表 | 来源字段 | 目标层级 | 目标表 | 目标字段 | 转换规则 | 默认值 | 是否允许为空 | 上游来源 | 下游影响 |
|------|----------|--------|----------|----------|--------|----------|----------|--------|--------------|----------|----------|
| 1 | ODS | ods_sap_customer | CUST_ID | DWD | dwd_crm_customer | customer_id | 直接映射，去除前后空格 | - | NOT NULL | SAP → S_CUSTOMER → CUST_ID | dwd_crm_order |
| 2 | ODS | ods_sap_customer | CUST_TYPE | DWD | dwd_crm_customer | customer_type | 'P'→'PERSONAL', 'E'→'ENTERPRISE' | PERSONAL | NULL | SAP → S_CUSTOMER → CUST_TYPE | 客户分类统计 |

### 8.6.4 版本控制

```text
Mapping 版本: v1.0
变更记录:
- 2024-01-15: 初始创建
- 2024-02-20: 添加 customer_phone 字段 Mapping
- 2024-03-10: 修改 customer_status 转换规则
```

## 8.7 Mapping 检查清单

| 检查项 | 检查内容 | 状态 |
|--------|----------|------|
| 来源系统 | 是否明确来源系统 | ✅/❌ |
| 来源表 | 是否明确来源表 | ✅/❌ |
| 来源字段 | 是否明确来源字段 | ✅/❌ |
| 目标表 | 是否明确目标表 | ✅/❌ |
| 目标字段 | 是否明确目标字段 | ✅/❌ |
| 转换规则 | 是否明确转换规则 | ✅/❌ |
| 默认值 | 是否明确默认值 | ✅/❌ |
| 是否允许为空 | 是否明确非空约束 | ✅/❌ |
| 上游来源 | 是否可追溯上游 | ✅/❌ |
| 数据字典一致性 | 是否与数据字典一致 | ✅/❌ |
| SQL 一致性 | 是否与 SQL 一致 | ✅/❌ |
| ETL 一致性 | 是否与 ETL 一致 | ✅/❌ |

## 8.8 可追溯性（Traceability）

### 8.8.1 上游追溯

```text
目标字段: customer_id
上游路径: SAP → S_CUSTOMER → CUST_ID → 业务系统 → 原始录入
```

### 8.8.2 下游追溯

```text
源字段: customer_id
下游影响: 
- crm_order.customer_id（订单表）
- crm_payment.customer_id（支付表）
- crm_contact.customer_id（联系人表）
- 销售报表
- 客户分析
```

## 8.9 禁止事项

- ❌ 禁止 Mapping 与数据字典不一致
- ❌ 禁止 Mapping 与 SQL 不一致
- ❌ 禁止 Mapping 与 ETL 不一致
- ❌ 禁止修改 Mapping 不同步更新相关文档
- ❌ 禁止不明确转换规则
- ❌ 禁止不标明数据来源
