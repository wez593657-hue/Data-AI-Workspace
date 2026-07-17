# DWS到ADS映射 字段映射

## 映射概览

| 目标表 | 目标表中文名 | 源表 | 源表中文名 |
|--------|-------------|------|------------|

## 字段映射详情

### ADS_CUST_INDV_POTEN (零售潜在客户信息)

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源系统 | 源表 | 源字段 | 映射规则 |
|----------|---------------|--------------|--------|------|--------|----------|
| POTEN_CUST_ID | 潜在客户号(自增键) | VARCHAR2(40) | - | - |  | - |
| POTEN_CUST_NAME | 潜在客户名称 | VARCHAR2(100) | - | - |  | - |
| POTEN_TYP | 潜客类型 | VARCHAR2(6) | - | - |  | - |
| POTEN_CUST_TYP | 潜在客户类型 | VARCHAR2(6) | - | - |  | - |
| GENDER | 性别 | VARCHAR2(6) | - | - |  | - |
| CERT_TYP | 证件类型 | VARCHAR2(6) | - | - |  | - |
| CERT_ID | 证件号码 | VARCHAR2(32) | - | - |  | - |
| TEL_NO | 联系电话 | VARCHAR2(32) | - | - |  | - |
| INTENT_DSC | 备注说明 | VARCHAR2(400) | - | - |  | - |
| DTL_ADDRS | 居住地址 | VARCHAR2(400) | - | - |  | - |
| CREATR | 创建人 | VARCHAR2(20) | - | - |  | - |
| CREAT_TIME | 创建时间 | VARCHAR2(20) | - | - |  | - |
| POTEN_CUST_STATE | 潜在客户状态 | VARCHAR2(6) | - | - |  | - |
| LPR_ID | 法人行号 | VARCHAR2(4) | - | - |  | - |
| SRC_TYP | 来源类型 | VARCHAR2(6) | - | - |  | - |
| MKT_PERSN | 客户经理 | VARCHAR2(20) | - | - |  | - |
| ALLO_DATE | 分配日期(创建时和创建日期一致) | VARCHAR2(8) | - | - |  | - |
| MKT_ORG | 归属机构 | VARCHAR2(6) | - | - |  | - |
| SERV_ENTER | 工作单位 | VARCHAR2(200) | - | - |  | - |
| POST | 职位 | VARCHAR2(6) | - | - |  | - |
| MTH_INCOM | 月收入 | NUMBER(20,2) | - | - |  | - |
| YR_INCOM | 年收入 | NUMBER(20,2) | - | - |  | - |
| RMARK | 备注 | VARCHAR2(400) | - | - |  | - |
| INF_KLKT_DATE | 潜客转化日期 | VARCHAR2(10) | - | - |  | - |
| UNIT_ADDRS | 工作单位地址 | VARCHAR2(200) | - | - |  | - |
| INTN_PRDKT | 意向产品 | VARCHAR2(60) | - | - |  | - |
| NO_BAT | 批次号 | VARCHAR2(40) | - | - |  | - |
| CUST_ID | 转化后核心客户号 | VARCHAR2(21) | - | - |  | - |
| POT_CNVRT_PRDKT | 潜客转化产品 | VARCHAR2(60) | - | - |  | - |
| POT_CNVRT_ORG | 潜客转化机构 | VARCHAR2(6) | - | - |  | - |

