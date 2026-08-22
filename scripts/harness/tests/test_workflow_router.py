import unittest

from scripts.harness.workflow_router import WorkflowRoutingError, route_command


class WorkflowRouterTests(unittest.TestCase):
    def test_rule_governance_routes_to_governance_profile(self):
        result = route_command("根据项目规则治理方案更新 Change ID、审批和发布治理")
        self.assertEqual(result["profile"], "governance")
        self.assertIsNone(result["skill"])
        self.assertFalse(result["read_only"])

    def test_governance_takes_priority_over_read_only_wording(self):
        result = route_command("分析并执行规则治理流程")
        self.assertEqual(result["profile"], "governance")

    def test_mixed_governance_and_business_asset_change_blocks_routing(self):
        with self.assertRaises(WorkflowRoutingError):
            route_command("规则治理并修改 Mapping Excel")

    def test_requirement_command_routes_to_standard_profile(self):
        """Generic requirement commands default to standard (L2) tier."""
        result = route_command("根据需求文档开发目标表存储过程")
        self.assertEqual(result["profile"], "standard")
        self.assertEqual(result["skill"], "crm-requirement-development")
        self.assertFalse(result["read_only"])

    def test_bugfix_command_routes_to_lightweight_profile(self):
        """Bug fix commands route to lightweight (L1) tier."""
        result = route_command("修复存储过程中的边界条件bug")
        self.assertEqual(result["profile"], "lightweight")
        self.assertEqual(result["skill"], "crm-requirement-development")

    def test_new_table_command_routes_to_strict_profile(self):
        """New table / DDL commands route to strict (L3) tier."""
        result = route_command("按需求开发新表DDL和存储过程")
        self.assertEqual(result["profile"], "strict")
        self.assertEqual(result["skill"], "crm-requirement-development")

    def test_schema_command_routes_to_schema_profile(self):
        result = route_command("根据 Mapping Excel 变更同步 MD、DD 和数据字典")
        self.assertEqual(result["profile"], "schema_change")
        self.assertEqual(result["skill"], "crm-schema-change")
        self.assertEqual(
            result["required_skills"],
            ["crm-schema-change", "kingbase-ddl-generator"],
        )

    def test_schema_procedure_command_requires_procedure_skill_chain(self):
        result = route_command(
            "根据 Mapping Excel 同步 DDL、数据字典并刷新 PRC_DWD_ACCT_INSUR"
        )
        self.assertEqual(result["profile"], "schema_change")
        self.assertEqual(
            result["required_skills"],
            [
                "crm-schema-change",
                "kingbase-ddl-generator",
                "prc-sql",
                "validate-procedure-date-parameters",
            ],
        )

    def test_combined_command_requires_follow_up_schema_task(self):
        """Combined requirement + schema commands route to standard (L2) with follow-up."""
        result = route_command("先按业务需求开发，再同步 Mapping Excel 表结构")
        self.assertEqual(result["profile"], "standard")
        self.assertEqual(result["follow_up"], "schema_change")

    def test_read_only_command_does_not_select_write_profile(self):
        result = route_command("扫描并校验数据字典")
        self.assertEqual(result["profile"], "read_only")
        self.assertTrue(result["read_only"])

    def test_ambiguous_command_blocks_routing(self):
        with self.assertRaises(WorkflowRoutingError):
            route_command("处理一下这个任务")

    def test_comment_format_command_routes_to_lightweight(self):
        """Comment/format changes route to L1."""
        result = route_command("修改存储过程注释格式")
        self.assertEqual(result["profile"], "lightweight")

    def test_cross_module_command_routes_to_strict(self):
        """Cross-module changes route to L3."""
        result = route_command("跨模块修改存储过程血缘关系")
        self.assertEqual(result["profile"], "strict")

    def test_l3_priority_over_l1(self):
        """L3 (strict) takes priority over L1 (lightweight) when both match."""
        result = route_command("修复跨模块存储过程血缘关系")
        self.assertEqual(result["profile"], "strict")


if __name__ == "__main__":
    unittest.main()
