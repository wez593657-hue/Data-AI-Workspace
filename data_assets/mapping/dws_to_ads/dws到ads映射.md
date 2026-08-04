# DWS到ADS映射 字段映射

## 映射来源

- Excel：`data_assets/mapping/dws_to_ads/ADS应用层数据模型_CRM_ V1.0.xlsx`
- Excel SHA-256：`a2d1dfc821f432ef4d2ca8c73febe49043b52fc4c5efcb4cefb292a0ee979edf`

## 映射概览

| 目标表 | 字段数 |
|--------|-------:|
| ADS_CRM_R_CUST_LABLE | 155 |
| ADS_CUST_DEADLINE_RMND_DTL | 25 |
| ADS_CUST_DEADLINE_RMND_STATIS | 15 |
| ADS_CUST_INDV_POTEN | 30 |
| ADS_CUST_LOST_DTL | 15 |
| ADS_CUST_LOST_STATIS | 11 |
| ADS_CUST_NEW_CUST_DTL | 14 |
| ADS_CUST_NEW_CUST_STATIS | 15 |
| ADS_CUST_OTHERS_RMND | 17 |
| ADS_CUST_POTN_UPGRADE_CUST_DTL | 14 |
| ADS_CUST_POTN_UPGRADE_STATIS | 12 |
| ADS_CUST_PRDKT_RCMD | 9 |
| ADS_CUST_SLEEP_WAKE_DTL | 13 |
| ADS_CUST_SLEEP_WAKE_STATIS | 9 |
| ADS_MKT_ACT_TSK_MON | 9 |
| ADS_MKT_ACT_TSK_MON_ZB | 7 |
| ADS_MKT_REC_INFO | 27 |
| ADS_MKT_TASK_INDX_SUB_CMPLT | 17 |
| ADS_MKT_TSK_INFO | 16 |
| ADS_STAT_INDX_DATA | 13 |
| REPORT_0001 | 20 |

## 字段映射详情

### ADS_CUST_INDV_POTEN

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源表 | 源字段 | 映射规则 |
|----------|----------------|--------------|------|--------|----------|
| POTEN_CUST_ID | 潜在客户号(自增键) | VARCHAR2(40) |  |  |  |
| POTEN_CUST_NAME | 潜在客户名称 | VARCHAR2(100) |  |  |  |
| POTEN_TYP | 潜客类型 | VARCHAR2(6) |  |  |  |
| POTEN_CUST_TYP | 潜在客户类型 | VARCHAR2(6) |  |  |  |
| GENDER | 性别 | VARCHAR2(6) | DWD_CUST_INDV_INFO | GEND |  |
| CERT_TYP | 证件类型 | VARCHAR2(6) |  |  |  |
| CERT_ID | 证件号码 | VARCHAR2(32) |  |  |  |
| TEL_NO | 联系电话 | VARCHAR2(32) |  |  |  |
| INTENT_DSC | 备注说明 | VARCHAR2(400) |  |  |  |
| DTL_ADDRS | 居住地址 | VARCHAR2(400) |  |  |  |
| CREATR | 创建人 | VARCHAR2(20) | DWD_SYS_ORG | CREATR |  |
| CREAT_TIME | 创建时间 | VARCHAR2(20) |  |  |  |
| POTEN_CUST_STATE | 潜在客户状态 | VARCHAR2(6) |  |  |  |
| LPR_ID | 法人行号 | VARCHAR2(4) |  |  |  |
| SRC_TYP | 来源类型 | VARCHAR2(6) |  |  |  |
| MKT_PERSN | 客户经理 | VARCHAR2(20) |  |  |  |
| ALLO_DATE | 分配日期(创建时和创建日期一致) | VARCHAR2(8) |  |  |  |
| MKT_ORG | 归属机构 | VARCHAR2(7) |  |  |  |
| SERV_ENTER | 工作单位 | VARCHAR2(200) |  |  |  |
| POST | 职位 | VARCHAR2(6) | DWD_CUST_INDV_INFO | HOST_CUST_MNGR_POST_ID |  |
| MTH_INCOM | 月收入 | NUMBER(20,2) |  |  |  |
| YR_INCOM | 年收入 | NUMBER(20,2) |  |  |  |
| RMARK | 备注 | VARCHAR2(400) |  |  |  |
| INF_KLKT_DATE | 潜客转化日期 | VARCHAR2(10) |  |  |  |
| UNIT_ADDRS | 工作单位地址 | VARCHAR2(200) |  |  |  |
| INTN_PRDKT | 意向产品 | VARCHAR2(60) |  |  |  |
| NO_BAT | 批次号 | VARCHAR2(40) |  |  |  |
| CUST_ID | 转化后核心客户号 | VARCHAR2(21) |  |  |  |
| POT_CNVRT_PRDKT | 潜客转化产品 | VARCHAR2(60) |  |  |  |
| POT_CNVRT_ORG | 潜客转化机构 | VARCHAR2(6) |  |  |  |

### ADS_MKT_TASK_INDX_SUB_CMPLT

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源表 | 源字段 | 映射规则 |
|----------|----------------|--------------|------|--------|----------|
| TSK_INDX_ID | 指标任务映射编号 | VARCHAR2(40) |  |  |  |
| TSK_ID | 任务编号 | VARCHAR2(40) |  |  |  |
| MAIN_TSK_ID | 主任务编号 | VARCHAR2(40) |  |  |  |
| INDX_ID | 指标ID | VARCHAR2(40) |  |  |  |
| TSK_NEXT_SEND_TYP | 任务下发类型(0总行下发,1分行/区行下发,2支行下发) | VARCHAR2(6) |  |  |  |
| RSV_OBJ | 接收对象0机构1客户经理 | VARCHAR2(6) |  |  |  |
| RSV_OBJ_ID | 接收对象ID | VARCHAR2(30) |  |  |  |
| TSK_BGN_DATE | 任务开始时间 | VARCHAR2(10) |  |  |  |
| TSK_END_DATE | 任务结束时间 | VARCHAR2(10) |  |  |  |
| INDX_UNIT | 指标单位(万元/个数/百分比) | VARCHAR2(20) |  |  |  |
| INDX_VAL | 指标额 | NUMBER(18,4) |  |  |  |
| INDX_VAL_ADD | 指标加码 | NUMBER(18,4) |  |  |  |
| ACUM_CMPLT_INDX | 累计完成指标 | NUMBER(18,4) |  |  |  |
| DAY_CURNT_CMPLT_INDX | 当天完成指标 | NUMBER(18,4) |  |  |  |
| BASE_VAL | 基准值 | NUMBER(18,4) |  |  |  |
| CURNT_VAL | 当前值 | NUMBER(18,4) |  |  |  |
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR2(30) |  |  |  |

