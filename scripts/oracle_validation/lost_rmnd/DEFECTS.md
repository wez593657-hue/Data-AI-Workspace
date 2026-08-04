# 流失挽回过程本地 Oracle 验证缺陷台账

依据 `docs/standards/oracle-local-testing-policy.md` 第 4 节登记。
未经用户确认，不得修改任何数据资产文件。

---

## DEFECT-LOST-001：ADS_CUST_LOST_DTL 目标表 DDL 缺少 RESCUED_FINA_ASSET 列（阻断级）

- **状态**：已修复（2026-08-01，用户确认）
- **具体位置**：
  - `data_assets/ddl/ads/ads_cust_lost_dtl.sql`（目标表 DDL，14 列，无
    RESCUED_FINA_ASSET）
  - 过程 `PRC_ADS_CUST_LOST_DTL.sql` 第 4 段 INSERT 列清单（15 列，含
    RESCUED_FINA_ASSET）
- **影响范围**：
  - 按现有 DDL 建表后过程无法运行（ORA-00904: invalid identifier）；
    需求 v2.1.0 明确"明细表新增 RESCUED_FINA_ASSET 字段"，DDL 未同步
- **复现证据**：
  - 需求记忆卡片 v2.1.0："明细表新增RESCUED_FINA_ASSET字段"；
    过程列清单与 DDL 列数不一致（15 vs 14）
- **建议解决方案**：
  - `ads_cust_lost_dtl.sql` 补充
    `RESCUED_FINA_ASSET NUMBER(20,2)`（已挽回金融资产金额）及 COMMENT；
    同步检查数据字典/映射文档
- **处理决策**：Codex 执行（用户 2026-08-01 确认）
  - 修复内容（三处同步）：
    1. `data_assets/ddl/ads/ads_cust_lost_dtl.sql`：
       `RESCUE_STATE` 后补充 `RESCUED_FINA_ASSET NUMBER(20,2)` 及 COMMENT
    2. `data_assets/mapping/dws_to_ads/dws到ads映射.md`：
       表清单列数 14→15；字段映射表补充 RESCUED_FINA_ASSET 行
       及映射规则（MAX(T-1日时点AUM-上月末时点AUM,0)，仅挽回客户计）
    3. `data_assets/mapping/dws_to_ads/ADS应用层数据模型_CRM_ V1.0.xlsx`：
       "客户流失清单" sheet 在 RESCUE_STATE 与 POST_ID 之间插入
       RESCUED_FINA_ASSET 行（属性类型 NUMBER(20,2)、标准中文名 已挽回金融资产），
       并在"修订记录" sheet 登记修订（修改前已备份 .bak）
  - 回归验证：本地 Oracle 两过程编译运行 RC=0；统计表映射已含该字段无需改动
