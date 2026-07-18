//-----------------------------------------------------------------------------
// File          : xx_lsu_sq.v
// Created       : 2024/10/01 (by Wen Jiahui)
// Last modified : 2024/10/01 (by Wen Jiahui)
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
// 2024/XX/XX : 
//-----------------------------------------------------------------------------

//#
//# Module Declaration
//# ==================
//#


// $Id: xx_lsu_sq.vp,v 1.48 2022/01/06 08:14:35 jizk Exp $
// *****************************************************************************

// &ModuleBeg; @30
module xx_lsu_sq #(
  parameter IID_WIDTH   = 7,
  parameter SDID_LEN    = 4,
  parameter LSIQ_ENTRY  = 12,
  parameter SQ_ENTRY    = 12,
  parameter WK_PA_WIDTH = `WK_PA_WIDTH,
  parameter PREG        = 7,
  parameter PC_LEN      = 15
)(
input logic                                                 cp0_lsu_dcache_en,                     
input logic                                                 cp0_lsu_icg_en,                        
input logic   [1  :0]                                       cp0_yy_priv_mode,                      
input logic                                                 cpurst_b,                              
input logic   [15 :0]                                       dcache_dirty_din,    //8->15 [16]deleted, L1D2->4way,  LTL@20250323                   
input logic                                                 dcache_dirty_gwen,                     
input logic   [15 :0]                                       dcache_dirty_wen,   //8->15 [16]deleted, L1D2->4way,  LTL@20250323                   
input logic   [7  :0]                                       dcache_idx,         //8->7, L1D2->4way,  LTL@20250323                   
input logic   [`WK_LS_DCACHE_TAG_NOECC_WIDTH-1:0]           dcache_tag_din,     //51->103, L1D2->4way,  LTL@20250323                   
input logic                                                 dcache_tag_gwen,                       
input logic   [3  :0]                                       dcache_tag_wen,     //1->3, L1D2->4way,  LTL@20250323                   
input logic                                                 forever_cpuclk,                                             
input logic                                                 icc_idle,                              
input logic                                                 icc_sq_grnt,
//input logic            lsdc0_older_than_lsdc1, //newly add signal, 2 lsdc compare in ex1, ex2 send to sq, LTL@20241016                            
input logic                                                 rtu_ck_flush,
input logic  [IID_WIDTH-1  :0]                              rtu_ck_flush_iid,
input logic   [LSIQ_ENTRY-1:0]                              lda0_ex3_lsid,  //1->3, for 3 ld_da, LTL@20241024
input logic   [LSIQ_ENTRY-1:0]                              lsda0_ex3_lsid,  //ld_da 
input logic   [LSIQ_ENTRY-1:0]                              lsda1_ex3_lsid,  //ld_da 
input logic                                                 lda0_sq_ex3_data_discard_vld,//1->3, for 3 ld_da, LTL@20241024
input logic                                                 lsda0_sq_ex3_data_discard_vld, 
input logic                                                 lsda1_sq_ex3_data_discard_vld, 
input logic   [SQ_ENTRY-1:0]                                lda0_sq_ex3_fwd_id,//1->3, for 3 ld_da, LTL@20241024
input logic   [SQ_ENTRY-1:0]                                lsda0_sq_ex3_fwd_id,
input logic   [SQ_ENTRY-1:0]                                lsda1_sq_ex3_fwd_id,  
input logic                                                 lda0_sq_ex3_fwd_multi_vld,//1->3, for 3 ld_da, LTL@20241024
input logic                                                 lsda0_sq_ex3_fwd_multi_vld,                
input logic                                                 lsda1_sq_ex3_fwd_multi_vld,
input logic                                                 lda0_sq_ex3_global_discard_vld,//1->3, for 3 ld_da, LTL@20241024
input logic                                                 lsda0_sq_ex3_global_discard_vld,           
input logic                                                 lsda1_sq_ex3_global_discard_vld,           
input logic   [`WK_PA_WIDTH-1 :0]                           ldc0_ex2_addr0,//1->3, for 3 ld_da, LTL@20241024
input logic   [`WK_PA_WIDTH-1 :0]                           lsdc0_ex2_st_addr0,//timing
input logic   [`WK_PA_WIDTH-1 :0]                           lsdc0_ex2_ld_addr0,//timing
input logic   [`WK_PA_WIDTH-1 :0]                           lsdc1_ex2_st_addr0,//timing
input logic   [`WK_PA_WIDTH-1 :0]                           lsdc1_ex2_ld_addr0,//timing
input logic   [7  :0]                                       ldc0_ex2_addr1_11to4,//1->3, for 3 ld_da, LTL@20241024
input logic   [7  :0]                                       lsdc0_ex2_addr1_11to4,
input logic   [7  :0]                                       lsdc1_ex2_addr1_11to4,
input logic   [15 :0]                                       ldc0_ex2_bytes_vld,//1->3, for 3 ld_da, LTL@20241024
input logic   [15 :0]                                       lsdc0_ex2_st_bytes_vld,
input logic   [15 :0]                                       lsdc0_ex2_ld_bytes_vld,//timing@LTL
input logic   [15 :0]                                       lsdc1_ex2_st_bytes_vld,
input logic   [15 :0]                                       lsdc1_ex2_ld_bytes_vld,//timing@LTL
input logic   [15 :0]                                       ldc0_ex2_bytes_vld1, //1->3, for 3 ld_da, LTL@20241024
input logic   [15 :0]                                       lsdc0_ex2_bytes_vld1,
input logic   [15 :0]                                       lsdc1_ex2_bytes_vld1,
input logic   [15 :0]                                       ldc0_ex2_bytes_vld2, //1->3, for 3 ld_da, LTL@20241024
input logic   [15 :0]                                       lsdc0_ex2_bytes_vld2,
input logic   [15 :0]                                       lsdc1_ex2_bytes_vld2,
input logic   [15 :0]                                       ldc0_ex2_bytes_vld3, //1->3, for 3 ld_da, LTL@20241024
input logic   [15 :0]                                       lsdc0_ex2_bytes_vld3,
input logic   [15 :0]                                       lsdc1_ex2_bytes_vld3,
input logic                                                 ldc0_ex2_is_us, //1->3, for 3 ld_da, LTL@20241024
input logic                                                 lsdc0_ex2_is_us,
input logic                                                 lsdc1_ex2_is_us,    //rvv512@LTL
input logic                                                 ldc0_ex2_chk_atomic_inst_vld, //1->3, for 3 ld, LTL@20241024
input logic                                                 lsdc0_ex2_chk_atomic_inst_vld,
input logic                                                 lsdc1_ex2_chk_atomic_inst_vld,
input logic                                                 ldc0_ex2_chk_ld_addr1_vld,//1->3, for 3 ld, LTL@20241024
input logic                                                 lsdc0_ex2_chk_ld_addr1_vld, 
input logic                                                 lsdc1_ex2_chk_ld_addr1_vld, 
input logic                                                 ldc0_sq_ex2_chk_ld_bypass_vld,//1->3, for 3 ld, LTL@20241024
input logic                                                 lsdc0_sq_ex2_chk_ld_bypass_vld,               
input logic                                                 lsdc1_sq_ex2_chk_ld_bypass_vld,
input logic                                                 ldc0_ex2_chk_ld_inst_vld,//1->3, for 3 ld, LTL@20241024
input logic                                                 lsdc0_ex2_chk_ld_inst_vld,
input logic                                                 lsdc1_ex2_chk_ld_inst_vld,
input logic   [IID_WIDTH-1:0]                               ldc0_ex2_iid, //1->3, for 3 ld, LTL@20241024
input logic   [IID_WIDTH-1:0]                               lsdc0_ex2_ld_iid,//logic levels opt@LTL
input logic   [IID_WIDTH-1:0]                               lsdc1_ex2_ld_iid,//logic levels opt@LTL
input logic   [IID_WIDTH-1:0]                               lsdc0_ex2_st_iid,//logic levels opt@LTL
input logic   [IID_WIDTH-1:0]                               lsdc1_ex2_st_iid,//logic levels opt@LTL
input logic                                                 lsu_rtu_all_commit_ld_data_vld,        
input logic                                                 pad_yy_icg_scan_en,  
input logic                                                 rb_sq_pop_hit_idx,
input logic                                                 rtu_lsu_async_flush,                   
input logic   [IID_WIDTH-1:0]                               rtu_lsu_commit0_iid_updt_val, //3->8, for 8 cmit data, LTL@20241101         
input logic   [IID_WIDTH-1:0]                               rtu_lsu_commit1_iid_updt_val,          
input logic   [IID_WIDTH-1:0]                               rtu_lsu_commit2_iid_updt_val,
input logic   [IID_WIDTH-1:0]                               rtu_lsu_commit3_iid_updt_val,          
input logic   [IID_WIDTH-1:0]                               rtu_lsu_commit4_iid_updt_val,          
input logic   [IID_WIDTH-1:0]                               rtu_lsu_commit5_iid_updt_val,
input logic   [IID_WIDTH-1:0]                               rtu_lsu_commit6_iid_updt_val,          
input logic   [IID_WIDTH-1:0]                               rtu_lsu_commit7_iid_updt_val,                   
input logic                                                 rtu_lsu_flush_fe,                      
input logic                                                 rtu_yy_xx_commit0,   //3->8, for 8 cmit data, LTL@20241101                  
input logic                                                 rtu_yy_xx_commit1,                     
input logic                                                 rtu_yy_xx_commit2,
input logic                                                 rtu_yy_xx_commit3,                     
input logic                                                 rtu_yy_xx_commit4,                     
input logic                                                 rtu_yy_xx_commit5,
input logic                                                 rtu_yy_xx_commit6,                     
input logic                                                 rtu_yy_xx_commit7,                                      
input logic                                                 rtu_yy_xx_flush,
input logic   [127:0]                                       std0_sq_ex1_data, //1->2, for 2 st data, LTL@20241101
input logic   [127:0]                                       std1_sq_ex1_data,
input logic                                                 std0_ex1_inst_vld,//1->2, for 2 st data, LTL@20241101
input logic                                                 std1_ex1_inst_vld,
input logic   [SDID_LEN-1:0]                                std0_rf_sdid,//1->2, for 2 st data, LTL@20241101
input logic   [SDID_LEN-1:0]                                std1_rf_sdid,
input logic                                                 std0_sq_rf_inst_vld_short,//1->2, for 2 st data, LTL@20241101
input logic                                                 std1_sq_rf_inst_vld_short,                       
input logic   [IID_WIDTH-1:0]                               lsda0_ex3_iid,//1->2, for 2 st, LTL@20241101
input logic   [IID_WIDTH-1:0]                               lsda1_ex3_iid,
input logic                                                 lsda0_ex3_inst_vld,//1->2, for 2 st, LTL@20241101
input logic                                                 lsda1_ex3_inst_vld, 
input logic                                                 lsda0_sq_ex3_secd,//1->2, for 2 st, LTL@20241101
input logic                                                 lsda1_sq_ex3_secd,
input logic                                                 lsda0_sq_ex3_dcache_dirty,//1->2, for 2 st, LTL@20241101
input logic                                                 lsda1_sq_ex3_dcache_dirty,
input logic                                                 lsda0_sq_ex3_dcache_page_share,//1->2, for 2 st, LTL@20241101
input logic                                                 lsda1_sq_ex3_dcache_page_share,
input logic                                                 lsda0_sq_ex3_dcache_share,//1->2, for 2 st, LTL@20241101
input logic                                                 lsda1_sq_ex3_dcache_share,
input logic                                                 lsda0_sq_ex3_dcache_valid,//1->2, for 2 st, LTL@20241101
input logic                                                 lsda1_sq_ex3_dcache_valid,
input logic    [1:0]                                        lsda0_sq_ex3_dcache_way,//1->2, for 2 st, LTL@20241101  //1->2bit, L1D 2->4way,  LTL@20250323 
input logic    [1:0]                                        lsda1_sq_ex3_dcache_way,  //1->2bit, L1D 2->4way,  LTL@20250323 
input logic                                                 lsda0_sq_ex3_ecc_stall,//1->2, for 2 st, LTL@20241101
input logic                                                 lsda1_sq_ex3_ecc_stall,
input logic                                                 lsda0_sq_ex3_expt_vld,//1->2, for 2 st, LTL@20241101
input logic                                                 lsda1_sq_ex3_expt_vld, 
input logic                                                 lsda0_sq_ex3_lm_fail,//1->2, for 2 st, LTL@20241101
input logic                                                 lsda1_sq_ex3_lm_fail,
input logic                                                 lsda0_sq_ex3_no_restart,//1->2, for 2 st, LTL@20241101
input logic                                                 lsda1_sq_ex3_no_restart,
input logic                                                 lsda0_ex3_spec_fail,//1->2, for 2 st, LTL@20241101
input logic                                                 lsda1_ex3_spec_fail,
input logic                                                 lsda0_ex3_vstart_vld,//1->2, for 2 st, LTL@20241101
input logic                                                 lsda1_ex3_vstart_vld,
input logic                                                 lsdc0_ex2_atomic,  //all lsdc 1->2, for 2 st, LTL@20241101      
input logic                                                 lsdc0_ex2_boundary,                        
input logic                                                 lsdc0_sq_ex2_boundary_first,                                       
input logic                                                 lsdc0_sq_ex2_cmit0_iid_crt_hit,          
input logic                                                 lsdc0_sq_ex2_cmit1_iid_crt_hit,          
input logic                                                 lsdc0_sq_ex2_cmit2_iid_crt_hit,
input logic                                                 lsdc0_sq_ex2_cmit3_iid_crt_hit,          
input logic                                                 lsdc0_sq_ex2_cmit4_iid_crt_hit,          
input logic                                                 lsdc0_sq_ex2_cmit5_iid_crt_hit,
input logic                                                 lsdc0_sq_ex2_cmit6_iid_crt_hit,          
input logic                                                 lsdc0_sq_ex2_cmit7_iid_crt_hit,                
input logic                                                 lsdc0_ex2_page_buf,                     
input logic                                                 lsdc0_ex2_page_ca,                      
input logic                                                 lsdc0_ex2_page_sec,                     
input logic                                                 lsdc0_ex2_page_share,                   
input logic                                                 lsdc0_ex2_page_so,                      
input logic                                                 lsdc0_ex2_page_wa,                      
input logic                                                 lsdc0_sq_ex2_dtcm_hit,                        
input logic   [1  :0]                                       lsdc0_sq_ex2_element_size,                    
input logic   [3  :0]                                       lsdc0_ex2_fence_mode,                      
input logic                                                 lsdc0_ex2_icc,                             
input logic   [PREG-1:0]                                    lsdc0_ex2_preg,
input logic                                                 lsdc0_sq_ex2_idx_order,                                                  
input logic                                                 lsdc0_sq_ex2_inst_flush,                      
input logic   [1  :0]                                       lsdc0_ex2_inst_mode,                       
input logic   [2  :0]                                       lsdc0_ex2_inst_size,                       
input logic   [1  :0]                                       lsdc0_ex2_inst_type,                       
input logic                                                 lsdc0_ex2_inst_vls,                        
input logic                                                 lsdc0_sq_ex2_itcm_hit,                        
input logic                                                 lsdc0_ex2_old,                             
input logic   [15 :0]                                       lsdc0_sq_ex2_rot_sel_rev,                     
input logic   [SDID_LEN-1:0]                                lsdc0_sq_ex2_sdid,                            
input logic                                                 lsdc0_sq_ex2_sdid_hit0,  //1->2, 0 for std0, 1 for std1, LTL@20241123
input logic                                                 lsdc0_sq_ex2_sdid_hit1,                       
input logic                                                 lsdc0_ex2_st_secd,//logic levels opt@LTL                            
input logic                                                 lsdc0_sq_ex2_create_dp_vld,                
input logic                                                 lsdc0_sq_ex2_create_gateclk_en,            
input logic                                                 lsdc0_sq_ex2_create_vld,                   
input logic                                                 lsdc0_sq_ex2_data_vld,                     
input logic                                                 lsdc0_ex2_sync_fence,                      
//input logic   [1  :0]                                       lsdc0_sq_ex2_vsew, //rvv1.0@hcl 
input logic   [1  :0]  lsdc0_sq_ex2_vmew, //rvv1.0@hcl
input logic   [1  :0]  lsdc0_sq_ex2_vmop, //rvv1.0@hcl                           
input logic                                                 lsdc0_sq_ex2_wo_st_inst,
input logic                                                 lsdc0_ex2_dcache_hit,
input logic   [1  :0]                                       lsdc0_ex2_ssp_va,
input logic   [PC_LEN-1:0]                                  lsdc0_ex2_pc,
input logic                                                 lsdc1_ex2_atomic,                          
input logic                                                 lsdc1_ex2_boundary,                        
input logic                                                 lsdc1_sq_ex2_boundary_first,                                        
input logic                                                 lsdc1_sq_ex2_cmit0_iid_crt_hit,          
input logic                                                 lsdc1_sq_ex2_cmit1_iid_crt_hit,          
input logic                                                 lsdc1_sq_ex2_cmit2_iid_crt_hit,
input logic                                                 lsdc1_sq_ex2_cmit3_iid_crt_hit,          
input logic                                                 lsdc1_sq_ex2_cmit4_iid_crt_hit,          
input logic                                                 lsdc1_sq_ex2_cmit5_iid_crt_hit,
input logic                                                 lsdc1_sq_ex2_cmit6_iid_crt_hit,          
input logic                                                 lsdc1_sq_ex2_cmit7_iid_crt_hit,                
input logic                                                 lsdc1_ex2_page_buf,                     
input logic                                                 lsdc1_ex2_page_ca,                      
input logic                                                 lsdc1_ex2_page_sec,                     
input logic                                                 lsdc1_ex2_page_share,                   
input logic                                                 lsdc1_ex2_page_so,                      
input logic                                                 lsdc1_ex2_page_wa,                      
input logic                                                 lsdc1_sq_ex2_dtcm_hit,                        
input logic   [1  :0]                                       lsdc1_sq_ex2_element_size,                    
input logic   [3  :0]                                       lsdc1_ex2_fence_mode,                      
input logic                                                 lsdc1_ex2_icc,                             
input logic   [PREG-1:0]                                    lsdc1_ex2_preg,
input logic                                                 lsdc1_sq_ex2_idx_order,                          
input logic                                                 lsdc1_sq_ex2_inst_flush,                      
input logic   [1  :0]                                       lsdc1_ex2_inst_mode,                       
input logic   [2  :0]                                       lsdc1_ex2_inst_size,                       
input logic   [1  :0]                                       lsdc1_ex2_inst_type,                       
input logic                                                 lsdc1_ex2_inst_vls,                        
input logic                                                 lsdc1_sq_ex2_itcm_hit,                        
input logic                                                 lsdc1_ex2_old,                             
input logic   [15 :0]                                       lsdc1_sq_ex2_rot_sel_rev,                     
input logic   [SDID_LEN-1:0]                                lsdc1_sq_ex2_sdid,                            
input logic                                                 lsdc1_sq_ex2_sdid_hit0, //1->2, 0 for std0, 1 for std1, LTL@20241123 
input logic                                                 lsdc1_sq_ex2_sdid_hit1,                      
input logic                                                 lsdc1_ex2_st_secd,//logic levels opt@LTL                            
input logic                                                 lsdc1_sq_ex2_create_dp_vld,                
input logic                                                 lsdc1_sq_ex2_create_gateclk_en,            
input logic                                                 lsdc1_sq_ex2_create_vld,                   
input logic                                                 lsdc1_sq_ex2_data_vld,                     
input logic                                                 lsdc1_ex2_sync_fence,                      
//input logic   [1  :0]                                       lsdc1_sq_ex2_vsew,  //rvv1.0@hcl  
input logic   [1  :0]  lsdc1_sq_ex2_vmew,  //rvv1.0@hcl
input logic   [1  :0]  lsdc1_sq_ex2_vmop,  //rvv1.0@hcl                        
input logic                                                 lsdc1_sq_ex2_wo_st_inst,
input logic                                                 lsdc1_ex2_dcache_hit,
input logic   [1  :0]                                       lsdc1_ex2_ssp_va,
input logic   [PC_LEN-1:0]                                  lsdc1_ex2_pc,
input logic   [`WK_PA_WIDTH-1 :0]                                       wmb_ce_addr,                           
input logic                                                 wmb_ce_dcache_sw_inst,                 
input logic   [SQ_ENTRY-1:0]                                wmb_ce_sq_ptr,                         
input logic                                                 wmb_ce_vld,                            
input logic                                                 wmb_empty,                             
input logic                                                 wmb_sq_pop_grnt,                       
input logic                                                 wmb_sq_pop_to_ce_grnt,                 
output logic                                                lsu_had_sq_not_empty,                                        
output logic                                                lsu_idu_exx_sq_not_full,                   
output logic                                                lsu_rtu_all_commit_data_vld,           
output logic  [LSIQ_ENTRY-1:0]                              sq_data_depd_wakeup0,//1->3, for 3 ld, LTL@20241024
output logic  [LSIQ_ENTRY-1:0]                              sq_data_depd_wakeup1,
output logic  [LSIQ_ENTRY-1:0]                              sq_data_depd_wakeup2,                   
output logic                                                sq_empty,                                                          
output logic  [LSIQ_ENTRY-1:0]                              sq_global_depd_wakeup0,//1->3, for 3 ld, LTL@20241024
output logic  [LSIQ_ENTRY-1:0]                              sq_global_depd_wakeup1,
output logic  [LSIQ_ENTRY-1:0]                              sq_global_depd_wakeup2,
output logic                                                sq_icc_clr,                            
output logic                                                sq_icc_inv,                            
output logic                                                sq_icc_req,                            
output logic  [127:0]                                       sq_lda0_ex3_fwd_data,//1->3, for 3 ld, LTL@20241024
output logic  [127:0]                                       sq_lsda0_ex3_fwd_data,
output logic  [127:0]                                       sq_lsda1_ex3_fwd_data,
output logic  [127:0]                                       sq_lda0_ex3_fwd_data_pe,//1->3, for 3 ld, LTL@20241024
output logic  [127:0]                                       sq_lsda0_ex3_fwd_data_pe,
output logic  [127:0]                                       sq_lsda1_ex3_fwd_data_pe,
output logic                                                sq_ldc0_ex2_addr1_dep_discard,//1->3, for 3 ld, LTL@20241024
output logic                                                sq_lsdc0_ex2_addr1_dep_discard,            
output logic                                                sq_lsdc1_ex2_addr1_dep_discard,
output logic                                                sq_ldc0_ex2_cancel_acc_req,//1->3, for 3 ld, LTL@20241024
output logic                                                sq_lsdc0_ex2_cancel_acc_req,
output logic                                                sq_lsdc1_ex2_cancel_acc_req,
output logic                                                sq_ldc0_ex2_cancel_ahead_wb,//1->3, for 3 ld, LTL@20241024
output logic                                                sq_lsdc0_ex2_cancel_ahead_wb,
output logic                                                sq_lsdc1_ex2_cancel_ahead_wb,
output logic                                                sq_lda0_ex2_data_discard_req,//1->3, for 3 ld, LTL@20241024
output logic                                                sq_lsda0_ex2_data_discard_req,
output logic                                                sq_lsda1_ex2_data_discard_req,
output logic                                                sq_lda0_ex2_fwd_bypass_multi,//1->3, for 3 ld, LTL@20241024
output logic                                                sq_lsda0_ex2_fwd_bypass_multi,
output logic                                                sq_lsda1_ex2_fwd_bypass_multi,
output logic                                                sq_lda0_ex2_fwd_bypass_req,  //1->3 for 3 ld bypass, LTL@20241024
output logic                                                sq_lsda0_ex2_fwd_bypass_req,               
output logic                                                sq_lsda1_ex2_fwd_bypass_req,
output logic                                                sq_lda0_ex2_fwd_bypass_sel,  //1->3 for 4 ld bypass choose std0 and std1, LTL@20241024
output logic                                                sq_lsda0_ex2_fwd_bypass_sel,               
output logic                                                sq_lsda1_ex2_fwd_bypass_sel,
output logic  [SQ_ENTRY-1:0]                                sq_lda0_ex2_fwd_id,  //1->3, for 3 ld, LTL@20241024
output logic  [SQ_ENTRY-1:0]                                sq_lsda0_ex2_fwd_id,                       
output logic  [SQ_ENTRY-1:0]                                sq_lsda1_ex2_fwd_id,
output logic                                                sq_lda0_ex2_fwd_multi,//1->3, for 3 ld, LTL@20241024
output logic                                                sq_lsda0_ex2_fwd_multi,
output logic                                                sq_lsda1_ex2_fwd_multi,
output logic                                                sq_lda0_ex2_fwd_multi_mask,//1->3, for 3 ld, LTL@20241024
output logic                                                sq_lsda0_ex2_fwd_multi_mask,                
output logic                                                sq_lsda1_ex2_fwd_multi_mask, 
output logic                                                sq_ldc0_ex2_fwd_req,//1->3, for 3 ld, LTL@20241024
output logic                                                sq_lsdc0_ex2_fwd_req, 
output logic                                                sq_lsdc1_ex2_fwd_req, 
output logic                                                sq_ldc0_ex2_has_fwd_req,//1->3, for 3 ld, LTL@20241024
output logic                                                sq_lsdc0_ex2_has_fwd_req,
output logic                                                sq_lsdc1_ex2_has_fwd_req,
output logic                                                sq_lda0_ex2_newest_fwd_data_vld_req,//1->3, for 3 ld, LTL@20241024
output logic                                                sq_lsda0_ex2_newest_fwd_data_vld_req,
output logic                                                sq_lsda1_ex2_newest_fwd_data_vld_req,
output logic                                                sq_lda0_ex2_other_discard_req,//1->3, for 3 ld, LTL@20241024
output logic                                                sq_lsda0_ex2_other_discard_req,
output logic                                                sq_lsda1_ex2_other_discard_req,
output logic                                                sq_pfu_pop_synci_inst,                 
output logic  [`WK_PA_WIDTH-1 :0]                                       sq_pop_addr,                           
output logic                                                sq_pop_atomic,                         
output logic  [15 :0]                                       sq_pop_bytes_vld,                      
output logic                                                sq_pop_dcache_1line_inst,              
output logic                                                sq_pop_dtcm_hit,                       
output logic                                                sq_pop_icc,                            
output logic  [PREG-1:0]                                    sq_pop_preg,         
output logic                                                sq_pop_inst_flush,                     
output logic  [1  :0]                                       sq_pop_inst_mode,                      
output logic  [2  :0]                                       sq_pop_inst_size,                      
output logic  [1  :0]                                       sq_pop_inst_type,                      
output logic                                                sq_pop_itcm_hit,                       
output logic                                                sq_pop_page_buf,                       
output logic                                                sq_pop_page_ca,                        
output logic                                                sq_pop_page_sec,                       
output logic                                                sq_pop_page_share,                     
output logic                                                sq_pop_page_so,                        
output logic                                                sq_pop_page_wa,                        
output logic  [1  :0]                                       sq_pop_priv_mode,                      
output logic  [SQ_ENTRY-1:0]                                sq_pop_ptr,  //parameter, LTL@20241022                          
output logic                                                sq_pop_st_inst,                        
output logic                                                sq_pop_sync_fence,                     
output logic                                                sq_pop_wo_st,
output logic                                                sq_pop_init_dcache_miss,
output logic  [1  :0]                                       sq_pop_ssp_va,
output logic  [PC_LEN-1:0]                                  sq_pop_pc_index,
output logic                                                sq_lsdc0_ex2_full,
output logic                                                sq_lsdc1_ex2_full,
output logic                                                sq_lsdc0_ex2_inst_hit,
output logic                                                sq_lsdc1_ex2_inst_hit,
output logic                                                sq_wmb_merge_req,                      
output logic                                                sq_wmb_merge_stall_req,                
output logic                                                sq_wmb_pop_to_ce_dp_req,               
output logic                                                sq_wmb_pop_to_ce_gateclk_en,           
output logic                                                sq_wmb_pop_to_ce_req,                  
output logic                                                sq_wmb_write_imme,                                         
output logic                                                wmb_ce_create_hit_rb_idx,              
output logic  [127:0]                                       wmb_ce_data128,                        
output logic                                                wmb_ce_dcache_share,                   
output logic                                                wmb_ce_dcache_valid,                   
output logic  [3  :0]                                       wmb_ce_fence_mode,                     
output logic  [IID_WIDTH-1:0]                               wmb_ce_iid,                            
output logic                                                wmb_ce_lm_fail,                        
output logic                                                wmb_ce_spec_fail,                      
output logic                                                wmb_ce_update_dcache_dirty,            
output logic                                                wmb_ce_update_dcache_page_share,       
output logic                                                wmb_ce_update_dcache_share,            
output logic                                                wmb_ce_update_dcache_valid,            
output logic  [1  :0]                                       wmb_ce_update_dcache_way,              
output logic                                                wmb_ce_vstart_vld,
output logic                                                sq_send_st_stride_init_dcache_miss,
output logic                                                sq_send_st_stride_page_ca,
output logic                                                sq_send_st_stride_page_sec,
output logic                                                sq_send_st_stride_page_share,
output logic  [1:0]                                         sq_send_st_stride_va,
output logic  [PC_LEN-1:0]                                  sq_send_st_stride_pc_index,
output logic  [WK_PA_WIDTH-1:0]                             sq_send_st_stride_addr0,
output logic                                                sq_send_st_stride_vld,
output logic                                                sq_send_st_stride_wo_st,
//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
input  logic                                                dtu_lsu_data_trig_en,      
input  logic  [`TDT_MP_HINFO_WIDTH-1:0]                     dtu_lsu_ls0_addr_halt_info,
input  logic  [`TDT_MP_HINFO_WIDTH-1:0]                     dtu_lsu_ls1_addr_halt_info,
input  logic  [`TDT_MP_HINFO_WIDTH-1:0]                     dtu_lsu_ls0_data_halt_info,
input  logic  [`TDT_MP_HINFO_WIDTH-1:0]                     dtu_lsu_ls1_data_halt_info,
input  logic                                                ls0_st_da_already_da,
input  logic                                                ls1_st_da_already_da,
input  logic                                                ls0_st_da_data_check,
input  logic                                                ls1_st_da_data_check,
input  logic                                                ls0_st_da_wb_expt_vld_cancel,
input  logic                                                ls1_st_da_wb_expt_vld_cancel,
output logic  [127:0]                                       lsu_dtu_data0,
output logic  [16 :0]                                       lsu_dtu_data_halt_info0,
output logic  [2  :0]                                       lsu_dtu_data_size0,
output logic  [1  :0]                                       lsu_dtu_data_type0,
output logic                                                lsu_dtu_data_vld0,
output logic  [127:0]                                       lsu_dtu_data1,
output logic  [16 :0]                                       lsu_dtu_data_halt_info1,
output logic  [2  :0]                                       lsu_dtu_data_size1,
output logic  [1  :0]                                       lsu_dtu_data_type1,
output logic                                                lsu_dtu_data_vld1,
output logic  [`TDT_MP_HINFO_WIDTH-1:0]                     wmb_ce_halt_info_0,
output logic  [`TDT_MP_HINFO_WIDTH-1:0]                     wmb_ce_halt_info_1,
output logic                                                wmb_ce_expt_vld
//==========================================================
//                  Risc-V Debug zdb End 
//==========================================================
);

                  

// &Regs; @32
logic     [SQ_ENTRY-1:0]                                    sq_create_ptr0;  //1-> LTL
logic     [SQ_ENTRY-1:0]                                    sq_create_ptr1;                         
logic     [SQ_ENTRY-1:0]                                    sq_data_discard_id_sel0;   //1->3  parameter, LTL@20241022  
logic     [SQ_ENTRY-1:0]                                    sq_data_discard_id_sel1;
logic     [SQ_ENTRY-1:0]                                    sq_data_discard_id_sel2;
logic     [127:0]                                           sq_data_ori0;
logic     [127:0]                                           sq_data_ori1;                           
logic     [SQ_ENTRY-1:0]                                    sq_dbg_pop_ptr;   //parameter, LTL@20241022                         
logic     [`WK_PA_WIDTH-1 :0]                               sq_dbg_st_addr;                        
logic     [`WK_PA_WIDTH-1 :0]                               sq_dbg_st_addr_ff;                     
logic     [15 :0]                                           sq_dbg_st_bytes_vld;                   
logic     [63 :0]                                           sq_dbg_st_data;                        
logic     [63 :0]                                           sq_dbg_st_data_ff;                     
logic     [IID_WIDTH-1:0]                                   sq_dbg_st_iid;                         
logic     [IID_WIDTH-1:0]                                   sq_dbg_st_iid_ff;                      
logic                                                       sq_dbg_st_req;                         
logic                                                       sq_dbg_st_req_ff;                      
logic     [127:0]                                           sq_fwd_data_pe0;//1->3 LTL@120241023
logic     [127:0]                                           sq_fwd_data_pe1;
logic     [127:0]                                           sq_fwd_data_pe2;                      
logic     [127:0]                                           sq_fwd_data_sel0;//1->3 LTL@120241016
logic     [127:0]                                           sq_fwd_data_sel1; 
logic     [127:0]                                           sq_fwd_data_sel2; 
logic                                                       sq_fwd_multi0;   //1->3 LTL@120241016
logic                                                       sq_fwd_multi1;  
logic                                                       sq_fwd_multi2;     
logic     [`WK_PA_WIDTH-1 :0]                               sq_pe_age_vec_surplus1_addr;           
logic     [15 :0]                                           sq_pe_age_vec_surplus1_bytes_vld;      
logic     [`WK_PA_WIDTH-1 :0]                               sq_pe_age_vec_zero_addr;               
logic     [15 :0]                                           sq_pe_age_vec_zero_bytes_vld;                        
logic                                                       sq_req_icc_success;                    
logic     [LSIQ_ENTRY-1:0]                                  sq_wakeup_queue0;  //1->3 LTL@120241016
logic     [LSIQ_ENTRY-1:0]                                  sq_wakeup_queue1;  //parameter, LTL@20241022  
logic     [LSIQ_ENTRY-1:0]                                  sq_wakeup_queue2;                                         

// &Wires; @33      
logic                                                       lsdc0_older_than_lsdc1; //newly add signal, 2 lsdc compare in ex1, ex2 send to sq, LTL@20241016                                                                               
logic                                                       lsu_rtu_all_commit_st_data_vld;                                                                       
logic                                                       sq_age_vec_set;                        
logic                                                       sq_clk;                                
logic                                                       sq_clk_en;                             
logic    [SQ_ENTRY-1:0]                                     sq_create_age_vec0;       //modified by LTL@20241015
logic    [SQ_ENTRY-1:0]                                     sq_create_age_vec1;      //added by LTL@20241015                 
logic                                                       sq_create_pop_clk;                     
logic                                                       sq_create_pop_clk_en;                  
logic                                                       sq_create_same_addr_newest0;       //modified by LTL@20241015
logic                                                       sq_create_same_addr_newest1;        //added by LTL@20241015
logic                                                       lsdc_lsdc_same_addr_newer0;        //added by LTL@20241015
logic                                                       lsdc_lsdc_same_addr_newer1;        //added by LTL@20241015           
logic                                                       sq_create_success0;               //modified by LTL@20241015
logic                                                       sq_create_success1;               //added by LTL@20241015
logic                                                       sq_less2_need_discard_st0;        //added by LTL@20241015
logic                                                       sq_less2_need_discard_st1;        //added by LTL@20241015 
logic                                                       sq_empty2_need_discard_st0;       //added by LTL@20241113
logic                                                       sq_empty2_need_discard_st1;   
logic                                                       sq_create_req2_need_discard_st0;
logic                                                       sq_create_req2_need_discard_st1;                 
logic    [SQ_ENTRY-1:0]                                     sq_create_vld0;       //modified by LTL@20241016
logic    [SQ_ENTRY-1:0]                                     sq_create_vld1;       //added by LTL@20241016                  
logic    [127:0]                                            sq_data_after_rot0;   //1->2  LTL@202410116
logic    [127:0]                                            sq_data_after_rot1;                      
logic                                                       sq_data_discard_has_newest0;//1->3, for 3 ld, LTL@20241024
logic                                                       sq_data_discard_has_newest1; 
logic                                                       sq_data_discard_has_newest2; 
logic    [SQ_ENTRY-1:0]                                     sq_data_discard_newest_id0;  //1->3, for 3 ld, LTL@20241024
logic    [SQ_ENTRY-1:0]                                     sq_data_discard_newest_id1;
logic    [SQ_ENTRY-1:0]                                     sq_data_discard_newest_id2;
logic                                                       sq_data_discard_req0;//1->3, for 3 ld, LTL@20241024
logic                                                       sq_data_discard_req1; 
logic                                                       sq_data_discard_req2;                    
logic                                                       sq_data_discard_req_short0;//1->3, for 3 ld, LTL@20241024
logic                                                       sq_data_discard_req_short1;
logic                                                       sq_data_discard_req_short2;            
logic    [127:0]                                            sq_data_settle0;   //1->2 LTL@120241016
logic    [127:0]                                            sq_data_settle1;                         
logic                                                       sq_dbg_clk;                            
logic                                                       sq_dbg_clk_en;                         
logic    [127:0]                                            sq_dbg_st_bytes_vld_extend;            
logic    [127:0]                                            sq_dbg_st_data_after_mask;             
logic    [63 :0]                                            sq_dbg_st_data_compress64;             
logic                                                       sq_empty_less2;   
logic                                                       sq_has_only2_empty;
logic    [SQ_ENTRY-1:0]                                     sq_empty_count;                     
//logic    [39 :0]  sq_entry_addr0_0;                      
//logic    [39 :0]  sq_entry_addr0_1;                             
//logic    [39 :0]  sq_entry_addr0_2;                      
//logic    [39 :0]  sq_entry_addr0_3;                      
//logic    [39 :0]  sq_entry_addr0_4;                      
//logic    [39 :0]  sq_entry_addr0_5;                      
//logic    [39 :0]  sq_entry_addr0_6;                      
//logic    [39 :0]  sq_entry_addr0_7;                      
//logic    [39 :0]  sq_entry_addr0_8;                      
//logic    [39 :0]  sq_entry_addr0_9;
//logic    [39 :0]  sq_entry_addr0_10;                     
//logic    [39 :0]  sq_entry_addr0_11;
logic    [SQ_ENTRY-1:0][`WK_PA_WIDTH-1:0]                   sq_entry_addr0;  //parameter LTL@20241022
logic    [SQ_ENTRY-1:0]                                     sq_entry_addr1_dep_discard0; //1->3, for 3 ld, LTL@20241024
logic    [SQ_ENTRY-1:0]                                     sq_entry_addr1_dep_discard1; 
logic    [SQ_ENTRY-1:0]                                     sq_entry_addr1_dep_discard2;             
logic    [SQ_ENTRY-1:0]                                     sq_entry_age_vec_surplus1_ptr; //parameter, LTL@20241022       
logic    [SQ_ENTRY-1:0]                                     sq_entry_age_vec_zero_ptr;             
logic    [SQ_ENTRY-1:0]                                     sq_entry_atomic;                                        
//logic    [15 :0]  sq_entry_bytes_vld_0;   //parameter, LTL@20241022                   
//logic    [15 :0]  sq_entry_bytes_vld_1;                                   
//logic    [15 :0]  sq_entry_bytes_vld_2;                  
//logic    [15 :0]  sq_entry_bytes_vld_3;                  
//logic    [15 :0]  sq_entry_bytes_vld_4;                  
//logic    [15 :0]  sq_entry_bytes_vld_5;                  
//logic    [15 :0]  sq_entry_bytes_vld_6;                  
//logic    [15 :0]  sq_entry_bytes_vld_7;                  
//logic    [15 :0]  sq_entry_bytes_vld_8;                  
//logic    [15 :0]  sq_entry_bytes_vld_9;
//logic    [15 :0]  sq_entry_bytes_vld_10;                 
//logic    [15 :0]  sq_entry_bytes_vld_11;  
logic    [SQ_ENTRY-1:0][15 :0]                              sq_entry_bytes_vld;  //parameter for sq_entry_bytes_vld_0-11, LTL@20241022                
logic    [SQ_ENTRY-1:0]                                     sq_entry_cancel_acc_req0;   //1->3, parameter, LTL@20241022               
logic    [SQ_ENTRY-1:0]                                     sq_entry_cancel_acc_req1;
logic    [SQ_ENTRY-1:0]                                     sq_entry_cancel_acc_req2;
logic    [SQ_ENTRY-1:0]                                     sq_entry_cancel_ahead_wb0;//1->3, for 3 ld, LTL@20241024
logic    [SQ_ENTRY-1:0]                                     sq_entry_cancel_ahead_wb1;
logic    [SQ_ENTRY-1:0]                                     sq_entry_cancel_ahead_wb2;            
logic    [SQ_ENTRY-1:0]                                     sq_entry_cmit;                         
logic    [SQ_ENTRY-1:0]                                     sq_entry_cmit_data_vld;                
logic    [SQ_ENTRY-1:0]                                     sq_entry_create_dp_vld0;  //1->2  LTL@20241016
logic    [SQ_ENTRY-1:0]                                     sq_entry_create_dp_vld1;                
logic    [SQ_ENTRY-1:0]                                     sq_entry_create_gateclk_en0;  //1->2  LTL@20241016
logic    [SQ_ENTRY-1:0]                                     sq_entry_create_gateclk_en1;            
logic    [SQ_ENTRY-1:0]                                     sq_entry_create_vld0;
logic    [SQ_ENTRY-1:0]                                     sq_entry_create_vld1;  //added by LTL@20241016                   
//logic    [127:0]  sq_entry_data_0;                       
//logic    [127:0]  sq_entry_data_1;                                            
//logic    [127:0]  sq_entry_data_2;                       
//logic    [127:0]  sq_entry_data_3;                       
//logic    [127:0]  sq_entry_data_4;                       
//logic    [127:0]  sq_entry_data_5;                       
//logic    [127:0]  sq_entry_data_6;                       
//logic    [127:0]  sq_entry_data_7;                       
//logic    [127:0]  sq_entry_data_8;                       
//logic    [127:0]  sq_entry_data_9;
//logic    [127:0]  sq_entry_data_10;                      
//logic    [127:0]  sq_entry_data_11;
logic    [SQ_ENTRY-1:0][127:0]                              sq_entry_data; //parameterized, LTL@20241022
//logic    [11 :0]  sq_entry_data_depd_wakeup_0;  //use array, LTL@20241022
//logic    [11 :0]  sq_entry_data_depd_wakeup_1; 
//logic    [11 :0]  sq_entry_data_depd_wakeup_2; 
//logic    [11 :0]  sq_entry_data_depd_wakeup_3; 
//logic    [11 :0]  sq_entry_data_depd_wakeup_4; 
//logic    [11 :0]  sq_entry_data_depd_wakeup_5; 
//logic    [11 :0]  sq_entry_data_depd_wakeup_6; 
//logic    [11 :0]  sq_entry_data_depd_wakeup_7; 
//logic    [11 :0]  sq_entry_data_depd_wakeup_8; 
//logic    [11 :0]  sq_entry_data_depd_wakeup_9;
//logic    [11 :0]  sq_entry_data_depd_wakeup_10;
//logic    [11 :0]  sq_entry_data_depd_wakeup_11;
logic    [SQ_ENTRY-1:0][LSIQ_ENTRY-1:0]                     sq_entry_data_depd_wakeup0;     //1->3, for 3 ld, LTL@20241024     
logic    [SQ_ENTRY-1:0][LSIQ_ENTRY-1:0]                     sq_entry_data_depd_wakeup1; 
logic    [SQ_ENTRY-1:0][LSIQ_ENTRY-1:0]                     sq_entry_data_depd_wakeup2; 
logic    [SQ_ENTRY-1:0]                                     sq_entry_data_discard_grnt0;  //1->3, for 3 ld, LTL@20241024
logic    [SQ_ENTRY-1:0]                                     sq_entry_data_discard_grnt1;
logic    [SQ_ENTRY-1:0]                                     sq_entry_data_discard_grnt2;           
logic    [SQ_ENTRY-1:0]                                     sq_entry_data_discard_req0;  //1->3  LTL@20240616 
logic    [SQ_ENTRY-1:0]                                     sq_entry_data_discard_req1; 
logic    [SQ_ENTRY-1:0]                                     sq_entry_data_discard_req2;            
logic    [SQ_ENTRY-1:0]                                     sq_entry_data_discard_req_short0;//1->3, for 3 ld, LTL@20241024
logic    [SQ_ENTRY-1:0]                                     sq_entry_data_discard_req_short1; 
logic    [SQ_ENTRY-1:0]                                     sq_entry_data_discard_req_short2;        
logic    [SQ_ENTRY-1:0]                                     sq_entry_dcache_dirty;                 
logic    [SQ_ENTRY-1:0]                                     sq_entry_dcache_info_vld;              
logic    [SQ_ENTRY-1:0]                                     sq_entry_dcache_page_share;            
logic    [SQ_ENTRY-1:0]                                     sq_entry_dcache_share;                 
logic    [SQ_ENTRY-1:0]                                     sq_entry_dcache_valid;                 
logic    [SQ_ENTRY-1:0][1:0]                                sq_entry_dcache_way;                   
logic    [SQ_ENTRY-1:0]                                     sq_entry_depd;                         
logic    [SQ_ENTRY-1:0]                                     sq_entry_depd_set;                     
logic    [SQ_ENTRY-1:0]                                     sq_entry_discard_req0;     //1->3  LTL@20241022  
logic    [SQ_ENTRY-1:0]                                     sq_entry_discard_req1; 
logic    [SQ_ENTRY-1:0]                                     sq_entry_discard_req2;                   
logic    [SQ_ENTRY-1:0]                                     sq_entry_dtcm_hit;                     
//logic    [1  :0]  sq_entry_element_size_0;       //use array for para,  LTL@20241022        
//logic    [1  :0]  sq_entry_element_size_1;                             
//logic    [1  :0]  sq_entry_element_size_2;               
//logic    [1  :0]  sq_entry_element_size_3;               
//logic    [1  :0]  sq_entry_element_size_4;               
//logic    [1  :0]  sq_entry_element_size_5;               
//logic    [1  :0]  sq_entry_element_size_6;               
//logic    [1  :0]  sq_entry_element_size_7;               
//logic    [1  :0]  sq_entry_element_size_8;               
//logic    [1  :0]  sq_entry_element_size_9;
//logic    [1  :0]  sq_entry_element_size_10;              
//logic    [1  :0]  sq_entry_element_size_11;
logic    [SQ_ENTRY-1:0][1:0]                                sq_entry_element_size; //no need 1->2, for 2 st_data, LTL@20241022   
logic    [SQ_ENTRY-1:0]                                     sq_entry_expt_nop;                     
//logic    [3  :0]  sq_entry_fence_mode_0;                 
//logic    [3  :0]  sq_entry_fence_mode_1;                                 
//logic    [3  :0]  sq_entry_fence_mode_2;                 
//logic    [3  :0]  sq_entry_fence_mode_3;                 
//logic    [3  :0]  sq_entry_fence_mode_4;                 
//logic    [3  :0]  sq_entry_fence_mode_5;                 
//logic    [3  :0]  sq_entry_fence_mode_6;                 
//logic    [3  :0]  sq_entry_fence_mode_7;                 
//logic    [3  :0]  sq_entry_fence_mode_8;                 
//logic    [3  :0]  sq_entry_fence_mode_9;
//logic    [3  :0]  sq_entry_fence_mode_10;                
//logic    [3  :0]  sq_entry_fence_mode_11;
logic    [SQ_ENTRY-1:0][3:0]                                sq_entry_fence_mode;  //array for parameter, LTL@20241023
logic    [SQ_ENTRY-1:0]                                     sq_entry_fwd_bypass_req0;   //1->3  LTL@20241016
logic    [SQ_ENTRY-1:0]                                     sq_entry_fwd_bypass_req1;
logic    [SQ_ENTRY-1:0]                                     sq_entry_fwd_bypass_req2;
logic    [SQ_ENTRY-1:0]                                     sq_entry_fwd_bypass_req_sel_0;   //1->3  LTL@20241016
logic    [SQ_ENTRY-1:0]                                     sq_entry_fwd_bypass_req_sel_1;
logic    [SQ_ENTRY-1:0]                                     sq_entry_fwd_bypass_req_sel_2;
logic    [SQ_ENTRY-1:0]                                     sq_entry_fwd_bypass_req0_newer;
logic    [SQ_ENTRY-1:0]                                     sq_entry_fwd_bypass_req1_newer;
logic    [SQ_ENTRY-1:0]                                     sq_entry_fwd_bypass_req2_newer;
logic    [SQ_ENTRY-1:0]                                     sq_entry_older_than_ldc0_same_addr_newest;
logic    [SQ_ENTRY-1:0]                                     sq_entry_older_than_lsdc0_same_addr_newest;
logic    [SQ_ENTRY-1:0]                                     sq_entry_older_than_lsdc1_same_addr_newest;
logic    [SQ_ENTRY-1:0]                                     sq_entry_fwd_multi_depd_set0; //1->3  LTL@20241016
logic    [SQ_ENTRY-1:0]                                     sq_entry_fwd_multi_depd_set1;
logic    [SQ_ENTRY-1:0]                                     sq_entry_fwd_multi_depd_set2;          
logic    [SQ_ENTRY-1:0]                                     sq_entry_fwd_req0; //1->3  LTL@20241016
logic    [SQ_ENTRY-1:0]                                     sq_entry_fwd_req1;
logic    [SQ_ENTRY-1:0]                                     sq_entry_fwd_req2;                     
logic    [SQ_ENTRY-1:0]                                     sq_entry_icc;                          
logic    [SQ_ENTRY-1:0][PREG-1:0]                           sq_entry_preg;
logic    [SQ_ENTRY-1:0]                                     sq_entry_idx_order;                    
//logic    [IID_WIDTH-1:0]  sq_entry_iid_0;     //use array, LTL@20241022                   
//logic    [IID_WIDTH-1:0]  sq_entry_iid_1;                                          
//logic    [IID_WIDTH-1:0]  sq_entry_iid_2;                        
//logic    [IID_WIDTH-1:0]  sq_entry_iid_3;                        
//logic    [IID_WIDTH-1:0]  sq_entry_iid_4;                        
//logic    [IID_WIDTH-1:0]  sq_entry_iid_5;                        
//logic    [IID_WIDTH-1:0]  sq_entry_iid_6;                        
//logic    [IID_WIDTH-1:0]  sq_entry_iid_7;                        
//logic    [IID_WIDTH-1:0]  sq_entry_iid_8;                        
//logic    [IID_WIDTH-1:0]  sq_entry_iid_9;
//logic    [IID_WIDTH-1:0]  sq_entry_iid_10;                       
//logic    [IID_WIDTH-1:0]  sq_entry_iid_11; 
logic    [SQ_ENTRY-1:0][IID_WIDTH-1:0]                      sq_entry_iid; //use array, LTL@20241022 
logic    [SQ_ENTRY-1:0]                                     sq_entry_inst_flush;                   
logic    [SQ_ENTRY-1:0]                                     sq_entry_inst_hit0;       //1->2 for 2 st_data, LTL@20241022 
logic    [SQ_ENTRY-1:0]                                     sq_entry_inst_hit1;
//logic    [1  :0]  sq_entry_inst_mode_0;               
//logic    [1  :0]  sq_entry_inst_mode_1;                              
//logic    [1  :0]  sq_entry_inst_mode_2;                  
//logic    [1  :0]  sq_entry_inst_mode_3;                  
//logic    [1  :0]  sq_entry_inst_mode_4;                  
//logic    [1  :0]  sq_entry_inst_mode_5;                  
//logic    [1  :0]  sq_entry_inst_mode_6;                  
//logic    [1  :0]  sq_entry_inst_mode_7;                  
//logic    [1  :0]  sq_entry_inst_mode_8;                  
//logic    [1  :0]  sq_entry_inst_mode_9;
//logic    [1  :0]  sq_entry_inst_mode_10;                 
//logic    [1  :0]  sq_entry_inst_mode_11;
logic    [SQ_ENTRY-1:0][1:0]                                sq_entry_inst_mode; //use array, LTL@20241022                  
//logic    [2  :0]  sq_entry_inst_size_0;                  
//logic    [2  :0]  sq_entry_inst_size_1;                                   
//logic    [2  :0]  sq_entry_inst_size_2;                  
//logic    [2  :0]  sq_entry_inst_size_3;                  
//logic    [2  :0]  sq_entry_inst_size_4;                  
//logic    [2  :0]  sq_entry_inst_size_5;                  
//logic    [2  :0]  sq_entry_inst_size_6;                  
//logic    [2  :0]  sq_entry_inst_size_7;                  
//logic    [2  :0]  sq_entry_inst_size_8;                  
//logic    [2  :0]  sq_entry_inst_size_9;
//logic    [2  :0]  sq_entry_inst_size_10;                 
//logic    [2  :0]  sq_entry_inst_size_11;
logic    [SQ_ENTRY-1:0][2:0]                                sq_entry_inst_size; //use array, LTL@20241022
//logic    [1  :0]  sq_entry_inst_type_0;                  
//logic    [1  :0]  sq_entry_inst_type_1;                                   
//logic    [1  :0]  sq_entry_inst_type_2;                  
//logic    [1  :0]  sq_entry_inst_type_3;                  
//logic    [1  :0]  sq_entry_inst_type_4;                  
//logic    [1  :0]  sq_entry_inst_type_5;                  
//logic    [1  :0]  sq_entry_inst_type_6;                  
//logic    [1  :0]  sq_entry_inst_type_7;                  
//logic    [1  :0]  sq_entry_inst_type_8;                  
//logic    [1  :0]  sq_entry_inst_type_9; 
//logic    [1  :0]  sq_entry_inst_type_10;                 
//logic    [1  :0]  sq_entry_inst_type_11;
logic    [SQ_ENTRY-1:0][1:0]                                sq_entry_inst_type; //use array, LTL@20241022
logic    [SQ_ENTRY-1:0]                                     sq_entry_inst_vls;  //no need 1->2  LTL@20241016             
logic    [SQ_ENTRY-1:0]                                     sq_entry_itcm_hit;                     
logic    [SQ_ENTRY-1:0]                                     sq_entry_lm_fail;                      
logic    [SQ_ENTRY-1:0]                                     sq_entry_newest_fwd_req_data_vld0;//1->3  LTL@20241016
logic    [SQ_ENTRY-1:0]                                     sq_entry_newest_fwd_req_data_vld1;
logic    [SQ_ENTRY-1:0]                                     sq_entry_newest_fwd_req_data_vld2;      
logic    [SQ_ENTRY-1:0]                                     sq_entry_newest_fwd_req_data_vld_short0;//1->3  LTL@20241016
logic    [SQ_ENTRY-1:0]                                     sq_entry_newest_fwd_req_data_vld_short1;
logic    [SQ_ENTRY-1:0]                                     sq_entry_newest_fwd_req_data_vld_short2;
logic    [SQ_ENTRY-1:0]                                     sq_entry_page_buf;                     
logic    [SQ_ENTRY-1:0]                                     sq_entry_page_ca;                      
logic    [SQ_ENTRY-1:0]                                     sq_entry_page_sec;                     
logic    [SQ_ENTRY-1:0]                                     sq_entry_page_share;                   
logic    [SQ_ENTRY-1:0]                                     sq_entry_page_so;                      
logic    [SQ_ENTRY-1:0]                                     sq_entry_page_wa;                      
logic    [SQ_ENTRY-1:0]                                     sq_entry_pop_req;                      
logic    [SQ_ENTRY-1:0]                                     sq_entry_pop_to_ce_grnt;               
logic    [SQ_ENTRY-1:0]                                     sq_entry_pop_to_ce_grnt_b;             
//logic    [1  :0]  sq_entry_priv_mode_0;                  
//logic    [1  :0]  sq_entry_priv_mode_1;                                   
//logic    [1  :0]  sq_entry_priv_mode_2;                  
//logic    [1  :0]  sq_entry_priv_mode_3;                  
//logic    [1  :0]  sq_entry_priv_mode_4;                  
//logic    [1  :0]  sq_entry_priv_mode_5;                  
//logic    [1  :0]  sq_entry_priv_mode_6;                  
//logic    [1  :0]  sq_entry_priv_mode_7;                  
//logic    [1  :0]  sq_entry_priv_mode_8;                  
//logic    [1  :0]  sq_entry_priv_mode_9;
//logic    [1  :0]  sq_entry_priv_mode_10;                 
//logic    [1  :0]  sq_entry_priv_mode_11;
logic    [SQ_ENTRY-1:0][1:0]                                sq_entry_priv_mode; //use array, LTL@20241022                 
//logic    [15 :0]  sq_entry_rot_sel_0;        //1->2  LTL@20241016              
//logic    [15 :0]  sq_entry_rot_sel_1;                                       
//logic    [15 :0]  sq_entry_rot_sel_2;                    
//logic    [15 :0]  sq_entry_rot_sel_3;                    
//logic    [15 :0]  sq_entry_rot_sel_4;                    
//logic    [15 :0]  sq_entry_rot_sel_5;                    
//logic    [15 :0]  sq_entry_rot_sel_6;                    
//logic    [15 :0]  sq_entry_rot_sel_7;                    
//logic    [15 :0]  sq_entry_rot_sel_8;                    
//logic    [15 :0]  sq_entry_rot_sel_9;
//logic    [15 :0]  sq_entry_rot_sel_10;                   
//logic    [15 :0]  sq_entry_rot_sel_11;
logic    [SQ_ENTRY-1:0][15:0]                               sq_entry_rot_sel; //use array, LTL@20241022   
logic    [SQ_ENTRY-1:0]                                     sq_entry_same_addr_newest;             
logic    [SQ_ENTRY-1:0]                                     sq_entry_settle_data_hit0;  //1->2  LTL@20241016
logic    [SQ_ENTRY-1:0]                                     sq_entry_settle_data_hit1;              
logic    [SQ_ENTRY-1:0]                                     sq_entry_spec_fail;                    
logic    [SQ_ENTRY-1:0]                                     sq_entry_lsdc0_create_age_vec; //1->2  LTL@20241017        
logic    [SQ_ENTRY-1:0]                                     sq_entry_lsdc1_create_age_vec; 
logic    [SQ_ENTRY-1:0]                                     sq_entry_lsdc0_same_addr_newer;  //modified  support 2 st dc newest addr comparison LTL 
logic    [SQ_ENTRY-1:0]                                     sq_entry_lsdc1_same_addr_newer;  //modified   LTL 
logic    [SQ_ENTRY-1:0]                                     sq_entry_ldc0_same_addr_older;
logic    [SQ_ENTRY-1:0]                                     sq_entry_lsdc0_same_addr_older;
logic    [SQ_ENTRY-1:0]                                     sq_entry_lsdc1_same_addr_older;
logic    [SQ_ENTRY-1:0]                                     sq_entry_sync_fence;                   
logic    [SQ_ENTRY-1:0]                                     sq_entry_vld;                          
//logic    [1  :0]  sq_entry_vsew_0;    //1->2  LTL@20241016                    
//logic    [1  :0]  sq_entry_vsew_1;                                            
//logic    [1  :0]  sq_entry_vsew_2;                       
//logic    [1  :0]  sq_entry_vsew_3;                       
//logic    [1  :0]  sq_entry_vsew_4;                       
//logic    [1  :0]  sq_entry_vsew_5;                       
//logic    [1  :0]  sq_entry_vsew_6;                       
//logic    [1  :0]  sq_entry_vsew_7;                       
//logic    [1  :0]  sq_entry_vsew_8;                       
//logic    [1  :0]  sq_entry_vsew_9;
//logic    [1  :0]  sq_entry_vsew_10;                      
//logic    [1  :0]  sq_entry_vsew_11;
//logic    [SQ_ENTRY-1:0][1:0]                                sq_entry_vsew; //use array, 1->2 for 2 st_data, LTL@20241112  //rvv1.0@hcl
logic    [SQ_ENTRY-1:0][1:0] sq_entry_vmew;//rvv1.0@hcl
logic    [SQ_ENTRY-1:0][1:0] sq_entry_vmop;//rvv1.0@hcl       
logic    [SQ_ENTRY-1:0]                                     sq_entry_vstart_vld;                   
logic    [SQ_ENTRY-1:0]                                     sq_entry_wakeup_queue_set_id0;  //1->3, for 3 ld, LTL@20241024
logic    [SQ_ENTRY-1:0]                                     sq_entry_wakeup_queue_set_id1;
logic    [SQ_ENTRY-1:0]                                     sq_entry_wakeup_queue_set_id2;          
logic    [SQ_ENTRY-1:0]                                     sq_entry_wo_st;
logic    [SQ_ENTRY-1:0]                                     sq_entry_init_dcache_miss;     //for st stride pfu, LTL@20250507                   
logic    [SQ_ENTRY-1:0][1:0]                                sq_entry_ssp_va;
logic    [SQ_ENTRY-1:0][PC_LEN-1:0]                         sq_entry_pc_index;
logic    [SQ_ENTRY-1:0]                                     sq_entry_already_st_stride_vec;
logic    [SQ_ENTRY-1:0]                                     sq_entry_already_send_st_stride;
logic    [SQ_ENTRY-1:0]                                     sq_entry_st_stride_age_vec_zero_ptr;

