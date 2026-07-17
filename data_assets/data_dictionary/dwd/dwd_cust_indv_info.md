# DWD数据字典 - DWD_CUST_INDV_INFO

## 表信息

| 属性 | 值 |
|------|------|
| 层级 | DWD - 明细数据层 |
| 表名 | DWD_CUST_INDV_INFO |
| 中文名称 | 客户基本信息 |
| 更新时间 | 2026-07-17 |

## 字段列表

| 字段名 | 字段中文说明 | 数据类型 | 长度 | 是否为空 | 默认值 | 主键 | 外键 | 枚举说明 | 业务含义 |
|--------|-------------|----------|------|----------|--------|------|------|----------|----------|
| CUST_ID | 客户编号 | VARCHAR2(20) | - | - | - | - | - | - | - |
| CUST_NAME | 客户名称 | VARCHAR2(100) | - | - | - | - | - | - | - |
| CERT_TYP | 证件类型 | VARCHAR2(6) | - | - | - | - | - | - | - |
| CERT_ID | 证件号码 | VARCHAR2(32) | - | - | - | - | - | - | - |
| CERT_PRD_VLID | 证件有效期起 | VARCHAR2(10) | - | - | - | - | - | - | - |
| CERT_PRD_VLID_END | 证件有效期止 | VARCHAR2(10) | - | - | - | - | - | - | - |
| CERT_ISSUING_AUTHORITY | 签发机关所在地 | VARCHAR2(100) | - | - | - | - | - | - | - |
| CUST_TYP | 客户类型 | VARCHAR2(2) | - | - | - | - | - | - | - |
| NATIONALITY | 国籍 | VARCHAR2(6) | - | - | - | - | - | - | - |
| NATION | 民族 | VARCHAR2(6) | - | - | - | - | - | - | - |
| MARI_SITU | 婚姻状况 | VARCHAR2(6) | - | - | - | - | - | - | - |
| MAX_DEG_EDU | 最高学历 | VARCHAR2(6) | - | - | - | - | - | - | - |
| NOW_ENTER | 现工作单位 | VARCHAR2(120) | - | - | - | - | - | - | - |
| OCCU_CLS | 职业分类 | VARCHAR2(6) | - | - | - | - | - | - | - |
| CUST_HRAKY | 客户等级 | VARCHAR2(2) | - | - | - | - | - | - | - |
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR2(4) | - | - | - | - | - | - | - |
| GEND | 性别 | VARCHAR2(2) | - | - | - | - | - | - | - |
| PHONE_NO | 手机号码 | VARCHAR2(20) | - | - | - | - | - | - | - |
| CONTACT_ADDRESS | 联系地址 | VARCHAR2(254) | - | - | - | - | - | - | - |
| CONTACT_ADDRESS_DETAIL | 联系地址详细地址 | VARCHAR2(254) | - | - | - | - | - | - | - |
| ID_ADDRESS | 证件地址 | VARCHAR2(254) | - | - | - | - | - | - | - |
| ID_ADDRESS_DETAIL | 证件地址详细地址 | VARCHAR2(254) | - | - | - | - | - | - | - |
| HOME_ADDRESS | 家庭地址 | VARCHAR2(254) | - | - | - | - | - | - | - |
| HOME_ADDRESS_DETAIL | 家庭地址详细地址 | VARCHAR2(254) | - | - | - | - | - | - | - |
| RESIDENCE_ADDRESS | 住宅地址 | VARCHAR2(254) | - | - | - | - | - | - | - |
| RESIDENCE_ADDRESS_DETAIL | 住宅地址详细地址 | VARCHAR2(254) | - | - | - | - | - | - | - |
| OFFICE_ADDRESS | 办公地址 | VARCHAR2(254) | - | - | - | - | - | - | - |
| OFFICE_ADDRESS_DETAIL | 办公地址详细地址 | VARCHAR2(254) | - | - | - | - | - | - | - |
| HOST_CUST_MNGR_POST_ID | 主办客户经理职位编号 | VARCHAR2(20) | - | - | - | - | - | - | - |
| HOST_CUST_MNGR_NAME | 主办客户经理名称 | VARCHAR2(60) | - | - | - | - | - | - | - |
| HOST_CUST_MNGR_EMP_ID | 主办客户经理工号 | VARCHAR2(6) | - | - | - | - | - | - | - |
| ORG_LEAD | 主办机构(归属机构) | VARCHAR2(6) | - | - | - | - | - | - | - |
| ORG_LEAD_PATH | 主办机构路径 | VARCHAR2(50) | - | - | - | - | - | - | - |
| COSPSR_CUST_MNGR_POST_ID | 信贷客户经理职位编号 | VARCHAR2(20) | - | - | - | - | - | - | - |
| COSPSR_CUST_MNGR_NAME | 信贷客户经理名称 | VARCHAR2(60) | - | - | - | - | - | - | - |
| COSPSR_CUST_MNGR_EMP_ID | 信贷客户经理工号 | VARCHAR2(6) | - | - | - | - | - | - | - |
| COSPSR_ORG | 信贷机构 | VARCHAR2(6) | - | - | - | - | - | - | - |
| COSPSR_ORG_PATH | 信贷机构路径 | VARCHAR2(50) | - | - | - | - | - | - | - |

---
*数据字典版本: v1.0 | 生成时间: 2026-07-17*
