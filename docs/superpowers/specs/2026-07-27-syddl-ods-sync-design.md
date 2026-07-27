# SYDDL 到 ODS DDL 同步设计

## 范围

- 源文件：`data_assets/ddl/SYDDL.ddl.sql`。
- 覆盖：ODS 目录中与源表同名的 133 个现有建表文件。
- 新增：`cms_customer_belong`、`cms_user_info`、`mbk_cust_detail_info`、`crm_sys_post`。
- 目录调整：`data_assets/ddl/ods/mbs` 改为 `data_assets/ddl/ods/mbk`。

## 排除规则

- 不更新或新增 `ADS_`、`DWD_`、`DWS_` 前缀表。
- 不新增任意 `TMP*`、`PRC*` 前缀表。
- 不删除现有 ODS 文件，不恢复已删除的 `ods_sap_customer.sql`。

## 同步规则

- 以源文件中同名表的完整 `CREATE TABLE` 语句为准覆盖 ODS 文件内容。
- 新增表按系统前缀写入 `cms`、`mbk`、`crm` 子目录。
- 输出更新、新增、排除和未匹配表清单，并校验生成文件均含可解析的建表语句。
