# 到期承接过程本地 Oracle 验证缺陷台账

本台账依据 `docs/standards/oracle-local-testing-policy.md` 第 4 节登记。
所有条目初始状态为"待审核"，未经用户确认不得修改任何数据资产文件。

---

## DEFECT-2026-08-01-001：STATIS 过程 SELECT 列表尾随逗号（阻断级）

- **状态**：已关闭（用户确认手动修复，2026-08-01）
- **具体位置**：
  - 文件：`data_assets/stored_procedure/dws_to_ads/PRC_ADS_CUST_DEADLINE_RMND_STATIS.sql`
  - 行：第 2 段（`INSERT INTO TMP_CDR_STAT_BASE`）SELECT 列表最后一项
  - 代码片段：
    ```sql
    NVL(d.FRST_MATURE_PK_BF_DAY_AUM_BAL, 0),
    NVL(a.CURR_AUM_BAL, 0),
    FROM ADS_CUST_DEADLINE_RMND_DTL d
    ```
- **影响范围**：
  - `PRC_ADS_CUST_DEADLINE_RMND_STATIS` 无法编译（Kingbase 与 Oracle 均报语法错误），
    到期承接统计表无法生成。
  - 静态校验（SQL 语法检查、跨层一致性、单元测试）未覆盖该缺陷。
- **复现证据**：
  - Oracle 11g 编译：`ORA-00936: missing expression`（第 117 行）。
  - 转换副本修复后编译运行成功，全部统计口径断言通过。
- **建议解决方案**：
  1. 删除该尾随逗号，使 `NVL(a.CURR_AUM_BAL, 0)` 后直接换行 `FROM`。
  2. 修复后需在 Kingbase Oracle 兼容模式重新编译并回放本验证样例。
  3. 建议将"SELECT 列表尾随逗号"加入静态校验规则。
- **处理决策**：手动处理（用户确认已手动修改源文件删除尾随逗号，2026-08-01）

### 变更状态核查（2026-08-01）

- 核查发现 `data_assets/stored_procedure/dws_to_ads/PRC_ADS_CUST_DEADLINE_RMND_STATIS.sql`
  工作区文件 LastWriteTime=2026-08-01 15:44:23，内容为删除该尾随逗号（与建议修复一致）。
- 同目录存在 `PRC_ADS_CUST_DEADLINE_RMND_STATIS.sql.bak`（2026-08-01 13:50:08，
  14451 字节），内容与 git HEAD 一致（含尾随逗号），即备份先于修改。
- 本次测试的转换脚本经核查仅输出至 `scripts/oracle_validation/deadline_rmnd/`，
  未向 `data_assets/` 写入；Oracle 验证副本（oracle_*.sql）保留修复供回放。
- **来源已确认**：用户于 2026-08-01 确认为本人手动修改，合规事件关闭。
- 缺陷修复已随用户手动修改落地；建议后续在 Kingbase 兼容模式重新编译并回放样例
  作为收尾确认（不在本次处理范围）。

---

## DEFECT-2026-08-01-002：Oracle 11g 标识符超长（平台适配项）

- **状态**：已关闭（不修复，2026-08-01）
- **具体位置**：
  - 过程名：`PRC_ADS_CUST_DEADLINE_RMND_STATIS`（33 字符，Oracle 上限 30）
  - 列名：`FIXED_FIN_MATURE_TRAN_INSUR_AMT`（31 字符）
- **影响范围**：
  - Oracle 11g 下无法创建上述过程与包含该列的表；Kingbase 不受影响。
- **复现证据**：
  - `ORA-00972: identifier is too long`
- **建议解决方案**：
  - Oracle 版改名映射（测试副本已实现）：
    - `PRC_ADS_CUST_DEADLINE_RMND_STATIS` → `PRC_ADS_CUST_DEADLINE_RMND_ST`
    - `FIXED_FIN_MATURE_TRAN_INSUR_AMT` → `FIXED_FIN_TRAN_INSUR_AMT`
  - 若 Oracle 为目标部署平台，需在 DDL/映射/字典文档中同步该改名映射；
    若仅 Kingbase 部署，可关闭本缺陷。
- **处理决策**：不修复（用户确认"其余不做处理"；若未来以 Oracle 为目标部署平台再重新评估）

---

## DEFECT-2026-08-01-003：TAKE_RATE 可超过 100%（口径待确认）

- **状态**：已关闭（不修复，2026-08-01）
- **具体位置**：
  - `data_assets/stored_procedure/dws_to_ads/PRC_ADS_CUST_DEADLINE_RMND_DTL.sql`
    第 9 段目标表写入，`TAKE_RATE = ROUND(NVL(t.TAKE_AMT_30D,0) / w.EXPR_AMT * 100, 2)`，
    无 100% 上限。
