# 保险账户存储过程本地 Oracle 验证缺陷台账

依据 `docs/standards/oracle-local-testing-policy.md` 第 4 节登记。

---

## DEFECT-2026-08-05-004：v2.3.0 Oracle 编译在快照段结束后失败

- **状态**：待审核
- **具体位置**：`scripts/oracle_validation/acct_insur/oracle_PRC_DWD_ACCT_INSUR.sql`；Oracle `USER_ERRORS` 报告第 253 行，`V_NO_ID := '2';`。
- **影响范围**：`PRC_DWD_ACCT_INSUR` 在本地 Oracle 11g `SCOTT` schema 中状态为 `INVALID`，后续功能回归、并发及性能测试无法执行。
- **复现证据**：部署 YBT v2.3.0 测试表并编译后，Oracle 返回 `PLS-00103: 出现符号 "2"`。独立最小过程的 `VARCHAR2` 赋值通过，排除本地 Oracle 与赋值语法问题。
- **初步分析**：错误位置位于快照段之后，疑似前置聚合 SQL 或 Oracle 兼容模式过程结构未被正确闭合；需对快照段逐段缩减/编译定位后修复。
- **建议解决方案**：在 Oracle 验证副本中定位最小失败片段，确认修复不改变 Kingbase 业务语义后，再同步修改正式过程并重新生成 Oracle 副本。
- **处理决策**：待用户确认。

---

## DEFECT-INSUR-001：YBT_POLICY_FEE_LIST 主键单列导致一保单多交易无法存储（阻断级）

- **状态**：待审核
- **具体位置**：`data_assets/ddl/ods/ybt/ybt_ybt_policy_fee_list.sql`
  `CONSTRAINT pk_ybt_ybt_policy_fee_list PRIMARY KEY (plat_policy_serial)`
- **影响范围**：同一保单的多笔交易（新单+续期+退保/满期给付等）无法插入
  （ORA-00001）；过程 2.1 聚合逻辑（MIN/MAX TX_DATE、COUNT(TRAN_TYPE='1')、
  MAX(TRAN_TYPE 2-8) 终止日期）依赖多交易行，按现有 DDL 数据不完整
- **复现证据**：测试插入同保单 2 笔交易报 ORA-00001；测试环境改复合主键
  (PLAT_POLICY_SERIAL, ORD_PAY_SERIAL) 后正常聚合
- **建议**：主键改为复合键（如 PLAT_POLICY_SERIAL+ORD_PAY_SERIAL 或 +ORD_ID），
  需与 ODS 实际主键设计确认
- **处理决策**：待用户确认

---

## DEFECT-INSUR-002：大数据量下性能非线性恶化

- **状态**：优化待实测
- **具体位置**：v3.2.0 的物理明细、预聚合和快照临时表链路。
- **影响范围**：1 万保单（2 万交易）21.2s；3 万保单 182.8s；5 万保单 >500s 超时；
  非线性增长，生产每日跑批不可接受
- **复现证据**：本地 Oracle 实测（见报告）
- **处理结果**：v3.3.0 已将明细、日期预聚合和四键聚合收敛为单条 CTE
  集合化写入，移除三张 TMP 表的清理、写入、回读及中间提交。需要在目标
  Oracle/Kingbase 验证库执行 `06_perf_test.sql` 后，以相同数据规模记录新耗时。

---

## DEFECT-INSUR-003：并发全量刷新风险

- **状态**：部分缓解，待审核
- **具体位置**：`DWD_ACCT_INSUR` 全量 `DELETE` 后重建。
- **影响范围**：v3.3.0 已消除共享快照表及其主键冲突；但两个会话并发执行时仍可能
  相互覆盖目标表的刷新结果，生产调度仍应保证同一过程单实例运行。
- **处理结果**：物理快照表已移除；保留 `07_concurrency.sql` 验证刷新模式风险。
- **处理决策**：待用户确认

---

## 发现与观察项（非阻断）

1. **已修复：代码 vs ODS DDL 不一致**：v3.3.0 使用
   `YBT_YBT_POLICY_*`、`IBP_IB_LIST_PLAT` 与 `ORD_CREATE_DATE`，不再引用
   不存在的 `TX_DATE` 字段。
2. **字段语义错位**：DWD_ACCT_INSUR 的 INSUR_PERIOD_TYP/INSUR_PERIOD 填充自
   PAY_PER_UNIT/PAY_PER_NUM（缴费期间），PAY_PERIOD_TYP/PAY_PERIOD 填充自
   VALID_PER_UNIT/VALID_PER_NUM（保险期间）——字段名与内容语义相反，需业务确认。
3. **POLICY_STATE 透传非法值**：CONT_STATUS='9' 等非法码值原样写入 POLICY_STATE
   （INSUR_AMT 已清零），无码值校验。
4. **参数校验分支无日志**：V_SYSDAT 格式非法时 OUTCDE=-1+RETURN，未写
   SYS_PRC_STEP_LOG（与 EXCEPTION 分支不一致）。
5. **文档同步滞后**：保险账户需求记忆卡片仍为 v1.0.1，代码 v2.2.0 / DDL v2.0.0
   未同步。
