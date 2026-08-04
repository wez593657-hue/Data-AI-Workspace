CREATE OR REPLACE PROCEDURE PRC_ADS_CUST_NEW_CUST_DTL(
    ------------------------------------------------------------------
    -- 输入参数
    ------------------------------------------------------------------
    -- V_SYSDAT: 跑批日期，格式YYYYMMDD（如'20260730'），必填，不为空
    V_SYSDAT IN VARCHAR,
    ------------------------------------------------------------------
    -- 输出参数
    ------------------------------------------------------------------
    -- OUTCDE: 执行结果码，0=成功，-1=异常
    OUTCDE   OUT INTEGER
)
AS
  ------------------------------------------------------------------
  -- 存储过程名称: PRC_ADS_CUST_NEW_CUST_DTL
  -- 中文名称: 新客经营明细处理
  -- 处理周期: 日
  -- 过程描述: 以客户基本信息OPEN_DATE字段确定180天内新客，按新客周期
  --           (0~30天/30~100天/100~180天)分类统计，生成月度明细数据
  -- 来源表: DWD_CUST_INDV_INFO(客户基本信息_OPEN_DATE开户日期),
  --         DWS_CUST_LVL_INFO(客户等级信息),
  --         DWS_CUST_ASSE_LIAB(客户资产负债=BAL_TYPE=1余额),
  --         DWD_CUST_INDV_KYC(客户KYC完整度信息_22字段),
  --         ADS_MKT_REC_INFO(营销活动记录_接触状态判断)
  -- 目标表: ADS_CUST_NEW_CUST_DTL(新客经营明细)
  -- 临时表: TMP_ADS_NEW_CUST_BASE(物理临时表，存储新客基础数据)
  -- 适配数据库: Kingbase Oracle 兼容模式
  -- 需求版本: v2.3.5
  -- 关联需求: REQ-CUST-007(新客定义), REQ-CUST-009(计算单位),
  --           REQ-CUST-010(去季年切片+未评级), REQ-CUST-011(接触时间调整),
  --           REQ-CUST-012(关联计算补齐法人行号), REQ-CUST-013(月度数据隔离),
  --           REQ-CUST-014(理财管户经理提取)
  -- 变更记录:
  --   v2.1.0(2026-07-22): 1.新客定义改为使用DWD_CUST_INDV_INFO的OPEN_DATE字段
  --                       2.新客周期边界值改为左闭右开（0~30、30~100、100~180）
  --   v2.2.0(2026-07-27): 计算单位调整为客户号+归属机构；明细由当日资产快照拆分
  --                       机构，法人行和归属机构取资产快照
  --   v2.3.0(2026-07-30): 1.统计周期去掉季/年切片，仅保留月度(M)
  --                       2.当月新客展示'未评级'
  --   v2.3.1(2026-07-30): 已接触客户数时间范围从"当月"调整为"新客周期内"
  --        (从OPEN_DATE到DATA_DATE期间的接触均计入)
  --   v2.3.2(2026-07-30): 修复关联计算缺少PERSN_LEGAL_BK_CODE问题，所有JOIN统一
  --                       使用CUST_ID+PERSN_LEGAL_BK_CODE作为基础计算单位；
  --                       DWD_CUST_INDV_KYC因不含PERSN_LEGAL_BK_CODE除外
  --   v2.3.3(2026-07-30): 移除历史客群持续经营步骤(原步骤5)，实现月度数据隔离：
  --                       本月接触/KYC状态仅记录在当月数据文件中，不再回溯写入
  --                       上一月历史明细记录
  --   v2.3.4(2026-07-30): 管户经理信息源从DWD_CUST_INDV_INFO.HOST_CUST_MNGR_POST_ID
  --                       改为DWD_CUST_MAN(MNG_TYP='1'理财管户).MNGR_POST_ID；
  --                       归属机构同步改为DWD_CUST_MAN.ORG_ID
  --   v2.3.5(2026-08-04): F-01:记录2026-08-01口径确认(ORG_ID取DWS_CUST_ASSE_LIAB资产快照，
  --                       非DWD_CUST_MAN.ORG_ID)；客户等级一律取DWS_CUST_LVL_INFO(无记录兜底'11')，
  --                       不再按开户月判断当月新客；F-06:删除V_END_DATE无效初始化
  ------------------------------------------------------------------
  ------------------------------------------------------------------
  -- 局部变量声明
  ------------------------------------------------------------------
  -- V_PRC_DESC:     存储过程描述文字（用于日志记录）
  V_PRC_DESC             VARCHAR(100) := '新客经营明细处理';
  -- V_PRC_NAME:     存储过程名称（用于日志记录）
  V_PRC_NAME             VARCHAR(64)  := 'PRC_ADS_CUST_NEW_CUST_DTL';
  -- V_LOG_MSG:      日志消息内容（最大4000字符）
  V_LOG_MSG              VARCHAR(4000);
  -- V_LOG_FLG:      日志标记（OUTCDE值，0=正常，-1=异常）
  V_LOG_FLG              INTEGER;
  -- V_LOG_BUTTON:    是否记录日志（1=记录，0=不记录），默认1
  V_LOG_BUTTON           INTEGER := 1;
  -- V_NO_ID:         当前步骤编号标识，用于日志定位（TMP1/TMP2/3）
  V_NO_ID                VARCHAR(10);
  -- V_BGN_DATE:      步骤开始时间（用于计算耗时）
  V_BGN_DATE             DATE;
  -- V_END_DATE:      步骤结束时间
  V_END_DATE             DATE;
  -- V_DURA_DATE:     步骤耗时（秒），(V_END_DATE - V_BGN_DATE) * 86400
  V_DURA_DATE            INTEGER;
  -- V_DATA_DATE:     数据日期，取V_SYSDAT值，格式YYYYMMDD
  V_DATA_DATE            VARCHAR2(8);
  -- V_HISTORY_CUTOFF_DATE: 三年历史清理边界（参数19），用于清理过期数据
  V_HISTORY_CUTOFF_DATE  VARCHAR2(8);
  -- V_180D_WINDOW_BEGIN: 180天新客窗口开始日（参数23）
  V_180D_WINDOW_BEGIN    VARCHAR2(8);

  ------------------------------------------------------------------
  -- 内部辅助过程：清空指定物理临时表
  -- 参数 P_TABLE_NAME: 临时表名称，直接拼接为TRUNCATE语句执行
  ------------------------------------------------------------------
  PROCEDURE TRUNC_TMP(P_TABLE_NAME VARCHAR2) IS
  BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE ' || P_TABLE_NAME;
  END;

