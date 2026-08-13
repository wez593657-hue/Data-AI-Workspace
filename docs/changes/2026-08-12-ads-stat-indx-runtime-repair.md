# PRC_ADS_STAT_INDX_DATA 运行逻辑修复记录

日期：2026-08-12

## 变更内容

| 模块 | 修改 | 预期效果 |
|---|---|---|
| 机构上卷 | 以 `CONNECT_BY_ROOT` 生成祖先机构与后代机构闭包关系，替换无效的机构编码字符串 `INSTR` 判断 | 直接机构结果可正确汇总至全部真实祖先机构；客户经理结果不参与机构上卷 |
| 聚合临时表 | 删除 `TMP_STAT_INDX_AGGR_A/B`，改为 `TMP_STAT_INDX_AGGR`，新增 `PATH_CODE` | 消除相同结构的双表，保留 A/B 路径区分和原有输出统计口径 |
| 月活日期 | `INDX_0067` 上限由当月末改为 `V_SYSDAT` | 月中或历史补跑不统计跑批日后的登录 |
| 开户日期 | 仅接受 `YYYYMMDD`、`YYYY-MM-DD` 两种格式并规范为字符日期比较 | 非法日期不再导致批处理异常，也不进入 0080、0082、0083 统计 |
| 事务与日志 | TMP 清理由 `TRUNCATE` 改为事务内 `DELETE`；移除中间业务提交；步骤成功日志改为最终成功后统一持久化且日志异常不回写业务失败 | 发生异常时可回滚过程 DML，避免日志过程内部提交破坏事务边界 |
| 并发 | 入口为共享 TMP 表加 `ACCESS EXCLUSIVE ... NOWAIT` 事务级排他锁 | 防止同过程并发清空、写入共享 TMP 表和基准表造成竞争 |

## 涉及文件

- `data_assets/stored_procedure/dws_to_ads/PRC_ADS_STAT_INDX_DATA.sql`
- `data_assets/ddl/tmp/tmp_pro_ads_stat_indx_data.ddl`
- `scripts/oracle_validation/indx_data/01_generate_oracle_schema.ps1`
- `scripts/oracle_validation/indx_data/01_setup_tables.sql`
- `scripts/oracle_validation/indx_data/02_convert_proc.ps1`
- `scripts/oracle_validation/indx_data/04_load_full_matrix.sql`
- `scripts/oracle_validation/indx_data/09_run_and_assert_real_schema.sql`
- `scripts/oracle_validation/indx_data/11_invalid_open_date_assert.sql`

## 验证结果

- 已通过 `python scripts/validate_procedure_date_parameters.py`。
- 已通过 `python scripts/validate_cross_layer_consistency.py`。
- 已生成 Oracle 转换副本及测试建表脚本；已补充月中未来登录和非法开户日期断言。
- 未执行真实 Oracle/Kingbase 回归：当前会话未配置可用的测试库连接凭据。Oracle 转换测试不能替代 Kingbase 编译、锁语法与并发行为验证。
