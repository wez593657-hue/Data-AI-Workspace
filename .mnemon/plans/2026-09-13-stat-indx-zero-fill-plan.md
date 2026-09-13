# 补零可见性保障修改方案（prc_ads_stat_indx_data）

> 目标：营销活动（路径08）/目标任务（路径09）分发到机构或客户经理后，
> 目标表 `ADS_STAT_INDX_DATA_MKT` / `ADS_STAT_INDX_DATA` 必须能取到被分发对象
> （机构/客户经理 × 活动/任务 × 指标）的指标行；**指标值为 0 也必须显示**。
> 状态：**修改方案已给出，待确认后实施**（尚未改动任何 SQL 文件）。

## 1. 根因

- `plan_001` 把分发清单完整装入 `TMP_STAT_INDX_SCOPE`（活动/任务 × 机构/经理 × 指标，全笛卡尔）。
- `plan_003~009` 各指标步骤用 INNER JOIN 解析「归属→客户」、INNER JOIN 事实表聚合：
  零客户/零交易的机构与经理在客户解析阶段即被丢弃，`AGGR_003~009` 无其行。
- `plan_010` 仅合并 `AGGR_003~009` 并发布，不感知「被分发但无数据」的组合。
- 结论：**缺口在发布端**。唯一权威的分发清单就是 `TMP_STAT_INDX_SCOPE`，
  在 `plan_010` 合并后、强校验前补零即可全覆盖。

## 2. 修改点（仅 1 个文件、1 处）

**`prc_ads_stat_indx_plan_010.sql`**：紧跟「合并 `_003~_009` → `TMP_STAT_INDX_AGGR_010`」
的 INSERT 之后、`-- 发布前强校验：空值检查` 之前，插入补零 INSERT。

```sql
    -------------------------------------------------------------------------
    -- 补零可见性保障：被分发（机构/客户经理 × 活动/任务 × 指标）但无指标数据的组合，
    -- 落 0 行，确保目标表能取到被分发对象（指标为 0 也显示）；
    -- 范围守卫：仅本流水线指标 0046~0083（与主表幂等删除清单对齐）
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_AGGR_010 (
        path_code, data_date, data_blng, statis_calib, statis_dim,
        indx_code, curnt_val, term_last_val, persn_legal_bk_code
    )
    SELECT s.path_code,                 -- 路径标识（08/09）
           v_sysdat,                    -- 数据日期
           s.data_blng,                -- 数据归属（裸值，已去前缀）
           s.statis_calib,             -- 统计口径（活动号/任务号）
           s.path_code,                -- 统计维度（恒=路径编码）
           s.indx_code,                -- 指标编码
           0,                          -- 当期值补 0
           0,                          -- 上期值补 0
           s.persn_legal_bk_code       -- 法人机构编码
      FROM (SELECT DISTINCT path_code, statis_calib, indx_code, data_blng, persn_legal_bk_code
              FROM TMP_STAT_INDX_SCOPE) s          -- 分发清单（唯一权威来源）
     WHERE s.indx_code >= 'INDX_0046'             -- 指标范围守卫
       AND s.indx_code <= 'INDX_0083'
       AND NOT EXISTS (                          -- 仅补缺失组合
             SELECT 1
               FROM TMP_STAT_INDX_AGGR_010 t
              WHERE t.data_date           = v_sysdat
                AND t.data_blng           = s.data_blng
                AND t.statis_calib        = s.statis_calib
                AND t.statis_dim          = s.path_code
                AND t.indx_code           = s.indx_code
                AND t.persn_legal_bk_code = s.persn_legal_bk_code);
```

同时在文件头变更记录区新增一行：`v1.4 补零可见性保障（TMP_STAT_INDX_SCOPE 驱动）`。

## 3. 关键依据（已核实）

| 事项 | 结论 |
|------|------|
| `TMP_STAT_INDX_SCOPE` 列 | path_code, statis_calib, indx_code, data_blng, blng_type, blng_id, term_begin_date, persn_legal_bk_code（plan_001 装载） |
| scope 生命周期 | plan_001 段首全量刷新；plan_002 末 DELETE term_begin_date=次日（冻结窗口行），到 plan_010 时仅剩「已开始、未结束」对象 |
| data_blng 格式 | v1.2 起去 ORG_/MGR_ 前缀，scope 与 AGGR_010 均为裸值，可直连 |
| 指标全集 | 0046~0083 连续 38 个，与 plan_010 主表删除清单一致（全目录核实） |
| 强校验兼容性 | 补 0 行无 NULL；DISTINCT+NOT EXISTS 防重复，主键校验可通过 |
| 机构树上卷 | 补零行进 raw_aggr 后，机构型归属随 org_closure 上卷，祖先机构同得 0 行；经理型不在机构树，仅自身 0 行 |

## 4. 用户已确认项（2026-09-13）

1. **0 客户显示 0**（非 NULL）——curnt_val/term_last_val 均补 0。
2. **INDX_0081 历史核查：未误删**。现行 `plan_008.sql` 第 193~208 行与 0069 同段计算
   （`INSERT INTO TMP_STAT_INDX_AGGR_008 ... 'INDX_0081'`），由 plan_010 第 87 行合入。
   git 链：`retention_rate.sql`(08-14) → 拆分为 `plan_008.sql`(08-21) → 删旧单体(08-22)，
   计算段全程携带，无删除。plan_010 中出现的 0081 仅是主表幂等删除清单，非指标排除。
   ⚠ 此前答复中「0081 无计算步骤」表述有误，以此为准。
3. **机构编码与客户经理编码不会同值**——data_blng 裸值去重无撞码风险，DISTINCT 直接可用。

## 5. 验证方法

1. `python -m scripts.harness risk-check standard` + `dialect-check`（改动文件）。
2. 逻辑自测：构造「已分发但零客户」机构 + 「已分发但零交易」经理各挂一个活动，
   跑批后 `ADS_STAT_INDX_DATA` 应出现该组合，curnt_val=0，且机构树上卷出祖先 0 行。
3. 回归：有数据对象数值与改前一致（NOT EXISTS 保证不触碰既有汇总行）。

## 6. 风险

- 比率指标（0066/0069/0081）「有客户但分子/分母为0→NULL」的既有行不会被补零覆盖
  （NOT EXISTS 不命中），NULL 语义保留；仅「完全无行」的组合补 0。
- 补零兜「整行缺失」；若属「有客户但某步骤漏算」导致的缺失，补 0 会掩盖真实问题，
  上线前建议用 `unresolved` 排查一次。
