# 新客经营口径对齐变更记录（未评级码值 11 / ORG_ID 取 DWS）

日期：2026-08-01
变更方式：Codex 执行（用户确认）

## 口径确认

1. **'未评级'码值 = '11'**：当月新客客户等级不再写入中文'未评级'，
   统一使用码值 '11'（VARCHAR2(2) 可容纳）。
2. **ORG_ID 统一取 DWS_CUST_ASSE_LIAB**：归属机构一律取资产快照，
   不再取管户关系表。
3. **客户等级直接取 DWS_CUST_LVL_INFO**（用户 2026-08-01 补充确认）：
   新客客户等级（含未评级码值 11）亦记录于 DWS_CUST_LVL_INFO，
   过程不再按开户月（OPEN_DATE 所在月=跑批月）重新判断当月新客，
   一律取等级表；无等级记录时兜底未评级（码值 11）。

## 文件修改

1. `requirements/客户等级.md`：新增 `| / | 未评级 | 11 | 未评级 | 8 |`。
2. `data_assets/stored_procedure/dws_to_ads/PRC_ADS_CUST_NEW_CUST_DTL.sql`：
   - TMP2 段客户等级：删除"当月新客（OPEN_DATE 所在月=跑批月）→未评级"
     的判断分支，改为直接取 `NVL(l.CUST_LVL, '11')`
     （DWS_CUST_LVL_INFO，含未评级码值 11；无记录兜底 11）；
     同步删除不再使用的 V_CURR_MONTH_BEGIN/V_BN_MONTH 变量与赋值；
   - TMP2 段 ORG_ID：`m.ORG_ID` → `a.ORG_ID`（DWS_CUST_ASSE_LIAB 资产快照），
     管户经理 POST_ID 仍取 DWD_CUST_MAN（MNG_TYP='1'）。

## 影响审核

### 新客经营明细/统计

- DEFECT-NEWCUST-001（CUST_LVL 长度）随码值方案解决：'11' 在 VARCHAR2(2) 内，
  原 DDL 无需扩列；且等级直接取 DWS_CUST_LVL_INFO，无"中文字符串写入"路径。
- DEFECT-NEWCUST-002（无管户客户统计遗漏）随 ORG_ID 改取资产快照解决：
  无管户客户仍归属资产快照机构，机构统计不再遗漏。
- 统计表（ADS_CUST_NEW_CUST_STATIS）无 CUST_LVL/ORG_ID 源列，逻辑不变。

### 流失挽回明细/统计

- 审核确认 ORG_ID 已取 DWS_CUST_ASSE_LIAB
  （`COALESCE(p.ORG_ID, pp.ORG_ID)`，p/pp 均为资产表子查询），无需代码修改。

## 回归验证（本地 Oracle，SCOTT）

| 项 | 修复前 | 修复后 |
|---|---|---|
| 当月新客 CUST_LVL | 报 ORA-12899 / '未评级' | 取等级表：N01='04'（表有值）、N02/N08/N11='11'（表未评级）、N13='11'（无记录兜底） |
| N09/N10 ORG_ID | NULL | ORG101（资产快照） |
| 统计表 ORG100 周期4 | 12 | 14 |
| 统计表 ORG100 周期2 | 4 | 6 |
| 流失挽回 ORG_ID 来源 | - | 确认全部来自 DWS，回归 8 行通过 |
