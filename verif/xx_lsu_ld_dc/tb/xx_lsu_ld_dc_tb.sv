`timescale 1ns/1ps
`include "xx_lsu_ld_dc_if.sv"
module xx_lsu_ld_dc_tb;
  localparam int VB_DATA_ENTRY = 3;
  localparam int LQENTRY = 48;
  localparam int LSIQENTRY = 12;
  localparam int VMBENTRY = 8;
  localparam int PC_LEN = 15;
  localparam int IID_WIDTH = 7;
  localparam int VREG = 6;
  localparam int PREG = 7;
  xx_lsu_ld_dc_if #(
    .VB_DATA_ENTRY (VB_DATA_ENTRY),
    .LQENTRY (LQENTRY),
    .LSIQENTRY (LSIQENTRY),
    .VMBENTRY (VMBENTRY),
    .PC_LEN (PC_LEN),
    .IID_WIDTH (IID_WIDTH),
    .VREG (VREG),
    .PREG (PREG)
  ) bus();
  xx_lsu_ld_dc #(
    .VB_DATA_ENTRY (VB_DATA_ENTRY),
    .LQENTRY (LQENTRY),
    .LSIQENTRY (LSIQENTRY),
    .VMBENTRY (VMBENTRY),
    .PC_LEN (PC_LEN),
    .IID_WIDTH (IID_WIDTH),
    .VREG (VREG),
    .PREG (PREG)
  ) dut (
`include "xx_lsu_ld_dc_connect.svh"
  );
  xx_lsu_ld_dc_assertions checks (
    .clk (bus.forever_cpuclk),
    .reset_n (bus.cpurst_b),
    .fp01_qualify (bus.lag_ldc_ex1_inst_vld),
    .fp01_observe (bus.ldc_lda_ex2_inst_vld),
    .fp02_qualify (bus.dcache_arb_ldc_borrow_vld),
    .fp02_observe (bus.ldc_ex2_borrow_vld),
    .fp03_qualify (bus.lag_ldc_ex1_inst_vld),
    .fp03_observe (bus.ldc_hit_way),
    .fp04_qualify (bus.lag_ldc_ex1_inst_vld),
    .fp04_observe (bus.ldc_lda_ex2_settle_way),
    .fp05_qualify (bus.lag_ldc_ex1_inst_vld),
    .fp05_observe (bus.ldc_lda_ex2_bytes_vld),
    .fp06_qualify (bus.lag_ldc_ex1_inst_vld),
    .fp06_observe (bus.ldc_lq_ex2_create_vld),
    .fp07_qualify (bus.lag_ldc_ex1_inst_vld),
    .fp07_observe (bus.ldc_lda_ex2_inst_vld),
    .fp08_qualify (bus.lag_ldc_ex1_inst_vld),
    .fp08_observe (bus.ldc_lda_ex2_expt_vld_except_access_err),
    .fp09_qualify (bus.lag_ldc_ex1_inst_vld),
    .fp09_observe (bus.ldc_lda_ex2_fwd_sq_vld),
    .fp10_qualify (bus.lag_ldc_ex1_inst_vld),
    .fp10_observe (bus.ldc_lda_ex2_inst_vld),
    .fp11_qualify (bus.lag_ldc_ex1_inst_vld),
    .fp11_observe (bus.ld_dc_dtu_addr_vld),
    .fp12_qualify (bus.lag_ldc_ex1_inst_vld),
    .fp12_observe (bus.ldc_lda_ex2_inst_vld)
  );
  assign bus.ctrl_ld_clk = bus.forever_cpuclk;
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
  task automatic tc_dc_ex1_ex2_owner();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.lag_ldc_ex1_inst_vld = '1;
    bus.lag0_ex1_iid = '1;
    tick(1);
    expect_known(^bus.ldc_lda_ex2_inst_vld, "tc_dc_ex1_ex2_owner");
  endtask
  task automatic tc_dc_borrow_owner();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.dcache_arb_ldc_borrow_vld = '1;
    bus.dcache_arb_ldc_borrow_vld_gate = '1;
    tick(1);
    expect_known(^bus.ldc_ex2_borrow_vld, "tc_dc_borrow_owner");
  endtask
  task automatic tc_dc_tag_way();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.lag_ldc_ex1_inst_vld = '1;
    bus.cp0_lsu_dcache_en = '1;
    bus.dcache_lsu_ld_tag_dout = '1;
    tick(1);
    expect_known(^bus.ldc_hit_way, "tc_dc_tag_way");
  endtask
  task automatic tc_dc_unit_stride_way();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.lag_ldc_ex1_inst_vld = '1;
    bus.lag_ldc_ex1_inst_us = '1;
    bus.lag_ldc_ex1_us_way = '1;
    tick(1);
    expect_known(^bus.ldc_lda_ex2_settle_way, "tc_dc_unit_stride_way");
  endtask
  task automatic tc_dc_byte_masks();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.lag_ldc_ex1_inst_vld = '1;
    bus.lag_ldc_ex1_bytes_vld = '1;
    bus.lag_ldc_ex1_bytes_vld1 = '1;
    bus.lag_ldc_ex1_bytes_vld2 = '1;
    bus.lag_ldc_ex1_bytes_vld3 = '1;
    tick(1);
    expect_known(^bus.ldc_lda_ex2_bytes_vld, "tc_dc_byte_masks");
  endtask
  task automatic tc_dc_lq_create();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.lag_ldc_ex1_inst_vld = '1;
    bus.lq_ldc_ex2_full = '1;
    bus.lq_ldc_create_entry = '1;
    tick(1);
    expect_known(^bus.ldc_lq_ex2_create_vld, "tc_dc_lq_create");
  endtask
  task automatic tc_dc_restart();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.lag_ldc_ex1_inst_vld = '1;
    bus.lq_ldc_ex2_full = '1;
    bus.mmu_lsu_tlb_busy = '1;
    tick(1);
    expect_known(^bus.ldc_lda_ex2_inst_vld, "tc_dc_restart");
  endtask
  task automatic tc_dc_exception();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.lag_ldc_ex1_inst_vld = '1;
    bus.lag_ldc_ex1_expt_vld = '1;
    bus.lag_ldc_ex1_expt_page_fault = '1;
    tick(1);
    expect_known(^bus.ldc_lda_ex2_expt_vld_except_access_err, "tc_dc_exception");
  endtask
  task automatic tc_dc_forward();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.lag_ldc_ex1_inst_vld = '1;
    bus.sq_ldc_ex2_fwd_req = '1;
    bus.wmb_ldc_fwd_req = '1;
    tick(1);
    expect_known(^bus.ldc_lda_ex2_fwd_sq_vld, "tc_dc_forward");
  endtask
  task automatic tc_dc_da_transfer();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.lag_ldc_ex1_inst_vld = '1;
    bus.lag0_ex1_iid = '1;
    bus.lag_ldc_ex1_addr0 = '1;
    tick(1);
    expect_known(^bus.ldc_lda_ex2_inst_vld, "tc_dc_da_transfer");
  endtask
  task automatic tc_dc_debug_pulse();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.lag_ldc_ex1_inst_vld = '1;
    bus.ld_ag_dtu_vld = '1;
    bus.ld_ag_dtu_va = '1;
    tick(1);
    expect_known(^bus.ld_dc_dtu_addr_vld, "tc_dc_debug_pulse");
  endtask
  task automatic tc_dc_clock_reset();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.lag_ldc_ex1_inst_vld = '1;
    bus.cp0_lsu_icg_en = '1;
    bus.pad_yy_icg_scan_en = '1;
    tick(1);
    expect_known(^bus.ldc_lda_ex2_inst_vld, "tc_dc_clock_reset");
  endtask
  string selected_test;
  initial begin
    if (!$value$plusargs("TEST=%s", selected_test)) selected_test = "tc_dc_ex1_ex2_owner";
    case (selected_test)
      "tc_dc_ex1_ex2_owner": tc_dc_ex1_ex2_owner();
      "tc_dc_borrow_owner": tc_dc_borrow_owner();
      "tc_dc_tag_way": tc_dc_tag_way();
      "tc_dc_unit_stride_way": tc_dc_unit_stride_way();
      "tc_dc_byte_masks": tc_dc_byte_masks();
      "tc_dc_lq_create": tc_dc_lq_create();
      "tc_dc_restart": tc_dc_restart();
      "tc_dc_exception": tc_dc_exception();
      "tc_dc_forward": tc_dc_forward();
      "tc_dc_da_transfer": tc_dc_da_transfer();
      "tc_dc_debug_pulse": tc_dc_debug_pulse();
      "tc_dc_clock_reset": tc_dc_clock_reset();
      default: $fatal(1, "unknown TEST=%s", selected_test);
    endcase
    $display("TEST_PASS %s static-harness execution", selected_test);
    $finish;
  end
endmodule
