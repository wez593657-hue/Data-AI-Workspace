# 指标任务详情与指标统计过程改造设计

## 目标

以 `DWD_MKT_TSK_INDX_SUB` 作为目标任务路径的指标清单和任务周期权威来源，
同步 Excel、Markdown、DDL 与 `PRC_ADS_STAT_INDX_DATA`，并修复已确认的
编译、机构汇总和字段口径问题。

## 数据模型

新增 DWD 表 `DWD_MKT_TSK_INDX_SUB`，字段以
`DWD明细层数据模型_CRM_ V1.0.xlsx` 为准：

`TSK_INDX_ID`、`TSK_ID`、`MAIN_TSK_ID`、`INDX_ID`、`TSK_DSC`、
`TSK_BGN_DATE`、`TSK_END_DATE`、`INDX_UNIT`、`INDX_VAL`、
`INDX_VAL_ADD`、`BASE_VAL`、`PERSN_LEGAL_BK_CODE`。

同步产物：

- `data_assets/mapping/ods_to_dwd/ods到dwd映射.md`
- `data_assets/ddl/dwd/dwd_mkt_tsk_indx_sub.sql`

DDL 使用 Excel 中的字段类型、长度和中文注释；不新增 Excel 未定义的字段、默认值或序列。

## 路径 B

路径 B 以 `DWD_MKT_INDX_TSK` 提供任务接收对象，以
`DWD_MKT_TSK_INDX_SUB` 提供指标明细。两表按 `TSK_ID` 和
`PERSN_LEGAL_BK_CODE` 关联。

- `sub.INDX_ID` 写入 `TMP_STAT_INDX_TSK_SRC.INDX_CODE`，只计算任务明确配置的指标。
- `sub.TSK_BGN_DATE`、`sub.TSK_END_DATE` 决定统计有效期，替代旧过程引用的不存在字段。
- `INDX_0047` 的权威基数来源已调整为 `DEPO_VALUE_INIT(ORG_ID, PERSN_LEGAL_BK_CODE, MNGR_POST_ID, VALUE_INIT)`；机构行如何汇总经理基数尚待确认，因此本次指标配置过滤改造不改变现有基数计算实现。
- `TMP_STAT_INDX_TSK_SRC` 主键调整为包含 `INDX_CODE`，支持一个任务配置多个指标。
- 余额基表继续按去重的“归属 + 统计维度 + 客户 + 法人行号”缓存多期余额，不将 `INDX_CODE` 扩散到余额事实记录；步骤 6 对每个指标通过完整键 `EXISTS` 回关联活动/任务指标客户表，作为最终产出开关。
- 该半连接条件统一包含统计维度、指标编号、归属、客户编号和法人行号。`0061`、`0067` 直接在客户来源子查询按指标编号过滤，语义等价且不叠加冗余 `EXISTS`。

## 过程修复

- 修复过程末尾为 `END;`。
- 路径 A 客户基表使用明确的内部关联、`DISTINCT` 和 `DATA_DATE = V_SYSDAT` 快照过滤。
- 基数查询同样按 `DWD_MKT_TSK_INFO.DATA_DATE = V_SYSDAT` 过滤。
- 步骤 2/3 仅生成直接机构归属和客户经理归属。步骤 6 只在直接归属上计算指标；步骤 7 再将机构结果按 `DWD_SYS_ORG.SUP_ORG_ID` 递归至全部祖先机构并汇总。客户经理行不递归。
- 递归链以访问路径防环，并保留最大 20 层保护。该方式可完整汇总不等深机构树中已存在直接机构和更深下级机构的共同贡献。
- 最终 A/B 合并显式列出列名，不使用 `SELECT *`。
- `INDX_0063` 按五段临界区间判定：`[45000,50000)`、`[270000,300000)`、`[450000,500000)`、`[900000,1000000)`、`[2700000,3000000)`。

## 持久化上期基准

新增持久化客户明细基准表 `ADS_STAT_INDX_BASELINE_DTL`，冻结活动/任务启动前的客户范围及上期值，避免源表历史快照清理、回补或重算导致活动期间净增口径漂移。

表的业务主键为：

```text
STATIS_CALIB + STATIS_DIM + INDX_CODE + DATA_BLNG + CUST_ID + PERSN_LEGAL_BK_CODE
```

建议字段如下：

