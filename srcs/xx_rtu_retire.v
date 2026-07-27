//-----------------------------------------------------------------------------
// File          : xx_rtu_retire.v
// Created       : 2024/10/01 (by Zhao Xia)
// Last modified : 2024/12/25 (by Deng Haowen)
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
// 2024/10/01 : Created
// 2024/12/18 : Increase retire width from 4 to 6. (by Deng Haowen)
// 2024/12/25 : Add mux logic for rtu_ifu_*_chk_idx/condbr/conbr_taken/jmp. (by Deng Haowen)
//-----------------------------------------------------------------------------

//#
//# Module Declaration
//# ==================
//#


// $Id: xx_rtu_retire.vp,v 1.56.32.3 2023/10/11 07:14:08 liuc Exp $
// *****************************************************************************

module xx_rtu_retire#(
    parameter IID_WIDTH = 9
)(
  cp0_rtu_icg_en,
  cp0_rtu_srt_en,
  cpurst_b,
  forever_cpuclk,
  hpcp_rtu_cnt_en,
  lsu_rtu_all_commit_data_vld,
  lsu_rtu_async_expt_addr,
  lsu_rtu_async_expt_vld,
  lsu_rtu_ctc_flush_vld,
  mmu_xx_mmu_en,
  pad_yy_icg_scan_en,
  pst_retire_retired_reg_wb,
  retire_pst_async_flush,
  retire_pst_wb_retire_inst0_ereg_vld,
  retire_pst_wb_retire_inst0_preg_vld,
  retire_pst_wb_retire_inst0_vreg_vld,
  retire_pst_wb_retire_inst1_ereg_vld,
  retire_pst_wb_retire_inst1_preg_vld,
  retire_pst_wb_retire_inst1_vreg_vld,
  retire_pst_wb_retire_inst2_ereg_vld,
  retire_pst_wb_retire_inst2_preg_vld,
  retire_pst_wb_retire_inst2_vreg_vld,
  retire_pst_wb_retire_inst3_ereg_vld,
  retire_pst_wb_retire_inst3_preg_vld,
  retire_pst_wb_retire_inst3_vreg_vld,
  retire_pst_wb_retire_inst4_ereg_vld,
  retire_pst_wb_retire_inst4_preg_vld,
  retire_pst_wb_retire_inst4_vreg_vld,
  retire_pst_wb_retire_inst5_ereg_vld,
  retire_pst_wb_retire_inst5_preg_vld,
  retire_pst_wb_retire_inst5_vreg_vld,
  retire_rob_async_expt_commit_mask,
  retire_rob_ctc_flush_req,
  retire_rob_dbg_inst0_ack_int,
  retire_rob_dbg_inst0_dbg_mode_on,
  retire_rob_dbg_inst0_expt_vld,
  retire_rob_dbg_inst0_flush,
  retire_rob_dbg_inst0_mispred,
  retire_rob_flush,
  retire_rob_flush_cur_state,
  retire_rob_flush_gateclk,
  retire_rob_inst0_jmp,
  retire_rob_inst1_jmp,
  retire_rob_inst2_jmp,
  retire_rob_inst3_jmp,
  retire_rob_inst4_jmp,
  retire_rob_inst5_jmp,
  retire_rob_inst_flush,
  retire_rob_retire_empty,
  retire_rob_rt_mask,
  retire_rob_split_fof_flush,
  retire_rob_srt_en,
  retire_top_ae_cur_state,
  rob_retire_commit0,
  rob_retire_commit1,
  rob_retire_commit2,
  rob_retire_commit3,
  rob_retire_commit4,
  rob_retire_commit5,
  rob_retire_ctc_flush_srt_en,
  rob_retire_inst0_uncondbr,
  rob_retire_inst1_uncondbr,
  rob_retire_inst2_uncondbr,
  rob_retire_inst3_uncondbr,
  rob_retire_inst4_uncondbr,
  rob_retire_inst5_uncondbr,
  rob_retire_inst0_bht_mispred,
  rob_retire_inst0_bju,
  rob_retire_inst0_bju_inc_pc,
  rob_retire_inst0_chk_idx,
  rob_retire_inst0_condbr,
  rob_retire_inst0_condbr_taken,
  rob_retire_inst0_ctc_flush,
  rob_retire_inst0_cur_pc,
  rob_retire_inst0_dbg_disable,
  rob_retire_inst0_efpc_vld,
  rob_retire_inst0_expt_ecc,
  rob_retire_inst0_expt_vec,
  rob_retire_inst0_expt_vld,
  rob_retire_inst0_fp_dirty,
  rob_retire_inst0_high_hw_expt,
  rob_retire_inst0_iid,
  rob_retire_inst0_immu_expt,
  rob_retire_inst0_inst_flush,
  rob_retire_inst0_int_vec,
  rob_retire_inst0_int_vld,
  rob_retire_inst0_intmask,
  rob_retire_inst0_jmp,
  rob_retire_inst0_jmp_mispred,
  rob_retire_inst0_load,
  rob_retire_inst0_mtval,
  rob_retire_inst0_next_pc,
  rob_retire_inst0_no_spec_hit,
  rob_retire_inst0_no_spec_mispred,
  rob_retire_inst0_no_spec_miss,
  rob_retire_inst0_no_spec_target,
  rob_retire_inst0_num,
  rob_retire_inst0_pc_offset,
  rob_retire_inst0_pcal,
  rob_retire_inst0_pret,
  rob_retire_inst0_pst_ereg_vld,
  rob_retire_inst0_pst_preg_vld,
  rob_retire_inst0_pst_vreg_vld,
  rob_retire_inst0_ras,
  rob_retire_inst0_spec_fail,
  rob_retire_inst0_spec_fail_no_ssf,
  rob_retire_inst0_spec_fail_ssf,
  rob_retire_inst0_split,
  rob_retire_inst0_store,
  rob_retire_inst0_vec_dirty,
  rob_retire_inst0_vl,
  rob_retire_inst0_vl_pred,
  rob_retire_inst0_vld,
  rob_retire_inst0_vlmul,
  rob_retire_inst0_vsetvl,
  rob_retire_inst0_vsetvli,
  rob_retire_inst0_vsew,
  rob_retire_inst0_vstart,
  rob_retire_inst0_vstart_vld,
  rob_retire_inst0_vma,  // add by tmj @20251120, rob_retire_inst{0-5}_{vma/vta}
  rob_retire_inst0_vta,
  rob_retire_inst1_bju,
  rob_retire_inst1_chk_idx,
  rob_retire_inst1_condbr,
  rob_retire_inst1_condbr_taken,
  rob_retire_inst1_cur_pc,
  rob_retire_inst1_fp_dirty,
  rob_retire_inst1_jmp,
  rob_retire_inst1_load,
  rob_retire_inst1_next_pc,
  rob_retire_inst1_no_spec_hit,
  rob_retire_inst1_no_spec_mispred,
  rob_retire_inst1_no_spec_miss,
  rob_retire_inst1_no_spec_target,
  rob_retire_inst1_num,
  rob_retire_inst1_pc_offset,
  rob_retire_inst1_pst_ereg_vld,
  rob_retire_inst1_pst_preg_vld,
  rob_retire_inst1_pst_vreg_vld,
  rob_retire_inst1_split,
  rob_retire_inst1_store,
  rob_retire_inst1_vec_dirty,
  rob_retire_inst1_vl,
  rob_retire_inst1_vl_pred,
  rob_retire_inst1_vld,
  rob_retire_inst1_vlmul,
  rob_retire_inst1_vsetvli,
  rob_retire_inst1_vsew, 
  rob_retire_inst1_vma,
  rob_retire_inst1_vta,
  rob_retire_inst2_bju,
  rob_retire_inst2_chk_idx,
  rob_retire_inst2_condbr,
  rob_retire_inst2_condbr_taken,
  rob_retire_inst2_cur_pc,
  rob_retire_inst2_fp_dirty,
  rob_retire_inst2_jmp,
  rob_retire_inst2_load,
  rob_retire_inst2_next_pc,
  rob_retire_inst2_no_spec_hit,
  rob_retire_inst2_no_spec_mispred,
  rob_retire_inst2_no_spec_miss,
  rob_retire_inst2_no_spec_target,
  rob_retire_inst2_num,
  rob_retire_inst2_pc_offset,
  rob_retire_inst2_pst_ereg_vld,
  rob_retire_inst2_pst_preg_vld,
  rob_retire_inst2_pst_vreg_vld,
  rob_retire_inst2_split,
  rob_retire_inst2_store,
  rob_retire_inst2_vec_dirty,
  rob_retire_inst2_vl,
  rob_retire_inst2_vl_pred,
  rob_retire_inst2_vld,
  rob_retire_inst2_vlmul,
  rob_retire_inst2_vsetvli,
  rob_retire_inst2_vsew, 
  rob_retire_inst2_vma,
  rob_retire_inst2_vta,
  rob_retire_inst3_bju,
  rob_retire_inst3_chk_idx,
  rob_retire_inst3_condbr,
  rob_retire_inst3_condbr_taken,
  rob_retire_inst3_cur_pc,
  rob_retire_inst3_fp_dirty,
  rob_retire_inst3_jmp,
  rob_retire_inst3_load,
  rob_retire_inst3_next_pc,
  rob_retire_inst3_no_spec_hit,
  rob_retire_inst3_no_spec_mispred,
  rob_retire_inst3_no_spec_miss,
  rob_retire_inst3_no_spec_target,
  rob_retire_inst3_num,
  rob_retire_inst3_pc_offset,
  rob_retire_inst3_pst_ereg_vld,
  rob_retire_inst3_pst_preg_vld,
  rob_retire_inst3_pst_vreg_vld,
  rob_retire_inst3_split,
  rob_retire_inst3_store,
  rob_retire_inst3_vec_dirty,
  rob_retire_inst3_vl,
  rob_retire_inst3_vl_pred,
  rob_retire_inst3_vld,
  rob_retire_inst3_vlmul,
  rob_retire_inst3_vsetvli,
  rob_retire_inst3_vsew, 
  rob_retire_inst3_vma,
  rob_retire_inst3_vta,
  rob_retire_inst4_bju,
  rob_retire_inst4_chk_idx,
  rob_retire_inst4_condbr,
  rob_retire_inst4_condbr_taken,
  rob_retire_inst4_cur_pc,
  rob_retire_inst4_fp_dirty,
  rob_retire_inst4_jmp,
  rob_retire_inst4_load,
  rob_retire_inst4_next_pc,
  rob_retire_inst4_no_spec_hit,
  rob_retire_inst4_no_spec_mispred,
  rob_retire_inst4_no_spec_miss,
  rob_retire_inst4_no_spec_target,
  rob_retire_inst4_num,
  rob_retire_inst4_pc_offset,
  rob_retire_inst4_pst_ereg_vld,
  rob_retire_inst4_pst_preg_vld,
  rob_retire_inst4_pst_vreg_vld,
  rob_retire_inst4_split,
  rob_retire_inst4_store,
  rob_retire_inst4_vec_dirty,
  rob_retire_inst4_vl,
  rob_retire_inst4_vl_pred,
  rob_retire_inst4_vld,
  rob_retire_inst4_vlmul,
  rob_retire_inst4_vsetvli,
  rob_retire_inst4_vsew, 
  rob_retire_inst4_vma,
  rob_retire_inst4_vta,
  rob_retire_inst5_bju,
  rob_retire_inst5_chk_idx,
  rob_retire_inst5_condbr,
  rob_retire_inst5_condbr_taken,
  rob_retire_inst5_cur_pc,
  rob_retire_inst5_fp_dirty,
  rob_retire_inst5_jmp,
  rob_retire_inst5_load,
  rob_retire_inst5_next_pc,
  rob_retire_inst5_no_spec_hit,
  rob_retire_inst5_no_spec_mispred,
  rob_retire_inst5_no_spec_miss,
  rob_retire_inst5_no_spec_target,
  rob_retire_inst5_num,
  rob_retire_inst5_pc_offset,
  rob_retire_inst5_pst_ereg_vld,
  rob_retire_inst5_pst_preg_vld,
  rob_retire_inst5_pst_vreg_vld,
  rob_retire_inst5_split,
  rob_retire_inst5_store,
  rob_retire_inst5_vec_dirty,
  rob_retire_inst5_vl,
  rob_retire_inst5_vl_pred,
  rob_retire_inst5_vld,
  rob_retire_inst5_vlmul,
  rob_retire_inst5_vsetvli,
  rob_retire_inst5_vsew, 
  rob_retire_inst5_vma,
  rob_retire_inst5_vta,
  rob_retire_int_srt_en,
  rob_retire_rob_cur_pc,
  rob_retire_split_spec_fail_srt,
  rob_retire_ssf_iid,
  rtu_cp0_epc,
  rtu_cp0_expt_gateclk_vld,
  rtu_cp0_expt_mtval,
  rtu_cp0_expt_vld,
  rtu_cp0_fp_dirty_vld,
  rtu_cp0_int_ack,
  rtu_cp0_vec_dirty_vld,
  rtu_cp0_vsetvl_vill,
  rtu_cp0_vsetvl_vl,
  rtu_cp0_vsetvl_vl_vld,
  rtu_cp0_vsetvl_vlmul,
  rtu_cp0_vsetvl_vsew,
  rtu_cp0_vsetvl_vta,
  rtu_cp0_vsetvl_vma,
  rtu_cp0_vsetvl_vtype_vld,
  rtu_cp0_vstart,
  rtu_cp0_vstart_vld,
  rtu_hpcp_inst0_ack_int,
  rtu_hpcp_inst0_bht_mispred,
  rtu_hpcp_inst0_condbr,
  rtu_hpcp_inst0_jmp,
  rtu_hpcp_inst0_jmp_mispred,
  rtu_hpcp_inst0_num,
  rtu_hpcp_inst0_pc_offset,
  rtu_hpcp_inst0_spec_fail,
  rtu_hpcp_inst0_split,
  rtu_hpcp_inst0_store,
  rtu_hpcp_inst0_vld,
  rtu_hpcp_inst1_condbr,
  rtu_hpcp_inst1_jmp,
  rtu_hpcp_inst1_num,
  rtu_hpcp_inst1_pc_offset,
  rtu_hpcp_inst1_split,
  rtu_hpcp_inst1_store,
  rtu_hpcp_inst1_vld,
  rtu_hpcp_inst2_condbr,
  rtu_hpcp_inst2_jmp,
  rtu_hpcp_inst2_num,
  rtu_hpcp_inst2_pc_offset,
  rtu_hpcp_inst2_split,
  rtu_hpcp_inst2_store,
  rtu_hpcp_inst2_vld,
  rtu_hpcp_inst3_condbr,
  rtu_hpcp_inst3_jmp,
  rtu_hpcp_inst3_num,
  rtu_hpcp_inst3_pc_offset,
  rtu_hpcp_inst3_split,
  rtu_hpcp_inst3_store,
  rtu_hpcp_inst3_vld,
  rtu_hpcp_inst4_condbr,
  rtu_hpcp_inst4_jmp,
  rtu_hpcp_inst4_num,
  rtu_hpcp_inst4_pc_offset,
  rtu_hpcp_inst4_split,
  rtu_hpcp_inst4_store,
  rtu_hpcp_inst4_vld,
  rtu_hpcp_inst5_condbr,
  rtu_hpcp_inst5_jmp,
  rtu_hpcp_inst5_num,
  rtu_hpcp_inst5_pc_offset,
  rtu_hpcp_inst5_split,
  rtu_hpcp_inst5_store,
  rtu_hpcp_inst5_vld,
  rtu_hpcp_trace_inst0_chgflow,
  rtu_hpcp_trace_inst0_next_pc,
  rtu_hpcp_trace_inst1_chgflow,
  rtu_hpcp_trace_inst1_next_pc,
  rtu_hpcp_trace_inst2_chgflow,
  rtu_hpcp_trace_inst2_next_pc,
  rtu_hpcp_trace_inst3_chgflow,
  rtu_hpcp_trace_inst3_next_pc,
  rtu_hpcp_trace_inst4_chgflow,
  rtu_hpcp_trace_inst4_next_pc,
  rtu_hpcp_trace_inst5_chgflow,
  rtu_hpcp_trace_inst5_next_pc,
  rtu_idu_flush_fe,
  rtu_idu_flush_is,
  rtu_idu_flush_stall,
  rtu_idu_retire0_inst_vld,
  rtu_idu_srt_en,
  rtu_ifu_chgflw_pc,
  rtu_ifu_chgflw_vld,
  rtu_ifu_flush,
  rtu_ifu_retire0_uncondbr,
  rtu_ifu_retire1_uncondbr,
  rtu_ifu_retire2_uncondbr,
  rtu_ifu_retire3_uncondbr,
  rtu_ifu_retire4_uncondbr,
  rtu_ifu_retire5_uncondbr,
  rtu_ifu_retire0_chk_idx,
  rtu_ifu_retire0_condbr,
  rtu_ifu_retire0_condbr_taken,
  rtu_ifu_retire0_inc_pc,
  rtu_ifu_retire0_jmp,
  rtu_ifu_retire0_jmp_mispred,
  rtu_ifu_retire0_mispred,
  //rtu_ifu_retire0_next_pc,
  rtu_ifu_retire0_pcall,
  rtu_ifu_retire0_preturn,
  rtu_ifu_retire1_chk_idx,
  rtu_ifu_retire1_condbr,
  rtu_ifu_retire1_condbr_taken,
  rtu_ifu_retire1_jmp,
  rtu_ifu_retire2_chk_idx,
  rtu_ifu_retire2_condbr,
  rtu_ifu_retire2_condbr_taken,
  rtu_ifu_retire2_jmp,
  rtu_ifu_retire3_chk_idx,
  rtu_ifu_retire3_condbr,
  rtu_ifu_retire3_condbr_taken,
  rtu_ifu_retire3_jmp,
  rtu_ifu_retire4_chk_idx,
  rtu_ifu_retire4_condbr,
  rtu_ifu_retire4_condbr_taken,
  rtu_ifu_retire4_jmp,
  rtu_ifu_retire5_chk_idx,
  rtu_ifu_retire5_condbr,
  rtu_ifu_retire5_condbr_taken,
  rtu_ifu_retire5_jmp,
  rtu_ifu_retire_inst0_cur_pc,
  rtu_ifu_retire_inst0_load,
  rtu_ifu_retire_inst0_no_spec_hit,
  rtu_ifu_retire_inst0_no_spec_mispred,
  rtu_ifu_retire_inst0_no_spec_miss,
  rtu_ifu_retire_inst0_no_spec_target,
  rtu_ifu_retire_inst0_store,
  rtu_ifu_retire_inst0_vl_hit,
  rtu_ifu_retire_inst0_vl_mispred,
  rtu_ifu_retire_inst0_vl_miss,
  rtu_ifu_retire_inst0_vl_pred,
  rtu_ifu_retire_inst1_cur_pc,
  rtu_ifu_retire_inst1_load,
  rtu_ifu_retire_inst1_no_spec_hit,
  rtu_ifu_retire_inst1_no_spec_mispred,
  rtu_ifu_retire_inst1_no_spec_miss,
  rtu_ifu_retire_inst1_no_spec_target,
  rtu_ifu_retire_inst1_store,
  rtu_ifu_retire_inst1_vl_pred,
  rtu_ifu_retire_inst2_cur_pc,
  rtu_ifu_retire_inst2_load,
  rtu_ifu_retire_inst2_no_spec_hit,
  rtu_ifu_retire_inst2_no_spec_mispred,
  rtu_ifu_retire_inst2_no_spec_miss,
  rtu_ifu_retire_inst2_no_spec_target,
  rtu_ifu_retire_inst2_store,
  rtu_ifu_retire_inst2_vl_pred,
  rtu_ifu_retire_inst3_cur_pc,
  rtu_ifu_retire_inst3_load,
  rtu_ifu_retire_inst3_no_spec_hit,
  rtu_ifu_retire_inst3_no_spec_mispred,
  rtu_ifu_retire_inst3_no_spec_miss,
  rtu_ifu_retire_inst3_no_spec_target,
  rtu_ifu_retire_inst3_store,
  rtu_ifu_retire_inst3_vl_pred,
  rtu_ifu_retire_inst4_cur_pc,
  rtu_ifu_retire_inst4_load,
  rtu_ifu_retire_inst4_no_spec_hit,
  rtu_ifu_retire_inst4_no_spec_mispred,
  rtu_ifu_retire_inst4_no_spec_miss,
  rtu_ifu_retire_inst4_no_spec_target,
  rtu_ifu_retire_inst4_store,
  rtu_ifu_retire_inst4_vl_pred,
  rtu_ifu_retire_inst5_cur_pc,
  rtu_ifu_retire_inst5_load,
  rtu_ifu_retire_inst5_no_spec_hit,
  rtu_ifu_retire_inst5_no_spec_mispred,
  rtu_ifu_retire_inst5_no_spec_miss,
  rtu_ifu_retire_inst5_no_spec_target,
  rtu_ifu_retire_inst5_store,
  rtu_ifu_retire_inst5_vl_pred,
  rtu_ifu_xx_dbgon,
  rtu_ifu_xx_expt_vec,
  rtu_ifu_xx_expt_vld,
  rtu_iu_flush_chgflw_mask,
  rtu_iu_flush_fe,
  rtu_lsu_async_flush,
  rtu_lsu_eret_flush,
  rtu_lsu_expt_flush,
  rtu_lsu_flush_fe,
  rtu_lsu_spec_fail_flush,
  rtu_lsu_spec_fail_iid,
  rtu_mmu_bad_vpn,
  rtu_mmu_expt_vld,
  rtu_yy_xx_dbgon,
  rtu_yy_xx_expt_ecc,
  rtu_yy_xx_expt_vec,
  rtu_yy_xx_flush,
  async_flush,
  retire_flush_sm_no_idle,
  retire_inst0_flush,
//==========================================================
//                  Risc-V Debug zdb Begin
//==========================================================
  //input
  cp0_yy_mmu_en,
  dtu_rtu_async_halt_req,
  dtu_rtu_dpc,
  dtu_rtu_ebreak_action,
  dtu_rtu_group_halt_req,
  dtu_rtu_int_mask,
  dtu_rtu_mdbgen,
  dtu_rtu_pending_tval,
  dtu_rtu_resume_req,
  dtu_rtu_sync_flush,
  dtu_rtu_sync_halt_req,
  ifu_rtu_reset_halt_req,
  retire_inst0_cancel,
  rob_retire_fof_err_srt,
  rob_retire_inst0_abnormal_for_gateclk,
  rob_retire_inst0_dret,
  rob_retire_inst0_ebreak,
  rob_retire_inst0_ecall,
  rob_retire_inst0_haltinfo,
  rob_retire_inst0_mret,
  rob_retire_inst0_sret,
  rob_retire_inst0_t0_halt_vld,
  rob_retire_t1_haltinfo_srt,
  //output
  retire_rob_dbg_req_en,
  retire_rob_exit_debug,
  rtu_cp0_dbg_pm,
  rtu_cp0_enter_debug,
  rtu_cp0_exit_debug,
  rtu_dtu_dpc,
  rtu_dtu_halt_ack,
  rtu_dtu_pending_ack,
  rtu_dtu_retire0_chgflw_pc,
  rtu_dtu_retire0_chgflw_vld,
  rtu_dtu_retire0_halt_info,
  rtu_dtu_retire0_mret,
  rtu_dtu_retire0_mret_gateclk,
  rtu_dtu_retire0_split,
  rtu_dtu_retire0_sret,
  rtu_dtu_retire0_vld,
  rtu_dtu_retire1_chgflw_pc,
  rtu_dtu_retire1_chgflw_vld,
  rtu_dtu_retire2_chgflw_pc,
  rtu_dtu_retire2_chgflw_vld,
  rtu_dtu_retire3_chgflw_pc,
  rtu_dtu_retire3_chgflw_vld,
  rtu_dtu_retire4_chgflw_pc,
  rtu_dtu_retire4_chgflw_vld,
  rtu_dtu_retire5_chgflw_pc,
  rtu_dtu_retire5_chgflw_vld,
  rtu_dtu_retire_chgflw_gateclk_vld,
  rtu_dtu_retire_debug_expt_vld,
  rtu_dtu_tval,
  rtu_yy_xx_expt_vld,
  rtu_yy_xx_expt_int
//==========================================================
//                  Risc-V Debug zdb End
//==========================================================
);

