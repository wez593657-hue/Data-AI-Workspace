import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[3]
DTL = (ROOT / "data_assets/stored_procedure/dws_to_ads/PRC_ADS_CUST_SLEEP_WAKE_DTL.sql").read_text(encoding="utf-8")
STATIS = (ROOT / "data_assets/stored_procedure/dws_to_ads/PRC_ADS_CUST_SLEEP_WAKE_STATIS.sql").read_text(encoding="utf-8")


class SleepWakeProcedureTests(unittest.TestCase):
    def test_month_start_keeps_same_day_candidate_and_wake_flow(self):
        self.assertIn("V_IS_MONTH_BEGIN = 'N'", DTL)
        self.assertIn("FROM TMP_ADS_SLEEP_CANDIDATE ca", DTL)
        self.assertIn("V_PREV_MONTH_END := V_PREV_DAY", DTL)

    def test_month_start_rechecks_aum_and_active_transactions(self):
        self.assertIn("a0.DATA_DATE = V_DATA_DATE", DTL)
        self.assertIn("NVL(a0.AUM_BAL, 0) < 100", DTL)
        self.assertIn("t0.JIOYCFFS = '0'", DTL)
        self.assertIn("V_IS_MONTH_BEGIN = 'Y'", DTL)

    def test_sleep_candidate_uses_legal_entity_and_org_grain(self):
        self.assertIn("t.PERSN_LEGAL_BK_CODE = a.PERSN_LEGAL_BK_CODE", DTL)
        self.assertIn("b.PERSN_LEGAL_BK_CODE = a.PERSN_LEGAL_BK_CODE", DTL)
        self.assertIn("b.ORG_ID", DTL)
        self.assertIn("a.ORG_ID", DTL)

    def test_wake_state_is_monthly_accumulative(self):
        self.assertIn("CASE WHEN b.WAKE_STATE = '1' THEN '1'", DTL)
        self.assertIn("WHEN sw.IS_WAKE = 1      THEN '1'", DTL)
        self.assertIn("CASE WHEN V_IS_MONTH_BEGIN = 'Y' THEN '0' ELSE y.WAKE_STATE END", DTL)

    def test_contact_state_is_monthly_accumulative(self):
        self.assertIn("b.CNTCT_STATE = '1' OR EXISTS", DTL)
        self.assertIn("CASE WHEN V_IS_MONTH_BEGIN = 'Y' THEN '0' ELSE y.CNTCT_STATE END", DTL)

    def test_missing_daily_snapshot_does_not_overwrite_history(self):
        self.assertIn("WHERE EXISTS (", DTL)
        self.assertIn("a3.DATA_DATE = V_DATA_DATE", DTL)
        self.assertIn("a3.ORG_ID = b.ORG_ID", DTL)

    def test_wake_products_include_fixed_finance_and_insurance(self):
        for expression in ("a2.FIXD_DEPO_BAL", "a2.FIN_BAL", "a2.INSUR_BAL"):
            self.assertIn(expression, DTL)

    def test_statistics_keeps_single_total_metric_contract(self):
        self.assertIn("COUNT(*) AS CUST_CNT", STATIS)
        self.assertIn("WAKE_CUST_CNT", STATIS)
        self.assertNotIn("CARRYOVER_CUST_CNT", STATIS)
        self.assertNotIn("NEW_CUST_CNT", STATIS)

    def test_history_cleanup_keeps_data_date_indexable(self):
        self.assertIn("s.DATA_DATE < TO_CHAR(", STATIS)
        self.assertNotIn("TO_DATE(s.DATA_DATE,'YYYYMMDD') <", STATIS)


if __name__ == "__main__":
    unittest.main()
