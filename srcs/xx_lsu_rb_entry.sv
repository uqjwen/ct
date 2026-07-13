//-----------------------------------------------------------------------------
// File          : xx_lsu_rb_entry.sv
// Created       : 2024/10/15 (by Wen Jiahui)
// Last modified : 2024/10/15 (by Wen Jiahui)
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
// 2024/10/15 : Created
// 2024/XX/XX : 
//-----------------------------------------------------------------------------

//#
//# Module Declaration
//# ==================
//#
module xx_lsu_rb_entry #(
    IID_WIDTH = 10,
    PREG = 8,
    VREG = 9,
    VMBENTRY = 8
)(
input logic                                   rtu_ck_flush,
input logic [IID_WIDTH-1:0]                   rtu_ck_flush_iid,
input logic [4  :0]                           biu_lsu_b_id,                    
input logic                                   biu_lsu_b_vld,                   
input logic [255:0]                           biu_lsu_r_data_mask,             
input logic [4  :0]                           biu_lsu_r_id,                    
input logic                                   biu_lsu_r_vld,                   
input logic                                   cp0_lsu_icg_en,                  
input logic [1  :0]                           cp0_yy_priv_mode,                
input logic                                   cpurst_b,                        
input logic [`WK_PA_WIDTH-1 :0]               lda0_ex3_addr,                      
input logic [`WK_VA_WIDTH-1 :12]              lda0_ex3_vaddr,
input logic [1  :0]                           lda0_ex3_addr_5to4,                              
input logic                                   lda0_ex3_boundary_after_mask,       
input logic                                   lda0_ex3_boundary_after_mask_ff,    
input logic [15 :0]                           lda0_ex3_bytes_vld,                 
input logic [15 :0]                           lda0_ex3_bytes_vld1,                 
input logic [15 :0]                           lda0_ex3_bytes_vld2,                 
input logic [15 :0]                           lda0_ex3_bytes_vld3,                 
input logic [15 :0]                           lda0_ex3_data_rot_sel,              
input logic                                   lda0_ex3_dcache_hit,                
input logic [8  :0]                           lda0_ex3_element_cnt,               
input logic [1  :0]                           lda0_ex3_element_size,              
input logic [7  :0]                           lda0_ex3_idx,                       
input logic [IID_WIDTH-1:0]                   lda0_ex3_iid,                       
input logic                                   lda0_ex3_inst_fof,                  
input logic [2  :0]                           lda0_ex3_inst_size,                 
input logic                                   lda0_ex3_inst_vfls,                 
input logic                                   lda0_ex3_inst_vls,                  
input logic                                   lda0_ex3_mcic_borrow_mmu,           
input logic                                   lda0_ex3_page_buf,                  
input logic                                   lda0_ex3_page_ca,                   
input logic                                   lda0_ex3_page_sec,                  
input logic                                   lda0_ex3_page_share,                
input logic                                   lda0_ex3_page_so,                   
input logic [PREG-1:0]                        lda0_ex3_preg,                      
input logic                                   lda0_rb_ex3_atomic,                 
input logic                                   lda0_rb_ex3_cmit,                   
input logic                                   lda0_rb_ex3_cmplt_success,          
input logic                                   lda0_rb_ex3_create_lfb,             
input logic [127:0]                           lda0_rb_ex3_data_ori,               
input logic [127:0]                           lda0_rb_ex3_data_ori1,               
input logic [127:0]                           lda0_rb_ex3_data_ori2,               
input logic [127:0]                           lda0_rb_ex3_data_ori3,               
input logic                                   lda0_rb_ex3_data_vld,               
input logic                                   lda0_rb_ex3_dest_vld,               
input logic                                   lda0_rb_ex3_discard_grnt,           
input logic                                   lda0_rb_ex3_expt_vld,               
input logic                                   lda0_rb_ex3_ldamo,                  
input logic                                   lda0_rb_ex3_merge_dp_vld,           
input logic                                   lda0_rb_ex3_merge_expt_vld,         
input logic                                   lda0_rb_ex3_merge_gateclk_en,       
input logic                                   lda0_rb_ex3_merge_vld,              
input logic [15 :0]                           lda0_ex3_reg_bytes_vld,             
input logic [15 :0]                           lda0_ex3_reg_bytes_vld1,             
input logic [15 :0]                           lda0_ex3_reg_bytes_vld2,             
input logic [15 :0]                           lda0_ex3_reg_bytes_vld3,             
input logic                                   lda0_ex3_inst_us,
input logic [8  :0]                           lda0_ex3_setvl_val,                 
input logic                                   lda0_ex3_sign_extend,               
input logic                                   lda0_ex3_split,                     
// input logic [1  :0]                           lda0_ex3_vlmul,            
input logic [2  :0]           lda0_ex3_vlmul,  //pwh 1 for rvv1.0         
input logic [VMBENTRY-1:0]                    lda0_ex3_vmb_id,                    
input logic                                   lda0_ex3_vmb_merge_vld,             
input logic [VREG-1:0]                        lda0_ex3_vreg,                      
input logic                                   lda0_ex3_vreg_sign_sel,             
//input logic [1  :0]                           lda0_ex3_vsew,  //rvv1.0@hcl
input logic [1  :0]           lda0_ex3_vmew,  //rvv1.0@hcl
input logic [1  :0]           lda0_ex3_vmop,  //rvv1.0@hcl
input logic                                   lda0_ex3_spec_fail,              
input logic                                   lsu_biu_r_linefill_ready,
// input logic [39 :0]           lda1_ex3_addr,                      
// input logic [1  :0]           lda1_ex3_addr_5to4,                              
// input logic                   lda1_ex3_boundary_after_mask,       
// input logic                   lda1_ex3_boundary_after_mask_ff,    
// input logic [15 :0]           lda1_ex3_bytes_vld,                 
// input logic [15 :0]           lda1_ex3_data_rot_sel,              
// input logic                   lda1_ex3_dcache_hit,                
// input logic [6  :0]           lda1_ex3_element_cnt,               
// input logic [1  :0]           lda1_ex3_element_size,              
// input logic [7  :0]           lda1_ex3_idx,                       
// input logic [IID_WIDTH-1:0]   lda1_ex3_iid,                       
// input logic                   lda1_ex3_inst_fof,                  
// input logic [2  :0]           lda1_ex3_inst_size,                 
// input logic                   lda1_ex3_inst_vfls,                 
// input logic                   lda1_ex3_inst_vls,                  
// input logic                   lda1_ex3_mcic_borrow_mmu,           
// input logic                   lda1_ex3_page_buf,                  
// input logic                   lda1_ex3_page_ca,                   
// input logic                   lda1_ex3_page_sec,                  
// input logic                   lda1_ex3_page_share,                
// input logic                   lda1_ex3_page_so,                   
// input logic [PREG-1:0]        lda1_ex3_preg,                      
// input logic                   lda1_rb_ex3_atomic,                 
// input logic                   lda1_rb_ex3_cmit,                   
// input logic                   lda1_rb_ex3_cmplt_success,          
// input logic                   lda1_rb_ex3_create_lfb,             
// input logic [127:0]           lda1_rb_ex3_data_ori,               
// input logic                   lda1_rb_ex3_data_vld,               
// input logic                   lda1_rb_ex3_dest_vld,               
// input logic                   lda1_rb_ex3_discard_grnt,           
// input logic                   lda1_rb_ex3_expt_vld,               
// input logic                   lda1_rb_ex3_ldamo,                  
// input logic                   lda1_rb_ex3_merge_dp_vld,           
// input logic                   lda1_rb_ex3_merge_expt_vld,         
// input logic                   lda1_rb_ex3_merge_gateclk_en,       
// input logic                   lda1_rb_ex3_merge_vld,              
// input logic [15 :0]           lda1_ex3_reg_bytes_vld,             
// input logic [6  :0]           lda1_ex3_setvl_val,                 
// input logic                   lda1_ex3_sign_extend,               
// input logic                   lda1_ex3_split,                     
// input logic [1  :0]           lda1_ex3_vlmul,                     
// input logic [VMBENTRY-1:0]    lda1_ex3_vmb_id,                    
// input logic                   lda1_ex3_vmb_merge_vld,             
// input logic [VREG-1:0]        lda1_ex3_vreg,                      
// input logic                   lda1_ex3_vreg_sign_sel,             
// input logic [1  :0]           lda1_ex3_vsew,                      
// input logic                   lda1_ex3_spec_fail,    
input logic                                   lm_already_snoop,                
input logic                                   lsu_has_fence,                   
input logic                                   lsu_special_clk,                 
input logic                                   pad_yy_icg_scan_en,              
input logic [`WK_PA_WIDTH-1 :0]               pfu_biu_req_addr,                
input logic [4  :0]                           rb_biu_ar_id,                    
input logic                                   rb_create_ptr0_x,                
// input logic                   rb_create_ptr1_x,                
input logic                                   rb_create_ptr2_x,                
input logic                                   rb_create_ptr3_x,                
input logic                                   rb_entry_biu_id_gateclk_en_x,    
input logic                                   rb_entry_biu_pe_req_grnt_x,      
input logic                                   rb_entry_ld0_create_dp_vld_x,     
input logic                                   rb_entry_ld0_create_gateclk_en_x, 
input logic                                   rb_entry_ld0_create_vld_x,        
// input logic                   rb_entry_ld1_create_dp_vld_x,     
// input logic                   rb_entry_ld1_create_gateclk_en_x, 
// input logic                   rb_entry_ld1_create_vld_x,        
input logic                                   rb_entry_next_so_bypass_x,       
input logic                                   rb_entry_read_req_grnt_x,        
input logic                                   rb_entry_ls0_create_dp_vld_x,     
input logic                                   rb_entry_ls0_create_gateclk_en_x, 
input logic                                   rb_entry_ls0_create_vld_x,        
input logic                                   rb_entry_ls1_create_dp_vld_x,     
input logic                                   rb_entry_ls1_create_gateclk_en_x, 
input logic                                   rb_entry_ls1_create_vld_x,        
input logic                                   rb_entry_wb_cmplt_grnt_x,        
input logic                                   rb_entry_wb_data_grnt_x,         
input logic                                   rb_fence_ld,                     
// input logic                   rb_ld_biu_pe_req_grnt, 
input logic                                   rb_ld0_biu_pe_req_grnt,
input logic                                   rb_ls0_biu_pe_req_grnt,
input logic                                   rb_ls1_biu_pe_req_grnt,
input logic                                   rb_r_resp_err,                   
input logic                                   rb_r_resp_okay,                  
input logic                                   rb_ready_all_req_biu_success,    
input logic                                   rb_ready_ld_req_biu_success,     
input logic                                   rtu_lsu_async_flush,             
input logic                                   rtu_yy_xx_commit0,               
input logic [IID_WIDTH-1:0]                   rtu_yy_xx_commit0_iid,           
input logic                                   rtu_yy_xx_commit1,               
input logic [IID_WIDTH-1:0]                   rtu_yy_xx_commit1_iid,           
input logic                                   rtu_yy_xx_commit2,               
input logic [IID_WIDTH-1:0]                   rtu_yy_xx_commit2_iid,           
input logic                                   rtu_yy_xx_commit3,               
input logic [IID_WIDTH-1:0]                   rtu_yy_xx_commit3_iid,           
input logic                                   rtu_yy_xx_commit4,               
input logic [IID_WIDTH-1:0]                   rtu_yy_xx_commit4_iid,           
input logic                                   rtu_yy_xx_commit5,               
input logic [IID_WIDTH-1:0]                   rtu_yy_xx_commit5_iid,           
input logic                                   rtu_yy_xx_commit6,               
input logic [IID_WIDTH-1:0]                   rtu_yy_xx_commit6_iid,           
input logic                                   rtu_yy_xx_commit7,               
input logic [IID_WIDTH-1:0]                   rtu_yy_xx_commit7_iid,           
input logic                                   rtu_yy_xx_flush,                 
input logic [`WK_PA_WIDTH-1 :0]               sq_pop_addr,                     
input logic                                   sq_pop_page_ca,                  
input logic                                   sq_pop_page_so,                  
input logic                                   lsda0_ex3_is_load,
input logic                                   lsda0_ex3_fence_inst, // only for st
input logic [3  :0]                           lsda0_ex3_fence_mode, // only for st
input logic                                   lsda0_ex3_sync_inst,  // only for st
input logic [`WK_PA_WIDTH-1 :0]               lsda0_ex3_addr,                      //shared
input logic [`WK_VA_WIDTH-1 :12]              lsda0_ex3_vaddr,
input logic [`WK_PA_WIDTH-1:0]                lsda0_ex3_ld_addr,
input logic [`WK_PA_WIDTH-1:0]                lsda0_ex3_st_addr,
input logic [1  :0]                           lsda0_ex3_addr_5to4,                              
input logic                                   lsda0_ex3_boundary_after_mask,       
input logic                                   lsda0_ex3_boundary_after_mask_ff,    
input logic [15 :0]                           lsda0_ex3_bytes_vld,                 
input logic [15 :0]                           lsda0_ex3_bytes_vld1,                 
input logic [15 :0]                           lsda0_ex3_bytes_vld2,                 
input logic [15 :0]                           lsda0_ex3_bytes_vld3,                 
input logic [15 :0]                           lsda0_ex3_data_rot_sel,              
input logic                                   lsda0_ex3_dcache_hit,                //shared
input logic [8  :0]                           lsda0_ex3_element_cnt,               
input logic [1  :0]                           lsda0_ex3_element_size,              
input logic [7  :0]                           lsda0_ex3_idx,                       
input logic [IID_WIDTH-1:0]                   lsda0_ex3_iid,                       
input logic [IID_WIDTH-1:0]                   lsda0_ex3_ld_iid,
input logic [IID_WIDTH-1:0]                   lsda0_ex3_st_iid,
input logic                                   lsda0_ex3_inst_fof,                  
input logic [2  :0]                           lsda0_ex3_inst_size,                 
input logic                                   lsda0_ex3_inst_vfls,                 
input logic                                   lsda0_ex3_inst_vls,                  
input logic                                   lsda0_ex3_mcic_borrow_mmu,           
input logic                                   lsda0_ex3_page_buf,                  
input logic                                   lsda0_ex3_page_ca,                   
input logic                                   lsda0_ex3_ld_page_ca,
input logic                                   lsda0_ex3_st_page_ca,
input logic                                   lsda0_ex3_page_sec,                  
input logic                                   lsda0_ex3_page_share,                
input logic                                   lsda0_ex3_page_so,                   
input logic [PREG-1:0]                        lsda0_ex3_preg,                      
input logic                                   lsda0_rb_ex3_atomic,                 
input logic                                   lsda0_rb_ex3_cmit,                   
input logic                                   lsda0_rb_ex3_cmplt_success,          
input logic                                   lsda0_rb_ex3_create_lfb,             
input logic [127:0]                           lsda0_rb_ex3_data_ori,               
input logic [127:0]                           lsda0_rb_ex3_data_ori1,               
input logic [127:0]                           lsda0_rb_ex3_data_ori2,               
input logic [127:0]                           lsda0_rb_ex3_data_ori3,               
input logic                                   lsda0_rb_ex3_data_vld,               
input logic                                   lsda0_rb_ex3_dest_vld,               
input logic                                   lsda0_rb_ex3_discard_grnt,           
input logic                                   lsda0_rb_ex3_expt_vld,               
input logic                                   lsda0_rb_ex3_ldamo,                  
input logic                                   lsda0_rb_ex3_merge_dp_vld,           
input logic                                   lsda0_rb_ex3_merge_expt_vld,         
input logic                                   lsda0_rb_ex3_merge_gateclk_en,       
input logic                                   lsda0_rb_ex3_merge_vld,              
input logic [15 :0]                           lsda0_ex3_reg_bytes_vld,             
input logic [15 :0]                           lsda0_ex3_reg_bytes_vld1,             
input logic [15 :0]                           lsda0_ex3_reg_bytes_vld2,             
input logic [15 :0]                           lsda0_ex3_reg_bytes_vld3,             
input logic                                   lsda0_ex3_inst_us,
input logic [8  :0]                           lsda0_ex3_setvl_val,                 
input logic                                   lsda0_ex3_sign_extend,               
input logic                                   lsda0_ex3_split,                     
// input logic [1  :0]                           lsda0_ex3_vlmul,  
input logic [2  :0]           lsda0_ex3_vlmul,  //pwh 2 for rvv1.0                  
input logic [VMBENTRY-1:0]                    lsda0_ex3_vmb_id,                    
input logic                                   lsda0_ex3_vmb_merge_vld,             
input logic [VREG-1:0]                        lsda0_ex3_vreg,                      
input logic                                   lsda0_ex3_vreg_sign_sel,             
//input logic [1  :0]                           lsda0_ex3_vsew,    //rvv1.0@hcl  
input logic [1  :0]           lsda0_ex3_vmew,    //rvv1.0@hcl
input logic [1  :0]           lsda0_ex3_vmop,    //rvv1.0@hcl                
input logic                                   lsda0_ex3_spec_fail,              
input logic                                   lsda1_ex3_is_load,
input logic                                   lsda1_ex3_fence_inst, // only for st
input logic [3  :0]                           lsda1_ex3_fence_mode, // only for st
input logic                                   lsda1_ex3_sync_inst,  // only for st
input logic [`WK_PA_WIDTH-1 :0]               lsda1_ex3_addr,                      //shared
input logic [`WK_VA_WIDTH-1 :12]              lsda1_ex3_vaddr,
input logic [`WK_PA_WIDTH-1:0]                lsda1_ex3_ld_addr,
input logic [`WK_PA_WIDTH-1:0]                lsda1_ex3_st_addr,
input logic [1  :0]                           lsda1_ex3_addr_5to4,                                
input logic                                   lsda1_ex3_boundary_after_mask,       
input logic                                   lsda1_ex3_boundary_after_mask_ff,    
input logic [15 :0]                           lsda1_ex3_bytes_vld,                 
input logic [15 :0]                           lsda1_ex3_bytes_vld1,                 
input logic [15 :0]                           lsda1_ex3_bytes_vld2,                 
input logic [15 :0]                           lsda1_ex3_bytes_vld3,                 
input logic [15 :0]                           lsda1_ex3_data_rot_sel,              
input logic                                   lsda1_ex3_dcache_hit,                //shared
input logic [8  :0]                           lsda1_ex3_element_cnt,               
input logic [1  :0]                           lsda1_ex3_element_size,              
input logic [7  :0]                           lsda1_ex3_idx,                       
input logic [IID_WIDTH-1:0]                   lsda1_ex3_iid,                       
input logic [IID_WIDTH-1:0]                   lsda1_ex3_ld_iid,
input logic [IID_WIDTH-1:0]                   lsda1_ex3_st_iid,
input logic                                   lsda1_ex3_inst_fof,                  
input logic [2  :0]                           lsda1_ex3_inst_size,                 
input logic                                   lsda1_ex3_inst_vfls,                 
input logic                                   lsda1_ex3_inst_vls,                  
input logic                                   lsda1_ex3_mcic_borrow_mmu,           
input logic                                   lsda1_ex3_page_buf,                  
input logic                                   lsda1_ex3_page_ca,                   
input logic                                   lsda1_ex3_ld_page_ca,
input logic                                   lsda1_ex3_st_page_ca,
input logic                                   lsda1_ex3_page_sec,                  
input logic                                   lsda1_ex3_page_share,                
input logic                                   lsda1_ex3_page_so,                   
input logic [PREG-1:0]                        lsda1_ex3_preg,                      
input logic                                   lsda1_rb_ex3_atomic,                 
input logic                                   lsda1_rb_ex3_cmit,                   
input logic                                   lsda1_rb_ex3_cmplt_success,          
input logic                                   lsda1_rb_ex3_create_lfb,             
input logic [127:0]                           lsda1_rb_ex3_data_ori,               
input logic [127:0]                           lsda1_rb_ex3_data_ori1,               
input logic [127:0]                           lsda1_rb_ex3_data_ori2,               
input logic [127:0]                           lsda1_rb_ex3_data_ori3,               
input logic                                   lsda1_rb_ex3_data_vld,               
input logic                                   lsda1_rb_ex3_dest_vld,               
input logic                                   lsda1_rb_ex3_discard_grnt,           
input logic                                   lsda1_rb_ex3_expt_vld,               
input logic                                   lsda1_rb_ex3_ldamo,                  
input logic                                   lsda1_rb_ex3_merge_dp_vld,           
input logic                                   lsda1_rb_ex3_merge_expt_vld,         
input logic                                   lsda1_rb_ex3_merge_gateclk_en,       
input logic                                   lsda1_rb_ex3_merge_vld,              
input logic [15 :0]                           lsda1_ex3_reg_bytes_vld,             
input logic [15 :0]                           lsda1_ex3_reg_bytes_vld1,             
input logic [15 :0]                           lsda1_ex3_reg_bytes_vld2,             
input logic [15 :0]                           lsda1_ex3_reg_bytes_vld3,             
input logic                                   lsda1_ex3_inst_us,
input logic [8  :0]                           lsda1_ex3_setvl_val,                 
input logic                                   lsda1_ex3_sign_extend,               
input logic                                   lsda1_ex3_split,                     
// input logic [1  :0]                           lsda1_ex3_vlmul,      
input logic [2  :0]           lsda1_ex3_vlmul,  //pwh 3 for rvv1.0              
input logic [VMBENTRY-1:0]                    lsda1_ex3_vmb_id,                    
input logic                                   lsda1_ex3_vmb_merge_vld,             
input logic [VREG-1:0]                        lsda1_ex3_vreg,                      
input logic                                   lsda1_ex3_vreg_sign_sel,             
//input logic [1  :0]                           lsda1_ex3_vsew,     //rvv1.0@hcl  
input logic [1  :0]           lsda1_ex3_vmew,     //rvv1.0@hcl
input logic [1  :0]           lsda1_ex3_vmop,     //rvv1.0@hcl               
input logic                                   lsda1_ex3_spec_fail,        
input logic [`WK_PA_WIDTH-1 :0]               wmb_ce_addr,                     
input logic                                   wmb_ce_page_ca,                  
input logic                                   wmb_ce_page_so,                  
input logic                                   wmb_rb_so_pending,               
input logic                                   wmb_sync_fence_biu_req_success,  
output logic  [`WK_PA_WIDTH-1 :0]             rb_entry_addr_v,                 
output logic  [`WK_VA_WIDTH-1 :12]            rb_entry_vaddr_v,                 
output logic                                  rb_entry_atomic_next_resp_x,     
output logic                                  rb_entry_atomic_x,               
output logic                                  rb_entry_biu_pe_req_gateclk_en_x, 
output logic                                  rb_entry_biu_pe_req_x,           
output logic                                  rb_entry_biu_req_x,                        
output logic                                  rb_entry_bus_err_x,              
output logic                                  rb_entry_cmit_data_vld_x,        
output logic                                  rb_entry_create_lfb_x,           
output logic  [127:0]                         rb_entry_data_v,                 
output logic  [127:0]                         rb_entry_data1_v,                 
output logic  [127:0]                         rb_entry_data2_v,                 
output logic  [127:0]                         rb_entry_data3_v,                 
output logic                                  rb_entry_depd_wakeup0_x,          
// output logic                  rb_entry_depd_wakeup1_x,          
output logic                                  rb_entry_depd_wakeup2_x,          
output logic                                  rb_entry_depd_wakeup3_x,          
output logic                                  rb_entry_depd0_x,                 
// output logic                  rb_entry_depd1_x,                 
output logic                                  rb_entry_depd2_x,                 
output logic                                  rb_entry_depd3_x,                 
output logic                                  rb_entry_discard_vld0_x,          
// output logic                  rb_entry_discard_vld1_x,          
output logic                                  rb_entry_discard_vld2_x,          
output logic                                  rb_entry_discard_vld3_x,          
output logic [8  :0]                          rb_entry_element_cnt_v,          
output logic [1  :0]                          rb_entry_element_size_v,         
output logic                                  rb_entry_expt_vld_x,             
output logic                                  rb_entry_fence_ld_vld_x,         
output logic                                  rb_entry_fence_x,                
output logic                                  rb_entry_flush_clear_x,          
output logic [IID_WIDTH-1:0]                  rb_entry_iid_v,                  
output logic                                  rb_entry_inst_fof_x,             
output logic [2  :0]                          rb_entry_inst_size_v,            
output logic                                  rb_entry_inst_vfls_x,            
output logic                                  rb_entry_inst_vls_x,             
output logic                                  rb_entry_lda0_hit_idx_x,        
// output logic                  rb_entry_lda1_hit_idx_x,        
output logic                                  rb_entry_lsda0_ld_hit_idx_x,        
output logic                                  rb_entry_lsda0_st_hit_idx_x,        
output logic                                  rb_entry_lsda1_ld_hit_idx_x,        
output logic                                  rb_entry_lsda1_st_hit_idx_x,        
output logic                                  rb_entry_ldamo_x,                
output logic                                  rb_entry_mcic_req_x,             
output logic                                  rb_entry_memr_wait_resp_x,       
output logic                                  rb_entry_merge_fail0_x,           
// output logic                  rb_entry_merge_fail1_x,           
output logic                                  rb_entry_merge_fail2_x,           
output logic                                  rb_entry_merge_fail3_x,           
output logic                                  rb_entry_page_buf_x,             
output logic                                  rb_entry_page_ca_x,              
output logic                                  rb_entry_page_sec_x,             
output logic                                  rb_entry_page_share_x,           
output logic                                  rb_entry_page_so_x,              
output logic                                  rb_entry_pfu_biu_req_hit_idx_x,  
output logic [PREG-1:0]                       rb_entry_preg_v,                 
output logic [1  :0]                          rb_entry_priv_mode_v,            
output logic [15 :0]                          rb_entry_reg_bytes_vld_v,        
output logic [15 :0]                          rb_entry_reg_bytes_vld1_v,        
output logic [15 :0]                          rb_entry_reg_bytes_vld2_v,        
output logic [15 :0]                          rb_entry_reg_bytes_vld3_v,        
output logic                                  rb_entry_inst_us_x,
output logic [15 :0]                          rb_entry_rot_sel_v,              
output logic [8  :0]                          rb_entry_setvl_val_v,            
output logic                                  rb_entry_sign_extend_x,          
output logic                                  rb_entry_spec_fail_x,            
output logic                                  rb_entry_split_x,                
output logic                                  rb_entry_sq_pop_hit_idx_x,       
output logic                                  rb_entry_st_x,                   
output logic [3  :0]                          rb_entry_state_v,                
output logic                                  rb_entry_sync_fence_x,           
output logic                                  rb_entry_sync_x,                 
output logic                                  rb_entry_vld_x,                  
// output logic [1  :0]                          rb_entry_vlmul_v, 
output logic [2  :0]          rb_entry_vlmul_v,  //pwh 4 for rvv1.0              
output logic [VMBENTRY-1:0]                   rb_entry_vmb_id_v,               
output logic                                  rb_entry_vmb_merge_vld_x,        
output logic                                  rb_entry_vreg_sign_sel_x,        
output logic [VREG-1:0]                       rb_entry_vreg_v,                 
//output logic [1  :0]                          rb_entry_vsew_v, //rvv1.0 @hcl
output logic [1  :0]          rb_entry_vmew_v, //rvv1.0 @hcl
output logic [1  :0]          rb_entry_vmop_v, //rvv1.0 @hcl
output logic                                  rb_entry_wb_cmplt_req_x,         
output logic                                  rb_entry_wb_data_pre_sel_x,      
output logic                                  rb_entry_wb_data_req_x,          
output logic                                  rb_entry_wmb_ce_hit_idx_x,
//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
input  logic [`TDT_MP_HINFO_WIDTH-1:0]          dtu_lsu_ld0_addr_halt_info,
input  logic [`TDT_MP_HINFO_WIDTH-1:0]          dtu_lsu_ls0_addr_halt_info,
input  logic [`TDT_MP_HINFO_WIDTH-1:0]          dtu_lsu_ls1_addr_halt_info,
input  logic [`TDT_MP_HINFO_WIDTH-1:0]          dtu_lsu_ld0_data_halt_info,
input  logic [`TDT_MP_HINFO_WIDTH-1:0]          dtu_lsu_ls0_data_halt_info,
input  logic [`TDT_MP_HINFO_WIDTH-1:0]          dtu_lsu_ls1_data_halt_info,      
input  logic                                    lda0_rb_ex3_data_check,
input  logic                                    lsda0_rb_ex3_data_check,
input  logic                                    lsda1_rb_ex3_data_check,
input  logic                                    ld0_data_halt_info_update_vld_x,
input  logic                                    ls0_data_halt_info_update_vld_x,
input  logic                                    ls1_data_halt_info_update_vld_x,
output logic                                    rb_entry_data_check_x,
output logic [`TDT_MP_HINFO_WIDTH-1:0]          rb_entry_halt_info_v
//==========================================================
//                  Risc-V Debug zdb End 
//==========================================================    
);


