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
module xx_lsu_ld_dc #(
parameter VB_DATA_ENTRY = 3,
parameter LQENTRY      = 48,
parameter LSIQENTRY    = 12,
parameter VMBENTRY     = 8,
parameter PC_LEN        = 15,
parameter IID_WIDTH     = 7,
parameter VREG          = 6,
parameter PREG          = 7
)(
  // &Ports; @28
cb_ld_dc_addr_hit,   
lsu_dcache_ld_xx_gwen,                 
cp0_lsu_da_fwd_dis,                     
cp0_lsu_dcache_en,                      
cp0_lsu_ecc_en,                         
cp0_lsu_icg_en,  
icc_dcache_arb_ecc_read,   
icc_dcache_arb_ld_tag_read,                         
cpurst_b,                               
ctrl_ld_clk,  
forever_cpuclk,                              
dcache_arb_ldc_borrow_db,             
dcache_arb_ldc_borrow_icc,            
dcache_arb_ldc_borrow_idx_5to4,       
dcache_arb_ldc_borrow_mmu,            
dcache_arb_ldc_borrow_prq,            
dcache_arb_ldc_borrow_sndb,           
dcache_arb_ldc_borrow_vb,             
dcache_arb_ldc_borrow_vld,            
dcache_arb_ldc_borrow_vld_gate,       
dcache_arb_ldc_borrow_wmb,            
dcache_arb_ldc_settle_way,            
dcache_idx,                             
dcache_lsu_ld_tag_dout,                                                                               
lag_ldc_ex1_addr1_to4,                        
lag_ldc_ex1_ahead_predict,                    
lag_ldc_ex1_already_da,                       
lag_ldc_ex1_atomic,                           
lag_ldc_ex1_boundary,                         
lag_ex1_dc_access_size,                   
lag_ldc_ex1_acclr_en,                      
lag_ldc_ex1_addr0,                         
lag_ldc_ex1_bytes_vld,                     
lag_ldc_ex1_bytes_vld1,                    
lag_ldc_ex1_bytes_vld2,                    
lag_ldc_ex1_bytes_vld3,                    
lag_ldc_ex1_inst_us,
lag_ldc_ex1_fwd_bypass_en,                 
lag_ldc_ex1_inst_vld,                      
lag_ldc_ex1_load_ahead_inst_vld,           
lag_ldc_ex1_load_inst_vld,                 
lag_ldc_ex1_mmu_req,                       
lag_ldc_ex1_page_so,                       
lag_ldc_ex1_rot_sel,                       
lag_ldc_ex1_vload_ahead_inst_vld,          
lag_ldc_ex1_vload_inst_vld,                
lag_ldc_ex1_dtcm_hit,                         
lag_ldc_ex1_element_cnt,                      
lag_ldc_ex1_element_offset,                   
lag_ldc_ex1_element_size,                     
lag_ldc_ex1_expt_access_fault_with_page,      
lag_ldc_ex1_expt_ldamo_not_ca,                
lag_ldc_ex1_expt_misalign_no_page,            
lag_ldc_ex1_expt_misalign_with_page,          
lag_ldc_ex1_expt_page_fault,                  
lag_ldc_ex1_expt_vld,                         
lag0_ex1_iid,                              
lag_ldc_ex1_inst_fof,                         
lag_ldc_ex1_inst_type,                        
lag_ldc_ex1_inst_vfls,                        
lag_ex1_inst_vld,                         
lag_ldc_ex1_inst_vls,                         
lag_ldc_ex1_itcm_hit,                         
lag_ldc_ex1_ldfifo_pc,                        
lag_ldc_ex1_lsid,                                             
lag_ldc_ex1_lsiq_spec_fail,                   
lag_ldc_ex1_no_spec,                          
lag_ldc_ex1_no_spec_exist,                    
lag_ldc_ex1_old,                              
lag_ldc_ex1_page_buf,                         
lag_ldc_ex1_page_ca,                          
lag_ldc_ex1_page_sec,                         
lag_ldc_ex1_page_share,                       
lag_ldc_ex1_pf_inst,                          
lag_ldc_ex1_preg,                             
lag_ldc_ex1_raw0_new,  
lag_ldc_ex1_raw1_new,                           
lag_ldc_ex1_reg_bytes_vld,                    
lag_ldc_ex1_reg_bytes_vld1,                    
lag_ldc_ex1_reg_bytes_vld2,                    
lag_ldc_ex1_reg_bytes_vld3,                    
lag_ldc_ex1_us_way,
lag_ldc_ex1_secd,                             
lag_ldc_ex1_sext,                      
lag_ldc_ex1_split,                            
lag_ldc_ex1_utlb_miss,                        
lag_ldc_ex1_vlmul,                            
lag_ldc_ex1_vmb_id,                           
lag_ldc_ex1_vmb_merge_vld,                    
lag_ldc_ex1_vpn,                              
lag_ldc_ex1_vreg,                             
//lag_ldc_ex1_vsew, //rvv1.0 @hcl 
lag_ldc_ex1_vmew,//rvv1.0 @hcl
lag_ldc_ex1_vmop,//rvv1.0 @hcl
lq_ldc_create_entry,                  
lq_ldc_ex2_full,                          
lq_ldc_ex2_inst_hit,                      
lq_ldc_ex2_less2,                         
lq_ldc0_ex2_rar_spec_fail,                                               
lsu_has_fence,                          
mmu_lsu_data_req_size,                  
mmu_lsu_mmu_en,                         
mmu_lsu_tlb_busy,                       
mmu_lsu_imme_wakeup, // wjh@tmq
pad_yy_icg_scan_en,                     
pfu_pfb_empty,                          
pfu_sdb_create_gateclk_en,              
pfu_sdb_empty,                          
rb_fence_ld,                            
rtu_lsu_flush_fe,                       
rtu_ck_flush,
rtu_ck_flush_iid,
sq_ldc_ex2_addr1_dep_discard,             
sq_ldc_ex2_cancel_acc_req,                
sq_ldc_ex2_cancel_ahead_wb,               
sq_ldc_ex2_fwd_req,                       
sq_ldc_ex2_has_fwd_req,                   
lsdc0_ex2_addr0, 
lsdc1_ex2_addr0,                            
lsdc0_ex2_bytes_vld, 
lsdc1_ex2_bytes_vld,                        
lsdc0_ex2_chk_st_inst_vld,  
lsdc1_ex2_chk_st_inst_vld,                 
lsdc0_ex2_chk_statomic_inst_vld,   
lsdc1_ex2_chk_statomic_inst_vld,          
lsdc0_ex2_inst_vld,        
lsdc1_ex2_inst_vld, 
lsdc0_ex2_is_load,        
lsdc1_ex2_is_load,                    
wmb_dcache_get_data,                    
wmb_fwd_bytes_vld,                      
wmb_ld_dc_cancel_acc_req,               
wmb_ld_dc_discard_req,                  
wmb_ldc_fwd_req,  
ld_dc_lq_create1_dp_vld,                
ldc_lq_ex2_create1_gateclk_en,            
ld_dc_lq_create1_vld,                   
ldc_lq_ex2_create_dp_vld,                 
ldc_lq_ex2_create_gateclk_en,             
ldc_lq_ex2_create_vld,                    
ldc_ex2_full_gateclk_en,     
ldc_ex2_addr0,                            
ldc_ex2_addr1,                            
ldc_ex2_addr1_11to4,                      
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
ldc_ex2_bytes_vld,                        
ldc_ex2_bytes_vld1,                                       
ldc_ex2_bytes_vld2,                                       
ldc_ex2_bytes_vld3,                                       
ldc_ex2_chk_atomic_inst_vld,              
ldc_ex2_chk_ld_addr1_vld,                 
ldc_sq_ex2_chk_ld_bypass_vld,                
ldc_ex2_chk_ld_inst_vld,                  
ldc_lda_ex2_bytes_vld,                     
ldc_lda_ex2_bytes_vld1,                                                
ldc_lda_ex2_bytes_vld2,                                                
ldc_lda_ex2_bytes_vld3,                                                
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
//ldc_hit_way0,
ldc_hit_way,                         
ldc_idu_ex2_lq_full,                      
ldc_idu_ex2_tlb_busy,                     
ldc_ex2_iid,                              
ldc_ex2_imme_wakeup,                      
ldc_ex2_inst_chk_vld,                     
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
ldc_pfu_ex2_older_than_ls0,
ldc_pfu_ex2_older_than_ls1,
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
ldc_ex2_tlb_busy_gateclk_en,              
ldc_lda_ex2_vector_nop,                       
ldc_lda_ex2_vlmul,                            
ldc_lda_ex2_vmb_id,                           
ldc_lda_ex2_vmb_merge_vld,                    
ldc_lda_ex2_vreg,                             
ldc_lda_ex2_vreg_sign_sel,                    
//ldc_lda_ex2_vsew,   //rvv1.0 @hcl  
ldc_lda_ex2_vmew,    //rvv1.0 @hcl
ldc_lda_ex2_vmop,     //rvv1.0 @hcl                          
ldc_lda_ex2_wait_fence,                       
lsu_idu_ex2_load_fwd_inst_vld, 
lsu_idu_ex2_load_inst_vld,    
lsu_idu_ex2_vload_fwd_inst_vld,    
lsu_idu_ex2_vload_inst_vld,  
lsu_idu_ex2_preg,
lsu_idu_ex2_vreg,          
lsu_mmu_vabuf0,  
ld_dc_cb_addr_create_gateclk_en,        
ld_dc_cb_addr_create_vld,               
ld_dc_cb_addr_tto4,   
ld_dc_da_cb_addr_create,                
ld_dc_da_cb_merge_en,
//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
//input
dtu_lsu_addr_trig_en,
dtu_lsu_data_trig_en,
ld_ag_boundary_unmask,
ld_ag_dtu_access_size,
ld_ag_dtu_last_check, 
ld_ag_dtu_type,       
ld_ag_dtu_va,         
ld_ag_dtu_vld,        
ld_ag_halt_info,      
//output
ld_dc_boundary_unmask,
ld_dc_dtu_addr,
ld_dc_dtu_addr_bytes_vld,
ld_dc_dtu_addr_halt_info,
ld_dc_dtu_addr_last_check,
ld_dc_dtu_addr_size,
ld_dc_dtu_addr_type,
ld_dc_dtu_addr_vld  
//==========================================================
//                  Risc-V Debug zdb End
//==========================================================
);
                      
