# 潜力提升过程本地 Oracle 验证缺陷台账

依据 `docs/standards/oracle-local-testing-policy.md` 第 4 节登记。
未经用户确认，不得修改任何数据资产文件。

---

## DEFECT-POTN-001：跨机构客户时点/月均关联缺 ORG_ID 导致笛卡尔积（阻断级）

- **状态**：已关闭（不修复，2026-08-01）
- **具体位置**：
  - `data_assets/stored_procedure/dws_to_ads/PRC_ADS_CUST_POTN_UPGRADE_CUST_DTL.sql`
    TMP2 段（TMP_ADS_POTN_BASE 生成）
  - b（T-1 时点）与 m（当月月均）两个 LEFT JOIN 仅按
    `CUST_ID + PERSN_LEGAL_BK_CODE + DATA_DATE + BAL_TYPE` 关联，未含 ORG_ID；
    变更记录 v2.4.3"移除 ORG_ID 条件"引入
- **影响范围**：
  - 同一客户号+法人行存在多个 ORG_ID（跨机构客户）时，p×b×m 产生笛卡尔积，
    明细行按机构数倍增（测试 P14 两机构：2 行→8 行），
    统计表 TTL_CUST_CNT/达标数/接触数/率值全部失真
- **复现证据**：
  - 明细总数 21（预期 15）；P14=8 行（预期 2）；ORG100 '03' TTL=21（预期 7）；
    PM101 '03' TTL=19（预期 5）
- **需求依据**：
  - `requirements/潜力提升规则记忆卡片.md` v2.2.0 及"计算单位说明"：
    "关联 DWS_CUST_ASSE_LIAB 时必须同时匹配 CUST_ID、ORG_ID 和
    PERSN_LEGAL_BK_CODE，避免跨法人行关联、笛卡尔积和重复计算"
- **建议解决方案**：
  - b/m 关联补充 `AND b.ORG_ID = p.ORG_ID`、`AND m.ORG_ID = p.ORG_ID`
    （回归验证：P14 应为 2 行、ORG100 '03'=7、PM101 '03'=5）
- **处理决策**：不修复（用户 2026-08-01 确认）
  - 业务规则确认：DWS_CUST_ASSE_LIAB 在同一个法人机构（PERSN_LEGAL_BK_CODE）
    下 ORG_ID 唯一（1:1），同客户号+法人行不会出现多 ORG_ID 行，
    P14 构造的跨机构场景属数据异常而非正常业务数据，不作为过程缺陷。
  - 该测试结果保留为"异常数据行为观察"：若真实数据出现同客户同法人行
    多 ORG_ID 行，应按数据异常处理（与到期承接需求附录 23 的防御性校验一致）。