//the state machine is devided to 2 part:
//before request biu: state[2] = 0
//after request biu:  state[2] = 1
parameter IDLE        = 4'b0000,
          WAIT_RDY    = 4'b1000,
          REQ_BIU     = 4'b1001,
          WAIT_RESP   = 4'b1100,
          REQ_WB      = 4'b1101,
          WAIT_MERGE  = 4'b1110,
          WAIT_DATA_FF= 4'b1011,
          FLUSH_FF    = 4'b1010;


parameter S_BYTE        = 2'b00,
          HALF        = 2'b01,
          WORD        = 2'b10,
          DWORD       = 2'b11;

// ---------------- define logic here ----------------------
// clk gate
logic                                         rb_entry_clk_en; 
logic                                         rb_entry_clk;
logic                                         rb_entry_create_up_clk_en;

logic                                         rb_entry_ld0_merge_gateclk_en;
// logic                                         rb_entry_ld1_merge_gateclk_en;
logic                                         rb_entry_ls0_merge_gateclk_en;
logic                                         rb_entry_ls1_merge_gateclk_en;
logic                                         rb_entry_create_up_clk;

logic                                         rb_entry_data_clk_en;
logic                                         rb_entry_data_clk;

logic                                         rb_entry_biu_id_clk_en;
logic                                         rb_entry_biu_id_clk;
// rb entry reg                       
logic                                         rb_entry_vld;
logic                                         rb_entry_mcic_req;
logic [`WK_PA_WIDTH-1:0]                      rb_entry_addr;
logic [`WK_VA_WIDTH-1:12]                     rb_entry_vaddr;
logic [15:0]                                  rb_entry_bytes_vld;
logic [15:0]                                  rb_entry_bytes_vld1;
logic [15:0]                                  rb_entry_bytes_vld2;
logic [15:0]                                  rb_entry_bytes_vld3;
logic [IID_WIDTH-1:0]                         rb_entry_iid;
logic [3:0]                                   rb_entry_fence_mode;
logic                                         rb_entry_sign_extend;
logic                                         rb_entry_boundary;
logic [PREG-1:0]                              rb_entry_preg;
logic                                         rb_entry_page_ca;
logic                                         rb_entry_page_so;
logic                                         rb_entry_page_sec;
logic                                         rb_entry_page_buf;
logic                                         rb_entry_page_share;
logic                                         rb_entry_sync;
logic                                         rb_entry_fence;
logic                                         rb_entry_atomic;
logic                                         rb_entry_ldamo;
logic                                         rb_entry_dcache_hit;
logic                                         rb_entry_st;
logic [2:0]                                   rb_entry_inst_size;
logic                                         rb_entry_create_lfb;
logic [VREG-1:0]                              rb_entry_vreg;
logic                                         rb_entry_inst_vfls;
logic                                         rb_entry_vreg_sign_sel;
logic [1:0]                                   rb_entry_priv_mode;
logic                                         rb_entry_cmit;
logic                                         rb_entry_expt_vld;
logic                                         rb_entry_secd_expt;
logic [8:0]                                   rb_entry_secd_setvl_val;
logic [8:0]                                   rb_entry_setvl_val_final;
logic [15:0]                                  rb_entry_reg_bytes_vld;
logic [15:0]                                  rb_entry_reg_bytes_vld1;
logic [15:0]                                  rb_entry_reg_bytes_vld2;
logic [15:0]                                  rb_entry_reg_bytes_vld3;
logic                                         rb_entry_inst_us;
//logic [1:0]                                   rb_entry_vsew; //rvv1.0@hcl 
logic [1:0]               rb_entry_vmew; //rvv1.0@hcl
logic [1:0]               rb_entry_vmop; //rvv1.0@hcl
// logic [1:0]                                   rb_entry_vlmul;
logic [2:0]               rb_entry_vlmul;  //pwh 5 for rvv1.0
logic [1:0]                                   rb_entry_element_size;
logic [8:0]                                   rb_entry_element_cnt;
logic [8:0]                                   rb_entry_setvl_val;
logic [VMBENTRY-1:0]                          rb_entry_vmb_id;
logic                                         rb_entry_inst_vls;
logic                                         rb_entry_inst_fof;
logic                                         rb_entry_vmb_merge_vld;
logic                                         rb_entry_split;
logic [15:0]                                  rb_entry_rot_sel;
logic                                         rb_entry_secd;
logic                                         rb_entry_wb_cmplt_success;
logic                                         rb_entry_wb_data_success;
logic [4:0]                                   rb_entry_biu_id;
logic                                         rb_entry_biu_r_resp;
logic                                         rb_entry_biu_b_resp;
logic                                         rb_entry_bus_err;
logic                                         rb_entry_biu_pe_req_success;
logic                                         rb_entry_dest_vld;
logic [127:0]                                 rb_entry_data;
logic                                         rb_entry_depd0;
// logic                                         rb_entry_depd1;
logic                                         rb_entry_depd2;
logic                                         rb_entry_depd3;
logic                                         rb_entry_discard_vld0;
// logic                                         rb_entry_discard_vld1;
logic                                         rb_entry_discard_vld2;
logic                                         rb_entry_discard_vld3;
logic                                         rb_entry_wakeup_pop0;
// logic                                         rb_entry_wakeup_pop1;
logic                                         rb_entry_wakeup_pop2;
logic                                         rb_entry_wakeup_pop3;
logic                                         rb_entry_boundary_depd0;
// logic                                         rb_entry_boundary_depd1;
logic                                         rb_entry_boundary_depd2;
logic                                         rb_entry_boundary_depd3;
logic                                         rb_entry_boundary_wakeup0;
// logic                                         rb_entry_boundary_wakeup1;
logic                                         rb_entry_boundary_wakeup2;
logic                                         rb_entry_boundary_wakeup3;
logic                                         rb_entry_boundary_depd_set0;
// logic                                         rb_entry_boundary_depd_set1;
logic                                         rb_entry_boundary_depd_set2;
logic                                         rb_entry_boundary_depd_set3;
logic                                         rb_entry_fof_bus_err_expt;
logic                                         rb_entry_biu_r_resp_set;
logic                                         rb_entry_biu_b_resp_set;
logic                                         rb_entry_bus_err_set;
logic                                         rb_entry_fof_not_first;
// signal of rb fsm
logic [3:0]                                   rb_entry_state;
logic [3:0]                                   rb_entry_next_state;
logic                                         rb_entry_biu_req_success;
logic                                         rb_entry_cmit_set;
// signal driven/used by rb fsm
logic                                         rb_entry_ld_wait_data_ff;
logic                                         rb_entry_data_bypass_vld;
logic                                         rb_entry_data_bypass_vld0;
logic                                         rb_entry_data_bypass_vld1;
logic                                         rb_entry_data_bypass_vld2;
logic                                         rb_entry_data_bypass_vld3;
logic                                         rb_entry_create_wait_rdy;
logic                                         rb_entry_flush_clear;
logic                                         rb_entry_ready_to_biu_req;
logic                                         rb_entry_wait_resp_imme_idle;
logic                                         rb_entry_sync_fence_resp_success;
logic                                         rb_entry_wait_resp_to_req_merge;
logic                                         rb_entry_req_wb_success;
logic                                         rb_entry_hit_fence_ld;
logic                                         rb_entry_fence_ready;
logic                                         rb_entry_sync_ready;
logic                                         rb_entry_not_sync_fence_ready;
logic                                         rb_entry_biu_pe_req_gateclk_en;
logic                                         rb_entry_biu_req;
logic                                         rb_entry_b_id_hit;
logic                                         rb_entry_r_id_hit;
logic                                         rb_entry_atomic_next_resp;
logic                                         rb_entry_fof_bus_err;
logic [8:0]                                   rb_entry_fof_bus_err_element;
logic [3:0]                                   rb_entry_fof_vreg_element;
logic [127:0]                                 rb_entry_biu_data_ori;
logic [127:0]                                 rb_entry_biu_data_ori1;
logic [127:0]                                 rb_entry_biu_data_ori2;
logic [127:0]                                 rb_entry_biu_data_ori3;
logic                                         rb_entry_merge_sel;
logic [127:0]                                 rb_entry_merge_data_ori;
logic [127:0]                                 rb_entry_data_ori_mux;
logic [15:0]                                  rb_entry_merge_bytes_vld;
logic [127:0]                                 rb_entry_merge_data_sel;
logic [127:0]                                 rb_entry_merge_data_aft_rev;
logic                                         rb_entry_sync_resp_success;
logic                                         rb_entry_fence_resp_success;
logic                                         rb_entry_wb_cmplt_req;
logic                                         rb_entry_wb_data_req;
logic                                         rb_entry_wb_data_req_pre;
logic                                         rb_entry_wb_data_pre_sel;
logic                                         rb_entry_data_vld;
logic                                         rb_entry_flush_ff;
logic                                         rb_entry_ld0_merge_pre;
// logic                                         rb_entry_ld1_merge_pre;
logic                                         rb_entry_ls0_merge_pre;
logic                                         rb_entry_ls1_merge_pre;
// logic                                         rb_entry_ld0_merge_gateclk_en;
// logic                                         rb_entry_ld1_merge_gateclk_en;
// logic                                         rb_entry_ls0_merge_gateclk_en;
// logic                                         rb_entry_ls1_merge_gateclk_en;
logic                                         rb_entry_addr_5to4_hit0;
// logic                                         rb_entry_addr_5to4_hit1;
logic                                         rb_entry_addr_5to4_hit2;
logic                                         rb_entry_addr_5to4_hit3;

