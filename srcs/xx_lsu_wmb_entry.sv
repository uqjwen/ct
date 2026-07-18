//-----------------------------------------------------------------------------
// File          : xx_lsu_wmb_entry.v
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

// &ModuleBeg; @33
module xx_lsu_wmb_entry #(
  parameter WMB_ENTRY = 8,
  parameter IID_WIDTH = 7,
  parameter PREG      = 7
)(
// &Ports; @34
input logic   [4  :0]                                   biu_lsu_b_id,                                     
input logic                                             biu_lsu_b_vld,                                    
input logic   [4  :0]                                   biu_lsu_r_id,                                     
input logic                                             biu_lsu_r_vld,                                    
input logic                                             bus_arb_wmb_aw_grnt,                              
input logic                                             bus_arb_wmb_w_grnt,                               
input logic                                             cp0_lsu_icg_en,                                   
input logic                                             cpurst_b,                                         
input logic   [15 :0]                                   dcache_dirty_din,   //8->15, L1D 2->4way, LTL@20250325                              
input logic                                             dcache_dirty_gwen,                                
input logic   [15 :0]                                   dcache_dirty_wen,   //8->15, L1D 2->4way, LTL@20250325                               
input logic   [7  :0]                                   dcache_idx,         //8->7, L1D 2->4way, LTL@20250325                               
input logic                                             dcache_snq_st_sel,                                
input logic   [`WK_LS_DCACHE_TAG_NOECC_WIDTH-1:0]       dcache_tag_din,     //51->103, L1D 2->4way, LTL@20250325                               
input logic                                             dcache_tag_gwen,                                  
input logic   [3  :0]                                   dcache_tag_wen,     //1->3, L1D 2->4way, LTL@20250325                              
input logic                                             dm_state_is_force_fail,                           
input logic                                             forever_cpuclk,                                   
input logic   [`WK_PA_WIDTH-1 :0]                       ldc0_ex2_addr0, //data depd, 1->3, LTL@20241104
input logic   [`WK_PA_WIDTH-1 :0]                       lsdc0_ex2_addr0,
input logic   [`WK_PA_WIDTH-1 :0]                       lsdc1_ex2_addr0,                                      
input logic   [7  :0]                                   ldc0_ex2_addr1_11to4,//data depd, 1->3, LTL@20241104 
input logic   [7  :0]                                   lsdc0_ex2_addr1_11to4,                             
input logic   [7  :0]                                   lsdc1_ex2_addr1_11to4,                               
input logic   [15 :0]                                   ldc0_ex2_bytes_vld, //data depd, 1->3, LTL@20241104
input logic   [15 :0]                                   lsdc0_ex2_bytes_vld,                               
input logic   [15 :0]                                   lsdc1_ex2_bytes_vld,                                  
input logic   [15 :0]                                   ldc0_ex2_bytes_vld1, //rvv512@LTL
input logic   [15 :0]                                   lsdc0_ex2_bytes_vld1,
input logic   [15 :0]                                   lsdc1_ex2_bytes_vld1,
input logic   [15 :0]                                   ldc0_ex2_bytes_vld2, //rvv512@LTL
input logic   [15 :0]                                   lsdc0_ex2_bytes_vld2,
input logic   [15 :0]                                   lsdc1_ex2_bytes_vld2,
input logic   [15 :0]                                   ldc0_ex2_bytes_vld3, //rvv512@LTL
input logic   [15 :0]                                   lsdc0_ex2_bytes_vld3,
input logic   [15 :0]                                   lsdc1_ex2_bytes_vld3,
input logic                                             ldc0_ex2_is_us, //rvv512@LTL
input logic                                             lsdc0_ex2_is_us,
input logic                                             lsdc1_ex2_is_us,    //rvv512@LTL
input logic                                             ldc0_ex2_chk_atomic_inst_vld,//data depd, 1->3, LTL@20241104
input logic                                             lsdc0_ex2_chk_atomic_inst_vld,
input logic                                             lsdc1_ex2_chk_atomic_inst_vld,                        
input logic                                             ldc0_ex2_chk_ld_inst_vld, //data depd, 1->3, LTL@20241104
input logic                                             lsdc0_ex2_chk_ld_inst_vld, 
input logic                                             lsdc1_ex2_chk_ld_inst_vld,                            
input logic                                             lm_state_is_ex_wait_lock,                         
input logic                                             lm_state_is_idle,                                 
input logic                                             pad_yy_icg_scan_en,                               
input logic   [`WK_PA_WIDTH-1 :0]                       pfu_biu_req_addr,                                 
input logic                                             pw_merge_stall,                                   
input logic   [`WK_PA_WIDTH-1 :0]                       rb_biu_req_addr,                                  
input logic                                             rb_biu_req_unmask,                                
input logic                                             rtu_lsu_async_flush,                              
input logic                                             snq_can_create_snq_uncheck,                       
input logic   [`WK_PA_WIDTH-1 :0]                       snq_create_addr,                                  
input logic   [`WK_PA_WIDTH-1 :0]                       sq_pop_addr,                                      
input logic   [15 :0]                                   sq_pop_bytes_vld,                                 
input logic   [1  :0]                                   sq_pop_priv_mode,                                 
input logic                                             sq_wmb_merge_req,                                 
input logic                                             sq_wmb_merge_stall_req,                           
input logic                                             vb_wmb_empty,                                     
input logic                                             vb_wmb_entry_rcl_done_x,                          
input logic                                             wmb_b_resp_exokay,                                
input logic   [4  :0]                                   wmb_biu_ar_id,                                    
input logic   [4  :0]                                   wmb_biu_aw_id,                                    
input logic                                             wmb_biu_write_en,                                 
input logic   [`WK_PA_WIDTH-1 :0]                       wmb_ce_addr,                                      
input logic                                             wmb_ce_atomic,                                                                   
input logic   [15 :0]                                   wmb_ce_bytes_vld,                                 
input logic                                             wmb_ce_bytes_vld_full,                            
input logic                                             wmb_ce_create_vld,                                
input logic   [127:0]                                   wmb_ce_data128,                                   
input logic   [3  :0]                                   wmb_ce_data_vld,                                  
input logic                                             wmb_ce_dcache_inst,                               
input logic                                             wmb_ce_dtcm_hit,                                  
input logic   [3  :0]                                   wmb_ce_fence_mode,                                
input logic                                             wmb_ce_icc,                                       
input logic   [PREG-1:0]                                wmb_ce_preg,
input logic   [IID_WIDTH-1:0]                           wmb_ce_iid,   //parameter, LTL@2024123                       
input logic                                             wmb_ce_inst_flush,                                
input logic   [1  :0]                                   wmb_ce_inst_mode,                                 
input logic   [2  :0]                                   wmb_ce_inst_size,                                 
input logic   [1  :0]                                   wmb_ce_inst_type,                                 
input logic                                             wmb_ce_itcm_hit,                                  
input logic                                             wmb_ce_last_addr_plus,                            
input logic                                             wmb_ce_last_addr_sub,                             
input logic                                             wmb_ce_merge_en,                                  
input logic                                             wmb_ce_page_buf,                                  
input logic                                             wmb_ce_page_ca,                                   
input logic                                             wmb_ce_page_sec,                                  
input logic                                             wmb_ce_page_share,                                
input logic                                             wmb_ce_page_so,                                   
input logic                                             wmb_ce_page_wa,                                   
input logic   [1  :0]                                   wmb_ce_priv_mode,                                 
input logic                                             wmb_ce_sc_wb_vld,                                 
input logic                                             wmb_ce_spec_fail,                                 
input logic                                             wmb_ce_sync_fence,                                
input logic                                             wmb_ce_update_dcache_dirty,                       
input logic                                             wmb_ce_update_dcache_page_share,                  
input logic                                             wmb_ce_update_dcache_share,                       
input logic                                             wmb_ce_update_dcache_valid,                       
input logic   [1  :0]                                   wmb_ce_update_dcache_way,      //1->2bit, L1D 2->4way, LTL@20250323                   
input logic                                             wmb_ce_update_same_dcache_line,                   
input logic   [WMB_ENTRY-1:0]                           wmb_ce_update_same_dcache_line_ptr,      //parameter, LTL@20241023         
input logic                                             wmb_ce_vstart_vld,                                
input logic                                             wmb_ce_wb_cmplt_success,                          
input logic                                             wmb_ce_wb_data_success,                           
input logic                                             wmb_ce_write_imme,                                
input logic                                             wmb_create_ptr_next1_x,                           
input logic                                             wmb_create_vb_success,                            
input logic                                             wmb_data_ptr_x,                                   
input logic                                             wmb_dcache_arb_req_unmask,                        
input logic                                             wmb_dcache_inst_write_req_hit_idx,                
input logic                                             wmb_dcache_req_ptr_x,                             
input logic                                             wmb_entry_create_data_vld_x,                      
input logic                                             wmb_entry_create_dp_vld_x,                        
input logic                                             wmb_entry_create_gateclk_en_x,                    
input logic                                             wmb_entry_create_vld_x,                           
input logic                                             wmb_entry_mem_set_write_gateclk_en_x,             
input logic                                             wmb_entry_mem_set_write_grnt_x,                   
input logic                                             wmb_entry_merge_data_vld_x,                       
input logic                                             wmb_entry_merge_data_wait_not_vld_req_x,          
input logic                                             wmb_entry_next_so_bypass_x,                       
input logic                                             wmb_entry_w_last_set_x,                           
input logic                                             wmb_entry_wb_cmplt_grnt_x,                        
input logic                                             wmb_entry_wb_data_grnt_x,                         
input logic                                             wmb_read_ptr_read_req_grnt,                       
input logic                                             wmb_read_ptr_shift_imme_grnt,                     
input logic                                             wmb_read_ptr_x,                                   
input logic   [WMB_ENTRY-1:0]                           wmb_same_line_resp_ready,   //parameter, LTL@20241023                      
input logic                                             wmb_tcm_grant,                                    
input logic                                             wmb_tcm_write_done_x,                             
input logic                                             wmb_wakeup_queue_not_empty,                       
input logic                                             wmb_write_biu_dcache_line,                        
input logic                                             wmb_write_dcache_success,                         
input logic                                             wmb_write_imme,                                   
input logic                                             wmb_write_ptr_shift_imme_grnt,                    
input logic                                             wmb_write_ptr_to_next3_x,                         
input logic                                             wmb_write_ptr_x,                                  
output logic  [`WK_PA_WIDTH-1 :0]                       wmb_entry_addr_v,                                 
output logic                                            wmb_entry_already_read_req_x,                     
output logic                                            wmb_entry_ar_pending_x,                           
output logic                                            wmb_entry_atomic_and_vld_x,                       
output logic                                            wmb_entry_atomic_x,                               
output logic                                            wmb_entry_aw_pending_x,                           
output logic  [4  :0]                                   wmb_entry_biu_id_v,                                                        
output logic  [15 :0]                                   wmb_entry_bytes_vld_v,                            
output logic                                            wmb_entry_cancel_acc_req0_x,  //1->4, LTL@20241024
output logic                                            wmb_entry_cancel_acc_req1_x,
output logic                                            wmb_entry_cancel_acc_req2_x,                                             
output logic                                            wmb_entry_data_biu_req_x,                         
output logic                                            wmb_entry_data_ptr_after_write_shift_imme_gate_x,  
output logic                                            wmb_entry_data_ptr_after_write_shift_imme_x,      
output logic                                            wmb_entry_data_ptr_with_write_shift_imme_x,       
output logic                                            wmb_entry_data_req_wns_x,                         
output logic                                            wmb_entry_data_req_x,                             
output logic  [127:0]                                   wmb_entry_data_v,                                 
output logic                                            wmb_entry_dcache_inst_same_line_x,                
output logic                                            wmb_entry_dcache_inst_x,                          
output logic                                            wmb_entry_dcache_page_share_x,                    
output logic                                            wmb_entry_dcache_dirty_x,
output logic                                            wmb_entry_dcache_share_x,
output logic                                            wmb_entry_dcache_valid_x,
output logic  [1  :0]                                   wmb_entry_dcache_way_x,    //1->2bit, L1D 2->4way, LTL@20250323                       
output logic                                            wmb_entry_depd_x,                                 
output logic                                            wmb_entry_discard_req0_x,  //fwd data, 1->3, LTL@20241104
output logic                                            wmb_entry_discard_req1_x,
output logic                                            wmb_entry_discard_req2_x,                        
output logic                                            wmb_entry_dtcm_hit_x,                             
output logic  [15 :0]                                   wmb_entry_fwd_bytes_vld0_v,  //fwd data, 1->3, LTL@20241104
output logic  [15 :0]                                   wmb_entry_fwd_bytes_vld1_v,
output logic  [15 :0]                                   wmb_entry_fwd_bytes_vld2_v,                  
output logic                                            wmb_entry_fwd_data_pe_gateclk_en0_x,  //fwd data, 1->3, LTL@20241104
output logic                                            wmb_entry_fwd_data_pe_gateclk_en1_x,
output logic                                            wmb_entry_fwd_data_pe_gateclk_en2_x,              
output logic                                            wmb_entry_fwd_data_pe_req0_x,  //fwd data, 1->3, LTL@20241104
output logic                                            wmb_entry_fwd_data_pe_req1_x,
output logic                                            wmb_entry_fwd_data_pe_req2_x,                     
output logic                                            wmb_entry_fwd_req0_x,  //fwd req, 1->3, LTL@20241104
output logic                                            wmb_entry_fwd_req1_x,
output logic                                            wmb_entry_fwd_req2_x,                             
output logic                                            wmb_entry_icc_and_vld_x,                          
output logic                                            wmb_entry_icc_x,                                  
output logic  [IID_WIDTH-1:0]                           wmb_entry_iid_v,                                  
output logic                                            wmb_entry_inst_flush_x,                           
output logic                                            wmb_entry_inst_is_dcache_x,                       
output logic  [1  :0]                                   wmb_entry_inst_mode_v,                            
output logic  [2  :0]                                   wmb_entry_inst_size_v,                            
output logic  [1  :0]                                   wmb_entry_inst_type_v,                            
output logic                                            wmb_entry_last_addr_plus_x,                       
output logic                                            wmb_entry_last_addr_sub_x,                        
output logic                                            wmb_entry_merge_data_addr_hit_x,                  
output logic                                            wmb_entry_merge_data_stall_x,                     
output logic                                            wmb_entry_no_op_x,                                
output logic                                            wmb_entry_page_buf_x,                             
output logic                                            wmb_entry_page_ca_x,                              
output logic                                            wmb_entry_page_sec_x,                             
output logic                                            wmb_entry_page_share_x,                           
output logic                                            wmb_entry_page_so_x,                              
output logic                                            wmb_entry_page_wa_x,                              
output logic                                            wmb_entry_pfu_biu_req_hit_idx_x,                  
output logic                                            wmb_entry_pop_vld_x,                              
output logic  [PREG-1  :0]                              wmb_entry_preg_v,                                 
output logic  [1  :0]                                   wmb_entry_priv_mode_v,                            
output logic                                            wmb_entry_rb_biu_req_hit_idx_x,                   
output logic                                            wmb_entry_read_dp_req_x,                          
output logic                                            wmb_entry_read_ptr_chk_idx_shift_imme_x,          
output logic                                            wmb_entry_read_ptr_unconditional_shift_imme_x,    
output logic                                            wmb_entry_read_req_x,                             
output logic                                            wmb_entry_read_resp_ready_x,                      
output logic                                            wmb_entry_ready_to_dcache_line_x,                 
output logic                                            wmb_entry_sc_wb_success_x,                        
output logic                                            wmb_entry_snq_depd_remove_x,                      
output logic                                            wmb_entry_snq_depd_x,                             
output logic                                            wmb_entry_spec_fail_x,                            
output logic                                            wmb_entry_sq_pop_sameline_set_x,                  
output logic                                            wmb_entry_st_hit_sq_pop_dcache_line_x,            
output logic                                            wmb_entry_sync_fence_biu_req_success_x,           
output logic                                            wmb_entry_sync_fence_inst_x,                      
output logic                                            wmb_entry_sync_fence_x,                           
output logic                                            wmb_entry_vld_x,                                  
output logic                                            wmb_entry_vstart_vld_x,                           
output logic                                            wmb_entry_w_last_x,                               
output logic                                            wmb_entry_w_pending_x,                            
output logic                                            wmb_entry_wb_cmplt_req_x,                         
output logic                                            wmb_entry_wb_data_req_x,                          
output logic                                            wmb_entry_write_biu_dp_req_x,                     
output logic                                            wmb_entry_write_biu_req_x,                        
output logic                                            wmb_entry_write_dcache_req_x,                     
output logic                                            wmb_entry_write_imme_bypass_x,                    
output logic                                            wmb_entry_write_imme_x,                           
output logic                                            wmb_entry_write_ptr_chk_idx_shift_imme_x,         
output logic                                            wmb_entry_write_ptr_unconditional_shift_imme_x,   
output logic                                            wmb_entry_write_req_x,                            
output logic                                            wmb_entry_write_stall_x,                          
output logic                                            wmb_entry_write_tcm_req_x,                        
output logic                                            wmb_entry_write_vb_req_x,
//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
input  logic                                            dtu_lsu_data_trig_en,
input  logic  [`TDT_MP_HINFO_WIDTH-1:0]                 wmb_ce_halt_info_0,
input  logic  [`TDT_MP_HINFO_WIDTH-1:0]                 wmb_ce_halt_info_1,
input  logic                                            wmb_ce_expt_vld,
output logic  [`TDT_MP_HINFO_WIDTH-1:0]                 wmb_entry_halt_info_0_v,
output logic  [`TDT_MP_HINFO_WIDTH-1:0]                 wmb_entry_halt_info_1_v
//==========================================================
//                  Risc-V Debug zdb End 
//==========================================================   
);

                       

