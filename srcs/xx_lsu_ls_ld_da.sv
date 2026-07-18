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
module xx_lsu_ls_ld_da #(
  parameter IID_WIDTH     = 7,
  parameter VB_DATA_ENTRY = 3,
  parameter LQ_ENTRY      = 16,
  parameter LSIQ_ENTRY    = 12,
  parameter SQ_ENTRY      = 12,
  parameter WMB_ENTRY     = 8,
  parameter VMB_ENTRY     = 8,
  parameter PC_LEN        = 15,
  parameter WK_PA_WIDTH   = 40,
  parameter PREG          = 7,
  parameter VREG          = 6
)(
// &Ports; @29
input logic  [127:0]                                        cb_ld_da_data,                      
input logic                                                 cb_ld_da_data_vld,                 
input logic                                                 cp0_lsu_data_ecc_inj,                
input logic  [38 :0]                                        cp0_lsu_data_random,                 
input logic                                                 cp0_lsu_dcache_en,                   
input logic  [16 :0]                                        cp0_lsu_dcache_read_index,           
input logic                                                 cp0_lsu_ecc_en,                      
input logic                                                 cp0_lsu_icg_en,                      
input logic                                                 cp0_lsu_l2_pref_en,                  
input logic                                                 cp0_lsu_nsfe,                        
input logic                                                 cp0_lsu_tag_ecc_inj,                 
input logic  [`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0]         cp0_lsu_tag_random0,     // 2025/12/03/ mark zhangdunbo            
input logic  [`VSTART_WIDTH-1  :0]                                        cp0_lsu_vstart,                      
input logic                                                 cp0_yy_dcache_pref_en,               
input logic                                                 cpurst_b,                            
input logic                                                 ctrl_ld_clk,                         
input logic  [38 :0]                                        dcache_lsda_ex2_data_bank0_dout,       
input logic  [38 :0]                                        dcache_lsda_ex2_data_bank1_dout,       
input logic  [38 :0]                                        dcache_lsda_ex2_data_bank2_dout,       
input logic  [38 :0]                                        dcache_lsda_ex2_data_bank3_dout,       
input logic  [38 :0]                                        dcache_lsda_ex2_data_bank4_dout,       
input logic  [38 :0]                                        dcache_lsda_ex2_data_bank5_dout,       
input logic  [38 :0]                                        dcache_lsda_ex2_data_bank6_dout,       
input logic  [38 :0]                                        dcache_lsda_ex2_data_bank7_dout,
input logic  [38 :0]                                        dcache_lsda_ex2_data_bank8_dout,       
input logic  [38 :0]                                        dcache_lsda_ex2_data_bank9_dout,       
input logic  [38 :0]                                        dcache_lsda_ex2_data_bank10_dout,       
input logic  [38 :0]                                        dcache_lsda_ex2_data_bank11_dout,       
input logic  [38 :0]                                        dcache_lsda_ex2_data_bank12_dout,       
input logic  [38 :0]                                        dcache_lsda_ex2_data_bank13_dout,       
input logic  [38 :0]                                        dcache_lsda_ex2_data_bank14_dout,       
input logic  [38 :0]                                        dcache_lsda_ex2_data_bank15_dout,       
input logic  [`WK_LS_DCACHE_LDTAG_WIDTH-1:0]                dcache_lsda_ex2_tag_dout,              
input logic                                                 forever_cpuclk,
input logic                                                 lsdc_ex2_is_load,                      
input logic  [`WK_PA_WIDTH-1:0]                            lsdc_ex2_addr0,                         
input logic                                                 lsdc_lsda_ex2_ahead_predict,                 
input logic                                                 lsdc_lsda_ex2_ahead_preg_wb_vld,             
input logic                                                 lsdc_lsda_ex2_ahead_vreg_wb_vld,             
input logic                                                 lsdc_lsda_ex2_already_da,                    
input logic                                                 lsdc_ex2_atomic,                                        
input logic  [2  :0]                                        lsdc_lsda_ex2_borrow_db,                     
input logic                                                 lsdc_lsda_ex2_borrow_icc,                    
input logic                                                 lsdc_lsda_ex2_borrow_icc_ecc,                
input logic                                                 lsdc_lsda_ex2_borrow_icc_tag,                
input logic  [1  :0]                                        lsdc_lsda_ex2_borrow_idx_5to4,               
input logic                                                 lsdc_lsda_ex2_borrow_mmu,                    
input logic                                                 lsdc_lsda_ex2_borrow_sndb,                   
input logic                                                 lsdc_lsda_ex2_borrow_vb,                     
input logic                                                 lsdc_lsda_ex2_borrow_vld,                    
input logic                                                 lsdc_lsda_ex2_borrow_wmb,                    
input logic                                                 lsdc_ex2_boundary,                      
input logic  [15 :0]                                        lsdc_ex2_bytes_vld,                  
input logic  [15 :0]                                        lsdc_ex2_bytes_vld1,                 
input logic  [15 :0]                                        lsdc_ex2_bytes_vld2,                 
input logic  [15 :0]                                        lsdc_ex2_bytes_vld3,                 
input logic                                                 lsdc_lsda_ex2_cb_addr_create,           
input logic                                                 lsdc_lsda_ex2_cb_merge_en,           
input logic  [15 :0]                                        lsdc_lsda_ex2_data_rot_sel,               
input logic                                                 lsdc_lsda_ex2_expt_vld_gate_en,           
input logic                                                 lsdc_lsda_ex2_icc_tag_vld,                
input logic                                                 lsdc_lsda_ex2_inst_vld,                   
input logic  [LQ_ENTRY-1:0]                                 lsdc_lsda_ex2_lq_entry,               
input logic                                                 lsdc_ex2_old,                
input logic                                                 lsdc_ex2_page_buf,                   
input logic                                                 lsdc_ex2_page_ca,                    
input logic                                                 lsdc_ex2_page_sec,                   
input logic                                                 lsdc_ex2_page_share,                 
input logic                                                 lsdc_ex2_page_so,                    
input logic                                                 lsdc_lsda_ex2_pf_inst,           
input logic  [`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1 :0]        lsdc_lsda_ex2_tag_read,                   
input logic                                                 lsdc_lsda_ex2_data_inj_dp,            
input logic                                                 lsdc_lsda_ex2_dcache_hit,                    
input logic                                                 lsdc_ex2_dtcm_hit,                      
input logic  [8  :0]                                        lsdc_lsda_ex2_element_cnt,                   
input logic  [1  :0]                                        lsdc_ex2_element_size,                  
input logic                                                 lsdc_lsda_ex2_expt_access_fault_extra,       
input logic                                                 lsdc_lsda_ex2_expt_access_fault_mask,        
input logic  [4  :0]                                        lsdc_lsda_ex2_expt_vec,                      
input logic                                                 lsdc_lsda_ex2_expt_vld_except_access_err,    
input logic  [15 :0]                                        lsdc_lsda_ex2_fwd_bytes_vld,                 
input logic                                                 lsdc_ex2_fwd_sq_vld,                    
input logic                                                 lsdc_ex2_fwd_wmb_vld,                   
input logic  [3  :0]                                        lsdc_ex2_get_dcache_data,               
//input logic           lsdc_ex2_hit_high_region,               
//input logic           lsdc_ex2_hit_low_region,
input logic                                                 rtu_ck_flush,
input logic  [IID_WIDTH-1  :0]                              rtu_ck_flush_iid,
input logic                                                 lsdc_ex2_hit_3_region, 
input logic                                                 lsdc_ex2_hit_2_region,
input logic                                                 lsdc_ex2_hit_1_region, 
input logic                                                 lsdc_ex2_hit_0_region,
input logic  [3  :0]                                        lsdc_ex2_hit_way,                      
input logic  [IID_WIDTH-1:0]                                lsdc_ex2_iid,                           
input logic                                                 lsdc_lsda_ex2_inst_fof,                      
input logic  [2  :0]                                        lsdc_ex2_inst_size,                     
input logic  [1  :0]                                        lsdc_ex2_inst_type,                     
input logic                                                 lsdc_lsda_ex2_inst_vfls,                     
input logic                                                 lsdc_ex2_inst_vld,                      
input logic                                                 lsdc_ex2_inst_vls,                      
input logic                                                 lsdc_ex2_itcm_hit,                      
input logic  [PC_LEN-1:0]                                   lsdc_lsda_ex2_ldfifo_pc,                     
input logic  [LSIQ_ENTRY-1:0]                               lsdc_lsda_ex2_lsid,                          
input logic                                                 lsdc_lsda_ex2_mmu_req,                       
input logic  [`WK_PA_WIDTH-1:0]                             lsdc_lsda_ex2_mt_value,                      
input logic  [1  :0]                                        lsdc_lsda_ex2_no_spec,                       
input logic                                                 lsdc_lsda_ex2_no_spec_exist,                 
input logic                                                 lsdc_pfu_info_set_vld,              
input logic  [`WK_PA_WIDTH-1:0]                             lsdc_lsda_ex2_pfu_va,                        
input logic  [PREG-1  :0]                                   lsdc_lsda_ex2_preg,                          
input logic  [3  :0]                                        lsdc_lsda_ex2_preg_sign_sel,                 
input logic  [15 :0]                                        lsdc_lsda_ex2_reg_bytes_vld,                 
input logic  [15 :0]                                        lsdc_lsda_ex2_reg_bytes_vld1,                 
input logic  [15 :0]                                        lsdc_lsda_ex2_reg_bytes_vld2,                 
input logic  [15 :0]                                        lsdc_lsda_ex2_reg_bytes_vld3,                 
input logic                                                 lsdc_lsda_ex2_inst_us,
input logic                                                 lsdc_lsda_ex2_us_discard,
input logic                                                 lsdc_ex2_secd,                          
input logic  [1  :0]                                        lsdc_lsda_ex2_settle_way,                    
input logic  [8  :0]                                        lsdc_lsda_ex2_setvl_val,                     
input logic                                                 lsdc_lsda_ex2_sign_extend,                   
input logic                                                 lsdc_lsda_ex2_spec_fail,                     
input logic  [PC_LEN-1:0]                                   lq_lsu_ex2_spec_fail_pc, // wjh@sfp
input logic                                                 lsdc_lsda_ex2_split,                         
input logic                                                 lsdc_lsda_ex2_tag_inj_dp,                    
input logic                                                 lsdc_ex2_vector_nop,                    
// input logic  [1  :0]                                        lsdc_lsda_ex2_vlmul,   
input logic  [2  :0]  lsdc_lsda_ex2_vlmul,  //pwh 1 for rvv1.0                     
input logic  [VMB_ENTRY-1:0]                                lsdc_lsda_ex2_vmb_id,                        
input logic                                                 lsdc_lsda_ex2_vmb_merge_vld,                 
input logic  [VREG-1  :0]                                   lsdc_lsda_ex2_vreg,                          
input logic                                                 lsdc_lsda_ex2_vreg_sign_sel,                 
//input logic  [1  :0]                                        lsdc_ex2_vsew,  //rvv1.0@hcl 
input logic  [1  :0]  lsdc_ex2_vmew,  //rvv1.0@hcl  
input logic  [1  :0]  lsdc_ex2_vmop,  //rvv1.0@hcl                        
input logic                                                 lsdc_lsda_ex2_wait_fence,                    
input logic                                                 ld_hit_prefetch,                     
input logic                                                 lfb_lsda_hit_idx,                   
input logic                                                 lm_lsda_hit_idx,                    
input logic                                                 lsu_special_clk,                     
input logic                                                 mmu_lsu_access_fault,               
input logic                                                 pad_yy_icg_scan_en,                  
input logic  [`WK_PA_WIDTH-1:0]                             pfu_biu_req_addr,                    
input logic                                                 rb_lsda_ex3_full,                       
input logic                                                 rb_lsda_ex3_hit_idx,                    
input logic                                                 rb_lsda_merge_fail,                 
input logic                                                 rtu_lsu_flush_fe,                    
input logic                                                 rtu_yy_xx_commit0,
input logic                                                 rtu_yy_xx_commit1,
input logic                                                 rtu_yy_xx_commit2,
input logic                                                 rtu_yy_xx_commit3,
input logic                                                 rtu_yy_xx_commit4,
input logic                                                 rtu_yy_xx_commit5,
input logic                                                 rtu_yy_xx_commit6,
input logic                                                 rtu_yy_xx_commit7,                  
input logic  [IID_WIDTH-1:0]                                rtu_yy_xx_commit0_iid, 
input logic  [IID_WIDTH-1:0]                                rtu_yy_xx_commit1_iid,               
input logic  [IID_WIDTH-1:0]                                rtu_yy_xx_commit2_iid,
input logic  [IID_WIDTH-1:0]                                rtu_yy_xx_commit3_iid, 
input logic  [IID_WIDTH-1:0]                                rtu_yy_xx_commit4_iid,               
input logic  [IID_WIDTH-1:0]                                rtu_yy_xx_commit5_iid, 
input logic  [IID_WIDTH-1:0]                                rtu_yy_xx_commit6_iid, 
input logic  [IID_WIDTH-1:0]                                rtu_yy_xx_commit7_iid,                              
input logic  [127:0]                                        std0_ex1_data_bypass,            //1->2 for 2 st data, LTL@20241114        
input logic                                                 std0_ex1_inst_vld, 
input logic  [127:0]                                        std1_ex1_data_bypass,            //1->2 for 2 st data, LTL@20241114        
input logic                                                 std1_ex1_inst_vld,                     
input logic                                                 sf_spec_mark,                        
input logic  [127:0]                                        sq_lsda_ex3_fwd_data,                   
input logic  [127:0]                                        sq_lsda_ex3_fwd_data_pe,                
input logic                                                 sq_lsda_ex2_data_discard_req,           
input logic                                                 sq_lsda_ex2_fwd_bypass_multi,           
input logic                                                 sq_lsda_ex2_fwd_bypass_req, 
input logic                                                 sq_lsda_ex2_fwd_bypass_sel,   //use  for select sd0 or sd1, LTL@20241114            
input logic  [SQ_ENTRY-1:0]                                 sq_lsda_ex2_fwd_id,                     
input logic                                                 sq_lsda_ex2_fwd_multi,                  
input logic                                                 sq_lsda_ex2_fwd_multi_mask,             
input logic                                                 sq_lsda_ex2_newest_fwd_data_vld_req,    
input logic                                                 sq_lsda_ex2_other_discard_req,          
input logic  [`WK_PA_WIDTH-1:0]                             lsda_selfda_ex3_addr,
input logic                                                 lda0_lsda_ex3_tag_inj_mask,   //tag inj mask, 3 must 2 0 and 1 1, tag can inj, LTL@20241203                           
input logic                                                 lsda_lsda_ex3_tag_inj_mask,       //st_da_ld_tag_inj_mask LTL@20241114        
input logic  [127:0]                                        wmb_lsda_fwd_data,                  
input logic                                                 wmb_lsdc_discard_req,
output logic                                                lsda_ex3_is_load,              
output logic [`WK_PA_WIDTH-1:0]                             lsda_ex3_addr,                          
output logic [1  :0]                                        lsda_ex3_addr_5to4,                                       
output logic                                                lsda_ex3_borrow_vld,                    
output logic                                                lsda_ex3_boundary_after_mask,           
output logic                                                lsda_ex3_boundary_after_mask_ff,        
output logic [15 :0]                                        lsda_ex3_bytes_vld,                     
output logic [15 :0]                                        lsda_ex3_bytes_vld1,                     
output logic [15 :0]                                        lsda_ex3_bytes_vld2,                     
output logic [15 :0]                                        lsda_ex3_bytes_vld3,                     
//output logic [127:0]  lsda_cb_data,                       
output logic                                                lsda_cb_data_vld,                   
output logic                                                lsda_cb_ecc_cancel,                 
output logic                                                lsda_cb_ld_inst_vld,                
output logic [511:0]                                        lsda_ex3_data512,  //256->512, L1D 2->4way, LTL@20250322                       
output logic [15 :0]                                        lsda_ex3_data_rot_sel,                  
output logic                                                lsda_ex3_dcache_hit,                    
output logic [22 :0]                                        lsda_ex3_ecc_info,                      
output logic                                                lsda_ex3_ecc_info_update,               
output logic                                                lsda_ex3_ecc_info_update_gate,          
output logic [`WK_PA_WIDTH-1:0]                             lsda_ex3_ecc_pa,                        
output logic [LSIQ_ENTRY-1:0]                               lsda_ex3_ecc_wakeup,                    
output logic [8  :0]                                        lsda_ex3_element_cnt,                   
output logic [1  :0]                                        lsda_ex3_element_size,                  
output logic                                                lsda_ex3_fwd_ecc_stall,                 
output logic [127:0]                                        lsda_icc_read_data,                 
output logic [LSIQ_ENTRY-1:0]                               lsda_idu_ex3_already_da,                               
output logic [LSIQ_ENTRY-1:0]                               lsda_idu_ex3_boundary_gateclk_en,       
output logic [LSIQ_ENTRY-1:0]                               lsda_idu_ex3_pop_entry,                 
output logic                                                lsda_idu_ex3_pop_vld,                   
output logic [LSIQ_ENTRY-1:0]                               lsda_idu_ex3_rb_full,                   
output logic [LSIQ_ENTRY-1:0]                               lsda_idu_ex3_secd,                      
output logic [LSIQ_ENTRY-1:0]                               lsda_idu_ex3_us_restart,
output logic [LSIQ_ENTRY-1:0]                               lsda_idu_ex3_spec_fail,                 
output logic [LSIQ_ENTRY-1:0]                               lsda_idu_ex3_wait_fence,                
output logic [`WK_PA_WIDTH-7  :0]                           lsda_ex3_idx,    //8->34  @lishuo                  
output logic [IID_WIDTH-1:0]                                lsda_ex3_iid,                           
output logic                                                lsda_ex3_inst_fof,                      
output logic [2  :0]                                        lsda_ex3_inst_size,                     
output logic                                                lsda_ex3_inst_vfls,                     
output logic                                                lsda_ex3_inst_vld,                      
output logic                                                lsda_ex3_inst_vls,                      
output logic [PC_LEN-1:0]                                   lsda_ex3_ldfifo_pc,                     
output logic                                                lsda_lfb_discard_grnt,              
output logic                                                lsda_lfb_set_wakeup_queue,          
output logic                                                lsda_lfb_set_wakeup_queue_gate,     
output logic [LSIQ_ENTRY:0]                                 lsda_lfb_wakeup_queue_next,         
output logic                                                lsda_lm_ex3_discard_grnt,               
output logic                                                lsda_lm_ex3_ecc_err,                    
output logic                                                lsda_lm_ex3_lr_no_restart,              
output logic                                                lsda_lm_ex3_lr_no_restart_dp,           
output logic                                                lsda_lm_ex3_no_req,                     
output logic                                                lsda_lm_ex3_vector_nop,                 
output logic [LQ_ENTRY-1:0]                                 lsda_ex3_lq_entry_pop,                  
output logic [LSIQ_ENTRY-1:0]                               lsda_ex3_lsid,                          
output logic                                                lsda_mcic_borrow_mmu,               
output logic                                                lsda_mcic_borrow_mmu_req,           
output logic [63 :0]                                        lsda_mcic_bypass_data,              
output logic                                                lsda_mcic_data_err,                 
output logic                                                lsda_mcic_rb_full,                  
output logic                                                lsda_mcic_wakeup,                   
output logic                                                lsda_ex3_old,                           
output logic                                                lsda_ex3_page_buf,                      
output logic                                                lsda_ex3_page_ca,                       
output logic                                                lsda_ex3_page_sec,                      
output logic                                                lsda_ex3_page_sec_ff,                   
output logic                                                lsda_ex3_page_share,                    
output logic                                                lsda_ex3_page_share_ff,                 
output logic                                                lsda_ex3_page_so,                       
output logic                                                lsda_pfu_ex3_awk_dp_vld,                
output logic                                                lsda_pfu_ex3_awk_vld,                   
output logic                                                lsda_pfu_ex3_biu_req_hit_idx,           
output logic                                                lsda_pfu_ex3_eviwk_cnt_vld,             
output logic                                                lsda_pfu_ex3_pf_inst_vld,               
output logic [`WK_PA_WIDTH-1:0]                             lsda_pfu_ex3_va,                        
output logic [`WK_PA_WIDTH-1:0]                             lsda_pfu_ex3_ppfu_va,                       
output logic [`WK_PA_WIDTH-13:0]                            lsda_pfu_ex3_ppn_ff,                        
output logic [PREG-1  :0]                                   lsda_ex3_preg,                          
output logic [3  :0]                                        lsda_ex3_preg_sign_sel,                 
output logic                                                lsda_rb_ex3_atomic,                     
output logic                                                lsda_rb_ex3_cmit,                       
output logic                                                lsda_rb_ex3_cmplt_success,              
output logic                                                lsda_rb_ex3_create_dp_vld,              
output logic                                                lsda_rb_ex3_create_gateclk_en,          
output logic                                                lsda_rb_ex3_create_judge_vld,           
output logic                                                lsda_rb_ex3_create_lfb,                 
output logic                                                lsda_rb_ex3_create_vld,                 
output logic [127:0]                                        lsda_rb_ex3_data_ori,                   
output logic [127:0]                                        lsda_rb_ex3_data_ori1,                   
output logic [127:0]                                        lsda_rb_ex3_data_ori2,                   
output logic [127:0]                                        lsda_rb_ex3_data_ori3,                   
output logic                                                lsda_rb_ex3_data_vld,                   
output logic                                                lsda_rb_ex3_dest_vld,                   
output logic                                                lsda_rb_ex3_discard_grnt,               
output logic                                                lsda_rb_ex3_expt_vld,                   
output logic                                                lsda_ex3_rb_full_gateclk_en,            
output logic                                                lsda_rb_ex3_ldamo,                      
output logic                                                lsda_rb_ex3_merge_dp_vld,               
output logic                                                lsda_rb_ex3_merge_expt_vld,             
output logic                                                lsda_rb_ex3_merge_gateclk_en,           
output logic                                                lsda_rb_ex3_merge_vld,                  
output logic [15 :0]                                        lsda_ex3_reg_bytes_vld,                 
output logic [15 :0]                                        lsda_ex3_reg_bytes_vld1,                 
output logic [15 :0]                                        lsda_ex3_reg_bytes_vld2,                 
output logic [15 :0]                                        lsda_ex3_reg_bytes_vld3,                 
output logic                                                lsda_ex3_inst_us,
output logic [8  :0]                                        lsda_ex3_setvl_val,                     
output logic [`WK_PA_WIDTH-5 :0]                            lsda_sf_ex3_addr_tto4,                  
output logic [15 :0]                                        lsda_sf_ex3_bytes_vld,                  
output logic [IID_WIDTH-1:0]                                lsda_sf_ex3_iid,                        
output logic                                                lsda_sf_ex3_no_spec_miss,               
output logic                                                lsda_sf_ex3_no_spec_miss_gate,          
output logic                                                lsda_sf_ex3_spec_chk_req,               
output logic [PC_LEN-1:0]                                   lsda_sfp_ex3_src_pc, // wjh@sfp
output logic                                                lsda_ex3_sign_extend,                   
output logic                                                lsda_snq_ex3_borrow_icc,                
output logic                                                lsda_snq_ex3_borrow_sndb,               
output logic                                                lsda_ex3_special_gateclk_en,            
output logic                                                lsda_ex3_split,                         
output logic                                                lsda_sq_ex3_data_discard_vld,           
output logic [SQ_ENTRY-1:0]                                 lsda_sq_ex3_fwd_id,                     
output logic                                                lsda_sq_ex3_fwd_multi_vld,              
output logic                                                lsda_sq_ex3_global_discard_vld,         
output logic                                                selfda_lsda_ex3_hit_idx,                 
output logic                                                lsda_ex3_tag_inj_mask,               
output logic [2  :0]                                        lsda_vb_ex3_borrow_vb,                  
output logic                                                lsda_vb_ex3_snq_data_reissue,           
output logic                                                lsda_vb_ex3_snq_ecc_err,                
// output logic [1  :0]                                        lsda_ex3_vlmul,       
output logic [2  :0]  lsda_ex3_vlmul,  //pwh 2 for rvv1.0                 
output logic [VMB_ENTRY-1:0]                                lsda_ex3_vmb_id,                        
output logic                                                lsda_ex3_vmb_merge_vld,                 
output logic [VREG-1  :0]                                   lsda_ex3_vreg,                          
output logic                                                lsda_ex3_vreg_sign_sel,                 
//output logic [1  :0]                                        lsda_ex3_vsew,  //rvv1.0@hcl  
output logic [1  :0]  lsda_ex3_vmew,  //rvv1.0@hcl
output logic [1  :0]  lsda_ex3_vmop,  //rvv1.0@hcl                      
output logic                                                lsda_ex3_wait_fence_gateclk_en,         
output logic                                                lsda_lswb_ex3_cmplt_req,                  
output logic                                                lsda_lswb_ex3_cmplt_req_gate,             
output logic [127:0]                                        lsda_lswb_ex3_data,                       
output logic [127:0]                                        lsda_lswb_ex3_data1,                       
output logic [127:0]                                        lsda_lswb_ex3_data2,                       
output logic [127:0]                                        lsda_lswb_ex3_data3,                       
output logic                                                lsda_lswb_ex3_data_req,                   
output logic                                                lsda_lswb_ex3_data_req_dp,                
output logic                                                lsda_lswb_ex3_data_req_gateclk_en,        
output logic [4  :0]                                        lsda_lswb_ex3_expt_vec,                   
output logic                                                lsda_ex3_expt_vld,                   
output logic                                                lsda_lswb_ex3_inst_vls,                   
output logic [`WK_PA_WIDTH-1:0]                             lsda_lswb_ex3_mt_value,                   
output logic                                                lsda_lswb_ex3_no_spec_hit,                
output logic                                                lsda_lswb_ex3_no_spec_mispred,            
output logic                                                lsda_lswb_ex3_no_spec_miss,               
output logic                                                lsda_lswb_ex3_no_spec_target,             
output logic                                                lsda_lswb_ex3_spec_fail,                  
output logic [14 :0]                                        lsda_lswb_ex3_vreg_sign_sel,              
output logic                                                lsda_lswb_ex3_vsetvl,                     
output logic                                                lsda_lswb_ex3_vstart_vld,                 
output logic                                                lsda_wmb_data_reissue,              
output logic                                                lsda_wmb_discard_vld,               
output logic [127:0]                                        lsda_wmb_read_data,                 
output logic                                                lsda_wmb_two_bit_err,               
output logic                                                lsu_hpcp_ls_cache_access,            
output logic                                                lsu_hpcp_ls_cache_miss,              
output logic                                                lsu_hpcp_ld_data_discard,            
output logic                                                lsu_hpcp_ld_discard_sq,              
output logic                                                lsu_hpcp_ls_unalign_inst,            
output logic [PREG-1  :0]                                   lsu_idu_ex3_fwd_preg,           
output logic [63 :0]                                        lsu_idu_ex3_fwd_preg_data,      
output logic                                                lsu_idu_ex3_fwd_preg_vld,       
output logic [VREG  :0]                                     lsu_idu_ex3_fwd_vreg,           
output logic [63 :0]                                        lsu_idu_ex3_fwd_vreg_fr_data,   
output logic                                                lsu_idu_ex3_fwd_vreg_vld,       
output logic [255 :0]                                        lsu_idu_ex3_fwd_vreg_vr0_data,  
output logic [255 :0]                                        lsu_idu_ex3_fwd_vreg_vr1_data,  
output logic [LSIQ_ENTRY-1:0]                               lsda_idu_ex3_wait_old,              
output logic                                                lsda_idu_ex3_wait_old_gateclk_en,   
output logic                                                lsu_lsda_data_inj_cmplt,               
output logic                                                lsu_lsda_tag_inj_cmplt,                
output logic [IID_WIDTH-1:0]                                lsu_rtu_ex3_ssf_iid, 
output logic                                                lsu_rtu_ex3_ssf_vld,
output logic                                                ld_da_ecc_stall,
output logic                                                lsda_pfu_ld_tag_miss,
//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
input  logic                                              dtu_lsu_data_trig_en,
input  logic [`TDT_MP_HINFO_WIDTH-1:0]                    dtu_lsu_addr_halt_info,
input  logic                                              ld_dc_boundary_unmask,
output logic                                              ld_da_dtu_addr_halt_info_stall_vld,
output logic [`TDT_MP_HINFO_WIDTH-1:0]                    ld_da_halt_info_am,
output logic [`TDT_MP_HINFO_WIDTH-1:0]                    ld_da_idu_halt_info,           
output logic [LSIQ_ENTRY-1:0]                             ld_da_idu_halt_info_update_vld,
output logic                                              ld_da_rb_data_check   
//==========================================================
//                  Risc-V Debug zdb End 
//========================================================== 
);