### ADS_MKT_TASK_INDX_SUB_CMPLT (指标任务完成情况)

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源系统 | 源表 | 源字段 | 映射规则 |
|----------|---------------|--------------|--------|------|--------|----------|
| TSK_INDX_ID | 指标任务映射编号 | VARCHAR2(40) | - | - |  | - |
| TSK_ID | 任务编号 | VARCHAR2(40) | - | - |  | - |
| MAIN_TSK_ID | 主任务编号 | VARCHAR2(40) | - | - |  | - |
| INDX_ID | 指标ID | VARCHAR2(40) | - | - |  | - |
| TSK_NEXT_SEND_TYP | 任务下发类型(0总行下发,1分行/区行下发,2支行下发) | VARCHAR2(6) | - | - |  | - |
| RSV_OBJ | 接收对象0机构1客户经理 | VARCHAR2(6) | - | - |  | - |
| RSV_OBJ_ID | 接收对象ID | VARCHAR2(30) | - | - |  | - |
| TSK_BGN_DATE | 任务开始时间 | VARCHAR2(10) | - | - |  | - |
| TSK_END_DATE | 任务结束时间 | VARCHAR2(10) | - | - |  | - |
| INDX_UNIT | 指标单位(万元/个数/百分比) | VARCHAR2(20) | - | - |  | - |
| INDX_VAL | 指标额 | NUMBER(18,4) | - | - |  | - |
| INDX_VAL_ADD | 指标加码 | NUMBER(18,4) | - | - |  | - |
| ACUM_CMPLT_INDX | 累计完成指标 | NUMBER(18,4) | - | - |  | - |
| DAY_CURNT_CMPLT_INDX | 当天完成指标 | NUMBER(18,4) | - | - |  | - |
| BASE_VAL | 基准值 | NUMBER(18,4) | - | - |  | - |
| CURNT_VAL | 当前值 | NUMBER(18,4) | - | - |  | - |
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR2(30) | - | - |  | - |

### ADS_MKT_TSK_INFO (营销任务表)

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源系统 | 源表 | 源字段 | 映射规则 |
|----------|---------------|--------------|--------|------|--------|----------|
| MKT_TSK_ID | 营销任务编号 | VARCHAR2(40) | - | - |  | - |
| MKT_ACT_ID | 活动编号 | VARCHAR2(40) | - | - |  | - |
| CUST_ID | 客户编号 | VARCHAR2(21) | - | - |  | - |
| CUST_NAME | 客户名称 | VARCHAR2(200) | - | - |  | - |
| COVER_FLG | 是否接触 | VARCHAR2(1) | - | - |  | - |
| CONVRS_FLG | 是否成功 | VARCHAR2(1) | - | - |  | - |
| MKT_PERSN | 营销人 | VARCHAR2(30) | - | - |  | - |
| MKT_PERSN_ORG | 营销人机构 | VARCHAR2(30) | - | - |  | - |
| CREATR | 创建人 | VARCHAR2(64) | - | - |  | - |
| CREAT_TIME | 创建时间 | VARCHAR2(20) | - | - |  | - |
| CREAT_ORG | 创建机构 | VARCHAR2(30) | - | - |  | - |
| BASE_VAL | 基数 | NUMBER(18,4) | - | - |  | - |
| CURNT_VAL | 当前值 | NUMBER(18,4) | - | - |  | - |
| DATA_DATE | 数据日期 | VARCHAR2(30) | - | - |  | - |
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR2(30) | - | - |  | - |
| ACT_DSC | 备注 | VARCHAR2(2000) | - | - |  | - |

### ADS_MKT_ACT_TSK_MON (营销活动任务监控)

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源系统 | 源表 | 源字段 | 映射规则 |
|----------|---------------|--------------|--------|------|--------|----------|
| DATA_DATE | 数据日期 | VARCHAR2(8) | - | - |  | - |
| STAT_OBJ | 统计对象 | VARCHAR2(2) | - | - |  | - |
| MKT_ACT_ID | 营销活动编号 | VARCHAR2(40) | - | - |  | - |
| CUST_CNT | 客户数 | NUMBER(8) | - | - |  | - |
| CTKT_COVER_RATE | 接触覆盖率 | NUMBER(10,2) | - | - |  | - |
| PLAN_SUPPORT_CUST_CNT | 拟支持客户数 | NUMBER(8) | - | - |  | - |
| FURTHER_MKT_CUST_CNT | 进一步营销客户数 | NUMBER(8) | - | - |  | - |
| NOT_SUPPORT_CUST_CNT | 不予支持客户数 | NUMBER(8) | - | - |  | - |
| MKT_SUCCESS_RATE | 营销成功率 | NUMBER(10,2) | - | - |  | - |

