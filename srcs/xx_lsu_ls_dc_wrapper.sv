//-----------------------------------------------------------------------------
// File          : xx_lsu_ls_ag_wrapper.v
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

// &ModuleBeg; @28
module xx_lsu_ls_dc_wrapper #(
  parameter VB_DATA_ENTRY = 3,
  parameter LSIQ_ENTRY = 12,
  parameter SDIQ_ENTRY = 12,  
  parameter IID_WIDTH  = 7,
  parameter SDID_LEN   = 4,
  parameter SNQ_ENTRY  = 6,
  parameter PC_LEN     = 15,
  parameter LQ_ENTRY   = 16,
  parameter VMB_ENTRY  = 8,
  parameter PREG       = 7,
  parameter VREG       = 6
)(
// &Ports; @29
input logic                                           rtu_ck_flush,
input logic   [IID_WIDTH-1  :0]                       rtu_ck_flush_iid,
input logic                                           cb_ld_dc_addr_hit,                      
input logic                                           cp0_lsu_da_fwd_dis,                     
input logic                                           cp0_lsu_dcache_en,               
input logic                                           cp0_lsu_ecc_en,                  
input logic                                           cp0_lsu_icg_en,                  
input logic                                           cp0_lsu_l2_st_pref_en,           
input logic                                           cpurst_b,
input logic                                           ctrl_ld_clk,                         
input logic                                           ctrl_st_clk,
input logic   [2 :0]                                  dcache_arb_lsdc_borrow_db,                  
input logic   [1 :0]                                  dcache_arb_lsdc_borrow_idx_5to4,       
input logic                                           dcache_arb_lsdc_borrow_mmu,            
input logic                                           dcache_arb_lsdc_borrow_sndb,           
input logic                                           dcache_arb_lsdc_borrow_vb,                
input logic                                           dcache_arb_lsdc_borrow_wmb,
input logic   [1 :0]                                  dcache_arb_lsdc_settle_way,                           
input logic                                           dcache_arb_lsdc_borrow_icc,     
input logic                                           dcache_arb_lsdc_borrow_snq,     
input logic   [SNQ_ENTRY-1:0]                         dcache_arb_lsdc_borrow_snq_id,  
input logic                                           dcache_arb_lsdc_borrow_vld,     
input logic                                           dcache_arb_lsdc_borrow_vld_gate,
input logic                                           dcache_arb_lsdc_dcache_replace, 
input logic   [1 :0]                                  dcache_arb_lsdc_ex1_dcache_sw,      
input logic                                           dcache_lsdc_dirty_gwen,               
input logic   [7 :0]                                  dcache_lsdc_idx,                      
input logic   [`WK_LS_DCACHE_META_WIDTH-1:0]          dcache_lsdc_dirty_dout,        
input logic   [`WK_LS_DCACHE_LDTAG_WIDTH-1:0]         dcache_lsdc_tag_dout,    //st_tag 52 bit, ld_tag 68 bit, use 68, LTL@20241107      
input logic                                           forever_cpuclk,                  
input logic                                           icc_dcache_arb_ecc_read,                
input logic                                           icc_dcache_arb_ld_tag_read,                                        
input logic                                           pad_yy_icg_scan_en,              
input logic   [IID_WIDTH-1:0]                         rtu_lsu_commit0_iid_updt_val,     
input logic   [IID_WIDTH-1:0]                         rtu_lsu_commit1_iid_updt_val,     
input logic   [IID_WIDTH-1:0]                         rtu_lsu_commit2_iid_updt_val,
input logic   [IID_WIDTH-1:0]                         rtu_lsu_commit3_iid_updt_val,     
input logic   [IID_WIDTH-1:0]                         rtu_lsu_commit4_iid_updt_val,     
input logic   [IID_WIDTH-1:0]                         rtu_lsu_commit5_iid_updt_val,     
input logic   [IID_WIDTH-1:0]                         rtu_lsu_commit6_iid_updt_val,     
input logic   [IID_WIDTH-1:0]                         rtu_lsu_commit7_iid_updt_val,    
input logic                                           rtu_lsu_flush_fe,                
input logic   [SDID_LEN-1:0]                          std0_rf_sdid,  //1->2, for 2 std, LTL@20241125
input logic   [SDID_LEN-1:0]                          std1_rf_sdid,                  
input logic                                           sq_lsdc_ex2_full,                   
input logic                                           sq_lsdc_ex2_inst_hit,
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
input logic   [3 :0]                                  lsag_lsdc_ex1_rot_sel,
input logic                                           lsag_lsdc_ex1_vload_ahead_inst_vld,          
input logic                                           lsag_lsdc_ex1_vload_inst_vld,                
input logic                                           lsag_lsdc_ex1_dtcm_hit,                  
input logic   [8 :0]                                  lsag_lsdc_ex1_element_cnt,
input logic   [3 :0]                                  lsag_lsdc_ex1_element_offset,               
input logic   [1 :0]                                  lsag_lsdc_ex1_element_size,              
input logic                                           lsag_lsdc_ex1_expt_access_fault_with_page,
input logic                                           lsag_lsdc_ex1_expt_illegal_inst,         
input logic                                           lsag_lsdc_ex1_expt_misalign_no_page,     
input logic                                           lsag_lsdc_ex1_expt_misalign_with_page,   
input logic                                           lsag_lsdc_ex1_expt_page_fault,           
input logic                                           lsag_lsdc_ex1_expt_amo_not_ca,         
input logic                                           lsag_lsdc_ex1_expt_vld,                  
input logic   [3 :0]                                  lsag_lsdc_ex1_fence_mode,                
input logic                                           lsag_lsdc_ex1_icc,                       
input logic                                           lsag_lsdc_ex1_idx_order,                 
input logic   [IID_WIDTH-1:0]                         lsag_ex1_iid,                       
input logic                                           lsag_lsdc_ex1_inst_flush,                
input logic   [1 :0]                                  lsag_lsdc_ex1_inst_mode,
input logic                                           lsag_lsdc_ex1_inst_fof,                 
input logic   [1 :0]                                  lsag_lsdc_ex1_inst_type,                 
input logic                                           lsag_ex1_inst_vld,
input logic                                           lsag_lsdc_ex1_inst_vfls,                  
input logic                                           lsag_lsdc_ex1_inst_vls,                  
input logic                                           lsag_lsdc_ex1_itcm_hit,
input logic   [PC_LEN-1:0]                            lsag_lsdc_ex1_ldfifo_pc,                   
input logic                                           lsag_lsdc_ex1_lsfifo,                    
input logic   [LSIQ_ENTRY-1:0]                        lsag_lsdc_ex1_lsid,                                
input logic                                           lsag_lsdc_ex1_lsiq_spec_fail,            
input logic   [`WK_PA_WIDTH-1:0]                      lsag_lsdc_ex1_mt_value,                  
input logic   [1 :0]                                  lsag_lsdc_ex1_no_spec,
input logic                                           lsag_lsdc_ex1_no_spec_exist,                   
input logic                                           lsag_lsdc_ex1_old,                       
input logic                                           lsag_lsdc_ex1_page_buf,                  
input logic                                           lsag_lsdc_ex1_page_ca,                   
input logic                                           lsag_lsdc_ex1_page_sec,
input logic                                           lsag_lsdc_ex1_page_share,
input logic                                           lsag_lsdc_ex1_page_so,                  
input logic                                           lsag_lsdc_ex1_page_wa,
input logic                                           lsag_lsdc_ex1_pf_inst,                   
input logic   [PC_LEN-1:0]                            lsag_lsdc_ex1_pc,
input logic   [PREG-1 :0]                             lsag_lsdc_ex1_preg,         
input logic                                           lsag_lsdc_ex1_raw_new,      
input logic   [15:0]                                  lsag_lsdc_ex1_reg_bytes_vld,                        
input logic   [15:0]                                  lsag_lsdc_ex1_reg_bytes_vld1,                        
input logic   [15:0]                                  lsag_lsdc_ex1_reg_bytes_vld2,                        
input logic   [15:0]                                  lsag_lsdc_ex1_reg_bytes_vld3,                        
input logic   [3 :0]                                  lsag_lsdc_ex1_us_way,
input logic   [SDIQ_ENTRY-1:0]                        lsag_lsdc_ex1_sdiq_entry,                   
input logic                                           lsag_lsdc_ex1_secd,
input logic                                           lsag_lsdc_ex1_sign_extend,                      
input logic                                           lsag_lsdc_ex1_split,                     
input logic                                           lsag_lsdc_ex1_st,                        
input logic                                           lsag_lsdc_ex1_staddr,                    
input logic                                           lsag_lsdc_ex1_sync_fence,                
input logic                                           lsag_lsdc_ex1_utlb_miss,
// input logic   [1 :0]                                  lsag_lsdc_ex1_vlmul,   
input logic   [2 :0]  lsag_lsdc_ex1_vlmul,  //pwh 1 for rvv1.0     
input logic   [7 :0]                                  lsag_lsdc_ex1_vmb_id,       
input logic                                           lsag_lsdc_ex1_vmb_merge_vld,                 
input logic   [`WK_PA_WIDTH-13:0]                     lsag_lsdc_ex1_vpn,
input logic   [VREG-1 :0]                             lsag_lsdc_ex1_vreg,                       
//input logic   [1 :0]                                  lsag_lsdc_ex1_vsew, //rvv1.0@hcl
input logic   [1 :0]  lsag_lsdc_ex1_vmew, //rvv1.0@hcl
input logic   [1 :0]  lsag_lsdc_ex1_vmop, //rvv1.0@hcl
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
input logic                                           mmu_lsu_imme_wakeup, // wjh@tmq-full, mrg-on-cmplt
input logic                                           pfu_pfb_empty,                 
input logic                                           pfu_sdb_create_gateclk_en,     
input logic                                           pfu_sdb_empty,                 
input logic                                           rb_fence_ld,                             
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
input logic   [IID_WIDTH-1:0]                         lsdc_selfdc_ex2_iid,
input logic                                           lsdc_selfdc_ex2_chk_ld_inst,                                                       
output logic  [SDIQ_ENTRY-1:0]                        lsu_idu_ex2_sdiq_entry,           
output logic                                          lsu_idu_ex2_staddr1_vld,          
output logic                                          lsu_idu_ex2_staddr_unalign,       
output logic                                          lsu_idu_ex2_staddr_vld,           
output logic  [`WK_PA_WIDTH-13:0]                     lsu_mmu_vabuf,
output logic                                          lsdc_ex2_is_load,                  
output logic  [`WK_PA_WIDTH-1:0]                      lsdc_ex2_addr0,
output logic  [`WK_PA_WIDTH-1:0]                      lsdc_ex2_ld_addr0,//timing@LTL
output logic  [`WK_PA_WIDTH-1:0]                      lsdc_ex2_st_addr0,//timing@LTL
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
output logic                                          lsdc_lsda_ex2_borrow_wmb,      
output logic                                          lsdc_lsda_ex2_borrow_dcache_replace,     
output logic  [1 :0]                                  lsdc_lsda_ex2_borrow_dcache_sw,                         
output logic                                          lsdc_lsda_ex2_borrow_snq,                
output logic  [SNQ_ENTRY-1:0]                         lsdc_lsda_ex2_borrow_snq_id,             
output logic                                          lsdc_ex2_borrow_vld,                
output logic                                          lsdc_ex2_boundary,                  
output logic                                          lsdc_sq_ex2_boundary_first,            
output logic  [15:0]                                  lsdc_ex2_bytes_vld,
output logic  [15:0]                                  lsdc_ex2_ld_bytes_vld,//timing
output logic  [15:0]                                  lsdc_ex2_st_bytes_vld,//timing
output logic  [15:0]                                  lsdc_ex2_bytes_vld1,
output logic  [15:0]                                  lsdc_ex2_bytes_vld2,
output logic  [15:0]                                  lsdc_ex2_bytes_vld3,
output logic                                          lsdc_cb_ex2_addr_create_gateclk_en,
output logic                                          lsdc_cb_ex2_addr_create_vld,       
output logic  [`WK_PA_WIDTH-5:0]                      lsdc_cb_ex2_addr_tto4,                              
output logic                                          lsdc_ex2_chk_st_inst_vld,           
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
output logic                                          lsdc_sq_ex2_cmit0_iid_crt_hit,          
output logic                                          lsdc_sq_ex2_cmit1_iid_crt_hit,          
output logic                                          lsdc_sq_ex2_cmit2_iid_crt_hit,
output logic                                          lsdc_sq_ex2_cmit3_iid_crt_hit,          
output logic                                          lsdc_sq_ex2_cmit4_iid_crt_hit,          
output logic                                          lsdc_sq_ex2_cmit5_iid_crt_hit,
output logic                                          lsdc_sq_ex2_cmit6_iid_crt_hit,          
output logic                                          lsdc_sq_ex2_cmit7_iid_crt_hit,      
output logic  [15 :0]                                 lsdc_lsda_ex2_dcache_dirty_array,    //[16] deleted, L1D 2->4way, LTL@20250324 
output logic  [`WK_LS_DCACHE_TAG_NOECC_WIDTH-1:0]     lsdc_lsda_ex2_dcache_tag_array,          
output logic                                          lsdc_lsda_ex2_inst_vld, 
output logic  [LQ_ENTRY-1:0]                          lsdc_lsda_ex2_lq_entry,             
output logic                                          lsdc_ex2_page_buf,               
output logic                                          lsdc_ex2_page_ca,                
output logic                                          lsdc_ex2_page_sec,               
output logic                                          lsdc_ex2_page_share,             
output logic                                          lsdc_ex2_page_so,                
output logic                                          lsdc_ex2_page_wa, 
output logic  [`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0]  lsdc_lsda_ex2_tag_read,   
output logic                                          lsdc_lsda_ex2_data_inj_dp,
output logic                                          lsdc_lsda_ex2_dcache_hit,               
output logic                                          lsdc_lsda_ex2_staddr_vld,             
output logic                                          lsdc_lsda_ex2_tag0_hit,               
output logic                                          lsdc_lsda_ex2_tag1_hit,               
output logic                                          lsdc_lsda_ex2_tag2_hit,               
output logic                                          lsdc_lsda_ex2_tag3_hit,
output logic                                          lsdc_lsda_ex2_dcwp_hit_idx,              
output logic                                          lsdc_ex2_dtcm_hit,                 
output logic  [8 :0]                                  lsdc_lsda_ex2_element_cnt,               
output logic  [1 :0]                                  lsdc_ex2_element_size,              
output logic                                          lsdc_lsda_ex2_expt_access_fault_extra,   
output logic                                          lsdc_lsda_ex2_expt_access_fault_mask,    
output logic  [4 :0]                                  lsdc_lsda_ex2_expt_vec,                  
output logic                                          lsdc_lsda_ex2_expt_vld_except_access_err,
output logic  [15:0]                                  lsdc_lsda_ex2_fwd_bytes_vld,
output logic                                          lsdc_ex2_fwd_sq_vld,        
output logic                                          lsdc_ex2_fwd_wmb_vld,  
output logic  [3 :0]                                  lsdc_ex2_get_dcache_data,
output logic                                          lsdc_ex2_hit_3_region,
output logic                                          lsdc_ex2_hit_2_region,
output logic                                          lsdc_ex2_hit_1_region,
output logic                                          lsdc_ex2_hit_0_region, 
output logic  [3 :0]                                  lsdc_ex2_hit_way,            
output logic  [3 :0]                                  lsdc_ex2_fence_mode,                
output logic                                          lsdc_lsda_ex2_get_dcache_tag_dirty,      
output logic                                          lsdc_ex2_icc,                       
output logic  [LSIQ_ENTRY-1:0]                        lsdc_idu_ex2_sq_full,
output logic  [LSIQ_ENTRY-1:0]                        lsdc_idu_ex2_lq_full,               
output logic  [LSIQ_ENTRY-1:0]                        lsdc_idu_ex2_tlb_busy,              
output logic                                          lsdc_sq_ex2_idx_order,                 
output logic  [IID_WIDTH-1:0]                         lsdc_ex2_iid,                       
output logic  [IID_WIDTH-1:0]                         lsdc_ex2_ld_iid, //logic levels opt@LTL
output logic  [IID_WIDTH-1:0]                         lsdc_ex2_st_iid, //logic levels opt@LTL
output logic  [LSIQ_ENTRY-1:0]                        lsdc_ex2_imme_wakeup,
output logic                                          lsdc_ex2_inst_chk_vld,  //only for ld, LTL               
output logic                                          lsdc_sq_ex2_inst_flush,                
output logic  [1 :0]                                  lsdc_ex2_inst_mode,
output logic                                          lsdc_lsda_ex2_inst_fof,                 
output logic  [2 :0]                                  lsdc_ex2_inst_size,                 
output logic  [1 :0]                                  lsdc_ex2_inst_type,
output logic                                          lsdc_lsda_ex2_inst_vfls,                  
output logic                                          lsdc_ex2_inst_vld,                  
output logic                                          lsdc_ex2_inst_vls,                  
output logic                                          lsdc_ex2_itcm_hit,   //LTL
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
output logic  [PREG-1 :0]                             lsdc_lsda_ex2_preg,          
output logic  [3 :0]                                  lsdc_lsda_ex2_preg_sign_sel,
output logic  [15:0]                                  lsdc_lsda_ex2_reg_bytes_vld,                    
output logic  [15:0]                                  lsdc_lsda_ex2_reg_bytes_vld1,                    
output logic  [15:0]                                  lsdc_lsda_ex2_reg_bytes_vld2,                    
output logic  [15:0]                                  lsdc_lsda_ex2_reg_bytes_vld3,                    
output logic                                          lsdc_lsda_ex2_inst_us,
output logic                                          lsdc_lsda_ex2_us_discard,
output logic                                          lsdc_ex2_old,                       
output logic  [PC_LEN-1:0]                            lsdc_lsda_ex2_pc,         //parameterized by LTL@20241104                    
output logic                                          lsdc_lsda_ex2_pf_inst,                   
output logic  [`WK_PA_WIDTH-1:0]                      lsdc_lsda_ex2_pfu_va,                    
output logic  [15:0]                                  lsdc_sq_ex2_rot_sel_rev,               
output logic  [SDID_LEN-1 :0]                         lsdc_sq_ex2_sdid,       //parameterized by LTL@20241021                
output logic                                          lsdc_sq_ex2_sdid_hit0,          //1->2, LTL@20241123
output logic                                          lsdc_sq_ex2_sdid_hit1,                  
//output logic                                          lsdc_ex2_secd, //llo@LTL
output logic                                          lsdc_ex2_ld_secd,
output logic                                          lsdc_ex2_st_secd,
output logic  [1 :0]                                  lsdc_lsda_ex2_settle_way,  
output logic  [8 :0]                                  lsdc_lsda_ex2_setvl_val,   
output logic                                          lsdc_lsda_ex2_sign_extend,                      
output logic                                          lsdc_lsda_ex2_spec_fail,                 
output logic                                          lsdc_lsda_ex2_split,                   
output logic                                          lsdc_sq_ex2_create_dp_vld,          
output logic                                          lsdc_sq_ex2_create_gateclk_en,      
output logic                                          lsdc_sq_ex2_create_vld,             
output logic                                          lsdc_sq_ex2_data_vld,               
output logic                                          lsdc_ex2_sq_full_gateclk_en,        
output logic                                          lsdc_lsda_ex2_st,                        
output logic                                          lsdc_ex2_sync_fence,                
output logic                                          lsdc_lsda_ex2_tag_inj_dp,                
output logic                                          lsdc_ex2_tlb_busy_gateclk_en,       
output logic                                          lsdc_lsda_ex2_vector_nop,                
//output logic  [1 :0]                                  lsdc_ex2_vsew, //rvv1.0@hcl
output logic  [1 :0]  lsdc_ex2_vmew,//rvv1.0@hcl
output logic  [1 :0]  lsdc_ex2_vmop,//rvv1.0@hcl                     
output logic                                          lsdc_sq_ex2_wo_st_inst,        
// output logic  [1 :0]                                  lsdc_lsda_ex2_vlmul,     
output logic  [2 :0]  lsdc_lsda_ex2_vlmul,  //pwh 2 for rvv1.0           
output logic  [7 :0]                                  lsdc_lsda_ex2_vmb_id,               
output logic                                          lsdc_lsda_ex2_vmb_merge_vld,        
output logic  [VREG-1 :0]                             lsdc_lsda_ex2_vreg,                 
output logic                                          lsdc_lsda_ex2_vreg_sign_sel,                       
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
output logic                                          lsdc_uop_older_than_another_lsdc,
output logic                                          ls_is_older_than_ls,
//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
input  logic                                          dtu_lsu_addr_trig_en,
input  logic                                          dtu_lsu_data_trig_en,
input  logic                                          ls_ag_boundary_unmask,
input  logic [2  :0]                                  ls_ag_dtu_access_size,
input  logic                                          ls_ag_dtu_last_check,
input  logic [1  :0]                                  ls_ag_dtu_type,
input  logic [47 :0]                                  ls_ag_dtu_va,
input  logic                                          ls_ag_dtu_vld,
input  logic [`TDT_MP_HINFO_WIDTH-1:0]                ls_ag_halt_info,
output logic                                          ls_dc_boundary_unmask,
output logic [47:0]                                   ls_dc_dtu_addr,
output logic [15:0]                                   ls_dc_dtu_addr_bytes_vld,
output logic [`TDT_MP_HINFO_WIDTH-1:0]                ls_dc_dtu_addr_halt_info,
output logic                                          ls_dc_dtu_addr_last_check,
output logic [2 :0]                                   ls_dc_dtu_addr_size,
output logic [1 :0]                                   ls_dc_dtu_addr_type,
output logic                                          ls_dc_dtu_addr_vld,
output logic                                          st_dc_data_check  
//==========================================================
//                  Risc-V Debug zdb End 
//==========================================================             
);