// &Regs; @30
logic     [`WK_PA_WIDTH-1:0]                                ld_da_addr0;          
logic     [`WK_PA_WIDTH-7:0]                                ld_da_addr0_idx;      
logic                                                       ld_da_ahead_predict;  
logic                                                       ld_da_ahead_preg_wb_vld;             
logic                                                       ld_da_ahead_vreg_wb_vld;             
logic                                                       ld_da_already_da;     
logic                                                       ld_da_atomic;         
logic     [2  :0]                                           ld_da_borrow_db;      
logic                                                       ld_da_borrow_icc;     
logic                                                       ld_da_borrow_icc_ecc; 
logic                                                       ld_da_borrow_icc_tag; 
logic     [1  :0]                                           ld_da_borrow_idx_5to4;
logic                                                       ld_da_borrow_mmu;     
logic                                                       ld_da_borrow_sndb;    
logic                                                       ld_da_borrow_vb;       
logic                                                       ld_da_borrow_wmb;     
logic                                                       ld_da_boundary;           
logic     [15 :0]                                           ld_da_bytes_vld1;     
logic     [15 :0]                                           ld_da_bytes_vld2;     
logic     [15 :0]                                           ld_da_bytes_vld3;     
logic                                                       ld_da_cb_addr_create; 
logic                                                       ld_da_cb_merge_en;    
logic                                                       ld_da_data_discard_sq;
logic     [127:0]                                           ld_da_data_ff;        
logic     [127:0]                                           ld_da_data_ff1;        
logic     [127:0]                                           ld_da_data_ff2;        
logic     [127:0]                                           ld_da_data_ff3;        
logic                                                       ld_da_data_inj_vld;   
logic                                                       ld_da_data_vld_newest_fwd_sq_dup0;   
logic                                                       ld_da_data_vld_newest_fwd_sq_dup1;   
logic                                                       ld_da_data_vld_newest_fwd_sq_dup2;   
logic                                                       ld_da_data_vld_newest_fwd_sq_dup3;   
logic     [31 :0]                                           ld_da_dcache_data_ahead_bank0;       
logic     [31 :0]                                           ld_da_dcache_data_ahead_bank1;       
logic     [31 :0]                                           ld_da_dcache_data_ahead_bank2;       
logic     [31 :0]                                           ld_da_dcache_data_ahead_bank3;       
logic     [31 :0]                                           ld_da_dcache_data_ahead_bank4;       
logic     [31 :0]                                           ld_da_dcache_data_ahead_bank5;       
logic     [31 :0]                                           ld_da_dcache_data_ahead_bank6;       
logic     [31 :0]                                           ld_da_dcache_data_ahead_bank7;       
logic     [31 :0]                                           ld_da_dcache_data_ahead_bank8;       
logic     [31 :0]                                           ld_da_dcache_data_ahead_bank9;       
logic     [31 :0]                                           ld_da_dcache_data_ahead_bank10;       
logic     [31 :0]                                           ld_da_dcache_data_ahead_bank11;       
logic     [31 :0]                                           ld_da_dcache_data_ahead_bank12;       
logic     [31 :0]                                           ld_da_dcache_data_ahead_bank13;       
logic     [31 :0]                                           ld_da_dcache_data_ahead_bank14;       
logic     [31 :0]                                           ld_da_dcache_data_ahead_bank15;
logic     [38 :0]                                           ld_da_dcache_data_bank0;             
logic     [38 :0]                                           ld_da_dcache_data_bank1;             
logic     [38 :0]                                           ld_da_dcache_data_bank2;             
logic     [38 :0]                                           ld_da_dcache_data_bank3;             
logic     [38 :0]                                           ld_da_dcache_data_bank4;             
logic     [38 :0]                                           ld_da_dcache_data_bank5;             
logic     [38 :0]                                           ld_da_dcache_data_bank6;             
logic     [38 :0]                                           ld_da_dcache_data_bank7;              
logic     [38 :0]                                           ld_da_dcache_data_bank8;              
logic     [38 :0]                                           ld_da_dcache_data_bank9;              
logic     [38 :0]                                           ld_da_dcache_data_bank10;             
logic     [38 :0]                                           ld_da_dcache_data_bank11;             
logic     [38 :0]                                           ld_da_dcache_data_bank12;             
logic     [38 :0]                                           ld_da_dcache_data_bank13;             
logic     [38 :0]                                           ld_da_dcache_data_bank14;             
logic     [38 :0]                                           ld_da_dcache_data_bank15;
logic                                                       ld_da_discard_wmb;    
logic                                                       ld_da_dtcm_hit;       
logic                                                       ld_da_ecc_stall_already;             
logic                                                       ld_da_ecc_stall_cb_merge;            
logic                                                       ld_da_ecc_stall_data; 
logic                                                       ld_da_ecc_stall_fatal;
logic     [3:0]                                             ld_da_ecc_stall_tag_way;             
logic     [LSIQ_ENTRY:0]                                    ld_da_ecc_wakeup_queue;              
logic                                                       ld_da_expt_access_fault_extra;       
logic                                                       ld_da_expt_access_fault_mask;        
logic                                                       ld_da_expt_access_fault_mmu;         
logic     [4  :0]                                           ld_da_expt_vec;       
logic                                                       ld_da_expt_vld_except_access_err;    
logic                                                       ld_da_fwd_bypass_sq_multi;           
logic     [15 :0]                                           ld_da_fwd_bytes_vld;  
logic     [15 :0]                                           ld_da_fwd_bytes_vld_dup; 
logic     [127:0]                                           ld_da_fwd_data_bypass;   //result from st data 0 and 1, LTL@20241114         
logic     [127:0]                                           ld_da_fwd_data_bypass0;  //1->2 for 2 st data, LTL@20241114
logic     [127:0]                                           ld_da_fwd_data_bypass1;
logic                                                       ld_da_fwd_sq_bypass; 
logic                                                       ld_da_fwd_sq_bypass_sel;  //from sq, choose data from st data 0 or 1, LTL@20241114   
logic                                                       ld_da_fwd_sq_multi;   
logic                                                       ld_da_fwd_sq_multi_mask;             
logic                                                       ld_da_fwd_sq_vld;     
logic                                                       ld_da_fwd_wmb_vld;    
logic     [3  :0]                                           ld_da_get_dcache_data;
logic                                                       ld_da_hit_3_region;
logic                                                       ld_da_hit_3_region_dup0;          
logic                                                       ld_da_hit_3_region_dup1;          
logic                                                       ld_da_hit_3_region_dup2;          
logic                                                       ld_da_hit_3_region_dup3;          
logic                                                       ld_da_hit_2_region; 
logic                                                       ld_da_hit_2_region_dup0;           
logic                                                       ld_da_hit_2_region_dup1;           
logic                                                       ld_da_hit_2_region_dup2;           
logic                                                       ld_da_hit_2_region_dup3;
logic                                                       ld_da_hit_1_region;
logic                                                       ld_da_hit_1_region_dup0;          
logic                                                       ld_da_hit_1_region_dup1;          
logic                                                       ld_da_hit_1_region_dup2;          
logic                                                       ld_da_hit_1_region_dup3;          
logic                                                       ld_da_hit_0_region; 
logic                                                       ld_da_hit_0_region_dup0;           
logic                                                       ld_da_hit_0_region_dup1;           
logic                                                       ld_da_hit_0_region_dup2;           
logic                                                       ld_da_hit_0_region_dup3;           
logic     [3  :0]                                           ld_da_hit_way;
logic     [1  :0]                                           ld_da_hit_way_2bit;           
logic     [1  :0]                                           ld_da_inst_type;         
logic                                                       ld_da_itcm_hit;           
logic     [LQ_ENTRY-1:0]                                    ld_da_lq_entry;
logic                                                       ld_da_mmu_req;        
logic     [`WK_PA_WIDTH-1:0]                                ld_da_mt_value;       
logic     [1  :0]                                           ld_da_no_spec;        
logic                                                       ld_da_no_spec_exist;         
logic                                                       ld_da_other_discard_sq;     
logic                                                       ld_da_pf_inst;  
logic     [63 :0]                                           ld_da_preg_data_sign_extend;         
logic                                                       ld_da_secd;           
logic     [1  :0]                                           ld_da_settle_way;      
logic                                                       ld_da_spec_fail;            
logic                                                       ld_da_split_miss_ff;    
logic     [`WK_LS_DCACHE_LDTAG_QUADRUPLE_BF_ECC_LENGTH-1:0] ld_da_tag_corrected_f;//53->107, L1D 2->4way, LTL@20250322
logic                                                       ld_da_tag_inj_vld;    
logic     [`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1 :0]           ld_da_tag_read;       
logic                                                       ld_da_vector_nop;            
logic                                                       ld_da_wait_fence;     
logic     [`WK_PA_WIDTH-1:0]                                ld_da_wb_mt_value_ori;            