### ADS_MKT_TSK_INFO

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源表 | 源字段 | 映射规则 |
|----------|----------------|--------------|------|--------|----------|
| MKT_TSK_ID | 营销任务编号 | VARCHAR2(40) |  |  |  |
| MKT_ACT_ID | 活动编号 | VARCHAR2(40) |  |  |  |
| CUST_ID | 客户编号 | VARCHAR2(21) |  |  |  |
| CUST_NAME | 客户名称 | VARCHAR2(200) |  |  |  |
| COVER_FLG | 是否接触 | VARCHAR2(1) |  |  |  |
| CONVRS_FLG | 是否成功 | VARCHAR2(1) |  |  |  |
| MKT_PERSN | 营销人 | VARCHAR2(30) |  |  |  |
| MKT_PERSN_ORG | 营销人机构 | VARCHAR2(7) |  |  |  |
| CREATR | 创建人 | VARCHAR2(64) | DWD_SYS_ORG | CREATR |  |
| CREAT_TIME | 创建时间 | VARCHAR2(20) |  |  |  |
| CREAT_ORG | 创建机构 | VARCHAR2(7) |  |  |  |
| BASE_VAL | 基数 | NUMBER(18,4) |  |  |  |
| CURNT_VAL | 当前值 | NUMBER(18,4) |  |  |  |
| DATA_DATE | 数据日期 | VARCHAR2(30) |  |  |  |
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR2(30) |  |  |  |
| ACT_DSC | 备注 | VARCHAR2(2000) |  |  |  |

### ADS_MKT_ACT_TSK_MON

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源表 | 源字段 | 映射规则 |
|----------|----------------|--------------|------|--------|----------|
| DATA_DATE | 数据日期 | VARCHAR2(8) |  |  |  |
| STAT_OBJ | 统计对象 | VARCHAR2(2) |  |  |  |
| MKT_ACT_ID | 营销活动编号 | VARCHAR2(40) |  |  |  |
| CUST_CNT | 客户数 | NUMBER(8) |  |  |  |
| CTKT_COVER_RATE | 接触覆盖率 | NUMBER(10,2) |  |  |  |
| PLAN_SUPPORT_CUST_CNT | 拟支持客户数 | NUMBER(8) |  |  |  |
| FURTHER_MKT_CUST_CNT | 进一步营销客户数 | NUMBER(8) |  |  |  |
| NOT_SUPPORT_CUST_CNT | 不予支持客户数 | NUMBER(8) |  |  |  |
| MKT_SUCCESS_RATE | 营销成功率 | NUMBER(10,2) |  |  |  |

### ADS_MKT_ACT_TSK_MON_ZB

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源表 | 源字段 | 映射规则 |
|----------|----------------|--------------|------|--------|----------|
| DATA_DATE | 数据日期 | VARCHAR2(8) |  |  |  |
| STAT_OBJ | 统计对象 | VARCHAR2(2) |  |  |  |
| MKT_ACT_ID | 营销活动编号 | VARCHAR2(40) |  |  |  |
| BASE_VAL | 基准值 | NUMBER(20,2) |  |  |  |
| CURNT_VAL | 当前值 | NUMBER(20,2) |  |  |  |
| INCR | 增量 | NUMBER(20,2) |  |  | 计算字段: 当前周期值-上一周期值 |
| GROWTH_RATE | 增长率 | NUMBER(10,2) |  |  |  |

### ADS_STAT_INDX_DATA

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源表 | 源字段 | 映射规则 |
|----------|----------------|--------------|------|--------|----------|
| INDX_CODE | 指标编码 | VARCHAR2(100) |  |  |  |
| DATA_BLNG | 数据归属 | VARCHAR2(100) |  |  |  |
| STATIS_DIM | 统计维度 | VARCHAR2(100) |  |  |  |
| STATIS_CALIB | 统计口径 | VARCHAR2(100) |  |  |  |
| CURNT_VAL | 本期值 | NUMBER(20,2) |  |  |  |
| TERM_LAST_VAL | 上期值 | NUMBER(20,2) |  |  |  |
| MTH_END_VAL | 月末值 | NUMBER(20,2) |  |  |  |
| YR_BGN_VAL | 年初值 | NUMBER(20,2) |  |  |  |
| MTH_LAST_END_AVG_DAY_VAL | 上月末日均值 | NUMBER(20,2) |  |  |  |
| YR_LAST_END_AVG_DAY_VAL | 上年末日均值 | NUMBER(20,2) |  |  |  |
| DATA_DATE | 数据日期 | VARCHAR2(10) |  |  |  |
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR2(30) |  |  |  |
| ID | [NULL] | VARCHAR2(10) |  |  | 自增主键 |

### REPORT_0001

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源表 | 源字段 | 映射规则 |
|----------|----------------|--------------|------|--------|----------|
| DATA_DATE | 数据日期 | VARCHAR2(8) |  |  |  |
| BLNG_BRCH | 所属分行 | VARCHAR2(7) |  |  |  |
| BLNG_BRCH_SUB | 所属支行 | VARCHAR2(7) |  |  |  |
| BLNG_BRCH_NET | 所属网点 | VARCHAR2(7) |  |  |  |
| ORG_PATH | 机构路径 | VARCHAR2(20) |  |  |  |
| CUST_LVL | 客户等级 | VARCHAR2(2) |  |  |  |
| CUST_CNT | 客户数 | NUMBER(8) |  |  |  |
| AUM_BAL | AUM余额 | NUMBER(20,2) |  |  |  |
| AUM_MTH_AVG | AUM月日均 | NUMBER(20,2) |  |  |  |
| COMN_FIXD_BAL | 普通定期余额 | NUMBER(20,2) |  |  |  |
| LEHUI_BAL | 乐惠存余额 | NUMBER(20,2) |  |  |  |
| LARGEDP_BAL | 大额存单余额 | NUMBER(20,2) |  |  |  |
| FIXD_SUM | 定期合计 | NUMBER(20,2) |  |  |  |
| DEPO_CURNT_DEPO_BAL | 活期余额 | NUMBER(20,2) |  |  |  |
| DEPO_SUM | 存款合计 | NUMBER(20,2) |  |  |  |
| BIZ_SELF_FIN_BAL | 自营理财余额 | NUMBER(20,2) |  |  |  |
| PROXY_SELL_FIN_BAL | 代销理财余额 | NUMBER(20,2) |  |  |  |
| FIN_BAL_SUM | 理财余额合计 | NUMBER(20,2) |  |  |  |
| INSUR_BAL | 保险余额 | NUMBER(20,2) |  |  |  |
| LOAN_BAL | 贷款余额 | NUMBER(20,2) |  |  |  |