// &Regs; @35
logic     [`WK_PA_WIDTH-1 :0]                           wmb_entry_addr;                                  
logic                                                   wmb_entry_already_read_req;                      
logic                                                   wmb_entry_atomic;                                
logic                                                   wmb_entry_biu_b_id_vld;                          
logic     [4  :0]                                       wmb_entry_biu_id;                                
logic                                                   wmb_entry_biu_r_id_vld;                                                   
logic     [15 :0]                                       wmb_entry_bytes_vld;                             
logic                                                   wmb_entry_bytes_vld_full;                        
logic     [127:0]                                       wmb_entry_data;                                  
logic                                                   wmb_entry_data_req_success;                      
logic                                                   wmb_entry_dcache_dirty;                          
logic                                                   wmb_entry_dcache_page_share;                     
logic                                                   wmb_entry_dcache_share;                          
logic                                                   wmb_entry_dcache_valid;                          
logic     [1  :0]                                       wmb_entry_dcache_way;      //1->2bit, L1D 2->4way, LTL@20250323                      
logic                                                   wmb_entry_depd;                                  
logic                                                   wmb_entry_dtcm_hit;                              
logic     [3  :0]                                       wmb_entry_fence_mode;                            
logic                                                   wmb_entry_icc;                                   
logic     [IID_WIDTH-1:0]                               wmb_entry_iid;                                   
logic                                                   wmb_entry_inst_flush;                            
logic                                                   wmb_entry_inst_is_dcache;                        
logic     [1  :0]                                       wmb_entry_inst_mode;                             
logic     [2  :0]                                       wmb_entry_inst_size;                             
logic     [1  :0]                                       wmb_entry_inst_type;                             
logic                                                   wmb_entry_itcm_hit;                              
logic                                                   wmb_entry_last_addr_plus;                        
logic                                                   wmb_entry_last_addr_sub;                         
logic                                                   wmb_entry_mem_set_req;                           
logic                                                   wmb_entry_merge_en;                              
logic                                                   wmb_entry_page_buf;                              
logic                                                   wmb_entry_page_ca;                               
logic                                                   wmb_entry_page_sec;                              
logic                                                   wmb_entry_page_share;                            
logic                                                   wmb_entry_page_so;                               
logic                                                   wmb_entry_page_wa;                               
logic     [1  :0]                                       wmb_entry_priv_mode;                             
logic                                                   wmb_entry_read_req_success;                      
logic                                                   wmb_entry_read_resp;                             
logic                                                   wmb_entry_same_dcache_line;                      
logic     [WMB_ENTRY-1:0]                               wmb_entry_same_dcache_line_ptr;                  
logic                                                   wmb_entry_sc_wb_success;                         
logic                                                   wmb_entry_sc_wb_vld;                             
logic                                                   wmb_entry_spec_fail;                             
logic                                                   wmb_entry_sync_fence;                            
logic                                                   wmb_entry_vld;                                   
logic                                                   wmb_entry_vstart_vld;                            
logic                                                   wmb_entry_w_last;                                
logic                                                   wmb_entry_wb_cmplt_success;                      
logic                                                   wmb_entry_wb_data_success;                       
logic                                                   wmb_entry_write_imme;                            
logic                                                   wmb_entry_write_req_success;                     
logic                                                   wmb_entry_write_resp;                            
logic                                                   wmb_entry_write_stall;                           

// &Wires; @36
                                                        
                                                                 
logic                                                   vb_wmb_entry_rcl_done;                                                                               
logic                                                   wmb_create_ptr_next1;                                                    
logic                                                   wmb_data_ptr;                                         
logic                                                   wmb_dcache_req_ptr;                                                        
logic    [15 :0]                                        wmb_entry_and_ldc0_bytes_vld;  //1->3 for 3 ld_dc, LTL@20241104
logic    [15 :0]                                        wmb_entry_and_lsdc0_bytes_vld;
logic    [15 :0]                                        wmb_entry_and_lsdc1_bytes_vld;                   
logic                                                   wmb_entry_and_ldc0_bytes_vld_hit;//1->3 for 3 ld_dc, LTL@20241104
logic                                                   wmb_entry_and_lsdc0_bytes_vld_hit;
logic                                                   wmb_entry_and_lsdc1_bytes_vld_hit;               
logic                                                   wmb_entry_and_ldc0_bytes_vld1_hit; //rvv512
logic                                                   wmb_entry_and_lsdc0_bytes_vld1_hit;//rvv512
logic                                                   wmb_entry_and_lsdc1_bytes_vld1_hit;//rvv512 
logic                                                   wmb_entry_and_ldc0_bytes_vld2_hit; //rvv512
logic                                                   wmb_entry_and_lsdc0_bytes_vld2_hit;//rvv512
logic                                                   wmb_entry_and_lsdc1_bytes_vld2_hit;//rvv512 
logic                                                   wmb_entry_and_ldc0_bytes_vld3_hit; //rvv512
logic                                                   wmb_entry_and_lsdc0_bytes_vld3_hit;//rvv512
logic                                                   wmb_entry_and_lsdc1_bytes_vld3_hit;//rvv512 
logic                                                   wmb_entry_ar_pending;                                          
logic                                                   wmb_entry_atomic_and_vld;                        
logic                                                   wmb_entry_aw_pending;                            
logic                                                   wmb_entry_b_id_hit;                              
logic                                                   wmb_entry_b_resp_vld;                            
logic                                                   wmb_entry_biu_b_id_vld_set;                      
logic                                                   wmb_entry_biu_id_clk;                            
logic                                                   wmb_entry_biu_id_clk_en;                         
logic                                                   wmb_entry_biu_r_id_vld_set;                      
logic    [15 :0]                                        wmb_entry_bytes_vld_and;                         
logic                                                   wmb_entry_bytes_vld_clk;                         
logic                                                   wmb_entry_bytes_vld_clk_en;                      
logic                                                   wmb_entry_bytes_vld_full_and;                    
logic                                                   wmb_entry_cancel_acc_req0;       //1->3 for 3 ld_dc, LTL@20241104                 
logic                                                   wmb_entry_cancel_acc_req1;
logic                                                   wmb_entry_cancel_acc_req2;
logic                                                   wmb_entry_clk;                                   
logic                                                   wmb_entry_clk_en;                                
logic                                                   wmb_entry_create_clk;                            
logic                                                   wmb_entry_create_clk_en;                         
logic    [3  :0]                                        wmb_entry_create_data;                           
logic                                                   wmb_entry_create_data_vld;                       
logic                                                   wmb_entry_create_dp_vld;                               
logic                                                   wmb_entry_create_gateclk_en;                            
logic                                                   wmb_entry_create_merge_data_gateclk_en;          
logic                                                   wmb_entry_create_vld;                            
logic                                                   wmb_entry_ctc_inst;                              
logic                                                   wmb_entry_data0_clk;                             
logic                                                   wmb_entry_data1_clk;                             
logic                                                   wmb_entry_data2_clk;                             
logic                                                   wmb_entry_data3_clk;                             
logic                                                   wmb_entry_data_biu_req;   
logic    [3  :0]                                        wmb_entry_data_clk_en;                           
logic    [127:0]                                        wmb_entry_data_next;                             
logic                                                   wmb_entry_data_ptr_after_write_shift_imme;       
logic                                                   wmb_entry_data_ptr_after_write_shift_imme_gate;  
logic                                                   wmb_entry_data_ptr_with_write_shift_imme;        
logic                                                   wmb_entry_data_req;                              
logic                                                   wmb_entry_data_req_success_set;                  
logic                                                   wmb_entry_data_req_wns;                                            
logic                                                   wmb_entry_dcache_1line_inst;                     
logic                                                   wmb_entry_dcache_addr_inst;                      
logic                                                   wmb_entry_dcache_addr_l1_inst;                   
logic                                                   wmb_entry_dcache_addr_not_l1_inst;               
logic                                                   wmb_entry_dcache_all_inst;                       
logic                                                   wmb_entry_dcache_clr_1line_inst;                 
logic                                                   wmb_entry_dcache_clr_addr_inst;                  
logic                                                   wmb_entry_dcache_clr_sw_inst;                    
logic                                                   wmb_entry_dcache_except_only_inv_1line_inst;     
logic                                                   wmb_entry_dcache_hit_idx;                        
logic                                                   wmb_entry_dcache_inst;                           
logic                                                   wmb_entry_dcache_inst_same_line;                        
logic                                                   wmb_entry_dcache_line_req;                       
logic                                                   wmb_entry_dcache_only_inv_1line_inst;            
logic                                                   wmb_entry_dcache_only_inv_addr_inst;             
logic                                                   wmb_entry_dcache_only_inv_sw_inst;                         
logic                                                   wmb_entry_dcache_sw_inst;                        
logic                                                   wmb_entry_dcache_update_vld;                     
logic                                                   wmb_entry_dcache_update_vld_unmask;                                 
logic                                                   wmb_entry_depd_addr1_11to4_hit0;   //1->3, for 3 ld_dc, LTL@20241104
logic                                                   wmb_entry_depd_addr1_11to4_hit1;
logic                                                   wmb_entry_depd_addr1_11to4_hit2;
logic                                                   wmb_entry_depd_addr1_tto4_hit0;   //1->3, for 3 ld_dc, LTL@20241104
logic                                                   wmb_entry_depd_addr1_tto4_hit1;
logic                                                   wmb_entry_depd_addr1_tto4_hit2;
logic                                                   wmb_entry_depd_addr_11to4_hit0;   //1->3, for 3 ld_dc, LTL@20241104
logic                                                   wmb_entry_depd_addr_11to4_hit1;
logic                                                   wmb_entry_depd_addr_11to4_hit2;                   
logic                                                   wmb_entry_depd_addr_tto12_hit0;   //1->3, for 3 ld_dc, LTL@20241104                  
logic                                                   wmb_entry_depd_addr_tto12_hit1;
logic                                                   wmb_entry_depd_addr_tto12_hit2;
logic                                                   wmb_entry_depd_addr_tto4_hit0;   //1->3, for 3 ld_dc, LTL@20241104
logic                                                   wmb_entry_depd_addr_tto4_hit1;                    
logic                                                   wmb_entry_depd_addr_tto4_hit2;
logic                                                   wmb_entry_depd_addr_tto6_hit0;//rvv512
logic                                                   wmb_entry_depd_addr_tto6_hit1;//rvv512
logic                                                   wmb_entry_depd_addr_tto6_hit2;//rvv512
logic                                                   wmb_entry_depd_do_hit0;   //1->3, for 3 ld_dc, LTL@20241104
logic                                                   wmb_entry_depd_do_hit1;
logic                                                   wmb_entry_depd_do_hit2;                         
logic                                                   wmb_entry_depd_hit1_0;  //1->3, for 3 ld_dc, LTL@20241104                           
logic                                                   wmb_entry_depd_hit2_0;  //1->3, for 3 ld_dc, LTL@20241104                           
logic                                                   wmb_entry_depd_hit3_0;  //1->3, for 3 ld_dc, LTL@20241104                           
logic                                                   wmb_entry_depd_hit5_0;  //1->3, for 3 ld_dc, LTL@20241104
logic                                                   wmb_entry_depd_hit1_1;                             
logic                                                   wmb_entry_depd_hit2_1;                             
logic                                                   wmb_entry_depd_hit3_1;                             
logic                                                   wmb_entry_depd_hit5_1;
logic                                                   wmb_entry_depd_hit1_2;                             
logic                                                   wmb_entry_depd_hit2_2;                             
logic                                                   wmb_entry_depd_hit3_2;                             
logic                                                   wmb_entry_depd_hit5_2;                            
logic                                                   wmb_entry_depd_hit4_0;//rvv512
logic                                                   wmb_entry_depd_hit4_1;//rvv512
logic                                                   wmb_entry_depd_hit4_2;//rvv512
logic                                                   wmb_entry_depd_whole_hit0;   //1->3, for 3 ld_dc, LTL@20241104                        
logic                                                   wmb_entry_depd_whole_hit1;
logic                                                   wmb_entry_depd_whole_hit2;
logic                                                   wmb_entry_discard_req0;   //1->3, for 3 ld_dc, LTL@20241104                      
logic                                                   wmb_entry_discard_req1;
logic                                                   wmb_entry_discard_req2;

logic    [15 :0]                                        wmb_entry_fwd_bytes_vld0;//1->3, for 3 ld_dc, LTL@20241104 
logic    [15 :0]                                        wmb_entry_fwd_bytes_vld1;
logic    [15 :0]                                        wmb_entry_fwd_bytes_vld2;                         
logic                                                   wmb_entry_fwd_data_pe_gateclk_en0;//1->3, for 3 ld_dc, LTL@20241104 
logic                                                   wmb_entry_fwd_data_pe_gateclk_en1;
logic                                                   wmb_entry_fwd_data_pe_gateclk_en2;             
logic                                                   wmb_entry_fwd_data_pe_req0;   //1->3, for 3 ld_dc, LTL@20241104 
logic                                                   wmb_entry_fwd_data_pe_req1;
logic                                                   wmb_entry_fwd_data_pe_req2;                     
logic                                                   wmb_entry_fwd_data_pre0;   //1->3, for 3 ld_dc, LTL@20241104 
logic                                                   wmb_entry_fwd_data_pre1;
logic                                                   wmb_entry_fwd_data_pre2;                        
logic                                                   wmb_entry_fwd_req0;   //1->3, for 3 ld_dc, LTL@20241104 
logic                                                   wmb_entry_fwd_req1;
logic                                                   wmb_entry_fwd_req2;                                   
logic                                                   wmb_entry_hit_sq_pop_addr_5to4;                  
logic                                                   wmb_entry_hit_sq_pop_addr_tto6;                  
logic                                                   wmb_entry_hit_sq_pop_bytes_vld;                  
logic                                                   wmb_entry_icc_and_vld;                                  
logic                                                   wmb_entry_idx_cmpare_inst;                       
logic                                                   wmb_entry_idx_snq_dep_inst;                                              
logic                                                   wmb_entry_mem_set_ptr;                           
logic                                                   wmb_entry_mem_set_write_gateclk_en;              
logic                                                   wmb_entry_mem_set_write_grnt;                    
logic    [3  :0]                                        wmb_entry_merge_data;                            
logic                                                   wmb_entry_merge_data_addr_hit;                   
logic                                                   wmb_entry_merge_data_grnt;                       
logic                                                   wmb_entry_merge_data_permit;                     
logic                                                   wmb_entry_merge_data_stall;                      
logic                                                   wmb_entry_merge_data_vld;                        
logic                                                   wmb_entry_merge_data_wait_not_vld_req;           
logic                                                   wmb_entry_merge_data_write_imme_set;             
logic                                                   wmb_entry_next_so_bypass;                                        
logic                                                   wmb_entry_no_op;                                                               
logic                                                   wmb_entry_not_and_ldc0_bytes_vld_hit;  //1->3, for 3 ld_dc, LTL@20241104  
logic                                                   wmb_entry_not_and_lsdc0_bytes_vld_hit;
logic                                                   wmb_entry_not_and_lsdc1_bytes_vld_hit;                                   
logic                                                   wmb_entry_page_ca_dcache_valid;                                          
logic                                                   wmb_entry_pfu_biu_req_hit_idx;                                 
logic                                                   wmb_entry_pop_vld;                                                       
logic    [PREG-1  :0]                                   wmb_entry_preg;                                                                                    
logic                                                   wmb_entry_r_id_hit;                              
logic                                                   wmb_entry_r_resp_vld;                            
logic                                                   wmb_entry_rb_biu_req_hit_idx;                                   
logic                                                   wmb_entry_read_dp_req;                                                  
logic                                                   wmb_entry_read_ptr_chk_idx_shift_imme;                 
logic                                                   wmb_entry_read_ptr_not_already_success;          
logic                                                   wmb_entry_read_ptr_shift_imme;                   
logic                                                   wmb_entry_read_ptr_unconditional_shift_imme;      
logic                                                   wmb_entry_read_req;                              
logic                                                   wmb_entry_read_req_success_set;                                            
logic                                                   wmb_entry_read_resp_not_write;                   
logic                                                   wmb_entry_read_resp_ready;                                        
logic                                                   wmb_entry_read_resp_set;                         
logic                                                   wmb_entry_ready_to_dcache_line;                               
logic                                                   wmb_entry_same_dcache_line_clr;                  
logic                                                   wmb_entry_same_dcache_line_ready;                
logic                                                   wmb_entry_sc_force_fail;                         
logic                                                   wmb_entry_sc_inst;                               
logic                                                   wmb_entry_sc_wb_set;                             
logic                                                   wmb_entry_sc_wb_success_set;                                      
logic                                                   wmb_entry_snq_create_addr_hit_idx;               
logic                                                   wmb_entry_snq_create_hit_idx;                    
logic                                                   wmb_entry_snq_depd;                              
logic                                                   wmb_entry_snq_depd_remove;                                                             
logic                                                   wmb_entry_snq_set_write_imme;                    
logic                                                   wmb_entry_so_st_inst;                                                   
logic                                                   wmb_entry_sq_pop_sameline_set;                          
logic                                                   wmb_entry_st_hit_sq_pop_dcache_line;                    
logic                                                   wmb_entry_st_inst;                               
logic                                                   wmb_entry_stamo_inst;                            
logic                                                   wmb_entry_sync_fence_biu_req_success;             
logic                                                   wmb_entry_sync_fence_inst;                                     
logic                                                   wmb_entry_tcm_hit;                               
logic                                                   wmb_entry_update_dcache_dirty;                   
logic                                                   wmb_entry_update_dcache_page_share;              
logic                                                   wmb_entry_update_dcache_share;                   
logic                                                   wmb_entry_update_dcache_valid;                   
logic   [1  :0]                                         wmb_entry_update_dcache_way;   //1->2bit, L1D 2->4way, LTL@20250323                  
logic                                                   wmb_entry_w_last_set;                                                            
logic                                                   wmb_entry_w_pending;                                     
logic                                                   wmb_entry_wb_cmplt_grnt;                                  
logic                                                   wmb_entry_wb_cmplt_req;                                  
logic                                                   wmb_entry_wb_data_grnt;                                       
logic                                                   wmb_entry_wb_data_req;                                               
logic                                                   wmb_entry_wo_st_inst;                            
logic                                                   wmb_entry_wo_st_write_biu_req;                   
logic                                                   wmb_entry_wo_st_write_tcm_req;                   
logic                                                   wmb_entry_write_biu_dp_req;                                        
logic                                                   wmb_entry_write_biu_req;                                             
logic                                                   wmb_entry_write_dcache_req;                                    
logic                                                   wmb_entry_write_imme_bypass;                                    
logic                                                   wmb_entry_write_imme_set;                                             
logic                                                   wmb_entry_write_ptr_chk_idx_shift_imme;              
logic                                                   wmb_entry_write_ptr_shift_imme;                  
logic                                                   wmb_entry_write_ptr_unconditional_shift_imme;      
logic                                                   wmb_entry_write_req;                             
logic                                                   wmb_entry_write_req_success_set;                                    
logic                                                   wmb_entry_write_resp_set;                                            
logic                                                   wmb_entry_write_tcm_req;                                         
logic                                                   wmb_entry_write_vb_req;                                            
logic                                                   wmb_read_ptr;                                                   
logic                                                   wmb_tcm_write_done;                                                                                       
logic                                                   wmb_write_ptr;                                                  

//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
logic                                                   wmb_entry_exec_cancel;
logic                                                   wmb_entry_expt_vld;
logic                                                   wmb_entry_vld_exec;                            
logic  [`TDT_MP_HINFO_WIDTH-1:0]                        wmb_entry_halt_info_0;
logic  [`TDT_MP_HINFO_WIDTH-1:0]                        wmb_entry_halt_info_1;
//==========================================================
//                  Risc-V Debug zdb End
//==========================================================

//parameter WMB_ENTRY = 8;   //define in front, LTL@20241024

//==========================================================
//                 Instance of Gated Cell  
//==========================================================
//----------entry gateclk---------------
assign wmb_entry_clk_en = wmb_entry_vld
                          ||  wmb_entry_create_gateclk_en;
// &Instance("gated_clk_cell", "x_lsu_wmb_entry_gated_clk"); @46
gated_clk_cell  x_lsu_wmb_entry_gated_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (wmb_entry_clk     ),
  .external_en        (1'b0              ),
  .local_en           (wmb_entry_clk_en  ),
  .module_en          (cp0_lsu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect(.clk_in        (forever_cpuclk     ), @47
//          .external_en   (1'b0               ), @48
//          .module_en     (cp0_lsu_icg_en     ), @49
//          .local_en      (wmb_entry_clk_en    ), @50
//          .clk_out       (wmb_entry_clk       )); @51

//-----------create gateclk-------------
assign wmb_entry_create_clk_en  = wmb_entry_create_gateclk_en;
// &Instance("gated_clk_cell", "x_lsu_wmb_entry_create_up_gated_clk"); @55
gated_clk_cell  x_lsu_wmb_entry_create_up_gated_clk (
  .clk_in                  (forever_cpuclk         ),
  .clk_out                 (wmb_entry_create_clk   ),
  .external_en             (1'b0                   ),
  .local_en                (wmb_entry_create_clk_en),
  .module_en               (cp0_lsu_icg_en         ),
  .pad_yy_icg_scan_en      (pad_yy_icg_scan_en     )
);

// &Connect(.clk_in        (forever_cpuclk     ), @56
//          .external_en   (1'b0               ), @57
//          .module_en     (cp0_lsu_icg_en     ), @58
//          .local_en      (wmb_entry_create_clk_en), @59
//          .clk_out       (wmb_entry_create_clk)); @60

//----------data gateclk----------------
// &Instance("gated_clk_cell", "x_lsu_wmb_entry_bytes_vld_gated_clk"); @63
gated_clk_cell  x_lsu_wmb_entry_bytes_vld_gated_clk (
  .clk_in                     (forever_cpuclk            ),
  .clk_out                    (wmb_entry_bytes_vld_clk   ),
  .external_en                (1'b0                      ),
  .local_en                   (wmb_entry_bytes_vld_clk_en),
  .module_en                  (cp0_lsu_icg_en            ),
  .pad_yy_icg_scan_en         (pad_yy_icg_scan_en        )
);

// &Connect(.clk_in        (forever_cpuclk     ), @64
//          .external_en   (1'b0               ), @65
//          .module_en     (cp0_lsu_icg_en     ), @66
//          .local_en      (wmb_entry_bytes_vld_clk_en), @67
//          .clk_out       (wmb_entry_bytes_vld_clk)); @68

// &Instance("gated_clk_cell", "x_lsu_wmb_entry_data0_gated_clk"); @70
gated_clk_cell  x_lsu_wmb_entry_data0_gated_clk (
  .clk_in                   (forever_cpuclk          ),
  .clk_out                  (wmb_entry_data0_clk     ),
  .external_en              (1'b0                    ),
  .local_en                 (wmb_entry_data_clk_en[0]),
  .module_en                (cp0_lsu_icg_en          ),
  .pad_yy_icg_scan_en       (pad_yy_icg_scan_en      )
);

// &Connect(.clk_in        (forever_cpuclk     ), @71
//          .external_en   (1'b0               ), @72
//          .module_en     (cp0_lsu_icg_en     ), @73
//          .local_en      (wmb_entry_data_clk_en[0]), @74
//          .clk_out       (wmb_entry_data0_clk)); @75

// &Instance("gated_clk_cell", "x_lsu_wmb_entry_data1_gated_clk"); @77
gated_clk_cell  x_lsu_wmb_entry_data1_gated_clk (
  .clk_in                   (forever_cpuclk          ),
  .clk_out                  (wmb_entry_data1_clk     ),
  .external_en              (1'b0                    ),
  .local_en                 (wmb_entry_data_clk_en[1]),
  .module_en                (cp0_lsu_icg_en          ),
  .pad_yy_icg_scan_en       (pad_yy_icg_scan_en      )
);

// &Connect(.clk_in        (forever_cpuclk     ), @78
//          .external_en   (1'b0               ), @79
//          .module_en     (cp0_lsu_icg_en     ), @80
//          .local_en      (wmb_entry_data_clk_en[1]), @81
//          .clk_out       (wmb_entry_data1_clk)); @82

// &Instance("gated_clk_cell", "x_lsu_wmb_entry_data2_gated_clk"); @84
gated_clk_cell  x_lsu_wmb_entry_data2_gated_clk (
  .clk_in                   (forever_cpuclk          ),
  .clk_out                  (wmb_entry_data2_clk     ),
  .external_en              (1'b0                    ),
  .local_en                 (wmb_entry_data_clk_en[2]),
  .module_en                (cp0_lsu_icg_en          ),
  .pad_yy_icg_scan_en       (pad_yy_icg_scan_en      )
);

// &Connect(.clk_in        (forever_cpuclk     ), @85
//          .external_en   (1'b0               ), @86
//          .module_en     (cp0_lsu_icg_en     ), @87
//          .local_en      (wmb_entry_data_clk_en[2]), @88
//          .clk_out       (wmb_entry_data2_clk)); @89

// &Instance("gated_clk_cell", "x_lsu_wmb_entry_data3_gated_clk"); @91
gated_clk_cell  x_lsu_wmb_entry_data3_gated_clk (
  .clk_in                   (forever_cpuclk          ),
  .clk_out                  (wmb_entry_data3_clk     ),
  .external_en              (1'b0                    ),
  .local_en                 (wmb_entry_data_clk_en[3]),
  .module_en                (cp0_lsu_icg_en          ),
  .pad_yy_icg_scan_en       (pad_yy_icg_scan_en      )
);

// &Connect(.clk_in        (forever_cpuclk     ), @92
//          .external_en   (1'b0               ), @93
//          .module_en     (cp0_lsu_icg_en     ), @94
//          .local_en      (wmb_entry_data_clk_en[3]), @95
//          .clk_out       (wmb_entry_data3_clk)); @96

//biu_id_gate_clk
assign wmb_entry_biu_id_clk_en  = wmb_entry_create_gateclk_en
//                                  ||  vb_wmb_entry_rcl_done_gateclk_en
                                  ||  wmb_entry_read_req
                                  ||  wmb_entry_write_biu_req
                                  ||  wmb_entry_mem_set_write_gateclk_en
                                  ||  wmb_entry_r_id_hit
                                  ||  wmb_entry_b_id_hit;
// &Instance("gated_clk_cell", "x_lsu_wmb_entry_biu_id_gated_clk"); @106
gated_clk_cell  x_lsu_wmb_entry_biu_id_gated_clk (
  .clk_in                  (forever_cpuclk         ),
  .clk_out                 (wmb_entry_biu_id_clk   ),
  .external_en             (1'b0                   ),
  .local_en                (wmb_entry_biu_id_clk_en),
  .module_en               (cp0_lsu_icg_en         ),
  .pad_yy_icg_scan_en      (pad_yy_icg_scan_en     )
);

// &Connect(.clk_in        (forever_cpuclk     ), @107
//          .external_en   (1'b0               ), @108
//          .module_en     (cp0_lsu_icg_en     ), @109
//          .local_en      (wmb_entry_biu_id_clk_en), @110
//          .clk_out       (wmb_entry_biu_id_clk)); @111

//==========================================================
//                 Register
//==========================================================
//+-----------+
//| entry_vld |
//+-----------+
always @(posedge wmb_entry_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    wmb_entry_vld             <=  1'b0;
  else if(wmb_entry_pop_vld)
    wmb_entry_vld             <=  1'b0;
  else if(wmb_entry_create_vld)
    wmb_entry_vld             <=  1'b1;
end

//+-------------------------+
//| instruction information |
//+-------------------------+
always @(posedge wmb_entry_create_clk)
begin
  if(wmb_entry_create_dp_vld)
  begin
    wmb_entry_expt_vld        <=  wmb_ce_expt_vld; // Risc-V Debug zdb
    wmb_entry_sync_fence      <=  wmb_ce_sync_fence;
    wmb_entry_atomic          <=  wmb_ce_atomic;
    wmb_entry_icc             <=  wmb_ce_icc;
    wmb_entry_preg[PREG-1:0]  <=  wmb_ce_preg[PREG-1:0];
    wmb_entry_inst_flush      <=  wmb_ce_inst_flush;
    wmb_entry_inst_is_dcache  <=  wmb_ce_dcache_inst;
    wmb_entry_inst_type[1:0]  <=  wmb_ce_inst_type[1:0];
    wmb_entry_inst_size[2:0]  <=  wmb_ce_inst_size[2:0];
    wmb_entry_inst_mode[1:0]  <=  wmb_ce_inst_mode[1:0];
    wmb_entry_fence_mode[3:0] <=  wmb_ce_fence_mode[3:0];
    wmb_entry_iid[IID_WIDTH-1:0]   <=  wmb_ce_iid[IID_WIDTH-1:0];
    wmb_entry_priv_mode[1:0]  <=  wmb_ce_priv_mode[1:0];
    wmb_entry_page_share      <=  wmb_ce_page_share;
    wmb_entry_page_so         <=  wmb_ce_page_so;
    wmb_entry_page_ca         <=  wmb_ce_page_ca;
    wmb_entry_page_wa         <=  wmb_ce_page_wa;
    wmb_entry_page_buf        <=  wmb_ce_page_buf;
    wmb_entry_page_sec        <=  wmb_ce_page_sec;
    wmb_entry_merge_en        <=  wmb_ce_merge_en;
    wmb_entry_addr[`WK_PA_WIDTH-1:0] <=  wmb_ce_addr[`WK_PA_WIDTH-1:0];
    wmb_entry_spec_fail       <=  wmb_ce_spec_fail;
    wmb_entry_vstart_vld      <=  wmb_ce_vstart_vld;
    wmb_entry_dtcm_hit        <=  wmb_ce_dtcm_hit;
    wmb_entry_itcm_hit        <=  wmb_ce_itcm_hit;
  end
end

assign wmb_entry_tcm_hit = wmb_entry_dtcm_hit | wmb_entry_itcm_hit;
//+-------------------+
//| cache_information |
//+-------------------+
always @(posedge wmb_entry_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    wmb_entry_dcache_valid     <=  1'b0;
    wmb_entry_dcache_share     <=  1'b0;
    wmb_entry_dcache_dirty     <=  1'b0;
    wmb_entry_dcache_way       <=  2'b0;
    wmb_entry_dcache_page_share<=  1'b0;
  end
  else if(wmb_entry_create_dp_vld)
  begin
    wmb_entry_dcache_valid     <=  wmb_ce_update_dcache_valid;
    wmb_entry_dcache_share     <=  wmb_ce_update_dcache_share;
    wmb_entry_dcache_dirty     <=  wmb_ce_update_dcache_dirty;
    wmb_entry_dcache_way       <=  wmb_ce_update_dcache_way;
    wmb_entry_dcache_page_share<=  wmb_ce_update_dcache_page_share;
  end
  else if(wmb_entry_dcache_update_vld)
  begin
    wmb_entry_dcache_valid     <=  wmb_entry_update_dcache_valid;
    wmb_entry_dcache_share     <=  wmb_entry_update_dcache_share;
    wmb_entry_dcache_dirty     <=  wmb_entry_update_dcache_dirty;
    wmb_entry_dcache_way       <=  wmb_entry_update_dcache_way;
    wmb_entry_dcache_page_share<=  wmb_entry_update_dcache_page_share;
  end
end

//+--------------------+
//| already merge grnt |
//+--------------------+
always @(posedge wmb_entry_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    wmb_entry_write_stall  <=  1'b0;
  else if(wmb_entry_merge_data_grnt
    &&  sq_wmb_merge_req
    &&  wmb_ce_create_vld)
    wmb_entry_write_stall  <=  1'b1;
  else
    wmb_entry_write_stall  <=  1'b0;
end

//+--------------------+
//| data and bytes_vld |
//+--------------------+
always @(posedge wmb_entry_bytes_vld_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    wmb_entry_bytes_vld_full  <=  1'b0;
    wmb_entry_bytes_vld[15:0] <=  16'b0;
  end
  else if(wmb_entry_create_dp_vld)
  begin
    wmb_entry_bytes_vld_full  <=  wmb_ce_bytes_vld_full;
    wmb_entry_bytes_vld[15:0] <=  wmb_ce_bytes_vld[15:0];
  end
  else if(wmb_entry_merge_data_vld)
  begin
    wmb_entry_bytes_vld_full  <=  wmb_entry_bytes_vld_full_and;
    wmb_entry_bytes_vld[15:0] <=  wmb_entry_bytes_vld_and[15:0];
  end
end

always @(posedge wmb_entry_data0_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    wmb_entry_data[31:0]      <=  32'b0;
  else if(wmb_entry_create_data[0] ||  wmb_entry_merge_data[0])
    wmb_entry_data[31:0]      <=  wmb_entry_data_next[31:0];
end

always @(posedge wmb_entry_data1_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    wmb_entry_data[63:32]     <=  32'b0;
  else if(wmb_entry_create_data[1] ||  wmb_entry_merge_data[1])
    wmb_entry_data[63:32]     <=  wmb_entry_data_next[63:32];
end

always @(posedge wmb_entry_data2_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    wmb_entry_data[95:64]     <=  32'b0;
  else if(wmb_entry_create_data[2] ||  wmb_entry_merge_data[2])
    wmb_entry_data[95:64]     <=  wmb_entry_data_next[95:64];
end

always @(posedge wmb_entry_data3_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    wmb_entry_data[127:96]    <=  32'b0;
  else if(wmb_entry_create_data[3] ||  wmb_entry_merge_data[3])
    wmb_entry_data[127:96]    <=  wmb_entry_data_next[127:96];
end

//------------------success/resp signal---------------------
//+------------------+
//| read_req_success |
//+------------------+
always @(posedge wmb_entry_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    wmb_entry_read_req_success  <=  1'b0;
  else if(wmb_entry_create_dp_vld)
    wmb_entry_read_req_success  <=  1'b0;
  else if(wmb_entry_read_req_success_set)
    wmb_entry_read_req_success  <=  1'b1;
end

//+-----------+
//| read_resp |
//+-----------+
always @(posedge wmb_entry_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    wmb_entry_read_resp         <=  1'b0;
  else if(wmb_entry_create_dp_vld)
    wmb_entry_read_resp         <=  1'b0;
  else if(wmb_entry_read_resp_set)
    wmb_entry_read_resp         <=  1'b1;
end

//+-------------------+
//| write_req_success |
//+-------------------+
always @(posedge wmb_entry_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    wmb_entry_write_req_success <=  1'b0;
  else if(wmb_entry_create_dp_vld)
    wmb_entry_write_req_success <=  1'b0;
  else if(wmb_entry_write_req_success_set)
    wmb_entry_write_req_success <=  1'b1;
end

//+-----------+
//| writ_resp |
//+-----------+
always @(posedge wmb_entry_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    wmb_entry_write_resp        <=  1'b0;
  else if(wmb_entry_create_dp_vld)
    wmb_entry_write_resp        <=  1'b0;
  else if(wmb_entry_write_resp_set)
    wmb_entry_write_resp        <=  1'b1;
end

//+------------------+
//| data_req_success |
//+------------------+
always @(posedge wmb_entry_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    wmb_entry_data_req_success  <=  1'b0;
  else if(wmb_entry_create_dp_vld)
    wmb_entry_data_req_success  <=  1'b0;
  else if(wmb_entry_data_req_success_set)
    wmb_entry_data_req_success  <=  1'b1;
end

//----------------------biu id signal-----------------------
//+--------+
//| biu_id |
//+--------+
always @(posedge wmb_entry_biu_id_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    wmb_entry_biu_id[4:0]       <=  5'b0;
//  else if(vb_wmb_entry_rcl_done)
//    wmb_entry_biu_id[4:0]       <=  vb_wmb_aw_id[4:0];
  else if(wmb_entry_read_req)
    wmb_entry_biu_id[4:0]       <=  wmb_biu_ar_id[4:0];
  else if(wmb_entry_write_biu_req ||  wmb_entry_mem_set_write_grnt)
    wmb_entry_biu_id[4:0]       <=  wmb_biu_aw_id[4:0];
end

//+------------+
//| biu_id_vld |
//+------------+
always @(posedge wmb_entry_biu_id_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    wmb_entry_biu_r_id_vld    <=  1'b0;
  else if(wmb_entry_create_dp_vld)
    wmb_entry_biu_r_id_vld    <=  1'b0;
  else if(wmb_entry_biu_r_id_vld_set)
    wmb_entry_biu_r_id_vld    <=  1'b1;
  else if(wmb_entry_r_resp_vld)
    wmb_entry_biu_r_id_vld    <=  1'b0;
end

always @(posedge wmb_entry_biu_id_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    wmb_entry_biu_b_id_vld      <=  1'b0;
  else if(wmb_entry_create_dp_vld)
    wmb_entry_biu_b_id_vld      <=  1'b0;
  else if(wmb_entry_biu_b_id_vld_set)
    wmb_entry_biu_b_id_vld      <=  1'b1;
  else if(wmb_entry_b_resp_vld)
    wmb_entry_biu_b_id_vld      <=  1'b0;
end

//+--------+
//| w_last |
//+--------+
always @(posedge wmb_entry_biu_id_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    wmb_entry_w_last            <=  1'b0;
  else if(wmb_entry_write_biu_req ||  wmb_entry_mem_set_write_grnt)
    wmb_entry_w_last            <=  wmb_entry_w_last_set;
end

//+-------------+
//| mem_set_req |
//+-------------+
always @(posedge wmb_entry_biu_id_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    wmb_entry_mem_set_req     <=  1'b0;
  else if(wmb_entry_create_dp_vld)
    wmb_entry_mem_set_req     <=  1'b0;
  else if(wmb_entry_mem_set_write_grnt)
    wmb_entry_mem_set_req     <=  wmb_write_biu_dcache_line;
end

//-------------cmplt/data req success signal----------------
//+------------------+
//| wb_cmplt_success |
//+------------------+
always @(posedge wmb_entry_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    wmb_entry_wb_cmplt_success  <=  1'b0;
  else if(wmb_entry_create_dp_vld)
    wmb_entry_wb_cmplt_success  <=  wmb_ce_wb_cmplt_success;
  else if(wmb_entry_wb_cmplt_grnt ||  rtu_lsu_async_flush)
    wmb_entry_wb_cmplt_success  <=  1'b1;
end

//+-----------------+
//| wb_data_success |
//+-----------------+
always @(posedge wmb_entry_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    wmb_entry_wb_data_success   <=  1'b0;
  else if(wmb_entry_create_dp_vld)
    wmb_entry_wb_data_success   <=  wmb_ce_wb_data_success;
  else if(wmb_entry_wb_data_grnt  ||  rtu_lsu_async_flush)
    wmb_entry_wb_data_success   <=  1'b1;
end

//------------same cache line write imme and depd-----------
//+-----------------+
//| same_dcache_line |
//+-----------------+
always @(posedge wmb_entry_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    wmb_entry_same_dcache_line  <=  1'b0;
  else if(wmb_entry_create_dp_vld)
    wmb_entry_same_dcache_line  <=  wmb_ce_update_same_dcache_line;
  else if(wmb_entry_same_dcache_line_clr)
    wmb_entry_same_dcache_line  <=  1'b0;
end

always @(posedge wmb_entry_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    wmb_entry_same_dcache_line_ptr[WMB_ENTRY-1:0]  <=  8'b0;
  else if(wmb_entry_create_dp_vld)
    wmb_entry_same_dcache_line_ptr[WMB_ENTRY-1:0]  <=  wmb_ce_update_same_dcache_line_ptr[WMB_ENTRY-1:0];
end
//+------------+
//| write_imme |
//+------------+
//if write req grnt, clear write imme
always @(posedge wmb_entry_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    wmb_entry_write_imme        <=  1'b0;
  else if(wmb_entry_create_dp_vld)
    wmb_entry_write_imme        <=  wmb_ce_write_imme;
  else if(wmb_entry_write_req_success_set)
    wmb_entry_write_imme        <=  1'b0;
  else if(wmb_entry_write_imme_set)
    wmb_entry_write_imme        <=  1'b1;
end

//+------+
//| depd |
//+------+
always @(posedge wmb_entry_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    wmb_entry_depd              <=  1'b0;
  else if(wmb_entry_create_dp_vld)
    wmb_entry_depd              <=  1'b0;
  else if(wmb_entry_discard_req0 ||  wmb_entry_fwd_req0   //1->3, for 3 ld_dc, LTL@20241104
          || wmb_entry_discard_req1 ||  wmb_entry_fwd_req1
          || wmb_entry_discard_req2 ||  wmb_entry_fwd_req2)
    wmb_entry_depd              <=  1'b1;
end

//----------------------stex signal-------------------------
//+-----------+---------------+
//| sc_wb_vld | sc_wb_success |
//+-----------+---------------+
always @(posedge wmb_entry_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    wmb_entry_sc_wb_vld         <=  1'b0;
    wmb_entry_sc_wb_success     <=  1'b0;
  end
  else if(wmb_entry_create_dp_vld)
  begin
    wmb_entry_sc_wb_vld         <=  wmb_ce_sc_wb_vld;
    wmb_entry_sc_wb_success     <=  1'b0;
  end
  else if(wmb_entry_sc_wb_set)
  begin
    wmb_entry_sc_wb_vld         <=  1'b1;
    wmb_entry_sc_wb_success     <=  wmb_entry_sc_wb_success_set;
  end
end

always @(posedge wmb_entry_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    wmb_entry_already_read_req  <=  1'b0;
  else if(wmb_entry_create_dp_vld)
    wmb_entry_already_read_req  <=  1'b0;
  else if(wmb_entry_read_req && wmb_read_ptr_read_req_grnt)
    wmb_entry_already_read_req  <=  1'b1;
end

//----------------------write burst judge signal-------------------------
//+-----------+----------+
//| addr_plus | addr_sub |
//+-----------+----------+
always @(posedge wmb_entry_create_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    wmb_entry_last_addr_plus         <=  1'b0;
    wmb_entry_last_addr_sub          <=  1'b0;
  end
  else if(wmb_entry_create_dp_vld)
  begin
    wmb_entry_last_addr_plus         <=  wmb_ce_last_addr_plus;
    wmb_entry_last_addr_sub          <=  wmb_ce_last_addr_sub;
  end
end
//==========================================================
//                  Create/merge signal
//==========================================================
//wmb_entry_hit_sq_pop_cache_line is used for same_dcache_line
// &Force("bus","sq_pop_addr","39","0"); @529
assign wmb_entry_hit_sq_pop_addr_tto6   = wmb_entry_addr[`WK_PA_WIDTH-1:6]  ==  sq_pop_addr[`WK_PA_WIDTH-1:6];
assign wmb_entry_hit_sq_pop_addr_5to4   = wmb_entry_addr[5:4]   ==  sq_pop_addr[5:4];
//assign wmb_entry_hit_sq_pop_addr_tto4   = wmb_entry_hit_sq_pop_addr_tto6
//                                          &&  wmb_entry_hit_sq_pop_addr_5to4;
assign wmb_entry_hit_sq_pop_bytes_vld   = |(wmb_entry_bytes_vld[15:0] & sq_pop_bytes_vld[15:0]);

assign wmb_entry_sq_pop_sameline_set    = wmb_entry_hit_sq_pop_addr_tto6
                                            &&  wmb_entry_st_inst
                                            &&  wmb_entry_vld;
assign wmb_entry_st_hit_sq_pop_dcache_line   = wmb_entry_hit_sq_pop_addr_tto6
                                            &&  (wmb_entry_st_inst || wmb_entry_atomic)
                                            &&  wmb_entry_vld;
assign wmb_entry_dcache_inst_same_line    = wmb_entry_hit_sq_pop_addr_tto6
                                            &&  wmb_entry_dcache_1line_inst
                                            &&  wmb_entry_vld;

//if supv mode or page info is not hit, then set write_imme and donot grnt
//signal to sq
assign wmb_entry_merge_data_addr_hit    = wmb_entry_hit_sq_pop_addr_tto6
                                          &&  (wmb_entry_mem_set_req || wmb_entry_dcache_line_req || wmb_entry_hit_sq_pop_addr_5to4) 
                                          &&  (!wmb_entry_dtcm_hit || wmb_entry_hit_sq_pop_bytes_vld)
                                          &&  wmb_entry_merge_en
                                          &&  wmb_entry_vld;

assign wmb_entry_merge_data_permit      = (wmb_entry_priv_mode[1:0]  ==  sq_pop_priv_mode[1:0])
                                          &&  !(wmb_entry_wo_st_write_biu_req
                                                ||  wmb_entry_dcache_line_req
                                                ||  wmb_entry_wo_st_write_tcm_req
                                                ||  wmb_entry_data_req
                                                ||  wmb_dcache_req_ptr
                                                    && (pw_merge_stall
                                                        || wmb_dcache_arb_req_unmask))
                                          &&  !wmb_entry_dtcm_hit
                                          &&  !wmb_entry_write_req_success
                                          &&  !wmb_entry_data_req_success
                                          &&  !dtu_lsu_data_trig_en; // Risc-V Debug zdb

assign wmb_entry_merge_data_stall       = wmb_entry_merge_data_addr_hit
                                          &&  !wmb_entry_merge_data_permit;

assign wmb_entry_merge_data_grnt        = wmb_entry_merge_data_addr_hit
                                          &&  wmb_entry_merge_data_permit;

assign wmb_entry_merge_data_write_imme_set  = wmb_entry_merge_data_addr_hit
                                              &&  sq_wmb_merge_stall_req;

assign wmb_entry_merge_data[3:0]        = {4{wmb_entry_merge_data_vld}}
                                          & wmb_ce_data_vld[3:0];

assign wmb_entry_create_data[3:0]       = {4{wmb_entry_create_data_vld}}
                                          & wmb_ce_data_vld[3:0];

assign wmb_entry_create_merge_data_gateclk_en = wmb_entry_create_gateclk_en
                                                ||  wmb_entry_merge_data_vld;

assign wmb_entry_data_clk_en[3:0]       = {4{wmb_entry_create_merge_data_gateclk_en}} 
                                          & wmb_ce_data_vld[3:0];
assign wmb_entry_bytes_vld_clk_en       = wmb_entry_create_merge_data_gateclk_en;

//------------------merge data------------------------------
assign wmb_entry_data_next[7:0]     = wmb_ce_bytes_vld[0]   ? wmb_ce_data128[7:0]
                                                            : wmb_entry_data[7:0];
assign wmb_entry_data_next[15:8]    = wmb_ce_bytes_vld[1]   ? wmb_ce_data128[15:8]
                                                            : wmb_entry_data[15:8];
assign wmb_entry_data_next[23:16]   = wmb_ce_bytes_vld[2]   ? wmb_ce_data128[23:16]
                                                            : wmb_entry_data[23:16];
assign wmb_entry_data_next[31:24]   = wmb_ce_bytes_vld[3]   ? wmb_ce_data128[31:24]
                                                            : wmb_entry_data[31:24];
assign wmb_entry_data_next[39:32]   = wmb_ce_bytes_vld[4]   ? wmb_ce_data128[39:32]
                                                            : wmb_entry_data[39:32];
assign wmb_entry_data_next[47:40]   = wmb_ce_bytes_vld[5]   ? wmb_ce_data128[47:40]
                                                            : wmb_entry_data[47:40];
assign wmb_entry_data_next[55:48]   = wmb_ce_bytes_vld[6]   ? wmb_ce_data128[55:48]
                                                            : wmb_entry_data[55:48];
assign wmb_entry_data_next[63:56]   = wmb_ce_bytes_vld[7]   ? wmb_ce_data128[63:56]
                                                            : wmb_entry_data[63:56];
assign wmb_entry_data_next[71:64]   = wmb_ce_bytes_vld[8]   ? wmb_ce_data128[71:64]
                                                            : wmb_entry_data[71:64];
assign wmb_entry_data_next[79:72]   = wmb_ce_bytes_vld[9]   ? wmb_ce_data128[79:72]
                                                            : wmb_entry_data[79:72];
assign wmb_entry_data_next[87:80]   = wmb_ce_bytes_vld[10]  ? wmb_ce_data128[87:80]
                                                            : wmb_entry_data[87:80];
assign wmb_entry_data_next[95:88]   = wmb_ce_bytes_vld[11]  ? wmb_ce_data128[95:88]
                                                            : wmb_entry_data[95:88];
assign wmb_entry_data_next[103:96]  = wmb_ce_bytes_vld[12]  ? wmb_ce_data128[103:96]
                                                            : wmb_entry_data[103:96];
assign wmb_entry_data_next[111:104] = wmb_ce_bytes_vld[13]  ? wmb_ce_data128[111:104]
                                                            : wmb_entry_data[111:104];
assign wmb_entry_data_next[119:112] = wmb_ce_bytes_vld[14]  ? wmb_ce_data128[119:112]
                                                            : wmb_entry_data[119:112];
assign wmb_entry_data_next[127:120] = wmb_ce_bytes_vld[15]  ? wmb_ce_data128[127:120]
                                                            : wmb_entry_data[127:120];
//------------------merge bytes_vld-------------------------
assign wmb_entry_bytes_vld_and[15:0]  = wmb_entry_bytes_vld[15:0]  | wmb_ce_bytes_vld[15:0];
assign wmb_entry_bytes_vld_full_and   = &wmb_entry_bytes_vld_and[15:0];

//----------ready to send dcache line of this entry---------
assign wmb_entry_ready_to_dcache_line = wmb_entry_vld
                                        &&  wmb_entry_wo_st_inst
                                        &&  wmb_entry_page_ca
                                        &&  wmb_entry_bytes_vld_full
                                        &&  !wmb_entry_write_req_success
                                        &&  wmb_entry_read_resp
                                        &&  !wmb_entry_dcache_valid;

//==========================================================
//        Generate inst type
//==========================================================
assign wmb_entry_atomic_and_vld   = wmb_entry_atomic
                                    &&  wmb_entry_vld;
assign wmb_entry_icc_and_vld      = wmb_entry_icc
                                    &&  wmb_entry_vld;

assign wmb_entry_sync_fence_inst  = !wmb_entry_atomic
                                    &&  wmb_entry_sync_fence;
assign wmb_entry_ctc_inst         = wmb_entry_icc
                                    &&  !wmb_entry_atomic
                                    &&  (wmb_entry_inst_type[1:0]  !=  2'b10);
assign wmb_entry_dcache_inst      = wmb_entry_inst_is_dcache;
assign wmb_entry_st_inst          = !wmb_entry_icc
                                    &&  !wmb_entry_atomic
                                    &&  !wmb_entry_sync_fence;
assign wmb_entry_wo_st_inst       = wmb_entry_st_inst
                                    &&  !wmb_entry_page_so;
assign wmb_entry_so_st_inst       = wmb_entry_st_inst
                                    &&  wmb_entry_page_so;
assign wmb_entry_stamo_inst       = wmb_entry_atomic
                                    &&  (wmb_entry_inst_type[1:0] == 2'b00);
assign wmb_entry_sc_inst          = wmb_entry_atomic
                                    &&  (wmb_entry_inst_type[1:0] == 2'b01);

assign wmb_entry_dcache_all_inst        = wmb_entry_dcache_inst
                                          &&  (wmb_entry_inst_mode[1:0]  ==  2'b00);
assign wmb_entry_dcache_1line_inst      = wmb_entry_dcache_inst
                                          &&  (wmb_entry_inst_mode[1:0]  !=  2'b00);
assign wmb_entry_dcache_addr_inst       = wmb_entry_dcache_inst
                                          &&  wmb_entry_inst_mode[0];
assign wmb_entry_dcache_sw_inst         = wmb_entry_dcache_inst
                                          &&  (wmb_entry_inst_mode[1:0]  ==  2'b10);
assign wmb_entry_dcache_clr_addr_inst   = wmb_entry_dcache_addr_inst
                                          &&  (wmb_entry_inst_size[1:0] !=  2'b10);
assign wmb_entry_dcache_clr_sw_inst     = wmb_entry_dcache_sw_inst
                                          &&  (wmb_entry_inst_size[1:0] !=  2'b10);
assign wmb_entry_dcache_clr_1line_inst  = wmb_entry_dcache_clr_addr_inst
                                          ||  wmb_entry_dcache_clr_sw_inst;
assign wmb_entry_dcache_addr_l1_inst    = wmb_entry_dcache_addr_inst
                                          &&  (wmb_entry_inst_size[1:0] ==  2'b00);
assign wmb_entry_dcache_addr_not_l1_inst    = wmb_entry_dcache_addr_inst
                                              &&  (wmb_entry_inst_size[1:0] !=  2'b00);
assign wmb_entry_dcache_only_inv_addr_inst  = wmb_entry_dcache_addr_inst
                                              &&  (wmb_entry_inst_size[1:0]  ==  2'b10);
assign wmb_entry_dcache_only_inv_sw_inst    = wmb_entry_dcache_sw_inst
                                              &&  (wmb_entry_inst_size[1:0]  ==  2'b10);
assign wmb_entry_dcache_only_inv_1line_inst = wmb_entry_dcache_only_inv_addr_inst
                                              ||  wmb_entry_dcache_only_inv_sw_inst;

assign wmb_entry_dcache_except_only_inv_1line_inst  = wmb_entry_dcache_inst
                                                      &&  !wmb_entry_dcache_only_inv_1line_inst;

//==========================================================
//            Compare dcache write port(dcwp)
//==========================================================
// &Force("nonport","wmb_entry_dcache_hit_idx"); @691
// &Instance("xx_lsu_dcache_info_update","x_lsu_wmb_entry_dcache_info_update"); @692
xx_lsu_dcache_info_update  x_lsu_wmb_entry_dcache_info_update (
  .compare_dcwp_addr                  (wmb_entry_addr[`WK_PA_WIDTH-1:0]              ),
  .compare_dcwp_hit_idx               (wmb_entry_dcache_hit_idx          ),
  .compare_dcwp_sw_inst               (wmb_entry_dcache_sw_inst          ),
  .compare_dcwp_update_vld            (wmb_entry_dcache_update_vld_unmask),
  .dcache_dirty_din                   (dcache_dirty_din                  ),
  .dcache_dirty_gwen                  (dcache_dirty_gwen                 ),
  .dcache_dirty_wen                   (dcache_dirty_wen                  ),
  .dcache_idx                         (dcache_idx                        ),
  .dcache_tag_din                     (dcache_tag_din                    ),
  .dcache_tag_gwen                    (dcache_tag_gwen                   ),
  .dcache_tag_wen                     (dcache_tag_wen                    ),
  .origin_dcache_dirty                (wmb_entry_dcache_dirty            ),
  .origin_dcache_page_share           (wmb_entry_dcache_page_share       ),
  .origin_dcache_share                (wmb_entry_dcache_share            ),
  .origin_dcache_valid                (wmb_entry_dcache_valid            ),
  .origin_dcache_way                  (wmb_entry_dcache_way              ),
  .update_dcache_dirty                (wmb_entry_update_dcache_dirty     ),
  .update_dcache_page_share           (wmb_entry_update_dcache_page_share),
  .update_dcache_share                (wmb_entry_update_dcache_share     ),
  .update_dcache_valid                (wmb_entry_update_dcache_valid     ),
  .update_dcache_way                  (wmb_entry_update_dcache_way       )
);

