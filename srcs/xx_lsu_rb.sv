//-----------------------------------------------------------------------------
// File          : xx_lsu_rb.sv
// Created       : 2024/10/17 (by Wen Jiahui)
// Last modified : 2024/10/17 (by Wen Jiahui)
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
// 2024/10/17 : Created
// 2024/XX/XX : 
//-----------------------------------------------------------------------------

//#
//# Module Declaration
//# ==================
//#
module xx_lsu_rb #(
    IID_WIDTH = 7,
    PREG = 7,
    VREG = 7,
    VMBENTRY = 8,
    RBENTRY = 32
)(
input logic [4  :0]                     biu_lsu_b_id,                  
input logic                             biu_lsu_b_vld,                 
input logic [255:0]                     biu_lsu_r_data,                
input logic [4  :0]                     biu_lsu_r_id,                  
input logic [3  :0]                     biu_lsu_r_resp,                
input logic                             biu_lsu_r_vld,                 
input logic                             bus_arb_rb_ar_grnt,            
input logic                             cp0_lsu_dcache_en,             
input logic                             cp0_lsu_icg_en,                
input logic [`VSTART_WIDTH-1  :0]                     cp0_lsu_vstart,                
input logic [1  :0]                     cp0_yy_priv_mode,              
input logic                             cpurst_b,                      
input logic                             forever_cpuclk,                
input logic [`WK_PA_WIDTH-1:0]          lda0_ex3_addr,                      
input logic [`WK_VA_WIDTH-1 :12]        lda0_ex3_vaddr,
input logic [1  :0]                     lda0_ex3_addr_5to4,                               
input logic                             lda0_ex3_boundary_after_mask,       
input logic                             lda0_ex3_boundary_after_mask_ff,    
input logic [15 :0]                     lda0_ex3_bytes_vld,                 
input logic [15 :0]                     lda0_ex3_bytes_vld1,                 
input logic [15 :0]                     lda0_ex3_bytes_vld2,                 
input logic [15 :0]                     lda0_ex3_bytes_vld3,                 
input logic [15 :0]                     lda0_ex3_data_rot_sel,              
input logic                             lda0_ex3_dcache_hit,                
input logic [8  :0]                     lda0_ex3_element_cnt,               
input logic [1  :0]                     lda0_ex3_element_size,              
input logic [7  :0]                     lda0_ex3_idx,                       
input logic [IID_WIDTH-1:0]             lda0_ex3_iid,                       
input logic                             lda0_ex3_inst_fof,                  
input logic  [2:0]                      lda0_ex3_inst_size,
input logic                             lda0_ex3_inst_vfls,                 
input logic                             lda0_ex3_inst_vls,                  
input logic                             lda0_ex3_mcic_borrow_mmu,           
input logic                             lda0_ex3_old,
input logic                             lda0_ex3_page_buf,                  
input logic                             lda0_ex3_page_ca,                   
input logic                             lda0_ex3_page_sec,                  
input logic                             lda0_ex3_page_share,                
input logic                             lda0_ex3_page_so,                   
input logic [PREG-1:0]                  lda0_ex3_preg,                      
input logic                             lda0_rb_ex3_atomic,                 
input logic                             lda0_rb_ex3_cmit,                   
input logic                             lda0_rb_ex3_cmplt_success,          
input logic                             lda0_rb_ex3_create_dp_vld,        
input logic                             lda0_rb_ex3_create_gateclk_en,    
input logic                             lda0_rb_ex3_create_judge_vld,
input logic                             lda0_rb_ex3_create_lfb,
input logic                             lda0_rb_ex3_create_vld,           
input logic [127:0]                     lda0_rb_ex3_data_ori,             
input logic [127:0]                     lda0_rb_ex3_data_ori1,             
input logic [127:0]                     lda0_rb_ex3_data_ori2,             
input logic [127:0]                     lda0_rb_ex3_data_ori3,             
input logic                             lda0_rb_ex3_data_vld,             
input logic                             lda0_rb_ex3_dest_vld,             
input logic                             lda0_rb_ex3_discard_grnt,         
input logic                             lda0_rb_ex3_expt_vld,             
input logic                             lda0_rb_ex3_ldamo,                
input logic                             lda0_rb_ex3_merge_dp_vld,         
input logic                             lda0_rb_ex3_merge_expt_vld,       
input logic                             lda0_rb_ex3_merge_gateclk_en,     
input logic                             lda0_rb_ex3_merge_vld,            
// input logic                             lda0_rb_ex3_ecc_mask,
input logic [15 :0]                     lda0_ex3_reg_bytes_vld,           
input logic [15 :0]                     lda0_ex3_reg_bytes_vld1,           
input logic [15 :0]                     lda0_ex3_reg_bytes_vld2,           
input logic [15 :0]                     lda0_ex3_reg_bytes_vld3,           
input logic                             lda0_ex3_inst_us,
input logic [8  :0]                     lda0_ex3_setvl_val,               
input logic                             lda0_ex3_sign_extend,             
input logic                             lda0_ex3_split,                   
// input logic [1  :0]                     lda0_ex3_vlmul,  
input logic [2  :0]           lda0_ex3_vlmul,  //pwh 1 for rvv1.0                  
input logic [VMBENTRY-1:0]              lda0_ex3_vmb_id,                  
input logic                             lda0_ex3_vmb_merge_vld,           
input logic [VREG-1:0]                  lda0_ex3_vreg,                    
input logic                             lda0_ex3_vreg_sign_sel,           
//input logic [1  :0]                     lda0_ex3_vsew,   //rvv1.0 @hcl 
input logic [1  :0]           lda0_ex3_vmew,   //rvv1.0 @hcl 
input logic [1  :0]           lda0_ex3_vmop,   //rvv1.0 @hcl                  
input logic                             lda0_ex3_spec_fail,            
input logic                             lwb_rb_ex3_cmplt_grnt,           
input logic                             lwb_rb_ex3_data_grnt,            
input logic                             lsu_biu_r_linefill_ready,
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
// input logic                   lda1_ex3_old,
// input logic                   lda1_ex3_page_buf,                  
// input logic                   lda1_ex3_page_ca,                   
// input logic                   lda1_ex3_page_sec,                  
// input logic                   lda1_ex3_page_share,                
// input logic                   lda1_ex3_page_so,                   
// input logic [PREG-1:0]        lda1_ex3_preg,                      
// input logic                   lda1_rb_ex3_atomic,                 
// input logic                   lda1_rb_ex3_cmit,                   
// input logic                   lda1_rb_ex3_cmplt_success,          
// input logic                   lda1_rb_ex3_create_dp_vld,        
// input logic                   lda1_rb_ex3_create_gateclk_en,    
// input logic                   lda1_rb_ex3_create_judge_vld,     
// input logic                   lda1_rb_ex3_create_lfb,
// input logic                   lda1_rb_ex3_create_vld,           
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
// input logic                   lda1_rb_ex3_ecc_mask,
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
input logic                             rtu_ck_flush,
input logic [IID_WIDTH-1:0]             rtu_ck_flush_iid,
input logic                             lfb_addr_full,                 
input logic                             lfb_rb_biu_req_hit_idx,        
input logic                             lfb_rb_ca_rready_grnt,         
input logic [4  :0]                     lfb_rb_create_id,              
input logic                             lfb_rb_nc_empty,               
input logic                             lfb_rb_nc_rready_grnt,         
input logic                             lm_already_snoop,              
input logic                             lsu_special_clk,               
input logic                             pad_yy_icg_scan_en,            
input logic [`WK_PA_WIDTH-1:0]          pfu_biu_req_addr,              
input logic                             rtu_lsu_async_flush,           
input logic                             rtu_yy_xx_commit0,               
input logic [IID_WIDTH-1:0]             rtu_yy_xx_commit0_iid,           
input logic                             rtu_yy_xx_commit1,               
input logic [IID_WIDTH-1:0]             rtu_yy_xx_commit1_iid,           
input logic                             rtu_yy_xx_commit2,               
input logic [IID_WIDTH-1:0]             rtu_yy_xx_commit2_iid,           
input logic                             rtu_yy_xx_commit3,               
input logic [IID_WIDTH-1:0]             rtu_yy_xx_commit3_iid,           
input logic                             rtu_yy_xx_commit4,               
input logic [IID_WIDTH-1:0]             rtu_yy_xx_commit4_iid,           
input logic                             rtu_yy_xx_commit5,               
input logic [IID_WIDTH-1:0]             rtu_yy_xx_commit5_iid,           
input logic                             rtu_yy_xx_commit6,               
input logic [IID_WIDTH-1:0]             rtu_yy_xx_commit6_iid,           
input logic                             rtu_yy_xx_commit7,               
input logic [IID_WIDTH-1:0]             rtu_yy_xx_commit7_iid,           
input logic                             rtu_yy_xx_flush,                 
input logic [`WK_PA_WIDTH-1:0]          sq_pop_addr,                   
input logic                             sq_pop_page_ca,                
input logic                             sq_pop_page_so,                
input logic                             lsda0_ex3_is_load,
input logic [`WK_PA_WIDTH-1:0]          lsda0_ex3_addr,
input logic [`WK_VA_WIDTH-1 :12]        lsda0_ex3_vaddr,
input logic [`WK_PA_WIDTH-1:0]          lsda0_ex3_ld_addr,
input logic [`WK_PA_WIDTH-1:0]          lsda0_ex3_st_addr,
input logic                             lsda0_ex3_dcache_hit,              
input logic                             lsda0_ex3_fence_inst,              
input logic [3  :0]                     lsda0_ex3_fence_mode,              
input logic [IID_WIDTH-1:0]             lsda0_ex3_iid,                     
input logic [IID_WIDTH-1:0]             lsda0_ex3_ld_iid,
input logic [IID_WIDTH-1:0]             lsda0_ex3_st_iid,
input logic [2  :0]                     lsda0_ex3_inst_size,               
input logic                             lsda0_ex3_old,                     
input logic                             lsda0_ex3_page_buf,                
input logic                             lsda0_ex3_page_ca,                 
input logic                             lsda0_ex3_ld_page_ca,
input logic                             lsda0_ex3_st_page_ca,
input logic                             lsda0_ex3_page_sec,                
input logic                             lsda0_ex3_page_share,              
input logic                             lsda0_ex3_page_so,                 
input logic                             lsda0_rb_ex3_cmit,                 
input logic                             lsda0_rb_ex3_create_dp_vld,        
input logic                             lsda0_rb_ex3_create_gateclk_en,    
input logic                             lsda0_rb_ex3_create_lfb,           
input logic                             lsda0_rb_ex3_create_vld,           
input logic                             lsda0_ex3_sync_fence,              
input logic                             lsda0_ex3_sync_inst,               
input logic [1:0]                       lsda0_ex3_addr_5to4,               
input logic                             lsda0_ex3_boundary_after_mask,       
input logic                             lsda0_ex3_boundary_after_mask_ff,    
input logic [15 :0]                     lsda0_ex3_bytes_vld,                 
input logic [15 :0]                     lsda0_ex3_bytes_vld1,                 
input logic [15 :0]                     lsda0_ex3_bytes_vld2,                 
input logic [15 :0]                     lsda0_ex3_bytes_vld3,                 
input logic [15 :0]                     lsda0_ex3_data_rot_sel,              
input logic [8  :0]                     lsda0_ex3_element_cnt,               
input logic [1  :0]                     lsda0_ex3_element_size,              
input logic [7  :0]                     lsda0_ex3_idx,                       
input logic                             lsda0_ex3_inst_fof,                  
input logic                             lsda0_ex3_inst_vfls,                 
input logic                             lsda0_ex3_inst_vls,                  
input logic                             lsda0_ex3_mcic_borrow_mmu,           
input logic [PREG-1:0]                  lsda0_ex3_preg,                      
input logic                             lsda0_rb_ex3_atomic,                 
input logic                             lsda0_rb_ex3_cmplt_success,          
input logic                             lsda0_rb_ex3_create_judge_vld,     
input logic [127:0]                     lsda0_rb_ex3_data_ori,             
input logic [127:0]                     lsda0_rb_ex3_data_ori1,             
input logic [127:0]                     lsda0_rb_ex3_data_ori2,             
input logic [127:0]                     lsda0_rb_ex3_data_ori3,             
input logic                             lsda0_rb_ex3_data_vld,             
input logic                             lsda0_rb_ex3_dest_vld,             
input logic                             lsda0_rb_ex3_discard_grnt,         
input logic                             lsda0_rb_ex3_expt_vld,             
input logic                             lsda0_rb_ex3_ldamo,                
input logic                             lsda0_rb_ex3_merge_dp_vld,         
input logic                             lsda0_rb_ex3_merge_expt_vld,       
input logic                             lsda0_rb_ex3_merge_gateclk_en,     
input logic                             lsda0_rb_ex3_merge_vld,            
// input logic                             lsda0_rb_ex3_ecc_mask,
input logic [15 :0]                     lsda0_ex3_reg_bytes_vld,           
input logic [15 :0]                     lsda0_ex3_reg_bytes_vld1,           
input logic [15 :0]                     lsda0_ex3_reg_bytes_vld2,           
input logic [15 :0]                     lsda0_ex3_reg_bytes_vld3,           
input logic                             lsda0_ex3_inst_us,
input logic [8  :0]                     lsda0_ex3_setvl_val,               
input logic                             lsda0_ex3_sign_extend,             
input logic                             lsda0_ex3_split,                   
// input logic [1  :0]                     lsda0_ex3_vlmul,    
input logic [2  :0]           lsda0_ex3_vlmul,  //pwh 2 for rvv1.0              
input logic [VMBENTRY-1:0]              lsda0_ex3_vmb_id,                  
input logic                             lsda0_ex3_vmb_merge_vld,           
input logic [VREG-1:0]                  lsda0_ex3_vreg,                    
input logic                             lsda0_ex3_vreg_sign_sel,           
//input logic [1  :0]                     lsda0_ex3_vsew,  //rvv1.0@hcl  
input logic [1  :0]           lsda0_ex3_vmew,  //rvv1.0@hcl
input logic [1  :0]           lsda0_ex3_vmop,  //rvv1.0@hcl                
input logic                             lsda0_ex3_spec_fail,            
input logic                             lsda1_ex3_is_load,
input logic [`WK_PA_WIDTH-1:0]          lsda1_ex3_addr,
input logic [`WK_VA_WIDTH-1 :12]        lsda1_ex3_vaddr,
input logic [`WK_PA_WIDTH-1:0]          lsda1_ex3_ld_addr,
input logic [`WK_PA_WIDTH-1:0]          lsda1_ex3_st_addr,
input logic                             lsda1_ex3_dcache_hit,              
input logic                             lsda1_ex3_fence_inst,              
input logic [3  :0]                     lsda1_ex3_fence_mode,              
input logic [IID_WIDTH-1:0]             lsda1_ex3_iid,                     
input logic [IID_WIDTH-1:0]             lsda1_ex3_ld_iid,
input logic [IID_WIDTH-1:0]             lsda1_ex3_st_iid,
input logic [2  :0]                     lsda1_ex3_inst_size,               
input logic                             lsda1_ex3_old,                     
input logic                             lsda1_ex3_page_buf,                
input logic                             lsda1_ex3_page_ca,                 
input logic                             lsda1_ex3_ld_page_ca,
input logic                             lsda1_ex3_st_page_ca,
input logic                             lsda1_ex3_page_sec,                
input logic                             lsda1_ex3_page_share,              
input logic                             lsda1_ex3_page_so,                 
input logic                             lsda1_rb_ex3_cmit,                 
input logic                             lsda1_rb_ex3_create_dp_vld,        
input logic                             lsda1_rb_ex3_create_gateclk_en,    
input logic                             lsda1_rb_ex3_create_lfb,           
input logic                             lsda1_rb_ex3_create_vld,           
input logic                             lsda1_ex3_sync_fence,              
input logic                             lsda1_ex3_sync_inst,               
input logic [1:0]                       lsda1_ex3_addr_5to4,              
input logic                             lsda1_ex3_boundary_after_mask,       
input logic                             lsda1_ex3_boundary_after_mask_ff,    
input logic [15 :0]                     lsda1_ex3_bytes_vld,                 
input logic [15 :0]                     lsda1_ex3_bytes_vld1,                 
input logic [15 :0]                     lsda1_ex3_bytes_vld2,                 
input logic [15 :0]                     lsda1_ex3_bytes_vld3,                 
input logic [15 :0]                     lsda1_ex3_data_rot_sel,              
input logic [8  :0]                     lsda1_ex3_element_cnt,               
input logic [1  :0]                     lsda1_ex3_element_size,              
input logic [7  :0]                     lsda1_ex3_idx,                       
input logic                             lsda1_ex3_inst_fof,                  
input logic                             lsda1_ex3_inst_vfls,                 
input logic                             lsda1_ex3_inst_vls,                  
input logic                             lsda1_ex3_mcic_borrow_mmu,           
input logic [PREG-1:0]                  lsda1_ex3_preg,                      
input logic                             lsda1_rb_ex3_atomic,                 
input logic                             lsda1_rb_ex3_cmplt_success,          
input logic                             lsda1_rb_ex3_create_judge_vld,     
input logic [127:0]                     lsda1_rb_ex3_data_ori,             
input logic [127:0]                     lsda1_rb_ex3_data_ori1,             
input logic [127:0]                     lsda1_rb_ex3_data_ori2,             
input logic [127:0]                     lsda1_rb_ex3_data_ori3,             
input logic                             lsda1_rb_ex3_data_vld,             
input logic                             lsda1_rb_ex3_dest_vld,             
input logic                             lsda1_rb_ex3_discard_grnt,         
input logic                             lsda1_rb_ex3_expt_vld,             
input logic                             lsda1_rb_ex3_ldamo,                
input logic                             lsda1_rb_ex3_merge_dp_vld,         
input logic                             lsda1_rb_ex3_merge_expt_vld,       
input logic                             lsda1_rb_ex3_merge_gateclk_en,     
input logic                             lsda1_rb_ex3_merge_vld,            
// input logic                             lsda1_rb_ex3_ecc_mask,
input logic [15 :0]                     lsda1_ex3_reg_bytes_vld,           
input logic [15 :0]                     lsda1_ex3_reg_bytes_vld1,           
input logic [15 :0]                     lsda1_ex3_reg_bytes_vld2,           
input logic [15 :0]                     lsda1_ex3_reg_bytes_vld3,           
input logic                             lsda1_ex3_inst_us,
input logic [8  :0]                     lsda1_ex3_setvl_val,               
input logic                             lsda1_ex3_sign_extend,             
input logic                             lsda1_ex3_split,                   
// input logic [1  :0]                     lsda1_ex3_vlmul,       
input logic [2  :0]           lsda1_ex3_vlmul,  //pwh 3 for rvv1.0          
input logic [VMBENTRY-1:0]              lsda1_ex3_vmb_id,                  
input logic                             lsda1_ex3_vmb_merge_vld,           
input logic [VREG-1:0]                  lsda1_ex3_vreg,                    
input logic                             lsda1_ex3_vreg_sign_sel,           
//input logic [1  :0]                     lsda1_ex3_vsew,  //rvv1.0@hcl 
input logic [1  :0]           lsda1_ex3_vmew,  //rvv1.0@hcl
input logic [1  :0]           lsda1_ex3_vmop,  //rvv1.0@hcl                 
input logic                             lsda1_ex3_spec_fail,     
input logic                             vb_rb_biu_req_hit_idx,         
input logic [`WK_PA_WIDTH-1:0]          wmb_ce_addr,                   
input logic                             wmb_ce_page_ca,                
input logic                             wmb_ce_page_so,                
input logic                             wmb_has_sync_fence,            
input logic                             wmb_rb_biu_req_hit_idx,        
input logic                             wmb_rb_so_pending,             
input logic                             wmb_sync_fence_biu_req_success, 
output logic [7  :0]                    lsu_had_rb_entry_fence,        
output logic [3  :0]                    lsu_had_rb_entry_state_0,      
output logic [3  :0]                    lsu_had_rb_entry_state_1,      
output logic [3  :0]                    lsu_had_rb_entry_state_2,      
output logic [3  :0]                    lsu_had_rb_entry_state_3,      
output logic [3  :0]                    lsu_had_rb_entry_state_4,      
output logic [3  :0]                    lsu_had_rb_entry_state_5,      
output logic [3  :0]                    lsu_had_rb_entry_state_6,      
output logic [3  :0]                    lsu_had_rb_entry_state_7,      
output logic                            lsu_has_fence,                 
output logic                            lsu_idu_no_fence,              
output logic                            lsu0_idu_exx_rb_not_full,           
// output logic                            lsu1_idu_exx_rb_not_full,           
output logic                            lsu2_idu_exx_rb_not_full,           
output logic                            lsu3_idu_exx_rb_not_full,           
output logic                            lsu_rtu_all_commit_ld_data_vld, 
output logic [`WK_PA_WIDTH-1:0]         rb_biu_ar_addr,                
output logic [1  :0]                    rb_biu_ar_bar,                 
output logic [1  :0]                    rb_biu_ar_burst,               
output logic [3  :0]                    rb_biu_ar_cache,               
output logic [1  :0]                    rb_biu_ar_domain,              
output logic                            rb_biu_ar_dp_req,              
output logic [4  :0]                    rb_biu_ar_id,                  
output logic [1  :0]                    rb_biu_ar_len,                 
output logic                            rb_biu_ar_lock,                
output logic [2  :0]                    rb_biu_ar_prot,                
output logic                            rb_biu_ar_req,                 
output logic                            rb_biu_ar_req_gateclk_en,      
output logic [2  :0]                    rb_biu_ar_size,                
output logic [3  :0]                    rb_biu_ar_snoop,               
output logic [3  :0]                    rb_biu_ar_user,                
output logic [`WK_PA_WIDTH-1:0]         rb_biu_req_addr,               
output logic [`WK_VA_WIDTH-1 :12]       rb_lfb_full_va,
output logic                            rb_biu_req_unmask,             
output logic                            rb_empty,                      
output logic                            rb_fence_ld,                   
output logic                            rb_has_pend,                   
output logic                            rb_lda0_ex3_full,                   
// output logic                            rb_lda1_ex3_full,                   
output logic                            rb_lda0_ex3_hit_idx,                   
// output logic                            rb_lda1_ex3_hit_idx,                   
output logic                            rb_lda0_ex3_merge_fail,                   
// output logic                            rb_lda1_ex3_merge_fail,                           
output logic                            rb_lwb_ex3_bus_err,              
output logic [`WK_PA_WIDTH-1:0]         rb_lwb_ex3_bus_err_addr,         
output logic                            rb_lwb_ex3_cmplt_req,            
output logic [VMBENTRY-1:0]             rb_lwb_ex3_cmplt_vmb_id,         
output logic                            rb_lwb_ex3_cmplt_vmb_merge_vld,  
output logic [127:0]                    rb_lwb_ex3_data,                 
output logic [127:0]                    rb_lwb_ex3_data1,                 
output logic [127:0]                    rb_lwb_ex3_data2,                 
output logic [127:0]                    rb_lwb_ex3_data3,                 
output logic [8  :0]                    rb_lwb_ex3_data_element_cnt,     
output logic [IID_WIDTH-1:0]            rb_lwb_ex3_data_iid,             
output logic                            rb_lwb_ex3_data_req,             
output logic [VMBENTRY-1:0]             rb_lwb_ex3_data_vmb_id,          
output logic                            rb_lwb_ex3_data_vmb_merge_vld,   
output logic [8  :0]                    rb_lwb_ex3_element_cnt,          
output logic                            rb_lwb_ex3_expt_gateclk,         
output logic                            rb_lwb_ex3_expt_vld,             
output logic [IID_WIDTH-1:0]            rb_lwb_ex3_iid,                  
output logic                            rb_lwb_ex3_inst_vfls,            
output logic                            rb_lwb_ex3_inst_vls,             
output logic [`WK_PA_WIDTH-1:0]         rb_lwb_ex3_mt_value,             
output logic [PREG-1:0]                 rb_lwb_ex3_preg,                 
output logic [3  :0]                    rb_lwb_ex3_preg_sign_sel,        
output logic [15 :0]                    rb_lwb_ex3_reg_bytes_vld,        
output logic [15 :0]                    rb_lwb_ex3_reg_bytes_vld1,        
output logic [15 :0]                    rb_lwb_ex3_reg_bytes_vld2,        
output logic [15 :0]                    rb_lwb_ex3_reg_bytes_vld3,        
output logic                            rb_lwb_ex3_inst_us,
output logic [1  :0]                    rb_lwb_ex3_vmew,
output logic                            rb_lwb_ex3_spec_fail,            
output logic [VREG-1:0]                 rb_lwb_ex3_vreg,                 
output logic [14 :0]                    rb_lwb_ex3_vreg_sign_sel,        
output logic                            rb_lwb_ex3_vsetvl,               
output logic                            rb_lwb_ex3_vstart_vld,           
output logic [`WK_PA_WIDTH-5 :0]        rb_lfb_addr_tto4,              
output logic                            rb_lfb_atomic,                 
output logic                            rb_lfb_create_dp_vld,          
output logic                            rb_lfb_create_gateclk_en,      
output logic                            rb_lfb_create_req,             
output logic                            rb_lfb_create_vld,             
output logic                            rb_lfb_depd,                   
output logic                            rb_lfb_depd_wakeup0,            
// output logic                            rb_lfb_depd_wakeup1,            
output logic                            rb_lfb_depd_wakeup2,            
output logic                            rb_lfb_depd_wakeup3,            
output logic                            rb_lfb_ldamo,                  
output logic                            rb_lfb_page_ca,                
output logic                            rb_lfb_page_share,             
output logic [4  :0]                    rb_lm_ar_id,                   
output logic                            rb_lm_atomic_next_resp,        
output logic                            rb_lm_wait_resp_dp_vld,        
output logic                            rb_lm_wait_resp_vld,           
output logic [4  :0]                    rb_mcic_ar_id,                 
output logic                            rb_mcic_biu_req_success,       
output logic                            rb_mcic_ecc_err,               
output logic                            rb_mcic_not_full,              
output logic [`WK_PA_WIDTH-1:0]         rb_pend_addr_f,                
output logic                            rb_pend_page_ca_f,             
output logic                            rb_pend_page_so_f,             
output logic                            rb_pfu_biu_req_hit_idx,        
output logic                            rb_pfu_nc_no_pending,          
output logic                            rb_sq_pop_hit_idx,             
output logic                            rb_lsda0_ex3_full,                 
output logic                            rb_lsda1_ex3_full,                 
output logic [1:0]                      rb_lsda0_ex3_hit_idx,              
output logic [1:0]                      rb_lsda1_ex3_hit_idx,              
output logic                            rb_lsda0_ex3_merge_fail,              
output logic                            rb_lsda1_ex3_merge_fail,              
output logic                            rb_wmb_ce_hit_idx,             
output logic                            rb_wmb_so_pending,
//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
input  logic [`TDT_MP_HINFO_WIDTH-1:0]  dtu_lsu_ld0_addr_halt_info,
input  logic [`TDT_MP_HINFO_WIDTH-1:0]  dtu_lsu_ls0_addr_halt_info,
input  logic [`TDT_MP_HINFO_WIDTH-1:0]  dtu_lsu_ls1_addr_halt_info,
input  logic [`TDT_MP_HINFO_WIDTH-1:0]  dtu_lsu_ld0_data_halt_info,
input  logic [`TDT_MP_HINFO_WIDTH-1:0]  dtu_lsu_ls0_data_halt_info,
input  logic [`TDT_MP_HINFO_WIDTH-1:0]  dtu_lsu_ls1_data_halt_info,
input  logic [RBENTRY-1:0]              ld0_data_halt_info_update_vld,
input  logic [RBENTRY-1:0]              ls0_data_halt_info_update_vld,
input  logic [RBENTRY-1:0]              ls1_data_halt_info_update_vld,
input  logic                            ld0_ld_da_rb_data_check,
input  logic                            ls0_ld_da_rb_data_check,
input  logic                            ls1_ld_da_rb_data_check,
output logic                            rb_ld_wb_data_check,
output logic [`TDT_MP_HINFO_WIDTH-1:0]  rb_ld_wb_data_halt_info,
output logic [RBENTRY-1:0]              rb_ld_wb_data_ptr,    
output logic [`TDT_MP_HINFO_WIDTH-1:0]  rb_ld_wb_halt_info_am,
output logic [2  :0]                    rb_ld_wb_inst_size 
//==========================================================
//                  Risc-V Debug zdb End
//==========================================================
);
localparam ENTRY4LD = 12;
localparam BIU_R_NC_ID       = 5'd24,
           BIU_R_SO_ID       = 5'd29,
           BIU_R_NC_ATOM_ID  = 5'd30,
           BIU_R_SYNC_FENCE_ID = 5'd31;
localparam S_BYTE              = 2'b00,
           HALF              = 2'b01,
           WORD              = 2'b10,
           DWORD             = 2'b11;
localparam OKAY              = 2'b00,
           EXOKAY            = 2'b01,
           SLVERR            = 2'b10,
           DECERR            = 2'b11;

// definition of clk_en
logic                                   rb_pe_clk_en;
logic                                   rb_pe_clk;
logic                                   rb_data_ptr_clk;
logic                                   rb_data_ptr_clk_en;
logic                                   rb_read_req_grnt_gateclk_en;
logic                                   rb_biu_req_flush_clear;
logic                                   rb_biu_pe_req_gateclk_en;
// definition of idfifo_so            
logic                                   rb_idfifo_so_clk_en;
logic [$clog2(RBENTRY)-1:0]             rb_biu_req_ptr_encode;
logic [RBENTRY-1:0]                     rb_biu_req_ptr;
logic                                   rb_idfifo_so_create_vld;
logic                                   rb_so_no_pending;
logic [RBENTRY-1:0]                     rb_entry_next_so_bypass;
logic                                   rb_idfifo_so_pop_vld;
logic                                   rb_r_so_id_hit;
// definition of biu attrs
logic                                   rb_biu_so_req_grnt;
logic                                   rb_biu_req_page_ca;
logic                                   rb_biu_req_page_so;
logic                                   rb_biu_req_page_sec;
logic                                   rb_biu_req_page_buf;
logic                                   rb_biu_req_page_share;
logic                                   rb_biu_req_sync_fence;
logic                                   rb_biu_req_sync;
logic                                   rb_biu_req_fence;
logic                                   rb_biu_req_atomic;
logic                                   rb_biu_req_ldamo;
logic                                   rb_biu_req_st;
logic [2:0]                             rb_biu_req_inst_size;
logic [1:0]                             rb_biu_req_priv_mode;
logic                                   rb_biu_req_page_ca_dcache_en;
logic                                   rb_biu_req_page_nc_atomic;
logic                                   rb_biu_req_inst_us;
logic                                   rb_biu_req_hit_idx;
logic                                   rb_biu_so_req_gateclk_en;
logic                                   rb_biu_so_recv_gateclk_en;
logic [255:0]                           biu_lsu_r_data_mask;
logic                                   rb_biu_req_create_lfb;
logic                                   rb_biu_pe_create_lfb;
logic                                   rb_biu_pe_req_permit;
logic                                   rb_biu_pe_req;
logic [RBENTRY-1:0]                     rb_biu_pe_req_ptr;
logic [`WK_PA_WIDTH-1:0]                rb_biu_pe_req_addr;
logic [`WK_VA_WIDTH-1:12]               rb_biu_pe_full_va;
logic                                   rb_biu_req_mcic_req;


logic                                   rb_nc_fifo_empty;
logic [3:0]                             rb_biu_ar_id_judge;
logic                                   rb_biu_ar_size_maintain;
logic                                   rb_biu_len3_sel;
logic                                   rb_atomic_readunique;
logic                                   rb_biu_share_refill;
logic                                   rb_biu_req_not_wait_fence;
logic [RBENTRY-1:0]                     rb_ld_wb_cmplt_ptr;
logic [8:0]                             rb_ld_wb_setvl_val;
//logic [1:0]                             rb_ld_wb_cmplt_vsew; //rvv1.0@hcl
logic [1:0]              rb_ld_wb_cmplt_vmew; //rvv1.0@hcl
logic [1:0]              rb_ld_wb_cmplt_vmop; //rvv1.0@hcl
// logic [1:0]                             rb_ld_wb_cmplt_vlmul;
logic [2:0]              rb_ld_wb_cmplt_vlmul;  //pwh 4 for rvv1.0
logic                                   rb_ld_wb_expt;
logic                                   rb_ld_wb_split;
logic                                   rb_ld_wb_cmplt_inst_vls;
logic                                   rb_ld_wb_cmplt_inst_fof;
logic                                   rb_ld_wb_fof_not_first;
logic [8:0]                             rb_ld_wb_vl_upval;
logic [RBENTRY-1:0]                     rb_ld_wb_data_ptr_pre;
logic                                   rb_ld_wb_data_req_unmask;
logic [1:0]                             rb_ld_wb_element_size;
//logic [1:0]                             rb_ld_wb_vsew;//rvv1.0 @hcl
logic [1:0]              rb_ld_wb_vmew;//rvv1.0 @hcl
logic [1:0]              rb_ld_wb_vmop;//rvv1.0 @hcl
logic [15:0]                            rb_ld_rot_sel;
logic                                   rb_ld_wb_sign_extend;
logic                                   rb_ld_wb_vreg_sign;
logic [127:0]                           rb_wb_data;
logic [127:0]                           rb_wb_data1;
logic [127:0]                           rb_wb_data2;
logic [127:0]                           rb_wb_data3;
logic [127:0]                           rb_wb_us_data0;
logic [127:0]                           rb_wb_data_unsettle;
logic [127:0]                           rb_ld_wb_data_128;
logic                                   rb_r_resp_ecc_err;
logic                                   rb_nc_ar_req;
logic [RBENTRY-1:0]                     rb_pend_entry;
logic                                   rb_pend_busy;
logic                                   rb_lfb_create_vld_unmask;

// logic                                   lda1_hit_idx_ori;
// logic                                   lda1_hit_idx_wrt_lda0;

logic                                   lsda0_hit_idx_ori;
logic                                   lsda0_ld_hit_idx_wrt_lda0;
logic                                   lsda0_st_hit_idx_wrt_lda0;
// logic                                   lsda0_ld_hit_idx_wrt_lda1;
// logic                                   lsda0_st_hit_idx_wrt_lda1;

logic                                   lsda1_hit_idx_ori;
logic                                   lsda1_ld_hit_idx_wrt_lda0;
// logic                                   lsda1_ld_hit_idx_wrt_lda1;
logic                                   lsda1_ld_hit_idx_wrt_lsda0;
logic                                   lsda1_st_hit_idx_wrt_lda0;
// logic                                   lsda1_st_hit_idx_wrt_lda1;
logic                                   lsda1_st_hit_idx_wrt_lsda0;

logic                                   rb_ld0_biu_pe_req;
// logic                                   rb_ld1_biu_pe_req;
logic                                   rb_ls0_biu_pe_req;
logic                                   rb_ls1_biu_pe_req;
// definition of entry inputs
logic [RBENTRY-1:0]                     rb_create_ptr0;
// logic [RBENTRY-1:0]                     rb_create_ptr1;
logic [RBENTRY-1:0]                     rb_create_ptr2;
logic [RBENTRY-1:0]                     rb_create_ptr3;
logic [RBENTRY-1:0]                     rb_create_ptr3_fix;
logic [RBENTRY-1:0]                     rb_entry_biu_id_gateclk_en;
logic [RBENTRY-1:0]                     rb_entry_biu_pe_req_grnt;
logic [RBENTRY-1:0]                     rb_entry_ld0_create_dp_vld;
logic [RBENTRY-1:0]                     rb_entry_ld0_create_gateclk_en;
logic [RBENTRY-1:0]                     rb_entry_ld0_create_vld;
// logic [RBENTRY-1:0]                     rb_entry_ld1_create_dp_vld;
// logic [RBENTRY-1:0]                     rb_entry_ld1_create_gateclk_en;
// logic [RBENTRY-1:0]                     rb_entry_ld1_create_vld;
// logic [RBENTRY-1:0]                     rb_entry_next_so_bypass;
logic [RBENTRY-1:0]                     rb_entry_read_req_grnt;
logic [RBENTRY-1:0]                     rb_entry_ls0_create_dp_vld;
logic [RBENTRY-1:0]                     rb_entry_ls0_create_gateclk_en;
logic [RBENTRY-1:0]                     rb_entry_ls0_create_vld;
logic [RBENTRY-1:0]                     rb_entry_ls1_create_dp_vld;
logic [RBENTRY-1:0]                     rb_entry_ls1_create_gateclk_en;
logic [RBENTRY-1:0]                     rb_entry_ls1_create_vld;
logic [RBENTRY-1:0]                     rb_entry_wb_cmplt_grnt;
logic [RBENTRY-1:0]                     rb_entry_wb_data_grnt;
logic                                   rb_ld0_biu_pe_req_grnt;
logic                                   rb_ls0_biu_pe_req_grnt;
logic                                   rb_ls1_biu_pe_req_grnt;
logic                                   rb_r_resp_err;
logic                                   rb_r_resp_okay;
logic                                   rb_ready_all_req_biu_success;
logic                                   rb_ready_ld_req_biu_success;
logic [RBENTRY-1:0][`WK_PA_WIDTH-1:0]               rb_entry_addr;
logic [RBENTRY-1:0][`WK_VA_WIDTH-1:12]  rb_entry_vaddr;
logic [RBENTRY-1:0]                     rb_entry_atomic_next_resp;
logic [RBENTRY-1:0]                     rb_entry_atomic;
logic [RBENTRY-1:0]                     rb_entry_biu_pe_req_gateclk_en;
logic [RBENTRY-1:0]                     rb_entry_biu_pe_req;
logic [RBENTRY-1:0]                     rb_entry_biu_req;
logic [RBENTRY-1:0]                     rb_entry_bus_err;
logic [RBENTRY-1:0]                     rb_entry_cmit_data_vld;
logic [RBENTRY-1:0]                     rb_entry_create_lfb;
logic [RBENTRY-1:0][127:0]              rb_entry_data;
logic [RBENTRY-1:0][127:0]              rb_entry_data1;
logic [RBENTRY-1:0][127:0]              rb_entry_data2;
logic [RBENTRY-1:0][127:0]              rb_entry_data3;
logic [RBENTRY-1:0]                     rb_entry_depd_wakeup0;
// logic [RBENTRY-1:0]                     rb_entry_depd_wakeup1;
logic [RBENTRY-1:0]                     rb_entry_depd_wakeup2;
logic [RBENTRY-1:0]                     rb_entry_depd_wakeup3;
logic [RBENTRY-1:0]                     rb_entry_depd0;
// logic [RBENTRY-1:0]                     rb_entry_depd1;
logic [RBENTRY-1:0]                     rb_entry_depd2;
logic [RBENTRY-1:0]                     rb_entry_depd3;
logic [RBENTRY-1:0]                     rb_entry_discard_vld0;
// logic [RBENTRY-1:0]                     rb_entry_discard_vld1;
logic [RBENTRY-1:0]                     rb_entry_discard_vld2;
logic [RBENTRY-1:0]                     rb_entry_discard_vld3;
logic [RBENTRY-1:0][8:0]                rb_entry_element_cnt;
logic [RBENTRY-1:0][1:0]                rb_entry_element_size;
logic [RBENTRY-1:0]                     rb_entry_expt_vld;
logic [RBENTRY-1:0]                     rb_entry_fence_ld_vld;
logic [RBENTRY-1:0]                     rb_entry_fence;
logic [RBENTRY-1:0]                     rb_entry_flush_clear;
logic [RBENTRY-1:0][IID_WIDTH-1:0]      rb_entry_iid;
logic [RBENTRY-1:0]                     rb_entry_inst_fof;
logic [RBENTRY-1:0][2:0]                rb_entry_inst_size;
logic [RBENTRY-1:0]                     rb_entry_inst_vfls;
logic [RBENTRY-1:0]                     rb_entry_inst_vls;
logic [RBENTRY-1:0]                     rb_entry_lda0_hit_idx;
// logic [RBENTRY-1:0]                     rb_entry_lda1_hit_idx;
// logic [RBENTRY-1:0]                     rb_entry_lsda0_hit_idx;
// logic [RBENTRY-1:0]                     rb_entry_lsda1_hit_idx;
logic [RBENTRY-1:0]                     rb_entry_lsda0_ld_hit_idx;
logic [RBENTRY-1:0]                     rb_entry_lsda0_st_hit_idx;
logic [RBENTRY-1:0]                     rb_entry_lsda1_ld_hit_idx;
logic [RBENTRY-1:0]                     rb_entry_lsda1_st_hit_idx;
logic [RBENTRY-1:0]                     rb_entry_ldamo;
logic [RBENTRY-1:0]                     rb_entry_mcic_req;
logic [RBENTRY-1:0]                     rb_entry_memr_wait_resp;
logic [RBENTRY-1:0]                     rb_entry_merge_fail0;
// logic [RBENTRY-1:0]                     rb_entry_merge_fail1;
logic [RBENTRY-1:0]                     rb_entry_merge_fail2;
logic [RBENTRY-1:0]                     rb_entry_merge_fail3;
logic [RBENTRY-1:0]                     rb_entry_page_buf;
logic [RBENTRY-1:0]                     rb_entry_page_ca;
logic [RBENTRY-1:0]                     rb_entry_page_sec;
logic [RBENTRY-1:0]                     rb_entry_page_share;
logic [RBENTRY-1:0]                     rb_entry_page_so;
logic [RBENTRY-1:0]                     rb_entry_pfu_biu_req_hit_idx;
logic [RBENTRY-1:0][PREG-1:0]           rb_entry_preg;
logic [RBENTRY-1:0][1:0]                rb_entry_priv_mode;
logic [RBENTRY-1:0][15:0]               rb_entry_reg_bytes_vld;
logic [RBENTRY-1:0][15:0]               rb_entry_reg_bytes_vld1;
logic [RBENTRY-1:0][15:0]               rb_entry_reg_bytes_vld2;
logic [RBENTRY-1:0][15:0]               rb_entry_reg_bytes_vld3;
logic [RBENTRY-1:0]                     rb_entry_inst_us;
logic [RBENTRY-1:0][15:0]               rb_entry_rot_sel;
logic [RBENTRY-1:0][8:0]                rb_entry_setvl_val;
logic [RBENTRY-1:0]                     rb_entry_sign_extend;
logic [RBENTRY-1:0]                     rb_entry_spec_fail;
logic [RBENTRY-1:0]                     rb_entry_split;
logic [RBENTRY-1:0]                     rb_entry_sq_pop_hit_idx;
logic [RBENTRY-1:0]                     rb_entry_st;
logic [RBENTRY-1:0][3:0]                rb_entry_state;
logic [RBENTRY-1:0]                     rb_entry_sync_fence;
logic [RBENTRY-1:0]                     rb_entry_sync;
logic [RBENTRY-1:0]                     rb_entry_vld;
// logic [RBENTRY-1:0][1:0]                rb_entry_vlmul;
logic [RBENTRY-1:0][2:0]           rb_entry_vlmul;  //pwh 5 for rvv1.0
logic [RBENTRY-1:0][VMBENTRY-1:0]       rb_entry_vmb_id;
logic [RBENTRY-1:0]                     rb_entry_vmb_merge_vld;
logic [RBENTRY-1:0]                     rb_entry_vreg_sign_sel;
logic [RBENTRY-1:0][VREG-1:0]           rb_entry_vreg;
//logic [RBENTRY-1:0][1:0]                rb_entry_vsew; //rvv1.0@hcl
logic [RBENTRY-1:0][1:0]           rb_entry_vmew; //rvv1.0@hcl
logic [RBENTRY-1:0][1:0]           rb_entry_vmop; //rvv1.0@hcl
logic [RBENTRY-1:0]                     rb_entry_wb_cmplt_req;
logic [RBENTRY-1:0]                     rb_entry_wb_data_pre_sel;
logic [RBENTRY-1:0]                     rb_entry_wb_data_req;
logic [RBENTRY-1:0]                     rb_entry_wmb_ce_hit_idx;
// definitions for entry logic
logic [RBENTRY-1:0]                     rb_entry_all1s_low0;
logic [RBENTRY-1:0]                     rb_entry_all1s_high0;
logic [RBENTRY-1:0]                     rb_entry_all1s_low1;
logic [RBENTRY-1:0]                     rb_entry_all1s_high1;
logic                                   rb_full_mmu;
logic                                   rb_full_low;
logic                                   rb_full_high;
logic                                   rb_empty_less2_low;
logic                                   rb_empty_less3_low;
logic                                   rb_empty_less2_high;
logic                                   rb_empty_less3_high;
logic                                   rb_full;
logic                                   rb_empty_less2;
logic                                   rb_empty_less3;
logic                                   rb_empty_less4;
logic                                   rb_not_empty;
// logic                                   rb_empty;
logic                                   rb_create_ld0_success;
// logic                                   rb_create_ld1_success;
logic                                   rb_create_ls0_success;
logic                                   rb_create_ls1_success;
logic                                   rb_ready_ld_req_biu;
logic                                   rb_ready_req_biu;
logic                                   rb_has_sync_fence;
logic                                   lsu_has_fence_set;
logic                                   rb_pipe_biu_pe_req;
logic                                   rb_read_req_grnt;

//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
logic [RBENTRY-1:0]                          rb_entry_data_check;
logic [RBENTRY-1:0][`TDT_MP_HINFO_WIDTH-1:0] rb_entry_halt_info;
logic [`TDT_MP_HINFO_WIDTH-1:0]              rb_ld_wb_halt_info;
//==========================================================
//                  Risc-V Debug zdb End 
//==========================================================

// 
//==========================================================
//                 Instance of Gated Cell  
//==========================================================
//pop entry signal
assign rb_pe_clk_en   = rb_biu_req_unmask
                        ? (rb_read_req_grnt_gateclk_en
                              ||  rb_biu_req_flush_clear)
                        : (lda0_rb_ex3_create_gateclk_en
                          //  || lda1_rb_ex3_create_gateclk_en
                           || lsda0_rb_ex3_create_gateclk_en && lsda0_ex3_is_load
                           || lsda1_rb_ex3_create_gateclk_en && lsda1_ex3_is_load
                           ||  rb_biu_pe_req_gateclk_en);

gated_clk_cell  x_lsu_rb_pe_gated_clk (
  .clk_in             (lsu_special_clk   ),
  .clk_out            (rb_pe_clk         ),
  .external_en        (1'b0              ),
  .local_en           (rb_pe_clk_en      ),
  .module_en          (cp0_lsu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

gated_clk_cell  x_lsu_rb_data_ptr_gated_clk (
  .clk_in             (lsu_special_clk   ),
  .clk_out            (rb_data_ptr_clk   ),
  .external_en        (1'b0              ),
  .local_en           (rb_data_ptr_clk_en),
  .module_en          (cp0_lsu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

xx_lsu_idfifo_32 #(.IDFIFO_ENTRY(RBENTRY)) x_xx_lsu_rb_idfifo_so (
  .cp0_lsu_icg_en               (cp0_lsu_icg_en              ),
  .cpurst_b                     (cpurst_b                    ),
  .forever_cpuclk               (forever_cpuclk              ),
  .idfifo_clk_en                (rb_idfifo_so_clk_en         ),
  .idfifo_create_id             (rb_biu_req_ptr_encode       ),
  .idfifo_create_id_oh          (rb_biu_req_ptr              ),
  .idfifo_create_vld            (rb_idfifo_so_create_vld     ),
  .idfifo_empty                 (rb_so_no_pending            ),
  .idfifo_pop_id_oh             (rb_entry_next_so_bypass     ),
  .idfifo_pop_vld               (rb_idfifo_so_pop_vld        ),
  .pad_yy_icg_scan_en           (pad_yy_icg_scan_en          )
);

//-----------------------wires------------------------------
assign rb_idfifo_so_create_vld    = rb_biu_so_req_grnt;
assign rb_idfifo_so_pop_vld       = rb_r_so_id_hit;

//------------------gateclk---------------------------------
assign rb_biu_so_req_gateclk_en   = rb_biu_req_unmask
                                    &&  rb_biu_req_page_so
                                    &&  !rb_biu_req_sync_fence;
assign rb_biu_so_recv_gateclk_en  = rb_r_so_id_hit;
assign rb_idfifo_so_clk_en        = rb_biu_so_req_gateclk_en
                                    ||  rb_biu_so_recv_gateclk_en;

//------------------pending---------------------------------
assign rb_wmb_so_pending          = !rb_so_no_pending;

//-----------------biu req ptr------------------------------
// &Instance("wk_rtu_encode_8","x_lsu_rb_idfifo_so_req_ptr_encode"); @125
// change of RBENTRY
// xx_lsu_encode_32  x_lsu_rb_idfifo_so_req_ptr_encode (
//   .x_num                      (rb_biu_req_ptr_encode),
//   .x_num_expand               (rb_biu_req_ptr       )
// );
xx_lsu_encode #(.RBENTRY(RBENTRY)) x_lsu_rb_idfifo_so_req_ptr_encode(
  .x_num                      (rb_biu_req_ptr_encode),
  .x_num_expand               (rb_biu_req_ptr       )
);

// &Connect( .x_num          (rb_biu_req_ptr_encode[2:0]    ), @126
//           .x_num_expand   (rb_biu_req_ptr[7:0] )); @127

//-----------------biu data mask------------------------------
assign biu_lsu_r_data_mask[255:0] = biu_lsu_r_resp[1]
                                    ? 256'b0
                                    : biu_lsu_r_data[255:0]; 
                                      
generate
    for(genvar i=0; i<RBENTRY; i++) begin 
        xx_lsu_rb_entry #(
            .IID_WIDTH(IID_WIDTH),
            .PREG(PREG),
            .VREG(VREG),
            .VMBENTRY(VMBENTRY)
        )
        i_xx_lsu_rb_entry(
            .biu_lsu_b_id                     ( biu_lsu_b_id                     ),
            .biu_lsu_b_vld                    ( biu_lsu_b_vld                    ),
            .biu_lsu_r_data_mask              ( biu_lsu_r_data_mask              ),
            .biu_lsu_r_id                     ( biu_lsu_r_id                     ),
            .biu_lsu_r_vld                    ( biu_lsu_r_vld                    ),
            .cp0_lsu_icg_en                   ( cp0_lsu_icg_en                   ),
            .cp0_yy_priv_mode                 ( cp0_yy_priv_mode                 ),
            .cpurst_b                         ( cpurst_b                         ),
            .lda0_ex3_addr                    ( lda0_ex3_addr                    ),
            .lda0_ex3_vaddr                   ( lda0_ex3_vaddr                   ),
            .lda0_ex3_addr_5to4               ( lda0_ex3_addr_5to4               ),
            .lda0_ex3_boundary_after_mask     ( lda0_ex3_boundary_after_mask     ),
            .lda0_ex3_boundary_after_mask_ff  ( lda0_ex3_boundary_after_mask_ff  ),
            .lda0_ex3_bytes_vld               ( lda0_ex3_bytes_vld               ),
            .lda0_ex3_bytes_vld1              ( lda0_ex3_bytes_vld1              ),
            .lda0_ex3_bytes_vld2              ( lda0_ex3_bytes_vld2              ),
            .lda0_ex3_bytes_vld3              ( lda0_ex3_bytes_vld3              ),
            .lda0_ex3_data_rot_sel            ( lda0_ex3_data_rot_sel            ),
            .lda0_ex3_dcache_hit              ( lda0_ex3_dcache_hit              ),
            .lda0_ex3_element_cnt             ( lda0_ex3_element_cnt             ),
            .lda0_ex3_element_size            ( lda0_ex3_element_size            ),
            .lda0_ex3_idx                     ( lda0_ex3_idx                     ),
            .lda0_ex3_iid                     ( lda0_ex3_iid                     ),
            .lda0_ex3_inst_fof                ( lda0_ex3_inst_fof                ),
            .lda0_ex3_inst_size               ( lda0_ex3_inst_size               ),
            .lda0_ex3_inst_vfls               ( lda0_ex3_inst_vfls               ),
            .lda0_ex3_inst_vls                ( lda0_ex3_inst_vls                ),
            .lda0_ex3_mcic_borrow_mmu         ( lda0_ex3_mcic_borrow_mmu         ),
            .lda0_ex3_page_buf                ( lda0_ex3_page_buf                ),
            .lda0_ex3_page_ca                 ( lda0_ex3_page_ca                 ),
            .lda0_ex3_page_sec                ( lda0_ex3_page_sec                ),
            .lda0_ex3_page_share              ( lda0_ex3_page_share              ),
            .lda0_ex3_page_so                 ( lda0_ex3_page_so                 ),
            .lda0_ex3_preg                    ( lda0_ex3_preg                    ),
            .lda0_rb_ex3_atomic               ( lda0_rb_ex3_atomic               ),
            .lda0_rb_ex3_cmit                 ( lda0_rb_ex3_cmit                 ),
            .lda0_rb_ex3_cmplt_success        ( lda0_rb_ex3_cmplt_success        ),
            .lda0_rb_ex3_create_lfb           ( lda0_rb_ex3_create_lfb           ),
            .lda0_rb_ex3_data_ori             ( lda0_rb_ex3_data_ori             ),
            .lda0_rb_ex3_data_ori1            ( lda0_rb_ex3_data_ori1            ),
            .lda0_rb_ex3_data_ori2            ( lda0_rb_ex3_data_ori2            ),
            .lda0_rb_ex3_data_ori3            ( lda0_rb_ex3_data_ori3            ),
            .lda0_rb_ex3_data_vld             ( lda0_rb_ex3_data_vld             ),
            .lda0_rb_ex3_dest_vld             ( lda0_rb_ex3_dest_vld             ),
            .lda0_rb_ex3_discard_grnt         ( lda0_rb_ex3_discard_grnt         ),
            .lda0_rb_ex3_expt_vld             ( lda0_rb_ex3_expt_vld             ),
            .lda0_rb_ex3_ldamo                ( lda0_rb_ex3_ldamo                ),
            .lda0_rb_ex3_merge_dp_vld         ( lda0_rb_ex3_merge_dp_vld         ),
            .lda0_rb_ex3_merge_expt_vld       ( lda0_rb_ex3_merge_expt_vld       ),
            .lda0_rb_ex3_merge_gateclk_en     ( lda0_rb_ex3_merge_gateclk_en     ),
            .lda0_rb_ex3_merge_vld            ( lda0_rb_ex3_merge_vld            ),
            .lda0_ex3_reg_bytes_vld           ( lda0_ex3_reg_bytes_vld           ),
            .lda0_ex3_reg_bytes_vld1          ( lda0_ex3_reg_bytes_vld1          ),
            .lda0_ex3_reg_bytes_vld2          ( lda0_ex3_reg_bytes_vld2          ),
            .lda0_ex3_reg_bytes_vld3          ( lda0_ex3_reg_bytes_vld3          ),
            .lda0_ex3_inst_us                 ( lda0_ex3_inst_us                 ),
            .lda0_ex3_setvl_val               ( lda0_ex3_setvl_val               ),
            .lda0_ex3_sign_extend             ( lda0_ex3_sign_extend             ),
            .lda0_ex3_split                   ( lda0_ex3_split                   ),
            .lda0_ex3_vlmul                   ( lda0_ex3_vlmul                   ),
            .lda0_ex3_vmb_id                  ( lda0_ex3_vmb_id                  ),
            .lda0_ex3_vmb_merge_vld           ( lda0_ex3_vmb_merge_vld           ),
            .lda0_ex3_vreg                    ( lda0_ex3_vreg                    ),
            .lda0_ex3_vreg_sign_sel           ( lda0_ex3_vreg_sign_sel           ),
            //.lda0_ex3_vsew                    ( lda0_ex3_vsew                    ),//rvv1.0 @hcl
            .lda0_ex3_vmew                    ( lda0_ex3_vmew                    ),//rvv1.0 @hcl
            .lda0_ex3_vmop                    ( lda0_ex3_vmop                    ),//rvv1.0 @hcl
            .lda0_ex3_spec_fail               ( lda0_ex3_spec_fail               ),
            .lsu_biu_r_linefill_ready         ( lsu_biu_r_linefill_ready         ),
            // .lda1_ex3_addr                    ( lda1_ex3_addr                    ),
            // .lda1_ex3_addr_5to4               ( lda1_ex3_addr_5to4               ),
            // .lda1_ex3_boundary_after_mask     ( lda1_ex3_boundary_after_mask     ),
            // .lda1_ex3_boundary_after_mask_ff  ( lda1_ex3_boundary_after_mask_ff  ),
            // .lda1_ex3_bytes_vld               ( lda1_ex3_bytes_vld               ),
            // .lda1_ex3_data_rot_sel            ( lda1_ex3_data_rot_sel            ),
            // .lda1_ex3_dcache_hit              ( lda1_ex3_dcache_hit              ),
            // .lda1_ex3_element_cnt             ( lda1_ex3_element_cnt             ),
            // .lda1_ex3_element_size            ( lda1_ex3_element_size            ),
            // .lda1_ex3_idx                     ( lda1_ex3_idx                     ),
            // .lda1_ex3_iid                     ( lda1_ex3_iid                     ),
            // .lda1_ex3_inst_fof                ( lda1_ex3_inst_fof                ),
            // .lda1_ex3_inst_size               ( lda1_ex3_inst_size               ),
            // .lda1_ex3_inst_vfls               ( lda1_ex3_inst_vfls               ),
            // .lda1_ex3_inst_vls                ( lda1_ex3_inst_vls                ),
            // .lda1_ex3_mcic_borrow_mmu         ( lda1_ex3_mcic_borrow_mmu         ),
            // .lda1_ex3_page_buf                ( lda1_ex3_page_buf                ),
            // .lda1_ex3_page_ca                 ( lda1_ex3_page_ca                 ),
            // .lda1_ex3_page_sec                ( lda1_ex3_page_sec                ),
            // .lda1_ex3_page_share              ( lda1_ex3_page_share              ),
            // .lda1_ex3_page_so                 ( lda1_ex3_page_so                 ),
            // .lda1_ex3_preg                    ( lda1_ex3_preg                    ),
            // .lda1_rb_ex3_atomic               ( lda1_rb_ex3_atomic               ),
            // .lda1_rb_ex3_cmit                 ( lda1_rb_ex3_cmit                 ),
            // .lda1_rb_ex3_cmplt_success        ( lda1_rb_ex3_cmplt_success        ),
            // .lda1_rb_ex3_create_lfb           ( lda1_rb_ex3_create_lfb           ),
            // .lda1_rb_ex3_data_ori             ( lda1_rb_ex3_data_ori             ),
            // .lda1_rb_ex3_data_vld             ( lda1_rb_ex3_data_vld             ),
            // .lda1_rb_ex3_dest_vld             ( lda1_rb_ex3_dest_vld             ),
            // .lda1_rb_ex3_discard_grnt         ( lda1_rb_ex3_discard_grnt         ),
            // .lda1_rb_ex3_expt_vld             ( lda1_rb_ex3_expt_vld             ),
            // .lda1_rb_ex3_ldamo                ( lda1_rb_ex3_ldamo                ),
            // .lda1_rb_ex3_merge_dp_vld         ( lda1_rb_ex3_merge_dp_vld         ),
            // .lda1_rb_ex3_merge_expt_vld       ( lda1_rb_ex3_merge_expt_vld       ),
            // .lda1_rb_ex3_merge_gateclk_en     ( lda1_rb_ex3_merge_gateclk_en     ),
            // .lda1_rb_ex3_merge_vld            ( lda1_rb_ex3_merge_vld            ),
            // .lda1_ex3_reg_bytes_vld           ( lda1_ex3_reg_bytes_vld           ),
            // .lda1_ex3_setvl_val               ( lda1_ex3_setvl_val               ),
            // .lda1_ex3_sign_extend             ( lda1_ex3_sign_extend             ),
            // .lda1_ex3_split                   ( lda1_ex3_split                   ),
            // .lda1_ex3_vlmul                   ( lda1_ex3_vlmul                   ),
            // .lda1_ex3_vmb_id                  ( lda1_ex3_vmb_id                  ),
            // .lda1_ex3_vmb_merge_vld           ( lda1_ex3_vmb_merge_vld           ),
            // .lda1_ex3_vreg                    ( lda1_ex3_vreg                    ),
            // .lda1_ex3_vreg_sign_sel           ( lda1_ex3_vreg_sign_sel           ),
            // .lda1_ex3_vsew                    ( lda1_ex3_vsew                    ),
            // .lda1_ex3_spec_fail               ( lda1_ex3_spec_fail               ),
            .lm_already_snoop                 ( lm_already_snoop                 ),
            .lsu_has_fence                    ( lsu_has_fence                    ),
            .lsu_special_clk                  ( lsu_special_clk                  ),
            .pad_yy_icg_scan_en               ( pad_yy_icg_scan_en               ),
            .pfu_biu_req_addr                 ( pfu_biu_req_addr                 ),
            .rb_biu_ar_id                     ( rb_biu_ar_id                     ),
            .rb_create_ptr0_x                 ( rb_create_ptr0[i]                ),
            // .rb_create_ptr1_x                 ( rb_create_ptr1[i]                ),
            .rb_create_ptr2_x                 ( rb_create_ptr2[i]                ),
            .rb_create_ptr3_x                 ( rb_create_ptr3_fix[i]                ),
            .rb_entry_biu_id_gateclk_en_x     ( rb_entry_biu_id_gateclk_en[i]    ),
            .rb_entry_biu_pe_req_grnt_x       ( rb_entry_biu_pe_req_grnt[i]      ),
            .rb_entry_ld0_create_dp_vld_x     ( rb_entry_ld0_create_dp_vld[i]    ),
            .rb_entry_ld0_create_gateclk_en_x ( rb_entry_ld0_create_gateclk_en[i]),
            .rb_entry_ld0_create_vld_x        ( rb_entry_ld0_create_vld[i]       ),
            // .rb_entry_ld1_create_dp_vld_x     ( rb_entry_ld1_create_dp_vld[i]    ),
            // .rb_entry_ld1_create_gateclk_en_x ( rb_entry_ld1_create_gateclk_en[i]),
            // .rb_entry_ld1_create_vld_x        ( rb_entry_ld1_create_vld[i]       ),
            .rb_entry_next_so_bypass_x        ( rb_entry_next_so_bypass[i]       ),
            .rb_entry_read_req_grnt_x         ( rb_entry_read_req_grnt[i]        ),
            .rb_entry_ls0_create_dp_vld_x     ( rb_entry_ls0_create_dp_vld[i]    ),
            .rb_entry_ls0_create_gateclk_en_x ( rb_entry_ls0_create_gateclk_en[i]),
            .rb_entry_ls0_create_vld_x        ( rb_entry_ls0_create_vld[i]       ),
            .rb_entry_ls1_create_dp_vld_x     ( rb_entry_ls1_create_dp_vld[i]    ),
            .rb_entry_ls1_create_gateclk_en_x ( rb_entry_ls1_create_gateclk_en[i]),
            .rb_entry_ls1_create_vld_x        ( rb_entry_ls1_create_vld[i]       ),
            .rb_entry_wb_cmplt_grnt_x         ( rb_entry_wb_cmplt_grnt[i]        ),
            .rb_entry_wb_data_grnt_x          ( rb_entry_wb_data_grnt[i]         ),
            .rb_fence_ld                      ( rb_fence_ld                      ),
            .rb_ld0_biu_pe_req_grnt           ( rb_ld0_biu_pe_req_grnt           ),
            .rb_ls0_biu_pe_req_grnt           ( rb_ls0_biu_pe_req_grnt           ),
            .rb_ls1_biu_pe_req_grnt           ( rb_ls1_biu_pe_req_grnt           ),
            .rb_r_resp_err                    ( rb_r_resp_err                    ),
            .rb_r_resp_okay                   ( rb_r_resp_okay                   ),
            .rb_ready_all_req_biu_success     ( rb_ready_all_req_biu_success     ),
            .rb_ready_ld_req_biu_success      ( rb_ready_ld_req_biu_success      ),
            .rtu_lsu_async_flush              ( rtu_lsu_async_flush              ),
            .rtu_yy_xx_commit0                ( rtu_yy_xx_commit0                ),
            .rtu_yy_xx_commit0_iid            ( rtu_yy_xx_commit0_iid            ),
            .rtu_yy_xx_commit1                ( rtu_yy_xx_commit1                ),
            .rtu_yy_xx_commit1_iid            ( rtu_yy_xx_commit1_iid            ),
            .rtu_yy_xx_commit2                ( rtu_yy_xx_commit2                ),
            .rtu_yy_xx_commit2_iid            ( rtu_yy_xx_commit2_iid            ),
            .rtu_yy_xx_commit3                ( rtu_yy_xx_commit3                ),
            .rtu_yy_xx_commit3_iid            ( rtu_yy_xx_commit3_iid            ),
            .rtu_yy_xx_commit4                ( rtu_yy_xx_commit4                ),
            .rtu_yy_xx_commit4_iid            ( rtu_yy_xx_commit4_iid            ),
            .rtu_yy_xx_commit5                ( rtu_yy_xx_commit5                ),
            .rtu_yy_xx_commit5_iid            ( rtu_yy_xx_commit5_iid            ),
            .rtu_yy_xx_commit6                ( rtu_yy_xx_commit6                ),
            .rtu_yy_xx_commit6_iid            ( rtu_yy_xx_commit6_iid            ),
            .rtu_yy_xx_commit7                ( rtu_yy_xx_commit7                ),
            .rtu_yy_xx_commit7_iid            ( rtu_yy_xx_commit7_iid            ),
            .rtu_yy_xx_flush                  ( rtu_yy_xx_flush                  ),
            .rtu_ck_flush                     ( rtu_ck_flush                     ),
            .rtu_ck_flush_iid                 ( rtu_ck_flush_iid                 ),
            .sq_pop_addr                      ( sq_pop_addr                      ),
            .sq_pop_page_ca                   ( sq_pop_page_ca                   ),
            .sq_pop_page_so                   ( sq_pop_page_so                   ),
            .lsda0_ex3_is_load                ( lsda0_ex3_is_load                ),
            .lsda0_ex3_fence_inst             ( lsda0_ex3_fence_inst             ),
            .lsda0_ex3_fence_mode             ( lsda0_ex3_fence_mode             ),
            .lsda0_ex3_sync_inst              ( lsda0_ex3_sync_inst              ),
            .lsda0_ex3_addr                   ( lsda0_ex3_addr                   ),
            .lsda0_ex3_vaddr                  ( lsda0_ex3_vaddr                  ),
            .lsda0_ex3_ld_addr                ( lsda0_ex3_ld_addr                ), // wjh@202502 timing
            .lsda0_ex3_st_addr                ( lsda0_ex3_st_addr                ), // wjh@202502 timing
            .lsda0_ex3_addr_5to4              ( lsda0_ex3_addr_5to4              ),
            .lsda0_ex3_boundary_after_mask    ( lsda0_ex3_boundary_after_mask    ),
            .lsda0_ex3_boundary_after_mask_ff ( lsda0_ex3_boundary_after_mask_ff ),
            .lsda0_ex3_bytes_vld              ( lsda0_ex3_bytes_vld              ),
            .lsda0_ex3_bytes_vld1             ( lsda0_ex3_bytes_vld1             ),
            .lsda0_ex3_bytes_vld2             ( lsda0_ex3_bytes_vld2             ),
            .lsda0_ex3_bytes_vld3             ( lsda0_ex3_bytes_vld3             ),
            .lsda0_ex3_data_rot_sel           ( lsda0_ex3_data_rot_sel           ),
            .lsda0_ex3_dcache_hit             ( lsda0_ex3_dcache_hit             ),
            .lsda0_ex3_element_cnt            ( lsda0_ex3_element_cnt            ),
            .lsda0_ex3_element_size           ( lsda0_ex3_element_size           ),
            .lsda0_ex3_idx                    ( lsda0_ex3_idx                    ),
            .lsda0_ex3_iid                    ( lsda0_ex3_iid                    ),
            .lsda0_ex3_ld_iid                 ( lsda0_ex3_ld_iid                 ), // wjh@202502 timing
            .lsda0_ex3_st_iid                 ( lsda0_ex3_st_iid                 ), // wjh@202502 timing
            .lsda0_ex3_inst_fof               ( lsda0_ex3_inst_fof               ),
            .lsda0_ex3_inst_size              ( lsda0_ex3_inst_size              ),
            .lsda0_ex3_inst_vfls              ( lsda0_ex3_inst_vfls              ),
            .lsda0_ex3_inst_vls               ( lsda0_ex3_inst_vls               ),
            .lsda0_ex3_mcic_borrow_mmu        ( lsda0_ex3_mcic_borrow_mmu        ),
            .lsda0_ex3_page_buf               ( lsda0_ex3_page_buf               ),
            .lsda0_ex3_page_ca                ( lsda0_ex3_page_ca                ),
            .lsda0_ex3_ld_page_ca             ( lsda0_ex3_ld_page_ca             ), // wjh@202502 timing
            .lsda0_ex3_st_page_ca             ( lsda0_ex3_st_page_ca             ), // wjh@202502 timing
            .lsda0_ex3_page_sec               ( lsda0_ex3_page_sec               ),
            .lsda0_ex3_page_share             ( lsda0_ex3_page_share             ),
            .lsda0_ex3_page_so                ( lsda0_ex3_page_so                ),
            .lsda0_ex3_preg                   ( lsda0_ex3_preg                   ),
            .lsda0_rb_ex3_atomic              ( lsda0_rb_ex3_atomic              ),
            .lsda0_rb_ex3_cmit                ( lsda0_rb_ex3_cmit                ),
            .lsda0_rb_ex3_cmplt_success       ( lsda0_rb_ex3_cmplt_success       ),
            .lsda0_rb_ex3_create_lfb          ( lsda0_rb_ex3_create_lfb          ),
            .lsda0_rb_ex3_data_ori            ( lsda0_rb_ex3_data_ori            ),
            .lsda0_rb_ex3_data_ori1           ( lsda0_rb_ex3_data_ori1           ),
            .lsda0_rb_ex3_data_ori2           ( lsda0_rb_ex3_data_ori2           ),
            .lsda0_rb_ex3_data_ori3           ( lsda0_rb_ex3_data_ori3           ),
            .lsda0_rb_ex3_data_vld            ( lsda0_rb_ex3_data_vld            ),
            .lsda0_rb_ex3_dest_vld            ( lsda0_rb_ex3_dest_vld            ),
            .lsda0_rb_ex3_discard_grnt        ( lsda0_rb_ex3_discard_grnt        ),
            .lsda0_rb_ex3_expt_vld            ( lsda0_rb_ex3_expt_vld            ),
            .lsda0_rb_ex3_ldamo               ( lsda0_rb_ex3_ldamo               ),
            .lsda0_rb_ex3_merge_dp_vld        ( lsda0_rb_ex3_merge_dp_vld        ),
            .lsda0_rb_ex3_merge_expt_vld      ( lsda0_rb_ex3_merge_expt_vld      ),
            .lsda0_rb_ex3_merge_gateclk_en    ( lsda0_rb_ex3_merge_gateclk_en    ),
            .lsda0_rb_ex3_merge_vld           ( lsda0_rb_ex3_merge_vld           ),
            .lsda0_ex3_reg_bytes_vld          ( lsda0_ex3_reg_bytes_vld          ),
            .lsda0_ex3_reg_bytes_vld1         ( lsda0_ex3_reg_bytes_vld1         ),
            .lsda0_ex3_reg_bytes_vld2         ( lsda0_ex3_reg_bytes_vld2         ),
            .lsda0_ex3_reg_bytes_vld3         ( lsda0_ex3_reg_bytes_vld3         ),
            .lsda0_ex3_inst_us                ( lsda0_ex3_inst_us                ),
            .lsda0_ex3_setvl_val              ( lsda0_ex3_setvl_val              ),
            .lsda0_ex3_sign_extend            ( lsda0_ex3_sign_extend            ),
            .lsda0_ex3_split                  ( lsda0_ex3_split                  ),
            .lsda0_ex3_vlmul                  ( lsda0_ex3_vlmul                  ),
            .lsda0_ex3_vmb_id                 ( lsda0_ex3_vmb_id                 ),
            .lsda0_ex3_vmb_merge_vld          ( lsda0_ex3_vmb_merge_vld          ),
            .lsda0_ex3_vreg                   ( lsda0_ex3_vreg                   ),
            .lsda0_ex3_vreg_sign_sel          ( lsda0_ex3_vreg_sign_sel          ),
           // .lsda0_ex3_vsew                   ( lsda0_ex3_vsew                   ),//rvv1.0@hcl 
            .lsda0_ex3_vmew                   ( lsda0_ex3_vmew                   ),
            .lsda0_ex3_vmop                   ( lsda0_ex3_vmop                   ),
            .lsda0_ex3_spec_fail              ( lsda0_ex3_spec_fail              ),
            .lsda1_ex3_is_load                ( lsda1_ex3_is_load                ),
            .lsda1_ex3_fence_inst             ( lsda1_ex3_fence_inst             ),
            .lsda1_ex3_fence_mode             ( lsda1_ex3_fence_mode             ),
            .lsda1_ex3_sync_inst              ( lsda1_ex3_sync_inst              ),
            .lsda1_ex3_addr                   ( lsda1_ex3_addr                   ),
            .lsda1_ex3_vaddr                  ( lsda1_ex3_vaddr                  ),
            .lsda1_ex3_ld_addr                ( lsda1_ex3_ld_addr                ), // wjh@202502 timing
            .lsda1_ex3_st_addr                ( lsda1_ex3_st_addr                ), // wjh@202502 timing
            .lsda1_ex3_addr_5to4              ( lsda1_ex3_addr_5to4              ),
            .lsda1_ex3_boundary_after_mask    ( lsda1_ex3_boundary_after_mask    ),
            .lsda1_ex3_boundary_after_mask_ff ( lsda1_ex3_boundary_after_mask_ff ),
            .lsda1_ex3_bytes_vld              ( lsda1_ex3_bytes_vld              ),
            .lsda1_ex3_bytes_vld1             ( lsda1_ex3_bytes_vld1             ),
            .lsda1_ex3_bytes_vld2             ( lsda1_ex3_bytes_vld2             ),
            .lsda1_ex3_bytes_vld3             ( lsda1_ex3_bytes_vld3             ),
            .lsda1_ex3_data_rot_sel           ( lsda1_ex3_data_rot_sel           ),
            .lsda1_ex3_dcache_hit             ( lsda1_ex3_dcache_hit             ),
            .lsda1_ex3_element_cnt            ( lsda1_ex3_element_cnt            ),
            .lsda1_ex3_element_size           ( lsda1_ex3_element_size           ),
            .lsda1_ex3_idx                    ( lsda1_ex3_idx                    ),
            .lsda1_ex3_iid                    ( lsda1_ex3_iid                    ),
            .lsda1_ex3_ld_iid                 ( lsda1_ex3_ld_iid                 ), // wjh@202502 timing
            .lsda1_ex3_st_iid                 ( lsda1_ex3_st_iid                 ), // wjh@202502 timing
            .lsda1_ex3_inst_fof               ( lsda1_ex3_inst_fof               ),
            .lsda1_ex3_inst_size              ( lsda1_ex3_inst_size              ),
            .lsda1_ex3_inst_vfls              ( lsda1_ex3_inst_vfls              ),
            .lsda1_ex3_inst_vls               ( lsda1_ex3_inst_vls               ),
            .lsda1_ex3_mcic_borrow_mmu        ( lsda1_ex3_mcic_borrow_mmu        ),
            .lsda1_ex3_page_buf               ( lsda1_ex3_page_buf               ),
            .lsda1_ex3_page_ca                ( lsda1_ex3_page_ca                ),
            .lsda1_ex3_ld_page_ca             ( lsda1_ex3_ld_page_ca             ), // wjh@202502 timing
            .lsda1_ex3_st_page_ca             ( lsda1_ex3_st_page_ca             ), // wjh@202502 timing
            .lsda1_ex3_page_sec               ( lsda1_ex3_page_sec               ),
            .lsda1_ex3_page_share             ( lsda1_ex3_page_share             ),
            .lsda1_ex3_page_so                ( lsda1_ex3_page_so                ),
            .lsda1_ex3_preg                   ( lsda1_ex3_preg                   ),
            .lsda1_rb_ex3_atomic              ( lsda1_rb_ex3_atomic              ),
            .lsda1_rb_ex3_cmit                ( lsda1_rb_ex3_cmit                ),
            .lsda1_rb_ex3_cmplt_success       ( lsda1_rb_ex3_cmplt_success       ),
            .lsda1_rb_ex3_create_lfb          ( lsda1_rb_ex3_create_lfb          ),
            .lsda1_rb_ex3_data_ori            ( lsda1_rb_ex3_data_ori            ),
            .lsda1_rb_ex3_data_ori1           ( lsda1_rb_ex3_data_ori1           ),
            .lsda1_rb_ex3_data_ori2           ( lsda1_rb_ex3_data_ori2           ),
            .lsda1_rb_ex3_data_ori3           ( lsda1_rb_ex3_data_ori3           ),
            .lsda1_rb_ex3_data_vld            ( lsda1_rb_ex3_data_vld            ),
            .lsda1_rb_ex3_dest_vld            ( lsda1_rb_ex3_dest_vld            ),
            .lsda1_rb_ex3_discard_grnt        ( lsda1_rb_ex3_discard_grnt        ),
            .lsda1_rb_ex3_expt_vld            ( lsda1_rb_ex3_expt_vld            ),
            .lsda1_rb_ex3_ldamo               ( lsda1_rb_ex3_ldamo               ),
            .lsda1_rb_ex3_merge_dp_vld        ( lsda1_rb_ex3_merge_dp_vld        ),
            .lsda1_rb_ex3_merge_expt_vld      ( lsda1_rb_ex3_merge_expt_vld      ),
            .lsda1_rb_ex3_merge_gateclk_en    ( lsda1_rb_ex3_merge_gateclk_en    ),
            .lsda1_rb_ex3_merge_vld           ( lsda1_rb_ex3_merge_vld           ),
            .lsda1_ex3_reg_bytes_vld          ( lsda1_ex3_reg_bytes_vld          ),
            .lsda1_ex3_reg_bytes_vld1         ( lsda1_ex3_reg_bytes_vld1         ),
            .lsda1_ex3_reg_bytes_vld2         ( lsda1_ex3_reg_bytes_vld2         ),
            .lsda1_ex3_reg_bytes_vld3         ( lsda1_ex3_reg_bytes_vld3         ),
            .lsda1_ex3_inst_us                ( lsda1_ex3_inst_us                ),
            .lsda1_ex3_setvl_val              ( lsda1_ex3_setvl_val              ),
            .lsda1_ex3_sign_extend            ( lsda1_ex3_sign_extend            ),
            .lsda1_ex3_split                  ( lsda1_ex3_split                  ),
            .lsda1_ex3_vlmul                  ( lsda1_ex3_vlmul                  ),
            .lsda1_ex3_vmb_id                 ( lsda1_ex3_vmb_id                 ),
            .lsda1_ex3_vmb_merge_vld          ( lsda1_ex3_vmb_merge_vld          ),
            .lsda1_ex3_vreg                   ( lsda1_ex3_vreg                   ),
            .lsda1_ex3_vreg_sign_sel          ( lsda1_ex3_vreg_sign_sel          ),
            //.lsda1_ex3_vsew                   ( lsda1_ex3_vsew                   ),//rvv1.0@hcl
            .lsda1_ex3_vmew                   ( lsda1_ex3_vmew                   ),//rvv1.0@hcl
            .lsda1_ex3_vmop                   ( lsda1_ex3_vmop                   ),//rvv1.0@hcl
            .lsda1_ex3_spec_fail              ( lsda1_ex3_spec_fail              ),
            .wmb_ce_addr                      ( wmb_ce_addr                      ),
            .wmb_ce_page_ca                   ( wmb_ce_page_ca                   ),
            .wmb_ce_page_so                   ( wmb_ce_page_so                   ),
            .wmb_rb_so_pending                ( wmb_rb_so_pending                ),
            .wmb_sync_fence_biu_req_success   ( wmb_sync_fence_biu_req_success   ),
            .rb_entry_addr_v                  ( rb_entry_addr[i]                 ),
            .rb_entry_vaddr_v                 ( rb_entry_vaddr[i]                ),
            .rb_entry_atomic_next_resp_x      ( rb_entry_atomic_next_resp[i]     ),
            .rb_entry_atomic_x                ( rb_entry_atomic[i]               ),
            .rb_entry_biu_pe_req_gateclk_en_x ( rb_entry_biu_pe_req_gateclk_en[i]),
            .rb_entry_biu_pe_req_x            ( rb_entry_biu_pe_req[i]           ),
            .rb_entry_biu_req_x               ( rb_entry_biu_req[i]              ),
            .rb_entry_bus_err_x               ( rb_entry_bus_err[i]              ),
            .rb_entry_cmit_data_vld_x         ( rb_entry_cmit_data_vld[i]        ),
            .rb_entry_create_lfb_x            ( rb_entry_create_lfb[i]           ),
            .rb_entry_data_v                  ( rb_entry_data[i]                 ),
            .rb_entry_data1_v                 ( rb_entry_data1[i]                ),
            .rb_entry_data2_v                 ( rb_entry_data2[i]                ),
            .rb_entry_data3_v                 ( rb_entry_data3[i]                ),
            .rb_entry_depd_wakeup0_x          ( rb_entry_depd_wakeup0[i]         ),
            // .rb_entry_depd_wakeup1_x          ( rb_entry_depd_wakeup1[i]         ),
            .rb_entry_depd_wakeup2_x          ( rb_entry_depd_wakeup2[i]         ),
            .rb_entry_depd_wakeup3_x          ( rb_entry_depd_wakeup3[i]         ),
            .rb_entry_depd0_x                 ( rb_entry_depd0[i]                ),
            // .rb_entry_depd1_x                 ( rb_entry_depd1[i]                ),
            .rb_entry_depd2_x                 ( rb_entry_depd2[i]                ),
            .rb_entry_depd3_x                 ( rb_entry_depd3[i]                ),
            .rb_entry_discard_vld0_x          ( rb_entry_discard_vld0[i]         ),
            // .rb_entry_discard_vld1_x          ( rb_entry_discard_vld1[i]         ),
            .rb_entry_discard_vld2_x          ( rb_entry_discard_vld2[i]         ),
            .rb_entry_discard_vld3_x          ( rb_entry_discard_vld3[i]         ),
            .rb_entry_element_cnt_v           ( rb_entry_element_cnt[i]          ),
            .rb_entry_element_size_v          ( rb_entry_element_size[i]         ),
            .rb_entry_expt_vld_x              ( rb_entry_expt_vld[i]             ),
            .rb_entry_fence_ld_vld_x          ( rb_entry_fence_ld_vld[i]         ),
            .rb_entry_fence_x                 ( rb_entry_fence[i]                ),
            .rb_entry_flush_clear_x           ( rb_entry_flush_clear[i]          ),
            .rb_entry_iid_v                   ( rb_entry_iid[i]                  ),
            .rb_entry_inst_fof_x              ( rb_entry_inst_fof[i]              ),
            .rb_entry_inst_size_v             ( rb_entry_inst_size[i]             ),
            .rb_entry_inst_vfls_x             ( rb_entry_inst_vfls[i]            ),
            .rb_entry_inst_vls_x              ( rb_entry_inst_vls[i]             ),
            .rb_entry_lda0_hit_idx_x          ( rb_entry_lda0_hit_idx[i]         ),
            // .rb_entry_lda1_hit_idx_x          ( rb_entry_lda1_hit_idx[i]         ),
            // .rb_entry_lsda0_hit_idx_x         ( rb_entry_lsda0_hit_idx[i]        ),
            // .rb_entry_lsda1_hit_idx_x         ( rb_entry_lsda1_hit_idx[i]        ),
            .rb_entry_lsda0_ld_hit_idx_x      ( rb_entry_lsda0_ld_hit_idx[i]     ),
            .rb_entry_lsda0_st_hit_idx_x      ( rb_entry_lsda0_st_hit_idx[i]     ),
            .rb_entry_lsda1_ld_hit_idx_x      ( rb_entry_lsda1_ld_hit_idx[i]     ),
            .rb_entry_lsda1_st_hit_idx_x      ( rb_entry_lsda1_st_hit_idx[i]     ),
            .rb_entry_ldamo_x                 ( rb_entry_ldamo[i]                ),
            .rb_entry_mcic_req_x              ( rb_entry_mcic_req[i]             ),
            .rb_entry_memr_wait_resp_x        ( rb_entry_memr_wait_resp[i]       ),
            .rb_entry_merge_fail0_x           ( rb_entry_merge_fail0[i]          ),
            // .rb_entry_merge_fail1_x           ( rb_entry_merge_fail1[i]          ),
            .rb_entry_merge_fail2_x           ( rb_entry_merge_fail2[i]          ),
            .rb_entry_merge_fail3_x           ( rb_entry_merge_fail3[i]          ),
            .rb_entry_page_buf_x              ( rb_entry_page_buf[i]             ),
            .rb_entry_page_ca_x               ( rb_entry_page_ca[i]              ),
            .rb_entry_page_sec_x              ( rb_entry_page_sec[i]             ),
            .rb_entry_page_share_x            ( rb_entry_page_share[i]           ),
            .rb_entry_page_so_x               ( rb_entry_page_so[i]              ),
            .rb_entry_pfu_biu_req_hit_idx_x   ( rb_entry_pfu_biu_req_hit_idx[i]  ),
            .rb_entry_preg_v                  ( rb_entry_preg[i]                 ),
            .rb_entry_priv_mode_v             ( rb_entry_priv_mode[i]            ),
            .rb_entry_reg_bytes_vld_v         ( rb_entry_reg_bytes_vld[i]        ),
            .rb_entry_reg_bytes_vld1_v        ( rb_entry_reg_bytes_vld1[i]        ),
            .rb_entry_reg_bytes_vld2_v        ( rb_entry_reg_bytes_vld2[i]        ),
            .rb_entry_reg_bytes_vld3_v        ( rb_entry_reg_bytes_vld3[i]        ),
            .rb_entry_inst_us_x               ( rb_entry_inst_us[i]               ),
            .rb_entry_rot_sel_v               ( rb_entry_rot_sel[i]              ),
            .rb_entry_setvl_val_v             ( rb_entry_setvl_val[i]            ),
            .rb_entry_sign_extend_x           ( rb_entry_sign_extend[i]          ),
            .rb_entry_spec_fail_x             ( rb_entry_spec_fail[i]            ),
            .rb_entry_split_x                 ( rb_entry_split[i]                ),
            .rb_entry_sq_pop_hit_idx_x        ( rb_entry_sq_pop_hit_idx[i]       ),
            .rb_entry_st_x                    ( rb_entry_st[i]                   ),
            .rb_entry_state_v                 ( rb_entry_state[i]                ),
            .rb_entry_sync_fence_x            ( rb_entry_sync_fence[i]           ),
            .rb_entry_sync_x                  ( rb_entry_sync[i]                 ),
            .rb_entry_vld_x                   ( rb_entry_vld[i]                  ),
            .rb_entry_vlmul_v                 ( rb_entry_vlmul[i]                ),
            .rb_entry_vmb_id_v                ( rb_entry_vmb_id[i]               ),
            .rb_entry_vmb_merge_vld_x         ( rb_entry_vmb_merge_vld[i]        ),
            .rb_entry_vreg_sign_sel_x         ( rb_entry_vreg_sign_sel[i]        ),
            .rb_entry_vreg_v                  ( rb_entry_vreg[i]                 ),
            //.rb_entry_vsew_v                  ( rb_entry_vsew[i]                 ),
            .rb_entry_vmew_v                  ( rb_entry_vmew[i]                 ),
            .rb_entry_vmop_v                  ( rb_entry_vmop[i]                 ),
            .rb_entry_wb_cmplt_req_x          ( rb_entry_wb_cmplt_req[i]         ),
            .rb_entry_wb_data_pre_sel_x       ( rb_entry_wb_data_pre_sel[i]      ),
            .rb_entry_wb_data_req_x           ( rb_entry_wb_data_req[i]          ),
            .rb_entry_wmb_ce_hit_idx_x        ( rb_entry_wmb_ce_hit_idx[i]       ),
//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
            //input
            .dtu_lsu_ld0_addr_halt_info       ( dtu_lsu_ld0_addr_halt_info       ),
            .dtu_lsu_ls0_addr_halt_info       ( dtu_lsu_ls0_addr_halt_info       ),
            .dtu_lsu_ls1_addr_halt_info       ( dtu_lsu_ls1_addr_halt_info       ),
            .dtu_lsu_ld0_data_halt_info       ( dtu_lsu_ld0_data_halt_info       ),
            .dtu_lsu_ls0_data_halt_info       ( dtu_lsu_ls0_data_halt_info       ),
            .dtu_lsu_ls1_data_halt_info       ( dtu_lsu_ls1_data_halt_info       ),
            .lda0_rb_ex3_data_check           ( ld0_ld_da_rb_data_check          ),
            .lsda0_rb_ex3_data_check          ( ls0_ld_da_rb_data_check          ),
            .lsda1_rb_ex3_data_check          ( ls1_ld_da_rb_data_check          ),
            .ld0_data_halt_info_update_vld_x  ( ld0_data_halt_info_update_vld[i] ),
            .ls0_data_halt_info_update_vld_x  ( ls0_data_halt_info_update_vld[i] ),
            .ls1_data_halt_info_update_vld_x  ( ls1_data_halt_info_update_vld[i] ),
            //output
            .rb_entry_data_check_x            ( rb_entry_data_check[i]           ),
            .rb_entry_halt_info_v             ( rb_entry_halt_info[i]            )
//==========================================================
//                  Risc-V Debug zdb End 
//==========================================================
        );
    end 
endgenerate

// ENTRY4-1-th entry is reserved for mmu
// always_comb begin 
//     rb_create_ptr0[RBENTRY-1:1] = '0;
//     rb_create_ptr0[0]           = !rb_entry_vld[0];
//     rb_entry_all1s_low0         = '1;
//     for(int i=1; i< ENTRY4LD; i++) begin 
//         for(int j=0; j<i; j++) begin 
//             rb_entry_all1s_low0[i] = rb_entry_all1s_low0[i] & rb_entry_vld[j];
//         end 
//         rb_create_ptr0[i] = (rb_entry_vld[i]==1'b0) && (rb_entry_all1s_low0[i] == 1'b1);
//     end 
// end 


// always_comb begin 
//     rb_create_ptr1[RBENTRY-1:ENTRY4LD-1] = '0; 
//     rb_create_ptr1[ENTRY4LD-2]         = !rb_entry_vld[ENTRY4LD-2]; // EHTRY4LD-1-th is reserved for mmu, so count from ENTRY4LD-2
//     rb_create_ptr1[ENTRY4LD-3:0]       = '0;
//     rb_entry_all1s_high0               = '1;
//     for(int i=ENTRY4LD-3; i>=0; i--) begin 
//         for(int j = ENTRY4LD-2; j>i; j--) begin 
//             rb_entry_all1s_high0[i] = rb_entry_all1s_high0[i] & rb_entry_vld[j];
//         end 
//         rb_create_ptr1[i] = (rb_entry_vld[i]==1'b0) && (rb_entry_all1s_high0[i] == 1'b1);
//     end 
// end 

// always_comb begin 
//     rb_create_ptr2[ENTRY4LD-1:0] = '0;
//     rb_create_ptr2[RBENTRY-1:ENTRY4LD+1] = '0;
//     rb_create_ptr2[ENTRY4LD] = !rb_entry_vld[ENTRY4LD];
//     rb_entry_all1s_low1      = '1;
//     for(int i=ENTRY4LD+1; i<RBENTRY; i++) begin 
//         for(int j=ENTRY4LD; j< i; j++) begin 
//             rb_entry_all1s_low1[i] = rb_entry_all1s_low1[i] & rb_entry_vld[j];
//         end 
//         rb_create_ptr2[i] = (rb_entry_vld[i] == 1'b0) && (rb_entry_all1s_low1[i] == 1'b1);
//     end 
// end 

// always_comb begin 
//     rb_create_ptr3[RBENTRY-1] = !rb_entry_vld[RBENTRY-1];
//     rb_create_ptr3[RBENTRY-2:0] = '0;
//     rb_entry_all1s_high1 = '1;
//     for(int i=RBENTRY-2; i>= ENTRY4LD; i--) begin 
//         for(int j=RBENTRY-1; j>i; j--) begin 
//             rb_entry_all1s_high1[i] = rb_entry_all1s_high1[i] & rb_entry_vld[j];
//         end 
//         rb_create_ptr3[i] = (rb_entry_vld[i] == 1'b0) && (rb_entry_all1s_high1[i] == 1'b1);
//     end 
// end 
assign rb_create_ptr0[0] = ~rb_entry_vld[0];
generate
    for(genvar i=1; i<RBENTRY; i++)
        assign rb_create_ptr0[i] = ~rb_entry_vld[i] & (&(rb_entry_vld[i-1:0]));
endgenerate
// assign rb_create_ptr0[1] = ~rb_entry_vld[1] && rb_entry_vld[0];
// assign rb_create_ptr0[2] = ~rb_entry_vld[2] && &(rb_entry_vld[1:0]);
// assign rb_create_ptr0[3] = ~rb_entry_vld[3] && &(rb_entry_vld[2:0]);
// assign rb_create_ptr0[4] = ~rb_entry_vld[4] && &(rb_entry_vld[3:0]);
// assign rb_create_ptr0[5] = ~rb_entry_vld[5] && &(rb_entry_vld[4:0]);
// assign rb_create_ptr0[6] = ~rb_entry_vld[6] && &(rb_entry_vld[5:0]);
// assign rb_create_ptr0[7] = ~rb_entry_vld[7] && &(rb_entry_vld[6:0]);
// assign rb_create_ptr0[8] = ~rb_entry_vld[8] && &(rb_entry_vld[7:0]);
// assign rb_create_ptr0[9] = ~rb_entry_vld[9] && &(rb_entry_vld[8:0]);
// assign rb_create_ptr0[10] = ~rb_entry_vld[10] && &(rb_entry_vld[9:0]);
// assign rb_create_ptr0[11] = ~rb_entry_vld[11] && &(rb_entry_vld[10:0]);
// assign rb_create_ptr0[12] = ~rb_entry_vld[12] && &(rb_entry_vld[11:0]);
// assign rb_create_ptr0[13] = ~rb_entry_vld[13] && &(rb_entry_vld[12:0]);
// assign rb_create_ptr0[14] = ~rb_entry_vld[14] && &(rb_entry_vld[13:0]);
// assign rb_create_ptr0[15] = ~rb_entry_vld[15] && &(rb_entry_vld[14:0]);

assign rb_create_ptr2[RBENTRY-1] = 1'b0;
assign rb_create_ptr2[RBENTRY-2] = ~rb_entry_vld[RBENTRY-2];
generate 
    for(genvar i=RBENTRY-3; i>=0; i--)
        assign rb_create_ptr2[i] = ~rb_entry_vld[i] & (&(rb_entry_vld[RBENTRY-2:i+1]));
endgenerate

// assign rb_create_ptr2[13] = ~rb_entry_vld[13] && rb_entry_vld[14];
// assign rb_create_ptr2[12] = ~rb_entry_vld[12] && &(rb_entry_vld[14:13]);
// assign rb_create_ptr2[11] = ~rb_entry_vld[11] && &(rb_entry_vld[14:12]);
// assign rb_create_ptr2[10] = ~rb_entry_vld[10] && &(rb_entry_vld[14:11]);
// assign rb_create_ptr2[9] = ~rb_entry_vld[9] && &(rb_entry_vld[14:10]);
// assign rb_create_ptr2[8] = ~rb_entry_vld[8] && &(rb_entry_vld[14:9]);
// assign rb_create_ptr2[7] = ~rb_entry_vld[7] && &(rb_entry_vld[14:8]);
// assign rb_create_ptr2[6] = ~rb_entry_vld[6] && &(rb_entry_vld[14:7]);
// assign rb_create_ptr2[5] = ~rb_entry_vld[5] && &(rb_entry_vld[14:6]);
// assign rb_create_ptr2[4] = ~rb_entry_vld[4] && &(rb_entry_vld[14:5]);
// assign rb_create_ptr2[3] = ~rb_entry_vld[3] && &(rb_entry_vld[14:4]);
// assign rb_create_ptr2[2] = ~rb_entry_vld[2] && &(rb_entry_vld[14:3]);
// assign rb_create_ptr2[1] = ~rb_entry_vld[1] && &(rb_entry_vld[14:2]);
// assign rb_create_ptr2[0] = ~rb_entry_vld[0] && &(rb_entry_vld[14:1]);

assign rb_create_ptr3[RBENTRY-1] = 1'b0;
assign rb_create_ptr3[RBENTRY-2] = 1'b0;
generate
    for(genvar i=RBENTRY-3; i>=0; i--)
        assign rb_create_ptr3[i] = ~rb_entry_vld[i] & (&(rb_entry_vld[RBENTRY-2:i+1] | rb_create_ptr2[RBENTRY-2:i+1])) & (|(rb_create_ptr2[RBENTRY-2:i+1]));
endgenerate

// assign rb_create_ptr3[13] = ~rb_entry_vld[13] && &(rb_entry_vld[14]    | rb_create_ptr2[14])    && |(rb_create_ptr2[14]);
// assign rb_create_ptr3[12] = ~rb_entry_vld[12] && &(rb_entry_vld[14:13] | rb_create_ptr2[14:13]) && |(rb_create_ptr2[14:13]);
// assign rb_create_ptr3[11] = ~rb_entry_vld[11] && &(rb_entry_vld[14:12] | rb_create_ptr2[14:12]) && |(rb_create_ptr2[14:12]);
// assign rb_create_ptr3[10] = ~rb_entry_vld[10] && &(rb_entry_vld[14:11] | rb_create_ptr2[14:11]) && |(rb_create_ptr2[14:11]);
// assign rb_create_ptr3[9] = ~rb_entry_vld[9] && &(rb_entry_vld[14:10] | rb_create_ptr2[14:10]) && |(rb_create_ptr2[14:10]);
// assign rb_create_ptr3[8] = ~rb_entry_vld[8] && &(rb_entry_vld[14:9] | rb_create_ptr2[14:9]) && |(rb_create_ptr2[14:9]);
// assign rb_create_ptr3[7] = ~rb_entry_vld[7] && &(rb_entry_vld[14:8] | rb_create_ptr2[14:8]) && |(rb_create_ptr2[14:8]);
// assign rb_create_ptr3[6] = ~rb_entry_vld[6] && &(rb_entry_vld[14:7] | rb_create_ptr2[14:7]) && |(rb_create_ptr2[14:7]);
// assign rb_create_ptr3[5] = ~rb_entry_vld[5] && &(rb_entry_vld[14:6] | rb_create_ptr2[14:6]) && |(rb_create_ptr2[14:6]);
// assign rb_create_ptr3[4] = ~rb_entry_vld[4] && &(rb_entry_vld[14:5] | rb_create_ptr2[14:5]) && |(rb_create_ptr2[14:5]);
// assign rb_create_ptr3[3] = ~rb_entry_vld[3] && &(rb_entry_vld[14:4] | rb_create_ptr2[14:4]) && |(rb_create_ptr2[14:4]);
// assign rb_create_ptr3[2] = ~rb_entry_vld[2] && &(rb_entry_vld[14:3] | rb_create_ptr2[14:3]) && |(rb_create_ptr2[14:3]);
// assign rb_create_ptr3[1] = ~rb_entry_vld[1] && &(rb_entry_vld[14:2] | rb_create_ptr2[14:2]) && |(rb_create_ptr2[14:2]);
// assign rb_create_ptr3[0] = ~rb_entry_vld[0] && &(rb_entry_vld[14:1] | rb_create_ptr2[14:1]) && |(rb_create_ptr2[14:1]);



//------------------full signal-----------------------------
assign rb_full_mmu = &rb_entry_vld[RBENTRY-1:0];
assign rb_full     = &rb_entry_vld[RBENTRY-2:0];
// assign rb_empty_less2_low = &(rb_entry_vld[ENTRY4LD-2:0] | rb_create_ptr0[ENTRY4LD-2:0]);
// assign rb_empty_less3_low = &(rb_entry_vld[ENTRY4LD-2:0]
//                               | rb_create_ptr0[ENTRY4LD-2:0]
//                               | rb_create_ptr1[ENTRY4LD-2:0]);
assign rb_empty_less2 = &(rb_entry_vld[RBENTRY-2:0] | rb_create_ptr0[RBENTRY-2:0]);
assign rb_empty_less3 = &(rb_entry_vld[RBENTRY-2:0]
                   | rb_create_ptr0[RBENTRY-2:0]
                   | rb_create_ptr2[RBENTRY-2:0]);
assign rb_empty_less4 = &(rb_entry_vld[RBENTRY-2:0]
                   | rb_create_ptr0[RBENTRY-2:0]
                   | rb_create_ptr2[RBENTRY-2:0]
                   | rb_create_ptr3[RBENTRY-2:0]);
// assign rb_lda0_ex3_full = lda0_ex3_mcic_borrow_mmu ? rb_full_mmu : (rb_full_low || (!lda0_ex3_old && rb_empty_less2_low));
assign rb_lda0_ex3_full = lda0_ex3_mcic_borrow_mmu ? rb_full_mmu : (rb_full || (!lda0_ex3_old && rb_empty_less2));
// if one entry available, and the req is not old or lda0 is requesting for one entry, then full; as the only one should be reserved for the old, and lda0 has high priority
// if two entries available, and the req is not old and ld0 is requesting for one entry, then full for the same reason
// assign rb_lda1_ex3_full = rb_full_low
//                           || (!lda1_ex3_old || lda0_rb_ex3_create_judge_vld)
//                              && rb_empty_less2_low 
//                           || lda0_rb_ex3_create_judge_vld
//                              && !lda1_ex3_old
//                              && rb_empty_less3_low;

// assign rb_full_high = &rb_entry_vld[RBENTRY-1:ENTRY4LD];
// assign rb_empty_less2_high = &(rb_entry_vld[RBENTRY-1:ENTRY4LD] | rb_create_ptr2[RBENTRY-1:ENTRY4LD]);
// assign rb_empty_less3_high = &(rb_entry_vld[RBENTRY-1:ENTRY4LD]
//                                | rb_create_ptr2[RBENTRY-1:ENTRY4LD]
//                                | rb_create_ptr3[RBENTRY-1:ENTRY4LD]);
assign rb_lsda0_ex3_full = rb_full
                           || rb_empty_less2
                              && (!lsda0_ex3_old || lda0_rb_ex3_create_judge_vld)
                           || rb_empty_less3
                              && (!lsda0_ex3_old && lda0_rb_ex3_create_judge_vld);

assign rb_lsda1_ex3_full = rb_full
                           || rb_empty_less2
                              && (!lsda1_ex3_old || lda0_rb_ex3_create_judge_vld || lsda0_rb_ex3_create_judge_vld)
                           || rb_empty_less3
                              && (!lsda1_ex3_old && lda0_rb_ex3_create_judge_vld
                                  || !lsda1_ex3_old && lsda0_rb_ex3_create_judge_vld
                                  || lda0_rb_ex3_create_judge_vld && lsda0_rb_ex3_create_judge_vld)
                           || rb_empty_less4
                              && (!lsda1_ex3_old && lda0_rb_ex3_create_judge_vld && lsda0_rb_ex3_create_judge_vld);
//------------------empty signal----------------------------
assign rb_not_empty = |rb_entry_vld[RBENTRY-1:0];
assign rb_empty     = !rb_not_empty
                       && !rb_pend_busy;

//------------------merge signal----------------------------
assign rb_lda0_ex3_merge_fail       = |(rb_entry_merge_fail0[RBENTRY-1:0]);
// assign rb_lda1_ex3_merge_fail       = |(rb_entry_merge_fail1[RBENTRY-1:0]);
assign rb_lsda0_ex3_merge_fail      = |(rb_entry_merge_fail2[RBENTRY-1:0]);
assign rb_lsda1_ex3_merge_fail      = |(rb_entry_merge_fail3[RBENTRY-1:0]);

//------------------create vld------------------------------
assign rb_create_ld0_success = lda0_rb_ex3_create_vld
                               &&  !rb_lda0_ex3_full;

// assign rb_create_ld1_success = lda1_rb_ex3_create_vld
//                                &&  !rb_lda1_ex3_full;

assign rb_create_ls0_success = lsda0_rb_ex3_create_vld
                               &&  !rb_lsda0_ex3_full;

assign rb_create_ls1_success = lsda1_rb_ex3_create_vld
                               &&  !rb_lsda1_ex3_full;

assign rb_entry_ld0_create_vld[RBENTRY-1:0]     =
                rb_create_ptr0[RBENTRY-1:0]
                & {RBENTRY{rb_create_ld0_success}};

// assign rb_entry_ld1_create_vld[RBENTRY-1:0]     =
//                 rb_create_ptr1[RBENTRY-1:0]
//                 & {RBENTRY{rb_create_ld1_success}};

assign rb_entry_ls0_create_vld[RBENTRY-1:0]     =
                rb_create_ptr2[RBENTRY-1:0]
                & {RBENTRY{rb_create_ls0_success}};

assign rb_create_ptr3_fix = lsda0_rb_ex3_create_dp_vld? rb_create_ptr3: rb_create_ptr2;
assign rb_entry_ls1_create_vld[RBENTRY-1:0]     =
                rb_create_ptr3_fix[RBENTRY-1:0]
                & {RBENTRY{rb_create_ls1_success}};

//------------------create dp vld---------------------------
assign rb_entry_ld0_create_dp_vld[RBENTRY-1:0]  =
                rb_create_ptr0[RBENTRY-1:0]
                & {RBENTRY{!rb_lda0_ex3_full}}
                & {RBENTRY{lda0_rb_ex3_create_dp_vld}};

// assign rb_entry_ld1_create_dp_vld[RBENTRY-1:0]  =
//                 rb_create_ptr1[RBENTRY-1:0]
//                 & {RBENTRY{!rb_lda1_ex3_full}}
//                 & {RBENTRY{lda1_rb_ex3_create_dp_vld}};

assign rb_entry_ls0_create_dp_vld[RBENTRY-1:0]  =
                rb_create_ptr2[RBENTRY-1:0]
                & {RBENTRY{!rb_lsda0_ex3_full}}
                & {RBENTRY{lsda0_rb_ex3_create_dp_vld}};

assign rb_entry_ls1_create_dp_vld[RBENTRY-1:0]  =
                rb_create_ptr3_fix[RBENTRY-1:0]
                & {RBENTRY{!rb_lsda1_ex3_full}}
                & {RBENTRY{lsda1_rb_ex3_create_dp_vld}};
//------------------create gateclk vld----------------------
assign rb_entry_ld0_create_gateclk_en[RBENTRY-1:0] =
                rb_create_ptr0[RBENTRY-1:0]
                & {RBENTRY{!rb_lda0_ex3_full}}
                & {RBENTRY{lda0_rb_ex3_create_gateclk_en}};

// assign rb_entry_ld1_create_gateclk_en[RBENTRY-1:0] =
//                 rb_create_ptr1[RBENTRY-1:0]
//                 & {RBENTRY{!rb_lda1_ex3_full}}
//                 & {RBENTRY{lda1_rb_ex3_create_gateclk_en}};

assign rb_entry_ls0_create_gateclk_en[RBENTRY-1:0] =
                rb_create_ptr2[RBENTRY-1:0]
                & {RBENTRY{!rb_lsda0_ex3_full}}
                & {RBENTRY{lsda0_rb_ex3_create_gateclk_en}};

assign rb_entry_ls1_create_gateclk_en[RBENTRY-1:0] =
                rb_create_ptr3_fix[RBENTRY-1:0]
                & {RBENTRY{!rb_lsda1_ex3_full}}
                & {RBENTRY{lsda1_rb_ex3_create_gateclk_en}};


//==========================================================
//                    info for bar ready
//==========================================================
//success neglect mmu request
assign rb_ready_ld_req_biu          = |(~rb_entry_st[RBENTRY-1:0]
                                        & ~rb_entry_mcic_req[RBENTRY-1:0]
                                        & rb_entry_biu_req[RBENTRY-1:0]);

assign rb_ready_ld_req_biu_success  = !rb_ready_ld_req_biu;
assign rb_ready_req_biu             = |(~rb_entry_mcic_req[RBENTRY-1:0]
                                        & rb_entry_biu_req[RBENTRY-1:0]);
assign rb_ready_all_req_biu_success = !rb_ready_req_biu;


//==========================================================
//                        Fence signal
//==========================================================
// &Force("output","lsu_has_fence"); @286
always @(posedge lsu_special_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    lsu_has_fence   <=  1'b0;
  else if(rb_create_ls0_success && !lsda0_ex3_is_load &&  !lsu_has_fence)
    lsu_has_fence   <=  lsda0_ex3_sync_fence;
  else if(rb_create_ls1_success && !lsda1_ex3_is_load &&  !lsu_has_fence)
    lsu_has_fence   <=  lsda1_ex3_sync_fence;
  else 
    lsu_has_fence   <=  lsu_has_fence_set;
end

assign rb_has_sync_fence  = |(rb_entry_vld[RBENTRY-1:0]
                              & rb_entry_sync_fence[RBENTRY-1:0]);
assign lsu_has_fence_set  = rb_has_sync_fence
                            ||  wmb_has_sync_fence;
assign lsu_idu_no_fence   = !lsu_has_fence;


//==========================================================
//                  Request biu pop entry
//==========================================================
//------------------------registers-------------------------
//+---------+
//| biu_req |
//+---------+
// &Force("output","rb_biu_req_unmask"); @310
always @(posedge rb_pe_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    rb_biu_req_unmask   <=  1'b0;
  else if(rb_pipe_biu_pe_req)
    rb_biu_req_unmask   <=  1'b1;
  else if(rb_read_req_grnt  ||  rb_biu_req_flush_clear)
    rb_biu_req_unmask   <=  1'b0;
end

//+---------+------+------------+
//| pop ptr | addr | lfb_create |
//+---------+------+------------+
// &Force("output","rb_biu_req_addr"); @324
always @(posedge rb_pe_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    rb_biu_req_ptr[RBENTRY-1:0]    <=  {RBENTRY{1'b0}};
    rb_biu_req_create_lfb           <=  1'b0;
    rb_biu_req_addr[`WK_PA_WIDTH-1:0]  <=  {`WK_PA_WIDTH{1'b0}};
    rb_lfb_full_va[`WK_VA_WIDTH-1:12]  <=  {`WK_VA_WIDTH-12{1'b0}};
  end
  else if(rb_biu_pe_req_permit  &&  rb_biu_pe_req)
  begin
    rb_biu_req_ptr[RBENTRY-1:0]    <=  rb_biu_pe_req_ptr[RBENTRY-1:0];
    rb_biu_req_create_lfb           <=  rb_biu_pe_create_lfb;
    rb_biu_req_addr[`WK_PA_WIDTH-1:0]  <=  rb_biu_pe_req_addr[`WK_PA_WIDTH-1:0];
    rb_lfb_full_va[`WK_VA_WIDTH-1:12]  <=  rb_biu_pe_full_va[`WK_VA_WIDTH-1 :12];
  end
  else if(rb_ld0_biu_pe_req_grnt)
  begin
    rb_biu_req_ptr[RBENTRY-1:0]    <=  rb_create_ptr0[RBENTRY-1:0];
    rb_biu_req_create_lfb           <=  lda0_rb_ex3_create_lfb;
    rb_biu_req_addr[`WK_PA_WIDTH-1:0]  <=  lda0_ex3_addr[`WK_PA_WIDTH-1:0];
    rb_lfb_full_va[`WK_VA_WIDTH-1:12]  <=  lda0_ex3_vaddr[`WK_VA_WIDTH-1 :12];
  end
  // else if(rb_ld_biu_pe_req_grnt && rb_ld1_biu_pe_req)
  // begin
  //   rb_biu_req_ptr[RBENTRY-1:0]    <=  rb_create_ptr1[RBENTRY-1:0];
  //   rb_biu_req_create_lfb           <=  lda1_rb_ex3_create_lfb;
  //   rb_biu_req_addr[`WK_PA_WIDTH-1:0]  <=  lda1_ex3_addr[`WK_PA_WIDTH-1:0];
  // end
  else if(rb_ls0_biu_pe_req_grnt)
  begin
    rb_biu_req_ptr[RBENTRY-1:0]    <=  rb_create_ptr2[RBENTRY-1:0];
    rb_biu_req_create_lfb           <=  lsda0_rb_ex3_create_lfb;
    rb_biu_req_addr[`WK_PA_WIDTH-1:0]  <=  lsda0_ex3_addr[`WK_PA_WIDTH-1:0];
    rb_lfb_full_va[`WK_VA_WIDTH-1:12]  <=  lsda0_ex3_vaddr[`WK_VA_WIDTH-1 :12];
  end
  else if(rb_ls1_biu_pe_req_grnt)
  begin
    rb_biu_req_ptr[RBENTRY-1:0]    <=  rb_create_ptr3_fix[RBENTRY-1:0];
    rb_biu_req_create_lfb           <=  lsda1_rb_ex3_create_lfb;
    rb_biu_req_addr[`WK_PA_WIDTH-1:0]  <=  lsda1_ex3_addr[`WK_PA_WIDTH-1:0];
    rb_lfb_full_va[`WK_VA_WIDTH-1:12]  <=  lsda1_ex3_vaddr[`WK_VA_WIDTH-1 :12];
  end
end

//-----------------------biu req ptr------------------------
assign rb_biu_pe_req_gateclk_en = |rb_entry_biu_pe_req_gateclk_en[RBENTRY-1:0];
assign rb_biu_pe_req = |rb_entry_biu_pe_req[RBENTRY-1:0];

com_ff1_from_lsb #(.WIDTH(RBENTRY)) i_wk_find_1st_biu_pe_req (
  .in_data               (rb_entry_biu_pe_req),
  .out_data              (rb_biu_pe_req_ptr  )
);


assign rb_biu_pe_create_lfb       = |(rb_biu_pe_req_ptr[RBENTRY-1:0]
                                      & rb_entry_create_lfb[RBENTRY-1:0]);

always_comb begin 
    rb_biu_pe_req_addr = '0;
    for(int i=0; i<RBENTRY; i++) begin 
        if(rb_biu_pe_req_ptr[i] == 1'b1) begin 
            rb_biu_pe_req_addr = rb_entry_addr[i];
        end 
    end 
end 
always_comb begin 
    rb_biu_pe_full_va = '0;
    for(int i=0; i<RBENTRY; i++) begin 
        if(rb_biu_pe_req_ptr[i] == 1'b1) begin 
            rb_biu_pe_full_va = rb_entry_vaddr[i];
        end 
    end 
end 


//-------------------ld/st biu pop req----------------------
assign rb_ld0_biu_pe_req    = rb_create_ld0_success
                              &&  !lda0_rb_ex3_data_vld
                              &&  !lda0_ex3_page_so
                              &&  !lsu_has_fence;
// assign rb_ld1_biu_pe_req    = rb_create_ld1_success
//                               &&  !lda1_rb_ex3_data_vld
//                               &&  !lda1_ex3_page_so
//                               &&  !lsu_has_fence;
assign rb_ls0_biu_pe_req    = rb_create_ls0_success && lsda0_ex3_is_load
                              &&  !lsda0_rb_ex3_data_vld
                              &&  !lsda0_ex3_page_so
                              &&  !lsu_has_fence;
assign rb_ls1_biu_pe_req    = rb_create_ls1_success && lsda1_ex3_is_load
                              &&  !lsda1_rb_ex3_data_vld
                              &&  !lsda1_ex3_page_so
                              &&  !lsu_has_fence;

assign rb_pipe_biu_pe_req   = rb_biu_pe_req
                              ||  rb_ld0_biu_pe_req
                              // ||  rb_ld1_biu_pe_req
                              ||  rb_ls0_biu_pe_req
                              ||  rb_ls1_biu_pe_req;

assign rb_biu_pe_req_permit   = !rb_biu_req_unmask
                                ||  rb_read_req_grnt
                                ||  rb_biu_req_flush_clear;

assign rb_entry_biu_pe_req_grnt[RBENTRY-1:0]=
                {RBENTRY{rb_biu_pe_req_permit}}
                & rb_biu_pe_req_ptr[RBENTRY-1:0];

assign rb_ld0_biu_pe_req_grnt  = rb_biu_pe_req_permit
                                 &&  !rb_biu_pe_req
                                 &&  rb_ld0_biu_pe_req;

assign rb_ls0_biu_pe_req_grnt  = rb_biu_pe_req_permit
                                 &&  !rb_biu_pe_req
                                 &&  rb_ls0_biu_pe_req
                                 &&  !rb_ld0_biu_pe_req;

assign rb_ls1_biu_pe_req_grnt  = rb_biu_pe_req_permit
                                 &&  !rb_biu_pe_req
                                 &&  rb_ls1_biu_pe_req
                                 &&  !rb_ld0_biu_pe_req
                                 &&  !rb_ls0_biu_pe_req;


//-----------------flush clear in coror----------------------
assign rb_biu_req_flush_clear = ( |(rb_biu_req_ptr[RBENTRY-1:0]
                                    & rb_entry_flush_clear[RBENTRY-1:0]))
                                &&  rb_biu_req_unmask;


//==========================================================
//                      Request biu
//==========================================================
//------------------barrier---------------------------------
// &Force("output","rb_fence_ld"); @423
assign rb_fence_ld  = |rb_entry_fence_ld_vld[RBENTRY-1:0];

//------------------biu req info----------------------------
//rb_biu_req_unmask will send to wmb_entry
// //&Force("output","rb_biu_req_unmask"); @428
//assign rb_biu_req_unmask          = |rb_entry_biu_req[RBENTRY-1:0];
assign rb_biu_req_mcic_req        = |(rb_biu_req_ptr[RBENTRY-1:0] & rb_entry_mcic_req[RBENTRY-1:0]);

assign rb_biu_req_page_ca         = |(rb_biu_req_ptr[RBENTRY-1:0] & rb_entry_page_ca[RBENTRY-1:0]);
assign rb_biu_req_page_so         = |(rb_biu_req_ptr[RBENTRY-1:0] & rb_entry_page_so[RBENTRY-1:0]);
assign rb_biu_req_page_sec        = |(rb_biu_req_ptr[RBENTRY-1:0] & rb_entry_page_sec[RBENTRY-1:0]);
assign rb_biu_req_page_buf        = |(rb_biu_req_ptr[RBENTRY-1:0] & rb_entry_page_buf[RBENTRY-1:0]);
assign rb_biu_req_page_share      = |(rb_biu_req_ptr[RBENTRY-1:0] & rb_entry_page_share[RBENTRY-1:0]);
assign rb_biu_req_sync            = |(rb_biu_req_ptr[RBENTRY-1:0] & rb_entry_sync[RBENTRY-1:0]);
assign rb_biu_req_fence           = |(rb_biu_req_ptr[RBENTRY-1:0] & rb_entry_fence[RBENTRY-1:0]);
assign rb_biu_req_atomic          = |(rb_biu_req_ptr[RBENTRY-1:0] & rb_entry_atomic[RBENTRY-1:0]);
assign rb_biu_req_ldamo           = |(rb_biu_req_ptr[RBENTRY-1:0] & rb_entry_ldamo[RBENTRY-1:0]);
assign rb_biu_req_st              = |(rb_biu_req_ptr[RBENTRY-1:0] & rb_entry_st[RBENTRY-1:0]);
assign rb_biu_req_inst_us         = |(rb_biu_req_ptr[RBENTRY-1:0] & rb_entry_inst_us[RBENTRY-1:0]);
always_comb begin 
    rb_biu_req_inst_size = '0;
    for(int i=0; i<RBENTRY; i++) begin 
        if(rb_biu_req_ptr[i] == 1'b1) begin 
            rb_biu_req_inst_size = rb_entry_inst_size[i];
        end 
    end 
end 

always_comb begin 
    rb_biu_req_priv_mode = '0;
    for(int i=0; i<RBENTRY; i++) begin 
        if(rb_biu_req_ptr[i] == 1'b1) begin 
            rb_biu_req_priv_mode = rb_entry_priv_mode[i];
        end 
    end 
end 

assign rb_biu_req_page_ca_dcache_en     = rb_biu_req_page_ca  &&  cp0_lsu_dcache_en;
assign rb_biu_req_page_nc_atomic        = !rb_biu_req_page_ca &&  rb_biu_req_atomic;

assign rb_biu_req_hit_idx     = wmb_rb_biu_req_hit_idx
                                ||  lfb_rb_biu_req_hit_idx
                                ||  vb_rb_biu_req_hit_idx;
// &Force("output","rb_biu_ar_req"); @466
assign rb_biu_ar_req          = rb_biu_req_unmask
                                &&  !rb_biu_req_flush_clear
                                &&  (!rb_biu_req_hit_idx
                                        &&  rb_biu_req_page_ca
                                        &&  !lfb_addr_full
                                        &&  (lfb_rb_ca_rready_grnt
                                             || rb_nc_fifo_empty) 
                                    ||  !rb_biu_req_page_ca
                                        &&  (!lfb_addr_full | rb_biu_req_page_so)
                                        &&  lfb_rb_nc_rready_grnt);
assign rb_biu_ar_dp_req       = rb_biu_req_unmask
                                &&  !rb_biu_req_flush_clear
                                &&  (rb_biu_req_page_ca
                                        &&  !lfb_addr_full
                                        &&  (lfb_rb_ca_rready_grnt
                                             || rb_nc_fifo_empty) 
                                    ||  !rb_biu_req_page_ca
                                        &&  (!lfb_addr_full | rb_biu_req_page_so)
                                        &&  lfb_rb_nc_rready_grnt);
assign rb_biu_ar_req_gateclk_en = rb_biu_req_unmask;

//----------ar_id-----------------------
assign rb_biu_req_sync_fence      = rb_biu_req_sync  ||  rb_biu_req_fence;
assign rb_biu_ar_id_judge[3:0]    = {rb_biu_req_sync_fence,
                                    rb_biu_req_page_so,
                                    rb_biu_req_page_ca,
                                    rb_biu_req_atomic};

// &Force("output","rb_biu_ar_id"); @495
// &CombBeg; @496
always @( rb_biu_ar_id_judge[3:0]
       or lfb_rb_create_id[4:0])
begin
rb_biu_ar_id[4:0] = 5'b0;
casez(rb_biu_ar_id_judge[3:0])
  4'b1???:rb_biu_ar_id[4:0] = BIU_R_SYNC_FENCE_ID;
  4'b01??:rb_biu_ar_id[4:0] = BIU_R_SO_ID;
  4'b001?:rb_biu_ar_id[4:0] = lfb_rb_create_id[4:0];
  4'b0001:rb_biu_ar_id[4:0] = BIU_R_NC_ATOM_ID;
  4'b0000:rb_biu_ar_id[4:0] = lfb_rb_create_id[4:0];
  default:rb_biu_ar_id[4:0] = 5'b0;
endcase
// &CombEnd; @506
end

//----------ar others-------------------
assign rb_biu_ar_addr[`WK_PA_WIDTH-1:4]  = rb_biu_req_addr[`WK_PA_WIDTH-1:4];

assign rb_biu_ar_size_maintain  = (rb_biu_req_page_so  ||  rb_biu_req_page_nc_atomic)
                                  &&  !rb_biu_req_sync_fence;

assign rb_biu_ar_addr[3:0]      = rb_biu_ar_size_maintain
                                  ? rb_biu_req_addr[3:0]
                                  : 4'b0;
//len: a cache line(4x) or 1x
assign rb_biu_len3_sel = rb_biu_req_page_ca_dcache_en  
                            &&  !rb_biu_req_sync_fence
                         || rb_biu_req_inst_us
                         || rb_biu_req_page_ca
                            &&  rb_biu_req_atomic; 
      
assign rb_biu_ar_len[1:0]       = rb_biu_len3_sel
                                  ? 2'h1
                                  : 2'h0;
//size:
//  ca/nc : 111
//  so    : so_size
assign rb_biu_ar_size[2:0]      = rb_biu_ar_size_maintain
                                  ? {rb_biu_req_inst_size[2:0]}
                                  : 3'b101;
//burst:incr1 or wrap4
assign rb_biu_ar_burst[1:0]     = rb_biu_len3_sel
                                  ? 2'b10
                                  : 2'b01;
assign rb_biu_ar_lock           = rb_biu_req_atomic;


//cache:
//if sync/bar use normal, noncacheable
assign rb_biu_ar_cache[3:0]     = rb_biu_req_sync_fence
                                  ? 4'b0011
                                  : {rb_biu_req_page_ca,
                                    rb_biu_req_page_ca,
                                    !rb_biu_req_page_so,
                                    rb_biu_req_page_buf};

//prot:2:inst,1:sec,0:supv
assign rb_biu_ar_prot[2:0]      = {1'b0,
                                  rb_biu_req_page_sec,
                                  rb_biu_req_priv_mode[0]};
//if request both biu and lfb, then the rb_entry must get two grnt signal, else
//it will not request biu or lfb. it is realized in rb top module.
assign rb_biu_ar_user[3:0]      = {rb_biu_req_page_share,1'b0,rb_biu_req_priv_mode[1],rb_biu_req_mcic_req};
//----------ar snoop--------------------
assign rb_atomic_readunique     = rb_biu_req_page_ca
                                  &&  rb_biu_req_ldamo;
//lr should send read shared when cache is off (for l2 snoop filter)
assign rb_biu_share_refill      = rb_biu_req_page_ca
                                  &&  (cp0_lsu_dcache_en || rb_biu_req_atomic);  

// &CombBeg; @565
always @( rb_biu_req_st
       or rb_atomic_readunique
       or rb_biu_share_refill)
begin
rb_biu_ar_snoop[3:0] = 4'b0;
casez({rb_atomic_readunique,rb_biu_share_refill,rb_biu_req_st})
  3'b1??:rb_biu_ar_snoop[3:0] = 4'b0111;//ReadUnique
  3'b011:rb_biu_ar_snoop[3:0] = 4'b0111;//ReadUnique
  3'b010:rb_biu_ar_snoop[3:0] = 4'b0001;//ReadShared
  default:rb_biu_ar_snoop[3:0] = 4'b0;//ReadNoSnoop & ReadOnce
endcase
// &CombEnd; @573
end

//if ld non-cacheable then domain = 2'b11
assign rb_biu_ar_domain[1:0]    = (!rb_biu_req_page_ca  &&  !rb_biu_req_st)
                                  ? 2'b11
                                  : rb_biu_req_sync_fence
                                    ? {1'b0,rb_biu_req_page_share} 
                                    : 2'b01;

assign rb_biu_req_not_wait_fence  = rb_biu_req_mcic_req ||  rb_biu_req_st;
// &CombBeg; @583
always @( rb_biu_req_not_wait_fence
       or rb_biu_req_fence
       or rb_biu_req_sync)
begin
rb_biu_ar_bar[1:0]  = 2'b00;
case({rb_biu_req_not_wait_fence,rb_biu_req_sync,rb_biu_req_fence})
  3'b100:rb_biu_ar_bar[1:0] = 2'b10;//mmu req
  3'b110:rb_biu_ar_bar[1:0] = 2'b11;//sync req
  3'b101:rb_biu_ar_bar[1:0] = 2'b01;//fence req
  default:rb_biu_ar_bar[1:0]  = 2'b00;
endcase
// &CombEnd; @591
end

//-----------------biu grnt signal--------------------------
//assign rb_biu_nc_req_grnt     = bus_arb_rb_ar_grnt
//                                &&  !rb_biu_req_page_ca
//                                &&  !rb_biu_req_page_so
//                                &&  !rb_biu_req_atomic
//                                &&  !rb_biu_req_sync_fence;
assign rb_biu_so_req_grnt     = bus_arb_rb_ar_grnt
                                &&  rb_biu_req_page_so
                                &&  !rb_biu_req_sync_fence;

assign rb_read_req_grnt       = bus_arb_rb_ar_grnt;

//for timing, use shorter route of req_success for gateclk
assign rb_read_req_grnt_gateclk_en  = rb_biu_req_unmask;
assign rb_entry_biu_id_gateclk_en[RBENTRY-1:0] =
                {RBENTRY{rb_read_req_grnt_gateclk_en}}
                & rb_biu_req_ptr[RBENTRY-1:0];
assign rb_entry_read_req_grnt[RBENTRY-1:0] =
                {RBENTRY{rb_read_req_grnt}}
                & rb_biu_req_ptr[RBENTRY-1:0];



//==========================================================
//                  Request ld_wb stage
//==========================================================
//------------------wb cmplt part signal--------------------
//because only so/ex load request cmplt, so there is only 1 complete request
//assign rb_ld_wb_cmplt_ptr[RBENTRY-1:0] = rb_entry_wb_cmplt_req[RBENTRY-1:0];
assign rb_lwb_ex3_cmplt_req     = |rb_entry_wb_cmplt_req[RBENTRY-1:0];
always_comb begin 
    rb_lwb_ex3_iid = '0;
    for(int i=0; i<RBENTRY; i++) begin 
        if(rb_ld_wb_cmplt_ptr[i] == 1'b1) begin 
            rb_lwb_ex3_iid = rb_entry_iid[i];
        end 
    end 
end 

//----------wb cmplt part grnt----------
assign rb_entry_wb_cmplt_grnt[RBENTRY-1:0] = rb_ld_wb_cmplt_ptr[RBENTRY-1:0]
                                              & {RBENTRY{lwb_rb_ex3_cmplt_grnt}};

assign rb_lwb_ex3_spec_fail = |(rb_ld_wb_cmplt_ptr[RBENTRY-1:0] & rb_entry_spec_fail[RBENTRY-1:0]);

// &Force("output","rb_ld_wb_expt_vld"); @639
// &Force("output","rb_ld_wb_element_cnt"); @640
assign rb_lwb_ex3_cmplt_vmb_merge_vld         = |(rb_ld_wb_cmplt_ptr[RBENTRY-1:0] & rb_entry_vmb_merge_vld[RBENTRY-1:0]);

always_comb begin 
    rb_lwb_ex3_cmplt_vmb_id[VMBENTRY-1:0] = {VMBENTRY{1'b0}};
    rb_lwb_ex3_element_cnt[8:0]           = 9'b0;
    rb_ld_wb_setvl_val[8:0]               = 9'b0;
    //rb_ld_wb_cmplt_vsew[1:0]              = 2'b0; //rvv1.0 @hcl 
    rb_ld_wb_cmplt_vmew[1:0]              = 2'b0; //rvv1.0 @hcl 
    rb_ld_wb_cmplt_vmop[1:0]              = 2'b0; //rvv1.0 @hcl 
    // rb_ld_wb_cmplt_vlmul                  = 2'b0;
    rb_ld_wb_cmplt_vlmul                  = 3'b0;    
    for(int i=0; i<RBENTRY; i++) begin 
        if(rb_ld_wb_cmplt_ptr[i] == 1'b1) begin 
            rb_lwb_ex3_cmplt_vmb_id = rb_entry_vmb_id[i];
            rb_lwb_ex3_element_cnt  = rb_entry_element_cnt[i];
            rb_ld_wb_setvl_val      = rb_entry_setvl_val[i];
            //rb_ld_wb_cmplt_vsew     = rb_entry_vsew[i];
            rb_ld_wb_cmplt_vmew     = rb_entry_vmew[i];
            rb_ld_wb_cmplt_vmop     = rb_entry_vmop[i];
            rb_ld_wb_cmplt_vlmul    = rb_entry_vlmul[i];
        end 
    end 
end 

assign rb_ld_wb_expt            = |(rb_ld_wb_cmplt_ptr[RBENTRY-1:0] & rb_entry_expt_vld[RBENTRY-1:0]);
assign rb_ld_wb_split           = |(rb_ld_wb_cmplt_ptr[RBENTRY-1:0] & rb_entry_split[RBENTRY-1:0]);
assign rb_ld_wb_cmplt_inst_vls  = |(rb_ld_wb_cmplt_ptr[RBENTRY-1:0] & rb_entry_inst_vls[RBENTRY-1:0]);
assign rb_ld_wb_cmplt_inst_fof  = |(rb_ld_wb_cmplt_ptr[RBENTRY-1:0] & rb_entry_inst_fof[RBENTRY-1:0]);

assign rb_ld_wb_fof_not_first = rb_ld_wb_cmplt_inst_fof
                                && !(rb_ld_wb_setvl_val[8:0] == 9'b0);

assign rb_lwb_ex3_expt_vld   =  rb_ld_wb_expt
                                && !rb_ld_wb_fof_not_first; 

assign rb_lwb_ex3_vstart_vld = rb_ld_wb_cmplt_inst_vls
                               && ((cp0_lsu_vstart[`VSTART_WIDTH-1:0] == `VSTART_WIDTH'b0)
                                      && rb_lwb_ex3_expt_vld
                                   || (cp0_lsu_vstart[`VSTART_WIDTH-1:0] != `VSTART_WIDTH'b0)
                                      && !rb_ld_wb_split
                                      && !rb_lwb_ex3_expt_vld);

assign rb_lwb_ex3_vsetvl = rb_ld_wb_cmplt_inst_fof
                           && rb_ld_wb_expt
                           && rb_ld_wb_fof_not_first;

assign rb_ld_wb_vl_upval[8:0] = rb_ld_wb_setvl_val[8:0];

assign rb_lwb_ex3_mt_value[`WK_PA_WIDTH-1:0] = rb_lwb_ex3_expt_vld
                                          ? {`WK_PA_WIDTH{1'b0}}
//                                          : {{`WK_PA_WIDTH-16{1'b0}},3'b100,1'b0,rb_ld_wb_vl_upval[6:0],1'b0,rb_ld_wb_cmplt_vmew[1:0],rb_ld_wb_cmplt_vlmul[1:0]};//rvv1.0 @hcl
                                          : {{`WK_PA_WIDTH-19{1'b0}},3'b100,1'b0,rb_ld_wb_vl_upval[8:0],1'b0,rb_ld_wb_cmplt_vmew[1:0],rb_ld_wb_cmplt_vlmul[2:0]};//rvv1.0 @hcl
// mark by tmj, TODO: vlmul 3bits
//for gateclk
assign rb_lwb_ex3_expt_gateclk = |(rb_ld_wb_cmplt_ptr[RBENTRY-1:0] & rb_entry_expt_vld[RBENTRY-1:0]);


//------------------wb data part signal---------------------
com_ff1_from_lsb #(.WIDTH(RBENTRY)) i_wk_find_1st_wb_data_pre_sel (
  .in_data               (rb_entry_wb_data_pre_sel),
  .out_data              (rb_ld_wb_data_ptr_pre  )
);

com_ff1_from_lsb #(.WIDTH(RBENTRY)) i_wk_find_1st_wb_cmplt_req (
  .in_data               (rb_entry_wb_cmplt_req),
  .out_data              (rb_ld_wb_cmplt_ptr  )
);

//==========================================================
//                 Instance of Gated Cell  
//==========================================================
//data_ptr pop signal
assign rb_data_ptr_clk_en = rb_not_empty; 
                            
always @(posedge rb_data_ptr_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    rb_ld_wb_data_ptr[RBENTRY-1:0]  <= {RBENTRY{1'b0}};
  else if(rb_not_empty)
    rb_ld_wb_data_ptr[RBENTRY-1:0]  <=  rb_ld_wb_data_ptr_pre[RBENTRY-1:0];
end


assign rb_ld_wb_data_req_unmask = |(rb_ld_wb_data_ptr[RBENTRY-1:0] & rb_entry_wb_data_req[RBENTRY-1:0]);

always_comb begin 
    rb_ld_wb_inst_size[2:0]                   = 3'b0;
    rb_lwb_ex3_preg[PREG-1:0]                 = {PREG{1'b0}};
    rb_lwb_ex3_vreg[VREG-1:0]                 = {VREG{1'b0}};
    rb_lwb_ex3_bus_err_addr[`WK_PA_WIDTH-1:0] = {`WK_PA_WIDTH{1'b0}};
    rb_lwb_ex3_data_iid[IID_WIDTH-1:0]        = {IID_WIDTH{1'b0}};
    rb_ld_wb_element_size[1:0]                = 2'b0;
    //rb_ld_wb_vsew[1:0]                        = 2'b0;//rvv1.0 @hcl
    rb_ld_wb_vmew[1:0]                        = 2'b0;//rvv1.0 @hcl
    rb_ld_wb_vmop[1:0]                        = 2'b0;//rvv1.0 @hcl
    rb_lwb_ex3_reg_bytes_vld[15:0]            = 16'b0;
    rb_lwb_ex3_reg_bytes_vld1[15:0]            = 16'b0;
    rb_lwb_ex3_reg_bytes_vld2[15:0]            = 16'b0;
    rb_lwb_ex3_reg_bytes_vld3[15:0]            = 16'b0;
    rb_lwb_ex3_inst_us                         = 1'b0;
    rb_lwb_ex3_data_vmb_id[VMBENTRY-1:0]      = {VMBENTRY{1'b0}};
    rb_lwb_ex3_data_element_cnt[8:0]          = 9'b0;
    rb_ld_rot_sel                             = 16'b0;
    
    for(int i=0; i<RBENTRY; i++) begin 
        if(rb_ld_wb_data_ptr[i] == 1'b1) begin 
            rb_ld_wb_inst_size      = rb_entry_inst_size[i];
            rb_lwb_ex3_preg         = rb_entry_preg[i];
            rb_lwb_ex3_vreg         = rb_entry_vreg[i];
            rb_lwb_ex3_bus_err_addr = rb_entry_addr[i];
            rb_lwb_ex3_data_iid     = rb_entry_iid[i];
            rb_ld_wb_element_size   = rb_entry_element_size[i];
            //rb_ld_wb_vsew           = rb_entry_vsew[i]; //rvv1.0 @hcl
            rb_ld_wb_vmew           = rb_entry_vmew[i]; //rvv1.0 @hcl
            rb_ld_wb_vmop           = rb_entry_vmop[i]; //rvv1.0 @hcl
            rb_lwb_ex3_reg_bytes_vld = rb_entry_reg_bytes_vld[i];
            rb_lwb_ex3_reg_bytes_vld1 = rb_entry_reg_bytes_vld1[i];
            rb_lwb_ex3_reg_bytes_vld2 = rb_entry_reg_bytes_vld2[i];
            rb_lwb_ex3_reg_bytes_vld3 = rb_entry_reg_bytes_vld3[i];
            rb_lwb_ex3_inst_us        = rb_entry_inst_us[i];
            rb_lwb_ex3_data_vmb_id   = rb_entry_vmb_id[i];
            rb_lwb_ex3_data_element_cnt = rb_entry_element_cnt[i];
            rb_ld_rot_sel               = rb_entry_rot_sel[i];
        end 
    end 
end 
assign rb_lwb_ex3_vmew = rb_ld_wb_vmew;
assign rb_ld_wb_sign_extend     = |(rb_ld_wb_data_ptr[RBENTRY-1:0] & rb_entry_sign_extend[RBENTRY-1:0]);
assign rb_lwb_ex3_bus_err       = |(rb_ld_wb_data_ptr[RBENTRY-1:0]  & rb_entry_bus_err[RBENTRY-1:0]);
assign rb_lwb_ex3_data_req        = rb_ld_wb_data_req_unmask;


// &Force("output","rb_ld_wb_inst_vfls"); @820
assign rb_lwb_ex3_inst_vfls    = |(rb_ld_wb_data_ptr[RBENTRY-1:0]  & rb_entry_inst_vfls[RBENTRY-1:0]);
assign rb_ld_wb_vreg_sign      = |(rb_ld_wb_data_ptr[RBENTRY-1:0]  & rb_entry_vreg_sign_sel[RBENTRY-1:0]);

// &Force("output","rb_ld_wb_inst_vls"); @825
// &Force("output","rb_ld_wb_vreg_sign_sel"); @826
assign rb_lwb_ex3_inst_vls            = |(rb_ld_wb_data_ptr[RBENTRY-1:0]  & rb_entry_inst_vls[RBENTRY-1:0]);
assign rb_lwb_ex3_data_vmb_merge_vld  = |(rb_ld_wb_data_ptr[RBENTRY-1:0]  & rb_entry_vmb_merge_vld[RBENTRY-1:0]);

//----------wb data part grnt-----------
assign rb_entry_wb_data_grnt[RBENTRY-1:0] = 
                rb_ld_wb_data_ptr[RBENTRY-1:0]
                & {RBENTRY{lwb_rb_ex3_data_grnt  &&  !rtu_yy_xx_flush}};

//==========================================================
//            Settle data to register mode
//==========================================================
// &CombBeg; @894
always_comb begin 
    rb_wb_data = {128{1'b0}};
    rb_wb_data1 = {128{1'b0}};
    rb_wb_data2 = {128{1'b0}};
    rb_wb_data3 = {128{1'b0}};
    for(int i=0; i<RBENTRY; i++) begin 
        if(rb_ld_wb_data_ptr[i] == 1'b1) begin 
            rb_wb_data = rb_entry_data[i];
            rb_wb_data1 = rb_entry_data1[i];
            rb_wb_data2 = rb_entry_data2[i];
            rb_wb_data3 = rb_entry_data3[i];
        end 
    end 
end 

assign rb_wb_data_unsettle[127:0] = rb_wb_data[127:0];
// &CombBeg; @918
// &CombEnd; @930

//rotate data
// &Instance("xx_lsu_rot_data", "x_lsu_rb_wb_data_rot"); @935
xx_lsu_rot_data  x_lsu_rb_wb_data_rot (
  .data_in             (rb_wb_data_unsettle),
  .data_settle_out     (rb_ld_wb_data_128  ),
  .rot_sel             (rb_ld_rot_sel      )
);

assign rb_lwb_ex3_data[127:0] = rb_lwb_ex3_inst_us? rb_wb_us_data0: rb_ld_wb_data_128[127:0];

xx_lsu_rot_us_data x_xx_lsu_rot_us_data
(
  .data_in0   (rb_wb_data),
  .data_in1   (rb_wb_data1),
  .data_in2   (rb_wb_data2),
  .data_in3   (rb_wb_data3),
  .rot_sel    (rb_lwb_ex3_bus_err_addr[5:0]),
  .data_out0  (rb_wb_us_data0),
  .data_out1  (rb_lwb_ex3_data1),
  .data_out2  (rb_lwb_ex3_data2),
  .data_out3  (rb_lwb_ex3_data3)
);
//------------------select sign bit-------------------------

always @( rb_ld_wb_inst_size[1:0]
       or rb_ld_wb_sign_extend)
begin
case({rb_ld_wb_sign_extend,rb_ld_wb_inst_size[1:0]})
  {1'b1,S_BYTE}:rb_lwb_ex3_preg_sign_sel[3:0] = 4'b0010;
  {1'b1,HALF}:rb_lwb_ex3_preg_sign_sel[3:0] = 4'b0100;
  {1'b1,WORD}:rb_lwb_ex3_preg_sign_sel[3:0] = 4'b1000;
  default:rb_lwb_ex3_preg_sign_sel[3:0] = 4'b0001;
endcase
// &CombEnd; @954
end

// &CombBeg; @957
always @( rb_ld_wb_vmew[1:0]
       or rb_lwb_ex3_inst_vls
       or rb_ld_wb_vreg_sign
       or rb_ld_wb_element_size[1:0])
begin
casez({rb_lwb_ex3_inst_vls,rb_ld_wb_vreg_sign,rb_ld_wb_element_size[1:0],rb_ld_wb_vmew[1:0]})//rvv1.0 @hcl
  {1'b1,1'b0,S_BYTE,HALF}:  rb_lwb_ex3_vreg_sign_sel[14:0] = 15'h0002;
  {1'b1,1'b1,S_BYTE,HALF}:  rb_lwb_ex3_vreg_sign_sel[14:0] = 15'h0004;
  {1'b1,1'b0,S_BYTE,WORD}:  rb_lwb_ex3_vreg_sign_sel[14:0] = 15'h0008;
  {1'b1,1'b1,S_BYTE,WORD}:  rb_lwb_ex3_vreg_sign_sel[14:0] = 15'h0010;
  {1'b1,1'b0,S_BYTE,DWORD}: rb_lwb_ex3_vreg_sign_sel[14:0] = 15'h0020;
  {1'b1,1'b1,S_BYTE,DWORD}: rb_lwb_ex3_vreg_sign_sel[14:0] = 15'h0040;
  {1'b1,1'b0,HALF,WORD}:    rb_lwb_ex3_vreg_sign_sel[14:0] = 15'h0080;
  {1'b1,1'b1,HALF,WORD}:    rb_lwb_ex3_vreg_sign_sel[14:0] = 15'h0100;
  {1'b1,1'b0,HALF,DWORD}:   rb_lwb_ex3_vreg_sign_sel[14:0] = 15'h0200;
  {1'b1,1'b1,HALF,DWORD}:   rb_lwb_ex3_vreg_sign_sel[14:0] = 15'h0400;
  {1'b1,1'b0,WORD,DWORD}:   rb_lwb_ex3_vreg_sign_sel[14:0] = 15'h0800;
  {1'b1,1'b1,WORD,DWORD}:   rb_lwb_ex3_vreg_sign_sel[14:0] = 15'h1000;
  {1'b0,1'b1,HALF,2'b??}:   rb_lwb_ex3_vreg_sign_sel[14:0] = 15'h2000;
  {1'b0,1'b1,WORD,2'b??}:   rb_lwb_ex3_vreg_sign_sel[14:0] = 15'h4000;
  default:rb_lwb_ex3_vreg_sign_sel[14:0] = 15'h0001;         
endcase
// &CombEnd; @975
end

//==========================================================
//                    compare index
//==========================================================
assign rb_sq_pop_hit_idx      = |rb_entry_sq_pop_hit_idx[RBENTRY-1:0];
assign rb_wmb_ce_hit_idx      = |rb_entry_wmb_ce_hit_idx[RBENTRY-1:0];
assign rb_pfu_biu_req_hit_idx = |rb_entry_pfu_biu_req_hit_idx[RBENTRY-1:0];
// now you need to hanld idx conflict among the parallel req here
// assign rb_ld_da_hit_idx       = |rb_entry_ld_da_hit_idx[RBENTRY-1:0];
// assign rb_st_da_hit_idx       = |rb_entry_st_da_hit_idx[RBENTRY-1:0];
// it is impossible rb_create loads to hit idx, they are arbitered when requesting L1D otherwise
// while load-store idx-hit are resolved in st-da
assign rb_lda0_ex3_hit_idx    = |rb_entry_lda0_hit_idx[RBENTRY-1:0];
// 
// ------------------------------- lsda0 -----------------------------------------
// assign rb_lsda0_ex3_hit_idx   = |rb_entry_lsda0_hit_idx[RBENTRY-1:0];
assign rb_lsda0_ex3_hit_idx   = {|rb_entry_lsda0_ld_hit_idx[RBENTRY-1:0], |rb_entry_lsda0_st_hit_idx};

// ---------------------------- lsda1 ------------------------------------
// assign rb_lsda1_ex3_hit_idx   = |rb_entry_lsda1_hit_idx[RBENTRY-1:0];
assign rb_lsda1_ex3_hit_idx   = {|rb_entry_lsda1_ld_hit_idx[RBENTRY-1:0], |rb_entry_lsda1_st_hit_idx};

//==========================================================
//                    Compare r_id
//==========================================================
//assign rb_r_nc_id_hit     = biu_lsu_r_vld
//                            &&  (biu_lsu_r_id[4:0]  ==  BIU_R_NC_ID);
assign rb_r_so_id_hit     = biu_lsu_r_vld
                            &&  (biu_lsu_r_id[4:0]  ==  BIU_R_SO_ID);
// &Force("bus","biu_lsu_r_resp",3,0); @997
assign rb_r_resp_err      = biu_lsu_r_vld
                            &&  biu_lsu_r_resp[1];
assign rb_r_resp_okay     = biu_lsu_r_vld
                            &&  (biu_lsu_r_resp[1:0]  ==  OKAY);
assign rb_r_resp_ecc_err  = 1'b0;
//==========================================================
//                for avoid deadlock with no rready
//==========================================================
assign rb_nc_fifo_empty     = rb_so_no_pending  && lfb_rb_nc_empty;
assign rb_nc_ar_req         = rb_biu_req_unmask && !rb_biu_req_page_ca; 
assign rb_pfu_nc_no_pending = rb_nc_fifo_empty  && !rb_nc_ar_req;

//==========================================================
//                        pend addr
//==========================================================
assign rb_pend_entry[RBENTRY-1:0]  = rb_entry_memr_wait_resp[RBENTRY-1:0];

// &ConnRule(s/xxsource/rb/); @1015
// &Instance("xx_lsu_pend_addr_sel","x_xx_lsu_rb_pend_addr_sel"); @1016
xx_lsu_pend_addr_sel_32 #(.RBENTRY(RBENTRY)) 
  x_xx_lsu_rb_pend_addr_sel (
  .cp0_lsu_icg_en          (cp0_lsu_icg_en         ),
  .cpurst_b                (cpurst_b               ),
  .forever_cpuclk          (forever_cpuclk         ),
  .pad_yy_icg_scan_en      (pad_yy_icg_scan_en     ),
  .xxsource_entry_addr     (rb_entry_addr          ),
  .xxsource_entry_page_ca  (rb_entry_page_ca       ),
  .xxsource_entry_page_so  (rb_entry_page_so       ),
  .xxsource_has_pend       (rb_has_pend            ),
  .xxsource_pend_addr_f    (rb_pend_addr_f         ),
  .xxsource_pend_busy      (rb_pend_busy           ),
  .xxsource_pend_entry     (rb_pend_entry          ),
  .xxsource_pend_page_ca_f (rb_pend_page_ca_f      ),
  .xxsource_pend_page_so_f (rb_pend_page_so_f      )
);


//==========================================================
//        interface to other module (except biu_arb)
//==========================================================
//------------------------lfb-------------------------------
assign rb_lfb_create_vld_unmask   = rb_biu_req_unmask & rb_biu_req_create_lfb;
assign rb_lfb_depd                = |(rb_biu_req_ptr[RBENTRY-1:0]
                                      & (rb_entry_depd0[RBENTRY-1:0]
                                        // | rb_entry_depd1[RBENTRY-1:0]
                                        | rb_entry_depd2[RBENTRY-1:0]
                                        | rb_entry_depd3[RBENTRY-1:0]
                                        | rb_entry_discard_vld0[RBENTRY-1:0]
                                        // | rb_entry_discard_vld1[RBENTRY-1:0]
                                        | rb_entry_discard_vld2[RBENTRY-1:0]
                                        | rb_entry_discard_vld3[RBENTRY-1:0]));
assign rb_lfb_atomic                      = rb_biu_req_atomic;
assign rb_lfb_ldamo                       = rb_biu_req_ldamo;
assign rb_lfb_page_ca                     = rb_biu_req_page_ca;
assign rb_lfb_page_share                  = rb_biu_req_page_share;
assign rb_lfb_addr_tto4[`WK_PA_WIDTH-5:0] = rb_biu_req_addr[`WK_PA_WIDTH-1:4];

//create req signal is used for artribute
// &Force("output","rb_lfb_create_req"); @1033
assign rb_lfb_create_req          = rb_lfb_create_vld_unmask;
assign rb_lfb_create_vld          = bus_arb_rb_ar_grnt  &&  rb_biu_req_create_lfb;
assign rb_lfb_create_dp_vld       = rb_lfb_create_vld_unmask;
assign rb_lfb_create_gateclk_en   = rb_lfb_create_vld_unmask;
assign rb_lfb_depd_wakeup0        = |(rb_entry_depd_wakeup0[RBENTRY-1:0]);
// assign rb_lfb_depd_wakeup1        = |(rb_entry_depd_wakeup1[RBENTRY-1:0]);
assign rb_lfb_depd_wakeup2        = |(rb_entry_depd_wakeup2[RBENTRY-1:0]);
assign rb_lfb_depd_wakeup3        = |(rb_entry_depd_wakeup3[RBENTRY-1:0]);
//------------------------mcic------------------------------
assign rb_mcic_biu_req_success    = bus_arb_rb_ar_grnt &&  rb_biu_req_mcic_req;
assign rb_mcic_ar_id[4:0]         = rb_biu_ar_id[4:0];
assign rb_mcic_not_full           = !rb_full; // reserve one entry for mcic req
assign rb_mcic_ecc_err            = rb_r_resp_ecc_err;
//------------------------lm--------------------------------
assign rb_lm_wait_resp_dp_vld     = rb_biu_req_unmask &&  rb_biu_req_atomic;
assign rb_lm_wait_resp_vld        = bus_arb_rb_ar_grnt &&  rb_biu_req_atomic;
assign rb_lm_ar_id[4:0]           = rb_biu_ar_id[4:0];
assign rb_lm_atomic_next_resp     = |rb_entry_atomic_next_resp[RBENTRY-1:0];
//------------------------idu-------------------------------
// assign lsu_idu_rb_not_full        = !rb_empty_less2;
assign lsu0_idu_exx_rb_not_full   = !rb_empty_less2; // lsu0-1 will use low
// assign lsu1_idu_exx_rb_not_full   = !rb_empty_less2_low; // lsu0-1 will use low
assign lsu2_idu_exx_rb_not_full   = !rb_empty_less2; // lsu2-3 will use high
assign lsu3_idu_exx_rb_not_full   = !rb_empty_less2; // lsu2-3 will use high
//------------------------rtu-------------------------------
assign lsu_rtu_all_commit_ld_data_vld = &rb_entry_cmit_data_vld[RBENTRY-1:0];
//------------------------had-------------------------------
assign lsu_had_rb_entry_state_0[3:0]  = rb_entry_state[0][3:0];
assign lsu_had_rb_entry_state_1[3:0]  = rb_entry_state[1][3:0];
assign lsu_had_rb_entry_state_2[3:0]  = rb_entry_state[2][3:0];
assign lsu_had_rb_entry_state_3[3:0]  = rb_entry_state[3][3:0];
assign lsu_had_rb_entry_state_4[3:0]  = rb_entry_state[4][3:0];
assign lsu_had_rb_entry_state_5[3:0]  = rb_entry_state[5][3:0];
assign lsu_had_rb_entry_state_6[3:0]  = rb_entry_state[6][3:0];
assign lsu_had_rb_entry_state_7[3:0]  = rb_entry_state[7][3:0];
assign lsu_had_rb_entry_fence[7:0] = rb_entry_fence[7:0];

//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
assign rb_ld_wb_data_check    = |(rb_ld_wb_data_ptr[RBENTRY-1:0]  & rb_entry_data_check[RBENTRY-1:0]);

always_comb begin
  rb_ld_wb_data_halt_info[`TDT_MP_HINFO_WIDTH-1:0] = {`TDT_MP_HINFO_WIDTH{1'b0}};
  for(int i=0; i<RBENTRY; i++) begin 
        if(rb_ld_wb_data_ptr[i] == 1'b1) begin
          rb_ld_wb_data_halt_info = rb_entry_halt_info[i];
        end
  end
end

always_comb begin
  rb_ld_wb_halt_info[`TDT_MP_HINFO_WIDTH-1:0] = {`TDT_MP_HINFO_WIDTH{1'b0}};
  for(int i=0; i<RBENTRY; i++) begin 
        if(rb_ld_wb_cmplt_ptr[i] == 1'b1) begin 
            rb_ld_wb_halt_info[`TDT_MP_HINFO_WIDTH-1:0] = rb_entry_halt_info[i];
        end 
    end
end

assign rb_ld_wb_halt_info_am[`TDT_MP_HINFO_WIDTH-1:2] = rb_ld_wb_halt_info[`TDT_MP_HINFO_WIDTH-1:2];
assign rb_ld_wb_halt_info_am[1] = rb_ld_wb_halt_info[1] & ~rb_lwb_ex3_vsetvl;                              
assign rb_ld_wb_halt_info_am[0] = rb_ld_wb_halt_info[0];
//==========================================================
//                  Risc-V Debug zdb End
//==========================================================
// &ModuleEnd; @1064
endmodule


// def print_3create_rb(entry, reserve):
//     print("\\\\print_3create")
//     for i in range(entry):
//         if i==0:
//             print("assign rb_create_ptr0[0] = ~rb_entry_vld[0];")
//         elif i==1:
//             print("assign rb_create_ptr0[1] = ~rb_entry_vld[1] && rb_entry_vld[0];")
//         else:
//             print("assign rb_create_ptr0["+str(i)+"] = ~rb_entry_vld["+str(i)+"] && &(rb_entry_vld["+str(i-1)+":0]);")
//     print("")
//     for i in range(reserve):
//         print("assign rb_create_ptr2["+str(entry-i-1)+"] = 1'b0;")
//     for i in range(entry-reserve-1,-1,-1):
//         if(i == entry-reserve-1):
//             print("assign rb_create_ptr2["+str(i)+"] = ~rb_entry_vld["+str(i)+"];")
//         elif(i == entry-reserve-2):
//             print("assign rb_create_ptr2["+str(i)+"] = ~rb_entry_vld["+str(i)+"] && rb_entry_vld["+str(i+1)+"];")
//         else:
//             print("assign rb_create_ptr2["+str(i)+"] = ~rb_entry_vld["+str(i)+"] && &(rb_entry_vld["+str(entry-1-reserve)+":"+str(i+1)+"]);")
//     print("")
//     for i in range(reserve):
//         print("assign rb_create_ptr3["+str(entry-i-1)+"] = 1'b0;")
//     for i in range(entry-reserve-1,-1,-1):
//         if(i == entry-reserve-1):
//             print("assign rb_create_ptr3["+str(i)+"] = 1'b0;")
//         elif(i == entry-reserve-2):
//             print("assign rb_create_ptr3["+str(i)+"] = ~rb_entry_vld["+str(i)+"] && &(rb_entry_vld["+str(i+1)+"]    | rb_create_ptr2["+str(i+1)+"])    && |(rb_create_ptr2["+str(i+1)+"]);")
//         else:
//             print("assign rb_create_ptr3["+str(i)+"] = ~rb_entry_vld["+str(i)+"] && &(rb_entry_vld["+str(entry-reserve-1)+":"+str(i+1)+"] | rb_create_ptr2["+str(entry-reserve-1)+":"+str(i+1)+"]) && |(rb_create_ptr2["+str(entry-reserve-1)+":"+str(i+1)+"]);")
