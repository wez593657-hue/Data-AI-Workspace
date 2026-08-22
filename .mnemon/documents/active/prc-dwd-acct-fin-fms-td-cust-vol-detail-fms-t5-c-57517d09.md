---
id: "57517d09-253f-4229-94e0-ba0a7e90ba85"
title: "PRC_DWD_ACCT_FIN 份额表替换改造设计（FMS_TD_CUST_VOL_DETAIL / FMS_T5_CUST_VOL_LIST）"
description: "PRC_DWD_ACCT_FIN 由汇总份额表切换到两张明细份额表的设计方案（评审修正版），含置0规则待确认项。"
status: "active"
created_at: "2026-08-18T09:34:13.603Z"
updated_at: "2026-08-18T09:34:13.603Z"
content_hash: "f73db996a186942c58e19e881df055b3533dc5d04392ae035973ed05f8c342e7"
source_paths:
  - "data_assets/ddl/ods/fms/fms_td_cust_vol_detail.sql"
  - "data_assets/ddl/ods/fms/fms_t5_cust_vol_list.sql"
  - "data_assets/stored_procedure/ods_to_dwd/PRC_DWD_ACCT_FIN.sql"
  - "data_assets/ddl/ods/fms/detail"
session_ids:
  - "94d2dbdd-a77d-4185-8558-de1ecdec88ba"
memory_body_ids:
  []
---

# PRC_DWD_ACCT_FIN 份额表替换改造设计（评审修正版）

## 状态
设计稿（checkpoint 评审后修正），**尚未实施**，等待用户确认关键口径后落地。父会话已按 SOP 先出方案、未改文件；本评审修正了方案中的 3 处缺陷。

## 背景与目标
`data_assets/stored_procedure/ods_to_dwd/PRC_DWD_ACCT_FIN.sql`（v2.0.0，DELETE+INSERT + 到期保留方案）当前以汇总份额表 `FMS_TD_CUST_VOL` / `FMS_T5_CUST_VOL` 为驱动。需切换为两张新明细表：
- `data_assets/ddl/ods/fms/fms_td_cust_vol_detail.sql` → `FMS_TD_CUST_VOL_DETAIL`（OLTP 风格：理财客户份额明细表，一确认一流水）
- `data_assets/ddl/ods/fms/fms_t5_cust_vol_list.sql` → `FMS_T5_CUST_VOL_LIST`（理财客户份额明细表，一交易一流水）

并在过程最后新增规则：**如果记录在 2 张明细份额表中均不存在，则理财余额 FIN_AMT 置 0**。

## 表结构差异（旧汇总 vs 新明细）
- 旧 `FMS_TD_CUST_VOL`（假设按 账户+产品 一行）；新 `FMS_TD_CUST_VOL_DETAIL` 主键 `(FNC_TRANS_ACCT_NO, TA_ACCT_NO, TANO, PROD_CODE, TA_CFM_SERNO)`，**同一账户+产品可有多行**。
- 旧 `FMS_T5_CUST_VOL` 主键 `(PROD_CODE, FNC_TRANS_ACCT_NO, DISTRIBUTOR_CODE)`；新 `FMS_T5_CUST_VOL_LIST` 主键 `(TRANS_SERNO)`，**同一账户+产品可有多行**。
- 关键字段：TD 明细有 `CFM_VOL`（确认份额）、`REMAIN_VOL`（剩余份额含冻结）、`NAV`、`NAV_DATE`、`TA_CFM_SERNO`、`BUSI_CODE` 等；T5 明细有 `VOL`、`REMAIN_VOL`、`USE_VOL`、`FROZEN_VOL`、`TRANS_SERNO`、`BUY_NAV` 等。
- 注意：两个新 DDL 文件非 UTF-8 编码（read 工具报 invalid UTF-8，grep 结果可读）；落库前建议先转码。

## 需修改部分（PRC_DWD_ACCT_FIN）
1. 头注释：来源表清单改为两张明细表；版本号 v2.0.0 → v2.1.0，补变更记录。
2. 步骤2 UNION ALL 两个分支：
   - 2.1 代销分支 `FROM FMS_TD_CUST_VOL cv` → 明细聚合子查询（见修正 A）。
   - 2.2 自营分支 `FROM FMS_T5_CUST_VOL cv` → 明细聚合子查询（见修正 A）。
   - `TOTAL_VOL` 引用全部替换为聚合后的份额字段。
3. 步骤3 之后新增「份额存在性 → 余额置 0」逻辑（见修正 B/C，先与用户确认作用域与判定键）。
4. 步骤编号/日志文案同步更新。

