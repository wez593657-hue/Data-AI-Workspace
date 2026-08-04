SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET PAGESIZE 0
SET FEEDBACK OFF
SET VERIFY OFF
SET TRIMSPOOL ON
SET LINESIZE 400

-- ============================================================
-- 场景复现: 当月新增50元定期 → 触发唤醒
-- 客户C999: 昨日在睡眠清单(AUM=50活期), 今日新增50元定期
-- 测试日期: 20260815 (非月首, 当月首日=20260801)
-- ============================================================

-- ============================================================
-- STEP 0: 清理并初始化基础设施
-- ============================================================
BEGIN DBMS_OUTPUT.PUT_LINE('========== STEP 0: 初始化环境 =========='); END;
/

DELETE FROM ADS_CUST_SLEEP_WAKE_DTL;
DELETE FROM ADS_CUST_SLEEP_WAKE_STATIS;
DELETE FROM DWD_CUST_INDV_INFO WHERE CUST_ID='C999';
DELETE FROM DWS_CUST_ASSE_LIAB WHERE CUST_ID='C999';
DELETE FROM DWD_TX_ASET WHERE CUST_ID='C999';
DELETE FROM DWD_CUST_MAN WHERE CUST_ID='C999';
DELETE FROM DWS_CUST_LVL_INFO WHERE CUST_ID='C999';
DELETE FROM ADS_MKT_REC_INFO WHERE CUST_ID='C999';
DELETE FROM DWD_SYS_ORG WHERE ORG_ID='ORG999';

BEGIN
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_ADS_SLEEP_WAKE_BASE';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_ADS_SLEEP_CANDIDATE';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_ADS_SLEEP_DWS_WAKE';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_ADS_SLEEP_CNTCT';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_ADS_SLEEP_STAT_SRC';
END;
/

-- 组织机构
INSERT INTO DWD_SYS_ORG (ORG_ID, SUP_ORG_ID, ORG_NAME, ORG_TYP, ORG_STATE, PERSN_LEGAL_BK_CODE)
VALUES ('ORG999', NULL, 'Test Org', '1', '1', 'BK01');

-- 客户基本信息
INSERT INTO DWD_CUST_INDV_INFO (CUST_ID, CUST_NAME, CUST_TYP, OPEN_DATE, OPEN_ORG, PERSN_LEGAL_BK_CODE)
VALUES ('C999', 'FixdWake50', '01', '20250101', 'ORG999', 'BK01');

-- 客户等级
INSERT INTO DWS_CUST_LVL_INFO (DATA_DATE, CUST_ID, CUST_LVL, PERSN_LEGAL_BK_CODE)
VALUES ('20260815', 'C999', '01', 'BK01');
INSERT INTO DWS_CUST_LVL_INFO (DATA_DATE, CUST_ID, CUST_LVL, PERSN_LEGAL_BK_CODE)
VALUES ('20260801', 'C999', '01', 'BK01');

-- 管户关系
INSERT INTO DWD_CUST_MAN (CUST_ID, MNGR_POST_ID, ORG_ID, MNG_TYP, PERSN_LEGAL_BK_CODE)
VALUES ('C999', 'MGR999', 'ORG999', '1', 'BK01');

COMMIT;

-- ============================================================
-- STEP 1: 前一日数据准备 (20260814)
-- ============================================================
BEGIN DBMS_OUTPUT.PUT_LINE(''); DBMS_OUTPUT.PUT_LINE('========== STEP 1: 前一日数据 (20260814) =========='); END;
/

-- 20260814的DWS快照: AUM=50(活期), 无产品
INSERT INTO DWS_CUST_ASSE_LIAB (DATA_DATE, PERSN_LEGAL_BK_CODE, CUST_ID, ORG_ID, BAL_TYPE, AUM_BAL, DEPO_CURNT_DEPO_BAL, FIXD_DEPO_BAL, FIN_BAL, INSUR_BAL)
VALUES ('20260814', 'BK01', 'C999', 'ORG999', '1', 50, 50, 0, 0, 0);

