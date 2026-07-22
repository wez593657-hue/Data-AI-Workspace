# ADS 重点经营视图 TMP 表审核清单

以下物理 `TMP_` 表仅在各过程运行期间使用，表名以过程名和运行日期隔离。创建前需人工审核字段。

| 过程 | TMP 表 | 用途 | 核心字段 |
| --- | --- | --- | --- |
| 到期承接明细 | `TMP_CDR_DTL_PERIOD` | 自然月、季、年周期边界 | `STAT_PERD, BGN_DT, END_DT` |
| 到期承接明细 | `TMP_CDR_DTL_MATURE_SRC` | 存款、理财到期产品归集，含全部汇总类型 | `CUST_ID, STATIS_TYP, ACCT_ID, PRDKT_ID, EXPR_AMT, EXPR_DT` |
| 到期承接明细 | `TMP_CDR_DTL_DUE_WIN` | 30天购买归属窗口 | `STAT_PERD, CUST_ID, STATIS_TYP, FIRST_EXPR_DT, LAST_EXPR_DT, TAKE_END_DT_30D` |
| 到期承接明细 | `TMP_CDR_DTL_PURCHASE_SRC` | 定期存款、长期化理财、保险购买来源 | `CUST_ID, PRDKT_TYP, BUY_AMT, BUY_DT` |
| 到期承接明细 | `TMP_CDR_DTL_TAKE_AMT` | 30天承接、转存和转保险金额 | `STAT_PERD, CUST_ID, STATIS_TYP, TAKE_AMT_30D, BUY_DEPO_AMT_30D, BUY_FIN_AMT_30D` |
| 到期承接明细 | `TMP_CDR_DTL_CUST_BASE` | 客户归属、管户关系和余额 | `CUST_ID, CUST_NAME, POST_ID, ORG_ID, DEPO_CURNT_DEPO_BAL, FIXD_DEPO_BAL, FIN_AMT` |
| 到期承接明细 | `TMP_CDR_DTL_AUM_BAL` | 首笔到期前一日及数据日AUM | `STAT_PERD, CUST_ID, STATIS_TYP, AUM_TYP, DATA_DATE, AUM_BAL` |
| 到期承接统计 | `TMP_CDR_STAT_BASE` | 到期承接明细与数据日 AUM 的统计基础 | `CUST_ID, ORG_ID, POST_ID, STAT_PERD, STATIS_TYP, EXPR_AMT, CURR_AUM_BAL` |
| 到期承接统计 | `TMP_CDR_STAT_SRC` | 机构向上汇总及客户经理统计对象展开 | `STATIS_OBJ, CUST_ID, STAT_PERD, STATIS_TYP, 指标字段` |
| 潜力提升明细/统计 | `TMP_ADS_POTN_BASE` | 临界客户、资产、接触状态 | `CUST_ID, LVL_CRIT, AUM_MTH_AVG, AUM_BAL, POST_ID, ORG_ID` |
| 流失挽回明细/统计 | `TMP_ADS_LOST_BASE` | 月日均、时点余额、挽回状态 | `CUST_ID, LVL_CHURN, PREV_AUM, CURR_AUM, POST_ID, ORG_ID` |
| 新客经营明细/统计 | `TMP_ADS_NEW_CUST_BASE` | 最早开户日、资产、KYC、接触状态 | `CUST_ID, OPEN_DATE, NEW_CUST_CYCLE, KYC_RATE, POST_ID, ORG_ID` |
| 睡眠户唤醒明细/统计 | `TMP_ADS_SLEEP_BASE` | 低 AUM、动账、唤醒状态 | `CUST_ID, AUM_BAL, ACTIVE_TX_FLG, WAKE_STATE, POST_ID, ORG_ID` |
| 五类统计过程 | `TMP_ADS_ORG_SCOPE` | 叶子机构到祖先机构映射 | `LEAF_ORG_ID, ANCESTOR_ORG_ID, ORG_LEVEL` |

## 统一约束

- `ORG_ID`、`LEAF_ORG_ID`、`ANCESTOR_ORG_ID`：`VARCHAR(7)`。
- `POST_ID`、`STATIS_OBJ`：`VARCHAR(20)`。
- `DATA_DATE`：`VARCHAR(8)`，格式为 `YYYYMMDD`。
- 统计周期：`M`、`Q`、`N`。
- 到期承接类型：`0`、`1`、`2`。
- 产品分类代码和主动动账 `LOAN_FLG` 值未提供；对应规则表字段保留为待补充，未配置时采用保守结果。