// &Connect( .compare_dcwp_addr          (wmb_entry_addr[`WK_PA_WIDTH-1:0]), @693
//           .compare_dcwp_sw_inst       (wmb_entry_dcache_sw_inst), @694
//           .origin_dcache_valid        (wmb_entry_dcache_valid ), @695
//           .origin_dcache_share        (wmb_entry_dcache_share ), @696
//           .origin_dcache_dirty        (wmb_entry_dcache_dirty ), @697
//           .origin_dcache_page_share   (wmb_entry_dcache_page_share ), @698
//           .origin_dcache_way          (wmb_entry_dcache_way   ), @699
//           .compare_dcwp_update_vld    (wmb_entry_dcache_update_vld_unmask), @700
//           .compare_dcwp_hit_idx       (wmb_entry_dcache_hit_idx), @701
//           .update_dcache_valid        (wmb_entry_update_dcache_valid), @702
//           .update_dcache_share        (wmb_entry_update_dcache_share), @703
//           .update_dcache_dirty        (wmb_entry_update_dcache_dirty), @704
//           .update_dcache_page_share   (wmb_entry_update_dcache_page_share), @705
//           .update_dcache_way          (wmb_entry_update_dcache_way  )); @706

assign wmb_entry_dcache_update_vld  = wmb_entry_dcache_update_vld_unmask
                                      &&  wmb_entry_vld;

