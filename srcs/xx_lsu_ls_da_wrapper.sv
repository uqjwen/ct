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
module xx_lsu_ls_da_wrapper #(
  parameter VB_DATA_ENTRY = 3,
  parameter WMB_ENTRY     = 8,
  parameter LSIQ_ENTRY = 12,
  parameter SDIQ_ENTRY = 12,  
  parameter IID_WIDTH  = 7,
  parameter SDID_LEN   = 4,
  parameter SNQ_ENTRY  = 6,
  parameter PC_LEN     = 15,
  parameter LQ_ENTRY   = 16,
  parameter SQ_ENTRY   = 12,
  parameter VMB_ENTRY  = 8,
  parameter PREG       = 7,
  parameter VREG       = 6
)(
// &Ports; @29
input logic                                               rtu_ck_flush,
input logic   [IID_WIDTH-1  :0]                           rtu_ck_flush_iid,
input logic                                               amr_wa_cancel,           
input logic  [127:0]                                      cb_ld_da_data,                      
input logic                                               cb_ld_da_data_vld,                 
input logic                                               cp0_lsu_data_ecc_inj,                
input logic  [38 :0]                                      cp0_lsu_data_random,                                   
input logic  [16 :0]                                      cp0_lsu_dcache_read_index,                                                    
input logic                                               cp0_lsu_l2_pref_en,                                                      
input logic  [`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0]       cp0_lsu_tag_random0,     // mark zhangdunbo                                
input logic                                               cp0_yy_dcache_pref_en,                                                    
input logic                                               cp0_lsu_dcache_en,                   
input logic                                               cp0_lsu_ecc_en,                      
input logic                                               cp0_lsu_icg_en,                      
input logic                                               cp0_lsu_l2_st_pref_en,               
input logic                                               cp0_lsu_nsfe,                        
input logic                                               cp0_lsu_tag_ecc_inj,                 
input logic   [`WK_LS_DCAHCE_SINGLE_MATE_TAG_WIDTH-1:0]   cp0_lsu_tag_random1,     // mark zhangdunbo            
input logic   [`VSTART_WIDTH-1 :0]                                      cp0_lsu_vstart,                      
input logic                                               cpurst_b,                            
input logic                                               ctrl_st_clk,
input logic                                               ctrl_ld_clk,
input logic  [38 :0]                                      dcache_lsda_ex2_data_bank0_dout,       
input logic  [38 :0]                                      dcache_lsda_ex2_data_bank1_dout,       
input logic  [38 :0]                                      dcache_lsda_ex2_data_bank2_dout,       
input logic  [38 :0]                                      dcache_lsda_ex2_data_bank3_dout,       
input logic  [38 :0]                                      dcache_lsda_ex2_data_bank4_dout,       
input logic  [38 :0]                                      dcache_lsda_ex2_data_bank5_dout,       
input logic  [38 :0]                                      dcache_lsda_ex2_data_bank6_dout,       
input logic  [38 :0]                                      dcache_lsda_ex2_data_bank7_dout,       
input logic  [38 :0]                                      dcache_lsda_ex2_data_bank8_dout,       
input logic  [38 :0]                                      dcache_lsda_ex2_data_bank9_dout,       
input logic  [38 :0]                                      dcache_lsda_ex2_data_bank10_dout,       
input logic  [38 :0]                                      dcache_lsda_ex2_data_bank11_dout,       
input logic  [38 :0]                                      dcache_lsda_ex2_data_bank12_dout,       
input logic  [38 :0]                                      dcache_lsda_ex2_data_bank13_dout,       
input logic  [38 :0]                                      dcache_lsda_ex2_data_bank14_dout,       
input logic  [38 :0]                                      dcache_lsda_ex2_data_bank15_dout,
input logic  [`WK_LS_DCACHE_LDTAG_WIDTH-1:0]              dcache_lsda_ex2_tag_dout,          //should be 68                           
input logic  [15 :0]                                      dcache_dirty_din,                    
input logic                                               dcache_dirty_gwen,                   
input logic  [15 :0]                                      dcache_dirty_wen,                    
input logic  [7 :0]                                       dcache_idx,                          
input logic  [`WK_LS_DCACHE_META_WIDTH-1:0]               dcache_lsu_st_dirty_dout,                      
input logic  [`WK_LS_DCACHE_TAG_NOECC_WIDTH-1:0]          dcache_tag_din,                      
input logic                                               dcache_tag_gwen,                     
input logic  [3 :0]                                       dcache_tag_wen,
input logic  [1 :0]                                       lsda_ex2_replace_way,                   
input logic                                               forever_cpuclk,                      
input logic                                               lda0_lsda_ex3_hit_idx, 
input logic                                               lsda_lsda_ex3_hit_idx,  
input logic                                               lsda_lsda_ex3_is_load,  
input logic   [IID_WIDTH-1:0]                             lsda_lsda_ex3_iid,      
input logic                                               lda0_lsda_ex3_tag_inj_mask, //1->2, LTL@20241109
input logic                                               lsda_lsda_ex3_tag_inj_mask,  
input logic                                               lfb_lsda_ex3_hit_idx,                   
input logic                                               lm_lsda_ex3_hit_idx,                    
input logic                                               lsu_has_fence,                                    
input logic                                               pad_yy_icg_scan_en,                                                       
input logic                                               rtu_lsu_flush_fe,                    
input logic                                               rtu_yy_xx_commit0,                                
input logic                                               rtu_yy_xx_commit1,
input logic                                               rtu_yy_xx_commit2,
input logic                                               rtu_yy_xx_commit3, 
input logic                                               rtu_yy_xx_commit4, 
input logic                                               rtu_yy_xx_commit5,
input logic                                               rtu_yy_xx_commit6,
input logic                                               rtu_yy_xx_commit7,                  
input logic   [IID_WIDTH-1:0]                             rtu_yy_xx_commit0_iid,
input logic   [IID_WIDTH-1:0]                             rtu_yy_xx_commit1_iid,                       
input logic   [IID_WIDTH-1:0]                             rtu_yy_xx_commit2_iid,    
input logic   [IID_WIDTH-1:0]                             rtu_yy_xx_commit3_iid,               
input logic   [IID_WIDTH-1:0]                             rtu_yy_xx_commit4_iid,               
input logic   [IID_WIDTH-1:0]                             rtu_yy_xx_commit5_iid,
input logic   [IID_WIDTH-1:0]                             rtu_yy_xx_commit6_iid,               
input logic   [IID_WIDTH-1:0]                             rtu_yy_xx_commit7_iid,  
input logic                                               lsdc_ex2_is_load,         
input logic   [`WK_PA_WIDTH-1:0]                          lsdc_ex2_addr0,
input logic                                               lsdc_lsda_ex2_ahead_predict,                 
input logic                                               lsdc_lsda_ex2_ahead_preg_wb_vld,             
input logic                                               lsdc_lsda_ex2_ahead_vreg_wb_vld,                            
input logic                                               lsdc_lsda_ex2_already_da,                    
input logic                                               lsdc_ex2_atomic,                        
input logic  [2  :0]                                      lsdc_lsda_ex2_borrow_db,                     
input logic                                               lsdc_lsda_ex2_borrow_icc,                    
input logic                                               lsdc_lsda_ex2_borrow_icc_ecc,                
input logic                                               lsdc_lsda_ex2_borrow_icc_tag,                
input logic  [1  :0]                                      lsdc_lsda_ex2_borrow_idx_5to4,               
input logic                                               lsdc_lsda_ex2_borrow_mmu,                    
input logic                                               lsdc_lsda_ex2_borrow_sndb,                   
input logic                                               lsdc_lsda_ex2_borrow_vb,                     
input logic                                               lsdc_lsda_ex2_borrow_vld,                    
input logic                                               lsdc_lsda_ex2_borrow_wmb,    
input logic                                               lsdc_lsda_ex2_borrow_dcache_replace,         
input logic  [1  :0]                                      lsdc_lsda_ex2_borrow_dcache_sw,                                 
input logic                                               lsdc_lsda_ex2_borrow_snq,                    
input logic  [SNQ_ENTRY-1:0]                              lsdc_lsda_ex2_borrow_snq_id,                               
input logic                                               lsdc_ex2_boundary,                      
input logic  [15 :0]                                      lsdc_ex2_bytes_vld,
input logic  [15 :0]                                      lsdc_ex2_bytes_vld1,
input logic  [15 :0]                                      lsdc_ex2_bytes_vld2,
input logic  [15 :0]                                      lsdc_ex2_bytes_vld3,
input logic                                               lsdc_lsda_ex2_cb_addr_create,           
input logic                                               lsdc_lsda_ex2_cb_merge_en,           
input logic  [15 :0]                                      lsdc_lsda_ex2_data_rot_sel,                         
input logic                                               lsdc_lsda_ex2_icc_tag_vld,                                 
input logic  [LQ_ENTRY-1:0]                               lsdc_lsda_ex2_lq_entry,   
input logic  [15:0]                                       lsdc_lsda_ex2_dcache_dirty_array,         
input logic  [`WK_LS_DCACHE_TAG_NOECC_WIDTH-1:0]          lsdc_lsda_ex2_dcache_tag_array,           
input logic                                               lsdc_lsda_ex2_expt_vld_gate_en,           
input logic                                               lsdc_lsda_ex2_inst_vld,                   
input logic                                               lsdc_ex2_page_buf,                   
input logic                                               lsdc_ex2_page_ca,                    
input logic                                               lsdc_ex2_page_sec,                   
input logic                                               lsdc_ex2_page_share,                 
input logic                                               lsdc_ex2_page_so,                    
input logic                                               lsdc_ex2_page_wa,          
input logic  [`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0]       lsdc_lsda_ex2_tag_read,                   
input logic                                               lsdc_lsda_ex2_data_inj_dp,            
input logic                                               lsdc_lsda_ex2_dcache_hit,                    
input logic                                               lsdc_ex2_dtcm_hit,                      
input logic  [8  :0]                                      lsdc_lsda_ex2_element_cnt,                   
input logic  [1  :0]                                      lsdc_ex2_element_size, 
input logic                                               lsdc_lsda_ex2_staddr_vld,                 
input logic                                               lsdc_lsda_ex2_tag0_hit,                   
input logic                                               lsdc_lsda_ex2_tag1_hit,                   
input logic                                               lsdc_lsda_ex2_tag2_hit,                   
input logic                                               lsdc_lsda_ex2_tag3_hit,
input logic                                               lsdc_lsda_ex2_dcwp_hit_idx,                                   
input logic                                               lsdc_lsda_ex2_expt_access_fault_extra,       
input logic                                               lsdc_lsda_ex2_expt_access_fault_mask,        
input logic   [4 :0]                                      lsdc_lsda_ex2_expt_vec,  
input logic                                               lsdc_lsda_ex2_expt_vld_except_access_err,
input logic  [15 :0]                                      lsdc_lsda_ex2_fwd_bytes_vld,                 
input logic                                               lsdc_ex2_fwd_sq_vld,                    
input logic                                               lsdc_ex2_fwd_wmb_vld,                   
input logic  [3  :0]                                      lsdc_ex2_get_dcache_data,               
input logic                                               lsdc_ex2_hit_3_region,               
input logic                                               lsdc_ex2_hit_2_region, 
input logic                                               lsdc_ex2_hit_1_region,               
input logic                                               lsdc_ex2_hit_0_region,                
input logic   [3 :0]                                      lsdc_ex2_hit_way,   
input logic   [3 :0]                                      lsdc_ex2_fence_mode,                    
input logic                                               lsdc_lsda_ex2_get_dcache_tag_dirty,          
input logic                                               lsdc_ex2_icc,                           
input logic   [IID_WIDTH-1:0]                             lsdc_ex2_ld_iid,//logic leves opt@LTL
input logic   [IID_WIDTH-1:0]                             lsdc_ex2_st_iid,//logic leves opt@LTL 
input logic                                               lsdc_lsda_ex2_inst_fof,                                                            
input logic                                               lsdc_lsda_ex2_inst_vfls,                                                               
input logic                                               lsdc_ex2_itcm_hit, 
input logic   [1 :0]                                      lsdc_ex2_inst_mode,                     
input logic   [2 :0]                                      lsdc_ex2_inst_size,                     
input logic   [1 :0]                                      lsdc_ex2_inst_type,                     
input logic                                               lsdc_ex2_inst_vld,                      
input logic                                               lsdc_ex2_inst_vls,
input logic  [PC_LEN-1:0]                                 lsdc_lsda_ex2_ldfifo_pc,                      
input logic   [LSIQ_ENTRY-1:0]                            lsdc_lsda_ex2_lsid,                          
input logic                                               lsdc_lsda_ex2_mmu_req,                       
input logic   [`WK_PA_WIDTH-1:0]                          lsdc_lsda_ex2_mt_value,                      
input logic   [1 :0]                                      lsdc_lsda_ex2_no_spec,
input logic                                               lsdc_lsda_ex2_no_spec_exist, 
input logic                                               lsdc_pfu_info_set_vld,                             
input logic  [PREG-1  :0]                                 lsdc_lsda_ex2_preg,                          
input logic  [3  :0]                                      lsdc_lsda_ex2_preg_sign_sel,                 
input logic  [15 :0]                                      lsdc_lsda_ex2_reg_bytes_vld,   
input logic  [15 :0]                                      lsdc_lsda_ex2_reg_bytes_vld1,   
input logic  [15 :0]                                      lsdc_lsda_ex2_reg_bytes_vld2,   
input logic  [15 :0]                                      lsdc_lsda_ex2_reg_bytes_vld3,   
input logic                                               lsdc_lsda_ex2_inst_us,
input logic                                               lsdc_lsda_ex2_us_discard,
input logic                                               lsdc_ex2_old,                           
input logic   [PC_LEN-1:0]                                lsdc_lsda_ex2_pc,                            
input logic                                               lsdc_lsda_ex2_pf_inst,                       
input logic   [`WK_PA_WIDTH-1:0]                          lsdc_lsda_ex2_pfu_va,                        
input logic                                               lsdc_ex2_ld_secd,
input logic                                               lsdc_ex2_st_secd,
input logic  [1  :0]                                      lsdc_lsda_ex2_settle_way,                    
input logic  [8  :0]                                      lsdc_lsda_ex2_setvl_val,                     
input logic                                               lsdc_lsda_ex2_sign_extend,                           
input logic                                               lsdc_lsda_ex2_spec_fail,                     
input logic [PC_LEN-1:0]                                  lq_lsu_ex2_spec_fail_pc, // wjh@sfp
input logic                                               lsdc_lsda_ex2_split,
input logic                                               lsdc_lsda_ex2_tag_inj_dp,                                     
// input logic  [1  :0]                                      lsdc_lsda_ex2_vlmul,
input logic  [2  :0]  lsdc_lsda_ex2_vlmul,  //pwh 1 for rvv1.0                        
input logic  [7  :0]                                      lsdc_lsda_ex2_vmb_id,                        
input logic                                               lsdc_lsda_ex2_vmb_merge_vld,                 
input logic  [VREG-1  :0]                                 lsdc_lsda_ex2_vreg,                          
input logic                                               lsdc_lsda_ex2_vreg_sign_sel, 
//input logic  [1  :0]                                      lsdc_ex2_vsew,  //rvv1.0@hcl 
input logic  [1  :0]  lsdc_ex2_vmew,  //rvv1.0@hcl
input logic  [1  :0]  lsdc_ex2_vmop,  //rvv1.0@hcl                       
input logic                                               lsdc_lsda_ex2_wait_fence,
input logic                                               ld_hit_prefetch,                     
input logic                                               lfb_lsda_hit_idx,                   
input logic                                               lm_lsda_hit_idx,                    
input logic                                               lsu_special_clk,                     
input logic                                               mmu_lsu_access_fault,  
input logic  [`WK_PA_WIDTH-1:0]                           pfu_biu_req_addr,                    
input logic                                               rb_lsda_ex3_full,                       
input logic  [1  :0]                                      rb_lsda_ex3_hit_idx,                    
input logic                                               rb_lsda_merge_fail,                 
input logic                                               lsdc_lsda_ex2_st,                            
input logic                                               lsdc_lsda_ex2_sync_fence,                                    
input logic                                               lsdc_ex2_vector_nop,
input logic  [127:0]                                      std0_ex1_data_bypass,                  
input logic                                               std0_ex1_inst_vld,
input logic  [127:0]                                      std1_ex1_data_bypass,                  
input logic                                               std1_ex1_inst_vld,                     
input logic                                               sf_spec_mark,                        
input logic  [127:0]                                      sq_lsda_ex3_fwd_data,                   
input logic  [127:0]                                      sq_lsda_ex3_fwd_data_pe,                
input logic                                               sq_lsda_ex2_data_discard_req,           
input logic                                               sq_lsda_ex2_fwd_bypass_multi,           
input logic                                               sq_lsda_ex2_fwd_bypass_req, 
input logic                                               sq_lsda_ex2_fwd_bypass_sel,            
input logic  [SQ_ENTRY-1:0]                               sq_lsda_ex2_fwd_id,                     
input logic                                               sq_lsda_ex2_fwd_multi,                  
input logic                                               sq_lsda_ex2_fwd_multi_mask,             
input logic                                               sq_lsda_ex2_newest_fwd_data_vld_req,    
input logic                                               sq_lsda_ex2_other_discard_req,          
input logic  [`WK_PA_WIDTH-1:0]                           lsda_selfda_ex3_addr,                                     
input logic  [127:0]                                      wmb_lsda_fwd_data,                  
input logic                                               wmb_lsdc_discard_req,          
output logic                                              lsu_hpcp_ld_cache_access,            
output logic                                              lsu_hpcp_ld_cache_miss,              
output logic                                              lsu_hpcp_st_cache_access,            
output logic                                              lsu_hpcp_st_cache_miss,
output logic                                              lsu_hpcp_ls_unalign_inst,
output logic                                              lsu_hpcp_ld_data_discard,            
output logic                                              lsu_hpcp_ld_discard_sq,
output logic                                              lsda_ex3_is_load,                         
output logic  [`WK_PA_WIDTH-1:0]                          lsda_ex3_addr,
output logic  [`WK_PA_WIDTH-1:0]                          lsda_ex3_ld_addr,
output logic  [`WK_PA_WIDTH-1:0]                          lsda_ex3_st_addr, 
output logic [1  :0]                                      lsda_ex3_addr_5to4,                                            
output logic                                              lsda_ex3_borrow_icc_vld,                
output logic                                              lsda_ex3_borrow_vld,                   
output logic                                              lsda_ex3_boundary_after_mask,           
output logic                                              lsda_ex3_boundary_after_mask_ff,
output logic [15 :0]                                      lsda_ex3_bytes_vld,                     
output logic [15 :0]                                      lsda_ex3_bytes_vld1,                     
output logic [15 :0]                                      lsda_ex3_bytes_vld2,                     
output logic [15 :0]                                      lsda_ex3_bytes_vld3,                     
//output logic [127:0]  lsda_cb_data,                       
output logic                                              lsda_cb_data_vld,                   
output logic                                              lsda_cb_ecc_cancel,                 
output logic                                              lsda_cb_ld_inst_vld,                
output logic [511:0]                                      lsda_ex3_data512,                       
output logic [15 :0]                                      lsda_ex3_data_rot_sel,                                     
output logic [22 :0]                                      lsda_ex3_ecc_info,                      
output logic                                              lsda_ex3_ecc_info_update,               
output logic                                              lsda_ex3_ecc_info_update_gate,          
output logic [`WK_PA_WIDTH-1:0]                           lsda_ex3_ecc_pa,                        
output logic [LSIQ_ENTRY-1:0]                             lsda_ex3_ecc_wakeup,                    
output logic [8  :0]                                      lsda_ex3_element_cnt,                   
output logic [1  :0]                                      lsda_ex3_element_size,                  
output logic                                              lsda_ex3_fwd_ecc_stall,                 
output logic                                              lsda_vb_ex3_dcache_dirty,                  
output logic                                              lsda_ex3_dcache_hit,                    
output logic                                              lsda_vb_ex3_dcache_miss,                   
output logic                                              lsda_vb_ex3_dcache_page_share,             
output logic                                              lsda_vb_ex3_dcache_replace_dirty,          
output logic                                              lsda_vb_ex3_dcache_replace_page_share,     
output logic                                              lsda_vb_ex3_dcache_replace_valid,          
output logic  [1 :0]                                      lsda_vb_ex3_dcache_replace_way,            
output logic  [1 :0]                                      lsda_vb_ex3_dcache_way,                                   
output logic                                              lsda_ex3_fence_inst,                    
output logic  [3 :0]                                      lsda_ex3_fence_mode,                    
output logic  [3 :0]                                      lsda_icc_ex3_dirty_info,                
output logic  [`WK_LS_DCACHE_SINGLE_DIRTY_ECC_WIDTH-1:0]  lsda_icc_ex3_ecc_info,                  
output logic  [`WK_LS_DCACHE_SINGLE_TAG_WIDTH-1:0]        lsda_icc_ex3_tag_info, 
output logic  [127:0]                                     lsda_icc_read_data,                                          
output logic  [`WK_PA_WIDTH-7:0]                          lsda_ex3_idx,                 
output logic  [LSIQ_ENTRY-1:0]                            lsda_idu_ex3_already_da,                              
output logic  [LSIQ_ENTRY-1:0]                            lsda_idu_ex3_boundary_gateclk_en,       
output logic  [LSIQ_ENTRY-1:0]                            lsda_idu_ex3_pop_entry,                 
output logic                                              lsda_idu_ex3_pop_vld,                   
output logic  [LSIQ_ENTRY-1:0]                            lsda_idu_ex3_rb_full,                   
output logic  [LSIQ_ENTRY-1:0]                            lsda_idu_ex3_secd,                      
output logic  [LSIQ_ENTRY-1:0]                            lsda_idu_ex3_us_restart,
output logic  [LSIQ_ENTRY-1:0]                            lsda_idu_ex3_spec_fail,                 
output logic  [LSIQ_ENTRY-1:0]                            lsda_idu_ex3_wait_fence,                
output logic  [IID_WIDTH-1:0]                             lsda_ex3_iid,      //need send to lsda, for st da rb create, ensure only 1 rb create, LTL@20241101                
output logic  [IID_WIDTH-1:0]                             lsda_ex3_ld_iid,
output logic  [IID_WIDTH-1:0]                             lsda_ex3_st_iid,
output logic                                              lsda_ex3_inst_fof,                                
output logic                                              lsda_ex3_inst_vfls,                     
output logic                                              lsda_ex3_inst_vls,                      
output logic [14 :0]                                      lsda_ex3_ldfifo_pc, 
output logic  [2 :0]                                      lsda_ex3_inst_size,                     
output logic                                              lsda_ex3_inst_vld,  
output logic                                              lsda_lfb_discard_grnt,              
output logic                                              lsda_lfb_set_wakeup_queue,          
output logic                                              lsda_lfb_set_wakeup_queue_gate,     
output logic [LSIQ_ENTRY :0]                              lsda_lfb_wakeup_queue_next,         
output logic                                              lsda_lm_ex3_discard_grnt,               
output logic                                              lsda_lm_ex3_ecc_err,                    
output logic                                              lsda_lm_ex3_lr_no_restart,              
output logic                                              lsda_lm_ex3_lr_no_restart_dp,           
output logic                                              lsda_lm_ex3_no_req,                     
output logic                                              lsda_lm_ex3_vector_nop,  
output logic [LQ_ENTRY-1:0]                               lsda_ex3_lq_entry_pop, 
output logic [LSIQ_ENTRY-1:0]                             lsda_ex3_lsid,
output logic                                              lsda_mcic_borrow_mmu,               
output logic                                              lsda_mcic_borrow_mmu_req,           
output logic [63 :0]                                      lsda_mcic_bypass_data,              
output logic                                              lsda_mcic_data_err,                 
output logic                                              lsda_mcic_rb_full,                  
output logic                                              lsda_mcic_wakeup,
output logic                                              lsda_ex3_old,                           
output logic                                              lsda_ex3_page_buf,                      
output logic                                              lsda_ex3_page_ca, 
output logic                                              lsda_ex3_ld_page_ca,
output logic                                              lsda_ex3_st_page_ca,                      
output logic                                              lsda_ex3_page_sec,                      
output logic                                              lsda_ex3_page_sec_ff,                   
output logic                                              lsda_ex3_page_share,                    
output logic                                              lsda_ex3_page_share_ff,                 
output logic                                              lsda_ex3_page_so,
output logic                                              lsda_pfu_ex3_awk_dp_vld,                
output logic                                              lsda_pfu_ex3_awk_vld,                   
output logic                                              lsda_pfu_ex3_biu_req_hit_idx,           
output logic                                              lsda_pfu_ex3_eviwk_cnt_vld,             
output logic                                              lsda_pfu_ex3_pf_inst_vld,               
output logic [`WK_PA_WIDTH-1:0]                           lsda_pfu_ex3_va,                        
output logic [`WK_PA_WIDTH-1:0]                           lsda_pfu_ex3_ppfu_va,                       
output logic [`WK_PA_WIDTH-13:0]                          lsda_pfu_ex3_ppn_ff,   
output logic  [PC_LEN-1:0]                                lsda_pfu_ex3_pc,
output logic                                              lsda_pfu_ld_tag_miss,                                                                               
output logic [PREG-1  :0]                                 lsda_ex3_preg,                          
output logic [3  :0]                                      lsda_ex3_preg_sign_sel,                 
output logic                                              lsda_rb_ex3_atomic, 
output logic                                              lsda_rb_ex3_cmit,                       
output logic                                              lsda_rb_ex3_cmplt_success,              
output logic                                              lsda_rb_ex3_create_dp_vld,              
output logic                                              lsda_rb_ex3_create_gateclk_en,          
output logic                                              lsda_rb_ex3_create_judge_vld,           
output logic                                              lsda_rb_ex3_create_lfb,                 
output logic                                              lsda_rb_ex3_create_vld,                 
output logic [127:0]                                      lsda_rb_ex3_data_ori,                   
output logic [127:0]                                      lsda_rb_ex3_data_ori1,                   
output logic [127:0]                                      lsda_rb_ex3_data_ori2,                   
output logic [127:0]                                      lsda_rb_ex3_data_ori3,                   
output logic                                              lsda_rb_ex3_data_vld,                   
output logic                                              lsda_rb_ex3_dest_vld,                   
output logic                                              lsda_rb_ex3_discard_grnt,               
output logic                                              lsda_rb_ex3_expt_vld,                   
output logic                                              lsda_ex3_rb_full_gateclk_en,            
output logic                                              lsda_rb_ex3_ldamo,                      
output logic                                              lsda_rb_ex3_merge_dp_vld,               
output logic                                              lsda_rb_ex3_merge_expt_vld,             
output logic                                              lsda_rb_ex3_merge_gateclk_en,           
output logic                                              lsda_rb_ex3_merge_vld, 
output logic [15 :0]                                      lsda_ex3_reg_bytes_vld,                 
output logic [15 :0]                                      lsda_ex3_reg_bytes_vld1,                 
output logic [15 :0]                                      lsda_ex3_reg_bytes_vld2,                 
output logic [15 :0]                                      lsda_ex3_reg_bytes_vld3,                 
output logic                                              lsda_ex3_inst_us,
output logic [8  :0]                                      lsda_ex3_setvl_val,                     
output logic [`WK_PA_WIDTH-5:0]                           lsda_sf_ex3_addr_tto4,                  
output logic [15 :0]                                      lsda_sf_ex3_bytes_vld,                  
output logic [IID_WIDTH-1:0]                              lsda_sf_ex3_iid,                        
output logic                                              lsda_sf_ex3_no_spec_miss,               
output logic                                              lsda_sf_ex3_no_spec_miss_gate,          
output logic                                              lsda_sf_ex3_spec_chk_req,             
output logic [PC_LEN-1:0]                                 lsda_sfp_ex3_src_pc, // wjh@sfp
output logic [PC_LEN-1:0]                                 lsda_sfp_ex3_dst_pc, // wjh@sfp
output logic                                              lsda_sq_ex3_secd,                          
output logic                                              lsda_ex3_sign_extend, 
output logic                                              lsda_snq_ex3_borrow_icc,                
output logic                                              lsda_snq_ex3_borrow_sndb,               
output logic                                              lsda_ex3_special_gateclk_en,            
output logic                                              lsda_ex3_split,                         
output logic                                              lsda_sq_ex3_data_discard_vld,           
output logic [SQ_ENTRY-1:0]                               lsda_sq_ex3_fwd_id,                     
output logic                                              lsda_sq_ex3_fwd_multi_vld,              
output logic                                              lsda_sq_ex3_global_discard_vld,   
output logic                                              selfda_lsda_ex3_hit_idx,                 
output logic                                              lsda_ex3_tag_inj_mask,     
output logic  [SNQ_ENTRY-1:0]                             lsda_snq_ex3_borrow_snq,                
output logic                                              lsda_snq_ex3_dcache_dirty,              
output logic                                              lsda_snq_ex3_dcache_page_share,         
output logic                                              lsda_snq_ex3_dcache_share,              
output logic                                              lsda_snq_ex3_dcache_valid,              
output logic  [1 :0]                                      lsda_snq_ex3_dcache_way,                
output logic                                              lsda_snq_ex3_ecc_err,                   
output logic  [SNQ_ENTRY-1:0]                             lsda_snq_ex3_entry_tag_reissue,         
output logic                                              lsda_sq_ex3_dcache_dirty,               
output logic                                              lsda_sq_ex3_dcache_page_share,          
output logic                                              lsda_sq_ex3_dcache_share,               
output logic                                              lsda_sq_ex3_dcache_valid,               
output logic  [1 :0]                                      lsda_sq_ex3_dcache_way,                 
output logic                                              lsda_sq_ex3_ecc_stall,                  
output logic                                              lsda_sq_ex3_expt_vld,                   
output logic                                              lsda_sq_ex3_lm_fail,                    
output logic                                              lsda_sq_ex3_no_restart,                 
output logic                                              lsda_ex3_sync_fence,                    
output logic                                              lsda_ex3_sync_inst,  
output logic [2  :0]                                      lsda_vb_ex3_borrow_vb,                  
output logic                                              lsda_vb_ex3_snq_data_reissue,           
output logic                                              lsda_vb_ex3_snq_ecc_err,      
output logic                                              lsda_vb_ex3_ecc_err,                    
output logic                                              lsda_vb_ex3_ecc_stall,                  
output logic  [`WK_PA_WIDTH-15:0]                         lsda_vb_ex3_feedback_addr_tto14,        
output logic                                              lsda_vb_ex3_tag_reissue,                
output logic                                              lsda_ex3_wait_fence_gateclk_en,         
output logic                                              lsda_lswb_ex3_cmplt_req,                  
output logic  [4 :0]                                      lsda_lswb_ex3_expt_vec,                   
output logic                                              lsda_ex3_expt_vld,                   
output logic  [`WK_PA_WIDTH-1:0]                          lsda_lswb_ex3_mt_value,                   
output logic                                              lsda_lswb_ex3_no_spec_hit,                
output logic                                              lsda_lswb_ex3_no_spec_mispred,            
output logic                                              lsda_lswb_ex3_no_spec_miss,               
output logic                                              lsda_lswb_ex3_no_spec_target,             
output logic                                              lsda_lswb_ex3_spec_fail,                  
output logic                                              lsda_lswb_ex3_vstart_vld,
// output logic [1  :0]                                      lsda_ex3_vlmul,  
output logic [2  :0]  lsda_ex3_vlmul,  //pwh 2 for rvv1.0                      
output logic [7  :0]                                      lsda_ex3_vmb_id,                        
output logic                                              lsda_ex3_vmb_merge_vld,                 
output logic [VREG-1  :0]                                 lsda_ex3_vreg,                          
output logic                                              lsda_ex3_vreg_sign_sel,                 
//output logic [1  :0]                                      lsda_ex3_vsew, //rvv1.0@hcl
output logic [1  :0]  lsda_ex3_vmew, //rvv1.0@hcl
output logic [1  :0]  lsda_ex3_vmop, //rvv1.0@hcl                                      
output logic                                              lsda_lswb_ex3_cmplt_req_gate,             
output logic [127:0]                                      lsda_lswb_ex3_data,                       
output logic [127:0]                                      lsda_lswb_ex3_data1,                       
output logic [127:0]                                      lsda_lswb_ex3_data2,                       
output logic [127:0]                                      lsda_lswb_ex3_data3,                       
output logic                                              lsda_lswb_ex3_data_req,                   
output logic                                              lsda_lswb_ex3_data_req_dp,                
output logic                                              lsda_lswb_ex3_data_req_gateclk_en,                
output logic                                              lsda_lswb_ex3_inst_vls,                   
output logic [14 :0]                                      lsda_lswb_ex3_vreg_sign_sel,              
output logic                                              lsda_lswb_ex3_vsetvl, 
output logic                                              lsda_wmb_data_reissue,              
output logic                                              lsda_wmb_discard_vld,               
output logic [127:0]                                      lsda_wmb_read_data,                 
output logic                                              lsda_wmb_two_bit_err,                       
output logic [PREG-1  :0]                                 lsu_idu_ex3_fwd_preg,           
output logic [63 :0]                                      lsu_idu_ex3_fwd_preg_data,      
output logic                                              lsu_idu_ex3_fwd_preg_vld,       
output logic [VREG  :0]                                   lsu_idu_ex3_fwd_vreg,           
output logic [63 :0]                                      lsu_idu_ex3_fwd_vreg_fr_data,   
output logic                                              lsu_idu_ex3_fwd_vreg_vld,       
output logic [255 :0]                                     lsu_idu_ex3_fwd_vreg_vr0_data,  
output logic [255 :0]                                     lsu_idu_ex3_fwd_vreg_vr1_data,  
output logic [LSIQ_ENTRY-1 :0]                            lsda_idu_ex3_wait_old,              
output logic                                              lsda_idu_ex3_wait_old_gateclk_en,   
output logic                                              lsu_lsda_data_inj_cmplt,               
output logic                                              lsu_lsda_tag_inj_cmplt,                
output logic [IID_WIDTH-1:0]                              lsu_rtu_ex3_ssf_iid, 
output logic                                              lsu_rtu_ex3_ssf_vld,

output logic                                              ld_da_ex2_ecc_stall, // to determine ex2 pc vld @zdb
//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
input  logic                                              dtu_lsu_addr_trig_en,
input  logic                                              dtu_lsu_data_trig_en,
input  logic [`TDT_MP_HINFO_WIDTH-1:0]                    dtu_lsu_addr_halt_info,
input  logic                                              ls_dc_boundary_unmask,
input  logic                                              st_dc_data_check,
output logic                                              ls_da_dtu_addr_halt_info_stall_vld,
output logic [`TDT_MP_HINFO_WIDTH-1:0]                    ls_da_halt_info_am,
output logic [`TDT_MP_HINFO_WIDTH-1:0]                    ls_da_idu_halt_info,           
output logic [LSIQ_ENTRY-1:0]                             ls_da_idu_halt_info_update_vld,
output logic                                              ls_da_rb_data_check,
output logic                                              st_da_already_da,
output logic                                              st_da_data_check,
output logic                                              st_da_wb_expt_vld_cancel      
//==========================================================
//                  Risc-V Debug zdb End 
//========================================================== 
);

// &Regs; @30  

//ld type
logic                                                     lsdc_lsda_ex2_ld_inst_vld;  //=1 ust to valid pipe, =0 to invalid ld pipe, LTL@20241107 
logic                                                     lsdc_ex2_ld_inst_vld;  //=1 ust to valid pipe, =0 to invalid ld pipe, LTL@20241107 
logic                                                     lsda_ex3_is_load0;

logic                                                     selfda_lsda_ex3_ld_hit_idx;
logic                                                     lsda_ex3_ld_tag_inj_mask;
//logic [39 :0]  lsda_ex3_ld_addr;                                            
logic                                                     lsda_ex3_ld_borrow_vld;                                   
logic                                                     lsda_ex3_ld_dcache_hit;                    
logic [22 :0]                                             lsda_ex3_ld_ecc_info;                      
logic                                                     lsda_ex3_ld_ecc_info_update;               
logic                                                     lsda_ex3_ld_ecc_info_update_gate;          
logic [`WK_PA_WIDTH-1:0]                                  lsda_ex3_ld_ecc_pa;                        
logic [LSIQ_ENTRY-1 :0]                                   lsda_ex3_ld_ecc_wakeup;                    
logic [8  :0]                                             lsda_ex3_ld_element_cnt;                                   
logic [LSIQ_ENTRY-1:0]                                    lsda_idu_ex3_ld_already_da;                               
logic [LSIQ_ENTRY-1:0]                                    lsda_idu_ex3_ld_boundary_gateclk_en;       
logic [LSIQ_ENTRY-1:0]                                    lsda_idu_ex3_ld_pop_entry;                 
logic                                                     lsda_idu_ex3_ld_pop_vld;                   
logic [LSIQ_ENTRY-1:0]                                    lsda_idu_ex3_ld_rb_full;                   
logic [LSIQ_ENTRY-1:0]                                    lsda_idu_ex3_ld_secd;                      
logic [LSIQ_ENTRY-1:0]                                    lsda_idu_ex3_ld_spec_fail;                 
logic [LSIQ_ENTRY-1:0]                                    lsda_idu_ex3_ld_wait_fence;                    
//logic [IID_WIDTH-1:0]  lsda_ex3_ld_iid;                                
logic [2  :0]                                             lsda_ex3_ld_inst_size;                                       
logic                                                     lsda_ex3_ld_inst_vld;                                  
logic                                                     lsda_lm_ex3_ld_ecc_err;                          
logic                                                     lsda_ex3_ld_old;                           
logic                                                     lsda_ex3_ld_page_buf;                      
//logic          lsda_ex3_ld_page_ca;                       
logic                                                     lsda_ex3_ld_page_sec;                      
logic                                                     lsda_ex3_ld_page_sec_ff;                   
logic                                                     lsda_ex3_ld_page_share;                    
logic                                                     lsda_ex3_ld_page_share_ff;                 
logic                                                     lsda_ex3_ld_page_so;                       
logic                                                     lsda_pfu_ex3_ld_awk_dp_vld;                
logic                                                     lsda_pfu_ex3_ld_awk_vld;                   
logic                                                     lsda_pfu_ex3_ld_biu_req_hit_idx;           
logic                                                     lsda_pfu_ex3_ld_eviwk_cnt_vld;             
logic                                                     lsda_pfu_ex3_ld_pf_inst_vld;               
logic [`WK_PA_WIDTH-1:0]                                  lsda_pfu_ex3_ld_ppfu_va;                       
logic [`WK_PA_WIDTH-13:0]                                 lsda_pfu_ex3_ld_ppn_ff;                           
logic                                                     lsda_rb_ex3_ld_cmit;                       
logic                                                     lsda_rb_ex3_ld_create_dp_vld;              
logic                                                     lsda_rb_ex3_ld_create_gateclk_en;
logic                                                     lsda_rb_ex3_ld_create_judge_vld;           
logic                                                     lsda_rb_ex3_ld_create_lfb;                 
logic                                                     lsda_rb_ex3_ld_create_vld;                 
logic                                                     lsda_ex3_ld_rb_full_gateclk_en;            
logic [`WK_PA_WIDTH-5:0]                                  lsda_sf_ex3_ld_addr_tto4;                  
logic [15 :0]                                             lsda_sf_ex3_ld_bytes_vld;                  
logic [IID_WIDTH-1:0]                                     lsda_sf_ex3_ld_iid;                        
logic                                                     lsda_sf_ex3_ld_no_spec_miss;               
logic                                                     lsda_sf_ex3_ld_no_spec_miss_gate;                                      
logic                                                     lsda_ex3_ld_wait_fence_gateclk_en;         
logic                                                     lsda_lswb_ex3_ld_cmplt_req;                  
logic [4  :0]                                             lsda_lswb_ex3_ld_expt_vec; 
logic                                                     lsda_ex3_ld_expt_vld;                   
logic [`WK_PA_WIDTH-1:0]                                  lsda_lswb_ex3_ld_mt_value;                   
logic                                                     lsda_lswb_ex3_ld_no_spec_hit;                
logic                                                     lsda_lswb_ex3_ld_no_spec_mispred;            
logic                                                     lsda_lswb_ex3_ld_no_spec_miss;               
logic                                                     lsda_lswb_ex3_ld_no_spec_target;             
logic                                                     lsda_lswb_ex3_ld_spec_fail;                          
logic                                                     lsda_lswb_ex3_ld_vstart_vld;                 
//logic          lsu_hpcp_ld_cache_access;            
//logic          lsu_hpcp_ld_cache_miss;                          
logic                                                     lsu_hpcp_ld_unalign_inst;                     
logic                                                     lsu_lsda_ld_tag_inj_cmplt;                
logic [IID_WIDTH-1:0]                                     lsu_rtu_ex3_ld_ssf_iid; 
logic                                                     lsu_rtu_ex3_ld_ssf_vld; 
logic                                                     ld_da_ecc_stall;

//st type
logic                                                     lsdc_lsda_ex2_st_inst_vld;  //=1 ust to valid pipe, =0 to invalid st pipe, LTL@20241107
logic                                                     lsdc_ex2_st_inst_vld;  //=1 ust to valid pipe, =0 to invalid ld pipe, LTL@20241107  
logic                                                     lsda_ex3_is_load1;                

logic                                                     selfda_lsda_ex3_st_hit_idx;
logic                                                     lsda_ex3_st_tag_inj_mask;
//logic [39 :0]  lsda_ex3_st_addr;                                             
logic                                                     lsda_ex3_st_borrow_vld;                                   
logic                                                     lsda_ex3_st_dcache_hit;                    
logic [22 :0]                                             lsda_ex3_st_ecc_info;                      
logic                                                     lsda_ex3_st_ecc_info_update;               
logic                                                     lsda_ex3_st_ecc_info_update_gate;          
logic [`WK_PA_WIDTH-1:0]                                  lsda_ex3_st_ecc_pa;                        
logic [LSIQ_ENTRY-1:0]                                    lsda_ex3_st_ecc_wakeup;                    
logic [8  :0]                                             lsda_ex3_st_element_cnt;                                   
logic [LSIQ_ENTRY-1:0]                                    lsda_idu_ex3_st_already_da;                             
logic [LSIQ_ENTRY-1:0]                                    lsda_idu_ex3_st_boundary_gateclk_en;       
logic [LSIQ_ENTRY-1:0]                                    lsda_idu_ex3_st_pop_entry;                 
logic                                                     lsda_idu_ex3_st_pop_vld;                   
logic [LSIQ_ENTRY-1:0]                                    lsda_idu_ex3_st_rb_full;                   
logic [LSIQ_ENTRY-1:0]                                    lsda_idu_ex3_st_secd;                      
logic [LSIQ_ENTRY-1:0]                                    lsda_idu_ex3_st_spec_fail;                 
logic [LSIQ_ENTRY-1:0]                                    lsda_idu_ex3_st_wait_fence;                    
//logic [IID_WIDTH-1:0]  lsda_ex3_st_iid;                                
logic [2  :0]                                             lsda_ex3_st_inst_size;                                       
logic                                                     lsda_ex3_st_inst_vld;                                  
logic                                                     lsda_lm_ex3_st_ecc_err;                          
logic                                                     lsda_ex3_st_old;                           
logic                                                     lsda_ex3_st_page_buf;                      
//logic          lsda_ex3_st_page_ca;                       
logic                                                     lsda_ex3_st_page_sec;                      
logic                                                     lsda_ex3_st_page_sec_ff;                   
logic                                                     lsda_ex3_st_page_share;                    
logic                                                     lsda_ex3_st_page_share_ff;                 
logic                                                     lsda_ex3_st_page_so;                       
logic                                                     lsda_pfu_ex3_st_awk_dp_vld;                
logic                                                     lsda_pfu_ex3_st_awk_vld;                   
logic                                                     lsda_pfu_ex3_st_biu_req_hit_idx;           
logic                                                     lsda_pfu_ex3_st_eviwk_cnt_vld;             
logic                                                     lsda_pfu_ex3_st_pf_inst_vld;               
logic [`WK_PA_WIDTH-1:0]                                  lsda_pfu_ex3_st_ppfu_va;                       
logic [`WK_PA_WIDTH-13:0]                                 lsda_pfu_ex3_st_ppn_ff;                           
logic                                                     lsda_rb_ex3_st_cmit;                       
logic                                                     lsda_rb_ex3_st_create_dp_vld;
logic                                                     lsda_rb_ex3_st_create_judge_vld;              
logic                                                     lsda_rb_ex3_st_create_gateclk_en;          
logic                                                     lsda_rb_ex3_st_create_lfb;                 
logic                                                     lsda_rb_ex3_st_create_vld;                 
logic                                                     lsda_ex3_st_rb_full_gateclk_en;            
logic [`WK_PA_WIDTH-5:0]                                  lsda_sf_ex3_st_addr_tto4;                  
logic [15 :0]                                             lsda_sf_ex3_st_bytes_vld;                  
logic [IID_WIDTH-1:0]                                     lsda_sf_ex3_st_iid;                        
logic                                                     lsda_sf_ex3_st_no_spec_miss;               
logic                                                     lsda_sf_ex3_st_no_spec_miss_gate;                                      
logic                                                     lsda_ex3_st_wait_fence_gateclk_en;         
logic                                                     lsda_lswb_ex3_st_cmplt_req;                  
logic [4  :0]                                             lsda_lswb_ex3_st_expt_vec; 
logic                                                     lsda_ex3_st_expt_vld;                   
logic [`WK_PA_WIDTH-1:0]                                  lsda_lswb_ex3_st_mt_value;                   
logic                                                     lsda_lswb_ex3_st_no_spec_hit;                
logic                                                     lsda_lswb_ex3_st_no_spec_mispred;            
logic                                                     lsda_lswb_ex3_st_no_spec_miss;               
logic                                                     lsda_lswb_ex3_st_no_spec_target;             
logic                                                     lsda_lswb_ex3_st_spec_fail;                          
logic                                                     lsda_lswb_ex3_st_vstart_vld;                 
//logic          lsu_hpcp_st_cache_access;            
//logic          lsu_hpcp_st_cache_miss;                          
logic                                                     lsu_hpcp_st_unalign_inst;                     
logic                                                     lsu_lsda_st_tag_inj_cmplt;                
logic [IID_WIDTH-1:0]                                     lsu_rtu_ex3_st_ssf_iid; 
logic                                                     lsu_rtu_ex3_st_ssf_vld; 
logic [`WK_LS_DCACHE_TAG_NOECC_WIDTH-1:0]                 dcache_lsu_st_tag_dout;                                                                                                 
logic                                                     st_da_ecc_stall;    
logic [PC_LEN-1:0]                                        lsda_sfp_ex3_ld_src_pc; // wjh@sfp
logic [PC_LEN-1:0]                                        lsda_sfp_ex3_st_src_pc; // wjh@sfp
logic                                                     lsda_sf_ex3_ld_spec_chk_req; // wjh@sfp
logic                                                     lsda_sf_ex3_st_spec_chk_req; // wjh@sfp

//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
logic                                                     ld_da_dtu_addr_halt_info_stall_vld;
logic [`TDT_MP_HINFO_WIDTH-1:0]                           ld_da_idu_halt_info;  
logic [LSIQ_ENTRY-1:0]                                    ld_da_idu_halt_info_update_vld;
logic                                                     st_da_dtu_addr_halt_info_stall_vld;
logic [`TDT_MP_HINFO_WIDTH-1:0]                           st_da_idu_halt_info;  
logic [LSIQ_ENTRY-1:0]                                    st_da_idu_halt_info_update_vld;                                                
//==========================================================
//                  Risc-V Debug zdb End 
//==========================================================

xx_lsu_ls_ld_da #(
.IID_WIDTH    (IID_WIDTH    ),
.VB_DATA_ENTRY(VB_DATA_ENTRY),
.LQ_ENTRY     (LQ_ENTRY     ),
.LSIQ_ENTRY   (LSIQ_ENTRY   ),
.SQ_ENTRY     (SQ_ENTRY     ),
.WMB_ENTRY    (WMB_ENTRY    ),
.VMB_ENTRY    (VMB_ENTRY    ),
.PC_LEN       (PC_LEN       ),
.WK_PA_WIDTH  (`WK_PA_WIDTH  ),
.PREG         (PREG         ),
.VREG         (VREG         )
)
x_xx_lsu_ls_ld_da (
  .cb_ld_da_data                               (cb_ld_da_data),                            
  .cb_ld_da_data_vld                           (cb_ld_da_data_vld),                           
  .cp0_lsu_data_ecc_inj                        (cp0_lsu_data_ecc_inj),                              
  .cp0_lsu_data_random                         (cp0_lsu_data_random),                             
  .cp0_lsu_dcache_en                           (cp0_lsu_dcache_en),                             
  .cp0_lsu_dcache_read_index                   (cp0_lsu_dcache_read_index),                             
  .cp0_lsu_ecc_en                              (cp0_lsu_ecc_en),                              
  .cp0_lsu_icg_en                              (cp0_lsu_icg_en),                              
  .cp0_lsu_l2_pref_en                          (cp0_lsu_l2_pref_en),                              
  .cp0_lsu_nsfe                                (cp0_lsu_nsfe),                              
  .cp0_lsu_tag_ecc_inj                         (cp0_lsu_tag_ecc_inj),                             
  .cp0_lsu_tag_random0                         (cp0_lsu_tag_random0),                             
  .cp0_lsu_vstart                              (cp0_lsu_vstart),                              
  .cp0_yy_dcache_pref_en                       (cp0_yy_dcache_pref_en),                             
  .cpurst_b                                    (cpurst_b),                              
  .ctrl_ld_clk                                 (ctrl_ld_clk),                             
  .dcache_lsda_ex2_data_bank0_dout             (dcache_lsda_ex2_data_bank0_dout),                               
  .dcache_lsda_ex2_data_bank1_dout             (dcache_lsda_ex2_data_bank1_dout),                               
  .dcache_lsda_ex2_data_bank2_dout             (dcache_lsda_ex2_data_bank2_dout),                               
  .dcache_lsda_ex2_data_bank3_dout             (dcache_lsda_ex2_data_bank3_dout),                               
  .dcache_lsda_ex2_data_bank4_dout             (dcache_lsda_ex2_data_bank4_dout),                               
  .dcache_lsda_ex2_data_bank5_dout             (dcache_lsda_ex2_data_bank5_dout),                               
  .dcache_lsda_ex2_data_bank6_dout             (dcache_lsda_ex2_data_bank6_dout),                               
  .dcache_lsda_ex2_data_bank7_dout             (dcache_lsda_ex2_data_bank7_dout),                               
  .dcache_lsda_ex2_data_bank8_dout             (dcache_lsda_ex2_data_bank8_dout),                               
  .dcache_lsda_ex2_data_bank9_dout             (dcache_lsda_ex2_data_bank9_dout),                               
  .dcache_lsda_ex2_data_bank10_dout            (dcache_lsda_ex2_data_bank10_dout),                               
  .dcache_lsda_ex2_data_bank11_dout            (dcache_lsda_ex2_data_bank11_dout),                               
  .dcache_lsda_ex2_data_bank12_dout            (dcache_lsda_ex2_data_bank12_dout),                               
  .dcache_lsda_ex2_data_bank13_dout            (dcache_lsda_ex2_data_bank13_dout),                               
  .dcache_lsda_ex2_data_bank14_dout            (dcache_lsda_ex2_data_bank14_dout),                               
  .dcache_lsda_ex2_data_bank15_dout            (dcache_lsda_ex2_data_bank15_dout),
  .dcache_lsda_ex2_tag_dout                    (dcache_lsda_ex2_tag_dout),                                
  .forever_cpuclk                              (forever_cpuclk),
  .lsdc_ex2_is_load                            (lsdc_ex2_is_load),                              
  .lsdc_ex2_addr0                              (lsdc_ex2_addr0),                                 
  .lsdc_lsda_ex2_ahead_predict                 (lsdc_lsda_ex2_ahead_predict),                                     
  .lsdc_lsda_ex2_ahead_preg_wb_vld             (lsdc_lsda_ex2_ahead_preg_wb_vld),                                     
  .lsdc_lsda_ex2_ahead_vreg_wb_vld             (lsdc_lsda_ex2_ahead_vreg_wb_vld),                                     
  .lsdc_lsda_ex2_already_da                    (lsdc_lsda_ex2_already_da),                                      
  .lsdc_ex2_atomic                             (lsdc_ex2_atomic),                                                                    
  .lsdc_lsda_ex2_borrow_db                     (lsdc_lsda_ex2_borrow_db),                                     
  .lsdc_lsda_ex2_borrow_icc                    (lsdc_lsda_ex2_borrow_icc),                                      
  .lsdc_lsda_ex2_borrow_icc_ecc                (lsdc_lsda_ex2_borrow_icc_ecc),                                      
  .lsdc_lsda_ex2_borrow_icc_tag                (lsdc_lsda_ex2_borrow_icc_tag),                                      
  .lsdc_lsda_ex2_borrow_idx_5to4               (lsdc_lsda_ex2_borrow_idx_5to4),                                     
  .lsdc_lsda_ex2_borrow_mmu                    (lsdc_lsda_ex2_borrow_mmu),                                      
  .lsdc_lsda_ex2_borrow_sndb                   (lsdc_lsda_ex2_borrow_sndb),                                     
  .lsdc_lsda_ex2_borrow_vb                     (lsdc_lsda_ex2_borrow_vb),                                     
  .lsdc_lsda_ex2_borrow_vld                    (lsdc_lsda_ex2_borrow_vld),                                      
  .lsdc_lsda_ex2_borrow_wmb                    (lsdc_lsda_ex2_borrow_wmb),                                      
  .lsdc_ex2_boundary                           (lsdc_ex2_boundary),                                
  .lsdc_ex2_bytes_vld                          (lsdc_ex2_bytes_vld),                              
  .lsdc_ex2_bytes_vld1                         (lsdc_ex2_bytes_vld1),                             
  .lsdc_ex2_bytes_vld2                         (lsdc_ex2_bytes_vld2),
  .lsdc_ex2_bytes_vld3                         (lsdc_ex2_bytes_vld3),
  .lsdc_lsda_ex2_cb_addr_create                (lsdc_lsda_ex2_cb_addr_create),                                 
  .lsdc_lsda_ex2_cb_merge_en                   (lsdc_lsda_ex2_cb_merge_en),                             
  .lsdc_lsda_ex2_data_rot_sel                  (lsdc_lsda_ex2_data_rot_sel),                                   
  .lsdc_lsda_ex2_expt_vld_gate_en              (lsdc_lsda_ex2_expt_vld_gate_en),                                   
  .lsdc_lsda_ex2_icc_tag_vld                   (lsdc_lsda_ex2_icc_tag_vld),                                  
  .lsdc_lsda_ex2_inst_vld                      (lsdc_lsda_ex2_ld_inst_vld),                                   
  .lsdc_lsda_ex2_lq_entry                      (lsdc_lsda_ex2_lq_entry),                               
  .lsdc_ex2_old                                (lsdc_ex2_old),                      
  .lsdc_ex2_page_buf                           (lsdc_ex2_page_buf),                             
  .lsdc_ex2_page_ca                            (lsdc_ex2_page_ca),                              
  .lsdc_ex2_page_sec                           (lsdc_ex2_page_sec),                             
  .lsdc_ex2_page_share                         (lsdc_ex2_page_share),                             
  .lsdc_ex2_page_so                            (lsdc_ex2_page_so),                              
  .lsdc_lsda_ex2_pf_inst                       (lsdc_lsda_ex2_pf_inst),                         
  .lsdc_lsda_ex2_tag_read                      (lsdc_lsda_ex2_tag_read),                                   
  .lsdc_lsda_ex2_data_inj_dp                   (lsdc_lsda_ex2_data_inj_dp),                              
  .lsdc_lsda_ex2_dcache_hit                    (lsdc_lsda_ex2_dcache_hit),                                      
  .lsdc_ex2_dtcm_hit                           (lsdc_ex2_dtcm_hit),                                
  .lsdc_lsda_ex2_element_cnt                   (lsdc_lsda_ex2_element_cnt),                                     
  .lsdc_ex2_element_size                       (lsdc_ex2_element_size),                                
  .lsdc_lsda_ex2_expt_access_fault_extra       (lsdc_lsda_ex2_expt_access_fault_extra),                                     
  .lsdc_lsda_ex2_expt_access_fault_mask        (lsdc_lsda_ex2_expt_access_fault_mask),                                      
  .lsdc_lsda_ex2_expt_vec                      (lsdc_lsda_ex2_expt_vec),                                      
  .lsdc_lsda_ex2_expt_vld_except_access_err    (lsdc_lsda_ex2_expt_vld_except_access_err),                                      
  .lsdc_lsda_ex2_fwd_bytes_vld                 (lsdc_lsda_ex2_fwd_bytes_vld),                                     
  .lsdc_ex2_fwd_sq_vld                         (lsdc_ex2_fwd_sq_vld),                                
  .lsdc_ex2_fwd_wmb_vld                        (lsdc_ex2_fwd_wmb_vld),                                 
  .lsdc_ex2_get_dcache_data                    (lsdc_ex2_get_dcache_data),                                 
  .lsdc_ex2_hit_3_region                       (lsdc_ex2_hit_3_region),                                 
  .lsdc_ex2_hit_2_region                       (lsdc_ex2_hit_2_region),
  .lsdc_ex2_hit_1_region                       (lsdc_ex2_hit_1_region),                                 
  .lsdc_ex2_hit_0_region                       (lsdc_ex2_hit_0_region),                                
  .lsdc_ex2_hit_way                            (lsdc_ex2_hit_way),                                
  .lsdc_ex2_iid                                (lsdc_ex2_ld_iid),//logic leves opt@LTL                                 
  .lsdc_lsda_ex2_inst_fof                      (lsdc_lsda_ex2_inst_fof),                                      
  .lsdc_ex2_inst_size                          (lsdc_ex2_inst_size),                                 
  .lsdc_ex2_inst_type                          (lsdc_ex2_inst_type),                                 
  .lsdc_lsda_ex2_inst_vfls                     (lsdc_lsda_ex2_inst_vfls),                                     
  .lsdc_ex2_inst_vld                           (lsdc_ex2_ld_inst_vld),                                
  .lsdc_ex2_inst_vls                           (lsdc_ex2_inst_vls),                                
  .lsdc_ex2_itcm_hit                           (lsdc_ex2_itcm_hit),                                
  .lsdc_lsda_ex2_ldfifo_pc                     (lsdc_lsda_ex2_ldfifo_pc),                                     
  .lsdc_lsda_ex2_lsid                          (lsdc_lsda_ex2_lsid),                                      
  .lsdc_lsda_ex2_mmu_req                       (lsdc_lsda_ex2_mmu_req),                                     
  .lsdc_lsda_ex2_mt_value                      (lsdc_lsda_ex2_mt_value),                                      
  .lsdc_lsda_ex2_no_spec                       (lsdc_lsda_ex2_no_spec),                                     
  .lsdc_lsda_ex2_no_spec_exist                 (lsdc_lsda_ex2_no_spec_exist),                                     
  .lsdc_pfu_info_set_vld                       (lsdc_pfu_info_set_vld),                            
  .lsdc_lsda_ex2_pfu_va                        (lsdc_lsda_ex2_pfu_va),                                      
  .lsdc_lsda_ex2_preg                          (lsdc_lsda_ex2_preg),                                      
  .lsdc_lsda_ex2_preg_sign_sel                 (lsdc_lsda_ex2_preg_sign_sel),                                     
  .lsdc_lsda_ex2_reg_bytes_vld                 (lsdc_lsda_ex2_reg_bytes_vld),                  
  .lsdc_lsda_ex2_reg_bytes_vld1                (lsdc_lsda_ex2_reg_bytes_vld1),
  .lsdc_lsda_ex2_reg_bytes_vld2                (lsdc_lsda_ex2_reg_bytes_vld2),
  .lsdc_lsda_ex2_reg_bytes_vld3                (lsdc_lsda_ex2_reg_bytes_vld3),
  .lsdc_lsda_ex2_inst_us                       (lsdc_lsda_ex2_inst_us),
  .lsdc_lsda_ex2_us_discard                    (lsdc_lsda_ex2_us_discard),
  .lsdc_ex2_secd                               (lsdc_ex2_ld_secd),                                
  .lsdc_lsda_ex2_settle_way                    (lsdc_lsda_ex2_settle_way),                                      
  .lsdc_lsda_ex2_setvl_val                     (lsdc_lsda_ex2_setvl_val),                                     
  .lsdc_lsda_ex2_sign_extend                   (lsdc_lsda_ex2_sign_extend),                                     
  .lsdc_lsda_ex2_spec_fail                     (lsdc_lsda_ex2_spec_fail),                                     
  .lq_lsu_ex2_spec_fail_pc                     (lq_lsu_ex2_spec_fail_pc), // wjh@sfp
  .lsdc_lsda_ex2_split                         (lsdc_lsda_ex2_split),                                     
  .lsdc_lsda_ex2_tag_inj_dp                    (lsdc_lsda_ex2_tag_inj_dp),                                      
  .lsdc_ex2_vector_nop                         (lsdc_ex2_vector_nop),                                
  .lsdc_lsda_ex2_vlmul                         (lsdc_lsda_ex2_vlmul),                                     
  .lsdc_lsda_ex2_vmb_id                        (lsdc_lsda_ex2_vmb_id),                                      
  .lsdc_lsda_ex2_vmb_merge_vld                 (lsdc_lsda_ex2_vmb_merge_vld),                                     
  .lsdc_lsda_ex2_vreg                          (lsdc_lsda_ex2_vreg),                                      
  .lsdc_lsda_ex2_vreg_sign_sel                 (lsdc_lsda_ex2_vreg_sign_sel),                                     
  //.lsdc_ex2_vsew                               (lsdc_ex2_vsew),  //rvv1.0@hcl
  .lsdc_ex2_vmew                               (lsdc_ex2_vmew),  //rvv1.0@hcl
  .lsdc_ex2_vmop                               (lsdc_ex2_vmop),  //rvv1.0@hcl                              
  .lsdc_lsda_ex2_wait_fence                    (lsdc_lsda_ex2_wait_fence),                                      
  .ld_hit_prefetch                             (ld_hit_prefetch),                             
  .lfb_lsda_hit_idx                            (lfb_lsda_hit_idx),                             
  .lm_lsda_hit_idx                             (lm_lsda_hit_idx),                            
  .lsu_special_clk                             (lsu_special_clk),                             
  .mmu_lsu_access_fault                        (mmu_lsu_access_fault),                             
  .pad_yy_icg_scan_en                          (pad_yy_icg_scan_en),                              
  .pfu_biu_req_addr                            (pfu_biu_req_addr),                              
  .rb_lsda_ex3_full                            (rb_lsda_ex3_full),                                 
  .rb_lsda_ex3_hit_idx                         (rb_lsda_ex3_hit_idx[1]),                                
  .rb_lsda_merge_fail                          (rb_lsda_merge_fail),                             
  .rtu_lsu_flush_fe                            (rtu_lsu_flush_fe),                              
  .rtu_ck_flush                                (rtu_ck_flush),
  .rtu_ck_flush_iid                            (rtu_ck_flush_iid),
  .rtu_yy_xx_commit0                           (rtu_yy_xx_commit0),          
  .rtu_yy_xx_commit1                           (rtu_yy_xx_commit1),          
  .rtu_yy_xx_commit2                           (rtu_yy_xx_commit2),          
  .rtu_yy_xx_commit3                           (rtu_yy_xx_commit3),          
  .rtu_yy_xx_commit4                           (rtu_yy_xx_commit4),          
  .rtu_yy_xx_commit5                           (rtu_yy_xx_commit5),          
  .rtu_yy_xx_commit6                           (rtu_yy_xx_commit6),          
  .rtu_yy_xx_commit7                           (rtu_yy_xx_commit7),                            
  .rtu_yy_xx_commit0_iid                       (rtu_yy_xx_commit0_iid),               
  .rtu_yy_xx_commit1_iid                       (rtu_yy_xx_commit1_iid),                             
  .rtu_yy_xx_commit2_iid                       (rtu_yy_xx_commit2_iid),              
  .rtu_yy_xx_commit3_iid                       (rtu_yy_xx_commit3_iid),               
  .rtu_yy_xx_commit4_iid                       (rtu_yy_xx_commit4_iid),                             
  .rtu_yy_xx_commit5_iid                       (rtu_yy_xx_commit5_iid),               
  .rtu_yy_xx_commit6_iid                       (rtu_yy_xx_commit6_iid),               
  .rtu_yy_xx_commit7_iid                       (rtu_yy_xx_commit7_iid),                                            
  .std0_ex1_data_bypass                        (std0_ex1_data_bypass),      //1->2, for 2 st data, LTL@2024114                          
  .std0_ex1_inst_vld                           (std0_ex1_inst_vld), 
  .std1_ex1_data_bypass                        (std1_ex1_data_bypass),                              
  .std1_ex1_inst_vld                           (std1_ex1_inst_vld),                              
  .sf_spec_mark                                (sf_spec_mark),                              
  .sq_lsda_ex3_fwd_data                        (sq_lsda_ex3_fwd_data),                                 
  .sq_lsda_ex3_fwd_data_pe                     (sq_lsda_ex3_fwd_data_pe),                                
  .sq_lsda_ex2_data_discard_req                (sq_lsda_ex2_data_discard_req),                                 
  .sq_lsda_ex2_fwd_bypass_multi                (sq_lsda_ex2_fwd_bypass_multi),                                 
  .sq_lsda_ex2_fwd_bypass_req                  (sq_lsda_ex2_fwd_bypass_req),
  .sq_lsda_ex2_fwd_bypass_sel                  (sq_lsda_ex2_fwd_bypass_sel),                                 
  .sq_lsda_ex2_fwd_id                          (sq_lsda_ex2_fwd_id),                                 
  .sq_lsda_ex2_fwd_multi                       (sq_lsda_ex2_fwd_multi),                                
  .sq_lsda_ex2_fwd_multi_mask                  (sq_lsda_ex2_fwd_multi_mask),                                 
  .sq_lsda_ex2_newest_fwd_data_vld_req         (sq_lsda_ex2_newest_fwd_data_vld_req),                                
  .sq_lsda_ex2_other_discard_req               (sq_lsda_ex2_other_discard_req),                                
  .lsda_selfda_ex3_addr                        (lsda_selfda_ex3_addr),
  .lda0_lsda_ex3_tag_inj_mask                  (lda0_lsda_ex3_tag_inj_mask),   //tag inj mask, 3 must 2 0 and 1 1, tag can inj, LTL@20241203                                       
  .lsda_lsda_ex3_tag_inj_mask                  (lsda_lsda_ex3_tag_inj_mask),                                     
  .wmb_lsda_fwd_data                           (wmb_lsda_fwd_data),                            
  .wmb_lsdc_discard_req                        (wmb_lsdc_discard_req),
  .lsda_ex3_is_load                            (lsda_ex3_is_load0),                               
  .lsda_ex3_addr                               (lsda_ex3_ld_addr),                                
  .lsda_ex3_addr_5to4                          (lsda_ex3_addr_5to4),                                                              
  .lsda_ex3_borrow_vld                         (lsda_ex3_ld_borrow_vld),                                
  .lsda_ex3_boundary_after_mask                (lsda_ex3_boundary_after_mask),                                 
  .lsda_ex3_boundary_after_mask_ff             (lsda_ex3_boundary_after_mask_ff),                                
  .lsda_ex3_bytes_vld                          (lsda_ex3_bytes_vld),                                 
  .lsda_ex3_bytes_vld1                         (lsda_ex3_bytes_vld1),
  .lsda_ex3_bytes_vld2                         (lsda_ex3_bytes_vld2),
  .lsda_ex3_bytes_vld3                         (lsda_ex3_bytes_vld3),
  //.lsda_cb_data                                (lsda_cb_data),                             
  .lsda_cb_data_vld                            (lsda_cb_data_vld),                             
  .lsda_cb_ecc_cancel                          (lsda_cb_ecc_cancel),                             
  .lsda_cb_ld_inst_vld                         (lsda_cb_ld_inst_vld),                            
  .lsda_ex3_data512                            (lsda_ex3_data512),                                 
  .lsda_ex3_data_rot_sel                       (lsda_ex3_data_rot_sel),                                
  .lsda_ex3_dcache_hit                         (lsda_ex3_ld_dcache_hit),                                
  .lsda_ex3_ecc_info                           (lsda_ex3_ld_ecc_info),                                
  .lsda_ex3_ecc_info_update                    (lsda_ex3_ld_ecc_info_update),                                 
  .lsda_ex3_ecc_info_update_gate               (lsda_ex3_ld_ecc_info_update_gate),                                
  .lsda_ex3_ecc_pa                             (lsda_ex3_ld_ecc_pa),                                
  .lsda_ex3_ecc_wakeup                         (lsda_ex3_ld_ecc_wakeup),                                
  .lsda_ex3_element_cnt                        (lsda_ex3_ld_element_cnt),                                 
  .lsda_ex3_element_size                       (lsda_ex3_element_size),                                
  .lsda_ex3_fwd_ecc_stall                      (lsda_ex3_fwd_ecc_stall),                                 
  .lsda_icc_read_data                          (lsda_icc_read_data),                             
  .lsda_idu_ex3_already_da                     (lsda_idu_ex3_ld_already_da),                                                              
  .lsda_idu_ex3_boundary_gateclk_en            (lsda_idu_ex3_ld_boundary_gateclk_en),                                 
  .lsda_idu_ex3_pop_entry                      (lsda_idu_ex3_ld_pop_entry),                                 
  .lsda_idu_ex3_pop_vld                        (lsda_idu_ex3_ld_pop_vld),                                 
  .lsda_idu_ex3_rb_full                        (lsda_idu_ex3_ld_rb_full),                                 
  .lsda_idu_ex3_secd                           (lsda_idu_ex3_ld_secd),                                
  .lsda_idu_ex3_us_restart                     (lsda_idu_ex3_us_restart),
  .lsda_idu_ex3_spec_fail                      (lsda_idu_ex3_ld_spec_fail),                                 
  .lsda_idu_ex3_wait_fence                     (lsda_idu_ex3_ld_wait_fence),                                
  .lsda_ex3_idx                                (lsda_ex3_idx),                                 
  .lsda_ex3_iid                                (lsda_ex3_ld_iid),                                 
  .lsda_ex3_inst_fof                           (lsda_ex3_inst_fof),                                
  .lsda_ex3_inst_size                          (lsda_ex3_ld_inst_size),                                 
  .lsda_ex3_inst_vfls                          (lsda_ex3_inst_vfls),                                 
  .lsda_ex3_inst_vld                           (lsda_ex3_ld_inst_vld),                                
  .lsda_ex3_inst_vls                           (lsda_ex3_inst_vls),                                
  .lsda_ex3_ldfifo_pc                          (lsda_ex3_ldfifo_pc),                                 
  .lsda_lfb_discard_grnt                       (lsda_lfb_discard_grnt),                            
  .lsda_lfb_set_wakeup_queue                   (lsda_lfb_set_wakeup_queue),                            
  .lsda_lfb_set_wakeup_queue_gate              (lsda_lfb_set_wakeup_queue_gate),                             
  .lsda_lfb_wakeup_queue_next                  (lsda_lfb_wakeup_queue_next),                             
  .lsda_lm_ex3_discard_grnt                    (lsda_lm_ex3_discard_grnt),                                 
  .lsda_lm_ex3_ecc_err                         (lsda_lm_ex3_ld_ecc_err),                                
  .lsda_lm_ex3_lr_no_restart                   (lsda_lm_ex3_lr_no_restart),                                
  .lsda_lm_ex3_lr_no_restart_dp                (lsda_lm_ex3_lr_no_restart_dp),                                 
  .lsda_lm_ex3_no_req                          (lsda_lm_ex3_no_req),                                 
  .lsda_lm_ex3_vector_nop                      (lsda_lm_ex3_vector_nop),                                 
  .lsda_ex3_lq_entry_pop                       (lsda_ex3_lq_entry_pop),                                
  .lsda_ex3_lsid                               (lsda_ex3_lsid),                                
  .lsda_mcic_borrow_mmu                        (lsda_mcic_borrow_mmu),                             
  .lsda_mcic_borrow_mmu_req                    (lsda_mcic_borrow_mmu_req),                             
  .lsda_mcic_bypass_data                       (lsda_mcic_bypass_data),                            
  .lsda_mcic_data_err                          (lsda_mcic_data_err),                             
  .lsda_mcic_rb_full                           (lsda_mcic_rb_full),                            
  .lsda_mcic_wakeup                            (lsda_mcic_wakeup),                             
  .lsda_ex3_old                                (lsda_ex3_ld_old),                                 
  .lsda_ex3_page_buf                           (lsda_ex3_ld_page_buf),                                
  .lsda_ex3_page_ca                            (lsda_ex3_ld_page_ca),                                 
  .lsda_ex3_page_sec                           (lsda_ex3_ld_page_sec),                                
  .lsda_ex3_page_sec_ff                        (lsda_ex3_ld_page_sec_ff),                                 
  .lsda_ex3_page_share                         (lsda_ex3_ld_page_share),                                
  .lsda_ex3_page_share_ff                      (lsda_ex3_ld_page_share_ff),                                 
  .lsda_ex3_page_so                            (lsda_ex3_ld_page_so),                                 
  .lsda_pfu_ex3_awk_dp_vld                     (lsda_pfu_ex3_ld_awk_dp_vld),                                
  .lsda_pfu_ex3_awk_vld                        (lsda_pfu_ex3_ld_awk_vld),                                 
  .lsda_pfu_ex3_biu_req_hit_idx                (lsda_pfu_ex3_ld_biu_req_hit_idx),                                 
  .lsda_pfu_ex3_eviwk_cnt_vld                  (lsda_pfu_ex3_ld_eviwk_cnt_vld),                                 
  .lsda_pfu_ex3_pf_inst_vld                    (lsda_pfu_ex3_ld_pf_inst_vld),                                 
  .lsda_pfu_ex3_va                             (lsda_pfu_ex3_va),                                
  .lsda_pfu_ex3_ppfu_va                        (lsda_pfu_ex3_ld_ppfu_va),                                     
  .lsda_pfu_ex3_ppn_ff                         (lsda_pfu_ex3_ld_ppn_ff),                                    
  .lsda_ex3_preg                               (lsda_ex3_preg),                                
  .lsda_ex3_preg_sign_sel                      (lsda_ex3_preg_sign_sel),                                 
  .lsda_rb_ex3_atomic                          (lsda_rb_ex3_atomic),                                 
  .lsda_rb_ex3_cmit                            (lsda_rb_ex3_ld_cmit),                                 
  .lsda_rb_ex3_cmplt_success                   (lsda_rb_ex3_cmplt_success),                                
  .lsda_rb_ex3_create_dp_vld                   (lsda_rb_ex3_ld_create_dp_vld),                                
  .lsda_rb_ex3_create_gateclk_en               (lsda_rb_ex3_ld_create_gateclk_en),                                
  .lsda_rb_ex3_create_judge_vld                (lsda_rb_ex3_ld_create_judge_vld),                                 
  .lsda_rb_ex3_create_lfb                      (lsda_rb_ex3_ld_create_lfb),                                 
  .lsda_rb_ex3_create_vld                      (lsda_rb_ex3_ld_create_vld),                                 
  .lsda_rb_ex3_data_ori                        (lsda_rb_ex3_data_ori),                                 
  .lsda_rb_ex3_data_ori1                       (lsda_rb_ex3_data_ori1),
  .lsda_rb_ex3_data_ori2                       (lsda_rb_ex3_data_ori2),
  .lsda_rb_ex3_data_ori3                       (lsda_rb_ex3_data_ori3),
  .lsda_rb_ex3_data_vld                        (lsda_rb_ex3_data_vld),                                 
  .lsda_rb_ex3_dest_vld                        (lsda_rb_ex3_dest_vld),                                 
  .lsda_rb_ex3_discard_grnt                    (lsda_rb_ex3_discard_grnt),                                 
  .lsda_rb_ex3_expt_vld                        (lsda_rb_ex3_expt_vld),                                 
  .lsda_ex3_rb_full_gateclk_en                 (lsda_ex3_ld_rb_full_gateclk_en),                                
  .lsda_rb_ex3_ldamo                           (lsda_rb_ex3_ldamo),                                
  .lsda_rb_ex3_merge_dp_vld                    (lsda_rb_ex3_merge_dp_vld),                                 
  .lsda_rb_ex3_merge_expt_vld                  (lsda_rb_ex3_merge_expt_vld),                                 
  .lsda_rb_ex3_merge_gateclk_en                (lsda_rb_ex3_merge_gateclk_en),                                 
  .lsda_rb_ex3_merge_vld                       (lsda_rb_ex3_merge_vld),                                
  .lsda_ex3_reg_bytes_vld                      (lsda_ex3_reg_bytes_vld),                                 
  .lsda_ex3_reg_bytes_vld1                     (lsda_ex3_reg_bytes_vld1),                                 
  .lsda_ex3_reg_bytes_vld2                     (lsda_ex3_reg_bytes_vld2),                                 
  .lsda_ex3_reg_bytes_vld3                     (lsda_ex3_reg_bytes_vld3),                                 
  .lsda_ex3_inst_us                            (lsda_ex3_inst_us),
  .lsda_ex3_setvl_val                          (lsda_ex3_setvl_val),                                 
  .lsda_sf_ex3_addr_tto4                       (lsda_sf_ex3_ld_addr_tto4),                                
  .lsda_sf_ex3_bytes_vld                       (lsda_sf_ex3_ld_bytes_vld),                                
  .lsda_sf_ex3_iid                             (lsda_sf_ex3_ld_iid),                                
  .lsda_sf_ex3_no_spec_miss                    (lsda_sf_ex3_ld_no_spec_miss),                                 
  .lsda_sf_ex3_no_spec_miss_gate               (lsda_sf_ex3_ld_no_spec_miss_gate),                                
  .lsda_sf_ex3_spec_chk_req                    (lsda_sf_ex3_ld_spec_chk_req), // wjh@sfp
  .lsda_sfp_ex3_src_pc                         (lsda_sfp_ex3_ld_src_pc), // wjh@sfp
  .lsda_ex3_sign_extend                        (lsda_ex3_sign_extend),                                 
  .lsda_snq_ex3_borrow_icc                     (lsda_snq_ex3_borrow_icc),                                
  .lsda_snq_ex3_borrow_sndb                    (lsda_snq_ex3_borrow_sndb),                                 
  .lsda_ex3_special_gateclk_en                 (lsda_ex3_special_gateclk_en),                                
  .lsda_ex3_split                              (lsda_ex3_split),                                 
  .lsda_sq_ex3_data_discard_vld                (lsda_sq_ex3_data_discard_vld),                                 
  .lsda_sq_ex3_fwd_id                          (lsda_sq_ex3_fwd_id),                                 
  .lsda_sq_ex3_fwd_multi_vld                   (lsda_sq_ex3_fwd_multi_vld),                                
  .lsda_sq_ex3_global_discard_vld              (lsda_sq_ex3_global_discard_vld),                                 
  .selfda_lsda_ex3_hit_idx                     (selfda_lsda_ex3_ld_hit_idx),                                 
  .lsda_ex3_tag_inj_mask                       (lsda_ex3_ld_tag_inj_mask),                                     
  .lsda_vb_ex3_borrow_vb                       (lsda_vb_ex3_borrow_vb),                                
  .lsda_vb_ex3_snq_data_reissue                (lsda_vb_ex3_snq_data_reissue),                                 
  .lsda_vb_ex3_snq_ecc_err                     (lsda_vb_ex3_snq_ecc_err),                                
  .lsda_ex3_vlmul                              (lsda_ex3_vlmul),                                 
  .lsda_ex3_vmb_id                             (lsda_ex3_vmb_id),                                
  .lsda_ex3_vmb_merge_vld                      (lsda_ex3_vmb_merge_vld),                                 
  .lsda_ex3_vreg                               (lsda_ex3_vreg),                                
  .lsda_ex3_vreg_sign_sel                      (lsda_ex3_vreg_sign_sel),                                 
  //.lsda_ex3_vsew                               (lsda_ex3_vsew),     //rvv1.0 @hcl 
  .lsda_ex3_vmew                               (lsda_ex3_vmew),     //rvv1.0 @hcl 
  .lsda_ex3_vmop                               (lsda_ex3_vmop),     //rvv1.0 @hcl 
  .lsda_ex3_wait_fence_gateclk_en              (lsda_ex3_ld_wait_fence_gateclk_en),                                 
  .lsda_lswb_ex3_cmplt_req                     (lsda_lswb_ex3_ld_cmplt_req),                                  
  .lsda_lswb_ex3_cmplt_req_gate                (lsda_lswb_ex3_cmplt_req_gate),                                   
  .lsda_lswb_ex3_data                          (lsda_lswb_ex3_data),                                   
  .lsda_lswb_ex3_data1                         (lsda_lswb_ex3_data1),                                   
  .lsda_lswb_ex3_data2                         (lsda_lswb_ex3_data2),                                   
  .lsda_lswb_ex3_data3                         (lsda_lswb_ex3_data3),                                   
  .lsda_lswb_ex3_data_req                      (lsda_lswb_ex3_data_req),                                   
  .lsda_lswb_ex3_data_req_dp                   (lsda_lswb_ex3_data_req_dp),                                  
  .lsda_lswb_ex3_data_req_gateclk_en           (lsda_lswb_ex3_data_req_gateclk_en),                                  
  .lsda_lswb_ex3_expt_vec                      (lsda_lswb_ex3_ld_expt_vec),                                   
  .lsda_ex3_expt_vld                           (lsda_ex3_ld_expt_vld),                             
  .lsda_lswb_ex3_inst_vls                      (lsda_lswb_ex3_inst_vls),                                   
  .lsda_lswb_ex3_mt_value                      (lsda_lswb_ex3_ld_mt_value),                                   
  .lsda_lswb_ex3_no_spec_hit                   (lsda_lswb_ex3_ld_no_spec_hit),                                  
  .lsda_lswb_ex3_no_spec_mispred               (lsda_lswb_ex3_ld_no_spec_mispred),                                  
  .lsda_lswb_ex3_no_spec_miss                  (lsda_lswb_ex3_ld_no_spec_miss),                                   
  .lsda_lswb_ex3_no_spec_target                (lsda_lswb_ex3_ld_no_spec_target),                                   
  .lsda_lswb_ex3_spec_fail                     (lsda_lswb_ex3_ld_spec_fail),                                  
  .lsda_lswb_ex3_vreg_sign_sel                 (lsda_lswb_ex3_vreg_sign_sel),                                  
  .lsda_lswb_ex3_vsetvl                        (lsda_lswb_ex3_vsetvl),                                   
  .lsda_lswb_ex3_vstart_vld                    (lsda_lswb_ex3_ld_vstart_vld),                                   
  .lsda_wmb_data_reissue                       (lsda_wmb_data_reissue),                            
  .lsda_wmb_discard_vld                        (lsda_wmb_discard_vld),                             
  .lsda_wmb_read_data                          (lsda_wmb_read_data),                             
  .lsda_wmb_two_bit_err                        (lsda_wmb_two_bit_err),                             
  .lsu_hpcp_ls_cache_access                    (lsu_hpcp_ld_cache_access),                              
  .lsu_hpcp_ls_cache_miss                      (lsu_hpcp_ld_cache_miss),                              
  .lsu_hpcp_ld_data_discard                    (lsu_hpcp_ld_data_discard),                              
  .lsu_hpcp_ld_discard_sq                      (lsu_hpcp_ld_discard_sq),                              
  .lsu_hpcp_ls_unalign_inst                    (lsu_hpcp_ld_unalign_inst),                              
  .lsu_idu_ex3_fwd_preg                        (lsu_idu_ex3_fwd_preg),                         
  .lsu_idu_ex3_fwd_preg_data                   (lsu_idu_ex3_fwd_preg_data),                        
  .lsu_idu_ex3_fwd_preg_vld                    (lsu_idu_ex3_fwd_preg_vld),                         
  .lsu_idu_ex3_fwd_vreg                        (lsu_idu_ex3_fwd_vreg),                         
  .lsu_idu_ex3_fwd_vreg_fr_data                (lsu_idu_ex3_fwd_vreg_fr_data),                         
  .lsu_idu_ex3_fwd_vreg_vld                    (lsu_idu_ex3_fwd_vreg_vld),                         
  .lsu_idu_ex3_fwd_vreg_vr0_data               (lsu_idu_ex3_fwd_vreg_vr0_data),                        
  .lsu_idu_ex3_fwd_vreg_vr1_data               (lsu_idu_ex3_fwd_vreg_vr1_data),                        
  .lsda_idu_ex3_wait_old                       (lsda_idu_ex3_wait_old),                            
  .lsda_idu_ex3_wait_old_gateclk_en            (lsda_idu_ex3_wait_old_gateclk_en),                           
  .lsu_lsda_data_inj_cmplt                     (lsu_lsda_data_inj_cmplt),                               
  .lsu_lsda_tag_inj_cmplt                      (lsu_lsda_ld_tag_inj_cmplt),                                
  .lsu_rtu_ex3_ssf_iid                         (lsu_rtu_ex3_ld_ssf_iid),             
  .lsu_rtu_ex3_ssf_vld                         (lsu_rtu_ex3_ld_ssf_vld),
  .ld_da_ecc_stall                             (ld_da_ecc_stall),
  .lsda_pfu_ld_tag_miss                        (lsda_pfu_ld_tag_miss),
//==========================================================
//                  Risc-V Debug zdb Begin (xx_lsu_ls_ld_da)
//==========================================================
  //input
  .dtu_lsu_data_trig_en                        (dtu_lsu_data_trig_en),
  .dtu_lsu_addr_halt_info                      (dtu_lsu_addr_halt_info),
  .ld_dc_boundary_unmask                       (ls_dc_boundary_unmask),
  //output
  .ld_da_dtu_addr_halt_info_stall_vld          (ld_da_dtu_addr_halt_info_stall_vld),
  .ld_da_halt_info_am                          (ls_da_halt_info_am),
  .ld_da_idu_halt_info                         (ld_da_idu_halt_info),
  .ld_da_idu_halt_info_update_vld              (ld_da_idu_halt_info_update_vld),
  .ld_da_rb_data_check                         (ls_da_rb_data_check)
//==========================================================
//                  Risc-V Debug zdb End   (xx_lsu_ls_ld_da)
//==========================================================                                     
);

assign dcache_lsu_st_tag_dout = { dcache_lsda_ex2_tag_dout[`WK_LS_DCACHE_SINGLE_TAG_WIDTH+`WK_LS_DCACHE_TRIPLE_LDTAG_WIDTH-1:`WK_LS_DCACHE_TRIPLE_LDTAG_WIDTH],
                                  dcache_lsda_ex2_tag_dout[`WK_LS_DCACHE_SINGLE_TAG_WIDTH+`WK_LS_DCACHE_DOUBLE_LDTAG_WIDTH-1:`WK_LS_DCACHE_DOUBLE_LDTAG_WIDTH],
                                  dcache_lsda_ex2_tag_dout[`WK_LS_DCACHE_SINGLE_TAG_WIDTH+`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH],
                                  dcache_lsda_ex2_tag_dout[`WK_LS_DCACHE_SINGLE_TAG_WIDTH-1:0]};  

