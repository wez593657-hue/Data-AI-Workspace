# 流失挽回明细表 DDL 补列变更记录（DEFECT-LOST-001）

日期：2026-08-01
修复方式：Codex 执行（用户确认）
背景：本地验证发现 ADS_CUST_LOST_DTL 目标表 DDL 缺少过程中必需的
RESCUED_FINA_ASSET 列（需求 v2.1.0 已明确新增），按原 DDL 建表后两过程无法编译。

## 修改文件（三处同步，保持 DDL/字典/Excel 一致）

1. `data_assets/ddl/ads/ads_cust_lost_dtl.sql`
   - RESCUE_STATE 后新增列：`RESCUED_FINA_ASSET NUMBER(20,2)`
   - 新增注释：`COMMENT ON COLUMN ... IS '已挽回金融资产'`
2. `data_assets/mapping/dws_to_ads/dws到ads映射.md`
   - 表清单 ADS_CUST_LOST_DTL 列数 14 → 15
   - 字段映射表新增：
     `RESCUED_FINA_ASSET | 已挽回金融资产 | NUMBER(20,2) |
     MAX(T-1日时点AUM-上月末时点AUM,0)，仅挽回客户计`
3. `data_assets/mapping/dws_to_ads/ADS应用层数据模型_CRM_ V1.0.xlsx`
   - "客户流失清单" sheet 在 RESCUE_STATE 与 POST_ID 之间插入
     RESCUED_FINA_ASSET（NUMBER(20,2)/已挽回金融资产）
   - "修订记录" sheet 登记修订（序号1，2026-08-01）
   - 修改前已备份：`ADS应用层数据模型_CRM_ V1.0.xlsx.bak`

## 口径说明

RESCUED_FINA_ASSET = MAX(T-1日时点AUM - 上月末时点AUM, 0)，仅已挽回客户
（RESCUE_STATE='1'）计入；统计表直接 SUM 明细字段汇总（单一事实来源）。

## 验证

- 本地 Oracle 两过程（Oracle 版）编译运行 RC=0
- 统计表映射已含该字段，无需改动；SYDDL 汇总文件中无此表定义
- 字段顺序与过程 INSERT 列清单一致（RESCUE_STATE 之后、POST_ID 之前）