-- 20260814的DTL: C999昨日已在睡眠清单中
INSERT INTO ADS_CUST_SLEEP_WAKE_DTL (
  PERSN_LEGAL_BK_CODE, DATA_DATE, CUST_ID, CUST_NAME, CUST_LVL,
  DEPO_CURNT_DEPO_BAL, FIXD_DEPO_BAL, FIN_AMT, INSUR_AMT,
  CNTCT_STATE, WAKE_STATE, POST_ID, ORG_ID, STATIS_CYCLE
) VALUES ('BK01', '20260814', 'C999', 'FixdWake50', '01', 50, 0, 0, 0, '0', '0', 'MGR999', 'ORG999', 'M');

-- 唤醒基线DWS: 20260801 (当月首日) 的基线快照 - 定期=0
INSERT INTO DWS_CUST_ASSE_LIAB (DATA_DATE, PERSN_LEGAL_BK_CODE, CUST_ID, ORG_ID, BAL_TYPE, AUM_BAL, DEPO_CURNT_DEPO_BAL, FIXD_DEPO_BAL, FIN_BAL, INSUR_BAL)
VALUES ('20260801', 'BK01', 'C999', 'ORG999', '1', 50, 50, 0, 0, 0);

COMMIT;

BEGIN
  DBMS_OUTPUT.PUT_LINE('20260814 DWS: AUM=50, FIXD=0, FIN=0, INSUR=0');
  DBMS_OUTPUT.PUT_LINE('20260814 DTL: C999在睡眠清单, WAKE=0, CNTCT=0');
  DBMS_OUTPUT.PUT_LINE('20260801 基线: AUM=50, FIXD=0, FIN=0, INSUR=0');
END;
/

-- ============================================================
-- STEP 2: 当日数据准备 (20260815) - 新增50元定期!
-- ============================================================
BEGIN
  DBMS_OUTPUT.PUT_LINE('');
  DBMS_OUTPUT.PUT_LINE('========== STEP 2: 当日数据 (20260815) 新增50元定期! ==========');
END;
/

-- 20260815 DWS快照: AUM=100(50活期+50定期)
INSERT INTO DWS_CUST_ASSE_LIAB (DATA_DATE, PERSN_LEGAL_BK_CODE, CUST_ID, ORG_ID, BAL_TYPE, AUM_BAL, DEPO_CURNT_DEPO_BAL, FIXD_DEPO_BAL, FIN_BAL, INSUR_BAL)
VALUES ('20260815', 'BK01', 'C999', 'ORG999', '1', 100, 50, 50, 0, 0);

COMMIT;

BEGIN
  DBMS_OUTPUT.PUT_LINE('20260815 DWS: AUM=100, FIXD_DEPO_BAL=50 (新增!), FIN=0, INSUR=0');
  DBMS_OUTPUT.PUT_LINE('定期: 基线=0 → 当日=50 → 触发唤醒!');
END;
/

-- ============================================================
-- STEP 3: 调用存储过程
-- ============================================================
BEGIN
  DBMS_OUTPUT.PUT_LINE('');
  DBMS_OUTPUT.PUT_LINE('========== STEP 3: 执行 PRC_ADS_CUST_SLEEP_WAKE_DTL(''20260815'') ==========');
END;
/

DECLARE v_out INTEGER;
BEGIN
  PRC_ADS_CUST_SLEEP_WAKE_DTL('20260815', v_out);
  DBMS_OUTPUT.PUT_LINE('返回码: ' || v_out);
END;
/

-- ============================================================
-- STEP 4: 逐步骤检查中间表
-- ============================================================
BEGIN
  DBMS_OUTPUT.PUT_LINE('');
  DBMS_OUTPUT.PUT_LINE('========== STEP 4: 中间结果检查 ==========');
END;
/

-- 4a. TMP_ADS_SLEEP_DWS_WAKE (A0步骤)
BEGIN
  DBMS_OUTPUT.PUT_LINE('');
  DBMS_OUTPUT.PUT_LINE('--- [A0] TMP_ADS_SLEEP_DWS_WAKE ---');
  DBMS_OUTPUT.PUT_LINE('当日快照 + 唤醒基线LEFT JOIN → IS_WAKE计算');
END;
/
SELECT CUST_ID, AUM_BAL, DEPO_CURNT_DEPO_BAL AS DEPO, FIXD_DEPO_BAL AS FIXD, FIN_BAL AS FIN, INSUR_BAL AS INSUR, IS_WAKE
FROM TMP_ADS_SLEEP_DWS_WAKE WHERE CUST_ID='C999';

