# DWD到DWS映射 字段映射

## 映射来源

- Excel：`data_assets/mapping/dwd_to_dws/DWS汇总层数据模型_CRM_ V1.0.xlsx`
- Excel SHA-256：`c11376787670aff7bfbfb5df8fb69aa1cecf9182407510d8acd679e8de47072f`

## 映射概览

| 目标表 | 字段数 |
|--------|-------:|
| DWS_CUST_ASSE_LIAB | 14 |
| DWS_CUST_ASSE_LIAB_CUMU | 15 |
| DWS_CUST_CAPITAL_RMND | 21 |
| DWS_CUST_CARE_RMND | 17 |
| DWS_CUST_DEADLINE_RMND | 20 |
| DWS_CUST_INDIV_REFERRAL | 14 |
| DWS_CUST_LVL_INFO | 3 |
| DWS_CUST_REFERRAL_RMND | 10 |

## 字段映射详情

### DWS_CUST_DEADLINE_RMND

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源表 | 源字段 | 映射规则 |
|----------|----------------|--------------|------|--------|----------|
| RMND_ID | 到期提醒ID | VARCHAR2(40) |  |  |  |
| RMND_TYP | 提醒类型 | VARCHAR2(6) |  |  |  |
| RMND_NAME | 提醒名称 | VARCHAR2(100) |  |  |  |
| MNGR_POST_ID | 客户经理编号 | VARCHAR2(20) |  |  |  |
| MNGR_NAME | 客户经理名称 | VARCHAR2(120) |  |  |  |
| CUST_ID | 客户ID | VARCHAR2(20) |  |  |  |
| CUST_TYP | 客户类型 | VARCHAR2(6) |  |  |  |
| CUST_NAME | 客户名称 | VARCHAR2(100) |  |  |  |
| PRDKT_NAME | 产品名称 | VARCHAR2(100) |  |  |  |
| EXPR_AMT | 到期金额 | NUMBER(20,2) |  |  |  |
| EXPR_DATE | 到期日期 | VARCHAR2(10) |  |  |  |
| ORG_ID | 机构(客户经理所在机构) | VARCHAR2(7) |  |  |  |
| HDLE_STATE | 处理状态(0为未读,1已读) | VARCHAR2(2) |  |  |  |
| RMND_DATE | 提醒日期 | VARCHAR2(10) |  |  |  |
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR2(4) |  |  |  |
| HDLE_TIME | 处理时间 | VARCHAR2(20) |  |  |  |
| DEL_FLG | 删除标志 1 是 0 否 | CHAR(1) |  |  |  |
| PHONE_NO | 手机号 | VARCHAR2(20) |  |  |  |
| RMND_INF | 提醒内容 | VARCHAR2(200) |  |  |  |
| CUST_LVL | 客户层级 | VARCHAR2(2) |  |  |  |

### DWS_CUST_CARE_RMND

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源表 | 源字段 | 映射规则 |
|----------|----------------|--------------|------|--------|----------|
| CARE_ID | 关怀ID | VARCHAR2(40) |  |  |  |
| CARE_TYP | 关怀类型(01生日关怀,02节假日关怀) | VARCHAR2(2) |  |  |  |
| MNGR_POST_ID | 客户经理编号 | VARCHAR2(20) |  |  |  |
| MNGR_NAME | 客户经理名称 | VARCHAR2(120) |  |  |  |
| CUST_ID | 客户ID | VARCHAR2(20) |  |  |  |
| CUST_NAME | 客户名称 | VARCHAR2(120) |  |  |  |
| PHONE_NO | 手机号 | VARCHAR2(32) |  |  |  |
| CUST_TYP | 客户类型 | VARCHAR2(2) |  |  |  |
| ORG_ID | 所属机构(客户经理所在机构) | VARCHAR2(7) |  |  |  |
| HDLE_STATE | 处理状态(0 未处理，1 已处理，2已到期) | VARCHAR2(2) |  |  |  |
| CATE_TIME | 关怀时间 | VARCHAR2(20) |  |  |  |
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR2(4) |  |  |  |
| HDLE_TIME | 处理时间 | VARCHAR2(20) |  |  |  |
| CTKTR_NAME | 联系人姓名 | VARCHAR2(64) |  |  |  |
| CTKTR_REL | 联系人关系 | VARCHAR2(6) |  |  |  |
| DATA_DATE | 数据日期 | VARCHAR2(8) |  |  |  |
| MSG_CONTENT | 消息内容 | VARCHAR2(200) |  |  |  |