// &Regs; @30  

//ld type
logic  [3 :0]                                         lsdc_ex2_ld_hit_way;
logic                                                 lsdc_lsda_ex2_ld_dcache_hit;
logic                                                 lsag_lsdc_ex1_ld_inst_vld;  //=1 ust to valid pipe, =0 to invalid ld pipe, LTL@20241107 
logic                                                 lsag_ex1_ld_inst_vld;  //=1 ust to valid pipe, =0 to invalid ld pipe, LTL@20241107 
logic                                                 lsdc_ex2_is_load0;
//logic  [`WK_PA_WIDTH-1:0]                             lsdc_ex2_ld_addr0;        
logic                                                 lsdc_lsda_ex2_ld_already_da;           
logic                                                 lsdc_ex2_ld_atomic;   
logic                                                 lsdc_lsda_ex2_ld_borrow_icc;  
logic                                                 lsdc_ex2_ld_borrow_vld;    
logic                                                 lsdc_ex2_ld_boundary; 
//logic  [15:0]                                         lsdc_ex2_ld_bytes_vld;   
logic                                                 lsdc_ex2_ld_chk_atomic_inst_vld;     
logic                                                 lsdc_lsda_ex2_ld_expt_vld_gate_en;       
logic                                                 lsdc_lsda_ex2_ld_inst_vld;   
logic                                                 lsdc_ex2_ld_old;   
logic                                                 lsdc_ex2_ld_page_buf;          
logic                                                 lsdc_ex2_ld_page_ca;           
logic                                                 lsdc_ex2_ld_page_sec;          
logic                                                 lsdc_ex2_ld_page_share;        
logic                                                 lsdc_ex2_ld_page_so;           
logic  [PREG-1:0]                                     lsdc_lsda_ex2_ld_preg;
logic                                                 lsdc_lsda_ex2_ld_pf_inst;
logic                                                 lsdc_ex2_ld_dtcm_hit; 
logic  [8 :0]                                         lsdc_lsda_ex2_ld_element_cnt;          
logic  [1 :0]                                         lsdc_ex2_ld_element_size;         
logic                                                 lsdc_lsda_ex2_ld_expt_access_fault_extra;          
logic                                                 lsdc_lsda_ex2_ld_expt_access_fault_mask;           
logic  [4 :0]                                         lsdc_lsda_ex2_ld_expt_vec; 
logic                                                 lsdc_lsda_ex2_ld_expt_vld_except_access_err;         
logic  [LSIQ_ENTRY-1:0]                               lsdc_idu_ex2_ld_tlb_busy;         
//logic  [IID_WIDTH-1:0]                                lsdc_ex2_ld_iid;      
logic  [LSIQ_ENTRY-1:0]                               lsdc_ex2_ld_imme_wakeup;  
logic  [2 :0]                                         lsdc_ex2_ld_inst_size;
logic  [1 :0]                                         lsdc_ex2_ld_inst_type;         
logic                                                 lsdc_ex2_ld_inst_vld; 
logic                                                 lsdc_ex2_ld_inst_vls; 
logic                                                 lsdc_ex2_ld_itcm_hit;          
logic  [LSIQ_ENTRY-1:0]                               lsdc_lsda_ex2_ld_lsid;     
logic                                                 lsdc_lsda_ex2_ld_mmu_req;  
logic  [`WK_PA_WIDTH-1:0]                             lsdc_lsda_ex2_ld_mt_value; 
logic  [1 :0]                                         lsdc_lsda_ex2_ld_no_spec;           
logic  [`WK_PA_WIDTH-1:0]                             lsdc_lsda_ex2_ld_pfu_va; 
//logic                                                 lsdc_ex2_ld_secd;         
logic                                                 lsdc_lsda_ex2_ld_split;    
logic                                                 lsdc_lsda_ex2_ld_tag_inj_dp;           
logic                                                 lsdc_ex2_ld_tlb_busy_gateclk_en;  
logic                                                 lsdc_lsda_ex2_ld_vector_nop; 
//logic  [1 :0]                                         lsdc_ex2_ld_vsew; //rvv1.0@hcl 
logic  [1 :0]  lsdc_ex2_ld_vmew; //rvv1.0@hcl
logic  [1 :0]  lsdc_ex2_ld_vmop; //rvv1.0@hcl      
logic  [`WK_PA_WIDTH-13:0]                            lsu_mmu_vabuf0;    



//st type
logic  [3 :0]                                         lsdc_ex2_st_hit_way;
logic                                                 lsdc_ex2_dcache_hit;
logic                                                 lsag_lsdc_ex1_st_inst_vld;  //=1 ust to valid pipe, =0 to invalid st pipe, LTL@20241107
logic                                                 lsag_ex1_st_inst_vld;  //=1 ust to valid pipe, =0 to invalid ld pipe, LTL@20241107  
logic                                                 lsdc_ex2_is_load1;                
//logic  [`WK_PA_WIDTH-1:0]                             lsdc_ex2_st_addr0;  //lsu-timing@LTL                   
logic                                                 lsdc_lsda_ex2_st_already_da;                
logic                                                 lsdc_ex2_st_atomic;                                  
logic                                                 lsdc_lsda_ex2_st_borrow_icc;                
logic                                                 lsdc_ex2_st_borrow_vld;                
logic                                                 lsdc_ex2_st_boundary;                           
//logic  [15:0]                                         lsdc_ex2_st_bytes_vld;                         
logic                                                 lsdc_ex2_st_chk_atomic_inst_vld;               
logic                                                 lsdc_lsda_ex2_st_expt_vld_gate_en;       
logic                                                 lsdc_lsda_ex2_st_inst_vld;               
logic                                                 lsdc_ex2_st_page_buf;               
logic                                                 lsdc_ex2_st_page_ca;                
logic                                                 lsdc_ex2_st_page_sec;               
logic                                                 lsdc_ex2_st_page_share;             
logic                                                 lsdc_ex2_st_page_so;                                                             
logic  [PREG-1:0]                                     lsdc_lsda_ex2_st_preg;
logic                                                 lsdc_sq_ex2_st_dtcm_hit;                  
logic  [8 :0]                                         lsdc_lsda_ex2_st_element_cnt;               
logic  [1 :0]                                         lsdc_ex2_st_element_size;              
logic                                                 lsdc_lsda_ex2_st_expt_access_fault_extra;   
logic                                                 lsdc_lsda_ex2_st_expt_access_fault_mask;    
logic  [4 :0]                                         lsdc_lsda_ex2_st_expt_vec;                  
logic                                                 lsdc_lsda_ex2_st_expt_vld_except_access_err;                                               
logic  [LSIQ_ENTRY-1:0]                               lsdc_idu_ex2_st_tlb_busy;                           
//logic  [IID_WIDTH-1:0]                                lsdc_ex2_st_iid;                       
logic  [LSIQ_ENTRY-1:0]                               lsdc_ex2_st_imme_wakeup;                                            
logic  [2 :0]                                         lsdc_ex2_st_inst_size;                 
logic  [1 :0]                                         lsdc_ex2_st_inst_type;                 
logic                                                 lsdc_ex2_st_inst_vld;                  
logic                                                 lsdc_ex2_st_inst_vls;                  
logic                                                 lsdc_ex2_st_itcm_hit;   
logic  [LSIQ_ENTRY-1:0]                               lsdc_lsda_ex2_st_lsid;                                   
logic                                                 lsdc_lsda_ex2_st_mmu_req;                   
logic  [`WK_PA_WIDTH-1:0]                             lsdc_lsda_ex2_st_mt_value;                  
logic  [1 :0]                                         lsdc_lsda_ex2_st_no_spec;                   
logic                                                 lsdc_ex2_st_old;                                           
logic                                                 lsdc_lsda_ex2_st_pf_inst;                   
logic  [`WK_PA_WIDTH-1:0]                             lsdc_lsda_ex2_st_pfu_va;                                                           
//logic                                                 lsdc_ex2_st_secd;                      
logic                                                 lsdc_lsda_ex2_st_spec_fail;                 
logic                                                 lsdc_lsda_ex2_st_split;                           
logic                                                 lsdc_lsda_ex2_st_tag_inj_dp;                
logic                                                 lsdc_ex2_st_tlb_busy_gateclk_en;       
logic                                                 lsdc_lsda_ex2_st_vector_nop;                
//logic  [1 :0]                                         lsdc_ex2_st_vsew;  //rvv1.0@hcl 
logic  [1 :0]  lsdc_ex2_st_vmew;  //rvv1.0@hcl
logic  [1 :0]  lsdc_ex2_st_vmop;  //rvv1.0@hcl 
logic  [`WK_PA_WIDTH-13:0]                            lsu_mmu_vabuf1;  

logic  [`WK_LS_DCACHE_TAG_NOECC_WIDTH-1:0]            dcache_lsu_st_tag_dout;                                                                                                 

