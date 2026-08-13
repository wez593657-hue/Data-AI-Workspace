CREATE OR REPLACE PROCEDURE crmdm.prc_ads_stat_indx_org_rollup_publish(
    v_sysdat  IN  VARCHAR2,   -- 跑批业务日期
    o_row_cnt OUT INTEGER     -- 处理行数
) AS
    V_INVALID_CNT   INTEGER;
    V_DUPLICATE_CNT INTEGER;
BEGIN
    -------------------------------------------------------------------------
    -- 发布前强校验：空值检查
    -------------------------------------------------------------------------
    SELECT COUNT(*) INTO V_INVALID_CNT
      FROM TMP_STAT_INDX_AGGR
     WHERE data_date           IS NULL
        OR data_blng           IS NULL
        OR statis_dim          IS NULL
        OR indx_code           IS NULL
        OR persn_legal_bk_code IS NULL;

    -------------------------------------------------------------------------
    -- 发布前强校验：重复主键检查
    -------------------------------------------------------------------------
    SELECT COUNT(*) INTO V_DUPLICATE_CNT
      FROM (
          SELECT data_date, data_blng, statis_dim, statis_calib,
                 indx_code, persn_legal_bk_code
            FROM TMP_STAT_INDX_AGGR
           GROUP BY data_date, data_blng, statis_dim, statis_calib,
                    indx_code, persn_legal_bk_code
          HAVING COUNT(*) > 1
      );

    IF V_INVALID_CNT > 0 OR V_DUPLICATE_CNT > 0 THEN
        RAISE_APPLICATION_ERROR(-20002,
            '结果数据集发布前强校验失败: 非法结果行数=' || V_INVALID_CNT ||
            ', 重复主键组数=' || V_DUPLICATE_CNT);
    END IF;

    -------------------------------------------------------------------------
    -- 删除当日旧数据
    -------------------------------------------------------------------------
    DELETE FROM ADS_STAT_INDX_DATA WHERE data_date = v_sysdat;

    -------------------------------------------------------------------------
    -- 机构树上卷 + 原子发布
    -------------------------------------------------------------------------
    INSERT INTO ADS_STAT_INDX_DATA (
        indx_code, data_blng, statis_dim, statis_calib,
        curnt_val, term_last_val, data_date, persn_legal_bk_code
    )
    WITH raw_aggr AS (
        SELECT data_date, data_blng, statis_dim, statis_calib,
               indx_code, curnt_val, term_last_val, persn_legal_bk_code
          FROM TMP_STAT_INDX_AGGR
    ),
    org_closure AS (
        SELECT CONNECT_BY_ROOT org_id AS ancestor_org_id,
               org_id                AS descendant_org_id
          FROM DWD_SYS_ORG
         START WITH org_id IS NOT NULL
       CONNECT BY NOCYCLE PRIOR org_id = sup_org_id
               AND LEVEL < 20
    ),
    org_rolled_up AS (
        SELECT r.data_date,
               'ORG_' || c.ancestor_org_id AS data_blng,
               r.statis_dim,
               r.statis_calib,
               r.indx_code,
               SUM(r.curnt_val)      AS curnt_val,
               SUM(r.term_last_val)  AS term_last_val,
               r.persn_legal_bk_code
          FROM raw_aggr r
         INNER JOIN org_closure c
            ON r.data_blng = 'ORG_' || c.descendant_org_id
           AND c.ancestor_org_id <> c.descendant_org_id
         GROUP BY r.data_date, c.ancestor_org_id, r.statis_dim,
                  r.statis_calib, r.indx_code, r.persn_legal_bk_code
    )
    SELECT indx_code, data_blng, statis_dim, statis_calib,
           curnt_val, term_last_val, data_date, persn_legal_bk_code
      FROM raw_aggr
    UNION ALL
    SELECT indx_code, data_blng, statis_dim, statis_calib,
           curnt_val, term_last_val, data_date, persn_legal_bk_code
      FROM org_rolled_up;

    o_row_cnt := SQL%ROWCOUNT;
END prc_ads_stat_indx_org_rollup_publish;