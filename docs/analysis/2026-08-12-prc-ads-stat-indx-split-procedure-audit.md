# PRC_ADS_STAT_INDX_DATA 拆分过程审核报告

审核日期：2026-08-12  
审核对象：`data_assets/stored_procedure/dws_to_ads/prc_ads_stat_indx_data/` 下 10 个过程  
审核方法：需求记忆卡片、目标和临时表 DDL、拆分过程静态 SQL 审查、原单体过程及已有 Oracle 验证资料交叉比对。

## 结论

当前拆分链路**不具备上线条件**。已确认 2 项 P0 缺陷：目标任务机构范围未递归覆盖下级机构客户；入口过程每步调用日志过程时被日志内部 `COMMIT` 打断事务和锁保护。另有 6 项 P1 功能或可运维性问题，包含储蓄存款口径错误、手机银行年度口径错误、`TERM_LAST_VAL` 固定写零、机构上卷输出可能重复、子过程独立调用不符合模板及拆分链路未纳入回归。

本报告中的“已确认”是基于代码与已确认需求/DDL 的静态证据；“待数据库验证”不能替代 Kingbase 编译、真实执行计划、锁竞争与权限检查结论。

## 范围与数据流

| 顺序 | 过程 | 职责 | 主要读写对象 |
| --- | --- | --- | --- |
| 1 | `prc_ads_stat_indx_build_scope` | 建立 A/B 指标范围 | `TMP_STAT_INDX_SCOPE` |
| 2 | `prc_ads_stat_indx_freeze_baseline` | 开始日前一天冻结客户和金额基准 | 三张 `ADS_STAT_INDX_BASELINE_*`、`TMP_STAT_INDX_SCOPE` |
| 3 | `prc_ads_stat_indx_aum_balance` | 0046-0051 指标预聚合和计算 | `TMP_STAT_INDX_BAL_AGGR`、`TMP_STAT_INDX_AGGR` |
| 4 | `prc_ads_stat_indx_product_baseline` | 0055/0056/0058/0059/0062 基准增量 | `TMP_STAT_INDX_AGGR` |
| 5 | `prc_ads_stat_indx_cust_upgrade` | 0052-0054/0063 客户状态增量 | `TMP_STAT_INDX_CUST_STATE`、`TMP_STAT_INDX_AGGR` |
| 6 | `prc_ads_stat_indx_event_count` | 0061、0067 事件指标 | `TMP_STAT_INDX_AGGR` |
| 7 | `prc_ads_stat_indx_new_cust_rule` | 0080、0082、0083 指标 | `TMP_STAT_INDX_AGGR` |
| 8 | `prc_ads_stat_indx_retention_rate` | 0081 留存率 | `TMP_STAT_INDX_AGGR` |
| 9 | `prc_ads_stat_indx_org_rollup_publish` | 机构递归上卷和发布 | `ADS_STAT_INDX_DATA` |
| 10 | `PRC_ADS_STAT_INDX_PLAN` | 参数校验、编排、日志、异常处理 | 调用上述 9 个过程 |

## 共性问题