logic                                                 lsdc_lsda_ex2_ld_spec_fail;
logic                                                 lsdc_ex2_st_dtcm_hit;
//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
logic                                                 ls_dc_inst_clk;
//==========================================================
//                  Risc-V Debug zdb End 
//==========================================================
xx_lsu_ls_ld_dc #(
  .VB_DATA_ENTRY  (VB_DATA_ENTRY),
  .IID_WIDTH      (IID_WIDTH),    
  .LQ_ENTRY       (LQ_ENTRY),     
  .LSIQ_ENTRY     (LSIQ_ENTRY),   
  .VMB_ENTRY      (VMB_ENTRY),    
  .PC_LEN         (PC_LEN),
  .WK_PA_WIDTH    (`WK_PA_WIDTH),
  .PREG           (PREG),
  .VREG           (VREG)       
)
x_xx_lsu_ls_ld_dc (
    .cb_ld_dc_addr_hit                                 (cb_ld_dc_addr_hit),                                  
    .cp0_lsu_da_fwd_dis                                (cp0_lsu_da_fwd_dis),                                 
    .cp0_lsu_dcache_en                                 (cp0_lsu_dcache_en),                                  
    .cp0_lsu_ecc_en                                    (cp0_lsu_ecc_en),                                 
    .cp0_lsu_icg_en                                    (cp0_lsu_icg_en),                                 
    .cpurst_b                                          (cpurst_b),                                   
    .ctrl_ld_clk                                       (ctrl_ld_clk),                                
    .dcache_arb_lsdc_borrow_db                         (dcache_arb_lsdc_borrow_db),                                 
    .dcache_arb_lsdc_borrow_icc                        (dcache_arb_lsdc_borrow_icc),                                
    .dcache_arb_lsdc_borrow_idx_5to4                   (dcache_arb_lsdc_borrow_idx_5to4),                               
    .dcache_arb_lsdc_borrow_mmu                        (dcache_arb_lsdc_borrow_mmu),                                
    .dcache_arb_lsdc_borrow_sndb                       (dcache_arb_lsdc_borrow_sndb),                               
    .dcache_arb_lsdc_borrow_vb                         (dcache_arb_lsdc_borrow_vb),                                 
    .dcache_arb_lsdc_borrow_vld                        (dcache_arb_lsdc_borrow_vld),                                
    .dcache_arb_lsdc_borrow_vld_gate                   (dcache_arb_lsdc_borrow_vld_gate),                               
    .dcache_arb_lsdc_borrow_wmb                        (dcache_arb_lsdc_borrow_wmb),                                
    .dcache_arb_lsdc_settle_way                        (dcache_arb_lsdc_settle_way),                                
    .dcache_idx                                        (dcache_lsdc_idx),                                 
    .dcache_lsu_ld_tag_dout                            (dcache_lsdc_tag_dout),                                 
    .forever_cpuclk                                    (forever_cpuclk),                                                                  
    .icc_dcache_arb_ecc_read                           (icc_dcache_arb_ecc_read),                                
    .icc_dcache_arb_ld_tag_read                        (icc_dcache_arb_ld_tag_read),
    .lsag_ex1_is_load                                  (lsag_ex1_is_load),                                 
    .lsag_lsdc_ex1_addr1_to4                           (lsag_lsdc_ex1_addr1_to4),                                        
    .lsag_lsdc_ex1_ahead_predict                       (lsag_lsdc_ex1_ahead_predict),                                        
    .lsag_lsdc_ex1_already_da                          (lsag_lsdc_ex1_already_da),                                           
    .lsag_lsdc_ex1_atomic                              (lsag_lsdc_ex1_atomic),                                           
    .lsag_lsdc_ex1_boundary                            (lsag_lsdc_ex1_boundary),                                         
    .lsag_ex1_access_size                              (lsag_ex1_access_size),                                   
    .lsag_lsdc_ex1_acclr_en                            (lsag_lsdc_ex1_acclr_en),                                      
    .lsag_lsdc_ex1_addr0                               (lsag_lsdc_ex1_addr0),                                     
    .lsag_lsdc_ex1_bytes_vld                           (lsag_lsdc_ex1_bytes_vld),                                     
    .lsag_lsdc_ex1_bytes_vld1                          (lsag_lsdc_ex1_bytes_vld1),
    .lsag_lsdc_ex1_bytes_vld2                          (lsag_lsdc_ex1_bytes_vld2),
    .lsag_lsdc_ex1_bytes_vld3                          (lsag_lsdc_ex1_bytes_vld3),                                        
    .lsag_lsdc_ex1_inst_us                             (lsag_lsdc_ex1_inst_us),
    .lsag_lsdc_ex1_fwd_bypass_en                       (lsag_lsdc_ex1_fwd_bypass_en),                                     
    .lsag_lsdc_ex1_inst_vld                            (lsag_lsdc_ex1_ld_inst_vld),                                      
    .lsag_lsdc_ex1_load_ahead_inst_vld                 (lsag_lsdc_ex1_load_ahead_inst_vld),                                       
    .lsag_lsdc_ex1_load_inst_vld                       (lsag_lsdc_ex1_load_inst_vld),                                     
    .lsag_lsdc_ex1_mmu_req                             (lsag_lsdc_ex1_mmu_req),                                       
    .lsag_lsdc_ex1_page_so                             (lsag_lsdc_ex1_page_so),                                       
    .lsag_lsdc_ex1_rot_sel                             (lsag_lsdc_ex1_rot_sel),                                       
    .lsag_lsdc_ex1_vload_ahead_inst_vld                (lsag_lsdc_ex1_vload_ahead_inst_vld),                                      
    .lsag_lsdc_ex1_vload_inst_vld                      (lsag_lsdc_ex1_vload_inst_vld),                                        
    .lsag_lsdc_ex1_dtcm_hit                            (lsag_lsdc_ex1_dtcm_hit),                                         
    .lsag_lsdc_ex1_element_cnt                         (lsag_lsdc_ex1_element_cnt),                                          
    .lsag_lsdc_ex1_element_offset                      (lsag_lsdc_ex1_element_offset),                                           
    .lsag_lsdc_ex1_element_size                        (lsag_lsdc_ex1_element_size),                                         
    .lsag_lsdc_ex1_expt_access_fault_with_page         (lsag_lsdc_ex1_expt_access_fault_with_page),                                          
    .lsag_lsdc_ex1_expt_amo_not_ca                     (lsag_lsdc_ex1_expt_amo_not_ca),                                        
    .lsag_lsdc_ex1_expt_misalign_no_page               (lsag_lsdc_ex1_expt_misalign_no_page),                                        
    .lsag_lsdc_ex1_expt_misalign_with_page             (lsag_lsdc_ex1_expt_misalign_with_page),                                          
    .lsag_lsdc_ex1_expt_page_fault                     (lsag_lsdc_ex1_expt_page_fault),                                          
    .lsag_lsdc_ex1_expt_vld                            (lsag_lsdc_ex1_expt_vld),                                         
    .lsag_ex1_iid                                      (lsag_ex1_iid),                                      
    .lsag_lsdc_ex1_inst_fof                            (lsag_lsdc_ex1_inst_fof),                                         
    .lsag_lsdc_ex1_inst_type                           (lsag_lsdc_ex1_inst_type),                                        
    .lsag_lsdc_ex1_inst_vfls                           (lsag_lsdc_ex1_inst_vfls),                                        
    .lsag_ex1_inst_vld                                 (lsag_ex1_ld_inst_vld),                                     
    .lsag_lsdc_ex1_inst_vls                            (lsag_lsdc_ex1_inst_vls),                                         
    .lsag_lsdc_ex1_itcm_hit                            (lsag_lsdc_ex1_itcm_hit),                                         
    .lsag_lsdc_ex1_ldfifo_pc                           (lsag_lsdc_ex1_ldfifo_pc),                                        
    .lsag_lsdc_ex1_lsid                                (lsag_lsdc_ex1_lsid),                                                                                   
    .lsag_lsdc_ex1_lsiq_spec_fail                      (lsag_lsdc_ex1_lsiq_spec_fail),                                           
    .lsag_lsdc_ex1_no_spec                             (lsag_lsdc_ex1_no_spec),                                          
    .lsag_lsdc_ex1_no_spec_exist                       (lsag_lsdc_ex1_no_spec_exist),                                        
    .lsag_lsdc_ex1_old                                 (lsag_lsdc_ex1_old),                                          
    .lsag_lsdc_ex1_page_buf                            (lsag_lsdc_ex1_page_buf),                                         
    .lsag_lsdc_ex1_page_ca                             (lsag_lsdc_ex1_page_ca),                                          
    .lsag_lsdc_ex1_page_sec                            (lsag_lsdc_ex1_page_sec),                                         
    .lsag_lsdc_ex1_page_share                          (lsag_lsdc_ex1_page_share),                                           
    .lsag_lsdc_ex1_pf_inst                             (lsag_lsdc_ex1_pf_inst),                                          
    .lsag_lsdc_ex1_preg                                (lsag_lsdc_ex1_preg),                                         
    .lsag_lsdc_ex1_raw_new                             (lsag_lsdc_ex1_raw_new),                                          
    .lsag_lsdc_ex1_reg_bytes_vld                       (lsag_lsdc_ex1_reg_bytes_vld),                                        
    .lsag_lsdc_ex1_reg_bytes_vld1                      (lsag_lsdc_ex1_reg_bytes_vld1),
    .lsag_lsdc_ex1_reg_bytes_vld2                      (lsag_lsdc_ex1_reg_bytes_vld2),
    .lsag_lsdc_ex1_reg_bytes_vld3                      (lsag_lsdc_ex1_reg_bytes_vld3),
    .lsag_lsdc_ex1_us_way                              (lsag_lsdc_ex1_us_way),
    .lsag_lsdc_ex1_secd                                (lsag_lsdc_ex1_secd),                                         
    .lsag_lsdc_ex1_sign_extend                         (lsag_lsdc_ex1_sign_extend),                                          
    .lsag_lsdc_ex1_split                               (lsag_lsdc_ex1_split),                                        
    .lsag_lsdc_ex1_utlb_miss                           (lsag_lsdc_ex1_utlb_miss),                                        
    .lsag_lsdc_ex1_vlmul                               (lsag_lsdc_ex1_vlmul),                                        
    .lsag_lsdc_ex1_vmb_id                              (lsag_lsdc_ex1_vmb_id),                                           
    .lsag_lsdc_ex1_vmb_merge_vld                       (lsag_lsdc_ex1_vmb_merge_vld),                                        
    .lsag_lsdc_ex1_vpn                                 (lsag_lsdc_ex1_vpn),                                          
    .lsag_lsdc_ex1_vreg                                (lsag_lsdc_ex1_vreg),                                         
    //.lsag_lsdc_ex1_vsew                                (lsag_lsdc_ex1_vsew), //rvv1.0@hcl
    .lsag_lsdc_ex1_vmew                                (lsag_lsdc_ex1_vmew), //rvv1.0@hcl
    .lsag_lsdc_ex1_vmop                                (lsag_lsdc_ex1_vmop), //rvv1.0@hcl                                         
    .lq_lsdc_ex2_create_entry                          (lq_lsdc_ex2_create_entry),                                      
    .lq_lsdc_ex2_full                                  (lq_lsdc_ex2_full),                                      
    .lq_lsdc_ex2_inst_hit                              (lq_lsdc_ex2_inst_hit),                                      
    .lq_lsdc_ex2_less2                                 (lq_lsdc_ex2_less2),                                     
    .lq_lsdc_ex2_spec_fail                             (lq_lsdc_ex2_spec_fail),                                     
    .lsu_dcache_ld_xx_gwen                             (lsu_dcache_ld_xx_gwen),                                  
    .lsu_has_fence                                     (lsu_has_fence),                                  
    .mmu_lsu_data_req_size                             (mmu_lsu_data_req_size),                                  
    .mmu_lsu_mmu_en                                    (mmu_lsu_mmu_en),                                 
    .mmu_lsu_tlb_busy                                  (mmu_lsu_tlb_busy),                                   
    .mmu_lsu_imme_wakeup                               (mmu_lsu_imme_wakeup), // wjh@tmq-full, mrg-on-cmplt
    .pad_yy_icg_scan_en                                (pad_yy_icg_scan_en),                                 
    .pfu_pfb_empty                                     (pfu_pfb_empty),                                  
    .pfu_sdb_create_gateclk_en                         (pfu_sdb_create_gateclk_en),                                  
    .pfu_sdb_empty                                     (pfu_sdb_empty),                                  
    .rb_fence_ld                                       (rb_fence_ld),
    .rtu_lsu_flush_fe                                  (rtu_lsu_flush_fe),                                    
    .rtu_ck_flush                                      (rtu_ck_flush),
    .rtu_ck_flush_iid                                  (rtu_ck_flush_iid),
    .sq_lsdc_ex2_addr1_dep_discard                     (sq_lsdc_ex2_addr1_dep_discard),                                     
    .sq_lsdc_ex2_cancel_acc_req                        (sq_lsdc_ex2_cancel_acc_req),                                    
    .sq_lsdc_ex2_cancel_ahead_wb                       (sq_lsdc_ex2_cancel_ahead_wb),                                   
    .sq_lsdc_ex2_fwd_req                               (sq_lsdc_ex2_fwd_req),                                   
    .sq_lsdc_ex2_has_fwd_req                           (sq_lsdc_ex2_has_fwd_req),                                   
    .lsdc_selfdc_ex2_addr0                             (lsdc_selfdc_ex2_addr0),                                            
    .lsdc_selfdc_ex2_bytes_vld                         (lsdc_selfdc_ex2_bytes_vld),                                            
    .lsdc_selfdc_ex2_chk_st_inst_vld                   (lsdc_selfdc_ex2_chk_st_inst_vld),                                          
    .lsdc_selfdc_ex2_chk_statomic_inst_vld             (lsdc_selfdc_ex2_chk_statomic_inst_vld),                                            
    .lsdc_selfdc_ex2_inst_vld                          (lsdc_selfdc_ex2_inst_vld),                                             
    .wmb_lsdc_dcache_get_data                          (wmb_lsdc_dcache_get_data),                                        
    .wmb_lsdc_fwd_bytes_vld                            (wmb_lsdc_fwd_bytes_vld),                                      
    .wmb_lsdc_cancel_acc_req                           (wmb_lsdc_cancel_acc_req),                               
    .wmb_lsdc_discard_req                              (wmb_lsdc_discard_req),                                  
    .wmb_lsdc_fwd_req                                  (wmb_lsdc_fwd_req),
    .lsdc_ex2_is_load                                  (lsdc_ex2_is_load0),                                  
    .lsdc_ex2_addr0                                    (lsdc_ex2_ld_addr0),                                    
    .lsdc_ex2_addr1                                    (lsdc_ex2_addr1),                                    
    .lsdc_ex2_addr1_11to4                              (lsdc_ex2_addr1_11to4),                                      
    .lsdc_lsda_ex2_ahead_predict                       (lsdc_lsda_ex2_ahead_predict),                                        
    .lsdc_lsda_ex2_ahead_preg_wb_vld                   (lsdc_lsda_ex2_ahead_preg_wb_vld),                                        
    .lsdc_lsda_ex2_ahead_vreg_wb_vld                   (lsdc_lsda_ex2_ahead_vreg_wb_vld),                                        
    .lsdc_lsda_ex2_already_da                          (lsdc_lsda_ex2_ld_already_da),                                           
    .lsdc_ex2_atomic                                   (lsdc_ex2_ld_atomic),                                                                           
    .lsdc_lsda_ex2_borrow_db                           (lsdc_lsda_ex2_borrow_db),                                        
    .lsdc_lsda_ex2_borrow_icc                          (lsdc_lsda_ex2_ld_borrow_icc),                                           
    .lsdc_lsda_ex2_borrow_icc_ecc                      (lsdc_lsda_ex2_borrow_icc_ecc),                                           
    .lsdc_lsda_ex2_borrow_icc_tag                      (lsdc_lsda_ex2_borrow_icc_tag),                                           
    .lsdc_lsda_ex2_borrow_idx_5to4                     (lsdc_lsda_ex2_borrow_idx_5to4),                                          
    .lsdc_lsda_ex2_borrow_mmu                          (lsdc_lsda_ex2_borrow_mmu),                                           
    .lsdc_lsda_ex2_borrow_sndb                         (lsdc_lsda_ex2_borrow_sndb),                                          
    .lsdc_lsda_ex2_borrow_vb                           (lsdc_lsda_ex2_borrow_vb),                                        
    .lsdc_ex2_borrow_vld                               (lsdc_ex2_ld_borrow_vld),                                   
    .lsdc_lsda_ex2_borrow_wmb                          (lsdc_lsda_ex2_borrow_wmb),                                           
    .lsdc_ex2_boundary                                 (lsdc_ex2_ld_boundary),                                     
    .lsdc_ex2_bytes_vld                                (lsdc_ex2_ld_bytes_vld),   //use lsdc_ex2 not lsdc_lsda_ex2, LTL@20241118, ???                                 
    .lsdc_ex2_bytes_vld1                               (lsdc_ex2_bytes_vld1),                                   
    .lsdc_ex2_bytes_vld2                               (lsdc_ex2_bytes_vld2),                                   
    .lsdc_ex2_bytes_vld3                               (lsdc_ex2_bytes_vld3),                                   
    .lsdc_cb_ex2_addr_create_gateclk_en                (lsdc_cb_ex2_addr_create_gateclk_en),                                    
    .lsdc_cb_ex2_addr_create_vld                       (lsdc_cb_ex2_addr_create_vld),                                   
    .lsdc_cb_ex2_addr_tto4                             (lsdc_cb_ex2_addr_tto4),                                     
    .lsdc_ex2_chk_atomic_inst_vld                      (lsdc_ex2_ld_chk_atomic_inst_vld),                                      
    .lsdc_ex2_chk_ld_addr1_vld                         (lsdc_ex2_chk_ld_addr1_vld),                                     
    .lsdc_sq_ex2_chk_ld_bypass_vld                     (lsdc_sq_ex2_chk_ld_bypass_vld),                                        
    .lsdc_ex2_chk_ld_inst_vld                          (lsdc_ex2_chk_ld_inst_vld),                                      
    .lsdc_lsda_ex2_bytes_vld                           (lsdc_lsda_ex2_bytes_vld),                                     
    .lsdc_lsda_ex2_bytes_vld1                          (lsdc_lsda_ex2_bytes_vld1),                                        
    .lsdc_lsda_ex2_bytes_vld2                          (lsdc_lsda_ex2_bytes_vld2),                                        
    .lsdc_lsda_ex2_bytes_vld3                          (lsdc_lsda_ex2_bytes_vld3),                                        
    .lsdc_lsda_ex2_cb_addr_create                      (lsdc_lsda_ex2_cb_addr_create),                                        
    .lsdc_lsda_ex2_cb_merge_en                         (lsdc_lsda_ex2_cb_merge_en),                                       
    .lsdc_lsda_ex2_data_rot_sel                        (lsdc_lsda_ex2_data_rot_sel),                                      
    .lsdc_lsda_ex2_expt_vld_gate_en                    (lsdc_lsda_ex2_ld_expt_vld_gate_en),                                      
    .lsdc_lsda_ex2_icc_tag_vld                         (lsdc_lsda_ex2_icc_tag_vld),                                       
    .lsdc_lsda_ex2_inst_vld                            (lsdc_lsda_ex2_ld_inst_vld),                                      
    .lsdc_lsda_ex2_lq_entry                            (lsdc_lsda_ex2_lq_entry),                                      
    .lsdc_ex2_old                                      (lsdc_ex2_ld_old),                                   
    .lsdc_ex2_page_buf                                 (lsdc_ex2_ld_page_buf),                                  
    .lsdc_ex2_page_ca                                  (lsdc_ex2_ld_page_ca),                                   
    .lsdc_ex2_page_sec                                 (lsdc_ex2_ld_page_sec),                                  
    .lsdc_ex2_page_share                               (lsdc_ex2_ld_page_share),                                
    .lsdc_ex2_page_so                                  (lsdc_ex2_ld_page_so), 
    .lsdc_lsda_ex2_pf_inst                             (lsdc_lsda_ex2_ld_pf_inst),                                    
    .lsdc_lsda_ex2_tag_read                            (lsdc_lsda_ex2_tag_read),                                      
    .lsdc_lsda_ex2_data_inj_dp                         (lsdc_lsda_ex2_data_inj_dp),                                          
    .lsdc_lsda_ex2_dcache_hit                          (lsdc_lsda_ex2_ld_dcache_hit),                                           
    .lsdc_ex2_dtcm_hit                                 (lsdc_ex2_ld_dtcm_hit),                                     
    .lsdc_lsda_ex2_element_cnt                         (lsdc_lsda_ex2_ld_element_cnt),                                          
    .lsdc_lsda_ex2_element_size                        (lsdc_ex2_ld_element_size),                                         
    .lsdc_lsda_ex2_expt_access_fault_extra             (lsdc_lsda_ex2_ld_expt_access_fault_extra),                                          
    .lsdc_lsda_ex2_expt_access_fault_mask              (lsdc_lsda_ex2_ld_expt_access_fault_mask),                                           
    .lsdc_lsda_ex2_expt_vec                            (lsdc_lsda_ex2_ld_expt_vec),                                         
    .lsdc_lsda_ex2_expt_vld_except_access_err          (lsdc_lsda_ex2_ld_expt_vld_except_access_err),                                           
    .lsdc_lsda_ex2_fwd_bytes_vld                       (lsdc_lsda_ex2_fwd_bytes_vld),                                        
    .lsdc_ex2_fwd_sq_vld                               (lsdc_ex2_fwd_sq_vld),                                   
    .lsdc_ex2_fwd_wmb_vld                              (lsdc_ex2_fwd_wmb_vld),                                      
    .lsdc_ex2_get_dcache_data                          (lsdc_ex2_get_dcache_data),                                      
    .lsdc_ex2_hit_3_region                             (lsdc_ex2_hit_3_region),                                      
    .lsdc_ex2_hit_2_region                             (lsdc_ex2_hit_2_region),
    .lsdc_ex2_hit_1_region                             (lsdc_ex2_hit_1_region),                                      
    .lsdc_ex2_hit_0_region                             (lsdc_ex2_hit_0_region),                                   
    .lsdc_ex2_hit_way                                  (lsdc_ex2_ld_hit_way),                                     
    .lsdc_idu_ex2_lq_full                              (lsdc_idu_ex2_lq_full),                                      
    .lsdc_idu_ex2_tlb_busy                             (lsdc_idu_ex2_ld_tlb_busy),                                     
    .lsdc_ex2_iid                                      (lsdc_ex2_ld_iid),                                      
    .lsdc_ex2_imme_wakeup                              (lsdc_ex2_ld_imme_wakeup),                                      
    .lsdc_ex2_inst_chk_vld                             (lsdc_ex2_inst_chk_vld),                                     
    .lsdc_lsda_ex2_inst_fof                            (lsdc_lsda_ex2_inst_fof),                                         
    .lsdc_lsda_ex2_inst_size                           (lsdc_ex2_ld_inst_size),                                        
    .lsdc_lsda_ex2_inst_type                           (lsdc_ex2_ld_inst_type),                                        
    .lsdc_lsda_ex2_inst_vfls                           (lsdc_lsda_ex2_inst_vfls),                                        
    .lsdc_ex2_inst_vld                                 (lsdc_ex2_ld_inst_vld),                                     
    .lsdc_lsda_ex2_inst_vls                            (lsdc_ex2_ld_inst_vls),                                         
    .lsdc_lsda_ex2_itcm_hit                            (lsdc_ex2_ld_itcm_hit),                                         
    .lsdc_lsda_ex2_ldfifo_pc                           (lsdc_lsda_ex2_ldfifo_pc),                                        
    .lsdc_lq_ex2_create1_dp_vld                        (lsdc_lq_ex2_create1_dp_vld),                                    
    .lsdc_lq_ex2_create1_gateclk_en                    (lsdc_lq_ex2_create1_gateclk_en),                                    
    .lsdc_lq_ex2_create1_vld                           (lsdc_lq_ex2_create1_vld),                                   
    .lsdc_lq_ex2_create_dp_vld                         (lsdc_lq_ex2_create_dp_vld),                                     
    .lsdc_lq_ex2_create_gateclk_en                     (lsdc_lq_ex2_create_gateclk_en),                                     
    .lsdc_lq_ex2_create_vld                            (lsdc_lq_ex2_create_vld),                                    
    .lsdc_ex2_lq_full_gateclk_en                       (lsdc_ex2_lq_full_gateclk_en),                                   
    .lsdc_lsda_ex2_lsid                                (lsdc_lsda_ex2_ld_lsid),                                         
    .lsdc_lsda_ex2_mmu_req                             (lsdc_lsda_ex2_ld_mmu_req),                                          
    .lsdc_lsda_ex2_mt_value                            (lsdc_lsda_ex2_ld_mt_value),                                         
    .lsdc_lsda_ex2_no_spec                             (lsdc_lsda_ex2_ld_no_spec),                                          
    .lsdc_lsda_ex2_no_spec_exist                       (lsdc_lsda_ex2_no_spec_exist),                                        
    .lsdc_pfu_info_set_vld                             (lsdc_pfu_info_set_vld),                                 
    .lsdc_lsda_ex2_pfu_va                              (lsdc_lsda_ex2_ld_pfu_va),                                           
    .lsdc_lsda_ex2_preg                                (lsdc_lsda_ex2_ld_preg),                                         
    .lsdc_lsda_ex2_preg_sign_sel                       (lsdc_lsda_ex2_preg_sign_sel),                                        
    .lsdc_lsda_ex2_reg_bytes_vld                       (lsdc_lsda_ex2_reg_bytes_vld),                                        
    .lsdc_lsda_ex2_reg_bytes_vld1                      (lsdc_lsda_ex2_reg_bytes_vld1),
    .lsdc_lsda_ex2_reg_bytes_vld2                      (lsdc_lsda_ex2_reg_bytes_vld2),
    .lsdc_lsda_ex2_reg_bytes_vld3                      (lsdc_lsda_ex2_reg_bytes_vld3),
    .lsdc_lsda_ex2_inst_us                             (lsdc_lsda_ex2_inst_us),
    .lsdc_lsda_ex2_us_discard                          (lsdc_lsda_ex2_us_discard),
    .lsdc_ex2_secd                                     (lsdc_ex2_ld_secd),                                     
    .lsdc_lsda_ex2_settle_way                          (lsdc_lsda_ex2_settle_way),                                           
    .lsdc_lsda_ex2_setvl_val                           (lsdc_lsda_ex2_setvl_val),                                        
    .lsdc_lsda_ex2_sign_extend                         (lsdc_lsda_ex2_sign_extend),                                          
    .lsdc_lsda_ex2_spec_fail                           (lsdc_lsda_ex2_ld_spec_fail),                                        
    .lsdc_lsda_ex2_split                               (lsdc_lsda_ex2_ld_split),                                        
    .lsdc_lsda_ex2_tag_inj_dp                          (lsdc_lsda_ex2_ld_tag_inj_dp),                                           
    .lsdc_ex2_tlb_busy_gateclk_en                      (lsdc_ex2_ld_tlb_busy_gateclk_en),                                      
    .lsdc_lsda_ex2_vector_nop                          (lsdc_lsda_ex2_ld_vector_nop),                                           
    .lsdc_lsda_ex2_vlmul                               (lsdc_lsda_ex2_vlmul),                                        
    .lsdc_lsda_ex2_vmb_id                              (lsdc_lsda_ex2_vmb_id),                                           
    .lsdc_lsda_ex2_vmb_merge_vld                       (lsdc_lsda_ex2_vmb_merge_vld),                                        
    .lsdc_lsda_ex2_vreg                                (lsdc_lsda_ex2_vreg),                                         
    .lsdc_lsda_ex2_vreg_sign_sel                       (lsdc_lsda_ex2_vreg_sign_sel),                                        
    //.lsdc_lsda_ex2_vsew                                (lsdc_ex2_ld_vsew),   //rvv1.0@hcl 
    .lsdc_lsda_ex2_vmew                                (lsdc_ex2_ld_vmew),   //rvv1.0@hcl
    .lsdc_lsda_ex2_vmop                                (lsdc_ex2_ld_vmop),   //rvv1.0@hcl                                     
    .lsdc_lsda_ex2_wait_fence                          (lsdc_lsda_ex2_wait_fence),                                           
    .lsu_idu_ex2_load_fwd_inst_vld_dup1                (lsu_idu_ex2_load_fwd_inst_vld_dup1),                             
    .lsu_idu_ex2_load_fwd_inst_vld_dup2                (lsu_idu_ex2_load_fwd_inst_vld_dup2),                             
    .lsu_idu_ex2_load_fwd_inst_vld_dup3                (lsu_idu_ex2_load_fwd_inst_vld_dup3),                             
    .lsu_idu_ex2_load_fwd_inst_vld_dup4                (lsu_idu_ex2_load_fwd_inst_vld_dup4),                             
    .lsu_idu_ex2_load_inst_vld_dup0                    (lsu_idu_ex2_load_inst_vld_dup0),                            
    .lsu_idu_ex2_load_inst_vld_dup1                    (lsu_idu_ex2_load_inst_vld_dup1),                            
    .lsu_idu_ex2_load_inst_vld_dup2                    (lsu_idu_ex2_load_inst_vld_dup2),                            
    .lsu_idu_ex2_load_inst_vld_dup3                    (lsu_idu_ex2_load_inst_vld_dup3),                            
    .lsu_idu_ex2_load_inst_vld_dup4                    (lsu_idu_ex2_load_inst_vld_dup4),                            
    .lsu_idu_ex2_preg_dup0                             (lsu_idu_ex2_preg_dup0),                             
    .lsu_idu_ex2_preg_dup1                             (lsu_idu_ex2_preg_dup1),                             
    .lsu_idu_ex2_preg_dup2                             (lsu_idu_ex2_preg_dup2),                             
    .lsu_idu_ex2_preg_dup3                             (lsu_idu_ex2_preg_dup3),                             
    .lsu_idu_ex2_preg_dup4                             (lsu_idu_ex2_preg_dup4),                             
    .lsu_idu_ex2_vload_fwd_inst_vld                    (lsu_idu_ex2_vload_fwd_inst_vld),                            
    .lsu_idu_ex2_vload_inst_vld_dup0                   (lsu_idu_ex2_vload_inst_vld_dup0),                           
    .lsu_idu_ex2_vload_inst_vld_dup1                   (lsu_idu_ex2_vload_inst_vld_dup1),                           
    .lsu_idu_ex2_vload_inst_vld_dup2                   (lsu_idu_ex2_vload_inst_vld_dup2),                           
    .lsu_idu_ex2_vload_inst_vld_dup3                   (lsu_idu_ex2_vload_inst_vld_dup3),                           
    .lsu_idu_ex2_vreg_dup0                             (lsu_idu_ex2_vreg_dup0),                             
    .lsu_idu_ex2_vreg_dup1                             (lsu_idu_ex2_vreg_dup1),                             
    .lsu_idu_ex2_vreg_dup2                             (lsu_idu_ex2_vreg_dup2),                             
    .lsu_idu_ex2_vreg_dup3                             (lsu_idu_ex2_vreg_dup3),                             
    .lsu_mmu_vabuf0                                    (lsu_mmu_vabuf0),
//==========================================================
//                  Risc-V Debug zdb Begin (xx_lsu_ls_ld_dc)
//==========================================================
    //input
    .dtu_lsu_addr_trig_en                              (dtu_lsu_addr_trig_en),
    .dtu_lsu_data_trig_en                              (dtu_lsu_data_trig_en)
    //output 
//==========================================================
//                  Risc-V Debug zdb End   (xx_lsu_ls_ld_dc)
//==========================================================                  
);

assign dcache_lsu_st_tag_dout = { dcache_lsdc_tag_dout[`WK_LS_DCACHE_TRIPLE_LDTAG_WIDTH+`WK_LS_DCACHE_SINGLE_TAG_WIDTH-1:`WK_LS_DCACHE_TRIPLE_LDTAG_WIDTH],
                                  dcache_lsdc_tag_dout[`WK_LS_DCACHE_DOUBLE_LDTAG_WIDTH+`WK_LS_DCACHE_SINGLE_TAG_WIDTH-1:`WK_LS_DCACHE_DOUBLE_LDTAG_WIDTH],
                                  dcache_lsdc_tag_dout[`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH+`WK_LS_DCACHE_SINGLE_TAG_WIDTH-1:`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH],
                                  dcache_lsdc_tag_dout[`WK_LS_DCACHE_SINGLE_TAG_WIDTH-1:0]};   

xx_lsu_ls_st_dc #(
  .LSIQ_ENTRY     (LSIQ_ENTRY),
  .SDIQ_ENTRY     (SDIQ_ENTRY),
  .IID_WIDTH      (IID_WIDTH),
  .SDID_LEN       (SDID_LEN),
  .SNQ_ENTRY      (SNQ_ENTRY),
  .PC_LEN         (PC_LEN),
  .WK_PA_WIDTH    (`WK_PA_WIDTH),
  .PREG           (PREG)
)
x_xx_lsu_ls_st_dc (
    .cp0_lsu_dcache_en                                   (cp0_lsu_dcache_en),                       
    .cp0_lsu_ecc_en                                      (cp0_lsu_ecc_en),                      
    .cp0_lsu_icg_en                                      (cp0_lsu_icg_en),                      
    .cp0_lsu_l2_st_pref_en                               (cp0_lsu_l2_st_pref_en),                       
    .cpurst_b                                            (cpurst_b),                        
    .ctrl_st_clk                                         (ctrl_st_clk),                     
    .dcache_arb_lsdc_borrow_icc                          (dcache_arb_lsdc_borrow_icc),                     
    .dcache_arb_lsdc_borrow_snq                          (dcache_arb_lsdc_borrow_snq),                     
    .dcache_arb_lsdc_borrow_snq_id                       (dcache_arb_lsdc_borrow_snq_id),                      
    .dcache_arb_lsdc_borrow_vld                          (dcache_arb_lsdc_borrow_vld),                     
    .dcache_arb_lsdc_borrow_vld_gate                     (dcache_arb_lsdc_borrow_vld_gate),                    
    .dcache_arb_lsdc_dcache_replace                      (dcache_arb_lsdc_dcache_replace),                     
    .dcache_arb_lsdc_ex1_dcache_sw                       (dcache_arb_lsdc_ex1_dcache_sw),                          
    .dcache_lsdc_dirty_gwen                              (dcache_lsdc_dirty_gwen),                           
    .dcache_lsdc_idx                                     (dcache_lsdc_idx),                          
    .dcache_lsdc_dirty_dout                              (dcache_lsdc_dirty_dout),                    
    .dcache_lsdc_tag_dout                                (dcache_lsu_st_tag_dout),                      
    .forever_cpuclk                                      (forever_cpuclk),                      
    .pad_yy_icg_scan_en                                  (pad_yy_icg_scan_en),                      
    .rtu_lsu_commit0_iid_updt_val                        (rtu_lsu_commit0_iid_updt_val),                         
    .rtu_lsu_commit1_iid_updt_val                        (rtu_lsu_commit1_iid_updt_val),                         
    .rtu_lsu_commit2_iid_updt_val                        (rtu_lsu_commit2_iid_updt_val),                    
    .rtu_lsu_commit3_iid_updt_val                        (rtu_lsu_commit3_iid_updt_val),                         
    .rtu_lsu_commit4_iid_updt_val                        (rtu_lsu_commit4_iid_updt_val),                         
    .rtu_lsu_commit5_iid_updt_val                        (rtu_lsu_commit5_iid_updt_val),                         
    .rtu_lsu_commit6_iid_updt_val                        (rtu_lsu_commit6_iid_updt_val),                         
    .rtu_lsu_commit7_iid_updt_val                        (rtu_lsu_commit7_iid_updt_val),                        
    .rtu_lsu_flush_fe                                    (rtu_lsu_flush_fe),                        
    .rtu_ck_flush                                        (rtu_ck_flush),
    .rtu_ck_flush_iid                                    (rtu_ck_flush_iid),
    .std0_rf_sdid                                        (std0_rf_sdid), 
    .std1_rf_sdid                                        (std1_rf_sdid),                 
    .sq_lsdc_ex2_full                                    (sq_lsdc_ex2_full),                           
    .sq_lsdc_ex2_inst_hit                                (sq_lsdc_ex2_inst_hit),
    .lq_lsdc_ex2_spec_fail                               (lq_lsdc_ex2_spec_fail),
    .mmu_lsu_mmu_en                                      (mmu_lsu_mmu_en),                                 
    .mmu_lsu_tlb_busy                                    (mmu_lsu_tlb_busy),
    .mmu_lsu_imme_wakeup                                 (mmu_lsu_imme_wakeup), // wjh@tmq full, mrg-on-cmplt
    .lsag_ex1_is_load                                    (lsag_ex1_is_load),                            
    .lsag_lsdc_ex1_already_da                            (lsag_lsdc_ex1_already_da),                                
    .lsag_lsdc_ex1_atomic                                (lsag_lsdc_ex1_atomic),                                
    .lsag_lsdc_ex1_boundary                              (lsag_lsdc_ex1_boundary),                              
    .lsag_ex1_access_size                                (lsag_ex1_access_size),                        
    .lsag_lsdc_ex1_addr0                                 (lsag_lsdc_ex1_addr0),                          
    .lsag_lsdc_ex1_bytes_vld                             (lsag_lsdc_ex1_bytes_vld),                          
    .lsag_lsdc_ex1_inst_vld                              (lsag_lsdc_ex1_st_inst_vld),                           
    .lsag_lsdc_ex1_mmu_req                               (lsag_lsdc_ex1_mmu_req),                            
    .lsag_lsdc_ex1_page_share                            (lsag_lsdc_ex1_page_share),                             
    .lsag_lsdc_ex1_page_so                               (lsag_lsdc_ex1_page_so),                            
    .lsag_lsdc_ex1_rot_sel                               (lsag_lsdc_ex1_rot_sel),                            
    .lsag_lsdc_ex1_dtcm_hit                              (lsag_lsdc_ex1_dtcm_hit),                              
    .lsag_lsdc_ex1_element_cnt                           (lsag_lsdc_ex1_element_cnt),                               
    .lsag_lsdc_ex1_element_size                          (lsag_lsdc_ex1_element_size),                              
    .lsag_lsdc_ex1_expt_access_fault_with_page           (lsag_lsdc_ex1_expt_access_fault_with_page),                                
    .lsag_lsdc_ex1_expt_illegal_inst                     (lsag_lsdc_ex1_expt_illegal_inst),                             
    .lsag_lsdc_ex1_expt_misalign_no_page                 (lsag_lsdc_ex1_expt_misalign_no_page),                             
    .lsag_lsdc_ex1_expt_misalign_with_page               (lsag_lsdc_ex1_expt_misalign_with_page),                               
    .lsag_lsdc_ex1_expt_page_fault                       (lsag_lsdc_ex1_expt_page_fault),                               
    .lsag_lsdc_ex1_expt_amo_not_ca                       (lsag_lsdc_ex1_expt_amo_not_ca),                             
    .lsag_lsdc_ex1_expt_vld                              (lsag_lsdc_ex1_expt_vld),                              
    .lsag_lsdc_ex1_fence_mode                            (lsag_lsdc_ex1_fence_mode),                                
    .lsag_lsdc_ex1_icc                                   (lsag_lsdc_ex1_icc),                               
    .lsag_lsdc_ex1_idx_order                             (lsag_lsdc_ex1_idx_order),                             
    .lsag_ex1_iid                                        (lsag_ex1_iid),                           
    .lsag_lsdc_ex1_inst_flush                            (lsag_lsdc_ex1_inst_flush),                                
    .lsag_lsdc_ex1_inst_mode                             (lsag_lsdc_ex1_inst_mode),                             
    .lsag_lsdc_ex1_inst_type                             (lsag_lsdc_ex1_inst_type),                             
    .lsag_ex1_inst_vld                                   (lsag_ex1_st_inst_vld),                          
    .lsag_lsdc_ex1_inst_vls                              (lsag_lsdc_ex1_inst_vls),                              
    .lsag_lsdc_ex1_itcm_hit                              (lsag_lsdc_ex1_itcm_hit),                              
    .lsag_lsdc_ex1_lsfifo                                (lsag_lsdc_ex1_lsfifo),                                
    .lsag_lsdc_ex1_lsid                                  (lsag_lsdc_ex1_lsid),                                                           
    .lsag_lsdc_ex1_lsiq_spec_fail                        (lsag_lsdc_ex1_lsiq_spec_fail),                                
    .lsag_lsdc_ex1_mt_value                              (lsag_lsdc_ex1_mt_value),                              
    .lsag_lsdc_ex1_no_spec                               (lsag_lsdc_ex1_no_spec),                               
    .lsag_lsdc_ex1_old                                   (lsag_lsdc_ex1_old),                               
    .lsag_lsdc_ex1_page_buf                              (lsag_lsdc_ex1_page_buf),                              
    .lsag_lsdc_ex1_page_ca                               (lsag_lsdc_ex1_page_ca),                               
    .lsag_lsdc_ex1_page_sec                              (lsag_lsdc_ex1_page_sec),                              
    .lsag_lsdc_ex1_page_wa                               (lsag_lsdc_ex1_page_wa),                               
    .lsag_lsdc_ex1_pc                                    (lsag_lsdc_ex1_pc),                                
    .lsag_lsdc_ex1_preg                                  (lsag_lsdc_ex1_preg),
    .lsag_lsdc_ex1_sdiq_entry                            (lsag_lsdc_ex1_sdiq_entry),                                   
    .lsag_lsdc_ex1_secd                                  (lsag_lsdc_ex1_secd),                              
    .lsag_lsdc_ex1_split                                 (lsag_lsdc_ex1_split),                             
    .lsag_lsdc_ex1_st                                    (lsag_lsdc_ex1_st),                                
    .lsag_lsdc_ex1_staddr                                (lsag_lsdc_ex1_staddr),                                
    .lsag_lsdc_ex1_sync_fence                            (lsag_lsdc_ex1_sync_fence),                                
    .lsag_lsdc_ex1_utlb_miss                             (lsag_lsdc_ex1_utlb_miss),                             
    .lsag_lsdc_ex1_vpn                                   (lsag_lsdc_ex1_vpn),                               
    //.lsag_lsdc_ex1_vsew                                  (lsag_lsdc_ex1_vsew),
    .lsag_lsdc_ex1_vmew                                (lsag_lsdc_ex1_vmew), //rvv1.0@hcl
    .lsag_lsdc_ex1_vmop                                (lsag_lsdc_ex1_vmop), //rvv1.0@hcl                              
    .lsu_idu_ex2_sdiq_entry                              (lsu_idu_ex2_sdiq_entry),                       
    .lsu_idu_ex2_staddr1_vld                             (lsu_idu_ex2_staddr1_vld),                      
    .lsu_idu_ex2_staddr_unalign                          (lsu_idu_ex2_staddr_unalign),                       
    .lsu_idu_ex2_staddr_vld                              (lsu_idu_ex2_staddr_vld),                       
    .lsu_mmu_vabuf                                       (lsu_mmu_vabuf1),
    .lsdc_ex2_is_load                                    (lsdc_ex2_is_load1),                       
    .lsdc_ex2_addr0                                      (lsdc_ex2_st_addr0),                         
    .lsdc_lsda_ex2_already_da                            (lsdc_lsda_ex2_st_already_da),                                
    .lsdc_ex2_atomic                                     (lsdc_ex2_st_atomic),                                                    
    .lsdc_lsda_ex2_borrow_dcache_replace                 (lsdc_lsda_ex2_borrow_dcache_replace),                             
    .lsdc_lsda_ex2_borrow_dcache_sw                      (lsdc_lsda_ex2_borrow_dcache_sw),                              
    .lsdc_lsda_ex2_borrow_icc                            (lsdc_lsda_ex2_st_borrow_icc),                                
    .lsdc_lsda_ex2_borrow_snq                            (lsdc_lsda_ex2_borrow_snq),                                
    .lsdc_lsda_ex2_borrow_snq_id                         (lsdc_lsda_ex2_borrow_snq_id),                             
    .lsdc_ex2_borrow_vld                                 (lsdc_ex2_st_borrow_vld),                        
    .lsdc_ex2_boundary                                   (lsdc_ex2_st_boundary),                          
    .lsdc_sq_ex2_boundary_first                          (lsdc_sq_ex2_boundary_first),                            
    .lsdc_ex2_bytes_vld                                  (lsdc_ex2_st_bytes_vld),                         
    .lsdc_ex2_chk_st_inst_vld                            (lsdc_ex2_chk_st_inst_vld),                           
    .lsdc_ex2_chk_atomic_inst_vld                        (lsdc_ex2_st_chk_atomic_inst_vld),                         
    .lsdc_sq_ex2_cmit0_iid_crt_hit                       (lsdc_sq_ex2_cmit0_iid_crt_hit),                          
    .lsdc_sq_ex2_cmit1_iid_crt_hit                       (lsdc_sq_ex2_cmit1_iid_crt_hit),                          
    .lsdc_sq_ex2_cmit2_iid_crt_hit                       (lsdc_sq_ex2_cmit2_iid_crt_hit),                
    .lsdc_sq_ex2_cmit3_iid_crt_hit                       (lsdc_sq_ex2_cmit3_iid_crt_hit),                          
    .lsdc_sq_ex2_cmit4_iid_crt_hit                       (lsdc_sq_ex2_cmit4_iid_crt_hit),                          
    .lsdc_sq_ex2_cmit5_iid_crt_hit                       (lsdc_sq_ex2_cmit5_iid_crt_hit),                
    .lsdc_sq_ex2_cmit6_iid_crt_hit                       (lsdc_sq_ex2_cmit6_iid_crt_hit),                          
    .lsdc_sq_ex2_cmit7_iid_crt_hit                       (lsdc_sq_ex2_cmit7_iid_crt_hit),                      
    .lsdc_lsda_ex2_dcache_dirty_array                    (lsdc_lsda_ex2_dcache_dirty_array),                             
    .lsdc_lsda_ex2_dcache_tag_array                      (lsdc_lsda_ex2_dcache_tag_array),                           
    .lsdc_lsda_ex2_expt_vld_gate_en                      (lsdc_lsda_ex2_st_expt_vld_gate_en),                           
    .lsdc_lsda_ex2_inst_vld                              (lsdc_lsda_ex2_st_inst_vld),                           
    .lsdc_ex2_page_buf                                   (lsdc_ex2_st_page_buf),                       
    .lsdc_ex2_page_ca                                    (lsdc_ex2_st_page_ca),                        
    .lsdc_ex2_page_sec                                   (lsdc_ex2_st_page_sec),                       
    .lsdc_ex2_page_share                                 (lsdc_ex2_st_page_share),                     
    .lsdc_ex2_page_so                                    (lsdc_ex2_st_page_so),                        
    .lsdc_ex2_page_wa                                    (lsdc_ex2_page_wa),                        
    .lsdc_lsda_ex2_staddr_vld                            (lsdc_lsda_ex2_staddr_vld),                             
    .lsdc_lsda_ex2_tag0_hit                              (lsdc_lsda_ex2_tag0_hit),                           
    .lsdc_lsda_ex2_tag1_hit                              (lsdc_lsda_ex2_tag1_hit),                           
    .lsdc_lsda_ex2_tag2_hit                              (lsdc_lsda_ex2_tag2_hit),                           
    .lsdc_lsda_ex2_tag3_hit                              (lsdc_lsda_ex2_tag3_hit),
    .lsdc_ex2_dcache_hit                                 (lsdc_ex2_dcache_hit   ),
    .lsdc_ex2_hit_way                                    (lsdc_ex2_st_hit_way   ),
    .lsdc_lsda_ex2_dcwp_hit_idx                          (lsdc_lsda_ex2_dcwp_hit_idx),                              
    .lsdc_sq_ex2_dtcm_hit                                (lsdc_ex2_st_dtcm_hit),                              
    .lsdc_lsda_ex2_element_cnt                           (lsdc_lsda_ex2_st_element_cnt),                               
    .lsdc_sq_ex2_element_size                            (lsdc_ex2_st_element_size),                              
    .lsdc_lsda_ex2_expt_access_fault_extra               (lsdc_lsda_ex2_st_expt_access_fault_extra),                               
    .lsdc_lsda_ex2_expt_access_fault_mask                (lsdc_lsda_ex2_st_expt_access_fault_mask),                                
    .lsdc_lsda_ex2_expt_vec                              (lsdc_lsda_ex2_st_expt_vec),                              
    .lsdc_lsda_ex2_expt_vld_except_access_err            (lsdc_lsda_ex2_st_expt_vld_except_access_err),                                
    .lsdc_ex2_fence_mode                                 (lsdc_ex2_fence_mode),                        
    .lsdc_lsda_ex2_get_dcache_tag_dirty                  (lsdc_lsda_ex2_get_dcache_tag_dirty),                              
    .lsdc_ex2_icc                                        (lsdc_ex2_icc),                           
    .lsdc_idu_ex2_sq_full                                (lsdc_idu_ex2_sq_full),                           
    .lsdc_idu_ex2_tlb_busy                               (lsdc_idu_ex2_st_tlb_busy),                          
    .lsdc_sq_ex2_idx_order                               (lsdc_sq_ex2_idx_order),                             
    .lsdc_ex2_iid                                        (lsdc_ex2_st_iid),                           
    .lsdc_ex2_imme_wakeup                                (lsdc_ex2_st_imme_wakeup),                           
    .lsdc_sq_ex2_inst_flush                              (lsdc_sq_ex2_inst_flush),                            
    .lsdc_ex2_inst_mode                                  (lsdc_ex2_inst_mode),                         
    .lsdc_ex2_inst_size                                  (lsdc_ex2_st_inst_size),                         
    .lsdc_ex2_inst_type                                  (lsdc_ex2_st_inst_type),                         
    .lsdc_ex2_inst_vld                                   (lsdc_ex2_st_inst_vld),                          
    .lsdc_ex2_inst_vls                                   (lsdc_ex2_st_inst_vls),                          
    .lsdc_sq_ex2_itcm_hit                                (lsdc_ex2_st_itcm_hit),                              
    .lsdc_lsda_ex2_lsid                                  (lsdc_lsda_ex2_st_lsid),                              
    .lsdc_lsda_ex2_mmu_req                               (lsdc_lsda_ex2_st_mmu_req),                               
    .lsdc_lsda_ex2_mt_value                              (lsdc_lsda_ex2_st_mt_value),                              
    .lsdc_lsda_ex2_no_spec                               (lsdc_lsda_ex2_st_no_spec),                               
    .lsdc_ex2_old                                        (lsdc_ex2_st_old),                           
    .lsdc_lsda_ex2_pc                                    (lsdc_lsda_ex2_pc),                     
    .lsdc_ex2_preg                                       (lsdc_lsda_ex2_st_preg),
    .lsdc_lsda_ex2_pf_inst                               (lsdc_lsda_ex2_st_pf_inst),                               
    .lsdc_lsda_ex2_pfu_va                                (lsdc_lsda_ex2_st_pfu_va),                                
    .lsdc_sq_ex2_rot_sel_rev                             (lsdc_sq_ex2_rot_sel_rev),                           
    .lsdc_sq_ex2_sdid                                    (lsdc_sq_ex2_sdid),                  
    .lsdc_sq_ex2_sdid_hit0                               (lsdc_sq_ex2_sdid_hit0),
    .lsdc_sq_ex2_sdid_hit1                               (lsdc_sq_ex2_sdid_hit1),                              
    .lsdc_ex2_secd                                       (lsdc_ex2_st_secd),                          
    .lsdc_lsda_ex2_spec_fail                             (lsdc_lsda_ex2_st_spec_fail),                             
    .lsdc_lsda_ex2_split                                 (lsdc_lsda_ex2_st_split),                             
    .lsdc_sq_ex2_create_dp_vld                           (lsdc_sq_ex2_create_dp_vld),                          
    .lsdc_sq_ex2_create_gateclk_en                       (lsdc_sq_ex2_create_gateclk_en),                          
    .lsdc_sq_ex2_create_vld                              (lsdc_sq_ex2_create_vld),                         
    .lsdc_sq_ex2_data_vld                                (lsdc_sq_ex2_data_vld),                           
    .lsdc_ex2_sq_full_gateclk_en                         (lsdc_ex2_sq_full_gateclk_en),                        
    .lsdc_lsda_ex2_st                                    (lsdc_lsda_ex2_st),                                
    .lsdc_ex2_sync_fence                                 (lsdc_ex2_sync_fence),                        
    .lsdc_lsda_ex2_tag_inj_dp                            (lsdc_lsda_ex2_st_tag_inj_dp),                                
    .lsdc_ex2_tlb_busy_gateclk_en                        (lsdc_ex2_st_tlb_busy_gateclk_en),                           
    .lsdc_lsda_ex2_vector_nop                            (lsdc_lsda_ex2_st_vector_nop),                                
    //.lsdc_sq_ex2_vsew                                    (lsdc_ex2_st_vsew), //rvv1.0@hcl 
    .lsdc_sq_ex2_vmew                                    (lsdc_ex2_st_vmew),//rvv1.0@hcl 
    .lsdc_sq_ex2_vmop                                    (lsdc_ex2_st_vmop),//rvv1.0@hcl                             
    .lsdc_sq_ex2_wo_st_inst                              (lsdc_sq_ex2_wo_st_inst),
//==========================================================
//                  Risc-V Debug zdb Begin (xx_lsu_st_dc)
//==========================================================
    //input
    .dtu_lsu_addr_trig_en                               (dtu_lsu_addr_trig_en),
    .dtu_lsu_data_trig_en                               (dtu_lsu_data_trig_en),
    //output 
    .st_dc_data_check                                   (st_dc_data_check)
//==========================================================
//                  Risc-V Debug zdb End   (xx_lsu_st_dc)
//==========================================================             
);

xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH))
x_lsu_lsdc_compare_lsdc_iid (
  .x_iid0         (lsdc_ex2_iid[IID_WIDTH-1:0]       ),
  .x_iid0_older   (lsdc_uop_older_than_another_lsdc     ),
  .x_iid1         (lsdc_selfdc_ex2_iid[IID_WIDTH-1:0])
);
assign ls_is_older_than_ls = lsdc_uop_older_than_another_lsdc && lsdc_ex2_chk_ld_inst_vld
                            || lsdc_ex2_chk_ld_inst_vld && !lsdc_selfdc_ex2_chk_ld_inst;
                            
assign lsag_lsdc_ex1_ld_inst_vld = lsag_lsdc_ex1_inst_vld && lsag_ex1_is_load;  //decide ld pipe is valid, LTL@20241107
assign lsag_lsdc_ex1_st_inst_vld = lsag_lsdc_ex1_inst_vld && !lsag_ex1_is_load; //decide st pipe is valid, LTL@20241107

assign lsag_ex1_ld_inst_vld = lsag_ex1_inst_vld && lsag_ex1_is_load;  //decide ld pipe dp is valid, LTL@20241107
assign lsag_ex1_st_inst_vld = lsag_ex1_inst_vld && !lsag_ex1_is_load; //decide st pipe dp is valid, LTL@20241107
//assign lsdc_ex2_is_load = lsdc_ex2_is_load0 && lsdc_ex2_ld_inst_vld    //need add lsdc_ex2_ld/st_inst_vld, LTL@20241119
//                          || lsdc_ex2_is_load1 && lsdc_ex2_st_inst_vld;  