### ADS_CUST_DEADLINE_RMND_DTL

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源表 | 源字段 | 映射规则 |
|----------|----------------|--------------|------|--------|----------|
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR2(4) | DWD_CUST_INDV_INFO | PERSN_LEGAL_BK_CODE | 直接取客户基本信息法人行号 |
| DATA_DATE | 数据日期 | VARCHAR2(8) | TMP_CDR_DTL_DUE_WIN | END_DT | 按 M/Q/N 周期生成，格式化为 yyyymmdd |
| CUST_ID | 客户编号 | VARCHAR2(20) | TMP_CDR_DTL_DUE_WIN | CUST_ID | 直接取到期窗口客户编号 |
| CUST_NAME | 客户名称 | VARCHAR2(100) | TMP_CDR_DTL_CUST_BASE | CUST_NAME | 直接取客户基础中间表 |
| CUST_LVL | 客户等级 | VARCHAR2(2) | TMP_CDR_DTL_CUST_BASE | CUST_LVL | 由 DWD_CUST_INDV_INFO.CUST_HRAKY 映射为 CUST_LVL 后取值 |
| DEPO_CURNT_DEPO_BAL | 活期余额 | NUMBER(20,2) | TMP_CDR_DTL_CUST_BASE | DEPO_CURNT_DEPO_BAL | 直接取客户余额中间表 |
| FIXD_DEPO_BAL | 定期余额 | NUMBER(20,2) | TMP_CDR_DTL_CUST_BASE | FIXD_DEPO_BAL | 直接取客户余额中间表 |
| FIN_AMT | 理财余额 | NUMBER(20,2) | TMP_CDR_DTL_CUST_BASE | FIN_AMT | 直接取客户余额中间表 |
| STAT_PERD | 统计周期 | VARCHAR2(2) | TMP_CDR_DTL_DUE_WIN | STAT_PERD | 直接取到期窗口统计周期 |
| STATIS_TYP | 承接类型1-存款2-理财 | VARCHAR2(2) | TMP_CDR_DTL_DUE_WIN | STATIS_TYP | 1 存款、2 理财、0 汇总 |
| EXPR_AMT | 到期金额 | NUMBER(20,2) | TMP_CDR_DTL_DUE_WIN | EXPR_AMT | 直接取窗口已到期金额 |
| MATURE_TTL_AMT | 到期总金额 | NUMBER(20,2) | TMP_CDR_DTL_DUE_WIN | MATURE_TTL_AMT | 直接取窗口到期总金额 |
| TAKE_RATE | 承接率 | NUMBER(10,2) | TMP_CDR_DTL_TAKE_AMT | TAKE_AMT_30D | ROUND(NVL(t.TAKE_AMT_30D,0)/w.EXPR_AMT*100,2)，EXPR_AMT=0 时为 0 |
| FIX_DEPO_MATURE_AMT | 定期存款到期金额 | NUMBER(20,2) | TMP_CDR_DTL_DUE_WIN | EXPR_AMT | STATIS_TYP=1 时取 EXPR_AMT，否则为 0 |
| FIX_DEPO_MATURE_TTL_AMT | 定期存款到期总金额 | NUMBER(20,2) | TMP_CDR_DTL_DUE_WIN | MATURE_TTL_AMT | STATIS_TYP=1 时取 MATURE_TTL_AMT，否则为 0 |
| FIX_DEPO_TAKE_RATE | 定期存款承接率 | NUMBER(10,2) | TMP_CDR_DTL_TAKE_AMT | BUY_DEPO_AMT_30D | STATIS_TYP=1 时按 BUY_DEPO_AMT_30D/EXPR_AMT 计算 |
| CNTCT_STATE | 接触状态 | VARCHAR2(1) | ADS_MKT_REC_INFO | CUST_ID,MKT_TIME | 存在 MKT_TIME 且不晚于跑批日则为 1，否则为 0 |
| UNDTAKE_STATE | 承接状态 | VARCHAR2(1) | TMP_CDR_DTL_TAKE_AMT | TAKE_AMT_30D | TAKE_AMT_30D/EXPR_AMT >= 0.8 则为 1，否则为 0 |
| FIXED_FIN_MATURE_TRAN_INSUR_AMT | 定期理财到期转保险金额 | NUMBER(20,2) | TMP_CDR_DTL_TAKE_AMT | BUY_INSUR_AMT_30D | 仅作为保险转化金额；保险不计入 TAKE_AMT_30D |
| FIN_MATURE_TRAN_FIXED_AMT | 理财到期转定期金额 | NUMBER(20,2) | TMP_CDR_DTL_TAKE_AMT | BUY_DEPO_AMT_30D | 客户维度汇总 x.STATIS_TYP=2 的 BUY_DEPO_AMT_30D |
| FIXED_MATURE_TRAN_FIN_AMT | 定期到期转理财金额 | NUMBER(20,2) | TMP_CDR_DTL_TAKE_AMT | BUY_FIN_AMT_30D | 客户维度汇总 x.STATIS_TYP=1 的 BUY_FIN_AMT_30D |
| FRST_MATURE_PK_BF_DAY_AUM_BAL | 本期第一笔到期产品前一日AUM余额 | NUMBER(20,2) | TMP_CDR_DTL_AUM_BAL | AUM_BAL | 取 AUM_TYP=PREV 的 AUM_BAL |
| LAST_END_DATE | 本期最后一笔到期产品日期 | VARCHAR2(8) | TMP_CDR_DTL_DUE_WIN | LAST_EXPR_DT | 格式化为 yyyymmdd |
| POST_ID | 管户经理 | VARCHAR2(20) | TMP_CDR_DTL_CUST_BASE | POST_ID | 直接取客户基础中间表 |
| ORG_ID | 归属机构 | VARCHAR2(7) | TMP_CDR_DTL_CUST_BASE | ORG_ID | 直接取客户基础中间表 |

