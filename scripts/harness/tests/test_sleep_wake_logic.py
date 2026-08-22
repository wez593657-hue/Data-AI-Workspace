import unittest
from pathlib import Path


# 断言契约同步至 PRC_ADS_CUST_SLEEP_WAKE_DTL v2.16.2（属性计算式重构）：
# 身份一律出自 DORMANT 快照；属性/状态在 INSERT 时直接计算，不使用 UPDATE。
ROOT = Path(__file__).resolve().parents[3]
DTL = (ROOT / "data_assets/stored_procedure/dws_to_ads/PRC_ADS_CUST_SLEEP_WAKE_DTL.sql").read_text(encoding="utf-8")
STATIS = (ROOT / "data_assets/stored_procedure/dws_to_ads/PRC_ADS_CUST_SLEEP_WAKE_STATIS.sql").read_text(encoding="utf-8")


class SleepWakeProcedureTests(unittest.TestCase):
    def test_month_start_keeps_same_day_candidate_and_wake_flow(self):
        self.assertIn("V_IS_MONTH_BEGIN := 'N'", DTL)
        self.assertIn("INSERT INTO TMP_ADS_SLEEP_WAKE_BASE", DTL)
        self.assertIn("y.DATA_DATE = V_PREV_DAY", DTL)

    def test_month_start_rebuilds_base_from_dormant_snapshot(self):
        self.assertIn("V_IS_MONTH_BEGIN = 'Y'", DTL)
        self.assertIn("FROM DWS_CUST_DORMANT_ACCOUT d", DTL)
        self.assertIn("WHERE d.DATA_DATE = V_DATA_DATE", DTL)
        # v2.16.2: 身份一律出自 DORMANT 快照，过程内不再按资产/交易重算
        self.assertNotIn("NVL(w.AUM_BAL, 0) < 100", DTL)
        self.assertNotIn("JIOYCFFS", DTL)

    def test_sleep_candidate_uses_legal_entity_and_org_grain(self):
        self.assertIn("w.PERSN_LEGAL_BK_CODE = b.PERSN_LEGAL_BK_CODE", DTL)
        self.assertIn("c.PERSN_LEGAL_BK_CODE = b.PERSN_LEGAL_BK_CODE", DTL)
        self.assertIn("m.ORG_ID = w.ORG_ID", DTL)
        self.assertIn("w.ORG_ID", DTL)

    def test_wake_state_is_monthly_accumulative(self):
        self.assertIn("FROM TMP_ADS_SLEEP_WAKE_PROD p", DTL)
        self.assertIn("THEN '1' ELSE '0' END AS WAKE_STATE", DTL)
        # 当月窗口覆盖定期/理财/保险三源
        self.assertIn("d.INTRI_BGN_DATE >= V_CURR_MONTH_BEGIN", DTL)
        self.assertIn("f.ISSU_DATE >= V_CURR_MONTH_BEGIN", DTL)
        self.assertIn("i.LAST_TX_DATE >= V_CURR_MONTH_BEGIN", DTL)
        # v2.16.2: 不使用 UPDATE 累积
        self.assertNotIn("SET b.WAKE_STATE", DTL)

    def test_contact_state_is_monthly_accumulative(self):
        self.assertIn("FROM TMP_ADS_SLEEP_CNTCT ct", DTL)
        self.assertIn("THEN '1' ELSE '0' END AS CNTCT_STATE", DTL)
        self.assertIn("r.MKT_TYP IN ('1','2','3','4')", DTL)
        self.assertIn("r.MKT_TIME >= SUBSTR(V_CURR_MONTH_BEGIN,1,4)", DTL)
        # v2.16.2: 不使用 UPDATE 累积
        self.assertNotIn("SET b.CNTCT_STATE", DTL)

    def test_missing_daily_snapshot_does_not_overwrite_history(self):
        # v2.16.0 S-1前置校验: 快照缺失直接终止，防止静默覆盖历史
        self.assertIn("IF V_SNAP_CNT = 0 THEN", DTL)
        self.assertIn("RAISE_APPLICATION_ERROR(-20003", DTL)

    def test_wake_products_include_fixed_finance_and_insurance(self):
        for expression in ("FROM DWD_ACCT_DEPO d", "FROM DWD_ACCT_FIN f", "FROM DWD_ACCT_INSUR i"):
            self.assertIn(expression, DTL)

    def test_statistics_keeps_single_total_metric_contract(self):
        self.assertIn("COUNT(*) AS CUST_CNT", STATIS)
        self.assertIn("WAKE_CUST_CNT", STATIS)
        self.assertNotIn("CARRYOVER_CUST_CNT", STATIS)
        self.assertNotIn("NEW_CUST_CNT", STATIS)

    def test_history_cleanup_keeps_data_date_indexable(self):
        self.assertIn("s.DATA_DATE < V_HISTORY_CUTOFF_DATE", STATIS)
        self.assertNotIn("TO_DATE(s.DATA_DATE,'YYYYMMDD') <", STATIS)


if __name__ == "__main__":
    unittest.main()