### ADS_MKT_ACT_TSK_MON_ZB (营销活动任务监控附表)

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源系统 | 源表 | 源字段 | 映射规则 |
|----------|---------------|--------------|--------|------|--------|----------|
| DATA_DATE | 数据日期 | VARCHAR2(8) | - | - |  | - |
| STAT_OBJ | 统计对象 | VARCHAR2(2) | - | - |  | - |
| MKT_ACT_ID | 营销活动编号 | VARCHAR2(40) | - | - |  | - |
| BASE_VAL | 基准值 | NUMBER(20,2) | - | - |  | - |
| CURNT_VAL | 当前值 | NUMBER(20,2) | - | - |  | - |
| INCR | 增量 | NUMBER(20,2) | - | - |  | - |
| GROWTH_RATE | 增长率 | NUMBER(10,2) | - | - |  | - |

### ADS_STAT_INDX_DATA (机构客户层级资产月报表)

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源系统 | 源表 | 源字段 | 映射规则 |
|----------|---------------|--------------|--------|------|--------|----------|
| DATA_DATE | 数据日期 | VARCHAR2(8) | - | - |  | - |
| BLNG_BRCH | 所属分行 | VARCHAR2(6) | - | - |  | - |
| BLNG_BRCH_SUB | 所属支行 | VARCHAR2(6) | - | - |  | - |
| BLNG_BRCH_NET | 所属网点 | VARCHAR2(6) | - | - |  | - |
| ORG_PATH | 机构路径 | VARCHAR2(20) | - | - |  | - |
| CUST_LVL | 客户等级 | VARCHAR2(2) | - | - |  | - |
| CUST_CNT | 客户数 | NUMBER(8) | - | - |  | - |
| AUM_BAL | AUM余额 | NUMBER(20,2) | - | - |  | - |
| AUM_MTH_AVG | AUM月日均 | NUMBER(20,2) | - | - |  | - |
| COMN_FIXD_BAL | 普通定期余额 | NUMBER(20,2) | - | - |  | - |
| LEHUI_BAL | 乐惠存余额 | NUMBER(20,2) | - | - |  | - |
| LARGEDP_BAL | 大额存单余额 | NUMBER(20,2) | - | - |  | - |
| FIXD_SUM | 定期合计 | NUMBER(20,2) | - | - |  | - |
| DEPO_CURNT_DEPO_BAL | 活期余额 | NUMBER(20,2) | - | - |  | - |
| DEPO_SUM | 存款合计 | NUMBER(20,2) | - | - |  | - |
| BIZ_SELF_FIN_BAL | 自营理财余额 | NUMBER(20,2) | - | - |  | - |
| PROXY_SELL_FIN_BAL | 代销理财余额 | NUMBER(20,2) | - | - |  | - |
| FIN_BAL_SUM | 理财余额合计 | NUMBER(20,2) | - | - |  | - |
| INSUR_BAL | 保险余额 | NUMBER(20,2) | - | - |  | - |
| LOAN_BAL | 贷款余额 | NUMBER(20,2) | - | - |  | - |

