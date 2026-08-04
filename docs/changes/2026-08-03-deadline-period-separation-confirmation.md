# 变更确认单：到期承接两期计算分离架构（v3.0.0）

- 变更编号：REQ-CHG-20260803-002
- 状态：**EXECUTED（已确认执行）→ VERIFIED（静态校验通过）**
- 提交日期：2026-08-03
- 提交人：Codex（AI）
- 审核人：待用户确认

## 一、变更目标

按「数据处理系统设计」要求，将到期承接明细/统计处理重构为**两期计算完全分离**架构：
本期与上期各自拥有独立计算模块、独立隔离存储、严格边界检查、独立日志与统一验证，
同时严格遵守 C1/C2（单存储过程）、C3（两期逻辑段落分离）与 D1（**禁止嵌套过程**）约束。

## 二、约束符合性自查

| 约束 | 符合性 | 说明 |
|---|---|---|
| C1 明细单过程化 | ✅ | 全部明细逻辑位于单个 `PRC_ADS_CUST_DEADLINE_RMND_DTL`，不新建任何顶层过程 |
| C2 统计单过程化 | ✅ | 全部统计逻辑位于单个 `PRC_ADS_CUST_DEADLINE_RMND_STATIS`，不新建任何顶层过程 |
| C3 两期逻辑段落分离 | ✅ | 本期与上期逻辑位于**同一个 `BEGIN…END;` 匿名块内**，块内以注释段落（9.1 本期计算段 / 9.2 上期计算段 / 9.3 验证段）分隔；日志前缀 C1/C2（本期）与 P1/P2（上期）、V1（验证）互不混用；两期结果写入独立隔离存储表；各段落自带周期边界 WHERE 与断言（RAISE -2001x/-2002x） |
| D1 禁止嵌套过程 | ✅ | 存储过程内不声明任何嵌套 PROCEDURE/FUNCTION；原 `TRUNC_TMP`/`LOG_STEP`/`CALC_*`/`VALIDATE_*` 全部改为内联语句；本期/上期/验证全部位于**单个 `BEGIN…END;` 块**内，以注释段落分隔书写 |

## 三、影响文件清单

### 已应用改动（本确认单追溯确认）

| 文件 | 改动 |
|---|---|
| `data_assets/stored_procedure/dws_to_ads/PRC_ADS_CUST_DEADLINE_RMND_DTL.sql` | v3.0.0（中间态）：段1 区间删除（保留上期）；段9 冻结快照 + 模块调用；**已含嵌套过程，需按 D1 重构为匿名逻辑段** |
| `data_assets/stored_procedure/dws_to_ads/PRC_ADS_CUST_DEADLINE_RMND_STATIS.sql` | v3.0.0（中间态）：段1 增加隔离存储 TRUNCATE；**已含嵌套过程，需按 D1 重构为匿名逻辑段；段4 未接线** |

### 待确认后执行（本确认单获批后实施）

| 文件 | 改动 |
|---|---|
| `data_assets/stored_procedure/dws_to_ads/PRC_ADS_CUST_DEADLINE_RMND_DTL.sql` | **D1 重构**：删除全部嵌套过程（TRUNC_TMP/LOG_STEP/CALC_CURR_PERIOD/CALC_PREV_PERIOD/VALIDATE_PERIODS）；TRUNCATE 内联化；段9 改为**单个 `BEGIN…END;` 匿名块**，块内以注释段落书写「冻结快照 / 本期计算段 / 上期计算段 / 验证段」；日志内联 |
| `data_assets/stored_procedure/dws_to_ads/PRC_ADS_CUST_DEADLINE_RMND_STATIS.sql` | **D1 重构**：删除全部嵌套过程（TRUNC_TMP/LOG_STEP/CALC_CURR_STAT/CALC_PREV_STAT/VALIDATE_STATIS）；TRUNCATE 内联化；段4 接线为**单个 `BEGIN…END;` 匿名块**，块内分段落书写「上期冻结快照 / 本期计算段 / 上期计算段 / 验证段」；头部变更记录 v3.0.0 |
| `data_assets/ddl/tmp/tmp_pro_ads_cust_deadline_rmnd_dtl.ddl` | 新增 4 张隔离/验证表：TMP_CDR_DTL_CURR_STAGE、TMP_CDR_DTL_PREV_STAGE、TMP_CDR_DTL_FREEZE_LOG、TMP_CDR_VALIDATE_RESULT |
| `data_assets/ddl/tmp/tmp_pro_ads_cust_deadline_rmnd_statis.ddl` | 新增 3 张隔离/验证表：TMP_CDR_STAT_CURR_STAGE、TMP_CDR_STAT_PREV_STAGE、TMP_CDR_STAT_FREEZE_LOG |
| `governance/tmp_tables/` | 为上述 7 张新表补齐审核清单 JSON（另建议补全既有 TMP_CDR_* 族清单） |
| `docs/changes/2026-08-03-deadline-rmnd-prev-period-freeze.md` | 追加 v3.0.0 分离架构实施记录 |
| `scripts/oracle_validation/deadline_rmnd/10_prev_period_freeze.sql` | 增加模块调用/日志/验证结果断言 |

