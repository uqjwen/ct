`timescale 1ns/1ps
`include "xx_lsu_ld_da_if.sv"
module xx_lsu_ld_da_tb;
  localparam int VB_DATA_ENTRY = 3;
  localparam int LQENTRY = 48;
  localparam int LSIQENTRY = 12;
  localparam int SQ_ENTRY = 12;
  localparam int WMB_ENTRY = 8;
  localparam int VMB_ENTRY = 8;
  localparam int PC_LEN = 15;
  localparam int IID_WIDTH = 7;
  localparam int VREG = 6;
  localparam int PREG = 7;
  xx_lsu_ld_da_if #(
    .VB_DATA_ENTRY (VB_DATA_ENTRY),
    .LQENTRY (LQENTRY),
    .LSIQENTRY (LSIQENTRY),
    .SQ_ENTRY (SQ_ENTRY),
    .WMB_ENTRY (WMB_ENTRY),
    .VMB_ENTRY (VMB_ENTRY),
    .PC_LEN (PC_LEN),
    .IID_WIDTH (IID_WIDTH),
    .VREG (VREG),
    .PREG (PREG)
  ) bus();
  xx_lsu_ld_da #(
    .VB_DATA_ENTRY (VB_DATA_ENTRY),
    .LQENTRY (LQENTRY),
    .LSIQENTRY (LSIQENTRY),
    .SQ_ENTRY (SQ_ENTRY),
    .WMB_ENTRY (WMB_ENTRY),
    .VMB_ENTRY (VMB_ENTRY),
    .PC_LEN (PC_LEN),
    .IID_WIDTH (IID_WIDTH),
    .VREG (VREG),
    .PREG (PREG)
  ) dut (
`include "xx_lsu_ld_da_connect.svh"
  );
  xx_lsu_ld_da_assertions checks (
    .clk (bus.forever_cpuclk),
    .reset_n (bus.cpurst_b),
    .fp01_qualify (bus.ldc_lda_ex2_inst_vld),
    .fp01_observe (bus.lda_rb_ex3_data_ori),
    .fp02_qualify (bus.ldc_lda_ex2_inst_vld),
    .fp02_observe (bus.lda_rb_ex3_data_ori),
    .fp03_qualify (bus.ldc_lda_ex2_inst_vld),
    .fp03_observe (bus.lda_ex2_ecc_stall),
    .fp04_qualify (bus.ldc_lda_ex2_inst_vld),
    .fp04_observe (bus.lda_lwb_ex3_expt_vld),
    .fp05_qualify (bus.ldc_lda_ex2_inst_vld),
    .fp05_observe (bus.lda_ex3_lq_entry_pop),
    .fp06_qualify (bus.ldc_lda_ex2_inst_vld),
    .fp06_observe (bus.lda_rb_ex3_create_vld),
    .fp07_qualify (bus.ldc_lda_ex2_inst_vld),
    .fp07_observe (bus.lda_lwb_ex3_cmplt_req),
    .fp08_qualify (bus.ldc_lda_ex2_inst_vld),
    .fp08_observe (bus.lda_lwb_ex3_data_req),
    .fp09_qualify (bus.ldc_lda_ex2_inst_vld),
    .fp09_observe (bus.lda_lwb_ex3_expt_vld),
    .fp10_qualify (bus.ldc_lda_ex2_inst_vld),
    .fp10_observe (bus.lda_lfb_set_wakeup_queue),
    .fp11_qualify (bus.ldc_lda_ex2_inst_vld),
    .fp11_observe (bus.ld_da_idu_halt_info_update_vld),
    .fp12_qualify (bus.ldc_lda_ex2_inst_vld),
    .fp12_observe (bus.lda_ex3_inst_vld)
  );
  assign bus.ctrl_ld_clk = bus.forever_cpuclk;
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
  task automatic tc_da_cache_data();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.ldc_lda_ex2_inst_vld = '1;
    bus.ldc_lda_ex2_get_dcache_data = '1;
    bus.dcache_lsu_ld_data_bank0_dout = '1;
    bus.dcache_lsu_ld_data_bank4_dout = '1;
    bus.dcache_lsu_ld_data_bank8_dout = '1;
    bus.dcache_lsu_ld_data_bank12_dout = '1;
    tick(1);
    expect_known(^bus.lda_rb_ex3_data_ori, "tc_da_cache_data");
  endtask
  task automatic tc_da_forward_merge();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.ldc_lda_ex2_inst_vld = '1;
    bus.ldc_lda_ex2_fwd_sq_vld = '1;
    bus.ldc_lda_ex2_fwd_wmb_vld = '1;
    bus.sq_lda_ex2_fwd_data = '1;
    bus.wmb_lda_fwd_data = '1;
    tick(1);
    expect_known(^bus.lda_rb_ex3_data_ori, "tc_da_forward_merge");
  endtask
  task automatic tc_da_ecc_replay();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.ldc_lda_ex2_inst_vld = '1;
    bus.cp0_lsu_ecc_en = '1;
    bus.dcache_lsu_ld_data_bank0_dout = '1;
    tick(1);
    expect_known(^bus.lda_ex2_ecc_stall, "tc_da_ecc_replay");
  endtask
  task automatic tc_da_access_fault();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.ldc_lda_ex2_inst_vld = '1;
    bus.mmu_lsu_access_fault0 = '1;
    bus.ldc_lda_ex2_expt_access_fault_mask = '1;
    tick(1);
    expect_known(^bus.lda_lwb_ex3_expt_vld, "tc_da_access_fault");
  endtask
  task automatic tc_da_lq_pop();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.ldc_lda_ex2_inst_vld = '1;
    bus.ldc_lda_ex2_lq_entry = '1;
    bus.ldc_lda_ex2_spec_fail = '1;
    tick(1);
    expect_known(^bus.lda_ex3_lq_entry_pop, "tc_da_lq_pop");
  endtask
  task automatic tc_da_rb_create_merge();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.ldc_lda_ex2_inst_vld = '1;
    bus.rb_lda_ex3_full = '1;
    bus.rb_lda_ex3_hit_idx = '1;
    tick(1);
    expect_known(^bus.lda_rb_ex3_create_vld, "tc_da_rb_create_merge");
  endtask
  task automatic tc_da_completion();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.ldc_lda_ex2_inst_vld = '1;
    bus.ldc_lda_ex2_expt_vld_except_access_err = '1;
    bus.rb_lda_ex3_full = '1;
    tick(1);
    expect_known(^bus.lda_lwb_ex3_cmplt_req, "tc_da_completion");
  endtask
  task automatic tc_da_data_request();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.ldc_lda_ex2_inst_vld = '1;
    bus.ldc_lda_ex2_inst_vls = '1;
    bus.ldc_lda_ex2_inst_us = '1;
    tick(1);
    expect_known(^bus.lda_lwb_ex3_data_req, "tc_da_data_request");
  endtask
  task automatic tc_da_terminal_state();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.ldc_lda_ex2_inst_vld = '1;
    bus.ldc_lda_ex2_spec_fail = '1;
    bus.rb_lda_ex3_full = '1;
    tick(1);
    expect_known(^bus.lda_lwb_ex3_expt_vld, "tc_da_terminal_state");
  endtask
  task automatic tc_da_dependency();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.ldc_lda_ex2_inst_vld = '1;
    bus.ldc_lda_ex2_lsid = '1;
    bus.ldc_lda_ex2_spec_fail = '1;
    tick(1);
    expect_known(^bus.lda_lfb_set_wakeup_queue, "tc_da_dependency");
  endtask
  task automatic tc_da_debug();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.ldc_lda_ex2_inst_vld = '1;
    bus.dtu_lsu_addr_halt_info = '1;
    bus.dtu_lsu_data_trig_en = '1;
    tick(1);
    expect_known(^bus.ld_da_idu_halt_info_update_vld, "tc_da_debug");
  endtask
  task automatic tc_da_flush_clock();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.ldc_lda_ex2_inst_vld = '1;
    bus.rtu_lsu_flush_fe = '1;
    bus.cp0_lsu_icg_en = '1;
    tick(1);
    expect_known(^bus.lda_ex3_inst_vld, "tc_da_flush_clock");
  endtask
  string selected_test;
  initial begin
    if (!$value$plusargs("TEST=%s", selected_test)) selected_test = "tc_da_cache_data";
    case (selected_test)
      "tc_da_cache_data": tc_da_cache_data();
      "tc_da_forward_merge": tc_da_forward_merge();
      "tc_da_ecc_replay": tc_da_ecc_replay();
      "tc_da_access_fault": tc_da_access_fault();
      "tc_da_lq_pop": tc_da_lq_pop();
      "tc_da_rb_create_merge": tc_da_rb_create_merge();
      "tc_da_completion": tc_da_completion();
      "tc_da_data_request": tc_da_data_request();
      "tc_da_terminal_state": tc_da_terminal_state();
      "tc_da_dependency": tc_da_dependency();
      "tc_da_debug": tc_da_debug();
      "tc_da_flush_clock": tc_da_flush_clock();
      default: $fatal(1, "unknown TEST=%s", selected_test);
    endcase
    $display("TEST_PASS %s static-harness execution", selected_test);
    $finish;
  end
endmodule