### ADS_CUST_DEADLINE_RMND_DTL (到期承接明细表)

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源系统 | 源表 | 源字段 | 映射规则 |
|----------|---------------|--------------|--------|------|--------|----------|
| DATA_DATE | 数据日期 | 8 | - | - |  | - |
| CUST_ID | 客户编号 | 20 | - | - |  | - |
| CUST_NAME | 客户名称 | 100 | - | - |  | - |
| CUST_LVL | 客户等级 | 2 | - | - |  | - |
| DEPO_CURNT_DEPO_BAL | 活期余额 | 20 | - | - |  | - |
| FIXD_DEPO_BAL | 定期余额 | 20 | - | - |  | - |
| FIN_AMT | 理财余额 | 20 | - | - |  | - |
| STAT_PERD | 统计周期 | 2 | - | - |  | - |
| STATIS_TYP | 承接类型1-存款2-理财 | 2 | - | - |  | - |
| EXPR_AMT | 到期金额 | 20 | - | - |  | - |
| MATURE_TTL_AMT | 到期总金额 | 20 | - | - |  | - |
| TAKE_RATE | 承接率 | 10 | - | - |  | - |
| FIX_DEPO_MATURE_AMT | 定期存款到期金额 | 20 | - | - |  | - |
| FIX_DEPO_MATURE_TTL_AMT | 定期存款到期总金额 | 20 | - | - |  | - |
| FIX_DEPO_TAKE_RATE | 定期存款承接率 | 10 | - | - |  | - |
| CNTCT_STATE | 接触状态 | 1 | - | - |  | - |
| UNDTAKE_STATE | 承接状态 | 1 | - | - |  | - |
| FIXED_FIN_MATURE_TRAN_INSUR_AMT | 定期理财到期转保险金额 | 20 | - | - |  | - |
| FIN_MATURE_TRAN_FIXED_AMT | 理财到期转定期金额 | 20 | - | - |  | - |
| FIXED_MATURE_TRAN_FIN_AMT | 定期到期转理财金额 | 20 | - | - |  | - |
| FRST_MATURE_PK_BF_DAY_AUM_BAL | 本期第一笔到期产品前一日AUM余额 | 20 | - | - |  | - |
| LAST_END_DATE | 本期最后一笔到期产品日期 | 8 | - | - |  | - |
| POST_ID | 管户经理 | 20 | - | - |  | - |
| ORG_ID | 归属机构 | 6 | - | - |  | - |

### CUST_DEADLINE_RMND_STATIS (到期承接统计表)

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源系统 | 源表 | 源字段 | 映射规则 |
|----------|---------------|--------------|--------|------|--------|----------|
| DATA_DATE | 数据日期 | 8 | - | - |  | - |
| STATIS_OBJ | 统计对象 | 2 | - | - |  | - |
| STATIS_CYCLE | 统计周期 | 2 | - | - |  | - |
| STATIS_TYP | 承接类型1-存款2-理财 | 2 | - | - |  | - |
| EXPR_CUST_CNT | 已到期客户数 | 8 | - | - |  | - |
| TTL_EXPR_CUST_CNT | 总到期客户数 | 8 | - | - |  | - |
| EXPR_AMT | 已到期金额 | 20,2 | - | - |  | - |
| TTL_EXPR_AMT | 总到期金额 | 20,2 | - | - |  | - |
| CUST_UNDTAKE_RATE | 客户承接率 | 20,2 | - | - |  | - |
| ASSET_KEEP_RATE | 资产留存率 | 20,2 | - | - |  | - |
| ASSET_UNDTAKE_RATE | 资产承接率 | 20,2 | - | - |  | - |
| DEPO_TO_FIN_CONVRS_RATE | 存款转理财转化率 | 20,2 | - | - |  | - |
| INSUR_CONVRS_RATE | 保险转化率 | 20,2 | - | - |  | - |
| FIN_TO_DEPO_CONVRS_RATE | 理财转存款转化率 | 20,2 | - | - |  | - |

### CUST_LOST_DTL (客户流失清单)

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源系统 | 源表 | 源字段 | 映射规则 |
|----------|---------------|--------------|--------|------|--------|----------|
| DATA_DATE | 数据日期 | VARCHAR2(8) | - | - |  | - |
| CUST_ID | 客户编号 | VARCHAR2(20) | - | - |  | - |
| CUST_NAME | 客户名称 | VARCHAR2(100) | - | - |  | - |
| CUST_LVL | 客户等级 | VARCHAR2(2) | - | - |  | - |
| LVL_CHURN | 流失等级 | VARCHAR2(2) | - | - |  | - |
| DEPO_CURNT_DEPO_BAL | 活期余额 | NUMBER(20,2) | - | - |  | - |
| FIXD_DEPO_BAL | 定期余额 | NUMBER(20,2) | - | - |  | - |
| FIN_AMT | 理财余额 | NUMBER(20,2) | - | - |  | - |
| CNTCT_STATE | 接触状态 | VARCHAR2(1) | - | - |  | - |
| RESCUE_STATE | 挽回状态 | VARCHAR2(1) | - | - |  | - |
| POST_ID | 管户经理 | VARCHAR2(20) | - | - |  | - |
| ORG_ID | 归属机构 | VARCHAR2(6) | - | - |  | - |

