`timescale 1ns/1ps

module xx_lsu_ld_ag_assertions #(
  parameter int IID_WIDTH = 7,
  parameter int LSIQENTRY = 12
) (
  input logic                  clk,
  input logic                  reset_n,
  input logic                  flush,
  input logic                  lag_ex1_inst_vld,
  input logic                  lag_ex1_stall_ori,
  input logic [IID_WIDTH-1:0]  lag0_ex1_iid,
  input logic                  lag_ldc_ex1_inst_vld,
  input logic                  lag_ldc_ex1_inst_vls,
  input logic                  lag_ldc_ex1_inst_us,
  input logic [15:0]           lag_ldc_ex1_bytes_vld,
  input logic [15:0]           lag_ldc_ex1_bytes_vld1,
  input logic [15:0]           lag_ldc_ex1_bytes_vld2,
  input logic [15:0]           lag_ldc_ex1_bytes_vld3,
  input logic                  lsu_mmu_va_vld,
  input logic                  mmu_lsu_pa_vld,
  input logic                  mmu_lsu_page_fault,
  input logic                  mmu_lsu_access_fault,
  input logic                  lsu_mmu_abort,
  input logic                  lag_ldc_ex1_expt_vld,
  input logic                  lag_ldc_ex1_expt_page_fault,
  input logic                  lag_ldc_ex1_expt_access_fault_with_page,
  input logic                  lag_ldc_ex1_expt_ldamo_not_ca,
  input logic [LSIQENTRY-1:0]  lag_ex1_stall_restart_entry,
  input logic [15:0]           lag_dcache_arb_ex1_data_req,
  input logic                  lag_dcache_arb_ex1_ld_tag_req,
  input logic [1:0]            lag_dcache_arb_ex1_bank_idx,
  input logic [3:0]            lag_ldc_ex1_us_way,
  input logic                  lsu_lrq_create_vld,
  input logic                  lsu_lrq_create_frz,
  input logic [IID_WIDTH-1:0]  lsu_lrq_create_iid,
  input logic                  lag_ldc_ex1_atomic,
  input logic                  lag_ldc_ex1_dtcm_hit,
  input logic                  lag_ldc_ex1_itcm_hit,
  input logic                  lag_lm_ex1_init_vld,
  input logic [15:0]           lag_ldc_ex1_reg_bytes_vld,
  input logic [1:0]            idu_lsu_rf_inst_size,
  input logic                  idu_lsu_rf_unit_stride,
  input logic [1:0]            idu_lsu_rf_vmew,
  input logic                  idu_lsu_rf_split,
  input logic                  rtu_yy_xx_commit0
);

  default clocking cb @(posedge clk); endclocking
  default disable iff (!reset_n);

  CHK_FP01_OWNER_STABLE:
    assert property (lag_ex1_stall_ori && !flush
                     |=> !lag_ex1_stall_ori
                          || $stable(lag0_ex1_iid)
                          || flush)
      else $fatal(1, "AG-FP-01 owner changed while AG remained stalled");
  COV_FP01_OWNER:
    cover property (lag_ex1_inst_vld ##1 lag_ex1_stall_ori[*2]
                    ##1 !lag_ex1_stall_ori);

  CHK_FP02_ADDR_MASK:
    assert property (lag_ldc_ex1_inst_vld && !lag_ldc_ex1_inst_vls
                     |-> !$isunknown(lag_ldc_ex1_bytes_vld))
      else $fatal(1, "AG-FP-02 scalar byte mask contains X");
  COV_FP02_ADDR_SIZE:
    cover property (lag_ex1_inst_vld ##0 idu_lsu_rf_inst_size == 2'b11);

  CHK_FP03_MMU_OWNER:
    assert property (lsu_mmu_va_vld |-> lag_ex1_inst_vld)
      else $fatal(1, "AG-FP-03 MMU request has no live AG owner");
  COV_FP03_MMU_RESULT:
    cover property (lsu_mmu_va_vld ##1 mmu_lsu_pa_vld
                    ##1 lsu_mmu_va_vld ##1 !mmu_lsu_pa_vld);

  CHK_FP04_FAULT_TRANSFER:
    assert property (mmu_lsu_page_fault && mmu_lsu_pa_vld
                     |-> lag_ldc_ex1_expt_page_fault)
      else $fatal(1, "AG-FP-04 page fault was not transferred to DC");
  COV_FP04_FAULT_DELAY:
    cover property (lsu_mmu_va_vld ##1 mmu_lsu_access_fault
                    ##[0:2] lag_ldc_ex1_expt_vld);

  CHK_FP05_RESTART_OWNER:
    assert property ((|lag_ex1_stall_restart_entry)
                     |-> lag_ex1_stall_ori || lsu_mmu_abort)
      else $fatal(1, "AG-FP-05 restart bitmap lacks stall/abort cause");
  COV_FP05_STALL_REASON:
    cover property (lag_ex1_inst_vld ##1 lag_ex1_stall_ori
                    ##1 |lag_ex1_stall_restart_entry);

  CHK_FP06_DC_REQ_VALID:
    assert property ((|lag_dcache_arb_ex1_data_req)
                     |-> lag_dcache_arb_ex1_ld_tag_req
                          && lag_ex1_inst_vld)
      else $fatal(1, "AG-FP-06 D-cache data request is not owner-qualified");
  COV_FP06_BANK_INDEX:
    cover property ((|lag_dcache_arb_ex1_data_req)
                    ##1 lag_dcache_arb_ex1_bank_idx == 2'b11);

  CHK_FP07_US_SEQUENCE:
    assert property (lag_ldc_ex1_inst_us && |lag_dcache_arb_ex1_data_req
                     |-> $onehot0(lag_ldc_ex1_us_way))
      else $fatal(1, "AG-FP-07 unit-stride way is multi-hot or unknown");
  COV_FP07_US_WAY:
    cover property (lag_ldc_ex1_inst_us ##[1:3]
                    lag_ldc_ex1_us_way == 4'b1000);

  CHK_FP08_EXCEPTION_AGGREGATES:
    assert property ((lag_ldc_ex1_expt_page_fault
                      || lag_ldc_ex1_expt_access_fault_with_page)
                     |-> lag_ldc_ex1_expt_vld)
      else $fatal(1, "AG-FP-08 exception subtype missing aggregate valid");
  CHK_FP08_LDAMO_ENCODING:
    assert property (lag_ldc_ex1_expt_ldamo_not_ca
                     |-> lag_ldc_ex1_atomic)
      else $fatal(1, "AG-FP-08 LDAMO-not-CA set for non-atomic instruction");
  COV_FP08_EXCEPTION_KIND:
    cover property (lag_ldc_ex1_expt_page_fault
                    ##1 lag_ldc_ex1_expt_ldamo_not_ca);

  CHK_FP09_LRQ_OWNER:
    assert property (lsu_lrq_create_vld
                     |-> lsu_lrq_create_iid == lag0_ex1_iid)
      else $fatal(1, "AG-FP-09 LRQ create owner differs from AG owner");
  COV_FP09_LRQ_STATE:
    cover property (lsu_lrq_create_vld && lsu_lrq_create_frz);

  CHK_FP10_ATOMIC_COMMIT:
    assert property (lag_lm_ex1_init_vld |-> lag_ldc_ex1_atomic)
      else $fatal(1, "AG-FP-10 local monitor initialized by non-atomic load");
  CHK_FP10_TCM_EXCLUSIVE:
    assert property (!(lag_ldc_ex1_dtcm_hit && lag_ldc_ex1_itcm_hit))
      else $fatal(1, "AG-FP-10 DTCM and ITCM selected together");
  COV_FP10_SPECIAL_SOURCE:
    cover property (lag_ldc_ex1_atomic ##[1:4] rtu_yy_xx_commit0
                    ##1 lag_lm_ex1_init_vld);

  CHK_FP11_VECTOR_KNOWN:
    assert property (lag_ldc_ex1_inst_vld && lag_ldc_ex1_inst_vls
                     |-> !$isunknown({
                       lag_ldc_ex1_bytes_vld,
                       lag_ldc_ex1_bytes_vld1,
                       lag_ldc_ex1_bytes_vld2,
                       lag_ldc_ex1_bytes_vld3,
                       lag_ldc_ex1_reg_bytes_vld
                     }))
      else $fatal(1, "AG-FP-11 valid vector mask contains X");
  COV_FP11_VECTOR_MODE:
    cover property (idu_lsu_rf_split && idu_lsu_rf_unit_stride
                    ##0 idu_lsu_rf_vmew == 2'b11);

  CHK_FP12_FLUSH_CLEARS:
    assert property (flush |=> !lag_ex1_inst_vld)
      else $fatal(1, "AG-FP-12 flush left a live AG owner");
  COV_FP12_FLUSH_POINT:
    cover property (lag_ex1_inst_vld && lag_ex1_stall_ori ##1 flush
                    ##1 !lag_ex1_inst_vld);

endmodule
