# 到期承接模块全面复核报告

> 实施状态（2026-08-01）：经七批共 33 条业务口径确认后，DTL/STATIS 已完成代码对齐（过程版本 v2.8.0），本报告问题清单中 P0/P1 项均已按确认口径修复或明确，详见 docs/changes/2026-08-01-deadline-rmnd-rules-implementation.md。

## 报告信息

- 复核日期：2026-08-01
- 复核对象：到期承接模块（重点经营视图-到期承接 + 移动端客户360-到期承接）
- 代码版本：master @ bbf0457（含 2026-08-01 日期参数标准化）
- 复核范围：
  - 原始需求：`requirements/05_经营管理.md`（重点经营视图-到期承接）、`requirements/08_移动端客户.md`（到期承接、到期承接推荐的产品）
  - 业务规则基线：`requirements/到期承接规则记忆卡片.md`
  - 实现：`data_assets/stored_procedure/dws_to_ads/PRC_ADS_CUST_DEADLINE_RMND_DTL.sql`（845 行）、`PRC_ADS_CUST_DEADLINE_RMND_STATIS.sql`（275 行）、`PRC_ADS_CUST_PRDKT_RCMD.sql`（产品推荐）
  - 结构：`data_assets/ddl/ads/ads_cust_deadline_rmnd_dtl.sql`、`ads_cust_deadline_rmnd_statis.sql`、`data_assets/mapping/dws_to_ads/dws到ads映射.md`
- 方法：源码静态比对，未连接数据库；确认项=结构与口径可直接判定，风险项=依赖数据分布或需求未决。

## 一、结论摘要

到期承接模块**整体框架与需求基本一致**（周期 M/Q/Y、30天窗口、全部/定期存款页签、机构/管户经理双维度、三年历史保留、DATA_DATE=周期结束日等均有落地），但存在 **1 个高风险金额放大缺陷、2 个中高风险口径错误、1 个结构性编译风险（统计表 DDL 缺列）**，以及若干文档滞后与治理缺口。**不建议在当前状态直接上线**，需按第四节修复并回放验证。

## 二、与原始需求的符合性核对