### CUST_LOST_STATIS (客户挽回统计表)

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源系统 | 源表 | 源字段 | 映射规则 |
|----------|---------------|--------------|--------|------|--------|----------|
| DATA_DATE | 数据日期 | VARCHAR2(8) | - | - |  | - |
| STATIS_OBJ | 统计对象 | VARCHAR2(2) | - | - |  | - |
| STATIS_CYCLE | 统计周期 | VARCHAR2(2) | - | - |  | - |
| LVL_CHURN | 流失等级 | VARCHAR2(1) | - | - |  | - |
| CUST_CNT | 客户数 | NUMBER(8) | - | - |  | - |
| CNTCT_CUST_CNT | 已接触客户 | NUMBER(8) | - | - |  | - |
| CNTCT_RATE | 接触率 | NUMBER(20,2) | - | - |  | - |
| RESCUED_CUST_CNT | 已挽回客户 | NUMBER(8) | - | - |  | - |
| RESCUE_RATE | 挽回率 | NUMBER(20,2) | - | - |  | - |
| RESCUED_FINA_ASSET | 已挽回金融资产 | NUMBER(20,2) | - | - |  | - |

### CUST_POTN_UPGRADE_CUST_DTL (潜力提升客户明细列表)

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源系统 | 源表 | 源字段 | 映射规则 |
|----------|---------------|--------------|--------|------|--------|----------|
| DATA_DATE | 数据日期 | VARCHAR2(8) | - | - |  | - |
| CUST_ID | 客户编号 | VARCHAR2(20) | - | - |  | - |
| CUST_NAME | 客户名称 | VARCHAR2(100) | - | - |  | - |
| CUST_LVL | 客户等级 | VARCHAR2(2) | - | - |  | - |
| LVL_CRIT | 临界等级 | VARCHAR2(2) | - | - |  | - |
| DEPO_CURNT_DEPO_BAL | 活期余额 | NUMBER(20,2) | - | - |  | - |
| FIXD_DEPO_BAL | 定期余额 | NUMBER(20,2) | - | - |  | - |
| FIN_AMT | 理财余额 | NUMBER(20,2) | - | - |  | - |
| CNTCT_STATE | 接触状态 | VARCHAR2(1) | - | - |  | - |
| QUAL_STATE | 达标状态 | VARCHAR2(1) | - | - |  | - |
| POST_ID | 管户经理 | VARCHAR2(20) | - | - |  | - |
| ORG_ID | 归属机构 | VARCHAR2(6) | - | - |  | - |

### CUST_POTN_UPGRADE_STATIS (潜力提升统计表)

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源系统 | 源表 | 源字段 | 映射规则 |
|----------|---------------|--------------|--------|------|--------|----------|
| DATA_DATE | 数据日期 | VARCHAR2(8) | - | - |  | - |
| STATIS_OBJ | 统计对象 | VARCHAR2(2) | - | - |  | - |
| STATIS_CYCLE | 统计周期 | VARCHAR2(2) | - | - |  | - |
| LVL_CRIT | 临界等级 | VARCHAR2(2) | - | - |  | - |
| TTL_CUST_CNT | 总客户数 | NUMBER(8) | - | - |  | - |
| MTH_AVG_QUAL_CNT | 月均达标 | NUMBER(8) | - | - |  | - |
| MTH_AVG_QUAL_RATE | 月均达标率 | NUMBER(20,2) | - | - |  | - |
| PNT_QUAL_CNT | 时点达标 | NUMBER(8) | - | - |  | - |
| PNT_QUAL_RATE | 时点达标率 | NUMBER(20,2) | - | - |  | - |
| CNTCT_CUST_CNT | 已接触客户 | NUMBER(8) | - | - |  | - |
| CNTCT_RATE | 接触率 | NUMBER(20,2) | - | - |  | - |

