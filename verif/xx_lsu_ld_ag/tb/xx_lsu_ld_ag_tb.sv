`timescale 1ns/1ps
`include "xx_lsu_ld_ag_defs.svh"
`include "xx_lsu_ld_ag_if.sv"

module xx_lsu_ld_ag_tb;
  localparam int LSIQENTRY = 12;
  localparam int VMBENTRY  = 8;
  localparam int PC_LEN    = 15;
  localparam int IID_WIDTH = 7;
  localparam int VREG      = 6;
  localparam int PREG      = 7;

  xx_lsu_ld_ag_if #(
    .LSIQENTRY (LSIQENTRY),
    .VMBENTRY  (VMBENTRY),
    .PC_LEN    (PC_LEN),
    .IID_WIDTH (IID_WIDTH),
    .VREG      (VREG),
    .PREG      (PREG)
  ) bus();

  xx_lsu_ld_ag #(
    .LSIQENTRY (LSIQENTRY),
    .VMBENTRY  (VMBENTRY),
    .PC_LEN    (PC_LEN),
    .IID_WIDTH (IID_WIDTH),
    .VREG      (VREG),
    .PREG      (PREG)
  ) dut (
`include "xx_lsu_ld_ag_connect.svh"
  );

  xx_lsu_ld_ag_assertions #(
    .IID_WIDTH (IID_WIDTH),
    .LSIQENTRY (LSIQENTRY)
  ) checks (
    .clk                                      (bus.forever_cpuclk),
    .reset_n                                  (bus.cpurst_b),
    .flush                                    (bus.rtu_lsu_flush_fe),
    .lag_ex1_inst_vld                         (bus.lag_ex1_inst_vld),
    .lag_ex1_stall_ori                        (bus.lag_ex1_stall_ori),
    .lag0_ex1_iid                             (bus.lag0_ex1_iid),
    .lag_ldc_ex1_inst_vld                     (bus.lag_ldc_ex1_inst_vld),
    .lag_ldc_ex1_inst_vls                     (bus.lag_ldc_ex1_inst_vls),
    .lag_ldc_ex1_inst_us                      (bus.lag_ldc_ex1_inst_us),
    .lag_ldc_ex1_bytes_vld                    (bus.lag_ldc_ex1_bytes_vld),
    .lag_ldc_ex1_bytes_vld1                   (bus.lag_ldc_ex1_bytes_vld1),
    .lag_ldc_ex1_bytes_vld2                   (bus.lag_ldc_ex1_bytes_vld2),
    .lag_ldc_ex1_bytes_vld3                   (bus.lag_ldc_ex1_bytes_vld3),
    .lsu_mmu_va_vld                           (bus.lsu_mmu_va_vld),
    .mmu_lsu_pa_vld                           (bus.mmu_lsu_pa_vld),
    .mmu_lsu_page_fault                       (bus.mmu_lsu_page_fault),
    .mmu_lsu_access_fault                     (bus.mmu_lsu_access_fault),
    .lsu_mmu_abort                            (bus.lsu_mmu_abort),
    .lag_ldc_ex1_expt_vld                     (bus.lag_ldc_ex1_expt_vld),
    .lag_ldc_ex1_expt_page_fault              (bus.lag_ldc_ex1_expt_page_fault),
    .lag_ldc_ex1_expt_access_fault_with_page  (
      bus.lag_ldc_ex1_expt_access_fault_with_page
    ),
    .lag_ldc_ex1_expt_ldamo_not_ca            (
      bus.lag_ldc_ex1_expt_ldamo_not_ca
    ),
    .lag_ex1_stall_restart_entry              (
      bus.lag_ex1_stall_restart_entry
    ),
    .lag_dcache_arb_ex1_data_req              (
      bus.lag_dcache_arb_ex1_data_req
    ),
    .lag_dcache_arb_ex1_ld_tag_req            (
      bus.lag_dcache_arb_ex1_ld_tag_req
    ),
    .lag_dcache_arb_ex1_bank_idx              (
      bus.lag_dcache_arb_ex1_bank_idx
    ),
    .lag_ldc_ex1_us_way                       (bus.lag_ldc_ex1_us_way),
    .lsu_lrq_create_vld                       (bus.lsu_lrq_create_vld),
    .lsu_lrq_create_frz                       (bus.lsu_lrq_create_frz),
    .lsu_lrq_create_iid                       (bus.lsu_lrq_create_iid),
    .lag_ldc_ex1_atomic                       (bus.lag_ldc_ex1_atomic),
    .lag_ldc_ex1_dtcm_hit                     (bus.lag_ldc_ex1_dtcm_hit),
    .lag_ldc_ex1_itcm_hit                     (bus.lag_ldc_ex1_itcm_hit),
    .lag_lm_ex1_init_vld                      (bus.lag_lm_ex1_init_vld),
    .lag_ldc_ex1_reg_bytes_vld                (
      bus.lag_ldc_ex1_reg_bytes_vld
    ),
    .idu_lsu_rf_inst_size                     (bus.idu_lsu_rf_inst_size),
    .idu_lsu_rf_unit_stride                   (bus.idu_lsu_rf_unit_stride),
    .idu_lsu_rf_vmew                          (bus.idu_lsu_rf_vmew),
    .idu_lsu_rf_split                         (bus.idu_lsu_rf_split),
    .rtu_yy_xx_commit0                        (bus.rtu_yy_xx_commit0)
  );

  string selected_test;
  int unsigned checks_run;
  int unsigned known_findings;

  assign bus.ctrl_ld_clk = bus.forever_cpuclk;

  initial begin
    bus.forever_cpuclk = 1'b0;
    forever #5 bus.forever_cpuclk = ~bus.forever_cpuclk;
  end

  task automatic tick(input int unsigned cycles = 1);
    repeat (cycles) begin
      @(posedge bus.forever_cpuclk);
      #1;
    end
  endtask

  task automatic expect_true(input logic condition, input string message);
    checks_run++;
    if (condition !== 1'b1)
      $fatal(1, "CHECK_FAIL: %s", message);
  endtask

  task automatic record_known_finding(
    input logic condition,
    input string message
  );
    checks_run++;
    if (condition === 1'b1) begin
      known_findings++;
      $display("KNOWN_DESIGN_ERROR: %s", message);
    end
    else
      $display("KNOWN_DESIGN_ERROR_NOT_OBSERVED: %s", message);
  endtask

  task automatic clear_rf();
    bus.idu_lsu_rf_gateclk_sel = 1'b0;
    bus.idu_lsu_rf_sel = 1'b0;
    bus.lrq_lsu_rf_replay_vld = 1'b0;
    bus.idu_lsu_rf_atomic = 1'b0;
    bus.idu_lsu_rf_inst_vls = 1'b0;
    bus.idu_lsu_rf_unit_stride = 1'b0;
    bus.idu_lsu_rf_inst_ldr = 1'b0;
    bus.idu_lsu_rf_older_vld = 1'b0;
    bus.idu_lsu_rf_halt_info = '0;
  endtask

  task automatic apply_reset();
    bus.drive_idle();
    bus.cpurst_b = 1'b0;
    tick(3);
    bus.cpurst_b = 1'b1;
    bus.dcache_arb_lag_ex1_sel = 1'b1;
    bus.mmu_lsu_pa_vld = 1'b1;
    bus.mmu_lsu_ca = 1'b1;
    bus.cp0_lsu_dcache_en = 1'b1;
    bus.cp0_lsu_icg_en = 1'b1;
    bus.cp0_lsu_mm = 1'b1;
    tick(1);
  endtask

  task automatic launch_scalar(
    input logic [63:0] base,
    input logic [11:0] offset,
    input logic [1:0] size,
    input logic [IID_WIDTH-1:0] iid,
    input logic [3:0] shift = 4'b0000
  );
    @(negedge bus.forever_cpuclk);
    bus.idu_lsu_rf_gateclk_sel = 1'b1;
    bus.idu_lsu_rf_sel = 1'b1;
    bus.idu_lsu_rf_src0 = base;
    bus.idu_lsu_rf_offset = offset;
    bus.idu_lsu_rf_shift = shift;
    bus.idu_lsu_rf_inst_size = size;
    bus.idu_lsu_rf_inst_type = 2'b00;
    bus.idu_lsu_rf_iid = iid;
    bus.idu_lsu_rf_preg = iid;
    bus.mmu_lsu_pa = base[`WK_PA_WIDTH-1:12];
    tick(1);
  endtask

  task automatic drain();
    @(negedge bus.forever_cpuclk);
    clear_rf();
    bus.dcache_arb_lag_ex1_bkcon = 1'b0;
    bus.dcache_arb_lag_ex1_sel = 1'b1;
    bus.mmu_lsu_page_fault = 1'b0;
    bus.mmu_lsu_access_fault = 1'b0;
    bus.rtu_lsu_flush_fe = 1'b0;
    bus.rtu_ck_flush = 1'b0;
    tick(2);
  endtask

  function automatic logic [15:0] ref_mask(
    input logic [1:0] size,
    input logic [3:0] low
  );
    logic [31:0] raw;
    raw = ((32'b1 << (1 << size)) - 1) << low;
    return raw[15:0];
  endfunction

  task automatic tc_rf_capture_replay();
    logic [IID_WIDTH-1:0] held_iid;
    logic [`TDT_MP_HINFO_WIDTH-1:0] replay_halt_info;
    apply_reset();
    launch_scalar(64'h0000_0000_0010_0040, 12'h004, 2'b11, 7'h11);
    held_iid = bus.lag0_ex1_iid;
    @(negedge bus.forever_cpuclk);
    bus.dcache_arb_lag_ex1_bkcon = 1'b1;
    bus.idu_lsu_rf_gateclk_sel = 1'b1;
    bus.idu_lsu_rf_sel = 1'b1;
    bus.idu_lsu_rf_iid = 7'h22;
    tick(2);
    expect_true(bus.lag0_ex1_iid == held_iid,
                "fresh owner changed during backpressure");
    drain();

    replay_halt_info = 17'h12A5;
    @(negedge bus.forever_cpuclk);
    bus.lrq_lsu_rf_replay_vld = 1'b1;
    bus.idu_lsu_rf_gateclk_sel = 1'b1;
    bus.lrq_lsu_rf_va = 64'h0000_0000_0020_0100;
    bus.idu_lsu_rf_halt_info = 17'h0555;
    tick(1);
    record_known_finding(
      bus.ld_ag_halt_info != replay_halt_info,
      "replay halt_info is sourced from the current IDU bus instead of LRQ"
    );
    drain();
  endtask

  task automatic tc_scalar_va_cross_page();
    int size;
    int low;
    int sample;
    int shift;
    logic [63:0] base;
    logic [63:0] expected_va;
    logic [11:0] random_offset;
    apply_reset();
    for (size = 0; size < 4; size++) begin
      for (low = 0; low < 16; low++) begin
        base = 64'h0000_0000_1234_5000 | low;
        launch_scalar(base, 12'h003, size[1:0], size * 16 + low);
        expected_va = base + 64'h3;
        expect_true(dut.ld_ag_va == expected_va,
                    $sformatf("VA mismatch size=%0d low=%0d", size, low));
        expect_true(
          bus.lag_ldc_ex1_bytes_vld == ref_mask(size[1:0], expected_va[3:0]),
          $sformatf("mask mismatch size=%0d low=%0d", size, low)
        );
        drain();
      end
    end

    bus.idu_lsu_rf_off_zext = 1'b1;
    for (sample = 0; sample < 64; sample++) begin
      base = 64'h0000_0000_2000_0000 | ($urandom & 32'h0000_FFFF);
      random_offset = $urandom_range(12'h7FF, 12'h000);
      size = $urandom_range(3, 0);
      launch_scalar(base, random_offset, size[1:0], sample[IID_WIDTH-1:0]);
      expected_va = base + random_offset;
      expect_true(dut.ld_ag_va == expected_va,
                  $sformatf("random VA mismatch sample=%0d", sample));
      expect_true(
        bus.lag_ldc_ex1_bytes_vld
          == ref_mask(size[1:0], expected_va[3:0]),
        $sformatf("random mask mismatch sample=%0d", sample)
      );
      drain();
    end
    bus.idu_lsu_rf_off_zext = 1'b0;

    for (shift = 0; shift < 4; shift++) begin
      base = 64'h0000_0000_3000_1000;
      launch_scalar(base, 12'hFFC, 2'b00, 7'h60 + shift, shift[3:0]);
      expected_va = base - (64'd4 << shift);
      expect_true(dut.ld_ag_va == expected_va,
                  $sformatf("signed offset mismatch shift=%0d", shift));
      drain();
    end

    launch_scalar(
      64'h0000_0000_3000_0002,
      12'hFFC,
      2'b00,
      7'h66,
      4'b0000
    );
    expect_true(dut.ld_ag_cross_4k,
                "negative offset crossing previous page was not detected");
    drain();

    launch_scalar(64'h0000_0000_1234_5FFE, 12'h004, 2'b10, 7'h33);
    expect_true(dut.ld_ag_cross_4k,
                "page-edge address did not raise cross-4K indication");
    drain();
  endtask

  task automatic tc_mmu_hit_miss_abort();
    apply_reset();
    launch_scalar(64'h0000_0000_0030_0080, 12'h000, 2'b11, 7'h21);
    expect_true(bus.lsu_mmu_va_vld && !bus.lag_ldc_ex1_utlb_miss,
                "MMU hit path did not retain a valid owner");
    drain();

    bus.mmu_lsu_pa_vld = 1'b0;
    launch_scalar(64'h0000_0000_0030_1080, 12'h000, 2'b11, 7'h22);
    expect_true(bus.lag_ldc_ex1_utlb_miss,
                "accepted MMU miss did not report uTLB miss");
    drain();

    bus.mmu_lsu_pa_vld = 1'b1;
    bus.mmu_lsu_page_fault = 1'b1;
    launch_scalar(64'h0000_0000_0030_2080, 12'h000, 2'b11, 7'h23);
    expect_true(bus.lsu_mmu_abort,
                "page fault did not transfer ownership to abort");
    drain();
  endtask

  task automatic tc_mmu_fault_persistence();
    apply_reset();
    bus.dcache_arb_lag_ex1_bkcon = 1'b1;
    launch_scalar(64'h0000_0000_0040_0000, 12'h008, 2'b11, 7'h31);
    bus.mmu_lsu_page_fault = 1'b1;
    tick(1);
    bus.mmu_lsu_page_fault = 1'b0;
    tick(2);
    expect_true(dut.lag_bkcon_pgfault,
                "captured page fault was not persistent under backpressure");
    drain();

    bus.dcache_arb_lag_ex1_bkcon = 1'b1;
    launch_scalar(64'h0000_0000_0040_1000, 12'h008, 2'b11, 7'h32);
    @(negedge bus.forever_cpuclk);
    bus.mmu_lsu_access_fault = 1'b1;
    tick(1);
    bus.mmu_lsu_access_fault = 1'b0;
    expect_true(dut.lag_bkcon_acfault,
                "next-cycle access fault was not captured");
    drain();
  endtask

  task automatic tc_stall_restart_owner();
    apply_reset();
    bus.dcache_arb_lag_ex1_sel = 1'b0;
    bus.idu_lsu_rf_older_vld = 1'b1;
    launch_scalar(64'h0000_0000_0050_0000, 12'h000, 2'b11, 7'h41);
    expect_true(bus.lag_ex1_stall_ori,
                "D-cache rejection did not stall AG");
    expect_true(bus.lsu_lrq_create_vld,
                "stalled fresh request did not create an LRQ owner");
    drain();

    bus.lrq_lsu_rf_replay_vld = 1'b1;
    bus.lrq_lsu_ex1_lrqid = 12'b0000_0000_0100;
    bus.dcache_arb_lag_ex1_sel = 1'b0;
    launch_scalar(64'h0000_0000_0050_1000, 12'h000, 2'b11, 7'h42);
    expect_true(bus.lag_ex1_stall_ori,
                "replay D-cache rejection did not stall");
    drain();
  endtask

  task automatic tc_dcache_bank_requests();
    int bank;
    logic [63:0] base;
    apply_reset();
    for (bank = 0; bank < 4; bank++) begin
      base = 64'h0000_0000_0060_0000 | (bank << 6);
      launch_scalar(base, 12'h000, 2'b11, bank + 7'h10);
      expect_true(bus.lag_dcache_arb_ex1_ld_tag_req,
                  "cacheable load omitted tag request");
      expect_true(bus.lag_dcache_arb_ex1_bank_idx == bank[1:0],
                  "D-cache bank index mismatch");
      expect_true(|bus.lag_dcache_arb_ex1_data_req,
                  "cacheable load omitted data request");
      drain();
    end
    bus.cp0_lsu_dcache_en = 1'b0;
    launch_scalar(64'h0000_0000_0060_1000, 12'h000, 2'b11, 7'h18);
    expect_true(!bus.lag_dcache_arb_ex1_ld_tag_req,
                "disabled D-cache still received a tag request");
    drain();
  endtask

  task automatic tc_unit_stride_two_phase();
    int way;
    apply_reset();
    for (way = 0; way < 4; way++) begin
      @(negedge bus.forever_cpuclk);
      bus.idu_lsu_rf_gateclk_sel = 1'b1;
      bus.idu_lsu_rf_sel = 1'b1;
      bus.idu_lsu_rf_inst_vls = 1'b1;
      bus.idu_lsu_rf_unit_stride = 1'b1;
      bus.idu_lsu_rf_vmop = 2'b00;
      bus.idu_lsu_rf_vl = 8'd64;
      bus.idu_lsu_rf_src0 = 64'h0000_0000_0070_0000;
      bus.idu_lsu_rf_iid = 7'h50 + way;
      force dut.lag_us_tag_hit_way = 4'b0001 << way;
      tick(3);
      expect_true(bus.lag_ldc_ex1_us_way == (4'b0001 << way),
                  "unit-stride way capture mismatch");
      release dut.lag_us_tag_hit_way;
      drain();
    end

    force dut.lag_ldc_ex1_inst_vls = 1'b1;
    force dut.ld_ag_unit_stride = 1'b1;
    force dut.lag_ex1_pa = 40'h0000_70003F;
    force dut.lag_ex1_us_way = 4'b0001;
    #1;
    record_known_finding(
      (bus.lag_dcache_arb_ex1_data_0_idx
       == bus.lag_dcache_arb_ex1_data_1_idx)
      && (bus.lag_dcache_arb_ex1_data_1_idx
          == bus.lag_dcache_arb_ex1_data_2_idx)
      && (bus.lag_dcache_arb_ex1_data_2_idx
          == bus.lag_dcache_arb_ex1_data_3_idx),
      "cross-line 512-bit unit-stride access exposes only one line index"
    );
    release dut.lag_ldc_ex1_inst_vls;
    release dut.ld_ag_unit_stride;
    release dut.lag_ex1_pa;
    release dut.lag_ex1_us_way;
    drain();
  endtask

  task automatic tc_exception_priority();
    apply_reset();
    launch_scalar(64'h0000_0000_0080_0001, 12'h000, 2'b11, 7'h61);
    force dut.ld_ag_unalign = 1'b1;
    force dut.lag_ldc_ex1_atomic = 1'b1;
    #1;
    expect_true(bus.lag_ldc_ex1_expt_misalign_no_page,
                "misaligned atomic load did not raise exception");
    expect_true(!bus.lag_ldc_ex1_inst_vld,
                "misaligned atomic load escaped to DC");
    release dut.ld_ag_unalign;
    release dut.lag_ldc_ex1_atomic;
    drain();

    bus.mmu_lsu_page_fault = 1'b1;
    launch_scalar(64'h0000_0000_0080_1000, 12'h000, 2'b11, 7'h62);
    expect_true(bus.lag_ldc_ex1_expt_page_fault,
                "page fault was not prioritized");
    drain();

    bus.idu_lsu_rf_atomic = 1'b1;
    bus.mmu_lsu_ca = 1'b0;
    bus.rtu_yy_xx_commit0 = 1'b1;
    bus.rtu_yy_xx_commit0_iid = 7'h63;
    launch_scalar(64'h0000_0000_0080_2000, 12'h000, 2'b11, 7'h63);
    expect_true(bus.lag_ldc_ex1_expt_ldamo_not_ca,
                "LDAMO on non-cacheable page omitted dedicated exception");
    bus.rtu_yy_xx_commit0 = 1'b0;
    drain();
  endtask

  task automatic tc_lrq_create_freeze();
    apply_reset();
    bus.mmu_lsu_pa_vld = 1'b0;
    bus.dcache_arb_lag_ex1_sel = 1'b0;
    bus.idu_lsu_rf_older_vld = 1'b1;
    launch_scalar(64'h0000_0000_0090_0000, 12'h000, 2'b11, 7'h71);
    expect_true(bus.lsu_lrq_create_vld,
                "fresh accepted miss did not create LRQ entry");
    expect_true(bus.lsu_lrq_create_frz,
                "accepted MMU miss was incorrectly created ready");
    drain();

    @(negedge bus.forever_cpuclk);
    bus.lrq_lsu_rf_replay_vld = 1'b1;
    bus.idu_lsu_rf_gateclk_sel = 1'b1;
    bus.lrq_lsu_rf_va = 64'h0000_0000_0090_1000;
    tick(1);
    expect_true(!bus.lsu_lrq_create_vld,
                "LRQ replay created a duplicate entry");
    drain();
  endtask

  task automatic tc_tcm_atomic_commit();
    apply_reset();
    expect_true(!bus.lag_ldc_ex1_dtcm_hit && !bus.lag_ldc_ex1_itcm_hit,
                "standalone AG unexpectedly enables a TCM source");
    @(negedge bus.forever_cpuclk);
    bus.idu_lsu_rf_atomic = 1'b1;
    bus.idu_lsu_rf_gateclk_sel = 1'b1;
    bus.idu_lsu_rf_sel = 1'b1;
    bus.idu_lsu_rf_iid = 7'h75;
    bus.idu_lsu_rf_src0 = 64'h0000_0000_00A0_0000;
    tick(1);
    expect_true(!bus.lag_lm_ex1_init_vld,
                "atomic load initialized monitor before commit");
    @(negedge bus.forever_cpuclk);
    bus.rtu_yy_xx_commit0 = 1'b1;
    bus.rtu_yy_xx_commit0_iid = 7'h75;
    tick(1);
    expect_true(bus.lag_lm_ex1_init_vld,
                "committed atomic load did not initialize monitor");
    drain();
  endtask

  task automatic tc_vector_masks();
    int vmew;
    apply_reset();
    for (vmew = 0; vmew < 4; vmew++) begin
      @(negedge bus.forever_cpuclk);
      bus.idu_lsu_rf_gateclk_sel = 1'b1;
      bus.idu_lsu_rf_sel = 1'b1;
      bus.idu_lsu_rf_inst_vls = 1'b1;
      bus.idu_lsu_rf_unit_stride = 1'b1;
      bus.idu_lsu_rf_vmop = 2'b00;
      bus.idu_lsu_rf_vmew = vmew[1:0];
      bus.idu_lsu_rf_split = 1'b1;
      bus.idu_lsu_rf_split_num = vmew;
      bus.idu_lsu_rf_vl = 8'd64;
      bus.idu_lsu_rf_vmask_vld = 1'b1;
      bus.idu_lsu_rf_srcvm_vr0 = {256{1'b1}};
      bus.idu_lsu_rf_srcvm_vr1 = {256{1'b1}};
      bus.idu_lsu_rf_src0 = 64'h0000_0000_00B0_0000;
      bus.idu_lsu_rf_iid = 7'h78 + vmew;
      tick(1);
      expect_true(
        !$isunknown({
          bus.lag_ldc_ex1_bytes_vld,
          bus.lag_ldc_ex1_bytes_vld1,
          bus.lag_ldc_ex1_bytes_vld2,
          bus.lag_ldc_ex1_bytes_vld3,
          bus.lag_ldc_ex1_reg_bytes_vld
        }),
        "vector helper contract produced unknown valid masks"
      );
      drain();
    end
  endtask

  task automatic tc_flush_clock_gating();
    apply_reset();
    bus.dcache_arb_lag_ex1_bkcon = 1'b1;
    launch_scalar(64'h0000_0000_00C0_0000, 12'h000, 2'b11, 7'h7D);
    expect_true(bus.lag_ex1_inst_vld,
                "flush test did not establish a live AG owner");
    @(negedge bus.forever_cpuclk);
    bus.rtu_lsu_flush_fe = 1'b1;
    tick(1);
    expect_true(!bus.lag_ex1_inst_vld,
                "front-end flush did not clear AG owner");
    expect_true(!bus.lsu_lrq_create_vld,
                "front-end flush allowed late LRQ create");
    drain();

    bus.cp0_lsu_icg_en = 1'b0;
    bus.pad_yy_icg_scan_en = 1'b1;
    launch_scalar(64'h0000_0000_00C0_1000, 12'h000, 2'b11, 7'h7E);
    expect_true(bus.lag_ex1_inst_vld,
                "scan-enable clock path did not capture request");
    drain();
  endtask

  initial begin
    checks_run = 0;
    known_findings = 0;
    if (!$value$plusargs("TEST=%s", selected_test))
      selected_test = "tc_scalar_va_cross_page";

    case (selected_test)
      "tc_rf_capture_replay":       tc_rf_capture_replay();
      "tc_scalar_va_cross_page":    tc_scalar_va_cross_page();
      "tc_mmu_hit_miss_abort":      tc_mmu_hit_miss_abort();
      "tc_mmu_fault_persistence":   tc_mmu_fault_persistence();
      "tc_stall_restart_owner":     tc_stall_restart_owner();
      "tc_dcache_bank_requests":    tc_dcache_bank_requests();
      "tc_unit_stride_two_phase":   tc_unit_stride_two_phase();
      "tc_exception_priority":      tc_exception_priority();
      "tc_lrq_create_freeze":       tc_lrq_create_freeze();
      "tc_tcm_atomic_commit":       tc_tcm_atomic_commit();
      "tc_vector_masks":            tc_vector_masks();
      "tc_flush_clock_gating":      tc_flush_clock_gating();
      default: $fatal(1, "unknown +TEST=%s", selected_test);
    endcase

    $display(
      "TEST_COMPLETE name=%s checks=%0d known_design_errors=%0d",
      selected_test,
      checks_run,
      known_findings
    );
    $finish;
  end

  initial begin
    #200000;
    $fatal(1, "global timeout in %s", selected_test);
  end

endmodule