xx_lsu_ls_st_da #(
.IID_WIDTH      (IID_WIDTH  ),
.LSIQ_ENTRY     (LSIQ_ENTRY ),
.SNQ_ENTRY      (SNQ_ENTRY  ),
.WK_PA_WIDTH    (`WK_PA_WIDTH),
.PC_LEN         (PC_LEN     )
)
x_xx_lsu_ls_st_da (
  .amr_wa_cancel                                 (amr_wa_cancel),                             
  .cp0_lsu_dcache_en                             (cp0_lsu_dcache_en),                             
  .cp0_lsu_ecc_en                                (cp0_lsu_ecc_en),                              
  .cp0_lsu_icg_en                                (cp0_lsu_icg_en),                              
  .cp0_lsu_l2_st_pref_en                         (cp0_lsu_l2_st_pref_en),                             
  .cp0_lsu_nsfe                                  (cp0_lsu_nsfe),                              
  .cp0_lsu_tag_ecc_inj                           (cp0_lsu_tag_ecc_inj),                             
  .cp0_lsu_tag_random1                           (cp0_lsu_tag_random1),                             
  .cp0_lsu_vstart                                (cp0_lsu_vstart),                              
  .cpurst_b                                      (cpurst_b),                              
  .ctrl_st_clk                                   (ctrl_st_clk),                             
  .dcache_dirty_din                              (dcache_dirty_din),                              
  .dcache_dirty_gwen                             (dcache_dirty_gwen),                             
  .dcache_dirty_wen                              (dcache_dirty_wen),                              
  .dcache_idx                                    (dcache_idx),                              
  .dcache_lsu_st_dirty_dout                      (dcache_lsu_st_dirty_dout),                              
  .dcache_lsu_st_tag_dout                        (dcache_lsu_st_tag_dout),                              
  .dcache_tag_din                                (dcache_tag_din),                              
  .dcache_tag_gwen                               (dcache_tag_gwen),                             
  .dcache_tag_wen                                (dcache_tag_wen),
  .lsda_ex2_replace_way                          (lsda_ex2_replace_way),   
  .forever_cpuclk                                (forever_cpuclk),                              
  .ld_da_ecc_stall                               (ld_da_ecc_stall),  //st_ecc_stall should contain ld_ecc_stall, LTL@20250213    
  .lda0_lsda_ex3_hit_idx                         (lda0_lsda_ex3_hit_idx),               
  .lsda_lsda_ex3_hit_idx                         (lsda_lsda_ex3_hit_idx),               
  .lsda_lsda_ex3_is_load                         (lsda_lsda_ex3_is_load),               
  .lsda_lsda_ex3_iid                             (lsda_lsda_ex3_iid),               
  .lda0_lsda_ex3_tag_inj_mask                    (lda0_lsda_ex3_tag_inj_mask),                                         
  .lsda_lsda_ex3_tag_inj_mask                    (lsda_lsda_ex3_tag_inj_mask),                      
  .lfb_lsda_ex3_hit_idx                          (lfb_lsda_ex3_hit_idx),                                 
  .lm_lsda_ex3_hit_idx                           (lm_lsda_ex3_hit_idx),                                
  .lsu_has_fence                                 (lsu_has_fence),                             
  .mmu_lsu_access_fault                          (mmu_lsu_access_fault),                             
  .pad_yy_icg_scan_en                            (pad_yy_icg_scan_en),                              
  .pfu_biu_req_addr                              (pfu_biu_req_addr),                              
  .rb_lsda_ex3_full                              (rb_lsda_ex3_full),                                 
  .rb_lsda_ex3_hit_idx                           (rb_lsda_ex3_hit_idx[0]),                                
  .rtu_lsu_flush_fe                              (rtu_lsu_flush_fe),                              
  .rtu_ck_flush                                  (rtu_ck_flush),
  .rtu_ck_flush_iid                              (rtu_ck_flush_iid),
  .rtu_yy_xx_commit0                             (rtu_yy_xx_commit0),                             
  .rtu_yy_xx_commit0_iid                         (rtu_yy_xx_commit0_iid),                             
  .rtu_yy_xx_commit1                             (rtu_yy_xx_commit1),                             
  .rtu_yy_xx_commit1_iid                         (rtu_yy_xx_commit1_iid),                             
  .rtu_yy_xx_commit2                             (rtu_yy_xx_commit2),                             
  .rtu_yy_xx_commit2_iid                         (rtu_yy_xx_commit2_iid),              
  .rtu_yy_xx_commit3                             (rtu_yy_xx_commit3),                             
  .rtu_yy_xx_commit3_iid                         (rtu_yy_xx_commit3_iid),                             
  .rtu_yy_xx_commit4                             (rtu_yy_xx_commit4),                             
  .rtu_yy_xx_commit4_iid                         (rtu_yy_xx_commit4_iid),                             
  .rtu_yy_xx_commit5                             (rtu_yy_xx_commit5),                             
  .rtu_yy_xx_commit5_iid                         (rtu_yy_xx_commit5_iid),              
  .rtu_yy_xx_commit6                             (rtu_yy_xx_commit6),                             
  .rtu_yy_xx_commit6_iid                         (rtu_yy_xx_commit6_iid),                             
  .rtu_yy_xx_commit7                             (rtu_yy_xx_commit7),                             
  .rtu_yy_xx_commit7_iid                         (rtu_yy_xx_commit7_iid),
  .lsdc_ex2_is_load                              (lsdc_ex2_is_load),                         
  .lsdc_ex2_addr0                                (lsdc_ex2_addr0),                                 
  .lsdc_lsda_ex2_already_da                      (lsdc_lsda_ex2_already_da),                                      
  .lsdc_ex2_atomic                               (lsdc_ex2_atomic),                                                                    
  .lsdc_lsda_ex2_borrow_dcache_replace           (lsdc_lsda_ex2_borrow_dcache_replace),                                     
  .lsdc_lsda_ex2_borrow_dcache_sw                (lsdc_lsda_ex2_borrow_dcache_sw),                                      
  .lsdc_lsda_ex2_borrow_icc                      (lsdc_lsda_ex2_borrow_icc),                                      
  .lsdc_lsda_ex2_borrow_snq                      (lsdc_lsda_ex2_borrow_snq),                                      
  .lsdc_lsda_ex2_borrow_snq_id                   (lsdc_lsda_ex2_borrow_snq_id),                                     
  .lsdc_ex2_borrow_vld                           (lsdc_lsda_ex2_borrow_vld),                                
  .lsdc_ex2_boundary                             (lsdc_ex2_boundary),                                
  .lsdc_ex2_bytes_vld                            (lsdc_ex2_bytes_vld),                                 
  .lsdc_lsda_ex2_dcache_dirty_array              (lsdc_lsda_ex2_dcache_dirty_array),                                   
  .lsdc_lsda_ex2_dcache_tag_array                (lsdc_lsda_ex2_dcache_tag_array),                                   
  .lsdc_lsda_ex2_expt_vld_gate_en                (lsdc_lsda_ex2_expt_vld_gate_en),                                   
  .lsdc_lsda_ex2_inst_vld                        (lsdc_lsda_ex2_st_inst_vld),                                   
  .lsdc_ex2_page_buf                             (lsdc_ex2_page_buf),                             
  .lsdc_ex2_page_ca                              (lsdc_ex2_page_ca),                              
  .lsdc_ex2_page_sec                             (lsdc_ex2_page_sec),                             
  .lsdc_ex2_page_share                           (lsdc_ex2_page_share),                             
  .lsdc_ex2_page_so                              (lsdc_ex2_page_so),                              
  .lsdc_ex2_page_wa                              (lsdc_ex2_page_wa),                              
  .lsdc_lsda_ex2_staddr_vld                      (lsdc_lsda_ex2_staddr_vld),                                   
  .lsdc_lsda_ex2_tag0_hit                        (lsdc_lsda_ex2_tag0_hit),                                   
  .lsdc_lsda_ex2_tag1_hit                        (lsdc_lsda_ex2_tag1_hit),                                   
  .lsdc_lsda_ex2_tag2_hit                        (lsdc_lsda_ex2_tag2_hit),                                   
  .lsdc_lsda_ex2_tag3_hit                        (lsdc_lsda_ex2_tag3_hit),
  .lsdc_lsda_ex2_dcwp_hit_idx                    (lsdc_lsda_ex2_dcwp_hit_idx),                                      
  .lsdc_lsda_ex2_element_cnt                     (lsdc_lsda_ex2_element_cnt),                                     
  .lsdc_lsda_ex2_expt_access_fault_extra         (lsdc_lsda_ex2_expt_access_fault_extra),                                     
  .lsdc_lsda_ex2_expt_access_fault_mask          (lsdc_lsda_ex2_expt_access_fault_mask),                                      
  .lsdc_lsda_ex2_expt_vec                        (lsdc_lsda_ex2_expt_vec),                                      
  .lsdc_lsda_ex2_expt_vld_except_access_err      (lsdc_lsda_ex2_expt_vld_except_access_err),                                      
  .lsdc_ex2_fence_mode                           (lsdc_ex2_fence_mode),                                
  .lsdc_lsda_ex2_get_dcache_tag_dirty            (lsdc_lsda_ex2_get_dcache_tag_dirty),                                      
  .lsdc_ex2_icc                                  (lsdc_ex2_icc),                                 
  .lsdc_ex2_iid                                  (lsdc_ex2_st_iid),//logic leves opt@LTL                                 
  .lsdc_ex2_inst_mode                            (lsdc_ex2_inst_mode),                                 
  .lsdc_ex2_inst_size                            (lsdc_ex2_inst_size),                                 
  .lsdc_ex2_inst_type                            (lsdc_ex2_inst_type),                                 
  .lsdc_ex2_inst_vld                             (lsdc_ex2_st_inst_vld),                                
  .lsdc_ex2_inst_vls                             (lsdc_ex2_inst_vls),                                
  .lsdc_lsda_ex2_lsid                            (lsdc_lsda_ex2_lsid),                                      
  .lsdc_lsda_ex2_mmu_req                         (lsdc_lsda_ex2_mmu_req),                                     
  .lsdc_lsda_ex2_mt_value                        (lsdc_lsda_ex2_mt_value),                                      
  .lsdc_lsda_ex2_no_spec                         (lsdc_lsda_ex2_no_spec),                                     
  .lsdc_ex2_old                                  (lsdc_ex2_old),                                 
  .lsdc_lsda_ex2_pc                              (lsdc_lsda_ex2_pc),                                      
  .lsdc_lsda_ex2_pf_inst                         (lsdc_lsda_ex2_pf_inst),                                     
  .lsdc_lsda_ex2_pfu_va                          (lsdc_lsda_ex2_pfu_va),                                      
  .lsdc_ex2_secd                                 (lsdc_ex2_st_secd),                                
  .lsdc_lsda_ex2_spec_fail                       (lsdc_lsda_ex2_spec_fail),                                     
  .lq_lsu_ex2_spec_fail_pc                       (lq_lsu_ex2_spec_fail_pc), // wjh@sfp
  .lsdc_lsda_ex2_split                           (lsdc_lsda_ex2_split),                                     
  .lsdc_lsda_ex2_st                              (lsdc_lsda_ex2_st),                                      
  .lsdc_lsda_ex2_sync_fence                      (lsdc_lsda_ex2_sync_fence),  
  .lsdc_lsda_ex2_tag_inj_dp                      (lsdc_lsda_ex2_tag_inj_dp),                                                                  
  .lsdc_ex2_vector_nop                           (lsdc_ex2_vector_nop), 
  .lsda_selfda_ex3_addr                          (lsda_selfda_ex3_addr),//new add for st-st rb create_hit_idx, LTL@20241120  
  .selfda_lsda_ex3_hit_idx                       (selfda_lsda_ex3_st_hit_idx),//new add for st-st rb create_hit_idx, LTL@20241120                                    
  .lsu_hpcp_ls_cache_access                      (lsu_hpcp_st_cache_access),                              
  .lsu_hpcp_ls_cache_miss                        (lsu_hpcp_st_cache_miss),                              
  .lsu_hpcp_ls_unalign_inst                      (lsu_hpcp_st_unalign_inst),                              
  .lsu_rtu_ex3_ssf_iid                           (lsu_rtu_ex3_st_ssf_iid),             
  .lsu_rtu_ex3_ssf_vld                           (lsu_rtu_ex3_st_ssf_vld),             
  .lsu_lsda_tag_inj_cmplt                        (lsu_lsda_st_tag_inj_cmplt), 
  .lsda_ex3_is_load                              (lsda_ex3_is_load1),                          
  .lsda_ex3_addr                                 (lsda_ex3_st_addr),                                                              
  .lsda_ex3_borrow_icc_vld                       (lsda_ex3_borrow_icc_vld),                                
  .lsda_ex3_borrow_vld                           (lsda_ex3_st_borrow_vld),                                
  .lsda_vb_ex3_dcache_dirty                      (lsda_vb_ex3_dcache_dirty),                                    
  .lsda_ex3_dcache_hit                           (lsda_ex3_st_dcache_hit),                                
  .lsda_vb_ex3_dcache_miss                       (lsda_vb_ex3_dcache_miss),                                   
  .lsda_vb_ex3_dcache_page_share                 (lsda_vb_ex3_dcache_page_share),                                   
  .lsda_vb_ex3_dcache_replace_dirty              (lsda_vb_ex3_dcache_replace_dirty),                                    
  .lsda_vb_ex3_dcache_replace_page_share         (lsda_vb_ex3_dcache_replace_page_share),                                   
  .lsda_vb_ex3_dcache_replace_valid              (lsda_vb_ex3_dcache_replace_valid),                                    
  .lsda_vb_ex3_dcache_replace_way                (lsda_vb_ex3_dcache_replace_way),                                    
  .lsda_vb_ex3_dcache_way                        (lsda_vb_ex3_dcache_way),                                    
  .lsda_ex3_ecc_info                             (lsda_ex3_st_ecc_info),                                
  .lsda_ex3_ecc_info_update                      (lsda_ex3_st_ecc_info_update),                                 
  .lsda_ex3_ecc_info_update_gate                 (lsda_ex3_st_ecc_info_update_gate),                                
  .lsda_ex3_ecc_pa                               (lsda_ex3_st_ecc_pa),                                
  .lsda_ex3_ecc_wakeup                           (lsda_ex3_st_ecc_wakeup),                                
  .lsda_lswb_ex3_element_cnt                     (lsda_ex3_st_element_cnt),                                     
  .lsda_ex3_fence_inst                           (lsda_ex3_fence_inst),                                
  .lsda_ex3_fence_mode                           (lsda_ex3_fence_mode),                                
  .lsda_icc_ex3_dirty_info                       (lsda_icc_ex3_dirty_info),                                
  .lsda_icc_ex3_ecc_info                         (lsda_icc_ex3_ecc_info),                                
  .lsda_icc_ex3_tag_info                         (lsda_icc_ex3_tag_info),                                
  .lsda_idu_ex3_already_da                       (lsda_idu_ex3_st_already_da),                                                              
  .lsda_idu_ex3_boundary_gateclk_en              (lsda_idu_ex3_st_boundary_gateclk_en),                                 
  .lsda_idu_ex3_pop_entry                        (lsda_idu_ex3_st_pop_entry),                                 
  .lsda_idu_ex3_pop_vld                          (lsda_idu_ex3_st_pop_vld),                                 
  .lsda_idu_ex3_rb_full                          (lsda_idu_ex3_st_rb_full),                                 
  .lsda_idu_ex3_secd                             (lsda_idu_ex3_st_secd),                                
  .lsda_idu_ex3_spec_fail                        (lsda_idu_ex3_st_spec_fail),                                 
  .lsda_idu_ex3_wait_fence                       (lsda_idu_ex3_st_wait_fence),                                
  .lsda_ex3_iid                                  (lsda_ex3_st_iid),        
  .lsda_ex3_inst_size                            (lsda_ex3_st_inst_size),                                 
  .lsda_ex3_inst_vld                             (lsda_ex3_st_inst_vld),                                
  .lsda_ex3_tag_inj_mask                         (lsda_ex3_st_tag_inj_mask),                                   
  .lsda_lm_ex3_ecc_err                           (lsda_lm_ex3_st_ecc_err),                                
  .lsda_ex3_old                                  (lsda_ex3_st_old),                                 
  .lsda_ex3_page_buf                             (lsda_ex3_st_page_buf),                                
  .lsda_ex3_page_ca                              (lsda_ex3_st_page_ca),                                 
  .lsda_ex3_page_sec                             (lsda_ex3_st_page_sec),                                
  .lsda_ex3_page_sec_ff                          (lsda_ex3_st_page_sec_ff),                                 
  .lsda_ex3_page_share                           (lsda_ex3_st_page_share),                                
  .lsda_ex3_page_share_ff                        (lsda_ex3_st_page_share_ff),                                 
  .lsda_ex3_page_so                              (lsda_ex3_st_page_so),                                 
  .lsda_pfu_ex3_pc                               (lsda_pfu_ex3_pc),                                    
  .lsda_pfu_ex3_awk_dp_vld                       (lsda_pfu_ex3_st_awk_dp_vld),                                
  .lsda_pfu_ex3_awk_vld                          (lsda_pfu_ex3_st_awk_vld),                                 
  .lsda_pfu_ex3_biu_req_hit_idx                  (lsda_pfu_ex3_st_biu_req_hit_idx),                                 
  .lsda_pfu_ex3_eviwk_cnt_vld                    (lsda_pfu_ex3_st_eviwk_cnt_vld),                                 
  .lsda_pfu_ex3_pf_inst_vld                      (lsda_pfu_ex3_st_pf_inst_vld),                                 
  .lsda_pfu_ex3_ppfu_va                          (lsda_pfu_ex3_st_ppfu_va),                                     
  .lsda_pfu_ex3_ppn_ff                           (lsda_pfu_ex3_st_ppn_ff),                                    
  .lsda_rb_ex3_cmit                              (lsda_rb_ex3_st_cmit),                                 
  .lsda_rb_ex3_create_dp_vld                     (lsda_rb_ex3_st_create_dp_vld),                                
  .lsda_rb_ex3_create_gateclk_en                 (lsda_rb_ex3_st_create_gateclk_en),
  .lsda_rb_ex3_create_judge_vld                  (lsda_rb_ex3_st_create_judge_vld),                 
  .lsda_rb_ex3_create_lfb                        (lsda_rb_ex3_st_create_lfb),                                 
  .lsda_rb_ex3_create_vld                        (lsda_rb_ex3_st_create_vld),                                 
  .lsda_ex3_rb_full_gateclk_en                   (lsda_ex3_st_rb_full_gateclk_en),                                
  .lsda_sq_ex3_secd                              (lsda_sq_ex3_secd),                                    
  .lsda_sf_ex3_addr_tto4                         (lsda_sf_ex3_st_addr_tto4),                                
  .lsda_sf_ex3_bytes_vld                         (lsda_sf_ex3_st_bytes_vld),                                
  .lsda_sf_ex3_iid                               (lsda_sf_ex3_st_iid),                                
  .lsda_sf_ex3_no_spec_miss                      (lsda_sf_ex3_st_no_spec_miss),                                 
  .lsda_sf_ex3_no_spec_miss_gate                 (lsda_sf_ex3_st_no_spec_miss_gate),                                
  .lsda_sf_ex3_spec_chk_req                      (lsda_sf_ex3_st_spec_chk_req), // wjh@sfp
  .lsda_sfp_ex3_src_pc                           (lsda_sfp_ex3_st_src_pc), // wjh@sfp
  .lsda_snq_ex3_borrow_snq                       (lsda_snq_ex3_borrow_snq),                                
  .lsda_snq_ex3_dcache_dirty                     (lsda_snq_ex3_dcache_dirty),                                
  .lsda_snq_ex3_dcache_page_share                (lsda_snq_ex3_dcache_page_share),                                 
  .lsda_snq_ex3_dcache_share                     (lsda_snq_ex3_dcache_share),                                
  .lsda_snq_ex3_dcache_valid                     (lsda_snq_ex3_dcache_valid),                                
  .lsda_snq_ex3_dcache_way                       (lsda_snq_ex3_dcache_way),                                
  .lsda_snq_ex3_ecc_err                          (lsda_snq_ex3_ecc_err),                                 
  .lsda_snq_ex3_entry_tag_reissue                (lsda_snq_ex3_entry_tag_reissue),                                 
  .lsda_sq_ex3_dcache_dirty                      (lsda_sq_ex3_dcache_dirty),                                 
  .lsda_sq_ex3_dcache_page_share                 (lsda_sq_ex3_dcache_page_share),                                
  .lsda_sq_ex3_dcache_share                      (lsda_sq_ex3_dcache_share),                                 
  .lsda_sq_ex3_dcache_valid                      (lsda_sq_ex3_dcache_valid),                                 
  .lsda_sq_ex3_dcache_way                        (lsda_sq_ex3_dcache_way),                                 
  .lsda_sq_ex3_ecc_stall                         (lsda_sq_ex3_ecc_stall),                                
  .lsda_sq_ex3_expt_vld                          (lsda_sq_ex3_expt_vld),                                 
  .lsda_sq_ex3_lm_fail                           (lsda_sq_ex3_lm_fail),                                
  .lsda_sq_ex3_no_restart                        (lsda_sq_ex3_no_restart),                                 
  .lsda_ex3_sync_fence                           (lsda_ex3_sync_fence),                                
  .lsda_ex3_sync_inst                            (lsda_ex3_sync_inst),                                 
  .lsda_vb_ex3_ecc_err                           (lsda_vb_ex3_ecc_err),                                
  .lsda_vb_ex3_ecc_stall                         (lsda_vb_ex3_ecc_stall),                                
  .lsda_vb_ex3_feedback_addr_tto14               (lsda_vb_ex3_feedback_addr_tto14),                                
  .lsda_vb_ex3_tag_reissue                       (lsda_vb_ex3_tag_reissue),                                
  .lsda_ex3_wait_fence_gateclk_en                (lsda_ex3_st_wait_fence_gateclk_en),                                 
  .lsda_lswb_ex3_cmplt_req                       (lsda_lswb_ex3_st_cmplt_req),                                  
  .lsda_lswb_ex3_expt_vec                        (lsda_lswb_ex3_st_expt_vec),                                   
  .lsda_ex3_expt_vld                             (lsda_ex3_st_expt_vld),                             
  .lsda_lswb_ex3_mt_value                        (lsda_lswb_ex3_st_mt_value),                                   
  .lsda_lswb_ex3_no_spec_hit                     (lsda_lswb_ex3_st_no_spec_hit),                                  
  .lsda_lswb_ex3_no_spec_mispred                 (lsda_lswb_ex3_st_no_spec_mispred),                                  
  .lsda_lswb_ex3_no_spec_miss                    (lsda_lswb_ex3_st_no_spec_miss),                                   
  .lsda_lswb_ex3_no_spec_target                  (lsda_lswb_ex3_st_no_spec_target),                                   
  .lsda_lswb_ex3_spec_fail                       (lsda_lswb_ex3_st_spec_fail),                                  
  .lsda_lswb_ex3_vstart_vld                      (lsda_lswb_ex3_st_vstart_vld),
  .st_da_ecc_stall                               (st_da_ecc_stall),
//==========================================================
//                  Risc-V Debug zdb Begin (xx_lsu_st_da)
//==========================================================
  //input
  .dtu_lsu_addr_trig_en                        (dtu_lsu_addr_trig_en),
  .dtu_lsu_data_trig_en                        (dtu_lsu_data_trig_en),
  .dtu_lsu_addr_halt_info                      (dtu_lsu_addr_halt_info),
  .st_dc_boundary_unmask                       (ls_dc_boundary_unmask),
  .st_dc_data_check                            (st_dc_data_check),
  //output
  .st_da_already_da                            (st_da_already_da),
  .st_da_data_check                            (st_da_data_check),
  .st_da_dtu_addr_halt_info_stall_vld          (st_da_dtu_addr_halt_info_stall_vld),
  .st_da_idu_halt_info                         (st_da_idu_halt_info),
  .st_da_idu_halt_info_update_vld              (st_da_idu_halt_info_update_vld),
  .st_da_wb_expt_vld_cancel                    (st_da_wb_expt_vld_cancel)
//==========================================================
//                  Risc-V Debug zdb End   (xx_lsu_st_da)
//==========================================================                                     
);

//assign lsdc_lsda_ex2_ld_inst_vld = lsdc_lsda_ex2_inst_vld && lsdc_ex2_is_load;  //decide ld pipe is valid, LTL@20241107
//assign lsdc_lsda_ex2_st_inst_vld = lsdc_lsda_ex2_inst_vld && !lsdc_ex2_is_load; //decide st pipe is valid, LTL@20241107

//assign lsdc_ex2_ld_inst_vld = lsdc_ex2_inst_vld && lsdc_ex2_is_load;  //decide ld pipe dp is valid, LTL@20241107
//assign lsdc_ex2_st_inst_vld = lsdc_ex2_inst_vld && !lsdc_ex2_is_load; //decide st pipe dp is valid, LTL@20241107

always_comb begin          //need consider pipe borrow, LTL@20241112, no need worry dcache stall and mmu stall 
    if(ld_da_ecc_stall)    //first consider ld_da_ecc_stall, LTL@20250213
    begin
        lsdc_lsda_ex2_ld_inst_vld = lsdc_lsda_ex2_inst_vld;
        lsdc_lsda_ex2_st_inst_vld = 1'b0;  
        lsdc_ex2_ld_inst_vld      = lsdc_ex2_inst_vld && lsdc_ex2_is_load;                                    
        lsdc_ex2_st_inst_vld      = 1'b0;  
    end 
    else if(st_da_ecc_stall)   //no need use lsda_ex3_inst_vld, borrow_vld can also lead to ecc_stall 
    begin
        lsdc_lsda_ex2_ld_inst_vld = 1'b0;
        lsdc_lsda_ex2_st_inst_vld = lsdc_lsda_ex2_inst_vld;
        lsdc_ex2_ld_inst_vld      = 1'b0;                                     // if st_da ecc stall, ld da inst vld forcely set 0
        lsdc_ex2_st_inst_vld      = lsdc_ex2_inst_vld && !lsdc_ex2_is_load;   //
    end
    else
    begin
        lsdc_lsda_ex2_ld_inst_vld = lsdc_lsda_ex2_inst_vld && lsdc_ex2_is_load; 
        lsdc_lsda_ex2_st_inst_vld = lsdc_lsda_ex2_inst_vld && !lsdc_ex2_is_load;
        lsdc_ex2_ld_inst_vld      = lsdc_ex2_inst_vld && lsdc_ex2_is_load; 
        lsdc_ex2_st_inst_vld      = lsdc_ex2_inst_vld && !lsdc_ex2_is_load;
    end      
end


//assign lsda_ex3_is_load = lsda_ex3_is_load0 && lsda_ex3_ld_inst_vld
//                           || lsda_ex3_is_load1 && lsda_ex3_st_inst_vld;   //need consider 
//always_comb begin
//  lsda_ex3_is_load = 1'b0;
//  if(!lsda_ex3_ld_inst_vld && !lsda_ex3_st_inst_vld && lsda_ex3_is_load0)
//    lsda_ex3_is_load = 1'b0;
//  else if(!lsda_ex3_ld_inst_vld && !lsda_ex3_st_inst_vld && !lsda_ex3_is_load0)
//    lsda_ex3_is_load = 1'b0;
//  else if(lsda_ex3_ld_inst_vld)
//    lsda_ex3_is_load = 1'b1;
//end
always @(posedge forever_cpuclk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    lsda_ex3_is_load                    <=  1'b0;
  end
  else if(lsdc_lsda_ex2_borrow_vld && !ld_da_ecc_stall)  //when ld_da_ecc_stall, st_borrow should restart, LTL@20250213
  begin
    lsda_ex3_is_load                    <=  1'b0;
  end  
  else if(ld_da_ecc_stall || lsdc_lsda_ex2_ld_inst_vld)
  begin
    lsda_ex3_is_load                    <=  1'b1;
  end
  else if(st_da_ecc_stall || lsdc_lsda_ex2_st_inst_vld)
  begin
    lsda_ex3_is_load                    <=  1'b0;
  end
  else
    lsda_ex3_is_load                    <=  lsdc_ex2_is_load;
end

assign selfda_lsda_ex3_hit_idx                   = lsda_ex3_is_load
                                                  ? selfda_lsda_ex3_ld_hit_idx
                                                  : selfda_lsda_ex3_st_hit_idx;
assign lsda_ex3_tag_inj_mask                     = lsda_ex3_is_load
                                                  ? lsda_ex3_ld_tag_inj_mask
                                                  : lsda_ex3_st_tag_inj_mask;
assign lsda_ex3_addr                             = lsda_ex3_is_load
                                                  ? lsda_ex3_ld_addr
                                                  : lsda_ex3_st_addr;           
assign lsda_ex3_borrow_vld                       = lsda_ex3_is_load
                                                  ? lsda_ex3_ld_borrow_vld
                                                  : lsda_ex3_st_borrow_vld;          
assign lsda_ex3_dcache_hit                       = lsda_ex3_is_load
                                                  ? lsda_ex3_ld_dcache_hit
                                                  : lsda_ex3_st_dcache_hit;         
assign lsda_ex3_ecc_info                         = lsda_ex3_is_load
                                                  ? lsda_ex3_ld_ecc_info
                                                  : lsda_ex3_st_ecc_info;       
assign lsda_ex3_ecc_info_update                  = lsda_ex3_is_load
                                                  ? lsda_ex3_ld_ecc_info_update
                                                  : lsda_ex3_st_ecc_info_update;              
assign lsda_ex3_ecc_info_update_gate             = lsda_ex3_is_load
                                                  ? lsda_ex3_ld_ecc_info_update_gate
                                                  : lsda_ex3_st_ecc_info_update_gate;                   
assign lsda_ex3_ecc_pa                           = lsda_ex3_is_load
                                                  ? lsda_ex3_ld_ecc_pa
                                                  : lsda_ex3_st_ecc_pa;     
assign lsda_ex3_ecc_wakeup                       = lsda_ex3_is_load
                                                  ? lsda_ex3_ld_ecc_wakeup
                                                  : lsda_ex3_st_ecc_wakeup;         
assign lsda_ex3_element_cnt                      = lsda_ex3_is_load
                                                  ? lsda_ex3_ld_element_cnt
                                                  : lsda_ex3_st_element_cnt;          
assign lsda_idu_ex3_already_da                   = lsda_ex3_is_load
                                                  ? lsda_idu_ex3_ld_already_da
                                                  : lsda_idu_ex3_st_already_da;                         
assign lsda_idu_ex3_boundary_gateclk_en          = lsda_ex3_is_load
                                                  ? lsda_idu_ex3_ld_boundary_gateclk_en
                                                  : lsda_idu_ex3_st_boundary_gateclk_en;                      
assign lsda_idu_ex3_pop_entry                    = lsda_ex3_is_load
                                                  ? lsda_idu_ex3_ld_pop_entry
                                                  : lsda_idu_ex3_st_pop_entry;            
assign lsda_idu_ex3_pop_vld                      = lsda_ex3_is_load
                                                  ? lsda_idu_ex3_ld_pop_vld
                                                  : lsda_idu_ex3_st_pop_vld;          
assign lsda_idu_ex3_rb_full                      = lsda_ex3_is_load
                                                  ? lsda_idu_ex3_ld_rb_full
                                                  : lsda_idu_ex3_st_rb_full;          
assign lsda_idu_ex3_secd                         = lsda_ex3_is_load
                                                  ? lsda_idu_ex3_ld_secd
                                                  : lsda_idu_ex3_st_secd;       
assign lsda_idu_ex3_spec_fail                    = lsda_ex3_is_load
                                                  ? lsda_idu_ex3_ld_spec_fail
                                                  : lsda_idu_ex3_st_spec_fail;            
assign lsda_idu_ex3_wait_fence                   = lsda_ex3_is_load
                                                  ? lsda_idu_ex3_ld_wait_fence
                                                  : lsda_idu_ex3_st_wait_fence;             
assign lsda_ex3_iid                              = lsda_ex3_is_load
                                                  ? lsda_ex3_ld_iid
                                                  : lsda_ex3_st_iid;
assign lsda_ex3_inst_size                        = lsda_ex3_is_load
                                                  ? lsda_ex3_ld_inst_size
                                                  : lsda_ex3_st_inst_size;        
assign lsda_ex3_inst_vld                         = lsda_ex3_ld_inst_vld      //or no need is_load, LTL@20241119
                                                  || lsda_ex3_st_inst_vld;       
assign lsda_lm_ex3_ecc_err                       = lsda_ex3_is_load
                                                  ? lsda_lm_ex3_ld_ecc_err
                                                  : lsda_lm_ex3_st_ecc_err;         
assign lsda_ex3_old                              = lsda_ex3_is_load
                                                  ? lsda_ex3_ld_old
                                                  : lsda_ex3_st_old;  
assign lsda_ex3_page_buf                         = lsda_ex3_is_load
                                                  ? lsda_ex3_ld_page_buf
                                                  : lsda_ex3_st_page_buf;       
assign lsda_ex3_page_ca                          = lsda_ex3_is_load
                                                  ? lsda_ex3_ld_page_ca
                                                  : lsda_ex3_st_page_ca;      
assign lsda_ex3_page_sec                         = lsda_ex3_is_load
                                                  ? lsda_ex3_ld_page_sec
                                                  : lsda_ex3_st_page_sec;       
assign lsda_ex3_page_sec_ff                      = lsda_ex3_is_load
                                                  ? lsda_ex3_ld_page_sec_ff
                                                  : lsda_ex3_st_page_sec_ff;          
assign lsda_ex3_page_share                       = lsda_ex3_is_load
                                                  ? lsda_ex3_ld_page_share
                                                  : lsda_ex3_st_page_share;         
assign lsda_ex3_page_share_ff                    = lsda_ex3_is_load
                                                  ? lsda_ex3_ld_page_share_ff
                                                  : lsda_ex3_st_page_share_ff;            
assign lsda_ex3_page_so                          = lsda_ex3_is_load
                                                  ? lsda_ex3_ld_page_so
                                                  : lsda_ex3_st_page_so;      
assign lsda_pfu_ex3_awk_dp_vld                   = lsda_ex3_is_load
                                                  ? lsda_pfu_ex3_ld_awk_dp_vld
                                                  : lsda_pfu_ex3_st_awk_dp_vld;             
assign lsda_pfu_ex3_awk_vld                      = lsda_ex3_is_load
                                                  ? lsda_pfu_ex3_ld_awk_vld
                                                  : lsda_pfu_ex3_st_awk_vld;          
assign lsda_pfu_ex3_biu_req_hit_idx              = lsda_ex3_is_load
                                                  ? lsda_pfu_ex3_ld_biu_req_hit_idx
                                                  : lsda_pfu_ex3_st_biu_req_hit_idx;                  
assign lsda_pfu_ex3_eviwk_cnt_vld                = lsda_ex3_is_load
                                                  ? lsda_pfu_ex3_ld_eviwk_cnt_vld
                                                  : lsda_pfu_ex3_st_eviwk_cnt_vld;                
assign lsda_pfu_ex3_pf_inst_vld                  = lsda_ex3_is_load
                                                  ? lsda_pfu_ex3_ld_pf_inst_vld
                                                  : lsda_pfu_ex3_st_pf_inst_vld;              
assign lsda_pfu_ex3_ppfu_va                      = lsda_ex3_is_load
                                                  ? lsda_pfu_ex3_ld_ppfu_va
                                                  : lsda_pfu_ex3_st_ppfu_va;          
assign lsda_pfu_ex3_ppn_ff                       = lsda_ex3_is_load
                                                  ? lsda_pfu_ex3_ld_ppn_ff
                                                  : lsda_pfu_ex3_st_ppn_ff;          
assign lsda_rb_ex3_cmit                          = lsda_ex3_is_load
                                                  ? lsda_rb_ex3_ld_cmit
                                                  : lsda_rb_ex3_st_cmit;      
assign lsda_rb_ex3_create_dp_vld                 = lsda_ex3_is_load
                                                  ? lsda_rb_ex3_ld_create_dp_vld
                                                  : lsda_rb_ex3_st_create_dp_vld;               
assign lsda_rb_ex3_create_gateclk_en             = lsda_ex3_is_load
                                                  ? lsda_rb_ex3_ld_create_gateclk_en
                                                  : lsda_rb_ex3_st_create_gateclk_en;
assign lsda_rb_ex3_create_judge_vld              = lsda_ex3_is_load
                                                  ? lsda_rb_ex3_ld_create_judge_vld
                                                  : lsda_rb_ex3_st_create_judge_vld;                      
assign lsda_rb_ex3_create_lfb                    = lsda_ex3_is_load
                                                  ? lsda_rb_ex3_ld_create_lfb
                                                  : lsda_rb_ex3_st_create_lfb;            
assign lsda_rb_ex3_create_vld                    = lsda_ex3_is_load
                                                  ? lsda_rb_ex3_ld_create_vld
                                                  : lsda_rb_ex3_st_create_vld;            
assign lsda_ex3_rb_full_gateclk_en               = lsda_ex3_is_load
                                                  ? lsda_ex3_ld_rb_full_gateclk_en
                                                  : lsda_ex3_st_rb_full_gateclk_en;                 
assign lsda_sf_ex3_addr_tto4                     = lsda_ex3_is_load
                                                  ? lsda_sf_ex3_ld_addr_tto4
                                                  : lsda_sf_ex3_st_addr_tto4;           
assign lsda_sf_ex3_bytes_vld                     = lsda_ex3_is_load
                                                  ? lsda_sf_ex3_ld_bytes_vld
                                                  : lsda_sf_ex3_st_bytes_vld;           
assign lsda_sf_ex3_iid                           = lsda_ex3_is_load
                                                  ? lsda_sf_ex3_ld_iid
                                                  : lsda_sf_ex3_st_iid;     
assign lsda_sf_ex3_no_spec_miss                  = lsda_ex3_is_load
                                                  ? lsda_sf_ex3_ld_no_spec_miss
                                                  : lsda_sf_ex3_st_no_spec_miss;              
assign lsda_sf_ex3_no_spec_miss_gate             = lsda_ex3_is_load
                                                  ? lsda_sf_ex3_ld_no_spec_miss_gate
                                                  : lsda_sf_ex3_st_no_spec_miss_gate;                   
assign lsda_sf_ex3_spec_chk_req                  = lsda_ex3_is_load
                                                   ? lsda_sf_ex3_ld_spec_chk_req
                                                   : lsda_sf_ex3_st_spec_chk_req;// wjh@sfp
assign lsda_sfp_ex3_src_pc                       = lsda_ex3_is_load
                                                   ? lsda_sfp_ex3_ld_src_pc
                                                   : lsda_sfp_ex3_st_src_pc; // wjh@sfp
assign lsda_sfp_ex3_dst_pc                       = lsda_ex3_is_load
                                                   ? lsda_ex3_ldfifo_pc
                                                   : lsda_pfu_ex3_pc; // wjh@sfp
assign lsda_ex3_wait_fence_gateclk_en            = lsda_ex3_is_load
                                                  ? lsda_ex3_ld_wait_fence_gateclk_en
                                                  : lsda_ex3_st_wait_fence_gateclk_en;                    
assign lsda_lswb_ex3_cmplt_req                   = lsda_ex3_is_load
                                                   ? lsda_lswb_ex3_ld_cmplt_req     //same as lsda_lswb_ex3_inst_vld, LTL@20241120
                                                  : lsda_lswb_ex3_st_cmplt_req ;             
assign lsda_lswb_ex3_expt_vec                    = lsda_ex3_is_load
                                                  ? lsda_lswb_ex3_ld_expt_vec
                                                  : lsda_lswb_ex3_st_expt_vec;            
assign lsda_ex3_expt_vld                         = lsda_ex3_is_load
                                                  ? lsda_ex3_ld_expt_vld
                                                  : lsda_ex3_st_expt_vld;        
assign lsda_lswb_ex3_mt_value                    = lsda_ex3_is_load
                                                  ? lsda_lswb_ex3_ld_mt_value
                                                  : lsda_lswb_ex3_st_mt_value;            
assign lsda_lswb_ex3_no_spec_hit                 = lsda_ex3_is_load
                                                  ? lsda_lswb_ex3_ld_no_spec_hit
                                                  : lsda_lswb_ex3_st_no_spec_hit;               
assign lsda_lswb_ex3_no_spec_mispred             = lsda_ex3_is_load
                                                  ? lsda_lswb_ex3_ld_no_spec_mispred
                                                  : lsda_lswb_ex3_st_no_spec_mispred;                   
assign lsda_lswb_ex3_no_spec_miss                = lsda_ex3_is_load
                                                  ? lsda_lswb_ex3_ld_no_spec_miss
                                                  : lsda_lswb_ex3_st_no_spec_miss;                
assign lsda_lswb_ex3_no_spec_target              = lsda_ex3_is_load
                                                  ? lsda_lswb_ex3_ld_no_spec_target
                                                  : lsda_lswb_ex3_st_no_spec_target;                  
assign lsda_lswb_ex3_spec_fail                   = lsda_ex3_is_load
                                                  ? lsda_lswb_ex3_ld_spec_fail
                                                  : lsda_lswb_ex3_st_spec_fail;             
assign lsda_lswb_ex3_vstart_vld                  = lsda_ex3_is_load
                                                  ? lsda_lswb_ex3_ld_vstart_vld
                                                  : lsda_lswb_ex3_st_vstart_vld;              
//assign lsu_hpcp_ls_cache_access                     = lsda_ex3_is_load
//                                                  ? lsu_hpcp_ld_cache_access
//                                                  : lsu_hpcp_st_cache_access;           
//assign lsu_hpcp_ls_cache_miss                       = lsda_ex3_is_load
//                                                  ? lsu_hpcp_ld_cache_miss
//                                                  : lsu_hpcp_st_cache_miss;         
assign lsu_hpcp_ls_unalign_inst                     = lsda_ex3_is_load
                                                  ? lsu_hpcp_ld_unalign_inst
                                                  : lsu_hpcp_st_unalign_inst;            
assign lsu_lsda_tag_inj_cmplt                    = lsda_ex3_is_load
                                                  ? lsu_lsda_ld_tag_inj_cmplt
                                                  : lsu_lsda_st_tag_inj_cmplt;           
assign lsu_rtu_ex3_ssf_iid                       = lsda_ex3_is_load
                                                  ? lsu_rtu_ex3_ld_ssf_iid
                                                  : lsu_rtu_ex3_st_ssf_iid;          
assign lsu_rtu_ex3_ssf_vld                       = lsda_ex3_is_load
                                                  ? lsu_rtu_ex3_ld_ssf_vld
                                                  : lsu_rtu_ex3_st_ssf_vld;          

assign ld_da_ex2_ecc_stall                       =  ld_da_ecc_stall; // @zdb

//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
assign ls_da_dtu_addr_halt_info_stall_vld        = lsda_ex3_is_load? ld_da_dtu_addr_halt_info_stall_vld : st_da_dtu_addr_halt_info_stall_vld;
assign ls_da_idu_halt_info                       = lsda_ex3_is_load? ld_da_idu_halt_info                : st_da_idu_halt_info; 
assign ls_da_idu_halt_info_update_vld            = lsda_ex3_is_load? ld_da_idu_halt_info_update_vld     : st_da_idu_halt_info_update_vld;
//==========================================================
//                  Risc-V Debug zdb End 
//==========================================================
endmodule
