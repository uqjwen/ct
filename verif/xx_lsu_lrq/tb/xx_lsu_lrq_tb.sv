`timescale 1ns/1ps
`include "xx_lsu_lrq_if.sv"
module xx_lsu_lrq_tb;
  localparam int PREG = 7;
  localparam int VREG = 6;
  localparam int IID_WIDTH = 10;
  localparam int VMBENTRY = 8;
  localparam int LRQENTRY = 12;
  localparam int PC_LEN = 15;
  localparam int LSIQENTRY = 12;
  localparam int SDIQENTRY = 12;
  xx_lsu_lrq_if #(
    .PREG (PREG),
    .VREG (VREG),
    .IID_WIDTH (IID_WIDTH),
    .VMBENTRY (VMBENTRY),
    .LRQENTRY (LRQENTRY),
    .PC_LEN (PC_LEN),
    .LSIQENTRY (LSIQENTRY),
    .SDIQENTRY (SDIQENTRY)
  ) bus();
  xx_lsu_lrq #(
    .PREG (PREG),
    .VREG (VREG),
    .IID_WIDTH (IID_WIDTH),
    .VMBENTRY (VMBENTRY),
    .LRQENTRY (LRQENTRY),
    .PC_LEN (PC_LEN),
    .LSIQENTRY (LSIQENTRY),
    .SDIQENTRY (SDIQENTRY)
  ) dut (
`include "xx_lsu_lrq_connect.svh"
  );
  xx_lsu_lrq_assertions checks (
    .clk (bus.forever_cpuclk),
    .reset_n (bus.cpurst_b),
    .fp01_qualify (bus.lsu0_lrq_create_vld),
    .fp01_observe (bus.lrq_lsu0_ex1_lrqid),
    .fp02_qualify (bus.lsu0_lrq_create_vld),
    .fp02_observe (bus.lrq_lsu0_rf_replay_vld),
    .fp03_qualify (bus.lsu0_lrq_create_vld),
    .fp03_observe (bus.lrq_lsu0_rf_va),
    .fp04_qualify (bus.lsu0_lrq_create_frz),
    .fp04_observe (bus.lrq_lsu0_rf_replay_vld),
    .fp05_qualify (bus.lsu0_lrq_exx_tlb_wakeup),
    .fp05_observe (bus.lrq0_idu_exx_wakeup),
    .fp06_qualify (bus.idu_lsu_old_vld),
    .fp06_observe (bus.lrq_lsu0_rf_replay_vld),
    .fp07_qualify (bus.lsu0_lrq_create_vld),
    .fp07_observe (bus.lrq_lsu0_rf_replay_vld),
    .fp08_qualify (bus.lsu0_lrq_create_no_spec_chk),
    .fp08_observe (bus.lrq0_hit_no_spec_tbl),
    .fp09_qualify (bus.lsu0_lrq_ex3_secd),
    .fp09_observe (bus.lrq_lsu0_rf_already_da),
    .fp10_qualify (bus.lsu0_lrq_create_vld),
    .fp10_observe (bus.lrq_lsu0_rf_replay_vld),
    .fp11_qualify (bus.lsu0_lrq_create_vld),
    .fp11_observe (bus.lrq_lsu0_rf_replay_vld),
    .fp12_qualify (bus.lsu0_lrq_create_vld),
    .fp12_observe (bus.lrq_lsu0_ex1_lrqid)
  );
  assign bus.lsu_special_clk = bus.forever_cpuclk;
  initial bus.forever_cpuclk = 1'b0;
  always #5 bus.forever_cpuclk = ~bus.forever_cpuclk;
  task automatic tick(input int cycles = 1);
    repeat (cycles) begin @(posedge bus.forever_cpuclk); #1; end
  endtask
  task automatic expect_known(input logic value, input string label);
    if ($isunknown(value)) $fatal(1, "CHECK_FAIL: %s", label);
  endtask
  task automatic apply_reset();
    bus.drive_idle();
    bus.cpurst_b = 1'b0;
    tick(3);
    bus.cpurst_b = 1'b1;
    tick(1);
  endtask
  task automatic tc_lrq_capacity();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.lsu0_lrq_create_vld = '1;
    bus.lsu2_lrq_create_vld = '1;
    bus.lsu3_lrq_create_vld = '1;
    tick(1);
    expect_known(^bus.lrq_lsu0_ex1_lrqid, "tc_lrq_capacity");
  endtask
  task automatic tc_lrq_create_accept();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.lsu0_lrq_create_vld = '1;
    bus.rtu_lsu_flush_fe = '1;
    bus.lsu0_lrq_create_iid = '1;
    tick(1);
    expect_known(^bus.lrq_lsu0_rf_replay_vld, "tc_lrq_create_accept");
  endtask
  task automatic tc_lrq_payload();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.lsu0_lrq_create_vld = '1;
    bus.lsu0_lrq_create_va = '1;
    bus.lsu0_lrq_create_iid = '1;
    bus.lsu0_lrq_create_bytes_vld = '1;
    tick(1);
    expect_known(^bus.lrq_lsu0_rf_va, "tc_lrq_payload");
  endtask
  task automatic tc_lrq_freeze();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.lsu0_lrq_create_frz = '1;
    bus.lsu0_lrq_create_wait_old_chk = '1;
    bus.lsu0_lrq_exx_tlb_wakeup = '1;
    bus.lsu0_lrq_ex3_rb_full = '1;
    tick(1);
    expect_known(^bus.lrq_lsu0_rf_replay_vld, "tc_lrq_freeze");
  endtask
  task automatic tc_lrq_wakeup();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.lsu0_lrq_exx_tlb_wakeup = '1;
    bus.lsu0_lrq_frz_clr = '1;
    bus.lsu0_lrq_create_iid = '1;
    tick(1);
    expect_known(^bus.lrq0_idu_exx_wakeup, "tc_lrq_wakeup");
  endtask
  task automatic tc_lrq_oldest_issue();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.idu_lsu_old_vld = '1;
    bus.idu_lsu_old_iid = '1;
    bus.lsu0_lrq_create_iid = '1;
    tick(1);
    expect_known(^bus.lrq_lsu0_rf_replay_vld, "tc_lrq_oldest_issue");
  endtask
  task automatic tc_lrq_replay();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.lsu0_lrq_create_vld = '1;
    bus.lsu0_lrq_create_boundary = '1;
    bus.lsu0_lrq_create_unit_stride = '1;
    tick(1);
    expect_known(^bus.lrq_lsu0_rf_replay_vld, "tc_lrq_replay");
  endtask
  task automatic tc_lrq_barrier();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.lsu0_lrq_create_no_spec_chk = '1;
    bus.lsu0_lrq_create_bar_chk = '1;
    bus.idu_lsu0_rf_no_spec_exist = '1;
    tick(1);
    expect_known(^bus.lrq0_hit_no_spec_tbl, "tc_lrq_barrier");
  endtask
  task automatic tc_lrq_da_feedback();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.lsu0_lrq_ex3_secd = '1;
    bus.lsu0_lrq_ex3_already_da = '1;
    bus.lsu0_lrq_ex3_spec_fail = '1;
    tick(1);
    expect_known(^bus.lrq_lsu0_rf_already_da, "tc_lrq_da_feedback");
  endtask
  task automatic tc_lrq_flush();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.lsu0_lrq_create_vld = '1;
    bus.rtu_lsu_flush_fe = '1;
    bus.rtu_ck_flush = '1;
    bus.rtu_ck_flush_iid = '1;
    tick(1);
    expect_known(^bus.lrq_lsu0_rf_replay_vld, "tc_lrq_flush");
  endtask
  task automatic tc_lrq_clock_reset();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.lsu0_lrq_create_vld = '1;
    bus.cp0_lsu_icg_en = '1;
    bus.pad_yy_icg_scan_en = '1;
    tick(1);
    expect_known(^bus.lrq_lsu0_rf_replay_vld, "tc_lrq_clock_reset");
  endtask
  task automatic tc_lrq_parameter_contract();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.lsu0_lrq_create_vld = '1;
    bus.lsu0_lrq_pop_entry = '1;
    tick(1);
    expect_known(^bus.lrq_lsu0_ex1_lrqid, "tc_lrq_parameter_contract");
  endtask
  string selected_test;
  initial begin
    if (!$value$plusargs("TEST=%s", selected_test)) selected_test = "tc_lrq_capacity";
    case (selected_test)
      "tc_lrq_capacity": tc_lrq_capacity();
      "tc_lrq_create_accept": tc_lrq_create_accept();
      "tc_lrq_payload": tc_lrq_payload();
      "tc_lrq_freeze": tc_lrq_freeze();
      "tc_lrq_wakeup": tc_lrq_wakeup();
      "tc_lrq_oldest_issue": tc_lrq_oldest_issue();
      "tc_lrq_replay": tc_lrq_replay();
      "tc_lrq_barrier": tc_lrq_barrier();
      "tc_lrq_da_feedback": tc_lrq_da_feedback();
      "tc_lrq_flush": tc_lrq_flush();
      "tc_lrq_clock_reset": tc_lrq_clock_reset();
      "tc_lrq_parameter_contract": tc_lrq_parameter_contract();
      default: $fatal(1, "unknown TEST=%s", selected_test);
    endcase
    $display("TEST_PASS %s static-harness execution", selected_test);
    $finish;
  end
endmodule
