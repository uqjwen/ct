//-----------------------------------------------------------------------------
// File          : xx_lsu_wmb.v
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

// &ModuleBeg; @37
module xx_lsu_wmb#(
  parameter IID_WIDTH   = 7,
  parameter SDID_LEN    = 4,
  parameter LSIQ_ENTRY  = 12,
  parameter SQ_ENTRY    = 12,
  parameter WMB_ENTRY   = 8,
  parameter PREG        = 7,
  parameter VREG        = 6
)(
input logic                                                 rtu_ck_flush,          
input logic                                                 amr_l2_mem_set,                                
input logic   [4  :0]                                       biu_lsu_b_id,                                  
input logic   [1  :0]                                       biu_lsu_b_resp,                                
input logic                                                 biu_lsu_b_vld,                                 
input logic   [4  :0]                                       biu_lsu_r_id,                                  
input logic                                                 biu_lsu_r_vld,                                 
input logic                                                 bus_arb_wmb_ar_grnt,                           
input logic                                                 bus_arb_wmb_aw_grnt,                           
input logic                                                 bus_arb_wmb_w_grnt,                            
input logic                                                 cp0_lsu_ecc_en,                                
input logic                                                 cp0_lsu_icg_en,                                
input logic                                                 cp0_lsu_no_op_req,                             
input logic                                                 cp0_lsu_wr_burst_dis,                          
input logic                                                 cpurst_b,                                      
input logic                                                 dcache_arb_wmb_ld_grnt,                        
input logic   [15 :0]                                       dcache_dirty_din,   //8->15, L1D 2->4way, LTL@20250325                           
input logic                                                 dcache_dirty_gwen,                             
input logic   [15 :0]                                       dcache_dirty_wen,   //8->15, L1D 2->4way, LTL@20250325                           
input logic   [7  :0]                                       dcache_idx,         //8->7, L1D 2->4way, LTL@20250325                           
input logic                                                 dcache_snq_st_sel,                             
input logic   [`WK_LS_DCACHE_TAG_NOECC_WIDTH-1:0]           dcache_tag_din,     //51->103, L1D 2->4way, LTL@20250325                           
input logic                                                 dcache_tag_gwen,                               
input logic   [3  :0]                                       dcache_tag_wen,     //1->3, L1D 2->4way, LTL@20250325                           
input logic                                                 dcache_vb_snq_gwen,                            
input logic                                                 dm_state_is_force_fail,                        
input logic                                                 forever_cpuclk,                                
input logic                                                 icc_wmb_write_imme,                            
input logic                                                 lag0_ex1_inst_vld,         //ld_ag  st_ag use lag or lsag    LTL@20241104             
input logic                                                 lsag0_ex1_inst_vld,
input logic                                                 lsag1_ex1_inst_vld,
input logic                                                 lda0_ex3_fwd_ecc_stall,    //fwd depd, 1->3, LTL@20241104
input logic                                                 lsda0_ex3_fwd_ecc_stall,                           
input logic                                                 lsda1_ex3_fwd_ecc_stall,
input logic   [LSIQ_ENTRY-1:0]                              lda0_ex3_lsid,   //1->3 for 3 ld dc, LTL@20241104
input logic   [LSIQ_ENTRY-1:0]                              lsda0_ex3_lsid,                                    
input logic   [LSIQ_ENTRY-1:0]                              lsda1_ex3_lsid,
input logic                                                 lda0_wmb_data_reissue,       //not sure 1->3, borrow? ld_da->wmb data???, need ask lishuo LTL@20241104                  
input logic                                                 lda0_wmb_ex3_discard_vld,  //data depd, 1->3, LTL@20241104
input logic                                                 lsda0_wmb_ex3_discard_vld,                         
input logic                                                 lsda1_wmb_ex3_discard_vld,
input logic   [127:0]                                       lda0_wmb_read_data,    //ecc related, not sure 1->4, borrow? ld_da->wmb data ??? need ask lishuo, LTL@20241104                         
input logic                                                 lda0_wmb_two_bit_err,  //ecc related, not sure 1->4, borrow? ld_da->wmb data ??? need ask lishuo, LTL@20241104                         
input logic   [`WK_PA_WIDTH-1 :0]                           ldc0_ex2_addr0,          //data depd, 1->3, LTL@20241104                         
input logic   [`WK_PA_WIDTH-1 :0]                           lsdc0_ex2_addr0,
input logic   [`WK_PA_WIDTH-1 :0]                           lsdc1_ex2_addr0,
input logic   [7  :0]                                       ldc0_ex2_addr1_11to4,  //data depd, 1->3, LTL@20241104 
input logic   [7  :0]                                       lsdc0_ex2_addr1_11to4,                             
input logic   [7  :0]                                       lsdc1_ex2_addr1_11to4,
input logic   [15 :0]                                       ldc0_ex2_bytes_vld,  //data depd, 1->3, LTL@20241104 
input logic   [15 :0]                                       lsdc0_ex2_bytes_vld,                               
input logic   [15 :0]                                       lsdc1_ex2_bytes_vld,
input logic   [15 :0]                                       ldc0_ex2_bytes_vld1, //rvv512@LTL
input logic   [15 :0]                                       lsdc0_ex2_bytes_vld1,
input logic   [15 :0]                                       lsdc1_ex2_bytes_vld1,
input logic   [15 :0]                                       ldc0_ex2_bytes_vld2, //rvv512@LTL
input logic   [15 :0]                                       lsdc0_ex2_bytes_vld2,
input logic   [15 :0]                                       lsdc1_ex2_bytes_vld2,
input logic   [15 :0]                                       ldc0_ex2_bytes_vld3, //rvv512@LTL
input logic   [15 :0]                                       lsdc0_ex2_bytes_vld3,
input logic   [15 :0]                                       lsdc1_ex2_bytes_vld3,
input logic                                                 ldc0_ex2_is_us, //rvv512@LTL
input logic                                                 lsdc0_ex2_is_us,
input logic                                                 lsdc1_ex2_is_us,    //rvv512@LTL
input logic                                                 ldc0_ex2_chk_atomic_inst_vld,  //data depd, 1->3, LTL@20241104 
input logic                                                 lsdc0_ex2_chk_atomic_inst_vld,
input logic                                                 lsdc1_ex2_chk_atomic_inst_vld,                     
input logic                                                 ldc0_ex2_chk_ld_inst_vld,   //data depd, 1->3, LTL@20241104 
input logic                                                 lsdc0_ex2_chk_ld_inst_vld, 
input logic                                                 lsdc1_ex2_chk_ld_inst_vld,                         
input logic                                                 lwb0_wmb_ex3_data_grnt,   //data depd, 1->3, LTL@20241104 
input logic                                                 lswb0_wmb_ex3_data_grnt,
input logic                                                 lswb1_wmb_ex3_data_grnt,                          
input logic                                                 lfb_wmb_read_req_hit_idx,     //lfb no need rename     LTL            
input logic                                                 lfb_wmb_write_req_hit_idx,                     
input logic                                                 lm_state_is_amo_lock,         //lm no need rename     LTL                
input logic                                                 lm_state_is_ex_wait_lock,                      
input logic                                                 lm_state_is_idle,                              
input logic                                                 pad_yy_icg_scan_en,                            
input logic   [`WK_PA_WIDTH-1 :0]                           pfu_biu_req_addr,          //pfu no need rename     LTL                      
input logic   [`WK_PA_WIDTH-1 :0]                           rb_biu_req_addr,           //rb no need rename     LTL                      
input logic                                                 rb_biu_req_unmask,                             
input logic                                                 rb_wmb_so_pending,                             
input logic                                                 rtu_lsu_async_flush,        //rtu no need rename     LTL                     
input logic                                                 rtu_yy_xx_flush,                               
input logic                                                 snq_can_create_snq_uncheck,   //snq no need rename     LTL                   
input logic   [`WK_PA_WIDTH-1 :0]                           snq_create_addr,                               
input logic                                                 snq_create_wmb_read_req_hit_idx,               
input logic                                                 snq_create_wmb_write_req_hit_idx,              
input logic                                                 snq_wmb_read_req_hit_idx,                      
input logic                                                 snq_wmb_write_req_hit_idx,                     
input logic   [`WK_PA_WIDTH-1 :0]                           sq_pop_addr,               //sq_pop no need rename     LTL                        
input logic                                                 sq_pop_atomic,                                 
input logic   [15 :0]                                       sq_pop_bytes_vld,                              
input logic                                                 sq_pop_dcache_1line_inst,                      
input logic   [1  :0]                                       sq_pop_priv_mode,                              
input logic                                                 sq_pop_st_inst,                                
input logic                                                 sq_wmb_merge_req,        //sq no need rename     LTL                       
input logic                                                 sq_wmb_merge_stall_req,                        
input logic                                                 sq_wmb_pop_to_ce_dp_req,                       
input logic                                                 sq_wmb_pop_to_ce_gateclk_en,                   
input logic                                                 sq_wmb_pop_to_ce_req,                          
input logic                                                 sq_wmb_write_imme,                                               
input logic                                                 lsag0_rf_inst_vld,      // 1->2, st ag, LTL@20241104                           
input logic                                                 lsag1_rf_inst_vld,
input logic                                                 idu_lsu2_rf_is_load,  //used for st_rf_inst_vld, LTL@20241114
input logic                                                 idu_lsu3_rf_is_load,
input logic                                                 lsag0_ex1_is_load,    //used for st_ag_inst_vld, LTL@20241114
input logic                                                 lsag1_ex1_is_load,
input logic                                                 lswb0_wmb_ex3_cmplt_grnt,    // 1->2, st_wb, LTL@20241104                        
input logic                                                 lswb1_wmb_ex3_cmplt_grnt,
input logic                                                 vb_wmb_create_grnt,     //vb no need rename     LTL                            
input logic                                                 vb_wmb_empty,                                  
input logic   [WMB_ENTRY-1:0]                               vb_wmb_entry_rcl_done, //parameter, LTL@20241104                       
input logic                                                 vb_wmb_write_req_hit_idx,                      
input logic   [`WK_PA_WIDTH-1 :0]                           wmb_ce_addr,            //wmb ce no need rename     LTL                       
input logic                                                 wmb_ce_atomic,                                                         
input logic   [15 :0]                                       wmb_ce_bytes_vld,                              
input logic                                                 wmb_ce_bytes_vld_full,                         
input logic                                                 wmb_ce_create_wmb_data_req,                    
input logic                                                 wmb_ce_create_wmb_dp_req,                      
input logic                                                 wmb_ce_create_wmb_gateclk_en,                  
input logic                                                 wmb_ce_create_wmb_req,                         
input logic   [127:0]                                       wmb_ce_data128,                                
input logic   [3  :0]                                       wmb_ce_data_vld,                               
input logic                                                 wmb_ce_dcache_1line_inst,                      
input logic                                                 wmb_ce_dcache_inst,                            
input logic                                                 wmb_ce_dtcm_hit,                               
input logic   [3  :0]                                       wmb_ce_fence_mode,                             
input logic                                                 wmb_ce_hit_sq_pop_dcache_line,                 
input logic                                                 wmb_ce_icc,                                    
input logic   [PREG-1:0]                                    wmb_ce_preg,
input logic   [IID_WIDTH-1:0]                               wmb_ce_iid,                                    
input logic                                                 wmb_ce_inst_flush,                             
input logic   [1  :0]                                       wmb_ce_inst_mode,                              
input logic   [2  :0]                                       wmb_ce_inst_size,                              
input logic   [1  :0]                                       wmb_ce_inst_type,                              
input logic                                                 wmb_ce_itcm_hit,                               
input logic                                                 wmb_ce_merge_data_addr_hit,                    
input logic                                                 wmb_ce_merge_data_stall,                       
input logic                                                 wmb_ce_merge_en,                               
input logic   [WMB_ENTRY-1:0]                               wmb_ce_merge_ptr,                              
input logic                                                 wmb_ce_merge_wmb_req,                          
input logic                                                 wmb_ce_merge_wmb_wait_not_vld_req,             
input logic                                                 wmb_ce_page_buf,                               
input logic                                                 wmb_ce_page_ca,                                
input logic                                                 wmb_ce_page_sec,                               
input logic                                                 wmb_ce_page_share,                             
input logic                                                 wmb_ce_page_so,                                
input logic                                                 wmb_ce_page_wa,                                
input logic   [1  :0]                                       wmb_ce_priv_mode,                              
input logic                                                 wmb_ce_read_dp_req,                            
input logic   [WMB_ENTRY-1:0]                               wmb_ce_same_dcache_line,                       
input logic                                                 wmb_ce_sc_wb_vld,                              
input logic                                                 wmb_ce_spec_fail,                              
input logic                                                 wmb_ce_sq_pop_sameline_set,                    
input logic                                                 wmb_ce_st_inst,                                
input logic                                                 wmb_ce_sync_fence,                             
input logic                                                 wmb_ce_update_dcache_dirty,                    
input logic                                                 wmb_ce_update_dcache_page_share,               
input logic                                                 wmb_ce_update_dcache_share,                    
input logic                                                 wmb_ce_update_dcache_valid,                    
input logic   [1  :0]                                       wmb_ce_update_dcache_way,   //1->2bit, L1D 2->4way, LTL@20250323                   
input logic                                                 wmb_ce_vld,                                    
input logic                                                 wmb_ce_vstart_vld,                             
input logic                                                 wmb_ce_wb_cmplt_success,                       
input logic                                                 wmb_ce_wb_data_success,                        
input logic                                                 wmb_ce_write_biu_dp_req,                       
input logic                                                 wmb_ce_write_imme,                             
output logic                                                lsu_had_wmb_ar_pending,     //had no need rename     LTL                   
output logic                                                lsu_had_wmb_aw_pending,                        
output logic  [WMB_ENTRY-1:0]                               lsu_had_wmb_create_ptr,                        
output logic  [WMB_ENTRY-1:0]                               lsu_had_wmb_data_ptr,                          
output logic  [WMB_ENTRY-1:0]                               lsu_had_wmb_entry_vld,                         
output logic  [WMB_ENTRY-1:0]                               lsu_had_wmb_read_ptr,                          
output logic                                                lsu_had_wmb_w_pending,                         
output logic                                                lsu_had_wmb_write_imme,                        
output logic  [WMB_ENTRY-1:0]                               lsu_had_wmb_write_ptr,                         
output logic  [`WK_PA_WIDTH-1 :0]                           wmb_biu_ar_addr,                               
output logic  [1  :0]                                       wmb_biu_ar_bar,                                
output logic  [1  :0]                                       wmb_biu_ar_burst,                              
output logic  [3  :0]                                       wmb_biu_ar_cache,                              
output logic  [1  :0]                                       wmb_biu_ar_domain,                             
output logic                                                wmb_biu_ar_dp_req,                             
output logic  [4  :0]                                       wmb_biu_ar_id,                                 
output logic  [1  :0]                                       wmb_biu_ar_len,                                
output logic                                                wmb_biu_ar_lock,                               
output logic  [2  :0]                                       wmb_biu_ar_prot,                               
output logic                                                wmb_biu_ar_req,                                
output logic                                                wmb_biu_ar_req_gateclk_en,                     
output logic  [2  :0]                                       wmb_biu_ar_size,                               
output logic  [3  :0]                                       wmb_biu_ar_snoop,                              
output logic  [3  :0]                                       wmb_biu_ar_user,                               
output logic  [`WK_PA_WIDTH-1 :0]                           wmb_biu_aw_addr,                               
output logic  [1  :0]                                       wmb_biu_aw_bar,                                
output logic  [1  :0]                                       wmb_biu_aw_burst,                              
output logic  [3  :0]                                       wmb_biu_aw_cache,                              
output logic  [1  :0]                                       wmb_biu_aw_domain,                             
output logic                                                wmb_biu_aw_dp_req,                             
output logic  [4  :0]                                       wmb_biu_aw_id,                                 
output logic  [1  :0]                                       wmb_biu_aw_len,                                
output logic                                                wmb_biu_aw_lock,                               
output logic  [2  :0]                                       wmb_biu_aw_prot,                               
output logic                                                wmb_biu_aw_req,                                
output logic                                                wmb_biu_aw_req_gateclk_en,                     
output logic  [2  :0]                                       wmb_biu_aw_size,                               
output logic  [2  :0]                                       wmb_biu_aw_snoop,                              
output logic  [1  :0]                                       wmb_biu_aw_user,                               
output logic  [127:0]                                       wmb_biu_w_data,                                
output logic  [4  :0]                                       wmb_biu_w_id,                                  
output logic                                                wmb_biu_w_last,                                
output logic                                                wmb_biu_w_req,                                 
output logic  [15 :0]                                       wmb_biu_w_strb,                                
output logic                                                wmb_biu_w_vld,                                 
output logic                                                wmb_biu_w_wns,                                 
output logic  [WMB_ENTRY-1:0]                               wmb_ce_create_depd_val,                        
output logic                                                wmb_ce_create_dp_vld,                          
output logic                                                wmb_ce_create_gateclk_en,                      
output logic                                                wmb_ce_create_merge,                           
output logic  [WMB_ENTRY-1:0]                               wmb_ce_create_merge_ptr,                       
output logic  [WMB_ENTRY-1:0]                               wmb_ce_create_same_dcache_line,                
output logic                                                wmb_ce_create_stall,                           
output logic                                                wmb_ce_create_vld,                             
output logic                                                wmb_ce_pop_vld,                                
output logic                                                wmb_clk,                                       
output logic  [`WK_PA_WIDTH-1 :0]                           wmb_dcache_arb_borrow_addr,                    
output logic  [1  :0]                                       wmb_dcache_arb_data_way,                       
output logic                                                wmb_dcache_arb_ld_borrow_req,                  
output logic  [15 :0]                                       wmb_dcache_arb_ld_data_gateclk_en,  //no relation with WMB_entry, 7->15, for 4way data, L1D 2way->4way, LTL@20250320             
output logic  [15 :0]                                       wmb_dcache_arb_ld_data_gwen,        //no relation with WMB_entry, 7->15, for 4way data, L1D 2way->4way, LTL@20250320             
//output logic  [155:0]  wmb_dcache_arb_ld_data_high_din,               
output logic  [9  :0]                                       wmb_dcache_arb_ld_data_idx,         //10->9, L1D 2way->4way, LTL@20250320                
//output logic  [155:0]  wmb_dcache_arb_ld_data_low_din, 
output logic  [155:0]                                       wmb_dcache_arb_ld_data_3_din,
output logic  [155:0]                                       wmb_dcache_arb_ld_data_2_din,
output logic  [155:0]                                       wmb_dcache_arb_ld_data_1_din,               
output logic  [155:0]                                       wmb_dcache_arb_ld_data_0_din,
output logic  [15 :0]                                       wmb_dcache_arb_ld_data_req,    //no relation with WMB_entry, 7->15, for 4way data, L1D 2way->4way, LTL@20250320                  
output logic  [63 :0]                                       wmb_dcache_arb_ld_data_wen,    //31->63, L1D 2way->4way, LTL@20250321                 
output logic                                                wmb_dcache_arb_ld_req,                         
output logic                                                wmb_dcache_arb_ld_tag_gateclk_en,              
output logic  [7  :0]                                       wmb_dcache_arb_ld_tag_idx,      //8->7, L1D 2way->4way, LTL@20250321               
output logic                                                wmb_dcache_arb_ld_tag_req,                     
output logic  [3  :0]                                       wmb_dcache_arb_ld_tag_wen,      //1->3, L1D 2way->4way, LTL@20250321                 
output logic  [`WK_LS_DCACHE_META_WIDTH-1 :0]               wmb_dcache_arb_st_dirty_din,    //22->44, L1D 2way->4way, LTL@20250321               
output logic                                                wmb_dcache_arb_st_dirty_gateclk_en,            
output logic  [7  :0]                                       wmb_dcache_arb_st_dirty_idx,    //8->7, L1D 2way->4way, LTL@20250321                 
output logic                                                wmb_dcache_arb_st_dirty_req,                   
output logic  [15 :0]                                       wmb_dcache_arb_st_dirty_wen,    //8->15, L1D 2way->4way, LTL@20250321               
output logic                                                wmb_dcache_arb_st_icc_req,                     
output logic                                                wmb_dcache_arb_st_req,                         
output logic  [3  :0]                                       wmb_dcache_get_data,                           
output logic  [LSIQ_ENTRY-1:0]                              wmb_depd_wakeup0,      //1->3, for 3 lsiq, LTL@20241104                              
output logic  [LSIQ_ENTRY-1:0]                              wmb_depd_wakeup1,
output logic  [LSIQ_ENTRY-1:0]                              wmb_depd_wakeup2,
output logic                                                wmb_empty,                                     
output logic  [WMB_ENTRY-1:0]                               wmb_entry_vld,                                 
output logic  [15 :0]                                       wmb_ldc0_fwd_bytes_vld,  //1->3, for 3 ld, LTL@20241104   
output logic  [15 :0]                                       wmb_lsdc0_fwd_bytes_vld,
output logic  [15 :0]                                       wmb_lsdc1_fwd_bytes_vld,                         
output logic                                                wmb_has_pend,                                  
output logic                                                wmb_has_sync_fence,                            
output logic  [127:0]                                       wmb_lda0_fwd_data,          //fwd data, 1->3, LTL@20241104                  
output logic  [127:0]                                       wmb_lsda0_fwd_data,
output logic  [127:0]                                       wmb_lsda1_fwd_data,
output logic                                                wmb_ldc0_cancel_acc_req,   //depd check, 1->3, LTL@20241104                       
output logic                                                wmb_lsdc0_cancel_acc_req,
output logic                                                wmb_lsdc1_cancel_acc_req,
output logic                                                wmb_ldc0_discard_req,     //depd check, 1->3, LTL@20241104                        
output logic                                                wmb_lsdc0_discard_req,
output logic                                                wmb_lsdc1_discard_req,
output logic                                                wmb_ldc0_fwd_req,          //fwd req, 1->3, LTL@20241104                             
output logic                                                wmb_lsdc0_fwd_req,
output logic                                                wmb_lsdc1_fwd_req,
output logic  [127:0]                                       wmb_lwb0_data,     //fwd data, 1->3, LTL@20241104                                
output logic  [127:0]                                       wmb_lswb0_data,
output logic  [127:0]                                       wmb_lswb1_data,
output logic  [`WK_PA_WIDTH-1 :0]                           wmb_lwb0_data_addr,  //fwd data addr, 1->3, LTL@20241104                           
output logic  [`WK_PA_WIDTH-1 :0]                           wmb_lswb0_data_addr, //tie 0  
output logic  [`WK_PA_WIDTH-1 :0]                           wmb_lswb1_data_addr, //tie 0  
output logic  [IID_WIDTH-1:0]                               wmb_lwb0_data_iid,  //fwd data iid, 1->3, LTL@20241104  
output logic  [IID_WIDTH-1:0]                               wmb_lswb0_data_iid, //tie 0                             
output logic  [IID_WIDTH-1:0]                               wmb_lswb1_data_iid, //tie 0  
output logic                                                wmb_lwb0_data_req,   //wmb_ld_wb data req, 1->3, LTL@20241104                             
output logic                                                wmb_lswb0_data_req,  //tie 0  
output logic                                                wmb_lswb1_data_req,  //tie 0  
output logic                                                wmb_lwb0_inst_vfls,  //wmb_ld_wb inst vfls, 1->3, LTL@20241104                         
output logic                                                wmb_lswb0_inst_vfls, //tie 0  
output logic                                                wmb_lswb1_inst_vfls, //tie 0  
output logic                                                wmb_lwb0_inst_vls,  //wmb_ld_wb inst vls, 1->3, LTL@20241104 
output logic                                                wmb_lswb0_inst_vls, //tie 0  
output logic                                                wmb_lswb1_inst_vls, //tie 0                             
output logic  [PREG-1  :0]                                  wmb_lwb0_preg,     //wmb_ld_wb, 1->3, LTL@20241104                            
output logic  [PREG-1  :0]                                  wmb_lswb0_preg,    //tie 0  
output logic  [PREG-1  :0]                                  wmb_lswb1_preg,    //tie 0  
output logic  [3  :0]                                       wmb_lwb0_preg_sign_sel, //wmb_ld_wb , 1->3, LTL@20241104 
output logic  [3  :0]                                       wmb_lswb0_preg_sign_sel, //tie 0  
output logic  [3  :0]                                       wmb_lswb1_preg_sign_sel, //tie 0                       
output logic                                                wmb_lwb0_vmb_merge_vld,      //tie 0, 1->3, LTL@20241104                  
output logic                                                wmb_lswb0_vmb_merge_vld,
output logic                                                wmb_lswb1_vmb_merge_vld,
output logic  [VREG-1  :0]                                  wmb_lwb0_vreg,  //wmb_ld_wb, 1->3, LTL@20241104 
output logic  [VREG-1  :0]                                  wmb_lswb0_vreg,  //tie 0                                
output logic  [VREG-1  :0]                                  wmb_lswb1_vreg,  //tie 0  
output logic  [14 :0]                                       wmb_lwb0_vreg_sign_sel,  //wmb_ld_wb, 1->3, LTL@20241104 
output logic  [14 :0]                                       wmb_lswb0_vreg_sign_sel, //tie 0  
output logic  [14 :0]                                       wmb_lswb1_vreg_sign_sel, //tie 0                        
output logic                                                wmb_lm_already_read_req,                       
output logic                                                wmb_lm_state_clr,                              
output logic                                                wmb_lm_success,                                
output logic                                                wmb_no_op,                                     
output logic  [`WK_PA_WIDTH-1 :0]                           wmb_pend_addr_f,                               
output logic                                                wmb_pend_page_ca_f,                            
output logic                                                wmb_pend_page_so_f,                            
output logic                                                wmb_pfu_biu_req_hit_idx,                       
output logic                                                wmb_rb_biu_req_hit_idx,                        
output logic                                                wmb_rb_so_pending,                             
output logic  [`WK_PA_WIDTH-1 :0]                           wmb_read_req_addr,                             
output logic                                                wmb_read_req_dcache_inv_inst,                  
output logic                                                wmb_read_req_unmask,                           
output logic  [WMB_ENTRY-1:0]                               wmb_snq_depd,                                  
output logic  [WMB_ENTRY-1:0]                               wmb_snq_depd_remove,                           
output logic                                                wmb_sq_pop_grnt,                               
output logic                                                wmb_sq_pop_to_ce_grnt,                                             
output logic                                                wmb_lswb0_cmplt_req,      //wmb_st_wb, 1->2, LTL@20241104 
output logic                                                wmb_lswb1_cmplt_req,      //tie 0                      
output logic  [IID_WIDTH-1:0]                               wmb_lswb0_iid,  //wmb_st_wb, 1->2, LTL@20241104 
output logic  [IID_WIDTH-1:0]                               wmb_lswb1_iid,  //tie 0                                 
output logic                                                wmb_lswb0_inst_flush,   //wmb_st_wb, 1->2, LTL@20241104 
output logic                                                wmb_lswb1_inst_flush,   //tie 0                        
output logic                                                wmb_lswb0_spec_fail,  //wmb_st_wb, 1->2, LTL@20241104 
output logic                                                wmb_lswb1_spec_fail,    //tie 0                          
output logic                                                wmb_lswb0_vstart_vld,  //wmb_st_wb, 1->2, LTL@20241104 
output logic                                                wmb_lswb1_vstart_vld,   //tie 0                         
output logic                                                wmb_sync_fence_biu_req_success,                
output logic  [`WK_PA_WIDTH-7 :0]                           wmb_vb_addr_tto6,                              
output logic                                                wmb_vb_create_dp_vld,                          
output logic                                                wmb_vb_create_gateclk_en,                      
output logic                                                wmb_vb_create_req,                             
output logic                                                wmb_vb_create_vld,                             
output logic                                                wmb_vb_inv,                                    
output logic                                                wmb_vb_set_way_mode,                           
output logic  [WMB_ENTRY-1:0]                               wmb_write_ptr,                                 
output logic  [2  :0]                                       wmb_write_ptr_encode,     //need decide bit number with vb, ???? LTL@20241104                     
output logic  [`WK_PA_WIDTH-1 :0]                           wmb_write_req_addr,                            
output logic                                                wmb_write_req_icc,
//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
input  logic                                                dtu_lsu_data_trig_en,
input  logic  [`TDT_MP_HINFO_WIDTH-1:0]                     wmb_ce_halt_info_0,
input  logic  [`TDT_MP_HINFO_WIDTH-1:0]                     wmb_ce_halt_info_1,
input  logic                                                wmb_ce_expt_vld,                         
output logic  [`TDT_MP_HINFO_WIDTH-1:0]                     wmb_st_wb_halt_info_0,
output logic  [`TDT_MP_HINFO_WIDTH-1:0]                     wmb_st_wb_halt_info_1
//==========================================================
//                  Risc-V Debug zdb End 
//========================================================== 
);

                     
logic     [WMB_ENTRY-1:0]                                   wmb_create_ptr;                                
logic                                                       wmb_create_ptr_circular;                       
logic                                                       wmb_ctc_secd;                                  
logic     [WMB_ENTRY-1:0]                                   wmb_data_ptr;                                  
logic                                                       wmb_data_ptr_circular;                         
logic     [127:0]                                           wmb_data_req_data;                                                  
logic     [127:0]                                           wmb_fwd_data0; //fwd 1->3, LTL@20241104
logic     [127:0]                                           wmb_fwd_data1; 
logic     [127:0]                                           wmb_fwd_data2;                                
logic     [127:0]                                           wmb_fwd_data_sel0;//fwd 1->3, LTL@20241104
logic     [127:0]                                           wmb_fwd_data_sel1;
logic     [127:0]                                           wmb_fwd_data_sel2;                             
logic     [`WK_PA_WIDTH-1 :0]                               wmb_last_create_addr;                          
logic                                                       wmb_pop_depd_ff;                               
logic                                                       wmb_read_dp_req;                               
logic     [WMB_ENTRY-1:0]                                   wmb_read_ptr;                                  
logic                                                       wmb_read_ptr_circular;                            
logic     [WMB_ENTRY-1:0]                                   wmb_st_wb_cmplt_ptr;                           
logic     [LSIQ_ENTRY-1:0]                                  wmb_wakeup_queue0;  //3 wakeup queue, for 3 pipe, LTL@20241104
logic     [LSIQ_ENTRY-1:0]                                  wmb_wakeup_queue1;
logic     [LSIQ_ENTRY-1:0]                                  wmb_wakeup_queue2;                          
logic                                                       wmb_write_biu_dp_req;                          
logic     [`WK_PA_WIDTH-1 :0]                               wmb_write_dcache_addr;                         
logic     [127:0]                                           wmb_write_dcache_data;                         
logic                                                       wmb_write_dcache_pop_req;                      
logic     [WMB_ENTRY-1:0]                                   wmb_write_dcache_priority;                     
logic     [WMB_ENTRY-1:0]                                   wmb_write_dcache_ptr;                          
logic     [WMB_ENTRY-1:0]                                   wmb_write_dcache_ptr_set;                      
logic                                                       wmb_write_imme;                                
logic                                                       wmb_write_imme_hold;                                                          
logic                                                       wmb_write_ptr_circular;                        
logic                                                       wmb_write_ptr_circular_set;                    
logic     [WMB_ENTRY-1:0]                                   wmb_write_ptr_set;                                           
logic     [`WK_PA_WIDTH-1 :0]                               wmb_write_req_addr_set;                        
logic                                                       wmb_write_req_atomic;                          
logic                                                       wmb_write_req_atomic_set;                                    
logic                                                       wmb_write_req_icc_set;                         
logic                                                       wmb_write_req_page_ca;                         
logic                                                       wmb_write_req_page_ca_set;                     
logic                                                       wmb_write_req_page_share;                      
logic                                                       wmb_write_req_page_share_set;                  
logic                                                       wmb_write_req_sync_fence;                      
logic                                                       wmb_write_req_sync_fence_set;                           
logic                                                       pw_ecc_idle;                                   
logic                                                       pw_en;                                         
logic                                                       pw_merge_stall;                                
logic                                                       pw_read;                                        
logic                                                       wmb_b_resp_exokay;                             
logic                                                       wmb_b_so_id_hit;                               
logic    [3  :0]                                            wmb_biu_ar_addr_judge;                                      
logic    [`WK_PA_WIDTH-1 :0]                                wmb_biu_ar_icache_first_addr;  
logic    [`WK_PA_WIDTH-1 :0]                                wmb_biu_ar_icache_secd_addr;     
logic    [`WK_PA_WIDTH-1 :0]                                wmb_biu_ar_l2cache_first_addr;                                   
logic    [`WK_PA_WIDTH-1 :0]                                wmb_biu_ar_tlbi_first_addr;                    
logic    [`WK_PA_WIDTH-1 :0]                                wmb_biu_ar_tlbi_secd_addr;                                    
logic    [4  :0]                                            wmb_biu_aw_id_judge;                             
logic                                                       wmb_biu_aw_size_maintain;                                
logic                                                       wmb_biu_so_recv_gateclk_en;                    
logic                                                       wmb_biu_so_req_gateclk_en;                     
logic                                                       wmb_biu_so_req_grnt;  
logic                                                       wmb_biu_write_en;                                    
logic                                                       wmb_ce_create_depd_create_ptr;                                                   
logic                                                       wmb_ce_last_addr_eq_high;                      
logic                                                       wmb_ce_last_addr_plus;                         
logic                                                       wmb_ce_last_addr_sub;                                                               
logic                                                       wmb_ce_update_same_dcache_line;                
logic    [WMB_ENTRY-1:0]                                    wmb_ce_update_same_dcache_line_ptr;                                                        
logic                                                       wmb_clk_en;                                    
logic    [WMB_ENTRY-1:0]                                    wmb_create_not_vld;                            
logic                                                       wmb_create_permit;                             
logic                                                       wmb_create_ptr_clk;                            
logic                                                       wmb_create_ptr_clk_en;                         
logic    [WMB_ENTRY-1:0]                                    wmb_create_ptr_next1;                          
logic                                                       wmb_create_vb_success;                         
logic                                                       wmb_create_vld;                                
logic                                                       wmb_create_write_imme_set;                     
logic                                                       wmb_data_biu_req;                              
logic                                                       wmb_data_grnt;                                 
logic                                                       wmb_data_ptr_after_write_shift_imme;           
logic                                                       wmb_data_ptr_after_write_shift_imme_gate;      
logic                                                       wmb_data_ptr_clk;                              
logic                                                       wmb_data_ptr_clk_en;                           
logic                                                       wmb_data_ptr_met_create;                       
logic    [WMB_ENTRY-1:0]                                    wmb_data_ptr_next1;                            
logic                                                       wmb_data_ptr_shift_vld;                        
logic                                                       wmb_data_ptr_with_write_shift_imme;            
logic                                                       wmb_data_req;                                  
logic    [4  :0]                                            wmb_data_req_biu_id;                           
logic    [15 :0]                                            wmb_data_req_bytes_vld;                        
logic                                                       wmb_data_req_w_last;                           
logic                                                       wmb_data_req_wns;  
logic    [15 :0]                                            wmb_dcache_arb_ld_data_req_unmask;    //7->15, L1D 2way->4way, LTL@20250321                                        
logic                                                       wmb_dcache_arb_req;                            
logic                                                       wmb_dcache_arb_req_unmask;                                  
logic    [1  :0]                                            wmb_dcache_data_high_sel;     //1bit->2bit, L1D 2way->4way, LTL@20250321                 
logic    [3  :0]                                            wmb_dcache_data_region;                                  
logic                                                       wmb_dcache_inst_write_req_hit_idx;             
logic                                                       wmb_dcache_req_next;                           
logic    [WMB_ENTRY-1:0]                                    wmb_dcache_req_ptr;                            
logic    [WMB_ENTRY-1:0]                                    wmb_dcache_req_set;                                     
logic    [`WK_LS_DCACHE_STTAG_AF_ECC_LENGTH-1 :0]           wmb_dirty_af_ecc;                              
logic    [`WK_LS_DCACHE_META_WIDTH-1 :0]                    wmb_dirty_ecc_din;           //22->44, L1D 2way->4way, LTL@20250321                    
logic                                                       wmb_discard_req0;  //1->3 for 3 ld_dc, LTL@220241019  
logic                                                       wmb_discard_req1;
logic                                                       wmb_discard_req2;                            
logic    [15 :0]                                            wmb_ecc_data_wen;                              
logic                                                       wmb_ecc_fatal_err;                             
logic                                                       wmb_ecc_fsm_start;                             
logic                                                       wmb_ecc_getdp;                                 
logic    [127:0]                                            wmb_ecc_st_data;                               
logic    [155:0]                                            wmb_ecc_write_data;                            
logic                                                       wmb_ecc_write_req;                                            
logic    [WMB_ENTRY-1:0]                                    wmb_entry_1_entry_w_last;                      
//logic    [39 :0]  wmb_entry_addr_0;       //need paramter, LTL@220241019                       
//logic    [39 :0]  wmb_entry_addr_1;                              
//logic    [39 :0]  wmb_entry_addr_2;                              
//logic    [39 :0]  wmb_entry_addr_3;                              
//logic    [39 :0]  wmb_entry_addr_4;                              
//logic    [39 :0]  wmb_entry_addr_5;                              
//logic    [39 :0]  wmb_entry_addr_6;                              
//logic    [39 :0]  wmb_entry_addr_7;  
logic    [WMB_ENTRY-1:0][`WK_PA_WIDTH-1 :0]               wmb_entry_addr; //use array for parameter, LTL@20241104                         
logic    [WMB_ENTRY-1:0]                                  wmb_entry_already_read_req;                    
logic    [WMB_ENTRY-1:0]                                  wmb_entry_ar_pending;                          
logic    [WMB_ENTRY-1:0]                                  wmb_entry_atomic;                              
logic    [WMB_ENTRY-1:0]                                  wmb_entry_atomic_and_vld;                      
logic    [WMB_ENTRY-1:0]                                  wmb_entry_aw_pending;                          
//logic    [4  :0]  wmb_entry_biu_id_0;                            
//logic    [4  :0]  wmb_entry_biu_id_1;                            
//logic    [4  :0]  wmb_entry_biu_id_2;                            
//logic    [4  :0]  wmb_entry_biu_id_3;                            
//logic    [4  :0]  wmb_entry_biu_id_4;                            
//logic    [4  :0]  wmb_entry_biu_id_5;                            
//logic    [4  :0]  wmb_entry_biu_id_6;                            
//logic    [4  :0]  wmb_entry_biu_id_7;
logic    [WMB_ENTRY-1:0][4  :0]                           wmb_entry_biu_id; //use array for parameter, LTL@20241104                                                     
//logic    [15 :0]  wmb_entry_bytes_vld_0;                         
//logic    [15 :0]  wmb_entry_bytes_vld_1;                         
//logic    [15 :0]  wmb_entry_bytes_vld_2;                         
//logic    [15 :0]  wmb_entry_bytes_vld_3;                         
//logic    [15 :0]  wmb_entry_bytes_vld_4;                         
//logic    [15 :0]  wmb_entry_bytes_vld_5;                         
//logic    [15 :0]  wmb_entry_bytes_vld_6;                         
//logic    [15 :0]  wmb_entry_bytes_vld_7;
logic    [WMB_ENTRY-1:0][15 :0]                           wmb_entry_bytes_vld; //use array for parameter, LTL@20241104                           
logic    [WMB_ENTRY-1:0]                                  wmb_entry_cancel_acc_req0; //1->3 for 3 ld dc, LTL@20241024 
logic    [WMB_ENTRY-1:0]                                  wmb_entry_cancel_acc_req1;                      
logic    [WMB_ENTRY-1:0]                                  wmb_entry_cancel_acc_req2;                   
logic    [WMB_ENTRY-1:0]                                  wmb_entry_create_data_vld;                     
logic    [WMB_ENTRY-1:0]                                  wmb_entry_create_dp_vld;                       
logic    [WMB_ENTRY-1:0]                                  wmb_entry_create_gateclk_en;                   
logic    [WMB_ENTRY-1:0]                                  wmb_entry_create_vld;                          
//logic    [127:0]  wmb_entry_data_0;                              
//logic    [127:0]  wmb_entry_data_1;                              
//logic    [127:0]  wmb_entry_data_2;                              
//logic    [127:0]  wmb_entry_data_3;                              
//logic    [127:0]  wmb_entry_data_4;                              
//logic    [127:0]  wmb_entry_data_5;                              
//logic    [127:0]  wmb_entry_data_6;                              
//logic    [127:0]  wmb_entry_data_7;
logic    [WMB_ENTRY-1:0][127:0]                           wmb_entry_data; //use array for parameter, LTL@20241104                             
logic    [WMB_ENTRY-1:0]                                  wmb_entry_data_biu_req;                        
logic    [WMB_ENTRY-1:0]                                  wmb_entry_data_ptr_after_write_shift_imme;     
logic    [WMB_ENTRY-1:0]                                  wmb_entry_data_ptr_after_write_shift_imme_gate; 
logic    [WMB_ENTRY-1:0]                                  wmb_entry_data_ptr_with_write_shift_imme;      
logic    [WMB_ENTRY-1:0]                                  wmb_entry_data_req;                            
logic    [WMB_ENTRY-1:0]                                  wmb_entry_data_req_wns;                        
logic    [WMB_ENTRY-1:0]                                  wmb_entry_dcache_inst;                         
logic    [WMB_ENTRY-1:0]                                  wmb_entry_dcache_inst_same_line;               
logic    [WMB_ENTRY-1:0]                                  wmb_entry_dcache_line_w_last;                  
logic    [WMB_ENTRY-1:0]                                  wmb_entry_dcache_page_share;                   
logic    [WMB_ENTRY-1:0]                                  wmb_entry_dcache_dirty;
logic    [WMB_ENTRY-1:0]                                  wmb_entry_dcache_share;                   
logic    [WMB_ENTRY-1:0]                                  wmb_entry_dcache_valid;
logic    [WMB_ENTRY-1:0][1:0]                             wmb_entry_dcache_way;                          
logic    [WMB_ENTRY-1:0]                                  wmb_entry_depd;                                
logic    [WMB_ENTRY-1:0]                                  wmb_entry_discard_req0;//1->3, for 3 ld_dc, LTL@20241024 
logic    [WMB_ENTRY-1:0]                                  wmb_entry_discard_req1; 
logic    [WMB_ENTRY-1:0]                                  wmb_entry_discard_req2;                        
logic    [WMB_ENTRY-1:0]                                  wmb_entry_dtcm_hit;                            
//logic    [15 :0]  wmb_entry_fwd_bytes_vld_0;      //1->3, for 3 ld_dc and parameterized, LTL@20241104               
//logic    [15 :0]  wmb_entry_fwd_bytes_vld_1;                     
//logic    [15 :0]  wmb_entry_fwd_bytes_vld_2;                     
//logic    [15 :0]  wmb_entry_fwd_bytes_vld_3;                     
//logic    [15 :0]  wmb_entry_fwd_bytes_vld_4;                     
//logic    [15 :0]  wmb_entry_fwd_bytes_vld_5;                     
//logic    [15 :0]  wmb_entry_fwd_bytes_vld_6;                     
//logic    [15 :0]  wmb_entry_fwd_bytes_vld_7;
logic    [WMB_ENTRY-1:0][15 :0]                           wmb_entry_fwd_bytes_vld0;  //use array for parameter, 1->3 for 3 ld fwd, LTL@20241104  
logic    [WMB_ENTRY-1:0][15 :0]                           wmb_entry_fwd_bytes_vld1;
logic    [WMB_ENTRY-1:0][15 :0]                           wmb_entry_fwd_bytes_vld2;
logic    [WMB_ENTRY-1:0]                                  wmb_entry_fwd_data_pe_gateclk_en0;  //1->3, for 3 ld_dc, LTL@20241104 
logic    [WMB_ENTRY-1:0]                                  wmb_entry_fwd_data_pe_gateclk_en1;
logic    [WMB_ENTRY-1:0]                                  wmb_entry_fwd_data_pe_gateclk_en2;            
logic    [WMB_ENTRY-1:0]                                  wmb_entry_fwd_data_pe_req0;   //1->3, for 3 ld_dc, LTL@20241104 
logic    [WMB_ENTRY-1:0]                                  wmb_entry_fwd_data_pe_req1;
logic    [WMB_ENTRY-1:0]                                  wmb_entry_fwd_data_pe_req2;                    
logic    [WMB_ENTRY-1:0]                                  wmb_entry_fwd_req0;   //1->3, for 3 ld_dc, LTL@20241104 
logic    [WMB_ENTRY-1:0]                                  wmb_entry_fwd_req1;
logic    [WMB_ENTRY-1:0]                                  wmb_entry_fwd_req2;                            
logic    [WMB_ENTRY-1:0]                                  wmb_entry_icc;                                 
logic    [WMB_ENTRY-1:0]                                  wmb_entry_icc_and_vld;                         
//logic    [IID_WIDTH-1:0]  wmb_entry_iid_0;                               
//logic    [IID_WIDTH-1:0]  wmb_entry_iid_1;                               
//logic    [IID_WIDTH-1:0]  wmb_entry_iid_2;                               
//logic    [IID_WIDTH-1:0]  wmb_entry_iid_3;                               
//logic    [IID_WIDTH-1:0]  wmb_entry_iid_4;                               
//logic    [IID_WIDTH-1:0]  wmb_entry_iid_5;                               
//logic    [IID_WIDTH-1:0]  wmb_entry_iid_6;                               
//logic    [IID_WIDTH-1:0]  wmb_entry_iid_7;
logic    [WMB_ENTRY-1:0][IID_WIDTH-1:0]                   wmb_entry_iid; //use array for parameter, LTL@20241104                                
logic    [WMB_ENTRY-1:0]                                  wmb_entry_inst_flush;                          
logic    [WMB_ENTRY-1:0]                                  wmb_entry_inst_is_dcache;                      
//logic    [1  :0]  wmb_entry_inst_mode_0;                         
//logic    [1  :0]  wmb_entry_inst_mode_1;                         
//logic    [1  :0]  wmb_entry_inst_mode_2;                         
//logic    [1  :0]  wmb_entry_inst_mode_3;                         
//logic    [1  :0]  wmb_entry_inst_mode_4;                         
//logic    [1  :0]  wmb_entry_inst_mode_5;                         
//logic    [1  :0]  wmb_entry_inst_mode_6;                         
//logic    [1  :0]  wmb_entry_inst_mode_7; 
logic    [WMB_ENTRY-1:0][1  :0]                           wmb_entry_inst_mode; //use array for parameter, LTL@20241104                         
//logic    [2  :0]  wmb_entry_inst_size_0;                         
//logic    [2  :0]  wmb_entry_inst_size_1;                         
//logic    [2  :0]  wmb_entry_inst_size_2;                         
//logic    [2  :0]  wmb_entry_inst_size_3;                         
//logic    [2  :0]  wmb_entry_inst_size_4;                         
//logic    [2  :0]  wmb_entry_inst_size_5;                         
//logic    [2  :0]  wmb_entry_inst_size_6;                         
//logic    [2  :0]  wmb_entry_inst_size_7;
logic    [WMB_ENTRY-1:0][2  :0]                           wmb_entry_inst_size; //use array for parameter, LTL@20241104                       
//logic    [1  :0]  wmb_entry_inst_type_0;                         
//logic    [1  :0]  wmb_entry_inst_type_1;                         
//logic    [1  :0]  wmb_entry_inst_type_2;                         
//logic    [1  :0]  wmb_entry_inst_type_3;                         
//logic    [1  :0]  wmb_entry_inst_type_4;                         
//logic    [1  :0]  wmb_entry_inst_type_5;                         
//logic    [1  :0]  wmb_entry_inst_type_6;                         
//logic    [1  :0]  wmb_entry_inst_type_7; 
logic    [WMB_ENTRY-1:0][1  :0]                           wmb_entry_inst_type; //use array for parameter, LTL@20241104                          
logic    [WMB_ENTRY-1:0]                                  wmb_entry_last_addr_plus;                      
logic    [WMB_ENTRY-1:0]                                  wmb_entry_last_addr_sub;                       
logic    [WMB_ENTRY-1:0]                                  wmb_entry_mem_set_write_gateclk_en;            
logic    [WMB_ENTRY-1:0]                                  wmb_entry_mem_set_write_grnt;                  
logic    [WMB_ENTRY-1:0]                                  wmb_entry_merge_data_addr_hit;                 
logic    [WMB_ENTRY-1:0]                                  wmb_entry_merge_data_stall;                    
logic    [WMB_ENTRY-1:0]                                  wmb_entry_merge_data_vld;                      
logic    [WMB_ENTRY-1:0]                                  wmb_entry_merge_data_wait_not_vld_req;         
logic    [WMB_ENTRY-1:0]                                  wmb_entry_next_so_bypass;                      
logic    [WMB_ENTRY-1:0]                                  wmb_entry_no_op;                               
logic    [WMB_ENTRY-1:0]                                  wmb_entry_page_buf;                            
logic    [WMB_ENTRY-1:0]                                  wmb_entry_page_ca;                             
logic    [WMB_ENTRY-1:0]                                  wmb_entry_page_sec;                            
logic    [WMB_ENTRY-1:0]                                  wmb_entry_page_share;                          
logic    [WMB_ENTRY-1:0]                                  wmb_entry_page_so;                             
logic    [WMB_ENTRY-1:0]                                  wmb_entry_page_wa;                             
logic    [WMB_ENTRY-1:0]                                  wmb_entry_pfu_biu_req_hit_idx;                 
logic    [WMB_ENTRY-1:0]                                  wmb_entry_pop_vld;                             
//logic    [6  :0]  wmb_entry_preg_0;                              
//logic    [6  :0]  wmb_entry_preg_1;                              
//logic    [6  :0]  wmb_entry_preg_2;                              
//logic    [6  :0]  wmb_entry_preg_3;                              
//logic    [6  :0]  wmb_entry_preg_4;                              
//logic    [6  :0]  wmb_entry_preg_5;                              
//logic    [6  :0]  wmb_entry_preg_6;                              
//logic    [6  :0]  wmb_entry_preg_7;
logic    [WMB_ENTRY-1:0][PREG-1:0]                        wmb_entry_preg;  // use array for parameter, LTL@20241104                            
//logic    [1  :0]  wmb_entry_priv_mode_0;                         
//logic    [1  :0]  wmb_entry_priv_mode_1;                         
//logic    [1  :0]  wmb_entry_priv_mode_2;                         
//logic    [1  :0]  wmb_entry_priv_mode_3;                         
//logic    [1  :0]  wmb_entry_priv_mode_4;                         
//logic    [1  :0]  wmb_entry_priv_mode_5;                         
//logic    [1  :0]  wmb_entry_priv_mode_6;                         
//logic    [1  :0]  wmb_entry_priv_mode_7; 
logic    [WMB_ENTRY-1:0][1  :0]                           wmb_entry_priv_mode; //use array for parameter, LTL@20241104                      
logic    [WMB_ENTRY-1:0]                                  wmb_entry_rb_biu_req_hit_idx;                  
logic    [WMB_ENTRY-1:0]                                  wmb_entry_read_dp_req;                         
logic    [WMB_ENTRY-1:0]                                  wmb_entry_read_ptr_chk_idx_shift_imme;         
logic    [WMB_ENTRY-1:0]                                  wmb_entry_read_ptr_unconditional_shift_imme;   
logic    [WMB_ENTRY-1:0]                                  wmb_entry_read_req;                            
logic    [WMB_ENTRY-1:0]                                  wmb_entry_read_resp_ready;                     
logic    [WMB_ENTRY-1:0]                                  wmb_entry_ready_to_dcache_line;                
logic    [WMB_ENTRY-1:0]                                  wmb_entry_sc_wb_success;                       
logic    [WMB_ENTRY-1:0]                                  wmb_entry_snq_depd;                            
logic    [WMB_ENTRY-1:0]                                  wmb_entry_snq_depd_remove;                     
logic    [WMB_ENTRY-1:0]                                  wmb_entry_spec_fail;                           
logic    [WMB_ENTRY-1:0]                                  wmb_entry_sq_pop_sameline_set;                 
logic    [WMB_ENTRY-1:0]                                  wmb_entry_st_hit_sq_pop_dcache_line;           
logic    [WMB_ENTRY-1:0]                                  wmb_entry_sync_fence;                          
logic    [WMB_ENTRY-1:0]                                  wmb_entry_sync_fence_biu_req_success;          
logic    [WMB_ENTRY-1:0]                                  wmb_entry_sync_fence_inst;                                        
logic    [WMB_ENTRY-1:0]                                  wmb_entry_vstart_vld;                          
logic    [WMB_ENTRY-1:0]                                  wmb_entry_w_last;                              
logic    [WMB_ENTRY-1:0]                                  wmb_entry_w_last_set;                          
logic    [WMB_ENTRY-1:0]                                  wmb_entry_w_pending;                           
logic    [WMB_ENTRY-1:0]                                  wmb_entry_wb_cmplt_grnt;                       
logic    [WMB_ENTRY-1:0]                                  wmb_entry_wb_cmplt_req;                        
logic    [WMB_ENTRY-1:0]                                  wmb_entry_wb_data_grnt;                        
logic    [WMB_ENTRY-1:0]                                  wmb_entry_wb_data_req;                         
logic    [WMB_ENTRY-1:0]                                  wmb_entry_write_biu_dp_req;                    
logic    [WMB_ENTRY-1:0]                                  wmb_entry_write_biu_req;                       
logic    [WMB_ENTRY-1:0]                                  wmb_entry_write_dcache_req;                    
logic    [WMB_ENTRY-1:0]                                  wmb_entry_write_imme;                          
logic    [WMB_ENTRY-1:0]                                  wmb_entry_write_imme_bypass;                   
logic    [WMB_ENTRY-1:0]                                  wmb_entry_write_ptr_chk_idx_shift_imme;        
logic    [WMB_ENTRY-1:0]                                  wmb_entry_write_ptr_unconditional_shift_imme;  
logic    [WMB_ENTRY-1:0]                                  wmb_entry_write_req;                           
logic    [WMB_ENTRY-1:0]                                  wmb_entry_write_stall;                         
logic    [WMB_ENTRY-1:0]                                  wmb_entry_write_tcm_req;                       
logic    [WMB_ENTRY-1:0]                                  wmb_entry_write_vb_req;                        
logic                                                     wmb_fwd_data_pe_clk0; //fwd 1->3, for 3 ld_dc, LTL@20241104
logic                                                     wmb_fwd_data_pe_clk1;
logic                                                     wmb_fwd_data_pe_clk2;                           
logic                                                     wmb_fwd_data_pe_clk_en0;  //fwd 1->3, for 3 ld_dc, LTL@20241104
logic                                                     wmb_fwd_data_pe_clk_en1;
logic                                                     wmb_fwd_data_pe_clk_en2;                        
logic                                                     wmb_fwd_data_pe_gateclk_en0;  //fwd 1->3, for 3 ld_dc, LTL@20241104
logic                                                     wmb_fwd_data_pe_gateclk_en1; 
logic                                                     wmb_fwd_data_pe_gateclk_en2;                   
logic                                                     wmb_fwd_data_pe_req0;   //fwd req 1->3, for 3 ld_dc, LTL@20241104
logic                                                     wmb_fwd_data_pe_req1;
logic                                                     wmb_fwd_data_pe_req2;                         
logic                                                     wmb_fwd_req0;  //fwd req 1->3, for 3 ld_dc, LTL@20241104
logic                                                     wmb_fwd_req1;
logic                                                     wmb_fwd_req2;                                 
logic                                                     wmb_has_dcache_inst;                  
logic                                                     wmb_idfifo_so_clk_en;                          
logic                                                     wmb_idfifo_so_create_vld;                      
logic                                                     wmb_idfifo_so_pop_vld;                         
logic    [1  :0]                                          wmb_last_addr_plus;                            
logic    [1  :0]                                          wmb_last_addr_sub;                             
logic    [WMB_ENTRY-1:0]                                  wmb_ld_wb_data_ptr;                            
logic                                                     wmb_lwb0_data_success;       //wmb_ld_wb, 1->3, LTL@20241104                 
logic                                                     wmb_lswb0_data_success;
logic                                                     wmb_lswb1_data_success;                                  
logic                                                     wmb_mem_set_write_gateclk_en;                  
logic                                                     wmb_mem_set_write_grnt;                        
logic                                                     wmb_merge_data_addr_hit;                       
logic                                                     wmb_merge_data_stall;                          
logic                                                     wmb_merge_vld;                                       
logic                                                     wmb_other4_write_imme;                         
logic                                                     wmb_other_write_imme;                                    
logic                                                     wmb_pend_busy;                                 
logic    [WMB_ENTRY-1:0]                                  wmb_pend_entry;           
logic                                                     wmb_pop_depd;                                  
logic                                                     wmb_pop_discard_req;                           
logic                                                     wmb_pop_fwd_req;                               
logic                                                     wmb_pop_to_ce_permit;                                      
logic                                                     wmb_read_dp_req_next1;                         
logic                                                     wmb_read_grnt;                                 
logic                                                     wmb_read_pop_clk;                              
logic                                                     wmb_read_pop_clk_en;                           
logic                                                     wmb_read_pop_up_wmb_ce_vld;                    
logic                                                     wmb_read_ptr_chk_idx_shift_imme;               
logic                                                     wmb_read_ptr_clk;                              
logic                                                     wmb_read_ptr_clk_en;                           
logic    [2  :0]                                          wmb_read_ptr_encode;                           
logic                                                     wmb_read_ptr_met_create;                       
logic    [WMB_ENTRY-1:0]                                  wmb_read_ptr_next1;                            
logic                                                     wmb_read_ptr_next1_met_create;                 
logic                                                     wmb_read_ptr_read_req_grnt;                    
logic                                                     wmb_read_ptr_shift_imme_grnt;                  
logic                                                     wmb_read_ptr_shift_vld;                        
logic                                                     wmb_read_ptr_unconditional_shift_imme;         
logic    [`WK_PA_WIDTH-1 :0]                              wmb_read_req_addr_next1;                       
logic                                                     wmb_read_req_atomic;                           
logic                                                     wmb_read_req_ctc_end;                          
logic                                                     wmb_read_req_ctc_inst;                         
logic    [15 :0]                                          wmb_read_req_data;                                             
logic                                                     wmb_read_req_dcache_l1_inst;                   
logic                                                     wmb_read_req_hit_idx;                          
logic                                                     wmb_read_req_icache_all_inst;                  
logic                                                     wmb_read_req_icache_inst;                      
logic                                                     wmb_read_req_icc;                              
logic                                                     wmb_read_req_inst_is_dcache;                   
logic    [1  :0]                                          wmb_read_req_inst_mode;                        
logic    [1  :0]                                          wmb_read_req_inst_size;                        
logic    [1  :0]                                          wmb_read_req_inst_type;                        
logic                                                     wmb_read_req_l2cache_inst;                     
logic                                                     wmb_read_req_page_sec;                         
logic                                                     wmb_read_req_page_share;                       
logic    [1  :0]                                          wmb_read_req_priv_mode;                        
logic                                                     wmb_read_req_tlbi_asid_inst;                   
logic                                                     wmb_read_req_tlbi_inst;                        
logic                                                     wmb_read_req_tlbi_va_inst;                                              
logic    [WMB_ENTRY-1:0]                                  wmb_same_line_resp_ready;                                                                 
logic                                                     wmb_so_no_pending;                                 
logic                                                     wmb_lswb0_atomic;  //wmb_st_wb, 1->2, LTL@20241104
logic                                                     wmb_lswb1_atomic;                                    
logic                                                     wmb_lswb0_sc_wb_success;  //wmb_st_wb, 1->2, LTL@20241104
logic                                                     wmb_lswb1_sc_wb_success;                                       
logic    [`WK_LS_DCACHE_STTAG_BF_ECC_LENGTH-1 :0]         wmb_tag_bf_ecc;                                
logic    [`WK_LS_DATASRAM_ECC_WIDTH-1  :0]                wmb_tag_ecc;                                   
logic                                                     wmb_tag_parity;                                
logic                                                     wmb_tcm_dtcm_sel;                              
logic                                                     wmb_tcm_grant;                                 
logic                                                     wmb_tcm_pending;                               
logic                                                     wmb_tcm_req_unmask;                            
logic    [WMB_ENTRY-1:0]                                  wmb_tcm_write_done;                                                          
logic                                                     wmb_wakeup_queue_clk0; //wakeup queue clk, 3 for 3 pipes, LTL@20241104
logic                                                     wmb_wakeup_queue_clk1; 
logic                                                     wmb_wakeup_queue_clk2;                         
logic                                                     wmb_wakeup_queue_clk_en0;//wakeup queue clk en, 3 for 3 pipes, LTL@20241104
logic                                                     wmb_wakeup_queue_clk_en1;
logic                                                     wmb_wakeup_queue_clk_en2;                     
logic    [LSIQ_ENTRY-1:0]                                 wmb_wakeup_queue_grnt0;//wakeup queue, 4 for 4 pipes, LTL@20241104
logic    [LSIQ_ENTRY-1:0]                                 wmb_wakeup_queue_grnt1;
logic    [LSIQ_ENTRY-1:0]                                 wmb_wakeup_queue_grnt2;                        
logic    [LSIQ_ENTRY-1:0]                                 wmb_wakeup_queue_next0;//wakeup queue, 4 for 4 pipes, LTL@20241104
logic    [LSIQ_ENTRY-1:0]                                 wmb_wakeup_queue_next1;
logic    [LSIQ_ENTRY-1:0]                                 wmb_wakeup_queue_next2;                        
logic                                                     wmb_wakeup_queue_not_empty; //1->3 for 3 wakeup queue, contain 0-3 cond. LTL@20241104
logic                                                     wmb_wakeup_queue_not_empty0;//1->3 for 3 wakeup queue, LTL@20241104
logic                                                     wmb_wakeup_queue_not_empty1;
logic                                                     wmb_wakeup_queue_not_empty2;                  
logic                                                     wmb_write_biu_dcache_line;                     
logic                                                     wmb_write_biu_dp_req_next1;                    
logic                                                     wmb_write_biu_req_unmask;                      
logic                                                     wmb_write_burst_neg;                           
logic    [`WK_PA_WIDTH-1 :0]                              wmb_write_dcache_addr_set;                     
logic                                                     wmb_write_dcache_atomic;                       
logic    [15 :0]                                          wmb_write_dcache_bytes_vld;                    
logic                                                     wmb_write_dcache_icc;                          
logic                                                     wmb_write_dcache_permit;                       
logic                                                     wmb_write_dcache_pop_clk;                      
logic                                                     wmb_write_dcache_pop_clk_en;                   
logic                                                     wmb_write_dcache_pop_up;                       
logic                                                     wmb_write_dcache_req_icc_inst;                 
logic                                                     wmb_write_dcache_stall;                        
logic                                                     wmb_write_dcache_success;                      
logic                                                     wmb_write_dcache_success_ori;                  
logic                                                     wmb_write_dcache_sync_fence;                   
logic    [15 :0]                                          wmb_write_dcache_wen;                          
logic                                                     wmb_write_grnt;                                
logic                                                     wmb_write_imme_amr_clr;                        
logic                                                     wmb_write_imme_bypass;                         
logic                                                     wmb_write_imme_clr;                            
logic                                                     wmb_write_imme_hold_set;                       
logic                                                     wmb_write_imme_ori;                            
logic                                                     wmb_write_imme_other_bypass;                   
logic                                                     wmb_write_imme_set;                            
logic                                                     wmb_write_pop_clk;                             
logic                                                     wmb_write_pop_clk_en;                          
logic                                                     wmb_write_pop_up_wmb_ce_gateclk_en;            
logic                                                     wmb_write_pop_up_wmb_ce_vld;                   
logic                                                     wmb_write_ptr_chk_idx_shift_imme;              
logic                                                     wmb_write_ptr_circular_set_vld;                
logic                                                     wmb_write_ptr_clk;                             
logic                                                     wmb_write_ptr_clk_en;                                                
logic                                                     wmb_write_ptr_met_create; 
logic    [2  :0]                                          wmb_write_ptr_next3_encode;     //encode bit number ??? LTL@20241104  
logic                                                     wmb_write_ptr_next1_met_create; 
//logic    [WMB_ENTRY-1:0]  wmb_write_ptr_next1;    //need parameterized,  wmb_write_ptr_next[1], LTL@20241104                       
//logic    [WMB_ENTRY-1:0]  wmb_write_ptr_next2;                           
//logic    [WMB_ENTRY-1:0]  wmb_write_ptr_next3;                           
//logic    [WMB_ENTRY-1:0]  wmb_write_ptr_next4;                           
//logic    [WMB_ENTRY-1:0]  wmb_write_ptr_next5;                           
//logic    [WMB_ENTRY-1:0]  wmb_write_ptr_next6;                           
//logic    [WMB_ENTRY-1:0]  wmb_write_ptr_next7;   //need parameterized,  wmb_write_ptr_next[7], 
logic    [WMB_ENTRY-1:0][WMB_ENTRY-1:0]                   wmb_write_ptr_next;//use array for parameter, LTL@20241104                          
logic                                                     wmb_write_ptr_shift_imme_grnt;                 
logic                                                     wmb_write_ptr_shift_vld;                       
logic    [WMB_ENTRY-1:0]                                  wmb_write_ptr_to_next3;                        
logic                                                     wmb_write_ptr_unconditional_shift_imme;        
logic                                                     wmb_write_req;                                 
logic                                                     wmb_write_req_addr_dcache_begin;               
logic    [`WK_PA_WIDTH-1 :0]                              wmb_write_req_addr_next1;                      
logic                                                     wmb_write_req_atomic_next1;                    
logic                                                     wmb_write_req_dcache_page_share;               
logic                                                     wmb_write_req_dcache_dirty;
logic                                                     wmb_write_req_dcache_share;
logic                                                     wmb_write_req_dcache_valid;
logic    [1  :0]                                          wmb_write_req_dcache_way;    //1->2bit, L1D 2->4way, LTL@20250323                  
logic                                                     wmb_write_req_default_domain;                  
logic                                                     wmb_write_req_hit_idx;                         
logic                                                     wmb_write_req_icc_next1;                       
logic    [1  :0]                                          wmb_write_req_inst_mode;                       
logic    [2  :0]                                          wmb_write_req_inst_size;                       
logic    [1  :0]                                          wmb_write_req_inst_type;                       
logic                                                     wmb_write_req_next1_addr_plus;                 
logic                                                     wmb_write_req_next1_addr_sub;                  
logic                                                     wmb_write_req_next1_ready_to_dcache_line;      
logic                                                     wmb_write_req_next2_addr_plus;                 
logic                                                     wmb_write_req_next2_addr_sub;                  
logic                                                     wmb_write_req_next2_ready_to_dcache_line;      
logic                                                     wmb_write_req_next3_addr_plus;                 
logic                                                     wmb_write_req_next3_addr_sub;                  
logic                                                     wmb_write_req_next3_ready_to_dcache_line;      
logic                                                     wmb_write_req_page_buf;                        
logic                                                     wmb_write_req_page_ca_next1;                   
logic                                                     wmb_write_req_page_nc_atomic;                  
logic                                                     wmb_write_req_page_sec;                        
logic                                                     wmb_write_req_page_share_next1;                
logic                                                     wmb_write_req_page_so;                         
logic                                                     wmb_write_req_page_wa;                         
logic    [1  :0]                                          wmb_write_req_priv_mode;                       
logic                                                     wmb_write_req_ready_to_dcache_line;            
logic                                                     wmb_write_req_st_inst;                         
logic                                                     wmb_write_req_stex_inst;                       
logic                                                     wmb_write_req_sync_fence_inst;                 
logic                                                     wmb_write_req_sync_fence_next1;                
logic                                                     wmb_write_req_sync_inst;                       
logic                                                     wmb_write_vb_req_unmask;                       
logic                                                     write_burst_en;                                