// &Wires; @31       
logic    [38 :0]                                            data_bank0_bf_ecc;    
logic    [31 :0]                                            data_bank0_corrected; 
logic                                                       data_bank0_ecc_err;   
logic                                                       data_bank0_ecc_vld;   
logic                                                       data_bank0_ham_error; 
logic                                                       data_bank0_parity_error;             
logic    [38 :0]                                            data_bank1_bf_ecc;    
logic    [31 :0]                                            data_bank1_corrected; 
logic                                                       data_bank1_ecc_err;   
logic                                                       data_bank1_ecc_vld;   
logic                                                       data_bank1_ham_error; 
logic                                                       data_bank1_parity_error;             
logic    [38 :0]                                            data_bank2_bf_ecc;    
logic    [31 :0]                                            data_bank2_corrected; 
logic                                                       data_bank2_ecc_err;   
logic                                                       data_bank2_ecc_vld;   
logic                                                       data_bank2_ham_error; 
logic                                                       data_bank2_parity_error;             
logic    [38 :0]                                            data_bank3_bf_ecc;    
logic    [31 :0]                                            data_bank3_corrected; 
logic                                                       data_bank3_ecc_err;   
logic                                                       data_bank3_ecc_vld;   
logic                                                       data_bank3_ham_error; 
logic                                                       data_bank3_parity_error;             
logic    [38 :0]                                            data_bank4_bf_ecc;    
logic    [31 :0]                                            data_bank4_corrected; 
logic                                                       data_bank4_ecc_err;   
logic                                                       data_bank4_ecc_vld;   
logic                                                       data_bank4_ham_error; 
logic                                                       data_bank4_parity_error;             
logic    [38 :0]                                            data_bank5_bf_ecc;    
logic    [31 :0]                                            data_bank5_corrected; 
logic                                                       data_bank5_ecc_err;   
logic                                                       data_bank5_ecc_vld;   
logic                                                       data_bank5_ham_error; 
logic                                                       data_bank5_parity_error;             
logic    [38 :0]                                            data_bank6_bf_ecc;    
logic    [31 :0]                                            data_bank6_corrected; 
logic                                                       data_bank6_ecc_err;   
logic                                                       data_bank6_ecc_vld;   
logic                                                       data_bank6_ham_error; 
logic                                                       data_bank6_parity_error;             
logic    [38 :0]                                            data_bank7_bf_ecc;    
logic    [31 :0]                                            data_bank7_corrected; 
logic                                                       data_bank7_ecc_err;   
logic                                                       data_bank7_ecc_vld;   
logic                                                       data_bank7_ham_error; 
logic                                                       data_bank7_parity_error;             
logic    [38 :0]                                            data_bank8_bf_ecc;    
logic    [31 :0]                                            data_bank8_corrected; 
logic                                                       data_bank8_ecc_err;   
logic                                                       data_bank8_ecc_vld;   
logic                                                       data_bank8_ham_error; 
logic                                                       data_bank8_parity_error;             
logic    [38 :0]                                            data_bank9_bf_ecc;    
logic    [31 :0]                                            data_bank9_corrected; 
logic                                                       data_bank9_ecc_err;   
logic                                                       data_bank9_ecc_vld;   
logic                                                       data_bank9_ham_error; 
logic                                                       data_bank9_parity_error;             
logic    [38 :0]                                            data_bank10_bf_ecc;    
logic    [31 :0]                                            data_bank10_corrected; 
logic                                                       data_bank10_ecc_err;   
logic                                                       data_bank10_ecc_vld;   
logic                                                       data_bank10_ham_error; 
logic                                                       data_bank10_parity_error;             
logic    [38 :0]                                            data_bank11_bf_ecc;    
logic    [31 :0]                                            data_bank11_corrected; 
logic                                                       data_bank11_ecc_err;   
logic                                                       data_bank11_ecc_vld;   
logic                                                       data_bank11_ham_error; 
logic                                                       data_bank11_parity_error;             
logic    [38 :0]                                            data_bank12_bf_ecc;    
logic    [31 :0]                                            data_bank12_corrected; 
logic                                                       data_bank12_ecc_err;   
logic                                                       data_bank12_ecc_vld;   
logic                                                       data_bank12_ham_error; 
logic                                                       data_bank12_parity_error;             
logic    [38 :0]                                            data_bank13_bf_ecc;    
logic    [31 :0]                                            data_bank13_corrected; 
logic                                                       data_bank13_ecc_err;   
logic                                                       data_bank13_ecc_vld;   
logic                                                       data_bank13_ham_error; 
logic                                                       data_bank13_parity_error;             
logic    [38 :0]                                            data_bank14_bf_ecc;    
logic    [31 :0]                                            data_bank14_corrected; 
logic                                                       data_bank14_ecc_err;   
logic                                                       data_bank14_ecc_vld;   
logic                                                       data_bank14_ham_error; 
logic                                                       data_bank14_parity_error;             
logic    [38 :0]                                            data_bank15_bf_ecc;    
logic    [31 :0]                                            data_bank15_corrected; 
logic                                                       data_bank15_ecc_err;   
logic                                                       data_bank15_ecc_vld;   
logic                                                       data_bank15_ham_error; 
logic                                                       data_bank15_parity_error; 
logic                                                       data_3_region_ecc_err;  //double L1D 2->4way, LTL@20250322          
logic                                                       data_3_region_ecc_vld;            
logic                                                       data_2_region_ecc_err;             
logic                                                       data_2_region_ecc_vld; 
logic                                                       data_1_region_ecc_err;            
logic                                                       data_1_region_ecc_vld;            
logic                                                       data_0_region_ecc_err;             
logic                                                       data_0_region_ecc_vld;             
logic    [38 :0]                                            dcache_data_bank0;    
logic    [38 :0]                                            dcache_data_bank1;    
logic    [38 :0]                                            dcache_data_bank2;    
logic    [38 :0]                                            dcache_data_bank3;    
logic    [38 :0]                                            dcache_data_bank4;    
logic    [38 :0]                                            dcache_data_bank5;    
logic    [38 :0]                                            dcache_data_bank6;    
logic    [38 :0]                                            dcache_data_bank7;    
logic    [38 :0]                                            dcache_data_bank8;    
logic    [38 :0]                                            dcache_data_bank9;    
logic    [38 :0]                                            dcache_data_bank10;    
logic    [38 :0]                                            dcache_data_bank11;    
logic    [38 :0]                                            dcache_data_bank12;    
logic    [38 :0]                                            dcache_data_bank13;    
logic    [38 :0]                                            dcache_data_bank14;    
logic    [38 :0]                                            dcache_data_bank15;
logic    [`WK_LS_DCACHE_LDTAG_WIDTH-1:0]                    dcache_ld_tag_dout;
logic                                                       dtcm_1bit_err;        
logic    [127:0]                                            dtcm_rdata;           
logic                                                       ecc_info_fatal;       
logic    [16 :0]                                            ecc_info_index;       
logic    [2  :0]                                            ecc_info_ramid;       
logic                                                       ecc_info_update;      
logic    [1  :0]                                            ecc_info_way;         
logic    [3  :0]                                            ecc_info_way_compare; 
logic    [1  :0]                                            ecc_info_way_compare_2bit; 
logic    [`WK_PA_WIDTH-1:0]                                 ecc_pa;
logic    [127:0]                                            icc_read_data;        
logic    [27 :0]                                            icc_read_ecc;         
logic                                                       itcm_1bit_err;        
logic    [127:0]                                            itcm_rdata;
logic    [127:0]                                            ld_da_ahead_preg_data_settle;        
logic    [63 :0]                                            ld_da_ahead_preg_data_sign0;         
logic    [63 :0]                                            ld_da_ahead_preg_data_sign1;         
logic    [63 :0]                                            ld_da_ahead_preg_data_sign2;         
logic    [63 :0]                                            ld_da_ahead_preg_data_sign3;         
logic    [127:0]                                            ld_da_ahead_preg_data_unsettle;      
logic                                                       ld_da_borrow_clk;     
logic                                                       ld_da_borrow_clk_en;  
logic                                                       ld_da_borrow_db_vld;          
logic                                                       ld_da_boundary_cross_2k;             
logic    [127:0]                                            ld_da_boundary_data;  
logic                                                       ld_da_boundary_first; 
logic    [127:0]                                            ld_da_bytes_vld_ext;  
logic    [127:0]                                            ld_da_cb_bypass_data_am;             
logic    [127:0]                                            ld_da_cb_bypass_data_for_merge;    
logic                                                       ld_da_clk;            
logic                                                       ld_da_clk_en;         
logic                                                       ld_da_cmit_hit0;      
logic                                                       ld_da_cmit_hit1;      
logic                                                       ld_da_cmit_hit2;
logic                                                       ld_da_cmit_hit3;      
logic                                                       ld_da_cmit_hit4;      
logic                                                       ld_da_cmit_hit5;
logic                                                       ld_da_cmit_hit6;      
logic                                                       ld_da_cmit_hit7;          
logic    [`WK_PA_WIDTH-1:0]                                 ld_da_cmp_pfu_biu_req_addr;          
logic    [`WK_PA_WIDTH-1:0]                                 ld_da_cmp_st_da_addr; 
logic                                                       ld_da_data0_clk;      
logic                                                       ld_da_data0_clk_en;   
logic    [127:0]                                            ld_da_data128;        
logic                                                       ld_da_data128_ecc_err;
logic                                                       ld_da_data128_ecc_vld;
logic                                                       ld_da_data1_clk;      
logic                                                       ld_da_data1_clk_en;     
logic                                                       ld_da_data256_ecc_err;
logic                                                       ld_da_data256_ecc_vld;
logic    [511:0]                                            ld_da_data512_way0;   
logic    [511:0]                                            ld_da_data512_way0_aft_ecc;          
logic    [511:0]                                            ld_da_data512_way0_corrected;        
logic    [511:0]                                            ld_da_data512_way1;   
logic    [511:0]                                            ld_da_data512_way1_aft_ecc;          
logic    [511:0]                                            ld_da_data512_way1_corrected;
logic    [511:0]                                            ld_da_data512_way2;   
logic    [511:0]                                            ld_da_data512_way2_aft_ecc;          
logic    [511:0]                                            ld_da_data512_way2_corrected;        
logic    [511:0]                                            ld_da_data512_way3;   
logic    [511:0]                                            ld_da_data512_way3_aft_ecc;          
logic    [511:0]                                            ld_da_data512_way3_corrected;        
logic                                                       ld_da_data2_clk;      
logic                                                       ld_da_data2_clk_en;   
logic                                                       ld_da_data3_clk;      
logic                                                       ld_da_data3_clk_en;   
logic    [127:0]                                            ld_da_data_aft_merge; 
logic                                                       ld_da_data_delay_gate;
logic                                                       ld_da_data_delay_vld; 
logic                                                       ld_da_data_discard_sq_final;         
logic                                                       ld_da_data_discard_sq_req;           
logic                                                       ld_da_data_ecc_err;   
logic                                                       ld_da_data_ecc_stall; 
logic                                                       ld_da_data_ecc_stall_gate;           
logic                                                       ld_da_data_ecc_stall_ori;            
logic                                                       ld_da_data_ecc_vld;   
logic                                                       ld_da_data_ff_clk;    
logic                                                       ld_da_data_ff_clk_en; 
logic    [127:0]                                            ld_da_data_for_save;  
logic    [127:0]                                            ld_da_data_for_save1;  
logic    [127:0]                                            ld_da_data_for_save2;  
logic    [127:0]                                            ld_da_data_for_save3;  
logic                                                       ld_da_data_rb_restart;
logic    [127:0]                                            ld_da_data_settle;    
logic    [127:0]                                            ld_da_data_unrot;     
logic                                                       ld_da_data_vld;       
logic    [127:0]                                            ld_da_dcache_data128_ahead_am;       
logic    [127:0]                                            ld_da_dcache_data_after_merge;       
logic                                                       ld_da_dcache_miss;    
logic    [127:0]                                            ld_da_dcache_pass_data128_ahead_am;  
logic    [127:0]                                            ld_da_dcache_pass_data128_am;        
logic    [`WK_LS_DCACHE_LDTAG_QUADRUPLE_BF_ECC_LENGTH-1:0]  ld_da_dcache_tag_corrected;          
logic                                                       ld_da_depd_rb;        
logic                                                       ld_da_discard_dc_req; 
logic                                                       ld_da_discard_from_lfb_req;          
logic                                                       ld_da_discard_from_lm_req;           
logic                                                       ld_da_discard_from_rb_req;           
logic                                                       ld_da_discard_wmb_final;             
logic                                                       ld_da_discard_wmb_req;
logic    [38 :0]                                            ld_da_ecc_data_bank0; 
logic    [38 :0]                                            ld_da_ecc_data_bank1; 
logic    [38 :0]                                            ld_da_ecc_data_bank2; 
logic    [38 :0]                                            ld_da_ecc_data_bank3; 
logic    [38 :0]                                            ld_da_ecc_data_bank4; 
logic    [38 :0]                                            ld_da_ecc_data_bank5; 
logic    [38 :0]                                            ld_da_ecc_data_bank6; 
logic    [38 :0]                                            ld_da_ecc_data_bank7; 
logic    [38 :0]                                            ld_da_ecc_data_bank8; 
logic    [38 :0]                                            ld_da_ecc_data_bank9; 
logic    [38 :0]                                            ld_da_ecc_data_bank10; 
logic    [38 :0]                                            ld_da_ecc_data_bank11; 
logic    [38 :0]                                            ld_da_ecc_data_bank12; 
logic    [38 :0]                                            ld_da_ecc_data_bank13; 
logic    [38 :0]                                            ld_da_ecc_data_bank14; 
logic    [38 :0]                                            ld_da_ecc_data_bank15;
logic                                                       ld_da_ecc_data_req_mask;             
logic                                                       ld_da_ecc_dcache_hit; 
logic                                                       ld_da_ecc_fatal;      
//logic             ld_da_ecc_hit_high_region;           
//logic             ld_da_ecc_hit_low_region;
logic                                                       ld_da_ecc_hit_0_region; 
logic                                                       ld_da_ecc_hit_1_region; 
logic                                                       ld_da_ecc_hit_2_region;             
logic                                                       ld_da_ecc_hit_3_region; 
logic                                                       ld_da_ecc_hit_way0;   
logic                                                       ld_da_ecc_hit_way1;          
logic                                                       ld_da_ecc_hit_way2;   
logic                                                       ld_da_ecc_hit_way3;
logic                                                       ld_da_ecc_mcic_wakup;     
logic                                                       ld_da_ecc_spec_fail;  
//logic             ld_da_ecc_stall;      
logic                                                       ld_da_ecc_stall_clk;  
logic                                                       ld_da_ecc_stall_clk_en;              
logic                                                       ld_da_ecc_stall_gate; 
logic                                                       ld_da_ecc_stall_tag_fatal;           
logic    [3:0]                                              ld_da_ecc_tag_way;      
logic                                                       ld_da_expt_access_fault;             
logic                                                       ld_da_expt_clk;       
logic                                                       ld_da_expt_clk_en;    
logic                                                       ld_da_expt_ori;       
logic                                                       ld_da_expt_vld;       
logic                                                       ld_da_ff_clk;         
logic                                                       ld_da_ff_clk_en;      
logic                                                       ld_da_fof_not_first;  
logic    [127:0]                                            ld_da_fwd_data_am;    
logic    [127:0]                                            ld_da_fwd_data_pe_am;  
logic                                                       ld_da_fwd_no_cache;   
logic                                                       ld_da_fwd_sq_bypass_vld;             
logic    [127:0]                                            ld_da_fwd_sq_data_am; 
logic    [127:0]                                            ld_da_fwd_sq_data_pe_am;             
logic                                                       ld_da_fwd_sq_multi_final;            
logic                                                       ld_da_fwd_sq_multi_req;              
logic                                                       ld_da_fwd_vld;        
logic    [127:0]                                            ld_da_fwd_wmb_data_am;
//logic    [127:0]  ld_da_high_region_data128_ahead_am;  
//logic    [127:0]  ld_da_high_region_data128_am;        
logic                                                       ld_da_hit_high_ecc;   
logic                                                       ld_da_hit_idx_discard_req;           
logic                                                       ld_da_hit_idx_discard_vld;           
logic                                                       ld_da_hit_low_ecc;    
logic    [127:0]                                            ld_da_icc_data_read;  
logic    [127:0]                                            ld_da_icc_tag_read;       
logic                                                       ld_da_idu_boundary_gateclk_vld;        
logic                                                       ld_da_idu_secd_vld;          
logic                                                       ld_da_inst_clk;       
logic                                                       ld_da_inst_clk_en;    
logic                                                       ld_da_inst_cmplt;     
logic                                                       ld_da_ld_inst;        
logic                                                       ld_da_ldamo_inst;    
//logic    [127:0]  ld_da_low_region_data128_ahead_am;   
//logic    [127:0]  ld_da_low_region_data128_am;
logic    [127:0]                                            ld_da_0_region_data128_ahead_am; 
logic    [127:0]                                            ld_da_1_region_data128_ahead_am; 
logic    [127:0]                                            ld_da_2_region_data128_ahead_am; 
logic    [127:0]                                            ld_da_3_region_data128_ahead_am; 
logic    [127:0]                                            ld_da_0_region_data128_am;
logic    [127:0]                                            ld_da_1_region_data128_am;
logic    [127:0]                                            ld_da_2_region_data128_am;
logic    [127:0]                                            ld_da_3_region_data128_am;
logic                                                       ld_da_lq_pop_vld;     
logic                                                       ld_da_lr_inst;        
logic    [LSIQ_ENTRY-1:0]                                   ld_da_mask_lsid;              
logic    [63 :0]                                            ld_da_mcic_bypass_data_ori;          
logic    [63 :0]                                            ld_da_mcic_data;       
logic                                                       ld_da_merge_from_cb;  
logic                                                       ld_da_merge_mask;     
logic                                                       ld_da_no_spec_miss;   
logic                                                       ld_da_no_spec_pair;   
logic                                                       ld_da_no_spec_target; 
logic                                                       ld_da_other_discard_sq_req;          
logic                                                       ld_da_other_discard_sq_vld;          
logic                                                       ld_da_pair_no_spec_mispred;          
logic                                                       ld_da_pair_no_spec_miss;       
logic                                                       ld_da_pfu_info_clk;   
logic                                                       ld_da_pfu_info_clk_en;              
logic                                                       ld_da_rb_create_vld_unmask;        
logic                                                       ld_da_rb_ecc_mask;            
logic                                                       ld_da_rb_full_req;    
logic                                                       ld_da_rb_full_vld;  
logic                                                       ld_da_rb_merge_vld_unmask;           
logic                                                       ld_da_restart_no_cache;              
logic                                                       ld_da_restart_vld;              
logic                                                       ld_da_spec;           
logic                                                       ld_da_spec_chk_req;              
logic                                                       ld_da_split_last;     
logic                                                       ld_da_split_miss;          
logic                                                       ld_da_sq_fwd_ecc_discard;        
logic                                                       ld_da_tag_clk;        
logic                                                       ld_da_tag_clk_en;     
logic                                                       ld_da_tag_ecc_err;    
logic                                                       ld_da_tag_ecc_stall;  
logic                                                       ld_da_tag_ecc_stall_gate;            
logic                                                       ld_da_tag_ecc_stall_ori;             
logic                                                       ld_da_tag_ecc_vld;    
logic    [127:0]                                            ld_da_tag_read_settle;
logic                                                       ld_da_target_no_spec_hit;            
logic                                                       ld_da_target_no_spec_mispred;        
logic                                                       ld_da_target_no_spec_miss;           
logic    [127:0]                                            ld_da_tcm_data128_am; 
logic                                                       ld_da_tcm_ecc_stall;  
logic                                                       ld_da_tcm_ecc_stall_gate;            
logic                                                       ld_da_tcm_ecc_stall_ori;             
logic                                                       ld_da_tcm_hit;        
logic                                                       ld_da_tcm_rb_restart;              
logic    [8  :0]                                            ld_da_vl_upval;             
logic                                                       ld_da_wait_fence_req; 
logic                                                       ld_da_wait_fence_vld;       
logic                                                       ld_da_wb_data_req_mask;
logic                                                       ld_dc_data_inj_vld;              
logic                                                       ld_dc_tag_inj_vld;         
logic    [127:0]                                            sq_ld_da_fwd_data_128;              
logic    [127:0]                                            sq_ld_da_fwd_data_pe_128;  
logic    [`WK_LS_DCACHE_LDTAG_WIDTH-1:0]                    tag_bf_ecc;           
logic    [`WK_PA_WIDTH-1:0]                                 tag_ecc_addr;         
logic                                                       tag_ecc_pipe_down;    
logic                                                       tcm_1bit_err;         
logic    [127:0]                                            tcm_rdata;            
logic                                                       w0_ecc_fatal;         
logic                                                       w0_ecc_free;          
logic    [`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1 :0]            w0_tag_bf_ecc;        
logic    [`WK_LS_DCACHE_LDTAG_BF_ECC_LENGTH-1:0]           w0_tag_corrected;     
logic                                                       w0_tag_ham_error;     
logic                                                       w0_tag_parity_error;  
logic                                                       w1_ecc_fatal;         
logic                                                       w1_ecc_free;          
logic    [`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1 :0]            w1_tag_bf_ecc;        
logic    [`WK_LS_DCACHE_LDTAG_BF_ECC_LENGTH-1:0]            w1_tag_corrected;     
logic                                                       w1_tag_ham_error;     
logic                                                       w1_tag_parity_error; 
logic                                                       w2_ecc_fatal;         
logic                                                       w2_ecc_free;          
logic    [`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1 :0]            w2_tag_bf_ecc;        
logic    [`WK_LS_DCACHE_LDTAG_BF_ECC_LENGTH-1:0]            w2_tag_corrected;     
logic                                                       w2_tag_ham_error;     
logic                                                       w2_tag_parity_error;  
logic                                                       w3_ecc_fatal;         
logic                                                       w3_ecc_free;          
logic    [`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1 :0]            w3_tag_bf_ecc;        
logic    [`WK_LS_DCACHE_LDTAG_BF_ECC_LENGTH-1:0]            w3_tag_corrected;     
logic                                                       w3_tag_ham_error;     
logic                                                       w3_tag_parity_error;             
logic    [127:0]                                            wmb_ld_da_fwd_data_128;        
logic                                                       ld_da_hit_0_ecc; // wjh@chkdsi
logic                                                       ld_da_hit_1_ecc; // wjh@chkdsi
logic                                                       ld_da_hit_2_ecc; // wjh@chkdsi
logic                                                       ld_da_hit_3_ecc; // wjh@chkdsi
logic    [127:0]                                            lsda_lswb_ex3_data0;
logic                                                       lsda_ex3_us_discard;
logic                                                       ld_da_us_discard_req;

logic rtu_ck_flush_iid_older_than_ex2_iid;
logic rtu_ck_flush_iid_older_than_ex3_iid;
logic ld_da_ahead_preg_wb_vld_f;
logic ld_da_ahead_vreg_wb_vld_f;
logic lsdc_lsda_ex2_ahead_preg_wb_vld_ff;
logic lsdc_lsda_ex2_ahead_vreg_wb_vld_ff;

//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
logic                                                       ls_da_boundary_unmask;
logic                                                       ld_da_expt_ori_cancel;
logic                                                       ld_da_expt_vld_cancel;
logic                                                       lda_lwb_ex3_expt_vld_cancel;
//==========================================================
//                  Risc-V Debug zdb End 
//==========================================================

parameter S_BYTE        = 2'b00,
          HALF        = 2'b01,
          WORD        = 2'b10,
          DWORD       = 2'b11;
//==========================================================
//                 Instance of Gated Cell  
//==========================================================
//------------------normal reg------------------------------
assign ld_da_clk_en = lsdc_ex2_inst_vld
                      ||  ld_da_ecc_stall_gate
                      ||  lsdc_lsda_ex2_borrow_vld;
// &Instance("gated_clk_cell", "x_lsu_ld_da_gated_clk"); @52
gated_clk_cell  x_lsu_ld_da_gated_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (ld_da_clk         ),
  .external_en        (1'b0              ),
  .local_en           (ld_da_clk_en      ),
  .module_en          (cp0_lsu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect(.clk_in        (forever_cpuclk     ), @53
//          .external_en   (1'b0               ), @54
//          .module_en     (cp0_lsu_icg_en     ), @55
//          .local_en      (ld_da_clk_en       ), @56
//          .clk_out       (ld_da_clk          )); @57

assign ld_da_inst_clk_en = lsdc_ex2_inst_vld;
// &Instance("gated_clk_cell", "x_lsu_ld_da_inst_gated_clk"); @60
gated_clk_cell  x_lsu_ld_da_inst_gated_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (ld_da_inst_clk    ),
  .external_en        (1'b0              ),
  .local_en           (ld_da_inst_clk_en ),
  .module_en          (cp0_lsu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect(.clk_in        (forever_cpuclk     ), @61
//          .external_en   (1'b0               ), @62
//          .module_en     (cp0_lsu_icg_en     ), @63
//          .local_en      (ld_da_inst_clk_en  ), @64
//          .clk_out       (ld_da_inst_clk     )); @65

assign ld_da_borrow_clk_en = lsdc_lsda_ex2_borrow_vld;
// &Instance("gated_clk_cell", "x_lsu_ld_da_borrow_gated_clk"); @68
gated_clk_cell  x_lsu_ld_da_borrow_gated_clk (
  .clk_in              (forever_cpuclk     ),
  .clk_out             (ld_da_borrow_clk   ),
  .external_en         (1'b0               ),
  .local_en            (ld_da_borrow_clk_en),
  .module_en           (cp0_lsu_icg_en     ),
  .pad_yy_icg_scan_en  (pad_yy_icg_scan_en )
);

// &Connect(.clk_in        (forever_cpuclk     ), @69
//          .external_en   (1'b0               ), @70
//          .module_en     (cp0_lsu_icg_en     ), @71
//          .local_en      (ld_da_borrow_clk_en), @72
//          .clk_out       (ld_da_borrow_clk   )); @73

assign ld_da_expt_clk_en  = lsdc_ex2_inst_vld
                            &&  lsdc_lsda_ex2_expt_vld_gate_en
                            || ld_da_ecc_stall_gate;
// &Instance("gated_clk_cell", "x_lsu_ld_da_expt_gated_clk"); @78
gated_clk_cell  x_lsu_ld_da_expt_gated_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (ld_da_expt_clk    ),
  .external_en        (1'b0              ),
  .local_en           (ld_da_expt_clk_en ),
  .module_en          (cp0_lsu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect(.clk_in        (forever_cpuclk     ), @79
//          .external_en   (1'b0               ), @80
//          .module_en     (cp0_lsu_icg_en     ), @81
//          .local_en      (ld_da_expt_clk_en  ), @82
//          .clk_out       (ld_da_expt_clk     )); @83

//------------------pfu_addr reg----------------------------
assign ld_da_pfu_info_clk_en  = lsdc_pfu_info_set_vld;
// &Instance("gated_clk_cell", "x_lsu_ld_da_pfu_info_gated_clk"); @87
gated_clk_cell  x_lsu_ld_da_pfu_info_gated_clk (
  .clk_in                (lsu_special_clk      ),
  .clk_out               (ld_da_pfu_info_clk   ),
  .external_en           (1'b0                 ),
  .local_en              (ld_da_pfu_info_clk_en),
  .module_en             (cp0_lsu_icg_en       ),
  .pad_yy_icg_scan_en    (pad_yy_icg_scan_en   )
);

// &Connect(.clk_in        (lsu_special_clk    ), @88
//          .external_en   (1'b0               ), @89
//          .module_en     (cp0_lsu_icg_en     ), @90
//          .local_en      (ld_da_pfu_info_clk_en ), @91
//          .clk_out       (ld_da_pfu_info_clk    )); @92

//------------------dcache reg------------------------------
assign ld_da_data0_clk_en = lsdc_ex2_get_dcache_data[0] || ld_da_ecc_stall_gate;
// &Instance("gated_clk_cell", "x_lsu_ld_da_data0_gated_clk"); @96
gated_clk_cell  x_lsu_ld_da_data0_gated_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (ld_da_data0_clk   ),
  .external_en        (1'b0              ),
  .local_en           (ld_da_data0_clk_en),
  .module_en          (cp0_lsu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect(.clk_in        (forever_cpuclk     ), @97
//          .external_en   (1'b0               ), @98
//          .module_en     (cp0_lsu_icg_en     ), @99
//          .local_en      (ld_da_data0_clk_en ), @100
//          .clk_out       (ld_da_data0_clk    )); @101

assign ld_da_data1_clk_en = lsdc_ex2_get_dcache_data[1] || ld_da_ecc_stall_gate;
// &Instance("gated_clk_cell", "x_lsu_ld_da_data1_gated_clk"); @104
gated_clk_cell  x_lsu_ld_da_data1_gated_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (ld_da_data1_clk   ),
  .external_en        (1'b0              ),
  .local_en           (ld_da_data1_clk_en),
  .module_en          (cp0_lsu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect(.clk_in        (forever_cpuclk     ), @105
//          .external_en   (1'b0               ), @106
//          .module_en     (cp0_lsu_icg_en     ), @107
//          .local_en      (ld_da_data1_clk_en ), @108
//          .clk_out       (ld_da_data1_clk    )); @109

assign ld_da_data2_clk_en = lsdc_ex2_get_dcache_data[2] || ld_da_ecc_stall_gate;
// &Instance("gated_clk_cell", "x_lsu_ld_da_data2_gated_clk"); @112
gated_clk_cell  x_lsu_ld_da_data2_gated_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (ld_da_data2_clk   ),
  .external_en        (1'b0              ),
  .local_en           (ld_da_data2_clk_en),
  .module_en          (cp0_lsu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect(.clk_in        (forever_cpuclk     ), @113
//          .external_en   (1'b0               ), @114
//          .module_en     (cp0_lsu_icg_en     ), @115
//          .local_en      (ld_da_data2_clk_en ), @116
//          .clk_out       (ld_da_data2_clk    )); @117

assign ld_da_data3_clk_en = lsdc_ex2_get_dcache_data[3] || ld_da_ecc_stall_gate;
// &Instance("gated_clk_cell", "x_lsu_ld_da_data3_gated_clk"); @120
gated_clk_cell  x_lsu_ld_da_data3_gated_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (ld_da_data3_clk   ),
  .external_en        (1'b0              ),
  .local_en           (ld_da_data3_clk_en),
  .module_en          (cp0_lsu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect(.clk_in        (forever_cpuclk     ), @121
//          .external_en   (1'b0               ), @122
//          .module_en     (cp0_lsu_icg_en     ), @123
//          .local_en      (ld_da_data3_clk_en ), @124
//          .clk_out       (ld_da_data3_clk    )); @125

assign ld_da_tag_clk_en = lsdc_lsda_ex2_icc_tag_vld;
// &Instance("gated_clk_cell", "x_lsu_ld_da_tag_gated_clk"); @128
gated_clk_cell  x_lsu_ld_da_tag_gated_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (ld_da_tag_clk     ),
  .external_en        (1'b0              ),
  .local_en           (ld_da_tag_clk_en  ),
  .module_en          (cp0_lsu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect(.clk_in        (forever_cpuclk     ), @129
//          .external_en   (1'b0               ), @130
//          .module_en     (cp0_lsu_icg_en     ), @131
//          .local_en      (ld_da_tag_clk_en ), @132
//          .clk_out       (ld_da_tag_clk    )); @133

assign ld_da_ecc_stall_clk_en = ld_da_ecc_stall_gate;
// &Instance("gated_clk_cell", "x_lsu_ld_da_ecc_stall_gated_clk"); @137
gated_clk_cell  x_lsu_ld_da_ecc_stall_gated_clk (
  .clk_in                 (forever_cpuclk        ),
  .clk_out                (ld_da_ecc_stall_clk   ),
  .external_en            (1'b0                  ),
  .local_en               (ld_da_ecc_stall_clk_en),
  .module_en              (cp0_lsu_icg_en        ),
  .pad_yy_icg_scan_en     (pad_yy_icg_scan_en    )
);

// &Connect(.clk_in        (forever_cpuclk     ), @138
//          .external_en   (1'b0               ), @139
//          .module_en     (cp0_lsu_icg_en     ), @140
//          .local_en      (ld_da_ecc_stall_clk_en ), @141
//          .clk_out       (ld_da_ecc_stall_clk    )); @142
//==========================================================
//                 Pipeline Register
//==========================================================
//------------------control part----------------------------
//+----------+------------+
//| inst_vld | borrow_vld |
//+----------+------------+
// &Force("output","lsda_ex3_inst_vld"); @151
//always @(posedge ctrl_ld_clk or negedge cpurst_b)
//begin
//  if (!cpurst_b)
//  begin
//    lsda_ex3_is_load           <=  1'b0;
//  end
//  else if(lsdc_ex2_is_load)
//  begin
//    lsda_ex3_is_load           <=  1'b1;
//  end
//  else
//  begin
//    lsda_ex3_is_load           <=  1'b0;
//  end  
//end

xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH)) 
x_lsu_ck_flush_compare_ex2_iid (
  .x_iid0                    (rtu_ck_flush_iid[IID_WIDTH-1:0]),
  .x_iid0_older              (rtu_ck_flush_iid_older_than_ex2_iid  ),
  .x_iid1                    (lsdc_ex2_iid[IID_WIDTH-1:0]           )
);
xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH)) 
x_lsu_ck_flush_compare_ex3_iid (
  .x_iid0                    (rtu_ck_flush_iid[IID_WIDTH-1:0]),
  .x_iid0_older              (rtu_ck_flush_iid_older_than_ex3_iid  ),
  .x_iid1                    (lsda_ex3_iid[IID_WIDTH-1:0]           )
);

assign ld_da_ahead_preg_wb_vld_f   = ~(rtu_ck_flush &&rtu_ck_flush_iid_older_than_ex3_iid)  //flush younger ex3_preg_wb_vld when ecc stall, ck_flush@LTL
                                    ? ld_da_ahead_preg_wb_vld
                                    : 1'b0;
assign ld_da_ahead_vreg_wb_vld_f   = ~(rtu_ck_flush &&rtu_ck_flush_iid_older_than_ex3_iid)  //flush younger ex3_vreg_wb_vld when ecc stall, ck_flush@LTL
                                    ? ld_da_ahead_vreg_wb_vld
                                    : 1'b0;
assign lsdc_lsda_ex2_ahead_preg_wb_vld_ff = ~(rtu_ck_flush &&rtu_ck_flush_iid_older_than_ex2_iid) //flush younger ex2->ex3 preg_wb_vld when no ecc stall, ck_flush@LTL
                                          ? lsdc_lsda_ex2_ahead_preg_wb_vld
                                          : 1'b0;
assign lsdc_lsda_ex2_ahead_vreg_wb_vld_ff = ~(rtu_ck_flush &&rtu_ck_flush_iid_older_than_ex2_iid) //flush younger ex2->ex3 vreg_wb_vld when no ecc stall, ck_flush@LTL
                                          ? lsdc_lsda_ex2_ahead_vreg_wb_vld
                                          : 1'b0;

always @(posedge ctrl_ld_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    lsda_ex3_is_load        <=  1'b0;
    lsda_ex3_inst_vld       <=  1'b0;
    ld_da_ahead_preg_wb_vld <=  1'b0;
    ld_da_ahead_vreg_wb_vld <=  1'b0;
  end
  else if(rtu_lsu_flush_fe)
  begin
    lsda_ex3_inst_vld       <=  1'b0;
    ld_da_ahead_preg_wb_vld <=  1'b0;
    ld_da_ahead_vreg_wb_vld <=  1'b0;
  end
  else if(ld_da_ecc_stall)
  begin
    lsda_ex3_is_load            <=  1'b1;
    lsda_ex3_inst_vld           <=  lsda_ex3_inst_vld && ~(rtu_ck_flush && rtu_ck_flush_iid_older_than_ex3_iid); //flush younger ex3->ex3 inst_vld when ecc stall, ck_flush@LTL
    ld_da_ahead_preg_wb_vld     <=  ld_da_ahead_preg_wb_vld_f;
    ld_da_ahead_vreg_wb_vld     <=  ld_da_ahead_vreg_wb_vld_f;
  end
  else if(lsdc_lsda_ex2_inst_vld)
  begin
    lsda_ex3_is_load            <=  1'b1;
    lsda_ex3_inst_vld           <=  ~(rtu_ck_flush && rtu_ck_flush_iid_older_than_ex2_iid);//flush younger ex2->ex3 inst_vld when no ecc stall, ck_flush@LTL
    ld_da_ahead_preg_wb_vld     <=  lsdc_lsda_ex2_ahead_preg_wb_vld_ff;
    ld_da_ahead_vreg_wb_vld     <=  lsdc_lsda_ex2_ahead_vreg_wb_vld_ff;
  end
  else
  begin
    lsda_ex3_is_load            <=  lsdc_ex2_is_load;
    lsda_ex3_inst_vld           <=  1'b0;
    ld_da_ahead_preg_wb_vld     <=  1'b0;
    ld_da_ahead_vreg_wb_vld     <=  1'b0;
  end
end

always @(posedge ctrl_ld_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    ld_da_dtcm_hit        <=  1'b0;
    ld_da_itcm_hit        <=  1'b0;
  end
  else if(ld_da_ecc_stall)
  begin
    ld_da_dtcm_hit        <=  ld_da_dtcm_hit;
    ld_da_itcm_hit        <=  ld_da_itcm_hit;
  end
  else if(lsdc_lsda_ex2_borrow_vld)
  begin
    ld_da_dtcm_hit        <=  1'b0;
    ld_da_itcm_hit        <=  1'b0;
  end
  else if(lsdc_ex2_inst_vld)
  begin
    ld_da_dtcm_hit        <=  lsdc_ex2_dtcm_hit;
    ld_da_itcm_hit        <=  lsdc_ex2_itcm_hit;
  end
end

assign ld_da_tcm_hit = ld_da_dtcm_hit | ld_da_itcm_hit;

// &Force("output","lsda_ex3_borrow_vld"); @214
always @(posedge ctrl_ld_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    lsda_ex3_borrow_vld        <=  1'b0;
  else if(ld_da_ecc_stall)
    lsda_ex3_borrow_vld        <=  lsda_ex3_borrow_vld;
  else if(lsdc_lsda_ex2_borrow_vld)
    lsda_ex3_borrow_vld        <=  1'b1;
  else
    lsda_ex3_borrow_vld        <=  1'b0;
end

always @(posedge ctrl_ld_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    ld_da_ecc_stall_already  <=  1'b0;
    ld_da_ecc_stall_fatal    <=  1'b0;
    ld_da_ecc_stall_data     <=  1'b0;
    ld_da_ecc_stall_cb_merge <=  1'b0;
    ld_da_ecc_stall_tag_way  <=  4'b0;
  end
  else if(ld_da_ecc_stall)
  begin
    ld_da_ecc_stall_already  <=  1'b1;
    ld_da_ecc_stall_fatal    <=  ld_da_ecc_fatal;
    ld_da_ecc_stall_data     <=  !ld_da_tag_ecc_stall_ori;
    ld_da_ecc_stall_cb_merge <=  ld_da_merge_from_cb;
    ld_da_ecc_stall_tag_way  <=  ld_da_ecc_tag_way;
  end
  else
  begin
    ld_da_ecc_stall_already  <=  1'b0;
    ld_da_ecc_stall_fatal    <=  1'b0;
    ld_da_ecc_stall_data     <=  1'b0;
    ld_da_ecc_stall_cb_merge <=  1'b0;
    ld_da_ecc_stall_tag_way  <=  4'b0;
  end
end

always @(posedge ctrl_ld_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    ld_da_get_dcache_data[3:0]    <=  4'b0;
    ld_da_tag_inj_vld             <=  1'b0;
    ld_da_data_inj_vld            <=  1'b0;
  end
  else if((lsdc_ex2_inst_vld || lsdc_lsda_ex2_borrow_vld) && !ld_da_ecc_stall)
  begin
    ld_da_get_dcache_data[3:0]    <=  lsdc_ex2_get_dcache_data[3:0];
    ld_da_tag_inj_vld             <=  ld_dc_tag_inj_vld;
    ld_da_data_inj_vld            <=  ld_dc_data_inj_vld;
  end
end

//store tag for pa update
always @(posedge ld_da_ecc_stall_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    ld_da_tag_corrected_f[`WK_LS_DCACHE_LDTAG_QUADRUPLE_BF_ECC_LENGTH-1:0] <=  {`WK_LS_DCACHE_LDTAG_QUADRUPLE_BF_ECC_LENGTH{1'b0}};
  else if(ld_da_tag_ecc_stall)
    ld_da_tag_corrected_f[`WK_LS_DCACHE_LDTAG_QUADRUPLE_BF_ECC_LENGTH-1:0] <=  ld_da_dcache_tag_corrected[`WK_LS_DCACHE_LDTAG_QUADRUPLE_BF_ECC_LENGTH-1:0];  //53->107, L1D 2->4way, LTL@20250322
end

//for dc inst wakeup
always @(posedge ctrl_ld_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    ld_da_ecc_wakeup_queue[LSIQ_ENTRY:0] <=  {LSIQ_ENTRY+1{1'b0}};
  else if(ld_da_ecc_stall && lsdc_lsda_ex2_inst_vld && !rtu_lsu_flush_fe)  //ck_flush=1, still wakeup
    ld_da_ecc_wakeup_queue[LSIQ_ENTRY:0] <=  {1'b0,lsdc_lsda_ex2_lsid[LSIQ_ENTRY-1:0]};
  else if(ld_da_ecc_stall && lsdc_lsda_ex2_borrow_vld)
    ld_da_ecc_wakeup_queue[LSIQ_ENTRY:0] <=  {lsdc_lsda_ex2_borrow_mmu,{LSIQ_ENTRY{1'b0}}};
  else
    ld_da_ecc_wakeup_queue[LSIQ_ENTRY:0] <=  {LSIQ_ENTRY+1{1'b0}};
end
//+----------+----------+----------+----------+
//| data 0/4 | data 1/5 | data 2/6 | data 3/7 | 
//+----------+----------+----------+----------+
//data bank0 and bank4 use a common gateclk because they are read
//simultaneously in all case
always @(posedge ld_da_data0_clk)
begin
  if (ld_da_data_ecc_stall)
  begin
  ld_da_dcache_data_bank0[38:0] <=  ld_da_ecc_data_bank0[38:0];
  ld_da_dcache_data_bank4[38:0] <=  ld_da_ecc_data_bank4[38:0];
  ld_da_dcache_data_bank8[38:0] <=  ld_da_ecc_data_bank8[38:0];
  ld_da_dcache_data_bank12[38:0] <=  ld_da_ecc_data_bank12[38:0];
  end
  else if(!ld_da_tag_ecc_stall && lsdc_ex2_get_dcache_data[0])
  begin
  ld_da_dcache_data_bank0[38:0] <=  dcache_data_bank0[38:0];
  ld_da_dcache_data_bank4[38:0] <=  dcache_data_bank4[38:0];
  ld_da_dcache_data_bank8[38:0] <=  dcache_data_bank8[38:0];
  ld_da_dcache_data_bank12[38:0] <=  dcache_data_bank12[38:0];
  end
end

always @(posedge ld_da_data1_clk)
begin
  if (ld_da_data_ecc_stall)
  begin
  ld_da_dcache_data_bank1[38:0] <=  ld_da_ecc_data_bank1[38:0];
  ld_da_dcache_data_bank5[38:0] <=  ld_da_ecc_data_bank5[38:0];
  ld_da_dcache_data_bank9[38:0] <=  ld_da_ecc_data_bank9[38:0];
  ld_da_dcache_data_bank13[38:0] <=  ld_da_ecc_data_bank13[38:0];
  end
  else if(!ld_da_tag_ecc_stall && lsdc_ex2_get_dcache_data[1])
  begin
  ld_da_dcache_data_bank1[38:0] <=  dcache_data_bank1[38:0];
  ld_da_dcache_data_bank5[38:0] <=  dcache_data_bank5[38:0];
  ld_da_dcache_data_bank9[38:0] <=  dcache_data_bank9[38:0];
  ld_da_dcache_data_bank13[38:0] <=  dcache_data_bank13[38:0];
  end
end

always @(posedge ld_da_data2_clk)
begin
  if (ld_da_data_ecc_stall)
  begin
  ld_da_dcache_data_bank2[38:0] <=  ld_da_ecc_data_bank2[38:0];
  ld_da_dcache_data_bank6[38:0] <=  ld_da_ecc_data_bank6[38:0];
  ld_da_dcache_data_bank10[38:0] <=  ld_da_ecc_data_bank10[38:0];
  ld_da_dcache_data_bank14[38:0] <=  ld_da_ecc_data_bank14[38:0];
  end
  else if(!ld_da_tag_ecc_stall && lsdc_ex2_get_dcache_data[2])
  begin
  ld_da_dcache_data_bank2[38:0] <=  dcache_data_bank2[38:0];
  ld_da_dcache_data_bank6[38:0] <=  dcache_data_bank6[38:0];
  ld_da_dcache_data_bank10[38:0] <=  dcache_data_bank10[38:0];
  ld_da_dcache_data_bank14[38:0] <=  dcache_data_bank14[38:0];
  end
end

always @(posedge ld_da_data3_clk)
begin
  if (ld_da_data_ecc_stall)
  begin
  ld_da_dcache_data_bank3[38:0] <=  ld_da_ecc_data_bank3[38:0];
  ld_da_dcache_data_bank7[38:0] <=  ld_da_ecc_data_bank7[38:0];
  ld_da_dcache_data_bank11[38:0] <=  ld_da_ecc_data_bank11[38:0];
  ld_da_dcache_data_bank15[38:0] <=  ld_da_ecc_data_bank15[38:0];
  end
  else if(!ld_da_tag_ecc_stall && lsdc_ex2_get_dcache_data[3])
  begin
  ld_da_dcache_data_bank3[38:0] <=  dcache_data_bank3[38:0];
  ld_da_dcache_data_bank7[38:0] <=  dcache_data_bank7[38:0];
  ld_da_dcache_data_bank11[38:0] <=  dcache_data_bank11[38:0];
  ld_da_dcache_data_bank15[38:0] <=  dcache_data_bank15[38:0];
  end
end

always @(posedge ld_da_data0_clk)
begin
  ld_da_dcache_data_ahead_bank0[31:0] <=  dcache_lsda_ex2_data_bank0_dout[31:0];
  ld_da_dcache_data_ahead_bank4[31:0] <=  dcache_lsda_ex2_data_bank4_dout[31:0];
  ld_da_dcache_data_ahead_bank8[31:0] <=  dcache_lsda_ex2_data_bank8_dout[31:0];
  ld_da_dcache_data_ahead_bank12[31:0] <=  dcache_lsda_ex2_data_bank12_dout[31:0];
end

always @(posedge ld_da_data1_clk)
begin
  ld_da_dcache_data_ahead_bank1[31:0] <=  dcache_lsda_ex2_data_bank1_dout[31:0];
  ld_da_dcache_data_ahead_bank5[31:0] <=  dcache_lsda_ex2_data_bank5_dout[31:0];
  ld_da_dcache_data_ahead_bank9[31:0] <=  dcache_lsda_ex2_data_bank9_dout[31:0];
  ld_da_dcache_data_ahead_bank13[31:0] <=  dcache_lsda_ex2_data_bank13_dout[31:0];
end

always @(posedge ld_da_data2_clk)
begin
  ld_da_dcache_data_ahead_bank2[31:0] <=  dcache_lsda_ex2_data_bank2_dout[31:0];
  ld_da_dcache_data_ahead_bank6[31:0] <=  dcache_lsda_ex2_data_bank6_dout[31:0];
  ld_da_dcache_data_ahead_bank10[31:0] <=  dcache_lsda_ex2_data_bank10_dout[31:0];
  ld_da_dcache_data_ahead_bank14[31:0] <=  dcache_lsda_ex2_data_bank14_dout[31:0];
end

always @(posedge ld_da_data3_clk)
begin
  ld_da_dcache_data_ahead_bank3[31:0] <=  dcache_lsda_ex2_data_bank3_dout[31:0];
  ld_da_dcache_data_ahead_bank7[31:0] <=  dcache_lsda_ex2_data_bank7_dout[31:0];
  ld_da_dcache_data_ahead_bank11[31:0] <=  dcache_lsda_ex2_data_bank11_dout[31:0];
  ld_da_dcache_data_ahead_bank15[31:0] <=  dcache_lsda_ex2_data_bank15_dout[31:0];
end

//------------------tag read for debug-------------------------------
always @(posedge ld_da_tag_clk)
begin
  if(lsdc_lsda_ex2_icc_tag_vld)
  ld_da_tag_read[`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0] <=  lsdc_lsda_ex2_tag_read[`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0];
end

//------------------expt part-------------------------------
//+----------+
//| expt_vec |
//+----------+
always @(posedge ld_da_expt_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    ld_da_expt_vec[4:0]               <=  5'b0;
    ld_da_mt_value[`WK_PA_WIDTH-1:0]     <=  {`WK_PA_WIDTH{1'b0}};
  end
  else if(lsdc_ex2_inst_vld  &&  lsdc_lsda_ex2_expt_vld_gate_en && !ld_da_ecc_stall)
  begin
    ld_da_expt_vec[4:0]           <=  lsdc_lsda_ex2_expt_vec[4:0];
    ld_da_mt_value[`WK_PA_WIDTH-1:0] <=  lsdc_lsda_ex2_mt_value[`WK_PA_WIDTH-1:0];
  end
end

//------------------borrow part-----------------------------
//+-----+------+-----+------------+
//| vb | sndb | mmu | settle way |
//+-----+------+-----+------------+
always @(posedge ld_da_borrow_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    ld_da_borrow_db[VB_DATA_ENTRY-1:0]  <=  {VB_DATA_ENTRY{1'b0}};
    ld_da_borrow_vb                     <=  1'b0;
    ld_da_borrow_sndb                   <=  1'b0;
    ld_da_borrow_mmu                    <=  1'b0;
    ld_da_borrow_icc                    <=  1'b0;
    ld_da_borrow_icc_tag                <=  1'b0;
    // ld_da_settle_way                    <=  2'b0;  //1->2bit, L1D 2->4way, LTL@20250322
    ld_da_borrow_wmb                    <=  1'b0;
    ld_da_borrow_icc_ecc                <=  1'b0;
    ld_da_borrow_idx_5to4[1:0]          <=  2'b0;
  end
  else if(lsdc_lsda_ex2_borrow_vld && !ld_da_ecc_stall)
  begin
    ld_da_borrow_db[VB_DATA_ENTRY-1:0]  <=  lsdc_lsda_ex2_borrow_db[VB_DATA_ENTRY-1:0];
    ld_da_borrow_vb                     <=  lsdc_lsda_ex2_borrow_vb;
    ld_da_borrow_sndb                   <=  lsdc_lsda_ex2_borrow_sndb;
    ld_da_borrow_mmu                    <=  lsdc_lsda_ex2_borrow_mmu;
    ld_da_borrow_icc                    <=  lsdc_lsda_ex2_borrow_icc;
    ld_da_borrow_icc_tag                <=  lsdc_lsda_ex2_borrow_icc_tag;
    // ld_da_settle_way                    <=  lsdc_lsda_ex2_settle_way;
    ld_da_borrow_wmb                    <=  lsdc_lsda_ex2_borrow_wmb;
    ld_da_borrow_icc_ecc                <=  lsdc_lsda_ex2_borrow_icc_ecc;
    ld_da_borrow_idx_5to4[1:0]          <=  lsdc_lsda_ex2_borrow_idx_5to4[1:0];
  end
end
always @(posedge ld_da_clk or negedge cpurst_b)begin 
  if(!cpurst_b)
    ld_da_settle_way <= 2'b00;
  else if((lsdc_lsda_ex2_borrow_vld || lsdc_ex2_inst_vld) && !ld_da_ecc_stall)
    ld_da_settle_way <= lsdc_lsda_ex2_settle_way;
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
// &Force("output","lsda_ex3_inst_size"); @518
// &Force("output","lsda_ex3_sign_extend"); @519
// &Force("output","lsda_ex3_iid"); @520
// &Force("output","lsda_ex3_bytes_vld"); @521
// &Force("output","lsda_ex3_lsid"); @522
// &Force("output","lsda_ex3_bkpta_data"); @523
// &Force("output","lsda_ex3_bkptb_data"); @524
// &Force("output","lsda_ex3_inst_vfls"); @525
// &Force("output","lsda_pfu_ex3_va"); @526
// &Force("output","lsda_ex3_preg"); @527
// &Force("output","lsda_ex3_vreg"); @528
// &Force("output","lsda_ex3_ldfifo_pc"); @529
// &Force("output","lsda_ex3_preg_sign_sel"); @530
// &Force("output","lsda_ex3_vreg_sign_sel"); @531
// &Force("nonport","ld_da_ahead_predict"); @532
// &Force("nonport","ld_da_nf_cnt"); @533
always @(posedge ld_da_inst_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    ld_da_mmu_req                     <=  1'b0;
    ld_da_expt_vld_except_access_err  <=  1'b0;
    ld_da_expt_access_fault_mask      <=  1'b0;
    ld_da_expt_access_fault_extra     <=  1'b0;
    ld_da_expt_access_fault_mmu       <=  1'b0;
    lsda_pfu_ex3_va[`WK_PA_WIDTH-1:0] <=  {`WK_PA_WIDTH{1'b0}};
    lsda_ex3_split                    <=  1'b0;
    ld_da_inst_type[1:0]              <=  2'b0;
    lsda_ex3_inst_size[2:0]           <=  3'b0;
    ld_da_secd                        <=  1'b0;
    lsda_ex3_sign_extend              <=  1'b0;
    ld_da_atomic                      <=  1'b0;
    lsda_ex3_iid[IID_WIDTH-1:0]       <=  {IID_WIDTH{1'b0}};
    lsda_ex3_lsid[LSIQ_ENTRY-1:0]     <=  {LSIQ_ENTRY{1'b0}};
    ld_da_boundary                    <=  1'b0;
    lsda_ex3_preg[PREG-1:0]           <=  {PREG{1'b0}};
    ld_da_already_da                  <=  1'b0;
    lsda_ex3_ldfifo_pc[PC_LEN-1:0]       <=  {PC_LEN{1'b0}};
    ld_da_ahead_predict             <=  1'b0;
    ld_da_wait_fence                <=  1'b0;
    ld_da_other_discard_sq          <=  1'b0;
    ld_da_data_discard_sq           <=  1'b0;
    ld_da_fwd_sq_bypass             <=  1'b0;
    ld_da_fwd_sq_bypass_sel         <=  1'b0;
    ld_da_fwd_sq_vld                <=  1'b0;
    ld_da_data_vld_newest_fwd_sq_dup0    <=  1'b0;
    ld_da_data_vld_newest_fwd_sq_dup1    <=  1'b0;
    ld_da_data_vld_newest_fwd_sq_dup2    <=  1'b0;
    ld_da_data_vld_newest_fwd_sq_dup3    <=  1'b0;
    ld_da_fwd_sq_multi              <=  1'b0;
    ld_da_fwd_sq_multi_mask         <=  1'b0;
    ld_da_fwd_bypass_sq_multi       <=  1'b0;
    lsda_sq_ex3_fwd_id[SQ_ENTRY-1:0]   <=  {SQ_ENTRY{1'b0}};
    ld_da_discard_wmb                   <=  1'b0;
    ld_da_fwd_wmb_vld                   <=  1'b0;
    //ld_da_wmb_fwd_id[WMB_ENTRY-1:0] <=  {WMB_ENTRY{1'b0}};
    ld_da_spec_fail                     <=  1'b0;
    lsda_sfp_ex3_src_pc                 <=  {PC_LEN{1'b0}}; // wjh@sfp
    lsda_ex3_vreg[VREG-1:0]             <=  {VREG{1'b0}};
    lsda_ex3_inst_vfls                  <=  1'b0;
    ld_da_fwd_bytes_vld[15:0]           <=  16'b0;
    ld_da_fwd_bytes_vld_dup[15:0]       <=  16'b0;
    lsda_ex3_preg_sign_sel[3:0]         <=  4'b0;
    lsda_ex3_vreg_sign_sel              <=  1'b0;
    ld_da_cb_addr_create                <=  1'b0;
    ld_da_cb_merge_en                   <=  1'b0;
    ld_da_pf_inst                       <=  1'b0;
    ld_da_no_spec[1:0]                  <=  2'b0;
    ld_da_no_spec_exist                 <=  1'b0;
    ld_da_vector_nop                    <=  1'b0;
    ld_da_lq_entry[LQ_ENTRY-1:0]        <=  {LQ_ENTRY{1'b0}};
    lsda_ex3_reg_bytes_vld[15:0]        <=  16'b0;
    lsda_ex3_inst_us                    <=  1'b0;
    lsda_ex3_us_discard                 <=  1'b0;
    //lsda_ex3_vsew[1:0]                  <=  2'b0;//rvv1.0@hcl
    lsda_ex3_vmew[1:0]                  <=  2'b0;//rvv1.0@hcl
    lsda_ex3_vmop[1:0]                  <=  2'b0;//rvv1.0@hcl
    // lsda_ex3_vlmul[1:0]                 <=  2'b0;
    lsda_ex3_vlmul[2:0]                 <=  3'b0;    
    lsda_ex3_element_size[1:0]          <=  2'b0;
    lsda_ex3_element_cnt[8:0]           <=  9'b0;
    lsda_ex3_setvl_val[8:0]             <=  9'b0;
    lsda_ex3_vmb_id[VMB_ENTRY-1:0]      <=  {VMB_ENTRY{1'b0}};
    lsda_ex3_inst_vls                   <=  1'b0;
    lsda_ex3_inst_fof                   <=  1'b0;
    lsda_ex3_vmb_merge_vld              <=  1'b0;
    ls_da_boundary_unmask               <=  1'b0; // Risc-V Debug zdb
  end
  else if(lsdc_ex2_inst_vld && !ld_da_ecc_stall)
  begin
    ld_da_mmu_req                     <=  lsdc_lsda_ex2_mmu_req;
    ld_da_expt_vld_except_access_err  <=  lsdc_lsda_ex2_expt_vld_except_access_err;
    ld_da_expt_access_fault_mask      <=  lsdc_lsda_ex2_expt_access_fault_mask;
    ld_da_expt_access_fault_extra     <=  lsdc_lsda_ex2_expt_access_fault_extra;
    ld_da_expt_access_fault_mmu       <=  mmu_lsu_access_fault;
    lsda_pfu_ex3_va[`WK_PA_WIDTH-1:0] <=  lsdc_lsda_ex2_pfu_va[`WK_PA_WIDTH-1:0];
    lsda_ex3_split                    <=  lsdc_lsda_ex2_split;
    ld_da_inst_type[1:0]              <=  lsdc_ex2_inst_type[1:0];
    lsda_ex3_inst_size[2:0]           <=  lsdc_ex2_inst_size[2:0];
    ld_da_secd                        <=  lsdc_ex2_secd;
    lsda_ex3_sign_extend              <=  lsdc_lsda_ex2_sign_extend;
    ld_da_atomic                      <=  lsdc_ex2_atomic;
    lsda_ex3_iid[IID_WIDTH-1:0]       <=  lsdc_ex2_iid[IID_WIDTH-1:0];
    lsda_ex3_lsid[LSIQ_ENTRY-1:0]     <=  lsdc_lsda_ex2_lsid[LSIQ_ENTRY-1:0];
    ld_da_boundary                    <=  lsdc_ex2_boundary;
    lsda_ex3_preg[PREG-1:0]           <=  lsdc_lsda_ex2_preg[PREG-1:0];
    ld_da_already_da                  <=  lsdc_lsda_ex2_already_da;
    lsda_ex3_ldfifo_pc[PC_LEN-1:0]    <=  lsdc_lsda_ex2_ldfifo_pc[PC_LEN-1:0];
    ld_da_ahead_predict               <=  lsdc_lsda_ex2_ahead_predict;
    ld_da_wait_fence                  <=  lsdc_lsda_ex2_wait_fence;
    ld_da_other_discard_sq            <=  sq_lsda_ex2_other_discard_req;
    ld_da_data_discard_sq             <=  sq_lsda_ex2_data_discard_req;
    ld_da_fwd_sq_bypass               <=  sq_lsda_ex2_fwd_bypass_req;
    ld_da_fwd_sq_bypass_sel           <=  sq_lsda_ex2_fwd_bypass_sel;
    ld_da_fwd_sq_vld                  <=  lsdc_ex2_fwd_sq_vld;
    ld_da_data_vld_newest_fwd_sq_dup0 <=  sq_lsda_ex2_newest_fwd_data_vld_req;
    ld_da_data_vld_newest_fwd_sq_dup1 <=  sq_lsda_ex2_newest_fwd_data_vld_req;
    ld_da_data_vld_newest_fwd_sq_dup2 <=  sq_lsda_ex2_newest_fwd_data_vld_req;
    ld_da_data_vld_newest_fwd_sq_dup3 <=  sq_lsda_ex2_newest_fwd_data_vld_req;
    ld_da_fwd_sq_multi                <=  sq_lsda_ex2_fwd_multi;
    ld_da_fwd_sq_multi_mask           <=  sq_lsda_ex2_fwd_multi_mask;
    ld_da_fwd_bypass_sq_multi         <=  sq_lsda_ex2_fwd_bypass_multi;
    lsda_sq_ex3_fwd_id[SQ_ENTRY-1:0]  <=  sq_lsda_ex2_fwd_id[SQ_ENTRY-1:0];
    ld_da_discard_wmb                 <=  wmb_lsdc_discard_req;
    ld_da_fwd_wmb_vld                 <=  lsdc_ex2_fwd_wmb_vld;
    //ld_da_wmb_fwd_id[WMB_ENTRY-1:0] <=  wmb_ld_dc_fwd_id[WMB_ENTRY-1:0];
    ld_da_spec_fail                   <=  lsdc_lsda_ex2_spec_fail;
    lsda_sfp_ex3_src_pc               <=  lq_lsu_ex2_spec_fail_pc; // wjh@sfp
    lsda_ex3_vreg[VREG-1:0]           <=  lsdc_lsda_ex2_vreg[VREG-1:0];
    lsda_ex3_inst_vfls                <=  lsdc_lsda_ex2_inst_vfls;
    ld_da_fwd_bytes_vld[15:0]         <=  lsdc_lsda_ex2_fwd_bytes_vld[15:0];
    ld_da_fwd_bytes_vld_dup[15:0]     <=  lsdc_lsda_ex2_fwd_bytes_vld[15:0];
    lsda_ex3_preg_sign_sel[3:0]       <=  lsdc_lsda_ex2_preg_sign_sel[3:0];
    lsda_ex3_vreg_sign_sel            <=  lsdc_lsda_ex2_vreg_sign_sel;
    ld_da_cb_addr_create              <=  lsdc_lsda_ex2_cb_addr_create;
    ld_da_cb_merge_en                 <=  lsdc_lsda_ex2_cb_merge_en;
    ld_da_pf_inst                     <=  lsdc_lsda_ex2_pf_inst;
    ld_da_no_spec[1:0]                <=  lsdc_lsda_ex2_no_spec[1:0];
    ld_da_no_spec_exist               <=  lsdc_lsda_ex2_no_spec_exist;
    ld_da_vector_nop                  <=  lsdc_ex2_vector_nop;
    ld_da_lq_entry[LQ_ENTRY-1:0]      <=  lsdc_lsda_ex2_lq_entry[LQ_ENTRY-1:0];
    lsda_ex3_reg_bytes_vld[15:0]      <=  lsdc_lsda_ex2_reg_bytes_vld[15:0];
    lsda_ex3_inst_us                  <=  lsdc_lsda_ex2_inst_us;
    lsda_ex3_us_discard               <=  lsdc_lsda_ex2_us_discard;
    //lsda_ex3_vsew[1:0]                <=  lsdc_ex2_vsew[1:0];//rvv1.0@hcl
    lsda_ex3_vmew[1:0]                <=  lsdc_ex2_vmew[1:0];//rvv1.0@hcl
    lsda_ex3_vmop[1:0]                <=  lsdc_ex2_vmop[1:0];//rvv1.0@hcl
    // lsda_ex3_vlmul[1:0]               <=  lsdc_lsda_ex2_vlmul[1:0];
    lsda_ex3_vlmul[2:0]               <=  lsdc_lsda_ex2_vlmul[2:0];    
    lsda_ex3_element_size[1:0]        <=  lsdc_ex2_element_size[1:0];
    lsda_ex3_element_cnt[8:0]         <=  lsdc_lsda_ex2_element_cnt[8:0];
    lsda_ex3_setvl_val[8:0]           <=  lsdc_lsda_ex2_setvl_val[8:0];
    lsda_ex3_vmb_id[VMB_ENTRY-1:0]    <=  lsdc_lsda_ex2_vmb_id[VMB_ENTRY-1:0];
    lsda_ex3_inst_vls                 <=  lsdc_ex2_inst_vls;
    lsda_ex3_inst_fof                 <=  lsdc_lsda_ex2_inst_fof;
    lsda_ex3_vmb_merge_vld            <=  lsdc_lsda_ex2_vmb_merge_vld;
    ls_da_boundary_unmask             <=  ld_dc_boundary_unmask; // Risc-V Debug zdb
  end
end

always @(posedge ld_da_clk or negedge cpurst_b)begin 
  if(!cpurst_b)begin 
    lsda_ex3_bytes_vld1[15:0]           <=  16'b0;
    lsda_ex3_bytes_vld2[15:0]           <=  16'b0;
    lsda_ex3_bytes_vld3[15:0]           <=  16'b0;
    lsda_ex3_reg_bytes_vld1[15:0]       <=  16'b0;
    lsda_ex3_reg_bytes_vld2[15:0]       <=  16'b0;
    lsda_ex3_reg_bytes_vld3[15:0]       <=  16'b0;
  end
  else if(lsdc_ex2_inst_vld && !ld_da_ecc_stall && lsdc_lsda_ex2_inst_us)begin 
    lsda_ex3_bytes_vld1[15:0]         <=  lsdc_ex2_bytes_vld1[15:0];
    lsda_ex3_bytes_vld2[15:0]         <=  lsdc_ex2_bytes_vld2[15:0];
    lsda_ex3_bytes_vld3[15:0]         <=  lsdc_ex2_bytes_vld3[15:0];
    lsda_ex3_reg_bytes_vld1[15:0]     <=  lsdc_lsda_ex2_reg_bytes_vld1[15:0];
    lsda_ex3_reg_bytes_vld2[15:0]     <=  lsdc_lsda_ex2_reg_bytes_vld2[15:0];
    lsda_ex3_reg_bytes_vld3[15:0]     <=  lsdc_lsda_ex2_reg_bytes_vld3[15:0];
  end
end 
//------------------inst/borrow share part------------------
//+------+-----------------+------------------+
//| addr | dcache_data_sel | page_information |
//+------+-----------------+------------------+
// &Force("output","lsda_ex3_page_ca"); @688
// &Force("output","lsda_ex3_page_so"); @689
// &Force("output","lsda_ex3_page_sec"); @690
// &Force("output","lsda_ex3_page_share"); @691
// &Force("output","lsda_ex3_data_rot_sel"); @692
always @(posedge ld_da_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    ld_da_addr0_idx[`WK_PA_WIDTH-7:0]<=  {(`WK_PA_WIDTH-6){1'b0}};
    lsda_ex3_old                     <=  1'b0;
    lsda_ex3_page_so                 <=  1'b0;
    lsda_ex3_page_ca                 <=  1'b0;
    lsda_ex3_page_buf                <=  1'b0;
    lsda_ex3_page_sec                <=  1'b0;
    lsda_ex3_page_share              <=  1'b0;
    lsda_ex3_data_rot_sel[15:0]      <=  16'b0;
    lsda_ex3_bytes_vld[15:0]         <=  16'b0;
  end
  else if((lsdc_ex2_inst_vld  ||  lsdc_lsda_ex2_borrow_vld && !lsdc_lsda_ex2_borrow_vb && !lsdc_lsda_ex2_borrow_sndb) && !ld_da_ecc_stall)
  begin
    ld_da_addr0_idx[`WK_PA_WIDTH-7:0]<=  lsdc_ex2_addr0[`WK_PA_WIDTH-1:6];
    lsda_ex3_old                     <=  lsdc_ex2_old;
    lsda_ex3_page_so                 <=  lsdc_ex2_page_so;
    lsda_ex3_page_ca                 <=  lsdc_ex2_page_ca;
    lsda_ex3_page_buf                <=  lsdc_ex2_page_buf;
    lsda_ex3_page_sec                <=  lsdc_ex2_page_sec;
    lsda_ex3_page_share              <=  lsdc_ex2_page_share;
    lsda_ex3_data_rot_sel[15:0]      <=  lsdc_lsda_ex2_data_rot_sel[15:0];
    lsda_ex3_bytes_vld[15:0]         <=  lsdc_ex2_bytes_vld[15:0];
  end
end

always @(posedge ld_da_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    ld_da_addr0[`WK_PA_WIDTH-1:0]    <=  {`WK_PA_WIDTH{1'b0}};
  else if((lsdc_ex2_inst_vld  ||  lsdc_lsda_ex2_borrow_vld) && !ld_da_ecc_stall)
    ld_da_addr0[`WK_PA_WIDTH-1:0]    <=  lsdc_ex2_addr0[`WK_PA_WIDTH-1:0];
end



always @(posedge ld_da_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    lsda_ex3_dcache_hit         <=  1'b0;
    ld_da_hit_0_region          <=  1'b0;
    ld_da_hit_0_region_dup0     <=  1'b0;
    ld_da_hit_0_region_dup1     <=  1'b0;
    ld_da_hit_0_region_dup2     <=  1'b0;
    ld_da_hit_0_region_dup3     <=  1'b0;
    ld_da_hit_1_region          <=  1'b0;
    ld_da_hit_1_region_dup0     <=  1'b0;
    ld_da_hit_1_region_dup1     <=  1'b0;
    ld_da_hit_1_region_dup2     <=  1'b0;
    ld_da_hit_1_region_dup3     <=  1'b0;
    ld_da_hit_2_region          <=  1'b0;
    ld_da_hit_2_region_dup0     <=  1'b0;
    ld_da_hit_2_region_dup1     <=  1'b0;
    ld_da_hit_2_region_dup2     <=  1'b0;
    ld_da_hit_2_region_dup3     <=  1'b0;
    ld_da_hit_3_region          <=  1'b0;
    ld_da_hit_3_region_dup0     <=  1'b0;
    ld_da_hit_3_region_dup1     <=  1'b0;
    ld_da_hit_3_region_dup2     <=  1'b0;
    ld_da_hit_3_region_dup3     <=  1'b0;
  end
  else if(ld_da_tag_ecc_stall)
  begin
    lsda_ex3_dcache_hit        <=  ld_da_ecc_dcache_hit;
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
  else if((lsdc_ex2_inst_vld  ||  lsdc_lsda_ex2_borrow_vld && lsdc_lsda_ex2_borrow_mmu) && !ld_da_ecc_stall)
  begin
    lsda_ex3_dcache_hit        <=  lsdc_lsda_ex2_dcache_hit;
    ld_da_hit_0_region         <=  lsdc_ex2_hit_0_region;
    ld_da_hit_0_region_dup0    <=  lsdc_ex2_hit_0_region;
    ld_da_hit_0_region_dup1    <=  lsdc_ex2_hit_0_region;
    ld_da_hit_0_region_dup2    <=  lsdc_ex2_hit_0_region;
    ld_da_hit_0_region_dup3    <=  lsdc_ex2_hit_0_region;
    ld_da_hit_1_region         <=  lsdc_ex2_hit_1_region;
    ld_da_hit_1_region_dup0    <=  lsdc_ex2_hit_1_region;
    ld_da_hit_1_region_dup1    <=  lsdc_ex2_hit_1_region;
    ld_da_hit_1_region_dup2    <=  lsdc_ex2_hit_1_region;
    ld_da_hit_1_region_dup3    <=  lsdc_ex2_hit_1_region;
    ld_da_hit_2_region         <=  lsdc_ex2_hit_2_region;
    ld_da_hit_2_region_dup0    <=  lsdc_ex2_hit_2_region;
    ld_da_hit_2_region_dup1    <=  lsdc_ex2_hit_2_region;
    ld_da_hit_2_region_dup2    <=  lsdc_ex2_hit_2_region;
    ld_da_hit_2_region_dup3    <=  lsdc_ex2_hit_2_region;
    ld_da_hit_3_region         <=  lsdc_ex2_hit_3_region;
    ld_da_hit_3_region_dup0    <=  lsdc_ex2_hit_3_region;
    ld_da_hit_3_region_dup1    <=  lsdc_ex2_hit_3_region;
    ld_da_hit_3_region_dup2    <=  lsdc_ex2_hit_3_region;
    ld_da_hit_3_region_dup3    <=  lsdc_ex2_hit_3_region;
  end
end

//for ecc info
always @(posedge ld_da_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    //ld_da_hit_way0              <=  1'b0;
    ld_da_hit_way              <=  4'b0;
  end
  else if(ld_da_tag_ecc_stall)
  begin
    //ld_da_hit_way0              <=  ld_da_ecc_hit_way0;
    ld_da_hit_way              <=  {ld_da_ecc_hit_way3,ld_da_ecc_hit_way2,ld_da_ecc_hit_way1,ld_da_ecc_hit_way0};
  end
  else if((lsdc_ex2_inst_vld  ||  lsdc_lsda_ex2_borrow_vld && lsdc_lsda_ex2_borrow_mmu) && !ld_da_ecc_stall)
  begin
    //ld_da_hit_way0              <=  lsdc_ex2_hit_way0;
    ld_da_hit_way              <=  lsdc_ex2_hit_way;
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
    lsda_pfu_ex3_ppfu_va[`WK_PA_WIDTH-1:0]      <=  {`WK_PA_WIDTH{1'b0}};
  else if(lsdc_pfu_info_set_vld && !ld_da_ecc_stall)
    lsda_pfu_ex3_ppfu_va[`WK_PA_WIDTH-1:0]      <=  lsdc_lsda_ex2_pfu_va[`WK_PA_WIDTH-1:0];
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
assign ld_da_ecc_stall_tag_fatal = ld_da_ecc_stall_fatal & ~ld_da_ecc_stall_data; 

// &Force("output","lsda_ex3_expt_vld"); @862
assign ld_da_expt_ori = ld_da_expt_vld_except_access_err
                         ||  ld_da_expt_access_fault
                         ||  ld_da_ecc_stall_tag_fatal;

assign ld_da_expt_vld = (ld_da_expt_vld_except_access_err
                         ||  ld_da_expt_access_fault
                         ||  ld_da_ecc_stall_tag_fatal)
                        && !ld_da_fof_not_first
                        && !ld_da_vector_nop;

assign lsda_ex3_expt_vld = (ld_da_expt_vld_except_access_err
                               ||  ld_da_expt_access_fault)
                           && !ld_da_fof_not_first
                           && !ld_da_vector_nop;

// &CombBeg; @878
always @( ld_da_mt_value[`WK_PA_WIDTH-1:0]
       or ld_da_expt_access_fault
       or ld_da_expt_vec[4:0]
       or ld_da_atomic
       or dtu_lsu_addr_halt_info[`TDT_MP_HINFO_WIDTH-1:0]
       or ls_da_boundary_unmask
       or lsda_ex3_expt_vld)
begin
lsda_lswb_ex3_expt_vec[4:0]  = ld_da_expt_vec[4:0];

ld_da_wb_mt_value_ori[`WK_PA_WIDTH-1:0]  = ld_da_mt_value[`WK_PA_WIDTH-1:0];
if(ld_da_expt_access_fault &&  !ld_da_atomic)
begin
  lsda_lswb_ex3_expt_vec[4:0]  = 5'd5;
  ld_da_wb_mt_value_ori[`WK_PA_WIDTH-1:0]  = {`WK_PA_WIDTH{1'b0}};
end
else if(ld_da_expt_access_fault &&  ld_da_atomic)
begin
  lsda_lswb_ex3_expt_vec[4:0]  = 5'd7;
  ld_da_wb_mt_value_ori[`WK_PA_WIDTH-1:0]  = {`WK_PA_WIDTH{1'b0}};
end
//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
else if(dtu_lsu_addr_halt_info[0] & ls_da_boundary_unmask | dtu_lsu_addr_halt_info[1] & ls_da_boundary_unmask & ~lsda_ex3_expt_vld)
begin
  lsda_lswb_ex3_expt_vec[4:0]  = 5'd3;
  ld_da_wb_mt_value_ori[`WK_PA_WIDTH-1:0]  = {`WK_PA_WIDTH{1'b0}};
end
//==========================================================
//                  Risc-V Debug zdb End 
//==========================================================
// &CombEnd; @892
end

// &Force("output","lsda_ex3_element_cnt"); @895
// &Force("output","lsda_ex3_vlmul"); @896
// &Force("output","lsda_ex3_inst_fof"); @897
// &Force("output","lsda_ex3_split"); @898
// &Force("output","lsda_ex3_setvl_val"); @899
// &Force("output","lsda_rb_ex3_expt_vld"); @900
assign lsda_rb_ex3_expt_vld = lsda_ex3_inst_vld
                           && (ld_da_expt_vld_except_access_err
                               ||  ld_da_expt_access_fault)
                           && !ld_da_vector_nop;

assign ld_da_fof_not_first = lsda_ex3_inst_fof
                             && !(lsda_ex3_setvl_val[8:0] == 9'b0);

assign lsda_lswb_ex3_vsetvl = lsda_ex3_inst_vld
                         && !ld_da_vector_nop
                         && ld_da_fof_not_first
                         && (ld_da_expt_vld_except_access_err
                             ||  ld_da_expt_access_fault)
                         && ~dtu_lsu_addr_halt_info[0]; // Risc-V Debug zdb

assign ld_da_vl_upval[8:0] = lsda_ex3_setvl_val[8:0];

assign lsda_lswb_ex3_mt_value[`WK_PA_WIDTH-1:0] = lsda_ex3_expt_vld
                                                ? ld_da_wb_mt_value_ori[`WK_PA_WIDTH-1:0]
                                                // : {{`WK_PA_WIDTH-16{1'b0}},3'b100,1'b0,ld_da_vl_upval[8:0],1'b0,lsda_ex3_vmew[1:0],lsda_ex3_vlmul[1:0]};//rvv1.0
                                          : {{WK_PA_WIDTH-19{1'b0}},3'b100,1'b0,ld_da_vl_upval[8:0],1'b0,lsda_ex3_vmew[1:0],lsda_ex3_vlmul[2:0]};//rvv1.0                                          

assign lsda_lswb_ex3_vstart_vld = lsda_ex3_inst_vld
                             && lsda_ex3_inst_vls
                             && (lsda_ex3_expt_vld
                                 || (dtu_lsu_addr_halt_info[0] // Risc-V Debug zdb
                                    && ~ld_da_fof_not_first)   // Risc-V Debug zdb
                                 || (cp0_lsu_vstart[`VSTART_WIDTH-1:0] != `VSTART_WIDTH'b0)
                                    && !lsda_ex3_split
                                    && !lsda_ex3_expt_vld
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

assign lsda_pfu_ld_tag_miss = lsda_ex3_inst_vld
                              &&  !ld_da_expt_vld_cancel
                              &&  ld_da_ld_inst
                              &&  lsda_ex3_page_ca
                              &&  ld_da_dcache_miss
                              &&  !ld_da_fwd_vld;  //no fwd, LTL@20250515
//==========================================================
//        Data forward from sq/wmb
//==========================================================
//data forward from sq/wmb is done in sq/wmb file
assign sq_ld_da_fwd_data_128[127:0] = sq_lsda_ex3_fwd_data[127:0];
assign sq_ld_da_fwd_data_pe_128[127:0] = sq_lsda_ex3_fwd_data_pe[127:0];
assign wmb_ld_da_fwd_data_128[127:0] = wmb_lsda_fwd_data[127:0];

assign ld_da_fwd_wmb_data_am[127:0] = {{{8{lsda_ex3_bytes_vld[15]}}  & wmb_ld_da_fwd_data_128[127:120]}
                                      ,{{8{lsda_ex3_bytes_vld[14]}}  & wmb_ld_da_fwd_data_128[119:112]}
                                      ,{{8{lsda_ex3_bytes_vld[13]}}  & wmb_ld_da_fwd_data_128[111:104]}
                                      ,{{8{lsda_ex3_bytes_vld[12]}}  & wmb_ld_da_fwd_data_128[103:96]}
                                      ,{{8{lsda_ex3_bytes_vld[11]}}  & wmb_ld_da_fwd_data_128[95:88]}
                                      ,{{8{lsda_ex3_bytes_vld[10]}}  & wmb_ld_da_fwd_data_128[87:80]}
                                      ,{{8{lsda_ex3_bytes_vld[9]}}   & wmb_ld_da_fwd_data_128[79:72]}
                                      ,{{8{lsda_ex3_bytes_vld[8]}}   & wmb_ld_da_fwd_data_128[71:64]}
                                      ,{{8{lsda_ex3_bytes_vld[7]}}   & wmb_ld_da_fwd_data_128[63:56]}
                                      ,{{8{lsda_ex3_bytes_vld[6]}}   & wmb_ld_da_fwd_data_128[55:48]}
                                      ,{{8{lsda_ex3_bytes_vld[5]}}   & wmb_ld_da_fwd_data_128[47:40]}
                                      ,{{8{lsda_ex3_bytes_vld[4]}}   & wmb_ld_da_fwd_data_128[39:32]}
                                      ,{{8{lsda_ex3_bytes_vld[3]}}   & wmb_ld_da_fwd_data_128[31:24]}
                                      ,{{8{lsda_ex3_bytes_vld[2]}}   & wmb_ld_da_fwd_data_128[23:16]}
                                      ,{{8{lsda_ex3_bytes_vld[1]}}   & wmb_ld_da_fwd_data_128[15:8]}
                                      ,{{8{lsda_ex3_bytes_vld[0]}}   & wmb_ld_da_fwd_data_128[7:0]}};

assign ld_da_fwd_sq_data_pe_am[127:0] = {{{8{lsda_ex3_bytes_vld[15]}}  & sq_ld_da_fwd_data_pe_128[127:120]}
                                        ,{{8{lsda_ex3_bytes_vld[14]}}  & sq_ld_da_fwd_data_pe_128[119:112]}
                                        ,{{8{lsda_ex3_bytes_vld[13]}}  & sq_ld_da_fwd_data_pe_128[111:104]}
                                        ,{{8{lsda_ex3_bytes_vld[12]}}  & sq_ld_da_fwd_data_pe_128[103:96]}
                                        ,{{8{lsda_ex3_bytes_vld[11]}}  & sq_ld_da_fwd_data_pe_128[95:88]}
                                        ,{{8{lsda_ex3_bytes_vld[10]}}  & sq_ld_da_fwd_data_pe_128[87:80]}
                                        ,{{8{lsda_ex3_bytes_vld[9]}}   & sq_ld_da_fwd_data_pe_128[79:72]}
                                        ,{{8{lsda_ex3_bytes_vld[8]}}   & sq_ld_da_fwd_data_pe_128[71:64]}
                                        ,{{8{lsda_ex3_bytes_vld[7]}}   & sq_ld_da_fwd_data_pe_128[63:56]}
                                        ,{{8{lsda_ex3_bytes_vld[6]}}   & sq_ld_da_fwd_data_pe_128[55:48]}
                                        ,{{8{lsda_ex3_bytes_vld[5]}}   & sq_ld_da_fwd_data_pe_128[47:40]}
                                        ,{{8{lsda_ex3_bytes_vld[4]}}   & sq_ld_da_fwd_data_pe_128[39:32]}
                                        ,{{8{lsda_ex3_bytes_vld[3]}}   & sq_ld_da_fwd_data_pe_128[31:24]}
                                        ,{{8{lsda_ex3_bytes_vld[2]}}   & sq_ld_da_fwd_data_pe_128[23:16]}
                                        ,{{8{lsda_ex3_bytes_vld[1]}}   & sq_ld_da_fwd_data_pe_128[15:8]}
                                        ,{{8{lsda_ex3_bytes_vld[0]}}   & sq_ld_da_fwd_data_pe_128[7:0]}};

assign ld_da_fwd_sq_data_am[127:0]    = {{{8{lsda_ex3_bytes_vld[15]}}  & sq_ld_da_fwd_data_128[127:120]}
                                        ,{{8{lsda_ex3_bytes_vld[14]}}  & sq_ld_da_fwd_data_128[119:112]}
                                        ,{{8{lsda_ex3_bytes_vld[13]}}  & sq_ld_da_fwd_data_128[111:104]}
                                        ,{{8{lsda_ex3_bytes_vld[12]}}  & sq_ld_da_fwd_data_128[103:96]}
                                        ,{{8{lsda_ex3_bytes_vld[11]}}  & sq_ld_da_fwd_data_128[95:88]}
                                        ,{{8{lsda_ex3_bytes_vld[10]}}  & sq_ld_da_fwd_data_128[87:80]}
                                        ,{{8{lsda_ex3_bytes_vld[9]}}   & sq_ld_da_fwd_data_128[79:72]}
                                        ,{{8{lsda_ex3_bytes_vld[8]}}   & sq_ld_da_fwd_data_128[71:64]}
                                        ,{{8{lsda_ex3_bytes_vld[7]}}   & sq_ld_da_fwd_data_128[63:56]}
                                        ,{{8{lsda_ex3_bytes_vld[6]}}   & sq_ld_da_fwd_data_128[55:48]}
                                        ,{{8{lsda_ex3_bytes_vld[5]}}   & sq_ld_da_fwd_data_128[47:40]}
                                        ,{{8{lsda_ex3_bytes_vld[4]}}   & sq_ld_da_fwd_data_128[39:32]}
                                        ,{{8{lsda_ex3_bytes_vld[3]}}   & sq_ld_da_fwd_data_128[31:24]}
                                        ,{{8{lsda_ex3_bytes_vld[2]}}   & sq_ld_da_fwd_data_128[23:16]}
                                        ,{{8{lsda_ex3_bytes_vld[1]}}   & sq_ld_da_fwd_data_128[15:8]}
                                        ,{{8{lsda_ex3_bytes_vld[0]}}   & sq_ld_da_fwd_data_128[7:0]}};

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

// &CombBeg; @1025
always @( std0_ex1_data_bypass[127:0]
       or lsda_ex3_inst_size[2:0])
begin
case(lsda_ex3_inst_size[2:0])
  3'b000: ld_da_fwd_data_bypass0[127:0] = {120'b0,std0_ex1_data_bypass[7:0]};  //byte
  3'b001: ld_da_fwd_data_bypass0[127:0] = {112'b0,std0_ex1_data_bypass[15:0]}; //half
  3'b010: ld_da_fwd_data_bypass0[127:0] = {96'b0,std0_ex1_data_bypass[31:0]};  //word
  3'b011: ld_da_fwd_data_bypass0[127:0] = {64'b0,std0_ex1_data_bypass[63:0]};  //dword
  default:ld_da_fwd_data_bypass0[127:0] = std0_ex1_data_bypass[127:0];         //qword
endcase
// &CombEnd; @1033
end
always @( std1_ex1_data_bypass[127:0]
       or lsda_ex3_inst_size[2:0])
begin
case(lsda_ex3_inst_size[2:0])
  3'b000: ld_da_fwd_data_bypass1[127:0] = {120'b0,std1_ex1_data_bypass[7:0]};  //byte
  3'b001: ld_da_fwd_data_bypass1[127:0] = {112'b0,std1_ex1_data_bypass[15:0]}; //half
  3'b010: ld_da_fwd_data_bypass1[127:0] = {96'b0,std1_ex1_data_bypass[31:0]};  //word
  3'b011: ld_da_fwd_data_bypass1[127:0] = {64'b0,std1_ex1_data_bypass[63:0]};  //dword
  default:ld_da_fwd_data_bypass1[127:0] = std1_ex1_data_bypass[127:0];         //qword
