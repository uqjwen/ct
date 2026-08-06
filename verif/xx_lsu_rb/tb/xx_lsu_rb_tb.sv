`timescale 1ns/1ps
`include "xx_lsu_rb_if.sv"
module xx_lsu_rb_tb;
  localparam int IID_WIDTH = 7;
  localparam int PREG = 7;
  localparam int VREG = 7;
  localparam int VMBENTRY = 8;
  localparam int RBENTRY = 32;
  xx_lsu_rb_if #(
    .IID_WIDTH (IID_WIDTH),
    .PREG (PREG),
    .VREG (VREG),
    .VMBENTRY (VMBENTRY),
    .RBENTRY (RBENTRY)
  ) bus();
  xx_lsu_rb #(
    .IID_WIDTH (IID_WIDTH),
    .PREG (PREG),
    .VREG (VREG),
    .VMBENTRY (VMBENTRY),
    .RBENTRY (RBENTRY)
  ) dut (
`include "xx_lsu_rb_connect.svh"
  );
  xx_lsu_rb_assertions checks (
    .clk (bus.forever_cpuclk),
    .reset_n (bus.cpurst_b),
    .fp01_qualify (bus.lda0_rb_ex3_create_vld),
    .fp01_observe (bus.rb_lda0_ex3_full),
    .fp02_qualify (bus.lda0_rb_ex3_create_vld),
    .fp02_observe (bus.rb_lda0_ex3_full),
    .fp03_qualify (bus.lda0_rb_ex3_create_vld),
    .fp03_observe (bus.rb_biu_ar_req),
    .fp04_qualify (bus.lda0_rb_ex3_merge_vld),
    .fp04_observe (bus.rb_lda0_ex3_hit_idx),
    .fp05_qualify (bus.lda0_rb_ex3_create_vld),
    .fp05_observe (bus.rb_biu_ar_req),
    .fp06_qualify (bus.lda0_rb_ex3_create_vld),
    .fp06_observe (bus.rb_lfb_create_vld),
    .fp07_qualify (bus.biu_lsu_r_vld),
    .fp07_observe (bus.rb_lwb_ex3_data_req),
    .fp08_qualify (bus.biu_lsu_b_vld),
    .fp08_observe (bus.rb_lwb_ex3_cmplt_req),
    .fp09_qualify (bus.lda0_rb_ex3_create_vld),
    .fp09_observe (bus.rb_wmb_so_pending),
    .fp10_qualify (bus.lwb_rb_ex3_cmplt_grnt),
    .fp10_observe (bus.rb_lwb_ex3_cmplt_req),
    .fp11_qualify (bus.lda0_rb_ex3_create_vld),
    .fp11_observe (bus.rb_biu_ar_req),
    .fp12_qualify (bus.lda0_rb_ex3_create_vld),
    .fp12_observe (bus.rb_empty)
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
  task automatic tc_rb_capacity();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.lda0_rb_ex3_create_vld = '1;
    bus.lda0_rb_ex3_create_judge_vld = '1;
    bus.lda0_ex3_iid = '1;
    tick(1);
    expect_known(^bus.rb_lda0_ex3_full, "tc_rb_capacity");
  endtask
  task automatic tc_rb_create_arb();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.lda0_rb_ex3_create_vld = '1;
    bus.lsda0_rb_ex3_create_vld = '1;
    bus.lsda1_rb_ex3_create_vld = '1;
    tick(1);
    expect_known(^bus.rb_lda0_ex3_full, "tc_rb_create_arb");
  endtask
  task automatic tc_rb_entry_lifecycle();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.lda0_rb_ex3_create_vld = '1;
    bus.bus_arb_rb_ar_grnt = '1;
    bus.biu_lsu_r_vld = '1;
    tick(1);
    expect_known(^bus.rb_biu_ar_req, "tc_rb_entry_lifecycle");
  endtask
  task automatic tc_rb_merge();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.lda0_rb_ex3_merge_vld = '1;
    bus.lda0_ex3_boundary_after_mask = '1;
    bus.lda0_ex3_addr = '1;
    tick(1);
    expect_known(^bus.rb_lda0_ex3_hit_idx, "tc_rb_merge");
  endtask
  task automatic tc_rb_biu_ar();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.lda0_rb_ex3_create_vld = '1;
    bus.bus_arb_rb_ar_grnt = '1;
    bus.lfb_addr_full = '1;
    tick(1);
    expect_known(^bus.rb_biu_ar_req, "tc_rb_biu_ar");
  endtask
  task automatic tc_rb_lfb_create();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.lda0_rb_ex3_create_vld = '1;
    bus.lda0_rb_ex3_create_lfb = '1;
    bus.lfb_rb_create_id = '1;
    tick(1);
    expect_known(^bus.rb_lfb_create_vld, "tc_rb_lfb_create");
  endtask
  task automatic tc_rb_r_response();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.biu_lsu_r_vld = '1;
    bus.biu_lsu_r_id = '1;
    bus.biu_lsu_r_resp = '1;
    bus.biu_lsu_r_data = '1;
    tick(1);
    expect_known(^bus.rb_lwb_ex3_data_req, "tc_rb_r_response");
  endtask
  task automatic tc_rb_b_response();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.biu_lsu_b_vld = '1;
    bus.biu_lsu_b_id = '1;
    bus.lda0_rb_ex3_atomic = '1;
    tick(1);
    expect_known(^bus.rb_lwb_ex3_cmplt_req, "tc_rb_b_response");
  endtask
  task automatic tc_rb_so_fifo();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.lda0_rb_ex3_create_vld = '1;
    bus.lda0_ex3_page_so = '1;
    bus.biu_lsu_r_vld = '1;
    tick(1);
    expect_known(^bus.rb_wmb_so_pending, "tc_rb_so_fifo");
  endtask
  task automatic tc_rb_wb();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.lwb_rb_ex3_cmplt_grnt = '1;
    bus.lwb_rb_ex3_data_grnt = '1;
    bus.biu_lsu_r_vld = '1;
    tick(1);
    expect_known(^bus.rb_lwb_ex3_cmplt_req, "tc_rb_wb");
  endtask
  task automatic tc_rb_flush();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.lda0_rb_ex3_create_vld = '1;
    bus.rtu_yy_xx_flush = '1;
    bus.rtu_lsu_async_flush = '1;
    tick(1);
    expect_known(^bus.rb_biu_ar_req, "tc_rb_flush");
  endtask
  task automatic tc_rb_clock_reset();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.lda0_rb_ex3_create_vld = '1;
    bus.cp0_lsu_icg_en = '1;
    bus.pad_yy_icg_scan_en = '1;
    tick(1);
    expect_known(^bus.rb_empty, "tc_rb_clock_reset");
  endtask
  string selected_test;
  initial begin
    if (!$value$plusargs("TEST=%s", selected_test)) selected_test = "tc_rb_capacity";
    case (selected_test)
      "tc_rb_capacity": tc_rb_capacity();
      "tc_rb_create_arb": tc_rb_create_arb();
      "tc_rb_entry_lifecycle": tc_rb_entry_lifecycle();
      "tc_rb_merge": tc_rb_merge();
      "tc_rb_biu_ar": tc_rb_biu_ar();
      "tc_rb_lfb_create": tc_rb_lfb_create();
      "tc_rb_r_response": tc_rb_r_response();
      "tc_rb_b_response": tc_rb_b_response();
      "tc_rb_so_fifo": tc_rb_so_fifo();
      "tc_rb_wb": tc_rb_wb();
      "tc_rb_flush": tc_rb_flush();
      "tc_rb_clock_reset": tc_rb_clock_reset();
      default: $fatal(1, "unknown TEST=%s", selected_test);
    endcase
    $display("TEST_PASS %s static-harness execution", selected_test);
    $finish;
  end
endmodule
