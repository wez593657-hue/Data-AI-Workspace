# 保险账户信息表存储过程深度验证报告

日期：2026-08-03
环境：本地 Oracle 11.2.0.1（ORCL），SCOTT schema（隔离规范）
对象：PRC_DWD_ACCT_INSUR（ODS→DWD 保险账户，v2.2.0）、DWD_ACCT_INSUR（v2.0.0）

## 1. 验证范围

表结构、数据完整性（主键/约束）、业务逻辑、边界值、异常数据、性能、
并发、参数校验、错误处理。

## 2. 表结构与数据完整性（T1，PASS）

- 目标表 26 列与过程 INSERT 列清单一致
- 5 个 NOT NULL：CUST_ID/ACCT_ID/PRDKT_ID/INSUR_BID_FORM_NO/POLICY_STATE
- 四键主键 PK(CUST_ID,ACCT_ID,PRDKT_ID,INSUR_BID_FORM_NO) 生效
- 2 个二级索引（POLICY_STATE、CUST_ID）存在
- 无外键（ODS/DWD 均未定义 FK，属当前设计）

## 3. 业务逻辑验证（T2，PASS）

| 场景 | 预期 | 实际 |
|---|---|---|
| 新单+续期聚合 | TX_DATE=min/LAST=max；INSUR_AMT=新单+续期 | C001=20000 ✓ |
| 趸交未满一年 | INSUR_AMT=保费 | C002=50000 ✓ |
| 趸交满一年 | INSUR_AMT=0 | C003=0 ✓ |
| 失效/未生效 | INSUR_AMT=0 | C004/C005=0 ✓ |
| 期缴缴满 | INSUR_AMT=0 | C006=0 ✓ |
| 宽限期过 60 天未缴 | INSUR_AMT=0 | C007=0 ✓ |
| 三笔交易聚合 | TX/LAST 正确，INSUR_AMT=3×12000 | C008=36000 ✓ |
| 终止交易 ACTL_TERM | 状态交易最新日期 | C009=20260520 ✓ |
| 保至年龄推算 | 证件号出生日+年限 | C010=2045-01-01 ✓ |
| 永久保单 | CANCL=9999-12-31 | C011 ✓ |
| 非法状态 | INSUR_AMT=0 | C012=0 ✓（POLICY_STATE 透传 '9'） |
| 法人行映射 | 15/12/18/其他→1500/1200/1800/9999 | 全部 ✓ |
| TX_TYP 置空 | NULL | ✓ |

## 4. 幂等性（T3，PASS）

同批日重跑：行数不变（13）、金额一致（UPSERT 语义）。

## 5. 参数校验（T4）

- NULL/7 位/字母/含空格 → OUTCDE=-1（RETURN，不抛异常，无日志）
- 格式合法日期非法（20260230）→ ORA-01839 被 EXCEPTION 捕获、日志 LOG_FLG=-1
- 合法日期 → RC=0

## 6. 异常处理（T5/T6，PASS）

- 依赖对象缺失 → 过程 INVALID（Oracle 机制），恢复后正常
- 运行期错误 → 整体回滚、日志记录、RAISE

## 7. 性能测试（发现平方级问题，DEFECT-INSUR-002）

| 保单量（×2 交易） | 耗时 |
|---|---|
| 10,000 | 21.2s |
| 30,000 | 182.8s |
| 50,000 | >500s（超时） |

非线性增长，需索引优化（见缺陷台账建议）。

## 8. 并发测试（发现冲突，DEFECT-INSUR-003）

双会话同时执行本过程：会话 1 成功（13 行）；会话 2 报
ORA-00001（PK_TMP_SNAP violated）——共享快照临时表并发不安全。

## 9. 发现的问题汇总（详见 DEFECTS.md）

| 编号 | 问题 | 级别 |
|---|---|---|
| DEFECT-INSUR-001 | 保单交易表单列主键无法存多交易 | 阻断 |
| DEFECT-INSUR-002 | 大数据量性能平方级恶化 | 部署阻断 |
| DEFECT-INSUR-003 | 共享快照表并发跑批冲突 | 并发缺陷 |
| 观察 1 | 代码引用 TX_DATE 但 ODS DDL 无此列 | 待确认 |
| 观察 2 | INSUR_PERIOD/PAY_PERIOD 字段语义错位 | 待确认 |
| 观察 3 | POLICY_STATE 透传非法码值 | 观察 |
| 观察 4 | 参数校验分支无日志 | 观察 |
| 观察 5 | 需求卡片版本滞后（v1.0.1 vs 代码 v2.2.0） | 文档 |

## 10. 结论

1. 业务逻辑（聚合/金额规则/日期推算/法人行映射/幂等）与最新代码一致，验证通过。
2. 三个待审核缺陷（交易表主键、性能、并发）影响上线；五个观察项待业务/文档确认。
3. 全部测试在 SCOTT 隔离 schema 完成，未修改任何数据资产文件
   （测试环境表结构按发现调整以继续验证）。

## 11. 测试产物

- 建表：`01_setup_tables.sql`；转换：`02_convert_procs.ps1`
- 数据：`03_load_test_data.sql`；结构/逻辑：`04_structure_and_logic.sql`
- 性能：`06_perf_test.sql`；并发：`07_concurrency.sql`
- 缺陷台账：`DEFECTS.md`
