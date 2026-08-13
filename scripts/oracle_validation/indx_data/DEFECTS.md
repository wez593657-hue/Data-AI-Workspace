# PRC_ADS_STAT_INDX_DATA Oracle 测试缺陷台账

| 缺陷编号 | 状态 | 具体位置 | 影响范围 | 复现证据 | 建议解决方案 | 处理决策 |
|---|---|---|---|---|---|---|
| DEFECT-2026-08-12-001 | 已关闭 | `scripts/oracle_validation/indx_data/oracle_PRC_ADS_STAT_INDX_DATA.sql` 部署链路 | Oracle 本地过程编译、全部指标集成验证 | 初始调用返回 `PLS-00201`；后续用户确认 `SCOTT.PRC_ADS_STAT_INDX_DATA` 已编译，实测 `USER_OBJECTS.STATUS=VALID` | 使用库内已编译有效过程执行全矩阵；测试转换副本不再作为本轮部署依据 | 已由用户处理 |

| DEFECT-2026-08-12-002 | 已确认，待修复 | 过程步骤2范围提取 | `ADS_STAT_INDX_RULE.IS_ENABLED='0'` 的指标仍进入发布结果 | 真实结构测试中停用 `INDX_0080` 后，`09_run_and_assert_real_schema.sql` 报 `ORA-20904: disabled indicator published` | 在活动目标和任务子指标范围提取阶段联动规则表，至少过滤 `IS_ENABLED='1'` 及生效日期；随后补停用规则回归 | 阻塞规则停用语义 |
| DEFECT-2026-08-12-003 | 已确认，待修复 | 过程步骤7 `org_tree/org_rolled_up` | 完整四层机构树只生成原子机构结果，未向 `SB/BR/ORG` 上卷 | `DWD_SYS_ORG` 20 行、最大深度4；`ACT001/INDX_0055` 仅有 `MGR_MGR001`、`ORG_ORG001` 2 行，期望至少覆盖网点、支行、分行、总行；父子关系真实存在 | `org_tree` 使用 `SYS_CONNECT_BY_PATH(org_id,'/')` 生成祖先路径，或使用 `CONNECT_BY_ROOT`/层级闭包表明确关联祖先；禁止用机构ID字符串包含关系代替层级关系 | 阻塞机构递归汇总 |
| DEFECT-2026-08-12-004 | 已确认，待修复 | 公共 `SYS_FUN_DEAL_DATE` 与过程日期契约 | 正式函数无参数28，但过程调用参数28计算次日 | SCOTT 当前函数调用 `SYS_FUN_DEAL_DATE('20260809',28)` 返回 `NULL`，导致首次期初冻结范围为空；测试专用函数补充28后基准成功生成 | 按项目日期函数标准补充并发布参数28，或修改过程使用已有参数语义；完成函数单测和过程期初冻结回归后再上线 | 阻塞期初冻结正确性 |
