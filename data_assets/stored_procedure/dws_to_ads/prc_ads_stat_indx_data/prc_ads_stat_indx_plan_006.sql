-------------------------------------------------------------------------
-- 需求版本: v5.0 (2026-08-25)
-- 变更记录:
--   v4.6 0071年龄边界修正：70岁以下改为AGE<70（原<=70）
--   v4.7 0064改标签表口径：基数表ADS_CRM_R_SALRY_PAYROL_BASE按活动/任务隔离取新增
--   v4.8 0065代销业务收入（暂不含贵金属）：理财FIN_AMT+保险INSUR_AMT合并，期间[开始日,跑批日]
--   v4.9 修复0071/0072未声明变量V_YEAR_BEGIN/V_180_DAY_BEGIN；补全代发薪客户净增INDX_0064汇总段(7.17/7.18)
--   v5.0 AGGR汇总表拆分：写入专属表TMP_STAT_INDX_AGGR_006并段首自清；基数表按活动结束日+3个自然月清理
-------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE CRMDM.PRC_ADS_STAT_INDX_PLAN_006
(
	V_SYSDAT IN VARCHAR2,
	OUTCDE   OUT INTEGER
) AS
	V_PRC_DESC   VARCHAR2(100) := '指标数据统计步骤66处理完成 6';
	V_PRC_NAME   VARCHAR2(32) := 'PRC_ADS_STAT_INDX_PLAN_006';
	V_LOG_MSG    VARCHAR2(4000);
	V_LOG_FLG    INTEGER;
	V_LOG_BUTTON INTEGER := 1;
	V_NO_ID      VARCHAR2(10);
	V_BGN_DATE   DATE;
	V_END_DATE   DATE;
	V_DURA_DATE  INTEGER;
	V_YEAR_BEGIN    VARCHAR2(8) := SYS_FUN_DEAL_DATE(V_SYSDAT, 13);
	V_180_DAY_BEGIN VARCHAR2(8) := SYS_FUN_DEAL_DATE(V_SYSDAT, 27);
