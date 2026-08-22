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
	-- 7.1/7.2 保险新保保费 INDX_0061 (合并 A/B)
	-------------------------------------------------------------------------
	INSERT INTO TMP_STAT_INDX_AGGR
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
	INSERT INTO TMP_STAT_INDX_AGGR
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
	INSERT INTO TMP_STAT_INDX_AGGR
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
	INSERT INTO TMP_STAT_INDX_AGGR
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
	INSERT INTO TMP_STAT_INDX_AGGR
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
	INSERT INTO TMP_STAT_INDX_AGGR
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
	INSERT INTO TMP_STAT_INDX_AGGR
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
																			AND I.AGE <= 70),
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
	INSERT INTO TMP_STAT_INDX_AGGR
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

	OUTCDE := SQL%ROWCOUNT;
	COMMIT;
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