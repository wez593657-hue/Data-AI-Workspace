# 保险账户信息表 YBT 日期口径修复

## 问题描述

过程引用了未定义的交易日期字段 `YBT_POLICY_FEE_LIST.TX_DATE`，且源实体名与已确认的 YBT DDL 不一致。现行业务口径为：`TX_DATE` 取保单投保日期 `ACCEPT_DATE`；`LAST_TX_DATE` 取缴费成功状态 `ORD_TRAN_STATUS='2'` 的最近 `ORD_CREATE_DATE`，无成功缴费时回退 `ACCEPT_DATE`。

## 修复方案

1. 源表统一为 `YBT_YBT_POLICY_BASE_INFO`、`YBT_YBT_POLICY_FEE_LIST`、`YBT_YBT_POLICY_INSURANCE_INFO`、`YBT_YBT_PRODUCT_INFO` 与 `YBT_IB_LIST_PLAT`。
2. 将 `ACCEPT_DATE` 作为投保日期和趸交满一年计算基准，按 `YYYYMMDD` 解析。
3. 以保单流水号预聚合交易表：成功订单计算最近交易日期，终止交易计算实际终止日期，消除原相关子查询。
4. 无成功缴费记录时，`LAST_TX_DATE` 回退至 `ACCEPT_DATE`；不新增或修改源表主键。
5. 同步 Mapping，并新增 `08_tx_date_last_tx_date_regression.sql` 覆盖多笔成功取最新、失败订单不影响最近日期、无成功回退投保日期。

## 测试结果

| 项目 | 结果 | 说明 |
|---|---|---|
| 日期参数静态校验 | 通过 | `validate_procedure_date_parameters.py` 返回 0。 |
| 跨层结构静态校验 | 通过 | `validate_cross_layer_consistency.py` 返回 0；不检查对象、字段或运行语义。 |
| SQL 格式检查 | 通过 | 本次修改文件无 `git diff --check` 新增格式问题；工作区存在无关存量格式问题。 |
| Oracle 功能回归 | 待执行 | 已提供可执行脚本；本轮未连接 Oracle/Kingbase，不能声称已通过。 |
| 并发与性能实测 | 待执行 | `07_concurrency.sql` 与 `06_perf_test.sql` 需在目标数据库使用真实统计信息执行。 |

## 性能对比与注意事项

修复前，`ACTL_TERM_DATE` 使用每保单相关子查询重复扫描交易表；修复后，交易日期和终止日期在单次按保单预聚合中计算并复用。理论上可降低相关子查询造成的重复扫描，但没有数据库实测数据时，不提供伪造耗时对比。执行 `06_perf_test.sql` 时应记录修复前后同数据量的耗时、逻辑读、临时空间和执行计划；目标数据库应重点确认交易表 `PLAT_POLICY_SERIAL`、交易流水表 `PLAT_SERIAL`、客户表 `CUST_ID` 的访问计划。

源交易表不设主键意味着过程可处理多笔交易，但上游仍应保证订单数据的业务唯一性和幂等投递；重复成功订单会按当前既有金额逻辑参与累计。
