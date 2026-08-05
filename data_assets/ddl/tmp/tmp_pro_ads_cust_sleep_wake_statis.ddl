-- ============================================================
-- 睡眠户唤醒统计存储过程临时表建表语句（整合文件）
-- 存储过程名称: PRC_ADS_CUST_SLEEP_WAKE_STATIS
-- 需求版本: v2.12.1
-- 变更记录:
--   v2.10.0 2026-07-30 初始整合（TMP_ADS_SLEEP_ORG_HIER/TMP_ADS_SLEEP_STAT_SRC）
--   v2.12.1 2026-08-04 F-6 步骤编号规范化（TMP1→1/TMP2→TMP1/3→2）
-- 部署说明: 本文件包含该存储过程全部相关临时表定义，可直接在Kingbase
--           (Oracle兼容模式)中整体执行部署，支持IF NOT EXISTS幂等创建。
-- ============================================================

-- ============================================================
-- 1. TMP_ADS_SLEEP_ORG_HIER — 机构层级预物化表
-- 对应步骤: TMP1（机构递归层级）
-- 用途: 预物化CONNECT BY机构递归结果（叶子机构→全部祖先机构，含自身），
--       供TMP1步骤INSERT机构维度统计源时JOIN使用，
--       避免在INSERT子查询中重复执行递归（O-04优化）。
-- 数据来源: DWD_SYS_ORG, ADS_CUST_SLEEP_WAKE_DTL
-- ============================================================
CREATE TABLE IF NOT EXISTS TMP_ADS_SLEEP_ORG_HIER (
    LEAF_ORG_ID     VARCHAR(7),     -- 叶子机构（网点级机构）
    ANCESTOR_ORG_ID VARCHAR(7)      -- 祖先机构（含自身，向上汇总目标）
);

-- ============================================================
-- 2. TMP_ADS_SLEEP_STAT_SRC — 统计源数据临时表
-- 对应步骤: TMP1（展开机构+客户经理维度）
-- 用途: 存储展开机构递归汇总和客户经理维度的统计源数据，
--       供目标表写入步骤按统计对象汇总计数。
-- 数据来源: ADS_CUST_SLEEP_WAKE_DTL, TMP_ADS_SLEEP_ORG_HIER
-- ============================================================
CREATE TABLE IF NOT EXISTS TMP_ADS_SLEEP_STAT_SRC (
    PERSN_LEGAL_BK_CODE VARCHAR(4),
    DATA_DATE VARCHAR(8),
    STATIS_CYCLE VARCHAR(2),
    STATIS_OBJ VARCHAR(20),
    CNTCT_STATE VARCHAR(1),
    WAKE_STATE VARCHAR(1)
);

COMMENT ON TABLE TMP_ADS_SLEEP_STAT_SRC IS '睡眠户统计源数据临时表';
COMMENT ON COLUMN TMP_ADS_SLEEP_STAT_SRC.PERSN_LEGAL_BK_CODE IS '法人行号';
COMMENT ON COLUMN TMP_ADS_SLEEP_STAT_SRC.DATA_DATE IS '数据日期';
COMMENT ON COLUMN TMP_ADS_SLEEP_STAT_SRC.STATIS_CYCLE IS '统计周期(M=月度)';
COMMENT ON COLUMN TMP_ADS_SLEEP_STAT_SRC.STATIS_OBJ IS '统计对象(机构编号或客户经理编号)';
COMMENT ON COLUMN TMP_ADS_SLEEP_STAT_SRC.CNTCT_STATE IS '接触状态(0未接触/1已接触)';
COMMENT ON COLUMN TMP_ADS_SLEEP_STAT_SRC.WAKE_STATE IS '唤醒状态(0未唤醒/1已唤醒)';