endcase
// &CombEnd; @1033
end

assign ld_da_fwd_data_bypass  = ({128{!ld_da_fwd_sq_bypass_sel}} & ld_da_fwd_data_bypass0[127:0])   //choose data from sd0 and sd1, LTL@20241114
                                | ({128{ld_da_fwd_sq_bypass_sel}} & ld_da_fwd_data_bypass1[127:0]);

assign ld_da_fwd_vld          = ld_da_fwd_sq_vld
                                ||  ld_da_fwd_sq_bypass_vld  
                                ||  ld_da_fwd_wmb_vld
                                    &&  (lsda_ex3_dcache_hit | ld_da_tcm_hit);

assign ld_da_merge_from_cb    = ld_da_cb_merge_en
                                   && cb_ld_da_data_vld
                                || ld_da_ecc_stall_cb_merge;

//==========================================================
//                Settle data from cache
//==========================================================
//------------------cache data settle to vb/snq------------
assign ld_da_data512_way0[511:0]  = {ld_da_dcache_data_bank15[31:0],
                                     ld_da_dcache_data_bank14[31:0],
                                     ld_da_dcache_data_bank13[31:0],
                                     ld_da_dcache_data_bank12[31:0],
                                     ld_da_dcache_data_bank11[31:0],
                                     ld_da_dcache_data_bank10[31:0],
                                     ld_da_dcache_data_bank9[31:0],
                                     ld_da_dcache_data_bank8[31:0],
                                     ld_da_dcache_data_bank7[31:0],
                                     ld_da_dcache_data_bank6[31:0],
                                     ld_da_dcache_data_bank5[31:0],
                                     ld_da_dcache_data_bank4[31:0],
                                     ld_da_dcache_data_bank3[31:0],
                                     ld_da_dcache_data_bank2[31:0],
                                     ld_da_dcache_data_bank1[31:0],
                                     ld_da_dcache_data_bank0[31:0]};

