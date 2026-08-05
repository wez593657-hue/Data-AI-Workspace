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

## DEFECT-INSUR-002：大数据量下性能平方级恶化（部署阻断项）

- **状态**：待审核
- **具体位置**：2.1 快照聚合（5 表 JOIN + DWD_CUST_INDV_INFO LEFT JOIN）、
  2.2 NOT EXISTS、2.3 MERGE
- **影响范围**：1 万保单（2 万交易）21.2s；3 万保单 182.8s；5 万保单 >500s 超时；
  非线性增长，生产每日跑批不可接受
- **复现证据**：本地 Oracle 实测（见报告）
- **建议**：为关联列建索引（如 DWD_CUST_INDV_INFO(CUST_ID)、
  YBT_POLICY_FEE_LIST(ORD_PAY_SERIAL) 等），并核查执行计划
- **处理决策**：待用户确认

---

## DEFECT-INSUR-003：共享快照临时表导致并发跑批冲突（并发缺陷）

- **状态**：待审核
- **具体位置**：`TMP_DWD_ACCT_INSUR_SNAP`（物理共享表，2.1 TRUNCATE+INSERT）
- **影响范围**：两个会话同时执行本过程时，第二个会话报
  ORA-00001（PK_TMP_SNAP violated），批处理失败；生产并发调度/重跑重叠风险
- **复现证据**：双会话并发实测（见报告）
- **建议**：批处理串行化（调度锁/单实例执行），或改用会话级临时表
- **处理决策**：待用户确认

---

## 发现与观察项（非阻断）

1. **代码 vs ODS DDL 不一致**：过程引用 `YBT_POLICY_FEE_LIST.TX_DATE`，
   工作区该表 DDL 无 TX_DATE 列（测试补列验证）；实际交易日期字段
   （ORD_CREATE_DATE 等）需确认。
2. **字段语义错位**：DWD_ACCT_INSUR 的 INSUR_PERIOD_TYP/INSUR_PERIOD 填充自
   PAY_PER_UNIT/PAY_PER_NUM（缴费期间），PAY_PERIOD_TYP/PAY_PERIOD 填充自
   VALID_PER_UNIT/VALID_PER_NUM（保险期间）——字段名与内容语义相反，需业务确认。
3. **POLICY_STATE 透传非法值**：CONT_STATUS='9' 等非法码值原样写入 POLICY_STATE
   （INSUR_AMT 已清零），无码值校验。
4. **参数校验分支无日志**：V_SYSDAT 格式非法时 OUTCDE=-1+RETURN，未写
   SYS_PRC_STEP_LOG（与 EXCEPTION 分支不一致）。
5. **文档同步滞后**：保险账户需求记忆卡片仍为 v1.0.1，代码 v2.2.0 / DDL v2.0.0
   未同步。