//logic                     sq_send_st_stride_init_dcache_miss;
//logic                     sq_send_st_stride_page_sec;
//logic                     sq_send_st_stride_page_share;
//logic    [1:0]            sq_send_st_stride_va;
//logic    [PC_LEN-1:0]     sq_send_st_stride_pc_index;
//logic    [WK_PA_WIDTH-1:0] sq_send_st_stride_addr0;
logic                                                       rtu_ck_flush_iid_older_than_lsdc0;
logic                                                       rtu_ck_flush_iid_older_than_lsdc1;
logic                                                       sq_full;                               
logic                                                       sq_fwd_bypass_req0; //fwd 1->3  LTL@20241016
logic                                                       sq_fwd_bypass_req1;
logic                                                       sq_fwd_bypass_req2;                   
logic                                                       sq_fwd_data_pe_clk0;//fwd 1->3  LTL@20241016
logic                                                       sq_fwd_data_pe_clk1;
logic                                                       sq_fwd_data_pe_clk2;
logic                                                       sq_fwd_data_pe_clk_en0;//fwd 1->3  LTL@20241016
logic                                                       sq_fwd_data_pe_clk_en1;
logic                                                       sq_fwd_data_pe_clk_en2;
logic                                                       sq_fwd_data_pe_req0; //fwd 1->3  LTL@20241022
logic                                                       sq_fwd_data_pe_req1;
logic                                                       sq_fwd_data_pe_req2;
logic                                                       sq_fwd_req0; //fwd 1->3  LTL@20241022
logic                                                       sq_fwd_req1;                            
logic                                                       sq_fwd_req2;
logic    [SQ_ENTRY-1:0]                                     sq_fwd_req_id0; //fwd 1->3  LTL@20241022
logic    [SQ_ENTRY-1:0]                                     sq_fwd_req_id1;                                         
logic    [SQ_ENTRY-1:0]                                     sq_fwd_req_id2;
logic                                                       sq_has_cmit;                                                                 
logic                                                       sq_newest_fwd_bypass_req0;  //fwd 1->3  LTL@20241016
logic                                                       sq_newest_fwd_bypass_req1;
logic                                                       sq_newest_fwd_bypass_req2;             
logic                                                       sq_newest_fwd_req0;          //fwd 1->3  LTL@20241016
logic                                                       sq_newest_fwd_req1;
logic                                                       sq_newest_fwd_req2;                    
logic                                                       sq_newest_fwd_req_data_vld_short0;  //fwd 1->3  LTL@20241016
logic                                                       sq_newest_fwd_req_data_vld_short1;
logic                                                       sq_newest_fwd_req_data_vld_short2;    
logic    [SQ_ENTRY-1:0]                                     sq_newest_fwd_req_id0;     //1->3  LTL@20241016
logic    [SQ_ENTRY-1:0]                                     sq_newest_fwd_req_id1;
logic    [SQ_ENTRY-1:0]                                     sq_newest_fwd_req_id2;                  
logic                                                       sq_pe_age_vec_surplus1_atomic;         
logic                                                       sq_pe_age_vec_surplus1_dtcm_hit;       
logic                                                       sq_pe_age_vec_surplus1_icc;            
logic    [PREG-1:0]                                         sq_pe_age_vec_surplus1_preg;
logic                                                       sq_pe_age_vec_surplus1_inst_flush;     
logic    [1  :0]                                            sq_pe_age_vec_surplus1_inst_mode;      
logic    [2  :0]                                            sq_pe_age_vec_surplus1_inst_size;      
logic    [1  :0]                                            sq_pe_age_vec_surplus1_inst_type;      
logic                                                       sq_pe_age_vec_surplus1_itcm_hit;       
logic                                                       sq_pe_age_vec_surplus1_page_buf;       
logic                                                       sq_pe_age_vec_surplus1_page_ca;        
logic                                                       sq_pe_age_vec_surplus1_page_sec;       
logic                                                       sq_pe_age_vec_surplus1_page_share;     
logic                                                       sq_pe_age_vec_surplus1_page_so;        
logic                                                       sq_pe_age_vec_surplus1_page_wa;        
logic    [1  :0]                                            sq_pe_age_vec_surplus1_priv_mode;      
logic                                                       sq_pe_age_vec_surplus1_sync_fence;     
logic                                                       sq_pe_age_vec_surplus1_wo_st;          
logic                                                       sq_pe_age_vec_surplus1_init_dcache_miss;
logic    [1  :0]                                            sq_pe_age_vec_surplus1_ssp_va;
logic    [PC_LEN-1:0]                                       sq_pe_age_vec_surplus1_pc_index;
logic                                                       sq_pe_age_vec_zero_atomic;             
logic                                                       sq_pe_age_vec_zero_dtcm_hit;           
logic                                                       sq_pe_age_vec_zero_icc;                
logic    [PREG-1:0]                                         sq_pe_age_vec_zero_preg;
logic                                                       sq_pe_age_vec_zero_inst_flush;         
logic    [1  :0]                                            sq_pe_age_vec_zero_inst_mode;          
logic    [2  :0]                                            sq_pe_age_vec_zero_inst_size;          
logic    [1  :0]                                            sq_pe_age_vec_zero_inst_type;          
logic                                                       sq_pe_age_vec_zero_itcm_hit;           
logic                                                       sq_pe_age_vec_zero_page_buf;           
logic                                                       sq_pe_age_vec_zero_page_ca;            
logic                                                       sq_pe_age_vec_zero_page_sec;           
logic                                                       sq_pe_age_vec_zero_page_share;         
logic                                                       sq_pe_age_vec_zero_page_so;            
logic                                                       sq_pe_age_vec_zero_page_wa;            
logic    [1  :0]                                            sq_pe_age_vec_zero_priv_mode;          
logic                                                       sq_pe_age_vec_zero_sync_fence;         
logic                                                       sq_pe_age_vec_zero_wo_st;              
logic                                                       sq_pe_age_vec_zero_init_dcache_miss;
logic    [1  :0]                                            sq_pe_age_vec_zero_ssp_va;
logic    [PC_LEN-1:0]                                       sq_pe_age_vec_zero_pc_index; 
logic                                                       sq_pe_sel_age_vec_surplus1_entry_vld;  
logic                                                       sq_pe_sel_age_vec_zero_entry_vld;
logic                                                       sq_pop_clk;                            
logic                                                       sq_pop_clk_en;                         
logic                                                       sq_pop_dcache_all_inst;                
logic                                                       sq_pop_dcache_inst; 
logic                                                       sq_pop_depd_ff;                   
logic                                                       sq_pop_expt_nop;                       
logic                                                       sq_pop_expt_nop_vld;                   
logic                                                       sq_pop_merge_data_req_unmask;          
logic                                                       sq_pop_req_unmask;                     
logic                                                       sq_pop_sc_inst;                        
logic                                                       sq_pop_st_and_atomic_inst;                                  
logic                                                       sq_pop_to_ce_req;                      
logic                                                       sq_pop_to_ce_req_unmask;               
logic    [1  :0]                                            sq_settle_element_size0; //1->2  LTL@20241016
logic    [1  :0]                                            sq_settle_element_size1;                
logic                                                       sq_settle_inst_vls0;//1->2  LTL@20241016  
logic                                                       sq_settle_inst_vls1;
logic    [15 :0]                                            sq_settle_rot_sel0;  //1->2  LTL@20241016
logic    [15 :0]                                            sq_settle_rot_sel1;                     
//logic    [1  :0]                                            sq_settle_vsew0;     //1->2  LTL@20241016 //rvv1.0
//logic    [1  :0]                                            sq_settle_vsew1; 
logic    [1  :0]  sq_settle_vmew0;
logic    [1  :0]  sq_settle_vmew1;                                            
logic                                                       sq_wakeup_queue_clk0; //1->3  LTL@20241016
logic                                                       sq_wakeup_queue_clk1;
logic                                                       sq_wakeup_queue_clk2;
logic                                                       sq_wakeup_queue_clk_en0; //1->3  LTL@20241016
logic                                                       sq_wakeup_queue_clk_en1;
logic                                                       sq_wakeup_queue_clk_en2;            
logic    [LSIQ_ENTRY-1:0]                                   sq_wakeup_queue_grnt0;  //1->3  LTL@20241016
logic    [LSIQ_ENTRY-1:0]                                   sq_wakeup_queue_grnt1;
logic    [LSIQ_ENTRY-1:0]                                   sq_wakeup_queue_grnt2;                 
logic    [LSIQ_ENTRY-1:0]                                   sq_wakeup_queue_next0;  //1->3  LTL@20241016
logic    [LSIQ_ENTRY-1:0]                                   sq_wakeup_queue_next1;
logic    [LSIQ_ENTRY-1:0]                                   sq_wakeup_queue_next2;                  
logic    [7  :0]                                            wb_dbg_r_id;                           
logic                                                       wb_dbg_r_last;                         
logic                                                       wb_dbg_r_req_ff;                       
logic    [3  :0]                                            wb_dbg_r_resp;                         
logic                                                       wmb_ce_dcache_dirty;                   
logic                                                       wmb_ce_dcache_hit_idx;                 
logic                                                       wmb_ce_dcache_page_share;              
logic                                                       wmb_ce_dcache_update_vld;                              
logic    [1 :0]                                             wmb_ce_dcache_way;                     
logic                                                       wmb_ce_depd;                           
logic                                                       wmb_ce_depd_set;                       