| 编号 | 等级 | 状态 | 证据 | 影响与整改建议 |
| --- | --- | --- | --- | --- |
| AUD-001 | P0 | 已确认 | `prc_ads_stat_indx_build_scope.sql:51-68` 仅保存 `RSV_OBJ_ID`；所有 B 路径均以 `lv.org_id = s.blng_id` 直接取客户，例如 `prc_ads_stat_indx_aum_balance.sql:38-40`。需求要求机构任务递归 `SUP_ORG_ID` 覆盖下级机构全部客户。 | 机构任务遗漏下级机构及其客户经理客户，影响冻结、余额、事件、新客、商户全部 B 路径指标。应在范围构建阶段生成“任务机构 -> 后代机构”的闭包，并让所有 B 路径复用统一的客户范围。 |
| AUD-002 | P0 | 已确认 | `PRC_ADS_STAT_INDX_PLAN.sql:44-46、53-56、63-66、72-110` 每步调用 `SYS_PRC_STEP_LOGS`；该日志过程在 `SYS_PRC_STEP_LOGS.sql:45-60` 写日志后 `COMMIT`。 | 首次日志即提交 TMP 清理及此前业务 DML，并释放 `ACCESS EXCLUSIVE` 锁；后续失败无法整体回滚，另一会话可并发清理共享 TMP。应把成功日志缓存至业务提交后统一写入，或改造日志过程不提交调用方事务。 |
| AUD-003 | P1 | 已确认 | 各业务模块将 `TERM_LAST_VAL` 常量写为 `0`，如 `prc_ads_stat_indx_event_count.sql:21-27、47-53`、`prc_ads_stat_indx_new_cust_rule.sql:61-76`。目标字段定义为上期值。 | 下游趋势、环比或前后期比对失真。发布前应从前一业务日同一稳定键读取上期值；不存在历史行时才按明确默认规则置零。 |
| AUD-004 | P1 | 已确认 | `prc_ads_stat_indx_org_rollup_publish.sql:53-55` 以 `UNION ALL` 同时写原子行和上卷行，未按最终业务键再次汇总；目标表 DDL 未声明唯一键。 | 当同一祖先机构既有原子行又有下级上卷行时，可能产生同键多行。应将两类结果 `UNION ALL` 后按最终稳定键 `GROUP BY` 汇总，或在发布前对合并集做重复键强校验。 |
| AUD-005 | P1 | 已确认 | `prc_ads_stat_indx_aum_balance.sql:49-56` 对 0046-0051 均使用 `AUM_BAL`。需求规定储蓄存款为活期、普通定期、乐惠、大额存单和通知存款之和。 | AUM 包含非存款资产，0046-0051 会偏高或偏低。应以 DWS 可确认的五类存款字段表达式替代；当前 DDL 未见通知存款字段，需先确认其字段来源，不能擅自以 AUM 回退。 |
| AUD-006 | P1 | 已确认 | `prc_ads_stat_indx_event_count.sql:7、72-73、99-100` 以当月初至跑批日统计 0067。需求为“当年个人手机银行登录活跃客户数”。 | 月初会丢失当年早期已登录客户。应使用 `V_YAR_BEGIN := sys_fun_deal_date(v_sysdat, 13)` 作为下界，并按 `LGN_DATE` 实际数据类型使用无隐式转换的范围条件。 |
| AUD-007 | P1 | 已确认 | 9 个子过程均为可独立执行的 schema 过程，但均无参数校验、异常处理、事务边界或步骤日志，例如 `prc_ads_stat_indx_product_baseline.sql:1-215`。 | 直接调用子过程可绕过入口锁、清理和错误治理，不符合独立过程模板。应封装为包内私有过程，或为每个公开过程补齐模板控制段并限制只授予入口过程的调度权限。 |
| AUD-008 | P1 | 已确认 | 现有 Oracle 脚本 `scripts/oracle_validation/indx_data/02_convert_proc.ps1:5` 仅转换原单体 `PRC_ADS_STAT_INDX_DATA.sql`。 | 单体回归即使通过，也不能证明 10 个拆分过程可编译、调用顺序正确或事务行为一致。应新增拆分版部署顺序、编译检查和端到端回归脚本。 |
| AUD-009 | P1 | 部分整改 | 已在 `prc_ads_stat_indx_product_baseline.sql` 实现0057、0060：按 `DWD_ACCT_FIN.ISSU_DATE` 和 `CFM_AMT` 统计购买确认金额，0060限定 `PRDKT_CATE_BIG IN ('1','2')`，赎回暂不处理。0064、0065、0066、0068-0079仍无实现。 | 指标覆盖仍不完整。0073-0079已明确本期不处理；其余指标须提供来源和已确认口径后独立开发，禁止写零值伪造完成。0057、0060仍需在Kingbase测试库完成编译和回归。 |
| AUD-010 | P2 | 已确认 | 多过程在多条 DML 后直接返回最后一条 `SQL%ROWCOUNT`；`prc_ads_stat_indx_freeze_baseline.sql:121-142` 最后执行的是 `SELECT COUNT`。 | 日志中的处理行数不代表模块总写入量，冻结模块通常返回 1。应逐条 DML 累加受影响行数，并区分范围、基准、聚合和发布行数。 |
| AUD-011 | P2 | 静态风险 | `prc_ads_stat_indx_event_count.sql:72-73` 拼接登录日期字符串；`prc_ads_stat_indx_retention_rate.sql:25、65` 对 `PAY_TIME` 使用 `SUBSTR`；`prc_ads_stat_indx_new_cust_rule.sql:69-71、136-141` 对日期/账户类型使用函数。 | 可能导致索引失效或因源字段类型、格式不一致而漏数。应以实际 DDL/数据类型确定标准化字段与半开区间条件，并在 Kingbase 执行计划验证。 |
| AUD-012 | P2 | 待数据库验证 | 项目源表 DDL 未定义索引或主键，无法从仓库确认实际索引覆盖范围。 | 必须在 Kingbase 测试库对关键关联和过滤组合执行 `EXPLAIN (ANALYZE, BUFFERS)`，重点检查营销任务、客户余额、机构关系、登录、商户订单及基准表稳定键。 |

## 逐过程审核

### 1. prc_ads_stat_indx_build_scope