BEGIN
	V_NO_ID    := '0';
	V_BGN_DATE := SYSDATE;
	IF V_SYSDAT IS NULL
		 OR NOT REGEXP_LIKE(V_SYSDAT, '^[0-9]{8}$')
	THEN
		RAISE_APPLICATION_ERROR(-20001, 'V_SYSDAT必须为YYYYMMDD格式');
	END IF;
	V_END_DATE := TO_DATE(V_SYSDAT, 'YYYYMMDD');

   -------------------------------------------------------------------------
   -- 7.0.0 基数表生命周期清理（INDX_0064）
   -- 每日巡检：活动/任务结束日+3个自然月 <= 跑批日 → 删除该活动基数
   --   A路径: DWD_MKT_ACT_INFO.STATIS_STOP_DATE
   --   B路径: DWD_MKT_TSK_INDX_SUB.TSK_END_DATE（任务级一致）
   --   另：AGGR 段首自清，本过程专属汇总临时表，防止重跑/并行残留
   -------------------------------------------------------------------------
   DELETE FROM TMP_STAT_INDX_AGGR_006;

   DELETE FROM ADS_CRM_R_SALRY_PAYROL_BASE T
    WHERE (T.PATH_CODE = 'A'
           AND EXISTS (SELECT 1
                         FROM DWD_MKT_ACT_INFO A
                        WHERE A.MKT_ACT_ID = T.STATIS_DIM
                          AND ADD_MONTHS(TO_DATE(A.STATIS_STOP_DATE, 'YYYYMMDD'), 3)
                              <= TO_DATE(V_SYSDAT, 'YYYYMMDD')))
       OR (T.PATH_CODE = 'B'
           AND EXISTS (SELECT 1
                         FROM DWD_MKT_TSK_INDX_SUB S
                        WHERE S.TSK_ID = T.STATIS_DIM
                          AND ADD_MONTHS(TO_DATE(S.TSK_END_DATE, 'YYYYMMDD'), 3)
                              <= TO_DATE(V_SYSDAT, 'YYYYMMDD')));
   -------------------------------------------------------------------------
   -- 7.0 代发薪客户基数表刷新（INDX_0064）
   -- 每日跑批：范围内客户标签 IS_NOT_SALRY_PAYROL_BK='1' 入基数表
   --   新活动/任务首次出现：FRST_MARK_DATE='19000101'（活动前基数，不计新增）
   --   活动期间新增标记：FRST_MARK_DATE=跑批日
   -------------------------------------------------------------------------
   INSERT INTO ADS_CRM_R_SALRY_PAYROL_BASE
          (PATH_CODE, STATIS_DIM, PERSN_LEGAL_BK_CODE, CUST_ID, FRST_MARK_DATE)
          WITH SCOPE_BASE AS
           (SELECT 'A' AS PATH_CODE,
                           S.STATIS_DIM,
                           TI.CUST_ID,
                           S.PERSN_LEGAL_BK_CODE
                          FROM TMP_STAT_INDX_SCOPE S
                   INNER JOIN DWD_MKT_TSK_INFO TI ON TI.MKT_ACT_ID = S.STATIS_DIM
                                                   AND TI.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE
                                                   AND TI.DATA_DATE = V_SYSDAT
                                                   AND ((S.BLNG_TYPE = 'O' AND TI.MKT_PERSN_ORG = S.BLNG_ID) OR
                                                        (S.BLNG_TYPE = 'M' AND TI.MKT_PERSN = S.BLNG_ID))
                   WHERE S.PATH_CODE = 'A'
                     AND S.INDX_CODE = 'INDX_0064'
            UNION ALL
            SELECT 'B',
                          S.STATIS_DIM,
                          LV.CUST_ID,
                          S.PERSN_LEGAL_BK_CODE
                          FROM TMP_STAT_INDX_SCOPE S
                   INNER JOIN DWS_CUST_LVL_INFO LV ON S.BLNG_TYPE = 'O'
                                                    AND LV.ORG_ID = S.BLNG_ID
                                                    AND LV.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE
                                                    AND LV.DATA_DATE = V_SYSDAT
                   WHERE S.PATH_CODE = 'B'
                     AND S.INDX_CODE = 'INDX_0064'
            UNION ALL
            SELECT 'B',
                          S.STATIS_DIM,
                          CM.CUST_ID,
                          S.PERSN_LEGAL_BK_CODE
                          FROM TMP_STAT_INDX_SCOPE S
                   INNER JOIN DWD_CUST_MAN CM ON S.BLNG_TYPE = 'M'
                                              AND CM.MNGR_POST_ID = S.BLNG_ID
                                              AND CM.MNG_TYP = '1'
                                              AND CM.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE
                   WHERE S.PATH_CODE = 'B'
                     AND S.INDX_CODE = 'INDX_0064')
          SELECT DISTINCT
                 SB.PATH_CODE,
                 SB.STATIS_DIM,
                 SB.PERSN_LEGAL_BK_CODE,
                 SB.CUST_ID,
                 CASE
                     WHEN EXISTS (SELECT 1
                                    FROM ADS_CRM_R_SALRY_PAYROL_BASE EB
                                   WHERE EB.PATH_CODE = SB.PATH_CODE
                                     AND EB.STATIS_DIM = SB.STATIS_DIM) THEN
                         V_SYSDAT
                     ELSE
                         '19000101'
                 END AS FRST_MARK_DATE
            FROM SCOPE_BASE SB
           INNER JOIN ADS_CRM_R_CUST_LABLE L
               ON L.CUST_ID = SB.CUST_ID
              AND L.PERSN_LEGAL_BK_CODE = SB.PERSN_LEGAL_BK_CODE
           WHERE L.IS_NOT_SALRY_PAYROL_BK = '1'
             AND NOT EXISTS (SELECT 1
                               FROM ADS_CRM_R_SALRY_PAYROL_BASE NB
                              WHERE NB.PATH_CODE = SB.PATH_CODE
                                AND NB.STATIS_DIM = SB.STATIS_DIM
                                AND NB.CUST_ID = SB.CUST_ID
                                AND NB.PERSN_LEGAL_BK_CODE = SB.PERSN_LEGAL_BK_CODE);
	-------------------------------------------------------------------------
	-- 7.1/7.2 保险新保保费 INDX_0061 (合并 A/B)
	-------------------------------------------------------------------------
	INSERT INTO TMP_STAT_INDX_AGGR_006
		(PATH_CODE,
		 DATA_DATE,
		 DATA_BLNG,
		 STATIS_DIM,
		 STATIS_CALIB,
		 INDX_CODE,
		 CURNT_VAL,
		 TERM_LAST_VAL,
		 PERSN_LEGAL_BK_CODE)
		WITH SCOPE_ALL AS
		 (SELECT 'A' AS PATH_CODE,
						 '营销活动' AS STATIS_CALIB,
						 S.STATIS_DIM,
						 S.DATA_BLNG,
						 S.TERM_BEGIN_DATE,
						 TI.CUST_ID,
						 S.PERSN_LEGAL_BK_CODE
				FROM TMP_STAT_INDX_SCOPE S
			 INNER JOIN DWD_MKT_TSK_INFO TI ON TI.MKT_ACT_ID = S.STATIS_DIM
																		 AND TI.PERSN_LEGAL_BK_CODE =
																				 S.PERSN_LEGAL_BK_CODE
																		 AND TI.DATA_DATE = V_SYSDAT
																		 AND ((S.BLNG_TYPE = 'O' AND
																				 TI.MKT_PERSN_ORG = S.BLNG_ID) OR
																				 (S.BLNG_TYPE = 'M' AND
																				 TI.MKT_PERSN = S.BLNG_ID))
			 WHERE S.PATH_CODE = 'A'
				 AND S.INDX_CODE = 'INDX_0061'
			UNION ALL
			SELECT 'B',
						 '目标任务',
						 S.STATIS_DIM,
						 S.DATA_BLNG,
						 S.TERM_BEGIN_DATE,
						 LV.CUST_ID,
						 S.PERSN_LEGAL_BK_CODE
				FROM TMP_STAT_INDX_SCOPE S
			 INNER JOIN DWS_CUST_LVL_INFO LV ON S.BLNG_TYPE = 'O'
																			AND LV.ORG_ID = S.BLNG_ID
																			AND LV.PERSN_LEGAL_BK_CODE =
																					S.PERSN_LEGAL_BK_CODE
																			AND LV.DATA_DATE = V_SYSDAT
			 WHERE S.PATH_CODE = 'B'
				 AND S.INDX_CODE = 'INDX_0061'
			UNION ALL
			SELECT 'B',
						 '目标任务',
						 S.STATIS_DIM,
						 S.DATA_BLNG,
						 S.TERM_BEGIN_DATE,
						 CM.CUST_ID,
						 S.PERSN_LEGAL_BK_CODE
				FROM TMP_STAT_INDX_SCOPE S
			 INNER JOIN DWD_CUST_MAN CM ON S.BLNG_TYPE = 'M'
																 AND CM.MNGR_POST_ID = S.BLNG_ID
																 AND CM.MNG_TYP = '1'
																 AND CM.PERSN_LEGAL_BK_CODE =
																		 S.PERSN_LEGAL_BK_CODE
			 WHERE S.PATH_CODE = 'B'
				 AND S.INDX_CODE = 'INDX_0061')
		SELECT SM.PATH_CODE,
					 V_SYSDAT,
					 SM.DATA_BLNG,
					 SM.STATIS_DIM,
					 SM.STATIS_CALIB,
					 'INDX_0061',
					 SUM(NVL(I.NEW_INSUR_AMT, 0)),
					 0,
					 SM.PERSN_LEGAL_BK_CODE
			FROM (SELECT DISTINCT PATH_CODE,
														STATIS_CALIB,
														STATIS_DIM,
														DATA_BLNG,
														TERM_BEGIN_DATE,
														CUST_ID,
														PERSN_LEGAL_BK_CODE
							FROM SCOPE_ALL) SM
		 INNER JOIN DWD_ACCT_INSUR I ON I.CUST_ID = SM.CUST_ID
																AND I.PERSN_LEGAL_BK_CODE =
																		SM.PERSN_LEGAL_BK_CODE
																AND I.POLICY_STATE = '1'
																AND I.TX_DATE BETWEEN SM.TERM_BEGIN_DATE AND
																		V_SYSDAT
		 GROUP BY SM.PATH_CODE,
							SM.DATA_BLNG,
							SM.STATIS_DIM,
							SM.STATIS_CALIB,
							SM.PERSN_LEGAL_BK_CODE;

	-------------------------------------------------------------------------
	-- 7.3/7.4 手机银行活跃客户数 INDX_0067 (合并 A/B)
	-------------------------------------------------------------------------
	INSERT INTO TMP_STAT_INDX_AGGR_006
		(PATH_CODE,
		 DATA_DATE,
		 DATA_BLNG,
		 STATIS_DIM,
		 STATIS_CALIB,
		 INDX_CODE,
		 CURNT_VAL,
		 TERM_LAST_VAL,
		 PERSN_LEGAL_BK_CODE)
		WITH SCOPE_ALL AS
		 (SELECT 'A' AS PATH_CODE,
						 '营销活动' AS STATIS_CALIB,
						 S.STATIS_DIM,
						 S.DATA_BLNG,
						 TI.CUST_ID,
						 S.PERSN_LEGAL_BK_CODE
				FROM TMP_STAT_INDX_SCOPE S
			 INNER JOIN DWD_MKT_TSK_INFO TI ON TI.MKT_ACT_ID = S.STATIS_DIM
																		 AND TI.PERSN_LEGAL_BK_CODE =
																				 S.PERSN_LEGAL_BK_CODE
																		 AND TI.DATA_DATE = V_SYSDAT
																		 AND ((S.BLNG_TYPE = 'O' AND
																				 TI.MKT_PERSN_ORG = S.BLNG_ID) OR
																				 (S.BLNG_TYPE = 'M' AND
																				 TI.MKT_PERSN = S.BLNG_ID))
			 WHERE S.PATH_CODE = 'A'
				 AND S.INDX_CODE = 'INDX_0067'
			UNION ALL
			SELECT 'B',
						 '目标任务',
						 S.STATIS_DIM,
						 S.DATA_BLNG,
						 LV.CUST_ID,
						 S.PERSN_LEGAL_BK_CODE
				FROM TMP_STAT_INDX_SCOPE S
			 INNER JOIN DWS_CUST_LVL_INFO LV ON S.BLNG_TYPE = 'O'
																			AND LV.ORG_ID = S.BLNG_ID
																			AND LV.PERSN_LEGAL_BK_CODE =
																					S.PERSN_LEGAL_BK_CODE
																			AND LV.DATA_DATE = V_SYSDAT
			 WHERE S.PATH_CODE = 'B'
				 AND S.INDX_CODE = 'INDX_0067'
			UNION ALL
			SELECT 'B',
						 '目标任务',
						 S.STATIS_DIM,
						 S.DATA_BLNG,
						 CM.CUST_ID,
						 S.PERSN_LEGAL_BK_CODE
				FROM TMP_STAT_INDX_SCOPE S
			 INNER JOIN DWD_CUST_MAN CM ON S.BLNG_TYPE = 'M'
																 AND CM.MNGR_POST_ID = S.BLNG_ID
																 AND CM.MNG_TYP = '1'
																 AND CM.PERSN_LEGAL_BK_CODE =
																		 S.PERSN_LEGAL_BK_CODE
			 WHERE S.PATH_CODE = 'B'
				 AND S.INDX_CODE = 'INDX_0067')
		SELECT SM.PATH_CODE,
					 V_SYSDAT,
					 SM.DATA_BLNG,
					 SM.STATIS_DIM,
					 SM.STATIS_CALIB,
					 'INDX_0067',
					 COUNT(DISTINCT SM.CUST_ID),
					 0,
					 SM.PERSN_LEGAL_BK_CODE
			FROM SCOPE_ALL SM
		 INNER JOIN ADS_CRM_R_CUST_LABLE L ON L.CUST_ID = SM.CUST_ID
																			AND L.PERSN_LEGAL_BK_CODE =
																					SM.PERSN_LEGAL_BK_CODE
																			AND L.IS_NOT_BK_PHONE_ACTV_CUST = '1'
		 GROUP BY SM.PATH_CODE,
							SM.DATA_BLNG,
							SM.STATIS_DIM,
							SM.STATIS_CALIB,
							SM.PERSN_LEGAL_BK_CODE;

	-------------------------------------------------------------------------
	-- 7.5/7.6 收单价值商户数 INDX_0068 (合并 A/B)
	-------------------------------------------------------------------------
	INSERT INTO TMP_STAT_INDX_AGGR_006
		(PATH_CODE,
		 DATA_DATE,
		 DATA_BLNG,
		 STATIS_DIM,
		 STATIS_CALIB,
		 INDX_CODE,
		 CURNT_VAL,
		 TERM_LAST_VAL,
		 PERSN_LEGAL_BK_CODE)
		WITH SCOPE_ALL AS
		 (SELECT 'A' AS PATH_CODE,
						 '营销活动' AS STATIS_CALIB,
						 S.STATIS_DIM,
						 S.DATA_BLNG,
						 S.PERSN_LEGAL_BK_CODE,
						 M.MCT_ID
				FROM TMP_STAT_INDX_SCOPE S
			 INNER JOIN UEPP_PAY_MCT_INFO M ON ((S.BLNG_TYPE = 'O' AND
																				 M.ORG_ID = S.BLNG_ID) OR
																				 (S.BLNG_TYPE = 'M' AND
																				 M.JOB_ID = S.BLNG_ID))
			 WHERE S.PATH_CODE = 'A'
				 AND S.INDX_CODE = 'INDX_0068'
			UNION ALL
			SELECT 'B',
						 '目标任务',
						 S.STATIS_DIM,
						 S.DATA_BLNG,
						 S.PERSN_LEGAL_BK_CODE,
						 M.MCT_ID
				FROM TMP_STAT_INDX_SCOPE S
			 INNER JOIN UEPP_PAY_MCT_INFO M ON ((S.BLNG_TYPE = 'O' AND
																				 M.ORG_ID = S.BLNG_ID) OR
																				 (S.BLNG_TYPE = 'M' AND
																				 M.JOB_ID = S.BLNG_ID))
			 WHERE S.PATH_CODE = 'B'
				 AND S.INDX_CODE = 'INDX_0068'),
		VAL_MERCHANT AS
		 (SELECT DISTINCT SM.PATH_CODE,
											SM.STATIS_CALIB,
											SM.STATIS_DIM,
											SM.DATA_BLNG,
											SM.PERSN_LEGAL_BK_CODE,
											L.CUST_ID
				FROM (SELECT DISTINCT PATH_CODE,
															STATIS_CALIB,
															STATIS_DIM,
															DATA_BLNG,
															PERSN_LEGAL_BK_CODE,
															MCT_ID
								FROM SCOPE_ALL) SM
			 INNER JOIN UEPP_PAY_MCT_SETTLE_ACCOUNT SA ON SA.MCT_ID = SM.MCT_ID
																								AND SA.CUST_NO IS NOT NULL
			 INNER JOIN ADS_CRM_R_CUST_LABLE L ON L.CUST_ID = SA.CUST_NO
																				AND L.PERSN_LEGAL_BK_CODE =
																						SM.PERSN_LEGAL_BK_CODE
																				AND L.IS_NOT_BILL_RSV_VAL_MKNT = '1')
		SELECT PATH_CODE,
					 V_SYSDAT,
					 DATA_BLNG,
					 STATIS_DIM,
					 STATIS_CALIB,
					 'INDX_0068',
					 COUNT(DISTINCT CUST_ID),
					 0,
					 PERSN_LEGAL_BK_CODE
			FROM VAL_MERCHANT
		 GROUP BY PATH_CODE,
							DATA_BLNG,
							STATIS_DIM,
							STATIS_CALIB,
							PERSN_LEGAL_BK_CODE;

	-------------------------------------------------------------------------
	-- 7.7/7.8 一码付收款客户数 INDX_0076 (合并 A/B)
	-------------------------------------------------------------------------
	INSERT INTO TMP_STAT_INDX_AGGR_006
		(PATH_CODE,
		 DATA_DATE,
		 DATA_BLNG,
		 STATIS_DIM,
		 STATIS_CALIB,
		 INDX_CODE,
		 CURNT_VAL,
		 TERM_LAST_VAL,
		 PERSN_LEGAL_BK_CODE)
		WITH SCOPE_ALL AS
		 (SELECT 'A' AS PATH_CODE,
						 '营销活动' AS STATIS_CALIB,
						 S.STATIS_DIM,
						 S.DATA_BLNG,
						 S.TERM_BEGIN_DATE,
						 TI.CUST_ID,
						 S.PERSN_LEGAL_BK_CODE
				FROM TMP_STAT_INDX_SCOPE S
			 INNER JOIN DWD_MKT_TSK_INFO TI ON TI.MKT_ACT_ID = S.STATIS_DIM
																		 AND TI.PERSN_LEGAL_BK_CODE =
																				 S.PERSN_LEGAL_BK_CODE
																		 AND TI.DATA_DATE = V_SYSDAT
																		 AND ((S.BLNG_TYPE = 'O' AND
																				 TI.MKT_PERSN_ORG = S.BLNG_ID) OR
																				 (S.BLNG_TYPE = 'M' AND
																				 TI.MKT_PERSN = S.BLNG_ID))
			 WHERE S.PATH_CODE = 'A'
				 AND S.INDX_CODE = 'INDX_0076'
			UNION ALL
			SELECT 'B',
						 '目标任务',
						 S.STATIS_DIM,
						 S.DATA_BLNG,
						 S.TERM_BEGIN_DATE,
						 LV.CUST_ID,
						 S.PERSN_LEGAL_BK_CODE
				FROM TMP_STAT_INDX_SCOPE S
			 INNER JOIN DWS_CUST_LVL_INFO LV ON S.BLNG_TYPE = 'O'
																			AND LV.ORG_ID = S.BLNG_ID
																			AND LV.PERSN_LEGAL_BK_CODE =
																					S.PERSN_LEGAL_BK_CODE
																			AND LV.DATA_DATE = V_SYSDAT
			 WHERE S.PATH_CODE = 'B'
				 AND S.INDX_CODE = 'INDX_0076'
			UNION ALL
			SELECT 'B',
						 '目标任务',
						 S.STATIS_DIM,
						 S.DATA_BLNG,
						 S.TERM_BEGIN_DATE,
						 CM.CUST_ID,
						 S.PERSN_LEGAL_BK_CODE
				FROM TMP_STAT_INDX_SCOPE S
			 INNER JOIN DWD_CUST_MAN CM ON S.BLNG_TYPE = 'M'
																 AND CM.MNGR_POST_ID = S.BLNG_ID
																 AND CM.MNG_TYP = '1'
																 AND CM.PERSN_LEGAL_BK_CODE =
																		 S.PERSN_LEGAL_BK_CODE
			 WHERE S.PATH_CODE = 'B'
				 AND S.INDX_CODE = 'INDX_0076'),
		MERCHANT_CUSTOMER AS
		 (SELECT DISTINCT SC.PATH_CODE,
											SC.STATIS_CALIB,
											SC.STATIS_DIM,
											SC.DATA_BLNG,
											SC.PERSN_LEGAL_BK_CODE,
											SA.CUST_NO AS CUST_ID
				FROM (SELECT DISTINCT PATH_CODE,
															STATIS_CALIB,
															STATIS_DIM,
															DATA_BLNG,
															TERM_BEGIN_DATE,
															CUST_ID,
															PERSN_LEGAL_BK_CODE
								FROM SCOPE_ALL) SC
			 INNER JOIN DWD_CUST_INDV_INFO CI ON CI.CUST_ID = SC.CUST_ID
																			 AND CI.PERSN_LEGAL_BK_CODE =
																					 SC.PERSN_LEGAL_BK_CODE
			 INNER JOIN UEPP_PAY_MCT_SETTLE_ACCOUNT SA ON SA.CUST_NO = SC.CUST_ID
																								AND SA.STATUS <> '9'
			 INNER JOIN UEPP_PAY_MCT_INFO M ON M.MCT_ID = SA.MCT_ID
																		 AND M.MCT_TYPE IN
																				 ('personage', 'smallBusinesses')
																		 AND M.STATUS <> '9')
		SELECT PATH_CODE,
					 V_SYSDAT,
					 DATA_BLNG,
					 STATIS_DIM,
					 STATIS_CALIB,
					 'INDX_0076',
					 COUNT(DISTINCT CUST_ID),
					 0,
					 PERSN_LEGAL_BK_CODE
			FROM MERCHANT_CUSTOMER
		 GROUP BY PATH_CODE,
							DATA_BLNG,
							STATIS_DIM,
							STATIS_CALIB,
							PERSN_LEGAL_BK_CODE;

	-------------------------------------------------------------------------
	-- 7.9/7.10 一码付新增客户数 INDX_0077 (合并 A/B)
	-------------------------------------------------------------------------
	INSERT INTO TMP_STAT_INDX_AGGR_006
		(PATH_CODE,
		 DATA_DATE,
		 DATA_BLNG,
		 STATIS_DIM,
		 STATIS_CALIB,
		 INDX_CODE,
		 CURNT_VAL,
		 TERM_LAST_VAL,
		 PERSN_LEGAL_BK_CODE)
		WITH SCOPE_ALL AS
		 (SELECT 'A' AS PATH_CODE,
						 '营销活动' AS STATIS_CALIB,
						 S.STATIS_DIM,
						 S.DATA_BLNG,
						 S.TERM_BEGIN_DATE,
						 TI.CUST_ID,
						 S.PERSN_LEGAL_BK_CODE
				FROM TMP_STAT_INDX_SCOPE S
			 INNER JOIN DWD_MKT_TSK_INFO TI ON TI.MKT_ACT_ID = S.STATIS_DIM
																		 AND TI.PERSN_LEGAL_BK_CODE =
																				 S.PERSN_LEGAL_BK_CODE
																		 AND TI.DATA_DATE = V_SYSDAT
																		 AND ((S.BLNG_TYPE = 'O' AND
																				 TI.MKT_PERSN_ORG = S.BLNG_ID) OR
																				 (S.BLNG_TYPE = 'M' AND
																				 TI.MKT_PERSN = S.BLNG_ID))
			 WHERE S.PATH_CODE = 'A'
				 AND S.INDX_CODE = 'INDX_0077'
			UNION ALL
			SELECT 'B',
						 '目标任务',
						 S.STATIS_DIM,
						 S.DATA_BLNG,
						 S.TERM_BEGIN_DATE,
						 LV.CUST_ID,
						 S.PERSN_LEGAL_BK_CODE
				FROM TMP_STAT_INDX_SCOPE S
			 INNER JOIN DWS_CUST_LVL_INFO LV ON S.BLNG_TYPE = 'O'
																			AND LV.ORG_ID = S.BLNG_ID
																			AND LV.PERSN_LEGAL_BK_CODE =
																					S.PERSN_LEGAL_BK_CODE
																			AND LV.DATA_DATE = V_SYSDAT
			 WHERE S.PATH_CODE = 'B'
				 AND S.INDX_CODE = 'INDX_0077'
			UNION ALL
			SELECT 'B',
						 '目标任务',
						 S.STATIS_DIM,
						 S.DATA_BLNG,
						 S.TERM_BEGIN_DATE,
						 CM.CUST_ID,
						 S.PERSN_LEGAL_BK_CODE
				FROM TMP_STAT_INDX_SCOPE S
			 INNER JOIN DWD_CUST_MAN CM ON S.BLNG_TYPE = 'M'
																 AND CM.MNGR_POST_ID = S.BLNG_ID
																 AND CM.MNG_TYP = '1'
																 AND CM.PERSN_LEGAL_BK_CODE =
																		 S.PERSN_LEGAL_BK_CODE
			 WHERE S.PATH_CODE = 'B'
				 AND S.INDX_CODE = 'INDX_0077'),
		MERCHANT_CUSTOMER AS
		 (SELECT DISTINCT SC.PATH_CODE,
											SC.STATIS_CALIB,
											SC.STATIS_DIM,
											SC.DATA_BLNG,
											SC.TERM_BEGIN_DATE,
											SC.PERSN_LEGAL_BK_CODE,
											SA.CUST_NO AS CUST_ID,
											M.SIGN_DATE
				FROM (SELECT DISTINCT PATH_CODE,
															STATIS_CALIB,
															STATIS_DIM,
															DATA_BLNG,
															TERM_BEGIN_DATE,
															CUST_ID,
															PERSN_LEGAL_BK_CODE
								FROM SCOPE_ALL) SC
			 INNER JOIN DWD_CUST_INDV_INFO CI ON CI.CUST_ID = SC.CUST_ID
																			 AND CI.PERSN_LEGAL_BK_CODE =
																					 SC.PERSN_LEGAL_BK_CODE
			 INNER JOIN UEPP_PAY_MCT_SETTLE_ACCOUNT SA ON SA.CUST_NO = SC.CUST_ID
																								AND SA.STATUS <> '9'
			 INNER JOIN UEPP_PAY_MCT_INFO M ON M.MCT_ID = SA.MCT_ID
																		 AND M.MCT_TYPE IN
																				 ('personage', 'smallBusinesses')
																		 AND M.STATUS <> '9')
		SELECT PATH_CODE,
					 V_SYSDAT,
					 DATA_BLNG,
					 STATIS_DIM,
					 STATIS_CALIB,
					 'INDX_0077',
					 COUNT(DISTINCT CASE
									 WHEN SIGN_DATE BETWEEN TERM_BEGIN_DATE AND V_SYSDAT THEN
										CUST_ID
								 END),
					 0,
					 PERSN_LEGAL_BK_CODE
			FROM MERCHANT_CUSTOMER
		 GROUP BY PATH_CODE,
							DATA_BLNG,
							STATIS_DIM,
							STATIS_CALIB,
							PERSN_LEGAL_BK_CODE;

	-------------------------------------------------------------------------
	-- 7.11/7.12 银行卡三方支付绑卡数 INDX_0070（A/B，活动期间）
	-------------------------------------------------------------------------
	INSERT INTO TMP_STAT_INDX_AGGR_006
		(PATH_CODE,
		 DATA_DATE,
		 DATA_BLNG,
		 STATIS_DIM,
		 STATIS_CALIB,
		 INDX_CODE,
		 CURNT_VAL,
		 TERM_LAST_VAL,
		 PERSN_LEGAL_BK_CODE)
		WITH BIND_CARD AS
		 (SELECT SGN_ACCT_ID_DE AS CARD_NO,
						 MIN(TXN_DATE) AS BIND_DATE
				FROM ECPP_E_TXN_SIGN
			 WHERE STATUS = '00'
				 AND INSTG_ID IN
						 ('Z2004944000010', 'Z2007933000010', 'Z2009331000015')
			 GROUP BY SGN_ACCT_ID_DE),
		SCOPE_ALL AS
		 (SELECT 'A' AS PATH_CODE,
						 '营销活动' AS STATIS_CALIB,
						 S.STATIS_DIM,
						 S.DATA_BLNG,
						 S.TERM_BEGIN_DATE,
						 TI.CUST_ID,
						 S.PERSN_LEGAL_BK_CODE
				FROM TMP_STAT_INDX_SCOPE S
			 INNER JOIN DWD_MKT_TSK_INFO TI ON TI.MKT_ACT_ID = S.STATIS_DIM
																		 AND TI.PERSN_LEGAL_BK_CODE =
																				 S.PERSN_LEGAL_BK_CODE
																		 AND TI.DATA_DATE = V_SYSDAT
																		 AND ((S.BLNG_TYPE = 'O' AND
																				 TI.MKT_PERSN_ORG = S.BLNG_ID) OR
																				 (S.BLNG_TYPE = 'M' AND
																				 TI.MKT_PERSN = S.BLNG_ID))
			 WHERE S.PATH_CODE = 'A'
				 AND S.INDX_CODE = 'INDX_0070'
			UNION ALL
			SELECT 'B',
						 '目标任务',
						 S.STATIS_DIM,
						 S.DATA_BLNG,
						 S.TERM_BEGIN_DATE,
						 LV.CUST_ID,
						 S.PERSN_LEGAL_BK_CODE
				FROM TMP_STAT_INDX_SCOPE S
			 INNER JOIN DWS_CUST_LVL_INFO LV ON S.BLNG_TYPE = 'O'
																			AND LV.ORG_ID = S.BLNG_ID
																			AND LV.PERSN_LEGAL_BK_CODE =
																					S.PERSN_LEGAL_BK_CODE
																			AND LV.DATA_DATE = V_SYSDAT
			 WHERE S.PATH_CODE = 'B'
				 AND S.INDX_CODE = 'INDX_0070'
			UNION ALL
			SELECT 'B',
						 '目标任务',
						 S.STATIS_DIM,
						 S.DATA_BLNG,
						 S.TERM_BEGIN_DATE,
						 CM.CUST_ID,
						 S.PERSN_LEGAL_BK_CODE
				FROM TMP_STAT_INDX_SCOPE S
			 INNER JOIN DWD_CUST_MAN CM ON S.BLNG_TYPE = 'M'
																 AND CM.MNGR_POST_ID = S.BLNG_ID
																 AND CM.MNG_TYP = '1'
																 AND CM.PERSN_LEGAL_BK_CODE =
																		 S.PERSN_LEGAL_BK_CODE
			 WHERE S.PATH_CODE = 'B'
				 AND S.INDX_CODE = 'INDX_0070'),
		CARD_SCOPE AS
		 (SELECT DISTINCT X.PATH_CODE,
											X.STATIS_CALIB,
											X.STATIS_DIM,
											X.DATA_BLNG,
											X.TERM_BEGIN_DATE,
											X.PERSN_LEGAL_BK_CODE,
											C.KEHUHAOO            AS CUST_ID,
											C.KAHAOOOO            AS CARD_NO
				FROM SCOPE_ALL X
			 INNER JOIN CBS_KCDA_PZJCXX C ON C.KEHUHAOO = X.CUST_ID
																	 AND CASE
																				 WHEN C.FAKAJIGO LIKE '12%' THEN
																					'1200'
																				 WHEN C.FAKAJIGO LIKE '15%' THEN
																					'1500'
																				 WHEN C.FAKAJIGO LIKE '18%' THEN
																					'1800'
																				 ELSE
																					'9999'
																			 END = X.PERSN_LEGAL_BK_CODE)
		SELECT X.PATH_CODE,
					 V_SYSDAT,
					 X.DATA_BLNG,
					 X.STATIS_DIM,
					 X.STATIS_CALIB,
					 'INDX_0070',
					 COUNT(DISTINCT X.CUST_ID),
					 0,
					 X.PERSN_LEGAL_BK_CODE
			FROM CARD_SCOPE X
		 INNER JOIN BIND_CARD B ON B.CARD_NO = X.CARD_NO
													 AND B.BIND_DATE BETWEEN X.TERM_BEGIN_DATE AND
															 V_SYSDAT
		 GROUP BY X.PATH_CODE,
							X.DATA_BLNG,
							X.STATIS_DIM,
							X.STATIS_CALIB,
							X.PERSN_LEGAL_BK_CODE;

	-------------------------------------------------------------------------
	-- 7.13/7.14 银行卡三方支付绑卡率 INDX_0071（A/B，本年）
	-------------------------------------------------------------------------
	INSERT INTO TMP_STAT_INDX_AGGR_006
		(PATH_CODE,
		 DATA_DATE,
		 DATA_BLNG,
		 STATIS_DIM,
		 STATIS_CALIB,
		 INDX_CODE,
		 CURNT_VAL,
		 TERM_LAST_VAL,
		 PERSN_LEGAL_BK_CODE)
		WITH BIND_CARD AS
		 (SELECT DISTINCT SGN_ACCT_ID_DE AS CARD_NO
				FROM ECPP_E_TXN_SIGN
			 WHERE STATUS = '00'
				 AND INSTG_ID IN
						 ('Z2004944000010', 'Z2007933000010', 'Z2009331000015')),
		SCOPE_ALL AS
		 (SELECT 'A' AS PATH_CODE,
						 '营销活动' AS STATIS_CALIB,
						 S.STATIS_DIM,
						 S.DATA_BLNG,
						 TI.CUST_ID,
						 S.PERSN_LEGAL_BK_CODE
				FROM TMP_STAT_INDX_SCOPE S
			 INNER JOIN DWD_MKT_TSK_INFO TI ON TI.MKT_ACT_ID = S.STATIS_DIM
																		 AND TI.PERSN_LEGAL_BK_CODE =
																				 S.PERSN_LEGAL_BK_CODE
																		 AND TI.DATA_DATE = V_SYSDAT
																		 AND ((S.BLNG_TYPE = 'O' AND
																				 TI.MKT_PERSN_ORG = S.BLNG_ID) OR
																				 (S.BLNG_TYPE = 'M' AND
																				 TI.MKT_PERSN = S.BLNG_ID))
			 WHERE S.PATH_CODE = 'A'
				 AND S.INDX_CODE = 'INDX_0071'
			UNION ALL
			SELECT 'B',
						 '目标任务',
						 S.STATIS_DIM,
						 S.DATA_BLNG,
						 LV.CUST_ID,
						 S.PERSN_LEGAL_BK_CODE
				FROM TMP_STAT_INDX_SCOPE S
			 INNER JOIN DWS_CUST_LVL_INFO LV ON S.BLNG_TYPE = 'O'
																			AND LV.ORG_ID = S.BLNG_ID
																			AND LV.PERSN_LEGAL_BK_CODE =
																					S.PERSN_LEGAL_BK_CODE
																			AND LV.DATA_DATE = V_SYSDAT
			 WHERE S.PATH_CODE = 'B'
				 AND S.INDX_CODE = 'INDX_0071'
			UNION ALL
			SELECT 'B',
						 '目标任务',
						 S.STATIS_DIM,
						 S.DATA_BLNG,
						 CM.CUST_ID,
						 S.PERSN_LEGAL_BK_CODE
				FROM TMP_STAT_INDX_SCOPE S
			 INNER JOIN DWD_CUST_MAN CM ON S.BLNG_TYPE = 'M'
																 AND CM.MNGR_POST_ID = S.BLNG_ID
																 AND CM.MNG_TYP = '1'
																 AND CM.PERSN_LEGAL_BK_CODE =
																		 S.PERSN_LEGAL_BK_CODE
			 WHERE S.PATH_CODE = 'B'
				 AND S.INDX_CODE = 'INDX_0071'),
		NEW_CUST AS
		 (SELECT DISTINCT X.PATH_CODE,
											X.STATIS_CALIB,
											X.STATIS_DIM,
											X.DATA_BLNG,
											X.PERSN_LEGAL_BK_CODE,
											C.KEHUHAOO            AS CUST_ID,
											C.KAHAOOOO            AS CARD_NO
				FROM SCOPE_ALL X
			 INNER JOIN CBS_KCDA_PZJCXX C ON C.KEHUHAOO = X.CUST_ID
																	 AND CASE
																				 WHEN C.FAKAJIGO LIKE '12%' THEN
																					'1200'
																				 WHEN C.FAKAJIGO LIKE '15%' THEN
																					'1500'
																				 WHEN C.FAKAJIGO LIKE '18%' THEN
																					'1800'
																				 ELSE
																					'9999'
																			 END = X.PERSN_LEGAL_BK_CODE
																	 AND C.FAKARIQI BETWEEN
																			 V_YEAR_BEGIN AND
																			 V_SYSDAT),
		ELIGIBLE AS
		 (SELECT N.*
				FROM NEW_CUST N
			 INNER JOIN DWD_CUST_INDV_INFO I ON I.CUST_ID = N.CUST_ID
																			AND I.PERSN_LEGAL_BK_CODE =
																					N.PERSN_LEGAL_BK_CODE
																			AND I.AGE < 70),
		CUST_FLAG AS
		 (SELECT E.PATH_CODE,
						 E.STATIS_CALIB,
						 E.STATIS_DIM,
						 E.DATA_BLNG,
						 E.PERSN_LEGAL_BK_CODE,
						 E.CUST_ID,
						 MAX(CASE
									 WHEN B.CARD_NO IS NOT NULL THEN
										1
									 ELSE
										0
								 END) AS HAS_BIND
				FROM ELIGIBLE E
				LEFT JOIN BIND_CARD B ON B.CARD_NO = E.CARD_NO
			 GROUP BY E.PATH_CODE,
								E.STATIS_CALIB,
								E.STATIS_DIM,
								E.DATA_BLNG,
								E.PERSN_LEGAL_BK_CODE,
								E.CUST_ID)
		SELECT PATH_CODE,
					 V_SYSDAT,
					 DATA_BLNG,
					 STATIS_DIM,
					 STATIS_CALIB,
					 'INDX_0071',
					 ROUND(SUM(HAS_BIND) * 100 / NULLIF(COUNT(*), 0), 2),
					 0,
					 PERSN_LEGAL_BK_CODE
			FROM CUST_FLAG
		 GROUP BY PATH_CODE,
							DATA_BLNG,
							STATIS_DIM,
							STATIS_CALIB,
							PERSN_LEGAL_BK_CODE;

	-------------------------------------------------------------------------
	-- 7.15/7.16 活跃卡数 INDX_0072（A/B，近180天）
	-------------------------------------------------------------------------
	INSERT INTO TMP_STAT_INDX_AGGR_006
		(PATH_CODE,
		 DATA_DATE,
		 DATA_BLNG,
		 STATIS_DIM,
		 STATIS_CALIB,
		 INDX_CODE,
		 CURNT_VAL,
		 TERM_LAST_VAL,
		 PERSN_LEGAL_BK_CODE)
		WITH SCOPE_ALL AS
		 (SELECT 'A' AS PATH_CODE,
						 '营销活动' AS STATIS_CALIB,
						 S.STATIS_DIM,
						 S.DATA_BLNG,
						 TI.CUST_ID,
						 S.PERSN_LEGAL_BK_CODE
				FROM TMP_STAT_INDX_SCOPE S
			 INNER JOIN DWD_MKT_TSK_INFO TI ON TI.MKT_ACT_ID = S.STATIS_DIM
																		 AND TI.PERSN_LEGAL_BK_CODE =
																				 S.PERSN_LEGAL_BK_CODE
																		 AND TI.DATA_DATE = V_SYSDAT
																		 AND ((S.BLNG_TYPE = 'O' AND
																				 TI.MKT_PERSN_ORG = S.BLNG_ID) OR
																				 (S.BLNG_TYPE = 'M' AND
																				 TI.MKT_PERSN = S.BLNG_ID))
			 WHERE S.PATH_CODE = 'A'
				 AND S.INDX_CODE = 'INDX_0072'
			UNION ALL
			SELECT 'B',
						 '目标任务',
						 S.STATIS_DIM,
						 S.DATA_BLNG,
						 LV.CUST_ID,
						 S.PERSN_LEGAL_BK_CODE
				FROM TMP_STAT_INDX_SCOPE S
			 INNER JOIN DWS_CUST_LVL_INFO LV ON S.BLNG_TYPE = 'O'
																			AND LV.ORG_ID = S.BLNG_ID
																			AND LV.PERSN_LEGAL_BK_CODE =
																					S.PERSN_LEGAL_BK_CODE
																			AND LV.DATA_DATE = V_SYSDAT
			 WHERE S.PATH_CODE = 'B'
				 AND S.INDX_CODE = 'INDX_0072'
			UNION ALL
			SELECT 'B',
						 '目标任务',
						 S.STATIS_DIM,
						 S.DATA_BLNG,
						 CM.CUST_ID,
						 S.PERSN_LEGAL_BK_CODE
				FROM TMP_STAT_INDX_SCOPE S
			 INNER JOIN DWD_CUST_MAN CM ON S.BLNG_TYPE = 'M'
																 AND CM.MNGR_POST_ID = S.BLNG_ID
																 AND CM.MNG_TYP = '1'
																 AND CM.PERSN_LEGAL_BK_CODE =
																		 S.PERSN_LEGAL_BK_CODE
			 WHERE S.PATH_CODE = 'B'
				 AND S.INDX_CODE = 'INDX_0072'),
		CARD_SCOPE AS
		 (SELECT DISTINCT X.PATH_CODE,
											X.STATIS_CALIB,
											X.STATIS_DIM,
											X.DATA_BLNG,
											X.PERSN_LEGAL_BK_CODE,
											C.KAHAOOOO AS CARD_NO
				FROM SCOPE_ALL X
			 INNER JOIN CBS_KCDA_PZJCXX C ON C.KEHUHAOO = X.CUST_ID
																	 AND CASE
																				 WHEN C.FAKAJIGO LIKE '12%' THEN
																					'1200'
																				 WHEN C.FAKAJIGO LIKE '15%' THEN
																					'1500'
																				 WHEN C.FAKAJIGO LIKE '18%' THEN
																					'1800'
																				 ELSE
																					'9999'
																			 END = X.PERSN_LEGAL_BK_CODE)
		SELECT X.PATH_CODE,
					 V_SYSDAT,
					 X.DATA_BLNG,
					 X.STATIS_DIM,
					 X.STATIS_CALIB,
					 'INDX_0072',
					 COUNT(DISTINCT X.CARD_NO),
					 0,
					 X.PERSN_LEGAL_BK_CODE
			FROM CARD_SCOPE X
		 INNER JOIN DWD_TX_ASET T ON T.CARD_NO = X.CARD_NO
														 AND T.TX_DATE BETWEEN
																 V_180_DAY_BEGIN AND
																 V_SYSDAT
														 AND T.JIOYCFFS = '0'
														 AND T.CHONGZBZ = '0'
		 GROUP BY X.PATH_CODE,
							X.DATA_BLNG,
							X.STATIS_DIM,
							X.STATIS_CALIB,
							X.PERSN_LEGAL_BK_CODE;