assign ld_da_data512_way1[511:0]  = {ld_da_dcache_data_bank11[31:0],
                                    ld_da_dcache_data_bank10[31:0],
                                    ld_da_dcache_data_bank9[31:0],
                                    ld_da_dcache_data_bank8[31:0],
                                    ld_da_dcache_data_bank15[31:0],
                                    ld_da_dcache_data_bank14[31:0],
                                    ld_da_dcache_data_bank13[31:0],
                                    ld_da_dcache_data_bank12[31:0],
                                    ld_da_dcache_data_bank3[31:0],
                                    ld_da_dcache_data_bank2[31:0],
                                    ld_da_dcache_data_bank1[31:0],
                                    ld_da_dcache_data_bank0[31:0],
                                    ld_da_dcache_data_bank7[31:0],
                                    ld_da_dcache_data_bank6[31:0],
                                    ld_da_dcache_data_bank5[31:0],
                                    ld_da_dcache_data_bank4[31:0]};
assign ld_da_data512_way2[511:0]  = {ld_da_dcache_data_bank7[31:0],
                                    ld_da_dcache_data_bank6[31:0],
                                    ld_da_dcache_data_bank5[31:0],
                                    ld_da_dcache_data_bank4[31:0],
                                    ld_da_dcache_data_bank3[31:0],
                                    ld_da_dcache_data_bank2[31:0],
                                    ld_da_dcache_data_bank1[31:0],
                                    ld_da_dcache_data_bank0[31:0],
                                    ld_da_dcache_data_bank15[31:0],
                                    ld_da_dcache_data_bank14[31:0],
                                    ld_da_dcache_data_bank13[31:0],
                                    ld_da_dcache_data_bank12[31:0],
                                    ld_da_dcache_data_bank11[31:0],
                                    ld_da_dcache_data_bank10[31:0],
                                    ld_da_dcache_data_bank9[31:0],
                                    ld_da_dcache_data_bank8[31:0]};
assign ld_da_data512_way3[511:0]  = {ld_da_dcache_data_bank3[31:0],
                                    ld_da_dcache_data_bank2[31:0],
                                    ld_da_dcache_data_bank1[31:0],
                                    ld_da_dcache_data_bank0[31:0],
                                    ld_da_dcache_data_bank7[31:0],
                                    ld_da_dcache_data_bank6[31:0],
                                    ld_da_dcache_data_bank5[31:0],
                                    ld_da_dcache_data_bank4[31:0],
                                    ld_da_dcache_data_bank11[31:0],
                                    ld_da_dcache_data_bank10[31:0],
                                    ld_da_dcache_data_bank9[31:0],
                                    ld_da_dcache_data_bank8[31:0],
                                    ld_da_dcache_data_bank15[31:0],
                                    ld_da_dcache_data_bank14[31:0],
                                    ld_da_dcache_data_bank13[31:0],
                                    ld_da_dcache_data_bank12[31:0]};                                    
assign ld_da_data512_way0_aft_ecc[511:0] = cp0_lsu_ecc_en
                                           ? ld_da_data512_way0_corrected[511:0]
                                           : ld_da_data512_way0[511:0];
assign ld_da_data512_way1_aft_ecc[511:0] = cp0_lsu_ecc_en
                                           ? ld_da_data512_way1_corrected[511:0]
                                           : ld_da_data512_way1[511:0];  
assign ld_da_data512_way2_aft_ecc[511:0] = cp0_lsu_ecc_en
                                           ? ld_da_data512_way2_corrected[511:0]
                                           : ld_da_data512_way2[511:0];
assign ld_da_data512_way3_aft_ecc[511:0] = cp0_lsu_ecc_en
                                           ? ld_da_data512_way3_corrected[511:0]
                                           : ld_da_data512_way3[511:0]; 
//assign lsda_ex3_data256[255:0]       = ld_da_settle_way
//                                    ? ld_da_data256_way1_aft_ecc[255:0]
//                                    : ld_da_data256_way0_aft_ecc[255:0];
always_comb
begin
case(ld_da_settle_way[1:0])
  2'b11: lsda_ex3_data512[511:0] = ld_da_data512_way3_aft_ecc[ 511:0 ];  //way3
  2'b10: lsda_ex3_data512[511:0] = ld_da_data512_way2_aft_ecc[ 511:0 ];  //way2
  2'b01: lsda_ex3_data512[511:0] = ld_da_data512_way1_aft_ecc[ 511:0 ];  //way1
  2'b00: lsda_ex3_data512[511:0] = ld_da_data512_way0_aft_ecc[ 511:0 ];  //way0
  default: lsda_ex3_data512[511:0] = 512'b0;
endcase
end
generate 
  for(genvar i=0; i<16; i++)begin 
    assign lsda_lswb_ex3_data0[i*8 +: 8] = {8{lsda_ex3_bytes_vld[i]}}  & lsda_ex3_data512[i*8 +: 8];
    assign lsda_lswb_ex3_data1[i*8 +: 8] = {8{lsda_ex3_bytes_vld1[i]}} & lsda_ex3_data512[(i+16)*8 +: 8];
    assign lsda_lswb_ex3_data2[i*8 +: 8] = {8{lsda_ex3_bytes_vld2[i]}} & lsda_ex3_data512[(i+32)*8 +: 8];
    assign lsda_lswb_ex3_data3[i*8 +: 8] = {8{lsda_ex3_bytes_vld3[i]}} & lsda_ex3_data512[(i+48)*8 +: 8];
  end
endgenerate
//------------------cache data settle-----------------------
assign ld_da_3_region_data128_am[127:0]= {{{8{lsda_ex3_bytes_vld[15]}}  & ld_da_dcache_data_bank15[31:24]}
                                            ,{{8{lsda_ex3_bytes_vld[14]}}  & ld_da_dcache_data_bank15[23:16]}
                                            ,{{8{lsda_ex3_bytes_vld[13]}}  & ld_da_dcache_data_bank15[15:8]}
                                            ,{{8{lsda_ex3_bytes_vld[12]}}  & ld_da_dcache_data_bank15[7:0]}
                                            ,{{8{lsda_ex3_bytes_vld[11]}}  & ld_da_dcache_data_bank14[31:24]}
                                            ,{{8{lsda_ex3_bytes_vld[10]}}  & ld_da_dcache_data_bank14[23:16]}
                                            ,{{8{lsda_ex3_bytes_vld[9]}}   & ld_da_dcache_data_bank14[15:8]}
                                            ,{{8{lsda_ex3_bytes_vld[8]}}   & ld_da_dcache_data_bank14[7:0]}
                                            ,{{8{lsda_ex3_bytes_vld[7]}}   & ld_da_dcache_data_bank13[31:24]}
                                            ,{{8{lsda_ex3_bytes_vld[6]}}   & ld_da_dcache_data_bank13[23:16]}
                                            ,{{8{lsda_ex3_bytes_vld[5]}}   & ld_da_dcache_data_bank13[15:8]}
                                            ,{{8{lsda_ex3_bytes_vld[4]}}   & ld_da_dcache_data_bank13[7:0]}
                                            ,{{8{lsda_ex3_bytes_vld[3]}}   & ld_da_dcache_data_bank12[31:24]}
                                            ,{{8{lsda_ex3_bytes_vld[2]}}   & ld_da_dcache_data_bank12[23:16]}
                                            ,{{8{lsda_ex3_bytes_vld[1]}}   & ld_da_dcache_data_bank12[15:8]}
                                            ,{{8{lsda_ex3_bytes_vld[0]}}   & ld_da_dcache_data_bank12[7:0]}};
assign ld_da_2_region_data128_am[127:0]= {{{8{lsda_ex3_bytes_vld[15]}}  & ld_da_dcache_data_bank11[31:24]}
                                            ,{{8{lsda_ex3_bytes_vld[14]}}  & ld_da_dcache_data_bank11[23:16]}
                                            ,{{8{lsda_ex3_bytes_vld[13]}}  & ld_da_dcache_data_bank11[15:8]}
                                            ,{{8{lsda_ex3_bytes_vld[12]}}  & ld_da_dcache_data_bank11[7:0]}
                                            ,{{8{lsda_ex3_bytes_vld[11]}}  & ld_da_dcache_data_bank10[31:24]}
                                            ,{{8{lsda_ex3_bytes_vld[10]}}  & ld_da_dcache_data_bank10[23:16]}
                                            ,{{8{lsda_ex3_bytes_vld[9]}}   & ld_da_dcache_data_bank10[15:8]}
                                            ,{{8{lsda_ex3_bytes_vld[8]}}   & ld_da_dcache_data_bank10[7:0]}
                                            ,{{8{lsda_ex3_bytes_vld[7]}}   & ld_da_dcache_data_bank9[31:24]}
                                            ,{{8{lsda_ex3_bytes_vld[6]}}   & ld_da_dcache_data_bank9[23:16]}
                                            ,{{8{lsda_ex3_bytes_vld[5]}}   & ld_da_dcache_data_bank9[15:8]}
                                            ,{{8{lsda_ex3_bytes_vld[4]}}   & ld_da_dcache_data_bank9[7:0]}
                                            ,{{8{lsda_ex3_bytes_vld[3]}}   & ld_da_dcache_data_bank8[31:24]}
                                            ,{{8{lsda_ex3_bytes_vld[2]}}   & ld_da_dcache_data_bank8[23:16]}
                                            ,{{8{lsda_ex3_bytes_vld[1]}}   & ld_da_dcache_data_bank8[15:8]}
                                            ,{{8{lsda_ex3_bytes_vld[0]}}   & ld_da_dcache_data_bank8[7:0]}};

assign ld_da_1_region_data128_am[127:0]= {{{8{lsda_ex3_bytes_vld[15]}}  & ld_da_dcache_data_bank7[31:24]}
                                            ,{{8{lsda_ex3_bytes_vld[14]}}  & ld_da_dcache_data_bank7[23:16]}
                                            ,{{8{lsda_ex3_bytes_vld[13]}}  & ld_da_dcache_data_bank7[15:8]}
                                            ,{{8{lsda_ex3_bytes_vld[12]}}  & ld_da_dcache_data_bank7[7:0]}
                                            ,{{8{lsda_ex3_bytes_vld[11]}}  & ld_da_dcache_data_bank6[31:24]}
                                            ,{{8{lsda_ex3_bytes_vld[10]}}  & ld_da_dcache_data_bank6[23:16]}
                                            ,{{8{lsda_ex3_bytes_vld[9]}}   & ld_da_dcache_data_bank6[15:8]}
                                            ,{{8{lsda_ex3_bytes_vld[8]}}   & ld_da_dcache_data_bank6[7:0]}
                                            ,{{8{lsda_ex3_bytes_vld[7]}}   & ld_da_dcache_data_bank5[31:24]}
                                            ,{{8{lsda_ex3_bytes_vld[6]}}   & ld_da_dcache_data_bank5[23:16]}
                                            ,{{8{lsda_ex3_bytes_vld[5]}}   & ld_da_dcache_data_bank5[15:8]}
                                            ,{{8{lsda_ex3_bytes_vld[4]}}   & ld_da_dcache_data_bank5[7:0]}
                                            ,{{8{lsda_ex3_bytes_vld[3]}}   & ld_da_dcache_data_bank4[31:24]}
                                            ,{{8{lsda_ex3_bytes_vld[2]}}   & ld_da_dcache_data_bank4[23:16]}
                                            ,{{8{lsda_ex3_bytes_vld[1]}}   & ld_da_dcache_data_bank4[15:8]}
                                            ,{{8{lsda_ex3_bytes_vld[0]}}   & ld_da_dcache_data_bank4[7:0]}};

assign ld_da_0_region_data128_am[127:0] = {{{8{lsda_ex3_bytes_vld[15]}}  & ld_da_dcache_data_bank3[31:24]}
                                            ,{{8{lsda_ex3_bytes_vld[14]}}  & ld_da_dcache_data_bank3[23:16]}
                                            ,{{8{lsda_ex3_bytes_vld[13]}}  & ld_da_dcache_data_bank3[15:8]}
                                            ,{{8{lsda_ex3_bytes_vld[12]}}  & ld_da_dcache_data_bank3[7:0]}
                                            ,{{8{lsda_ex3_bytes_vld[11]}}  & ld_da_dcache_data_bank2[31:24]}
                                            ,{{8{lsda_ex3_bytes_vld[10]}}  & ld_da_dcache_data_bank2[23:16]}
                                            ,{{8{lsda_ex3_bytes_vld[9]}}   & ld_da_dcache_data_bank2[15:8]}
                                            ,{{8{lsda_ex3_bytes_vld[8]}}   & ld_da_dcache_data_bank2[7:0]}
                                            ,{{8{lsda_ex3_bytes_vld[7]}}   & ld_da_dcache_data_bank1[31:24]}
                                            ,{{8{lsda_ex3_bytes_vld[6]}}   & ld_da_dcache_data_bank1[23:16]}
                                            ,{{8{lsda_ex3_bytes_vld[5]}}   & ld_da_dcache_data_bank1[15:8]}
                                            ,{{8{lsda_ex3_bytes_vld[4]}}   & ld_da_dcache_data_bank1[7:0]}
                                            ,{{8{lsda_ex3_bytes_vld[3]}}   & ld_da_dcache_data_bank0[31:24]}
                                            ,{{8{lsda_ex3_bytes_vld[2]}}   & ld_da_dcache_data_bank0[23:16]}
                                            ,{{8{lsda_ex3_bytes_vld[1]}}   & ld_da_dcache_data_bank0[15:8]}
                                            ,{{8{lsda_ex3_bytes_vld[0]}}   & ld_da_dcache_data_bank0[7:0]}};
assign ld_da_3_region_data128_ahead_am[127:0]= {{{8{lsda_ex3_bytes_vld[15]}}  & ld_da_dcache_data_ahead_bank15[31:24]}
                                                  ,{{8{lsda_ex3_bytes_vld[14]}}  & ld_da_dcache_data_ahead_bank15[23:16]}
                                                  ,{{8{lsda_ex3_bytes_vld[13]}}  & ld_da_dcache_data_ahead_bank15[15:8]}
                                                  ,{{8{lsda_ex3_bytes_vld[12]}}  & ld_da_dcache_data_ahead_bank15[7:0]}
                                                  ,{{8{lsda_ex3_bytes_vld[11]}}  & ld_da_dcache_data_ahead_bank14[31:24]}
                                                  ,{{8{lsda_ex3_bytes_vld[10]}}  & ld_da_dcache_data_ahead_bank14[23:16]}
                                                  ,{{8{lsda_ex3_bytes_vld[9]}}   & ld_da_dcache_data_ahead_bank14[15:8]}
                                                  ,{{8{lsda_ex3_bytes_vld[8]}}   & ld_da_dcache_data_ahead_bank14[7:0]}
                                                  ,{{8{lsda_ex3_bytes_vld[7]}}   & ld_da_dcache_data_ahead_bank13[31:24]}
                                                  ,{{8{lsda_ex3_bytes_vld[6]}}   & ld_da_dcache_data_ahead_bank13[23:16]}
                                                  ,{{8{lsda_ex3_bytes_vld[5]}}   & ld_da_dcache_data_ahead_bank13[15:8]}
                                                  ,{{8{lsda_ex3_bytes_vld[4]}}   & ld_da_dcache_data_ahead_bank13[7:0]}
                                                  ,{{8{lsda_ex3_bytes_vld[3]}}   & ld_da_dcache_data_ahead_bank12[31:24]}
                                                  ,{{8{lsda_ex3_bytes_vld[2]}}   & ld_da_dcache_data_ahead_bank12[23:16]}
                                                  ,{{8{lsda_ex3_bytes_vld[1]}}   & ld_da_dcache_data_ahead_bank12[15:8]}
                                                  ,{{8{lsda_ex3_bytes_vld[0]}}   & ld_da_dcache_data_ahead_bank12[7:0]}};
assign ld_da_2_region_data128_ahead_am[127:0]= {{{8{lsda_ex3_bytes_vld[15]}}  & ld_da_dcache_data_ahead_bank11[31:24]}
                                                  ,{{8{lsda_ex3_bytes_vld[14]}}  & ld_da_dcache_data_ahead_bank11[23:16]}
                                                  ,{{8{lsda_ex3_bytes_vld[13]}}  & ld_da_dcache_data_ahead_bank11[15:8]}
                                                  ,{{8{lsda_ex3_bytes_vld[12]}}  & ld_da_dcache_data_ahead_bank11[7:0]}
                                                  ,{{8{lsda_ex3_bytes_vld[11]}}  & ld_da_dcache_data_ahead_bank10[31:24]}
                                                  ,{{8{lsda_ex3_bytes_vld[10]}}  & ld_da_dcache_data_ahead_bank10[23:16]}
                                                  ,{{8{lsda_ex3_bytes_vld[9]}}   & ld_da_dcache_data_ahead_bank10[15:8]}
                                                  ,{{8{lsda_ex3_bytes_vld[8]}}   & ld_da_dcache_data_ahead_bank10[7:0]}
                                                  ,{{8{lsda_ex3_bytes_vld[7]}}   & ld_da_dcache_data_ahead_bank9[31:24]}
                                                  ,{{8{lsda_ex3_bytes_vld[6]}}   & ld_da_dcache_data_ahead_bank9[23:16]}
                                                  ,{{8{lsda_ex3_bytes_vld[5]}}   & ld_da_dcache_data_ahead_bank9[15:8]}
                                                  ,{{8{lsda_ex3_bytes_vld[4]}}   & ld_da_dcache_data_ahead_bank9[7:0]}
                                                  ,{{8{lsda_ex3_bytes_vld[3]}}   & ld_da_dcache_data_ahead_bank8[31:24]}
                                                  ,{{8{lsda_ex3_bytes_vld[2]}}   & ld_da_dcache_data_ahead_bank8[23:16]}
                                                  ,{{8{lsda_ex3_bytes_vld[1]}}   & ld_da_dcache_data_ahead_bank8[15:8]}
                                                  ,{{8{lsda_ex3_bytes_vld[0]}}   & ld_da_dcache_data_ahead_bank8[7:0]}};
assign ld_da_1_region_data128_ahead_am[127:0]= {{{8{lsda_ex3_bytes_vld[15]}}  & ld_da_dcache_data_ahead_bank7[31:24]}
                                                  ,{{8{lsda_ex3_bytes_vld[14]}}  & ld_da_dcache_data_ahead_bank7[23:16]}
                                                  ,{{8{lsda_ex3_bytes_vld[13]}}  & ld_da_dcache_data_ahead_bank7[15:8]}
                                                  ,{{8{lsda_ex3_bytes_vld[12]}}  & ld_da_dcache_data_ahead_bank7[7:0]}
                                                  ,{{8{lsda_ex3_bytes_vld[11]}}  & ld_da_dcache_data_ahead_bank6[31:24]}
                                                  ,{{8{lsda_ex3_bytes_vld[10]}}  & ld_da_dcache_data_ahead_bank6[23:16]}
                                                  ,{{8{lsda_ex3_bytes_vld[9]}}   & ld_da_dcache_data_ahead_bank6[15:8]}
                                                  ,{{8{lsda_ex3_bytes_vld[8]}}   & ld_da_dcache_data_ahead_bank6[7:0]}
                                                  ,{{8{lsda_ex3_bytes_vld[7]}}   & ld_da_dcache_data_ahead_bank5[31:24]}
                                                  ,{{8{lsda_ex3_bytes_vld[6]}}   & ld_da_dcache_data_ahead_bank5[23:16]}
                                                  ,{{8{lsda_ex3_bytes_vld[5]}}   & ld_da_dcache_data_ahead_bank5[15:8]}
                                                  ,{{8{lsda_ex3_bytes_vld[4]}}   & ld_da_dcache_data_ahead_bank5[7:0]}
                                                  ,{{8{lsda_ex3_bytes_vld[3]}}   & ld_da_dcache_data_ahead_bank4[31:24]}
                                                  ,{{8{lsda_ex3_bytes_vld[2]}}   & ld_da_dcache_data_ahead_bank4[23:16]}
                                                  ,{{8{lsda_ex3_bytes_vld[1]}}   & ld_da_dcache_data_ahead_bank4[15:8]}
                                                  ,{{8{lsda_ex3_bytes_vld[0]}}   & ld_da_dcache_data_ahead_bank4[7:0]}};

assign ld_da_0_region_data128_ahead_am[127:0] = {{{8{lsda_ex3_bytes_vld[15]}}  & ld_da_dcache_data_ahead_bank3[31:24]}
                                                  ,{{8{lsda_ex3_bytes_vld[14]}}  & ld_da_dcache_data_ahead_bank3[23:16]}
                                                  ,{{8{lsda_ex3_bytes_vld[13]}}  & ld_da_dcache_data_ahead_bank3[15:8]}
                                                  ,{{8{lsda_ex3_bytes_vld[12]}}  & ld_da_dcache_data_ahead_bank3[7:0]}
                                                  ,{{8{lsda_ex3_bytes_vld[11]}}  & ld_da_dcache_data_ahead_bank2[31:24]}
                                                  ,{{8{lsda_ex3_bytes_vld[10]}}  & ld_da_dcache_data_ahead_bank2[23:16]}
                                                  ,{{8{lsda_ex3_bytes_vld[9]}}   & ld_da_dcache_data_ahead_bank2[15:8]}
                                                  ,{{8{lsda_ex3_bytes_vld[8]}}   & ld_da_dcache_data_ahead_bank2[7:0]}
                                                  ,{{8{lsda_ex3_bytes_vld[7]}}   & ld_da_dcache_data_ahead_bank1[31:24]}
                                                  ,{{8{lsda_ex3_bytes_vld[6]}}   & ld_da_dcache_data_ahead_bank1[23:16]}
                                                  ,{{8{lsda_ex3_bytes_vld[5]}}   & ld_da_dcache_data_ahead_bank1[15:8]}
                                                  ,{{8{lsda_ex3_bytes_vld[4]}}   & ld_da_dcache_data_ahead_bank1[7:0]}
                                                  ,{{8{lsda_ex3_bytes_vld[3]}}   & ld_da_dcache_data_ahead_bank0[31:24]}
                                                  ,{{8{lsda_ex3_bytes_vld[2]}}   & ld_da_dcache_data_ahead_bank0[23:16]}
                                                  ,{{8{lsda_ex3_bytes_vld[1]}}   & ld_da_dcache_data_ahead_bank0[15:8]}
                                                  ,{{8{lsda_ex3_bytes_vld[0]}}   & ld_da_dcache_data_ahead_bank0[7:0]}};


//==========================================================
//        Compare tag and select data from cache/sq|wmb
//==========================================================
//------------------compare tag-----------------------------
//assign ld_da_tag[17:0]      = ld_da_addr0[31:14];
// &Force("output","lsda_ex3_idx"); @1161
assign lsda_ex3_idx[`WK_PA_WIDTH-7:0] = ld_da_addr0_idx[`WK_PA_WIDTH-7:0];
assign lsda_ex3_addr_5to4[1:0]        = ld_da_addr0[5:4];

// &Force("output","lsda_ex3_dcache_hit"); @1165
assign ld_da_dcache_miss    = !lsda_ex3_dcache_hit;

//------------------select data-----------------------------
//hit region refer to LSU spec
assign ld_da_dcache_pass_data128_am[127:0]  = {128{ld_da_hit_0_region}}  & ld_da_0_region_data128_am[127:0]
                                              | {128{ld_da_hit_1_region}}  & ld_da_1_region_data128_am[127:0]
                                              | {128{ld_da_hit_2_region}}  & ld_da_2_region_data128_am[127:0]
                                              | {128{ld_da_hit_3_region}}  & ld_da_3_region_data128_am[127:0];

assign ld_da_dcache_pass_data128_ahead_am[31:0]   = {32{ld_da_hit_0_region_dup0}}  & ld_da_0_region_data128_ahead_am[31:0]
                                                    | {32{ld_da_hit_1_region_dup0}}  & ld_da_1_region_data128_ahead_am[31:0]
                                                    | {32{ld_da_hit_2_region_dup0}}  & ld_da_2_region_data128_ahead_am[31:0]
                                                    | {32{ld_da_hit_3_region_dup0}}  & ld_da_3_region_data128_ahead_am[31:0];
assign ld_da_dcache_pass_data128_ahead_am[63:32]  = {32{ld_da_hit_0_region_dup1}}  & ld_da_0_region_data128_ahead_am[63:32]
                                                    | {32{ld_da_hit_1_region_dup1}}  & ld_da_1_region_data128_ahead_am[63:32]
                                                    | {32{ld_da_hit_2_region_dup1}}  & ld_da_2_region_data128_ahead_am[63:32]
                                                    | {32{ld_da_hit_3_region_dup1}}  & ld_da_3_region_data128_ahead_am[63:32];
assign ld_da_dcache_pass_data128_ahead_am[95:64]  = {32{ld_da_hit_0_region_dup2}}  & ld_da_0_region_data128_ahead_am[95:64]
                                                    | {32{ld_da_hit_1_region_dup2}}  & ld_da_1_region_data128_ahead_am[95:64]
                                                    | {32{ld_da_hit_2_region_dup2}}  & ld_da_2_region_data128_ahead_am[95:64]
                                                    | {32{ld_da_hit_3_region_dup2}}  & ld_da_3_region_data128_ahead_am[95:64];
assign ld_da_dcache_pass_data128_ahead_am[127:96] = {32{ld_da_hit_0_region_dup3}}  & ld_da_0_region_data128_ahead_am[127:96]
                                                    | {32{ld_da_hit_1_region_dup3}}  & ld_da_1_region_data128_ahead_am[127:96]
                                                    | {32{ld_da_hit_2_region_dup3}}  & ld_da_2_region_data128_ahead_am[127:96]
                                                    | {32{ld_da_hit_3_region_dup3}}  & ld_da_3_region_data128_ahead_am[127:96];


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

assign ld_da_cb_bypass_data_for_merge[127:0]  = ld_da_merge_from_cb
                                                ? ld_da_cb_bypass_data_am[127:0]
                                                : 128'b0;

assign ld_da_dcache_data_after_merge[127:0]   = ld_da_cb_bypass_data_for_merge[127:0]
                                                | ld_da_dcache_pass_data128_am[127:0];

assign ld_da_data_aft_merge[127:0] = ld_da_tcm_hit
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
  .rot_sel            (lsda_ex3_data_rot_sel)
);

// &Connect(.rot_sel         (lsda_ex3_data_rot_sel     ), @1276
//          .data_in         (ld_da_data_unrot   ), @1277
//          .data_settle_out (ld_da_data_settle )); @1278

assign ld_da_data128[127:0]   = ld_da_fwd_sq_bypass
                                ? ld_da_fwd_data_bypass[127:0]
                                : ld_da_data_settle[127:0];
assign lsda_lswb_ex3_data[127:0] = lsda_ex3_inst_us? lsda_lswb_ex3_data0:ld_da_data128[127:0];

//------------------select data from cache or sq/wmb--------
assign ld_da_data_vld               = lsda_ex3_inst_vld
                                      &&  !ld_da_expt_vld
                                      &&  (ld_da_fwd_vld ||  lsda_ex3_dcache_hit || ld_da_tcm_hit);
assign lsda_rb_ex3_data_vld = ld_da_data_vld 
                           || lsda_ex3_inst_vld 
                              && (ld_da_vector_nop || ld_da_expt_ori);
// &Force("output","lsda_rb_ex3_data_vld"); @1300

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
  .rot_sel                        (lsda_ex3_data_rot_sel            )
);

// &Connect(.rot_sel         (lsda_ex3_data_rot_sel     ), @1354
//          .data_in         (ld_da_ahead_preg_data_unsettle), @1355
//          .data_settle_out (ld_da_ahead_preg_data_settle )); @1356

//assign ld_da_ahead_vreg_data_unsettle[127:0]  = ld_da_dcache_pass_data128_am[127:0];
//assign ld_da_ahead_vreg_data_unsettle[127:0]  = ld_da_ahead_preg_data_unsettle[127:0];
//rotate vreg data
//&Instance("xx_lsu_rot_data", "x_lsu_ld_da_ahead_vreg_data_rot");
// //&Connect(.rot_sel         (lsda_ex3_data_rot_sel     ), @1362
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
    lsda_ex3_boundary_after_mask_ff  <=  1'b0;
    ld_da_data_ff[127:0]          <=  128'b0;
    ld_da_data_ff1                <= 128'b0;
    ld_da_data_ff2                <= 128'b0;
    ld_da_data_ff3                <= 128'b0;
  end
  else if(ld_da_data_delay_vld)
  begin
    lsda_ex3_boundary_after_mask_ff  <=  lsda_ex3_boundary_after_mask;
    ld_da_data_ff[127:0]          <=  ld_da_data_for_save[127:0];
    ld_da_data_ff1                <=  ld_da_data_for_save1;
    ld_da_data_ff2                <=  ld_da_data_for_save2;
    ld_da_data_ff3                <=  ld_da_data_for_save3;
  end
end

