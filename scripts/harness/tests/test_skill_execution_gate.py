from __future__ import annotations

import unittest

from scripts.harness.gate_checker import GateError, _validate_skill_execution_gate


class SkillExecutionGateTests(unittest.TestCase):
    def _evidence(self, **overrides):
        value = {
            "purpose": "skill_execution",
            "input_workbook": "data_assets/mapping/ods_to_dwd/DWD.xlsx",
            "skills": ["crm-schema-change", "kingbase-ddl-generator"],
            "steps": ["excel_to_mapping", "excel_to_ddl", "excel_to_dictionary"],
            "output_files": [
                "data_assets/mapping/ods_to_dwd/ods到dwd映射.md",
                "data_assets/ddl/dwd/dwd_acct_insur.sql",
                "data_assets/data_dictionary/dwd/dwd_acct_insur.md",
            ],
        }
        value.update(overrides)
        return [value]

    def test_schema_asset_chain_is_required(self):
        _validate_skill_execution_gate(["skill_execution"], self._evidence())

    def test_procedure_output_requires_prc_skill_and_date_check(self):
        evidence = self._evidence(
            skills=["crm-schema-change", "kingbase-ddl-generator", "prc-sql"],
            output_files=[
                "data_assets/stored_procedure/ods_to_dwd/PRC_DWD_ACCT_INSUR.sql"
            ],
        )
        with self.assertRaises(GateError):
            _validate_skill_execution_gate(["skill_execution"], evidence)


if __name__ == "__main__":
    unittest.main()
