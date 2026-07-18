//-----------------------------------------------------------------------------
// File          : xx_lsu_ld_dc.v
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



// *****************************************************************************

// &ModuleBeg; @27
module xx_lsu_ls_ld_dc #(
  parameter VB_DATA_ENTRY = 3,
  parameter IID_WIDTH     = 7,
  parameter LQ_ENTRY      = 16,
  parameter LSIQ_ENTRY    = 12,
  parameter VMB_ENTRY     = 8,
  parameter PC_LEN        = 15,
  parameter WK_PA_WIDTH   = 40,
  parameter WK_VA_WIDTH   = 39,
  parameter PREG          = 7,
  parameter VREG          = 6
)(
  input logic                                           rtu_ck_flush,
  input logic  [IID_WIDTH-1  :0]                        rtu_ck_flush_iid,
  input logic                                           cb_ld_dc_addr_hit,                      
  input logic                                           cp0_lsu_da_fwd_dis,                     
  input logic                                           cp0_lsu_dcache_en,                      
  input logic                                           cp0_lsu_ecc_en,                         
  input logic                                           cp0_lsu_icg_en,                         
  input logic                                           cpurst_b,                               
  input logic                                           ctrl_ld_clk,                            
  input logic   [2 :0]                                  dcache_arb_lsdc_borrow_db,             
  input logic                                           dcache_arb_lsdc_borrow_icc,            
  input logic   [1 :0]                                  dcache_arb_lsdc_borrow_idx_5to4,       
  input logic                                           dcache_arb_lsdc_borrow_mmu,            
  input logic                                           dcache_arb_lsdc_borrow_sndb,           
  input logic                                           dcache_arb_lsdc_borrow_vb,             
  input logic                                           dcache_arb_lsdc_borrow_vld,            
  input logic                                           dcache_arb_lsdc_borrow_vld_gate,       
  input logic                                           dcache_arb_lsdc_borrow_wmb,            
  input logic   [1 :0]                                  dcache_arb_lsdc_settle_way,   //1bit->2bit, L1D 2way->4way, LTL@20250321          
  input logic   [7 :0]                                  dcache_idx,                   //8->7, 2way->4way, LTL@20250321                           
  input logic   [`WK_LS_DCACHE_LDTAG_WIDTH-1:0]         dcache_lsu_ld_tag_dout,       //67->135, 2way->4way, LTL@20250321          
  input logic                                           forever_cpuclk,                                             
  input logic                                           icc_dcache_arb_ecc_read,                
  input logic                                           icc_dcache_arb_ld_tag_read,
  input logic                                           lsag_ex1_is_load,             
  input logic   [`WK_PA_WIDTH-5:0]                      lsag_lsdc_ex1_addr1_to4,                        
  input logic                                           lsag_lsdc_ex1_ahead_predict,                    
  input logic                                           lsag_lsdc_ex1_already_da,                       
  input logic                                           lsag_lsdc_ex1_atomic,                           
  input logic                                           lsag_lsdc_ex1_boundary,                         
  input logic   [2 :0]                                  lsag_ex1_access_size,                   
  input logic                                           lsag_lsdc_ex1_acclr_en,                      
  input logic   [`WK_PA_WIDTH-1:0]                      lsag_lsdc_ex1_addr0,                         
  input logic   [15:0]                                  lsag_lsdc_ex1_bytes_vld,                     
  input logic   [15:0]                                  lsag_lsdc_ex1_bytes_vld1,                    
  input logic   [15:0]                                  lsag_lsdc_ex1_bytes_vld2,                    
  input logic   [15:0]                                  lsag_lsdc_ex1_bytes_vld3,                    
  input logic                                           lsag_lsdc_ex1_inst_us,
  input logic                                           lsag_lsdc_ex1_fwd_bypass_en,                 
  input logic                                           lsag_lsdc_ex1_inst_vld,                      
  input logic                                           lsag_lsdc_ex1_load_ahead_inst_vld,           
  input logic                                           lsag_lsdc_ex1_load_inst_vld,                 
  input logic                                           lsag_lsdc_ex1_mmu_req,                       
  input logic                                           lsag_lsdc_ex1_page_so,                       
  input logic   [3 :0]                                  lsag_lsdc_ex1_rot_sel,                       
  input logic                                           lsag_lsdc_ex1_vload_ahead_inst_vld,          
  input logic                                           lsag_lsdc_ex1_vload_inst_vld,                
  input logic                                           lsag_lsdc_ex1_dtcm_hit,                         
  input logic   [8 :0]                                  lsag_lsdc_ex1_element_cnt,                      
  input logic   [3 :0]                                  lsag_lsdc_ex1_element_offset,                   
  input logic   [1 :0]                                  lsag_lsdc_ex1_element_size,                     
  input logic                                           lsag_lsdc_ex1_expt_access_fault_with_page,      
  input logic                                           lsag_lsdc_ex1_expt_amo_not_ca,                
  input logic                                           lsag_lsdc_ex1_expt_misalign_no_page,            
  input logic                                           lsag_lsdc_ex1_expt_misalign_with_page,          
  input logic                                           lsag_lsdc_ex1_expt_page_fault,                  
  input logic                                           lsag_lsdc_ex1_expt_vld,                         
  input logic   [IID_WIDTH-1:0]                         lsag_ex1_iid,                              
  input logic                                           lsag_lsdc_ex1_inst_fof,                         
  input logic   [1 :0]                                  lsag_lsdc_ex1_inst_type,                        
  input logic                                           lsag_lsdc_ex1_inst_vfls,                        
  input logic                                           lsag_ex1_inst_vld,                         
  input logic                                           lsag_lsdc_ex1_inst_vls,                         
  input logic                                           lsag_lsdc_ex1_itcm_hit,                         
  input logic   [PC_LEN-1:0]                            lsag_lsdc_ex1_ldfifo_pc,                        
  input logic   [LSIQ_ENTRY-1:0]                        lsag_lsdc_ex1_lsid,                                           
  input logic                                           lsag_lsdc_ex1_lsiq_spec_fail,                   
  input logic   [1 :0]                                  lsag_lsdc_ex1_no_spec,                          
  input logic                                           lsag_lsdc_ex1_no_spec_exist,                    
  input logic                                           lsag_lsdc_ex1_old,                              
  input logic                                           lsag_lsdc_ex1_page_buf,                         
  input logic                                           lsag_lsdc_ex1_page_ca,                          
  input logic                                           lsag_lsdc_ex1_page_sec,                         
  input logic                                           lsag_lsdc_ex1_page_share,                       
  input logic                                           lsag_lsdc_ex1_pf_inst,                          
  input logic   [PREG-1 :0]                             lsag_lsdc_ex1_preg,                             
  input logic                                           lsag_lsdc_ex1_raw_new,                          
  input logic   [15:0]                                  lsag_lsdc_ex1_reg_bytes_vld,                    
  input logic   [15:0]                                  lsag_lsdc_ex1_reg_bytes_vld1,                    
  input logic   [15:0]                                  lsag_lsdc_ex1_reg_bytes_vld2,                    
  input logic   [15:0]                                  lsag_lsdc_ex1_reg_bytes_vld3,                    
  input logic   [3 :0]                                  lsag_lsdc_ex1_us_way,
  input logic                                           lsag_lsdc_ex1_secd,                             
  input logic                                           lsag_lsdc_ex1_sign_extend,                      
  input logic                                           lsag_lsdc_ex1_split,                            
  input logic                                           lsag_lsdc_ex1_utlb_miss,                        
  // input logic   [1 :0]                                  lsag_lsdc_ex1_vlmul,     
  input logic   [2 :0]  lsag_lsdc_ex1_vlmul,  //pwh 1 for rvv1.0                        
  input logic   [VMB_ENTRY-1:0]                         lsag_lsdc_ex1_vmb_id,                           
  input logic                                           lsag_lsdc_ex1_vmb_merge_vld,                    
  input logic   [`WK_PA_WIDTH-13:0]                     lsag_lsdc_ex1_vpn,                              
  input logic   [VREG-1 :0]                             lsag_lsdc_ex1_vreg,                             
  //input logic   [1 :0]                                  lsag_lsdc_ex1_vsew,  //rvv1.0@hcl
  input logic   [1 :0]  lsag_lsdc_ex1_vmew,  //rvv1.0@hcl
  input logic   [1 :0]  lsag_lsdc_ex1_vmop,  //rvv1.0@hcl                           
  input logic   [LQ_ENTRY-1:0]                          lq_lsdc_ex2_create_entry,                  
  input logic                                           lq_lsdc_ex2_full,                          
  input logic                                           lq_lsdc_ex2_inst_hit,                      
  input logic                                           lq_lsdc_ex2_less2,                         
  input logic                                           lq_lsdc_ex2_spec_fail,                     
  input logic                                           lsu_dcache_ld_xx_gwen,                  
  input logic                                           lsu_has_fence,                          
  input logic                                           mmu_lsu_data_req_size,                  
  input logic                                           mmu_lsu_mmu_en,                         
  input logic                                           mmu_lsu_tlb_busy,                       
  input logic                                           mmu_lsu_imme_wakeup, //wjh@tmq, full, mrg-on-cmplt
  input logic                                           pad_yy_icg_scan_en,                     
  input logic                                           pfu_pfb_empty,                          
  input logic                                           pfu_sdb_create_gateclk_en,              
  input logic                                           pfu_sdb_empty,                          
  input logic                                           rb_fence_ld,                            
  input logic                                           rtu_lsu_flush_fe,                       
  input logic                                           sq_lsdc_ex2_addr1_dep_discard,             
  input logic                                           sq_lsdc_ex2_cancel_acc_req,                
  input logic                                           sq_lsdc_ex2_cancel_ahead_wb,               
  input logic                                           sq_lsdc_ex2_fwd_req,                       
  input logic                                           sq_lsdc_ex2_has_fwd_req,                   
  input logic   [`WK_PA_WIDTH-1:0]                      lsdc_selfdc_ex2_addr0,                            
  input logic   [15:0]                                  lsdc_selfdc_ex2_bytes_vld,                        
  input logic                                           lsdc_selfdc_ex2_chk_st_inst_vld,                  
  input logic                                           lsdc_selfdc_ex2_chk_statomic_inst_vld,            
  input logic                                           lsdc_selfdc_ex2_inst_vld,                         
  input logic   [3 :0]                                  wmb_lsdc_dcache_get_data,                    
  input logic   [15:0]                                  wmb_lsdc_fwd_bytes_vld,                      
  input logic                                           wmb_lsdc_cancel_acc_req,               
  input logic                                           wmb_lsdc_discard_req,                  
  input logic                                           wmb_lsdc_fwd_req,
  output logic                                          lsdc_ex2_is_load,                     
  output logic  [`WK_PA_WIDTH-1:0]                      lsdc_ex2_addr0,                            
  output logic  [`WK_PA_WIDTH-1:0]                      lsdc_ex2_addr1,                            
  output logic  [7 :0]                                  lsdc_ex2_addr1_11to4,                      
  output logic                                          lsdc_lsda_ex2_ahead_predict,                    
  output logic                                          lsdc_lsda_ex2_ahead_preg_wb_vld,                
  output logic                                          lsdc_lsda_ex2_ahead_vreg_wb_vld,                
  output logic                                          lsdc_lsda_ex2_already_da,                       
  output logic                                          lsdc_ex2_atomic,                                                
  output logic  [2 :0]                                  lsdc_lsda_ex2_borrow_db,                        
  output logic                                          lsdc_lsda_ex2_borrow_icc,                       
  output logic                                          lsdc_lsda_ex2_borrow_icc_ecc,                   
  output logic                                          lsdc_lsda_ex2_borrow_icc_tag,                   
  output logic  [1 :0]                                  lsdc_lsda_ex2_borrow_idx_5to4,                  
  output logic                                          lsdc_lsda_ex2_borrow_mmu,                       
  output logic                                          lsdc_lsda_ex2_borrow_sndb,                      
  output logic                                          lsdc_lsda_ex2_borrow_vb,                        
  output logic                                          lsdc_ex2_borrow_vld,                       
  output logic                                          lsdc_lsda_ex2_borrow_wmb,                       
  output logic                                          lsdc_ex2_boundary,                         
  output logic  [15:0]                                  lsdc_ex2_bytes_vld,                        
  output logic  [15:0]                                  lsdc_ex2_bytes_vld1,                       
  output logic  [15:0]                                  lsdc_ex2_bytes_vld2,                       
  output logic  [15:0]                                  lsdc_ex2_bytes_vld3,                       
  output logic                                          lsdc_cb_ex2_addr_create_gateclk_en,        
  output logic                                          lsdc_cb_ex2_addr_create_vld,               
  output logic  [`WK_PA_WIDTH-5:0]                      lsdc_cb_ex2_addr_tto4,                     
  output logic                                          lsdc_ex2_chk_atomic_inst_vld,              
  output logic                                          lsdc_ex2_chk_ld_addr1_vld,                 
  output logic                                          lsdc_sq_ex2_chk_ld_bypass_vld,                
  output logic                                          lsdc_ex2_chk_ld_inst_vld,                  
  output logic  [15:0]                                  lsdc_lsda_ex2_bytes_vld,                     
  output logic  [15:0]                                  lsdc_lsda_ex2_bytes_vld1,                    
  output logic  [15:0]                                  lsdc_lsda_ex2_bytes_vld2,                    
  output logic  [15:0]                                  lsdc_lsda_ex2_bytes_vld3,                    
  output logic                                          lsdc_lsda_ex2_cb_addr_create,                
  output logic                                          lsdc_lsda_ex2_cb_merge_en,                   
  output logic  [15:0]                                  lsdc_lsda_ex2_data_rot_sel,                  
  output logic                                          lsdc_lsda_ex2_expt_vld_gate_en,              
  output logic                                          lsdc_lsda_ex2_icc_tag_vld,                   
  output logic                                          lsdc_lsda_ex2_inst_vld,                      
  output logic  [LQ_ENTRY-1:0]                          lsdc_lsda_ex2_lq_entry,                      
  output logic                                          lsdc_ex2_old,                           
  output logic                                          lsdc_ex2_page_buf,                      
  output logic                                          lsdc_ex2_page_ca,                       
  output logic                                          lsdc_ex2_page_sec,                      
  output logic                                          lsdc_ex2_page_share,                    
  output logic                                          lsdc_ex2_page_so,                       
  output logic                                          lsdc_lsda_ex2_pf_inst,                       
  output logic  [`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0]  lsdc_lsda_ex2_tag_read,                      
  output logic                                          lsdc_lsda_ex2_data_inj_dp,                      
  output logic                                          lsdc_lsda_ex2_dcache_hit,                       
  output logic                                          lsdc_ex2_dtcm_hit,                         
  output logic  [8 :0]                                  lsdc_lsda_ex2_element_cnt,                      
  output logic  [1 :0]                                  lsdc_lsda_ex2_element_size,                     
  output logic                                          lsdc_lsda_ex2_expt_access_fault_extra,          
  output logic                                          lsdc_lsda_ex2_expt_access_fault_mask,           
  output logic  [4 :0]                                  lsdc_lsda_ex2_expt_vec,                         
  output logic                                          lsdc_lsda_ex2_expt_vld_except_access_err,       
  output logic  [15:0]                                  lsdc_lsda_ex2_fwd_bytes_vld,                    
  output logic                                          lsdc_ex2_fwd_sq_vld,                       
  output logic                                          lsdc_ex2_fwd_wmb_vld,                      
  output logic  [3 :0]                                  lsdc_ex2_get_dcache_data,                  
  //output logic          lsdc_ex2_hit_high_region,   //2 region->4 region, L1D 2->4way, LTL@20250321               
  //output logic          lsdc_ex2_hit_low_region, 
  output logic                                          lsdc_ex2_hit_3_region,
  output logic                                          lsdc_ex2_hit_2_region,
  output logic                                          lsdc_ex2_hit_1_region,                  
  output logic                                          lsdc_ex2_hit_0_region,
  output logic  [3 :0]                                  lsdc_ex2_hit_way,                         
  output logic  [LSIQ_ENTRY-1:0]                        lsdc_idu_ex2_lq_full,                      
  output logic  [LSIQ_ENTRY-1:0]                        lsdc_idu_ex2_tlb_busy,                     
  output logic  [IID_WIDTH-1:0]                         lsdc_ex2_iid,                              
  output logic  [LSIQ_ENTRY-1:0]                        lsdc_ex2_imme_wakeup,                      
  output logic                                          lsdc_ex2_inst_chk_vld,                     
  output logic                                          lsdc_lsda_ex2_inst_fof,                         
  output logic  [2 :0]                                  lsdc_lsda_ex2_inst_size,                        
  output logic  [1 :0]                                  lsdc_lsda_ex2_inst_type,                        
  output logic                                          lsdc_lsda_ex2_inst_vfls,                        
  output logic                                          lsdc_ex2_inst_vld,                         
  output logic                                          lsdc_lsda_ex2_inst_vls,                         
  output logic                                          lsdc_lsda_ex2_itcm_hit,                         
  output logic  [PC_LEN-1:0]                            lsdc_lsda_ex2_ldfifo_pc,                        
  output logic                                          lsdc_lq_ex2_create1_dp_vld,                
  output logic                                          lsdc_lq_ex2_create1_gateclk_en,            
  output logic                                          lsdc_lq_ex2_create1_vld,                   
  output logic                                          lsdc_lq_ex2_create_dp_vld,                 
  output logic                                          lsdc_lq_ex2_create_gateclk_en,             
  output logic                                          lsdc_lq_ex2_create_vld,                    
  output logic                                          lsdc_ex2_lq_full_gateclk_en,               
  output logic  [LSIQ_ENTRY-1:0]                        lsdc_lsda_ex2_lsid,                             
  output logic                                          lsdc_lsda_ex2_mmu_req,                          
  output logic  [`WK_PA_WIDTH-1:0]                      lsdc_lsda_ex2_mt_value,                         
  output logic  [1 :0]                                  lsdc_lsda_ex2_no_spec,                          
  output logic                                          lsdc_lsda_ex2_no_spec_exist,                    
  output logic                                          lsdc_pfu_info_set_vld,                 
  output logic  [`WK_PA_WIDTH-1:0]                      lsdc_lsda_ex2_pfu_va,                           
  output logic  [PREG-1 :0]                             lsdc_lsda_ex2_preg,                             
  output logic  [3 :0]                                  lsdc_lsda_ex2_preg_sign_sel,                    
  output logic  [15:0]                                  lsdc_lsda_ex2_reg_bytes_vld,                    
  output logic  [15:0]                                  lsdc_lsda_ex2_reg_bytes_vld1,                    
  output logic  [15:0]                                  lsdc_lsda_ex2_reg_bytes_vld2,                    
  output logic  [15:0]                                  lsdc_lsda_ex2_reg_bytes_vld3,                    
  output logic                                          lsdc_lsda_ex2_inst_us,
  output logic                                          lsdc_lsda_ex2_us_discard,
  output logic                                          lsdc_ex2_secd,                             
  output logic  [1 :0]                                  lsdc_lsda_ex2_settle_way,  //1bit->2bit, L1D 2way->4way, LTL@20250321                     
  output logic  [8 :0]                                  lsdc_lsda_ex2_setvl_val,                        
  output logic                                          lsdc_lsda_ex2_sign_extend,                      
  output logic                                          lsdc_lsda_ex2_spec_fail,                        
  output logic                                          lsdc_lsda_ex2_split,                            
  output logic                                          lsdc_lsda_ex2_tag_inj_dp,                       
  output logic                                          lsdc_ex2_tlb_busy_gateclk_en,              
  output logic                                          lsdc_lsda_ex2_vector_nop,                       
  // output logic  [1 :0]                                  lsdc_lsda_ex2_vlmul,   
  output logic  [2 :0]  lsdc_lsda_ex2_vlmul,  //pwh 2 for rvv1.0                          
  output logic  [VMB_ENTRY-1:0]                         lsdc_lsda_ex2_vmb_id,                           
  output logic                                          lsdc_lsda_ex2_vmb_merge_vld,                    
  output logic  [VREG-1 :0]                             lsdc_lsda_ex2_vreg,                             
  output logic                                          lsdc_lsda_ex2_vreg_sign_sel,                    
  //output logic  [1 :0]                                  lsdc_lsda_ex2_vsew,   //rvv1.0@hcl 
  output logic  [1 :0]  lsdc_lsda_ex2_vmew,   //rvv1.0@hcl
  output logic  [1 :0]  lsdc_lsda_ex2_vmop,   //rvv1.0@hcl                          
  output logic                                          lsdc_lsda_ex2_wait_fence,                       
  output logic                                          lsu_idu_ex2_load_fwd_inst_vld_dup1, 
  output logic                                          lsu_idu_ex2_load_fwd_inst_vld_dup2, 
  output logic                                          lsu_idu_ex2_load_fwd_inst_vld_dup3, 
  output logic                                          lsu_idu_ex2_load_fwd_inst_vld_dup4, 
  output logic                                          lsu_idu_ex2_load_inst_vld_dup0,    
  output logic                                          lsu_idu_ex2_load_inst_vld_dup1,    
  output logic                                          lsu_idu_ex2_load_inst_vld_dup2,    
  output logic                                          lsu_idu_ex2_load_inst_vld_dup3,    
  output logic                                          lsu_idu_ex2_load_inst_vld_dup4,    
  output logic  [PREG-1 :0]                             lsu_idu_ex2_preg_dup0,             
  output logic  [PREG-1 :0]                             lsu_idu_ex2_preg_dup1,             
  output logic  [PREG-1 :0]                             lsu_idu_ex2_preg_dup2,             
  output logic  [PREG-1 :0]                             lsu_idu_ex2_preg_dup3,             
  output logic  [PREG-1 :0]                             lsu_idu_ex2_preg_dup4,             
  output logic                                          lsu_idu_ex2_vload_fwd_inst_vld,    
  output logic                                          lsu_idu_ex2_vload_inst_vld_dup0,   
  output logic                                          lsu_idu_ex2_vload_inst_vld_dup1,   
  output logic                                          lsu_idu_ex2_vload_inst_vld_dup2,   
  output logic                                          lsu_idu_ex2_vload_inst_vld_dup3,   
  output logic  [VREG :0]                               lsu_idu_ex2_vreg_dup0,             
  output logic  [VREG :0]                               lsu_idu_ex2_vreg_dup1,             
  output logic  [VREG :0]                               lsu_idu_ex2_vreg_dup2,             
  output logic  [VREG :0]                               lsu_idu_ex2_vreg_dup3,             
  output logic  [`WK_PA_WIDTH-13:0]                     lsu_mmu_vabuf0,
//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
  input  logic                                          dtu_lsu_addr_trig_en,
  input  logic                                          dtu_lsu_data_trig_en  
//==========================================================
//                  Risc-V Debug zdb End 
//==========================================================       
);