logic  [WMB_ENTRY-1:0]                                    find_one_from_zero_for_priority;    //newly add for parameter, LTL@20241024
logic  [WMB_ENTRY-1:0]                                    find_one_from_zero_for_cmplt_ptr;
logic  [WMB_ENTRY-1:0]                                    find_one_from_zero_for_fwd_bytes0;  //1->3 for 3 ld, LTL@20241104
logic  [WMB_ENTRY-1:0]                                    find_one_from_zero_for_fwd_bytes1;
logic  [WMB_ENTRY-1:0]                                    find_one_from_zero_for_fwd_bytes2;
logic  [WMB_ENTRY-1:0]                                    find_one_from_zero_for_fwd_data0;  //1->3 for 3 ld, LTL@20241104
logic  [WMB_ENTRY-1:0]                                    find_one_from_zero_for_fwd_data1;
logic  [WMB_ENTRY-1:0]                                    find_one_from_zero_for_fwd_data2;

//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
logic  [WMB_ENTRY-1:0][`TDT_MP_HINFO_WIDTH-1:0]           wmb_entry_halt_info_0;
logic  [WMB_ENTRY-1:0][`TDT_MP_HINFO_WIDTH-1:0]           wmb_entry_halt_info_1;
//==========================================================
//                  Risc-V Debug zdb End 
//==========================================================

//parameter WMB_ENTRY         = 8,   //defined in front, LTL@20241104
//          LSIQ_ENTRY        = 12;
parameter BIU_R_NORM_ID_T   = 2'b10,
          BIU_R_CTC_ID      = 5'd28;
parameter BIU_B_NC_ID       = 5'd24,
          BIU_B_SO_ID       = 5'd29,
          BIU_B_NC_ATOM_ID  = 5'd30,
          BIU_B_SYNC_FENCE_ID = 5'd31;
parameter S_BYTE              = 2'b00,
          HALF              = 2'b01,
          WORD              = 2'b10;
parameter OKAY              = 2'b00,
          EXOKAY            = 2'b01,
          SLVERR            = 2'b10,
          DECERR            = 2'b11;
parameter IDLE              = 3'b000,
          REQ_DATA0         = 3'b100,
          REQ_DATA1         = 3'b101,
          REQ_DATA2         = 3'b110,
          REQ_DATA3         = 3'b111;

//==========================================================
//                 Instance of Gated Cell  
//==========================================================
//if sq has entry or create sq, then this gateclk is on
assign wmb_clk_en = !wmb_empty
                    ||  sq_wmb_pop_to_ce_gateclk_en
                    ||  wmb_ce_vld
                    ||  wmb_pop_depd_ff
                    ||  wmb_read_dp_req
                    ||  wmb_write_biu_dp_req
                    ||  wmb_write_imme;
