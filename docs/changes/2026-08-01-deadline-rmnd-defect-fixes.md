# 到期承接过程缺陷修复变更记录（DEFECT-004~007）

日期：2026-08-01
修复方式：Codex 执行（用户确认）
涉及文件：`data_assets/stored_procedure/dws_to_ads/PRC_ADS_CUST_DEADLINE_RMND_DTL.sql`

## 修复原则遵守情况

| 原则 | 遵守情况 |
|---|---|
| 仅修复缺陷逻辑 | 通过：仅 4 处逻辑修正，无需求/功能变更 |
| 不改 Oracle 规范截断的字段/表/过程名称 | 通过：表名、字段名、过程名均未改动 |
| 不引入数据结构变更 | 通过：源表/中间表/目标表结构未改；TAKE_AMT/CROSS_CONV 表结构保留（不再生成数据） |
| 不引入新功能变更 | 通过：语义与需求口径保持一致 |
| 修改经充分测试 | 通过：34 次跑批 + 13 组断言回归，全部通过（观察项除外） |

## 修复明细

### DEFECT-004：EXPR_AMT 已到期金额截止日改为 V_SYSDAT

第 4 段 DUE_WIN 聚合：

```sql
-- 修复前
SUM(CASE WHEN m.EXPR_DT <= V_END_DATE THEN NVL(m.EXPR_AMT, 0) ELSE 0 END) AS EXPR_AMT
-- 修复后（V_END_DATE 原为 SYSDATE，不符合口径12/T-1）
SUM(CASE WHEN m.EXPR_DT <= TO_DATE(V_SYSDAT, 'yyyymmdd') THEN NVL(m.EXPR_AMT, 0) ELSE 0 END) AS EXPR_AMT
```

### DEFECT-005：接触状态增加跑批日截止

第 9 段 CNTCT_STATE 判定在 30 天窗口条件后增加：

```sql
AND TO_DATE(REPLACE(SUBSTR(m.MKT_TIME, 1, 10), '-', ''), 'yyyymmdd') <= TO_DATE(V_SYSDAT, 'yyyymmdd')
```

### DEFECT-006：承接金额/跨类型转化按统计周期实例计算

- 第 6 段/6.1 段原按 `STAT_PERD + CUST_ID + STATIS_TYP + PERSN_LEGAL_BK_CODE`
  聚合写入 TAKE_AMT/CROSS_CONV 中间表，上季 Q1 与当季 Q2（上月与当月）被合并，
  导致上期切片错误关联当期购买金额。
- 修复：两段不再生成中间表数据（表结构保留，第 1 段 TRUNCATE 不变）；
  第 9 段最终查询改用按周期实例（BGN_DT/END_DT）分组的派生表 t/cv 内联计算，
  关联键同步增加 BGN_DT/END_DT。

### DEFECT-007：AUM 关联补充 DATA_DATE

第 9 段 ap 关联增加：

```sql
AND ap.DATA_DATE = TO_CHAR(w.FIRST_EXPR_DT - 1, 'yyyymmdd')
```

消除同 STAT_PERD 多周期实例（Q1/Q2）PREV 行导致的明细行重复。

## 回归验证

- 环境：本地 Oracle 11.2.0.1，SCOTT schema（隔离规范）
- 用例：9 探针客户，连续 30 天跑批 + 检查日 0705/0731/0930/1231
- 结果：34 次跑批全部成功；A1~A13 断言全部 PASS
  - EXPR_AMT 截止：06-01=0，30 天递进 0→10万→15万→23万 ✓
  - 接触状态：未来营销记录不计入（CNTCT=0）✓
  - 跨周期聚合：C17 Q1 TAKE_RATE=0、明细 1 行 ✓
  - 月季年一致性、窗口计算、跨月购买归属、过滤规则、空值兜底均无回归 ✓
- 观察项（不在本次修复范围）：DWS 重复快照金额放大（DEFECT-008）

## 遗留说明

- DEFECT-008（DWS 重复快照/负金额防御）保持观察项，待业务确认后再评估。
- TMP_CDR_DTL_TAKE_AMT / TMP_CDR_DTL_CROSS_CONV 表结构保留但不再写入数据，
  后续若需清理可另行评估。
- 需在 Kingbase Oracle 兼容模式编译本过程并回放同一验证矩阵（本地 Oracle 已验证）。