//always_comb begin
//  lsdc_ex2_is_load = 1'b0;
//  if(!lsdc_ex2_ld_inst_vld && !lsdc_ex2_st_inst_vld && lsdc_ex2_is_load0)
//    lsdc_ex2_is_load = 1'b1;
//  else if(!lsdc_ex2_ld_inst_vld && !lsdc_ex2_st_inst_vld && !lsdc_ex2_is_load0)
//    lsdc_ex2_is_load = 1'b0;
//  else if(lsdc_ex2_ld_inst_vld)
//    lsdc_ex2_is_load = 1'b1;
//end
always @(posedge forever_cpuclk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    lsdc_ex2_is_load                    <=  1'b0;
  end
  else if(dcache_arb_lsdc_borrow_vld)
  begin
    lsdc_ex2_is_load                    <=  1'b0;
  end
  else if(lsag_lsdc_ex1_ld_inst_vld)
  begin
    lsdc_ex2_is_load                    <=  1'b1;
  end
  else if(lsag_lsdc_ex1_st_inst_vld)
  begin
    lsdc_ex2_is_load                    <=  1'b0;
  end
  else
    lsdc_ex2_is_load                    <=  lsag_ex1_is_load;
end


assign lsdc_ex2_hit_way    = lsdc_ex2_is_load
                                        ? lsdc_ex2_ld_hit_way
                                        : lsdc_ex2_st_hit_way;
assign lsdc_lsda_ex2_dcache_hit    = lsdc_ex2_is_load
                                        ? lsdc_lsda_ex2_ld_dcache_hit
                                        : lsdc_ex2_dcache_hit;

assign lsdc_ex2_addr0    = lsdc_ex2_is_load
                                        ? lsdc_ex2_ld_addr0
                                        : lsdc_ex2_st_addr0;        
assign lsdc_lsda_ex2_already_da  = lsdc_ex2_is_load
                                        ? lsdc_lsda_ex2_ld_already_da
                                        : lsdc_lsda_ex2_st_already_da;           
assign lsdc_ex2_atomic   = lsdc_ex2_is_load
                                        ? lsdc_ex2_ld_atomic
                                        : lsdc_ex2_st_atomic;
assign lsdc_lsda_ex2_borrow_icc  = lsdc_ex2_is_load
                                        ? lsdc_lsda_ex2_ld_borrow_icc
                                        : lsdc_lsda_ex2_st_borrow_icc;
assign lsdc_ex2_borrow_vld   = lsdc_ex2_is_load
                                        ? lsdc_ex2_ld_borrow_vld
                                        : lsdc_ex2_st_borrow_vld;    
assign lsdc_ex2_boundary     = lsdc_ex2_is_load
                                        ? lsdc_ex2_ld_boundary
                                        : lsdc_ex2_st_boundary;
assign lsdc_ex2_bytes_vld    = lsdc_ex2_is_load
                                        ? lsdc_ex2_ld_bytes_vld
                                        : lsdc_ex2_st_bytes_vld;
assign lsdc_ex2_chk_atomic_inst_vld  = lsdc_ex2_is_load
                                        ? lsdc_ex2_ld_chk_atomic_inst_vld
                                        : lsdc_ex2_st_chk_atomic_inst_vld;     
assign lsdc_lsda_ex2_expt_vld_gate_en    = lsdc_ex2_is_load
                                        ? lsdc_lsda_ex2_ld_expt_vld_gate_en
                                        : lsdc_lsda_ex2_st_expt_vld_gate_en;       
assign lsdc_lsda_ex2_inst_vld    = lsdc_lsda_ex2_ld_inst_vld   //no need is_load sel, LTL@20241119
                                   || lsdc_lsda_ex2_st_inst_vld;
assign lsdc_ex2_old  = lsdc_ex2_is_load
                                        ? lsdc_ex2_ld_old
                                        : lsdc_ex2_st_old;
assign lsdc_ex2_page_buf     = lsdc_ex2_is_load
                                        ? lsdc_ex2_ld_page_buf
                                        : lsdc_ex2_st_page_buf;          
assign lsdc_ex2_page_ca  = lsdc_ex2_is_load
                                        ? lsdc_ex2_ld_page_ca
                                        : lsdc_ex2_st_page_ca;           
assign lsdc_ex2_page_sec     = lsdc_ex2_is_load
                                        ? lsdc_ex2_ld_page_sec
                                        : lsdc_ex2_st_page_sec;          
assign lsdc_ex2_page_share   = lsdc_ex2_is_load
                                        ? lsdc_ex2_ld_page_share
                                        : lsdc_ex2_st_page_share;        
assign lsdc_ex2_page_so  = lsdc_ex2_is_load
                                        ? lsdc_ex2_ld_page_so
                                        : lsdc_ex2_st_page_so;           
assign lsdc_lsda_ex2_pf_inst     = lsdc_ex2_is_load
                                        ? lsdc_lsda_ex2_ld_pf_inst
                                        : lsdc_lsda_ex2_st_pf_inst;
assign lsdc_lsda_ex2_preg = lsdc_ex2_is_load
                                      ? lsdc_lsda_ex2_ld_preg
                                      : lsdc_lsda_ex2_st_preg;
assign lsdc_ex2_dtcm_hit     = lsdc_ex2_is_load
                                        ? lsdc_ex2_ld_dtcm_hit
                                        : lsdc_ex2_st_dtcm_hit;
assign lsdc_lsda_ex2_element_cnt     = lsdc_ex2_is_load
                                        ? lsdc_lsda_ex2_ld_element_cnt
                                        : lsdc_lsda_ex2_st_element_cnt;          
assign lsdc_ex2_element_size     = lsdc_ex2_is_load
                                        ? lsdc_ex2_ld_element_size
                                        : lsdc_ex2_st_element_size;         
assign lsdc_lsda_ex2_expt_access_fault_extra     = lsdc_ex2_is_load
                                        ? lsdc_lsda_ex2_ld_expt_access_fault_extra
                                        : lsdc_lsda_ex2_st_expt_access_fault_extra;
assign lsdc_lsda_ex2_expt_access_fault_mask  = lsdc_ex2_is_load
                                        ? lsdc_lsda_ex2_ld_expt_access_fault_mask
                                        : lsdc_lsda_ex2_st_expt_access_fault_mask;
assign lsdc_lsda_ex2_expt_vec    = lsdc_ex2_is_load
                                        ? lsdc_lsda_ex2_ld_expt_vec
                                        : lsdc_lsda_ex2_st_expt_vec;
assign lsdc_lsda_ex2_expt_vld_except_access_err  = lsdc_ex2_is_load
                                        ? lsdc_lsda_ex2_ld_expt_vld_except_access_err
                                        : lsdc_lsda_ex2_st_expt_vld_except_access_err;
assign lsdc_idu_ex2_tlb_busy     = lsdc_ex2_is_load
                                        ? lsdc_idu_ex2_ld_tlb_busy
                                        : lsdc_idu_ex2_st_tlb_busy;        
assign lsdc_ex2_iid  = lsdc_ex2_is_load
                                        ? lsdc_ex2_ld_iid
                                        : lsdc_ex2_st_iid;      
assign lsdc_ex2_imme_wakeup  = lsdc_ex2_is_load
                                        ? lsdc_ex2_ld_imme_wakeup
                                        : lsdc_ex2_st_imme_wakeup;
assign lsdc_ex2_inst_size    = lsdc_ex2_is_load
                                        ? lsdc_ex2_ld_inst_size
                                        : lsdc_ex2_st_inst_size;
assign lsdc_ex2_inst_type    = lsdc_ex2_is_load
                                        ? lsdc_ex2_ld_inst_type
                                        : lsdc_ex2_st_inst_type;         
assign lsdc_ex2_inst_vld     = lsdc_ex2_ld_inst_vld            //inst_vld or no need is_load sel, LTL@20241119
                               || lsdc_ex2_st_inst_vld;
assign lsdc_ex2_inst_vls     = lsdc_ex2_is_load
                                        ? lsdc_ex2_ld_inst_vls
                                        : lsdc_ex2_st_inst_vls;
assign lsdc_ex2_itcm_hit    = lsdc_ex2_is_load
                                        ? lsdc_ex2_ld_itcm_hit
                                        : lsdc_ex2_st_itcm_hit;          
assign lsdc_lsda_ex2_lsid    = lsdc_ex2_is_load
                                        ? lsdc_lsda_ex2_ld_lsid
                                        : lsdc_lsda_ex2_st_lsid;     
assign lsdc_lsda_ex2_mmu_req     = lsdc_ex2_is_load
                                        ? lsdc_lsda_ex2_ld_mmu_req
                                        : lsdc_lsda_ex2_st_mmu_req;
assign lsdc_lsda_ex2_mt_value    = lsdc_ex2_is_load
                                        ? lsdc_lsda_ex2_ld_mt_value
                                        : lsdc_lsda_ex2_st_mt_value;
assign lsdc_lsda_ex2_no_spec     = lsdc_ex2_is_load
                                        ? lsdc_lsda_ex2_ld_no_spec
                                        : lsdc_lsda_ex2_st_no_spec;           
assign lsdc_lsda_ex2_pfu_va  = lsdc_ex2_is_load
                                        ? lsdc_lsda_ex2_ld_pfu_va
                                        : lsdc_lsda_ex2_st_pfu_va;
//assign lsdc_ex2_secd     = lsdc_ex2_is_load
//                                        ? lsdc_ex2_ld_secd
//                                        : lsdc_ex2_st_secd;        
assign lsdc_lsda_ex2_spec_fail  = lsdc_ex2_is_load
                                        ? lsdc_lsda_ex2_ld_spec_fail
                                        : lsdc_lsda_ex2_st_spec_fail;
assign lsdc_lsda_ex2_split   = lsdc_ex2_is_load
                                        ? lsdc_lsda_ex2_ld_split
                                        : lsdc_lsda_ex2_st_split;    
assign lsdc_lsda_ex2_tag_inj_dp  = lsdc_ex2_is_load
                                        ? lsdc_lsda_ex2_ld_tag_inj_dp
                                        : lsdc_lsda_ex2_st_tag_inj_dp;           
assign lsdc_ex2_tlb_busy_gateclk_en  = lsdc_ex2_is_load
                                        ? lsdc_ex2_ld_tlb_busy_gateclk_en
                                        : lsdc_ex2_st_tlb_busy_gateclk_en;
assign lsdc_lsda_ex2_vector_nop  = lsdc_ex2_is_load
                                        ? lsdc_lsda_ex2_ld_vector_nop
                                        : lsdc_lsda_ex2_st_vector_nop;
//assign lsdc_ex2_vsew     = lsdc_ex2_is_load                   //rvv1.0@hcl
//                                        ? lsdc_ex2_ld_vsew    //rvv1.0@hcl  
//                                        : lsdc_ex2_st_vsew;   //rvv1.0@hcl 
assign lsdc_ex2_vmew     = lsdc_ex2_is_load                   //rvv1.0@hcl
                                        ? lsdc_ex2_ld_vmew    //rvv1.0@hcl  
                                        : lsdc_ex2_st_vmew;   //rvv1.0@hcl
assign lsdc_ex2_vmop     = lsdc_ex2_is_load                   //rvv1.0@hcl
                                        ? lsdc_ex2_ld_vmop    //rvv1.0@hcl  
                                        : lsdc_ex2_st_vmop;   //rvv1.0@hcl         
assign lsu_mmu_vabuf   = lsdc_ex2_is_load
                                        ? lsu_mmu_vabuf0
                                        : lsu_mmu_vabuf1;

//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
gated_clk_cell  x_lsu_ld_dc_inst_gated_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (ls_dc_inst_clk    ),
  .external_en        (1'b0              ),
  .local_en           (lsag_ex1_inst_vld ),
  .module_en          (cp0_lsu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

always @(posedge ls_dc_inst_clk or negedge cpurst_b)
begin
  if (~cpurst_b)
  begin
    ls_dc_boundary_unmask                              <=  1'b0;
    ls_dc_dtu_addr[`WK_MA_WIDTH-1:0]                   <=  {`WK_MA_WIDTH{1'b0}};           
    ls_dc_dtu_addr_bytes_vld[15:0]                     <=  {16{1'b0}};         
    ls_dc_dtu_addr_type[1:0]                           <=  {2{1'b0}};   
    ls_dc_dtu_addr_size[2:0]                           <=  {3{1'b0}};   
    ls_dc_dtu_addr_halt_info[`TDT_MP_HINFO_WIDTH-1:0]  <=  {`TDT_MP_HINFO_WIDTH{1'b0}};  
    ls_dc_dtu_addr_last_check                          <=  1'b0;
  end
  else if(lsag_ex1_inst_vld & ls_ag_dtu_vld)
  begin
    ls_dc_boundary_unmask                              <=  ls_ag_boundary_unmask;
    ls_dc_dtu_addr[`WK_MA_WIDTH-1:0]                   <=  ls_ag_dtu_va[`WK_MA_WIDTH-1:0];
    ls_dc_dtu_addr_bytes_vld[15:0]                     <=  lsag_lsdc_ex1_bytes_vld[15:0]; // 20260325 mark@zdb how to use lag_ldc_ex1_bytes_vld1?
    ls_dc_dtu_addr_type[1:0]                           <=  ls_ag_dtu_type[1:0];
    ls_dc_dtu_addr_size[2:0]                           <=  ls_ag_dtu_access_size[2:0];
    ls_dc_dtu_addr_halt_info[`TDT_MP_HINFO_WIDTH-1:0]  <=  ls_ag_halt_info[`TDT_MP_HINFO_WIDTH-1:0];
    ls_dc_dtu_addr_last_check                          <=  ls_ag_dtu_last_check;
  end
end

always @(posedge ls_dc_inst_clk or negedge cpurst_b)
begin
  if (~cpurst_b)
  begin
    ls_dc_dtu_addr_vld                                 <=  1'b0;
  end
  else if(lsag_ex1_inst_vld & ls_ag_dtu_vld)
  begin
    ls_dc_dtu_addr_vld                                 <=  ls_ag_dtu_vld;
  end
end
//==========================================================
//                  Risc-V Debug zdb End 
//==========================================================

endmodule