- **影响范围**：
  - 明细表 TAKE_RATE、统计表 ASSET_UNDTAKE_RATE 在"窗口内购买金额超过到期金额"时
    显示 >100%（本次样例为 120%）。
- **复现证据**：
  - C001：EXPR_AMT=100000，TAKE_AMT_30D=120000 → TAKE_RATE=120。
- **建议解决方案**：
  - 业务确认是否限幅（如 `LEAST(..., 100)`）；若确认，则同步修改 DTL 与映射文档，
    并补测试用例。
- **处理决策**：不修复（用户确认"其余不做处理"；如业务后续要求限幅再重新评估）

---

## DEFECT-2026-08-01-004：EXPR_AMT 已到期金额截止日使用 SYSDATE 而非 V_SYSDAT（阻断级）

- **状态**：已修复（2026-08-01，回归验证通过）
- **具体位置**：
  - `data_assets/stored_procedure/dws_to_ads/PRC_ADS_CUST_DEADLINE_RMND_DTL.sql` 第 4 段
  - `SUM(CASE WHEN m.EXPR_DT <= V_END_DATE THEN NVL(m.EXPR_AMT,0) ELSE 0 END) AS EXPR_AMT`，
    其中 V_END_DATE 在每段末尾被赋值为 SYSDATE（运行时刻）
- **影响范围**：
  - 违反口径12/待确认4"已到期截止日 = T-1 = 跑批日 V_SYSDAT"
  - 历史回放/补数（V_SYSDAT 早于当前日期）时，周期内晚于 V_SYSDAT 但早于当前日期的
    到期产品被错误计入 EXPR_AMT，导致已到期金额/承接率分母虚高
- **复现证据**：
  - C10 首笔到期 06-05，跑批日 06-01 时 M 周期 EXPR_AMT=230000（预期 0）；
    连续 30 天跑批全程 EXPR_AMT=230000，无"未到期=0"阶段（见验证报告 A1）
- **建议解决方案**：
  - EXPR_AMT 截止改为 `m.EXPR_DT <= TO_DATE(V_SYSDAT,'YYYYMMDD')`，
    并同步核对 v2.7.0 变更记录（该处已声明改为 V_SYSDAT，实现未对齐）
- **处理决策**：Codex 执行（用户 2026-08-01 确认修复）
  - 修复位置：`PRC_ADS_CUST_DEADLINE_RMND_DTL.sql` 第 4 段 EXPR_AMT 聚合
  - 修复内容：`m.EXPR_DT <= V_END_DATE` 改为 `m.EXPR_DT <= TO_DATE(V_SYSDAT,'yyyymmdd')`
  - 回归证据：C10 跑批 06-01 EXPR_AMT=0（修复前 230000）；30 天递进 0→100000→150000→230000 正确

---

## DEFECT-2026-08-01-005：CNTCT_STATE 接触状态未按 V_SYSDAT 截止（阻断级）

- **状态**：已修复（2026-08-01，回归验证通过）
- **具体位置**：
  - `PRC_ADS_CUST_DEADLINE_RMND_DTL.sql` 第 9 段 CNTCT_STATE 判定，
    仅判断 `MKT_TIME BETWEEN FIRST_EXPR_DT AND TAKE_END_DT_30D`，无 `MKT_TIME <= V_SYSDAT` 上限
- **影响范围**：
  - 违反口径21/27"接触状态截止日使用 V_SYSDAT"；
    未来日期（晚于跑批日）的营销记录会被计入，接触状态虚高
- **复现证据**：
  - C12 跑批 07-05，营销记录 07-20（在窗口 06-28~07-28 内但晚于跑批日）→ CNTCT_STATE=1（预期 0）
- **建议解决方案**：
  - 判定条件增加 `AND TO_DATE(REPLACE(SUBSTR(m.MKT_TIME,1,10),'-',''),'YYYYMMDD') <= TO_DATE(V_SYSDAT,'YYYYMMDD')`
- **处理决策**：Codex 执行（用户 2026-08-01 确认修复）
  - 修复位置：`PRC_ADS_CUST_DEADLINE_RMND_DTL.sql` 第 9 段 CNTCT_STATE 判定
  - 修复内容：窗口判定增加 `MKT_TIME 日期 <= TO_DATE(V_SYSDAT,'yyyymmdd')`
  - 回归证据：C12 跑批 07-05 CNTCT_STATE=0（修复前 1）

---

## DEFECT-2026-08-01-006：TAKE_AMT/CROSS_CONV 按 STAT_PERD 聚合未区分统计周期（阻断级）