//==========================================================
//                 Dependency check
//==========================================================

// situat ld pipe         sq/wmb          addr    bytes_vld data_vld  manner
// --------------------------------------------------------------------------
// 1      ld              st              :4      part      x         discard
// 2      ld atomic       any             x       x         x         discard
// 3      ld              atomic          :4      do        x         discard
// 4      ld              st              :4      whole     x         forward
// 5      ld(addr1)       st              :4      x         x         !acclr_en

//------------------compare signal--------------------------
//-----------addr compare---------------
//addr compare
// &Force("bus","ldc0_ex2_addr0",39,0); @726
assign wmb_entry_depd_addr_tto12_hit0  = wmb_entry_addr[`WK_PA_WIDTH-1:12] == ldc0_ex2_addr0[`WK_PA_WIDTH-1:12];  //1->3, for 3 ld_dc, LTL@20241104
assign wmb_entry_depd_addr_tto12_hit1  = wmb_entry_addr[`WK_PA_WIDTH-1:12] == lsdc0_ex2_addr0[`WK_PA_WIDTH-1:12];
assign wmb_entry_depd_addr_tto12_hit2  = wmb_entry_addr[`WK_PA_WIDTH-1:12] == lsdc1_ex2_addr0[`WK_PA_WIDTH-1:12];

