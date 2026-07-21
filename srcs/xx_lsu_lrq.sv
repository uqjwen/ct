//-----------------------------------------------------------------------------
// File          : xx_lsu_lrq.v
// Created       : 2025/03/24 (by Wen Jiahui)
// Last modified : 2025/03/24 (by Wen Jiahui)
// Version       : s1.0 (##s means single file version, 
//                       to avoid conflicts with the whole project version)
//-----------------------------------------------------------------------------
// Description :
//  This block contains the TBD.
//-----------------------------------------------------------------------------
// Copyright (c) 2023 CHUXIN Team.  All rights reserved.
// This model is the confidential and proprietary property of CHUXIN team and the possession or use of this
// file requires a written license from CHUXIN team. This work may not be copied, modified, re-published, uploaded, executed,
// or distributed in any way, in any medium, whether in whole or in part, without prior written permission from CHUXIN Team.
//-----------------------------------------------------------------------------
// Modification history :
// 2024/03/24 : Created
// 2024/XX/XX : 
//-----------------------------------------------------------------------------

//#
//# Module Declaration
//# ==================
//#
module xx_lsu_lrq #(
    parameter PREG = 7,
    parameter VREG = 6,
    parameter IID_WIDTH = 10,
    parameter VMBENTRY = 8,
    parameter LRQENTRY = 12,
    parameter PC_LEN = 15,
    parameter LSIQENTRY = 12,
    parameter SDIQENTRY = 12
)(
input logic                 cpurst_b,
input logic                 forever_cpuclk,
input logic                 lsu_special_clk,
input logic                 cp0_lsu_icg_en,
input logic                 pad_yy_icg_scan_en,
input logic                 rtu_lsu_flush_fe,
input logic                 rtu_ck_flush,
input logic [IID_WIDTH-1:0] rtu_ck_flush_iid,
input logic                 idu_lsu_old_vld,
input logic [IID_WIDTH-1:0] idu_lsu_old_iid,

input logic                 idu_lsu0_rf_atomic,
input logic                 idu_lsu0_rf_gateclk_sel, // 
input logic [IID_WIDTH-1:0] idu_lsu0_rf_iid,
input logic                 idu_lsu0_rf_inst_fls,
input logic                 idu_lsu0_rf_inst_fof,
input logic                 idu_lsu0_rf_inst_ldr,
input logic [1:0]           idu_lsu0_rf_inst_size,
input logic [1:0]           idu_lsu0_rf_inst_type,
input logic                 idu_lsu0_rf_inst_vls,
input logic [1:0]           idu_lsu0_rf_inst_vmew,
input logic [1:0]           idu_lsu0_rf_inst_vmop,
input logic                 idu_lsu0_rf_inst_nf,
input logic [LSIQENTRY-1:0] idu_lsu0_rf_lch_entry, // 
input logic                 idu_lsu0_rf_lsfifo,
//input logic [2:0]           idu_lsu0_rf_mlen, //not use in rvv1.0 @hcl
input logic [1:0]           idu_lsu0_rf_no_spec,
input logic                 idu_lsu0_rf_no_spec_exist,
input logic                 idu_lsu0_rf_zext,
input logic [11:0]          idu_lsu0_rf_offset,
input logic [12:0]          idu_lsu0_rf_offset_plus,
input logic                 idu_lsu0_rf_oldest,
input logic [PC_LEN-1:0]    idu_lsu0_rf_pc,
input logic [PREG-1:0]      idu_lsu0_rf_preg,
input logic                 idu_lsu0_rf_sel,
input logic [3:0]           idu_lsu0_rf_shift,
input logic                 idu_lsu0_rf_sext,
input logic                 idu_lsu0_rf_split,
input logic [8:0]           idu_lsu0_rf_split_num,
input logic [63:0]          idu_lsu0_rf_src0,
input logic [63:0]          idu_lsu0_rf_src1,
input logic [255:0]         idu_lsu0_rf_srcvm_vr0,
input logic [255:0]         idu_lsu0_rf_srcvm_vr1,
input logic                 idu_lsu0_rf_unit_stride,
input logic [`VL_WIDTH-1:0]           idu_lsu0_rf_vl,
// input logic [1:0]           idu_lsu0_rf_vlmul,
input logic [2:0]           idu_lsu0_rf_vlmul,  //pwh 1 for rvv1.0
input logic [3:0]           idu_lsu0_rf_vls_size,
input logic                 idu_lsu0_rf_vmask_vld,
input logic [VMBENTRY-1:0]  idu_lsu0_rf_vmb_id,
input logic                 idu_lsu0_rf_vmb_merge_vld,
input logic [VREG-1:0]      idu_lsu0_rf_vreg,
//input logic [1:0]           idu_lsu0_rf_vsew, // not use in rvv1.0 @hcl

input  logic                  idu_lsu2_rf_atomic,
input  logic                  idu_lsu2_rf_gateclk_sel,
input  logic  [IID_WIDTH-1:0] idu_lsu2_rf_iid,
input  logic                  idu_lsu2_rf_inst_fls,
input  logic                  idu_lsu2_rf_inst_fof,
input  logic                  idu_lsu2_rf_inst_ldr,
input  logic  [1:0]           idu_lsu2_rf_inst_size,
input  logic  [1:0]           idu_lsu2_rf_inst_type,
input  logic                  idu_lsu2_rf_inst_vls,
input  logic  [1:0]           idu_lsu2_rf_inst_vmew,
input  logic  [1:0]           idu_lsu2_rf_inst_vmop,
input  logic                  idu_lsu2_rf_inst_nf,
input  logic  [LSIQENTRY-1:0] idu_lsu2_rf_lch_entry,
input  logic                  idu_lsu2_rf_lsfifo,
//input  logic  [2:0]           idu_lsu2_rf_mlen, //not use in rvv1.0 @hcl
input  logic  [1:0]           idu_lsu2_rf_no_spec,
input  logic                  idu_lsu2_rf_no_spec_exist,
input  logic                  idu_lsu2_rf_zext,
input  logic  [11:0]          idu_lsu2_rf_offset,
input  logic  [12:0]          idu_lsu2_rf_offset_plus,
input  logic                  idu_lsu2_rf_oldest,
input  logic  [14:0]          idu_lsu2_rf_pc,
input  logic  [PREG-1:0]      idu_lsu2_rf_preg,
input  logic                  idu_lsu2_rf_sel,
input  logic  [3:0]           idu_lsu2_rf_shift,
input  logic                  idu_lsu2_rf_sext,
input  logic                  idu_lsu2_rf_split,
input  logic  [8:0]           idu_lsu2_rf_split_num,
input  logic  [63:0]          idu_lsu2_rf_src0,
input  logic  [63:0]          idu_lsu2_rf_src1,
input  logic  [255:0]          idu_lsu2_rf_srcvm_vr0,
input  logic  [255:0]          idu_lsu2_rf_srcvm_vr1,
input  logic                  idu_lsu2_rf_unit_stride,
input  logic  [`VL_WIDTH-1:0]           idu_lsu2_rf_vl,
// input  logic  [1:0]           idu_lsu2_rf_vlmul,
input  logic  [2:0]           idu_lsu2_rf_vlmul,  //pwh 2 for rvv1.0
input  logic  [3:0]           idu_lsu2_rf_vls_size,
input  logic                  idu_lsu2_rf_vmask_vld,
input  logic  [7:0]           idu_lsu2_rf_vmb_id,
input  logic                  idu_lsu2_rf_vmb_merge_vld,
input  logic  [VREG-1:0]      idu_lsu2_rf_vreg,
//input  logic  [1:0]           idu_lsu2_rf_vsew,  // not use in rvv1.0 @hcl
input  logic                  idu_lsu2_rf_is_load, // specialized for store inst
input  logic  [3:0]           idu_lsu2_rf_fence_mode,
input  logic                  idu_lsu2_rf_icc,
input  logic                  idu_lsu2_rf_idx_ord,
input  logic  [31:0]          idu_lsu2_rf_inst_code,
input  logic                  idu_lsu2_rf_inst_flush,
input  logic  [1:0]           idu_lsu2_rf_inst_mode,
input  logic                  idu_lsu2_rf_inst_share,
input  logic                  idu_lsu2_rf_inst_str,
input  logic                  idu_lsu2_rf_mmu_req,
input  logic  [SDIQENTRY-1:0] idu_lsu2_rf_sdiq_entry,
input  logic                  idu_lsu2_rf_st,
input  logic                  idu_lsu2_rf_staddr,
input  logic                  idu_lsu2_rf_sync_fence,

input  logic                  idu_lsu3_rf_atomic,
input  logic                  idu_lsu3_rf_gateclk_sel,
input  logic  [IID_WIDTH-1:0] idu_lsu3_rf_iid,
input  logic                  idu_lsu3_rf_inst_fls,
input  logic                  idu_lsu3_rf_inst_fof,
input  logic                  idu_lsu3_rf_inst_ldr,
input  logic  [1:0]           idu_lsu3_rf_inst_size,
input  logic  [1:0]           idu_lsu3_rf_inst_type,
input  logic                  idu_lsu3_rf_inst_vls,
input  logic  [1:0]           idu_lsu3_rf_inst_vmew,
input  logic  [1:0]           idu_lsu3_rf_inst_vmop,
input  logic                  idu_lsu3_rf_inst_nf,
input  logic  [LSIQENTRY-1:0] idu_lsu3_rf_lch_entry,
input  logic                  idu_lsu3_rf_lsfifo,
//input  logic  [2:0]           idu_lsu3_rf_mlen, //not use in rvv1.0 @hcl
input  logic  [1:0]           idu_lsu3_rf_no_spec,
input  logic                  idu_lsu3_rf_no_spec_exist,
input  logic                  idu_lsu3_rf_zext,
input  logic  [11:0]          idu_lsu3_rf_offset,
input  logic  [12:0]          idu_lsu3_rf_offset_plus,
input  logic                  idu_lsu3_rf_oldest,
input  logic  [14:0]          idu_lsu3_rf_pc,
input  logic  [PREG-1:0]      idu_lsu3_rf_preg,
input  logic                  idu_lsu3_rf_sel,
input  logic  [3:0]           idu_lsu3_rf_shift,
input  logic                  idu_lsu3_rf_sext,
input  logic                  idu_lsu3_rf_split,
input  logic  [8:0]           idu_lsu3_rf_split_num,
input  logic  [63:0]          idu_lsu3_rf_src0,
input  logic  [63:0]          idu_lsu3_rf_src1,
input  logic  [255:0]         idu_lsu3_rf_srcvm_vr0,
input  logic  [255:0]         idu_lsu3_rf_srcvm_vr1,
input  logic                  idu_lsu3_rf_unit_stride,
input  logic  [`VL_WIDTH-1:0]           idu_lsu3_rf_vl,
// input  logic  [1:0]           idu_lsu3_rf_vlmul,
input  logic  [2:0]           idu_lsu3_rf_vlmul,  //pwh 3 for rvv1.0
input  logic  [3:0]           idu_lsu3_rf_vls_size,
input  logic                  idu_lsu3_rf_vmask_vld,
input  logic  [7:0]           idu_lsu3_rf_vmb_id,
input  logic                  idu_lsu3_rf_vmb_merge_vld,
input  logic  [VREG-1:0]      idu_lsu3_rf_vreg,
//input  logic  [1:0]           idu_lsu3_rf_vsew, // not use in rvv1.0 @hcl
input  logic                  idu_lsu3_rf_is_load, // specialized for store inst
input  logic  [3:0]           idu_lsu3_rf_fence_mode,
input  logic                  idu_lsu3_rf_icc,
input  logic                  idu_lsu3_rf_idx_ord,
input  logic  [31:0]          idu_lsu3_rf_inst_code,
input  logic                  idu_lsu3_rf_inst_flush,
input  logic  [1:0]           idu_lsu3_rf_inst_mode,
input  logic                  idu_lsu3_rf_inst_share,
input  logic                  idu_lsu3_rf_inst_str,
input  logic                  idu_lsu3_rf_mmu_req,
input  logic  [SDIQENTRY-1:0] idu_lsu3_rf_sdiq_entry,
input  logic                  idu_lsu3_rf_st,
input  logic                  idu_lsu3_rf_staddr,
input  logic                  idu_lsu3_rf_sync_fence,
// input logic 

input logic                     lsu0_lrq_create_vld,
input logic [63:0]              lsu0_lrq_create_va,
input logic                     lsu0_lrq_create_frz,
input logic                     lsu0_lrq_create_wait_old_chk,
input logic                     lsu0_lrq_create_bar_chk,
input logic                     lsu0_lrq_create_no_spec_chk,
input logic [15:0]              lsu0_lrq_create_bytes_vld,
input logic [15:0]              lsu0_lrq_create_bytes_vld1,
input logic [15:0]              lsu0_lrq_create_bytes_vld2,
input logic [15:0]              lsu0_lrq_create_bytes_vld3,
input logic [15:0]              lsu0_lrq_create_reg_bytes_vld,
input logic [15:0]              lsu0_lrq_create_reg_bytes_vld1,
input logic [15:0]              lsu0_lrq_create_reg_bytes_vld2,
input logic [15:0]              lsu0_lrq_create_reg_bytes_vld3,
input logic                     lsu0_lrq_create_boundary,
input logic                     lsu0_lrq_create_atomic,
input logic [IID_WIDTH-1:0]     lsu0_lrq_create_iid,
input logic                     lsu0_lrq_create_fls,
input logic                     lsu0_lrq_create_fof,
input logic [1:0]               lsu0_lrq_create_size,
input logic [1:0]               lsu0_lrq_create_type,
input logic                     lsu0_lrq_create_vls,
input logic                     lsu0_lrq_create_lsfifo,
input logic [PC_LEN-1:0]        lsu0_lrq_create_pc,
input logic [PREG-1:0]          lsu0_lrq_create_preg,
input logic                     lsu0_lrq_create_sext,
input logic                     lsu0_lrq_create_split,
input logic [8:0]               lsu0_lrq_create_split_num,
input logic                     lsu0_lrq_create_unit_stride,
// input logic [1:0]               lsu0_lrq_create_vlmul,
input logic [2:0]               lsu0_lrq_create_vlmul,  //pwh 4 for rvv1.0
input logic [3:0]               lsu0_lrq_create_vls_size,
input logic [VMBENTRY-1:0]      lsu0_lrq_create_vmb_id,
input logic                     lsu0_lrq_create_vmb_merge_vld,
input logic [VREG-1:0]          lsu0_lrq_create_vreg,
//input logic [1:0]               lsu0_lrq_create_vsew,
input logic [1:0]               lsu0_lrq_create_vmew,
input logic [1:0]               lsu0_lrq_create_vmop,
input logic                     lsu0_lrq_create_nf,
input logic                     lsu0_lrq_create_4kstall,
input logic                     lsu0_lrq_ex1_pa_set, // to set the pa
input logic [`WK_PA_WIDTH-13:0] lsu0_lrq_ex1_pa, // 
input logic [4:0]               lsu0_lrq_ex1_attr,
input logic [LRQENTRY-1:0]      lsu0_lrq_pop_entry,

input logic [LRQENTRY-1:0]   lsu0_lrq_frz_clr, // like lsu0_idu_exx_wakeup may excluding ld0_rf_imme_wakeup 
input logic [LRQENTRY-1:0]   lsu0_lrq_ex1_lrqid,
input logic                  lsu0_lrq_ex1_stall_vld, // stall ori
input logic [IID_WIDTH-1:0]  lsu0_lrq_ex1_iid,
input logic                  lsu0_lrq_ex1_inst_vld,

input logic [LRQENTRY-1:0]   lsu0_lrq_ex2_lq_full, // from ctrl
input logic                  lsu0_lrq_ex2_lq_not_full, // from lq
input logic [LRQENTRY-1:0]   lsu0_lrq_ex2_sq_full,  // from ctrl
input logic                  lsu0_lrq_exx_sq_not_full, // from sq
input logic [LRQENTRY-1:0]   lsu0_lrq_ex3_rb_full,  // from ctrl
input logic                  lsu0_lrq_ex3_rb_not_full, // from rb
input logic [LRQENTRY-1:0]   lsu0_lrq_ex1_wait_old,  // from ctrl
input logic [LRQENTRY-1:0]   lsu0_lrq_ex3_wait_fence, // from ctrl
input logic                  lsu0_lrq_exx_no_fence, // from rb
input logic [LRQENTRY-1:0]   lsu0_lrq_ex2_tlb_busy, // from ctrl 
input logic [LRQENTRY-1:0]   lsu0_lrq_exx_tlb_wakeup, // from ctrl 
input logic [LRQENTRY-1:0]   lsu0_lrq_ex3_secd,       // from ctrl 
input logic [LRQENTRY-1:0]   lsu0_lrq_ex3_already_da, // from ctrl 
input logic [LRQENTRY-1:0]   lsu0_lrq_ex3_spec_fail,  // from ctrl 
input logic                  lsu0_lrq_ex3_pop_vld, // from da
input logic [LRQENTRY-1:0]   lsu0_lrq_ex3_pop_entry, // from da
// lsu2
input logic                      lsu2_lrq_create_vld,
input logic  [63:0]              lsu2_lrq_create_va,
input logic                      lsu2_lrq_create_frz,
input logic                      lsu2_lrq_create_wait_old_chk,
input logic                      lsu2_lrq_create_bar_chk,
input logic                      lsu2_lrq_create_no_spec_chk,
input logic  [15:0]              lsu2_lrq_create_bytes_vld,
input logic  [15:0]              lsu2_lrq_create_bytes_vld1,
input logic  [15:0]              lsu2_lrq_create_bytes_vld2,
input logic  [15:0]              lsu2_lrq_create_bytes_vld3,
input logic  [15:0]              lsu2_lrq_create_reg_bytes_vld,
input logic  [15:0]              lsu2_lrq_create_reg_bytes_vld1,
input logic  [15:0]              lsu2_lrq_create_reg_bytes_vld2,
input logic  [15:0]              lsu2_lrq_create_reg_bytes_vld3,
input logic                      lsu2_lrq_create_boundary,
input logic                      lsu2_lrq_create_atomic,
input logic  [IID_WIDTH-1:0]     lsu2_lrq_create_iid,
input logic                      lsu2_lrq_create_fls,
input logic                      lsu2_lrq_create_fof,
input logic  [1:0]               lsu2_lrq_create_size,
input logic  [1:0]               lsu2_lrq_create_type,
input logic                      lsu2_lrq_create_vls,
input logic                      lsu2_lrq_create_lsfifo,
input logic  [PC_LEN-1:0]        lsu2_lrq_create_pc,
input logic  [PREG-1:0]          lsu2_lrq_create_preg,
input logic                      lsu2_lrq_create_sext,
input logic                      lsu2_lrq_create_split,
input logic  [8:0]               lsu2_lrq_create_split_num,
input logic                      lsu2_lrq_create_unit_stride,
// input logic  [1:0]               lsu2_lrq_create_vlmul,
input logic  [2:0]               lsu2_lrq_create_vlmul,  //pwh 5 for rvv1.0
input logic  [3:0]               lsu2_lrq_create_vls_size,
input logic  [VMBENTRY-1:0]      lsu2_lrq_create_vmb_id,
input logic                      lsu2_lrq_create_vmb_merge_vld,
input logic  [VREG-1:0]          lsu2_lrq_create_vreg,
//input logic  [1:0]               lsu2_lrq_create_vsew,
input logic  [1:0]               lsu2_lrq_create_vmew,
input logic  [1:0]               lsu2_lrq_create_vmop,
input logic                      lsu2_lrq_create_nf,
input logic                      lsu2_lrq_create_4kstall,
input logic                      lsu2_lrq_ex1_pa_set,
input logic  [`WK_PA_WIDTH-13:0] lsu2_lrq_ex1_pa,
input logic  [4:0]               lsu2_lrq_ex1_attr,
input logic  [LSIQENTRY-1:0]     lsu2_lrq_pop_entry,
input logic                      lsu2_lrq_create_is_load,
input logic  [3:0]               lsu2_lrq_create_fence_mode,
input logic                      lsu2_lrq_create_icc,
input logic                      lsu2_lrq_create_idx_ord,
input logic                      lsu2_lrq_create_inst_flush,
input logic  [1:0]               lsu2_lrq_create_inst_mode,
input logic                      lsu2_lrq_create_inst_share,
input logic                      lsu2_lrq_create_inst_str,
input logic                      lsu2_lrq_create_mmu_req,
input logic  [SDIQENTRY-1:0]     lsu2_lrq_create_sdiq_entry,
input logic                      lsu2_lrq_create_st,
input logic                      lsu2_lrq_create_staddr,
input logic                      lsu2_lrq_create_sync_fence,
input logic [LRQENTRY-1:0]   lsu2_lrq_frz_clr, // like lsu0_idu_exx_wakeup may excluding ld0_rf_imme_wakeup 
input logic [LRQENTRY-1:0]   lsu2_lrq_ex1_lrqid,
input logic                  lsu2_lrq_ex1_stall_vld, // stall ori
input logic [IID_WIDTH-1:0]  lsu2_lrq_ex1_iid,
input logic                  lsu2_lrq_ex1_inst_vld,
input logic                  lsu2_lrq_ex1_is_load,
input logic                  lsu2_lrq_ex1_sync_fence,
// input logic [3:0]            lsu2_lrq_ex1_fence_mode,

input logic [LRQENTRY-1:0]   lsu2_lrq_ex2_lq_full, // from ctrl
input logic                  lsu2_lrq_ex2_lq_not_full, // from lq
input logic [LRQENTRY-1:0]   lsu2_lrq_ex2_sq_full,  // from ctrl
input logic                  lsu2_lrq_exx_sq_not_full, // from sq
input logic [LRQENTRY-1:0]   lsu2_lrq_ex3_rb_full,  // from ctrl
input logic                  lsu2_lrq_ex3_rb_not_full, // from rb
input logic [LRQENTRY-1:0]   lsu2_lrq_ex1_wait_old,  // from ctrl
input logic [LRQENTRY-1:0]   lsu2_lrq_ex3_wait_fence, // from ctrl
input logic                  lsu2_lrq_exx_no_fence, // from rb
input logic [LRQENTRY-1:0]   lsu2_lrq_ex2_tlb_busy, // from ctrl 
input logic [LRQENTRY-1:0]   lsu2_lrq_exx_tlb_wakeup, // from ctrl 
input logic [LRQENTRY-1:0]   lsu2_lrq_ex3_secd,       // from ctrl 
input logic [LRQENTRY-1:0]   lsu2_lrq_ex3_already_da, // from ctrl 
input logic [LRQENTRY-1:0]   lsu2_lrq_ex3_spec_fail,  // from ctrl 
input logic                  lsu2_lrq_ex3_pop_vld, // from da
input logic [LRQENTRY-1:0]   lsu2_lrq_ex3_pop_entry, // from da
// lsu3
input logic                      lsu3_lrq_create_vld,
input logic  [63:0]              lsu3_lrq_create_va,
input logic                      lsu3_lrq_create_frz,
input logic                      lsu3_lrq_create_wait_old_chk,
input logic                      lsu3_lrq_create_bar_chk,
input logic                      lsu3_lrq_create_no_spec_chk,
input logic  [15:0]              lsu3_lrq_create_bytes_vld,
input logic  [15:0]              lsu3_lrq_create_bytes_vld1,
input logic  [15:0]              lsu3_lrq_create_bytes_vld2,
input logic  [15:0]              lsu3_lrq_create_bytes_vld3,
input logic  [15:0]              lsu3_lrq_create_reg_bytes_vld,
input logic  [15:0]              lsu3_lrq_create_reg_bytes_vld1,
input logic  [15:0]              lsu3_lrq_create_reg_bytes_vld2,
input logic  [15:0]              lsu3_lrq_create_reg_bytes_vld3,
input logic                      lsu3_lrq_create_boundary,
input logic                      lsu3_lrq_create_atomic,
input logic  [IID_WIDTH-1:0]     lsu3_lrq_create_iid,
input logic                      lsu3_lrq_create_fls,
input logic                      lsu3_lrq_create_fof,
input logic  [1:0]               lsu3_lrq_create_size,
input logic  [1:0]               lsu3_lrq_create_type,
input logic                      lsu3_lrq_create_vls,
input logic                      lsu3_lrq_create_lsfifo,
input logic  [PC_LEN-1:0]        lsu3_lrq_create_pc,
input logic  [PREG-1:0]          lsu3_lrq_create_preg,
input logic                      lsu3_lrq_create_sext,
input logic                      lsu3_lrq_create_split,
input logic  [8:0]               lsu3_lrq_create_split_num,
input logic                      lsu3_lrq_create_unit_stride,
// input logic  [1:0]               lsu3_lrq_create_vlmul,
input logic  [2:0]               lsu3_lrq_create_vlmul,  //pwh 6 for rvv1.0
input logic  [3:0]               lsu3_lrq_create_vls_size,
input logic  [VMBENTRY-1:0]      lsu3_lrq_create_vmb_id,
input logic                      lsu3_lrq_create_vmb_merge_vld,
input logic  [VREG-1:0]          lsu3_lrq_create_vreg,
//input logic  [1:0]               lsu3_lrq_create_vsew,
input logic  [1:0]               lsu3_lrq_create_vmew,
input logic  [1:0]               lsu3_lrq_create_vmop,
input logic                      lsu3_lrq_create_nf,
input logic                      lsu3_lrq_create_4kstall,
input logic                      lsu3_lrq_ex1_pa_set,
input logic  [`WK_PA_WIDTH-13:0] lsu3_lrq_ex1_pa,
input logic  [4:0]               lsu3_lrq_ex1_attr,
input logic  [LSIQENTRY-1:0]     lsu3_lrq_pop_entry,
input logic                      lsu3_lrq_create_is_load,
input logic  [3:0]               lsu3_lrq_create_fence_mode,
input logic                      lsu3_lrq_create_icc,
input logic                      lsu3_lrq_create_idx_ord,
input logic                      lsu3_lrq_create_inst_flush,
input logic  [1:0]               lsu3_lrq_create_inst_mode,
input logic                      lsu3_lrq_create_inst_share,
input logic                      lsu3_lrq_create_inst_str,
input logic                      lsu3_lrq_create_mmu_req,
input logic  [SDIQENTRY-1:0]     lsu3_lrq_create_sdiq_entry,
input logic                      lsu3_lrq_create_st,
input logic                      lsu3_lrq_create_staddr,
input logic                      lsu3_lrq_create_sync_fence,
input logic [LRQENTRY-1:0]   lsu3_lrq_frz_clr, // like lsu0_idu_exx_wakeup may excluding ld0_rf_imme_wakeup 
input logic [LRQENTRY-1:0]   lsu3_lrq_ex1_lrqid,
input logic                  lsu3_lrq_ex1_stall_vld, // stall ori
input logic [IID_WIDTH-1:0]  lsu3_lrq_ex1_iid,
input logic                  lsu3_lrq_ex1_inst_vld,
input logic                  lsu3_lrq_ex1_is_load,
input logic                  lsu3_lrq_ex1_sync_fence,
// input logic [3:0]            lsu3_lrq_ex1_fence_mode,

input logic [LRQENTRY-1:0]   lsu3_lrq_ex2_lq_full, // from ctrl
input logic                  lsu3_lrq_ex2_lq_not_full, // from lq
input logic [LRQENTRY-1:0]   lsu3_lrq_ex2_sq_full,  // from ctrl
input logic                  lsu3_lrq_exx_sq_not_full, // from sq
input logic [LRQENTRY-1:0]   lsu3_lrq_ex3_rb_full,  // from ctrl
input logic                  lsu3_lrq_ex3_rb_not_full, // from rb
input logic [LRQENTRY-1:0]   lsu3_lrq_ex1_wait_old,  // from ctrl
input logic [LRQENTRY-1:0]   lsu3_lrq_ex3_wait_fence, // from ctrl
input logic                  lsu3_lrq_exx_no_fence, // from rb
input logic [LRQENTRY-1:0]   lsu3_lrq_ex2_tlb_busy, // from ctrl 
input logic [LRQENTRY-1:0]   lsu3_lrq_exx_tlb_wakeup, // from ctrl 
input logic [LRQENTRY-1:0]   lsu3_lrq_ex3_secd,       // from ctrl 
input logic [LRQENTRY-1:0]   lsu3_lrq_ex3_already_da, // from ctrl 
input logic [LRQENTRY-1:0]   lsu3_lrq_ex3_spec_fail,  // from ctrl 
input logic                  lsu3_lrq_ex3_pop_vld, // from da
input logic [LRQENTRY-1:0]   lsu3_lrq_ex3_pop_entry, // from da

// input logic [PC_LEN-1:0]     sfp_lsu0_no_spec_dst_pc, // from sfp
// input logic [PC_LEN-1:0]     sfp_lsu2_no_spec_dst_pc, // from sfp
// input logic [PC_LEN-1:0]     sfp_lsu3_no_spec_dst_pc, // from sfp
input logic [PC_LEN-1:0]     lsu0_lrq_sfp_dst_pc,
input logic [PC_LEN-1:0]     lsu2_lrq_sfp_dst_pc,
input logic [PC_LEN-1:0]     lsu3_lrq_sfp_dst_pc,
input logic                  sfp_lrq0_ex0_pc_hit,
input logic                  sfp_lrq2_ex0_pc_hit,
input logic                  sfp_lrq3_ex0_pc_hit,
input logic [PC_LEN-1:0]     sfp_lrq0_ex0_dst_pc, // 
input logic [PC_LEN-1:0]     sfp_lrq2_ex0_dst_pc, // 
input logic [PC_LEN-1:0]     sfp_lrq3_ex0_dst_pc, // 
output  logic                  lrq_lsu0_rf_replay_vld,
output  logic  [63:0]          lrq_lsu0_rf_va,
output  logic  [15:0]          lrq_lsu0_rf_bytes_vld,
output  logic  [15:0]          lrq_lsu0_rf_bytes_vld1,
output  logic  [15:0]          lrq_lsu0_rf_bytes_vld2,
output  logic  [15:0]          lrq_lsu0_rf_bytes_vld3,
output  logic  [15:0]          lrq_lsu0_rf_reg_bytes_vld,
output  logic  [15:0]          lrq_lsu0_rf_reg_bytes_vld1,
output  logic  [15:0]          lrq_lsu0_rf_reg_bytes_vld2,
output  logic  [15:0]          lrq_lsu0_rf_reg_bytes_vld3,
output  logic                  lrq_lsu0_rf_boundary,
output  logic                  lrq_lsu0_rf_already_da,
output  logic                  lrq_lsu0_rf_atomic,
output  logic                  lrq_lsu0_rf_gateclk_sel,
output  logic  [IID_WIDTH-1:0] lrq_lsu0_rf_iid,
output  logic                  lrq_lsu0_rf_inst_fls,
output  logic                  lrq_lsu0_rf_inst_fof,
output  logic                  lrq_lsu0_rf_inst_ldr,
output  logic  [1:0]           lrq_lsu0_rf_inst_size,
output  logic  [1:0]           lrq_lsu0_rf_inst_type,
output  logic                  lrq_lsu0_rf_inst_vls,
output  logic  [LRQENTRY-1:0]  lrq_lsu0_rf_lch_entry, // special care
output  logic                  lrq_lsu0_rf_lsfifo,
//output  logic  [2:0]           lrq_lsu0_rf_mlen, // not use in rvv1.0 @hcl
output  logic  [1:0]           lrq_lsu0_rf_no_spec,
output  logic                  lrq_lsu0_rf_no_spec_exist,
output  logic                  lrq_lsu0_rf_zext,
output  logic  [11:0]          lrq_lsu0_rf_offset,
output  logic  [12:0]          lrq_lsu0_rf_offset_plus,
output  logic                  lrq_lsu0_rf_oldest, // special care
output  logic  [14:0]          lrq_lsu0_rf_pc,
output  logic  [PREG-1:0]      lrq_lsu0_rf_preg,
output  logic                  lrq_lsu0_rf_sel, // special care
output  logic                  lrq_lsu0_rf_older_vld, // timing
output  logic  [3:0]           lrq_lsu0_rf_shift,
output  logic                  lrq_lsu0_rf_sext,
output  logic                  lrq_lsu0_rf_spec_fail,
output  logic                  lrq_lsu0_rf_split,
output  logic  [8:0]           lrq_lsu0_rf_split_num,
output  logic  [63:0]          lrq_lsu0_rf_src0,
output  logic  [63:0]          lrq_lsu0_rf_src1,
output  logic  [255:0]         lrq_lsu0_rf_srcvm_vr0,
output  logic  [255:0]         lrq_lsu0_rf_srcvm_vr1,
output  logic                  lrq_lsu0_rf_unal2nd,
output  logic                  lrq_lsu0_rf_unit_stride,
output  logic  [`VL_WIDTH-1:0]           lrq_lsu0_rf_vl,
// output  logic  [1:0]           lrq_lsu0_rf_vlmul,
output  logic  [2:0]           lrq_lsu0_rf_vlmul,  //pwh 7 for rvv1.0
output  logic  [3:0]           lrq_lsu0_rf_vls_size,
output  logic                  lrq_lsu0_rf_vmask_vld,
output  logic  [7:0]           lrq_lsu0_rf_vmb_id,
output  logic                  lrq_lsu0_rf_vmb_merge_vld,
output  logic  [VREG-1:0]      lrq_lsu0_rf_vreg,
//output  logic  [1:0]           lrq_lsu0_rf_vsew, // not use in rvv1.0 @hcl
output  logic  [1:0]           lrq_lsu0_rf_vmew,
output  logic  [1:0]           lrq_lsu0_rf_vmop,
output  logic                  lrq_lsu0_rf_nf,
output  logic                  lrq_lsu0_rf_pa_vld,
output  logic  [`WK_PA_WIDTH-13:0] lrq_lsu0_rf_pa,
output  logic [4:0]                lrq_lsu0_rf_attr,
output  logic [PC_LEN-1:0]         lrq_lsu0_rf_sfp_dst_pc,
output  logic                      lrq_lsu0_rf_sfp_pc_hit,
output  logic [LRQENTRY-1:0]       lrq_lsu0_ex1_lrqid,
output  logic                      lrq0_hit_no_spec_tbl,
output logic  [LSIQENTRY-1:0] lrq0_idu_ex3_pop_entry,
output logic                  lrq0_idu_ex3_pop_vld,
output logic  [LSIQENTRY-1:0] lrq0_idu_exx_wakeup, // full wakeup idu
// lsu2
output logic                      lrq_lsu2_rf_replay_vld,
output logic  [63:0]              lrq_lsu2_rf_va,
output logic  [15:0]              lrq_lsu2_rf_bytes_vld,
output logic  [15:0]              lrq_lsu2_rf_bytes_vld1,
output logic  [15:0]              lrq_lsu2_rf_bytes_vld2,
output logic  [15:0]              lrq_lsu2_rf_bytes_vld3,
output logic  [15:0]              lrq_lsu2_rf_reg_bytes_vld,
output logic  [15:0]              lrq_lsu2_rf_reg_bytes_vld1,
output logic  [15:0]              lrq_lsu2_rf_reg_bytes_vld2,
output logic  [15:0]              lrq_lsu2_rf_reg_bytes_vld3,
output logic                      lrq_lsu2_rf_boundary,
output logic                      lrq_lsu2_rf_already_da,
output logic                      lrq_lsu2_rf_atomic,
output logic                      lrq_lsu2_rf_gateclk_sel,
output logic  [IID_WIDTH-1:0]     lrq_lsu2_rf_iid,
output logic                      lrq_lsu2_rf_inst_fls,
output logic                      lrq_lsu2_rf_inst_fof,
output logic                      lrq_lsu2_rf_inst_ldr,
output logic  [1:0]               lrq_lsu2_rf_inst_size,
output logic  [1:0]               lrq_lsu2_rf_inst_type,
output logic                      lrq_lsu2_rf_inst_vls,
output logic  [LRQENTRY-1:0]      lrq_lsu2_rf_lch_entry, // special care
output logic                      lrq_lsu2_rf_lsfifo,
//output logic  [2:0]               lrq_lsu2_rf_mlen,//not use in rvv1.0 @hcl
output logic  [1:0]               lrq_lsu2_rf_no_spec,
output logic                      lrq_lsu2_rf_no_spec_exist,
output logic                      lrq_lsu2_rf_zext,
output logic  [11:0]              lrq_lsu2_rf_offset,
output logic  [12:0]              lrq_lsu2_rf_offset_plus,
output logic                      lrq_lsu2_rf_oldest, // special care
output logic  [14:0]              lrq_lsu2_rf_pc,
output logic  [PREG-1:0]          lrq_lsu2_rf_preg,
output logic                      lrq_lsu2_rf_sel, // special care
output logic                      lrq_lsu2_rf_older_vld, // wjh@timing
output logic  [3:0]               lrq_lsu2_rf_shift,
output logic                      lrq_lsu2_rf_sext,
output logic                      lrq_lsu2_rf_spec_fail,
output logic                      lrq_lsu2_rf_split,
output logic  [8:0]               lrq_lsu2_rf_split_num,
output logic  [63:0]              lrq_lsu2_rf_src0,
output logic  [63:0]              lrq_lsu2_rf_src1,
output logic  [255:0]             lrq_lsu2_rf_srcvm_vr0,
output logic  [255:0]             lrq_lsu2_rf_srcvm_vr1,
output logic                      lrq_lsu2_rf_unal2nd,
output logic                      lrq_lsu2_rf_unit_stride,
output logic  [`VL_WIDTH-1:0]               lrq_lsu2_rf_vl,
// output logic  [1:0]               lrq_lsu2_rf_vlmul,
output logic  [2:0]               lrq_lsu2_rf_vlmul,  //pwh 8 for rvv1.0
output logic  [3:0]               lrq_lsu2_rf_vls_size,
output logic                      lrq_lsu2_rf_vmask_vld,
output logic  [7:0]               lrq_lsu2_rf_vmb_id,
output logic                      lrq_lsu2_rf_vmb_merge_vld,
output logic  [VREG-1:0]          lrq_lsu2_rf_vreg,
//output logic  [1:0]               lrq_lsu2_rf_vsew, // not use in rvv1.0 @hcl
output logic  [1:0]               lrq_lsu2_rf_vmew,
output logic  [1:0]               lrq_lsu2_rf_vmop,
output logic                      lrq_lsu2_rf_nf,
output logic                      lrq_lsu2_rf_pa_vld,
output logic  [`WK_PA_WIDTH-13:0] lrq_lsu2_rf_pa,
output logic  [4:0]               lrq_lsu2_rf_attr,
output logic  [3:0]               lrq_lsu2_rf_fence_mode,    // wjh@lrq
output logic                      lrq_lsu2_rf_is_load,       // wjh@lrq
output logic                      lrq_lsu2_rf_icc,           // wjh@lrq
output logic                      lrq_lsu2_rf_idx_ord,       // wjh@lrq
output logic  [31:0]              lrq_lsu2_rf_inst_code,     // wjh@lrq
output logic  [PC_LEN-1:0]        lrq_lsu2_rf_sfp_dst_pc,
output logic                      lrq_lsu2_rf_sfp_pc_hit,
output logic                      lrq_lsu2_rf_inst_flush,    // wjh@lrq
output logic  [1:0]               lrq_lsu2_rf_inst_mode,     // wjh@lrq
output logic                      lrq_lsu2_rf_inst_share,    // wjh@lrq
output logic                      lrq_lsu2_rf_inst_str,      // wjh@lrq
output logic                      lrq_lsu2_rf_mmu_req,       // wjh@lrq
output logic  [SDIQENTRY-1:0]     lrq_lsu2_rf_sdiq_entry,    // wjh@lrq
output logic                      lrq_lsu2_rf_st,            // wjh@lrq
output logic                      lrq_lsu2_rf_staddr,        // wjh@lrq
output logic                      lrq_lsu2_rf_sync_fence,    // wjh@lrq
output logic  [LRQENTRY-1:0]      lrq_lsu2_ex1_lrqid,
output logic                      lrq2_hit_no_spec_tbl, // !!! extension
output logic  [LSIQENTRY-1:0]     lrq2_idu_exx_wakeup,
output logic  [LSIQENTRY-1:0]     lrq2_idu_ex3_pop_entry,
output logic                      lrq2_idu_ex3_pop_vld,
// lsu3
output logic                      lrq_lsu3_rf_replay_vld,
output logic  [63:0]              lrq_lsu3_rf_va,
output logic  [15:0]              lrq_lsu3_rf_bytes_vld,
output logic  [15:0]              lrq_lsu3_rf_bytes_vld1,
output logic  [15:0]              lrq_lsu3_rf_bytes_vld2,
output logic  [15:0]              lrq_lsu3_rf_bytes_vld3,
output logic  [15:0]              lrq_lsu3_rf_reg_bytes_vld,
output logic  [15:0]              lrq_lsu3_rf_reg_bytes_vld1,
output logic  [15:0]              lrq_lsu3_rf_reg_bytes_vld2,
output logic  [15:0]              lrq_lsu3_rf_reg_bytes_vld3,
output logic                      lrq_lsu3_rf_boundary,
output logic                      lrq_lsu3_rf_already_da,
output logic                      lrq_lsu3_rf_atomic,
output logic                      lrq_lsu3_rf_gateclk_sel,
output logic  [IID_WIDTH-1:0]     lrq_lsu3_rf_iid,
output logic                      lrq_lsu3_rf_inst_fls,
output logic                      lrq_lsu3_rf_inst_fof,
output logic                      lrq_lsu3_rf_inst_ldr,
output logic  [1:0]               lrq_lsu3_rf_inst_size,
output logic  [1:0]               lrq_lsu3_rf_inst_type,
output logic                      lrq_lsu3_rf_inst_vls,
output logic  [LRQENTRY-1:0]      lrq_lsu3_rf_lch_entry, // special care
output logic                      lrq_lsu3_rf_lsfifo,
//output logic  [2:0]               lrq_lsu3_rf_mlen,  //not use in rvv1.0 @hcl
output logic  [1:0]               lrq_lsu3_rf_no_spec,
output logic                      lrq_lsu3_rf_no_spec_exist,
output logic                      lrq_lsu3_rf_zext,
output logic  [11:0]              lrq_lsu3_rf_offset,
output logic  [12:0]              lrq_lsu3_rf_offset_plus,
output logic                      lrq_lsu3_rf_oldest, // special care
output logic  [14:0]              lrq_lsu3_rf_pc,
output logic  [PREG-1:0]          lrq_lsu3_rf_preg,
output logic                      lrq_lsu3_rf_sel, // special care
output logic                      lrq_lsu3_rf_older_vld, // wjh@timing
output logic  [3:0]               lrq_lsu3_rf_shift,
output logic                      lrq_lsu3_rf_sext,
output logic                      lrq_lsu3_rf_spec_fail,
output logic                      lrq_lsu3_rf_split,
output logic  [8:0]               lrq_lsu3_rf_split_num,
output logic  [63:0]              lrq_lsu3_rf_src0,
output logic  [63:0]              lrq_lsu3_rf_src1,
output logic  [255:0]             lrq_lsu3_rf_srcvm_vr0,
output logic  [255:0]             lrq_lsu3_rf_srcvm_vr1,
output logic                      lrq_lsu3_rf_unal2nd,
output logic                      lrq_lsu3_rf_unit_stride,
output logic  [`VL_WIDTH-1:0]               lrq_lsu3_rf_vl,
// output logic  [1:0]               lrq_lsu3_rf_vlmul,
output logic  [2:0]               lrq_lsu3_rf_vlmul,  //pwh 9 for rvv1.0
output logic  [3:0]               lrq_lsu3_rf_vls_size,
output logic                      lrq_lsu3_rf_vmask_vld,
output logic  [7:0]               lrq_lsu3_rf_vmb_id,
output logic                      lrq_lsu3_rf_vmb_merge_vld,
output logic  [VREG-1:0]          lrq_lsu3_rf_vreg,
//output logic  [1:0]               lrq_lsu3_rf_vsew, // not use in rvv1.0 @hcl
output logic  [1:0]               lrq_lsu3_rf_vmew,
output logic  [1:0]               lrq_lsu3_rf_vmop,
output logic                      lrq_lsu3_rf_nf,
output logic                      lrq_lsu3_rf_pa_vld,
output logic  [`WK_PA_WIDTH-13:0] lrq_lsu3_rf_pa,
output logic  [4:0]               lrq_lsu3_rf_attr,
output logic                      lrq_lsu3_rf_is_load,
output logic  [3:0]               lrq_lsu3_rf_fence_mode,    // wjh@lrq
output logic                      lrq_lsu3_rf_icc,           // wjh@lrq
output logic                      lrq_lsu3_rf_idx_ord,       // wjh@lrq
output logic  [31:0]              lrq_lsu3_rf_inst_code,     // wjh@lrq
output logic  [PC_LEN-1:0]        lrq_lsu3_rf_sfp_dst_pc,
output logic                      lrq_lsu3_rf_sfp_pc_hit,
output logic                      lrq_lsu3_rf_inst_flush,    // wjh@lrq
output logic  [1:0]               lrq_lsu3_rf_inst_mode,     // wjh@lrq
output logic                      lrq_lsu3_rf_inst_share,    // wjh@lrq
output logic                      lrq_lsu3_rf_inst_str,      // wjh@lrq
output logic                      lrq_lsu3_rf_mmu_req,       // wjh@lrq
output logic  [SDIQENTRY-1:0]     lrq_lsu3_rf_sdiq_entry,    // wjh@lrq
output logic                      lrq_lsu3_rf_st,            // wjh@lrq
output logic                      lrq_lsu3_rf_staddr,        // wjh@lrq
output logic                      lrq_lsu3_rf_sync_fence,    // wjh@lrq
output logic  [LRQENTRY-1:0]      lrq_lsu3_ex1_lrqid,
output logic                      lrq3_hit_no_spec_tbl, // !!! extension
output logic  [LSIQENTRY-1:0]     lrq3_idu_exx_wakeup,
output logic  [LSIQENTRY-1:0]     lrq3_idu_ex3_pop_entry,
output logic                      lrq3_idu_ex3_pop_vld,
output logic                      lrq_fence_aft_load,
output logic                      lrq_fence_aft_store,
output logic                      lrq_has_load,
output logic                      lrq_has_store,
output logic                      lrq_has_fence

);