## 四、逻辑改动点

1. **单个 `BEGIN…END;` 块内分段落**：本期计算段、上期计算段、验证段均写在同一个匿名块内，段落之间用注释头（如 `-- ===== 【本期计算段】开始 =====`）与段落尾注释明确分隔。
2. **本期计算段**：仅读取当期周期实例（END_DT=当期结束日 / DATA_DATE=V_SYSDAT），结果写入 `*_CURR_STAGE`，整行写入目标表；边界断言 `DATA_DATE<>V_SYSDAT 即中止`。
3. **上期计算段**：仅读取上期周期实例（END_DT=上期结束日 / DATA_DATE=上期期末日期），结果写入 `*_PREV_STAGE`，对目标表仅更新 7 字段（明细）/ 6 率值列（统计）；边界断言 `DATA_DATE 与上期期末一一对应`。
4. **验证段**：冻结快照比对（明细 18 基础字段 / 统计 9 基础列）、更新字段一致性、两期 DATA_DATE 互斥、率值/状态值域、stage 与目标表行数一致；任一 FAIL 即中止批次（RAISE -2001x/-2002x）。
5. **日志隔离**：同一块内各段落内联调用 `SYS_PRC_STEP_LOGS`，V_NO_ID 使用 C1/C2（本期）、P1/P2（上期）、V1（验证）前缀；TRUNCATE 直接内联 EXECUTE IMMEDIATE（不借助嵌套助手）。

## 五、中间态说明（重要）

当前工作区处于重构中间态：

- DTL 过程已接线但**含嵌套过程**（违反 D1），STATIS 过程含嵌套过程且段4 未接线（旧 MERGE 仍在）；
- 两个过程已引用 7 张**尚未建表**的隔离/验证表，因此在补齐 DDL 前无法编译（预期行为）；
- 获批后首先执行 D1 重构（删除嵌套过程→匿名逻辑段），再接线 STATIS 段4 并补齐 DDL；
- 获批执行待办清单后即可恢复可编译状态并运行静态校验。

## 六、测试与验证计划

- 静态校验：`validate_cross_layer_consistency.py`、`validate_procedure_date_parameters.py`、括号/引用结构核对；
- Oracle/Kingbase 回放：10_prev_period_freeze.sql（F1 冻结、F2 滚动、F3 DATA_DATE、F4 方案B、F5 幂等）+ 新增日志/验证结果断言；
- 边界用例：跨期引用注入（本期行含上期日期）应触发 -20011/-20021 并回滚。

## 七、风险与回退

- 未建表前不可编译：待办清单第 2 项补齐 DDL 后解决；
- 重构代码量大且含 D1 重构（删除嵌套过程），需编译级回放确认；回退方案：恢复本确认单「已应用改动」前的工作区版本（git 还原指定文件）。

---

**审核结论（待用户填写）**：□ 确认执行待办清单　□ 需调整（说明）　□ 拒绝/回退

---

## 八、执行记录（2026-08-03，用户确认后执行）

1. ✅ DTL D1 重构：删除全部嵌套过程，段9 改为单个 `BEGIN…END;` 块分段落（冻结快照/本期段/上期段/验证段），TRUNCATE 与日志内联；
2. ✅ STATIS D1 重构 + 段4 接线：删除全部嵌套过程，段4 改为单个 `BEGIN…END;` 块分段落（4.0~4.3）；
3. ✅ 7 张隔离/验证表 DDL 追加至两个 tmp DDL 文件；
4. ✅ 7 张新表 governance 审核清单 JSON（approved）；
5. ✅ 变更实施文档与测试脚本同步（含 C/P/V 日志与验证结果断言）；
6. ✅ 静态校验：跨层一致性、日期参数规则通过（exit 0）。

> 校验证据：`validate_cross_layer_consistency.py` exit 0；`validate_procedure_date_parameters.py` exit 0；
> 结构核对：两过程括号配平、无嵌套过程、段落标记完整。
