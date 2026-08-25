CREATE OR REPLACE PROCEDURE PRC_CUST_LABEL_AF03(
    V_SYSDAT IN VARCHAR,
    OUTCDE   OUT INTEGER
)
AS
  ------------------------------------------------------------------
  -- 存储过程模板：Oracle 兼容模式
  --
  -- 生成规则：
  -- 1. 保留本过程的参数、异常处理框架和 SYS_PRC_STEP_LOGS 调用方式。
  -- 2. 业务逻辑按实际处理链拆分，不预设固定的业务段数量。
  -- 3. 每个物理临时表段按 TMP1、TMP2、TMP3... 顺序命名并独立处理。
  -- 4. 每个临时表段必须依次包含：设置步骤号、记录开始时间、处理数据、COMMIT、
  --    记录结束时间和耗时、调用 SYS_PRC_STEP_LOGS。
  -- 5. 临时表段之间的 COMMIT 和日志调用不可省略，不得合并为过程末尾一次提交。
  -- 6. 临时表段完成后，再按实际业务逻辑汇总写入目标表，并单独记录目标表步骤日志。
  -- 7. 字段、来源表、过滤条件无法确认时保留 NULL 或明确占位，不得猜测业务规则。
  -- 8. 本模板中的两个 INSERT 仅保留原有示例行为，不代表生成过程固定只有两个步骤。
  -- 9. 字段、来源表、目标表都要带上注释并对齐。
  --
  -- 强制格式与注释要求（写逻辑时必须遵守，docs/quality_rules.md QA-14~17）：
  -- A. 关键字统一大写；缩进 4 空格；逻辑块之间空行。
  -- B. 文件头注释含：存储过程名称、功能、参数说明、需求版本、变更记录；版本无法确认须标注【待确认】。
  -- C. 每条 SELECT 字段、WHERE/JOIN 条件、函数、参数后均需行内注释（-- 注释业务含义）。
  -- D. 字段别名必须使用大写 AS 并对齐；同一代码块内行内注释尽量对齐。
  -- E. 提交前必须运行校验工具（逻辑零改动 + 对齐/覆盖率），未达标退回：
  --      python scripts/proc_beautify.py verify <file.sql>
  --      python scripts/proc_beautify.py align  <file.sql>
  ------------------------------------------------------------------
  V_PRC_DESC             VARCHAR(100) := '单位类型';
  V_PRC_NAME             VARCHAR(32)  := 'PRC_CUST_LABEL_AF03';
  V_LOG_MSG              VARCHAR(4000);
  V_LOG_FLG              INTEGER;
  V_LOG_BUTTON           INTEGER := 1;
  V_NO_ID                VARCHAR(10);
  V_BGN_DATE             DATE;
  V_END_DATE             DATE;
  V_DURA_DATE            INTEGER;
  -- Date parameters: declare only the business dates required by this procedure.
  -- Each parameter must retain its code and meaning; see governance/stored_procedure_date_parameter_rules.md.
  -- V_PREV_DAY             VARCHAR(8) := sys_fun_deal_date(V_SYSDAT, 1);  -- 1: previous business day
  -- V_PREV_MONTH_END       VARCHAR(8) := sys_fun_deal_date(V_SYSDAT, 2);  -- 2: previous month end
BEGIN
  --***************************************
  --1.自定义参数区
  --***************************************
  IF V_SYSDAT IS NULL
     OR NOT REGEXP_LIKE(V_SYSDAT, '^[0-9]{8}$')
  THEN
    RAISE_APPLICATION_ERROR(-20001, 'V_SYSDAT must be in YYYYMMDD format');
  END IF;

  -- 解析日期以校验“格式正确但日期非法”的输入。
  V_END_DATE := TO_DATE(V_SYSDAT, 'YYYYMMDD');

  -- V_SYSDAT is valid only for input validation, logs, and source snapshot equality.
  -- Derive business dates through the named parameters above. Target date output is YYYYMMDD.

  --***************************************
  -- 2. 目标表准备
  --***************************************
  
  -- 每日全量过程先清理目标表；该语义保持不变。
  EXECUTE IMMEDIATE 'TRUNCATE TABLE MTS_CUST_LABEL_AF03';

  --***************************************
  -- 3. 业务处理段
  --
  -- 按实际业务逻辑增加或删除处理段。以下两个 INSERT 保留原模板行为。
  -- 生成 TMP1/TMP2/... 时，应将每个临时表段改写为下方“临时表段标准结构”，
  -- 并在对应段内完成 COMMIT 和 SYS_PRC_STEP_LOGS 调用。
  --***************************************

  -- 3.1 原有业务处理段
  V_NO_ID := '1';
  V_BGN_DATE := SYSDATE;

  INSERT INTO MTS_CUST_LABEL_AF03 (AA01, AF03, DATA_DATE)
  SELECT T.ECIF_CUST_NO  AS AA01,
         T.UNIT_TYPE     AS AF03,
         V_SYSDAT        AS DATA_DATE
    FROM ECIF_T01_P_CUST_INFO T;

  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := '第1个业务处理段完成';
  V_LOG_FLG := OUTCDE;

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

  -- 3.2 原有业务处理段
  V_NO_ID := '2';
  V_BGN_DATE := SYSDATE;

  INSERT INTO MTS_CUST_LABEL_AF03 (AA01, AF03, DATA_DATE)
  SELECT T.ECIF_CUST_NO  AS AA01,
         T.UNIT_TYPE     AS AF03,
         V_SYSDAT        AS DATA_DATE
    FROM ECIF_T01_P_CUST_INFO T;

  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := '第2个业务处理段完成';
  V_LOG_FLG := OUTCDE;

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

  ------------------------------------------------------------------
  -- 临时表段标准结构（生成 TMP1/TMP2/... 时复制本结构并替换业务逻辑）
  ------------------------------------------------------------------
  -- V_NO_ID := 'TMP1';
  -- V_BGN_DATE := SYSDATE;
  -- EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_<结果表>_TMP1';
  -- INSERT INTO TMP_<结果表>_TMP1 (...)
  -- SELECT ...;
  -- COMMIT;
  -- V_END_DATE := SYSDATE;
  -- V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  -- OUTCDE := 0;
  -- V_LOG_MSG := 'TMP1 临时表处理完成';
  -- V_LOG_FLG := OUTCDE;
  -- SYS_PRC_STEP_LOGS(
  --     V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID,
  --     V_BGN_DATE, V_END_DATE, V_DURA_DATE,
  --     V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON
  -- );
    -- ***************************************  
    -- 4. 异常处理区（捕获错误码并记录详细日志）
    -- ***************************************  
EXCEPTION
  WHEN OTHERS THEN
    OUTCDE := -1;
    ROLLBACK;

    V_END_DATE := SYSDATE;
    V_DURA_DATE := CASE
                     WHEN V_BGN_DATE IS NULL OR V_END_DATE IS NULL THEN NULL
                     ELSE TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60)
                   END;
    V_LOG_MSG := SUBSTR(SQLERRM, 1, 1000);
    V_LOG_FLG := OUTCDE;

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

    RAISE;
END;
