# 潜力提升明细/统计存储过程验证报告

日期：2026-08-01
环境：本地 Oracle 11.2.0.1（ORCL），SCOTT schema（隔离规范）
对象：PRC_ADS_CUST_POTN_UPGRADE_CUST_DTL / PRC_ADS_CUST_POTN_UPGRADE_STATIS
（Oracle 版改名 PRC_ADS_CUST_POTN_UPGRADE_DTL / PRC_ADS_CUST_POTN_UPGRADE_STAT，
仅测试副本，不改源文件）
依据：requirements/潜力提升规则记忆卡片.md（v3.1.x）

## 1. 验证范围

1. 输入参数校验（边界值、异常值）
2. 核心业务逻辑正确性
3. 输出结果完整性与准确性
4. 性能测试（不同数据量）
5. 错误处理机制

## 2. 测试数据（18 个探针客户）

覆盖：5 个临界等级（03~07）、临界区间上下边界（4.5万/5万、27万/30万、45万/50万、
90万/100万、270万/300万）、排除区间（<4.5万、[5万,27万) 无匹配、≥300万）、
时点 AUM 缺失、月均 AUM 缺失、跨机构客户（P14 双机构）、无管户、无效管户类型
（MNG_TYP='2'）、接触记录在月初前、无效接触类型（'5'）、跑批日当天接触。

## 3. 功能验证结果（F1~F8）

| 用例 | 验证点 | 预期 | 实际 | 结论 |
|---|---|---|---|---|
| F1 | 明细行数与跨机构无放大 | 15 行；P14=2 行 | 21 行；P14=8 行 | **FAIL（DEFECT-POTN-001）** |
| F2 | 临界等级判定（5 等级边界） | P01=03…P08=07 等 | 全部正确 | PASS |
| F3 | 排除规则（P03/P09/P10/P11） | 0 行 | 0 行 | PASS |
| F4 | 时点达标判断（含时点缺失→0） | 13 客户各预期值 | 全部正确 | PASS |
| F5 | 接触状态（月初前/无效类型/当天边界） | P17=0、P18=1 等 | 全部正确 | PASS |
| F6 | 输出完整性（DATA_DATE/周期/管户/机构） | 15 行字段完整、2 行无管户 | 一致 | PASS |
| F7 | 统计表机构汇总（未污染切片） | ORG100 04=4/1/25/2/50/1/25；ORG102 03=100 系列 | 一致 | PASS |
| F8 | 统计表客户经理汇总（PM100） | 5 等级 TTL/率值精确 | 一致 | PASS |

## 4. 参数校验结果（P1）

| 输入 | 预期 | 实际 | 结论 |
|---|---|---|---|
| NULL | ORA-20001 | -20001 | PASS |
| 7 位（2026063） | ORA-20001 | -20001 | PASS |
| 非数字（ABCDEFGH） | ORA-20001 | -20001 | PASS |
| 含空格 | ORA-20001 | -20001 | PASS |
| 格式合法日期非法（20260230） | 运行期错误被捕获 | ORA-01839 被 EXCEPTION 捕获 | PASS |

DTL 与 STATIS 行为一致；合法输入返回 RC=0（P2）。

## 5. 错误处理机制（P3/P4）

- 运行期错误（无效日期）→ EXCEPTION 捕获 → OUTCDE=-1 → ROLLBACK → 日志 LOG_FLG=-1
  记录错误信息（SYS_PRC_STEP_LOG 实证）→ RAISE 抛出 → PASS
- 依赖对象缺失（DROP 中间表）→ 过程变为 INVALID，调用报 PLS-00905（Oracle 依赖机制），
  恢复表并重新编译后可正常运行（P4 RC=0）→ PASS

## 6. 性能测试结果（P5）

| 数据量（临界客户） | DTL 耗时 | STATIS 耗时 | 明细行数 |
|---|---|---|---|
| 10,000 | 0.17s | 0.08s | 10,000 |
| 30,000 | 0.43s | 0.15s | 30,000 |
| 50,000 | 0.56s | 0.24s | 50,000 |

执行时间随数据量近似线性增长，5 万客户总量 <1s，性能达标。

## 7. 发现的问题

**DEFECT-POTN-001（已关闭，不修复）**：跨机构客户（同客户号+法人行多 ORG_ID）时，
TMP_ADS_POTN_BASE 中 T-1 时点（b）与当月月均（m）LEFT JOIN 未按 ORG_ID 关联，
产生笛卡尔积（P14 2 行→8 行），明细与统计全部放大。
根因：变更记录 v2.4.3 移除 ORG_ID 条件，与需求 v2.2.0"三键关联避免笛卡尔积"相悖。
**用户确认（2026-08-01）**：DWS_CUST_ASSE_LIAB 在同一个法人机构下 ORG_ID 唯一
（1:1），同客户号+法人行不会出现多 ORG_ID 行，P14 场景属数据异常而非过程缺陷，
无需修复，缺陷关闭。该行为保留为"异常数据防御"观察项（与到期承接需求附录 23 一致）。
详见 `scripts/oracle_validation/potn_upgrade/DEFECTS.md`。

## 8. 结论

1. 参数校验、核心逻辑（等级判定/达标/接触/排除）、输出完整性、错误处理、
   性能均验证通过（F2~F8、P1~P5 PASS）。
2. 跨机构放大现象经用户确认为异常数据行为（同法人行 ORG_ID 1:1 业务规则），
   不作为缺陷修复；真实数据出现时按数据异常处理。
3. 全部测试在 SCOTT 隔离 schema 完成，未修改任何数据资产文件。

## 9. 测试产物

- 建表：`scripts/oracle_validation/potn_upgrade/01_setup_tables.sql`
- 过程转换：`scripts/oracle_validation/potn_upgrade/02_convert_procs.ps1`
- 数据加载：`03_load_test_data.sql`；功能断言：`04_func_validation.sql`
- 参数/错误：`05_param_and_error.sql`；性能：`06_perf_test.sql`
- 缺陷台账：`scripts/oracle_validation/potn_upgrade/DEFECTS.md`
