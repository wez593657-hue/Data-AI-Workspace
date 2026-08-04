# 到期承接上期数据冻结与定点更新实施变更记录（v2.15.0）

日期：2026-08-03
变更方式：Codex 执行（用户确认）
涉及文件：
- `data_assets/stored_procedure/dws_to_ads/PRC_ADS_CUST_DEADLINE_RMND_DTL.sql`（v2.9.0）
- `data_assets/stored_procedure/dws_to_ads/PRC_ADS_CUST_DEADLINE_RMND_STATIS.sql`（v2.6.0）
- `requirements/到期承接规则记忆卡片.md`、`requirements/05_经营管理.md`、`requirements/需求-代码映射追踪表.md`
- `scripts/oracle_validation/deadline_rmnd/10_prev_period_freeze.sql`（新增回归断言）

## 一、结论

按 2026-08-03 确认的第八批业务口径（34~39），完成到期承接明细/统计过程改造：
上期（上月/上季/上年）基础数据冻结，仅按 30 天承接窗口滚动更新指定字段；
DATA_DATE 采用双语义（本期=跑批日期，上期=期末日期）；
统计表采用方案 B（上期冻结基础列、仅更新率值列）。

## 二、规则与实现

| 口径 | 实现 |
|---|---|
| 34 上期基础数据冻结 | DTL 段1 DELETE 由「当期+上期六组合」改为「当期周期区间本期快照（当月初/季初/年初~V_SYSDAT）+ 旧语义当期结束日」；上期行不再删除 |
| 28 本期快照每日替换 | DTL/STATIS 段1 删除当期周期区间内本期快照行（含同周期早期跑批快照），避免行数随跑批日累积；段9/段4 经 MERGE 重插当日快照 |
| 35 上期实时更新 7 字段 | DTL 段9 由 INSERT 改为 MERGE：上期行 WHEN MATCHED 仅更新 TAKE_RATE、FIX_DEPO_TAKE_RATE、UNDTAKE_STATE、CNTCT_STATE、FIXED_FIN_MATURE_TRAN_INSUR_AMT、FIN_MATURE_TRAN_FIXED_AMT、FIXED_MATURE_TRAN_FIN_AMT；本期行与缺失上期行 WHEN NOT MATCHED 整行插入 |
| 36 统计表方案B | STATIS 段1 仅删除本期统计快照；段4 由 INSERT 改为 MERGE：上期行（期末日期）仅更新 6 个率值列，基础列（客户数/金额/维度）冻结；本期行整行插入 |
| 37 DATA_DATE 双语义 | DTL：本期行 DATA_DATE=V_SYSDAT，上期行=上期期末日期（CASE 按 STAT_PERD+END_DT 判定）；STATIS：段2 取数条件改为 DATA_DATE IN (V_SYSDAT, 上期结束日)，三年清理保留 V_SYSDAT |
| 38 上期更新数据来源 | 上期更新仅以上一周期实例（上月末/上季末/上年末对应 DUE_WIN/STAT_SRC 行）为源，匹配键不含 ORG_ID |
| 39 窗口购买截止 | TAKE_AMT/CROSS_CONV 内联计算在窗口判定上增加 `p.BUY_DT <= TO_DATE(V_SYSDAT,'yyyymmdd')`（join 条件与 CASE WHEN 均补充） |

## 三、迁移与部署说明

1. **旧语义当期行清理**：段1 DELETE 保留 `DATA_DATE = V_CURR_MONTH_END/QUARTER_END/YEAR_END` 三个过渡条件，部署首日自动清理旧语义生成的当期结束日行；存量核对建议在部署前执行：
   ```sql
   SELECT STAT_PERD, DATA_DATE, COUNT(*) FROM ADS_CUST_DEADLINE_RMND_DTL
    WHERE DATA_DATE IN (上月末, 上季末, 上年末, 当月末, 当季末, 当年末)
    GROUP BY STAT_PERD, DATA_DATE;
   ```
