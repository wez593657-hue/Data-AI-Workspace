# ADS数据字典 - CUST_NEW_CUST_STATIS

## 表信息

| 属性 | 值 |
|------|------|
| 层级 | ADS - 应用数据层 |
| 表名 | CUST_NEW_CUST_STATIS |
| 中文名称 | 新客经营统计表 |
| 更新时间 | 2026-07-17 |

## 字段列表

| 字段名 | 字段中文说明 | 数据类型 | 长度 | 是否为空 | 默认值 | 主键 | 外键 | 枚举说明 | 业务含义 |
|--------|-------------|----------|------|----------|--------|------|------|----------|----------|
| DATA_DATE | 数据日期 | VARCHAR2(8) | - | - | - | - | - | - | - |
| STATIS_OBJ | 统计对象 | VARCHAR2(2) | - | - | - | - | - | - | - |
| STATIS_CYCLE | 统计周期 | VARCHAR2(2) | - | - | - | - | - | - | - |
| NEW_CUST_CYCLE | 新客周期 | VARCHAR2(1) | - | - | - | - | - | - | - |
| NEW_CUST_CNT | 新客数 | NUMBER(8) | - | - | - | - | - | - | - |
| CNTCT_CUST_CNT | 已接触客户 | NUMBER(8) | - | - | - | - | - | - | - |
| ASSET_BAL_SEG1_CUST_CNT | 资产余额区间1客户数 | NUMBER(8) | - | - | - | - | - | - | - |
| ASSET_BAL_SEG2_CUST_CNT | 资产余额区间2客户数 | NUMBER(8) | - | - | - | - | - | - | - |
| ASSET_BAL_SEG3_CUST_CNT | 资产余额区间3客户数 | NUMBER(8) | - | - | - | - | - | - | - |
| ASSET_BAL_SEG4_CUST_CNT | 资产余额区间4客户数 | NUMBER(8) | - | - | - | - | - | - | - |
| ASSET_BAL_SEG5_CUST_CNT | 资产余额区间5客户数 | NUMBER(8) | - | - | - | - | - | - | - |
| CNTCT_RATE | 接触率 | NUMBER(20,2) | - | - | - | - | - | - | - |
| KYC_CUST_CNT | KYC客户 | NUMBER(8) | - | - | - | - | - | - | - |
| COMP_RATE | 完成率 | NUMBER(20,2) | - | - | - | - | - | - | - |

---
*数据字典版本: v1.0 | 生成时间: 2026-07-17*
