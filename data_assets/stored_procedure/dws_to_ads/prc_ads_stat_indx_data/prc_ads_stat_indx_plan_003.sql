-------------------------------------------------------------------------
-- 存储过程: CRMDM.PRC_ADS_STAT_INDX_PLAN_003
-- 功能说明: 指标数据统计——步骤3（余额预聚合与各指标增量写入汇总表）
-- 参数说明:
--   V_SYSDAT IN  VARCHAR2   跑批业务日期 YYYYMMDD
--   OUTCDE   OUT INTEGER    处理行数
-- 需求版本: v4.7 (2026-08-25)
-- 变更记录:
--   v4.7 AGGR汇总表拆分：写入专属表 TMP_STAT_INDX_AGGR_003，段首自清（并行跑批隔离）
--   v4.6 0047基数缺失时增量与期初值置NULL；0050/0051基准改为基数表
--        ADS_STAT_INDX_BASELINE_SUM（活动前一日冻结/存量补跑）；
--        删除HIS直取的prev_yr_avg_aum/prev_mth_avg_aum及V_YAR_PREV_END
-------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE crmdm.prc_ads_stat_indx_plan_003(
    v_sysdat  IN  VARCHAR2,   -- 跑批业务日期 YYYYMMDD
    outcde OUT INTEGER     -- 处理行数
) AS
    V_PRC_DESC   VARCHAR2(100) := '指标数据统计步骤3';   -- 过程描述，用于日志
    V_PRC_NAME   VARCHAR2(32)  := 'PRC_ADS_STAT_INDX_PLAN_003';   -- 过程名称，用于日志
    V_LOG_MSG    VARCHAR2(4000);  -- 日志消息
    V_LOG_FLG    INTEGER;         -- 日志标志（0成功/-1失败）
    V_LOG_BUTTON INTEGER := 1;    -- 日志按钮，1启用步骤日志
    V_NO_ID      VARCHAR2(10);    -- 日志序号标识
    V_BGN_DATE   DATE;            -- 过程开始时间
    V_END_DATE   DATE;            -- 过程结束时间
    V_DURA_DATE  INTEGER;         -- 过程耗时（秒）
    V_MTH_BEGIN    VARCHAR2(8);   -- 当月月初
    V_MTH_END      VARCHAR2(8);   -- 上月月末
    V_QRT_END      VARCHAR2(8);   -- 上季末
    V_YAR_BEGIN    VARCHAR2(8);   -- 当年初
