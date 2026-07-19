# ADS数据字典 - ads_cust_prdkt_rcmd

## 表信息

| 属性 | 值 |
|------|------|
| 层级 | ADS |
| 表名 | ads_cust_prdkt_rcmd |
| 中文名称 | 客户产品推荐表 |
| 更新时间 | 2026-07-19 |

## 字段列表

| 字段名 | 字段中文说明 | 数据类型 | 长度 | 是否为空 | 默认值 | 主键 | 外键 | 枚举说明 | 业务含义 |
|--------|-------------|----------|------|----------|--------|------|------|----------|----------|
| DATA_DATE | 数据日期 | VARCHAR(8) | - | NOT NULL | - | - | - | - | 数据日期 |
| CUST_ID | 客户编号 | VARCHAR(20) | - | NOT NULL | - | - | - | - | 客户唯一标识 |
| PRDKT_ID | 产品编号 | VARCHAR(40) | - | NOT NULL | - | - | - | - | 产品唯一标识 |
| PRDKT_NAME | 产品名称 | VARCHAR(100) | - | NULL | - | - | - | - | 产品名称 |
| RCMD_RANK | 推荐排序 | VARCHAR(1) | - | NULL | - | - | - | 1/2/3 | 推荐排序序号 |
| TOTAL_SCORE | 总分 | NUMBER(5,2) | - | NULL | - | - | - | 0-100 | 100分制总分 |
| RETURN_SCORE | 收益吸引力得分 | NUMBER(5,2) | - | NULL | - | - | - | 0-35 | 收益竞争力评分 |
| DURATION_SCORE | 期限匹配度得分 | NUMBER(5,2) | - | NULL | - | - | - | 0-30 | 期限匹配程度评分 |
| RISK_COMFORT_SCORE | 风险舒适度得分 | NUMBER(5,2) | - | NULL | - | - | - | 0-20 | 风险舒适区评分 |
| HIST_PREF_SCORE | 历史偏好得分 | NUMBER(5,2) | - | NULL | - | - | - | 0-15 | 历史购买偏好评分 |
| RCMD_REASON | 推荐理由 | VARCHAR(500) | - | NULL | - | - | - | - | 推荐理由描述 |
| CUST_RISK_LVL | 客户风险承受等级 | VARCHAR(2) | - | NULL | - | - | - | C1-C5 | 客户风险承受能力等级 |
| PRDKT_RISK_LVL | 产品风险等级 | VARCHAR(2) | - | NULL | - | - | - | R1-R5 | 产品风险等级 |
| PRDKT_RATE | 产品预期收益率 | NUMBER(18,4) | - | NULL | - | - | - | - | 产品预期收益率 |
| PRDKT_DURATION | 产品期限(天) | NUMBER(10) | - | NULL | - | - | - | - | 产品期限天数 |
| PRDKT_STATE | 产品状态 | VARCHAR(10) | - | NULL | - | - | - | - | 产品状态(在售/停售) |
| PRDKT_CATE_BIG | 产品大类 | VARCHAR(10) | - | NULL | - | - | - | - | 产品大类 |
| ISSU_ORG | 发行机构 | VARCHAR(6) | - | NULL | - | - | - | - | 产品发行机构 |
| BGN_DATE | 产品开始日期 | VARCHAR(10) | - | NULL | - | - | - | - | 产品开始日期 |
| END_DATE | 产品结束日期 | VARCHAR(10) | - | NULL | - | - | - | - | 产品结束日期 |
| CUST_NAME | 客户名称 | VARCHAR(100) | - | NULL | - | - | - | - | 客户名称 |
| POST_ID | 管户经理 | VARCHAR(20) | - | NULL | - | - | - | - | 管户经理编号 |
| ORG_ID | 归属机构 | VARCHAR(6) | - | NULL | - | - | - | - | 归属机构编号 |

---
*数据字典版本: v1.0 | 生成时间: 2026-07-19*