// &Force("output","wmb_clk"); @74
// &Instance("gated_clk_cell", "x_lsu_wmb_gated_clk"); @75
gated_clk_cell  x_lsu_wmb_gated_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (wmb_clk           ),
  .external_en        (1'b0              ),
  .local_en           (wmb_clk_en        ),
  .module_en          (cp0_lsu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect(.clk_in        (forever_cpuclk     ), @76
//          .external_en   (1'b0               ), @77
//          .module_en     (cp0_lsu_icg_en     ), @78
//          .local_en      (wmb_clk_en         ), @79
//          .clk_out       (wmb_clk            )); @80

//create ptr
assign wmb_create_ptr_clk_en  = wmb_ce_create_wmb_gateclk_en;
// &Instance("gated_clk_cell", "x_lsu_wmb_create_ptr_gated_clk"); @84
gated_clk_cell  x_lsu_wmb_create_ptr_gated_clk (
  .clk_in                (forever_cpuclk       ),
  .clk_out               (wmb_create_ptr_clk   ),
  .external_en           (1'b0                 ),
  .local_en              (wmb_create_ptr_clk_en),
  .module_en             (cp0_lsu_icg_en       ),
  .pad_yy_icg_scan_en    (pad_yy_icg_scan_en   )
);

// &Connect(.clk_in        (forever_cpuclk     ), @85
//          .external_en   (1'b0               ), @86
//          .module_en     (cp0_lsu_icg_en     ), @87
//          .local_en      (wmb_create_ptr_clk_en), @88
//          .clk_out       (wmb_create_ptr_clk )); @89

//read ptr
assign wmb_read_ptr_clk_en  = wmb_read_ptr_unconditional_shift_imme
                              ||  wmb_read_ptr_chk_idx_shift_imme
                              ||  wmb_read_req_unmask;
// &Instance("gated_clk_cell", "x_lsu_wmb_read_ptr_gated_clk"); @95
gated_clk_cell  x_lsu_wmb_read_ptr_gated_clk (
  .clk_in              (forever_cpuclk     ),
  .clk_out             (wmb_read_ptr_clk   ),
  .external_en         (1'b0               ),
  .local_en            (wmb_read_ptr_clk_en),
  .module_en           (cp0_lsu_icg_en     ),
  .pad_yy_icg_scan_en  (pad_yy_icg_scan_en )
);

// &Connect(.clk_in        (forever_cpuclk     ), @96
//          .external_en   (1'b0               ), @97
//          .module_en     (cp0_lsu_icg_en     ), @98
//          .local_en      (wmb_read_ptr_clk_en), @99
//          .clk_out       (wmb_read_ptr_clk   )); @100

//write ptr
assign wmb_write_ptr_clk_en = wmb_write_ptr_unconditional_shift_imme
                              ||  wmb_write_ptr_chk_idx_shift_imme
                              ||  wmb_write_req
                              ||  wmb_tcm_req_unmask
                              ||  wmb_dcache_arb_req_unmask;
// &Instance("gated_clk_cell", "x_lsu_wmb_write_ptr_gated_clk"); @108
gated_clk_cell  x_lsu_wmb_write_ptr_gated_clk (
  .clk_in               (forever_cpuclk      ),
  .clk_out              (wmb_write_ptr_clk   ),
  .external_en          (1'b0                ),
  .local_en             (wmb_write_ptr_clk_en),
  .module_en            (cp0_lsu_icg_en      ),
  .pad_yy_icg_scan_en   (pad_yy_icg_scan_en  )
);

// &Connect(.clk_in        (forever_cpuclk     ), @109
//          .external_en   (1'b0               ), @110
//          .module_en     (cp0_lsu_icg_en     ), @111
//          .local_en      (wmb_write_ptr_clk_en), @112
//          .clk_out       (wmb_write_ptr_clk  )); @113

//data ptr
assign wmb_data_ptr_clk_en  = wmb_data_ptr_after_write_shift_imme_gate
                              ||  wmb_data_ptr_with_write_shift_imme
                              ||  wmb_data_req
                              ||  wmb_dcache_arb_req_unmask;
// &Instance("gated_clk_cell", "x_lsu_wmb_data_ptr_gated_clk"); @120
gated_clk_cell  x_lsu_wmb_data_ptr_gated_clk (
  .clk_in              (forever_cpuclk     ),
  .clk_out             (wmb_data_ptr_clk   ),
  .external_en         (1'b0               ),
  .local_en            (wmb_data_ptr_clk_en),
  .module_en           (cp0_lsu_icg_en     ),
  .pad_yy_icg_scan_en  (pad_yy_icg_scan_en )
);

// &Connect(.clk_in        (forever_cpuclk     ), @121
//          .external_en   (1'b0               ), @122
//          .module_en     (cp0_lsu_icg_en     ), @123
//          .local_en      (wmb_data_ptr_clk_en), @124
//          .clk_out       (wmb_data_ptr_clk   )); @125

//wmb fwd ld da pop entry
assign wmb_fwd_data_pe_clk_en0 = wmb_fwd_data_pe_gateclk_en0;
// &Instance("gated_clk_cell", "x_lsu_wmb_fwd_data_pe_gated_clk"); @129
gated_clk_cell  x_lsu_wmb_fwd_data_pe_gated_clk0 (
  .clk_in                 (forever_cpuclk        ),
  .clk_out                (wmb_fwd_data_pe_clk0   ),
  .external_en            (1'b0                  ),
  .local_en               (wmb_fwd_data_pe_clk_en0),
  .module_en              (cp0_lsu_icg_en        ),
  .pad_yy_icg_scan_en     (pad_yy_icg_scan_en    )
);
assign wmb_fwd_data_pe_clk_en1 = wmb_fwd_data_pe_gateclk_en1;
// &Instance("gated_clk_cell", "x_lsu_wmb_fwd_data_pe_gated_clk"); @129
gated_clk_cell  x_lsu_wmb_fwd_data_pe_gated_clk1 (
  .clk_in                 (forever_cpuclk        ),
  .clk_out                (wmb_fwd_data_pe_clk1   ),
  .external_en            (1'b0                  ),
  .local_en               (wmb_fwd_data_pe_clk_en1),
  .module_en              (cp0_lsu_icg_en        ),
  .pad_yy_icg_scan_en     (pad_yy_icg_scan_en    )
);
assign wmb_fwd_data_pe_clk_en2 = wmb_fwd_data_pe_gateclk_en2;
// &Instance("gated_clk_cell", "x_lsu_wmb_fwd_data_pe_gated_clk"); @129
gated_clk_cell  x_lsu_wmb_fwd_data_pe_gated_clk2 (
  .clk_in                 (forever_cpuclk        ),
  .clk_out                (wmb_fwd_data_pe_clk2   ),
  .external_en            (1'b0                  ),
  .local_en               (wmb_fwd_data_pe_clk_en2),
  .module_en              (cp0_lsu_icg_en        ),
  .pad_yy_icg_scan_en     (pad_yy_icg_scan_en    )
);

// &Connect(.clk_in        (forever_cpuclk     ), @130
//          .external_en   (1'b0               ), @131
//          .module_en     (cp0_lsu_icg_en     ), @132
//          .local_en      (wmb_fwd_data_pe_clk_en), @133
//          .clk_out       (wmb_fwd_data_pe_clk)); @134

//pop entry signal
assign wmb_write_pop_clk_en = wmb_write_ptr_clk_en
                              ||  wmb_write_pop_up_wmb_ce_gateclk_en;
// &Instance("gated_clk_cell", "x_lsu_wmb_write_pop_gated_clk"); @139
gated_clk_cell  x_lsu_wmb_write_pop_gated_clk (
  .clk_in               (forever_cpuclk      ),
  .clk_out              (wmb_write_pop_clk   ),
  .external_en          (1'b0                ),
  .local_en             (wmb_write_pop_clk_en),
  .module_en            (cp0_lsu_icg_en      ),
  .pad_yy_icg_scan_en   (pad_yy_icg_scan_en  )
);

// &Connect(.clk_in        (forever_cpuclk     ), @140
//          .external_en   (1'b0               ), @141
//          .module_en     (cp0_lsu_icg_en     ), @142
//          .local_en      (wmb_write_pop_clk_en), @143
//          .clk_out       (wmb_write_pop_clk  )); @144

assign wmb_write_dcache_pop_clk_en = wmb_dcache_req_next || wmb_write_dcache_pop_req;
                            
// &Instance("gated_clk_cell", "x_lsu_wmb_write_dcache_pop_gated_clk"); @148
gated_clk_cell  x_lsu_wmb_write_dcache_pop_gated_clk (
  .clk_in                      (forever_cpuclk             ),
  .clk_out                     (wmb_write_dcache_pop_clk   ),
  .external_en                 (1'b0                       ),
  .local_en                    (wmb_write_dcache_pop_clk_en),
  .module_en                   (cp0_lsu_icg_en             ),
  .pad_yy_icg_scan_en          (pad_yy_icg_scan_en         )
);

// &Connect(.clk_in        (forever_cpuclk     ), @149
//          .external_en   (1'b0               ), @150
//          .module_en     (cp0_lsu_icg_en     ), @151
//          .local_en      (wmb_write_dcache_pop_clk_en), @152
//          .clk_out       (wmb_write_dcache_pop_clk  )); @153

assign wmb_read_pop_clk_en  = wmb_read_ptr_clk_en
                              ||  wmb_ce_create_wmb_gateclk_en;
// &Instance("gated_clk_cell", "x_lsu_wmb_read_pop_gated_clk"); @157
gated_clk_cell  x_lsu_wmb_read_pop_gated_clk (
  .clk_in              (forever_cpuclk     ),
  .clk_out             (wmb_read_pop_clk   ),
  .external_en         (1'b0               ),
  .local_en            (wmb_read_pop_clk_en),
  .module_en           (cp0_lsu_icg_en     ),
  .pad_yy_icg_scan_en  (pad_yy_icg_scan_en )
);

// &Connect(.clk_in        (forever_cpuclk     ), @158
//          .external_en   (1'b0               ), @159
//          .module_en     (cp0_lsu_icg_en     ), @160
//          .local_en      (wmb_read_pop_clk_en), @161
//          .clk_out       (wmb_read_pop_clk   )); @162

//depd clk is used for wakeup queue
assign wmb_wakeup_queue_clk_en0  = lda0_wmb_ex3_discard_vld        //wakeup queue, 1->3 for 3 lsiq, LTL@20241104
                                  ||  wmb_pop_depd_ff
                                  ||  rtu_yy_xx_flush
                                  ||  rtu_ck_flush;
// &Instance("gated_clk_cell", "x_lsu_wmb_wakeup_queue_gated_clk"); @168
gated_clk_cell  x_lsu_wmb_wakeup_queue_gated_clk0 (
  .clk_in                  (forever_cpuclk         ),
  .clk_out                 (wmb_wakeup_queue_clk0   ),
  .external_en             (1'b0                   ),
  .local_en                (wmb_wakeup_queue_clk_en0),
  .module_en               (cp0_lsu_icg_en         ),
  .pad_yy_icg_scan_en      (pad_yy_icg_scan_en     )
);
assign wmb_wakeup_queue_clk_en1  = lsda0_wmb_ex3_discard_vld        //wakeup queue, 1->3 for 3 lsiq, LTL@20241104
                                  ||  wmb_pop_depd_ff
                                  ||  rtu_yy_xx_flush
                                  ||  rtu_ck_flush;
// &Instance("gated_clk_cell", "x_lsu_wmb_wakeup_queue_gated_clk"); @168
gated_clk_cell  x_lsu_wmb_wakeup_queue_gated_clk1 (
  .clk_in                  (forever_cpuclk         ),
  .clk_out                 (wmb_wakeup_queue_clk1   ),
  .external_en             (1'b0                   ),
  .local_en                (wmb_wakeup_queue_clk_en1),
  .module_en               (cp0_lsu_icg_en         ),
  .pad_yy_icg_scan_en      (pad_yy_icg_scan_en     )
);
assign wmb_wakeup_queue_clk_en2  = lsda1_wmb_ex3_discard_vld        //wakeup queue, 1->3 for 3 lsiq, LTL@20241104
                                  ||  wmb_pop_depd_ff
                                  ||  rtu_yy_xx_flush
                                  ||  rtu_ck_flush;
// &Instance("gated_clk_cell", "x_lsu_wmb_wakeup_queue_gated_clk"); @168
gated_clk_cell  x_lsu_wmb_wakeup_queue_gated_clk2 (
  .clk_in                  (forever_cpuclk         ),
  .clk_out                 (wmb_wakeup_queue_clk2   ),
  .external_en             (1'b0                   ),
  .local_en                (wmb_wakeup_queue_clk_en2),
  .module_en               (cp0_lsu_icg_en         ),
  .pad_yy_icg_scan_en      (pad_yy_icg_scan_en     )
);

// &Connect(.clk_in        (forever_cpuclk     ), @169
//          .external_en   (1'b0               ), @170
//          .module_en     (cp0_lsu_icg_en     ), @171
//          .local_en      (wmb_wakeup_queue_clk_en), @172
//          .clk_out       (wmb_wakeup_queue_clk)); @173

//==========================================================
//                      Empty cnt
//==========================================================
//------------------empty signal----------------------------
// &Force("output","wmb_entry_vld"); @179
// &Force("output","wmb_empty"); @180
assign wmb_empty                  = !(|wmb_entry_vld[WMB_ENTRY-1:0])
                                    &&  !wmb_pend_busy;

//==========================================================
//                 Non-cacheable FIFO
//==========================================================
//&Instance("xx_lsu_idfifo_8","x_xx_lsu_wmb_idfifo_nc");
// //&Connect( .idfifo_clk_en        (wmb_idfifo_nc_clk_en         ), @188
// //          .idfifo_create_vld    (wmb_idfifo_nc_create_vld     ), @189
// //          .idfifo_pop_vld       (wmb_idfifo_nc_pop_vld        ), @190
// //          .idfifo_create_id     (wmb_write_ptr_encode[2:0]    ), @191
// //          .idfifo_create_id_oh  (wmb_write_ptr[7:0]           ), @192
// //          .idfifo_pop_id_oh     (wmb_entry_next_nc_bypass[7:0]), @193
// //          .idfifo_empty         (wmb_nc_no_pending            )); @194
// //&Force("nonport","wmb_nc_no_pending"); @195

//-----------------------wires------------------------------
//assign wmb_idfifo_nc_create_vld                = wmb_biu_nc_req_grnt;
//assign wmb_idfifo_nc_pop_vld                   = wmb_b_nc_id_hit;

//------------------gateclk---------------------------------
//assign wmb_biu_nc_req_gateclk_en  = wmb_write_biu_req_unmask
//                                    &&  !wmb_write_req_page_ca
//                                    &&  !wmb_write_req_page_so
//                                    &&  (wmb_write_req_atomic
//                                        ||  !wmb_write_req_icc
//                                            &&  !wmb_write_req_sync_fence);
//assign wmb_biu_nc_recv_gateclk_en = wmb_b_nc_id_hit;
//assign wmb_idfifo_nc_clk_en          = wmb_biu_nc_req_gateclk_en
//                                    ||  wmb_biu_nc_recv_gateclk_en;

//==========================================================
//                 Strong order FIFO
//==========================================================
// &Instance("xx_lsu_idfifo_8","x_xx_lsu_wmb_idfifo_so"); @215
xx_lsu_idfifo_8  x_xx_lsu_wmb_idfifo_so (
  .cp0_lsu_icg_en                (cp0_lsu_icg_en               ),
  .cpurst_b                      (cpurst_b                     ),
  .forever_cpuclk                (forever_cpuclk               ),
  .idfifo_clk_en                 (wmb_idfifo_so_clk_en         ),
  .idfifo_create_id              (wmb_write_ptr_encode[2:0]    ),
  .idfifo_create_id_oh           (wmb_write_ptr[7:0]           ),
  .idfifo_create_vld             (wmb_idfifo_so_create_vld     ),
  .idfifo_empty                  (wmb_so_no_pending            ),
  .idfifo_pop_id_oh              (wmb_entry_next_so_bypass[7:0]),
  .idfifo_pop_vld                (wmb_idfifo_so_pop_vld        ),
  .pad_yy_icg_scan_en            (pad_yy_icg_scan_en           )
);

// &Connect( .idfifo_clk_en        (wmb_idfifo_so_clk_en         ), @216
//           .idfifo_create_vld    (wmb_idfifo_so_create_vld     ), @217
//           .idfifo_pop_vld       (wmb_idfifo_so_pop_vld        ), @218
//           .idfifo_create_id     (wmb_write_ptr_encode[2:0]    ), @219
//           .idfifo_create_id_oh  (wmb_write_ptr[7:0]           ), @220
//           .idfifo_pop_id_oh     (wmb_entry_next_so_bypass[7:0]), @221
//           .idfifo_empty         (wmb_so_no_pending            )); @222

//-----------------------wires------------------------------
assign wmb_idfifo_so_create_vld                = wmb_biu_so_req_grnt;
assign wmb_idfifo_so_pop_vld                   = wmb_b_so_id_hit;

//------------------gateclk---------------------------------
assign wmb_biu_so_req_gateclk_en  = wmb_write_biu_req_unmask
                                    &&  wmb_write_req_page_so
                                    &&  (wmb_write_req_atomic
                                        ||  !wmb_write_req_icc
                                            &&  !wmb_write_req_sync_fence);
assign wmb_biu_so_recv_gateclk_en = wmb_b_so_id_hit;
assign wmb_idfifo_so_clk_en       = wmb_biu_so_req_gateclk_en
                                    ||  wmb_biu_so_recv_gateclk_en;

//------------------pending---------------------------------
assign wmb_rb_so_pending          = !wmb_so_no_pending;

//==========================================================
//          Instance of write merge buffer entry
//==========================================================
genvar entry_i;

generate
  for(entry_i=0;entry_i<WMB_ENTRY;entry_i=entry_i+1) begin
      xx_lsu_wmb_entry #(
        .WMB_ENTRY(WMB_ENTRY),
        .IID_WIDTH(IID_WIDTH),
        .PREG(PREG)
      )
  x_xx_lsu_wmb_entry (
//  .biu_lsu_b_id                                        (biu_lsu_b_id),                                          
//  .biu_lsu_b_vld                                       (biu_lsu_b_vld),                                           
//  .biu_lsu_r_id                                        (biu_lsu_r_id),                                          
//  .biu_lsu_r_vld                                       (biu_lsu_r_vld),                                           
//  .bus_arb_wmb_aw_grnt                                 (bus_arb_wmb_aw_grnt),                                           
//  .bus_arb_wmb_w_grnt                                  (bus_arb_wmb_w_grnt),                                          
//  .cp0_lsu_icg_en                                      (cp0_lsu_icg_en),                                          
//  .cpurst_b                                            (cpurst_b),                                          
//  .dcache_dirty_din                                    (dcache_dirty_din),                                          
//  .dcache_dirty_gwen                                   (dcache_dirty_gwen),                                           
//  .dcache_dirty_wen                                    (dcache_dirty_wen),                                          
//  .dcache_idx                                          (dcache_idx),                                          
//  .dcache_snq_st_sel                                   (dcache_snq_st_sel),                                           
//  .dcache_tag_din                                      (dcache_tag_din),                                          
//  .dcache_tag_gwen                                     (dcache_tag_gwen),                                           
//  .dcache_tag_wen                                      (dcache_tag_wen),                                          
//  .dm_state_is_force_fail                              (dm_state_is_force_fail),                                          
//  .forever_cpuclk                                      (forever_cpuclk),                                          
//  .ld_dc_addr0                                         (ldc0_ex2_addr0),                                           
//  .ld_dc_addr1_11to4                                   (ldc0_ex2_addr1_11to4),                                           
//  .ld_dc_bytes_vld                                     (ldc0_ex2_bytes_vld),                                           
//  .ld_dc_chk_atomic_inst_vld                           (ldc0_ex2_chk_atomic_inst_vld),                                           
//  .ld_dc_chk_ld_inst_vld                               (ldc0_ex2_chk_ld_inst_vld),                                           
//  .lm_state_is_ex_wait_lock                            (lm_state_is_ex_wait_lock),                                          
//  .lm_state_is_idle                                    (lm_state_is_idle),                                          
//  .pad_yy_icg_scan_en                                  (pad_yy_icg_scan_en),                                          
//  .pfu_biu_req_addr                                    (pfu_biu_req_addr),                                          
//  .pw_merge_stall                                      (pw_merge_stall),                                          
//  .rb_biu_req_addr                                     (rb_biu_req_addr),                                           
//  .rb_biu_req_unmask                                   (rb_biu_req_unmask),                                           
//  .rtu_lsu_async_flush                                 (rtu_lsu_async_flush),                                           
//  .snq_can_create_snq_uncheck                          (snq_can_create_snq_uncheck),                                          
//  .snq_create_addr                                     (snq_create_addr),                                           
//  .sq_pop_addr                                         (sq_pop_addr),                                           
//  .sq_pop_bytes_vld                                    (sq_pop_bytes_vld),                                          
//  .sq_pop_priv_mode                                    (sq_pop_priv_mode),                                          
//  .sq_wmb_merge_req                                    (sq_wmb_merge_req),                                          
//  .sq_wmb_merge_stall_req                              (sq_wmb_merge_stall_req),                                          
//  .vb_wmb_empty                                        (vb_wmb_empty),                                          
//  .vb_wmb_entry_rcl_done_x                             (vb_wmb_entry_rcl_done[entry_i]),                                           
//  .wmb_b_resp_exokay                                   (wmb_b_resp_exokay),                                           
//  .wmb_biu_ar_id                                       (wmb_biu_ar_id),                                           
//  .wmb_biu_aw_id                                       (wmb_biu_aw_id),                                           
//  .wmb_biu_write_en                                    (wmb_biu_write_en),                                          
//  .wmb_ce_addr                                         (wmb_ce_addr),                                           
//  .wmb_ce_atomic                                       (wmb_ce_atomic),                                                                                   
//  .wmb_ce_bytes_vld                                    (wmb_ce_bytes_vld),                                          
//  .wmb_ce_bytes_vld_full                               (wmb_ce_bytes_vld_full),                                           
//  .wmb_ce_create_vld                                   (wmb_ce_create_vld),                                           
//  .wmb_ce_data128                                      (wmb_ce_data128),                                          
//  .wmb_ce_data_vld                                     (wmb_ce_data_vld),                                           
//  .wmb_ce_dcache_inst                                  (wmb_ce_dcache_inst),                                          
//  .wmb_ce_dtcm_hit                                     (wmb_ce_dtcm_hit),                                           
//  .wmb_ce_fence_mode                                   (wmb_ce_fence_mode),                                           
//  .wmb_ce_icc                                          (wmb_ce_icc),                                          
//  .wmb_ce_iid                                          (wmb_ce_iid),                                          
//  .wmb_ce_inst_flush                                   (wmb_ce_inst_flush),                                           
//  .wmb_ce_inst_mode                                    (wmb_ce_inst_mode),                                          
//  .wmb_ce_inst_size                                    (wmb_ce_inst_size),                                          
//  .wmb_ce_inst_type                                    (wmb_ce_inst_type),                                          
//  .wmb_ce_itcm_hit                                     (wmb_ce_itcm_hit),                                           
//  .wmb_ce_last_addr_plus                               (wmb_ce_last_addr_plus),                                           
//  .wmb_ce_last_addr_sub                                (wmb_ce_last_addr_sub),                                          
//  .wmb_ce_merge_en                                     (wmb_ce_merge_en),                                           
//  .wmb_ce_page_buf                                     (wmb_ce_page_buf),                                           
//  .wmb_ce_page_ca                                      (wmb_ce_page_ca),                                          
//  .wmb_ce_page_sec                                     (wmb_ce_page_sec),                                           
//  .wmb_ce_page_share                                   (wmb_ce_page_share),                                           
//  .wmb_ce_page_so                                      (wmb_ce_page_so),                                          
//  .wmb_ce_page_wa                                      (wmb_ce_page_wa),                                          
//  .wmb_ce_priv_mode                                    (wmb_ce_priv_mode),                                          
//  .wmb_ce_sc_wb_vld                                    (wmb_ce_sc_wb_vld),                                          
//  .wmb_ce_spec_fail                                    (wmb_ce_spec_fail),                                          
//  .wmb_ce_sync_fence                                   (wmb_ce_sync_fence),                                           
//  .wmb_ce_update_dcache_dirty                          (wmb_ce_update_dcache_dirty),                                          
//  .wmb_ce_update_dcache_page_share                     (wmb_ce_update_dcache_page_share),                                           
//  .wmb_ce_update_dcache_share                          (wmb_ce_update_dcache_share),                                          
//  .wmb_ce_update_dcache_valid                          (wmb_ce_update_dcache_valid),                                          
//  .wmb_ce_update_dcache_way                            (wmb_ce_update_dcache_way),                                          
//  .wmb_ce_update_same_dcache_line                      (wmb_ce_update_same_dcache_line),                                          
//  .wmb_ce_update_same_dcache_line_ptr                  (wmb_ce_update_same_dcache_line_ptr),                                          
//  .wmb_ce_vstart_vld                                   (wmb_ce_vstart_vld),                                           
//  .wmb_ce_wb_cmplt_success                             (wmb_ce_wb_cmplt_success),                                           
//  .wmb_ce_wb_data_success                              (wmb_ce_wb_data_success),                                          
//  .wmb_ce_write_imme                                   (wmb_ce_write_imme),                                           
//  .wmb_create_ptr_next1_x                              (wmb_create_ptr_next1[entry_i]),                                          
//  .wmb_create_vb_success                               (wmb_create_vb_success),                                           
//  .wmb_data_ptr_x                                      (wmb_data_ptr[entry_i]),                                          
//  .wmb_dcache_arb_req_unmask                           (wmb_dcache_arb_req_unmask),                                           
//  .wmb_dcache_inst_write_req_hit_idx                   (wmb_dcache_inst_write_req_hit_idx),                                           
//  .wmb_dcache_req_ptr_x                                (wmb_dcache_req_ptr[entry_i]),                                          
//  .wmb_entry_create_data_vld_x                         (wmb_entry_create_data_vld[entry_i]),                                           
//  .wmb_entry_create_dp_vld_x                           (wmb_entry_create_dp_vld[entry_i]),                                           
//  .wmb_entry_create_gateclk_en_x                       (wmb_entry_create_gateclk_en[entry_i]),                                           
//  .wmb_entry_create_vld_x                              (wmb_entry_create_vld[entry_i]),                                          
//  .wmb_entry_mem_set_write_gateclk_en_x                (wmb_entry_mem_set_write_gateclk_en[entry_i]),                                          
//  .wmb_entry_mem_set_write_grnt_x                      (wmb_entry_mem_set_write_grnt[entry_i]),                                          
//  .wmb_entry_merge_data_vld_x                          (wmb_entry_merge_data_vld[entry_i]),                                          
//  .wmb_entry_merge_data_wait_not_vld_req_x             (wmb_entry_merge_data_wait_not_vld_req[entry_i]),                                           
//  .wmb_entry_next_so_bypass_x                          (wmb_entry_next_so_bypass[entry_i]),                                          
//  .wmb_entry_w_last_set_x                              (wmb_entry_w_last_set[entry_i]),                                          
//  .wmb_entry_wb_cmplt_grnt_x                           (wmb_entry_wb_cmplt_grnt[entry_i] ),                                           
//  .wmb_entry_wb_data_grnt_x                            (wmb_entry_wb_data_grnt[entry_i] ),                                          
//  .wmb_read_ptr_read_req_grnt                          (wmb_read_ptr_read_req_grnt),                                          
//  .wmb_read_ptr_shift_imme_grnt                        (wmb_read_ptr_shift_imme_grnt),                                          
//  .wmb_read_ptr_x                                      (wmb_read_ptr[entry_i]),                                          
//  .wmb_same_line_resp_ready                            (wmb_same_line_resp_ready),                                          
//  .wmb_tcm_grant                                       (wmb_tcm_grant),                                           
//  .wmb_tcm_write_done_x                                (wmb_tcm_write_done[entry_i]),                                          
//  .wmb_wakeup_queue_not_empty                          (wmb_wakeup_queue_not_empty),                                          
//  .wmb_write_biu_dcache_line                           (wmb_write_biu_dcache_line),                                           
//  .wmb_write_dcache_success                            (wmb_write_dcache_success),                                          
//  .wmb_write_imme                                      (wmb_write_imme),                                          
//  .wmb_write_ptr_shift_imme_grnt                       (wmb_write_ptr_shift_imme_grnt),                                           
//  .wmb_write_ptr_to_next3_x                            (wmb_write_ptr_to_next3[entry_i]),                                          
//  .wmb_write_ptr_x                                     (wmb_write_ptr[entry_i]),                                           
//  .wmb_entry_addr_v                                    (wmb_entry_addr[entry_i] ),                                          
//  .wmb_entry_already_read_req_x                        (wmb_entry_already_read_req[entry_i]),                                          
//  .wmb_entry_ar_pending_x                              (wmb_entry_ar_pending[entry_i]),                                          
//  .wmb_entry_atomic_and_vld_x                          (wmb_entry_atomic_and_vld[entry_i]),                                          
//  .wmb_entry_atomic_x                                  (wmb_entry_atomic[entry_i]),                                          
//  .wmb_entry_aw_pending_x                              (wmb_entry_aw_pending[entry_i]),                                          
//  .wmb_entry_biu_id_v                                  (wmb_entry_biu_id[entry_i]),                                                                                  
//  .wmb_entry_bytes_vld_v                               (wmb_entry_bytes_vld[entry_i]),                                           
//  .wmb_entry_cancel_acc_req_x                          (wmb_entry_cancel_acc_req0[entry_i]),                                          
//  .wmb_entry_data_biu_req_x                            (wmb_entry_data_biu_req[entry_i]),                                          
//  .wmb_entry_data_ptr_after_write_shift_imme_gate_x    (wmb_entry_data_ptr_after_write_shift_imme_gate[entry_i]),                                           
//  .wmb_entry_data_ptr_after_write_shift_imme_x         (wmb_entry_data_ptr_after_write_shift_imme[entry_i]     ),                                      
//  .wmb_entry_data_ptr_with_write_shift_imme_x          (wmb_entry_data_ptr_with_write_shift_imme[entry_i]      ),                                    
//  .wmb_entry_data_req_wns_x                            (wmb_entry_data_req_wns[entry_i]),                                          
//  .wmb_entry_data_req_x                                (wmb_entry_data_req[entry_i]),                                          
//  .wmb_entry_data_v                                    (wmb_entry_data[entry_i]),                                          
//  .wmb_entry_dcache_inst_same_line_x                   (wmb_entry_dcache_inst_same_line[entry_i]               ),                                         
//  .wmb_entry_dcache_inst_x                             (wmb_entry_dcache_inst[entry_i]                         ),                               
//  .wmb_entry_dcache_page_share_x                       (wmb_entry_dcache_page_share[entry_i]                   ),                                     
//  .wmb_entry_dcache_way_x                              (wmb_entry_dcache_way[entry_i]                          ),                             
//  .wmb_entry_depd_x                                    (wmb_entry_depd[entry_i]                                ),                                  
//  .wmb_entry_discard_req_x                             (wmb_entry_discard_req0[entry_i]                        ),                                          
//  .wmb_entry_dtcm_hit_x                                (wmb_entry_dtcm_hit[entry_i]),                                          
//  .wmb_entry_fwd_bytes_vld_v                           (wmb_entry_fwd_bytes_vld0[entry_i]),                                           
//  .wmb_entry_fwd_data_pe_gateclk_en_x                  (wmb_entry_fwd_data_pe_gateclk_en0[entry_i]),                                          
//  .wmb_entry_fwd_data_pe_req_x                         (wmb_entry_fwd_data_pe_req0[entry_i]),                                           
//  .wmb_entry_fwd_req_x                                 (wmb_entry_fwd_req0[entry_i]),                                           
//  .wmb_entry_icc_and_vld_x                             (wmb_entry_icc_and_vld[entry_i]),                                           
//  .wmb_entry_icc_x                                     (wmb_entry_icc[entry_i]),                                           
//  .wmb_entry_iid_v                                     (wmb_entry_iid[entry_i]),                                           
//  .wmb_entry_inst_flush_x                              (wmb_entry_inst_flush[entry_i]                          ),                                    
//  .wmb_entry_inst_is_dcache_x                          (wmb_entry_inst_is_dcache[entry_i]                      ),                                        
//  .wmb_entry_inst_mode_v                               (wmb_entry_inst_mode[entry_i]                           ),                                    
//  .wmb_entry_inst_size_v                               (wmb_entry_inst_size[entry_i]                            ),                                    
//  .wmb_entry_inst_type_v                               (wmb_entry_inst_type[entry_i]                           ),                                    
//  .wmb_entry_last_addr_plus_x                          (wmb_entry_last_addr_plus[entry_i] ),                                          
//  .wmb_entry_last_addr_sub_x                           (wmb_entry_last_addr_sub[entry_i]),                                           
//  .wmb_entry_merge_data_addr_hit_x                     (wmb_entry_merge_data_addr_hit[entry_i]                 ),                                           
//  .wmb_entry_merge_data_stall_x                        (wmb_entry_merge_data_stall[entry_i]                    ),                                       
//  .wmb_entry_no_op_x                                   (wmb_entry_no_op[entry_i]                               ),                                    
//  .wmb_entry_page_buf_x                                (wmb_entry_page_buf[entry_i]                            ),                                      
//  .wmb_entry_page_ca_x                                 (wmb_entry_page_ca[entry_i]                             ),                                      
//  .wmb_entry_page_sec_x                                (wmb_entry_page_sec[entry_i]                            ),                                      
//  .wmb_entry_page_share_x                              (wmb_entry_page_share[entry_i]                          ),                                        
//  .wmb_entry_page_so_x                                 (wmb_entry_page_so[entry_i]                             ),                                      
//  .wmb_entry_page_wa_x                                 (wmb_entry_page_wa[entry_i]                             ),                                      
//  .wmb_entry_pfu_biu_req_hit_idx_x                     (wmb_entry_pfu_biu_req_hit_idx[entry_i]                 ),                                        
//  .wmb_entry_pop_vld_x                                 (wmb_entry_pop_vld[entry_i]                             ),                            
//  .wmb_entry_preg_v                                    (wmb_entry_preg[entry_i]                                ),                        
//  .wmb_entry_priv_mode_v                               (wmb_entry_priv_mode[entry_i]                           ),                 
//  .wmb_entry_rb_biu_req_hit_idx_x                      (wmb_entry_rb_biu_req_hit_idx[entry_i]                  ),                         
//  .wmb_entry_read_dp_req_x                             (wmb_entry_read_dp_req[entry_i]                         ),                   
//  .wmb_entry_read_ptr_chk_idx_shift_imme_x             (wmb_entry_read_ptr_chk_idx_shift_imme[entry_i]         ),                                   
//  .wmb_entry_read_ptr_unconditional_shift_imme_x       (wmb_entry_read_ptr_unconditional_shift_imme[entry_i]   ),                                         
//  .wmb_entry_read_req_x                                (wmb_entry_read_req[entry_i]                            ),               
//  .wmb_entry_read_resp_ready_x                         (wmb_entry_read_resp_ready[entry_i]                     ),                       
//  .wmb_entry_ready_to_dcache_line_x                    (wmb_entry_ready_to_dcache_line[entry_i]                ),                           
//  .wmb_entry_sc_wb_success_x                           (wmb_entry_sc_wb_success[entry_i]                       ),                     
//  .wmb_entry_snq_depd_remove_x                         (wmb_entry_snq_depd_remove[entry_i]                     ),                            
//  .wmb_entry_snq_depd_x                                (wmb_entry_snq_depd[entry_i]                            ),                    
//  .wmb_entry_spec_fail_x                               (wmb_entry_spec_fail[entry_i]                           ),                      
//  .wmb_entry_sq_pop_sameline_set_x                     (wmb_entry_sq_pop_sameline_set[entry_i]                 ),                                
//  .wmb_entry_st_hit_sq_pop_dcache_line_x               (wmb_entry_st_hit_sq_pop_dcache_line[entry_i]           ),                                      
//  .wmb_entry_sync_fence_biu_req_success_x              (wmb_entry_sync_fence_biu_req_success[entry_i]          ),                                      
//  .wmb_entry_sync_fence_inst_x                         (wmb_entry_sync_fence_inst[entry_i]                     ),                            
//  .wmb_entry_sync_fence_x                              (wmb_entry_sync_fence[entry_i]                          ),                      
//  .wmb_entry_vld_x                                     (wmb_entry_vld[entry_i]                                 ),                                   
//  .wmb_entry_vstart_vld_x                              (wmb_entry_vstart_vld[entry_i]                          ),                                         
//  .wmb_entry_w_last_x                                   (wmb_entry_w_last[entry_i]                              ),                                      
//  .wmb_entry_w_pending_x                                (wmb_entry_w_pending[entry_i]                           ),                                          
//  .wmb_entry_wb_cmplt_req_x                            (wmb_entry_wb_cmplt_req[entry_i]                        ),                                          
//  .wmb_entry_wb_data_req_x                             (wmb_entry_wb_data_req[entry_i]                         ),                                           
//  .wmb_entry_write_biu_dp_req_x                        (wmb_entry_write_biu_dp_req[entry_i]                    ),                                         
//  .wmb_entry_write_biu_req_x                           (wmb_entry_write_biu_req[entry_i]                       ),                                       
//  .wmb_entry_write_dcache_req_x                        (wmb_entry_write_dcache_req[entry_i]                    ),                        
//  .wmb_entry_write_imme_bypass_x                       (wmb_entry_write_imme_bypass[entry_i]                   ),                          
//  .wmb_entry_write_imme_x                              (wmb_entry_write_imme[entry_i]                          ),                  
//  .wmb_entry_write_ptr_chk_idx_shift_imme_x            (wmb_entry_write_ptr_chk_idx_shift_imme[entry_i]        ),                                    
//  .wmb_entry_write_ptr_unconditional_shift_imme_x      (wmb_entry_write_ptr_unconditional_shift_imme[entry_i]  ),                                          
//  .wmb_entry_write_req_x                               (wmb_entry_write_req[entry_i]                           ),                                       
//  .wmb_entry_write_stall_x                             (wmb_entry_write_stall[entry_i]                         ),                                         
//  .wmb_entry_write_tcm_req_x                           (wmb_entry_write_tcm_req[entry_i]                       ),                                           
//  .wmb_entry_write_vb_req_x                            (wmb_entry_write_vb_req[entry_i]                        )                         

  .biu_lsu_b_id                                      (biu_lsu_b_id                                     ),
  .biu_lsu_b_vld                                     (biu_lsu_b_vld                                    ),
  .biu_lsu_r_id                                      (biu_lsu_r_id                                     ),
  .biu_lsu_r_vld                                     (biu_lsu_r_vld                                    ),
  .bus_arb_wmb_aw_grnt                               (bus_arb_wmb_aw_grnt                              ),
  .bus_arb_wmb_w_grnt                                (bus_arb_wmb_w_grnt                               ),
  .cp0_lsu_icg_en                                    (cp0_lsu_icg_en                                   ),
  .cpurst_b                                          (cpurst_b                                         ),
  .dcache_dirty_din                                  (dcache_dirty_din                                 ),
  .dcache_dirty_gwen                                 (dcache_dirty_gwen                                ),
  .dcache_dirty_wen                                  (dcache_dirty_wen                                 ),
  .dcache_idx                                        (dcache_idx                                       ),
  .dcache_snq_st_sel                                 (dcache_snq_st_sel                                ),
  .dcache_tag_din                                    (dcache_tag_din                                   ),
  .dcache_tag_gwen                                   (dcache_tag_gwen                                  ),
  .dcache_tag_wen                                    (dcache_tag_wen                                   ),
  .dm_state_is_force_fail                            (dm_state_is_force_fail                           ),
  .forever_cpuclk                                    (forever_cpuclk                                   ),
  .ldc0_ex2_addr0                                    (ldc0_ex2_addr0                                   ),//1->3, for 3 ld_dc, LTL@20241104
  .lsdc0_ex2_addr0                                   (lsdc0_ex2_addr0                                  ),
  .lsdc1_ex2_addr0                                   (lsdc1_ex2_addr0                                  ),
  .ldc0_ex2_addr1_11to4                              (ldc0_ex2_addr1_11to4                             ),//1->3, for 3 ld_dc, LTL@20241104
  .lsdc0_ex2_addr1_11to4                             (lsdc0_ex2_addr1_11to4                            ),
  .lsdc1_ex2_addr1_11to4                             (lsdc1_ex2_addr1_11to4                            ),
  .ldc0_ex2_bytes_vld                                (ldc0_ex2_bytes_vld                               ),//1->3, for 3 ld_dc, LTL@20241104
  .lsdc0_ex2_bytes_vld                               (lsdc0_ex2_bytes_vld                              ),
  .lsdc1_ex2_bytes_vld                               (lsdc1_ex2_bytes_vld                              ),
  .ldc0_ex2_bytes_vld1                               (ldc0_ex2_bytes_vld1                              ),//rvv512@LTL
  .lsdc0_ex2_bytes_vld1                              (lsdc0_ex2_bytes_vld1                             ),//rvv512@LTL
  .lsdc1_ex2_bytes_vld1                              (lsdc1_ex2_bytes_vld1                             ),//rvv512@LTL
  .ldc0_ex2_bytes_vld2                               (ldc0_ex2_bytes_vld2                              ),//rvv512@LTL
  .lsdc0_ex2_bytes_vld2                              (lsdc0_ex2_bytes_vld2                             ),//rvv512@LTL
  .lsdc1_ex2_bytes_vld2                              (lsdc1_ex2_bytes_vld2                             ),//rvv512@LTL      
  .ldc0_ex2_bytes_vld3                               (ldc0_ex2_bytes_vld3                              ),//rvv512@LTL
  .lsdc0_ex2_bytes_vld3                              (lsdc0_ex2_bytes_vld3                             ),//rvv512@LTL
  .lsdc1_ex2_bytes_vld3                              (lsdc1_ex2_bytes_vld3                             ),//rvv512@LTL      
  .ldc0_ex2_is_us                                    (ldc0_ex2_is_us                                   ),//rvv512@LTL
  .lsdc0_ex2_is_us                                   (lsdc0_ex2_is_us                                  ),//rvv512@LTL
  .lsdc1_ex2_is_us                                   (lsdc1_ex2_is_us                                  ),//rvv512@LTL  
  .ldc0_ex2_chk_atomic_inst_vld                      (ldc0_ex2_chk_atomic_inst_vld                     ),//1->3, for 3 ld_dc, LTL@20241104
  .lsdc0_ex2_chk_atomic_inst_vld                     (lsdc0_ex2_chk_atomic_inst_vld                    ),
  .lsdc1_ex2_chk_atomic_inst_vld                     (lsdc1_ex2_chk_atomic_inst_vld                    ),
  .ldc0_ex2_chk_ld_inst_vld                          (ldc0_ex2_chk_ld_inst_vld                         ),//1->3, for 3 ld_dc, LTL@20241104
  .lsdc0_ex2_chk_ld_inst_vld                         (lsdc0_ex2_chk_ld_inst_vld                        ),
  .lsdc1_ex2_chk_ld_inst_vld                         (lsdc1_ex2_chk_ld_inst_vld                        ),
  .lm_state_is_ex_wait_lock                          (lm_state_is_ex_wait_lock                         ),
  .lm_state_is_idle                                  (lm_state_is_idle                                 ),
  .pad_yy_icg_scan_en                                (pad_yy_icg_scan_en                               ),
  .pfu_biu_req_addr                                  (pfu_biu_req_addr                                 ),
  .pw_merge_stall                                    (pw_merge_stall                                   ),
  .rb_biu_req_addr                                   (rb_biu_req_addr                                  ),
  .rb_biu_req_unmask                                 (rb_biu_req_unmask                                ),
  .rtu_lsu_async_flush                               (rtu_lsu_async_flush                              ),
  .snq_can_create_snq_uncheck                        (snq_can_create_snq_uncheck                       ),
  .snq_create_addr                                   (snq_create_addr                                  ),
  .sq_pop_addr                                       (sq_pop_addr                                      ),
  .sq_pop_bytes_vld                                  (sq_pop_bytes_vld                                 ),
  .sq_pop_priv_mode                                  (sq_pop_priv_mode                                 ),
  .sq_wmb_merge_req                                  (sq_wmb_merge_req                                 ),
  .sq_wmb_merge_stall_req                            (sq_wmb_merge_stall_req                           ),
  .vb_wmb_empty                                      (vb_wmb_empty                                     ),
  .vb_wmb_entry_rcl_done_x                           (vb_wmb_entry_rcl_done[entry_i]                   ),
  .wmb_b_resp_exokay                                 (wmb_b_resp_exokay                                ),
  .wmb_biu_ar_id                                     (wmb_biu_ar_id                                    ),
  .wmb_biu_aw_id                                     (wmb_biu_aw_id                                    ),
  .wmb_biu_write_en                                  (wmb_biu_write_en                                 ),
  .wmb_ce_addr                                       (wmb_ce_addr                                      ),
  .wmb_ce_atomic                                     (wmb_ce_atomic                                    ),
  .wmb_ce_bytes_vld                                  (wmb_ce_bytes_vld                                 ),
  .wmb_ce_bytes_vld_full                             (wmb_ce_bytes_vld_full                            ),
  .wmb_ce_create_vld                                 (wmb_ce_create_vld                                ),
  .wmb_ce_data128                                    (wmb_ce_data128                                   ),
  .wmb_ce_data_vld                                   (wmb_ce_data_vld                                  ),
  .wmb_ce_dcache_inst                                (wmb_ce_dcache_inst                               ),
  .wmb_ce_dtcm_hit                                   (wmb_ce_dtcm_hit                                  ),
  .wmb_ce_fence_mode                                 (wmb_ce_fence_mode                                ),
  .wmb_ce_icc                                        (wmb_ce_icc                                       ),
  .wmb_ce_preg                                       (wmb_ce_preg                                      ),
  .wmb_ce_iid                                        (wmb_ce_iid                                       ),
  .wmb_ce_inst_flush                                 (wmb_ce_inst_flush                                ),
  .wmb_ce_inst_mode                                  (wmb_ce_inst_mode                                 ),
  .wmb_ce_inst_size                                  (wmb_ce_inst_size                                 ),
  .wmb_ce_inst_type                                  (wmb_ce_inst_type                                 ),
  .wmb_ce_itcm_hit                                   (wmb_ce_itcm_hit                                  ),
  .wmb_ce_last_addr_plus                             (wmb_ce_last_addr_plus                            ),
  .wmb_ce_last_addr_sub                              (wmb_ce_last_addr_sub                             ),
  .wmb_ce_merge_en                                   (wmb_ce_merge_en                                  ),
  .wmb_ce_page_buf                                   (wmb_ce_page_buf                                  ),
  .wmb_ce_page_ca                                    (wmb_ce_page_ca                                   ),
  .wmb_ce_page_sec                                   (wmb_ce_page_sec                                  ),
  .wmb_ce_page_share                                 (wmb_ce_page_share                                ),
  .wmb_ce_page_so                                    (wmb_ce_page_so                                   ),
  .wmb_ce_page_wa                                    (wmb_ce_page_wa                                   ),
  .wmb_ce_priv_mode                                  (wmb_ce_priv_mode                                 ),
  .wmb_ce_sc_wb_vld                                  (wmb_ce_sc_wb_vld                                 ),
  .wmb_ce_spec_fail                                  (wmb_ce_spec_fail                                 ),
  .wmb_ce_sync_fence                                 (wmb_ce_sync_fence                                ),
  .wmb_ce_update_dcache_dirty                        (wmb_ce_update_dcache_dirty                       ),
  .wmb_ce_update_dcache_page_share                   (wmb_ce_update_dcache_page_share                  ),
  .wmb_ce_update_dcache_share                        (wmb_ce_update_dcache_share                       ),
  .wmb_ce_update_dcache_valid                        (wmb_ce_update_dcache_valid                       ),
  .wmb_ce_update_dcache_way                          (wmb_ce_update_dcache_way                         ),
  .wmb_ce_update_same_dcache_line                    (wmb_ce_update_same_dcache_line                   ),
  .wmb_ce_update_same_dcache_line_ptr                (wmb_ce_update_same_dcache_line_ptr               ),
  .wmb_ce_vstart_vld                                 (wmb_ce_vstart_vld                                ),
  .wmb_ce_wb_cmplt_success                           (wmb_ce_wb_cmplt_success                          ),
  .wmb_ce_wb_data_success                            (wmb_ce_wb_data_success                           ),
  .wmb_ce_write_imme                                 (wmb_ce_write_imme                                ),
  .wmb_create_ptr_next1_x                            (wmb_create_ptr_next1[entry_i]                    ),
  .wmb_create_vb_success                             (wmb_create_vb_success                            ),
  .wmb_data_ptr_x                                    (wmb_data_ptr[entry_i]                            ),
  .wmb_dcache_arb_req_unmask                         (wmb_dcache_arb_req_unmask                        ),
  .wmb_dcache_inst_write_req_hit_idx                 (wmb_dcache_inst_write_req_hit_idx                ),
  .wmb_dcache_req_ptr_x                              (wmb_dcache_req_ptr[entry_i]                      ),
  .wmb_entry_addr_v                                  (wmb_entry_addr[entry_i]                          ),
  .wmb_entry_already_read_req_x                      (wmb_entry_already_read_req[entry_i]              ),
  .wmb_entry_ar_pending_x                            (wmb_entry_ar_pending[entry_i]                    ),
  .wmb_entry_atomic_and_vld_x                        (wmb_entry_atomic_and_vld[entry_i]                ),
  .wmb_entry_atomic_x                                (wmb_entry_atomic[entry_i]                        ),
  .wmb_entry_aw_pending_x                            (wmb_entry_aw_pending[entry_i]                    ),
  .wmb_entry_biu_id_v                                (wmb_entry_biu_id[entry_i]                        ),
  .wmb_entry_bytes_vld_v                             (wmb_entry_bytes_vld[entry_i]                     ),
  .wmb_entry_cancel_acc_req0_x                       (wmb_entry_cancel_acc_req0[entry_i]               ),
  .wmb_entry_cancel_acc_req1_x                       (wmb_entry_cancel_acc_req1[entry_i]               ),
  .wmb_entry_cancel_acc_req2_x                       (wmb_entry_cancel_acc_req2[entry_i]               ),
  .wmb_entry_create_data_vld_x                       (wmb_entry_create_data_vld[entry_i]               ),
  .wmb_entry_create_dp_vld_x                         (wmb_entry_create_dp_vld[entry_i]                 ),
  .wmb_entry_create_gateclk_en_x                     (wmb_entry_create_gateclk_en[entry_i]             ),
  .wmb_entry_create_vld_x                            (wmb_entry_create_vld[entry_i]                          ),
  .wmb_entry_data_biu_req_x                          (wmb_entry_data_biu_req[entry_i]                        ),
  .wmb_entry_data_ptr_after_write_shift_imme_gate_x  (wmb_entry_data_ptr_after_write_shift_imme_gate[entry_i]),
  .wmb_entry_data_ptr_after_write_shift_imme_x       (wmb_entry_data_ptr_after_write_shift_imme[entry_i]     ),
  .wmb_entry_data_ptr_with_write_shift_imme_x        (wmb_entry_data_ptr_with_write_shift_imme[entry_i]      ),
  .wmb_entry_data_req_wns_x                          (wmb_entry_data_req_wns[entry_i]                        ),
  .wmb_entry_data_req_x                              (wmb_entry_data_req[entry_i]                            ),
  .wmb_entry_data_v                                  (wmb_entry_data[entry_i]                                ),
  .wmb_entry_dcache_inst_same_line_x                 (wmb_entry_dcache_inst_same_line[entry_i]               ),
  .wmb_entry_dcache_inst_x                           (wmb_entry_dcache_inst[entry_i]                         ),
  .wmb_entry_dcache_page_share_x                     (wmb_entry_dcache_page_share[entry_i]                   ),
  .wmb_entry_dcache_dirty_x                          (wmb_entry_dcache_dirty[entry_i]                   ),
  .wmb_entry_dcache_share_x                          (wmb_entry_dcache_share[entry_i]                   ),
  .wmb_entry_dcache_valid_x                          (wmb_entry_dcache_valid[entry_i]                   ),
  .wmb_entry_dcache_way_x                            (wmb_entry_dcache_way[entry_i]                          ),
  .wmb_entry_depd_x                                  (wmb_entry_depd[entry_i]                                ),
  .wmb_entry_discard_req0_x                          (wmb_entry_discard_req0[entry_i]                        ),//1->3, for 3 ld_dc, LTL@20241104
  .wmb_entry_discard_req1_x                          (wmb_entry_discard_req1[entry_i]                        ),
  .wmb_entry_discard_req2_x                          (wmb_entry_discard_req2[entry_i]                        ),
  .wmb_entry_dtcm_hit_x                              (wmb_entry_dtcm_hit[entry_i]                            ),
  .wmb_entry_fwd_bytes_vld0_v                        (wmb_entry_fwd_bytes_vld0[entry_i]                      ),//1->3, for 3 ld_dc, LTL@20241104
  .wmb_entry_fwd_bytes_vld1_v                        (wmb_entry_fwd_bytes_vld1[entry_i]                      ),
  .wmb_entry_fwd_bytes_vld2_v                        (wmb_entry_fwd_bytes_vld2[entry_i]                      ),
  .wmb_entry_fwd_data_pe_gateclk_en0_x               (wmb_entry_fwd_data_pe_gateclk_en0[entry_i]             ),//1->3, for 3 ld_dc, LTL@20241104
  .wmb_entry_fwd_data_pe_gateclk_en1_x               (wmb_entry_fwd_data_pe_gateclk_en1[entry_i]             ),
  .wmb_entry_fwd_data_pe_gateclk_en2_x               (wmb_entry_fwd_data_pe_gateclk_en2[entry_i]             ),
  .wmb_entry_fwd_data_pe_req0_x                      (wmb_entry_fwd_data_pe_req0[entry_i]                    ),//1->3, for 3 ld_dc, LTL@20241104
  .wmb_entry_fwd_data_pe_req1_x                      (wmb_entry_fwd_data_pe_req1[entry_i]                    ),
  .wmb_entry_fwd_data_pe_req2_x                      (wmb_entry_fwd_data_pe_req2[entry_i]                    ),
  .wmb_entry_fwd_req0_x                              (wmb_entry_fwd_req0[entry_i]                            ),//1->3, for 3 ld_dc, LTL@20241104
  .wmb_entry_fwd_req1_x                              (wmb_entry_fwd_req1[entry_i]                            ),
  .wmb_entry_fwd_req2_x                              (wmb_entry_fwd_req2[entry_i]                            ),
  .wmb_entry_icc_and_vld_x                           (wmb_entry_icc_and_vld[entry_i]                         ),
  .wmb_entry_icc_x                                   (wmb_entry_icc[entry_i]                                 ),
  .wmb_entry_iid_v                                   (wmb_entry_iid[entry_i]                                 ),
  .wmb_entry_inst_flush_x                            (wmb_entry_inst_flush[entry_i]                          ),
  .wmb_entry_inst_is_dcache_x                        (wmb_entry_inst_is_dcache[entry_i]                      ),
  .wmb_entry_inst_mode_v                             (wmb_entry_inst_mode[entry_i]                           ),
  .wmb_entry_inst_size_v                             (wmb_entry_inst_size[entry_i]                            ),
  .wmb_entry_inst_type_v                             (wmb_entry_inst_type[entry_i]                           ),
  .wmb_entry_last_addr_plus_x                        (wmb_entry_last_addr_plus[entry_i]                      ),
  .wmb_entry_last_addr_sub_x                         (wmb_entry_last_addr_sub[entry_i]                       ),
  .wmb_entry_mem_set_write_gateclk_en_x              (wmb_entry_mem_set_write_gateclk_en[entry_i]            ),
  .wmb_entry_mem_set_write_grnt_x                    (wmb_entry_mem_set_write_grnt[entry_i]                  ),
  .wmb_entry_merge_data_addr_hit_x                   (wmb_entry_merge_data_addr_hit[entry_i]                 ),
  .wmb_entry_merge_data_stall_x                      (wmb_entry_merge_data_stall[entry_i]                    ),
  .wmb_entry_merge_data_vld_x                        (wmb_entry_merge_data_vld[entry_i]                      ),
  .wmb_entry_merge_data_wait_not_vld_req_x           (wmb_entry_merge_data_wait_not_vld_req[entry_i]         ),
  .wmb_entry_next_so_bypass_x                        (wmb_entry_next_so_bypass[entry_i]                      ),
  .wmb_entry_no_op_x                                 (wmb_entry_no_op[entry_i]                               ),
  .wmb_entry_page_buf_x                              (wmb_entry_page_buf[entry_i]                            ),
  .wmb_entry_page_ca_x                               (wmb_entry_page_ca[entry_i]                             ),
  .wmb_entry_page_sec_x                              (wmb_entry_page_sec[entry_i]                            ),
  .wmb_entry_page_share_x                            (wmb_entry_page_share[entry_i]                          ),
  .wmb_entry_page_so_x                               (wmb_entry_page_so[entry_i]                             ),
  .wmb_entry_page_wa_x                               (wmb_entry_page_wa[entry_i]                             ),
  .wmb_entry_pfu_biu_req_hit_idx_x                   (wmb_entry_pfu_biu_req_hit_idx[entry_i]                 ),
  .wmb_entry_pop_vld_x                               (wmb_entry_pop_vld[entry_i]                             ),
  .wmb_entry_preg_v                                  (wmb_entry_preg[entry_i]                                ),
  .wmb_entry_priv_mode_v                             (wmb_entry_priv_mode[entry_i]                           ),
  .wmb_entry_rb_biu_req_hit_idx_x                    (wmb_entry_rb_biu_req_hit_idx[entry_i]                  ),
  .wmb_entry_read_dp_req_x                           (wmb_entry_read_dp_req[entry_i]                         ),
  .wmb_entry_read_ptr_chk_idx_shift_imme_x           (wmb_entry_read_ptr_chk_idx_shift_imme[entry_i]         ),
  .wmb_entry_read_ptr_unconditional_shift_imme_x     (wmb_entry_read_ptr_unconditional_shift_imme[entry_i]   ),
  .wmb_entry_read_req_x                              (wmb_entry_read_req[entry_i]                            ),
  .wmb_entry_read_resp_ready_x                       (wmb_entry_read_resp_ready[entry_i]                     ),
  .wmb_entry_ready_to_dcache_line_x                  (wmb_entry_ready_to_dcache_line[entry_i]                ),
  .wmb_entry_sc_wb_success_x                         (wmb_entry_sc_wb_success[entry_i]                       ),
  .wmb_entry_snq_depd_remove_x                       (wmb_entry_snq_depd_remove[entry_i]                     ),
  .wmb_entry_snq_depd_x                              (wmb_entry_snq_depd[entry_i]                            ),
  .wmb_entry_spec_fail_x                             (wmb_entry_spec_fail[entry_i]                           ),
  .wmb_entry_sq_pop_sameline_set_x                   (wmb_entry_sq_pop_sameline_set[entry_i]                 ),
  .wmb_entry_st_hit_sq_pop_dcache_line_x             (wmb_entry_st_hit_sq_pop_dcache_line[entry_i]           ),
  .wmb_entry_sync_fence_biu_req_success_x            (wmb_entry_sync_fence_biu_req_success[entry_i]          ),
  .wmb_entry_sync_fence_inst_x                       (wmb_entry_sync_fence_inst[entry_i]                     ),
  .wmb_entry_sync_fence_x                            (wmb_entry_sync_fence[entry_i]                          ),
  .wmb_entry_vld_x                                   (wmb_entry_vld[entry_i]                                 ),
  .wmb_entry_vstart_vld_x                            (wmb_entry_vstart_vld[entry_i]                          ),
  .wmb_entry_w_last_set_x                            (wmb_entry_w_last_set[entry_i]                          ),
  .wmb_entry_w_last_x                                (wmb_entry_w_last[entry_i]                              ),
  .wmb_entry_w_pending_x                             (wmb_entry_w_pending[entry_i]                           ),
  .wmb_entry_wb_cmplt_grnt_x                         (wmb_entry_wb_cmplt_grnt[entry_i]                       ),
  .wmb_entry_wb_cmplt_req_x                          (wmb_entry_wb_cmplt_req[entry_i]                        ),
  .wmb_entry_wb_data_grnt_x                          (wmb_entry_wb_data_grnt[entry_i]                        ),
  .wmb_entry_wb_data_req_x                           (wmb_entry_wb_data_req[entry_i]                         ),
  .wmb_entry_write_biu_dp_req_x                      (wmb_entry_write_biu_dp_req[entry_i]                    ),
  .wmb_entry_write_biu_req_x                         (wmb_entry_write_biu_req[entry_i]                       ),
  .wmb_entry_write_dcache_req_x                      (wmb_entry_write_dcache_req[entry_i]                    ),
  .wmb_entry_write_imme_bypass_x                     (wmb_entry_write_imme_bypass[entry_i]                   ),
  .wmb_entry_write_imme_x                            (wmb_entry_write_imme[entry_i]                          ),
  .wmb_entry_write_ptr_chk_idx_shift_imme_x          (wmb_entry_write_ptr_chk_idx_shift_imme[entry_i]        ),
  .wmb_entry_write_ptr_unconditional_shift_imme_x    (wmb_entry_write_ptr_unconditional_shift_imme[entry_i]  ),
  .wmb_entry_write_req_x                             (wmb_entry_write_req[entry_i]                           ),
  .wmb_entry_write_stall_x                           (wmb_entry_write_stall[entry_i]                         ),
  .wmb_entry_write_tcm_req_x                         (wmb_entry_write_tcm_req[entry_i]                       ),
  .wmb_entry_write_vb_req_x                          (wmb_entry_write_vb_req[entry_i]                        ),
  .wmb_read_ptr_read_req_grnt                        (wmb_read_ptr_read_req_grnt                             ),
  .wmb_read_ptr_shift_imme_grnt                      (wmb_read_ptr_shift_imme_grnt                           ),
  .wmb_read_ptr_x                                    (wmb_read_ptr[entry_i]                                  ),
  .wmb_same_line_resp_ready                          (wmb_same_line_resp_ready                               ),
  .wmb_tcm_grant                                     (wmb_tcm_grant                                          ),
  .wmb_tcm_write_done_x                              (wmb_tcm_write_done[entry_i]                            ),
  .wmb_wakeup_queue_not_empty                        (wmb_wakeup_queue_not_empty                             ),
  .wmb_write_biu_dcache_line                         (wmb_write_biu_dcache_line                              ),
  .wmb_write_dcache_success                          (wmb_write_dcache_success                               ),
  .wmb_write_imme                                    (wmb_write_imme                                         ),
  .wmb_write_ptr_shift_imme_grnt                     (wmb_write_ptr_shift_imme_grnt                          ),
  .wmb_write_ptr_to_next3_x                          (wmb_write_ptr_to_next3[entry_i]                        ),
  .wmb_write_ptr_x                                   (wmb_write_ptr[entry_i]                                 ),
//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
  //input
  .dtu_lsu_data_trig_en                              (dtu_lsu_data_trig_en                                   ),
  .wmb_ce_halt_info_0                                (wmb_ce_halt_info_0                                     ),
  .wmb_ce_halt_info_1                                (wmb_ce_halt_info_1                                     ),
  .wmb_ce_expt_vld                                   (wmb_ce_expt_vld                                        ),
  //output
  .wmb_entry_halt_info_0_v                           (wmb_entry_halt_info_0[entry_i]                         ),
  .wmb_entry_halt_info_1_v                           (wmb_entry_halt_info_1[entry_i]                         )
//==========================================================
//                  Risc-V Debug zdb End 
//========================================================== 
);
  end
endgenerate

//==========================================================
//                  Maintain pointer
//==========================================================
//----------------------registers---------------------------
//circular bit is to check whether write/read/data ptr equal to create_ptr
//+------------+
//| create_ptr |
//+------------+
always @(posedge wmb_create_ptr_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    wmb_create_ptr[WMB_ENTRY-1:0] <=  {{WMB_ENTRY-1{1'b0}},1'b1};
  else if(wmb_create_vld)
    wmb_create_ptr[WMB_ENTRY-1:0] <=  wmb_create_ptr_next1[WMB_ENTRY-1:0];
end

always @(posedge wmb_create_ptr_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    wmb_create_ptr_circular       <=  1'b0;
  else if(wmb_create_vld  &&  wmb_create_ptr[WMB_ENTRY-1])
    wmb_create_ptr_circular       <=  !wmb_create_ptr_circular;
end

//+----------+
//| read_ptr |
//+----------+
always @(posedge wmb_read_ptr_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    wmb_read_ptr[WMB_ENTRY-1:0]       <=  {{WMB_ENTRY-1{1'b0}},1'b1};
  else if(wmb_read_ptr_shift_vld)
    wmb_read_ptr[WMB_ENTRY-1:0]       <=  wmb_read_ptr_next1[WMB_ENTRY-1:0];
end

always @(posedge wmb_read_ptr_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    wmb_read_ptr_circular             <=  1'b0;
  else if(wmb_read_ptr_shift_vld  &&  wmb_read_ptr[WMB_ENTRY-1])
    wmb_read_ptr_circular             <=  !wmb_read_ptr_circular;
end

//+-----------+
//| write_ptr |
//+-----------+
// &Force("output","wmb_write_ptr"); @322
always @(posedge wmb_write_ptr_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    wmb_write_ptr[WMB_ENTRY-1:0]      <=  {{WMB_ENTRY-1{1'b0}},1'b1};
  else
    wmb_write_ptr[WMB_ENTRY-1:0]      <=  wmb_write_ptr_set[WMB_ENTRY-1:0];
end

always @(posedge wmb_write_ptr_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    wmb_write_ptr_circular            <=  1'b0;
  else
    wmb_write_ptr_circular            <=  wmb_write_ptr_circular_set;
end

//+----------+
//| data_ptr |
//+----------+
always @(posedge wmb_data_ptr_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    wmb_data_ptr[WMB_ENTRY-1:0]       <=  {{WMB_ENTRY-1{1'b0}},1'b1};
  else if(wmb_data_ptr_shift_vld)
    wmb_data_ptr[WMB_ENTRY-1:0]       <=  wmb_data_ptr_next1[WMB_ENTRY-1:0];
end

always @(posedge wmb_data_ptr_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    wmb_data_ptr_circular             <=  1'b0;
  else if(wmb_data_ptr_shift_vld  &&  wmb_data_ptr[WMB_ENTRY-1])
    wmb_data_ptr_circular             <=  !wmb_data_ptr_circular;
end

//------------------write ptr set---------------------------
//if snq clear read req, then read ptr must be set write_ptr_set
// &CombBeg; @360
always @( wmb_write_ptr_next[1][WMB_ENTRY-1:0]
       or wmb_write_ptr[WMB_ENTRY-1:0]
       or wmb_write_ptr_shift_vld)
begin
if(wmb_write_ptr_shift_vld)
  wmb_write_ptr_set[WMB_ENTRY-1:0]  = wmb_write_ptr_next[1][WMB_ENTRY-1:0];
else
  wmb_write_ptr_set[WMB_ENTRY-1:0]  = wmb_write_ptr[WMB_ENTRY-1:0];
// &CombEnd; @365
end

// &CombBeg; @367
always @( wmb_write_ptr_circular_set_vld
       or wmb_write_ptr_circular)
begin
if(wmb_write_ptr_circular_set_vld)
  wmb_write_ptr_circular_set  = !wmb_write_ptr_circular;
else
  wmb_write_ptr_circular_set  = wmb_write_ptr_circular;
// &CombEnd; @372
end
//------------------pointer encode--------------------------
// &Instance("wk_rtu_encode_8","x_lsu_wmb_read_ptr_encode"); @374
wk_rtu_encode_8  x_lsu_wmb_read_ptr_encode (
  .x_num                    (wmb_read_ptr_encode[2:0]),
  .x_num_expand             (wmb_read_ptr[WMB_ENTRY-1:0]       )
);

// &Connect( .x_num          (wmb_read_ptr_encode[2:0]   ), @375
//           .x_num_expand   (wmb_read_ptr[7:0]          )); @376


// &Force("output","wmb_write_ptr_encode"); @379
// &Instance("wk_rtu_encode_8","x_lsu_wmb_write_ptr_encode"); @380
wk_rtu_encode_8  x_lsu_wmb_write_ptr_encode (               //??? wmb_entry > 8, need more bit
  .x_num                     (wmb_write_ptr_encode[2:0]),
  .x_num_expand              (wmb_write_ptr[WMB_ENTRY-1:0]       )
);

// &Connect( .x_num          (wmb_write_ptr_encode[2:0]  ), @381
//           .x_num_expand   (wmb_write_ptr[7:0]         )); @382

// &Instance("wk_rtu_encode_8","x_lsu_wmb_write_ptr_next3_encode"); @384
wk_rtu_encode_8  x_lsu_wmb_write_ptr_next3_encode (
  .x_num                           (wmb_write_ptr_next3_encode[2:0]),
  .x_num_expand                    (wmb_write_ptr_next[3][WMB_ENTRY-1:0]       )
);

// &Connect( .x_num          (wmb_write_ptr_next3_encode[2:0]  ), @385
//           .x_num_expand   (wmb_write_ptr_next3[7:0]         )); @386

//------------------condition wires-------------------------
assign wmb_write_burst_neg = (wmb_write_req_addr[5:4] ==  2'b11);

assign wmb_write_req_addr_dcache_begin  = (wmb_write_req_addr[5:4] ==  2'b11)
                                              && wmb_write_req_next1_addr_sub
                                              && wmb_write_req_next2_addr_sub
                                              && wmb_write_req_next3_addr_sub
                                          ||  (wmb_write_req_addr[5:4] ==  2'b0)
                                              && wmb_write_req_next1_addr_plus
                                              && wmb_write_req_next2_addr_plus
                                              && wmb_write_req_next3_addr_plus;

//------------has read resp in next 4 entry-----------------
assign write_burst_en = !cp0_lsu_wr_burst_dis;

assign wmb_write_biu_dcache_line  = write_burst_en
                                    &&  wmb_write_req_addr_dcache_begin
                                    &&  wmb_write_req_ready_to_dcache_line
                                    &&  wmb_write_req_next1_ready_to_dcache_line
                                    &&  wmb_write_req_next2_ready_to_dcache_line
                                    &&  wmb_write_req_next3_ready_to_dcache_line;

assign wmb_read_grnt            = bus_arb_wmb_ar_grnt;
assign wmb_read_ptr_unconditional_shift_imme  = |wmb_entry_read_ptr_unconditional_shift_imme[WMB_ENTRY-1:0];
assign wmb_read_ptr_chk_idx_shift_imme        = |wmb_entry_read_ptr_chk_idx_shift_imme[WMB_ENTRY-1:0];

assign wmb_create_vb_success    = wmb_vb_create_vld &&  vb_wmb_create_grnt;
assign wmb_write_grnt           = bus_arb_wmb_aw_grnt
                                  || wmb_tcm_grant
//                                  ||  wmb_write_dcache_success
                                  ||  wmb_create_vb_success;
assign wmb_write_req            = |wmb_entry_write_req[WMB_ENTRY-1:0];
assign wmb_write_ptr_unconditional_shift_imme = |wmb_entry_write_ptr_unconditional_shift_imme[WMB_ENTRY-1:0];
assign wmb_write_ptr_chk_idx_shift_imme       = |wmb_entry_write_ptr_chk_idx_shift_imme[WMB_ENTRY-1:0];
assign wmb_data_grnt            = bus_arb_wmb_w_grnt;
//                                  ||  wmb_write_dcache_success;
assign wmb_data_req             = |wmb_entry_data_req[WMB_ENTRY-1:0];
assign wmb_data_ptr_after_write_shift_imme      = |wmb_entry_data_ptr_after_write_shift_imme[WMB_ENTRY-1:0];
assign wmb_data_ptr_after_write_shift_imme_gate = |wmb_entry_data_ptr_after_write_shift_imme_gate[WMB_ENTRY-1:0];
assign wmb_data_ptr_with_write_shift_imme       = |wmb_entry_data_ptr_with_write_shift_imme[WMB_ENTRY-1:0];
//-----------------shift condition wires--------------------
assign wmb_read_ptr_shift_imme_grnt = !wmb_read_ptr_met_create
                                      &&  (wmb_read_ptr_unconditional_shift_imme
                                          ||  wmb_read_ptr_chk_idx_shift_imme
                                              &&  !wmb_read_req_hit_idx);

assign wmb_read_ptr_read_req_grnt   = wmb_read_grnt
                                      &&  (!wmb_read_req_ctc_inst
                                          ||  wmb_read_req_ctc_end);

assign wmb_read_ptr_shift_vld   = wmb_read_ptr_read_req_grnt
                                  ||  wmb_read_ptr_shift_imme_grnt;

//all shift imme don't see wmb write imme, because write_imme only effective
//to wo st
assign wmb_write_ptr_shift_imme_grnt  = !wmb_write_ptr_met_create
                                        //&&  wmb_write_imme
                                        &&  (wmb_write_ptr_unconditional_shift_imme
                                            ||  wmb_write_ptr_chk_idx_shift_imme
                                                &&  !wmb_write_req_hit_idx);

assign wmb_write_ptr_shift_vld  = wmb_write_grnt
                                  ||  wmb_write_ptr_shift_imme_grnt;
//set circular
assign wmb_write_ptr_circular_set_vld = wmb_write_ptr_shift_vld
                                        &&  wmb_write_ptr[WMB_ENTRY-1];

assign wmb_data_ptr_shift_vld   = wmb_data_grnt &&  wmb_data_req
                                  ||  !wmb_data_ptr_met_create
                                      &&  (wmb_data_ptr_after_write_shift_imme
                                          ||  wmb_data_ptr_with_write_shift_imme
                                              &&  wmb_write_ptr_shift_imme_grnt);
//------------------other pointer---------------------------
assign wmb_create_ptr_next1[WMB_ENTRY-1:0]  = {wmb_create_ptr[WMB_ENTRY-2:0],
                                              wmb_create_ptr[WMB_ENTRY-1]};
//assign wmb_create_ptr_next2[WMB_ENTRY-1:0]  = {wmb_create_ptr[WMB_ENTRY-3:0],
//                                              wmb_create_ptr[WMB_ENTRY-1:WMB_ENTRY-2]};
//assign wmb_create_ptr_next3[WMB_ENTRY-1:0]  = {wmb_create_ptr[WMB_ENTRY-4:0],
//                                              wmb_create_ptr[WMB_ENTRY-1:WMB_ENTRY-3]};
//assign wmb_create_ptr_next4[WMB_ENTRY-1:0]  = {wmb_create_ptr[WMB_ENTRY-5:0],
//                                              wmb_create_ptr[WMB_ENTRY-1:WMB_ENTRY-4]};
//assign wmb_create_ptr_next5[WMB_ENTRY-1:0]  = {wmb_create_ptr[WMB_ENTRY-6:0],
//                                              wmb_create_ptr[WMB_ENTRY-1:WMB_ENTRY-5]};
//assign wmb_create_ptr_next6[WMB_ENTRY-1:0]  = {wmb_create_ptr[WMB_ENTRY-7:0],
//                                              wmb_create_ptr[WMB_ENTRY-1:WMB_ENTRY-6]};
//assign wmb_create_ptr_next7[WMB_ENTRY-1:0]  = {wmb_create_ptr[WMB_ENTRY-8:0],
//                                              wmb_create_ptr[WMB_ENTRY-1:WMB_ENTRY-7]};

//assign wmb_read_ptr_and_vld[WMB_ENTRY-1:0]  = wmb_read_ptr[WMB_ENTRY-1:0]
//                                              & wmb_entry_vld[WMB_ENTRY-1:0];
//assign wmb_read_ptr_vld                     = |wmb_read_ptr_and_vld[WMB_ENTRY-1:0];
assign wmb_read_ptr_next1[WMB_ENTRY-1:0]    = {wmb_read_ptr[WMB_ENTRY-2:0],
                                              wmb_read_ptr[WMB_ENTRY-1]};
//mem set must use write_ptr_to_next_3
assign wmb_write_ptr_next[1][WMB_ENTRY-1:0]   = {wmb_write_ptr[WMB_ENTRY-2:0],   //not parameterized, too explict, LTL@20241024
                                              wmb_write_ptr[WMB_ENTRY-1]};
assign wmb_write_ptr_next[2][WMB_ENTRY-1:0]   = {wmb_write_ptr[WMB_ENTRY-3:0],
                                              wmb_write_ptr[WMB_ENTRY-1:WMB_ENTRY-2]};
assign wmb_write_ptr_next[3][WMB_ENTRY-1:0]   = {wmb_write_ptr[WMB_ENTRY-4:0],
                                              wmb_write_ptr[WMB_ENTRY-1:WMB_ENTRY-3]};
assign wmb_write_ptr_next[4][WMB_ENTRY-1:0]   = {wmb_write_ptr[WMB_ENTRY-5:0],
                                              wmb_write_ptr[WMB_ENTRY-1:WMB_ENTRY-4]};
assign wmb_write_ptr_next[5][WMB_ENTRY-1:0]   = {wmb_write_ptr[WMB_ENTRY-6:0],
                                              wmb_write_ptr[WMB_ENTRY-1:WMB_ENTRY-5]};
assign wmb_write_ptr_next[6][WMB_ENTRY-1:0]   = {wmb_write_ptr[WMB_ENTRY-7:0],
                                              wmb_write_ptr[WMB_ENTRY-1:WMB_ENTRY-6]};
assign wmb_write_ptr_next[7][WMB_ENTRY-1:0]   = {wmb_write_ptr[0],
                                              wmb_write_ptr[WMB_ENTRY-1:WMB_ENTRY-7]};

//always_comb begin    //used for wmb_write_ptr_next1-7 parameter, LTL@20241024
//  wmb_write_ptr_next[0] = {WMB_ENTRY{1'b0}};
//  for(int i=1;i<WMB_ENTRY;i++) begin
//    wmb_write_ptr_next[i] = {wmb_write_ptr[WMB_ENTRY-1-i:0], wmb_write_ptr[WMB_ENTRY-1:WMB_ENTRY-i]};  //wrong syntax, LTL@20241024
//  end
//end


assign wmb_write_ptr_to_next3[WMB_ENTRY-1:0]  = wmb_write_ptr_next[3][WMB_ENTRY-1:0]  //wmb_write_ptr_next3->wmb_write_ptr_next[3] LTL@20241024
                                                | wmb_write_ptr_next[2][WMB_ENTRY-1:0]
                                                | wmb_write_ptr_next[1][WMB_ENTRY-1:0]
                                                | wmb_write_ptr[WMB_ENTRY-1:0];

assign wmb_data_ptr_next1[WMB_ENTRY-1:0]    = {wmb_data_ptr[WMB_ENTRY-2:0],
                                              wmb_data_ptr[WMB_ENTRY-1]};

//-------------judge if meet create signal------------------
assign wmb_read_ptr_met_create  = (wmb_read_ptr[WMB_ENTRY-1:0]  ==  wmb_create_ptr[WMB_ENTRY-1:0])
                                  &&  (wmb_read_ptr_circular  ==  wmb_create_ptr_circular);

assign wmb_write_ptr_met_create = (wmb_write_ptr[WMB_ENTRY-1:0] ==  wmb_create_ptr[WMB_ENTRY-1:0])
                                  &&  (wmb_write_ptr_circular ==  wmb_create_ptr_circular);

assign wmb_data_ptr_met_create  = (wmb_data_ptr[WMB_ENTRY-1:0]  ==  wmb_create_ptr[WMB_ENTRY-1:0])
                                  &&  (wmb_data_ptr_circular  ==  wmb_create_ptr_circular);

//==========================================================
//          Generate signal for sq pop
//==========================================================
//----------------can't merge signal------------------------
assign wmb_has_dcache_inst      = |(wmb_entry_dcache_inst[WMB_ENTRY-1:0]
                                    & wmb_entry_vld[WMB_ENTRY-1:0]);
//------------------merge signal----------------------------
assign wmb_merge_data_stall     = |wmb_entry_merge_data_stall[WMB_ENTRY-1:0];
assign wmb_merge_data_addr_hit  = |wmb_entry_merge_data_addr_hit[WMB_ENTRY-1:0];
//assign wmb_hit_sq_pop_dcache_line = |wmb_entry_hit_sq_pop_dcache_line[WMB_ENTRY-1:0];
//------------------wmb ce create signal--------------------
assign wmb_ce_create_merge      = sq_wmb_merge_req
                                  &&  (wmb_merge_data_addr_hit
                                      ||  wmb_ce_merge_data_addr_hit);
assign wmb_ce_create_stall      = wmb_merge_data_stall
                                  ||  wmb_ce_merge_data_stall
                                  ||  (wmb_merge_data_addr_hit
                                          ||  wmb_ce_merge_data_addr_hit)
                                      &&  (sq_wmb_merge_stall_req
                                          ||  wmb_has_dcache_inst);
assign wmb_ce_create_same_dcache_line[WMB_ENTRY-1:0] =  {WMB_ENTRY{wmb_ce_sq_pop_sameline_set && wmb_create_vld}}
                                                           & wmb_create_ptr[WMB_ENTRY-1:0]
                                                        |  wmb_entry_sq_pop_sameline_set[WMB_ENTRY-1:0]; 

assign wmb_ce_create_merge_ptr[WMB_ENTRY-1:0] = (wmb_ce_create_wmb_dp_req  &&  wmb_ce_merge_data_addr_hit)
                                                ? wmb_create_ptr[WMB_ENTRY-1:0]
                                                : wmb_entry_merge_data_addr_hit[WMB_ENTRY-1:0];

//create depd signal for dcache inst
assign wmb_ce_create_depd_create_ptr  = wmb_ce_create_wmb_dp_req
                                        &&  wmb_ce_hit_sq_pop_dcache_line
                                        &&  (sq_pop_dcache_1line_inst
                                                &&  wmb_ce_dcache_1line_inst
                                            ||  sq_pop_dcache_1line_inst
                                                &&  (wmb_ce_st_inst | wmb_ce_atomic)
                                            ||  (sq_pop_st_inst | sq_pop_atomic)
                                                &&  wmb_ce_dcache_1line_inst);

assign wmb_ce_create_depd_val[WMB_ENTRY-1:0]  = {WMB_ENTRY{wmb_ce_create_depd_create_ptr}}
                                                  & wmb_create_ptr[WMB_ENTRY-1:0]
                                                | {WMB_ENTRY{sq_pop_dcache_1line_inst}}
                                                  & wmb_entry_st_hit_sq_pop_dcache_line[WMB_ENTRY-1:0]
                                                | {WMB_ENTRY{sq_pop_st_inst || sq_pop_dcache_1line_inst || sq_pop_atomic}}
                                                  & wmb_entry_dcache_inst_same_line[WMB_ENTRY-1:0];

assign wmb_pop_to_ce_permit     = wmb_sq_pop_grnt
                                  ||  !wmb_ce_vld;
// &Force("output","wmb_ce_create_vld"); @561
assign wmb_ce_create_vld        = sq_wmb_pop_to_ce_req
                                  &&  wmb_pop_to_ce_permit;
// &Force("output","wmb_ce_create_dp_vld"); @564
assign wmb_ce_create_dp_vld     = sq_wmb_pop_to_ce_dp_req
                                  &&  wmb_pop_to_ce_permit;
assign wmb_ce_create_gateclk_en = sq_wmb_pop_to_ce_gateclk_en
                                  &&  wmb_pop_to_ce_permit;

//for wmb entry
assign wmb_ce_update_same_dcache_line_ptr[WMB_ENTRY-1:0] = wmb_ce_same_dcache_line[WMB_ENTRY-1:0] 
                                                           & wmb_entry_vld[WMB_ENTRY-1:0];
assign wmb_ce_update_same_dcache_line = |wmb_ce_update_same_dcache_line_ptr[WMB_ENTRY-1:0]; 
//----------------------to sq-------------------------------
assign wmb_sq_pop_to_ce_grnt    = sq_wmb_pop_to_ce_req
                                  &&  wmb_pop_to_ce_permit;

//==========================================================
//          Generate grnt signal for wmb ce
//==========================================================
//------------------grnt signal-----------------------------
assign wmb_create_not_vld[WMB_ENTRY-1:0]    = wmb_create_ptr[WMB_ENTRY-1:0]
                                              & (~wmb_entry_vld[WMB_ENTRY-1:0]);

assign wmb_create_permit    = |wmb_create_not_vld[WMB_ENTRY-1:0];

assign wmb_create_vld       = wmb_create_permit
                              &&  wmb_ce_create_wmb_req;
assign wmb_merge_vld        = wmb_ce_merge_wmb_req;
assign wmb_entry_merge_data_vld[WMB_ENTRY-1:0]  = {WMB_ENTRY{wmb_merge_vld}}
                                                  & wmb_ce_merge_ptr[WMB_ENTRY-1:0];
assign wmb_entry_merge_data_wait_not_vld_req[WMB_ENTRY-1:0]  =
                {WMB_ENTRY{wmb_ce_merge_wmb_wait_not_vld_req}}
                & wmb_ce_merge_ptr[WMB_ENTRY-1:0];

// &Force("output","wmb_sq_pop_grnt"); @596
assign wmb_sq_pop_grnt      = wmb_create_vld
                              ||  wmb_merge_vld;
assign wmb_ce_pop_vld       = wmb_sq_pop_grnt;

//------------------create signal---------------------------
assign wmb_entry_create_vld[WMB_ENTRY-1:0]        = wmb_create_not_vld[WMB_ENTRY-1:0]
                                                    & {WMB_ENTRY{wmb_create_vld}};
assign wmb_entry_create_dp_vld[WMB_ENTRY-1:0]     = wmb_create_not_vld[WMB_ENTRY-1:0]
                                                    & {WMB_ENTRY{wmb_ce_create_wmb_dp_req}};
assign wmb_entry_create_gateclk_en[WMB_ENTRY-1:0] = wmb_create_not_vld[WMB_ENTRY-1:0]
                                                    & {WMB_ENTRY{wmb_ce_create_wmb_gateclk_en}};
assign wmb_entry_create_data_vld[WMB_ENTRY-1:0]   = wmb_create_not_vld[WMB_ENTRY-1:0]
                                                    & {WMB_ENTRY{wmb_ce_create_wmb_data_req}};

//==========================================================
//        Select signal from read/write/data ptr
//==========================================================
//-----------------read req info----------------------------wmb_entry_inst_flush
// &Force("output", "wmb_read_req_unmask"); @615
assign wmb_read_req_unmask          = |wmb_entry_read_req[WMB_ENTRY-1:0];
assign wmb_read_req_atomic              = |(wmb_read_ptr[WMB_ENTRY-1:0] & wmb_entry_atomic[WMB_ENTRY-1:0]);
assign wmb_read_req_icc             = |(wmb_read_ptr[WMB_ENTRY-1:0] & wmb_entry_icc[WMB_ENTRY-1:0]);
assign wmb_read_req_inst_is_dcache  = |(wmb_read_ptr[WMB_ENTRY-1:0] & wmb_entry_inst_is_dcache[WMB_ENTRY-1:0]);
//assign wmb_read_req_inst_type[1:0]  = {2{wmb_read_ptr[0]}}  & wmb_entry_inst_type_0[1:0]  //parameter, LTL@20241104
//                                      | {2{wmb_read_ptr[1]}}  & wmb_entry_inst_type_1[1:0]
//                                      | {2{wmb_read_ptr[2]}}  & wmb_entry_inst_type_2[1:0]
//                                      | {2{wmb_read_ptr[3]}}  & wmb_entry_inst_type_3[1:0]
//                                      | {2{wmb_read_ptr[4]}}  & wmb_entry_inst_type_4[1:0]
//                                      | {2{wmb_read_ptr[5]}}  & wmb_entry_inst_type_5[1:0]
//                                      | {2{wmb_read_ptr[6]}}  & wmb_entry_inst_type_6[1:0]
//                                      | {2{wmb_read_ptr[7]}}  & wmb_entry_inst_type_7[1:0];

always_comb begin  //parameter for wmb_read_req_inst_type, LTL@20241104
  wmb_read_req_inst_type[1:0] = 2'b0;
  for(int i=0;i<WMB_ENTRY;i++) begin
    wmb_read_req_inst_type[1:0] |= {2{wmb_read_ptr[i]}} & wmb_entry_inst_type[i][1:0];
  end
end


//assign wmb_read_req_inst_size[1:0]  = {2{wmb_read_ptr[0]}}  & wmb_entry_inst_size_0[1:0]  //parameter, LTL@20241104
//                                      | {2{wmb_read_ptr[1]}}  & wmb_entry_inst_size_1[1:0]
//                                      | {2{wmb_read_ptr[2]}}  & wmb_entry_inst_size_2[1:0]
//                                      | {2{wmb_read_ptr[3]}}  & wmb_entry_inst_size_3[1:0]
//                                      | {2{wmb_read_ptr[4]}}  & wmb_entry_inst_size_4[1:0]
//                                      | {2{wmb_read_ptr[5]}}  & wmb_entry_inst_size_5[1:0]
//                                      | {2{wmb_read_ptr[6]}}  & wmb_entry_inst_size_6[1:0]
//                                      | {2{wmb_read_ptr[7]}}  & wmb_entry_inst_size_7[1:0];
always_comb begin  //parameter for wmb_read_req_inst_size, LTL@20241104
  wmb_read_req_inst_size[1:0] = 2'b0;
  for(int i=0;i<WMB_ENTRY;i++) begin
    wmb_read_req_inst_size[1:0] |= {2{wmb_read_ptr[i]}} & wmb_entry_inst_size[i][1:0];
  end
end
//assign wmb_read_req_inst_mode[1:0]  = {2{wmb_read_ptr[0]}}  & wmb_entry_inst_mode_0[1:0]  //parameter, LTL@20241104
//                                      | {2{wmb_read_ptr[1]}}  & wmb_entry_inst_mode_1[1:0]
//                                      | {2{wmb_read_ptr[2]}}  & wmb_entry_inst_mode_2[1:0]
//                                      | {2{wmb_read_ptr[3]}}  & wmb_entry_inst_mode_3[1:0]
//                                      | {2{wmb_read_ptr[4]}}  & wmb_entry_inst_mode_4[1:0]
//                                      | {2{wmb_read_ptr[5]}}  & wmb_entry_inst_mode_5[1:0]
//                                      | {2{wmb_read_ptr[6]}}  & wmb_entry_inst_mode_6[1:0]
//                                      | {2{wmb_read_ptr[7]}}  & wmb_entry_inst_mode_7[1:0];
always_comb begin  //parameter for wmb_read_req_inst_mode, LTL@20241104
  wmb_read_req_inst_mode[1:0] = 2'b0;
  for(int i=0;i<WMB_ENTRY;i++) begin
    wmb_read_req_inst_mode[1:0] |= {2{wmb_read_ptr[i]}} & wmb_entry_inst_mode[i][1:0];
  end
end
//assign wmb_read_req_data[15:0]      = {16{wmb_read_ptr[0]}}  & wmb_entry_data_0[15:0]  //parameter, LTL@20241104
//                                      | {16{wmb_read_ptr[1]}}  & wmb_entry_data_1[15:0]
//                                      | {16{wmb_read_ptr[2]}}  & wmb_entry_data_2[15:0]
//                                      | {16{wmb_read_ptr[3]}}  & wmb_entry_data_3[15:0]
//                                      | {16{wmb_read_ptr[4]}}  & wmb_entry_data_4[15:0]
//                                      | {16{wmb_read_ptr[5]}}  & wmb_entry_data_5[15:0]
//                                      | {16{wmb_read_ptr[6]}}  & wmb_entry_data_6[15:0]
//                                      | {16{wmb_read_ptr[7]}}  & wmb_entry_data_7[15:0];
always_comb begin  //parameter for wmb_read_req_data, LTL@20241104
  wmb_read_req_data[15:0] = 16'b0;
  for(int i=0;i<WMB_ENTRY;i++) begin
    wmb_read_req_data[15:0] |= {16{wmb_read_ptr[i]}}  & wmb_entry_data[i][15:0];
  end
end
//assign wmb_read_req_priv_mode[1:0]  = {2{wmb_read_ptr[0]}}  & wmb_entry_priv_mode_0[1:0] //parameter, LTL@20241104
//                                      | {2{wmb_read_ptr[1]}}  & wmb_entry_priv_mode_1[1:0]
//                                      | {2{wmb_read_ptr[2]}}  & wmb_entry_priv_mode_2[1:0]
//                                      | {2{wmb_read_ptr[3]}}  & wmb_entry_priv_mode_3[1:0]
//                                      | {2{wmb_read_ptr[4]}}  & wmb_entry_priv_mode_4[1:0]
//                                      | {2{wmb_read_ptr[5]}}  & wmb_entry_priv_mode_5[1:0]
//                                      | {2{wmb_read_ptr[6]}}  & wmb_entry_priv_mode_6[1:0]
//                                      | {2{wmb_read_ptr[7]}}  & wmb_entry_priv_mode_7[1:0];
always_comb begin  //parameter for wmb_read_req_priv_mode, LTL@20241104
  wmb_read_req_priv_mode[1:0] = 2'b0;
  for(int i=0;i<WMB_ENTRY;i++) begin
    wmb_read_req_priv_mode[1:0] |= {2{wmb_read_ptr[i]}}  & wmb_entry_priv_mode[i][1:0];
  end
end


assign wmb_read_req_page_share      = |(wmb_read_ptr[WMB_ENTRY-1:0] & wmb_entry_page_share[WMB_ENTRY-1:0]);
assign wmb_read_req_page_sec        = |(wmb_read_ptr[WMB_ENTRY-1:0] & wmb_entry_page_sec[WMB_ENTRY-1:0]);

assign wmb_read_dp_req_next1        = |(wmb_read_ptr_next1[WMB_ENTRY-1:0] & wmb_entry_read_dp_req[WMB_ENTRY-1:0]);
//assign wmb_read_req_addr_next1[`WK_PA_WIDTH-1:0] = {`WK_PA_WIDTH{wmb_read_ptr_next1[0]}} & wmb_entry_addr_0[`WK_PA_WIDTH-1:0] //parameter, LTL@20241104
//                                                | {`WK_PA_WIDTH{wmb_read_ptr_next1[1]}} & wmb_entry_addr_1[`WK_PA_WIDTH-1:0]
//                                                | {`WK_PA_WIDTH{wmb_read_ptr_next1[2]}} & wmb_entry_addr_2[`WK_PA_WIDTH-1:0]
//                                                | {`WK_PA_WIDTH{wmb_read_ptr_next1[3]}} & wmb_entry_addr_3[`WK_PA_WIDTH-1:0]
//                                                | {`WK_PA_WIDTH{wmb_read_ptr_next1[4]}} & wmb_entry_addr_4[`WK_PA_WIDTH-1:0]
//                                                | {`WK_PA_WIDTH{wmb_read_ptr_next1[5]}} & wmb_entry_addr_5[`WK_PA_WIDTH-1:0]
//                                                | {`WK_PA_WIDTH{wmb_read_ptr_next1[6]}} & wmb_entry_addr_6[`WK_PA_WIDTH-1:0]
//                                                | {`WK_PA_WIDTH{wmb_read_ptr_next1[7]}} & wmb_entry_addr_7[`WK_PA_WIDTH-1:0];
always_comb begin  //parameter for wmb_read_req_addr_next1, LTL@20241104
  wmb_read_req_addr_next1[`WK_PA_WIDTH-1:0] = {`WK_PA_WIDTH{1'b0}};
  for(int i=0;i<WMB_ENTRY;i++) begin
    wmb_read_req_addr_next1[`WK_PA_WIDTH-1:0] |= {`WK_PA_WIDTH{wmb_read_ptr_next1[i]}}  & wmb_entry_addr[i][`WK_PA_WIDTH-1:0];
  end
end
//-----------------write req info---------------------------
assign wmb_write_imme_bypass        = |wmb_entry_write_imme_bypass[WMB_ENTRY-1:0];
assign wmb_write_imme_other_bypass  = |(wmb_entry_write_imme_bypass[WMB_ENTRY-1:0]
                                        & ~wmb_write_ptr[WMB_ENTRY-1:0]);
assign wmb_write_biu_req_unmask     = |wmb_entry_write_biu_req[WMB_ENTRY-1:0];
//assign wmb_write_dcache_req         = |wmb_entry_write_dcache_req[WMB_ENTRY-1:0];
assign wmb_write_vb_req_unmask      = |wmb_entry_write_vb_req[WMB_ENTRY-1:0];
//assign wmb_write_req_sync_fence       = |(wmb_write_ptr[WMB_ENTRY-1:0] & wmb_entry_sync_fence[WMB_ENTRY-1:0]);//origin
//assign wmb_write_req_inst_type[1:0] = {2{wmb_write_ptr[0]}}  & wmb_entry_inst_type_0[1:0]  //parameter, LTL@20241104
//                                      | {2{wmb_write_ptr[1]}}  & wmb_entry_inst_type_1[1:0]
//                                      | {2{wmb_write_ptr[2]}}  & wmb_entry_inst_type_2[1:0]
//                                      | {2{wmb_write_ptr[3]}}  & wmb_entry_inst_type_3[1:0]
//                                      | {2{wmb_write_ptr[4]}}  & wmb_entry_inst_type_4[1:0]
//                                      | {2{wmb_write_ptr[5]}}  & wmb_entry_inst_type_5[1:0]
//                                      | {2{wmb_write_ptr[6]}}  & wmb_entry_inst_type_6[1:0]
//                                      | {2{wmb_write_ptr[7]}}  & wmb_entry_inst_type_7[1:0];
always_comb begin  //parameter for wmb_write_req_inst_type, LTL@20241104
  wmb_write_req_inst_type[1:0] = 2'b0;
  for(int i=0;i<WMB_ENTRY;i++) begin
    wmb_write_req_inst_type[1:0] |= {2{wmb_write_ptr[i]}}  & wmb_entry_inst_type[i][1:0];
  end
end
//assign wmb_write_req_inst_size[2:0] = {3{wmb_write_ptr[0]}}  & wmb_entry_inst_size_0[2:0]  //parameter, LTL@20241104
//                                      | {3{wmb_write_ptr[1]}}  & wmb_entry_inst_size_1[2:0]
//                                      | {3{wmb_write_ptr[2]}}  & wmb_entry_inst_size_2[2:0]
//                                      | {3{wmb_write_ptr[3]}}  & wmb_entry_inst_size_3[2:0]
//                                      | {3{wmb_write_ptr[4]}}  & wmb_entry_inst_size_4[2:0]
//                                      | {3{wmb_write_ptr[5]}}  & wmb_entry_inst_size_5[2:0]
//                                      | {3{wmb_write_ptr[6]}}  & wmb_entry_inst_size_6[2:0]
//                                      | {3{wmb_write_ptr[7]}}  & wmb_entry_inst_size_7[2:0];
always_comb begin  //parameter for wmb_write_req_inst_size, LTL@20241104
  wmb_write_req_inst_size[2:0] = 3'b0;
  for(int i=0;i<WMB_ENTRY;i++) begin
    wmb_write_req_inst_size[2:0] |= {3{wmb_write_ptr[i]}}  & wmb_entry_inst_size[i][2:0];
  end
end


//assign wmb_write_req_inst_mode[1:0] = {2{wmb_write_ptr[0]}}  & wmb_entry_inst_mode_0[1:0]  //parameter, LTL@20241104
//                                      | {2{wmb_write_ptr[1]}}  & wmb_entry_inst_mode_1[1:0]
//                                      | {2{wmb_write_ptr[2]}}  & wmb_entry_inst_mode_2[1:0]
//                                      | {2{wmb_write_ptr[3]}}  & wmb_entry_inst_mode_3[1:0]
//                                      | {2{wmb_write_ptr[4]}}  & wmb_entry_inst_mode_4[1:0]
//                                      | {2{wmb_write_ptr[5]}}  & wmb_entry_inst_mode_5[1:0]
//                                      | {2{wmb_write_ptr[6]}}  & wmb_entry_inst_mode_6[1:0]
//                                      | {2{wmb_write_ptr[7]}}  & wmb_entry_inst_mode_7[1:0];
always_comb begin  //parameter for wmb_write_req_inst_mode, LTL@20241104
  wmb_write_req_inst_mode[1:0] = 2'b0;
  for(int i=0;i<WMB_ENTRY;i++) begin
    wmb_write_req_inst_mode[1:0] |= {2{wmb_write_ptr[i]}}  & wmb_entry_inst_mode[i][1:0];
  end
end
//assign wmb_write_req_priv_mode[1:0] = {2{wmb_write_ptr[0]}}  & wmb_entry_priv_mode_0[1:0]  //parameter, LTL@20241104
//                                      | {2{wmb_write_ptr[1]}}  & wmb_entry_priv_mode_1[1:0]
//                                      | {2{wmb_write_ptr[2]}}  & wmb_entry_priv_mode_2[1:0]
//                                      | {2{wmb_write_ptr[3]}}  & wmb_entry_priv_mode_3[1:0]
//                                      | {2{wmb_write_ptr[4]}}  & wmb_entry_priv_mode_4[1:0]
//                                      | {2{wmb_write_ptr[5]}}  & wmb_entry_priv_mode_5[1:0]
//                                      | {2{wmb_write_ptr[6]}}  & wmb_entry_priv_mode_6[1:0]
//                                      | {2{wmb_write_ptr[7]}}  & wmb_entry_priv_mode_7[1:0];
always_comb begin  //parameter for wmb_write_req_priv_mode, LTL@20241104
  wmb_write_req_priv_mode[1:0] = 2'b0;
  for(int i=0;i<WMB_ENTRY;i++) begin
    wmb_write_req_priv_mode[1:0] |= {2{wmb_write_ptr[i]}}  & wmb_entry_priv_mode[i][1:0];
  end
end
//assign wmb_write_req_page_share     = |(wmb_write_ptr[WMB_ENTRY-1:0] & wmb_entry_page_share[WMB_ENTRY-1:0]);
assign wmb_write_req_page_so        = |(wmb_write_ptr[WMB_ENTRY-1:0] & wmb_entry_page_so[WMB_ENTRY-1:0]);
//assign wmb_write_req_page_ca        = |(wmb_write_ptr[WMB_ENTRY-1:0] & wmb_entry_page_ca[WMB_ENTRY-1:0]);
assign wmb_write_req_page_wa        = |(wmb_write_ptr[WMB_ENTRY-1:0] & wmb_entry_page_wa[WMB_ENTRY-1:0]);
assign wmb_write_req_page_buf       = |(wmb_write_ptr[WMB_ENTRY-1:0] & wmb_entry_page_buf[WMB_ENTRY-1:0]);
assign wmb_write_req_page_sec       = |(wmb_write_ptr[WMB_ENTRY-1:0] & wmb_entry_page_sec[WMB_ENTRY-1:0]);
assign wmb_write_biu_dp_req_next1   = |(wmb_write_ptr_next[1][WMB_ENTRY-1:0] & wmb_entry_write_biu_dp_req[WMB_ENTRY-1:0]);
assign wmb_write_req_atomic_next1   = |(wmb_write_ptr_next[1][WMB_ENTRY-1:0] & wmb_entry_atomic_and_vld[WMB_ENTRY-1:0]);
assign wmb_write_req_icc_next1      = |(wmb_write_ptr_next[1][WMB_ENTRY-1:0] & wmb_entry_icc_and_vld[WMB_ENTRY-1:0]);

assign wmb_write_req_sync_fence_next1 = |(wmb_write_ptr_next[1][WMB_ENTRY-1:0] & wmb_entry_sync_fence[WMB_ENTRY-1:0]);
assign wmb_write_req_page_ca_next1    = |(wmb_write_ptr_next[1][WMB_ENTRY-1:0] & wmb_entry_page_ca[WMB_ENTRY-1:0]);
assign wmb_write_req_page_share_next1 = |(wmb_write_ptr_next[1][WMB_ENTRY-1:0] & wmb_entry_page_share[WMB_ENTRY-1:0]);
//assign wmb_write_req_addr_next1[`WK_PA_WIDTH-1:0]  = {`WK_PA_WIDTH{wmb_write_ptr_next1[0]}} & wmb_entry_addr_0[`WK_PA_WIDTH-1:0]   //parameter, LTL@20241104
//                                                  | {`WK_PA_WIDTH{wmb_write_ptr_next1[1]}} & wmb_entry_addr_1[`WK_PA_WIDTH-1:0]
//                                                  | {`WK_PA_WIDTH{wmb_write_ptr_next1[2]}} & wmb_entry_addr_2[`WK_PA_WIDTH-1:0]
//                                                  | {`WK_PA_WIDTH{wmb_write_ptr_next1[3]}} & wmb_entry_addr_3[`WK_PA_WIDTH-1:0]
//                                                  | {`WK_PA_WIDTH{wmb_write_ptr_next1[4]}} & wmb_entry_addr_4[`WK_PA_WIDTH-1:0]
//                                                  | {`WK_PA_WIDTH{wmb_write_ptr_next1[5]}} & wmb_entry_addr_5[`WK_PA_WIDTH-1:0]
//                                                  | {`WK_PA_WIDTH{wmb_write_ptr_next1[6]}} & wmb_entry_addr_6[`WK_PA_WIDTH-1:0]
//                                                  | {`WK_PA_WIDTH{wmb_write_ptr_next1[7]}} & wmb_entry_addr_7[`WK_PA_WIDTH-1:0];
always_comb begin  //parameter for wmb_write_req_addr_next1, LTL@20241104
  wmb_write_req_addr_next1[`WK_PA_WIDTH-1:0] = {`WK_PA_WIDTH{1'b0}};
  for(int i=0;i<WMB_ENTRY;i++) begin
    wmb_write_req_addr_next1[`WK_PA_WIDTH-1:0] |= {`WK_PA_WIDTH{wmb_write_ptr_next[1][i]}}  & wmb_entry_addr[i][`WK_PA_WIDTH-1:0];
  end
end
//-----------------------inst type--------------------------
assign wmb_write_req_st_inst        = !wmb_write_req_atomic
                                      &&  !wmb_write_req_sync_fence
                                      &&  !wmb_write_req_icc;
assign wmb_write_req_stex_inst      = wmb_write_req_atomic;

//for write dcache_line check
assign wmb_write_req_ready_to_dcache_line       = |(wmb_write_ptr[WMB_ENTRY-1:0]
                                                    & wmb_entry_ready_to_dcache_line[WMB_ENTRY-1:0]);
assign wmb_write_req_next1_ready_to_dcache_line = |(wmb_write_ptr_next[1][WMB_ENTRY-1:0]
                                                    & wmb_entry_ready_to_dcache_line[WMB_ENTRY-1:0]);
assign wmb_write_req_next2_ready_to_dcache_line = |(wmb_write_ptr_next[2][WMB_ENTRY-1:0]
                                                    & wmb_entry_ready_to_dcache_line[WMB_ENTRY-1:0]);
assign wmb_write_req_next3_ready_to_dcache_line = |(wmb_write_ptr_next[3][WMB_ENTRY-1:0]
                                                    & wmb_entry_ready_to_dcache_line[WMB_ENTRY-1:0]);

//addr plus or sub
assign wmb_write_req_next1_addr_plus = |(wmb_write_ptr_next[1][WMB_ENTRY-1:0]
                                         & wmb_entry_last_addr_plus[WMB_ENTRY-1:0]);
assign wmb_write_req_next2_addr_plus = |(wmb_write_ptr_next[2][WMB_ENTRY-1:0]
                                         & wmb_entry_last_addr_plus[WMB_ENTRY-1:0]);
assign wmb_write_req_next3_addr_plus = |(wmb_write_ptr_next[3][WMB_ENTRY-1:0]
                                         & wmb_entry_last_addr_plus[WMB_ENTRY-1:0]);

assign wmb_write_req_next1_addr_sub  = |(wmb_write_ptr_next[1][WMB_ENTRY-1:0]
                                          & wmb_entry_last_addr_sub[WMB_ENTRY-1:0]);
assign wmb_write_req_next2_addr_sub  = |(wmb_write_ptr_next[2][WMB_ENTRY-1:0]
                                          & wmb_entry_last_addr_sub[WMB_ENTRY-1:0]);
assign wmb_write_req_next3_addr_sub  = |(wmb_write_ptr_next[3][WMB_ENTRY-1:0]
                                         & wmb_entry_last_addr_sub[WMB_ENTRY-1:0]);

assign wmb_write_req_page_nc_atomic     = !wmb_write_req_page_ca  &&  wmb_write_req_atomic;
//-----------------data req info----------------------------
assign wmb_data_biu_req             = |wmb_entry_data_biu_req[WMB_ENTRY-1:0];
assign wmb_data_req_wns             = |wmb_entry_data_req_wns[WMB_ENTRY-1:0];
//assign wmb_data_req_biu_id[4:0]     = {5{wmb_data_ptr[0]}}  & wmb_entry_biu_id_0[4:0]   //parameter, LTL@20241104
//                                      | {5{wmb_data_ptr[1]}}  & wmb_entry_biu_id_1[4:0]
//                                      | {5{wmb_data_ptr[2]}}  & wmb_entry_biu_id_2[4:0]
//                                      | {5{wmb_data_ptr[3]}}  & wmb_entry_biu_id_3[4:0]
//                                      | {5{wmb_data_ptr[4]}}  & wmb_entry_biu_id_4[4:0]
//                                      | {5{wmb_data_ptr[5]}}  & wmb_entry_biu_id_5[4:0]
//                                      | {5{wmb_data_ptr[6]}}  & wmb_entry_biu_id_6[4:0]
//                                      | {5{wmb_data_ptr[7]}}  & wmb_entry_biu_id_7[4:0];
always_comb begin  //parameter for wmb_data_req_biu_id, LTL@20241104
  wmb_data_req_biu_id[4:0] = 5'b0;
  for(int i=0;i<WMB_ENTRY;i++) begin
    wmb_data_req_biu_id[4:0] |= {5{wmb_data_ptr[i]}}  & wmb_entry_biu_id[i][4:0];
  end
end
// &CombBeg; @786
//always @( wmb_data_ptr[7:0]             //wmb_data_ptr, at most one value is 1, LTL@20241024
//       or wmb_entry_data_1[127:0]       //when parameter, no need find first value 1, LTL@20241024
//       or wmb_entry_data_2[127:0]
//       or wmb_entry_data_0[127:0]
//       or wmb_entry_data_4[127:0]
//       or wmb_entry_data_3[127:0]
//       or wmb_entry_data_7[127:0]
//       or wmb_entry_data_5[127:0]
//       or wmb_entry_data_6[127:0])
//begin
//case(wmb_data_ptr[7:0])
//  8'h01:  wmb_data_req_data[127:0] = wmb_entry_data_0[127:0];
//  8'h02:  wmb_data_req_data[127:0] = wmb_entry_data_1[127:0];
//  8'h04:  wmb_data_req_data[127:0] = wmb_entry_data_2[127:0];
//  8'h08:  wmb_data_req_data[127:0] = wmb_entry_data_3[127:0];
//  8'h10:  wmb_data_req_data[127:0] = wmb_entry_data_4[127:0];
//  8'h20:  wmb_data_req_data[127:0] = wmb_entry_data_5[127:0];
//  8'h40:  wmb_data_req_data[127:0] = wmb_entry_data_6[127:0];
//  8'h80:  wmb_data_req_data[127:0] = wmb_entry_data_7[127:0];
//  default:wmb_data_req_data[127:0] = {128{1'bx}};
//endcase
//end
always_comb begin  //parameter for wmb_data_req_data, LTL@20241104
  wmb_data_req_data[127:0] = 128'b0;
  for(int i=0;i<WMB_ENTRY;i++) begin
    wmb_data_req_data[127:0] |= {128{wmb_data_ptr[i]}}  & wmb_entry_data[i][127:0];
  end
end


//assign wmb_data_req_bytes_vld[15:0] = {16{wmb_data_ptr[0]}} & wmb_entry_bytes_vld_0[15:0]  //parameter, LTL@20241104
//                                      | {16{wmb_data_ptr[1]}} & wmb_entry_bytes_vld_1[15:0]
//                                      | {16{wmb_data_ptr[2]}} & wmb_entry_bytes_vld_2[15:0]
//                                      | {16{wmb_data_ptr[3]}} & wmb_entry_bytes_vld_3[15:0]
//                                      | {16{wmb_data_ptr[4]}} & wmb_entry_bytes_vld_4[15:0]
//                                      | {16{wmb_data_ptr[5]}} & wmb_entry_bytes_vld_5[15:0]
//                                      | {16{wmb_data_ptr[6]}} & wmb_entry_bytes_vld_6[15:0]
//                                      | {16{wmb_data_ptr[7]}} & wmb_entry_bytes_vld_7[15:0];
always_comb begin  //parameter for wmb_data_req_bytes_vld, LTL@20241104
  wmb_data_req_bytes_vld[15:0] = 16'b0;
  for(int i=0;i<WMB_ENTRY;i++) begin
    wmb_data_req_bytes_vld[15:0] |= {16{wmb_data_ptr[i]}}  & wmb_entry_bytes_vld[i][15:0];
  end
end
assign wmb_data_req_w_last = |(wmb_data_ptr[WMB_ENTRY-1:0] & wmb_entry_w_last[WMB_ENTRY-1:0]);

//==========================================================
//              write imme signal pop entry
//==========================================================
//wmb vld                                 mechanism
//<=5                                     write leisure(!ld_ag && !st_ag)
//>=6                                     write imme
//                                        if (st_ag && st_rf),
//                                        then write 2 cycle
//amr and >=4                             write amr
//-----------------------registers--------------------------
//if wmb too full and must write dcache, and st_ag/rf has inst, then write
//2 cycle to reduce st out of order
always @(posedge wmb_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    wmb_write_imme_hold <=  1'b0;
  else if(wmb_write_imme_hold_set)
    wmb_write_imme_hold <=  1'b1;
  else
    wmb_write_imme_hold <=  1'b0;
end

//if sq pop write imme, then wmb_write_imme set immediately
always @(posedge wmb_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    wmb_write_imme    <=  1'b0;
  else if(wmb_create_write_imme_set ||  wmb_write_imme_other_bypass)
    wmb_write_imme    <=  1'b1;
  else if(wmb_write_imme_amr_clr || wmb_write_imme_clr)
    wmb_write_imme    <=  1'b0;
  else if(wmb_write_imme_set)
    wmb_write_imme    <=  1'b1;
end

//------------------------signals---------------------------
assign wmb_write_imme_hold_set  = !wmb_write_imme_hold
                                  &&  !wmb_write_imme_amr_clr
                                  &&  !wmb_write_imme_clr
                                  &&  wmb_write_imme_bypass //entry >= 6
                                  //&&  (lsag0_rf_inst_vld && !idu_lsu2_rf_is_load)
                                  //&&  (lsag0_ex1_inst_vld && !lsag0_ex1_is_load);
                                  &&  ((lsag0_rf_inst_vld && !idu_lsu2_rf_is_load)   //st_rf_inst_vld 1->2, hold wmb write imme ??? , LTL@20241114
                                         &&  (lsag0_ex1_inst_vld && !lsag0_ex1_is_load)  //st_ag_inst_vld 1->2, hold wmb write imme, LTL@20241114
                                        ||  (lsag1_rf_inst_vld && !idu_lsu3_rf_is_load) 
                                            &&  (lsag1_ex1_inst_vld && !lsag1_ex1_is_load));//may cause out of order

assign wmb_create_write_imme_set  = wmb_ce_create_wmb_req  &&  wmb_ce_write_imme;
assign wmb_write_imme_set = icc_wmb_write_imme
                            ||  cp0_lsu_no_op_req
                            ||  sq_wmb_write_imme
                            ||  wmb_write_imme_bypass
                            ||  wmb_write_imme_hold
                            ||  !wmb_write_imme
                                &&  wmb_write_imme_ori;

assign wmb_write_imme_ori     = |wmb_entry_write_imme[WMB_ENTRY-1:0];
assign wmb_other_write_imme   = |(~wmb_write_ptr[WMB_ENTRY-1:0] & wmb_entry_write_imme[WMB_ENTRY-1:0]);
assign wmb_other4_write_imme  = |(~wmb_write_ptr_to_next3[WMB_ENTRY-1:0] & wmb_entry_write_imme[WMB_ENTRY-1:0]);

assign wmb_write_imme_amr_clr = !wmb_other4_write_imme
                                &&  wmb_mem_set_write_grnt;

assign wmb_write_imme_clr     = !wmb_other_write_imme
                                    &&  !wmb_write_imme_hold
                                    &&  wmb_write_ptr_shift_vld
                                ||  wmb_empty;

assign wmb_write_dcache_permit= wmb_write_imme
                                ||  (!lsag0_ex1_inst_vld && !lsag1_ex1_inst_vld  //!ld_ag_inst_vld&&!st_ag_inst_vld, ask lishuo, ??? LTL@20241104
                                    &&  !lag0_ex1_inst_vld); //whether wmb borrow fix lda0 st0 or lda1 st1,  ??? LTL@20241021

//==========================================================
//            generate reset_read_ptr_req logic
//==========================================================
//if (wmb_reset_read_ptr_req_ff && wmb_ctc_secd)
//  then wmb_reset_read_ptr_req_ff hold, and send read req
//else if (wmb_reset_read_ptr_req_ff && !wmb_ctc_secd)
//  then wmb_reset_read_ptr_req_ff clear, and do not send read req
//--------------------reset_ptr_req_ff----------------------
//no need anymore
//==========================================================
//                last create pop entry
//==========================================================
//used for write burst
always @(posedge wmb_create_ptr_clk)
begin
  if(wmb_create_vld)
    wmb_last_create_addr[`WK_PA_WIDTH-1:0]   <=  wmb_ce_addr[`WK_PA_WIDTH-1:0];
end
//---------------------entry create signal------------------------
assign wmb_ce_last_addr_eq_high = (wmb_ce_addr[`WK_PA_WIDTH-1:6] == wmb_last_create_addr[`WK_PA_WIDTH-1:6]);

assign wmb_last_addr_plus[1:0] = wmb_last_create_addr[5:4] + 2'd1;
assign wmb_last_addr_sub[1:0]  = wmb_last_create_addr[5:4] - 2'd1;

assign wmb_ce_last_addr_plus = wmb_ce_last_addr_eq_high
                               && (wmb_ce_addr[5:4] == wmb_last_addr_plus[1:0]);
assign wmb_ce_last_addr_sub  = wmb_ce_last_addr_eq_high
                               && (wmb_ce_addr[5:4] == wmb_last_addr_sub[1:0]);

//==========================================================
//                Read ptr pop entry
//==========================================================
//+-------------+
//| read_dp_req |
//+-------------+
always @(posedge wmb_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    wmb_read_dp_req           <=  1'b0;
  else if(wmb_empty &&  !wmb_ce_vld)
    wmb_read_dp_req           <=  1'b0;
  else if(dcache_vb_snq_gwen)
    wmb_read_dp_req           <=  1'b1;
  else if(wmb_read_pop_up_wmb_ce_vld)
    wmb_read_dp_req           <=  wmb_ce_read_dp_req;
  else if(wmb_read_ptr_next1_met_create &&  wmb_read_ptr_shift_vld)
    wmb_read_dp_req           <=  1'b0;
  else if(wmb_read_ptr_shift_vld)
    wmb_read_dp_req           <=  wmb_read_dp_req_next1;
end

//+---------------+
//| read_req_addr |
//+---------------+
// &Force("output","wmb_read_req_addr"); @933
always @(posedge wmb_read_pop_clk)
begin
  if(wmb_read_pop_up_wmb_ce_vld)
    wmb_read_req_addr[`WK_PA_WIDTH-1:0]   <=  wmb_ce_addr[`WK_PA_WIDTH-1:0];
  else if(wmb_read_ptr_shift_vld)
    wmb_read_req_addr[`WK_PA_WIDTH-1:0]   <=  wmb_read_req_addr_next1[`WK_PA_WIDTH-1:0];
end

//---------------------update signal------------------------
assign wmb_read_ptr_next1_met_create  = wmb_create_ptr[WMB_ENTRY-1:0]
                                        ==  wmb_read_ptr_next1[WMB_ENTRY-1:0];

assign wmb_read_pop_up_wmb_ce_vld     = wmb_ce_create_wmb_dp_req
                                        &&  (wmb_read_ptr_met_create
                                            ||  wmb_read_ptr_next1_met_create
                                                &&  wmb_read_ptr_shift_vld);

//for same_dcache_line
assign wmb_same_line_resp_ready[WMB_ENTRY-1:0] = wmb_entry_read_resp_ready[WMB_ENTRY-1:0]; 
//==========================================================
//                Write ptr pop entry
//==========================================================
//+------------------+
//| write_biu_dp_req |
//+------------------+
always @(posedge wmb_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    wmb_write_biu_dp_req      <=  1'b0;
  else if(wmb_empty &&  !wmb_ce_vld)
    wmb_write_biu_dp_req      <=  1'b0;
  else if(dcache_vb_snq_gwen || wmb_write_dcache_req_icc_inst)
    wmb_write_biu_dp_req      <=  1'b1;
  else if(wmb_write_pop_up_wmb_ce_vld)
    wmb_write_biu_dp_req      <=  wmb_ce_write_biu_dp_req;
  else if(wmb_mem_set_write_grnt)
    wmb_write_biu_dp_req      <=  1'b1;
  else if(wmb_write_ptr_shift_vld)
    wmb_write_biu_dp_req      <=  wmb_write_biu_dp_req_next1;
end

//+----------------+
//| write_pop_addr |
//+----------------+
// &Force("output","wmb_write_req_addr"); @978
// &Force("output","wmb_write_req_icc"); @979
// //&Force("output","wmb_write_req_atomic"); @980
always @(posedge wmb_write_pop_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    wmb_write_req_atomic              <=  1'b0;
    wmb_write_req_icc                 <=  1'b0;
    wmb_write_req_sync_fence          <=  1'b0;
    wmb_write_req_page_ca             <=  1'b0;
    wmb_write_req_page_share          <=  1'b0;
  end
  else
  begin
    wmb_write_req_atomic              <=  wmb_write_req_atomic_set;
    wmb_write_req_icc                 <=  wmb_write_req_icc_set;
    wmb_write_req_sync_fence          <=  wmb_write_req_sync_fence_set;
    wmb_write_req_page_ca             <=  wmb_write_req_page_ca_set;
    wmb_write_req_page_share          <=  wmb_write_req_page_share_set;
  end
end

always @(posedge wmb_write_pop_clk)
begin
    wmb_write_req_addr[`WK_PA_WIDTH-1:0] <=  wmb_write_req_addr_set[`WK_PA_WIDTH-1:0];
end

// &CombBeg; @1006
always @( wmb_write_pop_up_wmb_ce_vld
       or wmb_write_req_addr_next1[`WK_PA_WIDTH-1:0]
       or wmb_write_req_page_share_next1
       or wmb_ce_icc
       or wmb_write_req_atomic_next1
       or wmb_write_ptr_shift_vld
       or wmb_write_req_sync_fence_next1
       or wmb_write_req_addr[`WK_PA_WIDTH-1:0]
       or wmb_write_req_page_share
       or wmb_ce_page_share
       or wmb_write_req_page_ca
       or wmb_write_req_sync_fence
       or wmb_ce_atomic
       or wmb_write_req_icc_next1
       or wmb_write_req_atomic
       or wmb_write_req_icc
       or wmb_ce_page_ca
       or wmb_write_req_page_ca_next1
       or wmb_ce_addr[`WK_PA_WIDTH-1:0]
       or wmb_ce_sync_fence)
begin
if(wmb_write_pop_up_wmb_ce_vld)
begin
  wmb_write_req_atomic_set              = wmb_ce_atomic;
  wmb_write_req_icc_set                 = wmb_ce_icc;
  wmb_write_req_sync_fence_set          = wmb_ce_sync_fence;
  wmb_write_req_page_ca_set             = wmb_ce_page_ca;
  wmb_write_req_page_share_set          = wmb_ce_page_share;
  wmb_write_req_addr_set[`WK_PA_WIDTH-1:0] = wmb_ce_addr[`WK_PA_WIDTH-1:0];
end
else if(wmb_write_ptr_shift_vld)
begin
  wmb_write_req_atomic_set              = wmb_write_req_atomic_next1;
  wmb_write_req_icc_set                 = wmb_write_req_icc_next1;
  wmb_write_req_sync_fence_set          = wmb_write_req_sync_fence_next1;
  wmb_write_req_page_ca_set             = wmb_write_req_page_ca_next1;
  wmb_write_req_page_share_set          = wmb_write_req_page_share_next1;
  wmb_write_req_addr_set[`WK_PA_WIDTH-1:0] = wmb_write_req_addr_next1[`WK_PA_WIDTH-1:0];
end
else
begin
  wmb_write_req_atomic_set              = wmb_write_req_atomic;
  wmb_write_req_icc_set                 = wmb_write_req_icc;
  wmb_write_req_sync_fence_set          = wmb_write_req_sync_fence;
  wmb_write_req_page_ca_set             = wmb_write_req_page_ca;
  wmb_write_req_page_share_set          = wmb_write_req_page_share;
  wmb_write_req_addr_set[`WK_PA_WIDTH-1:0] = wmb_write_req_addr[`WK_PA_WIDTH-1:0];
end
// &CombEnd; @1034
end

//---------------------update signal------------------------
assign wmb_write_ptr_next1_met_create = wmb_create_ptr[WMB_ENTRY-1:0]
                                        ==  wmb_write_ptr_next[1][WMB_ENTRY-1:0];

assign wmb_write_pop_up_wmb_ce_vld    = wmb_ce_create_wmb_dp_req
                                        &&  (wmb_write_ptr_met_create
                                            ||  wmb_write_ptr_next1_met_create
                                                &&  wmb_write_ptr_shift_vld);

assign wmb_write_pop_up_wmb_ce_gateclk_en = wmb_ce_create_wmb_gateclk_en
                                            &&  (wmb_write_ptr_met_create
                                                ||  wmb_write_ptr_next1_met_create);

//==========================================================
//        Request biu ar channel(include ctc request)
//==========================================================
//----------------------hit_idx-----------------------------
assign wmb_read_req_hit_idx = snq_create_wmb_read_req_hit_idx
                                  && !lm_state_is_amo_lock
                              ||  snq_wmb_read_req_hit_idx
                              ||  lfb_wmb_read_req_hit_idx;
//-----------------ctc register-----------------------------
always @(posedge wmb_read_ptr_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    wmb_ctc_secd      <=  1'b0;
  else if(wmb_read_req_ctc_inst &&  !wmb_read_req_ctc_end  &&  bus_arb_wmb_ar_grnt)
    wmb_ctc_secd      <=  1'b1;
  else if(bus_arb_wmb_ar_grnt)
    wmb_ctc_secd      <=  1'b0;
end

//-----------------ctc end singal-----------------------------
assign wmb_read_req_ctc_end = !wmb_biu_ar_addr[0];
//-----------------inst type--------------------------------
assign wmb_read_req_dcache_l1_inst  = !wmb_read_req_atomic
                                      &&  wmb_read_req_icc
                                      &&  wmb_read_req_inst_is_dcache
                                      &&  wmb_read_req_inst_mode[0] //va or pa
                                      &&  (wmb_read_req_inst_size[1:0] ==  2'b00);
assign wmb_read_req_dcache_inv_inst = !wmb_read_req_atomic
                                      &&  wmb_read_req_icc
                                      &&  wmb_read_req_inst_is_dcache
                                      &&  wmb_read_req_inst_size[1];
assign wmb_read_req_ctc_inst        = !wmb_read_req_atomic
                                      &&  wmb_read_req_icc
                                      &&  (wmb_read_req_inst_type[1:0]  !=  2'b10);
assign wmb_read_req_tlbi_inst       = !wmb_read_req_atomic
                                      &&  wmb_read_req_icc
                                      &&  (wmb_read_req_inst_type[1:0]  ==  2'b00);
assign wmb_read_req_tlbi_asid_inst  = wmb_read_req_tlbi_inst
                                      &&  wmb_read_req_inst_mode[0];
assign wmb_read_req_tlbi_va_inst    = wmb_read_req_tlbi_inst
                                      &&  wmb_read_req_inst_mode[1];
assign wmb_read_req_icache_inst     = !wmb_read_req_atomic
                                      &&  wmb_read_req_icc
                                      &&  (wmb_read_req_inst_type[1:0]  ==  2'b01);
assign wmb_read_req_icache_all_inst = wmb_read_req_icache_inst
                                      &&  (wmb_read_req_inst_mode[1:0]  ==  2'b00);
assign wmb_read_req_l2cache_inst    = !wmb_read_req_atomic
                                      &&  wmb_read_req_icc
                                      &&  (wmb_read_req_inst_type[1:0]  ==  2'b11);
//-----------------interface to bus_arb---------------------
assign wmb_biu_ar_req           = wmb_read_req_unmask
                                  &&  (!wmb_read_req_hit_idx
                                      ||  wmb_read_req_ctc_inst);
assign wmb_biu_ar_dp_req        = wmb_read_req_unmask;
assign wmb_biu_ar_req_gateclk_en  = wmb_read_dp_req;
// &Force("output","wmb_biu_ar_id"); @1104
assign wmb_biu_ar_id[4:0]       = wmb_read_req_ctc_inst
                                  ? BIU_R_CTC_ID
                                  : {BIU_R_NORM_ID_T,wmb_read_ptr_encode[2:0]};

//-----------------addr-----------------
assign wmb_biu_ar_tlbi_first_addr[`WK_PA_WIDTH-1:0]  =
               {8'b0,                               // 47:40
                wmb_read_req_data[15:8],            //ASID[15:8]    39:32
                8'b0,                               //              
                wmb_read_req_data[7:0],             //ASID[7:0]     23:16
                1'b0,                               //              15
                3'b000,                             //TLBI          14:12
                2'b10,                              //Guest?        11:10
                2'b11,                              //non-sec       9:8
                1'b0,                               //              7
                wmb_read_req_tlbi_va_inst           //`WK_PA_WIDTH-1:24 not vld 6
                | wmb_read_req_tlbi_asid_inst,                               
                wmb_read_req_tlbi_asid_inst,        //23:16 vld     5
                4'b0,                               //              4:1
                wmb_read_req_tlbi_va_inst};         //need secd     0

assign wmb_biu_ar_tlbi_secd_addr[`WK_PA_WIDTH-1:0]  =
                {wmb_read_req_addr[`WK_PA_WIDTH-1:4],  //VA            PA_WIDTH-1:4
                3'b0,                               //              3:1
                1'b0};                              //end           0

assign wmb_biu_ar_icache_first_addr[`WK_PA_WIDTH-1:0]  =
               {32'b0,                              //            PA_WIDTH-1:16
                1'b0,                               //              15
                3'b010,                             //ICACHEI       14:12
                2'b00,                              //Guest?        11:10
                2'b11,                               //              9:8
                1'b0,                               //              7
                2'b0,                               //              6:5
                4'b0,                               //              4:1
                !wmb_read_req_icache_all_inst};     //need secd?    0

assign wmb_biu_ar_icache_secd_addr[`WK_PA_WIDTH-1:0]   = 
                {wmb_read_req_addr[`WK_PA_WIDTH-1:4],  //VA            PA_WIDTH-1:4
                3'b0,                               //              3:1
                1'b0};                              //end           0

assign wmb_biu_ar_l2cache_first_addr[`WK_PA_WIDTH-1:0] =
                {{`WK_PA_WIDTH-24{1'b0}},              //              PA_WIDTH-1:24
                6'b0,                               //              23:18
                wmb_read_req_inst_size[0],          //CLEAR         17
                wmb_read_req_inst_size[1],          //INV           16
                1'b0,                               //              15
                3'b111,                             //L2CACHE       14:12
                2'b10,                              //Guest?        11:10
                2'b11,                              //non-sec       9:8
                1'b0,                               //              7
                1'b0,                               //PA_WIDTH-1:24 not vld 6
                1'b0,                               //23:16 not vld 5
                4'b0,                               //              4:1
                1'b0};                              //end           0
                                          
assign wmb_biu_ar_addr_judge[3:0]     = {wmb_ctc_secd,
                                        wmb_read_req_tlbi_inst,
                                        wmb_read_req_icache_inst,
                                        wmb_read_req_l2cache_inst};

// &Force("output","wmb_biu_ar_addr"); @1166
// &CombBeg; @1167
always @( wmb_read_req_addr[`WK_PA_WIDTH-1:6]
       or wmb_biu_ar_tlbi_first_addr[`WK_PA_WIDTH-1:0]
       or wmb_biu_ar_icache_first_addr[`WK_PA_WIDTH-1:0]
       or wmb_biu_ar_icache_secd_addr[`WK_PA_WIDTH-1:0]
       or wmb_biu_ar_l2cache_first_addr[`WK_PA_WIDTH-1:0]
       or wmb_biu_ar_tlbi_secd_addr[`WK_PA_WIDTH-1:0]
       or wmb_biu_ar_addr_judge[3:0])
begin
wmb_biu_ar_addr[`WK_PA_WIDTH-1:0] = {wmb_read_req_addr[`WK_PA_WIDTH-1:6],6'b0};
casez(wmb_biu_ar_addr_judge[3:0])
  4'b0100:wmb_biu_ar_addr[`WK_PA_WIDTH-1:0] = wmb_biu_ar_tlbi_first_addr[`WK_PA_WIDTH-1:0];
  4'b1100:wmb_biu_ar_addr[`WK_PA_WIDTH-1:0] = wmb_biu_ar_tlbi_secd_addr[`WK_PA_WIDTH-1:0];
  4'b0010:wmb_biu_ar_addr[`WK_PA_WIDTH-1:0] = wmb_biu_ar_icache_first_addr[`WK_PA_WIDTH-1:0];
  4'b1010:wmb_biu_ar_addr[`WK_PA_WIDTH-1:0] = wmb_biu_ar_icache_secd_addr[`WK_PA_WIDTH-1:0];
  4'b0001:wmb_biu_ar_addr[`WK_PA_WIDTH-1:0] = wmb_biu_ar_l2cache_first_addr[`WK_PA_WIDTH-1:0];
  default:wmb_biu_ar_addr[`WK_PA_WIDTH-1:0] = {wmb_read_req_addr[`WK_PA_WIDTH-1:6],6'b0};
endcase
// &CombEnd; @1177
end

//-----------------others-----------------
//ctc   : 1
//other : 3
assign wmb_biu_ar_len[1:0]      = wmb_read_req_ctc_inst
                                  ? 2'b00
                                  : 2'b01;
//128 bits
assign wmb_biu_ar_size[2:0]     = 3'b101;
//increase
assign wmb_biu_ar_burst[1:0]    = 2'b01;
//not exclusive
assign wmb_biu_ar_lock          = 1'b0;

//ctc 0010
//dcache.l1 0011
//others 1111
// &CombBeg; @1195
always @( wmb_read_req_dcache_l1_inst
       or wmb_read_req_ctc_inst)
begin
wmb_biu_ar_cache[3:0] = 4'b1111;
case({wmb_read_req_ctc_inst,wmb_read_req_dcache_l1_inst})
  2'b10:wmb_biu_ar_cache[3:0] = 4'b0010;
  2'b01:wmb_biu_ar_cache[3:0] = 4'b0011;
  default:wmb_biu_ar_cache[3:0] = 4'b1111;
endcase
// &CombEnd; @1202
end

assign wmb_biu_ar_prot[2:0]     = {1'b0,
                                  wmb_read_req_page_sec,
                                  wmb_read_req_priv_mode[0]};
assign wmb_biu_ar_user[3:0]     = {wmb_read_req_page_share,
                                  1'b0,
                                  wmb_read_req_priv_mode[1],
                                  1'b0};

//-----------------snoop----------------
//st cleanunique 1011
//dcache only clr cleanshared  1000
//dcache only clr l1 cleanshared  1000
//dcache clr inv  cleaninvalid 1001
//dcache only inv makeinvalid  1101
//ctc 1111
// &CombBeg; @1219
always @( wmb_read_req_icc
       or wmb_read_req_inst_size[1:0]
       or wmb_read_req_atomic
       or wmb_read_req_inst_type[1:0])
begin
wmb_biu_ar_snoop[3:0] = 4'b1011;
casez({wmb_read_req_atomic,wmb_read_req_icc,wmb_read_req_inst_type[1:0],wmb_read_req_inst_size[1:0]})
  {1'b0,1'b1,2'b10,2'b01}:wmb_biu_ar_snoop[3:0]  = 4'b1000;//CleanShared
  {1'b0,1'b1,2'b10,2'b00}:wmb_biu_ar_snoop[3:0]  = 4'b1000;//CleanShared
  {1'b0,1'b1,2'b10,2'b10}:wmb_biu_ar_snoop[3:0]  = 4'b1101;//MakeInvalid
  {1'b0,1'b1,2'b10,2'b11}:wmb_biu_ar_snoop[3:0]  = 4'b1001;//CleanInvalid
  {1'b0,1'b1,2'b00,2'b??}:wmb_biu_ar_snoop[3:0]  = 4'b1111;//CTC
  {1'b0,1'b1,2'b01,2'b??}:wmb_biu_ar_snoop[3:0]  = 4'b1111;
  {1'b0,1'b1,2'b11,2'b??}:wmb_biu_ar_snoop[3:0]  = 4'b1111;
  default:wmb_biu_ar_snoop[3:0] = 4'b1011;
endcase
// &CombEnd; @1231
end

assign wmb_biu_ar_domain[1:0]   = 2'b01;
assign wmb_biu_ar_bar[1:0]      = 2'b0;

//==========================================================
//                    Request dcache
//==========================================================
//-----------------dcache req ptr---------------------------
assign wmb_write_dcache_pop_up = wmb_write_dcache_success 
                                 || !wmb_write_dcache_pop_req 
                                    && wmb_dcache_req_next; 

assign wmb_dcache_req_ptr[WMB_ENTRY-1:0] = {WMB_ENTRY{wmb_write_dcache_pop_req}} & wmb_write_dcache_ptr[WMB_ENTRY-1:0];
assign wmb_dcache_req_set[WMB_ENTRY-1:0] = wmb_entry_write_dcache_req[WMB_ENTRY-1:0] & ~wmb_dcache_req_ptr[WMB_ENTRY-1:0];

assign wmb_dcache_req_next = |wmb_dcache_req_set[WMB_ENTRY-1:0];                

always @(posedge wmb_write_dcache_pop_clk or negedge cpurst_b)
begin
    if(!cpurst_b)
    wmb_write_dcache_pop_req  <=  1'b0; 
    else if(wmb_write_dcache_pop_up)
    wmb_write_dcache_pop_req  <=  wmb_dcache_req_next; 
end

always @(posedge wmb_write_dcache_pop_clk)
begin
    if(wmb_write_dcache_pop_up)
    begin
    wmb_write_dcache_ptr[WMB_ENTRY-1:0]  <=  wmb_write_dcache_ptr_set[WMB_ENTRY-1:0]; 
    wmb_write_dcache_addr[`WK_PA_WIDTH-1:0] <=  wmb_write_dcache_addr_set[`WK_PA_WIDTH-1:0];
    end
end

//sel dcache req entry
// &CombBeg; @1267
always @( wmb_write_ptr[7:0]                        //parameter carefully, LTL@20241024
       or wmb_dcache_req_set[7:0])
begin
case(wmb_write_ptr[WMB_ENTRY-1:0])   //wmb_write_ptr at most one value is 1, no need find first one, LTL@20241024
  8'b00000001:wmb_write_dcache_priority[7:0] = wmb_dcache_req_set[7:0];
  8'b00000010:wmb_write_dcache_priority[7:0] = {wmb_dcache_req_set[0],wmb_dcache_req_set[7:1]};
  8'b00000100:wmb_write_dcache_priority[7:0] = {wmb_dcache_req_set[1:0],wmb_dcache_req_set[7:2]};
  8'b00001000:wmb_write_dcache_priority[7:0] = {wmb_dcache_req_set[2:0],wmb_dcache_req_set[7:3]};
  8'b00010000:wmb_write_dcache_priority[7:0] = {wmb_dcache_req_set[3:0],wmb_dcache_req_set[7:4]};
  8'b00100000:wmb_write_dcache_priority[7:0] = {wmb_dcache_req_set[4:0],wmb_dcache_req_set[7:5]};
  8'b01000000:wmb_write_dcache_priority[7:0] = {wmb_dcache_req_set[5:0],wmb_dcache_req_set[7:6]};
  8'b10000000:wmb_write_dcache_priority[7:0] = {wmb_dcache_req_set[6:0],wmb_dcache_req_set[7]};
  default:    wmb_write_dcache_priority[7:0] = 8'b0;
endcase
// &CombEnd; @1279
end
//always_comb begin  //parameter for wmb_write_dcache_priority, syntax too explict, no support,  LTL@20241104
//  wmb_write_dcache_priority[WMB_ENTRY-1:0] = {WMB_ENTRY{wmb_write_ptr[0]}} & wmb_dcache_req_set[WMB_ENTRY-1:0];
//  for(int i=1;i<WMB_ENTRY;i++) begin
//    wmb_write_dcache_priority[WMB_ENTRY-1:0] |= {WMB_ENTRY{wmb_write_ptr[i]}}  & {wmb_dcache_req_set[i-1:0],wmb_dcache_req_set[WMB_ENTRY-1:i]};
//  end
//end


//always @( wmb_write_ptr_next[1][7:0]   //need parameter, LTL@20241024
//       or wmb_write_ptr_next7[7:0]
//       or wmb_write_ptr_next3[7:0]
//       or wmb_write_ptr_next2[7:0]
//       or wmb_write_dcache_priority[7:0]
//       or wmb_write_ptr_next4[7:0]
//       or wmb_write_ptr_next5[7:0]
//       or wmb_write_ptr[7:0]
//       or wmb_write_ptr_next6[7:0])
//begin
//casez(wmb_write_dcache_priority[WMB_ENTRY-1:0])    //find the first one in wmb_write_dcache_priority, LTL@20241024
//  8'b???????1:wmb_write_dcache_ptr_set[7:0] = wmb_write_ptr[WMB_ENTRY-1:0];
//  8'b??????10:wmb_write_dcache_ptr_set[7:0] = wmb_write_ptr_next1[WMB_ENTRY-1:0];
//  8'b?????100:wmb_write_dcache_ptr_set[7:0] = wmb_write_ptr_next2[WMB_ENTRY-1:0];
//  8'b????1000:wmb_write_dcache_ptr_set[7:0] = wmb_write_ptr_next3[WMB_ENTRY-1:0];
//  8'b???10000:wmb_write_dcache_ptr_set[7:0] = wmb_write_ptr_next4[WMB_ENTRY-1:0];
//  8'b??100000:wmb_write_dcache_ptr_set[7:0] = wmb_write_ptr_next5[WMB_ENTRY-1:0];
//  8'b?1000000:wmb_write_dcache_ptr_set[7:0] = wmb_write_ptr_next6[WMB_ENTRY-1:0];
//  8'b10000000:wmb_write_dcache_ptr_set[7:0] = wmb_write_ptr_next7[WMB_ENTRY-1:0];
//  default:    wmb_write_dcache_ptr_set[7:0] = 8'b0;
//endcase
//end

always_comb begin    //parameter for sq_lda0_ex3_fwd_data, need consider first 1 from ptr0, and 1->4 LTL@20241104
  wmb_write_dcache_ptr_set[WMB_ENTRY-1:0] = {WMB_ENTRY{wmb_write_dcache_priority[0]}} & wmb_write_ptr[WMB_ENTRY-1:0];
  find_one_from_zero_for_priority = {WMB_ENTRY{1'b0}};
  for(int i=1;i<WMB_ENTRY;i++) begin
    for(int j=0; j<i; j++) begin
      find_one_from_zero_for_priority[i] = find_one_from_zero_for_priority[i] | wmb_write_dcache_priority[j];
    end
      wmb_write_dcache_ptr_set[WMB_ENTRY-1:0] |= {WMB_ENTRY{wmb_write_dcache_priority[i] & (!find_one_from_zero_for_priority[i])}} & wmb_write_ptr_next[i][WMB_ENTRY-1:0];  //no need or, LTL@20241104
  end  
end

//assign wmb_write_dcache_addr_set[`WK_PA_WIDTH-1:0]  = {`WK_PA_WIDTH{wmb_write_dcache_ptr_set[0]}} & wmb_entry_addr_0[`WK_PA_WIDTH-1:0]  //parameter, LTL@20241024
//                                                   | {`WK_PA_WIDTH{wmb_write_dcache_ptr_set[1]}} & wmb_entry_addr_1[`WK_PA_WIDTH-1:0]
//                                                   | {`WK_PA_WIDTH{wmb_write_dcache_ptr_set[2]}} & wmb_entry_addr_2[`WK_PA_WIDTH-1:0]
//                                                   | {`WK_PA_WIDTH{wmb_write_dcache_ptr_set[3]}} & wmb_entry_addr_3[`WK_PA_WIDTH-1:0]
//                                                   | {`WK_PA_WIDTH{wmb_write_dcache_ptr_set[4]}} & wmb_entry_addr_4[`WK_PA_WIDTH-1:0]
//                                                   | {`WK_PA_WIDTH{wmb_write_dcache_ptr_set[5]}} & wmb_entry_addr_5[`WK_PA_WIDTH-1:0]
//                                                   | {`WK_PA_WIDTH{wmb_write_dcache_ptr_set[6]}} & wmb_entry_addr_6[`WK_PA_WIDTH-1:0]
//                                                   | {`WK_PA_WIDTH{wmb_write_dcache_ptr_set[7]}} & wmb_entry_addr_7[`WK_PA_WIDTH-1:0];
always_comb begin  //parameter for wmb_write_dcache_addr_set, LTL@20241104
  wmb_write_dcache_addr_set[`WK_PA_WIDTH-1:0] = {`WK_PA_WIDTH{1'b0}};
  for(int i=0;i<WMB_ENTRY;i++) begin
    wmb_write_dcache_addr_set[`WK_PA_WIDTH-1:0] |= {`WK_PA_WIDTH{wmb_write_dcache_ptr_set[i]}}  & wmb_entry_addr[i][`WK_PA_WIDTH-1:0];
  end
end

//dcache pop signal
//assign wmb_write_req_dcache_way        = |(wmb_write_dcache_ptr[WMB_ENTRY-1:0] & wmb_entry_dcache_way[WMB_ENTRY-1:0]);  //L1D 2->4way, LTL@20250323
always_comb begin  //parameter for wmb_write_req_dcache_way, LTL@20241104  //L1D 2->4way, LTL@20250323
  wmb_write_req_dcache_way[1:0] = 2'b0;
  for(int i=0;i<WMB_ENTRY;i++) begin
    wmb_write_req_dcache_way[1:0] |= {2{wmb_write_dcache_ptr[i]}}  & wmb_entry_dcache_way[i][1:0];
  end
end
assign wmb_write_req_dcache_page_share = |(wmb_write_dcache_ptr[WMB_ENTRY-1:0] & wmb_entry_dcache_page_share[WMB_ENTRY-1:0]);
assign wmb_write_req_dcache_dirty      = |(wmb_write_dcache_ptr[WMB_ENTRY-1:0] & wmb_entry_dcache_dirty[WMB_ENTRY-1:0]);
assign wmb_write_req_dcache_share      = |(wmb_write_dcache_ptr[WMB_ENTRY-1:0] & wmb_entry_dcache_share[WMB_ENTRY-1:0]);
assign wmb_write_req_dcache_valid      = |(wmb_write_dcache_ptr[WMB_ENTRY-1:0] & wmb_entry_dcache_valid[WMB_ENTRY-1:0]);
//assign wmb_write_dcache_bytes_vld[15:0] = {16{wmb_write_dcache_ptr[0]}} & wmb_entry_bytes_vld_0[15:0]
//                                          | {16{wmb_write_dcache_ptr[1]}} & wmb_entry_bytes_vld_1[15:0]
//                                          | {16{wmb_write_dcache_ptr[2]}} & wmb_entry_bytes_vld_2[15:0]
//                                          | {16{wmb_write_dcache_ptr[3]}} & wmb_entry_bytes_vld_3[15:0]
//                                          | {16{wmb_write_dcache_ptr[4]}} & wmb_entry_bytes_vld_4[15:0]
//                                          | {16{wmb_write_dcache_ptr[5]}} & wmb_entry_bytes_vld_5[15:0]
//                                          | {16{wmb_write_dcache_ptr[6]}} & wmb_entry_bytes_vld_6[15:0]
//                                          | {16{wmb_write_dcache_ptr[7]}} & wmb_entry_bytes_vld_7[15:0];
always_comb begin  //parameter for wmb_write_dcache_bytes_vld, LTL@20241104
  wmb_write_dcache_bytes_vld[15:0] = 16'b0;
  for(int i=0;i<WMB_ENTRY;i++) begin
    wmb_write_dcache_bytes_vld[15:0] |= {16{wmb_write_dcache_ptr[i]}}  & wmb_entry_bytes_vld[i][15:0];
  end
end

// &CombBeg; @1317
//always @( wmb_entry_data_4[127:0]
//       or wmb_entry_data_7[127:0]
//       or wmb_entry_data_5[127:0]
//       or wmb_write_dcache_ptr[7:0]
//       or wmb_entry_data_1[127:0]
//       or wmb_entry_data_2[127:0]
//       or wmb_entry_data_0[127:0]
//       or wmb_entry_data_3[127:0]
//       or wmb_entry_data_6[127:0])
//begin
//case(wmb_write_dcache_ptr[7:0])    //at most one value is 1, no need find first 1, LTL@20241024
//  8'h01:  wmb_write_dcache_data[127:0] = wmb_entry_data_0[127:0];
//  8'h02:  wmb_write_dcache_data[127:0] = wmb_entry_data_1[127:0];
//  8'h04:  wmb_write_dcache_data[127:0] = wmb_entry_data_2[127:0];
//  8'h08:  wmb_write_dcache_data[127:0] = wmb_entry_data_3[127:0];
//  8'h10:  wmb_write_dcache_data[127:0] = wmb_entry_data_4[127:0];
//  8'h20:  wmb_write_dcache_data[127:0] = wmb_entry_data_5[127:0];
//  8'h40:  wmb_write_dcache_data[127:0] = wmb_entry_data_6[127:0];
//  8'h80:  wmb_write_dcache_data[127:0] = wmb_entry_data_7[127:0];
//  default:wmb_write_dcache_data[127:0] = {128{1'bx}};
//endcase
//// &CombEnd; @1329
//end
always_comb begin  //parameter for wmb_write_dcache_data, LTL@20241104
  wmb_write_dcache_data[127:0] = 128'b0;
  for(int i=0;i<WMB_ENTRY;i++) begin
    wmb_write_dcache_data[127:0] |= {128{wmb_write_dcache_ptr[i]}}  & wmb_entry_data[i][127:0];
  end
end
assign wmb_write_dcache_stall      = |(wmb_write_dcache_ptr[WMB_ENTRY-1:0] & wmb_entry_write_stall[WMB_ENTRY-1:0]);

assign wmb_write_dcache_sync_fence = |(wmb_write_dcache_ptr[WMB_ENTRY-1:0] & wmb_entry_sync_fence[WMB_ENTRY-1:0]);
assign wmb_write_dcache_atomic     = |(wmb_write_dcache_ptr[WMB_ENTRY-1:0] & wmb_entry_atomic_and_vld[WMB_ENTRY-1:0]);
assign wmb_write_dcache_icc        = |(wmb_write_dcache_ptr[WMB_ENTRY-1:0] & wmb_entry_icc_and_vld[WMB_ENTRY-1:0]);

assign wmb_write_dcache_req_icc_inst  = !wmb_write_dcache_atomic
                                        &&  !wmb_write_dcache_sync_fence
                                        &&  wmb_write_dcache_pop_req
                                        &&  wmb_write_dcache_icc;

//----------------------hit_idx-----------------------------
assign wmb_write_req_hit_idx  = lfb_wmb_write_req_hit_idx
//                                ||  snq_create_wmb_write_req_hit_idx
//                                ||  snq_wmb_write_req_hit_idx
                                ||  vb_wmb_write_req_hit_idx;

//for dcache_inst
assign wmb_dcache_inst_write_req_hit_idx  = lfb_wmb_write_req_hit_idx
                                            ||  snq_create_wmb_write_req_hit_idx
                                            ||  snq_wmb_write_req_hit_idx
                                            ||  vb_wmb_write_req_hit_idx;
//-----------------for ecc ---------------------------------
//for partial write
assign pw_en = wmb_dcache_data_region[3] && !(&wmb_write_dcache_bytes_vld[15:12])
               || wmb_dcache_data_region[2] && !(&wmb_write_dcache_bytes_vld[11:8])
               || wmb_dcache_data_region[1] && !(&wmb_write_dcache_bytes_vld[7:4])
               || wmb_dcache_data_region[0] && !(&wmb_write_dcache_bytes_vld[3:0]);

assign pw_read =  pw_en
                  && pw_ecc_idle
                  && !wmb_write_dcache_req_icc_inst
                  && cp0_lsu_ecc_en;

assign wmb_ecc_fsm_start = wmb_write_dcache_success_ori
                           && pw_read;

//for merge
assign pw_merge_stall = pw_en
                        && cp0_lsu_ecc_en;

// &Instance("xx_lsu_wmb_ecc_fsm","x_xx_lsu_wmb_ecc_fsm"); @1373
xx_lsu_wmb_ecc_fsm  x_xx_lsu_wmb_ecc_fsm (
  .cp0_lsu_icg_en         (cp0_lsu_icg_en        ),
  .cpurst_b               (cpurst_b              ),
  .forever_cpuclk         (forever_cpuclk        ),
  .lda0_wmb_data_reissue  (lda0_wmb_data_reissue ),
  .lda0_wmb_read_data     (lda0_wmb_read_data    ),
  .lda0_wmb_two_bit_err   (lda0_wmb_two_bit_err  ),
  .pad_yy_icg_scan_en     (pad_yy_icg_scan_en    ),
  .pw_ecc_idle            (pw_ecc_idle           ),
  .wmb_ecc_data_wen       (wmb_ecc_data_wen      ),
  .wmb_ecc_fatal_err      (wmb_ecc_fatal_err     ),
  .wmb_ecc_fsm_start      (wmb_ecc_fsm_start     ),
  .wmb_ecc_getdp          (wmb_ecc_getdp         ),
  .wmb_ecc_st_data        (wmb_ecc_st_data       ),
  .wmb_ecc_write_data     (wmb_ecc_write_data    ),
  .wmb_ecc_write_req      (wmb_ecc_write_req     )
);


//ecc fsm interface
assign wmb_ecc_data_wen[15:0] = wmb_write_dcache_bytes_vld[15:0];
assign wmb_ecc_st_data[127:0] = wmb_write_dcache_data[127:0];
assign wmb_ecc_getdp          = wmb_write_dcache_success_ori;

//for tag dirty ecc encode
assign wmb_tag_bf_ecc[`WK_LS_DCACHE_STTAG_BF_ECC_LENGTH-1:0]   = {wmb_write_req_dcache_page_share && !wmb_write_dcache_req_icc_inst,3'b101,wmb_write_dcache_addr[`WK_PA_WIDTH-1:14]};

`ifdef WK_PA_WIDTH_40
// &Instance("xx_lsu_30bit_ecc_encode", "x_wk_dcache_30bit_ecc_encode"); @1383
xx_lsu_30bit_ecc_encode  x_wk_dcache_30bit_ecc_encode (
  .data_encode          (wmb_tag_bf_ecc[`WK_LS_DCACHE_STTAG_BF_ECC_LENGTH-1:0]),
  .ecc_code             (wmb_tag_ecc[`WK_LS_DATASRAM_ECC_WIDTH-1:0]    ),
  .parity_bit           (wmb_tag_parity      )
);
`endif

`ifdef WK_PA_WIDTH_48
// &Instance("xx_lsu_34bit_ecc_encode", "x_wk_dcache_34bit_ecc_encode"); @1383
xx_lsu_38bit_ecc_encode  x_wk_dcache_38bit_ecc_encode (
  .data_encode          (wmb_tag_bf_ecc[`WK_LS_DCACHE_STTAG_BF_ECC_LENGTH-1:0]),
  .ecc_code             (wmb_tag_ecc[`WK_LS_DATASRAM_ECC_WIDTH-1:0]    ),
  .parity_bit           (wmb_tag_parity      )
);
`endif

// &Connect(.data_encode    (wmb_tag_bf_ecc[29:0] ),   @1384
//          .ecc_code       (wmb_tag_ecc[5:0]     ),  @1385
//          .parity_bit     (wmb_tag_parity       )  @1386
//         ); @1387

assign wmb_dirty_af_ecc[`WK_LS_DCACHE_STTAG_AF_ECC_LENGTH-1:0]   = {wmb_tag_parity,wmb_tag_ecc[`WK_LS_DATASRAM_ECC_WIDTH-1:0],wmb_tag_bf_ecc[`WK_LS_DCACHE_STTAG_BF_ECC_LENGTH-1:`WK_LS_DCACHE_SINGLE_TAG_WIDTH]};
assign wmb_dirty_ecc_din[`WK_LS_DCACHE_META_WIDTH-1:0]  = { wmb_dirty_af_ecc[`WK_LS_DCACHE_STTAG_AF_ECC_LENGTH-1:0],
                                    wmb_dirty_af_ecc[`WK_LS_DCACHE_STTAG_AF_ECC_LENGTH-1:0],
                                    wmb_dirty_af_ecc[`WK_LS_DCACHE_STTAG_AF_ECC_LENGTH-1:0],
                                    wmb_dirty_af_ecc[`WK_LS_DCACHE_STTAG_AF_ECC_LENGTH-1:0]};// 1'b0 deleted, L1D 2way->4way, LTL@20250321

//for cache inv
//when inv cacheline,should also clear st tag for next ecc check
//especially for cache miss
assign wmb_dcache_arb_st_icc_req = wmb_dcache_arb_req 
                                   && wmb_write_dcache_req_icc_inst;

//for ecc_info
//assign wmb_dcache_arb_pw_addr[`WK_PA_WIDTH-1:0] = wmb_write_dcache_addr[`WK_PA_WIDTH-1:0];

//for pw dcache bank sel
assign wmb_dcache_get_data[3:0] = wmb_dcache_data_region[3:0];

// &Force("nonport","wmb_write_req_dcache_page_share"); @1405

assign wmb_dcache_arb_ld_borrow_req = wmb_dcache_arb_req && pw_read;
assign wmb_dcache_arb_data_way[1:0] = wmb_dcache_data_high_sel[1:0];  //1bit->2bit, L1D 2way->4way, LTL@20250321

assign wmb_write_dcache_wen[15:0]   = wmb_ecc_write_req
                                      ? 16'hffff
                                      : wmb_write_dcache_bytes_vld[15:0];
//----------------------cache interface---------------------
assign wmb_dcache_arb_req_unmask  = wmb_write_dcache_pop_req
                                       &&  pw_ecc_idle
                                       &&  !wmb_write_dcache_stall
                                       &&  wmb_write_dcache_permit
                                    || wmb_ecc_write_req;
assign wmb_dcache_arb_req         = wmb_dcache_arb_req_unmask;
assign wmb_dcache_arb_ld_req      = wmb_dcache_arb_req;
assign wmb_dcache_arb_st_req      = wmb_dcache_arb_req;

assign wmb_write_dcache_success_ori = wmb_dcache_arb_req
                                      &&  dcache_arb_wmb_ld_grnt;
//                                    &&  !wmb_write_req_hit_idx;
//for ecc pw read                                    
assign wmb_write_dcache_success     = wmb_write_dcache_success_ori
                                         && (!pw_read || wmb_ecc_write_req)
                                      || wmb_ecc_fatal_err;
//----------------tag array-------------
assign wmb_dcache_arb_ld_tag_gateclk_en = wmb_dcache_arb_req_unmask
                                          &&  !pw_read
                                          &&  wmb_write_dcache_req_icc_inst;
assign wmb_dcache_arb_ld_tag_req        = wmb_dcache_arb_req_unmask
                                          &&  !pw_read
                                          &&  wmb_write_dcache_req_icc_inst;
//                                          &&  !wmb_write_req_hit_idx;
assign wmb_dcache_arb_ld_tag_idx[7:0]   = wmb_write_dcache_addr[13:6];          //8->7,14->13, L1D 2way->4way, LTL@20250321
assign wmb_dcache_arb_ld_tag_wen[3:0]   = {wmb_write_req_dcache_way==2'b11,     //1->3, L1D 2way->4way, LTL@20250321
                                           wmb_write_req_dcache_way==2'b10,
                                           wmb_write_req_dcache_way==2'b01,
                                           wmb_write_req_dcache_way==2'b00};
//---------------dirty array------------
assign wmb_dcache_arb_st_dirty_gateclk_en = wmb_dcache_arb_req_unmask
                                            && !pw_read
                                            && (wmb_write_dcache_req_icc_inst
                                              || ({wmb_write_req_dcache_dirty, wmb_write_req_dcache_share, wmb_write_req_dcache_valid} != 3'b101
                                                  && !wmb_write_dcache_req_icc_inst));
assign wmb_dcache_arb_st_dirty_req      = wmb_dcache_arb_req_unmask
                                          &&  !pw_read
                                          && (wmb_write_dcache_req_icc_inst
                                              || ({wmb_write_req_dcache_dirty, wmb_write_req_dcache_share, wmb_write_req_dcache_valid} != 3'b101
                                                  && !wmb_write_dcache_req_icc_inst));
//                                          &&  !wmb_write_req_hit_idx;
assign wmb_dcache_arb_st_dirty_idx[7:0] = wmb_write_dcache_addr[13:6];    //8->7, L1D 2way->4way, LTL@20250321
//fifo,dirty1,share1,valid1,dirty0,share0,valid0
assign wmb_dcache_arb_st_dirty_din[`WK_LS_DCACHE_META_WIDTH-1:0]= wmb_write_dcache_req_icc_inst  ////23->45, 22->44, L1D 2way->4way, LTL@20250321
                                          ? {`WK_LS_DCACHE_META_WIDTH{1'b0}}
                                          : wmb_dirty_ecc_din[`WK_LS_DCACHE_META_WIDTH-1:0];
assign wmb_dcache_arb_st_dirty_wen[15:0] = {                                  ////1'b0 deleted, 8->16, L1D 2way->4way, LTL@20250321
                                          {4{wmb_write_req_dcache_way==2'b11}},
                                          {4{wmb_write_req_dcache_way==2'b10}},
                                          {4{wmb_write_req_dcache_way==2'b01}},
                                          {4{wmb_write_req_dcache_way==2'b00}}};

//---------------data array-------------
//pre signal
assign wmb_dcache_data_region[3]  = |wmb_write_dcache_bytes_vld[15:12];
assign wmb_dcache_data_region[2]  = |wmb_write_dcache_bytes_vld[11:8];
assign wmb_dcache_data_region[1]  = |wmb_write_dcache_bytes_vld[7:4];
assign wmb_dcache_data_region[0]  = |wmb_write_dcache_bytes_vld[3:0];
assign wmb_dcache_data_high_sel[1:0] = {wmb_write_req_dcache_way[1] ^ wmb_write_dcache_addr[5], wmb_write_req_dcache_way[0] ^ wmb_write_dcache_addr[4]}; //L1D 2way->4way, LTL@20250320

// &Force("output","wmb_dcache_arb_ld_data_req"); @1476
assign wmb_dcache_arb_ld_data_req_unmask[15:0] = {wmb_dcache_data_region[3:0],wmb_dcache_data_region[3:0],wmb_dcache_data_region[3:0],wmb_dcache_data_region[3:0]}      //7->15, L1D 2way->4way, LTL@20250320
                                                & {{4{wmb_dcache_data_high_sel==2'b11}},{4{wmb_dcache_data_high_sel==2'b10}},{4{wmb_dcache_data_high_sel==2'b01}},{4{wmb_dcache_data_high_sel==2'b00}}}
                                                & {16{wmb_dcache_arb_req_unmask}};
assign wmb_dcache_arb_ld_data_req[15:0]        = wmb_dcache_arb_ld_data_req_unmask[15:0];  //7->15, L1D 2way->4way, LTL@20250321
//                                                & {8{!wmb_write_req_hit_idx}};
assign wmb_dcache_arb_ld_data_gateclk_en[15:0] = wmb_dcache_arb_ld_data_req_unmask[15:0];  //7->15, L1D 2way->4way, LTL@20250321
                                            
assign wmb_dcache_arb_borrow_addr[`WK_PA_WIDTH-1:0] = wmb_write_dcache_addr[`WK_PA_WIDTH-1:0];
assign wmb_dcache_arb_ld_data_idx[9:0] = {wmb_write_dcache_addr[13:6],wmb_write_req_dcache_way};  //10->9,14->13 L1D 2way->4way, LTL@20250320  
assign wmb_dcache_arb_ld_data_0_din[155:0]  = wmb_ecc_write_data[155:0];
assign wmb_dcache_arb_ld_data_1_din[155:0]  = wmb_ecc_write_data[155:0];
assign wmb_dcache_arb_ld_data_2_din[155:0]  = wmb_ecc_write_data[155:0];
assign wmb_dcache_arb_ld_data_3_din[155:0]  = wmb_ecc_write_data[155:0];
assign wmb_dcache_arb_ld_data_gwen[15:0] =  pw_read                               //7->15, L1D 2way->4way, LTL@20250320  
                                           ? 16'b0
                                           : wmb_dcache_arb_ld_data_req_unmask[15:0];
assign wmb_dcache_arb_ld_data_wen[63:0] = {wmb_write_dcache_wen[15:0],wmb_write_dcache_wen[15:0],wmb_write_dcache_wen[15:0],wmb_write_dcache_wen[15:0]}   //31->63, L1D 2way->4way, LTL@20250320  
                                          & {{16{wmb_dcache_data_high_sel==2'b11}},{16{wmb_dcache_data_high_sel==2'b10}},{16{wmb_dcache_data_high_sel==2'b01}},{16{wmb_dcache_data_high_sel==2'b00}}};

//==========================================================
//                       Request TCM
//==========================================================
assign wmb_tcm_req_unmask       = |wmb_entry_write_tcm_req[WMB_ENTRY-1:0];
assign wmb_tcm_dtcm_sel         = |(wmb_write_ptr[WMB_ENTRY-1:0] & wmb_entry_dtcm_hit[WMB_ENTRY-1:0]);
// &Force("nonport", "wmb_tcm_dtcm_sel"); @1504

// &Instance("gated_clk_cell", "x_lsu_wmb_tcm_req_gated_clk"); @1517
// &Connect(.clk_in        (forever_cpuclk     ), @1518
//          .external_en   (1'b0               ), @1519
//          .module_en     (cp0_lsu_icg_en     ), @1520
//          .local_en      (wmb_tcm_req_clk_en), @1521
//          .clk_out       (wmb_tcm_req_clk   )); @1522
assign wmb_tcm_pending                   = 1'b0;
assign wmb_tcm_grant                     = 1'b0;
assign wmb_tcm_write_done[WMB_ENTRY-1:0] = {WMB_ENTRY{1'b0}};
//----------------------------------------------------------
//                          output
//----------------------------------------------------------
//---------------- dtcm ----------------
//---------------- itcm ----------------
//==========================================================
//                  Request victim buffer
//==========================================================
//req signal is used for arbitration
assign wmb_vb_create_req          = wmb_write_vb_req_unmask;
// &Force("output","wmb_vb_create_vld"); @1595
//only create vb should check snq
assign wmb_vb_create_vld          = wmb_write_vb_req_unmask
                                    &&  !wmb_dcache_inst_write_req_hit_idx;
assign wmb_vb_create_dp_vld       = wmb_write_vb_req_unmask;
assign wmb_vb_create_gateclk_en   = wmb_write_vb_req_unmask;
assign wmb_vb_inv                 = wmb_write_req_inst_size[1];
assign wmb_vb_set_way_mode        = wmb_write_req_inst_mode[1:0]  ==  2'b10;
assign wmb_vb_addr_tto6[`WK_PA_WIDTH-7:0]  = wmb_write_req_addr[`WK_PA_WIDTH-1:6];

//==========================================================
//      Request biu aw channel(include mem set request)
//==========================================================
//-----------------------inst type--------------------------
assign wmb_write_req_sync_fence_inst  = wmb_write_req_sync_fence
                                        &&  !wmb_write_req_atomic;
assign wmb_write_req_sync_inst  = wmb_write_req_sync_fence
                                  &&  !wmb_write_req_atomic
                                  &&  (wmb_write_req_inst_type[1:0] ==  2'b00);
//assign wmb_write_req_icc_inst   = !wmb_write_req_atomic
//                                  &&  !wmb_write_req_sync_fence
//                                  &&  wmb_write_req_icc;
//-----------------interface to bus_arb---------------------
assign wmb_biu_write_en = wmb_write_imme || wmb_write_biu_dcache_line;
// &Force("output","wmb_biu_aw_req"); @1619
assign wmb_biu_aw_req   = wmb_write_biu_dp_req
                          &&  wmb_biu_write_en
                          &&  wmb_write_biu_req_unmask
                          &&  !wmb_tcm_pending
                          &&  (!rb_wmb_so_pending
                              ||  !wmb_write_req_page_so)
                          &&  (!wmb_write_req_hit_idx
                              ||  wmb_write_req_sync_fence_inst);

assign wmb_biu_aw_dp_req          = wmb_write_biu_dp_req
                                    &&  wmb_biu_write_en
                                    &&  wmb_write_biu_req_unmask
                                    &&  (!rb_wmb_so_pending
                                        ||  !wmb_write_req_page_so);
assign wmb_biu_aw_req_gateclk_en  = wmb_write_biu_dp_req;
//-----------------id-------------------
assign wmb_biu_aw_id_judge[4:0] = {wmb_write_req_sync_fence_inst,
                                  wmb_write_req_page_so,
                                  wmb_write_req_page_ca,
                                  wmb_write_req_atomic,
                                  wmb_write_biu_dcache_line};

// &Force("output","wmb_biu_aw_id"); @1642
// &CombBeg; @1643
always @( wmb_write_ptr_encode[2:0]
       or wmb_biu_aw_id_judge[4:0]
       or wmb_write_ptr_next3_encode[2:0])
begin
wmb_biu_aw_id[4:0]  = 5'b0;
casez(wmb_biu_aw_id_judge[4:0])
  5'b1????:wmb_biu_aw_id[4:0] = BIU_B_SYNC_FENCE_ID;
  5'b01???:wmb_biu_aw_id[4:0] = BIU_B_SO_ID;
  5'b001?0:wmb_biu_aw_id[4:0] = {BIU_R_NORM_ID_T,wmb_write_ptr_encode[2:0]};
  5'b001?1:wmb_biu_aw_id[4:0] = {BIU_R_NORM_ID_T,wmb_write_ptr_next3_encode[2:0]};
  5'b0001?:wmb_biu_aw_id[4:0] = BIU_B_NC_ATOM_ID;
  5'b0000?:wmb_biu_aw_id[4:0] = {BIU_R_NORM_ID_T,wmb_write_ptr_encode[2:0]};
  default :wmb_biu_aw_id[4:0]  = 5'b0;
endcase
// &CombEnd; @1654
end

assign wmb_biu_aw_addr[`WK_PA_WIDTH-1:4] = wmb_write_req_addr[`WK_PA_WIDTH-1:4];

assign wmb_biu_aw_size_maintain = (wmb_write_req_page_so  ||  wmb_write_req_page_nc_atomic)
                                  &&  !wmb_write_req_sync_fence_inst;

assign wmb_biu_aw_addr[3:0]   = wmb_biu_aw_size_maintain
                                ? wmb_write_req_addr[3:0]
                                : 4'b0;

assign wmb_biu_aw_len[1:0]    = wmb_write_biu_dcache_line
                                ? 2'b11
                                : 2'b00;
assign wmb_biu_aw_size[2:0]   = wmb_biu_aw_size_maintain
                                ? {wmb_write_req_inst_size[2:0]}
                                : 3'b100;
assign wmb_biu_aw_burst[1:0]  = wmb_write_biu_dcache_line &&  wmb_write_burst_neg
                                ? 2'b11
                                : 2'b01;
assign wmb_biu_aw_lock        = !wmb_write_req_page_ca
//                                &&  wmb_write_req_page_share
                                &&  wmb_write_req_atomic;

//cache
//if sync/fence use normal, noncacheable
assign wmb_biu_aw_cache[3:0]  = wmb_write_req_sync_fence_inst
                                ? 4'b0011
                                : {wmb_write_req_page_wa  &&  !amr_l2_mem_set,
                                  wmb_write_req_page_ca,
                                  !wmb_write_req_page_so,
                                  wmb_write_req_page_buf};

//prot:supv,sec,inst
assign wmb_biu_aw_prot[2:0]   = {1'b0,
                                wmb_write_req_page_sec,
                                wmb_write_req_priv_mode[0]};

assign wmb_biu_aw_user[1:0]   = {wmb_write_req_page_share,wmb_write_req_priv_mode[1]};

//-----------------snoop----------------
//for single core,send wu or wlu when not wns_en
//assign wmb_write_req_no_wns   = wmb_write_req_page_share || !cp0_lsu_wns_en;

assign wmb_biu_aw_snoop[2:0]  = wmb_write_req_page_ca && wmb_write_biu_dcache_line
                                ? 3'b001
                                : wmb_write_req_atomic && wmb_write_req_page_ca
                                  ? 3'b011
                                  : 3'b000;

assign wmb_write_req_default_domain = !wmb_write_req_page_ca
                                      &&  (wmb_write_req_stex_inst
                                          ||  wmb_write_req_st_inst);
assign wmb_biu_aw_domain[1:0] = wmb_write_req_default_domain
                                ? 2'b11
                                : wmb_write_req_sync_fence_inst
                                  ? {1'b0,wmb_write_req_page_share}
                                  : 2'b01;

assign wmb_biu_aw_bar[1:0]    = {wmb_write_req_sync_inst,wmb_write_req_sync_fence_inst};

//-----------------mem_set counter--------------------------
assign wmb_mem_set_write_grnt = wmb_write_biu_dcache_line
                                &&  bus_arb_wmb_aw_grnt;

assign wmb_entry_mem_set_write_grnt[WMB_ENTRY-1:0]  = {WMB_ENTRY{wmb_mem_set_write_grnt}}
                                                      & wmb_write_ptr_to_next3[WMB_ENTRY-1:0];

//for timing use mem_set write gateclk en for biu_id clk
assign wmb_mem_set_write_gateclk_en = wmb_write_biu_req_unmask
                                      &&  wmb_write_biu_dcache_line;
assign wmb_entry_mem_set_write_gateclk_en[WMB_ENTRY-1:0]  = {WMB_ENTRY{wmb_mem_set_write_gateclk_en}}
                                                            & wmb_write_ptr_to_next3[WMB_ENTRY-1:0];

//-----------------biu grnt signal--------------------------
//assign wmb_biu_nc_req_grnt    = bus_arb_wmb_aw_grnt
//                                &&  !wmb_write_req_page_ca
//                                &&  !wmb_write_req_page_so
//                                &&  !wmb_write_req_atomic
//                                &&  !wmb_write_req_sync_fence_inst;
assign wmb_biu_so_req_grnt    = bus_arb_wmb_aw_grnt
                                //&&  !wmb_write_req_atomic
                                &&  wmb_write_req_page_so
                                &&  !wmb_write_req_sync_fence_inst;

//set wmb_entry_w_last signal
assign wmb_entry_1_entry_w_last[WMB_ENTRY-1:0]      = wmb_write_ptr[WMB_ENTRY-1:0];
assign wmb_entry_dcache_line_w_last[WMB_ENTRY-1:0]  = wmb_write_ptr_next[3][WMB_ENTRY-1:0];
assign wmb_entry_w_last_set[WMB_ENTRY-1:0]          = wmb_write_biu_dcache_line
                                                      ? wmb_entry_dcache_line_w_last[WMB_ENTRY-1:0]
                                                      : wmb_entry_1_entry_w_last[WMB_ENTRY-1:0];

//==========================================================
//                Request biu w channel
//==========================================================
assign wmb_biu_w_req          = wmb_data_biu_req;
//w_id is used for debug
assign wmb_biu_w_id[4:0]      = wmb_data_req_biu_id[4:0];
assign wmb_biu_w_data[127:0]  = wmb_data_req_data[127:0];
assign wmb_biu_w_strb[15:0]   = wmb_data_req_bytes_vld[15:0];
assign wmb_biu_w_last         = wmb_data_req_w_last;
assign wmb_biu_w_vld          = wmb_data_biu_req;
assign wmb_biu_w_wns          = wmb_data_req_wns;

//==========================================================
//                Request wb cmplt part
//==========================================================
// &CombBeg; @1761
//always @( wmb_entry_wb_cmplt_req[7:0])
//begin
//wmb_st_wb_cmplt_ptr[WMB_ENTRY-1:0]  = {WMB_ENTRY{1'b0}};
//casez(wmb_entry_wb_cmplt_req[WMB_ENTRY-1:0])
//  8'b????_???1:wmb_st_wb_cmplt_ptr[0]  = 1'b1;
//  8'b????_??10:wmb_st_wb_cmplt_ptr[1]  = 1'b1;
//  8'b????_?100:wmb_st_wb_cmplt_ptr[2]  = 1'b1;
//  8'b????_1000:wmb_st_wb_cmplt_ptr[3]  = 1'b1;
//  8'b???1_0000:wmb_st_wb_cmplt_ptr[4]  = 1'b1;
//  8'b??10_0000:wmb_st_wb_cmplt_ptr[5]  = 1'b1;
//  8'b?100_0000:wmb_st_wb_cmplt_ptr[6]  = 1'b1;
//  8'b1000_0000:wmb_st_wb_cmplt_ptr[7]  = 1'b1;
//  default:wmb_st_wb_cmplt_ptr[WMB_ENTRY-1:0]  = {WMB_ENTRY{1'b0}};
//endcase
//// &CombEnd; @1774
//end

always_comb begin    //parameter for wmb_st_wb_cmplt_ptr, need consider first 1 from ptr0, and 1->4 LTL@20241104
  wmb_st_wb_cmplt_ptr[0] = wmb_entry_wb_cmplt_req[0];
  wmb_st_wb_cmplt_ptr[WMB_ENTRY-1:1] = {WMB_ENTRY-1{1'b0}};
  find_one_from_zero_for_cmplt_ptr = {WMB_ENTRY{1'b0}};
  for(int i=1;i<WMB_ENTRY;i++) begin
    for(int j=0; j<i; j++) begin
      find_one_from_zero_for_cmplt_ptr[i] = find_one_from_zero_for_cmplt_ptr[i] | wmb_entry_wb_cmplt_req[j];
    end
      wmb_st_wb_cmplt_ptr[i] = wmb_entry_wb_cmplt_req[i] & (!find_one_from_zero_for_cmplt_ptr[i]);
  end  
end


//-----------------cmplt req info---------------------------
// &Force("output","wmb_lswb0_cmplt_req"); @1777
assign wmb_lswb0_cmplt_req  = |wmb_entry_wb_cmplt_req[WMB_ENTRY-1:0];   //fix lswb0 for wmb cmplt_req, LTL@20241024
assign wmb_lswb0_inst_flush = |(wmb_st_wb_cmplt_ptr[WMB_ENTRY-1:0]  & wmb_entry_inst_flush[WMB_ENTRY-1:0]);
assign wmb_lswb0_spec_fail  = |(wmb_st_wb_cmplt_ptr[WMB_ENTRY-1:0]  & wmb_entry_spec_fail[WMB_ENTRY-1:0]);
assign wmb_lswb1_cmplt_req  = wmb_lswb0_cmplt_req; 
assign wmb_lswb1_inst_flush = wmb_lswb0_inst_flush;
assign wmb_lswb1_spec_fail  = wmb_lswb0_spec_fail;
assign wmb_lswb1_iid        = wmb_lswb0_iid;
assign wmb_lswb1_vstart_vld = wmb_lswb0_vstart_vld;
//assign wmb_lswb0_iid[IID_WIDTH-1:0]   = {7{wmb_st_wb_cmplt_ptr[0]}} & wmb_entry_iid_0[6:0]
//                              | {7{wmb_st_wb_cmplt_ptr[1]}} & wmb_entry_iid_1[6:0]
//                              | {7{wmb_st_wb_cmplt_ptr[2]}} & wmb_entry_iid_2[6:0]
//                              | {7{wmb_st_wb_cmplt_ptr[3]}} & wmb_entry_iid_3[6:0]
//                              | {7{wmb_st_wb_cmplt_ptr[4]}} & wmb_entry_iid_4[6:0]
//                              | {7{wmb_st_wb_cmplt_ptr[5]}} & wmb_entry_iid_5[6:0]
//                              | {7{wmb_st_wb_cmplt_ptr[6]}} & wmb_entry_iid_6[6:0]
//                              | {7{wmb_st_wb_cmplt_ptr[7]}} & wmb_entry_iid_7[6:0];
always_comb begin  //parameter for wmb_lswb0_iid, LTL@20241104
  wmb_lswb0_iid[IID_WIDTH-1:0] = {IID_WIDTH{1'b0}};
  for(int i=0;i<WMB_ENTRY;i++) begin
    wmb_lswb0_iid[IID_WIDTH-1:0] |= {IID_WIDTH{wmb_st_wb_cmplt_ptr[i]}} & wmb_entry_iid[i][IID_WIDTH-1:0];
  end
end

assign wmb_lswb0_vstart_vld = |(wmb_st_wb_cmplt_ptr[WMB_ENTRY-1:0]  & wmb_entry_vstart_vld[WMB_ENTRY-1:0]);
// &Force("nonport","wmb_entry_vstart_vld"); @1794

//-------------------cmplt grnt-----------------------------
assign wmb_entry_wb_cmplt_grnt[WMB_ENTRY-1:0] = {WMB_ENTRY{lswb0_wmb_ex3_cmplt_grnt}}
                                                & wmb_st_wb_cmplt_ptr[WMB_ENTRY-1:0];
//==========================================================
//                Request wb data part
//==========================================================
assign wmb_ld_wb_data_ptr[WMB_ENTRY-1:0]  = wmb_entry_wb_data_req[WMB_ENTRY-1:0];

assign wmb_lwb0_data_req         = |wmb_entry_wb_data_req[WMB_ENTRY-1:0];  //wmb wb data only use lwb0 pipe, LTL@20241024

//assign wmb_lwb0_preg[6:0]        = {7{wmb_ld_wb_data_ptr[0]}} & wmb_entry_preg_0[6:0]
//                                    | {7{wmb_ld_wb_data_ptr[1]}} & wmb_entry_preg_1[6:0]
//                                    | {7{wmb_ld_wb_data_ptr[2]}} & wmb_entry_preg_2[6:0]
//                                    | {7{wmb_ld_wb_data_ptr[3]}} & wmb_entry_preg_3[6:0]
//                                    | {7{wmb_ld_wb_data_ptr[4]}} & wmb_entry_preg_4[6:0]
//                                    | {7{wmb_ld_wb_data_ptr[5]}} & wmb_entry_preg_5[6:0]
//                                    | {7{wmb_ld_wb_data_ptr[6]}} & wmb_entry_preg_6[6:0]
//                                    | {7{wmb_ld_wb_data_ptr[7]}} & wmb_entry_preg_7[6:0];
always_comb begin  //parameter for wmb_lwb0_preg, LTL@20241104
  wmb_lwb0_preg[PREG-1:0] = {PREG{1'b0}};
  for(int i=0;i<WMB_ENTRY;i++) begin
    wmb_lwb0_preg[PREG-1:0] |= {PREG{wmb_ld_wb_data_ptr[i]}}  & wmb_entry_preg[i][PREG-1:0];
  end
end

//assign wmb_lwb0_data_addr[`WK_PA_WIDTH-1:0] = {`WK_PA_WIDTH{wmb_ld_wb_data_ptr[0]}} & wmb_entry_addr_0[`WK_PA_WIDTH-1:0]
//                                            | {`WK_PA_WIDTH{wmb_ld_wb_data_ptr[1]}} & wmb_entry_addr_1[`WK_PA_WIDTH-1:0]
//                                            | {`WK_PA_WIDTH{wmb_ld_wb_data_ptr[2]}} & wmb_entry_addr_2[`WK_PA_WIDTH-1:0]
//                                            | {`WK_PA_WIDTH{wmb_ld_wb_data_ptr[3]}} & wmb_entry_addr_3[`WK_PA_WIDTH-1:0]
//                                            | {`WK_PA_WIDTH{wmb_ld_wb_data_ptr[4]}} & wmb_entry_addr_4[`WK_PA_WIDTH-1:0]
//                                            | {`WK_PA_WIDTH{wmb_ld_wb_data_ptr[5]}} & wmb_entry_addr_5[`WK_PA_WIDTH-1:0]
//                                            | {`WK_PA_WIDTH{wmb_ld_wb_data_ptr[6]}} & wmb_entry_addr_6[`WK_PA_WIDTH-1:0]
//                                            | {`WK_PA_WIDTH{wmb_ld_wb_data_ptr[7]}} & wmb_entry_addr_7[`WK_PA_WIDTH-1:0];
always_comb begin  //parameter for wmb_lwb0_data_addr, LTL@20241104
  wmb_lwb0_data_addr[`WK_PA_WIDTH-1:0] = {`WK_PA_WIDTH{1'b0}};
  for(int i=0;i<WMB_ENTRY;i++) begin
    wmb_lwb0_data_addr[`WK_PA_WIDTH-1:0] |= {`WK_PA_WIDTH{wmb_ld_wb_data_ptr[i]}}  & wmb_entry_addr[i][`WK_PA_WIDTH-1:0];
  end
end
//assign wmb_lwb0_data_iid[6:0]    = {7{wmb_ld_wb_data_ptr[0]}} & wmb_entry_iid_0[6:0]
//                                    | {7{wmb_ld_wb_data_ptr[1]}} & wmb_entry_iid_1[6:0]
//                                    | {7{wmb_ld_wb_data_ptr[2]}} & wmb_entry_iid_2[6:0]
//                                    | {7{wmb_ld_wb_data_ptr[3]}} & wmb_entry_iid_3[6:0]
//                                    | {7{wmb_ld_wb_data_ptr[4]}} & wmb_entry_iid_4[6:0]
//                                    | {7{wmb_ld_wb_data_ptr[5]}} & wmb_entry_iid_5[6:0]
//                                    | {7{wmb_ld_wb_data_ptr[6]}} & wmb_entry_iid_6[6:0]
//                                    | {7{wmb_ld_wb_data_ptr[7]}} & wmb_entry_iid_7[6:0];
always_comb begin  //parameter for wmb_lwb0_data_iid, LTL@20241104
  wmb_lwb0_data_iid[IID_WIDTH-1:0] = {IID_WIDTH{1'b0}};
  for(int i=0;i<WMB_ENTRY;i++) begin
    wmb_lwb0_data_iid[IID_WIDTH-1:0] |= {IID_WIDTH{wmb_ld_wb_data_ptr[i]}}  & wmb_entry_iid[i][IID_WIDTH-1:0];
  end
end
assign wmb_lwb0_data[127:1]         = 127'b0;
assign wmb_lwb0_vreg_sign_sel[14:0] = 15'h0001;
assign wmb_lwb0_inst_vls            = 1'b0;
assign wmb_lwb0_vmb_merge_vld       = 1'b0;
assign wmb_lwb0_data[0]          = !wmb_lwb0_data_success;
assign wmb_lwb0_data_success     = |(wmb_ld_wb_data_ptr[WMB_ENTRY-1:0]
                                      & wmb_entry_sc_wb_success[WMB_ENTRY-1:0]);


assign wmb_lswb0_data_req           = wmb_lwb0_data_req;                        //duplicate of lwb0 rather than tie 0, LTL@20250210
assign wmb_lswb0_preg               = wmb_lwb0_preg;
assign wmb_lswb0_data_addr          = wmb_lwb0_data_addr;   
assign wmb_lswb0_data_iid           = wmb_lwb0_data_iid;
assign wmb_lswb0_data[127:0]        = wmb_lwb0_data;
assign wmb_lswb0_vreg_sign_sel[14:0]= wmb_lwb0_vreg_sign_sel;
assign wmb_lswb0_inst_vls           = wmb_lwb0_inst_vls;
assign wmb_lswb0_vmb_merge_vld      = wmb_lwb0_vmb_merge_vld;          
assign wmb_lswb0_data_success       = 1'b0;  

assign wmb_lswb1_data_req           = wmb_lwb0_data_req;                        //duplicate of lwb0 rather than tie 0, LTL@20250210
assign wmb_lswb1_preg               = wmb_lwb0_preg;
assign wmb_lswb1_data_addr          = wmb_lwb0_data_addr;   
assign wmb_lswb1_data_iid           = wmb_lwb0_data_iid;
assign wmb_lswb1_data[127:0]        = wmb_lwb0_data;
assign wmb_lswb1_vreg_sign_sel[14:0]= wmb_lwb0_vreg_sign_sel;
assign wmb_lswb1_inst_vls           = wmb_lwb0_inst_vls;
assign wmb_lswb1_vmb_merge_vld      = wmb_lwb0_vmb_merge_vld;  
assign wmb_lswb1_data_success       = 1'b0;  
//don't expand sign
assign wmb_lwb0_preg_sign_sel[3:0] = 4'b0001;
assign wmb_lwb0_vreg[VREG-1:0] = {VREG{1'b0}};
assign wmb_lwb0_inst_vfls = 1'b0;

assign wmb_lswb0_preg_sign_sel[3:0] = 4'b0001;                         //duplicate of lwb0 rather than tie 0, LTL@20250210
assign wmb_lswb0_vreg[VREG-1:0] = {VREG{1'b0}};
assign wmb_lswb0_inst_vfls = 1'b0;

assign wmb_lswb1_preg_sign_sel[3:0] = 4'b0001;                         //duplicate of lwb0 rather than tie 0, LTL@20250210
assign wmb_lswb1_vreg[VREG-1:0] = {VREG{1'b0}};
assign wmb_lswb1_inst_vfls = 1'b0;
//-------------------atomic inst----------------------------
assign wmb_lswb0_atomic     = |(wmb_st_wb_cmplt_ptr[WMB_ENTRY-1:0]  & wmb_entry_atomic[WMB_ENTRY-1:0]); //wmb cmplt fix lswb0 pipe, LTL@20241024
assign wmb_lswb0_sc_wb_success    = |(wmb_st_wb_cmplt_ptr[WMB_ENTRY-1:0]  & wmb_entry_sc_wb_success[WMB_ENTRY-1:0]);
assign wmb_lm_already_read_req = |(wmb_st_wb_cmplt_ptr[WMB_ENTRY-1:0]  & wmb_entry_already_read_req[WMB_ENTRY-1:0]);
assign wmb_lm_state_clr     = wmb_lswb0_cmplt_req
                              &&  wmb_lswb0_atomic;
assign wmb_lm_success       = wmb_lswb0_sc_wb_success;
//-------------------data grnt------------------------------
assign wmb_entry_wb_data_grnt[WMB_ENTRY-1:0]  = {WMB_ENTRY{lwb0_wmb_ex3_data_grnt}}    //wmb write back tie lwb0, LTL@20241118
                                                & wmb_ld_wb_data_ptr[WMB_ENTRY-1:0];

//==========================================================
//            maintain restart wakeup queue
//==========================================================
//---------------------registers----------------------------
//+--------------+
//| wakeup_queue |
//+--------------+
//the queue stores the instructions waiting for wakeup
always @(posedge wmb_wakeup_queue_clk0 or negedge cpurst_b)  //3 wakeup queue, for 3 issue queue, LTL@20241104
begin
  if (!cpurst_b)
    wmb_wakeup_queue0[LSIQ_ENTRY-1:0]  <=  {LSIQ_ENTRY{1'b0}};  
  else if(rtu_yy_xx_flush)
    wmb_wakeup_queue0[LSIQ_ENTRY-1:0]  <=  {LSIQ_ENTRY{1'b0}};  
  else if(rtu_ck_flush)                                             //ck_flush send out all wakeup queue, ck_flush@LTL
    wmb_wakeup_queue0[LSIQ_ENTRY-1:0]  <=  {LSIQ_ENTRY{1'b0}}; 
  else if(lda0_wmb_ex3_discard_vld ||  wmb_pop_depd_ff)
    wmb_wakeup_queue0[LSIQ_ENTRY-1:0]  <=  wmb_wakeup_queue_next0[LSIQ_ENTRY-1:0];
end
always @(posedge wmb_wakeup_queue_clk1 or negedge cpurst_b)  //3 wakeup queue, for 3 issue queue, LTL@20241104
begin
  if (!cpurst_b)
    wmb_wakeup_queue1[LSIQ_ENTRY-1:0]  <=  {LSIQ_ENTRY{1'b0}};  
  else if(rtu_yy_xx_flush)
    wmb_wakeup_queue1[LSIQ_ENTRY-1:0]  <=  {LSIQ_ENTRY{1'b0}};  
  else if(rtu_ck_flush)   //ck_flush send out all wakeup queue, ck_flush@LTL
    wmb_wakeup_queue1[LSIQ_ENTRY-1:0]  <=  {LSIQ_ENTRY{1'b0}}; 
  else if(lsda0_wmb_ex3_discard_vld ||  wmb_pop_depd_ff)
    wmb_wakeup_queue1[LSIQ_ENTRY-1:0]  <=  wmb_wakeup_queue_next1[LSIQ_ENTRY-1:0];
end
always @(posedge wmb_wakeup_queue_clk2 or negedge cpurst_b)  //3 wakeup queue, for 3 issue queue, LTL@20241104
begin
  if (!cpurst_b)
    wmb_wakeup_queue2[LSIQ_ENTRY-1:0]  <=  {LSIQ_ENTRY{1'b0}};  
  else if(rtu_yy_xx_flush)
    wmb_wakeup_queue2[LSIQ_ENTRY-1:0]  <=  {LSIQ_ENTRY{1'b0}};  
  else if(rtu_ck_flush)   //ck_flush send out all wakeup queue, ck_flush@LTL
    wmb_wakeup_queue2[LSIQ_ENTRY-1:0]  <=  {LSIQ_ENTRY{1'b0}}; 
  else if(lsda1_wmb_ex3_discard_vld ||  wmb_pop_depd_ff)
    wmb_wakeup_queue2[LSIQ_ENTRY-1:0]  <=  wmb_wakeup_queue_next2[LSIQ_ENTRY-1:0];
end
//+-------------+
//| depd_pop_ff |
//+-------------+
//if depd pop, this will set to 1, and clear wakeup_queue next cycle
always @(posedge wmb_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    wmb_pop_depd_ff      <=  1'b0;
  else if(wmb_pop_depd  ||  wmb_pop_discard_req || wmb_pop_fwd_req)
    wmb_pop_depd_ff      <=  1'b1;
  else
    wmb_pop_depd_ff      <=  1'b0;
end
assign wmb_wakeup_queue_not_empty = wmb_wakeup_queue_not_empty0   //contain 3 cond. send to entry, LTL@20241104
                                    || wmb_wakeup_queue_not_empty1
                                    || wmb_wakeup_queue_not_empty2;
assign wmb_wakeup_queue_not_empty0 = |wmb_wakeup_queue0[LSIQ_ENTRY-1:0]; //1->3 for 3 wakeup queue, LTL@20241104
assign wmb_wakeup_queue_not_empty1 = |wmb_wakeup_queue1[LSIQ_ENTRY-1:0];
assign wmb_wakeup_queue_not_empty2 = |wmb_wakeup_queue2[LSIQ_ENTRY-1:0];
//------------------request---------------------------------
//------------wmb_pop_depd--------------
assign wmb_pop_depd       = |(wmb_entry_pop_vld[WMB_ENTRY-1:0]  & wmb_entry_depd[WMB_ENTRY-1:0]);
//---------interface to ld_dc-----------
assign wmb_discard_req0    = |wmb_entry_discard_req0[WMB_ENTRY-1:0];    //1->3 for 3 ld dc, LTL@20241104
assign wmb_discard_req1    = |wmb_entry_discard_req1[WMB_ENTRY-1:0];
assign wmb_discard_req2    = |wmb_entry_discard_req2[WMB_ENTRY-1:0];
assign wmb_ldc0_discard_req            = wmb_discard_req0;    //1->3 for 3 ld dc, LTL@20241104
assign wmb_lsdc0_discard_req            = wmb_discard_req1;
assign wmb_lsdc1_discard_req            = wmb_discard_req2;
assign wmb_fwd_req0                      = |wmb_entry_fwd_req0[WMB_ENTRY-1:0];
assign wmb_fwd_req1                      = |wmb_entry_fwd_req1[WMB_ENTRY-1:0];
assign wmb_fwd_req2                      = |wmb_entry_fwd_req2[WMB_ENTRY-1:0];
// &CombBeg; @1916
//always @( wmb_entry_fwd_bytes_vld0_6[15:0]
//       or wmb_entry_fwd_bytes_vld0_1[15:0]
//       or wmb_entry_fwd_data_pe_req0[7:0]
//       or wmb_entry_fwd_bytes_vld0_7[15:0]
//       or wmb_entry_fwd_bytes_vld0_0[15:0]
//       or wmb_entry_fwd_bytes_vld0_2[15:0]
//       or wmb_entry_fwd_bytes_vld0_3[15:0]
//       or wmb_entry_fwd_bytes_vld0_5[15:0]
//       or wmb_entry_fwd_bytes_vld0_4[15:0])
//begin
//case(wmb_entry_fwd_data_pe_req0[7:0])
//  8'h01:  wmb_fwd_bytes_vld[15:0] = wmb_entry_fwd_bytes_vld0_0[15:0];
//  8'h02:  wmb_fwd_bytes_vld[15:0] = wmb_entry_fwd_bytes_vld0_1[15:0];
//  8'h04:  wmb_fwd_bytes_vld[15:0] = wmb_entry_fwd_bytes_vld0_2[15:0];
//  8'h08:  wmb_fwd_bytes_vld[15:0] = wmb_entry_fwd_bytes_vld0_3[15:0];
//  8'h10:  wmb_fwd_bytes_vld[15:0] = wmb_entry_fwd_bytes_vld0_4[15:0];
//  8'h20:  wmb_fwd_bytes_vld[15:0] = wmb_entry_fwd_bytes_vld0_5[15:0];
//  8'h40:  wmb_fwd_bytes_vld[15:0] = wmb_entry_fwd_bytes_vld0_6[15:0];
//  8'h80:  wmb_fwd_bytes_vld[15:0] = wmb_entry_fwd_bytes_vld0_7[15:0];
//  default:wmb_fwd_bytes_vld[15:0] = {16{1'bx}};
//endcase
//// &CombEnd; @1928
//end

always_comb begin    //parameter for wmb_fwd_bytes_vld, need consider first 1 from ptr0, and 1->3 LTL@20241104
  wmb_ldc0_fwd_bytes_vld[15:0] = {16{wmb_entry_fwd_data_pe_req0[0]}} & wmb_entry_fwd_bytes_vld0[0][15:0];
  find_one_from_zero_for_fwd_bytes0 = {WMB_ENTRY{1'b0}};
  for(int i=1;i<WMB_ENTRY;i++) begin
    for(int j=0; j<i; j++) begin
      find_one_from_zero_for_fwd_bytes0[i] = find_one_from_zero_for_fwd_bytes0[i] | wmb_entry_fwd_data_pe_req0[j];
    end
      wmb_ldc0_fwd_bytes_vld[15:0] |= {16{wmb_entry_fwd_data_pe_req0[i] & (!find_one_from_zero_for_fwd_bytes0[i])}} & wmb_entry_fwd_bytes_vld0[i][15:0];
  end  
end

always_comb begin    //parameter for wmb_fwd_bytes_vld, need consider first 1 from ptr0, and 1->3 LTL@20241104
  wmb_lsdc0_fwd_bytes_vld[15:0] = {16{wmb_entry_fwd_data_pe_req1[0]}} & wmb_entry_fwd_bytes_vld1[0][15:0];
  find_one_from_zero_for_fwd_bytes1 = {WMB_ENTRY{1'b0}};
  for(int i=1;i<WMB_ENTRY;i++) begin
    for(int j=0; j<i; j++) begin
      find_one_from_zero_for_fwd_bytes1[i] = find_one_from_zero_for_fwd_bytes1[i] | wmb_entry_fwd_data_pe_req1[j];
    end
      wmb_lsdc0_fwd_bytes_vld[15:0] |= {16{wmb_entry_fwd_data_pe_req1[i] & (!find_one_from_zero_for_fwd_bytes1[i])}} & wmb_entry_fwd_bytes_vld1[i][15:0];
  end  
end

always_comb begin    //parameter for wmb_fwd_bytes_vld, need consider first 1 from ptr0, and 1->3 LTL@20241104
  wmb_lsdc1_fwd_bytes_vld[15:0] = {16{wmb_entry_fwd_data_pe_req2[0]}} & wmb_entry_fwd_bytes_vld2[0][15:0];
  find_one_from_zero_for_fwd_bytes2 = {WMB_ENTRY{1'b0}};
  for(int i=1;i<WMB_ENTRY;i++) begin
    for(int j=0; j<i; j++) begin
      find_one_from_zero_for_fwd_bytes2[i] = find_one_from_zero_for_fwd_bytes2[i] | wmb_entry_fwd_data_pe_req2[j];
    end
      wmb_lsdc1_fwd_bytes_vld[15:0] |= {16{wmb_entry_fwd_data_pe_req2[i] & (!find_one_from_zero_for_fwd_bytes2[i])}} & wmb_entry_fwd_bytes_vld2[i][15:0];
  end  
end


assign wmb_ldc0_fwd_req                 = wmb_fwd_req0;//1->3 for 3 ld dc, LTL@20241104
assign wmb_lsdc0_fwd_req                = wmb_fwd_req1;
assign wmb_lsdc1_fwd_req                = wmb_fwd_req2;
//assign wmb_ld_dc_fwd_id[WMB_ENTRY-1:0]  = wmb_entry_fwd_req0[WMB_ENTRY-1:0];
assign wmb_ldc0_cancel_acc_req          = |wmb_entry_cancel_acc_req0[WMB_ENTRY-1:0];
assign wmb_lsdc0_cancel_acc_req         = |wmb_entry_cancel_acc_req1[WMB_ENTRY-1:0];
assign wmb_lsdc1_cancel_acc_req         = |wmb_entry_cancel_acc_req2[WMB_ENTRY-1:0];
//---------interface to wmb_entry--------
//for timing, discard req and set write imme/depd signal, and set wakeup queue
//at next cycle

//assign wmb_entry_discard_grnt[WMB_ENTRY-1:0]  = {WMB_ENTRY{lda0_wmb_ex3_discard_vld}}
//                                                & wmb_entry_discard_req0[WMB_ENTRY-1:0];
//-------forward to depd_pop_ff-------
assign wmb_pop_discard_req  = |(wmb_entry_pop_vld[WMB_ENTRY-1:0]  & (wmb_entry_discard_req0[WMB_ENTRY-1:0]
                                                                    | wmb_entry_discard_req1[WMB_ENTRY-1:0]
                                                                    | wmb_entry_discard_req2[WMB_ENTRY-1:0]));  //discard_req 1 -> 3, LTL@20241104
assign wmb_pop_fwd_req      = |(wmb_entry_pop_vld[WMB_ENTRY-1:0]  & (wmb_entry_fwd_req0[WMB_ENTRY-1:0]     //fwd_req 1 -> 3, LTL@20241104
                                                                    | wmb_entry_fwd_req1[WMB_ENTRY-1:0]
                                                                    | wmb_entry_fwd_req2[WMB_ENTRY-1:0]));

//------------------update wakeup queue---------------------
assign wmb_wakeup_queue_grnt0[LSIQ_ENTRY-1:0]  = wmb_wakeup_queue0[LSIQ_ENTRY-1:0]   //1->4 for 4 iq, LTL@20241104, keep value
                                                | ({LSIQ_ENTRY{lda0_wmb_ex3_discard_vld}}  //discard is valid, add lda_lsid into wakeup queue, LTL@20241104
                                                  & lda0_ex3_lsid[LSIQ_ENTRY-1:0]);
assign wmb_wakeup_queue_grnt1[LSIQ_ENTRY-1:0]  = wmb_wakeup_queue1[LSIQ_ENTRY-1:0]
                                                | ({LSIQ_ENTRY{lsda0_wmb_ex3_discard_vld}}
                                                  & lsda0_ex3_lsid[LSIQ_ENTRY-1:0]);
assign wmb_wakeup_queue_grnt2[LSIQ_ENTRY-1:0]  = wmb_wakeup_queue2[LSIQ_ENTRY-1:0]
                                                | ({LSIQ_ENTRY{lsda1_wmb_ex3_discard_vld}}
                                                  & lsda1_ex3_lsid[LSIQ_ENTRY-1:0]);


assign wmb_wakeup_queue_next0[LSIQ_ENTRY-1:0]  = wmb_pop_depd_ff || rtu_ck_flush  //1-> 3,  next state, when wmb entry poped, clear wakeup queue, LTL@20241104
                                                ? {LSIQ_ENTRY{1'b0}}
                                                : wmb_wakeup_queue_grnt0[LSIQ_ENTRY-1:0];
assign wmb_wakeup_queue_next1[LSIQ_ENTRY-1:0]  = wmb_pop_depd_ff || rtu_ck_flush  //1-> 3,  next state, when wmb entry poped, clear wakeup queue, LTL@20241104
                                                ? {LSIQ_ENTRY{1'b0}}
                                                : wmb_wakeup_queue_grnt1[LSIQ_ENTRY-1:0];
assign wmb_wakeup_queue_next2[LSIQ_ENTRY-1:0]  = wmb_pop_depd_ff || rtu_ck_flush   //1-> 3,  next state, when wmb entry poped, clear wakeup queue, LTL@20241104
                                                ? {LSIQ_ENTRY{1'b0}}
                                                : wmb_wakeup_queue_grnt2[LSIQ_ENTRY-1:0];
//-------------------------wakeup---------------------------
assign wmb_depd_wakeup0[LSIQ_ENTRY-1:0]  = wmb_pop_depd_ff || rtu_ck_flush         //1-> 3,  when wmb entry poped, wakeup queue send to issue, LTL@20241104
                                          ? wmb_wakeup_queue_grnt0[LSIQ_ENTRY-1:0]
                                          : {LSIQ_ENTRY{1'b0}};
assign wmb_depd_wakeup1[LSIQ_ENTRY-1:0]  = wmb_pop_depd_ff || rtu_ck_flush         //1-> 3,  when wmb entry poped, wakeup queue send to issue, LTL@20241104
                                          ? wmb_wakeup_queue_grnt1[LSIQ_ENTRY-1:0]
                                          : {LSIQ_ENTRY{1'b0}};
assign wmb_depd_wakeup2[LSIQ_ENTRY-1:0]  = wmb_pop_depd_ff || rtu_ck_flush         //1-> 3,  when wmb entry poped, wakeup queue send to issue, LTL@20241104
                                          ? wmb_wakeup_queue_grnt2[LSIQ_ENTRY-1:0]
                                          : {LSIQ_ENTRY{1'b0}};
//==========================================================
//                Monitor biu b channel
//==========================================================
//assign wmb_b_nc_id_hit    = biu_lsu_b_vld
//                            &&  (biu_lsu_b_id[4:0]  ==  BIU_B_NC_ID);
assign wmb_b_so_id_hit    = biu_lsu_b_vld
                            &&  (biu_lsu_b_id[4:0]  ==  BIU_B_SO_ID);
assign wmb_b_resp_exokay  = biu_lsu_b_resp[1:0] ==  EXOKAY;

//==========================================================
//              Forward data to ld_da
//==========================================================
always @(posedge wmb_fwd_data_pe_clk0 or negedge cpurst_b)    //1->3 for 3 ld, LTL@2024114
begin
  if (!cpurst_b)
    wmb_fwd_data0[127:0]   <=  128'd0;
  else if(wmb_fwd_data_pe_req0)
    wmb_fwd_data0[127:0]   <=  wmb_fwd_data_sel0[127:0];
end
always @(posedge wmb_fwd_data_pe_clk1 or negedge cpurst_b)
begin
  if (!cpurst_b)
    wmb_fwd_data1[127:0]   <=  128'd0;
  else if(wmb_fwd_data_pe_req1)
    wmb_fwd_data1[127:0]   <=  wmb_fwd_data_sel1[127:0];
end
always @(posedge wmb_fwd_data_pe_clk2 or negedge cpurst_b)
begin
  if (!cpurst_b)
    wmb_fwd_data2[127:0]   <=  128'd0;
  else if(wmb_fwd_data_pe_req2)
    wmb_fwd_data2[127:0]   <=  wmb_fwd_data_sel2[127:0];
end



assign wmb_fwd_data_pe_req0  = (|wmb_entry_fwd_data_pe_req0[WMB_ENTRY-1:0])  //fwd 1->3 for 3 ld_dc, LTL@20241104
                              &&  ldc0_ex2_chk_ld_inst_vld
                              &&  !lda0_ex3_fwd_ecc_stall;
assign wmb_fwd_data_pe_req1  = (|wmb_entry_fwd_data_pe_req1[WMB_ENTRY-1:0])
                              &&  lsdc0_ex2_chk_ld_inst_vld
                              &&  !lsda0_ex3_fwd_ecc_stall;
assign wmb_fwd_data_pe_req2  = (|wmb_entry_fwd_data_pe_req2[WMB_ENTRY-1:0])
                              &&  lsdc1_ex2_chk_ld_inst_vld
                              &&  !lsda1_ex3_fwd_ecc_stall;                                                                                          
assign wmb_fwd_data_pe_gateclk_en0 = (|wmb_entry_fwd_data_pe_gateclk_en0[WMB_ENTRY-1:0]) //fwd 1->3 for 3 ld_dc, LTL@20241104
                                    &&  ldc0_ex2_chk_ld_inst_vld;
assign wmb_fwd_data_pe_gateclk_en1 = (|wmb_entry_fwd_data_pe_gateclk_en1[WMB_ENTRY-1:0])
                                    &&  lsdc0_ex2_chk_ld_inst_vld;
assign wmb_fwd_data_pe_gateclk_en2 = (|wmb_entry_fwd_data_pe_gateclk_en2[WMB_ENTRY-1:0])
                                    &&  lsdc1_ex2_chk_ld_inst_vld;                                                                                                            
// &CombBeg; @1982
//always @( wmb_entry_data_4[127:0]                    //canshuhua,  LTL@20241104
//       or wmb_entry_data_7[127:0]
//       or wmb_entry_data_5[127:0]
//       or wmb_entry_fwd_data_pe_req[7:0]
//       or wmb_entry_data_1[127:0]
//       or wmb_entry_data_2[127:0]
//       or wmb_entry_data_0[127:0]
//       or wmb_entry_data_3[127:0]
//       or wmb_entry_data_6[127:0])
//begin
//case(wmb_entry_fwd_data_pe_req[7:0])    //at most one value is 1, same address will merge, LTL@20241024
//  8'h01:  wmb_fwd_data_sel[127:0] = wmb_entry_data_0[127:0];
//  8'h02:  wmb_fwd_data_sel[127:0] = wmb_entry_data_1[127:0];
//  8'h04:  wmb_fwd_data_sel[127:0] = wmb_entry_data_2[127:0];
//  8'h08:  wmb_fwd_data_sel[127:0] = wmb_entry_data_3[127:0];
//  8'h10:  wmb_fwd_data_sel[127:0] = wmb_entry_data_4[127:0];
//  8'h20:  wmb_fwd_data_sel[127:0] = wmb_entry_data_5[127:0];
//  8'h40:  wmb_fwd_data_sel[127:0] = wmb_entry_data_6[127:0];
//  8'h80:  wmb_fwd_data_sel[127:0] = wmb_entry_data_7[127:0];
//  default:wmb_fwd_data_sel[127:0] = {128{1'bx}};
//endcase
//// &CombEnd; @1994
//end

always_comb begin    //parameter for wmb_fwd_data_sel0, need consider first 1 from ptr0, and 1->4 LTL@20241104
  wmb_fwd_data_sel0[127:0] = {128{wmb_entry_fwd_data_pe_req0[0]}} & wmb_entry_data[0][127:0];
  find_one_from_zero_for_fwd_data0 = {WMB_ENTRY{1'b0}};
  for(int i=1;i<WMB_ENTRY;i++) begin
    for(int j=0; j<i; j++) begin
      find_one_from_zero_for_fwd_data0[i] = find_one_from_zero_for_fwd_data0[i] | wmb_entry_fwd_data_pe_req0[j];
    end
      wmb_fwd_data_sel0[127:0] |= {128{wmb_entry_fwd_data_pe_req0[i] & (!find_one_from_zero_for_fwd_data0[i])}} & wmb_entry_data[i][127:0];
  end  
end
always_comb begin    //parameter for wmb_fwd_data_sel1, need consider first 1 from ptr0, and 1->4 LTL@20241104
  wmb_fwd_data_sel1[127:0] = {128{wmb_entry_fwd_data_pe_req1[0]}} & wmb_entry_data[0][127:0];
  find_one_from_zero_for_fwd_data1 = {WMB_ENTRY{1'b0}};
  for(int i=1;i<WMB_ENTRY;i++) begin
    for(int j=0; j<i; j++) begin
      find_one_from_zero_for_fwd_data1[i] = find_one_from_zero_for_fwd_data1[i] | wmb_entry_fwd_data_pe_req1[j];
    end
      wmb_fwd_data_sel1[127:0] |= {128{wmb_entry_fwd_data_pe_req1[i] & (!find_one_from_zero_for_fwd_data1[i])}} & wmb_entry_data[i][127:0];
  end  
end
always_comb begin    //parameter for wmb_fwd_data_sel2, need consider first 1 from ptr0, and 1->4 LTL@20241104
  wmb_fwd_data_sel2[127:0] = {128{wmb_entry_fwd_data_pe_req2[0]}} & wmb_entry_data[0][127:0];
  find_one_from_zero_for_fwd_data2 = {WMB_ENTRY{1'b0}};
  for(int i=1;i<WMB_ENTRY;i++) begin
    for(int j=0; j<i; j++) begin
      find_one_from_zero_for_fwd_data2[i] = find_one_from_zero_for_fwd_data2[i] | wmb_entry_fwd_data_pe_req2[j];
    end
      wmb_fwd_data_sel2[127:0] |= {128{wmb_entry_fwd_data_pe_req2[i] & (!find_one_from_zero_for_fwd_data2[i])}} & wmb_entry_data[i][127:0];
  end  
end


assign wmb_lda0_fwd_data[127:0]   = wmb_fwd_data0[127:0];  //1->3 for 3 ld_dc, LTL@20241104
assign wmb_lsda0_fwd_data[127:0]  = wmb_fwd_data1[127:0];
assign wmb_lsda1_fwd_data[127:0]  = wmb_fwd_data2[127:0];
//==========================================================
//                      Hit index
//==========================================================
assign wmb_pfu_biu_req_hit_idx      = |wmb_entry_pfu_biu_req_hit_idx[WMB_ENTRY-1:0];
assign wmb_snq_depd[WMB_ENTRY-1:0]  = wmb_entry_snq_depd[WMB_ENTRY-1:0];

assign wmb_snq_depd_remove[WMB_ENTRY-1:0]  = wmb_entry_snq_depd_remove[WMB_ENTRY-1:0];

//hit cache line signal
assign wmb_rb_biu_req_hit_idx     = |wmb_entry_rb_biu_req_hit_idx[WMB_ENTRY-1:0];

//==========================================================
//                        pend addr
//==========================================================
assign wmb_pend_entry[WMB_ENTRY-1:0]  = wmb_entry_aw_pending[WMB_ENTRY-1:0]
                                        & ~wmb_entry_sync_fence[WMB_ENTRY-1:0];

// &ConnRule(s/xxsource/wmb/); @2014
// &Instance("xx_lsu_pend_addr_sel","x_xx_lsu_wmb_pend_addr_sel"); @2015
xx_lsu_pend_addr_sel  x_xx_lsu_wmb_pend_addr_sel (
  .cp0_lsu_icg_en          (cp0_lsu_icg_en         ),
  .cpurst_b                (cpurst_b               ),
  .forever_cpuclk          (forever_cpuclk         ),
  .pad_yy_icg_scan_en      (pad_yy_icg_scan_en     ),
  .xxsource_entry_addr_0   (wmb_entry_addr[0]       ),
  .xxsource_entry_addr_1   (wmb_entry_addr[1]       ),
  .xxsource_entry_addr_2   (wmb_entry_addr[2]       ),
  .xxsource_entry_addr_3   (wmb_entry_addr[3]       ),
  .xxsource_entry_addr_4   (wmb_entry_addr[4]       ),
  .xxsource_entry_addr_5   (wmb_entry_addr[5]       ),
  .xxsource_entry_addr_6   (wmb_entry_addr[6]       ),
  .xxsource_entry_addr_7   (wmb_entry_addr[7]       ),
  .xxsource_entry_page_ca  (wmb_entry_page_ca      ),
  .xxsource_entry_page_so  (wmb_entry_page_so      ),
  .xxsource_has_pend       (wmb_has_pend           ),
  .xxsource_pend_addr_f    (wmb_pend_addr_f        ),
  .xxsource_pend_busy      (wmb_pend_busy          ),
  .xxsource_pend_entry     (wmb_pend_entry         ),
  .xxsource_pend_page_ca_f (wmb_pend_page_ca_f     ),
  .xxsource_pend_page_so_f (wmb_pend_page_so_f     )
);


//==========================================================
//              Interface to other module
//==========================================================
assign wmb_sync_fence_biu_req_success = |wmb_entry_sync_fence_biu_req_success[WMB_ENTRY-1:0];
//assign wmb_amr_cancel               = |wmb_entry_amr_cancel[WMB_ENTRY-1:0];
//assign wmb_amr_cancel_gateclk       = |wmb_entry_amr_cancel_gateclk[WMB_ENTRY-1:0];
assign wmb_has_sync_fence           = |(wmb_entry_vld[WMB_ENTRY-1:0]
                                        & wmb_entry_sync_fence_inst[WMB_ENTRY-1:0]);
assign wmb_no_op                    = |wmb_entry_no_op[WMB_ENTRY-1:0];


assign lsu_had_wmb_write_imme       = wmb_write_imme;
assign lsu_had_wmb_entry_vld[WMB_ENTRY-1:0]   = wmb_entry_vld[WMB_ENTRY-1:0];
assign lsu_had_wmb_ar_pending       = |wmb_entry_ar_pending[WMB_ENTRY-1:0];
assign lsu_had_wmb_aw_pending       = |wmb_entry_aw_pending[WMB_ENTRY-1:0];
assign lsu_had_wmb_w_pending        = |wmb_entry_w_pending[WMB_ENTRY-1:0];
assign lsu_had_wmb_create_ptr[WMB_ENTRY-1:0]  = wmb_create_ptr[WMB_ENTRY-1:0];
assign lsu_had_wmb_write_ptr[WMB_ENTRY-1:0]   = wmb_write_ptr[WMB_ENTRY-1:0];
assign lsu_had_wmb_read_ptr[WMB_ENTRY-1:0]    = wmb_read_ptr[WMB_ENTRY-1:0];
assign lsu_had_wmb_data_ptr[WMB_ENTRY-1:0]    = wmb_data_ptr[WMB_ENTRY-1:0];

//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
always_comb begin
  wmb_st_wb_halt_info_0[`TDT_MP_HINFO_WIDTH-1:0] = {`TDT_MP_HINFO_WIDTH{1'b0}};
  for(int i=0;i<WMB_ENTRY;i++) begin
    wmb_st_wb_halt_info_0[`TDT_MP_HINFO_WIDTH-1:0] |= {`TDT_MP_HINFO_WIDTH{wmb_entry_halt_info_0[i][0]}} & wmb_entry_halt_info_0[i][`TDT_MP_HINFO_WIDTH-1:0];
  end
end

always_comb begin
  wmb_st_wb_halt_info_1[`TDT_MP_HINFO_WIDTH-1:0] = {`TDT_MP_HINFO_WIDTH{1'b0}};
  for(int i=0;i<WMB_ENTRY;i++) begin
    wmb_st_wb_halt_info_1[`TDT_MP_HINFO_WIDTH-1:0] |= {`TDT_MP_HINFO_WIDTH{wmb_entry_halt_info_1[i][0]}} & wmb_entry_halt_info_1[i][`TDT_MP_HINFO_WIDTH-1:0];
  end
end
//==========================================================
//                  Risc-V Debug zdb End
//==========================================================
// &ModuleEnd; @2056
endmodule