parameter LRQ_ATTR          = 5 - 1;
parameter LRQ_PA            = LRQ_ATTR + `WK_PA_PAGE_NUM_WIDTH;
parameter LRQ_PA_VLD        = LRQ_PA + 1;
parameter LRQ_SYNC_FENCE    = LRQ_PA_VLD + 1;
parameter LRQ_STADDR        = LRQ_SYNC_FENCE + 1;
parameter LRQ_ST            = LRQ_STADDR + 1;
parameter LRQ_SDIQ_ENTRY    = LRQ_ST + SDIQENTRY;
parameter LRQ_MMU_REQ       = LRQ_SDIQ_ENTRY + 1;
parameter LRQ_INST_STR      = LRQ_MMU_REQ + 1;
parameter LRQ_INST_SHARE    = LRQ_INST_STR + 1;
parameter LRQ_INST_MODE     = LRQ_INST_SHARE + 2;
parameter LRQ_INST_FLUSH    = LRQ_INST_MODE + 1;
parameter LRQ_IDX_ORD       = LRQ_INST_FLUSH + 1;
parameter LRQ_ICC           = LRQ_IDX_ORD + 1;
parameter LRQ_FENCE_MODE    = LRQ_ICC + 4;
parameter LRQ_IS_LOAD       = LRQ_FENCE_MODE + 1;
parameter LRQ_VMEW          = LRQ_IS_LOAD + 2; // for rvv mew @hcl
parameter LRQ_VMOP          = LRQ_VMEW + 2;
parameter LRQ_NF            = LRQ_VMOP + 1;
parameter LRQ_VREG          = LRQ_NF + VREG; // for rvv mop @hcl
parameter LRQ_VMB_MERGE_VLD = LRQ_VREG + 1;
parameter LRQ_VMB_ID        = LRQ_VMB_MERGE_VLD + VMBENTRY;
parameter LRQ_VLS_SIZE      = LRQ_VMB_ID + 4;
// parameter LRQ_VLMUL         = LRQ_VLS_SIZE + 2;
parameter LRQ_VLMUL         = LRQ_VLS_SIZE + 3;  //pwh 10 for rvv1.0
parameter LRQ_UNIT_STRIDE   = LRQ_VLMUL + 1;
parameter LRQ_UNAL2ND       = LRQ_UNIT_STRIDE + 1;
parameter LRQ_SPLIT_NUM     = LRQ_UNAL2ND + 9;
parameter LRQ_SPLIT         = LRQ_SPLIT_NUM + 1;
parameter LRQ_SPEC_FAIL     = LRQ_SPLIT + 1;
parameter LRQ_SEXT          = LRQ_SPEC_FAIL + 1;
parameter LRQ_PREG          = LRQ_SEXT + PREG;
parameter LRQ_PC            = LRQ_PREG + PC_LEN;
parameter LRQ_LSFIFO        = LRQ_PC + 1;
parameter LRQ_OLDEST        = LRQ_LSFIFO + 1;
parameter LRQ_INST_VLS      = LRQ_OLDEST + 1;
parameter LRQ_INST_TYPE     = LRQ_INST_VLS + 2;
parameter LRQ_INST_SIZE     = LRQ_INST_TYPE + 2;
parameter LRQ_INST_FOF      = LRQ_INST_SIZE + 1;
parameter LRQ_INST_FLS      = LRQ_INST_FOF + 1;
parameter LRQ_IID           = LRQ_INST_FLS + IID_WIDTH;
parameter LRQ_BKPTB_DATA    = LRQ_IID + 1;
parameter LRQ_BKPTA_DATA    = LRQ_BKPTB_DATA + 1;
parameter LRQ_ATOMIC        = LRQ_BKPTA_DATA + 1;
parameter LRQ_ALREADY_DA    = LRQ_ATOMIC + 1;
parameter LRQ_VA            = LRQ_ALREADY_DA + 64;
parameter LRQ_BOUNDARY      = LRQ_VA + 1;
parameter LRQ_REG_BYTES_VLD = LRQ_BOUNDARY + 16;
parameter LRQ_REG_BYTES_VLD1 = LRQ_REG_BYTES_VLD + 16;
parameter LRQ_REG_BYTES_VLD2 = LRQ_REG_BYTES_VLD1 + 16;
parameter LRQ_REG_BYTES_VLD3 = LRQ_REG_BYTES_VLD2 + 16;
parameter LRQ_BYTES_VLD      = LRQ_REG_BYTES_VLD3 + 16;
parameter LRQ_BYTES_VLD1     = LRQ_BYTES_VLD + 16;
parameter LRQ_BYTES_VLD2     = LRQ_BYTES_VLD1 + 16;
parameter LRQ_BYTES_VLD3     = LRQ_BYTES_VLD2 + 16;
parameter LRQ_NOSPEC_EXIST   = LRQ_BYTES_VLD3 + 1;
parameter LRQ_WIDTH          = LRQ_NOSPEC_EXIST + 1;

logic [LRQENTRY-1:0]   lrq0_entry_vld;
logic [LRQENTRY-1:0]   lrq0_create_ptr0;
logic [LRQENTRY-1:0]   lrq0_create_ptr1;
logic                  lrq0_create_success;
logic [LRQENTRY-1:0]   lrq0_create_vld;
logic                  lrq0_create_frz;
logic                  lrq0_full;
logic                  lrq0_less_2;
logic                  lrq0_less_3;
logic                  lrq0_no_space;
logic [LRQENTRY-1:0]   lsu0_lrq_ex1_pa_set_ptr;

logic [LRQENTRY-1:0]   lrq0_entry_create_local_agevec;
logic [3*LRQENTRY-1:0] lrq0_entry_create_global_agevec;
logic [LRQENTRY-1:0]   lrq0_entry_create_agevec0_x;
logic [LRQENTRY-1:0]   lrq0_entry_create_agevec2_x;
logic [LRQENTRY-1:0]   lrq0_entry_create_agevec3_x;
logic                  lrq0_local_agevec_updt_vld;
logic                  lrq0_global_agevec_updt_vld;
logic [LRQENTRY-1:0]   lrq0_local_pop_vld_b;
logic [3*LRQENTRY-1:0] lrq0_global_pop_vld_b;
logic [LRQENTRY-1:0]   rdy_pre_vec0;
logic [LRQENTRY-1:0]   rdy_pre0;
logic [LRQENTRY-1:0]   rdy0;
logic [LRQENTRY-1:0]   lrq0_entry_aft_load;
logic [LRQENTRY-1:0]   lrq0_entry_aft_store;
logic [LRQENTRY-1:0]   lrq0_entry_issued;
logic [LRQENTRY-1:0]   lrq0_entry_load;
// logic                  lrq0_idu_ex0_pop_vld;
// logic [LSIQENTRY-1:0]  lrq0_idu_ex0_pop_entry;

logic                  lrq0_has_rdy;
logic                  lsu0_issue_sel_lrq; // 0-idu, 1-lrq
logic                  lsu0_issue_sel_idu;
logic                  lsu0_rdy_older_idu;
logic [LRQENTRY-1:0]   lrq0_rdy_older_ex1;
logic                  idu0_iid_older_ex1;

logic                  lsu0_issue_permit;
logic                  lsu0_issue_permit_idu;
logic                  lsu0_issue_permit_lrq;
logic [LRQENTRY-1:0]   lrq0_entry_issue_grnt;
logic [LRQENTRY-1:0][LRQ_WIDTH-1:0] lrq0_read_data;
logic [LRQ_WIDTH-1:0] lrq0_rdy_data;


// lrq2
logic [LRQENTRY-1:0]   lrq2_entry_vld;
logic [LRQENTRY-1:0]   lrq2_create_ptr0;
logic [LRQENTRY-1:0]   lrq2_create_ptr1;
logic                  lrq2_create_success;
logic [LRQENTRY-1:0]   lrq2_create_vld;
logic                  lrq2_create_frz;
logic                  lrq2_full;
logic                  lrq2_less_2;
logic                  lrq2_less_3;
logic                  lrq2_no_space;
logic [LRQENTRY-1:0]   lsu2_lrq_ex1_pa_set_ptr;

logic [LRQENTRY-1:0]   lrq2_entry_create_local_agevec;
logic [3*LRQENTRY-1:0] lrq2_entry_create_global_agevec;
logic [LRQENTRY-1:0]   lrq2_entry_create_agevec0_x;
logic [LRQENTRY-1:0]   lrq2_entry_create_agevec2_x;
logic [LRQENTRY-1:0]   lrq2_entry_create_agevec3_x;
logic                  lrq2_local_agevec_updt_vld;
logic                  lrq2_global_agevec_updt_vld;
logic [LRQENTRY-1:0]   lrq2_local_pop_vld_b;
logic [3*LRQENTRY-1:0] lrq2_global_pop_vld_b;
logic [LRQENTRY-1:0]   rdy_pre_vec2;
logic [LRQENTRY-1:0]   rdy_pre2;
logic [LRQENTRY-1:0]   rdy2;
logic [LRQENTRY-1:0]   lrq2_entry_sync_fence;
logic [LRQENTRY-1:0]   lrq2_entry_aft_load;
logic [LRQENTRY-1:0]   lrq2_entry_aft_store;
logic [LRQENTRY-1:0]   lrq2_entry_issued;
logic [LRQENTRY-1:0]   lrq2_entry_load;
logic [LRQENTRY-1:0]   lrq2_entry_store;

logic                  lrq2_has_rdy;
logic                  lsu2_issue_sel_lrq; // 0-idu, 1-lrq
logic                  lsu2_issue_sel_idu;
logic                  lsu2_rdy_older_idu;
logic [LRQENTRY-1:0]   lrq2_rdy_older_ex1;
logic                  idu2_iid_older_ex1;

logic                  lsu2_issue_permit;
logic                  lsu2_issue_permit_idu;
logic                  lsu2_issue_permit_lrq;
logic [LRQENTRY-1:0]   lrq2_entry_issue_grnt;
logic [LRQENTRY-1:0][LRQ_WIDTH-1:0] lrq2_read_data;
logic [LRQ_WIDTH-1:0] lrq2_rdy_data;

// lrq3
logic [LRQENTRY-1:0]   lrq3_entry_vld;
logic [LRQENTRY-1:0]   lrq3_create_ptr0;
logic [LRQENTRY-1:0]   lrq3_create_ptr1;
logic                  lrq3_create_success;
logic [LRQENTRY-1:0]   lrq3_create_vld;
logic                  lrq3_create_frz;
logic                  lrq3_full;
logic                  lrq3_less_2;
logic                  lrq3_less_3;
logic                  lrq3_no_space;
logic [LRQENTRY-1:0]   lsu3_lrq_ex1_pa_set_ptr;

logic [LRQENTRY-1:0]   lrq3_entry_create_local_agevec;
logic [3*LRQENTRY-1:0] lrq3_entry_create_global_agevec;
logic [LRQENTRY-1:0]   lrq3_entry_create_agevec0_x;
logic [LRQENTRY-1:0]   lrq3_entry_create_agevec2_x;
logic [LRQENTRY-1:0]   lrq3_entry_create_agevec3_x;
logic                  lrq3_local_agevec_updt_vld;
logic                  lrq3_global_agevec_updt_vld;
logic [LRQENTRY-1:0]   lrq3_local_pop_vld_b;
logic [3*LRQENTRY-1:0] lrq3_global_pop_vld_b;
logic [LRQENTRY-1:0]   rdy_pre_vec3;
logic [LRQENTRY-1:0]   rdy_pre3;
logic [LRQENTRY-1:0]   rdy3;
logic [LRQENTRY-1:0]   lrq3_entry_sync_fence;
logic [LRQENTRY-1:0]   lrq3_entry_aft_load;
logic [LRQENTRY-1:0]   lrq3_entry_aft_store;
logic [LRQENTRY-1:0]   lrq3_entry_issued;
logic [LRQENTRY-1:0]   lrq3_entry_load;
logic [LRQENTRY-1:0]   lrq3_entry_store;

logic                  lrq3_has_rdy;
logic                  lsu3_issue_sel_lrq; // 0-idu, 1-lrq
logic                  lsu3_issue_sel_idu;
logic                  lsu3_rdy_older_idu;
logic [LRQENTRY-1:0]   lrq3_rdy_older_ex1;
logic                  idu3_iid_older_ex1;

logic                  lsu3_issue_permit;
logic                  lsu3_issue_permit_idu;
logic                  lsu3_issue_permit_lrq;
logic [LRQENTRY-1:0]   lrq3_entry_issue_grnt;
logic [LRQENTRY-1:0][LRQ_WIDTH-1:0] lrq3_read_data;
logic [LRQ_WIDTH-1:0] lrq3_rdy_data;

// cross
logic                  lrq_create_old20;
logic                  lrq_create_old30;
logic                  lrq_create_old32;
logic [3*LRQENTRY-1:0] lrq_old_vld;
logic [IID_WIDTH-1:0]  lrq_old_iid;
logic                  lrq_iid_older_than_idu;
logic                  lrq_older_than_lsiq;
logic [2*LRQENTRY-1:0] lrq_entry_bar_ptr;
logic                  lrq_has_bar;
// logic                  lrq_create_bar_chk;
logic                  lrq_bar_mode;
logic [3*LRQENTRY-1:0] lrq_oth_bar;
logic [3*LRQENTRY-1:0] lrq_oth_aft_load;
logic [3*LRQENTRY-1:0] lrq_oth_aft_store;
logic [3*LRQENTRY-1:0] lrq_oth_issued;
logic [3*LRQENTRY-1:0] lrq_oth_load;
logic [3*LRQENTRY-1:0] lrq_oth_store;
logic [3*LRQENTRY-1:0][IID_WIDTH-1:0] lrq_all_iid;
logic [3*LRQENTRY-1:0] lrq_all_vld;
logic [LRQENTRY-1:0]   lrq0_rdy_older_idu;
logic [LRQENTRY-1:0]   lrq2_rdy_older_idu;
logic [LRQENTRY-1:0]   lrq3_rdy_older_idu;
logic                  lsu0_issue_sel_lrq_final;
logic                  lsu2_issue_sel_lrq_final;
logic                  lsu3_issue_sel_lrq_final;
// logic                  lrq_has_load;
// logic                  lrq_has_store;

logic [3*LRQENTRY-1:0] lsu0_no_spec_target;
logic [3*LRQENTRY-1:0] lsu2_no_spec_target;
logic [3*LRQENTRY-1:0] lsu3_no_spec_target;
// logic                  lrq_fence_aft_load;
// logic                  lrq_fence_aft_store;
// logic                  lrq_fence_idu2;
// logic                  lrq_fence_idu3;

logic                  rtu_ck_flush_iid_older_lsu0_iid;
logic                  rtu_ck_flush_iid_older_lsu2_iid;
logic                  rtu_ck_flush_iid_older_lsu3_iid;
// cross logics
generate 
    for(genvar i=0; i<LRQENTRY; i++)
        assign lrq3_entry_sync_fence[i] = lrq3_read_data[i][LRQ_SYNC_FENCE];
    for(genvar j=0; j<LRQENTRY; j++)
        assign lrq2_entry_sync_fence[j] = lrq2_read_data[j][LRQ_SYNC_FENCE];
endgenerate

assign lrq_has_bar        = |{lrq3_entry_vld & lrq3_entry_sync_fence, lrq2_entry_vld & lrq2_entry_sync_fence};
                            // || lsu2_lrq_ex1_inst_vld && !lsu2_lrq_ex1_is_load && lsu2_lrq_ex1_sync_fence
                            // || lsu3_lrq_ex1_inst_vld && !lsu3_lrq_ex1_is_load && lsu3_lrq_ex1_sync_fence;
assign lrq_has_load       = |(lrq_all_vld & lrq_oth_load);
                            // || lsu0_lrq_ex1_inst_vld
                            // || lsu2_lrq_ex1_inst_vld && lsu2_lrq_ex1_is_load
                            // || lsu3_lrq_ex1_inst_vld && lsu3_lrq_ex1_is_load;
assign lrq_has_store      = |(lrq_all_vld & lrq_oth_store);

assign lrq_fence_aft_load  = |{lrq3_entry_vld & lrq3_entry_sync_fence & lrq3_entry_aft_load,
                               lrq2_entry_vld & lrq2_entry_sync_fence & lrq2_entry_aft_load};
assign lrq_fence_aft_store = |{lrq3_entry_vld & lrq3_entry_sync_fence & lrq3_entry_aft_store,
                               lrq2_entry_vld & lrq2_entry_sync_fence & lrq2_entry_aft_store};
                            // || lsu2_lrq_ex1_inst_vld && !lsu2_lrq_ex1_is_load && !lsu2_lrq_ex1_sync_fence
                            // || lsu3_lrq_ex1_inst_vld && !lsu3_lrq_ex1_is_load && !lsu3_lrq_ex1_sync_fence;
// assign lrq_fence_aft_load = |(lrq_all_vld & lrq_oth_bar & lrq_oth_aft_load)
//                             || lsu2_lrq_ex1_inst_vld && !lsu2_lrq_ex1_is_load && !lsu2_lrq_ex1_sync_fence && lsu2_lrq_ex1_fence_mode[2]
//                             || lsu3_lrq_ex1_inst_vld && !lsu3_lrq_ex1_is_load && !lsu3_lrq_ex1_sync_fence && lsu3_lrq_ex1_fence_mode[2];
// assign lrq_fence_aft_store= |(lrq_all_vld & lrq_oth_bar & lrq_oth_aft_store)
//                             || lsu2_lrq_ex1_inst_vld && !lsu2_lrq_ex1_is_load && !lsu2_lrq_ex1_sync_fence && lsu2_lrq_ex1_fence_mode[3]
//                             || lsu3_lrq_ex1_inst_vld && !lsu3_lrq_ex1_is_load && !lsu3_lrq_ex1_sync_fence && lsu3_lrq_ex1_fence_mode[3];
// assign lrq_create_bar_chk = lrq_entry_has_bar
//                             || lrq2_create_success && idu_lsu2_rf_sync_fence
//                             || lrq3_create_success && idu_lsu3_rf_sync_fence;
assign lrq_bar_mode       = lrq_has_bar;
assign lrq_has_fence      = lrq_has_bar;
assign lrq_oth_bar        = {lrq3_entry_sync_fence, lrq2_entry_sync_fence, {LRQENTRY{1'b0}}};
assign lrq_oth_aft_load   = {lrq3_entry_aft_load,   lrq2_entry_aft_load,   {LRQENTRY{1'b0}}};
assign lrq_oth_aft_store  = {lrq3_entry_aft_store,  lrq2_entry_aft_store,  {LRQENTRY{1'b0}}};
assign lrq_oth_issued     = {lrq3_entry_issued,     lrq2_entry_issued,     lrq0_entry_issued};
assign lrq_oth_load       = {lrq3_entry_load,       lrq2_entry_load,       lrq0_entry_load};
assign lrq_oth_store      = {lrq3_entry_store,      lrq2_entry_store,      {LRQENTRY{1'b0}}};
assign lrq_all_vld        = {lrq3_entry_vld,        lrq2_entry_vld,        lrq0_entry_vld};

generate 
    for(genvar i=0; i<LRQENTRY; i++)begin 
        xx_lsu_lrq_entry #(
            .PREG      ( PREG      ),
            .VREG      ( VREG      ),
            .IID_WIDTH ( IID_WIDTH ),
            .VMBENTRY  ( VMBENTRY  ),
            .LRQENTRY  ( LRQENTRY  ),
            .PC_LEN    ( PC_LEN    ),
            .LRQ_WIDTH (LRQ_WIDTH  ),
            .SDIQENTRY ( SDIQENTRY )
        )
        i_xx_lsu_lrq_entry(
            .cpurst_b                       ( cpurst_b),
            .forever_cpuclk                 ( forever_cpuclk),
            .lsu_special_clk                ( lsu_special_clk),
            .cp0_lsu_icg_en                 ( cp0_lsu_icg_en),
            .pad_yy_icg_scan_en             ( pad_yy_icg_scan_en),
            .rtu_lsu_flush_fe               ( rtu_lsu_flush_fe),
            .rtu_ck_flush                   ( rtu_ck_flush),
            .rtu_ck_flush_iid               ( rtu_ck_flush_iid),
            .lrq_create_va                  ( lsu0_lrq_create_va),
            // .lrq_create_frz                 ( lsu0_lrq_create_frz),
            .lrq_create_wait_old_chk        ( lsu0_lrq_create_wait_old_chk),
            .lrq_create_bar_chk             ( lsu0_lrq_create_bar_chk),
            .lrq_create_no_spec_chk         ( lsu0_lrq_create_no_spec_chk),
            .lrq_create_no_spec_target      ( lsu0_no_spec_target),
            .lrq_create_bytes_vld           ( lsu0_lrq_create_bytes_vld),
            .lrq_create_bytes_vld1          ( lsu0_lrq_create_bytes_vld1),
            .lrq_create_bytes_vld2          ( lsu0_lrq_create_bytes_vld2),
            .lrq_create_bytes_vld3          ( lsu0_lrq_create_bytes_vld3),
            .lrq_create_reg_bytes_vld       ( lsu0_lrq_create_reg_bytes_vld),
            .lrq_create_reg_bytes_vld1      ( lsu0_lrq_create_reg_bytes_vld1),
            .lrq_create_reg_bytes_vld2      ( lsu0_lrq_create_reg_bytes_vld2),
            .lrq_create_reg_bytes_vld3      ( lsu0_lrq_create_reg_bytes_vld3),
            .lrq_create_boundary            ( lsu0_lrq_create_boundary),
            .lrq_create_atomic              ( lsu0_lrq_create_atomic),
            .lrq_create_iid                 ( lsu0_lrq_create_iid),
            .lrq_create_fls                 ( lsu0_lrq_create_fls),
            .lrq_create_fof                 ( lsu0_lrq_create_fof),
            .lrq_create_size                ( lsu0_lrq_create_size),
            .lrq_create_type                ( lsu0_lrq_create_type),
            .lrq_create_vls                 ( lsu0_lrq_create_vls),
            .lrq_create_lsfifo              ( lsu0_lrq_create_lsfifo),
            .lrq_create_pc                  ( lsu0_lrq_create_pc),
            .lrq_create_preg                ( lsu0_lrq_create_preg),
            .lrq_create_sext                ( lsu0_lrq_create_sext),
            .lrq_create_split               ( lsu0_lrq_create_split),
            .lrq_create_split_num           ( lsu0_lrq_create_split_num),
            .lrq_create_unit_stride         ( lsu0_lrq_create_unit_stride),
            .lrq_create_vlmul               ( lsu0_lrq_create_vlmul),
            .lrq_create_vls_size            ( lsu0_lrq_create_vls_size),
            .lrq_create_vmb_id              ( lsu0_lrq_create_vmb_id),
            .lrq_create_vmb_merge_vld       ( lsu0_lrq_create_vmb_merge_vld),
            .lrq_create_vreg                ( lsu0_lrq_create_vreg),
            //.lrq_create_vsew                ( lsu0_lrq_create_vsew),
            .lrq_create_vmew                ( lsu0_lrq_create_vmew),
            .lrq_create_vmop                ( lsu0_lrq_create_vmop),
            .lrq_create_nf                  ( lsu0_lrq_create_nf  ),
            .lrq_create_4kstall             ( lsu0_lrq_create_4kstall),
            .lrq_create_is_load             ( 1'b1),
            .lrq_create_fence_mode          ( {4{1'b0}}),
            .lrq_create_icc                 ( 1'b0),
            .lrq_create_idx_ord             ( 1'b0),
            .lrq_create_inst_flush          ( 1'b0),
            .lrq_create_inst_mode           ( 2'b00),
            .lrq_create_inst_share          ( 1'b0),
            .lrq_create_inst_str            ( 1'b0),
            .lrq_create_mmu_req             ( 1'b0),
            .lrq_create_sdiq_entry          ( {SDIQENTRY{1'b0}}),
            .lrq_create_st                  ( 1'b0),
            .lrq_create_staddr              ( 1'b0),
            .lrq_create_sync_fence          ( 1'b0),
            .lsu_lrq_frz_clr                ( lsu0_lrq_frz_clr[i]),
            .lsu_lrq_ex1_pa_set             ( lsu0_lrq_ex1_pa_set_ptr[i]),
            .lsu_lrq_ex1_pa                 ( lsu0_lrq_ex1_pa),
            .lsu_lrq_ex1_attr               ( lsu0_lrq_ex1_attr),
            .lsu_lrq_ex1_iid                ( lsu0_lrq_ex1_iid),// wjh@timing
            .idu_lrq_rf_iid                 ( idu_lsu0_rf_iid), // wjh@timing
            .lrq_entry_create_vld           ( lrq0_create_vld[i]),
            .lrq_entry_create_frz           ( lsu0_lrq_create_frz),
            .lrq_create_iid0                ( lsu0_lrq_create_iid),
            .lrq_create_iid2                ( lsu2_lrq_create_iid), // !! extension
            .lrq_create_iid3                ( lsu3_lrq_create_iid), // !! extension
            .lrq_create_ptr0                ( lrq0_create_vld),
            .lrq_create_ptr2                ( lrq2_create_vld), // !! extension 
            .lrq_create_ptr3                ( lrq3_create_vld), // !! extension
            .lrq_create_ptr                 ( lrq0_create_vld),
            .lrq_entry_create_local_agevec  ( lrq0_entry_create_local_agevec),
            .lrq_entry_create_global_agevec ( lrq0_entry_create_global_agevec),
            .lrq_local_agevec_updt_vld      ( lrq0_local_agevec_updt_vld),
            .lrq_global_agevec_updt_vld     ( lrq0_global_agevec_updt_vld),
            .lrq_entry_pop_vld              ( lsu0_lrq_ex3_pop_entry[i]),
            .lrq_local_pop_vld_b            ( lrq0_local_pop_vld_b),
            .lrq_global_pop_vld_b           ( lrq0_global_pop_vld_b),
            .lrq_entry_issue_grnt           ( lrq0_entry_issue_grnt[i]),
            .lrq_bar_mode                   ( lrq_bar_mode),
            .lrq_oth_bar                    ( lrq_oth_bar),
            .lrq_oth_aft_load               ( lrq_oth_aft_load),
            .lrq_oth_aft_store              ( lrq_oth_aft_store),
            .lrq_oth_issued                 ( lrq_oth_issued),
            .lrq_oth_load                   ( lrq_oth_load),
            .lrq_oth_store                  ( lrq_oth_store),
            .lsu_lrq_ex2_lq_full            ( lsu0_lrq_ex2_lq_full[i]),
            .lsu_lrq_ex2_lq_not_full        ( lsu0_lrq_ex2_lq_not_full),
            .lsu_lrq_ex2_sq_full            ( lsu0_lrq_ex2_sq_full[i]),
            .lsu_lrq_exx_sq_not_full        ( lsu0_lrq_exx_sq_not_full),
            .lsu_lrq_ex3_rb_full            ( lsu0_lrq_ex3_rb_full[i]),
            .lsu_lrq_ex3_rb_not_full        ( lsu0_lrq_ex3_rb_not_full),
            .lsu_lrq_ex1_wait_old           ( lsu0_lrq_ex1_wait_old[i]),
            .lsu_lrq_ex3_wait_fence         ( lsu0_lrq_ex3_wait_fence[i]),
            .lsu_lrq_exx_no_fence           ( lsu0_lrq_exx_no_fence),
            .lsu_lrq_ex2_tlb_busy           ( lsu0_lrq_ex2_tlb_busy[i]),
            .lsu_lrq_exx_tlb_wakeup         ( lsu0_lrq_exx_tlb_wakeup[i]),
            .lsu_lrq_ex3_secd               ( lsu0_lrq_ex3_secd[i]),
            .lsu_lrq_ex3_already_da         ( lsu0_lrq_ex3_already_da[i]),
            .lsu_lrq_ex3_spec_fail          ( lsu0_lrq_ex3_spec_fail[i]),
            .rdy_pre_vec                    ( rdy_pre_vec0),
            .lrq_older_than_lsiq            ( lrq_older_than_lsiq),
            .sfp_lsu0_no_spec_dst_pc        ( lsu0_lrq_sfp_dst_pc),
            .sfp_lsu2_no_spec_dst_pc        ( lsu2_lrq_sfp_dst_pc),
            .sfp_lsu3_no_spec_dst_pc        ( lsu3_lrq_sfp_dst_pc),
            .lrq_rdy_older_ex1              ( lrq0_rdy_older_ex1[i]), // wjh@timing
            .lrq_rdy_older_idu              ( lrq0_rdy_older_idu[i]), // wjh@timing
            .lrq_read_data                  ( lrq0_read_data[i]),
            .lrq_entry_vld_x                ( lrq0_entry_vld[i]),
            .lrq_entry_create_agevec0_x     ( lrq0_entry_create_agevec0_x[i]),
            .lrq_entry_create_agevec2_x     ( lrq0_entry_create_agevec2_x[i]),
            .lrq_entry_create_agevec3_x     ( lrq0_entry_create_agevec3_x[i]),
            .lrq_entry_aft_load_x           ( lrq0_entry_aft_load[i]),
            .lrq_entry_aft_store_x          ( lrq0_entry_aft_store[i]),
            .lrq_entry_issued_x             ( lrq0_entry_issued[i]),
            .lrq_entry_load_x               ( lrq0_entry_load[i]),
            .lrq_entry_store_x              ( /*floating*/),
            .lrq_old_vld_x                  ( lrq_old_vld[i]),
            .rdy_pre_x                      ( rdy_pre0[i]),
            .lsu0_no_spec_target_x          ( lsu0_no_spec_target[i]),
            .lsu2_no_spec_target_x          ( lsu2_no_spec_target[i]),
            .lsu3_no_spec_target_x          ( lsu3_no_spec_target[i]),
            .rdy_x                          ( rdy0[i])
        );
    end 
endgenerate
// lrq2
generate 
    for(genvar i=0; i<LRQENTRY; i++)begin 
        xx_lsu_lrq_entry #(
            .PREG      ( PREG      ),
            .VREG      ( VREG      ),
            .IID_WIDTH ( IID_WIDTH ),
            .VMBENTRY  ( VMBENTRY  ),
            .LRQENTRY  ( LRQENTRY  ),
            .PC_LEN    ( PC_LEN    ),
            .LRQ_WIDTH (LRQ_WIDTH  ),
            .SDIQENTRY ( SDIQENTRY )
        )
        i_xx_lsu_lrq_entry(
            .cpurst_b                       ( cpurst_b),
            .forever_cpuclk                 ( forever_cpuclk),
            .lsu_special_clk                ( lsu_special_clk),
            .cp0_lsu_icg_en                 ( cp0_lsu_icg_en),
            .pad_yy_icg_scan_en             ( pad_yy_icg_scan_en),
            .rtu_lsu_flush_fe               ( rtu_lsu_flush_fe),
            .rtu_ck_flush                   ( rtu_ck_flush),
            .rtu_ck_flush_iid               ( rtu_ck_flush_iid),
            .lrq_create_va                  ( lsu2_lrq_create_va),
            .lrq_create_wait_old_chk        ( lsu2_lrq_create_wait_old_chk),
            .lrq_create_bar_chk             ( lsu2_lrq_create_bar_chk),
            .lrq_create_no_spec_chk         ( lsu2_lrq_create_no_spec_chk),
            .lrq_create_no_spec_target      ( lsu2_no_spec_target),
            .lrq_create_bytes_vld           ( lsu2_lrq_create_bytes_vld),
            .lrq_create_bytes_vld1          ( lsu2_lrq_create_bytes_vld1),
            .lrq_create_bytes_vld2          ( lsu2_lrq_create_bytes_vld2),
            .lrq_create_bytes_vld3          ( lsu2_lrq_create_bytes_vld3),
            .lrq_create_reg_bytes_vld       ( lsu2_lrq_create_reg_bytes_vld),
            .lrq_create_reg_bytes_vld1      ( lsu2_lrq_create_reg_bytes_vld1),
            .lrq_create_reg_bytes_vld2      ( lsu2_lrq_create_reg_bytes_vld2),
            .lrq_create_reg_bytes_vld3      ( lsu2_lrq_create_reg_bytes_vld3),
            .lrq_create_boundary            ( lsu2_lrq_create_boundary),
            .lrq_create_atomic              ( lsu2_lrq_create_atomic),
            .lrq_create_iid                 ( lsu2_lrq_create_iid),
            .lrq_create_fls                 ( lsu2_lrq_create_fls),
            .lrq_create_fof                 ( lsu2_lrq_create_fof),
            .lrq_create_size                ( lsu2_lrq_create_size),
            .lrq_create_type                ( lsu2_lrq_create_type),
            .lrq_create_vls                 ( lsu2_lrq_create_vls),
            .lrq_create_lsfifo              ( lsu2_lrq_create_lsfifo),
            .lrq_create_pc                  ( lsu2_lrq_create_pc),
            .lrq_create_preg                ( lsu2_lrq_create_preg),
            .lrq_create_sext                ( lsu2_lrq_create_sext),
            .lrq_create_split               ( lsu2_lrq_create_split),
            .lrq_create_split_num           ( lsu2_lrq_create_split_num),
            .lrq_create_unit_stride         ( lsu2_lrq_create_unit_stride),
            .lrq_create_vlmul               ( lsu2_lrq_create_vlmul),
            .lrq_create_vls_size            ( lsu2_lrq_create_vls_size),
            .lrq_create_vmb_id              ( lsu2_lrq_create_vmb_id),
            .lrq_create_vmb_merge_vld       ( lsu2_lrq_create_vmb_merge_vld),
            .lrq_create_vreg                ( lsu2_lrq_create_vreg),
            //.lrq_create_vsew                ( lsu2_lrq_create_vsew),
            .lrq_create_vmew                ( lsu2_lrq_create_vmew),
            .lrq_create_vmop                ( lsu2_lrq_create_vmop),
            .lrq_create_nf                  ( lsu2_lrq_create_nf  ),
            .lrq_create_4kstall             ( lsu2_lrq_create_4kstall),
            .lrq_create_is_load             ( lsu2_lrq_create_is_load),
            .lrq_create_fence_mode          ( lsu2_lrq_create_fence_mode),
            .lrq_create_icc                 ( lsu2_lrq_create_icc),
            .lrq_create_idx_ord             ( lsu2_lrq_create_idx_ord),
            .lrq_create_inst_flush          ( lsu2_lrq_create_inst_flush),
            .lrq_create_inst_mode           ( lsu2_lrq_create_inst_mode),
            .lrq_create_inst_share          ( lsu2_lrq_create_inst_share),
            .lrq_create_inst_str            ( lsu2_lrq_create_inst_str),
            .lrq_create_mmu_req             ( lsu2_lrq_create_mmu_req),
            .lrq_create_sdiq_entry          ( lsu2_lrq_create_sdiq_entry),
            .lrq_create_st                  ( lsu2_lrq_create_st),
            .lrq_create_staddr              ( lsu2_lrq_create_staddr),
            .lrq_create_sync_fence          ( lsu2_lrq_create_sync_fence),
            .lsu_lrq_frz_clr                ( lsu2_lrq_frz_clr[i]),
            .lsu_lrq_ex1_pa_set             ( lsu2_lrq_ex1_pa_set_ptr[i]),
            .lsu_lrq_ex1_pa                 ( lsu2_lrq_ex1_pa),
            .lsu_lrq_ex1_attr               ( lsu2_lrq_ex1_attr),
            .lsu_lrq_ex1_iid                ( lsu2_lrq_ex1_iid),// wjh@timing
            .idu_lrq_rf_iid                 ( idu_lsu2_rf_iid), // wjh@timing
            .lrq_entry_create_vld           ( lrq2_create_vld[i]),
            .lrq_entry_create_frz           ( lsu2_lrq_create_frz),
            .lrq_create_iid0                ( lsu0_lrq_create_iid),
            .lrq_create_iid2                ( lsu2_lrq_create_iid), // !! extension
            .lrq_create_iid3                ( lsu3_lrq_create_iid), // !! extension
            .lrq_create_ptr0                ( lrq0_create_vld),
            .lrq_create_ptr2                ( lrq2_create_vld), // !! extension 
            .lrq_create_ptr3                ( lrq3_create_vld), // !! extension
            .lrq_create_ptr                 ( lrq2_create_vld),
            .lrq_entry_create_local_agevec  ( lrq2_entry_create_local_agevec),
            .lrq_entry_create_global_agevec ( lrq2_entry_create_global_agevec),
            .lrq_local_agevec_updt_vld      ( lrq2_local_agevec_updt_vld),
            .lrq_global_agevec_updt_vld     ( lrq2_global_agevec_updt_vld),
            .lrq_entry_pop_vld              ( lsu2_lrq_ex3_pop_entry[i]),
            .lrq_local_pop_vld_b            ( lrq2_local_pop_vld_b),
            .lrq_global_pop_vld_b           ( lrq2_global_pop_vld_b),
            .lrq_entry_issue_grnt           ( lrq2_entry_issue_grnt[i]),
            .lrq_bar_mode                   ( lrq_bar_mode),
            .lrq_oth_bar                    ( lrq_oth_bar),
            .lrq_oth_aft_load               ( lrq_oth_aft_load),
            .lrq_oth_aft_store              ( lrq_oth_aft_store),
            .lrq_oth_issued                 ( lrq_oth_issued),
            .lrq_oth_load                   ( lrq_oth_load),
            .lrq_oth_store                  ( lrq_oth_store),
            .lsu_lrq_ex2_lq_full            ( lsu2_lrq_ex2_lq_full[i]),
            .lsu_lrq_ex2_lq_not_full        ( lsu2_lrq_ex2_lq_not_full),
            .lsu_lrq_ex2_sq_full            ( lsu2_lrq_ex2_sq_full[i]),
            .lsu_lrq_exx_sq_not_full        ( lsu2_lrq_exx_sq_not_full),
            .lsu_lrq_ex3_rb_full            ( lsu2_lrq_ex3_rb_full[i]),
            .lsu_lrq_ex3_rb_not_full        ( lsu2_lrq_ex3_rb_not_full),
            .lsu_lrq_ex1_wait_old           ( lsu2_lrq_ex1_wait_old[i]),
            .lsu_lrq_ex3_wait_fence         ( lsu2_lrq_ex3_wait_fence[i]),
            .lsu_lrq_exx_no_fence           ( lsu2_lrq_exx_no_fence),
            .lsu_lrq_ex2_tlb_busy           ( lsu2_lrq_ex2_tlb_busy[i]),
            .lsu_lrq_exx_tlb_wakeup         ( lsu2_lrq_exx_tlb_wakeup[i]),
            .lsu_lrq_ex3_secd               ( lsu2_lrq_ex3_secd[i]),
            .lsu_lrq_ex3_already_da         ( lsu2_lrq_ex3_already_da[i]),
            .lsu_lrq_ex3_spec_fail          ( lsu2_lrq_ex3_spec_fail[i]),
            .rdy_pre_vec                    ( rdy_pre_vec2),
            .lrq_older_than_lsiq            ( lrq_older_than_lsiq),
            .sfp_lsu0_no_spec_dst_pc        ( lsu0_lrq_sfp_dst_pc),
            .sfp_lsu2_no_spec_dst_pc        ( lsu2_lrq_sfp_dst_pc),
            .sfp_lsu3_no_spec_dst_pc        ( lsu3_lrq_sfp_dst_pc),
            .lrq_rdy_older_ex1              ( lrq2_rdy_older_ex1[i]), // wjh@timing
            .lrq_rdy_older_idu              ( lrq2_rdy_older_idu[i]), // wjh@timing
            .lrq_read_data                  ( lrq2_read_data[i]),
            .lrq_entry_vld_x                ( lrq2_entry_vld[i]),
            .lrq_entry_create_agevec0_x     ( lrq2_entry_create_agevec0_x[i]),
            .lrq_entry_create_agevec2_x     ( lrq2_entry_create_agevec2_x[i]),
            .lrq_entry_create_agevec3_x     ( lrq2_entry_create_agevec3_x[i]),
            .lrq_entry_aft_load_x           ( lrq2_entry_aft_load[i]),
            .lrq_entry_aft_store_x          ( lrq2_entry_aft_store[i]),
            .lrq_entry_issued_x             ( lrq2_entry_issued[i]),
            .lrq_entry_load_x               ( lrq2_entry_load[i]),
            .lrq_entry_store_x              ( lrq2_entry_store[i]),
            .lrq_old_vld_x                  ( lrq_old_vld[i+LRQENTRY]),
            .rdy_pre_x                      ( rdy_pre2[i]),
            .lsu0_no_spec_target_x          ( lsu0_no_spec_target[i+LRQENTRY]),
            .lsu2_no_spec_target_x          ( lsu2_no_spec_target[i+LRQENTRY]),
            .lsu3_no_spec_target_x          ( lsu3_no_spec_target[i+LRQENTRY]),
            .rdy_x                          ( rdy2[i])
        );
    end 
endgenerate
// lrq3
generate 
    for(genvar i=0; i<LRQENTRY; i++)begin 
        xx_lsu_lrq_entry #(
            .PREG      ( PREG      ),
            .VREG      ( VREG      ),
            .IID_WIDTH ( IID_WIDTH ),
            .VMBENTRY  ( VMBENTRY  ),
            .LRQENTRY  ( LRQENTRY  ),
            .PC_LEN    ( PC_LEN    ),
            .LRQ_WIDTH (LRQ_WIDTH  ),
            .SDIQENTRY ( SDIQENTRY )
        )
        i_xx_lsu_lrq_entry(
            .cpurst_b                       ( cpurst_b),
            .forever_cpuclk                 ( forever_cpuclk),
            .lsu_special_clk                ( lsu_special_clk),
            .cp0_lsu_icg_en                 ( cp0_lsu_icg_en),
            .pad_yy_icg_scan_en             ( pad_yy_icg_scan_en),
            .rtu_lsu_flush_fe               ( rtu_lsu_flush_fe),
            .rtu_ck_flush                   ( rtu_ck_flush),
            .rtu_ck_flush_iid               ( rtu_ck_flush_iid),
            .lrq_create_va                  ( lsu3_lrq_create_va),
            .lrq_create_wait_old_chk        ( lsu3_lrq_create_wait_old_chk),
            .lrq_create_bar_chk             ( lsu3_lrq_create_bar_chk),
            .lrq_create_no_spec_chk         ( lsu3_lrq_create_no_spec_chk),
            .lrq_create_no_spec_target      ( lsu3_no_spec_target),
            .lrq_create_bytes_vld           ( lsu3_lrq_create_bytes_vld),
            .lrq_create_bytes_vld1          ( lsu3_lrq_create_bytes_vld1),
            .lrq_create_bytes_vld2          ( lsu3_lrq_create_bytes_vld2),
            .lrq_create_bytes_vld3          ( lsu3_lrq_create_bytes_vld3),
            .lrq_create_reg_bytes_vld       ( lsu3_lrq_create_reg_bytes_vld),
            .lrq_create_reg_bytes_vld1      ( lsu3_lrq_create_reg_bytes_vld1),
            .lrq_create_reg_bytes_vld2      ( lsu3_lrq_create_reg_bytes_vld2),
            .lrq_create_reg_bytes_vld3      ( lsu3_lrq_create_reg_bytes_vld3),
            .lrq_create_boundary            ( lsu3_lrq_create_boundary),
            .lrq_create_atomic              ( lsu3_lrq_create_atomic),
            .lrq_create_iid                 ( lsu3_lrq_create_iid),
            .lrq_create_fls                 ( lsu3_lrq_create_fls),
            .lrq_create_fof                 ( lsu3_lrq_create_fof),
            .lrq_create_size                ( lsu3_lrq_create_size),
            .lrq_create_type                ( lsu3_lrq_create_type),
            .lrq_create_vls                 ( lsu3_lrq_create_vls),
            .lrq_create_lsfifo              ( lsu3_lrq_create_lsfifo),
            .lrq_create_pc                  ( lsu3_lrq_create_pc),
            .lrq_create_preg                ( lsu3_lrq_create_preg),
            .lrq_create_sext                ( lsu3_lrq_create_sext),
            .lrq_create_split               ( lsu3_lrq_create_split),
            .lrq_create_split_num           ( lsu3_lrq_create_split_num),
            .lrq_create_unit_stride         ( lsu3_lrq_create_unit_stride),
            .lrq_create_vlmul               ( lsu3_lrq_create_vlmul),
            .lrq_create_vls_size            ( lsu3_lrq_create_vls_size),
            .lrq_create_vmb_id              ( lsu3_lrq_create_vmb_id),
            .lrq_create_vmb_merge_vld       ( lsu3_lrq_create_vmb_merge_vld),
            .lrq_create_vreg                ( lsu3_lrq_create_vreg),
            //.lrq_create_vsew                ( lsu3_lrq_create_vsew),
            .lrq_create_vmew                ( lsu3_lrq_create_vmew),
            .lrq_create_vmop                ( lsu3_lrq_create_vmop),
            .lrq_create_nf                  ( lsu3_lrq_create_nf  ),
            .lrq_create_4kstall             ( lsu3_lrq_create_4kstall),
            .lrq_create_is_load             ( lsu3_lrq_create_is_load),
            .lrq_create_fence_mode          ( lsu3_lrq_create_fence_mode),
            .lrq_create_icc                 ( lsu3_lrq_create_icc),
            .lrq_create_idx_ord             ( lsu3_lrq_create_idx_ord),
            .lrq_create_inst_flush          ( lsu3_lrq_create_inst_flush),
            .lrq_create_inst_mode           ( lsu3_lrq_create_inst_mode),
            .lrq_create_inst_share          ( lsu3_lrq_create_inst_share),
            .lrq_create_inst_str            ( lsu3_lrq_create_inst_str),
            .lrq_create_mmu_req             ( lsu3_lrq_create_mmu_req),
            .lrq_create_sdiq_entry          ( lsu3_lrq_create_sdiq_entry),
            .lrq_create_st                  ( lsu3_lrq_create_st),
            .lrq_create_staddr              ( lsu3_lrq_create_staddr),
            .lrq_create_sync_fence          ( lsu3_lrq_create_sync_fence),
            .lsu_lrq_frz_clr                ( lsu3_lrq_frz_clr[i]),
            .lsu_lrq_ex1_pa_set             ( lsu3_lrq_ex1_pa_set_ptr[i]),
            .lsu_lrq_ex1_pa                 ( lsu3_lrq_ex1_pa),
            .lsu_lrq_ex1_attr               ( lsu3_lrq_ex1_attr),
            .lsu_lrq_ex1_iid                ( lsu3_lrq_ex1_iid),// wjh@timing
            .idu_lrq_rf_iid                 ( idu_lsu3_rf_iid), // wjh@timing
            .lrq_entry_create_vld           ( lrq3_create_vld[i]),
            .lrq_entry_create_frz           ( lsu3_lrq_create_frz),
            .lrq_create_iid0                ( lsu0_lrq_create_iid),
            .lrq_create_iid2                ( lsu2_lrq_create_iid), // !! extension
            .lrq_create_iid3                ( lsu3_lrq_create_iid), // !! extension
            .lrq_create_ptr0                ( lrq0_create_vld),
            .lrq_create_ptr2                ( lrq2_create_vld), // !! extension 
            .lrq_create_ptr3                ( lrq3_create_vld), // !! extension
            .lrq_create_ptr                 ( lrq3_create_vld),
            .lrq_entry_create_local_agevec  ( lrq3_entry_create_local_agevec),
            .lrq_entry_create_global_agevec ( lrq3_entry_create_global_agevec),
            .lrq_local_agevec_updt_vld      ( lrq3_local_agevec_updt_vld),
            .lrq_global_agevec_updt_vld     ( lrq3_global_agevec_updt_vld),
            .lrq_entry_pop_vld              ( lsu3_lrq_ex3_pop_entry[i]),
            .lrq_local_pop_vld_b            ( lrq3_local_pop_vld_b),
            .lrq_global_pop_vld_b           ( lrq3_global_pop_vld_b),
            .lrq_entry_issue_grnt           ( lrq3_entry_issue_grnt[i]),
            .lrq_bar_mode                   ( lrq_bar_mode),
            .lrq_oth_bar                    ( lrq_oth_bar),
            .lrq_oth_aft_load               ( lrq_oth_aft_load),
            .lrq_oth_aft_store              ( lrq_oth_aft_store),
            .lrq_oth_issued                 ( lrq_oth_issued),
            .lrq_oth_load                   ( lrq_oth_load),
            .lrq_oth_store                  ( lrq_oth_store),
            .lsu_lrq_ex2_lq_full            ( lsu3_lrq_ex2_lq_full[i]),
            .lsu_lrq_ex2_lq_not_full        ( lsu3_lrq_ex2_lq_not_full),
            .lsu_lrq_ex2_sq_full            ( lsu3_lrq_ex2_sq_full[i]),
            .lsu_lrq_exx_sq_not_full        ( lsu3_lrq_exx_sq_not_full),
            .lsu_lrq_ex3_rb_full            ( lsu3_lrq_ex3_rb_full[i]),
            .lsu_lrq_ex3_rb_not_full        ( lsu3_lrq_ex3_rb_not_full),
            .lsu_lrq_ex1_wait_old           ( lsu3_lrq_ex1_wait_old[i]),
            .lsu_lrq_ex3_wait_fence         ( lsu3_lrq_ex3_wait_fence[i]),
            .lsu_lrq_exx_no_fence           ( lsu3_lrq_exx_no_fence),
            .lsu_lrq_ex2_tlb_busy           ( lsu3_lrq_ex2_tlb_busy[i]),
            .lsu_lrq_exx_tlb_wakeup         ( lsu3_lrq_exx_tlb_wakeup[i]),
            .lsu_lrq_ex3_secd               ( lsu3_lrq_ex3_secd[i]),
            .lsu_lrq_ex3_already_da         ( lsu3_lrq_ex3_already_da[i]),
            .lsu_lrq_ex3_spec_fail          ( lsu3_lrq_ex3_spec_fail[i]),
            .rdy_pre_vec                    ( rdy_pre_vec3),
            .lrq_older_than_lsiq            ( lrq_older_than_lsiq),
            .sfp_lsu0_no_spec_dst_pc        ( lsu0_lrq_sfp_dst_pc),
            .sfp_lsu2_no_spec_dst_pc        ( lsu2_lrq_sfp_dst_pc),
            .sfp_lsu3_no_spec_dst_pc        ( lsu3_lrq_sfp_dst_pc),
            .lrq_rdy_older_ex1              ( lrq3_rdy_older_ex1[i]), // wjh@timing
            .lrq_rdy_older_idu              ( lrq3_rdy_older_idu[i]), // wjh@timing
            .lrq_read_data                  ( lrq3_read_data[i]),
            .lrq_entry_vld_x                ( lrq3_entry_vld[i]),
            .lrq_entry_create_agevec0_x     ( lrq3_entry_create_agevec0_x[i]),
            .lrq_entry_create_agevec2_x     ( lrq3_entry_create_agevec2_x[i]),
            .lrq_entry_create_agevec3_x     ( lrq3_entry_create_agevec3_x[i]),
            .lrq_entry_aft_load_x           ( lrq3_entry_aft_load[i]),
            .lrq_entry_aft_store_x          ( lrq3_entry_aft_store[i]),
            .lrq_entry_issued_x             ( lrq3_entry_issued[i]),
            .lrq_entry_load_x               ( lrq3_entry_load[i]),
            .lrq_entry_store_x              ( lrq3_entry_store[i]),
            .lrq_old_vld_x                  ( lrq_old_vld[i+2*LRQENTRY]),
            .rdy_pre_x                      ( rdy_pre3[i]),
            .lsu0_no_spec_target_x          ( lsu0_no_spec_target[i+2*LRQENTRY]),
            .lsu2_no_spec_target_x          ( lsu2_no_spec_target[i+2*LRQENTRY]),
            .lsu3_no_spec_target_x          ( lsu3_no_spec_target[i+2*LRQENTRY]),
            .rdy_x                          ( rdy3[i])
        );
    end 
endgenerate



// assign lrq2_entry_create_agevec0_x = {LRQENTRY{1'b0}}; // lsu0 checkon lrq2 for global age
// assign lrq2_entry_create_agevec2_x = {LRQENTRY{1'b0}}; // lsu2 checkon lrq2 for global age
// assign lrq2_entry_create_agevec3_x = {LRQENTRY{1'b0}}; // lsu3 checkon lrq2 for global age
// assign lrq3_entry_create_agevec0_x = {LRQENTRY{1'b0}}; // lsu0 checkon lrq3 for global age
// assign lrq3_entry_create_agevec2_x = {LRQENTRY{1'b0}}; // lsu2 checkon lrq3 for global age
// assign lrq3_entry_create_agevec3_x = {LRQENTRY{1'b0}}; // lsu3 checkon lrq3 for global age
// pa-set
assign lsu0_lrq_ex1_pa_set_ptr = {LRQENTRY{lsu0_lrq_ex1_pa_set}} & lsu0_lrq_ex1_lrqid;
assign lsu2_lrq_ex1_pa_set_ptr = {LRQENTRY{lsu2_lrq_ex1_pa_set}} & lsu2_lrq_ex1_lrqid;
assign lsu3_lrq_ex1_pa_set_ptr = {LRQENTRY{lsu3_lrq_ex1_pa_set}} & lsu3_lrq_ex1_lrqid;

//
com_ff1_from_lsb #(.WIDTH(LRQENTRY)) i_wk_find_1st_0_lrq0(
    .in_data  ( ~lrq0_entry_vld),
    .out_data ( lrq0_create_ptr0)
);

assign lrq0_create_ptr1[LRQENTRY-1] = ~lrq0_entry_vld[LRQENTRY-1];
generate
    for(genvar i=LRQENTRY-2; i>=0; i--)
        assign lrq0_create_ptr1[i] = ~lrq0_entry_vld[i] & (&(lrq0_entry_vld[LRQENTRY-1:i+1]));
endgenerate

com_ff1_from_lsb #(.WIDTH(LRQENTRY)) i_wk_find_1st_0_lrq2(
    .in_data  ( ~lrq2_entry_vld),
    .out_data ( lrq2_create_ptr0)
);

assign lrq2_create_ptr1[LRQENTRY-1] = ~lrq2_entry_vld[LRQENTRY-1];
generate
    for(genvar i=LRQENTRY-2; i>=0; i--)
        assign lrq2_create_ptr1[i] = ~lrq2_entry_vld[i] & (&(lrq2_entry_vld[LRQENTRY-1:i+1]));
endgenerate

com_ff1_from_lsb #(.WIDTH(LRQENTRY)) i_wk_find_1st_0_lrq3(
    .in_data  ( ~lrq3_entry_vld),
    .out_data ( lrq3_create_ptr0)
);
assign lrq3_create_ptr1[LRQENTRY-1] = ~lrq3_entry_vld[LRQENTRY-1];
generate
    for(genvar i=LRQENTRY-2; i>=0; i--)
        assign lrq3_create_ptr1[i] = ~lrq3_entry_vld[i] & (&(lrq3_entry_vld[LRQENTRY-1:i+1]));
endgenerate

assign lrq0_full           = &lrq0_entry_vld;
assign lrq0_less_2         = &(lrq0_entry_vld | lrq0_create_ptr0);
assign lrq0_less_3         = &(lrq0_entry_vld | lrq0_create_ptr0 | lrq0_create_ptr1);
assign lrq0_no_space       = lrq0_less_3 && !idu_lsu0_rf_oldest
                             || lrq0_full;
assign lrq0_create_success = lsu0_lrq_create_vld
                             && !rtu_lsu_flush_fe
                             && !(rtu_ck_flush && rtu_ck_flush_iid_older_lsu0_iid);//flush younger lrq create, ck_flush@LTL
assign lrq0_create_vld     = {LRQENTRY{lrq0_create_success}} & lrq0_create_ptr0;
assign lrq_lsu0_ex1_lrqid  = lrq0_create_ptr0;

assign lrq2_full           = &lrq2_entry_vld;
assign lrq2_less_2         = &(lrq2_entry_vld | lrq2_create_ptr0);
assign lrq2_less_3         = &(lrq2_entry_vld | lrq2_create_ptr0 | lrq2_create_ptr1);
assign lrq2_no_space       = lrq2_less_3 && !idu_lsu2_rf_oldest
                             || lrq2_full;
assign lrq2_create_success = lsu2_lrq_create_vld
                             && !rtu_lsu_flush_fe
                             && !(rtu_ck_flush && rtu_ck_flush_iid_older_lsu2_iid);//flush younger lrq create, ck_flush@LTL
assign lrq2_create_vld     = {LRQENTRY{lrq2_create_success}} & lrq2_create_ptr0;
assign lrq_lsu2_ex1_lrqid  = lrq2_create_ptr0;

assign lrq3_full           = &lrq3_entry_vld;
assign lrq3_less_2         = &(lrq3_entry_vld | lrq3_create_ptr0);
assign lrq3_less_3         = &(lrq3_entry_vld | lrq3_create_ptr0 | lrq3_create_ptr1);
assign lrq3_no_space       = lrq3_less_3 && !idu_lsu3_rf_oldest
                             || lrq3_full;
assign lrq3_create_success = lsu3_lrq_create_vld
                             && !rtu_lsu_flush_fe
                             && !(rtu_ck_flush && rtu_ck_flush_iid_older_lsu3_iid);//flush younger lrq create, ck_flush@LTL
assign lrq3_create_vld     = {LRQENTRY{lrq3_create_success}} & lrq3_create_ptr0;
assign lrq_lsu3_ex1_lrqid  = lrq3_create_ptr0;

`ifndef SYNTHESIS
// CTRL-RR-03 owner-lifetime checks at the LRQ interface boundary.
// The visible producer interfaces carry only an entry bitmap, not producer IID
// metadata.  These assertions therefore prove the locally observable contract:
// a wakeup must target a live entry, and an accepted create must not overlap a
// visible wakeup from the previous owner.  Proving
// producer_owner_iid == entry_iid additionally requires verification-only owner
// IID/pending metadata to be exported by every wakeup producer.
generate
  for (genvar assert_entry = 0; assert_entry < LRQENTRY; assert_entry++) begin : gen_lrq_owner_lifetime_assertions
    a_lrq0_wakeup_targets_live_entry: assert property (
      @(posedge forever_cpuclk) disable iff (!cpurst_b)
        (lsu0_lrq_exx_tlb_wakeup[assert_entry] || lsu0_lrq_frz_clr[assert_entry])
        |-> lrq0_entry_vld[assert_entry]
    ) else $error("LRQ0 wakeup targets non-live entry %0d", assert_entry);

    a_lrq2_wakeup_targets_live_entry: assert property (
      @(posedge forever_cpuclk) disable iff (!cpurst_b)
        (lsu2_lrq_exx_tlb_wakeup[assert_entry] || lsu2_lrq_frz_clr[assert_entry])
        |-> lrq2_entry_vld[assert_entry]
    ) else $error("LRQ2 wakeup targets non-live entry %0d", assert_entry);

    a_lrq3_wakeup_targets_live_entry: assert property (
      @(posedge forever_cpuclk) disable iff (!cpurst_b)
        (lsu3_lrq_exx_tlb_wakeup[assert_entry] || lsu3_lrq_frz_clr[assert_entry])
        |-> lrq3_entry_vld[assert_entry]
    ) else $error("LRQ3 wakeup targets non-live entry %0d", assert_entry);

    a_lrq0_create_has_no_visible_old_wakeup: assert property (
      @(posedge forever_cpuclk) disable iff (!cpurst_b)
        lrq0_create_vld[assert_entry] |->
        !(lsu0_lrq_exx_tlb_wakeup[assert_entry] || lsu0_lrq_frz_clr[assert_entry])
    ) else $error("LRQ0 entry %0d reused with an old-owner wakeup", assert_entry);

    a_lrq2_create_has_no_visible_old_wakeup: assert property (
      @(posedge forever_cpuclk) disable iff (!cpurst_b)
        lrq2_create_vld[assert_entry] |->
        !(lsu2_lrq_exx_tlb_wakeup[assert_entry] || lsu2_lrq_frz_clr[assert_entry])
    ) else $error("LRQ2 entry %0d reused with an old-owner wakeup", assert_entry);

    a_lrq3_create_has_no_visible_old_wakeup: assert property (
      @(posedge forever_cpuclk) disable iff (!cpurst_b)
        lrq3_create_vld[assert_entry] |->
        !(lsu3_lrq_exx_tlb_wakeup[assert_entry] || lsu3_lrq_frz_clr[assert_entry])
    ) else $error("LRQ3 entry %0d reused with an old-owner wakeup", assert_entry);
  end