### ADS_CUST_DEADLINE_RMND_STATIS

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源表 | 源字段 | 映射规则 |
|----------|----------------|--------------|------|--------|----------|
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR2(4) | TMP_CDR_STAT_SRC | PERSN_LEGAL_BK_CODE | 直接取统计来源中间表 |
| DATA_DATE | 数据日期 | VARCHAR2(8) | TMP_CDR_STAT_SRC | DATA_DATE | 直接取统计来源中间表 |
| STATIS_OBJ | 统计对象 | VARCHAR2(20) | TMP_CDR_STAT_SRC | STATIS_OBJ | 机构维度取机构层级展开结果，客户经理维度取 POST_ID |
| STATIS_CYCLE | 统计周期 | VARCHAR2(2) | TMP_CDR_STAT_SRC | STAT_PERD | 由明细统计周期映射为统计周期 |
| STATIS_TYP | 承接类型0-全部 1-定期存款 2-理财 | VARCHAR2(2) | TMP_CDR_STAT_SRC | STATIS_TYP | 直接取统计来源中间表 |
| EXPR_CUST_CNT | 已到期客户数 | NUMBER(8) | TMP_CDR_STAT_SRC | EXPR_AMT,CUST_ID | COUNT(DISTINCT CUST_ID) WHERE EXPR_AMT>0 |
| TTL_EXPR_CUST_CNT | 总到期客户数 | NUMBER(8) | TMP_CDR_STAT_SRC | MATURE_TTL_AMT,CUST_ID | COUNT(DISTINCT CUST_ID) WHERE MATURE_TTL_AMT>0 |
| EXPR_AMT | 已到期金额 | NUMBER(20,2) | TMP_CDR_STAT_SRC | EXPR_AMT | SUM(EXPR_AMT) |
| TTL_EXPR_AMT | 总到期金额 | NUMBER(20,2) | TMP_CDR_STAT_SRC | MATURE_TTL_AMT | SUM(MATURE_TTL_AMT) |
| CUST_UNDTAKE_RATE | 客户承接率 | NUMBER(20,2) | TMP_CDR_STAT_SRC | CUST_TAKE_FLG,CUST_ID,EXPR_AMT | 承接客户数/已到期客户数*100 |
| ASSET_KEEP_RATE | 资产留存率 | NUMBER(20,2) | TMP_CDR_STAT_SRC | CURR_AUM_BAL,FRST_MATURE_PK_BF_DAY_AUM_BAL | SUM(CURR_AUM_BAL)/SUM(FRST_MATURE_PK_BF_DAY_AUM_BAL)*100 |
| ASSET_UNDTAKE_RATE | 资产承接率 | NUMBER(20,2) | TMP_CDR_STAT_SRC | EXPR_AMT,TAKE_RATE_30D | SUM(EXPR_AMT*TAKE_RATE_30D/100)/SUM(EXPR_AMT)*100 |
| DEPO_TO_FIN_CONVRS_RATE | 存款转理财转化率 | NUMBER(20,2) | TMP_CDR_STAT_SRC | FIXED_MATURE_TRAN_FIN_AMT,EXPR_AMT | SUM(FIXED_MATURE_TRAN_FIN_AMT)/SUM(EXPR_AMT)*100 |
| INSUR_CONVRS_RATE | 保险转化率 | NUMBER(20,2) | TMP_CDR_STAT_SRC | FIXED_FIN_MATURE_TRAN_INSUR_AMT,EXPR_AMT | SUM(FIXED_FIN_MATURE_TRAN_INSUR_AMT)/SUM(EXPR_AMT)*100 |
| FIN_TO_DEPO_CONVRS_RATE | 理财转存款转化率 | NUMBER(20,2) | TMP_CDR_STAT_SRC | FIN_MATURE_TRAN_FIXED_AMT,EXPR_AMT | SUM(FIN_MATURE_TRAN_FIXED_AMT)/SUM(EXPR_AMT)*100 |

### ADS_CUST_LOST_DTL

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源表 | 源字段 | 映射规则 |
|----------|----------------|--------------|------|--------|----------|
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR2(4) |  |  |  |
| DATA_DATE | 数据日期 | VARCHAR2(8) |  |  |  |
| CUST_ID | 客户编号 | VARCHAR2(20) |  |  |  |
| CUST_NAME | 客户名称 | VARCHAR2(100) |  |  |  |
| CUST_LVL | 客户等级 | VARCHAR2(2) |  |  |  |
| LVL_CHURN | 流失等级 | VARCHAR2(2) |  |  |  |
| DEPO_CURNT_DEPO_BAL | 活期余额 | NUMBER(20,2) |  |  |  |
| FIXD_DEPO_BAL | 定期余额 | NUMBER(20,2) |  |  |  |
| FIN_AMT | 理财余额 | NUMBER(20,2) |  |  |  |
| CNTCT_STATE | 接触状态 | VARCHAR2(1) |  |  |  |
| RESCUE_STATE | 挽回状态 | VARCHAR2(1) |  |  |  |
| RESCUED_FINA_ASSET | 已挽回金融资产 | NUMBER(20,2) |  |  | MAX(T-1日时点AUM-上月末时点AUM,0)，仅挽回客户计 |
| POST_ID | 管户经理 | VARCHAR2(20) |  |  |  |
| ORG_ID | 归属机构 | VARCHAR2(7) |  |  |  |
| STATIS_CYCLE | 统计周期(月/季/年) | VARCHAR2(2) |  |  |  |

### ADS_CUST_LOST_STATIS

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源表 | 源字段 | 映射规则 |
|----------|----------------|--------------|------|--------|----------|
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR2(4) |  |  |  |
| DATA_DATE | 数据日期 | VARCHAR2(8) |  |  |  |
| STATIS_OBJ | 统计对象(机构/客户经理) | VARCHAR2(20) |  |  |  |
| STATIS_CYCLE | 统计周期(月/季/年) | VARCHAR2(2) |  |  |  |
| LVL_CHURN | 流失等级 | VARCHAR2(1) |  |  |  |
| CUST_CNT | 客户数 | NUMBER(8) |  |  |  |
| CNTCT_CUST_CNT | 已接触客户 | NUMBER(8) |  |  |  |
| CNTCT_RATE | 接触率 | NUMBER(20,2) |  |  |  |
| RESCUED_CUST_CNT | 已挽回客户 | NUMBER(8) |  |  |  |
| RESCUE_RATE | 挽回率 | NUMBER(20,2) |  |  |  |
| RESCUED_FINA_ASSET | 已挽回金融资产 | NUMBER(20,2) |  |  |  |

### ADS_CUST_POTN_UPGRADE_CUST_DTL

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源表 | 源字段 | 映射规则 |
|----------|----------------|--------------|------|--------|----------|
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR2(4) |  |  |  |
| DATA_DATE | 数据日期 | VARCHAR2(8) |  |  |  |
| CUST_ID | 客户编号 | VARCHAR2(20) |  |  |  |
| CUST_NAME | 客户名称 | VARCHAR2(100) |  |  |  |
| CUST_LVL | 客户等级 | VARCHAR2(2) |  |  |  |
| LVL_CRIT | 临界等级 | VARCHAR2(2) |  |  |  |
| DEPO_CURNT_DEPO_BAL | 活期余额 | NUMBER(20,2) |  |  |  |
| FIXD_DEPO_BAL | 定期余额 | NUMBER(20,2) |  |  |  |
| FIN_AMT | 理财余额 | NUMBER(20,2) |  |  |  |
| CNTCT_STATE | 接触状态 | VARCHAR2(1) |  |  |  |
| QUAL_STATE | 达标状态 | VARCHAR2(1) |  |  |  |
| POST_ID | 管户经理 | VARCHAR2(20) |  |  |  |
| ORG_ID | 归属机构 | VARCHAR2(7) |  |  |  |
| STATIS_CYCLE | 统计周期(月/季/年) | VARCHAR2(2) |  |  |  |

### ADS_CUST_POTN_UPGRADE_STATIS

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源表 | 源字段 | 映射规则 |
|----------|----------------|--------------|------|--------|----------|
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR2(4) |  |  |  |
| DATA_DATE | 数据日期 | VARCHAR2(8) |  |  |  |
| STATIS_OBJ | 统计对象 | VARCHAR2(20) |  |  |  |
| STATIS_CYCLE | 统计周期(月/季/年) | VARCHAR2(2) |  |  |  |
| LVL_CRIT | 临界等级 | VARCHAR2(2) |  |  |  |
| TTL_CUST_CNT | 总客户数 | NUMBER(8) |  |  |  |
| MTH_AVG_QUAL_CNT | 月均达标 | NUMBER(8) |  |  |  |
| MTH_AVG_QUAL_RATE | 月均达标率 | NUMBER(20,2) |  |  |  |
| PNT_QUAL_CNT | 时点达标 | NUMBER(8) |  |  |  |
| PNT_QUAL_RATE | 时点达标率 | NUMBER(20,2) |  |  |  |
| CNTCT_CUST_CNT | 已接触客户 | NUMBER(8) |  |  |  |
| CNTCT_RATE | 接触率 | NUMBER(20,2) |  |  |  |

