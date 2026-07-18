//-----------------------------------------------------------------------------
// File          : wk_lsu_ctrl.v
// Created       : 2024/10/12 (by Wen Jiahui)
// Last modified : 2024/10/12 (by Wen Jiahui)
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
// 2024/10/12 : Created
// 2024/XX/XX : 
//-----------------------------------------------------------------------------

//#
//# Module Declaration
//# ==================
//#
module xx_lsu_ctrl#(
    parameter LSIQENTRY=16
)(
input   logic  [1:0]                    cp0_lsu_dcache_pref_dist,
input   logic                           cp0_lsu_icg_en,
input   logic  [1:0]                    cp0_lsu_l2_pref_dist,
input   logic                           forever_cpuclk,
input   logic                           cpurst_b,
input   logic                           dcache_ldc_ex2_borrow_vld_gate,
input   logic                           dcache_lsdc_ex2_borrow_vld_gate,
input   logic                           hpcp_lsu_cnt_en,
input   logic                           icc_vb_create_gateclk_en,
input   logic                           idu_lsu0_rf1_gateclk_sel,
// input   logic                   idu_lsu1_rf1_gateclk_sel,
input   logic                           idu_lsu2_rf1_gateclk_sel,
input   logic                           idu_lsu3_rf1_gateclk_sel,
input   logic                           idu_lsu0_rf1_sel,
// input   logic                   idu_lsu1_rf1_sel,
input   logic                           idu_lsu2_rf1_sel,
input   logic                           idu_lsu3_rf1_sel,
input   logic                           idu_lsu0_rf1_older_vld, // wjh@timing
input   logic                           idu_lsu2_rf1_older_vld, // wjh@timing
input   logic                           idu_lsu3_rf1_older_vld, // wjh@timing
input   logic                           idu_lsu4_rf1_gateclk_sel,
input   logic                           idu_lsu5_rf1_gateclk_sel,
input   logic                           idu_lsu_vmb_create0_gateclk_en,
input   logic                           idu_lsu_vmb_create1_gateclk_en,
input   logic                           lag0_ex1_inst_vld,
input   logic                           lag0_ex1_stall_ori,
input   logic  [LSIQENTRY-1:0]          lag0_ex1_stall_restart_entry,
// input   logic                   lag1_ex1_inst_vld,
// input   logic                   lag1_ex1_stall_ori,
// input   logic  [LSIQENTRY-1:0]  lag1_ex1_stall_restart_entry,
// lda0,
input   logic                           lda0_ex3_borrow_vld,
input   logic  [LSIQENTRY-1:0]          lda0_ex3_ecc_wakeup,
input   logic  [LSIQENTRY-1:0]          lda0_idu_ex3_already_da,
input   logic  [LSIQENTRY-1:0]          lda0_idu_ex3_boundary_gateclk_en,
input   logic  [LSIQENTRY-1:0]          lda0_idu_ex3_pop_entry,
input   logic                           lda0_idu_ex3_pop_vld,
input   logic  [LSIQENTRY-1:0]          lda0_idu_ex3_rb_full,
input   logic  [LSIQENTRY-1:0]          lda0_idu_ex3_secd,
input   logic  [LSIQENTRY-1:0]          lda0_idu_ex3_us_restart,
input   logic  [LSIQENTRY-1:0]          lda0_idu_ex3_spec_fail,
input   logic  [LSIQENTRY-1:0]          lda0_idu_ex3_wait_fence,
input   logic                           lda0_ex3_inst_vld,
input   logic                           lda0_ex3_rb_full_gateclk_en,
input   logic                           lda0_ex3_special_gateclk_en,
input   logic                           lda0_ex3_wait_fence_gateclk_en,
// lda1,
// input   logic  [LSIQENTRY-1:0]  lda1_ex3_ecc_wakeup,
// input   logic  [LSIQENTRY-1:0]  lda1_idu_ex3_already_da,
// input   logic  [LSIQENTRY-1:0]  lda1_idu_ex3_boundary_gateclk_en,
// input   logic  [LSIQENTRY-1:0]  lda1_idu_ex3_pop_entry,
// input   logic                   lda1_idu_ex3_pop_vld,
// input   logic  [LSIQENTRY-1:0]  lda1_idu_ex3_rb_full,
// input   logic  [LSIQENTRY-1:0]  lda1_idu_ex3_secd,
// input   logic  [LSIQENTRY-1:0]  lda1_idu_ex3_spec_fail,
// input   logic  [LSIQENTRY-1:0]  lda1_idu_ex3_wait_fence,
// input   logic                   lda1_ex3_inst_vld,
// input   logic                   lda1_ex3_rb_full_gateclk_en,
// input   logic                   lda1_ex3_special_gateclk_en,
// input   logic                   lda1_ex3_wait_fence_gateclk_en,
// ldc0 lw0,
input   logic                           ldc0_ex2_borrow_vld,
input   logic  [LSIQENTRY-1:0]          ldc0_idu_ex2_lq_full,
input   logic  [LSIQENTRY-1:0]          ldc0_idu_ex2_tlb_busy,
input   logic  [LSIQENTRY-1:0]          ldc0_ex2_imme_wakeup,
input   logic                           ldc0_ex2_inst_vld,
input   logic                           ldc0_ex2_lq_full_gateclk_en,
input   logic                           ldc0_ex2_tlb_busy_gateclk_en,
input   logic                           lwb0_ex4_data_vld,
input   logic                           lwb0_ex4_inst_vld,
// ldc1 lw1,
// input   logic  [LSIQENTRY-1:0]  ldc1_idu_ex2_lq_full,
// input   logic  [LSIQENTRY-1:0]  ldc1_idu_ex2_tlb_busy,
// input   logic  [LSIQENTRY-1:0]  ldc1_ex2_imme_wakeup,
// input   logic                   ldc1_ex2_inst_vld,
// input   logic                   ldc1_ex2_lq_full_gateclk_en,
// input   logic                   ldc1_ex2_tlb_busy_gateclk_en,
// input   logic                   lwb1_ex4_data_vld,
// input   logic                   lwb1_ex4_inst_vld,
// end,
input   logic  [LSIQENTRY-1:0]          lfb_depd_wakeup0,
// input   logic  [LSIQENTRY-1:0]  lfb_depd_wakeup1,
input   logic  [LSIQENTRY-1:0]          lfb_depd_wakeup2,
input   logic  [LSIQENTRY-1:0]          lfb_depd_wakeup3,
input   logic                           lfb_empty,
input   logic                           lfb_has_pend,
input   logic  [`WK_PA_WIDTH-1:0]       lfb_pend_addr_f,
input   logic                           lfb_pend_page_ca_f,
input   logic                           lfb_pend_page_so_f,
input   logic                           lfb_pop_depd_ff,
input   logic                           lm_lfb_depd_wakeup0,
input   logic                           lm_lfb_depd_wakeup2,
input   logic                           lm_lfb_depd_wakeup3,
input   logic  [2 :0]                   lsu_had_amr_state,
input   logic  [1 :0]                   lsu_had_cdr_state,
input   logic  [5 :0]                   lsu_had_ctcq_entry_2_cmplt,
input   logic  [5 :0]                   lsu_had_ctcq_entry_cmplt,
input   logic  [5 :0]                   lsu_had_ctcq_entry_vld,
input   logic  [3 :0]                   lsu_had_icc_state,
input   logic  [7 :0]                   lsu_had_lfb_addr_entry_dcache_hit,
input   logic  [7 :0]                   lsu_had_lfb_addr_entry_rcl_done,
input   logic  [7 :0]                   lsu_had_lfb_addr_entry_vld,
input   logic  [1 :0]                   lsu_had_lfb_data_entry_last,
input   logic  [1 :0]                   lsu_had_lfb_data_entry_vld,
input   logic                           lsu_had_lfb_lf_sm_vld,
input   logic  [LSIQENTRY:0]            lsu_had_lfb_wakeup_queue,
input   logic  [2 :0]                   lsu_had_lm_state,
input   logic                           lsu_had_mcic_data_req,
input   logic                           lsu_had_mcic_frz,
input   logic  [7 :0]                   lsu_had_rb_entry_fence,
input   logic  [3 :0]                   lsu_had_rb_entry_state_0,
input   logic  [3 :0]                   lsu_had_rb_entry_state_1,
input   logic  [3 :0]                   lsu_had_rb_entry_state_2,
input   logic  [3 :0]                   lsu_had_rb_entry_state_3,
input   logic  [3 :0]                   lsu_had_rb_entry_state_4,
input   logic  [3 :0]                   lsu_had_rb_entry_state_5,
input   logic  [3 :0]                   lsu_had_rb_entry_state_6,
input   logic  [3 :0]                   lsu_had_rb_entry_state_7,
input   logic  [2 :0]                   lsu_had_sdb_entry_vld,
input   logic                           lsu_had_snoop_data_req,
input   logic                           lsu_had_snoop_tag_req,
input   logic  [5 :0]                   lsu_had_snq_entry_issued,
input   logic  [5 :0]                   lsu_had_snq_entry_vld,
input   logic                           lsu_had_sq_not_empty,
input   logic  [1 :0]                   lsu_had_vb_addr_entry_vld,
input   logic  [2 :0]                   lsu_had_vb_data_entry_vld,
input   logic  [3 :0]                   lsu_had_vb_rcl_sm_state,
input   logic                           lsu_had_wmb_aw_pending,
input   logic                           lsu_had_wmb_ar_pending,
input   logic  [7 :0]                   lsu_had_wmb_create_ptr,
input   logic  [7 :0]                   lsu_had_wmb_data_ptr,
input   logic  [7 :0]                   lsu_had_wmb_entry_vld,
input   logic  [7 :0]                   lsu_had_wmb_read_ptr,
input   logic                           lsu_had_wmb_w_pending,
input   logic                           lsu_had_wmb_write_imme,
input   logic  [7 :0]                   lsu_had_wmb_write_ptr,
input   logic                           lsu_has_fence,
// ld0 ls0,
input   logic                           lsu_hpcp_ld0_cache_access,
input   logic                           lsu_hpcp_ld0_cache_miss,
input   logic                           lsu_hpcp_ld0_cross_4k_stall,
input   logic                           lsu_hpcp_ld0_data_discard,
input   logic                           lsu_hpcp_ld0_discard_sq,
input   logic                           lsu_hpcp_ld0_other_stall,
input   logic                           lsu_hpcp_ld0_unalign_inst,
input   logic                           lsu_hpcp_ls0_ld_cache_access,
input   logic                           lsu_hpcp_ls0_ld_cache_miss,
input   logic                           lsu_hpcp_ls0_st_cache_access,
input   logic                           lsu_hpcp_ls0_st_cache_miss,
input   logic                           lsu_hpcp_ls0_cross_4k_stall,
input   logic                           lsu_hpcp_ls0_data_discard,
input   logic                           lsu_hpcp_ls0_discard_sq,
input   logic                           lsu_hpcp_ls0_other_stall,
input   logic                           lsu_hpcp_ls0_unalign_inst,
// ld1 ls1,
// input   logic                 lsu_hpcp_ld1_cache_access,
// input   logic                 lsu_hpcp_ld1_cache_miss,
// input   logic                 lsu_hpcp_ld1_cross_4k_stall,
// input   logic                 lsu_hpcp_ld1_data_discard,
// input   logic                 lsu_hpcp_ld1_discard_sq,
// input   logic                 lsu_hpcp_ld1_other_stall,
// input   logic                 lsu_hpcp_ld1_unalign_inst,
input   logic                           lsu_hpcp_ls1_ld_cache_access,
input   logic                           lsu_hpcp_ls1_ld_cache_miss,
input   logic                           lsu_hpcp_ls1_st_cache_access,
input   logic                           lsu_hpcp_ls1_st_cache_miss,
input   logic                           lsu_hpcp_ls1_cross_4k_stall,
input   logic                           lsu_hpcp_ls1_data_discard,
input   logic                           lsu_hpcp_ls1_discard_sq,
input   logic                           lsu_hpcp_ls1_other_stall,
input   logic                           lsu_hpcp_ls1_unalign_inst,
// lag0 lda0,
input   logic  [LSIQENTRY-1:0]          lag0_idu_ex1_wait_old,
input   logic                           lag0_idu_ex1_wait_old_gateclk_en,
input   logic  [LSIQENTRY-1:0]          lda0_idu_ex3_wait_old,
input   logic                           lda0_idu_ex3_wait_old_gateclk_en,
// lag1 lda1,
// input   logic  [LSIQENTRY-1:0]  lag1_idu_ex1_wait_old,
// input   logic                   lag1_idu_ex1_wait_old_gateclk_en,
// input   logic  [LSIQENTRY-1:0]  lda1_idu_ex3_wait_old,
// input   logic                   lda1_idu_ex3_wait_old_gateclk_en,
// lsag0 lsag1,
input   logic  [LSIQENTRY-1:0]          lsag0_idu_ex1_wait_old,
input   logic                           lsag0_idu_ex1_wait_old_gateclk_en,
input   logic  [LSIQENTRY-1:0]          lsag1_idu_ex1_wait_old,
input   logic                           lsag1_idu_ex1_wait_old_gateclk_en,
// lsda0 lsda1
input   logic  [LSIQENTRY-1:0]          lsda0_idu_ex3_wait_old,
input   logic                           lsda0_idu_ex3_wait_old_gateclk_en,
input   logic  [LSIQENTRY-1:0]          lsda1_idu_ex3_wait_old,
input   logic                           lsda1_idu_ex3_wait_old_gateclk_en,

// lda0,
input   logic                           lsu_lda0_data_inj_cmplt,
input   logic                           lsu_lda0_tag_inj_cmplt,
// lda1,
// input   logic                 lsu_lda1_data_inj_cmplt,
// input   logic                 lsu_lda1_tag_inj_cmplt,
// lsda0,
input   logic                           lsu_lsda0_data_inj_cmplt,
input   logic                           lsu_lsda0_tag_inj_cmplt,
// lsda1,
input   logic                           lsu_lsda1_data_inj_cmplt,
input   logic                           lsu_lsda1_tag_inj_cmplt,
// end,
input   logic  [LSIQENTRY-1:0]          mmu_lsu_tlb_wakeup,
input   logic  [LSIQENTRY-1:0]          mmu_lsu_async_wakeup0, // wjh@tmq
input   logic  [LSIQENTRY-1:0]          mmu_lsu_async_wakeup2, // wjh@tmq
input   logic  [LSIQENTRY-1:0]          mmu_lsu_async_wakeup3, // wjh@tmq
input   logic                           pad_yy_icg_scan_en,
input   logic                           pfu_lfb_create_gateclk_en,
input   logic                           pfu_part_empty,
input   logic                           rb_empty,
input   logic                           rb_has_pend,
// input   logic                   rb_ld_wb_cmplt_req,
input   logic                           arb_lwb0_rb_cmplt_req,
input   logic                           arb_lswb0_rb_cmplt_req,
input   logic                           arb_lswb1_rb_cmplt_req,
// input   logic                   rb_ld_wb_data_req,
input   logic                           arb_lwb0_rb_data_req,
input   logic                           arb_lswb0_rb_data_req,
input   logic                           arb_lswb1_rb_data_req,
input   logic  [`WK_PA_WIDTH-1:0]       rb_pend_addr_f,
input   logic                           rb_pend_page_ca_f,
input   logic                           rb_pend_page_so_f,
input   logic                           std0_ex1_inst_vld,
input   logic                           std1_ex1_inst_vld,
input   logic  [LSIQENTRY-1:0]          sq_data_depd_wakeup0,
// input   logic  [LSIQENTRY-1:0]  sq_data_depd_wakeup1,
input   logic  [LSIQENTRY-1:0]          sq_data_depd_wakeup2,
input   logic  [LSIQENTRY-1:0]          sq_data_depd_wakeup3,
input   logic                           sq_empty,
input   logic  [LSIQENTRY-1:0]          sq_global_depd_wakeup0,
// input   logic  [LSIQENTRY-1:0]  sq_global_depd_wakeup1,
input   logic  [LSIQENTRY-1:0]          sq_global_depd_wakeup2,
input   logic  [LSIQENTRY-1:0]          sq_global_depd_wakeup3,
// lsag0,
input   logic                           lsag0_ex1_inst_vld,
input   logic                           lsag0_ex1_stall_ori,
input   logic  [LSIQENTRY-1:0]          lsag0_ex1_stall_restart_entry,
// lsag1,
input   logic                           lsag1_ex1_inst_vld,
input   logic                           lsag1_ex1_stall_ori,
input   logic  [LSIQENTRY-1:0]          lsag1_ex1_stall_restart_entry,
// lsda0,
input   logic                           lsda0_ex3_borrow_vld,
input   logic  [LSIQENTRY-1:0]          lsda0_ex3_ecc_wakeup,
input   logic  [LSIQENTRY-1:0]          lsda0_idu_ex3_already_da,
input   logic  [LSIQENTRY-1:0]          lsda0_idu_ex3_boundary_gateclk_en,
input   logic  [LSIQENTRY-1:0]          lsda0_idu_ex3_pop_entry,
input   logic                           lsda0_idu_ex3_pop_vld,
input   logic  [LSIQENTRY-1:0]          lsda0_idu_ex3_rb_full,
input   logic  [LSIQENTRY-1:0]          lsda0_idu_ex3_secd,
input   logic  [LSIQENTRY-1:0]          lsda0_idu_ex3_us_restart,
input   logic  [LSIQENTRY-1:0]          lsda0_idu_ex3_spec_fail,
input   logic  [LSIQENTRY-1:0]          lsda0_idu_ex3_wait_fence,
input   logic                           lsda0_ex3_inst_vld,
input   logic                           lsda0_rb_ex3_create_gateclk_en,
input   logic                           lsda0_ex3_rb_full_gateclk_en,
input   logic                           lsda0_ex3_special_gateclk_en,
input   logic                           lsda0_ex3_wait_fence_gateclk_en,
// lsda1,
input   logic  [LSIQENTRY-1:0]          lsda1_ex3_ecc_wakeup,
input   logic  [LSIQENTRY-1:0]          lsda1_idu_ex3_already_da,
input   logic  [LSIQENTRY-1:0]          lsda1_idu_ex3_boundary_gateclk_en,
input   logic  [LSIQENTRY-1:0]          lsda1_idu_ex3_pop_entry,
input   logic                           lsda1_idu_ex3_pop_vld,
input   logic  [LSIQENTRY-1:0]          lsda1_idu_ex3_rb_full,
input   logic  [LSIQENTRY-1:0]          lsda1_idu_ex3_secd,
input   logic  [LSIQENTRY-1:0]          lsda1_idu_ex3_us_restart,
input   logic  [LSIQENTRY-1:0]          lsda1_idu_ex3_spec_fail,
input   logic  [LSIQENTRY-1:0]          lsda1_idu_ex3_wait_fence,
input   logic                           lsda1_ex3_inst_vld,
input   logic                           lsda1_rb_ex3_create_gateclk_en,
input   logic                           lsda1_ex3_rb_full_gateclk_en,
input   logic                           lsda1_ex3_special_gateclk_en,
input   logic                           lsda1_ex3_wait_fence_gateclk_en,
// lsdc0 lswb0,
input   logic                         lsdc0_ex2_borrow_vld,
input   logic  [LSIQENTRY-1:0]        lsdc0_idu_ex2_sq_full,
input   logic  [LSIQENTRY-1:0]        lsdc0_idu_ex2_lq_full,
input   logic  [LSIQENTRY-1:0]        lsdc0_idu_ex2_tlb_busy,
input   logic  [LSIQENTRY-1:0]        lsdc0_ex2_imme_wakeup,
input   logic                         lsdc0_ex2_inst_vld,
input   logic                         lsdc0_idu_ex2_sq_full_gateclk_en,
input   logic                         lsdc0_ex2_lq_full_gateclk_en,
input   logic                         lsdc0_ex2_tlb_busy_gateclk_en,
input   logic                         lswb0_ex4_inst_vld,
input   logic                         lswb0_ex4_data_vld,
// lsdc1 lswb1,
input   logic  [LSIQENTRY-1:0]        lsdc1_idu_ex2_sq_full,
input   logic  [LSIQENTRY-1:0]        lsdc1_idu_ex2_lq_full,
input   logic  [LSIQENTRY-1:0]        lsdc1_idu_ex2_tlb_busy,
input   logic  [LSIQENTRY-1:0]        lsdc1_ex2_imme_wakeup,
input   logic                         lsdc1_ex2_inst_vld,
input   logic                         lsdc1_idu_ex2_sq_full_gateclk_en,
input   logic                         lsdc1_ex2_lq_full_gateclk_en,
input   logic                         lsdc1_ex2_tlb_busy_gateclk_en,
input   logic                         lswb1_ex4_inst_vld,
input   logic                         lswb1_ex4_data_vld,
// end,
input   logic                         vb_empty,
input   logic                         vmb_empty,
// input   logic                   vmb_ld_wb_data_req,
input   logic                         arb_lwb0_vmb_data_req,
input   logic                         arb_lswb0_vmb_data_req,
input   logic                         arb_lswb1_vmb_data_req,
input   logic  [LSIQENTRY-1:0]        wmb_depd_wakeup0,
// input   logic  [LSIQENTRY-1:0]  wmb_depd_wakeup1,
input   logic  [LSIQENTRY-1:0]        wmb_depd_wakeup2,
input   logic  [LSIQENTRY-1:0]        wmb_depd_wakeup3,
input   logic                         wmb_empty,
input   logic                         wmb_has_pend,
// input   logic                         wmb_ld_wb_data_req,
input   logic                         arb_lwb0_wmb_data_req,
input   logic                         arb_lswb0_wmb_data_req,
input   logic                         arb_lswb1_wmb_data_req,
input   logic                         wmb_no_op,
input   logic  [`WK_PA_WIDTH-1:0]     wmb_pend_addr_f,
input   logic                         wmb_pend_page_ca_f,
input   logic                         wmb_pend_page_so_f,
// input   logic                   wmb_lswb_cmplt_req,
input   logic                         arb_lswb0_wmb_cmplt_req,
input   logic                         arb_lswb1_wmb_cmplt_req,
input   logic                         wmb_write_req_icc,
// ld0 ld1,
output   logic                        ctrl_ld0_clk,
// output   logic                 ctrl_ld1_clk,
// ls0 ls1,
output   logic                        ctrl_ls0_ld_clk,
output   logic                        ctrl_ls0_st_clk,
output   logic                        ctrl_ls1_ld_clk,
output   logic                        ctrl_ls1_st_clk,
// end,
output   logic                        lsu_cp0_data_inj_cmplt,
output   logic                        lsu_cp0_tag_inj_cmplt,
output   logic  [1:0]                 lsu_hpcp_cache_read_access,
output   logic  [1:0]                 lsu_hpcp_cache_read_miss,
output   logic  [1:0]                 lsu_hpcp_cache_write_access,
output   logic  [1:0]                 lsu_hpcp_cache_write_miss,
output   logic                        lsu_hpcp_fence_stall,
output   logic                        lsu_hpcp_ld_stall_cross_4k,
output   logic                        lsu_hpcp_ld_stall_other,
output   logic                        lsu_hpcp_replay_data_discard,
output   logic                        lsu_hpcp_replay_discard_sq,
output   logic                        lsu_hpcp_st_stall_cross_4k,
output   logic                        lsu_hpcp_st_stall_other,
output   logic  [1:0]                 lsu_hpcp_unalign_inst,
// lsu0,
output   logic  [LSIQENTRY-1:0]       lsu0_idu_ex3_already_da,
output   logic  [LSIQENTRY-1:0]       lsu0_idu_ex2_lq_full,
output   logic                        lsu0_idu_ex2_lq_full_gateclk_en,
output   logic                        lsu0_idu_ex3_lsiq_pop_vld,
output   logic  [LSIQENTRY-1:0]       lsu0_idu_ex3_lsiq_pop_entry,
output   logic  [LSIQENTRY-1:0]       lsu0_idu_ex3_rb_full,
output   logic                        lsu0_idu_ex3_rb_full_gateclk_en,
output   logic  [LSIQENTRY-1:0]       lsu0_idu_ex3_secd,
output   logic  [LSIQENTRY-1:0]       lsu0_idu_ex3_spec_fail,
// output   logic  [LSIQENTRY-1:0]   lsu2-3_idu_ex2_sq_full,
// output   logic                 lsu2-3_idu_ex2_sq_full_gateclk_en,
output   logic  [LSIQENTRY-1:0]       lsu0_idu_ex2_tlb_busy,
output   logic                        lsu0_idu_ex2_tlb_busy_gateclk_en,
output   logic  [LSIQENTRY-1:0]       lsu0_idu_exx_tlb_wakeup,
output   logic  [LSIQENTRY-1:0]       lsu0_idu_ex3_unalign_gateclk_en,
output   logic  [LSIQENTRY-1:0]       lsu0_idu_ex3_wait_fence,
output   logic                        lsu0_idu_ex3_wait_fence_gateclk_en,
output   logic  [LSIQENTRY-1:0]       lsu0_idu_ex1_wait_old,
output   logic                        lsu0_idu_ex1_wait_old_gateclk_en,
output   logic  [LSIQENTRY-1:0]       lsu0_idu_exx_wakeup,
// lsu1,
// output   logic  [LSIQENTRY-1:0]  lsu1_idu_ex3_already_da,
// output   logic  [LSIQENTRY-1:0]  lsu1_idu_ex2_lq_full,
// output   logic                   lsu1_idu_ex2_lq_full_gateclk_en,
// output   logic                   lsu1_idu_ex3_lsiq_pop_vld,
// output   logic  [LSIQENTRY-1:0]  lsu1_idu_ex3_lsiq_pop_entry,
// output   logic  [LSIQENTRY-1:0]  lsu1_idu_ex3_rb_full,
// output   logic                   lsu1_idu_ex3_rb_full_gateclk_en,
// output   logic  [LSIQENTRY-1:0]  lsu1_idu_ex3_secd,
// output   logic  [LSIQENTRY-1:0]  lsu1_idu_ex3_spec_fail,
// // output   logic  [LSIQENTRY-1:0]   lsu2-3_idu_ex2_sq_full,
// // output   logic                 lsu2-3_idu_ex2_sq_full_gateclk_en,
// output   logic  [LSIQENTRY-1:0]  lsu1_idu_ex2_tlb_busy,
// output   logic                   lsu1_idu_ex2_tlb_busy_gateclk_en,
// output   logic  [LSIQENTRY-1:0]  lsu1_idu_exx_tlb_wakeup,
// output   logic  [LSIQENTRY-1:0]  lsu1_idu_ex3_unalign_gateclk_en,
// output   logic  [LSIQENTRY-1:0]  lsu1_idu_ex3_wait_fence,
// output   logic                   lsu1_idu_ex3_wait_fence_gateclk_en,
// output   logic  [LSIQENTRY-1:0]  lsu1_idu_ex1_wait_old,
// output   logic                   lsu1_idu_ex1_wait_old_gateclk_en,
// output   logic  [LSIQENTRY-1:0]  lsu1_idu_exx_wakeup,
// lsu2,
output   logic  [LSIQENTRY-1:0]       lsu2_idu_ex3_already_da,
output   logic  [LSIQENTRY-1:0]       lsu2_idu_ex2_lq_full,
output   logic                        lsu2_idu_ex2_lq_full_gateclk_en,
output   logic                        lsu2_idu_ex3_lsiq_pop_vld,
output   logic  [LSIQENTRY-1:0]       lsu2_idu_ex3_lsiq_pop_entry,
output   logic  [LSIQENTRY-1:0]       lsu2_idu_ex3_rb_full,
output   logic                        lsu2_idu_ex3_rb_full_gateclk_en,
output   logic  [LSIQENTRY-1:0]       lsu2_idu_ex3_secd,
output   logic  [LSIQENTRY-1:0]       lsu2_idu_ex3_spec_fail,
output   logic  [LSIQENTRY-1:0]       lsu2_idu_ex2_sq_full,
output   logic                        lsu2_idu_ex2_sq_full_gateclk_en,
output   logic  [LSIQENTRY-1:0]       lsu2_idu_ex2_tlb_busy,
output   logic                        lsu2_idu_ex2_tlb_busy_gateclk_en,
output   logic  [LSIQENTRY-1:0]       lsu2_idu_exx_tlb_wakeup,
output   logic  [LSIQENTRY-1:0]       lsu2_idu_ex3_unalign_gateclk_en,
output   logic  [LSIQENTRY-1:0]       lsu2_idu_ex3_wait_fence,
output   logic                        lsu2_idu_ex3_wait_fence_gateclk_en,
output   logic  [LSIQENTRY-1:0]       lsu2_idu_ex1_wait_old,
output   logic                        lsu2_idu_ex1_wait_old_gateclk_en,
output   logic  [LSIQENTRY-1:0]       lsu2_idu_exx_wakeup,
// lsu3,      
output   logic  [LSIQENTRY-1:0]       lsu3_idu_ex3_already_da,
output   logic  [LSIQENTRY-1:0]       lsu3_idu_ex2_lq_full,
output   logic                        lsu3_idu_ex2_lq_full_gateclk_en,
output   logic                        lsu3_idu_ex3_lsiq_pop_vld,
output   logic  [LSIQENTRY-1:0]       lsu3_idu_ex3_lsiq_pop_entry,
output   logic  [LSIQENTRY-1:0]       lsu3_idu_ex3_rb_full,
output   logic                        lsu3_idu_ex3_rb_full_gateclk_en,
output   logic  [LSIQENTRY-1:0]       lsu3_idu_ex3_secd,
output   logic  [LSIQENTRY-1:0]       lsu3_idu_ex3_spec_fail,
output   logic  [LSIQENTRY-1:0]       lsu3_idu_ex2_sq_full,
output   logic                        lsu3_idu_ex2_sq_full_gateclk_en,
output   logic  [LSIQENTRY-1:0]       lsu3_idu_ex2_tlb_busy,
output   logic                        lsu3_idu_ex2_tlb_busy_gateclk_en,
output   logic  [LSIQENTRY-1:0]       lsu3_idu_exx_tlb_wakeup,
output   logic  [LSIQENTRY-1:0]       lsu3_idu_ex3_unalign_gateclk_en,
output   logic  [LSIQENTRY-1:0]       lsu3_idu_ex3_wait_fence,
output   logic                        lsu3_idu_ex3_wait_fence_gateclk_en,
output   logic  [LSIQENTRY-1:0]       lsu3_idu_ex1_wait_old,
output   logic                        lsu3_idu_ex1_wait_old_gateclk_en,
output   logic  [LSIQENTRY-1:0]       lsu3_idu_exx_wakeup,
// lsu end,     
output   logic  [3:0]                 lsu_pfu_l1_dist_sel,
output   logic  [3:0]                 lsu_pfu_l2_dist_sel,
output   logic                        lsu_special_clk,
output   logic                        lsu_yy_xx_no_op,
//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
input    logic                                      dtu_lsu_addr_trig_en,
input    logic                                      dtu_lsu_data_trig_en,
output   logic                                      lsu_any_trig_en,
output   logic  [`LSU_DEBUG_INFO_WIDTH-1:0]         lsu_dtu_debug_info,
output   logic  [`LSU_DEBUG_INFO_PENDING_WIDTH-1:0] lsu_dtu_debug_info_pend
//==========================================================
//                  Risc-V Debug zdb End 
//==========================================================
);

// define logic 
logic                                 lsu_special_clk_en;
logic                                 ctrl_ld0_clk_en;
// logic ctrl_ld1_clk_en;
logic                                 ctrl_ls0_clk_en;
logic                                 ctrl_ls1_clk_en;
// pfu
logic                                 cp0_lsu_up_vld;
logic                                 cp0_lsu_clk_en;
logic                                 cp0_lsu_clk;
// hpcp
logic                                 lsu_hpcp_up_vld;
logic                                 lsu_hpcp_clk_en;
logic                                 lsu_hpcp_clk;

logic [1:0]                           lsu_hpcp_cache_read_access_0;
logic [1:0]                           lsu_hpcp_cache_read_miss_0;
logic [1:0]                           lsu_hpcp_cache_write_access_0;
logic [1:0]                           lsu_hpcp_cache_write_miss_0;
logic                                 lsu_hpcp_ld_stall_cross_4k_0;
logic                                 lsu_hpcp_ld_stall_other_0;
logic                                 lsu_hpcp_replay_data_discard_0;
logic                                 lsu_hpcp_replay_discard_sq_0;
logic                                 lsu_hpcp_st_stall_cross_4k_0;
logic                                 lsu_hpcp_st_stall_other_0;
logic [1:0]                           lsu_hpcp_unalign_inst_0;

// logic       lsu_hpcp_cache_read_access_1;
// logic       lsu_hpcp_cache_read_miss_1;
// logic       lsu_hpcp_cache_write_access_1;
// logic       lsu_hpcp_cache_write_miss_1;
// logic       lsu_hpcp_ld_stall_cross_4k_1;
// logic       lsu_hpcp_ld_stall_other_1;
// logic       lsu_hpcp_replay_data_discard_1;
// logic       lsu_hpcp_replay_discard_sq_1;
// logic       lsu_hpcp_st_stall_cross_4k_1;
// logic       lsu_hpcp_st_stall_other_1;
// logic [1:0] lsu_hpcp_unalign_inst_1;

// pfu 
logic [3:0]                           cp0_lsu_l1_dist_sel;
logic [3:0]                           cp0_lsu_l2_dist_sel;
logic                                 lsu_pref_dist_up;


// pipeline signal 
logic                                 ld0_rf_restart_vld; // , ld1_rf_restart_vld;
logic [LSIQENTRY-1:0]                 ld0_rf_imme_wakeup; // , ld1_rf_imme_wakeup;
logic                                 ls0_rf_restart_vld, ls1_rf_restart_vld;
logic [LSIQENTRY-1:0]                 ls0_rf_imme_wakeup, ls1_rf_imme_wakeup;


// pend signal 
logic                                 read_pend_page_ca;
logic                                 read_pend_page_so;
logic [`WK_PA_WIDTH-1:0]              read_pend_addr;


//==========================================================
//              Instance of Global Gated Cell
//==========================================================
assign lsu_special_clk_en = lda0_ex3_special_gateclk_en
                            // || lda1_ex3_special_gateclk_en
                            || lsda0_rb_ex3_create_gateclk_en
                            || lsda1_rb_ex3_create_gateclk_en
                            || wmb_write_req_icc
                            || pfu_lfb_create_gateclk_en
                            || !rb_empty
                            || !vb_empty
                            || !lfb_empty
                            || !vmb_empty
                            || lfb_pop_depd_ff
                            || !pfu_part_empty
                            || lsu_has_fence
                            || lm_lfb_depd_wakeup0
                            || lm_lfb_depd_wakeup2
                            || lm_lfb_depd_wakeup3
                            || idu_lsu_vmb_create0_gateclk_en
                            || idu_lsu_vmb_create1_gateclk_en;
gated_clk_cell  x_lsu_special_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (lsu_special_clk   ),
  .external_en        (1'b0              ),
  .local_en           (lsu_special_clk_en),
  .module_en          (cp0_lsu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

//==========================================================
//                 Instance of Gated Cell  
//==========================================================
//ctrl_ld0_clk_en is used for ld0 pipe
assign ctrl_ld0_clk_en = idu_lsu0_rf1_gateclk_sel
                         ||  lag0_ex1_inst_vld
                         ||  ldc0_ex2_inst_vld
                         ||  lda0_ex3_inst_vld
                        //  ||  rb_ld_wb_cmplt_req
                         ||  arb_lwb0_rb_cmplt_req
                         ||  lwb0_ex4_inst_vld
                        //  ||  wmb_ld_wb_data_req
                         ||  arb_lwb0_wmb_data_req
                        //  ||  vmb_ld_wb_data_req
                         ||  arb_lwb0_vmb_data_req
                        //  ||  rb_ld_wb_data_req
                         ||  arb_lwb0_rb_data_req
                         ||  lwb0_ex4_data_vld
                         ||  dcache_ldc_ex2_borrow_vld_gate
                         ||  ldc0_ex2_borrow_vld
                         ||  lda0_ex3_borrow_vld;
gated_clk_cell  x_lsu_ctrl_ld0_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (ctrl_ld0_clk      ),
  .external_en        (1'b0              ),
  .local_en           (ctrl_ld0_clk_en   ),
  .module_en          (cp0_lsu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);
//ctrl_ld0_clk_en is used for ld0 pipe
// assign ctrl_ld1_clk_en = idu_lsu1_rf1_gateclk_sel
//                          ||  lag1_ex1_inst_vld
//                          ||  ldc1_ex2_inst_vld
//                          ||  lda1_ex3_inst_vld
//                          ||  rb_ld_wb_cmplt_req
//                          ||  lwb1_ex4_data_vld
//                          ||  wmb_ld_wb_data_req
//                          ||  vmb_ld_wb_data_req
//                          ||  rb_ld_wb_data_req
//                          ||  lwb1_ex4_data_vld
//                          ||  dcache_ldc_ex2_borrow_vld_gate;

// gated_clk_cell  x_lsu_ctrl_ld1_clk (
//   .clk_in             (forever_cpuclk    ),
//   .clk_out            (ctrl_ld1_clk      ),
//   .external_en        (1'b0              ),
//   .local_en           (ctrl_ld1_clk_en   ),
//   .module_en          (cp0_lsu_icg_en    ),
//   .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
// );

//ctrl_st_clk is used for st/sd pipe
assign ctrl_ls0_clk_en = idu_lsu2_rf1_gateclk_sel
                         ||  lsag0_ex1_inst_vld
                         ||  idu_lsu4_rf1_gateclk_sel
                         ||  std0_ex1_inst_vld
                         ||  lsdc0_ex2_inst_vld
                         ||  lsda0_ex3_inst_vld
                         ||  arb_lswb0_wmb_data_req // wjh@202502
                         ||  arb_lswb0_vmb_data_req // wjh@202502
                         ||  arb_lswb0_rb_data_req  // wjh@202502
                         ||  arb_lswb0_rb_cmplt_req // wjh@202502
                         ||  arb_lswb0_wmb_cmplt_req// wjh@202502
                        //  ||  wmb_lswb_cmplt_req
                         ||  lswb0_ex4_inst_vld
                         ||  dcache_lsdc_ex2_borrow_vld_gate
                         ||  lsdc0_ex2_borrow_vld
                         ||  lsda0_ex3_borrow_vld;
// &Instance("gated_clk_cell", "x_lsu_ctrl_st_clk"); @94
gated_clk_cell  x_lsu_ctrl_ls0_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (ctrl_ls0_st_clk   ),
  .external_en        (1'b0              ),
  .local_en           (ctrl_ls0_clk_en   ),
  .module_en          (cp0_lsu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);
assign ctrl_ls0_ld_clk = ctrl_ls0_st_clk;

//ctrl_st_clk is used for st/sd pipe
assign ctrl_ls1_clk_en = idu_lsu3_rf1_gateclk_sel
                         ||  lsag1_ex1_inst_vld
                         ||  idu_lsu5_rf1_gateclk_sel
                         ||  std1_ex1_inst_vld
                         ||  lsdc1_ex2_inst_vld
                         ||  lsda1_ex3_inst_vld
                         ||  arb_lswb1_wmb_data_req // wjh@202502
                         ||  arb_lswb1_vmb_data_req // wjh@202502
                         ||  arb_lswb1_rb_data_req  // wjh@202502
                         ||  arb_lswb1_rb_cmplt_req // wjh@202502
                         ||  arb_lswb1_wmb_cmplt_req// wjh@202502
                        //  ||  wmb_lswb_cmplt_req
                         ||  lswb1_ex4_inst_vld;
                        //  ||  dcache_lsdc_ex2_borrow_vld_gate
                        //  ||  lsdc1_ex2_borrow_vld
                        //  ||  lsda1_ex3_borrow_vld;
// &Instance("gated_clk_cell", "x_lsu_ctrl_st_clk"); @94
gated_clk_cell  x_lsu_ctrl_ls1_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (ctrl_ls1_st_clk   ),
  .external_en        (1'b0              ),
  .local_en           (ctrl_ls1_clk_en   ),
  .module_en          (cp0_lsu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);
assign ctrl_ls1_ld_clk = ctrl_ls1_st_clk;


assign cp0_lsu_clk_en = cp0_lsu_up_vld;
gated_clk_cell  x_cp0_lsu_gated_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (cp0_lsu_clk       ),
  .external_en        (1'b0              ),
  .local_en           (cp0_lsu_clk_en    ),
  .module_en          (cp0_lsu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);


assign lsu_hpcp_clk_en  = lsu_hpcp_up_vld;
// &Instance("gated_clk_cell", "x_lsu_hpcp_gated_clk"); @111
gated_clk_cell  x_lsu_hpcp_gated_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (lsu_hpcp_clk      ),
  .external_en        (1'b0              ),
  .local_en           (lsu_hpcp_clk_en   ),
  .module_en          (cp0_lsu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

//for timing, flop some cp0_lsu signals
assign cp0_lsu_l1_dist_sel[3:0] = {cp0_lsu_dcache_pref_dist[1]  &&  cp0_lsu_dcache_pref_dist[0],    //8x
                                  cp0_lsu_dcache_pref_dist[1]  &&  !cp0_lsu_dcache_pref_dist[0],    //4x
                                  !cp0_lsu_dcache_pref_dist[1]  &&  cp0_lsu_dcache_pref_dist[0],    //2x
                                  !cp0_lsu_dcache_pref_dist[1]  &&  !cp0_lsu_dcache_pref_dist[0]};  //1x

assign cp0_lsu_l2_dist_sel[3:0] = {cp0_lsu_l2_pref_dist[1]  &&  cp0_lsu_l2_pref_dist[0],    //8x
                                  cp0_lsu_l2_pref_dist[1]  &&  !cp0_lsu_l2_pref_dist[0],    //4x
                                  !cp0_lsu_l2_pref_dist[1]  &&  cp0_lsu_l2_pref_dist[0],    //2x
                                  !cp0_lsu_l2_pref_dist[1]  &&  !cp0_lsu_l2_pref_dist[0]};  //1x

assign lsu_pref_dist_up = (lsu_pfu_l1_dist_sel[3:0] 
                              !=  cp0_lsu_l1_dist_sel[3:0])
                          ||  (lsu_pfu_l2_dist_sel[3:0]
                              !=  cp0_lsu_l2_dist_sel[3:0]);

assign cp0_lsu_up_vld   =  lsu_pref_dist_up;


always @(posedge cp0_lsu_clk, negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    lsu_pfu_l1_dist_sel[3:0]  <= 4'b0;
    lsu_pfu_l2_dist_sel[3:0]  <= 4'b0;
  end
  else if(cp0_lsu_up_vld)
  begin
    lsu_pfu_l1_dist_sel[3:0]  <=  cp0_lsu_l1_dist_sel[3:0];
    lsu_pfu_l2_dist_sel[3:0]  <=  cp0_lsu_l2_dist_sel[3:0];
  end
end

assign lsu_cp0_tag_inj_cmplt  = lsu_lda0_tag_inj_cmplt
                                // || lsu_lda1_tag_inj_cmplt
                                || lsu_lsda0_tag_inj_cmplt
                                || lsu_lsda1_tag_inj_cmplt;

assign lsu_cp0_data_inj_cmplt = lsu_lda0_data_inj_cmplt
                                // || lsu_lda1_data_inj_cmplt
                                || lsu_lsda0_data_inj_cmplt
                                || lsu_lsda1_data_inj_cmplt;

//==========================================================
//        interface to hpcp
//==========================================================

assign lsu_hpcp_up_vld  = (lda0_ex3_inst_vld
                          //  || lda1_ex3_inst_vld
                           || lsda0_ex3_inst_vld
                           || lsda1_ex3_inst_vld
                           || lag0_ex1_inst_vld
                          //  || lag1_ex1_inst_vld
                           || lsag0_ex1_inst_vld
                           || lsag1_ex1_inst_vld
                           || lsu_has_fence
                           || (|lsu_hpcp_cache_read_access)
                           || (|lsu_hpcp_cache_read_miss)
                           || (|lsu_hpcp_cache_write_access)
                           || (|lsu_hpcp_cache_write_miss)
                           || lsu_hpcp_replay_discard_sq
                           || lsu_hpcp_replay_data_discard
                           || lsu_hpcp_ld_stall_cross_4k
                           || lsu_hpcp_ld_stall_other
                           || lsu_hpcp_st_stall_cross_4k
                           || lsu_hpcp_st_stall_other
                           || lsu_hpcp_ld0_unalign_inst
                          //  || lsu_hpcp_ld1_unalign_inst
                           || lsu_hpcp_ls0_unalign_inst
                           || lsu_hpcp_ls1_unalign_inst
                           || lsu_hpcp_fence_stall)
                          &&  hpcp_lsu_cnt_en;

assign lsu_hpcp_cache_read_access   = lsu_hpcp_cache_read_access_0;
assign lsu_hpcp_cache_read_miss     = lsu_hpcp_cache_read_miss_0;
assign lsu_hpcp_cache_write_access  = lsu_hpcp_cache_write_access_0;
assign lsu_hpcp_cache_write_miss    = lsu_hpcp_cache_write_miss_0;
// assign lsu_hpcp_fence_stall         = lsu_hpcp_fence_stall_0
assign lsu_hpcp_ld_stall_cross_4k   = lsu_hpcp_ld_stall_cross_4k_0;
assign lsu_hpcp_ld_stall_other      = lsu_hpcp_ld_stall_other_0;
assign lsu_hpcp_replay_data_discard = lsu_hpcp_replay_data_discard_0;
assign lsu_hpcp_replay_discard_sq   = lsu_hpcp_replay_discard_sq_0;
assign lsu_hpcp_st_stall_cross_4k   = lsu_hpcp_st_stall_cross_4k_0;
assign lsu_hpcp_st_stall_other      = lsu_hpcp_st_stall_other_0;
assign lsu_hpcp_unalign_inst        = lsu_hpcp_unalign_inst_0;

always @(posedge lsu_hpcp_clk, negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    lsu_hpcp_fence_stall          <= 1'b0; 

    lsu_hpcp_cache_read_access_0   <= 2'b0;
    lsu_hpcp_cache_read_miss_0     <= 2'b0;
    lsu_hpcp_cache_write_access_0  <= 2'b0;
    lsu_hpcp_cache_write_miss_0    <= 2'b0;
    lsu_hpcp_ld_stall_cross_4k_0   <= 1'b0;
    lsu_hpcp_ld_stall_other_0      <= 1'b0;
    lsu_hpcp_replay_data_discard_0 <= 1'b0;
    lsu_hpcp_replay_discard_sq_0   <= 1'b0;
    lsu_hpcp_st_stall_cross_4k_0   <= 1'b0;
    lsu_hpcp_st_stall_other_0      <= 1'b0;
    lsu_hpcp_unalign_inst_0        <= 2'b0;
    // lsu_hpcp_cache_read_access_1   <= 1'b0;
    // lsu_hpcp_cache_read_miss_1     <= 1'b0;
    // lsu_hpcp_cache_write_access_1  <= 1'b0;
    // lsu_hpcp_cache_write_miss_1    <= 1'b0;
    // lsu_hpcp_ld_stall_cross_4k_1   <= 1'b0;
    // lsu_hpcp_ld_stall_other_1      <= 1'b0;
    // lsu_hpcp_replay_data_discard_1 <= 1'b0;
    // lsu_hpcp_replay_discard_sq_1   <= 1'b0;
    // lsu_hpcp_st_stall_cross_4k_1   <= 1'b0;
    // lsu_hpcp_st_stall_other_1      <= 1'b0;
    // lsu_hpcp_unalign_inst_1        <= 2'b0;

  end
  else if(lsu_hpcp_up_vld)
  begin
    lsu_hpcp_cache_read_access_0   <= {1'b0, lsu_hpcp_ld0_cache_access} + {1'b0, lsu_hpcp_ls0_ld_cache_access} + {1'b0, lsu_hpcp_ls1_ld_cache_access};
    lsu_hpcp_cache_read_miss_0     <= {1'b0, lsu_hpcp_ld0_cache_miss}   + {1'b0, lsu_hpcp_ls0_ld_cache_miss}   + {1'b0, lsu_hpcp_ls1_ld_cache_miss};
    lsu_hpcp_cache_write_access_0  <= {1'b0, lsu_hpcp_ls0_st_cache_access} + {1'b0, lsu_hpcp_ls1_st_cache_access};
    lsu_hpcp_cache_write_miss_0    <= {1'b0, lsu_hpcp_ls0_st_cache_miss}   + {1'b0, lsu_hpcp_ls1_st_cache_miss};
    lsu_hpcp_ld_stall_cross_4k_0   <= lsu_hpcp_ld0_cross_4k_stall;
    lsu_hpcp_ld_stall_other_0      <= lsu_hpcp_ld0_other_stall;
    lsu_hpcp_replay_data_discard_0 <= lsu_hpcp_ld0_data_discard;
    lsu_hpcp_replay_discard_sq_0   <= lsu_hpcp_ld0_discard_sq;
    lsu_hpcp_st_stall_cross_4k_0   <= lsu_hpcp_ls0_cross_4k_stall;
    lsu_hpcp_st_stall_other_0      <= lsu_hpcp_ls0_other_stall;
    lsu_hpcp_unalign_inst_0        <= {1'b0,lsu_hpcp_ld0_unalign_inst} + {1'b0,lsu_hpcp_ls0_unalign_inst};

    // lsu_hpcp_cache_read_access_1   <= lsu_hpcp_ld1_cache_access;
    // lsu_hpcp_cache_read_miss_1     <= lsu_hpcp_ld1_cache_miss;
    // lsu_hpcp_cache_write_access_1  <= lsu_hpcp_ls1_cache_access;
    // lsu_hpcp_cache_write_miss_1    <= lsu_hpcp_ls1_cache_miss;
    // lsu_hpcp_ld_stall_cross_4k_1   <= lsu_hpcp_ld1_cross_4k_stall;
    // lsu_hpcp_ld_stall_other_1      <= lsu_hpcp_ld1_other_stall;
    // lsu_hpcp_replay_data_discard_1 <= lsu_hpcp_ld1_data_discard;
    // lsu_hpcp_replay_discard_sq_1   <= lsu_hpcp_ld1_discard_sq;
    // lsu_hpcp_st_stall_cross_4k_1   <= lsu_hpcp_ls1_cross_4k_stall;
    // lsu_hpcp_st_stall_other_1      <= lsu_hpcp_ls1_other_stall;
    // lsu_hpcp_unalign_inst_1        <= {1'b0,lsu_hpcp_ld1_unalign_inst} + {1'b0,lsu_hpcp_ls1_unalign_inst}; 
    // lsu_hpcp_unalign_inst_1        <= {1'b0,lsu_hpcp_ls1_unalign_inst}; 

    lsu_hpcp_fence_stall          <= lsu_has_fence; 
  end
end


//==========================================================
//        Pipeline signal
//==========================================================
//------------------rf stage--------------------------------

assign ld0_rf_restart_vld                = idu_lsu0_rf1_older_vld // wjh@timing
                                           &&  lag0_ex1_stall_ori;

assign ld0_rf_imme_wakeup[LSIQENTRY-1:0] = lag0_ex1_stall_restart_entry[LSIQENTRY-1:0]
                                           & {LSIQENTRY{ld0_rf_restart_vld}};

// assign ld1_rf_restart_vld                = idu_lsu1_rf1_sel
//                                            &&  lag1_ex1_stall_ori;

// assign ld1_rf_imme_wakeup[LSIQENTRY-1:0] = lag1_ex1_stall_restart_entry[LSIQENTRY-1:0]
//                                            & {LSIQENTRY{ld1_rf_restart_vld}};

assign ls0_rf_restart_vld                  = idu_lsu2_rf1_older_vld // wjh@timing
                                            &&  lsag0_ex1_stall_ori;
assign ls0_rf_imme_wakeup[LSIQENTRY-1:0]  = lsag0_ex1_stall_restart_entry[LSIQENTRY-1:0]
                                            & {LSIQENTRY{ls0_rf_restart_vld}};

assign ls1_rf_restart_vld                  = idu_lsu3_rf1_older_vld // wjh@timing
                                            &&  lsag1_ex1_stall_ori;
assign ls1_rf_imme_wakeup[LSIQENTRY-1:0]  = lsag1_ex1_stall_restart_entry[LSIQENTRY-1:0]
                                            & {LSIQENTRY{ls1_rf_restart_vld}};
//------------------ag stage--------------------------------
assign lsu0_idu_ex2_tlb_busy = ldc0_idu_ex2_tlb_busy;
// assign lsu1_idu_ex2_tlb_busy = ldc1_idu_ex2_tlb_busy;
assign lsu2_idu_ex2_tlb_busy = lsdc0_idu_ex2_tlb_busy;
assign lsu3_idu_ex2_tlb_busy = lsdc1_idu_ex2_tlb_busy;

//------------------dc stage--------------------------------
assign lsu0_idu_ex2_lq_full = ldc0_idu_ex2_lq_full;
// assign lsu1_idu_ex2_lq_full = ldc1_idu_ex2_lq_full;
assign lsu2_idu_ex2_lq_full = lsdc0_idu_ex2_lq_full;
assign lsu3_idu_ex2_lq_full = lsdc1_idu_ex2_lq_full;

assign lsu2_idu_ex2_sq_full = lsdc0_idu_ex2_sq_full;
assign lsu3_idu_ex2_sq_full = lsdc1_idu_ex2_sq_full;

//------------------da stage--------------------------------
assign lsu0_idu_ex3_wait_fence = lda0_idu_ex3_wait_fence;
// assign lsu1_idu_ex3_wait_fence = lda1_idu_ex3_wait_fence;
assign lsu2_idu_ex3_wait_fence = lsda0_idu_ex3_wait_fence;
assign lsu3_idu_ex3_wait_fence = lsda1_idu_ex3_wait_fence;

assign lsu0_idu_ex3_rb_full = lda0_idu_ex3_rb_full;
// assign lsu1_idu_ex3_rb_full = lda1_idu_ex3_rb_full;
assign lsu2_idu_ex3_rb_full = lsda0_idu_ex3_rb_full;
assign lsu3_idu_ex3_rb_full = lsda1_idu_ex3_rb_full;

assign lsu0_idu_ex3_already_da = lda0_idu_ex3_already_da;
// assign lsu1_idu_ex3_already_da = lda1_idu_ex3_already_da;
assign lsu2_idu_ex3_already_da = lsda0_idu_ex3_already_da;
assign lsu3_idu_ex3_already_da = lsda1_idu_ex3_already_da;
//---------------boundary signal----------------------------
assign lsu0_idu_ex3_unalign_gateclk_en = lda0_idu_ex3_boundary_gateclk_en;
// assign lsu1_idu_ex3_unalign_gateclk_en = lda1_idu_ex3_boundary_gateclk_en;
assign lsu2_idu_ex3_unalign_gateclk_en = lsda0_idu_ex3_boundary_gateclk_en;
assign lsu3_idu_ex3_unalign_gateclk_en = lsda1_idu_ex3_boundary_gateclk_en;

assign lsu0_idu_ex3_secd = lda0_idu_ex3_secd;
// assign lsu1_idu_ex3_secd = lda1_idu_ex3_secd;
assign lsu2_idu_ex3_secd = lsda0_idu_ex3_secd;
assign lsu3_idu_ex3_secd = lsda1_idu_ex3_secd;

//------------------pop signals-----------------------------
assign lsu0_idu_ex3_lsiq_pop_vld = lda0_idu_ex3_pop_vld;
// assign lsu1_idu_ex3_lsiq_pop_vld = lda1_idu_ex3_pop_vld;
assign lsu2_idu_ex3_lsiq_pop_vld = lsda0_idu_ex3_pop_vld;
assign lsu3_idu_ex3_lsiq_pop_vld = lsda1_idu_ex3_pop_vld;

assign lsu0_idu_ex3_lsiq_pop_entry = lda0_idu_ex3_pop_entry;
// assign lsu1_idu_ex3_lsiq_pop_entry = lda1_idu_ex3_pop_entry;
assign lsu2_idu_ex3_lsiq_pop_entry = lsda0_idu_ex3_pop_entry;
assign lsu3_idu_ex3_lsiq_pop_entry = lsda1_idu_ex3_pop_entry;

//--------------gateclk-----------------
assign lsu0_idu_ex2_lq_full_gateclk_en = ldc0_ex2_lq_full_gateclk_en;
// assign lsu1_idu_ex2_lq_full_gateclk_en = ldc1_ex2_lq_full_gateclk_en;
assign lsu2_idu_ex2_lq_full_gateclk_en = lsdc0_ex2_lq_full_gateclk_en;
assign lsu3_idu_ex2_lq_full_gateclk_en = lsdc1_ex2_lq_full_gateclk_en;

assign lsu2_idu_ex2_sq_full_gateclk_en = lsdc0_idu_ex2_sq_full_gateclk_en;
assign lsu3_idu_ex2_sq_full_gateclk_en = lsdc1_idu_ex2_sq_full_gateclk_en;

assign lsu0_idu_ex2_tlb_busy_gateclk_en = ldc0_ex2_tlb_busy_gateclk_en;
// assign lsu1_idu_ex2_tlb_busy_gateclk_en = ldc1_ex2_tlb_busy_gateclk_en;
assign lsu2_idu_ex2_tlb_busy_gateclk_en = lsdc0_ex2_tlb_busy_gateclk_en;
assign lsu3_idu_ex2_tlb_busy_gateclk_en = lsdc1_ex2_tlb_busy_gateclk_en;

assign lsu0_idu_ex3_rb_full_gateclk_en = lda0_ex3_rb_full_gateclk_en;
// assign lsu1_idu_ex3_rb_full_gateclk_en = lda1_ex3_rb_full_gateclk_en;
assign lsu2_idu_ex3_rb_full_gateclk_en = lsda0_ex3_rb_full_gateclk_en;
assign lsu3_idu_ex3_rb_full_gateclk_en = lsda1_ex3_rb_full_gateclk_en;

assign lsu0_idu_ex3_wait_fence_gateclk_en = lda0_ex3_wait_fence_gateclk_en;
// assign lsu1_idu_ex3_wait_fence_gateclk_en = lda1_ex3_wait_fence_gateclk_en;
assign lsu2_idu_ex3_wait_fence_gateclk_en = lsda0_ex3_wait_fence_gateclk_en;
assign lsu3_idu_ex3_wait_fence_gateclk_en = lsda1_ex3_wait_fence_gateclk_en;

//==========================================================
//        Imme & Buffer maintain restart
//==========================================================
assign lsu0_idu_exx_wakeup = ld0_rf_imme_wakeup
                             | ldc0_ex2_imme_wakeup
                             | lda0_idu_ex3_secd
                             | lda0_ex3_ecc_wakeup
                             | sq_global_depd_wakeup0
                             | sq_data_depd_wakeup0
                             | wmb_depd_wakeup0
                             | mmu_lsu_async_wakeup0 // wjh@tmq
                             | lda0_idu_ex3_us_restart
                             | lfb_depd_wakeup0;

// assign lsu1_idu_exx_wakeup = ld1_rf_imme_wakeup
//                              | ldc1_ex2_imme_wakeup
//                              | lda1_idu_ex3_secd
//                              | lda1_ex3_ecc_wakeup
//                              | sq_global_depd_wakeup1
//                              | sq_data_depd_wakeup1
//                              | wmb_depd_wakeup1
//                              | lfb_depd_wakeup1;

assign lsu2_idu_exx_wakeup = ls0_rf_imme_wakeup
                             | lsdc0_ex2_imme_wakeup
                             | lsda0_idu_ex3_secd
                             | lsda0_ex3_ecc_wakeup
                             | sq_global_depd_wakeup2
                             | sq_data_depd_wakeup2
                             | wmb_depd_wakeup2
                             | mmu_lsu_async_wakeup2 // wjh@tmq
                             | lsda0_idu_ex3_us_restart
                             | lfb_depd_wakeup2;

assign lsu3_idu_exx_wakeup = ls1_rf_imme_wakeup
                             | lsdc1_ex2_imme_wakeup
                             | lsda1_idu_ex3_secd
                             | lsda1_idu_ex3_us_restart
                             | lsda1_ex3_ecc_wakeup
                             | sq_global_depd_wakeup3
                             | sq_data_depd_wakeup3
                             | wmb_depd_wakeup3
                             | mmu_lsu_async_wakeup3 // wjh@tmq
                             | lfb_depd_wakeup3;

assign lsu0_idu_exx_tlb_wakeup = mmu_lsu_tlb_wakeup;
// assign lsu1_idu_exx_tlb_wakeup = mmu_lsu_tlb_wakeup;
assign lsu2_idu_exx_tlb_wakeup = mmu_lsu_tlb_wakeup;
assign lsu3_idu_exx_tlb_wakeup = mmu_lsu_tlb_wakeup;

assign lsu0_idu_ex1_wait_old = lag0_idu_ex1_wait_old | lda0_idu_ex3_wait_old;
// assign lsu1_idu_ex1_wait_old = lag1_idu_ex1_wait_old | lda1_idu_ex3_wait_old;
assign lsu2_idu_ex1_wait_old = lsag0_idu_ex1_wait_old | lsda0_idu_ex3_wait_old;
assign lsu3_idu_ex1_wait_old = lsag1_idu_ex1_wait_old | lsda1_idu_ex3_wait_old;

assign lsu0_idu_ex1_wait_old_gateclk_en = lag0_idu_ex1_wait_old_gateclk_en | lda0_idu_ex3_wait_old_gateclk_en;
// assign lsu1_idu_ex1_wait_old_gateclk_en = lag1_idu_ex1_wait_old_gateclk_en | lda1_idu_ex3_wait_old_gateclk_en;
assign lsu2_idu_ex1_wait_old_gateclk_en = lsag0_idu_ex1_wait_old_gateclk_en | lsda0_idu_ex3_wait_old_gateclk_en;
assign lsu3_idu_ex1_wait_old_gateclk_en = lsag1_idu_ex1_wait_old_gateclk_en | lsda1_idu_ex3_wait_old_gateclk_en;

assign lsu0_idu_ex3_spec_fail = lda0_idu_ex3_spec_fail;
assign lsu2_idu_ex3_spec_fail = lsda0_idu_ex3_spec_fail;
assign lsu3_idu_ex3_spec_fail = lsda1_idu_ex3_spec_fail;
//==========================================================
//                Generate no_op signal
//==========================================================
assign lsu_yy_xx_no_op  = wmb_empty
                          &&  sq_empty
                          &&  rb_empty
                          &&  lfb_empty
                          &&  vmb_empty
                          &&  vb_empty;


always_comb begin 
  if(rb_has_pend)
    begin
      read_pend_page_ca    = rb_pend_page_ca_f;
      read_pend_page_so    = rb_pend_page_so_f;
      read_pend_addr[`WK_PA_WIDTH-1:0] = rb_pend_addr_f[`WK_PA_WIDTH-1:0];
    end
  else
    begin
      read_pend_page_ca    = lfb_pend_page_ca_f;
      read_pend_page_so    = lfb_pend_page_so_f;
      read_pend_addr[`WK_PA_WIDTH-1:0] = lfb_pend_addr_f[`WK_PA_WIDTH-1:0];
    end
end 

//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
assign lsu_dtu_debug_info[`LSU_DEBUG_INFO_WIDTH-1:0] = {lsu_had_amr_state[2:0],
      lsu_had_icc_state[2:0],
      lsu_had_lfb_addr_entry_vld[7:0],
      lsu_had_lfb_addr_entry_rcl_done[7:0],
      lsu_had_lfb_addr_entry_dcache_hit[7:0],
      lsu_had_lfb_data_entry_vld[1:0],
      lsu_had_lfb_data_entry_last[1:0],
      lsu_had_lfb_lf_sm_vld,
      lsu_had_lfb_wakeup_queue[12:0],
      lsu_had_vb_addr_entry_vld[1:0],
      lsu_had_vb_data_entry_vld[2:0],
      lsu_had_vb_rcl_sm_state[3:0],
      lsu_had_lm_state[2:0],
      lsu_had_mcic_data_req,
      lsu_had_mcic_frz,
      lsu_had_rb_entry_fence[7:0],
      lsu_had_rb_entry_state_0[3:0],
      lsu_had_rb_entry_state_1[3:0],
      lsu_had_rb_entry_state_2[3:0],
      lsu_had_rb_entry_state_3[3:0],
      lsu_had_rb_entry_state_4[3:0],
      lsu_had_rb_entry_state_5[3:0],
      lsu_had_rb_entry_state_6[3:0],
      lsu_had_rb_entry_state_7[3:0],
      lsu_had_sq_not_empty,
      lsu_had_wmb_ar_pending,
      lsu_had_wmb_aw_pending,
      lsu_had_wmb_w_pending,
      lsu_had_wmb_entry_vld[7:0],
      lsu_had_wmb_create_ptr[7:0],
      lsu_had_wmb_write_ptr[7:0],
      lsu_had_wmb_data_ptr[7:0],
      lsu_had_wmb_read_ptr[7:0],
      lsu_had_wmb_write_imme,
      lsu_had_snq_entry_vld[5:0],
      lsu_had_snq_entry_issued[5:0],
      lsu_had_snoop_tag_req,
      lsu_had_snoop_data_req,
      lsu_had_sdb_entry_vld[2:0],
      lsu_had_cdr_state[1:0],
      lsu_had_ctcq_entry_vld[5:0],
      lsu_had_ctcq_entry_cmplt[5:0],
      lsu_had_ctcq_entry_2_cmplt[5:0]      
      };

assign lsu_dtu_debug_info_pend[`LSU_DEBUG_INFO_PENDING_WIDTH-1:0]  = {
                                        1'b0,
                                        wmb_has_pend,
                                        wmb_pend_page_so_f,
                                        wmb_pend_page_ca_f,
                                        wmb_pend_addr_f[39:0],
                                        lfb_has_pend,
                                        rb_has_pend,
                                        read_pend_page_so,
                                        read_pend_page_ca,
                                        read_pend_addr[39:0]};

assign lsu_any_trig_en  = dtu_lsu_data_trig_en | dtu_lsu_addr_trig_en;
//==========================================================
//                  Risc-V Debug zdb End
//==========================================================

endmodule