// &Ports; @28
                   

// &Regs; @29
logic                                                   ld_dc_acclr_en;                                                   
logic     [`WK_PA_WIDTH-5:0]                            ld_dc_addr1_tto4;                                                                 
logic     [3 :0]                                        ld_dc_borrow_wmb_get_data;                                               
logic     [3 :0]                                        ld_dc_element_offset;                                       
logic                                                   ld_dc_expt_access_fault_with_page;      
logic                                                   ld_dc_expt_ldamo_not_ca;                
logic                                                   ld_dc_expt_misalign_no_page;            
logic                                                   ld_dc_expt_misalign_with_page;          
logic                                                   ld_dc_expt_page_fault;            
logic     [3 :0]                                        ld_dc_first_byte;                       
logic                                                   ld_dc_fwd_bypass_en;          
logic                                                   ld_dc_inst_vls_dup1;                    
logic                                                   ld_dc_inst_vls_dup2;                    
logic                                                   ld_dc_inst_vls_dup3;                                                                  
logic                                                   ld_dc_load_ahead_inst_vld_dup1;         
logic                                                   ld_dc_load_ahead_inst_vld_dup2;         
logic                                                   ld_dc_load_ahead_inst_vld_dup3;         
logic                                                   ld_dc_load_ahead_inst_vld_dup4;         
logic                                                   ld_dc_load_inst_vld_dup0;               
logic                                                   ld_dc_load_inst_vld_dup1;               
logic                                                   ld_dc_load_inst_vld_dup2;               
logic                                                   ld_dc_load_inst_vld_dup3;               
logic                                                   ld_dc_load_inst_vld_dup4;                                                          
logic                                                   ld_dc_lsiq_spec_fail;                          
logic                                                   ld_dc_old;                              
logic                                                   ld_dc_page_buf;                         
logic                                                   ld_dc_page_ca;                          
logic                                                   ld_dc_page_sec;                         
logic                                                   ld_dc_page_share;                       
logic                                                   ld_dc_page_so;                          
logic                                                   ld_dc_pf_inst;                                              
logic     [PREG-1 :0]                                   ld_dc_preg_dup1;                        
logic     [PREG-1 :0]                                   ld_dc_preg_dup2;                        
logic     [PREG-1 :0]                                   ld_dc_preg_dup3;                        
logic     [PREG-1 :0]                                   ld_dc_preg_dup4;                        
logic                                                   ld_dc_raw_new;                          
logic     [3 :0]                                        ld_dc_rot_sel;                                           
logic                                                   ld_dc_tlb_busy;                         
logic                                                   ld_dc_tlb_imme_wakeup; // wjh@tmq full, mrg-on-cmplt
logic                                                   ld_dc_utlb_miss;                              
logic                                                   ld_dc_vload_ahead_inst_vld;             
logic                                                   ld_dc_vload_inst_vld_dup0;              
logic                                                   ld_dc_vload_inst_vld_dup1;              
logic                                                   ld_dc_vload_inst_vld_dup2;              
logic                                                   ld_dc_vload_inst_vld_dup3;                                                     
logic     [`WK_PA_WIDTH-13:0]                           ld_dc_vpn;                                     
logic     [VREG-1 :0]                                   ld_dc_vreg_dup1;                        
logic     [VREG-1 :0]                                   ld_dc_vreg_dup2;                        
logic     [VREG-1 :0]                                   ld_dc_vreg_dup3;                                                   
logic                                                   ld_first_byte_unalign;                  
logic     [3 :0]                                        ld_first_element_ori;                   
logic     [15:0]                                        mmu_bytes_vld;                          
logic     [3 :0]                                        setvl_val_low;                          
// &Wires; @30
logic                                                   rtu_ck_flush_iid_older_than_ex1_iid;
logic                                                   cb_create_hit_idx;                         
logic                                                   ld_dc_ahead_wb_vld;                                           
logic                                                   ld_dc_borrow_clk;                       
logic                                                   ld_dc_borrow_clk_en;                    
logic                                                   ld_dc_borrow_mmu_vld;                   
logic                                                   ld_dc_boundary_first;                         
logic                                                   ld_dc_clk;                              
logic                                                   ld_dc_clk_en;                           
logic    [`WK_PA_WIDTH-1:0]                             ld_dc_cmp_st_dc_addr0;                  
logic    [3 :0]                                         ld_dc_data_bias_sel;                       
logic    [`WK_LS_DCACHE_LDTAG_WIDTH-1:0]                ld_dc_dcache_tag_array; //67->135, 2way->4way, LTL@20250319                
logic                                                   ld_dc_dcache_valid0;                    
logic                                                   ld_dc_dcache_valid1;                    
logic                                                   ld_dc_dcache_valid2;                    
logic                                                   ld_dc_dcache_valid3; 
logic                                                   ld_dc_depd_imme_restart_req;            
logic                                                   ld_dc_depd_imme_restart_vld;            
logic                                                   ld_dc_depd_st_dc;                       
logic                                                   ld_dc_depd_st_dc2;                      
logic                                                   ld_dc_depd_st_dc3;                      
logic                                                   ld_dc_dup_dcache_data_en;                                
logic                                                   ld_dc_expt_access_fault_short;          
logic                                                   ld_dc_get_dcache_data_all;              
logic    [3 :0]                                         ld_dc_get_dcache_data_inst_mmu;         
logic                                                   lsdc_ex2_hit_way0;
logic                                                   lsdc_ex2_hit_way1;
logic                                                   lsdc_ex2_hit_way2;                                    
logic                                                   lsdc_ex2_hit_way3;                         
logic                                                   ld_dc_imme_restart_vld;                 
logic                                                   ld_dc_inst_clk;                         
logic                                                   ld_dc_inst_clk_en;                      
logic                                                   ld_dc_ld_inst;                          
logic                                                   ld_dc_ldamo_inst;                        
logic                                                   ld_dc_lq_full_req;                      
logic                                                   ld_dc_lq_full_vld;                      
logic    [LSIQ_ENTRY-1:0]                               ld_dc_mask_lsid;                        
logic                                                   ld_dc_pf_inst_short;                       
logic    [7 :0]                                         ld_dc_pfu_va_11to4;                                      
logic                                                   ld_dc_raw_addr1_tto4_hit;               
logic                                                   ld_dc_raw_addr_tto4_hit;                
logic                                                   ld_dc_raw_do_hit;                       
logic                                                   ld_dc_restart_vld;                      
logic    [3 :0]                                         ld_dc_rot_sel_final;                     
logic                                                   ld_dc_tlb_busy_restart_vld;             
logic                                                   ld_dc_utlb_miss_vld;                    
logic    [`WK_PA_WIDTH-1:0]                             ld_dc_va;                                                     
logic                                                   ld_dc_way0_tag_hit;                     
logic                                                   ld_dc_way1_tag_hit; 
logic                                                   ld_dc_way2_tag_hit;                     
logic                                                   ld_dc_way3_tag_hit;                    
logic    [3 :0]                                         ld_first_element;                                                 
logic    [3 :0]                                         mmu_rot_sel;                                        
logic    [3 :0]                                         setvl_val_byte;                         
logic                                                   setvl_val_dword;                        
logic    [2 :0]                                         setvl_val_half;                         
logic    [1 :0]                                         setvl_val_word;                         
logic    [1 :0]                                         lsdc_ex2_borrow_way;
logic    [3 :0]                                         lsdc_ex2_us_way;

parameter S_BYTE  = 2'b00,
          HALF  = 2'b01,
          WORD  = 2'b10,
          DWORD = 2'b11;
//parameter VB_DATA_ENTRY = 3,
//          LQ_ENTRY      = 16,
//          LSIQ_ENTRY    = 12;
//parameter VMB_ENTRY     = 8;
//parameter PC_LEN        = 15;

//==========================================================
//                 Instance of Gated Cell  
//==========================================================
assign ld_dc_clk_en = lsag_ex1_inst_vld
                      ||  dcache_arb_lsdc_borrow_vld_gate;
// &Instance("gated_clk_cell", "x_lsu_ld_dc_gated_clk"); @47
gated_clk_cell  x_lsu_ld_dc_gated_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (ld_dc_clk         ),
  .external_en        (1'b0              ),
  .local_en           (ld_dc_clk_en      ),
  .module_en          (cp0_lsu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect(.clk_in        (forever_cpuclk     ), @48
//          .external_en   (1'b0               ), @49
//          .module_en     (cp0_lsu_icg_en     ), @50
//          .local_en      (ld_dc_clk_en       ), @51
//          .clk_out       (ld_dc_clk          )); @52

assign ld_dc_inst_clk_en = lsag_ex1_inst_vld;
// &Instance("gated_clk_cell", "x_lsu_ld_dc_inst_gated_clk"); @55
gated_clk_cell  x_lsu_ld_dc_inst_gated_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (ld_dc_inst_clk    ),
  .external_en        (1'b0              ),
  .local_en           (ld_dc_inst_clk_en ),
  .module_en          (cp0_lsu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect(.clk_in        (forever_cpuclk     ), @56
//          .external_en   (1'b0               ), @57
//          .module_en     (cp0_lsu_icg_en     ), @58
//          .local_en      (ld_dc_inst_clk_en  ), @59
//          .clk_out       (ld_dc_inst_clk     )); @60

assign ld_dc_borrow_clk_en = dcache_arb_lsdc_borrow_vld_gate;
// &Instance("gated_clk_cell", "x_lsu_ld_dc_borrow_gated_clk"); @63
gated_clk_cell  x_lsu_ld_dc_borrow_gated_clk (
  .clk_in              (forever_cpuclk     ),
  .clk_out             (ld_dc_borrow_clk   ),
  .external_en         (1'b0               ),
  .local_en            (ld_dc_borrow_clk_en),
  .module_en           (cp0_lsu_icg_en     ),
  .pad_yy_icg_scan_en  (pad_yy_icg_scan_en )
);

// &Connect(.clk_in        (forever_cpuclk     ), @64
//          .external_en   (1'b0               ), @65
//          .module_en     (cp0_lsu_icg_en     ), @66
//          .local_en      (ld_dc_borrow_clk_en), @67
//          .clk_out       (ld_dc_borrow_clk   )); @68

//-----------------------expt clk---------------------------
//assign ld_dc_expt_illegal_inst_clk_en = lsag_ex1_inst_vld
//                                        &&  ld_ag_expt_illegal_inst;
//&Instance("gated_clk_cell", "x_lsu_st_dc_expt_illegal_inst_gated_clk");
// //&Connect(.clk_in        (forever_cpuclk     ), @74
// //         .external_en   (1'b0               ), @75
// //         .module_en     (cp0_lsu_icg_en     ), @76
// //         .local_en      (ld_dc_expt_illegal_inst_clk_en), @77
// //         .clk_out       (ld_dc_expt_illegal_inst_clk)); @78

//==========================================================
//                 Pipeline Register
//==========================================================
//------------------control part----------------------------
//+----------+------------+
//| inst_vld | borrow_vld |
//+----------+------------+
// &Force("output","lsdc_ex2_inst_vld"); @87
always @(posedge ctrl_ld_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    lsdc_ex2_is_load           <=  1'b0;
  end
  else
  begin
    lsdc_ex2_is_load           <=  lsag_ex1_is_load;
  end
end


always @(posedge ctrl_ld_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    lsdc_ex2_inst_vld                <=  1'b0;
    ld_dc_load_inst_vld_dup0         <=  1'b0;
    ld_dc_load_inst_vld_dup1         <=  1'b0;
    ld_dc_load_inst_vld_dup2         <=  1'b0;
    ld_dc_load_inst_vld_dup3         <=  1'b0;
    ld_dc_load_inst_vld_dup4         <=  1'b0;
    ld_dc_load_ahead_inst_vld_dup1   <=  1'b0;
    ld_dc_load_ahead_inst_vld_dup2   <=  1'b0;
    ld_dc_load_ahead_inst_vld_dup3   <=  1'b0;
    ld_dc_load_ahead_inst_vld_dup4   <=  1'b0;
    ld_dc_vload_inst_vld_dup0        <=  1'b0;
    ld_dc_vload_inst_vld_dup1        <=  1'b0;
    ld_dc_vload_inst_vld_dup2        <=  1'b0;
    ld_dc_vload_inst_vld_dup3        <=  1'b0;
    ld_dc_vload_ahead_inst_vld       <=  1'b0;
  end
  else if(rtu_lsu_flush_fe)
  begin
    lsdc_ex2_inst_vld                <=  1'b0;
    ld_dc_load_inst_vld_dup0         <=  1'b0;
    ld_dc_load_inst_vld_dup1         <=  1'b0;
    ld_dc_load_inst_vld_dup2         <=  1'b0;
    ld_dc_load_inst_vld_dup3         <=  1'b0;
    ld_dc_load_inst_vld_dup4         <=  1'b0;
    ld_dc_load_ahead_inst_vld_dup1   <=  1'b0;
    ld_dc_load_ahead_inst_vld_dup2   <=  1'b0;
    ld_dc_load_ahead_inst_vld_dup3   <=  1'b0;
    ld_dc_load_ahead_inst_vld_dup4   <=  1'b0;
    ld_dc_vload_inst_vld_dup0        <=  1'b0;
    ld_dc_vload_inst_vld_dup1        <=  1'b0;
    ld_dc_vload_inst_vld_dup2        <=  1'b0;
    ld_dc_vload_inst_vld_dup3        <=  1'b0;
    ld_dc_vload_ahead_inst_vld       <=  1'b0;
  end
  else if(rtu_ck_flush && rtu_ck_flush_iid_older_than_ex1_iid)  //flush younger ex1->ex2, ck_flush@LTL
  begin
    lsdc_ex2_inst_vld                <=  1'b0;
    ld_dc_load_inst_vld_dup0         <=  1'b0;
    ld_dc_load_inst_vld_dup1         <=  1'b0;
    ld_dc_load_inst_vld_dup2         <=  1'b0;
    ld_dc_load_inst_vld_dup3         <=  1'b0;
    ld_dc_load_inst_vld_dup4         <=  1'b0;
    ld_dc_load_ahead_inst_vld_dup1   <=  1'b0;
    ld_dc_load_ahead_inst_vld_dup2   <=  1'b0;
    ld_dc_load_ahead_inst_vld_dup3   <=  1'b0;
    ld_dc_load_ahead_inst_vld_dup4   <=  1'b0;
    ld_dc_vload_inst_vld_dup0        <=  1'b0;
    ld_dc_vload_inst_vld_dup1        <=  1'b0;
    ld_dc_vload_inst_vld_dup2        <=  1'b0;
    ld_dc_vload_inst_vld_dup3        <=  1'b0;
    ld_dc_vload_ahead_inst_vld       <=  1'b0;
  end
  else if(lsag_lsdc_ex1_inst_vld)
  begin
    lsdc_ex2_inst_vld                <=  1'b1;
    ld_dc_load_inst_vld_dup0         <=  lsag_lsdc_ex1_load_inst_vld;
    ld_dc_load_inst_vld_dup1         <=  lsag_lsdc_ex1_load_inst_vld;
    ld_dc_load_inst_vld_dup2         <=  lsag_lsdc_ex1_load_inst_vld;
    ld_dc_load_inst_vld_dup3         <=  lsag_lsdc_ex1_load_inst_vld;
    ld_dc_load_inst_vld_dup4         <=  lsag_lsdc_ex1_load_inst_vld;
    ld_dc_load_ahead_inst_vld_dup1   <=  lsag_lsdc_ex1_load_ahead_inst_vld;
    ld_dc_load_ahead_inst_vld_dup2   <=  lsag_lsdc_ex1_load_ahead_inst_vld;
    ld_dc_load_ahead_inst_vld_dup3   <=  lsag_lsdc_ex1_load_ahead_inst_vld;
    ld_dc_load_ahead_inst_vld_dup4   <=  lsag_lsdc_ex1_load_ahead_inst_vld;
    ld_dc_vload_inst_vld_dup0        <=  lsag_lsdc_ex1_vload_inst_vld;
    ld_dc_vload_inst_vld_dup1        <=  lsag_lsdc_ex1_vload_inst_vld;
    ld_dc_vload_inst_vld_dup2        <=  lsag_lsdc_ex1_vload_inst_vld;
    ld_dc_vload_inst_vld_dup3        <=  lsag_lsdc_ex1_vload_inst_vld;
    ld_dc_vload_ahead_inst_vld       <=  lsag_lsdc_ex1_vload_ahead_inst_vld;
  end
  else
  begin
    lsdc_ex2_inst_vld                <=  1'b0;
    ld_dc_load_inst_vld_dup0         <=  1'b0;
    ld_dc_load_inst_vld_dup1         <=  1'b0;
    ld_dc_load_inst_vld_dup2         <=  1'b0;
    ld_dc_load_inst_vld_dup3         <=  1'b0;
    ld_dc_load_inst_vld_dup4         <=  1'b0;
    ld_dc_load_ahead_inst_vld_dup1   <=  1'b0;
    ld_dc_load_ahead_inst_vld_dup2   <=  1'b0;
    ld_dc_load_ahead_inst_vld_dup3   <=  1'b0;
    ld_dc_load_ahead_inst_vld_dup4   <=  1'b0;
    ld_dc_vload_inst_vld_dup0        <=  1'b0;
    ld_dc_vload_inst_vld_dup1        <=  1'b0;
    ld_dc_vload_inst_vld_dup2        <=  1'b0;
    ld_dc_vload_inst_vld_dup3        <=  1'b0;
    ld_dc_vload_ahead_inst_vld       <=  1'b0;
  end
end

// &Force("output","lsdc_ex2_borrow_vld"); @164
always @(posedge ctrl_ld_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    lsdc_ex2_borrow_vld      <=  1'b0;
  else if(dcache_arb_lsdc_borrow_vld)
    lsdc_ex2_borrow_vld      <=  1'b1;
  else
    lsdc_ex2_borrow_vld      <=  1'b0;
end

//------------------expt part-------------------------------
//+-------+----------+--------+------+---------+
//| tmiss | misalign | tfatal | deny | rd_tinv |
//+-------+----------+--------+------+---------+
// &Force("output","lsdc_lsda_ex2_mmu_req"); @179
always @(posedge ld_dc_inst_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    lsdc_lsda_ex2_mmu_req               <=  1'b0;
    //ld_dc_expt_illegal_inst           <=  1'b0;
    ld_dc_expt_misalign_no_page         <=  1'b0;
    //ld_dc_expt_access_fault           <=  1'b0;
    ld_dc_expt_page_fault               <=  1'b0;
    ld_dc_expt_misalign_with_page       <=  1'b0;
    ld_dc_expt_access_fault_with_page   <=  1'b0;
    ld_dc_expt_ldamo_not_ca             <=  1'b0;
  end
  else if(lsag_ex1_inst_vld)
  begin
    lsdc_lsda_ex2_mmu_req               <=  lsag_lsdc_ex1_mmu_req;
    //ld_dc_expt_illegal_inst           <=  ld_ag_expt_illegal_inst;
    ld_dc_expt_misalign_no_page         <=  lsag_lsdc_ex1_expt_misalign_no_page;
    //ld_dc_expt_access_fault           <=  ld_ag_expt_access_fault;
    ld_dc_expt_page_fault               <=  lsag_lsdc_ex1_expt_page_fault;
    ld_dc_expt_misalign_with_page       <=  lsag_lsdc_ex1_expt_misalign_with_page;
    ld_dc_expt_access_fault_with_page   <=  lsag_lsdc_ex1_expt_access_fault_with_page;
    ld_dc_expt_ldamo_not_ca             <=  lsag_lsdc_ex1_expt_amo_not_ca;
  end
end

//always @(posedge ld_dc_expt_illegal_inst_clk or negedge cpurst_b)
//begin
//  if (!cpurst_b)
//    ld_dc_inst_code[31:0]   <=  32'b0;
//  else if(lsag_ex1_inst_vld  &&  ld_ag_expt_illegal_inst)
//    ld_dc_inst_code[31:0]   <=  ld_ag_inst_code[31:0];
//end

//------------------borrow part-----------------------------
//+-----+------+-----+------------+
//| rcl | sndb | mmu | settle way |
//+-----+------+-----+------------+
// &Force("output","lsdc_lsda_ex2_borrow_mmu"); @218
// &Force("output","lsdc_lsda_ex2_borrow_icc"); @219
// &Force("output","lsdc_lsda_ex2_borrow_icc_tag"); @220
// &Force("output","lsdc_lsda_ex2_settle_way"); @221
always @(posedge ld_dc_borrow_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    lsdc_lsda_ex2_borrow_db[VB_DATA_ENTRY-1:0]  <=  {VB_DATA_ENTRY{1'b0}};
    lsdc_lsda_ex2_borrow_vb                     <=  1'b0;
    lsdc_lsda_ex2_borrow_sndb                   <=  1'b0;
    lsdc_lsda_ex2_borrow_mmu                    <=  1'b0;
    lsdc_lsda_ex2_borrow_icc                    <=  1'b0;
    lsdc_lsda_ex2_borrow_icc_tag                <=  1'b0;
    // lsdc_lsda_ex2_settle_way                    <=  2'b0;
    lsdc_ex2_borrow_way                         <=  2'b00;
    lsdc_lsda_ex2_borrow_wmb                    <=  1'b0;
    ld_dc_borrow_wmb_get_data[3:0]              <=  4'b0;
    lsdc_lsda_ex2_borrow_icc_ecc                <=  1'b0;
    lsdc_lsda_ex2_borrow_idx_5to4[1:0]          <=  2'b0;
  end
  else if(dcache_arb_lsdc_borrow_vld)
  begin
    lsdc_lsda_ex2_borrow_db[VB_DATA_ENTRY-1:0]  <=  dcache_arb_lsdc_borrow_db[VB_DATA_ENTRY-1:0];
    lsdc_lsda_ex2_borrow_vb                     <=  dcache_arb_lsdc_borrow_vb;
    lsdc_lsda_ex2_borrow_sndb                   <=  dcache_arb_lsdc_borrow_sndb;
    lsdc_lsda_ex2_borrow_mmu                    <=  dcache_arb_lsdc_borrow_mmu;
    lsdc_lsda_ex2_borrow_icc                    <=  dcache_arb_lsdc_borrow_icc;
    lsdc_lsda_ex2_borrow_icc_tag                <=  icc_dcache_arb_ld_tag_read;
    // lsdc_lsda_ex2_settle_way                    <=  dcache_arb_lsdc_settle_way;
    lsdc_ex2_borrow_way                         <=  dcache_arb_lsdc_settle_way;
    lsdc_lsda_ex2_borrow_wmb                    <=  dcache_arb_lsdc_borrow_wmb;
    ld_dc_borrow_wmb_get_data[3:0]              <=  wmb_lsdc_dcache_get_data[3:0];
    lsdc_lsda_ex2_borrow_icc_ecc                <=  icc_dcache_arb_ecc_read;
    lsdc_lsda_ex2_borrow_idx_5to4[1:0]          <=  dcache_arb_lsdc_borrow_idx_5to4[1:0];
  end
end
assign lsdc_lsda_ex2_settle_way = lsdc_ex2_borrow_vld? lsdc_ex2_borrow_way: {lsdc_ex2_hit_way3|lsdc_ex2_hit_way2, lsdc_ex2_hit_way3|lsdc_ex2_hit_way1};
//------------------inst part----------------------------
//+----------+---------+-----+
//| expt_vld | pf_inst | vpn |
//+----------+---------+-----+
//+-----------+-----------+------+------------+----------------+
//| inst_type | inst_size | secd | already_da | lsiq_spec_fail |
//+-----------+-----------+------+------------+----------------+
//+-------------+----+-----+------+-----+------------+------------+
//| sign_extend | ex | iid | lsid | old | bytes_vld0 | bytes_vld1 |
//+-------------+----+-----+------+-----+------------+------------+
//+--------+----------+------+-------+
//| deform | boundary | preg | split |
//+--------+----------+------+-------+
//+-----------+-------+-------+-----------+---------+
//| ldfifo_pc | bkpta | bkptb | data_bias | pf_inst |
//+-----------+-------+-------+-----------+---------+
//+----+----+-----+-----+-------+
//| so | ca | buf | sec | share |
//+----+----+-----+-----+-------+
// &Force("output","lsdc_lsda_ex2_split"); @277
// &Force("output","lsdc_lsda_ex2_inst_type"); @278
// &Force("output","lsdc_ex2_secd"); @279
// &Force("output","lsdc_lsda_ex2_already_da"); @280
// &Force("output","lsdc_ex2_atomic"); @281
// &Force("output","lsdc_ex2_iid"); @282
// &Force("output","lsdc_lsda_ex2_lsid"); @283
// &Force("output","lsdc_ex2_bytes_vld"); @284
// &Force("output","lsdc_ex2_bytes_vld1"); @285
// &Force("output","lsdc_lsda_ex2_bytes_vld"); @286
// &Force("output","lsdc_lsda_ex2_preg"); @287
// &Force("output","lsdc_lsda_ex2_inst_vfls"); @288
// &Force("output","lsdc_lsda_ex2_vreg"); @289
// &Force("output","lsdc_ex2_addr1_11to4"); @290
// &Force("output","lsdc_lsda_ex2_ldfifo_pc"); @291
// &Force("output","lsdc_lsda_ex2_inst_size"); @292
// &Force("output","lsdc_lsda_ex2_sign_extend"); @293
// &Force("output","lsdc_lsda_ex2_expt_vld_except_access_err"); @294
// &Force("output","lsdc_ex2_boundary"); @295
// &Force("output","lsdc_ex2_dtcm_hit"); @296
// &Force("output","lsdc_lsda_ex2_itcm_hit"); @297
always @(posedge ld_dc_inst_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    //lsdc_ex2_is_load                          <=  1'b0;
    lsdc_lsda_ex2_expt_vld_except_access_err  <=  1'b0;
    ld_dc_pf_inst                             <=  1'b0;
    ld_dc_vpn[`WK_PA_WIDTH-13:0]              <=  {`WK_PA_WIDTH-12{1'b0}};
    ld_dc_addr1_tto4[`WK_PA_WIDTH-5:0]        <=  {`WK_PA_WIDTH-4{1'b0}};
    lsdc_lsda_ex2_split                       <=  1'b0;
    lsdc_lsda_ex2_inst_type[1:0]              <=  2'b0;
    lsdc_lsda_ex2_inst_size[2:0]              <=  3'b0;
    lsdc_ex2_secd                             <=  1'b0;
    lsdc_lsda_ex2_already_da                  <=  1'b0;
    ld_dc_lsiq_spec_fail                      <=  1'b0;
    lsdc_lsda_ex2_sign_extend                 <=  1'b0;
    lsdc_ex2_atomic                           <=  1'b0;
    lsdc_ex2_iid[IID_WIDTH-1:0]               <=  {IID_WIDTH{1'b0}};
    lsdc_lsda_ex2_lsid[LSIQ_ENTRY-1:0]        <=  {LSIQ_ENTRY{1'b0}};
    ld_dc_old                                 <=  1'b0;
    lsdc_ex2_bytes_vld[15:0]                  <=  16'b0;
    lsdc_ex2_bytes_vld1[15:0]                 <=  16'b0;
    ld_dc_rot_sel[3:0]                        <=  4'b0;
    lsdc_ex2_boundary                         <=  1'b0;
    lsdc_lsda_ex2_preg[PREG-1:0]              <=  {PREG{1'b0}};
    ld_dc_preg_dup1[PREG-1:0]                 <=  {PREG{1'b0}};
    ld_dc_preg_dup2[PREG-1:0]                 <=  {PREG{1'b0}};
    ld_dc_preg_dup3[PREG-1:0]                 <=  {PREG{1'b0}};
    ld_dc_preg_dup4[PREG-1:0]                 <=  {PREG{1'b0}};
    lsdc_lsda_ex2_ldfifo_pc[PC_LEN-1:0]       <=  {PC_LEN{1'b0}};
    lsdc_lsda_ex2_ahead_predict               <=  1'b0;
    ld_dc_page_so                             <=  1'b0;
    ld_dc_page_ca                             <=  1'b0;
    ld_dc_page_buf                            <=  1'b0;
    ld_dc_page_sec                            <=  1'b0;
    ld_dc_page_share                          <=  1'b0;
    ld_dc_utlb_miss                           <=  1'b0;
    ld_dc_tlb_busy                            <=  1'b0;
    ld_dc_tlb_imme_wakeup                     <=  1'b0; // wjh@tmq full, mrg-on-cmplt
    lsdc_lsda_ex2_vreg[VREG-1:0]              <=  {VREG{1'b0}};
    ld_dc_vreg_dup1[VREG-1:0]                 <=  {VREG{1'b0}};
    ld_dc_vreg_dup2[VREG-1:0]                 <=  {VREG{1'b0}};
    ld_dc_vreg_dup3[VREG-1:0]                 <=  {VREG{1'b0}};
    lsdc_lsda_ex2_inst_vfls                   <=  1'b0;
    ld_dc_acclr_en                            <=  1'b0;
    ld_dc_fwd_bypass_en                       <=  1'b0;
    lsdc_lsda_ex2_no_spec[1:0]                <=  2'b0;
    lsdc_lsda_ex2_no_spec_exist               <=  1'b0;
    ld_dc_raw_new                             <=  1'b0;
    lsdc_lsda_ex2_reg_bytes_vld[15:0]         <=  16'b0;
    lsdc_lsda_ex2_inst_us                     <=  1'b0;
    //lsdc_lsda_ex2_vsew[1:0]                   <=  2'b0; //rvv1.0@hcl
    lsdc_lsda_ex2_vmew[1:0]                   <=  2'b0; //rvv1.0@hcl
    lsdc_lsda_ex2_vmop[1:0]                   <=  2'b0; //rvv1.0@hcl
    // lsdc_lsda_ex2_vlmul[1:0]                  <=  2'b0;
    lsdc_lsda_ex2_vlmul[2:0]                  <=  3'b0;    
    lsdc_lsda_ex2_element_size[1:0]           <=  2'b0;
    lsdc_lsda_ex2_element_cnt[8:0]            <=  9'b0;
    ld_dc_element_offset[3:0]                 <=  4'b0;
    lsdc_lsda_ex2_vmb_id[VMB_ENTRY-1:0]       <=  {VMB_ENTRY{1'b0}};
    lsdc_lsda_ex2_inst_vls                    <=  1'b0;
    ld_dc_inst_vls_dup1                       <=  1'b0;
    ld_dc_inst_vls_dup2                       <=  1'b0;
    ld_dc_inst_vls_dup3                       <=  1'b0;
    lsdc_lsda_ex2_inst_fof                    <=  1'b0;
    lsdc_lsda_ex2_vmb_merge_vld               <=  1'b0;
    lsdc_ex2_dtcm_hit                         <=  1'b0;
    lsdc_lsda_ex2_itcm_hit                    <=  1'b0;
  end
  else if(lsag_ex1_inst_vld)
  begin
    //lsdc_ex2_is_load                          <=  1'b1;
    lsdc_lsda_ex2_expt_vld_except_access_err  <=  lsag_lsdc_ex1_expt_vld;
    ld_dc_pf_inst                             <=  lsag_lsdc_ex1_pf_inst;
    ld_dc_vpn[`WK_PA_WIDTH-13:0]              <=  lsag_lsdc_ex1_vpn[`WK_PA_WIDTH-13:0];
    ld_dc_addr1_tto4[`WK_PA_WIDTH-5:0]        <=  lsag_lsdc_ex1_addr1_to4[`WK_PA_WIDTH-5:0];
    lsdc_lsda_ex2_split                       <=  lsag_lsdc_ex1_split;
    lsdc_lsda_ex2_inst_type[1:0]              <=  lsag_lsdc_ex1_inst_type[1:0];
    lsdc_lsda_ex2_inst_size[2:0]              <=  lsag_ex1_access_size[2:0];
    lsdc_ex2_secd                             <=  lsag_lsdc_ex1_secd;
    lsdc_lsda_ex2_already_da                  <=  lsag_lsdc_ex1_already_da;
    ld_dc_lsiq_spec_fail                      <=  lsag_lsdc_ex1_lsiq_spec_fail;
    lsdc_lsda_ex2_sign_extend                 <=  lsag_lsdc_ex1_sign_extend;
    lsdc_ex2_atomic                           <=  lsag_lsdc_ex1_atomic;
    lsdc_ex2_iid[IID_WIDTH-1:0]               <=  lsag_ex1_iid[IID_WIDTH-1:0];
    lsdc_lsda_ex2_lsid[LSIQ_ENTRY-1:0]        <=  lsag_lsdc_ex1_lsid[LSIQ_ENTRY-1:0];
    ld_dc_old                                 <=  lsag_lsdc_ex1_old;
    lsdc_ex2_bytes_vld[15:0]                  <=  lsag_lsdc_ex1_bytes_vld[15:0];
    lsdc_ex2_bytes_vld1[15:0]                 <=  lsag_lsdc_ex1_bytes_vld1[15:0];
    ld_dc_rot_sel[3:0]                        <=  lsag_lsdc_ex1_rot_sel[3:0];
    lsdc_ex2_boundary                         <=  lsag_lsdc_ex1_boundary;
    lsdc_lsda_ex2_preg[PREG-1:0]                   <=  lsag_lsdc_ex1_preg[PREG-1:0];
    ld_dc_preg_dup1[PREG-1:0]                      <=  lsag_lsdc_ex1_preg[PREG-1:0];
    ld_dc_preg_dup2[PREG-1:0]                      <=  lsag_lsdc_ex1_preg[PREG-1:0];
    ld_dc_preg_dup3[PREG-1:0]                      <=  lsag_lsdc_ex1_preg[PREG-1:0];
    ld_dc_preg_dup4[PREG-1:0]                      <=  lsag_lsdc_ex1_preg[PREG-1:0];
    lsdc_lsda_ex2_ldfifo_pc[PC_LEN-1:0]       <=  lsag_lsdc_ex1_ldfifo_pc[PC_LEN-1:0];
    lsdc_lsda_ex2_ahead_predict               <=  lsag_lsdc_ex1_ahead_predict;
    ld_dc_page_so                             <=  lsag_lsdc_ex1_page_so;
    ld_dc_page_ca                             <=  lsag_lsdc_ex1_page_ca;
    ld_dc_page_buf                            <=  lsag_lsdc_ex1_page_buf;
    ld_dc_page_sec                            <=  lsag_lsdc_ex1_page_sec;
    ld_dc_page_share                          <=  lsag_lsdc_ex1_page_share;
    ld_dc_utlb_miss                           <=  lsag_lsdc_ex1_utlb_miss;
    ld_dc_tlb_busy                            <=  mmu_lsu_tlb_busy;
    ld_dc_tlb_imme_wakeup                     <=  mmu_lsu_imme_wakeup; // wjh@tmq, full, mrg-on-cmplt
    lsdc_lsda_ex2_vreg[VREG-1:0]                   <=  lsag_lsdc_ex1_vreg[VREG-1:0];
    ld_dc_vreg_dup1[VREG-1:0]                      <=  lsag_lsdc_ex1_vreg[VREG-1:0];
    ld_dc_vreg_dup2[VREG-1:0]                      <=  lsag_lsdc_ex1_vreg[VREG-1:0];
    ld_dc_vreg_dup3[VREG-1:0]                      <=  lsag_lsdc_ex1_vreg[VREG-1:0];
    lsdc_lsda_ex2_inst_vfls                   <=  lsag_lsdc_ex1_inst_vfls;
    ld_dc_acclr_en                            <=  lsag_lsdc_ex1_acclr_en;
    ld_dc_fwd_bypass_en                       <=  lsag_lsdc_ex1_fwd_bypass_en;
    lsdc_lsda_ex2_no_spec[1:0]                <=  lsag_lsdc_ex1_no_spec[1:0];
    lsdc_lsda_ex2_no_spec_exist               <=  lsag_lsdc_ex1_no_spec_exist;
    ld_dc_raw_new                             <=  lsag_lsdc_ex1_raw_new;
    lsdc_lsda_ex2_reg_bytes_vld[15:0]         <=  lsag_lsdc_ex1_reg_bytes_vld[15:0];
    lsdc_lsda_ex2_inst_us                     <=  lsag_lsdc_ex1_inst_us;
    //lsdc_lsda_ex2_vsew[1:0]                   <=  lsag_lsdc_ex1_vsew[1:0]; // rvv1.0@hcl
    lsdc_lsda_ex2_vmew[1:0]                   <=  lsag_lsdc_ex1_vmew[1:0]; // rvv1.0@hcl
    lsdc_lsda_ex2_vmop[1:0]                   <=  lsag_lsdc_ex1_vmop[1:0]; // rvv1.0@hcl
    // lsdc_lsda_ex2_vlmul[1:0]                  <=  lsag_lsdc_ex1_vlmul[1:0];
    lsdc_lsda_ex2_vlmul[2:0]                  <=  lsag_lsdc_ex1_vlmul[2:0];   
    lsdc_lsda_ex2_element_size[1:0]           <=  lsag_lsdc_ex1_element_size[1:0];
    lsdc_lsda_ex2_element_cnt[8:0]            <=  lsag_lsdc_ex1_element_cnt[8:0];
    ld_dc_element_offset[3:0]                 <=  lsag_lsdc_ex1_element_offset[3:0];
    lsdc_lsda_ex2_vmb_id[VMB_ENTRY-1:0]       <=  lsag_lsdc_ex1_vmb_id[VMB_ENTRY-1:0];
    lsdc_lsda_ex2_inst_vls                    <=  lsag_lsdc_ex1_inst_vls;
    ld_dc_inst_vls_dup1                       <=  lsag_lsdc_ex1_inst_vls;
    ld_dc_inst_vls_dup2                       <=  lsag_lsdc_ex1_inst_vls;
    ld_dc_inst_vls_dup3                       <=  lsag_lsdc_ex1_inst_vls;
    lsdc_lsda_ex2_inst_fof                    <=  lsag_lsdc_ex1_inst_fof;
    lsdc_lsda_ex2_vmb_merge_vld               <=  lsag_lsdc_ex1_vmb_merge_vld;
    lsdc_ex2_dtcm_hit                         <=  lsag_lsdc_ex1_dtcm_hit;
    lsdc_lsda_ex2_itcm_hit                    <=  lsag_lsdc_ex1_itcm_hit;
  end
end

always @(posedge ld_dc_inst_clk or negedge cpurst_b)begin 
  if(!cpurst_b)begin 
    lsdc_lsda_ex2_reg_bytes_vld1[15:0]        <=  16'b0;
    lsdc_lsda_ex2_reg_bytes_vld2[15:0]        <=  16'b0;
    lsdc_lsda_ex2_reg_bytes_vld3[15:0]        <=  16'b0;
    lsdc_ex2_bytes_vld2[15:0]                 <=  16'b0;
    lsdc_ex2_bytes_vld3[15:0]                 <=  16'b0;
    lsdc_ex2_us_way[3:0]                      <=  4'b0;
  end
  else if(lsag_ex1_inst_vld &lsag_lsdc_ex1_inst_us)begin 
    lsdc_lsda_ex2_reg_bytes_vld1[15:0]        <=  lsag_lsdc_ex1_reg_bytes_vld1[15:0];
    lsdc_lsda_ex2_reg_bytes_vld2[15:0]        <=  lsag_lsdc_ex1_reg_bytes_vld2[15:0];
    lsdc_lsda_ex2_reg_bytes_vld3[15:0]        <=  lsag_lsdc_ex1_reg_bytes_vld3[15:0];
    lsdc_ex2_bytes_vld2[15:0]                 <=  lsag_lsdc_ex1_bytes_vld2[15:0];
    lsdc_ex2_bytes_vld3[15:0]                 <=  lsag_lsdc_ex1_bytes_vld3[15:0];
    lsdc_ex2_us_way[3:0]                      <=  lsag_lsdc_ex1_us_way[3:0];
  end
end

xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH)) 
x_lsu_ck_flush_compare_ex1_iid (
  .x_iid0                    (rtu_ck_flush_iid[IID_WIDTH-1:0]),
  .x_iid0_older              (rtu_ck_flush_iid_older_than_ex1_iid  ),
  .x_iid1                    (lsag_ex1_iid[IID_WIDTH-1:0]           )
);
//------------------inst/borrow share part------------------
//+-------+
//| addr0 |
//+-------+
// &Force("output","lsdc_ex2_addr0"); @442
always @(posedge ld_dc_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    lsdc_ex2_addr0[`WK_PA_WIDTH-1:0]     <=  {`WK_PA_WIDTH{1'b0}};
  end
  else if(lsag_ex1_inst_vld  ||  dcache_arb_lsdc_borrow_vld)
  begin
    lsdc_ex2_addr0[`WK_PA_WIDTH-1:0]     <=  lsag_lsdc_ex1_addr0[`WK_PA_WIDTH-1:0];
  end
end

//==========================================================
//        Generate  va
//==========================================================
assign ld_dc_va[`WK_PA_WIDTH-1:12] = ld_dc_vpn[`WK_PA_WIDTH-13:0];
assign ld_dc_va[11:4]           = lsdc_ex2_addr0[11:4];
assign ld_dc_va[3:0]            = (lsdc_ex2_boundary
                                      &&  !lsdc_ex2_secd
                                      &&  !ld_dc_expt_misalign_no_page)
                                  ? 4'b0
                                  : lsdc_ex2_addr0[3:0];
assign lsdc_ex2_addr1_11to4[7:0]   = ld_dc_addr1_tto4[7:0];
// for preload addr check
assign ld_dc_pfu_va_11to4[7:0]      = lsdc_ex2_boundary  &&  !lsdc_ex2_secd
                                      ? lsdc_ex2_addr1_11to4[7:0]
                                      : lsdc_ex2_addr0[11:4];
//if this inst cross 4k, this va is not accurate
assign lsdc_lsda_ex2_pfu_va[`WK_PA_WIDTH-1:0]  = {ld_dc_vpn[`WK_PA_WIDTH-13:0],
                                      ld_dc_pfu_va_11to4[7:0],
                                      lsdc_ex2_addr0[3:0]};

//==========================================================
//        Exception generate
//==========================================================
assign lsdc_lsda_ex2_expt_access_fault_mask = ld_dc_expt_misalign_no_page
                                      ||  ld_dc_expt_page_fault;

assign lsdc_lsda_ex2_expt_access_fault_extra  = lsdc_lsda_ex2_mmu_req
                                        &&  ld_dc_expt_ldamo_not_ca;

assign ld_dc_expt_access_fault_short  = lsdc_lsda_ex2_mmu_req;
//if utlb_miss and dmmu expt,
//then st_dc_expt_vld_except_access_err is 0,
//but st_dc_da_expt_vld is not certain

assign lsdc_lsda_ex2_expt_vld_gate_en  = lsdc_lsda_ex2_expt_vld_except_access_err
                                      ||  ld_dc_expt_access_fault_short
                                      ||  dtu_lsu_addr_trig_en  // Risc-V Debug zdb
                                      ||  dtu_lsu_data_trig_en; // Risc-V Debug zdb

// &CombBeg; @492
always @( lsdc_ex2_atomic
       or ld_dc_expt_access_fault_with_page
       or ld_dc_va[`WK_PA_WIDTH-1:0]
       or ld_dc_expt_misalign_with_page
       or ld_dc_addr1_tto4[`WK_PA_WIDTH-5:0]
       or ld_dc_expt_misalign_no_page
       or lsdc_lsda_ex2_expt_vld_except_access_err
       or ld_dc_expt_page_fault)
begin
lsdc_lsda_ex2_expt_vec[4:0] = 5'b0;
lsdc_lsda_ex2_mt_value[`WK_PA_WIDTH-1:0] = {`WK_PA_WIDTH{1'b0}};
if(ld_dc_expt_misalign_no_page  && !lsdc_ex2_atomic)
begin
  lsdc_lsda_ex2_expt_vec[4:0]   = 5'd4;
  lsdc_lsda_ex2_mt_value[`WK_PA_WIDTH-1:0]  = {ld_dc_addr1_tto4[`WK_PA_WIDTH-5:0],ld_dc_va[3:0]};
end
else if(ld_dc_expt_misalign_no_page && lsdc_ex2_atomic)
begin
  lsdc_lsda_ex2_expt_vec[4:0]   = 5'd6;
  lsdc_lsda_ex2_mt_value[`WK_PA_WIDTH-1:0]  = ld_dc_va[`WK_PA_WIDTH-1:0];
end
else if(ld_dc_expt_page_fault &&  !lsdc_ex2_atomic)
begin
  lsdc_lsda_ex2_expt_vec[4:0]   = 5'd13;
  lsdc_lsda_ex2_mt_value[`WK_PA_WIDTH-1:0]  = ld_dc_va[`WK_PA_WIDTH-1:0];
end
else if(ld_dc_expt_page_fault &&  lsdc_ex2_atomic)
begin
  lsdc_lsda_ex2_expt_vec[4:0]   = 5'd15;
  lsdc_lsda_ex2_mt_value[`WK_PA_WIDTH-1:0]  = ld_dc_va[`WK_PA_WIDTH-1:0];
end
else if(ld_dc_expt_misalign_with_page)
begin
  lsdc_lsda_ex2_expt_vec[4:0]   = 5'd4;
  lsdc_lsda_ex2_mt_value[`WK_PA_WIDTH-1:0]  = ld_dc_va[`WK_PA_WIDTH-1:0];
end
else if(ld_dc_expt_access_fault_with_page)
begin
  lsdc_lsda_ex2_expt_vec[4:0]   = 5'd5;
  lsdc_lsda_ex2_mt_value[`WK_PA_WIDTH-1:0]  = {`WK_PA_WIDTH{1'b0}};
end
else if(lsdc_lsda_ex2_expt_vld_except_access_err && !lsdc_ex2_atomic)begin 
  lsdc_lsda_ex2_expt_vec[4:0]   = 5'd5;
  lsdc_lsda_ex2_mt_value[WK_PA_WIDTH-1:0]  = {WK_PA_WIDTH{1'b0}};
end
else if(lsdc_lsda_ex2_expt_vld_except_access_err && lsdc_ex2_atomic)begin 
  lsdc_lsda_ex2_expt_vec[4:0]   = 5'd7;
  lsdc_lsda_ex2_mt_value[WK_PA_WIDTH-1:0]  = {WK_PA_WIDTH{1'b0}};
end
// &CombEnd @525
end

//==========================================================
//        Generate inst type
//==========================================================
// &Force("output","lsdc_lsda_ex2_vector_nop"); @530
//for masked element,treat it as nop
assign lsdc_lsda_ex2_vector_nop =  (lsdc_ex2_atomic || ld_dc_ld_inst) 
                        &&!(|lsdc_ex2_bytes_vld[15:0])
                        &&!lsdc_lsda_ex2_inst_us
                      || lsdc_lsda_ex2_inst_us
                         && !((|lsdc_ex2_bytes_vld)
                            | (|lsdc_ex2_bytes_vld1)
                            | (|lsdc_ex2_bytes_vld2)
                            | (|lsdc_ex2_bytes_vld3)); 
assign ld_dc_ld_inst    = !lsdc_ex2_atomic
                          &&  (lsdc_lsda_ex2_inst_type[1:0]  == 2'b00);
assign ld_dc_ldamo_inst = lsdc_ex2_atomic
                          &&  (lsdc_lsda_ex2_inst_type[1:0]  == 2'b00);
//==========================================================
//                 Create load queue
//==========================================================
//lq_create_vld is not accurate, comparing iid is a must precedure to create lq
// &Force("output","lsdc_lq_ex2_create_vld"); @546
// &Force("output","lsdc_lq_ex2_create1_vld"); @547
// &Force("output","lsdc_lq_ex2_create_dp_vld"); @548
// &Force("output","lsdc_lq_ex2_create1_dp_vld"); @549
//to reduce spec fail, create lq should be more strict

//for timing, create lq do not see access deny
assign lsdc_lq_ex2_create_vld          = lsdc_lq_ex2_create_dp_vld; //lq_create_dp_vld = lq_create_vld, process lq only one entry@202508
                                      //&&  !ld_dc_depd_imme_restart_req
                                      //&&  !sq_lsdc_ex2_addr1_dep_discard;

assign lsdc_lq_ex2_create1_vld         = lsdc_lq_ex2_create1_dp_vld
                                      &&  !ld_dc_depd_imme_restart_req
                                      && cb_ld_dc_addr_hit
                                      && !sq_lsdc_ex2_addr1_dep_discard;

assign lsdc_lq_ex2_create_dp_vld       = lsdc_ex2_inst_vld
                                      &&  ld_dc_ld_inst
                                      &&  !lsdc_lsda_ex2_vector_nop
                                      &&  !ld_dc_old
                                      &&  !ld_dc_page_so
                                      &&  !ld_dc_utlb_miss
                                      &&  !lq_lsdc_ex2_inst_hit
                                      &&  !lsdc_lsda_ex2_expt_vld_except_access_err
                                      &&  !ld_dc_depd_imme_restart_req
                                      &&  !sq_lsdc_ex2_addr1_dep_discard;

assign lsdc_lq_ex2_create1_dp_vld      = lsdc_lq_ex2_create_dp_vld 
                                      && ld_dc_acclr_en;
 
// &Force("output","lsdc_lq_ex2_create_gateclk_en"); @574
assign lsdc_lq_ex2_create_gateclk_en   = lsdc_ex2_inst_vld
                                      &&  ld_dc_ld_inst
                                      &&  !ld_dc_old
                                      &&  !ld_dc_page_so
                                      &&  !ld_dc_utlb_miss
                                      &&  !lsdc_lsda_ex2_expt_vld_except_access_err;
assign lsdc_lq_ex2_create1_gateclk_en  = lsdc_lq_ex2_create_gateclk_en
                                      &&  ld_dc_acclr_en;

// &Force("output","lsdc_ex2_addr1"); @584
assign lsdc_ex2_addr1[`WK_PA_WIDTH-1:0]   = {lsdc_ex2_addr0[`WK_PA_WIDTH-1:12],lsdc_ex2_addr1_11to4[7:0],4'b0};

//lq create entry
assign lsdc_lsda_ex2_lq_entry[LQ_ENTRY-1:0] = lq_lsdc_ex2_create_entry[LQ_ENTRY-1:0];
//==========================================================
//                 Generate check signal to lq/sq/wmb
//==========================================================
// &Force("output","lsdc_ex2_chk_ld_inst_vld"); @592
assign lsdc_ex2_chk_ld_inst_vld      = lsdc_ex2_inst_vld
                                    &&  ld_dc_ld_inst
                                    &&  !lsdc_lsda_ex2_expt_vld_except_access_err
                                    &&  !ld_dc_utlb_miss
                                    &&  !ld_dc_page_so;

assign lsdc_sq_ex2_chk_ld_bypass_vld    = lsdc_ex2_chk_ld_inst_vld
                                    &&  ld_dc_fwd_bypass_en;

assign lsdc_ex2_chk_ld_addr1_vld     = lsdc_ex2_inst_vld
                                    &&  ld_dc_ld_inst
                                    &&  !lsdc_lsda_ex2_expt_vld_except_access_err
                                    &&  !ld_dc_utlb_miss
                                    &&  !ld_dc_page_so
                                    &&  ld_dc_acclr_en;

assign lsdc_ex2_chk_atomic_inst_vld  = lsdc_ex2_inst_vld
                                    &&  !lsdc_lsda_ex2_vector_nop
                                    &&  lsdc_ex2_atomic
                                    &&  !ld_dc_utlb_miss
                                    &&  !lsdc_lsda_ex2_expt_vld_except_access_err;

//==========================================================
//                 RAW speculation check
//==========================================================
// st_dc stage should check raw speculation for ld_dc stage

// situat st pipe             ld pipe           addr      bytes_vld
// ----------------------------------------------------------------
// 2      st/stex             ld                31:4       x

// &Force("output","lsdc_ex2_inst_chk_vld"); @624
assign lsdc_ex2_inst_chk_vld       = lsdc_ex2_inst_vld
                                  &&  ld_dc_ld_inst
                                  &&  !lsdc_lsda_ex2_expt_vld_except_access_err
                                  &&  !ld_dc_utlb_miss
                                  &&  !ld_dc_page_so;
//------------------compare signal--------------------------
//-----------iid compare----------------
//compare the instruction in the entry is newer or older
//&Instance("wk_rtu_compare_iid","x_lsu_ld_dc_compare_st_dc_iid");
// //&Connect( .x_iid0         (st_dc_iid[6:0]         ), @634
// //          .x_iid1         (lsdc_ex2_iid[6:0]         ), @635
// //          .x_iid0_older   (ld_dc_raw_new          )); @636

//-----------addr compare---------------
//addr0 compare
assign ld_dc_cmp_st_dc_addr0[`WK_PA_WIDTH-1:0] = lsdc_selfdc_ex2_addr0[`WK_PA_WIDTH-1:0];
assign ld_dc_raw_addr_tto4_hit    = lsdc_ex2_addr0[`WK_PA_WIDTH-1:4]
                                    ==  ld_dc_cmp_st_dc_addr0[`WK_PA_WIDTH-1:4];

// for cache buffer
assign ld_dc_raw_addr1_tto4_hit   = lsdc_ex2_addr1[`WK_PA_WIDTH-1:4]
                                    ==  ld_dc_cmp_st_dc_addr0[`WK_PA_WIDTH-1:4];
//-----------bytes_vld compare----------
assign ld_dc_raw_do_hit     = |(lsdc_ex2_bytes_vld[15:0]  & lsdc_selfdc_ex2_bytes_vld[15:0]);

//------------------situation 2-----------------------------
assign ld_dc_depd_st_dc2    = lsdc_ex2_inst_chk_vld
                              &&  ld_dc_raw_new
                              &&  (lsdc_selfdc_ex2_chk_st_inst_vld                //these two signal, no need lsdc_ex2_is_load, LTL@20241114
                                  ||  lsdc_selfdc_ex2_chk_statomic_inst_vld)
                              &&  ld_dc_raw_addr_tto4_hit
                              &&  ld_dc_raw_do_hit;
//------------------situation 3-----------------------------
// when ld addr hit st, then do not get data from merge buffer
assign ld_dc_depd_st_dc3    = lsdc_ex2_inst_chk_vld
                              &&  ld_dc_raw_new
                              &&  lsdc_selfdc_ex2_inst_vld   //no need use is_load signal, LTL@20241114 
                              &&  ld_dc_raw_addr1_tto4_hit;

//------------------combine---------------------------------
assign ld_dc_depd_st_dc     = ld_dc_depd_st_dc2; 

assign lsdc_lsda_ex2_us_discard = lsdc_ex2_inst_vld
                                 && lsdc_lsda_ex2_inst_us
                                 && lsdc_lsda_ex2_dcache_hit
                                 && !(lsdc_ex2_hit_way == lsdc_ex2_us_way);
//==========================================================
//                 Dependency check
//==========================================================
// dependency check is done in sq/wmb entry file
//------------------arbitrate-------------------------------
//-----------forward arbitrate----------
//bypass: pass data from ex1
//fwd: pass data from sq/wmb
//if ld_dc_fwd_sq_bypass_vld=1, and lsdc_ex2_fwd_sq_vld=1,
//then see as multi depd in da
assign lsdc_ex2_fwd_sq_vld         = sq_lsdc_ex2_fwd_req;
// &Force("output","lsdc_ex2_fwd_wmb_vld"); @678
assign lsdc_ex2_fwd_wmb_vld        = !sq_lsdc_ex2_has_fwd_req
                                   &&  wmb_lsdc_fwd_req;

// &CombBeg; @682
always @( wmb_lsdc_fwd_req
       or wmb_lsdc_fwd_bytes_vld[15:0]
       or sq_lsdc_ex2_has_fwd_req)
begin
case({sq_lsdc_ex2_has_fwd_req,wmb_lsdc_fwd_req})
  2'b11:lsdc_lsda_ex2_fwd_bytes_vld[15:0] = 16'hffff;
  2'b10:lsdc_lsda_ex2_fwd_bytes_vld[15:0] = 16'hffff;
  2'b01:lsdc_lsda_ex2_fwd_bytes_vld[15:0] = wmb_lsdc_fwd_bytes_vld[15:0];
  2'b00:lsdc_lsda_ex2_fwd_bytes_vld[15:0] = 16'h0;
  default:lsdc_lsda_ex2_fwd_bytes_vld[15:0] = {16{1'bx}};
endcase
// &CombEnd; @690
end

//==========================================================
//                 Restart signal
//==========================================================
//-----------arbiter----------------------------------------
//prioritize:
//1. utlb_miss(include tlb_busy)
//2. depd st_dc/sq imme restart
//3. lq_full
//
//for timing, discard to da stage

//for timing, use create_dp signal to replay
assign ld_dc_lq_full_req      = lsdc_lq_ex2_create_dp_vld && lq_lsdc_ex2_full
                                || lsdc_lq_ex2_create1_dp_vld && lq_lsdc_ex2_less2;

assign ld_dc_depd_imme_restart_req  = ld_dc_depd_st_dc;

assign ld_dc_utlb_miss_vld    = lsdc_ex2_inst_vld
                                &&  !lsdc_lsda_ex2_expt_vld_except_access_err
                                &&  ld_dc_utlb_miss;

assign ld_dc_depd_imme_restart_vld  = !ld_dc_utlb_miss_vld
                                      &&  ld_dc_depd_imme_restart_req;

assign ld_dc_lq_full_vld        = ld_dc_lq_full_req
                                  &&  !ld_dc_depd_imme_restart_req
                                  &&  !ld_dc_utlb_miss_vld;

assign lsdc_ex2_lq_full_gateclk_en = lsdc_lq_ex2_create_gateclk_en
                                  &&  lq_lsdc_ex2_less2;

assign ld_dc_restart_vld        = ld_dc_lq_full_req
                                  ||  ld_dc_depd_imme_restart_req
                                  ||  ld_dc_utlb_miss_vld;

//---------------------restart kinds------------------------
// assign ld_dc_imme_restart_vld = ld_dc_utlb_miss_vld
//                                     &&  !ld_dc_tlb_busy
//                                 ||  ld_dc_depd_imme_restart_vld;

// assign ld_dc_tlb_busy_restart_vld = ld_dc_utlb_miss_vld
//                                     &&  ld_dc_tlb_busy;
assign ld_dc_imme_restart_vld        = ld_dc_depd_imme_restart_vld
                                       || ld_dc_tlb_imme_wakeup; // // wjh@tmq full, mrg-on-cmplt, hidden conditio is tlb-miss
assign ld_dc_tlb_busy_restart_vld    = 1'b0; // wjh@tmq
assign lsdc_ex2_tlb_busy_gateclk_en  = ld_dc_tlb_busy_restart_vld;

//==========================================================
//        Combine signal of spec_fail
//==========================================================
assign lsdc_lsda_ex2_spec_fail            = lq_lsdc_ex2_spec_fail
                                        && !ld_dc_ldamo_inst
                                    ||  ld_dc_lsiq_spec_fail;

//==========================================================
//            Generage get dcache signal
//==========================================================
//this data_bias_sel is for wmb/dcache
// //&Force("output","ld_dc_data_bias_sel"); @818
// //&Force("bus","ld_dc_data_bias_sel",3,0); @819

// &CombBeg; @821
always @( lsdc_ex2_addr0[3:2]
       or mmu_lsu_data_req_size)
begin
case({mmu_lsu_data_req_size,lsdc_ex2_addr0[3:2]})
  3'b000:mmu_bytes_vld[15:0]  = 16'h000f;
  3'b001:mmu_bytes_vld[15:0]  = 16'h00f0;
  3'b010:mmu_bytes_vld[15:0]  = 16'h0f00;
  3'b011:mmu_bytes_vld[15:0]  = 16'hf000;
  3'b100:mmu_bytes_vld[15:0]  = 16'h00ff;
  3'b110:mmu_bytes_vld[15:0]  = 16'hff00;
  default:mmu_bytes_vld[15:0]  = 16'h0;
endcase
// &CombEnd; @831
end

assign lsdc_lsda_ex2_bytes_vld[15:0] = ld_dc_borrow_mmu_vld ? mmu_bytes_vld[15:0]
                                                       : lsdc_ex2_bytes_vld[15:0];
assign lsdc_lsda_ex2_bytes_vld1[15:0] = lsdc_ex2_bytes_vld1[15:0];
assign lsdc_lsda_ex2_bytes_vld2[15:0] = lsdc_ex2_bytes_vld2[15:0];
assign lsdc_lsda_ex2_bytes_vld3[15:0] = lsdc_ex2_bytes_vld3[15:0];

assign ld_dc_data_bias_sel[0] = |lsdc_lsda_ex2_bytes_vld[3:0];
assign ld_dc_data_bias_sel[1] = |lsdc_lsda_ex2_bytes_vld[7:4];
assign ld_dc_data_bias_sel[2] = |lsdc_lsda_ex2_bytes_vld[11:8];
assign ld_dc_data_bias_sel[3] = |lsdc_lsda_ex2_bytes_vld[15:12];

//if deform/mmu double word, then open 2 groups of banks
assign ld_dc_dup_dcache_data_en = lsdc_ex2_inst_vld 
                                  || ld_dc_borrow_mmu_vld;

assign ld_dc_get_dcache_data_inst_mmu[3:0]  =  {4{ld_dc_dup_dcache_data_en}}
                                                & ld_dc_data_bias_sel[3:0];
// &Force("output","lsdc_lsda_ex2_borrow_wmb"); @849
assign ld_dc_get_dcache_data_all  = lsdc_ex2_borrow_vld
                                    &&  !lsdc_lsda_ex2_borrow_mmu
                                    &&  !lsdc_lsda_ex2_borrow_wmb;

assign lsdc_ex2_get_dcache_data[3:0] = (ld_dc_get_dcache_data_all 
                                    || ld_dc_acclr_en && lsdc_ex2_inst_vld
                                    || lsdc_lsda_ex2_inst_us && lsdc_ex2_inst_vld)
                                    ? 4'b1111
                                    : (lsdc_ex2_borrow_vld && lsdc_lsda_ex2_borrow_wmb
                                       ? ld_dc_borrow_wmb_get_data[3:0]
                                       : ld_dc_get_dcache_data_inst_mmu[3:0]);

//==========================================================
//            Generage to DA stage signal
//==========================================================
assign lsdc_lsda_ex2_inst_vld          = lsdc_ex2_inst_vld
                                    &&  !ld_dc_restart_vld;
//------------------page info sel if mmu req----------------
// &Force("output","lsdc_ex2_page_ca"); @876
assign ld_dc_borrow_mmu_vld       = lsdc_ex2_borrow_vld  &&  lsdc_lsda_ex2_borrow_mmu;
assign lsdc_ex2_page_so           = lsdc_ex2_borrow_vld  ? 1'b0
                                                      : ld_dc_page_so;
assign lsdc_ex2_page_ca           = lsdc_ex2_borrow_vld  ? 1'b1
                                                      : ld_dc_page_ca;
assign lsdc_ex2_page_buf          = lsdc_ex2_borrow_vld  ? 1'b1
                                                      : ld_dc_page_buf;
assign lsdc_ex2_page_sec          = lsdc_ex2_borrow_vld  ? 1'b0
                                                      : ld_dc_page_sec;
assign lsdc_ex2_page_share        = lsdc_ex2_borrow_vld  ? 1'b1
                                                      : ld_dc_page_share;
//------------------regard mmu request as old---------------
//because the old inst may cause tlb refill
assign lsdc_ex2_old               = ld_dc_borrow_mmu_vld  ? 1'b1
                                                          : ld_dc_old;
//------------------dcache tag pre_compare----------------
assign ld_dc_dcache_tag_array[`WK_LS_DCACHE_LDTAG_WIDTH-1:0]  = dcache_lsu_ld_tag_dout[`WK_LS_DCACHE_LDTAG_WIDTH-1:0];//67->135, 2way->4way, LTL@20250321

//for ecc inj prepare
assign lsdc_lsda_ex2_tag_inj_dp  = lsdc_ex2_inst_vld
                              && lsdc_ex2_page_ca
                              && cp0_lsu_dcache_en
                              && cp0_lsu_ecc_en
                              && !lsdc_lsda_ex2_expt_vld_except_access_err
                              && !ld_dc_utlb_miss_vld
                           || lsdc_ex2_borrow_vld
                              && lsdc_lsda_ex2_borrow_mmu;

assign lsdc_lsda_ex2_data_inj_dp = lsdc_ex2_inst_vld
                              && lsdc_ex2_page_ca
                              && cp0_lsu_dcache_en
                              && cp0_lsu_ecc_en
                              && !lsdc_lsda_ex2_expt_vld_except_access_err
                              && !ld_dc_utlb_miss_vld
                           || lsdc_ex2_borrow_vld
                              && !lsdc_lsda_ex2_borrow_icc;



assign ld_dc_way0_tag_hit   = (lsdc_ex2_addr0[`WK_PA_WIDTH-1:14] == ld_dc_dcache_tag_array[`WK_LS_DCACHE_SINGLE_TAG_WIDTH-1:0]);

assign ld_dc_way1_tag_hit   = (lsdc_ex2_addr0[`WK_PA_WIDTH-1:14] == ld_dc_dcache_tag_array[`WK_LS_DCACHE_SINGLE_TAG_WIDTH+`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH]);

assign ld_dc_way2_tag_hit   = (lsdc_ex2_addr0[`WK_PA_WIDTH-1:14] == ld_dc_dcache_tag_array[`WK_LS_DCACHE_SINGLE_TAG_WIDTH+`WK_LS_DCACHE_DOUBLE_LDTAG_WIDTH-1:`WK_LS_DCACHE_DOUBLE_LDTAG_WIDTH]);

assign ld_dc_way3_tag_hit   = (lsdc_ex2_addr0[`WK_PA_WIDTH-1:14] == ld_dc_dcache_tag_array[`WK_LS_DCACHE_SINGLE_TAG_WIDTH+`WK_LS_DCACHE_TRIPLE_LDTAG_WIDTH-1:`WK_LS_DCACHE_TRIPLE_LDTAG_WIDTH]);

assign ld_dc_dcache_valid0  = ld_dc_dcache_tag_array[`WK_LS_DCACHE_SINGLE_TAG_WIDTH]
                              &&  cp0_lsu_dcache_en
                              &&  lsdc_ex2_page_ca;
// &Force("output","lsdc_ex2_hit_way0"); @932
assign ld_dc_dcache_valid1  = ld_dc_dcache_tag_array[`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH+`WK_LS_DCACHE_SINGLE_TAG_WIDTH]
                              &&  cp0_lsu_dcache_en
                              &&  lsdc_ex2_page_ca;

assign ld_dc_dcache_valid2  = ld_dc_dcache_tag_array[`WK_LS_DCACHE_DOUBLE_LDTAG_WIDTH+`WK_LS_DCACHE_SINGLE_TAG_WIDTH]
                              &&  cp0_lsu_dcache_en
                              &&  lsdc_ex2_page_ca;
assign ld_dc_dcache_valid3  = ld_dc_dcache_tag_array[`WK_LS_DCACHE_TRIPLE_LDTAG_WIDTH+`WK_LS_DCACHE_SINGLE_TAG_WIDTH]
                              &&  cp0_lsu_dcache_en
                              &&  lsdc_ex2_page_ca;
assign lsdc_ex2_hit_way0       = ld_dc_dcache_valid0
                              &&  ld_dc_way0_tag_hit; 
assign lsdc_ex2_hit_way1       = ld_dc_dcache_valid1
                              &&  ld_dc_way1_tag_hit; 
assign lsdc_ex2_hit_way2       = ld_dc_dcache_valid2
                              &&  ld_dc_way2_tag_hit; 
assign lsdc_ex2_hit_way3       = ld_dc_dcache_valid3
                              &&  ld_dc_way3_tag_hit; 
assign lsdc_ex2_hit_way = {lsdc_ex2_hit_way3,lsdc_ex2_hit_way2,lsdc_ex2_hit_way1,lsdc_ex2_hit_way0};
// &Force("output","lsdc_lsda_ex2_dcache_hit"); @947
assign lsdc_lsda_ex2_dcache_hit     = lsdc_ex2_hit_way0  ||  lsdc_ex2_hit_way1 ||  lsdc_ex2_hit_way2 ||  lsdc_ex2_hit_way3;
//assign lsdc_ex2_hit_low_region = lsdc_ex2_addr0[4]
//                              ? lsdc_ex2_hit_way1
//                              : lsdc_ex2_hit_way0;
//assign lsdc_ex2_hit_high_region= lsdc_ex2_addr0[4]
//                              ? lsdc_ex2_hit_way0
//                              : lsdc_ex2_hit_way1;
always @( lsdc_ex2_addr0[5:4]
          or lsdc_ex2_hit_way0
          or lsdc_ex2_hit_way1
          or lsdc_ex2_hit_way2
          or lsdc_ex2_hit_way3)
begin
case(lsdc_ex2_addr0[5:4])
  2'b11: begin
    lsdc_ex2_hit_3_region = lsdc_ex2_hit_way0;
    lsdc_ex2_hit_2_region = lsdc_ex2_hit_way1;
    lsdc_ex2_hit_1_region = lsdc_ex2_hit_way2;
    lsdc_ex2_hit_0_region = lsdc_ex2_hit_way3;
  end 
  
  2'b10: begin
    lsdc_ex2_hit_3_region = lsdc_ex2_hit_way1;
    lsdc_ex2_hit_2_region = lsdc_ex2_hit_way0;
    lsdc_ex2_hit_1_region = lsdc_ex2_hit_way3;
    lsdc_ex2_hit_0_region = lsdc_ex2_hit_way2;
  end 
  2'b01: begin
    lsdc_ex2_hit_3_region = lsdc_ex2_hit_way2;
    lsdc_ex2_hit_2_region = lsdc_ex2_hit_way3;
    lsdc_ex2_hit_1_region = lsdc_ex2_hit_way0;
    lsdc_ex2_hit_0_region = lsdc_ex2_hit_way1;
  end 
  2'b00: begin
    lsdc_ex2_hit_3_region = lsdc_ex2_hit_way3;
    lsdc_ex2_hit_2_region = lsdc_ex2_hit_way2;
    lsdc_ex2_hit_1_region = lsdc_ex2_hit_way1;
    lsdc_ex2_hit_0_region = lsdc_ex2_hit_way0;
  end   
  default: {lsdc_ex2_hit_3_region,lsdc_ex2_hit_2_region,lsdc_ex2_hit_1_region,lsdc_ex2_hit_0_region} = 4'b0;
endcase
end
//------------------icc read tag info----------------
assign lsdc_lsda_ex2_icc_tag_vld  = lsdc_ex2_borrow_vld
                               && lsdc_lsda_ex2_borrow_icc
                               && lsdc_lsda_ex2_borrow_icc_tag;
//assign lsdc_lsda_ex2_tag_read[33:0] = lsdc_lsda_ex2_settle_way   //L1D 2->4way, LTL@20250321
//                                 ? dcache_lsu_ld_tag_dout[67:34]
//                                 : dcache_lsu_ld_tag_dout[33:0];
always @( lsdc_lsda_ex2_settle_way[1:0]
          or dcache_lsu_ld_tag_dout[`WK_LS_DCACHE_LDTAG_WIDTH-1:0])
begin
case(lsdc_lsda_ex2_settle_way[1:0])
  2'b11: lsdc_lsda_ex2_tag_read[`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0] = dcache_lsu_ld_tag_dout[`WK_LS_DCACHE_LDTAG_WIDTH-1        :`WK_LS_DCACHE_TRIPLE_LDTAG_WIDTH];  //way0
  2'b10: lsdc_lsda_ex2_tag_read[`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0] = dcache_lsu_ld_tag_dout[`WK_LS_DCACHE_TRIPLE_LDTAG_WIDTH-1 :`WK_LS_DCACHE_DOUBLE_LDTAG_WIDTH];  //way1
  2'b01: lsdc_lsda_ex2_tag_read[`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0] = dcache_lsu_ld_tag_dout[`WK_LS_DCACHE_DOUBLE_LDTAG_WIDTH-1 :`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH];  //way2
  2'b00: lsdc_lsda_ex2_tag_read[`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0] = dcache_lsu_ld_tag_dout[`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1 :0];  //way3
  default: lsdc_lsda_ex2_tag_read[`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0] = {`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH{1'b0}};
endcase
end

//------------------data pre_select----------------
//for mmu select
assign mmu_rot_sel[3:0]   = mmu_lsu_data_req_size
                            ? {lsdc_ex2_addr0[3],3'b0}
                            : {lsdc_ex2_addr0[3:2],2'b0};

assign ld_dc_rot_sel_final[3:0] = ld_dc_borrow_mmu_vld
                                   ? mmu_rot_sel[3:0]
                                   : ld_dc_rot_sel[3:0]; 

// &CombBeg;    @979
always @( ld_dc_rot_sel_final[3:0])
begin
casez(ld_dc_rot_sel_final[3:0])
  4'h0:lsdc_lsda_ex2_data_rot_sel[15:0]  = 16'b0000000000000001;
  4'h1:lsdc_lsda_ex2_data_rot_sel[15:0]  = 16'b0000000000000010;
  4'h2:lsdc_lsda_ex2_data_rot_sel[15:0]  = 16'b0000000000000100;
  4'h3:lsdc_lsda_ex2_data_rot_sel[15:0]  = 16'b0000000000001000;
  4'h4:lsdc_lsda_ex2_data_rot_sel[15:0]  = 16'b0000000000010000;
  4'h5:lsdc_lsda_ex2_data_rot_sel[15:0]  = 16'b0000000000100000;
  4'h6:lsdc_lsda_ex2_data_rot_sel[15:0]  = 16'b0000000001000000;
  4'h7:lsdc_lsda_ex2_data_rot_sel[15:0]  = 16'b0000000010000000;
  4'h8:lsdc_lsda_ex2_data_rot_sel[15:0]  = 16'b0000000100000000;
  4'h9:lsdc_lsda_ex2_data_rot_sel[15:0]  = 16'b0000001000000000;
  4'ha:lsdc_lsda_ex2_data_rot_sel[15:0]  = 16'b0000010000000000;
  4'hb:lsdc_lsda_ex2_data_rot_sel[15:0]  = 16'b0000100000000000;
  4'hc:lsdc_lsda_ex2_data_rot_sel[15:0]  = 16'b0001000000000000;
  4'hd:lsdc_lsda_ex2_data_rot_sel[15:0]  = 16'b0010000000000000;
  4'he:lsdc_lsda_ex2_data_rot_sel[15:0]  = 16'b0100000000000000;
  4'hf:lsdc_lsda_ex2_data_rot_sel[15:0]  = 16'b1000000000000000;
  default:lsdc_lsda_ex2_data_rot_sel[15:0]  = {16{1'bx}};
endcase
// &CombEnd; @999
end
// &CombBeg;    @1001
// &CombEnd; @1013

//----------sign_sel--------------------
//3: word sign extend
//2: half sign extend
//1: byte sign extend
//0: not extend
// &CombBeg; @1021
always @( lsdc_lsda_ex2_sign_extend
       or lsdc_lsda_ex2_inst_size[1:0])
begin
case({lsdc_lsda_ex2_sign_extend,lsdc_lsda_ex2_inst_size[1:0]})
  {1'b1,S_BYTE}:lsdc_lsda_ex2_preg_sign_sel[3:0] = 4'b0010;
  {1'b1,HALF}:lsdc_lsda_ex2_preg_sign_sel[3:0] = 4'b0100;
  {1'b1,WORD}:lsdc_lsda_ex2_preg_sign_sel[3:0] = 4'b1000;
  default:lsdc_lsda_ex2_preg_sign_sel[3:0] = 4'b0001;
endcase
// &CombEnd; @1028
end

// &Force("output","lsdc_lsda_ex2_inst_vls"); @1031
assign lsdc_lsda_ex2_vreg_sign_sel  = lsdc_lsda_ex2_inst_vls
                              ? lsdc_lsda_ex2_sign_extend
                              : (lsdc_lsda_ex2_inst_size[1:0]  !=  2'b11);

// &Force("output","lsdc_lsda_ex2_element_cnt"); @1044
// &Force("output","lsdc_lsda_ex2_element_size"); @1045
// &Force("output","lsdc_lsda_ex2_vsew"); @1046
//----------fof_vl_sel--------------------
// &CombBeg;    @1048
always @( lsdc_ex2_bytes_vld[15:0])
begin
casez(lsdc_ex2_bytes_vld[15:0])
  16'b???????????????1:ld_dc_first_byte[3:0] = 4'h0;
  16'b??????????????10:ld_dc_first_byte[3:0] = 4'h1;
  16'b?????????????100:ld_dc_first_byte[3:0] = 4'h2;
  16'b????????????1000:ld_dc_first_byte[3:0] = 4'h3;
  16'b???????????10000:ld_dc_first_byte[3:0] = 4'h4;
  16'b??????????100000:ld_dc_first_byte[3:0] = 4'h5;
  16'b?????????1000000:ld_dc_first_byte[3:0] = 4'h6;
  16'b????????10000000:ld_dc_first_byte[3:0] = 4'h7;
  16'b???????100000000:ld_dc_first_byte[3:0] = 4'h8;
  16'b??????1000000000:ld_dc_first_byte[3:0] = 4'h9;
  16'b?????10000000000:ld_dc_first_byte[3:0] = 4'ha;
  16'b????100000000000:ld_dc_first_byte[3:0] = 4'hb;
  16'b???1000000000000:ld_dc_first_byte[3:0] = 4'hc;
  16'b??10000000000000:ld_dc_first_byte[3:0] = 4'hd;
  16'b?100000000000000:ld_dc_first_byte[3:0] = 4'he;
  16'b1000000000000000:ld_dc_first_byte[3:0] = 4'hf;
  default:ld_dc_first_byte[3:0]  = 4'h0;
endcase
// &CombEnd; @1068
end

// &CombBeg; @1070
always @( ld_dc_first_byte[3:0]
       or lsdc_lsda_ex2_element_size[1:0])
begin
case(lsdc_lsda_ex2_element_size[1:0])
  S_BYTE:   ld_first_element_ori[3:0] = ld_dc_first_byte[3:0]; 
  HALF:   ld_first_element_ori[3:0] = {1'b0,ld_dc_first_byte[3:1]}; 
  WORD:   ld_first_element_ori[3:0] = {2'b0,ld_dc_first_byte[3:2]}; 
  DWORD:  ld_first_element_ori[3:0] = {3'b0,ld_dc_first_byte[3]};
  default:ld_first_element_ori[3:0] = {4{1'bx}};
endcase
// &CombEnd; @1078
end

assign ld_dc_boundary_first  = lsdc_ex2_boundary && !lsdc_ex2_secd;

// &CombBeg; @1082
always @( ld_dc_first_byte[2:0]
       or lsdc_lsda_ex2_element_size[1:0])
begin
case(lsdc_lsda_ex2_element_size[1:0])
  HALF:   ld_first_byte_unalign = ld_dc_first_byte[0]; 
  WORD:   ld_first_byte_unalign = |ld_dc_first_byte[1:0]; 
  DWORD:  ld_first_byte_unalign = |ld_dc_first_byte[2:0];
  default:ld_first_byte_unalign = 1'b0;
endcase
// &CombEnd; @1089
end
 
assign ld_first_element[3:0] = ld_dc_boundary_first && ld_first_byte_unalign
                               ? ld_first_element_ori[3:0] + 1'b1
                               : ld_first_element_ori[3:0]; 

assign setvl_val_byte[3:0] = ld_first_element[3:0] + ld_dc_element_offset[3:0];
assign setvl_val_half[2:0] = ld_first_element[2:0] + ld_dc_element_offset[2:0];
assign setvl_val_word[1:0] = ld_first_element[1:0] + ld_dc_element_offset[1:0];
assign setvl_val_dword     = ld_first_element[0]   + ld_dc_element_offset[0];

// &CombBeg; @1100
always @( setvl_val_byte[3:0]
       or setvl_val_dword
       or setvl_val_half[2:0]
       or setvl_val_word[1:0]
       or lsdc_lsda_ex2_vmew[1:0]) // origin sew  now mew  rvv1.0
begin
case(lsdc_lsda_ex2_vmew[1:0])// origin sew  now mew  rvv1.0
  S_BYTE: setvl_val_low[3:0] = setvl_val_byte[3:0]; 
  HALF: setvl_val_low[3:0] = {1'b0,setvl_val_half[2:0]}; 
  WORD: setvl_val_low[3:0] = {2'b0,setvl_val_word[1:0]}; 
  DWORD:setvl_val_low[3:0] = {3'b0,setvl_val_dword}; 
  default:setvl_val_low[3:0] = {4{1'bx}};
endcase
// &CombEnd; @1108
end

assign lsdc_lsda_ex2_setvl_val[8:0] = lsdc_lsda_ex2_element_cnt[8:0] + {5'b0,setvl_val_low[3:0]}; 

//==========================================================
//            Generage pfu signal
//==========================================================
// &Force("output","lsdc_lsda_ex2_pf_inst"); @1116
assign lsdc_lsda_ex2_pf_inst       = ld_dc_pf_inst
                                &&  !lsdc_lsda_ex2_vector_nop
                                &&  ld_dc_page_ca;

assign ld_dc_pf_inst_short    = ld_dc_pf_inst
                                &&  !lsdc_lsda_ex2_vector_nop
                                &&  ld_dc_page_ca
                                &&  !ld_dc_utlb_miss
                                &&  !lsdc_lsda_ex2_expt_vld_except_access_err;

assign lsdc_pfu_info_set_vld = lsdc_ex2_inst_vld
                                &&  ld_dc_pf_inst_short
                                &&  (!pfu_sdb_empty
                                    ||  !pfu_pfb_empty
                                    ||  pfu_sdb_create_gateclk_en);

//==========================================================
//            Generage to cache buffer signal
//==========================================================
//------------------addr prepare----------------
assign lsdc_cb_ex2_addr_tto4[`WK_PA_WIDTH-5:0] = lsdc_ex2_addr0[`WK_PA_WIDTH-1:4];

// &Force("bus","dcache_idx","8","0"); @1139
assign cb_create_hit_idx   = (lsdc_ex2_addr0[13:6]  ==  dcache_idx[7:0]);
// &Force("output","lsdc_cb_ex2_addr_create_vld"); @1141
assign lsdc_cb_ex2_addr_create_vld = lsdc_ex2_inst_vld
                                  &&  ld_dc_ld_inst
                                  &&  ld_dc_acclr_en
                                  &&  !lsdc_lsda_ex2_vector_nop
                                  &&  !lsdc_lsda_ex2_expt_vld_except_access_err
                                  &&  !ld_dc_restart_vld
                                  &&  !(lsu_dcache_ld_xx_gwen
                                        && cb_create_hit_idx)
                                  && !rtu_lsu_flush_fe;
assign lsdc_cb_ex2_addr_create_gateclk_en  = lsdc_ex2_inst_vld
                                          &&  ld_dc_ld_inst
                                          &&  ld_dc_acclr_en
                                          &&  !lsdc_lsda_ex2_expt_vld_except_access_err
                                          &&  !rtu_lsu_flush_fe;

assign lsdc_lsda_ex2_cb_addr_create  = lsdc_cb_ex2_addr_create_vld;
assign lsdc_lsda_ex2_cb_merge_en     = ld_dc_acclr_en
                                  &&  cb_ld_dc_addr_hit
                                  &&  !lsdc_lsda_ex2_vector_nop
                                  &&  !ld_dc_depd_st_dc3
                                  &&  !sq_lsdc_ex2_cancel_acc_req
                                  &&  !wmb_lsdc_cancel_acc_req
                                  &&  !lq_lsdc_ex2_inst_hit
                                  &&  !lsdc_lsda_ex2_expt_vld_except_access_err;

//==========================================================
//              Generate forward write back
//==========================================================
// &Force("output","lsdc_lsda_ex2_wait_fence"); @1170
assign lsdc_lsda_ex2_wait_fence         = lsu_has_fence
                                  &&  rb_fence_ld;

assign ld_dc_ahead_wb_vld       = lsdc_ex2_inst_vld
                                  &&  !cp0_lsu_da_fwd_dis
                                  &&  ld_dc_page_ca
                                  &&  ld_dc_ld_inst
                                  &&  !lsdc_lsda_ex2_expt_vld_except_access_err
                                  &&  !lsdc_lsda_ex2_wait_fence
                                  &&  !lsdc_ex2_boundary
                                  &&  lsdc_lsda_ex2_dcache_hit;

assign lsdc_lsda_ex2_ahead_preg_wb_vld  = ld_dc_ahead_wb_vld
                                  &&  !sq_lsdc_ex2_cancel_ahead_wb
                                  &&  !wmb_lsdc_discard_req
                                  &&  !lsdc_lsda_ex2_inst_vfls;
//assign lsdc_lsda_ex2_ahead_vreg_wb_vld  = ld_dc_ahead_wb_vld
//                                  &&  !sq_lsdc_ex2_cancel_ahead_wb
//                                  &&  !wmb_lsdc_discard_req
//                                  &&  !lsdc_lsda_ex2_inst_vls
//                                  &&  lsdc_lsda_ex2_inst_vfls;
assign lsdc_lsda_ex2_ahead_vreg_wb_vld = 1'b0;

//==========================================================
//      Generage lsiq signal (renamed in lsu_restart.vp)
//==========================================================
assign ld_dc_mask_lsid[LSIQ_ENTRY-1:0]    = {LSIQ_ENTRY{lsdc_ex2_inst_vld}}
                                            & lsdc_lsda_ex2_lsid[LSIQ_ENTRY-1:0];
assign lsdc_idu_ex2_lq_full[LSIQ_ENTRY-1:0]  = {LSIQ_ENTRY{ld_dc_lq_full_vld}}
                                            & ld_dc_mask_lsid[LSIQ_ENTRY-1:0];
assign lsdc_ex2_imme_wakeup[LSIQ_ENTRY-1:0]  = {LSIQ_ENTRY{ld_dc_imme_restart_vld}}
                                            & ld_dc_mask_lsid[LSIQ_ENTRY-1:0];
assign lsdc_idu_ex2_tlb_busy[LSIQ_ENTRY-1:0] = {LSIQ_ENTRY{ld_dc_tlb_busy_restart_vld}}
                                            & ld_dc_mask_lsid[LSIQ_ENTRY-1:0];
                                        
//==========================================================
//                Generage signal to idu
//==========================================================
assign lsu_idu_ex2_load_inst_vld_dup0     = ld_dc_load_inst_vld_dup0;
assign lsu_idu_ex2_load_inst_vld_dup1     = ld_dc_load_inst_vld_dup1;
assign lsu_idu_ex2_load_inst_vld_dup2     = ld_dc_load_inst_vld_dup2;
assign lsu_idu_ex2_load_inst_vld_dup3     = ld_dc_load_inst_vld_dup3;
assign lsu_idu_ex2_load_inst_vld_dup4     = ld_dc_load_inst_vld_dup4;
assign lsu_idu_ex2_load_fwd_inst_vld_dup1 = ld_dc_load_ahead_inst_vld_dup1;
assign lsu_idu_ex2_load_fwd_inst_vld_dup2 = ld_dc_load_ahead_inst_vld_dup2;
assign lsu_idu_ex2_load_fwd_inst_vld_dup3 = ld_dc_load_ahead_inst_vld_dup3;
assign lsu_idu_ex2_load_fwd_inst_vld_dup4 = ld_dc_load_ahead_inst_vld_dup4;
assign lsu_idu_ex2_preg_dup0[PREG-1:0]         = lsdc_lsda_ex2_preg[PREG-1:0];
assign lsu_idu_ex2_preg_dup1[PREG-1:0]         = ld_dc_preg_dup1[PREG-1:0];
assign lsu_idu_ex2_preg_dup2[PREG-1:0]         = ld_dc_preg_dup2[PREG-1:0];
assign lsu_idu_ex2_preg_dup3[PREG-1:0]         = ld_dc_preg_dup3[PREG-1:0];
assign lsu_idu_ex2_preg_dup4[PREG-1:0]         = ld_dc_preg_dup4[PREG-1:0];
assign lsu_idu_ex2_vload_inst_vld_dup0    = ld_dc_vload_inst_vld_dup0; 
assign lsu_idu_ex2_vload_inst_vld_dup1    = ld_dc_vload_inst_vld_dup1; 
assign lsu_idu_ex2_vload_inst_vld_dup2    = ld_dc_vload_inst_vld_dup2; 
assign lsu_idu_ex2_vload_inst_vld_dup3    = ld_dc_vload_inst_vld_dup3; 
assign lsu_idu_ex2_vload_fwd_inst_vld     = ld_dc_vload_ahead_inst_vld; 
assign lsu_idu_ex2_vreg_dup0[VREG:0]         = {lsdc_lsda_ex2_inst_vls,lsdc_lsda_ex2_vreg[VREG-1:0]};
assign lsu_idu_ex2_vreg_dup1[VREG:0]         = {ld_dc_inst_vls_dup1,ld_dc_vreg_dup1[VREG-1:0]};
assign lsu_idu_ex2_vreg_dup2[VREG:0]         = {ld_dc_inst_vls_dup2,ld_dc_vreg_dup2[VREG-1:0]};
assign lsu_idu_ex2_vreg_dup3[VREG:0]         = {ld_dc_inst_vls_dup3,ld_dc_vreg_dup3[VREG-1:0]};
//==========================================================
//        for mmu power
//==========================================================
assign lsu_mmu_vabuf0[`WK_PA_WIDTH-13:0] = ld_dc_vpn[`WK_PA_WIDTH-13:0];

// &ModuleEnd; @1244
endmodule


