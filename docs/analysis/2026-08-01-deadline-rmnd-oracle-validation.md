# 到期承接存储过程本地 Oracle 回放验证报告

日期：2026-08-01
环境：本地 Oracle 11.2.0.1（ORCL 实例），SCOTT 用户
目标：验证 PRC_ADS_CUST_DEADLINE_RMND_DTL / PRC_ADS_CUST_DEADLINE_RMND_STATIS

## 1. 连接测试结果

### 1.1 数据库服务

| 项目 | 状态 |
|---|---|
| OracleServiceORCL（实例服务） | Running |
| OracleDBConsoleorcl | Running |
| 监听器（1521） | 初始未运行，直接启动 TNSLSNR 后正常 |
| 数据库实例 | 可连接，实例名 orcl，主机 m |

### 1.2 连接过程遇到的错误与处理

| 错误 | 原因 | 处理 |
|---|---|---|
| TNS-12541 / TNS-12560 / TNS-00530 | 监听器未启动；`lsnrctl start` 在 11.2.0.1 环境下启动失败 | 直接运行 `tnslsnr LISTENER` 使 1521 正常监听 |
| ORA-12638 | sqlnet.ora 配置 `SQLNET.AUTHENTICATION_SERVICES=(NTS)`，沙箱进程无法获取 Windows 身份令牌 | 临时 TNS_ADMIN 下使用 `(NONE)`，不改系统配置 |
| ORA-01031 | 当前 Windows 用户不在 ORA_DBA 组，`/ as sysdba` 不可用 | 改用 SCOTT 普通账号密码认证 |

### 1.3 最终连接确认

```text
user=SCOTT  db=orcl  service=orcl  host=m  instance=orcl
连接时间 2026-08-01 15:19，基本查询 SELECT 1 FROM dual 通过。
```

SCOTT 权限：CONNECT + RESOURCE + UNLIMITED TABLESPACE，可建表、建过程、插入数据。

## 2. 验证环境搭建

源表、中间表、目标表、日期函数、日志过程均基于工作区 DDL 在 SCOTT 模式创建：

- 源表 9 张：DWD_ACCT_DEPO/FIN/INSUR、DWD_CUST_INDV_INFO、DWD_CUST_MAN、
  DWS_CUST_LVL_INFO、DWS_CUST_ASSE_LIAB、DWD_SYS_ORG、ADS_MKT_REC_INFO
- 中间表 10 张：TMP_CDR_DTL_*（8）、TMP_CDR_STAT_BASE/SRC
- 目标表 2 张：ADS_CUST_DEADLINE_RMND_DTL、ADS_CUST_DEADLINE_RMND_STATIS
- 函数 SYS_FUN_DEAL_DATE（PL/pgSQL 转 PL/SQL）
- 日志过程 SYS_PRC_STEP_LOGS + 日志表 SYS_PRC_STEP_LOG

脚本目录：`scripts/oracle_validation/deadline_rmnd/`

## 3. 测试数据与口径覆盖

跑批日期 V_SYSDAT=20260731，构造样例：

| 样例 | 目的 | 结果 |
|---|---|---|
| C001 存款到期 10 万（20260720）+ 购买定期 9 万、理财 3 万、保险 5 万 | 承接率/长期化产品/保险剔除 | TAKE_RATE=120%，保险不计 TAKE_AMT |
| C001 资产负债表同日 BAL_TYPE='1' 与 '2' 两行 | 多 BAL_TYPE 只取 '1'（口径15） | '2' 行 999999 未参与计算 |
| C002 理财到期 5 万 + 购定期 2 万、理财 4 万 | 理财转定期转化率 | FIN_MATURE_TRAN_FIXED=2 万，FIN_TO_DEPO=40% |
| C003 通知存款（PRDKT_CATE_BIG='04'） | 通知存款过滤 | 未进入到期源 |
| C004 开放式理财（PRDKT_CATE_BIG='1'） | 开放理财过滤 | 未进入到期源 |
| DP005 活期账户 | 活期过滤 | 未进入到期源 |
| C001 营销记录在 30 天窗口内 + 一条窗口外 | 接触状态口径30 | CNTCT_STATE=1（窗口外不干扰） |
| 机构 ORG001←ORG002←ORG003 | 机构层级汇总 | ORG001 汇总含 C001+C002 |
| 客户经理 POST001/POST002 | 经理维度统计 | 各自独立汇总 |

## 4. 执行结果

两过程均编译成功并运行成功（返回码 0），日志表 14 个步骤全部 LOG_FLG=0。

明细表关键行（M 周期）：

