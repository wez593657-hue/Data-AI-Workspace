# 新客经营过程本地 Oracle 验证缺陷台账

依据 `docs/standards/oracle-local-testing-policy.md` 第 4 节登记。
未经用户确认，不得修改任何数据资产文件。

---

## DEFECT-NEWCUST-001：CUST_LVL 列长度不足，无法存储'未评级'（阻断级）

- **状态**：已修复（2026-08-01，用户确认口径）
- **具体位置**：
  - `data_assets/ddl/ads/ads_cust_new_cust_dtl.sql`：`CUST_LVL VARCHAR(2)`
  - `data_assets/stored_procedure/dws_to_ads/PRC_ADS_CUST_NEW_CUST_DTL.sql`
    TMP2 段：当月新客 CUST_LVL 赋值为'未评级'
- **影响范围**：
  - 当月新客（OPEN_DATE 所在月=跑批月）写入'未评级'（3 个汉字，ZHS16GBK 下 6 字节）
    > VARCHAR2(2)，过程运行报 ORA-12899，整批失败
- **复现证据**：
  - Oracle 11g：`ORA-12899: value too large for column TMP_ADS_NEW_CUST_BASE.CUST_LVL`
    （actual: 6, maximum: 2）；测试环境将 CUST_LVL 扩为 VARCHAR2(10) 后运行成功
- **处理决策**：Codex 执行（用户 2026-08-01 确认：'未评级'码值=11）
  - 修复内容：`PRC_ADS_CUST_NEW_CUST_DTL.sql` TMP2 段当月新客等级
    改为直接取 `NVL(l.CUST_LVL, '11')`（DWS_CUST_LVL_INFO，用户补充确认：
    新客等级含未评级码值 11 亦记录于等级表，不再按开户月重新判断；
    无记录兜底 11），CUST_LVL VARCHAR2(2) 即可容纳；
    `requirements/客户等级.md` 增加码值 11=未评级行
  - 回归证据：N01（当月新客，等级表='04'）输出 '04'；N02/N08/N11='11'；
    N13（无记录）='11' 兜底；无 ORA-12899；测试表保持 VARCHAR2(2)

---

## DEFECT-NEWCUST-002：无管户客户 ORG_ID 为空导致统计遗漏（阻断级）

- **状态**：已修复（2026-08-01，用户确认口径）
- **具体位置**：
  - `PRC_ADS_CUST_NEW_CUST_DTL.sql` TMP2 段：ORG_ID 取自 `m.ORG_ID`
    （DWD_CUST_MAN，MNG_TYP='1'）；无理财管户客户 LEFT JOIN 不命中 → ORG_ID NULL
- **影响范围**：
  - 无管户客户（含仅存在 MNG_TYP='2' 管户的客户）ORG_ID/POST_ID 均为 NULL，
    统计表机构分支（LEAF_ORG_ID=D.ORG_ID 不匹配）与客户经理分支
    （POST_ID IS NOT NULL 过滤）均不包含 → 客户从统计表完全遗漏
  - 与需求 v2.2.0"明细由当日资产快照拆分机构，法人行和归属机构取资产快照"
    口径冲突（v2.3.4 改为取 DWD_CUST_MAN.ORG_ID）
- **复现证据**：
  - 测试 N09（无管户）、N10（管户 MNG_TYP='2'）：明细 14 行，
    统计表 ORG100 周期4=12（缺 2 客户）；N09/N10 的 DTL ORG_ID 为 NULL
- **处理决策**：Codex 执行（用户 2026-08-01 确认：ORG_ID 取 DWS_CUST_ASSE_LIAB）
  - 修复内容：`PRC_ADS_CUST_NEW_CUST_DTL.sql` TMP2 段 ORG_ID 由
    `m.ORG_ID`（DWD_CUST_MAN）改为 `a.ORG_ID`（DWS_CUST_ASSE_LIAB 资产快照）；
    管户经理 POST_ID 仍取 DWD_CUST_MAN（v2.3.4 不变）
  - 回归证据：N09（无管户）/N10（MNG_TYP='2'）ORG_ID=ORG101；
    统计表 ORG100 周期4=14（修复前 12）、周期2=6（修复前 4）

---

## 口径变更影响审核（2026-08-01，用户确认）

1. **未评级码值=11**：仅影响新客经营 DTL（等级赋值），已修复；统计表无 CUST_LVL
   字段，不受影响。
2. **ORG_ID 取 DWS_CUST_ASSE_LIAB**：
   - 新客经营：修复 DEFECT-NEWCUST-002（ORG_ID 改取 a.ORG_ID）✓
   - 流失挽回：审核确认已符合——DTL ORG_ID 取 `COALESCE(p.ORG_ID, pp.ORG_ID)`，
     p/pp 均来自 DWS_CUST_ASSE_LIAB，无需代码修改；回归验证 8 行明细
     ORG_ID 全部来自资产快照 ✓
