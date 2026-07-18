//-----------------------------------------------------------------------------
// File          : xx_lsu_sq_entry.v
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


// $Id: xx_lsu_sq_entry.vp,v 1.35 2022/02/18 07:52:18 zhangwen Exp $
// *****************************************************************************

// &ModuleBeg; @29
module xx_lsu_sq_entry #(
  parameter LSIQ_ENTRY    = 12,
  parameter SQ_ENTRY      = 12,
  parameter SDID_LEN      = 4,
  parameter IID_WIDTH     = 7,
  parameter WK_PA_WIDTH   = `WK_PA_WIDTH,
  parameter PREG          = 7,
  parameter PC_LEN        = 15
)(
// &Ports, @30
input logic                                         rtu_ck_flush,
input logic    [IID_WIDTH-1:0]                      rtu_ck_flush_iid,
input logic                                         cp0_lsu_icg_en,                          
input logic   [1  :0]                               cp0_yy_priv_mode,                        
input logic                                         cpurst_b,                                
input logic   [15 :0]                               dcache_dirty_din,      //8->15, L1D2->4way,  LTL@20250323                   
input logic                                         dcache_dirty_gwen,                       
input logic   [15 :0]                               dcache_dirty_wen,      //8->15, L1D2->4way,  LTL@20250323                   
input logic   [7  :0]                               dcache_idx,            //8->7, L1D2->4way,  LTL@20250323                    
input logic   [`WK_LS_DCACHE_TAG_NOECC_WIDTH-1:0]   dcache_tag_din,        //51->103, L1D2->4way,  LTL@20250323                   
input logic                                         dcache_tag_gwen,                         
input logic   [3  :0]                               dcache_tag_wen,        //1->3, L1D2->4way,  LTL@20250323                  
input logic                                         forever_cpuclk,                          
input logic   [LSIQ_ENTRY-1:0]                      lda0_ex3_lsid,  //1->3 for 3 ld, LTL@20241021
input logic   [LSIQ_ENTRY-1:0]                      lsda0_ex3_lsid,
input logic   [LSIQ_ENTRY-1:0]                      lsda1_ex3_lsid,
input logic   [`WK_PA_WIDTH-1 :0]                   ldc0_ex2_addr0,   //1->3 for 3 ld, LTL@20241021
input logic   [`WK_PA_WIDTH-1 :0]                   lsdc0_ex2_st_addr0,//timing@LTL
input logic   [`WK_PA_WIDTH-1 :0]                   lsdc0_ex2_ld_addr0,//timing
input logic   [`WK_PA_WIDTH-1 :0]                   lsdc1_ex2_st_addr0,//timing@LTL
input logic   [`WK_PA_WIDTH-1 :0]                   lsdc1_ex2_ld_addr0,//timing
input logic   [7  :0]                               ldc0_ex2_addr1_11to4,   //1->3 for 3 ld, LTL@20241021
input logic   [7  :0]                               lsdc0_ex2_addr1_11to4,
input logic   [7  :0]                               lsdc1_ex2_addr1_11to4,
input logic   [15 :0]                               ldc0_ex2_bytes_vld,  //1->3 for 3 ld, LTL@20241021
input logic   [15 :0]                               lsdc0_ex2_st_bytes_vld,
input logic   [15 :0]                               lsdc0_ex2_ld_bytes_vld,//timing
input logic   [15 :0]                               lsdc1_ex2_st_bytes_vld,
input logic   [15 :0]                               lsdc1_ex2_ld_bytes_vld,//timing
input logic   [15 :0]                               ldc0_ex2_bytes_vld1,  //1->3 for 3 ld, LTL@20241021
input logic   [15 :0]                               lsdc0_ex2_bytes_vld1,
input logic   [15 :0]                               lsdc1_ex2_bytes_vld1,
input logic   [15 :0]                               ldc0_ex2_bytes_vld2, //rvv512@LTL
input logic   [15 :0]                               lsdc0_ex2_bytes_vld2,//rvv512@LTL
input logic   [15 :0]                               lsdc1_ex2_bytes_vld2,//rvv512@LTL
input logic   [15 :0]                               ldc0_ex2_bytes_vld3, //rvv512@LTL
input logic   [15 :0]                               lsdc0_ex2_bytes_vld3,//rvv512@LTL
input logic   [15 :0]                               lsdc1_ex2_bytes_vld3,//rvv512@LTL
input logic                                         ldc0_ex2_is_us,      //rvv512@LTL
input logic                                         lsdc0_ex2_is_us,     //rvv512@LTL
input logic                                         lsdc1_ex2_is_us,     //rvv512@LTL   
input logic                                         ldc0_ex2_chk_atomic_inst_vld,  //1->3 for 3 ld, LTL@20241021
input logic                                         lsdc0_ex2_chk_atomic_inst_vld,
input logic                                         lsdc1_ex2_chk_atomic_inst_vld,
input logic                                         ldc0_ex2_chk_ld_addr1_vld,   //1->3 for 3 ld, LTL@20241021
input logic                                         lsdc0_ex2_chk_ld_addr1_vld, 
input logic                                         lsdc1_ex2_chk_ld_addr1_vld, 
input logic                                         ldc0_sq_ex2_chk_ld_bypass_vld,  //1->3 for 3 ld, LTL@20241021
input logic                                         lsdc0_sq_ex2_chk_ld_bypass_vld,               
input logic                                         lsdc1_sq_ex2_chk_ld_bypass_vld,
input logic                                         ldc0_ex2_chk_ld_inst_vld,   //1->3 for 3 ld, LTL@20241021
input logic                                         lsdc0_ex2_chk_ld_inst_vld,
input logic                                         lsdc1_ex2_chk_ld_inst_vld,
input logic   [IID_WIDTH-1:0]                       ldc0_ex2_iid,  //1->3 for 3 ld, LTL@20241021
input logic   [IID_WIDTH-1:0]                       lsdc0_ex2_ld_iid,//logic levels opt@LTL
input logic   [IID_WIDTH-1:0]                       lsdc1_ex2_ld_iid,//logic levels opt@LTL
input logic   [IID_WIDTH-1:0]                       lsdc0_ex2_st_iid,//logic levels opt@LTL
input logic   [IID_WIDTH-1:0]                       lsdc1_ex2_st_iid,//logic levels opt@LTL
input logic                                         pad_yy_icg_scan_en,                      
input logic                                         rtu_lsu_async_flush,                     
input logic   [IID_WIDTH-1:0]                       rtu_lsu_commit0_iid_updt_val,  //3->8, LTL@20241021
input logic   [IID_WIDTH-1:0]                       rtu_lsu_commit1_iid_updt_val,            
input logic   [IID_WIDTH-1:0]                       rtu_lsu_commit2_iid_updt_val,
input logic   [IID_WIDTH-1:0]                       rtu_lsu_commit3_iid_updt_val,          
input logic   [IID_WIDTH-1:0]                       rtu_lsu_commit4_iid_updt_val,          
input logic   [IID_WIDTH-1:0]                       rtu_lsu_commit5_iid_updt_val,
input logic   [IID_WIDTH-1:0]                       rtu_lsu_commit6_iid_updt_val,          
input logic   [IID_WIDTH-1:0]                       rtu_lsu_commit7_iid_updt_val,                   
input logic                                         rtu_yy_xx_commit0,  //3->8, LTL@20241021           
input logic                                         rtu_yy_xx_commit1,                       
input logic                                         rtu_yy_xx_commit2,                     
input logic                                         rtu_yy_xx_commit3,                     
input logic                                         rtu_yy_xx_commit4,                     
input logic                                         rtu_yy_xx_commit5,
input logic                                         rtu_yy_xx_commit6,                     
input logic                                         rtu_yy_xx_commit7,   
input logic                                         rtu_yy_xx_flush,                         
input logic                                         std0_ex1_inst_vld,  //1->2  LTL@20241016
input logic                                         std1_ex1_inst_vld,                          
input logic   [SDID_LEN-1:0]                        std0_rf_sdid,//1->2  LTL@20241016
input logic   [SDID_LEN-1:0]                        std1_rf_sdid,
input logic                                         std0_sq_rf_inst_vld_short,//1->2  LTL@20241016
input logic                                         std1_sq_rf_inst_vld_short,
input logic                                         sq_age_vec_set,                          
input logic   [SQ_ENTRY-1:0]                        sq_create_age_vec0,  //1->2  LTL@20241016
input logic   [SQ_ENTRY-1:0]                        sq_create_age_vec1,                         
input logic                                         sq_create_pop_clk,                       
input logic                                         sq_create_same_addr_newest0,  //1->2  LTL@20241016
input logic                                         sq_create_same_addr_newest1,             
input logic                                         sq_create_success0,  //1->2  LTL@20241016
input logic                                         sq_create_success1,                        
input logic   [SQ_ENTRY-1:0]                        sq_create_vld0,      //1->2  LTL@20241016
input logic   [SQ_ENTRY-1:0]                        sq_create_vld1,                            
input logic   [127:0]                               sq_data_settle0,   //1->2  LTL@20241016
input logic   [127:0]                               sq_data_settle1,                          
input logic                                         sq_entry_create_dp_vld0_x, //1->2  LTL@20241016
input logic                                         sq_entry_create_dp_vld1_x,                 
input logic                                         sq_entry_create_gateclk_en0_x,  //1->2  LTL@20241016
input logic                                         sq_entry_create_gateclk_en1_x,            
input logic                                         sq_entry_create_vld0_x,  //1->2  LTL@20241016
input logic                                         sq_entry_create_vld1_x,                   
input logic                                         sq_entry_data_discard_grnt0_x,//1->3  for 3 ld, LTL@20241016
input logic                                         sq_entry_data_discard_grnt1_x,
input logic                                         sq_entry_data_discard_grnt2_x,            
input logic                                         sq_entry_fwd_multi_depd_set0_x, //1->4  for 3 ld, LTL@20241016
input logic                                         sq_entry_fwd_multi_depd_set1_x,
input logic                                         sq_entry_fwd_multi_depd_set2_x,           
input logic   [SQ_ENTRY-1:0]                        sq_entry_pop_to_ce_grnt_b,               
input logic                                         sq_entry_pop_to_ce_grnt_x,               
input logic                                         sq_pop_ptr_x,                       
input logic   [IID_WIDTH-1:0]                       lsda0_ex3_iid,//1->2  for 2 ls, LTL@20241016
input logic   [IID_WIDTH-1:0]                       lsda1_ex3_iid,
input logic                                         lsda0_ex3_inst_vld,
input logic                                         lsda1_ex3_inst_vld, 
input logic                                         lsda0_sq_ex3_secd,
input logic                                         lsda1_sq_ex3_secd,
input logic                                         lsda0_sq_ex3_dcache_dirty,
input logic                                         lsda1_sq_ex3_dcache_dirty,
input logic                                         lsda0_sq_ex3_dcache_page_share,
input logic                                         lsda1_sq_ex3_dcache_page_share,
input logic                                         lsda0_sq_ex3_dcache_share,
input logic                                         lsda1_sq_ex3_dcache_share,
input logic                                         lsda0_sq_ex3_dcache_valid,
input logic                                         lsda1_sq_ex3_dcache_valid,
input logic   [1  :0]                               lsda0_sq_ex3_dcache_way,  //1->2bit, L1D2->4way,  LTL@20250323 
input logic   [1  :0]                               lsda1_sq_ex3_dcache_way,  //1->2bit, L1D2->4way,  LTL@20250323 
input logic                                         lsda0_sq_ex3_ecc_stall,
input logic                                         lsda1_sq_ex3_ecc_stall,
input logic                                         lsda0_sq_ex3_expt_vld,
input logic                                         lsda1_sq_ex3_expt_vld, 
input logic                                         lsda0_sq_ex3_lm_fail,
input logic                                         lsda1_sq_ex3_lm_fail,
input logic                                         lsda0_sq_ex3_no_restart,
input logic                                         lsda1_sq_ex3_no_restart,
input logic                                         lsda0_ex3_spec_fail,
input logic                                         lsda1_ex3_spec_fail,
input logic                                         lsda0_ex3_vstart_vld,
input logic                                         lsda1_ex3_vstart_vld,
input logic                                         lsdc0_ex2_atomic,                            
input logic                                         lsdc0_ex2_boundary,                          
input logic                                         lsdc0_sq_ex2_boundary_first,                                           
input logic                                         lsdc0_sq_ex2_cmit0_iid_crt_hit,                 
input logic                                         lsdc0_sq_ex2_cmit1_iid_crt_hit,                 
input logic                                         lsdc0_sq_ex2_cmit2_iid_crt_hit,
input logic                                         lsdc0_sq_ex2_cmit3_iid_crt_hit,                 
input logic                                         lsdc0_sq_ex2_cmit4_iid_crt_hit,                 
input logic                                         lsdc0_sq_ex2_cmit5_iid_crt_hit,
input logic                                         lsdc0_sq_ex2_cmit6_iid_crt_hit,                 
input logic                                         lsdc0_sq_ex2_cmit7_iid_crt_hit,                                
input logic                                         lsdc0_ex2_page_buf,                       
input logic                                         lsdc0_ex2_page_ca,                        
input logic                                         lsdc0_ex2_page_sec,                       
input logic                                         lsdc0_ex2_page_share,                     
input logic                                         lsdc0_ex2_page_so,                        
input logic                                         lsdc0_ex2_page_wa,                        
input logic                                         lsdc0_sq_ex2_dtcm_hit,                          
input logic   [1  :0]                               lsdc0_sq_ex2_element_size,                      
input logic   [3  :0]                               lsdc0_ex2_fence_mode,                        
input logic                                         lsdc0_ex2_icc,                               
input logic   [PREG-1:0]                            lsdc0_ex2_preg,
input logic                                         lsdc0_sq_ex2_idx_order,                                                      
input logic                                         lsdc0_sq_ex2_inst_flush,                        
input logic   [1  :0]                               lsdc0_ex2_inst_mode,                         
input logic   [2  :0]                               lsdc0_ex2_inst_size,                         
input logic   [1  :0]                               lsdc0_ex2_inst_type,                         
input logic                                         lsdc0_ex2_inst_vls,                          
input logic                                         lsdc0_sq_ex2_itcm_hit,                          
input logic   [15 :0]                               lsdc0_sq_ex2_rot_sel_rev,                       
input logic   [SDID_LEN-1:0]                        lsdc0_sq_ex2_sdid,                              
input logic                                         lsdc0_sq_ex2_sdid_hit0,  //1->2 , LTL@20241123
input logic                                         lsdc0_sq_ex2_sdid_hit1,                         
input logic                                         lsdc0_ex2_st_secd,//logic levels opt@LTL                              
input logic                                         lsdc0_sq_ex2_data_vld,                       
input logic                                         lsdc0_ex2_sync_fence,                        
//input logic   [1  :0]                               lsdc0_sq_ex2_vsew,  //rvv1.0@hcl   
input logic   [1  :0]  lsdc0_sq_ex2_vmew,  //rvv1.0@hcl
input logic   [1  :0]  lsdc0_sq_ex2_vmop,  //rvv1.0@hcl                         
input logic                                         lsdc0_sq_ex2_wo_st_inst,
input logic                                         lsdc0_ex2_dcache_hit, 
input logic   [1  :0]                               lsdc0_ex2_ssp_va,
input logic   [PC_LEN-1:0]                          lsdc0_ex2_pc,
input logic                                         lsdc1_ex2_atomic,                            
input logic                                         lsdc1_ex2_boundary,                          
input logic                                         lsdc1_sq_ex2_boundary_first,                                           
input logic                                         lsdc1_sq_ex2_cmit0_iid_crt_hit,                 
input logic                                         lsdc1_sq_ex2_cmit1_iid_crt_hit,                 
input logic                                         lsdc1_sq_ex2_cmit2_iid_crt_hit,
input logic                                         lsdc1_sq_ex2_cmit3_iid_crt_hit,                 
input logic                                         lsdc1_sq_ex2_cmit4_iid_crt_hit,                 
input logic                                         lsdc1_sq_ex2_cmit5_iid_crt_hit,
input logic                                         lsdc1_sq_ex2_cmit6_iid_crt_hit,                 
input logic                                         lsdc1_sq_ex2_cmit7_iid_crt_hit,                  
input logic                                         lsdc1_ex2_page_buf,                       
input logic                                         lsdc1_ex2_page_ca,                        
input logic                                         lsdc1_ex2_page_sec,                       
input logic                                         lsdc1_ex2_page_share,                     
input logic                                         lsdc1_ex2_page_so,                        
input logic                                         lsdc1_ex2_page_wa,                        
input logic                                         lsdc1_sq_ex2_dtcm_hit,                          
input logic   [1  :0]                               lsdc1_sq_ex2_element_size,                      
input logic   [3  :0]                               lsdc1_ex2_fence_mode,                        
input logic                                         lsdc1_ex2_icc,                               
input logic   [PREG-1:0]                            lsdc1_ex2_preg,
input logic                                         lsdc1_sq_ex2_idx_order,                             
input logic                                         lsdc1_sq_ex2_inst_flush,                        
input logic   [1  :0]                               lsdc1_ex2_inst_mode,                         
input logic   [2  :0]                               lsdc1_ex2_inst_size,                         
input logic   [1  :0]                               lsdc1_ex2_inst_type,                         
input logic                                         lsdc1_ex2_inst_vls,                          
input logic                                         lsdc1_sq_ex2_itcm_hit,                          
input logic   [15 :0]                               lsdc1_sq_ex2_rot_sel_rev,                       
input logic   [SDID_LEN-1:0]                        lsdc1_sq_ex2_sdid,                              
input logic                                         lsdc1_sq_ex2_sdid_hit0,
input logic                                         lsdc1_sq_ex2_sdid_hit1,                          
input logic                                         lsdc1_ex2_st_secd, //logic levels opt@LTL                             
input logic                                         lsdc1_sq_ex2_data_vld,                       
input logic                                         lsdc1_ex2_sync_fence,                        
//input logic   [1  :0]                               lsdc1_sq_ex2_vsew,   //rvv1.0@hcl 
input logic   [1  :0]  lsdc1_sq_ex2_vmew,   //rvv1.0@hcl
input logic   [1  :0]  lsdc1_sq_ex2_vmop,   //rvv1.0@hcl                          
input logic                                         lsdc1_sq_ex2_wo_st_inst,
input logic                                         lsdc1_ex2_dcache_hit, 
input logic   [1  :0]                               lsdc1_ex2_ssp_va,
input logic   [PC_LEN-1:0]                          lsdc1_ex2_pc,
input logic                                         wmb_sq_pop_grnt,
input logic   [SQ_ENTRY-1:0]                        sq_entry_already_st_stride_vec,
input logic   [SQ_ENTRY-1:0]                        sq_entry_fwd_bypass_req0_vec,
input logic   [SQ_ENTRY-1:0]                        sq_entry_fwd_bypass_req1_vec,
input logic   [SQ_ENTRY-1:0]                        sq_entry_fwd_bypass_req2_vec,
input logic   [SQ_ENTRY-1:0]                        sq_entry_same_addr_older_than_ldc0_vec,
input logic   [SQ_ENTRY-1:0]                        sq_entry_same_addr_older_than_lsdc0_vec,
input logic   [SQ_ENTRY-1:0]                        sq_entry_same_addr_older_than_lsdc1_vec,                         
output logic  [`WK_PA_WIDTH-1 :0]                   sq_entry_addr0_v,                        
output logic                                        sq_entry_addr1_dep_discard0_x,  //1->3  LTL@20241016
output logic                                        sq_entry_addr1_dep_discard1_x,
output logic                                        sq_entry_addr1_dep_discard2_x,        
output logic                                        sq_entry_age_vec_surplus1_ptr_x,         
output logic                                        sq_entry_age_vec_zero_ptr_x,             
output logic                                        sq_entry_atomic_x,                                        
output logic  [15 :0]                               sq_entry_bytes_vld_v,                    
output logic                                        sq_entry_cancel_acc_req0_x, //1->3  LTL@20241016 
output logic                                        sq_entry_cancel_acc_req1_x,
output logic                                        sq_entry_cancel_acc_req2_x,               
output logic                                        sq_entry_cancel_ahead_wb0_x,  //1->3  LTL@20241016
output logic                                        sq_entry_cancel_ahead_wb1_x,
output logic                                        sq_entry_cancel_ahead_wb2_x,            
output logic                                        sq_entry_cmit_data_vld_x,                
output logic                                        sq_entry_cmit_x,                         
output logic  [LSIQ_ENTRY-1:0]                      sq_entry_data_depd_wakeup0_v,
output logic  [LSIQ_ENTRY-1:0]                      sq_entry_data_depd_wakeup1_v,
output logic  [LSIQ_ENTRY-1:0]                      sq_entry_data_depd_wakeup2_v,          
output logic                                        sq_entry_data_discard_req_short0_x,  //1->3  LTL@20241016
output logic                                        sq_entry_data_discard_req_short1_x,
output logic                                        sq_entry_data_discard_req_short2_x,    
output logic                                        sq_entry_data_discard_req0_x,   //1->3  LTL@20241016
output logic                                        sq_entry_data_discard_req1_x, 
output logic                                        sq_entry_data_discard_req2_x,            
output logic  [127:0]                               sq_entry_data_v,                         
output logic                                        sq_entry_dcache_dirty_x,                 
output logic                                        sq_entry_dcache_info_vld_x,              
output logic                                        sq_entry_dcache_page_share_x,            
output logic                                        sq_entry_dcache_share_x,                 
output logic                                        sq_entry_dcache_valid_x,                 
output logic  [1  :0]                               sq_entry_dcache_way_x,                   
output logic                                        sq_entry_depd_set_x,                     
output logic                                        sq_entry_depd_x,                         
output logic                                        sq_entry_discard_req0_x, //1->3  LTL@20241016
output logic                                        sq_entry_discard_req1_x, 
output logic                                        sq_entry_discard_req2_x,                  
output logic                                        sq_entry_dtcm_hit_x,                     
output logic  [1  :0]                               sq_entry_element_size_v,    
output logic                                        sq_entry_expt_nop_x,                     
output logic  [3  :0]                               sq_entry_fence_mode_v,                   
output logic                                        sq_entry_fwd_bypass_req0_x,//1->3  , 1->2 bit for recognizing std0 and std 1, LTL@20241016
output logic                                        sq_entry_fwd_bypass_req1_x,
output logic                                        sq_entry_fwd_bypass_req2_x,
output logic                                        sq_entry_fwd_bypass_req_sel_0_x,//1->3  , 1->2 bit for recognizing std0 and std 1, LTL@20241016
output logic                                        sq_entry_fwd_bypass_req_sel_1_x,
output logic                                        sq_entry_fwd_bypass_req_sel_2_x,
output logic                                        sq_entry_fwd_bypass_req0_newer_x,
output logic                                        sq_entry_fwd_bypass_req1_newer_x,
output logic                                        sq_entry_fwd_bypass_req2_newer_x,
output logic                                        sq_entry_fwd_req0_x,   //1->3  LTL@20241016
output logic                                        sq_entry_fwd_req1_x,
output logic                                        sq_entry_fwd_req2_x,
output logic                                        sq_entry_older_than_ldc0_same_addr_newest,
output logic                                        sq_entry_older_than_lsdc0_same_addr_newest,
output logic                                        sq_entry_older_than_lsdc1_same_addr_newest,                    
output logic                                        sq_entry_icc_x,                          
output logic  [PREG-1:0]                            sq_entry_preg_v,
output logic                                        sq_entry_idx_order_x,                    
output logic  [IID_WIDTH-1:0]                       sq_entry_iid_v,                          
output logic                                        sq_entry_inst_flush_x,                   
output logic                                        sq_entry_inst_hit0_x,   //1->2  LTL@20241016
output logic                                        sq_entry_inst_hit1_x,                     
output logic  [1  :0]                               sq_entry_inst_mode_v,                    
output logic  [2  :0]                               sq_entry_inst_size_v,                    
output logic  [1  :0]                               sq_entry_inst_type_v,                    
output logic                                        sq_entry_inst_vls_x,           
output logic                                        sq_entry_itcm_hit_x,                     
output logic                                        sq_entry_lm_fail_x,                      
output logic                                        sq_entry_newest_fwd_req_data_vld_short0_x,  //1->3  LTL@20241016
output logic                                        sq_entry_newest_fwd_req_data_vld_short1_x, 
output logic                                        sq_entry_newest_fwd_req_data_vld_short2_x,
output logic                                        sq_entry_newest_fwd_req_data_vld0_x,   //1->3  LTL@20241016
output logic                                        sq_entry_newest_fwd_req_data_vld1_x,
output logic                                        sq_entry_newest_fwd_req_data_vld2_x,      
output logic                                        sq_entry_page_buf_x,                     
output logic                                        sq_entry_page_ca_x,                      
output logic                                        sq_entry_page_sec_x,                     
output logic                                        sq_entry_page_share_x,                   
output logic                                        sq_entry_page_so_x,                      
output logic                                        sq_entry_page_wa_x,                      
output logic                                        sq_entry_pop_req_x,                      
output logic  [1  :0]                               sq_entry_priv_mode_v,                    
output logic  [15 :0]                               sq_entry_rot_sel_v,        //no need 1->2  LTL@20241016              
output logic                                        sq_entry_same_addr_newest_x,             
output logic                                        sq_entry_settle_data_hit0_x,  //1->2  LTL@20241016
output logic                                        sq_entry_settle_data_hit1_x,              
output logic                                        sq_entry_spec_fail_x,                    
output logic                                        sq_entry_lsdc0_create_age_vec_x,  //1->2 for 2 lsdc, LTL@20241017
output logic                                        sq_entry_lsdc1_create_age_vec_x,         
output logic                                        sq_entry_lsdc0_same_addr_newer_x, 
output logic                                        sq_entry_lsdc1_same_addr_newer_x,        
output logic                                        sq_entry_ldc0_same_addr_older_x, 
output logic                                        sq_entry_lsdc0_same_addr_older_x,
output logic                                        sq_entry_lsdc1_same_addr_older_x,        
output logic                                        sq_entry_sync_fence_x,                   
output logic                                        sq_entry_vld_x,                          
//output logic  [1  :0]                               sq_entry_vsew_v,    //no need 1->2 for 2 st_data, LTL@20241021   //rvv1.0@hcl 
output logic  [1  :0]  sq_entry_vmew_v, //rvv1.0@hcl
output logic  [1  :0]  sq_entry_vmop_v, //rvv1.0@hcl
output logic                                        sq_entry_vstart_vld_x,                   
output logic                                        sq_entry_wo_st_x,
output logic                                        sq_entry_init_dcache_miss_x,
output logic  [1  :0]                               sq_entry_ssp_va_x,
output logic  [PC_LEN-1:0]                          sq_entry_pc_index_x,
output logic                                        sq_entry_already_send_st_stride_x, 
output logic                                        sq_entry_st_stride_age_vec_zero_ptr_x,
//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
input  logic  [`TDT_MP_HINFO_WIDTH-1:0]             dtu_lsu_addr_halt_info0,
input  logic  [`TDT_MP_HINFO_WIDTH-1:0]             dtu_lsu_addr_halt_info1,
input  logic  [`TDT_MP_HINFO_WIDTH-1:0]             dtu_lsu_data_halt_info0,
input  logic  [`TDT_MP_HINFO_WIDTH-1:0]             dtu_lsu_data_halt_info1,
input  logic                                        lsda0_st_da_wb_expt_vld_cancel,
input  logic                                        lsda1_st_da_wb_expt_vld_cancel,
input  logic                                        sq_entry_data_halt_info_update_vld_0,
input  logic                                        sq_entry_data_halt_info_update_vld_1,
input  logic                                        sq_entry_wake_data_grnt_0_x,
input  logic                                        sq_entry_wake_data_grnt_1_x,
input  logic                                        st_da_already_da_0,
input  logic                                        st_da_already_da_1,
input  logic                                        st_da_data_check_0,
input  logic                                        st_da_data_check_1,
output logic                                        sq_entry_data_check_0_x,
output logic                                        sq_entry_data_check_1_x,
output logic  [16 :0]                               sq_entry_halt_info_0_v,
output logic  [16 :0]                               sq_entry_halt_info_1_v,
output logic                                        sq_entry_wake_data_req_0_x,
output logic                                        sq_entry_wake_data_req_1_x
//==========================================================
//                  Risc-V Debug zdb End 
//==========================================================
);

                   

