import unittest

from scripts.harness.workflow_router import WorkflowRoutingError, route_command


class WorkflowRouterTests(unittest.TestCase):
    def test_requirement_command_routes_to_requirement_profile(self):
        result = route_command("根据需求文档开发目标表存储过程")
        self.assertEqual(result["profile"], "requirement_development")
        self.assertEqual(result["skill"], "crm-requirement-development")
        self.assertFalse(result["read_only"])

    def test_schema_command_routes_to_schema_profile(self):
        result = route_command("根据 Mapping Excel 变更同步 MD、DD 和数据字典")
        self.assertEqual(result["profile"], "schema_change")
        self.assertEqual(result["skill"], "crm-schema-change")

    def test_combined_command_requires_follow_up_schema_task(self):
        result = route_command("先按业务需求开发，再同步 Mapping Excel 表结构")
        self.assertEqual(result["profile"], "requirement_development")
        self.assertEqual(result["follow_up"], "schema_change")

    def test_read_only_command_does_not_select_write_profile(self):
        result = route_command("扫描并校验数据字典")
        self.assertEqual(result["profile"], "read_only")
        self.assertTrue(result["read_only"])

    def test_ambiguous_command_blocks_routing(self):
        with self.assertRaises(WorkflowRoutingError):
            route_command("处理一下这个任务")


if __name__ == "__main__":
    unittest.main()