### DWS_CUST_CAPITAL_RMND

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源表 | 源字段 | 映射规则 |
|----------|----------------|--------------|------|--------|----------|
| RMND_ID | 提醒ID | VARCHAR2(40) |  |  |  |
| MNGR_POST_ID | 客户经理编号 | VARCHAR2(20) |  |  |  |
| MNGR_NAME | 客户经理名称 | VARCHAR2(120) |  |  |  |
| CUST_ID | 客户编号 | VARCHAR2(20) |  |  |  |
| CUST_TYP | 客户类型 | VARCHAR2(4) |  |  |  |
| CUST_NAME | 客户名称 | VARCHAR2(100) |  |  |  |
| ACCT_NO | 账号 | VARCHAR2(40) |  |  |  |
| HAPN_BAL | 发生金额 | NUMBER(20,2) |  |  |  |
| ORG_ID | 机构ID | VARCHAR2(7) |  |  |  |
| PHONE_NO | 手机号 | VARCHAR2(32) |  |  |  |
| HDLE_STATE | 处理状态(0为浏览,1已浏览) | VARCHAR2(2) |  |  |  |
| DC_FLAG | 借贷标志 | VARCHAR2(2) |  |  |  |
| RMND_TIME | 发生时间 | VARCHAR2(20) |  |  |  |
| TX_CHNL | 交易渠道 | VARCHAR2(20) |  |  |  |
| OPNT_BK_KEEP | 对手行 | VARCHAR2(200) |  |  |  |
| OPNT_NAME | 对手姓名 | VARCHAR2(200) |  |  |  |
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR2(4) |  |  |  |
| HDLE_TIME | 处理时间 | VARCHAR2(20) |  |  |  |
| REMARK | 备注 | VARCHAR2(200) |  |  |  |
| CUST_LVL | 客户层级 | VARCHAR2(2) |  |  |  |
| RMND_INF | 提醒内容 | VARCHAR2(600) |  |  |  |

### DWS_CUST_INDIV_REFERRAL

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源表 | 源字段 | 映射规则 |
|----------|----------------|--------------|------|--------|----------|
| PK_ID | 主键 | VARCHAR2(40) |  |  |  |
| CUST_ID | 被转介客户号 | VARCHAR2(20) |  |  |  |
| CUST_NAME | 被转介客户姓名 | VARCHAR2(120) |  |  |  |
| CUST_TYP | 被转介客户类型 | VARCHAR2(2) |  |  |  |
| TEL_NO | 被转介客户联系电话 | VARCHAR2(20) |  |  |  |
| CERT_ID | 被转介客户证件号码 | VARCHAR2(32) |  |  |  |
| INTENT_PRDKT | 被转介客户意向产品 | VARCHAR2(200) |  |  |  |
| REFERRER | 转介人编号 | VARCHAR2(20) |  |  |  |
| REFERRAL_DATE | 转介日期 | VARCHAR2(8) |  |  |  |
| RSV_DATE | 接收日期 | VARCHAR2(8) |  |  |  |
| STATE | 状态 | VARCHAR2(2) |  |  |  |
| DSC | 说明 | VARCHAR2(400) |  |  |  |
| ELEVT_AUM | AUM提升金额 | NUMBER(20,2) |  |  |  |
| AUM | 接收时被转介客户AUM余额 | NUMBER(20,2) |  |  |  |