| 字段 | 类型 | 说明 |
|------|------|------|
| STATIS_CALIB | VARCHAR(100) | 统计口径：营销活动/目标任务 |
| STATIS_DIM | VARCHAR(100) | 活动编号/任务编号 |
| INDX_CODE | VARCHAR(100) | 指标编码 |
| DATA_BLNG | VARCHAR(100) | 直接机构或客户经理归属 |
| CUST_ID | VARCHAR(20) | 客户编号 |
| PERSN_LEGAL_BK_CODE | VARCHAR(30) | 法人行号 |
| BASE_DATA_DATE | VARCHAR(8) | 基准业务日期，固定为活动/任务开始日前一天 |
| BASE_RUN_DATE | VARCHAR(8) | 实际生成或补建基准值的跑批日期 |
| BASE_CUST_LVL | VARCHAR(2) | 客户等级基准值，供0052~0054使用 |
| BASE_LOAN_BAL | NUMBER(20,2) | 贷款余额基准值，供0062使用 |
| BASE_MTH_AVG_AUM | NUMBER(20,2) | 月日均AUM基准值，供0063使用 |
| BASE_YR_AVG_FIN | NUMBER(20,2) | 年日均理财基准值，供0055使用 |
| BASE_MTH_AVG_FIN | NUMBER(20,2) | 月日均理财基准值，供0056使用 |
| BASE_YR_AVG_AGEN_FIN | NUMBER(20,2) | 年日均代销理财基准值，供0058使用 |
| BASE_MTH_AVG_AGEN_FIN | NUMBER(20,2) | 月日均代销理财基准值，供0059使用 |

处理规则：

1. 跑批日为活动/任务开始日前一天时，按客户明细业务主键生成基准记录，`BASE_DATA_DATE` 与 `BASE_RUN_DATE` 均为该跑批日。
2. 活动/任务期间发现基准记录缺失时允许补建，但 `BASE_DATA_DATE` 仍固定为开始日前一天，`BASE_RUN_DATE` 记录实际补建跑批日。
3. 补建必须仍从 `BASE_DATA_DATE` 的历史快照读取基准值；历史快照不存在时不得使用当前值替代，必须记录异常并跳过该明细。
4. 已存在的业务主键不得更新或覆盖，保证基准值和客户归属冻结。
5. `INDX_0052`、`INDX_0053`、`INDX_0054`、`INDX_0055`、`INDX_0056`、`INDX_0058`、`INDX_0059`、`INDX_0062`、`INDX_0063` 改为读取该基准表；其余指标保持当前年初、月末、季末、年末或业务基数口径。
6. 基准生成使用步骤7前的直接机构/客户经理归属；机构递归仍在指标聚合完成后执行，避免基准在祖先机构维度重复存储。

前置条件与风险：活动/任务开始日前一天必须能从源表取得次日生效的配置、客户范围和归属。若该类数据直到开始日才落库，前置生成会延后为活动期补建；此时只有开始日前一天的历史快照仍可查询，补建结果才具备正确性。

## 暂不产出指标

以下指标缺少正确计算所需的权威字段，本次不产出，避免生成口径错误的数据：

- `INDX_0066`：需要贷款在考核期初和期末的风险分类历史，以识别“期初正常或关注、期末不良”的新形成不良余额。
- `INDX_0070`：需要三方支付平台类型的明确值域，才能按卡号和平台判断首次绑定。
- `INDX_0071`：需要本年新增持卡和年龄的权威字段及关联规则。
- `INDX_0072`：需要根卡关系和有效卡状态，才能统计有效卡片而非客户数。

## 事务与验证

本次不扩大为临时表架构重构，步骤 7 作为机构结果的最终递归汇总阶段。提交前执行：

- Excel、Markdown、DDL 的字段名、类型、长度、注释一致性校验。
- SQL 静态字段引用检查，确保不存在 `DWD_MKT_INDX_TSK.INDX_CODE` 和 `STATIS_STOP_DATE`。
- 过程文本语法和 `END;` 校验。
- 路径 B 多指标任务、五段临界区间、机构不等深层级、空明细任务的离线样例检查。
- 基准表首次生成、重复跑批幂等、活动期缺失补建、历史快照缺失跳过、源表客户归属变更后仍按冻结基准计算的离线样例检查。

不连接数据库；不以静态检查替代 Kingbase 编译、执行计划或真实业务样本验证。