// &Regs; @31
logic     [`WK_PA_WIDTH-1 :0]                       sq_entry_addr0;                          
logic     [SQ_ENTRY-1:0]                            sq_entry_age_vec;          //parameterize LTL@20241021         
logic     [SQ_ENTRY-1:0]                            sq_entry_age_vec_1;                      
logic                                               sq_entry_atomic;                                             
logic                                               sq_entry_bond_first_only;                
logic                                               sq_entry_boundary;                       
logic     [15 :0]                                   sq_entry_bytes_vld;                      
logic                                               sq_entry_cmit;                           
logic                                               sq_entry_cmit0_iid_hit;                  
logic                                               sq_entry_cmit1_iid_hit;                  
logic                                               sq_entry_cmit2_iid_hit;
logic                                               sq_entry_cmit3_iid_hit; //3->8  LTL@20241016                 
logic                                               sq_entry_cmit4_iid_hit;                  
logic                                               sq_entry_cmit5_iid_hit; 
logic                                               sq_entry_cmit6_iid_hit;                  
logic                                               sq_entry_cmit7_iid_hit;                  
logic     [127:0]                                   sq_entry_data;                           
logic                                               sq_entry_data_set_ff;                    
logic                                               sq_entry_data_vld;                       
logic                                               sq_entry_dcache_dirty;                   
logic                                               sq_entry_dcache_info_vld;                
logic                                               sq_entry_dcache_page_share;              
logic                                               sq_entry_dcache_share;                   
logic                                               sq_entry_dcache_valid;                   
logic     [1  :0]                                   sq_entry_dcache_way;    //1->2, L1D2->4way,  LTL@20250323                  
logic                                               sq_entry_depd;                           
logic                                               sq_entry_dtcm_hit;                       
logic     [1  :0]                                   sq_entry_element_size;                
logic                                               sq_entry_expt_nop;                       
logic     [3  :0]                                   sq_entry_fence_mode;                     
logic                                               sq_entry_icc;                            
logic     [PREG-1:0]                                sq_entry_preg;
logic                                               sq_entry_idx_order;                      
logic     [IID_WIDTH-1:0]                           sq_entry_iid;                            
logic                                               sq_entry_in_wmb_ce;                      
logic                                               sq_entry_inst_flush;                     
logic     [1  :0]                                   sq_entry_inst_mode;                      
logic     [2  :0]                                   sq_entry_inst_size;                      
logic     [1  :0]                                   sq_entry_inst_type;                      
logic                                               sq_entry_inst_vls;  //1->2 for 2 st_data is wrong, entry attr no need 1->2, LTL@20241017                
logic                                               sq_entry_itcm_hit;                       
logic                                               sq_entry_lm_fail;                        
logic                                               sq_entry_no_restart;   //sq entry attr, no need 1->2, LTL@20241017                    
logic                                               sq_entry_page_buf;                       
logic                                               sq_entry_page_ca;                        
logic                                               sq_entry_page_sec;                       
logic                                               sq_entry_page_share;                     
logic                                               sq_entry_page_so;                        
logic                                               sq_entry_page_wa;                        
logic     [1  :0]                                   sq_entry_priv_mode;                      
logic     [15 :0]                                   sq_entry_rot_sel;  //no need 1->2, for 2 st_data, LTL@20241112                
logic                                               sq_entry_same_addr_newest;               
logic     [SDID_LEN:0]                              sq_entry_sdid;                           
logic                                               sq_entry_secd;                           
logic                                               sq_entry_spec_fail;                      
logic                                               sq_entry_st_data0_sdid_hit;  //1->2, for 2 st_data, LTL@20241017
logic                                               sq_entry_st_data1_sdid_hit;               
logic                                               sq_entry_sync_fence;                     
logic                                               sq_entry_vld;                            
//logic     [1  :0]                                   sq_entry_vsew;  //no need 1->2, for 2 st_data, LTL@20241112 //rvv1.0@hcl
logic     [1  :0]  sq_entry_vmew;//rvv1.0@hcl
logic     [1  :0]  sq_entry_vmop;//rvv1.0@hcl
logic                                               sq_entry_vstart_vld;                     
logic     [LSIQ_ENTRY-1:0]                          sq_entry_wakeup_queue0;//1->3, for 3 ld, LTL@20241024
logic     [LSIQ_ENTRY-1:0]                          sq_entry_wakeup_queue1;
logic     [LSIQ_ENTRY-1:0]                          sq_entry_wakeup_queue2;                   
logic                                               sq_entry_wo_st;
logic                                               sq_entry_init_dcache_miss;                          
logic     [1  :0]                                   sq_entry_ssp_va;
logic  [PC_LEN-1:0]                                 sq_entry_pc_index;
logic                                               sq_entry_already_send_st_stride;
logic                                               sq_entry_rdy_send_st_stride;
logic                                               sq_entry_already_send_st_stride_set;
logic                                               sq_entry_st_stride_age_vec_zero;
logic                                               sq_entry_st_stride_age_vec_zero_ptr;
// &Wires; @32
logic                                               rtu_ck_flush_iid_older_than_entry;
logic                                               sq_entry_data_depd_wakeup_vld_with_flush;
logic                                               sq_bond_secd_create_vld0;  //1->2, for 2 lsdc, LTL@20241017
logic                                               sq_bond_secd_create_vld1;                                                  
logic                                               sq_entry_addr1_dep_discard0;  //1->3, for 3 ld dc, LTL@20241017
logic                                               sq_entry_addr1_dep_discard1;
logic                                               sq_entry_addr1_dep_discard2;
logic                                               sq_entry_addr_tto4_hit_ldc0;   //1->3, for 2 lsdc, LTL@20251010                
logic                                               sq_entry_addr_tto4_hit_lsdc0;  
logic                                               sq_entry_addr_tto4_hit_lsdc1;           
logic                                               sq_entry_addr_tto4_hit_lsdc0_st;//timing@LTL
logic                                               sq_entry_addr_tto4_hit_lsdc1_st;//timing@LTL
logic   [SQ_ENTRY-1:0]                              sq_entry_age_vec_create;                 
logic                                               sq_entry_age_vec_less2;                  
logic   [SQ_ENTRY-1:0]                              sq_entry_age_vec_next;                   
logic                                               sq_entry_age_vec_surplus1_ptr;                
logic                                               sq_entry_age_vec_zero;                   
logic                                               sq_entry_age_vec_zero_ptr;                
logic                                               sq_entry_and_ldc0_bytes_vld1_hit; 
logic                                               sq_entry_and_lsdc0_bytes_vld1_hit; 
logic                                               sq_entry_and_lsdc1_bytes_vld1_hit;       
logic                                               sq_entry_and_ldc0_bytes_vld_hit;
logic                                               sq_entry_and_lsdc0_bytes_vld_hit;
logic                                               sq_entry_and_lsdc1_bytes_vld_hit;                       
logic                                               sq_entry_cancel_acc_req0;   //1->3, for 3 ld_dc, LTL@20241017
logic                                               sq_entry_cancel_acc_req1;
logic                                               sq_entry_cancel_acc_req2;                 
logic                                               sq_entry_cancel_ahead_wb0;  //1->3, for 3 ld_dc, LTL@20241017
logic                                               sq_entry_cancel_ahead_wb1;
logic                                               sq_entry_cancel_ahead_wb2;             
logic                                               sq_entry_clk;                            
logic                                               sq_entry_clk_en;                         
logic                                               sq_entry_cmit0_iid_pre_hit;              
logic                                               sq_entry_cmit1_iid_pre_hit;              
logic                                               sq_entry_cmit2_iid_pre_hit;
logic                                               sq_entry_cmit3_iid_pre_hit;              
logic                                               sq_entry_cmit4_iid_pre_hit;              
logic                                               sq_entry_cmit5_iid_pre_hit;
logic                                               sq_entry_cmit6_iid_pre_hit;              
logic                                               sq_entry_cmit7_iid_pre_hit;                
logic                                               sq_entry_cmit_data_not_vld;              
logic                                               sq_entry_cmit_data_vld;                        
logic                                               sq_entry_cmit_hit0;                      
logic                                               sq_entry_cmit_hit1;                      
logic                                               sq_entry_cmit_hit2;
logic                                               sq_entry_cmit_hit3;                      
logic                                               sq_entry_cmit_hit4;                      
logic                                               sq_entry_cmit_hit5;
logic                                               sq_entry_cmit_hit6;                      
logic                                               sq_entry_cmit_hit7;                                  
logic                                               sq_entry_cmit_set;                                     
logic                                               sq_entry_create_clk;                     
logic                                               sq_entry_create_clk_en;                  
logic                                               sq_entry_create_da_clk;                  
logic                                               sq_entry_create_da_clk_en;
logic                                               sq_entry_create_dp_vld0;  //1->2  LTL@20241016
logic                                               sq_entry_create_dp_vld1;                    
logic                                               sq_entry_create_gateclk_en0; //1->2  LTL@20241016
logic                                               sq_entry_create_gateclk_en1;              
logic                                               sq_entry_create_vld0;   //1->2  LTL@20241016
logic                                               sq_entry_create_vld1;                              
logic                                               sq_entry_data_clk;                       
logic                                               sq_entry_data_clk_en;              
logic   [LSIQ_ENTRY-1:0]                            sq_entry_data_depd_wakeup0;//1->3 for 3 ld dc, LTL@20241017 
logic   [LSIQ_ENTRY-1:0]                            sq_entry_data_depd_wakeup1;
logic   [LSIQ_ENTRY-1:0]                            sq_entry_data_depd_wakeup2;           
logic                                               sq_entry_data_depd_wakeup_vld;           
logic                                               sq_entry_data_discard_grnt;
logic                                               sq_entry_data_discard_grnt0;  //1->3 for 3 ld dc input, LTL@20241024
logic                                               sq_entry_data_discard_grnt1;
logic                                               sq_entry_data_discard_grnt2;                
logic                                               sq_entry_data_discard_req0;   //1->3 for 3 ld dc, LTL@20241017  
logic                                               sq_entry_data_discard_req1;
logic                                               sq_entry_data_discard_req2;               
logic                                               sq_entry_data_discard_req_short0;  //1->3 for 3 ld dc, LTL@20241017  
logic                                               sq_entry_data_discard_req_short1;
logic                                               sq_entry_data_discard_req_short2;
logic                                               sq_entry_data_set;      //merge 0-1
logic                                               sq_entry_data_set0;     //0-1 from sq  LTL@20241017
logic                                               sq_entry_data_set1;                                  
logic                                               sq_entry_data_vld_now;                         
logic                                               sq_entry_dcache_hit_idx;                  
logic                                               sq_entry_dcache_inst;                        
logic                                               sq_entry_dcache_sw_inst;                 
logic                                               sq_entry_dcache_update_vld;              
logic                                               sq_entry_dcache_update_vld_unmask;                              
logic                                               sq_entry_depd_addr0_11to4_hit0;  //1->3  LTL@20241017           
logic                                               sq_entry_depd_addr0_11to4_hit1;
logic                                               sq_entry_depd_addr0_11to4_hit2;
logic                                               sq_entry_depd_addr1_11to4_hit0;  //1->3  LTL@20241017  
logic                                               sq_entry_depd_addr1_11to4_hit1;
logic                                               sq_entry_depd_addr1_11to4_hit2;           
logic                                               sq_entry_depd_addr1_tto4_hit0; //1->3  LTL@20241017 
logic                                               sq_entry_depd_addr1_tto4_hit1;
logic                                               sq_entry_depd_addr1_tto4_hit2;
logic                                               sq_entry_depd_addr_tto12_hit0;//1->3  LTL@20241017 
logic                                               sq_entry_depd_addr_tto12_hit1;
logic                                               sq_entry_depd_addr_tto12_hit2;
logic                                               sq_entry_depd_addr_tto4_hit0;//1->3  LTL@20241017 
logic                                               sq_entry_depd_addr_tto4_hit1;
logic                                               sq_entry_depd_addr_tto4_hit2;
logic                                               sq_entry_depd_addr_tto6_hit0;//rvv512@LTL 
logic                                               sq_entry_depd_addr_tto6_hit1;
logic                                               sq_entry_depd_addr_tto6_hit2;
logic                                               sq_entry_depd_bv1_do_hit0;  //1->3 for 3 ld dc, LTL@20241017 
logic                                               sq_entry_depd_bv1_do_hit1;                
logic                                               sq_entry_depd_bv1_do_hit2;
logic                                               sq_entry_depd_do_hit0;  //1->3 for 3 ld dc, LTL@20241017 
logic                                               sq_entry_depd_do_hit1;
logic                                               sq_entry_depd_do_hit2;
logic                                               sq_entry_depd_exawk_hit0;  //1->3 for 4 lsdc, LTL@20241017  
logic                                               sq_entry_depd_exawk_hit1; 
logic                                               sq_entry_depd_exawk_hit2;                 
logic                                               sq_entry_depd_hit0_0;  //rvv512@LTL                    
logic                                               sq_entry_depd_hit0_1;                      
logic                                               sq_entry_depd_hit0_2;
logic                                               sq_entry_depd_hit1_0;                      
logic                                               sq_entry_depd_hit2_0;                      
logic                                               sq_entry_depd_hit3_0;                      
logic                                               sq_entry_depd_hit4_0;                      
logic                                               sq_entry_depd_hit5_0;
logic                                               sq_entry_depd_hit5_0_0;  //use to recognize std0 or std1, LTL@20241024
logic                                               sq_entry_depd_hit5_0_1;                      
logic                                               sq_entry_depd_hit6_0;                      
logic                                               sq_entry_depd_hit7_0; 
logic                                               sq_entry_depd_hit1_1;                      
logic                                               sq_entry_depd_hit2_1;                      
logic                                               sq_entry_depd_hit3_1;                      
logic                                               sq_entry_depd_hit4_1;                      
logic                                               sq_entry_depd_hit5_1;
logic                                               sq_entry_depd_hit5_1_0;  //use to recognize std0 or std1, LTL@20241024
logic                                               sq_entry_depd_hit5_1_1;                          
logic                                               sq_entry_depd_hit6_1;                      
logic                                               sq_entry_depd_hit7_1;
logic                                               sq_entry_depd_hit1_2;                      
logic                                               sq_entry_depd_hit2_2;                      
logic                                               sq_entry_depd_hit3_2;                      
logic                                               sq_entry_depd_hit4_2;                      
logic                                               sq_entry_depd_hit5_2;
logic                                               sq_entry_depd_hit5_2_0;  //use to recognize std0 or std1, LTL@20241024
logic                                               sq_entry_depd_hit5_2_1;                          
logic                                               sq_entry_depd_hit6_2;                      
logic                                               sq_entry_depd_hit7_2;                  
logic                                               sq_entry_depd_hit8_0;   //1->3 for 3ld  dc, LTL@20241024
logic                                               sq_entry_depd_hit8_1;
logic                                               sq_entry_depd_hit8_2;                   
logic                                               sq_entry_depd_part_hit0;   //1->3 for 3 ld_dc, LTL
logic                                               sq_entry_depd_part_hit1;
logic                                               sq_entry_depd_part_hit2;
logic                                               sq_entry_depd_set;  //split 3 cond, LTL@20241017                
logic                                               sq_entry_depd_set0;  //1->3 for 3ld_dc, LTL
logic                                               sq_entry_depd_set1;
logic                                               sq_entry_depd_set2;                          
logic                                               sq_entry_depd_whole_hit0;   //1->3 for 3 ld_dc, LTL
logic                                               sq_entry_depd_whole_hit1;
logic                                               sq_entry_depd_whole_hit2;              
logic                                               sq_entry_discard_req0;   //1->3 for 3ld  dc, LTL
logic                                               sq_entry_discard_req1;
logic                                               sq_entry_discard_req2;                                
logic                                               sq_entry_expt_pop_vld;                         
logic                                               sq_entry_flush_pop_vld;                  
logic   [`WK_PA_WIDTH-1 :0]                         sq_entry_from_ldc0_ex2_addr0;  //1->3 for 3ld_dc, LTL
logic   [`WK_PA_WIDTH-1 :0]                         sq_entry_from_lsdc0_ex2_addr0;
logic   [`WK_PA_WIDTH-1 :0]                         sq_entry_from_lsdc1_ex2_addr0;               
logic                                               sq_entry_fwd_bypass_req0;   //1->3 for 3ld dc, 1->2 bit for recognize std0 and std1, LTL@20241024
logic                                               sq_entry_fwd_bypass_req1;
logic                                               sq_entry_fwd_bypass_req2;
logic                                               sq_entry_fwd_bypass_req_sel_0;   //1->3 for 3ld_dc, 1->2 bit for recognize std0 and std1, LTL@20241024
logic                                               sq_entry_fwd_bypass_req_sel_1;
logic                                               sq_entry_fwd_bypass_req_sel_2;
logic                                               sq_entry_fwd_bypass_req0_newer;
logic                                               sq_entry_fwd_bypass_req1_newer;
logic                                               sq_entry_fwd_bypass_req2_newer;                   
logic                                               sq_entry_fwd_multi_depd_set0;//1->3 for 3ld_dc, LTL
logic                                               sq_entry_fwd_multi_depd_set1;
logic                                               sq_entry_fwd_multi_depd_set2;                  
logic                                               sq_entry_fwd_req0;   //1->3 for 3ld  dc, LTL
logic                                               sq_entry_fwd_req1;
logic                                               sq_entry_fwd_req2;                            
logic                                               sq_entry_has_wait_restart;                        
logic                                               sq_entry_iid_newer_than_lsdc0;   //1->2 LTL
logic                                               sq_entry_iid_newer_than_lsdc1;          
logic                                               sq_entry_iid_older_than_ldc0;   //1->3 for 3ld_dc, LTL
logic                                               sq_entry_iid_older_than_lsdc0;                       
logic                                               sq_entry_iid_older_than_lsdc1; 
logic                                               sq_entry_inst_hit0;
logic                                               sq_entry_inst_hit1;                                   
logic                                               sq_entry_newer_than_lsdc0; //1->2 LTL
logic                                               sq_entry_newer_than_lsdc1;               
logic                                               sq_entry_newest_fwd_req_data_vld0; //1->3 for 3ld  dc, LTL
logic                                               sq_entry_newest_fwd_req_data_vld1; 
logic                                               sq_entry_newest_fwd_req_data_vld2;       
logic                                               sq_entry_newest_fwd_req_data_vld_short0;//1->3 for 3ld  dc, LTL
logic                                               sq_entry_newest_fwd_req_data_vld_short1;
logic                                               sq_entry_newest_fwd_req_data_vld_short2;
logic                                               sq_entry_not_and_ldc0_bytes_vld_hit;   //1->3 for 3ld_dc, LTL
logic                                               sq_entry_not_and_lsdc0_bytes_vld_hit;
logic                                               sq_entry_not_and_lsdc1_bytes_vld_hit;    
logic                                               sq_entry_older_than_ldc0;  //1->3 LTL
logic                                               sq_entry_older_than_lsdc0;
logic                                               sq_entry_older_than_lsdc1;                        
logic                                               sq_entry_pop_req;                             
logic                                               sq_entry_pop_to_ce_grnt;                  
logic                                               sq_entry_pop_vld;                          
logic                                               sq_entry_same_addr_newest_clr;           
logic                                               sq_entry_sdid_hit0;
logic                                               sq_entry_sdid_hit1;                      
logic                                               sq_entry_settle_data_hit0;  //1->2 for 2 lsdc, LTL@20241017
logic                                               sq_entry_settle_data_hit1;                         
logic                                               sq_entry_st_da_info_set0; //1->2  LTL@20241017
logic                                               sq_entry_st_da_info_set1;
logic                                               sq_entry_ldc0_bv_do_hit;                 
logic                                               sq_entry_lsdc0_bv_do_hit; //1->3  LTL@20251010
logic                                               sq_entry_lsdc1_bv_do_hit;                
logic                                               sq_entry_lsdc0_bv_do_hit_st;//timingOpt@LTL
logic                                               sq_entry_lsdc1_bv_do_hit_st;//timingOpt@LTL
logic                                               sq_entry_lsdc0_create_age_vec; //1->2 LTL
logic                                               sq_entry_lsdc1_create_age_vec;                 
logic                                               sq_entry_lsdc0_same_addr_newer; //1->2 LTL
logic                                               sq_entry_lsdc1_same_addr_newer;          
logic                                               sq_entry_ldc0_same_addr_older;
logic                                               sq_entry_lsdc0_same_addr_older;
logic                                               sq_entry_lsdc1_same_addr_older;          
logic                                               sq_entry_st_inst;                        
logic                                               sq_entry_update_dcache_dirty;            
logic                                               sq_entry_update_dcache_page_share;       
logic                                               sq_entry_update_dcache_share;            
logic                                               sq_entry_update_dcache_valid;            
logic   [1  :0]                                     sq_entry_update_dcache_way;   //1->2bit, L1D2->4way,  LTL@20250323                               
logic                                               sq_entry_wakeup_queue_clk;               
logic                                               sq_entry_wakeup_queue_clk_en;            
logic                                               sq_entry_wo_st_inst;                             
logic                                               sq_pop_ptr;               

