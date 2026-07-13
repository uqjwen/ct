//-----------------------------------------------------------------------------
// File          : xx_lsu_ld_da.v
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
module xx_lsu_ld_da #(
parameter VB_DATA_ENTRY = 3,
parameter LQENTRY      = 48,
parameter LSIQENTRY    = 12,
parameter SQ_ENTRY      = 12,
parameter WMB_ENTRY     = 8,
parameter VMB_ENTRY     = 8,
parameter PC_LEN        = 15,
parameter IID_WIDTH     = 7,
parameter VREG          = 6,
parameter PREG          = 7
)(
// &Ports; @29
  cb_ld_da_data,                       
  cb_ld_da_data_vld,                   
  cp0_lsu_data_ecc_inj,                
  cp0_lsu_data_random,                 
  cp0_lsu_dcache_en,                   
  cp0_lsu_dcache_read_index,           
  cp0_lsu_ecc_en,                      
  cp0_lsu_icg_en,                      
  cp0_lsu_l2_pref_en,                  
  cp0_lsu_nsfe,                        
  cp0_lsu_tag_ecc_inj,                 
  cp0_lsu_tag_random0,                 
  cp0_lsu_vstart,                      
  cp0_yy_dcache_pref_en,               
  cpurst_b,                            
  ctrl_ld_clk,                         
  dcache_lsu_ld_data_bank0_dout,       
  dcache_lsu_ld_data_bank1_dout,       
  dcache_lsu_ld_data_bank2_dout,       
  dcache_lsu_ld_data_bank3_dout,       
  dcache_lsu_ld_data_bank4_dout,       
  dcache_lsu_ld_data_bank5_dout,       
  dcache_lsu_ld_data_bank6_dout,       
  dcache_lsu_ld_data_bank7_dout,       
  dcache_lsu_ld_data_bank8_dout,       
  dcache_lsu_ld_data_bank9_dout,       
  dcache_lsu_ld_data_bank10_dout,       
  dcache_lsu_ld_data_bank11_dout,       
  dcache_lsu_ld_data_bank12_dout,       
  dcache_lsu_ld_data_bank13_dout,       
  dcache_lsu_ld_data_bank14_dout,       
  dcache_lsu_ld_data_bank15_dout,
  dcache_lsu_ld_tag_dout,              
  forever_cpuclk,                      
  ldc_ex2_addr0,                         
  ldc_lda_ex2_ahead_predict,                 
  ldc_lda_ex2_ahead_preg_wb_vld,             
  ldc_lda_ex2_ahead_vreg_wb_vld,             
  ldc_lda_ex2_already_da,                    
  ldc_lda_ex2_atomic,                                           
  ldc_lda_ex2_borrow_db,                     
  ldc_lda_ex2_borrow_icc,                    
  ldc_lda_ex2_borrow_icc_ecc,                
  ldc_lda_ex2_borrow_icc_tag,                
  ldc_lda_ex2_borrow_idx_5to4,               
  ldc_lda_ex2_borrow_mmu,                    
  ldc_lda_ex2_borrow_prq,                    
  ldc_lda_ex2_borrow_sndb,                   
  ldc_lda_ex2_borrow_vb,                     
  ldc_ex2_borrow_vld,                    
  ldc_lda_ex2_borrow_wmb,                    
  ldc_lda_ex2_boundary,                      
  ldc_lda_ex2_bytes_vld,                  
  ldc_lda_ex2_bytes_vld1,                 
  ldc_lda_ex2_bytes_vld2,                 
  ldc_lda_ex2_bytes_vld3,                 
  ld_dc_da_cb_addr_create,             
  ld_dc_da_cb_merge_en,                
  ldc_lda_ex2_rot_sel,               
  ldc_lda_ex2_expt_vld_gate_en,           
  ldc_lda_ex2_icc_tag_vld,                
  ldc_lda_ex2_inst_vld,                   
  ldc_lda_ex2_lq_entry,                   
  ldc_lda_ex2_old,                        
  ldc_lda_ex2_page_buf,                   
  ldc_lda_ex2_page_ca,                    
  ldc_lda_ex2_page_sec,                   
  ldc_lda_ex2_page_share,                 
  ldc_lda_ex2_page_so,                    
  ldc_lda_ex2_pf_inst,                    
  ldc_lda_ex2_tag_read,                   
  ldc_lda_ex2_data_inj_dp,                   
  ldc_lda_ex2_dcache_hit,                    
  ldc_lda_ex2_dtcm_hit,                      
  ldc_lda_ex2_element_cnt,                   
  ldc_lda_ex2_element_size,                  
  ldc_lda_ex2_expt_access_fault_extra,       
  ldc_lda_ex2_expt_access_fault_mask,        
  ldc_lda_ex2_expt_vec,                      
  ldc_lda_ex2_expt_vld_except_access_err,    
  ldc_lda_ex2_fwd_bytes_vld,                 
  ldc_lda_ex2_fwd_sq_vld,                    
  ldc_lda_ex2_fwd_wmb_vld,                   
  ldc_lda_ex2_get_dcache_data,               
  //ldc_lda_ex2_hit_high_region,               
  //ldc_lda_ex2_hit_low_region,
  ldc_lda_ex2_hit_3_region,
  ldc_lda_ex2_hit_2_region,
  ldc_lda_ex2_hit_1_region,
  ldc_lda_ex2_hit_0_region,                
  //ldc_lda_ex2_hit_way0, 
  ldc_hit_way,                     
  ldc_ex2_iid,                           
  ldc_lda_ex2_inst_fof,                      
  ldc_lda_ex2_inst_size,                     
  ldc_lda_ex2_inst_type,                     
  ldc_lda_ex2_inst_vfls,                     
  ldc_ex2_inst_vld,                      
  ldc_lda_ex2_inst_vls,                      
  ldc_lda_ex2_itcm_hit,                      
  ldc_lda_ex2_ldfifo_pc,                     
  ldc_lda_ex2_lsid,                          
  ldc_lda_ex2_mmu_req,                       
  ldc_lda_ex2_mtval,                      
  ldc_lda_ex2_no_spec,                       
  ldc_lda_ex2_no_spec_exist,                 
  ldc_lda_ex2_pfu_info_set_vld,              
  ldc_lda_ex2_pfu_va,                        
  ldc_lda_ex2_preg,                          
  ldc_lda_ex2_preg_sign_sel,                 
  ldc_lda_ex2_reg_bytes_vld,                 
  ldc_lda_ex2_reg_bytes_vld1,                 
  ldc_lda_ex2_reg_bytes_vld2,                 
  ldc_lda_ex2_reg_bytes_vld3,                 
  ldc_lda_ex2_inst_us,                 
  ldc_lda_ex2_us_discard,
  ldc_ex2_secd,                          
  ldc_lda_ex2_settle_way,                    
  ldc_lda_ex2_setvl_val,                     
  ldc_lda_ex2_sext,                   
  ldc_lda_ex2_spec_fail,                     
  ldc_lda_ex2_split,                         
  ldc_lda_ex2_tag_inj_dp,                    
  ldc_lda_ex2_vector_nop,                    
  ldc_lda_ex2_vlmul,                         
  ldc_lda_ex2_vmb_id,                        
  ldc_lda_ex2_vmb_merge_vld,                 
  ldc_lda_ex2_vreg,                          
  ldc_lda_ex2_vreg_sign_sel,                 
  //ldc_lda_ex2_vsew,//rvv1.0 @hcl 
  ldc_lda_ex2_vmew,//rvv1.0 @hcl
  ldc_lda_ex2_vmop,//rvv1.0 @hcl                         
  ldc_lda_ex2_wait_fence,                    
  lq_lsu_ex2_spec_fail_pc, // wjh@sfp
  ld_hit_prefetch,                     
  lfb_lda_hit_idx,                   
  lm_lda_ex3_hit_idx,                    
  lsu_special_clk,                     
  mmu_lsu_access_fault0,               
  pad_yy_icg_scan_en,                  
  pfu_biu_req_addr,                    
  rb_lda_ex3_full,                       
  rb_lda_ex3_hit_idx,                    
  rb_lda_ex3_merge_fail,                 
  rtu_lsu_flush_fe,                    
  rtu_ck_flush,
  rtu_ck_flush_iid,
  rtu_yy_xx_commit0,                   
  rtu_yy_xx_commit0_iid,               
  rtu_yy_xx_commit1,                   
  rtu_yy_xx_commit1_iid,               
  rtu_yy_xx_commit2,                   
  rtu_yy_xx_commit2_iid,   
  rtu_yy_xx_commit3,                   
  rtu_yy_xx_commit3_iid,               
  rtu_yy_xx_commit4,                   
  rtu_yy_xx_commit4_iid,               
  rtu_yy_xx_commit5,                   
  rtu_yy_xx_commit5_iid,  
  //rtu_yy_xx_commit6,                   
  //rtu_yy_xx_commit6_iid,               
  //rtu_yy_xx_commit7,                   
  //rtu_yy_xx_commit7_iid,               
  std0_ex1_data_bypass,
  std1_ex1_data_bypass,                  
  std0_ex1_inst_vld,  
  std1_ex1_inst_vld,                    
  sf_lda_spec_mark,                        
  sq_lda_ex2_fwd_data,                   
  sq_lda_ex2_fwd_data_pe,                
  sq_lda_ex2_data_discard_req,           
  sq_lda_ex2_fwd_bypass_multi,           
  sq_lda_ex2_fwd_bypass_req,             
  sq_lda_ex2_fwd_id,                     
  sq_lda_ex2_fwd_multi,                  
  sq_lda_ex2_fwd_multi_mask,             
  sq_ldc_ex2_newest_fwd_data_vld_req,    
  sq_lda_ex2_other_discard_req,   
  sq_lda_ex2_fwd_bypass_sel,       
  lsda0_ex3_addr, 
  lsda1_ex3_addr,                           
  lsda0_ex3_tag_inj_mask,
  lsda1_ex3_tag_inj_mask,                
  wmb_lda_fwd_data,                  
  wmb_ldc_discard_req,               
  lda_ex3_addr,                          
  lda_ex3_addr_5to4,                                      
  lda_ex3_borrow_vld,                    
  lda_ex3_boundary_after_mask,           
  lda_ex3_boundary_after_mask_ff,        
  lda_ex3_bytes_vld,                     
  lda_ex3_bytes_vld1,                     
  lda_ex3_bytes_vld2,                     
  lda_ex3_bytes_vld3,                     
  //ld_da_cb_data,                       
  ld_da_cb_data_vld,                   
  ld_da_cb_ecc_cancel,                 
  ld_da_cb_ld_inst_vld,                
  lda_vb_ex3_data512, //double, LTL@20250321                      
  lda_ex3_data_rot_sel,                  
  lda_ex3_dcache_hit,                    
  lda_borrow_prq,                
  lda_ecc_ex3_info,                      
  lda_ecc_ex3_info_update,               
  lda_ecc_ex3_info_update_gate,          
  lda_ecc_ex3_pa,                        
  lda_ex3_ecc_wakeup,                    
  lda_ex3_element_cnt,                   
  lda_ex3_element_size,                  
  lda_ex3_fwd_ecc_stall,                 
  lda_icc_ex3_read_data,                 
  lda_idu_ex3_already_da,                               
  lda_idu_ex3_boundary_gateclk_en,       
  lda_idu_ex3_pop_entry,                 
  lda_idu_ex3_pop_vld,                   
  lda_idu_ex3_rb_full,                   
  lda_idu_ex3_secd,                      
  lda_idu_ex3_us_restart,
  lda_idu_ex3_spec_fail,                 
  lda_idu_ex3_wait_fence,                
  lda_ex3_idx,                           
  lda_ex3_iid,                           
  lda_ex3_inst_fof,                      
  lda_ex3_inst_size,                     
  lda_ex3_inst_vfls,                     
  lda_ex3_inst_vld,                      
  lda_ex3_inst_vls,                      
  lda_pfu_ex3_ldfifo_pc,                     
  lda_lfb_ex3_discard_grnt,              
  lda_lfb_set_wakeup_queue,          
  lda_lfb_wakeup_queue_gate,     
  lda_lfb_ex3_wakeup_queue_next,         
  lda_lm_ex3_discard_grnt,               
  lda_lm_ex3_ecc_err,                    
  lda_lm_ex3_lr_no_restart,              
  lda_lm_ex3_lr_no_restart_dp,           
  lda_lm_ex3_no_req,                     
  lda_lm_ex3_vector_nop,                 
  lda_ex3_lq_entry_pop,                  
  lda_ex3_lsid,                          
  lda_mcic_ex3_borrow_mmu,               
  lda_mcic_ex3_borrow_mmu_req,           
  lda_mcic_ex3_bypass_data,              
  lda_mcic_ex3_data_err,                 
  lda_mcic_ex3_rb_full,                  
  lda_mcic_ex3_wakeup,                   
  lda_ex3_old,                           
  lda_ex3_page_buf,                      
  lda_ex3_page_ca,                       
  lda_ex3_page_sec,                      
  lda_pfu_ex3_page_sec_ff,                   
  lda_ex3_page_share,                    
  lda_pfu_ex3_page_share_ff,                 
  lda_ex3_page_so,                       
  lda_pfu_ex3_awk_dp_vld,                
  lda_pfu_ex3_awk_vld,                   
  lda_pfu_ex3_biu_req_hit_idx,           
  lda_pfu_ex3_eviwk_cnt_vld  ,             
  lda_pfu_ex3_pf_inst_vld,               
  lda_pfu_ex3_va,                        
  lda_ppfu_ex3_va,                       
  lda_pfu_ex3_ppn_ff,                        
  lda_ex3_preg,                          
  lda_lwb_ex3_preg_sign_sel,                 
  lda_rb_ex3_atomic,                     
  lda_rb_ex3_cmit,                       
  lda_rb_ex3_cmplt_success,              
  lda_rb_ex3_create_dp_vld,              
  lda_rb_ex3_create_gateclk_en,          
  lda_rb_ex3_create_judge_vld,           
  lda_rb_ex3_create_lfb,                 
  lda_rb_ex3_create_vld,                 
  lda_rb_ex3_data_ori,                   
  lda_rb_ex3_data_ori1,                   
  lda_rb_ex3_data_ori2,                   
  lda_rb_ex3_data_ori3,                   
  lda_rb_ex3_data_vld,                   
  lda_rb_ex3_dest_vld,                   
  lda_rb_ex3_discard_grnt,               
  lda_rb_ex3_expt_vld,                   
  lda_rb_ex3_full_gateclk_en,            
  lda_rb_ex3_ldamo,                      
  lda_rb_ex3_merge_dp_vld,               
  lda_rb_ex3_merge_expt_vld,             
  lda_rb_ex3_merge_gateclk_en,           
  lda_rb_ex3_merge_vld,
  lda_rb_ex3_ecc_mask,                  
  lda_ex3_reg_bytes_vld,                 
  lda_ex3_reg_bytes_vld1,                 
  lda_ex3_reg_bytes_vld2,                 
  lda_ex3_reg_bytes_vld3,                 
  lda_ex3_inst_us,
  lda_ex3_setvl_val,                     
  lda_sf_ex3_addr_tto4,                  
  lda_sf_ex3_bytes_vld,                  
  lda0_sf_ex3_iid, 
  lsu_rtu_ex3_ssf_vld,
  lsu_rtu_ex3_ssf_iid,  
  lda_sf_ex3_no_spec_miss,               
  lda_sf_ex3_no_spec_miss_gate,          
  lda_sf_ex3_spec_chk_req,               
  lda_sfp_ex3_src_pc, // wjh@sfp
  lda_ex3_sext,                   
  lda_snq_ex3_borrow_icc,                
  lda_snq_ex3_borrow_sndb,               
  lda_ex3_special_gateclk_en,            
  lda_ex3_split,                         
  lda_sq_ex3_data_discard_vld,           
  lda_sq_ex3_fwd_id,                     
  lda_sq_ex3_fwd_multi_vld,              
  lda_sq_ex3_global_discard_vld,         
  lda_lsda0_ex3_hit_idx, 
  lda_lsda1_ex3_hit_idx,                  
  lda_lsda_ex3_tag_inj_mask,               
  lda_vb_ex3_borrow_vb,                  
  lda_vb_ex3_snq_data_reissue,           
  lda_vb_snq_ex3_ecc_err,                
  lda_ex3_vlmul,                         
  lda_ex3_vmb_id,                        
  lda_ex3_vmb_merge_vld,                 
  lda_ex3_vreg,                          
  lda_ex3_vreg_sign_sel,                 
  //lda_ex3_vsew,//rvv1.0 @hcl 
  lda_ex3_vmew, //rvv1.0@hcl 
  lda_ex3_vmop, //rvv1.0@hcl                          
  lda_ex3_wait_fence_gateclk_en,         
  lda_lwb_ex3_cmplt_req,                  
  lda_lwb_ex3_cmplt_req_gate,             
  lda_lwb_ex3_data,                       
  lda_lwb_ex3_data1,                       
  lda_lwb_ex3_data2,                       
  lda_lwb_ex3_data3,                       
  lda_lwb_ex3_data_req,                   
  lda_lwb_ex3_data_req_dp,                
  lda_lwb_ex3_data_req_gateclk_en,        
  lda_lwb_ex3_expt_vec,                   
  lda_lwb_ex3_expt_vld, 
  lda_lwb_ex3_inst_vls,                                    
  lda_lwb_ex3_mtval,                   
  lda_lwb_ex3_no_spec_hit,                
  lda_lwb_ex3_no_spec_mispred,            
  lda_lwb_ex3_no_spec_miss,               
  lda_lwb_ex3_no_spec_target,             
  lda_ex3_spec_fail,                  
  lda_lwb_ex3_vreg_sign_sel,              
  lda_lwb_ex3_vsetvl,                     
  lda_lwb_ex3_vstart_vld,                 
  lda_wmb_ex3_data_reissue,              
  lda_wmb_ex3_discard_vld,               
  lda_wmb_ex3_read_data,                 
  lda_wmb_ex3_two_bit_err,               
  lsu_hpcp_ld_cache_access,            
  lsu_hpcp_ld_cache_miss,              
  lsu_hpcp_ld_data_discard,            
  lsu_hpcp_ld_discard_sq,              
  lsu_hpcp_ld_unalign_inst,            
  lda_idu_ex3_fwd_preg,           
  lda_idu_ex3_fwd_preg_data,      
  lda_idu_ex3_fwd_preg_vld,       
  lda_idu_ex3_fwd_vreg,           
  lda_idu_ex3_fwd_vreg_fr_data,   
  lda_idu_ex3_fwd_vreg_vld,       
  lda_idu_ex3_fwd_vreg_vr0_data,  
  lda_idu_ex3_fwd_vreg_vr1_data,  
  lsu_idu_ex3_wait_old,              
  lsu_idu_ex3_wait_old_gateclk_en,   
  lsu_ld_data_inj_cmplt,               
  lsu_ld_tag_inj_cmplt,
  lda_ex2_ecc_stall, // @zdb              
//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
  //input
  dtu_lsu_data_trig_en,
  dtu_lsu_addr_halt_info,
  ld_dc_boundary_unmask,
  //output
  ld_da_dtu_addr_halt_info_stall_vld,
  ld_da_halt_info_am,
  ld_da_idu_halt_info,           
  ld_da_idu_halt_info_update_vld,
  ld_da_rb_data_check
//==========================================================
//                  Risc-V Debug zdb End
//==========================================================
);

input   [127:0]                                             cb_ld_da_data;                       
input                                                       cb_ld_da_data_vld;                   
input                                                       cp0_lsu_data_ecc_inj;                
input   [38 :0]                                             cp0_lsu_data_random;                 
input                                                       cp0_lsu_dcache_en;                   
input   [16 :0]                                             cp0_lsu_dcache_read_index;           
input                                                       cp0_lsu_ecc_en;                      
input                                                       cp0_lsu_icg_en;                      
input                                                       cp0_lsu_l2_pref_en;                  
input                                                       cp0_lsu_nsfe;                        
input                                                       cp0_lsu_tag_ecc_inj;                 
input   [`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0]              cp0_lsu_tag_random0;                 
input   [`VSTART_WIDTH-1  :0]                                             cp0_lsu_vstart;                      
input                                                       cp0_yy_dcache_pref_en;               
input                                                       cpurst_b;                            
input                                                       ctrl_ld_clk;                         
input   [38 :0]                                             dcache_lsu_ld_data_bank0_dout;       
input   [38 :0]                                             dcache_lsu_ld_data_bank1_dout;       
input   [38 :0]                                             dcache_lsu_ld_data_bank2_dout;       
input   [38 :0]                                             dcache_lsu_ld_data_bank3_dout;       
input   [38 :0]                                             dcache_lsu_ld_data_bank4_dout;       
input   [38 :0]                                             dcache_lsu_ld_data_bank5_dout;       
input   [38 :0]                                             dcache_lsu_ld_data_bank6_dout;       
input   [38 :0]                                             dcache_lsu_ld_data_bank7_dout; 
input   [38 :0]                                             dcache_lsu_ld_data_bank8_dout;   //8bank_data->16 bank_data, L1D 2way->4way, LTL@20250320      
input   [38 :0]                                             dcache_lsu_ld_data_bank9_dout;       
input   [38 :0]                                             dcache_lsu_ld_data_bank10_dout;       
input   [38 :0]                                             dcache_lsu_ld_data_bank11_dout;       
input   [38 :0]                                             dcache_lsu_ld_data_bank12_dout;       
input   [38 :0]                                             dcache_lsu_ld_data_bank13_dout;       
input   [38 :0]                                             dcache_lsu_ld_data_bank14_dout;       
input   [38 :0]                                             dcache_lsu_ld_data_bank15_dout;       
input   [`WK_LS_DCACHE_LDTAG_WIDTH-1:0]                     dcache_lsu_ld_tag_dout;         //L1D 2way->4way, LTL@20250320          
input                                                       forever_cpuclk;                      
input   [`WK_PA_WIDTH-1 :0]                                 ldc_ex2_addr0;                         
input                                                       ldc_lda_ex2_ahead_predict;                 
input                                                       ldc_lda_ex2_ahead_preg_wb_vld;             
input                                                       ldc_lda_ex2_ahead_vreg_wb_vld;             
input                                                       ldc_lda_ex2_already_da;                    
input                                                       ldc_lda_ex2_atomic;                                          
input   [2  :0]                                             ldc_lda_ex2_borrow_db;                     
input                                                       ldc_lda_ex2_borrow_icc;                    
input                                                       ldc_lda_ex2_borrow_icc_ecc;                
input                                                       ldc_lda_ex2_borrow_icc_tag;                
input   [1  :0]                                             ldc_lda_ex2_borrow_idx_5to4;               
input                                                       ldc_lda_ex2_borrow_mmu;                    
input                                                       ldc_lda_ex2_borrow_prq;                    
input                                                       ldc_lda_ex2_borrow_sndb;                   
input                                                       ldc_lda_ex2_borrow_vb;                     
input                                                       ldc_ex2_borrow_vld;                    
input                                                       ldc_lda_ex2_borrow_wmb;                    
input                                                       ldc_lda_ex2_boundary;                      
input   [15 :0]                                             ldc_lda_ex2_bytes_vld;                  
input   [15 :0]                                             ldc_lda_ex2_bytes_vld1;                 
input   [15 :0]                                             ldc_lda_ex2_bytes_vld2;                 
input   [15 :0]                                             ldc_lda_ex2_bytes_vld3;                 
input                                                       ld_dc_da_cb_addr_create;             
input                                                       ld_dc_da_cb_merge_en;                
input   [15 :0]                                             ldc_lda_ex2_rot_sel;               
input                                                       ldc_lda_ex2_expt_vld_gate_en;           
input                                                       ldc_lda_ex2_icc_tag_vld;                
input                                                       ldc_lda_ex2_inst_vld;                   
input   [LQENTRY-1:0]                                       ldc_lda_ex2_lq_entry;                   
input                                                       ldc_lda_ex2_old;                        
input                                                       ldc_lda_ex2_page_buf;                   
input                                                       ldc_lda_ex2_page_ca;                    
input                                                       ldc_lda_ex2_page_sec;                   
input                                                       ldc_lda_ex2_page_share;                 
input                                                       ldc_lda_ex2_page_so;                    
input                                                       ldc_lda_ex2_pf_inst;                    
input   [`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0]              ldc_lda_ex2_tag_read;                   
input                                                       ldc_lda_ex2_data_inj_dp;                   
input                                                       ldc_lda_ex2_dcache_hit;                    
input                                                       ldc_lda_ex2_dtcm_hit;                      
input   [8  :0]                                             ldc_lda_ex2_element_cnt;                   
input   [1  :0]                                             ldc_lda_ex2_element_size;                  
input                                                       ldc_lda_ex2_expt_access_fault_extra;       
input                                                       ldc_lda_ex2_expt_access_fault_mask;        
input   [4  :0]                                             ldc_lda_ex2_expt_vec;                      
input                                                       ldc_lda_ex2_expt_vld_except_access_err;    
input   [15 :0]                                             ldc_lda_ex2_fwd_bytes_vld;                 
input                                                       ldc_lda_ex2_fwd_sq_vld;                    
input                                                       ldc_lda_ex2_fwd_wmb_vld;                   
input   [3  :0]                                             ldc_lda_ex2_get_dcache_data;               
//input                       ldc_lda_ex2_hit_high_region;               
//input                       ldc_lda_ex2_hit_low_region; 
input                                                       ldc_lda_ex2_hit_3_region;
input                                                       ldc_lda_ex2_hit_2_region;               
input                                                       ldc_lda_ex2_hit_1_region;
input                                                       ldc_lda_ex2_hit_0_region;
//input                       ldc_lda_ex2_hit_way0;                    
input                                                       rtu_ck_flush;
input   [IID_WIDTH-1  :0]                                   rtu_ck_flush_iid;
input   [3  :0]                                             ldc_hit_way;        
input   [IID_WIDTH-1:0]                                     ldc_ex2_iid;                           
input                                                       ldc_lda_ex2_inst_fof;                      
input   [2  :0]                                             ldc_lda_ex2_inst_size;                     
input   [1  :0]                                             ldc_lda_ex2_inst_type;                     
input                                                       ldc_lda_ex2_inst_vfls;                     
input                                                       ldc_ex2_inst_vld;                      
input                                                       ldc_lda_ex2_inst_vls;                      
input                                                       ldc_lda_ex2_itcm_hit;                      
input   [PC_LEN-1:0]                                        ldc_lda_ex2_ldfifo_pc;                     
input   [LSIQENTRY-1:0]                                     ldc_lda_ex2_lsid;                          
input                                                       ldc_lda_ex2_mmu_req;                       
input   [`WK_PA_WIDTH-1:0]                                  ldc_lda_ex2_mtval;                      
input   [1  :0]                                             ldc_lda_ex2_no_spec;                       
input                                                       ldc_lda_ex2_no_spec_exist;                 
input                                                       ldc_lda_ex2_pfu_info_set_vld;              
input   [`WK_PA_WIDTH-1:0]                                  ldc_lda_ex2_pfu_va;                        
input   [PREG-1:0]                                          ldc_lda_ex2_preg;                          
input   [3  :0]                                             ldc_lda_ex2_preg_sign_sel;                 
input   [15 :0]                                             ldc_lda_ex2_reg_bytes_vld;                 
input   [15 :0]                                             ldc_lda_ex2_reg_bytes_vld1;                 
input   [15 :0]                                             ldc_lda_ex2_reg_bytes_vld2;                 
input   [15 :0]                                             ldc_lda_ex2_reg_bytes_vld3;                 
input                                                       ldc_lda_ex2_inst_us;
input                                                       ldc_lda_ex2_us_discard;
input                                                       ldc_ex2_secd;                          
input   [1  :0]                                             ldc_lda_ex2_settle_way;                    
input   [8  :0]                                             ldc_lda_ex2_setvl_val;                     
input                                                       ldc_lda_ex2_sext;                   
input                                                       ldc_lda_ex2_spec_fail;                     
input                                                       ldc_lda_ex2_split;                         
input                                                       ldc_lda_ex2_tag_inj_dp;                    
input                                                       ldc_lda_ex2_vector_nop;                    
// input   [1  :0]                                             ldc_lda_ex2_vlmul;     
input   [2  :0]             ldc_lda_ex2_vlmul;  //pwh 1 for rvv1.0                    
input   [VMB_ENTRY-1:0]                                     ldc_lda_ex2_vmb_id;                        
input                                                       ldc_lda_ex2_vmb_merge_vld;                 
input   [VREG-1  :0]                                        ldc_lda_ex2_vreg;                          
input                                                       ldc_lda_ex2_vreg_sign_sel;                 
//input   [1  :0]                                             ldc_lda_ex2_vsew;//rvv1.0@hcl
input   [1  :0]             ldc_lda_ex2_vmew;  //rvv1.0@hcl
input   [1  :0]             ldc_lda_ex2_vmop;  //rvv1.0@hcl                        
input                                                       ldc_lda_ex2_wait_fence;                    
input   [PC_LEN-1:0]                                        lq_lsu_ex2_spec_fail_pc; // wjh@sfp
input                                                       ld_hit_prefetch;                     
input                                                       lfb_lda_hit_idx;                   
input                                                       lm_lda_ex3_hit_idx;                    
input                                                       lsu_special_clk;                     
input                                                       mmu_lsu_access_fault0;               
input                                                       pad_yy_icg_scan_en;                  
input   [`WK_PA_WIDTH-1:0]                                  pfu_biu_req_addr;                    
input                                                       rb_lda_ex3_full;                       
input                                                       rb_lda_ex3_hit_idx;                    
input                                                       rb_lda_ex3_merge_fail;                 
input                                                       rtu_lsu_flush_fe;                    
input                                                       rtu_yy_xx_commit0;                   
input   [IID_WIDTH-1:0]                                     rtu_yy_xx_commit0_iid;               
input                                                       rtu_yy_xx_commit1;                   
input   [IID_WIDTH-1:0]                                     rtu_yy_xx_commit1_iid;               
input                                                       rtu_yy_xx_commit2;                   
input   [IID_WIDTH-1:0]                                     rtu_yy_xx_commit2_iid;   
input                                                       rtu_yy_xx_commit3;                   
input   [IID_WIDTH-1:0]                                     rtu_yy_xx_commit3_iid;               
input                                                       rtu_yy_xx_commit4;                   
input   [IID_WIDTH-1:0]                                     rtu_yy_xx_commit4_iid;               
input                                                       rtu_yy_xx_commit5;                   
input   [IID_WIDTH-1:0]                                     rtu_yy_xx_commit5_iid;  
//input                       rtu_yy_xx_commit6,                  ;
//input   [IID_WIDTH-1:0]     rtu_yy_xx_commit6_iid,              ;
//input                       rtu_yy_xx_commit7,                  ;
//input   [IID_WIDTH-1:0]     rtu_yy_xx_commit7_iid,              ;
input   [127:0]                                             std0_ex1_data_bypass;
input   [127:0]                                             std1_ex1_data_bypass;                  
input                                                       std0_ex1_inst_vld;  
input                                                       std1_ex1_inst_vld;                    
input                                                       sf_lda_spec_mark;                        
input   [127:0]                                             sq_lda_ex2_fwd_data;                   
input   [127:0]                                             sq_lda_ex2_fwd_data_pe;                
input                                                       sq_lda_ex2_data_discard_req;           
input                                                       sq_lda_ex2_fwd_bypass_multi;           
input                                                       sq_lda_ex2_fwd_bypass_req;             
input   [SQ_ENTRY-1 :0]                                     sq_lda_ex2_fwd_id;                     
input                                                       sq_lda_ex2_fwd_multi;                  
input                                                       sq_lda_ex2_fwd_multi_mask;             
input                                                       sq_ldc_ex2_newest_fwd_data_vld_req;    
input                                                       sq_lda_ex2_other_discard_req;   
input                                                       sq_lda_ex2_fwd_bypass_sel;       
input   [`WK_PA_WIDTH-1:0]                                  lsda0_ex3_addr; 
input   [`WK_PA_WIDTH-1:0]                                  lsda1_ex3_addr;                           
input                                                       lsda0_ex3_tag_inj_mask;
input                                                       lsda1_ex3_tag_inj_mask;                
input   [127:0]                                             wmb_lda_fwd_data;                  
input                                                       wmb_ldc_discard_req;               
output  [`WK_PA_WIDTH-1:0]                                  lda_ex3_addr;                          
output  [1  :0]                                             lda_ex3_addr_5to4;                                      
output                                                      lda_ex3_borrow_vld;                    
output                                                      lda_ex3_boundary_after_mask;           
output                                                      lda_ex3_boundary_after_mask_ff;        
output  [15 :0]                                             lda_ex3_bytes_vld;                     
output  [15 :0]                                             lda_ex3_bytes_vld1;                     
output  [15 :0]                                             lda_ex3_bytes_vld2;                     
output  [15 :0]                                             lda_ex3_bytes_vld3;                     
//output  [127:0]             ld_da_cb_data;                       
output                                                      ld_da_cb_data_vld;                   
output                                                      ld_da_cb_ecc_cancel;                 
output                                                      ld_da_cb_ld_inst_vld;                
output  [511:0]                                             lda_vb_ex3_data512;  //256->512, LTL@20250320                       
output  [15 :0]                                             lda_ex3_data_rot_sel;                  
output                                                      lda_ex3_dcache_hit;                    
output                                                      lda_borrow_prq;                    
output  [22 :0]                                             lda_ecc_ex3_info;                      
output                                                      lda_ecc_ex3_info_update;               
output                                                      lda_ecc_ex3_info_update_gate;          
output  [`WK_PA_WIDTH-1:0]                                  lda_ecc_ex3_pa;                        
output  [LSIQENTRY-1:0]                                     lda_ex3_ecc_wakeup;                    
output  [8  :0]                                             lda_ex3_element_cnt;                   
output  [1  :0]                                             lda_ex3_element_size;                  
output                                                      lda_ex3_fwd_ecc_stall;                 
output  [127:0]                                             lda_icc_ex3_read_data;                 
output  [LSIQENTRY-1:0]                                     lda_idu_ex3_already_da;                               
output  [LSIQENTRY-1:0]                                     lda_idu_ex3_boundary_gateclk_en;       
output  [LSIQENTRY-1:0]                                     lda_idu_ex3_pop_entry;                 
output                                                      lda_idu_ex3_pop_vld;                   
output  [LSIQENTRY-1:0]                                     lda_idu_ex3_rb_full;                   
output  [LSIQENTRY-1:0]                                     lda_idu_ex3_secd;                      
output  [LSIQENTRY-1:0]                                     lda_idu_ex3_us_restart;
output  [LSIQENTRY-1:0]                                     lda_idu_ex3_spec_fail;                 
output  [LSIQENTRY-1:0]                                     lda_idu_ex3_wait_fence;                
output  [`WK_PA_WIDTH-7  :0]                                lda_ex3_idx;   // 8 -> 34 @lishuo                         
output  [IID_WIDTH-1:0]                                     lda_ex3_iid;                           
output                                                      lda_ex3_inst_fof;                      
output  [2  :0]                                             lda_ex3_inst_size;                     
output                                                      lda_ex3_inst_vfls;                     
output                                                      lda_ex3_inst_vld;                      
output                                                      lda_ex3_inst_vls;                      
output  [PC_LEN-1:0]                                        lda_pfu_ex3_ldfifo_pc;                     
output                                                      lda_lfb_ex3_discard_grnt;              
output                                                      lda_lfb_set_wakeup_queue;          
output                                                      lda_lfb_wakeup_queue_gate;     
output  [LSIQENTRY:0]                                       lda_lfb_ex3_wakeup_queue_next;         
output                                                      lda_lm_ex3_discard_grnt;               
output                                                      lda_lm_ex3_ecc_err;                    
output                                                      lda_lm_ex3_lr_no_restart;              
output                                                      lda_lm_ex3_lr_no_restart_dp;           
output                                                      lda_lm_ex3_no_req;                     
output                                                      lda_lm_ex3_vector_nop;                 
output  [LQENTRY-1:0]                                       lda_ex3_lq_entry_pop;                  
output  [LSIQENTRY-1:0]                                     lda_ex3_lsid;                          
output                                                      lda_mcic_ex3_borrow_mmu;               
output                                                      lda_mcic_ex3_borrow_mmu_req;           
output  [63 :0]                                             lda_mcic_ex3_bypass_data;              
output                                                      lda_mcic_ex3_data_err;                 
output                                                      lda_mcic_ex3_rb_full;                  
output                                                      lda_mcic_ex3_wakeup;                   
output                                                      lda_ex3_old;                           
output                                                      lda_ex3_page_buf;                      
output                                                      lda_ex3_page_ca;                       
output                                                      lda_ex3_page_sec;                      
output                                                      lda_pfu_ex3_page_sec_ff;                   
output                                                      lda_ex3_page_share;                    
output                                                      lda_pfu_ex3_page_share_ff;                 
output                                                      lda_ex3_page_so;                       
output                                                      lda_pfu_ex3_awk_dp_vld;                
output                                                      lda_pfu_ex3_awk_vld;                   
output                                                      lda_pfu_ex3_biu_req_hit_idx;           
output                                                      lda_pfu_ex3_eviwk_cnt_vld ;             
output                                                      lda_pfu_ex3_pf_inst_vld;               
output  [`WK_PA_WIDTH-1:0]                                  lda_pfu_ex3_va;                        
output  [`WK_PA_WIDTH-1:0]                                  lda_ppfu_ex3_va;                       
output  [`WK_PA_WIDTH-13:0]                                 lda_pfu_ex3_ppn_ff;                        
output  [PREG-1:0]                                          lda_ex3_preg;                          
output  [3  :0]                                             lda_lwb_ex3_preg_sign_sel;                 
output                                                      lda_rb_ex3_atomic;                     
output                                                      lda_rb_ex3_cmit;                       
output                                                      lda_rb_ex3_cmplt_success;              
output                                                      lda_rb_ex3_create_dp_vld;              
output                                                      lda_rb_ex3_create_gateclk_en;          
output                                                      lda_rb_ex3_create_judge_vld;           
output                                                      lda_rb_ex3_create_lfb;                 
output                                                      lda_rb_ex3_create_vld;                 
output  [127:0]                                             lda_rb_ex3_data_ori;                   
output  [127:0]                                             lda_rb_ex3_data_ori1;                   
output  [127:0]                                             lda_rb_ex3_data_ori2;                   
output  [127:0]                                             lda_rb_ex3_data_ori3;                   
output                                                      lda_rb_ex3_data_vld;                   
output                                                      lda_rb_ex3_dest_vld;                   
output                                                      lda_rb_ex3_discard_grnt;               
output                                                      lda_rb_ex3_expt_vld;                   
output                                                      lda_rb_ex3_full_gateclk_en;            
output                                                      lda_rb_ex3_ldamo;                      
output                                                      lda_rb_ex3_merge_dp_vld;               
output                                                      lda_rb_ex3_merge_expt_vld;             
output                                                      lda_rb_ex3_merge_gateclk_en;           
output                                                      lda_rb_ex3_merge_vld;
output                                                      lda_rb_ex3_ecc_mask;                  
output  [15 :0]                                             lda_ex3_reg_bytes_vld;                 
output  [15 :0]                                             lda_ex3_reg_bytes_vld1;                 
output  [15 :0]                                             lda_ex3_reg_bytes_vld2;                 
output  [15 :0]                                             lda_ex3_reg_bytes_vld3;                 
output                                                      lda_ex3_inst_us;
output  [8  :0]                                             lda_ex3_setvl_val;                     
output  [`WK_PA_WIDTH-5:0]                                  lda_sf_ex3_addr_tto4;                  
output  [15 :0]                                             lda_sf_ex3_bytes_vld;                  
output  [IID_WIDTH-1:0]                                     lda0_sf_ex3_iid;  
output                                                      lda_sf_ex3_no_spec_miss;               
output                                                      lda_sf_ex3_no_spec_miss_gate;          
output                                                      lda_sf_ex3_spec_chk_req;               
output  [PC_LEN-1:0]                                        lda_sfp_ex3_src_pc; // wjh@sfp
output                                                      lda_ex3_sext;                   
output                                                      lda_snq_ex3_borrow_icc;                
output                                                      lda_snq_ex3_borrow_sndb;               
output                                                      lda_ex3_special_gateclk_en;            
output                                                      lda_ex3_split;                         
output                                                      lda_sq_ex3_data_discard_vld;           
output  [SQ_ENTRY-1:0]                                      lda_sq_ex3_fwd_id;                     
output                                                      lda_sq_ex3_fwd_multi_vld;              
output                                                      lda_sq_ex3_global_discard_vld;         
output                                                      lda_lsda0_ex3_hit_idx; 
output                                                      lda_lsda1_ex3_hit_idx;                  
output                                                      lda_lsda_ex3_tag_inj_mask;               
output  [2  :0]                                             lda_vb_ex3_borrow_vb;                  
output                                                      lda_vb_ex3_snq_data_reissue;           
output                                                      lda_vb_snq_ex3_ecc_err;                
// output  [1  :0]                                             lda_ex3_vlmul;          
output  [2  :0]             lda_ex3_vlmul;  //pwh 2 for rvv1.0               
output  [VMB_ENTRY-1:0]                                     lda_ex3_vmb_id;                        
output                                                      lda_ex3_vmb_merge_vld;                 
output  [VREG-1  :0]                                        lda_ex3_vreg;                          
output                                                      lda_ex3_vreg_sign_sel;                 
//output  [1  :0]                                             lda_ex3_vsew;//rvv1.0@hcl   
output  [1  :0]             lda_ex3_vmew; //rvv1.0@hcl
output  [1  :0]             lda_ex3_vmop;  //rvv1.0@hcl                      
output                                                      lda_ex3_wait_fence_gateclk_en;         
output                                                      lda_lwb_ex3_cmplt_req;                  
output                                                      lda_lwb_ex3_cmplt_req_gate;             
output  [127:0]                                             lda_lwb_ex3_data;                       
output  [127:0]                                             lda_lwb_ex3_data1;                       
output  [127:0]                                             lda_lwb_ex3_data2;                       
output  [127:0]                                             lda_lwb_ex3_data3;                       
output                                                      lda_lwb_ex3_data_req;                   
output                                                      lda_lwb_ex3_data_req_dp;                
output                                                      lda_lwb_ex3_data_req_gateclk_en;        
output  [4  :0]                                             lda_lwb_ex3_expt_vec;                   
output                                                      lda_lwb_ex3_expt_vld;                   
output                                                      lda_lwb_ex3_inst_vls;                   
output  [`WK_PA_WIDTH-1:0]                                  lda_lwb_ex3_mtval;                   
output                                                      lda_lwb_ex3_no_spec_hit;                
output                                                      lda_lwb_ex3_no_spec_mispred;            
output                                                      lda_lwb_ex3_no_spec_miss;               
output                                                      lda_lwb_ex3_no_spec_target;             
output                                                      lda_ex3_spec_fail;                  
output  [14 :0]                                             lda_lwb_ex3_vreg_sign_sel;              
output                                                      lda_lwb_ex3_vsetvl;                     
output                                                      lda_lwb_ex3_vstart_vld;                 
output                                                      lda_wmb_ex3_data_reissue;              
output                                                      lda_wmb_ex3_discard_vld;               
output  [127:0]                                             lda_wmb_ex3_read_data;                 
output                                                      lda_wmb_ex3_two_bit_err;               
output                                                      lsu_hpcp_ld_cache_access;            
output                                                      lsu_hpcp_ld_cache_miss;              
output                                                      lsu_hpcp_ld_data_discard;            
output                                                      lsu_hpcp_ld_discard_sq;              
output                                                      lsu_hpcp_ld_unalign_inst;            
output  [PREG-1:0]                                          lda_idu_ex3_fwd_preg;           
output  [63 :0]                                             lda_idu_ex3_fwd_preg_data;      
output                                                      lda_idu_ex3_fwd_preg_vld;       
output  [VREG:0]                                            lda_idu_ex3_fwd_vreg;           
output  [63 :0]                                             lda_idu_ex3_fwd_vreg_fr_data;   
output                                                      lda_idu_ex3_fwd_vreg_vld;       
output  [255 :0]                                             lda_idu_ex3_fwd_vreg_vr0_data;  
output  [255 :0]                                             lda_idu_ex3_fwd_vreg_vr1_data;  
output  [LSIQENTRY-1:0]                                     lsu_idu_ex3_wait_old;              
output                                                      lsu_idu_ex3_wait_old_gateclk_en;   
output                                                      lsu_ld_data_inj_cmplt;               
output                                                      lsu_ld_tag_inj_cmplt;                
output  [IID_WIDTH-1:0]                                     lsu_rtu_ex3_ssf_iid; 
output                                                      lsu_rtu_ex3_ssf_vld;

output                                                      lda_ex2_ecc_stall; // @zdb

// &Regs; @30
reg     [`WK_PA_WIDTH-1 :0]                                 lda_addr0;                         
reg     [`WK_PA_WIDTH-7 :0]                                 ld_da_addr0_idx;                     
reg                                                         ld_da_ahead_predict;                 
reg                                                         lda_ahead_preg_wb_vld;             
reg                                                         lda_ahead_vreg_wb_vld;             
reg                                                         ld_da_already_da;                    
reg                                                         ld_da_atomic;                                          
reg   [VB_DATA_ENTRY-1  :0]                                 ld_da_borrow_db;                     
reg                                                         lda_borrow_icc;                    
reg                                                         ld_da_borrow_icc_ecc;                
reg                                                         ld_da_borrow_icc_tag;                
reg     [1  :0]                                             ld_da_borrow_idx_5to4;               
reg                                                         lda_borrow_mmu;                    
reg                                                         lda_borrow_prq;                    
reg                                                         ld_da_borrow_sndb;                   
reg                                                         ld_da_borrow_vb;                     
reg                                                         lda_ex3_borrow_vld;                    
reg                                                         lda_borrow_wmb;                    
reg                                                         ld_da_boundary;                      
reg                                                         lda_ex3_boundary_after_mask_ff;        
reg     [15 :0]                                             lda_ex3_bytes_vld;                     
reg     [15 :0]                                             lda_ex3_bytes_vld1;                    
reg     [15 :0]                                             lda_ex3_bytes_vld2;                    
reg     [15 :0]                                             lda_ex3_bytes_vld3;                    
reg                                                         ld_da_cb_addr_create;                
reg                                                         ld_da_cb_merge_en;                   
reg                                                         ld_da_data_discard_sq;               
reg     [127:0]                                             ld_da_data_ff;                       
reg     [127:0]                                             ld_da_data_ff1;                       
reg     [127:0]                                             ld_da_data_ff2;                       
reg     [127:0]                                             ld_da_data_ff3;                       
reg                                                         lda_data_inj_vld;                  
reg     [15 :0]                                             lda_ex3_data_rot_sel;                  
reg                                                         ld_da_data_vld_newest_fwd_sq_dup0;   
reg                                                         ld_da_data_vld_newest_fwd_sq_dup1;   
reg                                                         ld_da_data_vld_newest_fwd_sq_dup2;   
reg                                                         ld_da_data_vld_newest_fwd_sq_dup3;   
reg     [31 :0]                                             ld_da_dcache_data_ahead_bank0;       
reg     [31 :0]                                             ld_da_dcache_data_ahead_bank1;       
reg     [31 :0]                                             ld_da_dcache_data_ahead_bank2;       
reg     [31 :0]                                             ld_da_dcache_data_ahead_bank3;       
reg     [31 :0]                                             ld_da_dcache_data_ahead_bank4;       
reg     [31 :0]                                             ld_da_dcache_data_ahead_bank5;       
reg     [31 :0]                                             ld_da_dcache_data_ahead_bank6;       
reg     [31 :0]                                             ld_da_dcache_data_ahead_bank7;       
reg     [31 :0]                                             ld_da_dcache_data_ahead_bank8;        
reg     [31 :0]                                             ld_da_dcache_data_ahead_bank9;        
reg     [31 :0]                                             ld_da_dcache_data_ahead_bank10;       
reg     [31 :0]                                             ld_da_dcache_data_ahead_bank11;       
reg     [31 :0]                                             ld_da_dcache_data_ahead_bank12;       
reg     [31 :0]                                             ld_da_dcache_data_ahead_bank13;       
reg     [31 :0]                                             ld_da_dcache_data_ahead_bank14;       
reg     [31 :0]                                             ld_da_dcache_data_ahead_bank15;
reg     [38 :0]                                             lda_dcache_data_bank0;             
reg     [38 :0]                                             lda_dcache_data_bank1;             
reg     [38 :0]                                             lda_dcache_data_bank2;             
reg     [38 :0]                                             lda_dcache_data_bank3;             
reg     [38 :0]                                             lda_dcache_data_bank4;             
reg     [38 :0]                                             lda_dcache_data_bank5;             
reg     [38 :0]                                             lda_dcache_data_bank6;             
reg     [38 :0]                                             lda_dcache_data_bank7;
reg     [38 :0]                                             lda_dcache_data_bank8;             
reg     [38 :0]                                             lda_dcache_data_bank9;             
reg     [38 :0]                                             lda_dcache_data_bank10;             
reg     [38 :0]                                             lda_dcache_data_bank11;             
reg     [38 :0]                                             lda_dcache_data_bank12;             
reg     [38 :0]                                             lda_dcache_data_bank13;             
reg     [38 :0]                                             lda_dcache_data_bank14;             
reg     [38 :0]                                             lda_dcache_data_bank15;             
reg                                                         lda_ex3_dcache_hit;                    
reg                                                         ld_da_discard_wmb;                   
reg                                                         lda_dtcm_hit;                      
reg                                                         lda_ecc_stall_already;             
reg                                                         lda_ecc_stall_cb_merge;            
reg                                                         lda_ecc_stall_data;                
reg                                                         lda_ecc_stall_fatal;               
reg     [3  :0]                                             lda_ecc_stall_tag_way;             
reg     [LSIQENTRY :0]                                      lda_ecc_wakeup_queue;              
reg     [8  :0]                                             lda_ex3_element_cnt;                   
reg     [1  :0]                                             lda_ex3_element_size;                  
reg                                                         ld_da_expt_access_fault_extra;       
reg                                                         ld_da_expt_access_fault_mask;        
reg                                                         ld_da_expt_access_fault_mmu;         
reg     [4  :0]                                             ld_da_expt_vec;                      
reg                                                         ld_da_expt_vld_except_access_err;    
reg                                                         ld_da_fwd_bypass_sq_multi;           
reg     [15 :0]                                             ld_da_fwd_bytes_vld;                 
reg     [15 :0]                                             ld_da_fwd_bytes_vld_dup;                            
reg                                                         ld_da_fwd_sq_bypass;  
reg                                                         lda_fwd_bypass_sel;               
reg                                                         ld_da_fwd_sq_multi;                  
reg                                                         ld_da_fwd_sq_multi_mask;             
reg                                                         ld_da_fwd_sq_vld;                    
reg                                                         ld_da_fwd_wmb_vld;                   
reg     [3  :0]                                             lda_get_dcache_data;               
//reg                         ld_da_hit_high_region;               
//reg                         ld_da_hit_high_region_dup0;          
//reg                         ld_da_hit_high_region_dup1;          
//reg                         ld_da_hit_high_region_dup2;          
//reg                         ld_da_hit_high_region_dup3;          
//reg                         ld_da_hit_low_region;                
//reg                         ld_da_hit_low_region_dup0;           
//reg                         ld_da_hit_low_region_dup1;           
//reg                         ld_da_hit_low_region_dup2;           
//reg                         ld_da_hit_low_region_dup3;     
reg                                                         ld_da_hit_0_region;         
reg                                                         ld_da_hit_0_region_dup0;    
reg                                                         ld_da_hit_0_region_dup1;    
reg                                                         ld_da_hit_0_region_dup2;    
reg                                                         ld_da_hit_0_region_dup3;    
reg                                                         ld_da_hit_1_region;          
reg                                                         ld_da_hit_1_region_dup0;     
reg                                                         ld_da_hit_1_region_dup1;     
reg                                                         ld_da_hit_1_region_dup2;     
reg                                                         ld_da_hit_1_region_dup3;  
reg                                                         ld_da_hit_2_region;         
reg                                                         ld_da_hit_2_region_dup0;    
reg                                                         ld_da_hit_2_region_dup1;    
reg                                                         ld_da_hit_2_region_dup2;    
reg                                                         ld_da_hit_2_region_dup3;    
reg                                                         ld_da_hit_3_region;          
reg                                                         ld_da_hit_3_region_dup0;     
reg                                                         ld_da_hit_3_region_dup1;     
reg                                                         ld_da_hit_3_region_dup2;     
reg                                                         ld_da_hit_3_region_dup3;          
//reg                         ld_da_hit_way0;
reg     [3  :0]                                             ld_da_hit_way;                      
reg     [IID_WIDTH-1:0]                                     lda_ex3_iid;                           
reg                                                         lda_ex3_inst_fof;                      
reg     [2  :0]                                             lda_ex3_inst_size;                     
reg     [1  :0]                                             ld_da_inst_type;                     
reg                                                         lda_ex3_inst_vfls;                     
reg                                                         lda_ex3_inst_vld;                      
reg                                                         lda_ex3_inst_vls;                      
reg                                                         lda_itcm_hit;                      
reg     [PC_LEN-1:0]                                        lda_pfu_ex3_ldfifo_pc;                     
reg     [LQENTRY-1:0]                                       ld_da_lq_entry;                      
reg     [LSIQENTRY-1:0]                                     lda_ex3_lsid;                          
reg                                                         ld_da_mmu_req;                       
reg     [`WK_PA_WIDTH-1:0]                                  ld_da_mt_value;                      
reg     [1  :0]                                             ld_da_no_spec;                       
reg                                                         ld_da_no_spec_exist;                 
reg                                                         lda_ex3_old;                           
reg                                                         ld_da_other_discard_sq;              
reg                                                         lda_ex3_page_buf;                      
reg                                                         lda_ex3_page_ca;                       
reg                                                         lda_ex3_page_sec;                      
reg                                                         lda_pfu_ex3_page_sec_ff;                   
reg                                                         lda_ex3_page_share;                    
reg                                                         lda_pfu_ex3_page_share_ff;                 
reg                                                         lda_ex3_page_so;                       
reg                                                         ld_da_pf_inst;                       
reg     [`WK_PA_WIDTH-1:0]                                  lda_pfu_ex3_va;                        
reg     [`WK_PA_WIDTH-1:0]                                  lda_ppfu_ex3_va;                       
reg     [`WK_PA_WIDTH-13:0]                                 lda_pfu_ex3_ppn_ff;                        
reg     [PREG-1:0]                                          lda_ex3_preg;                          
reg     [63 :0]                                             ld_da_preg_data_sign_extend;         
reg     [3  :0]                                             lda_lwb_ex3_preg_sign_sel;                 
reg     [15 :0]                                             lda_ex3_reg_bytes_vld;                 
reg     [15 :0]                                             lda_ex3_reg_bytes_vld1;                 
reg     [15 :0]                                             lda_ex3_reg_bytes_vld2;                 
reg     [15 :0]                                             lda_ex3_reg_bytes_vld3;                 
reg                                                         lda_ex3_inst_us;
reg                                                         lda_ex3_us_discard;
wire                                                        ld_da_us_discard_req;
reg                                                         ld_da_secd;                          
reg     [1  :0]                                             ld_da_settle_way;    //L1D 2->4 way, LTL@20250320                
reg     [8  :0]                                             lda_ex3_setvl_val;                     
reg                                                         lda_ex3_sext;                   
reg                                                         ld_da_spec_fail;                     
reg                                                         lda_ex3_split;                         
reg                                                         ld_da_split_miss_ff;                 
reg     [SQ_ENTRY-1:0]                                      lda_sq_ex3_fwd_id;                     
reg     [`WK_LS_DCACHE_LDTAG_QUADRUPLE_BF_ECC_LENGTH-1:0]   lda_tag_corrected_f; //53->107, L1D 2->4way, LTL@20250322              
reg                                                         lda_tag_inj_vld;                   
reg     [`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0]              ld_da_tag_read;                      
reg                                                         ld_da_vector_nop;                    
// reg     [1  :0]                                             lda_ex3_vlmul;          
reg     [2  :0]             lda_ex3_vlmul;                
reg     [VMB_ENTRY-1:0]                                     lda_ex3_vmb_id;                        
reg                                                         lda_ex3_vmb_merge_vld;                 
reg     [VREG-1  :0]                                        lda_ex3_vreg;                          
reg                                                         lda_ex3_vreg_sign_sel;                 
//reg     [1  :0]                                             lda_ex3_vsew;//rvv1.0 @hcl   
reg     [1  :0]             lda_ex3_vmew;//rvv1.0 @hcl 
reg     [1  :0]             lda_ex3_vmop;//rvv1.0 @hcl                        
reg                                                         ld_da_wait_fence;                    
reg     [PC_LEN-1:0]                                        lda_sfp_ex3_src_pc; // wjh@sfp
reg     [4  :0]                                             lda_lwb_ex3_expt_vec;                   
reg     [`WK_PA_WIDTH-1:0]                                  ld_da_wb_mt_value_ori;               
reg     [14 :0]                                             lda_lwb_ex3_vreg_sign_sel; 
reg     [127:0]                                             ld_da_fwd_data_bypass0;
reg     [127:0]                                             ld_da_fwd_data_bypass1;             
reg     [1  :0]                                             ld_da_hit_way_2bit;
reg     [511:0]                                             lda_vb_ex3_data512;
reg                                                         ld_da_ecc_hit_0_region;
reg                                                         ld_da_ecc_hit_1_region;
reg                                                         ld_da_ecc_hit_2_region;
reg                                                         ld_da_ecc_hit_3_region;
reg     [127:0]                                             lda_wmb_ex3_read_data;
reg     [1  :0]                                             ecc_info_way_compare_2bit;
reg     [`WK_PA_WIDTH-1:0]                                  tag_ecc_addr;
reg     [127:0]                                             icc_read_data;
reg     [27 :0]                                             icc_read_ecc;
// &Wires; @31
wire    [127:0]                                             cb_ld_da_data;                       
wire                                                        cb_ld_da_data_vld;                   
wire                                                        cp0_lsu_data_ecc_inj;                
wire    [38 :0]                                             cp0_lsu_data_random;                 
wire                                                        cp0_lsu_dcache_en;                   
wire    [16 :0]                                             cp0_lsu_dcache_read_index;           
wire                                                        cp0_lsu_ecc_en;                      
wire                                                        cp0_lsu_icg_en;                      
wire                                                        cp0_lsu_l2_pref_en;                  
wire                                                        cp0_lsu_nsfe;                        
wire                                                        cp0_lsu_tag_ecc_inj;                 
wire    [`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0]              cp0_lsu_tag_random0;                 
wire    [`VSTART_WIDTH-1  :0]                                             cp0_lsu_vstart;                      
wire                                                        cp0_yy_dcache_pref_en;               
wire                                                        cpurst_b;                            
wire                                                        ctrl_ld_clk;                         
wire    [38 :0]                                             data_bank0_bf_ecc;                   
wire    [31 :0]                                             data_bank0_corrected;                
wire                                                        data_bank0_ecc_err;                  
wire                                                        data_bank0_ecc_vld;                  
wire                                                        data_bank0_ham_error;                
wire                                                        data_bank0_parity_error;             
wire    [38 :0]                                             data_bank1_bf_ecc;                   
wire    [31 :0]                                             data_bank1_corrected;                
wire                                                        data_bank1_ecc_err;                  
wire                                                        data_bank1_ecc_vld;                  
wire                                                        data_bank1_ham_error;                
wire                                                        data_bank1_parity_error;             
wire    [38 :0]                                             data_bank2_bf_ecc;                   
wire    [31 :0]                                             data_bank2_corrected;                
wire                                                        data_bank2_ecc_err;                  
wire                                                        data_bank2_ecc_vld;                  
wire                                                        data_bank2_ham_error;                
wire                                                        data_bank2_parity_error;             
wire    [38 :0]                                             data_bank3_bf_ecc;                   
wire    [31 :0]                                             data_bank3_corrected;                
wire                                                        data_bank3_ecc_err;                  
wire                                                        data_bank3_ecc_vld;                  
wire                                                        data_bank3_ham_error;                
wire                                                        data_bank3_parity_error;             
wire    [38 :0]                                             data_bank4_bf_ecc;                   
wire    [31 :0]                                             data_bank4_corrected;                
wire                                                        data_bank4_ecc_err;                  
wire                                                        data_bank4_ecc_vld;                  
wire                                                        data_bank4_ham_error;                
wire                                                        data_bank4_parity_error;             
wire    [38 :0]                                             data_bank5_bf_ecc;                   
wire    [31 :0]                                             data_bank5_corrected;                
wire                                                        data_bank5_ecc_err;                  
wire                                                        data_bank5_ecc_vld;                  
wire                                                        data_bank5_ham_error;                
wire                                                        data_bank5_parity_error;             
wire    [38 :0]                                             data_bank6_bf_ecc;                   
wire    [31 :0]                                             data_bank6_corrected;                
wire                                                        data_bank6_ecc_err;                  
wire                                                        data_bank6_ecc_vld;                  
wire                                                        data_bank6_ham_error;                
wire                                                        data_bank6_parity_error;             
wire    [38 :0]                                             data_bank7_bf_ecc;                   
wire    [31 :0]                                             data_bank7_corrected;                
wire                                                        data_bank7_ecc_err;                  
wire                                                        data_bank7_ecc_vld;                  
wire                                                        data_bank7_ham_error;                
wire                                                        data_bank7_parity_error; 
wire    [38 :0]                                             data_bank8_bf_ecc;                   
wire    [31 :0]                                             data_bank8_corrected;                
wire                                                        data_bank8_ecc_err;                  
wire                                                        data_bank8_ecc_vld;                  
wire                                                        data_bank8_ham_error;                
wire                                                        data_bank8_parity_error;             
wire    [38 :0]                                             data_bank9_bf_ecc;                   
wire    [31 :0]                                             data_bank9_corrected;                
wire                                                        data_bank9_ecc_err;                  
wire                                                        data_bank9_ecc_vld;                  
wire                                                        data_bank9_ham_error;                
wire                                                        data_bank9_parity_error;             
wire    [38 :0]                                             data_bank10_bf_ecc;                   
wire    [31 :0]                                             data_bank10_corrected;                
wire                                                        data_bank10_ecc_err;                  
wire                                                        data_bank10_ecc_vld;                  
wire                                                        data_bank10_ham_error;                
wire                                                        data_bank10_parity_error;             
wire    [38 :0]                                             data_bank11_bf_ecc;                   
wire    [31 :0]                                             data_bank11_corrected;                
wire                                                        data_bank11_ecc_err;                  
wire                                                        data_bank11_ecc_vld;                  
wire                                                        data_bank11_ham_error;                
wire                                                        data_bank11_parity_error;             
wire    [38 :0]                                             data_bank12_bf_ecc;                   
wire    [31 :0]                                             data_bank12_corrected;                
wire                                                        data_bank12_ecc_err;                  
wire                                                        data_bank12_ecc_vld;                  
wire                                                        data_bank12_ham_error;                
wire                                                        data_bank12_parity_error;             
wire    [38 :0]                                             data_bank13_bf_ecc;                   
wire    [31 :0]                                             data_bank13_corrected;                
wire                                                        data_bank13_ecc_err;                  
wire                                                        data_bank13_ecc_vld;                  
wire                                                        data_bank13_ham_error;                
wire                                                        data_bank13_parity_error;             
wire    [38 :0]                                             data_bank14_bf_ecc;                   
wire    [31 :0]                                             data_bank14_corrected;                
wire                                                        data_bank14_ecc_err;                  
wire                                                        data_bank14_ecc_vld;                  
wire                                                        data_bank14_ham_error;                
wire                                                        data_bank14_parity_error;             
wire    [38 :0]                                             data_bank15_bf_ecc;                   
wire    [31 :0]                                             data_bank15_corrected;                
wire                                                        data_bank15_ecc_err;                  
wire                                                        data_bank15_ecc_vld;                  
wire                                                        data_bank15_ham_error;                
wire                                                        data_bank15_parity_error;             
wire                                                        data_3_region_ecc_err;            
wire                                                        data_3_region_ecc_vld;            
wire                                                        data_2_region_ecc_err;             
wire                                                        data_2_region_ecc_vld;
wire                                                        data_1_region_ecc_err;            
wire                                                        data_1_region_ecc_vld;            
wire                                                        data_0_region_ecc_err;             
wire                                                        data_0_region_ecc_vld;             
wire    [38 :0]                                             dcache_data_bank0;                   
wire    [38 :0]                                             dcache_data_bank1;                   
wire    [38 :0]                                             dcache_data_bank2;                   
wire    [38 :0]                                             dcache_data_bank3;                   
wire    [38 :0]                                             dcache_data_bank4;                   
wire    [38 :0]                                             dcache_data_bank5;                   
wire    [38 :0]                                             dcache_data_bank6;                   
wire    [38 :0]                                             dcache_data_bank7; 
wire    [38 :0]                                             dcache_data_bank8;                   
wire    [38 :0]                                             dcache_data_bank9;                   
wire    [38 :0]                                             dcache_data_bank10;                   
wire    [38 :0]                                             dcache_data_bank11;                   
wire    [38 :0]                                             dcache_data_bank12;                   
wire    [38 :0]                                             dcache_data_bank13;                   
wire    [38 :0]                                             dcache_data_bank14;                   
wire    [38 :0]                                             dcache_data_bank15;                   
wire    [`WK_LS_DCACHE_LDTAG_WIDTH-1:0]                     dcache_ld_tag_dout;     //L1D 67->135, LTL@20250323             
wire    [38 :0]                                             dcache_lsu_ld_data_bank0_dout;       
wire    [38 :0]                                             dcache_lsu_ld_data_bank1_dout;       
wire    [38 :0]                                             dcache_lsu_ld_data_bank2_dout;       
wire    [38 :0]                                             dcache_lsu_ld_data_bank3_dout;       
wire    [38 :0]                                             dcache_lsu_ld_data_bank4_dout;       
wire    [38 :0]                                             dcache_lsu_ld_data_bank5_dout;       
wire    [38 :0]                                             dcache_lsu_ld_data_bank6_dout;       
wire    [38 :0]                                             dcache_lsu_ld_data_bank7_dout; 
wire    [38 :0]                                             dcache_lsu_ld_data_bank8_dout; //8bank_data->16 bank_data, L1D 2way->4way, LTL@20250320       
wire    [38 :0]                                             dcache_lsu_ld_data_bank9_dout;       
wire    [38 :0]                                             dcache_lsu_ld_data_bank10_dout;       
wire    [38 :0]                                             dcache_lsu_ld_data_bank11_dout;       
wire    [38 :0]                                             dcache_lsu_ld_data_bank12_dout;       
wire    [38 :0]                                             dcache_lsu_ld_data_bank13_dout;       
wire    [38 :0]                                             dcache_lsu_ld_data_bank14_dout;       
wire    [38 :0]                                             dcache_lsu_ld_data_bank15_dout;       
wire    [`WK_LS_DCACHE_LDTAG_WIDTH-1:0]                     dcache_lsu_ld_tag_dout;              
wire                                                        dtcm_1bit_err;                       
wire    [127:0]                                             dtcm_rdata;                          
wire                                                        ecc_info_fatal;                      
wire    [16 :0]                                             ecc_info_index;                      
wire    [2  :0]                                             ecc_info_ramid;                      
wire                                                        ecc_info_update;                     
wire    [1  :0]                                             ecc_info_way;                        
wire    [3  :0]                                             ecc_info_way_compare;                
wire    [`WK_PA_WIDTH-1:0]                                  ecc_pa;                              
wire                                                        forever_cpuclk;                                                                     
wire                                                        itcm_1bit_err;                       
wire    [127:0]                                             itcm_rdata;                          
wire    [`WK_PA_WIDTH-1:0]                                  lda_ex3_addr;                          
wire    [1  :0]                                             lda_ex3_addr_5to4;                     
wire    [127:0]                                             ld_da_ahead_preg_data_settle;        
wire    [63 :0]                                             ld_da_ahead_preg_data_sign0;         
wire    [63 :0]                                             ld_da_ahead_preg_data_sign1;         
wire    [63 :0]                                             ld_da_ahead_preg_data_sign2;         
wire    [63 :0]                                             ld_da_ahead_preg_data_sign3;         
wire    [127:0]                                             ld_da_ahead_preg_data_unsettle;      
wire                                                        lda_borrow_clk;                    
wire                                                        lda_borrow_clk_en;                 
wire                                                        ld_da_borrow_db_vld;                 
wire                                                        lda_ex3_boundary_after_mask;           
wire                                                        ld_da_boundary_cross_2k;             
wire    [127:0]                                             ld_da_boundary_data;                 
wire                                                        ld_da_boundary_first;                
wire    [127:0]                                             ld_da_bytes_vld_ext;                 
wire    [127:0]                                             ld_da_cb_bypass_data_am;             
wire    [127:0]                                             ld_da_cb_bypass_data_for_merge;      
//wire    [127:0]             ld_da_cb_data;                       
wire                                                        ld_da_cb_data_vld;                   
wire                                                        ld_da_cb_ecc_cancel;                 
wire                                                        ld_da_cb_ld_inst_vld;                
wire                                                        lda_clk;                           
wire                                                        lda_clk_en;                        
wire                                                        ld_da_cmit_hit0;                     
wire                                                        ld_da_cmit_hit1;                     
wire                                                        ld_da_cmit_hit2; 
wire                                                        ld_da_cmit_hit3;                     
wire                                                        ld_da_cmit_hit4;                     
wire                                                        ld_da_cmit_hit5; 
wire                                                        ld_da_cmit_hit6;                     
wire                                                        ld_da_cmit_hit7;                     
wire    [`WK_PA_WIDTH-1:0]                                  ld_da_cmp_pfu_biu_req_addr;          
wire    [`WK_PA_WIDTH-1:0]                                  lda_cmp_lsda0_addr;
wire    [`WK_PA_WIDTH-1:0]                                  lda_cmp_lsda1_addr;                  
wire                                                        ld_da_data0_clk;                     
wire                                                        lda_data0_clk_en;                  
wire    [127:0]                                             ld_da_data128;                       
wire                                                        ld_da_data128_ecc_err;               
wire                                                        ld_da_data128_ecc_vld;               
wire                                                        lda_data1_clk;                     
wire                                                        lda_data1_clk_en;                                         
wire                                                        lda_data256_ecc_err;               
wire                                                        ld_da_data256_ecc_vld;               
wire    [511:0]                                             lda_data512_way0;                  
wire    [511:0]                                             lda_data512_way0_aft_ecc;          
wire    [511:0]                                             lda_data512_way0_corrected;        
wire    [511:0]                                             lda_data512_way1;                  
wire    [511:0]                                             lda_data512_way1_aft_ecc;          
wire    [511:0]                                             lda_data512_way1_corrected; 
wire    [511:0]                                             lda_data512_way2;                  
wire    [511:0]                                             lda_data512_way2_aft_ecc;          
wire    [511:0]                                             lda_data512_way2_corrected;        
wire    [511:0]                                             lda_data512_way3;                  
wire    [511:0]                                             lda_data512_way3_aft_ecc;          
wire    [511:0]                                             lda_data512_way3_corrected;        
wire                                                        lda_data2_clk;                     
wire                                                        lda_data2_clk_en;                  
wire                                                        lda_data3_clk;                     
wire                                                        lda_data3_clk_en;                  
wire    [127:0]                                             ld_da_data_aft_merge;                
wire                                                        ld_da_data_delay_gate;               
wire                                                        ld_da_data_delay_vld;                
wire                                                        ld_da_data_discard_sq_final;         
wire                                                        ld_da_data_discard_sq_req;           
wire                                                        ld_da_data_ecc_err;                  
wire                                                        lda_data_ecc_stall;                
wire                                                        ld_da_data_ecc_stall_gate;           
wire                                                        ld_da_data_ecc_stall_ori;            
wire                                                        ld_da_data_ecc_vld;                  
wire                                                        ld_da_data_ff_clk;                   
wire                                                        ld_da_data_ff_clk_en;                
wire    [127:0]                                             ld_da_data_for_save;                 
wire    [127:0]                                             ld_da_data_for_save1;                 
wire    [127:0]                                             ld_da_data_for_save2;                 
wire    [127:0]                                             ld_da_data_for_save3;                 
wire                                                        ld_da_data_rb_restart;               
wire    [127:0]                                             ld_da_data_settle;                   
wire    [127:0]                                             ld_da_data_unrot;                    
wire                                                        ld_da_data_vld;                      
wire    [127:0]                                             ld_da_dcache_data128_ahead_am;       
wire    [127:0]                                             ld_da_dcache_data_after_merge;       
wire                                                        ld_da_dcache_miss;                   
wire    [127:0]                                             ld_da_dcache_pass_data128_ahead_am;  
wire    [127:0]                                             ld_da_dcache_pass_data128_am;        
wire    [`WK_LS_DCACHE_LDTAG_QUADRUPLE_BF_ECC_LENGTH-1:0]   lda_dcache_tag_corrected; //53->107, L1D 2->4way, LTL@20250322         
wire                                                        ld_da_depd_rb;                       
wire                                                        ld_da_discard_dc_req;                
wire                                                        ld_da_discard_from_lfb_req;          
wire                                                        ld_da_discard_from_lm_req;           
wire                                                        ld_da_discard_from_rb_req;           
wire                                                        ld_da_discard_wmb_final;             
wire                                                        ld_da_discard_wmb_req;               
wire    [38 :0]                                             lda_ecc_data_bank0;                
wire    [38 :0]                                             lda_ecc_data_bank1;                
wire    [38 :0]                                             lda_ecc_data_bank2;                
wire    [38 :0]                                             lda_ecc_data_bank3;                
wire    [38 :0]                                             lda_ecc_data_bank4;                
wire    [38 :0]                                             lda_ecc_data_bank5;                
wire    [38 :0]                                             lda_ecc_data_bank6;                
wire    [38 :0]                                             lda_ecc_data_bank7;
wire    [38 :0]                                             lda_ecc_data_bank8;                
wire    [38 :0]                                             lda_ecc_data_bank9;                
wire    [38 :0]                                             lda_ecc_data_bank10;                
wire    [38 :0]                                             lda_ecc_data_bank11;                
wire    [38 :0]                                             lda_ecc_data_bank12;                
wire    [38 :0]                                             lda_ecc_data_bank13;                
wire    [38 :0]                                             lda_ecc_data_bank14;                
wire    [38 :0]                                             lda_ecc_data_bank15;                 
wire                                                        ld_da_ecc_data_req_mask;             
wire                                                        ld_da_ecc_dcache_hit;                
wire                                                        lda_ecc_fatal;                     
//wire                        ld_da_ecc_hit_high_region;           
//wire                        ld_da_ecc_hit_low_region;  
wire                                                        ld_da_ecc_hit_way0;                  
wire                                                        ld_da_ecc_hit_way1;
wire                                                        ld_da_ecc_hit_way2;                  
wire                                                        ld_da_ecc_hit_way3;                  
wire    [22 :0]                                             lda_ecc_ex3_info;                      
wire                                                        lda_ecc_ex3_info_update;               
wire                                                        lda_ecc_ex3_info_update_gate;          
wire                                                        ld_da_ecc_mcic_wakup;                
wire    [`WK_PA_WIDTH-1:0]                                  lda_ecc_ex3_pa;                        
wire                                                        ld_da_ecc_spec_fail;                 
wire                                                        lda_ecc_stall;                     
wire                                                        lda_ecc_stall_clk;                 
wire                                                        lda_ecc_stall_clk_en;              
wire                                                        lda_ecc_stall_gate;                
wire                                                        ld_da_ecc_stall_tag_fatal;           
wire    [3  :0]                                             lda_ecc_tag_way;                   
wire    [LSIQENTRY-1:0]                                     lda_ex3_ecc_wakeup;                    
wire                                                        ld_da_expt_access_fault;             
wire                                                        lda_expt_clk;                      
wire                                                        lda_expt_clk_en;                   
wire                                                        ld_da_expt_ori;                      
wire                                                        ld_da_expt_vld;                      
wire                                                        ld_da_ff_clk;                        
wire                                                        ld_da_ff_clk_en;                     
wire                                                        ld_da_fof_not_first;                 
wire    [127:0]                                             ld_da_fwd_data_am;                   
wire    [127:0]                                             ld_da_fwd_data_pe_am;                
wire                                                        lda_ex3_fwd_ecc_stall;                 
wire                                                        ld_da_fwd_no_cache;                  
wire                                                        ld_da_fwd_sq_bypass_vld;          
wire    [127:0]                                             ld_da_fwd_sq_data_am;                
wire    [127:0]                                             ld_da_fwd_sq_data_pe_am;             
wire                                                        ld_da_fwd_sq_multi_final;            
wire                                                        ld_da_fwd_sq_multi_req;              
wire                                                        ld_da_fwd_vld;                       
wire    [127:0]                                             ld_da_fwd_wmb_data_am; 
wire    [127:0]                                             ld_da_3_region_data128_ahead_am;
wire    [127:0]                                             ld_da_2_region_data128_ahead_am;
wire    [127:0]                                             ld_da_1_region_data128_ahead_am;
wire    [127:0]                                             ld_da_0_region_data128_ahead_am;
wire    [127:0]                                             ld_da_3_region_data128_am;
wire    [127:0]                                             ld_da_2_region_data128_am;
wire    [127:0]                                             ld_da_1_region_data128_am;
wire    [127:0]                                             ld_da_0_region_data128_am;
//wire    [127:0]             ld_da_high_region_data128_ahead_am;  
//wire    [127:0]             ld_da_high_region_data128_am;        
wire                                                        ld_da_hit_high_ecc;                  
wire                                                        ld_da_hit_idx_discard_req;           
wire                                                        ld_da_hit_idx_discard_vld;           
wire                                                        ld_da_hit_low_ecc;                   
wire    [127:0]                                             ld_da_icc_data_read;                 
wire    [127:0]                                             lda_icc_ex3_read_data;                 
wire    [127:0]                                             ld_da_icc_tag_read;                  
wire    [LSIQENTRY-1:0]                                     lda_idu_ex3_already_da;                            
wire    [LSIQENTRY-1:0]                                     lda_idu_ex3_boundary_gateclk_en;       
wire                                                        ld_da_idu_boundary_gateclk_vld;      
wire    [LSIQENTRY-1:0]                                     lda_idu_ex3_pop_entry;                 
wire                                                        lda_idu_ex3_pop_vld;                   
wire    [LSIQENTRY-1:0]                                     lda_idu_ex3_rb_full;                   
wire    [LSIQENTRY-1:0]                                     lda_idu_ex3_secd;                      
wire    [LSIQENTRY-1:0]                                     lda_idu_ex3_us_restart;
wire                                                        ld_da_idu_secd_vld;                  
wire    [LSIQENTRY-1:0]                                     lda_idu_ex3_spec_fail;                 
wire    [LSIQENTRY-1:0]                                     lda_idu_ex3_wait_fence;                
wire    [`WK_PA_WIDTH-7 :0]                                 lda_ex3_idx;                           
wire                                                        lda_inst_clk;                      
wire                                                        lda_inst_clk_en;                   
wire                                                        ld_da_inst_cmplt;                    
wire                                                        ld_da_ld_inst;                       
wire                                                        ld_da_ldamo_inst;                    
wire                                                        lda_lfb_ex3_discard_grnt;              
wire                                                        lda_lfb_set_wakeup_queue;          
wire                                                        lda_lfb_wakeup_queue_gate;     
wire    [LSIQENTRY :0]                                      lda_lfb_ex3_wakeup_queue_next;         
wire                                                        lda_lm_ex3_discard_grnt;               
wire                                                        lda_lm_ex3_ecc_err;                    
wire                                                        lda_lm_ex3_lr_no_restart;              
wire                                                        lda_lm_ex3_lr_no_restart_dp;           
wire                                                        lda_lm_ex3_no_req;                     
wire                                                        lda_lm_ex3_vector_nop;                 
//wire    [127:0]             ld_da_low_region_data128_ahead_am;   //L1D 2way->4 way, LTL@20250320
//wire    [127:0]             ld_da_low_region_data128_am;         
wire    [LQENTRY-1:0]                                       lda_ex3_lq_entry_pop;                  
wire                                                        ld_da_lq_pop_vld;                    
wire                                                        ld_da_lr_inst;                       
wire    [LSIQENTRY-1:0]                                     ld_da_mask_lsid;                     
wire                                                        lda_mcic_ex3_borrow_mmu;               
wire                                                        lda_mcic_ex3_borrow_mmu_req;           
wire    [63 :0]                                             lda_mcic_ex3_bypass_data;              
wire    [63 :0]                                             ld_da_mcic_bypass_data_ori;          
wire    [63 :0]                                             ld_da_mcic_data;                     
wire                                                        lda_mcic_ex3_data_err;                 
wire                                                        lda_mcic_ex3_rb_full;                  
wire                                                        lda_mcic_ex3_wakeup;                   
wire                                                        lda_merge_from_cb;                 
wire                                                        ld_da_merge_mask;                    
wire                                                        ld_da_no_spec_miss;                  
wire                                                        ld_da_no_spec_pair;                  
wire                                                        ld_da_no_spec_target;                
wire                                                        ld_da_other_discard_sq_req;          
wire                                                        ld_da_other_discard_sq_vld;          
wire                                                        ld_da_pair_no_spec_mispred;          
wire                                                        ld_da_pair_no_spec_miss;             
wire                                                        lda_pfu_ex3_awk_dp_vld;                
wire                                                        lda_pfu_ex3_awk_vld;                   
wire                                                        lda_pfu_ex3_biu_req_hit_idx;           
wire                                                        lda_pfu_ex3_eviwk_cnt_vld;             
wire                                                        ld_da_pfu_info_clk;                  
wire                                                        lda_pfu_info_clk_en;               
wire                                                        lda_pfu_ex3_pf_inst_vld;               
wire                                                        lda_rb_ex3_atomic;                     
wire                                                        lda_rb_ex3_cmit;                       
wire                                                        lda_rb_ex3_cmplt_success;              
wire                                                        lda_rb_ex3_create_dp_vld;              
wire                                                        lda_rb_ex3_create_gateclk_en;          
wire                                                        lda_rb_ex3_create_judge_vld;           
wire                                                        lda_rb_ex3_create_lfb;                 
wire                                                        lda_rb_ex3_create_vld;                 
wire                                                        ld_da_rb_create_vld_unmask;          
wire    [127:0]                                             lda_rb_ex3_data_ori;                   
wire    [127:0]                                             lda_rb_ex3_data_ori1;                   
wire    [127:0]                                             lda_rb_ex3_data_ori2;                   
wire    [127:0]                                             lda_rb_ex3_data_ori3;                   
wire                                                        lda_rb_ex3_data_vld;                   
wire                                                        lda_rb_ex3_dest_vld;                   
wire                                                        lda_rb_ex3_discard_grnt;               
wire                                                        lda_rb_ex3_ecc_mask ;                   
wire                                                        lda_rb_ex3_expt_vld;                   
wire                                                        lda_rb_ex3_full_gateclk_en;            
wire                                                        ld_da_rb_full_req;                   
wire                                                        ld_da_rb_full_vld;                   
wire                                                        lda_rb_ex3_ldamo;                      
wire                                                        lda_rb_ex3_merge_dp_vld;               
wire                                                        lda_rb_ex3_merge_expt_vld;             
wire                                                        lda_rb_ex3_merge_gateclk_en;           
wire                                                        lda_rb_ex3_merge_vld;                  
wire                                                        ld_da_rb_merge_vld_unmask;           
wire                                                        ld_da_restart_no_cache;              
wire                                                        ld_da_restart_vld;                   
wire    [`WK_PA_WIDTH-5:0]                                  lda_sf_ex3_addr_tto4;                  
wire    [15 :0]                                             lda_sf_ex3_bytes_vld;                  
wire    [IID_WIDTH-1:0]                                     lda0_sf_ex3_iid;                      
wire                                                        lda_sf_ex3_no_spec_miss;               
wire                                                        lda_sf_ex3_no_spec_miss_gate;          
wire                                                        lda_sf_ex3_spec_chk_req;               
wire                                                        lda_snq_ex3_borrow_icc;                
wire                                                        lda_snq_ex3_borrow_sndb;               
wire                                                        ld_da_spec;                          
wire                                                        ld_da_spec_chk_req;                  
wire                                                        lda_ex3_special_gateclk_en;            
wire                                                        ld_da_split_last;                    
wire                                                        ld_da_split_miss;                    
wire                                                        lda_sq_ex3_data_discard_vld;           
wire                                                        ld_da_sq_fwd_ecc_discard;            
wire                                                        lda_sq_ex3_fwd_multi_vld;              
wire                                                        lda_sq_ex3_global_discard_vld;         
wire                                                        lda_lsda0_ex3_hit_idx;
wire                                                        lda_lsda1_ex3_hit_idx;                   
wire                                                        lda_lsda_ex3_tag_inj_mask;               
wire                                                        lda_tag_clk;                       
wire                                                        lda_tag_clk_en;                    
wire                                                        ld_da_tag_ecc_err;                   
wire                                                        lda_tag_ecc_stall;                 
wire                                                        ld_da_tag_ecc_stall_gate;            
wire                                                        lda_tag_ecc_stall_ori;             
wire                                                        ld_da_tag_ecc_vld;                   
wire    [127:0]                                             ld_da_tag_read_settle;               
wire                                                        ld_da_target_no_spec_hit;            
wire                                                        ld_da_target_no_spec_mispred;        
wire                                                        ld_da_target_no_spec_miss;           
wire    [127:0]                                             ld_da_tcm_data128_am;                
wire                                                        ld_da_tcm_ecc_stall;                 
wire                                                        ld_da_tcm_ecc_stall_gate;            
wire                                                        ld_da_tcm_ecc_stall_ori;             
wire                                                        lda_tcm_hit;                       
wire                                                        ld_da_tcm_rb_restart;                
wire    [2  :0]                                             lda_vb_ex3_borrow_vb;                  
wire                                                        lda_vb_ex3_snq_data_reissue;           
wire                                                        lda_vb_snq_ex3_ecc_err;                
wire    [8  :0]                                             ld_da_vl_upval;                      
wire                                                        lda_ex3_wait_fence_gateclk_en;         
wire                                                        ld_da_wait_fence_req;                
wire                                                        ld_da_wait_fence_vld;                
wire                                                        lda_lwb_ex3_cmplt_req;                  
wire                                                        lda_lwb_ex3_cmplt_req_gate;             
wire    [127:0]                                             lda_lwb_ex3_data;                       
wire    [127:0]                                             lda_lwb_ex3_data0;                       
wire    [127:0]                                             lda_lwb_ex3_data1;                       
wire    [127:0]                                             lda_lwb_ex3_data2;                       
wire    [127:0]                                             lda_lwb_ex3_data3;                       
wire                                                        lda_lwb_ex3_data_req;                   
wire                                                        lda_lwb_ex3_data_req_dp;                
wire                                                        lda_lwb_ex3_data_req_gateclk_en;        
wire                                                        ld_da_wb_data_req_mask;              
wire                                                        lda_lwb_ex3_expt_vld;                   
wire                                                        lda_lwb_ex3_inst_vls;                   
wire    [`WK_PA_WIDTH-1:0]                                  lda_lwb_ex3_mtval;                   
wire                                                        lda_lwb_ex3_no_spec_hit;                
wire                                                        lda_lwb_ex3_no_spec_mispred;            
wire                                                        lda_lwb_ex3_no_spec_miss;               
wire                                                        lda_lwb_ex3_no_spec_target;             
wire                                                        lda_ex3_spec_fail;                  
wire                                                        lda_lwb_ex3_vsetvl;                     
wire                                                        lda_lwb_ex3_vstart_vld;                 
wire                                                        lda_wmb_ex3_data_reissue;              
wire                                                        lda_wmb_ex3_discard_vld;                                
wire                                                        lda_wmb_ex3_two_bit_err;               
wire    [`WK_PA_WIDTH-1:0]                                  ldc_ex2_addr0;                         
wire                                                        ldc_lda_ex2_ahead_predict;                 
wire                                                        ldc_lda_ex2_ahead_preg_wb_vld;             
wire                                                        ldc_lda_ex2_ahead_vreg_wb_vld;             
wire                                                        ldc_lda_ex2_already_da;                    
wire                                                        ldc_lda_ex2_atomic;                                         
wire    [2  :0]                                             ldc_lda_ex2_borrow_db;                     
wire                                                        ldc_lda_ex2_borrow_icc;                    
wire                                                        ldc_lda_ex2_borrow_icc_ecc;                
wire                                                        ldc_lda_ex2_borrow_icc_tag;                
wire    [1  :0]                                             ldc_lda_ex2_borrow_idx_5to4;               
wire                                                        ldc_lda_ex2_borrow_mmu;                    
wire                                                        ldc_lda_ex2_borrow_prq;                    
wire                                                        ldc_lda_ex2_borrow_sndb;                   
wire                                                        ldc_lda_ex2_borrow_vb;                     
wire                                                        ldc_ex2_borrow_vld;                    
wire                                                        ldc_lda_ex2_borrow_wmb;                    
wire                                                        ldc_lda_ex2_boundary;                      
wire    [15 :0]                                             ldc_lda_ex2_bytes_vld;                  
wire    [15 :0]                                             ldc_lda_ex2_bytes_vld1;                 
wire    [15 :0]                                             ldc_lda_ex2_bytes_vld2;                 
wire    [15 :0]                                             ldc_lda_ex2_bytes_vld3;                 
wire                                                        ld_dc_da_cb_addr_create;             
wire                                                        ld_dc_da_cb_merge_en;                
wire    [15 :0]                                             ldc_lda_ex2_rot_sel;               
wire                                                        ldc_lda_ex2_expt_vld_gate_en;           
wire                                                        ldc_lda_ex2_icc_tag_vld;                
wire                                                        ldc_lda_ex2_inst_vld;                   
wire    [LQENTRY-1:0]                                       ldc_lda_ex2_lq_entry;                   
wire                                                        ldc_lda_ex2_old;                        
wire                                                        ldc_lda_ex2_page_buf;                   
wire                                                        ldc_lda_ex2_page_ca;                    
wire                                                        ldc_lda_ex2_page_sec;                   
wire                                                        ldc_lda_ex2_page_share;                 
wire                                                        ldc_lda_ex2_page_so;                    
wire                                                        ldc_lda_ex2_pf_inst;                    
wire    [`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0]              ldc_lda_ex2_tag_read;                   
wire                                                        ldc_lda_ex2_data_inj_dp;                   
wire                                                        ldc_data_inj_vld;                  
wire                                                        ldc_lda_ex2_dcache_hit;                    
wire                                                        ldc_lda_ex2_dtcm_hit;                      
wire    [8  :0]                                             ldc_lda_ex2_element_cnt;                   
wire    [1  :0]                                             ldc_lda_ex2_element_size;                  
wire                                                        ldc_lda_ex2_expt_access_fault_extra;       
wire                                                        ldc_lda_ex2_expt_access_fault_mask;        
wire    [4  :0]                                             ldc_lda_ex2_expt_vec;                      
wire                                                        ldc_lda_ex2_expt_vld_except_access_err;    
wire    [15 :0]                                             ldc_lda_ex2_fwd_bytes_vld;                 
wire                                                        ldc_lda_ex2_fwd_sq_vld;                    
wire                                                        ldc_lda_ex2_fwd_wmb_vld;                   
wire    [3  :0]                                             ldc_lda_ex2_get_dcache_data;               
//wire                        ldc_lda_ex2_hit_high_region;               
//wire                        ldc_lda_ex2_hit_low_region;
wire                                                        ldc_lda_ex2_hit_3_region;
wire                                                        ldc_lda_ex2_hit_2_region;
wire                                                        ldc_lda_ex2_hit_1_region;
wire                                                        ldc_lda_ex2_hit_0_region;                
//wire                        ldc_lda_ex2_hit_way0;           
wire                                                        rtu_ck_flush;
wire    [IID_WIDTH-1:0]                                     rtu_ck_flush_iid;
wire                                                        rtu_ck_flush_iid_older_than_ex2_iid;
wire                                                        rtu_ck_flush_iid_older_than_ex3_iid;
wire    [3  :0]                                             ldc_hit_way;                      
wire    [IID_WIDTH-1:0]                                     ldc_ex2_iid;                           
wire                                                        ldc_lda_ex2_inst_fof;                      
wire    [2  :0]                                             ldc_lda_ex2_inst_size;                     
wire    [1  :0]                                             ldc_lda_ex2_inst_type;                     
wire                                                        ldc_lda_ex2_inst_vfls;                     
wire                                                        ldc_ex2_inst_vld;                      
wire                                                        ldc_lda_ex2_inst_vls;                      
wire                                                        ldc_lda_ex2_itcm_hit;                      
wire    [PC_LEN-1:0]                                        ldc_lda_ex2_ldfifo_pc;                     
wire    [LSIQENTRY-1:0]                                     ldc_lda_ex2_lsid;                          
wire                                                        ldc_lda_ex2_mmu_req;                       
wire    [`WK_PA_WIDTH-1:0]                                  ldc_lda_ex2_mtval;                      
wire    [1  :0]                                             ldc_lda_ex2_no_spec;                       
wire                                                        ldc_lda_ex2_no_spec_exist;                 
wire                                                        ldc_lda_ex2_pfu_info_set_vld;              
wire    [`WK_PA_WIDTH-1:0]                                  ldc_lda_ex2_pfu_va;                        
wire    [PREG-1:0]                                          ldc_lda_ex2_preg;                          
wire    [3  :0]                                             ldc_lda_ex2_preg_sign_sel;                 
wire    [15 :0]                                             ldc_lda_ex2_reg_bytes_vld;                 
wire    [15 :0]                                             ldc_lda_ex2_reg_bytes_vld1;                 
wire    [15 :0]                                             ldc_lda_ex2_reg_bytes_vld2;                 
wire    [15 :0]                                             ldc_lda_ex2_reg_bytes_vld3;                 
wire                                                        ldc_lda_ex2_inst_us;
wire                                                        ldc_lda_ex2_us_discard;
wire                                                        ldc_ex2_secd;                          
wire    [1  :0]                                             ldc_lda_ex2_settle_way;                    
wire    [8  :0]                                             ldc_lda_ex2_setvl_val;                     
wire                                                        ldc_lda_ex2_sext;                   
wire                                                        ldc_lda_ex2_spec_fail;                     
wire                                                        ldc_lda_ex2_split;                         
wire                                                        ldc_lda_ex2_tag_inj_dp;                    
wire                                                        ldc_tag_inj_vld;                   
wire                                                        ldc_lda_ex2_vector_nop;                    
// wire    [1  :0]                                             ldc_lda_ex2_vlmul;    
wire    [2  :0]             ldc_lda_ex2_vlmul;                       
wire    [VMB_ENTRY-1:0]                                     ldc_lda_ex2_vmb_id;                        
wire                                                        ldc_lda_ex2_vmb_merge_vld;                 
wire    [VREG-1  :0]                                        ldc_lda_ex2_vreg;                          
wire                                                        ldc_lda_ex2_vreg_sign_sel;                 
//wire    [1  :0]                                             ldc_lda_ex2_vsew;//rvv1.0@hcl 
wire    [1  :0]             ldc_lda_ex2_vmew;//rvv1.0@hcl 
wire    [1  :0]             ldc_lda_ex2_vmop;//rvv1.0@hcl                          
wire                                                        ldc_lda_ex2_wait_fence;                    
wire    [PC_LEN-1:0]                                        lq_lsu_ex2_spec_fail_pc; //wjh@sfp
wire                                                        ld_hit_prefetch;                     
wire                                                        lfb_lda_hit_idx;                   
wire                                                        lm_lda_ex3_hit_idx;                    
wire                                                        lsu_hpcp_ld_cache_access;            
wire                                                        lsu_hpcp_ld_cache_miss;              
wire                                                        lsu_hpcp_ld_data_discard;            
wire                                                        lsu_hpcp_ld_discard_sq;              
wire                                                        lsu_hpcp_ld_unalign_inst;            
wire    [PREG-1:0]                                          lda_idu_ex3_fwd_preg;           
wire    [63 :0]                                             lda_idu_ex3_fwd_preg_data;      
wire                                                        lda_idu_ex3_fwd_preg_vld;       
wire    [VREG:0]                                            lda_idu_ex3_fwd_vreg;           
wire    [63 :0]                                             lda_idu_ex3_fwd_vreg_fr_data;   
wire                                                        lda_idu_ex3_fwd_vreg_vld;       
wire    [255 :0]                                             lda_idu_ex3_fwd_vreg_vr0_data;  
wire    [255 :0]                                             lda_idu_ex3_fwd_vreg_vr1_data;  
wire    [LSIQENTRY-1:0]                                     lsu_idu_ex3_wait_old;              
wire                                                        lsu_idu_ex3_wait_old_gateclk_en;   
wire                                                        lsu_ld_data_inj_cmplt;               
wire                                                        lsu_ld_tag_inj_cmplt;                
wire    [IID_WIDTH-1:0]                                     lsu_rtu_ex3_ssf_iid; 
wire                                                        lsu_rtu_ex3_ssf_vld; 
wire                                                        lsu_special_clk;                     
wire                                                        mmu_lsu_access_fault0;               
wire                                                        pad_yy_icg_scan_en;                  
wire    [`WK_PA_WIDTH-1:0]                                  pfu_biu_req_addr;                    
wire                                                        rb_lda_ex3_full;                       
wire                                                        rb_lda_ex3_hit_idx;                    
wire                                                        rb_lda_ex3_merge_fail;                 
wire                                                        rtu_lsu_flush_fe;                    
wire                                                        rtu_yy_xx_commit0;                   
wire    [IID_WIDTH-1:0]                                     rtu_yy_xx_commit0_iid;               
wire                                                        rtu_yy_xx_commit1;                   
wire    [IID_WIDTH-1:0]                                     rtu_yy_xx_commit1_iid;               
wire                                                        rtu_yy_xx_commit2;                   
wire    [IID_WIDTH-1:0]                                     rtu_yy_xx_commit2_iid; 
wire                                                        rtu_yy_xx_commit3;                   
wire    [IID_WIDTH-1:0]                                     rtu_yy_xx_commit3_iid;               
wire                                                        rtu_yy_xx_commit4;                   
wire    [IID_WIDTH-1:0]                                     rtu_yy_xx_commit4_iid;               
wire                                                        rtu_yy_xx_commit5;                   
wire    [IID_WIDTH-1:0]                                     rtu_yy_xx_commit5_iid; 
//wire                        rtu_yy_xx_commit6;                   
//wire    [IID_WIDTH-1:0]     rtu_yy_xx_commit6_iid;               
//wire                        rtu_yy_xx_commit7;                   
//wire    [IID_WIDTH-1:0]     rtu_yy_xx_commit7_iid; 
wire    [127:0]                                             ld_da_fwd_data_bypass;              
wire    [127:0]                                             std0_ex1_data_bypass; 
wire    [127:0]                                             std1_ex1_data_bypass;                 
wire                                                        std0_ex1_inst_vld;   
wire                                                        std1_ex1_inst_vld;                    
wire                                                        sf_lda_spec_mark;                        
wire    [127:0]                                             sq_lda_ex2_fwd_data;                   
wire    [127:0]                                             sq_ld_da_fwd_data_128;               
wire    [127:0]                                             sq_lda_ex2_fwd_data_pe;                
wire    [127:0]                                             sq_ld_da_fwd_data_pe_128;            
wire                                                        sq_lda_ex2_data_discard_req;           
wire                                                        sq_lda_ex2_fwd_bypass_multi;           
wire                                                        sq_lda_ex2_fwd_bypass_req;             
wire    [SQ_ENTRY-1 :0]                                     sq_lda_ex2_fwd_id;                     
wire                                                        sq_lda_ex2_fwd_multi;                  
wire                                                        sq_lda_ex2_fwd_multi_mask;             
wire                                                        sq_ldc_ex2_newest_fwd_data_vld_req;    
wire                                                        sq_lda_ex2_other_discard_req;   
wire                                                        sq_lda_ex2_fwd_bypass_sel;       
wire    [`WK_PA_WIDTH-1:0]                                  lsda0_ex3_addr; 
wire    [`WK_PA_WIDTH-1:0]                                  lsda1_ex3_addr;                            
wire                                                        lsda0_ex3_tag_inj_mask;      
wire                                                        lsda1_ex3_tag_inj_mask;            
wire    [`WK_LS_DCACHE_LDTAG_WIDTH-1:0]                     tag_bf_ecc;                                                  
wire                                                        tag_ecc_pipe_down;                   
wire                                                        tcm_1bit_err;                        
wire    [127:0]                                             tcm_rdata;                           
wire                                                        w0_ecc_fatal;                        
wire                                                        w0_ecc_free;                         
wire    [`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0]              w0_tag_bf_ecc;                       
wire    [`WK_LS_DCACHE_LDTAG_BF_ECC_LENGTH-1:0]             w0_tag_corrected;                    
wire                                                        w0_tag_ham_error;                    
wire                                                        w0_tag_parity_error;                 
wire                                                        w1_ecc_fatal;                        
wire                                                        w1_ecc_free;                         
wire    [`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0]              w1_tag_bf_ecc;                       
wire    [`WK_LS_DCACHE_LDTAG_BF_ECC_LENGTH-1 :0]            w1_tag_corrected;                    
wire                                                        w1_tag_ham_error;                    
wire                                                        w1_tag_parity_error;
wire                                                        w2_ecc_fatal;                        
wire                                                        w2_ecc_free;                         
wire    [`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0]              w2_tag_bf_ecc;                       
wire    [`WK_LS_DCACHE_LDTAG_BF_ECC_LENGTH-1 :0]            w2_tag_corrected;                    
wire                                                        w2_tag_ham_error;                    
wire                                                        w2_tag_parity_error;                 
wire                                                        w3_ecc_fatal;                        
wire                                                        w3_ecc_free;                         
wire    [`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0]              w3_tag_bf_ecc;                       
wire    [`WK_LS_DCACHE_LDTAG_BF_ECC_LENGTH-1 :0]            w3_tag_corrected;                    
wire                                                        w3_tag_ham_error;                    
wire                                                        w3_tag_parity_error;                 
wire    [127:0]                                             wmb_lda_fwd_data;                  
wire    [127:0]                                             wmb_ld_da_fwd_data_128;              
wire                                                        wmb_ldc_discard_req;               

wire                                                        ld_da_hit_0_ecc; // wjh@chkdsi
wire                                                        ld_da_hit_1_ecc; // wjh@chkdsi
wire                                                        ld_da_hit_2_ecc; // wjh@chkdsi
wire                                                        ld_da_hit_3_ecc; // wjh@chkdsi

wire   lda_ahead_preg_wb_vld_f;
wire   lda_ahead_vreg_wb_vld_f;
wire   ldc_lda_ex2_ahead_preg_wb_vld_ff;
wire   ldc_lda_ex2_ahead_vreg_wb_vld_ff;

//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
input                                             dtu_lsu_data_trig_en;
input   [`TDT_MP_HINFO_WIDTH-1:0]                 dtu_lsu_addr_halt_info;
input                                             ld_dc_boundary_unmask;

output                                            ld_da_dtu_addr_halt_info_stall_vld;
output  [`TDT_MP_HINFO_WIDTH-1:0]                 ld_da_halt_info_am;
output  [`TDT_MP_HINFO_WIDTH-1:0]                 ld_da_idu_halt_info;           
output  [LSIQENTRY-1:0]                           ld_da_idu_halt_info_update_vld;
output                                            ld_da_rb_data_check;

//input
wire                                              dtu_lsu_data_trig_en;
wire    [`TDT_MP_HINFO_WIDTH-1:0]                 dtu_lsu_addr_halt_info;
wire                                              ld_dc_boundary_unmask;
//output
wire                                              ld_da_dtu_addr_halt_info_stall_vld;
wire    [`TDT_MP_HINFO_WIDTH-1:0]                 ld_da_halt_info_am;
wire    [`TDT_MP_HINFO_WIDTH-1:0]                 ld_da_idu_halt_info;           
wire    [LSIQENTRY-1:0]                           ld_da_idu_halt_info_update_vld;
wire                                              ld_da_rb_data_check;

reg                                               ld_da_boundary_unmask;

wire                                              ld_da_expt_ori_cancel;
wire                                              ld_da_expt_vld_cancel;
wire                                              lda_lwb_ex3_expt_vld_cancel;
//==========================================================
//                  Risc-V Debug zdb End
//==========================================================

parameter S_BYTE        = 2'b00,
          HALF          = 2'b01,
          WORD          = 2'b10,
          DWORD         = 2'b11;
//==========================================================
//                 Instance of Gated Cell  
//==========================================================
//------------------normal reg------------------------------
assign lda_clk_en = ldc_ex2_inst_vld
                      ||  lda_ecc_stall_gate
                      ||  ldc_ex2_borrow_vld;
// &Instance("gated_clk_cell", "x_lsu_ld_da_gated_clk"); @52
gated_clk_cell  x_lsu_ld_da_gated_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (lda_clk           ),
  .external_en        (1'b0              ),
  .local_en           (lda_clk_en        ),
  .module_en          (cp0_lsu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect(.clk_in        (forever_cpuclk     ), @53
//          .external_en   (1'b0               ), @54
//          .module_en     (cp0_lsu_icg_en     ), @55
//          .local_en      (lda_clk_en       ), @56
//          .clk_out       (lda_clk          )); @57

assign lda_inst_clk_en = ldc_ex2_inst_vld;
// &Instance("gated_clk_cell", "x_lsu_ld_da_inst_gated_clk"); @60
gated_clk_cell  x_lsu_ld_da_inst_gated_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (lda_inst_clk      ),
  .external_en        (1'b0              ),
  .local_en           (lda_inst_clk_en   ),
  .module_en          (cp0_lsu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect(.clk_in        (forever_cpuclk     ), @61
//          .external_en   (1'b0               ), @62
//          .module_en     (cp0_lsu_icg_en     ), @63
//          .local_en      (lda_inst_clk_en  ), @64
//          .clk_out       (lda_inst_clk     )); @65

assign lda_borrow_clk_en = ldc_ex2_borrow_vld;
// &Instance("gated_clk_cell", "x_lsu_ld_da_borrow_gated_clk"); @68
gated_clk_cell  x_lsu_ld_da_borrow_gated_clk (
  .clk_in              (forever_cpuclk     ),
  .clk_out             (lda_borrow_clk     ),
  .external_en         (1'b0               ),
  .local_en            (lda_borrow_clk_en  ),
  .module_en           (cp0_lsu_icg_en     ),
  .pad_yy_icg_scan_en  (pad_yy_icg_scan_en )
);

// &Connect(.clk_in        (forever_cpuclk     ), @69
//          .external_en   (1'b0               ), @70
//          .module_en     (cp0_lsu_icg_en     ), @71
//          .local_en      (lda_borrow_clk_en), @72
//          .clk_out       (lda_borrow_clk   )); @73

assign lda_expt_clk_en  = ldc_ex2_inst_vld
                          &&  ldc_lda_ex2_expt_vld_gate_en
                          || lda_ecc_stall_gate;
// &Instance("gated_clk_cell", "x_lsu_ld_da_expt_gated_clk"); @78
gated_clk_cell  x_lsu_ld_da_expt_gated_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (lda_expt_clk      ),
  .external_en        (1'b0              ),
  .local_en           (lda_expt_clk_en   ),
  .module_en          (cp0_lsu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect(.clk_in        (forever_cpuclk     ), @79
//          .external_en   (1'b0               ), @80
//          .module_en     (cp0_lsu_icg_en     ), @81
//          .local_en      (lda_expt_clk_en  ), @82
//          .clk_out       (lda_expt_clk     )); @83

//------------------pfu_addr reg----------------------------
assign lda_pfu_info_clk_en  = ldc_lda_ex2_pfu_info_set_vld;
// &Instance("gated_clk_cell", "x_lsu_ld_da_pfu_info_gated_clk"); @87
gated_clk_cell  x_lsu_ld_da_pfu_info_gated_clk (
  .clk_in                (lsu_special_clk      ),
  .clk_out               (ld_da_pfu_info_clk   ),
  .external_en           (1'b0                 ),
  .local_en              (lda_pfu_info_clk_en  ),
  .module_en             (cp0_lsu_icg_en       ),
  .pad_yy_icg_scan_en    (pad_yy_icg_scan_en   )
);

// &Connect(.clk_in        (lsu_special_clk    ), @88
//          .external_en   (1'b0               ), @89
//          .module_en     (cp0_lsu_icg_en     ), @90
//          .local_en      (lda_pfu_info_clk_en ), @91
//          .clk_out       (ld_da_pfu_info_clk    )); @92

//------------------dcache reg------------------------------
assign lda_data0_clk_en = ldc_lda_ex2_get_dcache_data[0] || lda_ecc_stall_gate;
// &Instance("gated_clk_cell", "x_lsu_ld_da_data0_gated_clk"); @96
gated_clk_cell  x_lsu_ld_da_data0_gated_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (ld_da_data0_clk   ),
  .external_en        (1'b0              ),
  .local_en           (lda_data0_clk_en  ),
  .module_en          (cp0_lsu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect(.clk_in        (forever_cpuclk     ), @97
//          .external_en   (1'b0               ), @98
//          .module_en     (cp0_lsu_icg_en     ), @99
//          .local_en      (lda_data0_clk_en ), @100
//          .clk_out       (ld_da_data0_clk    )); @101

assign lda_data1_clk_en = ldc_lda_ex2_get_dcache_data[1] || lda_ecc_stall_gate;
// &Instance("gated_clk_cell", "x_lsu_ld_da_data1_gated_clk"); @104
gated_clk_cell  x_lsu_ld_da_data1_gated_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (lda_data1_clk   ),
  .external_en        (1'b0              ),
  .local_en           (lda_data1_clk_en  ),
  .module_en          (cp0_lsu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect(.clk_in        (forever_cpuclk     ), @105
//          .external_en   (1'b0               ), @106
//          .module_en     (cp0_lsu_icg_en     ), @107
//          .local_en      (lda_data1_clk_en ), @108
//          .clk_out       (lda_data1_clk    )); @109

assign lda_data2_clk_en = ldc_lda_ex2_get_dcache_data[2] || lda_ecc_stall_gate;
// &Instance("gated_clk_cell", "x_lsu_ld_da_data2_gated_clk"); @112
gated_clk_cell  x_lsu_ld_da_data2_gated_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (lda_data2_clk     ),
  .external_en        (1'b0              ),
  .local_en           (lda_data2_clk_en  ),
  .module_en          (cp0_lsu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect(.clk_in        (forever_cpuclk     ), @113
//          .external_en   (1'b0               ), @114
//          .module_en     (cp0_lsu_icg_en     ), @115
//          .local_en      (lda_data2_clk_en ), @116
//          .clk_out       (lda_data2_clk    )); @117

assign lda_data3_clk_en = ldc_lda_ex2_get_dcache_data[3] || lda_ecc_stall_gate;
// &Instance("gated_clk_cell", "x_lsu_ld_da_data3_gated_clk"); @120
gated_clk_cell  x_lsu_ld_da_data3_gated_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (lda_data3_clk     ),
  .external_en        (1'b0              ),
  .local_en           (lda_data3_clk_en  ),
  .module_en          (cp0_lsu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect(.clk_in        (forever_cpuclk     ), @121
//          .external_en   (1'b0               ), @122
//          .module_en     (cp0_lsu_icg_en     ), @123
//          .local_en      (lda_data3_clk_en ), @124
//          .clk_out       (lda_data3_clk    )); @125

assign lda_tag_clk_en = ldc_lda_ex2_icc_tag_vld;
// &Instance("gated_clk_cell", "x_lsu_ld_da_tag_gated_clk"); @128
gated_clk_cell  x_lsu_ld_da_tag_gated_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (lda_tag_clk       ),
  .external_en        (1'b0              ),
  .local_en           (lda_tag_clk_en    ),
  .module_en          (cp0_lsu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect(.clk_in        (forever_cpuclk     ), @129
//          .external_en   (1'b0               ), @130
//          .module_en     (cp0_lsu_icg_en     ), @131
//          .local_en      (lda_tag_clk_en ), @132
//          .clk_out       (lda_tag_clk    )); @133

assign lda_ecc_stall_clk_en = lda_ecc_stall_gate;
// &Instance("gated_clk_cell", "x_lsu_ld_da_ecc_stall_gated_clk"); @137
gated_clk_cell  x_lsu_ld_da_ecc_stall_gated_clk (
  .clk_in                 (forever_cpuclk        ),
  .clk_out                (lda_ecc_stall_clk     ),
  .external_en            (1'b0                  ),
  .local_en               (lda_ecc_stall_clk_en  ),
  .module_en              (cp0_lsu_icg_en        ),
  .pad_yy_icg_scan_en     (pad_yy_icg_scan_en    )
);

// &Connect(.clk_in        (forever_cpuclk     ), @138
//          .external_en   (1'b0               ), @139
//          .module_en     (cp0_lsu_icg_en     ), @140
//          .local_en      (lda_ecc_stall_clk_en ), @141
//          .clk_out       (lda_ecc_stall_clk    )); @142
//==========================================================
//                 Pipeline Register
//==========================================================
//------------------control part----------------------------
//+----------+------------+
//| inst_vld | borrow_vld |
//+----------+------------+
// &Force("output","lda_ex3_inst_vld"); @151
xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH)) 
x_lsu_ck_flush_compare_ex2_iid (
  .x_iid0                    (rtu_ck_flush_iid[IID_WIDTH-1:0]),
  .x_iid0_older              (rtu_ck_flush_iid_older_than_ex2_iid  ),
  .x_iid1                    (ldc_ex2_iid[IID_WIDTH-1:0]           )
);
xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH)) 
x_lsu_ck_flush_compare_ex3_iid (
  .x_iid0                    (rtu_ck_flush_iid[IID_WIDTH-1:0]),
  .x_iid0_older              (rtu_ck_flush_iid_older_than_ex3_iid  ),
  .x_iid1                    (lda_ex3_iid[IID_WIDTH-1:0]           )
);

assign lda_ahead_preg_wb_vld_f   = ~(rtu_ck_flush &&rtu_ck_flush_iid_older_than_ex3_iid)    //flush ex3 data wb_vld when ecc stall, ck_flush@LTL
                                    ? lda_ahead_preg_wb_vld
                                    : 1'b0;
assign lda_ahead_vreg_wb_vld_f   = ~(rtu_ck_flush &&rtu_ck_flush_iid_older_than_ex3_iid)    //flush ex3 data wb_vld when ecc stall, ck_flush@LTL
                                    ? lda_ahead_vreg_wb_vld
                                    : 1'b0;
assign ldc_lda_ex2_ahead_preg_wb_vld_ff = ~(rtu_ck_flush &&rtu_ck_flush_iid_older_than_ex2_iid) //flush ex2 data wb_vld when no ecc stall, ck_flush@LTL
                                          ? ldc_lda_ex2_ahead_preg_wb_vld
                                          : 1'b0;
assign ldc_lda_ex2_ahead_vreg_wb_vld_ff = ~(rtu_ck_flush &&rtu_ck_flush_iid_older_than_ex2_iid) //flush ex2 data wb_vld when no ecc stall, ck_flush@LTL
                                          ? ldc_lda_ex2_ahead_vreg_wb_vld
                                          : 1'b0;
always @(posedge ctrl_ld_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    lda_ex3_inst_vld      <=  1'b0;
    lda_ahead_preg_wb_vld <=  1'b0;
    lda_ahead_vreg_wb_vld <=  1'b0;
  end
  else if(rtu_lsu_flush_fe)
  begin
    lda_ex3_inst_vld      <=  1'b0;
    lda_ahead_preg_wb_vld <=  1'b0;
    lda_ahead_vreg_wb_vld <=  1'b0;
  end
  else if(lda_ecc_stall)
  begin
    lda_ex3_inst_vld      <=  lda_ex3_inst_vld && ~(rtu_ck_flush && rtu_ck_flush_iid_older_than_ex3_iid); //flush ex3->ex3 inst_vld when ecc stall, ck_flush@LTL
    lda_ahead_preg_wb_vld <=  lda_ahead_preg_wb_vld_f;
    lda_ahead_vreg_wb_vld <=  lda_ahead_vreg_wb_vld_f;
  end
  else if(ldc_lda_ex2_inst_vld)
  begin
    lda_ex3_inst_vld      <=  ~(rtu_ck_flush && rtu_ck_flush_iid_older_than_ex2_iid); //flush ex3->ex3 inst_vld when no ecc stall, ck_flush@LTL
    lda_ahead_preg_wb_vld <=  ldc_lda_ex2_ahead_preg_wb_vld_ff;
    lda_ahead_vreg_wb_vld <=  ldc_lda_ex2_ahead_vreg_wb_vld_ff;
  end
  else
  begin
    lda_ex3_inst_vld      <=  1'b0;
    lda_ahead_preg_wb_vld <=  1'b0;
    lda_ahead_vreg_wb_vld <=  1'b0;
  end
end

always @(posedge ctrl_ld_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    lda_dtcm_hit        <=  1'b0;
    lda_itcm_hit        <=  1'b0;
  end
  else if(lda_ecc_stall)
  begin
    lda_dtcm_hit        <=  lda_dtcm_hit;
    lda_itcm_hit        <=  lda_itcm_hit;
  end
  else if(ldc_ex2_borrow_vld)
  begin
    lda_dtcm_hit        <=  1'b0;
    lda_itcm_hit        <=  1'b0;
  end
  else if(ldc_ex2_inst_vld)
  begin
    lda_dtcm_hit        <=  ldc_lda_ex2_dtcm_hit;
    lda_itcm_hit        <=  ldc_lda_ex2_itcm_hit;
  end
end

assign lda_tcm_hit = lda_dtcm_hit | lda_itcm_hit;

// &Force("output","lda_ex3_borrow_vld"); @214
always @(posedge ctrl_ld_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    lda_ex3_borrow_vld        <=  1'b0;
  else if(lda_ecc_stall)
    lda_ex3_borrow_vld        <=  lda_ex3_borrow_vld;
  else if(ldc_ex2_borrow_vld)
    lda_ex3_borrow_vld        <=  1'b1;
  else
    lda_ex3_borrow_vld        <=  1'b0;
end

always @(posedge ctrl_ld_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    lda_ecc_stall_already  <=  1'b0;
    lda_ecc_stall_fatal    <=  1'b0;
    lda_ecc_stall_data     <=  1'b0;
    lda_ecc_stall_cb_merge <=  1'b0;
    lda_ecc_stall_tag_way  <=  4'b0;
  end
  else if(lda_ecc_stall)
  begin
    lda_ecc_stall_already  <=  1'b1;
    lda_ecc_stall_fatal    <=  lda_ecc_fatal;
    lda_ecc_stall_data     <=  !lda_tag_ecc_stall_ori;
    lda_ecc_stall_cb_merge <=  lda_merge_from_cb;
    lda_ecc_stall_tag_way  <=  lda_ecc_tag_way;
  end
  else
  begin
    lda_ecc_stall_already  <=  1'b0;
    lda_ecc_stall_fatal    <=  1'b0;
    lda_ecc_stall_data     <=  1'b0;
    lda_ecc_stall_cb_merge <=  1'b0;
    lda_ecc_stall_tag_way  <=  4'b0;
  end
end

always @(posedge ctrl_ld_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    lda_get_dcache_data[3:0]    <=  4'b0;
    lda_tag_inj_vld             <=  1'b0;
    lda_data_inj_vld            <=  1'b0;
  end
  else if((ldc_ex2_inst_vld || ldc_ex2_borrow_vld) && !lda_ecc_stall)
  begin
    lda_get_dcache_data[3:0]    <=  ldc_lda_ex2_get_dcache_data[3:0];
    lda_tag_inj_vld             <=  ldc_tag_inj_vld;
    lda_data_inj_vld            <=  ldc_data_inj_vld;
  end
end

//store tag for pa update
always @(posedge lda_ecc_stall_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    lda_tag_corrected_f[`WK_LS_DCACHE_LDTAG_QUADRUPLE_BF_ECC_LENGTH-1:0] <=  {`WK_LS_DCACHE_LDTAG_QUADRUPLE_BF_ECC_LENGTH{1'b0}};  //53->107, L1D 2->4way, LTL@20250322
  else if(lda_tag_ecc_stall)
    lda_tag_corrected_f[`WK_LS_DCACHE_LDTAG_QUADRUPLE_BF_ECC_LENGTH-1:0] <=  lda_dcache_tag_corrected[`WK_LS_DCACHE_LDTAG_QUADRUPLE_BF_ECC_LENGTH-1:0];
end

//for dc inst wakeup
always @(posedge ctrl_ld_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    lda_ecc_wakeup_queue[LSIQENTRY:0] <=  {LSIQENTRY+1{1'b0}};
  else if(lda_ecc_stall && ldc_lda_ex2_inst_vld && !rtu_lsu_flush_fe)  //rtu_ck_flush =1, still wakeup
    lda_ecc_wakeup_queue[LSIQENTRY:0] <=  {1'b0,ldc_lda_ex2_lsid[LSIQENTRY-1:0]};
  else if(lda_ecc_stall && ldc_ex2_borrow_vld)
    lda_ecc_wakeup_queue[LSIQENTRY:0] <=  {(ldc_lda_ex2_borrow_mmu),{LSIQENTRY{1'b0}}};
  else
    lda_ecc_wakeup_queue[LSIQENTRY:0] <=  {LSIQENTRY+1{1'b0}};
end
//+----------+----------+----------+----------+
//| data 0/4 | data 1/5 | data 2/6 | data 3/7 | 
//+----------+----------+----------+----------+
//data bank0 and bank4 use a common gateclk because they are read
//simultaneously in all case
always @(posedge ld_da_data0_clk)
begin
  if (lda_data_ecc_stall)
  begin
  lda_dcache_data_bank0[38:0] <=  lda_ecc_data_bank0[38:0];
  lda_dcache_data_bank4[38:0] <=  lda_ecc_data_bank4[38:0];
  lda_dcache_data_bank8[38:0] <=  lda_ecc_data_bank8[38:0];
  lda_dcache_data_bank12[38:0] <=  lda_ecc_data_bank12[38:0];
  end
  else if(!lda_tag_ecc_stall && ldc_lda_ex2_get_dcache_data[0])
  begin
  lda_dcache_data_bank0[38:0] <=  dcache_data_bank0[38:0];
  lda_dcache_data_bank4[38:0] <=  dcache_data_bank4[38:0];
  lda_dcache_data_bank8[38:0] <=  dcache_data_bank8[38:0];
  lda_dcache_data_bank12[38:0] <=  dcache_data_bank12[38:0];
  end
end

always @(posedge lda_data1_clk)
begin
  if (lda_data_ecc_stall)
  begin
  lda_dcache_data_bank1[38:0] <=  lda_ecc_data_bank1[38:0];
  lda_dcache_data_bank5[38:0] <=  lda_ecc_data_bank5[38:0];
  lda_dcache_data_bank9[38:0] <=  lda_ecc_data_bank9[38:0];
  lda_dcache_data_bank13[38:0] <=  lda_ecc_data_bank13[38:0];
  end
  else if(!lda_tag_ecc_stall && ldc_lda_ex2_get_dcache_data[1])
  begin
  lda_dcache_data_bank1[38:0] <=  dcache_data_bank1[38:0];
  lda_dcache_data_bank5[38:0] <=  dcache_data_bank5[38:0];
  lda_dcache_data_bank9[38:0] <=  dcache_data_bank9[38:0];
  lda_dcache_data_bank13[38:0] <=  dcache_data_bank13[38:0];
  end
end

always @(posedge lda_data2_clk)
begin
  if (lda_data_ecc_stall)
  begin
  lda_dcache_data_bank2[38:0] <=  lda_ecc_data_bank2[38:0];
  lda_dcache_data_bank6[38:0] <=  lda_ecc_data_bank6[38:0];
  lda_dcache_data_bank10[38:0] <=  lda_ecc_data_bank10[38:0];
  lda_dcache_data_bank14[38:0] <=  lda_ecc_data_bank14[38:0];
  end
  else if(!lda_tag_ecc_stall && ldc_lda_ex2_get_dcache_data[2])
  begin
  lda_dcache_data_bank2[38:0] <=  dcache_data_bank2[38:0];
  lda_dcache_data_bank6[38:0] <=  dcache_data_bank6[38:0];
  lda_dcache_data_bank10[38:0] <=  dcache_data_bank10[38:0];
  lda_dcache_data_bank14[38:0] <=  dcache_data_bank14[38:0];
  end
end

always @(posedge lda_data3_clk)
begin
  if (lda_data_ecc_stall)
  begin
  lda_dcache_data_bank3[38:0] <=  lda_ecc_data_bank3[38:0];
  lda_dcache_data_bank7[38:0] <=  lda_ecc_data_bank7[38:0];
  lda_dcache_data_bank11[38:0] <=  lda_ecc_data_bank11[38:0];
  lda_dcache_data_bank15[38:0] <=  lda_ecc_data_bank15[38:0];
  end
  else if(!lda_tag_ecc_stall && ldc_lda_ex2_get_dcache_data[3])
  begin
  lda_dcache_data_bank3[38:0] <=  dcache_data_bank3[38:0];
  lda_dcache_data_bank7[38:0] <=  dcache_data_bank7[38:0];
  lda_dcache_data_bank11[38:0] <=  dcache_data_bank11[38:0];
  lda_dcache_data_bank15[38:0] <=  dcache_data_bank15[38:0];
  end
end

always @(posedge ld_da_data0_clk)
begin
  ld_da_dcache_data_ahead_bank0[31:0] <=  dcache_lsu_ld_data_bank0_dout[31:0];
  ld_da_dcache_data_ahead_bank4[31:0] <=  dcache_lsu_ld_data_bank4_dout[31:0];
  ld_da_dcache_data_ahead_bank8[31:0] <=  dcache_lsu_ld_data_bank8_dout[31:0]; //L1D 2way->4way, LTL220250320
  ld_da_dcache_data_ahead_bank12[31:0] <=  dcache_lsu_ld_data_bank12_dout[31:0];
end

always @(posedge lda_data1_clk)
begin
  ld_da_dcache_data_ahead_bank1[31:0] <=  dcache_lsu_ld_data_bank1_dout[31:0];
  ld_da_dcache_data_ahead_bank5[31:0] <=  dcache_lsu_ld_data_bank5_dout[31:0];
  ld_da_dcache_data_ahead_bank9[31:0] <=  dcache_lsu_ld_data_bank9_dout[31:0]; //L1D 2way->4way, LTL220250320
  ld_da_dcache_data_ahead_bank13[31:0] <=  dcache_lsu_ld_data_bank13_dout[31:0];
end

always @(posedge lda_data2_clk)
begin
  ld_da_dcache_data_ahead_bank2[31:0] <=  dcache_lsu_ld_data_bank2_dout[31:0];
  ld_da_dcache_data_ahead_bank6[31:0] <=  dcache_lsu_ld_data_bank6_dout[31:0];
  ld_da_dcache_data_ahead_bank10[31:0] <=  dcache_lsu_ld_data_bank10_dout[31:0];//L1D 2way->4way, LTL220250320
  ld_da_dcache_data_ahead_bank14[31:0] <=  dcache_lsu_ld_data_bank14_dout[31:0];
end

always @(posedge lda_data3_clk)
begin
  ld_da_dcache_data_ahead_bank3[31:0] <=  dcache_lsu_ld_data_bank3_dout[31:0];
  ld_da_dcache_data_ahead_bank7[31:0] <=  dcache_lsu_ld_data_bank7_dout[31:0];
  ld_da_dcache_data_ahead_bank11[31:0] <=  dcache_lsu_ld_data_bank11_dout[31:0];//L1D 2way->4way, LTL220250320
  ld_da_dcache_data_ahead_bank15[31:0] <=  dcache_lsu_ld_data_bank15_dout[31:0];
end

//------------------tag read for debug-------------------------------
always @(posedge lda_tag_clk)
begin
  if(ldc_lda_ex2_icc_tag_vld)
  ld_da_tag_read[`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0] <=  ldc_lda_ex2_tag_read[`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0];
end

//------------------expt part-------------------------------
//+----------+
//| expt_vec |
//+----------+
always @(posedge lda_expt_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    ld_da_expt_vec[4:0]               <=  5'b0;
    ld_da_mt_value[`WK_PA_WIDTH-1:0]     <=  {`WK_PA_WIDTH{1'b0}};
  end
  else if(ldc_ex2_inst_vld  &&  ldc_lda_ex2_expt_vld_gate_en && !lda_ecc_stall)
  begin
    ld_da_expt_vec[4:0]           <=  ldc_lda_ex2_expt_vec[4:0];
    ld_da_mt_value[`WK_PA_WIDTH-1:0] <=  ldc_lda_ex2_mtval[`WK_PA_WIDTH-1:0];
  end
end

//------------------borrow part-----------------------------
//+-----+------+-----+------------+
//| vb | sndb | mmu | settle way |
//+-----+------+-----+------------+
always @(posedge lda_borrow_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    ld_da_borrow_db[VB_DATA_ENTRY-1:0]  <=  {VB_DATA_ENTRY{1'b0}};
    ld_da_borrow_vb                     <=  1'b0;
    ld_da_borrow_sndb                   <=  1'b0;
    lda_borrow_mmu                      <=  1'b0;
    lda_borrow_prq                      <=  1'b0;
    lda_borrow_icc                      <=  1'b0;
    ld_da_borrow_icc_tag                <=  1'b0;
    // ld_da_settle_way                    <=  2'b0;//1->2bit, L1D 2->4way, LTL@20250322
    lda_borrow_wmb                      <=  1'b0;
    ld_da_borrow_icc_ecc                <=  1'b0;
    ld_da_borrow_idx_5to4[1:0]          <=  2'b0;
  end
  else if(ldc_ex2_borrow_vld && !lda_ecc_stall)
  begin
    ld_da_borrow_db[VB_DATA_ENTRY-1:0]  <=  ldc_lda_ex2_borrow_db[VB_DATA_ENTRY-1:0];
    ld_da_borrow_vb                     <=  ldc_lda_ex2_borrow_vb;
    ld_da_borrow_sndb                   <=  ldc_lda_ex2_borrow_sndb;
    lda_borrow_mmu                      <=  ldc_lda_ex2_borrow_mmu;
    lda_borrow_prq                      <=  ldc_lda_ex2_borrow_prq;
    lda_borrow_icc                      <=  ldc_lda_ex2_borrow_icc;
    ld_da_borrow_icc_tag                <=  ldc_lda_ex2_borrow_icc_tag;
    // ld_da_settle_way                    <=  ldc_lda_ex2_settle_way;
    lda_borrow_wmb                      <=  ldc_lda_ex2_borrow_wmb;
    ld_da_borrow_icc_ecc                <=  ldc_lda_ex2_borrow_icc_ecc;
    ld_da_borrow_idx_5to4[1:0]          <=  ldc_lda_ex2_borrow_idx_5to4[1:0];
  end
end

always @(posedge lda_clk or negedge cpurst_b)begin 
  if(!cpurst_b)
    ld_da_settle_way <= 2'b00;
  else if((ldc_ex2_borrow_vld||ldc_ex2_inst_vld) && !lda_ecc_stall)
    ld_da_settle_way <= ldc_lda_ex2_settle_way; // include us hit way wjh@us512
end
//------------------inst part----------------------------
//+----------+
//| expt_vld |
//+----------+
//+-----------+-----------+------+-----------+
//| inst_type | inst_size | secd | inst_zone |
//+-----------+-----------+------+-----------+
//+-------------+----+-----+------+-----+------------+------------+
//| sign_extend | ex | iid | lsid | old | bytes_vld0 | bytes_vld1 |
//+-------------+----+-----+------+-----+------------+------------+
//+----------+------+---------------+-------+
//| boundary | preg | rar_spec_fail | split |
//+----------+------+---------------+-------+
//+------------+-----------+-------+-------+
//| already_da | ldfifo_pc | bkpta | bkptb |
//+------------+-----------+-------+-------+
//+----+----+-----+-----+-------+
//| so | ca | buf | sec | share |
//+----+----+-----+-----+-------+
//+------------+-------------+-----------+------------+
//| fwd_sq_vld | fwd_wmb_vld | sq_fwd_id | wmb_fwd_id |
//+------------+-------------+-----------+------------+
//+--------------+----------------+-----------------+
//| sq_fwd_multi | sq_discard_req | wmb_discard_req |
//+--------------+----------------+-----------------+
// &Force("output","lda_ex3_inst_size"); @518
// &Force("output","lda_ex3_sext"); @519
// &Force("output","lda_ex3_iid"); @520
// &Force("output","lda_ex3_bytes_vld"); @521
// &Force("output","lda_ex3_lsid"); @522
// &Force("output","lda_ex3_bkpta_data"); @523
// &Force("output","lda_ex3_bkptb_data"); @524
// &Force("output","lda_ex3_inst_vfls"); @525
// &Force("output","lda_pfu_ex3_va"); @526
// &Force("output","lda_ex3_preg"); @527
// &Force("output","lda_ex3_vreg"); @528
// &Force("output","lda_pfu_ex3_ldfifo_pc"); @529
// &Force("output","lda_lwb_ex3_preg_sign_sel"); @530
// &Force("output","lda_ex3_vreg_sign_sel"); @531
// &Force("nonport","ld_da_ahead_predict"); @532
// &Force("nonport","ld_da_nf_cnt"); @533
always @(posedge lda_inst_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    ld_da_mmu_req                        <=  1'b0;
    ld_da_expt_vld_except_access_err     <=  1'b0;
    ld_da_expt_access_fault_mask         <=  1'b0;
    ld_da_expt_access_fault_extra        <=  1'b0;
    ld_da_expt_access_fault_mmu          <=  1'b0;
    lda_pfu_ex3_va[`WK_PA_WIDTH-1:0]     <=  {`WK_PA_WIDTH{1'b0}};
    lda_ex3_split                        <=  1'b0;
    ld_da_inst_type[1:0]                 <=  2'b0;
    lda_ex3_inst_size[2:0]               <=  3'b0;
    ld_da_secd                           <=  1'b0;
    lda_ex3_sext                         <=  1'b0;
    ld_da_atomic                         <=  1'b0;
    lda_ex3_iid[IID_WIDTH-1:0]           <=  {IID_WIDTH{1'b0}};
    lda_ex3_lsid[LSIQENTRY-1:0]         <=  {LSIQENTRY{1'b0}};
    ld_da_boundary                       <=  1'b0;
    lda_ex3_preg[PREG-1:0]               <=  {PREG{1'b0}};
    ld_da_already_da                     <=  1'b0;
    lda_pfu_ex3_ldfifo_pc[PC_LEN-1:0]    <=  {PC_LEN{1'b0}};
    ld_da_ahead_predict                  <=  1'b0;
    ld_da_wait_fence                     <=  1'b0;
    ld_da_other_discard_sq               <=  1'b0;
    ld_da_data_discard_sq                <=  1'b0;
    ld_da_fwd_sq_bypass                  <=  1'b0;
    lda_fwd_bypass_sel                   <=  1'b0;
    ld_da_fwd_sq_vld                     <=  1'b0;
    ld_da_data_vld_newest_fwd_sq_dup0    <=  1'b0;
    ld_da_data_vld_newest_fwd_sq_dup1    <=  1'b0;
    ld_da_data_vld_newest_fwd_sq_dup2    <=  1'b0;
    ld_da_data_vld_newest_fwd_sq_dup3    <=  1'b0;
    ld_da_fwd_sq_multi                   <=  1'b0;
    ld_da_fwd_sq_multi_mask              <=  1'b0;
    ld_da_fwd_bypass_sq_multi            <=  1'b0;
    lda_sq_ex3_fwd_id[SQ_ENTRY-1:0]      <=  {SQ_ENTRY{1'b0}};
    ld_da_discard_wmb                    <=  1'b0;
    ld_da_fwd_wmb_vld                    <=  1'b0;
    //ld_da_wmb_fwd_id[WMB_ENTRY-1:0] <=  {WMB_ENTRY{1'b0}};
    ld_da_spec_fail                      <=  1'b0;
    lda_ex3_vreg[VREG-1:0]               <=  {VREG{1'b0}};
    lda_ex3_inst_vfls                    <=  1'b0;
    ld_da_fwd_bytes_vld[15:0]            <=  16'b0;
    ld_da_fwd_bytes_vld_dup[15:0]        <=  16'b0;
    lda_lwb_ex3_preg_sign_sel[3:0]       <=  4'b0;
    lda_ex3_vreg_sign_sel                <=  1'b0;
    ld_da_cb_addr_create                 <=  1'b0;
    ld_da_cb_merge_en                    <=  1'b0;
    ld_da_pf_inst                        <=  1'b0;
    ld_da_no_spec[1:0]                   <=  2'b0;
    ld_da_no_spec_exist                  <=  1'b0;
    ld_da_vector_nop                     <=  1'b0;
    ld_da_lq_entry[LQENTRY-1:0]         <=  {LQENTRY{1'b0}};
    lda_ex3_reg_bytes_vld[15:0]          <=  16'b0;
    lda_ex3_inst_us                      <= 1'b0;
    lda_ex3_us_discard                   <= 1'b0;
    //lda_ex3_vsew[1:0]                    <=  2'b0;//rvv1.0@hcl
    lda_ex3_vmew[1:0]                    <=  2'b0;//rvv1.0@hcl
    lda_ex3_vmop[1:0]                    <=  2'b0;//rvv1.0@hcl   order index
    // lda_ex3_vlmul[1:0]                   <=  2'b0;
    lda_ex3_vlmul[2:0]                   <=  3'b0;    
    lda_ex3_element_size[1:0]            <=  2'b0;
    lda_ex3_element_cnt[8:0]             <=  9'b0;
    lda_ex3_setvl_val[8:0]               <=  9'b0;
    lda_ex3_vmb_id[VMB_ENTRY-1:0]        <=  {VMB_ENTRY{1'b0}};
    lda_ex3_inst_vls                     <=  1'b0;
    lda_ex3_inst_fof                     <=  1'b0;
    lda_ex3_vmb_merge_vld                <=  1'b0;
    lda_sfp_ex3_src_pc                   <=  {PC_LEN{1'b0}};
    ld_da_boundary_unmask                <=  1'b0; // Risc-V Debug zdb
  end
  else if(ldc_ex2_inst_vld && !lda_ecc_stall)
  begin
    ld_da_mmu_req                     <=  ldc_lda_ex2_mmu_req;
    ld_da_expt_vld_except_access_err  <=  ldc_lda_ex2_expt_vld_except_access_err;
    ld_da_expt_access_fault_mask      <=  ldc_lda_ex2_expt_access_fault_mask;
    ld_da_expt_access_fault_extra     <=  ldc_lda_ex2_expt_access_fault_extra;
    ld_da_expt_access_fault_mmu       <=  mmu_lsu_access_fault0;
    lda_pfu_ex3_va[`WK_PA_WIDTH-1:0]     <=  ldc_lda_ex2_pfu_va[`WK_PA_WIDTH-1:0];
    lda_ex3_split                     <=  ldc_lda_ex2_split;
    ld_da_inst_type[1:0]            <=  ldc_lda_ex2_inst_type[1:0];
    lda_ex3_inst_size[2:0]            <=  ldc_lda_ex2_inst_size[2:0];
    ld_da_secd                      <=  ldc_ex2_secd;
    lda_ex3_sext               <=  ldc_lda_ex2_sext;
    ld_da_atomic                    <=  ldc_lda_ex2_atomic;
    lda_ex3_iid[IID_WIDTH-1:0]       <=  ldc_ex2_iid[IID_WIDTH-1:0];
    lda_ex3_lsid[LSIQENTRY-1:0]      <=  ldc_lda_ex2_lsid[LSIQENTRY-1:0];
    ld_da_boundary                  <=  ldc_lda_ex2_boundary;
    lda_ex3_preg[PREG-1:0]                 <=  ldc_lda_ex2_preg[PREG-1:0];
    ld_da_already_da                <=  ldc_lda_ex2_already_da;
    lda_pfu_ex3_ldfifo_pc[PC_LEN-1:0]     <=  ldc_lda_ex2_ldfifo_pc[PC_LEN-1:0];
    ld_da_ahead_predict             <=  ldc_lda_ex2_ahead_predict;
    ld_da_wait_fence                <=  ldc_lda_ex2_wait_fence;
    ld_da_other_discard_sq          <=  sq_lda_ex2_other_discard_req;
    ld_da_data_discard_sq           <=  sq_lda_ex2_data_discard_req;
    ld_da_fwd_sq_bypass             <=  sq_lda_ex2_fwd_bypass_req;
    lda_fwd_bypass_sel               <=  sq_lda_ex2_fwd_bypass_sel;
    ld_da_fwd_sq_vld                <=  ldc_lda_ex2_fwd_sq_vld;
    ld_da_data_vld_newest_fwd_sq_dup0    <=  sq_ldc_ex2_newest_fwd_data_vld_req;
    ld_da_data_vld_newest_fwd_sq_dup1    <=  sq_ldc_ex2_newest_fwd_data_vld_req;
    ld_da_data_vld_newest_fwd_sq_dup2    <=  sq_ldc_ex2_newest_fwd_data_vld_req;
    ld_da_data_vld_newest_fwd_sq_dup3    <=  sq_ldc_ex2_newest_fwd_data_vld_req;
    ld_da_fwd_sq_multi              <=  sq_lda_ex2_fwd_multi;
    ld_da_fwd_sq_multi_mask         <=  sq_lda_ex2_fwd_multi_mask;
    ld_da_fwd_bypass_sq_multi       <=  sq_lda_ex2_fwd_bypass_multi;
    lda_sq_ex3_fwd_id[SQ_ENTRY-1:0]   <=  sq_lda_ex2_fwd_id[SQ_ENTRY-1:0];
    ld_da_discard_wmb               <=  wmb_ldc_discard_req;
    ld_da_fwd_wmb_vld               <=  ldc_lda_ex2_fwd_wmb_vld;
    //ld_da_wmb_fwd_id[WMB_ENTRY-1:0] <=  wmb_ld_dc_fwd_id[WMB_ENTRY-1:0];
    ld_da_spec_fail                 <=  ldc_lda_ex2_spec_fail;
    lda_ex3_vreg[VREG-1:0]                 <=  ldc_lda_ex2_vreg[VREG-1:0];
    lda_ex3_inst_vfls                 <=  ldc_lda_ex2_inst_vfls;
    ld_da_fwd_bytes_vld[15:0]       <=  ldc_lda_ex2_fwd_bytes_vld[15:0];
    ld_da_fwd_bytes_vld_dup[15:0]   <=  ldc_lda_ex2_fwd_bytes_vld[15:0];
    lda_lwb_ex3_preg_sign_sel[3:0]        <=  ldc_lda_ex2_preg_sign_sel[3:0];
    lda_ex3_vreg_sign_sel             <=  ldc_lda_ex2_vreg_sign_sel;
    ld_da_cb_addr_create            <=  ld_dc_da_cb_addr_create;
    ld_da_cb_merge_en               <=  ld_dc_da_cb_merge_en;
    ld_da_pf_inst                   <=  ldc_lda_ex2_pf_inst;
    ld_da_no_spec[1:0]              <=  ldc_lda_ex2_no_spec[1:0];
    ld_da_no_spec_exist             <=  ldc_lda_ex2_no_spec_exist;
    ld_da_vector_nop                <=  ldc_lda_ex2_vector_nop;
    ld_da_lq_entry[LQENTRY-1:0]    <=  ldc_lda_ex2_lq_entry[LQENTRY-1:0];
    lda_ex3_reg_bytes_vld[15:0]       <=  ldc_lda_ex2_reg_bytes_vld[15:0];
    lda_ex3_inst_us                   <=  ldc_lda_ex2_inst_us;
    lda_ex3_us_discard                <=  ldc_lda_ex2_us_discard;
    //lda_ex3_vsew[1:0]                 <=  ldc_lda_ex2_vsew[1:0];
    lda_ex3_vmew[1:0]                 <=  ldc_lda_ex2_vmew[1:0];
    lda_ex3_vmop[1:0]                 <=  ldc_lda_ex2_vmop[1:0];
    // lda_ex3_vlmul[1:0]                <=  ldc_lda_ex2_vlmul[1:0];
    lda_ex3_vlmul[2:0]                <=  ldc_lda_ex2_vlmul[2:0];    
    lda_ex3_element_size[1:0]         <=  ldc_lda_ex2_element_size[1:0];
    lda_ex3_element_cnt[8:0]          <=  ldc_lda_ex2_element_cnt[8:0];
    lda_ex3_setvl_val[8:0]            <=  ldc_lda_ex2_setvl_val[8:0];
    lda_ex3_vmb_id[VMB_ENTRY-1:0]     <=  ldc_lda_ex2_vmb_id[VMB_ENTRY-1:0];
    lda_ex3_inst_vls                  <=  ldc_lda_ex2_inst_vls;
    lda_ex3_inst_fof                  <=  ldc_lda_ex2_inst_fof;
    lda_ex3_vmb_merge_vld             <=  ldc_lda_ex2_vmb_merge_vld;
    lda_sfp_ex3_src_pc                <=  lq_lsu_ex2_spec_fail_pc; // wjh@sfp
    ld_da_boundary_unmask             <=  ld_dc_boundary_unmask; // Risc-V Debug zdb
  end
end

always @(posedge lda_inst_clk or negedge cpurst_b)begin 
  if(!cpurst_b)begin 
    lda_ex3_bytes_vld1[15:0]               <=  16'b0;
    lda_ex3_bytes_vld2[15:0]               <=  16'b0;
    lda_ex3_bytes_vld3[15:0]               <=  16'b0;
    lda_ex3_reg_bytes_vld1[15:0]         <=  16'b0;
    lda_ex3_reg_bytes_vld2[15:0]         <=  16'b0;
    lda_ex3_reg_bytes_vld3[15:0]         <=  16'b0;
  end
  else if(ldc_ex2_inst_vld & ~lda_ecc_stall & ldc_lda_ex2_inst_us)begin 
    lda_ex3_bytes_vld1[15:0]          <=  ldc_lda_ex2_bytes_vld1[15:0];
    lda_ex3_bytes_vld2[15:0]          <=  ldc_lda_ex2_bytes_vld2[15:0];
    lda_ex3_bytes_vld3[15:0]          <=  ldc_lda_ex2_bytes_vld3[15:0];
    lda_ex3_reg_bytes_vld1[15:0]      <=  ldc_lda_ex2_reg_bytes_vld1[15:0];
    lda_ex3_reg_bytes_vld2[15:0]      <=  ldc_lda_ex2_reg_bytes_vld2[15:0];
    lda_ex3_reg_bytes_vld3[15:0]      <=  ldc_lda_ex2_reg_bytes_vld3[15:0];
  end
end
//------------------inst/borrow share part------------------
//+------+-----------------+------------------+
//| addr | dcache_data_sel | page_information |
//+------+-----------------+------------------+
// &Force("output","lda_ex3_page_ca"); @688
// &Force("output","lda_ex3_page_so"); @689
// &Force("output","lda_ex3_page_sec"); @690
// &Force("output","lda_ex3_page_share"); @691
// &Force("output","lda_ex3_data_rot_sel"); @692
always @(posedge lda_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    ld_da_addr0_idx[`WK_PA_WIDTH-7:0]          <=  {`WK_PA_WIDTH-6{1'b0}};
    lda_ex3_old                               <=  1'b0;
    lda_ex3_page_so                           <=  1'b0;
    lda_ex3_page_ca                           <=  1'b0;
    lda_ex3_page_buf                          <=  1'b0;
    lda_ex3_page_sec                          <=  1'b0;
    lda_ex3_page_share                        <=  1'b0;
    lda_ex3_data_rot_sel[15:0]                <=  16'b0;
    lda_ex3_bytes_vld[15:0]                   <=  16'b0;
  end
  else if((ldc_ex2_inst_vld  ||  ldc_ex2_borrow_vld && !ldc_lda_ex2_borrow_vb && !ldc_lda_ex2_borrow_sndb) && !lda_ecc_stall)
  begin
    ld_da_addr0_idx[`WK_PA_WIDTH-7:0]         <=  ldc_ex2_addr0[`WK_PA_WIDTH-1:6];
    lda_ex3_old                               <=  ldc_lda_ex2_old;
    lda_ex3_page_so                           <=  ldc_lda_ex2_page_so;
    lda_ex3_page_ca                           <=  ldc_lda_ex2_page_ca;
    lda_ex3_page_buf                          <=  ldc_lda_ex2_page_buf;
    lda_ex3_page_sec                          <=  ldc_lda_ex2_page_sec;
    lda_ex3_page_share                        <=  ldc_lda_ex2_page_share;
    lda_ex3_data_rot_sel[15:0]                <=  ldc_lda_ex2_rot_sel[15:0];
    lda_ex3_bytes_vld[15:0]                   <=  ldc_lda_ex2_bytes_vld[15:0];
  end
end

always @(posedge lda_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    lda_addr0[`WK_PA_WIDTH-1:0]    <=  {`WK_PA_WIDTH{1'b0}};
  else if((ldc_ex2_inst_vld  ||  ldc_ex2_borrow_vld) && !lda_ecc_stall)
    lda_addr0[`WK_PA_WIDTH-1:0]    <=  ldc_ex2_addr0[`WK_PA_WIDTH-1:0];
end



always @(posedge lda_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    lda_ex3_dcache_hit         <=  1'b0;
    ld_da_hit_0_region         <=  1'b0;
    ld_da_hit_0_region_dup0    <=  1'b0;
    ld_da_hit_0_region_dup1    <=  1'b0;
    ld_da_hit_0_region_dup2    <=  1'b0;
    ld_da_hit_0_region_dup3    <=  1'b0;
    ld_da_hit_1_region         <=  1'b0;
    ld_da_hit_1_region_dup0    <=  1'b0;
    ld_da_hit_1_region_dup1    <=  1'b0;
    ld_da_hit_1_region_dup2    <=  1'b0;
    ld_da_hit_1_region_dup3    <=  1'b0;
    ld_da_hit_2_region         <=  1'b0;
    ld_da_hit_2_region_dup0    <=  1'b0;
    ld_da_hit_2_region_dup1    <=  1'b0;
    ld_da_hit_2_region_dup2    <=  1'b0;
    ld_da_hit_2_region_dup3    <=  1'b0;
    ld_da_hit_3_region         <=  1'b0;
    ld_da_hit_3_region_dup0    <=  1'b0;
    ld_da_hit_3_region_dup1    <=  1'b0;
    ld_da_hit_3_region_dup2    <=  1'b0;
    ld_da_hit_3_region_dup3    <=  1'b0;
  end
  else if(lda_tag_ecc_stall)
  begin
    lda_ex3_dcache_hit         <=  ld_da_ecc_dcache_hit;
    ld_da_hit_0_region         <=  ld_da_ecc_hit_0_region;
    ld_da_hit_0_region_dup0    <=  ld_da_ecc_hit_0_region;
    ld_da_hit_0_region_dup1    <=  ld_da_ecc_hit_0_region;
    ld_da_hit_0_region_dup2    <=  ld_da_ecc_hit_0_region;
    ld_da_hit_0_region_dup3    <=  ld_da_ecc_hit_0_region;
    ld_da_hit_1_region         <=  ld_da_ecc_hit_1_region;
    ld_da_hit_1_region_dup0    <=  ld_da_ecc_hit_1_region;
    ld_da_hit_1_region_dup1    <=  ld_da_ecc_hit_1_region;
    ld_da_hit_1_region_dup2    <=  ld_da_ecc_hit_1_region;
    ld_da_hit_1_region_dup3    <=  ld_da_ecc_hit_1_region;
    ld_da_hit_2_region         <=  ld_da_ecc_hit_2_region;
    ld_da_hit_2_region_dup0    <=  ld_da_ecc_hit_2_region;
    ld_da_hit_2_region_dup1    <=  ld_da_ecc_hit_2_region;
    ld_da_hit_2_region_dup2    <=  ld_da_ecc_hit_2_region;
    ld_da_hit_2_region_dup3    <=  ld_da_ecc_hit_2_region;
    ld_da_hit_3_region         <=  ld_da_ecc_hit_3_region;
    ld_da_hit_3_region_dup0    <=  ld_da_ecc_hit_3_region;
    ld_da_hit_3_region_dup1    <=  ld_da_ecc_hit_3_region;
    ld_da_hit_3_region_dup2    <=  ld_da_ecc_hit_3_region;
    ld_da_hit_3_region_dup3    <=  ld_da_ecc_hit_3_region;
  end
  else if((ldc_ex2_inst_vld  ||  ldc_ex2_borrow_vld && (ldc_lda_ex2_borrow_mmu || ldc_lda_ex2_borrow_prq)) && !lda_ecc_stall)
  begin
    lda_ex3_dcache_hit         <=  ldc_lda_ex2_dcache_hit;
    ld_da_hit_0_region         <=  ldc_lda_ex2_hit_0_region;
    ld_da_hit_0_region_dup0    <=  ldc_lda_ex2_hit_0_region;
    ld_da_hit_0_region_dup1    <=  ldc_lda_ex2_hit_0_region;
    ld_da_hit_0_region_dup2    <=  ldc_lda_ex2_hit_0_region;
    ld_da_hit_0_region_dup3    <=  ldc_lda_ex2_hit_0_region;
    ld_da_hit_1_region         <=  ldc_lda_ex2_hit_1_region;
    ld_da_hit_1_region_dup0    <=  ldc_lda_ex2_hit_1_region;
    ld_da_hit_1_region_dup1    <=  ldc_lda_ex2_hit_1_region;
    ld_da_hit_1_region_dup2    <=  ldc_lda_ex2_hit_1_region;
    ld_da_hit_1_region_dup3    <=  ldc_lda_ex2_hit_1_region;
    ld_da_hit_2_region         <=  ldc_lda_ex2_hit_2_region;
    ld_da_hit_2_region_dup0    <=  ldc_lda_ex2_hit_2_region;
    ld_da_hit_2_region_dup1    <=  ldc_lda_ex2_hit_2_region;
    ld_da_hit_2_region_dup2    <=  ldc_lda_ex2_hit_2_region;
    ld_da_hit_2_region_dup3    <=  ldc_lda_ex2_hit_2_region;
    ld_da_hit_3_region         <=  ldc_lda_ex2_hit_3_region;
    ld_da_hit_3_region_dup0    <=  ldc_lda_ex2_hit_3_region;
    ld_da_hit_3_region_dup1    <=  ldc_lda_ex2_hit_3_region;
    ld_da_hit_3_region_dup2    <=  ldc_lda_ex2_hit_3_region;
    ld_da_hit_3_region_dup3    <=  ldc_lda_ex2_hit_3_region;
  end
end

//for ecc info
always @(posedge lda_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    //ld_da_hit_way0              <=  1'b0;
    ld_da_hit_way              <=  4'b0;
  end
  else if(lda_tag_ecc_stall)
  begin
    //ld_da_hit_way0              <=  ld_da_ecc_hit_way0;
    ld_da_hit_way              <=  {ld_da_ecc_hit_way3,ld_da_ecc_hit_way2,ld_da_ecc_hit_way1,ld_da_ecc_hit_way0};
  end
  else if((ldc_ex2_inst_vld  ||  ldc_ex2_borrow_vld && (ldc_lda_ex2_borrow_mmu || ldc_lda_ex2_borrow_prq)) && !lda_ecc_stall)
  begin
    //ld_da_hit_way0              <=  ldc_lda_ex2_hit_way0;
    ld_da_hit_way               <=   ldc_hit_way;
  end
end
always @( ld_da_hit_way[3:0])
begin
case(ld_da_hit_way[3:0])
  4'b1000: ld_da_hit_way_2bit[1:0] = 2'b11;  //way3
  4'b0100: ld_da_hit_way_2bit[1:0] = 2'b10;  //way2
  4'b0010: ld_da_hit_way_2bit[1:0] = 2'b01;  //way1
  4'b0001: ld_da_hit_way_2bit[1:0] = 2'b00;  //way0
  default: ld_da_hit_way_2bit[1:0] = 2'b00;
endcase
end

//+----------+
//| pfu_addr |
//+----------+
//low power pfu_addr, reverse only when pfb/sdb not empty
always @(posedge ld_da_pfu_info_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    lda_ppfu_ex3_va[`WK_PA_WIDTH-1:0]      <=  {`WK_PA_WIDTH{1'b0}};
  else if(ldc_lda_ex2_pfu_info_set_vld && !lda_ecc_stall)
    lda_ppfu_ex3_va[`WK_PA_WIDTH-1:0]      <=  ldc_lda_ex2_pfu_va[`WK_PA_WIDTH-1:0];
end

//==========================================================
//        Generate expt info
//==========================================================
assign ld_da_expt_access_fault  = (ld_da_mmu_req
                                          &&  ld_da_expt_access_fault_mmu
                                      ||  ld_da_expt_access_fault_extra)
                                  &&  !ld_da_expt_access_fault_mask;

// //&Force("output","ld_da_expt_vld"); @858
//ecc err will not trigger expt, cause interrupt instead
assign ld_da_ecc_stall_tag_fatal = lda_ecc_stall_fatal & ~lda_ecc_stall_data; 

// &Force("output","lda_lwb_ex3_expt_vld"); @862
assign ld_da_expt_ori = ld_da_expt_vld_except_access_err
                         ||  ld_da_expt_access_fault
                         ||  ld_da_ecc_stall_tag_fatal;

assign ld_da_expt_vld = (ld_da_expt_vld_except_access_err
                         ||  ld_da_expt_access_fault
                         ||  ld_da_ecc_stall_tag_fatal)
                        && !ld_da_fof_not_first
                        && !ld_da_vector_nop;

assign lda_lwb_ex3_expt_vld = (ld_da_expt_vld_except_access_err
                               ||  ld_da_expt_access_fault)
                           && !ld_da_fof_not_first
                           && !ld_da_vector_nop;

// &CombBeg; @878
always @( ld_da_mt_value[`WK_PA_WIDTH-1:0]
       or ld_da_expt_access_fault
       or ld_da_expt_vec[4:0]
       or ld_da_atomic)
begin
lda_lwb_ex3_expt_vec[4:0]  = ld_da_expt_vec[4:0];

ld_da_wb_mt_value_ori[`WK_PA_WIDTH-1:0]  = ld_da_mt_value[`WK_PA_WIDTH-1:0];
if(ld_da_expt_access_fault &&  !ld_da_atomic)
begin
  lda_lwb_ex3_expt_vec[4:0]  = 5'd5;
  ld_da_wb_mt_value_ori[`WK_PA_WIDTH-1:0]  = {`WK_PA_WIDTH{1'b0}};
end
else if(ld_da_expt_access_fault &&  ld_da_atomic)
begin
  lda_lwb_ex3_expt_vec[4:0]  = 5'd7;
  ld_da_wb_mt_value_ori[`WK_PA_WIDTH-1:0]  = {`WK_PA_WIDTH{1'b0}};
end
//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
else if(dtu_lsu_addr_halt_info[0] & ld_da_boundary_unmask | dtu_lsu_addr_halt_info[1] & ld_da_boundary_unmask & ~lda_lwb_ex3_expt_vld)
begin
  lda_lwb_ex3_expt_vec[4:0]  = 5'd3;
  ld_da_wb_mt_value_ori[`WK_PA_WIDTH-1:0]  = {`WK_PA_WIDTH{1'b0}};
end
//==========================================================
//                  Risc-V Debug zdb End 
//==========================================================
// &CombEnd; @892
end

// &Force("output","lda_ex3_element_cnt"); @895
// &Force("output","lda_ex3_vlmul"); @896
// &Force("output","lda_ex3_inst_fof"); @897
// &Force("output","lda_ex3_split"); @898
// &Force("output","lda_ex3_setvl_val"); @899
// &Force("output","lda_rb_ex3_expt_vld"); @900
assign lda_rb_ex3_expt_vld = lda_ex3_inst_vld
                           && (ld_da_expt_vld_except_access_err
                               ||  ld_da_expt_access_fault)
                           && !ld_da_vector_nop;

assign ld_da_fof_not_first = lda_ex3_inst_fof
                             && !(lda_ex3_setvl_val[8:0] == 9'b0);

assign lda_lwb_ex3_vsetvl = lda_ex3_inst_vld
                         && !ld_da_vector_nop
                         && ld_da_fof_not_first
                         && (ld_da_expt_vld_except_access_err
                             ||  ld_da_expt_access_fault)
                         && ~dtu_lsu_addr_halt_info[0]; // Risc-V Debug zdb

assign ld_da_vl_upval[8:0] = lda_ex3_setvl_val[8:0];

assign lda_lwb_ex3_mtval[`WK_PA_WIDTH-1:0] = lda_lwb_ex3_expt_vld
                                          ? ld_da_wb_mt_value_ori[`WK_PA_WIDTH-1:0]
                                          // : {{`WK_PA_WIDTH-16{1'b0}},3'b100,1'b0,ld_da_vl_upval[6:0],1'b0,lda_ex3_vmew[1:0],lda_ex3_vlmul[1:0]}; //rvv1.0@hcl
                                          : {{`WK_PA_WIDTH-19{1'b0}},3'b100,1'b0,ld_da_vl_upval[8:0],1'b0,lda_ex3_vmew[1:0],lda_ex3_vlmul[2:0]}; //rvv1.0@hcl                                          

assign lda_lwb_ex3_vstart_vld = lda_ex3_inst_vld
                             && lda_ex3_inst_vls
                             && (lda_lwb_ex3_expt_vld
                                 || (dtu_lsu_addr_halt_info[0] // Risc-V Debug zdb
                                    && ~ld_da_fof_not_first)
                                 || (cp0_lsu_vstart[`VSTART_WIDTH-1:0] != `VSTART_WIDTH'b0)
                                    && !lda_ex3_split
                                    && !lda_lwb_ex3_expt_vld_cancel); // Risc-V Debug zdb

//==========================================================
//        Generate inst type
//==========================================================
//ld/ldr/lrw/pop/lrs is treated as ld inst
assign ld_da_ld_inst    = !ld_da_atomic
                          &&  (ld_da_inst_type[1:0]  == 2'b00);
assign ld_da_ldamo_inst = ld_da_atomic
                          &&  (ld_da_inst_type[1:0]  == 2'b00);
assign ld_da_lr_inst    = ld_da_atomic
                          &&  (ld_da_inst_type[1:0]  == 2'b01);

//==========================================================
//        Data forward from sq/wmb
//==========================================================
//data forward from sq/wmb is done in sq/wmb file
assign sq_ld_da_fwd_data_128[127:0] = sq_lda_ex2_fwd_data[127:0];
assign sq_ld_da_fwd_data_pe_128[127:0] = sq_lda_ex2_fwd_data_pe[127:0];
assign wmb_ld_da_fwd_data_128[127:0] = wmb_lda_fwd_data[127:0];

assign ld_da_fwd_wmb_data_am[127:0] = {{{8{lda_ex3_bytes_vld[15]}}  & wmb_ld_da_fwd_data_128[127:120]}
                                      ,{{8{lda_ex3_bytes_vld[14]}}  & wmb_ld_da_fwd_data_128[119:112]}
                                      ,{{8{lda_ex3_bytes_vld[13]}}  & wmb_ld_da_fwd_data_128[111:104]}
                                      ,{{8{lda_ex3_bytes_vld[12]}}  & wmb_ld_da_fwd_data_128[103:96]}
                                      ,{{8{lda_ex3_bytes_vld[11]}}  & wmb_ld_da_fwd_data_128[95:88]}
                                      ,{{8{lda_ex3_bytes_vld[10]}}  & wmb_ld_da_fwd_data_128[87:80]}
                                      ,{{8{lda_ex3_bytes_vld[9]}}   & wmb_ld_da_fwd_data_128[79:72]}
                                      ,{{8{lda_ex3_bytes_vld[8]}}   & wmb_ld_da_fwd_data_128[71:64]}
                                      ,{{8{lda_ex3_bytes_vld[7]}}   & wmb_ld_da_fwd_data_128[63:56]}
                                      ,{{8{lda_ex3_bytes_vld[6]}}   & wmb_ld_da_fwd_data_128[55:48]}
                                      ,{{8{lda_ex3_bytes_vld[5]}}   & wmb_ld_da_fwd_data_128[47:40]}
                                      ,{{8{lda_ex3_bytes_vld[4]}}   & wmb_ld_da_fwd_data_128[39:32]}
                                      ,{{8{lda_ex3_bytes_vld[3]}}   & wmb_ld_da_fwd_data_128[31:24]}
                                      ,{{8{lda_ex3_bytes_vld[2]}}   & wmb_ld_da_fwd_data_128[23:16]}
                                      ,{{8{lda_ex3_bytes_vld[1]}}   & wmb_ld_da_fwd_data_128[15:8]}
                                      ,{{8{lda_ex3_bytes_vld[0]}}   & wmb_ld_da_fwd_data_128[7:0]}};

assign ld_da_fwd_sq_data_pe_am[127:0] = {{{8{lda_ex3_bytes_vld[15]}}  & sq_ld_da_fwd_data_pe_128[127:120]}
                                        ,{{8{lda_ex3_bytes_vld[14]}}  & sq_ld_da_fwd_data_pe_128[119:112]}
                                        ,{{8{lda_ex3_bytes_vld[13]}}  & sq_ld_da_fwd_data_pe_128[111:104]}
                                        ,{{8{lda_ex3_bytes_vld[12]}}  & sq_ld_da_fwd_data_pe_128[103:96]}
                                        ,{{8{lda_ex3_bytes_vld[11]}}  & sq_ld_da_fwd_data_pe_128[95:88]}
                                        ,{{8{lda_ex3_bytes_vld[10]}}  & sq_ld_da_fwd_data_pe_128[87:80]}
                                        ,{{8{lda_ex3_bytes_vld[9]}}   & sq_ld_da_fwd_data_pe_128[79:72]}
                                        ,{{8{lda_ex3_bytes_vld[8]}}   & sq_ld_da_fwd_data_pe_128[71:64]}
                                        ,{{8{lda_ex3_bytes_vld[7]}}   & sq_ld_da_fwd_data_pe_128[63:56]}
                                        ,{{8{lda_ex3_bytes_vld[6]}}   & sq_ld_da_fwd_data_pe_128[55:48]}
                                        ,{{8{lda_ex3_bytes_vld[5]}}   & sq_ld_da_fwd_data_pe_128[47:40]}
                                        ,{{8{lda_ex3_bytes_vld[4]}}   & sq_ld_da_fwd_data_pe_128[39:32]}
                                        ,{{8{lda_ex3_bytes_vld[3]}}   & sq_ld_da_fwd_data_pe_128[31:24]}
                                        ,{{8{lda_ex3_bytes_vld[2]}}   & sq_ld_da_fwd_data_pe_128[23:16]}
                                        ,{{8{lda_ex3_bytes_vld[1]}}   & sq_ld_da_fwd_data_pe_128[15:8]}
                                        ,{{8{lda_ex3_bytes_vld[0]}}   & sq_ld_da_fwd_data_pe_128[7:0]}};

assign ld_da_fwd_sq_data_am[127:0]    = {{{8{lda_ex3_bytes_vld[15]}}  & sq_ld_da_fwd_data_128[127:120]}
                                        ,{{8{lda_ex3_bytes_vld[14]}}  & sq_ld_da_fwd_data_128[119:112]}
                                        ,{{8{lda_ex3_bytes_vld[13]}}  & sq_ld_da_fwd_data_128[111:104]}
                                        ,{{8{lda_ex3_bytes_vld[12]}}  & sq_ld_da_fwd_data_128[103:96]}
                                        ,{{8{lda_ex3_bytes_vld[11]}}  & sq_ld_da_fwd_data_128[95:88]}
                                        ,{{8{lda_ex3_bytes_vld[10]}}  & sq_ld_da_fwd_data_128[87:80]}
                                        ,{{8{lda_ex3_bytes_vld[9]}}   & sq_ld_da_fwd_data_128[79:72]}
                                        ,{{8{lda_ex3_bytes_vld[8]}}   & sq_ld_da_fwd_data_128[71:64]}
                                        ,{{8{lda_ex3_bytes_vld[7]}}   & sq_ld_da_fwd_data_128[63:56]}
                                        ,{{8{lda_ex3_bytes_vld[6]}}   & sq_ld_da_fwd_data_128[55:48]}
                                        ,{{8{lda_ex3_bytes_vld[5]}}   & sq_ld_da_fwd_data_128[47:40]}
                                        ,{{8{lda_ex3_bytes_vld[4]}}   & sq_ld_da_fwd_data_128[39:32]}
                                        ,{{8{lda_ex3_bytes_vld[3]}}   & sq_ld_da_fwd_data_128[31:24]}
                                        ,{{8{lda_ex3_bytes_vld[2]}}   & sq_ld_da_fwd_data_128[23:16]}
                                        ,{{8{lda_ex3_bytes_vld[1]}}   & sq_ld_da_fwd_data_128[15:8]}
                                        ,{{8{lda_ex3_bytes_vld[0]}}   & sq_ld_da_fwd_data_128[7:0]}};

assign ld_da_fwd_data_am[127:0]     = ld_da_fwd_sq_vld
                                      ? ld_da_fwd_sq_data_am[127:0]
                                      : ld_da_fwd_wmb_data_am[127:0];


assign ld_da_fwd_data_pe_am[31:0]   = ld_da_data_vld_newest_fwd_sq_dup0
                                      ? ld_da_fwd_sq_data_pe_am[31:0]
                                      : ld_da_fwd_wmb_data_am[31:0];
assign ld_da_fwd_data_pe_am[63:32]  = ld_da_data_vld_newest_fwd_sq_dup1
                                      ? ld_da_fwd_sq_data_pe_am[63:32]
                                      : ld_da_fwd_wmb_data_am[63:32];
assign ld_da_fwd_data_pe_am[95:64]  = ld_da_data_vld_newest_fwd_sq_dup2
                                      ? ld_da_fwd_sq_data_pe_am[95:64]
                                      : ld_da_fwd_wmb_data_am[95:64];
assign ld_da_fwd_data_pe_am[127:96] = ld_da_data_vld_newest_fwd_sq_dup3
                                      ? ld_da_fwd_sq_data_pe_am[127:96]
                                      : ld_da_fwd_wmb_data_am[127:96];

// // &CombBeg; @1025
// always @( sd_ex1_data_bypass[127:0]
//        or lda_ex3_inst_size[2:0])
// begin
// case(lda_ex3_inst_size[2:0])
//   3'b000: ld_da_fwd_data_bypass[127:0] = {120'b0,sd_ex1_data_bypass[7:0]};  //byte
//   3'b001: ld_da_fwd_data_bypass[127:0] = {112'b0,sd_ex1_data_bypass[15:0]}; //half
//   3'b010: ld_da_fwd_data_bypass[127:0] = {96'b0,sd_ex1_data_bypass[31:0]};  //word
//   3'b011: ld_da_fwd_data_bypass[127:0] = {64'b0,sd_ex1_data_bypass[63:0]};  //dword
//   default:ld_da_fwd_data_bypass[127:0] = sd_ex1_data_bypass[127:0];         //qword
// endcase
// // &CombEnd; @1033
// end

// &CombBeg; @1025
always @( std0_ex1_data_bypass[127:0]
       or lda_ex3_inst_size[2:0])
begin
case(lda_ex3_inst_size[2:0])
  3'b000: ld_da_fwd_data_bypass0[127:0] = {120'b0,std0_ex1_data_bypass[7:0]};  //byte
  3'b001: ld_da_fwd_data_bypass0[127:0] = {112'b0,std0_ex1_data_bypass[15:0]}; //half
  3'b010: ld_da_fwd_data_bypass0[127:0] = {96'b0,std0_ex1_data_bypass[31:0]};  //word
  3'b011: ld_da_fwd_data_bypass0[127:0] = {64'b0,std0_ex1_data_bypass[63:0]};  //dword
  default:ld_da_fwd_data_bypass0[127:0] = std0_ex1_data_bypass[127:0];         //qword
endcase
// &CombEnd; @1033
end

always @( std1_ex1_data_bypass[127:0]
       or lda_ex3_inst_size[2:0])
begin
case(lda_ex3_inst_size[2:0])
  3'b000: ld_da_fwd_data_bypass1[127:0] = {120'b0,std1_ex1_data_bypass[7:0]};  //byte
  3'b001: ld_da_fwd_data_bypass1[127:0] = {112'b0,std1_ex1_data_bypass[15:0]}; //half
  3'b010: ld_da_fwd_data_bypass1[127:0] = {96'b0,std1_ex1_data_bypass[31:0]};  //word
  3'b011: ld_da_fwd_data_bypass1[127:0] = {64'b0,std1_ex1_data_bypass[63:0]};  //dword
  default:ld_da_fwd_data_bypass1[127:0] = std1_ex1_data_bypass[127:0];         //qword
endcase
// &CombEnd; @1033
end

assign ld_da_fwd_data_bypass[127:0]  ={{128{lda_fwd_bypass_sel}} &  ld_da_fwd_data_bypass1[127:0]}
                                      |  {{128{!lda_fwd_bypass_sel}} &  ld_da_fwd_data_bypass0[127:0]};   //@wangyu
assign ld_da_fwd_vld          = ld_da_fwd_sq_vld
                                ||  ld_da_fwd_sq_bypass_vld  
                                ||  ld_da_fwd_wmb_vld
                                    &&  (lda_ex3_dcache_hit | lda_tcm_hit);

assign lda_merge_from_cb    = ld_da_cb_merge_en
                                   && cb_ld_da_data_vld
                                || lda_ecc_stall_cb_merge;

//==========================================================
//                Settle data from cache
//==========================================================
//------------------cache data settle to vb/snq------------
assign lda_data512_way0[511:0]   = {lda_dcache_data_bank15[31:0],    //255->511, L1D 2way->4 way, LTL@20250320
                                    lda_dcache_data_bank14[31:0],
                                    lda_dcache_data_bank13[31:0],
                                    lda_dcache_data_bank12[31:0],
                                    lda_dcache_data_bank11[31:0],
                                    lda_dcache_data_bank10[31:0],
                                    lda_dcache_data_bank9[31:0],
                                    lda_dcache_data_bank8[31:0],
                                    lda_dcache_data_bank7[31:0],
                                    lda_dcache_data_bank6[31:0],
                                    lda_dcache_data_bank5[31:0],
                                    lda_dcache_data_bank4[31:0],
                                    lda_dcache_data_bank3[31:0],
                                    lda_dcache_data_bank2[31:0],
                                    lda_dcache_data_bank1[31:0],
                                    lda_dcache_data_bank0[31:0]};

assign lda_data512_way1[511:0]   = {lda_dcache_data_bank11[31:0],
                                    lda_dcache_data_bank10[31:0],
                                    lda_dcache_data_bank9[31:0],
                                    lda_dcache_data_bank8[31:0],
                                    lda_dcache_data_bank15[31:0],
                                    lda_dcache_data_bank14[31:0],
                                    lda_dcache_data_bank13[31:0],
                                    lda_dcache_data_bank12[31:0],
                                    lda_dcache_data_bank3[31:0],
                                    lda_dcache_data_bank2[31:0],
                                    lda_dcache_data_bank1[31:0],
                                    lda_dcache_data_bank0[31:0],
                                    lda_dcache_data_bank7[31:0],
                                    lda_dcache_data_bank6[31:0],
                                    lda_dcache_data_bank5[31:0],
                                    lda_dcache_data_bank4[31:0]};

assign lda_data512_way2[511:0]   = {lda_dcache_data_bank7[31:0],       //255->511, L1D 2way->4 way, LTL@20250320
                                    lda_dcache_data_bank6[31:0],
                                    lda_dcache_data_bank5[31:0],
                                    lda_dcache_data_bank4[31:0],
                                    lda_dcache_data_bank3[31:0],
                                    lda_dcache_data_bank2[31:0],
                                    lda_dcache_data_bank1[31:0],
                                    lda_dcache_data_bank0[31:0],
                                    lda_dcache_data_bank15[31:0],    
                                    lda_dcache_data_bank14[31:0],
                                    lda_dcache_data_bank13[31:0],
                                    lda_dcache_data_bank12[31:0],
                                    lda_dcache_data_bank11[31:0],
                                    lda_dcache_data_bank10[31:0],
                                    lda_dcache_data_bank9[31:0],
                                    lda_dcache_data_bank8[31:0]};
assign lda_data512_way3[511:0]   = {lda_dcache_data_bank3[31:0],      //255->511, L1D 2way->4 way, LTL@20250320
                                    lda_dcache_data_bank2[31:0],
                                    lda_dcache_data_bank1[31:0],
                                    lda_dcache_data_bank0[31:0],
                                    lda_dcache_data_bank7[31:0],       
                                    lda_dcache_data_bank6[31:0],
                                    lda_dcache_data_bank5[31:0],
                                    lda_dcache_data_bank4[31:0],
                                    lda_dcache_data_bank11[31:0],
                                    lda_dcache_data_bank10[31:0],
                                    lda_dcache_data_bank9[31:0],
                                    lda_dcache_data_bank8[31:0],
                                    lda_dcache_data_bank15[31:0],    
                                    lda_dcache_data_bank14[31:0],
                                    lda_dcache_data_bank13[31:0],
                                    lda_dcache_data_bank12[31:0]};

assign lda_data512_way0_aft_ecc[511:0] = cp0_lsu_ecc_en
                                           ? lda_data512_way0_corrected[511:0]
                                           : lda_data512_way0[511:0];
assign lda_data512_way1_aft_ecc[511:0] = cp0_lsu_ecc_en
                                           ? lda_data512_way1_corrected[511:0]
                                           : lda_data512_way1[511:0];  
assign lda_data512_way2_aft_ecc[511:0] = cp0_lsu_ecc_en
                                           ? lda_data512_way2_corrected[511:0]
                                           : lda_data512_way2[511:0];
assign lda_data512_way3_aft_ecc[511:0] = cp0_lsu_ecc_en
                                           ? lda_data512_way3_corrected[511:0]
                                           : lda_data512_way3[511:0]; 

//assign lda_vb_ex3_data512[511:0]       = ld_da_settle_way
//                                          ? lda_data512_way1_aft_ecc[511:0]
//                                          : lda_data512_way0_aft_ecc[511:0];
always @( ld_da_settle_way[1:0]
          or lda_data512_way3_aft_ecc[511:0]
          or lda_data512_way2_aft_ecc[511:0]
          or lda_data512_way1_aft_ecc[511:0]
          or lda_data512_way0_aft_ecc[511:0])
begin
case(ld_da_settle_way[1:0])
  2'b11: lda_vb_ex3_data512[511:0] = lda_data512_way3_aft_ecc[ 511:0 ];  //way3
  2'b10: lda_vb_ex3_data512[511:0] = lda_data512_way2_aft_ecc[ 511:0 ];  //way2
  2'b01: lda_vb_ex3_data512[511:0] = lda_data512_way1_aft_ecc[ 511:0 ];  //way1
  2'b00: lda_vb_ex3_data512[511:0] = lda_data512_way0_aft_ecc[ 511:0 ];  //way0
  default: lda_vb_ex3_data512[511:0] = 512'b0;
endcase
end
generate 
  for(genvar i=0; i<16; i++)begin 
    assign lda_lwb_ex3_data0[i*8 +: 8] = {8{lda_ex3_bytes_vld[i]}}  & lda_vb_ex3_data512[i*8 +: 8];
    assign lda_lwb_ex3_data1[i*8 +: 8] = {8{lda_ex3_bytes_vld1[i]}} & lda_vb_ex3_data512[(i+16)*8 +: 8];
    assign lda_lwb_ex3_data2[i*8 +: 8] = {8{lda_ex3_bytes_vld2[i]}} & lda_vb_ex3_data512[(i+32)*8 +: 8];
    assign lda_lwb_ex3_data3[i*8 +: 8] = {8{lda_ex3_bytes_vld3[i]}} & lda_vb_ex3_data512[(i+48)*8 +: 8];
  end
endgenerate
//------------------cache data settle-----------------------
assign ld_da_3_region_data128_am[127:0]= {{{8{lda_ex3_bytes_vld[15]}}  & lda_dcache_data_bank15[31:24]}
                                            ,{{8{lda_ex3_bytes_vld[14]}}  & lda_dcache_data_bank15[23:16]}
                                            ,{{8{lda_ex3_bytes_vld[13]}}  & lda_dcache_data_bank15[15:8]}
                                            ,{{8{lda_ex3_bytes_vld[12]}}  & lda_dcache_data_bank15[7:0]}
                                            ,{{8{lda_ex3_bytes_vld[11]}}  & lda_dcache_data_bank14[31:24]}
                                            ,{{8{lda_ex3_bytes_vld[10]}}  & lda_dcache_data_bank14[23:16]}
                                            ,{{8{lda_ex3_bytes_vld[9]}}   & lda_dcache_data_bank14[15:8]}
                                            ,{{8{lda_ex3_bytes_vld[8]}}   & lda_dcache_data_bank14[7:0]}
                                            ,{{8{lda_ex3_bytes_vld[7]}}   & lda_dcache_data_bank13[31:24]}
                                            ,{{8{lda_ex3_bytes_vld[6]}}   & lda_dcache_data_bank13[23:16]}
                                            ,{{8{lda_ex3_bytes_vld[5]}}   & lda_dcache_data_bank13[15:8]}
                                            ,{{8{lda_ex3_bytes_vld[4]}}   & lda_dcache_data_bank13[7:0]}
                                            ,{{8{lda_ex3_bytes_vld[3]}}   & lda_dcache_data_bank12[31:24]}
                                            ,{{8{lda_ex3_bytes_vld[2]}}   & lda_dcache_data_bank12[23:16]}
                                            ,{{8{lda_ex3_bytes_vld[1]}}   & lda_dcache_data_bank12[15:8]}
                                            ,{{8{lda_ex3_bytes_vld[0]}}   & lda_dcache_data_bank12[7:0]}};
assign ld_da_2_region_data128_am[127:0]= {{{8{lda_ex3_bytes_vld[15]}}  & lda_dcache_data_bank11[31:24]}
                                            ,{{8{lda_ex3_bytes_vld[14]}}  & lda_dcache_data_bank11[23:16]}
                                            ,{{8{lda_ex3_bytes_vld[13]}}  & lda_dcache_data_bank11[15:8]}
                                            ,{{8{lda_ex3_bytes_vld[12]}}  & lda_dcache_data_bank11[7:0]}
                                            ,{{8{lda_ex3_bytes_vld[11]}}  & lda_dcache_data_bank10[31:24]}
                                            ,{{8{lda_ex3_bytes_vld[10]}}  & lda_dcache_data_bank10[23:16]}
                                            ,{{8{lda_ex3_bytes_vld[9]}}   & lda_dcache_data_bank10[15:8]}
                                            ,{{8{lda_ex3_bytes_vld[8]}}   & lda_dcache_data_bank10[7:0]}
                                            ,{{8{lda_ex3_bytes_vld[7]}}   & lda_dcache_data_bank9[31:24]}
                                            ,{{8{lda_ex3_bytes_vld[6]}}   & lda_dcache_data_bank9[23:16]}
                                            ,{{8{lda_ex3_bytes_vld[5]}}   & lda_dcache_data_bank9[15:8]}
                                            ,{{8{lda_ex3_bytes_vld[4]}}   & lda_dcache_data_bank9[7:0]}
                                            ,{{8{lda_ex3_bytes_vld[3]}}   & lda_dcache_data_bank8[31:24]}
                                            ,{{8{lda_ex3_bytes_vld[2]}}   & lda_dcache_data_bank8[23:16]}
                                            ,{{8{lda_ex3_bytes_vld[1]}}   & lda_dcache_data_bank8[15:8]}
                                            ,{{8{lda_ex3_bytes_vld[0]}}   & lda_dcache_data_bank8[7:0]}};
assign ld_da_1_region_data128_am[127:0]= {{{8{lda_ex3_bytes_vld[15]}}  & lda_dcache_data_bank7[31:24]}
                                            ,{{8{lda_ex3_bytes_vld[14]}}  & lda_dcache_data_bank7[23:16]}
                                            ,{{8{lda_ex3_bytes_vld[13]}}  & lda_dcache_data_bank7[15:8]}
                                            ,{{8{lda_ex3_bytes_vld[12]}}  & lda_dcache_data_bank7[7:0]}
                                            ,{{8{lda_ex3_bytes_vld[11]}}  & lda_dcache_data_bank6[31:24]}
                                            ,{{8{lda_ex3_bytes_vld[10]}}  & lda_dcache_data_bank6[23:16]}
                                            ,{{8{lda_ex3_bytes_vld[9]}}   & lda_dcache_data_bank6[15:8]}
                                            ,{{8{lda_ex3_bytes_vld[8]}}   & lda_dcache_data_bank6[7:0]}
                                            ,{{8{lda_ex3_bytes_vld[7]}}   & lda_dcache_data_bank5[31:24]}
                                            ,{{8{lda_ex3_bytes_vld[6]}}   & lda_dcache_data_bank5[23:16]}
                                            ,{{8{lda_ex3_bytes_vld[5]}}   & lda_dcache_data_bank5[15:8]}
                                            ,{{8{lda_ex3_bytes_vld[4]}}   & lda_dcache_data_bank5[7:0]}
                                            ,{{8{lda_ex3_bytes_vld[3]}}   & lda_dcache_data_bank4[31:24]}
                                            ,{{8{lda_ex3_bytes_vld[2]}}   & lda_dcache_data_bank4[23:16]}
                                            ,{{8{lda_ex3_bytes_vld[1]}}   & lda_dcache_data_bank4[15:8]}
                                            ,{{8{lda_ex3_bytes_vld[0]}}   & lda_dcache_data_bank4[7:0]}};

assign ld_da_0_region_data128_am[127:0] = {{{8{lda_ex3_bytes_vld[15]}}  & lda_dcache_data_bank3[31:24]}
                                            ,{{8{lda_ex3_bytes_vld[14]}}  & lda_dcache_data_bank3[23:16]}
                                            ,{{8{lda_ex3_bytes_vld[13]}}  & lda_dcache_data_bank3[15:8]}
                                            ,{{8{lda_ex3_bytes_vld[12]}}  & lda_dcache_data_bank3[7:0]}
                                            ,{{8{lda_ex3_bytes_vld[11]}}  & lda_dcache_data_bank2[31:24]}
                                            ,{{8{lda_ex3_bytes_vld[10]}}  & lda_dcache_data_bank2[23:16]}
                                            ,{{8{lda_ex3_bytes_vld[9]}}   & lda_dcache_data_bank2[15:8]}
                                            ,{{8{lda_ex3_bytes_vld[8]}}   & lda_dcache_data_bank2[7:0]}
                                            ,{{8{lda_ex3_bytes_vld[7]}}   & lda_dcache_data_bank1[31:24]}
                                            ,{{8{lda_ex3_bytes_vld[6]}}   & lda_dcache_data_bank1[23:16]}
                                            ,{{8{lda_ex3_bytes_vld[5]}}   & lda_dcache_data_bank1[15:8]}
                                            ,{{8{lda_ex3_bytes_vld[4]}}   & lda_dcache_data_bank1[7:0]}
                                            ,{{8{lda_ex3_bytes_vld[3]}}   & lda_dcache_data_bank0[31:24]}
                                            ,{{8{lda_ex3_bytes_vld[2]}}   & lda_dcache_data_bank0[23:16]}
                                            ,{{8{lda_ex3_bytes_vld[1]}}   & lda_dcache_data_bank0[15:8]}
                                            ,{{8{lda_ex3_bytes_vld[0]}}   & lda_dcache_data_bank0[7:0]}};
assign ld_da_3_region_data128_ahead_am[127:0]= {{{8{lda_ex3_bytes_vld[15]}}  & ld_da_dcache_data_ahead_bank15[31:24]}   //high->1 region, L1D 2way->4way, LTL@20250320
                                                  ,{{8{lda_ex3_bytes_vld[14]}}  & ld_da_dcache_data_ahead_bank15[23:16]}
                                                  ,{{8{lda_ex3_bytes_vld[13]}}  & ld_da_dcache_data_ahead_bank15[15:8]}
                                                  ,{{8{lda_ex3_bytes_vld[12]}}  & ld_da_dcache_data_ahead_bank15[7:0]}
                                                  ,{{8{lda_ex3_bytes_vld[11]}}  & ld_da_dcache_data_ahead_bank14[31:24]}
                                                  ,{{8{lda_ex3_bytes_vld[10]}}  & ld_da_dcache_data_ahead_bank14[23:16]}
                                                  ,{{8{lda_ex3_bytes_vld[9]}}   & ld_da_dcache_data_ahead_bank14[15:8]}
                                                  ,{{8{lda_ex3_bytes_vld[8]}}   & ld_da_dcache_data_ahead_bank14[7:0]}
                                                  ,{{8{lda_ex3_bytes_vld[7]}}   & ld_da_dcache_data_ahead_bank13[31:24]}
                                                  ,{{8{lda_ex3_bytes_vld[6]}}   & ld_da_dcache_data_ahead_bank13[23:16]}
                                                  ,{{8{lda_ex3_bytes_vld[5]}}   & ld_da_dcache_data_ahead_bank13[15:8]}
                                                  ,{{8{lda_ex3_bytes_vld[4]}}   & ld_da_dcache_data_ahead_bank13[7:0]}
                                                  ,{{8{lda_ex3_bytes_vld[3]}}   & ld_da_dcache_data_ahead_bank12[31:24]}
                                                  ,{{8{lda_ex3_bytes_vld[2]}}   & ld_da_dcache_data_ahead_bank12[23:16]}
                                                  ,{{8{lda_ex3_bytes_vld[1]}}   & ld_da_dcache_data_ahead_bank12[15:8]}
                                                  ,{{8{lda_ex3_bytes_vld[0]}}   & ld_da_dcache_data_ahead_bank12[7:0]}};

assign ld_da_2_region_data128_ahead_am[127:0] = {{{8{lda_ex3_bytes_vld[15]}}  & ld_da_dcache_data_ahead_bank11[31:24]}
                                                  ,{{8{lda_ex3_bytes_vld[14]}}  & ld_da_dcache_data_ahead_bank11[23:16]}
                                                  ,{{8{lda_ex3_bytes_vld[13]}}  & ld_da_dcache_data_ahead_bank11[15:8]}
                                                  ,{{8{lda_ex3_bytes_vld[12]}}  & ld_da_dcache_data_ahead_bank11[7:0]}
                                                  ,{{8{lda_ex3_bytes_vld[11]}}  & ld_da_dcache_data_ahead_bank10[31:24]}
                                                  ,{{8{lda_ex3_bytes_vld[10]}}  & ld_da_dcache_data_ahead_bank10[23:16]}
                                                  ,{{8{lda_ex3_bytes_vld[9]}}   & ld_da_dcache_data_ahead_bank10[15:8]}
                                                  ,{{8{lda_ex3_bytes_vld[8]}}   & ld_da_dcache_data_ahead_bank10[7:0]}
                                                  ,{{8{lda_ex3_bytes_vld[7]}}   & ld_da_dcache_data_ahead_bank9[31:24]}
                                                  ,{{8{lda_ex3_bytes_vld[6]}}   & ld_da_dcache_data_ahead_bank9[23:16]}
                                                  ,{{8{lda_ex3_bytes_vld[5]}}   & ld_da_dcache_data_ahead_bank9[15:8]}
                                                  ,{{8{lda_ex3_bytes_vld[4]}}   & ld_da_dcache_data_ahead_bank9[7:0]}
                                                  ,{{8{lda_ex3_bytes_vld[3]}}   & ld_da_dcache_data_ahead_bank8[31:24]}
                                                  ,{{8{lda_ex3_bytes_vld[2]}}   & ld_da_dcache_data_ahead_bank8[23:16]}
                                                  ,{{8{lda_ex3_bytes_vld[1]}}   & ld_da_dcache_data_ahead_bank8[15:8]}
                                                  ,{{8{lda_ex3_bytes_vld[0]}}   & ld_da_dcache_data_ahead_bank8[7:0]}};
assign ld_da_1_region_data128_ahead_am[127:0]= {{{8{lda_ex3_bytes_vld[15]}}  & ld_da_dcache_data_ahead_bank7[31:24]}   //high->1 region, L1D 2way->4way, LTL@20250320
                                                  ,{{8{lda_ex3_bytes_vld[14]}}  & ld_da_dcache_data_ahead_bank7[23:16]}
                                                  ,{{8{lda_ex3_bytes_vld[13]}}  & ld_da_dcache_data_ahead_bank7[15:8]}
                                                  ,{{8{lda_ex3_bytes_vld[12]}}  & ld_da_dcache_data_ahead_bank7[7:0]}
                                                  ,{{8{lda_ex3_bytes_vld[11]}}  & ld_da_dcache_data_ahead_bank6[31:24]}
                                                  ,{{8{lda_ex3_bytes_vld[10]}}  & ld_da_dcache_data_ahead_bank6[23:16]}
                                                  ,{{8{lda_ex3_bytes_vld[9]}}   & ld_da_dcache_data_ahead_bank6[15:8]}
                                                  ,{{8{lda_ex3_bytes_vld[8]}}   & ld_da_dcache_data_ahead_bank6[7:0]}
                                                  ,{{8{lda_ex3_bytes_vld[7]}}   & ld_da_dcache_data_ahead_bank5[31:24]}
                                                  ,{{8{lda_ex3_bytes_vld[6]}}   & ld_da_dcache_data_ahead_bank5[23:16]}
                                                  ,{{8{lda_ex3_bytes_vld[5]}}   & ld_da_dcache_data_ahead_bank5[15:8]}
                                                  ,{{8{lda_ex3_bytes_vld[4]}}   & ld_da_dcache_data_ahead_bank5[7:0]}
                                                  ,{{8{lda_ex3_bytes_vld[3]}}   & ld_da_dcache_data_ahead_bank4[31:24]}
                                                  ,{{8{lda_ex3_bytes_vld[2]}}   & ld_da_dcache_data_ahead_bank4[23:16]}
                                                  ,{{8{lda_ex3_bytes_vld[1]}}   & ld_da_dcache_data_ahead_bank4[15:8]}
                                                  ,{{8{lda_ex3_bytes_vld[0]}}   & ld_da_dcache_data_ahead_bank4[7:0]}};

assign ld_da_0_region_data128_ahead_am[127:0] = {{{8{lda_ex3_bytes_vld[15]}}  & ld_da_dcache_data_ahead_bank3[31:24]}
                                                  ,{{8{lda_ex3_bytes_vld[14]}}  & ld_da_dcache_data_ahead_bank3[23:16]}
                                                  ,{{8{lda_ex3_bytes_vld[13]}}  & ld_da_dcache_data_ahead_bank3[15:8]}
                                                  ,{{8{lda_ex3_bytes_vld[12]}}  & ld_da_dcache_data_ahead_bank3[7:0]}
                                                  ,{{8{lda_ex3_bytes_vld[11]}}  & ld_da_dcache_data_ahead_bank2[31:24]}
                                                  ,{{8{lda_ex3_bytes_vld[10]}}  & ld_da_dcache_data_ahead_bank2[23:16]}
                                                  ,{{8{lda_ex3_bytes_vld[9]}}   & ld_da_dcache_data_ahead_bank2[15:8]}
                                                  ,{{8{lda_ex3_bytes_vld[8]}}   & ld_da_dcache_data_ahead_bank2[7:0]}
                                                  ,{{8{lda_ex3_bytes_vld[7]}}   & ld_da_dcache_data_ahead_bank1[31:24]}
                                                  ,{{8{lda_ex3_bytes_vld[6]}}   & ld_da_dcache_data_ahead_bank1[23:16]}
                                                  ,{{8{lda_ex3_bytes_vld[5]}}   & ld_da_dcache_data_ahead_bank1[15:8]}
                                                  ,{{8{lda_ex3_bytes_vld[4]}}   & ld_da_dcache_data_ahead_bank1[7:0]}
                                                  ,{{8{lda_ex3_bytes_vld[3]}}   & ld_da_dcache_data_ahead_bank0[31:24]}
                                                  ,{{8{lda_ex3_bytes_vld[2]}}   & ld_da_dcache_data_ahead_bank0[23:16]}
                                                  ,{{8{lda_ex3_bytes_vld[1]}}   & ld_da_dcache_data_ahead_bank0[15:8]}
                                                  ,{{8{lda_ex3_bytes_vld[0]}}   & ld_da_dcache_data_ahead_bank0[7:0]}};


//==========================================================
//        Compare tag and select data from cache/sq|wmb
//==========================================================
//------------------compare tag-----------------------------
//assign ld_da_tag[17:0]      = lda_addr0[31:14];
// &Force("output","lda_ex3_idx"); @1161
assign lda_ex3_idx[`WK_PA_WIDTH-7:0]       = ld_da_addr0_idx[`WK_PA_WIDTH-7:0];
assign lda_ex3_addr_5to4[1:0] = lda_addr0[5:4];

// &Force("output","lda_ex3_dcache_hit"); @1165
assign ld_da_dcache_miss    = !lda_ex3_dcache_hit;

//------------------select data-----------------------------
//hit region refer to LSU spec
//assign ld_da_dcache_pass_data128_am[127:0]  = {128{ld_da_hit_low_region}}  & ld_da_low_region_data128_am[127:0]
//                                              | {128{ld_da_hit_high_region}}  & ld_da_high_region_data128_am[127:0];
assign ld_da_dcache_pass_data128_am[127:0]  = {128{ld_da_hit_0_region}}  & ld_da_0_region_data128_am[127:0]
                                              | {128{ld_da_hit_1_region}}  & ld_da_1_region_data128_am[127:0]
                                              | {128{ld_da_hit_2_region}}  & ld_da_2_region_data128_am[127:0]
                                              | {128{ld_da_hit_3_region}}  & ld_da_3_region_data128_am[127:0];

assign ld_da_dcache_pass_data128_ahead_am[31:0]   = {32{ld_da_hit_3_region_dup0}}  & ld_da_3_region_data128_ahead_am[31:0]
                                                    | {32{ld_da_hit_2_region_dup0}}  & ld_da_2_region_data128_ahead_am[31:0]
                                                    | {32{ld_da_hit_1_region_dup0}}  & ld_da_1_region_data128_ahead_am[31:0]
                                                    | {32{ld_da_hit_0_region_dup0}}  & ld_da_0_region_data128_ahead_am[31:0];
assign ld_da_dcache_pass_data128_ahead_am[63:32]  = {32{ld_da_hit_3_region_dup1}}  & ld_da_3_region_data128_ahead_am[63:32]
                                                    | {32{ld_da_hit_2_region_dup1}}  & ld_da_2_region_data128_ahead_am[63:32]
                                                    | {32{ld_da_hit_1_region_dup1}}  & ld_da_1_region_data128_ahead_am[63:32]
                                                    | {32{ld_da_hit_0_region_dup1}}  & ld_da_0_region_data128_ahead_am[63:32];
assign ld_da_dcache_pass_data128_ahead_am[95:64]  = {32{ld_da_hit_3_region_dup2}}  & ld_da_3_region_data128_ahead_am[95:64]
                                                    | {32{ld_da_hit_2_region_dup2}}  & ld_da_2_region_data128_ahead_am[95:64]
                                                    | {32{ld_da_hit_1_region_dup2}}  & ld_da_1_region_data128_ahead_am[95:64]
                                                    | {32{ld_da_hit_0_region_dup2}}  & ld_da_0_region_data128_ahead_am[95:64];
assign ld_da_dcache_pass_data128_ahead_am[127:96] = {32{ld_da_hit_3_region_dup3}}  & ld_da_3_region_data128_ahead_am[127:96]
                                                    | {32{ld_da_hit_2_region_dup3}}  & ld_da_2_region_data128_ahead_am[127:96]
                                                    | {32{ld_da_hit_1_region_dup3}}  & ld_da_1_region_data128_ahead_am[127:96]
                                                    | {32{ld_da_hit_0_region_dup3}}  & ld_da_0_region_data128_ahead_am[127:96];


assign ld_da_dcache_data128_ahead_am[127:0] = ld_da_dcache_pass_data128_ahead_am[127:0];
 
// cache buffer bypass
assign ld_da_cb_bypass_data_am[127:0] = 128'b0;
// assign ld_da_cb_bypass_data_am[127:0] = {{{8{ld_da_bytes_vld1[15]}}  & cb_ld_da_data[127:120]}
//                                         ,{{8{ld_da_bytes_vld1[14]}}  & cb_ld_da_data[119:112]}
//                                         ,{{8{ld_da_bytes_vld1[13]}}  & cb_ld_da_data[111:104]}
//                                         ,{{8{ld_da_bytes_vld1[12]}}  & cb_ld_da_data[103:96]}
//                                         ,{{8{ld_da_bytes_vld1[11]}}  & cb_ld_da_data[95:88]}
//                                         ,{{8{ld_da_bytes_vld1[10]}}  & cb_ld_da_data[87:80]}
//                                         ,{{8{ld_da_bytes_vld1[9]}}   & cb_ld_da_data[79:72]}
//                                         ,{{8{ld_da_bytes_vld1[8]}}   & cb_ld_da_data[71:64]}
//                                         ,{{8{ld_da_bytes_vld1[7]}}   & cb_ld_da_data[63:56]}
//                                         ,{{8{ld_da_bytes_vld1[6]}}   & cb_ld_da_data[55:48]}
//                                         ,{{8{ld_da_bytes_vld1[5]}}   & cb_ld_da_data[47:40]}
//                                         ,{{8{ld_da_bytes_vld1[4]}}   & cb_ld_da_data[39:32]}
//                                         ,{{8{ld_da_bytes_vld1[3]}}   & cb_ld_da_data[31:24]}
//                                         ,{{8{ld_da_bytes_vld1[2]}}   & cb_ld_da_data[23:16]}
//                                         ,{{8{ld_da_bytes_vld1[1]}}   & cb_ld_da_data[15:8]}
//                                         ,{{8{ld_da_bytes_vld1[0]}}   & cb_ld_da_data[7:0]}};

assign ld_da_cb_bypass_data_for_merge[127:0]  = lda_merge_from_cb
                                                ? ld_da_cb_bypass_data_am[127:0]
                                                : 128'b0;

assign ld_da_dcache_data_after_merge[127:0]   = ld_da_cb_bypass_data_for_merge[127:0]
                                                | ld_da_dcache_pass_data128_am[127:0];

assign ld_da_data_aft_merge[127:0] = lda_tcm_hit
                                     ? ld_da_tcm_data128_am[127:0]
                                     : ld_da_dcache_data_after_merge[127:0];

assign ld_da_data_unrot[127:120]  = ld_da_fwd_bytes_vld[15]
                                    ? ld_da_fwd_data_am[127:120]
                                    : ld_da_data_aft_merge[127:120];
assign ld_da_data_unrot[119:112]  = ld_da_fwd_bytes_vld[14]
                                    ? ld_da_fwd_data_am[119:112]
                                    : ld_da_data_aft_merge[119:112];
assign ld_da_data_unrot[111:104]  = ld_da_fwd_bytes_vld[13]
                                    ? ld_da_fwd_data_am[111:104]
                                    : ld_da_data_aft_merge[111:104];
assign ld_da_data_unrot[103:96]  = ld_da_fwd_bytes_vld[12]
                                    ? ld_da_fwd_data_am[103:96]
                                    : ld_da_data_aft_merge[103:96];
assign ld_da_data_unrot[95:88]  = ld_da_fwd_bytes_vld[11]
                                    ? ld_da_fwd_data_am[95:88]
                                    : ld_da_data_aft_merge[95:88];
assign ld_da_data_unrot[87:80]  = ld_da_fwd_bytes_vld[10]
                                    ? ld_da_fwd_data_am[87:80]
                                    : ld_da_data_aft_merge[87:80];
assign ld_da_data_unrot[79:72]  = ld_da_fwd_bytes_vld[9]
                                    ? ld_da_fwd_data_am[79:72]
                                    : ld_da_data_aft_merge[79:72];
assign ld_da_data_unrot[71:64]  = ld_da_fwd_bytes_vld[8]
                                    ? ld_da_fwd_data_am[71:64]
                                    : ld_da_data_aft_merge[71:64];
assign ld_da_data_unrot[63:56]  = ld_da_fwd_bytes_vld[7]
                                    ? ld_da_fwd_data_am[63:56]
                                    : ld_da_data_aft_merge[63:56];
assign ld_da_data_unrot[55:48]  = ld_da_fwd_bytes_vld[6]
                                    ? ld_da_fwd_data_am[55:48]
                                    : ld_da_data_aft_merge[55:48];
assign ld_da_data_unrot[47:40]  = ld_da_fwd_bytes_vld[5]
                                    ? ld_da_fwd_data_am[47:40]
                                    : ld_da_data_aft_merge[47:40];
assign ld_da_data_unrot[39:32]  = ld_da_fwd_bytes_vld[4]
                                    ? ld_da_fwd_data_am[39:32]
                                    : ld_da_data_aft_merge[39:32];
assign ld_da_data_unrot[31:24]  = ld_da_fwd_bytes_vld[3]
                                    ? ld_da_fwd_data_am[31:24]
                                    : ld_da_data_aft_merge[31:24];
assign ld_da_data_unrot[23:16]  = ld_da_fwd_bytes_vld[2]
                                    ? ld_da_fwd_data_am[23:16]
                                    : ld_da_data_aft_merge[23:16];
assign ld_da_data_unrot[15:8]  = ld_da_fwd_bytes_vld[1]
                                    ? ld_da_fwd_data_am[15:8]
                                    : ld_da_data_aft_merge[15:8];
assign ld_da_data_unrot[7:0]  = ld_da_fwd_bytes_vld[0]
                                    ? ld_da_fwd_data_am[7:0]
                                    : ld_da_data_aft_merge[7:0];

//rotate data
// &Instance("xx_lsu_rot_data", "x_lsu_ld_da_data_rot"); @1275
xx_lsu_rot_data  x_lsu_ld_da_data_rot (
  .data_in            (ld_da_data_unrot  ),
  .data_settle_out    (ld_da_data_settle ),
  .rot_sel            (lda_ex3_data_rot_sel)
);

// &Connect(.rot_sel         (lda_ex3_data_rot_sel     ), @1276
//          .data_in         (ld_da_data_unrot   ), @1277
//          .data_settle_out (ld_da_data_settle )); @1278

assign ld_da_data128[127:0]   = ld_da_fwd_sq_bypass
                                ? ld_da_fwd_data_bypass[127:0]
                                : ld_da_data_settle[127:0];
    
assign lda_lwb_ex3_data[127:0] = lda_ex3_inst_us?lda_lwb_ex3_data0[127:0]:ld_da_data128[127:0]; // wjh@uw512

//------------------select data from cache or sq/wmb--------
assign ld_da_data_vld               = lda_ex3_inst_vld
                                      &&  !ld_da_expt_vld
                                      &&  (ld_da_fwd_vld ||  lda_ex3_dcache_hit || lda_tcm_hit);
assign lda_rb_ex3_data_vld = ld_da_data_vld 
                           || lda_ex3_inst_vld 
                              && (ld_da_vector_nop || ld_da_expt_ori);
// &Force("output","lda_rb_ex3_data_vld"); @1300

//------------------select data for ahead-------------------
assign ld_da_ahead_preg_data_unsettle[127:120] = ld_da_fwd_bytes_vld_dup[15]
                                            ? ld_da_fwd_data_pe_am[127:120]
                                            : ld_da_dcache_data128_ahead_am[127:120];
assign ld_da_ahead_preg_data_unsettle[119:112] = ld_da_fwd_bytes_vld_dup[14]
                                            ? ld_da_fwd_data_pe_am[119:112]
                                            : ld_da_dcache_data128_ahead_am[119:112];
assign ld_da_ahead_preg_data_unsettle[111:104] = ld_da_fwd_bytes_vld_dup[13]
                                            ? ld_da_fwd_data_pe_am[111:104]
                                            : ld_da_dcache_data128_ahead_am[111:104];
assign ld_da_ahead_preg_data_unsettle[103:96] = ld_da_fwd_bytes_vld_dup[12]
                                            ? ld_da_fwd_data_pe_am[103:96]
                                            : ld_da_dcache_data128_ahead_am[103:96];
assign ld_da_ahead_preg_data_unsettle[95:88] = ld_da_fwd_bytes_vld_dup[11]
                                            ? ld_da_fwd_data_pe_am[95:88]
                                            : ld_da_dcache_data128_ahead_am[95:88];
assign ld_da_ahead_preg_data_unsettle[87:80] = ld_da_fwd_bytes_vld_dup[10]
                                            ? ld_da_fwd_data_pe_am[87:80]
                                            : ld_da_dcache_data128_ahead_am[87:80];
assign ld_da_ahead_preg_data_unsettle[79:72] = ld_da_fwd_bytes_vld_dup[9]
                                            ? ld_da_fwd_data_pe_am[79:72]
                                            : ld_da_dcache_data128_ahead_am[79:72];
assign ld_da_ahead_preg_data_unsettle[71:64] = ld_da_fwd_bytes_vld_dup[8]
                                            ? ld_da_fwd_data_pe_am[71:64]
                                            : ld_da_dcache_data128_ahead_am[71:64];
assign ld_da_ahead_preg_data_unsettle[63:56] = ld_da_fwd_bytes_vld_dup[7]
                                            ? ld_da_fwd_data_pe_am[63:56]
                                            : ld_da_dcache_data128_ahead_am[63:56];
assign ld_da_ahead_preg_data_unsettle[55:48] = ld_da_fwd_bytes_vld_dup[6]
                                            ? ld_da_fwd_data_pe_am[55:48]
                                            : ld_da_dcache_data128_ahead_am[55:48];
assign ld_da_ahead_preg_data_unsettle[47:40] = ld_da_fwd_bytes_vld_dup[5]
                                            ? ld_da_fwd_data_pe_am[47:40]
                                            : ld_da_dcache_data128_ahead_am[47:40];
assign ld_da_ahead_preg_data_unsettle[39:32] = ld_da_fwd_bytes_vld_dup[4]
                                            ? ld_da_fwd_data_pe_am[39:32]
                                            : ld_da_dcache_data128_ahead_am[39:32];
assign ld_da_ahead_preg_data_unsettle[31:24] = ld_da_fwd_bytes_vld_dup[3]
                                            ? ld_da_fwd_data_pe_am[31:24]
                                            : ld_da_dcache_data128_ahead_am[31:24];
assign ld_da_ahead_preg_data_unsettle[23:16] = ld_da_fwd_bytes_vld_dup[2]
                                            ? ld_da_fwd_data_pe_am[23:16]
                                            : ld_da_dcache_data128_ahead_am[23:16];
assign ld_da_ahead_preg_data_unsettle[15:8] = ld_da_fwd_bytes_vld_dup[1]
                                            ? ld_da_fwd_data_pe_am[15:8]
                                            : ld_da_dcache_data128_ahead_am[15:8];
assign ld_da_ahead_preg_data_unsettle[7:0] = ld_da_fwd_bytes_vld_dup[0]
                                            ? ld_da_fwd_data_pe_am[7:0]
                                            : ld_da_dcache_data128_ahead_am[7:0];

//rotate preg data
// &Instance("xx_lsu_rot_data", "x_lsu_ld_da_ahead_preg_data_rot"); @1353
xx_lsu_rot_data  x_lsu_ld_da_ahead_preg_data_rot (
  .data_in                        (ld_da_ahead_preg_data_unsettle),
  .data_settle_out                (ld_da_ahead_preg_data_settle  ),
  .rot_sel                        (lda_ex3_data_rot_sel            )
);

// &Connect(.rot_sel         (lda_ex3_data_rot_sel     ), @1354
//          .data_in         (ld_da_ahead_preg_data_unsettle), @1355
//          .data_settle_out (ld_da_ahead_preg_data_settle )); @1356

//assign ld_da_ahead_vreg_data_unsettle[127:0]  = ld_da_dcache_pass_data128_am[127:0];
//assign ld_da_ahead_vreg_data_unsettle[127:0]  = ld_da_ahead_preg_data_unsettle[127:0];
//rotate vreg data
//&Instance("xx_lsu_rot_data", "x_lsu_ld_da_ahead_vreg_data_rot");
// //&Connect(.rot_sel         (lda_ex3_data_rot_sel     ), @1362
// //         .data_in         (ld_da_ahead_vreg_data_unsettle), @1363
// //         .data_settle_out (ld_da_ahead_vreg_data_settle )); @1364

//----------------------------------------------------------
//                     for read buffer
//----------------------------------------------------------
//------------------for read buffer merge--------
//boundary inst do not fwd from sd_ex1

//flop data for timing
assign ld_da_data_ff_clk_en = ld_da_data_delay_gate;
// &Instance("gated_clk_cell", "x_lsu_ld_da_data_ff_gated_clk"); @1374
gated_clk_cell  x_lsu_ld_da_data_ff_gated_clk (
  .clk_in               (lsu_special_clk     ),
  .clk_out              (ld_da_data_ff_clk   ),
  .external_en          (1'b0                ),
  .local_en             (ld_da_data_ff_clk_en),
  .module_en            (cp0_lsu_icg_en      ),
  .pad_yy_icg_scan_en   (pad_yy_icg_scan_en  )
);

// &Connect(.clk_in        (lsu_special_clk     ), @1375
//          .external_en   (1'b0               ), @1376
//          .module_en     (cp0_lsu_icg_en     ), @1377
//          .local_en      (ld_da_data_ff_clk_en), @1378
//          .clk_out       (ld_da_data_ff_clk)); @1379

always @(posedge ld_da_data_ff_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    lda_ex3_boundary_after_mask_ff  <=  1'b0;
    ld_da_data_ff[127:0]          <=  128'b0;
    ld_da_data_ff1[127:0]         <=  128'b0;
    ld_da_data_ff2[127:0]         <=  128'b0;
    ld_da_data_ff3[127:0]         <=  128'b0;
    
  end
  else if(ld_da_data_delay_vld)
  begin
    lda_ex3_boundary_after_mask_ff  <=  lda_ex3_boundary_after_mask;
    ld_da_data_ff[127:0]          <=  ld_da_data_for_save[127:0];
    ld_da_data_ff1[127:0]         <=  ld_da_data_for_save1[127:0];
    ld_da_data_ff2[127:0]         <=  ld_da_data_for_save2[127:0];
    ld_da_data_ff3[127:0]         <=  ld_da_data_for_save3[127:0];
  end
end

assign ld_da_data_delay_vld  = lda_ex3_inst_vld
                                  && (ld_da_rb_create_vld_unmask || ld_da_rb_merge_vld_unmask)
                                  && lda_rb_ex3_data_vld
                               || lda_ex3_borrow_vld
                                  && lda_borrow_mmu
                                  && lda_ex3_dcache_hit; 
assign ld_da_data_delay_gate = lda_ex3_inst_vld
                                  && lda_rb_ex3_data_vld
                               || lda_ex3_borrow_vld
                                  && lda_borrow_mmu;

assign ld_da_mcic_data[63:0]      = lda_addr0[3]
                                    ? ld_da_dcache_pass_data128_am[127:64]
                                    : ld_da_dcache_pass_data128_am[63:0];
assign ld_da_data_for_save[127:0] = lda_ex3_borrow_vld
                                    ? {2{ld_da_mcic_data[63:0]}}
                                    : lda_ex3_inst_us
                                      ? lda_lwb_ex3_data0
                                      : ld_da_data_unrot[127:0];
assign ld_da_data_for_save1 = lda_lwb_ex3_data1;
assign ld_da_data_for_save2 = lda_lwb_ex3_data2;
assign ld_da_data_for_save3 = lda_lwb_ex3_data3;
//-------------- rb data ---------------                                  
assign ld_da_boundary_data[127:0] = lda_ecc_stall_already & lda_ex3_inst_us
                                    ? lda_lwb_ex3_data0
                                    : lda_ecc_stall_already
                                      ? ld_da_data_unrot[127:0]
                                      : ld_da_data_ff[127:0];

assign lda_rb_ex3_data_ori[127:0]        = ld_da_boundary_data[127:0];
assign lda_rb_ex3_data_ori1              = lda_ecc_stall_already? lda_lwb_ex3_data1: ld_da_data_ff1;
assign lda_rb_ex3_data_ori2              = lda_ecc_stall_already? lda_lwb_ex3_data2: ld_da_data_ff2;
assign lda_rb_ex3_data_ori3              = lda_ecc_stall_already? lda_lwb_ex3_data2: ld_da_data_ff3;

//==========================================================
//            Data settle and Sign extend
//==========================================================
//sign extend
assign ld_da_ahead_preg_data_sign0[63:0]      = ld_da_ahead_preg_data_settle[63:0];
assign ld_da_ahead_preg_data_sign1[63:0]      = {{56{ld_da_ahead_preg_data_settle[7]}},ld_da_ahead_preg_data_settle[7:0]};
assign ld_da_ahead_preg_data_sign2[63:0]      = {{48{ld_da_ahead_preg_data_settle[15]}},ld_da_ahead_preg_data_settle[15:0]};
assign ld_da_ahead_preg_data_sign3[63:0]      = {{32{ld_da_ahead_preg_data_settle[31]}},ld_da_ahead_preg_data_settle[31:0]};

// &CombBeg; @1435
always @( ld_da_ahead_preg_data_sign1[63:0]
       or ld_da_ahead_preg_data_sign0[63:0]
       or lda_lwb_ex3_preg_sign_sel[3:0]
       or ld_da_ahead_preg_data_sign3[63:0]
       or ld_da_ahead_preg_data_sign2[63:0])
begin
case(lda_lwb_ex3_preg_sign_sel[3:0])
  4'b1000:ld_da_preg_data_sign_extend[63:0] = ld_da_ahead_preg_data_sign3[63:0];
  4'b0100:ld_da_preg_data_sign_extend[63:0] = ld_da_ahead_preg_data_sign2[63:0];
  4'b0010:ld_da_preg_data_sign_extend[63:0] = ld_da_ahead_preg_data_sign1[63:0];
  4'b0001:ld_da_preg_data_sign_extend[63:0] = ld_da_ahead_preg_data_sign0[63:0];
  default:ld_da_preg_data_sign_extend[63:0] = {64{1'bx}};
endcase
// &CombEnd; @1443
end

//vector data
//assign ld_da_vreg_data_sign_extend[63:0]  = lda_ex3_vreg_sign_sel && (lda_ex3_inst_size[1:0] == 2'b10)
//                                            ? {{32{1'b1}},ld_da_ahead_vreg_data_settle[31:0]}
//                                            : lda_ex3_vreg_sign_sel && (lda_ex3_inst_size[1:0] == 2'b01)
//                                              ? {{48{1'b1}},ld_da_ahead_vreg_data_settle[15:0]} 
//                                              : ld_da_ahead_vreg_data_settle[63:0];

// &Force("output","lda_ex3_inst_vls"); @1453
// &Force("output","lda_ex3_element_size"); @1454
// &Force("output","lda_ex3_vsew"); @1455
// &CombBeg; @1456
always @( lda_ex3_vmew[1:0]
       or lda_ex3_inst_vls
       or lda_ex3_element_size[1:0]
       or lda_ex3_vreg_sign_sel)
begin
casez({lda_ex3_inst_vls,lda_ex3_vreg_sign_sel,lda_ex3_element_size[1:0],lda_ex3_vmew[1:0]}) // rvv1.0 @hcl
  {1'b1,1'b0,S_BYTE,HALF}:  lda_lwb_ex3_vreg_sign_sel[14:0] = 15'h0002;
  {1'b1,1'b1,S_BYTE,HALF}:  lda_lwb_ex3_vreg_sign_sel[14:0] = 15'h0004;
  {1'b1,1'b0,S_BYTE,WORD}:  lda_lwb_ex3_vreg_sign_sel[14:0] = 15'h0008;
  {1'b1,1'b1,S_BYTE,WORD}:  lda_lwb_ex3_vreg_sign_sel[14:0] = 15'h0010;
  {1'b1,1'b0,S_BYTE,DWORD}: lda_lwb_ex3_vreg_sign_sel[14:0] = 15'h0020;
  {1'b1,1'b1,S_BYTE,DWORD}: lda_lwb_ex3_vreg_sign_sel[14:0] = 15'h0040;
  {1'b1,1'b0,HALF,WORD}:  lda_lwb_ex3_vreg_sign_sel[14:0] = 15'h0080;
  {1'b1,1'b1,HALF,WORD}:  lda_lwb_ex3_vreg_sign_sel[14:0] = 15'h0100;
  {1'b1,1'b0,HALF,DWORD}: lda_lwb_ex3_vreg_sign_sel[14:0] = 15'h0200;
  {1'b1,1'b1,HALF,DWORD}: lda_lwb_ex3_vreg_sign_sel[14:0] = 15'h0400;
  {1'b1,1'b0,WORD,DWORD}: lda_lwb_ex3_vreg_sign_sel[14:0] = 15'h0800;
  {1'b1,1'b1,WORD,DWORD}: lda_lwb_ex3_vreg_sign_sel[14:0] = 15'h1000;
  {1'b0,1'b1,HALF,2'b??}: lda_lwb_ex3_vreg_sign_sel[14:0] = 15'h2000;
  {1'b0,1'b1,WORD,2'b??}: lda_lwb_ex3_vreg_sign_sel[14:0] = 15'h4000;
  default:lda_lwb_ex3_vreg_sign_sel[14:0] = 15'h0001;         
endcase
// &CombEnd; @1474
end
assign lda_lwb_ex3_inst_vls      = lda_ex3_inst_vls;    

//==========================================================
//        Request read buffer & Compare index & discard
//==========================================================
//------------------origin create read buffer---------------
//-----------create---------------------
//ld            : cache miss, boundary first
//lr            : cache miss
//ld amo        : any
//borrow mmu    : cache miss

//judge vld pass to read buffer to get rb_full signal
// &Force("output","lda_rb_ex3_create_judge_vld"); @1492
assign lda_rb_ex3_create_judge_vld        = lda_ex3_inst_vld
                                              &&  !ld_da_expt_vld_cancel // Risc-V Debug zdb
                                              &&  !ld_da_discard_dc_req
                                              &&  (ld_da_ld_inst &&  !ld_da_secd
                                                  ||  ld_da_atomic)
                                          ||  lda_borrow_mmu  &&  lda_ex3_borrow_vld;

assign ld_da_rb_create_vld_unmask       = lda_ex3_inst_vld
                                              &&  !rtu_lsu_flush_fe
                                              &&  !(rtu_ck_flush && rtu_ck_flush_iid_older_than_ex3_iid)  //flush ex3 rb_create_vld when ecc stall, ck_flush@LTL
                                              &&  !ld_da_expt_vld_cancel // Risc-V Debug zdb
                                              &&  !ld_da_wait_fence_req
                                              &&  !ld_da_discard_dc_req
                                              &&  !ld_da_sq_fwd_ecc_discard
                                              &&  !lda_ecc_stall_data
                                              &&  (ld_da_ld_inst  
                                                      &&  !ld_da_secd 
                                                      &&  (!lda_rb_ex3_data_vld
                                                          ||  lda_ex3_boundary_after_mask
                                                          ||  ld_da_rb_data_check) // Risc-V Debug zdb
                                                  ||  ld_da_ldamo_inst
                                                      &&  !lda_tcm_hit
                                                      &&  !ld_da_vector_nop
                                                  ||  ld_da_lr_inst
                                                      &&  (!ld_da_data_vld
                                                      ||  ld_da_rb_data_check)) // Risc-V Debug zdb
                                          ||  lda_borrow_mmu
                                              &&  ld_da_dcache_miss
                                              &&  lda_ex3_borrow_vld;

//------------------index hit/discard grnt signal-----------
//addr is used to compare index, so addr0 is enough
assign lda_ex3_addr[`WK_PA_WIDTH-1:0]           = lda_addr0[`WK_PA_WIDTH-1:0];

assign ld_da_depd_rb = !lda_ex3_page_so
                       && !lda_tcm_hit
                       && rb_lda_ex3_hit_idx;

//because rb and lfb use a common wait queue, they can be granted simultaneously
assign ld_da_discard_from_rb_req  = ld_da_rb_create_vld_unmask
                                        &&  ld_da_depd_rb
                                    ||  ld_da_rb_merge_vld_unmask
                                        &&  (rb_lda_ex3_merge_fail
                                            ||  ld_da_depd_rb
                                                &&  !lda_rb_ex3_data_vld)
                                    ||  lda_tag_ecc_stall_ori
                                        &&  rb_lda_ex3_hit_idx;

assign ld_da_discard_from_lfb_req = (ld_da_rb_create_vld_unmask
                                        ||  ld_da_rb_merge_vld_unmask
                                            && !lda_rb_ex3_data_vld)
                                       &&  lda_ex3_page_ca
                                       &&  lfb_lda_hit_idx
                                    || lda_tag_ecc_stall_ori
                                       &&  lfb_lda_hit_idx;

assign ld_da_discard_from_lm_req  = (ld_da_rb_create_vld_unmask
                                        ||  ld_da_rb_merge_vld_unmask
                                            && !lda_rb_ex3_data_vld)
                                       &&  lda_ex3_page_ca
                                       &&  lm_lda_ex3_hit_idx
                                    || lda_tag_ecc_stall_ori
                                       &&  lm_lda_ex3_hit_idx;

assign ld_da_hit_idx_discard_req  = ld_da_discard_from_rb_req
                                    ||  ld_da_discard_from_lfb_req
                                    ||  ld_da_discard_from_lm_req;

//because ld_da_hit_idx_discard_vld = ld_da_hit_idx_discard_req, then grnt
//signal needn't see ld_da_hit_idx_discard_vld
assign lda_rb_ex3_discard_grnt      = ld_da_discard_from_rb_req;
assign lda_lfb_ex3_discard_grnt     = ld_da_discard_from_lfb_req;
assign lda_lm_ex3_discard_grnt      = ld_da_discard_from_lm_req;

//record lfb wakeup queue if hit index and create rb
// &Force("output","lda_lfb_set_wakeup_queue"); @1565
assign lda_lfb_set_wakeup_queue      = ld_da_hit_idx_discard_vld;
assign lda_lfb_wakeup_queue_gate = ld_da_hit_idx_discard_req;

assign lda_lfb_ex3_wakeup_queue_next[LSIQENTRY:0]  = {lda_mcic_ex3_borrow_mmu,
                                                    ld_da_mask_lsid[LSIQENTRY-1:0]};

//------------------create read buffer info-----------------
// &Force("output","lda_rb_ex3_create_vld"); @1573
assign lda_rb_ex3_create_vld          = ld_da_rb_create_vld_unmask
                                      &&  !lda_rb_ex3_ecc_mask 
                                      &&  !ld_da_hit_idx_discard_req;
// &Force("output","lda_rb_ex3_create_dp_vld"); @1577
assign lda_rb_ex3_create_dp_vld       = ld_da_rb_create_vld_unmask;
// &Force("output","lda_rb_ex3_create_gateclk_en"); @1579
assign lda_rb_ex3_create_gateclk_en   = ld_da_rb_create_vld_unmask;

assign lda_ex3_special_gateclk_en     = lda_ex3_inst_vld 
                                      || lda_ex3_borrow_vld 
                                         && lda_borrow_mmu;
//-----------merge signal---------------
//merge signal is used for secd ld instruction
assign ld_da_rb_merge_vld_unmask    = lda_ex3_inst_vld
                                      &&  !rtu_lsu_flush_fe
                                      &&  !(rtu_ck_flush && rtu_ck_flush_iid_older_than_ex3_iid)  //flush ex3 rb_merge_vld when ecc stall, ck_flush@LTL
                                      &&  !ld_da_wait_fence_req
                                      &&  !ld_da_expt_vld_cancel // Risc-V Debug zdb
                                      &&  !ld_da_discard_dc_req
                                      &&  !ld_da_sq_fwd_ecc_discard
                                      &&  !lda_ecc_stall_data
                                      &&  ld_da_ld_inst
                                      &&  ld_da_secd
                                      &&  ld_da_boundary;
assign lda_rb_ex3_merge_vld           = ld_da_rb_merge_vld_unmask
                                      &&  !lda_rb_ex3_ecc_mask 
                                      &&  !ld_da_hit_idx_discard_req;

assign lda_rb_ex3_merge_dp_vld        = ld_da_rb_merge_vld_unmask;
                                      
//for data merge
//assign ld_da_rb_merge_ecc_stall     = ld_da_ecc_data_req_mask;

//merge expt is for secd ld inst has exception
assign lda_rb_ex3_merge_expt_vld      = lda_ex3_inst_vld
                                      &&  ld_da_expt_vld_cancel // Risc-V Debug zdb
                                      &&  !ld_da_restart_vld
                                      &&  ld_da_ld_inst
                                      &&  ld_da_secd
                                      &&  ld_da_boundary;

assign lda_rb_ex3_merge_gateclk_en    = ld_da_rb_merge_vld_unmask;

//-----------rb create signal-----------
//this inst will request lfb addr entry in rb
assign lda_rb_ex3_create_lfb          = lda_ex3_page_ca
                                      || !lda_ex3_page_so && !ld_da_atomic;

assign lda_rb_ex3_atomic              = lda_ex3_inst_vld  &&  ld_da_atomic;
assign lda_rb_ex3_ldamo               = lda_ex3_inst_vld  &&  ld_da_ldamo_inst;
assign lda_rb_ex3_cmplt_success       = lda_ex3_borrow_vld
                                      ||  lda_ex3_inst_vld
                                          &&  !ld_da_boundary_first
                                          &&  ld_da_inst_cmplt;
assign lda_rb_ex3_dest_vld            = lda_ex3_inst_vld;

//==========================================================
//        Compare index
//==========================================================
//it's for the corner condition of read buffer creating port
//if both ld_da & st_da create rb and their index are the same
//------------------compare st_da stage---------------------
assign lda_cmp_lsda0_addr[`WK_PA_WIDTH-1:0] = lsda0_ex3_addr[`WK_PA_WIDTH-1:0];
assign lda_cmp_lsda1_addr[`WK_PA_WIDTH-1:0] = lsda1_ex3_addr[`WK_PA_WIDTH-1:0];
assign lda_lsda0_ex3_hit_idx      = (ld_da_rb_create_vld_unmask
                                      ||  ld_da_rb_merge_vld_unmask)
                                  &&  (lda_ex3_idx[7:0] ==  lda_cmp_lsda0_addr[13:6]);
assign lda_lsda1_ex3_hit_idx      = (ld_da_rb_create_vld_unmask
                                      ||  ld_da_rb_merge_vld_unmask)
                                  &&  (lda_ex3_idx[7:0] ==  lda_cmp_lsda1_addr[13:6]);       //@wangyu                           
//------------------compare pfu-----------------------------
//if timing is not enough, change ld_da_rb_create_vld_unmask to judge
assign ld_da_cmp_pfu_biu_req_addr[`WK_PA_WIDTH-1:0] = pfu_biu_req_addr[`WK_PA_WIDTH-1:0];
assign lda_pfu_ex3_biu_req_hit_idx  = (ld_da_rb_create_vld_unmask
                                        ||  ld_da_rb_merge_vld_unmask)
                                    &&  (lda_ex3_idx[7:0]
                                        ==  ld_da_cmp_pfu_biu_req_addr[13:6]);
//==========================================================
//        Generage commit signal
//==========================================================
assign ld_da_cmit_hit0  = {rtu_yy_xx_commit0,rtu_yy_xx_commit0_iid[IID_WIDTH-1:0]}
                          ==  {1'b1,lda_ex3_iid[IID_WIDTH-1:0]};
assign ld_da_cmit_hit1  = {rtu_yy_xx_commit1,rtu_yy_xx_commit1_iid[IID_WIDTH-1:0]}
                          ==  {1'b1,lda_ex3_iid[IID_WIDTH-1:0]};
assign ld_da_cmit_hit2  = {rtu_yy_xx_commit2,rtu_yy_xx_commit2_iid[IID_WIDTH-1:0]}
                          ==  {1'b1,lda_ex3_iid[IID_WIDTH-1:0]};
assign ld_da_cmit_hit3  = {rtu_yy_xx_commit3,rtu_yy_xx_commit3_iid[IID_WIDTH-1:0]}
                          ==  {1'b1,lda_ex3_iid[IID_WIDTH-1:0]};
assign ld_da_cmit_hit4  = {rtu_yy_xx_commit4,rtu_yy_xx_commit4_iid[IID_WIDTH-1:0]}
                          ==  {1'b1,lda_ex3_iid[IID_WIDTH-1:0]};
assign ld_da_cmit_hit5  = {rtu_yy_xx_commit5,rtu_yy_xx_commit5_iid[IID_WIDTH-1:0]}
                          ==  {1'b1,lda_ex3_iid[IID_WIDTH-1:0]};
//assign ld_da_cmit_hit6  = {rtu_yy_xx_commit6,rtu_yy_xx_commit6_iid[IID_WIDTH-1:0]}
//                          ==  {1'b1,lda_ex3_iid[IID_WIDTH-1:0]};
//assign ld_da_cmit_hit7  = {rtu_yy_xx_commit7,rtu_yy_xx_commit7_iid[IID_WIDTH-1:0]}      //@wangyu
//                          ==  {1'b1,lda_ex3_iid[IID_WIDTH-1:0]};

assign lda_rb_ex3_cmit    = ld_da_cmit_hit0
                            ||  ld_da_cmit_hit1
                            ||  ld_da_cmit_hit2
                            ||  ld_da_cmit_hit3
                            ||  ld_da_cmit_hit4
                            ||  ld_da_cmit_hit5;
                           // ||  ld_da_cmit_hit6
                           // ||  ld_da_cmit_hit7;                         
//==========================================================
//        Restart signal
//==========================================================
// assign ld_da_fwd_sq_bypass_vld      = ld_da_fwd_sq_bypass
//                                       &&  sd_ex1_inst_vld;
assign ld_da_fwd_sq_bypass_vld      = ld_da_fwd_sq_bypass
                                      && ((std0_ex1_inst_vld && !lda_fwd_bypass_sel)|| (std1_ex1_inst_vld && lda_fwd_bypass_sel)) ;    //@wangyu

assign ld_da_data_discard_sq_final  = ld_da_data_discard_sq
                                      ||  ld_da_fwd_sq_bypass
                                          && (!std0_ex1_inst_vld || (std0_ex1_inst_vld && lda_fwd_bypass_sel))
                                          && (!std1_ex1_inst_vld || (std1_ex1_inst_vld && !lda_fwd_bypass_sel)); //@wangyu
assign ld_da_fwd_sq_multi_final     = ld_da_fwd_sq_multi
                                          &&  !ld_da_fwd_sq_multi_mask
                                      ||  ld_da_fwd_bypass_sq_multi;
assign ld_da_discard_wmb_final      = !lda_ex3_page_ca
                                          &&  !lda_tcm_hit
                                          &&  ld_da_fwd_wmb_vld
                                      ||  ld_da_discard_wmb;
//-------------------dc reastart req------------------------
assign ld_da_discard_dc_req       = ld_da_other_discard_sq
                                    ||  ld_da_data_discard_sq_final
                                    ||  ld_da_fwd_sq_multi_final
                                    ||  ld_da_discard_wmb_final;
//------------------arbitrate-------------------------------
//1. other discard sq
//2. fwd sq data not vld
//3. fwd sq multi
//4. discard wmb
//5. wait_fence
//6. discard rb/lfb
//7. rb_full
assign ld_da_other_discard_sq_req = lda_ex3_inst_vld
                                    &&  ld_da_other_discard_sq;
assign ld_da_data_discard_sq_req  = lda_ex3_inst_vld
                                    &&  ld_da_data_discard_sq_final;
assign ld_da_fwd_sq_multi_req     = lda_ex3_inst_vld
                                    &&  ld_da_fwd_sq_multi_final;
assign ld_da_discard_wmb_req      = lda_ex3_inst_vld
                                    &&  ld_da_discard_wmb_final;
assign ld_da_wait_fence_req       = lda_ex3_inst_vld
//                                    &&  ld_da_ld_inst
                                    &&  ld_da_data_vld
                                    &&  ld_da_wait_fence;
assign ld_da_rb_full_req          = lda_rb_ex3_create_vld
                                    &&  rb_lda_ex3_full;

assign ld_da_other_discard_sq_vld = ld_da_other_discard_sq_req;
assign lda_sq_ex3_data_discard_vld  = !ld_da_other_discard_sq_req
                                    &&  ld_da_data_discard_sq_req;
// &Force("output","lda_sq_ex3_fwd_multi_vld"); @1706
assign lda_sq_ex3_fwd_multi_vld     = !ld_da_other_discard_sq_req
                                    &&  !ld_da_data_discard_sq_req
                                    &&  ld_da_fwd_sq_multi_req;
assign lda_wmb_ex3_discard_vld      = !ld_da_other_discard_sq_req
                                    &&  !ld_da_fwd_sq_multi_req
                                    &&  !ld_da_data_discard_sq_req
                                    &&  ld_da_discard_wmb_req;
assign ld_da_wait_fence_vld         = !ld_da_other_discard_sq_req
                                    &&  !ld_da_fwd_sq_multi_req
                                    &&  !ld_da_data_discard_sq_req
                                    &&  !ld_da_discard_wmb_req
                                    &&  ld_da_wait_fence_req;
assign lda_ex3_wait_fence_gateclk_en  = ld_da_wait_fence_req;
//this logic may be redundant, ld_da_hit_idx_discard_req
//needn't judge other condition, because this signal has already see other
//signals
assign ld_da_hit_idx_discard_vld  = ld_da_hit_idx_discard_req
                                    && !lda_ecc_stall;
assign ld_da_rb_full_vld          = !ld_da_other_discard_sq_req
                                    &&  !ld_da_fwd_sq_multi_req
                                    &&  !ld_da_data_discard_sq_req
                                    &&  !ld_da_discard_wmb_req
                                    &&  !ld_da_wait_fence_req
                                    &&  !ld_da_hit_idx_discard_req
                                    &&  ld_da_rb_full_req;
assign ld_da_us_discard_req       = lda_ex3_us_discard
                                    &&  !ld_da_other_discard_sq_req
                                    &&  !ld_da_fwd_sq_multi_req
                                    &&  !ld_da_data_discard_sq_req
                                    &&  !ld_da_discard_wmb_req
                                    &&  !ld_da_wait_fence_req
                                    &&  !ld_da_hit_idx_discard_req
                                    &&  !ld_da_rb_full_req;
assign lda_rb_ex3_full_gateclk_en   = lda_rb_ex3_create_gateclk_en
                                    &&  rb_lda_ex3_full;

assign ld_da_restart_vld          = ld_da_other_discard_sq_req
                                    ||  ld_da_fwd_sq_multi_req
                                    ||  ld_da_data_discard_sq_req
                                    ||  ld_da_discard_wmb_req
                                    ||  ld_da_hit_idx_discard_req
                                    ||  ld_da_rb_full_req
                                    ||  lda_ex3_us_discard
                                    ||  ld_da_wait_fence_req;

//interface to sq
assign lda_sq_ex3_global_discard_vld= ld_da_other_discard_sq_vld
                                    ||  lda_sq_ex3_fwd_multi_vld;

//partial restart with fast timing
assign ld_da_restart_no_cache = ld_da_other_discard_sq
                                || ld_da_data_discard_sq_final
                                || ld_da_fwd_sq_multi_final
                                || ld_da_discard_wmb_final 
                                || lda_ex3_us_discard
                                || ld_da_wait_fence_req; 
//==========================================================
//                     TCM data select
//==========================================================
//----------------------------------------------------------
//                           dtcm
//----------------------------------------------------------
assign dtcm_1bit_err               = 1'b0;
assign dtcm_rdata[127:0]           = {128{1'b0}};
//----------------------------------------------------------
//                           itcm
//----------------------------------------------------------
assign itcm_1bit_err               = 1'b0;
assign itcm_rdata[127:0]           = {128{1'b0}};
//----------------------------------------------------------
//                           tcm data
//----------------------------------------------------------
assign tcm_rdata[127:0] = lda_dtcm_hit
                          ? dtcm_rdata[127:0]
                          : itcm_rdata[127:0];

assign ld_da_bytes_vld_ext[127:0]  = {{8{lda_ex3_bytes_vld[15]}}  
                                     ,{8{lda_ex3_bytes_vld[14]}}  
                                     ,{8{lda_ex3_bytes_vld[13]}}  
                                     ,{8{lda_ex3_bytes_vld[12]}}  
                                     ,{8{lda_ex3_bytes_vld[11]}}  
                                     ,{8{lda_ex3_bytes_vld[10]}}  
                                     ,{8{lda_ex3_bytes_vld[9]}}   
                                     ,{8{lda_ex3_bytes_vld[8]}}   
                                     ,{8{lda_ex3_bytes_vld[7]}}   
                                     ,{8{lda_ex3_bytes_vld[6]}}   
                                     ,{8{lda_ex3_bytes_vld[5]}}   
                                     ,{8{lda_ex3_bytes_vld[4]}}   
                                     ,{8{lda_ex3_bytes_vld[3]}}   
                                     ,{8{lda_ex3_bytes_vld[2]}}   
                                     ,{8{lda_ex3_bytes_vld[1]}}   
                                     ,{8{lda_ex3_bytes_vld[0]}}}; 

assign ld_da_tcm_data128_am[127:0] = ld_da_bytes_vld_ext[127:0] & tcm_rdata[127:0];

assign tcm_1bit_err = itcm_1bit_err | dtcm_1bit_err;
// &Force("nonport","itcm_1bit_err"); @1821
// &Force("nonport","dtcm_1bit_err"); @1822
//----------------------------------------------------------
//                       ECC control
//----------------------------------------------------------
assign ld_da_tcm_ecc_stall_ori = lda_ex3_inst_vld
                                 && lda_tcm_hit
                                 && !ld_da_vector_nop
                                 && !ld_da_expt_vld_cancel // Risv-V Debug zdb
                                 && !ld_da_restart_no_cache
                                 && !ld_da_fwd_no_cache
                                 && !rtu_lsu_flush_fe
                                 && !(rtu_ck_flush && rtu_ck_flush_iid_older_than_ex3_iid)  //flush younger ecc_stall, ck_flush@LTL
                                 && !lda_ecc_stall_already
                                 && tcm_1bit_err;

assign ld_da_tcm_rb_restart = ld_da_rb_create_vld_unmask 
                                 && rb_lda_ex3_full
                              || ld_da_rb_merge_vld_unmask
                                 && rb_lda_ex3_merge_fail;
assign ld_da_tcm_ecc_stall  = ld_da_tcm_ecc_stall_ori && !ld_da_tcm_rb_restart;

assign ld_da_tcm_ecc_stall_gate = lda_ex3_inst_vld
                                  && lda_tcm_hit
                                  && !ld_da_vector_nop
                                  && !ld_da_expt_vld_cancel // Risc-V Debug zdb
                                  && !ld_da_restart_no_cache
                                  && !ld_da_fwd_no_cache
                                  && !lda_ecc_stall_already;
//==========================================================
//                    Settle data
//==========================================================
//------------------settle data to register mode------------
//rot_set signal is set in da stage and plays a role in wb stage

//==========================================================
//                    ECC handling
//==========================================================
// assign ldc_tag_inj_vld  = cp0_lsu_tag_ecc_inj 
//                             && ldc_lda_ex2_tag_inj_dp 
//                             && !st_da_ld_tag_inj_mask 
//                             && !lsu_ld_tag_inj_cmplt;
assign ldc_tag_inj_vld  = cp0_lsu_tag_ecc_inj 
                            && ldc_lda_ex2_tag_inj_dp 
                            && !lsda0_ex3_tag_inj_mask 
                            && !lsda1_ex3_tag_inj_mask     //@wangyu mask both ls0 and ls1 :0 
                            && !lsu_ld_tag_inj_cmplt;                           
assign ldc_data_inj_vld = cp0_lsu_data_ecc_inj 
                            && ldc_lda_ex2_data_inj_dp 
                            && !lsu_ld_data_inj_cmplt; 
//for tag ecc_inj
assign dcache_ld_tag_dout[`WK_LS_DCACHE_LDTAG_WIDTH-1:0] = ldc_tag_inj_vld
                                  ? dcache_lsu_ld_tag_dout[`WK_LS_DCACHE_LDTAG_WIDTH-1:0] ^ {4{cp0_lsu_tag_random0[`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0]}}//xor
                                  : dcache_lsu_ld_tag_dout[`WK_LS_DCACHE_LDTAG_WIDTH-1:0];


//for timing

assign dcache_data_bank0[38:0] = ldc_data_inj_vld
                                 ? dcache_lsu_ld_data_bank0_dout[38:0] ^ cp0_lsu_data_random[38:0]
                                 : dcache_lsu_ld_data_bank0_dout[38:0];

assign dcache_data_bank1[38:0] = ldc_data_inj_vld
                                 ? dcache_lsu_ld_data_bank1_dout[38:0] ^ cp0_lsu_data_random[38:0]
                                 : dcache_lsu_ld_data_bank1_dout[38:0];

assign dcache_data_bank2[38:0] = ldc_data_inj_vld
                                 ? dcache_lsu_ld_data_bank2_dout[38:0] ^ cp0_lsu_data_random[38:0]
                                 : dcache_lsu_ld_data_bank2_dout[38:0];

assign dcache_data_bank3[38:0] = ldc_data_inj_vld
                                 ? dcache_lsu_ld_data_bank3_dout[38:0] ^ cp0_lsu_data_random[38:0]
                                 : dcache_lsu_ld_data_bank3_dout[38:0]; 

assign dcache_data_bank4[38:0] = ldc_data_inj_vld
                                 ? dcache_lsu_ld_data_bank4_dout[38:0] ^ cp0_lsu_data_random[38:0]
                                 : dcache_lsu_ld_data_bank4_dout[38:0];

assign dcache_data_bank5[38:0] = ldc_data_inj_vld
                                 ? dcache_lsu_ld_data_bank5_dout[38:0] ^ cp0_lsu_data_random[38:0]
                                 : dcache_lsu_ld_data_bank5_dout[38:0];

assign dcache_data_bank6[38:0] = ldc_data_inj_vld
                                 ? dcache_lsu_ld_data_bank6_dout[38:0] ^ cp0_lsu_data_random[38:0]
                                 : dcache_lsu_ld_data_bank6_dout[38:0];

assign dcache_data_bank7[38:0] = ldc_data_inj_vld
                                 ? dcache_lsu_ld_data_bank7_dout[38:0] ^ cp0_lsu_data_random[38:0]
                                 : dcache_lsu_ld_data_bank7_dout[38:0];   

assign dcache_data_bank8[38:0] = ldc_data_inj_vld
                                 ? dcache_lsu_ld_data_bank8_dout[38:0] ^ cp0_lsu_data_random[38:0]
                                 : dcache_lsu_ld_data_bank8_dout[38:0];

assign dcache_data_bank9[38:0] = ldc_data_inj_vld
                                 ? dcache_lsu_ld_data_bank9_dout[38:0] ^ cp0_lsu_data_random[38:0]
                                 : dcache_lsu_ld_data_bank9_dout[38:0];

assign dcache_data_bank10[38:0] = ldc_data_inj_vld
                                 ? dcache_lsu_ld_data_bank10_dout[38:0] ^ cp0_lsu_data_random[38:0]
                                 : dcache_lsu_ld_data_bank10_dout[38:0];

assign dcache_data_bank11[38:0] = ldc_data_inj_vld
                                 ? dcache_lsu_ld_data_bank11_dout[38:0] ^ cp0_lsu_data_random[38:0]
                                 : dcache_lsu_ld_data_bank11_dout[38:0]; 

assign dcache_data_bank12[38:0] = ldc_data_inj_vld
                                 ? dcache_lsu_ld_data_bank12_dout[38:0] ^ cp0_lsu_data_random[38:0]
                                 : dcache_lsu_ld_data_bank12_dout[38:0];

assign dcache_data_bank13[38:0] = ldc_data_inj_vld
                                 ? dcache_lsu_ld_data_bank13_dout[38:0] ^ cp0_lsu_data_random[38:0]
                                 : dcache_lsu_ld_data_bank13_dout[38:0];

assign dcache_data_bank14[38:0] = ldc_data_inj_vld
                                 ? dcache_lsu_ld_data_bank14_dout[38:0] ^ cp0_lsu_data_random[38:0]
                                 : dcache_lsu_ld_data_bank14_dout[38:0];

assign dcache_data_bank15[38:0] = ldc_data_inj_vld
                                 ? dcache_lsu_ld_data_bank15_dout[38:0] ^ cp0_lsu_data_random[38:0]
                                 : dcache_lsu_ld_data_bank15_dout[38:0];   
//------------------tag ecc check------------
assign tag_bf_ecc[`WK_LS_DCACHE_LDTAG_WIDTH-1:0] = dcache_ld_tag_dout[`WK_LS_DCACHE_LDTAG_WIDTH-1:0]; //L1D 67->135, LTL@20250323

assign w0_tag_bf_ecc[`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0] = tag_bf_ecc[`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0];
assign w1_tag_bf_ecc[`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0] = tag_bf_ecc[`WK_LS_DCACHE_DOUBLE_LDTAG_WIDTH-1:`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH];
assign w2_tag_bf_ecc[`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0] = tag_bf_ecc[`WK_LS_DCACHE_TRIPLE_LDTAG_WIDTH-1:`WK_LS_DCACHE_DOUBLE_LDTAG_WIDTH];
assign w3_tag_bf_ecc[`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0] = tag_bf_ecc[`WK_LS_DCACHE_LDTAG_WIDTH-1       :`WK_LS_DCACHE_TRIPLE_LDTAG_WIDTH];

assign tag_ecc_pipe_down = (ldc_lda_ex2_inst_vld  ||  ldc_ex2_borrow_vld && (ldc_lda_ex2_borrow_mmu || ldc_lda_ex2_borrow_prq))
                            && !lda_ecc_stall;
 
`ifdef WK_PA_WIDTH_40
// &Instance("xx_lsu_27bit_2stage_ecc_decode","x_xx_lsu_27bit_2stage_ecc_decode_w0"); @1918
xx_lsu_27bit_2stage_ecc_decode  x_xx_lsu_27bit_2stage_ecc_decode_w0 (
  .corrected_data         (w0_tag_corrected[`WK_LS_DCACHE_LDTAG_BF_ECC_LENGTH-1:0]),
  .cpurst_b               (cpurst_b              ),
  .data_decode            (w0_tag_bf_ecc[`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0]   ),
  .ecc_stage_vld          (tag_ecc_pipe_down     ),
  .ham_error              (w0_tag_ham_error      ),
  .parity_error           (w0_tag_parity_error   ),
  .stage_dp_clk           (lda_clk             )
);
// &Instance("xx_lsu_27bit_2stage_ecc_decode","x_xx_lsu_27bit_2stage_ecc_decode_w1"); @1927
xx_lsu_27bit_2stage_ecc_decode  x_xx_lsu_27bit_2stage_ecc_decode_w1 (
  .corrected_data         (w1_tag_corrected[`WK_LS_DCACHE_LDTAG_BF_ECC_LENGTH-1:0]),
  .cpurst_b               (cpurst_b              ),
  .data_decode            (w1_tag_bf_ecc[`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0]   ),
  .ecc_stage_vld          (tag_ecc_pipe_down     ),
  .ham_error              (w1_tag_ham_error      ),
  .parity_error           (w1_tag_parity_error   ),
  .stage_dp_clk           (lda_clk             )
);
xx_lsu_27bit_2stage_ecc_decode  x_xx_lsu_27bit_2stage_ecc_decode_w2 (
  .corrected_data         (w2_tag_corrected[`WK_LS_DCACHE_LDTAG_BF_ECC_LENGTH-1:0]),
  .cpurst_b               (cpurst_b              ),
  .data_decode            (w2_tag_bf_ecc[`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0]   ),
  .ecc_stage_vld          (tag_ecc_pipe_down     ),
  .ham_error              (w2_tag_ham_error      ),
  .parity_error           (w2_tag_parity_error   ),
  .stage_dp_clk           (lda_clk             )
);
xx_lsu_27bit_2stage_ecc_decode  x_xx_lsu_27bit_2stage_ecc_decode_w3 (
  .corrected_data         (w3_tag_corrected[`WK_LS_DCACHE_LDTAG_BF_ECC_LENGTH-1:0]),
  .cpurst_b               (cpurst_b              ),
  .data_decode            (w3_tag_bf_ecc[`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0]   ),
  .ecc_stage_vld          (tag_ecc_pipe_down     ),
  .ham_error              (w3_tag_ham_error      ),
  .parity_error           (w3_tag_parity_error   ),
  .stage_dp_clk           (lda_clk             )
);
`endif

`ifdef WK_PA_WIDTH_48
// &Instance("xx_lsu_31bit_2stage_ecc_decode","x_xx_lsu_31bit_2stage_ecc_decode_w0"); @1918
xx_lsu_35bit_2stage_ecc_decode  x_xx_lsu_35bit_2stage_ecc_decode_w0 (
  .corrected_data         (w0_tag_corrected[`WK_LS_DCACHE_LDTAG_BF_ECC_LENGTH-1:0]),
  .cpurst_b               (cpurst_b              ),
  .data_decode            (w0_tag_bf_ecc[`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0]   ),
  .ecc_stage_vld          (tag_ecc_pipe_down     ),
  .ham_error              (w0_tag_ham_error      ),
  .parity_error           (w0_tag_parity_error   ),
  .stage_dp_clk           (lda_clk             )
);
// &Instance("xx_lsu_31bit_2stage_ecc_decode","x_xx_lsu_31bit_2stage_ecc_decode_w1"); @1927
xx_lsu_35bit_2stage_ecc_decode  x_xx_lsu_35bit_2stage_ecc_decode_w1 (
  .corrected_data         (w1_tag_corrected[`WK_LS_DCACHE_LDTAG_BF_ECC_LENGTH-1:0]),
  .cpurst_b               (cpurst_b              ),
  .data_decode            (w1_tag_bf_ecc[`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0]   ),
  .ecc_stage_vld          (tag_ecc_pipe_down     ),
  .ham_error              (w1_tag_ham_error      ),
  .parity_error           (w1_tag_parity_error   ),
  .stage_dp_clk           (lda_clk             )
);
xx_lsu_35bit_2stage_ecc_decode  x_xx_lsu_35bit_2stage_ecc_decode_w2 (
  .corrected_data         (w2_tag_corrected[`WK_LS_DCACHE_LDTAG_BF_ECC_LENGTH-1:0]),
  .cpurst_b               (cpurst_b              ),
  .data_decode            (w2_tag_bf_ecc[`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0]   ),
  .ecc_stage_vld          (tag_ecc_pipe_down     ),
  .ham_error              (w2_tag_ham_error      ),
  .parity_error           (w2_tag_parity_error   ),
  .stage_dp_clk           (lda_clk             )
);
xx_lsu_35bit_2stage_ecc_decode  x_xx_lsu_35bit_2stage_ecc_decode_w3 (
  .corrected_data         (w3_tag_corrected[`WK_LS_DCACHE_LDTAG_BF_ECC_LENGTH-1:0]),
  .cpurst_b               (cpurst_b              ),
  .data_decode            (w3_tag_bf_ecc[`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0]   ),
  .ecc_stage_vld          (tag_ecc_pipe_down     ),
  .ham_error              (w3_tag_ham_error      ),
  .parity_error           (w3_tag_parity_error   ),
  .stage_dp_clk           (lda_clk             )
);
`endif

assign w0_ecc_free   = !w0_tag_ham_error && !w0_tag_parity_error;
assign w0_ecc_fatal  = w0_tag_ham_error  && !w0_tag_parity_error;

assign w1_ecc_free   = !w1_tag_ham_error && !w1_tag_parity_error;
assign w1_ecc_fatal  = w1_tag_ham_error  && !w1_tag_parity_error;

assign w2_ecc_free   = !w2_tag_ham_error && !w2_tag_parity_error;
assign w2_ecc_fatal  = w2_tag_ham_error  && !w2_tag_parity_error;

assign w3_ecc_free   = !w3_tag_ham_error && !w3_tag_parity_error;
assign w3_ecc_fatal  = w3_tag_ham_error  && !w3_tag_parity_error;

assign ld_da_tag_ecc_vld = lda_ex3_page_ca
                           && cp0_lsu_dcache_en
                           && cp0_lsu_ecc_en
                           && (!w0_ecc_free || !w1_ecc_free || !w2_ecc_free || !w3_ecc_free);

assign ld_da_tag_ecc_err = lda_ex3_page_ca 
                           && cp0_lsu_dcache_en
                           && cp0_lsu_ecc_en
                           && (w0_ecc_fatal || w1_ecc_fatal || w2_ecc_fatal || w3_ecc_fatal);

//when 1-bit err,need to stall pipe to handle it
assign ld_da_fwd_no_cache     = ld_da_fwd_sq_vld || ld_da_fwd_sq_bypass_vld;//sq or bypass

assign lda_tag_ecc_stall_ori = (lda_ex3_inst_vld
                                     && !ld_da_vector_nop
                                     && !ld_da_expt_vld_cancel // Risc-V Debug zdb
                                     && !ld_da_restart_no_cache
                                     && !ld_da_fwd_no_cache
                                     && !rtu_lsu_flush_fe
                                     && !(rtu_ck_flush && rtu_ck_flush_iid_older_than_ex3_iid)  //flush younger ecc_stall, ck_flush@LTL
                                  || lda_ex3_borrow_vld 
                                     && lda_borrow_mmu)
                                 && !lda_ecc_stall_already
                                 && ld_da_tag_ecc_vld;

assign lda_tag_ecc_stall     = lda_tag_ecc_stall_ori
                                 && !rb_lda_ex3_hit_idx
                                 && !lfb_lda_hit_idx
                                 && !lm_lda_ex3_hit_idx;

assign ld_da_tag_ecc_stall_gate  = lda_tag_ecc_stall_ori;

//fix info
assign lda_dcache_tag_corrected[`WK_LS_DCACHE_LDTAG_QUADRUPLE_BF_ECC_LENGTH-1:0] = {w3_tag_corrected[`WK_LS_DCACHE_LDTAG_BF_ECC_LENGTH-1:0],
                                                                                    w2_tag_corrected[`WK_LS_DCACHE_LDTAG_BF_ECC_LENGTH-1:0],
                                                                                    w1_tag_corrected[`WK_LS_DCACHE_LDTAG_BF_ECC_LENGTH-1:0],
                                                                                    w0_tag_corrected[`WK_LS_DCACHE_LDTAG_BF_ECC_LENGTH-1:0]};

assign ld_da_ecc_hit_way0   = w0_tag_corrected[`WK_LS_DCACHE_LDTAG_BF_ECC_LENGTH-1]
                              &&  cp0_lsu_dcache_en
                              &&  lda_ex3_page_ca
                              &&  (lda_addr0[`WK_PA_WIDTH-1:14] == w0_tag_corrected[`WK_LS_DCACHE_SINGLE_TAG_WIDTH-1:0]);

assign ld_da_ecc_hit_way1   = w1_tag_corrected[`WK_LS_DCACHE_LDTAG_BF_ECC_LENGTH-1]
                              &&  cp0_lsu_dcache_en
                              &&  lda_ex3_page_ca
                              &&  (lda_addr0[`WK_PA_WIDTH-1:14] == w1_tag_corrected[`WK_LS_DCACHE_SINGLE_TAG_WIDTH-1:0]);

assign ld_da_ecc_hit_way2   = w2_tag_corrected[`WK_LS_DCACHE_LDTAG_BF_ECC_LENGTH-1]
                              &&  cp0_lsu_dcache_en
                              &&  lda_ex3_page_ca
                              &&  (lda_addr0[`WK_PA_WIDTH-1:14] == w2_tag_corrected[`WK_LS_DCACHE_SINGLE_TAG_WIDTH-1:0]);

assign ld_da_ecc_hit_way3   = w3_tag_corrected[`WK_LS_DCACHE_LDTAG_BF_ECC_LENGTH-1]
                              &&  cp0_lsu_dcache_en
                              &&  lda_ex3_page_ca
                              &&  (lda_addr0[`WK_PA_WIDTH-1:14] == w3_tag_corrected[`WK_LS_DCACHE_SINGLE_TAG_WIDTH-1:0]);

assign ld_da_ecc_dcache_hit = ld_da_ecc_hit_way0 || ld_da_ecc_hit_way1 || ld_da_ecc_hit_way2 || ld_da_ecc_hit_way3;

//assign ld_da_ecc_hit_low_region  = lda_addr0[4]
//                                   ? ld_da_ecc_hit_way1
//                                   : ld_da_ecc_hit_way0;
//
//assign ld_da_ecc_hit_high_region = lda_addr0[4]
//                                   ? ld_da_ecc_hit_way0
//                                   : ld_da_ecc_hit_way1;

always @(*)
begin
  case(lda_addr0[5:4])
  2'b00: begin
    ld_da_ecc_hit_0_region = ld_da_ecc_hit_way0;
    ld_da_ecc_hit_1_region = ld_da_ecc_hit_way1;
    ld_da_ecc_hit_2_region = ld_da_ecc_hit_way2;
    ld_da_ecc_hit_3_region = ld_da_ecc_hit_way3;
  end
  2'b01: begin
    ld_da_ecc_hit_0_region = ld_da_ecc_hit_way1;
    ld_da_ecc_hit_1_region = ld_da_ecc_hit_way0;
    ld_da_ecc_hit_2_region = ld_da_ecc_hit_way3;
    ld_da_ecc_hit_3_region = ld_da_ecc_hit_way2;
  end
  2'b10: begin
    ld_da_ecc_hit_0_region = ld_da_ecc_hit_way2;
    ld_da_ecc_hit_1_region = ld_da_ecc_hit_way3;
    ld_da_ecc_hit_2_region = ld_da_ecc_hit_way0;
    ld_da_ecc_hit_3_region = ld_da_ecc_hit_way1;
  end
  2'b11: begin
    ld_da_ecc_hit_0_region = ld_da_ecc_hit_way3;
    ld_da_ecc_hit_1_region = ld_da_ecc_hit_way2;
    ld_da_ecc_hit_2_region = ld_da_ecc_hit_way1;
    ld_da_ecc_hit_3_region = ld_da_ecc_hit_way0;
  end
  default:begin
    ld_da_ecc_hit_0_region = 1'b0;
    ld_da_ecc_hit_1_region = 1'b0;
    ld_da_ecc_hit_2_region = 1'b0;
    ld_da_ecc_hit_3_region = 1'b0;
  end
  endcase
end
//------------------data ecc check------------
assign data_bank0_bf_ecc[38:0] = lda_dcache_data_bank0[38:0];
assign data_bank1_bf_ecc[38:0] = lda_dcache_data_bank1[38:0];
assign data_bank2_bf_ecc[38:0] = lda_dcache_data_bank2[38:0];
assign data_bank3_bf_ecc[38:0] = lda_dcache_data_bank3[38:0];
assign data_bank4_bf_ecc[38:0] = lda_dcache_data_bank4[38:0];
assign data_bank5_bf_ecc[38:0] = lda_dcache_data_bank5[38:0];
assign data_bank6_bf_ecc[38:0] = lda_dcache_data_bank6[38:0];
assign data_bank7_bf_ecc[38:0] = lda_dcache_data_bank7[38:0];
assign data_bank8_bf_ecc[38:0] = lda_dcache_data_bank8[38:0];
assign data_bank9_bf_ecc[38:0] = lda_dcache_data_bank9[38:0];
assign data_bank10_bf_ecc[38:0] = lda_dcache_data_bank10[38:0];
assign data_bank11_bf_ecc[38:0] = lda_dcache_data_bank11[38:0];
assign data_bank12_bf_ecc[38:0] = lda_dcache_data_bank12[38:0];
assign data_bank13_bf_ecc[38:0] = lda_dcache_data_bank13[38:0];
assign data_bank14_bf_ecc[38:0] = lda_dcache_data_bank14[38:0];
assign data_bank15_bf_ecc[38:0] = lda_dcache_data_bank15[38:0];
// &Instance("xx_lsu_32bit_ecc_decode", "x_wk_dcache_32bit_ecc_decode_bank0"); @2006
xx_lsu_32bit_ecc_decode  x_wk_dcache_32bit_ecc_decode_bank0 (
  .corrected_data             (data_bank0_corrected[31:0]),
  .data_decode                (data_bank0_bf_ecc[38:0]   ),
  .ham_error                  (data_bank0_ham_error      ),
  .parity_error               (data_bank0_parity_error   )
);

// &Connect(.data_decode    (data_bank0_bf_ecc[38:0]     ),   @2007
//          .ham_error      (data_bank0_ham_error        ),  @2008
//          .parity_error   (data_bank0_parity_error     ),  @2009
//          .corrected_data (data_bank0_corrected[31:0]  )  @2010
//         ); @2011

// &Instance("xx_lsu_32bit_ecc_decode", "x_wk_dcache_32bit_ecc_decode_bank1"); @2013
xx_lsu_32bit_ecc_decode  x_wk_dcache_32bit_ecc_decode_bank1 (
  .corrected_data             (data_bank1_corrected[31:0]),
  .data_decode                (data_bank1_bf_ecc[38:0]   ),
  .ham_error                  (data_bank1_ham_error      ),
  .parity_error               (data_bank1_parity_error   )
);

// &Connect(.data_decode    (data_bank1_bf_ecc[38:0]     ),   @2014
//          .ham_error      (data_bank1_ham_error        ),  @2015
//          .parity_error   (data_bank1_parity_error     ),  @2016
//          .corrected_data (data_bank1_corrected[31:0]  )  @2017
//         ); @2018

// &Instance("xx_lsu_32bit_ecc_decode", "x_wk_dcache_32bit_ecc_decode_bank2"); @2020
xx_lsu_32bit_ecc_decode  x_wk_dcache_32bit_ecc_decode_bank2 (
  .corrected_data             (data_bank2_corrected[31:0]),
  .data_decode                (data_bank2_bf_ecc[38:0]   ),
  .ham_error                  (data_bank2_ham_error      ),
  .parity_error               (data_bank2_parity_error   )
);

// &Connect(.data_decode    (data_bank2_bf_ecc[38:0]     ),   @2021
//          .ham_error      (data_bank2_ham_error        ),  @2022
//          .parity_error   (data_bank2_parity_error     ),  @2023
//          .corrected_data (data_bank2_corrected[31:0]  )  @2024
//         ); @2025

// &Instance("xx_lsu_32bit_ecc_decode", "x_wk_dcache_32bit_ecc_decode_bank3"); @2027
xx_lsu_32bit_ecc_decode  x_wk_dcache_32bit_ecc_decode_bank3 (
  .corrected_data             (data_bank3_corrected[31:0]),
  .data_decode                (data_bank3_bf_ecc[38:0]   ),
  .ham_error                  (data_bank3_ham_error      ),
  .parity_error               (data_bank3_parity_error   )
);

// &Connect(.data_decode    (data_bank3_bf_ecc[38:0]     ),   @2028
//          .ham_error      (data_bank3_ham_error        ),  @2029
//          .parity_error   (data_bank3_parity_error     ),  @2030
//          .corrected_data (data_bank3_corrected[31:0]  )  @2031
//         ); @2032

// &Instance("xx_lsu_32bit_ecc_decode", "x_wk_dcache_32bit_ecc_decode_bank4"); @2034
xx_lsu_32bit_ecc_decode  x_wk_dcache_32bit_ecc_decode_bank4 (
  .corrected_data             (data_bank4_corrected[31:0]),
  .data_decode                (data_bank4_bf_ecc[38:0]   ),
  .ham_error                  (data_bank4_ham_error      ),
  .parity_error               (data_bank4_parity_error   )
);

// &Connect(.data_decode    (data_bank4_bf_ecc[38:0]     ),   @2035
//          .ham_error      (data_bank4_ham_error        ),  @2036
//          .parity_error   (data_bank4_parity_error     ),  @2037
//          .corrected_data (data_bank4_corrected[31:0]  )  @2038
//         ); @2039

// &Instance("xx_lsu_32bit_ecc_decode", "x_wk_dcache_32bit_ecc_decode_bank5"); @2041
xx_lsu_32bit_ecc_decode  x_wk_dcache_32bit_ecc_decode_bank5 (
  .corrected_data             (data_bank5_corrected[31:0]),
  .data_decode                (data_bank5_bf_ecc[38:0]   ),
  .ham_error                  (data_bank5_ham_error      ),
  .parity_error               (data_bank5_parity_error   )
);

// &Connect(.data_decode    (data_bank5_bf_ecc[38:0]     ),   @2042
//          .ham_error      (data_bank5_ham_error        ),  @2043
//          .parity_error   (data_bank5_parity_error     ),  @2044
//          .corrected_data (data_bank5_corrected[31:0]  )  @2045
//         ); @2046

// &Instance("xx_lsu_32bit_ecc_decode", "x_wk_dcache_32bit_ecc_decode_bank6"); @2048
xx_lsu_32bit_ecc_decode  x_wk_dcache_32bit_ecc_decode_bank6 (
  .corrected_data             (data_bank6_corrected[31:0]),
  .data_decode                (data_bank6_bf_ecc[38:0]   ),
  .ham_error                  (data_bank6_ham_error      ),
  .parity_error               (data_bank6_parity_error   )
);

// &Connect(.data_decode    (data_bank6_bf_ecc[38:0]     ),   @2049
//          .ham_error      (data_bank6_ham_error        ),  @2050
//          .parity_error   (data_bank6_parity_error     ),  @2051
//          .corrected_data (data_bank6_corrected[31:0]  )  @2052
//         ); @2053

// &Instance("xx_lsu_32bit_ecc_decode", "x_wk_dcache_32bit_ecc_decode_bank7"); @2055
xx_lsu_32bit_ecc_decode  x_wk_dcache_32bit_ecc_decode_bank7 (
  .corrected_data             (data_bank7_corrected[31:0]),
  .data_decode                (data_bank7_bf_ecc[38:0]   ),
  .ham_error                  (data_bank7_ham_error      ),
  .parity_error               (data_bank7_parity_error   )
);

// &Connect(.data_decode    (data_bank7_bf_ecc[38:0]     ),   @2056
//          .ham_error      (data_bank7_ham_error        ),  @2057
//          .parity_error   (data_bank7_parity_error     ),  @2058
//          .corrected_data (data_bank7_corrected[31:0]  )  @2059
//         ); @2060
xx_lsu_32bit_ecc_decode  x_wk_dcache_32bit_ecc_decode_bank8 (
  .corrected_data             (data_bank8_corrected[31:0]),
  .data_decode                (data_bank8_bf_ecc[38:0]   ),
  .ham_error                  (data_bank8_ham_error      ),
  .parity_error               (data_bank8_parity_error   )
);
xx_lsu_32bit_ecc_decode  x_wk_dcache_32bit_ecc_decode_bank9 (
  .corrected_data             (data_bank9_corrected[31:0]),
  .data_decode                (data_bank9_bf_ecc[38:0]   ),
  .ham_error                  (data_bank9_ham_error      ),
  .parity_error               (data_bank9_parity_error   )
);
xx_lsu_32bit_ecc_decode  x_wk_dcache_32bit_ecc_decode_bank10 (
  .corrected_data             (data_bank10_corrected[31:0]),
  .data_decode                (data_bank10_bf_ecc[38:0]   ),
  .ham_error                  (data_bank10_ham_error      ),
  .parity_error               (data_bank10_parity_error   )
);
xx_lsu_32bit_ecc_decode  x_wk_dcache_32bit_ecc_decode_bank11 (
  .corrected_data             (data_bank11_corrected[31:0]),
  .data_decode                (data_bank11_bf_ecc[38:0]   ),
  .ham_error                  (data_bank11_ham_error      ),
  .parity_error               (data_bank11_parity_error   )
);
xx_lsu_32bit_ecc_decode  x_wk_dcache_32bit_ecc_decode_bank12 (
  .corrected_data             (data_bank12_corrected[31:0]),
  .data_decode                (data_bank12_bf_ecc[38:0]   ),
  .ham_error                  (data_bank12_ham_error      ),
  .parity_error               (data_bank12_parity_error   )
);
xx_lsu_32bit_ecc_decode  x_wk_dcache_32bit_ecc_decode_bank13 (
  .corrected_data             (data_bank13_corrected[31:0]),
  .data_decode                (data_bank13_bf_ecc[38:0]   ),
  .ham_error                  (data_bank13_ham_error      ),
  .parity_error               (data_bank13_parity_error   )
);
xx_lsu_32bit_ecc_decode  x_wk_dcache_32bit_ecc_decode_bank14 (
  .corrected_data             (data_bank14_corrected[31:0]),
  .data_decode                (data_bank14_bf_ecc[38:0]   ),
  .ham_error                  (data_bank14_ham_error      ),
  .parity_error               (data_bank14_parity_error   )
);
xx_lsu_32bit_ecc_decode  x_wk_dcache_32bit_ecc_decode_bank15 (
  .corrected_data             (data_bank15_corrected[31:0]),
  .data_decode                (data_bank15_bf_ecc[38:0]   ),
  .ham_error                  (data_bank15_ham_error      ),
  .parity_error               (data_bank15_parity_error   )
);
assign data_bank0_ecc_vld = cp0_lsu_ecc_en
                            && lda_get_dcache_data[0]
                            && !lda_ecc_stall_data
                            && !(!data_bank0_ham_error && !data_bank0_parity_error);
assign data_bank0_ecc_err = cp0_lsu_ecc_en
                            && lda_get_dcache_data[0]
                            && !lda_ecc_stall_data
                            && data_bank0_ham_error 
                            && !data_bank0_parity_error;
assign data_bank1_ecc_vld = cp0_lsu_ecc_en
                            && lda_get_dcache_data[1]
                            && !lda_ecc_stall_data
                            && !(!data_bank1_ham_error && !data_bank1_parity_error);
assign data_bank1_ecc_err = cp0_lsu_ecc_en
                            && lda_get_dcache_data[1]
                            && !lda_ecc_stall_data
                            && data_bank1_ham_error 
                            && !data_bank1_parity_error;
assign data_bank2_ecc_vld = cp0_lsu_ecc_en
                            && lda_get_dcache_data[2]
                            && !lda_ecc_stall_data
                            && !(!data_bank2_ham_error && !data_bank2_parity_error);
assign data_bank2_ecc_err = cp0_lsu_ecc_en
                            && lda_get_dcache_data[2]
                            && !lda_ecc_stall_data
                            && data_bank2_ham_error 
                            && !data_bank2_parity_error;
assign data_bank3_ecc_vld = cp0_lsu_ecc_en
                            && lda_get_dcache_data[3]
                            && !lda_ecc_stall_data
                            && !(!data_bank3_ham_error && !data_bank3_parity_error);
assign data_bank3_ecc_err = cp0_lsu_ecc_en
                            && lda_get_dcache_data[3]
                            && !lda_ecc_stall_data
                            && data_bank3_ham_error 
                            && !data_bank3_parity_error;
assign data_bank4_ecc_vld = cp0_lsu_ecc_en
                            && lda_get_dcache_data[0]
                            && !lda_ecc_stall_data
                            && !(!data_bank4_ham_error && !data_bank4_parity_error);
assign data_bank4_ecc_err = cp0_lsu_ecc_en
                            && lda_get_dcache_data[0]
                            && !lda_ecc_stall_data
                            && data_bank4_ham_error 
                            && !data_bank4_parity_error;
assign data_bank5_ecc_vld = cp0_lsu_ecc_en
                            && lda_get_dcache_data[1]
                            && !lda_ecc_stall_data
                            && !(!data_bank5_ham_error && !data_bank5_parity_error);
assign data_bank5_ecc_err = cp0_lsu_ecc_en
                            && lda_get_dcache_data[1]
                            && !lda_ecc_stall_data
                            && data_bank5_ham_error 
                            && !data_bank5_parity_error;
assign data_bank6_ecc_vld = cp0_lsu_ecc_en
                            && lda_get_dcache_data[2]
                            && !lda_ecc_stall_data
                            && !(!data_bank6_ham_error && !data_bank6_parity_error);
assign data_bank6_ecc_err = cp0_lsu_ecc_en
                            && lda_get_dcache_data[2]
                            && !lda_ecc_stall_data
                            && data_bank6_ham_error 
                            && !data_bank6_parity_error;
assign data_bank7_ecc_vld = cp0_lsu_ecc_en
                            && lda_get_dcache_data[3]
                            && !lda_ecc_stall_data
                            && !(!data_bank7_ham_error && !data_bank7_parity_error);
assign data_bank7_ecc_err = cp0_lsu_ecc_en
                            && lda_get_dcache_data[3]
                            && !lda_ecc_stall_data
                            && data_bank7_ham_error 
                            && !data_bank7_parity_error;

assign data_bank8_ecc_vld = cp0_lsu_ecc_en
                            && lda_get_dcache_data[0]
                            && !lda_ecc_stall_data
                            && !(!data_bank8_ham_error && !data_bank8_parity_error);
assign data_bank8_ecc_err = cp0_lsu_ecc_en
                            && lda_get_dcache_data[0]
                            && !lda_ecc_stall_data
                            && data_bank8_ham_error 
                            && !data_bank8_parity_error;
assign data_bank9_ecc_vld = cp0_lsu_ecc_en
                            && lda_get_dcache_data[1]
                            && !lda_ecc_stall_data
                            && !(!data_bank9_ham_error && !data_bank9_parity_error);
assign data_bank9_ecc_err = cp0_lsu_ecc_en
                            && lda_get_dcache_data[1]
                            && !lda_ecc_stall_data
                            && data_bank9_ham_error 
                            && !data_bank9_parity_error;
assign data_bank10_ecc_vld = cp0_lsu_ecc_en
                            && lda_get_dcache_data[2]
                            && !lda_ecc_stall_data
                            && !(!data_bank10_ham_error && !data_bank10_parity_error);
assign data_bank10_ecc_err = cp0_lsu_ecc_en
                            && lda_get_dcache_data[2]
                            && !lda_ecc_stall_data
                            && data_bank10_ham_error 
                            && !data_bank10_parity_error;
assign data_bank11_ecc_vld = cp0_lsu_ecc_en
                            && lda_get_dcache_data[3]
                            && !lda_ecc_stall_data
                            && !(!data_bank11_ham_error && !data_bank11_parity_error);
assign data_bank11_ecc_err = cp0_lsu_ecc_en
                            && lda_get_dcache_data[3]
                            && !lda_ecc_stall_data
                            && data_bank11_ham_error 
                            && !data_bank11_parity_error;

assign data_bank12_ecc_vld = cp0_lsu_ecc_en
                            && lda_get_dcache_data[0]
                            && !lda_ecc_stall_data
                            && !(!data_bank12_ham_error && !data_bank12_parity_error);
assign data_bank12_ecc_err = cp0_lsu_ecc_en
                            && lda_get_dcache_data[0]
                            && !lda_ecc_stall_data
                            && data_bank12_ham_error 
                            && !data_bank12_parity_error;
assign data_bank13_ecc_vld = cp0_lsu_ecc_en
                            && lda_get_dcache_data[1]
                            && !lda_ecc_stall_data
                            && !(!data_bank13_ham_error && !data_bank13_parity_error);
assign data_bank13_ecc_err = cp0_lsu_ecc_en
                            && lda_get_dcache_data[1]
                            && !lda_ecc_stall_data
                            && data_bank13_ham_error 
                            && !data_bank13_parity_error;
assign data_bank14_ecc_vld = cp0_lsu_ecc_en
                            && lda_get_dcache_data[2]
                            && !lda_ecc_stall_data
                            && !(!data_bank14_ham_error && !data_bank14_parity_error);
assign data_bank14_ecc_err = cp0_lsu_ecc_en
                            && lda_get_dcache_data[2]
                            && !lda_ecc_stall_data
                            && data_bank14_ham_error 
                            && !data_bank14_parity_error;
assign data_bank15_ecc_vld = cp0_lsu_ecc_en
                            && lda_get_dcache_data[3]
                            && !lda_ecc_stall_data
                            && !(!data_bank15_ham_error && !data_bank15_parity_error);
assign data_bank15_ecc_err = cp0_lsu_ecc_en
                            && lda_get_dcache_data[3]
                            && !lda_ecc_stall_data
                            && data_bank15_ham_error 
                            && !data_bank15_parity_error;

assign data_0_region_ecc_vld  = data_bank0_ecc_vld
                                  || data_bank1_ecc_vld
                                  || data_bank2_ecc_vld
                                  || data_bank3_ecc_vld;

assign data_0_region_ecc_err  = data_bank0_ecc_err
                                  || data_bank1_ecc_err
                                  || data_bank2_ecc_err
                                  || data_bank3_ecc_err;

assign data_1_region_ecc_vld = data_bank4_ecc_vld
                                 || data_bank5_ecc_vld
                                 || data_bank6_ecc_vld
                                 || data_bank7_ecc_vld;

assign data_1_region_ecc_err = data_bank4_ecc_err
                                  || data_bank5_ecc_err
                                  || data_bank6_ecc_err
                                  || data_bank7_ecc_err;

assign data_2_region_ecc_vld = data_bank8_ecc_vld
                                 || data_bank9_ecc_vld
                                 || data_bank10_ecc_vld
                                 || data_bank11_ecc_vld;

assign data_2_region_ecc_err = data_bank8_ecc_err
                                  || data_bank9_ecc_err
                                  || data_bank10_ecc_err
                                  || data_bank11_ecc_err;

assign data_3_region_ecc_vld = data_bank12_ecc_vld
                                 || data_bank13_ecc_vld
                                 || data_bank14_ecc_vld
                                 || data_bank15_ecc_vld;

assign data_3_region_ecc_err = data_bank12_ecc_err
                                  || data_bank13_ecc_err
                                  || data_bank14_ecc_err
                                  || data_bank15_ecc_err;

//assign ld_da_hit_low_ecc  = lda_ex3_borrow_vld && lda_borrow_wmb
//                            ? !ld_da_settle_way
//                            : ld_da_hit_low_region;
//

//assign ld_da_hit_high_ecc  = lda_ex3_borrow_vld && lda_borrow_wmb
//                            ? ld_da_settle_way
//                            : ld_da_hit_high_region;

assign ld_da_hit_0_ecc  = lda_ex3_borrow_vld && lda_borrow_wmb
                            ? (ld_da_settle_way == 2'b00)
                            : ld_da_hit_0_region;
assign ld_da_hit_1_ecc  = lda_ex3_borrow_vld && lda_borrow_wmb
                            ? (ld_da_settle_way == 2'b01)
                            : ld_da_hit_1_region;
assign ld_da_hit_2_ecc  = lda_ex3_borrow_vld && lda_borrow_wmb
                            ? (ld_da_settle_way == 2'b10)
                            : ld_da_hit_2_region;
assign ld_da_hit_3_ecc  = lda_ex3_borrow_vld && lda_borrow_wmb
                            ? (ld_da_settle_way == 2'b11)
                            : ld_da_hit_3_region;

assign ld_da_data128_ecc_vld = ld_da_hit_0_ecc & data_0_region_ecc_vld
                               | ld_da_hit_1_ecc & data_1_region_ecc_vld
                               | ld_da_hit_2_ecc & data_2_region_ecc_vld
                               | ld_da_hit_3_ecc & data_3_region_ecc_vld;

assign ld_da_data128_ecc_err = ld_da_hit_0_ecc & data_0_region_ecc_err
                               | ld_da_hit_1_ecc & data_1_region_ecc_err
                               | ld_da_hit_2_ecc & data_2_region_ecc_err
                               | ld_da_hit_3_ecc & data_3_region_ecc_err;

//for vb/snq
assign ld_da_data256_ecc_vld = data_0_region_ecc_vld || data_1_region_ecc_vld || data_2_region_ecc_vld || data_3_region_ecc_vld;
assign lda_data256_ecc_err = data_0_region_ecc_err || data_1_region_ecc_err || data_2_region_ecc_err || data_3_region_ecc_err;

assign ld_da_data_ecc_vld = lda_ex3_borrow_vld && (ld_da_borrow_vb || ld_da_borrow_sndb)
                            ? ld_da_data256_ecc_vld
                            : ld_da_data128_ecc_vld;
assign ld_da_data_ecc_err = lda_ex3_borrow_vld && (ld_da_borrow_vb || ld_da_borrow_sndb)
                            ? lda_data256_ecc_err
                            : ld_da_data128_ecc_err;

//when ecc err(1/2 bits),need to stall pipe to handle it
assign ld_da_data_ecc_stall_ori = (lda_ex3_inst_vld 
                                        && !ld_da_vector_nop
                                        && !ld_da_expt_vld_cancel // Risc-V Debug zdb
                                        && !ld_da_restart_no_cache
                                        && !ld_da_fwd_no_cache
                                        && lda_ex3_dcache_hit
                                        && !rtu_lsu_flush_fe
                                        && !(rtu_ck_flush && rtu_ck_flush_iid_older_than_ex3_iid) //flush younger ecc_stall, ck_flush@LTL
                                     || lda_ex3_borrow_vld 
                                        && lda_borrow_mmu)
                                  && (!ld_da_tag_ecc_vld || lda_ecc_stall_already)
                                  && !ld_da_ecc_stall_tag_fatal
                                  && ld_da_data128_ecc_vld;

assign ld_da_data_rb_restart = ld_da_hit_idx_discard_req 
                               || ld_da_rb_create_vld_unmask && rb_lda_ex3_full;                                 
assign lda_data_ecc_stall  = ld_da_data_ecc_stall_ori && !ld_da_data_rb_restart;

assign ld_da_data_ecc_stall_gate = ld_da_data_ecc_stall_ori; 

//fix info
//ecc info is not required
assign lda_ecc_data_bank0[38:0] = {7'b0,data_bank0_corrected[31:0]}; 
assign lda_ecc_data_bank1[38:0] = {7'b0,data_bank1_corrected[31:0]}; 
assign lda_ecc_data_bank2[38:0] = {7'b0,data_bank2_corrected[31:0]}; 
assign lda_ecc_data_bank3[38:0] = {7'b0,data_bank3_corrected[31:0]}; 
assign lda_ecc_data_bank4[38:0] = {7'b0,data_bank4_corrected[31:0]}; 
assign lda_ecc_data_bank5[38:0] = {7'b0,data_bank5_corrected[31:0]}; 
assign lda_ecc_data_bank6[38:0] = {7'b0,data_bank6_corrected[31:0]}; 
assign lda_ecc_data_bank7[38:0] = {7'b0,data_bank7_corrected[31:0]};
assign lda_ecc_data_bank8[38:0] = {7'b0,data_bank8_corrected[31:0]}; 
assign lda_ecc_data_bank9[38:0] = {7'b0,data_bank9_corrected[31:0]}; 
assign lda_ecc_data_bank10[38:0] = {7'b0,data_bank10_corrected[31:0]}; 
assign lda_ecc_data_bank11[38:0] = {7'b0,data_bank11_corrected[31:0]}; 
assign lda_ecc_data_bank12[38:0] = {7'b0,data_bank12_corrected[31:0]}; 
assign lda_ecc_data_bank13[38:0] = {7'b0,data_bank13_corrected[31:0]}; 
assign lda_ecc_data_bank14[38:0] = {7'b0,data_bank14_corrected[31:0]}; 
assign lda_ecc_data_bank15[38:0] = {7'b0,data_bank15_corrected[31:0]};

assign lda_data512_way0_corrected[511:0] = {data_bank15_corrected[31:0],
                                              data_bank14_corrected[31:0],
                                              data_bank13_corrected[31:0],
                                              data_bank12_corrected[31:0],
                                              data_bank11_corrected[31:0],
                                              data_bank10_corrected[31:0],
                                              data_bank9_corrected[31:0],
                                              data_bank8_corrected[31:0],
                                              data_bank7_corrected[31:0],
                                              data_bank6_corrected[31:0],
                                              data_bank5_corrected[31:0],
                                              data_bank4_corrected[31:0],
                                              data_bank3_corrected[31:0],
                                              data_bank2_corrected[31:0],
                                              data_bank1_corrected[31:0],
                                              data_bank0_corrected[31:0]};

assign lda_data512_way1_corrected[511:0] = {data_bank11_corrected[31:0],
                                              data_bank10_corrected[31:0],
                                              data_bank9_corrected[31:0],
                                              data_bank8_corrected[31:0],
                                              data_bank15_corrected[31:0],
                                              data_bank14_corrected[31:0],
                                              data_bank13_corrected[31:0],
                                              data_bank12_corrected[31:0],
                                              data_bank3_corrected[31:0],
                                              data_bank2_corrected[31:0],
                                              data_bank1_corrected[31:0],
                                              data_bank0_corrected[31:0],
                                              data_bank7_corrected[31:0],
                                              data_bank6_corrected[31:0],
                                              data_bank5_corrected[31:0],
                                              data_bank4_corrected[31:0]};
assign lda_data512_way2_corrected[511:0] = {data_bank7_corrected[31:0],
                                              data_bank6_corrected[31:0],
                                              data_bank5_corrected[31:0],
                                              data_bank4_corrected[31:0],
                                              data_bank3_corrected[31:0],
                                              data_bank2_corrected[31:0],
                                              data_bank1_corrected[31:0],
                                              data_bank0_corrected[31:0],
                                              data_bank15_corrected[31:0],
                                              data_bank14_corrected[31:0],
                                              data_bank13_corrected[31:0],
                                              data_bank12_corrected[31:0],
                                              data_bank11_corrected[31:0],
                                              data_bank10_corrected[31:0],
                                              data_bank9_corrected[31:0],
                                              data_bank8_corrected[31:0]};
assign lda_data512_way3_corrected[511:0] = {data_bank3_corrected[31:0],
                                              data_bank2_corrected[31:0],
                                              data_bank1_corrected[31:0],
                                              data_bank0_corrected[31:0],
                                              data_bank7_corrected[31:0],
                                              data_bank6_corrected[31:0],
                                              data_bank5_corrected[31:0],
                                              data_bank4_corrected[31:0],
                                              data_bank11_corrected[31:0],
                                              data_bank10_corrected[31:0],
                                              data_bank9_corrected[31:0],
                                              data_bank8_corrected[31:0],
                                              data_bank15_corrected[31:0],
                                              data_bank14_corrected[31:0],
                                              data_bank13_corrected[31:0],
                                              data_bank12_corrected[31:0]};
//control signal
assign lda_ecc_stall      = lda_tag_ecc_stall || lda_data_ecc_stall || ld_da_tcm_ecc_stall;
assign lda_ecc_stall_gate = ld_da_tag_ecc_stall_gate || ld_da_data_ecc_stall_gate || ld_da_tcm_ecc_stall_gate;
assign lda_ecc_fatal      = ld_da_tag_ecc_err 
                                 && lda_tag_ecc_stall_ori
                              || (ld_da_data_ecc_stall_ori
                                     && !lda_tag_ecc_stall_ori
                                  || lda_ex3_borrow_vld && !lda_borrow_mmu)
                                 && ld_da_data_ecc_err;
//assign lda_ecc_tag_way = ld_da_tag_ecc_err
//                           ? w1_ecc_fatal
//                           : !w1_ecc_free;
assign lda_ecc_tag_way = ld_da_tag_ecc_err
                           ? {w3_ecc_fatal,w2_ecc_fatal,w1_ecc_fatal,w0_ecc_fatal}
                           : {!w3_ecc_free,!w2_ecc_free,!w1_ecc_free,!w0_ecc_free};

assign lda_rb_ex3_ecc_mask    = lda_tag_ecc_stall_ori || lda_ecc_stall_data || ld_da_ecc_stall_tag_fatal; 
//assign ld_da_mcic_ecc_mask = lda_tag_ecc_stall_ori || lda_ecc_stall_data; 

//for data cmplt req mask
assign ld_da_ecc_data_req_mask = lda_tag_ecc_stall_ori || ld_da_data_ecc_stall_ori || ld_da_tcm_ecc_stall_ori;

//for wmb data reissue
assign lda_wmb_ex3_data_reissue = lda_ecc_stall;

//for vb/snq data reissue
assign lda_vb_ex3_snq_data_reissue = lda_ecc_stall;

//for vb/snq ecc error
assign lda_vb_snq_ex3_ecc_err = lda_ex3_borrow_vld
                              && !lda_borrow_icc
                              && !lda_borrow_wmb
                              && !lda_borrow_mmu
                              && lda_data256_ecc_err;

//for wmb fwd data,we can stall fwd data
//for sq fwd data,we should cancel ecc stall(no partial fwd for sq)
assign lda_ex3_fwd_ecc_stall = lda_ecc_stall;


//assign ld_da_sq_fwd_ecc_discard = lda_ex3_inst_vld
//                                  && lda_ecc_stall_already
//                                  && (ld_da_fwd_sq_vld || ld_da_fwd_sq_bypass);
assign ld_da_sq_fwd_ecc_discard = 1'b0;

assign lsu_idu_ex3_wait_old[LSIQENTRY-1:0]  = lda_ex3_lsid[LSIQENTRY-1:0]
                                                 & {LSIQENTRY{ld_da_sq_fwd_ecc_discard}}; 

assign lsu_idu_ex3_wait_old_gateclk_en     = ld_da_sq_fwd_ecc_discard;

//for wakeup
assign ld_da_ecc_mcic_wakup = lda_ecc_stall_already && lda_ecc_wakeup_queue[LSIQENTRY];

assign lda_ex3_ecc_wakeup[LSIQENTRY-1:0] = {LSIQENTRY{lda_ecc_stall_already}} 
                                          & lda_ecc_wakeup_queue[LSIQENTRY-1:0];

//for pw read data
//assign lda_wmb_ex3_read_data[127:0] = ld_da_settle_way
//                                    ? lda_data512_way0_corrected[255:128]  //L1D 2way->4way, LTL@20250320
//                                    : lda_data512_way0_corrected[127:0];
always @( ld_da_settle_way[1:0]
          or lda_data512_way0_corrected[511:0])
begin
case(ld_da_settle_way[1:0])
  2'b11: lda_wmb_ex3_read_data[127:0] = lda_data512_way0_corrected[511 :384];   //way3
  2'b10: lda_wmb_ex3_read_data[127:0] = lda_data512_way0_corrected[383 :256 ];  //way2
  2'b01: lda_wmb_ex3_read_data[127:0] = lda_data512_way0_corrected[255 :128 ];  //way1
  2'b00: lda_wmb_ex3_read_data[127:0] = lda_data512_way0_corrected[127 :0   ];  //way0
  default: lda_wmb_ex3_read_data[127:0] = 128'b0;
endcase
end

assign lda_wmb_ex3_two_bit_err      = ld_da_data128_ecc_err;

//for mmu error
// &Force("output","lda_mcic_ex3_data_err"); @2290
assign lda_mcic_ex3_data_err        = lda_ex3_borrow_vld
                                    && lda_borrow_mmu
                                    && lda_ecc_stall_already
                                    && lda_ecc_stall_fatal;

//for lm
assign lda_lm_ex3_ecc_err           = lda_ex3_inst_vld
                                    && ld_da_atomic
                                    && lda_ecc_stall_already
                                    && lda_ecc_stall_fatal;

//ECC info
assign ecc_info_update      = lda_ecc_stall_already
                                 && (lda_ex3_inst_vld || lda_mcic_ex3_borrow_mmu)
                                 && !lda_tcm_hit
//                                 && !ld_da_restart_vld
//                                 && !ld_da_sq_fwd_ecc_discard
//                                 && !rtu_lsu_flush_fe
                              || lda_ex3_borrow_vld
                                 && ld_da_data_ecc_vld
                                 && (lda_borrow_wmb || ld_da_borrow_vb || ld_da_borrow_sndb);

//assign ecc_info_way_compare = lda_ecc_stall_data
//                              ? !ld_da_hit_way0
//                              : lda_ecc_stall_tag_way;
assign ecc_info_way_compare = lda_ecc_stall_data
                              ? ld_da_hit_way
                              : lda_ecc_stall_tag_way;
always @( ecc_info_way_compare[3:0])
begin
casez(ecc_info_way_compare[3:0])
  4'b1???: ecc_info_way_compare_2bit[1:0] = 2'b11;  //way3
  4'b01??: ecc_info_way_compare_2bit[1:0] = 2'b10;  //way2
  4'b001?: ecc_info_way_compare_2bit[1:0] = 2'b01;  //way1
  4'b0001: ecc_info_way_compare_2bit[1:0] = 2'b00;  //way0
  default: ecc_info_way_compare_2bit[1:0] = 2'b00;
endcase
end

//assign tag_ecc_addr[`WK_PA_WIDTH-1:0]  = lda_ecc_stall_tag_way
//                                         ? {lda_tag_corrected_f[52:28],lda_addr0[14:0]}
//                                         : {lda_tag_corrected_f[25:1],lda_addr0[14:0]};
always @(*)
begin
casez(lda_ecc_stall_tag_way[3:0])
  4'b1???: tag_ecc_addr[`WK_PA_WIDTH-1:0] = {lda_tag_corrected_f[`WK_LS_DCACHE_SINGLE_TAG_WIDTH+`WK_LS_DCACHE_LDTAG_TRIPLE_BF_ECC_LENGTH-1:`WK_LS_DCACHE_LDTAG_TRIPLE_BF_ECC_LENGTH],lda_addr0[13:0]};  //way3
  4'b01??: tag_ecc_addr[`WK_PA_WIDTH-1:0] = {lda_tag_corrected_f[`WK_LS_DCACHE_SINGLE_TAG_WIDTH+`WK_LS_DCACHE_LDTAG_DOUBLE_BF_ECC_LENGTH-1:`WK_LS_DCACHE_LDTAG_DOUBLE_BF_ECC_LENGTH],lda_addr0[13:0]};  //way2
  4'b001?: tag_ecc_addr[`WK_PA_WIDTH-1:0] = {lda_tag_corrected_f[`WK_LS_DCACHE_SINGLE_TAG_WIDTH+`WK_LS_DCACHE_LDTAG_BF_ECC_LENGTH-1:`WK_LS_DCACHE_LDTAG_BF_ECC_LENGTH],lda_addr0[13:0]};  //way1
  4'b0001: tag_ecc_addr[`WK_PA_WIDTH-1:0] = {lda_tag_corrected_f[`WK_LS_DCACHE_SINGLE_TAG_WIDTH-1:0],lda_addr0[13:0]};  //way0
  default: tag_ecc_addr[`WK_PA_WIDTH-1:0] = {`WK_PA_WIDTH{1'b0}};
endcase
end

assign ecc_info_index[16:0] = (lda_ex3_borrow_vld && !lda_borrow_mmu)
                              ? {lda_addr0[16:6],ld_da_borrow_idx_5to4[1:0],4'b0}
                              : {lda_addr0[16:6],ld_da_hit_way_2bit,4'b0};  //{lda_addr0[16:5],!ld_da_hit_way0,4'b0}, L1D 2way->4way, LTL@20250320
assign ecc_info_way[1:0]    = lda_ex3_borrow_vld && !lda_borrow_mmu
                              ? ld_da_borrow_idx_5to4[1:0]    //{1'b0,ld_da_borrow_idx_5to4[0]}
                              : ecc_info_way_compare_2bit;    //{1'b0,ecc_info_way_compare}

assign ecc_info_ramid[2:0]  = lda_ecc_stall_already && !lda_ecc_stall_data
                              ? 3'b010 
                              : 3'b011; 
assign ecc_info_fatal       = lda_ex3_borrow_vld && !lda_borrow_mmu
                              ? lda_ecc_fatal
                              : lda_ecc_stall_fatal;
assign ecc_pa[`WK_PA_WIDTH-1:0] = (lda_ex3_borrow_vld && !lda_borrow_mmu || lda_ecc_stall_data)
                                  ? lda_addr0[`WK_PA_WIDTH-1:0]
                                  : tag_ecc_addr[`WK_PA_WIDTH-1:0];

//interface
assign lda_ecc_ex3_info_update_gate = lda_ecc_stall_already
                                       && !lda_tcm_hit
                                    || lda_ex3_borrow_vld
                                       && (lda_borrow_wmb || ld_da_borrow_vb || ld_da_borrow_sndb);
assign lda_ecc_ex3_info_update      = ecc_info_update;
assign lda_ecc_ex3_info[22:0]       = {ecc_info_fatal,ecc_info_ramid[2:0],ecc_info_way[1:0],ecc_info_index[16:0]};
assign lda_ecc_ex3_pa[`WK_PA_WIDTH-1:0] = ecc_pa[`WK_PA_WIDTH-1:0];

//assign ld_da_ecc_async_expt_vld   = lda_ex3_borrow_vld
//                                    && ecc_info_fatal;

//ld pipe inj_cmplt
// &Force("output","lsu_ld_tag_inj_cmplt"); @2357
// &Force("output","lsu_ld_data_inj_cmplt"); @2358
assign lsu_ld_tag_inj_cmplt  =  (lda_ecc_stall_already
                                    && ~lda_ecc_stall_data
                                    && (lda_ex3_inst_vld || lda_mcic_ex3_borrow_mmu))
                                 && lda_tag_inj_vld;

assign lsu_ld_data_inj_cmplt = (lda_ecc_stall_already
                                       && lda_ecc_stall_data
                                       && (lda_ex3_inst_vld || lda_mcic_ex3_borrow_mmu)
                                    || lda_ex3_borrow_vld
                                       && (lda_borrow_wmb || ld_da_borrow_vb || ld_da_borrow_sndb)) 
                               && lda_data_inj_vld;

//to avoid st tag inj simultaneously,use ld inj to mask
assign lda_lsda_ex3_tag_inj_mask = (lda_ex3_inst_vld || lda_mcic_ex3_borrow_mmu)
                               && lda_tag_inj_vld;


// &Force("output","lda_mcic_ex3_data_err"); @2377
//==========================================================
//        Generage interface to lq
//==========================================================
//to reduce spec fail, when ld_da restart, pop lq entry
assign ld_da_lq_pop_vld = lda_ex3_inst_vld
                          && ld_da_restart_no_cache;

assign lda_ex3_lq_entry_pop[LQENTRY-1:0] = {LQENTRY{ld_da_lq_pop_vld}} & ld_da_lq_entry[LQENTRY-1:0];
//==========================================================
//        Generage interface to cache buffer
//==========================================================
//assign ld_da_cb_data[127:0] = {128{ld_da_hit_low_region}}  & lda_data512_way0[127:0]
//                              | {128{ld_da_hit_high_region}}  & lda_data512_way0[255:128];
assign ld_da_cb_data_vld    = lda_ex3_inst_vld
                              &&  ld_da_ld_inst
                              &&  ld_da_cb_addr_create 
                              &&  lda_ex3_dcache_hit
                              &&  !ld_da_expt_vld_cancel // Risc-V Debug zdb
                              &&  !ld_da_restart_no_cache 
                              &&  !rtu_lsu_flush_fe 
//                              &&  !(ld_da_ecc_data_req_mask || lda_ecc_stall_already)
                              &&  !ld_da_fwd_vld; 
 
assign ld_da_cb_ld_inst_vld = lda_ex3_inst_vld
                              &&  ld_da_ld_inst
                              &&  ld_da_cb_addr_create;

assign ld_da_cb_ecc_cancel  = ld_da_ecc_data_req_mask || lda_ecc_stall_already;
//==========================================================
//        Generage interface to prefetch buffer
//==========================================================
// &Force("output","lda_pfu_ex3_pf_inst_vld"); @2425
assign lda_pfu_ex3_pf_inst_vld      = lda_ex3_inst_vld
                                    &&  ld_da_pf_inst
                                    &&  !lda_ecc_stall_already
                                    &&  !ld_da_already_da
                                    &&  !ld_da_expt_ori;

assign ld_da_boundary_cross_2k    = lda_pfu_ex3_va[11]
                                    !=  lda_addr0[11];
//if cache miss and not hit idx, then it can create pmb
assign lda_pfu_ex3_awk_vld          = lda_ex3_inst_vld
                                    &&  ld_da_pf_inst
                                    &&  !ld_da_expt_ori
                                    &&  (lda_rb_ex3_create_vld || ld_da_split_miss_ff)
                                    &&  !ld_da_data_vld
                                    &&  !ld_da_boundary_cross_2k;//cross 4k condition will get wrong ppn

assign lda_pfu_ex3_awk_dp_vld       = lda_ex3_inst_vld
                                    &&  ld_da_pf_inst
                                    &&  !ld_da_expt_ori
                                    &&  !ld_da_data_vld
                                    &&  !ld_da_boundary_cross_2k;//cross 4k condition will get wrong ppn

//for evict count
assign lda_pfu_ex3_eviwk_cnt_vld      = lda_pfu_ex3_pf_inst_vld;

//==========================================================
//        Generage interface to WB stage signal
//==========================================================
//------------------write back cmplt part request-----------
// assign ld_da_inst_cmplt    = ld_da_expt_vld
//                              || (ld_da_vector_nop || ld_da_expt_ori)
//                                  &&  !(ld_da_secd
//                                        && lda_ex3_inst_fof)
//                              ||  ld_da_ld_inst
//                                  &&  !lda_ex3_page_so
//                                  &&  !lda_ex3_inst_fof
//                              ||  lda_ex3_inst_fof
//                                  &&  ld_da_data_vld
//                                  &&  !ld_da_secd
//                              ||  ld_da_ldamo_inst
//                                  &&  lda_tcm_hit
//                              ||  ld_da_lr_inst
//                                  &&  ld_da_data_vld;
//==========================================================
//                  Risc-V Debug zdb Begin (replace)
//==========================================================
assign ld_da_inst_cmplt    = ld_da_expt_vld_cancel
                             || (ld_da_vector_nop || ld_da_expt_ori_cancel)
                                 &&  !(ld_da_secd
                                       && lda_ex3_inst_fof)
                             ||  ld_da_ld_inst
                                 &&  !lda_ex3_page_so
                                 &&  !lda_ex3_inst_fof
                                 &&  !ld_da_rb_data_check // Risc-V Debug zdb
                             ||  lda_ex3_inst_fof
                                 &&  ld_da_data_vld
                                 &&  !ld_da_secd
                             ||  ld_da_ldamo_inst
                                 &&  lda_tcm_hit
                             ||  ld_da_lr_inst
                                 &&  ld_da_data_vld
                                 &&  !ld_da_rb_data_check; // Risc-V Debug zdb
//==========================================================
//                  Risc-V Debug zdb End   (replace)
//========================================================== 

assign lda_lwb_ex3_cmplt_req     = lda_ex3_inst_vld
                                &&  !ld_da_ecc_data_req_mask
                                &&  !ld_da_sq_fwd_ecc_discard
                                &&  !ld_da_restart_vld
                                &&  !ld_da_boundary_first
                                &&  ld_da_inst_cmplt;

assign lda_lwb_ex3_cmplt_req_gate = lda_ex3_inst_vld
                                 &&  !ld_da_boundary_first
                                 &&  ld_da_inst_cmplt;
//------------------write back data part request------------
assign ld_da_wb_data_req_mask = ld_da_other_discard_sq_req
                                ||  ld_da_fwd_sq_multi_req
                                ||  ld_da_data_discard_sq_req
                                ||  ld_da_discard_wmb_req
                                ||  lda_ex3_us_discard
                                ||  ld_da_wait_fence_req;

assign lda_lwb_ex3_data_req      = lda_ex3_inst_vld
                                &&  (ld_da_ld_inst & !ld_da_rb_data_check    // Risc-V Debug zdb
                                     || ld_da_lr_inst & !ld_da_rb_data_check // Risc-V Debug zdb
                                     || ld_da_ldamo_inst 
                                        && (ld_da_ecc_stall_tag_fatal
                                            ||  lda_tcm_hit
                                            ||  ld_da_vector_nop))
                                &&  (!ld_da_expt_vld_cancel // Risc-V Debug zdb
                                        &&  lda_rb_ex3_data_vld
                                     || ld_da_ecc_stall_tag_fatal) 
                                &&  !ld_da_ecc_data_req_mask
                                &&  !ld_da_sq_fwd_ecc_discard
                                &&  !ld_da_wb_data_req_mask
                                &&  !lda_ex3_boundary_after_mask
                                &&  !(rtu_ck_flush && rtu_ck_flush_iid_older_than_ex3_iid); //flush younger data_req, ck_flush@LTL

assign lda_lwb_ex3_data_req_dp   = lda_ex3_inst_vld
                                &&  (ld_da_ld_inst 
                                     || ld_da_lr_inst
                                     || ld_da_ldamo_inst 
                                        && (ld_da_ecc_stall_tag_fatal
                                            ||  lda_tcm_hit
                                            ||  ld_da_vector_nop))
                                &&  (!ld_da_expt_vld_cancel // Risc-V Debug zdb
                                        &&  lda_rb_ex3_data_vld
                                     || ld_da_ecc_stall_tag_fatal) 
                                &&  !ld_da_wb_data_req_mask
                                &&  !lda_ex3_boundary_after_mask
                                &&  !(rtu_ck_flush && rtu_ck_flush_iid_older_than_ex3_iid); //flush younger data_req, ck_flush@LTL

assign lda_lwb_ex3_data_req_gateclk_en = lda_ex3_inst_vld
                                      &&  (lda_ex3_dcache_hit
                                           || lda_tcm_hit
                                           || ld_da_fwd_sq_vld
                                           || ld_da_fwd_wmb_vld
                                           || ld_da_fwd_sq_bypass
                                           || ld_da_vector_nop
                                           || ld_da_fof_not_first
                                           || ld_da_ecc_stall_tag_fatal); 

// &Force("output", "ld_da_fwd_sq_bypass_vld"); @2526
//------------------other signal---------------------------
assign lda_ex3_spec_fail     = (ld_da_spec_fail || ld_da_ecc_spec_fail)
                                &&  !ld_da_expt_vld_cancel // Risc-V Debug zdb
                                &&  !lda_ex3_split;

//assign ld_da_wb_sign[2:0]     = {3{ld_da_sign}};

//==========================================================
//        Generate interface to borrow module
//==========================================================
assign ld_da_borrow_db_vld = lda_ex3_borrow_vld
                             && (ld_da_borrow_sndb || ld_da_borrow_vb);

assign lda_vb_ex3_borrow_vb[VB_DATA_ENTRY-1:0] = {VB_DATA_ENTRY{ld_da_borrow_db_vld}}
                                                & ld_da_borrow_db[VB_DATA_ENTRY-1:0];

assign lda_snq_ex3_borrow_sndb              = lda_ex3_borrow_vld
                                            &&  ld_da_borrow_sndb;

assign lda_snq_ex3_borrow_icc               = lda_ex3_borrow_vld
                                            &&  lda_borrow_icc;
//for icc, settle way actually means high region
// &Force("bus", "cp0_lsu_dcache_read_index", 16, 0); @2553
assign ld_da_tag_read_settle[127:0] = {{114-`WK_LS_DCACHE_SINGLE_TAG_WIDTH{1'b0}},
                                       ld_da_tag_read[`WK_LS_DCACHE_SINGLE_TAG_WIDTH-1:0],
                                       cp0_lsu_dcache_read_index[13:12],
                                       11'b0,
                                       ld_da_tag_read[`WK_LS_DCACHE_LDTAG_BF_ECC_LENGTH-1]};


assign ld_da_icc_tag_read[127:0]  = ld_da_borrow_icc_ecc
                                    ? {121'b0,ld_da_tag_read[`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:`WK_LS_DCACHE_LDTAG_BF_ECC_LENGTH]} 
                                    : ld_da_tag_read_settle[127:0];

//assign icc_read_data[127:0] = ld_da_settle_way
//                              ? lda_data512_way0[255:128]
//                              : lda_data512_way0[127:0];
always @( ld_da_settle_way[1:0]
          or lda_data512_way0[511:0])
begin
case(ld_da_settle_way[1:0])
  2'b11: icc_read_data[127:0] = lda_data512_way0[511 :384];   //way3
  2'b10: icc_read_data[127:0] = lda_data512_way0[383 :256 ];  //way2
  2'b01: icc_read_data[127:0] = lda_data512_way0[255 :128 ];  //way1
  2'b00: icc_read_data[127:0] = lda_data512_way0[127 :0   ];  //way0
  default: icc_read_data[127:0] = 128'b0;
endcase
end
//assign icc_read_ecc[27:0]   = ld_da_settle_way
//                             ? {lda_dcache_data_bank7[38:32],
//                                lda_dcache_data_bank6[38:32],
//                                lda_dcache_data_bank5[38:32],
//                                lda_dcache_data_bank4[38:32]}
//                             : {lda_dcache_data_bank3[38:32],
//                                lda_dcache_data_bank2[38:32],
//                                lda_dcache_data_bank1[38:32],
//                                lda_dcache_data_bank0[38:32]};
always @( ld_da_settle_way[1:0]
          or lda_dcache_data_bank15[38:32]
          or lda_dcache_data_bank14[38:32]
          or lda_dcache_data_bank13[38:32]
          or lda_dcache_data_bank12[38:32]
          or lda_dcache_data_bank11[38:32]
          or lda_dcache_data_bank10[38:32]
          or lda_dcache_data_bank9[38:32]
          or lda_dcache_data_bank8[38:32]
          or lda_dcache_data_bank7[38:32]
          or lda_dcache_data_bank6[38:32]
          or lda_dcache_data_bank5[38:32]
          or lda_dcache_data_bank4[38:32]
          or lda_dcache_data_bank3[38:32]
          or lda_dcache_data_bank2[38:32]
          or lda_dcache_data_bank1[38:32]
          or lda_dcache_data_bank0[38:32])
begin
case(ld_da_settle_way[1:0])
  2'b11: icc_read_ecc[27:0] = { lda_dcache_data_bank15[38:32],
                                lda_dcache_data_bank14[38:32],
                                lda_dcache_data_bank13[38:32],
                                lda_dcache_data_bank12[38:32]};   //way3
  2'b10: icc_read_ecc[27:0] = { lda_dcache_data_bank11[38:32],
                                lda_dcache_data_bank10[38:32],
                                lda_dcache_data_bank9[38:32],
                                lda_dcache_data_bank8[38:32]};  //way2
  2'b01: icc_read_ecc[27:0] = { lda_dcache_data_bank7[38:32],
                                lda_dcache_data_bank6[38:32],
                                lda_dcache_data_bank5[38:32],
                                lda_dcache_data_bank4[38:32]};  //way1
  2'b00: icc_read_ecc[27:0] = { lda_dcache_data_bank3[38:32],
                                lda_dcache_data_bank2[38:32],
                                lda_dcache_data_bank1[38:32],
                                lda_dcache_data_bank0[38:32]};  //way0
  default: icc_read_ecc[27:0] = 28'b0;
endcase
end

assign ld_da_icc_data_read[127:0] = ld_da_borrow_icc_ecc
                                    ? {100'b0,icc_read_ecc[27:0]}
                                    : icc_read_data[127:0];
                                     
assign lda_icc_ex3_read_data[127:0] = ld_da_borrow_icc_tag
                                    ? ld_da_icc_tag_read[127:0]
                                    : ld_da_icc_data_read[127:0];

// &Force("output","lda_mcic_ex3_borrow_mmu"); @2594
assign lda_mcic_ex3_borrow_mmu              = lda_ex3_borrow_vld
                                            &&  lda_borrow_mmu;
assign lda_mcic_ex3_borrow_mmu_req          = lda_mcic_ex3_borrow_mmu
                                            && !ld_da_ecc_data_req_mask;

assign lda_mcic_ex3_wakeup                  = ld_da_ecc_mcic_wakup;
//rb_full_vld has exclude ld_da_hit_idx_discard_req
assign lda_mcic_ex3_rb_full                 = lda_ex3_borrow_vld
                                            &&  lda_borrow_mmu
                                            &&  ld_da_rb_full_vld;
assign ld_da_mcic_bypass_data_ori[63:0]   = ld_da_data_ff[63:0];

assign lda_mcic_ex3_bypass_data[63:0]       = lda_mcic_ex3_data_err
                                            ? 64'b0
                                            : ld_da_mcic_bypass_data_ori[63:0];
//==========================================================
//              Interface to other module
//==========================================================
//-----------interface to local monitor---------------------
assign lda_lm_ex3_no_req      = lda_ex3_inst_vld
                              &&  ld_da_lr_inst
                              &&  ld_da_data_vld
                              &&  !lda_ecc_stall;
// &Force("output", "lda_lm_ex3_lr_no_restart_dp"); @2618
assign lda_lm_ex3_lr_no_restart_dp  = lda_ex3_inst_vld
                                    &&  ld_da_lr_inst;
assign lda_lm_ex3_lr_no_restart     = lda_lm_ex3_lr_no_restart_dp
                                    &&  !ld_da_restart_vld;

assign lda_lm_ex3_vector_nop  = lda_ex3_inst_vld
                              &&  ld_da_ldamo_inst 
                              &&  ld_da_vector_nop; 
//==========================================================
//        Generate lsiq signal
//==========================================================
assign ld_da_mask_lsid[LSIQENTRY-1:0]      = {LSIQENTRY{lda_ex3_inst_vld}}
                                              & lda_ex3_lsid[LSIQENTRY-1:0];

assign ld_da_merge_mask                     = lda_merge_from_cb
                                              && lda_ex3_dcache_hit
                                              && !ld_da_fwd_vld;

// &Force("output","lda_ex3_boundary_after_mask"); @2637
assign lda_ex3_boundary_after_mask            = lda_ex3_inst_vld
                                              &&  ld_da_boundary
                                              &&  !ld_da_merge_mask
                                              &&  !ld_da_expt_vld_cancel; // Risc-V Debug zdb

assign ld_da_boundary_first                 = lda_ex3_boundary_after_mask
                                              &&  !ld_da_secd;

assign ld_da_ecc_spec_fail = (lda_ecc_stall_already || lda_tag_ecc_stall_ori) 
                             && (lda_ahead_preg_wb_vld || lda_ahead_vreg_wb_vld); 

//-----------lsiq signal----------------
assign lda_idu_ex3_already_da[LSIQENTRY-1:0] = ld_da_mask_lsid[LSIQENTRY-1:0];

assign lda_idu_ex3_rb_full[LSIQENTRY-1:0]    = {LSIQENTRY{ld_da_rb_full_vld}}
                                              & ld_da_mask_lsid[LSIQENTRY-1:0];

assign lda_idu_ex3_wait_fence[LSIQENTRY-1:0] = {LSIQENTRY{ld_da_wait_fence_vld}}
                                              & ld_da_mask_lsid[LSIQENTRY-1:0];

// &Force("output","lda_idu_ex3_pop_vld"); @2662
assign lda_idu_ex3_pop_vld                    = lda_ex3_inst_vld
                                              &&  !ld_da_boundary_first
                                              &&  !lda_ecc_stall
                                              &&  !ld_da_sq_fwd_ecc_discard
                                              &&  !ld_da_restart_vld;
assign lda_idu_ex3_pop_entry[LSIQENTRY-1:0]  = {LSIQENTRY{lda_idu_ex3_pop_vld}}
                                              & ld_da_mask_lsid[LSIQENTRY-1:0];

assign lda_idu_ex3_spec_fail[LSIQENTRY-1:0]  = {LSIQENTRY{ld_da_spec_fail
                                                          &&  ld_da_boundary_first
                                                          || ld_da_ecc_spec_fail}}
                                              & ld_da_mask_lsid[LSIQENTRY-1:0];
            
//---------boundary gateclk-------------
assign ld_da_idu_boundary_gateclk_vld       = lda_ex3_inst_vld
                                              &&  ld_da_boundary_first;

assign lda_idu_ex3_boundary_gateclk_en[LSIQENTRY-1:0]  = 
                {LSIQENTRY{ld_da_idu_boundary_gateclk_vld}}
                & ld_da_mask_lsid[LSIQENTRY-1:0];
//-----------imme wakeup----------------
assign ld_da_idu_secd_vld                   = ld_da_boundary_first
                                              &&  !lda_ecc_stall
                                              &&  !ld_da_sq_fwd_ecc_discard
                                              &&  !ld_da_restart_vld;

assign lda_idu_ex3_secd[LSIQENTRY-1:0]       = {LSIQENTRY{ld_da_idu_secd_vld}}
                                              & ld_da_mask_lsid[LSIQENTRY-1:0];

assign lda_idu_ex3_us_restart[LSIQENTRY-1:0] = {LSIQENTRY{ld_da_us_discard_req}}
                                              & ld_da_mask_lsid[LSIQENTRY-1:0];
//==========================================================
//        Generate interface to rtu
//==========================================================
assign lsu_rtu_ex3_ssf_vld = lda_ex3_inst_vld
                                              &&  !ld_da_expt_vld_cancel // Risc-V Debug zdb
                                              &&  lda_ex3_split
                                              &&  (ld_da_spec_fail || ld_da_ecc_spec_fail);
assign lsu_rtu_ex3_ssf_iid[IID_WIDTH-1:0]  = lda_ex3_iid[IID_WIDTH-1:0];

//==========================================================
//        pipe3 data wb
//==========================================================
assign lda_idu_ex3_fwd_preg_vld        = lda_ahead_preg_wb_vld
                                              && !ld_da_expt_access_fault_mmu;
assign lda_idu_ex3_fwd_preg[PREG-1:0]       = lda_ex3_preg[PREG-1:0];
assign lda_idu_ex3_fwd_preg_data[63:0] = ld_da_preg_data_sign_extend[63:0];
assign lda_idu_ex3_fwd_vreg_vld        = lda_ahead_vreg_wb_vld
                                              && !ld_da_expt_access_fault_mmu;
//assign lda_idu_ex3_fwd_vreg[VREG:0]       = {1'b0,lda_ex3_vreg[VREG-1:0]};

//assign lda_idu_ex3_fwd_vreg_fr_data[63:0]  = ld_da_vreg_data_sign_extend[63:0];
assign lda_idu_ex3_fwd_vreg[VREG:0]        = '0;
assign lda_idu_ex3_fwd_vreg_fr_data[63:0]  = 64'b0;
assign lda_idu_ex3_fwd_vreg_vr0_data[63:0] = 256'b0;
assign lda_idu_ex3_fwd_vreg_vr1_data[63:0] = 256'b0;

//==========================================================
//                Flop for ld_da
//==========================================================
assign ld_da_ff_clk_en  = lda_ex3_inst_vld
                          && (cp0_yy_dcache_pref_en || cp0_lsu_l2_pref_en);
// &Instance("gated_clk_cell", "x_lsu_ld_da_ff_gated_clk"); @2729
gated_clk_cell  x_lsu_ld_da_ff_gated_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (ld_da_ff_clk      ),
  .external_en        (1'b0              ),
  .local_en           (ld_da_ff_clk_en   ),
  .module_en          (cp0_lsu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect(.clk_in        (forever_cpuclk     ), @2730
//          .external_en   (1'b0               ), @2731
//          .module_en     (cp0_lsu_icg_en     ), @2732
//          .local_en      (ld_da_ff_clk_en    ), @2733
//          .clk_out       (ld_da_ff_clk       )); @2734

always @(posedge ld_da_ff_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    lda_pfu_ex3_ppn_ff[`WK_PA_WIDTH-13:0]  <=  {`WK_PA_WIDTH-12{1'b0}};
    lda_pfu_ex3_page_sec_ff             <=  1'b0;
    lda_pfu_ex3_page_share_ff           <=  1'b0;
  end
  else if(lda_ex3_inst_vld)
  begin
    lda_pfu_ex3_ppn_ff[`WK_PA_WIDTH-13:0]  <=  lda_addr0[`WK_PA_WIDTH-1:12];
    lda_pfu_ex3_page_sec_ff             <=  lda_ex3_page_sec;
    lda_pfu_ex3_page_share_ff           <=  lda_ex3_page_share;
  end
end

//for preload
//when split load cache miss,record
assign ld_da_split_miss = lda_ex3_inst_vld
                          && ld_da_ld_inst
                          && lda_ex3_page_ca
                          && cp0_lsu_dcache_en
                          && lda_ex3_split
                          && !ld_da_secd
                          && !ld_da_expt_vld_cancel // Risc-V Debug zdb
                          && lda_rb_ex3_create_vld
                          && !ld_da_data_vld;

assign ld_da_split_last = lda_ex3_inst_vld
                          && ld_da_ld_inst
                          && !lda_ex3_split;

always @(posedge ld_da_ff_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    ld_da_split_miss_ff           <=  1'b0;
  else if(ld_da_split_miss)
    ld_da_split_miss_ff           <=  1'b1;
  else if(ld_da_split_last)
    ld_da_split_miss_ff           <=  1'b0;
end
//==========================================================
//        interface for spec_fail prediction
//==========================================================
assign ld_da_no_spec_target = (ld_da_no_spec[1:0] == 2'b01);
assign ld_da_spec           = (ld_da_no_spec[1:0] == 2'b00);
assign ld_da_no_spec_pair   = ld_da_no_spec[1];

assign ld_da_spec_chk_req  = lda_ex3_inst_vld
                             && ld_da_ld_inst
                             && cp0_lsu_nsfe
                             && ld_da_no_spec_exist
                             && !lda_ex3_page_so 
                             && !ld_da_expt_vld_except_access_err 
                             && !ld_da_restart_vld; 

assign ld_da_no_spec_miss = lda_ex3_inst_vld
                            && cp0_lsu_nsfe
                            && !ld_da_atomic
                            && ld_da_spec_fail; 
//------------ sf interface ------------
//for target
assign lda_sf_ex3_no_spec_miss              = ld_da_no_spec_miss
                                            && !ld_da_restart_vld;
assign lda_sf_ex3_no_spec_miss_gate         = ld_da_no_spec_miss;
assign lda0_sf_ex3_iid[IID_WIDTH-1:0]                  = lda_ex3_iid[IID_WIDTH-1:0];
assign lda_sf_ex3_addr_tto4[`WK_PA_WIDTH-5:0]  = lda_addr0[`WK_PA_WIDTH-1:4];
assign lda_sf_ex3_bytes_vld[15:0]           = lda_ex3_bytes_vld[15:0];

//for other
assign lda_sf_ex3_spec_chk_req = ld_da_spec_chk_req;

//------------ wb interface ------------
//for target
assign ld_da_target_no_spec_miss    = ld_da_no_spec_miss
                                      && !ld_da_no_spec_target;
assign ld_da_target_no_spec_hit     = lda_ex3_inst_vld
                                      && cp0_lsu_nsfe
                                      && !ld_da_spec_fail
                                      && ld_da_no_spec_target;
assign ld_da_target_no_spec_mispred = lda_ex3_inst_vld
                                      && cp0_lsu_nsfe
                                      && ld_da_spec_fail
                                      && ld_da_no_spec_target;

//for pair
assign ld_da_pair_no_spec_miss      = lda_ex3_inst_vld
                                      && cp0_lsu_nsfe
                                      && ld_da_spec
                                      && sf_lda_spec_mark;
assign ld_da_pair_no_spec_mispred   = lda_ex3_inst_vld
                                      && cp0_lsu_nsfe
                                      && ld_da_no_spec_pair
                                      && !ld_da_no_spec_exist;

assign lda_lwb_ex3_no_spec_miss     = ld_da_target_no_spec_miss || ld_da_pair_no_spec_miss;
assign lda_lwb_ex3_no_spec_hit      = ld_da_target_no_spec_hit;
assign lda_lwb_ex3_no_spec_mispred  = ld_da_target_no_spec_mispred || ld_da_pair_no_spec_mispred;
assign lda_lwb_ex3_no_spec_target   = ld_da_no_spec_target || ld_da_target_no_spec_miss;

//==========================================================
//        interface to hpcp
//==========================================================
// &Force("output","lda_rb_ex3_merge_vld"); @2839
assign lsu_hpcp_ld_cache_access = lda_ex3_inst_vld
                                  &&  ld_da_ld_inst
                                  &&  lda_ex3_page_ca
                                  &&  cp0_lsu_dcache_en
                                  &&  !ld_da_already_da;
assign lsu_hpcp_ld_cache_miss   = lda_ex3_inst_vld
                                  &&  ld_da_ld_inst
                                  &&  lda_ex3_page_ca
                                  &&  cp0_lsu_dcache_en
                                  &&  !ld_da_data_vld
                                  &&  (lda_rb_ex3_create_vld
                                          &&  !rb_lda_ex3_full
                                              || lda_rb_ex3_merge_vld);
                                          //     || ld_da_discard_from_lfb_req
                                          // && ld_hit_prefetch);
assign lsu_hpcp_ld_discard_sq    = lda_ex3_inst_vld
                                   &&  (ld_da_other_discard_sq_req
                                        || ld_da_fwd_sq_multi_req)
                                   &&  !ld_da_already_da;

assign lsu_hpcp_ld_data_discard  = lda_ex3_inst_vld
                                   &&  ld_da_data_discard_sq_req
                                   &&  !ld_da_already_da;

assign lsu_hpcp_ld_unalign_inst  = lda_ex3_inst_vld
                                   &&  !ld_da_already_da
                                   &&  ld_da_secd;

assign lda_ex2_ecc_stall         = lda_ecc_stall;
// &Force("nonport","ld_da_already_da"); @2868
// &ModuleEnd; @2870

//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
assign ld_da_expt_ori_cancel        = ld_da_expt_ori
                                    | dtu_lsu_addr_halt_info[0];

assign ld_da_expt_vld_cancel        = ld_da_expt_vld
                                    | dtu_lsu_addr_halt_info[0];                  

assign lda_lwb_ex3_expt_vld_cancel  = lda_lwb_ex3_expt_vld
                                    | dtu_lsu_addr_halt_info[0];

assign ld_da_rb_data_check = (lda_ex3_inst_vld
                             & ~lda_ex3_inst_vls
                             | ld_da_lr_inst)
                             & ~ld_da_boundary_first
                             & ~dtu_lsu_addr_halt_info[0]
                             & ~(lda_ecc_stall_already
                                 & lda_ecc_stall_fatal
                                 & lda_ecc_stall_data)
                             & dtu_lsu_data_trig_en;

assign ld_da_halt_info_am[`TDT_MP_HINFO_WIDTH-1:2]  = dtu_lsu_addr_halt_info[`TDT_MP_HINFO_WIDTH-1:2];
assign ld_da_halt_info_am[1]  = dtu_lsu_addr_halt_info[1]
                                & ~lda_lwb_ex3_vsetvl;
assign ld_da_halt_info_am[0]  = dtu_lsu_addr_halt_info[0];

assign ld_da_dtu_addr_halt_info_stall_vld             = lda_ecc_stall;
assign ld_da_idu_halt_info_update_vld[LSIQENTRY-1:0]  = {LSIQENTRY{ld_da_idu_secd_vld}}
                                                      & ld_da_mask_lsid[LSIQENTRY-1:0];
assign ld_da_idu_halt_info[`TDT_MP_HINFO_WIDTH-1:0]   = dtu_lsu_addr_halt_info[`TDT_MP_HINFO_WIDTH-1:0];
//==========================================================
//                  Risc-V Debug zdb End
//==========================================================

endmodule


