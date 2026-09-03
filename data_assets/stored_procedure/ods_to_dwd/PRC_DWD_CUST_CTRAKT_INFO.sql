CREATE OR REPLACE PROCEDURE CRMDM.PRC_DWD_CUST_CTRAKT_INFO
(
	V_SYSDAT VARCHAR,
	OUTCDE   OUT INTEGER
) AS
	------------------------------------------------------------------
	-- 存储过程名称: 客户合同信息处理
	-- 存储过程编号: PRC_DWD_CUST_CTRAKT_INFO
	-- 处理周期: 日
	-- 过程描述: 根据 CUST_CTRAKT_INFO 映射关系生成客户合同信息
	-- 来源表: CMS_CUSTOMER_INFO(客户信息表), CMS_BUSINESS_CONTRACT(合同业务表)
	-- 目标表: DWD_CUST_CTRAKT_INFO(客户合同信息)
	-- author :
	-- date   : 2026-07-15
	-- 适配数据库: 人大金仓 Oracle 兼容模式
	------------------------------------------------------------------
	------------------------------------------------------------------
	--***************************************
	--1.自定义参数区
	--***************************************
	V_PRC_DESC            VARCHAR(100) := '客户合同信息处理';
	V_PRC_NAME            VARCHAR(32) := 'PRC_DWD_CUST_CTRAKT_INFO';
	V_SYSDAT2             VARCHAR(10);
	V_SQL                 VARCHAR(4000);
	V_LOG_MSG             VARCHAR(4000);
	V_START_DT            DATE;
	V_LOG_FLG             INTEGER;
	V_LOG_BUTTON          INTEGER := 1;
	V_NO_ID               VARCHAR(10);
	V_BGN_DATE            DATE;
	V_END_DATE            DATE;
	V_DURA_DATE           INTEGER;
BEGIN
	--***************************************
	-- 2. 业务逻辑区
	--***************************************
	V_START_DT            := SYSDATE;

	EXECUTE IMMEDIATE 'TRUNCATE TABLE DWD_CUST_CTRAKT_INFO';

	--***************************************
	-- 2.1 客户合同信息落库
	--***************************************
	V_NO_ID    := '1';
	V_BGN_DATE := SYSDATE;

	INSERT INTO DWD_CUST_CTRAKT_INFO
		(CUST_ID,
		 CTRAKT_ID,
		 LOAN_ACCT,
		 CRDT_LMT,
		 LOAN_BAL,
		 GUARANT_MODE,
		 CATE_5LVL,
		 CCY_CD,
		 RATE_INTRI,
		 CONTR_AMT,
		 BGN_DATE,
		 END_DATE,
		 OPRTR,
		 OPRT_ORG,
		 PERSN_LEGAL_BK_CODE,
		 CYCL_TYP,
		 CMS_CUST_ID,
		 PRDKT_ID,
		 PRDKT_NAME)
		SELECT C.MFCUSTOMERID                   AS CUST_ID,      -- 客户编号；核心客户号
					 BC.SERIALNO                      AS CTRAKT_ID,    -- 合同编号；合同流水号
					 NVL(LENDACCOUNTNO, PAYACCOUNTNO) AS LOAN_ACCT,    -- 贷款账号；映射表未提供可确认来源
					 BC.BUSINESSSUM                   AS CRDT_LMT,     -- 授信额度；备注：个人没有授信额度,是否取业务合同金额
					 BC.BALANCE                       AS LOAN_BAL,     -- 贷款余额
					 SUBSTR(BC.VOUCHTYPE, 1, 3)       AS GUARANT_MODE, -- 担保方式
					 BC.CLASSIFYRESULT                AS CATE_5LVL,    -- 五级分类；分类结果  有空值
					 CASE
						 WHEN BC.BUSINESSCURRENCY = '01' THEN
							'156'
						 ELSE
							NULL
					 END                              AS CCY_CD,     -- 币种
					 BC.BUSINESSRATE                  AS RATE_INTRI, -- 利率；new 5 中 BUSINESS_CONTRACT 已有 businessrate,未额外关联 ACCT_RATE_SEGMENT
					 BC.BUSINESSSUM                   AS CONTR_AMT,  -- 合同金额
					 REPLACE(BC.PUTOUTDATE, '/', '')  AS BGN_DATE,   -- 发放日期；new 5 字段为 putoutdate
					 REPLACE(BC.MATURITY, '/', '')    AS END_DATE,   -- 结束日期；映射字段 MaturityDate 在 new 5 中对应 maturity
					 BC.MANAGEUSERID                  AS OPRTR,      -- 经办人；主办客户经理
					 BC.MANAGEORGID                   AS OPRT_ORG,   -- 经办机构；主办机构
					 CASE
						 WHEN BC.MANAGEORGID LIKE '15%' THEN
							'1500'
						 WHEN BC.MANAGEORGID LIKE '12%' THEN
							'1200'
						 WHEN BC.MANAGEORGID LIKE '18%' THEN
							'1800'
						 ELSE
							'9999'
					 END                              AS PERSN_LEGAL_BK_CODE, -- 法人行号
					 CASE
						 WHEN CREDITCYCLE = '1' THEN
							'1'
						 ELSE
							'0'
					 END                              AS CYCL_TYP,    -- 授信额度是否可循环
					 C.CUSTOMERID                     AS CMS_CUST_ID, -- 客户编号
					 BC.PRODUCTID                     AS PRDKT_ID,    -- 产品编号
					 BT.TYPENAME                      AS PRDKT_NAME   -- 产品名称
			FROM CMS_CUSTOMER_INFO C -- 客户信息表
		 INNER JOIN CMS_BUSINESS_CONTRACT BC -- 合同业务表
		ON BC.CUSTOMERID = C.CUSTOMERID
			LEFT JOIN CMS_BUSINESS_TYPE BT ON BT.TYPENO = BC.PRODUCTID
		 WHERE C.MFCUSTOMERID IS NOT NULL
			 AND NVL(LENDACCOUNTNO, PAYACCOUNTNO) IS NOT NULL;

	COMMIT;
	OUTCDE      := 0;
	V_END_DATE  := SYSDATE;
	V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
	V_LOG_MSG   := '2.1 客户合同信息落库';
	V_LOG_FLG   := OUTCDE;

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

	--***************************************
	-- 3. 异常处理区(捕获错误码并记录详细日志)
	--***************************************
EXCEPTION
	WHEN OTHERS THEN
		OUTCDE := -1;
		ROLLBACK;
		V_END_DATE  := SYSDATE;
		V_DURA_DATE := CASE
										 WHEN V_BGN_DATE IS NULL
													OR V_END_DATE IS NULL THEN
											NULL
										 ELSE
											TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60)
									 END;
		V_LOG_MSG   := SUBSTR(SQLERRM, 1, 1000);
		V_LOG_FLG   := OUTCDE;
	
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
END;