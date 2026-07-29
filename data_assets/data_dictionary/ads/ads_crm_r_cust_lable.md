# 对私客户标签表

**表名**: `ADS_CRM_R_CUST_LABLE`  
**中文名**: 对私客户标签表  
**来源**: Mapping Excel (ADS应用层数据模型)  
**存储过程**: PRC_ADS_CRM_R_CUST_LABLE (v1.0.0)  
**更新时间**: 2026-07-29

## Y标记字段（12个，其中8个已开发）

| 字段名 | 数据类型 | 中文名 | 业务口径 | 状态 |
|--------|---------|--------|----------|------|
| DATA_DATE | VARCHAR2(8) | 数据日期 | 跑批日期 | 已开发 |
| PERSN_LEGAL_BK_CODE | VARCHAR2 | 法人行号 | DWD_CUST_INDV_INFO | 已开发 |
| CUST_ID | VARCHAR2 | 核心客户号 | DWD_CUST_INDV_INFO | 已开发 |
| NEAR_MTH_TX_CNT | NUMBER | 近1月累计交易笔数 | 主动动账 | 已开发(待确认过滤字段) |
| NEAR_MTH_TX_AMT | NUMBER | 近1月累计交易金额 | 主动动账 | 已开发(待确认过滤字段) |
| NEAR_MTH_THIRD_PAY_OUT_CNT | NUMBER | 近1月第三方支付累计转出笔数 | 网联渠道 | 已开发(待确认码值) |
| NEAR_MTH_THIRD_PAY_OUT_AMT | NUMBER | 近1月第三方支付累计转出金额 | 网联渠道 | 已开发(待确认码值) |
| IS_NOT_RGLAR_TRANS_BK_OTHER_SAMENAME | CHAR | 是否向他行同名户规律转出 | 近半年每月至少1笔 | 已开发 |
| BILL_RSV_MKNT_CNT_MTH_LAST | NUMBER | 收单商户上月交易笔数 | 待定 | 待补充 |
| BILL_RSV_MKNT_AMT_MTH_LAST | NUMBER | 收单商户上月交易金额 | 待定 | 待补充 |
| YR_CAMPUS_PAY_CNT | NUMBER | 当年校园缴费笔数 | 手机银行取学费 | 待补充 |
| MTH_UTIL_PAY_TRAN_AMT | NUMBER | 当月完成水电气缴费交易金额 | 手机银行生活费 | 待补充 |
| MTH_UTIL_PAY_TRAN_CNT | NUMBER | 当月完成水电气缴费交易笔数 | 手机银行生活费 | 待补充 |

## 待确认事项

| # | 事项 | 影响字段 | 当前暂用方案 |
|---|------|----------|-------------|
| 1 | 主动/被动动账区分字段 | NEAR_MTH_TX_CNT/AMT | 不过滤，标记TODO |
| 2 | 网联渠道完整码值 | THIRD_PAY_OUT_CNT/AMT | 3026+3030 |
| 3 | 本行联行号标识 | RGLAR_TRANS | OPNT_BK_KEEP NOT LIKE '9999%' |
| 4 | mbk_cust_log_fee中CUST_ID映射 | CAMPUS/UTIL | NULL占位 |
| 5 | 收单商户CUST_ID映射 | BILL_RSV_MKNT_* | NULL占位 |
