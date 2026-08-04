# DWD_ACCT_INSUR 保单级主档重构与 DWS 简化适配（v2.0.0 / v3.0.0）

> 变更日期：2026-08-03
> 范围：DWD_ACCT_INSUR（保险账户信息）ODS→DWD 加工与 DWS_CUST_ASSE_LIAB_CUMU 保险余额计算
> 状态：已实施（待数据库编译验证与历史迁移）

## 一、设计定稿决策（经人工审核确认）

| 决策点 | 结论 |
|---|---|
| 表粒度 | 保单级主档：一保单一行，主键 (CUST_ID, ACCT_ID, PRDKT_ID, INSUR_BID_FORM_NO) |
| 写入方式 | MERGE/UPSERT，永不 DELETE（终止保单保留）；取消 TRUNCATE 全量重建 |
| 状态判定 | POLICY_STATE（CONT_STATUS 原值）：0 未生效 / 1 正常 / 2 失效；唯一状态判定源，DWS/ADS 不按交易类型判断 |
| 宽限期 | 不表达宽限期状态；INSUR_AMT 承担"60 天宽限期未缴费清零"规则 |
| 金额口径 | INSUR_AMT = 新单保费 + 续期保费累计；终止/未生效/趸交满一年/期缴缴满/宽限期过 60 天未缴 均置 0 |
| 趸交起算点 | TX_DATE（首次交易/缴费日期）+ 12 个月 |
| 终止日期 | ACTL_TERM_DATE：状态交易(2/3/4/5/6/8)最新日期 → CONT_STATUS 终止变更日 → CANCL_INSUR_DATE 回退；CANCL_INSUR_DATE 仅作期间参考 |
| 字段取舍 | 只新增 LAST_TX_DATE/ACTL_TERM_DATE/NEW_INSUR_AMT；不引入 RENEW_INSUR_AMT、POLICY_STATUS、INSUR_BAL、FIRST_TX_DT |
| DWS | 不再读 HIS、不再用交易类型；2.3-2.10 段删除；直接聚合 DWD_ACCT_INSUR.INSUR_AMT |

## 二、表结构（26 列）

| 分组 | 字段 |
|---|---|
| 主键 | CUST_ID, ACCT_ID, PRDKT_ID, INSUR_BID_FORM_NO（均 NOT NULL） |
| 客户/产品 | CUST_TYP, PRDKT_NAME, PRDKT_CATE_BIG |
| 日期 | TX_DATE(首次交易,VARCHAR2(8)), LAST_TX_DATE(最近交易), BGN_INSUR_DATE(起保/首期承保基准), CANCL_INSUR_DATE(推算,仅参考), ACTL_TERM_DATE(实际终止), PAY_UPTO_DATE |
| 期间/缴费 | INSUR_PERIOD_TYP, INSUR_PERIOD, PAY_PERIOD_TYP, PAY_PERIOD, PAY_PATRN |
| 金额 | NEW_INSUR_AMT(首期保费), INSUR_AMT(当前保险金额) |
| 状态 | POLICY_STATE(0/1/2, NOT NULL), TX_TYP(统一置空) |
| 机构 | TX_ORG, TX_CHNL, MKT_ORG, PERSN_LEGAL_BK_CODE |

索引：主键 4 键 + IDX(POLICY_STATE) + IDX(CUST_ID)。

## 三、修改文件清单

| 文件 | 修改内容 |
|---|---|
| data_assets/mapping/ods_to_dwd/DWD明细层数据模型_CRM_ V1.0.xlsx | 26 字段登记、规则更新、变更登记（脚本待文件解锁后执行） |
| data_assets/mapping/ods_to_dwd/ods到dwd映射.md | 字段映射同步（26 字段） |
| data_assets/ddl/dwd/dwd_acct_insur.sql | v2.0.0：26 列、主键、索引、注释 |
| data_assets/ddl/dwd/dwd_acct_insur_his.sql | v2.0.0：归档定位，同步新字段 |
| data_assets/ddl/SYDDL.ddl.sql | DWD_ACCT_INSUR/HIS/INSUR_BAL 临时表同步 |
| data_assets/ddl/ods/temp/tmp_dws_cust_asse_liab_insur_bal.sql | 新增 PERSN_LEGAL_BK_CODE/OPRT_ORG 列 |
| data_assets/stored_procedure/ods_to_dwd/PRC_DWD_ACCT_INSUR.sql | v2.0.0：保单级聚合 + MERGE + 状态/终止/余额规则 |
| data_assets/stored_procedure/dwd_to_dws/PRC_DWS_CUST_ASSE_LIAB_CUMU.sql | v3.0.0：直读主档、POLICY_STATE 过滤、删 2.3-2.10、临时表 13→5 |
| docs/changes/2026-08-03-dwd-acct-insur-premium-refactor.md | 本变更文档 |

