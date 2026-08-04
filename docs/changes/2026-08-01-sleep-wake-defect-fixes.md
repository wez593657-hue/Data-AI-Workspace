# 睡眠户唤醒过程缺陷修复变更记录

日期：2026-08-01
修复方式：Codex 执行（用户确认）

## 修复原则遵守情况

| 原则 | 遵守情况 |
|---|---|
| 仅修复缺陷逻辑 | 通过：仅 [D] 段 4 处别名修正，无需求/功能变更 |
| 不改 Oracle 规范截断的对象名 | 通过：表名/字段名/过程名零改动（本模块名称均未超长） |
| 不引入数据结构变更 | 通过：无表结构改动；索引作为独立部署脚本交付，未写入 DDL |
| 不引入新功能变更 | 通过：语义与需求口径一致 |
| 充分测试验证 | 通过：重新编译 + A1~A6 回归全部 PASS |

## DEFECT-SLEEP-001：DTL [D] 段 UPDATE 子查询别名修正

文件：`data_assets/stored_procedure/dws_to_ads/PRC_ADS_CUST_SLEEP_WAKE_DTL.sql`

```sql
-- 修复前（UPDATE ... SET (...) = (SELECT ...)，别名 a 不存在）
NVL(a.DEPO_CURNT_DEPO_BAL, b.DEPO_CURNT_DEPO_BAL)
NVL(a.FIXD_DEPO_BAL, b.FIXD_DEPO_BAL)
NVL(a.FIN_BAL, b.FIN_AMT)
NVL(a.INSUR_BAL, b.INSUR_AMT)
-- 修复后（子查询 FROM 派生表别名为 sw）
NVL(sw.DEPO_CURNT_DEPO_BAL, b.DEPO_CURNT_DEPO_BAL)
NVL(sw.FIXD_DEPO_BAL, b.FIXD_DEPO_BAL)
NVL(sw.FIN_BAL, b.FIN_AMT)
NVL(sw.INSUR_BAL, b.INSUR_AMT)
```

[B] 段合法的 `a.`（FROM DWS_CUST_ASSE_LIAB a）未改动。

## DEFECT-SLEEP-002：生产索引部署要求

无索引时 DTL 性能平方级恶化（10k=24.3s、30k=228.8s、50k>600s）；
建索引后线性扩展（10k=0.23s、30k=0.56s、50k=0.92s）。
交付索引脚本 `scripts/oracle_validation/sleep_wake/07_indexes.sql`：

```sql
CREATE INDEX IDX_DWD_TX_ASET_CUST_DATE ON DWD_TX_ASET(CUST_ID, TX_DATE);
CREATE INDEX IDX_DWS_ASSE_CUST_ORG_DATE ON DWS_CUST_ASSE_LIAB(CUST_ID, PERSN_LEGAL_BK_CODE, ORG_ID, DATA_DATE);
```

与需求记忆卡片待确认事项 1（DWD_TX_ASET 索引覆盖）一致；
索引属部署对象，未写入数据资产 DDL。

## 回归验证

- 重新编译：Procedure created（原 ORA-00904 消除）
- 功能回归：A1~A6（月首复核/重置、增量唤醒、不可逆、排除、快照保留、统计）全部 PASS
