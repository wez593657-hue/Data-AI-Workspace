# 存储过程目录

## 目录结构

```
stored_procedure/
├── ods_to_dwd/     # ODS层到DWD层的数据转换存储过程
├── dwd_to_dws/     # DWD层到DWS层的数据聚合存储过程
└── dws_to_ads/     # DWS层到ADS层的业务报表存储过程
```

## 命名规范

存储过程命名格式：`pro_{结果表}.sql`

| 层 | 示例 |
|----|------|
| DWD层 | `pro_dwd_cust_indv_info.sql` |
| DWS层 | `pro_dws_cust_deadline_rmnd.sql` |
| ADS层 | `pro_ads_cust_deadline_rmnd_dtl.sql` |

## 开发规范

参考文档: `docs/05_Stored_Procedure.md`

## 文件格式

- 文件后缀: `.sql`
- 编码格式: UTF-8
- 每个文件包含一个存储过程

## 目录说明

| 目录 | 用途 | 示例文件 |
|------|------|----------|
| ods_to_dwd | ODS原始数据清洗转换到DWD | `pro_dwd_cust_indv_info.sql` |
| dwd_to_dws | DWD明细数据聚合到DWS | `pro_dws_cust_deadline_rmnd.sql` |
| dws_to_ads | DWS汇总数据生成ADS报表 | `pro_ads_cust_deadline_rmnd_dtl.sql` |