BEGIN
  ------------------------------------------------------------------
  -- 步骤1: 参数检查
  -- 校验V_SYSDAT格式：必须为8位数字YYYYMMDD
  ------------------------------------------------------------------
  IF V_SYSDAT IS NULL
     OR NOT REGEXP_LIKE(V_SYSDAT, '^[0-9]{8}$')
  THEN
    RAISE_APPLICATION_ERROR(-20001, 'V_SYSDAT必须为YYYYMMDD格式');
  END IF;

  -- 设置数据日期 = 跑批日期
  V_DATA_DATE := V_SYSDAT;
  -- 三年历史清理边界（参数19）
  V_HISTORY_CUTOFF_DATE := sys_fun_deal_date(V_SYSDAT, 19);
  -- 180天新客窗口开始日（参数23）
  V_180D_WINDOW_BEGIN := sys_fun_deal_date(V_SYSDAT, 23);

  ------------------------------------------------------------------
  -- 步骤2_TMP1: 清理当前数据日明细和物理临时表
  --   - 删除当天已存在的明细数据（幂等重跑）
  --   - 删除三年前的历史过期数据（保留近三年）
  --   - 清空物理临时表 TMP_ADS_NEW_CUST_BASE
  ------------------------------------------------------------------
  V_NO_ID := 'TMP1';
  V_BGN_DATE := SYSDATE;

  -- 删除当天明细（支持重跑幂等）
  DELETE FROM ADS_CUST_NEW_CUST_DTL D
   WHERE D.DATA_DATE = V_DATA_DATE;

  -- 删除三年历史清理边界（参数19）之前的历史数据
  DELETE FROM ADS_CUST_NEW_CUST_DTL D
   WHERE D.DATA_DATE < V_HISTORY_CUTOFF_DATE;

  -- 清空临时表
  TRUNC_TMP('TMP_ADS_NEW_CUST_BASE');
  COMMIT;

  V_END_DATE := SYSDATE;
  -- 计算本步骤耗时（秒）
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := 'TMP1 完成：清理当前数据日明细、三年前历史数据和物理临时表';
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
  -- 步骤3_TMP2: 生成180天内新客基础数据
  --   新客定义: OPEN_DATE距今180天内（含180天）
  --   数据来源:
  --     DWS_CUST_ASSE_LIAB(a): 客户资产负债，取BAL_TYPE='1'余额快照
  --     DWD_CUST_INDV_INFO(c): 客户基本信息，获取OPEN_DATE开户日期
  --     DWD_CUST_MAN(m):       信贷管户关系表，MNG_TYP='1'获取理财管户经理
  --     DWS_CUST_LVL_INFO(l):  客户等级信息
  --     DWD_CUST_INDV_KYC(k):  客户KYC完整度，判断22字段中≥18个不为空
  --     ADS_MKT_REC_INFO(r):   营销接触记录，判断新客周期内有效接触
  --
  --   新客周期计算（左闭右开）:
  --      NEW_CUST_CYCLE='1': 0≤(DATA_DATE-OPEN_DATE)<30天
  --      NEW_CUST_CYCLE='2': 30≤(DATA_DATE-OPEN_DATE)<100天
  --      NEW_CUST_CYCLE='3': 100≤(DATA_DATE-OPEN_DATE)≤180天
  --
  --   接触状态(v2.3.1更新):
  --      时间范围: 从客户OPEN_DATE到DATA_DATE期间的接触均计入
  --      接触类型: 电话('1')/面访('2')/企微('3')/短信('4')
  --      接触人员: 理财管户客户经理(DWD_CUST_MAN, MNG_TYP='1')
  --      CNTCT_STATE='1': 新客周期内有有效接触; CNTCT_STATE='0': 无
  --
  --   当月新客未评级(v2.3.0新增):
  --      OPEN_DATE所在月份 = 跑批日所在月份 → CUST_LVL='未评级'
  --      非当月新客 → 取DWS_CUST_LVL_INFO的CUST_LVL
  --      若DWS_CUST_LVL_INFO无记录也默认'未评级'
  --
  --   KYC完整度:
  --      统计DWD_CUST_INDV_KYC中22个字段不为空的数量
  --      阈值为≥18个(≈81.8%) → KYC_STATE='1'; 否则 '0'
  ------------------------------------------------------------------
  V_NO_ID := 'TMP2';
  V_BGN_DATE := SYSDATE;

  INSERT INTO TMP_ADS_NEW_CUST_BASE (
      PERSN_LEGAL_BK_CODE,       -- 法人行号
      CUST_ID,                   -- 客户编号
      CUST_NAME,                 -- 客户姓名
      CUST_LVL,                  -- 客户等级(当月新客='未评级')
      NEW_CUST_CYCLE,            -- 新客周期(1=0~30天,2=30~100天,3=100~180天)
      DEPO_CURNT_DEPO_BAL,       -- 活期存款余额
      FIXD_DEPO_BAL,             -- 定期存款余额
      FIN_AMT,                   -- 理财余额
      CNTCT_STATE,               -- 接触状态(1=已接触,0=未接触)
      KYC_STATE,                 -- KYC完成状态(1=完整≥18/22,0=不完整)
      POST_ID,                   -- 管户经理岗位编号
      ORG_ID                     -- 归属机构编号
  )
  SELECT a.PERSN_LEGAL_BK_CODE,                                             -- 法人行号_取资产快照的法人行号
         a.CUST_ID,                                                         -- 客户编号
         c.CUST_NAME,                                                       -- 客户姓名_取客户基本信息
         -- 2026-08-01口径确认: 客户等级一律取DWS_CUST_LVL_INFO(新客等级含未评级码值11
         -- 亦记录于等级表)，不再按开户月重新判断；无等级记录时兜底未评级(码值11)
         NVL(l.CUST_LVL, '11'),                                             -- 客户等级
         CASE
           -- v2.1.0: 新客周期左闭右开
           -- 周期1: 开户0~30天（不含30天）
           WHEN TO_DATE(V_DATA_DATE, 'YYYYMMDD') - TO_DATE(REPLACE(SUBSTR(c.OPEN_DATE, 1, 10), '-', ''), 'YYYYMMDD') < 30 THEN '1'
           -- 周期2: 开户30~100天（不含100天）
           WHEN TO_DATE(V_DATA_DATE, 'YYYYMMDD') - TO_DATE(REPLACE(SUBSTR(c.OPEN_DATE, 1, 10), '-', ''), 'YYYYMMDD') < 100 THEN '2'
           -- 周期3: 开户100~180天（含180天）
           WHEN TO_DATE(V_DATA_DATE, 'YYYYMMDD') - TO_DATE(REPLACE(SUBSTR(c.OPEN_DATE, 1, 10), '-', ''), 'YYYYMMDD') <= 180 THEN '3'
         END,                                                                -- 新客周期
         NVL(a.DEPO_CURNT_DEPO_BAL, 0),                                     -- 活期存款余额_取当日余额快照
         NVL(a.FIXD_DEPO_BAL, 0),                                           -- 定期存款余额_取当日余额快照
         NVL(a.FIN_BAL, 0),                                                  -- 理财余额_取当日余额快照
         CASE
           -- v2.3.1: 接触状态判断时间范围改为"新客周期内"
           -- 从客户OPEN_DATE到当前DATA_DATE期间，管户经理有有效接触则标记为已接触
           WHEN EXISTS (
             SELECT 1
               FROM ADS_MKT_REC_INFO r                                         -- 营销活动记录表
              WHERE r.CUST_ID = c.CUST_ID                                      -- 关联客户号
                AND r.PERSN_LEGAL_BK_CODE = a.PERSN_LEGAL_BK_CODE             -- v2.3.2: 强制联动法人行号作为基础计算单位
                AND r.MKT_PERSN = m.MNGR_POST_ID                         -- v2.3.4: 关联理财管户经理
                AND r.MKT_TYP IN ('1', '2', '3', '4')                          -- 有效接触类型:1=电话,2=面访,3=企微,4=短信
                AND r.MKT_TIME IS NOT NULL                                     -- 接触时间不为空
                AND TO_DATE(REPLACE(SUBSTR(r.MKT_TIME, 1, 10), '-', ''), 'YYYYMMDD')
                    BETWEEN TO_DATE(REPLACE(SUBSTR(c.OPEN_DATE, 1, 10), '-', ''), 'YYYYMMDD')  -- 起始: 客户开户日期
                        AND TO_DATE(V_DATA_DATE, 'YYYYMMDD')                                    -- 截止: 当前跑批日期
           ) THEN '1'                                                          -- 新客周期内有有效接触
           ELSE '0'                                                            -- 新客周期内无有效接触
         END,                                                                -- 接触状态
         CASE
           -- KYC完整度判断: 统计22个KYC字段中不为空的数量
           -- 阈值: ≥18个不为空(≈81.8%)即为完整
           -- 字段列表:
           --   1.BK_OUTER_DEPO(行外存款)    2.BK_OUTER_FIN(行外理财)
           --   3.BK_OUTER_FUND(行外基金)    4.BK_OUTER_INSUR(行外保险)
           --   5.BK_OUTER_GOLD(行外贵金属)  6.STK_INVEST(股票投资)
           --   7.ESTT_INF(房产信息)         8.PROP_OWNER_CERT_NO(房产权属证书号)
           --   9.HOUSE_AREA(房屋面积)       10.IS_HOUSE_MORTGAGED(房产抵押)
           --   11.RES_ADDRS(居住地址)       12.SHOP_INVEST(商铺投资)
           --   13.VIKL_INF(车辆信息)        14.VEHICLE_PLATE_NO(车牌号)
           --   15.USAGE_NATURE(车辆使用性质) 16.IS_CAR_LOAN(车辆贷款)
           --   17.IS_CAR_MORTGAGED(车辆抵押) 18.MTH_INCOM(月收入)
           --   19.YR_INCOM(年收入)          20.BK_OUTER_LOAN_BAL(行外贷款余额)
           --   21.BK_OUTER_CRDT_LMT(行外信用卡额度) 22.AVAIL_LMT(可用额度)
           WHEN (CASE WHEN k.BK_OUTER_DEPO IS NOT NULL THEN 1 ELSE 0 END
                + CASE WHEN k.BK_OUTER_FIN IS NOT NULL THEN 1 ELSE 0 END
                + CASE WHEN k.BK_OUTER_FUND IS NOT NULL THEN 1 ELSE 0 END
                + CASE WHEN k.BK_OUTER_INSUR IS NOT NULL THEN 1 ELSE 0 END
                + CASE WHEN k.BK_OUTER_GOLD IS NOT NULL THEN 1 ELSE 0 END
                + CASE WHEN k.STK_INVEST IS NOT NULL THEN 1 ELSE 0 END
                + CASE WHEN k.ESTT_INF IS NOT NULL THEN 1 ELSE 0 END
                + CASE WHEN k.PROP_OWNER_CERT_NO IS NOT NULL THEN 1 ELSE 0 END
                + CASE WHEN k.HOUSE_AREA IS NOT NULL THEN 1 ELSE 0 END
                + CASE WHEN k.IS_HOUSE_MORTGAGED IS NOT NULL THEN 1 ELSE 0 END
                + CASE WHEN k.RES_ADDRS IS NOT NULL THEN 1 ELSE 0 END
                + CASE WHEN k.SHOP_INVEST IS NOT NULL THEN 1 ELSE 0 END
                + CASE WHEN k.VIKL_INF IS NOT NULL THEN 1 ELSE 0 END
                + CASE WHEN k.VEHICLE_PLATE_NO IS NOT NULL THEN 1 ELSE 0 END
                + CASE WHEN k.USAGE_NATURE IS NOT NULL THEN 1 ELSE 0 END
                + CASE WHEN k.IS_CAR_LOAN IS NOT NULL THEN 1 ELSE 0 END
                + CASE WHEN k.IS_CAR_MORTGAGED IS NOT NULL THEN 1 ELSE 0 END
                + CASE WHEN k.MTH_INCOM IS NOT NULL THEN 1 ELSE 0 END
                + CASE WHEN k.YR_INCOM IS NOT NULL THEN 1 ELSE 0 END
                + CASE WHEN k.BK_OUTER_LOAN_BAL IS NOT NULL THEN 1 ELSE 0 END
                + CASE WHEN k.BK_OUTER_CRDT_LMT IS NOT NULL THEN 1 ELSE 0 END
                + CASE WHEN k.AVAIL_LMT IS NOT NULL THEN 1 ELSE 0 END) >= 18
           THEN '1'                                                            -- KYC完整(≥18/22字段不为空)
           ELSE '0'                                                            -- KYC不完整
         END,                                                                -- KYC状态
         m.MNGR_POST_ID,                                                      -- v2.3.4: 理财管户经理岗位编号_取自DWD_CUST_MAN(MNG_TYP='1')
         a.ORG_ID                                                             -- 2026-08-01口径确认: 归属机构_取DWS_CUST_ASSE_LIAB资产快照
    FROM DWS_CUST_ASSE_LIAB a                                                 -- 客户资产负债表(当日余额快照)
    JOIN DWD_CUST_INDV_INFO c                                                  -- 客户基本信息(OPEN_DATE,管户经理)
      ON c.CUST_ID = a.CUST_ID
     AND c.PERSN_LEGAL_BK_CODE = a.PERSN_LEGAL_BK_CODE                        -- v2.3.2: 强制联动法人行号作为基础计算单位
    LEFT JOIN DWD_CUST_MAN m                                                    -- v2.3.4: 信贷管户关系表
      ON m.CUST_ID = c.CUST_ID                                                  -- 关联客户号
     AND m.PERSN_LEGAL_BK_CODE = a.PERSN_LEGAL_BK_CODE                          -- v2.3.2: 强制联动法人行号
     AND m.MNG_TYP = '1'                                                        -- MNG_TYP='1'=理财管户,仅取理财管户经理
    LEFT JOIN DWS_CUST_LVL_INFO l                                              -- 客户等级信息(当前等级)
      ON l.CUST_ID = c.CUST_ID
     AND l.PERSN_LEGAL_BK_CODE = a.PERSN_LEGAL_BK_CODE                        -- v2.3.2: 强制联动法人行号作为基础计算单位
     AND l.DATA_DATE = V_DATA_DATE                                               -- 取当日等级快照
    LEFT JOIN DWD_CUST_INDV_KYC k                                              -- 客户KYC信息(22字段完整度)
      ON k.CUST_ID = c.CUST_ID                                                 -- v2.3.2: DWD_CUST_INDV_KYC无PERSN_LEGAL_BK_CODE字段，仅用CUST_ID关联
   WHERE a.DATA_DATE = V_DATA_DATE                                             -- 取当日资产快照
     AND a.BAL_TYPE = '1'                                                      -- BAL_TYPE='1'=余额类型
     AND c.OPEN_DATE IS NOT NULL                                               -- 开户日期不为空
    AND TO_DATE(REPLACE(SUBSTR(c.OPEN_DATE, 1, 10), '-', ''), 'YYYYMMDD')
        BETWEEN TO_DATE(V_180D_WINDOW_BEGIN, 'YYYYMMDD')                       -- 开户日≥180天前（左闭，参数23）
            AND TO_DATE(V_DATA_DATE, 'YYYYMMDD');                             -- 开户日≤当天（右闭）—即180天内新客

  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := 'TMP2 完成：生成180天内新客基础数据（含当月新客未评级+新客周期内接触判断）';
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
  -- 步骤4: 目标表写入 — 生成月度(M)明细数据
  --   v2.3.0: 去掉季(Q)/年(N)切片，仅保留月度(M)
  --   每轮跑批写入当天(DATA_DATE=V_SYSDAT)的月度新客明细
  ------------------------------------------------------------------
  V_NO_ID := '3';
  V_BGN_DATE := SYSDATE;

  INSERT INTO ADS_CUST_NEW_CUST_DTL (
      PERSN_LEGAL_BK_CODE,       -- 法人行号
      DATA_DATE,                  -- 数据日期(YYYYMMDD)
      CUST_ID,                    -- 客户编号
      CUST_NAME,                  -- 客户姓名
      CUST_LVL,                   -- 客户等级
      NEW_CUST_CYCLE,             -- 新客周期(1/2/3)
      DEPO_CURNT_DEPO_BAL,        -- 活期存款余额
      FIXD_DEPO_BAL,              -- 定期存款余额
      FIN_AMT,                    -- 理财余额
      CNTCT_STATE,                -- 接触状态(1=已接触,0=未接触)
      KYC_STATE,                  -- KYC完成状态(1=完整,0=不完整)
      POST_ID,                    -- 管户经理岗位编号
      ORG_ID,                     -- 归属机构编号
      STATIS_CYCLE                -- 统计周期 - v2.3.0: 仅保留M(月度)
  )
  SELECT b.PERSN_LEGAL_BK_CODE,
         V_DATA_DATE,                                                         -- 数据日期=跑批日期
         b.CUST_ID,
         b.CUST_NAME,
         b.CUST_LVL,
         b.NEW_CUST_CYCLE,
         b.DEPO_CURNT_DEPO_BAL,
         b.FIXD_DEPO_BAL,
         b.FIN_AMT,
         b.CNTCT_STATE,
         b.KYC_STATE,
         b.POST_ID,
         b.ORG_ID,
         'M'                                                                   -- v2.3.0: 仅生成月度(M)统计周期
    FROM TMP_ADS_NEW_CUST_BASE b;                                              -- 从临时表读取新客基础数据

  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := '第3段完成：写入月度(M)新客经营明细';
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