-------------------------------------------------------------------------
   -------------------------------------------------------------------------
   -------------------------------------------------------------------------
   -------------------------------------------------------------------------
   -- 7.17/7.18 代发薪客户净增 INDX_0064（合并 A/B，标签表+基数表）
   -- 范围客户 ∩ 基数表：FRST_MARK_DATE∈[活动开始日,跑批日]即活动期间新增标记，COUNT(DISTINCT CUST_ID)
   -- 基数客户首现记'19000101'自动巌除；按活动/任务编号(STATIS_DIM)隔离防多活动重复
   -------------------------------------------------------------------------
   INSERT INTO TMP_STAT_INDX_AGGR_006
          (PATH_CODE,
           DATA_DATE,
           DATA_BLNG,
           STATIS_DIM,
           STATIS_CALIB,
           INDX_CODE,
           CURNT_VAL,
           TERM_LAST_VAL,
           PERSN_LEGAL_BK_CODE)
          WITH SCOPE_ALL AS
           (SELECT 'A' AS PATH_CODE,
                                           '营销活动' AS STATIS_CALIB,
                                           S.STATIS_DIM,
                                           S.DATA_BLNG,
                                           S.TERM_BEGIN_DATE,
                                           TI.CUST_ID,
                                           S.PERSN_LEGAL_BK_CODE
                          FROM TMP_STAT_INDX_SCOPE S
                   INNER JOIN DWD_MKT_TSK_INFO TI ON TI.MKT_ACT_ID = S.STATIS_DIM
                                                   AND TI.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE
                                                   AND TI.DATA_DATE = V_SYSDAT
                                                   AND ((S.BLNG_TYPE = 'O' AND TI.MKT_PERSN_ORG = S.BLNG_ID) OR
                                                        (S.BLNG_TYPE = 'M' AND TI.MKT_PERSN = S.BLNG_ID))
                   WHERE S.PATH_CODE = 'A'
                     AND S.INDX_CODE = 'INDX_0064'
          UNION ALL
          SELECT 'B',
                                         '目标任务',
                                         S.STATIS_DIM,
                                         S.DATA_BLNG,
                                         S.TERM_BEGIN_DATE,
                                         LV.CUST_ID,
                                         S.PERSN_LEGAL_BK_CODE
                          FROM TMP_STAT_INDX_SCOPE S
                   INNER JOIN DWS_CUST_LVL_INFO LV ON S.BLNG_TYPE = 'O'
                                                    AND LV.ORG_ID = S.BLNG_ID
                                                    AND LV.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE
                                                    AND LV.DATA_DATE = V_SYSDAT
                   WHERE S.PATH_CODE = 'B'
                     AND S.INDX_CODE = 'INDX_0064'
          UNION ALL
          SELECT 'B',
                                         '目标任务',
                                         S.STATIS_DIM,
                                         S.DATA_BLNG,
                                         S.TERM_BEGIN_DATE,
                                         CM.CUST_ID,
                                         S.PERSN_LEGAL_BK_CODE
                          FROM TMP_STAT_INDX_SCOPE S
                   INNER JOIN DWD_CUST_MAN CM ON S.BLNG_TYPE = 'M'
                                              AND CM.MNGR_POST_ID = S.BLNG_ID
                                              AND CM.MNG_TYP = '1'
                                              AND CM.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE
                   WHERE S.PATH_CODE = 'B'
                     AND S.INDX_CODE = 'INDX_0064')
          SELECT PATH_CODE,
                 V_SYSDAT,
                 DATA_BLNG,
                 STATIS_DIM,
                 STATIS_CALIB,
                 'INDX_0064',
                 COUNT(DISTINCT CUST_ID),
                 0,
                 PERSN_LEGAL_BK_CODE
            FROM (SELECT DISTINCT SM.PATH_CODE,
                                  SM.STATIS_CALIB,
                                  SM.STATIS_DIM,
                                  SM.DATA_BLNG,
                                  SM.TERM_BEGIN_DATE,
                                  SM.CUST_ID,
                                  SM.PERSN_LEGAL_BK_CODE
                    FROM SCOPE_ALL) SM
           INNER JOIN ADS_CRM_R_SALRY_PAYROL_BASE B ON B.CUST_ID = SM.CUST_ID
                                                   AND B.PERSN_LEGAL_BK_CODE = SM.PERSN_LEGAL_BK_CODE
                                                   AND B.STATIS_DIM = SM.STATIS_DIM
                                                   AND B.PATH_CODE = SM.PATH_CODE
                                                   AND B.FRST_MARK_DATE BETWEEN SM.TERM_BEGIN_DATE AND V_SYSDAT
            GROUP BY PATH_CODE,
                     DATA_BLNG,
                     STATIS_DIM,
                     STATIS_CALIB,
                     PERSN_LEGAL_BK_CODE;
   -- 7.19/7.20 代销业务收入 INDX_0065（合并 A/B，暂不含贵金属）
   -- 理财：DWD_ACCT_FIN.PRDKT_CATE_BIG IN('1','2')，ISSU_DATE∈[开始日,跑批日]，SUM(FIN_AMT)
   -- 保险：DWD_ACCT_INSUR.POLICY_STATE='1'，TX_DATE∈[开始日,跑批日]，SUM(INSUR_AMT)
   -- 本期值 = 理财合计 + 保险合计（UNION ALL 后统一 SUM，一个活动/任务一条记录）
   -------------------------------------------------------------------------
   INSERT INTO TMP_STAT_INDX_AGGR_006
           (PATH_CODE,
            DATA_DATE,
            DATA_BLNG,
            STATIS_DIM,
            STATIS_CALIB,
            INDX_CODE,
            CURNT_VAL,
            TERM_LAST_VAL,
            PERSN_LEGAL_BK_CODE)
           WITH SCOPE_ALL AS
            (SELECT 'A' AS PATH_CODE,
                                            '营销活动' AS STATIS_CALIB,
                                            S.STATIS_DIM,
                                            S.DATA_BLNG,
                                            S.TERM_BEGIN_DATE,
                                            TI.CUST_ID,
                                            S.PERSN_LEGAL_BK_CODE
                           FROM TMP_STAT_INDX_SCOPE S
                    INNER JOIN DWD_MKT_TSK_INFO TI ON TI.MKT_ACT_ID = S.STATIS_DIM
                                                                                                                                            AND TI.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE
                                                                                                                                            AND TI.DATA_DATE = V_SYSDAT
                                                                                                                                            AND ((S.BLNG_TYPE = 'O' AND TI.MKT_PERSN_ORG = S.BLNG_ID) OR
                                                                                                                                                            (S.BLNG_TYPE = 'M' AND TI.MKT_PERSN = S.BLNG_ID))
                    WHERE S.PATH_CODE = 'A'
                            AND S.INDX_CODE = 'INDX_0065'
                   UNION ALL
                   SELECT 'B',
                                            '目标任务',
                                            S.STATIS_DIM,
                                            S.DATA_BLNG,
                                            S.TERM_BEGIN_DATE,
                                            LV.CUST_ID,
                                            S.PERSN_LEGAL_BK_CODE
                           FROM TMP_STAT_INDX_SCOPE S
                    INNER JOIN DWS_CUST_LVL_INFO LV ON S.BLNG_TYPE = 'O'
                                                                                                                                                   AND LV.ORG_ID = S.BLNG_ID
                                                                                                                                                   AND LV.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE
                                                                                                                                                   AND LV.DATA_DATE = V_SYSDAT
                    WHERE S.PATH_CODE = 'B'
                            AND S.INDX_CODE = 'INDX_0065'
                   UNION ALL
                   SELECT 'B',
                                            '目标任务',
                                            S.STATIS_DIM,
                                            S.DATA_BLNG,
                                            S.TERM_BEGIN_DATE,
                                            CM.CUST_ID,
                                            S.PERSN_LEGAL_BK_CODE
                           FROM TMP_STAT_INDX_SCOPE S
                    INNER JOIN DWD_CUST_MAN CM ON S.BLNG_TYPE = 'M'
                                                                                                                            AND CM.MNGR_POST_ID = S.BLNG_ID
                                                                                                                            AND CM.MNG_TYP = '1'
                                                                                                                            AND CM.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE
                    WHERE S.PATH_CODE = 'B'
                            AND S.INDX_CODE = 'INDX_0065')
           SELECT PATH_CODE,
                  V_SYSDAT,
                  DATA_BLNG,
                  STATIS_DIM,
                  STATIS_CALIB,
                  'INDX_0065',
                  SUM(AMT),
                  0,
                  PERSN_LEGAL_BK_CODE
             FROM (SELECT DISTINCT SM.PATH_CODE,
                                   SM.STATIS_CALIB,
                                   SM.STATIS_DIM,
                                   SM.DATA_BLNG,
                                   SM.TERM_BEGIN_DATE,
                                   SM.CUST_ID,
                                   SM.PERSN_LEGAL_BK_CODE
                           FROM SCOPE_ALL) SM
            INNER JOIN (SELECT F.CUST_ID,
                               F.PERSN_LEGAL_BK_CODE,
                               NVL(F.FIN_AMT, 0) AS AMT,
                               F.ISSU_DATE AS TX_DATE
                          FROM DWD_ACCT_FIN F
                         WHERE F.PRDKT_CATE_BIG IN ('1', '2')
                         UNION ALL
                          SELECT I.CUST_ID,
                                I.PERSN_LEGAL_BK_CODE,
                               NVL(I.INSUR_AMT, 0) AS AMT,
                               I.TX_DATE AS TX_DATE
                          FROM DWD_ACCT_INSUR I
                         WHERE I.POLICY_STATE = '1') D
                ON D.CUST_ID = SM.CUST_ID
               AND D.PERSN_LEGAL_BK_CODE = SM.PERSN_LEGAL_BK_CODE
               AND D.TX_DATE BETWEEN SM.TERM_BEGIN_DATE AND V_SYSDAT
            GROUP BY PATH_CODE,
                     DATA_BLNG,
                     STATIS_DIM,
                     STATIS_CALIB,
                     PERSN_LEGAL_BK_CODE;
	OUTCDE := SQL%ROWCOUNT;
	COMMIT;
	V_END_DATE  := SYSDATE;
	V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 86400);
	V_LOG_MSG   := '步骤6处理完成，行数=' || NVL(OUTCDE, 0);
	V_LOG_FLG   := 0;
	SYS_PRC_STEP_LOGS(V_SYSDAT,
										V_PRC_NAME,
										V_PRC_DESC,
										V_NO_ID,
										V_BGN_DATE,
										V_END_DATE,
										V_DURA_DATE,
										V_LOG_MSG,
										V_LOG_FLG,
										V_LOG_BUTTON);
EXCEPTION
	WHEN OTHERS THEN
		ROLLBACK;
		OUTCDE      := -1;
		V_END_DATE  := SYSDATE;
		V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 86400);
		V_LOG_MSG   := SUBSTR(SQLERRM, 1, 1000);
		V_LOG_FLG   := -1;
		SYS_PRC_STEP_LOGS(V_SYSDAT,
											V_PRC_NAME,
											V_PRC_DESC,
											V_NO_ID,
											V_BGN_DATE,
											V_END_DATE,
											V_DURA_DATE,
											V_LOG_MSG,
											V_LOG_FLG,
											V_LOG_BUTTON);
		RAISE;
END PRC_ADS_STAT_INDX_PLAN_006;
