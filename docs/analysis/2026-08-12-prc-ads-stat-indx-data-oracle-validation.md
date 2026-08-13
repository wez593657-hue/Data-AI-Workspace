# PRC_ADS_STAT_INDX_DATA 本地 Oracle 验证报告

## 本轮真实结构复测（2026-08-12）

本轮以项目 DDL 重新核对并在本地 Oracle `SCOTT` schema 重建/复用源表。19 张源表的字段数量、关键非空字段和主键均按真实 DDL 落实；`DWD_SYS_ORG` 使用 5 组“总行-一级分行-二级支行-网点”四层树，共 20 行。每张源表均不少于 20 行，结构和数据校验输出：`STRUCTURE_AND_DATA_PASS source_tables=19 org_depth=4`。

期初调用 `PRC_ADS_STAT_INDX_DATA('20260809')` 返回 `0`，生成基准成员 60 行、客户基准明细 240 行、金额基准汇总 15 行。正式调用 `PRC_ADS_STAT_INDX_DATA('20260810')` 在真实结构下生成 21 个已配置指标，稳定键非空校验和正向指标场景通过。

本轮发现以下结果不能判定为整体通过：停用 `INDX_0080` 后仍发布该指标；四层机构树下 `INDX_0055` 仅产生 2 个原子/机构结果，没有完整上卷到网点、支行、分行、总行；正式 `SYS_FUN_DEAL_DATE` 未实现参数28，导致未补充测试函数时期初范围为空。详见 `scripts/oracle_validation/indx_data/DEFECTS.md`。此前基于简化表结构的测试结果仅作为历史预检，不作为本轮真实结构结论。

本轮新增/使用的关键脚本：`01_generate_oracle_schema.ps1`、`01_setup_tables.sql`、`04_load_full_matrix.sql`、`07_structure_and_data_assert.sql`、`08_patch_test_date_param_28.sql`、`09_run_and_assert_real_schema.sql`、`10_recursive_and_error_assert.sql`。测试专用参数28补丁只作用于 SCOTT，未修改正式项目函数或存储过程。

日期：2026-08-12  
环境：本地 Oracle 11g Enterprise Edition 11.2.0.1.0，服务 `orcl`，测试 schema `SCOTT`。  
过程状态：`SCOTT.PRC_ADS_STAT_INDX_DATA`、`SCOTT.SYS_FUN_DEAL_DATE` 均为 `VALID`。

## 结论

已使用 SCOTT 合成数据执行 `PRC_ADS_STAT_INDX_DATA('20260809')`（期初冻结）及 `PRC_ADS_STAT_INDX_DATA('20260810')`（正式统计）。21 个当前已实现指标均产生结果，正常、边界、排除、规则停用、重复去重、缺失冻结基准和非法日期场景的断言均通过。

本报告验证的是 Oracle 11g 兼容环境中的过程逻辑，不替代 Kingbase 生产数据量、执行计划和并发调度验证。

## 隔离与执行前检查

| 项目 | 结果 |
| --- | --- |
| 数据库与 schema | 本地 `orcl`，仅 `SCOTT` |
| 正式 schema / 正式数据资产写入 | 未执行 |
| 凭据处理 | 仅运行时使用，未写入测试脚本和报告 |
| 测试产物位置 | `scripts/oracle_validation/indx_data/` |
| 测试过程状态 | `VALID` |

## 测试数据样本与行数

跑批日期为 `20260810`，活动/任务开始日为 `20260810`，前一日 `20260809` 完成基准冻结。使用 20 位合成客户、20 个机构、20 个客户经理、20 个商户，活动 `ACT001` 与任务 `TSK001` 覆盖 A/B 路径。

| 源表 | 行数 | 设计说明 |
| --- | ---: | --- |
| `DWD_MKT_ACT_INFO` / `DWD_MKT_INDX_TSK` | 20 / 20 | 1 个有效主场景，19 个历史干扰对象 |
| `DWD_MKT_ACT_TARGT` / `DWD_MKT_TSK_INDX_SUB` | 21 / 40 | 21 指标配置；额外任务行验证范围去重 |
| `DWD_MKT_TSK_INFO` / `DWS_CUST_LVL_INFO` | 40 / 40 | 20 个客户；活动客户重复行及冻结/当前快照 |
| `DWD_CUST_MAN` / `CRM_SYS_POST` / `DWD_SYS_ORG` | 20 / 20 / 20 | 机构、经理归属与递归层级 |
| `DWS_CUST_ASSE_LIAB` | 420 | 20 客户 x 7 日期 x 3 `BAL_TYPE`，覆盖期初、当前、年初、月末、季末、年日均、月日均 |
| `DWD_CUST_INDV_INFO` / `MBK_CUST_INFO` / `MBK_CUST_LOG_LOGIN` | 各 20 | 新客、手机银行、月活条件 |
| `DWD_ACCT_INSUR` / `DWD_ACCT_DEPO` | 各 20 | 16 条有效保单 + 4 条排除；01/02 有效账户和 03 排除账户 |
| `UEPP_PAY_MCT_INFO` / `UEPP_PAY_ORDER_INFO` / `UEPP_PAY_MCT_SETTLE_ACCOUNT` | 各 20 | 10 个个人商户、10 个企业商户；500 等值及低于门槛交易 |
| `DEPO_VALUE_INIT` | 20 | 机构/经理存款基数 |

