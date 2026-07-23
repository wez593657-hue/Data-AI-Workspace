CREATE OR REPLACE PROCEDURE PRC_DWD_CUST_INDIV_RISK_INVST(
    V_SYSDAT IN VARCHAR,
    OUTCDE   OUT INTEGER
)
AS
  ------------------------------------------------------------------
  -- �洢��������: �ͻ���������
  -- �洢���̱��: PRC_DWD_CUST_INDIV_RISK_INVST
  -- ��������: ��
  -- ��������: ���� FMS_T4_CUST_RISK_ASSESS_INFO ӳ���ϵ���ɿͻ�����������Ϣ
  -- ��Դ��: FMS_T4_CUST_RISK_ASSESS_INFO(�ͻ����ճ�������������Ϣ��)
  -- Ŀ���: DWD_CUST_INDIV_RISK_INVST(�ͻ���������)
  -- author :
  -- date   : 2026-07-15
  -- �������ݿ�: �˴��� Oracle ����ģʽ
  ------------------------------------------------------------------
  ------------------------------------------------------------------
  --***************************************
  --1.�Զ��������
  --***************************************
  V_PRC_DESC             VARCHAR(100) := '�ͻ���������';
  V_PRC_NAME             VARCHAR(32)  := 'PRC_DWD_CUST_INDIV_RISK_INVST';
  V_SYSDAT2              VARCHAR(10);
  V_SQL                  VARCHAR(4000);
  V_LOG_MSG              VARCHAR(4000);
  V_START_DT             DATE;
  V_LOG_FLG              INTEGER;
  V_LOG_BUTTON           INTEGER := 1;
  V_NO_ID                VARCHAR(10);
  V_BGN_DATE             DATE;
  V_END_DATE             DATE;
  V_DURA_DATE            INTEGER;
  P_INTERVAL_START_DATE  VARCHAR(8);
  P_INTERVAL_END_DATE    VARCHAR(8);
BEGIN
  --***************************************
  -- 2. ҵ���߼���
  --***************************************
  V_START_DT := SYSDATE;
  V_SYSDAT2 := TO_CHAR(TO_DATE(V_SYSDAT, 'yyyymmdd'), 'yyyy-mm-dd');
  P_INTERVAL_START_DATE := TO_CHAR(TO_DATE(V_SYSDAT, 'yyyymmdd') - 30, 'yyyymmdd');
  P_INTERVAL_END_DATE   := V_SYSDAT;

  EXECUTE IMMEDIATE 'TRUNCATE TABLE DWD_CUST_CTRAKT_INFO';

  --***************************************
  -- 2.1 ���-�ͻ������������
  --***************************************
  V_NO_ID := '1';
  V_BGN_DATE := SYSDATE;

  INSERT INTO DWD_CUST_INDIV_RISK_INVST (
      CUST_ID,
      INVEST_TYP,
      ESTIM_RSLT,
      SCORE,
      RISK_LVL,
      ESTIM_DATE,
      EXPR_DATE,
      PERSN_LEGAL_BK_CODE
  )
  SELECT
      host_cust_no	  AS CUST_ID,   --�����ͻ���     
      NULL            AS INVEST_TYP,--Ͷ������	                          
      NULL	          AS ESTIM_RSLT,--�������
      NULL	          AS SCORE,     --����
      CUST_RISK_LEVEL	AS RISK_LVL,  --���ճ��ܵȼ�
      ASSESS_DATE	    AS ESTIM_DATE,--��������        
      INVALID_DATE	  AS EXPR_DATE, --ʧЧ����      
      '9999'          AS PERSN_LEGAL_BK_CODE �����к�
    FROM T4_CUST_RISK_ASSESS_INFO	; -- �ͻ����ճ�������������Ϣ��

  COMMIT;

  OUTCDE := 0;
  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG := '2.1 ���-�ͻ������������';
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

  --***************************************
  -- 2.2 ����-�ͻ������������
  --***************************************
  V_NO_ID := '2';
  V_BGN_DATE := SYSDATE;
/*9�±������ߺ�*/
  OUTCDE := 0;
  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG := '2.1 ����-�ͻ������������';
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

  --***************************************
  -- 3. �쳣����������������벢��¼��ϸ��־��
  --***************************************
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
/