- 已确认：A/B 范围均正确使用开始日前一天与开始日连续边界 `TERM_BEGIN_DATE <= V_NEXT_DAY`；未使用独立规则表，符合已确认“规则表删除”要求。
- P0：B 路径机构对象只保留当前机构编号，未生成下级机构范围，见 AUD-001。
- P2：`o_row_cnt` 只返回第二条 B 路径 `INSERT` 的行数（第 70 行），不等于 A+B 范围总行数。
- P2：活动、任务的状态/审批有效性没有依据当前 DDL 明确过滤；是否必须过滤需以营销状态码口径确认，不能猜测补加。
- 安全：无动态 SQL，输入不参与 SQL 拼接，未见 SQL 注入路径。

### 2. prc_ads_stat_indx_freeze_baseline

- 已确认：开始日前一天用参数 28 次日识别，并通过 `NOT EXISTS` 保证既有基准不覆盖，符合冻结稳定性要求。
- P0：B 路径冻结客户范围继承 AUD-001，后续再正确计算也无法补回漏冻结客户。
- P1：基准金额汇总以 `HAVING COUNT(DISTINCT b.cust_id) = COUNT(DISTINCT m.cust_id)` 阻断缺失快照是合理的，但缺失来源客户无法在异常中定位。应记录缺失的稳定键、客户数和样例客户，便于重跑修复。
- P2：第 142 行的 `SQL%ROWCOUNT` 是前一条 `SELECT COUNT` 的行数，而不是三张基准表总写入数，见 AUD-010。
- 规范：作为独立过程缺少参数校验、异常日志，见 AUD-007。

### 3. prc_ads_stat_indx_aum_balance

- P1：0046-0051 计算列使用 `AUM_BAL`，与储蓄存款字段口径冲突，见 AUD-005。
- P0：B 路径机构客户仅直连 `DWS_CUST_LVL_INFO.ORG_ID`，继承 AUD-001。
- 已确认：跑批相对日期均通过 `sys_fun_deal_date` 具名变量获得，未发现直接以 `V_SYSDAT` 推导月季年边界。
- P2：0047 已使用 `SUM(NVL(VALUE_INIT,0))`，不存在“无基数记录导致 SUM 为 NULL”的旧问题；但需要在基数表样例中验证同一机构/经理是否有重复装载行。
- 性能：余额表按客户、法人、日期、余额类型关联；需要验证组合索引和行数基数。

### 4. prc_ads_stat_indx_product_baseline

- P0：B 路径客户基准继承 AUD-001，导致 0055/0056/0058/0059/0062 对下级机构客户漏算。
- 已确认：当前值通过冻结成员表限制，基准通过汇总基准表扣减，符合减少客户 TMP 维度的已确认设计。
- P1：`TERM_LAST_VAL` 为基准值而非前一业务日值，和目标字段定义冲突，见 AUD-003。若该字段业务上确实要表达“期初基准”，必须先变更目标字段定义与下游契约。
- 规范：无独立异常处理与参数校验，见 AUD-007。

### 5. prc_ads_stat_indx_cust_upgrade

- P0：计算源为所有历史 `ADS_STAT_INDX_BASELINE_DTL`，最终由当前 scope 匹配；B 路径仍因 AUD-001 漏客户。
- P1：`TO_NUMBER(NVL(CUST_LVL,'0'))`（第 21-23 行）遇到非数字等级会使整个跑批失败。应先做值域校验并将无效记录输出至数据质量日志，不能以隐式约定承受脏数据。
- 已确认：0063 先保留期初或当期进入临界区间的客户，再计算当前数减基准数，逻辑上可覆盖进出临界区间的正负变动。
- P2：A/B 两段近乎复制，后续整改统一客户范围后应优先合并为一次聚合，以避免规则漂移与两次扫描。

### 6. prc_ads_stat_indx_event_count

- P0：B 路径机构范围继承 AUD-001。
- P1：0067 当前为当月登录人数，需求为当年累计登录活跃客户，见 AUD-006。
- P1：0061 使用 `POLICY_STATE='1'` 过滤；最新保险账户变更记录将其定义为唯一状态来源，而记忆卡片仍写 `CANCL_INSUR_DATE IS NULL`。这是需求文档间冲突，应确认以保单状态还是取消日期为准；在明确前不建议两者叠加。
- P2：`LGN_DATE` 与拼接的 `YYYY-MM-DD` 字符串比较，源类型为 DATE/TIMESTAMP 时将产生隐式转换并损失索引，见 AUD-011。

### 7. prc_ads_stat_indx_new_cust_rule

- P0：B 路径机构范围继承 AUD-001。
- 已确认：0080 的 180 天窗口使用日期函数参数 27；0083 的开户日期先作格式白名单处理，脏值不会抛出日期转换异常。
- P1：0082 不在需求编码清单 0046-0079 中，但在记忆卡片中作为已确认扩展指标存在。应在需求/映射中补充 0082 编码来源和版本记录，保证可追溯。
- P2：日期和 `TRIM(ACCT_TYP)` 函数筛选存在索引利用风险，见 AUD-011；长期方案是入 DWD 时标准化日期和代码值。

