# 睡眠户唤醒过程本地 Oracle 验证缺陷台账

依据 `docs/standards/oracle-local-testing-policy.md` 第 4 节登记。
未经用户确认，不得修改任何数据资产文件。

---

## DEFECT-SLEEP-001：DTL [D] 段 UPDATE 子查询别名错误导致无法编译（阻断级）

- **状态**：已修复（2026-08-01，用户确认）
- **具体位置**：
  - `data_assets/stored_procedure/dws_to_ads/PRC_ADS_CUST_SLEEP_WAKE_DTL.sql`
    [D] 一体化更新段 UPDATE ... SET (...) = (SELECT ...) 子查询
  - 4 处引用不存在的别名 `a.`（应为派生表 `sw.`）：
    `a.DEPO_CURNT_DEPO_BAL`、`a.FIXD_DEPO_BAL`、`a.FIN_BAL`、`a.INSUR_BAL`
- **影响范围**：
  - 过程无法编译（Oracle：ORA-00904；Kingbase 大概率同样失败），
    睡眠户明细整批不可用
- **复现证据**：
  - Oracle 11g 编译：`ORA-00904: "A"."INSUR_BAL": invalid identifier`；
    测试副本将 4 处 `a.` 改为 `sw.` 后编译运行成功
- **建议解决方案**：
  - 源文件 4 处 `a.` 改为 `sw.`（UPDATE 子查询 FROM 的派生表别名），
    并补充真实编译检查
- **处理决策**：Codex 执行（用户 2026-08-01 确认）
  - 修复内容：源文件 [D] 段 UPDATE 子查询 4 处别名 `a.` 改为 `sw.`
    （`DEPO_CURNT_DEPO_BAL`/`FIXD_DEPO_BAL`/`FIN_BAL`/`INSUR_BAL`），
    [B] 段合法的 `a.` 引用未改动
  - 回归证据：重新编译成功（Procedure created）；A1~A6 全部 PASS

---

## DEFECT-SLEEP-002：无索引时 DTL 性能平方级恶化（部署阻断项）

- **状态**：部署项（2026-08-01 交付索引脚本，非数据资产修改）
- **具体位置**：
  - DTL [B] 段 `NOT EXISTS(DWD_TX_ASET)`（每客户全表扫描，无索引）
  - DTL [D] 段 UPDATE 子查询逐行关联 DWS_CUST_ASSE_LIAB（两期快照）
- **影响范围**：
  - 无索引下执行时间随客户数平方级增长：10k=24.3s、30k=228.8s、50k>600s（超时）
  - 与需求记忆卡片待确认事项 1"DWD_TX_ASET 索引覆盖(CUST_ID, TX_DATE)"一致
- **复现证据**：
  - 建索引后：10k=0.23s、30k=0.56s、50k=0.92s（约 400 倍改善，线性扩展）
- **建议解决方案**：
  - 生产部署需建索引：
    - `DWD_TX_ASET(CUST_ID, TX_DATE)`（或 +PERSN_LEGAL_BK_CODE+JIOYCFFS）
    - `DWS_CUST_ASSE_LIAB(CUST_ID, PERSN_LEGAL_BK_CODE, ORG_ID, DATA_DATE)`
  - 建议将索引纳入 DDL/部署清单
- **处理决策**：部署执行（用户 2026-08-01 确认修复工作；
  索引脚本 `scripts/oracle_validation/sleep_wake/07_indexes.sql`，
  不改动数据资产 DDL/过程；生产环境按脚本建索引后重测）
