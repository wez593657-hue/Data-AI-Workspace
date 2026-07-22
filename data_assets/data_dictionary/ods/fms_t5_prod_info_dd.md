# ODS 层数据字典 - crmdm.fms_t5_prod_info

## 表信息

| 属性 | 值 |
|------|----|
| 表名 | crmdm.fms_t5_prod_info |
| 中文名称 | 【待确认】 |
| 描述 | 根据 ODS DDL 自动生成，业务含义待确认 |
| 数据来源 | DDL: crmdm.fms_t5_prod_info |
| 负责人 | 【待确认】 |
| 更新时间 | 2026-07-17 |

## 字段列表

| 字段名 | 字段中文说明 | 数据类型 | 长度 | 是否为空 | 默认值 | 主键 | 外键 | 枚举说明 | 数据来源 | 负责人 | 更新时间 |
|--------|--------------|----------|------|----------|--------|------|------|----------|----------|--------|----------|
| prod_code | 【待确认】 | VARCHAR | 32 | NOT NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.prod_code | 【待确认】 | 2026-07-17 |
| prod_name | 【待确认】 | VARCHAR | 256 | NOT NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.prod_name | 【待确认】 | 2026-07-17 |
| prod_name_short | 【待确认】 | VARCHAR | 68 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.prod_name_short | 【待确认】 | 2026-07-17 |
| parent_prod_code | 【待确认】 | VARCHAR | 32 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.parent_prod_code | 【待确认】 | 2026-07-17 |
| prod_type | 【待确认】 | BPCHAR | 1 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.prod_type | 【待确认】 | 2026-07-17 |
| prod_mode | 【待确认】 | BPCHAR | 2 | NOT NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.prod_mode | 【待确认】 | 2026-07-17 |
| period_type | 【待确认】 | BPCHAR | 1 | NOT NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.period_type | 【待确认】 | 2026-07-17 |
| prod_cur | 【待确认】 | VARCHAR | 3 | NOT NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.prod_cur | 【待确认】 | 2026-07-17 |
| prod_risk_level | 【待确认】 | BPCHAR | 1 | NOT NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.prod_risk_level | 【待确认】 | 2026-07-17 |
| orgno | 【待确认】 | VARCHAR | 10 | NOT NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.orgno | 【待确认】 | 2026-07-17 |
| legal_code | 【待确认】 | VARCHAR | 32 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.legal_code | 【待确认】 | 2026-07-17 |
| def_div_method | 【待确认】 | BPCHAR | 1 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.def_div_method | 【待确认】 | 2026-07-17 |
| div_chg_flag | 【待确认】 | BPCHAR | 1 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.div_chg_flag | 【待确认】 | 2026-07-17 |
| min_div_amt | 【待确认】 | NUMERIC | 16,2 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.min_div_amt | 【待确认】 | 2026-07-17 |
| max_size | 【待确认】 | NUMERIC | 16,2 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.max_size | 【待确认】 | 2026-07-17 |
| min_size | 【待确认】 | NUMERIC | 16,2 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.min_size | 【待确认】 | 2026-07-17 |
| hold_quota | 【待确认】 | NUMERIC | 16,2 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.hold_quota | 【待确认】 | 2026-07-17 |
| quota_dime | 【待确认】 | VARCHAR | 20 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.quota_dime | 【待确认】 | 2026-07-17 |
| sale_status | 【待确认】 | BPCHAR | 1 | NOT NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.sale_status | 【待确认】 | 2026-07-17 |
| can_booking | 【待确认】 | BPCHAR | 1 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.can_booking | 【待确认】 | 2026-07-17 |
| can_order | 【待确认】 | BPCHAR | 1 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.can_order | 【待确认】 | 2026-07-17 |
| can_subs | 【待确认】 | BPCHAR | 1 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.can_subs | 【待确认】 | 2026-07-17 |
| can_apply | 【待确认】 | BPCHAR | 1 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.can_apply | 【待确认】 | 2026-07-17 |
| can_redeem | 【待确认】 | BPCHAR | 1 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.can_redeem | 【待确认】 | 2026-07-17 |
| can_frozen | 【待确认】 | BPCHAR | 1 | NOT NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.can_frozen | 【待确认】 | 2026-07-17 |
| start_buy_time | 【待确认】 | BPCHAR | 6 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.start_buy_time | 【待确认】 | 2026-07-17 |
| end_buy_time | 【待确认】 | BPCHAR | 6 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.end_buy_time | 【待确认】 | 2026-07-17 |
| publish_code | 【待确认】 | VARCHAR | 10 | NOT NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.publish_code | 【待确认】 | 2026-07-17 |
| income_characteristic | 【待确认】 | BPCHAR | 1 | NOT NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.income_characteristic | 【待确认】 | 2026-07-17 |
| prod_lifecycle | 【待确认】 | BPCHAR | 1 | NOT NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.prod_lifecycle | 【待确认】 | 2026-07-17 |
| regist_code | 【待确认】 | VARCHAR | 32 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.regist_code | 【待确认】 | 2026-07-17 |
| pay_check_acct_no | 【待确认】 | VARCHAR | 32 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.pay_check_acct_no | 【待确认】 | 2026-07-17 |
| cust_type | 【待确认】 | VARCHAR | 16 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.cust_type | 【待确认】 | 2026-07-17 |
| subs_capital_model | 【待确认】 | BPCHAR | 1 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.subs_capital_model | 【待确认】 | 2026-07-17 |
| subs_income_deal_type | 【待确认】 | BPCHAR | 1 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.subs_income_deal_type | 【待确认】 | 2026-07-17 |
| series_code | 【待确认】 | VARCHAR | 32 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.series_code | 【待确认】 | 2026-07-17 |
| series_num | 【待确认】 | NUMERIC | - | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.series_num | 【待确认】 | 2026-07-17 |
| profit_type | 【待确认】 | BPCHAR | 1 | NOT NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.profit_type | 【待确认】 | 2026-07-17 |
| nav | 【待确认】 | NUMERIC | 12,6 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.nav | 【待确认】 | 2026-07-17 |
| nav_date | 【待确认】 | BPCHAR | 8 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.nav_date | 【待确认】 | 2026-07-17 |
| auto_winding_flag | 【待确认】 | BPCHAR | 1 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.auto_winding_flag | 【待确认】 | 2026-07-17 |
| rasie_type | 【待确认】 | BPCHAR | 1 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.rasie_type | 【待确认】 | 2026-07-17 |
| subs_quota | 【待确认】 | NUMERIC | 16,2 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.subs_quota | 【待确认】 | 2026-07-17 |
| apply_quota | 【待确认】 | NUMERIC | 16,2 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.apply_quota | 【待确认】 | 2026-07-17 |
| redeem_quota | 【待确认】 | NUMERIC | 16,2 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.redeem_quota | 【待确认】 | 2026-07-17 |
| recover_apply_quota | 【待确认】 | BPCHAR | 1 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.recover_apply_quota | 【待确认】 | 2026-07-17 |
| recover_redeem_quota | 【待确认】 | BPCHAR | 1 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.recover_redeem_quota | 【待确认】 | 2026-07-17 |
| cust_group | 【待确认】 | BPCHAR | 1 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.cust_group | 【待确认】 | 2026-07-17 |
| prod_quota | 【待确认】 | NUMERIC | 16,2 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.prod_quota | 【待确认】 | 2026-07-17 |
| subs_redeem_flag | 【待确认】 | BPCHAR | 1 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.subs_redeem_flag | 【待确认】 | 2026-07-17 |
| winding_pay_date | 【待确认】 | BPCHAR | 8 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.winding_pay_date | 【待确认】 | 2026-07-17 |
| winding_pay_days | 【待确认】 | VARCHAR | 32 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.winding_pay_days | 【待确认】 | 2026-07-17 |
| specification_status | 【待确认】 | BPCHAR | 1 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.specification_status | 【待确认】 | 2026-07-17 |
| protocol_status | 【待确认】 | BPCHAR | 1 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.protocol_status | 【待确认】 | 2026-07-17 |
| rasie_quota | 【待确认】 | NUMERIC | 16,2 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.rasie_quota | 【待确认】 | 2026-07-17 |
| money_pay_day | 【待确认】 | VARCHAR | 1 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.money_pay_day | 【待确认】 | 2026-07-17 |
| has_waver_period | 【待确认】 | BPCHAR | 1 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.has_waver_period | 【待确认】 | 2026-07-17 |
| prod_comp_type | 【待确认】 | VARCHAR | 1 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.prod_comp_type | 【待确认】 | 2026-07-17 |
| update_prod_date | 【待确认】 | VARCHAR | 8 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.update_prod_date | 【待确认】 | 2026-07-17 |
| update_prod_time | 【待确认】 | VARCHAR | 6 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.update_prod_time | 【待确认】 | 2026-07-17 |
| ryzd | 【待确认】 | VARCHAR | 1 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_prod_info.ryzd | 【待确认】 | 2026-07-17 |
