-- ================================================================
-- sys_fun_deal_date 函数逻辑测试脚本
-- 测试基准: 20260805 (2026-08-05)
-- 边界验证: 月初/月末/闰年/年末
-- 执行: Oracle/Kingbase SQL*Plus 或兼容客户端逐段执行
-- ================================================================

SET SERVEROUTPUT ON

-- 1. 全参数测试 (20260805)
DECLARE
    V_TEST_DATE VARCHAR(8) := '20260805';
    V_RESULT    VARCHAR(8);
    V_EXPECTED  VARCHAR(8);
    V_PASS      VARCHAR(10);
    V_TOTAL     INTEGER := 0;
    V_PASSED    INTEGER := 0;
    V_FAILED    INTEGER := 0;
    PROCEDURE T(P INTEGER, E VARCHAR2, D VARCHAR2) IS
    BEGIN
        V_RESULT := crmdm.sys_fun_deal_date(V_TEST_DATE, P);
        V_TOTAL := V_TOTAL + 1;
        IF V_RESULT = E THEN V_PASS := 'PASS'; V_PASSED := V_PASSED + 1;
        ELSE V_PASS := 'FAIL'; V_FAILED := V_FAILED + 1; END IF;
        DBMS_OUTPUT.PUT_LINE(RPAD('#'||P,5)||RPAD(D,25)||'exp='||E||' got='||V_RESULT||' '||V_PASS);
    END;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== 全参数测试 20260805 ===');
    T( 1,'20260804','上日');
    T( 2,'20260731','上月末');
    T( 3,'20260630','上季末');
    T( 4,'20251231','上年末');
    T( 5,'20260803','上上日');
    T( 6,'20260630','上上月末');
    T( 7,'20260331','上上季末(Q1末)');
    T( 8,'20241231','上上年末');
    T( 9,'20260801','当月初');
    T(10,'20260831','当月末');
    T(11,'20260701','当季初');
    T(12,'20260930','当季末');
    T(13,'20260101','当年初');
    T(14,'20261231','当年末');
    T(15,'20260701','上月初');
    T(16,'20260401','上季初');
    T(17,'20250101','上年初');
    T(18,'20260706','30天前');
    T(19,'20230805','三年边界');
    T(20,'20260705','1月前');
    T(21,'20260205','6月前');
    T(22,'20260630','近3月月末(last_day-2m)');
    T(23,'20260331','近6月月末(last_day-5m)');
    T(24,'20251231','近9月月末(last_day-8m)');
    T(25,'20250930','近12月月末(last_day-11m)');
    T(26,'20250805','365天前');
    T(27,'20260206','180天前');
    DBMS_OUTPUT.PUT_LINE('结果: '||V_PASSED||'/'||V_TOTAL||' 通过, '||V_FAILED||' 失败');
END;
/

-- 2. 月初边界测试
DECLARE
    V_RESULT VARCHAR(8);
    PROCEDURE T(D VARCHAR2, P INTEGER) IS
    BEGIN
        V_RESULT := crmdm.sys_fun_deal_date(D, P);
        DBMS_OUTPUT.PUT_LINE(D||' #'||P||' = '||V_RESULT);
    END;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== 月初边界: 20260801 ===');
    T('20260801', 1); T('20260801', 9); T('20260801',22);
    T('20260801',26); T('20260801',27);
    
    DBMS_OUTPUT.PUT_LINE('=== 月末边界: 20260831 ===');
    T('20260831',10); T('20260831',22); T('20260831',26);
    
    DBMS_OUTPUT.PUT_LINE('=== 季末: 20260630 ===');
    T('20260630', 3); T('20260630',11); T('20260630',22);
    
    DBMS_OUTPUT.PUT_LINE('=== 年末: 20251231 ===');
    T('20251231', 4); T('20251231',13); T('20251231',14);
    
    DBMS_OUTPUT.PUT_LINE('=== 闰年2/29: 20240229 ===');
    T('20240229',26); T('20240229',27);
END;
/

-- 3. 异常输入
DECLARE
    V_RESULT VARCHAR(8);
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== 异常输入 ===');
    BEGIN V_RESULT := crmdm.sys_fun_deal_date(NULL, 1);
        DBMS_OUTPUT.PUT_LINE('NULL -> '||V_RESULT); EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('NULL -> ERROR: '||SQLERRM); END;
    BEGIN V_RESULT := crmdm.sys_fun_deal_date('20260805', 99);
        DBMS_OUTPUT.PUT_LINE('#99 -> '||V_RESULT); EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('#99 -> ERROR'); END;
    BEGIN V_RESULT := crmdm.sys_fun_deal_date('20260805', 0);
        DBMS_OUTPUT.PUT_LINE('#0  -> '||V_RESULT); EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('#0  -> ERROR'); END;
    BEGIN V_RESULT := crmdm.sys_fun_deal_date('abc', 1);
        DBMS_OUTPUT.PUT_LINE('abc -> '||V_RESULT); EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('abc -> ERROR: '||SQLERRM); END;
END;
/

-- 4. 关键参数多日期验证 (22-27 新增参数)
DECLARE
    V_RESULT VARCHAR(8);
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== 参数22 last_day(V_DATE-2月) ===');
    V_RESULT := crmdm.sys_fun_deal_date('20260805',22); DBMS_OUTPUT.PUT_LINE('20260805→'||V_RESULT||' (exp:20260630)');
    V_RESULT := crmdm.sys_fun_deal_date('20260801',22); DBMS_OUTPUT.PUT_LINE('20260801→'||V_RESULT||' (exp:20260630)');
    V_RESULT := crmdm.sys_fun_deal_date('20260630',22); DBMS_OUTPUT.PUT_LINE('20260630→'||V_RESULT||' (exp:20260430)');
    V_RESULT := crmdm.sys_fun_deal_date('20260601',22); DBMS_OUTPUT.PUT_LINE('20260601→'||V_RESULT||' (exp:20260430)');

    DBMS_OUTPUT.PUT_LINE('=== 参数23 last_day(V_DATE-5月) ===');
    V_RESULT := crmdm.sys_fun_deal_date('20260805',23); DBMS_OUTPUT.PUT_LINE('20260805→'||V_RESULT||' (exp:20260331)');
    V_RESULT := crmdm.sys_fun_deal_date('20260630',23); DBMS_OUTPUT.PUT_LINE('20260630→'||V_RESULT||' (exp:20260131)');

    DBMS_OUTPUT.PUT_LINE('=== 参数26 V_DATE-365天 ===');
    V_RESULT := crmdm.sys_fun_deal_date('20260805',26); DBMS_OUTPUT.PUT_LINE('20260805→'||V_RESULT||' (exp:20250805)');
    V_RESULT := crmdm.sys_fun_deal_date('20241231',26); DBMS_OUTPUT.PUT_LINE('20241231→'||V_RESULT||' (exp:20240101)');

    DBMS_OUTPUT.PUT_LINE('=== 参数27 V_DATE-180天 ===');
    V_RESULT := crmdm.sys_fun_deal_date('20260805',27); DBMS_OUTPUT.PUT_LINE('20260805→'||V_RESULT||' (exp:20260206)');
    V_RESULT := crmdm.sys_fun_deal_date('20240701',27); DBMS_OUTPUT.PUT_LINE('20240701→'||V_RESULT||' (exp:20240103)');
END;
/