input                                             rtu_ck_flush;
input   [IID_WIDTH-1  :0]                         rtu_ck_flush_iid;              
input                                             cb_ld_dc_addr_hit;   
input                                             lsu_dcache_ld_xx_gwen;                 
input                                             cp0_lsu_da_fwd_dis;                     
input                                             cp0_lsu_dcache_en;                      
input                                             cp0_lsu_ecc_en;                         
input                                             cp0_lsu_icg_en;  
input                                             icc_dcache_arb_ecc_read;   
input                                             icc_dcache_arb_ld_tag_read;                         
input                                             cpurst_b;                               
input                                             ctrl_ld_clk;  
input                                             forever_cpuclk;                              
input   [VB_DATA_ENTRY-1 :0]                      dcache_arb_ldc_borrow_db;             
input                                             dcache_arb_ldc_borrow_icc;            
input   [1 :0]                                    dcache_arb_ldc_borrow_idx_5to4;       
input                                             dcache_arb_ldc_borrow_mmu;            
input                                             dcache_arb_ldc_borrow_prq;            
input                                             dcache_arb_ldc_borrow_sndb;           
input                                             dcache_arb_ldc_borrow_vb;             
input                                             dcache_arb_ldc_borrow_vld;            
input                                             dcache_arb_ldc_borrow_vld_gate;       
input                                             dcache_arb_ldc_borrow_wmb;            
input   [1 :0]                                    dcache_arb_ldc_settle_way;   //1bit->2bit, L1D 2way->4way, LTL@20250319          
input   [7 :0]                                    dcache_idx;                  //8->7, 2way->4way, LTL@20250319           
input   [`WK_LS_DCACHE_LDTAG_WIDTH-1:0]           dcache_lsu_ld_tag_dout;      //67->135, 2way->4way, LTL@20250319                                                                        
input   [`WK_PA_WIDTH-5:0]                        lag_ldc_ex1_addr1_to4;                        
input                                             lag_ldc_ex1_ahead_predict;                    
input                                             lag_ldc_ex1_already_da;                       
input                                             lag_ldc_ex1_atomic;                           
input                                             lag_ldc_ex1_boundary;                         
input   [2 :0]                                    lag_ex1_dc_access_size;                   
input                                             lag_ldc_ex1_acclr_en;                      
input   [`WK_PA_WIDTH-1:0]                        lag_ldc_ex1_addr0;                         
input   [15:0]                                    lag_ldc_ex1_bytes_vld;                     
input   [15:0]                                    lag_ldc_ex1_bytes_vld1;                    
input   [15:0]                                    lag_ldc_ex1_bytes_vld2;                    
input   [15:0]                                    lag_ldc_ex1_bytes_vld3;                    
input                                             lag_ldc_ex1_inst_us;
input                                             lag_ldc_ex1_fwd_bypass_en;                 
input                                             lag_ldc_ex1_inst_vld;                      
input                                             lag_ldc_ex1_load_ahead_inst_vld;           
input                                             lag_ldc_ex1_load_inst_vld;                 
input                                             lag_ldc_ex1_mmu_req;                       
input                                             lag_ldc_ex1_page_so;                       
input   [3 :0]                                    lag_ldc_ex1_rot_sel;                       
input                                             lag_ldc_ex1_vload_ahead_inst_vld;          
input                                             lag_ldc_ex1_vload_inst_vld;                
input                                             lag_ldc_ex1_dtcm_hit;                         
input   [8 :0]                                    lag_ldc_ex1_element_cnt;                      
input   [3 :0]                                    lag_ldc_ex1_element_offset;                   
input   [1 :0]                                    lag_ldc_ex1_element_size;                     
input                                             lag_ldc_ex1_expt_access_fault_with_page;      
input                                             lag_ldc_ex1_expt_ldamo_not_ca;                
input                                             lag_ldc_ex1_expt_misalign_no_page;            
input                                             lag_ldc_ex1_expt_misalign_with_page;          
input                                             lag_ldc_ex1_expt_page_fault;                  
input                                             lag_ldc_ex1_expt_vld;                         
input   [IID_WIDTH-1:0]                           lag0_ex1_iid;                              
input                                             lag_ldc_ex1_inst_fof;                         
input   [1 :0]                                    lag_ldc_ex1_inst_type;                        
input                                             lag_ldc_ex1_inst_vfls;                        
input                                             lag_ex1_inst_vld;                         
input                                             lag_ldc_ex1_inst_vls;                         
input                                             lag_ldc_ex1_itcm_hit;                         
input   [PC_LEN-1:0]                              lag_ldc_ex1_ldfifo_pc;                        
input   [LSIQENTRY-1:0]                           lag_ldc_ex1_lsid;                                           
input                                             lag_ldc_ex1_lsiq_spec_fail;                   
input   [1 :0]                                    lag_ldc_ex1_no_spec;                          
input                                             lag_ldc_ex1_no_spec_exist;                    
input                                             lag_ldc_ex1_old;                              
input                                             lag_ldc_ex1_page_buf;                         
input                                             lag_ldc_ex1_page_ca;                          
input                                             lag_ldc_ex1_page_sec;                         
input                                             lag_ldc_ex1_page_share;                       
input                                             lag_ldc_ex1_pf_inst;                          
input   [PREG-1:0]                                lag_ldc_ex1_preg;                             
input                                             lag_ldc_ex1_raw0_new;  
input                                             lag_ldc_ex1_raw1_new;                           
input   [15:0]                                    lag_ldc_ex1_reg_bytes_vld;                    
input   [15:0]                                    lag_ldc_ex1_reg_bytes_vld1;                    
input   [15:0]                                    lag_ldc_ex1_reg_bytes_vld2;                    
input   [15:0]                                    lag_ldc_ex1_reg_bytes_vld3;                    
input   [3 :0]                                    lag_ldc_ex1_us_way;
input                                             lag_ldc_ex1_secd;                             
input                                             lag_ldc_ex1_sext;                      
input                                             lag_ldc_ex1_split;                            
input                                             lag_ldc_ex1_utlb_miss;                        
// input   [1 :0]                                    lag_ldc_ex1_vlmul;     
input   [2 :0]             lag_ldc_ex1_vlmul;  //pwh 1 for rvv1.0                      
input   [VMBENTRY-1:0]                            lag_ldc_ex1_vmb_id;                           
input                                             lag_ldc_ex1_vmb_merge_vld;                    
input   [`WK_PA_WIDTH-13:0]                       lag_ldc_ex1_vpn;                              
input   [VREG-1:0]                                lag_ldc_ex1_vreg;                             
//input   [1 :0]                                    lag_ldc_ex1_vsew;//rvv1.0 @hcl  
input   [1 :0]             lag_ldc_ex1_vmew;//rvv1.0 @hcl
input   [1 :0]             lag_ldc_ex1_vmop;  //rvv1.0 @hcl                         
input   [LQENTRY-1:0]                             lq_ldc_create_entry;                  
input                                             lq_ldc_ex2_full;                          
input                                             lq_ldc_ex2_inst_hit;                      
input                                             lq_ldc_ex2_less2;                         
input                                             lq_ldc0_ex2_rar_spec_fail;                                               
input                                             lsu_has_fence;                          
input                                             mmu_lsu_data_req_size;                  
input                                             mmu_lsu_mmu_en;                         
input                                             mmu_lsu_tlb_busy;                       
input                                             mmu_lsu_imme_wakeup; // wjh@tmq
input                                             pad_yy_icg_scan_en;                     
input                                             pfu_pfb_empty;                          
input                                             pfu_sdb_create_gateclk_en;              
input                                             pfu_sdb_empty;                          
input                                             rb_fence_ld;                            
input                                             rtu_lsu_flush_fe;                       
input                                             sq_ldc_ex2_addr1_dep_discard;             
input                                             sq_ldc_ex2_cancel_acc_req;                
input                                             sq_ldc_ex2_cancel_ahead_wb;               
input                                             sq_ldc_ex2_fwd_req;                       
input                                             sq_ldc_ex2_has_fwd_req;                   
input   [`WK_PA_WIDTH-1:0]                        lsdc0_ex2_addr0; 
input   [`WK_PA_WIDTH-1:0]                        lsdc1_ex2_addr0;                            
input   [15:0]                                    lsdc0_ex2_bytes_vld; 
input   [15:0]                                    lsdc1_ex2_bytes_vld;                        
input                                             lsdc0_ex2_chk_st_inst_vld;  
input                                             lsdc1_ex2_chk_st_inst_vld;                 
input                                             lsdc0_ex2_chk_statomic_inst_vld;   
input                                             lsdc1_ex2_chk_statomic_inst_vld;          
input                                             lsdc0_ex2_inst_vld;        
input                                             lsdc1_ex2_inst_vld; 
input                                             lsdc0_ex2_is_load;        
input                                             lsdc1_ex2_is_load;                    
input   [3 :0]                                    wmb_dcache_get_data;                    
input   [15:0]                                    wmb_fwd_bytes_vld;                      
input                                             wmb_ld_dc_cancel_acc_req;               
input                                             wmb_ld_dc_discard_req;                  
input                                             wmb_ldc_fwd_req;  
output                                            ld_dc_lq_create1_dp_vld;                
output                                            ldc_lq_ex2_create1_gateclk_en;            
output                                            ld_dc_lq_create1_vld;                   
output                                            ldc_lq_ex2_create_dp_vld;                 
output                                            ldc_lq_ex2_create_gateclk_en;             
output                                            ldc_lq_ex2_create_vld;                    
output                                            ldc_ex2_full_gateclk_en;     
output  [`WK_PA_WIDTH-1:0]                        ldc_ex2_addr0;                            
output  [`WK_PA_WIDTH-1:0]                        ldc_ex2_addr1;                            
output  [7 :0]                                    ldc_ex2_addr1_11to4;                      
output                                            ldc_lda_ex2_ahead_predict;                    
output                                            ldc_lda_ex2_ahead_preg_wb_vld;                
output                                            ldc_lda_ex2_ahead_vreg_wb_vld;                
output                                            ldc_lda_ex2_already_da;                       
output                                            ldc_lda_ex2_atomic;                                                
output [VB_DATA_ENTRY-1 :0]                       ldc_lda_ex2_borrow_db;                        
output                                            ldc_lda_ex2_borrow_icc;                       
output                                            ldc_lda_ex2_borrow_icc_ecc;                   
output                                            ldc_lda_ex2_borrow_icc_tag;                   
output  [1 :0]                                    ldc_lda_ex2_borrow_idx_5to4;                  
output                                            ldc_lda_ex2_borrow_mmu;                       
output                                            ldc_lda_ex2_borrow_prq;                       
output                                            ldc_lda_ex2_borrow_sndb;                      
output                                            ldc_lda_ex2_borrow_vb;                        
output                                            ldc_ex2_borrow_vld;                       
output                                            ldc_lda_ex2_borrow_wmb;                       
output                                            ldc_lda_ex2_boundary;                         
output  [15:0]                                    ldc_ex2_bytes_vld;                        
output  [15:0]                                    ldc_ex2_bytes_vld1;                                       
output  [15:0]                                    ldc_ex2_bytes_vld2;                                       
output  [15:0]                                    ldc_ex2_bytes_vld3;                                       
output                                            ldc_ex2_chk_atomic_inst_vld;              
output                                            ldc_ex2_chk_ld_addr1_vld;                 
output                                            ldc_sq_ex2_chk_ld_bypass_vld;                
output                                            ldc_ex2_chk_ld_inst_vld;                  
output  [15:0]                                    ldc_lda_ex2_bytes_vld;                     
output  [15:0]                                    ldc_lda_ex2_bytes_vld1;                                                
output  [15:0]                                    ldc_lda_ex2_bytes_vld2;                                                
output  [15:0]                                    ldc_lda_ex2_bytes_vld3;                                                
output  [15:0]                                    ldc_lda_ex2_rot_sel;                  
output                                            ldc_lda_ex2_expt_vld_gate_en;              
output                                            ldc_lda_ex2_icc_tag_vld;                   
output                                            ldc_lda_ex2_inst_vld;                      
output  [LQENTRY-1:0]                             ldc_lda_ex2_lq_entry;                      
output                                            ldc_lda_ex2_old;                           
output                                            ldc_lda_ex2_page_buf;                      
output                                            ldc_lda_ex2_page_ca;                       
output                                            ldc_lda_ex2_page_sec;                      
output                                            ldc_lda_ex2_page_share;                    
output                                            ldc_lda_ex2_page_so;                       
output                                            ldc_lda_ex2_pf_inst;                       
output  [`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0]    ldc_lda_ex2_tag_read;                      
output                                            ldc_lda_ex2_data_inj_dp;                      
output                                            ldc_lda_ex2_dcache_hit;                       
output                                            ldc_lda_ex2_dtcm_hit;                         
output  [8 :0]                                    ldc_lda_ex2_element_cnt;                      
output  [1 :0]                                    ldc_lda_ex2_element_size;                     
output                                            ldc_lda_ex2_expt_access_fault_extra;          
output                                            ldc_lda_ex2_expt_access_fault_mask;           
output  [4 :0]                                    ldc_lda_ex2_expt_vec;                         
output                                            ldc_lda_ex2_expt_vld_except_access_err;       
output  [15:0]                                    ldc_lda_ex2_fwd_bytes_vld;                    
output                                            ldc_lda_ex2_fwd_sq_vld;                       
output                                            ldc_lda_ex2_fwd_wmb_vld;                      
output  [3 :0]                                    ldc_lda_ex2_get_dcache_data;                  
//output                     ldc_lda_ex2_hit_high_region;                  
//output                     ldc_lda_ex2_hit_low_region;
output                                            ldc_lda_ex2_hit_3_region;                  
output                                            ldc_lda_ex2_hit_2_region;
output                                            ldc_lda_ex2_hit_1_region;                  
output                                            ldc_lda_ex2_hit_0_region;
output  [3 :0]                                    ldc_hit_way;                    
//output                     ldc_hit_way0;                         
output  [LSIQENTRY-1:0]                           ldc_idu_ex2_lq_full;                      
output  [LSIQENTRY-1:0]                           ldc_idu_ex2_tlb_busy;                     
output  [IID_WIDTH-1:0]                           ldc_ex2_iid;                              
output  [LSIQENTRY-1:0]                           ldc_ex2_imme_wakeup;                      
output                                            ldc_ex2_inst_chk_vld;                     
output                                            ldc_lda_ex2_inst_fof;                         
output  [2 :0]                                    ldc_lda_ex2_inst_size;                        
output  [1 :0]                                    ldc_lda_ex2_inst_type;                        
output                                            ldc_lda_ex2_inst_vfls;                        
output                                            ldc_ex2_inst_vld;                         
output                                            ldc_lda_ex2_inst_vls;                         
output                                            ldc_lda_ex2_itcm_hit;                         
output  [PC_LEN-1:0]                              ldc_lda_ex2_ldfifo_pc;                                  
output  [LSIQENTRY-1:0]                           ldc_lda_ex2_lsid;                             
output                                            ldc_lda_ex2_mmu_req;                          
output  [`WK_PA_WIDTH-1:0]                        ldc_lda_ex2_mtval;                         
output  [1 :0]                                    ldc_lda_ex2_no_spec;                          
output                                            ldc_lda_ex2_no_spec_exist;                    
output                                            ldc_lda_ex2_pfu_info_set_vld;                 
output  [`WK_PA_WIDTH-1:0]                        ldc_lda_ex2_pfu_va;                           
output                                            ldc_pfu_ex2_older_than_ls0;
output                                            ldc_pfu_ex2_older_than_ls1;
output  [PREG-1:0]                                ldc_lda_ex2_preg;                             
output  [3 :0]                                    ldc_lda_ex2_preg_sign_sel;                    
output  [15:0]                                    ldc_lda_ex2_reg_bytes_vld;                    
output  [15:0]                                    ldc_lda_ex2_reg_bytes_vld1;                    
output  [15:0]                                    ldc_lda_ex2_reg_bytes_vld2;                    
output  [15:0]                                    ldc_lda_ex2_reg_bytes_vld3;                    
output                                            ldc_lda_ex2_inst_us;
output                                            ldc_lda_ex2_us_discard;
output                                            ldc_ex2_secd;                             
output  [1 :0]                                    ldc_lda_ex2_settle_way;     //1bit->2bit, L1D 2way->4way, LTL@20250319                
output  [8 :0]                                    ldc_lda_ex2_setvl_val;                        
output                                            ldc_lda_ex2_sext;                      
output                                            ldc_lda_ex2_spec_fail;                        
output                                            ldc_lda_ex2_split;                            
output                                            ldc_lda_ex2_tag_inj_dp;                       
output                                            ldc_ex2_tlb_busy_gateclk_en;              
output                                            ldc_lda_ex2_vector_nop;                       
// output  [1 :0]                                    ldc_lda_ex2_vlmul;    
output  [2 :0]             ldc_lda_ex2_vlmul;  //pwh 2 for rvv1.0                       
output  [VMBENTRY-1:0]                            ldc_lda_ex2_vmb_id;                           
output                                            ldc_lda_ex2_vmb_merge_vld;                    
output  [VREG-1:0]                                ldc_lda_ex2_vreg;                             
output                                            ldc_lda_ex2_vreg_sign_sel;                    
//output  [1 :0]                                    ldc_lda_ex2_vsew;   //rvv1.0 @hcl 
output  [1 :0]             ldc_lda_ex2_vmew;   //rvv1.0 @hcl 
output  [1 :0]             ldc_lda_ex2_vmop;   //rvv1.0 @hcl                          
output                                            ldc_lda_ex2_wait_fence;                       
output                                            lsu_idu_ex2_load_fwd_inst_vld; 
output                                            lsu_idu_ex2_load_inst_vld;    
output                                            lsu_idu_ex2_vload_fwd_inst_vld;    
output                                            lsu_idu_ex2_vload_inst_vld;  
output  [PREG-1:0]                                lsu_idu_ex2_preg;
output  [VREG:0]                                  lsu_idu_ex2_vreg;          
output  [`WK_PA_WIDTH-13:0]                       lsu_mmu_vabuf0;  
output                                            ld_dc_cb_addr_create_gateclk_en;        
output                                            ld_dc_cb_addr_create_vld;               
output  [`WK_PA_WIDTH-5:0]                        ld_dc_cb_addr_tto4;   
output                                            ld_dc_da_cb_addr_create;                
output                                            ld_dc_da_cb_merge_en; 


// &Regs; @29
reg                                               ldc_acclr_en;                         
reg     [`WK_PA_WIDTH-1:0]                        ldc_ex2_addr0;                            
reg     [`WK_PA_WIDTH-5:0]                        ldc_addr1_tto4;                       
reg                                               ldc_lda_ex2_ahead_predict;                    
reg                                               ldc_lda_ex2_already_da;                       
reg                                               ldc_lda_ex2_atomic;                           
reg     [VB_DATA_ENTRY-1 :0]                      ldc_lda_ex2_borrow_db;                        
reg                                               ldc_lda_ex2_borrow_icc;                       
reg                                               ldc_lda_ex2_borrow_icc_ecc;                   
reg                                               ldc_lda_ex2_borrow_icc_tag;                   
reg     [1 :0]                                    ldc_lda_ex2_borrow_idx_5to4;                  
reg                                               ldc_lda_ex2_borrow_mmu;                       
reg                                               ldc_lda_ex2_borrow_prq;                       
reg                                               ldc_lda_ex2_borrow_sndb;                      
reg                                               ldc_lda_ex2_borrow_vb;                        
reg                                               ldc_ex2_borrow_vld;                       
reg                                               ldc_lda_ex2_borrow_wmb;                       
reg     [3 :0]                                    ldc_lda_ex2_borrow_wmb_get_data;              
reg                                               ldc_lda_ex2_boundary;                         
reg     [15:0]                                    ldc_ex2_bytes_vld;                        
reg     [15:0]                                    ldc_ex2_bytes_vld1;                       
reg     [15:0]                                    ldc_ex2_bytes_vld2;                       
reg     [15:0]                                    ldc_ex2_bytes_vld3;                       
reg                                               ldc_lda_ex2_inst_us;
wire                                              ldc_lda_ex2_us_discard;
reg     [15:0]                                    ldc_lda_ex2_rot_sel;                  
reg                                               ldc_lda_ex2_dtcm_hit;                         
reg     [8 :0]                                    ldc_lda_ex2_element_cnt;                      
reg     [3 :0]                                    ldc_secd_element_offset;                   
reg     [1 :0]                                    ldc_lda_ex2_element_size;                     
reg                                               ldc_expt_access_fault_with_page;      
reg                                               ldc_expt_ldamo_not_ca;                
reg                                               ldc_expt_misalign_no_page;            
reg                                               ldc_expt_misalign_with_page;          
reg                                               ldc_expt_page_fault;                  
reg     [4 :0]                                    ldc_lda_ex2_expt_vec;                         
reg                                               ldc_lda_ex2_expt_vld_except_access_err;       
reg     [3 :0]                                    ldc_first_byte;                       
reg                                               ldc_fwd_bypass_en;                    
reg     [15:0]                                    ldc_lda_ex2_fwd_bytes_vld;                    
reg     [IID_WIDTH-1:0]                           ldc_ex2_iid;                              
reg                                               ldc_lda_ex2_inst_fof;                         
reg     [2 :0]                                    ldc_lda_ex2_inst_size;                        
reg     [1 :0]                                    ldc_lda_ex2_inst_type;                        
reg                                               ldc_lda_ex2_inst_vfls;                        
reg                                               ldc_ex2_inst_vld;                         
reg                                               ldc_lda_ex2_inst_vls;                                                      
reg                                               ldc_lda_ex2_itcm_hit;                         
reg     [PC_LEN-1:0]                              ldc_lda_ex2_ldfifo_pc;                        
reg                                               ldc_load_ahead_inst_vld;         
reg                                               ld_dc_load_ahead_inst_vld_dup2;         
reg                                               ld_dc_load_ahead_inst_vld_dup3;         
reg                                               ld_dc_load_ahead_inst_vld_dup4;         
reg                                               ldc_load_inst_vld;               
reg                                               ld_dc_load_inst_vld_dup1;               
reg                                               ld_dc_load_inst_vld_dup2;               
reg                                               ld_dc_load_inst_vld_dup3;               
reg                                               ld_dc_load_inst_vld_dup4;               
reg     [LSIQENTRY-1:0]                           ldc_lda_ex2_lsid;                                             
reg                                               ldc_lsiq_spec_fail;                   
reg                                               ldc_lda_ex2_mmu_req;                          
reg     [`WK_PA_WIDTH-1:0]                        ldc_lda_ex2_mtval;                         
reg     [1 :0]                                    ldc_lda_ex2_no_spec;                          
reg                                               ldc_lda_ex2_no_spec_exist;                    
reg                                               ldc_old;                              
reg                                               ldc_page_buf;                         
reg                                               ldc_page_ca;                          
reg                                               ldc_page_sec;                         
reg                                               ldc_page_share;                       
reg                                               ldc_page_so;                          
reg                                               ld_dc_pf_inst;                          
reg     [PREG-1:0]                                ldc_lda_ex2_preg;                                                             
reg     [3 :0]                                    ldc_lda_ex2_preg_sign_sel;                    
reg                                               ldc_raw0_new; 
reg                                               ldc_raw1_new;                          
reg     [15:0]                                    ldc_lda_ex2_reg_bytes_vld;                    
reg     [15:0]                                    ldc_lda_ex2_reg_bytes_vld1;                    
reg     [15:0]                                    ldc_lda_ex2_reg_bytes_vld2;                    
reg     [15:0]                                    ldc_lda_ex2_reg_bytes_vld3;                    
reg     [3 :0]                                    ldc_ex2_us_way;
reg     [3 :0]                                    ldc_rot_sel;                          
reg                                               ldc_ex2_secd;                             
wire    [1 :0]                                    ldc_lda_ex2_settle_way;    //1bit->2bit, L1D 2way->4way, LTL@20250319                    
reg     [1 :0]                                    ldc_ex2_borrow_way;
reg                                               ldc_lda_ex2_sext;                      
reg                                               ldc_lda_ex2_split;                            
reg                                               ldc_tlb_busy;                         
reg                                               ldc_tlb_imme_wakeup; // wjh@tmq
reg                                               ldc_utlb_miss;                        
// reg     [1 :0]                                    ldc_lda_ex2_vlmul;  
reg     [2 :0]             ldc_lda_ex2_vlmul;                           
reg                                               ldc_vload_ahead_inst_vld;             
reg                                               ldc_vload_inst_vld;                          
reg     [VMBENTRY-1:0]                            ldc_lda_ex2_vmb_id;                           
reg                                               ldc_lda_ex2_vmb_merge_vld;                    
reg     [`WK_PA_WIDTH-13:0]                       ldc_vpn;                              
reg     [VREG-1:0]                                ldc_lda_ex2_vreg;                                                               
//reg     [1 :0]                                    ldc_lda_ex2_vsew;   // rvv1.0 @hcl 
reg     [1 :0]             ldc_lda_ex2_vmew;   // rvv1.0 @hcl 
reg     [1 :0]             ldc_lda_ex2_vmop;   // rvv1.0 @hcl                            
reg                                               ld_first_byte_unalign;                  
reg     [3 :0]                                    ld_first_element_ori;                   
reg     [15:0]                                    mmu_bytes_vld;                          
reg     [3 :0]                                    setvl_val_low;                          
reg                                               ldc_lda_ex2_hit_3_region;
reg                                               ldc_lda_ex2_hit_2_region;
reg                                               ldc_lda_ex2_hit_1_region;
reg                                               ldc_lda_ex2_hit_0_region;
reg     [`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0]    ldc_lda_ex2_tag_read;
// &Wires; @30
wire                                              cb_create_hit_idx;                      
wire                                              cb_ld_dc_addr_hit; 
wire                                              lsu_dcache_ld_xx_gwen;                      
wire                                              cp0_lsu_da_fwd_dis;                     
wire                                              cp0_lsu_dcache_en;                      
wire                                              cp0_lsu_ecc_en;                         
wire                                              cp0_lsu_icg_en;  
wire                                              icc_dcache_arb_ecc_read;                
wire                                              icc_dcache_arb_ld_tag_read;                          
wire                                              cpurst_b;                               
wire                                              ctrl_ld_clk;   
wire                                              forever_cpuclk;                           
wire    [VB_DATA_ENTRY-1 :0]                      dcache_arb_ldc_borrow_db;             
wire                                              dcache_arb_ldc_borrow_icc;            
wire    [1 :0]                                    dcache_arb_ldc_borrow_idx_5to4;       
wire                                              dcache_arb_ldc_borrow_mmu;            
wire                                              dcache_arb_ldc_borrow_prq;            
wire                                              dcache_arb_ldc_borrow_sndb;           
wire                                              dcache_arb_ldc_borrow_vb;             
wire                                              dcache_arb_ldc_borrow_vld;            
wire                                              dcache_arb_ldc_borrow_vld_gate;       
wire                                              dcache_arb_ldc_borrow_wmb;            
wire    [1 :0]                                    dcache_arb_ldc_settle_way;  //1bit->2bit, L1D 2way->4way, LTL@20250319           
wire    [7 :0]                                    dcache_idx;                 //8->7, 2way->4way, LTL@20250319            
wire    [`WK_LS_DCACHE_LDTAG_WIDTH-1:0]           dcache_lsu_ld_tag_dout;     //67->135, 2way->4way, LTL@20250319                                                        
          
wire    [`WK_PA_WIDTH-5:0]                        lag_ldc_ex1_addr1_to4;                        
wire                                              lag_ldc_ex1_ahead_predict;                    
wire                                              lag_ldc_ex1_already_da;                       
wire                                              lag_ldc_ex1_atomic;                           
wire                                              lag_ldc_ex1_boundary;                         
wire    [2 :0]                                    lag_ex1_dc_access_size;                   
wire                                              lag_ldc_ex1_acclr_en;                      
wire    [`WK_PA_WIDTH-1:0]                        lag_ldc_ex1_addr0;                         
wire    [15:0]                                    lag_ldc_ex1_bytes_vld;                     
wire    [15:0]                                    lag_ldc_ex1_bytes_vld1;                    
wire    [15:0]                                    lag_ldc_ex1_bytes_vld2;                    
wire    [15:0]                                    lag_ldc_ex1_bytes_vld3;                    
wire                                              lag_ldc_ex1_inst_us;
wire                                              lag_ldc_ex2_fwd_bypass_en;                 
wire                                              lag_ldc_ex1_inst_vld;                      
wire                                              lag_ldc_ex1_load_ahead_inst_vld;           
wire                                              lag_ldc_ex1_load_inst_vld;                 
wire                                              lag_ldc_ex1_mmu_req;                       
wire                                              lag_ldc_ex1_page_so;                       
wire    [3 :0]                                    lag_ldc_ex1_rot_sel;                       
wire                                              lag_ldc_ex1_vload_ahead_inst_vld;          
wire                                              lag_ldc_ex1_vload_inst_vld;                
wire                                              lag_ldc_ex1_dtcm_hit;                         
wire    [8 :0]                                    lag_ldc_ex1_element_cnt;                      
wire    [3 :0]                                    lag_ldc_ex1_element_offset;                   
wire    [1 :0]                                    lag_ldc_ex1_element_size;                     
wire                                              lag_ldc_ex1_expt_access_fault_with_page;      
wire                                              lag_ldc_ex1_expt_ldamo_not_ca;                
wire                                              lag_ldc_ex1_expt_misalign_no_page;            
wire                                              lag_ldc_ex1_expt_misalign_with_page;          
wire                                              ldg_ldc_ex1_expt_page_fault;                  
wire                                              lag_ldc_ex1_expt_vld;                         
wire    [IID_WIDTH-1:0]                           lag0_ex1_iid;                              
wire                                              lag_ldc_ex1_inst_fof;                         
wire    [1 :0]                                    lag_ldc_ex1_inst_type;                        
wire                                              lag_ldc_ex1_inst_vfls;                        
wire                                              lag_ex1_inst_vld;                         
wire                                              lag_ldc_ex1_inst_vls;                         
wire                                              lag_ldc_ex1_itcm_hit;                         
wire    [PC_LEN-1:0]                              lag_ldc_ex1_ldfifo_pc;                        
wire    [LSIQENTRY-1:0]                           lag_ldc_ex1_lsid;                                              
wire                                              lag_ldc_ex1_lsiq_spec_fail;                   
wire    [1 :0]                                    lag_ldc_ex1_no_spec;                          
wire                                              lag_ldc_ex1_no_spec_exist;                    
wire                                              lag_ldc_ex1_old;                              
wire                                              lag_ldc_ex1_page_buf;                         
wire                                              lag_ldc_ex1_page_ca;                          
wire                                              lag_ldc_ex1_page_sec;                         
wire                                              lag_ldc_ex1_page_share;                       
wire                                              lag_ldc_ex1_pf_inst;                          
wire    [PREG-1:0]                                lag_ldc_ex1_preg;                             
wire                                              lag_ldc_ex1_raw0_new;     
wire                                              lag_ldc_ex1_raw1_new;                        
wire    [15:0]                                    lag_ldc_ex1_reg_bytes_vld;                    
wire    [15:0]                                    lag_ldc_ex1_reg_bytes_vld1;                    
wire    [15:0]                                    lag_ldc_ex1_reg_bytes_vld2;                    
wire    [15:0]                                    lag_ldc_ex1_reg_bytes_vld3;                    
wire    [3 :0]                                    lag_ldc_ex1_us_way;
wire                                              lag_ldc_ex1_secd;                             
wire                                              lag_ldc_ex1_sext;                      
wire                                              lag_ldc_ex1_split;                            
wire                                              lag_ldc_ex1_utlb_miss;                        
// wire    [1 :0]                                    lag_ldc_ex1_vlmul;     
wire    [2 :0]             lag_ldc_ex1_vlmul;                        
wire    [VMBENTRY-1:0]                            lag_ldc_ex1_vmb_id;                           
wire                                              lag_ldc_ex1_vmb_merge_vld;                    
wire    [`WK_PA_WIDTH-13:0]                       lag_ldc_ex1_vpn;                              
wire    [VREG-1:0]                                lag_ldc_ex1_vreg;                             
//wire    [1 :0]                                    lag_ldc_ex1_vsew; //rvv1.0 @hcl
wire    [1 :0]             lag_ldc_ex1_vmew;//rvv1.0 @hcl
wire    [1 :0]             lag_ldc_ex1_vmop;//rvv1.0 @hcl                          
wire    [`WK_PA_WIDTH-1:0]                        ldc_ex2_addr1;                            
wire    [7 :0]                                    ldc_ex2_addr1_11to4;                      
wire                                              ldc_lda_ex2_ahead_preg_wb_vld;                
wire                                              ldc_lda_ex2_ahead_vreg_wb_vld;                
wire                                              ldc_ahead_wb_vld;                                           
wire                                              ldc_borrow_clk;                       
wire                                              ldc_borrow_clk_en;                    
wire                                              ldc_borrow_mmu_vld;                   
wire                                              ldc_boundary_first;                   
wire                                              ld_dc_cb_addr_create_gateclk_en;        
wire                                              ld_dc_cb_addr_create_vld;               
wire    [`WK_PA_WIDTH-5:0]                        ld_dc_cb_addr_tto4;                     
wire                                              ldc_ex2_chk_atomic_inst_vld;              
wire                                              ldc_ex2_chk_ld_addr1_vld;                 
wire                                              ldc_sq_ex2_chk_ld_bypass_vld;                
wire                                              ldc_ex2_chk_ld_inst_vld;                  
wire                                              ldc_clk;                              
wire                                              ldc_clk_en;                           
wire    [`WK_PA_WIDTH-1:0]                        ldc_cmp_lsdc0_addr0;    
wire    [`WK_PA_WIDTH-1:0]                        ldc_cmp_lsdc1_addr0;                 
wire    [15:0]                                    ldc_lda_ex2_bytes_vld;                     
wire    [15:0]                                    ldc_lda_ex2_bytes_vld1;                    
wire    [15:0]                                    ldc_lda_ex2_bytes_vld2;                    
wire    [15:0]                                    ldc_lda_ex2_bytes_vld3;                    
wire                                              ld_dc_da_cb_addr_create;                
wire                                              ld_dc_da_cb_merge_en;                   
wire                                              ldc_lda_ex2_expt_vld_gate_en;              
wire                                              ldc_lda_ex2_icc_tag_vld;                   
wire                                              ldc_lda_ex2_inst_vld;                      
wire    [LQENTRY-1:0]                             ldc_lda_ex2_lq_entry;                      
wire                                              ldc_lda_ex2_old;                           
wire                                              ldc_lda_ex2_page_buf;                      
wire                                              ldc_lda_ex2_page_ca;                       
wire                                              ldc_lda_ex2_page_sec;                      
wire                                              ldc_lda_ex2_page_share;                    
wire                                              ldc_lda_ex2_page_so;                       
wire                                              ldc_lda_ex2_pf_inst;                                             
wire    [3 :0]                                    ldc_data_bias_sel;                    
wire                                              ldc_lda_ex2_data_inj_dp;                      
wire                                              ldc_lda_ex2_dcache_hit;                       
wire    [`WK_LS_DCACHE_LDTAG_WIDTH-1:0]           ldc_dcache_tag_array;    //67->135, L1D 2->4 way, LTL@20250321             
wire                                              ldc_dcache_valid0;   //L1D 2->4 way, LTL@20250323                 
wire                                              ldc_dcache_valid1;                    
wire                                              ldc_dcache_valid2;                    
wire                                              ldc_dcache_valid3;
wire                                              ldc_depd_imme_restart_req;            
wire                                              ldc_depd_imme_restart_vld;            
wire                                              ldc_depd_st_dc;                       
wire                                              ldc_depd0_st_dc2;   
wire                                              ldc_depd1_st_dc2;                    
wire                                              ldc_depd0_st_dc3; 
wire                                              ldc_depd1_st_dc3;                      
wire                                              ldc_dup_dcache_data_en;               
wire                                              ldc_lda_ex2_expt_access_fault_extra;          
wire                                              ldc_lda_ex2_expt_access_fault_mask;           
wire                                              ldc_expt_access_fault_short;          
wire                                              ldc_lda_ex2_fwd_sq_vld;                       
wire                                              ldc_lda_ex2_fwd_wmb_vld;                      
wire    [3 :0]                                    ldc_lda_ex2_get_dcache_data;                  
wire                                              ldc_get_dcache_data_all;              
wire    [3 :0]                                    ldc_get_dcache_data_inst_mmu;                           
//wire                       ldc_lda_ex2_hit_high_region;                  
//wire                       ldc_lda_ex2_hit_low_region;                       
wire                                              rtu_ck_flush;
wire    [IID_WIDTH-1:0]                           rtu_ck_flush_iid;
wire                                              rtu_ck_flush_iid_older_than_ex1_iid;
 
wire    [3 :0]                                    ldc_hit_way;                 
wire                                              ldc_hit_way0;                         
wire                                              ldc_hit_way1;
wire                                              ldc_hit_way2;                          
wire                                              ldc_hit_way3; 
wire    [LSIQENTRY-1:0]                           ldc_idu_ex2_lq_full;                      
wire    [LSIQENTRY-1:0]                           ldc_idu_ex2_tlb_busy;                     
wire                                              ldc_imme_restart_vld;                 
wire    [LSIQENTRY-1:0]                           ldc_ex2_imme_wakeup;                      
wire                                              ldc_ex2_inst_chk_vld;                     
wire                                              ldc_inst_clk;                         
wire                                              ldc_inst_clk_en;                      
wire                                              ldc_ld_inst;                          
wire                                              ldc_ldamo_inst;                       
wire                                              ld_dc_lq_create1_dp_vld;                
wire                                              ldc_lq_ex2_create1_gateclk_en;            
wire                                              ld_dc_lq_create1_vld;                   
wire                                              ldc_lq_ex2_create_dp_vld;                 
wire                                              ldc_lq_ex2_create_gateclk_en;             
wire                                              ldc_lq_ex2_create_vld;                    
wire                                              ldc_ex2_full_gateclk_en;               
wire                                              ldc_lq_full_req;                      
wire                                              ldc_lq_full_vld;                      
wire    [LSIQENTRY-1:0]                           ldc_mask_lsid;                        
wire                                              ldc_pf_inst_short;                    
wire                                              ldc_lda_ex2_pfu_info_set_vld;                 
wire    [`WK_PA_WIDTH-1:0]                        ldc_lda_ex2_pfu_va;                           
wire    [7 :0]                                    ldc_pfu_va_11to4;                                     
wire                                              ldc_raw0_addr1_tto4_hit; 
wire                                              ldc_raw1_addr1_tto4_hit;               
wire                                              ldc_raw0_addr_tto4_hit;    
wire                                              ldc_raw1_addr_tto4_hit;             
wire                                              ldc_raw0_do_hit;  
wire                                              ldc_raw1_do_hit;                      
wire                                              ldc_restart_vld;                      
wire    [3 :0]                                    ldc_rot_sel_final;                    
wire    [8 :0]                                    ldc_lda_ex2_setvl_val;                        
wire                                              ldc_lda_ex2_spec_fail;                        
wire                                              ldc_lda_ex2_tag_inj_dp;                       
wire                                              ldc_ex2_tlb_busy_gateclk_en;              
wire                                              ldc_tlb_busy_restart_vld;             
wire                                              ldc_utlb_miss_vld;                    
wire    [`WK_PA_WIDTH-1:0]                        ldc_va;                               
wire                                              ldc_lda_ex2_vector_nop;                       
wire                                              ldc_lda_ex2_vreg_sign_sel;                    
wire                                              ldc_lda_ex2_wait_fence;                       
wire                                              ldc_way0_tag_hit;                     
wire                                              ldc_way1_tag_hit;                     
wire                                              ldc_way2_tag_hit;                     
wire                                              ldc_way3_tag_hit;
wire    [3 :0]                                    ld_first_element;                       
wire    [LQENTRY-1:0]                             lq_ldc_create_entry;                  
wire                                              lq_ldc_ex2_full;                          
wire                                              lq_ldc_ex2_inst_hit;                      
wire                                              lq_ldc_ex2_less2;                         
wire                                              lq_ldc0_ex2_rar_spec_fail;                                      
wire                                              lsu_has_fence;                          
wire                                              lsu_idu_ex2_load_fwd_inst_vld; 
wire                                              lsu_idu_ex2_load_inst_vld;              
wire                                              lsu_idu_ex2_vload_fwd_inst_vld;    
wire                                              lsu_idu_ex2_vload_inst_vld;  
wire    [PREG-1:0]                                lsu_idu_ex2_preg;
wire    [VREG:0]                                  lsu_idu_ex2_vreg;             
wire    [`WK_PA_WIDTH-13:0]                       lsu_mmu_vabuf0;                         
wire                                              mmu_lsu_data_req_size;                  
wire                                              mmu_lsu_mmu_en;                         
wire                                              mmu_lsu_tlb_busy;                       
wire                                              mmu_lsu_imme_wakeup; // wjh@tmq
wire    [3 :0]                                    mmu_rot_sel;                            
wire                                              pad_yy_icg_scan_en;                     
wire                                              pfu_pfb_empty;                          
wire                                              pfu_sdb_create_gateclk_en;              
wire                                              pfu_sdb_empty;                          
wire                                              rb_fence_ld;                            
wire                                              rtu_lsu_flush_fe;                       
wire    [3 :0]                                    setvl_val_byte;                         
wire                                              setvl_val_dword;                        
wire    [2 :0]                                    setvl_val_half;                         
wire    [1 :0]                                    setvl_val_word;                         
wire                                              sq_ldc_ex2_addr1_dep_discard;             
wire                                              sq_ldc_ex2_cancel_acc_req;                
wire                                              sq_ldc_ex2_cancel_ahead_wb;               
wire                                              sq_ldc_ex2_fwd_req;                       
wire                                              sq_ldc_ex2_has_fwd_req;                   
wire    [`WK_PA_WIDTH-1:0]                        lsdc0_ex2_addr0;  
wire    [`WK_PA_WIDTH-1:0]                        lsdc1_ex2_addr0;                            
wire    [15:0]                                    lsdc0_ex2_bytes_vld;  
wire    [15:0]                                    lsdc1_ex2_bytes_vld;                       
wire                                              lsdc0_ex2_chk_st_inst_vld;  
wire                                              lsdc1_ex2_chk_st_inst_vld;                  
wire                                              lsdc0_ex2_chk_statomic_inst_vld;   
wire                                              lsdc1_ex2_chk_statomic_inst_vld;            
wire                                              lsdc0_ex2_inst_vld;   
wire                                              lsdc1_ex2_inst_vld; 
wire                                              lsdc0_ex2_is_load;        
wire                                              lsdc1_ex2_is_load;                        
wire    [3 :0]                                    wmb_dcache_get_data;                    
wire    [15:0]                                    wmb_fwd_bytes_vld;                      
wire                                              wmb_ld_dc_cancel_acc_req;               
wire                                              wmb_ld_dc_discard_req;                  
wire                                              wmb_ldc_fwd_req;                      