assign ld_da_data_delay_vld  = lsda_ex3_inst_vld
                                  && (ld_da_rb_create_vld_unmask || ld_da_rb_merge_vld_unmask)
                                  && lsda_rb_ex3_data_vld
                               || lsda_ex3_borrow_vld
                                  && ld_da_borrow_mmu
                                  && lsda_ex3_dcache_hit; 
assign ld_da_data_delay_gate = lsda_ex3_inst_vld
                                  && lsda_rb_ex3_data_vld
                               || lsda_ex3_borrow_vld
                                  && ld_da_borrow_mmu;

assign ld_da_mcic_data[63:0]      = ld_da_addr0[3]
                                    ? ld_da_dcache_pass_data128_am[127:64]
                                    : ld_da_dcache_pass_data128_am[63:0];
assign ld_da_data_for_save[127:0] = lsda_ex3_borrow_vld
                                    ? {2{ld_da_mcic_data[63:0]}}
                                    : lsda_ex3_inst_us
                                      ? lsda_lswb_ex3_data0
                                      : ld_da_data_unrot[127:0];
assign ld_da_data_for_save1 = lsda_lswb_ex3_data1;
assign ld_da_data_for_save2 = lsda_lswb_ex3_data2;
assign ld_da_data_for_save3 = lsda_lswb_ex3_data3;
//-------------- rb data ---------------                                  
assign ld_da_boundary_data[127:0] = ld_da_ecc_stall_already & lsda_ex3_inst_us
                                    ? lsda_lswb_ex3_data0
                                    : ld_da_ecc_stall_already
                                      ? ld_da_data_unrot[127:0]
                                      : ld_da_data_ff[127:0];

assign lsda_rb_ex3_data_ori[127:0]        = ld_da_boundary_data[127:0];
assign lsda_rb_ex3_data_ori1              = ld_da_ecc_stall_already? lsda_lswb_ex3_data1: ld_da_data_ff1;
assign lsda_rb_ex3_data_ori2              = ld_da_ecc_stall_already? lsda_lswb_ex3_data2: ld_da_data_ff2;
assign lsda_rb_ex3_data_ori3              = ld_da_ecc_stall_already? lsda_lswb_ex3_data3: ld_da_data_ff3;

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
       or lsda_ex3_preg_sign_sel[3:0]
       or ld_da_ahead_preg_data_sign3[63:0]
       or ld_da_ahead_preg_data_sign2[63:0])