## 评审发现（父方案缺陷，需修正）
### A. 缺聚合，明细表直接替换会产生重复快照行
明细表同一 (账户, 产品) 多行，直接 JOIN 会导致 TMP_DWD_ACCT_FIN_ACTIVE 三键重复、DWD_ACCT_FIN 主键冲突。
修正：驱动表改为聚合子查询
- TD：`GROUP BY FNC_TRANS_ACCT_NO, CUST_NO, TANO, PROD_CODE, SHARE_CLASS`（保留与 FMS_TD_PROD_INFO 的联接键）。
- T5：`GROUP BY FNC_TRANS_ACCT_NO, CUST_NO, PROD_CODE`（与 FMS_T5_PROD_INFO 联接键对齐）。
- `【待确认1】份额口径`：用 `SUM(REMAIN_VOL)`（当前持有，含冻结）还是 `SUM(CFM_VOL)`（确认份额）计算 FIN_AMT 与过滤条件；需与需求确认旧 `TOTAL_VOL` 语义。

### B. 置 0 规则判定键错误
父方案用 `cv.TA_CFM_SERNO = af.PRDKT_ID` / `cv.TRANS_SERNO = af.PRDKT_ID` 判定存在性——PRDKT_ID 是产品编号（REGIST_CODE），流水号 ≠ 产品号，键映射错误。
修正：存在性按 (客户, 账户, 产品) 判定；PRDKT_ID(REGIST_CODE) 需经产品信息表映射回 PROD_CODE：
- TD：`FMS_TD_CUST_VOL_DETAIL` JOIN `FMS_TD_PROD_INFO`（TANO+PROD_CODE+SHARE_CLASS → REGIST_CODE）。
- T5：`FMS_T5_CUST_VOL_LIST` JOIN `FMS_T5_PROD_INFO`（PROD_CODE → REGIST_CODE）。
- `【待确认2】`：是否按 (CUST_NO, FNC_TRANS_ACCT_NO) 账户级判定即可（不映射产品），更贴近「理财余额置 0」的客户维度语义。

### C. 置 0 规则作用域矛盾（语义歧义）
父方案 `WHERE (CUST_ID, ACCT_ID, PRDKT_ID) IN (SELECT ... FROM TMP_DWD_ACCT_FIN_ACTIVE)` 使置 0 永不触发——TMP 本就由明细表构建，命中 TMP 的行必然存在于明细表。
两种候选语义，需用户确认：
- 方案甲（字面语义）：对 DWD_ACCT_FIN 全表，`NOT EXISTS`（TD 明细）AND `NOT EXISTS`（T5 明细）时 FIN_AMT=0；影响范围含保留的到期记录（v2.0.0「保留到期记录供下游识别」行为延续：行保留、余额清零）。
- 方案乙（对齐活跃快照）：对 `NOT IN TMP_DWD_ACCT_FIN_ACTIVE` 的行 FIN_AMT=0，即到期/失效记录余额清零。
- `【待确认3】`：用户原话「如果不存在则置 0」按方案甲实现；但需确认到期保留记录是否参与置 0。

## 建议 SQL 骨架（待确认后定稿）
```sql
-- 步骤3 后、COMMIT 前（或作为独立步骤4）【待确认3 选定作用域】
UPDATE DWD_ACCT_FIN af
   SET FIN_AMT = 0
 WHERE NOT EXISTS ( -- TD 明细存在性（含产品映射，待确认2 是否账户级）
        SELECT 1
          FROM FMS_TD_CUST_VOL_DETAIL d
          JOIN FMS_TD_PROD_INFO p
            ON d.TANO = p.TANO AND d.PROD_CODE = p.PROD_CODE
           AND NVL(d.SHARE_CLASS,'~') = NVL(p.SHARE_CLASS,'~')
         WHERE d.CUST_NO = af.CUST_ID
           AND d.FNC_TRANS_ACCT_NO = af.ACCT_ID
           AND p.REGIST_CODE = af.PRDKT_ID
       )
   AND NOT EXISTS ( -- T5 明细存在性
        SELECT 1
          FROM FMS_T5_CUST_VOL_LIST l
          JOIN FMS_T5_PROD_INFO pi
            ON l.PROD_CODE = pi.PROD_CODE
         WHERE l.CUST_NO = af.CUST_ID
           AND l.FNC_TRANS_ACCT_NO = af.ACCT_ID
           AND pi.REGIST_CODE = af.PRDKT_ID
       );
```
（若按方案乙，将 WHERE 换为 `WHERE (CUST_ID, ACCT_ID, PRDKT_ID) NOT IN (SELECT cust_id, acct_id, prdkt_id FROM TMP_DWD_ACCT_FIN_ACTIVE)`。）

## 验证方法
- 仓库无数据库，只能离线校验：`python -m scripts.harness risk-check standard`、`offline-validate`、`dialect-check`（人大金仓 Oracle 兼容模式）。
- 待数据库可用后：核对 TMP 无三键重复、置 0 行数与明细比对的差异样例。

## 待确认汇总
1. 份额口径：REMAIN_VOL vs CFM_VOL（含过滤 `<>0` 条件）。
2. 置 0 存在性判定粒度：账户+产品 vs 仅账户。
3. 置 0 作用域：全表（含到期保留行）vs 仅 TMP 外行。