logic                                         rb_entry_bytes_vld_hit0;
// logic                                         rb_entry_bytes_vld_hit1;
logic                                         rb_entry_bytes_vld_hit2;
logic                                         rb_entry_bytes_vld_hit3;
// merge signals
logic                                         rb_entry_ld0_merge_dp_vld;
// logic                                         rb_entry_ld1_merge_dp_vld;
logic                                         rb_entry_ls0_merge_dp_vld;
logic                                         rb_entry_ls1_merge_dp_vld;
logic                                         rb_entry_ld0_merge_vld;
// logic                                         rb_entry_ld1_merge_vld;
logic                                         rb_entry_ls0_merge_vld;
logic                                         rb_entry_ls1_merge_vld;
logic                                         rb_entry_ld0_merge_expt_vld;
// logic                                         rb_entry_ld1_merge_expt_vld;
logic                                         rb_entry_ls0_merge_expt_vld;
logic                                         rb_entry_ls1_merge_expt_vld;
logic                                         rb_entry_ls0_ld_hit_idx;
logic                                         rb_entry_ls1_ld_hit_idx;
logic                                         rb_entry_ls0_st_hit_idx;
logic                                         rb_entry_ls1_st_hit_idx;
logic                                         rb_entry_sq_pop_cmp_vld;
logic [`WK_PA_WIDTH-1:0]                      rb_entry_cmp_sq_pop_addr;
logic                                         rb_entry_sq_pop_hit_idx;
logic [`WK_PA_WIDTH-1:0]                      rb_entry_cmp_wmb_ce_addr;
logic                                         rb_entry_wmb_ce_cmp_vld;
logic                                         rb_entry_wmb_ce_hit_idx;
logic [`WK_PA_WIDTH-1:0]                      rb_entry_cmp_pfu_biu_req_addr;
logic                                         rb_entry_pfu_biu_req_hit_idx;
logic                                         rb_entry_cmit_data_not_vld;
logic                                         rb_entry_memr_wait_resp;
logic                                         rb_entry_biu_pe_req;
logic                                         rb_entry_fence_ld_vld;

logic                                         rtu_ck_flush_iid_older_than_entry_iid;  //ck_flush@LTL
// ff reg
logic                                         rb_entry_ld0_create_vld_ff;
// logic                                         rb_entry_ld1_create_vld_ff;
logic                                         rb_entry_ls0_create_vld_ff;
logic                                         rb_entry_ls1_create_vld_ff;
logic                                         rb_entry_ld0_merge_vld_ff;
// logic                                         rb_entry_ld1_merge_vld_ff;
logic                                         rb_entry_ls0_merge_vld_ff;
logic                                         rb_entry_ls1_merge_vld_ff;
logic [127:0]                                 lda0_data_aft_rev_ff;
// logic [127:0]                                 lda1_data_aft_rev_ff;
logic [127:0]                                 lsda0_data_aft_rev_ff;
logic [127:0]                                 lsda1_data_aft_rev_ff;


logic                                         rb_entry_data_merge_vld;
logic                                         rb_entry_data_merge_vld0;
logic                                         rb_entry_data_merge_vld1;
logic                                         rb_entry_data_merge_vld2;
logic                                         rb_entry_data_merge_vld3;

logic [127:0]                                 rb_entry_merge_data;
logic [127:0]                                 rb_entry_merge_data0;
logic [127:0]                                 rb_entry_merge_data1;
logic [127:0]                                 rb_entry_merge_data2;
logic [127:0]                                 rb_entry_merge_data3;
logic [127:0]                                 rb_entry_biu_data_update;
logic [127:0]                                 ld_da_data_aft_rev;
logic [127:0]                                 ld_da_data_aft_rev1;
logic [127:0]                                 ld_da_data_aft_rev2;
logic [127:0]                                 ld_da_data_aft_rev3;
logic [127:0]                                 rb_entry_data1;
logic [127:0]                                 rb_entry_data2;
logic [127:0]                                 rb_entry_data3;
logic                                         rb_entry_us_cnt;
logic                                         rb_entry_biu_bypass_vld;
logic [127:0]                                 rb_entry_biu_data_update1;
logic [127:0]                                 rb_entry_biu_data_update2;
logic [127:0]                                 rb_entry_biu_data_update3;
logic                                         rb_entry_sync_fence;
logic                                         rb_entry_not_sync_fence;
// commit set singla                        
logic [7:0]                                   rb_entry_cmit_hit;
logic [127:0]                                 biu_lsu_r_data_mask_128;

//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
logic                                         rb_entry_data_check;
logic [16 :0]                                 rb_entry_halt_info;
logic [127:0]                                 biu_lsu_r_data0;
logic [127:0]                                 biu_lsu_r_data1;
logic [127:0]                                 biu_lsu_r_data2;
logic [127:0]                                 biu_lsu_r_data3;
//==========================================================
//                  Risc-V Debug zdb End 
//==========================================================

assign biu_lsu_r_data_mask_128 = rb_entry_addr[4]
                                  ? biu_lsu_r_data_mask[255:128]
                                  : biu_lsu_r_data_mask[127:0];
always @*
begin 
  casez({rb_entry_inst_us, rb_entry_addr[4], rb_entry_us_cnt, rb_entry_addr[5]})
  {1'b0, 1'b0, 1'b?, 1'b?}: biu_lsu_r_data0 = biu_lsu_r_data_mask[127:0];
  {1'b0, 1'b1, 1'b?, 1'b?}: biu_lsu_r_data0 = biu_lsu_r_data_mask[255:128];
  {1'b1, 1'b?, 1'b0, 1'b0}: biu_lsu_r_data0 = biu_lsu_r_data_mask[127:0];  // us_cnt == addr_5
  {1'b1, 1'b?, 1'b1, 1'b1}: biu_lsu_r_data0 = biu_lsu_r_data_mask[127:0];  // us_cnt == addr_5
  default:                  biu_lsu_r_data0 = {128{1'bx}};
  endcase
end
assign biu_lsu_r_data1 = rb_entry_inst_us && (rb_entry_us_cnt == rb_entry_addr[5])
                         ? biu_lsu_r_data_mask[255:128]
                         : {128{1'bx}};
assign biu_lsu_r_data2 = rb_entry_inst_us && !(rb_entry_us_cnt == rb_entry_addr[5])
                         ? biu_lsu_r_data_mask[127:0]
                         : {128{1'bx}};
assign biu_lsu_r_data3 = rb_entry_inst_us && !(rb_entry_us_cnt == rb_entry_addr[5])
                         ? biu_lsu_r_data_mask[255:128]
                         : {128{1'bx}};

//==========================================================
//                 Instance of Gated Cell  
//==========================================================
//-----------entry gateclk--------------
//normal gateclk ,open when create || entry_vld
assign rb_entry_clk_en = rb_entry_vld
                         || rb_entry_ld0_create_gateclk_en_x
                        //  || rb_entry_ld1_create_gateclk_en_x
                         || rb_entry_ls0_create_gateclk_en_x
                         || rb_entry_ls1_create_gateclk_en_x;

gated_clk_cell  x_lsu_rb_entry_gated_clk (
  .clk_in             (lsu_special_clk   ),
  .clk_out            (rb_entry_clk      ),
  .external_en        (1'b0              ),
  .local_en           (rb_entry_clk_en   ),
  .module_en          (cp0_lsu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

assign rb_entry_create_up_clk_en  = rb_entry_ld0_create_gateclk_en_x
                                    // || rb_entry_ld1_create_gateclk_en_x
                                    || rb_entry_ls0_create_gateclk_en_x
                                    || rb_entry_ls1_create_gateclk_en_x
                                    || rb_entry_ld0_merge_gateclk_en
                                    // || rb_entry_ld1_merge_gateclk_en
                                    || rb_entry_ls0_merge_gateclk_en
                                    || rb_entry_ls1_merge_gateclk_en
//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
                                    || ld0_data_halt_info_update_vld_x
                                    || ls0_data_halt_info_update_vld_x
                                    || ls1_data_halt_info_update_vld_x;
//==========================================================
//                  Risc-V Debug zdb End 
//==========================================================

gated_clk_cell  x_lsu_rb_entry_create_up_gated_clk (
  .clk_in                    (lsu_special_clk          ),
  .clk_out                   (rb_entry_create_up_clk   ),
  .external_en               (1'b0                     ),
  .local_en                  (rb_entry_create_up_clk_en),
  .module_en                 (cp0_lsu_icg_en           ),
  .pad_yy_icg_scan_en        (pad_yy_icg_scan_en       )
);


assign rb_entry_data_clk_en   = rb_entry_ld0_create_gateclk_en_x
                                // || rb_entry_ld1_create_gateclk_en_x
                                || (rb_entry_ls0_create_gateclk_en_x && lsda0_ex3_is_load)
                                || (rb_entry_ls1_create_gateclk_en_x && lsda1_ex3_is_load)
                                || rb_entry_ld0_merge_gateclk_en
                                // || rb_entry_ld1_merge_gateclk_en
                                || rb_entry_ls0_merge_gateclk_en
                                || rb_entry_ls1_merge_gateclk_en
                                || rb_entry_ld_wait_data_ff
                                || rb_entry_data_bypass_vld;
// &Instance("gated_clk_cell", "x_lsu_rb_entry_data_gated_clk"); @82
gated_clk_cell  x_lsu_rb_entry_data_gated_clk (
  .clk_in               (lsu_special_clk     ),
  .clk_out              (rb_entry_data_clk   ),
  .external_en          (1'b0                ),
  .local_en             (rb_entry_data_clk_en),
  .module_en            (cp0_lsu_icg_en      ),
  .pad_yy_icg_scan_en   (pad_yy_icg_scan_en  )
);

assign rb_entry_biu_id_clk_en   = rb_entry_biu_id_gateclk_en_x 
                                  || (rb_entry_ls0_create_gateclk_en_x && !lsda0_ex3_is_load)
                                  || (rb_entry_ls1_create_gateclk_en_x && !lsda1_ex3_is_load);
// &Instance("gated_clk_cell", "x_lsu_rb_entry_biu_id_gated_clk"); @91
gated_clk_cell  x_lsu_rb_entry_biu_id_gated_clk (
  .clk_in                 (lsu_special_clk       ),
  .clk_out                (rb_entry_biu_id_clk   ),
  .external_en            (1'b0                  ),
  .local_en               (rb_entry_biu_id_clk_en),
  .module_en              (cp0_lsu_icg_en        ),
  .pad_yy_icg_scan_en     (pad_yy_icg_scan_en    )
);

//==========================================================
//                 Register
//==========================================================
//+-------+
//| state |
//+-------+

always @(posedge rb_entry_clk, negedge cpurst_b)
begin
  if (!cpurst_b)
    rb_entry_state[3:0]         <=  IDLE;
  else
    rb_entry_state[3:0]         <=  rb_entry_next_state[3:0];
end
assign rb_entry_vld             = rb_entry_state[3];
assign rb_entry_biu_req_success = rb_entry_state[2];

//+------+
//| cmit |
//+------+
always @(posedge rb_entry_clk, negedge cpurst_b)
begin
  if (!cpurst_b)
    rb_entry_cmit             <=  1'b0;
  else if(rb_entry_ld0_create_dp_vld_x)
    rb_entry_cmit             <=  lda0_rb_ex3_cmit;
//   else if(rb_entry_ld1_create_dp_vld_x)
//     rb_entry_cmit             <=  lda1_rb_ex3_cmit;
  else if(rb_entry_ls0_create_dp_vld_x)
    rb_entry_cmit             <=  lsda0_rb_ex3_cmit;
  else if(rb_entry_ls1_create_dp_vld_x)
    rb_entry_cmit             <=  lsda1_rb_ex3_cmit;
  else if(rb_entry_cmit_set)
    rb_entry_cmit             <=  1'b1;
end



//+-------------------------+
//| instruction information |
//+-------------------------+
always @(posedge rb_entry_create_up_clk, negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    rb_entry_mcic_req         <=  1'b0;
    rb_entry_addr[`WK_PA_WIDTH-1:0]  <=  {`WK_PA_WIDTH{1'b0}};
    rb_entry_vaddr[`WK_VA_WIDTH-1:12]<=  {`WK_VA_WIDTH-12{1'b0}};
    rb_entry_bytes_vld[15:0]  <=  16'b0;
    rb_entry_iid              <=  '0;
    rb_entry_fence_mode[3:0]  <=  4'b0;
    rb_entry_sign_extend      <=  1'b0;
    rb_entry_boundary         <=  1'b0;
    rb_entry_preg             <=  '0;
    rb_entry_page_ca          <=  1'b0;
    rb_entry_page_so          <=  1'b0;
    rb_entry_page_sec         <=  1'b0;
    rb_entry_page_buf         <=  1'b0;
    rb_entry_page_share       <=  1'b0;
    rb_entry_sync             <=  1'b0;
    rb_entry_fence            <=  1'b0;
    rb_entry_atomic           <=  1'b0;
    rb_entry_ldamo            <=  1'b0;
    rb_entry_dcache_hit       <=  1'b0;
    rb_entry_st               <=  1'b0;
    rb_entry_inst_size[2:0]   <=  3'b0;
    rb_entry_create_lfb       <=  1'b0;
    rb_entry_vreg             <=  '0;
    rb_entry_inst_vfls        <=  1'b0;
    rb_entry_vreg_sign_sel    <=  1'b0;
    rb_entry_priv_mode[1:0]   <=  2'b0;
  end
  else if(rb_entry_ld0_merge_dp_vld)
  begin
    rb_entry_mcic_req         <=  1'b0;
    rb_entry_addr[`WK_PA_WIDTH-1:0]  <=  lda0_ex3_addr[`WK_PA_WIDTH-1:0];
    rb_entry_vaddr[`WK_VA_WIDTH-1:12]<=  lda0_ex3_vaddr[`WK_VA_WIDTH-1:12];
    rb_entry_bytes_vld[15:0]  <=  lda0_ex3_bytes_vld[15:0];
    rb_entry_iid              <=  lda0_ex3_iid     ;
    rb_entry_fence_mode[3:0]  <=  4'b0;
    rb_entry_sign_extend      <=  lda0_ex3_sign_extend;
    rb_entry_boundary         <=  lda0_ex3_boundary_after_mask;
    rb_entry_preg             <=  lda0_ex3_preg     ;
    rb_entry_page_ca          <=  lda0_ex3_page_ca;
    rb_entry_page_so          <=  lda0_ex3_page_so;
    rb_entry_page_sec         <=  lda0_ex3_page_sec;
    rb_entry_page_buf         <=  lda0_ex3_page_buf;
    rb_entry_page_share       <=  lda0_ex3_page_share;
    rb_entry_sync             <=  1'b0;
    rb_entry_fence            <=  1'b0;
    rb_entry_atomic           <=  1'b0;
    rb_entry_ldamo            <=  1'b0;
    rb_entry_dcache_hit       <=  lda0_ex3_dcache_hit;
    rb_entry_st               <=  1'b0;
    rb_entry_inst_size[2:0]   <=  lda0_ex3_inst_size[2:0];
    rb_entry_create_lfb       <=  lda0_rb_ex3_create_lfb;
    rb_entry_vreg             <=  lda0_ex3_vreg     ;
    rb_entry_inst_vfls        <=  lda0_ex3_inst_vfls;
    rb_entry_vreg_sign_sel    <=  lda0_ex3_vreg_sign_sel;
    rb_entry_priv_mode[1:0]   <=  cp0_yy_priv_mode[1:0];
  end
//   else if(rb_entry_ld1_merge_dp_vld)
//   begin
//     rb_entry_mcic_req         <=  1'b0;
//     rb_entry_addr[`WK_PA_WIDTH-1:0]  <=  lda1_ex3_addr[`WK_PA_WIDTH-1:0];
//     rb_entry_bytes_vld[15:0]  <=  lda1_ex3_bytes_vld[15:0];
//     rb_entry_iid              <=  lda1_ex3_iid     ;
//     rb_entry_fence_mode[3:0]  <=  4'b0;
//     rb_entry_sign_extend      <=  lda1_ex3_sign_extend;
//     rb_entry_boundary         <=  lda1_ex3_boundary_after_mask;
//     rb_entry_preg             <=  lda1_ex3_preg     ;
//     rb_entry_page_ca          <=  lda1_ex3_page_ca;
//     rb_entry_page_so          <=  lda1_ex3_page_so;
//     rb_entry_page_sec         <=  lda1_ex3_page_sec;
//     rb_entry_page_buf         <=  lda1_ex3_page_buf;
//     rb_entry_page_share       <=  lda1_ex3_page_share;
//     rb_entry_sync             <=  1'b0;
//     rb_entry_fence            <=  1'b0;
//     rb_entry_atomic           <=  1'b0;
//     rb_entry_ldamo            <=  1'b0;
//     rb_entry_dcache_hit       <=  lda1_ex3_dcache_hit;
//     rb_entry_st               <=  1'b0;
//     rb_entry_inst_size[2:0]   <=  lda1_ex3_inst_size[2:0];
//     rb_entry_create_lfb       <=  lda1_rb_ex3_create_lfb;
//     rb_entry_vreg             <=  lda1_ex3_vreg     ;
//     rb_entry_inst_vfls        <=  lda1_ex3_inst_vfls;
//     rb_entry_vreg_sign_sel    <=  lda1_ex3_vreg_sign_sel;
//     rb_entry_priv_mode[1:0]   <=  cp0_yy_priv_mode[1:0];
//   end
  else if(rb_entry_ls0_merge_dp_vld)
  begin
    rb_entry_mcic_req         <=  1'b0;
    rb_entry_addr[`WK_PA_WIDTH-1:0]  <=  lsda0_ex3_addr[`WK_PA_WIDTH-1:0];
    rb_entry_vaddr[`WK_VA_WIDTH-1:12]<=  lsda0_ex3_vaddr[`WK_VA_WIDTH-1:12];
    rb_entry_bytes_vld[15:0]  <=  lsda0_ex3_bytes_vld[15:0];
    rb_entry_iid              <=  lsda0_ex3_iid     ;
    rb_entry_fence_mode[3:0]  <=  4'b0;
    rb_entry_sign_extend      <=  lsda0_ex3_sign_extend;
    rb_entry_boundary         <=  lsda0_ex3_boundary_after_mask;
    rb_entry_preg             <=  lsda0_ex3_preg     ;
    rb_entry_page_ca          <=  lsda0_ex3_page_ca;
    rb_entry_page_so          <=  lsda0_ex3_page_so;
    rb_entry_page_sec         <=  lsda0_ex3_page_sec;
    rb_entry_page_buf         <=  lsda0_ex3_page_buf;
    rb_entry_page_share       <=  lsda0_ex3_page_share;
    rb_entry_sync             <=  1'b0;
    rb_entry_fence            <=  1'b0;
    rb_entry_atomic           <=  1'b0;
    rb_entry_ldamo            <=  1'b0;
    rb_entry_dcache_hit       <=  lsda0_ex3_dcache_hit;
    rb_entry_st               <=  1'b0;
    rb_entry_inst_size[2:0]   <=  lsda0_ex3_inst_size[2:0];
    rb_entry_create_lfb       <=  lsda0_rb_ex3_create_lfb;
    rb_entry_vreg             <=  lsda0_ex3_vreg     ;
    rb_entry_inst_vfls        <=  lsda0_ex3_inst_vfls;
    rb_entry_vreg_sign_sel    <=  lsda0_ex3_vreg_sign_sel;
    rb_entry_priv_mode[1:0]   <=  cp0_yy_priv_mode[1:0];
  end
  else if(rb_entry_ls1_merge_dp_vld)
  begin
    rb_entry_mcic_req         <=  1'b0;
    rb_entry_addr[`WK_PA_WIDTH-1:0]  <=  lsda1_ex3_addr[`WK_PA_WIDTH-1:0];
    rb_entry_vaddr[`WK_VA_WIDTH-1:12]<=  lsda1_ex3_vaddr[`WK_VA_WIDTH-1:12];
    rb_entry_bytes_vld[15:0]  <=  lsda1_ex3_bytes_vld[15:0];
    rb_entry_iid              <=  lsda1_ex3_iid     ;
    rb_entry_fence_mode[3:0]  <=  4'b0;
    rb_entry_sign_extend      <=  lsda1_ex3_sign_extend;
    rb_entry_boundary         <=  lsda1_ex3_boundary_after_mask;
    rb_entry_preg             <=  lsda1_ex3_preg     ;
    rb_entry_page_ca          <=  lsda1_ex3_page_ca;
    rb_entry_page_so          <=  lsda1_ex3_page_so;
    rb_entry_page_sec         <=  lsda1_ex3_page_sec;
    rb_entry_page_buf         <=  lsda1_ex3_page_buf;
    rb_entry_page_share       <=  lsda1_ex3_page_share;
    rb_entry_sync             <=  1'b0;
    rb_entry_fence            <=  1'b0;
    rb_entry_atomic           <=  1'b0;
    rb_entry_ldamo            <=  1'b0;
    rb_entry_dcache_hit       <=  lsda1_ex3_dcache_hit;
    rb_entry_st               <=  1'b0;
    rb_entry_inst_size[2:0]   <=  lsda1_ex3_inst_size[2:0];
    rb_entry_create_lfb       <=  lsda1_rb_ex3_create_lfb;
    rb_entry_vreg             <=  lsda1_ex3_vreg     ;
    rb_entry_inst_vfls        <=  lsda1_ex3_inst_vfls;
    rb_entry_vreg_sign_sel    <=  lsda1_ex3_vreg_sign_sel;
    rb_entry_priv_mode[1:0]   <=  cp0_yy_priv_mode[1:0];
  end  
  else if(rb_entry_ld0_create_dp_vld_x)
  begin
    rb_entry_mcic_req         <=  lda0_ex3_mcic_borrow_mmu;
    rb_entry_addr[`WK_PA_WIDTH-1:0]  <=  lda0_ex3_addr[`WK_PA_WIDTH-1:0];
    rb_entry_vaddr[`WK_VA_WIDTH-1:12]<=  lda0_ex3_vaddr[`WK_VA_WIDTH-1:12];
    rb_entry_bytes_vld[15:0]  <=  lda0_ex3_bytes_vld[15:0];
    rb_entry_iid              <=  lda0_ex3_iid     ;
    rb_entry_fence_mode[3:0]  <=  4'b0;
    rb_entry_sign_extend      <=  lda0_ex3_sign_extend;
    rb_entry_boundary         <=  lda0_ex3_boundary_after_mask;
    rb_entry_preg             <=  lda0_ex3_preg     ;
    rb_entry_page_ca          <=  lda0_ex3_page_ca;
    rb_entry_page_so          <=  lda0_ex3_page_so;
    rb_entry_page_sec         <=  lda0_ex3_page_sec;
    rb_entry_page_buf         <=  lda0_ex3_page_buf;
    rb_entry_page_share       <=  lda0_ex3_page_share;
    rb_entry_sync             <=  1'b0;
    rb_entry_fence            <=  1'b0;
    rb_entry_atomic           <=  lda0_rb_ex3_atomic;
    rb_entry_ldamo            <=  lda0_rb_ex3_ldamo;
    rb_entry_dcache_hit       <=  lda0_ex3_dcache_hit;
    rb_entry_st               <=  1'b0;
    rb_entry_inst_size[2:0]   <=  lda0_ex3_inst_size[2:0];
    rb_entry_create_lfb       <=  lda0_rb_ex3_create_lfb;
    rb_entry_vreg             <=  lda0_ex3_vreg     ;
    rb_entry_inst_vfls        <=  lda0_ex3_inst_vfls;
    rb_entry_vreg_sign_sel    <=  lda0_ex3_vreg_sign_sel;
    rb_entry_priv_mode[1:0]   <=  cp0_yy_priv_mode[1:0];
  end
//   else if(rb_entry_ld1_create_dp_vld_x)
//   begin
//     rb_entry_mcic_req         <=  lda1_ex3_mcic_borrow_mmu;
//     rb_entry_addr[`WK_PA_WIDTH-1:0]  <=  lda1_ex3_addr[`WK_PA_WIDTH-1:0];
//     rb_entry_bytes_vld[15:0]  <=  lda1_ex3_bytes_vld[15:0];
//     rb_entry_iid              <=  lda1_ex3_iid     ;
//     rb_entry_fence_mode[3:0]  <=  4'b0;
//     rb_entry_sign_extend      <=  lda1_ex3_sign_extend;
//     rb_entry_boundary         <=  lda1_ex3_boundary_after_mask;
//     rb_entry_preg             <=  lda1_ex3_preg     ;
//     rb_entry_page_ca          <=  lda1_ex3_page_ca;
//     rb_entry_page_so          <=  lda1_ex3_page_so;
//     rb_entry_page_sec         <=  lda1_ex3_page_sec;
//     rb_entry_page_buf         <=  lda1_ex3_page_buf;
//     rb_entry_page_share       <=  lda1_ex3_page_share;
//     rb_entry_sync             <=  1'b0;
//     rb_entry_fence            <=  1'b0;
//     rb_entry_atomic           <=  lda1_rb_ex3_atomic;
//     rb_entry_ldamo            <=  lda1_rb_ex3_ldamo;
//     rb_entry_dcache_hit       <=  lda1_ex3_dcache_hit;
//     rb_entry_st               <=  1'b0;
//     rb_entry_inst_size[2:0]   <=  lda1_ex3_inst_size[2:0];
//     rb_entry_create_lfb       <=  lda1_rb_ex3_create_lfb;
//     rb_entry_vreg             <=  lda1_ex3_vreg     ;
//     rb_entry_inst_vfls        <=  lda1_ex3_inst_vfls;
//     rb_entry_vreg_sign_sel    <=  lda1_ex3_vreg_sign_sel;
//     rb_entry_priv_mode[1:0]   <=  cp0_yy_priv_mode[1:0];
//   end
  else if(rb_entry_ls0_create_dp_vld_x && lsda0_ex3_is_load)
  begin
    rb_entry_mcic_req         <=  lsda0_ex3_mcic_borrow_mmu;
    rb_entry_addr[`WK_PA_WIDTH-1:0]  <=  lsda0_ex3_addr[`WK_PA_WIDTH-1:0];
    rb_entry_vaddr[`WK_VA_WIDTH-1:12] <= lsda0_ex3_vaddr[`WK_VA_WIDTH-1:12];
    rb_entry_bytes_vld[15:0]  <=  lsda0_ex3_bytes_vld[15:0];
    rb_entry_iid              <=  lsda0_ex3_iid     ;
    rb_entry_fence_mode[3:0]  <=  4'b0;
    rb_entry_sign_extend      <=  lsda0_ex3_sign_extend;
    rb_entry_boundary         <=  lsda0_ex3_boundary_after_mask;
    rb_entry_preg             <=  lsda0_ex3_preg     ;
    rb_entry_page_ca          <=  lsda0_ex3_page_ca;
    rb_entry_page_so          <=  lsda0_ex3_page_so;
    rb_entry_page_sec         <=  lsda0_ex3_page_sec;
    rb_entry_page_buf         <=  lsda0_ex3_page_buf;
    rb_entry_page_share       <=  lsda0_ex3_page_share;
    rb_entry_sync             <=  1'b0;
    rb_entry_fence            <=  1'b0;
    rb_entry_atomic           <=  lsda0_rb_ex3_atomic;
    rb_entry_ldamo            <=  lsda0_rb_ex3_ldamo;
    rb_entry_dcache_hit       <=  lsda0_ex3_dcache_hit;
    rb_entry_st               <=  1'b0;
    rb_entry_inst_size[2:0]   <=  lsda0_ex3_inst_size[2:0];
    rb_entry_create_lfb       <=  lsda0_rb_ex3_create_lfb;
    rb_entry_vreg             <=  lsda0_ex3_vreg     ;
    rb_entry_inst_vfls        <=  lsda0_ex3_inst_vfls;
    rb_entry_vreg_sign_sel    <=  lsda0_ex3_vreg_sign_sel;
    rb_entry_priv_mode[1:0]   <=  cp0_yy_priv_mode[1:0];
  end
  else if(rb_entry_ls1_create_dp_vld_x && lsda1_ex3_is_load)
  begin
    rb_entry_mcic_req         <=  lsda1_ex3_mcic_borrow_mmu;
    rb_entry_addr[`WK_PA_WIDTH-1:0]  <=  lsda1_ex3_addr[`WK_PA_WIDTH-1:0];
    rb_entry_vaddr[`WK_VA_WIDTH-1:12]<=  lsda1_ex3_vaddr[`WK_VA_WIDTH-1:12];
    rb_entry_bytes_vld[15:0]  <=  lsda1_ex3_bytes_vld[15:0];
    rb_entry_iid              <=  lsda1_ex3_iid     ;
    rb_entry_fence_mode[3:0]  <=  4'b0;
    rb_entry_sign_extend      <=  lsda1_ex3_sign_extend;
    rb_entry_boundary         <=  lsda1_ex3_boundary_after_mask;
    rb_entry_preg             <=  lsda1_ex3_preg     ;
    rb_entry_page_ca          <=  lsda1_ex3_page_ca;
    rb_entry_page_so          <=  lsda1_ex3_page_so;
    rb_entry_page_sec         <=  lsda1_ex3_page_sec;
    rb_entry_page_buf         <=  lsda1_ex3_page_buf;
    rb_entry_page_share       <=  lsda1_ex3_page_share;
    rb_entry_sync             <=  1'b0;
    rb_entry_fence            <=  1'b0;
    rb_entry_atomic           <=  lsda1_rb_ex3_atomic;
    rb_entry_ldamo            <=  lsda1_rb_ex3_ldamo;
    rb_entry_dcache_hit       <=  lsda1_ex3_dcache_hit;
    rb_entry_st               <=  1'b0;
    rb_entry_inst_size[2:0]   <=  lsda1_ex3_inst_size[2:0];
    rb_entry_create_lfb       <=  lsda1_rb_ex3_create_lfb;
    rb_entry_vreg             <=  lsda1_ex3_vreg     ;
    rb_entry_inst_vfls        <=  lsda1_ex3_inst_vfls;
    rb_entry_vreg_sign_sel    <=  lsda1_ex3_vreg_sign_sel;
    rb_entry_priv_mode[1:0]   <=  cp0_yy_priv_mode[1:0];
  end
  else if(rb_entry_ls0_create_dp_vld_x)
  begin
    rb_entry_mcic_req         <=  1'b0;
    rb_entry_addr[`WK_PA_WIDTH-1:0]  <=  lsda0_ex3_addr[`WK_PA_WIDTH-1:0];
    rb_entry_vaddr[`WK_VA_WIDTH-1:12]<=  lsda0_ex3_vaddr[`WK_VA_WIDTH-1:12];
    rb_entry_bytes_vld[15:0]  <=  16'b0;
    rb_entry_iid              <=  lsda0_ex3_iid     ;
    rb_entry_fence_mode[3:0]  <=  lsda0_ex3_fence_mode[3:0];
    rb_entry_sign_extend      <=  1'b0;
    rb_entry_boundary         <=  1'b0;
    rb_entry_preg             <=  '0;
    rb_entry_page_ca          <=  lsda0_ex3_page_ca;
    rb_entry_page_so          <=  lsda0_ex3_page_so;
    rb_entry_page_sec         <=  lsda0_ex3_page_sec;
    rb_entry_page_buf         <=  lsda0_ex3_page_buf;
    rb_entry_page_share       <=  lsda0_ex3_page_share;
    rb_entry_sync             <=  lsda0_ex3_sync_inst;
    rb_entry_fence            <=  lsda0_ex3_fence_inst;
    rb_entry_atomic           <=  1'b0;
    rb_entry_ldamo            <=  1'b0;
    rb_entry_dcache_hit       <=  lsda0_ex3_dcache_hit;
    rb_entry_st               <=  1'b1;
    rb_entry_inst_size[2:0]   <=  lsda0_ex3_inst_size[2:0];
    rb_entry_create_lfb       <=  lsda0_rb_ex3_create_lfb;
    rb_entry_vreg             <=  '0;
    rb_entry_inst_vfls        <=  1'b0;
    rb_entry_vreg_sign_sel    <=  1'b0;
    rb_entry_priv_mode[1:0]   <=  cp0_yy_priv_mode[1:0];
  end
  else if(rb_entry_ls1_create_dp_vld_x)
  begin
    rb_entry_mcic_req         <=  1'b0;
    rb_entry_addr[`WK_PA_WIDTH-1:0]  <=  lsda1_ex3_addr[`WK_PA_WIDTH-1:0];
    rb_entry_vaddr[`WK_VA_WIDTH-1:12]<=  lsda1_ex3_vaddr[`WK_VA_WIDTH-1:12];
    rb_entry_bytes_vld[15:0]  <=  16'b0;
    rb_entry_iid              <=  lsda1_ex3_iid     ;
    rb_entry_fence_mode[3:0]  <=  lsda1_ex3_fence_mode[3:0];
    rb_entry_sign_extend      <=  1'b0;
    rb_entry_boundary         <=  1'b0;
    rb_entry_preg             <=  '0;
    rb_entry_page_ca          <=  lsda1_ex3_page_ca;
    rb_entry_page_so          <=  lsda1_ex3_page_so;
    rb_entry_page_sec         <=  lsda1_ex3_page_sec;
    rb_entry_page_buf         <=  lsda1_ex3_page_buf;
    rb_entry_page_share       <=  lsda1_ex3_page_share;
    rb_entry_sync             <=  lsda1_ex3_sync_inst;
    rb_entry_fence            <=  lsda1_ex3_fence_inst;
    rb_entry_atomic           <=  1'b0;
    rb_entry_ldamo            <=  1'b0;
    rb_entry_dcache_hit       <=  lsda1_ex3_dcache_hit;
    rb_entry_st               <=  1'b1;
    rb_entry_inst_size[2:0]   <=  lsda1_ex3_inst_size[2:0];
    rb_entry_create_lfb       <=  lsda1_rb_ex3_create_lfb;
    rb_entry_vreg             <=  '0;
    rb_entry_inst_vfls        <=  1'b0;
    rb_entry_vreg_sign_sel    <=  1'b0;
    rb_entry_priv_mode[1:0]   <=  cp0_yy_priv_mode[1:0];
  end
end

always @(posedge rb_entry_create_up_clk, negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    rb_entry_reg_bytes_vld[15:0]       <=  16'b0;
    rb_entry_inst_us                   <= 1'b0;
    //rb_entry_vsew[1:0]                 <=  2'b0;//rvv1.0@hcl
    rb_entry_vmew[1:0]                 <=  2'b0;//rvv1.0@hcl
    rb_entry_vmop[1:0]                 <=  2'b0;//rvv1.0@hcl
    // rb_entry_vlmul[1:0]                <=  2'b0;
    rb_entry_vlmul[2:0]                <=  3'b0;    
    rb_entry_element_size[1:0]         <=  2'b0;
    rb_entry_element_cnt[8:0]          <=  9'b0;
    rb_entry_setvl_val[8:0]            <=  9'b0;
    rb_entry_vmb_id[VMBENTRY-1:0]      <=  {VMBENTRY{1'b0}};
    rb_entry_inst_vls                  <=  1'b0;
    rb_entry_inst_fof                  <=  1'b0;
    rb_entry_vmb_merge_vld             <=  1'b0;
    rb_entry_split                     <=  1'b0;
  end
  else if(rb_entry_ld0_create_dp_vld_x)
  begin
    rb_entry_reg_bytes_vld[15:0]       <=  lda0_ex3_reg_bytes_vld[15:0];
    rb_entry_inst_us                    <=  lda0_ex3_inst_us;
   // rb_entry_vsew[1:0]                 <=  lda0_ex3_vsew[1:0];//rvv1.0@hcl
    rb_entry_vmew[1:0]                 <=  lda0_ex3_vmew[1:0];
    rb_entry_vmop[1:0]                 <=  lda0_ex3_vmop[1:0];
    // rb_entry_vlmul[1:0]                <=  lda0_ex3_vlmul[1:0];
    rb_entry_vlmul[2:0]                <=  lda0_ex3_vlmul[2:0];    
    rb_entry_element_size[1:0]         <=  lda0_ex3_element_size[1:0];
    rb_entry_element_cnt[8:0]          <=  lda0_ex3_element_cnt[8:0];
    rb_entry_setvl_val[8:0]            <=  lda0_ex3_setvl_val[8:0];
    rb_entry_vmb_id[VMBENTRY-1:0]      <=  lda0_ex3_vmb_id[VMBENTRY-1:0];
    rb_entry_inst_vls                  <=  lda0_ex3_inst_vls;
    rb_entry_inst_fof                  <=  lda0_ex3_inst_fof;
    rb_entry_vmb_merge_vld             <=  lda0_ex3_vmb_merge_vld;
    rb_entry_split                     <=  lda0_ex3_split;
  end
//   else if(rb_entry_ld1_create_dp_vld_x)
//   begin
//     rb_entry_reg_bytes_vld[15:0]       <=  lda1_ex3_reg_bytes_vld[15:0];
//     rb_entry_vsew[1:0]                 <=  lda1_ex3_vsew[1:0];
//     rb_entry_vlmul[1:0]                <=  lda1_ex3_vlmul[1:0];
//     rb_entry_element_size[1:0]         <=  lda1_ex3_element_size[1:0];
//     rb_entry_element_cnt[6:0]          <=  lda1_ex3_element_cnt[6:0];
//     rb_entry_setvl_val[6:0]            <=  lda1_ex3_setvl_val[6:0];
//     rb_entry_vmb_id[VMBENTRY-1:0]      <=  lda1_ex3_vmb_id[VMBENTRY-1:0];
//     rb_entry_inst_vls                  <=  lda1_ex3_inst_vls;
//     rb_entry_inst_fof                  <=  lda1_ex3_inst_fof;
//     rb_entry_vmb_merge_vld             <=  lda1_ex3_vmb_merge_vld;
//     rb_entry_split                     <=  lda1_ex3_split;
//   end
  else if(rb_entry_ls0_create_dp_vld_x && lsda0_ex3_is_load)
  begin
    rb_entry_reg_bytes_vld[15:0]       <=  lsda0_ex3_reg_bytes_vld[15:0];
    rb_entry_inst_us                    <=  lsda0_ex3_inst_us;
    //rb_entry_vsew[1:0]                 <=  lsda0_ex3_vsew[1:0];//rvv1.0@hcl
    rb_entry_vmew[1:0]                 <=  lsda0_ex3_vmew[1:0]; //rvv1.0@hcl
    rb_entry_vmop[1:0]                 <=  lsda0_ex3_vmop[1:0]; //rvv1.0@hcl
    // rb_entry_vlmul[1:0]                <=  lsda0_ex3_vlmul[1:0];
    rb_entry_vlmul[2:0]                <=  lsda0_ex3_vlmul[2:0];    
    rb_entry_element_size[1:0]         <=  lsda0_ex3_element_size[1:0];
    rb_entry_element_cnt[8:0]          <=  lsda0_ex3_element_cnt[8:0];
    rb_entry_setvl_val[8:0]            <=  lsda0_ex3_setvl_val[8:0];
    rb_entry_vmb_id[VMBENTRY-1:0]      <=  lsda0_ex3_vmb_id[VMBENTRY-1:0];
    rb_entry_inst_vls                  <=  lsda0_ex3_inst_vls;
    rb_entry_inst_fof                  <=  lsda0_ex3_inst_fof;
    rb_entry_vmb_merge_vld             <=  lsda0_ex3_vmb_merge_vld;
    rb_entry_split                     <=  lsda0_ex3_split;
  end
  else if(rb_entry_ls1_create_dp_vld_x && lsda1_ex3_is_load)
  begin
    rb_entry_reg_bytes_vld[15:0]       <=  lsda1_ex3_reg_bytes_vld[15:0];
    rb_entry_inst_us                    <= lsda1_ex3_inst_us;
    //rb_entry_vsew[1:0]                 <=  lsda1_ex3_vsew[1:0]; //rvv1.0@hcl
    rb_entry_vmew[1:0]                 <=  lsda1_ex3_vmew[1:0];//rvv1.0@hcl
    rb_entry_vmop[1:0]                 <=  lsda1_ex3_vmop[1:0];//rvv1.0@hcl
    // rb_entry_vlmul[1:0]                <=  lsda1_ex3_vlmul[1:0];
    rb_entry_vlmul[2:0]                <=  lsda1_ex3_vlmul[2:0];    
    rb_entry_element_size[1:0]         <=  lsda1_ex3_element_size[1:0];
    rb_entry_element_cnt[8:0]          <=  lsda1_ex3_element_cnt[8:0];
    rb_entry_setvl_val[8:0]            <=  lsda1_ex3_setvl_val[8:0];
    rb_entry_vmb_id[VMBENTRY-1:0]      <=  lsda1_ex3_vmb_id[VMBENTRY-1:0];
    rb_entry_inst_vls                  <=  lsda1_ex3_inst_vls;
    rb_entry_inst_fof                  <=  lsda1_ex3_inst_fof;
    rb_entry_vmb_merge_vld             <=  lsda1_ex3_vmb_merge_vld;
    rb_entry_split                     <=  lsda1_ex3_split;
  end
  else if(rb_entry_ls0_create_dp_vld_x | rb_entry_ls1_create_dp_vld_x)
    rb_entry_inst_us                   <= 1'b0;
end

always @(posedge rb_entry_create_up_clk, negedge cpurst_b)begin 
  if(!cpurst_b)begin 
    rb_entry_bytes_vld1 <= 16'b0;
    rb_entry_bytes_vld2 <= 16'b0;
    rb_entry_bytes_vld3 <= 16'b0;
  end
  else if(rb_entry_ld0_merge_dp_vld | rb_entry_ld0_create_dp_vld_x & lda0_ex3_inst_us)begin 
    rb_entry_bytes_vld1     <= lda0_ex3_bytes_vld1;
    rb_entry_bytes_vld2     <= lda0_ex3_bytes_vld2;
    rb_entry_bytes_vld3     <= lda0_ex3_bytes_vld3;
  end
  else if(rb_entry_ls0_merge_dp_vld 
         | rb_entry_ls0_create_dp_vld_x 
           & lsda0_ex3_is_load 
           & lsda0_ex3_inst_us)begin 
    rb_entry_bytes_vld1     <= lsda0_ex3_bytes_vld1;
    rb_entry_bytes_vld2     <= lsda0_ex3_bytes_vld2;
    rb_entry_bytes_vld3     <= lsda0_ex3_bytes_vld3;
  end
  else if(rb_entry_ls1_merge_dp_vld 
          | rb_entry_ls1_create_dp_vld_x 
            & lsda1_ex3_is_load 
            & lsda1_ex3_inst_us)begin 
    rb_entry_bytes_vld1     <= lsda1_ex3_bytes_vld1;
    rb_entry_bytes_vld2     <= lsda1_ex3_bytes_vld2;
    rb_entry_bytes_vld3     <= lsda1_ex3_bytes_vld3;
  end
end

always @(posedge rb_entry_create_up_clk or negedge cpurst_b)begin 
  if(!cpurst_b)begin 
    rb_entry_reg_bytes_vld1 <= 16'b0;
    rb_entry_reg_bytes_vld2 <= 16'b0;
    rb_entry_reg_bytes_vld3 <= 16'b0;
  end
  else if(rb_entry_ld0_create_dp_vld_x & lda0_ex3_inst_us)begin 
    rb_entry_reg_bytes_vld1 <= lda0_ex3_reg_bytes_vld1;
    rb_entry_reg_bytes_vld2 <= lda0_ex3_reg_bytes_vld2;
    rb_entry_reg_bytes_vld3 <= lda0_ex3_reg_bytes_vld3;
  end
  else if(rb_entry_ls0_create_dp_vld_x & lsda0_ex3_is_load & lsda0_ex3_inst_us)begin 
    rb_entry_reg_bytes_vld1 <= lsda0_ex3_reg_bytes_vld1;
    rb_entry_reg_bytes_vld2 <= lsda0_ex3_reg_bytes_vld2;
    rb_entry_reg_bytes_vld3 <= lsda0_ex3_reg_bytes_vld3;
  end
  else if(rb_entry_ls1_create_dp_vld_x & lsda1_ex3_is_load & lsda1_ex3_inst_us)begin 
    rb_entry_reg_bytes_vld1 <= lsda1_ex3_reg_bytes_vld1;
    rb_entry_reg_bytes_vld2 <= lsda1_ex3_reg_bytes_vld2;
    rb_entry_reg_bytes_vld3 <= lsda1_ex3_reg_bytes_vld3;
  end
end

always @(posedge rb_entry_clk or negedge cpurst_b)begin 
  if(!cpurst_b)
    rb_entry_us_cnt <= 1'b0;
  else if(rb_entry_ld0_create_dp_vld_x
         | rb_entry_ld0_merge_dp_vld
         | rb_entry_ls0_create_dp_vld_x & lsda0_ex3_is_load
         | rb_entry_ls0_merge_dp_vld
         | rb_entry_ls1_create_dp_vld_x & lsda1_ex3_is_load
         | rb_entry_ls1_merge_dp_vld)
    rb_entry_us_cnt <= 1'b0;
  else if(rb_entry_inst_us & rb_entry_r_id_hit & lsu_biu_r_linefill_ready & (rb_entry_state == WAIT_RESP))
    rb_entry_us_cnt <= 1'b1;
end
//expt for fof,only first element trigger expt
always @(posedge rb_entry_clk, negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    rb_entry_expt_vld    <=  1'b0;
    rb_entry_secd_expt   <=  1'b0;
  end
  else if(rb_entry_ld0_create_dp_vld_x)
  begin
    rb_entry_expt_vld    <=  lda0_rb_ex3_expt_vld;
    rb_entry_secd_expt   <=  1'b0;
  end
//   else if(rb_entry_ld1_create_dp_vld_x)
//   begin
//     rb_entry_expt_vld    <=  lda1_rb_ex3_expt_vld;
//     rb_entry_secd_expt   <=  1'b0;
//   end
  else if(rb_entry_ls0_create_dp_vld_x && lsda0_ex3_is_load)
  begin
    rb_entry_expt_vld    <=  lsda0_rb_ex3_expt_vld;
    rb_entry_secd_expt   <=  1'b0;
  end
  else if(rb_entry_ls1_create_dp_vld_x && lsda1_ex3_is_load)
  begin
    rb_entry_expt_vld    <=  lsda1_rb_ex3_expt_vld;
    rb_entry_secd_expt   <=  1'b0;
  end
  else if(rb_entry_ld0_merge_vld)
  begin
    rb_entry_expt_vld    <=  rb_entry_expt_vld || lda0_rb_ex3_expt_vld;
    rb_entry_secd_expt   <=  lda0_rb_ex3_expt_vld;
  end
//   else if(rb_entry_ld1_merge_vld)
//   begin
//     rb_entry_expt_vld    <=  rb_entry_expt_vld || lda1_rb_ex3_expt_vld;
//     rb_entry_secd_expt   <=  lda1_rb_ex3_expt_vld;
//   end
  else if(rb_entry_ls0_merge_vld)
  begin
    rb_entry_expt_vld    <=  rb_entry_expt_vld || lsda0_rb_ex3_expt_vld;
    rb_entry_secd_expt   <=  lsda0_rb_ex3_expt_vld;
  end
  else if(rb_entry_ls1_merge_vld)
  begin
    rb_entry_expt_vld    <=  rb_entry_expt_vld || lsda1_rb_ex3_expt_vld;
    rb_entry_secd_expt   <=  lsda1_rb_ex3_expt_vld;
  end
  else if(rb_entry_fof_bus_err)
  begin
    rb_entry_expt_vld    <=  1'b1;
    rb_entry_secd_expt   <=  rb_entry_secd;
  end
end

always @(posedge rb_entry_data_clk, negedge cpurst_b)
begin
  if (!cpurst_b)
    rb_entry_secd_setvl_val[8:0]  <=  9'b0;
  else if(rb_entry_ld0_merge_dp_vld)
    rb_entry_secd_setvl_val[8:0]  <=  lda0_ex3_setvl_val[8:0];
//   else if(rb_entry_ld1_merge_dp_vld)
//     rb_entry_secd_setvl_val[8:0]  <=  lda1_ex3_setvl_val[8:0];
  else if(rb_entry_ls0_merge_dp_vld)
    rb_entry_secd_setvl_val[8:0]  <=  lsda0_ex3_setvl_val[8:0];
  else if(rb_entry_ls1_merge_dp_vld)
    rb_entry_secd_setvl_val[8:0]  <=  lsda1_ex3_setvl_val[8:0];
end

//setvl_val select
assign rb_entry_setvl_val_final[8:0] = rb_entry_secd_expt
                                       ? rb_entry_secd_setvl_val[8:0]
                                       : rb_entry_setvl_val[8:0];

always @(posedge rb_entry_create_up_clk, negedge cpurst_b)
begin
  if (!cpurst_b)
    rb_entry_rot_sel[15:0]    <=  16'b0;
  else if(rb_entry_ld0_merge_vld
        //   || rb_entry_ld1_merge_vld
          || rb_entry_ls0_merge_vld
          || rb_entry_ls1_merge_vld)
    rb_entry_rot_sel[15:0]    <=  {rb_entry_rot_sel[7:0],rb_entry_rot_sel[15:8]};
  else if(rb_entry_ld0_create_dp_vld_x)
    rb_entry_rot_sel[15:0]    <=  lda0_ex3_data_rot_sel[15:0];
//   else if(rb_entry_ld1_create_dp_vld_x)
//     rb_entry_rot_sel[15:0]    <=  lda1_ex3_data_rot_sel[15:0];
  else if(rb_entry_ls0_create_dp_vld_x)
    rb_entry_rot_sel[15:0]    <=  lsda0_ex3_data_rot_sel[15:0];
  else if(rb_entry_ls1_create_dp_vld_x)
    rb_entry_rot_sel[15:0]    <=  lsda1_ex3_data_rot_sel[15:0];
end


//+------+
//| secd |
//+------+
//secd must be accurate, so it use set signal
always @(posedge rb_entry_create_up_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    rb_entry_secd             <=  1'b0;
  else if(rb_entry_ld0_merge_vld
        //   || rb_entry_ld1_merge_vld
          || rb_entry_ls0_merge_vld
          || rb_entry_ls1_merge_vld)
    rb_entry_secd             <=  1'b1;
  else if(rb_entry_ld0_create_dp_vld_x
        //   || rb_entry_ld1_create_dp_vld_x
          || rb_entry_ls0_create_dp_vld_x
          || rb_entry_ls1_create_dp_vld_x)
    rb_entry_secd             <=  1'b0;
end


//+------+
//| depd |
//+------+
always @(posedge rb_entry_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    rb_entry_depd0             <=  1'b0;
  else if(rb_entry_ld0_merge_dp_vld || rb_entry_ld0_create_dp_vld_x)
    rb_entry_depd0             <=  1'b0;
  else if(rb_entry_discard_vld0)
    rb_entry_depd0             <=  1'b1;
  else if(rb_entry_wakeup_pop0)
    rb_entry_depd0             <=  1'b0;
end

always @(posedge rb_entry_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    rb_entry_depd2             <=  1'b0;
  else if(rb_entry_ls0_merge_dp_vld || rb_entry_ls0_create_dp_vld_x)
    rb_entry_depd2             <=  1'b0;
  else if(rb_entry_discard_vld2)
    rb_entry_depd2             <=  1'b1;
  else if(rb_entry_wakeup_pop2)
    rb_entry_depd2             <=  1'b0;
end

always @(posedge rb_entry_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    rb_entry_depd3             <=  1'b0;
  else if(rb_entry_ls1_merge_dp_vld || rb_entry_ls1_create_dp_vld_x)
    rb_entry_depd3             <=  1'b0;
  else if(rb_entry_discard_vld3)
    rb_entry_depd3             <=  1'b1;
  else if(rb_entry_wakeup_pop3)
    rb_entry_depd3             <=  1'b0;
end


//+---------------+
//| boundary_depd |
//+---------------+
always @(posedge rb_entry_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    rb_entry_boundary_depd0       <=  1'b0;
  else if(rb_entry_ld0_create_dp_vld_x  ||  rb_entry_boundary_wakeup0)
    rb_entry_boundary_depd0       <=  1'b0;
  else if(rb_entry_boundary_depd_set0)
    rb_entry_boundary_depd0       <=  1'b1;
end
// always @(posedge rb_entry_clk or negedge cpurst_b)
// begin
//   if (!cpurst_b)
//     rb_entry_boundary_depd1       <=  1'b0;
//   else if(rb_entry_ld1_create_dp_vld_x  ||  rb_entry_boundary_wakeup1)
//     rb_entry_boundary_depd1       <=  1'b0;
//   else if(rb_entry_boundary_depd_set1)
//     rb_entry_boundary_depd1       <=  1'b1;
// end
always @(posedge rb_entry_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    rb_entry_boundary_depd2       <=  1'b0;
  else if(rb_entry_ls0_create_dp_vld_x  ||  rb_entry_boundary_wakeup2)
    rb_entry_boundary_depd2       <=  1'b0;
  else if(rb_entry_boundary_depd_set2)
    rb_entry_boundary_depd2       <=  1'b1;
end
always @(posedge rb_entry_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    rb_entry_boundary_depd3       <=  1'b0;
  else if(rb_entry_ls1_create_dp_vld_x  ||  rb_entry_boundary_wakeup3)
    rb_entry_boundary_depd3       <=  1'b0;
  else if(rb_entry_boundary_depd_set3)
    rb_entry_boundary_depd3       <=  1'b1;
end



//+----------+
//| dest_vld |
//+----------+
always @(posedge rb_entry_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    rb_entry_dest_vld         <=  1'b0;
  else if(rb_entry_ld0_create_dp_vld_x)
    rb_entry_dest_vld         <=  lda0_rb_ex3_dest_vld;
//   else if(rb_entry_ld1_create_dp_vld_x)
//     rb_entry_dest_vld         <=  lda1_rb_ex3_dest_vld;
  else if(rb_entry_ls0_create_dp_vld_x && lsda0_ex3_is_load)
    rb_entry_dest_vld         <=  lsda0_rb_ex3_dest_vld;
  else if(rb_entry_ls1_create_dp_vld_x && lsda1_ex3_is_load)
    rb_entry_dest_vld         <=  lsda1_rb_ex3_dest_vld;
  else if(rb_entry_ld0_merge_expt_vld
        //   || rb_entry_ld1_merge_expt_vld
          || rb_entry_ls0_merge_expt_vld
          || rb_entry_ls1_merge_expt_vld
          || (rb_entry_ls0_create_dp_vld_x && !lsda0_ex3_is_load)
          || (rb_entry_ls1_create_dp_vld_x && !lsda1_ex3_is_load)
          ||  rb_entry_flush_clear)
    rb_entry_dest_vld         <=  1'b0;
end

//+------+
//| data |
//+------+
// assign rb_entry_data_merge_vld = rb_entry_ld_wait_data_ff && rb_entry_secd
//                                  || rb_entry_data_bypass_vld && rb_entry_secd;
assign rb_entry_data_merge_vld0 = rb_entry_ld_wait_data_ff && rb_entry_secd
                                 || rb_entry_data_bypass_vld 
                                    && rb_entry_secd 
                                    && (!rb_entry_inst_us || (rb_entry_addr[5]==rb_entry_us_cnt));
assign rb_entry_data_bypass_vld0 = rb_entry_data_bypass_vld
                                   && (!rb_entry_inst_us || (rb_entry_addr[5] == rb_entry_us_cnt));
always @(posedge rb_entry_data_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    rb_entry_data[127:0]       <=  128'b0;
  else if(rb_entry_data_merge_vld0)
    rb_entry_data[127:0]       <=  rb_entry_merge_data[127:0];
  else if(rb_entry_data_bypass_vld0)
    rb_entry_data[127:0]       <=  rb_entry_biu_data_update[127:0];
  else if(rb_entry_ld_wait_data_ff)
    rb_entry_data[127:0]       <=  ld_da_data_aft_rev[127:0];
end
//+------+
//| data1 |
//+------+
assign rb_entry_data_merge_vld1 = rb_entry_ld_wait_data_ff && rb_entry_secd
                                  || rb_entry_data_bypass_vld
                                     && rb_entry_secd
                                     && rb_entry_inst_us 
                                     && (rb_entry_addr[5]==rb_entry_us_cnt); // if addr5=0, the 2nd 128 is in the first beat (namely rb_entry_us_cnt=0, and vice versa)
assign rb_entry_data_bypass_vld1 = rb_entry_data_bypass_vld
                                   && rb_entry_inst_us
                                   && (rb_entry_addr[5] == rb_entry_us_cnt);

always @(posedge rb_entry_data_clk or negedge cpurst_b)begin 
  if(!cpurst_b)
    rb_entry_data1[127:0] <= 128'b0;
  else if(rb_entry_data_merge_vld1)
    rb_entry_data1[127:0] <= rb_entry_merge_data1;
  else if (rb_entry_data_bypass_vld1) // todo merge us512
    rb_entry_data1[127:0] <= rb_entry_biu_data_update1;
  else if(rb_entry_ld_wait_data_ff)
    rb_entry_data1        <= ld_da_data_aft_rev1;
end
//+------+
//| data2 |
//+------+
assign rb_entry_data_merge_vld2 = rb_entry_ld_wait_data_ff && rb_entry_secd
                                  || rb_entry_data_bypass_vld
                                     && rb_entry_secd
                                     && rb_entry_inst_us
                                     && !(rb_entry_addr[5] == rb_entry_us_cnt);// if addr5=0, the 3rd 128 is in the secnd beat (namely rb_entry_us_cnt=1, and vice versa)
assign rb_entry_data_bypass_vld2 = rb_entry_data_bypass_vld
                                   && rb_entry_inst_us
                                   && !(rb_entry_addr[5] == rb_entry_us_cnt);
always @(posedge rb_entry_data_clk or negedge cpurst_b)begin 
  if(!cpurst_b)
    rb_entry_data2[127:0] <= 128'b0;
  else if(rb_entry_data_merge_vld2)
    rb_entry_data2[127:0] <= rb_entry_merge_data2;
  else if(rb_entry_data_bypass_vld2)
    rb_entry_data2[127:0] <= rb_entry_biu_data_update2;
  else if(rb_entry_ld_wait_data_ff)
    rb_entry_data2        <= ld_da_data_aft_rev2;
end
//+------+
//| data3 |
//+------+
assign rb_entry_data_merge_vld3 = rb_entry_ld_wait_data_ff && rb_entry_secd
                                  || rb_entry_data_bypass_vld
                                     && rb_entry_secd
                                     && rb_entry_inst_us
                                     && !(rb_entry_addr[5] == rb_entry_us_cnt);// if addr5=0, the 3rd 128 is in the secnd beat (namely rb_entry_us_cnt=1, and vice versa)
assign rb_entry_data_bypass_vld3 = rb_entry_data_bypass_vld
                                   && rb_entry_inst_us
                                   && !(rb_entry_addr[5] == rb_entry_us_cnt);
always @(posedge rb_entry_data_clk or negedge cpurst_b)begin 
  if(!cpurst_b)
    rb_entry_data3[127:0] <= 128'b0;
  else if(rb_entry_data_merge_vld3)
    rb_entry_data3[127:0] <= rb_entry_merge_data3;
  else if(rb_entry_data_bypass_vld3)
    rb_entry_data3[127:0] <= rb_entry_biu_data_update3;
  else if(rb_entry_ld_wait_data_ff)
    rb_entry_data3        <= ld_da_data_aft_rev3;
end
//+------------------+
//| wb_cmplt_success |
//+------------------+
always @(posedge rb_entry_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    rb_entry_wb_cmplt_success <=  1'b0;
  else if(rb_entry_ld0_create_dp_vld_x || rb_entry_ld0_merge_dp_vld)
    rb_entry_wb_cmplt_success <=  lda0_rb_ex3_cmplt_success;
//   else if(rb_entry_ld1_create_dp_vld_x || rb_entry_ld1_merge_dp_vld)
//     rb_entry_wb_cmplt_success <=  lda1_rb_ex3_cmplt_success;
  else if((rb_entry_ls0_create_dp_vld_x && lsda0_ex3_is_load) || rb_entry_ls0_merge_dp_vld)
    rb_entry_wb_cmplt_success <=  lsda0_rb_ex3_cmplt_success;
  else if((rb_entry_ls1_create_dp_vld_x && lsda1_ex3_is_load) || rb_entry_ls1_merge_dp_vld)
    rb_entry_wb_cmplt_success <=  lsda1_rb_ex3_cmplt_success;
  else if((rb_entry_ls0_create_dp_vld_x && !lsda0_ex3_is_load) || (rb_entry_ls1_create_dp_vld_x && !lsda1_ex3_is_load))
    rb_entry_wb_cmplt_success <=  1'b1;
  else if(rb_entry_wb_cmplt_grnt_x)
    rb_entry_wb_cmplt_success <=  1'b1;
end

always @(posedge rb_entry_create_up_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    rb_entry_spec_fail_x       <=  1'b0;
  else if(rb_entry_ld0_create_dp_vld_x)
    rb_entry_spec_fail_x       <=  lda0_ex3_spec_fail;
//   else if(rb_entry_ld1_create_dp_vld_x)
//     rb_entry_spec_fail_x       <=  lda1_ex3_spec_fail;
  else if(rb_entry_ls0_create_dp_vld_x && lsda0_ex3_is_load)
    rb_entry_spec_fail_x       <=  lsda0_ex3_spec_fail;
  else if(rb_entry_ls1_create_dp_vld_x && lsda1_ex3_is_load)
    rb_entry_spec_fail_x       <=  lsda1_ex3_spec_fail;
end

//+-----------------+
//| wb_data_success |
//+-----------------+
always @(posedge rb_entry_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    rb_entry_wb_data_success  <=  1'b0;
  else if(rb_entry_ld0_create_dp_vld_x
        //   || rb_entry_ld1_create_dp_vld_x
          || (rb_entry_ls0_create_dp_vld_x && lsda0_ex3_is_load)
          || (rb_entry_ls1_create_dp_vld_x && lsda1_ex3_is_load))
    rb_entry_wb_data_success  <=  1'b0;
  else if((rb_entry_ls0_create_dp_vld_x && !lsda0_ex3_is_load)
          || (rb_entry_ls1_create_dp_vld_x && !lsda1_ex3_is_load))
    rb_entry_wb_data_success  <=  1'b1;
  else if(rb_entry_wb_data_grnt_x)
    rb_entry_wb_data_success  <=  1'b1;
  else if(rb_entry_fof_bus_err_expt)
    rb_entry_wb_data_success  <=  1'b1;
end


//+--------+
//| biu_id |
//+--------+
always @(posedge rb_entry_biu_id_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    rb_entry_biu_id[4:0]    <=  5'b0;
  else if((rb_entry_ls0_create_dp_vld_x && !lsda0_ex3_is_load)
           || (rb_entry_ls1_create_dp_vld_x && !lsda1_ex3_is_load))
    rb_entry_biu_id[4:0]    <=  5'd31;
  else if(rb_entry_read_req_grnt_x)
    rb_entry_biu_id[4:0]    <=  rb_biu_ar_id[4:0];
end


//+------------+
//| biu_r_resp |
//+------------+
always @(posedge rb_entry_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    rb_entry_biu_r_resp     <=  1'b0;
  else if(rb_entry_ld0_create_dp_vld_x
        //   || rb_entry_ld1_create_dp_vld_x
          || rb_entry_ls0_create_dp_vld_x
          || rb_entry_ls1_create_dp_vld_x)
    rb_entry_biu_r_resp     <=  1'b0;
  else if(rb_entry_biu_r_resp_set)
    rb_entry_biu_r_resp     <=  1'b1;
end


//+------------+
//| biu_b_resp |
//+------------+
always @(posedge rb_entry_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    rb_entry_biu_b_resp     <=  1'b0;
  else if(rb_entry_ld0_create_dp_vld_x
        //   || rb_entry_ld1_create_dp_vld_x
          || rb_entry_ls0_create_dp_vld_x
          || rb_entry_ls1_create_dp_vld_x)
    rb_entry_biu_b_resp     <=  1'b0;
  else if(rb_entry_biu_b_resp_set)
    rb_entry_biu_b_resp     <=  1'b1;
end


//+---------+
//| bus_err |
//+---------+
//ecc err will not carry bus err expt
always @(posedge rb_entry_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    rb_entry_bus_err        <=  1'b0;
  end
  else if(rb_entry_ld0_create_dp_vld_x
        //   || rb_entry_ld1_create_dp_vld_x
          || rb_entry_ls0_create_dp_vld_x
          || rb_entry_ls1_create_dp_vld_x)
  begin
    rb_entry_bus_err        <=  1'b0;
  end
  else if(rb_entry_bus_err_set && !rb_entry_fof_not_first)
  begin
    rb_entry_bus_err        <=  1'b1;
  end
end


//+-----------------------+
//| biu_pop_entry_success |
//+-----------------------+
//this signal represents request biu_pop_entry successfully
always @(posedge rb_entry_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    rb_entry_biu_pe_req_success   <=  1'b0;
  else if((rb_entry_ld0_create_dp_vld_x && rb_ld0_biu_pe_req_grnt
        //    || rb_entry_ld1_create_dp_vld_x
           || (rb_entry_ls0_create_dp_vld_x && lsda0_ex3_is_load && rb_ls0_biu_pe_req_grnt)
           || (rb_entry_ls1_create_dp_vld_x && lsda1_ex3_is_load && rb_ls1_biu_pe_req_grnt)))
    rb_entry_biu_pe_req_success   <=  1'b1;
  else if(rb_entry_ld0_create_vld_x
        //   || rb_entry_ld1_create_vld_x
          || rb_entry_ls0_create_vld_x
          || rb_entry_ls1_create_vld_x
          || rb_entry_ld0_merge_vld
        //   || rb_entry_ld1_merge_vld
          || rb_entry_ls0_merge_vld
          || rb_entry_ls1_merge_vld)
    rb_entry_biu_pe_req_success   <=  1'b0;
  else if(rb_entry_biu_pe_req_grnt_x)
    rb_entry_biu_pe_req_success   <=  1'b1;
end

always @(posedge rb_entry_create_up_clk or negedge cpurst_b)
begin 
    if(!cpurst_b)begin 
        rb_entry_ld0_create_vld_ff <= 1'b0;
        // rb_entry_ld1_create_vld_ff <= 1'b0;
        rb_entry_ls0_create_vld_ff <= 1'b0;
        rb_entry_ls1_create_vld_ff <= 1'b0;
        rb_entry_ld0_merge_vld_ff <= 1'b0;
        // rb_entry_ld1_merge_vld_ff <= 1'b0;
        rb_entry_ls0_merge_vld_ff <= 1'b0;
        rb_entry_ls1_merge_vld_ff <= 1'b0;
    end 
    else begin 
        rb_entry_ld0_create_vld_ff <= rb_entry_ld0_create_vld_x;
        // rb_entry_ld1_create_vld_ff <= rb_entry_ld1_create_vld_x;
        rb_entry_ls0_create_vld_ff <= rb_entry_ls0_create_vld_x && lsda0_ex3_is_load;
        rb_entry_ls1_create_vld_ff <= rb_entry_ls1_create_vld_x && lsda1_ex3_is_load;
        rb_entry_ld0_merge_vld_ff  <= rb_entry_ld0_merge_vld;
        // rb_entry_ld1_merge_vld_ff  <= rb_entry_ld1_merge_vld;
        rb_entry_ls0_merge_vld_ff  <= rb_entry_ls0_merge_vld;
        rb_entry_ls1_merge_vld_ff  <= rb_entry_ls1_merge_vld;
    end 
end 

//------------------commit set signal-----------------------
assign rb_entry_cmit_hit[0]       = {rtu_yy_xx_commit0,rtu_yy_xx_commit0_iid}
                                  ==  {1'b1,rb_entry_iid};
assign rb_entry_cmit_hit[1]       = {rtu_yy_xx_commit1,rtu_yy_xx_commit1_iid}
                                  ==  {1'b1,rb_entry_iid};
assign rb_entry_cmit_hit[2]       = {rtu_yy_xx_commit2,rtu_yy_xx_commit2_iid}
                                  ==  {1'b1,rb_entry_iid};
assign rb_entry_cmit_hit[3]       = {rtu_yy_xx_commit3,rtu_yy_xx_commit3_iid}
                                  ==  {1'b1,rb_entry_iid};
assign rb_entry_cmit_hit[4]       = {rtu_yy_xx_commit4,rtu_yy_xx_commit4_iid}
                                  ==  {1'b1,rb_entry_iid};
assign rb_entry_cmit_hit[5]       = {rtu_yy_xx_commit5,rtu_yy_xx_commit5_iid}
                                  ==  {1'b1,rb_entry_iid};
assign rb_entry_cmit_hit[6]       = {rtu_yy_xx_commit6,rtu_yy_xx_commit6_iid}
                                  ==  {1'b1,rb_entry_iid};
assign rb_entry_cmit_hit[7]       = {rtu_yy_xx_commit7,rtu_yy_xx_commit7_iid}
                                  ==  {1'b1,rb_entry_iid};

assign rb_entry_cmit_set  = (|rb_entry_cmit_hit[7:0]) &&  rb_entry_vld;

//==========================================================
//                 Generate inst type
//==========================================================
assign rb_entry_sync_fence      = rb_entry_sync ||  rb_entry_fence;
assign rb_entry_not_sync_fence  = !rb_entry_sync_fence;


always_comb begin 
    rb_entry_next_state = IDLE;
    case(rb_entry_state[3:0])
        IDLE:
            if((rb_entry_ld0_create_vld_x && lda0_rb_ex3_data_vld)
            //    ||(rb_entry_ld1_create_vld_x && lda1_rb_ex3_data_vld)
               ||(rb_entry_ls0_create_vld_x && lsda0_ex3_is_load && lsda0_rb_ex3_data_vld)
               ||(rb_entry_ls1_create_vld_x && lsda1_ex3_is_load && lsda1_rb_ex3_data_vld))
                rb_entry_next_state[3:0]  = WAIT_DATA_FF;
            else if(rb_entry_create_wait_rdy)
                rb_entry_next_state[3:0]  = WAIT_RDY;
            else if(rb_entry_ld0_create_vld_x
                    // || rb_entry_ld1_create_vld_x
                    || rb_entry_ls0_create_vld_x
                    || rb_entry_ls1_create_vld_x)
                rb_entry_next_state = REQ_BIU;
            else
                rb_entry_next_state = IDLE;
        WAIT_RDY:
            if(rb_entry_flush_clear)
                rb_entry_next_state = FLUSH_FF;
            else if(rb_entry_ready_to_biu_req)
                rb_entry_next_state = REQ_BIU;
            else
                rb_entry_next_state = WAIT_RDY;
        REQ_BIU:
            if(rb_entry_flush_clear)
                rb_entry_next_state = FLUSH_FF;
            else if(rb_entry_read_req_grnt_x)
                rb_entry_next_state  = WAIT_RESP;
            else
                rb_entry_next_state  = REQ_BIU;
        WAIT_RESP:
            if(rb_entry_wait_resp_imme_idle
               || rb_entry_sync_fence_resp_success
               || rtu_lsu_async_flush)
                rb_entry_next_state = IDLE;
            else if(rb_entry_wait_resp_to_req_merge)
                rb_entry_next_state = WAIT_MERGE;
            else if(rb_entry_biu_r_resp_set &&  rb_entry_not_sync_fence)
                rb_entry_next_state  = REQ_WB;
            else
                rb_entry_next_state  = WAIT_RESP;
        REQ_WB:
            if(!rb_entry_dest_vld ||  rb_entry_req_wb_success ||  rtu_lsu_async_flush)
                rb_entry_next_state  = IDLE;
            else
                rb_entry_next_state  = REQ_WB;
        WAIT_DATA_FF:
            if(rb_entry_secd)
                rb_entry_next_state  = REQ_WB;
            else if(rb_entry_boundary)
                rb_entry_next_state  = WAIT_MERGE;
            else
                rb_entry_next_state  = REQ_BIU;
        WAIT_MERGE:
            if(!rb_entry_dest_vld ||  rb_entry_flush_clear)
                rb_entry_next_state  = FLUSH_FF;
            else if((rb_entry_ld0_merge_vld && lda0_rb_ex3_data_vld)
                    // || (rb_entry_ld1_merge_vld && lda1_rb_ex3_data_vld)
                    || (rb_entry_ls0_merge_vld && lsda0_rb_ex3_data_vld)
                    || (rb_entry_ls1_merge_vld && lsda1_rb_ex3_data_vld))
                rb_entry_next_state  = WAIT_DATA_FF;
            else if(rb_entry_ld0_merge_vld
                    // || rb_entry_ld1_merge_vld
                    || rb_entry_ls0_merge_vld
                    || rb_entry_ls1_merge_vld)
                rb_entry_next_state  = REQ_BIU;
            else
                rb_entry_next_state  = WAIT_MERGE;
        FLUSH_FF:
            rb_entry_next_state  = IDLE;

        default: rb_entry_next_state  = IDLE;
    endcase
end 


//==========================================================
//                 State 0 : idle
//==========================================================
//create ptr0 is used for ld pipe
//create ptr1 is used for st pipe
assign rb_entry_hit_fence_ld    = lsu_has_fence
                                  &&  rb_fence_ld
                                  &&  (rb_create_ptr0_x
                                    //    || rb_create_ptr1_x
                                       || rb_create_ptr2_x
                                       || rb_create_ptr3_x);

assign rb_entry_create_wait_rdy = rb_entry_ld0_create_vld_x
                                      &&  !lda0_ex3_mcic_borrow_mmu
                                      &&  (lda0_ex3_page_so
                                          ||  rb_entry_hit_fence_ld)
                                //   || rb_entry_ld1_create_vld_x
                                //      && !lda1_ex3_mcic_borrow_mmu
                                //      && (lda1_ex3_page_so
                                //          || rb_entry_hit_fence_ld)
                                  || rb_entry_ls0_create_vld_x
                                     && lsda0_ex3_is_load
                                     && !lsda0_ex3_mcic_borrow_mmu
                                     && (lsda0_ex3_page_so
                                         || rb_entry_hit_fence_ld)
                                  || rb_entry_ls1_create_vld_x
                                     && lsda1_ex3_is_load
                                     && !lsda1_ex3_mcic_borrow_mmu
                                     && (lsda1_ex3_page_so
                                         || rb_entry_hit_fence_ld)
                                  || rb_entry_ls0_create_vld_x
                                     && !lsda0_ex3_is_load
                                     && (lsda0_ex3_fence_inst
                                          ||  lsda0_ex3_sync_inst)
                                  || rb_entry_ls1_create_vld_x
                                     && !lsda1_ex3_is_load
                                     && (lsda1_ex3_fence_inst
                                          ||  lsda1_ex3_sync_inst);

//==========================================================
//                 State 1 : wait for ready
//==========================================================
//to make it easy, rb send bar/sync ar request must wait wmb has sent aw request
assign rb_entry_fence_ready   = rb_entry_fence
                              &&  wmb_sync_fence_biu_req_success
                              &&  (!rb_entry_fence_mode[0]
                                  ||  rb_ready_ld_req_biu_success);

assign rb_entry_sync_ready  = rb_entry_sync
                              &&  wmb_sync_fence_biu_req_success
                              &&  rb_ready_all_req_biu_success;

assign rb_entry_not_sync_fence_ready  = rb_entry_not_sync_fence
                                        &&  (rb_entry_page_so
                                                &&  rb_entry_cmit
                                                &&  !wmb_rb_so_pending
                                            || !rb_entry_page_so
                                                &&  !lsu_has_fence); 
                              
assign rb_entry_ready_to_biu_req  = rb_entry_vld
                                    &&  (rb_entry_fence_ready
                                        ||  rb_entry_sync_ready
                                        ||  rb_entry_not_sync_fence_ready);

assign rb_entry_biu_pe_req_gateclk_en = ((rb_entry_state[3:0]  ==  WAIT_RDY)
                                            ||  rb_entry_biu_req
                                                &&  !rb_entry_biu_pe_req_success)
                                        &&  !rb_entry_flush_clear;

assign rb_entry_biu_pe_req      = (rb_entry_ready_to_biu_req
                                          &&  (rb_entry_state[3:0]  ==  WAIT_RDY)
                                      ||  rb_entry_biu_req
                                          &&  !rb_entry_biu_pe_req_success)
                                  &&  !rb_entry_flush_clear;


//==========================================================
//                 State 2 : request biu/lfb
//==========================================================
//------------------biu/lfb req-----------------------------
assign rb_entry_biu_req         = rb_entry_state[3:0]  ==  REQ_BIU;
assign rb_entry_r_id_hit    = biu_lsu_r_vld
                              &&  (rb_entry_biu_id[4:0]  ==  biu_lsu_r_id[4:0]);
assign rb_entry_b_id_hit    = biu_lsu_b_vld
                              &&  (rb_entry_biu_id[4:0]  ==  biu_lsu_b_id[4:0]);


assign rb_entry_biu_bypass_vld  = rb_entry_r_id_hit
                                  &&  (rb_entry_state[3:0] ==  WAIT_RESP)
                                  &&  (!rb_entry_page_so
//                                      ||  rb_entry_atomic && !rb_entry_page_so
//                                      ||  rb_entry_next_nc_bypass
                                      ||  rb_entry_next_so_bypass_x
                                      ||  rb_entry_sync_fence);

assign rb_entry_biu_r_resp_set  = rb_entry_r_id_hit
                                  &&  (!rb_entry_inst_us || rb_entry_us_cnt)
                                  &&  (rb_entry_state[3:0] ==  WAIT_RESP)
                                  &&  (!rb_entry_page_so
                                      ||  rb_entry_next_so_bypass_x
                                      ||  rb_entry_sync_fence);

assign rb_entry_biu_b_resp_set  = rb_entry_b_id_hit;

assign rb_entry_atomic_next_resp  = rb_entry_vld
                                    &&  rb_entry_atomic
                                    &&  (rb_entry_next_so_bypass_x
                                        ||  !rb_entry_page_so);

//if non-cacheable ldex, response okay is regarded as bus error
assign rb_entry_bus_err_set     = rb_entry_biu_r_resp_set
                                  &&  (rb_r_resp_err
                                      ||  rb_entry_atomic
                                          &&  !rb_entry_page_ca
                                          &&  rb_r_resp_okay);

assign rb_entry_fof_bus_err     = rb_entry_inst_fof
                                  && rb_entry_bus_err_set;
//only first fof element will trigger bus error
assign rb_entry_fof_bus_err_element[8:0] = rb_entry_secd
                                           ? rb_entry_secd_setvl_val[8:0]
                                           : rb_entry_setvl_val[8:0];

assign rb_entry_fof_not_first    = rb_entry_inst_fof
                                   && (rb_entry_fof_bus_err_element[8:0] != 9'b0);

//find whether it is vreg first element
// &CombBeg; @762
//rvv1.0 @hcl
always @( rb_entry_vmew[1:0]
       or rb_entry_fof_bus_err_element[3:0])
begin
case(rb_entry_vmew[1:0])
  S_BYTE: rb_entry_fof_vreg_element[3:0] = rb_entry_fof_bus_err_element[3:0];
  HALF: rb_entry_fof_vreg_element[3:0] = {1'b0,rb_entry_fof_bus_err_element[2:0]};
  WORD: rb_entry_fof_vreg_element[3:0] = {2'b0,rb_entry_fof_bus_err_element[1:0]};
  DWORD:rb_entry_fof_vreg_element[3:0] = {3'b0,rb_entry_fof_bus_err_element[0]};
  default:rb_entry_fof_vreg_element[3:0] = {4{1'bx}};
endcase
// &CombEnd; @770
end

//vreg first element should not write data back
assign rb_entry_fof_bus_err_expt = rb_entry_fof_bus_err
                                   && (rb_entry_fof_vreg_element[3:0] == 4'b0); 

//------------------data bypass signal----------------------
assign rb_entry_data_bypass_vld = rb_entry_biu_bypass_vld
                                  &&  rb_entry_dest_vld
                                  &&  (!rb_entry_atomic
                                      ||  lm_already_snoop
                                      ||  !rb_entry_dcache_hit);

//------------------settle data from biu--------------------

// assign rb_entry_biu_data_ori[127:0]  =   {{{8{rb_entry_bytes_vld[15]}}  & biu_lsu_r_data_mask_128[127:120]}
//                                          ,{{8{rb_entry_bytes_vld[14]}}  & biu_lsu_r_data_mask_128[119:112]}
//                                          ,{{8{rb_entry_bytes_vld[13]}}  & biu_lsu_r_data_mask_128[111:104]}
//                                          ,{{8{rb_entry_bytes_vld[12]}}  & biu_lsu_r_data_mask_128[103:96]}
//                                          ,{{8{rb_entry_bytes_vld[11]}}  & biu_lsu_r_data_mask_128[95:88]}
//                                          ,{{8{rb_entry_bytes_vld[10]}}  & biu_lsu_r_data_mask_128[87:80]}
//                                          ,{{8{rb_entry_bytes_vld[9]}}   & biu_lsu_r_data_mask_128[79:72]}
//                                          ,{{8{rb_entry_bytes_vld[8]}}   & biu_lsu_r_data_mask_128[71:64]}
//                                          ,{{8{rb_entry_bytes_vld[7]}}   & biu_lsu_r_data_mask_128[63:56]}
//                                          ,{{8{rb_entry_bytes_vld[6]}}   & biu_lsu_r_data_mask_128[55:48]}
//                                          ,{{8{rb_entry_bytes_vld[5]}}   & biu_lsu_r_data_mask_128[47:40]}
//                                          ,{{8{rb_entry_bytes_vld[4]}}   & biu_lsu_r_data_mask_128[39:32]}
//                                          ,{{8{rb_entry_bytes_vld[3]}}   & biu_lsu_r_data_mask_128[31:24]}
//                                          ,{{8{rb_entry_bytes_vld[2]}}   & biu_lsu_r_data_mask_128[23:16]}
//                                          ,{{8{rb_entry_bytes_vld[1]}}   & biu_lsu_r_data_mask_128[15:8]}
//                                          ,{{8{rb_entry_bytes_vld[0]}}   & biu_lsu_r_data_mask_128[7:0]}}; 
generate
    for(genvar i=0; i<16; i++)begin 
      assign rb_entry_biu_data_ori[i*8 +: 8]  = {8{rb_entry_bytes_vld[i]}}  & biu_lsu_r_data0[i*8 +: 8];
      assign rb_entry_biu_data_ori1[i*8 +: 8] = {8{rb_entry_bytes_vld1[i]}} & biu_lsu_r_data1[i*8 +: 8];
      assign rb_entry_biu_data_ori2[i*8 +: 8] = {8{rb_entry_bytes_vld2[i]}} & biu_lsu_r_data2[i*8 +: 8];
      assign rb_entry_biu_data_ori3[i*8 +: 8] = {8{rb_entry_bytes_vld3[i]}} & biu_lsu_r_data3[i*8 +: 8];
    end
endgenerate
// wjh@2410, rb_entry_boundary means this is a 16B-unalign req
// whether it is boundary-first or bourdary-secode, swap the high bytes and the low bytes
//+-------------------------------+
//| rb entry data generations |
//+-------------------------------+
xx_lsu_rb_data x_xx_lsu_rb_data_0
(
  .entry_data         (rb_entry_data),
  .entry_bytes_vld    (rb_entry_bytes_vld),
  .entry_inst_us      (rb_entry_inst_us),
  .entry_boundary     (rb_entry_boundary),
  .entry_wait_data_ff (rb_entry_ld_wait_data_ff),
  .ld0_create_vld_ff  (rb_entry_ld0_create_vld_ff),
  .ld0_merge_vld_ff   (rb_entry_ld0_merge_vld_ff),
  .ld0_boundary_ff    (lda0_ex3_boundary_after_mask_ff),
  .ls0_create_vld_ff  (rb_entry_ls0_create_vld_ff),
  .ls0_merge_vld_ff   (rb_entry_ls0_merge_vld_ff),
  .ls0_boundary_ff    (lsda0_ex3_boundary_after_mask_ff),
  .ls1_create_vld_ff  (rb_entry_ls1_create_vld_ff),
  .ls1_merge_vld_ff   (rb_entry_ls1_merge_vld_ff),
  .ls1_boundary_ff    (lsda1_ex3_boundary_after_mask_ff),
  .ld0_data_ori       (lda0_rb_ex3_data_ori),
  .ls0_data_ori       (lsda0_rb_ex3_data_ori),
  .ls1_data_ori       (lsda1_rb_ex3_data_ori),
  .biu_data_ori       (rb_entry_biu_data_ori),
  .merge_data         (rb_entry_merge_data),
  .data_aft_rev       (ld_da_data_aft_rev),
  .biu_data_updt      (rb_entry_biu_data_update)
);

xx_lsu_rb_data x_xx_lsu_rb_data_1
(
  .entry_data         (rb_entry_data1),
  .entry_bytes_vld    (rb_entry_bytes_vld1),
  .entry_inst_us      (rb_entry_inst_us),
  .entry_boundary     (rb_entry_boundary),
  .entry_wait_data_ff (rb_entry_ld_wait_data_ff),
  .ld0_create_vld_ff  (rb_entry_ld0_create_vld_ff),
  .ld0_merge_vld_ff   (rb_entry_ld0_merge_vld_ff),
  .ld0_boundary_ff    (lda0_ex3_boundary_after_mask_ff),
  .ls0_create_vld_ff  (rb_entry_ls0_create_vld_ff),
  .ls0_merge_vld_ff   (rb_entry_ls0_merge_vld_ff),
  .ls0_boundary_ff    (lsda0_ex3_boundary_after_mask_ff),
  .ls1_create_vld_ff  (rb_entry_ls1_create_vld_ff),
  .ls1_merge_vld_ff   (rb_entry_ls1_merge_vld_ff),
  .ls1_boundary_ff    (lsda1_ex3_boundary_after_mask_ff),
  .ld0_data_ori       (lda0_rb_ex3_data_ori1),
  .ls0_data_ori       (lsda0_rb_ex3_data_ori1),
  .ls1_data_ori       (lsda1_rb_ex3_data_ori1),
  .biu_data_ori       (rb_entry_biu_data_ori1),
  .merge_data         (rb_entry_merge_data1),
  .data_aft_rev       (ld_da_data_aft_rev1),
  .biu_data_updt      (rb_entry_biu_data_update1)
);

xx_lsu_rb_data x_xx_lsu_rb_data_2
(
  .entry_data         (rb_entry_data2),
  .entry_bytes_vld    (rb_entry_bytes_vld2),
  .entry_inst_us      (rb_entry_inst_us),
  .entry_boundary     (rb_entry_boundary),
  .entry_wait_data_ff (rb_entry_ld_wait_data_ff),
  .ld0_create_vld_ff  (rb_entry_ld0_create_vld_ff),
  .ld0_merge_vld_ff   (rb_entry_ld0_merge_vld_ff),
  .ld0_boundary_ff    (lda0_ex3_boundary_after_mask_ff),
  .ls0_create_vld_ff  (rb_entry_ls0_create_vld_ff),
  .ls0_merge_vld_ff   (rb_entry_ls0_merge_vld_ff),
  .ls0_boundary_ff    (lsda0_ex3_boundary_after_mask_ff),
  .ls1_create_vld_ff  (rb_entry_ls1_create_vld_ff),
  .ls1_merge_vld_ff   (rb_entry_ls1_merge_vld_ff),
  .ls1_boundary_ff    (lsda1_ex3_boundary_after_mask_ff),
  .ld0_data_ori       (lda0_rb_ex3_data_ori2),
  .ls0_data_ori       (lsda0_rb_ex3_data_ori2),
  .ls1_data_ori       (lsda1_rb_ex3_data_ori2),
  .biu_data_ori       (rb_entry_biu_data_ori2),
  .merge_data         (rb_entry_merge_data2),
  .data_aft_rev       (ld_da_data_aft_rev2),
  .biu_data_updt      (rb_entry_biu_data_update2)
);

xx_lsu_rb_data x_xx_lsu_rb_data_3
(
  .entry_data         (rb_entry_data3),
  .entry_bytes_vld    (rb_entry_bytes_vld3),
  .entry_inst_us      (rb_entry_inst_us),
  .entry_boundary     (rb_entry_boundary),
  .entry_wait_data_ff (rb_entry_ld_wait_data_ff),
  .ld0_create_vld_ff  (rb_entry_ld0_create_vld_ff),
  .ld0_merge_vld_ff   (rb_entry_ld0_merge_vld_ff),
  .ld0_boundary_ff    (lda0_ex3_boundary_after_mask_ff),
  .ls0_create_vld_ff  (rb_entry_ls0_create_vld_ff),
  .ls0_merge_vld_ff   (rb_entry_ls0_merge_vld_ff),
  .ls0_boundary_ff    (lsda0_ex3_boundary_after_mask_ff),
  .ls1_create_vld_ff  (rb_entry_ls1_create_vld_ff),
  .ls1_merge_vld_ff   (rb_entry_ls1_merge_vld_ff),
  .ls1_boundary_ff    (lsda1_ex3_boundary_after_mask_ff),
  .ld0_data_ori       (lda0_rb_ex3_data_ori3),
  .ls0_data_ori       (lsda0_rb_ex3_data_ori3),
  .ls1_data_ori       (lsda1_rb_ex3_data_ori3),
  .biu_data_ori       (rb_entry_biu_data_ori3),
  .merge_data         (rb_entry_merge_data3),
  .data_aft_rev       (ld_da_data_aft_rev3),
  .biu_data_updt      (rb_entry_biu_data_update3)
);


//+-------------------------------+
//| comment the following codes |
//+-------------------------------+
// assign rb_entry_biu_data_update[127:0] = rb_entry_boundary
//                                          ? {rb_entry_biu_data_ori[63:32],rb_entry_biu_data_ori[31:0],
//                                             rb_entry_biu_data_ori[127:96],rb_entry_biu_data_ori[95:64]}
//                                          :  rb_entry_biu_data_ori[127:0];
// generate
//   for(genvar i=0; i<16; i++) begin 
//     assign rb_entry_biu_data_update1[i*8 +: 8] = {8{rb_entry_bytes_vld1[i]}} & biu_lsu_r_data_mask[(i+16)*8 +: 8];
//     assign rb_entry_biu_data_update2[i*8 +: 8] = {8{rb_entry_bytes_vld2[i]}} & biu_lsu_r_data_mask[i*8 +: 8];
//     assign rb_entry_biu_data_update3[i*8 +: 8] = {8{rb_entry_bytes_vld3[i]}} & biu_lsu_r_data_mask[(i+16)*8 +: 8];
//   end
// endgenerate
// //---------------------merge data---------------------------
// assign rb_entry_merge_sel = rb_entry_ld_wait_data_ff; 
// // &Force("input", "ld_da_boundary_after_mask_ff"); @817
// // for boundary req, data of high bytes in the low addr (boundary_first) are swap to the low bytes
// // data of low bytes in the high addr (boundary secd) is swap to the high bytes
// assign lda0_data_aft_rev_ff[127:0] = lda0_ex3_boundary_after_mask_ff
//                                    ? {lda0_rb_ex3_data_ori[63:32], lda0_rb_ex3_data_ori[31:0],
//                                       lda0_rb_ex3_data_ori[127:96],lda0_rb_ex3_data_ori[95:64]}
//                                    :  lda0_rb_ex3_data_ori[127:0];
// // assign lda1_data_aft_rev_ff[127:0] = lda1_ex3_boundary_after_mask_ff
// //                                    ? {lda1_rb_ex3_data_ori[63:32], lda1_rb_ex3_data_ori[31:0],
// //                                       lda1_rb_ex3_data_ori[127:96],lda1_rb_ex3_data_ori[95:64]}
// //                                    :  lda1_rb_ex3_data_ori[127:0];
// assign lsda0_data_aft_rev_ff[127:0] = lsda0_ex3_boundary_after_mask_ff
//                                    ? {lsda0_rb_ex3_data_ori[63:32], lsda0_rb_ex3_data_ori[31:0],
//                                       lsda0_rb_ex3_data_ori[127:96],lsda0_rb_ex3_data_ori[95:64]}
//                                    :  lsda0_rb_ex3_data_ori[127:0];
// assign lsda1_data_aft_rev_ff[127:0] = lsda1_ex3_boundary_after_mask_ff
//                                    ? {lsda1_rb_ex3_data_ori[63:32], lsda1_rb_ex3_data_ori[31:0],
//                                       lsda1_rb_ex3_data_ori[127:96],lsda1_rb_ex3_data_ori[95:64]}
//                                    :  lsda1_rb_ex3_data_ori[127:0];
// always_comb begin 
//     ld_da_data_aft_rev = '0;
//     if(rb_entry_ld0_create_vld_ff || rb_entry_ld0_merge_vld_ff)
//         ld_da_data_aft_rev = lda0_data_aft_rev_ff;
//     // else if(rb_entry_ld1_create_vld_ff || rb_entry_ld1_merge_vld_ff)
//     //     ld_da_data_aft_rev = lda1_data_aft_rev_ff;
//     else if(rb_entry_ls0_create_vld_ff || rb_entry_ls0_merge_vld_ff)
//         ld_da_data_aft_rev = lsda0_data_aft_rev_ff;
//     else if(rb_entry_ls1_create_vld_ff || rb_entry_ls1_merge_vld_ff)
//         ld_da_data_aft_rev = lsda1_data_aft_rev_ff;
// end 

// always_comb begin 
//     rb_entry_data_ori_mux = rb_entry_biu_data_ori;
//     if(rb_entry_ld0_create_vld_ff || rb_entry_ld0_merge_vld_ff)
//         rb_entry_data_ori_mux = lda0_rb_ex3_data_ori;
//     // else if(rb_entry_ld1_create_vld_ff || rb_entry_ld1_merge_vld_ff)
//     //     rb_entry_data_ori_mux = lda1_rb_ex3_data_ori;
//     else if(rb_entry_ls0_create_vld_ff || rb_entry_ls0_merge_vld_ff)
//         rb_entry_data_ori_mux = lsda0_rb_ex3_data_ori;
//     else if(rb_entry_ls1_create_vld_ff || rb_entry_ls1_merge_vld_ff)
//         rb_entry_data_ori_mux = lsda1_rb_ex3_data_ori;

// end 

// assign rb_entry_merge_data_ori[127:0] = rb_entry_merge_sel 
//                                         ? rb_entry_data_ori_mux[127:0]
//                                         : rb_entry_biu_data_ori[127:0];

// assign rb_entry_merge_bytes_vld[15:0] = rb_entry_bytes_vld[15:0];

// assign rb_entry_merge_data_sel[127:0] = {{8{rb_entry_merge_bytes_vld[7]}},
//                                          {8{rb_entry_merge_bytes_vld[6]}},
//                                          {8{rb_entry_merge_bytes_vld[5]}},
//                                          {8{rb_entry_merge_bytes_vld[4]}},
//                                          {8{rb_entry_merge_bytes_vld[3]}},
//                                          {8{rb_entry_merge_bytes_vld[2]}},
//                                          {8{rb_entry_merge_bytes_vld[1]}},
//                                          {8{rb_entry_merge_bytes_vld[0]}},
//                                          {8{rb_entry_merge_bytes_vld[15]}},
//                                          {8{rb_entry_merge_bytes_vld[14]}},
//                                          {8{rb_entry_merge_bytes_vld[13]}},
//                                          {8{rb_entry_merge_bytes_vld[12]}},
//                                          {8{rb_entry_merge_bytes_vld[11]}},
//                                          {8{rb_entry_merge_bytes_vld[10]}},
//                                          {8{rb_entry_merge_bytes_vld[9]}},
//                                          {8{rb_entry_merge_bytes_vld[8]}}};

// assign rb_entry_merge_data_aft_rev[127:0] = {rb_entry_merge_data_ori[63:32],rb_entry_merge_data_ori[31:0],
//                                              rb_entry_merge_data_ori[127:96],rb_entry_merge_data_ori[95:64]};
// // wjh@2410 the high and low bytes of rb_entry_data is already swap
// assign rb_entry_merge_data[127:0]         = rb_entry_data[127:0] & ~rb_entry_merge_data_sel[127:0]
//                                             | rb_entry_merge_data_aft_rev[127:0];
//------------------resp success signal---------------------
// inst_type                      cmplt condition
// sync                           r&b resp
// fence                          r&b resp
// ld/atomic !boundary_first      -> REQ_WB
// ld boundary_first              -> WAIT_MERGE
assign rb_entry_sync_resp_success   = rb_entry_sync
                                      &&  rb_entry_biu_r_resp
                                      &&  rb_entry_biu_b_resp;
assign rb_entry_fence_resp_success  = rb_entry_fence
                                      &&  rb_entry_biu_r_resp
                                      &&  rb_entry_biu_b_resp;

//------------------generate next state signal--------------
assign rb_entry_wait_resp_imme_idle   = !rb_entry_dest_vld
                                        &&  rb_entry_page_ca
                                        &&  rb_entry_not_sync_fence;
                                        
assign rb_entry_sync_fence_resp_success = rb_entry_sync_resp_success
                                          ||  rb_entry_fence_resp_success;

assign rb_entry_wait_resp_to_req_merge  = rb_entry_biu_r_resp_set
                                          &&  rb_entry_boundary
                                          &&  !rb_entry_secd
                                          &&  rb_entry_not_sync_fence;



//==========================================================
//                 State 4 : req cmplt/data
//==========================================================
//------------------req cmplt signal------------------------
//so need to request wb cmplt part when grnt
//ldex need to request wb cmplt part when get data
//and only one entry will request cmplt part
assign rb_entry_wb_cmplt_req    = !rb_entry_wb_cmplt_success
                                  &&  rb_entry_dest_vld
                                  // &&  !rb_entry_data_check // Risc-V Debug zdb
                                  &&  (rb_entry_page_so
                                          &&  !rb_entry_atomic
                                          &&  (rb_entry_state[3:0] ==  WAIT_RESP)
                                      ||  (rb_entry_state[3:0] ==  REQ_WB))
                                  &&  (rb_entry_cmit || !rtu_ck_flush || !rtu_ck_flush_iid_older_than_entry_iid);   //flush younger and no_cmit entry, ck_flush@LTL
//------------------req data signal-------------------------
//if get bus error, then it must commit and send bus_err signal
assign rb_entry_wb_data_req     = rb_entry_dest_vld
                                  &&  (rb_entry_state[3:0] ==  REQ_WB)
                                  &&  (!rb_entry_bus_err  ||  rb_entry_cmit)
                                  &&  (rb_entry_wb_cmplt_success || rb_entry_data_check || ~rb_entry_inst_vls) // Risc-V Debug zdb
                                  &&  !rb_entry_wb_data_success
                                  &&  (rb_entry_cmit || !rtu_ck_flush || !rtu_ck_flush_iid_older_than_entry_iid); //flush younger and no_cmit entry, ck_flush@LTL

//for timing, select data_ptr one cycle ahead
assign rb_entry_wb_data_req_pre = rb_entry_biu_r_resp_set
                                  &&  (!rb_entry_boundary
                                      || rb_entry_secd)
                                  &&  rb_entry_wb_cmplt_success
                                  &&  rb_entry_not_sync_fence;
                                   
assign rb_entry_wb_data_pre_sel = rb_entry_wb_data_req 
                                  || rb_entry_wb_data_req_pre; 
//------------------generate next state signal--------------
assign rb_entry_req_wb_success     = rb_entry_vld
                                     &&  rb_entry_wb_cmplt_success
                                     &&  (rb_entry_wb_data_grnt_x || rb_entry_wb_data_success);

//get data_vld signal, if data_vld, then it will not hit idx on sq_pop
assign rb_entry_data_vld  = (rb_entry_state[3:0] == REQ_WB)
                            ||  (rb_entry_state[3:0] == WAIT_DATA_FF)
                                && rb_entry_boundary
                            ||  (rb_entry_state[3:0] == WAIT_MERGE);

assign rb_entry_flush_ff = (rb_entry_state[3:0] == FLUSH_FF);


//==========================================================
//                 State 5 : wait for merge
//==========================================================
//------------------generate merge signal------------------
// assign rb_entry_iid_hit         = rb_entry_iid[6:0] ==  ld_da_iid[6:0];
// --------------------------------- ld0 -----------------------
assign rb_entry_ld0_merge_pre    = (rb_entry_state[3:0] ==  WAIT_MERGE)
                                   && (rb_entry_iid      ==  lda0_ex3_iid     );

assign rb_entry_ld0_merge_vld    = lda0_rb_ex3_merge_vld
                                  &&  rb_entry_ld0_merge_pre;

assign rb_entry_ld0_merge_dp_vld = lda0_rb_ex3_merge_dp_vld
                                  &&  rb_entry_ld0_merge_pre;
// --------------------------------- ld1 -------------------------
// assign rb_entry_ld1_merge_pre    = (rb_entry_state[3:0] ==  WAIT_MERGE)
//                                    && (rb_entry_iid      ==  lda1_ex3_iid     );

// assign rb_entry_ld1_merge_vld    = lda1_rb_ex3_merge_vld
//                                   &&  rb_entry_ld1_merge_pre;

// assign rb_entry_ld1_merge_dp_vld = lda1_rb_ex3_merge_dp_vld
//                                   &&  rb_entry_ld1_merge_pre;

// --------------------------------- ls0 -----------------------
assign rb_entry_ls0_merge_pre    = (rb_entry_state[3:0] ==  WAIT_MERGE)
                                   && (rb_entry_iid      ==  lsda0_ex3_iid     );

assign rb_entry_ls0_merge_vld    = lsda0_rb_ex3_merge_vld
                                  &&  rb_entry_ls0_merge_pre;

assign rb_entry_ls0_merge_dp_vld = lsda0_rb_ex3_merge_dp_vld
                                  &&  rb_entry_ls0_merge_pre;
// --------------------------------- ls1 -----------------------
assign rb_entry_ls1_merge_pre    = (rb_entry_state[3:0] ==  WAIT_MERGE)
                                   && (rb_entry_iid      ==  lsda1_ex3_iid     );

assign rb_entry_ls1_merge_vld    = lsda1_rb_ex3_merge_vld
                                  &&  rb_entry_ls1_merge_pre;

assign rb_entry_ls1_merge_dp_vld = lsda1_rb_ex3_merge_dp_vld
                                  &&  rb_entry_ls1_merge_pre;


//for timing,use ld pipe data one cycle later
assign rb_entry_ld_wait_data_ff = (rb_entry_state[3:0] ==  WAIT_DATA_FF);

//this signal is for cancel dest_vld and pop entry
// --------------------------------- ld0 -----------------------
assign rb_entry_ld0_merge_expt_vld = lda0_rb_ex3_merge_expt_vld
                                     &&  rb_entry_vld
                                     &&  rb_entry_boundary
                                     &&  !rb_entry_secd
                                     &&  (rb_entry_iid == lda0_ex3_iid);

assign rb_entry_ld0_merge_gateclk_en  = lda0_rb_ex3_merge_gateclk_en
                                        &&  rb_entry_ld0_merge_pre;
// --------------------------------- ld1 -----------------------
// assign rb_entry_ld1_merge_expt_vld = lda1_rb_ex3_merge_expt_vld
//                                      &&  rb_entry_vld
//                                      &&  rb_entry_boundary
//                                      &&  !rb_entry_secd
//                                      &&  (rb_entry_iid == lda1_ex3_iid);

// assign rb_entry_ld1_merge_gateclk_en  = lda1_rb_ex3_merge_gateclk_en
//                                         &&  rb_entry_ld1_merge_pre;
// --------------------------------- ls0 -----------------------
assign rb_entry_ls0_merge_expt_vld = lsda0_rb_ex3_merge_expt_vld
                                     &&  rb_entry_vld
                                     &&  rb_entry_boundary
                                     &&  !rb_entry_secd
                                     &&  (rb_entry_iid == lsda0_ex3_iid);

assign rb_entry_ls0_merge_gateclk_en  = lsda0_rb_ex3_merge_gateclk_en
                                        &&  rb_entry_ls0_merge_pre;
// --------------------------------- ls1 -----------------------
assign rb_entry_ls1_merge_expt_vld = lsda1_rb_ex3_merge_expt_vld
                                     &&  rb_entry_vld
                                     &&  rb_entry_boundary
                                     &&  !rb_entry_secd
                                     &&  (rb_entry_iid == lsda1_ex3_iid);

assign rb_entry_ls1_merge_gateclk_en  = lsda1_rb_ex3_merge_gateclk_en
                                        &&  rb_entry_ls1_merge_pre;


//------------------boundary depd vld-----------------------
// --------------------------------- ld0 -----------------------
assign rb_entry_merge_fail0_x      = (rb_entry_iid == lda0_ex3_iid)
                                     &&  rb_entry_dest_vld
                                     &&  rb_entry_boundary
                                     &&  !rb_entry_secd
                                     &&  rb_entry_vld
                                     &&  (rb_entry_state[3:0] !=  WAIT_MERGE);
// if not rb_entry_lda0_hit_idx_x, then the secd req can be woken up when the state is wait-merge
assign rb_entry_boundary_depd_set0 = rb_entry_merge_fail0_x
                                    &&  lda0_rb_ex3_discard_grnt
                                    &&  !rb_entry_lda0_hit_idx_x;
//boundary depd clr
assign rb_entry_boundary_wakeup0   = rb_entry_boundary_depd0
                                    &&  (rb_entry_state[3:0] ==  WAIT_MERGE);



// --------------------------------- ld1 -----------------------
// assign rb_entry_merge_fail1_x      = (rb_entry_iid == lda1_ex3_iid)
//                                      &&  rb_entry_dest_vld
//                                      &&  rb_entry_boundary
//                                      &&  !rb_entry_secd
//                                      &&  rb_entry_vld
//                                      &&  (rb_entry_state[3:0] !=  WAIT_MERGE);

// assign rb_entry_boundary_depd_set1 = rb_entry_merge_fail1_x
//                                     &&  lda1_rb_ex3_discard_grnt
//                                     &&  !rb_entry_lda1_hit_idx_x;
// //boundary depd clr
// assign rb_entry_boundary_wakeup1   = rb_entry_boundary_depd1
//                                     &&  (rb_entry_state[3:0] ==  WAIT_MERGE);

// --------------------------------- ls0 -----------------------
assign rb_entry_merge_fail2_x      = (rb_entry_iid == lsda0_ex3_ld_iid)
                                     &&  rb_entry_dest_vld
                                     &&  rb_entry_boundary
                                     &&  !rb_entry_secd
                                     &&  rb_entry_vld
                                     &&  (rb_entry_state[3:0] !=  WAIT_MERGE);

assign rb_entry_boundary_depd_set2 = rb_entry_merge_fail2_x
                                    &&  lsda0_rb_ex3_discard_grnt
                                    && !rb_entry_ls0_ld_hit_idx;
                                    // &&  !rb_entry_lsda0_hit_idx_x;
//boundary depd clr
assign rb_entry_boundary_wakeup2   = rb_entry_boundary_depd2
                                    &&  (rb_entry_state[3:0] ==  WAIT_MERGE);


// --------------------------------- ls1 -----------------------
assign rb_entry_merge_fail3_x      = (rb_entry_iid == lsda1_ex3_ld_iid)
                                     &&  rb_entry_dest_vld
                                     &&  rb_entry_boundary
                                     &&  !rb_entry_secd
                                     &&  rb_entry_vld
                                     &&  (rb_entry_state[3:0] !=  WAIT_MERGE);

assign rb_entry_boundary_depd_set3 = rb_entry_merge_fail3_x
                                    &&  lsda1_rb_ex3_discard_grnt
                                    && !rb_entry_ls1_ld_hit_idx;
                                    // &&  !rb_entry_lsda1_hit_idx_x;
//boundary depd clr
assign rb_entry_boundary_wakeup3   = rb_entry_boundary_depd3
                                    &&  (rb_entry_state[3:0] ==  WAIT_MERGE);


//==========================================================
//                 Barrier inst
//==========================================================
assign rb_entry_fence_ld_vld      = rb_entry_fence
                                    &&  rb_entry_vld
                                    &&  rb_entry_fence_mode[0];

//==========================================================
//                 Compare index
//==========================================================
//------------------compare ld_da stage---------------------
//if has requested biu, then it will not compare with ld_da/st_da
//for nc wo,should also check address for RAR
assign rb_entry_addr_5to4_hit0 = (rb_entry_addr[5:4]       ==  lda0_ex3_addr_5to4[1:0]);
assign rb_entry_bytes_vld_hit0 = |(rb_entry_bytes_vld[15:0]  & lda0_ex3_bytes_vld[15:0]);
// assign rb_entry_addr_5to4_hit1 = (rb_entry_addr[5:4]       ==  lda1_ex3_addr_5to4[1:0]);
// assign rb_entry_bytes_vld_hit1 = |(rb_entry_bytes_vld[15:0]  & lda1_ex3_bytes_vld[15:0]);
assign rb_entry_addr_5to4_hit2 = (rb_entry_addr[5:4]       ==  lsda0_ex3_addr_5to4[1:0]);
assign rb_entry_bytes_vld_hit2 = |(rb_entry_bytes_vld[15:0]  & lsda0_ex3_bytes_vld[15:0]);
assign rb_entry_addr_5to4_hit3 = (rb_entry_addr[5:4]       ==  lsda1_ex3_addr_5to4[1:0]);
assign rb_entry_bytes_vld_hit3 = |(rb_entry_bytes_vld[15:0]  & lsda1_ex3_bytes_vld[15:0]);



assign rb_entry_lda0_hit_idx_x  = rb_entry_vld
                                  &&  !rb_entry_page_so
                                  &&  !rb_entry_sync_fence
                                  &&  !rb_entry_data_vld
                                  &&  !rb_entry_flush_ff
                                  &&  (rb_entry_addr[`WK_PA_WIDTH-1:6] == lda0_ex3_addr[`WK_PA_WIDTH-1:6]
                                       || (rb_entry_addr[13:6] == lda0_ex3_addr[13:6]
                                           && (rb_entry_ldamo | lda0_rb_ex3_ldamo)))// (rb_entry_addr[13:6] == lda0_ex3_idx[7:0])
                                  &&  (rb_entry_page_ca == lda0_ex3_page_ca)
                                  &&  (rb_entry_page_ca 
                                       || rb_entry_addr_5to4_hit0 && rb_entry_bytes_vld_hit0); 

// assign rb_entry_lda1_hit_idx_x  = rb_entry_vld
//                                   &&  !rb_entry_page_so
//                                   &&  !rb_entry_sync_fence
//                                   &&  !rb_entry_data_vld
//                                   &&  !rb_entry_flush_ff
//                                   &&  (rb_entry_addr[13:6] == lda1_ex3_idx[7:0])
//                                   &&  (rb_entry_page_ca == lda1_ex3_page_ca)
//                                   &&  (rb_entry_page_ca 
//                                        || rb_entry_addr_5to4_hit1 && rb_entry_bytes_vld_hit1); 

assign rb_entry_ls0_ld_hit_idx     = rb_entry_vld
                                     &&  !rb_entry_page_so
                                     &&  !rb_entry_sync_fence
                                     &&  !rb_entry_data_vld
                                     &&  !rb_entry_flush_ff
                                     &&  (rb_entry_addr[`WK_PA_WIDTH-1:6] == lsda0_ex3_ld_addr[`WK_PA_WIDTH-1:6]
                                          || (rb_entry_addr[13:6] == lsda0_ex3_ld_addr[13:6]
                                              && (rb_entry_ldamo | lsda0_rb_ex3_ldamo)))// (rb_entry_addr[13:6] == lsda0_ex3_idx[7:0])
                                     &&  (rb_entry_page_ca == lsda0_ex3_ld_page_ca)
                                     &&  (rb_entry_page_ca 
                                          || rb_entry_addr_5to4_hit2 && rb_entry_bytes_vld_hit2); 

assign rb_entry_ls1_ld_hit_idx     = rb_entry_vld
                                     &&  !rb_entry_page_so
                                     &&  !rb_entry_sync_fence
                                     &&  !rb_entry_data_vld
                                     &&  !rb_entry_flush_ff
                                     &&  (rb_entry_addr[`WK_PA_WIDTH-1:6] == lsda1_ex3_ld_addr[`WK_PA_WIDTH-1:6]
                                          || (rb_entry_addr[13:6] == lsda1_ex3_ld_addr[13:6]
                                              && (rb_entry_ldamo | lsda1_rb_ex3_ldamo)))// (rb_entry_addr[13:6] == lsda1_ex3_idx[7:0])
                                     &&  (rb_entry_page_ca == lsda1_ex3_ld_page_ca)
                                     &&  (rb_entry_page_ca 
                                          || rb_entry_addr_5to4_hit3 && rb_entry_bytes_vld_hit3); 



//------------------compare st_da stage---------------------
assign rb_entry_ls0_st_hit_idx   = rb_entry_page_ca
                                   &&  rb_entry_vld
                                   &&  !rb_entry_data_vld
                                   &&  !rb_entry_flush_ff
                                   &&  !rb_entry_sync_fence
                                   &&  (rb_entry_addr[`WK_PA_WIDTH-1:6] == lsda0_ex3_st_addr[`WK_PA_WIDTH-1:6]
                                        || (rb_entry_addr[13:6] == lsda0_ex3_st_addr[13:6]
                                            && rb_entry_ldamo));
                                  //  &&  (rb_entry_addr[13:6]
                                  //      ==  lsda0_ex3_st_addr[13:6]);
assign rb_entry_ls1_st_hit_idx   = rb_entry_page_ca
                                   &&  rb_entry_vld
                                   &&  !rb_entry_data_vld
                                   &&  !rb_entry_flush_ff
                                   &&  !rb_entry_sync_fence
                                   &&  (rb_entry_addr[`WK_PA_WIDTH-1:6] == lsda1_ex3_st_addr[`WK_PA_WIDTH-1:6]
                                        || (rb_entry_addr[13:6] == lsda1_ex3_st_addr[13:6]
                                            && rb_entry_ldamo));
                                  //  &&  (rb_entry_addr[13:6]
                                  //      ==  lsda1_ex3_st_addr[13:6]);

// assign rb_entry_lsda0_hit_idx_x = lsda0_ex3_is_load? rb_entry_ls0_ld_hit_idx: rb_entry_ls0_st_hit_idx;
// assign rb_entry_lsda1_hit_idx_x = lsda1_ex3_is_load? rb_entry_ls1_ld_hit_idx: rb_entry_ls1_st_hit_idx;
assign rb_entry_lsda0_ld_hit_idx_x = rb_entry_ls0_ld_hit_idx;
assign rb_entry_lsda0_st_hit_idx_x = rb_entry_ls0_st_hit_idx;
assign rb_entry_lsda1_ld_hit_idx_x = rb_entry_ls1_ld_hit_idx;
assign rb_entry_lsda1_st_hit_idx_x = rb_entry_ls1_st_hit_idx;
//------------------depd_vld--------------------------------
assign rb_entry_discard_vld0 = lda0_rb_ex3_discard_grnt
                               && rb_entry_lda0_hit_idx_x;
// assign rb_entry_discard_vld1 = lda1_rb_ex3_discard_grnt
//                                && rb_entry_lda1_hit_idx_x;
assign rb_entry_discard_vld2 = lsda0_rb_ex3_discard_grnt
                               && rb_entry_ls0_ld_hit_idx;
assign rb_entry_discard_vld3 = lsda1_rb_ex3_discard_grnt
                               && rb_entry_ls1_ld_hit_idx;

//------------------compare sq pop entry--------------------
//sq pop entry must compare index if:
//ca && !req_biu
//!ca && !so && !data_vld
assign rb_entry_cmp_sq_pop_addr[`WK_PA_WIDTH-1:0] = sq_pop_addr[`WK_PA_WIDTH-1:0];
assign rb_entry_sq_pop_cmp_vld  = rb_entry_page_ca  &&  sq_pop_page_ca  &&  !rb_entry_biu_req_success
                                  ||  !rb_entry_page_ca &&  !sq_pop_page_ca
                                      &&  !rb_entry_page_so &&  !sq_pop_page_so
                                      &&  !rb_entry_data_vld;
assign rb_entry_sq_pop_hit_idx  = rb_entry_sq_pop_cmp_vld
                                  &&  rb_entry_vld
                                  &&  !rb_entry_sync_fence
                                  &&  rb_entry_cmit
                                  &&  (rb_entry_addr[13:6]
                                      ==  rb_entry_cmp_sq_pop_addr[13:6]);
//------------------compare wmb ce entry---------------------
assign rb_entry_cmp_wmb_ce_addr[`WK_PA_WIDTH-1:0] = wmb_ce_addr[`WK_PA_WIDTH-1:0];
assign rb_entry_wmb_ce_cmp_vld  = rb_entry_page_ca  &&  wmb_ce_page_ca  &&  !rb_entry_biu_req_success
                                  ||  !rb_entry_page_ca &&  !wmb_ce_page_ca
                                      &&  !rb_entry_page_so &&  !wmb_ce_page_so
                                      &&  !rb_entry_data_vld;
assign rb_entry_wmb_ce_hit_idx  = rb_entry_wmb_ce_cmp_vld
                                  &&  rb_entry_vld
                                  &&  !rb_entry_sync_fence
                                  &&  rb_entry_cmit
                                  &&  (rb_entry_addr[13:6]
                                      ==  rb_entry_cmp_wmb_ce_addr[13:6]);

//------------------compare pfu pop entry--------------------
assign rb_entry_cmp_pfu_biu_req_addr[`WK_PA_WIDTH-1:0]  = pfu_biu_req_addr[`WK_PA_WIDTH-1:0];
assign rb_entry_pfu_biu_req_hit_idx = rb_entry_page_ca
                                      &&  rb_entry_vld
                                      &&  !rb_entry_sync_fence
                                      &&  (rb_entry_addr[13:6]
                                          ==  rb_entry_cmp_pfu_biu_req_addr[13:6]);
//==========================================================
//                 Flush dest_vld/Pop signal
//==========================================================
//req_biu_success && !cmit will cancel dest_vld
xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH)) 
x_lsu_ck_flush_compare_rb_entry_iid (
  .x_iid0                    (rtu_ck_flush_iid[IID_WIDTH-1:0]      ),
  .x_iid0_older              (rtu_ck_flush_iid_older_than_entry_iid  ),
  .x_iid1                    (rb_entry_iid[IID_WIDTH-1:0]         )
);
assign rb_entry_flush_clear   = (rtu_yy_xx_flush || (!rb_entry_cmit && rtu_ck_flush && rtu_ck_flush_iid_older_than_entry_iid))  //flush younger and no_cmit entry, ck_flush@LTL
                                    &&  (!rb_entry_cmit
                                        ||  rb_entry_boundary &&  !rb_entry_secd)
                                    &&  !rb_entry_mcic_req
                                ||  rtu_lsu_async_flush
                                    &&  !rb_entry_mcic_req;

//for rb depd wakeup                                    
assign rb_entry_wakeup_pop0 = rb_entry_vld
                              && rb_entry_depd0 
                              && (rb_entry_data_vld || rb_entry_flush_ff);
// assign rb_entry_wakeup_pop1 = rb_entry_vld
//                               && rb_entry_depd1 
//                               && (rb_entry_data_vld || rb_entry_flush_ff);
assign rb_entry_wakeup_pop2 = rb_entry_vld
                              && rb_entry_depd2 
                              && (rb_entry_data_vld || rb_entry_flush_ff);
assign rb_entry_wakeup_pop3 = rb_entry_vld
                              && rb_entry_depd3 
                              && (rb_entry_data_vld || rb_entry_flush_ff);
//==========================================================
//              Interface to other module
//==========================================================
//-----------------cmit data vld signal---------------------
//for rtu flush
assign rb_entry_cmit_data_not_vld = rb_entry_vld
                                    && rb_entry_cmit
                                    && rb_entry_dest_vld; 

assign rb_entry_memr_wait_resp    = (rb_entry_state[3:0] ==  WAIT_RESP)
                                    &&  !rb_entry_sync_fence;

// 

assign rb_entry_state_v[3:0]            = rb_entry_state[3:0];
assign rb_entry_memr_wait_resp_x        = rb_entry_memr_wait_resp;
assign rb_entry_vld_x                   = rb_entry_vld;
assign rb_entry_mcic_req_x              = rb_entry_mcic_req;
assign rb_entry_addr_v[`WK_PA_WIDTH-1:0]   = rb_entry_addr[`WK_PA_WIDTH-1:0];
assign rb_entry_vaddr_v[`WK_VA_WIDTH-1:12]  = rb_entry_vaddr[`WK_VA_WIDTH-1:12];
assign rb_entry_iid_v                   = rb_entry_iid;
assign rb_entry_sign_extend_x           = rb_entry_sign_extend;
assign rb_entry_preg_v                  = rb_entry_preg;
assign rb_entry_page_ca_x               = rb_entry_page_ca;
assign rb_entry_page_so_x               = rb_entry_page_so;
assign rb_entry_page_sec_x              = rb_entry_page_sec;
assign rb_entry_page_buf_x              = rb_entry_page_buf;
assign rb_entry_page_share_x            = rb_entry_page_share;
assign rb_entry_sync_x                  = rb_entry_sync;
assign rb_entry_fence_x                 = rb_entry_fence;
assign rb_entry_sync_fence_x            = rb_entry_sync_fence;
assign rb_entry_atomic_x                = rb_entry_atomic;
assign rb_entry_ldamo_x                 = rb_entry_ldamo;
assign rb_entry_st_x                    = rb_entry_st;
assign rb_entry_inst_size_v[2:0]        = rb_entry_inst_size[2:0];
assign rb_entry_depd0_x                 = rb_entry_depd0;
// assign rb_entry_depd1_x                 = rb_entry_depd1;
assign rb_entry_depd2_x                 = rb_entry_depd2;
assign rb_entry_depd3_x                 = rb_entry_depd3;
assign rb_entry_vreg_v                  = rb_entry_vreg;

assign rb_entry_inst_vfls_x             = rb_entry_inst_vfls;
assign rb_entry_vreg_sign_sel_x         = rb_entry_vreg_sign_sel;
assign rb_entry_priv_mode_v[1:0]        = rb_entry_priv_mode[1:0];
assign rb_entry_inst_vls_x              = rb_entry_inst_vls;
assign rb_entry_inst_fof_x              = rb_entry_inst_fof;
assign rb_entry_vmb_merge_vld_x         = rb_entry_vmb_merge_vld;
assign rb_entry_expt_vld_x              = rb_entry_expt_vld;
assign rb_entry_split_x                 = rb_entry_split;
assign rb_entry_data_v[127:0]           = rb_entry_data[127:0];
assign rb_entry_data1_v                 = rb_entry_data1;
assign rb_entry_data2_v                 = rb_entry_data2;
assign rb_entry_data3_v                 = rb_entry_data3;
assign rb_entry_element_size_v[1:0]     = rb_entry_element_size[1:0];
//assign rb_entry_vsew_v[1:0]             = rb_entry_vsew[1:0];// rvv1.0 @hcl
assign rb_entry_vmew_v[1:0]             = rb_entry_vmew[1:0];
assign rb_entry_vmop_v[1:0]             = rb_entry_vmop[1:0];
// assign rb_entry_vlmul_v[1:0]            = rb_entry_vlmul[1:0];
assign rb_entry_vlmul_v[2:0]            = rb_entry_vlmul[2:0];
assign rb_entry_vmb_id_v[VMBENTRY-1:0]  = rb_entry_vmb_id[VMBENTRY-1:0];
assign rb_entry_reg_bytes_vld_v[15:0]   = rb_entry_reg_bytes_vld[15:0];
assign rb_entry_reg_bytes_vld1_v[15:0]   = rb_entry_reg_bytes_vld1[15:0];
assign rb_entry_reg_bytes_vld2_v[15:0]   = rb_entry_reg_bytes_vld2[15:0];
assign rb_entry_reg_bytes_vld3_v[15:0]   = rb_entry_reg_bytes_vld3[15:0];
assign rb_entry_inst_us_x                = rb_entry_inst_us;
assign rb_entry_element_cnt_v[8:0]      = rb_entry_element_cnt[8:0];
assign rb_entry_setvl_val_v[8:0]        = rb_entry_setvl_val_final[8:0];
assign rb_entry_bus_err_x               = rb_entry_bus_err;
assign rb_entry_flush_clear_x           = rb_entry_flush_clear;
assign rb_entry_cmit_data_vld_x         = !rb_entry_cmit_data_not_vld;
// assign rb_entry_spec_fail_x             = rb_entry_spec_fail;

//-----------request--------------------
assign rb_entry_biu_req_x               = rb_entry_biu_req;
assign rb_entry_create_lfb_x            = rb_entry_create_lfb;
assign rb_entry_wb_cmplt_req_x          = rb_entry_wb_cmplt_req;
assign rb_entry_wb_data_req_x           = rb_entry_wb_data_req;
assign rb_entry_depd_wakeup0_x          = rb_entry_boundary_wakeup0 || rb_entry_wakeup_pop0;
// assign rb_entry_depd_wakeup1_x          = rb_entry_boundary_wakeup1 || rb_entry_wakeup_pop1;
assign rb_entry_depd_wakeup2_x          = rb_entry_boundary_wakeup2 || rb_entry_wakeup_pop2;
assign rb_entry_depd_wakeup3_x          = rb_entry_boundary_wakeup3 || rb_entry_wakeup_pop3;
assign rb_entry_biu_pe_req_x            = rb_entry_biu_pe_req;
assign rb_entry_biu_pe_req_gateclk_en_x = rb_entry_biu_pe_req_gateclk_en;
//-----------barrier inst---------------
assign rb_entry_fence_ld_vld_x          = rb_entry_fence_ld_vld;
//-----------hit idx--------------------
assign rb_entry_sq_pop_hit_idx_x        = rb_entry_sq_pop_hit_idx;
assign rb_entry_wmb_ce_hit_idx_x        = rb_entry_wmb_ce_hit_idx;
assign rb_entry_pfu_biu_req_hit_idx_x   = rb_entry_pfu_biu_req_hit_idx;
assign rb_entry_discard_vld0_x          = rb_entry_discard_vld0;
// assign rb_entry_discard_vld1_x          = rb_entry_discard_vld1;
assign rb_entry_discard_vld2_x          = rb_entry_discard_vld2;
assign rb_entry_discard_vld3_x          = rb_entry_discard_vld3;
assign rb_entry_rot_sel_v[15:0]         = rb_entry_rot_sel[15:0];
assign rb_entry_wb_data_pre_sel_x       = rb_entry_wb_data_pre_sel;
assign rb_entry_atomic_next_resp_x      = rb_entry_atomic_next_resp;

//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
always @(posedge rb_entry_create_up_clk or negedge cpurst_b)
begin
  if(~cpurst_b)
  begin
    rb_entry_data_check                         <= 1'b0; 
    rb_entry_halt_info[`TDT_MP_HINFO_WIDTH-1:0] <= {`TDT_MP_HINFO_WIDTH{1'b0}};
  end
  else if(rb_entry_ld0_merge_dp_vld | rb_entry_ld0_create_dp_vld_x)
  begin
    rb_entry_data_check                         <= lda0_rb_ex3_data_check; 
    rb_entry_halt_info[`TDT_MP_HINFO_WIDTH-1:0] <= dtu_lsu_ld0_addr_halt_info[`TDT_MP_HINFO_WIDTH-1:0];
  end
  else if(rb_entry_ls0_merge_dp_vld | rb_entry_ls0_create_dp_vld_x)
  begin
    rb_entry_data_check                         <= lsda0_rb_ex3_data_check; 
    rb_entry_halt_info[`TDT_MP_HINFO_WIDTH-1:0] <= dtu_lsu_ls0_addr_halt_info[`TDT_MP_HINFO_WIDTH-1:0];
  end
  else if(rb_entry_ls1_merge_dp_vld | rb_entry_ls1_create_dp_vld_x)
  begin
    rb_entry_data_check                         <= lsda1_rb_ex3_data_check; 
    rb_entry_halt_info[`TDT_MP_HINFO_WIDTH-1:0] <= dtu_lsu_ls1_addr_halt_info[`TDT_MP_HINFO_WIDTH-1:0];
  end
  else if(rb_entry_bus_err_set)
  begin
    rb_entry_data_check                         <= 1'b0; 
    rb_entry_halt_info[`TDT_MP_HINFO_WIDTH-1:0] <= rb_entry_halt_info[`TDT_MP_HINFO_WIDTH-1:0];
  end
  else if(ld0_data_halt_info_update_vld_x)
  begin
    rb_entry_data_check                         <= 1'b0; 
    rb_entry_halt_info[`TDT_MP_HINFO_WIDTH-1:0] <= dtu_lsu_ld0_data_halt_info[`TDT_MP_HINFO_WIDTH-1:0];
  end
  else if(ls0_data_halt_info_update_vld_x)
  begin
    rb_entry_data_check                         <= 1'b0; 
    rb_entry_halt_info[`TDT_MP_HINFO_WIDTH-1:0] <= dtu_lsu_ls0_data_halt_info[`TDT_MP_HINFO_WIDTH-1:0];
  end
  else if(ls1_data_halt_info_update_vld_x)
  begin
    rb_entry_data_check                         <= 1'b0; 
    rb_entry_halt_info[`TDT_MP_HINFO_WIDTH-1:0] <= dtu_lsu_ls1_data_halt_info[`TDT_MP_HINFO_WIDTH-1:0];
  end
end

assign rb_entry_data_check_x                         = rb_entry_data_check;
assign rb_entry_halt_info_v[`TDT_MP_HINFO_WIDTH-1:0] = rb_entry_halt_info[`TDT_MP_HINFO_WIDTH-1:0];
//==========================================================
//                  Risc-V Debug zdb End 
//==========================================================
endmodule