logic   [SQ_ENTRY-1:0]                              c_first_1;  //newly add for sq_entry_age_vec_1 parameter, LTL@20241022
//parameter SQ_ENTRY    = 12,  //defined in front, LTL@20241021
//          LSIQ_ENTRY  = 12;

//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
logic                                               sq_entry_chk_cur_state_is_data_check_0;
logic                                               sq_entry_chk_cur_state_is_data_check_1;
logic                                               sq_entry_chk_cur_state_no_final_0;
logic                                               sq_entry_chk_cur_state_no_final_1;
logic   [2  :0]                                     sq_entry_chk_cur_state_0;
logic   [2  :0]                                     sq_entry_chk_cur_state_1;
logic   [2  :0]                                     sq_entry_chk_next_state_0;
logic   [2  :0]                                     sq_entry_chk_next_state_1;
logic                                               sq_entry_expt_vld_cancel;
logic   [16 :0]                                     sq_entry_halt_info_0;
logic   [16 :0]                                     sq_entry_halt_info_1;
logic                                               sq_entry_wake_data_grnt_0;
logic                                               sq_entry_wake_data_grnt_1;
logic                                               sq_entry_wake_data_req_0;
logic                                               sq_entry_wake_data_req_1;
//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================

//==========================================================
//                 Instance of Gated Cell  
//==========================================================
//----------entry gateclk---------------
assign sq_entry_clk_en  = sq_entry_vld
                          || sq_entry_create_gateclk_en0   //gateclk_en0-> 0||1,  LTL@20241016
                          || sq_entry_create_gateclk_en1
                          || sq_entry_data_set_ff;
