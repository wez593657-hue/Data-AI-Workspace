import unittest

from scripts.harness.resolve_task import TaskResolutionError, resolve_task_id


class TaskResolverTests(unittest.TestCase):
    def test_explicit_task_id_is_required(self):
        self.assertEqual(resolve_task_id("master", explicit="maturity-takeover-v2"), "maturity-takeover-v2")
        with self.assertRaises(TaskResolutionError):
            resolve_task_id("master")


if __name__ == "__main__":
    unittest.main()