### ADS_CUST_NEW_CUST_DTL

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源表 | 源字段 | 映射规则 |
|----------|----------------|--------------|------|--------|----------|
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR2(4) |  |  |  |
| DATA_DATE | 数据日期 | VARCHAR2(8) |  |  |  |
| CUST_ID | 客户编号 | VARCHAR2(20) |  |  |  |
| CUST_NAME | 客户名称 | VARCHAR2(100) |  |  |  |
| CUST_LVL | 客户等级 | VARCHAR2(2) |  |  |  |
| NEW_CUST_CYCLE | 新客周期 | VARCHAR2(1) |  |  |  |
| DEPO_CURNT_DEPO_BAL | 活期余额 | NUMBER(20,2) |  |  |  |
| FIXD_DEPO_BAL | 定期余额 | NUMBER(20,2) |  |  |  |
| FIN_AMT | 理财余额 | NUMBER(20,2) |  |  |  |
| CNTCT_STATE | 接触状态 | VARCHAR2(1) |  |  |  |
| KYC_STATE | KYC状态 | VARCHAR2(1) |  |  |  |
| POST_ID | 管户经理 | VARCHAR2(20) |  |  |  |
| ORG_ID | 归属机构 | VARCHAR2(7) |  |  |  |
| STATIS_CYCLE | 统计周期(月/季/年) | VARCHAR2(2) |  |  |  |

### ADS_CUST_NEW_CUST_STATIS

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源表 | 源字段 | 映射规则 |
|----------|----------------|--------------|------|--------|----------|
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR2(4) |  |  |  |
| DATA_DATE | 数据日期 | VARCHAR2(8) |  |  |  |
| STATIS_OBJ | 统计对象 | VARCHAR2(20) |  |  |  |
| STATIS_CYCLE | 统计周期(月/季/年) | VARCHAR2(2) |  |  |  |
| NEW_CUST_CYCLE | 新客周期 | VARCHAR2(1) |  |  |  |
| NEW_CUST_CNT | 新客数 | NUMBER(8) |  |  |  |
| CNTCT_CUST_CNT | 已接触客户 | NUMBER(8) |  |  |  |
| ASSET_BAL_SEG1_CUST_CNT | 资产余额区间1客户数 | NUMBER(8) |  |  |  |
| ASSET_BAL_SEG2_CUST_CNT | 资产余额区间2客户数 | NUMBER(8) |  |  |  |
| ASSET_BAL_SEG3_CUST_CNT | 资产余额区间3客户数 | NUMBER(8) |  |  |  |
| ASSET_BAL_SEG4_CUST_CNT | 资产余额区间4客户数 | NUMBER(8) |  |  |  |
| ASSET_BAL_SEG5_CUST_CNT | 资产余额区间5客户数 | NUMBER(8) |  |  |  |
| CNTCT_RATE | 接触率 | NUMBER(20,2) |  |  |  |
| KYC_CUST_CNT | KYC客户 | NUMBER(8) |  |  |  |
| COMP_RATE | 完成率 | NUMBER(20,2) |  |  |  |

### ADS_CUST_SLEEP_WAKE_DTL

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源表 | 源字段 | 映射规则 |
|----------|----------------|--------------|------|--------|----------|
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR2(4) |  |  |  |
| DATA_DATE | 数据日期 | VARCHAR2(8) |  |  |  |
| CUST_ID | 客户编号 | VARCHAR2(20) |  |  |  |
| CUST_NAME | 客户名称 | VARCHAR2(100) |  |  |  |
| CUST_LVL | 客户等级 | VARCHAR2(2) |  |  |  |
| DEPO_CURNT_DEPO_BAL | 活期余额 | NUMBER(20,2) |  |  |  |
| FIXD_DEPO_BAL | 定期余额 | NUMBER(20,2) |  |  |  |
| FIN_AMT | 理财余额 | NUMBER(20,2) |  |  |  |
| CNTCT_STATE | 接触状态 | VARCHAR2(1) |  |  |  |
| WAKE_STATE | 唤醒状态 | VARCHAR2(1) |  |  |  |
| POST_ID | 管户经理 | VARCHAR2(20) |  |  |  |
| ORG_ID | 归属机构 | VARCHAR2(7) |  |  |  |
| STATIS_CYCLE | 统计周期(月/季/年) | VARCHAR2(2) |  |  |  |

### ADS_CUST_SLEEP_WAKE_STATIS

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源表 | 源字段 | 映射规则 |
|----------|----------------|--------------|------|--------|----------|
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR2(4) |  |  |  |
| DATA_DATE | 数据日期 | VARCHAR2(8) |  |  |  |
| STATIS_OBJ | 统计对象 | VARCHAR2(20) |  |  |  |
| STATIS_CYCLE | 统计周期(月/季/年) | VARCHAR2(2) |  |  |  |
| CUST_CNT | 客户数 | NUMBER(8) |  |  |  |
| CNTCT_CUST_CNT | 已接触客户 | NUMBER(8) |  |  |  |
| CNTCT_RATE | 接触率 | NUMBER(20,2) |  |  |  |
| WAKE_CUST_CNT | 已唤醒客户 | NUMBER(8) |  |  |  |
| WAKE_RATE | 唤醒率 | NUMBER(20,2) |  |  |  |

### ADS_MKT_REC_INFO

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源表 | 源字段 | 映射规则 |
|----------|----------------|--------------|------|--------|----------|
| MKT_REC_SEQ_ID | 营销记录流水号 | VARCHAR2 |  |  |  |
| REL_ID | 关联ID(商机ID、客户群ID/营销活动ID) | VARCHAR2 |  |  |  |
| MKT_TYP | 营销类型(1面访/2电话/3短信/4企微) | VARCHAR2 |  |  |  |
| REL_TYP | 关联类型(客户群/商机/营销活动) | VARCHAR2 |  |  |  |
| CUST_ID | 客户ID | VARCHAR2 |  |  |  |
| CUST_NAME | 客户名称 | VARCHAR2 |  |  |  |
| MKT_SITE | 营销地点 | VARCHAR2 |  |  |  |
| MKT_TIME | 营销时间 | VARCHAR2 |  |  |  |
| MKT_PERSN | 营销人ID | VARCHAR2 |  |  |  |
| MKT_PERSN_NAME | 营销人名称 | VARCHAR2 |  |  |  |
| MKT_ORG | 营销机构 | VARCHAR2 |  |  |  |
| MKT_DURA | 营销时长 | VARCHAR2 |  |  |  |
| MKT_DTL_SITU | 营销详细情况 | VARCHAR2 |  |  |  |
| MKT_APDIX_ID | 营销附件ID(录音/图片) | VARCHAR2 |  |  |  |
| TEMP_ID | 模板ID | VARCHAR2 |  |  |  |
| TEMP_NAME | 模板名称 | VARCHAR2 |  |  |  |
| MSG_SHORT_SEQ_ID | 短信流水号 | VARCHAR2 |  |  |  |
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR2 |  |  |  |
| CORDNAT_VISITOR | 协同拜访人 | VARCHAR2 |  |  |  |
| CORDNAT_VISITOR_NAME | 协同拜访人名称 | VARCHAR2 |  |  |  |
| LGTUD | 经度 | VARCHAR2 | DWD_SYS_ORG | ORG_LGTUD |  |
| LATTUD | 纬度 | VARCHAR2 | DWD_SYS_ORG | ORG_LATTUD |  |
| TEL_NO | 联系电话 | VARCHAR2 |  |  |  |
| CHNL_NO | 渠道编号 | VARCHAR2 |  |  |  |
| RMARK | 备注 | VARCHAR2 |  |  |  |
| NO_BAT | 批次号 | VARCHAR2 |  |  |  |
| MSG_SHORT_INF | 短信内容 | VARCHAR2 |  |  |  |

