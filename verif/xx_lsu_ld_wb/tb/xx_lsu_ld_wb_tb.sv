`timescale 1ns/1ps
`include "xx_lsu_ld_wb_if.sv"
module xx_lsu_ld_wb_tb;
  localparam int RBENTRY = 16;
  localparam int SQ_ENTRY = 12;
  localparam int VMB_ENTRY = 8;
  localparam int IID_WIDTH = 7;
  localparam int VREG = 6;
  localparam int PREG = 7;
  localparam int PREG_N = 96;
  xx_lsu_ld_wb_if #(
    .RBENTRY (RBENTRY),
    .SQ_ENTRY (SQ_ENTRY),
    .VMB_ENTRY (VMB_ENTRY),
    .IID_WIDTH (IID_WIDTH),
    .VREG (VREG),
    .PREG (PREG),
    .PREG_N (PREG_N)
  ) bus();
  xx_lsu_ld_wb #(
    .RBENTRY (RBENTRY),
    .SQ_ENTRY (SQ_ENTRY),
    .VMB_ENTRY (VMB_ENTRY),
    .IID_WIDTH (IID_WIDTH),
    .VREG (VREG),
    .PREG (PREG),
    .PREG_N (PREG_N)
  ) dut (
`include "xx_lsu_ld_wb_connect.svh"
  );
  xx_lsu_ld_wb_assertions checks (
    .clk (bus.forever_cpuclk),
    .reset_n (bus.cpurst_b),
    .fp01_qualify (bus.lda_lwb_ex3_cmplt_req),
    .fp01_observe (bus.lwb_rb_ex3_cmplt_grnt),
    .fp02_qualify (bus.lda_lwb_ex3_data_req),
    .fp02_observe (bus.lwb_ex4_data_vld),
    .fp03_qualify (bus.lda_lwb_ex3_data_req),
    .fp03_observe (bus.lwb_ex4_data_vld),
    .fp04_qualify (bus.lda_lwb_ex3_data_req),
    .fp04_observe (bus.lsu_idu_ex4_preg_vld),
    .fp05_qualify (bus.lda_lwb_ex3_data_req),
    .fp05_observe (bus.lsu_idu_ex4_vreg_vld),
    .fp06_qualify (bus.lda_lwb_ex3_cmplt_req),
    .fp06_observe (bus.lsu_rtu_ex4_cmplt),
    .fp07_qualify (bus.rb_lwb_ex3_data_req),
    .fp07_observe (bus.lsu_rtu_async_expt_vld),
    .fp08_qualify (bus.vmb_lwb_data_req),
    .fp08_observe (bus.ld_wb_vmb_data_grnt),
    .fp09_qualify (bus.rb_lwb_ex3_data_req),
    .fp09_observe (bus.rb_entry_data_halt_info_update_vld),
    .fp10_qualify (bus.lda_lwb_ex3_data_req),
    .fp10_observe (bus.lsu_idu_ex4_fwd_vreg_vld),
    .fp11_qualify (bus.lda_lwb_ex3_cmplt_req),
    .fp11_observe (bus.lwb_ex4_inst_vld),
    .fp12_qualify (bus.lda_lwb_ex3_data_req),
    .fp12_observe (bus.lwb_ex4_data_vld)
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
  task automatic tc_wb_completion_arb();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.lda_lwb_ex3_cmplt_req = '1;
    bus.rb_lwb_ex3_cmplt_req = '1;
    bus.lda_lwb_ex3_cmplt_req_gate = '1;
    tick(1);
    expect_known(^bus.lwb_rb_ex3_cmplt_grnt, "tc_wb_completion_arb");
  endtask
  task automatic tc_wb_data_arb();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.lda_lwb_ex3_data_req = '1;
    bus.wmb_lwb_data_req = '1;
    bus.vmb_lwb_data_req = '1;
    bus.rb_lwb_ex3_data_req = '1;
    tick(1);
    expect_known(^bus.lwb_ex4_data_vld, "tc_wb_data_arb");
  endtask
  task automatic tc_wb_req_contract();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.lda_lwb_ex3_data_req = '1;
    bus.lda_lwb_ex3_data_req_dp = '1;
    bus.lda_lwb_ex3_data_req_gateclk_en = '1;
    tick(1);
    expect_known(^bus.lwb_ex4_data_vld, "tc_wb_req_contract");
  endtask
  task automatic tc_wb_scalar();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.lda_lwb_ex3_data_req = '1;
    bus.lda_ex3_preg = '1;
    bus.lda_lwb_ex3_data = '1;
    bus.lda_lwb_ex3_preg_sign_sel = '1;
    tick(1);
    expect_known(^bus.lsu_idu_ex4_preg_vld, "tc_wb_scalar");
  endtask
  task automatic tc_wb_vector();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.lda_lwb_ex3_data_req = '1;
    bus.lda_ex3_inst_vfls = '1;
    bus.lda_ex3_vreg = '1;
    bus.lda_lwb_ex3_vreg_sign_sel = '1;
    tick(1);
    expect_known(^bus.lsu_idu_ex4_vreg_vld, "tc_wb_vector");
  endtask
  task automatic tc_wb_rtu();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.lda_lwb_ex3_cmplt_req = '1;
    bus.lda_ex3_iid = '1;
    bus.lda_lwb_ex3_expt_vld = '1;
    tick(1);
    expect_known(^bus.lsu_rtu_ex4_cmplt, "tc_wb_rtu");
  endtask
  task automatic tc_wb_bus_error();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.rb_lwb_ex3_data_req = '1;
    bus.rb_lwb_ex3_bus_err = '1;
    bus.rb_lwb_ex3_bus_err_addr = '1;
    tick(1);
    expect_known(^bus.lsu_rtu_async_expt_vld, "tc_wb_bus_error");
  endtask
  task automatic tc_wb_vmb();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.vmb_lwb_data_req = '1;
    bus.vmb_lwb_vmb_merge_vld = '1;
    bus.vmb_lwb_vreg = '1;
    bus.vmb_lwb_data = '1;
    tick(1);
    expect_known(^bus.ld_wb_vmb_data_grnt, "tc_wb_vmb");
  endtask
  task automatic tc_wb_debug();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.rb_lwb_ex3_data_req = '1;
    bus.rb_ld_wb_data_check = '1;
    bus.rb_ld_wb_data_halt_info = '1;
    tick(1);
    expect_known(^bus.rb_entry_data_halt_info_update_vld, "tc_wb_debug");
  endtask
  task automatic tc_wb_forward();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.lda_lwb_ex3_data_req = '1;
    bus.wmb_lwb_data_req = '1;
    bus.vmb_lwb_data_req = '1;
    bus.rb_lwb_ex3_data_req = '1;
    tick(1);
    expect_known(^bus.lsu_idu_ex4_fwd_vreg_vld, "tc_wb_forward");
  endtask
  task automatic tc_wb_flush();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.lda_lwb_ex3_cmplt_req = '1;
    bus.rtu_ck_flush = '1;
    bus.rtu_ck_flush_iid = '1;
    bus.lda_ex3_iid = '1;
    tick(1);
    expect_known(^bus.lwb_ex4_inst_vld, "tc_wb_flush");
  endtask
  task automatic tc_wb_clock_reset();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.lda_lwb_ex3_data_req = '1;
    bus.cp0_lsu_icg_en = '1;
    bus.pad_yy_icg_scan_en = '1;
    tick(1);
    expect_known(^bus.lwb_ex4_data_vld, "tc_wb_clock_reset");
  endtask
  string selected_test;
  initial begin
    if (!$value$plusargs("TEST=%s", selected_test)) selected_test = "tc_wb_completion_arb";
    case (selected_test)
      "tc_wb_completion_arb": tc_wb_completion_arb();
      "tc_wb_data_arb": tc_wb_data_arb();
      "tc_wb_req_contract": tc_wb_req_contract();
      "tc_wb_scalar": tc_wb_scalar();
      "tc_wb_vector": tc_wb_vector();
      "tc_wb_rtu": tc_wb_rtu();
      "tc_wb_bus_error": tc_wb_bus_error();
      "tc_wb_vmb": tc_wb_vmb();
      "tc_wb_debug": tc_wb_debug();
      "tc_wb_forward": tc_wb_forward();
      "tc_wb_flush": tc_wb_flush();
      "tc_wb_clock_reset": tc_wb_clock_reset();
      default: $fatal(1, "unknown TEST=%s", selected_test);
    endcase
    $display("TEST_PASS %s static-harness execution", selected_test);
    $finish;
  end
endmodule
