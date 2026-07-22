# ODS 层数据字典 - crmdm.fms_t5_cust_vol

## 表信息

| 属性 | 值 |
|------|----|
| 表名 | crmdm.fms_t5_cust_vol |
| 中文名称 | 【待确认】 |
| 描述 | 根据 ODS DDL 自动生成，业务含义待确认 |
| 数据来源 | DDL: crmdm.fms_t5_cust_vol |
| 负责人 | 【待确认】 |
| 更新时间 | 2026-07-17 |

## 字段列表

| 字段名 | 字段中文说明 | 数据类型 | 长度 | 是否为空 | 默认值 | 主键 | 外键 | 枚举说明 | 数据来源 | 负责人 | 更新时间 |
|--------|--------------|----------|------|----------|--------|------|------|----------|----------|--------|----------|
| cust_no | 【待确认】 | VARCHAR | 20 | NOT NULL | - | - | - | 【待确认】 | crmdm.fms_t5_cust_vol.cust_no | 【待确认】 | 2026-07-17 |
| fnc_trans_acct_no | 【待确认】 | VARCHAR | 17 | NOT NULL | - | - | - | 【待确认】 | crmdm.fms_t5_cust_vol.fnc_trans_acct_no | 【待确认】 | 2026-07-17 |
| prod_code | 【待确认】 | VARCHAR | 32 | NOT NULL | - | - | - | 【待确认】 | crmdm.fms_t5_cust_vol.prod_code | 【待确认】 | 2026-07-17 |
| distributor_code | 【待确认】 | VARCHAR | 14 | NOT NULL | '0 '::varchar | - | - | 【待确认】 | crmdm.fms_t5_cust_vol.distributor_code | 【待确认】 | 2026-07-17 |
| self_fnc_acct_no | 【待确认】 | BPCHAR | 12 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_cust_vol.self_fnc_acct_no | 【待确认】 | 2026-07-17 |
| total_vol | 【待确认】 | NUMERIC | 16,2 | NOT NULL | - | - | - | 【待确认】 | crmdm.fms_t5_cust_vol.total_vol | 【待确认】 | 2026-07-17 |
| buy_amt | 【待确认】 | NUMERIC | 16,2 | NOT NULL | - | - | - | 【待确认】 | crmdm.fms_t5_cust_vol.buy_amt | 【待确认】 | 2026-07-17 |
| trans_frozen_vol | 【待确认】 | NUMERIC | 16,2 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_cust_vol.trans_frozen_vol | 【待确认】 | 2026-07-17 |
| abnm_frozen_vol | 【待确认】 | NUMERIC | 16,2 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_cust_vol.abnm_frozen_vol | 【待确认】 | 2026-07-17 |
| redeem_amt | 【待确认】 | NUMERIC | 16,2 | NOT NULL | - | - | - | 【待确认】 | crmdm.fms_t5_cust_vol.redeem_amt | 【待确认】 | 2026-07-17 |
| unconvert_income | 【待确认】 | NUMERIC | 20,6 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_cust_vol.unconvert_income | 【待确认】 | 2026-07-17 |
| convert_income | 【待确认】 | NUMERIC | 20,6 | NOT NULL | - | - | - | 【待确认】 | crmdm.fms_t5_cust_vol.convert_income | 【待确认】 | 2026-07-17 |
| crt_date | 【待确认】 | BPCHAR | 8 | NOT NULL | - | - | - | 【待确认】 | crmdm.fms_t5_cust_vol.crt_date | 【待确认】 | 2026-07-17 |
| crt_time | 【待确认】 | BPCHAR | 6 | NOT NULL | - | - | - | 【待确认】 | crmdm.fms_t5_cust_vol.crt_time | 【待确认】 | 2026-07-17 |
| remark | 【待确认】 | VARCHAR | 255 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_cust_vol.remark | 【待确认】 | 2026-07-17 |
| upd_date | 【待确认】 | BPCHAR | 8 | NOT NULL | - | - | - | 【待确认】 | crmdm.fms_t5_cust_vol.upd_date | 【待确认】 | 2026-07-17 |
| upd_time | 【待确认】 | BPCHAR | 6 | NOT NULL | - | - | - | 【待确认】 | crmdm.fms_t5_cust_vol.upd_time | 【待确认】 | 2026-07-17 |
| cust_manager | 【待确认】 | VARCHAR | 20 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_cust_vol.cust_manager | 【待确认】 | 2026-07-17 |
| fm_manager | 【待确认】 | VARCHAR | 20 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_cust_vol.fm_manager | 【待确认】 | 2026-07-17 |
| last_vol_change_date | 【待确认】 | BPCHAR | 8 | NOT NULL | - | - | - | 【待确认】 | crmdm.fms_t5_cust_vol.last_vol_change_date | 【待确认】 | 2026-07-17 |
| elisor_frozen_vol | 【待确认】 | NUMERIC | 16,2 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_cust_vol.elisor_frozen_vol | 【待确认】 | 2026-07-17 |
| frozen_vol | 【待确认】 | NUMERIC | 16,2 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_cust_vol.frozen_vol | 【待确认】 | 2026-07-17 |
| acc_income | 【待确认】 | NUMERIC | 16,2 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_cust_vol.acc_income | 【待确认】 | 2026-07-17 |
| ryzd | 【待确认】 | VARCHAR | 1 | NULL | - | - | - | 【待确认】 | crmdm.fms_t5_cust_vol.ryzd | 【待确认】 | 2026-07-17 |