### ADS_CUST_PRDKT_RCMD

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源表 | 源字段 | 映射规则 |
|----------|----------------|--------------|------|--------|----------|
| DATA_DATE | 数据日期 | VARCHAR2 |  |  |  |
| CUST_ID | 客户编号 | VARCHAR2 |  |  |  |
| PRDKT_ID | 产品编号 | VARCHAR2 |  |  |  |
| PRDKT_NAME | 产品名称 | VARCHAR2 |  |  |  |
| MATCH_DEG_PRDKT | 产品匹配度 | NUMBER |  |  |  |
| PRDKT_TYP | 产品类型 | VARCHAR2 |  |  |  |
| RATE_INTRI | 利率或预期收益率 | NUMBER |  |  |  |
| RISK_LVL | 风险等级 | VARCHAR2 |  |  |  |
| MKT_SCRIPT | 营销话术 | VARCHAR2 |  |  |  |

### ADS_CUST_OTHERS_RMND

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源表 | 源字段 | 映射规则 |
|----------|----------------|--------------|------|--------|----------|
| RMND_ID | 提醒ID | VARCHAR2 |  |  |  |
| RMND_CATE_BIG | 提醒类型(1-贷款逾期提醒,2-贷款欠息提醒,3-贷款还款余额不足提醒,4-收单商户长期无交易提醒,5-销户提醒,6-客户分配,7-客户回收,8-客户移交,9-客户调配) | VARCHAR2 |  |  |  |
| RMND_CATE_SML | 提醒名称 | VARCHAR2 |  |  |  |
| MNGR_POST_ID | 客户经理编号 | VARCHAR2 |  |  |  |
| MNGR_NAME | 客户经理名称 | VARCHAR2 |  |  |  |
| ORG_ID | 机构编号 | VARCHAR2 |  |  |  |
| CUST_TYP | 客户类型 | VARCHAR2 |  |  |  |
| CUST_ID | 客户ID | VARCHAR2 |  |  |  |
| CUST_NAME | 客户名称 | VARCHAR2 |  |  |  |
| PHONE_NO | 手机号 | VARCHAR2 |  |  |  |
| RMND_INF | 提醒内容 | VARCHAR2 |  |  |  |
| HDLE_STATE | 处理状态(0未读 1已读) | VARCHAR2 |  |  |  |
| RMND_DATE | 提醒日期 | VARCHAR2 |  |  |  |
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR2 |  |  |  |
| HDLE_TIME | 处理时间 | VARCHAR2 |  |  |  |
| DEL_FLG | 删除标志 | VARCHAR2 |  |  |  |
| HDLE_DSC | 处理说明 | VARCHAR2 |  |  |  |

