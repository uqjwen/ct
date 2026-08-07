import subprocess
import sys
import unittest
from pathlib import Path

from tools.check_interaction_2_2_ag_boundary import _is_assigned, _is_observed


ROOT = Path(__file__).resolve().parents[1]


class Interaction22AgClarificationTests(unittest.TestCase):
    def test_checker_accepts_real_input_to_observed_output_path(self) -> None:
        completed = subprocess.run(
            [sys.executable, "tools/check_interaction_2_2_ag_boundary.py"],
            cwd=ROOT,
            text=True,
            capture_output=True,
        )
        self.assertEqual(0, completed.returncode, completed.stderr)
        self.assertIn("AG_FP05_DUT_BOUNDARY_PASS inputs=4 outputs=3", completed.stdout)

    def test_assignment_check_rejects_conditional_dut_output_drive(self) -> None:
        task = "if (inject_fault) bus.lsu_mmu_abort = 1'b1;"

        self.assertTrue(_is_assigned(task, "lsu_mmu_abort"))

    def test_assignment_check_rejects_conditional_dut_output_force(self) -> None:
        task = "if (inject_fault) force bus.lsu_lrq_create_frz = 1'b0;"

        self.assertTrue(_is_assigned(task, "lsu_lrq_create_frz"))

    def test_assignment_check_rejects_conditional_dut_output_select_drive(self) -> None:
        for select in (
            "[0]",
            "[3:0]",
            "[index +: 4]",
            "[index -: 4]",
            "[index_array[lane]]",
        ):
            with self.subTest(select=select):
                task = (
                    "if (inject_fault) "
                    f"bus.lag_ex1_stall_restart_entry{select} = 1'b1;"
                )

                self.assertTrue(_is_assigned(task, "lag_ex1_stall_restart_entry"))

    def test_assignment_check_rejects_concatenated_lvalue(self) -> None:
        task = "{bus.lsu_mmu_abort, spare} = 2'b10;"

        self.assertTrue(_is_assigned(task, "lsu_mmu_abort"))

    def test_assignment_check_rejects_prefix_and_postfix_updates(self) -> None:
        for task in (
            "bus.lsu_mmu_abort++;",
            "bus.lsu_mmu_abort--;",
            "++bus.lsu_mmu_abort;",
            "--bus.lsu_mmu_abort;",
        ):
            with self.subTest(task=task):
                self.assertTrue(_is_assigned(task, "lsu_mmu_abort"))

    def test_assignment_check_rejects_assignment_expression_in_predicate(self) -> None:
        task = "expect_true((bus.lsu_mmu_abort = 1'b1), \"must be high\");"

        self.assertTrue(_is_assigned(task, "lsu_mmu_abort"))

    def test_assignment_check_rejects_system_call_in_predicate(self) -> None:
        task = 'expect_true($cast(bus.lsu_mmu_abort, rhs), "cast");'

        self.assertTrue(_is_assigned(task, "lsu_mmu_abort"))

    def test_assignment_check_rejects_ref_style_call_in_predicate(self) -> None:
        task = """
            function automatic logic mutate(ref logic value);
              value = 1'b1;
              return value;
            endfunction
            expect_true(mutate(bus.lsu_mmu_abort), "mutation");
        """

        self.assertTrue(_is_assigned(task, "lsu_mmu_abort"))

    def test_assignment_check_rejects_method_or_package_call_in_predicate(self) -> None:
        for call in (
            "observer.mutate(bus.lsu_mmu_abort)",
            "guard_pkg::mutate(bus.lsu_mmu_abort)",
        ):
            with self.subTest(call=call):
                task = f'expect_true({call}, "nested call");'

                self.assertTrue(_is_assigned(task, "lsu_mmu_abort"))

    def test_assignment_check_rejects_output_or_ref_task_argument(self) -> None:
        for declaration in ("output logic value", "ref logic value"):
            with self.subTest(declaration=declaration):
                task = f"""
                    task automatic mutate({declaration});
                      value = 1'b1;
                    endtask
                    mutate(bus.lsu_mmu_abort);
                """

                self.assertTrue(_is_assigned(task, "lsu_mmu_abort"))

    def test_assignment_check_allows_nested_observation_predicate(self) -> None:
        task = """
            expect_true(
                (ready && (|bus.lag_ex1_stall_restart_entry[3:0])),
                "nested predicate"
            );
        """

        self.assertFalse(_is_assigned(task, "lag_ex1_stall_restart_entry"))
        self.assertTrue(_is_observed(task, "lag_ex1_stall_restart_entry"))

    def test_assignment_check_allows_grouping_parentheses_only(self) -> None:
        task = """
            expect_true(
                ((((bus.lsu_mmu_abort))) && ready),
                "grouped observation"
            );
        """

        self.assertFalse(_is_assigned(task, "lsu_mmu_abort"))
        self.assertTrue(_is_observed(task, "lsu_mmu_abort"))

    def test_assignment_check_ignores_dut_output_names_in_comments_and_strings(self) -> None:
        task = """
            // if (inject_fault) force bus.lag_ex1_stall_restart_entry = '1;
            expect_true(1'b1, "bus.lag_ex1_stall_restart_entry = '1");
        """

        self.assertFalse(_is_assigned(task, "lag_ex1_stall_restart_entry"))

    def test_observation_check_rejects_signal_used_only_in_message(self) -> None:
        task = 'expect_true(1\'b1, "bus.lag_ex1_stall_restart_entry observed");'

        self.assertFalse(_is_observed(task, "lag_ex1_stall_restart_entry"))
        self.assertTrue(
            _is_observed(
                "expect_true(|bus.lag_ex1_stall_restart_entry, \"restart present\");",
                "lag_ex1_stall_restart_entry",
            )
        )


if __name__ == "__main__":
    unittest.main()