logic  [SQ_ENTRY-1:0]                                       first_empty_entry0;  //newly add for first empty entry in sq_entry, LTL@20241022
logic  [SQ_ENTRY-1:0]                                       first_empty_entry1;
logic  [SQ_ENTRY-1:0]                                       find_multi_fwd0;  //1->3, for sq_fwd_multi parameter, LTL@20241022
logic  [SQ_ENTRY-1:0]                                       find_multi_fwd1;
logic  [SQ_ENTRY-1:0]                                       find_multi_fwd2;
logic  [SQ_ENTRY-1:0]                                       find_one_from_zero_for_fwd_data0; //1->3, parameter for sq_lda0_fwd_data
logic  [SQ_ENTRY-1:0]                                       find_one_from_zero_for_fwd_data1; //parameter for sq_lda1_fwd_data
logic  [SQ_ENTRY-1:0]                                       find_one_from_zero_for_fwd_data2; //parameter for sq_lsda0_fwd_data
logic  [SQ_ENTRY-1:0]                                       find_one_from_left_for_discard0; //1->3, parameter for sq_data_discard_id_sel0
logic  [SQ_ENTRY-1:0]                                       find_one_from_left_for_discard1; //parameter for sq_data_discard_id_sel1
logic  [SQ_ENTRY-1:0]                                       find_one_from_left_for_discard2; //parameter for sq_data_discard_id_sel2

logic  [SQ_ENTRY-1:0][SQ_ENTRY-1:0]                         sq_entry_same_addr_older_than_ldc0_vec;  //LTL@20251009, avoid multi-fwd while not sameaddr_newest
logic  [SQ_ENTRY-1:0][SQ_ENTRY-1:0]                         sq_entry_same_addr_older_than_lsdc0_vec;
logic  [SQ_ENTRY-1:0][SQ_ENTRY-1:0]                         sq_entry_same_addr_older_than_lsdc1_vec;
logic  [SQ_ENTRY-1:0]                                       sq_newest_fwd_bypass_vec0;//newly add for bypass data choose std0 and std1, LTL@20241104
logic  [SQ_ENTRY-1:0]                                       sq_newest_fwd_bypass_vec1;
logic  [SQ_ENTRY-1:0]                                       sq_newest_fwd_bypass_vec2;

logic  [SQ_ENTRY-1:0]                                       sq_entry_fwd_bypass_req0_vec;  //LTL@20250529, 2 sq entry may bypass same ldc0 lsdc0 lsdc1
logic  [SQ_ENTRY-1:0]                                       sq_entry_fwd_bypass_req1_vec;
logic  [SQ_ENTRY-1:0]                                       sq_entry_fwd_bypass_req2_vec;
logic                                                       sq_entry_fwd_bypass_req0_has_two;
logic                                                       sq_entry_fwd_bypass_req1_has_two;
logic                                                       sq_entry_fwd_bypass_req2_has_two;

logic                                                       sq_lda0_newest_fwd_bypass_req_sel;
logic                                                       sq_lda0_fwd_bypass_req_sel;
logic                                                       sq_lda0_fwd_bypass_req_sel_newer;
logic                                                       sq_lsda0_newest_fwd_bypass_req_sel;
logic                                                       sq_lsda0_fwd_bypass_req_sel;
logic                                                       sq_lsda0_fwd_bypass_req_sel_newer;
logic                                                       sq_lsda1_newest_fwd_bypass_req_sel;
logic                                                       sq_lsda1_fwd_bypass_req_sel;
logic                                                       sq_lsda1_fwd_bypass_req_sel_newer;
//parameter SQ_ENTRY    = 12,   //declared in front, LTL@20241022 
//          LSIQ_ENTRY  = 12;
//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
logic   [127:0]                       st_dtu0_data_0;
logic   [SQ_ENTRY-1:0]                st_dtu0_sq_data_ptr_0;
logic                                 st_dtu0_vld_0;
logic   [SQ_ENTRY-1:0]                st_dtu1_sq_data_ptr_0;
logic   [SQ_ENTRY-1:0]                st_dtu2_sq_data_ptr_0;
logic                                 st_dtu2_vld_0;
logic                                 st_dtu0_data_check_0;
logic                                 st_dtu0_entry_vld_0;
logic   [16 :0]                       st_dtu0_halt_info_0;
logic   [2  :0]                       st_dtu0_inst_size_0;
logic   [SQ_ENTRY-1:0]                st_dtu0_sq_data_ptr_pre_0;
logic                                 st_dtu1_entry_vld_0;
logic                                 st_dtu_data_clk_0;
logic                                 st_dtu_data_clk_en_0;
logic   [SQ_ENTRY-1:0][16 :0]         sq_entry_halt_info_0;
logic   [SQ_ENTRY-1:0]                sq_entry_data_check_0;
logic   [SQ_ENTRY-1:0]                sq_entry_wake_data_req_0;
logic   [SQ_ENTRY-1:0]                sq_entry_wake_data_grnt_0;
logic   [SQ_ENTRY-1:0]                sq_entry_wake_data_sel_0;
logic   [SQ_ENTRY-1:0]                sq_entry_data_halt_info_update_vld_0;

logic   [127:0]                       st_dtu0_data_1;
logic   [SQ_ENTRY-1:0]                st_dtu0_sq_data_ptr_1;
logic                                 st_dtu0_vld_1;
logic   [SQ_ENTRY-1:0]                st_dtu1_sq_data_ptr_1;
logic   [SQ_ENTRY-1:0]                st_dtu2_sq_data_ptr_1;
logic                                 st_dtu2_vld_1;
logic                                 st_dtu0_data_check_1;
logic                                 st_dtu0_entry_vld_1;
logic   [16 :0]                       st_dtu0_halt_info_1;
logic   [2  :0]                       st_dtu0_inst_size_1;
logic   [SQ_ENTRY-1:0]                st_dtu0_sq_data_ptr_pre_1;
logic                                 st_dtu1_entry_vld_1;
logic                                 st_dtu_data_clk_1;
logic                                 st_dtu_data_clk_en_1;
logic   [SQ_ENTRY-1:0][16 :0]         sq_entry_halt_info_1;
logic   [SQ_ENTRY-1:0]                sq_entry_data_check_1;
logic   [SQ_ENTRY-1:0]                sq_entry_wake_data_req_1;
logic   [SQ_ENTRY-1:0]                sq_entry_wake_data_grnt_1;
logic   [SQ_ENTRY-1:0]                sq_entry_wake_data_sel_1;
logic   [SQ_ENTRY-1:0]                sq_entry_data_halt_info_update_vld_1;
//==========================================================
//                  Risc-V Debug zdb End 
//==========================================================

parameter S_BYTE      = 2'b00,
          HALF        = 2'b01,
          WORD        = 2'b10,
          DWORD       = 2'b11;

//==========================================================
//                 Instance of Gated Cell  
//==========================================================
//if sq has entry or create sq, then this gateclk is on
//sq_clk is only used for depd_ff now
assign sq_clk_en  = !sq_empty                           //
                    ||  lsdc0_sq_ex2_create_gateclk_en
                    ||  lsdc1_sq_ex2_create_gateclk_en  //1->2, create_gateclk_en become 2, add by LTL@20241014
                    ||  sq_pop_depd_ff;