### ADS_CRM_R_CUST_LABLE

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源表 | 源字段 | 映射规则 |
|----------|----------------|--------------|------|--------|----------|
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR2 |  |  |  |
| CUST_ID | 核心客户号 | VARCHAR2 |  |  |  |
| CUST_NAME | 客户名称 | VARCHAR2 |  |  |  |
| CERT_TYP | 证件类型 | VARCHAR2 |  |  |  |
| CERT_ID | 证件号码 | VARCHAR2 |  |  |  |
| GEND | 性别 | VARCHAR2 |  |  |  |
| AGE | 年龄 | NUMBER |  |  |  |
| NATION | 民族 | VARCHAR2 |  |  |  |
| MARI_SITU | 婚姻状况 | VARCHAR2 |  |  |  |
| PHONE_NO | 手机号码 | VARCHAR2 |  |  |  |
| MAX_DEG_EDU | 最高学历 | VARCHAR2 |  |  |  |
| OCCU_CLS | 职业分类 | VARCHAR2 |  |  |  |
| HOST_CUST_MNGR_POST_ID | 主办客户经理职位编号 | VARCHAR2 |  |  |  |
| HOST_CUST_MNGR_NAME | 主办客户经理名称 | VARCHAR2 |  |  |  |
| HOST_CUST_MNGR_EMP_ID | 主办客户经理工号 | VARCHAR2 |  |  |  |
| ORG_LEAD | 主办机构(归属机构) | VARCHAR2 |  |  |  |
| ORG_LEAD_PATH | 主办机构路径 | VARCHAR2 |  |  |  |
| COSPSR_CUST_MNGR_POST_ID | 信贷客户经理职位编号 | VARCHAR2 |  |  |  |
| COSPSR_CUST_MNGR_NAME | 信贷客户经理名称 | VARCHAR2 |  |  |  |
| COSPSR_CUST_MNGR_EMP_ID | 信贷客户经理工号 | VARCHAR2 |  |  |  |
| COSPSR_ORG | 信贷机构 | VARCHAR2 |  |  |  |
| COSPSR_ORG_PATH | 信贷机构路径 | VARCHAR2 |  |  |  |
| IS_NOT_INDIV_BIZ_ACCT | 是否一码付商户 | VARCHAR2 |  |  |  |
| IS_NOT_MINOR_ENTER_MAIN | 是否小微企业主 | VARCHAR2 |  |  |  |
| NEAR_YR_HF_AVG_MTH_INCOM | 近半年月均收入 | NUMBER |  |  |  |
| INDIV_ESTIM_YR_INCOM | 个人年收入 | NUMBER |  |  |  |
| FUND_ACUM_DEPO_NUM_BASE | 公积金缴存基数 | NUMBER |  |  |  |
| SOCIAL_WELF_PAY_NUM_BASE | 社保缴存基数 | NUMBER |  |  |  |
| IS_NOT_PURE_NEW_CUST | 纯新户开户标志 | VARCHAR2 |  |  |  |
| IS_NOT_BK_SELF_EMP | 是否本行员工 | VARCHAR2 |  |  |  |
| IS_NOT_SLEEP_ACCT | 是否睡眠户 | VARCHAR2 |  |  |  |
| CUST_HRAKY | 客户层级 | VARCHAR2 |  |  |  |
| CUST_LVL | 客户等级 | VARCHAR2 |  |  |  |
| LIFE_CYC | 生命周期 | VARCHAR2 |  |  |  |
| AUM | AUM余额 | NUMBER |  |  |  |
| AUM_MTH_AVG | AUM月日均 | NUMBER |  |  |  |
| AUM_QRT_AVG | AUM季日均 | NUMBER |  |  |  |
| AUM_YR_AVG | AUM年日均 | NUMBER |  |  |  |
| IS_NOT_DEPO | 是否持有存款产品 | CHAR |  |  |  |
| DEPO_BAL | 存款余额 | NUMBER |  |  |  |
| DEPO_MTH_AVG | 存款月日均 | NUMBER |  |  |  |
| DEPO_QRT_AVG | 存款季日均 | NUMBER |  |  |  |
| DEPO_YR_AVG | 存款年日均 | NUMBER |  |  |  |
| DEPO_CURNT_DEPO_BAL | 活期存款余额 | NUMBER |  |  |  |
| DEPO_CURNT_DEPO_BAL_MTH_CURNT_AVG_DAY | 活期存款日均余额 | NUMBER |  |  |  |
| IS_NOT_HIST_FIXD_DEPO_FLAG | 是否历史持有定期存款产品 | VARCHAR2 |  |  |  |
| IS_NOT_FIXD_DEPO | 是否持有定期存款产品 | VARCHAR2 |  |  |  |
| FIX_DEPO_BAL | 定期存款余额 | NUMBER |  |  |  |
| FIX_DEPO_MTH_AVG | 定期存款月日均 | NUMBER |  |  |  |
| FIX_DEPO_QRT_AVG | 定期存款季日均 | NUMBER |  |  |  |
| FIX_DEPO_YR_AVG | 定期存款年日均 | NUMBER |  |  |  |
| IS_NOT_HIST_LUMPSUM_FIXD_FLAG | 是否历史持有整存整取定期存款 | VARCHAR2 |  |  |  |
| IS_NOT_LUMPSUM_FIXD | 是否持有整存整取定期存款 | VARCHAR2 |  |  |  |
| LUMPSUM_FIXD_DEPO_BAL | 整存整取定期存款余额 | NUMBER |  |  |  |
| IS_NOT_HIST_LEHUI_FLAG | 是否历史持有乐惠存产品 | VARCHAR2 |  |  |  |
| IS_NOT_LEHUI | 是否持有乐惠存产品 | VARCHAR2 |  |  |  |
| LEHUI_BAL | 乐惠存产品余额 | NUMBER |  |  |  |
| LEHUI_MTH_AVG_DAY | 乐惠存产品月日均余额 | NUMBER |  |  |  |
| RCNT_FIXD_DEPO_MATURE_DAYS | 最近一笔定期存款到期天数 | NUMBER |  |  |  |
| RCNT_FIXD_DEPO_MATURE_AMT | 最近一笔定期存款到期金额 | NUMBER |  |  |  |
| IS_NOT_HIST_LARGEDP_FLAG | 是否历史持有大额存单 | VARCHAR2 |  |  |  |
| IS_NOT_LARGEDP | 是否持有大额存单 | VARCHAR2 |  |  |  |
| LARGEDP_BAL | 大额存单余额 | NUMBER |  |  |  |
| LARGEDP_MTH_AVG_DAY | 大额存单月日均余额 | NUMBER |  |  |  |
| IS_NOT_FIN_CTRAKT | 是否理财签约 | VARCHAR2 |  |  |  |
| IS_NOT_HIST_FIN_FLAG | 是否历史持有理财产品 | VARCHAR2 |  |  |  |
| IS_NOT_FIN | 是否持有理财产品 | VARCHAR2 |  |  |  |
| RCNT_FIN_MATURE_DAYS | 最近一笔理财到期天数 | NUMBER |  |  |  |
| RCNT_FIN_MATURE_AMT | 最近一笔理财到期金额 | NUMBER |  |  |  |
| FIN_AMT | 理财余额 | NUMBER |  |  |  |
| FIN_MTH_AVG | 理财月日均 | NUMBER |  |  |  |
| FIN_QRT_AVG | 理财季日均 | NUMBER |  |  |  |
| FIN_YR_AVG | 理财年日均 | NUMBER |  |  |  |
| IS_NOT_HIST_OPEN_FIN_FLAG | 是否历史持有开放式理财产品 | VARCHAR2 |  |  |  |
| IS_NOT_OPEN_FIN | 是否持有开放式理财产品 | VARCHAR2 |  |  |  |
| OPEN_FIN_BAL | 开放式理财产品余额 | NUMBER |  |  |  |
| OPEN_FIN_MTH_AVG_DAY | 开放式理财产品月日均余额 | NUMBER |  |  |  |
| IS_NOT_HIST_CLOSE_FIN_FLAG | 是否历史持有封闭式理财产品 | VARCHAR2 |  |  |  |
| IS_NOT_CLOSE_FIN | 是否持有封闭式理财产品 | VARCHAR2 |  |  |  |
| CLOSE_FIN_BAL | 封闭式理财产品余额 | NUMBER |  |  |  |
| CLOSE_FIN_MTH_AVG_DAY | 封闭式理财产品月日均余额 | NUMBER |  |  |  |
| IS_NOT_HIST_AGT_FIN_FLAG | 是否历史持有代销理财产品 | VARCHAR2 |  |  |  |
| IS_NOT_AGT_FIN | 是否持有代销理财产品 | VARCHAR2 |  |  |  |
| AGT_FIN_BAL | 代销理财产品余额 | NUMBER |  |  |  |
| AGT_FIN_MTH_AVG_DAY | 代销理财产品月日均余额 | NUMBER |  |  |  |
| IS_NOT_LOAN_CUST | 是否贷款客户 | VARCHAR2 |  |  |  |
| IS_NOT_HIST_LOAN_FLAG | 是否历史贷款客户 | VARCHAR2 |  |  |  |
| LOAN_BAL | 贷款余额 | NUMBER |  |  |  |
| IS_NOT_PAYROL_BK | 是否代发户 | VARCHAR2 |  |  |  |
| IS_NOT_SALRY_PAYROL_BK | 是否代发工资客户 | VARCHAR2 |  |  |  |
| BK_SALRY_AMT_MTH_LAST | 上月代发工资金额 | NUMBER |  |  |  |
| RCNT_TIME_ONE_PAYROL_BK_SALRY_DATE | 最近一次代发工资日期 | DATE |  |  |  |
| PAYROL_BK_SALRY_AMT | 最近一次代发工资金额 | NUMBER |  |  |  |
| PAYROL_SALRY_TTL | 代发工资累计金额 | NUMBER |  |  |  |
| CONTI_PAYROL_BK_MTHS | 连续稳定代发工资月数 | NUMBER |  |  |  |
| DCARD_TYPE | 借记卡类型 | VARCHAR2 |  |  |  |
| IS_NOT_BK_SELF_SSCARD | 是否我行社保卡 | CHAR |  |  |  |
| IS_NOT_BK_SELF_CGZJ | 是否我行川工之家客户 | CHAR |  |  |  |
| CGZJ_ACCT_WELF_BAL | 川工之家账户福利资金余额 | NUMBER |  |  |  |
| IS_NOT_SELF_REG_MBANK | 是否自助注册手机银行 | CHAR |  |  |  |
| IS_NOT_KTER_CTRAKT_MBANK | 是否柜面签约手机银行 | CHAR |  |  |  |
| NEAR_MTH_TX_CNT | 近1月累计交易笔数 | NUMBER |  |  |  |
| NEAR_MTH_TX_AMT | 近1月累计交易金额 | NUMBER |  |  |  |
| NEAR_MTH_MBANK_TX_CNT | 近1月手机银行累计交易笔数 | NUMBER |  |  |  |
| NEAR_MTH_MBANK_TX_AMT | 近1月手机银行累计交易金额 | NUMBER |  |  |  |
| NEAR_MTH_MBANK_TX_AMT_BK_OUTER | 近1月手机银行行外入账金额 | NUMBER |  |  |  |
| IS_NOT_SFZF | 是否签约三方支付 | CHAR |  |  |  |
| NEAR_MTH_THIRD_PAY_OUT_CNT | 近1月第三方支付累计转出笔数 | NUMBER |  |  |  |
| NEAR_MTH_THIRD_PAY_OUT_AMT | 近1月第三方支付累计转出金额 | NUMBER |  |  |  |
| IS_NOT_BILL_RSV_MINOR_MKNT | 是否收单商户小微商户 | CHAR |  |  |  |
| IS_NOT_BILL_RSV_INDIV_MKNT | 是否收单商户个体商户 | CHAR |  |  |  |
| BILL_RSV_MKNT_CNT_MTH_LAST | 收单商户上月交易笔数 | NUMBER |  |  |  |
| BILL_RSV_MKNT_AMT_MTH_LAST | 收单商户上月交易金额 | NUMBER |  |  |  |
| IS_NOT_BILL_RSV_VAL_MKNT | 是否收单价值商户 | CHAR |  |  |  |
| IS_NOT_BK_SELF_FUND_PASS_BY_ACCT | 是否我行资金过路户 | CHAR |  |  |  |
| IS_NOT_RGLAR_TRANS_BK_OTHER_SAMENAME | 是否向他行同名户规律转出 | CHAR |  |  |  |
| MBANK_CONTI_LOGIN_DAYS | 连续登录手机银行天数 | NUMBER |  |  |  |
| IS_NOT_BK_PHONE_ACTV_CUST | 是否手机银行活跃客户 | CHAR |  |  |  |
| IS_NOT_BK_SELF_LOAN_DUE_OVER_CUST | 行内贷款是否逾期 | CHAR |  |  |  |
| NEAR_24MTH_OVERDUE_FLAG | 行内近24月内是否存在贷款逾期 | CHAR |  |  |  |
| CRDT_DUE_OVER_CNT | 征信逾期次数 | NUMBER |  |  |  |
| EXIST_BADLOAN_REC | 征信是否存在不良贷款记录 | CHAR |  |  |  |
| IS_NOT_INSUR | 是否持有保险产品 | CHAR |  |  |  |
| INSUR_FRST_PREM_AMT | 保险产品首期保费 | NUMBER |  |  |  |
| INSUR_BAL | 保险余额 | NUMBER |  |  |  |
| INSUR_MTH_AVG | 保险月日均 | NUMBER |  |  |  |
| INSUR_QRT_AVG | 保险季日均 | NUMBER |  |  |  |
| INSUR_YR_AVG | 保险年日均 | NUMBER |  |  |  |
| NEAR_3_MTH_MIN_BENEFIT_LVL | 近三个月最低权益等级 | VARCHAR2 |  |  |  |
| NEAR_6_MTH_MIN_BENEFIT_LVL | 近六个月最低权益等级 | VARCHAR2 |  |  |  |
| NEAR_9_MTH_MIN_BENEFIT_LVL | 近九个月最低权益等级 | VARCHAR2 |  |  |  |
| NEAR_12_MTH_MIN_BENEFIT_LVL | 近十二个月最低权益等级 | VARCHAR2 |  |  |  |
| IS_NOT_YR_FRST_LVL_UPG_CUST | 是否当年首次等级升级客户 | CHAR |  |  |  |
| FRST_UPG_CUST_UPG_LVL | 首次升级客户升级等级 | VARCHAR2 |  |  |  |
| IS_NOT_YR_LVL_DWN_CUST | 是否当年等级降级客户 | CHAR |  |  |  |
| DWN_CUST_LVL_BF_AF | 降级客户降级前后等级 | VARCHAR2 |  |  |  |
| IS_NOT_HIGH_WORTH_CRIT_CUST | 是否为高净值临界客户 | CHAR |  |  |  |
| IS_NOT_MBANK_BIND_CARD | 是否登录手机银行并完成绑卡客户 | CHAR |  |  |  |
| REG_LOGIN_BK_PHONE_CUST_DAYS | 注册并登录手机银行客户的天数 | NUMBER |  |  |  |
| MTH_LOGIN_MBANK_CNT | 当月登录手机银行次数 | NUMBER |  |  |  |
| IS_NOT_3RD_PAY_BIND_CARD_DONE | 是否完成三方支付绑卡 | CHAR |  |  |  |
| YR_CAMPUS_PAY_CNT | 当年校园缴费笔数 | NUMBER |  |  |  |
| YR_HOT_ACTV_CNT | 当年参与热门活动次数 | NUMBER |  |  |  |
| MTH_UTIL_PAY_TRAN_AMT | 当月完成水电气缴费交易金额 | NUMBER |  |  |  |
| MTH_UTIL_PAY_TRAN_CNT | 当月完成水电气缴费交易笔数 | NUMBER |  |  |  |
| TRAN_CHAN_PREF | 交易渠道偏好 | VARCHAR2 |  |  |  |
| IS_NOT_WECHAT_TRAN_MTH_ACTIVE | 是否为微信绑卡交易月活跃客户 | CHAR |  |  |  |
| PRDKT_PREF | 储蓄产品偏好 | VARCHAR2 |  |  |  |
| VERIFIED_BADGE | 企微客户认证标志 | VARCHAR2 |  |  |  |
| DEPO_TERM_PREF | 储蓄产品期限偏好 | VARCHAR2 |  |  |  |
| IS_NOT_WB_LOAN | 是否微粒贷客户 | VARCHAR2 |  |  |  |
| IS_NOT_MT_LOAN | 是否美团贷款客户 | VARCHAR2 |  |  |  |
| ORG_PATH | 机构路径 | VARCHAR2 |  |  |  |
| CONTR_AMT | 总合同额度 | NUMBER |  |  |  |
| DCARD_LVL | 借记卡等级 | VARCHAR2 |  |  |  |

---

*本文件由对应 Excel 模型同步生成；Excel 更新后必须重新生成本文件。