DECLARE
  v_wake NUMBER;
BEGIN
  SELECT IS_WAKE INTO v_wake FROM TMP_ADS_SLEEP_DWS_WAKE WHERE CUST_ID='C999';
  DBMS_OUTPUT.PUT_LINE('');
  DBMS_OUTPUT.PUT_LINE('IS_WAKE = ' || v_wake || ' (定期: 基线0→当日50, 触发!)');
END;
/

-- 4b. TMP_ADS_SLEEP_CNTCT (A1步骤)
BEGIN
  DBMS_OUTPUT.PUT_LINE('');
  DBMS_OUTPUT.PUT_LINE('--- [A1] TMP_ADS_SLEEP_CNTCT ---');
END;
/
DECLARE v_c NUMBER;
BEGIN SELECT COUNT(*) INTO v_c FROM TMP_ADS_SLEEP_CNTCT WHERE CUST_ID='C999';
  DBMS_OUTPUT.PUT_LINE('C999 接触记录数: ' || v_c || ' (当月无接触)');
END;
/

-- 4c. TMP_ADS_SLEEP_WAKE_BASE (A步骤: 继承昨日DTL)
BEGIN
  DBMS_OUTPUT.PUT_LINE('');
  DBMS_OUTPUT.PUT_LINE('--- [A] TMP_ADS_SLEEP_WAKE_BASE (继承自20260814 DTL) ---');
  DBMS_OUTPUT.PUT_LINE('V_IS_MONTH_BEGIN=N → 全部保留, 不检查条件');
END;
/
SELECT CUST_ID, DEPO_CURNT_DEPO_BAL AS DEPO, FIXD_DEPO_BAL AS FIXD, FIN_AMT AS FIN, INSUR_AMT AS INSUR,
       CNTCT_STATE AS CNTCT, WAKE_STATE AS WAKE
FROM TMP_ADS_SLEEP_WAKE_BASE WHERE CUST_ID='C999';

-- 4d. TMP_ADS_SLEEP_CANDIDATE (B步骤)
BEGIN
  DBMS_OUTPUT.PUT_LINE('');
  DBMS_OUTPUT.PUT_LINE('--- [B] TMP_ADS_SLEEP_CANDIDATE ---');
END;
/
DECLARE v_c NUMBER;
BEGIN SELECT COUNT(*) INTO v_c FROM TMP_ADS_SLEEP_CANDIDATE WHERE CUST_ID='C999';
  DBMS_OUTPUT.PUT_LINE('C999 候选记录数: ' || v_c || ' (AUM=100>=100, 不新增)');
END;
/

-- ============================================================
-- STEP 5: 目标表最终结果
-- ============================================================
BEGIN
  DBMS_OUTPUT.PUT_LINE('');
  DBMS_OUTPUT.PUT_LINE('========== STEP 5: ADS_CUST_SLEEP_WAKE_DTL 最终结果 ==========');
END;
/

SELECT CUST_ID, CUST_NAME,
       DEPO_CURNT_DEPO_BAL AS DEPO_CURNT,
       FIXD_DEPO_BAL AS FIXD,
       FIN_AMT AS FIN,
       INSUR_AMT AS INSUR,
       CNTCT_STATE AS CNTCT,
       WAKE_STATE AS WAKE,
       POST_ID,
       ORG_ID,
       STATIS_CYCLE
FROM ADS_CUST_SLEEP_WAKE_DTL
WHERE DATA_DATE='20260815'
ORDER BY CUST_ID;

-- ============================================================
-- STEP 6: 结果比对断言
-- ============================================================
BEGIN
  DBMS_OUTPUT.PUT_LINE('');
  DBMS_OUTPUT.PUT_LINE('========== STEP 6: 结果断言 ==========');
  DBMS_OUTPUT.PUT_LINE('');
END;
/