### CUST_NEW_CUST_DTL (新客经营明细)

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源系统 | 源表 | 源字段 | 映射规则 |
|----------|---------------|--------------|--------|------|--------|----------|
| DATA_DATE | 数据日期 | VARCHAR2(8) | - | - |  | - |
| CUST_ID | 客户编号 | VARCHAR2(20) | - | - |  | - |
| CUST_NAME | 客户名称 | VARCHAR2(100) | - | - |  | - |
| CUST_LVL | 客户等级 | VARCHAR2(2) | - | - |  | - |
| NEW_CUST_CYCLE | 新客周期 | VARCHAR2(1) | - | - |  | - |
| DEPO_CURNT_DEPO_BAL | 活期余额 | NUMBER(20,2) | - | - |  | - |
| FIXD_DEPO_BAL | 定期余额 | NUMBER(20,2) | - | - |  | - |
| FIN_AMT | 理财余额 | NUMBER(20,2) | - | - |  | - |
| CNTCT_STATE | 接触状态 | VARCHAR2(1) | - | - |  | - |
| KYC_STATE | KYC状态 | VARCHAR2(1) | - | - |  | - |
| POST_ID | 管户经理 | VARCHAR2(20) | - | - |  | - |
| ORG_ID | 归属机构 | VARCHAR2(6) | - | - |  | - |

### CUST_NEW_CUST_STATIS (新客经营统计表)

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源系统 | 源表 | 源字段 | 映射规则 |
|----------|---------------|--------------|--------|------|--------|----------|
| DATA_DATE | 数据日期 | VARCHAR2(8) | - | - |  | - |
| STATIS_OBJ | 统计对象 | VARCHAR2(2) | - | - |  | - |
| STATIS_CYCLE | 统计周期 | VARCHAR2(2) | - | - |  | - |
| NEW_CUST_CYCLE | 新客周期 | VARCHAR2(1) | - | - |  | - |
| NEW_CUST_CNT | 新客数 | NUMBER(8) | - | - |  | - |
| CNTCT_CUST_CNT | 已接触客户 | NUMBER(8) | - | - |  | - |
| ASSET_BAL_SEG1_CUST_CNT | 资产余额区间1客户数 | NUMBER(8) | - | - |  | - |
| ASSET_BAL_SEG2_CUST_CNT | 资产余额区间2客户数 | NUMBER(8) | - | - |  | - |
| ASSET_BAL_SEG3_CUST_CNT | 资产余额区间3客户数 | NUMBER(8) | - | - |  | - |
| ASSET_BAL_SEG4_CUST_CNT | 资产余额区间4客户数 | NUMBER(8) | - | - |  | - |
| ASSET_BAL_SEG5_CUST_CNT | 资产余额区间5客户数 | NUMBER(8) | - | - |  | - |
| CNTCT_RATE | 接触率 | NUMBER(20,2) | - | - |  | - |
| KYC_CUST_CNT | KYC客户 | NUMBER(8) | - | - |  | - |
| COMP_RATE | 完成率 | NUMBER(20,2) | - | - |  | - |

### CUST_SLEEP_WAKE_DTL (睡眠户明细表)

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源系统 | 源表 | 源字段 | 映射规则 |
|----------|---------------|--------------|--------|------|--------|----------|
| DATA_DATE | 数据日期 | VARCHAR2(8) | - | - |  | - |
| CUST_ID | 客户编号 | VARCHAR2(20) | - | - |  | - |
| CUST_NAME | 客户名称 | VARCHAR2(100) | - | - |  | - |
| CUST_LVL | 客户等级 | VARCHAR2(2) | - | - |  | - |
| DEPO_CURNT_DEPO_BAL | 活期余额 | NUMBER(20,2) | - | - |  | - |
| FIXD_DEPO_BAL | 定期余额 | NUMBER(20,2) | - | - |  | - |
| FIN_AMT | 理财余额 | NUMBER(20,2) | - | - |  | - |
| CNTCT_STATE | 接触状态 | VARCHAR2(1) | - | - |  | - |
| WAKE_STATE | 唤醒状态 | VARCHAR2(1) | - | - |  | - |
| POST_ID | 管户经理 | VARCHAR2(20) | - | - |  | - |
| ORG_ID | 归属机构 | VARCHAR2(6) | - | - |  | - |