| CUST_ID | STATIS_TYP | EXPR_AMT | TAKE_RATE | FIX_DEPO_TAKE_RATE | CNTCT_STATE | UNDTAKE_STATE | 转化金额 |
|---|---|---|---|---|---|---|---|
| C001 | 1 | 100000 | 120 | 90 | 1 | 1 | 定期转理财 30000 |
| C001 | 0 | 100000 | 120 | 0 | 1 | 1 | - |
| C002 | 2 | 50000 | 120 | 0 | 0 | 1 | 理财转定期 20000 |
| C002 | 0 | 50000 | 120 | 0 | 0 | 1 | - |

统计表关键行（ORG001，M 周期）：

| STATIS_TYP | EXPR_CUST_CNT | EXPR_AMT | CUST_UNDTAKE_RATE | DEPO_TO_FIN | INSUR | FIN_TO_DEPO |
|---|---|---|---|---|---|---|
| 0 | 2 | 150000 | 100 | 30 | 33.33 | 40 |
| 1 | 1 | 100000 | 100 | 30 | 0 | 0 |
| 2 | 1 | 50000 | 100 | 0 | 0 | 40 |

手工断言全部一致，口径 15/17/18/23/30 及过滤规则均验证通过。

## 5. 发现的问题

1. **STATIS 源文件存在 SQL 缺陷（阻断级）**：`PRC_ADS_CUST_DEADLINE_RMND_STATIS.sql`
   第 2 段 INSERT 的 SELECT 列表末尾有尾随逗号（`NVL(a.CURR_AUM_BAL, 0),` 后直接 `FROM`），
   Kingbase 上同样无法编译，静态校验未覆盖。验证副本已修复，需同步修复源文件。
2. **Oracle 11g 标识符超长（平台适配）**：
   - 过程名 PRC_ADS_CUST_DEADLINE_RMND_STATIS（33 字符）→ Oracle 版改名
     PRC_ADS_CUST_DEADLINE_RMND_ST（30 字符）
   - 列名 FIXED_FIN_MATURE_TRAN_INSUR_AMT（31 字符）→ Oracle 版改名
     FIXED_FIN_TRAN_INSUR_AMT（24 字符）
   - DDL 的 `IF NOT EXISTS` 语法需转换为标准 CREATE TABLE
3. **TAKE_RATE 可超 100%**：样例为 120%（同客户窗口内购买多产品），当前实现无上限，
   是否限制需业务确认。

## 6. 建议

1. 修复 STATIS 源文件尾随逗号缺陷，并补充真实编译检查（Kingbase 编译两过程）。
2. Oracle 目标库若部署，需执行标识符改名映射（见上），并保持 DDL/过程/映射文档同步。
3. 建议将本验证脚本纳入 `scripts/oracle_validation/` 作为可重复回放样例。

## 7. 流程确认（依据 docs/standards/oracle-local-testing-policy.md 第 6 节）

本次测试执行前的强制确认结果（追溯确认）：

| 确认项 | 结果 |
|---|---|
| 1. 测试产物目录为 scripts/oracle_validation/deadline_rmnd/，与 data_assets/ 物理隔离 | 通过 |
| 2. 数据库测试对象 schema 为 SCOTT，无 crmdm. 前缀引用 | 通过 |
| 3. 未对 data_assets/ 及已确认文件执行任何写操作 | 通过（源文件仅只读引用） |
| 4. 转换脚本仅输出到测试目录，不写回源文件 | 通过 |
| 5. 新发现缺陷已完成登记（DEFECTS.md，状态待审核） | 通过（3 条） |
| 6. 涉及数据资产修改的请求均处于已确认状态 | 不适用（未发起修改请求） |

缺陷处理决策等待用户审核确认，见 `scripts/oracle_validation/deadline_rmnd/DEFECTS.md`。

### 流程合规事件披露（强制报告）

核查中发现 `data_assets/stored_procedure/dws_to_ads/PRC_ADS_CUST_DEADLINE_RMND_STATIS.sql`
工作区文件存在未确认变更（2026-08-01 15:44:23，删除 SELECT 列表尾随逗号，与
DEFECT-2026-08-01-001 建议修复一致；同目录 13:50 备份与 git HEAD 一致）。
本次测试的转换脚本未写入 `data_assets/`，修改来源待用户确认。详细记录见
`scripts/oracle_validation/deadline_rmnd/DEFECTS.md` 的"变更状态核查"。

**后续确认（2026-08-01）**：用户确认该修改为本人手动执行，合规事件关闭。
缺陷处理决策回填：DEFECT-001 手动处理（已修复）；DEFECT-002/003 不修复。
台账状态均更新为"已关闭"。