DECLARE
  v_depo  NUMBER; v_fixd NUMBER; v_fin NUMBER; v_insur NUMBER;
  v_cntct CHAR(1); v_wake CHAR(1);
  v_pass  INTEGER := 0; v_fail INTEGER := 0;
  PROCEDURE chk(label VARCHAR2, exp VARCHAR2, act VARCHAR2) IS
  BEGIN
    IF exp = act THEN
      DBMS_OUTPUT.PUT_LINE('PASS: ' || label || ' = ' || act);
      v_pass := v_pass + 1;
    ELSE
      DBMS_OUTPUT.PUT_LINE('FAIL: ' || label || ' exp=' || exp || ' act=' || act);
      v_fail := v_fail + 1;
    END IF;
  END;
BEGIN
  SELECT DEPO_CURNT_DEPO_BAL, FIXD_DEPO_BAL, FIN_AMT, INSUR_AMT, CNTCT_STATE, WAKE_STATE
  INTO v_depo, v_fixd, v_fin, v_insur, v_cntct, v_wake
  FROM ADS_CUST_SLEEP_WAKE_DTL WHERE DATA_DATE='20260815' AND CUST_ID='C999';

  DBMS_OUTPUT.PUT_LINE('------ DTL记录存在性 ------');
  IF v_depo IS NOT NULL THEN
    DBMS_OUTPUT.PUT_LINE('PASS: C999在DTL中 (月内只增不减, 继续保留)');
    v_pass := v_pass + 1;
  ELSE
    DBMS_OUTPUT.PUT_LINE('FAIL: C999不在DTL中');
    v_fail := v_fail + 1;
  END IF;

  DBMS_OUTPUT.PUT_LINE('------ 余额刷新 ------');
  chk('活期余额(DEPO_CURNT_DEPO_BAL)', '50', CAST(v_depo AS VARCHAR2(20)));
  chk('定期余额(FIXD_DEPO_BAL)=50(新增)', '50', CAST(v_fixd AS VARCHAR2(20)));
  chk('理财余额(FIN_AMT)', '0', CAST(v_fin AS VARCHAR2(20)));
  chk('保险余额(INSUR_AMT)', '0', CAST(v_insur AS VARCHAR2(20)));

  DBMS_OUTPUT.PUT_LINE('------ 状态判定 ------');
  chk('WAKE_STATE=1 (定期0→50 触发唤醒)', '1', v_wake);
  chk('CNTCT_STATE=0 (当月无接触)', '0', v_cntct);

  DBMS_OUTPUT.PUT_LINE('');
  DBMS_OUTPUT.PUT_LINE('========== 汇总: ' || v_pass || ' PASS / ' || v_fail || ' FAIL ==========');
  IF v_fail > 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Test FAILED!');
  END IF;
END;
/

-- ============================================================
-- STEP 7: STATIS 验证
-- ============================================================
BEGIN
  DBMS_OUTPUT.PUT_LINE('');
  DBMS_OUTPUT.PUT_LINE('========== STEP 7: STATIS 20260815 ==========');
END;
/

DECLARE v_out INTEGER;
BEGIN
  PRC_ADS_CUST_SLEEP_WAKE_STATIS('20260815', v_out);
END;
/

SELECT STATIS_OBJ AS OBJ, CUST_CNT, CNTCT_CUST_CNT AS CNTCT_N, CNTCT_RATE,
       WAKE_CUST_CNT AS WAKE_N, WAKE_RATE
FROM ADS_CUST_SLEEP_WAKE_STATIS
WHERE DATA_DATE='20260815'
ORDER BY STATIS_OBJ;

DECLARE
  v_cust NUMBER; v_wake NUMBER; v_cntct NUMBER;
BEGIN
  SELECT CUST_CNT, WAKE_CUST_CNT, CNTCT_CUST_CNT
  INTO v_cust, v_wake, v_cntct
  FROM ADS_CUST_SLEEP_WAKE_STATIS
  WHERE DATA_DATE='20260815' AND STATIS_OBJ='MGR999';

  DBMS_OUTPUT.PUT_LINE('');
  DBMS_OUTPUT.PUT_LINE('STATIS MGR999: CUST_CNT='||v_cust||'  WAKE_CNT='||v_wake||'  CNTCT_CNT='||v_cntct);
  DBMS_OUTPUT.PUT_LINE('→ C999计入总客户数, 计入唤醒数(WAKE=1), 不计入接触数');
END;
/