//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
input                                             dtu_lsu_addr_trig_en;
input                                             dtu_lsu_data_trig_en;
input                                             ld_ag_boundary_unmask;
input   [2  :0]                                   ld_ag_dtu_access_size;
input                                             ld_ag_dtu_last_check;
input   [1  :0]                                   ld_ag_dtu_type;
input   [47 :0]                                   ld_ag_dtu_va;
input                                             ld_ag_dtu_vld;
input   [`TDT_MP_HINFO_WIDTH-1:0]                 ld_ag_halt_info;

output                                            ld_dc_boundary_unmask;
output  [47:0]                                    ld_dc_dtu_addr;
output  [15:0]                                    ld_dc_dtu_addr_bytes_vld;
output  [`TDT_MP_HINFO_WIDTH-1:0]                 ld_dc_dtu_addr_halt_info;
output                                            ld_dc_dtu_addr_last_check;
output  [2 :0]                                    ld_dc_dtu_addr_size;
output  [1 :0]                                    ld_dc_dtu_addr_type;
output                                            ld_dc_dtu_addr_vld;
//input
wire                                              dtu_lsu_addr_trig_en;
wire                                              dtu_lsu_data_trig_en;
wire                                              ld_ag_boundary_unmask;
wire    [2  :0]                                   ld_ag_dtu_access_size;
wire                                              ld_ag_dtu_last_check;
wire    [1  :0]                                   ld_ag_dtu_type;
wire    [47 :0]                                   ld_ag_dtu_va;
wire                                              ld_ag_dtu_vld;
wire    [`TDT_MP_HINFO_WIDTH-1:0]                 ld_ag_halt_info;  
//output
reg                                               ld_dc_boundary_unmask;
reg     [47 :0]                                   ld_dc_dtu_addr;
reg     [15 :0]                                   ld_dc_dtu_addr_bytes_vld;
reg     [`TDT_MP_HINFO_WIDTH-1:0]                 ld_dc_dtu_addr_halt_info;
reg                                               ld_dc_dtu_addr_last_check;
reg     [2  :0]                                   ld_dc_dtu_addr_size;
reg     [1  :0]                                   ld_dc_dtu_addr_type;
reg                                               ld_dc_dtu_addr_vld;
//==========================================================
//                  Risc-V Debug zdb End
//==========================================================