## 覆盖场景与实际结果

| 场景 | 预期 | 实际 | 结论 |
| --- | --- | --- | --- |
| 期初冻结 | 生成成员、客户状态和金额基准 | 成员 60、状态基准 240、金额基准 15 | 通过 |
| 全指标正常统计 | 21 个已实现指标均产出 | 21 指标、81 条 ADS 结果 | 通过 |
| 客户等级提升 | 0052/0053/0054 有正向提升 | 均为 4 | 通过 |
| 金额基准净增 | 0055/0056/0062 为正；代销 0058/0059 为正 | 500 / 500 / 500；300 / 300 | 通过 |
| 保险有效/失效排除 | 仅 `POLICY_STATE='1'` 与期间内保单计入 | 0061 = 17600 | 通过 |
| 手机银行月活 | 有效登录客户计入 | 0067 = 20 | 通过 |
| 新客 180 天和 100/2 边界 | 窗口内、余额/产品达到阈值计入；99 元排除 | 0080 = 20 | 通过 |
| 商户类型与 500 门槛 | 仅个人商户、成功收款累计不少于 500 计入 | 0081 = 201.80 | 通过 |
| 新增客户重复去重 | 同一客户重复活动任务只计一次 | 0082 = 19 | 通过 |
| 借记卡类型过滤 | 仅 01/02 且卡号非空计入，03 排除 | 0083 = 14 | 通过 |
| 规则停用 | 停用 0080 后不得发布 | `DISABLED_RULE_PASS` | 通过 |
| 缺失基准 | 删除 0055 冻结汇总后，已开始对象必须失败 | 捕获过程异常 `-20099` | 通过 |
| 非法日期 | `20261340` 必须拒绝 | 捕获过程异常 `-20099` | 通过 |

## 最终正常快照摘要

| 指标 | 结果行数 | 当前值范围 |
| --- | ---: | --- |
| 0046 | 21 | 2000 |
| 0047 | 3 | 19409 - 20210 |
| 0048、0049、0050 | 各 3 | 2000 |
| 0051 | 3 | 45983 |
| 0052、0053、0054 | 各 3 | 4 |
| 0055、0056、0062 | 各 3 | 500 |
| 0058、0059 | 各 3 | 300 |
| 0061 | 3 | 17600 |
| 0063 | 3 | 1 |
| 0067 | 3 | 20 |
| 0080 | 3 | 20 |
| 0081 | 3 | 201.80 |
| 0082 | 3 | 19 |
| 0083 | 3 | 14 |

## 执行步骤

1. 使用 `04_load_full_matrix.sql` 清理并装载 SCOTT 合成数据，同时在 `20260809` 冻结期初基准。
2. 使用 `05_run_and_assert_full_matrix.sql` 跑 `20260810` 正常矩阵，校验 21 指标、非空业务键、正向客户状态/金额/商户场景、规则停用和非法日期。
3. 使用 `06_negative_and_snapshot.sql` 校验重复客户去重和基准缺失阻断。
4. 再次执行步骤 1 与正常跑批，保留完整正常数据快照供复核。

## 交付文件

- `scripts/oracle_validation/indx_data/04_load_full_matrix.sql`
- `scripts/oracle_validation/indx_data/05_run_and_assert_full_matrix.sql`
- `scripts/oracle_validation/indx_data/06_negative_and_snapshot.sql`
- `scripts/oracle_validation/indx_data/DEFECTS.md`

## 残余风险

- 该矩阵覆盖当前过程已实现的 21 项指标；未实现或未注册的指标不在本次范围。
- `ORA-20099` 是过程统一异常封装码；底层业务错误通过过程日志文本进一步定位。
- 未覆盖生产规模性能、并发运行和 Kingbase 执行计划，需要在 Kingbase 测试库单独验证。