| 需求点（原始文档） | 实现 | 结论 |
|---|---|---|
| 周期：月/季/年三切片，1月～当月等区间（05 L339） | TMP_CDR_DTL_PERIOD 生成当前+上一 M/Q/Y 六周期；历史保留3年 | ✓ 符合 |
| 产品范围：定期存款（核心+智能）、理财（05 L341） | MATURE_SRC 仅取 DWD_ACCT_DEPO(FIX_CURNT_FLG='1') 与 DWD_ACCT_FIN(剔除开放理财) | ✓ 符合 |
| 已到期=本月1号起截至T-1日（05 L349/L353） | EXPR_AMT 用 EXPR_DT <= V_SYSDAT（跑批日） | ✗ 口径不一致：v2.7.0 已改 V_SYSDAT，但原始需求未同步（记忆卡片已同步为 V_SYSDAT） |
| 到期窗口：下一笔到期日减1 / 最后一笔+30（05 L359） | TAKE_END_DT_30D 按该规则实现 | ✓ 符合，但窗口基准"当期口径 A vs 当月口径 B"仍在代码注释【待确认】（记忆卡片同步标注） |
| 客户承接率：购买长期化≥80% 客户数/已到期客户数（05 L357-363） | CUST_UNDTAKE_RATE 按承接客户数/已到期客户数；UNDTAKE_STATE=TAKE_AMT/EXPR_AMT>=0.8 | △ 部分符合：80% 分母用已到期金额(EXPR_AMT)而非"客户本月到期资金"，口径待确认 |
| 长期化产品剔除开放式理财/活期/通知存款/保险（05 L361/L373） | TAKE_AMT_30D 仅统计 DEPO/FIN 且购买源剔除相关类型 | ✗ 购买源开放式理财过滤使用文字值'开放式理财'，与域定义编码('1','3')不符（见问题3） |
| 资产留存率=当前AUM/第一笔到期前一日AUM（05 L367） | ASSET_KEEP_RATE = SUM(CURR_AUM_BAL)/SUM(FRST_MATURE_PK_BF_DAY_AUM_BAL) | ✗ 分子机构级、分母客户法人行级，口径不一致（见问题5） |
| 资产承接率=Σ购买长期化/已到期金额（05 L369-375） | ASSET_UNDTAKE_RATE = Σ(EXPR_AMT×TAKE_RATE)/Σ(EXPR_AMT) | △ 公式正确，但受问题1/3影响；且 DTL 端已 ROUND，舍入误差未完全消除（v2.5.0 声称已消除） |
| 保险转化率：按最后一笔到期日+30天（05 L379） | BUY_INSUR_AMT_30D 使用 TAKE_END_DT_30D（下一笔-1规则） | ✗ 窗口口径不符（见问题6） |
| 理财转存款/存款转理财：按最后一笔+30天（05 L383/L401） | CROSS_CONV 使用同一 TAKE 窗口 | ✗ 窗口口径不符；且 CROSS_CONV 关联缺 STATIS_TYP（见问题7） |
| 定期存款承接率：不含通知存款（05 L393） | 到期源/购买源均过滤 PRDKT_CATE_BIG<>'04' | ✓ 符合（已实现，待确认项关闭） |
| 移动端：按存款/理财分组展示到期产品+推荐（最多3个）（08 L1224/L1260-1264） | DTL 无产品级明细；PRDKT_RCMD 仅对理财取数（dwd_acct_fin），未引用 DTL，未覆盖存款到期推荐 | ✗ 功能缺失/接口断层（见问题9） |
| 移动端：承接率=符合规则/已到期总金额（08 L1240） | 同客户承接率口径 | △ 与经营管理口径存在文字差异，需统一 |
| 展示：已到期/总到期 25/50 占比、较上月（05 L343） | EXPR_CUST_CNT/TTL_EXPR_CUST_CNT/EXPR_AMT/TTL_EXPR_AMT + 保留上期行 | ✓ 具备数据支撑 |
| 权限：机构辖下/本人管户（05 L409） | STATIS_OBJ（机构展开+POST_ID）+ 明细 POST_ID | ✓ 具备 |
| 统计粒度：客户号+归属机构/法人机构（v2.2.0） | 到期窗口/统计按 CUST+PERSN_LEGAL_BK_CODE+ORG_ID 分组 | ✗ 多处 DWS 关联/购买关联未按 ORG_ID 约束（见问题4/5），粒度规则未完全落实 |

## 三、确认的问题

### 高优先级

1. **到期产品源 JOIN DWS_CUST_ASSE_LIAB 缺少 BAL_TYPE 与 ORG_ID 过滤（金额放大/机构错配）**
   - DTL L236-242（存款）、L261-266（理财）：`INNER JOIN DWS_CUST_ASSE_LIAB CA ON CUST_ID+法人行`，仅带 `CA.DATA_DATE=V_SYSDAT`，未加 `CA.BAL_TYPE='1'`，也未约束 `CA.ORG_ID` 与账户机构一致。
   - DWS_CUST_ASSE_LIAB 同一客户/日期/机构存在 BAL_TYPE 1~4 多行（同库其他模块均按 BAL_TYPE 过滤），该 JOIN 会导致每笔到期账户与多行 CA 关联，`SUM(d.BAL)` 被放大（最多 4 倍）；客户多机构时还会把账户到期归属到非账户机构。
   - 影响：EXPR_AMT、MATURE_TTL_AMT、已到期客户数/金额、承接率、转化率全部失真。