// &Instance("gated_clk_cell", "x_lsu_sq_gated_clk"); @51
gated_clk_cell  x_lsu_sq_gated_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (sq_clk            ),
  .external_en        (1'b0              ),
  .local_en           (sq_clk_en         ),
  .module_en          (cp0_lsu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect(.clk_in        (forever_cpuclk     ), @52
//          .external_en   (1'b0               ), @53
//          .module_en     (cp0_lsu_icg_en     ), @54
//          .local_en      (sq_clk_en          ), @55
//          .clk_out       (sq_clk             )); @56

//create pop clk is used for age_vec
assign sq_create_pop_clk_en = lsdc0_sq_ex2_create_gateclk_en  
                              || lsdc1_sq_ex2_create_gateclk_en  
                              || sq_pop_req_unmask;  //modified by LTL@20241014
// &Instance("gated_clk_cell", "x_lsu_sq_create_pop_gated_clk"); @60
gated_clk_cell  x_lsu_sq_create_pop_gated_clk (
  .clk_in               (forever_cpuclk      ),
  .clk_out              (sq_create_pop_clk   ),
  .external_en          (1'b0                ),
  .local_en             (sq_create_pop_clk_en),
  .module_en            (cp0_lsu_icg_en      ),
  .pad_yy_icg_scan_en   (pad_yy_icg_scan_en  )
);

// &Connect(.clk_in        (forever_cpuclk     ), @61
//          .external_en   (1'b0               ), @62
//          .module_en     (cp0_lsu_icg_en     ), @63
//          .local_en      (sq_create_pop_clk_en), @64
//          .clk_out       (sq_create_pop_clk  )); @65

//depd clk is used for wakeup queue
assign sq_wakeup_queue_clk_en0 = lda0_sq_ex3_global_discard_vld            //1->3  by LTL@20241016  
                                ||  sq_pop_depd_ff
                                ||  rtu_yy_xx_flush
                                ||  rtu_ck_flush;
assign sq_wakeup_queue_clk_en1 = lsda0_sq_ex3_global_discard_vld
                                ||  sq_pop_depd_ff
                                ||  rtu_yy_xx_flush
                                ||  rtu_ck_flush;
assign sq_wakeup_queue_clk_en2 = lsda1_sq_ex3_global_discard_vld
                                ||  sq_pop_depd_ff
                                ||  rtu_yy_xx_flush
                                ||  rtu_ck_flush;
// &Instance("gated_clk_cell", "x_lsu_sq_wakeup_queue_gated_clk"); @71
gated_clk_cell  x_lsu_sq_wakeup_queue_gated_clk0 (
  .clk_in                 (forever_cpuclk        ),
  .clk_out                (sq_wakeup_queue_clk0   ),
  .external_en            (1'b0                  ),
  .local_en               (sq_wakeup_queue_clk_en0),
  .module_en              (cp0_lsu_icg_en        ),
  .pad_yy_icg_scan_en     (pad_yy_icg_scan_en    )
);
gated_clk_cell  x_lsu_sq_wakeup_queue_gated_clk1 (
  .clk_in                 (forever_cpuclk        ),
  .clk_out                (sq_wakeup_queue_clk1   ),
  .external_en            (1'b0                  ),
  .local_en               (sq_wakeup_queue_clk_en1),
  .module_en              (cp0_lsu_icg_en        ),
  .pad_yy_icg_scan_en     (pad_yy_icg_scan_en    )
);
gated_clk_cell  x_lsu_sq_wakeup_queue_gated_clk2 (
  .clk_in                 (forever_cpuclk        ),
  .clk_out                (sq_wakeup_queue_clk2   ),
  .external_en            (1'b0                  ),
  .local_en               (sq_wakeup_queue_clk_en2),
  .module_en              (cp0_lsu_icg_en        ),
  .pad_yy_icg_scan_en     (pad_yy_icg_scan_en    )
);

// &Connect(.clk_in        (forever_cpuclk     ), @72
//          .external_en   (1'b0               ), @73
//          .module_en     (cp0_lsu_icg_en     ), @74
//          .local_en      (sq_wakeup_queue_clk_en), @75
//          .clk_out       (sq_wakeup_queue_clk)); @76

//sq fwd ld da pop entry
assign sq_fwd_data_pe_clk_en0 = sq_newest_fwd_req_data_vld_short0;
// &Instance("gated_clk_cell", "x_lsu_sq_fwd_data_pe_gated_clk"); @80
gated_clk_cell  x_lsu_sq_fwd_data_pe_gated_clk0 (
  .clk_in                (forever_cpuclk       ),
  .clk_out               (sq_fwd_data_pe_clk0   ),
  .external_en           (1'b0                 ),
  .local_en              (sq_fwd_data_pe_clk_en0),
  .module_en             (cp0_lsu_icg_en       ),
  .pad_yy_icg_scan_en    (pad_yy_icg_scan_en   )
);
assign sq_fwd_data_pe_clk_en1 = sq_newest_fwd_req_data_vld_short1;
// &Instance("gated_clk_cell", "x_lsu_sq_fwd_data_pe_gated_clk"); @80
gated_clk_cell  x_lsu_sq_fwd_data_pe_gated_clk1 (
  .clk_in                (forever_cpuclk       ),
  .clk_out               (sq_fwd_data_pe_clk1   ),
  .external_en           (1'b0                 ),
  .local_en              (sq_fwd_data_pe_clk_en1),
  .module_en             (cp0_lsu_icg_en       ),
  .pad_yy_icg_scan_en    (pad_yy_icg_scan_en   )
);
assign sq_fwd_data_pe_clk_en2 = sq_newest_fwd_req_data_vld_short2;
// &Instance("gated_clk_cell", "x_lsu_sq_fwd_data_pe_gated_clk"); @80
gated_clk_cell  x_lsu_sq_fwd_data_pe_gated_clk2 (
  .clk_in                (forever_cpuclk       ),
  .clk_out               (sq_fwd_data_pe_clk2   ),
  .external_en           (1'b0                 ),
  .local_en              (sq_fwd_data_pe_clk_en2),
  .module_en             (cp0_lsu_icg_en       ),
  .pad_yy_icg_scan_en    (pad_yy_icg_scan_en   )
);
// &Connect(.clk_in        (forever_cpuclk     ), @81
//          .external_en   (1'b0               ), @82
//          .module_en     (cp0_lsu_icg_en     ), @83
//          .local_en      (sq_fwd_data_pe_clk_en), @84
//          .clk_out       (sq_fwd_data_pe_clk)); @85

//pop entry signal
assign sq_pop_clk_en  = sq_pop_req_unmask
                        ||  sq_pe_sel_age_vec_zero_entry_vld;
// &Instance("gated_clk_cell", "x_lsu_sq_pop_gated_clk"); @90
gated_clk_cell  x_lsu_sq_pop_gated_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (sq_pop_clk        ),
  .external_en        (1'b0              ),
  .local_en           (sq_pop_clk_en     ),
  .module_en          (cp0_lsu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect(.clk_in        (forever_cpuclk     ), @91
//          .external_en   (1'b0               ), @92
//          .module_en     (cp0_lsu_icg_en     ), @93
//          .local_en      (sq_pop_clk_en      ), @94
//          .clk_out       (sq_pop_clk         )); @95


//==========================================================
//              Instance of store queue entry
//==========================================================
//------------------instance--------------------------------
genvar entry_i;

generate
  for(entry_i=0;entry_i<SQ_ENTRY;entry_i=entry_i+1) begin
      xx_lsu_sq_entry #(
          .LSIQ_ENTRY(LSIQ_ENTRY),
          .SQ_ENTRY  (SQ_ENTRY  ),
          .SDID_LEN  (SDID_LEN  ),
          .IID_WIDTH (IID_WIDTH ),
          .PREG      (PREG      ),
          .PC_LEN    (PC_LEN    )
      ) x_xx_lsu_sq_entry (
        .cp0_lsu_icg_en                            (cp0_lsu_icg_en                           ),
        .cp0_yy_priv_mode                          (cp0_yy_priv_mode                         ),
        .cpurst_b                                  (cpurst_b                                 ),
        .dcache_dirty_din                          (dcache_dirty_din                         ),
        .dcache_dirty_gwen                         (dcache_dirty_gwen                        ),
        .dcache_dirty_wen                          (dcache_dirty_wen                         ),
        .dcache_idx                                (dcache_idx                               ),
        .dcache_tag_din                            (dcache_tag_din                           ),
        .dcache_tag_gwen                           (dcache_tag_gwen                          ),
        .dcache_tag_wen                            (dcache_tag_wen                           ),
        .forever_cpuclk                            (forever_cpuclk                           ),
        .lda0_ex3_lsid                             (lda0_ex3_lsid                            ),
        .lsda0_ex3_lsid                            (lsda0_ex3_lsid                           ),
        .lsda1_ex3_lsid                            (lsda1_ex3_lsid                           ),
        .ldc0_ex2_addr0                            (ldc0_ex2_addr0                           ),
        .lsdc0_ex2_st_addr0                        (lsdc0_ex2_st_addr0                       ),//timing
        .lsdc0_ex2_ld_addr0                        (lsdc0_ex2_ld_addr0                       ),//timing
        .lsdc1_ex2_st_addr0                        (lsdc1_ex2_st_addr0                       ),//timing
        .lsdc1_ex2_ld_addr0                        (lsdc1_ex2_ld_addr0                       ),//timing
        .ldc0_ex2_addr1_11to4                      (ldc0_ex2_addr1_11to4                     ),
        .lsdc0_ex2_addr1_11to4                     (lsdc0_ex2_addr1_11to4          ),
        .lsdc1_ex2_addr1_11to4                     (lsdc1_ex2_addr1_11to4          ),
        .ldc0_ex2_bytes_vld                        (ldc0_ex2_bytes_vld                       ),
        .lsdc0_ex2_st_bytes_vld                    (lsdc0_ex2_st_bytes_vld                   ),
        .lsdc0_ex2_ld_bytes_vld                    (lsdc0_ex2_ld_bytes_vld                   ),//timing
        .lsdc1_ex2_st_bytes_vld                    (lsdc1_ex2_st_bytes_vld                   ),
        .lsdc1_ex2_ld_bytes_vld                    (lsdc1_ex2_ld_bytes_vld                   ),//timing
        .ldc0_ex2_bytes_vld1                       (ldc0_ex2_bytes_vld1                      ),
        .lsdc0_ex2_bytes_vld1                      (lsdc0_ex2_bytes_vld1                      ),
        .lsdc1_ex2_bytes_vld1                      (lsdc1_ex2_bytes_vld1                      ),
        .ldc0_ex2_bytes_vld2                       (ldc0_ex2_bytes_vld2                       ),//rvv512@LTL
        .lsdc0_ex2_bytes_vld2                      (lsdc0_ex2_bytes_vld2                      ),//rvv512@LTL
        .lsdc1_ex2_bytes_vld2                      (lsdc1_ex2_bytes_vld2                      ),//rvv512@LTL      
        .ldc0_ex2_bytes_vld3                       (ldc0_ex2_bytes_vld3                       ),//rvv512@LTL
        .lsdc0_ex2_bytes_vld3                      (lsdc0_ex2_bytes_vld3                      ),//rvv512@LTL
        .lsdc1_ex2_bytes_vld3                      (lsdc1_ex2_bytes_vld3                      ),//rvv512@LTL      
        .ldc0_ex2_is_us                            (ldc0_ex2_is_us                            ),//rvv512@LTL
        .lsdc0_ex2_is_us                           (lsdc0_ex2_is_us                           ),//rvv512@LTL
        .lsdc1_ex2_is_us                           (lsdc1_ex2_is_us                           ),//rvv512@LTL
        .ldc0_ex2_chk_atomic_inst_vld              (ldc0_ex2_chk_atomic_inst_vld             ),
        .lsdc0_ex2_chk_atomic_inst_vld             (lsdc0_ex2_chk_atomic_inst_vld   ),
        .lsdc1_ex2_chk_atomic_inst_vld             (lsdc1_ex2_chk_atomic_inst_vld   ),
        .ldc0_ex2_chk_ld_addr1_vld                 (ldc0_ex2_chk_ld_addr1_vld                ),
        .lsdc0_ex2_chk_ld_addr1_vld                (lsdc0_ex2_chk_ld_addr1_vld  ),
        .lsdc1_ex2_chk_ld_addr1_vld                (lsdc1_ex2_chk_ld_addr1_vld  ),
        .ldc0_sq_ex2_chk_ld_bypass_vld             (ldc0_sq_ex2_chk_ld_bypass_vld            ),
        .lsdc0_sq_ex2_chk_ld_bypass_vld            (lsdc0_sq_ex2_chk_ld_bypass_vld    ),
        .lsdc1_sq_ex2_chk_ld_bypass_vld            (lsdc1_sq_ex2_chk_ld_bypass_vld    ),
        .ldc0_ex2_chk_ld_inst_vld                  (ldc0_ex2_chk_ld_inst_vld                 ),
        .lsdc0_ex2_chk_ld_inst_vld                 (lsdc0_ex2_chk_ld_inst_vld       ),
        .lsdc1_ex2_chk_ld_inst_vld                 (lsdc1_ex2_chk_ld_inst_vld       ),
        .ldc0_ex2_iid                              (ldc0_ex2_iid                             ),
        .lsdc0_ex2_ld_iid                          (lsdc0_ex2_ld_iid                         ),//logic levels opt@LTL
        .lsdc1_ex2_ld_iid                          (lsdc1_ex2_ld_iid                         ),//logic levels opt@LTL
        .lsdc0_ex2_st_iid                          (lsdc0_ex2_st_iid                         ),//logic levels opt@LTL
        .lsdc1_ex2_st_iid                          (lsdc1_ex2_st_iid                         ),//logic levels opt@LTL
        .pad_yy_icg_scan_en                        (pad_yy_icg_scan_en                       ),
        .rtu_lsu_async_flush                       (rtu_lsu_async_flush                      ),
        .rtu_lsu_commit0_iid_updt_val              (rtu_lsu_commit0_iid_updt_val             ),
        .rtu_lsu_commit1_iid_updt_val              (rtu_lsu_commit1_iid_updt_val             ),
        .rtu_lsu_commit2_iid_updt_val              (rtu_lsu_commit2_iid_updt_val             ),
        .rtu_lsu_commit3_iid_updt_val              (rtu_lsu_commit3_iid_updt_val   ),
        .rtu_lsu_commit4_iid_updt_val              (rtu_lsu_commit4_iid_updt_val   ),
        .rtu_lsu_commit5_iid_updt_val              (rtu_lsu_commit5_iid_updt_val   ),
        .rtu_lsu_commit6_iid_updt_val              (rtu_lsu_commit6_iid_updt_val   ),
        .rtu_lsu_commit7_iid_updt_val              (rtu_lsu_commit7_iid_updt_val   ),
        .rtu_yy_xx_commit0                         (rtu_yy_xx_commit0                        ),
        .rtu_yy_xx_commit1                         (rtu_yy_xx_commit1                        ),
        .rtu_yy_xx_commit2                         (rtu_yy_xx_commit2                        ),
        .rtu_yy_xx_commit3                         (rtu_yy_xx_commit3                        ),
        .rtu_yy_xx_commit4                         (rtu_yy_xx_commit4                        ),
        .rtu_yy_xx_commit5                         (rtu_yy_xx_commit5                        ),
        .rtu_yy_xx_commit6                         (rtu_yy_xx_commit6                        ),
        .rtu_yy_xx_commit7                         (rtu_yy_xx_commit7                        ),
        .rtu_yy_xx_flush                           (rtu_yy_xx_flush                          ),
        .rtu_ck_flush                              (rtu_ck_flush                             ),
        .rtu_ck_flush_iid                          (rtu_ck_flush_iid                         ),
        .std0_ex1_inst_vld                         (std0_ex1_inst_vld                        ),
        .std1_ex1_inst_vld                         (std1_ex1_inst_vld                       ),
        .std0_rf_sdid                              (std0_rf_sdid                            ),
        .std1_rf_sdid                              (std1_rf_sdid                             ),
        .std0_sq_rf_inst_vld_short                 (std0_sq_rf_inst_vld_short               ),
        .std1_sq_rf_inst_vld_short                 (std1_sq_rf_inst_vld_short                ),
        .sq_age_vec_set                            (sq_age_vec_set                           ),
        .sq_create_age_vec0                        (sq_create_age_vec0                        ),
        .sq_create_age_vec1                        (sq_create_age_vec1                        ),  
        .sq_create_pop_clk                         (sq_create_pop_clk                        ),
        .sq_create_same_addr_newest0               (sq_create_same_addr_newest0               ),
        .sq_create_same_addr_newest1               (sq_create_same_addr_newest1                ),
        .sq_create_success0                        (sq_create_success0                        ),
        .sq_create_success1                        (sq_create_success1                        ),
        .sq_create_vld0                            (sq_create_vld0                            ),
        .sq_create_vld1                            (sq_create_vld1                            ),
        .sq_data_settle0                           (sq_data_settle0                           ),
        .sq_data_settle1                           (sq_data_settle1                           ),
        .sq_entry_create_dp_vld0_x                 (sq_entry_create_dp_vld0[entry_i]                 ),
        .sq_entry_create_dp_vld1_x                 (sq_entry_create_dp_vld1[entry_i]               ),
        .sq_entry_create_gateclk_en0_x             (sq_entry_create_gateclk_en0[entry_i]            ),
        .sq_entry_create_gateclk_en1_x             (sq_entry_create_gateclk_en1[entry_i]            ),
        .sq_entry_create_vld0_x                    (sq_entry_create_vld0[entry_i]                   ),
        .sq_entry_create_vld1_x                    (sq_entry_create_vld1[entry_i]                   ),
        .sq_entry_data_discard_grnt0_x             (sq_entry_data_discard_grnt0[entry_i]            ),
        .sq_entry_data_discard_grnt1_x             (sq_entry_data_discard_grnt1[entry_i]             ),
        .sq_entry_data_discard_grnt2_x             (sq_entry_data_discard_grnt2[entry_i]             ),
        .sq_entry_fwd_multi_depd_set0_x            (sq_entry_fwd_multi_depd_set0[entry_i]           ),
        .sq_entry_fwd_multi_depd_set1_x            (sq_entry_fwd_multi_depd_set1[entry_i]            ),
        .sq_entry_fwd_multi_depd_set2_x            (sq_entry_fwd_multi_depd_set2[entry_i]            ),
        .sq_entry_pop_to_ce_grnt_b                 (sq_entry_pop_to_ce_grnt_b                ),
        .sq_entry_pop_to_ce_grnt_x                 (sq_entry_pop_to_ce_grnt[entry_i]               ),
        .sq_pop_ptr_x                              (sq_pop_ptr[entry_i]                            ),
        .lsda0_ex3_iid                             (lsda0_ex3_iid                            ),
        .lsda0_ex3_inst_vld                        (lsda0_ex3_inst_vld                       ),
        .lsda0_sq_ex3_secd                         (lsda0_sq_ex3_secd                        ),
        .lsda0_sq_ex3_dcache_dirty                 (lsda0_sq_ex3_dcache_dirty                ),
        .lsda0_sq_ex3_dcache_page_share            (lsda0_sq_ex3_dcache_page_share           ),
        .lsda0_sq_ex3_dcache_share                 (lsda0_sq_ex3_dcache_share                ),
        .lsda0_sq_ex3_dcache_valid                 (lsda0_sq_ex3_dcache_valid                ),
        .lsda0_sq_ex3_dcache_way                   (lsda0_sq_ex3_dcache_way                  ),
        .lsda0_sq_ex3_ecc_stall                    (lsda0_sq_ex3_ecc_stall                   ),
        .lsda0_sq_ex3_expt_vld                     (lsda0_sq_ex3_expt_vld                    ),
        .lsda0_sq_ex3_lm_fail                      (lsda0_sq_ex3_lm_fail                     ),
        .lsda0_sq_ex3_no_restart                   (lsda0_sq_ex3_no_restart                  ),
        .lsda0_ex3_spec_fail                       (lsda0_ex3_spec_fail                      ),
        .lsda0_ex3_vstart_vld                      (lsda0_ex3_vstart_vld                     ),
        .lsda1_ex3_iid                             (lsda1_ex3_iid                       ),
        .lsda1_ex3_inst_vld                        (lsda1_ex3_inst_vld                  ),
        .lsda1_sq_ex3_secd                         (lsda1_sq_ex3_secd                   ),
        .lsda1_sq_ex3_dcache_dirty                 (lsda1_sq_ex3_dcache_dirty           ),
        .lsda1_sq_ex3_dcache_page_share            (lsda1_sq_ex3_dcache_page_share      ),
        .lsda1_sq_ex3_dcache_share                 (lsda1_sq_ex3_dcache_share           ),
        .lsda1_sq_ex3_dcache_valid                 (lsda1_sq_ex3_dcache_valid           ),
        .lsda1_sq_ex3_dcache_way                   (lsda1_sq_ex3_dcache_way             ),
        .lsda1_sq_ex3_ecc_stall                    (lsda1_sq_ex3_ecc_stall              ),
        .lsda1_sq_ex3_expt_vld                     (lsda1_sq_ex3_expt_vld               ),
        .lsda1_sq_ex3_lm_fail                      (lsda1_sq_ex3_lm_fail                ),
        .lsda1_sq_ex3_no_restart                   (lsda1_sq_ex3_no_restart             ),
        .lsda1_ex3_spec_fail                       (lsda1_ex3_spec_fail                 ),
        .lsda1_ex3_vstart_vld                      (lsda1_ex3_vstart_vld                ),
        .lsdc0_ex2_atomic                          (lsdc0_ex2_atomic                         ),
        .lsdc0_ex2_boundary                        (lsdc0_ex2_boundary                       ),
        .lsdc0_sq_ex2_boundary_first               (lsdc0_sq_ex2_boundary_first              ),
        .lsdc0_sq_ex2_cmit0_iid_crt_hit            (lsdc0_sq_ex2_cmit0_iid_crt_hit           ),
        .lsdc0_sq_ex2_cmit1_iid_crt_hit            (lsdc0_sq_ex2_cmit1_iid_crt_hit           ),
        .lsdc0_sq_ex2_cmit2_iid_crt_hit            (lsdc0_sq_ex2_cmit2_iid_crt_hit           ),
        .lsdc0_sq_ex2_cmit3_iid_crt_hit            (lsdc0_sq_ex2_cmit3_iid_crt_hit            ),
        .lsdc0_sq_ex2_cmit4_iid_crt_hit            (lsdc0_sq_ex2_cmit4_iid_crt_hit            ),
        .lsdc0_sq_ex2_cmit5_iid_crt_hit            (lsdc0_sq_ex2_cmit5_iid_crt_hit            ),
        .lsdc0_sq_ex2_cmit6_iid_crt_hit            (lsdc0_sq_ex2_cmit6_iid_crt_hit            ),
        .lsdc0_sq_ex2_cmit7_iid_crt_hit            (lsdc0_sq_ex2_cmit7_iid_crt_hit            ),
        .lsdc0_ex2_page_buf                        (lsdc0_ex2_page_buf                       ),
        .lsdc0_ex2_page_ca                         (lsdc0_ex2_page_ca                        ),
        .lsdc0_ex2_page_sec                        (lsdc0_ex2_page_sec                       ),
        .lsdc0_ex2_page_share                      (lsdc0_ex2_page_share                     ),
        .lsdc0_ex2_page_so                         (lsdc0_ex2_page_so                        ),
        .lsdc0_ex2_page_wa                         (lsdc0_ex2_page_wa                        ),
        .lsdc0_sq_ex2_dtcm_hit                     (lsdc0_sq_ex2_dtcm_hit                    ),
        .lsdc0_sq_ex2_element_size                 (lsdc0_sq_ex2_element_size                ),
        .lsdc0_ex2_fence_mode                      (lsdc0_ex2_fence_mode                     ),
        .lsdc0_ex2_icc                             (lsdc0_ex2_icc                            ),
        .lsdc0_ex2_preg                            (lsdc0_ex2_preg                           ),
        .lsdc0_sq_ex2_idx_order                    (lsdc0_sq_ex2_idx_order                   ),
        .lsdc0_sq_ex2_inst_flush                   (lsdc0_sq_ex2_inst_flush                  ),
        .lsdc0_ex2_inst_mode                       (lsdc0_ex2_inst_mode                      ),
        .lsdc0_ex2_inst_size                       (lsdc0_ex2_inst_size                      ),
        .lsdc0_ex2_inst_type                       (lsdc0_ex2_inst_type                      ),
        .lsdc0_ex2_inst_vls                        (lsdc0_ex2_inst_vls                       ),
        .lsdc0_sq_ex2_itcm_hit                     (lsdc0_sq_ex2_itcm_hit                    ),
        .lsdc0_sq_ex2_rot_sel_rev                  (lsdc0_sq_ex2_rot_sel_rev                 ),
        .lsdc0_sq_ex2_sdid                         (lsdc0_sq_ex2_sdid                        ),
        .lsdc0_sq_ex2_sdid_hit0                    (lsdc0_sq_ex2_sdid_hit0                    ),
        .lsdc0_sq_ex2_sdid_hit1                    (lsdc0_sq_ex2_sdid_hit1                    ),
        .lsdc0_ex2_st_secd                         (lsdc0_ex2_st_secd                         ),//logic levels opt@LTL
        .lsdc0_sq_ex2_data_vld                     (lsdc0_sq_ex2_data_vld                    ),
        .lsdc0_ex2_sync_fence                      (lsdc0_ex2_sync_fence                     ),
        //.lsdc0_sq_ex2_vsew                         (lsdc0_sq_ex2_vsew                        ),//rvv1.0@hcl
        .lsdc0_sq_ex2_vmew                         (lsdc0_sq_ex2_vmew                        ),//rvv1.0@hcl
        .lsdc0_sq_ex2_vmop                         (lsdc0_sq_ex2_vmop                        ),//rvv1.0@hcl
        .lsdc0_sq_ex2_wo_st_inst                   (lsdc0_sq_ex2_wo_st_inst                  ),
        .lsdc0_ex2_dcache_hit                      (lsdc0_ex2_dcache_hit                     ),
        .lsdc0_ex2_ssp_va                          (lsdc0_ex2_ssp_va                         ),
        .lsdc0_ex2_pc                              (lsdc0_ex2_pc                             ),
        .lsdc1_ex2_atomic                          (lsdc1_ex2_atomic               ),
        .lsdc1_ex2_boundary                        (lsdc1_ex2_boundary             ),
        .lsdc1_sq_ex2_boundary_first               (lsdc1_sq_ex2_boundary_first    ),
        .lsdc1_sq_ex2_cmit0_iid_crt_hit            (lsdc1_sq_ex2_cmit0_iid_crt_hit ),
        .lsdc1_sq_ex2_cmit1_iid_crt_hit            (lsdc1_sq_ex2_cmit1_iid_crt_hit ),
        .lsdc1_sq_ex2_cmit2_iid_crt_hit            (lsdc1_sq_ex2_cmit2_iid_crt_hit ),
        .lsdc1_sq_ex2_cmit3_iid_crt_hit            (lsdc1_sq_ex2_cmit3_iid_crt_hit ),
        .lsdc1_sq_ex2_cmit4_iid_crt_hit            (lsdc1_sq_ex2_cmit4_iid_crt_hit ),
        .lsdc1_sq_ex2_cmit5_iid_crt_hit            (lsdc1_sq_ex2_cmit5_iid_crt_hit ),
        .lsdc1_sq_ex2_cmit6_iid_crt_hit            (lsdc1_sq_ex2_cmit6_iid_crt_hit ),
        .lsdc1_sq_ex2_cmit7_iid_crt_hit            (lsdc1_sq_ex2_cmit7_iid_crt_hit ),
        .lsdc1_ex2_page_buf                        (lsdc1_ex2_page_buf             ),
        .lsdc1_ex2_page_ca                         (lsdc1_ex2_page_ca              ),
        .lsdc1_ex2_page_sec                        (lsdc1_ex2_page_sec             ),
        .lsdc1_ex2_page_share                      (lsdc1_ex2_page_share           ),
        .lsdc1_ex2_page_so                         (lsdc1_ex2_page_so              ),
        .lsdc1_ex2_page_wa                         (lsdc1_ex2_page_wa              ),
        .lsdc1_sq_ex2_dtcm_hit                     (lsdc1_sq_ex2_dtcm_hit          ),
        .lsdc1_sq_ex2_element_size                 (lsdc1_sq_ex2_element_size      ),
        .lsdc1_ex2_fence_mode                      (lsdc1_ex2_fence_mode           ),
        .lsdc1_ex2_icc                             (lsdc1_ex2_icc                  ),
        .lsdc1_ex2_preg                            (lsdc1_ex2_preg                 ),
        .lsdc1_sq_ex2_idx_order                    (lsdc1_sq_ex2_idx_order         ),
        .lsdc1_sq_ex2_inst_flush                   (lsdc1_sq_ex2_inst_flush        ),
        .lsdc1_ex2_inst_mode                       (lsdc1_ex2_inst_mode            ),
        .lsdc1_ex2_inst_size                       (lsdc1_ex2_inst_size            ),
        .lsdc1_ex2_inst_type                       (lsdc1_ex2_inst_type            ),
        .lsdc1_ex2_inst_vls                        (lsdc1_ex2_inst_vls             ),
        .lsdc1_sq_ex2_itcm_hit                     (lsdc1_sq_ex2_itcm_hit          ),
        .lsdc1_sq_ex2_rot_sel_rev                  (lsdc1_sq_ex2_rot_sel_rev       ),
        .lsdc1_sq_ex2_sdid                         (lsdc1_sq_ex2_sdid              ),
        .lsdc1_sq_ex2_sdid_hit0                    (lsdc1_sq_ex2_sdid_hit0          ),
        .lsdc1_sq_ex2_sdid_hit1                    (lsdc1_sq_ex2_sdid_hit1          ),
        .lsdc1_ex2_st_secd                         (lsdc1_ex2_st_secd               ),//logic levels opt@LTL
        .lsdc1_sq_ex2_data_vld                     (lsdc1_sq_ex2_data_vld          ),
        .lsdc1_ex2_sync_fence                      (lsdc1_ex2_sync_fence           ),
        //.lsdc1_sq_ex2_vsew                         (lsdc1_sq_ex2_vsew              ),
        .lsdc1_sq_ex2_vmew                         (lsdc1_sq_ex2_vmew              ),
        .lsdc1_sq_ex2_vmop                         (lsdc1_sq_ex2_vmop              ),
        .lsdc1_sq_ex2_wo_st_inst                   (lsdc1_sq_ex2_wo_st_inst        ),
        .lsdc1_ex2_dcache_hit                      (lsdc1_ex2_dcache_hit           ),
        .lsdc1_ex2_ssp_va                          (lsdc1_ex2_ssp_va               ),
        .lsdc1_ex2_pc                              (lsdc1_ex2_pc                   ),
        .wmb_sq_pop_grnt                           (wmb_sq_pop_grnt                          ),
        .sq_entry_already_st_stride_vec            (sq_entry_already_st_stride_vec                  ),
        .sq_entry_fwd_bypass_req0_vec              (sq_entry_fwd_bypass_req0_vec   ),
        .sq_entry_fwd_bypass_req1_vec              (sq_entry_fwd_bypass_req1_vec   ),
        .sq_entry_fwd_bypass_req2_vec              (sq_entry_fwd_bypass_req2_vec   ),
        .sq_entry_same_addr_older_than_ldc0_vec    (sq_entry_same_addr_older_than_ldc0_vec[entry_i]          ),
        .sq_entry_same_addr_older_than_lsdc0_vec   (sq_entry_same_addr_older_than_lsdc0_vec[entry_i]          ),
        .sq_entry_same_addr_older_than_lsdc1_vec   (sq_entry_same_addr_older_than_lsdc1_vec[entry_i]          ),        
        .sq_entry_addr0_v                          (sq_entry_addr0[entry_i]                         ),
        .sq_entry_addr1_dep_discard0_x             (sq_entry_addr1_dep_discard0[entry_i]            ),
        .sq_entry_addr1_dep_discard1_x             (sq_entry_addr1_dep_discard1[entry_i]            ),
        .sq_entry_addr1_dep_discard2_x             (sq_entry_addr1_dep_discard2[entry_i]            ),
        .sq_entry_age_vec_surplus1_ptr_x           (sq_entry_age_vec_surplus1_ptr[entry_i]         ),
        .sq_entry_age_vec_zero_ptr_x               (sq_entry_age_vec_zero_ptr[entry_i]             ),
        .sq_entry_atomic_x                         (sq_entry_atomic[entry_i]                       ),
        .sq_entry_bytes_vld_v                      (sq_entry_bytes_vld[entry_i]                     ),
        .sq_entry_cancel_acc_req0_x                (sq_entry_cancel_acc_req0[entry_i]               ),
        .sq_entry_cancel_acc_req1_x                (sq_entry_cancel_acc_req1[entry_i]               ),
        .sq_entry_cancel_acc_req2_x                (sq_entry_cancel_acc_req2[entry_i]               ),
        .sq_entry_cancel_ahead_wb0_x               (sq_entry_cancel_ahead_wb0[entry_i]              ),
        .sq_entry_cancel_ahead_wb1_x               (sq_entry_cancel_ahead_wb1[entry_i]              ),
        .sq_entry_cancel_ahead_wb2_x               (sq_entry_cancel_ahead_wb2[entry_i]              ),
        .sq_entry_cmit_data_vld_x                  (sq_entry_cmit_data_vld[entry_i]                ),
        .sq_entry_cmit_x                           (sq_entry_cmit[entry_i]                         ),
        .sq_entry_data_depd_wakeup0_v              (sq_entry_data_depd_wakeup0[entry_i]              ),
        .sq_entry_data_depd_wakeup1_v              (sq_entry_data_depd_wakeup1[entry_i]              ),
        .sq_entry_data_depd_wakeup2_v              (sq_entry_data_depd_wakeup2[entry_i]              ),
        .sq_entry_data_discard_req_short0_x        (sq_entry_data_discard_req_short0[entry_i]       ),
        .sq_entry_data_discard_req_short1_x        (sq_entry_data_discard_req_short1[entry_i]       ),
        .sq_entry_data_discard_req_short2_x        (sq_entry_data_discard_req_short2[entry_i]       ),
        .sq_entry_data_discard_req0_x              (sq_entry_data_discard_req0[entry_i]             ),
        .sq_entry_data_discard_req1_x              (sq_entry_data_discard_req1[entry_i]             ),
        .sq_entry_data_discard_req2_x              (sq_entry_data_discard_req2[entry_i]             ),
        .sq_entry_data_v                           (sq_entry_data[entry_i]                          ),
        .sq_entry_dcache_dirty_x                   (sq_entry_dcache_dirty[entry_i]                 ),
        .sq_entry_dcache_info_vld_x                (sq_entry_dcache_info_vld[entry_i]              ),
        .sq_entry_dcache_page_share_x              (sq_entry_dcache_page_share[entry_i]            ),
        .sq_entry_dcache_share_x                   (sq_entry_dcache_share[entry_i]                 ),
        .sq_entry_dcache_valid_x                   (sq_entry_dcache_valid[entry_i]                 ),
        .sq_entry_dcache_way_x                     (sq_entry_dcache_way[entry_i]                   ),
        .sq_entry_depd_set_x                       (sq_entry_depd_set[entry_i]                     ),
        .sq_entry_depd_x                           (sq_entry_depd[entry_i]                         ),
        .sq_entry_discard_req0_x                   (sq_entry_discard_req0[entry_i]                  ),
        .sq_entry_discard_req1_x                   (sq_entry_discard_req1[entry_i]                  ),
        .sq_entry_discard_req2_x                   (sq_entry_discard_req2[entry_i]                  ),
        .sq_entry_dtcm_hit_x                       (sq_entry_dtcm_hit[entry_i]                     ),
        .sq_entry_element_size_v                   (sq_entry_element_size[entry_i]                  ),
        .sq_entry_expt_nop_x                       (sq_entry_expt_nop[entry_i]                     ),
        .sq_entry_fence_mode_v                     (sq_entry_fence_mode[entry_i]                    ),
        .sq_entry_fwd_bypass_req0_x                (sq_entry_fwd_bypass_req0[entry_i]               ),
        .sq_entry_fwd_bypass_req1_x                (sq_entry_fwd_bypass_req1[entry_i]               ),
        .sq_entry_fwd_bypass_req2_x                (sq_entry_fwd_bypass_req2[entry_i]               ),
        .sq_entry_fwd_bypass_req_sel_0_x           (sq_entry_fwd_bypass_req_sel_0[entry_i]         ),
        .sq_entry_fwd_bypass_req_sel_1_x           (sq_entry_fwd_bypass_req_sel_1[entry_i]         ),
        .sq_entry_fwd_bypass_req_sel_2_x           (sq_entry_fwd_bypass_req_sel_2[entry_i]         ),
        .sq_entry_fwd_bypass_req0_newer_x          (sq_entry_fwd_bypass_req0_newer[entry_i]         ),
        .sq_entry_fwd_bypass_req1_newer_x          (sq_entry_fwd_bypass_req1_newer[entry_i]         ),
        .sq_entry_fwd_bypass_req2_newer_x          (sq_entry_fwd_bypass_req2_newer[entry_i]         ),
        .sq_entry_older_than_ldc0_same_addr_newest (sq_entry_older_than_ldc0_same_addr_newest[entry_i] ), 
        .sq_entry_older_than_lsdc0_same_addr_newest(sq_entry_older_than_lsdc0_same_addr_newest[entry_i]),
        .sq_entry_older_than_lsdc1_same_addr_newest(sq_entry_older_than_lsdc1_same_addr_newest[entry_i]),
        .sq_entry_fwd_req0_x                       (sq_entry_fwd_req0[entry_i]                      ),
        .sq_entry_fwd_req1_x                       (sq_entry_fwd_req1[entry_i]                      ),
        .sq_entry_fwd_req2_x                       (sq_entry_fwd_req2[entry_i]                      ),
        .sq_entry_icc_x                            (sq_entry_icc[entry_i]                          ),
        .sq_entry_preg_v                           (sq_entry_preg[entry_i]                          ),
        .sq_entry_idx_order_x                      (sq_entry_idx_order[entry_i]                    ),
        .sq_entry_iid_v                            (sq_entry_iid[entry_i]                           ),
        .sq_entry_inst_flush_x                     (sq_entry_inst_flush[entry_i]                   ),
        .sq_entry_inst_hit0_x                      (sq_entry_inst_hit0[entry_i]                     ),
        .sq_entry_inst_hit1_x                      (sq_entry_inst_hit1[entry_i]                     ),
        .sq_entry_inst_mode_v                      (sq_entry_inst_mode[entry_i]                     ),
        .sq_entry_inst_size_v                      (sq_entry_inst_size[entry_i]                     ),
        .sq_entry_inst_type_v                      (sq_entry_inst_type[entry_i]                     ),
        .sq_entry_inst_vls_x                       (sq_entry_inst_vls[entry_i]                     ),
        .sq_entry_itcm_hit_x                       (sq_entry_itcm_hit[entry_i]                     ),
        .sq_entry_lm_fail_x                        (sq_entry_lm_fail[entry_i]                      ),
        .sq_entry_newest_fwd_req_data_vld_short0_x (sq_entry_newest_fwd_req_data_vld_short0[entry_i]),
        .sq_entry_newest_fwd_req_data_vld_short1_x (sq_entry_newest_fwd_req_data_vld_short1[entry_i]),
        .sq_entry_newest_fwd_req_data_vld_short2_x (sq_entry_newest_fwd_req_data_vld_short2[entry_i]),
        .sq_entry_newest_fwd_req_data_vld0_x       (sq_entry_newest_fwd_req_data_vld0[entry_i]      ),
        .sq_entry_newest_fwd_req_data_vld1_x       (sq_entry_newest_fwd_req_data_vld1[entry_i]      ),
        .sq_entry_newest_fwd_req_data_vld2_x       (sq_entry_newest_fwd_req_data_vld2[entry_i]      ),
        .sq_entry_page_buf_x                       (sq_entry_page_buf[entry_i]                     ),
        .sq_entry_page_ca_x                        (sq_entry_page_ca[entry_i]                      ),
        .sq_entry_page_sec_x                       (sq_entry_page_sec[entry_i]                     ),
        .sq_entry_page_share_x                     (sq_entry_page_share[entry_i]                   ),
        .sq_entry_page_so_x                        (sq_entry_page_so[entry_i]                      ),
        .sq_entry_page_wa_x                        (sq_entry_page_wa[entry_i]                      ),
        .sq_entry_pop_req_x                        (sq_entry_pop_req[entry_i]                      ),
        .sq_entry_priv_mode_v                      (sq_entry_priv_mode[entry_i]                     ),
        .sq_entry_rot_sel_v                        (sq_entry_rot_sel[entry_i]                       ),
        .sq_entry_same_addr_newest_x               (sq_entry_same_addr_newest[entry_i]             ),
        .sq_entry_settle_data_hit0_x               (sq_entry_settle_data_hit0[entry_i]              ),
        .sq_entry_settle_data_hit1_x               (sq_entry_settle_data_hit1[entry_i]              ),  
        .sq_entry_spec_fail_x                      (sq_entry_spec_fail[entry_i]                    ),
        .sq_entry_lsdc0_create_age_vec_x           (sq_entry_lsdc0_create_age_vec[entry_i]         ),
        .sq_entry_lsdc1_create_age_vec_x           (sq_entry_lsdc1_create_age_vec[entry_i]         ),
        .sq_entry_lsdc0_same_addr_newer_x          (sq_entry_lsdc0_same_addr_newer[entry_i]        ),
        .sq_entry_lsdc1_same_addr_newer_x          (sq_entry_lsdc1_same_addr_newer[entry_i]        ),
        .sq_entry_ldc0_same_addr_older_x           (sq_entry_ldc0_same_addr_older[entry_i]         ),
        .sq_entry_lsdc0_same_addr_older_x          (sq_entry_lsdc0_same_addr_older[entry_i]        ),
        .sq_entry_lsdc1_same_addr_older_x          (sq_entry_lsdc1_same_addr_older[entry_i]        ),
        .sq_entry_sync_fence_x                     (sq_entry_sync_fence[entry_i]                   ),
        .sq_entry_vld_x                            (sq_entry_vld[entry_i]                          ),
        //.sq_entry_vsew_v                           (sq_entry_vsew[entry_i]                          ),//rvv1.0@hcl
        .sq_entry_vmew_v                           (sq_entry_vmew[entry_i]                          ),//rvv1.0@hcl
        .sq_entry_vmop_v                           (sq_entry_vmop[entry_i]                          ),//rvv1.0@hcl
        .sq_entry_vstart_vld_x                     (sq_entry_vstart_vld[entry_i]                   ),
        .sq_entry_wo_st_x                          (sq_entry_wo_st[entry_i]                        ),
        .sq_entry_init_dcache_miss_x               (sq_entry_init_dcache_miss[entry_i]             ),
        .sq_entry_ssp_va_x                         (sq_entry_ssp_va[entry_i]                       ),
        .sq_entry_pc_index_x                       (sq_entry_pc_index[entry_i]                     ),
        .sq_entry_already_send_st_stride_x         (sq_entry_already_send_st_stride[entry_i]       ),
        .sq_entry_st_stride_age_vec_zero_ptr_x     (sq_entry_st_stride_age_vec_zero_ptr[entry_i]   ),
//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
        //input
        .dtu_lsu_addr_halt_info0                   (dtu_lsu_ls0_addr_halt_info                     ),
        .dtu_lsu_addr_halt_info1                   (dtu_lsu_ls1_addr_halt_info                     ),
        .dtu_lsu_data_halt_info0                   (dtu_lsu_ls0_data_halt_info                     ),
        .dtu_lsu_data_halt_info1                   (dtu_lsu_ls1_data_halt_info                     ),
        .lsda0_st_da_wb_expt_vld_cancel            (ls0_st_da_wb_expt_vld_cancel                   ),
        .lsda1_st_da_wb_expt_vld_cancel            (ls1_st_da_wb_expt_vld_cancel                   ),
        .sq_entry_data_halt_info_update_vld_0      (sq_entry_data_halt_info_update_vld_0[entry_i]  ),
        .sq_entry_data_halt_info_update_vld_1      (sq_entry_data_halt_info_update_vld_1[entry_i]  ),
        .sq_entry_wake_data_grnt_0_x               (sq_entry_wake_data_grnt_0[entry_i]             ),
        .sq_entry_wake_data_grnt_1_x               (sq_entry_wake_data_grnt_1[entry_i]             ),
        .st_da_already_da_0                        (ls0_st_da_already_da                           ),
        .st_da_already_da_1                        (ls1_st_da_already_da                           ),
        .st_da_data_check_0                        (ls0_st_da_data_check                           ),
        .st_da_data_check_1                        (ls1_st_da_data_check                           ),
        //output
        .sq_entry_data_check_0_x                   (sq_entry_data_check_0[entry_i]                 ),
        .sq_entry_data_check_1_x                   (sq_entry_data_check_1[entry_i]                 ),
        .sq_entry_halt_info_0_v                    (sq_entry_halt_info_0[entry_i]                  ),
        .sq_entry_halt_info_1_v                    (sq_entry_halt_info_1[entry_i]                  ),
        .sq_entry_wake_data_req_0_x                (sq_entry_wake_data_req_0[entry_i]              ),
        .sq_entry_wake_data_req_1_x                (sq_entry_wake_data_req_1[entry_i]              )        
//==========================================================
//                  Risc-V Debug zdb End 
//==========================================================
      );
  end
endgenerate

assign sq_entry_already_st_stride_vec[SQ_ENTRY-1:0] = sq_entry_already_send_st_stride[SQ_ENTRY-1:0];

assign sq_send_st_stride_vld = |sq_entry_st_stride_age_vec_zero_ptr[SQ_ENTRY-1:0];
assign sq_send_st_stride_wo_st = |(sq_entry_st_stride_age_vec_zero_ptr[SQ_ENTRY-1:0] & sq_entry_wo_st[SQ_ENTRY-1:0]);
assign sq_send_st_stride_init_dcache_miss = |(sq_entry_st_stride_age_vec_zero_ptr[SQ_ENTRY-1:0] & sq_entry_init_dcache_miss[SQ_ENTRY-1:0]);
assign sq_send_st_stride_page_sec = |(sq_entry_st_stride_age_vec_zero_ptr[SQ_ENTRY-1:0] & sq_entry_page_sec[SQ_ENTRY-1:0]);
assign sq_send_st_stride_page_ca = |(sq_entry_st_stride_age_vec_zero_ptr[SQ_ENTRY-1:0] & sq_entry_page_ca[SQ_ENTRY-1:0]);
assign sq_send_st_stride_page_share = |(sq_entry_st_stride_age_vec_zero_ptr[SQ_ENTRY-1:0] & sq_entry_page_share[SQ_ENTRY-1:0]);

always_comb begin  //parameter for sq_send_st_stride_va, LTL@020250517
  sq_send_st_stride_va[1:0] = 2'b0;
  for(int i=0;i<SQ_ENTRY;i++) begin
    sq_send_st_stride_va[1:0] |= {2{sq_entry_st_stride_age_vec_zero_ptr[i]}} & sq_entry_ssp_va[i][1:0];
  end
end

always_comb begin  //parameter for sq_send_st_stride_pc_index, LTL@020250507
  sq_send_st_stride_pc_index[PC_LEN-1:0] = {PC_LEN{1'b0}};
  for(int i=0;i<SQ_ENTRY;i++) begin
    sq_send_st_stride_pc_index[PC_LEN-1:0] |= {PC_LEN{sq_entry_st_stride_age_vec_zero_ptr[i]}} & sq_entry_pc_index[i][PC_LEN-1:0];
  end
end
always_comb begin  //parameter for sq_send_st_stride_addr0, LTL@020250507
  sq_send_st_stride_addr0[WK_PA_WIDTH-1:0] = {WK_PA_WIDTH{1'b0}};
  for(int i=0;i<SQ_ENTRY;i++) begin
    sq_send_st_stride_addr0[WK_PA_WIDTH-1:0] |= {WK_PA_WIDTH{sq_entry_st_stride_age_vec_zero_ptr[i]}} & sq_entry_addr0[i][WK_PA_WIDTH-1:0];
  end
end
//==========================================================
//                Generate full/create signal
//==========================================================
//------------------create ptr------------------------------
//ptr 0 find empty entry from No.0
// &CombBeg; @168
//always @( sq_entry_vld[11:0])
//begin
//sq_create_ptr0 [SQ_ENTRY-1:0]   = {SQ_ENTRY{1'b0}};           //maintain 2 ptrs from 1, one for one lsdc   LTL@20241015
//casez(sq_entry_vld[SQ_ENTRY-1:0])
//  12'b????_????_???0:sq_create_ptr0 [0]  = 1'b1;
//  12'b????_????_??01:sq_create_ptr0 [1]  = 1'b1;
//  12'b????_????_?011:sq_create_ptr0 [2]  = 1'b1;
//  12'b????_????_0111:sq_create_ptr0 [3]  = 1'b1;
//  12'b????_???0_1111:sq_create_ptr0 [4]  = 1'b1;
//  12'b????_??01_1111:sq_create_ptr0 [5]  = 1'b1;
//  12'b????_?011_1111:sq_create_ptr0 [6]  = 1'b1;
//  12'b????_0111_1111:sq_create_ptr0 [7]  = 1'b1;
//  12'b???0_1111_1111:sq_create_ptr0 [8]  = 1'b1;
//  12'b??01_1111_1111:sq_create_ptr0 [9]  = 1'b1;
//  12'b?011_1111_1111:sq_create_ptr0 [10]  = 1'b1;
//  12'b0111_1111_1111:sq_create_ptr0 [11]  = 1'b1;
//  default:sq_create_ptr0 [SQ_ENTRY-1:0]   = {SQ_ENTRY{1'b0}};
//endcase
//// &CombEnd; @185
//end

always_comb begin                             //ptr 0, find first empty entry from No.0, parameterized, LTL@20241022
  first_empty_entry0[SQ_ENTRY-1:0] = {SQ_ENTRY{1'b1}};
  sq_create_ptr0[0] = !sq_entry_vld[0];
  sq_create_ptr0[SQ_ENTRY-1:1]  = {SQ_ENTRY-1{1'b0}};
  for(int i=1;i<SQ_ENTRY;i++) begin
    for(int j=0;j<i;j++) begin
      first_empty_entry0[i] = first_empty_entry0[i] & sq_entry_vld[j];
    end
    sq_create_ptr0[i] = (!sq_entry_vld[i]) & first_empty_entry0[i];   
  end
end
//ptr 1 find empty entry from No.11
// &CombBeg; @168
//always @( sq_entry_vld[11:0])
//begin
//sq_create_ptr1 [SQ_ENTRY-1:0]   = {SQ_ENTRY{1'b0}}; 
//casez(sq_entry_vld[SQ_ENTRY-1:0])
//  12'b0???_????_????:sq_create_ptr1 [11]  = 1'b1;
//  12'b10??_????_????:sq_create_ptr1 [10]  = 1'b1;
//  12'b110?_????_????:sq_create_ptr1 [9]  = 1'b1;
//  12'b1110_????_????:sq_create_ptr1 [8]  = 1'b1;
//  12'b1111_0???_????:sq_create_ptr1 [7]  = 1'b1;
//  12'b1111_10??_????:sq_create_ptr1 [6]  = 1'b1;
//  12'b1111_110?_????:sq_create_ptr1 [5]  = 1'b1;
//  12'b1111_1110_????:sq_create_ptr1 [4]  = 1'b1;
//  12'b1111_1111_0???:sq_create_ptr1 [3]  = 1'b1;
//  12'b1111_1111_10??:sq_create_ptr1 [2]  = 1'b1;
//  12'b1111_1111_110?:sq_create_ptr1 [1]  = 1'b1;
//  12'b1111_1111_1110:sq_create_ptr1 [0]  = 1'b1;
//  default:sq_create_ptr1 [SQ_ENTRY-1:0]   = {SQ_ENTRY{1'b0}};
//endcase
//// &CombEnd; @185
//end

always_comb begin                             //ptr 1, find first empty entry from No. SQ_ENTRY-1, parameterized, LTL@20241022
  first_empty_entry1[SQ_ENTRY-1:0] = {SQ_ENTRY{1'b1}};
  sq_create_ptr1[SQ_ENTRY-1] = !sq_entry_vld[SQ_ENTRY-1];
  sq_create_ptr1[SQ_ENTRY-2:0]  = {SQ_ENTRY-1{1'b0}};
  for(int i=SQ_ENTRY-2; i>-1; i--) begin
    for(int j=SQ_ENTRY-1; j>i; j--) begin
      first_empty_entry1[i] = first_empty_entry1[i] & sq_entry_vld[j];
    end
    sq_create_ptr1[i] = (!sq_entry_vld[i]) & first_empty_entry1[i];   
  end
end

always_comb begin                             //only 2 empty entry, 2 create need consider oldest, LTL@20241022
  sq_empty_count[0] = 1'b1;
  sq_empty_count[SQ_ENTRY-1:1] = {SQ_ENTRY-1{1'b0}};
  for(int i=0; i<SQ_ENTRY; i++) begin
    if(sq_entry_vld[i] == 1'b0) begin
      sq_empty_count = sq_empty_count << 1;
    end
  end
end
//------------------full signal-----------------------------
assign sq_has_cmit      = |(sq_entry_cmit[SQ_ENTRY-1:0]
                            & sq_entry_vld[SQ_ENTRY-1:0]);
assign sq_full          = &sq_entry_vld[SQ_ENTRY-1:0];
assign sq_empty_less2   = &(sq_entry_vld[SQ_ENTRY-1:0]
                            | sq_create_ptr0 [SQ_ENTRY-1:0]);   //sq_create_ptr ->sq_create_ptr0, use ptr1 also okay  LTL@20241015
assign sq_has_only2_empty = (sq_empty_count[2] == 1'b1);

assign sq_lsdc0_ex2_inst_hit= |sq_entry_inst_hit0[SQ_ENTRY-1:0]; //sq_entry_inst_hit->sq_entry_inst_hit0 ,LTL@20241015
assign sq_lsdc1_ex2_inst_hit= |sq_entry_inst_hit1[SQ_ENTRY-1:0]; //sq_entry_inst_hit->sq_entry_inst_hit1 ,LTL@20241015

assign sq_lsdc0_ex2_full    = sq_full                            // 1->2 for two lsdc by LTL@20241015
                          ||  !lsdc0_ex2_old
                              &&  sq_empty_less2
                              &&  !sq_has_cmit
                          ||  sq_less2_need_discard_st0
                          ||  sq_empty2_need_discard_st0;        //cond3, 2 st dc and 1 empty entry,choose older LTL@20241015

assign sq_lsdc1_ex2_full    = sq_full                             // 1->2 for two lsdc by LTL@20241015
                          ||  !lsdc1_ex2_old
                              &&  sq_empty_less2
                              &&  !sq_has_cmit
                          ||  sq_less2_need_discard_st1
                          ||  sq_empty2_need_discard_st1;        //cond3, 2 st dc and 1 empty entry,choose older LTL@20241015 

assign sq_less2_need_discard_st0 = sq_empty_less2             
                            && !lsdc0_older_than_lsdc1   //cond3, 2 st dc and 1 empty entry,choose older LTL@20241015
                            && lsdc0_sq_ex2_create_vld   //lsdc0 iid compare with lsdc1's, =1 older, LTL@20241015
                            && lsdc1_sq_ex2_create_vld;  //
assign sq_less2_need_discard_st1 = sq_empty_less2             
                            && lsdc0_older_than_lsdc1    //cond3, 2 st dc and 1 empty entry,choose older LTL@20241015
                            && lsdc0_sq_ex2_create_vld   //lsdc0 iid compare with lsdc1's, =1 older, LTL@20241015 
                            && lsdc1_sq_ex2_create_vld;  //

assign sq_empty2_need_discard_st0 = sq_has_only2_empty   //2 empty and no one is old, need discard 1 req, LTL@20241113        
                            && !lsdc0_older_than_lsdc1   
                            && !lsdc1_ex2_old
                            && lsdc0_sq_ex2_create_vld   
                            && lsdc1_sq_ex2_create_vld; 
assign sq_empty2_need_discard_st1 = sq_has_only2_empty   //2 empty and no one is old, need discard 1 req, LTL@20241113               
                            && lsdc0_older_than_lsdc1  
                            && !lsdc0_ex2_old
                            && lsdc0_sq_ex2_create_vld 
                            && lsdc1_sq_ex2_create_vld;

assign sq_create_req2_need_discard_st0 = sq_less2_need_discard_st0;//lsu_timing@LTL || sq_empty2_need_discard_st0;  //2 create req simultaneously, discard 1, LTL@2024113
assign sq_create_req2_need_discard_st1 = sq_less2_need_discard_st1;//lsu_timing@LTL || sq_empty2_need_discard_st1;

xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH))
x_lsdc0_iid_compare_lsdc1_iid (
  .x_iid0         (lsdc0_ex2_st_iid[IID_WIDTH-1:0]),//logic levels opt@LTL
  .x_iid0_older   (lsdc0_older_than_lsdc1      ),
  .x_iid1         (lsdc1_ex2_st_iid[IID_WIDTH-1:0]) //logic levels opt@LTL
);
xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH))
x_ck_flush_iid_compare_lsdc0_iid (
  .x_iid0         (rtu_ck_flush_iid[IID_WIDTH-1:0]    ),
  .x_iid0_older   (rtu_ck_flush_iid_older_than_lsdc0  ),
  .x_iid1         (lsdc0_ex2_st_iid[IID_WIDTH-1:0]    ) //logic levels opt@LTL
);
xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH))
x_ck_flush_iid_compare_lsdc1_iid (
  .x_iid0         (rtu_ck_flush_iid[IID_WIDTH-1:0]    ),
  .x_iid0_older   (rtu_ck_flush_iid_older_than_lsdc1  ),
  .x_iid1         (lsdc1_ex2_st_iid[IID_WIDTH-1:0]    ) //logic levels opt@LTL
);
//------------------empty signal----------------------------
// &Force("output","sq_empty"); @201
assign sq_empty         = !(|sq_entry_vld[SQ_ENTRY-1:0]);
//------------------create signal---------------------------
assign sq_create_success0  = lsdc0_sq_ex2_create_vld
                            &&  !sq_lsdc0_ex2_full
                            &&  !rtu_lsu_flush_fe
                            &&  !(rtu_ck_flush && rtu_ck_flush_iid_older_than_lsdc0); //flush younger create, ck_flush@LTL
assign sq_create_success1  = lsdc1_sq_ex2_create_vld
                            &&  !sq_lsdc1_ex2_full
                            &&  !rtu_lsu_flush_fe
                            &&  !(rtu_ck_flush && rtu_ck_flush_iid_older_than_lsdc1); //flush younger create, ck_flush@LTL

assign sq_entry_create_vld0[SQ_ENTRY-1:0] = {{SQ_ENTRY{sq_create_success0}} & sq_create_ptr0 [SQ_ENTRY-1:0]};   //1->2 added by LTL@20241015, contain 2 ptr
assign sq_entry_create_vld1[SQ_ENTRY-1:0] = {{SQ_ENTRY{sq_create_success1}} & sq_create_ptr1 [SQ_ENTRY-1:0]};   //1->2 added by LTL@20241015, contain 2 ptr

assign sq_entry_create_dp_vld0[SQ_ENTRY-1:0]  = {{SQ_ENTRY{lsdc0_sq_ex2_create_dp_vld && !sq_create_req2_need_discard_st0}} //whether to use sq_lsdc0_ex2_full???  LTL@20241016
                                                & sq_create_ptr0 [SQ_ENTRY-1:0]};   //1->2 added by LTL@20241015, contain 2 ptr
assign sq_entry_create_dp_vld1[SQ_ENTRY-1:0]  = {{SQ_ENTRY{lsdc1_sq_ex2_create_dp_vld && !sq_create_req2_need_discard_st1}} //whether to use sq_lsdc0_ex2_full???  LTL@20241016
                                                & sq_create_ptr1 [SQ_ENTRY-1:0]};   //1->2 added by LTL@20241015, contain 2 ptr
                             
assign sq_entry_create_gateclk_en0[SQ_ENTRY-1:0] = {{SQ_ENTRY{lsdc0_sq_ex2_create_gateclk_en && !sq_create_req2_need_discard_st0}} //whether to use sq_lsdc0_ex2_full???  LTL@20241016
                                                  & sq_create_ptr0 [SQ_ENTRY-1:0]};   //1->2 added by LTL@20241015, contain 2 ptr
assign sq_entry_create_gateclk_en1[SQ_ENTRY-1:0] = {{SQ_ENTRY{lsdc1_sq_ex2_create_gateclk_en && !sq_create_req2_need_discard_st1}} //whether to use sq_lsdc0_ex2_full???  LTL@20241016
                                                  & sq_create_ptr1 [SQ_ENTRY-1:0]};   //1->2 added by LTL@20241015, contain 2 ptr

assign lsdc_lsdc_same_addr_newer0 = sq_create_success0
                                    && !lsdc0_older_than_lsdc1                                //lsdc0 is older,LTL@20250603
                                    && (lsdc0_ex2_st_addr0[WK_PA_WIDTH-1:4] == lsdc1_ex2_st_addr0[WK_PA_WIDTH-1:4])    //same addr
                                    && (|(lsdc0_ex2_st_bytes_vld[15:0] & lsdc1_ex2_st_bytes_vld[15:0]));             //if 1 discard, then 0 newer   //whether to use sq_lsdc1_ex2_full???  LTL@20241016                      
assign lsdc_lsdc_same_addr_newer1 = sq_create_success1
                                    && lsdc0_older_than_lsdc1                               //lsdc1 is older,LTL@20250603
                                    && (lsdc0_ex2_st_addr0[WK_PA_WIDTH-1:4] == lsdc1_ex2_st_addr0[WK_PA_WIDTH-1:4])   //same addr
                                    && (|(lsdc0_ex2_st_bytes_vld[15:0] & lsdc1_ex2_st_bytes_vld[15:0]));             //if 0 discard, then 1 newer   //whether to use sq_lsdc0_ex2_full???  LTL@20241016
assign sq_create_same_addr_newest0 = (&(~sq_entry_lsdc0_same_addr_newer[SQ_ENTRY-1:0])) && (!lsdc_lsdc_same_addr_newer1);  //add dc compare result LTL@20241015
assign sq_create_same_addr_newest1 = (&(~sq_entry_lsdc1_same_addr_newer[SQ_ENTRY-1:0])) && (!lsdc_lsdc_same_addr_newer0);  //add dc compare result LTL@20241015
//------------------create age_vec signal-------------------
assign sq_create_vld0[SQ_ENTRY-1:0]      = sq_entry_create_vld0[SQ_ENTRY-1:0];  //used to update entry age_vec, 1->2  LTL@20241016
assign sq_create_vld1[SQ_ENTRY-1:0]      = sq_entry_create_vld1[SQ_ENTRY-1:0]; //newly add  LTL@20241016

assign sq_create_age_vec0[SQ_ENTRY-1:0]  = sq_entry_lsdc0_create_age_vec[SQ_ENTRY-1:0]
                                          | ({SQ_ENTRY{(!lsdc0_older_than_lsdc1) && sq_create_success1}} & sq_create_ptr1);   //if lsdc1 older, set the sq_create_ptr1 position =1, | sq_create_ptr -> & LTL@20241113
assign sq_create_age_vec1[SQ_ENTRY-1:0]  = sq_entry_lsdc1_create_age_vec[SQ_ENTRY-1:0]
                                          | ({SQ_ENTRY{lsdc0_older_than_lsdc1 && sq_create_success0}} & sq_create_ptr0);  //if lsdc0 older, set the sq_create_ptr0 position =1, | sq_create_ptr -> & LTL@20241113

assign sq_age_vec_set = sq_create_success0 || sq_create_success1 || wmb_sq_pop_to_ce_grnt || sq_pop_expt_nop_vld;  //contain 2 create condition,  LTL@20241016

//==========================================================
//            Settle data to memory mode
//==========================================================
//------------------settle data to register mode------------
//narrow reg element to memory size
//assign sq_settle_element_size[1:0]  = {2{sq_entry_settle_data_hit[0]}}  & sq_entry_element_size_0[1:0]  //parameter, LTL@20241022
//                                      | {2{sq_entry_settle_data_hit[1]}}  & sq_entry_element_size_1[1:0]
//                                      | {2{sq_entry_settle_data_hit[2]}}  & sq_entry_element_size_2[1:0]
//                                      | {2{sq_entry_settle_data_hit[3]}}  & sq_entry_element_size_3[1:0]
//                                      | {2{sq_entry_settle_data_hit[4]}}  & sq_entry_element_size_4[1:0]
//                                      | {2{sq_entry_settle_data_hit[5]}}  & sq_entry_element_size_5[1:0]
//                                      | {2{sq_entry_settle_data_hit[6]}}  & sq_entry_element_size_6[1:0]
//                                      | {2{sq_entry_settle_data_hit[7]}}  & sq_entry_element_size_7[1:0]
//                                      | {2{sq_entry_settle_data_hit[8]}}  & sq_entry_element_size_8[1:0]
//                                      | {2{sq_entry_settle_data_hit[9]}}  & sq_entry_element_size_9[1:0]
//                                      | {2{sq_entry_settle_data_hit[10]}}  & sq_entry_element_size_10[1:0]
//                                      | {2{sq_entry_settle_data_hit[11]}}  & sq_entry_element_size_11[1:0];

always_comb begin    //parameter for sq_settle_element_size, LTL@20241022
  sq_settle_element_size0[1:0] = 2'b0;
  for(int i=0;i<SQ_ENTRY;i++) begin
    sq_settle_element_size0 |= {2{sq_entry_settle_data_hit0[i]}} & sq_entry_element_size[i][1:0];  //element_size 
  end
end                                     
always_comb begin    //1->2, LTL@20241022  
  sq_settle_element_size1[1:0] = 2'b0;
  for(int i=0;i<SQ_ENTRY;i++) begin
    sq_settle_element_size1 |= {2{sq_entry_settle_data_hit1[i]}} & sq_entry_element_size[i][1:0];
  end
end 

//assign sq_settle_vsew[1:0]          = {2{sq_entry_settle_data_hit[0]}}  & sq_entry_vsew_0[1:0]                
//                                      | {2{sq_entry_settle_data_hit[1]}}  & sq_entry_vsew_1[1:0]
//                                      | {2{sq_entry_settle_data_hit[2]}}  & sq_entry_vsew_2[1:0]
//                                      | {2{sq_entry_settle_data_hit[3]}}  & sq_entry_vsew_3[1:0]
//                                      | {2{sq_entry_settle_data_hit[4]}}  & sq_entry_vsew_4[1:0]
//                                      | {2{sq_entry_settle_data_hit[5]}}  & sq_entry_vsew_5[1:0]
//                                      | {2{sq_entry_settle_data_hit[6]}}  & sq_entry_vsew_6[1:0]
//                                      | {2{sq_entry_settle_data_hit[7]}}  & sq_entry_vsew_7[1:0]
//                                      | {2{sq_entry_settle_data_hit[8]}}  & sq_entry_vsew_8[1:0]
//                                      | {2{sq_entry_settle_data_hit[9]}}  & sq_entry_vsew_9[1:0]
//                                      | {2{sq_entry_settle_data_hit[10]}}  & sq_entry_vsew_10[1:0]
//                                      | {2{sq_entry_settle_data_hit[11]}}  & sq_entry_vsew_11[1:0];
//here   no extend directly in rvv1.0@hcl
always_comb begin    //parameter for sq_settle_vsew, LTL@20241022
  sq_settle_vmew0[1:0] = 2'b0;
  for(int i=0;i<SQ_ENTRY;i++) begin
    sq_settle_vmew0 |= {2{sq_entry_settle_data_hit0[i]}} & sq_entry_vmew[i][1:0];
  end
end 
always_comb begin    //1->2, parameter for sq_settle_vsew, LTL@20241022
  sq_settle_vmew1[1:0] = 2'b0;
  for(int i=0;i<SQ_ENTRY;i++) begin
    sq_settle_vmew1 |= {2{sq_entry_settle_data_hit1[i]}} & sq_entry_vmew[i][1:0];
  end
end 

assign sq_settle_inst_vls0 = |(sq_entry_settle_data_hit0[SQ_ENTRY-1:0] & sq_entry_inst_vls[SQ_ENTRY-1:0]);
assign sq_settle_inst_vls1 = |(sq_entry_settle_data_hit1[SQ_ENTRY-1:0] & sq_entry_inst_vls[SQ_ENTRY-1:0]);   //add LTL@20241016

// &CombBeg; @263
always @( sq_settle_inst_vls0
       or sq_settle_vmew0[1:0]
       or sq_settle_element_size0[1:0]
       or std0_sq_ex1_data[127:0])
begin
case({sq_settle_inst_vls0,sq_settle_element_size0[1:0],sq_settle_vmew0[1:0]})
  {1'b1,S_BYTE,HALF}: sq_data_ori0[127:0] = {64'b0,
                                          std0_sq_ex1_data[119:112],  
                                          std0_sq_ex1_data[103:96],  
                                          std0_sq_ex1_data[87:80],  
                                          std0_sq_ex1_data[71:64],  
                                          std0_sq_ex1_data[55:48],  
                                          std0_sq_ex1_data[39:32],  
                                          std0_sq_ex1_data[23:16],  
                                          std0_sq_ex1_data[7:0]};
  {1'b1,S_BYTE,WORD}: sq_data_ori0[127:0] = {96'b0,
                                          std0_sq_ex1_data[103:96],  
                                          std0_sq_ex1_data[71:64],  
                                          std0_sq_ex1_data[39:32],  
                                          std0_sq_ex1_data[7:0]};
  {1'b1,S_BYTE,DWORD}:sq_data_ori0[127:0] = {112'b0,
                                          std0_sq_ex1_data[71:64],  
                                          std0_sq_ex1_data[7:0]};
  {1'b1,HALF,WORD}: sq_data_ori0[127:0] = {64'b0,
                                          std0_sq_ex1_data[111:96],  
                                          std0_sq_ex1_data[79:64],  
                                          std0_sq_ex1_data[47:32],  
                                          std0_sq_ex1_data[15:0]};
  {1'b1,HALF,DWORD}:sq_data_ori0[127:0] = {96'b0,
                                          std0_sq_ex1_data[79:64],  
                                          std0_sq_ex1_data[15:0]};
  {1'b1,WORD,DWORD}:sq_data_ori0[127:0] = {64'b0,
                                          std0_sq_ex1_data[95:64],  
                                          std0_sq_ex1_data[31:0]};       
  default:sq_data_ori0[127:0] = std0_sq_ex1_data[127:0];         
endcase
// &CombEnd; @295
end
// rvv
always @( sq_settle_inst_vls1
       or sq_settle_vmew1[1:0]
       or sq_settle_element_size1[1:0]
       or std1_sq_ex1_data[127:0])
begin
case({sq_settle_inst_vls1,sq_settle_element_size1[1:0],sq_settle_vmew1[1:0]})                     //add LTL@20241016
  {1'b1,S_BYTE,HALF}: sq_data_ori1[127:0] = {64'b0,
                                          std1_sq_ex1_data[119:112],  
                                          std1_sq_ex1_data[103:96],  
                                          std1_sq_ex1_data[87:80],  
                                          std1_sq_ex1_data[71:64],  
                                          std1_sq_ex1_data[55:48],  
                                          std1_sq_ex1_data[39:32],  
                                          std1_sq_ex1_data[23:16],  
                                          std1_sq_ex1_data[7:0]};
  {1'b1,S_BYTE,WORD}: sq_data_ori1[127:0] = {96'b0,
                                          std1_sq_ex1_data[103:96],  
                                          std1_sq_ex1_data[71:64],  
                                          std1_sq_ex1_data[39:32],  
                                          std1_sq_ex1_data[7:0]};
  {1'b1,S_BYTE,DWORD}:sq_data_ori1[127:0] = {112'b0,
                                          std1_sq_ex1_data[71:64],  
                                          std1_sq_ex1_data[7:0]};
  {1'b1,HALF,WORD}: sq_data_ori1[127:0] = {64'b0,
                                          std1_sq_ex1_data[111:96],  
                                          std1_sq_ex1_data[79:64],  
                                          std1_sq_ex1_data[47:32],  
                                          std1_sq_ex1_data[15:0]};
  {1'b1,HALF,DWORD}:sq_data_ori1[127:0] = {96'b0,
                                          std1_sq_ex1_data[79:64],  
                                          std1_sq_ex1_data[15:0]};
  {1'b1,WORD,DWORD}:sq_data_ori1[127:0] = {64'b0,
                                          std1_sq_ex1_data[95:64],  
                                          std1_sq_ex1_data[31:0]};       
  default:sq_data_ori1[127:0] = std1_sq_ex1_data[127:0];         
endcase
// &CombEnd; @295
end

//assign sq_settle_rot_sel[15:0]  = {16{sq_entry_settle_data_hit[0]}}  & sq_entry_rot_sel_0[15:0]             
//                                  | {16{sq_entry_settle_data_hit[1]}}  & sq_entry_rot_sel_1[15:0]
//                                  | {16{sq_entry_settle_data_hit[2]}}  & sq_entry_rot_sel_2[15:0]
//                                  | {16{sq_entry_settle_data_hit[3]}}  & sq_entry_rot_sel_3[15:0]
//                                  | {16{sq_entry_settle_data_hit[4]}}  & sq_entry_rot_sel_4[15:0]
//                                  | {16{sq_entry_settle_data_hit[5]}}  & sq_entry_rot_sel_5[15:0]
//                                  | {16{sq_entry_settle_data_hit[6]}}  & sq_entry_rot_sel_6[15:0]
//                                  | {16{sq_entry_settle_data_hit[7]}}  & sq_entry_rot_sel_7[15:0]
//                                  | {16{sq_entry_settle_data_hit[8]}}  & sq_entry_rot_sel_8[15:0]
//                                  | {16{sq_entry_settle_data_hit[9]}}  & sq_entry_rot_sel_9[15:0]
//                                  | {16{sq_entry_settle_data_hit[10]}}  & sq_entry_rot_sel_10[15:0]
//                                  | {16{sq_entry_settle_data_hit[11]}}  & sq_entry_rot_sel_11[15:0];

always_comb begin    //parameter for sq_settle_vsew, LTL@20241022
  sq_settle_rot_sel0[15:0] = 16'b0;
  for(int i=0;i<SQ_ENTRY;i++) begin
    sq_settle_rot_sel0 |= {16{sq_entry_settle_data_hit0[i]}} & sq_entry_rot_sel[i][15:0];
  end
end 
always_comb begin    //parameter for sq_settle_vsew, LTL@20241022
  sq_settle_rot_sel1[15:0] = 16'b0;
  for(int i=0;i<SQ_ENTRY;i++) begin
    sq_settle_rot_sel1 |= {16{sq_entry_settle_data_hit1[i]}} & sq_entry_rot_sel[i][15:0];
  end
end

//rotate data
// &Instance("xx_lsu_rot_data", "x_lsu_sq_data_rot_to_mem_format"); @327
xx_lsu_rot_data  x_lsu_sq_data_rot_to_mem_format0 (
  .data_in           (sq_data_ori0      ),
  .data_settle_out   (sq_data_after_rot0),
  .rot_sel           (sq_settle_rot_sel0)
);

xx_lsu_rot_data  x_lsu_sq_data_rot_to_mem_format1 (              //add LTL@20241016
  .data_in           (sq_data_ori1      ),
  .data_settle_out   (sq_data_after_rot1),
  .rot_sel           (sq_settle_rot_sel1)
);

// &Connect(.rot_sel         (sq_settle_rot_sel  ), @328
//          .data_in         (sq_data_ori0        ), @329
//          .data_settle_out (sq_data_after_rot  )); @330

assign sq_data_settle0[127:0]       = sq_data_after_rot0[127:0];
assign sq_data_settle1[127:0]       = sq_data_after_rot1[127:0];   //add LTL@20241016

//==========================================================
//            sq to ld_dc depd/discard signal
//==========================================================
//------------------request---------------------------------
// &Force("output","sq_lda0_ex2_other_discard_req"); @343
assign sq_ldc0_ex2_cancel_ahead_wb   = (|sq_entry_cancel_ahead_wb0[SQ_ENTRY-1:0]     //1->3, 1 pipe change to 3 pipes, LTL@20241016
                                       && !sq_lda0_ex2_newest_fwd_data_vld_req
                                    || sq_lda0_ex2_other_discard_req);
assign sq_lsdc0_ex2_cancel_ahead_wb   = (|sq_entry_cancel_ahead_wb1[SQ_ENTRY-1:0]
                                       && !sq_lsda0_ex2_newest_fwd_data_vld_req
                                    || sq_lsda0_ex2_other_discard_req);
assign sq_lsdc1_ex2_cancel_ahead_wb   = (|sq_entry_cancel_ahead_wb2[SQ_ENTRY-1:0]
                                       && !sq_lsda1_ex2_newest_fwd_data_vld_req
                                    || sq_lsda1_ex2_other_discard_req);

assign sq_lda0_ex2_other_discard_req  = |sq_entry_discard_req0[SQ_ENTRY-1:0];        //1->3, 1 pipe change to 3 pipes, LTL@20241016
assign sq_lsda0_ex2_other_discard_req = |sq_entry_discard_req1[SQ_ENTRY-1:0];
assign sq_lsda1_ex2_other_discard_req = |sq_entry_discard_req2[SQ_ENTRY-1:0];


assign sq_ldc0_ex2_addr1_dep_discard = |sq_entry_addr1_dep_discard0[SQ_ENTRY-1:0]; //1->3, 1 pipe change to 3 pipes, LTL@20241016
assign sq_lsdc0_ex2_addr1_dep_discard = |sq_entry_addr1_dep_discard1[SQ_ENTRY-1:0]; 
assign sq_lsdc1_ex2_addr1_dep_discard = |sq_entry_addr1_dep_discard2[SQ_ENTRY-1:0]; 

assign sq_ldc0_ex2_cancel_acc_req     = |sq_entry_cancel_acc_req0[SQ_ENTRY-1:0];   //1->3, cache buffer acc is deleted, do not 1->3 LTL@20241016
assign sq_lsdc0_ex2_cancel_acc_req    = |sq_entry_cancel_acc_req1[SQ_ENTRY-1:0];
assign sq_lsdc1_ex2_cancel_acc_req    = |sq_entry_cancel_acc_req2[SQ_ENTRY-1:0];
//assign sq_ldc0_ex2_cancel_acc_req     = 'b1;   //cache buffer acc is deleted, do not 1->3 LTL@20241016
//assign sq_lsdc0_ex2_cancel_acc_req    = 'b1;
//assign sq_lsdc1_ex2_cancel_acc_req    = 'b1;
//------------------data depd-------------------------------
assign sq_fwd_bypass_req0            = |sq_entry_fwd_bypass_req0[SQ_ENTRY-1:0];    //1->3, cond5. 1 change to 3, LTL@20241016
assign sq_fwd_bypass_req1            = |sq_entry_fwd_bypass_req1[SQ_ENTRY-1:0];
assign sq_fwd_bypass_req2            = |sq_entry_fwd_bypass_req2[SQ_ENTRY-1:0];


assign sq_newest_fwd_bypass_req0     = |(sq_entry_fwd_bypass_req0[SQ_ENTRY-1:0]    //1->3, cond5. 1 change to 3, LTL@20241016
                                        & sq_entry_older_than_ldc0_same_addr_newest[SQ_ENTRY-1:0]);
                                        //& sq_entry_same_addr_newest[SQ_ENTRY-1:0]);  //avoid multi-fwd not same addr
assign sq_newest_fwd_bypass_req1     = |(sq_entry_fwd_bypass_req1[SQ_ENTRY-1:0]
                                        & sq_entry_older_than_lsdc0_same_addr_newest[SQ_ENTRY-1:0]);
                                        //& sq_entry_same_addr_newest[SQ_ENTRY-1:0]);
assign sq_newest_fwd_bypass_req2     = |(sq_entry_fwd_bypass_req2[SQ_ENTRY-1:0]
                                        & sq_entry_older_than_lsdc1_same_addr_newest[SQ_ENTRY-1:0]);
                                        //& sq_entry_same_addr_newest[SQ_ENTRY-1:0]);

//---------------newly add logic to decide std0 or std1 when bypass path is ok, LTL@20241104

assign sq_entry_fwd_bypass_req0_vec[SQ_ENTRY-1:0] = sq_entry_fwd_bypass_req0[SQ_ENTRY-1:0];
assign sq_entry_fwd_bypass_req1_vec[SQ_ENTRY-1:0] = sq_entry_fwd_bypass_req1[SQ_ENTRY-1:0];
assign sq_entry_fwd_bypass_req2_vec[SQ_ENTRY-1:0] = sq_entry_fwd_bypass_req2[SQ_ENTRY-1:0];

assign sq_entry_fwd_bypass_req0_has_two = |sq_entry_fwd_bypass_req0_newer[SQ_ENTRY-1:0];  //two sq_entry bypass for ldc0, LTL@20250529
assign sq_entry_fwd_bypass_req1_has_two = |sq_entry_fwd_bypass_req1_newer[SQ_ENTRY-1:0];  //two sq_entry bypass for lsdc0, LTL@20250529
assign sq_entry_fwd_bypass_req2_has_two = |sq_entry_fwd_bypass_req2_newer[SQ_ENTRY-1:0];  //two sq_entry bypass for lsdc1, LTL@20250529

assign sq_newest_fwd_bypass_vec0[SQ_ENTRY-1:0] = (sq_entry_fwd_bypass_req0[SQ_ENTRY-1:0]    //1->3, cond5. 1 change to 3, LTL@20241016
                            & sq_entry_older_than_ldc0_same_addr_newest[SQ_ENTRY-1:0]);
                            //& sq_entry_same_addr_newest[SQ_ENTRY-1:0]);
assign sq_lda0_newest_fwd_bypass_req_sel  = |(sq_newest_fwd_bypass_vec0[SQ_ENTRY-1:0] & sq_entry_fwd_bypass_req_sel_0[SQ_ENTRY-1:0]);   //choose newest bypass std0 or std1, LTL@20250530
assign sq_lda0_fwd_bypass_req_sel         = |(sq_entry_fwd_bypass_req0[SQ_ENTRY-1:0] & sq_entry_fwd_bypass_req_sel_0[SQ_ENTRY-1:0]);     //choose one bypass std0 or std1, LTL@20250530
assign sq_lda0_fwd_bypass_req_sel_newer   = |(sq_entry_fwd_bypass_req0_newer[SQ_ENTRY-1:0] & sq_entry_fwd_bypass_req_sel_0[SQ_ENTRY-1:0]);//choose newer one bypass std0 or std1, LTL@20250530

assign sq_newest_fwd_bypass_vec1[SQ_ENTRY-1:0] = (sq_entry_fwd_bypass_req1[SQ_ENTRY-1:0]
                            & sq_entry_older_than_lsdc0_same_addr_newest[SQ_ENTRY-1:0]);
                            //& sq_entry_same_addr_newest[SQ_ENTRY-1:0]);
assign sq_lsda0_newest_fwd_bypass_req_sel  = |(sq_newest_fwd_bypass_vec1[SQ_ENTRY-1:0] & sq_entry_fwd_bypass_req_sel_1[SQ_ENTRY-1:0]);   //choose newest bypass std0 or std1, LTL@20250530
assign sq_lsda0_fwd_bypass_req_sel         = |(sq_entry_fwd_bypass_req1[SQ_ENTRY-1:0] & sq_entry_fwd_bypass_req_sel_1[SQ_ENTRY-1:0]);     //choose one bypass std0 or std1, LTL@20250530
assign sq_lsda0_fwd_bypass_req_sel_newer   = |(sq_entry_fwd_bypass_req1_newer[SQ_ENTRY-1:0] & sq_entry_fwd_bypass_req_sel_1[SQ_ENTRY-1:0]);//choose newer one bypass std0 or std1, LTL@20250530


assign sq_newest_fwd_bypass_vec2[SQ_ENTRY-1:0] = (sq_entry_fwd_bypass_req2[SQ_ENTRY-1:0]
                            & sq_entry_older_than_lsdc1_same_addr_newest[SQ_ENTRY-1:0]);
                            //& sq_entry_same_addr_newest[SQ_ENTRY-1:0]);
assign sq_lsda1_newest_fwd_bypass_req_sel  = |(sq_newest_fwd_bypass_vec2[SQ_ENTRY-1:0] & sq_entry_fwd_bypass_req_sel_2[SQ_ENTRY-1:0]);   //choose newest bypass std0 or std1, LTL@20250530
assign sq_lsda1_fwd_bypass_req_sel         = |(sq_entry_fwd_bypass_req2[SQ_ENTRY-1:0] & sq_entry_fwd_bypass_req_sel_2[SQ_ENTRY-1:0]);     //choose one bypass std0 or std1, LTL@20250530
assign sq_lsda1_fwd_bypass_req_sel_newer   = |(sq_entry_fwd_bypass_req2_newer[SQ_ENTRY-1:0] & sq_entry_fwd_bypass_req_sel_2[SQ_ENTRY-1:0]);//choose newer one bypass std0 or std1, LTL@20250530

//-----------------newly add logic to decide std0 or std1 when bypass path is ok, LTL@20241104

assign sq_data_discard_req_short0    = |sq_entry_data_discard_req_short0[SQ_ENTRY-1:0];  //1->3, cond6. 1 change to 3, LTL@20241016
assign sq_data_discard_req_short1    = |sq_entry_data_discard_req_short1[SQ_ENTRY-1:0];
assign sq_data_discard_req_short2    = |sq_entry_data_discard_req_short2[SQ_ENTRY-1:0];

assign sq_data_discard_req0          = |sq_entry_data_discard_req0[SQ_ENTRY-1:0];   //1->3, cond6&&!cond5. 1 change to 3, LTL@20241016
assign sq_data_discard_req1          = |sq_entry_data_discard_req1[SQ_ENTRY-1:0]; 
assign sq_data_discard_req2          = |sq_entry_data_discard_req2[SQ_ENTRY-1:0]; 

//assign sq_newest_data_discard_req   = |(sq_entry_data_discard_req[SQ_ENTRY-1:0]
//                                        & sq_entry_same_addr_newest[SQ_ENTRY-1:0]);


always_comb begin     //LTL@20251010, avoid multi-fwd, while not same addr newest
  for(int i=0;i<SQ_ENTRY;i++) begin
    for(int j=0;j<SQ_ENTRY;j++) begin
      if(j==i)begin
        sq_entry_same_addr_older_than_ldc0_vec[i][j] = 1'b0;
        sq_entry_same_addr_older_than_lsdc0_vec[i][j] = 1'b0;
        sq_entry_same_addr_older_than_lsdc1_vec[i][j] = 1'b0;
      end
      else begin
        sq_entry_same_addr_older_than_ldc0_vec[i][j] = sq_entry_ldc0_same_addr_older[j];
        sq_entry_same_addr_older_than_lsdc0_vec[i][j] = sq_entry_lsdc0_same_addr_older[j];
        sq_entry_same_addr_older_than_lsdc1_vec[i][j] = sq_entry_lsdc1_same_addr_older[j];
      end
    end
  end
end

assign sq_fwd_req0                   = |sq_entry_fwd_req0[SQ_ENTRY-1:0];          //1->3, cond7. 1 change to 3, LTL@20241016
assign sq_fwd_req1                   = |sq_entry_fwd_req1[SQ_ENTRY-1:0];
assign sq_fwd_req2                   = |sq_entry_fwd_req2[SQ_ENTRY-1:0];
assign sq_newest_fwd_req_id0[SQ_ENTRY-1:0] = sq_entry_fwd_req0[SQ_ENTRY-1:0]        //1->3, cond7. 1 change to 3, LTL@20241016
                                            & sq_entry_older_than_ldc0_same_addr_newest[SQ_ENTRY-1:0];
                                            //& sq_entry_same_addr_newest[SQ_ENTRY-1:0];
assign sq_newest_fwd_req_id1[SQ_ENTRY-1:0] = sq_entry_fwd_req1[SQ_ENTRY-1:0]        //cond7. 1 change to 3, LTL@20241016
                                            & sq_entry_older_than_lsdc0_same_addr_newest[SQ_ENTRY-1:0];
                                            //& sq_entry_same_addr_newest[SQ_ENTRY-1:0];
assign sq_newest_fwd_req_id2[SQ_ENTRY-1:0] = sq_entry_fwd_req2[SQ_ENTRY-1:0]        //cond7. 1 change to 3, LTL@20241016
                                            & sq_entry_older_than_lsdc1_same_addr_newest[SQ_ENTRY-1:0];
                                            //& sq_entry_same_addr_newest[SQ_ENTRY-1:0];

assign sq_newest_fwd_req0            = |sq_newest_fwd_req_id0[SQ_ENTRY-1:0];   //1->3, newest fwd 1 change to 3, LTL@20241016
assign sq_newest_fwd_req1            = |sq_newest_fwd_req_id1[SQ_ENTRY-1:0];
assign sq_newest_fwd_req2            = |sq_newest_fwd_req_id2[SQ_ENTRY-1:0];

//------------------judge for depd--------------------------
//to ld_dc fwd judge
assign sq_ldc0_ex2_has_fwd_req           = sq_fwd_req0;     //1->3, has fwd 1 change to 3, LTL@20241016
assign sq_lsdc0_ex2_has_fwd_req           = sq_fwd_req1;
assign sq_lsdc1_ex2_has_fwd_req           = sq_fwd_req2;

assign sq_ldc0_ex2_fwd_req               = sq_newest_fwd_req0   //1->3, fwd req 1 change to 3, LTL@20241016
                                        ||  !sq_fwd_bypass_req0
                                            &&  sq_fwd_req0;
assign sq_lsdc0_ex2_fwd_req               = sq_newest_fwd_req1
                                        ||  !sq_fwd_bypass_req1
                                            &&  sq_fwd_req1;
assign sq_lsdc1_ex2_fwd_req               = sq_newest_fwd_req2
                                        ||  !sq_fwd_bypass_req2
                                            &&  sq_fwd_req2;

assign sq_lda0_ex2_newest_fwd_data_vld_req = |sq_entry_newest_fwd_req_data_vld0[SQ_ENTRY-1:0];  //1->3, newest fwd data valid 1 change to 3, LTL@20241016
assign sq_lsda0_ex2_newest_fwd_data_vld_req = |sq_entry_newest_fwd_req_data_vld1[SQ_ENTRY-1:0];
assign sq_lsda1_ex2_newest_fwd_data_vld_req = |sq_entry_newest_fwd_req_data_vld2[SQ_ENTRY-1:0];

assign sq_newest_fwd_req_data_vld_short0 = |sq_entry_newest_fwd_req_data_vld_short0[SQ_ENTRY-1:0];   //newest fwd req 1 change to 3, LTL@20241016
assign sq_newest_fwd_req_data_vld_short1 = |sq_entry_newest_fwd_req_data_vld_short1[SQ_ENTRY-1:0];
assign sq_newest_fwd_req_data_vld_short2 = |sq_entry_newest_fwd_req_data_vld_short2[SQ_ENTRY-1:0];

//to ld_da pipe 
assign sq_lda0_ex2_data_discard_req      = sq_data_discard_req0                              // 1 change to 3, LTL@20241016
                                        &&  !sq_newest_fwd_bypass_req0
                                        &&  !sq_newest_fwd_req0;
assign sq_lsda0_ex2_data_discard_req      = sq_data_discard_req1
                                        &&  !sq_newest_fwd_bypass_req1
                                        &&  !sq_newest_fwd_req1;
assign sq_lsda1_ex2_data_discard_req      = sq_data_discard_req2
                                        &&  !sq_newest_fwd_bypass_req2
                                        &&  !sq_newest_fwd_req2;

//if sq_lda0_ex2_fwd_bypass_req && sq_ldc0_ex2_fwd_req, then multi fwd
assign sq_lda0_ex2_fwd_bypass_req         = sq_newest_fwd_bypass_req0    //1->3,  1 change to 3, LTL@20241016
                                        ||  sq_fwd_bypass_req0
                                            &&  !sq_fwd_req0;
assign sq_lda0_ex2_fwd_bypass_sel         = sq_newest_fwd_bypass_req0 
                                            ? sq_lda0_newest_fwd_bypass_req_sel
                                            : sq_entry_fwd_bypass_req0_has_two
                                            ? sq_lda0_fwd_bypass_req_sel_newer
                                            : sq_lda0_fwd_bypass_req_sel; 
assign sq_lsda0_ex2_fwd_bypass_req        = sq_newest_fwd_bypass_req1
                                        ||  sq_fwd_bypass_req1
                                            &&  !sq_fwd_req1;
assign sq_lsda0_ex2_fwd_bypass_sel        = sq_newest_fwd_bypass_req1 
                                            ? sq_lsda0_newest_fwd_bypass_req_sel
                                            : sq_entry_fwd_bypass_req1_has_two
                                            ? sq_lsda0_fwd_bypass_req_sel_newer
                                            : sq_lsda0_fwd_bypass_req_sel;  
assign sq_lsda1_ex2_fwd_bypass_req        = sq_newest_fwd_bypass_req2
                                        ||  sq_fwd_bypass_req2
                                            &&  !sq_fwd_req2;
assign sq_lsda1_ex2_fwd_bypass_sel        = sq_newest_fwd_bypass_req2 
                                            ? sq_lsda1_newest_fwd_bypass_req_sel
                                            : sq_entry_fwd_bypass_req2_has_two
                                            ? sq_lsda1_fwd_bypass_req_sel_newer
                                            : sq_lsda1_fwd_bypass_req_sel; 

//if fwd_bypass_multi depd, then use sq_entry_data_discard_req_short id
assign sq_lda0_ex2_fwd_id[SQ_ENTRY-1:0]  = sq_data_discard_req_short0 &&  !sq_newest_fwd_req0         // 1 change to 3, LTL@20241016
                                        ? sq_entry_data_discard_req_short0[SQ_ENTRY-1:0]
                                        : sq_fwd_req_id0[SQ_ENTRY-1:0];
assign sq_lsda0_ex2_fwd_id[SQ_ENTRY-1:0]  = sq_data_discard_req_short1 &&  !sq_newest_fwd_req1
                                        ? sq_entry_data_discard_req_short1[SQ_ENTRY-1:0]
                                        : sq_fwd_req_id1[SQ_ENTRY-1:0];
assign sq_lsda1_ex2_fwd_id[SQ_ENTRY-1:0]  = sq_data_discard_req_short2 &&  !sq_newest_fwd_req2
                                        ? sq_entry_data_discard_req_short2[SQ_ENTRY-1:0]
                                        : sq_fwd_req_id2[SQ_ENTRY-1:0];

assign sq_fwd_req_id0[SQ_ENTRY-1:0]    = sq_newest_fwd_req0                                        // 1 change to 3, LTL@20241016
                                        ? sq_newest_fwd_req_id0[SQ_ENTRY-1:0]
                                        : sq_entry_fwd_req0[SQ_ENTRY-1:0];
assign sq_fwd_req_id1[SQ_ENTRY-1:0]    = sq_newest_fwd_req1
                                        ? sq_newest_fwd_req_id1[SQ_ENTRY-1:0]
                                        : sq_entry_fwd_req1[SQ_ENTRY-1:0];
assign sq_fwd_req_id2[SQ_ENTRY-1:0]    = sq_newest_fwd_req2
                                        ? sq_newest_fwd_req_id2[SQ_ENTRY-1:0]
                                        : sq_entry_fwd_req2[SQ_ENTRY-1:0];                                                                            
//---------multi depd-------------------
// &CombBeg; @392
//always @( sq_entry_fwd_req[11:0])              //parameterized and 1->3, LTL@20241016
//begin
//sq_fwd_multi = 1'b1;
//case(sq_entry_fwd_req[SQ_ENTRY-1:0])
//  12'b0000_0000_0000,
//  12'b0000_0000_0001,
//  12'b0000_0000_0010,
//  12'b0000_0000_0100,
//  12'b0000_0000_1000,
//  12'b0000_0001_0000,
//  12'b0000_0010_0000,
//  12'b0000_0100_0000,
//  12'b0000_1000_0000,
//  12'b0001_0000_0000,
//  12'b0010_0000_0000,
//  12'b0100_0000_0000,
//  12'b1000_0000_0000:
//    sq_fwd_multi = 1'b0;
//  default:sq_fwd_multi = 1'b1;
//endcase
//// &CombEnd; @411
//end

always_comb begin           //1->3, for sq_fwd_multi parameter, LTL@20241022  
  find_multi_fwd0[SQ_ENTRY-1:0] = {SQ_ENTRY{1'b0}}; 
  sq_fwd_multi0 = 1'b0;
  for(int i=1;i<SQ_ENTRY;i++) begin
    for(int j=0;j<i;j++) begin
      find_multi_fwd0[i] = find_multi_fwd0[i] | sq_entry_fwd_req0[j];
    end
    sq_fwd_multi0 |= sq_entry_fwd_req0[i] & find_multi_fwd0[i];
  end
end

always_comb begin           //1->3, for sq_fwd_multi parameter, LTL@20241022  
  find_multi_fwd1[SQ_ENTRY-1:0] = {SQ_ENTRY{1'b0}}; 
  sq_fwd_multi1 = 1'b0;
  for(int i=1;i<SQ_ENTRY;i++) begin
    for(int j=0;j<i;j++) begin
      find_multi_fwd1[i] = find_multi_fwd1[i] | sq_entry_fwd_req1[j];
    end
    sq_fwd_multi1 |= sq_entry_fwd_req1[i] & find_multi_fwd1[i];
  end
end

always_comb begin           //1->3, for sq_fwd_multi parameter, LTL@20241022  
  find_multi_fwd2[SQ_ENTRY-1:0] = {SQ_ENTRY{1'b0}}; 
  sq_fwd_multi2 = 1'b0;
  for(int i=1;i<SQ_ENTRY;i++) begin
    for(int j=0;j<i;j++) begin
      find_multi_fwd2[i] = find_multi_fwd2[i] | sq_entry_fwd_req2[j];
    end
    sq_fwd_multi2 |= sq_entry_fwd_req2[i] & find_multi_fwd2[i];
  end
end


assign sq_lda0_ex2_fwd_multi = sq_fwd_multi0;           //1->3 LTL@20241016
assign sq_lsda0_ex2_fwd_multi = sq_fwd_multi1;
assign sq_lsda1_ex2_fwd_multi = sq_fwd_multi2;

assign sq_lda0_ex2_fwd_multi_mask    = sq_newest_fwd_req0 || sq_newest_fwd_bypass_req0;     //1->3 LTL@20241016
assign sq_lsda0_ex2_fwd_multi_mask    = sq_newest_fwd_req1 || sq_newest_fwd_bypass_req1;
assign sq_lsda1_ex2_fwd_multi_mask    = sq_newest_fwd_req2 || sq_newest_fwd_bypass_req2;

assign sq_lda0_ex2_fwd_bypass_multi  = !sq_newest_fwd_bypass_req0   //1->3 LTL@20241016
                                    &&  !sq_newest_fwd_req0
                                    &&  sq_fwd_bypass_req0
                                    &&  sq_fwd_req0;
assign sq_lsda0_ex2_fwd_bypass_multi  = !sq_newest_fwd_bypass_req1
                                    &&  !sq_newest_fwd_req1
                                    &&  sq_fwd_bypass_req1
                                    &&  sq_fwd_req1;
assign sq_lsda1_ex2_fwd_bypass_multi  = !sq_newest_fwd_bypass_req2
                                    &&  !sq_newest_fwd_req2
                                    &&  sq_fwd_bypass_req2
                                    &&  sq_fwd_req2;                                                                        
//==========================================================
//              Forward data pop entry
//==========================================================
always @(posedge sq_fwd_data_pe_clk0 or negedge cpurst_b)        //1->3 LTL@20241016
begin
  if (!cpurst_b)
    sq_fwd_data_pe0[127:0]   <=  128'd0;
  else if(sq_fwd_data_pe_req0)
    sq_fwd_data_pe0[127:0]   <=  sq_fwd_data_sel0[127:0];
end
always @(posedge sq_fwd_data_pe_clk1 or negedge cpurst_b)  
begin
  if (!cpurst_b)
    sq_fwd_data_pe1[127:0]   <=  128'd0;
  else if(sq_fwd_data_pe_req1)
    sq_fwd_data_pe1[127:0]   <=  sq_fwd_data_sel1[127:0];
end
always @(posedge sq_fwd_data_pe_clk2 or negedge cpurst_b)    
begin
  if (!cpurst_b)
    sq_fwd_data_pe2[127:0]   <=  128'd0;
  else if(sq_fwd_data_pe_req2)
    sq_fwd_data_pe2[127:0]   <=  sq_fwd_data_sel2[127:0];
end

assign sq_fwd_data_pe_req0  = sq_lda0_ex2_newest_fwd_data_vld_req;    //1->3 LTL@20241016
assign sq_fwd_data_pe_req1  = sq_lsda0_ex2_newest_fwd_data_vld_req;
assign sq_fwd_data_pe_req2  = sq_lsda1_ex2_newest_fwd_data_vld_req;

// &CombBeg; @432
//always @( sq_entry_data_8[127:0]
//       or sq_entry_data_6[127:0]
//       or sq_entry_data_10[127:0]
//       or sq_entry_data_11[127:0]
//       or sq_entry_data_1[127:0]
//       or sq_entry_newest_fwd_req_data_vld[11:0]  //1->4 LTL@20241016, one always whether or not
//       or sq_entry_data_7[127:0]
//       or sq_entry_data_4[127:0]
//       or sq_entry_data_2[127:0]
//       or sq_entry_data_3[127:0]
//       or sq_entry_data_5[127:0]
//       or sq_entry_data_0[127:0]
//       or sq_entry_data_9[127:0])
//begin
//case(sq_entry_newest_fwd_req_data_vld[SQ_ENTRY-1:0])
//  12'h001:  sq_fwd_data_sel[127:0] = sq_entry_data_0[127:0];
//  12'h002:  sq_fwd_data_sel[127:0] = sq_entry_data_1[127:0];
//  12'h004:  sq_fwd_data_sel[127:0] = sq_entry_data_2[127:0];
//  12'h008:  sq_fwd_data_sel[127:0] = sq_entry_data_3[127:0];
//  12'h010:  sq_fwd_data_sel[127:0] = sq_entry_data_4[127:0];
//  12'h020:  sq_fwd_data_sel[127:0] = sq_entry_data_5[127:0];
//  12'h040:  sq_fwd_data_sel[127:0] = sq_entry_data_6[127:0];
//  12'h080:  sq_fwd_data_sel[127:0] = sq_entry_data_7[127:0];
//  12'h100:  sq_fwd_data_sel[127:0] = sq_entry_data_8[127:0];
//  12'h200:  sq_fwd_data_sel[127:0] = sq_entry_data_9[127:0];
//  12'h400:  sq_fwd_data_sel[127:0] = sq_entry_data_10[127:0];
//  12'h800:  sq_fwd_data_sel[127:0] = sq_entry_data_11[127:0];
//  default:sq_fwd_data_sel[127:0] = {128{1'bx}};
//endcase
//// &CombEnd; @448
//end
always_comb begin    //parameter for sq_settle_vsew, and 1->3 LTL@20241022
  sq_fwd_data_sel0[127:0] = 128'b0;   //sq_entry_newest_fwd_req_data_vld at most one 1-value, no need find first 1, LTL@20241022
  for(int i=0;i<SQ_ENTRY;i++) begin
    sq_fwd_data_sel0 |= {128{sq_entry_newest_fwd_req_data_vld0[i]}} & sq_entry_data[i][127:0];
  end
end
always_comb begin    //parameter for sq_settle_vsew, and 1->3 LTL@20241022
  sq_fwd_data_sel1[127:0] = 128'b0;
  for(int i=0;i<SQ_ENTRY;i++) begin
    sq_fwd_data_sel1 |= {128{sq_entry_newest_fwd_req_data_vld1[i]}} & sq_entry_data[i][127:0];
  end
end
always_comb begin    //parameter for sq_settle_vsew, and 1->3 LTL@20241022
  sq_fwd_data_sel2[127:0] = 128'b0;
  for(int i=0;i<SQ_ENTRY;i++) begin
    sq_fwd_data_sel2 |= {128{sq_entry_newest_fwd_req_data_vld2[i]}} & sq_entry_data[i][127:0];
  end
end



assign sq_lda0_ex3_fwd_data_pe[127:0] = sq_fwd_data_pe0[127:0]; //1->3, LTL@20241024
assign sq_lsda0_ex3_fwd_data_pe[127:0] = sq_fwd_data_pe1[127:0];
assign sq_lsda1_ex3_fwd_data_pe[127:0] = sq_fwd_data_pe2[127:0];

// &CombBeg; @460
// &CombEnd; @476
//==========================================================
//                forward data to ld_da
//==========================================================
// &CombBeg; @483
//always @( sq_entry_data_8[127:0]                              //1->3 LTL@20241016
//       or sq_entry_data_6[127:0]
//       or sq_entry_data_10[127:0]
//       or sq_entry_data_11[127:0]
//       or sq_entry_data_1[127:0]
//       or sq_entry_data_7[127:0]
//       or sq_entry_data_4[127:0]
//       or lda0_sq_ex3_fwd_id[11:0]
//       or sq_entry_data_2[127:0]
//       or sq_entry_data_3[127:0]
//       or sq_entry_data_5[127:0]
//       or sq_entry_data_0[127:0]
//       or sq_entry_data_9[127:0])
//begin
//case(lda0_sq_ex3_fwd_id[SQ_ENTRY-1:0])
//  12'h001:  sq_lda0_ex3_fwd_data[127:0] = sq_entry_data_0[127:0];
//  12'h002:  sq_lda0_ex3_fwd_data[127:0] = sq_entry_data_1[127:0];
//  12'h004:  sq_lda0_ex3_fwd_data[127:0] = sq_entry_data_2[127:0];
//  12'h008:  sq_lda0_ex3_fwd_data[127:0] = sq_entry_data_3[127:0];
//  12'h010:  sq_lda0_ex3_fwd_data[127:0] = sq_entry_data_4[127:0];
//  12'h020:  sq_lda0_ex3_fwd_data[127:0] = sq_entry_data_5[127:0];
//  12'h040:  sq_lda0_ex3_fwd_data[127:0] = sq_entry_data_6[127:0];
//  12'h080:  sq_lda0_ex3_fwd_data[127:0] = sq_entry_data_7[127:0];
//  12'h100:  sq_lda0_ex3_fwd_data[127:0] = sq_entry_data_8[127:0];
//  12'h200:  sq_lda0_ex3_fwd_data[127:0] = sq_entry_data_9[127:0];
//  12'h400:  sq_lda0_ex3_fwd_data[127:0] = sq_entry_data_10[127:0];
//  12'h800:  sq_lda0_ex3_fwd_data[127:0] = sq_entry_data_11[127:0];
//  default:sq_lda0_ex3_fwd_data[127:0] = {128{1'bx}};
//endcase
//end

always_comb begin    //parameter for sq_lda0_ex3_fwd_data, need consider first 1 from ptr0, and 1->4 LTL@20241022
  sq_lda0_ex3_fwd_data[127:0] = {128{lda0_sq_ex3_fwd_id[0]}} & sq_entry_data[0][127:0];
  find_one_from_zero_for_fwd_data0 = {SQ_ENTRY{1'b0}};
  for(int i=1;i<SQ_ENTRY;i++) begin
    for(int j=0; j<i; j++) begin
      find_one_from_zero_for_fwd_data0[i] = find_one_from_zero_for_fwd_data0[i] | lda0_sq_ex3_fwd_id[j];
    end
      sq_lda0_ex3_fwd_data |= {128{lda0_sq_ex3_fwd_id[i] & (!find_one_from_zero_for_fwd_data0[i])}} & sq_entry_data[i][127:0];
  end  
end
always_comb begin    //parameter for sq_lsda0_ex3_fwd_data, need consider first 1 from ptr0, and 1->4 LTL@20241022
  sq_lsda0_ex3_fwd_data[127:0] = {128{lsda0_sq_ex3_fwd_id[0]}} & sq_entry_data[0][127:0];
  find_one_from_zero_for_fwd_data1 = {SQ_ENTRY{1'b0}};
  for(int i=0;i<SQ_ENTRY;i++) begin
    for(int j=0; j<i; j++) begin
      find_one_from_zero_for_fwd_data1[i] = find_one_from_zero_for_fwd_data1[i] | lsda0_sq_ex3_fwd_id[j];
    end
      sq_lsda0_ex3_fwd_data |= {128{lsda0_sq_ex3_fwd_id[i] & (!find_one_from_zero_for_fwd_data1[i])}} & sq_entry_data[i][127:0];
  end  
end
always_comb begin    //parameter for sq_lsda0_ex3_fwd_data, need consider first 1 from ptr0, and 1->4 LTL@20241022
  sq_lsda1_ex3_fwd_data[127:0] = {128{lsda1_sq_ex3_fwd_id[0]}} & sq_entry_data[0][127:0];
  find_one_from_zero_for_fwd_data2 = {SQ_ENTRY{1'b0}};
  for(int i=0;i<SQ_ENTRY;i++) begin
    for(int j=0; j<i; j++) begin
      find_one_from_zero_for_fwd_data2[i] = find_one_from_zero_for_fwd_data2[i] | lsda1_sq_ex3_fwd_id[j];
    end
      sq_lsda1_ex3_fwd_data |= {128{lsda1_sq_ex3_fwd_id[i] & (!find_one_from_zero_for_fwd_data2[i])}} & sq_entry_data[i][127:0];
  end  
end
//==========================================================
//            ld_da to sq depd/discard signal
//==========================================================
//---------interface to sq_entry--------
//set depd signal
assign sq_entry_fwd_multi_depd_set0[SQ_ENTRY-1:0]  = {SQ_ENTRY{lda0_sq_ex3_fwd_multi_vld}}   //1->3 LTL@20241016
                                                    & lda0_sq_ex3_fwd_id[SQ_ENTRY-1:0]
                                                    & sq_entry_vld[SQ_ENTRY-1:0];
assign sq_entry_fwd_multi_depd_set1[SQ_ENTRY-1:0]  = {SQ_ENTRY{lsda0_sq_ex3_fwd_multi_vld}}
                                                    & lsda0_sq_ex3_fwd_id[SQ_ENTRY-1:0]
                                                    & sq_entry_vld[SQ_ENTRY-1:0];
assign sq_entry_fwd_multi_depd_set2[SQ_ENTRY-1:0]  = {SQ_ENTRY{lsda1_sq_ex3_fwd_multi_vld}}
                                                    & lsda1_sq_ex3_fwd_id[SQ_ENTRY-1:0]
                                                    & sq_entry_vld[SQ_ENTRY-1:0];                                                                                                        
//-------------data depd--------------
//if more than 1 entry have depend relationship, see fwd_en signal,
//if no entry has fwd_en signal, then select the biggest entry

//always @( lda_sq_ex3_fwd_id[11:0])                //parameterized, find 1 from left, 1->4 LTL@20241016
//begin
//sq_data_discard_id_sel[SQ_ENTRY-1:0] = {SQ_ENTRY{1'b0}};
//casez(lda0_sq_ex3_fwd_id[SQ_ENTRY-1:0])
//  12'b1???_????_????:sq_data_discard_id_sel[11] = 1'b1;
//  12'b01??_????_????:sq_data_discard_id_sel[10] = 1'b1;
//  12'b001?_????_????:sq_data_discard_id_sel[9] = 1'b1;
//  12'b0001_????_????:sq_data_discard_id_sel[8] = 1'b1;
//  12'b0000_1???_????:sq_data_discard_id_sel[7] = 1'b1;
//  12'b0000_01??_????:sq_data_discard_id_sel[6] = 1'b1;
//  12'b0000_001?_????:sq_data_discard_id_sel[5] = 1'b1;
//  12'b0000_0001_????:sq_data_discard_id_sel[4] = 1'b1;
//  12'b0000_0000_1???:sq_data_discard_id_sel[3] = 1'b1;
//  12'b0000_0000_01??:sq_data_discard_id_sel[2] = 1'b1;
//  12'b0000_0000_001?:sq_data_discard_id_sel[1] = 1'b1;
//  12'b0000_0000_0001:sq_data_discard_id_sel[0] = 1'b1;
//  default:sq_data_discard_id_sel[SQ_ENTRY-1:0] = {SQ_ENTRY{1'b0}};
//endcase
//end

always_comb begin    //parameter for sq_data_discard_id_sel0, need consider first 1 from left, and 1->3 LTL@20241022
  find_one_from_left_for_discard0 = {SQ_ENTRY{1'b0}};
  sq_data_discard_id_sel0[SQ_ENTRY-1] = lda0_sq_ex3_fwd_id[SQ_ENTRY-1];
  sq_data_discard_id_sel0[SQ_ENTRY-2:0] = {SQ_ENTRY-1{1'b0}};
  for(int i=SQ_ENTRY-2;i>-1;i--) begin
    for(int j=SQ_ENTRY-1; j>i; j--) begin
      find_one_from_left_for_discard0[i] = find_one_from_left_for_discard0[i] | lda0_sq_ex3_fwd_id[j];
    end
      sq_data_discard_id_sel0[i] = (lda0_sq_ex3_fwd_id[i]) & (!find_one_from_left_for_discard0[i]);
  end  
end
always_comb begin    //parameter for sq_data_discard_id_sel2, need consider first 1 from left, and 1->3 LTL@20241022
  find_one_from_left_for_discard1 = {SQ_ENTRY{1'b0}};
  sq_data_discard_id_sel1[SQ_ENTRY-1] = lsda0_sq_ex3_fwd_id[SQ_ENTRY-1];
  sq_data_discard_id_sel1[SQ_ENTRY-2:0] = {SQ_ENTRY-1{1'b0}};
  for(int i=SQ_ENTRY-2;i>-1;i--) begin
    for(int j=SQ_ENTRY-1; j>i; j--) begin
      find_one_from_left_for_discard1[i] = find_one_from_left_for_discard1[i] | lsda0_sq_ex3_fwd_id[j];
    end
      sq_data_discard_id_sel1[i] = (lsda0_sq_ex3_fwd_id[i]) & (!find_one_from_left_for_discard1[i]);
  end  
end
always_comb begin    //parameter for sq_data_discard_id_sel3, need consider first 1 from left, and 1->3 LTL@20241022
  find_one_from_left_for_discard2 = {SQ_ENTRY{1'b0}};
  sq_data_discard_id_sel2[SQ_ENTRY-1] = lsda1_sq_ex3_fwd_id[SQ_ENTRY-1];
  sq_data_discard_id_sel2[SQ_ENTRY-2:0] = {SQ_ENTRY-1{1'b0}};
  for(int i=SQ_ENTRY-2;i>-1;i--) begin
    for(int j=SQ_ENTRY-1; j>i; j--) begin
      find_one_from_left_for_discard2[i] = find_one_from_left_for_discard2[i] | lsda1_sq_ex3_fwd_id[j];
    end
      sq_data_discard_id_sel2[i] = (lsda1_sq_ex3_fwd_id[i]) & (!find_one_from_left_for_discard2[i]);
  end  
end

assign sq_data_discard_newest_id0[SQ_ENTRY-1:0]    = sq_entry_same_addr_newest[SQ_ENTRY-1:0]  //1->3 LTL@20241016
                                                    & lda0_sq_ex3_fwd_id[SQ_ENTRY-1:0];                                                
assign sq_data_discard_newest_id1[SQ_ENTRY-1:0]    = sq_entry_same_addr_newest[SQ_ENTRY-1:0]
                                                    & lsda0_sq_ex3_fwd_id[SQ_ENTRY-1:0];
assign sq_data_discard_newest_id2[SQ_ENTRY-1:0]    = sq_entry_same_addr_newest[SQ_ENTRY-1:0]
                                                    & lsda1_sq_ex3_fwd_id[SQ_ENTRY-1:0];

assign sq_data_discard_has_newest0                 = |sq_data_discard_newest_id0[SQ_ENTRY-1:0];  //1->3 LTL@20241016
assign sq_data_discard_has_newest1                 = |sq_data_discard_newest_id1[SQ_ENTRY-1:0];
assign sq_data_discard_has_newest2                 = |sq_data_discard_newest_id2[SQ_ENTRY-1:0];


assign sq_entry_wakeup_queue_set_id0[SQ_ENTRY-1:0] = sq_data_discard_has_newest0                //1->3 LTL@20241016
                                                    ? sq_data_discard_newest_id0[SQ_ENTRY-1:0]
                                                    : sq_data_discard_id_sel0[SQ_ENTRY-1:0];
assign sq_entry_wakeup_queue_set_id1[SQ_ENTRY-1:0] = sq_data_discard_has_newest1
                                                    ? sq_data_discard_newest_id1[SQ_ENTRY-1:0]
                                                    : sq_data_discard_id_sel1[SQ_ENTRY-1:0];
assign sq_entry_wakeup_queue_set_id2[SQ_ENTRY-1:0] = sq_data_discard_has_newest2
                                                    ? sq_data_discard_newest_id2[SQ_ENTRY-1:0]
                                                    : sq_data_discard_id_sel2[SQ_ENTRY-1:0];

assign sq_entry_data_discard_grnt0[SQ_ENTRY-1:0]   = {SQ_ENTRY{lda0_sq_ex3_data_discard_vld}}          //1->3 LTL@20241016
                                                    &  sq_entry_wakeup_queue_set_id0[SQ_ENTRY-1:0];
assign sq_entry_data_discard_grnt1[SQ_ENTRY-1:0]   = {SQ_ENTRY{lsda0_sq_ex3_data_discard_vld}}
                                                    &  sq_entry_wakeup_queue_set_id1[SQ_ENTRY-1:0];
assign sq_entry_data_discard_grnt2[SQ_ENTRY-1:0]   = {SQ_ENTRY{lsda1_sq_ex3_data_discard_vld}}
                                                    &  sq_entry_wakeup_queue_set_id2[SQ_ENTRY-1:0];                                                                                                        
//==========================================================
//            maintain restart wakeup queue
//==========================================================
//---------------------registers----------------------------
//+--------------+
//| wakeup_queue |
//+--------------+
//the queue stores the instructions waiting for wakeup
always @(posedge sq_wakeup_queue_clk0 or negedge cpurst_b)                  //1->4 LTL@20241016
begin
  if (!cpurst_b)
    sq_wakeup_queue0[LSIQ_ENTRY-1:0]   <=  {LSIQ_ENTRY{1'b0}};
  else if(rtu_yy_xx_flush)
    sq_wakeup_queue0[LSIQ_ENTRY-1:0]   <=  {LSIQ_ENTRY{1'b0}};
  else if(lda0_sq_ex3_global_discard_vld ||  sq_pop_depd_ff || rtu_ck_flush)  //ck_flush send out all wakeup queue, ck_flush@LTL
    sq_wakeup_queue0[LSIQ_ENTRY-1:0]   <=  sq_wakeup_queue_next0[LSIQ_ENTRY-1:0];
end
always @(posedge sq_wakeup_queue_clk1 or negedge cpurst_b)
begin
  if (!cpurst_b)
    sq_wakeup_queue1[LSIQ_ENTRY-1:0]   <=  {LSIQ_ENTRY{1'b0}};
  else if(rtu_yy_xx_flush)
    sq_wakeup_queue1[LSIQ_ENTRY-1:0]   <=  {LSIQ_ENTRY{1'b0}};
  else if(lsda0_sq_ex3_global_discard_vld ||  sq_pop_depd_ff || rtu_ck_flush) //ck_flush send out all wakeup queue, ck_flush@LTL
    sq_wakeup_queue1[LSIQ_ENTRY-1:0]   <=  sq_wakeup_queue_next1[LSIQ_ENTRY-1:0];
end
always @(posedge sq_wakeup_queue_clk2 or negedge cpurst_b)
begin
  if (!cpurst_b)
    sq_wakeup_queue2[LSIQ_ENTRY-1:0]   <=  {LSIQ_ENTRY{1'b0}};
  else if(rtu_yy_xx_flush)
    sq_wakeup_queue2[LSIQ_ENTRY-1:0]   <=  {LSIQ_ENTRY{1'b0}};
  else if(lsda1_sq_ex3_global_discard_vld ||  sq_pop_depd_ff || rtu_ck_flush) //ck_flush send out all wakeup queue, ck_flush@LTL
    sq_wakeup_queue2[LSIQ_ENTRY-1:0]   <=  sq_wakeup_queue_next2[LSIQ_ENTRY-1:0];
end
//+-------------+
//| depd_pop_ff |
//+-------------+
//if depd pop, this will set to 1, and clear wakeup_queue next cycle
always @(posedge sq_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    sq_pop_depd_ff      <=  1'b0;
  else if(wmb_sq_pop_grnt &&  (wmb_ce_depd  ||  wmb_ce_depd_set) || sq_pop_expt_nop_vld)
    sq_pop_depd_ff      <=  1'b1;
  else
    sq_pop_depd_ff      <=  1'b0;
end

//------------------update wakeup queue---------------------
assign sq_wakeup_queue_grnt0[LSIQ_ENTRY-1:0]   = sq_wakeup_queue0[LSIQ_ENTRY-1:0]                         //1->4 discard ld lsid in wakeup queue LTL@20241016
                                                | ({LSIQ_ENTRY{lda0_sq_ex3_global_discard_vld}}
                                                  & lda0_ex3_lsid[LSIQ_ENTRY-1:0]);
assign sq_wakeup_queue_grnt1[LSIQ_ENTRY-1:0]   = sq_wakeup_queue1[LSIQ_ENTRY-1:0]
                                                | ({LSIQ_ENTRY{lsda0_sq_ex3_global_discard_vld}}
                                                  & lsda0_ex3_lsid[LSIQ_ENTRY-1:0]);
assign sq_wakeup_queue_grnt2[LSIQ_ENTRY-1:0]   = sq_wakeup_queue2[LSIQ_ENTRY-1:0]
                                                | ({LSIQ_ENTRY{lsda1_sq_ex3_global_discard_vld}}
                                                  & lsda1_ex3_lsid[LSIQ_ENTRY-1:0]);


assign sq_wakeup_queue_next0[LSIQ_ENTRY-1:0]   = sq_pop_depd_ff || rtu_ck_flush                      //ck_flush send out all wakeup queue, ck_flush@LTL          //1->3 sq pop, wuq will clear, or keep  LTL@20241016
                                                ? {LSIQ_ENTRY{1'b0}}
                                                : sq_wakeup_queue_grnt0[LSIQ_ENTRY-1:0];
assign sq_wakeup_queue_next1[LSIQ_ENTRY-1:0]   = sq_pop_depd_ff || rtu_ck_flush 
                                                ? {LSIQ_ENTRY{1'b0}}
                                                : sq_wakeup_queue_grnt1[LSIQ_ENTRY-1:0];
assign sq_wakeup_queue_next2[LSIQ_ENTRY-1:0]   = sq_pop_depd_ff || rtu_ck_flush 
                                                ? {LSIQ_ENTRY{1'b0}}
                                                : sq_wakeup_queue_grnt2[LSIQ_ENTRY-1:0];
//-------------------------wakeup---------------------------
assign sq_global_depd_wakeup0[LSIQ_ENTRY-1:0]  = sq_pop_depd_ff || rtu_ck_flush                    //ck_flush send out all wakeup queue, ck_flush@LTL           //1->3, sq pop, wakeup queue send to issue queue   LTL@20241016 
                                                ? sq_wakeup_queue_grnt0[LSIQ_ENTRY-1:0]
                                                : {LSIQ_ENTRY{1'b0}};
assign sq_global_depd_wakeup1[LSIQ_ENTRY-1:0]  = sq_pop_depd_ff || rtu_ck_flush                   //ck_flush send out all wakeup queue, ck_flush@LTL
                                                ? sq_wakeup_queue_grnt1[LSIQ_ENTRY-1:0]
                                                : {LSIQ_ENTRY{1'b0}};
assign sq_global_depd_wakeup2[LSIQ_ENTRY-1:0]  = sq_pop_depd_ff || rtu_ck_flush                   //ck_flush send out all wakeup queue, ck_flush@LTL
                                                ? sq_wakeup_queue_grnt2[LSIQ_ENTRY-1:0]
                                                : {LSIQ_ENTRY{1'b0}};

//assign sq_data_depd_wakeup[LSIQ_ENTRY-1:0]    = sq_entry_data_depd_wakeup0_0[LSIQ_ENTRY-1:0]         //each entry maintain 4 data_depd_wakeup  LTL@20241016
//                                                | sq_entry_data_depd_wakeup0_1[LSIQ_ENTRY-1:0]
//                                                | sq_entry_data_depd_wakeup0_2[LSIQ_ENTRY-1:0]
//                                                | sq_entry_data_depd_wakeup0_3[LSIQ_ENTRY-1:0]
//                                                | sq_entry_data_depd_wakeup0_4[LSIQ_ENTRY-1:0]
//                                                | sq_entry_data_depd_wakeup0_5[LSIQ_ENTRY-1:0]
//                                                | sq_entry_data_depd_wakeup0_6[LSIQ_ENTRY-1:0]
//                                                | sq_entry_data_depd_wakeup0_7[LSIQ_ENTRY-1:0]
//                                                | sq_entry_data_depd_wakeup0_8[LSIQ_ENTRY-1:0]
//                                                | sq_entry_data_depd_wakeup0_9[LSIQ_ENTRY-1:0]
//                                                | sq_entry_data_depd_wakeup0_10[LSIQ_ENTRY-1:0]
//                                                | sq_entry_data_depd_wakeup0_11[LSIQ_ENTRY-1:0];
always_comb begin          //parameterized, LTL@20241022
  sq_data_depd_wakeup0[LSIQ_ENTRY-1:0] = {LSIQ_ENTRY{1'b0}};
  for(int i=0;i<SQ_ENTRY;i++) begin
    sq_data_depd_wakeup0[LSIQ_ENTRY-1:0] |= sq_entry_data_depd_wakeup0[i][LSIQ_ENTRY-1:0];
  end
end
always_comb begin
  sq_data_depd_wakeup1[LSIQ_ENTRY-1:0] = {LSIQ_ENTRY{1'b0}};
  for(int i=0;i<SQ_ENTRY;i++) begin
    sq_data_depd_wakeup1[LSIQ_ENTRY-1:0] |= sq_entry_data_depd_wakeup1[i][LSIQ_ENTRY-1:0];
  end
end
always_comb begin
  sq_data_depd_wakeup2[LSIQ_ENTRY-1:0] = {LSIQ_ENTRY{1'b0}};
  for(int i=0;i<SQ_ENTRY;i++) begin
    sq_data_depd_wakeup2[LSIQ_ENTRY-1:0] |= sq_entry_data_depd_wakeup2[i][LSIQ_ENTRY-1:0];
  end
end

//==========================================================
//                pop entry
//==========================================================
//+----------+---------------+
//| pop addr | pop_page_info |
//+----------+---------------+
// &Force("output","sq_pop_addr"); @652
// &Force("output","sq_pop_page_share"); @653
// &Force("output","sq_pop_page_ca"); @654
// &Force("output","sq_pop_page_so"); @655
// &Force("output","sq_pop_inst_mode"); @656
// &Force("output","sq_pop_sync_fence"); @657
// &Force("output","sq_pop_atomic"); @658
// &Force("output","sq_pop_icc"); @659
// &Force("output","sq_pop_inst_flush"); @660
// &Force("output","sq_pop_inst_type"); @661
// &Force("output","sq_pop_inst_size"); @662
// &Force("output","sq_pop_bytes_vld"); @663
// &Force("output","sq_pop_wo_st"); @664
// &Force("output","sq_pop_ptr"); @665
// &Force("output","sq_pop_dtcm_hit"); @666
// &Force("output","sq_pop_itcm_hit"); @667
always @(posedge sq_pop_clk)
begin
  if(sq_pe_sel_age_vec_zero_entry_vld)
  begin
    sq_pop_addr[WK_PA_WIDTH-1:0]  <=  sq_pe_age_vec_zero_addr[WK_PA_WIDTH-1:0];
    sq_pop_page_ca            <=  sq_pe_age_vec_zero_page_ca;
    sq_pop_page_wa            <=  sq_pe_age_vec_zero_page_wa;
    sq_pop_page_so            <=  sq_pe_age_vec_zero_page_so;
    sq_pop_page_sec           <=  sq_pe_age_vec_zero_page_sec;
    sq_pop_page_buf           <=  sq_pe_age_vec_zero_page_buf;
    sq_pop_page_share         <=  sq_pe_age_vec_zero_page_share;
    sq_pop_atomic             <=  sq_pe_age_vec_zero_atomic;
    sq_pop_icc                <=  sq_pe_age_vec_zero_icc;
    sq_pop_preg[PREG-1:0]     <=  sq_pe_age_vec_zero_preg[PREG-1:0]; 
    sq_pop_wo_st              <=  sq_pe_age_vec_zero_wo_st;
    sq_pop_sync_fence         <=  sq_pe_age_vec_zero_sync_fence;
    sq_pop_inst_flush         <=  sq_pe_age_vec_zero_inst_flush;
    sq_pop_inst_type[1:0]     <=  sq_pe_age_vec_zero_inst_type[1:0];
    sq_pop_inst_size[2:0]     <=  sq_pe_age_vec_zero_inst_size[2:0];
    sq_pop_inst_mode[1:0]     <=  sq_pe_age_vec_zero_inst_mode[1:0];
    sq_pop_bytes_vld[15:0]    <=  sq_pe_age_vec_zero_bytes_vld[15:0];
    sq_pop_ptr[SQ_ENTRY-1:0]  <=  sq_entry_age_vec_zero_ptr[SQ_ENTRY-1:0];
    sq_pop_priv_mode[1:0]     <=  sq_pe_age_vec_zero_priv_mode[1:0];
    sq_pop_dtcm_hit           <=  sq_pe_age_vec_zero_dtcm_hit;
    sq_pop_itcm_hit           <=  sq_pe_age_vec_zero_itcm_hit;
    sq_pop_init_dcache_miss   <=  sq_pe_age_vec_zero_init_dcache_miss;
    sq_pop_ssp_va[1:0]        <=  sq_pe_age_vec_zero_ssp_va[1:0];
    sq_pop_pc_index[PC_LEN-1:0] <= sq_pe_age_vec_zero_pc_index[PC_LEN-1:0];
  end
  else if(sq_pe_sel_age_vec_surplus1_entry_vld)
  begin
    sq_pop_addr[WK_PA_WIDTH-1:0]  <=  sq_pe_age_vec_surplus1_addr[WK_PA_WIDTH-1:0];
    sq_pop_page_ca            <=  sq_pe_age_vec_surplus1_page_ca;
    sq_pop_page_wa            <=  sq_pe_age_vec_surplus1_page_wa;
    sq_pop_page_so            <=  sq_pe_age_vec_surplus1_page_so;
    sq_pop_page_sec           <=  sq_pe_age_vec_surplus1_page_sec;
    sq_pop_page_buf           <=  sq_pe_age_vec_surplus1_page_buf;
    sq_pop_page_share         <=  sq_pe_age_vec_surplus1_page_share;
    sq_pop_atomic             <=  sq_pe_age_vec_surplus1_atomic;
    sq_pop_icc                <=  sq_pe_age_vec_surplus1_icc;
    sq_pop_preg[PREG-1:0]     <=  sq_pe_age_vec_surplus1_preg[PREG-1:0];
    sq_pop_wo_st              <=  sq_pe_age_vec_surplus1_wo_st;
    sq_pop_sync_fence         <=  sq_pe_age_vec_surplus1_sync_fence;
    sq_pop_inst_flush         <=  sq_pe_age_vec_surplus1_inst_flush;
    sq_pop_inst_type[1:0]     <=  sq_pe_age_vec_surplus1_inst_type[1:0];
    sq_pop_inst_size[2:0]     <=  sq_pe_age_vec_surplus1_inst_size[2:0];
    sq_pop_inst_mode[1:0]     <=  sq_pe_age_vec_surplus1_inst_mode[1:0];
    sq_pop_bytes_vld[15:0]    <=  sq_pe_age_vec_surplus1_bytes_vld[15:0];
    sq_pop_ptr[SQ_ENTRY-1:0]  <=  sq_entry_age_vec_surplus1_ptr[SQ_ENTRY-1:0];
    sq_pop_priv_mode[1:0]     <=  sq_pe_age_vec_surplus1_priv_mode[1:0];
    sq_pop_dtcm_hit           <=  sq_pe_age_vec_surplus1_dtcm_hit;
    sq_pop_itcm_hit           <=  sq_pe_age_vec_surplus1_itcm_hit;
    sq_pop_init_dcache_miss   <=  sq_pe_age_vec_surplus1_init_dcache_miss;
    sq_pop_ssp_va[1:0]        <=  sq_pe_age_vec_surplus1_ssp_va[1:0];
    sq_pop_pc_index[PC_LEN-1:0] <= sq_pe_age_vec_surplus1_pc_index[PC_LEN-1:0];
  end
end

//---------------------update siganl------------------------
//if change entry to age_vec_zero, it must be new entry in st_dc pipe,
// and in st_da pipe it send no_restart signal
assign sq_pe_sel_age_vec_zero_entry_vld       = |(sq_entry_age_vec_zero_ptr[SQ_ENTRY-1:0]
                                                  & (~sq_entry_dcache_info_vld[SQ_ENTRY-1:0]));

assign sq_pe_sel_age_vec_surplus1_entry_vld   = wmb_sq_pop_to_ce_grnt || sq_pop_expt_nop_vld;


//always @( sq_entry_addr0_7[39:0]   //parameter for sq_pe_age_vec_zero_addr, LTL@20241022
//       or sq_entry_addr0_0[39:0]
//       or sq_entry_addr0_8[39:0]
//       or sq_entry_addr0_1[39:0]
//       or sq_entry_addr0_2[39:0]
//       or sq_entry_addr0_4[39:0]
//       or sq_entry_addr0_3[39:0]
//       or sq_entry_addr0_11[39:0]
//       or sq_entry_addr0_5[39:0]
//       or sq_entry_addr0_10[39:0]
//       or sq_entry_addr0_6[39:0]
//       or sq_entry_addr0_9[39:0]
//       or sq_entry_age_vec_zero_ptr[11:0])
//begin
//case(sq_entry_age_vec_zero_ptr[SQ_ENTRY-1:0])
//  12'h001:  sq_pe_age_vec_zero_addr[WK_PA_WIDTH-1:0] = sq_entry_addr0_0[WK_PA_WIDTH-1:0];
//  12'h002:  sq_pe_age_vec_zero_addr[WK_PA_WIDTH-1:0] = sq_entry_addr0_1[WK_PA_WIDTH-1:0];
//  12'h004:  sq_pe_age_vec_zero_addr[WK_PA_WIDTH-1:0] = sq_entry_addr0_2[WK_PA_WIDTH-1:0];
//  12'h008:  sq_pe_age_vec_zero_addr[WK_PA_WIDTH-1:0] = sq_entry_addr0_3[WK_PA_WIDTH-1:0];
//  12'h010:  sq_pe_age_vec_zero_addr[WK_PA_WIDTH-1:0] = sq_entry_addr0_4[WK_PA_WIDTH-1:0];
//  12'h020:  sq_pe_age_vec_zero_addr[WK_PA_WIDTH-1:0] = sq_entry_addr0_5[WK_PA_WIDTH-1:0];
//  12'h040:  sq_pe_age_vec_zero_addr[WK_PA_WIDTH-1:0] = sq_entry_addr0_6[WK_PA_WIDTH-1:0];
//  12'h080:  sq_pe_age_vec_zero_addr[WK_PA_WIDTH-1:0] = sq_entry_addr0_7[WK_PA_WIDTH-1:0];
//  12'h100:  sq_pe_age_vec_zero_addr[WK_PA_WIDTH-1:0] = sq_entry_addr0_8[WK_PA_WIDTH-1:0];
//  12'h200:  sq_pe_age_vec_zero_addr[WK_PA_WIDTH-1:0] = sq_entry_addr0_9[WK_PA_WIDTH-1:0];
//  12'h400:  sq_pe_age_vec_zero_addr[WK_PA_WIDTH-1:0] = sq_entry_addr0_10[WK_PA_WIDTH-1:0];
//  12'h800:  sq_pe_age_vec_zero_addr[WK_PA_WIDTH-1:0] = sq_entry_addr0_11[WK_PA_WIDTH-1:0];
//  default:sq_pe_age_vec_zero_addr[WK_PA_WIDTH-1:0] = {WK_PA_WIDTH{1'bx}};
//endcase
//end
always_comb begin  //parameter for sq_pe_age_vec_zero_addr, LTL@020241022
  sq_pe_age_vec_zero_addr[WK_PA_WIDTH-1:0] = {WK_PA_WIDTH{1'b0}};
  for(int i=0;i<SQ_ENTRY;i++) begin
    sq_pe_age_vec_zero_addr[WK_PA_WIDTH-1:0] |= {WK_PA_WIDTH{sq_entry_age_vec_zero_ptr[i]}} & sq_entry_addr0[i];
  end
end


//always @( sq_entry_bytes_vld_8[15:0]    //parameter for sq_pe_age_vec_zero_bytes_vld, LTL@20241022
//       or sq_entry_bytes_vld_4[15:0]
//       or sq_entry_bytes_vld_3[15:0]
//       or sq_entry_bytes_vld_10[15:0]
//       or sq_entry_bytes_vld_6[15:0]
//       or sq_entry_bytes_vld_9[15:0]
//       or sq_entry_bytes_vld_11[15:0]
//       or sq_entry_bytes_vld_2[15:0]
//       or sq_entry_bytes_vld_7[15:0]
//       or sq_entry_bytes_vld_0[15:0]
//       or sq_entry_bytes_vld_1[15:0]
//       or sq_entry_bytes_vld_5[15:0]
//       or sq_entry_age_vec_zero_ptr[11:0])
//begin
//case(sq_entry_age_vec_zero_ptr[SQ_ENTRY-1:0])
//  12'h001:  sq_pe_age_vec_zero_bytes_vld[15:0] = sq_entry_bytes_vld_0[15:0];
//  12'h002:  sq_pe_age_vec_zero_bytes_vld[15:0] = sq_entry_bytes_vld_1[15:0];
//  12'h004:  sq_pe_age_vec_zero_bytes_vld[15:0] = sq_entry_bytes_vld_2[15:0];
//  12'h008:  sq_pe_age_vec_zero_bytes_vld[15:0] = sq_entry_bytes_vld_3[15:0];
//  12'h010:  sq_pe_age_vec_zero_bytes_vld[15:0] = sq_entry_bytes_vld_4[15:0];
//  12'h020:  sq_pe_age_vec_zero_bytes_vld[15:0] = sq_entry_bytes_vld_5[15:0];
//  12'h040:  sq_pe_age_vec_zero_bytes_vld[15:0] = sq_entry_bytes_vld_6[15:0];
//  12'h080:  sq_pe_age_vec_zero_bytes_vld[15:0] = sq_entry_bytes_vld_7[15:0];
//  12'h100:  sq_pe_age_vec_zero_bytes_vld[15:0] = sq_entry_bytes_vld_8[15:0];
//  12'h200:  sq_pe_age_vec_zero_bytes_vld[15:0] = sq_entry_bytes_vld_9[15:0];
//  12'h400:  sq_pe_age_vec_zero_bytes_vld[15:0] = sq_entry_bytes_vld_10[15:0];
//  12'h800:  sq_pe_age_vec_zero_bytes_vld[15:0] = sq_entry_bytes_vld_11[15:0];
//  default:sq_pe_age_vec_zero_bytes_vld[15:0] = {16{1'bx}};
//endcase
//end
always_comb begin  //parameter for sq_pe_age_vec_zero_addr, LTL@020241022
  sq_pe_age_vec_zero_bytes_vld[15:0] = 16'b0;
  for(int i=0;i<SQ_ENTRY;i++) begin
    sq_pe_age_vec_zero_bytes_vld[15:0] |= {16{sq_entry_age_vec_zero_ptr[i]}} & sq_entry_bytes_vld[i][15:0];
  end
end


assign sq_pe_age_vec_zero_page_ca         = |(sq_entry_age_vec_zero_ptr[SQ_ENTRY-1:0] & sq_entry_page_ca[SQ_ENTRY-1:0]);
assign sq_pe_age_vec_zero_page_wa         = |(sq_entry_age_vec_zero_ptr[SQ_ENTRY-1:0] & sq_entry_page_wa[SQ_ENTRY-1:0]);
assign sq_pe_age_vec_zero_page_so         = |(sq_entry_age_vec_zero_ptr[SQ_ENTRY-1:0] & sq_entry_page_so[SQ_ENTRY-1:0]);
assign sq_pe_age_vec_zero_page_buf        = |(sq_entry_age_vec_zero_ptr[SQ_ENTRY-1:0] & sq_entry_page_buf[SQ_ENTRY-1:0]);
assign sq_pe_age_vec_zero_page_sec        = |(sq_entry_age_vec_zero_ptr[SQ_ENTRY-1:0] & sq_entry_page_sec[SQ_ENTRY-1:0]);
assign sq_pe_age_vec_zero_page_share      = |(sq_entry_age_vec_zero_ptr[SQ_ENTRY-1:0] & sq_entry_page_share[SQ_ENTRY-1:0]);
assign sq_pe_age_vec_zero_atomic          = |(sq_entry_age_vec_zero_ptr[SQ_ENTRY-1:0] & sq_entry_atomic[SQ_ENTRY-1:0]);
assign sq_pe_age_vec_zero_icc             = |(sq_entry_age_vec_zero_ptr[SQ_ENTRY-1:0] & sq_entry_icc[SQ_ENTRY-1:0]);
assign sq_pe_age_vec_zero_wo_st           = |(sq_entry_age_vec_zero_ptr[SQ_ENTRY-1:0] & sq_entry_wo_st[SQ_ENTRY-1:0]);
assign sq_pe_age_vec_zero_sync_fence      = |(sq_entry_age_vec_zero_ptr[SQ_ENTRY-1:0] & sq_entry_sync_fence[SQ_ENTRY-1:0]);
assign sq_pe_age_vec_zero_inst_flush      = |(sq_entry_age_vec_zero_ptr[SQ_ENTRY-1:0] & sq_entry_inst_flush[SQ_ENTRY-1:0]);
assign sq_pe_age_vec_zero_dtcm_hit        = |(sq_entry_age_vec_zero_ptr[SQ_ENTRY-1:0] & sq_entry_dtcm_hit[SQ_ENTRY-1:0]);
assign sq_pe_age_vec_zero_itcm_hit        = |(sq_entry_age_vec_zero_ptr[SQ_ENTRY-1:0] & sq_entry_itcm_hit[SQ_ENTRY-1:0]);
always_comb begin  //parameter for sq_preg, LTL@020250610
  sq_pe_age_vec_zero_preg[PREG-1:0] = {PREG{1'b0}};
  for(int i=0;i<SQ_ENTRY;i++) begin
    sq_pe_age_vec_zero_preg[PREG-1:0] |= {PREG{sq_entry_age_vec_zero_ptr[i]}} & sq_entry_preg[i][PREG-1:0];
  end
end
assign sq_pe_age_vec_zero_init_dcache_miss= |(sq_entry_age_vec_zero_ptr[SQ_ENTRY-1:0] & sq_entry_init_dcache_miss[SQ_ENTRY-1:0]);

//assign sq_pe_age_vec_zero_inst_type[1:0]  = {2{sq_entry_age_vec_zero_ptr[0]}}  & sq_entry_inst_type_0[1:0]  //parameter LTL@20241022
//                                             | {2{sq_entry_age_vec_zero_ptr[1]}}  & sq_entry_inst_type_1[1:0]
//                                             | {2{sq_entry_age_vec_zero_ptr[2]}}  & sq_entry_inst_type_2[1:0]
//                                             | {2{sq_entry_age_vec_zero_ptr[3]}}  & sq_entry_inst_type_3[1:0]
//                                             | {2{sq_entry_age_vec_zero_ptr[4]}}  & sq_entry_inst_type_4[1:0]
//                                             | {2{sq_entry_age_vec_zero_ptr[5]}}  & sq_entry_inst_type_5[1:0]
//                                             | {2{sq_entry_age_vec_zero_ptr[6]}}  & sq_entry_inst_type_6[1:0]
//                                             | {2{sq_entry_age_vec_zero_ptr[7]}}  & sq_entry_inst_type_7[1:0]
//                                             | {2{sq_entry_age_vec_zero_ptr[8]}}  & sq_entry_inst_type_8[1:0]
//                                             | {2{sq_entry_age_vec_zero_ptr[9]}}  & sq_entry_inst_type_9[1:0]
//                                             | {2{sq_entry_age_vec_zero_ptr[10]}}  & sq_entry_inst_type_10[1:0]
//                                             | {2{sq_entry_age_vec_zero_ptr[11]}}  & sq_entry_inst_type_11[1:0];
always_comb begin  //parameter for sq_pe_age_vec_zero_inst_type, LTL@020241022
  sq_pe_age_vec_zero_inst_type[1:0] = 2'b0;
  for(int i=0;i<SQ_ENTRY;i++) begin
    sq_pe_age_vec_zero_inst_type[1:0] |= {2{sq_entry_age_vec_zero_ptr[i]}} & sq_entry_inst_type[i][1:0];
  end
end
always_comb begin  //parameter for sq_pe_age_vec_zero_ssp_va, LTL@020250507
  sq_pe_age_vec_zero_ssp_va[1:0] = 2'b0;
  for(int i=0;i<SQ_ENTRY;i++) begin
    sq_pe_age_vec_zero_ssp_va[1:0] |= {2{sq_entry_age_vec_zero_ptr[i]}} & sq_entry_ssp_va[i][1:0];
  end
end

always_comb begin  //parameter for sq_pe_age_vec_zero_pc_index, LTL@020250507
  sq_pe_age_vec_zero_pc_index[PC_LEN-1:0] = {PC_LEN{1'b0}};
  for(int i=0;i<SQ_ENTRY;i++) begin
    sq_pe_age_vec_zero_pc_index[PC_LEN-1:0] |= {PC_LEN{sq_entry_age_vec_zero_ptr[i]}} & sq_entry_pc_index[i][PC_LEN-1:0];
  end
end
//assign sq_pe_age_vec_zero_inst_size[2:0]  = {3{sq_entry_age_vec_zero_ptr[0]}}  & sq_entry_inst_size_0[2:0]  //parameter LTL@20241022
//                                             | {3{sq_entry_age_vec_zero_ptr[1]}}  & sq_entry_inst_size_1[2:0]
//                                             | {3{sq_entry_age_vec_zero_ptr[2]}}  & sq_entry_inst_size_2[2:0]
//                                             | {3{sq_entry_age_vec_zero_ptr[3]}}  & sq_entry_inst_size_3[2:0]
//                                             | {3{sq_entry_age_vec_zero_ptr[4]}}  & sq_entry_inst_size_4[2:0]
//                                             | {3{sq_entry_age_vec_zero_ptr[5]}}  & sq_entry_inst_size_5[2:0]
//                                             | {3{sq_entry_age_vec_zero_ptr[6]}}  & sq_entry_inst_size_6[2:0]
//                                             | {3{sq_entry_age_vec_zero_ptr[7]}}  & sq_entry_inst_size_7[2:0]
//                                             | {3{sq_entry_age_vec_zero_ptr[8]}}  & sq_entry_inst_size_8[2:0]
//                                             | {3{sq_entry_age_vec_zero_ptr[9]}}  & sq_entry_inst_size_9[2:0]
//                                             | {3{sq_entry_age_vec_zero_ptr[10]}}  & sq_entry_inst_size_10[2:0]
//                                             | {3{sq_entry_age_vec_zero_ptr[11]}}  & sq_entry_inst_size_11[2:0];
always_comb begin  //parameter for sq_pe_age_vec_zero_inst_size, LTL@020241022
  sq_pe_age_vec_zero_inst_size[2:0] = 3'b0;
  for(int i=0;i<SQ_ENTRY;i++) begin
    sq_pe_age_vec_zero_inst_size[2:0] |= {3{sq_entry_age_vec_zero_ptr[i]}} & sq_entry_inst_size[i][2:0];
  end
end
//assign sq_pe_age_vec_zero_inst_mode[1:0]  = {2{sq_entry_age_vec_zero_ptr[0]}}  & sq_entry_inst_mode_0[1:0]  //parameter LTL@20241022
//                                             | {2{sq_entry_age_vec_zero_ptr[1]}}  & sq_entry_inst_mode_1[1:0]
//                                             | {2{sq_entry_age_vec_zero_ptr[2]}}  & sq_entry_inst_mode_2[1:0]
//                                             | {2{sq_entry_age_vec_zero_ptr[3]}}  & sq_entry_inst_mode_3[1:0]
//                                             | {2{sq_entry_age_vec_zero_ptr[4]}}  & sq_entry_inst_mode_4[1:0]
//                                             | {2{sq_entry_age_vec_zero_ptr[5]}}  & sq_entry_inst_mode_5[1:0]
//                                             | {2{sq_entry_age_vec_zero_ptr[6]}}  & sq_entry_inst_mode_6[1:0]
//                                             | {2{sq_entry_age_vec_zero_ptr[7]}}  & sq_entry_inst_mode_7[1:0]
//                                             | {2{sq_entry_age_vec_zero_ptr[8]}}  & sq_entry_inst_mode_8[1:0]
//                                             | {2{sq_entry_age_vec_zero_ptr[9]}}  & sq_entry_inst_mode_9[1:0]
//                                             | {2{sq_entry_age_vec_zero_ptr[10]}}  & sq_entry_inst_mode_10[1:0]
//                                             | {2{sq_entry_age_vec_zero_ptr[11]}}  & sq_entry_inst_mode_11[1:0];
always_comb begin  //parameter for sq_pe_age_vec_zero_inst_mode, LTL@020241022
  sq_pe_age_vec_zero_inst_mode[1:0] = 2'b0;
  for(int i=0;i<SQ_ENTRY;i++) begin
    sq_pe_age_vec_zero_inst_mode[1:0] |= {2{sq_entry_age_vec_zero_ptr[i]}} & sq_entry_inst_mode[i];
  end
end
//assign sq_pe_age_vec_zero_priv_mode[1:0]  = {2{sq_entry_age_vec_zero_ptr[0]}}  & sq_entry_priv_mode_0[1:0]  //parameter LTL@20241022
//                                             | {2{sq_entry_age_vec_zero_ptr[1]}}  & sq_entry_priv_mode_1[1:0]
//                                             | {2{sq_entry_age_vec_zero_ptr[2]}}  & sq_entry_priv_mode_2[1:0]
//                                             | {2{sq_entry_age_vec_zero_ptr[3]}}  & sq_entry_priv_mode_3[1:0]
//                                             | {2{sq_entry_age_vec_zero_ptr[4]}}  & sq_entry_priv_mode_4[1:0]
//                                             | {2{sq_entry_age_vec_zero_ptr[5]}}  & sq_entry_priv_mode_5[1:0]
//                                             | {2{sq_entry_age_vec_zero_ptr[6]}}  & sq_entry_priv_mode_6[1:0]
//                                             | {2{sq_entry_age_vec_zero_ptr[7]}}  & sq_entry_priv_mode_7[1:0]
//                                             | {2{sq_entry_age_vec_zero_ptr[8]}}  & sq_entry_priv_mode_8[1:0]
//                                             | {2{sq_entry_age_vec_zero_ptr[9]}}  & sq_entry_priv_mode_9[1:0]
//                                             | {2{sq_entry_age_vec_zero_ptr[10]}}  & sq_entry_priv_mode_10[1:0]
//                                             | {2{sq_entry_age_vec_zero_ptr[11]}}  & sq_entry_priv_mode_11[1:0];
always_comb begin  //parameter for sq_pe_age_vec_zero_priv_mode, LTL@020241022
  sq_pe_age_vec_zero_priv_mode[1:0] = 2'b0;
  for(int i=0;i<SQ_ENTRY;i++) begin
    sq_pe_age_vec_zero_priv_mode[1:0] |= {2{sq_entry_age_vec_zero_ptr[i]}} & sq_entry_priv_mode[i][1:0];
  end
end

//always @( sq_entry_addr0_7[39:0]
//       or sq_entry_addr0_0[39:0]
//       or sq_entry_addr0_8[39:0]
//       or sq_entry_addr0_1[39:0]
//       or sq_entry_addr0_2[39:0]
//       or sq_entry_addr0_4[39:0]
//       or sq_entry_addr0_3[39:0]
//       or sq_entry_addr0_11[39:0]
//       or sq_entry_addr0_5[39:0]
//       or sq_entry_addr0_10[39:0]
//       or sq_entry_addr0_6[39:0]
//       or sq_entry_addr0_9[39:0]
//       or sq_entry_age_vec_surplus1_ptr[11:0])
//begin
//case(sq_entry_age_vec_surplus1_ptr[SQ_ENTRY-1:0])
//  12'h001:  sq_pe_age_vec_surplus1_addr[WK_PA_WIDTH-1:0] = sq_entry_addr0_0[WK_PA_WIDTH-1:0];
//  12'h002:  sq_pe_age_vec_surplus1_addr[WK_PA_WIDTH-1:0] = sq_entry_addr0_1[WK_PA_WIDTH-1:0];
//  12'h004:  sq_pe_age_vec_surplus1_addr[WK_PA_WIDTH-1:0] = sq_entry_addr0_2[WK_PA_WIDTH-1:0];
//  12'h008:  sq_pe_age_vec_surplus1_addr[WK_PA_WIDTH-1:0] = sq_entry_addr0_3[WK_PA_WIDTH-1:0];
//  12'h010:  sq_pe_age_vec_surplus1_addr[WK_PA_WIDTH-1:0] = sq_entry_addr0_4[WK_PA_WIDTH-1:0];
//  12'h020:  sq_pe_age_vec_surplus1_addr[WK_PA_WIDTH-1:0] = sq_entry_addr0_5[WK_PA_WIDTH-1:0];
//  12'h040:  sq_pe_age_vec_surplus1_addr[WK_PA_WIDTH-1:0] = sq_entry_addr0_6[WK_PA_WIDTH-1:0];
//  12'h080:  sq_pe_age_vec_surplus1_addr[WK_PA_WIDTH-1:0] = sq_entry_addr0_7[WK_PA_WIDTH-1:0];
//  12'h100:  sq_pe_age_vec_surplus1_addr[WK_PA_WIDTH-1:0] = sq_entry_addr0_8[WK_PA_WIDTH-1:0];
//  12'h200:  sq_pe_age_vec_surplus1_addr[WK_PA_WIDTH-1:0] = sq_entry_addr0_9[WK_PA_WIDTH-1:0];
//  12'h400:  sq_pe_age_vec_surplus1_addr[WK_PA_WIDTH-1:0] = sq_entry_addr0_10[WK_PA_WIDTH-1:0];
//  12'h800:  sq_pe_age_vec_surplus1_addr[WK_PA_WIDTH-1:0] = sq_entry_addr0_11[WK_PA_WIDTH-1:0];
//  default:sq_pe_age_vec_surplus1_addr[WK_PA_WIDTH-1:0] = {WK_PA_WIDTH{1'bx}};
//endcase
//// &CombEnd; @844
//end
always_comb begin  //parameter for sq_pe_age_vec_zero_addr, LTL@020241022
  sq_pe_age_vec_surplus1_addr[WK_PA_WIDTH-1:0] = {WK_PA_WIDTH{1'b0}};
  for(int i=0;i<SQ_ENTRY;i++) begin
    sq_pe_age_vec_surplus1_addr[WK_PA_WIDTH-1:0] |= {WK_PA_WIDTH{sq_entry_age_vec_surplus1_ptr[i]}} & sq_entry_addr0[i][WK_PA_WIDTH-1:0];
  end
end

// &CombBeg; @846
//always @( sq_entry_bytes_vld_8[15:0]
//       or sq_entry_bytes_vld_4[15:0]
//       or sq_entry_bytes_vld_3[15:0]
//       or sq_entry_bytes_vld_10[15:0]
//       or sq_entry_bytes_vld_6[15:0]
//       or sq_entry_bytes_vld_9[15:0]
//       or sq_entry_bytes_vld_11[15:0]
//       or sq_entry_bytes_vld_2[15:0]
//       or sq_entry_bytes_vld_7[15:0]
//       or sq_entry_bytes_vld_0[15:0]
//       or sq_entry_bytes_vld_1[15:0]
//       or sq_entry_bytes_vld_5[15:0]
//       or sq_entry_age_vec_surplus1_ptr[11:0])
//begin
//case(sq_entry_age_vec_surplus1_ptr[SQ_ENTRY-1:0])
//  12'h001:  sq_pe_age_vec_surplus1_bytes_vld[15:0] = sq_entry_bytes_vld_0[15:0];
//  12'h002:  sq_pe_age_vec_surplus1_bytes_vld[15:0] = sq_entry_bytes_vld_1[15:0];
//  12'h004:  sq_pe_age_vec_surplus1_bytes_vld[15:0] = sq_entry_bytes_vld_2[15:0];
//  12'h008:  sq_pe_age_vec_surplus1_bytes_vld[15:0] = sq_entry_bytes_vld_3[15:0];
//  12'h010:  sq_pe_age_vec_surplus1_bytes_vld[15:0] = sq_entry_bytes_vld_4[15:0];
//  12'h020:  sq_pe_age_vec_surplus1_bytes_vld[15:0] = sq_entry_bytes_vld_5[15:0];
//  12'h040:  sq_pe_age_vec_surplus1_bytes_vld[15:0] = sq_entry_bytes_vld_6[15:0];
//  12'h080:  sq_pe_age_vec_surplus1_bytes_vld[15:0] = sq_entry_bytes_vld_7[15:0];
//  12'h100:  sq_pe_age_vec_surplus1_bytes_vld[15:0] = sq_entry_bytes_vld_8[15:0];
//  12'h200:  sq_pe_age_vec_surplus1_bytes_vld[15:0] = sq_entry_bytes_vld_9[15:0];
//  12'h400:  sq_pe_age_vec_surplus1_bytes_vld[15:0] = sq_entry_bytes_vld_10[15:0];
//  12'h800:  sq_pe_age_vec_surplus1_bytes_vld[15:0] = sq_entry_bytes_vld_11[15:0];
//  default:sq_pe_age_vec_surplus1_bytes_vld[15:0] = {16{1'bx}};
//endcase
//// &CombEnd; @862
//end
always_comb begin  //parameter for sq_pe_age_vec_zero_addr, LTL@020241022
  sq_pe_age_vec_surplus1_bytes_vld[15:0] = 16'b0;
  for(int i=0;i<SQ_ENTRY;i++) begin
    sq_pe_age_vec_surplus1_bytes_vld[15:0] |= {16{sq_entry_age_vec_surplus1_ptr[i]}} & sq_entry_bytes_vld[i][15:0];
  end
end

assign sq_pe_age_vec_surplus1_page_ca     = |(sq_entry_age_vec_surplus1_ptr[SQ_ENTRY-1:0] & sq_entry_page_ca[SQ_ENTRY-1:0]);
assign sq_pe_age_vec_surplus1_page_wa     = |(sq_entry_age_vec_surplus1_ptr[SQ_ENTRY-1:0] & sq_entry_page_wa[SQ_ENTRY-1:0]);
assign sq_pe_age_vec_surplus1_page_so     = |(sq_entry_age_vec_surplus1_ptr[SQ_ENTRY-1:0] & sq_entry_page_so[SQ_ENTRY-1:0]);
assign sq_pe_age_vec_surplus1_page_buf    = |(sq_entry_age_vec_surplus1_ptr[SQ_ENTRY-1:0] & sq_entry_page_buf[SQ_ENTRY-1:0]);
assign sq_pe_age_vec_surplus1_page_sec    = |(sq_entry_age_vec_surplus1_ptr[SQ_ENTRY-1:0] & sq_entry_page_sec[SQ_ENTRY-1:0]);
assign sq_pe_age_vec_surplus1_page_share  = |(sq_entry_age_vec_surplus1_ptr[SQ_ENTRY-1:0] & sq_entry_page_share[SQ_ENTRY-1:0]);
assign sq_pe_age_vec_surplus1_atomic      = |(sq_entry_age_vec_surplus1_ptr[SQ_ENTRY-1:0] & sq_entry_atomic[SQ_ENTRY-1:0]);
assign sq_pe_age_vec_surplus1_icc         = |(sq_entry_age_vec_surplus1_ptr[SQ_ENTRY-1:0] & sq_entry_icc[SQ_ENTRY-1:0]);
assign sq_pe_age_vec_surplus1_wo_st       = |(sq_entry_age_vec_surplus1_ptr[SQ_ENTRY-1:0] & sq_entry_wo_st[SQ_ENTRY-1:0]);
assign sq_pe_age_vec_surplus1_sync_fence  = |(sq_entry_age_vec_surplus1_ptr[SQ_ENTRY-1:0] & sq_entry_sync_fence[SQ_ENTRY-1:0]);
assign sq_pe_age_vec_surplus1_inst_flush  = |(sq_entry_age_vec_surplus1_ptr[SQ_ENTRY-1:0] & sq_entry_inst_flush[SQ_ENTRY-1:0]);
assign sq_pe_age_vec_surplus1_dtcm_hit    = |(sq_entry_age_vec_surplus1_ptr[SQ_ENTRY-1:0] & sq_entry_dtcm_hit[SQ_ENTRY-1:0]);
assign sq_pe_age_vec_surplus1_itcm_hit    = |(sq_entry_age_vec_surplus1_ptr[SQ_ENTRY-1:0] & sq_entry_itcm_hit[SQ_ENTRY-1:0]);
always_comb begin  //parameter for sq_preg, LTL@020250610
  sq_pe_age_vec_surplus1_preg[PREG-1:0] = {PREG{1'b0}};
  for(int i=0;i<SQ_ENTRY;i++) begin
    sq_pe_age_vec_surplus1_preg[PREG-1:0] |= {PREG{sq_entry_age_vec_surplus1_ptr[i]}} & sq_entry_preg[i][PREG-1:0];
  end
end
assign sq_pe_age_vec_surplus1_init_dcache_miss = |(sq_entry_age_vec_surplus1_ptr[SQ_ENTRY-1:0] & sq_entry_init_dcache_miss[SQ_ENTRY-1:0]);

//assign sq_pe_age_vec_surplus1_inst_type[1:0]  = {2{sq_entry_age_vec_surplus1_ptr[0]}}  & sq_entry_inst_type_0[1:0]
//                                                 | {2{sq_entry_age_vec_surplus1_ptr[1]}}  & sq_entry_inst_type_1[1:0]
//                                                 | {2{sq_entry_age_vec_surplus1_ptr[2]}}  & sq_entry_inst_type_2[1:0]
//                                                 | {2{sq_entry_age_vec_surplus1_ptr[3]}}  & sq_entry_inst_type_3[1:0]
//                                                 | {2{sq_entry_age_vec_surplus1_ptr[4]}}  & sq_entry_inst_type_4[1:0]
//                                                 | {2{sq_entry_age_vec_surplus1_ptr[5]}}  & sq_entry_inst_type_5[1:0]
//                                                 | {2{sq_entry_age_vec_surplus1_ptr[6]}}  & sq_entry_inst_type_6[1:0]
//                                                 | {2{sq_entry_age_vec_surplus1_ptr[7]}}  & sq_entry_inst_type_7[1:0]
//                                                 | {2{sq_entry_age_vec_surplus1_ptr[8]}}  & sq_entry_inst_type_8[1:0]
//                                                 | {2{sq_entry_age_vec_surplus1_ptr[9]}}  & sq_entry_inst_type_9[1:0]
//                                                 | {2{sq_entry_age_vec_surplus1_ptr[10]}}  & sq_entry_inst_type_10[1:0]
//                                                 | {2{sq_entry_age_vec_surplus1_ptr[11]}}  & sq_entry_inst_type_11[1:0];
always_comb begin  //parameter for sq_pe_age_vec_surplus1_inst_type, LTL@020241022
  sq_pe_age_vec_surplus1_inst_type[1:0] = 2'b0;
  for(int i=0;i<SQ_ENTRY;i++) begin
    sq_pe_age_vec_surplus1_inst_type[1:0] |= {2{sq_entry_age_vec_surplus1_ptr[i]}} & sq_entry_inst_type[i][1:0];
  end
end

always_comb begin  //parameter for sq_pe_age_vec_surplus1_ssp_va, LTL@020250507
  sq_pe_age_vec_surplus1_ssp_va[1:0] = 2'b0;
  for(int i=0;i<SQ_ENTRY;i++) begin
    sq_pe_age_vec_surplus1_ssp_va[1:0] |= {2{sq_entry_age_vec_surplus1_ptr[i]}} & sq_entry_ssp_va[i][1:0];
  end
end
always_comb begin  //parameter for sq_pe_age_vec_surplus1_pc_index, LTL@020250507
  sq_pe_age_vec_surplus1_pc_index[PC_LEN-1:0] = {PC_LEN{1'b0}};
  for(int i=0;i<SQ_ENTRY;i++) begin
    sq_pe_age_vec_surplus1_pc_index[PC_LEN-1:0] |= {PC_LEN{sq_entry_age_vec_surplus1_ptr[i]}} & sq_entry_pc_index[i][PC_LEN-1:0];
  end
end
//assign sq_pe_age_vec_surplus1_inst_size[2:0]  = {3{sq_entry_age_vec_surplus1_ptr[0]}}  & sq_entry_inst_size_0[2:0]
//                                                 | {3{sq_entry_age_vec_surplus1_ptr[1]}}  & sq_entry_inst_size_1[2:0]
//                                                 | {3{sq_entry_age_vec_surplus1_ptr[2]}}  & sq_entry_inst_size_2[2:0]
//                                                 | {3{sq_entry_age_vec_surplus1_ptr[3]}}  & sq_entry_inst_size_3[2:0]
//                                                 | {3{sq_entry_age_vec_surplus1_ptr[4]}}  & sq_entry_inst_size_4[2:0]
//                                                 | {3{sq_entry_age_vec_surplus1_ptr[5]}}  & sq_entry_inst_size_5[2:0]
//                                                 | {3{sq_entry_age_vec_surplus1_ptr[6]}}  & sq_entry_inst_size_6[2:0]
//                                                 | {3{sq_entry_age_vec_surplus1_ptr[7]}}  & sq_entry_inst_size_7[2:0]
//                                                 | {3{sq_entry_age_vec_surplus1_ptr[8]}}  & sq_entry_inst_size_8[2:0]
//                                                 | {3{sq_entry_age_vec_surplus1_ptr[9]}}  & sq_entry_inst_size_9[2:0]
//                                                 | {3{sq_entry_age_vec_surplus1_ptr[10]}}  & sq_entry_inst_size_10[2:0]
//                                                 | {3{sq_entry_age_vec_surplus1_ptr[11]}}  & sq_entry_inst_size_11[2:0];
always_comb begin  //parameter for sq_pe_age_vec_surplus1_inst_size, LTL@020241022
  sq_pe_age_vec_surplus1_inst_size[2:0] = 3'b0;
  for(int i=0;i<SQ_ENTRY;i++) begin
    sq_pe_age_vec_surplus1_inst_size[2:0] |= {3{sq_entry_age_vec_surplus1_ptr[i]}} & sq_entry_inst_size[i][2:0];
  end
end
//assign sq_pe_age_vec_surplus1_inst_mode[1:0]  = {2{sq_entry_age_vec_surplus1_ptr[0]}}  & sq_entry_inst_mode_0[1:0]
//                                                 | {2{sq_entry_age_vec_surplus1_ptr[1]}}  & sq_entry_inst_mode_1[1:0]
//                                                 | {2{sq_entry_age_vec_surplus1_ptr[2]}}  & sq_entry_inst_mode_2[1:0]
//                                                 | {2{sq_entry_age_vec_surplus1_ptr[3]}}  & sq_entry_inst_mode_3[1:0]
//                                                 | {2{sq_entry_age_vec_surplus1_ptr[4]}}  & sq_entry_inst_mode_4[1:0]
//                                                 | {2{sq_entry_age_vec_surplus1_ptr[5]}}  & sq_entry_inst_mode_5[1:0]
//                                                 | {2{sq_entry_age_vec_surplus1_ptr[6]}}  & sq_entry_inst_mode_6[1:0]
//                                                 | {2{sq_entry_age_vec_surplus1_ptr[7]}}  & sq_entry_inst_mode_7[1:0]
//                                                 | {2{sq_entry_age_vec_surplus1_ptr[8]}}  & sq_entry_inst_mode_8[1:0]
//                                                 | {2{sq_entry_age_vec_surplus1_ptr[9]}}  & sq_entry_inst_mode_9[1:0]
//                                                 | {2{sq_entry_age_vec_surplus1_ptr[10]}}  & sq_entry_inst_mode_10[1:0]
//                                                 | {2{sq_entry_age_vec_surplus1_ptr[11]}}  & sq_entry_inst_mode_11[1:0];
always_comb begin  //parameter for sq_pe_age_vec_surplus1_inst_mode, LTL@020241022
  sq_pe_age_vec_surplus1_inst_mode[1:0] = 2'b0;
  for(int i=0;i<SQ_ENTRY;i++) begin
    sq_pe_age_vec_surplus1_inst_mode[1:0] |= {2{sq_entry_age_vec_surplus1_ptr[i]}} & sq_entry_inst_mode[i][1:0];
  end
end
//assign sq_pe_age_vec_surplus1_priv_mode[1:0]  = {2{sq_entry_age_vec_surplus1_ptr[0]}}  & sq_entry_priv_mode_0[1:0]
//                                                 | {2{sq_entry_age_vec_surplus1_ptr[1]}}  & sq_entry_priv_mode_1[1:0]
//                                                 | {2{sq_entry_age_vec_surplus1_ptr[2]}}  & sq_entry_priv_mode_2[1:0]
//                                                 | {2{sq_entry_age_vec_surplus1_ptr[3]}}  & sq_entry_priv_mode_3[1:0]
//                                                 | {2{sq_entry_age_vec_surplus1_ptr[4]}}  & sq_entry_priv_mode_4[1:0]
//                                                 | {2{sq_entry_age_vec_surplus1_ptr[5]}}  & sq_entry_priv_mode_5[1:0]
//                                                 | {2{sq_entry_age_vec_surplus1_ptr[6]}}  & sq_entry_priv_mode_6[1:0]
//                                                 | {2{sq_entry_age_vec_surplus1_ptr[7]}}  & sq_entry_priv_mode_7[1:0]
//                                                 | {2{sq_entry_age_vec_surplus1_ptr[8]}}  & sq_entry_priv_mode_8[1:0]
//                                                 | {2{sq_entry_age_vec_surplus1_ptr[9]}}  & sq_entry_priv_mode_9[1:0]
//                                                 | {2{sq_entry_age_vec_surplus1_ptr[10]}}  & sq_entry_priv_mode_10[1:0]
//                                                 | {2{sq_entry_age_vec_surplus1_ptr[11]}}  & sq_entry_priv_mode_11[1:0];
always_comb begin  //parameter for sq_pe_age_vec_surplus1_priv_mode, LTL@020241022
  sq_pe_age_vec_surplus1_priv_mode[1:0] = 2'b0;
  for(int i=0;i<SQ_ENTRY;i++) begin
    sq_pe_age_vec_surplus1_priv_mode[1:0] |= {2{sq_entry_age_vec_surplus1_ptr[i]}} & sq_entry_priv_mode[i][1:0];
  end
end
//for vector store idx order
// &Force("nonport","sq_entry_idx_order");  //temporary  @932

//==========================================================
//                request wmb ce
//==========================================================
//------------------pop info--------------------------------
assign sq_pop_req_unmask        = |(sq_entry_pop_req[SQ_ENTRY-1:0]);
//------------------inst type-------------------------------
// &Force("output", "sq_pop_st_inst"); @941
assign sq_pop_st_inst           = !sq_pop_atomic
                                  &&  !sq_pop_icc
                                  &&  !sq_pop_sync_fence;
assign sq_pop_sc_inst           = sq_pop_atomic
                                  &&  (sq_pop_inst_type[1:0] ==  2'b01);
assign sq_pop_dcache_inst       = !sq_pop_atomic
                                  &&  sq_pop_icc
                                  &&  (sq_pop_inst_type[1:0] ==  2'b10);

//dcache all request pass to icc for gate_clk
assign sq_pop_dcache_all_inst   = sq_pop_dcache_inst
                                  &&  (sq_pop_inst_mode[1:0] ==  2'b00);
// &Force("output", "sq_pop_dcache_1line_inst"); @954
assign sq_pop_dcache_1line_inst = sq_pop_dcache_inst
                                  &&  (sq_pop_inst_mode[1:0] !=  2'b00);

assign sq_pop_expt_nop     = |(sq_pop_ptr[SQ_ENTRY-1:0] & sq_entry_expt_nop[SQ_ENTRY-1:0]);
assign sq_pop_expt_nop_vld = sq_pop_req_unmask && sq_pop_expt_nop;
//------------------pop request-----------------------------
//dcache all request icc success and wait for idle
//index not hit include dcache write port not hit
assign sq_pop_to_ce_req_unmask  = sq_pop_req_unmask
                                  &&  (!sq_pop_dcache_all_inst
                                      ||  sq_req_icc_success
                                          &&  icc_idle);

//because change mechanism, cache miss atomic can write, so must wait for hit_idx
assign sq_pop_to_ce_req         = sq_pop_to_ce_req_unmask
                                  &&  !sq_pop_expt_nop
                                  &&  !(sq_pop_sc_inst && (!wmb_empty || wmb_ce_vld) && !cp0_lsu_dcache_en)
                                  &&  !rtu_lsu_async_flush;

assign sq_pop_merge_data_req_unmask = sq_pop_req_unmask
                                      &&  sq_pop_wo_st;

//------------------pop grnt--------------------------------
assign sq_entry_pop_to_ce_grnt[SQ_ENTRY-1:0]  = {SQ_ENTRY{wmb_sq_pop_to_ce_grnt || sq_pop_expt_nop_vld}}
                                                & sq_entry_pop_req[SQ_ENTRY-1:0];
assign sq_entry_pop_to_ce_grnt_b[SQ_ENTRY-1:0]= ~sq_entry_pop_to_ce_grnt[SQ_ENTRY-1:0];

//------------------create signal---------------------------
assign sq_wmb_merge_req               = sq_pop_merge_data_req_unmask;
assign sq_wmb_pop_to_ce_req           = sq_pop_to_ce_req;
assign sq_wmb_merge_stall_req         = wmb_ce_create_hit_rb_idx;
assign sq_wmb_pop_to_ce_dp_req        = sq_pop_to_ce_req_unmask;
assign sq_wmb_pop_to_ce_gateclk_en    = sq_pop_to_ce_req_unmask;

assign sq_wmb_write_imme = sq_pop_req_unmask
                           && sq_pop_sc_inst
                           && !cp0_lsu_dcache_en;

//if hit rb idx, then cannot merge
// &Force("output","wmb_ce_create_hit_rb_idx"); @994
assign wmb_ce_create_hit_rb_idx = rb_sq_pop_hit_idx
                                  &&  (sq_pop_wo_st
                                      ||  sq_pop_atomic
                                      ||  sq_pop_dcache_1line_inst);

//==========================================================
//                request icc
//==========================================================
//-----------------register---------------------------------
always @(posedge sq_create_pop_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    sq_req_icc_success  <=  1'b0;
  else if(icc_sq_grnt)
    sq_req_icc_success  <=  1'b1;
  else if(wmb_sq_pop_to_ce_grnt)
    sq_req_icc_success  <=  1'b0;
end
//-----------------wires------------------------------------
assign sq_icc_req = sq_pop_req_unmask
                    &&  sq_pop_dcache_all_inst
                    &&  !wmb_ce_vld
                    &&  !sq_req_icc_success;
assign sq_icc_clr = sq_pop_inst_size[0];
assign sq_icc_inv = sq_pop_inst_size[1];

//==========================================================
//                interface to pfu
//==========================================================
//clear all entry if sq pop a sync.i inst
assign sq_pfu_pop_synci_inst  = sq_pop_req_unmask
                                &&  !sq_pop_atomic
                                &&  sq_pop_sync_fence
                                &&  (sq_pop_inst_type[1:0]  ==  2'b00)
                                &&  sq_pop_inst_flush;


//==========================================================
//                wmb ce data path
//==========================================================
//assign wmb_ce_fence_mode[3:0]   = {4{wmb_ce_sq_ptr[0]}}  & sq_entry_fence_mode_0[3:0]
//                                  | {4{wmb_ce_sq_ptr[1]}}  & sq_entry_fence_mode_1[3:0]
//                                  | {4{wmb_ce_sq_ptr[2]}}  & sq_entry_fence_mode_2[3:0]
//                                  | {4{wmb_ce_sq_ptr[3]}}  & sq_entry_fence_mode_3[3:0]
//                                  | {4{wmb_ce_sq_ptr[4]}}  & sq_entry_fence_mode_4[3:0]
//                                  | {4{wmb_ce_sq_ptr[5]}}  & sq_entry_fence_mode_5[3:0]
//                                  | {4{wmb_ce_sq_ptr[6]}}  & sq_entry_fence_mode_6[3:0]
//                                  | {4{wmb_ce_sq_ptr[7]}}  & sq_entry_fence_mode_7[3:0]
//                                  | {4{wmb_ce_sq_ptr[8]}}  & sq_entry_fence_mode_8[3:0]
//                                  | {4{wmb_ce_sq_ptr[9]}}  & sq_entry_fence_mode_9[3:0]
//                                  | {4{wmb_ce_sq_ptr[10]}}  & sq_entry_fence_mode_10[3:0]
//                                  | {4{wmb_ce_sq_ptr[11]}}  & sq_entry_fence_mode_11[3:0];
always_comb begin  //parameter for wmb_ce_fence_mode, LTL@020241022
  wmb_ce_fence_mode[3:0] = 4'b0;
  for(int i=0;i<SQ_ENTRY;i++) begin
    wmb_ce_fence_mode[3:0] |= {4{wmb_ce_sq_ptr[i]}} & sq_entry_fence_mode[i][3:0];
  end
end

//assign wmb_ce_iid[IID_WIDTH-1:0]          = {IID_WIDTH{wmb_ce_sq_ptr[0]}}  & sq_entry_iid_0[IID_WIDTH-1:0]
//                                  | {IID_WIDTH{wmb_ce_sq_ptr[1]}}  & sq_entry_iid_1[IID_WIDTH-1:0]
//                                  | {IID_WIDTH{wmb_ce_sq_ptr[2]}}  & sq_entry_iid_2[IID_WIDTH-1:0]
//                                  | {IID_WIDTH{wmb_ce_sq_ptr[3]}}  & sq_entry_iid_3[IID_WIDTH-1:0]
//                                  | {IID_WIDTH{wmb_ce_sq_ptr[4]}}  & sq_entry_iid_4[IID_WIDTH-1:0]
//                                  | {IID_WIDTH{wmb_ce_sq_ptr[5]}}  & sq_entry_iid_5[IID_WIDTH-1:0]
//                                  | {IID_WIDTH{wmb_ce_sq_ptr[6]}}  & sq_entry_iid_6[IID_WIDTH-1:0]
//                                  | {IID_WIDTH{wmb_ce_sq_ptr[7]}}  & sq_entry_iid_7[IID_WIDTH-1:0]
//                                  | {IID_WIDTH{wmb_ce_sq_ptr[8]}}  & sq_entry_iid_8[IID_WIDTH-1:0]
//                                  | {IID_WIDTH{wmb_ce_sq_ptr[9]}}  & sq_entry_iid_9[IID_WIDTH-1:0]
//                                  | {IID_WIDTH{wmb_ce_sq_ptr[10]}}  & sq_entry_iid_10[IID_WIDTH-1:0]
//                                  | {IID_WIDTH{wmb_ce_sq_ptr[11]}}  & sq_entry_iid_11[IID_WIDTH-1:0];
always_comb begin  //parameter for wmb_ce_iid, LTL@020241022
  wmb_ce_iid[IID_WIDTH-1:0] = {IID_WIDTH{1'b0}};
  for(int i=0;i<SQ_ENTRY;i++) begin
    wmb_ce_iid[IID_WIDTH-1:0] |= {IID_WIDTH{wmb_ce_sq_ptr[i]}} & sq_entry_iid[i][IID_WIDTH-1:0];
  end
end


assign wmb_ce_spec_fail         = |(wmb_ce_sq_ptr[SQ_ENTRY-1:0]  & sq_entry_spec_fail[SQ_ENTRY-1:0]);
assign wmb_ce_vstart_vld        = |(wmb_ce_sq_ptr[SQ_ENTRY-1:0]  & sq_entry_vstart_vld[SQ_ENTRY-1:0]);

// &CombBeg; @1067
//always @( sq_entry_data_8[127:0]  //parameter for wmb_ce_data128, LTL@020241022
//       or sq_entry_data_6[127:0]
//       or sq_entry_data_10[127:0]
//       or sq_entry_data_11[127:0]
//       or sq_entry_data_1[127:0]
//       or sq_entry_data_7[127:0]
//       or sq_entry_data_4[127:0]
//       or sq_entry_data_2[127:0]
//       or sq_entry_data_3[127:0]
//       or sq_entry_data_5[127:0]
//       or wmb_ce_sq_ptr[11:0]
//       or sq_entry_data_0[127:0]
//       or sq_entry_data_9[127:0])
//begin
//case(wmb_ce_sq_ptr[SQ_ENTRY-1:0])  
//  12'h001:  wmb_ce_data128[127:0] = sq_entry_data_0[127:0];
//  12'h002:  wmb_ce_data128[127:0] = sq_entry_data_1[127:0];
//  12'h004:  wmb_ce_data128[127:0] = sq_entry_data_2[127:0];
//  12'h008:  wmb_ce_data128[127:0] = sq_entry_data_3[127:0];
//  12'h010:  wmb_ce_data128[127:0] = sq_entry_data_4[127:0];
//  12'h020:  wmb_ce_data128[127:0] = sq_entry_data_5[127:0];
//  12'h040:  wmb_ce_data128[127:0] = sq_entry_data_6[127:0];
//  12'h080:  wmb_ce_data128[127:0] = sq_entry_data_7[127:0];
//  12'h100:  wmb_ce_data128[127:0] = sq_entry_data_8[127:0];
//  12'h200:  wmb_ce_data128[127:0] = sq_entry_data_9[127:0];
//  12'h400:  wmb_ce_data128[127:0] = sq_entry_data_10[127:0];
//  12'h800:  wmb_ce_data128[127:0] = sq_entry_data_11[127:0];
//  default:wmb_ce_data128[127:0] = {128{1'bx}};
//endcase
//end
always_comb begin  //parameter for wmb_ce_data128, LTL@020241022
  wmb_ce_data128[127:0] = 128'b0;
  for(int i=0;i<SQ_ENTRY;i++) begin
    wmb_ce_data128[127:0] |= {128{wmb_ce_sq_ptr[i]}} & sq_entry_data[i][127:0];
  end
end

// &Force("output","wmb_ce_dcache_valid"); @1106
assign wmb_ce_dcache_valid      = |(wmb_ce_sq_ptr[SQ_ENTRY-1:0]  & sq_entry_dcache_valid[SQ_ENTRY-1:0]);
// &Force("output","wmb_ce_dcache_share"); @1108
assign wmb_ce_dcache_share      = |(wmb_ce_sq_ptr[SQ_ENTRY-1:0]  & sq_entry_dcache_share[SQ_ENTRY-1:0]);
assign wmb_ce_dcache_dirty      = |(wmb_ce_sq_ptr[SQ_ENTRY-1:0]  & sq_entry_dcache_dirty[SQ_ENTRY-1:0]);
assign wmb_ce_dcache_page_share = |(wmb_ce_sq_ptr[SQ_ENTRY-1:0]  & sq_entry_dcache_page_share[SQ_ENTRY-1:0]);

//assign wmb_ce_dcache_way        = |(wmb_ce_sq_ptr[SQ_ENTRY-1:0]  & sq_entry_dcache_way[SQ_ENTRY-1:0]);
always_comb begin  //parameter for wmb_ce_data128, LTL@020241022
  wmb_ce_dcache_way[1:0] = 2'b0;
  for(int i=0;i<SQ_ENTRY;i++) begin
    wmb_ce_dcache_way[1:0] |= {2{wmb_ce_sq_ptr[i]}} & sq_entry_dcache_way[i][1:0];
  end
end
assign wmb_ce_depd              = |(wmb_ce_sq_ptr[SQ_ENTRY-1:0]  & sq_entry_depd[SQ_ENTRY-1:0]);
assign wmb_ce_depd_set          = |(wmb_ce_sq_ptr[SQ_ENTRY-1:0]  & sq_entry_depd_set[SQ_ENTRY-1:0]);
assign wmb_ce_lm_fail           = |(wmb_ce_sq_ptr[SQ_ENTRY-1:0]  & sq_entry_lm_fail[SQ_ENTRY-1:0]);

//==========================================================
//            Compare dcache write port(dcwp)
//==========================================================
// &Instance("xx_lsu_dcache_info_update","x_lsu_wmb_ce_dcache_info_update"); @1120
xx_lsu_dcache_info_update  x_lsu_wmb_ce_dcache_info_update (
  .compare_dcwp_addr               (wmb_ce_addr[`WK_PA_WIDTH-1:0]  ),
  .compare_dcwp_hit_idx            (wmb_ce_dcache_hit_idx          ),
  .compare_dcwp_sw_inst            (wmb_ce_dcache_sw_inst          ),
  .compare_dcwp_update_vld         (wmb_ce_dcache_update_vld       ),
  .dcache_dirty_din                (dcache_dirty_din               ),
  .dcache_dirty_gwen               (dcache_dirty_gwen              ),
  .dcache_dirty_wen                (dcache_dirty_wen               ),
  .dcache_idx                      (dcache_idx                     ),
  .dcache_tag_din                  (dcache_tag_din                 ),
  .dcache_tag_gwen                 (dcache_tag_gwen                ),
  .dcache_tag_wen                  (dcache_tag_wen                 ),
  .origin_dcache_dirty             (wmb_ce_dcache_dirty            ),
  .origin_dcache_page_share        (wmb_ce_dcache_page_share       ),
  .origin_dcache_share             (wmb_ce_dcache_share            ),
  .origin_dcache_valid             (wmb_ce_dcache_valid            ),
  .origin_dcache_way               (wmb_ce_dcache_way              ),
  .update_dcache_dirty             (wmb_ce_update_dcache_dirty     ),
  .update_dcache_page_share        (wmb_ce_update_dcache_page_share),
  .update_dcache_share             (wmb_ce_update_dcache_share     ),
  .update_dcache_valid             (wmb_ce_update_dcache_valid     ),
  .update_dcache_way               (wmb_ce_update_dcache_way       )
);

// &Connect( .compare_dcwp_addr          (wmb_ce_addr[WK_PA_WIDTH-1:0]   ), @1121
//           .compare_dcwp_sw_inst       (wmb_ce_dcache_sw_inst), @1122
//           .origin_dcache_valid        (wmb_ce_dcache_valid ), @1123
//           .origin_dcache_share        (wmb_ce_dcache_share ), @1124
//           .origin_dcache_dirty        (wmb_ce_dcache_dirty ), @1125
//           .origin_dcache_page_share   (wmb_ce_dcache_page_share ), @1126
//           .origin_dcache_way          (wmb_ce_dcache_way   ), @1127
//           .compare_dcwp_update_vld    (wmb_ce_dcache_update_vld), @1128
//           .compare_dcwp_hit_idx       (wmb_ce_dcache_hit_idx), @1129
//           .update_dcache_valid        (wmb_ce_update_dcache_valid), @1130
//           .update_dcache_share        (wmb_ce_update_dcache_share), @1131
//           .update_dcache_dirty        (wmb_ce_update_dcache_dirty), @1132
//           .update_dcache_page_share   (wmb_ce_update_dcache_page_share), @1133
//           .update_dcache_way          (wmb_ce_update_dcache_way  )); @1134
// &Force("nonport","wmb_ce_dcache_update_vld"); @1135
// &Force("nonport","wmb_ce_dcache_hit_idx"); @1136
//==========================================================
//                interface to idu
//==========================================================
assign lsu_rtu_all_commit_st_data_vld = &sq_entry_cmit_data_vld[SQ_ENTRY-1:0];
assign lsu_rtu_all_commit_data_vld    = lsu_rtu_all_commit_st_data_vld && lsu_rtu_all_commit_ld_data_vld;

assign lsu_idu_exx_sq_not_full            = !sq_empty_less2;

//==========================================================
//                interface to had
//==========================================================
assign lsu_had_sq_not_empty       = !sq_empty;

//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================

assign wmb_ce_expt_vld          = |(wmb_ce_sq_ptr[SQ_ENTRY-1:0]  & sq_entry_expt_nop[SQ_ENTRY-1:0]); 

//ls0
always_comb begin
  wmb_ce_halt_info_0[`TDT_MP_HINFO_WIDTH-1:0] = {`TDT_MP_HINFO_WIDTH{1'b0}};
  for(int i=0;i<SQ_ENTRY;i++) begin
    wmb_ce_halt_info_0[`TDT_MP_HINFO_WIDTH-1:0] |= {`TDT_MP_HINFO_WIDTH{wmb_ce_sq_ptr[i]}} & sq_entry_halt_info_0[i][`TDT_MP_HINFO_WIDTH-1:0];
  end
end

com_ff1_from_lsb #(.WIDTH(SQ_ENTRY)) x_xx_lsu_sq_wake_data_0(
  .in_data                (sq_entry_wake_data_req_0),
  .out_data               (sq_entry_wake_data_sel_0)
);
assign sq_entry_wake_data_grnt_0[SQ_ENTRY-1:0] = sq_entry_wake_data_sel_0[SQ_ENTRY-1:0];

assign st_dtu_data_clk_en_0  =  std0_ex1_inst_vld
                             &  dtu_lsu_data_trig_en
                             |  st_dtu0_vld_0
                             |  lsu_dtu_data_vld0
                             |  st_dtu2_vld_0;
// &Instance("gated_clk_cell", "x_lsu_sq_dbg_gated_clk"); @102
gated_clk_cell  x_lsu_st_dtu_data_gated_clk_0 (
  .clk_in             (forever_cpuclk       ),
  .clk_out            (st_dtu_data_clk_0    ),
  .external_en        (1'b0                 ),
  .local_en           (st_dtu_data_clk_en_0 ),
  .module_en          (cp0_lsu_icg_en       ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en   )
);

//
always @(posedge st_dtu_data_clk_0 or negedge cpurst_b)
begin
  if(~cpurst_b)
    st_dtu0_vld_0 <= 1'b0;
  else if(rtu_yy_xx_flush)
    st_dtu0_vld_0 <= 1'b0;
  else if(std0_ex1_inst_vld & dtu_lsu_data_trig_en)
    st_dtu0_vld_0 <= 1'b1;
  else
    st_dtu0_vld_0 <= 1'b0;
end

assign st_dtu0_sq_data_ptr_pre_0[SQ_ENTRY-1:0] = sq_entry_settle_data_hit0[SQ_ENTRY-1:0];

always @(posedge st_dtu_data_clk_0 or negedge cpurst_b)
begin
  if(~cpurst_b)
  begin
    st_dtu0_sq_data_ptr_0[SQ_ENTRY-1:0]   <= {SQ_ENTRY{1'b0}};
    st_dtu0_data_0[127:0] <= {128{1'b0}};
  end
  else if(std0_ex1_inst_vld)
  begin
    st_dtu0_sq_data_ptr_0[SQ_ENTRY-1:0]   <= st_dtu0_sq_data_ptr_pre_0[SQ_ENTRY-1:0];
    st_dtu0_data_0[127:0] <= std0_sq_ex1_data[127:0];
  end
end

//
assign st_dtu0_entry_vld_0  = |(st_dtu0_sq_data_ptr_0[SQ_ENTRY-1:0] & sq_entry_vld[SQ_ENTRY-1:0]);
assign st_dtu0_data_check_0 = |(st_dtu0_sq_data_ptr_0[SQ_ENTRY-1:0] & sq_entry_data_check_0[SQ_ENTRY-1:0]);
//
always_comb begin
  st_dtu0_halt_info_0[`TDT_MP_HINFO_WIDTH-1:0] = {`TDT_MP_HINFO_WIDTH{1'b0}};
  for(int i=0;i<SQ_ENTRY;i++) begin
    st_dtu0_halt_info_0[`TDT_MP_HINFO_WIDTH-1:0] |= {`TDT_MP_HINFO_WIDTH{st_dtu0_sq_data_ptr_0[i]}} & sq_entry_halt_info_0[i][`TDT_MP_HINFO_WIDTH-1:0];
  end
end
//
always_comb begin
  st_dtu0_inst_size_0[2:0] = {3{1'b0}};
  for(int i=0;i<SQ_ENTRY;i++) begin
    st_dtu0_inst_size_0[2:0] |= {3{st_dtu0_sq_data_ptr_0[i]}} & sq_entry_inst_size[i][2:0];
  end
end
//
always @(posedge st_dtu_data_clk_0 or negedge cpurst_b)
begin
  if(~cpurst_b)
    lsu_dtu_data_vld0 <= 1'b0;
  else if(rtu_yy_xx_flush)
    lsu_dtu_data_vld0 <= 1'b0;
  else if(st_dtu0_vld_0 & st_dtu0_entry_vld_0)
    lsu_dtu_data_vld0 <= 1'b1;
  else
    lsu_dtu_data_vld0 <= 1'b0;
end

always @(posedge st_dtu_data_clk_0 or negedge cpurst_b)
begin
  if(~cpurst_b)
  begin
    st_dtu1_sq_data_ptr_0[SQ_ENTRY-1:0] <= {SQ_ENTRY{1'b0}};
    lsu_dtu_data0[127:0]   <= {128{1'b0}};
    lsu_dtu_data_size0[2:0] <= {3{1'b0}};
    lsu_dtu_data_halt_info0[`TDT_MP_HINFO_WIDTH-1:0]  <= {`TDT_MP_HINFO_WIDTH{1'b0}};  
  end
  else if(st_dtu0_vld_0)
  begin
    st_dtu1_sq_data_ptr_0[SQ_ENTRY-1:0] <= st_dtu0_sq_data_ptr_0[SQ_ENTRY-1:0];
    lsu_dtu_data0[127:0]   <= st_dtu0_data_0[127:0];
    lsu_dtu_data_size0[2:0] <= st_dtu0_inst_size_0[2:0];
    lsu_dtu_data_halt_info0[`TDT_MP_HINFO_WIDTH-1:0]  <= st_dtu0_halt_info_0[`TDT_MP_HINFO_WIDTH-1:0];
  end
end
assign lsu_dtu_data_type0[1:0] = 2'b01;

//
assign st_dtu1_entry_vld_0  = |(st_dtu1_sq_data_ptr_0[SQ_ENTRY-1:0] & sq_entry_vld[SQ_ENTRY-1:0]);
//
//
always @(posedge st_dtu_data_clk_0 or negedge cpurst_b)
begin
  if(~cpurst_b)
    st_dtu2_vld_0 <= 1'b0;
  else if(rtu_yy_xx_flush)
    st_dtu2_vld_0 <= 1'b0;
  else if(lsu_dtu_data_vld0 & st_dtu1_entry_vld_0)
    st_dtu2_vld_0 <= 1'b1;
  else
    st_dtu2_vld_0 <= 1'b0;
end

always @(posedge st_dtu_data_clk_0 or negedge cpurst_b)
begin
  if(~cpurst_b)
    st_dtu2_sq_data_ptr_0[SQ_ENTRY-1:0]   <= {SQ_ENTRY{1'b0}};
  else if(lsu_dtu_data_vld0)
    st_dtu2_sq_data_ptr_0[SQ_ENTRY-1:0]   <= st_dtu1_sq_data_ptr_0[SQ_ENTRY-1:0];
end

assign sq_entry_data_halt_info_update_vld_0[SQ_ENTRY-1 :0] = {SQ_ENTRY{st_dtu2_vld_0}}
                                                          & sq_entry_vld[SQ_ENTRY-1:0]
                                                          & st_dtu2_sq_data_ptr_0[SQ_ENTRY-1:0];

//ls1
always_comb begin
  wmb_ce_halt_info_1[`TDT_MP_HINFO_WIDTH-1:0] = {`TDT_MP_HINFO_WIDTH{1'b0}};
  for(int i=0;i<SQ_ENTRY;i++) begin
    wmb_ce_halt_info_1[`TDT_MP_HINFO_WIDTH-1:0] |= {`TDT_MP_HINFO_WIDTH{wmb_ce_sq_ptr[i]}} & sq_entry_halt_info_1[i][`TDT_MP_HINFO_WIDTH-1:0];
  end
end

com_ff1_from_lsb #(.WIDTH(SQ_ENTRY)) x_xx_lsu_sq_wake_data_1(
  .in_data                (sq_entry_wake_data_req_1),
  .out_data               (sq_entry_wake_data_sel_1)
);
assign sq_entry_wake_data_grnt_1[SQ_ENTRY-1:0] = sq_entry_wake_data_sel_1[SQ_ENTRY-1:0];

assign st_dtu_data_clk_en_1  =  std1_ex1_inst_vld
                             &  dtu_lsu_data_trig_en
                             |  st_dtu0_vld_1
                             |  lsu_dtu_data_vld1
                             |  st_dtu2_vld_1;

gated_clk_cell  x_lsu_st_dtu_data_gated_clk_1 (
  .clk_in             (forever_cpuclk       ),
  .clk_out            (st_dtu_data_clk_1    ),
  .external_en        (1'b0                 ),
  .local_en           (st_dtu_data_clk_en_1 ),
  .module_en          (cp0_lsu_icg_en       ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en   )
);

//
always @(posedge st_dtu_data_clk_1 or negedge cpurst_b)
begin
  if(~cpurst_b)
    st_dtu0_vld_1 <= 1'b0;
  else if(rtu_yy_xx_flush)
    st_dtu0_vld_1 <= 1'b0;
  else if(std1_ex1_inst_vld & dtu_lsu_data_trig_en)
    st_dtu0_vld_1 <= 1'b1;
  else
    st_dtu0_vld_1 <= 1'b0;
end

assign st_dtu0_sq_data_ptr_pre_1[SQ_ENTRY-1:0] = sq_entry_settle_data_hit1[SQ_ENTRY-1:0];

always @(posedge st_dtu_data_clk_1 or negedge cpurst_b)
begin
  if(~cpurst_b)
  begin
    st_dtu0_sq_data_ptr_1[SQ_ENTRY-1:0]   <= {SQ_ENTRY{1'b0}};
    st_dtu0_data_1[127:0] <= {128{1'b0}};
  end
  else if(std1_ex1_inst_vld)
  begin
    st_dtu0_sq_data_ptr_1[SQ_ENTRY-1:0]   <= st_dtu0_sq_data_ptr_pre_1[SQ_ENTRY-1:0];
    st_dtu0_data_1[127:0] <= std1_sq_ex1_data[127:0];
  end
end

//
assign st_dtu0_entry_vld_1  = |(st_dtu0_sq_data_ptr_1[SQ_ENTRY-1:0] & sq_entry_vld[SQ_ENTRY-1:0]);
assign st_dtu0_data_check_1 = |(st_dtu0_sq_data_ptr_1[SQ_ENTRY-1:0] & sq_entry_data_check_1[SQ_ENTRY-1:0]);
//
always_comb begin
  st_dtu0_halt_info_1[`TDT_MP_HINFO_WIDTH-1:0] = {`TDT_MP_HINFO_WIDTH{1'b0}};
  for(int i=0;i<SQ_ENTRY;i++) begin
    st_dtu0_halt_info_1[`TDT_MP_HINFO_WIDTH-1:0] |= {`TDT_MP_HINFO_WIDTH{st_dtu0_sq_data_ptr_1[i]}} & sq_entry_halt_info_1[i][`TDT_MP_HINFO_WIDTH-1:0];
  end
end
//
always_comb begin
  st_dtu0_inst_size_1[2:0] = {3{1'b0}};
  for(int i=0;i<SQ_ENTRY;i++) begin
    st_dtu0_inst_size_1[2:0] |= {3{st_dtu0_sq_data_ptr_1[i]}} & sq_entry_inst_size[i][2:0];
  end
end
//
always @(posedge st_dtu_data_clk_1 or negedge cpurst_b)
begin
  if(~cpurst_b)
    lsu_dtu_data_vld1 <= 1'b0;
  else if(rtu_yy_xx_flush)
    lsu_dtu_data_vld1 <= 1'b0;
  else if(st_dtu0_vld_1 & st_dtu0_entry_vld_1)
    lsu_dtu_data_vld1 <= 1'b1;
  else
    lsu_dtu_data_vld1 <= 1'b0;
end

always @(posedge st_dtu_data_clk_1 or negedge cpurst_b)
begin
  if(~cpurst_b)
  begin
    st_dtu1_sq_data_ptr_1[SQ_ENTRY-1:0] <= {SQ_ENTRY{1'b0}};
    lsu_dtu_data1[127:0]   <= {128{1'b0}};
    lsu_dtu_data_size1[2:0] <= {3{1'b0}};
    lsu_dtu_data_halt_info1[`TDT_MP_HINFO_WIDTH-1:0]  <= {`TDT_MP_HINFO_WIDTH{1'b0}};  
  end
  else if(st_dtu0_vld_1)
  begin
    st_dtu1_sq_data_ptr_1[SQ_ENTRY-1:0] <= st_dtu0_sq_data_ptr_1[SQ_ENTRY-1:0];
    lsu_dtu_data1[127:0]   <= st_dtu0_data_1[127:0];
    lsu_dtu_data_size1[2:0] <= st_dtu0_inst_size_1[2:0];
    lsu_dtu_data_halt_info1[`TDT_MP_HINFO_WIDTH-1:0]  <= st_dtu0_halt_info_1[`TDT_MP_HINFO_WIDTH-1:0];
  end
end
assign lsu_dtu_data_type1[1:0] = 2'b01;

//
assign st_dtu1_entry_vld_1  = |(st_dtu1_sq_data_ptr_1[SQ_ENTRY-1:0] & sq_entry_vld[SQ_ENTRY-1:0]);
//
//
always @(posedge st_dtu_data_clk_1 or negedge cpurst_b)
begin
  if(~cpurst_b)
    st_dtu2_vld_1 <= 1'b0;
  else if(rtu_yy_xx_flush)
    st_dtu2_vld_1 <= 1'b0;
  else if(lsu_dtu_data_vld1 & st_dtu1_entry_vld_1)
    st_dtu2_vld_1 <= 1'b1;
  else
    st_dtu2_vld_1 <= 1'b0;
end

always @(posedge st_dtu_data_clk_1 or negedge cpurst_b)
begin
  if(~cpurst_b)
    st_dtu2_sq_data_ptr_1[SQ_ENTRY-1:0]   <= {SQ_ENTRY{1'b0}};
  else if(lsu_dtu_data_vld1)
    st_dtu2_sq_data_ptr_1[SQ_ENTRY-1:0]   <= st_dtu1_sq_data_ptr_1[SQ_ENTRY-1:0];
end

assign sq_entry_data_halt_info_update_vld_1[SQ_ENTRY-1 :0] = {SQ_ENTRY{st_dtu2_vld_1}}
                                                          & sq_entry_vld[SQ_ENTRY-1:0]
                                                          & st_dtu2_sq_data_ptr_1[SQ_ENTRY-1:0];
//==========================================================
//                  Risc-V Debug zdb End 
//==========================================================

// &ModuleEnd; @1350
endmodule


