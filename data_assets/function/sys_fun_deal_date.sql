CREATE OR REPLACE FUNCTION crmdm.sys_fun_deal_date(p_dat varchar, p_pd integer)
 RETURNS varchar
AS
DECLARE
    V_DATE       date;
    V_RETUR_DATE varchar;
BEGIN
    V_DATE := to_date(p_dat, 'YYYYMMDD');

    CASE p_pd
        WHEN 1 THEN
            V_RETUR_DATE := to_char(V_DATE - interval '1' day, 'YYYYMMDD'); -- 上日
        WHEN 2 THEN
            V_RETUR_DATE := to_char(last_day(V_DATE - interval '1' month), 'YYYYMMDD'); -- 上月末
        WHEN 3 THEN
            V_RETUR_DATE := to_char(trunc(V_DATE, 'Q') - 1, 'YYYYMMDD'); -- 上季末
        WHEN 4 THEN
            V_RETUR_DATE := to_char(trunc(V_DATE, 'YEAR') - 1, 'YYYYMMDD'); -- 上年末

        WHEN 5 THEN
            V_RETUR_DATE := to_char(V_DATE - interval '2' day, 'YYYYMMDD'); -- 上上日
        WHEN 6 THEN
            V_RETUR_DATE := to_char(last_day(V_DATE - interval '2' month), 'YYYYMMDD'); -- 上上月末
        WHEN 7 THEN
            V_RETUR_DATE := to_char(trunc(add_months(V_DATE, -3), 'Q') - 1, 'YYYYMMDD'); -- 上上季末
        WHEN 8 THEN
            V_RETUR_DATE := to_char(trunc(add_months(V_DATE, -12), 'YEAR') - 1, 'YYYYMMDD'); -- 上上年末

        WHEN 9 THEN
            V_RETUR_DATE := to_char(trunc(V_DATE, 'MONTH'), 'YYYYMMDD'); -- 当月初
        WHEN 10 THEN
            V_RETUR_DATE := to_char(last_day(V_DATE), 'YYYYMMDD'); -- 当月末
        WHEN 11 THEN
            V_RETUR_DATE := to_char(trunc(V_DATE, 'Q'), 'YYYYMMDD'); -- 当季初
        WHEN 12 THEN
            V_RETUR_DATE := to_char(trunc(add_months(V_DATE, 3), 'Q') - 1, 'YYYYMMDD'); -- 当季末
        WHEN 13 THEN
            V_RETUR_DATE := to_char(trunc(V_DATE, 'YEAR'), 'YYYYMMDD'); -- 当年初
        WHEN 14 THEN
            V_RETUR_DATE := to_char(trunc(add_months(V_DATE, 12), 'YEAR') - 1, 'YYYYMMDD'); -- 当年末

        WHEN 15 THEN
            V_RETUR_DATE := to_char(trunc(add_months(V_DATE, -1), 'MONTH'), 'YYYYMMDD'); -- 上月初
        WHEN 16 THEN
            V_RETUR_DATE := to_char(trunc(add_months(V_DATE, -3), 'Q'), 'YYYYMMDD'); -- 上季初
        WHEN 17 THEN
            V_RETUR_DATE := to_char(trunc(add_months(V_DATE, -12), 'YEAR'), 'YYYYMMDD'); -- 上年初
        WHEN 18 THEN
            V_RETUR_DATE := to_char(V_DATE - interval '30' day, 'YYYYMMDD'); -- 30天承接窗口开始日
        WHEN 19 THEN
            V_RETUR_DATE := to_char(add_months(V_DATE, -36), 'YYYYMMDD'); -- 三年历史清理边界
        WHEN 20 THEN
            V_RETUR_DATE := to_char(add_months(V_DATE, -1), 'YYYYMMDD'); -- 1月前
        WHEN 21 THEN
            V_RETUR_DATE := to_char(add_months(V_DATE, -6), 'YYYYMMDD'); -- 6月前

        ELSE
            V_RETUR_DATE := NULL;
    END CASE;

    RETURN V_RETUR_DATE;
END;
;