- **状态**：已修复（2026-08-01，回归验证通过）
- **具体位置**：
  - `PRC_ADS_CUST_DEADLINE_RMND_DTL.sql` 第 6 段（TAKE_AMT）与第 6.1 段（CROSS_CONV）
  - 分组键 `STAT_PERD + CUST_ID + STATIS_TYP + PERSN_LEGAL_BK_CODE`，
    无 BGN_DT/END_DT 或 DATA_DATE 维度，上季 Q1 与当季 Q2、上月与当月被合并
- **影响范围**：
  - 上月/上季周期切片错误关联当期购买金额；
    承接率、转化率在上期周期行错配（本测试 C17 Q1 行 TAKE_RATE 错误 70%，预期 0）
- **复现证据**：
  - C17：Q1 周期（03-31 到期，窗口 03-31~04-30 无购买）TAKE_RATE=70，
    实际关联的是 Q2 周期（06-01/06-30 到期窗口内）的 70000 购买
- **建议解决方案**：
  - TAKE_AMT/CROSS_CONV 分组与关联键增加周期边界（如 BGN_DT/END_DT 或 DATA_DATE），
    使上期与当期周期切片独立计算
- **处理决策**：Codex 执行（用户 2026-08-01 确认修复）
  - 修复位置：`PRC_ADS_CUST_DEADLINE_RMND_DTL.sql` 第 6/6.1 段与第 9 段最终查询
  - 修复内容：TAKE_AMT/CROSS_CONV 不再按 STAT_PERD 聚合写入中间表，改为第 9 段
    按统计周期实例（BGN_DT/END_DT）内联派生表计算；TMP_CDR_DTL_TAKE_AMT /
    TMP_CDR_DTL_CROSS_CONV 表结构保留，不再生成数据（无结构变更）
  - 回归证据：C17 Q1 周期（03-31 到期）TAKE_RATE=0 且明细仅 1 行（修复前 70%、2 行）

---

## DEFECT-2026-08-01-007：DTL 最终关联 AUM_BAL 缺少 DATA_DATE 导致明细行重复（阻断级）

- **状态**：已修复（2026-08-01，回归验证通过）
- **具体位置**：
  - `PRC_ADS_CUST_DEADLINE_RMND_DTL.sql` 第 9 段最终 INSERT 的 JOIN
  - `TMP_CDR_DTL_AUM_BAL ap` 关联键为 STAT_PERD+CUST_ID+STATIS_TYP+AUM_TYP+法人，
    未关联 DATA_DATE；同 STAT_PERD 的 Q1/Q2（或上月/当月）各有一条 PREV 行时明细行翻倍
- **影响范围**：
  - 明细行重复（C17 Q1 行 2 行相同），统计表金额放大、客户数/金额失真
- **复现证据**：
  - C17 跑批 06-30：Q1 周期（DATA_DATE=20260331）明细行重复为 2 行（验证报告 A9/A13）
- **建议解决方案**：
  - ap 关联键增加 `AND ap.DATA_DATE = TO_CHAR(w.FIRST_EXPR_DT - 1, 'yyyymmdd')`
- **处理决策**：Codex 执行（用户 2026-08-01 确认修复）
  - 修复位置：`PRC_ADS_CUST_DEADLINE_RMND_DTL.sql` 第 9 段 ap 关联
  - 修复内容：ap 关联键增加 `AND ap.DATA_DATE = TO_CHAR(w.FIRST_EXPR_DT - 1, 'yyyymmdd')`
  - 回归证据：C17 Q1 明细 1 行（修复前 2 行）；ORG100 M0 EXPR_AMT=1049000（修复前 1249000）

---

## DEFECT-2026-08-01-008：DWS 重复快照/负金额等异常数据无防御（观察项）

- **状态**：观察项（未修复；修复需业务确认且可能引入新校验功能，超出本次范围）
- **具体位置**：
  - DTL 第 3 段 MATURE_SRC（DWS 关联）、第 7 段 CUST_BASE（AUM 汇总）、第 8 段 AUM_BAL
- **影响范围**：
  - a) DWS_CUST_ASSE_LIAB 同客户+法人行+同 DATA_DATE 存在多行（重复快照）时，
    MATURE_SRC/AUM 金额按 JOIN 倍数放大（C10 06-04 EXPR_AMT=460000=230000×2、
    C15 FRST_AUM=650000）；对应需求附录 23"防御性校验"场景
  - b) 负金额账户（BAL=-1000）被计入 EXPR_AMT 无业务校验（C16 合计 29000）
- **复现证据**：
  - 验证报告 A1/A6/A7
- **建议解决方案**：
  - 对 DWS 关联增加去重/唯一性校验或异常告警；
  - 对负金额、零金额账户按业务规则过滤或告警（待业务确认）
- **处理决策**：待用户确认（Codex 执行 / 手动处理 / 不修复）