### 8. prc_ads_stat_indx_retention_rate

- P0：B 路径机构/经理商户范围继承 AUD-001。
- 已确认：按商户号和结算客户号去重，再以 `CUST_NO = CUST_ID` 汇总年日均 AUM，符合记忆卡片的 0081 已确认口径。
- P2：`SUBSTR(PAY_TIME,1,8)` 会阻断普通索引使用；若字段为字符串，应改为同格式范围比较，若为时间类型，应改为日期范围条件，见 AUD-011。
- P2：分母通过 `NULLIF` 防除零，但结果为 NULL 时是否应保留 NULL 或输出 0 未在需求中定义；需在下游展示契约中确认。

### 9. prc_ads_stat_indx_org_rollup_publish

- 已确认：使用 `CONNECT_BY_ROOT` + `SUP_ORG_ID` 建立祖先-后代闭包，已替代旧的机构编号字符串包含判断。
- P1：原子行和上卷行 `UNION ALL` 后没有按最终业务键汇总，见 AUD-004。
- P1：删除当日 ADS 结果发生在最终插入之前；由于 AUD-002 已存在提前提交，异常时不能保证旧当日结果仍被保留。
- P2：机构层级限制 `LEVEL < 20` 为硬编码上限；应基于机构树最大深度监控或明确作为异常保护阈值并记录命中。
- 安全：无动态 SQL；实际 `DELETE/INSERT/LOCK` 权限及最小授权需在数据库核验。

### 10. PRC_ADS_STAT_INDX_PLAN

- 已确认：入口校验了 8 位日期及非法自然日；日期函数参数 28 已在当前 `sys_fun_deal_date` 实现，历史“参数 28 缺失”问题已修复。
- P0：步骤日志调用触发内部提交，破坏事务、锁和幂等性，见 AUD-002。
- P1：`V_PRC_NAME` 仍写为 `PRC_ADS_STAT_INDX_DATA`，但入口过程名为 `PRC_ADS_STAT_INDX_PLAN`（第 1、6 行）；部署后日志与实际入口不一致。
- P1：步骤 4-7 的成功日志异常均被静默吞掉，无法区分“业务成功但审计失败”。应保留业务原子性，但在任务结果中返回日志失败告警或使用独立可观测告警机制。
- P1：子过程没有统一部署脚本和依赖编译顺序；入口在子过程未编译时会运行失败，见 AUD-008。

## 安全与性能审查结论

- SQL 注入：未发现 `EXECUTE IMMEDIATE`、动态拼接 SQL、DBMS_SQL 或将入参拼入 SQL 文本的代码；当前输入日期仅用于绑定式比较和函数参数，静态审查结论为无注入入口。
- 权限：仓库未提供过程 `GRANT/REVOKE` 或调度账号定义，无法确认最小权限。上线前只应向调度角色授予入口过程 `EXECUTE`，不应向普通调用方授予 9 个子过程执行权限。
- 索引和计划：项目 DDL 未声明关键源表索引或主键，因此不能给出“已命中索引”的结论。必须以 Kingbase 测试库实际索引和 `EXPLAIN (ANALYZE, BUFFERS)` 验证。
- SQL 规范：未发现 `SELECT *` 或动态 SQL。存在多处 `OR` 关联条件和函数包裹筛选字段；前者需在统一范围表整改后减少，后者需按真实字段类型改为可索引条件。

## 验证要求

整改完成后至少执行：

1. 按依赖顺序编译 9 个子过程再编译入口过程，检查无效对象。
2. 构造四层机构树，对 B 路径机构任务验证本机构、下级机构、下级客户经理客户均计入，且不重复。
3. 构造并发会话：会话一运行至任意模块时，会话二启动入口必须按设计拒绝或等待；会话一失败后必须确认 TMP、基准和 ADS 当日结果回滚策略符合设计。
4. 验证 0046-0051 的储蓄存款表达式，包含五类字段和通知存款字段缺失的阻断场景。
5. 验证 0067 年初至跑批日均被统计，月初前登录客户不得遗漏。
6. 验证上卷后的 ADS 结果按稳定键唯一，`TERM_LAST_VAL` 等于前一业务日同键结果。
7. 对大表关联执行 Kingbase `EXPLAIN (ANALYZE, BUFFERS)`，记录实际索引、扫描行数、排序和临时空间。

详细整改状态见 [整改台账](2026-08-12-prc-ads-stat-indx-split-procedure-remediation-tracker.md)。
