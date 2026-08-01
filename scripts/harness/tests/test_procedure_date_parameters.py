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

    def test_direct_month_derivation_from_data_date_is_rejected(self):
        sql = "V_BN_MONTH := TRUNC(TO_DATE(V_DATA_DATE, 'YYYYMMDD'), 'MM');"
        self.assertTrue(validate_procedure_text(Path("sample.sql"), sql))

    def test_direct_cutoff_derivation_from_data_date_is_rejected(self):
        sql = "V_CUTOFF_DATE := ADD_MONTHS(TRUNC(TO_DATE(V_DATA_DATE, 'YYYYMMDD'), 'YYYY'), -36);"
        self.assertTrue(validate_procedure_text(Path("sample.sql"), sql))

    def test_fixed_window_derivation_from_data_date_is_rejected(self):
        sql = "WHERE t.TX_DATE BETWEEN TO_DATE(V_DATA_DATE, 'YYYYMMDD') - 365 AND TO_DATE(V_DATA_DATE, 'YYYYMMDD')"
        self.assertTrue(validate_procedure_text(Path("sample.sql"), sql))

    def test_record_relative_date_difference_is_allowed(self):
        sql = (
            "WHEN TO_DATE(V_DATA_DATE, 'YYYYMMDD') - TO_DATE(REPLACE(SUBSTR(c.OPEN_DATE, 1, 10), '-', ''), 'YYYYMMDD') < 30 "
            "THEN '1'"
        )
        self.assertEqual(validate_procedure_text(Path("sample.sql"), sql), [])

    def test_inline_function_call_is_rejected(self):
        sql = "WHERE t.data_date = sys_fun_deal_date(V_SYSDAT, 2)"
        self.assertTrue(validate_procedure_text(Path("sample.sql"), sql))

    def test_unimplemented_function_code_is_rejected(self):
        sql = "V_X := sys_fun_deal_date(V_SYSDAT, 99);"
        errors = validate_procedure_text(Path("sample.sql"), sql)
        self.assertTrue(any("未在" in error for error in errors))

    def test_function_implements_registered_codes(self):
        from scripts.validate_procedure_date_parameters import function_implemented_codes

        implemented = function_implemented_codes()
        self.assertTrue({22, 23}.issubset(implemented))
