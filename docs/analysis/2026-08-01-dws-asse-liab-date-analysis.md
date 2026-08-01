# DWS_CUST_ASSE_LIAB 与 dwd_acct_*_his 相关存储过程日期使用分析报告

> 改造状态（2026-08-01）：本报告中的不符合项已按确认的决策完成标准化改造，详见 [docs/changes/2026-08-01-date-parameter-standardization.md](../changes/2026-08-01-date-parameter-standardization.md)。

## 报告信息

- 分析日期：2026-08-01
- 分析范围：`D:\AI\AI-Workspace\Kingbase-CRM-AI-Development-Guide`（离线工作区）
- 数据来源：`data_assets\stored_procedure\` 下全部 22 个存储过程 SQL 文件；`data_assets\ddl\dws\dws_cust_asse_liab.sql`、`data_assets\ddl\dwd\*_his.sql`；`governance\stored_procedure_date_parameter_rules.md`；`data_assets\function\sys_fun_deal_date.sql`
- 说明：本报告基于仓库内存储过程源码静态分析，未连接数据库；仓库外/数据库内另建的过程不在覆盖范围。

## 日期语义基准（sys_fun_deal_date 参数）

| 参数 | 语义 | 参数 | 语义 |
|---|---|---|---|
| 1 | 上一日 | 12 | 当季末 |
| 2 | 上月末 | 13 | 当年初 |
| 3 | 上季末 | 14 | 当年末 |
| 4 | 上年末 | 15 | 上月初 |
| 5 | 上上日 | 16 | 上季初 |
| 6 | 上上月末 | 17 | 上年初 |
| 7 | 上上季末 | 18 | 30天承接窗口开始日 |
| 8 | 上上年末 | 19 | 三年历史清理边界 |
| 9 | 当月初 | 20 | 1月前 |
| 10 | 当月末 | 21 | 6月前 |
| 11 | 当季初 | | |

## 一、使用 DWS_CUST_ASSE_LIAB 的存储过程清单

### 1.1 SQL 实际引用（8 个）

| # | 存储过程 | 路径 | 引用位置 |
|---|---|---|---|
| 1 | PRC_ADS_CUST_SLEEP_WAKE_DTL | data_assets\stored_procedure\dws_to_ads\PRC_ADS_CUST_SLEEP_WAKE_DTL.sql | L139 a0、L180 a、L272 a2、L273 mb、L288 a3 |
| 2 | PRC_ADS_CUST_POTN_UPGRADE_CUST_DTL | data_assets\stored_procedure\dws_to_ads\PRC_ADS_CUST_POTN_UPGRADE_CUST_DTL.sql | L149 p、L161 m、L166 b |
| 3 | PRC_ADS_CUST_POTN_UPGRADE_STATIS | data_assets\stored_procedure\dws_to_ads\PRC_ADS_CUST_POTN_UPGRADE_STATIS.sql | L136 M、L163 M |
| 4 | PRC_ADS_CUST_NEW_CUST_DTL | data_assets\stored_procedure\dws_to_ads\PRC_ADS_CUST_NEW_CUST_DTL.sql | L279 a |
| 5 | PRC_ADS_CUST_NEW_CUST_STATIS | data_assets\stored_procedure\dws_to_ads\PRC_ADS_CUST_NEW_CUST_STATIS.sql | L195 A、L220 A |
| 6 | PRC_ADS_CUST_LOST_DTL | data_assets\stored_procedure\dws_to_ads\PRC_ADS_CUST_LOST_DTL.sql | L208 p、L223 pp、L241 e、L247 b |
| 7 | PRC_ADS_CUST_DEADLINE_RMND_STATIS | data_assets\stored_procedure\dws_to_ads\PRC_ADS_CUST_DEADLINE_RMND_STATIS.sql | L123 x |
| 8 | PRC_ADS_CUST_DEADLINE_RMND_DTL | data_assets\stored_procedure\dws_to_ads\PRC_ADS_CUST_DEADLINE_RMND_DTL.sql | L236 CA、L261 CA、L605 a、L659 h |

### 1.2 仅注释声明、无 SQL 引用（1 个）

| 存储过程 | 路径 | 说明 |
|---|---|---|
| PRC_ADS_CUST_LOST_STATIS | data_assets\stored_procedure\dws_to_ads\PRC_ADS_CUST_LOST_STATIS.sql | 头部"来源表"注释列出 DWS_CUST_ASSE_LIAB，SQL 主体实际未使用 |

### 1.3 名称含"ASSET_LIAB"但操作其他表（1 个）

| 存储过程 | 路径 | 实际关联表 |
|---|---|---|
| PRC_DWS_CUST_ASSE_LIAB_CUMU | data_assets\stored_procedure\dwd_to_dws\PRC_DWS_CUST_ASSE_LIAB_CUMU.sql | DWS_CUST_ASSE_LIAB_CUMU、DWS_CUST_ASSE_LIAB_CUMU_HIS（非 DWS_CUST_ASSE_LIAB 本身） |

## 二、DWS_CUST_ASSE_LIAB 的 DATA_DATE 日期类型及使用场景

> 表结构：`DWS_CUST_ASSE_LIAB.DATA_DATE VARCHAR(8)`，`BAL_TYPE`（1=余额、2=月日均、3=季日均、4=年日均）。

### 2.1 PRC_ADS_CUST_POTN_UPGRADE_CUST_DTL（潜力提升明细）

| 日期类型 | 取值/推导 | 条件 | 使用场景 |
|---|---|---|---|
| 跑批日 | V_SYSDAT | DWS m：DATA_DATE=V_SYSDAT AND BAL_TYPE='2' | 当月月日均AUM，计算月日均达标 |
| 跑批日（T-1口径） | V_SYSDAT | DWS b：DATA_DATE=V_SYSDAT AND BAL_TYPE='1' | T-1日时点资产，输出 PNT_AUM_BAL 及活期/定期/理财余额 |
| 上月末 | V_PREV_MONTH_END=sys_fun_deal_date(V_SYSDAT,2) | DWS p：DATA_DATE=V_PREV_MONTH_END AND BAL_TYPE='2' | 上月月日均资产筛选临界客户（AUM≥45000） |
| 当月初 | V_CURR_MONTH_BEGIN_DT=TO_DATE(sys_fun_deal_date(V_SYSDAT,9)) | ADS_MKT_REC_INFO.MKT_TIME BETWEEN 当月初 AND 跑批日 | 月接触状态窗口 |
| 三年清理边界 | V_HISTORY_CUTOFF_DATE=sys_fun_deal_date(V_SYSDAT,19) | 目标表 DELETE DATA_DATE<边界 | 历史数据清理 |
| 输出日期 | DATA_DATE=V_SYSDAT | 目标表写入 | 明细数据日期=跑批日 |

### 2.2 PRC_ADS_CUST_POTN_UPGRADE_STATIS（潜力提升统计）

| 日期类型 | 取值/推导 | 条件 | 使用场景 |
|---|---|---|---|
| 跑批日 | V_SYSDAT | DWS M：DATA_DATE=V_SYSDAT AND BAL_TYPE='2' | 补充当月月日均AUM（机构/管户经理两套统计口径） |
| 跑批日 | V_SYSDAT | 明细 D.DATA_DATE=V_SYSDAT | 仅统计当天跑批产生的明细 |
| 三年清理边界 | sys_fun_deal_date(V_SYSDAT,19) | 目标表 DELETE | 历史清理 |

### 2.3 PRC_ADS_CUST_NEW_CUST_DTL（新客经营明细）

| 日期类型 | 取值/推导 | 条件 | 使用场景 |
|---|---|---|---|
| 跑批日 | V_DATA_DATE=V_SYSDAT | DWS a：DATA_DATE=V_DATA_DATE AND BAL_TYPE='1' | 当日余额快照，判断新客资产及输出余额 |
| 当月初（直接TRUNC） | V_BN_MONTH=TRUNC(TO_DATE(V_DATA_DATE),'MM') | 客户 OPEN_DATE 所在月=V_BN_MONTH | 判断开户月是否为当月新客（未评级） |
| 三年前年初（直接ADD_MONTHS） | V_CUTOFF_DATE=ADD_MONTHS(TRUNC(TO_DATE(V_DATA_DATE),'YYYY'),-36) | 目标表 DELETE DATA_DATE<边界 | 历史清理 |
| 记录自身日期 | 客户 OPEN_DATE | DATA_DATE-OPEN_DATE <30/100/180天 | 新客周期 NEW_CUST_CYCLE 判定 |
| 记录自身日期 | OPEN_DATE→V_DATA_DATE | 接触时间 BETWEEN | 新客周期内已接触判定 |
| 输出日期 | DATA_DATE=V_DATA_DATE | 目标表写入 | 数据日期=跑批日 |

### 2.4 PRC_ADS_CUST_NEW_CUST_STATIS（新客经营统计）

| 日期类型 | 取值/推导 | 条件 | 使用场景 |
|---|---|---|---|
| 上一日（T-1） | V_PREV_DAY=sys_fun_deal_date(V_SYSDAT,1) | DWS A：DATA_DATE=V_PREV_DAY AND BAL_TYPE='1' | 取 T-1 日 AUM 余额快照 |
| 上月末 | V_PREV_MONTH_END=sys_fun_deal_date(V_SYSDAT,2) | 明细 D.DATA_DATE=V_PREV_MONTH_END | 关联上月末月度明细；清理上月末月度统计 |
| 三年前年初（直接ADD_MONTHS） | V_BN_YEAR=ADD_MONTHS(TRUNC(TO_DATE(V_DATA_DATE),'YYYY'),-36) | 目标表 DELETE | 历史清理 |

### 2.5 PRC_ADS_CUST_LOST_DTL（流失挽回明细）

| 日期类型 | 取值/推导 | 条件 | 使用场景 |
|---|---|---|---|
| 上月末 | V_PREV_MONTH_END=sys_fun_deal_date(V_SYSDAT,2) | DWS p：DATA_DATE=V_PREV_MONTH_END AND BAL_TYPE='2' | 上月月日均，判定轻度流失 |
| 上月末 | 同上 | DWS e：DATA_DATE=V_PREV_MONTH_END AND BAL_TYPE='1' | 上月末时点AUM，判定上月末余额达标 |
| 上上月末 | V_PREV_PREV_MONTH_END=sys_fun_deal_date(V_SYSDAT,6) | DWS pp：DATA_DATE=V_PREV_PREV_MONTH_END AND BAL_TYPE='2' | 上上月月日均，判定重度流失 |
| 跑批日（T-1口径） | V_DATA_DATE=V_SYSDAT | DWS b：DATA_DATE=V_DATA_DATE AND BAL_TYPE='1' | T-1日时点资产及挽回判定 |
| 当月初（直接TRUNC） | V_CURR_MONTH_BEGIN_DT=TRUNC(TO_DATE(V_DATA_DATE),'MM') | MKT_TIME BETWEEN 当月初 AND 跑批日 | 月接触状态窗口 |
| 三年前年初（内联直接） | TO_CHAR(ADD_MONTHS(TRUNC(TO_DATE(V_DATA_DATE),'YYYY'),-36)) | 目标表 DELETE DATA_DATE<边界 | 历史清理 |

### 2.6 PRC_ADS_CUST_SLEEP_WAKE_DTL（睡眠唤醒明细）

| 日期类型 | 取值/推导 | 条件 | 使用场景 |
|---|---|---|---|
| 跑批日 | V_DATA_DATE=V_SYSDAT | DWS a0/a/a2/a3：DATA_DATE=V_DATA_DATE AND BAL_TYPE='1' | 当日资产负债快照：睡眠判定（AUM<100）、余额输出、唤醒后复核 |
| 唤醒基线（动态） | 月首=上一日 V_PREV_DAY；非月首=当月首日 | DWS mb：DATA_DATE=V_PREV_MONTH_END（变量重载）AND BAL_TYPE='1' | 唤醒基线快照（上月末余额<100） |
| 上一日 | V_PREV_DAY=sys_fun_deal_date(V_SYSDAT,1) | 昨日 DTL：DATA_DATE=V_PREV_DAY | 读取昨日清单继续累积 |
| 当月首日 | V_CURR_MONTH_BEGIN=sys_fun_deal_date(V_SYSDAT,9) | V_DATA_DATE=V_CURR_MONTH_BEGIN | 月首标志判断、决定基线日期 |
| 365天窗口（直接推导） | TO_DATE(V_DATA_DATE)-365 ~ V_DATA_DATE | DWD_TX_ASET.TX_DATE BETWEEN | 近365天主动动账判断（JIOYCFFS='0'） |
| 月接触窗口（直接TRUNC） | TRUNC(TO_DATE(V_DATA_DATE),'MM') ~ V_DATA_DATE | MKT_TIME BETWEEN | 接触状态 |
| 三年前年初（内联直接） | ADD_MONTHS(TRUNC(TO_DATE(V_DATA_DATE),'YYYY'),-36) | 目标表 DELETE | 历史清理 |
| 输出日期 | DATA_DATE=V_DATA_DATE | 目标表写入 | 数据日期=跑批日 |

### 2.7 PRC_ADS_CUST_DEADLINE_RMND_STATIS（到期承接统计）

| 日期类型 | 取值/推导 | 条件 | 使用场景 |
|---|---|---|---|
| 跑批日 | V_SYSDAT | DWS x：DATA_DATE=V_SYSDAT AND BAL_TYPE='1' | 当前AUM汇总（CURR_AUM_BAL） |
| 上月末/上季末/上年末 | sys_fun_deal_date(2/3/4) | 明细 STAT_PERD 与 DATA_DATE 匹配 | 上一周期统计口径（M/Q/Y） |
| 当月末/当季末/当年末 | sys_fun_deal_date(10/12/14) | 同上 | 当前周期统计口径 |
| 三年清理边界 | sys_fun_deal_date(19) | 目标表 DELETE | 历史清理（保留周期末日） |

### 2.8 PRC_ADS_CUST_DEADLINE_RMND_DTL（到期承接明细）

| 日期类型 | 取值/推导 | 条件 | 使用场景 |
|---|---|---|---|
| 跑批日 | V_SYSDAT | DWS CA：DATA_DATE=V_SYSDAT | 到期账户关联法人行/机构（当前AUM） |
| 跑批日 | V_SYSDAT | DWS a：DATA_DATE=V_SYSDAT AND BAL_TYPE='1' | 当前AUM余额（客户基础中间表） |
| 上一日 | V_PREV_DAY=sys_fun_deal_date(V_SYSDAT,1) | 营销接触 MKT_TIME<=V_PREV_DAY；P_INTERVAL_END_DATE | 30天承接窗口结束日、接触判定截止 |
| 当月初/当月末/当季初/当季末/当年初/当年末 | sys_fun_deal_date(9/10/11/12/13/14) | TMP_CDR_DTL_PERIOD BGN_DT/END_DT | 当前 M/Q/Y 统计周期区间 |
| 上月初/上季初/上年初 | sys_fun_deal_date(15/16/17) | 同上 | 上一 M/Q/Y 周期区间 |
| 上月末/上季末/上年末 | sys_fun_deal_date(2/3/4) | 同上 | 上一周期结束日 |
| 30天窗口开始日 | P_INTERVAL_START_DATE=sys_fun_deal_date(18) | 到期产品 EXPR_DT 区间 | 30天到期承接窗口 |
| 三年清理边界 | sys_fun_deal_date(19) | 目标表 DELETE | 历史清理 |
| 记录自身日期 | 账户 EXPR_DATE/INTRI_BGN_DATE/ESTAB_DATE/ISSU_DATE/TX_DATE/BGN_INSUR_DATE | TO_DATE 解析 | 到期日/购买日匹配 |
| 记录自身日期 | DWS h：DATA_DATE=TO_CHAR(FIRST_EXPR_DT-1) | 第一笔到期前一日 | 承接前一日AUM（PREV 口径） |
| 输出日期 | DATA_DATE=周期结束日（TO_CHAR(END_DT)） | 目标表写入 | 明细按统计周期结束日归档 |

### 2.9 PRC_ADS_CUST_LOST_STATIS

无实际 SQL 引用，无日期使用。

## 三、使用 dwd_acct_*_his 系列表的存储过程清单

### 3.1 系列表（DDL 存在）

| 表名 | DDL 路径 |
|---|---|
| crmdm.dwd_acct_depo_his | data_assets\ddl\dwd\dwd_acct_depo_his.sql、SYDDL.ddl.sql L6324 |
| crmdm.dwd_acct_fin_his | data_assets\ddl\dwd\dwd_acct_fin_his.sql、SYDDL.ddl.sql L6408 |
| crmdm.dwd_acct_insur_his | data_assets\ddl\dwd\dwd_acct_insur_his.sql、SYDDL.ddl.sql L6497 |
| crmdm.dwd_acct_loan_his | data_assets\ddl\dwd\dwd_acct_loan_his.sql、SYDDL.ddl.sql L6583 |

### 3.2 SQL 实际使用这些表的过程（1 个）

| 存储过程 | 路径 | 使用的 his 表 |
|---|---|---|
| PRC_DWS_CUST_ASSE_LIAB_CUMU | data_assets\stored_procedure\dwd_to_dws\PRC_DWS_CUST_ASSE_LIAB_CUMU.sql | DWD_ACCT_INSUR_HIS（L201） |

补充：该过程另使用 DWS_CUST_ASSE_LIAB_CUMU_HIS（L839、L883），不属于 dwd_acct_*_his 模式，但同属历史表，一并记录。

### 3.3 相关发现

- 仓库内无任何存储过程**写入** dwd_acct_*_his 系列表（PRC_DWD_ACCT_INSUR / PRC_DWD_ACCT_FIN 仅 TRUNCATE/INSERT 当前表 DWD_ACCT_INSUR / DWD_ACCT_FIN）。
- 需求记忆卡片记录 his DDL 已实现（REQ-INSUR-003、REQ-FIN-003），但生产链路（谁写历史表）在仓库内无对应过程，需与数据库实际对象核对。

## 四、PRC_DWS_CUST_ASSE_LIAB_CUMU 日期类型及使用场景

### 4.1 跑批基准相关

| 日期类型 | 取值/推导 | 条件 | 使用场景 |
|---|---|---|---|
| 跑批日 | V_DATA_DATE=V_SYSDAT | DWD_ACCT_INSUR_HIS.DATA_DATE <= V_DATA_DATE | 取截至跑批日的保险历史交易全量流水，生成 TMP_DWS_CUST_ASSE_LIAB_INSUR_TX |
| 跑批日 | V_DATA_DATE | DWS_CUST_ASSE_LIAB_CUMU_HIS：DATA_DATE>=V_YAR_BEGIN AND DATA_DATE<V_DATA_DATE | 本年至今历史 KEY 补零 |
| 跑批日 | V_DATA_DATE | DWS_CUST_ASSE_LIAB_CUMU_HIS：DATA_DATE=V_PRE_DATA_DATE | 取上一日历史累计（MTH/QRT/YAR_BAL 基数） |
| 跑批日 | V_DATA_DATE | 目标表 DELETE DATA_DATE=V_DATA_DATE；写入 DATA_DATE=V_DATA_DATE | 当日重跑清理与落数 |

### 4.2 相对日期（全部为直接推导，未使用 sys_fun_deal_date）

| 日期类型 | 推导 | 使用场景 |
|---|---|---|
| 上一日 | V_PRE_DATA_DATE=TO_CHAR(V_DT-1) | 取上一日历史累计余额（对应参数1语义） |
| 当月初 | V_MTH_BEGIN=TO_CHAR(TRUNC(V_DT,'MM')) | 月累计清零判断、月已过天数（对应参数9语义） |
| 当季初 | V_QRT_BEGIN=TO_CHAR(TRUNC(V_DT,'Q')) | 季累计清零判断、季已过天数（对应参数11语义） |
| 当年初 | V_YAR_BEGIN=TO_CHAR(TRUNC(V_DT,'YYYY')) | 年累计清零判断、年已过天数、区间起点（对应参数13语义） |
| 月/季/年已过天数 | V_MTH_DAYS/QRT_DAYS/YAR_DAYS=V_DT-TRUNC+1 | 日均余额分母 |
| 年初~跑批日区间 | P_INTERVAL_START_DATE=V_YAR_BEGIN，P_INTERVAL_END_DATE=V_DATA_DATE | 全年累计区间 |

### 4.3 记录自身日期（源字段解析与保单计划）

| 日期类型 | 字段/推导 | 使用场景 |
|---|---|---|
| 交易/投保/退保/缴费截止日 | TX_DATE、BGN_INSUR_DATE、CANCL_INSUR_DATE、PAY_UPTO_DATE 的 TO_DATE 解析 | 生成保险历史交易临时表 |
| 首期/缴费截止日 | FIRST_TX_DT、PAY_UPTO_DT 加减 ADD_MONTHS/日 | 按缴费方式生成应缴计划（年缴/月缴/日缴） |
| 跑批日与保单日期比较 | V_DT 与 FIRST_TX_DT、PAY_UPTO_DT 比较 | 计算保险当日余额 |

## 五、规范符合性检查（对照 governance/stored_procedure_date_parameter_rules.md）

### 5.1 基本符合

- PRC_ADS_CUST_DEADLINE_RMND_DTL / STATIS：相对业务日期全部使用 sys_fun_deal_date 具名参数（1/2/3/4/9/10/11/12/13/14/15/16/17/18/19），符合规范。
- PRC_ADS_CUST_POTN_UPGRADE_CUST_DTL / STATIS、PRC_ADS_CUST_LOST_DTL：上月末、上上月末、三年边界等使用 sys_fun_deal_date。
- PRC_ADS_CUST_NEW_CUST_STATIS：T-1、上月末使用 sys_fun_deal_date。
- 目标表日期字段输出均为 8 位 YYYYMMDD。

### 5.2 不符合/风险项

| # | 过程 | 问题 | 风险 |
|---|---|---|---|
| 1 | PRC_ADS_CUST_NEW_CUST_DTL | 当月初用 TRUNC 直接推导；三年前年初用 ADD_MONTHS+TRUNC 直接推导 | 与规则"禁止直接基于 V_SYSDAT 推导业务边界"冲突；清理边界与参数19（36个月前当日）语义不一致 |
| 2 | PRC_ADS_CUST_NEW_CUST_STATIS | V_BN_YEAR 用 ADD_MONTHS+TRUNC 直接推导 | 同上 |
| 3 | PRC_ADS_CUST_LOST_DTL | 当月初 TRUNC 直接推导；历史清理内联 ADD_MONTHS+TRUNC | 同上 |
| 4 | PRC_ADS_CUST_SLEEP_WAKE_DTL | 365天动账窗口直接 V_DATA_DATE-365；月接触窗口 TRUNC；历史清理内联推导；V_PREV_MONTH_END 变量被重载为"上一日/当月首日"两个语义 | 违反具名参数与"不得复用语义不一致日期参数"；固定窗口未登记 |
| 5 | PRC_DWS_CUST_ASSE_LIAB_CUMU | 上日、当月初、当季初、当年初、已过天数全部直接 TRUNC/加减推导，未用 sys_fun_deal_date | 存量过程，规则适用"进入需求开发时改造"；当前为最大直接推导集中点 |
| 6 | 等级表日期列命名 | dws_cust_lvl_info 实际列 DATA_DTTE；LOST_DTL 用 DATA_DT，SLEEP_WAKE_DTL/POTN_UPGRADE/DEADLINE_RMND 用 DATA_DATE，NEW_CUST_DTL 用 DATA_DTTE | 跨过程列名不一致，存在编译/运行风险，需统一核对 |
| 7 | T-1 口径 | POTN/LOST v2.4.1 起 T-1 日=跑批日 V_SYSDAT；NEW_CUST_STATIS 仍用参数1（前一自然日） | 同一"T-1"词在不同过程语义不同，需在规范中明确区分 |

## 六、后续建议

1. 将本报告作为日期使用规范检查基线，后续改造按 `governance\stored_procedure_date_parameter_rules.md` 逐项对齐。
2. 优先改造直接推导集中点：PRC_DWS_CUST_ASSE_LIAB_CUMU、PRC_ADS_CUST_NEW_CUST_DTL、PRC_ADS_CUST_SLEEP_WAKE_DTL。
3. 统一 dws_cust_lvl_info 日期列引用（DATA_DTTE），消除跨过程命名差异。
4. 特殊固定窗口（365天动账、180天新客、30天承接）建议在规范中登记编号或具名参数。
5. 核实 dwd_acct_*_his 系列表的生产写入链路（仓库内无写入过程），确认数据库实际对象归属。
