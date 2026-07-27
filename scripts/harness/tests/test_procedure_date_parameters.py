import unittest
from pathlib import Path

from scripts.validate_procedure_date_parameters import validate_procedure_text


class ProcedureDateParameterTests(unittest.TestCase):
    def test_named_parameter_is_allowed(self):
        sql = "V_PREV_DAY VARCHAR2(8) := sys_fun_deal_date(V_SYSDAT, 1);"
        self.assertEqual(validate_procedure_text(Path("sample.sql"), sql), [])

    def test_named_p_prefix_parameter_is_allowed(self):
        sql = "P_WINDOW_START := sys_fun_deal_date(V_SYSDAT, 18);"
        self.assertEqual(validate_procedure_text(Path("sample.sql"), sql), [])

    def test_direct_month_derivation_is_rejected(self):
        sql = "V_MONTH_END := LAST_DAY(TO_DATE(V_SYSDAT, 'YYYYMMDD'));"
        self.assertTrue(validate_procedure_text(Path("sample.sql"), sql))

    def test_inline_function_call_is_rejected(self):
        sql = "WHERE t.data_date = sys_fun_deal_date(V_SYSDAT, 2)"
        self.assertTrue(validate_procedure_text(Path("sample.sql"), sql))
