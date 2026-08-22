CREATE OR REPLACE PROCEDURE CRMDM.PRC_ADS_STAT_INDX_PLAN_008
(
	V_SYSDAT  IN VARCHAR2, -- 跑批业务日期 YYYYMMDD
	OUTCDE OUT INTEGER -- 写入行数
) AS
    V_PRC_DESC VARCHAR2(100) := '指标数据统计步骤88处理完成 8';
    V_PRC_NAME VARCHAR2(32) := 'PRC_ADS_STAT_INDX_PLAN_008';
    V_LOG_MSG VARCHAR2(4000);
    V_LOG_FLG INTEGER;
    V_LOG_BUTTON INTEGER := 1;
    V_NO_ID VARCHAR2(10);
    V_BGN_DATE DATE;
    V_END_DATE DATE;
    V_DURA_DATE INTEGER;
	V_YAR_BEGIN VARCHAR2(8); -- 当年年初
	V_DAY_END   VARCHAR2(20); -- 业务日当日末（含时分秒上限）
BEGIN
    V_NO_ID := '0';
    V_BGN_DATE := SYSDATE;
    IF v_sysdat IS NULL OR NOT REGEXP_LIKE(v_sysdat, '^[0-9]{8}$') THEN
        RAISE_APPLICATION_ERROR(-20001, 'V_SYSDAT必须为YYYYMMDD格式');
    END IF;
    V_END_DATE := TO_DATE(v_sysdat, 'YYYYMMDD');
	---------------------------------------------------------------------
	/* * 过程名 : crmdm.prc_ads_stat_indx_plan_008
  * 业务   : 一码付留存率（客户维度）
  *          INDX_0081  AUM留存率     = 年日均AUM  * 100 / 年累计交易量
  *          INDX_0069  结算存款留存率 = 年日均存款 * 100 / 年累计交易量
  * 口径   : 客户级年累计交易(00/02) >= 500 元纳入统计
  *          pay_time 为 VARCHAR2(20) 带时分秒，采用区间比较以命中索引
  **/

	-- 0. 日期边界初始化
	---------------------------------------------------------------------
	V_YAR_BEGIN := SYS_FUN_DEAL_DATE(V_SYSDAT, 13);
	V_DAY_END   := V_SYSDAT || '999999';

	---------------------------------------------------------------------
	-- 1. 0081 / 0069 合并产出：A/B 路径一次扫描，两指标共享宽表
	---------------------------------------------------------------------
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
		 (
			/*-- 目标客户范围：A=营销活动  B=机构/管户 --*/
			SELECT 'A' AS PATH_CODE,
							'营销活动' AS STATIS_CALIB,
							S.STATIS_DIM,
							S.DATA_BLNG,
							S.PERSN_LEGAL_BK_CODE,
							TI.CUST_ID
				FROM TMP_STAT_INDX_SCOPE S
				JOIN DWD_MKT_TSK_INFO TI ON TI.MKT_ACT_ID = S.STATIS_DIM
																AND TI.PERSN_LEGAL_BK_CODE =
																		S.PERSN_LEGAL_BK_CODE
																AND TI.DATA_DATE = V_SYSDAT
																AND ((S.BLNG_TYPE = 'O' AND
																		TI.MKT_PERSN_ORG = S.BLNG_ID) OR
																		(S.BLNG_TYPE = 'M' AND
																		TI.MKT_PERSN = S.BLNG_ID))
			 WHERE S.PATH_CODE = 'A'
				 AND S.INDX_CODE IN ('INDX_0081', 'INDX_0069')
			UNION ALL
			SELECT 'B',
						 '目标任务',
						 S.STATIS_DIM,
						 S.DATA_BLNG,
						 S.PERSN_LEGAL_BK_CODE,
						 LV.CUST_ID
				FROM TMP_STAT_INDX_SCOPE S
				JOIN DWS_CUST_LVL_INFO LV ON LV.ORG_ID = S.BLNG_ID
																 AND LV.PERSN_LEGAL_BK_CODE =
																		 S.PERSN_LEGAL_BK_CODE
																 AND LV.DATA_DATE = V_SYSDAT
			 WHERE S.PATH_CODE = 'B'
				 AND S.BLNG_TYPE = 'O'
				 AND S.INDX_CODE IN ('INDX_0081', 'INDX_0069')
			UNION ALL
			SELECT 'B',
						 '目标任务',
						 S.STATIS_DIM,
						 S.DATA_BLNG,
						 S.PERSN_LEGAL_BK_CODE,
						 CM.CUST_ID
				FROM TMP_STAT_INDX_SCOPE S
				JOIN DWD_CUST_MAN CM ON CM.MNGR_POST_ID = S.BLNG_ID
														AND CM.MNG_TYP = '1'
														AND CM.PERSN_LEGAL_BK_CODE =
																S.PERSN_LEGAL_BK_CODE
			 WHERE S.PATH_CODE = 'B'
				 AND S.BLNG_TYPE = 'M'
				 AND S.INDX_CODE IN ('INDX_0081', 'INDX_0069')),
		CUST_MCT AS
		 (
			/*-- 客户 → 一码付商户：先去重到(客户,商户)对，防多结算账号膨胀 --*/
			SELECT DISTINCT SC.PATH_CODE,
											 SC.STATIS_CALIB,
											 SC.STATIS_DIM,
											 SC.DATA_BLNG,
											 SC.PERSN_LEGAL_BK_CODE,
											 SC.CUST_ID,
											 M.MCT_ID
				FROM (SELECT DISTINCT PATH_CODE,
															 STATIS_CALIB,
															 STATIS_DIM,
															 DATA_BLNG,
															 PERSN_LEGAL_BK_CODE,
															 CUST_ID
								 FROM SCOPE_ALL) SC
				JOIN DWD_CUST_INDV_INFO CI ON CI.CUST_ID = SC.CUST_ID
																	AND CI.PERSN_LEGAL_BK_CODE =
																			SC.PERSN_LEGAL_BK_CODE
				JOIN UEPP_PAY_MCT_SETTLE_ACCOUNT SA ON SA.CUST_NO = SC.CUST_ID
																					 AND SA.STATUS <> '9'
				JOIN UEPP_PAY_MCT_INFO M ON M.MCT_ID = SA.MCT_ID
																AND M.MCT_TYPE IN
																		('personage', 'smallBusinesses')
																AND M.STATUS <> '9'),
		MCT_TX AS
		 (
			/*-- 商户年累计交易量预聚合：先按 mct_id 压缩订单明细 --*/
			SELECT MCT_ID,
							SUM(NVL(ORDER_AMT, 0)) AS ANNUAL_TX_AMT
				FROM UEPP_PAY_ORDER_INFO
			 WHERE ORDER_TYPE = '00'
				 AND STATUS = '02'
				 AND PAY_TIME >= V_YAR_BEGIN
				 AND PAY_TIME <= V_DAY_END
			 GROUP BY MCT_ID),
		CUST_TX AS
		 (
			/*-- 客户年累计交易量：区间比较(可走 pay_time 索引) + >=500 阈值 --*/
			SELECT CM.PATH_CODE,
							CM.STATIS_CALIB,
							CM.STATIS_DIM,
							CM.DATA_BLNG,
							CM.PERSN_LEGAL_BK_CODE,
							CM.CUST_ID,
							SUM(T.ANNUAL_TX_AMT) AS ANNUAL_TX_AMT
				FROM CUST_MCT CM
				JOIN MCT_TX T ON T.MCT_ID = CM.MCT_ID
			 GROUP BY CM.PATH_CODE,
								 CM.STATIS_CALIB,
								 CM.STATIS_DIM,
								 CM.DATA_BLNG,
								 CM.PERSN_LEGAL_BK_CODE,
								 CM.CUST_ID
			HAVING SUM(T.ANNUAL_TX_AMT) >= 500),
		CUST_WIDE AS
		 (
			/*-- 客户级宽表：分母(交易量) + 分子(年日均AUM/存款)，LEFT JOIN 保零余额客户 --*/
			SELECT T.PATH_CODE,
							T.STATIS_CALIB,
							T.STATIS_DIM,
							T.DATA_BLNG,
							T.PERSN_LEGAL_BK_CODE,
							T.ANNUAL_TX_AMT,
							NVL(B.AUM_BAL, 0) AS ANNUAL_AUM,
							NVL(B.DEPO_BAL, 0) AS ANNUAL_DEPO
				FROM CUST_TX T
				LEFT JOIN DWS_CUST_ASSE_LIAB B ON B.CUST_ID = T.CUST_ID
																			AND B.PERSN_LEGAL_BK_CODE =
																					T.PERSN_LEGAL_BK_CODE
																			AND B.DATA_DATE = V_SYSDAT
																			AND B.BAL_TYPE = '4')
		/*-- 0081：AUM留存率 --*/
		SELECT PATH_CODE,
					 V_SYSDAT,
					 DATA_BLNG,
					 STATIS_DIM,
					 STATIS_CALIB,
					 'INDX_0081',
					 ROUND(SUM(ANNUAL_AUM) * 100 / NULLIF(SUM(ANNUAL_TX_AMT), 0), 2),
					 0,
					 PERSN_LEGAL_BK_CODE
			FROM CUST_WIDE
		 GROUP BY PATH_CODE,
							STATIS_CALIB,
							DATA_BLNG,
							STATIS_DIM,
							PERSN_LEGAL_BK_CODE
		UNION ALL
		/*-- 0069：结算存款留存率 --*/
		SELECT PATH_CODE,
					 V_SYSDAT,
					 DATA_BLNG,
					 STATIS_DIM,
					 STATIS_CALIB,
					 'INDX_0069',
					 ROUND(SUM(ANNUAL_DEPO) * 100 / NULLIF(SUM(ANNUAL_TX_AMT), 0), 2),
					 0,
					 PERSN_LEGAL_BK_CODE
			FROM CUST_WIDE
		 GROUP BY PATH_CODE,
							STATIS_CALIB,
							DATA_BLNG,
							STATIS_DIM,
							PERSN_LEGAL_BK_CODE;

	---------------------------------------------------------------------
	-- 2. 0066 个贷新形成不良贷款率: 期初基准(prc_ads_stat_indx_plan_002 3.4段建立)
	--    分母 = scope客户 ∩ 期初基准(正常1/关注2账户)余额合计
	--    分子 = 同上账户中期末(DWD_ACCT_LOAN)变不良(3次级/4可疑/5损失)的当前余额合计
	--           (期间结清账户期末不存在, 不计入分子; 期间新开账户期初不在基准, 不计入分母)
	--    率   = ROUND(分子/分母*100, 2), 分母为0时输出 NULL
	---------------------------------------------------------------------
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
		WITH SCOPE_CUST AS
		 (SELECT SC.PATH_CODE,
						 CASE
							 WHEN SC.PATH_CODE = 'A' THEN
								'营销活动'
							 ELSE
								'目标任务'
						 END AS STATIS_CALIB,
						 SC.STATIS_DIM,
						 SC.DATA_BLNG,
						 SC.PERSN_LEGAL_BK_CODE,
						 SC.CUST_ID
				FROM (SELECT DISTINCT S.PATH_CODE,
															S.STATIS_DIM,
															S.DATA_BLNG,
															S.PERSN_LEGAL_BK_CODE,
															TI.CUST_ID
								FROM TMP_STAT_INDX_SCOPE S
								JOIN DWD_MKT_TSK_INFO TI ON TI.MKT_ACT_ID = S.STATIS_DIM
																				AND TI.PERSN_LEGAL_BK_CODE =
																						S.PERSN_LEGAL_BK_CODE
																				AND TI.DATA_DATE = V_SYSDAT
																				AND ((S.BLNG_TYPE = 'O' AND
																						TI.MKT_PERSN_ORG = S.BLNG_ID) OR
																						(S.BLNG_TYPE = 'M' AND
																						TI.MKT_PERSN = S.BLNG_ID))
							 WHERE S.PATH_CODE = 'A'
								 AND S.INDX_CODE = 'INDX_0066'
							UNION
							SELECT DISTINCT S.PATH_CODE,
															S.STATIS_DIM,
															S.DATA_BLNG,
															S.PERSN_LEGAL_BK_CODE,
															LV.CUST_ID
								FROM TMP_STAT_INDX_SCOPE S
								JOIN DWS_CUST_LVL_INFO LV ON LV.ORG_ID = S.BLNG_ID
																				 AND LV.PERSN_LEGAL_BK_CODE =
																						 S.PERSN_LEGAL_BK_CODE
																				 AND LV.DATA_DATE = V_SYSDAT
							 WHERE S.PATH_CODE = 'B'
								 AND S.BLNG_TYPE = 'O'
								 AND S.INDX_CODE = 'INDX_0066'
							UNION
							SELECT DISTINCT S.PATH_CODE,
															S.STATIS_DIM,
															S.DATA_BLNG,
															S.PERSN_LEGAL_BK_CODE,
															CM.CUST_ID
								FROM TMP_STAT_INDX_SCOPE S
								JOIN DWD_CUST_MAN CM ON CM.MNGR_POST_ID = S.BLNG_ID
																		AND CM.MNG_TYP = '1'
																		AND CM.PERSN_LEGAL_BK_CODE =
																				S.PERSN_LEGAL_BK_CODE
							 WHERE S.PATH_CODE = 'B'
								 AND S.BLNG_TYPE = 'M'
								 AND S.INDX_CODE = 'INDX_0066') SC),
		DENOM AS
		 (SELECT SC.PATH_CODE,
						 SC.STATIS_CALIB,
						 SC.STATIS_DIM,
						 SC.DATA_BLNG,
						 SC.PERSN_LEGAL_BK_CODE,
						 SUM(NVL(B.LOAN_BAL, 0)) AS BASE_AMT
				FROM SCOPE_CUST SC
				JOIN TMP_STAT_INDX_LOAN_BASE B ON B.PATH_CODE = SC.PATH_CODE
																			AND B.STATIS_DIM = SC.STATIS_DIM
																			AND B.DATA_BLNG = SC.DATA_BLNG
																			AND B.PERSN_LEGAL_BK_CODE =
																					SC.PERSN_LEGAL_BK_CODE
																			AND B.CUST_ID = SC.CUST_ID
			 GROUP BY SC.PATH_CODE,
								SC.STATIS_CALIB,
								SC.STATIS_DIM,
								SC.DATA_BLNG,
								SC.PERSN_LEGAL_BK_CODE),
		NUMER AS
		 (SELECT SC.PATH_CODE,
						 SC.STATIS_CALIB,
						 SC.STATIS_DIM,
						 SC.DATA_BLNG,
						 SC.PERSN_LEGAL_BK_CODE,
						 SUM(NVL(A.BAL, 0)) AS BAD_AMT
				FROM SCOPE_CUST SC
				JOIN TMP_STAT_INDX_LOAN_BASE B ON B.PATH_CODE = SC.PATH_CODE
																			AND B.STATIS_DIM = SC.STATIS_DIM
																			AND B.DATA_BLNG = SC.DATA_BLNG
																			AND B.PERSN_LEGAL_BK_CODE =
																					SC.PERSN_LEGAL_BK_CODE
																			AND B.CUST_ID = SC.CUST_ID
				JOIN DWD_ACCT_LOAN A ON A.ACCT_ID = B.ACCT_ID
														AND A.CUST_ID = B.CUST_ID
														AND A.PERSN_LEGAL_BK_CODE =
																B.PERSN_LEGAL_BK_CODE
														AND A.CATE_5LVL IN ('3', '4', '5')
			 GROUP BY SC.PATH_CODE,
								SC.STATIS_CALIB,
								SC.STATIS_DIM,
								SC.DATA_BLNG,
								SC.PERSN_LEGAL_BK_CODE)
		SELECT D.PATH_CODE,
					 V_SYSDAT,
					 D.DATA_BLNG,
					 D.STATIS_DIM,
					 D.STATIS_CALIB,
					 'INDX_0066',
					 ROUND(NVL(N.BAD_AMT, 0) * 100 / NULLIF(D.BASE_AMT, 0), 2),
					 0,
					 D.PERSN_LEGAL_BK_CODE
			FROM DENOM D
			LEFT JOIN NUMER N ON N.PATH_CODE = D.PATH_CODE
											 AND N.STATIS_DIM = D.STATIS_DIM
											 AND N.DATA_BLNG = D.DATA_BLNG
											 AND N.PERSN_LEGAL_BK_CODE = D.PERSN_LEGAL_BK_CODE;

	    outcde := SQL%ROWCOUNT;
    COMMIT;
    V_END_DATE := SYSDATE;
    V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 86400);
    V_LOG_MSG := '步骤8处理完成，行数=' || NVL(outcde, 0);
    V_LOG_FLG := 0;
    SYS_PRC_STEP_LOGS(v_sysdat, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        outcde := -1;
        V_END_DATE := SYSDATE;
        V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 86400);
        V_LOG_MSG := SUBSTR(SQLERRM, 1, 1000);
        V_LOG_FLG := -1;
        SYS_PRC_STEP_LOGS(v_sysdat, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);
        RAISE;
END PRC_ADS_STAT_INDX_PLAN_008;