### DWS_CUST_REFERRAL_RMND

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源表 | 源字段 | 映射规则 |
|----------|----------------|--------------|------|--------|----------|
| PK_ID | 主键 | VARCHAR2(40) |  |  |  |
| MNGR_POST_ID | 客户经理编号 | VARCHAR2(20) |  |  |  |
| REFERRER_CUST_ID | 转介人客户号 | VARCHAR2(20) |  |  |  |
| REFERRER_NAME | 转介人名称 | VARCHAR2(120) |  |  |  |
| REFEREE_CUST_ID | 被转介人客户号 | VARCHAR2(20) |  |  |  |
| REFEREE_NAME | 被转介人名称 | VARCHAR2(120) |  |  |  |
| RMND_TIME | 提醒时间 | VARCHAR2(20) |  |  |  |
| RMND_INF | 提醒内容 | VARCHAR2(600) |  |  |  |
| HDLE_STATE | 处理状态 0-未读 1-已读 | VARCHAR2(2) |  |  |  |
| HDLE_TIME | 处理时间 | VARCHAR2(20) |  |  |  |

### DWS_CUST_ASSE_LIAB_CUMU

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源表 | 源字段 | 映射规则 |
|----------|----------------|--------------|------|--------|----------|
| DATA_DATE | 数据日期 | VARCHAR2(8) |  |  |  |
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR2(7) |  |  |  |
| OPRT_ORG | 归属机构 | VARCHAR2(7) |  |  |  |
| CUST_ID | 客户号 | VARCHAR2(20) |  |  |  |
| ACCT_ID | 账号 | VARCHAR2(40) |  |  |  |
| PRDKT_ID | 产品编号 | VARCHAR2(40) |  |  |  |
| PRDKT_CATE_BIG | 产品大类 | VARCHAR2(40) |  |  |  |
| PRDKT_TYP | 产品类型 | VARCHAR2(1) |  |  |  |
| BAL | 日余额 | NUMBER(20,2) |  |  |  |
| MTH_BAL | 月余额 | NUMBER(20,2) |  |  |  |
| QRT_BAL | 季余额 | NUMBER(20,2) |  |  |  |
| YAR_BAL | 年余额 | NUMBER(20,2) |  |  |  |
| MTH_DAYS | 月天数 | NUMBER(20,2) |  |  |  |
| QRT_DAYS | 季天数 | NUMBER(20,2) |  |  |  |
| YAR_DAYS | 年天数 | NUMBER(20,2) |  |  |  |

### DWS_CUST_ASSE_LIAB

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源表 | 源字段 | 映射规则 |
|----------|----------------|--------------|------|--------|----------|
| DATA_DATE | 数据日期 | VARCHAR2(8) |  |  |  |
| CUST_ID | 客户号 | VARCHAR2(20) |  |  |  |
| ORG_ID | 归属机构 | VARCHAR2(7) |  |  |  |
| ORG_ID_LOAN | 信贷归属机构 | VARCHAR2(6) |  |  |  |
| BAL_TYPE | 类型1-余额2-月日均3-季日均4-年日均 | CHAR(1) |  |  |  |
| AUM_BAL | AUM余额 | NUMBER(20,2) |  |  |  |
| DEPO_BAL | 定期余额 | NUMBER(20,2) |  |  |  |
| DEPO_CURNT_DEPO_BAL | 活期余额 | NUMBER(20,2) |  |  |  |
| FIXD_DEPO_BAL | 普通定期余额 | NUMBER(20,2) |  |  |  |
| LEHUI_BAL | 乐惠存产品余额 | NUMBER(20,2) |  |  |  |
| LARGEDP_BAL | 大额存单余额 | NUMBER(20,2) |  |  |  |
| FIN_BAL | 理财余额 | NUMBER(20,2) |  |  |  |
| INSUR_BAL | 保险余额 | NUMBER(20,2) |  |  |  |
| LOAN_BAL | 贷款余额 | NUMBER(20,2) |  |  |  |

### DWS_CUST_LVL_INFO

| 目标字段 | 目标字段中文名 | 目标字段类型 | 源表 | 源字段 | 映射规则 |
|----------|----------------|--------------|------|--------|----------|
| DATA_DT | 数据日期 | VARCHAR2(8) |  |  |  |
| CUST_ID | 客户编号 | VARCHAR2(20) |  |  |  |
| CUST_LVL | 客户等级 | VARCHAR2(2) |  |  |  |

---

*本文件由对应 Excel 模型同步生成；Excel 更新后必须重新生成本文件。
