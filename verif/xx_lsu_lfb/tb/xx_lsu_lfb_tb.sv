`timescale 1ns/1ps
`include "xx_lsu_lfb_if.sv"
module xx_lsu_lfb_tb;
  localparam int LSIQ_ENTRY = 12;
  localparam int LFB_ADDR_ENTRY = 16;
  localparam int LFB_DATA_ENTRY = 2;
  localparam int BIU_LFB_ID_T = 0;
  localparam int OKAY = 0;
  localparam int EXOKAY = 1;
  localparam int SLVERR = 2;
  localparam int DECERR = 3;
  xx_lsu_lfb_if #(
    .LSIQ_ENTRY (LSIQ_ENTRY),
    .LFB_ADDR_ENTRY (LFB_ADDR_ENTRY),
    .LFB_DATA_ENTRY (LFB_DATA_ENTRY),
    .BIU_LFB_ID_T (BIU_LFB_ID_T),
    .OKAY (OKAY),
    .EXOKAY (EXOKAY),
    .SLVERR (SLVERR),
    .DECERR (DECERR)
  ) bus();
  xx_lsu_lfb #(
    .LSIQ_ENTRY (LSIQ_ENTRY),
    .LFB_ADDR_ENTRY (LFB_ADDR_ENTRY),
    .LFB_DATA_ENTRY (LFB_DATA_ENTRY),
    .BIU_LFB_ID_T (BIU_LFB_ID_T),
    .OKAY (OKAY),
    .EXOKAY (EXOKAY),
    .SLVERR (SLVERR),
    .DECERR (DECERR)
  ) dut (
`include "xx_lsu_lfb_connect.svh"
  );
  xx_lsu_lfb_assertions checks (
    .clk (bus.forever_cpuclk),
    .reset_n (bus.cpurst_b),
    .fp01_qualify (bus.rb_lfb_create_vld),
    .fp01_observe (bus.lfb_rb_create_id),
    .fp02_qualify (bus.rb_lfb_create_vld),
    .fp02_observe (bus.lsu_had_lfb_addr_entry_vld),
    .fp03_qualify (bus.rb_lfb_create_req),
    .fp03_observe (bus.lfb_rb_biu_req_hit_idx),
    .fp04_qualify (bus.biu_lsu_r_vld),
    .fp04_observe (bus.lsu_had_lfb_data_entry_vld),
    .fp05_qualify (bus.biu_lsu_r_vld),
    .fp05_observe (bus.lsu_biu_r_linefill_ready),
    .fp06_qualify (bus.vb_lfb_create_grnt),
    .fp06_observe (bus.lfb_vb_create_vld),
    .fp07_qualify (bus.dcache_arb_lfb_ld_grnt),
    .fp07_observe (bus.lfb_dcache_arb_ld_data_req),
    .fp08_qualify (bus.biu_lsu_r_vld),
    .fp08_observe (bus.lfb_rb_nc_empty),
    .fp09_qualify (bus.rb_lfb_depd),
    .fp09_observe (bus.lfb_mcic_wakeup),
    .fp10_qualify (bus.snq_lfb_vb_req_hit_idx),
    .fp10_observe (bus.lfb_snq_bypass_hit),
    .fp11_qualify (bus.rb_lfb_create_vld),
    .fp11_observe (bus.lfb_dcache_arb_ld_req),
    .fp12_qualify (bus.rb_lfb_create_vld),
    .fp12_observe (bus.lfb_addr_full),
    .fp13_qualify (bus.rb_lfb_create_vld),
    .fp13_observe (bus.lfb_empty)
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
  task automatic tc_lfb_allocate();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.rb_lfb_create_vld = '1;
    bus.pfu_lfb_create_vld = '1;
    bus.rb_biu_req_addr = '1;
    tick(1);
    expect_known(^bus.lfb_rb_create_id, "tc_lfb_allocate");
  endtask
  task automatic tc_lfb_addr_lifecycle();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.rb_lfb_create_vld = '1;
    bus.biu_lsu_r_vld = '1;
    bus.biu_lsu_r_last = '1;
    tick(1);
    expect_known(^bus.lsu_had_lfb_addr_entry_vld, "tc_lfb_addr_lifecycle");
  endtask
  task automatic tc_lfb_address_hit();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.rb_lfb_create_req = '1;
    bus.pfu_lfb_create_req = '1;
    bus.wmb_read_req_addr = '1;
    tick(1);
    expect_known(^bus.lfb_rb_biu_req_hit_idx, "tc_lfb_address_hit");
  endtask
  task automatic tc_lfb_data_binding();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.biu_lsu_r_vld = '1;
    bus.biu_lsu_r_id = '1;
    bus.biu_lsu_r_data = '1;
    tick(1);
    expect_known(^bus.lsu_had_lfb_data_entry_vld, "tc_lfb_data_binding");
  endtask
  task automatic tc_lfb_biu_response();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.biu_lsu_r_vld = '1;
    bus.biu_lsu_r_id = '1;
    bus.biu_lsu_r_last = '1;
    bus.biu_lsu_r_resp = '1;
    tick(1);
    expect_known(^bus.lsu_biu_r_linefill_ready, "tc_lfb_biu_response");
  endtask
  task automatic tc_lfb_vb();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.vb_lfb_create_grnt = '1;
    bus.vb_lfb_dcache_hit = '1;
    bus.vb_lfb_dcache_dirty = '1;
    bus.vb_lfb_dcache_way = '1;
    tick(1);
    expect_known(^bus.lfb_vb_create_vld, "tc_lfb_vb");
  endtask
  task automatic tc_lfb_refill();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.dcache_arb_lfb_ld_grnt = '1;
    bus.biu_lsu_r_data = '1;
    bus.cp0_lsu_dcache_en = '1;
    tick(1);
    expect_known(^bus.lfb_dcache_arb_ld_data_req, "tc_lfb_refill");
  endtask
  task automatic tc_lfb_all_response();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.biu_lsu_r_vld = '1;
    bus.biu_lsu_r_last = '1;
    bus.rb_lfb_page_ca = '1;
    tick(1);
    expect_known(^bus.lfb_rb_nc_empty, "tc_lfb_all_response");
  endtask
  task automatic tc_lfb_dependency();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.rb_lfb_depd = '1;
    bus.rb_lfb_create_vld = '1;
    bus.lm_already_snoop = '1;
    tick(1);
    expect_known(^bus.lfb_mcic_wakeup, "tc_lfb_dependency");
  endtask
  task automatic tc_lfb_snq_bypass();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.snq_lfb_vb_req_hit_idx = '1;
    bus.snq_bypass_addr_tto6 = '1;
    bus.snq_lfb_bypass_invalid = '1;
    tick(1);
    expect_known(^bus.lfb_snq_bypass_hit, "tc_lfb_snq_bypass");
  endtask
  task automatic tc_lfb_flush();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.rb_lfb_create_vld = '1;
    bus.rtu_yy_xx_flush = '1;
    bus.rtu_ck_flush = '1;
    bus.biu_lsu_r_vld = '1;
    tick(1);
    expect_known(^bus.lfb_dcache_arb_ld_req, "tc_lfb_flush");
  endtask
  task automatic tc_lfb_capacity();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.rb_lfb_create_vld = '1;
    bus.pfu_lfb_create_vld = '1;
    bus.biu_lsu_r_last = '1;
    tick(1);
    expect_known(^bus.lfb_addr_full, "tc_lfb_capacity");
  endtask
  task automatic tc_lfb_clock_reset();
    apply_reset();
    @(negedge bus.forever_cpuclk);
    bus.rb_lfb_create_vld = '1;
    bus.cp0_lsu_icg_en = '1;
    bus.pad_yy_icg_scan_en = '1;
    tick(1);
    expect_known(^bus.lfb_empty, "tc_lfb_clock_reset");
  endtask
  string selected_test;
  initial begin
    if (!$value$plusargs("TEST=%s", selected_test)) selected_test = "tc_lfb_allocate";
    case (selected_test)
      "tc_lfb_allocate": tc_lfb_allocate();
      "tc_lfb_addr_lifecycle": tc_lfb_addr_lifecycle();
      "tc_lfb_address_hit": tc_lfb_address_hit();
      "tc_lfb_data_binding": tc_lfb_data_binding();
      "tc_lfb_biu_response": tc_lfb_biu_response();
      "tc_lfb_vb": tc_lfb_vb();
      "tc_lfb_refill": tc_lfb_refill();
      "tc_lfb_all_response": tc_lfb_all_response();
      "tc_lfb_dependency": tc_lfb_dependency();
      "tc_lfb_snq_bypass": tc_lfb_snq_bypass();
      "tc_lfb_flush": tc_lfb_flush();
      "tc_lfb_capacity": tc_lfb_capacity();
      "tc_lfb_clock_reset": tc_lfb_clock_reset();
      default: $fatal(1, "unknown TEST=%s", selected_test);
    endcase
    $display("TEST_PASS %s static-harness execution", selected_test);
    $finish;
  end
endmodule
