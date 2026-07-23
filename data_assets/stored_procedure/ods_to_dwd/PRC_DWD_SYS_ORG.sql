CREATE OR REPLACE PROCEDURE PRC_DWD_SYS_ORG(
    V_SYSDAT IN VARCHAR2,
    OUTCDE   OUT INTEGER
)
AS
  ------------------------------------------------------------------
  -- 报表名称: 双录机构表处理
  -- 报表编号: PRC_DWD_SYS_ORG
  -- 处理周期: 日
  -- 过程描述: 机构数据生成逻辑
  -- 来源表: kbrp_jgcshu(机构参数表), kbrp_jggxii(机构关系表)
  -- 目标表: DWD_SYS_ORG(机构表)
  -- author :
  -- date   : 2026-07-09
  -- 适配数据库: 人大金仓 Oracle 兼容模式
  ------------------------------------------------------------------
  ------------------------------------------------------------------
  --***************************************
  --1.自定义参数区
  --***************************************
  V_PRC_DESC             VARCHAR2(100) := '机构表处理';
  V_PRC_NAME             VARCHAR2(32)  := 'PRC_DWD_SYS_ORG';
  V_SYSDAT2              VARCHAR2(10);
  V_SQL                  VARCHAR2(4000);
  V_LOG_MSG              VARCHAR2(4000);
  V_START_DT             DATE;
  V_LOG_FLG              INTEGER;
  V_LOG_BUTTON           INTEGER := 1;
  V_NO_ID                VARCHAR2(10);
  V_BGN_DATE             DATE;
  V_END_DATE             DATE;
  V_DURA_DATE            INTEGER;
  P_INTERVAL_START_DATE  VARCHAR2(8);
  P_INTERVAL_END_DATE    VARCHAR2(8);