assign wmb_entry_depd_addr_11to4_hit0  = wmb_entry_addr[11:4] == ldc0_ex2_addr0[11:4];  //1->3, for 3 ld_dc, LTL@20241104
assign wmb_entry_depd_addr_11to4_hit1  = wmb_entry_addr[11:4] == lsdc0_ex2_addr0[11:4];
assign wmb_entry_depd_addr_11to4_hit2  = wmb_entry_addr[11:4] == lsdc1_ex2_addr0[11:4];

assign wmb_entry_depd_addr1_11to4_hit0 = wmb_entry_addr[11:4] == ldc0_ex2_addr1_11to4[7:0];  //1->3, for 3 ld_dc, LTL@20241104
assign wmb_entry_depd_addr1_11to4_hit1 = wmb_entry_addr[11:4] == lsdc0_ex2_addr1_11to4[7:0];
assign wmb_entry_depd_addr1_11to4_hit2 = wmb_entry_addr[11:4] == lsdc1_ex2_addr1_11to4[7:0];

assign wmb_entry_depd_addr_tto4_hit0   = wmb_entry_depd_addr_tto12_hit0    //1->3, for 3 ld_dc, LTL@20241104
                                        &&  wmb_entry_depd_addr_11to4_hit0;
assign wmb_entry_depd_addr_tto4_hit1   = wmb_entry_depd_addr_tto12_hit1
                                        &&  wmb_entry_depd_addr_11to4_hit1;
assign wmb_entry_depd_addr_tto4_hit2   = wmb_entry_depd_addr_tto12_hit2
                                        &&  wmb_entry_depd_addr_11to4_hit2;

assign wmb_entry_depd_addr1_tto4_hit0  = wmb_entry_depd_addr_tto12_hit0     //1->3, for 3 ld_dc, LTL@20241104
                                        &&  wmb_entry_depd_addr1_11to4_hit0;
assign wmb_entry_depd_addr1_tto4_hit1  = wmb_entry_depd_addr_tto12_hit1
                                        &&  wmb_entry_depd_addr1_11to4_hit1;
assign wmb_entry_depd_addr1_tto4_hit2  = wmb_entry_depd_addr_tto12_hit2
                                        &&  wmb_entry_depd_addr1_11to4_hit2;

assign wmb_entry_depd_addr_tto6_hit0   = wmb_entry_depd_addr_tto12_hit0    //1->3, for 3 ld_dc, LTL@20241104
                                        &&  (wmb_entry_addr[11:6] == ldc0_ex2_addr0[11:6]);
assign wmb_entry_depd_addr_tto6_hit1   = wmb_entry_depd_addr_tto12_hit1
                                        &&  (wmb_entry_addr[11:6] == lsdc0_ex2_addr0[11:6]);
assign wmb_entry_depd_addr_tto6_hit2   = wmb_entry_depd_addr_tto12_hit2
                                        &&  (wmb_entry_addr[11:6] == lsdc1_ex2_addr0[11:6]);
//-----------bytes_vld compare----------

assign wmb_entry_and_ldc0_bytes_vld[15:0]    = wmb_entry_bytes_vld[15:0]  & ldc0_ex2_bytes_vld[15:0];   //1->3, for 3 ld_dc, LTL@20241104
assign wmb_entry_and_lsdc0_bytes_vld[15:0]   = wmb_entry_bytes_vld[15:0]  & lsdc0_ex2_bytes_vld[15:0]; 
assign wmb_entry_and_lsdc1_bytes_vld[15:0]   = wmb_entry_bytes_vld[15:0]  & lsdc1_ex2_bytes_vld[15:0]; 

assign wmb_entry_and_ldc0_bytes_vld_hit      = |wmb_entry_and_ldc0_bytes_vld[15:0];  //1->3, for 3 ld_dc, LTL@20241104
assign wmb_entry_and_lsdc0_bytes_vld_hit     = |wmb_entry_and_lsdc0_bytes_vld[15:0];
assign wmb_entry_and_lsdc1_bytes_vld_hit     = |wmb_entry_and_lsdc1_bytes_vld[15:0];

assign wmb_entry_not_and_ldc0_bytes_vld_hit  = |((~wmb_entry_bytes_vld[15:0]) & ldc0_ex2_bytes_vld[15:0]);  //1->3, for 3 ld_dc, LTL@20241104
assign wmb_entry_not_and_lsdc0_bytes_vld_hit  = |((~wmb_entry_bytes_vld[15:0]) & lsdc0_ex2_bytes_vld[15:0]);
assign wmb_entry_not_and_lsdc1_bytes_vld_hit  = |((~wmb_entry_bytes_vld[15:0]) & lsdc1_ex2_bytes_vld[15:0]);

assign wmb_entry_and_ldc0_bytes_vld1_hit      = |(wmb_entry_bytes_vld[15:0]  & ldc0_ex2_bytes_vld1[15:0]);//rvv512
assign wmb_entry_and_lsdc0_bytes_vld1_hit     = |(wmb_entry_bytes_vld[15:0]  & lsdc0_ex2_bytes_vld1[15:0]);//rvv512
assign wmb_entry_and_lsdc1_bytes_vld1_hit     = |(wmb_entry_bytes_vld[15:0]  & lsdc1_ex2_bytes_vld1[15:0]);//rvv512

assign wmb_entry_and_ldc0_bytes_vld2_hit      = |(wmb_entry_bytes_vld[15:0]  & ldc0_ex2_bytes_vld2[15:0]);//rvv512
assign wmb_entry_and_lsdc0_bytes_vld2_hit     = |(wmb_entry_bytes_vld[15:0]  & lsdc0_ex2_bytes_vld2[15:0]);//rvv512
assign wmb_entry_and_lsdc1_bytes_vld2_hit     = |(wmb_entry_bytes_vld[15:0]  & lsdc1_ex2_bytes_vld2[15:0]);//rvv512

assign wmb_entry_and_ldc0_bytes_vld3_hit      = |(wmb_entry_bytes_vld[15:0]  & ldc0_ex2_bytes_vld3[15:0]);//rvv512
assign wmb_entry_and_lsdc0_bytes_vld3_hit     = |(wmb_entry_bytes_vld[15:0]  & lsdc0_ex2_bytes_vld3[15:0]);//rvv512
assign wmb_entry_and_lsdc1_bytes_vld3_hit     = |(wmb_entry_bytes_vld[15:0]  & lsdc1_ex2_bytes_vld3[15:0]);//rvv512


//example:
//depd_bytes_vld          ldc0_ex2_bytes_vld     depd kinds
//1111                    0011                do & whole
//0011                    0011                do & whole
//0110                    0011                do & part
//0110                    1111                do & part
//1100                    0011                /

assign wmb_entry_depd_do_hit0      = wmb_entry_and_ldc0_bytes_vld_hit;  //1->3, for 3 ld_dc, LTL@20241104
assign wmb_entry_depd_do_hit1      = wmb_entry_and_lsdc0_bytes_vld_hit;
assign wmb_entry_depd_do_hit2      = wmb_entry_and_lsdc1_bytes_vld_hit;

assign wmb_entry_depd_whole_hit0   = wmb_entry_and_ldc0_bytes_vld_hit  //1->3, for 3 ld_dc, LTL@20241104
                                    &&  !wmb_entry_not_and_ldc0_bytes_vld_hit;
assign wmb_entry_depd_whole_hit1   = wmb_entry_and_lsdc0_bytes_vld_hit
                                    &&  !wmb_entry_not_and_lsdc0_bytes_vld_hit;
assign wmb_entry_depd_whole_hit2   = wmb_entry_and_lsdc1_bytes_vld_hit
                                    &&  !wmb_entry_not_and_lsdc1_bytes_vld_hit;                                                                        
//------------------cancel amr------------------------------
//assign wmb_entry_discard_amr_cancel_gateclk = wmb_entry_vld
//                                      &&  (ldc0_ex2_chk_ld_inst_vld  ||  ldc0_ex2_chk_atomic_inst_vld)
//                                      &&  (wmb_entry_addr[11:4]  ==  ldc0_ex2_addr0[11:4]);
//------------------fwd data pop entry----------------------
assign wmb_entry_fwd_data_pe_req0  = wmb_entry_vld_exec  // Risc-V Deubg zdb         //1->3, for 3 ld_dc, LTL@20241104
                                    &&  wmb_entry_wo_st_inst
                                    &&  wmb_entry_depd_addr_tto4_hit0
                                    && !ldc0_ex2_is_us  //rvv512@LTL
                                    && (wmb_entry_depd_whole_hit0 
                                        || !wmb_entry_dtcm_hit && wmb_entry_depd_do_hit0);
assign wmb_entry_fwd_data_pe_req1  = wmb_entry_vld_exec // Risc-V Deubg zdb
                                    &&  wmb_entry_wo_st_inst
                                    &&  wmb_entry_depd_addr_tto4_hit1
                                    && !lsdc0_ex2_is_us  //rvv512@LTL
                                    && (wmb_entry_depd_whole_hit1 
                                        || !wmb_entry_dtcm_hit && wmb_entry_depd_do_hit1);
assign wmb_entry_fwd_data_pe_req2  = wmb_entry_vld_exec // Risc-V Deubg zdb
                                    &&  wmb_entry_wo_st_inst
                                    &&  wmb_entry_depd_addr_tto4_hit2
                                    && !lsdc1_ex2_is_us  //rvv512@LTL
                                    && (wmb_entry_depd_whole_hit2 
                                        || !wmb_entry_dtcm_hit && wmb_entry_depd_do_hit2);


assign wmb_entry_fwd_data_pe_gateclk_en0 = wmb_entry_vld_exec // Risc-V Deubg zdb       //1->3, for 3 ld_dc, LTL@20241104
                                          &&  wmb_entry_wo_st_inst
                                          &&  wmb_entry_depd_addr_11to4_hit0;

assign wmb_entry_fwd_data_pe_gateclk_en1 = wmb_entry_vld_exec // Risc-V Deubg zdb
                                          &&  wmb_entry_wo_st_inst
                                          &&  wmb_entry_depd_addr_11to4_hit1
                                          && !lsdc0_ex2_is_us;  //rvv512@LTL

assign wmb_entry_fwd_data_pe_gateclk_en2 = wmb_entry_vld_exec // Risc-V Deubg zdb
                                          &&  wmb_entry_wo_st_inst
                                          &&  wmb_entry_depd_addr_11to4_hit2
                                          && !lsdc1_ex2_is_us;  //rvv512@LTL
                                                                                   
//------------------situation 1-----------------------------
assign wmb_entry_fwd_data_pre0     = wmb_entry_fwd_data_pe_req0        //1->3, for 3 ld_dc, LTL@20241104
                                    &&  ldc0_ex2_chk_ld_inst_vld
                                    && !ldc0_ex2_is_us;//rvv512@LTL
assign wmb_entry_fwd_data_pre1     = wmb_entry_fwd_data_pe_req1
                                    &&  lsdc0_ex2_chk_ld_inst_vld
                                    && !lsdc0_ex2_is_us;//rvv512@LTL