## 四、DWS v3.0 流程

```
2.1  清理当日结果（临时表仅保留 5 个）
2.2  保险当日余额：SELECT CUST_ID, ACCT_ID, PRDKT_ID, PRDKT_CATE_BIG, SUM(INSUR_AMT),
                    MAX(PERSN_LEGAL_BK_CODE), MAX(MKT_ORG)
      FROM DWD_ACCT_INSUR WHERE POLICY_STATE='1' GROUP BY ...
2.11 四类产品当日余额合并（保险分支直取 INSUR_BAL，不再 JOIN DWD_ACCT_INSUR，消除放大风险）
2.12-2.16 聚合/补零/历史累计/落库（保留）
```

删除：2.3 保单基础、2.4 最后状态、2.5 应缴计划、2.6 缴费交易、2.7 计划匹配、2.8 当前应缴期、
2.9 最近缴费、2.10 余额规则；废弃临时表：INSUR_TX/POLICY_BASE/LAST_STATUS/PAY_PLAN/PAY_TX/
PLAN_MATCH/CURR_PERIOD/LAST_PAID（DDL 保留作归档）。

## 五、INSUR_AMT 清零规则（DWD 加工时计算）

| 场景 | INSUR_AMT |
|---|---|
| POLICY_STATE=0（未生效）/ =2（失效） | 0 |
| 趸缴且加工日 >= TX_DATE + 12 个月 | 0 |
| 期缴缴满（加工日 >= 首期 + 应缴期数 × 期间） | 0 |
| 期缴且加工日 > 下一期应缴日 + 60 天（未缴） | 0 |
| 其余 | NEW_INSUR_AMT + 续期保费累计 |

## 六、数据校验规则（待固化为测试脚本）

1. `POLICY_STATE IN ('0','1','2')` 值域校验（非值域拦截）。
2. `INSUR_AMT >= 0` 且终止保单（POLICY_STATE='2'）INSUR_AMT=0。
3. `ACTL_TERM_DATE` 非空时 POLICY_STATE='2' 一致性校验。
4. `TX_DATE <= LAST_TX_DATE`；`ACTL_TERM_DATE >= TX_DATE`。
5. 改版前后同一数据日期保险余额差异对账。
6. 行数校验：MERGE 后保单数 = 源保单主档数（无丢失）。

## 七、风险与上线注意

1. ODS 交易日期字段名（a.TX_DATE）与格式需上线前核对（代码已注释标注）。
2. DWD 主档化后首次上线需全量初始化（源保单聚合），后续日批为增量 UPSERT。
3. HIS 表停更（DWS 不再依赖），生产 HIS 加载链路建议停用或保留归档。
4. 同客户/账户/产品多保单机构不一致时，DWS 取组内 MAX（已注释，需业务口径确认）。
5. 指标 0061 与 ADS_CRM_R_CUST_LABLE.INSUR_FRST_PREM_AMT 可由 NEW_INSUR_AMT 提供，后续 ADS 侧实现。

## 八、复查修复记录（2026-08-03 二轮代码复查）

### 8.1 已修复

| 编号 | 修复内容 | 位置 |
|---|---|---|
| P1-1 | MERGE WHEN MATCHED UPDATE 补充 TX_ORG/TX_CHNL/MKT_ORG 更新（机构变更可刷新） | PRC_DWD_ACCT_INSUR.sql |
| P2-2 | 期缴缴满/宽限期规则按 PAY_PERIOD_TYP 分 12/1/2 计算（按日改天数）；0/-1 期间类型不触发该分支 | PRC_DWD_ACCT_INSUR.sql INSUR_AMT |
| P2-3 | CONT_STATUS 非 0/1/2 或 NULL 时 INSUR_AMT 兜底 0 | PRC_DWD_ACCT_INSUR.sql INSUR_AMT |
| P2-4 | ACTL_TERM_DATE 回退排除 '9999-12-31'（终生保单终止时回退置空） | PRC_DWD_ACCT_INSUR.sql ACTL_TERM_DATE |
| P2-7 | 删除未使用变量 V_SQL（DWD）、V_SYSDAT2（DWS） | 两个存储过程 |
| P3-10 | Excel v2 更新脚本变更登记幂等（已有 2026-08-03 记录则跳过） | scripts/apply_dwd_insur_excel_v2_update.py |
| P3-11 | 删除 v1.1.0 旧版 Excel 更新脚本（避免误用） | scripts/apply_dwd_insur_excel_update.py（已删） |

