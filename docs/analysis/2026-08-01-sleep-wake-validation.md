# 睡眠户唤醒明细/统计存储过程验证报告

日期：2026-08-01
环境：本地 Oracle 11.2.0.1（ORCL），SCOTT schema（隔离规范）
对象：PRC_ADS_CUST_SLEEP_WAKE_DTL / PRC_ADS_CUST_SLEEP_WAKE_STATIS
依据：requirements/睡眠户唤醒规则记忆卡片.md（v2.10.0）

## 1. 验证范围

1. 输入参数校验（边界值、异常值）
2. 核心业务逻辑正确性（多日跑批：月首复核/重置、月内累积、增量唤醒、不可逆）
3. 输出结果完整性与准确性
4. 性能测试（不同数据量，含索引对比）
5. 错误处理机制

## 2. 测试数据（13 个探针客户，5 个跑批日）

覆盖：一直睡眠、有主动动账排除（JIOYCFFS='0'）、AUM=100 边界、AUM=0、
快照缺失保留、月首新增、月首 AUM≥100 复核移除、月内买定期/保险唤醒、
唤醒后赎回不可逆、无效接触类型、非理财管户。

## 3. 功能验证结果（A1~A6，全部 PASS）

| 用例 | 验证点 | 预期 | 实际 | 结论 |
|---|---|---|---|---|
| A1（0630） | 昨日清单生成、主动动账排除 | 8 客户，S06 排除 | 一致 | PASS |
| A2（0701 月首） | 复核上月末清单+重置+月首新增 | 10 客户（S11 移除/S10 新增），WAKE/CNTCT 全 0 | 一致 | PASS |
| A3（0702 月内） | 增量唤醒（定期/定期/保险 0→>0） | S03/S05/S12=1，S01=0 | 一致 | PASS |
| A4（0703） | 唤醒不可逆+接触 | S05 赎回后 WAKE 仍 1；S02 CNTCT=1 | 一致 | PASS |
| A5（统计表） | ORG100 0702 | CUST_CNT=10、WAKE=3、唤醒率 30% | 一致 | PASS |
| A6（快照缺失） | S09 无快照保留遗值 | 清单保留、余额保留 | 一致 | PASS |

## 4. 参数校验与错误处理（PASS）

- 5 类非法输入（NULL/7位/字母/含空格/日期非法）全部正确拒绝（ORA-20001/-1839）
- 运行期错误 → OUTCDE=-1 → ROLLBACK → 日志 → RAISE
- 依赖对象缺失 → 过程 INVALID（Oracle 机制），恢复后正常

## 5. 性能测试（发现索引问题）

| 数据量 | 无索引 DTL | 有索引 DTL |
|---|---|---|
| 10,000 | 24.29s | 0.23s |
| 30,000 | 228.83s | 0.56s |
| 50,000 | >600s（超时） | 0.92s |

- 无索引：平方级恶化（[B] NOT EXISTS 全表扫描 + [D] 逐行关联 DWS）
- 建 `DWD_TX_ASET(CUST_ID,TX_DATE)` 与
  `DWS_CUST_ASSE_LIAB(CUST_ID,PERSN_LEGAL_BK_CODE,ORG_ID,DATA_DATE)` 索引后
  约 400 倍改善，线性扩展
- 与需求记忆卡片待确认事项 1 完全一致，登记 DEFECT-SLEEP-002

## 6. 发现的问题（详见 DEFECTS.md）

1. **DEFECT-SLEEP-001（阻断级）**：[D] 段 UPDATE 子查询 4 处别名
   `a.` 应为 `sw.`，过程无法编译；测试副本已修复继续验证。
2. **DEFECT-SLEEP-002（部署阻断项）**：无索引时性能平方级恶化，
   生产需按建议建索引。

## 7. 结论

1. 睡眠判定、月首复核/重置、月内累积、增量唤醒、不可逆、接触、统计、
   参数校验、错误处理均验证通过（A1~A6、P1~P4）。
2. 两个待审核项：编译别名缺陷（源文件）与索引部署要求。
3. 全部测试在 SCOTT 隔离 schema 完成，未修改任何数据资产文件。

## 7.1 修复与回归（2026-08-01，用户确认）

- DEFECT-SLEEP-001 已修复：源文件 [D] 段 4 处别名 `a.`→`sw.`，
  重新编译成功，A1~A6 回归全部 PASS（未触碰其他逻辑与对象名）。
- DEFECT-SLEEP-002 交付索引部署脚本
  `scripts/oracle_validation/sleep_wake/07_indexes.sql`
  （DWD_TX_ASET(CUST_ID,TX_DATE)、DWS_CUST_ASSE_LIAB(CUST_ID,法人,ORG,DATA_DATE)），
  不改动数据资产文件；生产建索引后 30k 客户 DTL 由 229s 降至 0.56s。
- 详见 `docs/changes/2026-08-01-sleep-wake-defect-fixes.md`。

## 8. 测试产物

- 建表：`01_setup_tables.sql`；转换：`02_convert_procs.ps1`（含测试副本别名修复）
- 数据：`03_load_test_data.sql`；跑批断言：`04_run_and_validate.sql`
- 参数/错误：`05_param_and_error.sql`；性能：`06_perf_test.sql`
- 缺陷台账：`DEFECTS.md`