2. **统计表 ADS_CUST_DEADLINE_RMND_STATIS 过程与 DDL/映射列不一致（编译/运行风险）**
   - 过程 v2.5.0 插入 18 列（新增 FIX_DEPO_EXPR_AMT、FIX_DEPO_TTL_EXPR_AMT、FIX_DEPO_UNDTAKE_RATE），DDL 与映射仍为 15 列。
   - 按现有 DDL 建表，过程 INSERT 将报列数不匹配；数据库对象若已有 18 列，则 DDL/映射滞后。无论哪种情况，仓库内结构不一致。

3. **购买源开放式理财过滤使用文字值（承接金额虚高）**
   - DTL L420：`NVL(f.PRDKT_CATE_BIG,'#') <> '开放式理财'`；而理财规则记忆卡片定义 PRDKT_CATE_BIG 为编码 '1'~'4'（1/3=开放式），到期源也按 `NOT IN ('1','3')` 过滤。
   - 若字段为编码值，则该条件永真，开放式理财购买被计入 TAKE_AMT_30D/BUY_FIN_AMT_30D → 资产承接率、客户承接率、存款转理财转化率虚高。

### 中优先级

4. **承接金额关联缺少 ORG_ID（跨机构重复/错配）**
   - DTL L491-495：PURCHASE_SRC 与 DUE_WIN 关联仅 CUST_ID+法人行+购买日期窗口，未含 ORG_ID；购买产品源的机构字段来源不一（DEPO=OPEN_ACCT_ORG、FIN=OPRT_ORG、INSUR=MKT_ORG）。
   - 违反 v2.2.0"按客户+机构维度分组"规则；同一客户多机构时购买金额会归属到每个机构行。

5. **第一笔到期前一日 AUM 关联缺少 ORG_ID（资产留存率口径错误）**
   - DTL L659-663：DWS_CUST_ASSE_LIAB 关联仅 CUST_ID+法人行+DATA_DATE+BAL_TYPE，未含 ORG_ID；而 STATIS 的当前 AUM 是按客户+法人+机构取数。
   - 资产留存率=机构级当前 AUM / 客户法人级到期前一日 AUM，分子分母粒度不一致。

6. **保险转化率与跨类型转化率窗口口径不符**
   - 需求（05 L379/L383/L401）明确"按最后一笔到期日后30天（含）"；代码对 BUY_INSUR_AMT_30D、CROSS_CONV 使用 TAKE_END_DT_30D（下一笔到期日减1规则）。仅客户/资产承接率应使用下一笔-1规则。

7. **CROSS_CONV 关联缺 STATIS_TYP（类型行污染）**
   - DTL L778-782：cv 仅按 STAT_PERD+CUST_ID+法人行+ORG_ID 关联，未含 STATIS_TYP；同一客户的"理财转定期/定期转理财"金额被复制到 0/1/2 三种类型行。
   - 统计层 DEPO_TO_FIN/FIN_TO_DEPO/INSUR 转化率在各 STATIS_TYP 行都会被计算，导致存款行/全部行出现理财转化金额、分母混用。

8. **承接率/承接状态分母口径待确认**
   - TAKE_RATE、UNDTAKE_STATE 分母为 EXPR_AMT（已到期金额）；需求表述为"客户本月到期资金"，若指 MATURE_TTL_AMT（总到期金额），则窗口期未到期部分会导致承接率虚高。需业务确认。

### 低优先级 / 文档与治理

9. **产品推荐功能覆盖不全、与明细模块断层**
   - PRC_ADS_CUST_PRDKT_RCMD 仅基于 DWD_ACCT_FIN（理财）做"即将到期"推荐，未覆盖定期存款到期推荐（需求要求定期到期推荐1定期+2理财），未引用 ADS_CUST_DEADLINE_RMND_DTL，两模块到期口径独立。
   - DTL 无产品级到期明细（按客户+类型聚合），移动端"按存款/理财分组展示到期产品"缺少仓库内数据源。

10. **CUST_BASE 别名误导与余额粒度**
    - DTL L584：`C.PERSN_LEGAL_BK_CODE AS ORG_ID`，值正确但别名误导；v2.6.0 已改名列，此处未同步。
    - CUST_BASE 余额按客户+法人行聚合（无 ORG_ID），明细行按机构展开时余额重复显示，与 STATIS 机构级当前 AUM 口径不一致。