// &Instance("gated_clk_cell", "x_lsu_sq_entry_gated_clk"); @44
gated_clk_cell  x_lsu_sq_entry_gated_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (sq_entry_clk      ),
  .external_en        (1'b0              ),
  .local_en           (sq_entry_clk_en   ),
  .module_en          (cp0_lsu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect(.clk_in        (forever_cpuclk     ), @45
//          .external_en   (1'b0               ), @46
//          .module_en     (cp0_lsu_icg_en     ), @47
//          .local_en      (sq_entry_clk_en    ), @48
//          .clk_out       (sq_entry_clk       )); @49

//--------create update gateclk---------
assign sq_entry_create_clk_en  = sq_entry_create_gateclk_en0 || sq_entry_create_gateclk_en1;  //  LTL@20241016
// &Instance("gated_clk_cell", "x_lsu_sq_entry_create_gated_clk"); @53
gated_clk_cell  x_lsu_sq_entry_create_gated_clk (
  .clk_in                 (forever_cpuclk        ),
  .clk_out                (sq_entry_create_clk   ),
  .external_en            (1'b0                  ),
  .local_en               (sq_entry_create_clk_en),
  .module_en              (cp0_lsu_icg_en        ),
  .pad_yy_icg_scan_en     (pad_yy_icg_scan_en    )
);

// &Connect(.clk_in        (forever_cpuclk     ), @54
//          .external_en   (1'b0               ), @55
//          .module_en     (cp0_lsu_icg_en     ), @56
//          .local_en      (sq_entry_create_clk_en), @57
//          .clk_out       (sq_entry_create_clk)); @58

assign sq_entry_create_da_clk_en  = sq_entry_create_gateclk_en0                      //1->2   LTL@20241017
                                    || sq_entry_st_da_info_set0
                                    || sq_entry_create_gateclk_en1
                                    || sq_entry_st_da_info_set1;
// &Instance("gated_clk_cell", "x_lsu_sq_entry_create_da_gated_clk"); @62
gated_clk_cell  x_lsu_sq_entry_create_da_gated_clk (
  .clk_in                    (forever_cpuclk           ),
  .clk_out                   (sq_entry_create_da_clk   ),
  .external_en               (1'b0                     ),
  .local_en                  (sq_entry_create_da_clk_en),
  .module_en                 (cp0_lsu_icg_en           ),
  .pad_yy_icg_scan_en        (pad_yy_icg_scan_en       )
);

// &Connect(.clk_in        (forever_cpuclk     ), @63
//          .external_en   (1'b0               ), @64
//          .module_en     (cp0_lsu_icg_en     ), @65
//          .local_en      (sq_entry_create_da_clk_en), @66
//          .clk_out       (sq_entry_create_da_clk)); @67


//----------data gateclk----------------
assign sq_entry_data_clk_en = sq_entry_data_set0 || sq_entry_data_set1;
// &Instance("gated_clk_cell", "x_lsu_sq_entry_data_gated_clk"); @72
gated_clk_cell  x_lsu_sq_entry_data_gated_clk (
  .clk_in               (forever_cpuclk      ),
  .clk_out              (sq_entry_data_clk   ),
  .external_en          (1'b0                ),
  .local_en             (sq_entry_data_clk_en),
  .module_en            (cp0_lsu_icg_en      ),
  .pad_yy_icg_scan_en   (pad_yy_icg_scan_en  )
);


// &Connect(.clk_in        (forever_cpuclk     ), @73
//          .external_en   (1'b0               ), @74
//          .module_en     (cp0_lsu_icg_en     ), @75
//          .local_en      (sq_entry_data_clk_en), @76
//          .clk_out       (sq_entry_data_clk)); @77

//--------wakeup queue gateclk----------
assign sq_entry_wakeup_queue_clk_en = sq_entry_data_discard_grnt                       //grnt contain 0-2, LTL
                                      ||  (sq_entry_data_set                           //use set, not set 0 and 1, LTL
                                              ||  sq_entry_data_set_ff
                                              ||  rtu_yy_xx_flush
                                              ||  rtu_ck_flush)
                                          &&  sq_entry_has_wait_restart;              //already contain 3 wakeup_queue, LTL
// &Instance("gated_clk_cell", "x_lsu_sq_entry_wakeup_queue_gated_clk"); @85
gated_clk_cell  x_lsu_sq_entry_wakeup_queue_gated_clk (
  .clk_in                       (forever_cpuclk              ),
  .clk_out                      (sq_entry_wakeup_queue_clk   ),
  .external_en                  (1'b0                        ),
  .local_en                     (sq_entry_wakeup_queue_clk_en),
  .module_en                    (cp0_lsu_icg_en              ),
  .pad_yy_icg_scan_en           (pad_yy_icg_scan_en          )
);

// &Connect(.clk_in        (forever_cpuclk     ), @86
//          .external_en   (1'b0               ), @87
//          .module_en     (cp0_lsu_icg_en     ), @88
//          .local_en      (sq_entry_wakeup_queue_clk_en), @89
//          .clk_out       (sq_entry_wakeup_queue_clk)); @90

//==========================================================
//                 Register
//==========================================================
//+-----------+
//| entry_vld |
//+-----------+
always @(posedge sq_entry_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    sq_entry_vld              <=  1'b0;
  else if(sq_entry_pop_vld
    ||  rtu_lsu_async_flush
    ||  sq_entry_flush_pop_vld
    ||  sq_entry_expt_pop_vld)
    sq_entry_vld              <=  1'b0;
  else if(sq_entry_create_vld0)           //1->2  LTL@20241017
    sq_entry_vld              <=  1'b1;
  else if(sq_entry_create_vld1)               
    sq_entry_vld              <=  1'b1;
end

//+-----------+
//| in wmb ce |
//+-----------+
always @(posedge sq_entry_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    sq_entry_in_wmb_ce        <=  1'b0;
  else if(sq_entry_create_dp_vld0 || sq_entry_create_dp_vld1)              //vld -> vld0 || vld1, LTL@20241017
    sq_entry_in_wmb_ce        <=  1'b0;
  else if(sq_entry_pop_to_ce_grnt)
    sq_entry_in_wmb_ce        <=  1'b1;
end

//+-----------+
//| fwd_en    |
//+-----------+
// for most multi forward situation, use this bit for newest forward
always @(posedge sq_entry_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    sq_entry_same_addr_newest       <=  1'b0;
  else if(sq_entry_create_dp_vld0)                                      //vld0=1, choose lsdc0, LTL@20241017
    sq_entry_same_addr_newest       <=  sq_create_same_addr_newest0;   
  else if(sq_entry_create_dp_vld1)
    sq_entry_same_addr_newest       <=  sq_create_same_addr_newest1;   //vld1=1, choose lsdc1, LTL@20241017
  else if(sq_entry_same_addr_newest_clr)
    sq_entry_same_addr_newest       <=  1'b0;
end
//+-------------------------+
//| instruction information |
//+-------------------------+
always @(posedge sq_entry_create_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    sq_entry_sync_fence       <=  1'b0;
    sq_entry_atomic           <=  1'b0;
    sq_entry_icc              <=  1'b0;
    sq_entry_preg[PREG-1:0]   <=  {PREG{1'b0}};
    sq_entry_inst_flush       <=  1'b0;
    sq_entry_inst_type[1:0]   <=  2'b0;
    sq_entry_inst_size[2:0]   <=  3'b0;
    sq_entry_inst_mode[1:0]   <=  2'b0;
    sq_entry_fence_mode[3:0]  <=  4'b0;
    sq_entry_iid[IID_WIDTH-1:0]  <=  {IID_WIDTH{1'b0}};
    sq_entry_sdid[SDID_LEN:0]  <= {SDID_LEN+1{1'b0}};
    sq_entry_page_share       <=  1'b0;
    sq_entry_page_so          <=  1'b0;
    sq_entry_page_ca          <=  1'b0;
    sq_entry_page_wa          <=  1'b0;
    sq_entry_page_buf         <=  1'b0;
    sq_entry_page_sec         <=  1'b0;
    sq_entry_wo_st            <=  1'b0;
    sq_entry_boundary         <=  1'b0;
    sq_entry_secd             <=  1'b0;
    sq_entry_addr0[WK_PA_WIDTH-1:0] <=  {WK_PA_WIDTH{1'b0}};
    sq_entry_bytes_vld[15:0]  <=  16'b0;
    sq_entry_priv_mode[1:0]   <=  2'b0;
    sq_entry_rot_sel[15:0]    <=  16'b0;
    sq_entry_inst_vls          <=  1'b0;  //entry attr no need 1->2, LTL@20241112
    //sq_entry_vsew[1:0]        <=  2'b0;//rvv1.0@hcl
    sq_entry_vmew[1:0]        <=  2'b0;//rvv1.0@hcl
    sq_entry_vmop[1:0]        <=  2'b0;//rvv1.0@hcl
    sq_entry_element_size[1:0] <=  2'b0;  //no need 1->2 for 2 st_data, LTL@20241017
    sq_entry_idx_order        <=  1'b0;
    sq_entry_dtcm_hit         <=  1'b0;
    sq_entry_itcm_hit         <=  1'b0;
    sq_entry_init_dcache_miss <=  1'b0;
    sq_entry_ssp_va           <=  2'b0;
    sq_entry_pc_index[PC_LEN-1:0] <=  {PC_LEN{1'b0}};
  end
  else if(sq_entry_create_dp_vld0)                    //vld0=1, choose lsdc0, LTL@20241017
  begin
    sq_entry_sync_fence       <=  lsdc0_ex2_sync_fence;
    sq_entry_atomic           <=  lsdc0_ex2_atomic;
    sq_entry_icc              <=  lsdc0_ex2_icc;
    sq_entry_preg[PREG-1:0]   <=  lsdc0_ex2_preg[PREG-1:0];
    sq_entry_inst_flush       <=  lsdc0_sq_ex2_inst_flush;
    sq_entry_inst_type[1:0]   <=  lsdc0_ex2_inst_type[1:0];
    sq_entry_inst_size[2:0]   <=  lsdc0_ex2_inst_size[2:0];
    sq_entry_inst_mode[1:0]   <=  lsdc0_ex2_inst_mode[1:0];
    sq_entry_fence_mode[3:0]  <=  lsdc0_ex2_fence_mode[3:0];
    sq_entry_iid[IID_WIDTH-1:0]   <=  lsdc0_ex2_st_iid[IID_WIDTH-1:0];//logic levels opt@LTL
    sq_entry_sdid[SDID_LEN:0]   <=  {1'b0, lsdc0_sq_ex2_sdid[SDID_LEN-1:0]};
    sq_entry_page_share       <=  lsdc0_ex2_page_share;
    sq_entry_page_so          <=  lsdc0_ex2_page_so;
    sq_entry_page_ca          <=  lsdc0_ex2_page_ca;
    sq_entry_page_wa          <=  lsdc0_ex2_page_wa;
    sq_entry_page_buf         <=  lsdc0_ex2_page_buf;
    sq_entry_page_sec         <=  lsdc0_ex2_page_sec;
    sq_entry_wo_st            <=  lsdc0_sq_ex2_wo_st_inst;
    sq_entry_boundary         <=  lsdc0_ex2_boundary;
    sq_entry_secd             <=  lsdc0_ex2_st_secd;//logic levels opt@LTL
    sq_entry_addr0[WK_PA_WIDTH-1:0] <=  lsdc0_ex2_st_addr0[WK_PA_WIDTH-1:0];//logic levels opt@LTL
    sq_entry_bytes_vld[15:0]  <=  lsdc0_ex2_st_bytes_vld[15:0];
    sq_entry_priv_mode[1:0]   <=  cp0_yy_priv_mode[1:0];
    sq_entry_rot_sel[15:0]    <=  lsdc0_sq_ex2_rot_sel_rev[15:0];
    sq_entry_inst_vls          <=  lsdc0_ex2_inst_vls;
    //sq_entry_vsew[1:0]        <=  lsdc0_sq_ex2_vsew[1:0];//rvv1.0@hcl
    sq_entry_vmew[1:0]        <=  lsdc0_sq_ex2_vmew[1:0];//rvv1.0@hcl
    sq_entry_vmop[1:0]        <=  lsdc0_sq_ex2_vmop[1:0];//rvv1.0@hcl
    sq_entry_element_size[1:0] <=  lsdc0_sq_ex2_element_size[1:0];
    sq_entry_idx_order        <=  lsdc0_sq_ex2_idx_order;
    sq_entry_dtcm_hit         <=  lsdc0_sq_ex2_dtcm_hit;
    sq_entry_itcm_hit         <=  lsdc0_sq_ex2_itcm_hit;
    sq_entry_init_dcache_miss <=  !lsdc0_ex2_dcache_hit;
    sq_entry_ssp_va[1:0]      <=  lsdc0_ex2_ssp_va[1:0];
    sq_entry_pc_index[PC_LEN-1:0] <=  lsdc0_ex2_pc[PC_LEN-1:0];
  end
  else if(sq_entry_create_dp_vld1)     //vld1=1, choose lsdc1, LTL@20241017
  begin
    sq_entry_sync_fence       <=  lsdc1_ex2_sync_fence;
    sq_entry_atomic           <=  lsdc1_ex2_atomic;
    sq_entry_icc              <=  lsdc1_ex2_icc;
    sq_entry_preg[PREG-1:0]   <=  lsdc1_ex2_preg[PREG-1:0];
    sq_entry_inst_flush       <=  lsdc1_sq_ex2_inst_flush;
    sq_entry_inst_type[1:0]   <=  lsdc1_ex2_inst_type[1:0];
    sq_entry_inst_size[2:0]   <=  lsdc1_ex2_inst_size[2:0];
    sq_entry_inst_mode[1:0]   <=  lsdc1_ex2_inst_mode[1:0];
    sq_entry_fence_mode[3:0]  <=  lsdc1_ex2_fence_mode[3:0];
    sq_entry_iid[IID_WIDTH-1:0]  <=  lsdc1_ex2_st_iid[IID_WIDTH-1:0];//logic levels opt@LTL
    sq_entry_sdid[SDID_LEN:0]  <=  {1'b1, lsdc1_sq_ex2_sdid[SDID_LEN-1:0]};
    sq_entry_page_share       <=  lsdc1_ex2_page_share;
    sq_entry_page_so          <=  lsdc1_ex2_page_so;
    sq_entry_page_ca          <=  lsdc1_ex2_page_ca;
    sq_entry_page_wa          <=  lsdc1_ex2_page_wa;
    sq_entry_page_buf         <=  lsdc1_ex2_page_buf;
    sq_entry_page_sec         <=  lsdc1_ex2_page_sec;
    sq_entry_wo_st            <=  lsdc1_sq_ex2_wo_st_inst;
    sq_entry_boundary         <=  lsdc1_ex2_boundary;
    sq_entry_secd             <=  lsdc1_ex2_st_secd;//logic levels opt@LTL
    sq_entry_addr0[WK_PA_WIDTH-1:0] <=  lsdc1_ex2_st_addr0[WK_PA_WIDTH-1:0];
    sq_entry_bytes_vld[15:0]      <=  lsdc1_ex2_st_bytes_vld[15:0];
    sq_entry_priv_mode[1:0]       <=  cp0_yy_priv_mode[1:0];
    sq_entry_rot_sel[15:0]       <=  lsdc1_sq_ex2_rot_sel_rev[15:0];
    sq_entry_inst_vls             <=  lsdc1_ex2_inst_vls;
    //sq_entry_vsew[1:0]           <=  lsdc1_sq_ex2_vsew[1:0];//rvv1.0@hcl
    sq_entry_vmew[1:0]           <=  lsdc1_sq_ex2_vmew[1:0];//rvv1.0@hcl
    sq_entry_vmop[1:0]           <=  lsdc1_sq_ex2_vmop[1:0];//rvv1.0@hcl
    sq_entry_element_size[1:0]    <=  lsdc1_sq_ex2_element_size[1:0];  //LTL@20241112
    sq_entry_idx_order        <=  lsdc1_sq_ex2_idx_order;
    sq_entry_dtcm_hit         <=  lsdc1_sq_ex2_dtcm_hit;
    sq_entry_itcm_hit         <=  lsdc1_sq_ex2_itcm_hit;
    sq_entry_init_dcache_miss <=  !lsdc1_ex2_dcache_hit;
    sq_entry_ssp_va[1:0]      <=  lsdc1_ex2_ssp_va[1:0];
    sq_entry_pc_index[PC_LEN-1:0] <=  lsdc1_ex2_pc[PC_LEN-1:0];
  end
end
xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH))
x_ck_flush_iid_compare_entry_iid (
  .x_iid0         (rtu_ck_flush_iid[IID_WIDTH-1:0]    ),
  .x_iid0_older   (rtu_ck_flush_iid_older_than_entry  ),
  .x_iid1         (sq_entry_iid[IID_WIDTH-1:0]        )
);
//+------+
//| send st_stride |
//+------+
always @(posedge sq_entry_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    sq_entry_already_send_st_stride <= 1'b0;   //LTL@for st_stride
  else if(sq_entry_create_dp_vld0 || sq_entry_create_dp_vld1)  //vld-> vld0||vld1, LTL@20241017
    sq_entry_already_send_st_stride <= 1'b0;   //LTL@for st_stride
  else if(sq_entry_already_send_st_stride_set)
    sq_entry_already_send_st_stride <=  1'b1;
end
//+------+
//| cmit |
//+------+
always @(posedge sq_entry_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    sq_entry_cmit             <=  1'b0;
  else if(sq_entry_create_dp_vld0 || sq_entry_create_dp_vld1)  //vld-> vld0||vld1, LTL@20241017
    sq_entry_cmit             <=  1'b0;
  else if(sq_entry_cmit_set)
    sq_entry_cmit             <=  1'b1;
end

//+----------+
//| data_vld |
//+----------+
always @(posedge sq_entry_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    sq_entry_data_vld         <=  1'b0;
  else if(sq_entry_create_dp_vld0)
    sq_entry_data_vld         <=  lsdc0_sq_ex2_data_vld;    //vld0=1, choose lsdc0, LTL@20241017
  else if(sq_entry_create_dp_vld1)
    sq_entry_data_vld         <=  lsdc1_sq_ex2_data_vld;    //vld1=1, choose lsdc1, LTL@20241017
  else if(sq_entry_data_set)                                //use set, not set 0 and 1, LTL
    sq_entry_data_vld         <=  1'b1;
end


//+-------------+
//| data_set_ff |
//+-------------+
always @(posedge sq_entry_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    sq_entry_data_set_ff      <=  1'b0;
  else if(sq_entry_create_dp_vld0 || sq_entry_create_dp_vld1)  //vld-> vld0||vld1, LTL@20241017
    sq_entry_data_set_ff      <=  1'b0;
  else if(sq_entry_data_set)                                   //use set, not set 0 and 1, LTL
    sq_entry_data_set_ff      <=  1'b1;                        //data_set_ff ->0 and 1 or not, LTL
  else
    sq_entry_data_set_ff      <=  1'b0;
end

//+--------------+
//| wakeup_queue |
//+--------------+
always @(posedge sq_entry_wakeup_queue_clk or negedge cpurst_b)
begin
  if (!cpurst_b)                                                              //when rst, 3 queue in one begin-end, LTL
  begin
    sq_entry_wakeup_queue0[LSIQ_ENTRY-1:0] <=  {LSIQ_ENTRY{1'b0}};
    sq_entry_wakeup_queue1[LSIQ_ENTRY-1:0] <=  {LSIQ_ENTRY{1'b0}};
    sq_entry_wakeup_queue2[LSIQ_ENTRY-1:0] <=  {LSIQ_ENTRY{1'b0}};
  end
  else if(sq_entry_data_set &&  !sq_entry_data_discard_grnt                  //use set, not set 0 and 1, not use discard_grnt0 LTL  ??? need fenkai???)
        || sq_entry_data_set_ff
        ||  rtu_yy_xx_flush
        ||  rtu_ck_flush ) //ck_flush send out all data_wakeup queue, ck_flush@LTL
  begin
    sq_entry_wakeup_queue0[LSIQ_ENTRY-1:0] <=  {LSIQ_ENTRY{1'b0}};
    sq_entry_wakeup_queue1[LSIQ_ENTRY-1:0] <=  {LSIQ_ENTRY{1'b0}};
    sq_entry_wakeup_queue2[LSIQ_ENTRY-1:0] <=  {LSIQ_ENTRY{1'b0}};
  end
  else if(sq_entry_data_set && sq_entry_data_discard_grnt)  //use set, not set 0 and 1, use discard_grnt not 0-3, LTL
    begin
    sq_entry_wakeup_queue0[LSIQ_ENTRY-1:0] <=  {LSIQ_ENTRY{sq_entry_data_discard_grnt0}} & lda0_ex3_lsid[LSIQ_ENTRY-1:0];   //add grnt=1, 1->3 for 3 wakeup queue
    sq_entry_wakeup_queue1[LSIQ_ENTRY-1:0] <=  {LSIQ_ENTRY{sq_entry_data_discard_grnt1}} & lsda0_ex3_lsid[LSIQ_ENTRY-1:0];
    sq_entry_wakeup_queue2[LSIQ_ENTRY-1:0] <=  {LSIQ_ENTRY{sq_entry_data_discard_grnt2}} & lsda1_ex3_lsid[LSIQ_ENTRY-1:0];
    end
  //else if(sq_entry_data_set &&  sq_entry_data_discard_grnt3)                 //use set, not set 0 and 1, use discard_grnt0, LTL
  //  sq_entry_wakeup_queue3[LSIQ_ENTRY-1:0] <=  lsda1_ex3_lsid[LSIQ_ENTRY-1:0];

  else if(sq_entry_data_discard_grnt0 || sq_entry_data_discard_grnt1 || sq_entry_data_discard_grnt2)    // if multi ld dc discard valid, use else if need careful 
    begin
    sq_entry_wakeup_queue0[LSIQ_ENTRY-1:0] <=  ({LSIQ_ENTRY{sq_entry_data_discard_grnt0}} & lda0_ex3_lsid[LSIQ_ENTRY-1:0])
                                              | sq_entry_wakeup_queue0[LSIQ_ENTRY-1:0];
    sq_entry_wakeup_queue1[LSIQ_ENTRY-1:0] <=  ({LSIQ_ENTRY{sq_entry_data_discard_grnt1}} & lsda0_ex3_lsid[LSIQ_ENTRY-1:0])
                                              | sq_entry_wakeup_queue1[LSIQ_ENTRY-1:0];
    sq_entry_wakeup_queue2[LSIQ_ENTRY-1:0] <=  ({LSIQ_ENTRY{sq_entry_data_discard_grnt2}} & lsda1_ex3_lsid[LSIQ_ENTRY-1:0])
                                              | sq_entry_wakeup_queue2[LSIQ_ENTRY-1:0];                                              
    end
  //else if(sq_entry_data_discard_grnt1)
  //  sq_entry_wakeup_queue1[LSIQ_ENTRY-1:0] <=  lda1_ex3_lsid[LSIQ_ENTRY-1:0]
  ///                                            | sq_entry_wakeup_queue1[LSIQ_ENTRY-1:0]; 
end
assign sq_entry_has_wait_restart = (|sq_entry_wakeup_queue0[LSIQ_ENTRY-1:0])    //1 queue -> 4 queue, LTL@20241017
                                  || (|sq_entry_wakeup_queue1[LSIQ_ENTRY-1:0])
                                  || (|sq_entry_wakeup_queue2[LSIQ_ENTRY-1:0]);

//+------+
//| data |
//+------+
always @(posedge sq_entry_data_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    sq_entry_data[127:0]       <=  128'b0;
  else if(sq_entry_data_set0)                             //0 for st_data0, LTL@20241017
    sq_entry_data[127:0]       <=  sq_data_settle0[127:0];
  else if(sq_entry_data_set1)                            //1 for st_data1, LTL@20241017
    sq_entry_data[127:0]       <=  sq_data_settle1[127:0];
end
//+-------------------+
//| st_da information |
//+-------------------+
//include dcache info/no_restart info
//include spec_fail info for timing
always @(posedge sq_entry_create_da_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    sq_entry_spec_fail        <=  1'b0;
    sq_entry_vstart_vld       <=  1'b0;
  end
  else if(sq_entry_st_da_info_set0)               //1->2, 0 for lsda0  LTL@20241017
  begin
    sq_entry_spec_fail        <=  lsda0_ex3_spec_fail;
    sq_entry_vstart_vld       <=  lsda0_ex3_vstart_vld;
  end
  else if(sq_entry_st_da_info_set1)              //for lsda1  LTL@20241017
  begin
    sq_entry_spec_fail        <=  lsda1_ex3_spec_fail;
    sq_entry_vstart_vld       <=  lsda1_ex3_vstart_vld;
  end
end

always @(posedge sq_entry_create_da_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    sq_entry_dcache_info_vld  <=  1'b0;
    sq_entry_no_restart       <=  1'b0;
    sq_entry_expt_nop         <=  1'b0;
    sq_entry_expt_vld_cancel  <=  1'b0; // Risc-V Debug zdb
    sq_entry_lm_fail          <=  1'b0;
  end
  else if(sq_entry_create_dp_vld0 || sq_entry_create_dp_vld1)   //dp_vld ->vld0 and 1, LTL@20241017
  begin
    sq_entry_dcache_info_vld  <=  1'b0;
    sq_entry_no_restart       <=  1'b0;
    sq_entry_expt_nop         <=  1'b0;
    sq_entry_expt_vld_cancel  <=  1'b0; // Risc-V Debug zdb
    sq_entry_lm_fail          <=  1'b0;
  end
  else if(sq_entry_st_da_info_set0)
  begin
    sq_entry_dcache_info_vld  <=  1'b1;
    sq_entry_no_restart       <=  lsda0_sq_ex3_no_restart;     //restart 0->1   LTL
    sq_entry_expt_nop         <=  lsda0_sq_ex3_expt_vld;
    sq_entry_expt_vld_cancel  <=  lsda0_st_da_wb_expt_vld_cancel; // Risc-V Debug zdb
    sq_entry_lm_fail          <=  lsda0_sq_ex3_lm_fail;
  end
  else if(sq_entry_st_da_info_set1)
  begin
    sq_entry_dcache_info_vld  <=  1'b1;
    sq_entry_no_restart       <=  lsda1_sq_ex3_no_restart;
    sq_entry_expt_nop         <=  lsda1_sq_ex3_expt_vld;
    sq_entry_expt_vld_cancel  <=  lsda1_st_da_wb_expt_vld_cancel; // Risc-V Debug zdb
    sq_entry_lm_fail          <=  lsda1_sq_ex3_lm_fail;
  end
end

//+-------------+
//| dcache info |
//+-------------+
always @(posedge sq_entry_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    sq_entry_dcache_valid     <=  1'b0;
    sq_entry_dcache_share     <=  1'b0;
    sq_entry_dcache_dirty     <=  1'b0;
    sq_entry_dcache_page_share<=  1'b0;
    sq_entry_dcache_way       <=  2'b0;
  end
  else if(sq_entry_dcache_update_vld)
  begin
    sq_entry_dcache_valid     <=  sq_entry_update_dcache_valid;
    sq_entry_dcache_share     <=  sq_entry_update_dcache_share;
    sq_entry_dcache_dirty     <=  sq_entry_update_dcache_dirty;
    sq_entry_dcache_page_share<=  sq_entry_update_dcache_page_share;
    sq_entry_dcache_way       <=  sq_entry_update_dcache_way;
  end
  else if(sq_entry_st_da_info_set0)
  begin
    sq_entry_dcache_valid     <=  lsda0_sq_ex3_dcache_valid;
    sq_entry_dcache_share     <=  lsda0_sq_ex3_dcache_share;
    sq_entry_dcache_dirty     <=  lsda0_sq_ex3_dcache_dirty;
    sq_entry_dcache_page_share<=  lsda0_sq_ex3_dcache_page_share;
    sq_entry_dcache_way       <=  lsda0_sq_ex3_dcache_way;
  end
  else if(sq_entry_st_da_info_set1)
  begin
    sq_entry_dcache_valid     <=  lsda1_sq_ex3_dcache_valid;
    sq_entry_dcache_share     <=  lsda1_sq_ex3_dcache_share;
    sq_entry_dcache_dirty     <=  lsda1_sq_ex3_dcache_dirty;
    sq_entry_dcache_page_share<=  lsda1_sq_ex3_dcache_page_share;
    sq_entry_dcache_way       <=  lsda1_sq_ex3_dcache_way;
  end
end

//+---------+
//| age_vec |
//+---------+
always @(posedge sq_create_pop_clk)
begin
  if(sq_entry_create_dp_vld0)                                               //dp_vld0 -> dp_vld0 and 1, 
    sq_entry_age_vec[SQ_ENTRY-1:0]  <=  sq_create_age_vec0[SQ_ENTRY-1:0];
  else if(sq_entry_create_dp_vld1)                                               //1 for lsdc1, LTL
    sq_entry_age_vec[SQ_ENTRY-1:0]  <=  sq_create_age_vec1[SQ_ENTRY-1:0];
  else if(sq_age_vec_set  &&  sq_entry_vld)
    sq_entry_age_vec[SQ_ENTRY-1:0]  <=  sq_entry_age_vec_next[SQ_ENTRY-1:0];
end

//+------+
//| depd |
//+------+
always @(posedge sq_entry_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    sq_entry_depd             <=  1'b0;
  else if(sq_entry_create_dp_vld0 || sq_entry_create_dp_vld1)  //vld->vld0 || vld1, LTL@20241021
    sq_entry_depd             <=  1'b0;
  else if(sq_entry_depd_set0 || sq_entry_depd_set1 || sq_entry_depd_set2)   //1->3, for 3 ld LTL@20241101
    sq_entry_depd             <=  1'b1;
end

always @(posedge sq_entry_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    sq_entry_cmit0_iid_hit    <=  1'b0;
    sq_entry_cmit1_iid_hit    <=  1'b0;
    sq_entry_cmit2_iid_hit    <=  1'b0;
    sq_entry_cmit3_iid_hit    <=  1'b0;
    sq_entry_cmit4_iid_hit    <=  1'b0;
    sq_entry_cmit5_iid_hit    <=  1'b0;
    sq_entry_cmit6_iid_hit    <=  1'b0;
    sq_entry_cmit7_iid_hit    <=  1'b0;      
  end
  else if(sq_entry_create_dp_vld0)   //vld 0 for lsdc0, LTL
  begin
    sq_entry_cmit0_iid_hit    <=  lsdc0_sq_ex2_cmit0_iid_crt_hit;   //3->8, LTL
    sq_entry_cmit1_iid_hit    <=  lsdc0_sq_ex2_cmit1_iid_crt_hit;
    sq_entry_cmit2_iid_hit    <=  lsdc0_sq_ex2_cmit2_iid_crt_hit;
    sq_entry_cmit3_iid_hit    <=  lsdc0_sq_ex2_cmit3_iid_crt_hit;
    sq_entry_cmit4_iid_hit    <=  lsdc0_sq_ex2_cmit4_iid_crt_hit;
    sq_entry_cmit5_iid_hit    <=  lsdc0_sq_ex2_cmit5_iid_crt_hit;
    sq_entry_cmit6_iid_hit    <=  lsdc0_sq_ex2_cmit6_iid_crt_hit;
    sq_entry_cmit7_iid_hit    <=  lsdc0_sq_ex2_cmit7_iid_crt_hit;

  end
  else if(sq_entry_create_dp_vld1)   //vld 1 for lsdc1, LTL
  begin
    sq_entry_cmit0_iid_hit    <=  lsdc1_sq_ex2_cmit0_iid_crt_hit;
    sq_entry_cmit1_iid_hit    <=  lsdc1_sq_ex2_cmit1_iid_crt_hit;
    sq_entry_cmit2_iid_hit    <=  lsdc1_sq_ex2_cmit2_iid_crt_hit;
    sq_entry_cmit3_iid_hit    <=  lsdc1_sq_ex2_cmit3_iid_crt_hit;
    sq_entry_cmit4_iid_hit    <=  lsdc1_sq_ex2_cmit4_iid_crt_hit;
    sq_entry_cmit5_iid_hit    <=  lsdc1_sq_ex2_cmit5_iid_crt_hit;
    sq_entry_cmit6_iid_hit    <=  lsdc1_sq_ex2_cmit6_iid_crt_hit;
    sq_entry_cmit7_iid_hit    <=  lsdc1_sq_ex2_cmit7_iid_crt_hit;  

  end  
  else if(sq_entry_vld)
  begin
    sq_entry_cmit0_iid_hit    <=  sq_entry_cmit0_iid_pre_hit;
    sq_entry_cmit1_iid_hit    <=  sq_entry_cmit1_iid_pre_hit;
    sq_entry_cmit2_iid_hit    <=  sq_entry_cmit2_iid_pre_hit;
    sq_entry_cmit3_iid_hit    <=  sq_entry_cmit3_iid_pre_hit;
    sq_entry_cmit4_iid_hit    <=  sq_entry_cmit4_iid_pre_hit;
    sq_entry_cmit5_iid_hit    <=  sq_entry_cmit5_iid_pre_hit;
    sq_entry_cmit6_iid_hit    <=  sq_entry_cmit6_iid_pre_hit;
    sq_entry_cmit7_iid_hit    <=  sq_entry_cmit7_iid_pre_hit;
  end
end

always @(posedge sq_entry_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    sq_entry_st_data0_sdid_hit   <=  1'b0;
    sq_entry_st_data1_sdid_hit   <=  1'b0;
  end
  else if(sq_entry_create_dp_vld0)                         //0 for lsdc0, dp_vld0 and 1 can use else if, LTL
  begin 
    sq_entry_st_data0_sdid_hit   <=  lsdc0_sq_ex2_sdid_hit0;                 //1->2, for lsdc0 and 
    sq_entry_st_data1_sdid_hit   <=  1'b0;
  end
  else if(sq_entry_create_dp_vld1)                         //1 for lsdc1, LTL@ 20241024
  begin  
    sq_entry_st_data0_sdid_hit   <=  1'b0;                 //1->2, for lsdc0 and 
    sq_entry_st_data1_sdid_hit   <=  lsdc1_sq_ex2_sdid_hit1;
  end
  else if(sq_entry_vld && !sq_entry_data_vld)
  begin
    sq_entry_st_data0_sdid_hit   <=  sq_entry_sdid_hit0;
    sq_entry_st_data1_sdid_hit   <=  sq_entry_sdid_hit1;
  end
end

always @(posedge sq_entry_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    sq_entry_bond_first_only     <=  1'b0;
  else if(sq_entry_create_dp_vld0)                      //0 for lsdc0, dp_vld0 and 1 can use else if, LTL 
    sq_entry_bond_first_only     <=  lsdc0_sq_ex2_boundary_first;
  else if(sq_entry_create_dp_vld1)                      //1 for lsdc1, dp_vld0 and 1 can use else if, LTL 
    sq_entry_bond_first_only     <=  lsdc1_sq_ex2_boundary_first;
  else if(sq_bond_secd_create_vld0 || sq_bond_secd_create_vld1)   //contain 0 and 1, first_only no need split 0 and 1, LTL@20241017 ???
    sq_entry_bond_first_only     <=  1'b0;
end

//==========================================================
//        Generate inst type
//==========================================================
assign sq_entry_dcache_inst = !sq_entry_atomic
                              &&  sq_entry_icc
                              &&  (sq_entry_inst_type[1:0]  ==  2'b10);
assign sq_entry_st_inst     = !sq_entry_icc
                              &&  !sq_entry_atomic
                              &&  !sq_entry_sync_fence;
assign sq_entry_wo_st_inst  = sq_entry_st_inst
                              &&  !sq_entry_expt_nop
                              &&  !sq_entry_page_so;

assign sq_entry_dcache_sw_inst  = sq_entry_dcache_inst
                                  &&  (sq_entry_inst_mode[1:0]  ==  2'b10);

//==========================================================
//      Generate cmit/st_da info/update signal
//==========================================================
//----------------------cmit signal-------------------------
assign sq_entry_cmit0_iid_pre_hit = (rtu_lsu_commit0_iid_updt_val[IID_WIDTH-1:0] == sq_entry_iid[IID_WIDTH-1:0]);
assign sq_entry_cmit1_iid_pre_hit = (rtu_lsu_commit1_iid_updt_val[IID_WIDTH-1:0] == sq_entry_iid[IID_WIDTH-1:0]);
assign sq_entry_cmit2_iid_pre_hit = (rtu_lsu_commit2_iid_updt_val[IID_WIDTH-1:0] == sq_entry_iid[IID_WIDTH-1:0]);
assign sq_entry_cmit3_iid_pre_hit = (rtu_lsu_commit3_iid_updt_val[IID_WIDTH-1:0] == sq_entry_iid[IID_WIDTH-1:0]);
assign sq_entry_cmit4_iid_pre_hit = (rtu_lsu_commit4_iid_updt_val[IID_WIDTH-1:0] == sq_entry_iid[IID_WIDTH-1:0]);
assign sq_entry_cmit5_iid_pre_hit = (rtu_lsu_commit5_iid_updt_val[IID_WIDTH-1:0] == sq_entry_iid[IID_WIDTH-1:0]);
assign sq_entry_cmit6_iid_pre_hit = (rtu_lsu_commit6_iid_updt_val[IID_WIDTH-1:0] == sq_entry_iid[IID_WIDTH-1:0]);
assign sq_entry_cmit7_iid_pre_hit = (rtu_lsu_commit7_iid_updt_val[IID_WIDTH-1:0] == sq_entry_iid[IID_WIDTH-1:0]);

assign sq_entry_cmit_hit0       = rtu_yy_xx_commit0
                                  &&  sq_entry_cmit0_iid_hit;
assign sq_entry_cmit_hit1       = rtu_yy_xx_commit1
                                  &&  sq_entry_cmit1_iid_hit;
assign sq_entry_cmit_hit2       = rtu_yy_xx_commit2
                                  &&  sq_entry_cmit2_iid_hit;
assign sq_entry_cmit_hit3       = rtu_yy_xx_commit3
                                  &&  sq_entry_cmit3_iid_hit;
assign sq_entry_cmit_hit4       = rtu_yy_xx_commit4
                                  &&  sq_entry_cmit4_iid_hit;
assign sq_entry_cmit_hit5       = rtu_yy_xx_commit5
                                  &&  sq_entry_cmit5_iid_hit;
assign sq_entry_cmit_hit6       = rtu_yy_xx_commit6
                                  &&  sq_entry_cmit6_iid_hit;
assign sq_entry_cmit_hit7       = rtu_yy_xx_commit7
                                  &&  sq_entry_cmit7_iid_hit;
                                 
assign sq_entry_cmit_set        = (sq_entry_cmit_hit0
                                      ||  sq_entry_cmit_hit1
                                      ||  sq_entry_cmit_hit2
                                      ||  sq_entry_cmit_hit3
                                      ||  sq_entry_cmit_hit4
                                      ||  sq_entry_cmit_hit5
                                      ||  sq_entry_cmit_hit6
                                      ||  sq_entry_cmit_hit7)
                                  &&  sq_entry_vld;

//-----------------cmit data vld signal---------------------
assign sq_entry_cmit_data_not_vld = sq_entry_vld
                                    &&  (sq_entry_cmit || sq_entry_cmit_set)
                                    &&  !sq_entry_data_vld;

assign sq_entry_cmit_data_vld     = !sq_entry_cmit_data_not_vld;

//---------------------st_da info siganl--------------------
assign sq_entry_st_da_info_set0    = sq_entry_vld
                                    &&  lsda0_ex3_inst_vld
                                    &&  !lsda0_sq_ex3_ecc_stall
                                    &&  !sq_entry_no_restart
                                    &&  (lsda0_sq_ex3_secd  ==  sq_entry_secd)
                                    &&  (lsda0_ex3_iid[IID_WIDTH-1:0]  ==  sq_entry_iid[IID_WIDTH-1:0]);
assign sq_entry_st_da_info_set1    = sq_entry_vld
                                    &&  lsda1_ex3_inst_vld
                                    &&  !lsda1_sq_ex3_ecc_stall
                                    &&  !sq_entry_no_restart
                                    &&  (lsda1_sq_ex3_secd  ==  sq_entry_secd)
                                    &&  (lsda1_ex3_iid[IID_WIDTH-1:0]  ==  sq_entry_iid[IID_WIDTH-1:0]);                                
//-------------------boundary secd signal-------------------
assign sq_bond_secd_create_vld0  = sq_entry_vld
                                  && sq_create_success0
                                  && (sq_entry_iid[IID_WIDTH-1:0] == lsdc0_ex2_st_iid[IID_WIDTH-1:0])//logic levels opt@LTL
                                  && lsdc0_ex2_st_secd;//logic levels opt@LTL
assign sq_bond_secd_create_vld1  = sq_entry_vld
                                  && sq_create_success1
                                  && (sq_entry_iid[IID_WIDTH-1:0] == lsdc1_ex2_st_iid[IID_WIDTH-1:0])//logic levels opt@LTL
                                  && lsdc1_ex2_st_secd;//logic levels opt@LTL
//---------------------data update signal-------------------
assign sq_entry_sdid_hit0          = (sq_entry_sdid[SDID_LEN:0] ==  {1'b0, std0_rf_sdid[SDID_LEN-1:0]});   //1->2 for 2 st_data, LTL
assign sq_entry_sdid_hit1          = (sq_entry_sdid[SDID_LEN:0] ==  {1'b1, std1_rf_sdid[SDID_LEN-1:0]});    

assign sq_entry_settle_data_hit0   = sq_entry_vld                          //1->2  for  2 st_data, LTL@20241017
                                    &&  !sq_entry_data_vld
                                    &&  sq_entry_st_data0_sdid_hit;
assign sq_entry_settle_data_hit1   = sq_entry_vld                          //1->2  for  2 st_data, LTL@20241017
                                    &&  !sq_entry_data_vld
                                    &&  sq_entry_st_data1_sdid_hit;

assign sq_entry_data_set0          = sq_entry_vld                      //1->2, set0 for st_data0, LTL@20241017
                                    &&  !sq_entry_data_vld
                                    &&  std0_ex1_inst_vld
                                    &&  sq_entry_st_data0_sdid_hit;

assign sq_entry_data_set1          = sq_entry_vld                     //set0 for st_data0, LTL@20241017
                                    &&  !sq_entry_data_vld
                                    &&  std1_ex1_inst_vld
                                    &&  sq_entry_st_data1_sdid_hit;

assign sq_entry_data_set = sq_entry_data_set0 || sq_entry_data_set1;  //set = set0 || set1, LTL@20241017                                    
//-----------------------fwd signal-------------------------
//to decrease multi forward depd
//assign sq_entry_addr_11to4_hit_lsdc0      = (sq_entry_addr0[11:4] == lsdc0_ex2_addr0[11:4]);//1->2 for 2lsdc, LTL@20241017  
//assign sq_entry_addr_11to4_hit_lsdc1      = (sq_entry_addr0[11:4] == lsdc1_ex2_addr0[11:4]);

assign sq_entry_addr_tto4_hit_ldc0       = (sq_entry_addr0[WK_PA_WIDTH-1:4] == ldc0_ex2_addr0[WK_PA_WIDTH-1:4]);
assign sq_entry_addr_tto4_hit_lsdc0      = (sq_entry_addr0[WK_PA_WIDTH-1:4] == lsdc0_ex2_ld_addr0[WK_PA_WIDTH-1:4]);//1->3 for 1ldc  2lsdc, LTL@20251010  
assign sq_entry_addr_tto4_hit_lsdc1      = (sq_entry_addr0[WK_PA_WIDTH-1:4] == lsdc1_ex2_ld_addr0[WK_PA_WIDTH-1:4]);
assign sq_entry_addr_tto4_hit_lsdc0_st   = (sq_entry_addr0[WK_PA_WIDTH-1:4] == lsdc0_ex2_st_addr0[WK_PA_WIDTH-1:4]);//timing@LTL
assign sq_entry_addr_tto4_hit_lsdc1_st   = (sq_entry_addr0[WK_PA_WIDTH-1:4] == lsdc1_ex2_st_addr0[WK_PA_WIDTH-1:4]);

assign sq_entry_ldc0_bv_do_hit            = |(ldc0_ex2_bytes_vld[15:0] & sq_entry_bytes_vld[15:0]);
assign sq_entry_lsdc0_bv_do_hit           = |(lsdc0_ex2_ld_bytes_vld[15:0] & sq_entry_bytes_vld[15:0]);//1->3 for 1ldc  2lsdc, LTL@20251010  
assign sq_entry_lsdc1_bv_do_hit           = |(lsdc1_ex2_ld_bytes_vld[15:0] & sq_entry_bytes_vld[15:0]);
assign sq_entry_lsdc0_bv_do_hit_st        = |(lsdc0_ex2_st_bytes_vld[15:0] & sq_entry_bytes_vld[15:0]);//1->3 for 1ldc  2lsdc, LTL@20251010  
assign sq_entry_lsdc1_bv_do_hit_st        = |(lsdc1_ex2_st_bytes_vld[15:0] & sq_entry_bytes_vld[15:0]);

assign sq_entry_same_addr_newest_clr      = sq_entry_vld                           // clear entry same addr newest, 2 lsdc, LTL@20241017  
                                            && ((sq_create_success0
                                            && !sq_entry_newer_than_lsdc0
                                            && sq_entry_addr_tto4_hit_lsdc0_st 
                                            && sq_entry_lsdc0_bv_do_hit_st)
                                            || (sq_create_success1
                                            && !sq_entry_newer_than_lsdc1
                                            && sq_entry_addr_tto4_hit_lsdc1_st 
                                            && sq_entry_lsdc1_bv_do_hit_st));

//to sq_create_fwd_newest
assign sq_entry_ldc0_same_addr_older     = sq_entry_vld                //1->3 for 1ldc   2lsdc, LTL@20251010  
                                            && sq_entry_older_than_ldc0
                                            && sq_entry_addr_tto4_hit_ldc0
                                            && sq_entry_ldc0_bv_do_hit;
assign sq_entry_lsdc0_same_addr_older     = sq_entry_vld                //1->3 for 1ldc   2lsdc, LTL@20251010  
                                            && sq_entry_older_than_lsdc0
                                            && sq_entry_addr_tto4_hit_lsdc0
                                            && sq_entry_lsdc0_bv_do_hit;
assign sq_entry_lsdc1_same_addr_older     = sq_entry_vld
                                            && sq_entry_older_than_lsdc1
                                            && sq_entry_addr_tto4_hit_lsdc1
                                            && sq_entry_lsdc1_bv_do_hit;
assign sq_entry_lsdc0_same_addr_newer     = sq_entry_vld                //1->3 for 1ldc   2lsdc, LTL@20251010  
                                            && sq_entry_newer_than_lsdc0
                                            && sq_entry_addr_tto4_hit_lsdc0_st
                                            && sq_entry_lsdc0_bv_do_hit_st;
assign sq_entry_lsdc1_same_addr_newer     = sq_entry_vld
                                            && sq_entry_newer_than_lsdc1
                                            && sq_entry_addr_tto4_hit_lsdc1_st
                                            && sq_entry_lsdc1_bv_do_hit_st;
//==========================================================
//                 sq iid check
//==========================================================
//check iid to judge whether to create sq
assign sq_entry_inst_hit0  = sq_entry_vld                       //1->2 for 2lsdc, LTL@20241017 
                            &&  !sq_entry_no_restart
                            &&  (sq_entry_secd  ==  lsdc0_ex2_st_secd)//logic levels opt@LTL
                            &&  (sq_entry_iid[IID_WIDTH-1:0] ==  lsdc0_ex2_st_iid[IID_WIDTH-1:0]);//logic levels opt@LTL
assign sq_entry_inst_hit1  = sq_entry_vld
                            &&  !sq_entry_no_restart
                            &&  (sq_entry_secd  ==  lsdc1_ex2_st_secd)//logic levels opt@LTL
                            &&  (sq_entry_iid[IID_WIDTH-1:0] ==  lsdc1_ex2_st_iid[IID_WIDTH-1:0]);//logic levels opt@LTL
//==========================================================
//            Compare dcache write port(dcwp)
//==========================================================
// &Instance("xx_lsu_dcache_info_update","x_lsu_sq_entry_dcache_info_update"); @538
xx_lsu_dcache_info_update  x_lsu_sq_entry_dcache_info_update (
  .compare_dcwp_addr                 (sq_entry_addr0[`WK_PA_WIDTH-1:0] ),
  .compare_dcwp_hit_idx              (sq_entry_dcache_hit_idx          ),
  .compare_dcwp_sw_inst              (sq_entry_dcache_sw_inst          ),
  .compare_dcwp_update_vld           (sq_entry_dcache_update_vld_unmask),
  .dcache_dirty_din                  (dcache_dirty_din                 ),
  .dcache_dirty_gwen                 (dcache_dirty_gwen                ),
  .dcache_dirty_wen                  (dcache_dirty_wen                 ),
  .dcache_idx                        (dcache_idx                       ),
  .dcache_tag_din                    (dcache_tag_din                   ),
  .dcache_tag_gwen                   (dcache_tag_gwen                  ),
  .dcache_tag_wen                    (dcache_tag_wen                   ),
  .origin_dcache_dirty               (sq_entry_dcache_dirty            ),
  .origin_dcache_page_share          (sq_entry_dcache_page_share       ),
  .origin_dcache_share               (sq_entry_dcache_share            ),
  .origin_dcache_valid               (sq_entry_dcache_valid            ),
  .origin_dcache_way                 (sq_entry_dcache_way              ),
  .update_dcache_dirty               (sq_entry_update_dcache_dirty     ),
  .update_dcache_page_share          (sq_entry_update_dcache_page_share),
  .update_dcache_share               (sq_entry_update_dcache_share     ),
  .update_dcache_valid               (sq_entry_update_dcache_valid     ),
  .update_dcache_way                 (sq_entry_update_dcache_way       )
);

// &Connect( .compare_dcwp_addr          (sq_entry_addr0[WK_PA_WIDTH-1:0]   ), @539
//           .compare_dcwp_sw_inst       (sq_entry_dcache_sw_inst), @540
//           .origin_dcache_valid        (sq_entry_dcache_valid  ), @541
//           .origin_dcache_share        (sq_entry_dcache_share  ), @542
//           .origin_dcache_dirty        (sq_entry_dcache_dirty  ), @543
//           .origin_dcache_page_share   (sq_entry_dcache_page_share ), @544
//           .origin_dcache_way          (sq_entry_dcache_way    ), @545
//           .compare_dcwp_update_vld    (sq_entry_dcache_update_vld_unmask), @546
//           .compare_dcwp_hit_idx       (sq_entry_dcache_hit_idx  ), @547
//           .update_dcache_valid        (sq_entry_update_dcache_valid ), @548
//           .update_dcache_share        (sq_entry_update_dcache_share ), @549
//           .update_dcache_dirty        (sq_entry_update_dcache_dirty ), @550
//           .update_dcache_page_share   (sq_entry_update_dcache_page_share), @551
//           .update_dcache_way          (sq_entry_update_dcache_way   )); @552
// &Force("nonport","sq_entry_dcache_hit_idx"); @553

assign sq_entry_dcache_update_vld   = sq_entry_dcache_update_vld_unmask
                                      &&  sq_entry_vld
                                      &&  sq_entry_dcache_info_vld;

//==========================================================
//                  Maintain Age Vector
//==========================================================
//if age_vec[n] = 1, it means sq_entry_n is older than this sq_entry
//age_vec -> age_vec_create -> age_vec_next
//-------------------age_vec after create-------------------
//sq entry newer than st_dc
// &Instance("wk_rtu_compare_iid","x_lsu_sq_entry_compare_st_dc_iid"); @566
xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH))
x_lsu_sq_entry_compare_st_dc_iid0 (                        //1->2 for 2lsdc, LTL@20241017 
  .x_iid0                        (lsdc0_ex2_st_iid[IID_WIDTH-1:0]        ),//logic levels opt@LTL
  .x_iid0_older                  (sq_entry_iid_newer_than_lsdc0),
  .x_iid1                        (sq_entry_iid[IID_WIDTH-1:0]            )
);
xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH))
x_lsu_sq_entry_compare_st_dc_iid1 (
  .x_iid0                        (lsdc1_ex2_st_iid[IID_WIDTH-1:0]        ),//logic levels opt@LTL
  .x_iid0_older                  (sq_entry_iid_newer_than_lsdc1),
  .x_iid1                        (sq_entry_iid[IID_WIDTH-1:0]            )
);
// &Connect( .x_iid0         (lsdc0_ex2_iid[6:0]       ), @567
//           .x_iid1         (sq_entry_iid[6:0]    ), @568
//           .x_iid0_older   (sq_entry_iid_newer_than_lsdc0)); @569

assign sq_entry_newer_than_lsdc0  = !sq_entry_cmit                               //1->2 for 2lsdc, LTL@20241017 
                                    &&  sq_entry_iid_newer_than_lsdc0;
assign sq_entry_newer_than_lsdc1  = !sq_entry_cmit
                                    &&  sq_entry_iid_newer_than_lsdc1;
                                    
assign sq_entry_lsdc0_create_age_vec  = sq_entry_vld                               //1->2 for 2lsdc, LTL@20241017 
                                        &&  !sq_entry_in_wmb_ce
                                        &&  !sq_entry_pop_to_ce_grnt
                                        &&  !sq_entry_newer_than_lsdc0;
assign sq_entry_lsdc1_create_age_vec  = sq_entry_vld
                                        &&  !sq_entry_in_wmb_ce
                                        &&  !sq_entry_pop_to_ce_grnt
                                        &&  !sq_entry_newer_than_lsdc1;

assign sq_entry_age_vec_create[SQ_ENTRY-1:0]  =                          //1->2  entry compare with lsdc to maintain age_vec, LTL@20241017        
                (sq_create_vld0[SQ_ENTRY-1:0] & {SQ_ENTRY{sq_entry_newer_than_lsdc0}})
                | (sq_create_vld1[SQ_ENTRY-1:0] & {SQ_ENTRY{sq_entry_newer_than_lsdc1}})
                | sq_entry_age_vec[SQ_ENTRY-1:0];

//-------------------age_vecafter pop-----------------------
assign sq_entry_age_vec_next[SQ_ENTRY-1:0]    = sq_entry_pop_to_ce_grnt_b[SQ_ENTRY-1:0]         //no need modify   LTL@20241017
                                                & sq_entry_age_vec_create[SQ_ENTRY-1:0];
//---------------------pop sel------------------------------
// &CombBeg; @588
//always @( sq_entry_age_vec[11:0])             //parameter below, LTL@20241022
//begin
//sq_entry_age_vec_1[SQ_ENTRY-1:0]  = 12'hfff;
//casez(sq_entry_age_vec[SQ_ENTRY-1:0])
//  12'b????_????_???1:sq_entry_age_vec_1[0]  = 1'b0;
//  12'b????_????_??10:sq_entry_age_vec_1[1]  = 1'b0;
//  12'b????_????_?100:sq_entry_age_vec_1[2]  = 1'b0;
//  12'b????_????_1000:sq_entry_age_vec_1[3]  = 1'b0;
//  12'b????_???1_0000:sq_entry_age_vec_1[4]  = 1'b0;
//  12'b????_??10_0000:sq_entry_age_vec_1[5]  = 1'b0;
//  12'b????_?100_0000:sq_entry_age_vec_1[6]  = 1'b0;
//  12'b????_1000_0000:sq_entry_age_vec_1[7]  = 1'b0;
//  12'b???1_0000_0000:sq_entry_age_vec_1[8]  = 1'b0;
//  12'b??10_0000_0000:sq_entry_age_vec_1[9]  = 1'b0;
//  12'b?100_0000_0000:sq_entry_age_vec_1[10]  = 1'b0;
//  12'b1000_0000_0000:sq_entry_age_vec_1[11]  = 1'b0;
//  default:sq_entry_age_vec_1[SQ_ENTRY-1:0]  = 12'hfff;
//endcase
//// &CombEnd; @605
//end


always_comb begin                             //instead case, LTL@20241022
  c_first_1[SQ_ENTRY-1:0] = {SQ_ENTRY{1'b0}};
  sq_entry_age_vec_1[0] = !sq_entry_age_vec[0];
  sq_entry_age_vec_1[SQ_ENTRY-1:1]  = {(SQ_ENTRY-1){1'b1}};
  for(int i=1;i<SQ_ENTRY;i++) begin
    for(int j=0;j<i;j++) begin
      c_first_1[i] = c_first_1[i] | sq_entry_age_vec[j];
    end
    sq_entry_age_vec_1[i] = (!sq_entry_age_vec[i]) | c_first_1[i];
  end
end


assign sq_entry_age_vec_less2 = !(|(sq_entry_age_vec[SQ_ENTRY-1:0]  & sq_entry_age_vec_1[SQ_ENTRY-1:0]));
assign sq_entry_age_vec_zero  = !(|sq_entry_age_vec[SQ_ENTRY-1:0]);
assign sq_entry_age_vec_zero_ptr      = sq_entry_vld
                                        &&  !sq_entry_in_wmb_ce
                                        &&  sq_entry_age_vec_zero;
assign sq_entry_age_vec_surplus1_ptr  = sq_entry_vld
                                        &&  !sq_entry_in_wmb_ce
                                        &&  sq_entry_age_vec_less2
                                        &&  !sq_entry_age_vec_zero;
//---------------------pop req------------------------------
assign sq_entry_pop_req = sq_pop_ptr
                          &&  sq_entry_vld
                          &&  sq_entry_cmit
                          &&  sq_entry_data_vld
                          &&  sq_entry_no_restart
                          &&  !sq_entry_in_wmb_ce;
//---------------------send to st_stride for prefetch training------------------------------
assign sq_entry_already_send_st_stride_set =  sq_entry_vld
                                              && (!sq_entry_wo_st_inst          //no consider SO
                                                  || !sq_entry_init_dcache_miss
                                                  || sq_entry_st_stride_age_vec_zero_ptr );

assign sq_entry_st_stride_age_vec_zero = !(|(sq_entry_age_vec[SQ_ENTRY-1:0] & (~sq_entry_already_st_stride_vec[SQ_ENTRY-1:0])));  //no older and !already_st_stride, LTL@st_stride
assign sq_entry_st_stride_age_vec_zero_ptr = sq_entry_vld 
                                             && sq_entry_cmit
                                             && sq_entry_wo_st_inst
                                             && !sq_entry_already_send_st_stride
                                             && sq_entry_st_stride_age_vec_zero;
//==========================================================
//                 Dependency check
//==========================================================

// No.    ld pipe         sq/wmb          addr  bytes_vld data_vld      manner
// --------------------------------------------------------------------------
// 1      ld              st              :4    part      x             discard
// 2      ld atomic       any             x     x         x             discard
// 3      ld              atomic          :4    do        x             discard
// 4      ld bond(addr1)  st only boud 1  :4    do bv1    x             discard
// 5      ld              st              :4    exact     0 bypass rf   forward bypass
// 6      ld              st              :4    whole     0 exclude 5   data discard
// 7      ld              st              :4    whole     1             forward
// 8      ld(addr1)       st              :4    x         x             !acclr_en


//-----------iid compare----------------
//sq_entry older than ld_dc
// &Instance("wk_rtu_compare_iid","x_lsu_sq_entry_compare_ld_dc_iid"); @641
xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH))
x_lsu_sq_entry_compare_ldc0_iid0 (                       //1->3, for 3 ld
  .x_iid0                        (sq_entry_iid[IID_WIDTH-1:0]            ),
  .x_iid0_older                  (sq_entry_iid_older_than_ldc0),
  .x_iid1                        (ldc0_ex2_iid[IID_WIDTH-1:0]               )
);
xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH))
x_lsu_sq_entry_compare_lsdc0_iid1 (
  .x_iid0                        (sq_entry_iid[IID_WIDTH-1:0]            ),
  .x_iid0_older                  (sq_entry_iid_older_than_lsdc0),
  .x_iid1                        (lsdc0_ex2_ld_iid[IID_WIDTH-1:0]               )
);
xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH))
x_lsu_sq_entry_compare_lsdc1_iid2 (
  .x_iid0                        (sq_entry_iid[IID_WIDTH-1:0]            ),
  .x_iid0_older                  (sq_entry_iid_older_than_lsdc1),
  .x_iid1                        (lsdc1_ex2_ld_iid[IID_WIDTH-1:0]               )
);
// &Connect( .x_iid0         (sq_entry_iid[6:0]      ), @642
//           .x_iid1         (ldc0_ex2_iid[6:0]         ), @643
//           .x_iid0_older   (sq_entry_iid_older_than_ld_dc)); @644

assign sq_entry_older_than_ldc0  = sq_entry_iid_older_than_ldc0       //1->3 for 3 ld dc 
                                    ||  sq_entry_cmit;                            
assign sq_entry_older_than_lsdc0  = sq_entry_iid_older_than_lsdc0
                                    ||  sq_entry_cmit;
assign sq_entry_older_than_lsdc1  = sq_entry_iid_older_than_lsdc1
                                    ||  sq_entry_cmit;                                    
//-----------addr compare---------------
//addr0 compare
assign sq_entry_from_ldc0_ex2_addr0[WK_PA_WIDTH-1:0]  = ldc0_ex2_addr0[WK_PA_WIDTH-1:0];  //1->3 for 3 ld dc 
assign sq_entry_depd_addr_tto12_hit0   = (sq_entry_addr0[WK_PA_WIDTH-1:12] == sq_entry_from_ldc0_ex2_addr0[WK_PA_WIDTH-1:12]);  //1->3 for 3 ld dc 
assign sq_entry_depd_addr0_11to4_hit0  = sq_entry_addr0[11:4] == sq_entry_from_ldc0_ex2_addr0[11:4];  //1->3 for 3 ld dc 
assign sq_entry_depd_addr1_11to4_hit0  = sq_entry_addr0[11:4] == ldc0_ex2_addr1_11to4[7:0];  //1->3 for 3 ld dc 

assign sq_entry_from_lsdc0_ex2_addr0[WK_PA_WIDTH-1:0]  = lsdc0_ex2_ld_addr0[WK_PA_WIDTH-1:0];
assign sq_entry_depd_addr_tto12_hit1   = (sq_entry_addr0[WK_PA_WIDTH-1:12] == sq_entry_from_lsdc0_ex2_addr0[WK_PA_WIDTH-1:12]);
assign sq_entry_depd_addr0_11to4_hit1  = sq_entry_addr0[11:4] == sq_entry_from_lsdc0_ex2_addr0[11:4];
assign sq_entry_depd_addr1_11to4_hit1  = sq_entry_addr0[11:4] == lsdc0_ex2_addr1_11to4[7:0];

assign sq_entry_from_lsdc1_ex2_addr0[WK_PA_WIDTH-1:0]  = lsdc1_ex2_ld_addr0[WK_PA_WIDTH-1:0];
assign sq_entry_depd_addr_tto12_hit2   = (sq_entry_addr0[WK_PA_WIDTH-1:12] == sq_entry_from_lsdc1_ex2_addr0[WK_PA_WIDTH-1:12]);
assign sq_entry_depd_addr0_11to4_hit2  = sq_entry_addr0[11:4] == sq_entry_from_lsdc1_ex2_addr0[11:4];
assign sq_entry_depd_addr1_11to4_hit2  = sq_entry_addr0[11:4] == lsdc1_ex2_addr1_11to4[7:0];

assign sq_entry_depd_addr_tto4_hit0    = sq_entry_depd_addr_tto12_hit0              //1->3 for 3 ld dc 
                                        &&  sq_entry_depd_addr0_11to4_hit0;
assign sq_entry_depd_addr_tto4_hit1    = sq_entry_depd_addr_tto12_hit1
                                        &&  sq_entry_depd_addr0_11to4_hit1;
assign sq_entry_depd_addr_tto4_hit2    = sq_entry_depd_addr_tto12_hit2
                                        &&  sq_entry_depd_addr0_11to4_hit2;

assign sq_entry_depd_addr_tto6_hit0    = sq_entry_depd_addr_tto12_hit0              //rvv512@LTL
                                        &&  (sq_entry_addr0[11:6] == ldc0_ex2_addr0[11:6]);
assign sq_entry_depd_addr_tto6_hit1    = sq_entry_depd_addr_tto12_hit1
                                        &&  (sq_entry_addr0[11:6] == lsdc0_ex2_ld_addr0[11:6]);
assign sq_entry_depd_addr_tto6_hit2    = sq_entry_depd_addr_tto12_hit2
                                        &&  (sq_entry_addr0[11:6] == lsdc1_ex2_ld_addr0[11:6]);

assign sq_entry_depd_addr1_tto4_hit0   = sq_entry_depd_addr_tto12_hit0
                                        &&  sq_entry_depd_addr1_11to4_hit0;
assign sq_entry_depd_addr1_tto4_hit1   = sq_entry_depd_addr_tto12_hit1
                                        &&  sq_entry_depd_addr1_11to4_hit1;
assign sq_entry_depd_addr1_tto4_hit2   = sq_entry_depd_addr_tto12_hit2
                                        &&  sq_entry_depd_addr1_11to4_hit2;
//-----------bytes_vld compare----------
assign sq_entry_and_ldc0_bytes_vld_hit      = |(sq_entry_bytes_vld[15:0]  & ldc0_ex2_bytes_vld[15:0]);   //1->3, for ld_dc LTL
assign sq_entry_and_lsdc0_bytes_vld_hit      = |(sq_entry_bytes_vld[15:0]  & lsdc0_ex2_ld_bytes_vld[15:0]);
assign sq_entry_and_lsdc1_bytes_vld_hit      = |(sq_entry_bytes_vld[15:0]  & lsdc1_ex2_ld_bytes_vld[15:0]);

assign sq_entry_not_and_ldc0_bytes_vld_hit  = |((~sq_entry_bytes_vld[15:0]) & ldc0_ex2_bytes_vld[15:0]);  //1->3, for ld_dc LTL
assign sq_entry_not_and_lsdc0_bytes_vld_hit  = |((~sq_entry_bytes_vld[15:0]) & lsdc0_ex2_ld_bytes_vld[15:0]);
assign sq_entry_not_and_lsdc1_bytes_vld_hit  = |((~sq_entry_bytes_vld[15:0]) & lsdc1_ex2_ld_bytes_vld[15:0]);

assign sq_entry_and_ldc0_bytes_vld1_hit     = |(sq_entry_bytes_vld[15:0]  & ldc0_ex2_bytes_vld1[15:0]);
assign sq_entry_and_lsdc0_bytes_vld1_hit     = |(sq_entry_bytes_vld[15:0]  & lsdc0_ex2_bytes_vld1[15:0]);
assign sq_entry_and_lsdc1_bytes_vld1_hit     = |(sq_entry_bytes_vld[15:0]  & lsdc1_ex2_bytes_vld1[15:0]);

assign sq_entry_and_ldc0_bytes_vld2_hit     = |(sq_entry_bytes_vld[15:0]  & ldc0_ex2_bytes_vld2[15:0]);
assign sq_entry_and_lsdc0_bytes_vld2_hit     = |(sq_entry_bytes_vld[15:0]  & lsdc0_ex2_bytes_vld2[15:0]);
assign sq_entry_and_lsdc1_bytes_vld2_hit     = |(sq_entry_bytes_vld[15:0]  & lsdc1_ex2_bytes_vld2[15:0]);

assign sq_entry_and_ldc0_bytes_vld3_hit     = |(sq_entry_bytes_vld[15:0]  & ldc0_ex2_bytes_vld3[15:0]);
assign sq_entry_and_lsdc0_bytes_vld3_hit     = |(sq_entry_bytes_vld[15:0]  & lsdc0_ex2_bytes_vld3[15:0]);
assign sq_entry_and_lsdc1_bytes_vld3_hit     = |(sq_entry_bytes_vld[15:0]  & lsdc1_ex2_bytes_vld3[15:0]);
//example:
//depd_bytes_vld          ld_dc_ex2_bytes_vld     depd kinds
//1111                    0011                do & whole
//0011                    0011                do & whole
//0110                    0011                do & part
//0110                    1111                do & part
//1100                    0011                /

assign sq_entry_depd_do_hit0         = sq_entry_and_ldc0_bytes_vld_hit;   //1->3, for ld_dc LTL
assign sq_entry_depd_do_hit1         = sq_entry_and_lsdc0_bytes_vld_hit; 
assign sq_entry_depd_do_hit2         = sq_entry_and_lsdc1_bytes_vld_hit;

assign sq_entry_depd_whole_hit0      = sq_entry_and_ldc0_bytes_vld_hit        //1->3, for ld_dc LTL
                                      &&  !sq_entry_not_and_ldc0_bytes_vld_hit;
assign sq_entry_depd_whole_hit1      = sq_entry_and_lsdc0_bytes_vld_hit
                                      &&  !sq_entry_not_and_lsdc0_bytes_vld_hit;
assign sq_entry_depd_whole_hit2      = sq_entry_and_lsdc1_bytes_vld_hit
                                      &&  !sq_entry_not_and_lsdc1_bytes_vld_hit;

assign sq_entry_depd_part_hit0       = sq_entry_and_ldc0_bytes_vld_hit        //1->3, for ld_dc LTL
                                      &&  sq_entry_not_and_ldc0_bytes_vld_hit;
assign sq_entry_depd_part_hit1       = sq_entry_and_lsdc0_bytes_vld_hit
                                      &&  sq_entry_not_and_lsdc0_bytes_vld_hit;
assign sq_entry_depd_part_hit2       = sq_entry_and_lsdc1_bytes_vld_hit
                                      &&  sq_entry_not_and_lsdc1_bytes_vld_hit;

assign sq_entry_depd_exawk_hit0      = (sq_entry_bytes_vld[15:0] == ldc0_ex2_bytes_vld[15:0]);           //1->3, for ld_dc LTL
assign sq_entry_depd_exawk_hit1      = (sq_entry_bytes_vld[15:0] == lsdc0_ex2_ld_bytes_vld[15:0]);
assign sq_entry_depd_exawk_hit2      = (sq_entry_bytes_vld[15:0] == lsdc1_ex2_ld_bytes_vld[15:0]);

assign sq_entry_depd_bv1_do_hit0    = sq_entry_and_ldc0_bytes_vld1_hit;           //1->3, for ld_dc LTL
assign sq_entry_depd_bv1_do_hit1    = sq_entry_and_lsdc0_bytes_vld1_hit;
assign sq_entry_depd_bv1_do_hit2    = sq_entry_and_lsdc1_bytes_vld1_hit;

//-------------data vld----------------
assign sq_entry_data_vld_now          = sq_entry_data_vld             //no need modify, LTL
                                        ||  sq_entry_data_set;
//------------------situation 0----------------------------- //depd for unistride, LTL
assign sq_entry_depd_hit0_0   = sq_entry_vld                      
                              &&  ldc0_ex2_chk_ld_inst_vld
                              &&  ldc0_ex2_is_us
                              &&  sq_entry_older_than_ldc0
                              &&  sq_entry_depd_addr_tto6_hit0
                              && ((sq_entry_and_ldc0_bytes_vld_hit && sq_entry_addr0[5:4]==2'b00)
                                  || (sq_entry_and_ldc0_bytes_vld1_hit && sq_entry_addr0[5:4]==2'b01)
                                  || (sq_entry_and_ldc0_bytes_vld2_hit && sq_entry_addr0[5:4]==2'b10)
                                  || (sq_entry_and_ldc0_bytes_vld3_hit && sq_entry_addr0[5:4]==2'b11));
assign sq_entry_depd_hit0_1   = sq_entry_vld
                              &&  lsdc0_ex2_chk_ld_inst_vld
                              &&  lsdc0_ex2_is_us
                              &&  sq_entry_older_than_lsdc0
                              &&  sq_entry_depd_addr_tto6_hit1
                              && ((sq_entry_and_lsdc0_bytes_vld_hit && sq_entry_addr0[5:4]==2'b00)
                                  || (sq_entry_and_lsdc0_bytes_vld1_hit && sq_entry_addr0[5:4]==2'b01)
                                  || (sq_entry_and_lsdc0_bytes_vld2_hit && sq_entry_addr0[5:4]==2'b10)
                                  || (sq_entry_and_lsdc0_bytes_vld3_hit && sq_entry_addr0[5:4]==2'b11));
assign sq_entry_depd_hit0_2   = sq_entry_vld
                              &&  lsdc1_ex2_chk_ld_inst_vld
                              &&  lsdc1_ex2_is_us
                              &&  sq_entry_older_than_lsdc1
                              &&  sq_entry_depd_addr_tto6_hit2
                              && ((sq_entry_and_lsdc1_bytes_vld_hit && sq_entry_addr0[5:4]==2'b00)
                                  || (sq_entry_and_lsdc1_bytes_vld1_hit && sq_entry_addr0[5:4]==2'b01)
                                  || (sq_entry_and_lsdc1_bytes_vld2_hit && sq_entry_addr0[5:4]==2'b10)
                                  || (sq_entry_and_lsdc1_bytes_vld3_hit && sq_entry_addr0[5:4]==2'b11));


//------------------situation 1-----------------------------
assign sq_entry_depd_hit1_0   = sq_entry_vld                             //1->4, for ld_dc LTL
                              &&  sq_entry_wo_st_inst
                              &&  ldc0_ex2_chk_ld_inst_vld
                              &&  !ldc0_ex2_is_us               //rvv512@LTL
                              &&  sq_entry_older_than_ldc0
                              &&  sq_entry_depd_addr_tto4_hit0
                              &&  sq_entry_depd_part_hit0;
assign sq_entry_depd_hit1_1   = sq_entry_vld
                              &&  sq_entry_wo_st_inst
                              &&  lsdc0_ex2_chk_ld_inst_vld
                              &&  !lsdc0_ex2_is_us               //rvv512@LTL
                              &&  sq_entry_older_than_lsdc0
                              &&  sq_entry_depd_addr_tto4_hit1
                              &&  sq_entry_depd_part_hit1;
assign sq_entry_depd_hit1_2   = sq_entry_vld
                              &&  sq_entry_wo_st_inst
                              &&  lsdc1_ex2_chk_ld_inst_vld
                              &&  !lsdc1_ex2_is_us               //rvv512@LTL
                              &&  sq_entry_older_than_lsdc1
                              &&  sq_entry_depd_addr_tto4_hit2
                              &&  sq_entry_depd_part_hit2;
//------------------situation 2-----------------------------
assign sq_entry_depd_hit2_0   = sq_entry_vld                    //1->3, for ld_dc LTL
                              &&  ldc0_ex2_chk_atomic_inst_vld
                              &&  sq_entry_older_than_ldc0;
assign sq_entry_depd_hit2_1   = sq_entry_vld
                              &&  lsdc0_ex2_chk_atomic_inst_vld
                              &&  sq_entry_older_than_lsdc0;                                                            
assign sq_entry_depd_hit2_2   = sq_entry_vld
                              &&  lsdc1_ex2_chk_atomic_inst_vld
                              &&  sq_entry_older_than_lsdc1;
//------------------situation 3-----------------------------
assign sq_entry_depd_hit3_0   = sq_entry_vld                    //1->3, for ld_dc LTL
                              &&  sq_entry_atomic
                              &&  ldc0_ex2_chk_ld_inst_vld
                              &&  !ldc0_ex2_is_us               //rvv512@LTL
                              &&  sq_entry_older_than_ldc0
                              &&  sq_entry_depd_addr_tto4_hit0
                              &&  sq_entry_depd_do_hit0;
assign sq_entry_depd_hit3_1   = sq_entry_vld
                              &&  sq_entry_atomic
                              &&  lsdc0_ex2_chk_ld_inst_vld
                              &&  !lsdc0_ex2_is_us               //rvv512@LTL
                              &&  sq_entry_older_than_lsdc0
                              &&  sq_entry_depd_addr_tto4_hit1
                              &&  sq_entry_depd_do_hit1;
assign sq_entry_depd_hit3_2   = sq_entry_vld
                              &&  sq_entry_atomic
                              &&  lsdc1_ex2_chk_ld_inst_vld
                              &&  !lsdc1_ex2_is_us               //rvv512@LTL
                              &&  sq_entry_older_than_lsdc1
                              &&  sq_entry_depd_addr_tto4_hit2
                              &&  sq_entry_depd_do_hit2;
//------------------situation 4-----------------------------
//for reducing spec fail when boundary ld st
assign sq_entry_depd_hit4_0   = sq_entry_vld                 //1->3, for 3 ld_dc LTL
                              &&  sq_entry_wo_st_inst
                              &&  ldc0_ex2_chk_ld_addr1_vld
                              &&  !ldc0_ex2_is_us               //rvv512@LTL
                              &&  sq_entry_older_than_ldc0
                              &&  sq_entry_bond_first_only
                              &&  sq_entry_depd_addr1_tto4_hit0
                              &&  sq_entry_depd_bv1_do_hit0; 
assign sq_entry_depd_hit4_1   = sq_entry_vld
                              &&  sq_entry_wo_st_inst
                              &&  lsdc0_ex2_chk_ld_addr1_vld
                              &&  !lsdc0_ex2_is_us               //rvv512@LTL
                              &&  sq_entry_older_than_lsdc0
                              &&  sq_entry_bond_first_only
                              &&  sq_entry_depd_addr1_tto4_hit1
                              &&  sq_entry_depd_bv1_do_hit1;
assign sq_entry_depd_hit4_2   = sq_entry_vld
                              &&  sq_entry_wo_st_inst
                              &&  lsdc1_ex2_chk_ld_addr1_vld
                              &&  !lsdc1_ex2_is_us               //rvv512@LTL
                              &&  sq_entry_older_than_lsdc1
                              &&  sq_entry_bond_first_only
                              &&  sq_entry_depd_addr1_tto4_hit2
                              &&  sq_entry_depd_bv1_do_hit2;
//------------------situation 5-----------------------------
//rf st_data bypass
assign sq_entry_depd_hit5_0_0   = sq_entry_vld                     //1->3, for 3 ld_dc LTL
                              &&  sq_entry_wo_st_inst
                              &&  (std0_sq_rf_inst_vld_short && sq_entry_sdid_hit0)       //0 for std0, LTL@20241021
                              &&  !sq_entry_boundary
                              &&  !sq_entry_inst_vls         //no need 1->2, LTL@20241112
                              &&  ldc0_sq_ex2_chk_ld_bypass_vld
                              &&  !ldc0_ex2_is_us               //rvv512@LTL
                              &&  sq_entry_older_than_ldc0
                              &&  sq_entry_depd_addr_tto4_hit0
                              &&  sq_entry_depd_exawk_hit0
                              &&  !sq_entry_data_vld;  //
assign sq_entry_depd_hit5_0_1   = sq_entry_vld                     //1->3, for 3 ld_dc LTL
                              &&  sq_entry_wo_st_inst
                              &&  (std1_sq_rf_inst_vld_short &&  sq_entry_sdid_hit1)       //1 for std1, LTL@20241021
                              &&  !sq_entry_boundary
                              &&  !sq_entry_inst_vls           //no need 1->2, LTL@20241112
                              &&  ldc0_sq_ex2_chk_ld_bypass_vld
                              &&  !ldc0_ex2_is_us               //rvv512@LTL
                              &&  sq_entry_older_than_ldc0
                              &&  sq_entry_depd_addr_tto4_hit0
                              &&  sq_entry_depd_exawk_hit0
                              &&  !sq_entry_data_vld;  //
assign sq_entry_depd_hit5_0     =  sq_entry_depd_hit5_0_0 || sq_entry_depd_hit5_0_1;    //1->2 for 2 st data, LTL@20241101                         
                            
assign sq_entry_depd_hit5_1_0   = sq_entry_vld
                              &&  sq_entry_wo_st_inst
                              &&  (std0_sq_rf_inst_vld_short && sq_entry_sdid_hit0)       //0 for std0, LTL@20241101
                              &&  !sq_entry_boundary
                              &&  !sq_entry_inst_vls              //no need 1->2, LTL@20241112
                              &&  lsdc0_sq_ex2_chk_ld_bypass_vld
                              &&  !lsdc0_ex2_is_us               //rvv512@LTL
                              &&  sq_entry_older_than_lsdc0
                              &&  sq_entry_depd_addr_tto4_hit1
                              &&  sq_entry_depd_exawk_hit1
                              &&  !sq_entry_data_vld;
assign sq_entry_depd_hit5_1_1   = sq_entry_vld
                              &&  sq_entry_wo_st_inst
                              &&  (std1_sq_rf_inst_vld_short &&  sq_entry_sdid_hit1)       //1 for std1, LTL@20241101
                              &&  !sq_entry_boundary
                              &&  !sq_entry_inst_vls             //no need 1->2, LTL@20241112      
                              &&  lsdc0_sq_ex2_chk_ld_bypass_vld
                              &&  !lsdc0_ex2_is_us               //rvv512@LTL
                              &&  sq_entry_older_than_lsdc0
                              &&  sq_entry_depd_addr_tto4_hit1
                              &&  sq_entry_depd_exawk_hit1
                              &&  !sq_entry_data_vld;
assign sq_entry_depd_hit5_1     =  sq_entry_depd_hit5_1_0 || sq_entry_depd_hit5_1_1;                              
assign sq_entry_depd_hit5_2_0   = sq_entry_vld
                              &&  sq_entry_wo_st_inst
                              &&  (std0_sq_rf_inst_vld_short && sq_entry_sdid_hit0)       //one is okay, consider std0 and 1, LTL@20241021
                              &&  !sq_entry_boundary
                              &&  !sq_entry_inst_vls
                              &&  lsdc1_sq_ex2_chk_ld_bypass_vld
                              &&  !lsdc1_ex2_is_us               //rvv512@LTL
                              &&  sq_entry_older_than_lsdc1
                              &&  sq_entry_depd_addr_tto4_hit2
                              &&  sq_entry_depd_exawk_hit2
                              &&  !sq_entry_data_vld;
assign sq_entry_depd_hit5_2_1   = sq_entry_vld
                              &&  sq_entry_wo_st_inst
                              &&  (std1_sq_rf_inst_vld_short &&  sq_entry_sdid_hit1)       //one is okay, consider std0 and 1, LTL@20241021
                              &&  !sq_entry_boundary
                              &&  !sq_entry_inst_vls
                              &&  lsdc1_sq_ex2_chk_ld_bypass_vld
                              &&  !lsdc1_ex2_is_us               //rvv512@LTL
                              &&  sq_entry_older_than_lsdc1
                              &&  sq_entry_depd_addr_tto4_hit2
                              &&  sq_entry_depd_exawk_hit2
                              &&  !sq_entry_data_vld;
assign sq_entry_depd_hit5_2     =  sq_entry_depd_hit5_2_0 || sq_entry_depd_hit5_2_1; 
//------------------situation 6-----------------------------
//data discard
assign sq_entry_depd_hit6_0   = sq_entry_vld                           //1->3, for 3 ld_dc LTL
                              &&  sq_entry_wo_st_inst
                              &&  ldc0_ex2_chk_ld_inst_vld
                              &&  !ldc0_ex2_is_us               //rvv512@LTL
                              &&  sq_entry_older_than_ldc0
                              &&  sq_entry_depd_addr_tto4_hit0
                              &&  !sq_entry_data_vld_now
                              &&  sq_entry_depd_whole_hit0;
assign sq_entry_depd_hit6_1   = sq_entry_vld                           //1->3, for 3 ld_dc LTL
                              &&  sq_entry_wo_st_inst
                              &&  lsdc0_ex2_chk_ld_inst_vld
                              &&  !lsdc0_ex2_is_us               //rvv512@LTL
                              &&  sq_entry_older_than_lsdc0
                              &&  sq_entry_depd_addr_tto4_hit1
                              &&  !sq_entry_data_vld_now
                              &&  sq_entry_depd_whole_hit1;
assign sq_entry_depd_hit6_2   = sq_entry_vld                           //1->3, for 3 ld_dc LTL
                              &&  sq_entry_wo_st_inst
                              &&  lsdc1_ex2_chk_ld_inst_vld
                              &&  !lsdc1_ex2_is_us               //rvv512@LTL
                              &&  sq_entry_older_than_lsdc1
                              &&  sq_entry_depd_addr_tto4_hit2
                              &&  !sq_entry_data_vld_now
                              &&  sq_entry_depd_whole_hit2;
//------------------situation 7-----------------------------
assign sq_entry_depd_hit7_0   = sq_entry_vld           //1->3, for 3 ld_dc LTL
                              &&  sq_entry_wo_st_inst
                              &&  ldc0_ex2_chk_ld_inst_vld
                              &&  !ldc0_ex2_is_us               //rvv512@LTL
                              &&  sq_entry_older_than_ldc0
                              &&  sq_entry_depd_addr_tto4_hit0
                              &&  sq_entry_data_vld_now
                              &&  sq_entry_depd_whole_hit0;
assign sq_entry_depd_hit7_1   = sq_entry_vld
                              &&  sq_entry_wo_st_inst
                              &&  lsdc0_ex2_chk_ld_inst_vld
                              &&  !lsdc0_ex2_is_us               //rvv512@LTL
                              &&  sq_entry_older_than_lsdc0
                              &&  sq_entry_depd_addr_tto4_hit1
                              &&  sq_entry_data_vld_now
                              &&  sq_entry_depd_whole_hit1;
assign sq_entry_depd_hit7_2   = sq_entry_vld
                              &&  sq_entry_wo_st_inst
                              &&  lsdc1_ex2_chk_ld_inst_vld
                              &&  !lsdc1_ex2_is_us               //rvv512@LTL
                              &&  sq_entry_older_than_lsdc1
                              &&  sq_entry_depd_addr_tto4_hit2
                              &&  sq_entry_data_vld_now
                              &&  sq_entry_depd_whole_hit2;

assign sq_entry_newest_fwd_req_data_vld0 = sq_entry_vld              //1->3, for 3 ld_dc LTL
                                          //&&  sq_entry_same_addr_newest
                                          &&  sq_entry_older_than_ldc0_same_addr_newest
                                          &&  sq_entry_wo_st_inst
                                          &&  ldc0_ex2_chk_ld_inst_vld
                                          &&  !ldc0_ex2_is_us               //rvv512@LTL
                                          &&  sq_entry_older_than_ldc0
                                          &&  sq_entry_depd_addr_tto4_hit0
                                          &&  sq_entry_data_vld
                                          &&  sq_entry_depd_whole_hit0;
assign sq_entry_newest_fwd_req_data_vld1 = sq_entry_vld
                                          //&&  sq_entry_same_addr_newest
                                          &&  sq_entry_older_than_lsdc0_same_addr_newest
                                          &&  sq_entry_wo_st_inst
                                          &&  lsdc0_ex2_chk_ld_inst_vld
                                          &&  !lsdc0_ex2_is_us               //rvv512@LTL
                                          &&  sq_entry_older_than_lsdc0
                                          &&  sq_entry_depd_addr_tto4_hit1
                                          &&  sq_entry_data_vld
                                          &&  sq_entry_depd_whole_hit1;
assign sq_entry_newest_fwd_req_data_vld2 = sq_entry_vld
                                          //&&  sq_entry_same_addr_newest
                                          &&  sq_entry_older_than_lsdc1_same_addr_newest
                                          &&  sq_entry_wo_st_inst
                                          &&  lsdc1_ex2_chk_ld_inst_vld
                                          &&  !lsdc1_ex2_is_us               //rvv512@LTL
                                          &&  sq_entry_older_than_lsdc1
                                          &&  sq_entry_depd_addr_tto4_hit2
                                          &&  sq_entry_data_vld
                                          &&  sq_entry_depd_whole_hit2;


assign sq_entry_newest_fwd_req_data_vld_short0 = sq_entry_vld             //1->3, for 3 ld_dc LTL
                                          //&&  sq_entry_same_addr_newest
                                          &&  sq_entry_older_than_ldc0_same_addr_newest
                                          &&  sq_entry_wo_st_inst
                                          &&  ldc0_ex2_chk_ld_inst_vld
                                          &&  !ldc0_ex2_is_us               //rvv512@LTL
                                          &&  sq_entry_older_than_ldc0
                                          &&  sq_entry_depd_addr0_11to4_hit0
                                          &&  sq_entry_data_vld;
assign sq_entry_newest_fwd_req_data_vld_short1 = sq_entry_vld
                                          //&&  sq_entry_same_addr_newest
                                          &&  sq_entry_older_than_lsdc0_same_addr_newest
                                          &&  sq_entry_wo_st_inst
                                          &&  lsdc0_ex2_chk_ld_inst_vld
                                          &&  !lsdc0_ex2_is_us               //rvv512@LTL
                                          &&  sq_entry_older_than_lsdc0
                                          &&  sq_entry_depd_addr0_11to4_hit1
                                          &&  sq_entry_data_vld;
assign sq_entry_newest_fwd_req_data_vld_short2 = sq_entry_vld
                                          //&&  sq_entry_same_addr_newest
                                          &&  sq_entry_older_than_lsdc1_same_addr_newest
                                          &&  sq_entry_wo_st_inst
                                          &&  lsdc1_ex2_chk_ld_inst_vld
                                          &&  !lsdc1_ex2_is_us               //rvv512@LTL
                                          &&  sq_entry_older_than_lsdc1
                                          &&  sq_entry_depd_addr0_11to4_hit2
                                          &&  sq_entry_data_vld;                                          
//------------------situation 8-----------------------------
//for cache buffer acceleration
assign sq_entry_depd_hit8_0   = sq_entry_vld                    //1->3, for 3 ld_dc LTL
                              &&  (sq_entry_wo_st_inst
                                  ||  sq_entry_atomic)
                              &&  sq_entry_older_than_ldc0
                              &&  sq_entry_depd_addr1_tto4_hit0
                              &&  sq_entry_depd_bv1_do_hit0;
assign sq_entry_depd_hit8_1   = sq_entry_vld
                              &&  (sq_entry_wo_st_inst
                                  ||  sq_entry_atomic)
                              &&  sq_entry_older_than_lsdc0
                              &&  sq_entry_depd_addr1_tto4_hit1
                              &&  sq_entry_depd_bv1_do_hit1;
assign sq_entry_depd_hit8_2   = sq_entry_vld
                              &&  (sq_entry_wo_st_inst
                                  ||  sq_entry_atomic)
                              &&  sq_entry_older_than_lsdc1
                              &&  sq_entry_depd_addr1_tto4_hit2
                              &&  sq_entry_depd_bv1_do_hit2;
//------------------cancel ahead wb-------------------------
assign sq_entry_cancel_ahead_wb0 = sq_entry_vld                         //1->3, for 3 ld_dc LTL
                                  &&  (sq_entry_wo_st_inst
                                      ||  sq_entry_atomic)
                                  &&  sq_entry_older_than_ldc0
                                  &&  sq_entry_depd_addr_tto4_hit0
                                  &&  sq_entry_depd_do_hit0;
assign sq_entry_cancel_ahead_wb1 = sq_entry_vld
                                  &&  (sq_entry_wo_st_inst
                                      ||  sq_entry_atomic)
                                  &&  sq_entry_older_than_lsdc0
                                  &&  sq_entry_depd_addr_tto4_hit1
                                  &&  sq_entry_depd_do_hit1;
assign sq_entry_cancel_ahead_wb2 = sq_entry_vld
                                  &&  (sq_entry_wo_st_inst
                                      ||  sq_entry_atomic)
                                  &&  sq_entry_older_than_lsdc1
                                  &&  sq_entry_depd_addr_tto4_hit2
                                  &&  sq_entry_depd_do_hit2;
//------------------combine---------------------------------
assign sq_entry_discard_req0       = sq_entry_depd_hit0_0    //rvv512@LTL
                                    ||  sq_entry_depd_hit1_0   //1->3  LTL@20241024
                                    ||  sq_entry_depd_hit2_0
                                    ||  sq_entry_depd_hit3_0
                                    ||  sq_entry_depd_hit4_0;
assign sq_entry_discard_req1       = sq_entry_depd_hit0_1    //rvv512@LTL
                                    ||  sq_entry_depd_hit1_1
                                    ||  sq_entry_depd_hit2_1
                                    ||  sq_entry_depd_hit3_1
                                    ||  sq_entry_depd_hit4_1;
assign sq_entry_discard_req2       = sq_entry_depd_hit0_2   //rvv512@LTL
                                    || sq_entry_depd_hit1_2
                                    ||  sq_entry_depd_hit2_2
                                    ||  sq_entry_depd_hit3_2
                                    ||  sq_entry_depd_hit4_2;

assign sq_entry_addr1_dep_discard0 = sq_entry_depd_hit4_0;  //1->3  LTL@20241024
assign sq_entry_addr1_dep_discard1 = sq_entry_depd_hit4_1;
assign sq_entry_addr1_dep_discard2 = sq_entry_depd_hit4_2;

assign sq_entry_fwd_bypass_req0    = sq_entry_depd_hit5_0_0 || sq_entry_depd_hit5_0_1; //1->3  LTL@20241024
assign sq_entry_fwd_bypass_req1    = sq_entry_depd_hit5_1_0 || sq_entry_depd_hit5_1_1;
assign sq_entry_fwd_bypass_req2    = sq_entry_depd_hit5_2_0 || sq_entry_depd_hit5_2_1;


assign sq_entry_fwd_bypass_req_sel_0    = ({sq_entry_depd_hit5_0_0, sq_entry_depd_hit5_0_1} == 2'b01); //2bit->1bit LTL@20250530
assign sq_entry_fwd_bypass_req_sel_1    = ({sq_entry_depd_hit5_1_0, sq_entry_depd_hit5_1_1} == 2'b01);
assign sq_entry_fwd_bypass_req_sel_2    = ({sq_entry_depd_hit5_2_0, sq_entry_depd_hit5_2_1} == 2'b01);

assign sq_entry_fwd_bypass_req0_newer = sq_entry_fwd_bypass_req0 && (|(sq_entry_fwd_bypass_req0_vec[SQ_ENTRY-1:0] & sq_entry_age_vec[SQ_ENTRY-1:0]));   //if |(&)=1, means an older one satisfy bypass_fwd, LTL@20250529 
assign sq_entry_fwd_bypass_req1_newer = sq_entry_fwd_bypass_req1 && (|(sq_entry_fwd_bypass_req1_vec[SQ_ENTRY-1:0] & sq_entry_age_vec[SQ_ENTRY-1:0]));   //if |(&)=1, means an older one satisfy bypass_fwd, LTL@20250529 
assign sq_entry_fwd_bypass_req2_newer = sq_entry_fwd_bypass_req2 && (|(sq_entry_fwd_bypass_req2_vec[SQ_ENTRY-1:0] & sq_entry_age_vec[SQ_ENTRY-1:0]));   //if |(&)=1, means an older one satisfy bypass_fwd, LTL@20250529 

assign sq_entry_data_discard_req_short0  = sq_entry_depd_hit6_0;  //1->3  LTL@20241024
assign sq_entry_data_discard_req_short1  = sq_entry_depd_hit6_1;
assign sq_entry_data_discard_req_short2  = sq_entry_depd_hit6_2;

assign sq_entry_data_discard_req0  = sq_entry_depd_hit6_0   //1->3  LTL@20241024
                                    &&  !sq_entry_depd_hit5_0;
assign sq_entry_data_discard_req1  = sq_entry_depd_hit6_1
                                    &&  !sq_entry_depd_hit5_1;
assign sq_entry_data_discard_req2  = sq_entry_depd_hit6_2
                                    &&  !sq_entry_depd_hit5_2;

assign sq_entry_fwd_req0           = sq_entry_depd_hit7_0;  //1->3  LTL@20241024
assign sq_entry_fwd_req1           = sq_entry_depd_hit7_1;
assign sq_entry_fwd_req2           = sq_entry_depd_hit7_2;

assign sq_entry_cancel_acc_req0    = sq_entry_depd_hit8_0;
assign sq_entry_cancel_acc_req1    = sq_entry_depd_hit8_1;
assign sq_entry_cancel_acc_req2    = sq_entry_depd_hit8_2;

assign sq_entry_older_than_ldc0_same_addr_newest  = sq_entry_ldc0_same_addr_older && (~(|(sq_entry_same_addr_older_than_ldc0_vec & ~sq_entry_age_vec[SQ_ENTRY-1:0])));
assign sq_entry_older_than_lsdc0_same_addr_newest = sq_entry_lsdc0_same_addr_older && (~(|(sq_entry_same_addr_older_than_lsdc0_vec & ~sq_entry_age_vec[SQ_ENTRY-1:0])));
assign sq_entry_older_than_lsdc1_same_addr_newest = sq_entry_lsdc1_same_addr_older && (~(|(sq_entry_same_addr_older_than_lsdc1_vec & ~sq_entry_age_vec[SQ_ENTRY-1:0])));

//-------------------set depd signal------------------------
assign sq_entry_depd_set0      = sq_entry_discard_req0   //1->3  LTL@20241024
                                ||  sq_entry_fwd_multi_depd_set0;
assign sq_entry_depd_set1      = sq_entry_discard_req1
                                ||  sq_entry_fwd_multi_depd_set1;
assign sq_entry_depd_set2      = sq_entry_discard_req2
                                ||  sq_entry_fwd_multi_depd_set2;



assign sq_entry_data_depd_wakeup_vld  = sq_entry_data_set                             //no need split into 4 for 4 queues, data ready, LTL
                                        ||  sq_entry_data_set_ff;


assign sq_entry_data_depd_wakeup_vld_with_flush = sq_entry_data_depd_wakeup_vld
                                                  && ~(rtu_ck_flush && rtu_ck_flush_iid_older_than_entry);


assign sq_entry_data_depd_wakeup0[LSIQ_ENTRY-1:0]  = rtu_ck_flush   //ck_flush send out all data_wakeup queue, ck_flush@LTL
                                                    ? ({LSIQ_ENTRY{sq_entry_data_discard_grnt0}} & lda0_ex3_lsid[LSIQ_ENTRY-1:0])
                                                      | sq_entry_wakeup_queue0[LSIQ_ENTRY-1:0]
                                                    : {LSIQ_ENTRY{sq_entry_data_depd_wakeup_vld_with_flush}}  //ck_flush@LTL
                                                    & sq_entry_wakeup_queue0[LSIQ_ENTRY-1:0];
assign sq_entry_data_depd_wakeup1[LSIQ_ENTRY-1:0]  = rtu_ck_flush   //ck_flush send out all data_wakeup queue, ck_flush@LTL
                                                    ? ({LSIQ_ENTRY{sq_entry_data_discard_grnt1}} & lsda0_ex3_lsid[LSIQ_ENTRY-1:0])
                                                      | sq_entry_wakeup_queue1[LSIQ_ENTRY-1:0]
                                                    : {LSIQ_ENTRY{sq_entry_data_depd_wakeup_vld_with_flush}}
                                                    & sq_entry_wakeup_queue1[LSIQ_ENTRY-1:0];
assign sq_entry_data_depd_wakeup2[LSIQ_ENTRY-1:0]  = rtu_ck_flush   //ck_flush send out all data_wakeup queue, ck_flush@LTL
                                                    ? ({LSIQ_ENTRY{sq_entry_data_discard_grnt2}} & lsda1_ex3_lsid[LSIQ_ENTRY-1:0])
                                                      | sq_entry_wakeup_queue2[LSIQ_ENTRY-1:0]
                                                    : {LSIQ_ENTRY{sq_entry_data_depd_wakeup_vld_with_flush}}
                                                    & sq_entry_wakeup_queue2[LSIQ_ENTRY-1:0];                                              
//==========================================================
//                 Generate pop signal
//==========================================================
assign sq_entry_flush_pop_vld = (rtu_yy_xx_flush || sq_entry_vld && rtu_ck_flush && rtu_ck_flush_iid_older_than_entry)  //flush younger and no_cmit entry, ck_flush@LTL
                                &&  !sq_entry_cmit;
//if pmp deny, then create sq and then pop sq
assign sq_entry_expt_pop_vld  = sq_entry_vld
                                &&  sq_entry_expt_nop
                                &&  sq_entry_pop_to_ce_grnt;   

assign sq_entry_pop_vld       = sq_entry_vld
                                &&  sq_entry_in_wmb_ce
                                &&  wmb_sq_pop_grnt;

//=========================================================,4
//                 Generate interface
//==========================================================
//-----------------------input------------------------------
//-----------create signal--------------
assign sq_entry_create_vld0          = sq_entry_create_vld0_x;
assign sq_entry_create_vld1          = sq_entry_create_vld1_x;
assign sq_entry_create_dp_vld0       = sq_entry_create_dp_vld0_x;
assign sq_entry_create_dp_vld1       = sq_entry_create_dp_vld1_x;
assign sq_entry_create_gateclk_en0   = sq_entry_create_gateclk_en0_x;  //1->2, LTL
assign sq_entry_create_gateclk_en1   = sq_entry_create_gateclk_en1_x;
assign sq_pop_ptr                   = sq_pop_ptr_x;
//-----------grnt signal----------------
assign sq_entry_data_discard_grnt0   = sq_entry_data_discard_grnt0_x;  //1->3, LTL
assign sq_entry_data_discard_grnt1   = sq_entry_data_discard_grnt1_x;
assign sq_entry_data_discard_grnt2   = sq_entry_data_discard_grnt2_x;
assign sq_entry_data_discard_grnt   = sq_entry_data_discard_grnt0     //1->3, grnt merge 3 input, LTL
                                      || sq_entry_data_discard_grnt1
                                      || sq_entry_data_discard_grnt2;
assign sq_entry_fwd_multi_depd_set0  = sq_entry_fwd_multi_depd_set0_x;
assign sq_entry_fwd_multi_depd_set1  = sq_entry_fwd_multi_depd_set1_x;
assign sq_entry_fwd_multi_depd_set2  = sq_entry_fwd_multi_depd_set2_x;
assign sq_entry_pop_to_ce_grnt      = sq_entry_pop_to_ce_grnt_x;
//-----------------------output-----------------------------
//-----------sq entry signal------------
assign sq_entry_vld_x               = sq_entry_vld;
assign sq_entry_inst_hit0_x          = sq_entry_inst_hit0;    //1->2, LTL
assign sq_entry_inst_hit1_x          = sq_entry_inst_hit1;
assign sq_entry_sync_fence_x        = sq_entry_sync_fence;
assign sq_entry_atomic_x            = sq_entry_atomic;
assign sq_entry_icc_x               = sq_entry_icc;
assign sq_entry_preg_v[PREG-1:0]    = sq_entry_preg[PREG-1:0];            
assign sq_entry_inst_flush_x        = sq_entry_inst_flush;
assign sq_entry_inst_type_v[1:0]    = sq_entry_inst_type[1:0];
assign sq_entry_inst_size_v[2:0]    = sq_entry_inst_size[2:0];
assign sq_entry_inst_mode_v[1:0]    = sq_entry_inst_mode[1:0];
assign sq_entry_fence_mode_v[3:0]   = sq_entry_fence_mode[3:0];
assign sq_entry_iid_v[IID_WIDTH-1:0] = sq_entry_iid[IID_WIDTH-1:0];
assign sq_entry_page_share_x        = sq_entry_page_share;
assign sq_entry_page_so_x           = sq_entry_page_so;
assign sq_entry_page_ca_x           = sq_entry_page_ca;
assign sq_entry_page_wa_x           = sq_entry_page_wa;
assign sq_entry_page_buf_x          = sq_entry_page_buf;
assign sq_entry_page_sec_x          = sq_entry_page_sec;
assign sq_entry_same_addr_newest_x  = sq_entry_same_addr_newest;
assign sq_entry_wo_st_x             = sq_entry_wo_st;
assign sq_entry_addr0_v[WK_PA_WIDTH-1:0]  = sq_entry_addr0[WK_PA_WIDTH-1:0];
assign sq_entry_bytes_vld_v[15:0]   = sq_entry_bytes_vld[15:0];
assign sq_entry_spec_fail_x         = sq_entry_spec_fail;
assign sq_entry_vstart_vld_x        = sq_entry_vstart_vld;
assign sq_entry_expt_nop_x          = sq_entry_expt_nop;
assign sq_entry_lm_fail_x           = sq_entry_lm_fail;
assign sq_entry_cmit_data_vld_x     = sq_entry_cmit_data_vld;
assign sq_entry_priv_mode_v[1:0]    = sq_entry_priv_mode[1:0];
assign sq_entry_data_v[127:0]       = sq_entry_data[127:0];
assign sq_entry_rot_sel_v[15:0]     = sq_entry_rot_sel[15:0];  //no need1->2 for 2 st_data, LTL@20241017
assign sq_entry_inst_vls_x          = sq_entry_inst_vls;//no need 1->2 for 2 st_data, LTL@20241017
//assign sq_entry_vsew_v[1:0]         = sq_entry_vsew[1:0]; //no need 1->2 for 2 st_data, LTL@20241017 //rvv1.0@hcl 
assign sq_entry_vmew_v[1:0]         = sq_entry_vmew[1:0];//rvv1.0@hcl
assign sq_entry_vmop_v[1:0]         = sq_entry_vmop[1:0];//rvv1.0@hcl
assign sq_entry_element_size_v[1:0]  = sq_entry_element_size[1:0];  //no need 1->2 for 2 st_data, LTL@20241017
assign sq_entry_idx_order_x         = sq_entry_idx_order;
assign sq_entry_dcache_valid_x      = sq_entry_dcache_valid;
assign sq_entry_dcache_share_x      = sq_entry_dcache_share;
assign sq_entry_dcache_dirty_x      = sq_entry_dcache_dirty;
assign sq_entry_dcache_page_share_x = sq_entry_dcache_page_share;
assign sq_entry_dcache_way_x        = sq_entry_dcache_way;
assign sq_entry_depd_x              = sq_entry_depd;
assign sq_entry_dcache_info_vld_x   = sq_entry_dcache_info_vld;
assign sq_entry_dtcm_hit_x          = sq_entry_dtcm_hit;
assign sq_entry_itcm_hit_x          = sq_entry_itcm_hit;
assign sq_entry_init_dcache_miss_x  = sq_entry_init_dcache_miss;
assign sq_entry_ssp_va_x[1:0]       = sq_entry_ssp_va[1:0];
assign sq_entry_pc_index_x[PC_LEN-1:0] = sq_entry_pc_index[PC_LEN-1:0];
//-----------request--------------------
assign sq_entry_data_depd_wakeup0_v[LSIQ_ENTRY-1:0]  = sq_entry_data_depd_wakeup0[LSIQ_ENTRY-1:0];    //1->3, LTL@20241017
assign sq_entry_data_depd_wakeup1_v[LSIQ_ENTRY-1:0]  = sq_entry_data_depd_wakeup1[LSIQ_ENTRY-1:0];
assign sq_entry_data_depd_wakeup2_v[LSIQ_ENTRY-1:0]  = sq_entry_data_depd_wakeup2[LSIQ_ENTRY-1:0];
assign sq_entry_discard_req0_x       = sq_entry_discard_req0;    //1->3, LTL@20241017
assign sq_entry_discard_req1_x       = sq_entry_discard_req1;
assign sq_entry_discard_req2_x       = sq_entry_discard_req2;
assign sq_entry_cancel_ahead_wb0_x   = sq_entry_cancel_ahead_wb0;    //1->3, LTL@20241017
assign sq_entry_cancel_ahead_wb1_x   = sq_entry_cancel_ahead_wb1;
assign sq_entry_cancel_ahead_wb2_x   = sq_entry_cancel_ahead_wb2;
assign sq_entry_depd_set_x          =  sq_entry_depd_set0   //1->3, no need split, merge 3 cond, LTL@20241017
                                        || sq_entry_depd_set1 
                                        || sq_entry_depd_set2;
assign sq_entry_pop_req_x           = sq_entry_pop_req;
assign sq_entry_cmit_x              = sq_entry_cmit;
assign sq_entry_newest_fwd_req_data_vld0_x = sq_entry_newest_fwd_req_data_vld0;    //1->3, LTL@20241017
assign sq_entry_newest_fwd_req_data_vld1_x = sq_entry_newest_fwd_req_data_vld1;
assign sq_entry_newest_fwd_req_data_vld2_x = sq_entry_newest_fwd_req_data_vld2;
assign sq_entry_newest_fwd_req_data_vld_short0_x = sq_entry_newest_fwd_req_data_vld_short0;    //1->3, LTL@20241017
assign sq_entry_newest_fwd_req_data_vld_short1_x = sq_entry_newest_fwd_req_data_vld_short1;
assign sq_entry_newest_fwd_req_data_vld_short2_x = sq_entry_newest_fwd_req_data_vld_short2;
//--------pop entry ptr-----------------
assign sq_entry_age_vec_zero_ptr_x      = sq_entry_age_vec_zero_ptr;
assign sq_entry_age_vec_surplus1_ptr_x  = sq_entry_age_vec_surplus1_ptr;
//-----------others---------------------
assign sq_entry_lsdc0_create_age_vec_x  = sq_entry_lsdc0_create_age_vec;  //1->2 LTL
assign sq_entry_lsdc1_create_age_vec_x  = sq_entry_lsdc1_create_age_vec;
assign sq_entry_settle_data_hit0_x       = sq_entry_settle_data_hit0;      //1->2 for 2 std, LTL
assign sq_entry_settle_data_hit1_x       = sq_entry_settle_data_hit1;
assign sq_entry_lsdc0_same_addr_newer_x = sq_entry_lsdc0_same_addr_newer;   //1->2 LTL
assign sq_entry_lsdc1_same_addr_newer_x = sq_entry_lsdc1_same_addr_newer;
assign sq_entry_ldc0_same_addr_older_x   = sq_entry_ldc0_same_addr_older; //1->3, LTL@20251010
assign sq_entry_lsdc0_same_addr_older_x  = sq_entry_lsdc0_same_addr_older;   
assign sq_entry_lsdc1_same_addr_older_x  = sq_entry_lsdc1_same_addr_older;
assign sq_entry_addr1_dep_discard0_x     = sq_entry_addr1_dep_discard0;  //1->3 for 3 ld dc, LTL@20241017
assign sq_entry_addr1_dep_discard1_x     = sq_entry_addr1_dep_discard1;
assign sq_entry_addr1_dep_discard2_x     = sq_entry_addr1_dep_discard2;
assign sq_entry_fwd_bypass_req0_x        = sq_entry_fwd_bypass_req0;  //1->3 for 3 ld dc, LTL@20241017
assign sq_entry_fwd_bypass_req1_x        = sq_entry_fwd_bypass_req1;
assign sq_entry_fwd_bypass_req2_x        = sq_entry_fwd_bypass_req2;
assign sq_entry_fwd_bypass_req_sel_0_x   = sq_entry_fwd_bypass_req_sel_0;  //1->3 for 3 ld dc, LTL@20241017
assign sq_entry_fwd_bypass_req_sel_1_x   = sq_entry_fwd_bypass_req_sel_1;
assign sq_entry_fwd_bypass_req_sel_2_x   = sq_entry_fwd_bypass_req_sel_2;
assign sq_entry_fwd_bypass_req0_newer_x  = sq_entry_fwd_bypass_req0_newer;
assign sq_entry_fwd_bypass_req1_newer_x  = sq_entry_fwd_bypass_req1_newer;
assign sq_entry_fwd_bypass_req2_newer_x  = sq_entry_fwd_bypass_req2_newer;
assign sq_entry_data_discard_req0_x      = sq_entry_data_discard_req0;//1->3 for 3 ld dc, LTL@20241017
assign sq_entry_data_discard_req1_x      = sq_entry_data_discard_req1;
assign sq_entry_data_discard_req2_x      = sq_entry_data_discard_req2;
assign sq_entry_data_discard_req_short0_x= sq_entry_data_discard_req_short0;  //1->3 for 3 ld dc, LTL@20241017
assign sq_entry_data_discard_req_short1_x= sq_entry_data_discard_req_short1;
assign sq_entry_data_discard_req_short2_x= sq_entry_data_discard_req_short2;
assign sq_entry_fwd_req0_x               = sq_entry_fwd_req0;  //1->3 for 3 ld dc, LTL@20241017
assign sq_entry_fwd_req1_x               = sq_entry_fwd_req1;
assign sq_entry_fwd_req2_x               = sq_entry_fwd_req2;
assign sq_entry_cancel_acc_req0_x        = sq_entry_cancel_acc_req0;//1->3 for 3 ld dc, LTL@20241017
assign sq_entry_cancel_acc_req1_x        = sq_entry_cancel_acc_req1;
assign sq_entry_cancel_acc_req2_x        = sq_entry_cancel_acc_req2;
assign sq_entry_st_stride_age_vec_zero_ptr_x = sq_entry_st_stride_age_vec_zero_ptr;
assign sq_entry_already_send_st_stride_x = sq_entry_already_send_st_stride;

//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
parameter CHK_IDLE            = 3'b000;
parameter CHK_WAKE_DATA       = 3'b010;
parameter CHK_DATA_CHECK      = 3'b001; 
parameter CHK_NEED_CMPLT      = 3'b100;
parameter CHK_NO_FORCE_CMPLT  = 3'b101;

//ls0
assign sq_entry_wake_data_grnt_0      = sq_entry_wake_data_grnt_0_x;
//
always @(posedge sq_entry_create_da_clk or negedge cpurst_b)
begin
  if (~cpurst_b)
    sq_entry_chk_cur_state_0[2:0] <= CHK_IDLE;
  else if(sq_entry_create_dp_vld0)
    sq_entry_chk_cur_state_0[2:0] <= CHK_IDLE;
  else if(sq_entry_vld & sq_entry_chk_cur_state_no_final_0)
    sq_entry_chk_cur_state_0[2:0] <= sq_entry_chk_next_state_0[2:0];
end

always @*
begin
case(sq_entry_chk_cur_state_0[2:0])
  CHK_IDLE:
    if(sq_entry_st_da_info_set0 & lsda0_sq_ex3_no_restart)
    begin
      if(st_da_data_check_0)
        sq_entry_chk_next_state_0[2:0] = CHK_WAKE_DATA;
      else
        sq_entry_chk_next_state_0[2:0] = CHK_NO_FORCE_CMPLT;
    end
    else
      sq_entry_chk_next_state_0[2:0] = CHK_IDLE;
  CHK_WAKE_DATA:
  begin
    if(sq_entry_wake_data_grnt_0)
      sq_entry_chk_next_state_0[2:0] = CHK_DATA_CHECK;
    else
      sq_entry_chk_next_state_0[2:0] = CHK_WAKE_DATA;
  end
  CHK_DATA_CHECK:
    if(sq_entry_data_halt_info_update_vld_0)
    begin
      if(sq_entry_boundary & ~sq_entry_secd & ~sq_entry_expt_vld_cancel)
        sq_entry_chk_next_state_0[2:0] = CHK_NO_FORCE_CMPLT;
      else
        sq_entry_chk_next_state_0[2:0] = CHK_NEED_CMPLT;
    end
    else
      sq_entry_chk_next_state_0[2:0] = CHK_DATA_CHECK;
  CHK_NEED_CMPLT:
    sq_entry_chk_next_state_0[2:0] = CHK_NEED_CMPLT;
  CHK_NO_FORCE_CMPLT:
    sq_entry_chk_next_state_0[2:0] = CHK_NO_FORCE_CMPLT;
  default:
    sq_entry_chk_next_state_0[2:0] = CHK_IDLE;
endcase
end
assign sq_entry_chk_cur_state_is_wake_data_0   = sq_entry_chk_cur_state_0[1];
assign sq_entry_chk_cur_state_is_data_check_0  = sq_entry_chk_cur_state_0[2:0] == CHK_DATA_CHECK;
assign sq_entry_chk_cur_state_no_final_0       = !sq_entry_chk_cur_state_0[2];

assign sq_entry_wake_data_req_0 = sq_entry_vld & sq_entry_chk_cur_state_is_wake_data_0;
//

always @(posedge sq_entry_create_da_clk or negedge cpurst_b)
begin
  if (~cpurst_b)
    sq_entry_halt_info_0[`TDT_MP_HINFO_WIDTH-1:0] <= {`TDT_MP_HINFO_WIDTH{1'b0}};
  else if(sq_entry_st_da_info_set0 & ~st_da_already_da_0 & sq_entry_halt_info_0[1])
    sq_entry_halt_info_0[`TDT_MP_HINFO_WIDTH-1:0] <= dtu_lsu_addr_halt_info0[`TDT_MP_HINFO_WIDTH-1:0];
  else if(sq_entry_data_halt_info_update_vld_0)
    sq_entry_halt_info_0[`TDT_MP_HINFO_WIDTH-1:0] <= dtu_lsu_data_halt_info0[`TDT_MP_HINFO_WIDTH-1:0];
end

assign sq_entry_wake_data_req_0_x     = sq_entry_wake_data_req_0;

//ls1
assign sq_entry_wake_data_grnt_1      = sq_entry_wake_data_grnt_1_x;
//
always @(posedge sq_entry_create_da_clk or negedge cpurst_b)
begin
  if (~cpurst_b)
    sq_entry_chk_cur_state_1[2:0] <= CHK_IDLE;
  else if(sq_entry_create_dp_vld1)
    sq_entry_chk_cur_state_1[2:0] <= CHK_IDLE;
  else if(sq_entry_vld & sq_entry_chk_cur_state_no_final_0)
    sq_entry_chk_cur_state_1[2:0] <= sq_entry_chk_next_state_1[2:0];
end

always @*
begin
case(sq_entry_chk_cur_state_1[2:0])
  CHK_IDLE:
    if(sq_entry_st_da_info_set1 & lsda1_sq_ex3_no_restart)
    begin
      if(st_da_data_check_1)
        sq_entry_chk_next_state_1[2:0] = CHK_WAKE_DATA;
      else
        sq_entry_chk_next_state_1[2:0] = CHK_NO_FORCE_CMPLT;
    end
    else
      sq_entry_chk_next_state_1[2:0] = CHK_IDLE;
  CHK_WAKE_DATA:
  begin
    if(sq_entry_wake_data_grnt_1)
      sq_entry_chk_next_state_1[2:0] = CHK_DATA_CHECK;
    else
      sq_entry_chk_next_state_1[2:0] = CHK_WAKE_DATA;
  end
  CHK_DATA_CHECK:
    if(sq_entry_data_halt_info_update_vld_1)
    begin
      if(sq_entry_boundary & ~sq_entry_secd & ~sq_entry_expt_vld_cancel)
        sq_entry_chk_next_state_1[2:0] = CHK_NO_FORCE_CMPLT;
      else
        sq_entry_chk_next_state_1[2:0] = CHK_NEED_CMPLT;
    end
    else
      sq_entry_chk_next_state_1[2:0] = CHK_DATA_CHECK;
  CHK_NEED_CMPLT:
    sq_entry_chk_next_state_1[2:0] = CHK_NEED_CMPLT;
  CHK_NO_FORCE_CMPLT:
    sq_entry_chk_next_state_1[2:0] = CHK_NO_FORCE_CMPLT;
  default:
    sq_entry_chk_next_state_1[2:0] = CHK_IDLE;
endcase
end
assign sq_entry_chk_cur_state_is_wake_data_1   = sq_entry_chk_cur_state_1[1];
assign sq_entry_chk_cur_state_is_data_check_1  = sq_entry_chk_cur_state_1[2:0] == CHK_DATA_CHECK;
assign sq_entry_chk_cur_state_no_final_1       = !sq_entry_chk_cur_state_1[2];

assign sq_entry_wake_data_req_1 = sq_entry_vld & sq_entry_chk_cur_state_is_wake_data_1;
//

always @(posedge sq_entry_create_da_clk or negedge cpurst_b)
begin
  if (~cpurst_b)
    sq_entry_halt_info_1[`TDT_MP_HINFO_WIDTH-1:0] <= {`TDT_MP_HINFO_WIDTH{1'b0}};
  else if(sq_entry_st_da_info_set1 & ~st_da_already_da_1 & sq_entry_halt_info_1[1])
    sq_entry_halt_info_1[`TDT_MP_HINFO_WIDTH-1:0] <= dtu_lsu_addr_halt_info1[`TDT_MP_HINFO_WIDTH-1:0];
  else if(sq_entry_data_halt_info_update_vld_1)
    sq_entry_halt_info_1[`TDT_MP_HINFO_WIDTH-1:0] <= dtu_lsu_data_halt_info1[`TDT_MP_HINFO_WIDTH-1:0];
end

assign sq_entry_wake_data_req_1_x     = sq_entry_wake_data_req_1;

assign sq_entry_halt_info_0_v[`TDT_MP_HINFO_WIDTH-1:0] = sq_entry_halt_info_0[`TDT_MP_HINFO_WIDTH-1:0];
assign sq_entry_halt_info_1_v[`TDT_MP_HINFO_WIDTH-1:0] = sq_entry_halt_info_1[`TDT_MP_HINFO_WIDTH-1:0];
// &ModuleEnd; @917

assign sq_entry_data_check_0_x        = sq_entry_chk_cur_state_is_data_check_0;
assign sq_entry_data_check_1_x        = sq_entry_chk_cur_state_is_data_check_1;
//==========================================================
//                  Risc-V Debug zdb End
//==========================================================
// &ModuleEnd; @917
endmodule