begin
case(lsda_ex3_preg_sign_sel[3:0])
  4'b1000:ld_da_preg_data_sign_extend[63:0] = ld_da_ahead_preg_data_sign3[63:0];
  4'b0100:ld_da_preg_data_sign_extend[63:0] = ld_da_ahead_preg_data_sign2[63:0];
  4'b0010:ld_da_preg_data_sign_extend[63:0] = ld_da_ahead_preg_data_sign1[63:0];
  4'b0001:ld_da_preg_data_sign_extend[63:0] = ld_da_ahead_preg_data_sign0[63:0];
  default:ld_da_preg_data_sign_extend[63:0] = {64{1'bx}};
endcase
// &CombEnd; @1443
end

//vector data
//assign ld_da_vreg_data_sign_extend[63:0]  = lsda_ex3_vreg_sign_sel && (lsda_ex3_inst_size[1:0] == 2'b10)
//                                            ? {{32{1'b1}},ld_da_ahead_vreg_data_settle[31:0]}
//                                            : lsda_ex3_vreg_sign_sel && (lsda_ex3_inst_size[1:0] == 2'b01)
//                                              ? {{48{1'b1}},ld_da_ahead_vreg_data_settle[15:0]} 
//                                              : ld_da_ahead_vreg_data_settle[63:0];

// &Force("output","lsda_ex3_inst_vls"); @1453
// &Force("output","lsda_ex3_element_size"); @1454
// &Force("output","lsda_ex3_vsew"); @1455
// &CombBeg; @1456
//rvv1.0@hcl
always @( lsda_ex3_vmew[1:0]
       or lsda_ex3_inst_vls
       or lsda_ex3_element_size[1:0]
       or lsda_ex3_vreg_sign_sel)
begin
casez({lsda_ex3_inst_vls,lsda_ex3_vreg_sign_sel,lsda_ex3_element_size[1:0],lsda_ex3_vmew[1:0]})
  {1'b1,1'b0,S_BYTE,HALF}:  lsda_lswb_ex3_vreg_sign_sel[14:0] = 15'h0002;
  {1'b1,1'b1,S_BYTE,HALF}:  lsda_lswb_ex3_vreg_sign_sel[14:0] = 15'h0004;
  {1'b1,1'b0,S_BYTE,WORD}:  lsda_lswb_ex3_vreg_sign_sel[14:0] = 15'h0008;
  {1'b1,1'b1,S_BYTE,WORD}:  lsda_lswb_ex3_vreg_sign_sel[14:0] = 15'h0010;
  {1'b1,1'b0,S_BYTE,DWORD}: lsda_lswb_ex3_vreg_sign_sel[14:0] = 15'h0020;
  {1'b1,1'b1,S_BYTE,DWORD}: lsda_lswb_ex3_vreg_sign_sel[14:0] = 15'h0040;
  {1'b1,1'b0,HALF,WORD}:  lsda_lswb_ex3_vreg_sign_sel[14:0] = 15'h0080;
  {1'b1,1'b1,HALF,WORD}:  lsda_lswb_ex3_vreg_sign_sel[14:0] = 15'h0100;
  {1'b1,1'b0,HALF,DWORD}: lsda_lswb_ex3_vreg_sign_sel[14:0] = 15'h0200;
  {1'b1,1'b1,HALF,DWORD}: lsda_lswb_ex3_vreg_sign_sel[14:0] = 15'h0400;
  {1'b1,1'b0,WORD,DWORD}: lsda_lswb_ex3_vreg_sign_sel[14:0] = 15'h0800;
  {1'b1,1'b1,WORD,DWORD}: lsda_lswb_ex3_vreg_sign_sel[14:0] = 15'h1000;
  {1'b0,1'b1,HALF,2'b??}: lsda_lswb_ex3_vreg_sign_sel[14:0] = 15'h2000;
  {1'b0,1'b1,WORD,2'b??}: lsda_lswb_ex3_vreg_sign_sel[14:0] = 15'h4000;
  default:lsda_lswb_ex3_vreg_sign_sel[14:0] = 15'h0001;         
endcase
// &CombEnd; @1474
end
assign lsda_lswb_ex3_inst_vls      = lsda_ex3_inst_vls;

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
// &Force("output","lsda_rb_ex3_create_judge_vld"); @1492
assign lsda_rb_ex3_create_judge_vld        = lsda_ex3_inst_vld
                                              &&  !ld_da_expt_vld_cancel
                                              &&  !ld_da_discard_dc_req
                                              &&  (ld_da_ld_inst &&  !ld_da_secd
                                                  ||  ld_da_atomic)
                                          ||  ld_da_borrow_mmu  &&  lsda_ex3_borrow_vld;

assign ld_da_rb_create_vld_unmask       = lsda_ex3_inst_vld
                                              &&  !rtu_lsu_flush_fe
                                              &&  !(rtu_ck_flush && rtu_ck_flush_iid_older_than_ex3_iid)  //flush younger ex3 rb_create_vld when no ecc stall, ck_flush@LTL
                                              &&  !ld_da_expt_vld_cancel
                                              &&  !ld_da_wait_fence_req
                                              &&  !ld_da_discard_dc_req
                                              &&  !ld_da_sq_fwd_ecc_discard
                                              &&  !lsda_ex3_us_discard
                                              &&  !ld_da_ecc_stall_data
                                              &&  (ld_da_ld_inst  
                                                      &&  !ld_da_secd 
                                                      &&  (!lsda_rb_ex3_data_vld
                                                          ||  lsda_ex3_boundary_after_mask)
                                                  ||  ld_da_ldamo_inst
                                                      &&  !ld_da_tcm_hit
                                                      &&  !ld_da_vector_nop
                                                  ||  ld_da_lr_inst
                                                      &&  !ld_da_data_vld)
                                          ||  ld_da_borrow_mmu
                                              &&  ld_da_dcache_miss
                                              &&  lsda_ex3_borrow_vld;

//------------------index hit/discard grnt signal-----------
//addr is used to compare index, so addr0 is enough
assign lsda_ex3_addr[`WK_PA_WIDTH-1:0]           = ld_da_addr0[`WK_PA_WIDTH-1:0];

assign ld_da_depd_rb = !lsda_ex3_page_so
                       && !ld_da_tcm_hit
                       && rb_lsda_ex3_hit_idx;

//because rb and lfb use a common wait queue, they can be granted simultaneously
assign ld_da_discard_from_rb_req  = ld_da_rb_create_vld_unmask
                                        &&  ld_da_depd_rb
                                    ||  ld_da_rb_merge_vld_unmask
                                        &&  (rb_lsda_merge_fail
                                            ||  ld_da_depd_rb
                                                &&  !lsda_rb_ex3_data_vld)
                                    ||  ld_da_tag_ecc_stall_ori
                                        &&  rb_lsda_ex3_hit_idx;

assign ld_da_discard_from_lfb_req = (ld_da_rb_create_vld_unmask
                                        ||  ld_da_rb_merge_vld_unmask
                                            && !lsda_rb_ex3_data_vld)
                                       &&  lsda_ex3_page_ca
                                       &&  lfb_lsda_hit_idx
                                    || ld_da_tag_ecc_stall_ori
                                       &&  lfb_lsda_hit_idx;

assign ld_da_discard_from_lm_req  = (ld_da_rb_create_vld_unmask
                                        ||  ld_da_rb_merge_vld_unmask
                                            && !lsda_rb_ex3_data_vld)
                                       &&  lsda_ex3_page_ca
                                       &&  lm_lsda_hit_idx
                                    || ld_da_tag_ecc_stall_ori
                                       &&  lm_lsda_hit_idx;

assign ld_da_hit_idx_discard_req  = ld_da_discard_from_rb_req
                                    ||  ld_da_discard_from_lfb_req
                                    ||  ld_da_discard_from_lm_req;

//because ld_da_hit_idx_discard_vld = ld_da_hit_idx_discard_req, then grnt
//signal needn't see ld_da_hit_idx_discard_vld
assign lsda_rb_ex3_discard_grnt      = ld_da_discard_from_rb_req;
assign lsda_lfb_discard_grnt     = ld_da_discard_from_lfb_req;
assign lsda_lm_ex3_discard_grnt      = ld_da_discard_from_lm_req;

//record lfb wakeup queue if hit index and create rb
// &Force("output","lsda_lfb_set_wakeup_queue"); @1565
assign lsda_lfb_set_wakeup_queue      = ld_da_hit_idx_discard_vld;
assign lsda_lfb_set_wakeup_queue_gate = ld_da_hit_idx_discard_req;

assign lsda_lfb_wakeup_queue_next[LSIQ_ENTRY:0]  = {lsda_mcic_borrow_mmu,
                                                    ld_da_mask_lsid[LSIQ_ENTRY-1:0]};

//------------------create read buffer info-----------------
// &Force("output","lsda_rb_ex3_create_vld"); @1573
assign lsda_rb_ex3_create_vld          = ld_da_rb_create_vld_unmask
                                      &&  !ld_da_rb_ecc_mask
                                      &&  !ld_da_hit_idx_discard_req;
// &Force("output","lsda_rb_ex3_create_dp_vld"); @1577
assign lsda_rb_ex3_create_dp_vld       = ld_da_rb_create_vld_unmask;
// &Force("output","lsda_rb_ex3_create_gateclk_en"); @1579
assign lsda_rb_ex3_create_gateclk_en   = ld_da_rb_create_vld_unmask;

assign lsda_ex3_special_gateclk_en     = lsda_ex3_inst_vld 
                                      || lsda_ex3_borrow_vld 
                                         && ld_da_borrow_mmu;
//-----------merge signal---------------
//merge signal is used for secd ld instruction
assign ld_da_rb_merge_vld_unmask    = lsda_ex3_inst_vld
                                      &&  !rtu_lsu_flush_fe
                                      &&  !(rtu_ck_flush && rtu_ck_flush_iid_older_than_ex3_iid)  //flush younger ex3 rb_merge_vld when no ecc stall, ck_flush@LTL
                                      &&  !ld_da_wait_fence_req
                                      &&  !ld_da_expt_vld_cancel
                                      &&  !ld_da_discard_dc_req
                                      &&  !ld_da_sq_fwd_ecc_discard
                                      &&  !ld_da_ecc_stall_data
                                      &&  !lsda_ex3_us_discard
                                      &&  ld_da_ld_inst
                                      &&  ld_da_secd
                                      &&  ld_da_boundary;
assign lsda_rb_ex3_merge_vld           = ld_da_rb_merge_vld_unmask
                                      &&  !ld_da_rb_ecc_mask
                                      &&  !ld_da_hit_idx_discard_req;

assign lsda_rb_ex3_merge_dp_vld        = ld_da_rb_merge_vld_unmask;
                                      
//for data merge
//assign ld_da_rb_merge_ecc_stall     = ld_da_ecc_data_req_mask;

//merge expt is for secd ld inst has exception
assign lsda_rb_ex3_merge_expt_vld      = lsda_ex3_inst_vld
                                      &&  ld_da_expt_vld_cancel
                                      &&  !ld_da_restart_vld
                                      &&  ld_da_ld_inst
                                      &&  ld_da_secd
                                      &&  ld_da_boundary;

assign lsda_rb_ex3_merge_gateclk_en    = ld_da_rb_merge_vld_unmask;

//-----------rb create signal-----------
//this inst will request lfb addr entry in rb
assign lsda_rb_ex3_create_lfb          = lsda_ex3_page_ca
                                      || !lsda_ex3_page_so && !ld_da_atomic;

assign lsda_rb_ex3_atomic              = lsda_ex3_inst_vld  &&  ld_da_atomic;
assign lsda_rb_ex3_ldamo               = lsda_ex3_inst_vld  &&  ld_da_ldamo_inst;
assign lsda_rb_ex3_cmplt_success       = lsda_ex3_borrow_vld
                                      ||  lsda_ex3_inst_vld
                                          &&  !ld_da_boundary_first
                                          &&  ld_da_inst_cmplt;
assign lsda_rb_ex3_dest_vld            = lsda_ex3_inst_vld;

//==========================================================
//        Compare index
//==========================================================
//it's for the corner condition of read buffer creating port
//if both ld_da & st_da create rb and their index are the same
//------------------compare st_da stage---------------------
assign ld_da_cmp_st_da_addr[`WK_PA_WIDTH-1:0] = lsda_selfda_ex3_addr[`WK_PA_WIDTH-1:0];
assign selfda_lsda_ex3_hit_idx      = (ld_da_rb_create_vld_unmask
                                      ||  ld_da_rb_merge_vld_unmask)
                                  &&  (lsda_ex3_idx[7:0] ==  ld_da_cmp_st_da_addr[13:6]);
//------------------compare pfu-----------------------------
//if timing is not enough, change ld_da_rb_create_vld_unmask to judge
assign ld_da_cmp_pfu_biu_req_addr[`WK_PA_WIDTH-1:0] = pfu_biu_req_addr[`WK_PA_WIDTH-1:0];
assign lsda_pfu_ex3_biu_req_hit_idx  = (ld_da_rb_create_vld_unmask
                                        ||  ld_da_rb_merge_vld_unmask)
                                    &&  (lsda_ex3_idx[7:0]
                                        ==  ld_da_cmp_pfu_biu_req_addr[13:6]);
//==========================================================
//        Generage commit signal
//==========================================================
assign ld_da_cmit_hit0  = {rtu_yy_xx_commit0,rtu_yy_xx_commit0_iid[IID_WIDTH-1:0]}
                          ==  {1'b1,lsda_ex3_iid[IID_WIDTH-1:0]};
assign ld_da_cmit_hit1  = {rtu_yy_xx_commit1,rtu_yy_xx_commit1_iid[IID_WIDTH-1:0]}
                          ==  {1'b1,lsda_ex3_iid[IID_WIDTH-1:0]};
assign ld_da_cmit_hit2  = {rtu_yy_xx_commit2,rtu_yy_xx_commit2_iid[IID_WIDTH-1:0]}
                          ==  {1'b1,lsda_ex3_iid[IID_WIDTH-1:0]};
assign ld_da_cmit_hit3  = {rtu_yy_xx_commit3,rtu_yy_xx_commit3_iid[IID_WIDTH-1:0]}
                          ==  {1'b1,lsda_ex3_iid[IID_WIDTH-1:0]};
assign ld_da_cmit_hit4  = {rtu_yy_xx_commit4,rtu_yy_xx_commit4_iid[IID_WIDTH-1:0]}
                          ==  {1'b1,lsda_ex3_iid[IID_WIDTH-1:0]};
assign ld_da_cmit_hit5  = {rtu_yy_xx_commit5,rtu_yy_xx_commit5_iid[IID_WIDTH-1:0]}
                          ==  {1'b1,lsda_ex3_iid[IID_WIDTH-1:0]};
assign ld_da_cmit_hit6  = {rtu_yy_xx_commit6,rtu_yy_xx_commit6_iid[IID_WIDTH-1:0]}
                          ==  {1'b1,lsda_ex3_iid[IID_WIDTH-1:0]};
assign ld_da_cmit_hit7  = {rtu_yy_xx_commit7,rtu_yy_xx_commit7_iid[IID_WIDTH-1:0]}
                          ==  {1'b1,lsda_ex3_iid[IID_WIDTH-1:0]};
assign lsda_rb_ex3_cmit    = ld_da_cmit_hit0
                          ||  ld_da_cmit_hit1
                          ||  ld_da_cmit_hit2
                          ||  ld_da_cmit_hit3
                          ||  ld_da_cmit_hit4
                          ||  ld_da_cmit_hit5
                          ||  ld_da_cmit_hit6
                          ||  ld_da_cmit_hit7;

//==========================================================
//        Restart signal
//==========================================================
assign ld_da_fwd_sq_bypass_vld      = ld_da_fwd_sq_bypass
                                      &&  (std0_ex1_inst_vld && !ld_da_fwd_sq_bypass_sel
                                          || std1_ex1_inst_vld && ld_da_fwd_sq_bypass_sel);  //std-> std0&&!sel || std1&&sel, LTL@20241114
assign ld_da_data_discard_sq_final  = ld_da_data_discard_sq
                                      ||  ld_da_fwd_sq_bypass
                                          &&  !(std0_ex1_inst_vld && !ld_da_fwd_sq_bypass_sel   //std-> std0&&!sel || std1&&sel, LTL@20241114
                                              || std1_ex1_inst_vld && ld_da_fwd_sq_bypass_sel);
assign ld_da_fwd_sq_multi_final     = ld_da_fwd_sq_multi
                                          &&  !ld_da_fwd_sq_multi_mask
                                      ||  ld_da_fwd_bypass_sq_multi;
assign ld_da_discard_wmb_final      = !lsda_ex3_page_ca
                                          &&  !ld_da_tcm_hit
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
assign ld_da_other_discard_sq_req = lsda_ex3_inst_vld
                                    &&  ld_da_other_discard_sq;
assign ld_da_data_discard_sq_req  = lsda_ex3_inst_vld
                                    &&  ld_da_data_discard_sq_final;
assign ld_da_fwd_sq_multi_req     = lsda_ex3_inst_vld
                                    &&  ld_da_fwd_sq_multi_final;
assign ld_da_discard_wmb_req      = lsda_ex3_inst_vld
                                    &&  ld_da_discard_wmb_final;
assign ld_da_wait_fence_req       = lsda_ex3_inst_vld
//                                    &&  ld_da_ld_inst
                                    &&  ld_da_data_vld
                                    &&  ld_da_wait_fence;
assign ld_da_rb_full_req          = lsda_rb_ex3_create_vld
                                    &&  rb_lsda_ex3_full;

assign ld_da_other_discard_sq_vld = ld_da_other_discard_sq_req;
assign lsda_sq_ex3_data_discard_vld  = !ld_da_other_discard_sq_req
                                    &&  ld_da_data_discard_sq_req;
// &Force("output","lsda_sq_ex3_fwd_multi_vld"); @1706
assign lsda_sq_ex3_fwd_multi_vld     = !ld_da_other_discard_sq_req
                                    &&  !ld_da_data_discard_sq_req
                                    &&  ld_da_fwd_sq_multi_req;
assign lsda_wmb_discard_vld      = !ld_da_other_discard_sq_req
                                    &&  !ld_da_fwd_sq_multi_req
                                    &&  !ld_da_data_discard_sq_req
                                    &&  ld_da_discard_wmb_req;
assign ld_da_wait_fence_vld         = !ld_da_other_discard_sq_req
                                    &&  !ld_da_fwd_sq_multi_req
                                    &&  !ld_da_data_discard_sq_req
                                    &&  !ld_da_discard_wmb_req
                                    &&  ld_da_wait_fence_req;
assign lsda_ex3_wait_fence_gateclk_en  = ld_da_wait_fence_req;
//this logic may be redundant, ld_da_hit_idx_discard_req
//needn't judge other condition, because this signal has already see other
//signals
assign ld_da_hit_idx_discard_vld  = ld_da_hit_idx_discard_req
                                    && !ld_da_ecc_stall;
assign ld_da_rb_full_vld          = !ld_da_other_discard_sq_req
                                    &&  !ld_da_fwd_sq_multi_req
                                    &&  !ld_da_data_discard_sq_req
                                    &&  !ld_da_discard_wmb_req
                                    &&  !ld_da_wait_fence_req
                                    &&  !ld_da_hit_idx_discard_req
                                    &&  ld_da_rb_full_req;
assign lsda_ex3_rb_full_gateclk_en   = lsda_rb_ex3_create_gateclk_en
                                    &&  rb_lsda_ex3_full;
assign ld_da_us_discard_req       = lsda_ex3_us_discard
                                    &&  !ld_da_other_discard_sq_req
                                    &&  !ld_da_fwd_sq_multi_req
                                    &&  !ld_da_data_discard_sq_req
                                    &&  !ld_da_discard_wmb_req
                                    &&  !ld_da_wait_fence_req
                                    &&  !ld_da_hit_idx_discard_req
                                    &&  !ld_da_rb_full_req;
assign ld_da_restart_vld          = ld_da_other_discard_sq_req
                                    ||  ld_da_fwd_sq_multi_req
                                    ||  ld_da_data_discard_sq_req
                                    ||  ld_da_discard_wmb_req
                                    ||  ld_da_hit_idx_discard_req
                                    ||  ld_da_rb_full_req
                                    ||  lsda_ex3_us_discard
                                    ||  ld_da_wait_fence_req;

//interface to sq
assign lsda_sq_ex3_global_discard_vld= ld_da_other_discard_sq_vld
                                    ||  lsda_sq_ex3_fwd_multi_vld;

//partial restart with fast timing
assign ld_da_restart_no_cache = ld_da_other_discard_sq
                                || ld_da_data_discard_sq_final
                                || ld_da_fwd_sq_multi_final
                                || ld_da_discard_wmb_final 
                                || lsda_ex3_us_discard
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
assign tcm_rdata[127:0] = ld_da_dtcm_hit
                          ? dtcm_rdata[127:0]
                          : itcm_rdata[127:0];

assign ld_da_bytes_vld_ext[127:0]  = {{8{lsda_ex3_bytes_vld[15]}}  
                                     ,{8{lsda_ex3_bytes_vld[14]}}  
                                     ,{8{lsda_ex3_bytes_vld[13]}}  
                                     ,{8{lsda_ex3_bytes_vld[12]}}  
                                     ,{8{lsda_ex3_bytes_vld[11]}}  
                                     ,{8{lsda_ex3_bytes_vld[10]}}  
                                     ,{8{lsda_ex3_bytes_vld[9]}}   
                                     ,{8{lsda_ex3_bytes_vld[8]}}   
                                     ,{8{lsda_ex3_bytes_vld[7]}}   
                                     ,{8{lsda_ex3_bytes_vld[6]}}   
                                     ,{8{lsda_ex3_bytes_vld[5]}}   
                                     ,{8{lsda_ex3_bytes_vld[4]}}   
                                     ,{8{lsda_ex3_bytes_vld[3]}}   
                                     ,{8{lsda_ex3_bytes_vld[2]}}   
                                     ,{8{lsda_ex3_bytes_vld[1]}}   
                                     ,{8{lsda_ex3_bytes_vld[0]}}}; 

assign ld_da_tcm_data128_am[127:0] = ld_da_bytes_vld_ext[127:0] & tcm_rdata[127:0];

assign tcm_1bit_err = itcm_1bit_err | dtcm_1bit_err;
// &Force("nonport","itcm_1bit_err"); @1821
// &Force("nonport","dtcm_1bit_err"); @1822
//----------------------------------------------------------
//                       ECC control
//----------------------------------------------------------
assign ld_da_tcm_ecc_stall_ori = lsda_ex3_inst_vld
                                 && ld_da_tcm_hit
                                 && !ld_da_vector_nop
                                 && !ld_da_expt_vld_cancel
                                 && !ld_da_restart_no_cache
                                 && !ld_da_fwd_no_cache
                                 && !rtu_lsu_flush_fe
                                 &&  !(rtu_ck_flush && rtu_ck_flush_iid_older_than_ex3_iid) //flush younger ex3 ecc stall, ck_flush@LTL
                                 && !ld_da_ecc_stall_already
                                 && tcm_1bit_err;

assign ld_da_tcm_rb_restart = ld_da_rb_create_vld_unmask 
                                 && rb_lsda_ex3_full
                              || ld_da_rb_merge_vld_unmask
                                 && rb_lsda_merge_fail;
assign ld_da_tcm_ecc_stall  = ld_da_tcm_ecc_stall_ori && !ld_da_tcm_rb_restart;

assign ld_da_tcm_ecc_stall_gate = lsda_ex3_inst_vld
                                  && ld_da_tcm_hit
                                  && !ld_da_vector_nop
                                  && !ld_da_expt_vld_cancel
                                  && !ld_da_restart_no_cache
                                  && !ld_da_fwd_no_cache
                                  && !ld_da_ecc_stall_already;
//==========================================================
//                    Settle data
//==========================================================
//------------------settle data to register mode------------
//rot_set signal is set in da stage and plays a role in wb stage

//==========================================================
//                    ECC handling
//==========================================================
assign ld_dc_tag_inj_vld  = cp0_lsu_tag_ecc_inj 
                            && lsdc_lsda_ex2_tag_inj_dp 
                            && !lda0_lsda_ex3_tag_inj_mask   //tag inj mask, 3 must 2 0 and 1 1, tag can inj, LTL@20241203   
                            && !lsda_lsda_ex3_tag_inj_mask 
                            && !lsu_lsda_tag_inj_cmplt;
assign ld_dc_data_inj_vld = cp0_lsu_data_ecc_inj 
                            && lsdc_lsda_ex2_data_inj_dp 
                            && !lsu_lsda_data_inj_cmplt; 
//for tag ecc_inj
assign dcache_ld_tag_dout[`WK_LS_DCACHE_LDTAG_WIDTH-1:0] = ld_dc_tag_inj_vld
                                  ? dcache_lsda_ex2_tag_dout[`WK_LS_DCACHE_LDTAG_WIDTH-1:0] ^ {4{cp0_lsu_tag_random0[`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0]}}  //double, LTL@20250322
                                  : dcache_lsda_ex2_tag_dout[`WK_LS_DCACHE_LDTAG_WIDTH-1:0];


//for timing

assign dcache_data_bank0[38:0] = ld_dc_data_inj_vld
                                 ? dcache_lsda_ex2_data_bank0_dout[38:0] ^ cp0_lsu_data_random[38:0]
                                 : dcache_lsda_ex2_data_bank0_dout[38:0];

assign dcache_data_bank1[38:0] = ld_dc_data_inj_vld
                                 ? dcache_lsda_ex2_data_bank1_dout[38:0] ^ cp0_lsu_data_random[38:0]
                                 : dcache_lsda_ex2_data_bank1_dout[38:0];

assign dcache_data_bank2[38:0] = ld_dc_data_inj_vld
                                 ? dcache_lsda_ex2_data_bank2_dout[38:0] ^ cp0_lsu_data_random[38:0]
                                 : dcache_lsda_ex2_data_bank2_dout[38:0];

assign dcache_data_bank3[38:0] = ld_dc_data_inj_vld
                                 ? dcache_lsda_ex2_data_bank3_dout[38:0] ^ cp0_lsu_data_random[38:0]
                                 : dcache_lsda_ex2_data_bank3_dout[38:0]; 

assign dcache_data_bank4[38:0] = ld_dc_data_inj_vld
                                 ? dcache_lsda_ex2_data_bank4_dout[38:0] ^ cp0_lsu_data_random[38:0]
                                 : dcache_lsda_ex2_data_bank4_dout[38:0];

assign dcache_data_bank5[38:0] = ld_dc_data_inj_vld
                                 ? dcache_lsda_ex2_data_bank5_dout[38:0] ^ cp0_lsu_data_random[38:0]
                                 : dcache_lsda_ex2_data_bank5_dout[38:0];

assign dcache_data_bank6[38:0] = ld_dc_data_inj_vld
                                 ? dcache_lsda_ex2_data_bank6_dout[38:0] ^ cp0_lsu_data_random[38:0]
                                 : dcache_lsda_ex2_data_bank6_dout[38:0];

assign dcache_data_bank7[38:0] = ld_dc_data_inj_vld
                                 ? dcache_lsda_ex2_data_bank7_dout[38:0] ^ cp0_lsu_data_random[38:0]
                                 : dcache_lsda_ex2_data_bank7_dout[38:0];   
assign dcache_data_bank8[38:0] = ld_dc_data_inj_vld
                                 ? dcache_lsda_ex2_data_bank8_dout[38:0] ^ cp0_lsu_data_random[38:0]
                                 : dcache_lsda_ex2_data_bank8_dout[38:0];

assign dcache_data_bank9[38:0] = ld_dc_data_inj_vld
                                 ? dcache_lsda_ex2_data_bank9_dout[38:0] ^ cp0_lsu_data_random[38:0]
                                 : dcache_lsda_ex2_data_bank9_dout[38:0];

assign dcache_data_bank10[38:0] = ld_dc_data_inj_vld
                                 ? dcache_lsda_ex2_data_bank10_dout[38:0] ^ cp0_lsu_data_random[38:0]
                                 : dcache_lsda_ex2_data_bank10_dout[38:0];

assign dcache_data_bank11[38:0] = ld_dc_data_inj_vld
                                 ? dcache_lsda_ex2_data_bank11_dout[38:0] ^ cp0_lsu_data_random[38:0]
                                 : dcache_lsda_ex2_data_bank11_dout[38:0]; 

assign dcache_data_bank12[38:0] = ld_dc_data_inj_vld
                                 ? dcache_lsda_ex2_data_bank12_dout[38:0] ^ cp0_lsu_data_random[38:0]
                                 : dcache_lsda_ex2_data_bank12_dout[38:0];

assign dcache_data_bank13[38:0] = ld_dc_data_inj_vld
                                 ? dcache_lsda_ex2_data_bank13_dout[38:0] ^ cp0_lsu_data_random[38:0]
                                 : dcache_lsda_ex2_data_bank13_dout[38:0];

assign dcache_data_bank14[38:0] = ld_dc_data_inj_vld
                                 ? dcache_lsda_ex2_data_bank14_dout[38:0] ^ cp0_lsu_data_random[38:0]
                                 : dcache_lsda_ex2_data_bank14_dout[38:0];

assign dcache_data_bank15[38:0] = ld_dc_data_inj_vld
                                 ? dcache_lsda_ex2_data_bank15_dout[38:0] ^ cp0_lsu_data_random[38:0]
                                 : dcache_lsda_ex2_data_bank15_dout[38:0];
//------------------tag ecc check------------
assign tag_bf_ecc[`WK_LS_DCACHE_LDTAG_WIDTH-1:0] = dcache_ld_tag_dout[`WK_LS_DCACHE_LDTAG_WIDTH-1:0];

assign w0_tag_bf_ecc[`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0] = tag_bf_ecc[`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0];
assign w1_tag_bf_ecc[`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0] = tag_bf_ecc[`WK_LS_DCACHE_DOUBLE_LDTAG_WIDTH-1:`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH];
assign w2_tag_bf_ecc[`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0] = tag_bf_ecc[`WK_LS_DCACHE_TRIPLE_LDTAG_WIDTH-1:`WK_LS_DCACHE_DOUBLE_LDTAG_WIDTH];
assign w3_tag_bf_ecc[`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0] = tag_bf_ecc[`WK_LS_DCACHE_LDTAG_WIDTH-1       :`WK_LS_DCACHE_TRIPLE_LDTAG_WIDTH];

assign tag_ecc_pipe_down = (lsdc_ex2_inst_vld  ||  lsdc_lsda_ex2_borrow_vld && lsdc_lsda_ex2_borrow_mmu) //dc_da_inst_vld-> dc_inst_vld, timing@LTL
                            && !ld_da_ecc_stall;
 
`ifdef WK_PA_WIDTH_40
// &Instance("xx_lsu_27bit_2stage_ecc_decode","x_xx_lsu_27bit_2stage_ecc_decode_w0"); @1918
xx_lsu_27bit_2stage_ecc_decode  x_xx_lsu_27bit_2stage_ecc_decode_w0 (
  .corrected_data         (w0_tag_corrected[`WK_LS_DCACHE_LDTAG_BF_ECC_LENGTH-1:0]),
  .cpurst_b               (cpurst_b              ),
  .data_decode            (w0_tag_bf_ecc[`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0]   ),
  .ecc_stage_vld          (tag_ecc_pipe_down     ),
  .ham_error              (w0_tag_ham_error      ),
  .parity_error           (w0_tag_parity_error   ),
  .stage_dp_clk           (ld_da_clk             )
);
// &Instance("xx_lsu_27bit_2stage_ecc_decode","x_xx_lsu_27bit_2stage_ecc_decode_w1"); @1927
xx_lsu_27bit_2stage_ecc_decode  x_xx_lsu_27bit_2stage_ecc_decode_w1 (
  .corrected_data         (w1_tag_corrected[`WK_LS_DCACHE_LDTAG_BF_ECC_LENGTH-1:0]),
  .cpurst_b               (cpurst_b              ),
  .data_decode            (w1_tag_bf_ecc[`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0]   ),
  .ecc_stage_vld          (tag_ecc_pipe_down     ),
  .ham_error              (w1_tag_ham_error      ),
  .parity_error           (w1_tag_parity_error   ),
  .stage_dp_clk           (ld_da_clk             )
);
xx_lsu_27bit_2stage_ecc_decode  x_xx_lsu_27bit_2stage_ecc_decode_w2 (
  .corrected_data         (w2_tag_corrected[`WK_LS_DCACHE_LDTAG_BF_ECC_LENGTH-1:0]),
  .cpurst_b               (cpurst_b              ),
  .data_decode            (w2_tag_bf_ecc[`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0]   ),
  .ecc_stage_vld          (tag_ecc_pipe_down     ),
  .ham_error              (w2_tag_ham_error      ),
  .parity_error           (w2_tag_parity_error   ),
  .stage_dp_clk           (ld_da_clk             )
);
xx_lsu_27bit_2stage_ecc_decode  x_xx_lsu_27bit_2stage_ecc_decode_w3 (
  .corrected_data         (w3_tag_corrected[`WK_LS_DCACHE_LDTAG_BF_ECC_LENGTH-1:0]),
  .cpurst_b               (cpurst_b              ),
  .data_decode            (w3_tag_bf_ecc[`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0]   ),
  .ecc_stage_vld          (tag_ecc_pipe_down     ),
  .ham_error              (w3_tag_ham_error      ),
  .parity_error           (w3_tag_parity_error   ),
  .stage_dp_clk           (ld_da_clk             )
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
  .stage_dp_clk           (ld_da_clk             )
);
// &Instance("xx_lsu_31bit_2stage_ecc_decode","x_xx_lsu_31bit_2stage_ecc_decode_w1"); @1927
xx_lsu_35bit_2stage_ecc_decode  x_xx_lsu_35bit_2stage_ecc_decode_w1 (
  .corrected_data         (w1_tag_corrected[`WK_LS_DCACHE_LDTAG_BF_ECC_LENGTH-1:0]),
  .cpurst_b               (cpurst_b              ),
  .data_decode            (w1_tag_bf_ecc[`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0]   ),
  .ecc_stage_vld          (tag_ecc_pipe_down     ),
  .ham_error              (w1_tag_ham_error      ),
  .parity_error           (w1_tag_parity_error   ),
  .stage_dp_clk           (ld_da_clk             )
);
xx_lsu_35bit_2stage_ecc_decode  x_xx_lsu_35bit_2stage_ecc_decode_w2 (
  .corrected_data         (w2_tag_corrected[`WK_LS_DCACHE_LDTAG_BF_ECC_LENGTH-1:0]),
  .cpurst_b               (cpurst_b              ),
  .data_decode            (w2_tag_bf_ecc[`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0]   ),
  .ecc_stage_vld          (tag_ecc_pipe_down     ),
  .ham_error              (w2_tag_ham_error      ),
  .parity_error           (w2_tag_parity_error   ),
  .stage_dp_clk           (ld_da_clk             )
);
xx_lsu_35bit_2stage_ecc_decode  x_xx_lsu_35bit_2stage_ecc_decode_w3 (
  .corrected_data         (w3_tag_corrected[`WK_LS_DCACHE_LDTAG_BF_ECC_LENGTH-1:0]),
  .cpurst_b               (cpurst_b              ),
  .data_decode            (w3_tag_bf_ecc[`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0]   ),
  .ecc_stage_vld          (tag_ecc_pipe_down     ),
  .ham_error              (w3_tag_ham_error      ),
  .parity_error           (w3_tag_parity_error   ),
  .stage_dp_clk           (ld_da_clk             )
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

assign ld_da_tag_ecc_vld = lsda_ex3_page_ca
                           && cp0_lsu_dcache_en
                           && cp0_lsu_ecc_en
                           && (!w0_ecc_free || !w1_ecc_free || !w2_ecc_free || !w3_ecc_free);

assign ld_da_tag_ecc_err = lsda_ex3_page_ca 
                           && cp0_lsu_dcache_en
                           && cp0_lsu_ecc_en
                           && (w0_ecc_fatal || w1_ecc_fatal || w2_ecc_fatal || w3_ecc_fatal);

//when 1-bit err,need to stall pipe to handle it
assign ld_da_fwd_no_cache     = ld_da_fwd_sq_vld || ld_da_fwd_sq_bypass_vld;

assign ld_da_tag_ecc_stall_ori = (lsda_ex3_inst_vld
                                     && !ld_da_vector_nop
                                     && !ld_da_expt_vld_cancel
                                     && !ld_da_restart_no_cache
                                     && !ld_da_fwd_no_cache
                                     && !rtu_lsu_flush_fe
                                     && !(rtu_ck_flush && rtu_ck_flush_iid_older_than_ex3_iid)  //flush younger ex3 ecc stall, ck_flush@LTL
                                  || lsda_ex3_borrow_vld 
                                     && ld_da_borrow_mmu)
                                 && !ld_da_ecc_stall_already
                                 && ld_da_tag_ecc_vld;

assign ld_da_tag_ecc_stall     = ld_da_tag_ecc_stall_ori
                                 && !rb_lsda_ex3_hit_idx
                                 && !lfb_lsda_hit_idx
                                 && !lm_lsda_hit_idx;

assign ld_da_tag_ecc_stall_gate  = ld_da_tag_ecc_stall_ori;

//fix info
assign ld_da_dcache_tag_corrected[`WK_LS_DCACHE_LDTAG_QUADRUPLE_BF_ECC_LENGTH-1:0] = {w3_tag_corrected[`WK_LS_DCACHE_LDTAG_BF_ECC_LENGTH-1:0],
                                                                                      w2_tag_corrected[`WK_LS_DCACHE_LDTAG_BF_ECC_LENGTH-1:0],
                                                                                      w1_tag_corrected[`WK_LS_DCACHE_LDTAG_BF_ECC_LENGTH-1:0],
                                                                                      w0_tag_corrected[`WK_LS_DCACHE_LDTAG_BF_ECC_LENGTH-1:0]};

assign ld_da_ecc_hit_way0   = w0_tag_corrected[`WK_LS_DCACHE_LDTAG_BF_ECC_LENGTH-1]
                              &&  cp0_lsu_dcache_en
                              &&  lsda_ex3_page_ca
                              &&  (ld_da_addr0[`WK_PA_WIDTH-1:14] == w0_tag_corrected[`WK_LS_DCACHE_SINGLE_TAG_WIDTH-1:0]);

assign ld_da_ecc_hit_way1   = w1_tag_corrected[`WK_LS_DCACHE_LDTAG_BF_ECC_LENGTH-1]
                              &&  cp0_lsu_dcache_en
                              &&  lsda_ex3_page_ca
                              &&  (ld_da_addr0[`WK_PA_WIDTH-1:14] == w1_tag_corrected[`WK_LS_DCACHE_SINGLE_TAG_WIDTH-1:0]);

assign ld_da_ecc_hit_way2   = w2_tag_corrected[`WK_LS_DCACHE_LDTAG_BF_ECC_LENGTH-1]
                              &&  cp0_lsu_dcache_en
                              &&  lsda_ex3_page_ca
                              &&  (ld_da_addr0[`WK_PA_WIDTH-1:14] == w2_tag_corrected[`WK_LS_DCACHE_SINGLE_TAG_WIDTH-1:0]);

assign ld_da_ecc_hit_way3   = w3_tag_corrected[`WK_LS_DCACHE_LDTAG_BF_ECC_LENGTH-1]
                              &&  cp0_lsu_dcache_en
                              &&  lsda_ex3_page_ca
                              &&  (ld_da_addr0[`WK_PA_WIDTH-1:14] == w3_tag_corrected[`WK_LS_DCACHE_SINGLE_TAG_WIDTH-1:0]);

assign ld_da_ecc_dcache_hit = ld_da_ecc_hit_way0 || ld_da_ecc_hit_way1 || ld_da_ecc_hit_way2 || ld_da_ecc_hit_way3;

//assign ld_da_ecc_hit_low_region  = ld_da_addr0[4]
//                                   ? ld_da_ecc_hit_way1
//                                   : ld_da_ecc_hit_way0;
//
//assign ld_da_ecc_hit_high_region = ld_da_addr0[4]
//                                   ? ld_da_ecc_hit_way0
//                                   : ld_da_ecc_hit_way1;
always @(*)
begin
  case(ld_da_addr0[5:4])
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
assign data_bank0_bf_ecc[38:0] = ld_da_dcache_data_bank0[38:0];
assign data_bank1_bf_ecc[38:0] = ld_da_dcache_data_bank1[38:0];
assign data_bank2_bf_ecc[38:0] = ld_da_dcache_data_bank2[38:0];
assign data_bank3_bf_ecc[38:0] = ld_da_dcache_data_bank3[38:0];
assign data_bank4_bf_ecc[38:0] = ld_da_dcache_data_bank4[38:0];
assign data_bank5_bf_ecc[38:0] = ld_da_dcache_data_bank5[38:0];
assign data_bank6_bf_ecc[38:0] = ld_da_dcache_data_bank6[38:0];
assign data_bank7_bf_ecc[38:0] = ld_da_dcache_data_bank7[38:0];
assign data_bank8_bf_ecc[38:0] = ld_da_dcache_data_bank8[38:0];
assign data_bank9_bf_ecc[38:0] = ld_da_dcache_data_bank9[38:0];
assign data_bank10_bf_ecc[38:0] = ld_da_dcache_data_bank10[38:0];
assign data_bank11_bf_ecc[38:0] = ld_da_dcache_data_bank11[38:0];
assign data_bank12_bf_ecc[38:0] = ld_da_dcache_data_bank12[38:0];
assign data_bank13_bf_ecc[38:0] = ld_da_dcache_data_bank13[38:0];
assign data_bank14_bf_ecc[38:0] = ld_da_dcache_data_bank14[38:0];
assign data_bank15_bf_ecc[38:0] = ld_da_dcache_data_bank15[38:0];
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
                            && ld_da_get_dcache_data[0]
                            && !ld_da_ecc_stall_data
                            && !(!data_bank0_ham_error && !data_bank0_parity_error);
assign data_bank0_ecc_err = cp0_lsu_ecc_en
                            && ld_da_get_dcache_data[0]
                            && !ld_da_ecc_stall_data
                            && data_bank0_ham_error 
                            && !data_bank0_parity_error;
assign data_bank1_ecc_vld = cp0_lsu_ecc_en
                            && ld_da_get_dcache_data[1]
                            && !ld_da_ecc_stall_data
                            && !(!data_bank1_ham_error && !data_bank1_parity_error);
assign data_bank1_ecc_err = cp0_lsu_ecc_en
                            && ld_da_get_dcache_data[1]
                            && !ld_da_ecc_stall_data
                            && data_bank1_ham_error 
                            && !data_bank1_parity_error;
assign data_bank2_ecc_vld = cp0_lsu_ecc_en
                            && ld_da_get_dcache_data[2]
                            && !ld_da_ecc_stall_data
                            && !(!data_bank2_ham_error && !data_bank2_parity_error);
assign data_bank2_ecc_err = cp0_lsu_ecc_en
                            && ld_da_get_dcache_data[2]
                            && !ld_da_ecc_stall_data
                            && data_bank2_ham_error 
                            && !data_bank2_parity_error;
assign data_bank3_ecc_vld = cp0_lsu_ecc_en
                            && ld_da_get_dcache_data[3]
                            && !ld_da_ecc_stall_data
                            && !(!data_bank3_ham_error && !data_bank3_parity_error);
assign data_bank3_ecc_err = cp0_lsu_ecc_en
                            && ld_da_get_dcache_data[3]
                            && !ld_da_ecc_stall_data
                            && data_bank3_ham_error 
                            && !data_bank3_parity_error;
assign data_bank4_ecc_vld = cp0_lsu_ecc_en
                            && ld_da_get_dcache_data[0]
                            && !ld_da_ecc_stall_data
                            && !(!data_bank4_ham_error && !data_bank4_parity_error);
assign data_bank4_ecc_err = cp0_lsu_ecc_en
                            && ld_da_get_dcache_data[0]
                            && !ld_da_ecc_stall_data
                            && data_bank4_ham_error 
                            && !data_bank4_parity_error;
assign data_bank5_ecc_vld = cp0_lsu_ecc_en
                            && ld_da_get_dcache_data[1]
                            && !ld_da_ecc_stall_data
                            && !(!data_bank5_ham_error && !data_bank5_parity_error);
assign data_bank5_ecc_err = cp0_lsu_ecc_en
                            && ld_da_get_dcache_data[1]
                            && !ld_da_ecc_stall_data
                            && data_bank5_ham_error 
                            && !data_bank5_parity_error;
assign data_bank6_ecc_vld = cp0_lsu_ecc_en
                            && ld_da_get_dcache_data[2]
                            && !ld_da_ecc_stall_data
                            && !(!data_bank6_ham_error && !data_bank6_parity_error);
assign data_bank6_ecc_err = cp0_lsu_ecc_en
                            && ld_da_get_dcache_data[2]
                            && !ld_da_ecc_stall_data
                            && data_bank6_ham_error 
                            && !data_bank6_parity_error;
assign data_bank7_ecc_vld = cp0_lsu_ecc_en
                            && ld_da_get_dcache_data[3]
                            && !ld_da_ecc_stall_data
                            && !(!data_bank7_ham_error && !data_bank7_parity_error);
assign data_bank7_ecc_err = cp0_lsu_ecc_en
                            && ld_da_get_dcache_data[3]
                            && !ld_da_ecc_stall_data
                            && data_bank7_ham_error 
                            && !data_bank7_parity_error;
assign data_bank8_ecc_vld = cp0_lsu_ecc_en
                            && ld_da_get_dcache_data[0]
                            && !ld_da_ecc_stall_data
                            && !(!data_bank8_ham_error && !data_bank8_parity_error);
assign data_bank8_ecc_err = cp0_lsu_ecc_en
                            && ld_da_get_dcache_data[0]
                            && !ld_da_ecc_stall_data
                            && data_bank8_ham_error 
                            && !data_bank8_parity_error;
assign data_bank9_ecc_vld = cp0_lsu_ecc_en
                            && ld_da_get_dcache_data[1]
                            && !ld_da_ecc_stall_data
                            && !(!data_bank9_ham_error && !data_bank9_parity_error);
assign data_bank9_ecc_err = cp0_lsu_ecc_en
                            && ld_da_get_dcache_data[1]
                            && !ld_da_ecc_stall_data
                            && data_bank9_ham_error 
                            && !data_bank9_parity_error;
assign data_bank10_ecc_vld = cp0_lsu_ecc_en
                            && ld_da_get_dcache_data[2]
                            && !ld_da_ecc_stall_data
                            && !(!data_bank10_ham_error && !data_bank10_parity_error);
assign data_bank10_ecc_err = cp0_lsu_ecc_en
                            && ld_da_get_dcache_data[2]
                            && !ld_da_ecc_stall_data
                            && data_bank10_ham_error 
                            && !data_bank10_parity_error;
assign data_bank11_ecc_vld = cp0_lsu_ecc_en
                            && ld_da_get_dcache_data[3]
                            && !ld_da_ecc_stall_data
                            && !(!data_bank11_ham_error && !data_bank11_parity_error);
assign data_bank11_ecc_err = cp0_lsu_ecc_en
                            && ld_da_get_dcache_data[3]
                            && !ld_da_ecc_stall_data
                            && data_bank11_ham_error 
                            && !data_bank11_parity_error;
assign data_bank12_ecc_vld = cp0_lsu_ecc_en
                            && ld_da_get_dcache_data[0]
                            && !ld_da_ecc_stall_data
                            && !(!data_bank12_ham_error && !data_bank12_parity_error);
assign data_bank12_ecc_err = cp0_lsu_ecc_en
                            && ld_da_get_dcache_data[0]
                            && !ld_da_ecc_stall_data
                            && data_bank12_ham_error 
                            && !data_bank12_parity_error;
assign data_bank13_ecc_vld = cp0_lsu_ecc_en
                            && ld_da_get_dcache_data[1]
                            && !ld_da_ecc_stall_data
                            && !(!data_bank13_ham_error && !data_bank13_parity_error);
assign data_bank13_ecc_err = cp0_lsu_ecc_en
                            && ld_da_get_dcache_data[1]
                            && !ld_da_ecc_stall_data
                            && data_bank13_ham_error 
                            && !data_bank13_parity_error;
assign data_bank14_ecc_vld = cp0_lsu_ecc_en
                            && ld_da_get_dcache_data[2]
                            && !ld_da_ecc_stall_data
                            && !(!data_bank14_ham_error && !data_bank14_parity_error);
assign data_bank14_ecc_err = cp0_lsu_ecc_en
                            && ld_da_get_dcache_data[2]
                            && !ld_da_ecc_stall_data
                            && data_bank14_ham_error 
                            && !data_bank14_parity_error;
assign data_bank15_ecc_vld = cp0_lsu_ecc_en
                            && ld_da_get_dcache_data[3]
                            && !ld_da_ecc_stall_data
                            && !(!data_bank15_ham_error && !data_bank15_parity_error);
assign data_bank15_ecc_err = cp0_lsu_ecc_en
                            && ld_da_get_dcache_data[3]
                            && !ld_da_ecc_stall_data
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
assign data_2_region_ecc_vld  = data_bank8_ecc_vld
                                  || data_bank9_ecc_vld
                                  || data_bank10_ecc_vld
                                  || data_bank11_ecc_vld;

assign data_2_region_ecc_err  = data_bank8_ecc_err
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
//assign ld_da_hit_low_ecc  = lsda_ex3_borrow_vld && ld_da_borrow_wmb
//                            ? !ld_da_settle_way
//                            : ld_da_hit_low_region;
//
//assign ld_da_hit_high_ecc  = lsda_ex3_borrow_vld && ld_da_borrow_wmb
//                            ? ld_da_settle_way
//                            : ld_da_hit_high_region;
assign ld_da_hit_0_ecc  = lsda_ex3_borrow_vld && ld_da_borrow_wmb
                            ? (ld_da_settle_way == 2'b00)
                            : ld_da_hit_0_region;
assign ld_da_hit_1_ecc  = lsda_ex3_borrow_vld && ld_da_borrow_wmb
                            ? (ld_da_settle_way == 2'b01)
                            : ld_da_hit_1_region;
assign ld_da_hit_2_ecc  = lsda_ex3_borrow_vld && ld_da_borrow_wmb
                            ? (ld_da_settle_way == 2'b10)
                            : ld_da_hit_2_region;
assign ld_da_hit_3_ecc  = lsda_ex3_borrow_vld && ld_da_borrow_wmb
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
assign ld_da_data256_ecc_err = data_0_region_ecc_err || data_1_region_ecc_err || data_2_region_ecc_err || data_3_region_ecc_err;

assign ld_da_data_ecc_vld = lsda_ex3_borrow_vld && (ld_da_borrow_vb || ld_da_borrow_sndb)
                            ? ld_da_data256_ecc_vld
                            : ld_da_data128_ecc_vld;
assign ld_da_data_ecc_err = lsda_ex3_borrow_vld && (ld_da_borrow_vb || ld_da_borrow_sndb)
                            ? ld_da_data256_ecc_err
                            : ld_da_data128_ecc_err;

//when ecc err(1/2 bits),need to stall pipe to handle it
assign ld_da_data_ecc_stall_ori = (lsda_ex3_inst_vld 
                                        && !ld_da_vector_nop
                                        && !ld_da_expt_vld_cancel
                                        && !ld_da_restart_no_cache
                                        && !ld_da_fwd_no_cache
                                        && lsda_ex3_dcache_hit
                                        && !rtu_lsu_flush_fe
                                        &&  !(rtu_ck_flush && rtu_ck_flush_iid_older_than_ex3_iid)  //flush younger ex3 ecc stall, ck_flush@LTL
                                     || lsda_ex3_borrow_vld 
                                        && ld_da_borrow_mmu)
                                  && (!ld_da_tag_ecc_vld || ld_da_ecc_stall_already)
                                  && !ld_da_ecc_stall_tag_fatal
                                  && ld_da_data128_ecc_vld;

assign ld_da_data_rb_restart = ld_da_hit_idx_discard_req 
                               || ld_da_rb_create_vld_unmask && rb_lsda_ex3_full;                                 
assign ld_da_data_ecc_stall  = ld_da_data_ecc_stall_ori && !ld_da_data_rb_restart;

assign ld_da_data_ecc_stall_gate = ld_da_data_ecc_stall_ori; 

//fix info
//ecc info is not required
assign ld_da_ecc_data_bank0[38:0] = {7'b0,data_bank0_corrected[31:0]}; 
assign ld_da_ecc_data_bank1[38:0] = {7'b0,data_bank1_corrected[31:0]}; 
assign ld_da_ecc_data_bank2[38:0] = {7'b0,data_bank2_corrected[31:0]}; 
assign ld_da_ecc_data_bank3[38:0] = {7'b0,data_bank3_corrected[31:0]}; 
assign ld_da_ecc_data_bank4[38:0] = {7'b0,data_bank4_corrected[31:0]}; 
assign ld_da_ecc_data_bank5[38:0] = {7'b0,data_bank5_corrected[31:0]}; 
assign ld_da_ecc_data_bank6[38:0] = {7'b0,data_bank6_corrected[31:0]}; 
assign ld_da_ecc_data_bank7[38:0] = {7'b0,data_bank7_corrected[31:0]};
assign ld_da_ecc_data_bank8[38:0]  = {7'b0,data_bank8_corrected[31:0]}; 
assign ld_da_ecc_data_bank9[38:0]  = {7'b0,data_bank9_corrected[31:0]}; 
assign ld_da_ecc_data_bank10[38:0] = {7'b0,data_bank10_corrected[31:0]}; 
assign ld_da_ecc_data_bank11[38:0] = {7'b0,data_bank11_corrected[31:0]}; 
assign ld_da_ecc_data_bank12[38:0] = {7'b0,data_bank12_corrected[31:0]}; 
assign ld_da_ecc_data_bank13[38:0] = {7'b0,data_bank13_corrected[31:0]}; 
assign ld_da_ecc_data_bank14[38:0] = {7'b0,data_bank14_corrected[31:0]}; 
assign ld_da_ecc_data_bank15[38:0] = {7'b0,data_bank15_corrected[31:0]};

assign ld_da_data512_way0_corrected[511:0] = {data_bank15_corrected[31:0],
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

assign ld_da_data512_way1_corrected[511:0] = {data_bank11_corrected[31:0],
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
assign ld_da_data512_way2_corrected[511:0] = {data_bank7_corrected[31:0],
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
assign ld_da_data512_way3_corrected[511:0] = {data_bank3_corrected[31:0],
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
assign ld_da_ecc_stall      = ld_da_tag_ecc_stall || ld_da_data_ecc_stall || ld_da_tcm_ecc_stall;
assign ld_da_ecc_stall_gate = ld_da_tag_ecc_stall_gate || ld_da_data_ecc_stall_gate || ld_da_tcm_ecc_stall_gate;
assign ld_da_ecc_fatal      = ld_da_tag_ecc_err 
                                 && ld_da_tag_ecc_stall_ori
                              || (ld_da_data_ecc_stall_ori
                                     && !ld_da_tag_ecc_stall_ori
                                  || lsda_ex3_borrow_vld && !ld_da_borrow_mmu)
                                 && ld_da_data_ecc_err;
assign ld_da_ecc_tag_way = ld_da_tag_ecc_err
                           ? {w3_ecc_fatal,w2_ecc_fatal,w1_ecc_fatal,w0_ecc_fatal}
                           : {!w3_ecc_free,!w2_ecc_free,!w1_ecc_free,!w0_ecc_free};

assign ld_da_rb_ecc_mask   = ld_da_tag_ecc_stall_ori || ld_da_ecc_stall_data || ld_da_ecc_stall_tag_fatal; 
//assign ld_da_mcic_ecc_mask = ld_da_tag_ecc_stall_ori || ld_da_ecc_stall_data; 

//for data cmplt req mask
assign ld_da_ecc_data_req_mask = ld_da_tag_ecc_stall_ori || ld_da_data_ecc_stall_ori || ld_da_tcm_ecc_stall_ori;

//for wmb data reissue
assign lsda_wmb_data_reissue = ld_da_ecc_stall;

//for vb/snq data reissue
assign lsda_vb_ex3_snq_data_reissue = ld_da_ecc_stall;

//for vb/snq ecc error
assign lsda_vb_ex3_snq_ecc_err = lsda_ex3_borrow_vld
                              && !ld_da_borrow_icc
                              && !ld_da_borrow_wmb
                              && !ld_da_borrow_mmu
                              && ld_da_data256_ecc_err;

//for wmb fwd data,we can stall fwd data
//for sq fwd data,we should cancel ecc stall(no partial fwd for sq)
assign lsda_ex3_fwd_ecc_stall = ld_da_ecc_stall;


//assign ld_da_sq_fwd_ecc_discard = lsda_ex3_inst_vld
//                                  && ld_da_ecc_stall_already
//                                  && (ld_da_fwd_sq_vld || ld_da_fwd_sq_bypass);
assign ld_da_sq_fwd_ecc_discard = 1'b0;

assign lsda_idu_ex3_wait_old[LSIQ_ENTRY-1:0]  = lsda_ex3_lsid[LSIQ_ENTRY-1:0]
                                                 & {LSIQ_ENTRY{ld_da_sq_fwd_ecc_discard}}; 

assign lsda_idu_ex3_wait_old_gateclk_en     = ld_da_sq_fwd_ecc_discard;

//for wakeup
assign ld_da_ecc_mcic_wakup = ld_da_ecc_stall_already && ld_da_ecc_wakeup_queue[LSIQ_ENTRY];

assign lsda_ex3_ecc_wakeup[LSIQ_ENTRY-1:0] = {LSIQ_ENTRY{ld_da_ecc_stall_already}} 
                                          & ld_da_ecc_wakeup_queue[LSIQ_ENTRY-1:0];

//for pw read data
//assign lsda_wmb_read_data[127:0] = ld_da_settle_way
//                                    ? ld_da_data256_way0_corrected[255:128]
//                                    : ld_da_data256_way0_corrected[127:0];
always_comb
begin
case(ld_da_settle_way[1:0])
  2'b11: lsda_wmb_read_data[127:0] = ld_da_data512_way0_corrected[511 :384];   //way3
  2'b10: lsda_wmb_read_data[127:0] = ld_da_data512_way0_corrected[383 :256 ];  //way2
  2'b01: lsda_wmb_read_data[127:0] = ld_da_data512_way0_corrected[255 :128 ];  //way1
  2'b00: lsda_wmb_read_data[127:0] = ld_da_data512_way0_corrected[127 :0   ];  //way0
  default: lsda_wmb_read_data[127:0] = 128'b0;
endcase
end

assign lsda_wmb_two_bit_err      = ld_da_data128_ecc_err;

//for mmu error
// &Force("output","lsda_mcic_data_err"); @2290
assign lsda_mcic_data_err        = lsda_ex3_borrow_vld
                                    && ld_da_borrow_mmu
                                    && ld_da_ecc_stall_already
                                    && ld_da_ecc_stall_fatal;

//for lm
assign lsda_lm_ex3_ecc_err           = lsda_ex3_inst_vld
                                    && ld_da_atomic
                                    && ld_da_ecc_stall_already
                                    && ld_da_ecc_stall_fatal;

//ECC info
assign ecc_info_update      = ld_da_ecc_stall_already
                                 && (lsda_ex3_inst_vld || lsda_mcic_borrow_mmu)
                                 && !ld_da_tcm_hit
//                                 && !ld_da_restart_vld
//                                 && !ld_da_sq_fwd_ecc_discard
//                                 && !rtu_lsu_flush_fe
                              || lsda_ex3_borrow_vld
                                 && ld_da_data_ecc_vld
                                 && (ld_da_borrow_wmb || ld_da_borrow_vb || ld_da_borrow_sndb);

//assign ecc_info_way_compare = ld_da_ecc_stall_data
//                              ? !ld_da_hit_way
//                              : ld_da_ecc_stall_tag_way;
assign ecc_info_way_compare = ld_da_ecc_stall_data
                              ? ld_da_hit_way
                              : ld_da_ecc_stall_tag_way;
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
//assign tag_ecc_addr[WK_PA_WIDTH-1:0]  = ld_da_ecc_stall_tag_way
//                                         ? {ld_da_tag_corrected_f[52:28],ld_da_addr0[14:0]}
//                                         : {ld_da_tag_corrected_f[25:1],ld_da_addr0[14:0]};
always @(*)
begin
casez(ld_da_ecc_stall_tag_way[3:0])
  4'b1???: tag_ecc_addr[`WK_PA_WIDTH-1:0] = {ld_da_tag_corrected_f[`WK_LS_DCACHE_LDTAG_QUADRUPLE_BF_ECC_LENGTH-2:`WK_LS_DCACHE_LDTAG_TRIPLE_BF_ECC_LENGTH], ld_da_addr0[13:0]};  //way3
  4'b01??: tag_ecc_addr[`WK_PA_WIDTH-1:0] = {ld_da_tag_corrected_f[`WK_LS_DCACHE_LDTAG_TRIPLE_BF_ECC_LENGTH-2   :`WK_LS_DCACHE_LDTAG_DOUBLE_BF_ECC_LENGTH], ld_da_addr0[13:0]};  //way2
  4'b001?: tag_ecc_addr[`WK_PA_WIDTH-1:0] = {ld_da_tag_corrected_f[`WK_LS_DCACHE_LDTAG_DOUBLE_BF_ECC_LENGTH-2   :`WK_LS_DCACHE_LDTAG_BF_ECC_LENGTH],        ld_da_addr0[13:0]};  //way1
  4'b0001: tag_ecc_addr[`WK_PA_WIDTH-1:0] = {ld_da_tag_corrected_f[`WK_LS_DCACHE_LDTAG_BF_ECC_LENGTH-2          :0],                                        ld_da_addr0[13:0]};  //way0
  default: tag_ecc_addr[`WK_PA_WIDTH-1:0] = {`WK_PA_WIDTH{1'b0}};
endcase
end

assign ecc_info_index[16:0] = (lsda_ex3_borrow_vld && !ld_da_borrow_mmu)
                              ? {ld_da_addr0[16:6],ld_da_borrow_idx_5to4[1:0],4'b0}
                              : {ld_da_addr0[16:6],ld_da_hit_way_2bit,4'b0};
assign ecc_info_way[1:0]    = lsda_ex3_borrow_vld && !ld_da_borrow_mmu
                              ? ld_da_borrow_idx_5to4[1:0]  //{1'b0,ld_da_borrow_idx_5to4[0]}, LTL@20250322
                              : ecc_info_way_compare_2bit;
assign ecc_info_ramid[2:0]  = ld_da_ecc_stall_already && !ld_da_ecc_stall_data
                              ? 3'b010 
                              : 3'b011; 
assign ecc_info_fatal       = lsda_ex3_borrow_vld && !ld_da_borrow_mmu
                              ? ld_da_ecc_fatal
                              : ld_da_ecc_stall_fatal;
assign ecc_pa[`WK_PA_WIDTH-1:0] = (lsda_ex3_borrow_vld && !ld_da_borrow_mmu || ld_da_ecc_stall_data)
                                  ? ld_da_addr0[`WK_PA_WIDTH-1:0]
                                  : tag_ecc_addr[`WK_PA_WIDTH-1:0];

//interface
assign lsda_ex3_ecc_info_update_gate = ld_da_ecc_stall_already
                                       && !ld_da_tcm_hit
                                    || lsda_ex3_borrow_vld
                                       && (ld_da_borrow_wmb || ld_da_borrow_vb || ld_da_borrow_sndb);
assign lsda_ex3_ecc_info_update      = ecc_info_update;
assign lsda_ex3_ecc_info[22:0]       = {ecc_info_fatal,ecc_info_ramid[2:0],ecc_info_way[1:0],ecc_info_index[16:0]};
assign lsda_ex3_ecc_pa[`WK_PA_WIDTH-1:0] = ecc_pa[`WK_PA_WIDTH-1:0];

//assign ld_da_ecc_async_expt_vld   = lsda_ex3_borrow_vld
//                                    && ecc_info_fatal;

//ld pipe inj_cmplt
// &Force("output","lsu_lsda_tag_inj_cmplt"); @2357
// &Force("output","lsu_lsda_data_inj_cmplt"); @2358
assign lsu_lsda_tag_inj_cmplt  =  (ld_da_ecc_stall_already
                                    && ~ld_da_ecc_stall_data
                                    && (lsda_ex3_inst_vld || lsda_mcic_borrow_mmu))
                                 && ld_da_tag_inj_vld;

assign lsu_lsda_data_inj_cmplt = (ld_da_ecc_stall_already
                                       && ld_da_ecc_stall_data
                                       && (lsda_ex3_inst_vld || lsda_mcic_borrow_mmu)
                                    || lsda_ex3_borrow_vld
                                       && (ld_da_borrow_wmb || ld_da_borrow_vb || ld_da_borrow_sndb)) 
                               && ld_da_data_inj_vld;

//to avoid st tag inj simultaneously,use ld inj to mask
assign lsda_ex3_tag_inj_mask = (lsda_ex3_inst_vld || lsda_mcic_borrow_mmu)
                               && ld_da_tag_inj_vld;


// &Force("output","lsda_mcic_data_err"); @2377
//==========================================================
//        Generage interface to lq
//==========================================================
//to reduce spec fail, when ld_da restart, pop lq entry
assign ld_da_lq_pop_vld = lsda_ex3_inst_vld
                          && ld_da_restart_no_cache;

assign lsda_ex3_lq_entry_pop[LQ_ENTRY-1:0] = {LQ_ENTRY{ld_da_lq_pop_vld}} & ld_da_lq_entry[LQ_ENTRY-1:0];
//==========================================================
//        Generage interface to cache buffer
//==========================================================
//assign lsda_cb_data[127:0] = {128{ld_da_hit_low_region}}  & ld_da_data256_way0[127:0]
//                              | {128{ld_da_hit_high_region}}  & ld_da_data256_way0[255:128];
assign lsda_cb_data_vld    = lsda_ex3_inst_vld
                              &&  ld_da_ld_inst
                              &&  ld_da_cb_addr_create 
                              &&  lsda_ex3_dcache_hit
                              &&  !ld_da_expt_vld_cancel
                              &&  !ld_da_restart_no_cache 
                              &&  !rtu_lsu_flush_fe 
//                              &&  !(ld_da_ecc_data_req_mask || ld_da_ecc_stall_already)
                              &&  !ld_da_fwd_vld; 
 
assign lsda_cb_ld_inst_vld = lsda_ex3_inst_vld
                              &&  ld_da_ld_inst
                              &&  ld_da_cb_addr_create;

assign lsda_cb_ecc_cancel  = ld_da_ecc_data_req_mask || ld_da_ecc_stall_already;
//==========================================================
//        Generage interface to prefetch buffer
//==========================================================
// &Force("output","lsda_pfu_ex3_pf_inst_vld"); @2425
assign lsda_pfu_ex3_pf_inst_vld      = lsda_ex3_inst_vld
                                    &&  ld_da_pf_inst
                                    &&  !ld_da_ecc_stall_already
                                    &&  !ld_da_already_da
                                    &&  !ld_da_expt_ori;

assign ld_da_boundary_cross_2k    = lsda_pfu_ex3_va[11]
                                    !=  ld_da_addr0[11];
//if cache miss and not hit idx, then it can create pmb
assign lsda_pfu_ex3_awk_vld          = lsda_ex3_inst_vld
                                    &&  ld_da_pf_inst
                                    &&  !ld_da_expt_ori
                                    &&  (lsda_rb_ex3_create_vld || ld_da_split_miss_ff)
                                    &&  !ld_da_data_vld
                                    &&  !ld_da_boundary_cross_2k;//cross 4k condition will get wrong ppn

assign lsda_pfu_ex3_awk_dp_vld       = lsda_ex3_inst_vld
                                    &&  ld_da_pf_inst
                                    &&  !ld_da_expt_ori
                                    &&  !ld_da_data_vld
                                    &&  !ld_da_boundary_cross_2k;//cross 4k condition will get wrong ppn

//for evict count
assign lsda_pfu_ex3_eviwk_cnt_vld    = lsda_pfu_ex3_pf_inst_vld;

//==========================================================
//        Generage interface to WB stage signal
//==========================================================
//------------------write back cmplt part request-----------
// assign ld_da_inst_cmplt    = ld_da_expt_vld
//                              || (ld_da_vector_nop || ld_da_expt_ori)
//                                  &&  !(ld_da_secd
//                                        && lsda_ex3_inst_fof)
//                              ||  ld_da_ld_inst
//                                  &&  !lsda_ex3_page_so
//                                  &&  !lsda_ex3_inst_fof
//                              ||  lsda_ex3_inst_fof
//                                  &&  ld_da_data_vld
//                                  &&  !ld_da_secd
//                              ||  ld_da_ldamo_inst
//                                  &&  ld_da_tcm_hit
//                              ||  ld_da_lr_inst
//                                  &&  ld_da_data_vld; 
//==========================================================
//                  Risc-V Debug zdb Begin (replace)
//==========================================================
assign ld_da_inst_cmplt    = ld_da_expt_vld_cancel
                             || (ld_da_vector_nop || ld_da_expt_ori_cancel)
                                 &&  !(ld_da_secd
                                       && lsda_ex3_inst_fof)
                             ||  ld_da_ld_inst
                                 &&  !lsda_ex3_page_so
                                 &&  !lsda_ex3_inst_fof
                             ||  lsda_ex3_inst_fof
                                 &&  ld_da_data_vld
                                 &&  !ld_da_secd
                             ||  ld_da_ldamo_inst
                                 &&  ld_da_tcm_hit
                             ||  ld_da_lr_inst
                                 &&  ld_da_data_vld;
//==========================================================
//                  Risc-V Debug zdb End   (replace)
//==========================================================

assign lsda_lswb_ex3_cmplt_req     = lsda_ex3_inst_vld
                                &&  !ld_da_ecc_data_req_mask
                                &&  !ld_da_sq_fwd_ecc_discard
                                &&  !ld_da_restart_vld
                                &&  !ld_da_boundary_first
                                &&  ld_da_inst_cmplt;

assign lsda_lswb_ex3_cmplt_req_gate = lsda_ex3_inst_vld
                                 &&  !ld_da_boundary_first
                                 &&  ld_da_inst_cmplt;
//------------------write back data part request------------
assign ld_da_wb_data_req_mask = ld_da_other_discard_sq_req
                                ||  ld_da_fwd_sq_multi_req
                                ||  ld_da_data_discard_sq_req
                                ||  lsda_ex3_us_discard
                                ||  ld_da_discard_wmb_req
                                ||  ld_da_wait_fence_req;

assign lsda_lswb_ex3_data_req      = lsda_ex3_inst_vld
                                &&  (ld_da_ld_inst
                                     || ld_da_lr_inst
                                     || ld_da_ldamo_inst 
                                        && (ld_da_ecc_stall_tag_fatal
                                            ||  ld_da_tcm_hit
                                            ||  ld_da_vector_nop))
                                &&  (!ld_da_expt_vld_cancel
                                        &&  lsda_rb_ex3_data_vld
                                     || ld_da_ecc_stall_tag_fatal) 
                                &&  !ld_da_ecc_data_req_mask
                                &&  !ld_da_sq_fwd_ecc_discard
                                &&  !ld_da_wb_data_req_mask
                                &&  !lsda_ex3_boundary_after_mask
                                &&  !(rtu_ck_flush && rtu_ck_flush_iid_older_than_ex3_iid); //flush younger ex3 data_req, ck_flush@LTL

assign lsda_lswb_ex3_data_req_dp   = lsda_ex3_inst_vld
                                &&  (ld_da_ld_inst 
                                     || ld_da_lr_inst
                                     || ld_da_ldamo_inst 
                                        && (ld_da_ecc_stall_tag_fatal
                                            ||  ld_da_tcm_hit
                                            ||  ld_da_vector_nop))
                                &&  (!ld_da_expt_vld_cancel
                                        &&  lsda_rb_ex3_data_vld
                                     || ld_da_ecc_stall_tag_fatal) 
                                &&  !ld_da_wb_data_req_mask
                                &&  !lsda_ex3_boundary_after_mask
                                &&  !(rtu_ck_flush && rtu_ck_flush_iid_older_than_ex3_iid); //flush younger ex3 data_req, ck_flush@LTL

assign lsda_lswb_ex3_data_req_gateclk_en = lsda_ex3_inst_vld
                                      &&  (lsda_ex3_dcache_hit
                                           || ld_da_tcm_hit
                                           || ld_da_fwd_sq_vld
                                           || ld_da_fwd_wmb_vld
                                           || ld_da_fwd_sq_bypass
                                           || ld_da_vector_nop
                                           || ld_da_fof_not_first
                                           || ld_da_ecc_stall_tag_fatal); 

// &Force("output", "ld_da_fwd_sq_bypass_vld"); @2526
//------------------other signal---------------------------
assign lsda_lswb_ex3_spec_fail     = (ld_da_spec_fail || ld_da_ecc_spec_fail)
                                &&  !ld_da_expt_vld_cancel
                                &&  !lsda_ex3_split;

//assign ld_da_wb_sign[2:0]     = {3{ld_da_sign}};

//==========================================================
//        Generate interface to borrow module
//==========================================================
assign ld_da_borrow_db_vld = lsda_ex3_borrow_vld
                             && (ld_da_borrow_sndb || ld_da_borrow_vb);

assign lsda_vb_ex3_borrow_vb[VB_DATA_ENTRY-1:0] = {VB_DATA_ENTRY{ld_da_borrow_db_vld}}
                                                & ld_da_borrow_db[VB_DATA_ENTRY-1:0];

assign lsda_snq_ex3_borrow_sndb              = lsda_ex3_borrow_vld
                                            &&  ld_da_borrow_sndb;

assign lsda_snq_ex3_borrow_icc               = lsda_ex3_borrow_vld
                                            &&  ld_da_borrow_icc;
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
//                              ? ld_da_data256_way0[255:128]
//                              : ld_da_data256_way0[127:0];
always_comb
begin
case(ld_da_settle_way[1:0])
  2'b11: icc_read_data[127:0] = ld_da_data512_way0[511 :384];   //way3
  2'b10: icc_read_data[127:0] = ld_da_data512_way0[383 :256 ];  //way2
  2'b01: icc_read_data[127:0] = ld_da_data512_way0[255 :128 ];  //way1
  2'b00: icc_read_data[127:0] = ld_da_data512_way0[127 :0   ];  //way0
  default: icc_read_data[127:0] = 128'b0;
endcase
end
//assign icc_read_ecc[27:0]   = ld_da_settle_way
//                             ? {ld_da_dcache_data_bank7[38:32],
//                                ld_da_dcache_data_bank6[38:32],
//                                ld_da_dcache_data_bank5[38:32],
//                                ld_da_dcache_data_bank4[38:32]}
//                             : {ld_da_dcache_data_bank3[38:32],
//                                ld_da_dcache_data_bank2[38:32],
//                                ld_da_dcache_data_bank1[38:32],
//                                ld_da_dcache_data_bank0[38:32]};
always_comb
begin
case(ld_da_settle_way[1:0])
  2'b11: icc_read_ecc[27:0] = { ld_da_dcache_data_bank15[38:32],
                                ld_da_dcache_data_bank14[38:32],
                                ld_da_dcache_data_bank13[38:32],
                                ld_da_dcache_data_bank12[38:32]};   //way3
  2'b10: icc_read_ecc[27:0] = { ld_da_dcache_data_bank11[38:32],
                                ld_da_dcache_data_bank10[38:32],
                                ld_da_dcache_data_bank9[38:32],
                                ld_da_dcache_data_bank8[38:32]};  //way2
  2'b01: icc_read_ecc[27:0] = { ld_da_dcache_data_bank7[38:32],
                                ld_da_dcache_data_bank6[38:32],
                                ld_da_dcache_data_bank5[38:32],
                                ld_da_dcache_data_bank4[38:32]};  //way1
  2'b00: icc_read_ecc[27:0] = { ld_da_dcache_data_bank3[38:32],
                                ld_da_dcache_data_bank2[38:32],
                                ld_da_dcache_data_bank1[38:32],
                                ld_da_dcache_data_bank0[38:32]};  //way0
  default: icc_read_ecc[27:0] = 28'b0;
endcase
end
assign ld_da_icc_data_read[127:0] = ld_da_borrow_icc_ecc
                                    ? {100'b0,icc_read_ecc[27:0]}
                                    : icc_read_data[127:0];
                                     
assign lsda_icc_read_data[127:0] = ld_da_borrow_icc_tag
                                    ? ld_da_icc_tag_read[127:0]
                                    : ld_da_icc_data_read[127:0];

// &Force("output","lsda_mcic_borrow_mmu"); @2594
assign lsda_mcic_borrow_mmu              = lsda_ex3_borrow_vld
                                            &&  ld_da_borrow_mmu;
assign lsda_mcic_borrow_mmu_req          = lsda_mcic_borrow_mmu
                                            && !ld_da_ecc_data_req_mask;

assign lsda_mcic_wakeup                  = ld_da_ecc_mcic_wakup;
//rb_full_vld has exclude ld_da_hit_idx_discard_req
assign lsda_mcic_rb_full                 = lsda_ex3_borrow_vld
                                            &&  ld_da_borrow_mmu
                                            &&  ld_da_rb_full_vld;
assign ld_da_mcic_bypass_data_ori[63:0]   = ld_da_data_ff[63:0];

assign lsda_mcic_bypass_data[63:0]       = lsda_mcic_data_err
                                            ? 64'b0
                                            : ld_da_mcic_bypass_data_ori[63:0];
//==========================================================
//              Interface to other module
//==========================================================
//-----------interface to local monitor---------------------
assign lsda_lm_ex3_no_req      = lsda_ex3_inst_vld
                              &&  ld_da_lr_inst
                              &&  ld_da_data_vld
                              &&  !ld_da_ecc_stall;
// &Force("output", "lsda_lm_ex3_lr_no_restart_dp"); @2618
assign lsda_lm_ex3_lr_no_restart_dp  = lsda_ex3_inst_vld
                                    &&  ld_da_lr_inst;
assign lsda_lm_ex3_lr_no_restart     = lsda_lm_ex3_lr_no_restart_dp
                                    &&  !ld_da_restart_vld;

assign lsda_lm_ex3_vector_nop  = lsda_ex3_inst_vld
                              &&  ld_da_ldamo_inst 
                              &&  ld_da_vector_nop; 
//==========================================================
//        Generate lsiq signal
//==========================================================
assign ld_da_mask_lsid[LSIQ_ENTRY-1:0]      = {LSIQ_ENTRY{lsda_ex3_inst_vld}}
                                              & lsda_ex3_lsid[LSIQ_ENTRY-1:0];

assign ld_da_merge_mask                     = ld_da_merge_from_cb
                                              && lsda_ex3_dcache_hit
                                              && !ld_da_fwd_vld;

// &Force("output","lsda_ex3_boundary_after_mask"); @2637
assign lsda_ex3_boundary_after_mask            = lsda_ex3_inst_vld
                                              &&  ld_da_boundary
                                              &&  !ld_da_merge_mask
                                              &&  !ld_da_expt_vld_cancel;

assign ld_da_boundary_first                 = lsda_ex3_boundary_after_mask
                                              &&  !ld_da_secd;

assign ld_da_ecc_spec_fail = (ld_da_ecc_stall_already || ld_da_tag_ecc_stall_ori) 
                             && (ld_da_ahead_preg_wb_vld || ld_da_ahead_vreg_wb_vld); 

//-----------lsiq signal----------------
assign lsda_idu_ex3_already_da[LSIQ_ENTRY-1:0] = ld_da_mask_lsid[LSIQ_ENTRY-1:0];

assign lsda_idu_ex3_rb_full[LSIQ_ENTRY-1:0]    = {LSIQ_ENTRY{ld_da_rb_full_vld}}
                                              & ld_da_mask_lsid[LSIQ_ENTRY-1:0];

assign lsda_idu_ex3_wait_fence[LSIQ_ENTRY-1:0] = {LSIQ_ENTRY{ld_da_wait_fence_vld}}
                                              & ld_da_mask_lsid[LSIQ_ENTRY-1:0];

// &Force("output","lsda_idu_ex3_pop_vld"); @2662
assign lsda_idu_ex3_pop_vld                    = lsda_ex3_inst_vld
                                              &&  !ld_da_boundary_first
                                              &&  !ld_da_ecc_stall
                                              &&  !ld_da_sq_fwd_ecc_discard
                                              &&  !ld_da_restart_vld;
assign lsda_idu_ex3_pop_entry[LSIQ_ENTRY-1:0]  = {LSIQ_ENTRY{lsda_idu_ex3_pop_vld}}
                                              & ld_da_mask_lsid[LSIQ_ENTRY-1:0];

assign lsda_idu_ex3_spec_fail[LSIQ_ENTRY-1:0]  = {LSIQ_ENTRY{ld_da_spec_fail
                                                          &&  ld_da_boundary_first
                                                          || ld_da_ecc_spec_fail}}
                                              & ld_da_mask_lsid[LSIQ_ENTRY-1:0];
            
//---------boundary gateclk-------------
assign ld_da_idu_boundary_gateclk_vld       = lsda_ex3_inst_vld
                                              &&  ld_da_boundary_first;

assign lsda_idu_ex3_boundary_gateclk_en[LSIQ_ENTRY-1:0]  = 
                {LSIQ_ENTRY{ld_da_idu_boundary_gateclk_vld}}
                & ld_da_mask_lsid[LSIQ_ENTRY-1:0];
//-----------imme wakeup----------------
assign ld_da_idu_secd_vld                   = ld_da_boundary_first
                                              &&  !ld_da_ecc_stall
                                              &&  !ld_da_sq_fwd_ecc_discard
                                              &&  !ld_da_restart_vld;

assign lsda_idu_ex3_secd[LSIQ_ENTRY-1:0]       = {LSIQ_ENTRY{ld_da_idu_secd_vld}}
                                              & ld_da_mask_lsid[LSIQ_ENTRY-1:0];

assign lsda_idu_ex3_us_restart[LSIQ_ENTRY-1:0] = {LSIQ_ENTRY{ld_da_us_discard_req}}
                                                & ld_da_mask_lsid[LSIQ_ENTRY-1:0];
//==========================================================
//        Generate interface to rtu
//==========================================================
assign lsu_rtu_ex3_ssf_vld = lsda_ex3_inst_vld
                                              &&  !ld_da_expt_vld_cancel
                                              &&  lsda_ex3_split
                                              &&  (ld_da_spec_fail || ld_da_ecc_spec_fail);
assign lsu_rtu_ex3_ssf_iid[IID_WIDTH-1:0]  = lsda_ex3_iid[IID_WIDTH-1:0];

//==========================================================
//        pipe3 data wb
//==========================================================
assign lsu_idu_ex3_fwd_preg_vld        = ld_da_ahead_preg_wb_vld
                                              && !ld_da_expt_access_fault_mmu;
assign lsu_idu_ex3_fwd_preg[PREG-1:0]  = lsda_ex3_preg[PREG-1:0];
assign lsu_idu_ex3_fwd_preg_data[63:0] = ld_da_preg_data_sign_extend[63:0];
assign lsu_idu_ex3_fwd_vreg_vld        = ld_da_ahead_vreg_wb_vld
                                              && !ld_da_expt_access_fault_mmu;
//assign lsu_idu_ex3_fwd_vreg[6:0]       = {1'b0,lsda_ex3_vreg[5:0]};

//assign lsu_idu_ex3_fwd_vreg_fr_data[63:0]  = ld_da_vreg_data_sign_extend[63:0];
assign lsu_idu_ex3_fwd_vreg[VREG:0]        = '0;
assign lsu_idu_ex3_fwd_vreg_fr_data[63:0]  = 64'b0;
assign lsu_idu_ex3_fwd_vreg_vr0_data[255:0] = 256'b0;
assign lsu_idu_ex3_fwd_vreg_vr1_data[255:0] = 256'b0;

//==========================================================
//                Flop for ld_da
//==========================================================
assign ld_da_ff_clk_en  = lsda_ex3_inst_vld
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
    lsda_pfu_ex3_ppn_ff[`WK_PA_WIDTH-13:0]  <=  {`WK_PA_WIDTH-12{1'b0}};
    lsda_ex3_page_sec_ff             <=  1'b0;
    lsda_ex3_page_share_ff           <=  1'b0;
  end
  else if(lsda_ex3_inst_vld)
  begin
    lsda_pfu_ex3_ppn_ff[`WK_PA_WIDTH-13:0]  <=  ld_da_addr0[`WK_PA_WIDTH-1:12];
    lsda_ex3_page_sec_ff             <=  lsda_ex3_page_sec;
    lsda_ex3_page_share_ff           <=  lsda_ex3_page_share;
  end
end

//for preload
//when split load cache miss,record
assign ld_da_split_miss = lsda_ex3_inst_vld
                          && ld_da_ld_inst
                          && lsda_ex3_page_ca
                          && cp0_lsu_dcache_en
                          && lsda_ex3_split
                          && !ld_da_secd
                          && !ld_da_expt_vld_cancel
                          && lsda_rb_ex3_create_vld
                          && !ld_da_data_vld;

assign ld_da_split_last = lsda_ex3_inst_vld
                          && ld_da_ld_inst
                          && !lsda_ex3_split;

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

assign ld_da_spec_chk_req  = lsda_ex3_inst_vld
                             && ld_da_ld_inst
                             && cp0_lsu_nsfe
                             && ld_da_no_spec_exist
                             && !lsda_ex3_page_so 
                             && !ld_da_expt_vld_except_access_err 
                             && !ld_da_restart_vld; 

assign ld_da_no_spec_miss = lsda_ex3_inst_vld
                            && cp0_lsu_nsfe
                            && !ld_da_atomic
                            && ld_da_spec_fail; 
//------------ sf interface ------------
//for target
assign lsda_sf_ex3_no_spec_miss              = ld_da_no_spec_miss
                                            && !ld_da_restart_vld;
assign lsda_sf_ex3_no_spec_miss_gate         = ld_da_no_spec_miss;
assign lsda_sf_ex3_iid[IID_WIDTH-1:0]         = lsda_ex3_iid[IID_WIDTH-1:0];
assign lsda_sf_ex3_addr_tto4[`WK_PA_WIDTH-5:0]  = ld_da_addr0[`WK_PA_WIDTH-1:4];
assign lsda_sf_ex3_bytes_vld[15:0]           = lsda_ex3_bytes_vld[15:0];

//for other
assign lsda_sf_ex3_spec_chk_req = ld_da_spec_chk_req;

//------------ wb interface ------------
//for target
assign ld_da_target_no_spec_miss    = ld_da_no_spec_miss
                                      && !ld_da_no_spec_target;
assign ld_da_target_no_spec_hit     = lsda_ex3_inst_vld
                                      && cp0_lsu_nsfe
                                      && !ld_da_spec_fail
                                      && ld_da_no_spec_target;
assign ld_da_target_no_spec_mispred = lsda_ex3_inst_vld
                                      && cp0_lsu_nsfe
                                      && ld_da_spec_fail
                                      && ld_da_no_spec_target;

//for pair
assign ld_da_pair_no_spec_miss      = lsda_ex3_inst_vld
                                      && cp0_lsu_nsfe
                                      && ld_da_spec
                                      && sf_spec_mark;
assign ld_da_pair_no_spec_mispred   = lsda_ex3_inst_vld
                                      && cp0_lsu_nsfe
                                      && ld_da_no_spec_pair
                                      && !ld_da_no_spec_exist;

assign lsda_lswb_ex3_no_spec_miss     = ld_da_target_no_spec_miss || ld_da_pair_no_spec_miss;
assign lsda_lswb_ex3_no_spec_hit      = ld_da_target_no_spec_hit;
assign lsda_lswb_ex3_no_spec_mispred  = ld_da_target_no_spec_mispred || ld_da_pair_no_spec_mispred;
assign lsda_lswb_ex3_no_spec_target   = ld_da_no_spec_target || ld_da_target_no_spec_miss;

//==========================================================
//        interface to hpcp
//==========================================================
// &Force("output","lsda_rb_ex3_merge_vld"); @2839
assign lsu_hpcp_ls_cache_access = lsda_ex3_inst_vld
                                  &&  ld_da_ld_inst
                                  &&  lsda_ex3_page_ca
                                  &&  cp0_lsu_dcache_en
                                  &&  !ld_da_already_da;
assign lsu_hpcp_ls_cache_miss   = lsda_ex3_inst_vld
                                  &&  ld_da_ld_inst
                                  &&  lsda_ex3_page_ca
                                  &&  cp0_lsu_dcache_en
                                  &&  !ld_da_data_vld
                                  &&  (lsda_rb_ex3_create_vld
                                          &&  !rb_lsda_ex3_full
                                              || lsda_rb_ex3_merge_vld);
                                          //     || ld_da_discard_from_lfb_req
                                          // && ld_hit_prefetch);
assign lsu_hpcp_ld_discard_sq    = lsda_ex3_inst_vld
                                   &&  (ld_da_other_discard_sq_req
                                        || ld_da_fwd_sq_multi_req)
                                   &&  !ld_da_already_da;

assign lsu_hpcp_ld_data_discard  = lsda_ex3_inst_vld
                                   &&  ld_da_data_discard_sq_req
                                   &&  !ld_da_already_da;

assign lsu_hpcp_ls_unalign_inst  = lsda_ex3_inst_vld
                                   &&  !ld_da_already_da
                                   &&  ld_da_secd;
// &Force("nonport","ld_da_already_da"); @2868
// &ModuleEnd; @2870

//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
assign ld_da_expt_ori_cancel        = ld_da_expt_ori
                                    | dtu_lsu_addr_halt_info[0];

assign ld_da_expt_vld_cancel        = ld_da_expt_vld
                                    | dtu_lsu_addr_halt_info[0];                  

assign lda_lwb_ex3_expt_vld_cancel  = lsda_ex3_expt_vld
                                    | dtu_lsu_addr_halt_info[0];

assign ld_da_rb_data_check = (lsda_ex3_inst_vld
                             & ~lsda_ex3_inst_vls
                             | ld_da_lr_inst)
                             & ~ld_da_boundary_first
                             & ~dtu_lsu_addr_halt_info[0]
                             & ~(ld_da_ecc_stall_already
                                 & ld_da_ecc_stall_fatal
                                 & ld_da_ecc_stall_data)
                             & dtu_lsu_data_trig_en;

assign ld_da_halt_info_am[`TDT_MP_HINFO_WIDTH-1:2]  = dtu_lsu_addr_halt_info[`TDT_MP_HINFO_WIDTH-1:2];
assign ld_da_halt_info_am[1]  = dtu_lsu_addr_halt_info[1]
                                & ~lsda_lswb_ex3_vsetvl;
assign ld_da_halt_info_am[0]  = dtu_lsu_addr_halt_info[0];

assign ld_da_idu_halt_info_update_vld[LSIQ_ENTRY-1:0] = {LSIQ_ENTRY{ld_da_idu_secd_vld}}
                                                      & ld_da_mask_lsid[LSIQ_ENTRY-1:0];
assign ld_da_idu_halt_info[`TDT_MP_HINFO_WIDTH-1:0]   = dtu_lsu_addr_halt_info[`TDT_MP_HINFO_WIDTH-1:0];

assign ld_da_dtu_addr_halt_info_stall_vld             = ld_da_ecc_stall;
//==========================================================
//                  Risc-V Debug zdb End
//==========================================================

endmodule