endgenerate
`endif

xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH))
x_lsu_lrq_create_compare_flush_iid_0(
    .x_iid0       ( rtu_ck_flush_iid                  ),
    .x_iid0_older ( rtu_ck_flush_iid_older_lsu0_iid   ),
    .x_iid1       ( lsu0_lrq_create_iid               )
);
xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH))
x_lsu_lrq_create_compare_flush_iid_2(
    .x_iid0       ( rtu_ck_flush_iid                  ),
    .x_iid0_older ( rtu_ck_flush_iid_older_lsu2_iid   ),
    .x_iid1       ( lsu2_lrq_create_iid               )
);
xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH))
x_lsu_lrq_create_compare_flush_iid_3(
    .x_iid0       ( rtu_ck_flush_iid                  ),
    .x_iid0_older ( rtu_ck_flush_iid_older_lsu3_iid   ),
    .x_iid1       ( lsu3_lrq_create_iid               )
);
xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH))
x_lsu_lrq_create_old20(
    .x_iid0       ( lsu2_lrq_create_iid  ),
    .x_iid0_older ( lrq_create_old20     ),
    .x_iid1       ( lsu0_lrq_create_iid  )
);
xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH))
x_lsu_lrq_create_old30(
    .x_iid0       ( lsu3_lrq_create_iid  ),
    .x_iid0_older ( lrq_create_old30     ),
    .x_iid1       ( lsu0_lrq_create_iid  )
);

xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH))
x_lsu_lrq_create_old32(
    .x_iid0       ( lsu3_lrq_create_iid  ),
    .x_iid0_older ( lrq_create_old32     ),
    .x_iid1       ( lsu2_lrq_create_iid  )
);

// global create age-vec
assign lrq0_entry_create_local_agevec = lrq0_entry_create_agevec0_x;
assign lrq2_entry_create_local_agevec = lrq2_entry_create_agevec2_x;
assign lrq3_entry_create_local_agevec = lrq3_entry_create_agevec3_x;

assign lrq0_entry_create_global_agevec = {lrq3_entry_create_agevec0_x, lrq2_entry_create_agevec0_x, lrq0_entry_create_agevec0_x}
                                       | {lrq3_create_vld & {LRQENTRY{lrq_create_old30}},
                                          lrq2_create_vld & {LRQENTRY{lrq_create_old20}},
                                          {LRQENTRY{1'b0}}
                                          };
assign lrq2_entry_create_global_agevec = {lrq3_entry_create_agevec2_x, lrq2_entry_create_agevec2_x, lrq0_entry_create_agevec2_x}
                                       | {lrq3_create_vld & {LRQENTRY{lrq_create_old32}},
                                          {LRQENTRY{1'b0}},
                                          lrq0_create_vld & {LRQENTRY{~lrq_create_old20}}
                                         };
assign lrq3_entry_create_global_agevec = {lrq3_entry_create_agevec3_x, lrq2_entry_create_agevec3_x, lrq0_entry_create_agevec3_x}
                                       | {{LRQENTRY{1'b0}},
                                          lrq2_create_vld & {LRQENTRY{~lrq_create_old32}},
                                          lrq0_create_vld & {LRQENTRY{~lrq_create_old30}}
                                         };

assign lrq0_local_agevec_updt_vld = lrq0_create_success || lsu0_lrq_ex3_pop_vld;
assign lrq2_local_agevec_updt_vld = lrq2_create_success || lsu2_lrq_ex3_pop_vld;
assign lrq3_local_agevec_updt_vld = lrq3_create_success || lsu3_lrq_ex3_pop_vld;
assign lrq0_global_agevec_updt_vld = lrq0_create_success
                                     || lrq2_create_success
                                     || lrq3_create_success
                                     || lsu0_lrq_ex3_pop_vld
                                     || lsu2_lrq_ex3_pop_vld
                                     || lsu3_lrq_ex3_pop_vld;
assign lrq2_global_agevec_updt_vld = lrq0_global_agevec_updt_vld;
assign lrq3_global_agevec_updt_vld = lrq0_global_agevec_updt_vld;

// pop_vld_b
assign lrq0_local_pop_vld_b = ~lsu0_lrq_ex3_pop_entry;
assign lrq2_local_pop_vld_b = ~lsu2_lrq_ex3_pop_entry;
assign lrq3_local_pop_vld_b = ~lsu3_lrq_ex3_pop_entry;
assign lrq0_global_pop_vld_b = {~lsu3_lrq_ex3_pop_entry,
                                ~lsu2_lrq_ex3_pop_entry,
                                ~lsu0_lrq_ex3_pop_entry};
assign lrq2_global_pop_vld_b = lrq0_global_pop_vld_b;
assign lrq3_global_pop_vld_b = lrq0_global_pop_vld_b;


assign rdy_pre_vec0 = rdy_pre0;
assign rdy_pre_vec2 = rdy_pre2;
assign rdy_pre_vec3 = rdy_pre3;


// lrq0
// xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH))
// x_lsu_lrq0_rdy_older_idu(
//     .x_iid0       ( lrq0_rdy_data[LRQ_IID:LRQ_IID-IID_WIDTH+1]  ),
//     .x_iid0_older ( lrq0_rdy_older_idu ),
//     .x_iid1       ( idu_lsu0_rf_iid  )
// );

// xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH))
// x_lsu_lrq0_rdy_older_ex1(
//     .x_iid0       ( lrq0_rdy_data[LRQ_IID:LRQ_IID-IID_WIDTH+1]  ),
//     .x_iid0_older ( lrq0_rdy_older_ex1 ),
//     .x_iid1       ( lsu0_lrq_ex1_iid  )
// );

xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH))
x_lsu_idu0_iid_older_ex1(
    .x_iid0       ( idu_lsu0_rf_iid  ),
    .x_iid0_older ( idu0_iid_older_ex1 ),
    .x_iid1       ( lsu0_lrq_ex1_iid  )
);
// lrq2
// xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH))
// x_lsu_lrq2_rdy_older_idu(
//     .x_iid0       ( lrq2_rdy_data[LRQ_IID:LRQ_IID-IID_WIDTH+1]  ),
//     .x_iid0_older ( lrq2_rdy_older_idu ),
//     .x_iid1       ( idu_lsu2_rf_iid  )
// );

// xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH))
// x_lsu_lrq2_rdy_older_ex1(
//     .x_iid0       ( lrq2_rdy_data[LRQ_IID:LRQ_IID-IID_WIDTH+1]  ),
//     .x_iid0_older ( lrq2_rdy_older_ex1 ),
//     .x_iid1       ( lsu2_lrq_ex1_iid  )
// );

xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH))
x_lsu_idu2_iid_older_ex1(
    .x_iid0       ( idu_lsu2_rf_iid  ),
    .x_iid0_older ( idu2_iid_older_ex1 ),
    .x_iid1       ( lsu2_lrq_ex1_iid  )
);

// lrq3
// xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH))
// x_lsu_lrq3_rdy_older_idu(
//     .x_iid0       ( lrq3_rdy_data[LRQ_IID:LRQ_IID-IID_WIDTH+1]  ),
//     .x_iid0_older ( lrq3_rdy_older_idu ),
//     .x_iid1       ( idu_lsu3_rf_iid  )
// );

// xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH))
// x_lsu_lrq3_rdy_older_ex1(
//     .x_iid0       ( lrq3_rdy_data[LRQ_IID:LRQ_IID-IID_WIDTH+1]  ),
//     .x_iid0_older ( lrq3_rdy_older_ex1 ),
//     .x_iid1       ( lsu3_lrq_ex1_iid  )
// );

xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH))
x_lsu_idu3_iid_older_ex1(
    .x_iid0       ( idu_lsu3_rf_iid  ),
    .x_iid0_older ( idu3_iid_older_ex1 ),
    .x_iid1       ( lsu3_lrq_ex1_iid  )
);
// lrq0
assign lrq0_has_rdy = |(rdy_pre0); // wjh@timing
assign lsu0_issue_sel_lrq = lrq0_has_rdy
                            && (!idu_lsu0_rf_sel
                                || (|lrq0_rdy_older_idu) // wjh@timing
                                || lrq0_no_space);
                                // || (lrq0_left_1 && lsu0_lrq_create_vld)); // if lrq0 is full, then lsu0-idu req is restart 

assign lsu0_issue_sel_idu = idu_lsu0_rf_sel
                            && !lrq0_no_space
                            && !(|lrq0_rdy_older_idu); // wjh@timing

assign lsu0_issue_permit = !lsu0_lrq_ex1_stall_vld;  // make newer than stalled ex1 req should never issued
                        //    || (lsu0_issue_sel_lrq
                        //        && lrq0_rdy_older_ex1)
                        //    || (lsu0_issue_sel_idu
                        //        && idu0_iid_older_ex1);
assign lsu0_issue_permit_lrq = !lsu0_lrq_ex1_stall_vld || (|lrq0_rdy_older_ex1); // wjh@timing
assign lsu0_issue_permit_idu = !lsu0_lrq_ex1_stall_vld || idu0_iid_older_ex1;
// lrq2
assign lrq2_has_rdy = |(rdy_pre2); // wjh@timing
assign lsu2_issue_sel_lrq = lrq2_has_rdy
                            && (!idu_lsu2_rf_sel
                                || (|lrq2_rdy_older_idu) // wjh@timing
                                || lrq2_no_space);
                                // || (lrq2_left_1 && lsu2_lrq_create_vld)); // if lrq0 is full, then lsu0-idu req is restart 

assign lsu2_issue_sel_idu = idu_lsu2_rf_sel
                            && !lrq2_no_space
                            && !(|lrq2_rdy_older_idu); // wjh@timing

assign lsu2_issue_permit = !lsu2_lrq_ex1_stall_vld; // make newer than stalled ex1 req should never issued
                        //    || (lsu2_issue_sel_lrq
                        //        && lrq2_rdy_older_ex1)
                        //    || (lsu2_issue_sel_idu
                        //        && idu2_iid_older_ex1);
assign lsu2_issue_permit_lrq = !lsu2_lrq_ex1_stall_vld || (|lrq2_rdy_older_ex1); // wjh@timing
assign lsu2_issue_permit_idu = !lsu2_lrq_ex1_stall_vld || idu2_iid_older_ex1;
// lrq3
assign lrq3_has_rdy = |(rdy_pre3); // wjh@timing
assign lsu3_issue_sel_lrq = lrq3_has_rdy
                            && (!idu_lsu3_rf_sel
                                || (|lrq3_rdy_older_idu) // wjh@timing
                                || lrq3_no_space);
                                // || (lrq3_left_1 && lsu3_lrq_create_vld)); // if lrq0 is full, then lsu0-idu req is restart 

assign lsu3_issue_sel_idu = idu_lsu3_rf_sel
                            && !lrq3_no_space
                            && !(|lrq3_rdy_older_idu); // wjh@timing

assign lsu3_issue_permit = !lsu3_lrq_ex1_stall_vld; // make newer than stalled ex1 req should never issued
                        //    || (lsu3_issue_sel_lrq
                        //        && lrq3_rdy_older_ex1)
                        //    || (lsu3_issue_sel_idu
                        //        && idu3_iid_older_ex1);
assign lsu3_issue_permit_lrq = !lsu3_lrq_ex1_stall_vld || (|lrq3_rdy_older_ex1); // wjh@timing
assign lsu3_issue_permit_idu = !lsu3_lrq_ex1_stall_vld || idu3_iid_older_ex1;

assign lsu0_issue_sel_lrq_final = lsu0_issue_sel_lrq && lsu0_issue_permit_lrq;
assign lrq0_entry_issue_grnt    = {LRQENTRY{lsu0_issue_sel_lrq_final}} & rdy0;
assign lsu2_issue_sel_lrq_final = lsu2_issue_sel_lrq && lsu2_issue_permit_lrq;
assign lrq2_entry_issue_grnt    = {LRQENTRY{lsu2_issue_sel_lrq_final}} & rdy2;
assign lsu3_issue_sel_lrq_final = lsu3_issue_sel_lrq && lsu3_issue_permit_lrq;
assign lrq3_entry_issue_grnt    = {LRQENTRY{lsu3_issue_sel_lrq_final}} & rdy3;

assign lrq0_idu_ex3_pop_vld   = lsu0_lrq_create_vld;
assign lrq0_idu_ex3_pop_entry = {LSIQENTRY{lsu0_lrq_create_vld}} & lsu0_lrq_pop_entry[LSIQENTRY-1:0];
assign lrq0_idu_exx_wakeup    = {LSIQENTRY{idu_lsu0_rf_sel
                                           & (~lsu0_issue_sel_idu
                                              | ~lsu0_issue_permit_idu)}} & idu_lsu0_rf_lch_entry;

assign lrq2_idu_ex3_pop_vld   = lsu2_lrq_create_vld;
assign lrq2_idu_ex3_pop_entry = {LSIQENTRY{lsu2_lrq_create_vld}} & lsu2_lrq_pop_entry[LSIQENTRY-1:0];
assign lrq2_idu_exx_wakeup    = {LSIQENTRY{idu_lsu2_rf_sel
                                           & (~lsu2_issue_sel_idu
                                              | ~lsu2_issue_permit_idu)}} & idu_lsu2_rf_lch_entry;

assign lrq3_idu_ex3_pop_vld   = lsu3_lrq_create_vld;
assign lrq3_idu_ex3_pop_entry = {LSIQENTRY{lsu3_lrq_create_vld}} & lsu3_lrq_pop_entry[LSIQENTRY-1:0];
assign lrq3_idu_exx_wakeup    = {LSIQENTRY{idu_lsu3_rf_sel
                                           & (~lsu3_issue_sel_idu
                                              | ~lsu3_issue_permit_idu)}} & idu_lsu3_rf_lch_entry;
// cross logic 
// assign lrq_old_vld[3*LRQENTRY-1:LRQENTRY] = {2*LRQENTRY{1'b0}}; // extension
generate
    for(genvar i=0; i<LRQENTRY; i++)
        assign lrq_all_iid[i]            = lrq0_read_data[i][LRQ_IID:LRQ_IID-IID_WIDTH+1];
    for(genvar i=0; i<LRQENTRY; i++)
        assign lrq_all_iid[i+LRQENTRY]   = lrq2_read_data[i][LRQ_IID:LRQ_IID-IID_WIDTH+1];
    for(genvar i=0; i<LRQENTRY; i++)
        assign lrq_all_iid[i+2*LRQENTRY] = lrq3_read_data[i][LRQ_IID:LRQ_IID-IID_WIDTH+1];
endgenerate
always_comb begin 
    lrq_old_iid = {IID_WIDTH{1'b0}};
    for(int i=0; i<3*LRQENTRY; i++) begin // extension
        if(lrq_old_vld[i] == 1'b1) begin 
            lrq_old_iid = lrq_all_iid[i];
        end 
    end 
end 

xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH))
x_lsu_lrq_rdy_older_idu_oldest(
    .x_iid0       ( lrq_old_iid            ),
    .x_iid0_older ( lrq_iid_older_than_idu ),
    .x_iid1       ( idu_lsu_old_iid        )
);

assign lrq_older_than_lsiq = |(lrq_old_vld[3*LRQENTRY-1:0]) // extension
                             && (!idu_lsu_old_vld
                                 || lrq_iid_older_than_idu);

// entry_signal
always_comb begin 
    lrq0_rdy_data = {LRQ_WIDTH{1'b0}};
    for(int i=0; i<LRQENTRY; i++) begin 
        if(rdy0[i] == 1'b1) begin 
            lrq0_rdy_data = lrq0_read_data[i];
        end         
    end 
end 

always_comb begin 
    lrq2_rdy_data = {LRQ_WIDTH{1'b0}};
    for(int i=0; i<LRQENTRY; i++) begin 
        if(rdy2[i] == 1'b1) begin 
            lrq2_rdy_data = lrq2_read_data[i];
        end         
    end 
end 

always_comb begin 
    lrq3_rdy_data = {LRQ_WIDTH{1'b0}};
    for(int i=0; i<LRQENTRY; i++) begin 
        if(rdy3[i] == 1'b1) begin 
            lrq3_rdy_data = lrq3_read_data[i];
        end         
    end 
end 
assign lrq0_hit_no_spec_tbl = |lsu0_no_spec_target[3*LRQENTRY-1:LRQENTRY];
assign lrq2_hit_no_spec_tbl = |lsu2_no_spec_target[3*LRQENTRY-1:LRQENTRY];
assign lrq3_hit_no_spec_tbl = |lsu3_no_spec_target[3*LRQENTRY-1:LRQENTRY];

assign lrq_lsu0_rf_replay_vld    = lsu0_issue_sel_lrq_final;
assign lrq_lsu0_rf_bytes_vld     = lsu0_issue_sel_lrq?lrq0_rdy_data[LRQ_BYTES_VLD:LRQ_BYTES_VLD-16+1]                       :{16{1'bx}};
assign lrq_lsu0_rf_bytes_vld1     = lsu0_issue_sel_lrq?lrq0_rdy_data[LRQ_BYTES_VLD1:LRQ_BYTES_VLD1-16+1]                       :{16{1'bx}};
assign lrq_lsu0_rf_bytes_vld2     = lsu0_issue_sel_lrq?lrq0_rdy_data[LRQ_BYTES_VLD2:LRQ_BYTES_VLD2-16+1]                       :{16{1'bx}};
assign lrq_lsu0_rf_bytes_vld3     = lsu0_issue_sel_lrq?lrq0_rdy_data[LRQ_BYTES_VLD3:LRQ_BYTES_VLD3-16+1]                       :{16{1'bx}};
assign lrq_lsu0_rf_reg_bytes_vld  = lsu0_issue_sel_lrq?lrq0_rdy_data[LRQ_REG_BYTES_VLD:LRQ_REG_BYTES_VLD-16+1]               :{16{1'bx}};
assign lrq_lsu0_rf_reg_bytes_vld1 = lsu0_issue_sel_lrq?lrq0_rdy_data[LRQ_REG_BYTES_VLD1:LRQ_REG_BYTES_VLD1-16+1]               :{16{1'bx}};
assign lrq_lsu0_rf_reg_bytes_vld2 = lsu0_issue_sel_lrq?lrq0_rdy_data[LRQ_REG_BYTES_VLD2:LRQ_REG_BYTES_VLD2-16+1]               :{16{1'bx}};
assign lrq_lsu0_rf_reg_bytes_vld3 = lsu0_issue_sel_lrq?lrq0_rdy_data[LRQ_REG_BYTES_VLD3:LRQ_REG_BYTES_VLD3-16+1]               :{16{1'bx}};
assign lrq_lsu0_rf_boundary      = lsu0_issue_sel_lrq?lrq0_rdy_data[LRQ_BOUNDARY]                                           :1'bx;
assign lrq_lsu0_rf_va            = lsu0_issue_sel_lrq?lrq0_rdy_data[LRQ_VA:LRQ_VA-64+1]                                     :{64{1'bx}};
assign lrq_lsu0_rf_already_da    = lsu0_issue_sel_lrq?lrq0_rdy_data[LRQ_ALREADY_DA]                                         :1'b0;
assign lrq_lsu0_rf_atomic        = lsu0_issue_sel_lrq?lrq0_rdy_data[LRQ_ATOMIC]                                             :idu_lsu0_rf_atomic;
assign lrq_lsu0_rf_iid           = lsu0_issue_sel_lrq?lrq0_rdy_data[LRQ_IID:LRQ_IID-IID_WIDTH+1]                            :idu_lsu0_rf_iid;
assign lrq_lsu0_rf_inst_fls      = lsu0_issue_sel_lrq?lrq0_rdy_data[LRQ_INST_FLS]                                           :idu_lsu0_rf_inst_fls;
assign lrq_lsu0_rf_inst_fof      = lsu0_issue_sel_lrq?lrq0_rdy_data[LRQ_INST_FOF]                                           :idu_lsu0_rf_inst_fof;
assign lrq_lsu0_rf_inst_ldr      = lsu0_issue_sel_lrq?1'bx                                                                  :idu_lsu0_rf_inst_ldr;
assign lrq_lsu0_rf_inst_size     = lsu0_issue_sel_lrq?lrq0_rdy_data[LRQ_INST_SIZE:LRQ_INST_SIZE-2+1]                        :idu_lsu0_rf_inst_size;
assign lrq_lsu0_rf_inst_type     = lsu0_issue_sel_lrq?lrq0_rdy_data[LRQ_INST_TYPE:LRQ_INST_TYPE-2+1]                        :idu_lsu0_rf_inst_type;
assign lrq_lsu0_rf_inst_vls      = lsu0_issue_sel_lrq?lrq0_rdy_data[LRQ_INST_VLS]                                           :idu_lsu0_rf_inst_vls;
assign lrq_lsu0_rf_lsfifo        = lsu0_issue_sel_lrq?lrq0_rdy_data[LRQ_LSFIFO]                                             :idu_lsu0_rf_lsfifo;
//assign lrq_lsu0_rf_mlen          = lsu0_issue_sel_lrq?3'bxxx                                                                :idu_lsu0_rf_mlen; // not use in rvv1.0 @hcl
assign lrq_lsu0_rf_no_spec       = lsu0_issue_sel_lrq?2'bxx                                                                 :idu_lsu0_rf_no_spec;
// assign lrq_lsu0_rf_no_spec_exist = lsu0_issue_sel_lrq?1'bx                                                                  :idu_lsu0_rf_no_spec_exist;
assign lrq_lsu0_rf_no_spec_exist = lsu0_issue_sel_lrq?lrq0_rdy_data[LRQ_NOSPEC_EXIST]                                       :1'b0;
assign lrq_lsu0_rf_zext          = lsu0_issue_sel_lrq?1'bx                                                                  :idu_lsu0_rf_zext;
assign lrq_lsu0_rf_offset        = lsu0_issue_sel_lrq?{12{1'b0}}                                                            :idu_lsu0_rf_offset;
assign lrq_lsu0_rf_offset_plus   = lsu0_issue_sel_lrq?{13{1'b0}}                                                            :idu_lsu0_rf_offset_plus;
assign lrq_lsu0_rf_oldest        = lsu0_issue_sel_lrq?lrq0_rdy_data[LRQ_OLDEST]                                             :idu_lsu0_rf_oldest & !lrq_older_than_lsiq;
assign lrq_lsu0_rf_pc            = lsu0_issue_sel_lrq?lrq0_rdy_data[LRQ_PC:LRQ_PC-PC_LEN+1]                                 :idu_lsu0_rf_pc;
assign lrq_lsu0_rf_preg          = lsu0_issue_sel_lrq?lrq0_rdy_data[LRQ_PREG:LRQ_PREG-PREG+1]                               :idu_lsu0_rf_preg;
assign lrq_lsu0_rf_shift         = lsu0_issue_sel_lrq?4'b0000                                                               :idu_lsu0_rf_shift;
assign lrq_lsu0_rf_sext          = lsu0_issue_sel_lrq?lrq0_rdy_data[LRQ_SEXT]                                               :idu_lsu0_rf_sext;
assign lrq_lsu0_rf_spec_fail     = lsu0_issue_sel_lrq?lrq0_rdy_data[LRQ_SPEC_FAIL]                                          :1'b0;
assign lrq_lsu0_rf_split         = lsu0_issue_sel_lrq?lrq0_rdy_data[LRQ_SPLIT]                                              :idu_lsu0_rf_split;
assign lrq_lsu0_rf_split_num     = lsu0_issue_sel_lrq?lrq0_rdy_data[LRQ_SPLIT_NUM:LRQ_SPLIT_NUM-9+1]                        :idu_lsu0_rf_split_num;
assign lrq_lsu0_rf_src0          = lsu0_issue_sel_lrq?{64{1'bx}}                                                            :idu_lsu0_rf_src0;
assign lrq_lsu0_rf_src1          = lsu0_issue_sel_lrq?{64{1'bx}}                                                            :idu_lsu0_rf_src1;
// assign lrq_lsu0_rf_srcvm_vr0     = lsu0_issue_sel_lrq?{64{1'bx}}                                                            :idu_lsu0_rf_srcvm_vr0;
// assign lrq_lsu0_rf_srcvm_vr1     = lsu0_issue_sel_lrq?{64{1'bx}}                                                            :idu_lsu0_rf_srcvm_vr1;
assign lrq_lsu0_rf_srcvm_vr0     = lsu0_issue_sel_lrq?{256{1'bx}}                                                            :idu_lsu0_rf_srcvm_vr0;
assign lrq_lsu0_rf_srcvm_vr1     = lsu0_issue_sel_lrq?{256{1'bx}}                                                            :idu_lsu0_rf_srcvm_vr1;
assign lrq_lsu0_rf_unal2nd       = lsu0_issue_sel_lrq?lrq0_rdy_data[LRQ_UNAL2ND]                                            :1'b0;
assign lrq_lsu0_rf_unit_stride   = lsu0_issue_sel_lrq?lrq0_rdy_data[LRQ_UNIT_STRIDE]                                        :idu_lsu0_rf_unit_stride;
assign lrq_lsu0_rf_vl            = lsu0_issue_sel_lrq?{`VL_WIDTH{1'bx}}                                                             :idu_lsu0_rf_vl;
//assign lrq_lsu0_rf_vlmul         = lsu0_issue_sel_lrq?lrq0_rdy_data[LRQ_VLMUL:LRQ_VLMUL-2+1]                                :idu_lsu0_rf_vlmul; // mark by tmj, TODO: 3bits
assign lrq_lsu0_rf_vlmul         = lsu0_issue_sel_lrq?lrq0_rdy_data[LRQ_VLMUL:LRQ_VLMUL-2]                                  :idu_lsu0_rf_vlmul;  //pwh
assign lrq_lsu0_rf_vls_size      = lsu0_issue_sel_lrq?lrq0_rdy_data[LRQ_VLS_SIZE:LRQ_VLS_SIZE-4+1]                          :idu_lsu0_rf_vls_size;
assign lrq_lsu0_rf_vmask_vld     = lsu0_issue_sel_lrq?1'bx                                                                  :idu_lsu0_rf_vmask_vld;
assign lrq_lsu0_rf_vmb_id        = lsu0_issue_sel_lrq?lrq0_rdy_data[LRQ_VMB_ID:LRQ_VMB_ID-VMBENTRY+1]                       :idu_lsu0_rf_vmb_id;
assign lrq_lsu0_rf_vmb_merge_vld = lsu0_issue_sel_lrq?lrq0_rdy_data[LRQ_VMB_MERGE_VLD]                                      :idu_lsu0_rf_vmb_merge_vld;
assign lrq_lsu0_rf_vreg          = lsu0_issue_sel_lrq?lrq0_rdy_data[LRQ_VREG:LRQ_VREG-VREG+1]                               :idu_lsu0_rf_vreg;
assign lrq_lsu0_rf_vmew           = lsu0_issue_sel_lrq?lrq0_rdy_data[LRQ_VMEW:LRQ_VMEW-2+1]                                  :idu_lsu0_rf_inst_vmew;// rvv1.0 @hcl
assign lrq_lsu0_rf_vmop           = lsu0_issue_sel_lrq?lrq0_rdy_data[LRQ_VMOP:LRQ_VMOP-2+1]                                  :idu_lsu0_rf_inst_vmop;// rvv1.0 @hcl
assign lrq_lsu0_rf_nf            = lsu0_issue_sel_lrq?lrq0_rdy_data[LRQ_NF]                                                 :idu_lsu0_rf_inst_nf;
//assign lrq_lsu0_rf_vsew          = lsu0_issue_sel_lrq?lrq0_rdy_data[LRQ_VSEW:LRQ_VSEW-2+1]                                  :idu_lsu0_rf_vsew; // not use in rvv1.0 @hcl
assign lrq_lsu0_rf_pa_vld        = lsu0_issue_sel_lrq?lrq0_rdy_data[LRQ_PA_VLD]                                             :1'b0;
assign lrq_lsu0_rf_pa            = lsu0_issue_sel_lrq?lrq0_rdy_data[LRQ_PA:LRQ_PA-`WK_PA_PAGE_NUM_WIDTH+1]                                     :{`WK_PA_WIDTH-12{1'bx}};
assign lrq_lsu0_rf_attr          = lsu0_issue_sel_lrq?lrq0_rdy_data[LRQ_ATTR:LRQ_ATTR-5+1]                                  :{5{1'bx}};
assign lrq_lsu0_rf_sfp_dst_pc    = lsu0_issue_sel_lrq?{PC_LEN{1'bx}}                                                        :sfp_lrq0_ex0_dst_pc;
assign lrq_lsu0_rf_sfp_pc_hit    = lsu0_issue_sel_lrq?1'bx                                                                  :sfp_lrq0_ex0_pc_hit;
assign lrq_lsu0_rf_gateclk_sel = lrq_lsu0_rf_sel;
assign lrq_lsu0_rf_lch_entry   = lsu0_issue_sel_lrq? rdy0 : {{LRQENTRY-LSIQENTRY{1'b0}}, idu_lsu0_rf_lch_entry[LSIQENTRY-1:0]}; // LRQENTRY should not smaller than LSIQENTRY
// assign lrq_lsu0_rf_sel         = lsu0_issue_sel_lrq && lsu0_issue_permit_lrq 
//                                  || lsu0_issue_sel_idu && lsu0_issue_permit_idu;
assign lrq_lsu0_rf_sel         = !lsu0_lrq_ex1_stall_vld && (lrq0_has_rdy || idu_lsu0_rf_sel && !lrq0_no_space)
                                 || lsu0_lrq_ex1_stall_vld && (|(lrq0_rdy_older_ex1) || idu_lsu0_rf_sel && idu0_iid_older_ex1 && !lrq0_no_space);

assign lrq_lsu0_rf_older_vld   = |(lrq0_rdy_older_ex1) || idu_lsu0_rf_sel && idu0_iid_older_ex1 && !lrq0_no_space; // wjh@timing
// lsu2


assign lrq_lsu2_rf_replay_vld    = lsu2_issue_sel_lrq_final;
assign lrq_lsu2_rf_bytes_vld     = lsu2_issue_sel_lrq?lrq2_rdy_data[LRQ_BYTES_VLD:LRQ_BYTES_VLD-16+1]                       :{16{1'bx}};
assign lrq_lsu2_rf_bytes_vld1    = lsu2_issue_sel_lrq?lrq2_rdy_data[LRQ_BYTES_VLD1:LRQ_BYTES_VLD1-16+1]                     :{16{1'bx}};
assign lrq_lsu2_rf_bytes_vld2    = lsu2_issue_sel_lrq?lrq2_rdy_data[LRQ_BYTES_VLD2:LRQ_BYTES_VLD2-16+1]                     :{16{1'bx}};
assign lrq_lsu2_rf_bytes_vld3    = lsu2_issue_sel_lrq?lrq2_rdy_data[LRQ_BYTES_VLD3:LRQ_BYTES_VLD3-16+1]                     :{16{1'bx}};
assign lrq_lsu2_rf_reg_bytes_vld = lsu2_issue_sel_lrq?lrq2_rdy_data[LRQ_REG_BYTES_VLD:LRQ_REG_BYTES_VLD-16+1]               :{16{1'bx}};
assign lrq_lsu2_rf_reg_bytes_vld1= lsu2_issue_sel_lrq?lrq2_rdy_data[LRQ_REG_BYTES_VLD1:LRQ_REG_BYTES_VLD1-16+1]             :{16{1'bx}};
assign lrq_lsu2_rf_reg_bytes_vld2= lsu2_issue_sel_lrq?lrq2_rdy_data[LRQ_REG_BYTES_VLD2:LRQ_REG_BYTES_VLD2-16+1]             :{16{1'bx}};
assign lrq_lsu2_rf_reg_bytes_vld3= lsu2_issue_sel_lrq?lrq2_rdy_data[LRQ_REG_BYTES_VLD3:LRQ_REG_BYTES_VLD3-16+1]             :{16{1'bx}};
assign lrq_lsu2_rf_boundary      = lsu2_issue_sel_lrq?lrq2_rdy_data[LRQ_BOUNDARY]                                           :1'bx;
assign lrq_lsu2_rf_va            = lsu2_issue_sel_lrq?lrq2_rdy_data[LRQ_VA:LRQ_VA-64+1]                                     :{64{1'bx}};
assign lrq_lsu2_rf_already_da    = lsu2_issue_sel_lrq?lrq2_rdy_data[LRQ_ALREADY_DA]                                         :1'b0;
assign lrq_lsu2_rf_atomic        = lsu2_issue_sel_lrq?lrq2_rdy_data[LRQ_ATOMIC]                                             :idu_lsu2_rf_atomic;
assign lrq_lsu2_rf_iid           = lsu2_issue_sel_lrq?lrq2_rdy_data[LRQ_IID:LRQ_IID-IID_WIDTH+1]                            :idu_lsu2_rf_iid;
assign lrq_lsu2_rf_inst_fls      = lsu2_issue_sel_lrq?lrq2_rdy_data[LRQ_INST_FLS]                                           :idu_lsu2_rf_inst_fls;
assign lrq_lsu2_rf_inst_fof      = lsu2_issue_sel_lrq?lrq2_rdy_data[LRQ_INST_FOF]                                           :idu_lsu2_rf_inst_fof;
assign lrq_lsu2_rf_inst_ldr      = lsu2_issue_sel_lrq?1'bx                                                                  :idu_lsu2_rf_inst_ldr;
assign lrq_lsu2_rf_inst_size     = lsu2_issue_sel_lrq?lrq2_rdy_data[LRQ_INST_SIZE:LRQ_INST_SIZE-2+1]                        :idu_lsu2_rf_inst_size;
assign lrq_lsu2_rf_inst_type     = lsu2_issue_sel_lrq?lrq2_rdy_data[LRQ_INST_TYPE:LRQ_INST_TYPE-2+1]                        :idu_lsu2_rf_inst_type;
assign lrq_lsu2_rf_inst_vls      = lsu2_issue_sel_lrq?lrq2_rdy_data[LRQ_INST_VLS]                                           :idu_lsu2_rf_inst_vls;
assign lrq_lsu2_rf_lsfifo        = lsu2_issue_sel_lrq?lrq2_rdy_data[LRQ_LSFIFO]                                             :idu_lsu2_rf_lsfifo;
//assign lrq_lsu2_rf_mlen          = lsu2_issue_sel_lrq?3'bxxx                                                                :idu_lsu2_rf_mlen;//not use in rvv1.0 @hcl
assign lrq_lsu2_rf_no_spec       = lsu2_issue_sel_lrq?2'bxx                                                                 :idu_lsu2_rf_no_spec;
// assign lrq_lsu2_rf_no_spec_exist = lsu2_issue_sel_lrq?1'bx                                                                  :idu_lsu2_rf_no_spec_exist;
assign lrq_lsu2_rf_no_spec_exist = lsu2_issue_sel_lrq?lrq2_rdy_data[LRQ_NOSPEC_EXIST]                                       :1'b0;
assign lrq_lsu2_rf_zext          = lsu2_issue_sel_lrq?1'bx                                                                  :idu_lsu2_rf_zext;
assign lrq_lsu2_rf_offset        = lsu2_issue_sel_lrq?{12{1'b0}}                                                            :idu_lsu2_rf_offset;
assign lrq_lsu2_rf_offset_plus   = lsu2_issue_sel_lrq?{13{1'b0}}                                                            :idu_lsu2_rf_offset_plus;
assign lrq_lsu2_rf_oldest        = lsu2_issue_sel_lrq?lrq2_rdy_data[LRQ_OLDEST]                                             :idu_lsu2_rf_oldest & !lrq_older_than_lsiq;
assign lrq_lsu2_rf_pc            = lsu2_issue_sel_lrq?lrq2_rdy_data[LRQ_PC:LRQ_PC-PC_LEN+1]                                 :idu_lsu2_rf_pc;
assign lrq_lsu2_rf_preg          = lsu2_issue_sel_lrq?lrq2_rdy_data[LRQ_PREG:LRQ_PREG-PREG+1]                               :idu_lsu2_rf_preg;
assign lrq_lsu2_rf_shift         = lsu2_issue_sel_lrq?4'b0000                                                               :idu_lsu2_rf_shift;
assign lrq_lsu2_rf_sext          = lsu2_issue_sel_lrq?lrq2_rdy_data[LRQ_SEXT]                                               :idu_lsu2_rf_sext;
assign lrq_lsu2_rf_spec_fail     = lsu2_issue_sel_lrq?lrq2_rdy_data[LRQ_SPEC_FAIL]                                          :1'b0;
assign lrq_lsu2_rf_split         = lsu2_issue_sel_lrq?lrq2_rdy_data[LRQ_SPLIT]                                              :idu_lsu2_rf_split;
assign lrq_lsu2_rf_split_num     = lsu2_issue_sel_lrq?lrq2_rdy_data[LRQ_SPLIT_NUM:LRQ_SPLIT_NUM-9+1]                        :idu_lsu2_rf_split_num;
assign lrq_lsu2_rf_src0          = lsu2_issue_sel_lrq?{64{1'bx}}                                                            :idu_lsu2_rf_src0;
assign lrq_lsu2_rf_src1          = lsu2_issue_sel_lrq?{64{1'bx}}                                                            :idu_lsu2_rf_src1;
assign lrq_lsu2_rf_srcvm_vr0     = lsu2_issue_sel_lrq?{256{1'bx}}                                                            :idu_lsu2_rf_srcvm_vr0;
assign lrq_lsu2_rf_srcvm_vr1     = lsu2_issue_sel_lrq?{256{1'bx}}                                                            :idu_lsu2_rf_srcvm_vr1;
assign lrq_lsu2_rf_unal2nd       = lsu2_issue_sel_lrq?lrq2_rdy_data[LRQ_UNAL2ND]                                            :1'b0;
assign lrq_lsu2_rf_unit_stride   = lsu2_issue_sel_lrq?lrq2_rdy_data[LRQ_UNIT_STRIDE]                                        :idu_lsu2_rf_unit_stride;
assign lrq_lsu2_rf_vl            = lsu2_issue_sel_lrq?{`VL_WIDTH{1'bx}}                                                             :idu_lsu2_rf_vl;
// assign lrq_lsu2_rf_vlmul         = lsu2_issue_sel_lrq?lrq2_rdy_data[LRQ_VLMUL:LRQ_VLMUL-2+1]                                :idu_lsu2_rf_vlmul;
assign lrq_lsu2_rf_vlmul         = lsu2_issue_sel_lrq?lrq2_rdy_data[LRQ_VLMUL:LRQ_VLMUL-2]                                  :idu_lsu2_rf_vlmul;
assign lrq_lsu2_rf_vls_size      = lsu2_issue_sel_lrq?lrq2_rdy_data[LRQ_VLS_SIZE:LRQ_VLS_SIZE-4+1]                          :idu_lsu2_rf_vls_size;
assign lrq_lsu2_rf_vmask_vld     = lsu2_issue_sel_lrq?1'bx                                                                  :idu_lsu2_rf_vmask_vld;
assign lrq_lsu2_rf_vmb_id        = lsu2_issue_sel_lrq?lrq2_rdy_data[LRQ_VMB_ID:LRQ_VMB_ID-VMBENTRY+1]                       :idu_lsu2_rf_vmb_id;
assign lrq_lsu2_rf_vmb_merge_vld = lsu2_issue_sel_lrq?lrq2_rdy_data[LRQ_VMB_MERGE_VLD]                                      :idu_lsu2_rf_vmb_merge_vld;
assign lrq_lsu2_rf_vreg          = lsu2_issue_sel_lrq?lrq2_rdy_data[LRQ_VREG:LRQ_VREG-VREG+1]                               :idu_lsu2_rf_vreg;
assign lrq_lsu2_rf_vmew          = lsu2_issue_sel_lrq?lrq2_rdy_data[LRQ_VMEW:LRQ_VMEW-2+1]                                  :idu_lsu2_rf_inst_vmew;// rvv1.0 @hcl
assign lrq_lsu2_rf_vmop          = lsu2_issue_sel_lrq?lrq2_rdy_data[LRQ_VMOP:LRQ_VMOP-2+1]                                  :idu_lsu2_rf_inst_vmop;// rvv1.0 @hcl
assign lrq_lsu2_rf_nf            = lsu2_issue_sel_lrq?lrq2_rdy_data[LRQ_NF]                                                 :idu_lsu2_rf_inst_nf;
//assign lrq_lsu2_rf_vsew          = lsu2_issue_sel_lrq?lrq2_rdy_data[LRQ_VSEW:LRQ_VSEW-2+1]                                  :idu_lsu2_rf_vsew; // not use in rvv1.0 @hcl
assign lrq_lsu2_rf_pa_vld        = lsu2_issue_sel_lrq?lrq2_rdy_data[LRQ_PA_VLD]                                             :1'b0;
assign lrq_lsu2_rf_pa            = lsu2_issue_sel_lrq?lrq2_rdy_data[LRQ_PA:LRQ_PA-`WK_PA_PAGE_NUM_WIDTH+1]                                     :{`WK_PA_WIDTH-12{1'bx}};
assign lrq_lsu2_rf_attr          = lsu2_issue_sel_lrq?lrq2_rdy_data[LRQ_ATTR:LRQ_ATTR-5+1]                                  :{5{1'bx}};
assign lrq_lsu2_rf_fence_mode    = lsu2_issue_sel_lrq?lrq2_rdy_data[LRQ_FENCE_MODE:LRQ_FENCE_MODE-4+1]                      :idu_lsu2_rf_fence_mode;
assign lrq_lsu2_rf_is_load       = lsu2_issue_sel_lrq?lrq2_rdy_data[LRQ_IS_LOAD]                                            :idu_lsu2_rf_is_load;
assign lrq_lsu2_rf_icc           = lsu2_issue_sel_lrq?lrq2_rdy_data[LRQ_ICC]                                                :idu_lsu2_rf_icc;
assign lrq_lsu2_rf_idx_ord       = lsu2_issue_sel_lrq?lrq2_rdy_data[LRQ_IDX_ORD]                                            :idu_lsu2_rf_idx_ord;
assign lrq_lsu2_rf_inst_flush    = lsu2_issue_sel_lrq?lrq2_rdy_data[LRQ_INST_FLUSH]                                         :idu_lsu2_rf_inst_flush;
assign lrq_lsu2_rf_inst_mode     = lsu2_issue_sel_lrq?lrq2_rdy_data[LRQ_INST_MODE:LRQ_INST_MODE-2+1]                        :idu_lsu2_rf_inst_mode;
assign lrq_lsu2_rf_inst_share    = lsu2_issue_sel_lrq?lrq2_rdy_data[LRQ_INST_SHARE]                                         :idu_lsu2_rf_inst_share;
assign lrq_lsu2_rf_inst_str      = lsu2_issue_sel_lrq?lrq2_rdy_data[LRQ_INST_STR]                                           :idu_lsu2_rf_inst_str;
assign lrq_lsu2_rf_mmu_req       = lsu2_issue_sel_lrq?lrq2_rdy_data[LRQ_MMU_REQ]                                            :idu_lsu2_rf_mmu_req;
assign lrq_lsu2_rf_sdiq_entry    = lsu2_issue_sel_lrq?lrq2_rdy_data[LRQ_SDIQ_ENTRY:LRQ_SDIQ_ENTRY-SDIQENTRY+1]              :idu_lsu2_rf_sdiq_entry;
assign lrq_lsu2_rf_st            = lsu2_issue_sel_lrq?lrq2_rdy_data[LRQ_ST]                                                 :idu_lsu2_rf_st;
assign lrq_lsu2_rf_staddr        = lsu2_issue_sel_lrq?lrq2_rdy_data[LRQ_STADDR]                                             :idu_lsu2_rf_staddr;
assign lrq_lsu2_rf_sync_fence    = lsu2_issue_sel_lrq?lrq2_rdy_data[LRQ_SYNC_FENCE]                                         :idu_lsu2_rf_sync_fence;
assign lrq_lsu2_rf_inst_code     = lsu2_issue_sel_lrq?{32{1'b0}}                                                            :idu_lsu2_rf_inst_code;
assign lrq_lsu2_rf_sfp_dst_pc    = lsu2_issue_sel_lrq?{PC_LEN{1'bx}}                                                        :sfp_lrq2_ex0_dst_pc;
assign lrq_lsu2_rf_sfp_pc_hit    = lsu2_issue_sel_lrq?1'bx                                                                  :sfp_lrq2_ex0_pc_hit;

assign lrq_lsu2_rf_gateclk_sel = lrq_lsu2_rf_sel;
assign lrq_lsu2_rf_lch_entry   = lsu2_issue_sel_lrq? rdy2 : {{LRQENTRY-LSIQENTRY{1'b0}}, idu_lsu2_rf_lch_entry[LSIQENTRY-1:0]}; // LRQENTRY should not smaller than LSIQENTRY
// assign lrq_lsu2_rf_sel         = lsu2_issue_sel_idu && lsu2_issue_permit_idu 
//                                  || lsu2_issue_sel_lrq && lsu2_issue_permit_lrq;
assign lrq_lsu2_rf_sel         = !lsu2_lrq_ex1_stall_vld && (lrq2_has_rdy || idu_lsu2_rf_sel && !lrq2_no_space)
                                 || lsu2_lrq_ex1_stall_vld && (|(lrq2_rdy_older_ex1) || idu_lsu2_rf_sel && idu2_iid_older_ex1 && !lrq2_no_space);

assign lrq_lsu2_rf_older_vld   = |(lrq2_rdy_older_ex1) || idu_lsu2_rf_sel && idu2_iid_older_ex1 && !lrq2_no_space; // timing
// lsu3


assign lrq_lsu3_rf_replay_vld    = lsu3_issue_sel_lrq_final;
assign lrq_lsu3_rf_bytes_vld     = lsu3_issue_sel_lrq?lrq3_rdy_data[LRQ_BYTES_VLD:LRQ_BYTES_VLD-16+1]                       :{16{1'bx}};
assign lrq_lsu3_rf_bytes_vld1    = lsu3_issue_sel_lrq?lrq3_rdy_data[LRQ_BYTES_VLD1:LRQ_BYTES_VLD1-16+1]                     :{16{1'bx}};
assign lrq_lsu3_rf_bytes_vld2    = lsu3_issue_sel_lrq?lrq3_rdy_data[LRQ_BYTES_VLD2:LRQ_BYTES_VLD2-16+1]                     :{16{1'bx}};
assign lrq_lsu3_rf_bytes_vld3    = lsu3_issue_sel_lrq?lrq3_rdy_data[LRQ_BYTES_VLD3:LRQ_BYTES_VLD3-16+1]                     :{16{1'bx}};
assign lrq_lsu3_rf_reg_bytes_vld = lsu3_issue_sel_lrq?lrq3_rdy_data[LRQ_REG_BYTES_VLD:LRQ_REG_BYTES_VLD-16+1]               :{16{1'bx}};
assign lrq_lsu3_rf_reg_bytes_vld1= lsu3_issue_sel_lrq?lrq3_rdy_data[LRQ_REG_BYTES_VLD1:LRQ_REG_BYTES_VLD1-16+1]             :{16{1'bx}};
assign lrq_lsu3_rf_reg_bytes_vld2= lsu3_issue_sel_lrq?lrq3_rdy_data[LRQ_REG_BYTES_VLD2:LRQ_REG_BYTES_VLD2-16+1]             :{16{1'bx}};
assign lrq_lsu3_rf_reg_bytes_vld3= lsu3_issue_sel_lrq?lrq3_rdy_data[LRQ_REG_BYTES_VLD3:LRQ_REG_BYTES_VLD3-16+1]             :{16{1'bx}};
assign lrq_lsu3_rf_boundary      = lsu3_issue_sel_lrq?lrq3_rdy_data[LRQ_BOUNDARY]                                           :1'bx;
assign lrq_lsu3_rf_va            = lsu3_issue_sel_lrq?lrq3_rdy_data[LRQ_VA:LRQ_VA-64+1]                                     :{64{1'bx}};
assign lrq_lsu3_rf_already_da    = lsu3_issue_sel_lrq?lrq3_rdy_data[LRQ_ALREADY_DA]                                         :1'b0;
assign lrq_lsu3_rf_atomic        = lsu3_issue_sel_lrq?lrq3_rdy_data[LRQ_ATOMIC]                                             :idu_lsu3_rf_atomic;
assign lrq_lsu3_rf_iid           = lsu3_issue_sel_lrq?lrq3_rdy_data[LRQ_IID:LRQ_IID-IID_WIDTH+1]                            :idu_lsu3_rf_iid;
assign lrq_lsu3_rf_inst_fls      = lsu3_issue_sel_lrq?lrq3_rdy_data[LRQ_INST_FLS]                                           :idu_lsu3_rf_inst_fls;
assign lrq_lsu3_rf_inst_fof      = lsu3_issue_sel_lrq?lrq3_rdy_data[LRQ_INST_FOF]                                           :idu_lsu3_rf_inst_fof;
assign lrq_lsu3_rf_inst_ldr      = lsu3_issue_sel_lrq?1'bx                                                                  :idu_lsu3_rf_inst_ldr;
assign lrq_lsu3_rf_inst_size     = lsu3_issue_sel_lrq?lrq3_rdy_data[LRQ_INST_SIZE:LRQ_INST_SIZE-2+1]                        :idu_lsu3_rf_inst_size;
assign lrq_lsu3_rf_inst_type     = lsu3_issue_sel_lrq?lrq3_rdy_data[LRQ_INST_TYPE:LRQ_INST_TYPE-2+1]                        :idu_lsu3_rf_inst_type;
assign lrq_lsu3_rf_inst_vls      = lsu3_issue_sel_lrq?lrq3_rdy_data[LRQ_INST_VLS]                                           :idu_lsu3_rf_inst_vls;
assign lrq_lsu3_rf_lsfifo        = lsu3_issue_sel_lrq?lrq3_rdy_data[LRQ_LSFIFO]                                             :idu_lsu3_rf_lsfifo;
//assign lrq_lsu3_rf_mlen          = lsu3_issue_sel_lrq?3'bxxx                                                                :idu_lsu3_rf_mlen;//not use in rvv1.0 @hcl
assign lrq_lsu3_rf_no_spec       = lsu3_issue_sel_lrq?2'bxx                                                                 :idu_lsu3_rf_no_spec;
// assign lrq_lsu3_rf_no_spec_exist = lsu3_issue_sel_lrq?1'bx                                                                  :idu_lsu3_rf_no_spec_exist;
assign lrq_lsu3_rf_no_spec_exist = lsu3_issue_sel_lrq?lrq3_rdy_data[LRQ_NOSPEC_EXIST]                                       :1'b0;
assign lrq_lsu3_rf_zext          = lsu3_issue_sel_lrq?1'bx                                                                  :idu_lsu3_rf_zext;
assign lrq_lsu3_rf_offset        = lsu3_issue_sel_lrq?{12{1'b0}}                                                            :idu_lsu3_rf_offset;
assign lrq_lsu3_rf_offset_plus   = lsu3_issue_sel_lrq?{13{1'b0}}                                                            :idu_lsu3_rf_offset_plus;
assign lrq_lsu3_rf_oldest        = lsu3_issue_sel_lrq?lrq3_rdy_data[LRQ_OLDEST]                                             :idu_lsu3_rf_oldest & !lrq_older_than_lsiq;
assign lrq_lsu3_rf_pc            = lsu3_issue_sel_lrq?lrq3_rdy_data[LRQ_PC:LRQ_PC-PC_LEN+1]                                 :idu_lsu3_rf_pc;
assign lrq_lsu3_rf_preg          = lsu3_issue_sel_lrq?lrq3_rdy_data[LRQ_PREG:LRQ_PREG-PREG+1]                               :idu_lsu3_rf_preg;
assign lrq_lsu3_rf_shift         = lsu3_issue_sel_lrq?4'b0000                                                               :idu_lsu3_rf_shift;
assign lrq_lsu3_rf_sext          = lsu3_issue_sel_lrq?lrq3_rdy_data[LRQ_SEXT]                                               :idu_lsu3_rf_sext;
assign lrq_lsu3_rf_spec_fail     = lsu3_issue_sel_lrq?lrq3_rdy_data[LRQ_SPEC_FAIL]                                          :1'b0;
assign lrq_lsu3_rf_split         = lsu3_issue_sel_lrq?lrq3_rdy_data[LRQ_SPLIT]                                              :idu_lsu3_rf_split;
assign lrq_lsu3_rf_split_num     = lsu3_issue_sel_lrq?lrq3_rdy_data[LRQ_SPLIT_NUM:LRQ_SPLIT_NUM-9+1]                        :idu_lsu3_rf_split_num;
assign lrq_lsu3_rf_src0          = lsu3_issue_sel_lrq?{64{1'bx}}                                                            :idu_lsu3_rf_src0;
assign lrq_lsu3_rf_src1          = lsu3_issue_sel_lrq?{64{1'bx}}                                                            :idu_lsu3_rf_src1;
assign lrq_lsu3_rf_srcvm_vr0     = lsu3_issue_sel_lrq?{256{1'bx}}                                                            :idu_lsu3_rf_srcvm_vr0;
assign lrq_lsu3_rf_srcvm_vr1     = lsu3_issue_sel_lrq?{256{1'bx}}                                                            :idu_lsu3_rf_srcvm_vr1;
assign lrq_lsu3_rf_unal2nd       = lsu3_issue_sel_lrq?lrq3_rdy_data[LRQ_UNAL2ND]                                            :1'b0;
assign lrq_lsu3_rf_unit_stride   = lsu3_issue_sel_lrq?lrq3_rdy_data[LRQ_UNIT_STRIDE]                                        :idu_lsu3_rf_unit_stride;
assign lrq_lsu3_rf_vl            = lsu3_issue_sel_lrq?{`VL_WIDTH{1'bx}}                                                             :idu_lsu3_rf_vl;
// assign lrq_lsu3_rf_vlmul         = lsu3_issue_sel_lrq?lrq3_rdy_data[LRQ_VLMUL:LRQ_VLMUL-2+1]                                :idu_lsu3_rf_vlmul;
assign lrq_lsu3_rf_vlmul         = lsu3_issue_sel_lrq?lrq3_rdy_data[LRQ_VLMUL:LRQ_VLMUL-2]                                  :idu_lsu3_rf_vlmul;
assign lrq_lsu3_rf_vls_size      = lsu3_issue_sel_lrq?lrq3_rdy_data[LRQ_VLS_SIZE:LRQ_VLS_SIZE-4+1]                          :idu_lsu3_rf_vls_size;
assign lrq_lsu3_rf_vmask_vld     = lsu3_issue_sel_lrq?1'bx                                                                  :idu_lsu3_rf_vmask_vld;
assign lrq_lsu3_rf_vmb_id        = lsu3_issue_sel_lrq?lrq3_rdy_data[LRQ_VMB_ID:LRQ_VMB_ID-VMBENTRY+1]                       :idu_lsu3_rf_vmb_id;
assign lrq_lsu3_rf_vmb_merge_vld = lsu3_issue_sel_lrq?lrq3_rdy_data[LRQ_VMB_MERGE_VLD]                                      :idu_lsu3_rf_vmb_merge_vld;
assign lrq_lsu3_rf_vreg          = lsu3_issue_sel_lrq?lrq3_rdy_data[LRQ_VREG:LRQ_VREG-VREG+1]                               :idu_lsu3_rf_vreg;
assign lrq_lsu3_rf_vmew          = lsu3_issue_sel_lrq?lrq3_rdy_data[LRQ_VMEW:LRQ_VMEW-2+1]                                  :idu_lsu3_rf_inst_vmew;// rvv1.0 @hcl
assign lrq_lsu3_rf_vmop          = lsu3_issue_sel_lrq?lrq3_rdy_data[LRQ_VMOP:LRQ_VMOP-2+1]                                  :idu_lsu3_rf_inst_vmop;// rvv1.0 @hcl
assign lrq_lsu3_rf_nf            = lsu3_issue_sel_lrq?lrq3_rdy_data[LRQ_NF]                                                 :idu_lsu3_rf_inst_nf;
//assign lrq_lsu3_rf_vsew          = lsu3_issue_sel_lrq?lrq3_rdy_data[LRQ_VSEW:LRQ_VSEW-2+1]                                  :idu_lsu3_rf_vsew; // not use in rvv1.0 @hcl
assign lrq_lsu3_rf_pa_vld        = lsu3_issue_sel_lrq?lrq3_rdy_data[LRQ_PA_VLD]                                             :1'b0;
assign lrq_lsu3_rf_pa            = lsu3_issue_sel_lrq?lrq3_rdy_data[LRQ_PA:LRQ_PA-`WK_PA_PAGE_NUM_WIDTH+1]                                     :{`WK_PA_WIDTH-12{1'bx}};
assign lrq_lsu3_rf_attr          = lsu3_issue_sel_lrq?lrq3_rdy_data[LRQ_ATTR:LRQ_ATTR-5+1]                                  :{5{1'bx}};
assign lrq_lsu3_rf_fence_mode    = lsu3_issue_sel_lrq?lrq3_rdy_data[LRQ_FENCE_MODE:LRQ_FENCE_MODE-4+1]                      :idu_lsu3_rf_fence_mode;
assign lrq_lsu3_rf_is_load       = lsu3_issue_sel_lrq?lrq3_rdy_data[LRQ_IS_LOAD]                                            :idu_lsu3_rf_is_load;
assign lrq_lsu3_rf_icc           = lsu3_issue_sel_lrq?lrq3_rdy_data[LRQ_ICC]                                                :idu_lsu3_rf_icc;
assign lrq_lsu3_rf_idx_ord       = lsu3_issue_sel_lrq?lrq3_rdy_data[LRQ_IDX_ORD]                                            :idu_lsu3_rf_idx_ord;
assign lrq_lsu3_rf_inst_flush    = lsu3_issue_sel_lrq?lrq3_rdy_data[LRQ_INST_FLUSH]                                         :idu_lsu3_rf_inst_flush;
assign lrq_lsu3_rf_inst_mode     = lsu3_issue_sel_lrq?lrq3_rdy_data[LRQ_INST_MODE:LRQ_INST_MODE-2+1]                        :idu_lsu3_rf_inst_mode;
assign lrq_lsu3_rf_inst_share    = lsu3_issue_sel_lrq?lrq3_rdy_data[LRQ_INST_SHARE]                                         :idu_lsu3_rf_inst_share;
assign lrq_lsu3_rf_inst_str      = lsu3_issue_sel_lrq?lrq3_rdy_data[LRQ_INST_STR]                                           :idu_lsu3_rf_inst_str;
assign lrq_lsu3_rf_mmu_req       = lsu3_issue_sel_lrq?lrq3_rdy_data[LRQ_MMU_REQ]                                            :idu_lsu3_rf_mmu_req;
assign lrq_lsu3_rf_sdiq_entry    = lsu3_issue_sel_lrq?lrq3_rdy_data[LRQ_SDIQ_ENTRY:LRQ_SDIQ_ENTRY-SDIQENTRY+1]              :idu_lsu3_rf_sdiq_entry;
assign lrq_lsu3_rf_st            = lsu3_issue_sel_lrq?lrq3_rdy_data[LRQ_ST]                                                 :idu_lsu3_rf_st;
assign lrq_lsu3_rf_staddr        = lsu3_issue_sel_lrq?lrq3_rdy_data[LRQ_STADDR]                                             :idu_lsu3_rf_staddr;
assign lrq_lsu3_rf_sync_fence    = lsu3_issue_sel_lrq?lrq3_rdy_data[LRQ_SYNC_FENCE]                                         :idu_lsu3_rf_sync_fence;
assign lrq_lsu3_rf_inst_code     = lsu3_issue_sel_lrq?{32{1'b0}}                                                            :idu_lsu3_rf_inst_code;
assign lrq_lsu3_rf_sfp_dst_pc    = lsu3_issue_sel_lrq?{PC_LEN{1'bx}}                                                        :sfp_lrq3_ex0_dst_pc;
assign lrq_lsu3_rf_sfp_pc_hit    = lsu3_issue_sel_lrq?1'bx                                                                  :sfp_lrq3_ex0_pc_hit;

assign lrq_lsu3_rf_gateclk_sel = lrq_lsu3_rf_sel;
assign lrq_lsu3_rf_lch_entry   = lsu3_issue_sel_lrq? rdy3 : {{LRQENTRY-LSIQENTRY{1'b0}}, idu_lsu3_rf_lch_entry[LSIQENTRY-1:0]}; // LRQENTRY should not smaller than LSIQENTRY
// assign lrq_lsu3_rf_sel         = lsu3_issue_sel_idu && lsu3_issue_permit_idu 
//                                  || lsu3_issue_sel_lrq && lsu3_issue_permit_lrq;
assign lrq_lsu3_rf_sel         = !lsu3_lrq_ex1_stall_vld && (lrq3_has_rdy || idu_lsu3_rf_sel && !lrq3_no_space)
                                 || lsu3_lrq_ex1_stall_vld && (|(lrq3_rdy_older_ex1) || idu_lsu3_rf_sel && idu3_iid_older_ex1 && !lrq3_no_space);

assign lrq_lsu3_rf_older_vld   = (|(lrq3_rdy_older_ex1) || idu_lsu3_rf_sel && idu3_iid_older_ex1 && !lrq3_no_space); // wjh@timing
endmodule