### CUST_SLEEP_WAKE_STATIS (睡眠户唤醒统计表)

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源系统 | 源表 | 源字段 | 映射规则 |
|----------|---------------|--------------|--------|------|--------|----------|
| DATA_DATE | 数据日期 | VARCHAR2(8) | - | - |  | - |
| STATIS_OBJ | 统计对象 | VARCHAR2(2) | - | - |  | - |
| STATIS_CYCLE | 统计周期 | VARCHAR2(2) | - | - |  | - |
| CUST_CNT | 客户数 | NUMBER(8) | - | - |  | - |
| CNTCT_CUST_CNT | 已接触客户 | NUMBER(8) | - | - |  | - |
| CNTCT_RATE | 接触率 | NUMBER(20,2) | - | - |  | - |
| WAKE_CUST_CNT | 已唤醒客户 | NUMBER(8) | - | - |  | - |
| WAKE_RATE | 唤醒率 | NUMBER(20,2) | - | - |  | - |

### MKT_REC_INFO (营销记录表)

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源系统 | 源表 | 源字段 | 映射规则 |
|----------|---------------|--------------|--------|------|--------|----------|
| MKT_REC_SEQ_ID | 营销记录流水号 | 40 | - | - |  | - |
| REL_ID | 关联ID(商机ID、客户群ID/营销活动ID) | 40 | - | - |  | - |
| MKT_TYP | 营销类型(1面访/2电话/3短信/4企微) | 6 | - | - |  | - |
| REL_TYP | 关联类型(客户群/商机/营销活动) | 6 | - | - |  | - |
| CUST_ID | 客户ID | 20 | - | - |  | - |
| CUST_NAME | 客户名称 | 100 | - | - |  | - |
| MKT_SITE | 营销地点 | 200 | - | - |  | - |
| MKT_TIME | 营销时间 | 20 | - | - |  | - |
| MKT_PERSN | 营销人ID | 30 | - | - |  | - |
| MKT_PERSN_NAME | 营销人名称 | 64 | - | - |  | - |
| MKT_ORG | 营销机构 | 30 | - | - |  | - |
| MKT_DURA | 营销时长 | 20 | - | - |  | - |
| MKT_DTL_SITU | 营销详细情况 | 400 | - | - |  | - |
| MKT_APDIX_ID | 营销附件ID(录音/图片) | 40 | - | - |  | - |
| TEMP_ID | 模板ID | 40 | - | - |  | - |
| TEMP_NAME | 模板名称 | 100 | - | - |  | - |
| MSG_SHORT_SEQ_ID | 短信流水号 | 40 | - | - |  | - |
| PERSN_LEGAL_BK_CODE | 法人行号 | 30 | - | - |  | - |
| CORDNAT_VISITOR | 协同拜访人 | 100 | - | - |  | - |
| CORDNAT_VISITOR_NAME | 协同拜访人名称 | 200 | - | - |  | - |
| LGTUD | 经度 | 40 | - | - |  | - |
| LATTUD | 纬度 | 40 | - | - |  | - |
| TEL_NO | 联系电话 | 40 | - | - |  | - |
| CHNL_NO | 渠道编号 | 6 | - | - |  | - |
| RMARK | 备注 | 400 | - | - |  | - |
| NO_BAT | 批次号 | 40 | - | - |  | - |
| MSG_SHORT_INF | 短信内容 | 500 | - | - |  | - |


---
*Mapping版本: v1.0 | 生成时间: 2026-07-17*