BEGIN
  --***************************************
  -- 2. 业务逻辑区
  --***************************************
  V_START_DT := SYSDATE;
  V_SYSDAT2 := TO_CHAR(TO_DATE(V_SYSDAT, 'yyyymmdd'), 'yyyy-mm-dd');
  P_INTERVAL_START_DATE := TO_CHAR(TO_DATE(V_SYSDAT, 'yyyymmdd') - 30, 'yyyymmdd');
  P_INTERVAL_END_DATE   := V_SYSDAT;

  --***************************************
  -- 2.1 临时表1：基础数据
  --***************************************
  V_NO_ID := '1';
  V_BGN_DATE := SYSDATE;

  EXECUTE IMMEDIATE 'TRUNCATE TABLE DWD_TMP_JIGOU_BASE';
  INSERT INTO DWD_TMP_JIGOU_BASE (
      JIGOUHAO,
      FARENDMA,
      FENHDAIM,
      JIGOLEIX,
      JIGOUZWM,
      DIZHIIII,
      YOUZHNBM,
      DIANHHMA,
      WEIHRIQI,
      WEIHSHIJ,
      JINGDUXX,
      WEIDUXXZ,
      YEWUGXJG,
      YEWUGXJB
  )
  SELECT
      c.JIGOUHAO, -- 营业机构号
      c.FARENDMA,
      c.FENHDAIM, -- 分行代码
      c.JIGOLEIX, -- 机构类型
      c.JIGOUZWM, -- 机构中文名称
      c.DIZHIIII, -- 地址
      c.YOUZHNBM, -- 邮政编码
      c.DIANHHMA, -- 电话号码
      c.WEIHRIQI,
      c.WEIHSHIJ,
      c.JINGDUXX, -- 经度
      c.WEIDUXXZ, -- 纬度
      CASE
          WHEN g.JIGOUHAO IS NOT NULL THEN g.YEWUGXJG
          WHEN c.FENHDAIM IS NOT NULL
               AND LPAD(c.FENHDAIM, 2, '0') || '0000' <> LPAD(c.JIGOUHAO, 6, '0')
               AND EXISTS (
                   SELECT 1
                     FROM CBS_kbrp_jgcshu f
                    WHERE f.FARENDMA = c.FARENDMA
                      AND f.JIGOUHAO = LPAD(c.FENHDAIM, 2, '0') || '0000'
               )
            THEN LPAD(c.FENHDAIM, 2, '0') || '0000'
          ELSE ''
      END AS YEWUGXJG, -- 业务关系机构；关系缺失时回退至存在的分行机构
      NVL(g.YEWUGXJB, 1) AS YEWUGXJB  -- 业务关系级别
    FROM CBS_kbrp_jgcshu c               -- 机构参数表
    LEFT JOIN cbs_kbrp_jggxii g          -- 机构关系表
      ON c.FARENDMA = g.FARENDMA
     AND c.JIGOUHAO = g.JIGOUHAO
     AND G.;

  -- 记录第1段结束时间和耗时
  OUTCDE      := 0;
  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG := '2.1 临时表1：基础数据';
  V_LOG_FLG := OUTCDE;

  -- 调用日志过程，记录第1段正常结束信息
  SYS_PRC_STEP_LOGS(
      V_SYSDAT,
      V_PRC_NAME,
      V_PRC_DESC,
      V_NO_ID,
      V_BGN_DATE,
      V_END_DATE,
      V_DURA_DATE,
      V_LOG_MSG,
      V_LOG_FLG,
      V_LOG_BUTTON
  );

  --***************************************
  -- 2.2 临时表2：机构编码与分类
  --***************************************
  V_NO_ID := '2';
  V_BGN_DATE := SYSDATE;

  EXECUTE IMMEDIATE 'TRUNCATE TABLE DWD_TMP_JIGOU_CODE';
  INSERT INTO DWD_TMP_JIGOU_CODE (
      ORG_ID,
      SUP_ORG_ID,
      ORG_NAME,
      DIRECT_UNDER_ORG,
      ORG_TYP,
      ORG_ADDRS,
      ORG_STATE,
      DSPLY_SEQ,
      CREATR,
      CREAT_TIME,
      CREAT_ORG,
      PERSN_LEGAL_BK_CODE,
      HR_MS_ORG_ID,
      ORG_LGTUD,
      ORG_LATTUD,
      ORG_RSPONR,
      ORG_TEL
  )
  SELECT
      src.ORG_ID,
      src.SUP_ORG_ID,
      src.ORG_NAME,
      src.DIRECT_UNDER_ORG,
      src.ORG_TYP,
      src.ORG_ADDRS,
      src.ORG_STATE,
      src.DSPLY_SEQ,
      src.CREATR,
      src.CREAT_TIME,
      src.CREAT_ORG,
      src.PERSN_LEGAL_BK_CODE,
      src.HR_MS_ORG_ID,
      src.ORG_LGTUD,
      src.ORG_LATTUD,
      src.ORG_RSPONR,
      src.ORG_TEL
  FROM (
      SELECT
          LPAD(b.JIGOUHAO, 6, '0') AS ORG_ID,
          CASE
              WHEN b.JIGOUHAO = '000000' THEN '-1'
              WHEN b.JIGOUHAO IN ('120000', '150000', '180000') THEN '-1'
              WHEN b.YEWUGXJG = '000090' THEN '000000'
              WHEN b.YEWUGXJG = b.JIGOUHAO
                    AND b.JIGOUHAO IN ('010100', '010200', '010300', '010400', '010500', '010600', '010700', '010800', '010900', '011000', '011100', '012000')
                THEN LPAD(b.JIGOUHAO, 6, '0') || 'a'
              WHEN b.YEWUGXJG = b.JIGOUHAO THEN '000000'
              WHEN b.YEWUGXJG = '000095' THEN ''
              WHEN b.YEWUGXJG = '010000' THEN LPAD(b.JIGOUHAO, 6, '0') || 'a'
              ELSE NVL(LPAD(p.JIGOUHAO, 6, '0'), '')
          END AS SUP_ORG_ID,
          CASE
              WHEN b.YEWUGXJG = '010000' THEN
                  CASE
                      WHEN b.JIGOUZWM LIKE '%乐山市商业银行%' THEN
                          CASE
                              WHEN REPLACE(b.JIGOUZWM, '乐山市商业银行', '') LIKE '%（汇总）' THEN
                                  REPLACE(REPLACE(b.JIGOUZWM, '乐山市商业银行', ''), '（汇总）', '') || '管理部'
                              WHEN REPLACE(b.JIGOUZWM, '乐山市商业银行', '') LIKE '%支行' THEN
                                  REPLACE(REPLACE(b.JIGOUZWM, '乐山市商业银行', ''), '支行', '管理部')
                              ELSE REPLACE(b.JIGOUZWM, '乐山市商业银行', '') || '管理部'
                          END
                      ELSE b.JIGOUZWM || '管理部'
                  END
              WHEN b.YEWUGXJG = b.JIGOUHAO
                   AND b.JIGOUHAO IN ('010100', '010200', '010300', '010400', '010500', '010600', '010700', '010800', '010900', '011000', '011100', '012000')
                THEN
                  CASE
                      WHEN b.JIGOUZWM LIKE '%乐山市商业银行%' THEN
                          CASE
                              WHEN REPLACE(b.JIGOUZWM, '乐山市商业银行', '') LIKE '%（汇总）' THEN
                                  REPLACE(REPLACE(b.JIGOUZWM, '乐山市商业银行', ''), '（汇总）', '') || '管理部'
                              WHEN REPLACE(b.JIGOUZWM, '乐山市商业银行', '') LIKE '%支行' THEN
                                  REPLACE(REPLACE(b.JIGOUZWM, '乐山市商业银行', ''), '支行', '管理部')
                              ELSE REPLACE(b.JIGOUZWM, '乐山市商业银行', '') || '管理部'
                          END
                      ELSE b.JIGOUZWM || '管理部'
                  END
              ELSE b.JIGOUZWM
          END AS ORG_NAME,
          CASE
              WHEN LPAD(b.FENHDAIM, 2, '0') = '00' THEN ''
              WHEN LPAD(b.FENHDAIM, 2, '0') = '01' THEN '010000'
              WHEN LPAD(b.FENHDAIM, 2, '0') = '02' THEN '020000'
              WHEN LPAD(b.FENHDAIM, 2, '0') = '03' THEN '030000'
              WHEN LPAD(b.FENHDAIM, 2, '0') = '04' THEN '040000'
              WHEN LPAD(b.FENHDAIM, 2, '0') = '05' THEN '050000'
              WHEN LPAD(b.FENHDAIM, 2, '0') = '06' THEN '060000'
              WHEN LPAD(b.FENHDAIM, 2, '0') = '07' THEN '070000'
              WHEN LPAD(b.FENHDAIM, 2, '0') = '08' THEN '080000'
              WHEN LPAD(b.FENHDAIM, 2, '0') = '09' THEN '090000'
              WHEN LPAD(b.FENHDAIM, 2, '0') = '10' THEN '100000'
              WHEN LPAD(b.FENHDAIM, 2, '0') = '11' THEN '110000'
              WHEN LPAD(b.FENHDAIM, 2, '0') = '12' THEN '120000'
              WHEN LPAD(b.FENHDAIM, 2, '0') = '15' THEN '150000'
              WHEN LPAD(b.FENHDAIM, 2, '0') = '18' THEN '180000'
              ELSE ''
          END AS DIRECT_UNDER_ORG,
          CASE
              WHEN b.JIGOUHAO = '000000' THEN '01'
              WHEN b.JIGOUZWM LIKE '%村镇银行%' THEN '07'
              WHEN b.JIGOUZWM LIKE '%汇总%' AND b.JIGOLEIX = '3' THEN '06'
              WHEN b.JIGOUZWM LIKE '%分行%' AND b.YEWUGXJB = 2 THEN '02'
              WHEN b.JIGOUZWM LIKE '%支行%' AND b.YEWUGXJB >= 3 AND b.JIGOLEIX = '2' THEN '03'
              WHEN b.JIGOUZWM LIKE '%营业部%' THEN '04'
              WHEN b.JIGOUZWM LIKE '%清算中心%' THEN '08'
              WHEN LPAD(b.FENHDAIM, 2, '0') = '00' AND (b.JIGOUZWM LIKE '%部%' OR b.JIGOUZWM LIKE '%办公室%') THEN '09'
              WHEN b.JIGOUZWM LIKE '%支行%' AND b.JIGOLEIX = '3' THEN '06'
              ELSE '05'
          END AS ORG_TYP,
          TRIM(
              NVL(b.DIZHIIII, '') ||
              CASE
                  WHEN b.YOUZHNBM IS NOT NULL THEN ' 邮编:' || TO_CHAR(b.YOUZHNBM)
                  ELSE ''
              END
          ) AS ORG_ADDRS,
          CASE
              WHEN b.JIGOUZWM LIKE '%撤并%' OR b.JIGOUZWM LIKE '%撤销%' THEN '0'
              WHEN b.JIGOUZWM LIKE '%测试%' THEN '2'
              ELSE '1'
          END AS ORG_STATE,
          TO_NUMBER(LPAD(b.JIGOUHAO, 6, '0')) AS DSPLY_SEQ,
          NULL AS CREATR,
          TRIM(
              CASE
                  WHEN b.WEIHRIQI IS NOT NULL THEN TO_CHAR(b.WEIHRIQI)
                  ELSE ''
              END ||
              CASE
                  WHEN b.WEIHSHIJ IS NOT NULL THEN ' ' || TO_CHAR(b.WEIHSHIJ)
                  ELSE ''
              END
          ) AS CREAT_TIME,
          NULL AS CREAT_ORG,
          TO_CHAR(b.FARENDMA) AS PERSN_LEGAL_BK_CODE,
          NULL AS HR_MS_ORG_ID,
          TO_CHAR(b.JINGDUXX) AS ORG_LGTUD,
          TO_CHAR(b.WEIDUXXZ) AS ORG_LATTUD,
          NULL AS ORG_RSPONR,
          b.DIANHHMA AS ORG_TEL
      FROM DWD_TMP_JIGOU_BASE b
      LEFT JOIN DWD_TMP_JIGOU_BASE p
        ON b.YEWUGXJG = p.JIGOUHAO
      WHERE NOT (
          LPAD(b.JIGOUHAO, 6, '0') IN ('000090', '000095', '010000', '001100', '002000', '002600')
          OR (
              NVL(b.JIGOUZWM, ' ') NOT LIKE '%营业部%'
              AND (NVL(b.JIGOUZWM, ' ') LIKE '%部%' OR NVL(b.JIGOUZWM, ' ') LIKE '%办公室%')
          )
      )

      UNION ALL

      SELECT
          LPAD(b.JIGOUHAO, 6, '0') || 'a' AS ORG_ID,
          '000000' AS SUP_ORG_ID,
          CASE
              WHEN b.JIGOUZWM LIKE '%乐山市商业银行%' THEN
                  CASE
                      WHEN REPLACE(b.JIGOUZWM, '乐山市商业银行', '') LIKE '%（汇总）' THEN
                          REPLACE(REPLACE(b.JIGOUZWM, '乐山市商业银行', ''), '（汇总）', '') || '管理部'
                      WHEN REPLACE(b.JIGOUZWM, '乐山市商业银行', '') LIKE '%支行' THEN
                          REPLACE(REPLACE(b.JIGOUZWM, '乐山市商业银行', ''), '支行', '管理部')
                      ELSE REPLACE(b.JIGOUZWM, '乐山市商业银行', '') || '管理部'
                  END
              ELSE b.JIGOUZWM || '管理部'
          END AS ORG_NAME,
          '000000' AS DIRECT_UNDER_ORG,
          '02' AS ORG_TYP,
          '' AS ORG_ADDRS,
          '1' AS ORG_STATE,
           TO_NUMBER(LPAD(b.JIGOUHAO, 6, '0')) AS DSPLY_SEQ,
          NULL AS CREATR,
          '' AS CREAT_TIME,
          NULL AS CREAT_ORG,
          NULL AS PERSN_LEGAL_BK_CODE,
          NULL AS HR_MS_ORG_ID,
          NULL AS ORG_LGTUD,
          NULL AS ORG_LATTUD,
          NULL AS ORG_RSPONR,
          NULL AS ORG_TEL
      FROM DWD_TMP_JIGOU_BASE b
      WHERE b.JIGOUHAO IN ('010100', '010200', '010300', '010400', '010500', '010600', '010700', '010800', '010900', '011000', '011100', '012000')
  ) src;

  -- 记录第2段结束时间和耗时
  OUTCDE      := 0;
  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG := '2.2 临时表2：机构编码与分类';
  V_LOG_FLG := OUTCDE;

  -- 调用日志过程，记录第2段正常结束信息
  SYS_PRC_STEP_LOGS(
      V_SYSDAT,
      V_PRC_NAME,
      V_PRC_DESC,
      V_NO_ID,
      V_BGN_DATE,
      V_END_DATE,
      V_DURA_DATE,
      V_LOG_MSG,
      V_LOG_FLG,
      V_LOG_BUTTON
  );

  --***************************************
  -- 2.3 临时表3：机构路径
  --***************************************
  V_NO_ID := '3';
  V_BGN_DATE := SYSDATE;

  EXECUTE IMMEDIATE 'TRUNCATE TABLE DWD_TMP_JIGOU_PATH';
  INSERT INTO DWD_TMP_JIGOU_PATH (
      ORG_ID,
      SUP_ORG_ID,
      ORG_PATH,
      ORG_HARCY
  )
  SELECT
      c.ORG_ID,
      c.SUP_ORG_ID,
      SYS_CONNECT_BY_PATH(c.ORG_ID, '/') || '/' AS ORG_PATH,
      TO_CHAR(LEVEL) AS ORG_HARCY
    FROM DWD_TMP_JIGOU_CODE c
   START WITH c.SUP_ORG_ID IS NULL
           OR c.SUP_ORG_ID = ''
           OR c.SUP_ORG_ID = '-1'
 CONNECT BY NOCYCLE PRIOR c.ORG_ID = c.SUP_ORG_ID;

  -- 记录第3段结束时间和耗时
  OUTCDE      := 0;
  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG := '2.3 临时表3：机构路径';
  V_LOG_FLG := OUTCDE;

  -- 调用日志过程，记录第3段正常结束信息
  SYS_PRC_STEP_LOGS(
      V_SYSDAT,
      V_PRC_NAME,
      V_PRC_DESC,
      V_NO_ID,
      V_BGN_DATE,
      V_END_DATE,
      V_DURA_DATE,
      V_LOG_MSG,
      V_LOG_FLG,
      V_LOG_BUTTON
  );

  --***************************************
  -- 2.4 汇总表落库
  --***************************************
  V_NO_ID := '4';
  V_BGN_DATE := SYSDATE;

  EXECUTE IMMEDIATE 'TRUNCATE TABLE DWD_SYS_ORG';
  INSERT INTO DWD_SYS_ORG (
      ORG_ID,
      SUP_ORG_ID,
      ORG_PATH,
      ORG_NAME,
      SUP_ORG_NAME,
      DIRECT_UNDER_ORG,
      ORG_TYP,
      ORG_HARCY,
      ORG_ADDRS,
      ORG_STATE,
      DSPLY_SEQ,
      CREATR,
      CREAT_TIME,
      CREAT_ORG,
      PERSN_LEGAL_BK_CODE,
      HR_MS_ORG_ID,
      ORG_LGTUD,
      ORG_LATTUD,
      ORG_RSPONR,
      ORG_TEL
  )
  SELECT
      c.ORG_ID, -- 机构编号
      c.SUP_ORG_ID, -- 上级机构编号
      p.ORG_PATH, -- 机构路径
      c.ORG_NAME, -- 机构名称
      s.ORG_NAME, -- 上级机构名称
      c.DIRECT_UNDER_ORG, -- 直属机构
      c.ORG_TYP, -- 机构类型
      p.ORG_HARCY, -- 机构层级
      c.ORG_ADDRS, -- 机构地址
      c.ORG_STATE, -- 机构状态
      c.DSPLY_SEQ, -- 显示顺序
      c.CREATR, -- 创建人
      c.CREAT_TIME, -- 创建时间
      c.CREAT_ORG, -- 创建机构
            CASE WHEN ORG_PATH LIKE '/150000%' THEN '1500' 
      	   WHEN ORG_PATH LIKE '/120000%' THEN '1200'
      	   WHEN ORG_PATH LIKE '/180000%' THEN '1800'
      	   ELSE '9999' END PERSN_LEGAL_BK_CODE, -- 法人行号
      c.HR_MS_ORG_ID, -- 人力资源系统机构号
      c.ORG_LGTUD, -- 机构经度
      c.ORG_LATTUD, -- 机构纬度
      c.ORG_RSPONR, -- 机构负责人
      c.ORG_TEL -- 机构电话
    FROM DWD_TMP_JIGOU_CODE c
    LEFT JOIN DWD_TMP_JIGOU_CODE s
      ON c.SUP_ORG_ID = s.ORG_ID
    LEFT JOIN DWD_TMP_JIGOU_PATH p
      ON c.ORG_ID = p.ORG_ID;

  -- 记录第4段结束时间和耗时
  OUTCDE      := 0;
  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG := '2.4 汇总表落库';
  V_LOG_FLG := OUTCDE;

  -- 调用日志过程，记录第4段正常结束信息
  SYS_PRC_STEP_LOGS(
      V_SYSDAT,
      V_PRC_NAME,
      V_PRC_DESC,
      V_NO_ID,
      V_BGN_DATE,
      V_END_DATE,
      V_DURA_DATE,
      V_LOG_MSG,
      V_LOG_FLG,
      V_LOG_BUTTON
  );

  COMMIT;
    -- ***************************************
    -- 3. 异常处理区（捕获错误码并记录详细日志）
    -- ***************************************
EXCEPTION
  WHEN OTHERS THEN
    OUTCDE := -1;
    ROLLBACK;
    V_END_DATE := SYSDATE;
    V_DURA_DATE := CASE WHEN V_BGN_DATE IS NULL OR V_END_DATE IS NULL THEN NULL ELSE TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60) END;
    V_LOG_MSG := SUBSTR(SQLERRM, 1, 1000);
    V_LOG_FLG := OUTCDE;
    SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);
    RAISE;
END;
/