assign wmb_entry_fwd_data_pre2     = wmb_entry_fwd_data_pe_req2
                                    &&  lsdc1_ex2_chk_ld_inst_vld
                                    && !lsdc1_ex2_is_us;//rvv512@LTL

assign wmb_entry_depd_hit1_0        = wmb_entry_fwd_data_pre0;        //1->3, for 3 ld_dc, LTL@20241104
assign wmb_entry_depd_hit1_1        = wmb_entry_fwd_data_pre1;
assign wmb_entry_depd_hit1_2        = wmb_entry_fwd_data_pre2;

assign wmb_entry_fwd_bytes_vld0[15:0]  = {16{wmb_entry_fwd_data_pre0}}        //1->3, for 3 ld_dc, LTL@20241104
                                        & wmb_entry_and_ldc0_bytes_vld[15:0];
assign wmb_entry_fwd_bytes_vld1[15:0]  = {16{wmb_entry_fwd_data_pre1}}
                                        & wmb_entry_and_lsdc0_bytes_vld[15:0];
assign wmb_entry_fwd_bytes_vld2[15:0]  = {16{wmb_entry_fwd_data_pre2}}
                                        & wmb_entry_and_lsdc1_bytes_vld[15:0];                                                                                
//------------------situation 2-----------------------------
assign wmb_entry_depd_hit2_0  = wmb_entry_vld      //1->3, for 3 ld_dc, LTL@20241104
                              &&  ldc0_ex2_chk_atomic_inst_vld;
assign wmb_entry_depd_hit2_1  = wmb_entry_vld
                              &&  lsdc0_ex2_chk_atomic_inst_vld;
assign wmb_entry_depd_hit2_2  = wmb_entry_vld
                              &&  lsdc1_ex2_chk_atomic_inst_vld;
//------------------situation 3-----------------------------
assign wmb_entry_depd_hit3_0  = wmb_entry_vld_exec // Risc-V Debug zdb      //1->3, for 3 ld_dc, LTL@20241104
                              &&  (wmb_entry_atomic
                                   || wmb_entry_dtcm_hit && !wmb_entry_depd_whole_hit0)
                              &&  ldc0_ex2_chk_ld_inst_vld
                              && !ldc0_ex2_is_us  //rvv512@LTL
                              &&  wmb_entry_depd_addr_tto4_hit0
                              &&  wmb_entry_depd_do_hit0;
assign wmb_entry_depd_hit3_1  = wmb_entry_vld_exec // Risc-V Debug zdb
                              &&  (wmb_entry_atomic
                                   || wmb_entry_dtcm_hit && !wmb_entry_depd_whole_hit1)
                              &&  lsdc0_ex2_chk_ld_inst_vld
                              && !lsdc0_ex2_is_us  //rvv512@LTL
                              &&  wmb_entry_depd_addr_tto4_hit1
                              &&  wmb_entry_depd_do_hit1;
assign wmb_entry_depd_hit3_2  = wmb_entry_vld_exec // Risc-V Debug zdb
                              &&  (wmb_entry_atomic
                                   || wmb_entry_dtcm_hit && !wmb_entry_depd_whole_hit2)
                              &&  lsdc1_ex2_chk_ld_inst_vld
                              && !lsdc1_ex2_is_us  //rvv512@LTL
                              &&  wmb_entry_depd_addr_tto4_hit2
                              &&  wmb_entry_depd_do_hit2;
