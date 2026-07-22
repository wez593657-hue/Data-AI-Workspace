# DWS到ADS映射 字段映射

## 映射来源

- Excel：`data_assets/mapping/dws_to_ads/ADS应用层数据模型_CRM_ V1.0.xlsx`
- Excel SHA-256：`d757dfb4462f26c413547c62d51720e81fbc47eb85e1cd258546281487faeab7`

## 映射概览

| 目标表 | 字段数 |
|--------|-------:|
| ADS_CUST_DEADLINE_RMND_DTL | 25 |
| ADS_CUST_DEADLINE_RMND_STATIS | 15 |
| ADS_CUST_INDV_POTEN | 30 |
| ADS_CUST_LOST_DTL | 14 |
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
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR2(4) |  |  |  |
| DATA_DATE | 数据日期 | VARCHAR2(8) |  |  |  |
| CUST_ID | 客户编号 | VARCHAR2(20) |  |  |  |
| CUST_NAME | 客户名称 | VARCHAR2(100) |  |  |  |
| CUST_LVL | 客户等级 | VARCHAR2(2) |  |  |  |
| DEPO_CURNT_DEPO_BAL | 活期余额 | NUMBER(20,2) |  |  |  |
| FIXD_DEPO_BAL | 定期余额 | NUMBER(20,2) |  |  |  |
| FIN_AMT | 理财余额 | NUMBER(20,2) |  |  |  |
| STAT_PERD | 统计周期 | VARCHAR2(2) |  |  |  |
| STATIS_TYP | 承接类型1-存款2-理财 | VARCHAR2(2) |  |  |  |
| EXPR_AMT | 到期金额 | NUMBER(20,2) |  |  |  |
| MATURE_TTL_AMT | 到期总金额 | NUMBER(20,2) |  |  |  |
| TAKE_RATE | 承接率 | NUMBER(10,2) |  |  |  |
| FIX_DEPO_MATURE_AMT | 定期存款到期金额 | NUMBER(20,2) |  |  |  |
| FIX_DEPO_MATURE_TTL_AMT | 定期存款到期总金额 | NUMBER(20,2) |  |  |  |
| FIX_DEPO_TAKE_RATE | 定期存款承接率 | NUMBER(10,2) |  |  |  |
| CNTCT_STATE | 接触状态 | VARCHAR2(1) |  |  |  |
| UNDTAKE_STATE | 承接状态 | VARCHAR2(1) |  |  |  |
| FIXED_FIN_MATURE_TRAN_INSUR_AMT | 定期理财到期转保险金额 | NUMBER(20,2) |  |  |  |
| FIN_MATURE_TRAN_FIXED_AMT | 理财到期转定期金额 | NUMBER(20,2) |  |  |  |
| FIXED_MATURE_TRAN_FIN_AMT | 定期到期转理财金额 | NUMBER(20,2) |  |  |  |
| FRST_MATURE_PK_BF_DAY_AUM_BAL | 本期第一笔到期产品前一日AUM余额 | NUMBER(20,2) |  |  |  |
| LAST_END_DATE | 本期最后一笔到期产品日期 | VARCHAR2(8) |  |  |  |
| POST_ID | 管户经理 | VARCHAR2(20) |  |  |  |
| ORG_ID | 归属机构 | VARCHAR2(7) |  |  |  |

### ADS_CUST_DEADLINE_RMND_STATIS

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源表 | 源字段 | 映射规则 |
|----------|----------------|--------------|------|--------|----------|
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR2(4) |  |  |  |
| DATA_DATE | 数据日期 | VARCHAR2(8) |  |  |  |
| STATIS_OBJ | 统计对象 | VARCHAR2(20) |  |  |  |
| STATIS_CYCLE | 统计周期 | VARCHAR2(2) |  |  |  |
| STATIS_TYP | 承接类型1-存款2-理财 | VARCHAR2(2) |  |  |  |
| EXPR_CUST_CNT | 已到期客户数 | NUMBER(8) |  |  |  |
| TTL_EXPR_CUST_CNT | 总到期客户数 | NUMBER(8) |  |  |  |
| EXPR_AMT | 已到期金额 | NUMBER(20,2) |  |  |  |
| TTL_EXPR_AMT | 总到期金额 | NUMBER(20,2) |  |  |  |
| CUST_UNDTAKE_RATE | 客户承接率 | NUMBER(20,2) |  |  |  |
| ASSET_KEEP_RATE | 资产留存率 | NUMBER(20,2) |  |  |  |
| ASSET_UNDTAKE_RATE | 资产承接率 | NUMBER(20,2) |  |  |  |
| DEPO_TO_FIN_CONVRS_RATE | 存款转理财转化率 | NUMBER(20,2) |  |  |  |
| INSUR_CONVRS_RATE | 保险转化率 | NUMBER(20,2) |  |  |  |
| FIN_TO_DEPO_CONVRS_RATE | 理财转存款转化率 | NUMBER(20,2) |  |  |  |

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

---

*本文件由对应 Excel 模型同步生成；Excel 更新后必须重新生成本文件。