11. **接触状态口径未定义**
    - CNTCT_STATE=存在 MKT_TIME<=V_PREV_DAY 的任意营销记录，无时间下限、无营销类型过滤；映射文档写"不晚于跑批日"与代码 V_PREV_DAY 不一致。需求仅要求可按"接触状态"筛选，未定义口径。

12. **到期窗口基准（当期 A vs 当月 B）仍待业务确认**
    - 代码注释 L333-335 明确标注二选一待确认，记忆卡片同步标注；当前实现为 A（当期口径）。

13. **资产承接率舍入误差残留**
    - v2.5.0 声称消除，但 DTL TAKE_RATE 仍 ROUND(...,2)，STATIS 基于该值加权，仍存在二次舍入。

14. **映射/文档滞后**
    - dws到ads映射.md：STATIS 缺 3 列（与 DDL 一致但与过程不一致）；CNTCT_STATE 映射写"跑批日"；ORG_ID 映射写来源于 CUST_BASE（实际取 DUE_WIN.ORG_ID）。

15. **中间表无 DDL/治理记录**
    - TMP_CDR_DTL_*（8张）、TMP_CDR_STAT_*（2张）在仓库无 DDL 文件，governance/tmp_tables 审核清单未覆盖；结构与字段变更无版本化证据。

## 四、异常处理与可观测性

- 两个过程均有 `EXCEPTION WHEN OTHERS → OUTCDE=-1 → ROLLBACK → SYS_PRC_STEP_LOGS → RAISE`，且每段 COMMIT 支持断点续跑，符合仓库既有模式 ✓。
- 不足：无任务状态/幂等锁，重跑依赖"先删后插"；中间表 TRUNCATE 后若中途失败，需人工重跑整过程（可接受，但建议记录每段影响行数）。

## 五、修复建议（按优先级）

| 优先级 | 修复项 | 动作 |
|---|---|---|
| P0 | 问题1 | MATURE_SRC 关联 DWS 增加 `CA.BAL_TYPE='1'`，并按账户机构约束 `CA.ORG_ID`（或改为直接从账户表取机构，与 v2.2.0 注释一致） |
| P0 | 问题2 | 同步 STATIS DDL/映射补齐 FIX_DEPO_* 三列，或回退过程至 15 列（以业务确认为准） |
| P0 | 问题3 | 购买源开放式理财过滤改为 `PRDKT_CATE_BIG NOT IN ('1','3')`（与域定义及到期源一致） |
| P1 | 问题4/5 | TAKE_AMT、AUM_PREV 关联补齐 ORG_ID 三键 |
| P1 | 问题6/7 | 保险/跨类型转化率窗口改"最后一笔+30天"独立计算；CROSS_CONV 增加 STATIS_TYP 维度 |
| P1 | 问题8 | 与业务确认承接率分母（已到期 vs 总到期），并同步需求文档 |
| P2 | 问题9 | 确认推荐模块产品范围与数据源；如需要，在 DTL 增加产品级明细或由推荐模块直接覆盖存款 |
| P2 | 问题10-15 | 修正别名/映射/接触口径、登记中间表 DDL 与审核清单、同步原始需求文档（T-1→V_SYSDAT、窗口基准、分母口径） |

## 六、验证要求

- 静态：修复后重跑 `validate_cross_layer_consistency.py`、`validate_procedure_date_parameters.py`、SQL 语法检查。
- 动态：在 Kingbase Oracle 兼容模式编译两过程；用构造样例核对：单客户4类BAL_TYPE行场景的到期金额（应等于账户余额非4倍）、跨机构客户承接归属、开放理财购买不计入承接、保险转化率窗口边界。
- 需求同步：将 T-1→V_SYSDAT、窗口基准A/B、承接率分母的最终口径回写 05/08 需求文档与记忆卡片。