input           cp0_rtu_icg_en;                      
input           cp0_rtu_srt_en;                      
input           cpurst_b;                            
input           forever_cpuclk;                                                                                      
input           hpcp_rtu_cnt_en;                     
input           lsu_rtu_all_commit_data_vld;         
input   [`WK_PA_WIDTH-1:0]  lsu_rtu_async_expt_addr;             
input           lsu_rtu_async_expt_vld;              
input           lsu_rtu_ctc_flush_vld;               
input           mmu_xx_mmu_en;                       
input           pad_yy_icg_scan_en;                  
input           pst_retire_retired_reg_wb;           
input           rob_retire_commit0;                  
input           rob_retire_commit1;                  
input           rob_retire_commit2; 
// add rob_retire_commit3-5. dhw@20241218                 
input           rob_retire_commit3;                  
input           rob_retire_commit4;                  
input           rob_retire_commit5;                  
input           rob_retire_ctc_flush_srt_en;         
input           rob_retire_inst0_uncondbr;             
input           rob_retire_inst1_uncondbr;             
input           rob_retire_inst2_uncondbr;             
input           rob_retire_inst3_uncondbr;             
input           rob_retire_inst4_uncondbr;             
input           rob_retire_inst5_uncondbr;             
input           rob_retire_inst0_bht_mispred;        
input           rob_retire_inst0_bju;                
input   [`WK_PC_LEN-1:0]  rob_retire_inst0_bju_inc_pc;                      
input   [7 :0]  rob_retire_inst0_chk_idx;            
input           rob_retire_inst0_condbr;             
input           rob_retire_inst0_condbr_taken;       
input           rob_retire_inst0_ctc_flush;          
input   [`WK_PC_LEN-1:0]  rob_retire_inst0_cur_pc;                     
input           rob_retire_inst0_dbg_disable;        
input           rob_retire_inst0_efpc_vld;           
input           rob_retire_inst0_expt_ecc;           
input   [3 :0]  rob_retire_inst0_expt_vec;           
input           rob_retire_inst0_expt_vld;           
input           rob_retire_inst0_fp_dirty;           
input           rob_retire_inst0_high_hw_expt;       
input   [IID_WIDTH - 1 :0]  rob_retire_inst0_iid;                
input           rob_retire_inst0_immu_expt;                   
input           rob_retire_inst0_inst_flush;         
input   [4 :0]  rob_retire_inst0_int_vec;            
input           rob_retire_inst0_int_vld;            
input           rob_retire_inst0_intmask;            
input           rob_retire_inst0_jmp;                
input           rob_retire_inst0_jmp_mispred;        
input           rob_retire_inst0_load;               
input   [`WK_PA_WIDTH:0]  rob_retire_inst0_mtval;              
input   [`WK_PC_LEN-1:0]  rob_retire_inst0_next_pc;            
input           rob_retire_inst0_no_spec_hit;        
input           rob_retire_inst0_no_spec_mispred;    
input           rob_retire_inst0_no_spec_miss;       
input           rob_retire_inst0_no_spec_target;     
input   [1 :0]  rob_retire_inst0_num;                
input   [2 :0]  rob_retire_inst0_pc_offset;          
input           rob_retire_inst0_pcal;               
input           rob_retire_inst0_pret;               
input           rob_retire_inst0_pst_ereg_vld;       
input           rob_retire_inst0_pst_preg_vld;       
input           rob_retire_inst0_pst_vreg_vld;       
input           rob_retire_inst0_ras;                
input           rob_retire_inst0_spec_fail;          
input           rob_retire_inst0_spec_fail_no_ssf;   
input           rob_retire_inst0_spec_fail_ssf;      
input           rob_retire_inst0_split;              
input           rob_retire_inst0_store;              
input           rob_retire_inst0_vec_dirty;          
input   [`VL_WIDTH-1 :0]  rob_retire_inst0_vl;                 
input           rob_retire_inst0_vl_pred;            
input           rob_retire_inst0_vld;                
input   [2 :0]  rob_retire_inst0_vlmul;              
input           rob_retire_inst0_vsetvl;             
input           rob_retire_inst0_vsetvli;            
input   [2 :0]  rob_retire_inst0_vsew;               
input   [`VSTART_WIDTH-1 :0]  rob_retire_inst0_vstart;             
input           rob_retire_inst0_vstart_vld;
input           rob_retire_inst0_vma; // add by tmj @20251120
input           rob_retire_inst0_vta; // add by tmj @20251120
input           rob_retire_inst1_bju;                
input   [7 :0]  rob_retire_inst1_chk_idx;            
input           rob_retire_inst1_condbr;             
input           rob_retire_inst1_condbr_taken;       
input   [`WK_PC_LEN-1:0]  rob_retire_inst1_cur_pc;             
input           rob_retire_inst1_fp_dirty;           
input           rob_retire_inst1_jmp;                
input           rob_retire_inst1_load;               
input   [`WK_PC_LEN-1:0]  rob_retire_inst1_next_pc;            
input           rob_retire_inst1_no_spec_hit;        
input           rob_retire_inst1_no_spec_mispred;    
input           rob_retire_inst1_no_spec_miss;       
input           rob_retire_inst1_no_spec_target;     
input   [1 :0]  rob_retire_inst1_num;                
input   [2 :0]  rob_retire_inst1_pc_offset;          
input           rob_retire_inst1_pst_ereg_vld;       
input           rob_retire_inst1_pst_preg_vld;       
input           rob_retire_inst1_pst_vreg_vld;       
input           rob_retire_inst1_split;              
input           rob_retire_inst1_store;              
input           rob_retire_inst1_vec_dirty;          
input   [`VL_WIDTH-1 :0]  rob_retire_inst1_vl;                 
input           rob_retire_inst1_vl_pred;            
input           rob_retire_inst1_vld;                
input   [2 :0]  rob_retire_inst1_vlmul;              
input           rob_retire_inst1_vsetvli;            
input   [2 :0]  rob_retire_inst1_vsew;       
input           rob_retire_inst1_vma;
input           rob_retire_inst1_vta;        
input           rob_retire_inst2_bju;                
input   [7 :0]  rob_retire_inst2_chk_idx;            
input           rob_retire_inst2_condbr;             
input           rob_retire_inst2_condbr_taken;       
input   [`WK_PC_LEN-1:0]  rob_retire_inst2_cur_pc;             
input           rob_retire_inst2_fp_dirty;           
input           rob_retire_inst2_jmp;                
input           rob_retire_inst2_load;               
input   [`WK_PC_LEN-1:0]  rob_retire_inst2_next_pc;            
input           rob_retire_inst2_no_spec_hit;        
input           rob_retire_inst2_no_spec_mispred;    
input           rob_retire_inst2_no_spec_miss;       
input           rob_retire_inst2_no_spec_target;     
input   [1 :0]  rob_retire_inst2_num;                
input   [2 :0]  rob_retire_inst2_pc_offset;          
input           rob_retire_inst2_pst_ereg_vld;       
input           rob_retire_inst2_pst_preg_vld;       
input           rob_retire_inst2_pst_vreg_vld;       
input           rob_retire_inst2_split;              
input           rob_retire_inst2_store;              
input           rob_retire_inst2_vec_dirty;          
input   [`VL_WIDTH-1 :0]  rob_retire_inst2_vl;                 
input           rob_retire_inst2_vl_pred;            
input           rob_retire_inst2_vld;                
input   [2 :0]  rob_retire_inst2_vlmul;              
input           rob_retire_inst2_vsetvli;            
input   [2 :0]  rob_retire_inst2_vsew;   
input           rob_retire_inst2_vma;
input           rob_retire_inst2_vta;
// add rob_retire_inst3-5*. dhw@20241218            
input           rob_retire_inst3_bju;                
input   [7 :0]  rob_retire_inst3_chk_idx;            
input           rob_retire_inst3_condbr;             
input           rob_retire_inst3_condbr_taken;       
input   [`WK_PC_LEN-1:0]  rob_retire_inst3_cur_pc;             
input           rob_retire_inst3_fp_dirty;           
input           rob_retire_inst3_jmp;                
input           rob_retire_inst3_load;               
input   [`WK_PC_LEN-1:0]  rob_retire_inst3_next_pc;            
input           rob_retire_inst3_no_spec_hit;        
input           rob_retire_inst3_no_spec_mispred;    
input           rob_retire_inst3_no_spec_miss;       
input           rob_retire_inst3_no_spec_target;     
input   [1 :0]  rob_retire_inst3_num;                
input   [2 :0]  rob_retire_inst3_pc_offset;          
input           rob_retire_inst3_pst_ereg_vld;       
input           rob_retire_inst3_pst_preg_vld;       
input           rob_retire_inst3_pst_vreg_vld;       
input           rob_retire_inst3_split;              
input           rob_retire_inst3_store;              
input           rob_retire_inst3_vec_dirty;          
input   [`VL_WIDTH-1 :0]  rob_retire_inst3_vl;                 
input           rob_retire_inst3_vl_pred;            
input           rob_retire_inst3_vld;                
input   [2 :0]  rob_retire_inst3_vlmul;              
input           rob_retire_inst3_vsetvli;            
input   [2 :0]  rob_retire_inst3_vsew;       
input           rob_retire_inst3_vma;
input           rob_retire_inst3_vta;        
input           rob_retire_inst4_bju;                
input   [7 :0]  rob_retire_inst4_chk_idx;            
input           rob_retire_inst4_condbr;             
input           rob_retire_inst4_condbr_taken;       
input   [`WK_PC_LEN-1:0]  rob_retire_inst4_cur_pc;             
input           rob_retire_inst4_fp_dirty;           
input           rob_retire_inst4_jmp;                
input           rob_retire_inst4_load;               
input   [`WK_PC_LEN-1:0]  rob_retire_inst4_next_pc;            
input           rob_retire_inst4_no_spec_hit;        
input           rob_retire_inst4_no_spec_mispred;    
input           rob_retire_inst4_no_spec_miss;       
input           rob_retire_inst4_no_spec_target;     
input   [1 :0]  rob_retire_inst4_num;                
input   [2 :0]  rob_retire_inst4_pc_offset;          
input           rob_retire_inst4_pst_ereg_vld;       
input           rob_retire_inst4_pst_preg_vld;       
input           rob_retire_inst4_pst_vreg_vld;       
input           rob_retire_inst4_split;              
input           rob_retire_inst4_store;              
input           rob_retire_inst4_vec_dirty;          
input   [`VL_WIDTH-1 :0]  rob_retire_inst4_vl;                 
input           rob_retire_inst4_vl_pred;            
input           rob_retire_inst4_vld;                
input   [2 :0]  rob_retire_inst4_vlmul;              
input           rob_retire_inst4_vsetvli;            
input   [2 :0]  rob_retire_inst4_vsew; 
input           rob_retire_inst4_vma;
input           rob_retire_inst4_vta;              
input           rob_retire_inst5_bju;                
input   [7 :0]  rob_retire_inst5_chk_idx;            
input           rob_retire_inst5_condbr;             
input           rob_retire_inst5_condbr_taken;       
input   [`WK_PC_LEN-1:0]  rob_retire_inst5_cur_pc;             
input           rob_retire_inst5_fp_dirty;           
input           rob_retire_inst5_jmp;                
input           rob_retire_inst5_load;               
input   [`WK_PC_LEN-1:0]  rob_retire_inst5_next_pc;            
input           rob_retire_inst5_no_spec_hit;        
input           rob_retire_inst5_no_spec_mispred;    
input           rob_retire_inst5_no_spec_miss;       
input           rob_retire_inst5_no_spec_target;     
input   [1 :0]  rob_retire_inst5_num;                
input   [2 :0]  rob_retire_inst5_pc_offset;          
input           rob_retire_inst5_pst_ereg_vld;       
input           rob_retire_inst5_pst_preg_vld;       
input           rob_retire_inst5_pst_vreg_vld;       
input           rob_retire_inst5_split;              
input           rob_retire_inst5_store;              
input           rob_retire_inst5_vec_dirty;          
input   [`VL_WIDTH-1 :0]  rob_retire_inst5_vl;                 
input           rob_retire_inst5_vl_pred;            
input           rob_retire_inst5_vld;                
input   [2 :0]  rob_retire_inst5_vlmul;              
input           rob_retire_inst5_vsetvli;            
input   [2 :0]  rob_retire_inst5_vsew; 
input           rob_retire_inst5_vma;
input           rob_retire_inst5_vta;              
input           rob_retire_int_srt_en;               
input   [`WK_PC_LEN-1:0]  rob_retire_rob_cur_pc;               
input           rob_retire_split_spec_fail_srt;      
input   [IID_WIDTH - 1 :0]  rob_retire_ssf_iid;                  
output          retire_pst_async_flush;              
output          retire_pst_wb_retire_inst0_ereg_vld; 
output          retire_pst_wb_retire_inst0_preg_vld; 
output          retire_pst_wb_retire_inst0_vreg_vld; 
output          retire_pst_wb_retire_inst1_ereg_vld; 
output          retire_pst_wb_retire_inst1_preg_vld; 
output          retire_pst_wb_retire_inst1_vreg_vld; 
output          retire_pst_wb_retire_inst2_ereg_vld; 
output          retire_pst_wb_retire_inst2_preg_vld; 
output          retire_pst_wb_retire_inst2_vreg_vld; 
// add retire_pst_wb_retire_inst3-5*. dhw@20241218
output          retire_pst_wb_retire_inst3_ereg_vld; 
output          retire_pst_wb_retire_inst3_preg_vld; 
output          retire_pst_wb_retire_inst3_vreg_vld; 
output          retire_pst_wb_retire_inst4_ereg_vld; 
output          retire_pst_wb_retire_inst4_preg_vld; 
output          retire_pst_wb_retire_inst4_vreg_vld; 
output          retire_pst_wb_retire_inst5_ereg_vld; 
output          retire_pst_wb_retire_inst5_preg_vld; 
output          retire_pst_wb_retire_inst5_vreg_vld; 
output          retire_rob_async_expt_commit_mask;   
output          retire_rob_ctc_flush_req;            
output          retire_rob_dbg_inst0_ack_int;        
output          retire_rob_dbg_inst0_dbg_mode_on;    
output          retire_rob_dbg_inst0_expt_vld;       
output          retire_rob_dbg_inst0_flush;          
output          retire_rob_dbg_inst0_mispred;        
output          retire_rob_flush;                    
output  [4 :0]  retire_rob_flush_cur_state;          
output          retire_rob_flush_gateclk;            
output          retire_rob_inst0_jmp;                
output          retire_rob_inst1_jmp;                
output          retire_rob_inst2_jmp;    
// add retire_rob_inst3-5_jmp. dhw@20241218            
output          retire_rob_inst3_jmp;                
output          retire_rob_inst4_jmp;                
output          retire_rob_inst5_jmp;                
output          retire_rob_inst_flush;               
output          retire_rob_retire_empty;             
output          retire_rob_rt_mask;                  
output          retire_rob_split_fof_flush;          
output          retire_rob_srt_en;                   
output  [1 :0]  retire_top_ae_cur_state;             
output  [63:0]  rtu_cp0_epc;                         
output          rtu_cp0_expt_gateclk_vld;            
output  [63:0]  rtu_cp0_expt_mtval;                  
output          rtu_cp0_expt_vld;                    
output          rtu_cp0_fp_dirty_vld;                
output          rtu_cp0_int_ack;                     
output          rtu_cp0_vec_dirty_vld;               
output          rtu_cp0_vsetvl_vill;                 
output  [`VL_WIDTH-1 :0]  rtu_cp0_vsetvl_vl;                   
output          rtu_cp0_vsetvl_vl_vld;               
output  [2 :0]  rtu_cp0_vsetvl_vlmul;    // add by tmj @20251022            
output  [2 :0]  rtu_cp0_vsetvl_vsew;                 
output          rtu_cp0_vsetvl_vta;// add by tmj @20251120
output          rtu_cp0_vsetvl_vma;// add by tmj @20251120
output          rtu_cp0_vsetvl_vtype_vld;            
output  [`VSTART_WIDTH-1 :0]  rtu_cp0_vstart;                      
output          rtu_cp0_vstart_vld;                                          
output          rtu_hpcp_inst0_ack_int;              
output          rtu_hpcp_inst0_bht_mispred;          
output          rtu_hpcp_inst0_condbr;               
output          rtu_hpcp_inst0_jmp;                  
output          rtu_hpcp_inst0_jmp_mispred;          
output  [1 :0]  rtu_hpcp_inst0_num;                  
output  [2 :0]  rtu_hpcp_inst0_pc_offset;            
output          rtu_hpcp_inst0_spec_fail;            
output          rtu_hpcp_inst0_split;                
output          rtu_hpcp_inst0_store;                
output          rtu_hpcp_inst0_vld;                  
output          rtu_hpcp_inst1_condbr;               
output          rtu_hpcp_inst1_jmp;                  
output  [1 :0]  rtu_hpcp_inst1_num;                  
output  [2 :0]  rtu_hpcp_inst1_pc_offset;            
output          rtu_hpcp_inst1_split;                
output          rtu_hpcp_inst1_store;                
output          rtu_hpcp_inst1_vld;                  
output          rtu_hpcp_inst2_condbr;               
output          rtu_hpcp_inst2_jmp;                  
output  [1 :0]  rtu_hpcp_inst2_num;                  
output  [2 :0]  rtu_hpcp_inst2_pc_offset;            
output          rtu_hpcp_inst2_split;                
output          rtu_hpcp_inst2_store;                
output          rtu_hpcp_inst2_vld;                  
output          rtu_hpcp_inst3_condbr;               
output          rtu_hpcp_inst3_jmp;                  
output  [1 :0]  rtu_hpcp_inst3_num;                  
output  [2 :0]  rtu_hpcp_inst3_pc_offset;            
output          rtu_hpcp_inst3_split;                
output          rtu_hpcp_inst3_store;                
output          rtu_hpcp_inst3_vld;                  
output          rtu_hpcp_inst4_condbr;               
output          rtu_hpcp_inst4_jmp;                  
output  [1 :0]  rtu_hpcp_inst4_num;                  
output  [2 :0]  rtu_hpcp_inst4_pc_offset;            
output          rtu_hpcp_inst4_split;                
output          rtu_hpcp_inst4_store;                
output          rtu_hpcp_inst4_vld;                  
output          rtu_hpcp_inst5_condbr;               
output          rtu_hpcp_inst5_jmp;                  
output  [1 :0]  rtu_hpcp_inst5_num;                  
output  [2 :0]  rtu_hpcp_inst5_pc_offset;            
output          rtu_hpcp_inst5_split;                
output          rtu_hpcp_inst5_store;                
output          rtu_hpcp_inst5_vld;                  
output          rtu_hpcp_trace_inst0_chgflow;        
output  [`WK_PC_LEN-1:0]  rtu_hpcp_trace_inst0_next_pc;        
output          rtu_hpcp_trace_inst1_chgflow;        
output  [`WK_PC_LEN-1:0]  rtu_hpcp_trace_inst1_next_pc;        
output          rtu_hpcp_trace_inst2_chgflow;        
output  [`WK_PC_LEN-1:0]  rtu_hpcp_trace_inst2_next_pc;        
output          rtu_hpcp_trace_inst3_chgflow;        
output  [`WK_PC_LEN-1:0]  rtu_hpcp_trace_inst3_next_pc;        
output          rtu_hpcp_trace_inst4_chgflow;        
output  [`WK_PC_LEN-1:0]  rtu_hpcp_trace_inst4_next_pc;        
output          rtu_hpcp_trace_inst5_chgflow;        
output  [`WK_PC_LEN-1:0]  rtu_hpcp_trace_inst5_next_pc;        
output          rtu_idu_flush_fe;                    
output          rtu_idu_flush_is;                    
output          rtu_idu_flush_stall;                 
output          rtu_idu_retire0_inst_vld;            
output          rtu_idu_srt_en;                      
output  [`WK_PC_LEN-1:0]  rtu_ifu_chgflw_pc;                   
output          rtu_ifu_chgflw_vld;                  
output          rtu_ifu_flush;                       
output          rtu_ifu_retire0_uncondbr;              
output          rtu_ifu_retire1_uncondbr;              
output          rtu_ifu_retire2_uncondbr;              
output          rtu_ifu_retire3_uncondbr;              
output          rtu_ifu_retire4_uncondbr;              
output          rtu_ifu_retire5_uncondbr;              
output  [7 :0]  rtu_ifu_retire0_chk_idx;             
output          rtu_ifu_retire0_condbr;              
output          rtu_ifu_retire0_condbr_taken;        
output  [`WK_PC_LEN-1:0]  rtu_ifu_retire0_inc_pc;              
output          rtu_ifu_retire0_jmp;                 
output          rtu_ifu_retire0_jmp_mispred;         
output          rtu_ifu_retire0_mispred;             
//output  [`WK_PC_LEN-1:0]  rtu_ifu_retire0_next_pc;             
output          rtu_ifu_retire0_pcall;               
output          rtu_ifu_retire0_preturn;             
output  [7 :0]  rtu_ifu_retire1_chk_idx;             
output          rtu_ifu_retire1_condbr;              
output          rtu_ifu_retire1_condbr_taken;        
output          rtu_ifu_retire1_jmp;                 
output  [7 :0]  rtu_ifu_retire2_chk_idx;             
output          rtu_ifu_retire2_condbr;              
output          rtu_ifu_retire2_condbr_taken;        
output          rtu_ifu_retire2_jmp;      
output  [7  :0]  rtu_ifu_retire3_chk_idx;
output           rtu_ifu_retire3_condbr;
output           rtu_ifu_retire3_condbr_taken;
output           rtu_ifu_retire3_jmp;
output  [7  :0]  rtu_ifu_retire4_chk_idx;
output           rtu_ifu_retire4_condbr;
output           rtu_ifu_retire4_condbr_taken;
output           rtu_ifu_retire4_jmp;
output  [7  :0]  rtu_ifu_retire5_chk_idx;
output           rtu_ifu_retire5_condbr;
output           rtu_ifu_retire5_condbr_taken;
output           rtu_ifu_retire5_jmp;
output  [`WK_PC_LEN-1:0]  rtu_ifu_retire_inst0_cur_pc;         
output          rtu_ifu_retire_inst0_load;           
output          rtu_ifu_retire_inst0_no_spec_hit;    
output          rtu_ifu_retire_inst0_no_spec_mispred; 
output          rtu_ifu_retire_inst0_no_spec_miss;   
output          rtu_ifu_retire_inst0_no_spec_target; 
output          rtu_ifu_retire_inst0_store;          
output          rtu_ifu_retire_inst0_vl_hit;         
output          rtu_ifu_retire_inst0_vl_mispred;     
output          rtu_ifu_retire_inst0_vl_miss;        
output          rtu_ifu_retire_inst0_vl_pred;        
output  [`WK_PC_LEN-1:0]  rtu_ifu_retire_inst1_cur_pc;         
output          rtu_ifu_retire_inst1_load;           
output          rtu_ifu_retire_inst1_no_spec_hit;    
output          rtu_ifu_retire_inst1_no_spec_mispred; 
output          rtu_ifu_retire_inst1_no_spec_miss;   
output          rtu_ifu_retire_inst1_no_spec_target; 
output          rtu_ifu_retire_inst1_store;          
output          rtu_ifu_retire_inst1_vl_pred;        
output  [`WK_PC_LEN-1:0]  rtu_ifu_retire_inst2_cur_pc;         
output          rtu_ifu_retire_inst2_load;           
output          rtu_ifu_retire_inst2_no_spec_hit;    
output          rtu_ifu_retire_inst2_no_spec_mispred; 
output          rtu_ifu_retire_inst2_no_spec_miss;   
output          rtu_ifu_retire_inst2_no_spec_target; 
output          rtu_ifu_retire_inst2_store;          
output          rtu_ifu_retire_inst2_vl_pred;     
// add rtu_ifu_retire_inst3-5*. dhw@20241218   
output  [`WK_PC_LEN-1:0]  rtu_ifu_retire_inst3_cur_pc;         
output          rtu_ifu_retire_inst3_load;           
output          rtu_ifu_retire_inst3_no_spec_hit;    
output          rtu_ifu_retire_inst3_no_spec_mispred; 
output          rtu_ifu_retire_inst3_no_spec_miss;   
output          rtu_ifu_retire_inst3_no_spec_target; 
output          rtu_ifu_retire_inst3_store;          
output          rtu_ifu_retire_inst3_vl_pred;        
output  [`WK_PC_LEN-1:0]  rtu_ifu_retire_inst4_cur_pc;         
output          rtu_ifu_retire_inst4_load;           
output          rtu_ifu_retire_inst4_no_spec_hit;    
output          rtu_ifu_retire_inst4_no_spec_mispred; 
output          rtu_ifu_retire_inst4_no_spec_miss;   
output          rtu_ifu_retire_inst4_no_spec_target; 
output          rtu_ifu_retire_inst4_store;          
output          rtu_ifu_retire_inst4_vl_pred;        
output  [`WK_PC_LEN-1:0]  rtu_ifu_retire_inst5_cur_pc;         
output          rtu_ifu_retire_inst5_load;           
output          rtu_ifu_retire_inst5_no_spec_hit;    
output          rtu_ifu_retire_inst5_no_spec_mispred; 
output          rtu_ifu_retire_inst5_no_spec_miss;   
output          rtu_ifu_retire_inst5_no_spec_target; 
output          rtu_ifu_retire_inst5_store;          
output          rtu_ifu_retire_inst5_vl_pred;        
output          rtu_ifu_xx_dbgon;                    
output  [5 :0]  rtu_ifu_xx_expt_vec;                 
output          rtu_ifu_xx_expt_vld;                 
output          rtu_iu_flush_chgflw_mask;            
output          rtu_iu_flush_fe;                     
output          rtu_lsu_async_flush;                 
output          rtu_lsu_eret_flush;                  
output          rtu_lsu_expt_flush;                  
output          rtu_lsu_flush_fe;                    
output          rtu_lsu_spec_fail_flush;             
output  [IID_WIDTH - 1 :0]  rtu_lsu_spec_fail_iid;               
output  [`WK_PC_LEN-1-12:0]  rtu_mmu_bad_vpn;                     
output          rtu_mmu_expt_vld;                    
output          rtu_yy_xx_dbgon;                     
output          rtu_yy_xx_expt_ecc;                  
output  [5 :0]  rtu_yy_xx_expt_vec;                  
output          rtu_yy_xx_flush;                                
output          async_flush;
output          retire_flush_sm_no_idle; 
output          retire_inst0_flush;
reg     [1 :0]  ae_cur_state;                        
reg     [1 :0]  ae_next_state;                       
reg     [`WK_PA_WIDTH-1:0]  ae_phy_addr;                         
reg             async_flush_ff;                      
reg             dbg_mode_on;                         
reg     [4 :0]  flush_cur_state;                     
reg             flush_eret;                          
reg             flush_expt;                          
reg     [4 :0]  flush_next_state;                    
reg             flush_spec_fail;                     
reg             ifu_dbg_mode_on;                     
reg             retire_ctc_flush_req;                
reg     [63:0]  retire_expt_mtval_src;               
reg             retire_hpcp_inst0_ack_int;           
reg             retire_hpcp_inst0_bht_mispred;       
reg             retire_hpcp_inst0_condbr;            
reg             retire_hpcp_inst0_jmp;               
reg             retire_hpcp_inst0_jmp_mispred;       
reg     [1 :0]  retire_hpcp_inst0_num;               
reg     [2 :0]  retire_hpcp_inst0_pc_offset;         
reg             retire_hpcp_inst0_spec_fail;         
reg             retire_hpcp_inst0_split;             
reg             retire_hpcp_inst0_store;             
reg             retire_hpcp_inst1_condbr;            
reg             retire_hpcp_inst1_jmp;               
reg     [1 :0]  retire_hpcp_inst1_num;               
reg     [2 :0]  retire_hpcp_inst1_pc_offset;         
reg             retire_hpcp_inst1_split;             
reg             retire_hpcp_inst1_store;             
reg             retire_hpcp_inst2_condbr;            
reg             retire_hpcp_inst2_jmp;               
reg     [1 :0]  retire_hpcp_inst2_num;               
reg     [2 :0]  retire_hpcp_inst2_pc_offset;         
reg             retire_hpcp_inst2_split;             
reg             retire_hpcp_inst2_store;      
// add retire_hpcp_inst3-5*. dhw@20241218       
reg             retire_hpcp_inst3_condbr;            
reg             retire_hpcp_inst3_jmp;               
reg     [1 :0]  retire_hpcp_inst3_num;               
reg     [2 :0]  retire_hpcp_inst3_pc_offset;         
reg             retire_hpcp_inst3_split;             
reg             retire_hpcp_inst3_store;             
reg             retire_hpcp_inst4_condbr;            
reg             retire_hpcp_inst4_jmp;               
reg     [1 :0]  retire_hpcp_inst4_num;               
reg     [2 :0]  retire_hpcp_inst4_pc_offset;         
reg             retire_hpcp_inst4_split;             
reg             retire_hpcp_inst4_store;             
reg             retire_hpcp_inst5_condbr;            
reg             retire_hpcp_inst5_jmp;               
reg     [1 :0]  retire_hpcp_inst5_num;               
reg     [2 :0]  retire_hpcp_inst5_pc_offset;         
reg             retire_hpcp_inst5_split;             
reg             retire_hpcp_inst5_store;             
reg             retire_ifu_chgflw_vld;               
reg             retire_retire_hpcp_inst0_vld;        
reg             retire_retire_hpcp_inst1_vld;        
reg             retire_retire_hpcp_inst2_vld;    
// add retire_retire_hpcp_inst3-5_vld. dhw@20241218    
reg             retire_retire_hpcp_inst3_vld;        
reg             retire_retire_hpcp_inst4_vld;        
reg             retire_retire_hpcp_inst5_vld;        
reg     [`VL_WIDTH-1 :0]  rtu_cp0_vsetvl_vl;                   
reg     [2 :0]  rtu_cp0_vsetvl_vlmul;      // add by tmj @20251022          
reg     [2 :0]  rtu_cp0_vsetvl_vsew;                 
reg             rtu_cp0_vsetvl_vta; // add by tmj @20251120
reg             rtu_cp0_vsetvl_vma; // add by tmj @20251120
reg     [5 :0]  rtu_ifu_xx_expt_vec;                 
reg             rtu_ifu_xx_expt_vld;                 
wire    [7 :0]  rtu_ifu_retire1_chk_idx;             
wire            rtu_ifu_retire1_condbr;              
wire            rtu_ifu_retire1_condbr_taken;        
wire            rtu_ifu_retire1_jmp;                 
wire    [7 :0]  rtu_ifu_retire2_chk_idx;             
wire            rtu_ifu_retire2_condbr;              
wire            rtu_ifu_retire2_condbr_taken;        
wire            rtu_ifu_retire2_jmp;   
wire    [7  :0]  rtu_ifu_retire3_chk_idx;
wire             rtu_ifu_retire3_condbr;
wire             rtu_ifu_retire3_condbr_taken;
wire             rtu_ifu_retire3_jmp;
wire    [7  :0]  rtu_ifu_retire4_chk_idx;
wire             rtu_ifu_retire4_condbr;
wire             rtu_ifu_retire4_condbr_taken;
wire             rtu_ifu_retire4_jmp;
wire    [7  :0]  rtu_ifu_retire5_chk_idx;
wire             rtu_ifu_retire5_condbr;
wire             rtu_ifu_retire5_condbr_taken;
wire             rtu_ifu_retire5_jmp;
reg     [IID_WIDTH - 1 :0]  spec_fail_iid;                       

wire            async_flush;                         
wire            cp0_rtu_icg_en;                      
wire            cp0_rtu_srt_en;                      
wire            cpurst_b;                                     
wire            forever_cpuclk;                                                                                   
wire            hpcp_clk;                            
wire            hpcp_clk_en;                         
wire            hpcp_rtu_cnt_en;                     
wire            instret_mask;                        
wire            lsu_rtu_all_commit_data_vld;         
wire    [`WK_PA_WIDTH-1:0]  lsu_rtu_async_expt_addr;             
wire            lsu_rtu_async_expt_vld;              
wire            lsu_rtu_ctc_flush_vld;               
wire            mmu_xx_mmu_en;                       
wire            pad_yy_icg_scan_en;                  
wire            pst_retire_retired_reg_wb;           
wire            retire_ack_int;                      
wire            retire_ack_mmu;                      
wire            retire_async_expt;                   
wire            retire_async_expt_no_commit;         
wire            retire_async_expt_no_retire;         
wire            retire_async_expt_sm_no_idle;        
wire    [5 :0]  retire_async_expt_vec;               
wire            retire_async_expt_vld;               
wire            retire_clk;                          
wire            retire_clk_en;                       
wire    [`WK_PC_LEN-1:0]  retire_cp0_epc;                      
wire            retire_ctc_flush_lsu_req;            
wire            retire_expt_ecc;                     
wire            retire_expt_gateclk_vld;             
wire            retire_expt_inst;                    
wire            retire_expt_int;                     
wire            retire_expt_mmu_bad_vpn;             
wire    [63:0]  retire_expt_mtval;                   
wire    [5 :0]  retire_expt_vec;                     
wire            retire_expt_vld;                     
wire            retire_flush_be;                     
wire            retire_flush_fe;                     
wire            retire_flush_is;                     
wire            retire_flush_pipeline_empty;         
wire            retire_flush_sm_no_idle;             
wire            retire_ifu_expt_ecc;                 
wire    [5 :0]  retire_ifu_expt_vec;                 
wire            retire_ifu_expt_vld;                 
wire            retire_inst0_condbr;                 
wire    [`WK_PC_LEN-1:0]  retire_inst0_epc;                    
wire            retire_inst0_flush;                  
wire            retire_inst0_flush_gateclk;          
wire            retire_inst0_inst_flush;             
wire            retire_inst0_jmp;                    
wire            retire_inst0_jmp_mispred;            
wire            retire_inst0_mispred;                
wire            retire_inst0_normal_retire;          
wire            retire_inst0_vsetvl_illegal;         
wire            retire_inst0_vsetvl_vl_fof;          
wire            retire_inst0_vsetvl_vl_mispred;      
wire            retire_inst0_vsetvli;                
wire            retire_inst0_vsetvlx;                
wire            retire_inst1_condbr;                 
wire            retire_inst1_jmp;                    
wire            retire_inst1_normal_retire;          
wire            retire_inst1_vsetvli;                
wire            retire_inst2_condbr;                 
wire            retire_inst2_jmp;                    
wire            retire_inst2_normal_retire;          
wire            retire_inst2_vsetvli;  
// add retire_inst3-5*. dhw@20241218              
wire            retire_inst3_condbr;                 
wire            retire_inst3_jmp;                    
wire            retire_inst3_normal_retire;          
wire            retire_inst3_vsetvli;                
wire            retire_inst4_condbr;                 
wire            retire_inst4_jmp;                    
wire            retire_inst4_normal_retire;          
wire            retire_inst4_vsetvli;                
wire            retire_inst5_condbr;                 
wire            retire_inst5_jmp;                    
wire            retire_inst5_normal_retire;          
wire            retire_inst5_vsetvli;                
wire            retire_pst_async_flush;              
wire            retire_pst_wb_retire_inst0_ereg_vld; 
wire            retire_pst_wb_retire_inst0_preg_vld; 
wire            retire_pst_wb_retire_inst0_vreg_vld; 
wire            retire_pst_wb_retire_inst1_ereg_vld; 
wire            retire_pst_wb_retire_inst1_preg_vld; 
wire            retire_pst_wb_retire_inst1_vreg_vld; 
wire            retire_pst_wb_retire_inst2_ereg_vld; 
wire            retire_pst_wb_retire_inst2_preg_vld; 
wire            retire_pst_wb_retire_inst2_vreg_vld; 
// add retire_pst_wb_retire_inst3-5*. dhw@20241218
wire            retire_pst_wb_retire_inst3_ereg_vld; 
wire            retire_pst_wb_retire_inst3_preg_vld; 
wire            retire_pst_wb_retire_inst3_vreg_vld; 
wire            retire_pst_wb_retire_inst4_ereg_vld; 
wire            retire_pst_wb_retire_inst4_preg_vld; 
wire            retire_pst_wb_retire_inst4_vreg_vld; 
wire            retire_pst_wb_retire_inst5_ereg_vld; 
wire            retire_pst_wb_retire_inst5_preg_vld; 
wire            retire_pst_wb_retire_inst5_vreg_vld; 
wire            retire_rob_async_expt_commit_mask;   
wire            retire_rob_ctc_flush_req;            
wire            retire_rob_dbg_inst0_ack_int;        
wire            retire_rob_dbg_inst0_dbg_mode_on;    
wire            retire_rob_dbg_inst0_expt_vld;       
wire            retire_rob_dbg_inst0_flush;          
wire            retire_rob_dbg_inst0_mispred;        
wire            retire_rob_flush;                    
wire    [4 :0]  retire_rob_flush_cur_state;          
wire            retire_rob_flush_gateclk;            
wire            retire_rob_inst0_jmp;                
wire            retire_rob_inst1_jmp;                
wire            retire_rob_inst2_jmp;   
// add retire_rob_inst3-5_jmp. dhw@20241218             
wire            retire_rob_inst3_jmp;                
wire            retire_rob_inst4_jmp;                
wire            retire_rob_inst5_jmp;                
wire            retire_rob_inst_flush;               
wire            retire_rob_retire_empty;             
wire            retire_rob_rt_mask;                  
wire            retire_rob_split_fof_flush;          
wire            retire_rob_srt_en;                   
wire            retire_srt_en;                       
wire    [1 :0]  retire_top_ae_cur_state;             
wire            rob_retire_commit0;                  
wire            rob_retire_commit1;                  
wire            rob_retire_commit2;   
// add rob_retire_commit3-5. dhw@20241218               
wire            rob_retire_commit3;                  
wire            rob_retire_commit4;                  
wire            rob_retire_commit5;                  
wire            rob_retire_ctc_flush_srt_en;         
wire            rob_retire_inst0_uncondbr;             
wire            rob_retire_inst1_uncondbr;             
wire            rob_retire_inst2_uncondbr;             
wire            rob_retire_inst3_uncondbr;             
wire            rob_retire_inst4_uncondbr;             
wire            rob_retire_inst5_uncondbr;             
wire            rob_retire_inst0_bht_mispred;        
wire            rob_retire_inst0_bju;                
wire    [`WK_PC_LEN-1:0]  rob_retire_inst0_bju_inc_pc;                      
wire    [7 :0]  rob_retire_inst0_chk_idx;            
wire            rob_retire_inst0_condbr;             
wire            rob_retire_inst0_condbr_taken;       
wire            rob_retire_inst0_ctc_flush;          
wire    [`WK_PC_LEN-1:0]  rob_retire_inst0_cur_pc;                      
wire            rob_retire_inst0_dbg_disable;        
wire            rob_retire_inst0_efpc_vld;           
wire            rob_retire_inst0_expt_ecc;           
wire    [3 :0]  rob_retire_inst0_expt_vec;           
wire            rob_retire_inst0_expt_vld;           
wire            rob_retire_inst0_fp_dirty;           
wire            rob_retire_inst0_high_hw_expt;       
wire    [IID_WIDTH - 1 :0]  rob_retire_inst0_iid;                
wire            rob_retire_inst0_immu_expt;                   
wire            rob_retire_inst0_inst_flush;         
wire    [4 :0]  rob_retire_inst0_int_vec;            
wire            rob_retire_inst0_int_vld;            
wire            rob_retire_inst0_intmask;            
wire            rob_retire_inst0_jmp;                
wire            rob_retire_inst0_jmp_mispred;        
wire            rob_retire_inst0_load;               
wire    [`WK_PA_WIDTH:0]  rob_retire_inst0_mtval;              
wire    [`WK_PC_LEN-1:0]  rob_retire_inst0_next_pc;            
wire            rob_retire_inst0_no_spec_hit;        
wire            rob_retire_inst0_no_spec_mispred;    
wire            rob_retire_inst0_no_spec_miss;       
wire            rob_retire_inst0_no_spec_target;     
wire    [1 :0]  rob_retire_inst0_num;                
wire    [2 :0]  rob_retire_inst0_pc_offset;          
wire            rob_retire_inst0_pcal;               
wire            rob_retire_inst0_pret;               
wire            rob_retire_inst0_pst_ereg_vld;       
wire            rob_retire_inst0_pst_preg_vld;       
wire            rob_retire_inst0_pst_vreg_vld;       
wire            rob_retire_inst0_ras;                
wire            rob_retire_inst0_spec_fail;          
wire            rob_retire_inst0_spec_fail_no_ssf;   
wire            rob_retire_inst0_spec_fail_ssf;      
wire            rob_retire_inst0_split;              
wire            rob_retire_inst0_store;              
wire            rob_retire_inst0_vec_dirty;          
wire    [`VL_WIDTH-1 :0]  rob_retire_inst0_vl;                 
wire            rob_retire_inst0_vl_pred;            
wire            rob_retire_inst0_vld;                
wire    [2 :0]  rob_retire_inst0_vlmul;              
wire            rob_retire_inst0_vsetvl;             
wire            rob_retire_inst0_vsetvli;            
wire    [2 :0]  rob_retire_inst0_vsew;               
wire    [`VSTART_WIDTH-1 :0]  rob_retire_inst0_vstart;             
wire            rob_retire_inst0_vstart_vld;
wire            rob_retire_inst0_vma; // add by tmj @20251120
wire            rob_retire_inst0_vta; // add by tmj @20251120
wire            rob_retire_inst1_bju;                
wire    [7 :0]  rob_retire_inst1_chk_idx;            
wire            rob_retire_inst1_condbr;             
wire            rob_retire_inst1_condbr_taken;       
wire    [`WK_PC_LEN-1:0]  rob_retire_inst1_cur_pc;             
wire            rob_retire_inst1_fp_dirty;           
wire            rob_retire_inst1_jmp;                
wire            rob_retire_inst1_load;               
wire    [`WK_PC_LEN-1:0]  rob_retire_inst1_next_pc;            
wire            rob_retire_inst1_no_spec_hit;        
wire            rob_retire_inst1_no_spec_mispred;    
wire            rob_retire_inst1_no_spec_miss;       
wire            rob_retire_inst1_no_spec_target;     
wire    [1 :0]  rob_retire_inst1_num;                
wire    [2 :0]  rob_retire_inst1_pc_offset;          
wire            rob_retire_inst1_pst_ereg_vld;       
wire            rob_retire_inst1_pst_preg_vld;       
wire            rob_retire_inst1_pst_vreg_vld;       
wire            rob_retire_inst1_split;              
wire            rob_retire_inst1_store;              
wire            rob_retire_inst1_vec_dirty;          
wire    [`VL_WIDTH-1 :0]  rob_retire_inst1_vl;                 
wire            rob_retire_inst1_vl_pred;            
wire            rob_retire_inst1_vld;                
wire    [2 :0]  rob_retire_inst1_vlmul;              
wire            rob_retire_inst1_vsetvli;            
wire    [2 :0]  rob_retire_inst1_vsew; 
wire            rob_retire_inst1_vma;
wire            rob_retire_inst1_vta;               
wire            rob_retire_inst2_bju;                
wire    [7 :0]  rob_retire_inst2_chk_idx;            
wire            rob_retire_inst2_condbr;             
wire            rob_retire_inst2_condbr_taken;       
wire    [`WK_PC_LEN-1:0]  rob_retire_inst2_cur_pc;             
wire            rob_retire_inst2_fp_dirty;           
wire            rob_retire_inst2_jmp;                
wire            rob_retire_inst2_load;               
wire    [`WK_PC_LEN-1:0]  rob_retire_inst2_next_pc;            
wire            rob_retire_inst2_no_spec_hit;        
wire            rob_retire_inst2_no_spec_mispred;    
wire            rob_retire_inst2_no_spec_miss;       
wire            rob_retire_inst2_no_spec_target;     
wire    [1 :0]  rob_retire_inst2_num;                
wire    [2 :0]  rob_retire_inst2_pc_offset;          
wire            rob_retire_inst2_pst_ereg_vld;       
wire            rob_retire_inst2_pst_preg_vld;       
wire            rob_retire_inst2_pst_vreg_vld;       
wire            rob_retire_inst2_split;              
wire            rob_retire_inst2_store;              
wire            rob_retire_inst2_vec_dirty;          
wire    [`VL_WIDTH-1 :0]  rob_retire_inst2_vl;                 
wire            rob_retire_inst2_vl_pred;            
wire            rob_retire_inst2_vld;                
wire    [2 :0]  rob_retire_inst2_vlmul;              
wire            rob_retire_inst2_vsetvli;            
wire    [2 :0]  rob_retire_inst2_vsew;
wire            rob_retire_inst2_vma;
wire            rob_retire_inst2_vta;     
// add rob_retire_inst3-5*. dhw@20241218           
wire            rob_retire_inst3_bju;                
wire    [7 :0]  rob_retire_inst3_chk_idx;            
wire            rob_retire_inst3_condbr;             
wire            rob_retire_inst3_condbr_taken;       
wire    [`WK_PC_LEN-1:0]  rob_retire_inst3_cur_pc;             
wire            rob_retire_inst3_fp_dirty;           
wire            rob_retire_inst3_jmp;                
wire            rob_retire_inst3_load;               
wire    [`WK_PC_LEN-1:0]  rob_retire_inst3_next_pc;            
wire            rob_retire_inst3_no_spec_hit;        
wire            rob_retire_inst3_no_spec_mispred;    
wire            rob_retire_inst3_no_spec_miss;       
wire            rob_retire_inst3_no_spec_target;     
wire    [1 :0]  rob_retire_inst3_num;                
wire    [2 :0]  rob_retire_inst3_pc_offset;          
wire            rob_retire_inst3_pst_ereg_vld;       
wire            rob_retire_inst3_pst_preg_vld;       
wire            rob_retire_inst3_pst_vreg_vld;       
wire            rob_retire_inst3_split;              
wire            rob_retire_inst3_store;              
wire            rob_retire_inst3_vec_dirty;          
wire    [`VL_WIDTH-1 :0]  rob_retire_inst3_vl;                 
wire            rob_retire_inst3_vl_pred;            
wire            rob_retire_inst3_vld;                
wire    [2 :0]  rob_retire_inst3_vlmul;              
wire            rob_retire_inst3_vsetvli;            
wire    [2 :0]  rob_retire_inst3_vsew; 
wire            rob_retire_inst3_vma;
wire            rob_retire_inst3_vta;               
wire            rob_retire_inst4_bju;                
wire    [7 :0]  rob_retire_inst4_chk_idx;            
wire            rob_retire_inst4_condbr;             
wire            rob_retire_inst4_condbr_taken;       
wire    [`WK_PC_LEN-1:0]  rob_retire_inst4_cur_pc;             
wire            rob_retire_inst4_fp_dirty;           
wire            rob_retire_inst4_jmp;                
wire            rob_retire_inst4_load;               
wire    [`WK_PC_LEN-1:0]  rob_retire_inst4_next_pc;            
wire            rob_retire_inst4_no_spec_hit;        
wire            rob_retire_inst4_no_spec_mispred;    
wire            rob_retire_inst4_no_spec_miss;       
wire            rob_retire_inst4_no_spec_target;     
wire    [1 :0]  rob_retire_inst4_num;                
wire    [2 :0]  rob_retire_inst4_pc_offset;          
wire            rob_retire_inst4_pst_ereg_vld;       
wire            rob_retire_inst4_pst_preg_vld;       
wire            rob_retire_inst4_pst_vreg_vld;       
wire            rob_retire_inst4_split;              
wire            rob_retire_inst4_store;              
wire            rob_retire_inst4_vec_dirty;          
wire    [`VL_WIDTH-1 :0]  rob_retire_inst4_vl;                 
wire            rob_retire_inst4_vl_pred;            
wire            rob_retire_inst4_vld;                
wire    [2 :0]  rob_retire_inst4_vlmul;              
wire            rob_retire_inst4_vsetvli;            
wire    [2 :0]  rob_retire_inst4_vsew;
wire            rob_retire_inst4_vma;
wire            rob_retire_inst4_vta;                 
wire            rob_retire_inst5_bju;                
wire    [7 :0]  rob_retire_inst5_chk_idx;            
wire            rob_retire_inst5_condbr;             
wire            rob_retire_inst5_condbr_taken;       
wire    [`WK_PC_LEN-1:0]  rob_retire_inst5_cur_pc;             
wire            rob_retire_inst5_fp_dirty;           
wire            rob_retire_inst5_jmp;                
wire            rob_retire_inst5_load;               
wire    [`WK_PC_LEN-1:0]  rob_retire_inst5_next_pc;            
wire            rob_retire_inst5_no_spec_hit;        
wire            rob_retire_inst5_no_spec_mispred;    
wire            rob_retire_inst5_no_spec_miss;       
wire            rob_retire_inst5_no_spec_target;     
wire    [1 :0]  rob_retire_inst5_num;                
wire    [2 :0]  rob_retire_inst5_pc_offset;          
wire            rob_retire_inst5_pst_ereg_vld;       
wire            rob_retire_inst5_pst_preg_vld;       
wire            rob_retire_inst5_pst_vreg_vld;       
wire            rob_retire_inst5_split;              
wire            rob_retire_inst5_store;              
wire            rob_retire_inst5_vec_dirty;          
wire    [`VL_WIDTH-1 :0]  rob_retire_inst5_vl;                 
wire            rob_retire_inst5_vl_pred;            
wire            rob_retire_inst5_vld;                
wire    [2 :0]  rob_retire_inst5_vlmul;              
wire            rob_retire_inst5_vsetvli;            
wire    [2 :0]  rob_retire_inst5_vsew;  
wire            rob_retire_inst5_vma;
wire            rob_retire_inst5_vta;             
wire            rob_retire_int_srt_en;               
wire    [`WK_PC_LEN-1:0]  rob_retire_rob_cur_pc;               
wire            rob_retire_split_spec_fail_srt;      
wire    [IID_WIDTH - 1 :0]  rob_retire_ssf_iid;                  
wire    [63:0]  rtu_cp0_epc;                         
wire            rtu_cp0_expt_gateclk_vld;            
wire    [63:0]  rtu_cp0_expt_mtval;                  
wire            rtu_cp0_expt_vld;                    
wire            rtu_cp0_fp_dirty_vld;                
wire            rtu_cp0_int_ack;                     
wire            rtu_cp0_vec_dirty_vld;               
wire            rtu_cp0_vsetvl_vill;                 
wire            rtu_cp0_vsetvl_vl_vld;               
wire            rtu_cp0_vsetvl_vtype_vld;            
wire    [`VSTART_WIDTH-1 :0]  rtu_cp0_vstart;                      
wire            rtu_cp0_vstart_vld;                                           
wire            rtu_hpcp_inst0_ack_int;              
wire            rtu_hpcp_inst0_bht_mispred;          
wire            rtu_hpcp_inst0_condbr;               
wire            rtu_hpcp_inst0_jmp;                  
wire            rtu_hpcp_inst0_jmp_mispred;          
wire    [1 :0]  rtu_hpcp_inst0_num;                  
wire    [2 :0]  rtu_hpcp_inst0_pc_offset;            
wire            rtu_hpcp_inst0_spec_fail;            
wire            rtu_hpcp_inst0_split;                
wire            rtu_hpcp_inst0_store;                
wire            rtu_hpcp_inst0_vld;                  
wire            rtu_hpcp_inst1_condbr;               
wire            rtu_hpcp_inst1_jmp;                  
wire    [1 :0]  rtu_hpcp_inst1_num;                  
wire    [2 :0]  rtu_hpcp_inst1_pc_offset;            
wire            rtu_hpcp_inst1_split;                
wire            rtu_hpcp_inst1_store;                
wire            rtu_hpcp_inst1_vld;                  
wire            rtu_hpcp_inst2_condbr;               
wire            rtu_hpcp_inst2_jmp;                  
wire    [1 :0]  rtu_hpcp_inst2_num;                  
wire    [2 :0]  rtu_hpcp_inst2_pc_offset;            
wire            rtu_hpcp_inst2_split;                
wire            rtu_hpcp_inst2_store;                
wire            rtu_hpcp_inst2_vld;                  
wire            rtu_hpcp_inst3_condbr;               
wire            rtu_hpcp_inst3_jmp;                  
wire    [1 :0]  rtu_hpcp_inst3_num;                  
wire    [2 :0]  rtu_hpcp_inst3_pc_offset;            
wire            rtu_hpcp_inst3_split;                
wire            rtu_hpcp_inst3_store;                
wire            rtu_hpcp_inst3_vld;                  
wire            rtu_hpcp_inst4_condbr;               
wire            rtu_hpcp_inst4_jmp;                  
wire    [1 :0]  rtu_hpcp_inst4_num;                  
wire    [2 :0]  rtu_hpcp_inst4_pc_offset;            
wire            rtu_hpcp_inst4_split;                
wire            rtu_hpcp_inst4_store;                
wire            rtu_hpcp_inst4_vld;                  
wire            rtu_hpcp_inst5_condbr;               
wire            rtu_hpcp_inst5_jmp;                  
wire    [1 :0]  rtu_hpcp_inst5_num;                  
wire    [2 :0]  rtu_hpcp_inst5_pc_offset;            
wire            rtu_hpcp_inst5_split;                
wire            rtu_hpcp_inst5_store;                
wire            rtu_hpcp_inst5_vld;                  
wire            rtu_hpcp_trace_inst0_chgflow;        
wire    [`WK_PC_LEN-1:0]  rtu_hpcp_trace_inst0_next_pc;        
wire            rtu_hpcp_trace_inst1_chgflow;        
wire    [`WK_PC_LEN-1:0]  rtu_hpcp_trace_inst1_next_pc;        
wire            rtu_hpcp_trace_inst2_chgflow;        
wire    [`WK_PC_LEN-1:0]  rtu_hpcp_trace_inst2_next_pc;        
wire            rtu_hpcp_trace_inst3_chgflow;        
wire    [`WK_PC_LEN-1:0]  rtu_hpcp_trace_inst3_next_pc;        
wire            rtu_hpcp_trace_inst4_chgflow;        
wire    [`WK_PC_LEN-1:0]  rtu_hpcp_trace_inst4_next_pc;        
wire            rtu_hpcp_trace_inst5_chgflow;        
wire    [`WK_PC_LEN-1:0]  rtu_hpcp_trace_inst5_next_pc;        
wire            rtu_idu_flush_fe;                    
wire            rtu_idu_flush_is;                    
wire            rtu_idu_flush_stall;                 
wire            rtu_idu_retire0_inst_vld;            
wire            rtu_idu_srt_en;                      
wire    [`WK_PC_LEN-1:0]  rtu_ifu_chgflw_pc;                   
wire            rtu_ifu_chgflw_vld;                  
wire            rtu_ifu_flush;                       
wire            rtu_ifu_retire0_uncondbr;              
wire            rtu_ifu_retire1_uncondbr;              
wire            rtu_ifu_retire2_uncondbr;              
wire            rtu_ifu_retire3_uncondbr;              
wire            rtu_ifu_retire4_uncondbr;              
wire            rtu_ifu_retire5_uncondbr;              
wire    [7 :0]  rtu_ifu_retire0_chk_idx;             
wire            rtu_ifu_retire0_condbr;              
wire            rtu_ifu_retire0_condbr_taken;        
wire    [`WK_PC_LEN-1:0]  rtu_ifu_retire0_inc_pc;              
wire            rtu_ifu_retire0_jmp;                 
wire            rtu_ifu_retire0_jmp_mispred;         
wire            rtu_ifu_retire0_mispred;             
//wire    [`WK_PC_LEN-1:0]  rtu_ifu_retire0_next_pc;             
wire            rtu_ifu_retire0_pcall;               
wire            rtu_ifu_retire0_preturn;             
wire    [`WK_PC_LEN-1:0]  rtu_ifu_retire_inst0_cur_pc;         
wire            rtu_ifu_retire_inst0_load;           
wire            rtu_ifu_retire_inst0_no_spec_hit;    
wire            rtu_ifu_retire_inst0_no_spec_mispred; 
wire            rtu_ifu_retire_inst0_no_spec_miss;   
wire            rtu_ifu_retire_inst0_no_spec_target; 
wire            rtu_ifu_retire_inst0_store;          
wire    [`VL_WIDTH-1 :0]  rtu_ifu_retire_inst0_vl;             
wire            rtu_ifu_retire_inst0_vl_hit;         
wire            rtu_ifu_retire_inst0_vl_mispred;     
wire            rtu_ifu_retire_inst0_vl_miss;        
wire            rtu_ifu_retire_inst0_vl_pred;        
wire    [`WK_PC_LEN-1:0]  rtu_ifu_retire_inst1_cur_pc;         
wire            rtu_ifu_retire_inst1_load;           
wire            rtu_ifu_retire_inst1_no_spec_hit;    
wire            rtu_ifu_retire_inst1_no_spec_mispred; 
wire            rtu_ifu_retire_inst1_no_spec_miss;   
wire            rtu_ifu_retire_inst1_no_spec_target; 
wire            rtu_ifu_retire_inst1_store;          
wire    [`VL_WIDTH-1 :0]  rtu_ifu_retire_inst1_vl;             
wire            rtu_ifu_retire_inst1_vl_pred;        
wire    [`WK_PC_LEN-1:0]  rtu_ifu_retire_inst2_cur_pc;         
wire            rtu_ifu_retire_inst2_load;           
wire            rtu_ifu_retire_inst2_no_spec_hit;    
wire            rtu_ifu_retire_inst2_no_spec_mispred; 
wire            rtu_ifu_retire_inst2_no_spec_miss;   
wire            rtu_ifu_retire_inst2_no_spec_target; 
wire            rtu_ifu_retire_inst2_store;          
wire    [`VL_WIDTH-1 :0]  rtu_ifu_retire_inst2_vl;             
wire            rtu_ifu_retire_inst2_vl_pred;        
// add rtu_ifu_retire_inst3-5*. dhw@20241218
wire    [`WK_PC_LEN-1:0]  rtu_ifu_retire_inst3_cur_pc;         
wire            rtu_ifu_retire_inst3_load;           
wire            rtu_ifu_retire_inst3_no_spec_hit;    
wire            rtu_ifu_retire_inst3_no_spec_mispred; 
wire            rtu_ifu_retire_inst3_no_spec_miss;   
wire            rtu_ifu_retire_inst3_no_spec_target; 
wire            rtu_ifu_retire_inst3_store;          
wire    [`VL_WIDTH-1 :0]  rtu_ifu_retire_inst3_vl;             
wire            rtu_ifu_retire_inst3_vl_pred;        
wire    [`WK_PC_LEN-1:0]  rtu_ifu_retire_inst4_cur_pc;         
wire            rtu_ifu_retire_inst4_load;           
wire            rtu_ifu_retire_inst4_no_spec_hit;    
wire            rtu_ifu_retire_inst4_no_spec_mispred; 
wire            rtu_ifu_retire_inst4_no_spec_miss;   
wire            rtu_ifu_retire_inst4_no_spec_target; 
wire            rtu_ifu_retire_inst4_store;          
wire    [`VL_WIDTH-1 :0]  rtu_ifu_retire_inst4_vl;             
wire            rtu_ifu_retire_inst4_vl_pred;        
wire    [`WK_PC_LEN-1:0]  rtu_ifu_retire_inst5_cur_pc;         
wire            rtu_ifu_retire_inst5_load;           
wire            rtu_ifu_retire_inst5_no_spec_hit;    
wire            rtu_ifu_retire_inst5_no_spec_mispred; 
wire            rtu_ifu_retire_inst5_no_spec_miss;   
wire            rtu_ifu_retire_inst5_no_spec_target; 
wire            rtu_ifu_retire_inst5_store;          
wire    [`VL_WIDTH-1 :0]  rtu_ifu_retire_inst5_vl;             
wire            rtu_ifu_retire_inst5_vl_pred;        
wire            rtu_ifu_xx_dbgon;                    
wire            rtu_iu_flush_chgflw_mask;            
wire            rtu_iu_flush_fe;                     
wire            rtu_lsu_async_flush;                 
wire            rtu_lsu_eret_flush;                  
wire            rtu_lsu_expt_flush;                  
wire            rtu_lsu_flush_fe;                    
wire            rtu_lsu_spec_fail_flush;             
wire    [IID_WIDTH - 1 :0]  rtu_lsu_spec_fail_iid;               
wire    [`WK_PC_LEN-1-12:0]  rtu_mmu_bad_vpn;                     
wire            rtu_mmu_expt_vld;                    
wire            rtu_yy_xx_dbgon;                     
wire            rtu_yy_xx_expt_ecc;                  
wire    [5 :0]  rtu_yy_xx_expt_vec;                  
wire            rtu_yy_xx_flush;                                
wire            sm_clk;                              
wire            sm_clk_en;                           

//==========================================================
//                  Risc-V Debug zdb Begin
//==========================================================

parameter HINFO_WIDTH = `TDT_MP_HINFO_WIDTH;

input           cp0_yy_mmu_en;
input           dtu_rtu_async_halt_req;
input   [63:0]  dtu_rtu_dpc;
input           dtu_rtu_ebreak_action;
input           dtu_rtu_group_halt_req;
input           dtu_rtu_int_mask;
input           dtu_rtu_mdbgen;
input   [63:0]  dtu_rtu_pending_tval;
input           dtu_rtu_resume_req;
input           dtu_rtu_sync_flush;
input           dtu_rtu_sync_halt_req;
input           ifu_rtu_reset_halt_req;
input           retire_inst0_cancel;
input           rob_retire_fof_err_srt;
input           rob_retire_inst0_abnormal_for_gateclk;
input           rob_retire_inst0_dret;
input           rob_retire_inst0_ebreak;
input           rob_retire_inst0_ecall;
input   [16:0]  rob_retire_inst0_haltinfo;
input           rob_retire_inst0_mret;
input           rob_retire_inst0_sret;
input           rob_retire_inst0_t0_halt_vld;
input           rob_retire_t1_haltinfo_srt;

output          retire_rob_dbg_req_en;
output          retire_rob_exit_debug;
output  [1 :0]  rtu_cp0_dbg_pm; 
output          rtu_cp0_enter_debug;
output          rtu_cp0_exit_debug;
output  [63:0]  rtu_dtu_dpc;
output          rtu_dtu_halt_ack;
output          rtu_dtu_pending_ack;
output  [`WK_PC_LEN-1:0]  rtu_dtu_retire0_chgflw_pc;
output          rtu_dtu_retire0_chgflw_vld;
output  [16:0]  rtu_dtu_retire0_halt_info;
output          rtu_dtu_retire0_mret;
output          rtu_dtu_retire0_mret_gateclk;
output          rtu_dtu_retire0_split;
output          rtu_dtu_retire0_sret;
output          rtu_dtu_retire0_vld;
output  [`WK_PC_LEN-1:0]  rtu_dtu_retire1_chgflw_pc;
output          rtu_dtu_retire1_chgflw_vld;
output  [`WK_PC_LEN-1:0]  rtu_dtu_retire2_chgflw_pc;
output          rtu_dtu_retire2_chgflw_vld;
output  [`WK_PC_LEN-1:0]  rtu_dtu_retire3_chgflw_pc;
output          rtu_dtu_retire3_chgflw_vld;
output  [`WK_PC_LEN-1:0]  rtu_dtu_retire4_chgflw_pc;
output          rtu_dtu_retire4_chgflw_vld;
output  [`WK_PC_LEN-1:0]  rtu_dtu_retire5_chgflw_pc;
output          rtu_dtu_retire5_chgflw_vld;
output          rtu_dtu_retire_chgflw_gateclk_vld;
output          rtu_dtu_retire_debug_expt_vld;
output  [63:0]  rtu_dtu_tval;
output          rtu_yy_xx_expt_int;                   
output          rtu_yy_xx_expt_vld;

//input
wire            cp0_yy_mmu_en;
wire            dtu_rtu_async_halt_req;
wire   [63:0]   dtu_rtu_dpc;
wire            dtu_rtu_ebreak_action;
wire            dtu_rtu_group_halt_req;
wire            dtu_rtu_int_mask;
wire            dtu_rtu_mdbgen;
wire   [63:0]   dtu_rtu_pending_tval;
wire            dtu_rtu_resume_req;
wire            dtu_rtu_sync_flush;
wire            dtu_rtu_sync_halt_req;
wire            ifu_rtu_reset_halt_req;
wire            retire_inst0_cancel;
wire            rob_retire_fof_err_srt;
wire            rob_retire_inst0_abnormal_for_gateclk;
wire            rob_retire_inst0_dret;
wire            rob_retire_inst0_ebreak;
wire            rob_retire_inst0_ecall;
wire    [16:0]  rob_retire_inst0_haltinfo;
wire            rob_retire_inst0_mret;
wire            rob_retire_inst0_sret;
wire            rob_retire_inst0_t0_halt_vld;
wire            rob_retire_t1_haltinfo_srt;
//output
wire            retire_rob_dbg_req_en;
wire            retire_rob_exit_debug;
wire    [1 :0]  rtu_cp0_dbg_pm;
wire            rtu_cp0_enter_debug;                     
wire            rtu_cp0_exit_debug;
wire    [63:0]  rtu_dtu_dpc;
wire            rtu_dtu_halt_ack;
wire            rtu_dtu_pending_ack;
wire    [`WK_PC_LEN-1:0]  rtu_dtu_retire0_chgflw_pc;
wire            rtu_dtu_retire0_chgflw_vld;
wire    [16:0]  rtu_dtu_retire0_halt_info;
wire            rtu_dtu_retire0_mret;
wire            rtu_dtu_retire0_mret_gateclk;
wire            rtu_dtu_retire0_split;
wire            rtu_dtu_retire0_sret;
wire            rtu_dtu_retire0_vld;
wire    [`WK_PC_LEN-1:0]  rtu_dtu_retire1_chgflw_pc;
wire            rtu_dtu_retire1_chgflw_vld;
wire    [`WK_PC_LEN-1:0]  rtu_dtu_retire2_chgflw_pc;
wire            rtu_dtu_retire2_chgflw_vld;
wire    [`WK_PC_LEN-1:0]  rtu_dtu_retire3_chgflw_pc;
wire            rtu_dtu_retire3_chgflw_vld;
wire    [`WK_PC_LEN-1:0]  rtu_dtu_retire4_chgflw_pc;
wire            rtu_dtu_retire4_chgflw_vld;
wire    [`WK_PC_LEN-1:0]  rtu_dtu_retire5_chgflw_pc;
wire            rtu_dtu_retire5_chgflw_vld;
wire            rtu_dtu_retire_chgflw_gateclk_vld;
wire            rtu_dtu_retire_debug_expt_vld;
wire    [63:0]  rtu_dtu_tval;
wire            rtu_yy_xx_expt_int;                   
wire            rtu_yy_xx_expt_vld;

reg             dbg_mode_on_after_req;
reg     [3 :0]  halt_cause;
reg     [63:0]  retire_dtval; 
reg             retire_exit_debug;
reg     [16:0]  retire_halt_info;
reg             retire_have_debug_req_f;
reg             retire_dtu_group_halt_req;
reg             retire_dtu_resume_req;
reg             retire_dtu_sync_flush;
reg             retire_dtu_sync_halt_req; 

wire            bkpt_req_ebreak;
wire            bkpt_req_pending;
wire            bkpt_req_t1;
wire            bkpt_req_trigger_t0;
wire            bkpt_req_trigger_t0_ifu;
wire            bkpt_req_trigger_t0_lsu;
wire            bkpt_req_trigger_t1;
wire            bkpt_req_trigger_t1_lsu;
wire            dbg_req_en;
wire            debug_req_t0_flush;
wire            debug_req_t1_flush;
wire            halt_req;
wire            halt_req_dm_async;
wire            halt_req_dm_sync;
wire            halt_req_ebreak;
wire            halt_req_for_int;
wire            halt_req_group;
wire            halt_req_pending;
wire            halt_req_reset;
wire            halt_req_t1;
wire            halt_req_t1_raw;
wire            halt_req_trigger_t0;
wire            halt_req_trigger_t0_action01;
wire            halt_req_trigger_t1;
wire            halt_req_trigger_t1_action01;
wire            hit_ebreak;
wire            hit_pending;
wire            hit_trigger_t0;
wire            hit_trigger_t1;
wire    [1 :0]  retire_dbg_mode;
wire            retire_debug_expt;
wire            retire_debug_expt_vld;
wire            retire_debug_step_flush;
wire    [63:0]  retire_dpc;
wire            retire_enter_debug;
wire            retire_exit_debug_raw;
wire    [63:0]  retire_expt_pc_high_hw_expt;
wire            retire_have_debug_req;
wire            retire_pending_bkpt_expt;
wire    [63:0]  retire_sync_tval;
wire            retire_tval_use_pipeline;
wire    [16:0]  rob_retire_halt_info;

//==========================================================
//                  Risc-V Debug zdb End
//==========================================================

//==========================================================
//                  Risc-V Debug zdb Begin
//==========================================================
assign retire_clk_en = retire_expt_gateclk_vld
                       | dbg_mode_on
                       | retire_have_debug_req
                       | retire_have_debug_req_f
                       | dbg_mode_on_after_req
                       | halt_req
                       | retire_inst0_inst_flush
                       | retire_exit_debug
                       | async_flush_ff
                       | retire_ifu_chgflw_vld
                       | rtu_ifu_xx_expt_vld;
//==========================================================
//                  Risc-V Debug zdb End
//==========================================================
gated_clk_cell  x_retire_gated_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (retire_clk        ),
  .external_en        (1'b0              ),
  .local_en           (retire_clk_en     ),
  .module_en          (cp0_rtu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

assign sm_clk_en = retire_inst0_flush_gateclk
                   || retire_flush_sm_no_idle
                   || lsu_rtu_async_expt_vld
                   || lsu_rtu_ctc_flush_vld
                   || retire_async_expt_sm_no_idle
                   || retire_ctc_flush_req;

gated_clk_cell  x_sm_gated_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (sm_clk            ),
  .external_en        (1'b0              ),
  .local_en           (sm_clk_en         ),
  .module_en          (cp0_rtu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// update hpcp_clk_en. dhw@20241218
assign hpcp_clk_en = hpcp_rtu_cnt_en
                     && rob_retire_inst0_vld
                     || retire_retire_hpcp_inst0_vld
                     || retire_retire_hpcp_inst1_vld
                     || retire_retire_hpcp_inst2_vld
                     || retire_retire_hpcp_inst3_vld
                     || retire_retire_hpcp_inst4_vld
                     || retire_retire_hpcp_inst5_vld;

gated_clk_cell  x_hpcp_gated_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (hpcp_clk          ),
  .external_en        (1'b0              ),
  .local_en           (hpcp_clk_en       ),
  .module_en          (cp0_rtu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

//==========================================================
//                  Single Retire Mode
//==========================================================
//when meet following condition, RTU will enable single retire
//mode: IDU stop folding, ROB read 1/2 will not valid

//==========================================================
//                  Risc-V Debug zdb Begin
//==========================================================
assign retire_srt_en     = dbg_req_en
                           | dbg_mode_on   //for split inst
                           | cp0_rtu_srt_en;
//==========================================================
//                  Risc-V Debug zdb End
//==========================================================

// assign retire_rob_srt_en = retire_srt_en
//                            || rob_retire_split_spec_fail_srt
//                            || rob_retire_int_srt_en
//                            || rob_retire_ctc_flush_srt_en;
//==========================================================
//                  Risc-V Debug zdb Begin (replace)
//==========================================================
assign retire_rob_srt_en = retire_srt_en
                           | rob_retire_split_spec_fail_srt  //srt is 1 when ssf inst cmplt
                           | rob_retire_fof_err_srt          //abnormal is 1 when fof error inst cmplt
                           | rob_retire_t1_haltinfo_srt      //srt is 1 when t1_halt inst cmplt
                           | rob_retire_int_srt_en
                           | rob_retire_ctc_flush_srt_en;
//==========================================================
//                  Risc-V Debug zdb End   (replace)
//==========================================================
assign rtu_idu_srt_en    = retire_srt_en;

//==========================================================
//                   Retire valid signals
//==========================================================
//retire inst 0 may expt vld, but retire inst 1/2 are always normal
// assign retire_inst0_normal_retire     = rob_retire_inst0_vld
//                                         && !rob_retire_inst0_expt_vld;
//==========================================================
//                  Risc-V Debug zdb Begin (replace)
//==========================================================
assign retire_inst0_normal_retire     = rob_retire_inst0_vld
                                        & ~retire_expt_inst
                                        & ~rob_retire_inst0_t0_halt_vld;
//==========================================================
//                  Risc-V Debug zdb End   (replace)
//==========================================================
assign retire_inst1_normal_retire     = rob_retire_inst1_vld;
assign retire_inst2_normal_retire     = rob_retire_inst2_vld;
assign retire_inst3_normal_retire     = rob_retire_inst3_vld; // add by dhw@20241218
assign retire_inst4_normal_retire     = rob_retire_inst4_vld; // add by dhw@20241218
assign retire_inst5_normal_retire     = rob_retire_inst5_vld; // add by dhw@20241218

//rename for output
assign rtu_idu_retire0_inst_vld       = rob_retire_inst0_vld;
  
//if inst bkpt or expt vld, retire inst0 cannot write back
assign retire_pst_wb_retire_inst0_preg_vld = rob_retire_inst0_pst_preg_vld; 
assign retire_pst_wb_retire_inst1_preg_vld = rob_retire_inst1_pst_preg_vld; 
assign retire_pst_wb_retire_inst2_preg_vld = rob_retire_inst2_pst_preg_vld; 
assign retire_pst_wb_retire_inst3_preg_vld = rob_retire_inst3_pst_preg_vld; // add by dhw@20241218 
assign retire_pst_wb_retire_inst4_preg_vld = rob_retire_inst4_pst_preg_vld; // add by dhw@20241218 
assign retire_pst_wb_retire_inst5_preg_vld = rob_retire_inst5_pst_preg_vld; // add by dhw@20241218 
//if inst bkpt or expt vld, retire inst0 cannot write back
assign retire_pst_wb_retire_inst0_vreg_vld = rob_retire_inst0_pst_vreg_vld; 
assign retire_pst_wb_retire_inst1_vreg_vld = rob_retire_inst1_pst_vreg_vld; 
assign retire_pst_wb_retire_inst2_vreg_vld = rob_retire_inst2_pst_vreg_vld; 
assign retire_pst_wb_retire_inst3_vreg_vld = rob_retire_inst3_pst_vreg_vld; // add by dhw@20241218 
assign retire_pst_wb_retire_inst4_vreg_vld = rob_retire_inst4_pst_vreg_vld; // add by dhw@20241218 
assign retire_pst_wb_retire_inst5_vreg_vld = rob_retire_inst5_pst_vreg_vld; // add by dhw@20241218 
//expt instruction should write back ereg value, and ereg value should be RETIRE
assign retire_pst_wb_retire_inst0_ereg_vld = rob_retire_inst0_pst_ereg_vld; 
assign retire_pst_wb_retire_inst1_ereg_vld = rob_retire_inst1_pst_ereg_vld; 
assign retire_pst_wb_retire_inst2_ereg_vld = rob_retire_inst2_pst_ereg_vld; 
assign retire_pst_wb_retire_inst3_ereg_vld = rob_retire_inst3_pst_ereg_vld; // add by dhw@20241218 
assign retire_pst_wb_retire_inst4_ereg_vld = rob_retire_inst4_pst_ereg_vld; // add by dhw@20241218 
assign retire_pst_wb_retire_inst5_ereg_vld = rob_retire_inst5_pst_ereg_vld; // add by dhw@20241218 

//==========================================================
//             Retire (Inst 0) Exception Process
//==========================================================
//Exception, Interrupt and debug can ONLY hit retire inst 0

//----------------------------------------------------------
//                 Prepare Exception Source
//----------------------------------------------------------

//==========================================================
//                  Risc-V Debug zdb Begin (insert)
//==========================================================
assign retire_inst_expt          = rob_retire_inst0_expt_vld;

assign retire_bkpt_expt          = bkpt_req_ebreak
                                 | bkpt_req_trigger_t0;

assign retire_debug_expt         = bkpt_req_trigger_t0
                                 | bkpt_req_pending
                                 | rob_retire_inst0_expt_vld & ~rob_retire_inst0_ebreak;
//==========================================================
//                  Risc-V Debug zdb End   (insert)
//==========================================================

// assign retire_expt_inst          = rob_retire_inst0_expt_vld;
assign retire_expt_inst          = retire_inst_expt | retire_bkpt_expt | retire_debug_expt; // Risc-V Debug zdb replace
assign retire_expt_mmu_bad_vpn   = rob_retire_inst0_expt_vld
                                   && (rob_retire_inst0_expt_vec[3:2] == 2'b11);

//----------------------------------------------------------
//                 Prepare Interrupt Source
//----------------------------------------------------------
// assign retire_expt_int           = rob_retire_inst0_int_vld
//                                    && !rob_retire_inst0_split
//                                    && !rob_retire_inst0_intmask;
//==========================================================
//                  Risc-V Debug zdb Begin (replace)
//==========================================================
assign retire_expt_int           = rob_retire_inst0_int_vld
                                   & (~rob_retire_inst0_split | retire_expt_inst)
                                   & (~rob_retire_inst0_intmask | retire_expt_inst)
                                   & ~halt_req_for_int
                                   & ~retire_pending_bkpt_expt
                                   & ~dtu_rtu_int_mask
                                   & ~dbg_mode_on;
//==========================================================
//                  Risc-V Debug zdb End   (replace)
//==========================================================
//----------------------------------------------------------
//                    Exception Vector
//----------------------------------------------------------
assign retire_expt_vec[5:0] = (retire_expt_int)
                              ? {1'b1, rob_retire_inst0_int_vec[4:0]}
                              : {2'b0, rob_retire_inst0_expt_vec[3:0]};
// assign retire_expt_ecc      = !retire_expt_int && rob_retire_inst0_expt_ecc;
//==========================================================
//                  Risc-V Debug zdb Begin (replace)
//==========================================================
assign retire_expt_ecc      = ~retire_expt_int
                              & ~retire_pending_bkpt_expt
                              & ~halt_req 
                              & rob_retire_inst0_expt_ecc;
//==========================================================
//                  Risc-V Debug zdb End   (replace)
//==========================================================
//----------------------------------------------------------
//                         MTVAL
//----------------------------------------------------------
// always @( retire_async_expt_vld
//        or mmu_xx_mmu_en
//        or rob_retire_inst0_immu_expt
//        or rob_retire_inst0_next_pc[38:11]
//        or ae_phy_addr[`WK_PA_WIDTH-1:0]
//        or retire_ack_int
//        or rob_retire_inst0_mtval[`WK_PA_WIDTH:0]
//        or rob_retire_inst0_high_hw_expt
//        or rob_retire_inst0_cur_pc[38:0])
// begin
//   if(retire_async_expt_vld)
//     retire_expt_mtval_src[`WK_PA_WIDTH:0] = {1'b0, ae_phy_addr[`WK_PA_WIDTH-1:0]};
//   else if(retire_ack_int)
//     retire_expt_mtval_src[`WK_PA_WIDTH:0] = {`WK_PA_WIDTH+1{1'b0}};
//   else if(rob_retire_inst0_immu_expt && !rob_retire_inst0_high_hw_expt)
//     retire_expt_mtval_src[`WK_PA_WIDTH:0] = {{`WK_PA_WIDTH-40{1'b0}},
//                                    mmu_xx_mmu_en & rob_retire_inst0_cur_pc[38],
//                                    rob_retire_inst0_cur_pc[38:0],1'b0};
//   //32 bit inst cross 4k page fault, high half-word is 4k align of next pc
//   else if(rob_retire_inst0_immu_expt)
//     retire_expt_mtval_src[`WK_PA_WIDTH:0] = {{`WK_PA_WIDTH-40{1'b0}},
//                                    mmu_xx_mmu_en & rob_retire_inst0_next_pc[38],
//                                    rob_retire_inst0_next_pc[38:11],12'b0};
//   else
//     retire_expt_mtval_src[`WK_PA_WIDTH:0] = rob_retire_inst0_mtval[`WK_PA_WIDTH:0];
// end
//==========================================================
//                  Risc-V Debug zdb Begin (replace)
//==========================================================
always @*
begin
  if(retire_async_expt_vld)
    retire_expt_mtval_src[63:0] = {{(64-`WK_PA_WIDTH){1'b0}}, ae_phy_addr[`WK_PA_WIDTH-1:0]};
  else if (retire_pending_bkpt_expt)
    retire_expt_mtval_src[63:0] = dtu_rtu_pending_tval[63:0];
  else if(retire_expt_int)
    retire_expt_mtval_src[63:0] = {64{1'b0}};
  else if(rob_retire_inst0_immu_expt & ~rob_retire_inst0_high_hw_expt | bkpt_req_trigger_t0_ifu)
    retire_expt_mtval_src[63:0] = cp0_yy_mmu_en ? {{(64- `WK_PC_LEN-2){1'b0}}, rob_retire_inst0_cur_pc[`WK_PC_LEN-1], rob_retire_inst0_cur_pc[`WK_PC_LEN-1:0], 1'b0}
                                                : {{(64- `WK_PC_LEN-1){1'b0}},                                      rob_retire_inst0_cur_pc[`WK_PC_LEN-1:0], 1'b0};
  //32 bit inst cross 4k page fault, high half-word is 4k align of next pc
  else if(rob_retire_inst0_immu_expt)
    retire_expt_mtval_src[63:0] = cp0_yy_mmu_en ? retire_expt_pc_high_hw_expt[63:0]
                                                : {{(64- `WK_PC_LEN-1){1'b0}},retire_expt_pc_high_hw_expt[`WK_PC_LEN:0]};
  else if (retire_tval_use_pipeline)
    retire_expt_mtval_src[63:0] = retire_sync_tval[63:0];
  else
    retire_expt_mtval_src[63:0] = {64{1'b0}};
// &CombEnd; @270
end
//==========================================================
//                  Risc-V Debug zdb End   (replace)
//==========================================================
assign retire_expt_mtval[63:0] = retire_expt_mtval_src[63:0];
//----------------------------------------------------------
//             Exception and Interrupt Priority
//----------------------------------------------------------
assign retire_ack_int     = retire_expt_int;

assign retire_ack_mmu     = retire_expt_inst
                            && retire_expt_mmu_bad_vpn
                            && !retire_expt_int;

//==========================================================
//                  Risc-V Debug zdb Begin
//==========================================================
assign retire_expt_vld    = rob_retire_inst0_vld
                            & ~halt_req
                            & ~dbg_mode_on
                            & (retire_expt_inst
                                | retire_expt_int);
//==========================================================
//                  Risc-V Debug zdb End
//==========================================================
// assign retire_expt_gateclk_vld = rob_retire_inst0_vld
//                                  && (retire_expt_inst
//                                      || retire_expt_int);
//==========================================================
//                  Risc-V Debug zdb Begin (replace)
//==========================================================
assign retire_expt_gateclk_vld = rob_retire_inst0_vld
                               & (rob_retire_inst0_abnormal_for_gateclk
                                  | rob_retire_inst0_int_vld);
//==========================================================
//                  Risc-V Debug zdb End   (replace)
//==========================================================
assign retire_rob_dbg_inst0_expt_vld = retire_expt_gateclk_vld;

//----------------------------------------------------------
//            IFU Exception and Interrupt Output
//----------------------------------------------------------
// assign retire_ifu_expt_vld  = (retire_expt_vld || retire_async_expt_vld)
//                               && !dbg_mode_on;
//==========================================================
//                  Risc-V Debug zdb Begin (replace)
//==========================================================
assign retire_ifu_expt_vld  = (retire_expt_vld || retire_async_expt_vld)
                              & ~dbg_mode_on
                              & ~halt_req;
//==========================================================
//                  Risc-V Debug zdb Begin (replace)
//==========================================================

always @(posedge retire_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    rtu_ifu_xx_expt_vld <= 1'b0;
  else
    rtu_ifu_xx_expt_vld <= retire_ifu_expt_vld;
end

//assign rtu_idu_vec_addr_not_fetched = rtu_ifu_xx_expt_vld;

assign retire_ifu_expt_vec[5:0] = (retire_async_expt_vld) 
                                  ? retire_async_expt_vec[5:0]
                                  : retire_expt_vec[5:0];
assign retire_ifu_expt_ecc      = !retire_async_expt_vld && retire_expt_ecc; 

assign rtu_yy_xx_expt_vec[5:0]  = retire_ifu_expt_vec[5:0];

assign rtu_yy_xx_expt_ecc       = retire_ifu_expt_ecc;

always @(posedge retire_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    rtu_ifu_xx_expt_vec[5:0] <= 6'b0;
  else if(retire_ifu_expt_vld)
    rtu_ifu_xx_expt_vec[5:0] <= retire_ifu_expt_vec[5:0];
  else
    rtu_ifu_xx_expt_vec[5:0] <= rtu_ifu_xx_expt_vec[5:0];
end

//----------------------------------------------------------
//            MMU Exception and Interrupt Output
//----------------------------------------------------------
assign rtu_mmu_expt_vld        = rob_retire_inst0_vld
                                 && retire_ack_mmu
                                 && !dbg_mode_on;

assign rtu_mmu_bad_vpn[`WK_PC_LEN-1-12:0]   = retire_expt_mtval[`WK_PC_LEN-1:12];

//----------------------------------------------------------
//            CP0 Exception and Interrupt Output
//----------------------------------------------------------
assign rtu_cp0_expt_vld        = (retire_expt_vld || retire_async_expt_vld)
                                 && !dbg_mode_on;
// assign rtu_cp0_expt_gateclk_vld = retire_expt_gateclk_vld
//                                   || retire_async_expt_vld;
assign rtu_cp0_expt_gateclk_vld = retire_expt_gateclk_vld || retire_async_expt_vld; // Risc-V Debug zdb replace

assign rtu_cp0_expt_mtval[63:0] = retire_expt_mtval[63:0];

//==========================================================
//                  Risc-V Debug zdb Begin
//==========================================================                                 
assign retire_inst0_epc  = retire_expt_inst
                                 ? rob_retire_inst0_cur_pc
                                 : rob_retire_inst0_next_pc;
//==========================================================
//                  Risc-V Debug zdb End
//==========================================================

assign retire_cp0_epc    = (retire_async_expt_vld)
                                 ? rob_retire_rob_cur_pc
                                 : retire_inst0_epc;

//==========================================================
//                  Risc-V Debug zdb Begin
//==========================================================                                 
assign rtu_cp0_epc[63:0]       = cp0_yy_mmu_en
                                ? {{(64- `WK_PC_LEN-1){retire_cp0_epc[`WK_PC_LEN-1]}}, retire_cp0_epc[`WK_PC_LEN-1:0], 1'b0}
                                : {{(64- `WK_PC_LEN-1){1'b0}},                       retire_cp0_epc[`WK_PC_LEN-1:0], 1'b0};
//==========================================================
//                  Risc-V Debug zdb End
//==========================================================

//==========================================================
//                  Risc-V Debug zdb Begin
//==========================================================
assign rtu_cp0_int_ack         = rob_retire_inst0_vld
                                 & !dbg_mode_on
                                 & retire_ack_int;
//==========================================================
//                  Risc-V Debug zdb End
//==========================================================

assign retire_rob_dbg_inst0_ack_int = rob_retire_inst0_vld
                                      && retire_ack_int;

// update rtu_cp0_fp_dirty_vld. dhw@20241218
assign rtu_cp0_fp_dirty_vld    = rob_retire_inst0_pst_vreg_vld
                                 && rob_retire_inst0_fp_dirty
                              || rob_retire_inst1_pst_vreg_vld
                                 && rob_retire_inst1_fp_dirty
                              || rob_retire_inst2_pst_vreg_vld
                                 && rob_retire_inst2_fp_dirty
                              || rob_retire_inst3_pst_vreg_vld
                                 && rob_retire_inst3_fp_dirty
                              || rob_retire_inst4_pst_vreg_vld
                                 && rob_retire_inst4_fp_dirty
                              || rob_retire_inst5_pst_vreg_vld
                                 && rob_retire_inst5_fp_dirty;

// update rtu_cp0_vec_dirty_vld. dhw@20241218
assign rtu_cp0_vec_dirty_vld   = rob_retire_inst0_pst_vreg_vld
                                 && rob_retire_inst0_vec_dirty
                              || rob_retire_inst1_pst_vreg_vld
                                 && rob_retire_inst1_vec_dirty
                              || rob_retire_inst2_pst_vreg_vld
                                 && rob_retire_inst2_vec_dirty
                              || rob_retire_inst3_pst_vreg_vld
                                 && rob_retire_inst3_vec_dirty
                              || rob_retire_inst4_pst_vreg_vld
                                 && rob_retire_inst4_vec_dirty
                              || rob_retire_inst5_pst_vreg_vld
                                 && rob_retire_inst5_vec_dirty;

//----------------------------------------------------------
//                  CP0 Vector Values
//----------------------------------------------------------
assign retire_inst0_vsetvli           = retire_inst0_normal_retire
                                        && rob_retire_inst0_vsetvli;
assign retire_inst1_vsetvli           = retire_inst1_normal_retire
                                        && rob_retire_inst1_vsetvli;
assign retire_inst2_vsetvli           = retire_inst2_normal_retire
                                        && rob_retire_inst2_vsetvli;
// add retire_inst3-5_vsetvli. dhw@20241218
assign retire_inst3_vsetvli           = retire_inst3_normal_retire
                                        && rob_retire_inst3_vsetvli;
assign retire_inst4_vsetvli           = retire_inst4_normal_retire
                                        && rob_retire_inst4_vsetvli;
assign retire_inst5_vsetvli           = retire_inst5_normal_retire
                                        && rob_retire_inst5_vsetvli;

assign retire_inst0_vsetvlx           = retire_inst0_normal_retire
                                        && rob_retire_inst0_vsetvl;
// mark by tmj
assign retire_inst0_vsetvl_illegal    = retire_inst0_vsetvlx
                                        && rob_retire_inst0_mtval[6+`VL_WIDTH]; // add by tmj @20251022
assign retire_inst0_vsetvl_vl_mispred = retire_inst0_vsetvlx
                                        && rob_retire_inst0_mtval[7+`VL_WIDTH]; // add by tmj @20251022
assign retire_inst0_vsetvl_vl_fof     = retire_inst0_vsetvlx
                                        && rob_retire_inst0_mtval[8+`VL_WIDTH]; // add by tmj @20251022

assign retire_rob_split_fof_flush     = retire_inst0_vsetvl_vl_fof
                                        && rob_retire_inst0_split;

assign rtu_cp0_vsetvl_vill            = retire_inst0_vsetvl_illegal;

assign rtu_cp0_vsetvl_vl_vld          = retire_inst0_vsetvli
                                     || retire_inst1_vsetvli
                                     || retire_inst2_vsetvli
                                     || retire_inst3_vsetvli // add by dhw@20241218
                                     || retire_inst4_vsetvli // add by dhw@20241218
                                     || retire_inst5_vsetvli // add by dhw@20241218
                                     || retire_inst0_vsetvl_vl_mispred
                                     || retire_inst0_vsetvl_vl_fof
                                     || retire_inst0_vsetvl_illegal;

assign rtu_cp0_vsetvl_vtype_vld       = retire_inst0_vsetvli
                                     || retire_inst1_vsetvli
                                     || retire_inst2_vsetvli
                                     || retire_inst3_vsetvli // add by dhw@20241218
                                     || retire_inst4_vsetvli // add by dhw@20241218
                                     || retire_inst5_vsetvli // add by dhw@20241218
                                     || retire_inst0_vsetvlx
                                        && !retire_inst0_vsetvl_vl_fof;

always @( rob_retire_inst0_vma
       or rob_retire_inst0_vta
       or rob_retire_inst0_vlmul[2:0]
       or rob_retire_inst0_vsew[2:0]
       or rob_retire_inst0_vl[`VL_WIDTH-1:0]
       or rob_retire_inst1_vma
       or rob_retire_inst1_vta
       or rob_retire_inst1_vlmul[2:0]
       or rob_retire_inst1_vsew[2:0]
       or rob_retire_inst1_vl[`VL_WIDTH-1:0]
       or rob_retire_inst2_vma
       or rob_retire_inst2_vta
       or rob_retire_inst2_vlmul[2:0]
       or rob_retire_inst2_vsew[2:0]
       or rob_retire_inst2_vl[`VL_WIDTH-1:0]
       or rob_retire_inst3_vma
       or rob_retire_inst3_vta
       or rob_retire_inst3_vlmul[2:0]
       or rob_retire_inst3_vsew[2:0]
       or rob_retire_inst3_vl[`VL_WIDTH-1:0]
       or rob_retire_inst4_vma
       or rob_retire_inst4_vta
       or rob_retire_inst4_vlmul[2:0]
       or rob_retire_inst4_vsew[2:0]
       or rob_retire_inst4_vl[`VL_WIDTH-1:0]
       or rob_retire_inst5_vma
       or rob_retire_inst5_vta
       or rob_retire_inst5_vlmul[2:0]
       or rob_retire_inst5_vsew[2:0]
       or rob_retire_inst5_vl[`VL_WIDTH-1:0]
       or rob_retire_inst0_mtval[40:0] // add by tmj @20251022
       or retire_inst1_vsetvli
       or retire_inst2_vsetvli
       or retire_inst3_vsetvli
       or retire_inst4_vsetvli
       or retire_inst5_vsetvli
       or retire_inst0_vsetvlx) 
begin
  if(retire_inst0_vsetvlx) begin
    // add by tmj @20251022
    rtu_cp0_vsetvl_vlmul[2:0] = rob_retire_inst0_mtval[2:0];
    rtu_cp0_vsetvl_vsew[2:0]  = rob_retire_inst0_mtval[5:3];
    rtu_cp0_vsetvl_vl[`VL_WIDTH-1:0]    = rob_retire_inst0_mtval[5+`VL_WIDTH:6];
    rtu_cp0_vsetvl_vma        = rob_retire_inst0_mtval[9+`VL_WIDTH];
    rtu_cp0_vsetvl_vta        = rob_retire_inst0_mtval[10+`VL_WIDTH];
  end
  else if(retire_inst5_vsetvli) begin // add by dhw@20241218
    // rtu_cp0_vsetvl_vlmul[1:0] = rob_retire_inst5_vlmul[1:0];
    rtu_cp0_vsetvl_vlmul[2:0] = rob_retire_inst5_vlmul[2:0]; // add by tmj @20251022
    rtu_cp0_vsetvl_vsew[2:0]  = rob_retire_inst5_vsew[2:0];
    rtu_cp0_vsetvl_vl[`VL_WIDTH-1:0]    = rob_retire_inst5_vl[`VL_WIDTH-1:0];
    rtu_cp0_vsetvl_vta        = rob_retire_inst5_vta; // add by tmj @20251122
    rtu_cp0_vsetvl_vma        = rob_retire_inst5_vma;
  end
  else if(retire_inst4_vsetvli) begin // add by dhw@20241218
    // rtu_cp0_vsetvl_vlmul[1:0] = rob_retire_inst4_vlmul[1:0];
    rtu_cp0_vsetvl_vlmul[2:0] = rob_retire_inst4_vlmul[2:0]; // add by tmj @20251022
    rtu_cp0_vsetvl_vsew[2:0]  = rob_retire_inst4_vsew[2:0];
    rtu_cp0_vsetvl_vl[`VL_WIDTH-1:0]    = rob_retire_inst4_vl[`VL_WIDTH-1:0];
    rtu_cp0_vsetvl_vta        = rob_retire_inst4_vta; // add by tmj @20251122
    rtu_cp0_vsetvl_vma        = rob_retire_inst4_vma;
  end
  else if(retire_inst3_vsetvli) begin // add by dhw@20241218
    // rtu_cp0_vsetvl_vlmul[1:0] = rob_retire_inst3_vlmul[1:0];
    rtu_cp0_vsetvl_vlmul[2:0] = rob_retire_inst3_vlmul[2:0]; // add by tmj @20251022
    rtu_cp0_vsetvl_vsew[2:0]  = rob_retire_inst3_vsew[2:0];
    rtu_cp0_vsetvl_vl[`VL_WIDTH-1:0]    = rob_retire_inst3_vl[`VL_WIDTH-1:0];
    rtu_cp0_vsetvl_vta        = rob_retire_inst3_vta; // add by tmj @20251122
    rtu_cp0_vsetvl_vma        = rob_retire_inst3_vma;
  end
  else if(retire_inst2_vsetvli) begin
    // rtu_cp0_vsetvl_vlmul[1:0] = rob_retire_inst2_vlmul[1:0];
    rtu_cp0_vsetvl_vlmul[2:0] = rob_retire_inst2_vlmul[2:0]; // add by tmj @20251022
    rtu_cp0_vsetvl_vsew[2:0]  = rob_retire_inst2_vsew[2:0];
    rtu_cp0_vsetvl_vl[`VL_WIDTH-1:0]    = rob_retire_inst2_vl[`VL_WIDTH-1:0];
    rtu_cp0_vsetvl_vta        = rob_retire_inst2_vta; // add by tmj @20251122
    rtu_cp0_vsetvl_vma        = rob_retire_inst2_vma;
  end
  else if(retire_inst1_vsetvli) begin
    // rtu_cp0_vsetvl_vlmul[1:0] = rob_retire_inst1_vlmul[1:0];
    rtu_cp0_vsetvl_vlmul[2:0] = rob_retire_inst1_vlmul[2:0]; // add by tmj @20251022
    rtu_cp0_vsetvl_vsew[2:0]  = rob_retire_inst1_vsew[2:0];
    rtu_cp0_vsetvl_vl[`VL_WIDTH-1:0]    = rob_retire_inst1_vl[`VL_WIDTH-1:0];
    rtu_cp0_vsetvl_vta        = rob_retire_inst1_vta; // add by tmj @20251122
    rtu_cp0_vsetvl_vma        = rob_retire_inst1_vma;
  end
  else begin
    // rtu_cp0_vsetvl_vlmul[1:0] = rob_retire_inst0_vlmul[1:0];
    rtu_cp0_vsetvl_vlmul[2:0] = rob_retire_inst0_vlmul[2:0]; // add by tmj @20251022
    rtu_cp0_vsetvl_vsew[2:0]  = rob_retire_inst0_vsew[2:0];
    rtu_cp0_vsetvl_vl[`VL_WIDTH-1:0]    = rob_retire_inst0_vl[`VL_WIDTH-1:0];
    rtu_cp0_vsetvl_vta        = rob_retire_inst0_vta; // add by tmj @20251122
    rtu_cp0_vsetvl_vma        = rob_retire_inst0_vma;
  end
end

assign rtu_cp0_vstart_vld                = rob_retire_inst0_vld
                                           && rob_retire_inst0_vstart_vld;
assign rtu_cp0_vstart[`VSTART_WIDTH-1:0]               = rob_retire_inst0_vstart[`VSTART_WIDTH-1:0];

//==========================================================
//                    RTU IFU Interface
//==========================================================
assign rtu_ifu_retire0_mispred           = retire_inst0_normal_retire
                                           && (rob_retire_inst0_bht_mispred
                                            || rob_retire_inst0_jmp_mispred);

assign retire_rob_dbg_inst0_mispred      = retire_inst0_normal_retire
                                           && (rob_retire_inst0_bht_mispred
                                            || rob_retire_inst0_jmp_mispred);

//----------------------------------------------------------
//                    Conditional Branch
//----------------------------------------------------------
assign retire_inst0_condbr               = retire_inst0_normal_retire
                                           && rob_retire_inst0_condbr;
assign retire_inst1_condbr               = retire_inst1_normal_retire
                                           && rob_retire_inst1_condbr;
assign retire_inst2_condbr               = retire_inst2_normal_retire
                                           && rob_retire_inst2_condbr;
// add retire_inst3-5_condbr. dhw@20241218                                           
assign retire_inst3_condbr               = retire_inst3_normal_retire
                                           && rob_retire_inst3_condbr;
assign retire_inst4_condbr               = retire_inst4_normal_retire
                                           && rob_retire_inst4_condbr;
assign retire_inst5_condbr               = retire_inst5_normal_retire
                                           && rob_retire_inst5_condbr;

assign rtu_ifu_retire0_condbr            = retire_inst0_condbr;
assign rtu_ifu_retire1_condbr            = retire_inst1_condbr;
assign rtu_ifu_retire2_condbr            = retire_inst2_condbr;
assign rtu_ifu_retire3_condbr            = retire_inst3_condbr;
assign rtu_ifu_retire4_condbr            = retire_inst4_condbr;
assign rtu_ifu_retire5_condbr            = retire_inst5_condbr;

assign rtu_ifu_retire0_uncondbr = retire_inst0_normal_retire 
                                & rob_retire_inst0_uncondbr;
assign rtu_ifu_retire1_uncondbr = retire_inst1_normal_retire 
                                & rob_retire_inst1_uncondbr;
assign rtu_ifu_retire2_uncondbr = retire_inst2_normal_retire 
                                & rob_retire_inst2_uncondbr;
assign rtu_ifu_retire3_uncondbr = retire_inst3_normal_retire 
                                & rob_retire_inst3_uncondbr;
assign rtu_ifu_retire4_uncondbr = retire_inst4_normal_retire 
                                & rob_retire_inst4_uncondbr;
assign rtu_ifu_retire5_uncondbr = retire_inst5_normal_retire 
                                & rob_retire_inst5_uncondbr;

assign rtu_ifu_retire0_condbr_taken      = retire_inst0_normal_retire
                                           && rob_retire_inst0_condbr_taken;
assign rtu_ifu_retire1_condbr_taken      = retire_inst1_normal_retire
                                           && rob_retire_inst1_condbr_taken;
assign rtu_ifu_retire2_condbr_taken      = retire_inst2_normal_retire
                                           && rob_retire_inst2_condbr_taken;
assign rtu_ifu_retire3_condbr_taken      = retire_inst3_normal_retire
                                           && rob_retire_inst3_condbr_taken;
assign rtu_ifu_retire4_condbr_taken      = retire_inst4_normal_retire
                                           && rob_retire_inst4_condbr_taken;
assign rtu_ifu_retire5_condbr_taken      = retire_inst5_normal_retire
                                           && rob_retire_inst5_condbr_taken;


//----------------------------------------------------------
//                      Return Stack
//----------------------------------------------------------
assign rtu_ifu_retire0_pcall             = retire_inst0_normal_retire
                                           && rob_retire_inst0_pcal;
assign rtu_ifu_retire0_preturn           = retire_inst0_normal_retire
                                           && rob_retire_inst0_pret;
assign rtu_ifu_retire0_inc_pc      = rob_retire_inst0_bju_inc_pc;

//----------------------------------------------------------
//                      Indirect Jump
//----------------------------------------------------------
assign retire_inst0_jmp_mispred          = retire_inst0_normal_retire
                                           && rob_retire_inst0_jmp_mispred
                                           && !rob_retire_inst0_pret;

assign rtu_ifu_retire0_jmp_mispred       = retire_inst0_jmp_mispred;

assign retire_inst0_jmp                  = retire_inst0_normal_retire
                                           && rob_retire_inst0_jmp
                                           && !rob_retire_inst0_pret;
assign retire_inst1_jmp                  = retire_inst1_normal_retire
                                           && rob_retire_inst1_jmp;
assign retire_inst2_jmp                  = retire_inst2_normal_retire
                                           && rob_retire_inst2_jmp;
// add retire_inst3-5_jmp. dhw@20241218                                        
assign retire_inst3_jmp                  = retire_inst3_normal_retire
                                           && rob_retire_inst3_jmp;
assign retire_inst4_jmp                  = retire_inst4_normal_retire
                                           && rob_retire_inst4_jmp;
assign retire_inst5_jmp                  = retire_inst5_normal_retire
                                           && rob_retire_inst5_jmp;

assign rtu_ifu_retire0_jmp               = retire_inst0_jmp;
assign rtu_ifu_retire1_jmp               = retire_inst1_jmp;
assign rtu_ifu_retire2_jmp               = retire_inst2_jmp;
assign rtu_ifu_retire3_jmp               = retire_inst3_jmp;
assign rtu_ifu_retire4_jmp               = retire_inst4_jmp;
assign rtu_ifu_retire5_jmp               = retire_inst5_jmp;

assign rtu_ifu_retire0_chk_idx[7:0]      = rob_retire_inst0_chk_idx[7:0];
assign rtu_ifu_retire1_chk_idx[7:0]      = rob_retire_inst1_chk_idx[7:0];
assign rtu_ifu_retire2_chk_idx[7:0]      = rob_retire_inst2_chk_idx[7:0];
assign rtu_ifu_retire3_chk_idx[7:0]      = rob_retire_inst3_chk_idx[7:0];
assign rtu_ifu_retire4_chk_idx[7:0]      = rob_retire_inst4_chk_idx[7:0];
assign rtu_ifu_retire5_chk_idx[7:0]      = rob_retire_inst5_chk_idx[7:0];

//assign rtu_ifu_retire0_next_pc[38:0]     = rob_retire_inst0_next_pc[38:0];

//----------------------------------------------------------
//                         No Spec
//----------------------------------------------------------
assign rtu_ifu_retire_inst0_load         = retire_inst0_normal_retire
                                           && rob_retire_inst0_load;
assign rtu_ifu_retire_inst1_load         = retire_inst1_normal_retire
                                           && rob_retire_inst1_load;
assign rtu_ifu_retire_inst2_load         = retire_inst2_normal_retire
                                           && rob_retire_inst2_load;
assign rtu_ifu_retire_inst3_load         = retire_inst3_normal_retire // add by dhw@20241218
                                           && rob_retire_inst3_load;
assign rtu_ifu_retire_inst4_load         = retire_inst4_normal_retire // add by dhw@20241218
                                           && rob_retire_inst4_load;
assign rtu_ifu_retire_inst5_load         = retire_inst5_normal_retire // add by dhw@20241218
                                           && rob_retire_inst5_load;

assign rtu_ifu_retire_inst0_store        = retire_inst0_normal_retire
                                           && rob_retire_inst0_store;
assign rtu_ifu_retire_inst1_store        = retire_inst1_normal_retire
                                           && rob_retire_inst1_store;
assign rtu_ifu_retire_inst2_store        = retire_inst2_normal_retire
                                           && rob_retire_inst2_store;
assign rtu_ifu_retire_inst3_store        = retire_inst3_normal_retire // add by dhw@20241218
                                           && rob_retire_inst3_store;
assign rtu_ifu_retire_inst4_store        = retire_inst4_normal_retire // add by dhw@20241218
                                           && rob_retire_inst4_store;
assign rtu_ifu_retire_inst5_store        = retire_inst5_normal_retire // add by dhw@20241218
                                           && rob_retire_inst5_store;

assign rtu_ifu_retire_inst0_no_spec_hit     = rob_retire_inst0_no_spec_hit;
assign rtu_ifu_retire_inst1_no_spec_hit     = rob_retire_inst1_no_spec_hit;
assign rtu_ifu_retire_inst2_no_spec_hit     = rob_retire_inst2_no_spec_hit;
assign rtu_ifu_retire_inst3_no_spec_hit     = rob_retire_inst3_no_spec_hit; // add by dhw@20241218
assign rtu_ifu_retire_inst4_no_spec_hit     = rob_retire_inst4_no_spec_hit; // add by dhw@20241218
assign rtu_ifu_retire_inst5_no_spec_hit     = rob_retire_inst5_no_spec_hit; // add by dhw@20241218

assign rtu_ifu_retire_inst0_no_spec_miss    = rob_retire_inst0_no_spec_miss;
assign rtu_ifu_retire_inst1_no_spec_miss    = rob_retire_inst1_no_spec_miss;
assign rtu_ifu_retire_inst2_no_spec_miss    = rob_retire_inst2_no_spec_miss;
assign rtu_ifu_retire_inst3_no_spec_miss    = rob_retire_inst3_no_spec_miss; // add by dhw@20241218
assign rtu_ifu_retire_inst4_no_spec_miss    = rob_retire_inst4_no_spec_miss; // add by dhw@20241218
assign rtu_ifu_retire_inst5_no_spec_miss    = rob_retire_inst5_no_spec_miss; // add by dhw@20241218

assign rtu_ifu_retire_inst0_no_spec_mispred = rob_retire_inst0_no_spec_mispred;
assign rtu_ifu_retire_inst1_no_spec_mispred = rob_retire_inst1_no_spec_mispred;
assign rtu_ifu_retire_inst2_no_spec_mispred = rob_retire_inst2_no_spec_mispred;
assign rtu_ifu_retire_inst3_no_spec_mispred = rob_retire_inst3_no_spec_mispred; // add by dhw@20241218
assign rtu_ifu_retire_inst4_no_spec_mispred = rob_retire_inst4_no_spec_mispred; // add by dhw@20241218
assign rtu_ifu_retire_inst5_no_spec_mispred = rob_retire_inst5_no_spec_mispred; // add by dhw@20241218

assign rtu_ifu_retire_inst0_no_spec_target  = rob_retire_inst0_no_spec_target;
assign rtu_ifu_retire_inst1_no_spec_target  = rob_retire_inst1_no_spec_target;
assign rtu_ifu_retire_inst2_no_spec_target  = rob_retire_inst2_no_spec_target;
assign rtu_ifu_retire_inst3_no_spec_target  = rob_retire_inst3_no_spec_target; // add by dhw@20241218
assign rtu_ifu_retire_inst4_no_spec_target  = rob_retire_inst4_no_spec_target; // add by dhw@20241218
assign rtu_ifu_retire_inst5_no_spec_target  = rob_retire_inst5_no_spec_target; // add by dhw@20241218

assign rtu_ifu_retire_inst0_cur_pc    = rob_retire_inst0_cur_pc;
assign rtu_ifu_retire_inst1_cur_pc    = rob_retire_inst1_cur_pc;
assign rtu_ifu_retire_inst2_cur_pc    = rob_retire_inst2_cur_pc;
assign rtu_ifu_retire_inst3_cur_pc    = rob_retire_inst3_cur_pc; // add by dhw@20241218
assign rtu_ifu_retire_inst4_cur_pc    = rob_retire_inst4_cur_pc; // add by dhw@20241218
assign rtu_ifu_retire_inst5_cur_pc    = rob_retire_inst5_cur_pc; // add by dhw@20241218

//----------------------------------------------------------
//                          Vl
//----------------------------------------------------------
assign rtu_ifu_retire_inst0_vl_pred      = retire_inst0_vsetvli
                                           && rob_retire_inst0_vl_pred;
assign rtu_ifu_retire_inst1_vl_pred      = retire_inst1_vsetvli
                                           && rob_retire_inst1_vl_pred;
assign rtu_ifu_retire_inst2_vl_pred      = retire_inst2_vsetvli
                                           && rob_retire_inst2_vl_pred;
// add rtu_ifu_retire_inst3-5_vl_pred. dhw@20241218                                           
assign rtu_ifu_retire_inst3_vl_pred      = retire_inst3_vsetvli
                                           && rob_retire_inst3_vl_pred;
assign rtu_ifu_retire_inst4_vl_pred      = retire_inst4_vsetvli
                                           && rob_retire_inst4_vl_pred;
assign rtu_ifu_retire_inst5_vl_pred      = retire_inst5_vsetvli
                                           && rob_retire_inst5_vl_pred;

assign rtu_ifu_retire_inst0_vl[`VL_WIDTH-1:0]      = retire_inst0_vsetvlx
                                          //  ? rob_retire_inst0_mtval[12:5]
                                           ? rob_retire_inst0_mtval[5+`VL_WIDTH:6] // add by tmj @20251022
                                           : rob_retire_inst0_vl[`VL_WIDTH-1:0];
assign rtu_ifu_retire_inst1_vl[`VL_WIDTH-1:0]      = rob_retire_inst1_vl[`VL_WIDTH-1:0];
assign rtu_ifu_retire_inst2_vl[`VL_WIDTH-1:0]      = rob_retire_inst2_vl[`VL_WIDTH-1:0];
assign rtu_ifu_retire_inst3_vl[`VL_WIDTH-1:0]      = rob_retire_inst3_vl[`VL_WIDTH-1:0]; // add by dhw@20241218
assign rtu_ifu_retire_inst4_vl[`VL_WIDTH-1:0]      = rob_retire_inst4_vl[`VL_WIDTH-1:0]; // add by dhw@20241218
assign rtu_ifu_retire_inst5_vl[`VL_WIDTH-1:0]      = rob_retire_inst5_vl[`VL_WIDTH-1:0]; // add by dhw@20241218

assign rtu_ifu_retire_inst0_vl_mispred   = retire_inst0_vsetvl_vl_mispred
                                           && retire_inst0_vsetvli
                                           && rob_retire_inst0_vl_pred;
assign rtu_ifu_retire_inst0_vl_hit       = !retire_inst0_vsetvl_vl_mispred
                                           && retire_inst0_vsetvli
                                           && rob_retire_inst0_vl_pred;
assign rtu_ifu_retire_inst0_vl_miss      = retire_inst0_vsetvl_vl_mispred
                                           && retire_inst0_vsetvli
                                           && !rob_retire_inst0_vl_pred;


//----------------------------------------------------------
//                   RTU IFU Change Flow
//----------------------------------------------------------
//if flush inst retires without exception, signal rob to flop rob cur pc
//into retire inst0 pc and then output to IFU PC MUX
//==========================================================
//                  Risc-V Debug zdb Begin (insert)
//==========================================================
assign debug_req_t1_flush           = halt_req_dm_sync | halt_req_group | retire_debug_step_flush;
assign debug_req_t0_flush           = halt_req;
//==========================================================
//                  Risc-V Debug zdb End   (insert)
//==========================================================
assign retire_inst0_inst_flush      = retire_inst0_normal_retire
                                      && (rob_retire_inst0_inst_flush
                                       || rob_retire_inst0_ctc_flush
                                          && !rob_retire_inst0_split);

// assign retire_rob_inst_flush        = retire_inst0_inst_flush;
assign retire_rob_inst_flush        = retire_inst0_inst_flush | debug_req_t1_flush; //update cur_pc for chgflw_pc Risc-V Debug zdb replace
assign retire_rob_dbg_inst0_flush   = retire_inst0_inst_flush;

always @(posedge retire_clk or negedge cpurst_b)
begin
  if(!cpurst_b) 
    retire_ifu_chgflw_vld <= 1'b0;
  else 
//==========================================================
//                  Risc-V Debug zdb Begin (replace)
//==========================================================
    retire_ifu_chgflw_vld <= retire_inst0_inst_flush
                             | debug_req_t1_flush
                             | debug_req_t0_flush
                             | retire_exit_debug_raw & ~retire_exit_debug;
//==========================================================
//                  Risc-V Debug zdb End   (replace)
//==========================================================
end

//flop and then signal IFU to changeflow
assign rtu_ifu_chgflw_vld           = retire_ifu_chgflw_vld;
//at this time, flush change flow pc is in retire inst0 cur pc
assign rtu_ifu_chgflw_pc[`WK_PC_LEN-1:0]      = retire_exit_debug ? dtu_rtu_dpc[`WK_PC_LEN-1:0] : rob_retire_inst0_cur_pc[`WK_PC_LEN-1:0];

//----------------------------------------------------------
//              Debug Ack and Mode on signal
//----------------------------------------------------------
assign rtu_yy_xx_dbgon = dbg_mode_on;

assign rtu_ifu_xx_dbgon                 = dbg_mode_on_after_req; // Risc-V Debug

assign retire_rob_dbg_inst0_dbg_mode_on = dbg_mode_on_after_req; // Risc-V Debug

assign rtu_hpcp_trace_inst0_chgflow          = retire_inst0_normal_retire
                                               && rob_retire_inst0_bju;
assign rtu_hpcp_trace_inst1_chgflow          = retire_inst1_normal_retire
                                               && rob_retire_inst1_bju;
assign rtu_hpcp_trace_inst2_chgflow          = retire_inst2_normal_retire
                                               && rob_retire_inst2_bju;
assign rtu_hpcp_trace_inst3_chgflow          = retire_inst3_normal_retire
                                               && rob_retire_inst3_bju;
assign rtu_hpcp_trace_inst4_chgflow          = retire_inst4_normal_retire
                                               && rob_retire_inst4_bju;
assign rtu_hpcp_trace_inst5_chgflow          = retire_inst5_normal_retire
                                               && rob_retire_inst5_bju;

assign rtu_hpcp_trace_inst0_next_pc    = rob_retire_inst0_next_pc;
assign rtu_hpcp_trace_inst1_next_pc    = rob_retire_inst1_next_pc;
assign rtu_hpcp_trace_inst2_next_pc    = rob_retire_inst2_next_pc;
assign rtu_hpcp_trace_inst3_next_pc    = rob_retire_inst3_next_pc;
assign rtu_hpcp_trace_inst4_next_pc    = rob_retire_inst4_next_pc;
assign rtu_hpcp_trace_inst5_next_pc    = rob_retire_inst5_next_pc;


//----------------------------------------------------------
//                 Performance Monitor
//----------------------------------------------------------
assign instret_mask = rob_retire_inst0_expt_vld
                   && ((rob_retire_inst0_expt_vec[3:0] == 4'd8)   //u-ecall
                     | (rob_retire_inst0_expt_vec[3:0] == 4'd9)   //s-ecall
                     | (rob_retire_inst0_expt_vec[3:0] == 4'd11)  //m-ecall
                     | (rob_retire_inst0_expt_vec[3:0] == 4'd3));  //ebreak
always @(posedge hpcp_clk or negedge cpurst_b)
begin
  if(!cpurst_b) begin
    retire_retire_hpcp_inst0_vld     <= 1'b0;
    retire_retire_hpcp_inst1_vld     <= 1'b0;
    retire_retire_hpcp_inst2_vld     <= 1'b0;
    retire_retire_hpcp_inst3_vld     <= 1'b0; // add by dhw@20241218
    retire_retire_hpcp_inst4_vld     <= 1'b0; // add by dhw@20241218
    retire_retire_hpcp_inst5_vld     <= 1'b0; // add by dhw@20241218

    retire_hpcp_inst0_split          <= 1'b0;
    retire_hpcp_inst1_split          <= 1'b0;
    retire_hpcp_inst2_split          <= 1'b0;
    retire_hpcp_inst3_split          <= 1'b0; // add by dhw@20241218
    retire_hpcp_inst4_split          <= 1'b0; // add by dhw@20241218
    retire_hpcp_inst5_split          <= 1'b0; // add by dhw@20241218
    retire_hpcp_inst0_num[1:0]       <= 2'b0;
    retire_hpcp_inst1_num[1:0]       <= 2'b0;
    retire_hpcp_inst2_num[1:0]       <= 2'b0;
    retire_hpcp_inst3_num[1:0]       <= 2'b0; // add by dhw@20241218
    retire_hpcp_inst4_num[1:0]       <= 2'b0; // add by dhw@20241218
    retire_hpcp_inst5_num[1:0]       <= 2'b0; // add by dhw@20241218
    retire_hpcp_inst0_pc_offset[2:0] <= 3'b0;
    retire_hpcp_inst1_pc_offset[2:0] <= 3'b0;
    retire_hpcp_inst2_pc_offset[2:0] <= 3'b0;
    retire_hpcp_inst3_pc_offset[2:0] <= 3'b0; // add by dhw@20241218
    retire_hpcp_inst4_pc_offset[2:0] <= 3'b0; // add by dhw@20241218
    retire_hpcp_inst5_pc_offset[2:0] <= 3'b0; // add by dhw@20241218
    retire_hpcp_inst0_condbr         <= 1'b0;
    retire_hpcp_inst1_condbr         <= 1'b0;
    retire_hpcp_inst2_condbr         <= 1'b0;
    retire_hpcp_inst3_condbr         <= 1'b0; // add by dhw@20241218
    retire_hpcp_inst4_condbr         <= 1'b0; // add by dhw@20241218
    retire_hpcp_inst5_condbr         <= 1'b0; // add by dhw@20241218
    retire_hpcp_inst0_jmp            <= 1'b0;
    retire_hpcp_inst1_jmp            <= 1'b0;
    retire_hpcp_inst2_jmp            <= 1'b0;
    retire_hpcp_inst3_jmp            <= 1'b0; // add by dhw@20241218
    retire_hpcp_inst4_jmp            <= 1'b0; // add by dhw@20241218
    retire_hpcp_inst5_jmp            <= 1'b0; // add by dhw@20241218
    retire_hpcp_inst0_store          <= 1'b0;
    retire_hpcp_inst1_store          <= 1'b0;
    retire_hpcp_inst2_store          <= 1'b0;
    retire_hpcp_inst3_store          <= 1'b0; // add by dhw@20241218
    retire_hpcp_inst4_store          <= 1'b0; // add by dhw@20241218
    retire_hpcp_inst5_store          <= 1'b0; // add by dhw@20241218
    retire_hpcp_inst0_bht_mispred    <= 1'b0;
    retire_hpcp_inst0_jmp_mispred    <= 1'b0;
    retire_hpcp_inst0_spec_fail      <= 1'b0;
    retire_hpcp_inst0_ack_int        <= 1'b0;
  end
  else if(hpcp_rtu_cnt_en && rob_retire_inst0_vld) begin
    // retire_retire_hpcp_inst0_vld     <= rob_retire_inst0_vld & ~instret_mask;
    retire_retire_hpcp_inst0_vld     <= rob_retire_inst0_vld & ~rob_retire_inst0_ebreak & ~rob_retire_inst0_ecall; // Risc-V Debug zdb replace
    retire_retire_hpcp_inst1_vld     <= rob_retire_inst1_vld;
    retire_retire_hpcp_inst2_vld     <= rob_retire_inst2_vld;
    retire_retire_hpcp_inst3_vld     <= rob_retire_inst3_vld;
    retire_retire_hpcp_inst4_vld     <= rob_retire_inst4_vld;
    retire_retire_hpcp_inst5_vld     <= rob_retire_inst5_vld;

    retire_hpcp_inst0_split          <= rob_retire_inst0_split;
    retire_hpcp_inst1_split          <= rob_retire_inst1_split;
    retire_hpcp_inst2_split          <= rob_retire_inst2_split;
    retire_hpcp_inst3_split          <= rob_retire_inst3_split;
    retire_hpcp_inst4_split          <= rob_retire_inst4_split;
    retire_hpcp_inst5_split          <= rob_retire_inst5_split;
    retire_hpcp_inst0_num[1:0]       <= rob_retire_inst0_num[1:0];
    retire_hpcp_inst1_num[1:0]       <= rob_retire_inst1_num[1:0];
    retire_hpcp_inst2_num[1:0]       <= rob_retire_inst2_num[1:0];
    retire_hpcp_inst3_num[1:0]       <= rob_retire_inst3_num[1:0];
    retire_hpcp_inst4_num[1:0]       <= rob_retire_inst4_num[1:0];
    retire_hpcp_inst5_num[1:0]       <= rob_retire_inst5_num[1:0];
    retire_hpcp_inst0_pc_offset[2:0] <= rob_retire_inst0_pc_offset[2:0];
    retire_hpcp_inst1_pc_offset[2:0] <= rob_retire_inst1_pc_offset[2:0];
    retire_hpcp_inst2_pc_offset[2:0] <= rob_retire_inst2_pc_offset[2:0];    
    retire_hpcp_inst3_pc_offset[2:0] <= rob_retire_inst3_pc_offset[2:0];
    retire_hpcp_inst4_pc_offset[2:0] <= rob_retire_inst4_pc_offset[2:0];
    retire_hpcp_inst5_pc_offset[2:0] <= rob_retire_inst5_pc_offset[2:0];    
    retire_hpcp_inst0_condbr         <= retire_inst0_condbr;
    retire_hpcp_inst1_condbr         <= retire_inst1_condbr;
    retire_hpcp_inst2_condbr         <= retire_inst2_condbr;
    retire_hpcp_inst3_condbr         <= retire_inst3_condbr;
    retire_hpcp_inst4_condbr         <= retire_inst4_condbr;
    retire_hpcp_inst5_condbr         <= retire_inst5_condbr;
    retire_hpcp_inst0_jmp            <= retire_inst0_jmp;
    retire_hpcp_inst1_jmp            <= retire_inst1_jmp;
    retire_hpcp_inst2_jmp            <= retire_inst2_jmp;
    retire_hpcp_inst3_jmp            <= retire_inst3_jmp;
    retire_hpcp_inst4_jmp            <= retire_inst4_jmp;
    retire_hpcp_inst5_jmp            <= retire_inst5_jmp;
    retire_hpcp_inst0_store          <= rob_retire_inst0_store;
    retire_hpcp_inst1_store          <= rob_retire_inst1_store;
    retire_hpcp_inst2_store          <= rob_retire_inst2_store;
    retire_hpcp_inst3_store          <= rob_retire_inst3_store;
    retire_hpcp_inst4_store          <= rob_retire_inst4_store;
    retire_hpcp_inst5_store          <= rob_retire_inst5_store;
    retire_hpcp_inst0_bht_mispred    <= retire_inst0_normal_retire
                                        && rob_retire_inst0_bht_mispred;
    retire_hpcp_inst0_jmp_mispred    <= retire_inst0_jmp_mispred;
    retire_hpcp_inst0_spec_fail      <= rob_retire_inst0_spec_fail;
    //ignore int when debug ack for timing
    retire_hpcp_inst0_ack_int        <= !dbg_mode_on && retire_ack_int;
  end
  else begin
    retire_retire_hpcp_inst0_vld     <= 1'b0;
    retire_retire_hpcp_inst1_vld     <= 1'b0;
    retire_retire_hpcp_inst2_vld     <= 1'b0;
    retire_retire_hpcp_inst3_vld     <= 1'b0;
    retire_retire_hpcp_inst4_vld     <= 1'b0;
    retire_retire_hpcp_inst5_vld     <= 1'b0;

    retire_hpcp_inst0_split          <= retire_hpcp_inst0_split;
    retire_hpcp_inst1_split          <= retire_hpcp_inst1_split;
    retire_hpcp_inst2_split          <= retire_hpcp_inst2_split;
    retire_hpcp_inst3_split          <= retire_hpcp_inst3_split;
    retire_hpcp_inst4_split          <= retire_hpcp_inst4_split;
    retire_hpcp_inst5_split          <= retire_hpcp_inst5_split;
    retire_hpcp_inst0_num[1:0]       <= retire_hpcp_inst0_num[1:0];
    retire_hpcp_inst1_num[1:0]       <= retire_hpcp_inst1_num[1:0];
    retire_hpcp_inst2_num[1:0]       <= retire_hpcp_inst2_num[1:0];
    retire_hpcp_inst3_num[1:0]       <= retire_hpcp_inst3_num[1:0];
    retire_hpcp_inst4_num[1:0]       <= retire_hpcp_inst4_num[1:0];
    retire_hpcp_inst5_num[1:0]       <= retire_hpcp_inst5_num[1:0];
    retire_hpcp_inst0_pc_offset[2:0] <= retire_hpcp_inst0_pc_offset[2:0];
    retire_hpcp_inst1_pc_offset[2:0] <= retire_hpcp_inst1_pc_offset[2:0];
    retire_hpcp_inst2_pc_offset[2:0] <= retire_hpcp_inst2_pc_offset[2:0];
    retire_hpcp_inst3_pc_offset[2:0] <= retire_hpcp_inst3_pc_offset[2:0];
    retire_hpcp_inst4_pc_offset[2:0] <= retire_hpcp_inst4_pc_offset[2:0];
    retire_hpcp_inst5_pc_offset[2:0] <= retire_hpcp_inst5_pc_offset[2:0];
    retire_hpcp_inst0_condbr         <= retire_hpcp_inst0_condbr;
    retire_hpcp_inst1_condbr         <= retire_hpcp_inst1_condbr;
    retire_hpcp_inst2_condbr         <= retire_hpcp_inst2_condbr;
    retire_hpcp_inst3_condbr         <= retire_hpcp_inst3_condbr;
    retire_hpcp_inst4_condbr         <= retire_hpcp_inst4_condbr;
    retire_hpcp_inst5_condbr         <= retire_hpcp_inst5_condbr;
    retire_hpcp_inst0_jmp            <= retire_hpcp_inst0_jmp;
    retire_hpcp_inst1_jmp            <= retire_hpcp_inst1_jmp;
    retire_hpcp_inst2_jmp            <= retire_hpcp_inst2_jmp;
    retire_hpcp_inst3_jmp            <= retire_hpcp_inst3_jmp;
    retire_hpcp_inst4_jmp            <= retire_hpcp_inst4_jmp;
    retire_hpcp_inst5_jmp            <= retire_hpcp_inst5_jmp;
    retire_hpcp_inst0_store          <= retire_hpcp_inst0_store;
    retire_hpcp_inst1_store          <= retire_hpcp_inst1_store;
    retire_hpcp_inst2_store          <= retire_hpcp_inst2_store;
    retire_hpcp_inst3_store          <= retire_hpcp_inst3_store;
    retire_hpcp_inst4_store          <= retire_hpcp_inst4_store;
    retire_hpcp_inst5_store          <= retire_hpcp_inst5_store;
    retire_hpcp_inst0_bht_mispred    <= retire_hpcp_inst0_bht_mispred;
    retire_hpcp_inst0_jmp_mispred    <= retire_hpcp_inst0_jmp_mispred;
    retire_hpcp_inst0_spec_fail      <= retire_hpcp_inst0_spec_fail;
    retire_hpcp_inst0_ack_int        <= retire_hpcp_inst0_ack_int;
  end
end

assign rtu_hpcp_inst0_vld                   = retire_retire_hpcp_inst0_vld;
assign rtu_hpcp_inst1_vld                   = retire_retire_hpcp_inst1_vld;
assign rtu_hpcp_inst2_vld                   = retire_retire_hpcp_inst2_vld;
assign rtu_hpcp_inst3_vld                   = retire_retire_hpcp_inst3_vld;
assign rtu_hpcp_inst4_vld                   = retire_retire_hpcp_inst4_vld;
assign rtu_hpcp_inst5_vld                   = retire_retire_hpcp_inst5_vld;

assign rtu_hpcp_inst0_split                 = retire_hpcp_inst0_split;
assign rtu_hpcp_inst1_split                 = retire_hpcp_inst1_split;
assign rtu_hpcp_inst2_split                 = retire_hpcp_inst2_split;
assign rtu_hpcp_inst3_split                 = retire_hpcp_inst3_split;
assign rtu_hpcp_inst4_split                 = retire_hpcp_inst4_split;
assign rtu_hpcp_inst5_split                 = retire_hpcp_inst5_split;

assign rtu_hpcp_inst0_num[1:0]              = retire_hpcp_inst0_num[1:0];
assign rtu_hpcp_inst1_num[1:0]              = retire_hpcp_inst1_num[1:0];
assign rtu_hpcp_inst2_num[1:0]              = retire_hpcp_inst2_num[1:0];
assign rtu_hpcp_inst3_num[1:0]              = retire_hpcp_inst3_num[1:0];
assign rtu_hpcp_inst4_num[1:0]              = retire_hpcp_inst4_num[1:0];
assign rtu_hpcp_inst5_num[1:0]              = retire_hpcp_inst5_num[1:0];

assign rtu_hpcp_inst0_pc_offset[2:0]        = retire_hpcp_inst0_pc_offset[2:0];
assign rtu_hpcp_inst1_pc_offset[2:0]        = retire_hpcp_inst1_pc_offset[2:0];
assign rtu_hpcp_inst2_pc_offset[2:0]        = retire_hpcp_inst2_pc_offset[2:0];
assign rtu_hpcp_inst3_pc_offset[2:0]        = retire_hpcp_inst3_pc_offset[2:0];
assign rtu_hpcp_inst4_pc_offset[2:0]        = retire_hpcp_inst4_pc_offset[2:0];
assign rtu_hpcp_inst5_pc_offset[2:0]        = retire_hpcp_inst5_pc_offset[2:0];

assign rtu_hpcp_inst0_condbr                = retire_hpcp_inst0_condbr;
assign rtu_hpcp_inst1_condbr                = retire_hpcp_inst1_condbr;
assign rtu_hpcp_inst2_condbr                = retire_hpcp_inst2_condbr;
assign rtu_hpcp_inst3_condbr                = retire_hpcp_inst3_condbr;
assign rtu_hpcp_inst4_condbr                = retire_hpcp_inst4_condbr;
assign rtu_hpcp_inst5_condbr                = retire_hpcp_inst5_condbr;

assign rtu_hpcp_inst0_jmp                   = retire_hpcp_inst0_jmp;
assign rtu_hpcp_inst1_jmp                   = retire_hpcp_inst1_jmp;
assign rtu_hpcp_inst2_jmp                   = retire_hpcp_inst2_jmp;
assign rtu_hpcp_inst3_jmp                   = retire_hpcp_inst3_jmp;
assign rtu_hpcp_inst4_jmp                   = retire_hpcp_inst4_jmp;
assign rtu_hpcp_inst5_jmp                   = retire_hpcp_inst5_jmp;

assign rtu_hpcp_inst0_bht_mispred           = retire_hpcp_inst0_bht_mispred;
assign rtu_hpcp_inst0_jmp_mispred           = retire_hpcp_inst0_jmp_mispred;

assign rtu_hpcp_inst0_store                 = retire_hpcp_inst0_store;
assign rtu_hpcp_inst1_store                 = retire_hpcp_inst1_store;
assign rtu_hpcp_inst2_store                 = retire_hpcp_inst2_store;
assign rtu_hpcp_inst3_store                 = retire_hpcp_inst3_store;
assign rtu_hpcp_inst4_store                 = retire_hpcp_inst4_store;
assign rtu_hpcp_inst5_store                 = retire_hpcp_inst5_store;

assign rtu_hpcp_inst0_spec_fail             = retire_hpcp_inst0_spec_fail;
assign rtu_hpcp_inst0_ack_int               = retire_hpcp_inst0_ack_int;

assign retire_rob_inst0_jmp                 = retire_hpcp_inst0_jmp;
assign retire_rob_inst1_jmp                 = retire_hpcp_inst1_jmp;
assign retire_rob_inst2_jmp                 = retire_hpcp_inst2_jmp;
assign retire_rob_inst3_jmp                 = retire_hpcp_inst3_jmp; // add by dhw@20241218
assign retire_rob_inst4_jmp                 = retire_hpcp_inst4_jmp; // add by dhw@20241218
assign retire_rob_inst5_jmp                 = retire_hpcp_inst5_jmp; // add by dhw@20241218

//==========================================================
//                    Flush Control
//==========================================================

parameter FLUSH_IDLE  = 5'b00001;
parameter FLUSH_IS    = 5'b00010;
parameter FLUSH_FE    = 5'b00100;
parameter WF_EMPTY    = 5'b01000;
parameter FLUSH_IS_BE = 5'b10010;
parameter FLUSH_FE_BE = 5'b10100;
parameter FLUSH_BE    = 5'b10000;

//----------------------------------------------------------
//              Prepare state machine signals
//----------------------------------------------------------
//==========================================================
//                  Risc-V Debug zdb Begin
//==========================================================
assign retire_inst0_flush          = retire_expt_vld
                                     | retire_inst0_inst_flush
                                     | retire_debug_expt_vld
                                     | retire_debug_step_flush //single step flush
                                     | bkpt_req_t1
                                     | halt_req
                                     | halt_req_t1
                                     | retire_dtu_resume_req & dbg_mode_on_after_req
                                     | retire_async_expt_vld;
//==========================================================
//                  Risc-V Debug zdb End
//==========================================================
assign retire_inst0_mispred        = retire_inst0_normal_retire
                                     && (rob_retire_inst0_jmp_mispred
                                      || rob_retire_inst0_bht_mispred);

//==========================================================
//                  Risc-V Debug zdb Begin
//==========================================================
assign retire_inst0_flush_gateclk  = retire_expt_gateclk_vld
                                     | retire_inst0_inst_flush
                                     | retire_debug_expt_vld
                                     | retire_debug_step_flush
                                     | retire_inst0_mispred
                                     | bkpt_req_t1
                                     | halt_req
                                     | halt_req_t1
                                     | retire_dtu_resume_req 
                                     | retire_exit_debug;
//==========================================================
//                  Risc-V Debug zdb End
//==========================================================

assign retire_flush_pipeline_empty = pst_retire_retired_reg_wb
                                     && lsu_rtu_all_commit_data_vld;

//----------------------------------------------------------
//                      FSM of Flush
//----------------------------------------------------------
// State Description:
// FLUSH_IDLE  : no flush or retiring inst 0 will trigger flush.
//               if triggering, stop commit, flush ROB, retire/expt entry
// FLUSH_IS    : flush IDU IS/RF, flush IDU ptag pool, start to stall
//               IDU ID, stall IDU ID
// FLUSH_FE    : flush IFU and IDU ID/IR/IS/RF, flush IDU ptag pool,
//               stall IDU ID
// WF_EMPTY    : wait PST retired and released entry WB, stall IDU ID
// FLUSH_BE    : flush PST, recover rename table,
//               stop IDU ID mispred stall, stall IDU ID
// FLUSH_IS_BE : flush IS and flush backend
// FLUSH_FE_BE : flush frontend and flush backend

always @(posedge sm_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    flush_cur_state[4:0] <= FLUSH_IDLE;
  else if(async_flush)
    flush_cur_state[4:0] <= FLUSH_FE_BE;
  else
    flush_cur_state[4:0] <= flush_next_state[4:0];
end

always @( retire_flush_pipeline_empty
       or flush_cur_state[4:0]
       or retire_inst0_flush
       or retire_inst0_mispred)
begin
  case(flush_cur_state[4:0])
    FLUSH_IDLE  : if(retire_inst0_flush
                     && retire_flush_pipeline_empty)
                    flush_next_state[4:0] = FLUSH_FE_BE;
                  else if(retire_inst0_flush)
                    flush_next_state[4:0] = FLUSH_FE;
                  //else if(retire_inst0_mispred                //bju mispred flush state move to rtu_rob_expt, ck_flush@LTL
                  //   && retire_flush_pipeline_empty)
                  //  flush_next_state[4:0] = FLUSH_IS_BE;
                  //else if(retire_inst0_mispred)
                  //  flush_next_state[4:0] = FLUSH_IS;
                  else
                    flush_next_state[4:0] = FLUSH_IDLE;
    FLUSH_IS    : if(retire_flush_pipeline_empty)
                    flush_next_state[4:0] = FLUSH_BE;
                  else
                    flush_next_state[4:0] = WF_EMPTY;
    FLUSH_FE    : if(retire_flush_pipeline_empty)
                    flush_next_state[4:0] = FLUSH_BE;
                  else
                    flush_next_state[4:0] = WF_EMPTY;
    WF_EMPTY    : if(retire_flush_pipeline_empty)
                    flush_next_state[4:0] = FLUSH_BE;
                  else
                    flush_next_state[4:0] = WF_EMPTY;
    FLUSH_IS_BE :   flush_next_state[4:0] = FLUSH_IDLE;
    FLUSH_FE_BE :   flush_next_state[4:0] = FLUSH_IDLE;
    FLUSH_BE    :   flush_next_state[4:0] = FLUSH_IDLE;
    default     :   flush_next_state[4:0] = FLUSH_IDLE;
  endcase
end

//----------------------------------------------------------
//                   Control Siganls
//----------------------------------------------------------
assign retire_flush_is  = flush_cur_state[1];

assign retire_flush_fe  = flush_cur_state[2];

assign retire_flush_be  = flush_cur_state[4];

assign rtu_ifu_flush    = retire_flush_fe;

assign rtu_idu_flush_fe = retire_flush_fe;

assign rtu_iu_flush_fe  = retire_flush_fe;

assign rtu_idu_flush_is = retire_flush_is;

assign rtu_lsu_flush_fe = retire_flush_fe
                       || retire_flush_is;

assign rtu_yy_xx_flush  = retire_flush_be;
assign retire_rob_flush = retire_inst0_flush
                          //|| retire_inst0_mispred       //when a mispred retire, rtu_ck_flush and retire_rob_flush will set to 1 at same time. ck_flush@LTL
                          || retire_flush_is
                          || retire_flush_fe;

assign retire_rob_flush_gateclk  = retire_inst0_flush_gateclk
                                   || retire_flush_is
                                   || retire_flush_fe;

assign retire_flush_sm_no_idle   = !flush_cur_state[0];

assign rtu_idu_flush_stall       = retire_flush_sm_no_idle;
//mask iu change flow on wrong path during flush state machine
//when mispred iu will mask wrong path change flow by itself
assign rtu_iu_flush_chgflw_mask  = retire_flush_sm_no_idle;

assign retire_rob_flush_cur_state[4:0] = flush_cur_state[4:0];

//----------------------------------------------------------
//                   Asynchronous Flush
//----------------------------------------------------------
//when sync flush, lsu entry do not flush commit inst, but
//lsu pipeline flush inst without considering its commit state
//when async flush, the committed lsu inst may die when flushed
//at lsu pipeline while not flushed in lsu entry
//so add async flush to flush lsu entry committed inst
//force flush state machine to flush fe and be state
//force pst preg all wb
//force async expt to idle
//the async expt will not interrupt commit inst execute in lsu
//so do not need async lsu flush
assign async_flush           = halt_req_dm_async;

always @(posedge retire_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    async_flush_ff <= 1'b0;
  else
    async_flush_ff <= async_flush;
end

assign retire_pst_async_flush = async_flush_ff;
assign rtu_lsu_async_flush    = async_flush_ff;

//----------------------------------------------------------
//                    Flush Expt
//----------------------------------------------------------
//rtu should signal lsu whether flush is triggered by
//1. expt, include expt, int and async expt
//2. exception return, include rte/rfi
//available only when flush
always @(posedge sm_clk or negedge cpurst_b)
begin
  if(!cpurst_b) begin
    flush_expt        <= 1'b0;
    flush_eret        <= 1'b0;
    flush_spec_fail   <= 1'b0;
  end
  else if(retire_inst0_flush) begin
    flush_expt        <= retire_ifu_expt_vld;
    flush_eret        <= rob_retire_inst0_efpc_vld;
    flush_spec_fail   <= rob_retire_inst0_spec_fail;
  end
  else if(retire_flush_be) begin
    flush_expt        <= 1'b0;
    flush_eret        <= 1'b0;
    flush_spec_fail   <= 1'b0;
  end
  else begin
    flush_expt        <= flush_expt;
    flush_eret        <= flush_eret;
    flush_spec_fail   <= flush_spec_fail;
  end 
end

assign rtu_lsu_expt_flush      = flush_expt;
assign rtu_lsu_eret_flush      = flush_eret;
assign rtu_lsu_spec_fail_flush = flush_spec_fail;

//----------------------------------------------------------
//                      Spec fail IID
//----------------------------------------------------------
always @(posedge sm_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    spec_fail_iid[IID_WIDTH - 1:0] <= {IID_WIDTH{1'b0}};
  else if(async_flush)
    spec_fail_iid[IID_WIDTH - 1:0] <= {IID_WIDTH{1'b0}};
  else if(retire_inst0_normal_retire && rob_retire_inst0_spec_fail_no_ssf)
    spec_fail_iid[IID_WIDTH - 1:0] <= rob_retire_inst0_iid[IID_WIDTH - 1:0];
  else if(retire_inst0_normal_retire && rob_retire_inst0_spec_fail_ssf)
    spec_fail_iid[IID_WIDTH - 1:0] <= rob_retire_ssf_iid[IID_WIDTH - 1:0];
  else
    spec_fail_iid[IID_WIDTH - 1:0] <= spec_fail_iid[IID_WIDTH - 1:0];
end

assign rtu_lsu_spec_fail_iid[IID_WIDTH - 1:0] = spec_fail_iid[IID_WIDTH - 1:0];

//==========================================================
//                  Asynchronous Exception
//==========================================================
parameter AE_IDLE = 2'b00;
parameter AE_WFC  = 2'b01;
parameter AE_WFI  = 2'b10;
parameter AE_EXPT = 2'b11;

//----------------------------------------------------------
//              Prepare state machine signals
//----------------------------------------------------------
assign retire_async_expt           = lsu_rtu_async_expt_vld
                                     && !dbg_mode_on;
 // no_commit increase to 6. dhw@20241218                                    
assign retire_async_expt_no_commit = !( rob_retire_commit0
                                     || rob_retire_commit1
                                     || rob_retire_commit2
                                     || rob_retire_commit3
                                     || rob_retire_commit4
                                     || rob_retire_commit5);
// no_retire increase to 6. dhw@20241218
assign retire_async_expt_no_retire = !( rob_retire_inst0_vld
                                     || rob_retire_inst1_vld
                                     || rob_retire_inst2_vld
                                     || rob_retire_inst3_vld
                                     || rob_retire_inst4_vld
                                     || rob_retire_inst5_vld
                                     || retire_flush_sm_no_idle
                                     || !pst_retire_retired_reg_wb);
//                                     || ifu_rtu_vec_addr_not_fetched);

//----------------------------------------------------------
//                 Save physical address
//----------------------------------------------------------
always @(posedge sm_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    ae_phy_addr[`WK_PA_WIDTH-1:0] <= {`WK_PA_WIDTH{1'b0}};
  else if(lsu_rtu_async_expt_vld)
    ae_phy_addr[`WK_PA_WIDTH-1:0] <= lsu_rtu_async_expt_addr[`WK_PA_WIDTH-1:0];
  else
    ae_phy_addr[`WK_PA_WIDTH-1:0] <= ae_phy_addr[`WK_PA_WIDTH-1:0];
end

//----------------------------------------------------------
//                    FSM of Async Expt
//----------------------------------------------------------
// State Description:
// AE_IDLE    : no asynchronous exception or LSU trigger async expt
// AE_WFC     : wait for commiting inst retire, stop new inst commit
// AE_WFI     : stop rob retire entry valid, wait for retire inst 0/1/2
//              not valid and FLUSH state machine IDLE and ifu fetch vec addr
// AE_EXPT    : signal IFU expt valid, trigger FLUSH state machine

always @(posedge sm_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    ae_cur_state[1:0] <= AE_IDLE;
  else if(async_flush)
    ae_cur_state[1:0] <= AE_IDLE;
  else
    ae_cur_state[1:0] <= ae_next_state[1:0];
end

always @( ae_cur_state[1:0]
       or retire_async_expt_no_retire
       or retire_async_expt
       or retire_async_expt_no_commit)
begin
  case(ae_cur_state[1:0])
    AE_IDLE    : if(retire_async_expt)
                   ae_next_state[1:0] = AE_WFC;
                 else
                   ae_next_state[1:0] = AE_IDLE;
    AE_WFC     : if(retire_async_expt_no_commit)
                   ae_next_state[1:0] = AE_WFI;
                 else
                   ae_next_state[1:0] = AE_WFC;
    AE_WFI     : if(retire_async_expt_no_retire)
                   ae_next_state[1:0] = AE_EXPT;
                 else
                   ae_next_state[1:0] = AE_WFI;
    AE_EXPT    :   ae_next_state[1:0] = AE_IDLE;
    default    :   ae_next_state[1:0] = AE_IDLE;
  endcase
end

//----------------------------------------------------------
//                   Control Siganls
//----------------------------------------------------------
assign retire_async_expt_sm_no_idle      = (ae_cur_state[1:0] != AE_IDLE);
//stop new inst commit, do not stop existent commit
assign retire_rob_async_expt_commit_mask = (ae_cur_state[1:0] == AE_WFC);
//stop rob retire new inst
assign retire_rob_rt_mask                = (ae_cur_state[1:0] == AE_WFI);
//async expt valid will flush rob, including commit
assign retire_async_expt_vld             = (ae_cur_state[1:0] == AE_EXPT);
//access error
assign retire_async_expt_vec[5:0]        = 6'd5;

assign retire_top_ae_cur_state[1:0]      = ae_cur_state[1:0];

//==========================================================
//                       CTC Flush
//==========================================================
//when lsu request ctc flush, rtu should req sync flush to
//rob read0 inst like int, ctc flush req should be clear when
//flush fe generated by ctc flush req or other rtu flush request.
//cannot use flush be because mispred may flush fe before ctc flush
//request, ctc flush req may be clear after mispred
assign retire_ctc_flush_lsu_req     = lsu_rtu_ctc_flush_vld;

always @(posedge sm_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    retire_ctc_flush_req <= 1'b0;
  else if(retire_ctc_flush_lsu_req)
    retire_ctc_flush_req <= 1'b1;
  else if(retire_flush_fe)
    retire_ctc_flush_req <= 1'b0;
  else
    retire_ctc_flush_req <= retire_ctc_flush_req;
end

assign retire_rob_ctc_flush_req = retire_ctc_flush_req;

//==========================================================
//                  Retire Empty Signals
//==========================================================
assign retire_rob_retire_empty = lsu_rtu_all_commit_data_vld;


//==========================================================
//                  Risc-V Debug zdb Begin
//==========================================================

//----------------------------------------------------------
//                    Debug Interface
//----------------------------------------------------------
//debug can ONLY hit retire inst 0
assign retire_have_debug_req = dtu_rtu_sync_halt_req  |
                               dtu_rtu_group_halt_req |
                               dtu_rtu_sync_flush     |
                               dtu_rtu_resume_req;
always @ (posedge retire_clk or negedge cpurst_b)
begin 
  if (~cpurst_b) begin
    retire_have_debug_req_f    <= 1'b0;
    retire_dtu_sync_halt_req   <= 1'b0;
    retire_dtu_group_halt_req  <= 1'b0;
    retire_dtu_sync_flush      <= 1'b0;
    retire_dtu_resume_req      <= 1'b0;
  end
  else if (retire_have_debug_req | retire_have_debug_req_f) begin
    retire_have_debug_req_f    <= retire_have_debug_req;
    retire_dtu_sync_halt_req   <= dtu_rtu_sync_halt_req;
    retire_dtu_group_halt_req  <= dtu_rtu_group_halt_req;
    retire_dtu_sync_flush      <= dtu_rtu_sync_flush;
    retire_dtu_resume_req      <= dtu_rtu_resume_req;
  end
end

assign dbg_req_en = dtu_rtu_sync_halt_req |
                    dtu_rtu_group_halt_req |
                    dtu_rtu_sync_flush |
                    dtu_rtu_async_halt_req;
assign retire_rob_dbg_req_en = dbg_req_en;

//haltinfo from expt entry
assign rob_retire_halt_info[`TDT_MP_HINFO_WIDTH-1:0] = rob_retire_inst0_haltinfo [`TDT_MP_HINFO_WIDTH-1:0];

//----------------------------------------------------------
//               TEE Debug Extension
//----------------------------------------------------------

//----------------------------------------------------------
//                   Debug Enable
//----------------------------------------------------------
//inst can enter debug:
//  1. mdbgen = 1 
//  2. mdbgen = 0 & pm != m mode & zdbgen
//if inst can't enter debug, it will set pending.
//debug en now in dtu.   

// // --------Zone Debug Enable----------------------------
// zone dbg enable in DTU
assign retire_mmode_dbg = dtu_rtu_mdbgen;

assign retire_dbg_mode[1:0] = retire_mmode_dbg ? 2'b11
                                               : 2'b01;

//---------------------------------------------------------
//                 Debug Hit: Timing 0
//---------------------------------------------------------
assign hit_ebreak     = rob_retire_inst0_vld
                      & rob_retire_inst0_ebreak;
assign hit_trigger_t0 = (rob_retire_inst0_vld | retire_inst0_cancel)
                      & rob_retire_halt_info[`TDT_MP_HINFO_MATCH]
                      & ~rob_retire_halt_info[`TDT_MP_HINFO_TIMING]
                      & ~rob_retire_halt_info[`TDT_MP_HINFO_PENDING_HALT];
assign hit_pending    = rob_retire_inst0_vld
                      & rob_retire_halt_info[`TDT_MP_HINFO_PENDING_HALT];

//---------------------------------------------------------
//                 Debug Hit: Timing 1
//---------------------------------------------------------
assign t1_retire_vld  = rob_retire_inst0_vld
                      & ~rob_retire_halt_info[`TDT_MP_HINFO_PENDING_HALT]
                      & ~halt_req;
assign hit_trigger_t1 = t1_retire_vld
                      & rob_retire_halt_info[`TDT_MP_HINFO_MATCH]
                      & rob_retire_halt_info[`TDT_MP_HINFO_TIMING];
//---------------------------------------------------------
//            Halt Request: Timing 0
//---------------------------------------------------------
// t0 halt request will enter debug mode when not in debug mode
assign halt_req_reset      = ifu_rtu_reset_halt_req;
assign halt_req_dm_async   = dtu_rtu_async_halt_req;
assign halt_req_ebreak     = hit_ebreak
                           & dtu_rtu_ebreak_action
                           & ~dbg_mode_on_after_req;
assign halt_req_trigger_t0 = hit_trigger_t0
                           & rob_retire_halt_info[`TDT_MP_HINFO_ACTION1]
                           & ~rob_retire_halt_info[`TDT_MP_HINFO_ACTION0]
                           & ~dbg_mode_on_after_req;
assign halt_req_pending    = hit_pending
                           & rob_retire_halt_info[`TDT_MP_HINFO_ACTION1]
                           & ~rob_retire_halt_info[`TDT_MP_HINFO_ACTION0]
                           & ~dbg_mode_on_after_req;

assign halt_req_trigger_t0_action01 = hit_trigger_t0
                                    & rob_retire_halt_info[`TDT_MP_HINFO_ACTION1]
                                    & rob_retire_halt_info[`TDT_MP_HINFO_ACTION0]    
                                    & ~dbg_mode_on_after_req;
//t0 halt request
assign halt_req             = halt_req_reset        // *
                            | halt_req_dm_async
                            | halt_req_ebreak
                            | halt_req_trigger_t0
                            | halt_req_pending;

assign halt_req_for_int     = halt_req | halt_req_trigger_t0_action01;
//----------------------------------------------------------
//         Halt Request: Timing 1
//----------------------------------------------------------
// t1 halt will cause flush but not affect expt/int
// t1 halt request will be masked:
//   1. pending halt
//   2. pending expt
//   3. in debug expt
//   4. ack t0 halt request

assign halt_req_dm_sync        = t1_retire_vld
                               & retire_dtu_sync_halt_req
                               & ~rob_retire_inst0_dbg_disable
                               & ~rob_retire_inst0_split;
assign halt_req_group          = t1_retire_vld
                               & retire_dtu_group_halt_req
                               & ~rob_retire_inst0_dbg_disable
                               & ~rob_retire_inst0_split;
assign halt_req_trigger_t1     = hit_trigger_t1
                               & rob_retire_halt_info[`TDT_MP_HINFO_ACTION1]
                               & ~rob_retire_halt_info[`TDT_MP_HINFO_ACTION0];

assign halt_req_trigger_t1_action01   = hit_trigger_t1
                                      & rob_retire_halt_info[`TDT_MP_HINFO_ACTION1]
                                      & rob_retire_halt_info[`TDT_MP_HINFO_ACTION0];

// t1 halt request will generate inst flush and signal dtu pending halt
assign halt_req_t1_raw         = (halt_req_dm_sync
                                | halt_req_group
                                | halt_req_trigger_t1)
                                & ~dbg_mode_on_after_req;
assign halt_req_t1             = halt_req_t1_raw
                               & ~bkpt_req_t1;       

//---------------------------------------------------------
//       Bkpt Expt Request: Timing 0
//---------------------------------------------------------
// ebreak dont care about dbgen.
assign bkpt_req_ebreak         = hit_ebreak
                               & ~dtu_rtu_ebreak_action;
// req_pending dont care about dbgen to clear pending.
assign bkpt_req_pending        = hit_pending
                               & rob_retire_halt_info[`TDT_MP_HINFO_ACTION0];
assign bkpt_req_trigger_t0     = hit_trigger_t0
                               & rob_retire_halt_info[`TDT_MP_HINFO_ACTION0];

// pending bkpt ack need not to use dbgen.
// however, expt judge need use dbgen to mask pending bkpt.
assign bkpt_req_trigger_t0_lsu = bkpt_req_trigger_t0
                               & rob_retire_halt_info[`TDT_MP_HINFO_LDST];
assign bkpt_req_trigger_t0_ifu = bkpt_req_trigger_t0
                               & ~rob_retire_halt_info[`TDT_MP_HINFO_LDST];

//---------------------------------------------------------
//       Bkpt Expt Request: Timing 1
//---------------------------------------------------------
// t1 halt request will be masked by:
//   1. pending halt
//   2. pending expt
//   3. t0 halt request
assign bkpt_req_trigger_t1    = hit_trigger_t1
                              & rob_retire_halt_info[`TDT_MP_HINFO_ACTION0];
assign bkpt_req_t1            = bkpt_req_trigger_t1; 

//assign retire_bkpt_expt_t1 = bkpt_req_trigger_t1;
assign bkpt_req_trigger_t1_lsu = bkpt_req_trigger_t1
                               & rob_retire_halt_info[`TDT_MP_HINFO_LDST];

//----------------------------------------------------------
//              Debug Sync Flush
//----------------------------------------------------------
//dtu will flush cpu when step and icount set.
assign retire_debug_step_flush = rob_retire_inst0_vld
                               & retire_dtu_sync_flush
                               & ~rob_retire_inst0_dbg_disable
                               & ~rob_retire_inst0_split
                               & ~dbg_mode_on_after_req;

//----------------------------------------------------------
//              Exit Debug Mode
//----------------------------------------------------------
assign retire_exit_debug_raw  = dbg_mode_on_after_req
                              & (retire_dtu_resume_req |
                                 rob_retire_inst0_vld & rob_retire_inst0_dret);

always @ (posedge retire_clk or negedge cpurst_b)
begin
  if (~cpurst_b)
    retire_exit_debug <= 1'b0;
  else if (retire_exit_debug)
    retire_exit_debug <= 1'b0;
  else if (dbg_mode_on_after_req)
    retire_exit_debug <= retire_exit_debug_raw;
end
assign retire_rob_exit_debug = retire_exit_debug;

//----------------------------------------------------------
//                 Cause Select
//----------------------------------------------------------
//select cause according to priority
//not includes itrigger and etrigger, which fire in dtu

//halt_req_group has higher priority than
//halt_req_trigger_t1 and halt_req_dm_sync
// &CombBeg; @850
always @*
begin
  if(halt_req_dm_async)
    halt_cause[3:0] = 4'd8;
  else if(halt_req_pending)
    halt_cause[3:0] = rob_retire_halt_info[`TDT_MP_HINFO_CAUSE:`TDT_MP_HINFO_CAUSE-3];
  else if(halt_req_trigger_t0 | halt_req_trigger_t0_action01)
    halt_cause[3:0] = 4'd2;
  else if(halt_req_ebreak)
    halt_cause[3:0] = 4'd1;
  else if(halt_req_reset)
    halt_cause[3:0] = 4'd5;
  else if(halt_req_group)
    halt_cause[3:0] = 4'd6;
  else if(halt_req_trigger_t1 | halt_req_trigger_t1_action01)
    halt_cause[3:0] = 4'd2; 
  else if(halt_req_dm_sync)
    halt_cause[3:0] = 4'd3;
  else //halt_req_step
    halt_cause[3:0] = 4'd4;
// &CombEnd; @869
end

//----------------------------------------------------------
//                 Debug Mode
//----------------------------------------------------------
//debug mode on after request;
//used to mask ifu inst fetch and new halt request
always @ (posedge retire_clk or negedge cpurst_b)
begin
  if (~cpurst_b)
    dbg_mode_on_after_req <= 1'b0;
  else if (halt_req)
    dbg_mode_on_after_req <= 1'b1;
  else if (retire_exit_debug)
    dbg_mode_on_after_req <= 1'b0;
end

assign retire_enter_debug       = retire_flush_be & dbg_mode_on_after_req & ~dbg_mode_on;

//assign retire_enter_debug_gate = retire_flush_done & dbg_mode_on_after_req;

//debug mode on after flush be:
//indicate hart is in halt
always @ (posedge retire_clk or negedge cpurst_b)
begin
  if (~cpurst_b)
    dbg_mode_on <= 1'b0;
  else if (retire_enter_debug)
    dbg_mode_on <= 1'b1;
  else if (retire_exit_debug)
    dbg_mode_on <= 1'b0;
end

// assign rtu_pad_halted  = dbg_mode_on;

//----------------------------------------------------------
//                 Retire Halt Info
//----------------------------------------------------------
// &CombBeg; @911
always @*
begin
  retire_halt_info[`TDT_MP_HINFO_WIDTH-1:0]      = rob_retire_halt_info[`TDT_MP_HINFO_WIDTH-1:0];
  if (1) begin 
    retire_halt_info[`TDT_MP_HINFO_ACTION1]      = halt_req | halt_req_t1_raw
                                                 | rob_retire_halt_info[`TDT_MP_HINFO_ACTION1];
    retire_halt_info[`TDT_MP_HINFO_ACTION0]      = rob_retire_halt_info[`TDT_MP_HINFO_ACTION0];
    retire_halt_info[`TDT_MP_HINFO_PENDING_HALT] = halt_req_t1 | bkpt_req_t1;
    retire_halt_info[`TDT_MP_HINFO_CAUSE-:4]     = halt_cause[3:0];
  end
// &CombEnd; @920
end

//----------------------------------------------------------
//                  Halt TVAL
//----------------------------------------------------------
// &CombBeg; @925

always @*
begin
//if load/store mcontrol, updata load/store address
if(bkpt_req_trigger_t1_lsu)
  retire_dtval[63:0] = retire_sync_tval[63:0];
//otherwise update cur pc
else if (cp0_yy_mmu_en)
  retire_dtval[63:0] = {{(64-`WK_PC_LEN-1){1'b0}}, rob_retire_inst0_cur_pc[`WK_PC_LEN-1:0], 1'b0};
else
  retire_dtval[63:0] = {{(64-`WK_PC_LEN-1){1'b0}}, rob_retire_inst0_cur_pc[`WK_PC_LEN-1:0], 1'b0};
// &CombEnd; @934
end

//----------------------------------------------------------
//                  Halt DPC
//----------------------------------------------------------
// &Force("bus","rob_retire_rob_cur_pc",63,0); @939

assign retire_dpc[`WK_PC_LEN-2:0] = {rob_retire_inst0_cur_pc[`WK_PC_LEN-2:0]};

assign retire_dpc[63:`WK_PC_LEN-1] = cp0_yy_mmu_en ? 
                                      {(64-`WK_PC_LEN+1){rob_retire_inst0_cur_pc[`WK_PC_LEN-1]}}
                                    : {(64-`WK_PC_LEN+1){1'b0}};

//----------------------------------------------------------
//                 Expt in Debug On
//----------------------------------------------------------
assign retire_debug_expt_vld = rob_retire_inst0_vld
                             & dbg_mode_on
                             & retire_debug_expt;

//----------------------------------------------------------
//                 DTU Interface
//----------------------------------------------------------
assign rtu_dtu_retire0_halt_info[`TDT_MP_HINFO_WIDTH-1:0] = retire_halt_info[`TDT_MP_HINFO_WIDTH-1:0];
assign rtu_dtu_dpc[63:0]                             = retire_dpc[63:0];
assign rtu_dtu_tval[63:0]                            = retire_dtval[63:0];

assign rtu_dtu_halt_ack                              = halt_req;
assign rtu_dtu_pending_ack                           = halt_req_pending
                                                     | bkpt_req_pending
                                                     | halt_req_dm_async;

assign rtu_dtu_retire0_vld                           = rob_retire_inst0_vld;
assign rtu_dtu_retire0_split                         = rob_retire_inst0_split;
assign rtu_dtu_retire_debug_expt_vld                 = retire_debug_expt_vld;
assign rtu_dtu_retire0_mret                          = rob_retire_inst0_vld
                                                      & rob_retire_inst0_mret;
assign rtu_dtu_retire0_mret_gateclk                  = rtu_dtu_retire0_mret;
assign rtu_dtu_retire0_sret                          = rob_retire_inst0_vld
                                                      & rob_retire_inst0_sret;
// &Force("output","rtu_dtu_retire0_mret"); @973

// for PCFIFO
assign rtu_dtu_retire0_chgflw_vld           = retire_inst0_normal_retire
                                             & rob_retire_inst0_bju;
assign rtu_dtu_retire1_chgflw_vld           = retire_inst1_normal_retire
                                             & rob_retire_inst1_bju;
assign rtu_dtu_retire2_chgflw_vld           = retire_inst2_normal_retire
                                             & rob_retire_inst2_bju;
assign rtu_dtu_retire3_chgflw_vld           = retire_inst3_normal_retire
                                             & rob_retire_inst3_bju;
assign rtu_dtu_retire4_chgflw_vld           = retire_inst4_normal_retire
                                             & rob_retire_inst4_bju;
assign rtu_dtu_retire5_chgflw_vld           = retire_inst5_normal_retire
                                             & rob_retire_inst5_bju;
assign rtu_dtu_retire_chgflw_gateclk_vld    = rob_retire_inst0_vld & rob_retire_inst0_bju
                                            | rob_retire_inst1_vld & rob_retire_inst1_bju                                            
                                            | rob_retire_inst2_vld & rob_retire_inst2_bju
                                            | rob_retire_inst3_vld & rob_retire_inst3_bju
                                            | rob_retire_inst4_vld & rob_retire_inst4_bju
                                            | rob_retire_inst5_vld & rob_retire_inst5_bju;

assign rtu_dtu_retire0_chgflw_pc[`WK_PC_LEN-1:0]    = rob_retire_inst0_next_pc[`WK_PC_LEN-1:0];
assign rtu_dtu_retire1_chgflw_pc[`WK_PC_LEN-1:0]    = rob_retire_inst1_next_pc[`WK_PC_LEN-1:0];
assign rtu_dtu_retire2_chgflw_pc[`WK_PC_LEN-1:0]    = rob_retire_inst2_next_pc[`WK_PC_LEN-1:0];
assign rtu_dtu_retire3_chgflw_pc[`WK_PC_LEN-1:0]    = rob_retire_inst3_next_pc[`WK_PC_LEN-1:0];
assign rtu_dtu_retire4_chgflw_pc[`WK_PC_LEN-1:0]    = rob_retire_inst4_next_pc[`WK_PC_LEN-1:0];
assign rtu_dtu_retire5_chgflw_pc[`WK_PC_LEN-1:0]    = rob_retire_inst5_next_pc[`WK_PC_LEN-1:0];

//----------------------------------------------------------
//                 RTU to CP0
//----------------------------------------------------------

assign rtu_cp0_enter_debug    = retire_enter_debug;
assign rtu_cp0_exit_debug     = retire_exit_debug;
assign rtu_cp0_dbg_pm[1:0]    = retire_dbg_mode[1:0];

//-----------------------------------------------------------
//           yy xx Exception Interrupt Output
//-----------------------------------------------------------
assign rtu_yy_xx_expt_vld       = (retire_expt_vld || retire_async_expt_vld)
                                & ~dbg_mode_on
                                & ~halt_req;

assign rtu_yy_xx_expt_int       = retire_expt_int;

assign retire_tval_use_pipeline = rob_retire_inst0_expt_vec[3:0] == 4'd1
                                | rob_retire_inst0_expt_vec[3:0] == 4'd2
                                | rob_retire_inst0_expt_vec[3:0] == 4'd3                                 
                                | rob_retire_inst0_expt_vec[3:0] == 4'd4
                                | rob_retire_inst0_expt_vec[3:0] == 4'd5
                                | rob_retire_inst0_expt_vec[3:0] == 4'd6
                                | rob_retire_inst0_expt_vec[3:0] == 4'd7
                                | rob_retire_inst0_expt_vec[3:0] == 4'd12
                                | rob_retire_inst0_expt_vec[3:0] == 4'd13
                                | rob_retire_inst0_expt_vec[3:0] == 4'd15
                                | bkpt_req_trigger_t0_lsu;

assign retire_sync_tval[63:0]   = {{63-`WK_PA_WIDTH{1'b0}}, rob_retire_inst0_mtval[`WK_PA_WIDTH:0]}; //  high 24bits of physical addr have been masked to 0 in LSU
assign retire_expt_pc_high_hw_expt[63:0] = rob_retire_inst0_cur_pc + 64'd2;   

//----------------------------------------------------------
//                 Prepare Interrupt Source
//----------------------------------------------------------
assign retire_pending_bkpt_expt = bkpt_req_pending;

//==========================================================
//                  Risc-V Debug zdb End
//==========================================================

endmodule


