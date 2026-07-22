# DWD数据字典 - DWD_CUST_INDV_KYC

## 表信息

| 属性 | 值 |
|------|------|
| 层级 | DWD - 明细数据层 |
| 表名 | DWD_CUST_INDV_KYC |
| 中文名称 | 客户KYC信息表 |
| 更新时间 | 2026-07-21 |

## 字段列表

| 字段名 | 字段中文说明 | 数据类型 | 长度 | 是否为空 | 默认值 | 主键 | 外键 | 枚举说明 | 业务含义 |
|--------|-------------|----------|------|----------|--------|------|------|----------|----------|
| CUST_ID | 客户编号 | VARCHAR | 20 | NOT NULL | - | - | - | - | 客户编号 |
| CUST_NM | 客户名称 | VARCHAR | 100 | - | - | - | - | - | 客户名称 |
| BK_OUTER_DEPO | 行外存款 | NUMBER | 20 | - | - | - | - | - | 行外存款 |
| BK_OUTER_FIN | 行外理财 | NUMBER | 20 | - | - | - | - | - | 行外理财 |
| BK_OUTER_FUND | 行外基金 | NUMBER | 20 | - | - | - | - | - | 行外基金 |
| BK_OUTER_INSUR | 行外保险 | NUMBER | 20 | - | - | - | - | - | 行外保险 |
| BK_OUTER_GOLD | 行外贵金属 | NUMBER | 20 | - | - | - | - | - | 行外贵金属 |
| STK_INVEST | 股票投资 | VARCHAR | 2 | - | - | - | - | - | 股票投资 |
| ESTT_INF | 住宅信息 | VARCHAR | 2 | - | - | - | - | - | 住宅信息 |
| PROP_OWNER_CERT_NO | 房产证号 | VARCHAR | 60 | - | - | - | - | - | 房产证号 |
| HOUSE_AREA | 面积 | NUMBER | 10 | - | - | - | - | - | 面积 |
| IS_HOUSE_MORTGAGED | 是否抵押 | VARCHAR | 1 | - | - | - | - | - | 是否抵押 |
| RES_ADDRS | 地址 | VARCHAR | 254 | - | - | - | - | - | 地址 |
| SHOP_INVEST | 商铺投资 | VARCHAR | 2 | - | - | - | - | - | 商铺投资 |
| VIKL_INF | 车辆信息 | VARCHAR | 2 | - | - | - | - | - | 车辆信息 |
| VEHICLE_PLATE_NO | 车牌号 | VARCHAR | 10 | - | - | - | - | - | 车牌号 |
| USAGE_NATURE | 使用性质 | VARCHAR | 100 | - | - | - | - | - | 使用性质 |
| IS_CAR_LOAN | 是否有车贷 | VARCHAR | 2 | - | - | - | - | - | 是否有车贷 |
| IS_CAR_MORTGAGED | 是否抵押 | VARCHAR | 2 | - | - | - | - | - | 是否抵押 |
| MTH_INCOM | 月收入 | NUMBER | 20 | - | - | - | - | - | 月收入 |
| YR_INCOM | 年收入 | NUMBER | 20 | - | - | - | - | - | 年收入 |
| BK_OUTER_LOAN_BAL | 行外贷款余额 | NUMBER | 20 | - | - | - | - | - | 行外贷款余额 |
| BK_OUTER_CRDT_LMT | 行外授信额度 | NUMBER | 20 | - | - | - | - | - | 行外授信额度 |
| AVAIL_LMT | 可用额度 | NUMBER | 20 | - | - | - | - | - | 可用额度 |
| CREATR | 创建人 | VARCHAR | 20 | - | - | - | - | - | 创建人 |
| CREAT_ORG | 创建机构 | VARCHAR | 7 | - | - | - | - | - | 创建机构 |
| CREAT_TIME | 创建时间 | VARCHAR | 20 | - | - | - | - | - | 创建时间 |

---
*数据字典版本: v1.0 | 生成时间: 2026-07-21*
