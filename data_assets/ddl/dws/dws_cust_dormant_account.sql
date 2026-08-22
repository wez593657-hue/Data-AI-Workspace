/*
 * DWS_CUST_DORMANT_ACCOUT
 * 中文名称: 睡眠户客户信息表
 * 版本: v1.0
 * 创建/纳管日期: 2026-08-17（由需求方提供表结构并纳入 DDL 管理）
 * 数据层: DWS（汇总层）
 * 更新周期: 日（每日一张快照，data_date 标识）
 * 说明: 睡眠户清单权威来源表。自 PRC_ADS_CUST_SLEEP_WAKE_DTL v2.16.0 起，
 *       睡眠户唤醒过程以本表为睡眠户身份的唯一事实来源：
 *         - 每月月初：取最新全量睡眠户（客户号 + 法人行号）作为当月清单基数；
 *         - 月内每日：取新产生的睡眠户（当日快照有、当月清单无）追加，清单只增不减。
 *       唤醒判定（当月新增持有定期/理财/保险）与接触判定（当月有效接触）不依赖本表。
 * 字段说明:
 *   persn_legal_bk_code: 客户所在法人行号
 *   data_date           : 快照日期，YYYYMMDD 字符串，与跑批日期同格式可直接范围比较
 *   cust_id             : 客户号
 * 已知边界: 表内无 ORG_ID/产品余额/睡眠产生日期/客户类型字段，
 *           归属机构仅由资产快照解析（缺失置空并预警，不做客户信息表兜底）；
 *           "新产生"识别采用“当日快照存在且不在当月清单”的 NOT EXISTS 方案；
 *           取数日直接使用当日快照（data_date = 跑批日），当日快照就绪为跑批前置条件。
 */

CREATE TABLE IF NOT EXISTS DWS_CUST_DORMANT_ACCOUT (
    PERSN_LEGAL_BK_CODE VARCHAR(4),   -- 客户所在法人行号
    DATA_DATE           VARCHAR(8),   -- 快照日期，YYYYMMDD，每日一条快照
    CUST_ID             VARCHAR(20)   -- 客户号
);

COMMENT ON TABLE  DWS_CUST_DORMANT_ACCOUT IS '睡眠户客户信息表（DWS每日快照，睡眠户清单权威来源）';
COMMENT ON COLUMN DWS_CUST_DORMANT_ACCOUT.PERSN_LEGAL_BK_CODE IS '客户所在法人行号：VARCHAR(4)，与CUST_ID构成睡眠户身份键。';
COMMENT ON COLUMN DWS_CUST_DORMANT_ACCOUT.DATA_DATE IS '快照日期：VARCHAR(8)，YYYYMMDD，每日一张快照；睡眠户唤醒过程直接取当日快照（data_date=V_DATA_DATE）。';
COMMENT ON COLUMN DWS_CUST_DORMANT_ACCOUT.CUST_ID IS '客户号：VARCHAR(20)，睡眠客户唯一标识。';

-- 建议索引（由 DBA 评估落地）：
-- CREATE INDEX IDX_DORMANT_ACCT_DATE ON DWS_CUST_DORMANT_ACCOUT (DATA_DATE, PERSN_LEGAL_BK_CODE, CUST_ID);