BEGIN
    -------------------------------------------------------------------------
    -- 标准模板：参数校验与开始日志状态
    -------------------------------------------------------------------------
    V_NO_ID := '0';   -- 初始化日志序号
    V_BGN_DATE := SYSDATE;   -- 记录过程开始时间
    IF v_sysdat IS NULL OR NOT REGEXP_LIKE(v_sysdat, '^[0-9]{8}$') THEN   -- 校验业务日期为非空8位数字
        RAISE_APPLICATION_ERROR(-20001, 'V_SYSDAT必须为YYYYMMDD格式');   -- 格式非法报错
    END IF;

    -- 段首自清：本过程专属汇总临时表，防止重跑/并行残留
    DELETE FROM TMP_STAT_INDX_AGGR_003;

    V_END_DATE := TO_DATE(v_sysdat, 'YYYYMMDD');   -- 业务日期字符串转日期型

    -------------------------------------------------------------------------
    -- 初始化日期边界
    -------------------------------------------------------------------------
    V_MTH_BEGIN    := sys_fun_deal_date(v_sysdat, 9);   -- 当月月初
    V_MTH_END      := sys_fun_deal_date(v_sysdat, 2);   -- 上月月末
    V_QRT_END      := sys_fun_deal_date(v_sysdat, 3);   -- 上季末
    V_YAR_BEGIN    := sys_fun_deal_date(v_sysdat, 13);   -- 当年初

    -------------------------------------------------------------------------
    -- 4.1 余额预聚合到 TMP_STAT_INDX_BAL_AGGR
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_BAL_AGGR (
        path_code, statis_dim, data_blng, persn_legal_bk_code,   -- 路径编码, 统计维度, 归属机构, 法人行号
        curnt_aum, yr_begin_aum, mth_end_aum, qrt_end_aum,   -- 当期AUM, 年期初AUM, 月期末AUM, 季期末AUM
        curnt_yr_avg_aum, curnt_mth_avg_aum   -- 当年日均AUM, 当月日均AUM
    )
    WITH base_scope AS (
        SELECT DISTINCT path_code, statis_dim, data_blng,   -- 路径编码, 统计维度, 归属机构
               blng_type, blng_id, persn_legal_bk_code   -- 归属类型, 归属ID, 法人行号
          FROM TMP_STAT_INDX_SCOPE   -- 指标统计范围表
         WHERE indx_code IN ('INDX_0046','INDX_0047','INDX_0048',   -- 仅取存款类AUM相关指标
                             'INDX_0049','INDX_0050','INDX_0051') -- 承上：其余存款类AUM指标
           AND (indx_code <> 'INDX_0047' OR blng_type = 'O')   -- INDX_0047 仅机构维度口径
    ),
    scope_member AS (
        -- A路径：营销活动成员
        SELECT s.path_code, s.statis_dim, s.data_blng,   -- 路径编码, 统计维度, 归属机构
               ti.cust_id, s.persn_legal_bk_code   -- 客户ID, 法人行号
          FROM base_scope s   -- 复用统计范围CTE
         INNER JOIN DWD_MKT_TSK_INFO ti   -- 营销任务信息表
            ON s.path_code             = 'A'   -- 限定A路径
           AND ti.mkt_act_id           = s.statis_dim   -- 任务活动ID=统计维度
           AND ti.persn_legal_bk_code  = s.persn_legal_bk_code   -- 法人行号一致
           AND ti.data_date            = v_sysdat   -- 任务数据日期=跑批日期
           AND ((s.blng_type = 'O' AND ti.mkt_persn_org = s.blng_id)   -- 机构口径按机构归属匹配
             OR (s.blng_type = 'M' AND ti.mkt_persn     = s.blng_id))   -- 客户经理口径按客户经理匹配

        UNION

        -- B路径-机构归属
        SELECT s.path_code, s.statis_dim, s.data_blng,   -- 路径编码, 统计维度, 归属机构
               lv.cust_id, s.persn_legal_bk_code   -- 客户ID, 法人行号
          FROM base_scope s   -- 复用统计范围CTE
         INNER JOIN DWS_CUST_LVL_INFO lv   -- 客户层级信息表
            ON s.path_code             = 'B'   -- 限定B路径
           AND s.blng_type             = 'O'   -- 只取机构口径
           AND lv.org_id               = s.blng_id   -- 客户所属机构=归属ID
           AND lv.persn_legal_bk_code  = s.persn_legal_bk_code   -- 法人行号一致
           AND lv.data_date            = v_sysdat   -- 数据日期=跑批日期

        UNION

        -- B路径-客户经理归属
        SELECT s.path_code, s.statis_dim, s.data_blng,   -- 路径编码, 统计维度, 归属机构
               cm.cust_id, s.persn_legal_bk_code   -- 客户ID, 法人行号
          FROM base_scope s   -- 复用统计范围CTE
         INNER JOIN DWD_CUST_MAN cm   -- 客户管户关系表
            ON s.path_code             = 'B'   -- 限定B路径
           AND s.blng_type             = 'M'   -- 只取客户经理口径
           AND cm.mngr_post_id         = s.blng_id   -- 管户经理岗位ID=归属ID
           AND cm.mng_typ              = '1'   -- 主管类型1（主管户）
           AND cm.persn_legal_bk_code  = s.persn_legal_bk_code   -- 法人行号一致
    )
    SELECT sm.path_code,   -- 路径编码
           sm.statis_dim,   -- 统计维度
           sm.data_blng,   -- 归属机构
           sm.persn_legal_bk_code,   -- 法人行号
           SUM(NVL(b.curnt_aum, 0))         AS curnt_aum,   -- 当期AUM合计=存款余额(type1)
           SUM(NVL(hb.yr_begin_aum, 0))     AS yr_begin_aum,   -- 年期初AUM合计
           SUM(NVL(hb.mth_end_aum, 0))      AS mth_end_aum,   -- 月期末AUM合计
           SUM(NVL(hb.qrt_end_aum, 0))      AS qrt_end_aum,   -- 季期末AUM合计
           SUM(NVL(b.curnt_yr_avg_aum, 0))  AS curnt_yr_avg_aum,   -- 当年日均AUM合计
           SUM(NVL(b.curnt_mth_avg_aum, 0)) AS curnt_mth_avg_aum   -- 当月日均AUM合计
      FROM scope_member sm   -- 成员明细CTE
      LEFT JOIN (
          SELECT cust_id,   -- 客户ID
                 persn_legal_bk_code,   -- 法人行号
                 SUM(CASE WHEN bal_type = '1' THEN NVL(depo_bal, 0) ELSE 0 END) AS curnt_aum,   -- 存款余额(type1)=当期AUM
                 SUM(CASE WHEN bal_type = '4' THEN NVL(depo_bal, 0) ELSE 0 END) AS curnt_yr_avg_aum,   -- 当年日均存款(type4)
                 SUM(CASE WHEN bal_type = '2' THEN NVL(depo_bal, 0) ELSE 0 END) AS curnt_mth_avg_aum   -- 当月日均存款(type2)
            FROM DWS_CUST_ASSE_LIAB   -- 客户资产负债表（当日）
           WHERE data_date = v_sysdat   -- 取跑批日数据
             AND EXISTS (SELECT 1 FROM scope_member sm2   -- 成员明细CTE2   -- 仅统计范围内客户
                          WHERE sm2.cust_id = DWS_CUST_ASSE_LIAB.cust_id   -- 匹配客户ID
                            AND sm2.persn_legal_bk_code = DWS_CUST_ASSE_LIAB.persn_legal_bk_code)   -- 匹配法人行号
           GROUP BY cust_id, persn_legal_bk_code
      ) b
        ON b.cust_id             = sm.cust_id   -- 按客户ID关联
       AND b.persn_legal_bk_code = sm.persn_legal_bk_code   -- 法人行号一致
      LEFT JOIN (
          SELECT cust_id,   -- 客户ID
                 persn_legal_bk_code,   -- 法人行号
                 SUM(CASE WHEN data_date = V_YAR_BEGIN   -- 年初日
                            AND bal_type = '1' THEN NVL(depo_bal, 0) ELSE 0 END) AS yr_begin_aum,   -- 年期初存款余额
                 SUM(CASE WHEN data_date = V_MTH_END   -- 月末日
                            AND bal_type = '1' THEN NVL(depo_bal, 0) ELSE 0 END) AS mth_end_aum,   -- 月期末存款余额
                 SUM(CASE WHEN data_date = V_QRT_END   -- 季末日
                            AND bal_type = '1' THEN NVL(depo_bal, 0) ELSE 0 END) AS qrt_end_aum   -- 季期末存款余额
            FROM DWS_CUST_ASSE_LIAB_HIS   -- 客户资产负债历史表
           WHERE data_date IN (V_YAR_BEGIN, V_MTH_END, V_QRT_END)   -- 取年初/月末/季末时点
             AND EXISTS (SELECT 1 FROM scope_member sm2   -- 成员明细CTE2   -- 仅统计范围内客户
                          WHERE sm2.cust_id = DWS_CUST_ASSE_LIAB_HIS.cust_id   -- 匹配客户ID
                            AND sm2.persn_legal_bk_code = DWS_CUST_ASSE_LIAB_HIS.persn_legal_bk_code)   -- 匹配法人行号
           GROUP BY cust_id, persn_legal_bk_code
      ) hb
        ON hb.cust_id             = sm.cust_id   -- 按客户ID关联
       AND hb.persn_legal_bk_code = sm.persn_legal_bk_code   -- 法人行号一致
     GROUP BY sm.path_code, sm.statis_dim, sm.data_blng, sm.persn_legal_bk_code;   -- 按路径/维度/机构/法人行汇总

    -------------------------------------------------------------------------
    -- 4.2 标准期间增量写入（INDX_0046/0048/0049/0050/0051）- A路径
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_AGGR_003 (
        path_code, data_date, data_blng, statis_dim, statis_calib,   -- 路径, 数据日期, 归属机构, 统计维度, 统计口径
        indx_code, curnt_val, term_last_val, persn_legal_bk_code   -- 指标编码, 当期值, 上期值, 法人行号
    )
    SELECT 'A', v_sysdat, s.data_blng, s.statis_dim, '营销活动', s.indx_code,   -- 路径A/数据日期/归属机构/统计维度/口径/指标编码
           CASE s.indx_code -- 按指标编码取当期标准期间增量
               WHEN 'INDX_0046' THEN b.curnt_aum - b.yr_begin_aum   -- 当年存款新增=当期-年期初
               WHEN 'INDX_0048' THEN b.curnt_aum - b.mth_end_aum   -- 当月存款新增=当期-月期初(上月末)
               WHEN 'INDX_0049' THEN b.curnt_aum - b.qrt_end_aum   -- 当季存款新增=当期-季期初(上季末)
               WHEN 'INDX_0050' THEN b.curnt_yr_avg_aum - bs.base_yr_avg_depo   -- 当年日均存款增量=当期日均-年度基数日均
               WHEN 'INDX_0051' THEN b.curnt_mth_avg_aum - bs.base_mth_avg_depo   -- 当月日均存款增量=当期日均-月份基数日均
           END,
           CASE s.indx_code -- 按指标编码取对应上期值
               WHEN 'INDX_0046' THEN b.yr_begin_aum   -- 上期值=年期初
               WHEN 'INDX_0048' THEN b.mth_end_aum   -- 上期值=月期初
               WHEN 'INDX_0049' THEN b.qrt_end_aum   -- 上期值=季期初
               WHEN 'INDX_0050' THEN bs.base_yr_avg_depo   -- 上期值=年度基数日均
               WHEN 'INDX_0051' THEN bs.base_mth_avg_depo   -- 上期值=月份基数日均
           END,
           s.persn_legal_bk_code -- 法人行号
      FROM TMP_STAT_INDX_SCOPE s   -- 指标统计范围表
     INNER JOIN TMP_STAT_INDX_BAL_AGGR b   -- 余额预聚合表
        ON b.path_code           = 'A'   -- 只取A路径余额
       AND b.statis_dim          = s.statis_dim   -- 统计维度一致
       AND b.data_blng           = s.data_blng   -- 归属机构一致
       AND b.persn_legal_bk_code = s.persn_legal_bk_code   -- 法人行号一致
      LEFT JOIN ADS_STAT_INDX_BASELINE_SUM bs   -- 指标存款基数汇总表
        ON bs.statis_calib        = '营销活动'   -- 统计口径=营销活动
       AND bs.statis_dim          = s.statis_dim   -- 统计维度一致
       AND bs.indx_code           = s.indx_code   -- 指标编码一致
       AND bs.data_blng           = s.data_blng   -- 归属机构一致
       AND bs.persn_legal_bk_code = s.persn_legal_bk_code   -- 法人行号一致
     WHERE s.path_code = 'A'   -- 仅A路径
       AND s.indx_code IN ('INDX_0046','INDX_0048','INDX_0049','INDX_0050','INDX_0051');   -- 仅标准期间指标

    -------------------------------------------------------------------------
    -- 4.2 标准期间增量写入（INDX_0046/0048/0049/0050/0051）- B路径
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_AGGR_003 (
        path_code, data_date, data_blng, statis_dim, statis_calib,   -- 路径, 数据日期, 归属机构, 统计维度, 统计口径
        indx_code, curnt_val, term_last_val, persn_legal_bk_code   -- 指标编码, 当期值, 上期值, 法人行号
    )
    SELECT 'B', v_sysdat, s.data_blng, s.statis_dim, '目标任务', s.indx_code,
           CASE s.indx_code -- 按指标编码取当期标准期间增量
               WHEN 'INDX_0046' THEN b.curnt_aum - b.yr_begin_aum   -- 当年存款新增=当期-年期初
               WHEN 'INDX_0048' THEN b.curnt_aum - b.mth_end_aum   -- 当月存款新增=当期-月期初
               WHEN 'INDX_0049' THEN b.curnt_aum - b.qrt_end_aum   -- 当季存款新增=当期-季期初
               WHEN 'INDX_0050' THEN b.curnt_yr_avg_aum - bs.base_yr_avg_depo   -- 当年日均存款增量
               WHEN 'INDX_0051' THEN b.curnt_mth_avg_aum - bs.base_mth_avg_depo   -- 当月日均存款增量
           END,
           CASE s.indx_code -- 按指标编码取对应上期值
               WHEN 'INDX_0046' THEN b.yr_begin_aum   -- 上期值=年期初
               WHEN 'INDX_0048' THEN b.mth_end_aum   -- 上期值=月期初
               WHEN 'INDX_0049' THEN b.qrt_end_aum   -- 上期值=季期初
               WHEN 'INDX_0050' THEN bs.base_yr_avg_depo   -- 上期值=年度基数日均
               WHEN 'INDX_0051' THEN bs.base_mth_avg_depo   -- 上期值=月份基数日均
           END,
           s.persn_legal_bk_code -- 法人行号
      FROM TMP_STAT_INDX_SCOPE s   -- 指标统计范围表
     INNER JOIN TMP_STAT_INDX_BAL_AGGR b   -- 余额预聚合表
        ON b.path_code           = 'B'   -- 只取B路径余额
       AND b.statis_dim          = s.statis_dim   -- 统计维度一致
       AND b.data_blng           = s.data_blng   -- 归属机构一致
       AND b.persn_legal_bk_code = s.persn_legal_bk_code   -- 法人行号一致
      LEFT JOIN ADS_STAT_INDX_BASELINE_SUM bs   -- 指标存款基数汇总表
        ON bs.statis_calib        = '目标任务'   -- 统计口径=目标任务
       AND bs.statis_dim          = s.statis_dim   -- 统计维度一致
       AND bs.indx_code           = s.indx_code   -- 指标编码一致
       AND bs.data_blng           = s.data_blng   -- 归属机构一致
       AND bs.persn_legal_bk_code = s.persn_legal_bk_code   -- 法人行号一致
     WHERE s.path_code = 'B'   -- 仅B路径
       AND s.indx_code IN ('INDX_0046','INDX_0048','INDX_0049','INDX_0050','INDX_0051');   -- 仅标准期间指标

    -------------------------------------------------------------------------
    -- 4.3 存款基数扣减指标 INDX_0047 - A路径（仅机构维度）
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_AGGR_003 (
        path_code, data_date, data_blng, statis_dim, statis_calib,   -- 路径, 数据日期, 归属机构, 统计维度, 统计口径
        indx_code, curnt_val, term_last_val, persn_legal_bk_code   -- 指标编码, 当期值, 上期值, 法人行号
    )
    SELECT 'A', v_sysdat, s.data_blng, s.statis_dim, '营销活动', 'INDX_0047',   -- 路径A/数据日期/归属机构/统计维度/口径/固定指标0047
           CASE WHEN SUM(v.value_init) IS NULL THEN NULL   -- 基数缺失时当期值置NULL
                ELSE b.curnt_aum - SUM(NVL(v.value_init, 0)) END,   -- 指标当期值=当期AUM-存款基数
           SUM(v.value_init),   -- 上期值=存款基数合计
           s.persn_legal_bk_code -- 法人行号
      FROM TMP_STAT_INDX_SCOPE s   -- 指标统计范围表
     INNER JOIN TMP_STAT_INDX_BAL_AGGR b   -- 余额预聚合表
        ON b.path_code           = 'A'   -- 只取A路径余额
       AND b.statis_dim          = s.statis_dim   -- 统计维度一致
       AND b.data_blng           = s.data_blng   -- 归属机构一致
       AND b.persn_legal_bk_code = s.persn_legal_bk_code   -- 法人行号一致
      LEFT JOIN DWD_DEPO_VALUE_INIT v   -- 存款基数初始化表
        ON v.org_id = s.blng_id   -- 按机构ID关联
     WHERE s.path_code = 'A'   -- 仅A路径
       AND s.blng_type = 'O'   -- 仅机构口径
       AND s.indx_code = 'INDX_0047'   -- 仅存款基数扣减指标
     GROUP BY s.data_blng, s.statis_dim, b.curnt_aum, s.persn_legal_bk_code;   -- 按维度/机构/当期AUM/法人行聚合

    -------------------------------------------------------------------------
    -- 4.3 存款基数扣减指标 INDX_0047 - B路径（仅机构维度）
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_AGGR_003 (
        path_code, data_date, data_blng, statis_dim, statis_calib,   -- 路径, 数据日期, 归属机构, 统计维度, 统计口径
        indx_code, curnt_val, term_last_val, persn_legal_bk_code   -- 指标编码, 当期值, 上期值, 法人行号
    )
    SELECT 'B', v_sysdat, s.data_blng, s.statis_dim, '目标任务', 'INDX_0047',   -- 路径B/数据日期/归属机构/统计维度/口径/固定指标0047
           CASE WHEN SUM(v.value_init) IS NULL THEN NULL   -- 基数缺失时当期值置NULL
                ELSE b.curnt_aum - SUM(NVL(v.value_init, 0)) END,   -- 指标当期值=当期AUM-存款基数
           SUM(v.value_init),   -- 上期值=存款基数合计
           s.persn_legal_bk_code -- 法人行号
      FROM TMP_STAT_INDX_SCOPE s   -- 指标统计范围表
     INNER JOIN TMP_STAT_INDX_BAL_AGGR b   -- 余额预聚合表
        ON b.path_code           = 'B'   -- 只取B路径余额
       AND b.statis_dim          = s.statis_dim   -- 统计维度一致
       AND b.data_blng           = s.data_blng   -- 归属机构一致
       AND b.persn_legal_bk_code = s.persn_legal_bk_code   -- 法人行号一致
      LEFT JOIN DWD_DEPO_VALUE_INIT v   -- 存款基数初始化表
        ON v.org_id = s.blng_id   -- 按机构ID关联
     WHERE s.path_code = 'B'   -- 仅B路径
       AND s.blng_type = 'O'   -- 仅机构口径
       AND s.indx_code = 'INDX_0047'   -- 仅存款基数扣减指标
     GROUP BY s.data_blng, s.statis_dim, b.curnt_aum, s.persn_legal_bk_code;   -- 按维度/机构/当期AUM/法人行聚合

    -------------------------------------------------------------------------
    -- 收尾：本次处理行数回填、提交并记录步骤日志
    -------------------------------------------------------------------------
    outcde := SQL%ROWCOUNT;   -- 返回最近DML影响行数
    COMMIT;   -- 提交事务
    V_END_DATE := SYSDATE;   -- 记录过程结束时间
    V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 86400);   -- 计算过程耗时秒数
    V_LOG_MSG := '步骤3处理完成，行数=' || NVL(outcde, 0);   -- 组装成功日志消息
    V_LOG_FLG := 0;   -- 日志标志置成功
    SYS_PRC_STEP_LOGS(v_sysdat, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);   -- 记录步骤日志

    -------------------------------------------------------------------------
    -- 异常处理：回滚并记录错误日志后重抛
    -------------------------------------------------------------------------
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;   -- 异常回滚事务
        outcde := -1;   -- 输出行数置-1表示失败
        V_END_DATE := SYSDATE;   -- 记录异常结束时间
        V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 86400);   -- 计算过程耗时秒数
        V_LOG_MSG := SUBSTR(SQLERRM, 1, 1000);   -- 截取错误信息
        V_LOG_FLG := -1;   -- 日志标志置失败
        SYS_PRC_STEP_LOGS(v_sysdat, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);   -- 记录错误日志
        RAISE;   -- 重新抛出异常
END prc_ads_stat_indx_plan_003;