### 8.2 未修复项及原因

| 编号 | 事项 | 原因 |
|---|---|---|
| P2-5 | 无交易保单不入主档（INNER JOIN 交易表） | 修复需 ODS 保单主档客户号字段（现 CUST_ID 取交易流水 b.user_id），仓库内无证据，待 ODS 字段核对后实施 |
| P2-6 | CREATE INDEX IF NOT EXISTS 兼容性 | 需目标 Kingbase 库编译验证 |
| P2-8 | HIS tx_date varchar(10) 与当前表 varchar(8) 不一致 | 归档表既有差异，列入后续治理 |
| P3-9 | DWS 段号/日志编号跳号（2.2→2.11） | 日志编号，不影响功能，保持现状 |
| P3-12 | 状态规则测试矩阵未自动化 | 上线前补齐 |

## 九、新增/更新逻辑分段实现（v2.2.0，单存储过程内分段落）

### 9.1 设计目标

在**单个存储过程 PRC_DWD_ACCT_INSUR 内**分段执行新增与更新（不拆分存储过程）：

| 段落 | 操作 | 触发条件 |
|---|---|---|
| 2.1 | 生成保单聚合快照 | 一次计算写入 TMP_DWD_ACCT_INSUR_SNAP |
| 2.2 | 新增 | 快照保单主键 (CUST_ID, ACCT_ID, PRDKT_ID, INSUR_BID_FORM_NO) 在 DWD_ACCT_INSUR 中**不存在**（NOT EXISTS） |
| 2.3 | 更新 | 主键**已存在**（MERGE 仅 WHEN MATCHED，刷新全部可变属性） |
| 2.4 | 统一提交 | 新增+更新同一事务，失败整体回滚 |

### 9.2 实现方式

1. **快照一次计算**：段落 2.1 将保单聚合结果写入 TMP_DWD_ACCT_INSUR_SNAP（26 列、四键主键），2.2/2.3 复用，避免重复聚合 ODS。
2. **批量操作**：INSERT ... SELECT（NOT EXISTS 走目标表主键索引）；MERGE 批量更新（ON 走主键索引）。
3. **参数验证**：过程入口校验 V_SYSDAT（非空、8 位 YYYYMMDD），不合法直接返回 -1。
4. **错误处理**：异常统一在过程异常区捕获，ROLLBACK 整体回滚新增+更新，保证原子性并记录日志。
5. **事务边界**：快照落临时表后 COMMIT；2.2 新增与 2.3 更新在 2.4 统一 COMMIT。
6. **索引优化**：目标表主键四键 + POLICY_STATE + CUST_ID 索引；快照表主键四键。
7. **行数反馈**：2.2/2.3 分别记录新增/更新行数（V_CNT_INS/V_CNT_UPD）写入日志。

### 9.3 涉及文件

| 文件 | 内容 |
|---|---|
| data_assets/stored_procedure/ods_to_dwd/PRC_DWD_ACCT_INSUR.sql | v2.2.0 单过程分段（参数验证 + 快照 + 2.2新增 + 2.3更新 + 统一事务） |
| data_assets/ddl/ods/temp/tmp_dwd_acct_insur_snap.sql | 快照临时表 DDL |
| data_assets/ddl/SYDDL.ddl.sql | 快照表段同步 |

### 9.4 性能与维护说明

- 快照一次计算 + 集合操作，与单条 MERGE 性能等价；单过程内段落边界清晰（触发条件/行数/日志），字段与参数注释完整，便于维护与扩展。
- 独立过程版本（v2.1.0 INS/UPD）已按评审要求合并回单过程并删除对应文件。
- 上线前需在目标库验证：REGEXP_LIKE、MERGE 仅 WHEN MATCHED 分支、快照表主键索引。