2. **调度要求**：月末/季末/年末须执行跑批（标准批量调度）。若周期结束日未跑批，上期行 DATA_DATE 将保持该周期最后跑批日，缺失上期行由 MERGE WHEN NOT MATCHED 按期末日期补建。
3. **索引建议**：DTL 目标表建议增加复合索引 `(STAT_PERD, DATA_DATE, CUST_ID, STATIS_TYP, PERSN_LEGAL_BK_CODE)`，以支撑 MERGE 匹配；STATIS 建议增加 `(STATIS_CYCLE, DATA_DATE, STATIS_OBJ, STATIS_TYP, PERSN_LEGAL_BK_CODE)`。
4. **DEFECT-008 影响**：DWS_CUST_ASSE_LIAB 重复快照缺陷（观察项）未修复；上期基础字段冻结后缺陷值将保留至上游治理修正，属已知影响。

## 四、测试与验证

- 静态校验：括号配平、MERGE 源列与引用一致性、DTL 25 列/STATIS 15 列与 DDL 一致（本次执行通过）。
- 仓库校验脚本：`validate_cross_layer_consistency.py`、`validate_procedure_date_parameters.py`（本次执行）。
- 新增断言脚本：`scripts/oracle_validation/deadline_rmnd/10_prev_period_freeze.sql`（上期 18 字段冻结快照比对、7 字段滚动、本期/上期 DATA_DATE、统计方案B 基础列冻结、幂等重跑）。
- 待执行：Kingbase Oracle 兼容模式编译两过程，并在本地 Oracle 回放 9+1 探针矩阵（06_run_batches 至 09_rate_validation 需按新 DATA_DATE 语义同步调整断言）。

## 五、发布前风险

1. 现有 Oracle 断言脚本（07/08/09）基于「DATA_DATE=周期结束日」旧语义，重跑前需将当期日期断言调整为 V_SYSDAT。
2. MERGE 对目标表无索引时可能产生较大扫描，上线前建议按第三节建立索引并做性能回放。
3. 接触状态/承接状态纳入滚动更新后，上期行展示值会随窗口内新增营销记录/购买记录变化，属预期口径调整（口径35）。

---

# 附录：v3.0.0 两期计算完全分离架构（REQ-CHG-20260803-002，已确认实施）

## 一、架构约束（C1/C2/C3/D1）

| 约束 | 实现 |
|---|---|
| C1 明细单过程 | 全部明细逻辑位于单个 `PRC_ADS_CUST_DEADLINE_RMND_DTL` |
| C2 统计单过程 | 全部统计逻辑位于单个 `PRC_ADS_CUST_DEADLINE_RMND_STATIS` |
| C3 两期逻辑段落分离 | 段9/段4 为**单个 `BEGIN…END;` 匿名块**，块内以注释段落分隔「本期计算段(C1/C2)」「上期计算段(P1/P2)」「数据验证段(V1)」 |
| D1 禁止嵌套过程 | 两个过程内无任何嵌套 PROCEDURE/FUNCTION；TRUNCATE 内联 `EXECUTE IMMEDIATE`，日志内联 `SYS_PRC_STEP_LOGS` |

## 二、隔离存储与验证

- 新增隔离/验证表 7 张：`TMP_CDR_DTL_CURR_STAGE`、`TMP_CDR_DTL_PREV_STAGE`、`TMP_CDR_DTL_FREEZE_LOG`、`TMP_CDR_VALIDATE_RESULT`（共用）、`TMP_CDR_STAT_CURR_STAGE`、`TMP_CDR_STAT_PREV_STAGE`、`TMP_CDR_STAT_FREEZE_LOG`；
- 边界检查：本期断言 `DATA_DATE=V_SYSDAT`，上期断言 `DATA_DATE=上期期末日期`，违规即 `RAISE_APPLICATION_ERROR(-2001x/-2002x)`；
- 验证段 5 项：上期基础字段/列冻结比对（18/9）、更新字段/率值一致性、两期 DATA_DATE 互斥、率值/状态值域、stage 与目标表行数一致；任一 FAIL 中止批次；
- 日志隔离：V_NO_ID 前缀 C1/C2（本期）、P1/P2（上期）、V1（验证）。

## 三、治理

- 7 张新表 DDL 已追加至 `data_assets/ddl/tmp/tmp_pro_ads_cust_deadline_rmnd_dtl.ddl` / `tmp_pro_ads_cust_deadline_rmnd_statis.ddl`；
- 7 张新表审核清单已创建于 `governance/tmp_tables/`（approved）；
- 静态校验：跨层一致性、日期参数规则（执行结果见验证记录）。