//------------------situation 4-----------------------------//rvv512 hit will lead to discard
assign wmb_entry_depd_hit4_0  = wmb_entry_vld      //1->3, for 3 ld_dc, LTL@20241104
                              &&  ldc0_ex2_is_us
                              &&  ldc0_ex2_chk_ld_inst_vld
                              &&  wmb_entry_depd_addr_tto6_hit0
                              &&  ( wmb_entry_and_ldc0_bytes_vld_hit && wmb_entry_addr[5:4]==2'b00
                                  || wmb_entry_and_ldc0_bytes_vld1_hit && wmb_entry_addr[5:4]==2'b01
                                  || wmb_entry_and_ldc0_bytes_vld2_hit && wmb_entry_addr[5:4]==2'b10
                                  || wmb_entry_and_ldc0_bytes_vld3_hit && wmb_entry_addr[5:4]==2'b11);
assign wmb_entry_depd_hit4_1  = wmb_entry_vld
                              &&  lsdc0_ex2_is_us
                              &&  lsdc0_ex2_chk_ld_inst_vld
                              &&  wmb_entry_depd_addr_tto6_hit1
                              &&  ( wmb_entry_and_lsdc0_bytes_vld_hit && wmb_entry_addr[5:4]==2'b00
                                  || wmb_entry_and_lsdc0_bytes_vld1_hit && wmb_entry_addr[5:4]==2'b01
                                  || wmb_entry_and_lsdc0_bytes_vld2_hit && wmb_entry_addr[5:4]==2'b10
                                  || wmb_entry_and_lsdc0_bytes_vld3_hit && wmb_entry_addr[5:4]==2'b11);
assign wmb_entry_depd_hit4_2  = wmb_entry_vld
                              &&  lsdc1_ex2_is_us
                              &&  lsdc1_ex2_chk_ld_inst_vld
                              &&  wmb_entry_depd_addr_tto6_hit2
                              &&  ( wmb_entry_and_lsdc1_bytes_vld_hit && wmb_entry_addr[5:4]==2'b00
                                  || wmb_entry_and_lsdc1_bytes_vld1_hit && wmb_entry_addr[5:4]==2'b01
                                  || wmb_entry_and_lsdc1_bytes_vld2_hit && wmb_entry_addr[5:4]==2'b10
                                  || wmb_entry_and_lsdc1_bytes_vld3_hit && wmb_entry_addr[5:4]==2'b11);
//for cache buffer acceleration
assign wmb_entry_depd_hit5_0  = wmb_entry_vld_exec // Risc-V Debug zdb      //1->3, for 3 ld_dc, LTL@20241104
                              && wmb_entry_depd_addr1_tto4_hit0;
assign wmb_entry_depd_hit5_1  = wmb_entry_vld_exec // Risc-V Debug zdb
                              && wmb_entry_depd_addr1_tto4_hit1;
assign wmb_entry_depd_hit5_2  = wmb_entry_vld_exec // Risc-V Debug zdb
                              && wmb_entry_depd_addr1_tto4_hit2;

//------------------combine---------------------------------
assign wmb_entry_discard_req0    = wmb_entry_depd_hit2_0      //1->3, for 3 ld_dc, LTL@20241104
                                  ||  wmb_entry_depd_hit3_0
                                  ||  wmb_entry_depd_hit4_0;  //rvv512@LTL
assign wmb_entry_discard_req1    = wmb_entry_depd_hit2_1
                                  ||  wmb_entry_depd_hit3_1
                                  ||  wmb_entry_depd_hit4_1;  //rvv512@LTL
assign wmb_entry_discard_req2    = wmb_entry_depd_hit2_2
                                  ||  wmb_entry_depd_hit3_2
                                  ||  wmb_entry_depd_hit4_2;  //rvv512@LTL


assign wmb_entry_fwd_req0        = wmb_entry_depd_hit1_0;      //1->3, for 3 ld_dc, LTL@20241104
assign wmb_entry_fwd_req1        = wmb_entry_depd_hit1_1;
assign wmb_entry_fwd_req2        = wmb_entry_depd_hit1_2;

assign wmb_entry_cancel_acc_req0 = wmb_entry_depd_hit5_0;      //1->3, for 3 ld_dc, LTL@20241104
assign wmb_entry_cancel_acc_req1 = wmb_entry_depd_hit5_1;
assign wmb_entry_cancel_acc_req2 = wmb_entry_depd_hit5_2;
//==========================================================
//                 Set write_imme
//==========================================================
//-------------request ar channel if need-------------------
//if has write out, then clear write imme
assign wmb_entry_write_imme_set     = wmb_entry_vld
                                      &&  !wmb_entry_write_req_success
                                      &&  (wmb_entry_discard_req0       //1->3, for 3 ld_dc, ???  LTL@20241104
                                          || wmb_entry_discard_req1
                                          || wmb_entry_discard_req2
                                          ||  wmb_entry_merge_data_wait_not_vld_req
                                          ||  wmb_entry_rb_biu_req_hit_idx
                                          ||  wmb_create_ptr_next1
//                                          ||  wmb_create_ptr_next3
//                                              &&  amr_mem_set
                                          ||  wmb_entry_snq_set_write_imme
                                          ||  wmb_wakeup_queue_not_empty
                                              &&  wmb_entry_depd
                                          ||  wmb_entry_merge_data_write_imme_set);

//for timing, use write_imme_bypass to set wmb_write_imme
assign wmb_entry_write_imme_bypass  = wmb_entry_vld
                                      &&  !wmb_entry_write_req_success
                                      &&  wmb_create_ptr_next1;

//assign wmb_entry_amr_cancel           = wmb_entry_vld
//                                        &&  !wmb_entry_write_req_success;
//                                        &&  wmb_entry_snq_create_hit_idx;

//assign wmb_entry_amr_cancel_gateclk   = wmb_entry_vld
//                                        &&  !wmb_entry_write_req_success
//                                        &&  (wmb_entry_discard_amr_cancel_gateclk
//                                            ||  wmb_entry_rb_biu_req_hit_idx);
//                                            ||  wmb_entry_snq_create_hit_idx);
//==========================================================
//                    Request read
//==========================================================
assign wmb_entry_read_ptr_not_already_success = wmb_entry_vld
                                                &&  wmb_read_ptr
                                                &&  !wmb_entry_read_req_success;
//-------------request ar channel if need-------------------
assign wmb_entry_read_req   = wmb_entry_read_ptr_not_already_success
                              &&  !wmb_entry_exec_cancel // Risc-V Debug zdb
                              &&  (wmb_entry_st_inst
                                      &&  wmb_entry_page_ca
                                      &&  wmb_entry_dcache_share
//                                          ||  !wmb_entry_dcache_valid)
                                      &&  !wmb_entry_same_dcache_line
                                  ||  wmb_entry_ctc_inst
                                  ||  wmb_entry_dcache_addr_inst
                                      &&  (wmb_entry_dcache_addr_not_l1_inst
                                          ||  wmb_entry_page_share)
                                      &&  wmb_entry_page_ca
                                      &&  wmb_entry_write_resp
                                  ||  wmb_entry_sc_inst
                                      &&  wmb_write_ptr
                                      &&  !wmb_entry_sc_wb_vld
                                      &&  wmb_entry_page_ca
                                      &&  !dm_state_is_force_fail
                                      &&  (wmb_entry_dcache_valid
                                              &&  wmb_entry_dcache_share
                                          ||  !wmb_entry_dcache_valid));

assign wmb_entry_read_dp_req  = wmb_entry_vld
                                &&  !wmb_entry_exec_cancel // Risc-V Debug zdb
                                &&  !wmb_entry_read_req_success
                                &&  (wmb_entry_st_inst
                                          &&  wmb_entry_page_ca
                                          &&  (wmb_entry_dcache_share
                                              ||  !wmb_entry_dcache_valid)
                                    ||  wmb_entry_ctc_inst
                                    ||  wmb_entry_dcache_addr_inst
                                        &&  wmb_entry_page_ca
                                    ||  wmb_entry_sc_inst
                                        &&  wmb_entry_page_ca
                                        &&  !wmb_entry_sc_wb_vld);

assign wmb_entry_read_ptr_chk_idx_shift_imme  =
                wmb_entry_read_ptr_not_already_success 
                &&  !wmb_entry_exec_cancel // Risc-V Debug zdb
//                &&  (wmb_entry_dcache_sw_inst
//                        &&  wmb_entry_write_resp
//                    ||  wmb_entry_st_inst
                &&  (wmb_entry_st_inst   
                        &&  wmb_entry_page_ca
                        &&  (wmb_entry_same_dcache_line
                            ||  !wmb_entry_dcache_valid
                            ||  wmb_entry_dcache_valid
                                &&  !wmb_entry_dcache_share)
                    ||  wmb_entry_stamo_inst
                    ||  wmb_entry_sc_inst
                        &&  wmb_write_ptr
                        &&  !wmb_entry_sc_wb_vld
                        &&  wmb_entry_page_ca
                        &&  (wmb_entry_dcache_valid
                                &&  !wmb_entry_dcache_share));

//if has sent read req and other condition, don't compare index
assign wmb_entry_read_ptr_unconditional_shift_imme  =
                wmb_entry_vld
                &&  wmb_read_ptr
                &&  (wmb_entry_read_req_success 
                    ||  wmb_entry_exec_cancel // Risc-V Debug zdb
                    ||  wmb_entry_st_inst
                        &&  !wmb_entry_page_ca
                    || wmb_entry_dcache_sw_inst
                        &&  wmb_entry_write_resp
                    ||  wmb_entry_dcache_all_inst
                    ||  wmb_entry_sync_fence_inst
                    ||  wmb_entry_dcache_addr_l1_inst
                        &&  !wmb_entry_page_share
                        &&  wmb_entry_write_resp
                    ||  wmb_entry_dcache_addr_inst
                        &&  !wmb_entry_page_ca
                        &&  wmb_entry_write_resp
//                    ||  wmb_entry_stamo_inst
                    ||  wmb_entry_sc_inst
                        &&  (!wmb_entry_page_ca
                            ||  wmb_entry_sc_wb_vld));

//-------------read req_success/resp set--------------------
assign wmb_entry_read_ptr_shift_imme  = wmb_entry_read_ptr_unconditional_shift_imme
                                        ||  wmb_entry_read_ptr_chk_idx_shift_imme;
assign wmb_entry_read_req_success_set = !wmb_entry_read_req_success
                                        &&  (wmb_entry_read_req
                                                &&  wmb_read_ptr_read_req_grnt
                                            ||  wmb_entry_read_ptr_shift_imme
                                                &&  wmb_read_ptr_shift_imme_grnt);

//if ctc has sent, then set read_resp
assign wmb_entry_read_resp_set        = !wmb_entry_read_resp
                                        &&  (wmb_entry_read_ptr_shift_imme
                                                &&  wmb_read_ptr_shift_imme_grnt
                                                &&  !wmb_entry_read_req_success
                                                &&  !wmb_entry_sync_fence_inst
                                                &&  !(wmb_entry_st_inst
                                                      && wmb_entry_page_ca
                                                      && wmb_entry_dcache_valid
                                                      && wmb_entry_dcache_share
                                                      && wmb_entry_same_dcache_line
                                                      && !wmb_entry_same_dcache_line_ready)
                                            ||  wmb_entry_read_req_success
                                                && wmb_entry_st_inst
                                                && wmb_entry_page_ca
                                                && wmb_entry_same_dcache_line
                                                && wmb_entry_same_dcache_line_ready
                                            ||  wmb_entry_r_resp_vld
                                            ||  wmb_entry_read_req
                                                &&  wmb_entry_ctc_inst
                                                &&  wmb_read_ptr_read_req_grnt);

//for same dcache line
assign wmb_entry_read_resp_ready = !(wmb_entry_vld
                                     && wmb_entry_read_req_success
                                     && !wmb_entry_read_resp);

assign wmb_entry_same_dcache_line_ready = |(wmb_entry_same_dcache_line_ptr[WMB_ENTRY-1:0] & wmb_same_line_resp_ready[WMB_ENTRY-1:0]);
//==========================================================
//                    Request write
//==========================================================
//-------------request dcache/vb/aw channel if need---------
//assign wmb_entry_write_permit       = wmb_pop_write_imme
//                                      ||  wmb_entry_dcache_valid
//                                          &&  !ld_ag_inst_vld
//                                          &&  !st_ag_inst_vld;

assign wmb_entry_page_ca_dcache_valid   = wmb_entry_page_ca
                                          &&  wmb_entry_dcache_valid;

//write req is used for write ptr shift
assign wmb_entry_write_req          = wmb_entry_vld
                                      &&  !wmb_entry_exec_cancel // Risc-V Debug zdb
                                      &&  wmb_write_ptr
                                      &&  !wmb_entry_write_req_success
                                      &&  !wmb_entry_ctc_inst
                                      &&  !wmb_entry_dcache_all_inst;

assign wmb_entry_write_biu_req      = wmb_entry_vld
                                      &&  !wmb_entry_exec_cancel // Risc-V Debug zdb
                                      &&  wmb_write_ptr
                                      &&  !wmb_entry_tcm_hit
                                      &&  !wmb_entry_write_req_success
                                      &&  !wmb_entry_write_stall
                                      &&  (wmb_entry_so_st_inst
                                              &&  wmb_entry_read_resp
                                          ||  wmb_entry_wo_st_inst
                                              &&  wmb_entry_read_resp
                                              &&  !wmb_entry_page_ca_dcache_valid
                                          ||  wmb_entry_sync_fence_inst
                                              &&  wmb_entry_read_req_success
                                              &&  vb_wmb_empty
                                          ||  wmb_entry_stamo_inst
                                              &&  wmb_entry_read_resp
                                              &&  !wmb_entry_dcache_valid
                                          ||  wmb_entry_sc_inst
                                              &&  wmb_entry_read_resp
                                              &&  !wmb_entry_sc_wb_vld
                                              &&  (!wmb_entry_page_ca
                                                  ||  !wmb_entry_dcache_valid));

//if write imme, then must write this cycle or next cycle
assign wmb_entry_wo_st_write_biu_req    = wmb_entry_vld
                                          &&  wmb_write_ptr
                                          &&  wmb_entry_merge_en
                                          &&  !wmb_entry_write_req_success
                                          &&  wmb_entry_wo_st_inst
                                          &&  wmb_biu_write_en
                                          &&  wmb_entry_read_resp
                                          &&  !wmb_entry_page_ca_dcache_valid;

assign wmb_entry_dcache_line_req        = wmb_entry_mem_set_ptr && wmb_write_biu_dcache_line;

assign wmb_entry_write_biu_dp_req   = wmb_entry_vld
                                      &&  !wmb_entry_exec_cancel // Risc-V Debug zdb
                                      &&  !wmb_entry_tcm_hit
                                      &&  !wmb_entry_write_req_success
                                      &&  (wmb_entry_so_st_inst
                                          ||  wmb_entry_wo_st_inst
                                              &&  !wmb_entry_page_ca_dcache_valid
                                          ||  wmb_entry_sync_fence_inst
                                          ||  wmb_entry_stamo_inst
                                              &&  !wmb_entry_dcache_valid
                                          ||  wmb_entry_sc_inst
                                              &&  (!wmb_entry_page_ca
                                                  ||  !wmb_entry_dcache_valid)
                                              &&  !wmb_entry_sc_wb_vld);

assign wmb_entry_write_dcache_req   = wmb_entry_vld
                                      &&  !wmb_entry_exec_cancel // Risc-V Debug zdb
//                                      &&  wmb_write_ptr
//                                      &&  wmb_data_ptr
                                      &&  !wmb_entry_write_resp
//                                      &&  !wmb_entry_write_stall
                                      &&  (wmb_entry_page_ca_dcache_valid
                                             &&  !wmb_entry_write_req_success
                                             &&  (wmb_entry_st_inst
                                                     &&  wmb_entry_read_resp
//                                                 ||  wmb_entry_dcache_only_inv_1line_inst
                                                 ||  wmb_entry_stamo_inst
                                                     &&  wmb_entry_read_resp
                                                 ||  wmb_entry_sc_inst
                                                     &&  wmb_entry_read_resp
                                                     &&  !wmb_entry_sc_wb_vld)
                                           || wmb_entry_dcache_only_inv_1line_inst
                                              && wmb_entry_page_ca_dcache_valid
                                              && wmb_entry_write_req_success);

assign wmb_entry_wo_st_write_tcm_req    = wmb_entry_vld
                                          &&  wmb_write_ptr
                                          &&  wmb_data_ptr
                                          &&  wmb_entry_tcm_hit
                                          &&  wmb_entry_merge_en
                                          &&  !wmb_entry_write_req_success
                                          &&  wmb_entry_wo_st_inst
                                          &&  (wmb_write_imme | wmb_entry_dtcm_hit)
                                          &&  wmb_entry_read_resp;

assign wmb_entry_write_tcm_req     = wmb_entry_vld
                                     &&  !wmb_entry_exec_cancel // Risc-V Debug zdb
                                     &&  wmb_write_ptr
                                     &&  wmb_data_ptr
                                     &&  !wmb_entry_write_req_success
                                     &&  !wmb_entry_write_stall
                                     &&  wmb_entry_tcm_hit
                                     &&  (wmb_entry_st_inst
                                              &&  wmb_entry_read_resp
                                          ||  wmb_entry_stamo_inst
                                              &&  wmb_entry_read_resp
                                          ||  wmb_entry_sc_inst
                                              &&  wmb_entry_read_resp
                                              &&  !wmb_entry_sc_wb_vld);
//if write permit, then write dcache this cycle, if write imme, then must
//write in next cycle
//assign wmb_entry_wo_st_write_dcache_req = wmb_entry_vld
//                                          &&  wmb_write_ptr
//                                          &&  wmb_data_ptr
//                                        &&  wmb_write_dcache_permit
//                                        &&  wmb_entry_merge_en
//                                        &&  !wmb_entry_write_req_success
//                                        &&  (!wmb_entry_write_stall
//                                            ||  wmb_write_imme)
//                                        &&  wmb_entry_page_ca_dcache_valid
//                                        &&  wmb_entry_wo_st_inst
//                                          &&  wmb_entry_read_resp;
                                     

assign wmb_entry_write_vb_req       = wmb_entry_vld
                                      &&  !wmb_entry_exec_cancel // Risc-V Debug zdb
                                      &&  wmb_write_ptr
                                      &&  !wmb_entry_write_req_success
                                      &&  wmb_entry_dcache_clr_1line_inst
                                      &&  wmb_entry_page_ca_dcache_valid;

//if already mem_set success, then write ptr shift imme
assign wmb_entry_write_ptr_unconditional_shift_imme =
            wmb_write_ptr
                && (!wmb_entry_vld
                    ||  wmb_entry_exec_cancel // Risc-V Debug zdb
                    ||  wmb_dcache_req_ptr
                        &&  wmb_write_dcache_success
                    ||  wmb_entry_write_resp   //for dcache_only_inv_1line
                    ||  wmb_entry_write_req_success
                        &&  wmb_entry_mem_set_req
                    ||  !wmb_entry_write_req_success
                        &&  (wmb_entry_dcache_all_inst
                            ||  wmb_entry_ctc_inst
                            ||  wmb_entry_sc_inst
                                &&  wmb_entry_read_resp
                                &&  wmb_entry_sc_wb_vld));

assign wmb_entry_write_ptr_chk_idx_shift_imme =
                wmb_entry_vld
                &&  !wmb_entry_exec_cancel // Risc-V Debug zdb
                &&  wmb_write_ptr
                &&  !wmb_entry_write_req_success
                &&  (wmb_entry_dcache_except_only_inv_1line_inst
                        &&  !wmb_entry_page_ca_dcache_valid);

//-------------write req_success/resp set-------------------
assign wmb_entry_write_ptr_shift_imme   = wmb_entry_write_ptr_chk_idx_shift_imme
                                          ||  wmb_entry_write_ptr_unconditional_shift_imme;
assign wmb_entry_write_req_success_set  = !wmb_entry_write_req_success
                                          &&  (wmb_entry_write_biu_req
                                                  &&  bus_arb_wmb_aw_grnt
                                              ||  wmb_entry_write_vb_req
                                                  &&  wmb_create_vb_success
                                              ||  wmb_dcache_req_ptr
                                                  &&  wmb_write_dcache_success
                                              ||  wmb_write_ptr
                                                  &&  wmb_tcm_grant
                                              ||  wmb_entry_vld
                                                  && wmb_entry_dcache_only_inv_1line_inst   //for timing
                                                  && !wmb_dcache_inst_write_req_hit_idx
                                                  && wmb_write_ptr 
                                              ||  wmb_entry_mem_set_write_grnt
                                              ||  wmb_entry_write_ptr_shift_imme
                                                  &&  wmb_write_ptr_shift_imme_grnt);

assign wmb_entry_write_resp_set         = !wmb_entry_write_resp
                                          &&  (vb_wmb_entry_rcl_done
                                              ||  wmb_dcache_req_ptr
                                                  &&  wmb_write_dcache_success
                                              ||  wmb_tcm_write_done
                                              ||  wmb_entry_vld
                                                  && wmb_entry_dcache_only_inv_1line_inst
                                                  && wmb_entry_write_req_success 
                                                  && !wmb_entry_page_ca_dcache_valid
                                              ||  wmb_entry_b_resp_vld
                                              ||  wmb_entry_write_ptr_shift_imme
                                                  &&  !wmb_entry_write_req_success
                                                  &&  wmb_write_ptr_shift_imme_grnt);

//==========================================================
//                    Request data
//==========================================================
//-------------request data channel if need-----------------
assign wmb_entry_data_req       = wmb_entry_vld
                                  &&  !wmb_entry_exec_cancel // Risc-V Debug zdb
                                  &&  wmb_data_ptr
                                  &&  !wmb_entry_data_req_success
                                  &&  (wmb_entry_read_resp
                                      || !(wmb_entry_st_inst
                                          ||  wmb_entry_atomic))
                                  &&  wmb_entry_write_req_success;
//                                      ||  wmb_entry_page_ca_dcache_valid
//                                          &&  wmb_write_dcache_permit);

assign wmb_entry_data_biu_req   = wmb_data_ptr
                                  &&  !wmb_entry_exec_cancel // Risc-V Debug zdb
                                  &&  wmb_entry_write_req_success
                                  &&  !wmb_entry_data_req_success
                                  &&  !wmb_entry_write_resp
                                  &&  (wmb_entry_st_inst
//                                      ||  wmb_entry_sync_fence_inst
                                      ||  wmb_entry_atomic);

assign wmb_entry_data_req_wns   = wmb_data_ptr
                                  && !wmb_entry_sync_fence_inst
                                  && wmb_entry_page_ca 
                                  && wmb_entry_atomic; 

assign wmb_entry_data_ptr_after_write_shift_imme  = 
                wmb_data_ptr
                &&  (!wmb_entry_vld
                    || wmb_entry_exec_cancel // Risc-V Debug zdb
                    || wmb_dcache_req_ptr
                       &&  wmb_write_dcache_success
                    ||  wmb_write_ptr
                        &&  wmb_tcm_grant
                    || wmb_entry_write_resp     //for only_inv_1line_inst 
                    || wmb_entry_write_req_success
                       &&  (wmb_entry_dcache_except_only_inv_1line_inst
                           ||  wmb_entry_ctc_inst
                           ||  wmb_entry_sync_fence_inst
                           ||  wmb_entry_sc_inst
                               &&  wmb_entry_sc_wb_vld));

assign wmb_entry_data_ptr_after_write_shift_imme_gate  = 
                wmb_data_ptr
                &&  (!wmb_entry_vld
                    || wmb_entry_exec_cancel // Risc-V Debug zdb
                    || wmb_dcache_req_ptr
                    ||  wmb_write_ptr
                        &&  wmb_entry_tcm_hit
                    || wmb_entry_write_resp     //for only_inv_1line_inst 
                    || wmb_entry_write_req_success
                       &&  (wmb_entry_dcache_except_only_inv_1line_inst
                           ||  wmb_entry_ctc_inst
                           ||  wmb_entry_sync_fence_inst
                           ||  wmb_entry_sc_inst
                               &&  wmb_entry_sc_wb_vld));
//assign wmb_entry_data_ptr_with_write_shift_imme = 
//                wmb_data_ptr
//                &&  wmb_write_ptr
//                &&  wmb_entry_dcache_only_inv_1line_inst
//                    &&  !wmb_entry_page_ca_dcache_valid;
assign wmb_entry_data_ptr_with_write_shift_imme = 1'b0;

//-------------write req_success/resp set-------------------
assign wmb_entry_data_req_success_set = wmb_entry_data_biu_req
                                            &&  bus_arb_wmb_w_grnt
                                        ||  wmb_dcache_req_ptr
                                            &&  wmb_write_dcache_success
                                        ||  wmb_write_ptr
                                            &&  wmb_tcm_grant
                                        ||  wmb_entry_data_ptr_after_write_shift_imme
                                        ||  wmb_entry_data_ptr_with_write_shift_imme
                                            &&  wmb_write_ptr_shift_imme_grnt;

//==========================================================
//                Compare biu r/b channel
//==========================================================
//---------------------biu id vld set-----------------------
assign wmb_entry_biu_r_id_vld_set = wmb_entry_read_req
                                        &&  !wmb_entry_ctc_inst
                                    ||  wmb_entry_sync_fence_inst
                                        &&  wmb_entry_write_biu_req;

assign wmb_entry_biu_b_id_vld_set = wmb_entry_write_biu_req
                                    ||  wmb_entry_mem_set_write_grnt;
//-----------------compare biu r channel--------------------
assign wmb_entry_r_id_hit = biu_lsu_r_vld
                            &&  wmb_entry_biu_r_id_vld
                            &&  (wmb_entry_biu_id[4:0]  ==  biu_lsu_r_id[4:0]);
assign wmb_entry_r_resp_vld   = wmb_entry_r_id_hit;

//-----------------compare biu b channel--------------------
assign wmb_entry_b_id_hit = biu_lsu_b_vld
                            &&  wmb_entry_biu_b_id_vld
                            &&  (wmb_entry_biu_id[4:0]  ==  biu_lsu_b_id[4:0]);

assign wmb_entry_b_resp_vld   = wmb_entry_b_id_hit
                                &&  (!wmb_entry_page_so
                                    ||  wmb_entry_atomic && !wmb_entry_page_so
//                                    ||  wmb_entry_next_nc_bypass
                                    ||  wmb_entry_next_so_bypass
                                    ||  wmb_entry_dcache_clr_1line_inst
                                    ||  wmb_entry_sync_fence_inst);
                                
//==========================================================
//                 Request wb cmplt/data
//==========================================================
//stex write data first, then request cmplt to ensure there is only 1 stex
//inst in wmb
assign wmb_entry_wb_cmplt_req = wmb_entry_vld
                                &&  !wmb_entry_wb_cmplt_success
                                &&  wmb_entry_wb_data_success
                                &&  (wmb_entry_dcache_all_inst
                                    ||  wmb_entry_sync_fence_inst
                                        &&  wmb_entry_read_resp
                                        &&  wmb_entry_write_resp
                                    ||  wmb_entry_so_st_inst
                                        &&  wmb_entry_write_req_success
                                    ||  wmb_entry_sc_inst
                                        &&  wmb_entry_sc_wb_vld
                                    ||  wmb_entry_stamo_inst
                                        &&  wmb_entry_write_resp);

assign wmb_entry_wb_data_req  = wmb_entry_vld
                                &&  !wmb_entry_wb_data_success
                                &&  wmb_entry_sc_inst
                                &&  wmb_entry_sc_wb_vld;

//==========================================================
//                 sc execute
//==========================================================
assign wmb_entry_sc_force_fail= dm_state_is_force_fail
                                &&  wmb_entry_page_ca
                                &&  (wmb_entry_dcache_valid
                                        &&  wmb_entry_dcache_share
                                    ||  !wmb_entry_dcache_valid)
                                || wmb_entry_exec_cancel; // Risc-V Debug zdb

assign wmb_entry_sc_wb_set    = wmb_entry_vld
                                &&  wmb_entry_sc_inst
                                &&  !wmb_entry_sc_wb_vld
                                &&  (lm_state_is_idle
                                    ||  wmb_entry_sc_force_fail
                                    ||  wmb_entry_page_ca_dcache_valid
                                        &&  wmb_entry_write_resp
                                    ||  wmb_entry_tcm_hit
                                        &&  wmb_entry_write_resp
                                    ||  wmb_entry_page_ca
                                        &&  !wmb_entry_dcache_valid
                                        &&  wmb_entry_b_resp_vld
                                    ||  !wmb_entry_page_ca
                                        &&  wmb_entry_b_resp_vld);

assign wmb_entry_sc_wb_success_set  = lm_state_is_ex_wait_lock
                                      &&  !wmb_entry_sc_force_fail
                                      &&  (wmb_entry_page_ca
                                          ||  wmb_entry_tcm_hit
                                          ||  !wmb_entry_page_ca
                                              &&  !wmb_entry_tcm_hit
                                              &&  wmb_b_resp_exokay);

//assign wmb_entry_preg[PREG-1:0]  = {wmb_entry_icc,
//                              wmb_entry_inst_mode[1:0],
//                              wmb_entry_fence_mode[3:0]};

//==========================================================
//                 Compare index
//==========================================================
assign wmb_entry_idx_cmpare_inst  = wmb_entry_vld
                                    &&  (wmb_entry_st_inst
                                        ||  wmb_entry_atomic
                                        ||  wmb_entry_dcache_1line_inst)
                                    &&  wmb_entry_page_ca;

//for snq dep
assign wmb_entry_idx_snq_dep_inst  = wmb_entry_vld
                                     &&  !wmb_entry_exec_cancel // Risc-V Debug zdb
                                     &&  (wmb_entry_st_inst
                                         ||  wmb_entry_stamo_inst
                                         ||  wmb_entry_dcache_only_inv_1line_inst
                                         ||  wmb_entry_sc_inst
                                             && !wmb_entry_sc_wb_vld);
//------------------compare rb biu req----------------------
//because if hit index of rb_biu_req, this entry must set write_imme bit, so it
//must compare with req_unmask signal
// &Force("bus","rb_biu_req_addr",39,0); @1318
assign wmb_entry_rb_biu_req_hit_idx = wmb_entry_idx_cmpare_inst
                                      &&  rb_biu_req_unmask
                                      &&  (wmb_entry_addr[13:6] ==  rb_biu_req_addr[13:6]);
//------------------compare pfu pop entry--------------------
// &Force("bus","pfu_biu_req_addr",39,0); @1323
assign wmb_entry_pfu_biu_req_hit_idx  = wmb_entry_idx_cmpare_inst
                                        &&  (wmb_entry_addr[13:6]
                                            ==  pfu_biu_req_addr[13:6]);
//------------------compare snq create port-----------------
//if hit snq create addr, then same_dcache_line will be cleared
//if wmb entry has not write, and has read_resp, then this entry must clr

// &Force("bus","snq_create_addr",39,0); @1331
assign wmb_entry_snq_create_addr_hit_idx  = wmb_entry_addr[13:6] ==  snq_create_addr[13:6];

assign wmb_entry_snq_create_hit_idx   = wmb_entry_idx_snq_dep_inst
                                        &&  snq_can_create_snq_uncheck
                                        &&  wmb_entry_snq_create_addr_hit_idx;

//if wmb entry has write and not resp, snq must wait
//assign wmb_entry_read_resp_already_write  = wmb_entry_read_req_success
//                                            &&  wmb_entry_read_resp
//                                            &&  wmb_entry_write_req_success;

//in this situation, then snq must wait, and set write imme of this entry
//assign wmb_entry_read_resp_hit_write_ptr  = wmb_entry_read_req_success
//                                            &&  wmb_entry_read_resp
//                                            &&  !wmb_entry_write_req_success
//                                            &&  wmb_write_ptr;

//read_req_success and read_resp and reset read_ptr
assign wmb_entry_read_resp_not_write      = wmb_entry_read_req_success
                                            &&  wmb_entry_read_resp
                                            &&  !wmb_entry_write_resp;

//set snq signal
assign wmb_entry_snq_depd                 = wmb_entry_snq_create_hit_idx
                                            &&  (wmb_entry_read_resp_not_write
                                                    && !wmb_entry_dcache_only_inv_1line_inst
                                                    && (wmb_entry_page_ca_dcache_valid 
                                                        || wmb_entry_page_ca && wmb_entry_atomic)
                                                 || wmb_entry_vld
                                                    && wmb_entry_write_req_success
                                                    && wmb_entry_dcache_only_inv_1line_inst);

assign wmb_entry_snq_set_write_imme       = wmb_entry_snq_create_hit_idx
                                            &&  wmb_entry_read_resp_not_write;

assign wmb_entry_snq_depd_remove = !wmb_entry_vld || wmb_entry_write_resp & wmb_entry_dcache_only_inv_1line_inst;  //write resp for dcache_inv 
//------------------compare snq dcache port-----------------
assign wmb_entry_same_dcache_line_clr = wmb_entry_vld
                                        &&  dcache_snq_st_sel
                                        &&  !wmb_entry_read_req_success
                                        &&  wmb_entry_dcache_hit_idx;

//==========================================================
//                Generate no_op signal
//==========================================================
//if not vld/ read resp & not write & not write imme
assign wmb_entry_no_op    = !wmb_entry_vld
                            ||  wmb_entry_read_resp
                                &&  !wmb_entry_write_imme
                                &&  !wmb_entry_write_req_success;

//==========================================================
//                 Generate pop signal
//==========================================================
//if write dcache line and is not the last entry of dcache line, then fast pop
assign wmb_entry_pop_vld  = wmb_entry_vld
                            &&  wmb_entry_read_resp
                            &&  (wmb_entry_write_resp
                                ||  wmb_entry_write_resp_set
                                ||  wmb_entry_mem_set_req
                                    &&  !wmb_entry_w_last)
                            &&  (wmb_entry_data_req_success  ||  wmb_entry_data_req_success_set)
                            &&  wmb_entry_wb_cmplt_success
                            &&  wmb_entry_wb_data_success;

//==========================================================
//                 Interface to rb
//==========================================================
assign wmb_entry_sync_fence_biu_req_success = wmb_entry_vld
                                              &&  wmb_entry_sync_fence_inst
                                              &&  wmb_entry_write_req_success;

//==========================================================
//                 Interface to had
//==========================================================
assign wmb_entry_ar_pending = wmb_entry_vld
                              &&  wmb_entry_read_req_success
                              &&  !wmb_entry_read_resp;

assign wmb_entry_aw_pending = wmb_entry_vld
                              &&  wmb_entry_write_req_success
                              &&  !wmb_entry_write_resp;

assign wmb_entry_w_pending  = wmb_entry_vld
                              &&  wmb_entry_data_req_success
                              &&  !wmb_entry_write_resp;

//==========================================================
//                 Generate interface
//==========================================================
//-----------------------input------------------------------
//-----------create signal--------------
assign wmb_entry_create_vld               = wmb_entry_create_vld_x;
assign wmb_entry_create_dp_vld            = wmb_entry_create_dp_vld_x;
assign wmb_entry_create_gateclk_en        = wmb_entry_create_gateclk_en_x;
assign wmb_entry_create_data_vld          = wmb_entry_create_data_vld_x;
//assign vb_wmb_entry_rcl_done_gateclk_en   = vb_wmb_entry_rcl_done_gateclk_en_x;
//---------grnt/done signal-------------
assign vb_wmb_entry_rcl_done              = vb_wmb_entry_rcl_done_x;
//assign wmb_entry_next_nc_bypass           = wmb_entry_next_nc_bypass_x;
assign wmb_entry_next_so_bypass           = wmb_entry_next_so_bypass_x;
assign wmb_entry_wb_cmplt_grnt            = wmb_entry_wb_cmplt_grnt_x;
assign wmb_entry_wb_data_grnt             = wmb_entry_wb_data_grnt_x;
//-----------pointer--------------------
assign wmb_create_ptr_next1               = wmb_create_ptr_next1_x;
//assign wmb_create_ptr_next3               = wmb_create_ptr_next3_x;
assign wmb_data_ptr                       = wmb_data_ptr_x;
assign wmb_read_ptr                       = wmb_read_ptr_x;
assign wmb_write_ptr                      = wmb_write_ptr_x;
assign wmb_dcache_req_ptr                 = wmb_dcache_req_ptr_x;
assign wmb_entry_mem_set_ptr              = wmb_write_ptr_to_next3_x;
assign wmb_entry_mem_set_write_grnt       = wmb_entry_mem_set_write_grnt_x;
assign wmb_entry_w_last_set               = wmb_entry_w_last_set_x;
assign wmb_tcm_write_done                 = wmb_tcm_write_done_x;
//-----------merge signal---------------
assign wmb_entry_merge_data_vld           = wmb_entry_merge_data_vld_x;
assign wmb_entry_merge_data_wait_not_vld_req  = wmb_entry_merge_data_wait_not_vld_req_x;
//-----------gateclk signal-------------
assign wmb_entry_mem_set_write_gateclk_en = wmb_entry_mem_set_write_gateclk_en_x;
//-----------------------output-----------------------------
//-----------entry signal---------------
assign wmb_entry_vld_x                    = wmb_entry_vld;
assign wmb_entry_sync_fence_x             = wmb_entry_sync_fence;
assign wmb_entry_atomic_x                 = wmb_entry_atomic;
assign wmb_entry_atomic_and_vld_x         = wmb_entry_atomic_and_vld;
assign wmb_entry_icc_x                    = wmb_entry_icc;
assign wmb_entry_icc_and_vld_x            = wmb_entry_icc_and_vld;
assign wmb_entry_inst_flush_x             = wmb_entry_inst_flush;
assign wmb_entry_inst_is_dcache_x         = wmb_entry_inst_is_dcache;
assign wmb_entry_dcache_inst_x            = wmb_entry_dcache_inst;
assign wmb_entry_inst_type_v[1:0]         = wmb_entry_inst_type[1:0];
assign wmb_entry_inst_size_v[2:0]         = wmb_entry_inst_size[2:0];
assign wmb_entry_inst_mode_v[1:0]         = wmb_entry_inst_mode[1:0];
assign wmb_entry_iid_v[IID_WIDTH-1:0]     = wmb_entry_iid[IID_WIDTH-1:0];
assign wmb_entry_priv_mode_v[1:0]         = wmb_entry_priv_mode[1:0];
assign wmb_entry_page_share_x             = wmb_entry_page_share;
assign wmb_entry_page_so_x                = wmb_entry_page_so;
assign wmb_entry_page_ca_x                = wmb_entry_page_ca;
assign wmb_entry_page_wa_x                = wmb_entry_page_wa;
assign wmb_entry_page_buf_x               = wmb_entry_page_buf;
assign wmb_entry_page_sec_x               = wmb_entry_page_sec;
assign wmb_entry_addr_v[`WK_PA_WIDTH-1:0]    = wmb_entry_addr[`WK_PA_WIDTH-1:0];
assign wmb_entry_spec_fail_x              = wmb_entry_spec_fail;
assign wmb_entry_vstart_vld_x             = wmb_entry_vstart_vld;
assign wmb_entry_dcache_way_x             = wmb_entry_dcache_way;
assign wmb_entry_dcache_page_share_x      = wmb_entry_dcache_page_share;
assign wmb_entry_dcache_dirty_x           = wmb_entry_dcache_dirty;
assign wmb_entry_dcache_share_x           = wmb_entry_dcache_share;
assign wmb_entry_dcache_valid_x           = wmb_entry_dcache_valid;
assign wmb_entry_data_v[127:0]            = wmb_entry_data[127:0];
assign wmb_entry_biu_id_v[4:0]            = wmb_entry_biu_id[4:0];
assign wmb_entry_w_last_x                 = wmb_entry_w_last;
assign wmb_entry_bytes_vld_v[15:0]        = wmb_entry_bytes_vld[15:0];
assign wmb_entry_write_imme_x             = wmb_entry_write_imme;
assign wmb_entry_depd_x                   = wmb_entry_depd;
assign wmb_entry_sc_wb_success_x          = wmb_entry_sc_wb_success;
assign wmb_entry_already_read_req_x       = wmb_entry_already_read_req;
assign wmb_entry_preg_v[PREG-1:0]         = wmb_entry_preg[PREG-1:0];
assign wmb_entry_sync_fence_inst_x        = wmb_entry_sync_fence_inst;
//-----------request--------------------
assign wmb_entry_fwd_data_pe_req0_x        = wmb_entry_fwd_data_pe_req0;//1->3, for 3 ld_dc, LTL@20241104
assign wmb_entry_fwd_data_pe_req1_x        = wmb_entry_fwd_data_pe_req1;
assign wmb_entry_fwd_data_pe_req2_x        = wmb_entry_fwd_data_pe_req2;
assign wmb_entry_fwd_data_pe_gateclk_en0_x = wmb_entry_fwd_data_pe_gateclk_en0;//1->3, for 3 ld_dc, LTL@20241104
assign wmb_entry_fwd_data_pe_gateclk_en1_x = wmb_entry_fwd_data_pe_gateclk_en1;
assign wmb_entry_fwd_data_pe_gateclk_en2_x = wmb_entry_fwd_data_pe_gateclk_en2;
assign wmb_entry_discard_req0_x            = wmb_entry_discard_req0;//1->3, for 3 ld_dc, LTL@20241104
assign wmb_entry_discard_req1_x            = wmb_entry_discard_req1;
assign wmb_entry_discard_req2_x            = wmb_entry_discard_req2;
assign wmb_entry_fwd_req0_x                = wmb_entry_fwd_req0;//1->3, for 3 ld_dc, LTL@20241104
assign wmb_entry_fwd_req1_x                = wmb_entry_fwd_req1;
assign wmb_entry_fwd_req2_x                = wmb_entry_fwd_req2;
assign wmb_entry_fwd_bytes_vld0_v[15:0]    = wmb_entry_fwd_bytes_vld0[15:0];//1->3, for 3 ld_dc, LTL@20241104
assign wmb_entry_fwd_bytes_vld1_v[15:0]    = wmb_entry_fwd_bytes_vld1[15:0];
assign wmb_entry_fwd_bytes_vld2_v[15:0]    = wmb_entry_fwd_bytes_vld2[15:0];
assign wmb_entry_wb_cmplt_req_x           = wmb_entry_wb_cmplt_req;
assign wmb_entry_wb_data_req_x            = wmb_entry_wb_data_req;
assign wmb_entry_read_req_x               = wmb_entry_read_req;
assign wmb_entry_read_dp_req_x            = wmb_entry_read_dp_req;
assign wmb_entry_write_req_x              = wmb_entry_write_req;
assign wmb_entry_write_biu_req_x          = wmb_entry_write_biu_req;
assign wmb_entry_write_biu_dp_req_x       = wmb_entry_write_biu_dp_req;
assign wmb_entry_write_dcache_req_x       = wmb_entry_write_dcache_req;
assign wmb_entry_write_vb_req_x           = wmb_entry_write_vb_req;
assign wmb_entry_write_tcm_req_x          = wmb_entry_write_tcm_req;
assign wmb_entry_dtcm_hit_x               = wmb_entry_dtcm_hit;
assign wmb_entry_data_req_x               = wmb_entry_data_req;
assign wmb_entry_data_biu_req_x           = wmb_entry_data_biu_req;
assign wmb_entry_data_req_wns_x           = wmb_entry_data_req_wns;
assign wmb_entry_pop_vld_x                = wmb_entry_pop_vld;
assign wmb_entry_cancel_acc_req0_x         = wmb_entry_cancel_acc_req0;//1->3, for 3 ld_dc, LTL@20241104
assign wmb_entry_cancel_acc_req1_x         = wmb_entry_cancel_acc_req1;
assign wmb_entry_cancel_acc_req2_x         = wmb_entry_cancel_acc_req2;
assign wmb_entry_merge_data_stall_x       = wmb_entry_merge_data_stall;
assign wmb_entry_merge_data_addr_hit_x    = wmb_entry_merge_data_addr_hit;
assign wmb_entry_write_stall_x            = wmb_entry_write_stall;
//-------maintain pointer---------------
assign wmb_entry_read_ptr_unconditional_shift_imme_x  = wmb_entry_read_ptr_unconditional_shift_imme;
assign wmb_entry_read_ptr_chk_idx_shift_imme_x        = wmb_entry_read_ptr_chk_idx_shift_imme;
assign wmb_entry_write_ptr_unconditional_shift_imme_x = wmb_entry_write_ptr_unconditional_shift_imme;
assign wmb_entry_write_ptr_chk_idx_shift_imme_x       = wmb_entry_write_ptr_chk_idx_shift_imme;
assign wmb_entry_data_ptr_after_write_shift_imme_x    = wmb_entry_data_ptr_after_write_shift_imme;
assign wmb_entry_data_ptr_after_write_shift_imme_gate_x = wmb_entry_data_ptr_after_write_shift_imme_gate;
assign wmb_entry_data_ptr_with_write_shift_imme_x     = wmb_entry_data_ptr_with_write_shift_imme;
//-----------hit idx--------------------
assign wmb_entry_pfu_biu_req_hit_idx_x    = wmb_entry_pfu_biu_req_hit_idx;
assign wmb_entry_rb_biu_req_hit_idx_x     = wmb_entry_rb_biu_req_hit_idx;
assign wmb_entry_snq_depd_x               = wmb_entry_snq_depd;
assign wmb_entry_sq_pop_sameline_set_x = wmb_entry_sq_pop_sameline_set;
assign wmb_entry_st_hit_sq_pop_dcache_line_x = wmb_entry_st_hit_sq_pop_dcache_line;
assign wmb_entry_dcache_inst_same_line_x  = wmb_entry_dcache_inst_same_line;
//-----------other signal---------------
assign wmb_entry_write_imme_bypass_x      = wmb_entry_write_imme_bypass;
assign wmb_entry_ready_to_dcache_line_x   = wmb_entry_ready_to_dcache_line;
assign wmb_entry_last_addr_plus_x         = wmb_entry_last_addr_plus;
assign wmb_entry_last_addr_sub_x          = wmb_entry_last_addr_sub;
assign wmb_entry_no_op_x                  = wmb_entry_no_op;
assign wmb_entry_read_resp_ready_x        = wmb_entry_read_resp_ready;
assign wmb_entry_snq_depd_remove_x        = wmb_entry_snq_depd_remove;
//--------to other module signal--------
assign wmb_entry_sync_fence_biu_req_success_x = wmb_entry_sync_fence_biu_req_success;
assign wmb_entry_ar_pending_x             = wmb_entry_ar_pending;
assign wmb_entry_aw_pending_x             = wmb_entry_aw_pending;
assign wmb_entry_w_pending_x              = wmb_entry_w_pending;

//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
assign wmb_entry_exec_cancel = wmb_entry_halt_info_0[0]
                             | wmb_entry_halt_info_1[0]
                             | wmb_entry_expt_vld;

assign wmb_entry_vld_exec         = wmb_entry_vld
                                    & ~wmb_entry_exec_cancel;

always @(posedge wmb_entry_create_clk or negedge cpurst_b)
begin
  if(~cpurst_b)
    wmb_entry_halt_info_0[`TDT_MP_HINFO_WIDTH-1:0] <= {`TDT_MP_HINFO_WIDTH{1'b0}};
  else if(wmb_entry_create_dp_vld)
    wmb_entry_halt_info_0[`TDT_MP_HINFO_WIDTH-1:0] <= wmb_ce_halt_info_0[`TDT_MP_HINFO_WIDTH-1:0];  
end

always @(posedge wmb_entry_create_clk or negedge cpurst_b)
begin
  if(~cpurst_b)
    wmb_entry_halt_info_1[`TDT_MP_HINFO_WIDTH-1:0] <= {`TDT_MP_HINFO_WIDTH{1'b0}};
  else if(wmb_entry_create_dp_vld)
    wmb_entry_halt_info_1[`TDT_MP_HINFO_WIDTH-1:0] <= wmb_ce_halt_info_1[`TDT_MP_HINFO_WIDTH-1:0];  
end

assign wmb_entry_halt_info_0_v[`TDT_MP_HINFO_WIDTH-1:0] = wmb_entry_halt_info_0[`TDT_MP_HINFO_WIDTH-1:0];
assign wmb_entry_halt_info_1_v[`TDT_MP_HINFO_WIDTH-1:0] = wmb_entry_halt_info_1[`TDT_MP_HINFO_WIDTH-1:0];
//==========================================================
//                  Risc-V Debug zdb End 
//==========================================================
// &ModuleEnd; @1544
endmodule