parameter S_BYTE  = 2'b00,
          HALF  = 2'b01,
          WORD  = 2'b10,
          DWORD = 2'b11;


//==========================================================
//                 Instance of Gated Cell  
//==========================================================
assign ldc_clk_en = lag_ex1_inst_vld
                      ||  dcache_arb_ldc_borrow_vld_gate;
// &Instance("gated_clk_cell", "x_lsu_ld_dc_gated_clk"); @47
gated_clk_cell  x_lsu_ld_dc_gated_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (ldc_clk         ),
  .external_en        (1'b0              ),
  .local_en           (ldc_clk_en      ),
  .module_en          (cp0_lsu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect(.clk_in        (forever_cpuclk     ), @48
//          .external_en   (1'b0               ), @49
//          .module_en     (cp0_lsu_icg_en     ), @50
//          .local_en      (ldc_clk_en       ), @51
//          .clk_out       (ldc_clk          )); @52

assign ldc_inst_clk_en = lag_ex1_inst_vld;
// &Instance("gated_clk_cell", "x_lsu_ld_dc_inst_gated_clk"); @55
gated_clk_cell  x_lsu_ld_dc_inst_gated_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (ldc_inst_clk    ),
  .external_en        (1'b0              ),
  .local_en           (ldc_inst_clk_en ),
  .module_en          (cp0_lsu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect(.clk_in        (forever_cpuclk     ), @56
//          .external_en   (1'b0               ), @57
//          .module_en     (cp0_lsu_icg_en     ), @58
//          .local_en      (ldc_inst_clk_en  ), @59
//          .clk_out       (ldc_inst_clk     )); @60

assign ldc_borrow_clk_en = dcache_arb_ldc_borrow_vld_gate;
// &Instance("gated_clk_cell", "x_lsu_ld_dc_borrow_gated_clk"); @63
gated_clk_cell  x_lsu_ld_dc_borrow_gated_clk (
  .clk_in              (forever_cpuclk     ),
  .clk_out             (ldc_borrow_clk   ),
  .external_en         (1'b0               ),
  .local_en            (ldc_borrow_clk_en),
  .module_en           (cp0_lsu_icg_en     ),
  .pad_yy_icg_scan_en  (pad_yy_icg_scan_en )
);

// &Connect(.clk_in        (forever_cpuclk     ), @64
//          .external_en   (1'b0               ), @65
//          .module_en     (cp0_lsu_icg_en     ), @66
//          .local_en      (ldc_borrow_clk_en), @67
//          .clk_out       (ldc_borrow_clk  )); @68

//-----------------------expt clk---------------------------
//assign ld_dc_expt_illegal_inst_clk_en = lag_ex1_inst_vld
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
// &Force("output","ldc_ex2_inst_vld"); @87
xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH)) 
x_lsu_ck_flush_compare_ex1_iid (
  .x_iid0                    (rtu_ck_flush_iid[IID_WIDTH-1:0]),
  .x_iid0_older              (rtu_ck_flush_iid_older_than_ex1_iid  ),
  .x_iid1                    (lag0_ex1_iid[IID_WIDTH-1:0]           )
);
always @(posedge ctrl_ld_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    ldc_ex2_inst_vld          <=  1'b0;
    ldc_load_inst_vld         <=  1'b0;
    ldc_load_ahead_inst_vld   <=  1'b0;
    ldc_vload_inst_vld        <=  1'b0;
    ldc_vload_ahead_inst_vld  <=  1'b0;
  end
  else if(rtu_lsu_flush_fe)
  begin
    ldc_ex2_inst_vld          <=  1'b0;
    ldc_load_inst_vld         <=  1'b0;
    ldc_load_ahead_inst_vld   <=  1'b0;
    ldc_vload_inst_vld        <=  1'b0;
    ldc_vload_ahead_inst_vld  <=  1'b0;
  end
  else if(rtu_ck_flush && rtu_ck_flush_iid_older_than_ex1_iid)  //flush younger ex1->ex2 inst_vld, ck_flush@LTL
  begin
    ldc_ex2_inst_vld          <=  1'b0;
    ldc_load_inst_vld         <=  1'b0;
    ldc_load_ahead_inst_vld   <=  1'b0;
    ldc_vload_inst_vld        <=  1'b0;
    ldc_vload_ahead_inst_vld  <=  1'b0;
  end
  else if(lag_ldc_ex1_inst_vld)
  begin
    ldc_ex2_inst_vld          <=  1'b1;
    ldc_load_inst_vld         <=  lag_ldc_ex1_load_inst_vld;
    ldc_load_ahead_inst_vld   <=  lag_ldc_ex1_load_ahead_inst_vld;
    ldc_vload_inst_vld        <=  lag_ldc_ex1_vload_inst_vld;
    ldc_vload_ahead_inst_vld  <=  lag_ldc_ex1_vload_ahead_inst_vld;
  end
  else
  begin
    ldc_ex2_inst_vld          <=  1'b0;
    ldc_load_inst_vld         <=  1'b0;
    ldc_load_ahead_inst_vld   <=  1'b0;
    ldc_vload_inst_vld        <=  1'b0;
    ldc_vload_ahead_inst_vld  <=  1'b0;
  end
end

// &Force("output","ldc_ex2_borrow_vld"); @164
always @(posedge ctrl_ld_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    ldc_ex2_borrow_vld      <=  1'b0;
  else if(dcache_arb_ldc_borrow_vld)
    ldc_ex2_borrow_vld      <=  1'b1;
  else
    ldc_ex2_borrow_vld      <=  1'b0;
end

//------------------expt part-------------------------------
//+-------+----------+--------+------+---------+
//| tmiss | misalign | tfatal | deny | rd_tinv |
//+-------+----------+--------+------+---------+
// &Force("output","ldc_lda_ex2_mmu_req"); @179
always @(posedge ldc_inst_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    ldc_lda_ex2_mmu_req               <=  1'b0;
    //ld_dc_expt_illegal_inst         <=  1'b0;
    ldc_expt_misalign_no_page         <=  1'b0;
    //ld_dc_expt_access_fault         <=  1'b0;
    ldc_expt_page_fault               <=  1'b0;
    ldc_expt_misalign_with_page       <=  1'b0;
    ldc_expt_access_fault_with_page   <=  1'b0;
    ldc_expt_ldamo_not_ca             <=  1'b0;
  end
  else if(lag_ex1_inst_vld)
  begin
    ldc_lda_ex2_mmu_req             <=  lag_ldc_ex1_mmu_req;
    //ld_dc_expt_illegal_inst           <=  ld_ag_expt_illegal_inst;
    ldc_expt_misalign_no_page       <=  lag_ldc_ex1_expt_misalign_no_page;
    //ld_dc_expt_access_fault           <=  ld_ag_expt_access_fault;
    ldc_expt_page_fault             <=  lag_ldc_ex1_expt_page_fault;
    ldc_expt_misalign_with_page     <=  lag_ldc_ex1_expt_misalign_with_page;
    ldc_expt_access_fault_with_page <=  lag_ldc_ex1_expt_access_fault_with_page;
    ldc_expt_ldamo_not_ca           <=  lag_ldc_ex1_expt_ldamo_not_ca;// deleted a repeated ';' by spyglass
  end
end

//always @(posedge ld_dc_expt_illegal_inst_clk or negedge cpurst_b)
//begin
//  if (!cpurst_b)
//    ld_dc_inst_code[31:0]   <=  32'b0;
//  else if(lag_ex1_inst_vld  &&  ld_ag_expt_illegal_inst)
//    ld_dc_inst_code[31:0]   <=  ld_ag_inst_code[31:0];
//end

//------------------borrow part-----------------------------
//+-----+------+-----+------------+
//| rcl | sndb | mmu | settle way |
//+-----+------+-----+------------+
// &Force("output","ldc_lda_ex2_borrow_mmu"); @218
// &Force("output","ldc_lda_ex2_borrow_icc"); @219
// &Force("output","ldc_lda_ex2_borrow_icc_tag"); @220
// &Force("output","ldc_lda_ex2_settle_way"); @221
always @(posedge ldc_borrow_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    ldc_lda_ex2_borrow_db[VB_DATA_ENTRY-1:0]  <=  {VB_DATA_ENTRY{1'b0}};
    ldc_lda_ex2_borrow_vb                     <=  1'b0;
    ldc_lda_ex2_borrow_sndb                   <=  1'b0;
    ldc_lda_ex2_borrow_mmu                    <=  1'b0;
    ldc_lda_ex2_borrow_prq                    <=  1'b0;
    ldc_lda_ex2_borrow_icc                    <=  1'b0;
    ldc_lda_ex2_borrow_icc_tag                <=  1'b0;
    // ldc_lda_ex2_settle_way                    <=  2'b0;  //1bit->2bit, L1D 2way->4way, LTL@20250319 
    ldc_ex2_borrow_way                        <=  2'b0;
    ldc_lda_ex2_borrow_wmb                    <=  1'b0;
    ldc_lda_ex2_borrow_wmb_get_data[3:0]      <=  4'b0;
    ldc_lda_ex2_borrow_icc_ecc                <=  1'b0;
    ldc_lda_ex2_borrow_idx_5to4[1:0]          <=  2'b0;
  end
  else if(dcache_arb_ldc_borrow_vld)
  begin
    ldc_lda_ex2_borrow_db[VB_DATA_ENTRY-1:0]  <=  dcache_arb_ldc_borrow_db[VB_DATA_ENTRY-1:0];
    ldc_lda_ex2_borrow_vb                     <=  dcache_arb_ldc_borrow_vb;
    ldc_lda_ex2_borrow_sndb                   <=  dcache_arb_ldc_borrow_sndb;
    ldc_lda_ex2_borrow_mmu                    <=  dcache_arb_ldc_borrow_mmu;
    ldc_lda_ex2_borrow_prq                    <=  dcache_arb_ldc_borrow_prq;
    ldc_lda_ex2_borrow_icc                    <=  dcache_arb_ldc_borrow_icc;
    ldc_lda_ex2_borrow_icc_tag                <=  icc_dcache_arb_ld_tag_read;
    // ldc_lda_ex2_settle_way                    <=  dcache_arb_ldc_settle_way;  //1bit->2bit, L1D 2way->4way, LTL@20250319 
    ldc_ex2_borrow_way                        <=  dcache_arb_ldc_settle_way;
    ldc_lda_ex2_borrow_wmb                    <=  dcache_arb_ldc_borrow_wmb;
    ldc_lda_ex2_borrow_wmb_get_data[3:0]      <=  wmb_dcache_get_data[3:0];//??????????????????????
    ldc_lda_ex2_borrow_icc_ecc                <=  icc_dcache_arb_ecc_read;
    ldc_lda_ex2_borrow_idx_5to4[1:0]          <=  dcache_arb_ldc_borrow_idx_5to4[1:0];
  end
end
assign ldc_lda_ex2_settle_way = ldc_ex2_borrow_vld? ldc_ex2_borrow_way: {ldc_hit_way3|ldc_hit_way2, ldc_hit_way3|ldc_hit_way1};
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
// &Force("output","ldc_lda_ex2_split"); @277
// &Force("output","ldc_lda_ex2_inst_type"); @278
// &Force("output","ldc_ex2_secd"); @279
// &Force("output","ldc_lda_ex2_already_da"); @280
// &Force("output","ldc_lda_ex2_atomic"); @281
// &Force("output","ldc_ex2_iid"); @282
// &Force("output","ldc_lda_ex2_lsid"); @283
// &Force("output","ldc_ex2_bytes_vld"); @284
// &Force("output","ldc_ex2_bytes_vld1"); @285
// &Force("output","ldc_lda_ex2_bytes_vld"); @286
// &Force("output","ldc_lda_ex2_preg"); @287
// &Force("output","ldc_lda_ex2_inst_vfls"); @288
// &Force("output","ldc_lda_ex2_vreg"); @289
// &Force("output","ldc_ex2_addr1_11to4"); @290
// &Force("output","ldc_lda_ex2_ldfifo_pc"); @291
// &Force("output","ldc_lda_ex2_inst_size"); @292
// &Force("output","ldc_lda_ex2_sext"); @293
// &Force("output","ldc_lda_ex2_expt_vld_except_access_err"); @294
// &Force("output","ldc_lda_ex2_boundary"); @295
// &Force("output","ldc_lda_ex2_dtcm_hit"); @296
// &Force("output","ldc_lda_ex2_itcm_hit"); @297
always @(posedge ldc_inst_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    ldc_lda_ex2_expt_vld_except_access_err  <=  1'b0;
    ld_dc_pf_inst                           <=  1'b0;
    ldc_vpn[`WK_PA_WIDTH-13:0]              <=  {`WK_PA_WIDTH-12{1'b0}};
    ldc_addr1_tto4[`WK_PA_WIDTH-5:0]        <=  {`WK_PA_WIDTH-4{1'b0}};
    ldc_lda_ex2_split                       <=  1'b0;
    ldc_lda_ex2_inst_type[1:0]              <=  2'b0;
    ldc_lda_ex2_inst_size[2:0]              <=  3'b0;
    ldc_ex2_secd                            <=  1'b0;
    ldc_lda_ex2_already_da                  <=  1'b0;
    ldc_lsiq_spec_fail                      <=  1'b0;
    ldc_lda_ex2_sext                        <=  1'b0;
    ldc_lda_ex2_atomic                      <=  1'b0;
    ldc_ex2_iid[IID_WIDTH-1:0]              <=  {IID_WIDTH{1'b0}};
    ldc_lda_ex2_lsid[LSIQENTRY-1:0]         <=  {LSIQENTRY{1'b0}};
    ldc_old                                 <=  1'b0;
    ldc_ex2_bytes_vld[15:0]                 <=  16'b0;
    ldc_ex2_bytes_vld1[15:0]                <=  16'b0;
    ldc_rot_sel[3:0]                        <=  4'b0;
    ldc_lda_ex2_boundary                    <=  1'b0;
    ldc_lda_ex2_preg[PREG-1:0]              <=  {PREG{1'b0}};
    ldc_lda_ex2_ldfifo_pc[PC_LEN-1:0]       <=  {PC_LEN{1'b0}};
    ldc_lda_ex2_ahead_predict               <=  1'b0;
    ldc_page_so                             <=  1'b0;
    ldc_page_ca                             <=  1'b0;
    ldc_page_buf                            <=  1'b0;
    ldc_page_sec                            <=  1'b0;
    ldc_page_share                          <=  1'b0;
    ldc_utlb_miss                           <=  1'b0;
    ldc_tlb_busy                            <=  1'b0;
    ldc_tlb_imme_wakeup                     <=  1'b0; // wjh@tmq
    ldc_lda_ex2_vreg[VREG-1:0]              <=  {VREG{1'b0}};
    ldc_lda_ex2_inst_vfls                   <=  1'b0;
    ldc_acclr_en                            <=  1'b0;
    ldc_fwd_bypass_en                       <=  1'b0;
    ldc_lda_ex2_no_spec[1:0]                <=  2'b0;
    ldc_lda_ex2_no_spec_exist               <=  1'b0;
    ldc_raw0_new                            <=  1'b0;
    ldc_raw1_new                            <=  1'b0;
    ldc_lda_ex2_reg_bytes_vld[15:0]         <=  16'b0;
    ldc_lda_ex2_inst_us                     <= 1'b0;
    //ldc_lda_ex2_vsew[1:0]                   <=  2'b0;//rvv1.0 @hcl
    ldc_lda_ex2_vmew[1:0]                   <=  2'b0;//rvv1.0 @hcl
    ldc_lda_ex2_vmop[1:0]                   <=  2'b0;//rvv1.0 @hcl
    // ldc_lda_ex2_vlmul[1:0]                  <=  2'b0;
    ldc_lda_ex2_vlmul[2:0]                  <=  3'b0;    
    ldc_lda_ex2_element_size[1:0]           <=  2'b0;
    ldc_lda_ex2_element_cnt[8:0]            <=  9'b0;
    ldc_secd_element_offset[3:0]            <=  4'b0;
    ldc_lda_ex2_vmb_id[VMBENTRY-1:0]        <=  {VMBENTRY{1'b0}};
    ldc_lda_ex2_inst_vls                    <=  1'b0;
    ldc_lda_ex2_inst_fof                    <=  1'b0;
    ldc_lda_ex2_vmb_merge_vld               <=  1'b0;
    ldc_lda_ex2_dtcm_hit                    <=  1'b0;
    ldc_lda_ex2_itcm_hit                    <=  1'b0;
  end
  else if(lag_ex1_inst_vld)
  begin
    ldc_lda_ex2_expt_vld_except_access_err  <=  lag_ldc_ex1_expt_vld;
    ld_dc_pf_inst                           <=  lag_ldc_ex1_pf_inst;
    ldc_vpn[`WK_PA_WIDTH-13:0]              <=  lag_ldc_ex1_vpn[`WK_PA_WIDTH-13:0];
    ldc_addr1_tto4[`WK_PA_WIDTH-5:0]        <=  lag_ldc_ex1_addr1_to4[`WK_PA_WIDTH-5:0];
    ldc_lda_ex2_split                       <=  lag_ldc_ex1_split;
    ldc_lda_ex2_inst_type[1:0]              <=  lag_ldc_ex1_inst_type[1:0];
    ldc_lda_ex2_inst_size[2:0]              <=  lag_ex1_dc_access_size[2:0];
    ldc_ex2_secd                            <=  lag_ldc_ex1_secd;
    ldc_lda_ex2_already_da                  <=  lag_ldc_ex1_already_da;
    ldc_lsiq_spec_fail                      <=  lag_ldc_ex1_lsiq_spec_fail;
    ldc_lda_ex2_sext                        <=  lag_ldc_ex1_sext;
    ldc_lda_ex2_atomic                      <=  lag_ldc_ex1_atomic;
    ldc_ex2_iid[IID_WIDTH-1:0]              <=  lag0_ex1_iid[IID_WIDTH-1:0];
    ldc_lda_ex2_lsid[LSIQENTRY-1:0]         <=  lag_ldc_ex1_lsid[LSIQENTRY-1:0];
    ldc_old                                 <=  lag_ldc_ex1_old;
    ldc_ex2_bytes_vld[15:0]                 <=  lag_ldc_ex1_bytes_vld[15:0];
    ldc_ex2_bytes_vld1[15:0]                <=  lag_ldc_ex1_bytes_vld1[15:0];
    ldc_rot_sel[3:0]                        <=  lag_ldc_ex1_rot_sel[3:0];
    ldc_lda_ex2_boundary                    <=  lag_ldc_ex1_boundary;
    ldc_lda_ex2_preg[PREG-1:0]              <=  lag_ldc_ex1_preg[PREG-1:0];
    ldc_lda_ex2_ldfifo_pc[PC_LEN-1:0]       <=  lag_ldc_ex1_ldfifo_pc[PC_LEN-1:0];
    ldc_lda_ex2_ahead_predict               <=  lag_ldc_ex1_ahead_predict;
    ldc_page_so                             <=  lag_ldc_ex1_page_so;
    ldc_page_ca                             <=  lag_ldc_ex1_page_ca;
    ldc_page_buf                            <=  lag_ldc_ex1_page_buf;
    ldc_page_sec                            <=  lag_ldc_ex1_page_sec;
    ldc_page_share                          <=  lag_ldc_ex1_page_share;
    ldc_utlb_miss                           <=  lag_ldc_ex1_utlb_miss;
    ldc_tlb_busy                            <=  mmu_lsu_tlb_busy;
    ldc_tlb_imme_wakeup                     <=  mmu_lsu_imme_wakeup; // wjh@tmq
    ldc_lda_ex2_vreg[VREG-1:0]              <=  lag_ldc_ex1_vreg[VREG-1:0];
    ldc_lda_ex2_inst_vfls                   <=  lag_ldc_ex1_inst_vfls;
    ldc_acclr_en                            <=  lag_ldc_ex1_acclr_en;
    ldc_fwd_bypass_en                       <=  lag_ldc_ex1_fwd_bypass_en;
    ldc_lda_ex2_no_spec[1:0]                <=  lag_ldc_ex1_no_spec[1:0];
    ldc_lda_ex2_no_spec_exist               <=  lag_ldc_ex1_no_spec_exist;
    ldc_raw0_new                            <=  lag_ldc_ex1_raw0_new;
    ldc_raw1_new                            <=  lag_ldc_ex1_raw1_new;
    ldc_lda_ex2_reg_bytes_vld[15:0]         <=  lag_ldc_ex1_reg_bytes_vld[15:0];
    ldc_lda_ex2_inst_us                     <=  lag_ldc_ex1_inst_us;
    //ldc_lda_ex2_vsew[1:0]                   <=  lag_ldc_ex1_vsew[1:0]; // not use in rvv1.0 @hcl
    ldc_lda_ex2_vmew[1:0]                   <=  lag_ldc_ex1_vmew;
    ldc_lda_ex2_vmop[1:0]                   <=  lag_ldc_ex1_vmop;
    // ldc_lda_ex2_vlmul[1:0]                  <=  lag_ldc_ex1_vlmul[1:0];
    ldc_lda_ex2_vlmul[2:0]                  <=  lag_ldc_ex1_vlmul[2:0];    
    ldc_lda_ex2_element_size[1:0]           <=  lag_ldc_ex1_element_size[1:0];
    ldc_lda_ex2_element_cnt[8:0]            <=  lag_ldc_ex1_element_cnt[8:0];
    ldc_secd_element_offset[3:0]            <=  lag_ldc_ex1_element_offset[3:0];
    ldc_lda_ex2_vmb_id[VMBENTRY-1:0]        <=  lag_ldc_ex1_vmb_id[VMBENTRY-1:0];
    ldc_lda_ex2_inst_vls                    <=  lag_ldc_ex1_inst_vls;
    ldc_lda_ex2_inst_fof                    <=  lag_ldc_ex1_inst_fof;
    ldc_lda_ex2_vmb_merge_vld               <=  lag_ldc_ex1_vmb_merge_vld;
    ldc_lda_ex2_dtcm_hit                    <=  lag_ldc_ex1_dtcm_hit;
    ldc_lda_ex2_itcm_hit                    <=  lag_ldc_ex1_itcm_hit;
  end
end

always @(posedge ldc_inst_clk or negedge cpurst_b)begin 
  if(!cpurst_b)begin 
    ldc_ex2_bytes_vld2[15:0]                <=  16'b0;
    ldc_ex2_bytes_vld3[15:0]                <=  16'b0;
    ldc_lda_ex2_reg_bytes_vld1[15:0]        <=  16'b0;
    ldc_lda_ex2_reg_bytes_vld2[15:0]        <=  16'b0;
    ldc_lda_ex2_reg_bytes_vld3[15:0]        <=  16'b0;
  end
  else if(lag_ex1_inst_vld & lag_ldc_ex1_inst_us)begin 
    ldc_ex2_bytes_vld2[15:0]                <=  lag_ldc_ex1_bytes_vld2[15:0];
    ldc_ex2_bytes_vld3[15:0]                <=  lag_ldc_ex1_bytes_vld3[15:0];
    ldc_lda_ex2_reg_bytes_vld1[15:0]        <=  lag_ldc_ex1_reg_bytes_vld1[15:0];
    ldc_lda_ex2_reg_bytes_vld2[15:0]        <=  lag_ldc_ex1_reg_bytes_vld2[15:0];
    ldc_lda_ex2_reg_bytes_vld3[15:0]        <=  lag_ldc_ex1_reg_bytes_vld3[15:0];
    ldc_ex2_us_way[3:0]                     <=  lag_ldc_ex1_us_way[3:0];

  end
end
assign ldc_pfu_ex2_older_than_ls0 = !ldc_raw0_new;
assign ldc_pfu_ex2_older_than_ls1 = !ldc_raw1_new;
//------------------inst/borrow share part------------------
//+-------+
//| addr0 |
//+-------+
// &Force("output","ldc_ex2_addr0"); @442
always @(posedge ldc_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    ldc_ex2_addr0[`WK_PA_WIDTH-1:0]     <=  {`WK_PA_WIDTH{1'b0}};
  end
  else if(lag_ex1_inst_vld  ||  dcache_arb_ldc_borrow_vld)
  begin
    ldc_ex2_addr0[`WK_PA_WIDTH-1:0]     <=  lag_ldc_ex1_addr0[`WK_PA_WIDTH-1:0];
  end
end

//==========================================================
//        Generate  va
//==========================================================
assign ldc_va[`WK_PA_WIDTH-1:12] = ldc_vpn[`WK_PA_WIDTH-13:0];
assign ldc_va[11:4]           = ldc_ex2_addr0[11:4];
assign ldc_va[3:0]            = (ldc_lda_ex2_boundary
                                      &&  !ldc_ex2_secd
                                      &&  !ldc_expt_misalign_no_page)
                                  ? 4'b0
                                  : ldc_ex2_addr0[3:0];
assign ldc_ex2_addr1_11to4[7:0]   = ldc_addr1_tto4[7:0];
// for preload addr check
assign ldc_pfu_va_11to4[7:0]      = ldc_lda_ex2_boundary  &&  !ldc_ex2_secd
                                      ? ldc_ex2_addr1_11to4[7:0]
                                      : ldc_ex2_addr0[11:4];
//if this inst cross 4k, this va is not accurate
assign ldc_lda_ex2_pfu_va[`WK_PA_WIDTH-1:0]  = {ldc_vpn[`WK_PA_WIDTH-13:0],
                                      ldc_pfu_va_11to4[7:0],
                                      ldc_ex2_addr0[3:0]};

//==========================================================
//        Exception generate
//==========================================================
assign ldc_lda_ex2_expt_access_fault_mask = ldc_expt_misalign_no_page
                                            ||  ldc_expt_page_fault;

assign ldc_lda_ex2_expt_access_fault_extra  = ldc_lda_ex2_mmu_req
                                              &&  ldc_expt_ldamo_not_ca;

assign ldc_expt_access_fault_short  = ldc_lda_ex2_mmu_req;
//if utlb_miss and dmmu expt,
//then st_dc_expt_vld_except_access_err is 0,
//but st_dc_da_expt_vld is not certain

assign ldc_lda_ex2_expt_vld_gate_en  = ldc_lda_ex2_expt_vld_except_access_err
                                        ||  ldc_expt_access_fault_short
                                        ||  dtu_lsu_addr_trig_en  // Risc-V Debug zdb
                                        ||  dtu_lsu_data_trig_en; // Risc-V Debug zdb

// &CombBeg; @492
always @( ldc_lda_ex2_atomic
       or ldc_expt_access_fault_with_page
       or ldc_va[`WK_PA_WIDTH-1:0]
       or ldc_expt_misalign_with_page
       or ldc_addr1_tto4[`WK_PA_WIDTH-5:0]
       or ldc_expt_misalign_no_page
       or ldc_lda_ex2_expt_vld_except_access_err
       or ldc_expt_page_fault)
begin
ldc_lda_ex2_expt_vec[4:0] = 5'b0;
ldc_lda_ex2_mtval[`WK_PA_WIDTH-1:0] = {`WK_PA_WIDTH{1'b0}};
if(ldc_expt_misalign_no_page  && !ldc_lda_ex2_atomic)
begin
  ldc_lda_ex2_expt_vec[4:0]   = 5'd4;
  ldc_lda_ex2_mtval[`WK_PA_WIDTH-1:0]  = {ldc_addr1_tto4[`WK_PA_WIDTH-5:0],ldc_va[3:0]};
end
else if(ldc_expt_misalign_no_page && ldc_lda_ex2_atomic)
begin
  ldc_lda_ex2_expt_vec[4:0]   = 5'd6;
  ldc_lda_ex2_mtval[`WK_PA_WIDTH-1:0]  = ldc_va[`WK_PA_WIDTH-1:0];
end
else if(ldc_expt_page_fault &&  !ldc_lda_ex2_atomic)
begin
  ldc_lda_ex2_expt_vec[4:0]   = 5'd13;
  ldc_lda_ex2_mtval[`WK_PA_WIDTH-1:0]  = ldc_va[`WK_PA_WIDTH-1:0];
end
else if(ldc_expt_page_fault &&  ldc_lda_ex2_atomic)
begin
  ldc_lda_ex2_expt_vec[4:0]   = 5'd15;
  ldc_lda_ex2_mtval[`WK_PA_WIDTH-1:0]  = ldc_va[`WK_PA_WIDTH-1:0];
end
else if(ldc_expt_misalign_with_page)
begin
  ldc_lda_ex2_expt_vec[4:0]   = 5'd4;
  ldc_lda_ex2_mtval[`WK_PA_WIDTH-1:0]  = ldc_va[`WK_PA_WIDTH-1:0];
end
else if(ldc_expt_access_fault_with_page)
begin
  ldc_lda_ex2_expt_vec[4:0]   = 5'd5;
  ldc_lda_ex2_mtval[`WK_PA_WIDTH-1:0]  = {`WK_PA_WIDTH{1'b0}};
end
else if(ldc_lda_ex2_expt_vld_except_access_err && !ldc_lda_ex2_atomic)begin 
  ldc_lda_ex2_expt_vec[4:0]   = 5'd5;
  ldc_lda_ex2_mtval[`WK_PA_WIDTH-1:0]  = {`WK_PA_WIDTH{1'b0}};
end
else if(ldc_lda_ex2_expt_vld_except_access_err && ldc_lda_ex2_atomic)begin 
  ldc_lda_ex2_expt_vec[4:0]   = 5'd7;
  ldc_lda_ex2_mtval[`WK_PA_WIDTH-1:0]  = {`WK_PA_WIDTH{1'b0}};
end
// &CombEnd @525
end

//==========================================================
//        Generate inst type
//==========================================================
// &Force("output","ldc_lda_ex2_vector_nop"); @530
//for masked element,treat it as nop
assign ldc_lda_ex2_vector_nop =  (ldc_lda_ex2_atomic || ldc_ld_inst) 
                                  &&!(|ldc_ex2_bytes_vld[15:0])
                                  && !ldc_lda_ex2_inst_us
                               || ldc_lda_ex2_inst_us
                                  && !((|ldc_ex2_bytes_vld)
                                     | (|ldc_ex2_bytes_vld1)
                                     | (|ldc_ex2_bytes_vld2)
                                     | (|ldc_ex2_bytes_vld3));
assign ldc_ld_inst      = !ldc_lda_ex2_atomic
                          &&  (ldc_lda_ex2_inst_type[1:0]  == 2'b00);
assign ldc_ldamo_inst   = ldc_lda_ex2_atomic
                          &&  (ldc_lda_ex2_inst_type[1:0]  == 2'b00);
//==========================================================
//                 Create load queue
//==========================================================
//lq_create_vld is not accurate, comparing iid is a must precedure to create lq
// &Force("output","ldc_lq_ex2_create_vld"); @546
// &Force("output","ld_dc_lq_create1_vld"); @547
// &Force("output","ldc_lq_ex2_create_dp_vld"); @548
// &Force("output","ld_dc_lq_create1_dp_vld"); @549
//to reduce spec fail, create lq should be more strict

//for timing, create lq do not see access deny
assign ldc_lq_ex2_create_vld          = ldc_lq_ex2_create_dp_vld;       //lq_create_dp_vld = lq_create_vld, process lq only one entry@202508
                                      //&&  !ldc_depd_imme_restart_req
                                      //&&  !sq_ldc_ex2_addr1_dep_discard;


assign ldc_lq_ex2_create_dp_vld       = ldc_ex2_inst_vld
                                      &&  ldc_ld_inst
                                      &&  !ldc_lda_ex2_vector_nop
                                      &&  !ldc_old
                                      &&  !ldc_page_so
                                      &&  !ldc_utlb_miss
                                      &&  !lq_ldc_ex2_inst_hit
                                      &&  !ldc_lda_ex2_expt_vld_except_access_err
                                      &&  !ldc_depd_imme_restart_req
                                      &&  !sq_ldc_ex2_addr1_dep_discard;

//----------------------------creat1_close---------------------------------
assign ld_dc_lq_create1_vld         = ld_dc_lq_create1_dp_vld
                                      &&  !ldc_depd_imme_restart_req
                                      && cb_ld_dc_addr_hit
                                      && !sq_ldc_ex2_addr1_dep_discard;


assign ld_dc_lq_create1_dp_vld      = ldc_lq_ex2_create_dp_vld 
                                      && ldc_acclr_en;
//------------------------------------------------------------------------

// &Force("output","ldc_lq_ex2_create_gateclk_en"); @574
assign ldc_lq_ex2_create_gateclk_en   = ldc_ex2_inst_vld
                                        &&  ldc_ld_inst
                                        &&  !ldc_old
                                        &&  !ldc_page_so
                                        &&  !ldc_utlb_miss
                                        &&  !ldc_lda_ex2_expt_vld_except_access_err;
//----------------------------creat1_close---------------------------------                                    
assign ldc_lq_ex2_create1_gateclk_en  = ldc_lq_ex2_create_gateclk_en
                                        &&  ldc_acclr_en;
//-------------------------------------------------------------------------
// &Force("output","ldc_ex2_addr1"); @584
assign ldc_ex2_addr1[`WK_PA_WIDTH-1:0]   = {ldc_ex2_addr0[`WK_PA_WIDTH-1:12],ldc_ex2_addr1_11to4[7:0],4'b0};

//lq create entry
assign ldc_lda_ex2_lq_entry[LQENTRY-1:0] = lq_ldc_create_entry[LQENTRY-1:0];
//==========================================================
//                 Generate check signal to lq/sq/wmb
//==========================================================
// &Force("output","ldc_ex2_chk_ld_inst_vld"); @592
assign ldc_ex2_chk_ld_inst_vld      = ldc_ex2_inst_vld
                                    &&  ldc_ld_inst
                                    &&  !ldc_lda_ex2_expt_vld_except_access_err
                                    &&  !ldc_utlb_miss
                                    &&  !ldc_page_so;

assign ldc_sq_ex2_chk_ld_bypass_vld    = ldc_ex2_chk_ld_inst_vld
                                          &&  ldc_fwd_bypass_en;

assign ldc_ex2_chk_ld_addr1_vld     = ldc_ex2_inst_vld
                                    &&  ldc_ld_inst
                                    &&  !ldc_lda_ex2_expt_vld_except_access_err
                                    &&  !ldc_utlb_miss
                                    &&  !ldc_page_so
                                    &&  ldc_acclr_en;

assign ldc_ex2_chk_atomic_inst_vld  = ldc_ex2_inst_vld
                                        &&  !ldc_lda_ex2_vector_nop
                                        &&  ldc_lda_ex2_atomic
                                        &&  !ldc_utlb_miss
                                        &&  !ldc_lda_ex2_expt_vld_except_access_err;

//==========================================================
//                 RAW speculation check
//==========================================================
// st_dc stage should check raw speculation for ld_dc stage

// situat st pipe             ld pipe           addr      bytes_vld
// ----------------------------------------------------------------
// 2      st/stex             ld                31:4       x

// &Force("output","ldc_ex2_inst_chk_vld"); @624
assign ldc_ex2_inst_chk_vld       = ldc_ex2_inst_vld
                                  &&  ldc_ld_inst
                                  &&  !ldc_lda_ex2_expt_vld_except_access_err
                                  &&  !ldc_utlb_miss
                                  &&  !ldc_page_so;
//------------------compare signal--------------------------
//-----------iid compare----------------
//compare the instruction in the entry is newer or older
//&Instance("wk_rtu_compare_iid","x_lsu_ld_dc_compare_st_dc_iid");
// //&Connect( .x_iid0         (st_dc_iid[IID_WIDTH-1:0]         ), @634
// //          .x_iid1         (ldc_ex2_iid[IID_WIDTH-1:0]         ), @635
// //          .x_iid0_older   (ldc_raw0_new          )); @636

//-----------addr compare---------------
//addr0 compare
assign ldc_cmp_lsdc0_addr0[`WK_PA_WIDTH-1:0] = lsdc0_ex2_addr0[`WK_PA_WIDTH-1:0];
assign ldc_cmp_lsdc1_addr0[`WK_PA_WIDTH-1:0] = lsdc1_ex2_addr0[`WK_PA_WIDTH-1:0];
assign ldc_raw0_addr_tto4_hit    = ldc_ex2_addr0[`WK_PA_WIDTH-1:4]
                                    ==  ldc_cmp_lsdc0_addr0[`WK_PA_WIDTH-1:4];
assign ldc_raw1_addr_tto4_hit    = ldc_ex2_addr0[`WK_PA_WIDTH-1:4]
                                    ==  ldc_cmp_lsdc1_addr0[`WK_PA_WIDTH-1:4];
// for cache buffer
assign ldc_raw0_addr1_tto4_hit   = ldc_ex2_addr1[`WK_PA_WIDTH-1:4]
                                    ==  ldc_cmp_lsdc0_addr0[`WK_PA_WIDTH-1:4];
assign ldc_raw1_addr1_tto4_hit   = ldc_ex2_addr1[`WK_PA_WIDTH-1:4]
                                    ==  ldc_cmp_lsdc1_addr0[`WK_PA_WIDTH-1:4];
//-----------bytes_vld compare----------
assign ldc_raw0_do_hit     = |(ldc_ex2_bytes_vld[15:0]  & lsdc0_ex2_bytes_vld[15:0]);
assign ldc_raw1_do_hit     = |(ldc_ex2_bytes_vld[15:0]  & lsdc1_ex2_bytes_vld[15:0]);
//------------------situation 2-----------------------------
assign ldc_depd0_st_dc2    = ldc_ex2_inst_chk_vld
                              &&  ldc_raw0_new
                              &&  (lsdc0_ex2_chk_st_inst_vld
                                  ||  lsdc0_ex2_chk_statomic_inst_vld)
                              &&  ldc_raw0_addr_tto4_hit
                              &&  ldc_raw0_do_hit;

assign ldc_depd1_st_dc2    = ldc_ex2_inst_chk_vld
                              &&  ldc_raw1_new
                              &&  (lsdc1_ex2_chk_st_inst_vld
                                  ||  lsdc1_ex2_chk_statomic_inst_vld)
                              &&  ldc_raw1_addr_tto4_hit
                              &&  ldc_raw1_do_hit;                                  
assign ldc_lda_ex2_us_discard    = ldc_ex2_inst_vld && ldc_lda_ex2_inst_us
                                   && ldc_lda_ex2_dcache_hit
                                   && !(ldc_hit_way == ldc_ex2_us_way);
//------------------situation 3-----------------------------
// when ld addr hit st, then do not get data from merge buffer
assign ldc_depd0_st_dc3    = ldc_ex2_inst_chk_vld
                              &&  ldc_raw0_new
                              &&  lsdc0_ex2_inst_vld  && !lsdc0_ex2_is_load
                              &&  ldc_raw0_addr1_tto4_hit;
assign ldc_depd1_st_dc3    = ldc_ex2_inst_chk_vld
                              &&  ldc_raw1_new
                              &&  lsdc1_ex2_inst_vld  && !lsdc1_ex2_is_load
                              &&  ldc_raw1_addr1_tto4_hit;                             

//------------------combine---------------------------------
assign ldc_depd_st_dc     = ldc_depd0_st_dc2 || ldc_depd1_st_dc2;

//==========================================================
//                 Dependency check
//==========================================================
// dependency check is done in sq/wmb entry file
//------------------arbitrate-------------------------------
//-----------forward arbitrate----------
//bypass: pass data from ex1
//fwd: pass data from sq/wmb
//if ld_dc_fwd_sq_bypass_vld=1, and ldc_lda_ex2_fwd_sq_vld=1,
//then see as multi depd in da
assign ldc_lda_ex2_fwd_sq_vld         = sq_ldc_ex2_fwd_req;
// &Force("output","ldc_lda_ex2_fwd_wmb_vld"); @678
assign ldc_lda_ex2_fwd_wmb_vld        = !sq_ldc_ex2_has_fwd_req
                                       &&  wmb_ldc_fwd_req;

// &CombBeg; @682
always @( wmb_ldc_fwd_req
       or wmb_fwd_bytes_vld[15:0]
       or sq_ldc_ex2_has_fwd_req)
begin
case({sq_ldc_ex2_has_fwd_req,wmb_ldc_fwd_req})
  2'b11:ldc_lda_ex2_fwd_bytes_vld[15:0] = 16'hffff;
  2'b10:ldc_lda_ex2_fwd_bytes_vld[15:0] = 16'hffff;
  2'b01:ldc_lda_ex2_fwd_bytes_vld[15:0] = wmb_fwd_bytes_vld[15:0];
  2'b00:ldc_lda_ex2_fwd_bytes_vld[15:0] = 16'h0;
  default:ldc_lda_ex2_fwd_bytes_vld[15:0] = {16{1'bx}};
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
assign ldc_lq_full_req        = ldc_lq_ex2_create_dp_vld && lq_ldc_ex2_full
                                || ld_dc_lq_create1_dp_vld && lq_ldc_ex2_less2;

assign ldc_depd_imme_restart_req  = ldc_depd_st_dc;

assign ldc_utlb_miss_vld      = ldc_ex2_inst_vld
                                &&  !ldc_lda_ex2_expt_vld_except_access_err
                                &&  ldc_utlb_miss;

assign ldc_depd_imme_restart_vld    = !ldc_utlb_miss_vld
                                      &&  ldc_depd_imme_restart_req;

assign ldc_lq_full_vld          = ldc_lq_full_req
                                  &&  !ldc_depd_imme_restart_req
                                  &&  !ldc_utlb_miss_vld;

assign ldc_ex2_full_gateclk_en  = ldc_lq_ex2_create_gateclk_en
                                  &&  lq_ldc_ex2_less2;

assign ldc_restart_vld          = ldc_lq_full_req
                                  ||  ldc_depd_imme_restart_req
                                  ||  ldc_utlb_miss_vld;

//---------------------restart kinds------------------------
// assign ldc_imme_restart_vld       = ldc_utlb_miss_vld
//                                     &&  !ldc_tlb_busy
//                                     ||  ldc_depd_imme_restart_vld;
assign ldc_imme_restart_vld       = ldc_depd_imme_restart_vld
                                    || ldc_tlb_imme_wakeup; // wjh@tmq
// assign ldc_tlb_busy_restart_vld   = ldc_utlb_miss_vld
//                                     &&  ldc_tlb_busy;
assign ldc_tlb_busy_restart_vld   = 1'b0;
assign ldc_ex2_tlb_busy_gateclk_en  = ldc_tlb_busy_restart_vld;

//==========================================================
//        Combine signal of spec_fail
//==========================================================
  assign ldc_lda_ex2_spec_fail      = lq_ldc0_ex2_rar_spec_fail
                                      && !ldc_ldamo_inst
                                      ||  ldc_lsiq_spec_fail;

//==========================================================
//            Generage get dcache signal
//==========================================================
//this data_bias_sel is for wmb/dcache
// //&Force("output","ldc_data_bias_sel"); @818
// //&Force("bus","ldc_data_bias_sel",3,0); @819

// &CombBeg; @821
always @( ldc_ex2_addr0[3:2]
       or mmu_lsu_data_req_size)
begin
case({mmu_lsu_data_req_size,ldc_ex2_addr0[3:2]})
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

assign ldc_lda_ex2_bytes_vld[15:0] = ldc_borrow_mmu_vld ? mmu_bytes_vld[15:0]
                                                          : ldc_ex2_bytes_vld[15:0];
assign ldc_lda_ex2_bytes_vld1[15:0] = ldc_ex2_bytes_vld1[15:0];
assign ldc_lda_ex2_bytes_vld2[15:0] = ldc_ex2_bytes_vld2[15:0];
assign ldc_lda_ex2_bytes_vld3[15:0] = ldc_ex2_bytes_vld3[15:0];

assign ldc_data_bias_sel[0] = |ldc_lda_ex2_bytes_vld[3:0];
assign ldc_data_bias_sel[1] = |ldc_lda_ex2_bytes_vld[7:4];
assign ldc_data_bias_sel[2] = |ldc_lda_ex2_bytes_vld[11:8];
assign ldc_data_bias_sel[3] = |ldc_lda_ex2_bytes_vld[15:12];

//if deform/mmu double word, then open 2 groups of banks
assign ldc_dup_dcache_data_en   = ldc_ex2_inst_vld 
                                  || ldc_borrow_mmu_vld;

assign ldc_get_dcache_data_inst_mmu[3:0]     =  {4{ldc_dup_dcache_data_en}}
                                                & ldc_data_bias_sel[3:0];
// &Force("output","ldc_lda_ex2_borrow_wmb"); @849
assign ldc_get_dcache_data_all      = ldc_ex2_borrow_vld
                                    &&  !ldc_lda_ex2_borrow_mmu
                                    &&  !ldc_lda_ex2_borrow_prq
                                    &&  !ldc_lda_ex2_borrow_wmb;

assign ldc_lda_ex2_get_dcache_data[3:0] = (ldc_get_dcache_data_all 
                                    || ldc_acclr_en && ldc_ex2_inst_vld
                                    || ldc_lda_ex2_inst_us && ldc_ex2_inst_vld)
                                    ? 4'b1111
                                    : (ldc_ex2_borrow_vld && ldc_lda_ex2_borrow_wmb
                                       ? ldc_lda_ex2_borrow_wmb_get_data[3:0]
                                       : ldc_get_dcache_data_inst_mmu[3:0]);

//==========================================================
//            Generage to DA stage signal
//==========================================================
assign ldc_lda_ex2_inst_vld          = ldc_ex2_inst_vld
                                       &&  !ldc_restart_vld;
//------------------page info sel if mmu req----------------
// &Force("output","ldc_lda_ex2_page_ca"); @876
assign ldc_borrow_mmu_vld            = ldc_ex2_borrow_vld  &&  ldc_lda_ex2_borrow_mmu;
assign ldc_lda_ex2_page_so           = ldc_ex2_borrow_vld  ? 1'b0
                                                           : ldc_page_so;
assign ldc_lda_ex2_page_ca           = ldc_ex2_borrow_vld  ? 1'b1
                                                            : ldc_page_ca;
assign ldc_lda_ex2_page_buf          = ldc_ex2_borrow_vld  ? 1'b1
                                                            : ldc_page_buf;
assign ldc_lda_ex2_page_sec          = ldc_ex2_borrow_vld  ? 1'b0
                                                            : ldc_page_sec;
assign ldc_lda_ex2_page_share        = ldc_ex2_borrow_vld  ? 1'b1
                                                            : ldc_page_share;
//------------------regard mmu request as old---------------
//because the old inst may cause tlb refill
assign ldc_lda_ex2_old               = ldc_borrow_mmu_vld  ? 1'b1
                                                          : ldc_old;
//------------------dcache tag pre_compare----------------
assign ldc_dcache_tag_array[`WK_LS_DCACHE_LDTAG_WIDTH-1:0]  = dcache_lsu_ld_tag_dout[`WK_LS_DCACHE_LDTAG_WIDTH-1:0];  //67->135, 2way->4way, LTL@20250319

//for ecc inj prepare
//inject errror  data to check the ecc of correct and stable
assign ldc_lda_ex2_tag_inj_dp  = ldc_ex2_inst_vld
                              && ldc_lda_ex2_page_ca
                              && cp0_lsu_dcache_en
                              && cp0_lsu_ecc_en
                              && !ldc_lda_ex2_expt_vld_except_access_err
                              && !ldc_utlb_miss_vld
                           || ldc_ex2_borrow_vld
                              && ldc_lda_ex2_borrow_mmu;

assign ldc_lda_ex2_data_inj_dp = ldc_ex2_inst_vld
                                  && ldc_lda_ex2_page_ca
                                  && cp0_lsu_dcache_en
                                  && cp0_lsu_ecc_en
                                  && !ldc_lda_ex2_expt_vld_except_access_err
                                  && !ldc_utlb_miss_vld
                              || ldc_ex2_borrow_vld
                                  && !ldc_lda_ex2_borrow_icc;

assign ldc_way0_tag_hit   = (ldc_ex2_addr0[`WK_PA_WIDTH-1:14] == ldc_dcache_tag_array[`WK_LS_DCACHE_SINGLE_TAG_WIDTH-1:0]);

assign ldc_way1_tag_hit   = (ldc_ex2_addr0[`WK_PA_WIDTH-1:14] == ldc_dcache_tag_array[`WK_LS_DCACHE_SINGLE_TAG_WIDTH+`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH]);

assign ldc_way2_tag_hit   = (ldc_ex2_addr0[`WK_PA_WIDTH-1:14] == ldc_dcache_tag_array[`WK_LS_DCACHE_SINGLE_TAG_WIDTH+`WK_LS_DCACHE_DOUBLE_LDTAG_WIDTH-1:`WK_LS_DCACHE_DOUBLE_LDTAG_WIDTH]);

assign ldc_way3_tag_hit   = (ldc_ex2_addr0[`WK_PA_WIDTH-1:14] == ldc_dcache_tag_array[`WK_LS_DCACHE_SINGLE_TAG_WIDTH+`WK_LS_DCACHE_TRIPLE_LDTAG_WIDTH-1:`WK_LS_DCACHE_TRIPLE_LDTAG_WIDTH]);

assign ldc_dcache_valid0  = ldc_dcache_tag_array[`WK_LS_DCACHE_SINGLE_TAG_WIDTH]
                            &&  cp0_lsu_dcache_en
                            &&  ldc_lda_ex2_page_ca;
// &Force("output","ldc_hit_way0"); @932
assign ldc_dcache_valid1  = ldc_dcache_tag_array[`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH+`WK_LS_DCACHE_SINGLE_TAG_WIDTH]
                            &&  cp0_lsu_dcache_en
                            &&  ldc_lda_ex2_page_ca;
assign ldc_dcache_valid2  = ldc_dcache_tag_array[`WK_LS_DCACHE_DOUBLE_LDTAG_WIDTH+`WK_LS_DCACHE_SINGLE_TAG_WIDTH]
                            &&  cp0_lsu_dcache_en
                            &&  ldc_lda_ex2_page_ca;
assign ldc_dcache_valid3  = ldc_dcache_tag_array[`WK_LS_DCACHE_TRIPLE_LDTAG_WIDTH+`WK_LS_DCACHE_SINGLE_TAG_WIDTH]
                            &&  cp0_lsu_dcache_en
                            &&  ldc_lda_ex2_page_ca;

assign ldc_hit_way0       = ldc_dcache_valid0
                            &&  ldc_way0_tag_hit; 
assign ldc_hit_way1       = ldc_dcache_valid1
                             &&  ldc_way1_tag_hit; 
assign ldc_hit_way2       = ldc_dcache_valid2
                             &&  ldc_way2_tag_hit; 
assign ldc_hit_way3       = ldc_dcache_valid3
                             &&  ldc_way3_tag_hit; 

assign ldc_hit_way        = {ldc_hit_way3,ldc_hit_way2,ldc_hit_way1,ldc_hit_way0};
// &Force("output","ldc_lda_ex2_dcache_hit"); @947
assign ldc_lda_ex2_dcache_hit     = ldc_hit_way0  ||  ldc_hit_way1 || ldc_hit_way2 || ldc_hit_way3;


//assign ldc_lda_ex2_hit_low_region = ldc_ex2_addr0[4]
//                                    ? ldc_hit_way1
//                                    : ldc_hit_way0;
//assign ldc_lda_ex2_hit_high_region= ldc_ex2_addr0[4]
//                                    ? ldc_hit_way0
//                                    : ldc_hit_way1;
always @( ldc_ex2_addr0[5:4]
          or ldc_hit_way0
          or ldc_hit_way1
          or ldc_hit_way2
          or ldc_hit_way3)
begin
case(ldc_ex2_addr0[5:4])
  2'b11: begin
    ldc_lda_ex2_hit_3_region = ldc_hit_way0;
    ldc_lda_ex2_hit_2_region = ldc_hit_way1;
    ldc_lda_ex2_hit_1_region = ldc_hit_way2;
    ldc_lda_ex2_hit_0_region = ldc_hit_way3;
  end 
  
  2'b10: begin
    ldc_lda_ex2_hit_3_region = ldc_hit_way1;
    ldc_lda_ex2_hit_2_region = ldc_hit_way0;
    ldc_lda_ex2_hit_1_region = ldc_hit_way3;
    ldc_lda_ex2_hit_0_region = ldc_hit_way2;
  end 
  2'b01: begin
    ldc_lda_ex2_hit_3_region = ldc_hit_way2;
    ldc_lda_ex2_hit_2_region = ldc_hit_way3;
    ldc_lda_ex2_hit_1_region = ldc_hit_way0;
    ldc_lda_ex2_hit_0_region = ldc_hit_way1;
  end 
  2'b00: begin
    ldc_lda_ex2_hit_3_region = ldc_hit_way3;
    ldc_lda_ex2_hit_2_region = ldc_hit_way2;
    ldc_lda_ex2_hit_1_region = ldc_hit_way1;
    ldc_lda_ex2_hit_0_region = ldc_hit_way0;
  end   
  default: {ldc_lda_ex2_hit_3_region,ldc_lda_ex2_hit_2_region,ldc_lda_ex2_hit_1_region,ldc_lda_ex2_hit_0_region} = 4'b0;
endcase
end
//------------------icc read tag info----------------
assign ldc_lda_ex2_icc_tag_vld  = ldc_ex2_borrow_vld
                                  && ldc_lda_ex2_borrow_icc
                                  && ldc_lda_ex2_borrow_icc_tag;
//assign ldc_lda_ex2_tag_read[33:0] = ldc_lda_ex2_settle_way
//                                    ? dcache_lsu_ld_tag_dout[67:34]
//                                    : dcache_lsu_ld_tag_dout[33:0];
always @( ldc_lda_ex2_settle_way[1:0]
          or dcache_lsu_ld_tag_dout[`WK_LS_DCACHE_LDTAG_WIDTH-1:0])
begin
case(ldc_lda_ex2_settle_way[1:0])
  2'b11: ldc_lda_ex2_tag_read[`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0] = dcache_lsu_ld_tag_dout[`WK_LS_DCACHE_LDTAG_WIDTH-1        :`WK_LS_DCACHE_TRIPLE_LDTAG_WIDTH];  //way0
  2'b10: ldc_lda_ex2_tag_read[`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0] = dcache_lsu_ld_tag_dout[`WK_LS_DCACHE_TRIPLE_LDTAG_WIDTH-1 :`WK_LS_DCACHE_DOUBLE_LDTAG_WIDTH];  //way1
  2'b01: ldc_lda_ex2_tag_read[`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0] = dcache_lsu_ld_tag_dout[`WK_LS_DCACHE_DOUBLE_LDTAG_WIDTH-1 :`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH];  //way2
  2'b00: ldc_lda_ex2_tag_read[`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0] = dcache_lsu_ld_tag_dout[`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1 :0];  //way3
  default: ldc_lda_ex2_tag_read[`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0] = {`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH{1'b0}};
endcase
end

//------------------data pre_select----------------
//for mmu select
assign mmu_rot_sel[3:0]   = mmu_lsu_data_req_size
                            ? {ldc_ex2_addr0[3],3'b0}
                            : {ldc_ex2_addr0[3:2],2'b0};

assign ldc_rot_sel_final[3:0] = ldc_borrow_mmu_vld
                                   ? mmu_rot_sel[3:0]
                                   : ldc_rot_sel[3:0]; 

// &CombBeg;    @979
always @( ldc_rot_sel_final[3:0])
begin
casez(ldc_rot_sel_final[3:0])
  4'h0:ldc_lda_ex2_rot_sel[15:0]  = 16'b0000000000000001;
  4'h1:ldc_lda_ex2_rot_sel[15:0]  = 16'b0000000000000010;
  4'h2:ldc_lda_ex2_rot_sel[15:0]  = 16'b0000000000000100;
  4'h3:ldc_lda_ex2_rot_sel[15:0]  = 16'b0000000000001000;
  4'h4:ldc_lda_ex2_rot_sel[15:0]  = 16'b0000000000010000;
  4'h5:ldc_lda_ex2_rot_sel[15:0]  = 16'b0000000000100000;
  4'h6:ldc_lda_ex2_rot_sel[15:0]  = 16'b0000000001000000;
  4'h7:ldc_lda_ex2_rot_sel[15:0]  = 16'b0000000010000000;
  4'h8:ldc_lda_ex2_rot_sel[15:0]  = 16'b0000000100000000;
  4'h9:ldc_lda_ex2_rot_sel[15:0]  = 16'b0000001000000000;
  4'ha:ldc_lda_ex2_rot_sel[15:0]  = 16'b0000010000000000;
  4'hb:ldc_lda_ex2_rot_sel[15:0]  = 16'b0000100000000000;
  4'hc:ldc_lda_ex2_rot_sel[15:0]  = 16'b0001000000000000;
  4'hd:ldc_lda_ex2_rot_sel[15:0]  = 16'b0010000000000000;
  4'he:ldc_lda_ex2_rot_sel[15:0]  = 16'b0100000000000000;
  4'hf:ldc_lda_ex2_rot_sel[15:0]  = 16'b1000000000000000;
  default:ldc_lda_ex2_rot_sel[15:0]  = {16{1'bx}};
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
always @( ldc_lda_ex2_sext
       or ldc_lda_ex2_inst_size[1:0])
begin
case({ldc_lda_ex2_sext,ldc_lda_ex2_inst_size[1:0]})
  {1'b1,S_BYTE}:ldc_lda_ex2_preg_sign_sel[3:0]  = 4'b0010;
  {1'b1,HALF}:ldc_lda_ex2_preg_sign_sel[3:0]    = 4'b0100;
  {1'b1,WORD}:ldc_lda_ex2_preg_sign_sel[3:0]    = 4'b1000;
  default:ldc_lda_ex2_preg_sign_sel[3:0]        = 4'b0001;
endcase
// &CombEnd; @1028
end

// &Force("output","ldc_lda_ex2_inst_vls"); @1031
assign ldc_lda_ex2_vreg_sign_sel  = ldc_lda_ex2_inst_vls
                                    ? ldc_lda_ex2_sext
                                    : (ldc_lda_ex2_inst_size[1:0]  !=  2'b11);

// &Force("output","ldc_lda_ex2_element_cnt"); @1044
// &Force("output","ldc_lda_ex2_element_size"); @1045
// &Force("output","ldc_lda_ex2_vsew"); @1046
//----------fof_vl_sel--------------------
// &CombBeg;    @1048
always @( ldc_ex2_bytes_vld[15:0])
begin
casez(ldc_ex2_bytes_vld[15:0])
  16'b???????????????1:ldc_first_byte[3:0] = 4'h0;
  16'b??????????????10:ldc_first_byte[3:0] = 4'h1;
  16'b?????????????100:ldc_first_byte[3:0] = 4'h2;
  16'b????????????1000:ldc_first_byte[3:0] = 4'h3;
  16'b???????????10000:ldc_first_byte[3:0] = 4'h4;
  16'b??????????100000:ldc_first_byte[3:0] = 4'h5;
  16'b?????????1000000:ldc_first_byte[3:0] = 4'h6;
  16'b????????10000000:ldc_first_byte[3:0] = 4'h7;
  16'b???????100000000:ldc_first_byte[3:0] = 4'h8;
  16'b??????1000000000:ldc_first_byte[3:0] = 4'h9;
  16'b?????10000000000:ldc_first_byte[3:0] = 4'ha;
  16'b????100000000000:ldc_first_byte[3:0] = 4'hb;
  16'b???1000000000000:ldc_first_byte[3:0] = 4'hc;
  16'b??10000000000000:ldc_first_byte[3:0] = 4'hd;
  16'b?100000000000000:ldc_first_byte[3:0] = 4'he;
  16'b1000000000000000:ldc_first_byte[3:0] = 4'hf;//first ld effctive byte num
  default:ldc_first_byte[3:0]  = 4'h0;
endcase
// &CombEnd; @1068
end

// &CombBeg; @1070
always @( ldc_first_byte[3:0]
       or ldc_lda_ex2_element_size[1:0])
begin
case(ldc_lda_ex2_element_size[1:0])
  S_BYTE: ld_first_element_ori[3:0] = ldc_first_byte[3:0]; 
  HALF:   ld_first_element_ori[3:0] = {1'b0,ldc_first_byte[3:1]}; 
  WORD:   ld_first_element_ori[3:0] = {2'b0,ldc_first_byte[3:2]}; 
  DWORD:  ld_first_element_ori[3:0] = {3'b0,ldc_first_byte[3]};
  default:ld_first_element_ori[3:0] = {4{1'bx}}; 
endcase
// &CombEnd; @1078
end

assign ldc_boundary_first  = ldc_lda_ex2_boundary && !ldc_ex2_secd;

// &CombBeg; @1082
always @( ldc_first_byte[2:0]
       or ldc_lda_ex2_element_size[1:0])
begin
case(ldc_lda_ex2_element_size[1:0])
  HALF:   ld_first_byte_unalign =  ldc_first_byte[0]; 
  WORD:   ld_first_byte_unalign = |ldc_first_byte[1:0]; 
  DWORD:  ld_first_byte_unalign = |ldc_first_byte[2:0];
  default:ld_first_byte_unalign = 1'b0;
endcase
// &CombEnd; @1089
end
 
assign ld_first_element[3:0] = ldc_boundary_first && ld_first_byte_unalign
                               ? ld_first_element_ori[3:0] + 1'b1
                               : ld_first_element_ori[3:0]; 

assign setvl_val_byte[3:0] = ld_first_element[3:0] + ldc_secd_element_offset[3:0];
assign setvl_val_half[2:0] = ld_first_element[2:0] + ldc_secd_element_offset[2:0];
assign setvl_val_word[1:0] = ld_first_element[1:0] + ldc_secd_element_offset[1:0];
assign setvl_val_dword     = ld_first_element[0]   + ldc_secd_element_offset[0];//set vectore length

// &CombBeg; @1100
always @( setvl_val_byte[3:0]
       or setvl_val_dword
       or setvl_val_half[2:0]
       or setvl_val_word[1:0]
       or ldc_lda_ex2_vmew[1:0])//vestor standard element width
begin
case(ldc_lda_ex2_vmew[1:0])
  S_BYTE: setvl_val_low[3:0] = setvl_val_byte[3:0]; 
  HALF: setvl_val_low[3:0]   = {1'b0,setvl_val_half[2:0]}; 
  WORD: setvl_val_low[3:0]   = {2'b0,setvl_val_word[1:0]}; 
  DWORD:setvl_val_low[3:0]   = {3'b0,setvl_val_dword}; 
  default:setvl_val_low[3:0] = {4{1'bx}};
endcase
// &CombEnd; @1108
end

assign ldc_lda_ex2_setvl_val[8:0] = ldc_lda_ex2_element_cnt[8:0] + {5'b0,setvl_val_low[3:0]}; 

//==========================================================
//            Generage pfu signal
//==========================================================
// &Force("output","ldc_lda_ex2_pf_inst"); @1116
assign ldc_lda_ex2_pf_inst    = ld_dc_pf_inst
                                &&  !ldc_lda_ex2_vector_nop
                                &&  ldc_page_ca;

assign ldc_pf_inst_short      = ld_dc_pf_inst
                                &&  !ldc_lda_ex2_vector_nop
                                &&  ldc_page_ca
                                &&  !ldc_utlb_miss
                                &&  !ldc_lda_ex2_expt_vld_except_access_err;

assign ldc_lda_ex2_pfu_info_set_vld = ldc_ex2_inst_vld
                                      &&  ldc_pf_inst_short
                                      &&  (!pfu_sdb_empty
                                          ||  !pfu_pfb_empty
                                          ||  pfu_sdb_create_gateclk_en);

//==========================================================
//            Generage to cache buffer signal
//==========================================================
//cache buffer signal not be modified 
//------------------addr prepare----------------
assign ld_dc_cb_addr_tto4[`WK_PA_WIDTH-5:0] = ldc_ex2_addr0[`WK_PA_WIDTH-1:4];

// &Force("bus","dcache_idx","8","0"); @1139
assign cb_create_hit_idx   = (ldc_ex2_addr0[13:6]  ==  dcache_idx[7:0]);
// &Force("output","ld_dc_cb_addr_create_vld"); @1141
assign ld_dc_cb_addr_create_vld = ldc_ex2_inst_vld
                                  &&  ldc_ld_inst
                                  &&  ldc_acclr_en
                                  &&  !ldc_lda_ex2_vector_nop
                                  &&  !ldc_lda_ex2_expt_vld_except_access_err
                                  &&  !ldc_restart_vld
                                  &&  !(lsu_dcache_ld_xx_gwen
                                        && cb_create_hit_idx)
                                  && !rtu_lsu_flush_fe;
assign ld_dc_cb_addr_create_gateclk_en  = ldc_ex2_inst_vld
                                          &&  ldc_ld_inst
                                          &&  ldc_acclr_en
                                          &&  !ldc_lda_ex2_expt_vld_except_access_err
                                          &&  !rtu_lsu_flush_fe;

assign ld_dc_da_cb_addr_create  = ld_dc_cb_addr_create_vld;
assign ld_dc_da_cb_merge_en     = ldc_acclr_en
                                  &&  cb_ld_dc_addr_hit
                                  &&  !ldc_lda_ex2_vector_nop
                                  &&  !ldc_depd0_st_dc3                        //@wangyu 
                                  &&  !ldc_depd1_st_dc3
                                  &&  !sq_ldc_ex2_cancel_acc_req
                                  &&  !wmb_ld_dc_cancel_acc_req
                                  &&  !lq_ldc_ex2_inst_hit
                                  &&  !ldc_lda_ex2_expt_vld_except_access_err;

//==========================================================
//              Generate forward write back
//==========================================================
// &Force("output","ldc_lda_ex2_wait_fence"); @1170
assign ldc_lda_ex2_wait_fence         = lsu_has_fence
                                        &&  rb_fence_ld;

assign ldc_ahead_wb_vld         = ldc_ex2_inst_vld
                                  &&  !cp0_lsu_da_fwd_dis
                                  &&  ldc_page_ca
                                  &&  ldc_ld_inst
                                  &&  !ldc_lda_ex2_expt_vld_except_access_err
                                  &&  !ldc_lda_ex2_wait_fence
                                  &&  !ldc_lda_ex2_boundary
                                  &&  ldc_lda_ex2_dcache_hit;

assign ldc_lda_ex2_ahead_preg_wb_vld  = ldc_ahead_wb_vld
                                        &&  !sq_ldc_ex2_cancel_ahead_wb
                                        &&  !wmb_ld_dc_discard_req
                                        &&  !ldc_lda_ex2_inst_vfls;
//assign ldc_lda_ex2_ahead_vreg_wb_vld  = ldc_ahead_wb_vld
//                                  &&  !sq_ldc_ex2_cancel_ahead_wb
//                                  &&  !ldc_lda_ex2_inst_vls
//                                  &&  ldc_lda_ex2_inst_vfls;
assign ldc_lda_ex2_ahead_vreg_wb_vld = 1'b0;
//==========================================================
//      Generage lsiq signal (renamed in lsu_restart.vp)
//==========================================================
assign ldc_mask_lsid[LSIQENTRY-1:0]        = {LSIQENTRY{ldc_ex2_inst_vld}}
                                              & ldc_lda_ex2_lsid[LSIQENTRY-1:0];
assign ldc_idu_ex2_lq_full[LSIQENTRY-1:0]  = {LSIQENTRY{ldc_lq_full_vld}}
                                              & ldc_mask_lsid[LSIQENTRY-1:0];
assign ldc_ex2_imme_wakeup[LSIQENTRY-1:0]  = {LSIQENTRY{ldc_imme_restart_vld}}
                                              & ldc_mask_lsid[LSIQENTRY-1:0];
assign ldc_idu_ex2_tlb_busy[LSIQENTRY-1:0] = {LSIQENTRY{ldc_tlb_busy_restart_vld}}
                                              & ldc_mask_lsid[LSIQENTRY-1:0];
                                        
//==========================================================
//                Generage signal to idu
//==========================================================
assign lsu_idu_ex2_load_inst_vld        = ldc_load_inst_vld;
assign lsu_idu_ex2_load_fwd_inst_vld    = ldc_load_ahead_inst_vld;
assign lsu_idu_ex2_vload_inst_vld       = ldc_vload_inst_vld; 
assign lsu_idu_ex2_vload_fwd_inst_vld   = ldc_vload_ahead_inst_vld; 
assign lsu_idu_ex2_preg[PREG-1:0]  = ldc_lda_ex2_preg[PREG-1:0];
assign lsu_idu_ex2_vreg[VREG:0]  = {ldc_lda_ex2_inst_vls,ldc_lda_ex2_vreg[VREG-1:0]};
//==========================================================
//        for mmu power
//==========================================================
assign lsu_mmu_vabuf0[`WK_PA_WIDTH-13:0] = ldc_vpn[`WK_PA_WIDTH-13:0];

//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
always @(posedge ldc_inst_clk or negedge cpurst_b)
begin
  if (~cpurst_b)
  begin
    ld_dc_boundary_unmask                              <=  1'b0;
    ld_dc_dtu_addr[`WK_MA_WIDTH-1:0]                   <=  {`WK_MA_WIDTH{1'b0}};           
    ld_dc_dtu_addr_bytes_vld[15:0]                     <=  {16{1'b0}};         
    ld_dc_dtu_addr_type[1:0]                           <=  {2{1'b0}};   
    ld_dc_dtu_addr_size[2:0]                           <=  {3{1'b0}};   
    ld_dc_dtu_addr_halt_info[`TDT_MP_HINFO_WIDTH-1:0]  <=  {`TDT_MP_HINFO_WIDTH{1'b0}};  
    ld_dc_dtu_addr_last_check                          <=  1'b0;
  end
  else if(lag_ex1_inst_vld & ld_ag_dtu_vld)
  begin
    ld_dc_boundary_unmask                              <=  ld_ag_boundary_unmask;
    ld_dc_dtu_addr[`WK_MA_WIDTH-1:0]                   <=  ld_ag_dtu_va[`WK_MA_WIDTH-1:0];
    ld_dc_dtu_addr_bytes_vld[15:0]                     <=  lag_ldc_ex1_bytes_vld[15:0]; // 20260325 mark@zdb how to use lag_ldc_ex1_bytes_vld1?
    ld_dc_dtu_addr_type[1:0]                           <=  ld_ag_dtu_type[1:0];
    ld_dc_dtu_addr_size[2:0]                           <=  ld_ag_dtu_access_size[2:0];
    ld_dc_dtu_addr_halt_info[`TDT_MP_HINFO_WIDTH-1:0]  <=  ld_ag_halt_info[`TDT_MP_HINFO_WIDTH-1:0];
    ld_dc_dtu_addr_last_check                          <=  ld_ag_dtu_last_check;
  end
end

always @(posedge ldc_inst_clk or negedge cpurst_b)
begin
  if (~cpurst_b)
  begin
    ld_dc_dtu_addr_vld                                  <=  1'b0;
  end
  else if(lag_ex1_inst_vld & ld_ag_dtu_vld)
  begin
    ld_dc_dtu_addr_vld                                 <=  ld_ag_dtu_vld;
  end
end
//==========================================================
//                  Risc-V Debug zdb End 
//==========================================================
// &ModuleEnd; @1244
endmodule


