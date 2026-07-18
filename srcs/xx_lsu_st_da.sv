//-----------------------------------------------------------------------------
// File          : xx_lsu_st_da.v
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


// $Id: xx_lsu_st_da.vp,v 1.91 2022/05/09 09:46:35 jiamh Exp $
// *****************************************************************************

// &ModuleBeg; @26
module xx_lsu_ls_st_da #(
  parameter IID_WIDTH   = 7,
  parameter LSIQ_ENTRY  = 12,
  parameter SNQ_ENTRY   = 6,
  parameter PC_LEN      = 15,
  parameter WK_PA_WIDTH = 40
)(
// &Ports; @27
input logic                                                 rtu_ck_flush,
input logic  [IID_WIDTH-1  :0]                              rtu_ck_flush_iid,
input logic                                                 amr_wa_cancel,                       
input logic                                                 cp0_lsu_dcache_en,                   
input logic                                                 cp0_lsu_ecc_en,                      
input logic                                                 cp0_lsu_icg_en,                      
input logic                                                 cp0_lsu_l2_st_pref_en,               
input logic                                                 cp0_lsu_nsfe,                        
input logic                                                 cp0_lsu_tag_ecc_inj,                 
input logic   [`WK_LS_DCAHCE_SINGLE_MATE_TAG_WIDTH-1:0]     cp0_lsu_tag_random1,                 
input logic   [`VSTART_WIDTH-1 :0]                                        cp0_lsu_vstart,                      
input logic                                                 cpurst_b,                            
input logic                                                 ctrl_st_clk,                         
input logic   [15:0]                                        dcache_dirty_din,      //8->16, L1D 2way->4way, LTL@20250321              
input logic                                                 dcache_dirty_gwen,                   
input logic   [15:0]                                        dcache_dirty_wen,      //8->16, L1D 2way->4way, LTL@20250321                
input logic   [7 :0]                                        dcache_idx,            //8->7, L1D 2way->4way, LTL@20250321               
input logic   [`WK_LS_DCACHE_META_WIDTH-1:0]                dcache_lsu_st_dirty_dout,   //[44]deleted, ask lishuo,  LTL@20250321         
input logic   [`WK_LS_DCACHE_TAG_NOECC_WIDTH-1:0]           dcache_lsu_st_tag_dout, //51->103, L1D 2way->4way, LTL@20250321               
input logic   [`WK_LS_DCACHE_TAG_NOECC_WIDTH-1:0]           dcache_tag_din,         //51->103, L1D 2way->4way, LTL@20250321             
input logic                                                 dcache_tag_gwen,                     
input logic   [3 :0]                                        dcache_tag_wen,         //1->3, 4 tags, L1D 2way->4way, LTL@20250321              
input logic   [1 :0]                                        lsda_ex2_replace_way,
input logic                                                 forever_cpuclk,                      
input logic                                                 ld_da_ecc_stall,        //lishuo find this error, ld da ecc stall cannot stall st_da_borrow_vld!!! LTL@20250213   
input logic                                                 lda0_lsda_ex3_hit_idx,  //1->3, st da need consider lda0 lda1 lsda hit idx, LTL@20241025
input logic                                                 lsda_lsda_ex3_hit_idx,  //how to use, 2 st da create rb???, discard two or one, LTL@20241025
input logic                                                 lsda_lsda_ex3_is_load,  //newly add for rb create, LTL@20241025
input logic   [IID_WIDTH-1:0]                               lsda_lsda_ex3_iid,      //newly add for 2 st da, rb create, LTL@20241025  ???age 
input logic                                                 lda0_lsda_ex3_tag_inj_mask,   //1->2, need receive lda0 and another lsda, LTL@20241109
input logic                                                 lsda_lsda_ex3_tag_inj_mask,  
input logic                                                 lfb_lsda_ex3_hit_idx,                   
input logic                                                 lm_lsda_ex3_hit_idx,                    
input logic                                                 lsu_has_fence,                       
input logic                                                 mmu_lsu_access_fault,               
input logic                                                 pad_yy_icg_scan_en,                  
input logic   [`WK_PA_WIDTH-1:0]                            pfu_biu_req_addr,                    
input logic                                                 rb_lsda_ex3_full,                       
input logic                                                 rb_lsda_ex3_hit_idx,                    
input logic                                                 rtu_lsu_flush_fe,                    
input logic                                                 rtu_yy_xx_commit0,
input logic                                                 rtu_yy_xx_commit1,
input logic                                                 rtu_yy_xx_commit2, 
input logic                                                 rtu_yy_xx_commit3,
input logic                                                 rtu_yy_xx_commit4, 
input logic                                                 rtu_yy_xx_commit5,
input logic                                                 rtu_yy_xx_commit6,
input logic                                                 rtu_yy_xx_commit7,
input logic   [IID_WIDTH-1:0]                               rtu_yy_xx_commit0_iid,           //parameterized, LTL@20241021               
input logic   [IID_WIDTH-1:0]                               rtu_yy_xx_commit1_iid,              
input logic   [IID_WIDTH-1:0]                               rtu_yy_xx_commit2_iid,
input logic   [IID_WIDTH-1:0]                               rtu_yy_xx_commit3_iid,              
input logic   [IID_WIDTH-1:0]                               rtu_yy_xx_commit4_iid,              
input logic   [IID_WIDTH-1:0]                               rtu_yy_xx_commit5_iid,    
input logic   [IID_WIDTH-1:0]                               rtu_yy_xx_commit6_iid,               
input logic   [IID_WIDTH-1:0]                               rtu_yy_xx_commit7_iid,  
input logic                                                 lsdc_ex2_is_load,         
input logic   [`WK_PA_WIDTH-1:0]                            lsdc_ex2_addr0,                         
input logic                                                 lsdc_lsda_ex2_already_da,                    
input logic                                                 lsdc_ex2_atomic,                                         
input logic                                                 lsdc_lsda_ex2_borrow_dcache_replace,         
input logic   [1  :0]                                       lsdc_lsda_ex2_borrow_dcache_sw,              
input logic                                                 lsdc_lsda_ex2_borrow_icc,                    
input logic                                                 lsdc_lsda_ex2_borrow_snq,                    
input logic   [SNQ_ENTRY-1:0]                               lsdc_lsda_ex2_borrow_snq_id,                 
input logic                                                 lsdc_ex2_borrow_vld,                    
input logic                                                 lsdc_ex2_boundary,                      
input logic   [15:0]                                        lsdc_ex2_bytes_vld,                     
input logic   [15:0]                                        lsdc_lsda_ex2_dcache_dirty_array,    //8->16, LTL@20250321     
input logic   [`WK_LS_DCACHE_TAG_NOECC_WIDTH-1:0]           lsdc_lsda_ex2_dcache_tag_array,     //51->103, LTL@20250321       
input logic                                                 lsdc_lsda_ex2_expt_vld_gate_en,           
input logic                                                 lsdc_lsda_ex2_inst_vld,                   
input logic                                                 lsdc_ex2_page_buf,                   
input logic                                                 lsdc_ex2_page_ca,                    
input logic                                                 lsdc_ex2_page_sec,                   
input logic                                                 lsdc_ex2_page_share,                 
input logic                                                 lsdc_ex2_page_so,                    
input logic                                                 lsdc_ex2_page_wa,                    
input logic                                                 lsdc_lsda_ex2_staddr_vld,                 
input logic                                                 lsdc_lsda_ex2_tag0_hit,                   
input logic                                                 lsdc_lsda_ex2_tag1_hit,
input logic                                                 lsdc_lsda_ex2_tag2_hit,                   
input logic                                                 lsdc_lsda_ex2_tag3_hit,                   
input logic                                                 lsdc_lsda_ex2_dcwp_hit_idx,                  
input logic   [8 :0]                                        lsdc_lsda_ex2_element_cnt,                   
input logic                                                 lsdc_lsda_ex2_expt_access_fault_extra,       
input logic                                                 lsdc_lsda_ex2_expt_access_fault_mask,        
input logic   [4 :0]                                        lsdc_lsda_ex2_expt_vec,                      
input logic                                                 lsdc_lsda_ex2_expt_vld_except_access_err,    
input logic   [3 :0]                                        lsdc_ex2_fence_mode,                    
input logic                                                 lsdc_lsda_ex2_get_dcache_tag_dirty,          
input logic                                                 lsdc_ex2_icc,                           
input logic   [IID_WIDTH-1:0]                               lsdc_ex2_iid,                           
input logic   [1 :0]                                        lsdc_ex2_inst_mode,                     
input logic   [2 :0]                                        lsdc_ex2_inst_size,                     
input logic   [1 :0]                                        lsdc_ex2_inst_type,                     
input logic                                                 lsdc_ex2_inst_vld,                      
input logic                                                 lsdc_ex2_inst_vls,                      
input logic   [LSIQ_ENTRY-1:0]                              lsdc_lsda_ex2_lsid,                          
input logic                                                 lsdc_lsda_ex2_mmu_req,                       
input logic   [`WK_PA_WIDTH-1:0]                            lsdc_lsda_ex2_mt_value,                      
input logic   [1 :0]                                        lsdc_lsda_ex2_no_spec,                       
input logic                                                 lsdc_ex2_old,                           
input logic   [PC_LEN-1:0]                                  lsdc_lsda_ex2_pc,                            
input logic                                                 lsdc_lsda_ex2_pf_inst,                       
input logic   [`WK_PA_WIDTH-1:0]                            lsdc_lsda_ex2_pfu_va,                        
input logic                                                 lsdc_ex2_secd,                          
input logic                                                 lsdc_lsda_ex2_spec_fail,                     
input logic   [PC_LEN-1:0]                                  lq_lsu_ex2_spec_fail_pc, // wjh@sfp
input logic                                                 lsdc_lsda_ex2_split,                         
input logic                                                 lsdc_lsda_ex2_st,                            
input logic                                                 lsdc_lsda_ex2_sync_fence,                    
input logic                                                 lsdc_lsda_ex2_tag_inj_dp,                    
input logic                                                 lsdc_ex2_vector_nop,       
input logic   [`WK_PA_WIDTH-1:0]                            lsda_selfda_ex3_addr,         //new add for st-st rb create_hit_idx, LTL@20241120  
output logic                                                selfda_lsda_ex3_hit_idx,      
output logic                                                lsu_hpcp_ls_cache_access,            
output logic                                                lsu_hpcp_ls_cache_miss,              
output logic                                                lsu_hpcp_ls_unalign_inst,            
output logic  [IID_WIDTH-1:0]                               lsu_rtu_ex3_ssf_iid, 
output logic                                                lsu_rtu_ex3_ssf_vld, 
output logic                                                lsu_lsda_tag_inj_cmplt,  
output logic                                                lsda_ex3_is_load,            
output logic  [`WK_PA_WIDTH-1:0]                            lsda_ex3_addr,                                            
output logic                                                lsda_ex3_borrow_icc_vld,                
output logic                                                lsda_ex3_borrow_vld,                    
output logic                                                lsda_vb_ex3_dcache_dirty,                  
output logic                                                lsda_ex3_dcache_hit,                    
output logic                                                lsda_vb_ex3_dcache_miss,                   
output logic                                                lsda_vb_ex3_dcache_page_share,             
output logic                                                lsda_vb_ex3_dcache_replace_dirty,          
output logic                                                lsda_vb_ex3_dcache_replace_page_share,     
output logic                                                lsda_vb_ex3_dcache_replace_valid,          
output logic  [1:0]                                         lsda_vb_ex3_dcache_replace_way,   //1->2bit for 4way, L1D 2->4way, LTL@20250321          
output logic  [1:0]                                         lsda_vb_ex3_dcache_way,   //L1D 2->4way, LTL@20250321                 
output logic  [22:0]                                        lsda_ex3_ecc_info,                      
output logic                                                lsda_ex3_ecc_info_update,               
output logic                                                lsda_ex3_ecc_info_update_gate,          
output logic  [`WK_PA_WIDTH-1:0]                            lsda_ex3_ecc_pa,                        
output logic  [LSIQ_ENTRY-1:0]                              lsda_ex3_ecc_wakeup,                    
output logic  [8 :0]                                        lsda_lswb_ex3_element_cnt,                   
output logic                                                lsda_ex3_fence_inst,                    
output logic  [3 :0]                                        lsda_ex3_fence_mode,                    
output logic  [3 :0]                                        lsda_icc_ex3_dirty_info,                
output logic  [`WK_LS_DCACHE_SINGLE_DIRTY_ECC_WIDTH-1:0]    lsda_icc_ex3_ecc_info,                  
output logic  [`WK_LS_DCACHE_SINGLE_TAG_WIDTH-1:0]          lsda_icc_ex3_tag_info,                  
output logic  [LSIQ_ENTRY-1:0]                              lsda_idu_ex3_already_da,                               
output logic  [LSIQ_ENTRY-1:0]                              lsda_idu_ex3_boundary_gateclk_en,       
output logic  [LSIQ_ENTRY-1:0]                              lsda_idu_ex3_pop_entry,                 
output logic                                                lsda_idu_ex3_pop_vld,                   
output logic  [LSIQ_ENTRY-1:0]                              lsda_idu_ex3_rb_full,                   
output logic  [LSIQ_ENTRY-1:0]                              lsda_idu_ex3_secd,                      
output logic  [LSIQ_ENTRY-1:0]                              lsda_idu_ex3_spec_fail,                 
output logic  [LSIQ_ENTRY-1:0]                              lsda_idu_ex3_wait_fence,                
output logic  [IID_WIDTH-1:0]                               lsda_ex3_iid,      //need send to lsda, for st da rb create, ensure only 1 rb create, LTL@20241101                
output logic  [2 :0]                                        lsda_ex3_inst_size,                     
output logic                                                lsda_ex3_inst_vld,                      
output logic                                                lsda_ex3_tag_inj_mask,      //need send to lda0 and another lsda, LTL@20241109         
output logic                                                lsda_lm_ex3_ecc_err,                    
output logic                                                lsda_ex3_old,                           
output logic                                                lsda_ex3_page_buf,                      
output logic                                                lsda_ex3_page_ca,                       
output logic                                                lsda_ex3_page_sec,                      
output logic                                                lsda_ex3_page_sec_ff,                   
output logic                                                lsda_ex3_page_share,                    
output logic                                                lsda_ex3_page_share_ff,                 
output logic                                                lsda_ex3_page_so,                       
output logic  [PC_LEN-1:0]                                  lsda_pfu_ex3_pc,                            
output logic                                                lsda_pfu_ex3_awk_dp_vld,                
output logic                                                lsda_pfu_ex3_awk_vld,                   
output logic                                                lsda_pfu_ex3_biu_req_hit_idx,           
output logic                                                lsda_pfu_ex3_eviwk_cnt_vld,             
output logic                                                lsda_pfu_ex3_pf_inst_vld,               
output logic  [`WK_PA_WIDTH-1:0]                            lsda_pfu_ex3_ppfu_va,                       
output logic  [`WK_PA_WIDTH-13:0]                           lsda_pfu_ex3_ppn_ff,                        
output logic                                                lsda_rb_ex3_cmit,                       
output logic                                                lsda_rb_ex3_create_dp_vld,
output logic                                                lsda_rb_ex3_create_judge_vld,               
output logic                                                lsda_rb_ex3_create_gateclk_en,          
output logic                                                lsda_rb_ex3_create_lfb,                 
output logic                                                lsda_rb_ex3_create_vld,                 
output logic                                                lsda_ex3_rb_full_gateclk_en,            
output logic                                                lsda_sq_ex3_secd,                          
output logic  [`WK_PA_WIDTH-5:0]                            lsda_sf_ex3_addr_tto4,                  
output logic  [15:0]                                        lsda_sf_ex3_bytes_vld,                  
output logic  [IID_WIDTH-1:0]                               lsda_sf_ex3_iid,                        
output logic                                                lsda_sf_ex3_no_spec_miss,               
output logic                                                lsda_sf_ex3_no_spec_miss_gate,          
output logic                                                lsda_sf_ex3_spec_chk_req, // wjh@sfp
output logic  [PC_LEN-1:0]                                  lsda_sfp_ex3_src_pc, // wjh@sfp
output logic  [SNQ_ENTRY-1:0]                               lsda_snq_ex3_borrow_snq,                
output logic                                                lsda_snq_ex3_dcache_dirty,              
output logic                                                lsda_snq_ex3_dcache_page_share,         
output logic                                                lsda_snq_ex3_dcache_share,              
output logic                                                lsda_snq_ex3_dcache_valid,              
output logic  [1:0]                                         lsda_snq_ex3_dcache_way,                
output logic                                                lsda_snq_ex3_ecc_err,                   
output logic  [SNQ_ENTRY-1:0]                               lsda_snq_ex3_entry_tag_reissue,         
output logic                                                lsda_sq_ex3_dcache_dirty,               
output logic                                                lsda_sq_ex3_dcache_page_share,          
output logic                                                lsda_sq_ex3_dcache_share,               
output logic                                                lsda_sq_ex3_dcache_valid,               
output logic  [1:0]                                         lsda_sq_ex3_dcache_way,    //1->2bit, L1D 2->4way, LTL@20250323               
output logic                                                lsda_sq_ex3_ecc_stall,                  
output logic                                                lsda_sq_ex3_expt_vld,                   
output logic                                                lsda_sq_ex3_lm_fail,                    
output logic                                                lsda_sq_ex3_no_restart,                 
output logic                                                lsda_ex3_sync_fence,                    
output logic                                                lsda_ex3_sync_inst,                     
output logic                                                lsda_vb_ex3_ecc_err,                    
output logic                                                lsda_vb_ex3_ecc_stall,                  
output logic  [`WK_PA_WIDTH-15:0]                           lsda_vb_ex3_feedback_addr_tto14,        
output logic                                                lsda_vb_ex3_tag_reissue,                
output logic                                                lsda_ex3_wait_fence_gateclk_en,         
output logic                                                lsda_lswb_ex3_cmplt_req,                  
output logic  [4 :0]                                        lsda_lswb_ex3_expt_vec,                   
output logic                                                lsda_ex3_expt_vld,                   
output logic  [`WK_PA_WIDTH-1:0]                            lsda_lswb_ex3_mt_value,                   
output logic                                                lsda_lswb_ex3_no_spec_hit,                
output logic                                                lsda_lswb_ex3_no_spec_mispred,            
output logic                                                lsda_lswb_ex3_no_spec_miss,               
output logic                                                lsda_lswb_ex3_no_spec_target,             
output logic                                                lsda_lswb_ex3_spec_fail,                  
output logic                                                lsda_lswb_ex3_vstart_vld,
output logic                                                st_da_ecc_stall,
//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
input  logic                                                dtu_lsu_addr_trig_en,
input  logic                                                dtu_lsu_data_trig_en,
input  logic [`TDT_MP_HINFO_WIDTH-1:0]                      dtu_lsu_addr_halt_info,
input  logic                                                st_dc_boundary_unmask,
input  logic                                                st_dc_data_check,
output logic                                                st_da_already_da,
output logic                                                st_da_data_check,
output logic                                                st_da_dtu_addr_halt_info_stall_vld,
output logic [`TDT_MP_HINFO_WIDTH-1:0]                      st_da_idu_halt_info,           
output logic [LSIQ_ENTRY-1:0]                               st_da_idu_halt_info_update_vld,
output logic                                                st_da_wb_expt_vld_cancel
//==========================================================
//                  Risc-V Debug zdb End 
//==========================================================       
);

            

// &Regs; @28
logic     [1 :0]                                            lsda_ex3_replace_way;
logic                                                       ecc_wakeup_dc_already_da;            
logic     [`WK_PA_WIDTH-1:0]                                st_da_addr0;                                             
logic                                                       st_da_atomic;                        
logic                                                       st_da_borrow_dcache_replace;         
logic     [1 :0]                                            st_da_borrow_dcache_sw;              
logic                                                       st_da_borrow_icc;                    
logic                                                       st_da_borrow_snq;                    
logic     [SNQ_ENTRY-1:0]                                   st_da_borrow_snq_id;                                 
logic                                                       st_da_boundary;                      
logic     [15:0]                                            st_da_bytes_vld;                     
logic     [15:0]                                            st_da_dcache_dirty_array;      //8->15 [16]deleted, L1D 2way->4way, LTL@20250321       
logic     [`WK_LS_DCACHE_DIRTY_ECC_WIDTH-1:0]               st_da_dcache_dirty_ecc;              
logic     [`WK_LS_DCACHE_TAG_NOECC_WIDTH-1:0]               st_da_dcache_tag_array;        //51->103, L1D 2way->4way, LTL@20250321       
logic     [15:0]                                            st_da_dcwp_dc_dirty_din;       //8->15 [16]deleted, L1D 2way->4way, LTL@20250321      
logic     [15:0]                                            st_da_dcwp_dc_dirty_wen;       //8->15 [16]deleted, L1D 2way->4way, LTL@20250321       
logic                                                       st_da_dcwp_dc_hit_idx;               
logic                                                       st_da_ecc_stall_already;             
logic                                                       st_da_ecc_stall_dcache_update;       
logic                                                       st_da_ecc_stall_fatal;               
logic     [3:0]                                             st_da_ecc_stall_tag_way;    //1->4, L1D 2way->4way, LTL@20250321 
logic     [1:0]                                             st_da_ecc_stall_tag_way_2bit;    //4->2bit, L1D 2way->4way, LTL@20250321          
logic     [LSIQ_ENTRY-1:0]                                  st_da_ecc_wakeup_queue;           //parameter, LTL@20241021                   
logic                                                       st_da_expt_access_fault_extra;       
logic                                                       st_da_expt_access_fault_mask;        
logic                                                       st_da_expt_access_fault_mmu;         
logic     [4 :0]                                            st_da_expt_vec;                      
logic                                                       st_da_expt_vld_except_access_err;                  
logic                                                       st_da_icc;                                                
logic     [1 :0]                                            st_da_inst_mode;                                       
logic     [1 :0]                                            st_da_inst_type;                                         
logic                                                       st_da_inst_vls;                      
logic     [LSIQ_ENTRY-1:0]                                  st_da_lsid;                          
logic                                                       st_da_mmu_req;                       
logic     [`WK_PA_WIDTH-1:0]                                st_da_mt_value;                      
logic     [1 :0]                                            st_da_no_spec;                                         
logic                                                       st_da_page_wa;                                               
logic                                                       st_da_pf_inst;                       
logic     [`WK_PA_WIDTH-1:0]                                st_da_pfu_va;                                           
logic                                                       st_da_spec_fail;                     
logic                                                       st_da_split;                         
logic                                                       st_da_split_miss_ff;                 
logic                                                       st_da_st;                            
logic                                                       st_da_tag0_hit;                      
logic                                                       st_da_tag1_hit; 
logic                                                       st_da_tag2_hit;      //double, L1D 2way->4way, LTL@20250321                
logic                                                       st_da_tag3_hit;                     
logic                                                       st_da_tag_inj_vld;                     
logic                                                       st_da_vector_nop;                          
logic    [`WK_LS_DCACHE_META_WIDTH-1:0]                     dcache_st_dirty_dout;    //double, L1D 2way->4way, LTL@20250321            
logic    [`WK_LS_DCACHE_TAG_NOECC_WIDTH-1:0]                dcache_st_tag_dout;     //double, L1D 2way->4way, LTL@20250321                               
logic                                                       ecc_info_fatal;                      
logic    [16:0]                                             ecc_info_index;                      
logic    [2 :0]                                             ecc_info_ramid;                      
logic                                                       ecc_info_update;                     
logic    [1 :0]                                             ecc_info_way;                        
logic    [`WK_PA_WIDTH-1:0]                                 ecc_pa;                                         
logic                                                       st_da_borrow_clk;                    
logic                                                       st_da_borrow_clk_en;                               
logic                                                       st_da_borrow_snq_vld;                
logic                                                       st_da_boundary_cross_2k;             
logic                                                       st_da_boundary_first;                
logic                                                       st_da_clk;                           
logic                                                       st_da_clk_en;                        
logic                                                       st_da_cmit_hit0;                     
logic                                                       st_da_cmit_hit1;                     
logic                                                       st_da_cmit_hit2;     
logic                                                       st_da_cmit_hit3;                     
logic                                                       st_da_cmit_hit4;                     
logic                                                       st_da_cmit_hit5;   
logic                                                       st_da_cmit_hit6;                     
logic                                                       st_da_cmit_hit7;                                  
logic    [`WK_PA_WIDTH-1:0]                                 st_da_cmp_pfu_biu_req_addr; 
logic    [`WK_PA_WIDTH-1:0]                                 st_da_cmp_lsda_ex3_addr;  //LTL@20241126         
logic                                                       st_da_ctc_inst;                      
logic                                                       st_da_dcache_1line_inst;             
logic                                                       st_da_dcache_dc_up_dirty;            
logic                                                       st_da_dcache_dc_up_page_share;       
logic                                                       st_da_dcache_dc_up_share;            
logic                                                       st_da_dcache_dc_up_valid;            
logic    [1 :0]                                             st_da_dcache_dc_up_way;           //1->2bit, L1D 2way->4way, LTL@20250321                  
logic    [15:0]                                             st_da_dcache_dirty_corrected;     //8->15 [16]deleted, L1D 2way->4way, LTL@20250321    
logic    [3 :0]                                             st_da_dcache_dirty_dc_up_hit_info;   
logic    [3 :0]                                             st_da_dcache_dirty_hit_info;                          
logic                                                       st_da_dcache_hit_idx;                
logic                                                       st_da_dcache_info_vld;               
logic                                                       st_da_dcache_inst;                                
logic                                                       st_da_dcache_pa_inst;                
logic                                                       st_da_dcache_sw_inst;                
logic                                                       st_da_dcache_sw_sel;                 
logic    [1 :0]                                             st_da_dcache_sw_sel_2bit;
//logic            st_da_dcache_sw_way1;//dcache_sw inst hit way is static addr[31], when L1D 2->4way, need addr[32:31], LTL@20250321  
logic    [1 :0]                                             st_da_dcache_sw_way;              
logic    [`WK_LS_DCACHE_TAG_NOECC_WIDTH-1:0]                st_da_dcache_tag_corrected;          
logic                                                       st_da_dcache_update_vld;             
logic                                                       st_da_dcache_va_inst;                
logic                                                       st_da_dcache_valid0;                 
logic                                                       st_da_dcache_valid1; 
logic                                                       st_da_dcache_valid2;              //L1D 2way->4way, LTL@20250321    
logic                                                       st_da_dcache_valid3;                                
logic    [15:0]                                             st_da_dirty_dc_update;            //8->15 [16]deleted, L1D 2way->4way, LTL@20250321    
logic    [15:0]                                             st_da_dirty_dc_update_dout;       //8->15 [16]deleted, L1D 2way->4way, LTL@20250321   
logic                                                       st_da_ecc_fatal;                     
logic                                                       st_da_ecc_hit_idx_vld;                                 
//logic            st_da_ecc_stall;                     
logic                                                       rtu_ck_flush_iid_older_than_ex2_iid;
logic                                                       rtu_ck_flush_iid_older_than_ex3_iid;
logic                                                       st_da_ecc_tag0_hit;                  
logic                                                       st_da_ecc_tag1_hit;
logic                                                       st_da_ecc_tag2_hit;                  
logic                                                       st_da_ecc_tag3_hit;                  
logic    [3:0]                                              st_da_ecc_tag_way;                               
logic                                                       st_da_expt_access_fault;             
logic                                                       st_da_expt_clk;                      
logic                                                       st_da_expt_clk_en;                   
logic                                                       st_da_expt_vld;                      
logic                                                       st_da_feedback_sel_tag;              
logic    [1:0]                                              st_da_feedback_sel_tag_way;  //way1->way,  L1D 2way->4way, LTL@20250321                        
logic                                                       st_da_fence_nop_inst;                
logic                                                       st_da_ff_clk;                        
logic                                                       st_da_ff_clk_en;
logic    [1:0]                                              st_da_hit_way;                     
logic                                                       st_da_hit_way0;                      
logic                                                       st_da_hit_way1;
logic                                                       st_da_hit_way2;  //L1D 2->4way, LTL@20250321                      
logic                                                       st_da_hit_way3;                       
logic                                                       st_da_idu_boundary_gateclk_vld;                     
logic                                                       st_da_idu_secd_vld;                             
logic                                                       st_da_inst_clk;                      
logic                                                       st_da_inst_clk_en;                   
logic                                                       st_da_l2cache_inst;                               
logic    [LSIQ_ENTRY-1:0]                                   st_da_mask_lsid;    //parameter, LTL@20241021    
logic                                                       st_da_no_spec_hit;                   
logic                                                       st_da_no_spec_mispred;               
logic                                                       st_da_no_spec_miss;                  
logic                                                       st_da_no_spec_target;                
logic                                                       st_da_page_ca_dcache_en;                          
logic                                                       st_da_rb_create_vld_unmask;                  
logic                                                       st_da_rb_full_vld;                   
logic                                                       st_da_rb_page_wa;                    
logic                                                       st_da_restart_no_cache;              
logic                                                       st_da_restart_vld;                   
logic                                                       st_da_sc_inst;                               
logic    [3 :0]                                             st_da_snq_dcache_dirty_hit_info;     
logic                                                       st_da_snq_tag_reissue;               
logic                                                       st_da_split_last;                    
logic                                                       st_da_split_miss;                                  
logic                                                       st_da_st_inst;                       
logic                                                       st_da_stamo_inst;                                     
logic                                                       st_da_tag_dirty_clk;                 
logic                                                       st_da_tag_dirty_clk_en;              
logic                                                       st_da_tag_ecc_err;                   
logic                                                       st_da_tag_ecc_stall;                 
logic                                                       st_da_tag_ecc_stall_gate;            
logic                                                       st_da_tag_ecc_vld;                   
logic                                                       st_da_tag_req_inst;                        
logic                                                       st_da_wait_fence_vld;
logic                                                       self_iid_newer_than_other_lsda; //newly add for st da create rb, LTL@20241101       
logic    [LSIQ_ENTRY-1:0]                                   st_da_wakeup_lsid;  //parameter, LTL@20241021                                
logic                                                       st_dc_tag_inj_vld;                                         
logic                                                       tag_ecc_pipe_down;                   
logic                                                       w0_ecc_fatal;                        
logic                                                       w0_ecc_free;                         
logic    [`WK_LS_DCAHCE_SINGLE_MATE_TAG_WIDTH-1:0]          w0_tag_bf_ecc;                       
logic    [`WK_LS_DCACHE_STTAG_BF_ECC_LENGTH-1:0]            w0_tag_corrected;                    
logic                                                       w0_tag_ham_error;                    
logic                                                       w0_tag_parity_error;                 
logic                                                       w1_ecc_fatal;                        
logic                                                       w1_ecc_free;                         
logic    [`WK_LS_DCAHCE_SINGLE_MATE_TAG_WIDTH-1:0]          w1_tag_bf_ecc;                       
logic    [`WK_LS_DCACHE_STTAG_BF_ECC_LENGTH-1:0]            w1_tag_corrected;                    
logic                                                       w1_tag_ham_error;                    
logic                                                       w1_tag_parity_error;                 
logic                                                       w2_ecc_fatal;           //L1D 2way->4way, LTL@20250321             
logic                                                       w2_ecc_free;                         
logic    [`WK_LS_DCAHCE_SINGLE_MATE_TAG_WIDTH-1:0]          w2_tag_bf_ecc;                       
logic    [`WK_LS_DCACHE_STTAG_BF_ECC_LENGTH-1:0]            w2_tag_corrected;                    
logic                                                       w2_tag_ham_error;                    
logic                                                       w2_tag_parity_error;                 
logic                                                       w3_ecc_fatal;                        
logic                                                       w3_ecc_free;                         
logic    [`WK_LS_DCAHCE_SINGLE_MATE_TAG_WIDTH-1:0]          w3_tag_bf_ecc;                       
logic    [`WK_LS_DCACHE_STTAG_BF_ECC_LENGTH-1:0]            w3_tag_corrected;                    
logic                                                       w3_tag_ham_error;                    
logic                                                       w3_tag_parity_error;   

//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
logic                                                       st_da_boundary_unmask;
logic                                                       st_da_expt_vld_cancel;
//==========================================================
//                  Risc-V Debug zdb End
//==========================================================

parameter S_BYTE        = 2'b00,
          HALF          = 2'b01,
          WORD          = 2'b10;
//parameter SNQ_ENTRY     = 6;  //defined in front, parameter, LTL@20241021    
//parameter PC_LEN        = 15;

//==========================================================
//                 Instance of Gated Cell  
//==========================================================
//------------------normal reg------------------------------
assign st_da_clk_en = lsdc_ex2_inst_vld
                      ||  lsdc_ex2_borrow_vld;
// &Instance("gated_clk_cell", "x_lsu_st_da_gated_clk"); @44
gated_clk_cell  x_lsu_st_da_gated_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (st_da_clk         ),
  .external_en        (1'b0              ),
  .local_en           (st_da_clk_en      ),
  .module_en          (cp0_lsu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect(.clk_in        (forever_cpuclk     ), @45
//          .external_en   (1'b0               ), @46
//          .module_en     (cp0_lsu_icg_en     ), @47
//          .local_en      (st_da_clk_en       ), @48
//          .clk_out       (st_da_clk          )); @49

assign st_da_inst_clk_en = lsdc_ex2_inst_vld;
// &Instance("gated_clk_cell", "x_lsu_st_da_inst_gated_clk"); @52
gated_clk_cell  x_lsu_st_da_inst_gated_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (st_da_inst_clk    ),
  .external_en        (1'b0              ),
  .local_en           (st_da_inst_clk_en ),
  .module_en          (cp0_lsu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect(.clk_in        (forever_cpuclk     ), @53
//          .external_en   (1'b0               ), @54
//          .module_en     (cp0_lsu_icg_en     ), @55
//          .local_en      (st_da_inst_clk_en  ), @56
//          .clk_out       (st_da_inst_clk     )); @57

assign st_da_borrow_clk_en = lsdc_ex2_borrow_vld;
// &Instance("gated_clk_cell", "x_lsu_st_da_borrow_gated_clk"); @60
gated_clk_cell  x_lsu_st_da_borrow_gated_clk (
  .clk_in              (forever_cpuclk     ),
  .clk_out             (st_da_borrow_clk   ),
  .external_en         (1'b0               ),
  .local_en            (st_da_borrow_clk_en),
  .module_en           (cp0_lsu_icg_en     ),
  .pad_yy_icg_scan_en  (pad_yy_icg_scan_en )
);

// &Connect(.clk_in        (forever_cpuclk     ), @61
//          .external_en   (1'b0               ), @62
//          .module_en     (cp0_lsu_icg_en     ), @63
//          .local_en      (st_da_borrow_clk_en), @64
//          .clk_out       (st_da_borrow_clk   )); @65

assign st_da_expt_clk_en  = lsdc_ex2_inst_vld
//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
                            &&  (lsdc_lsda_ex2_expt_vld_gate_en
                            | dtu_lsu_addr_trig_en
                            | dtu_lsu_data_trig_en);
//==========================================================
//                  Risc-V Debug zdb End
//==========================================================
// &Instance("gated_clk_cell", "x_lsu_st_da_expt_gated_clk"); @69
gated_clk_cell  x_lsu_st_da_expt_gated_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (st_da_expt_clk    ),
  .external_en        (1'b0              ),
  .local_en           (st_da_expt_clk_en ),
  .module_en          (cp0_lsu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect(.clk_in        (forever_cpuclk     ), @70
//          .external_en   (1'b0               ), @71
//          .module_en     (cp0_lsu_icg_en     ), @72
//          .local_en      (st_da_expt_clk_en  ), @73
//          .clk_out       (st_da_expt_clk     )); @74

//------------------dcache reg------------------------------
assign st_da_tag_dirty_clk_en = lsdc_lsda_ex2_get_dcache_tag_dirty || st_da_tag_ecc_stall_gate;
// &Instance("gated_clk_cell", "x_lsu_st_da_tag_dirty_gated_clk"); @78
gated_clk_cell  x_lsu_st_da_tag_dirty_gated_clk (
  .clk_in                 (forever_cpuclk        ),
  .clk_out                (st_da_tag_dirty_clk   ),
  .external_en            (1'b0                  ),
  .local_en               (st_da_tag_dirty_clk_en),
  .module_en              (cp0_lsu_icg_en        ),
  .pad_yy_icg_scan_en     (pad_yy_icg_scan_en    )
);

// &Connect(.clk_in        (forever_cpuclk     ), @79
//          .external_en   (1'b0               ), @80
//          .module_en     (cp0_lsu_icg_en     ), @81
//          .local_en      (st_da_tag_dirty_clk_en), @82
//          .clk_out       (st_da_tag_dirty_clk)); @83

//==========================================================
//                 Pipeline Register
//==========================================================
//------------------control part----------------------------
//+----------+------------+
//| inst_vld | borrow_vld |
//+----------+------------+
// &Force("output","lsda_ex3_inst_vld"); @92
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

always @(posedge ctrl_st_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    lsda_ex3_inst_vld        <=  1'b0;
    lsda_ex3_is_load         <=  1'b0;
  end
  else if(rtu_lsu_flush_fe)
    lsda_ex3_inst_vld        <=  1'b0;
  else if(st_da_ecc_stall)
  begin
    lsda_ex3_inst_vld        <=  lsda_ex3_inst_vld && ~(rtu_ck_flush && rtu_ck_flush_iid_older_than_ex3_iid);    //flush younger ex3->ex3 when ecc stall, ck_flush@LTL
    lsda_ex3_is_load         <=  lsda_ex3_is_load;
  end
  else if(lsdc_lsda_ex2_inst_vld)
  begin
    lsda_ex3_inst_vld        <=  ~(rtu_ck_flush && rtu_ck_flush_iid_older_than_ex2_iid);    //flush younger ex2->ex3 when no ecc stall, ck_flush@LTL
    lsda_ex3_is_load         <=  1'b0;
  end
  else
  begin
    lsda_ex3_inst_vld        <=  1'b0;
    lsda_ex3_is_load         <=  1'b0;
  end
end

// &Force("output","lsda_ex3_borrow_vld"); @109
always @(posedge ctrl_st_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    lsda_ex3_borrow_vld      <=  1'b0;
  else if(st_da_ecc_stall)
    lsda_ex3_borrow_vld      <=  lsda_ex3_borrow_vld;
  else if(lsdc_ex2_borrow_vld)
    lsda_ex3_borrow_vld      <=  1'b1;
  else
    lsda_ex3_borrow_vld      <=  1'b0;
end

always @(posedge ctrl_st_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    st_da_ecc_stall_already       <=  1'b0;
    st_da_ecc_stall_fatal         <=  1'b0;
    st_da_ecc_stall_dcache_update <=  1'b0;
    st_da_ecc_stall_tag_way       <=  4'b0;
  end
  else if(st_da_ecc_stall)
  begin
    st_da_ecc_stall_already       <=  1'b1;
    st_da_ecc_stall_fatal         <=  st_da_ecc_fatal;
    st_da_ecc_stall_dcache_update <=  st_da_ecc_hit_idx_vld;
    st_da_ecc_stall_tag_way       <=  st_da_ecc_tag_way;
  end
  else
  begin
    st_da_ecc_stall_already       <=  1'b0;
    st_da_ecc_stall_fatal         <=  1'b0;
    st_da_ecc_stall_dcache_update <=  1'b0;
    st_da_ecc_stall_tag_way       <=  4'b0;
  end
end

always @(posedge ctrl_st_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    st_da_tag_inj_vld  <=  1'b0;
  else if((lsdc_ex2_inst_vld  ||  lsdc_ex2_borrow_vld) && !st_da_ecc_stall)
    st_da_tag_inj_vld  <=  st_dc_tag_inj_vld;
end

//for dc inst wakeup
always @(posedge ctrl_st_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    st_da_ecc_wakeup_queue[LSIQ_ENTRY-1:0] <=  {LSIQ_ENTRY{1'b0}};
  else if(st_da_ecc_stall)
    st_da_ecc_wakeup_queue[LSIQ_ENTRY-1:0] <=  st_da_wakeup_lsid[LSIQ_ENTRY-1:0];
  else
    st_da_ecc_wakeup_queue[LSIQ_ENTRY-1:0] <=  {LSIQ_ENTRY{1'b0}};
end

always @(posedge ctrl_st_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    ecc_wakeup_dc_already_da <=  1'b0;
  else if(st_da_ecc_stall)
    ecc_wakeup_dc_already_da <=  lsdc_lsda_ex2_staddr_vld;
  else
    ecc_wakeup_dc_already_da <=  1'b0;
end
//------------------cache output part-----------------------
//+-----+-------+
//| tag | dirty |
//+-----+-------+
always @(posedge st_da_tag_dirty_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    st_da_dcache_tag_array[`WK_LS_DCACHE_TAG_NOECC_WIDTH-1:0] <=  {`WK_LS_DCACHE_TAG_NOECC_WIDTH{1'b0}};
    st_da_dcache_dirty_array[15:0]                            <=  16'b0;
    lsda_ex3_replace_way                                      <=  2'b0;
    st_da_tag0_hit                                            <=  1'b0;
    st_da_tag1_hit                                            <=  1'b0;
    st_da_tag2_hit                                            <=  1'b0;
    st_da_tag3_hit                                            <=  1'b0;
  end
  else if(st_da_tag_ecc_stall)
  begin
    st_da_dcache_tag_array[`WK_LS_DCACHE_TAG_NOECC_WIDTH-1:0] <=  st_da_dcache_tag_corrected[`WK_LS_DCACHE_TAG_NOECC_WIDTH-1:0];
    st_da_dcache_dirty_array[15:0]                            <=  st_da_dcache_dirty_corrected[15:0];
    lsda_ex3_replace_way                                      <=  lsda_ex3_replace_way;
    st_da_tag0_hit                                            <=  st_da_ecc_tag0_hit;
    st_da_tag1_hit                                            <=  st_da_ecc_tag1_hit;
    st_da_tag2_hit                                            <=  st_da_ecc_tag2_hit;
    st_da_tag3_hit                                            <=  st_da_ecc_tag3_hit;
  end
  else if(lsdc_lsda_ex2_get_dcache_tag_dirty)
  begin
    st_da_dcache_tag_array[`WK_LS_DCACHE_TAG_NOECC_WIDTH-1:0] <=  lsdc_lsda_ex2_dcache_tag_array[`WK_LS_DCACHE_TAG_NOECC_WIDTH-1:0];
    st_da_dcache_dirty_array[15:0]                            <=  lsdc_lsda_ex2_dcache_dirty_array[15:0];
    lsda_ex3_replace_way                                      <=  lsda_ex2_replace_way;
    st_da_tag0_hit                                            <=  lsdc_lsda_ex2_tag0_hit;
    st_da_tag1_hit                                            <=  lsdc_lsda_ex2_tag1_hit;
    st_da_tag2_hit                                            <=  lsdc_lsda_ex2_tag2_hit;
    st_da_tag3_hit                                            <=  lsdc_lsda_ex2_tag3_hit;
    
  end
end

always @(posedge st_da_tag_dirty_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    st_da_dcache_dirty_ecc[`WK_LS_DCACHE_DIRTY_ECC_WIDTH-1:0] <=  {`WK_LS_DCACHE_DIRTY_ECC_WIDTH{1'b0}};
  end
  else if(lsdc_lsda_ex2_get_dcache_tag_dirty)
  begin
    st_da_dcache_dirty_ecc[`WK_LS_DCACHE_DIRTY_ECC_WIDTH-1:0] <=  { dcache_st_dirty_dout[`WK_LS_DCACHE_META_WIDTH-1       :`WK_LS_DCACHE_META_WIDTH-`WK_LS_DATASRAM_ECC_WIDTH-1],
                                                                    dcache_st_dirty_dout[`WK_LS_DCACHE_TRIPLE_META_WIDTH-1:`WK_LS_DCACHE_TRIPLE_META_WIDTH-`WK_LS_DATASRAM_ECC_WIDTH-1],
                                                                    dcache_st_dirty_dout[`WK_LS_DCACHE_DOUBLE_META_WIDTH-1:`WK_LS_DCACHE_DOUBLE_META_WIDTH-`WK_LS_DATASRAM_ECC_WIDTH-1],
                                                                    dcache_st_dirty_dout[`WK_LS_DCACHE_SINGLE_META_WIDTH-1:`WK_LS_DCACHE_SINGLE_META_WIDTH-`WK_LS_DATASRAM_ECC_WIDTH-1]};
  end
end
//------------------expt part-------------------------------
//+----------+-----+-----------+
//| expt_vec | vpn | dmmu_expt |
//+----------+-----+-----------+
always @(posedge st_da_expt_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    st_da_expt_vec[4:0]               <=  5'b0;
    st_da_mt_value[`WK_PA_WIDTH-1:0]  <=  {`WK_PA_WIDTH{1'b0}};
  end
  else if(lsdc_ex2_inst_vld  &&  lsdc_lsda_ex2_expt_vld_gate_en)
  begin
    st_da_expt_vec[4:0]               <=  lsdc_lsda_ex2_expt_vec[4:0];
    st_da_mt_value[`WK_PA_WIDTH-1:0]  <=  lsdc_lsda_ex2_mt_value[`WK_PA_WIDTH-1:0];
  end
end

//------------------borrow part-----------------------------
//+-----+-----+
//| rcl | snq |
//+-----+-----+
always @(posedge st_da_borrow_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    st_da_borrow_dcache_replace         <=  1'b0;
    st_da_borrow_dcache_sw              <=  2'b0;
    st_da_borrow_snq                    <=  1'b0;
    st_da_borrow_icc                    <=  1'b0;
    st_da_borrow_snq_id[SNQ_ENTRY-1:0]  <=  {SNQ_ENTRY{1'b0}};
  end
  else if(lsdc_ex2_borrow_vld && !st_da_ecc_stall)
  begin
    st_da_borrow_dcache_replace         <=  lsdc_lsda_ex2_borrow_dcache_replace;
    st_da_borrow_dcache_sw              <=  lsdc_lsda_ex2_borrow_dcache_sw;
    st_da_borrow_snq                    <=  lsdc_lsda_ex2_borrow_snq;
    st_da_borrow_icc                    <=  lsdc_lsda_ex2_borrow_icc;
    st_da_borrow_snq_id[SNQ_ENTRY-1:0]  <=  lsdc_lsda_ex2_borrow_snq_id[SNQ_ENTRY-1:0];
  end
end

//------------------inst part----------------------------
//+----------+-----+----+-----------+-----------+-----------+
//| sync_fence | icc | ex | inst_type | inst_size | inst_mode |
//+----------+-----+----+-----------+-----------+-----------+
//+------+------------+-----------+-------+
//| secd | already_da | spec_fail | split |
//+------+------------+-----------+-------+
//+----+-----+------+-----+
//| ex | iid | lsid | old |
//+----+-----+------+-----+
//+----------+------+-------+-------+
//| boundary | preg | bkpta | bkptb |
//+----------+------+-------+-------+
//+------------+------------+
//| ldfifo_vld | ldfifo_idx |
//+------------+------------+
//+----+----+----+-----+-----+-------+
//| so | ca | wa | buf | sec | share |
//+----+----+----+-----+-----+-------+
// &Force("output","lsda_ex3_expt_vld"); @317
// &Force("output","lsda_ex3_iid"); @318
// &Force("output","lsda_sq_ex3_secd"); @319
// &Force("output","lsda_ex3_page_so"); @320
// &Force("output","lsda_ex3_page_ca"); @321
// &Force("output","lsda_ex3_sync_fence"); @324
// &Force("output","lsda_ex3_page_sec"); @325
// &Force("output","lsda_ex3_page_share"); @326
// &Force("output","lsda_pfu_ex3_pc"); @327
// &Force("output","lsda_ex3_fence_mode"); @328
// &Force("nonport","st_da_nf_cnt"); @329
always @(posedge st_da_inst_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    //lsda_ex3_is_load                  <=  1'b0;
    st_da_mmu_req                     <=  1'b0;
    st_da_expt_vld_except_access_err  <=  1'b0;
    st_da_expt_access_fault_mask      <=  1'b0;
    st_da_expt_access_fault_extra     <=  1'b0;
    st_da_expt_access_fault_mmu       <=  1'b0;
    st_da_split                       <=  1'b0;
    lsda_ex3_sync_fence               <=  1'b0;
    st_da_icc                         <=  1'b0;
    st_da_inst_type[1:0]              <=  2'b0;
    st_da_inst_mode[1:0]              <=  2'b0;
    lsda_ex3_inst_size[2:0]           <=  3'b0;
    lsda_ex3_fence_mode[3:0]          <=  4'b0;
    st_da_st                          <=  1'b0;
    lsda_sq_ex3_secd                  <=  1'b0;
    st_da_atomic                      <=  1'b0;
    lsda_ex3_iid[IID_WIDTH-1:0]       <=  {IID_WIDTH{1'b0}};
    st_da_lsid[LSIQ_ENTRY-1:0]        <=  {LSIQ_ENTRY{1'b0}};
    lsda_ex3_old                      <=  1'b0;
    st_da_boundary                    <=  1'b0;
    st_da_spec_fail                   <=  1'b0;
    lsda_sfp_ex3_src_pc               <=  {PC_LEN{1'b0}}; // wjh@sfp
    lsda_ex3_page_so                  <=  1'b0;
    lsda_ex3_page_ca                  <=  1'b0;
    st_da_page_wa                     <=  1'b0;
    lsda_ex3_page_buf                 <=  1'b0;
    lsda_ex3_page_sec                 <=  1'b0;
    lsda_ex3_page_share               <=  1'b0;
    st_da_already_da                  <=  1'b0;
    st_da_no_spec[1:0]                <=  2'b0;
    st_da_bytes_vld[15:0]             <=  16'b0;
    lsda_pfu_ex3_pc[PC_LEN-1:0]       <=  {PC_LEN{1'b0}};
    st_da_pfu_va[`WK_PA_WIDTH-1:0]    <=  {`WK_PA_WIDTH{1'b0}};
    st_da_pf_inst                     <=  1'b0;
    st_da_vector_nop                  <=  1'b0;
    st_da_inst_vls                    <=  1'b0;
    st_da_boundary_unmask             <=  1'b0; // Risc-V Debug zdb
    st_da_data_check                  <=  1'b0; // Risc-V Debug zdb
    lsda_lswb_ex3_element_cnt[8:0]    <=  9'b0;
  end
  else if(lsdc_ex2_inst_vld && !st_da_ecc_stall)
  begin
    //lsda_ex3_is_load                  <=  lsdc_ex2_is_load;
    st_da_mmu_req                     <=  lsdc_lsda_ex2_mmu_req;
    st_da_expt_vld_except_access_err  <=  lsdc_lsda_ex2_expt_vld_except_access_err;
    st_da_expt_access_fault_mask      <=  lsdc_lsda_ex2_expt_access_fault_mask;
    st_da_expt_access_fault_extra     <=  lsdc_lsda_ex2_expt_access_fault_extra;
    st_da_expt_access_fault_mmu       <=  mmu_lsu_access_fault;
    st_da_split                       <=  lsdc_lsda_ex2_split;
    lsda_ex3_sync_fence               <=  lsdc_lsda_ex2_sync_fence;
    st_da_icc                         <=  lsdc_ex2_icc;
    st_da_inst_type[1:0]              <=  lsdc_ex2_inst_type[1:0];
    st_da_inst_mode[1:0]              <=  lsdc_ex2_inst_mode[1:0];
    lsda_ex3_inst_size[2:0]           <=  lsdc_ex2_inst_size[2:0];
    lsda_ex3_fence_mode[3:0]          <=  lsdc_ex2_fence_mode[3:0];
    st_da_st                          <=  lsdc_lsda_ex2_st;
    lsda_sq_ex3_secd                  <=  lsdc_ex2_secd;
    st_da_atomic                      <=  lsdc_ex2_atomic;
    lsda_ex3_iid[IID_WIDTH-1:0]       <=  lsdc_ex2_iid;  //here was a fatal error, {IID_WIDTH{1'b0}}, LTL@20241127 
    st_da_lsid[LSIQ_ENTRY-1:0]        <=  lsdc_lsda_ex2_lsid[LSIQ_ENTRY-1:0];
    lsda_ex3_old                      <=  lsdc_ex2_old;
    st_da_boundary                    <=  lsdc_ex2_boundary;
    st_da_spec_fail                   <=  lsdc_lsda_ex2_spec_fail;
    lsda_sfp_ex3_src_pc               <=  lq_lsu_ex2_spec_fail_pc; // wjh@sfp
    lsda_ex3_page_so                  <=  lsdc_ex2_page_so;
    lsda_ex3_page_ca                  <=  lsdc_ex2_page_ca;
    st_da_page_wa                     <=  lsdc_ex2_page_wa;
    lsda_ex3_page_buf                 <=  lsdc_ex2_page_buf;
    lsda_ex3_page_sec                 <=  lsdc_ex2_page_sec;
    lsda_ex3_page_share               <=  lsdc_ex2_page_share;
    st_da_already_da                  <=  lsdc_lsda_ex2_already_da;
    st_da_no_spec[1:0]                <=  lsdc_lsda_ex2_no_spec[1:0];
    st_da_bytes_vld[15:0]             <=  lsdc_ex2_bytes_vld[15:0];
    lsda_pfu_ex3_pc[PC_LEN-1:0]       <=  lsdc_lsda_ex2_pc[PC_LEN-1:0];
    st_da_pfu_va[`WK_PA_WIDTH-1:0]    <=  lsdc_lsda_ex2_pfu_va[`WK_PA_WIDTH-1:0];           
    st_da_pf_inst                     <=  lsdc_lsda_ex2_pf_inst;
    st_da_vector_nop                  <=  lsdc_ex2_vector_nop;
    st_da_inst_vls                    <=  lsdc_ex2_inst_vls;
    st_da_boundary_unmask             <=  st_dc_boundary_unmask; // Risc-V Debug zdb
    st_da_data_check                  <=  st_dc_data_check; // Risc-V Debug zdb
    lsda_lswb_ex3_element_cnt[8:0]    <=  lsdc_lsda_ex2_element_cnt[8:0];
  end
end

//------------------inst/borrow share part------------------
//+-------+
//| addr0 |
//+-------+
//+--------------+----------------+----------------+
//| dcwp_hit_idx | dcwp_dirty_din | dcwp_dirty_wen |
//+--------------+----------------+----------------+
always @(posedge st_da_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    st_da_addr0[`WK_PA_WIDTH-1:0]   <=  {`WK_PA_WIDTH{1'b0}};
    st_da_dcwp_dc_hit_idx           <=  1'b0;
    st_da_dcwp_dc_dirty_din[15:0]   <=  16'b0;
    st_da_dcwp_dc_dirty_wen[15:0]   <=  16'b0;
  end
  else if((lsdc_ex2_inst_vld  ||  lsdc_ex2_borrow_vld) && !st_da_ecc_stall)
  begin
    st_da_addr0[`WK_PA_WIDTH-1:0]   <=  lsdc_ex2_addr0[`WK_PA_WIDTH-1:0];
    st_da_dcwp_dc_hit_idx           <=  lsdc_lsda_ex2_dcwp_hit_idx;
    st_da_dcwp_dc_dirty_din[15:0]   <=  dcache_dirty_din[15:0];
    st_da_dcwp_dc_dirty_wen[15:0]   <=  dcache_dirty_wen[15:0];
  end
end

//==========================================================
//        Generate expt info
//==========================================================
assign st_da_expt_access_fault  = (st_da_mmu_req
                                          &&  st_da_expt_access_fault_mmu
                                      ||  st_da_expt_access_fault_extra)
                                  &&  !st_da_expt_access_fault_mask;

assign st_da_expt_vld = (st_da_expt_vld_except_access_err
                         ||  st_da_expt_access_fault
                         ||  st_da_ecc_stall_fatal
                             && !st_da_sc_inst)
                        && !st_da_vector_nop;

assign lsda_ex3_expt_vld = (st_da_expt_vld_except_access_err
                               ||  st_da_expt_access_fault)
                           && !st_da_vector_nop;

// &CombBeg; @467
always @( st_da_expt_access_fault
       or st_da_mt_value[`WK_PA_WIDTH-1:0]
       or st_da_st
       or st_da_expt_vec[4:0]
       or dtu_lsu_addr_halt_info[`TDT_MP_HINFO_WIDTH-1:0]
       or st_da_boundary_unmask
       or lsda_ex3_expt_vld)
begin
lsda_lswb_ex3_expt_vec[4:0]  = st_da_expt_vec[4:0];

lsda_lswb_ex3_mt_value[`WK_PA_WIDTH-1:0]  = st_da_mt_value[`WK_PA_WIDTH-1:0];
if(st_da_expt_access_fault &&  !st_da_st)
begin
  lsda_lswb_ex3_expt_vec[4:0]  = 5'd5;
  lsda_lswb_ex3_mt_value[`WK_PA_WIDTH-1:0]  = {`WK_PA_WIDTH{1'b0}};
end
else if(st_da_expt_access_fault &&  st_da_st)
begin
  lsda_lswb_ex3_expt_vec[4:0]  = 5'd7;
  lsda_lswb_ex3_mt_value[`WK_PA_WIDTH-1:0]  = {`WK_PA_WIDTH{1'b0}};
end
//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
else if(dtu_lsu_addr_halt_info[0] & st_da_boundary_unmask | dtu_lsu_addr_halt_info[1] & st_da_boundary_unmask & ~lsda_ex3_expt_vld)
begin
  lsda_lswb_ex3_expt_vec[4:0]  = 5'd3;
  lsda_lswb_ex3_mt_value[`WK_PA_WIDTH-1:0]  = {`WK_PA_WIDTH{1'b0}};
end
//==========================================================
//                  Risc-V Debug zdb End 
//==========================================================
// &CombEnd; @481
end

assign lsda_lswb_ex3_vstart_vld = lsda_ex3_inst_vld
                             && st_da_inst_vls
                             && (st_da_wb_expt_vld_cancel // Risc-V Debug zdb
                                 || (cp0_lsu_vstart[`VSTART_WIDTH-1:0] != `VSTART_WIDTH'b0)
                                    && !st_da_split
                                    && !st_da_wb_expt_vld_cancel); // Risc-V Debug zdb
//==========================================================
//        Generate inst type
//==========================================================
//st/str/push/srs is treated as st inst
// &Force("output","lsda_ex3_sync_inst"); @497
assign lsda_ex3_sync_inst    = lsda_ex3_sync_fence
                            &&  !st_da_atomic
                            &&  (st_da_inst_type[1:0] ==  2'b00);
// &Force("output","lsda_ex3_fence_inst"); @501
assign lsda_ex3_fence_inst   = lsda_ex3_sync_fence
                            &&  !st_da_atomic
                            &&  (st_da_inst_type[1:0] ==  2'b01);
assign st_da_ctc_inst     = st_da_icc
                            &&  !st_da_atomic
                            &&  (st_da_inst_type[1:0] !=  2'b10);
assign st_da_dcache_inst  = st_da_icc
                            &&  !st_da_atomic
                            &&  (st_da_inst_type[1:0] ==  2'b10);

assign st_da_l2cache_inst = st_da_icc
                            &&  !st_da_atomic
                            &&  (st_da_inst_type[1:0] ==  2'b11);
assign st_da_st_inst      = !st_da_icc
                            &&  !st_da_atomic
                            &&  !lsda_ex3_sync_fence
                            &&  (st_da_inst_type[1:0] ==  2'b00);
assign st_da_dcache_sw_inst     = st_da_dcache_inst
                                  &&  (st_da_inst_mode[1:0] ==  2'b10);
assign st_da_dcache_pa_inst     = st_da_dcache_inst
                                  &&  (st_da_inst_mode[1:0] ==  2'b11);
assign st_da_dcache_va_inst     = st_da_dcache_inst
                                  &&  (st_da_inst_mode[1:0] ==  2'b01);
assign st_da_dcache_1line_inst  = st_da_dcache_sw_inst
                                  ||  st_da_dcache_pa_inst
                                  ||  st_da_dcache_va_inst;

assign st_da_sc_inst    = st_da_atomic
                          &&  (st_da_inst_type[1:0] == 2'b01);
assign st_da_stamo_inst = st_da_atomic
                          &&  (st_da_inst_type[1:0] == 2'b00);

//lignt fence inst, treated as nop
assign st_da_fence_nop_inst = lsda_ex3_fence_inst
                              && (lsda_ex3_fence_mode[3:0] == 4'b0011);
//==========================================================
//              Compare tag and select data
//==========================================================
//------------------compare tag-----------------------------
assign st_da_dcache_sw_sel  = lsda_ex3_inst_vld
                                  &&  st_da_dcache_sw_inst
                              ||  lsda_ex3_borrow_vld
                                  &&  st_da_borrow_dcache_sw[0];  //snq vb need dcache_hit_way, icc donot need
assign st_da_dcache_sw_sel_2bit =  {2{lsda_ex3_borrow_vld}}
                                  &  st_da_borrow_dcache_sw;
//if dcache sw inst, then hit_way is static as addr[31]
//assign st_da_dcache_sw_way1 = st_da_addr0[31];  //dcache_sw inst hit way is static addr[31], when L1D 2->4way, need addr[32:31], LTL@20250321
assign st_da_dcache_sw_way[1:0] = st_da_addr0[32:31];

assign st_da_dcache_info_vld= lsda_ex3_inst_vld  &&  lsda_ex3_page_ca
                              ||  lsda_ex3_borrow_vld;

assign st_da_dcache_valid0  = st_da_dcache_dirty_array[0]
                              &&  cp0_lsu_dcache_en
                              &&  st_da_dcache_info_vld;
assign st_da_dcache_valid1  = st_da_dcache_dirty_array[4]
                              &&  cp0_lsu_dcache_en
                              &&  st_da_dcache_info_vld;
assign st_da_dcache_valid2  = st_da_dcache_dirty_array[8]
                              &&  cp0_lsu_dcache_en
                              &&  st_da_dcache_info_vld;
assign st_da_dcache_valid3  = st_da_dcache_dirty_array[12]
                              &&  cp0_lsu_dcache_en
                              &&  st_da_dcache_info_vld;
assign st_da_hit_way0       = st_da_dcache_valid0
                              &&  (!st_da_dcache_sw_sel
                                      &&  st_da_tag0_hit
                                  ||  st_da_dcache_sw_sel
                                      &&  (st_da_dcache_sw_way==2'b00));   //!st_da_dcache_sw_way1,  LTL@20250321
assign st_da_hit_way1       = st_da_dcache_valid1
                              &&  (!st_da_dcache_sw_sel
                                      &&  st_da_tag1_hit
                                  ||  st_da_dcache_sw_sel
                                      &&  (st_da_dcache_sw_way==2'b01));      //!st_da_dcache_sw_way1,  LTL@20250321
assign st_da_hit_way2       = st_da_dcache_valid2
                              &&  (!st_da_dcache_sw_sel
                                      &&  st_da_tag2_hit
                                  ||  st_da_dcache_sw_sel
                                      &&  (st_da_dcache_sw_way==2'b10));
assign st_da_hit_way3       = st_da_dcache_valid3
                              &&  (!st_da_dcache_sw_sel
                                      &&  st_da_tag3_hit
                                  ||  st_da_dcache_sw_sel
                                      &&  (st_da_dcache_sw_way==2'b11));
always@(st_da_hit_way0
        or st_da_hit_way1
        or st_da_hit_way2
        or st_da_hit_way3)
begin
  case({st_da_hit_way3,st_da_hit_way2,st_da_hit_way1,st_da_hit_way0})
  4'b1000: st_da_hit_way = 2'b11;
  4'b0100: st_da_hit_way = 2'b10;
  4'b0010: st_da_hit_way = 2'b01;
  4'b0001: st_da_hit_way = 2'b00;
  default: st_da_hit_way = 2'b00;
  endcase
end

// &Force("output","lsda_ex3_dcache_hit"); @570
assign lsda_ex3_dcache_hit     = st_da_hit_way0  ||  st_da_hit_way1 ||  st_da_hit_way2 ||  st_da_hit_way3;


// &Force("output","lsda_vb_ex3_dcache_miss"); @572
assign lsda_vb_ex3_dcache_miss    = !lsda_ex3_dcache_hit;

//select cache hit info
assign st_da_dcache_dirty_hit_info[3:0] = 
                {4{st_da_hit_way0}} & st_da_dcache_dirty_array[3:0]
                | {4{st_da_hit_way1}} & st_da_dcache_dirty_array[7:4]
                | {4{st_da_hit_way2}} & st_da_dcache_dirty_array[11:8]
                | {4{st_da_hit_way3}} & st_da_dcache_dirty_array[15:12];

//------output dcache info for inst/snq/vb rcl(inst/icc)-------
assign lsda_vb_ex3_dcache_dirty         = st_da_dcache_dirty_hit_info[2];
assign lsda_vb_ex3_dcache_page_share    = st_da_dcache_dirty_hit_info[3];
// &Force("output","lsda_vb_ex3_dcache_way"); @583
assign lsda_vb_ex3_dcache_way           = st_da_dcache_sw_sel
                                    ? st_da_dcache_sw_way            //1bit->2bit, L1D 2->4way, LTL@20250321
                                    : st_da_hit_way;             //st_da_hit_way1

//---------output dcache info for vb rcl line replace-------
// &Force("output","lsda_vb_ex3_dcache_replace_way"); @589
//if dcache hit, then cover this dcache line in atomic instruction
assign lsda_vb_ex3_dcache_replace_way   = lsda_ex3_dcache_hit
                                    ? st_da_hit_way                   //way1->way,  L1D 2->4way, LTL@20250321
                                    : lsda_ex2_replace_way;
                                    //: {2{st_da_dcache_dirty_array[8]}};   //??? ask lishuo?? 8->16,  L1D 2->4way, LTL@20250321
//assign lsda_vb_ex3_dcache_replace_dirty = lsda_vb_ex3_dcache_replace_way   //L1D 2->4 way, LTL@20250321
//                                    ? st_da_dcache_dirty_array[6]
//                                    : st_da_dcache_dirty_array[2];
//assign st_da_dcache_replace_share = lsda_vb_ex3_dcache_replace_way
//                                    ? st_da_dcache_dirty_array[5]
//                                    : st_da_dcache_dirty_array[1];
//assign lsda_vb_ex3_dcache_replace_valid = lsda_vb_ex3_dcache_replace_way  //L1D 2->4 way, LTL@20250321
//                                    ? st_da_dcache_dirty_array[4]
//                                    : st_da_dcache_dirty_array[0];
//assign lsda_vb_ex3_dcache_replace_page_share = lsda_vb_ex3_dcache_replace_way  //L1D 2->4 way, LTL@20250321
//                                         ? st_da_dcache_dirty_array[7]
//                                         : st_da_dcache_dirty_array[3];
always @(lsda_vb_ex3_dcache_replace_way
        or st_da_dcache_dirty_array)
begin
  case(lsda_vb_ex3_dcache_replace_way[1:0])
  2'b11: begin
    lsda_vb_ex3_dcache_replace_dirty = st_da_dcache_dirty_array[14];
    lsda_vb_ex3_dcache_replace_valid = st_da_dcache_dirty_array[12];
    lsda_vb_ex3_dcache_replace_page_share = st_da_dcache_dirty_array[15];
  end
  2'b10: begin
    lsda_vb_ex3_dcache_replace_dirty = st_da_dcache_dirty_array[10];
    lsda_vb_ex3_dcache_replace_valid = st_da_dcache_dirty_array[8];
    lsda_vb_ex3_dcache_replace_page_share = st_da_dcache_dirty_array[11];
  end
  2'b01: begin
    lsda_vb_ex3_dcache_replace_dirty = st_da_dcache_dirty_array[6];
    lsda_vb_ex3_dcache_replace_valid = st_da_dcache_dirty_array[4];
    lsda_vb_ex3_dcache_replace_page_share = st_da_dcache_dirty_array[7];
  end
  2'b00: begin
    lsda_vb_ex3_dcache_replace_dirty = st_da_dcache_dirty_array[2];
    lsda_vb_ex3_dcache_replace_valid = st_da_dcache_dirty_array[0];
    lsda_vb_ex3_dcache_replace_page_share = st_da_dcache_dirty_array[3];
  end
  default: begin
    lsda_vb_ex3_dcache_replace_dirty = 1'b0;
    lsda_vb_ex3_dcache_replace_valid = 1'b0;
    lsda_vb_ex3_dcache_replace_page_share = 1'b0;
  end
  endcase
end

//------------------feedback addr to vb---------------------
//if dcache_sw inst, it must give addr to vb to generate a write request
assign st_da_feedback_sel_tag_way  =
                lsda_vb_ex3_dcache_replace_way  &  {2{st_da_borrow_dcache_replace}}     //1->2bit, &&->&, LTL@20250321
                |  st_da_dcache_sw_way  &  {2{st_da_borrow_dcache_sw[0]}};    //1->2bit, &&->&, LTL@20250321

assign st_da_feedback_sel_tag       = st_da_borrow_dcache_replace      //dcache_replace & borrow_dcache_sw canot be 1 at same time, LTL@20250409
                                      ||  st_da_borrow_dcache_sw[0];
// &CombBeg; @614
always @( st_da_addr0[`WK_PA_WIDTH-1:14]
       or st_da_feedback_sel_tag
       or st_da_dcache_tag_array[`WK_LS_DCACHE_TAG_NOECC_WIDTH-1:0]
       or st_da_feedback_sel_tag_way)
begin
lsda_vb_ex3_feedback_addr_tto14[`WK_PA_WIDTH-15:0]  = st_da_addr0[`WK_PA_WIDTH-1:14];
case({st_da_feedback_sel_tag,st_da_feedback_sel_tag_way})
  3'b100:lsda_vb_ex3_feedback_addr_tto14[`WK_PA_WIDTH-15:0]   = st_da_dcache_tag_array[`WK_LS_DCACHE_SINGLE_TAG_WIDTH-1 :0];
  3'b101:lsda_vb_ex3_feedback_addr_tto14[`WK_PA_WIDTH-15:0]   = st_da_dcache_tag_array[`WK_LS_DCACHE_DOUBLE_TAG_WIDTH-1 :`WK_LS_DCACHE_SINGLE_TAG_WIDTH];
  3'b110:lsda_vb_ex3_feedback_addr_tto14[`WK_PA_WIDTH-15:0]   = st_da_dcache_tag_array[`WK_LS_DCACHE_TRIPLE_TAG_WIDTH-1 :`WK_LS_DCACHE_DOUBLE_TAG_WIDTH];
  3'b111:lsda_vb_ex3_feedback_addr_tto14[`WK_PA_WIDTH-15:0]   = st_da_dcache_tag_array[`WK_LS_DCACHE_TAG_NOECC_WIDTH-1  :`WK_LS_DCACHE_TRIPLE_TAG_WIDTH];
  default:lsda_vb_ex3_feedback_addr_tto14[`WK_PA_WIDTH-15:0]  = st_da_addr0[`WK_PA_WIDTH-1:14];
endcase
// &CombEnd; @621
end

//---------------feedback dirty info to snq-----------------
assign st_da_snq_dcache_dirty_hit_info[3:0] =                             //L1D 2->4way, LTL@20250321
                {4{st_da_tag0_hit && st_da_dcache_dirty_array[0]}} & st_da_dcache_dirty_array[3:0]    //take tag vld into consider, LTL@20260716
                | {4{st_da_tag1_hit && st_da_dcache_dirty_array[4]}} & st_da_dcache_dirty_array[7:4]
                | {4{st_da_tag2_hit && st_da_dcache_dirty_array[8]}} & st_da_dcache_dirty_array[11:8]
                | {4{st_da_tag3_hit && st_da_dcache_dirty_array[12]}} & st_da_dcache_dirty_array[15:12];

assign lsda_snq_ex3_dcache_valid = st_da_snq_dcache_dirty_hit_info[0]
                                &&  cp0_lsu_dcache_en;
assign lsda_snq_ex3_dcache_share = st_da_snq_dcache_dirty_hit_info[1];
assign lsda_snq_ex3_dcache_dirty = st_da_snq_dcache_dirty_hit_info[2];
assign lsda_snq_ex3_dcache_page_share = st_da_snq_dcache_dirty_hit_info[3];
//assign lsda_snq_ex3_dcache_way   = st_da_dcache_dirty_array[4]    //valid && tag1_hit, L1D 2->4way, LTL@20250321
//                                &&  st_da_tag1_hit;
assign lsda_snq_ex3_dcache_way   = {2{st_da_dcache_dirty_array[12] && st_da_tag3_hit}} &  2'b11   //valid && tag1_hit, L1D 2->4way, LTL@20250321
                                  | {2{st_da_dcache_dirty_array[8] && st_da_tag2_hit}} &  2'b10   //consider two tags are same in one set, 4 way, LTL@20260716 
                                  | {2{st_da_dcache_dirty_array[4] && st_da_tag1_hit}} &  2'b01
                                  | {2{st_da_dcache_dirty_array[0] && st_da_tag0_hit}} &  2'b00;

//==========================================================
//          Dirty array update da stage for sq
//==========================================================
//when inst is in dc stage, then only dcache dirty array may be changed
//when inst is in da stage, then tag & dirty array may be changed
//-------update dirty info if index hit in dc stage---------
assign st_da_dirty_dc_update[15:0]       = {16{st_da_dcwp_dc_hit_idx}}
                                          & st_da_dcwp_dc_dirty_wen[15:0];//8->16, L1D 2way->4way, LTL@20250321 

assign st_da_dirty_dc_update_dout[15:0]  =                                      //8->16, L1D 2way->4way, LTL@20250321
                st_da_dirty_dc_update[15:0] & st_da_dcwp_dc_dirty_din[15:0]
                | (~st_da_dirty_dc_update[15:0])  & st_da_dcache_dirty_array[15:0];

//select cache hit info
assign st_da_dcache_dirty_dc_up_hit_info[3:0] =
                {4{st_da_hit_way0}} & st_da_dirty_dc_update_dout[3:0]
                | {4{st_da_hit_way1}} & st_da_dirty_dc_update_dout[7:4]
                | {4{st_da_hit_way2}} & st_da_dirty_dc_update_dout[11:8]
                | {4{st_da_hit_way3}} & st_da_dirty_dc_update_dout[15:12];

assign st_da_dcache_dc_up_page_share    = st_da_dcache_dirty_dc_up_hit_info[3];
assign st_da_dcache_dc_up_dirty         = st_da_dcache_dirty_dc_up_hit_info[2];
assign st_da_dcache_dc_up_share         = st_da_dcache_dirty_dc_up_hit_info[1];
assign st_da_dcache_dc_up_valid         = st_da_dcache_dirty_dc_up_hit_info[0];
assign st_da_dcache_dc_up_way           = lsda_vb_ex3_dcache_way;

//-------------update dcache info in da stage---------------
// &Instance("xx_lsu_dcache_info_update","x_lsu_st_da_dcache_info_update"); @663
xx_lsu_dcache_info_update  x_lsu_st_da_dcache_info_update (
  .compare_dcwp_addr             (st_da_addr0[`WK_PA_WIDTH-1:0]   ),
  .compare_dcwp_hit_idx          (st_da_dcache_hit_idx            ),
  .compare_dcwp_sw_inst          (st_da_dcache_sw_inst            ),
  .compare_dcwp_update_vld       (st_da_dcache_update_vld         ),
  .dcache_dirty_din              (dcache_dirty_din                ),
  .dcache_dirty_gwen             (dcache_dirty_gwen               ),
  .dcache_dirty_wen              (dcache_dirty_wen                ),
  .dcache_idx                    (dcache_idx                      ),
  .dcache_tag_din                (dcache_tag_din                  ),
  .dcache_tag_gwen               (dcache_tag_gwen                 ),
  .dcache_tag_wen                (dcache_tag_wen                  ),
  .origin_dcache_dirty           (st_da_dcache_dc_up_dirty        ),
  .origin_dcache_page_share      (st_da_dcache_dc_up_page_share   ),
  .origin_dcache_share           (st_da_dcache_dc_up_share        ),
  .origin_dcache_valid           (st_da_dcache_dc_up_valid        ),
  .origin_dcache_way             (st_da_dcache_dc_up_way          ),
  .update_dcache_dirty           (lsda_sq_ex3_dcache_dirty        ),
  .update_dcache_page_share      (lsda_sq_ex3_dcache_page_share   ),
  .update_dcache_share           (lsda_sq_ex3_dcache_share        ),
  .update_dcache_valid           (lsda_sq_ex3_dcache_valid        ),
  .update_dcache_way             (lsda_sq_ex3_dcache_way          )
);


xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH))
x_lsu_lsda_compare_lsda_iid0 (                        //1->2 for 2lsdc, LTL
  .x_iid0                        (lsda_lsda_ex3_iid[IID_WIDTH-1:0]     ),
  .x_iid0_older                  (self_iid_newer_than_other_lsda       ),
  .x_iid1                        (lsda_ex3_iid[IID_WIDTH-1:0]          )
);
// &Connect( .compare_dcwp_addr          (st_da_addr0[WK_PA_WIDTH-1:0]   ), @664
//           .compare_dcwp_sw_inst       (st_da_dcache_sw_inst), @665
//           .origin_dcache_valid        (st_da_dcache_dc_up_valid ), @666
//           .origin_dcache_share        (st_da_dcache_dc_up_share ), @667
//           .origin_dcache_dirty        (st_da_dcache_dc_up_dirty ), @668
//           .origin_dcache_page_share   (st_da_dcache_dc_up_page_share ), @669
//           .origin_dcache_way          (st_da_dcache_dc_up_way   ), @670
//           .compare_dcwp_update_vld    (st_da_dcache_update_vld  ), @671
//           .compare_dcwp_hit_idx       (st_da_dcache_hit_idx     ), @672
//           .update_dcache_valid        (lsda_sq_ex3_dcache_valid    ), @673
//           .update_dcache_share        (lsda_sq_ex3_dcache_share    ), @674
//           .update_dcache_dirty        (lsda_sq_ex3_dcache_dirty    ), @675
//           .update_dcache_page_share   (lsda_sq_ex3_dcache_page_share), @676
//           .update_dcache_way          (lsda_sq_ex3_dcache_way      )); @677

// &Force("nonport","st_da_dcache_update_vld"); @679
// &Force("nonport","st_da_dcache_hit_idx"); @680
// &Force("output","lsda_sq_ex3_dcache_valid"); @681
// &Force("output","lsda_sq_ex3_dcache_share"); @682
// &Force("output","lsda_sq_ex3_dcache_dirty"); @683
// &Force("output","lsda_sq_ex3_dcache_page_share"); @684

//==========================================================
//        Generage commit signal
//==========================================================
assign st_da_cmit_hit0  = {rtu_yy_xx_commit0,rtu_yy_xx_commit0_iid[IID_WIDTH-1:0]}
                          ==  {1'b1,lsda_ex3_iid[IID_WIDTH-1:0]};
assign st_da_cmit_hit1  = {rtu_yy_xx_commit1,rtu_yy_xx_commit1_iid[IID_WIDTH-1:0]}
                          ==  {1'b1,lsda_ex3_iid[IID_WIDTH-1:0]};
assign st_da_cmit_hit2  = {rtu_yy_xx_commit2,rtu_yy_xx_commit2_iid[IID_WIDTH-1:0]}
                          ==  {1'b1,lsda_ex3_iid[IID_WIDTH-1:0]};
assign st_da_cmit_hit3  = {rtu_yy_xx_commit3,rtu_yy_xx_commit3_iid[IID_WIDTH-1:0]}
                          ==  {1'b1,lsda_ex3_iid[IID_WIDTH-1:0]};
assign st_da_cmit_hit4  = {rtu_yy_xx_commit4,rtu_yy_xx_commit4_iid[IID_WIDTH-1:0]}
                          ==  {1'b1,lsda_ex3_iid[IID_WIDTH-1:0]};
assign st_da_cmit_hit5  = {rtu_yy_xx_commit5,rtu_yy_xx_commit5_iid[IID_WIDTH-1:0]}
                          ==  {1'b1,lsda_ex3_iid[IID_WIDTH-1:0]};
assign st_da_cmit_hit6  = {rtu_yy_xx_commit6,rtu_yy_xx_commit6_iid[IID_WIDTH-1:0]}
                          ==  {1'b1,lsda_ex3_iid[IID_WIDTH-1:0]};
assign st_da_cmit_hit7  = {rtu_yy_xx_commit7,rtu_yy_xx_commit7_iid[IID_WIDTH-1:0]}
                          ==  {1'b1,lsda_ex3_iid[IID_WIDTH-1:0]};

assign lsda_rb_ex3_cmit    = st_da_cmit_hit0         //3->8, LTL@20241021
                          ||  st_da_cmit_hit1
                          ||  st_da_cmit_hit2
                          ||  st_da_cmit_hit3
                          ||  st_da_cmit_hit4
                          ||  st_da_cmit_hit5
                          ||  st_da_cmit_hit6
                          ||  st_da_cmit_hit7;
//==========================================================
//        Request read buffer & Compare index & discard
//==========================================================
//----------in mem copy mode, then it won't request rb------
assign st_da_rb_page_wa = st_da_page_wa &&  !amr_wa_cancel;
//------------------origin create read buffer---------------
//-----------create 1-------------------
//st/push/srs: cache miss, cacheable

assign st_da_page_ca_dcache_en      = lsda_ex3_page_ca &&  cp0_lsu_dcache_en;

assign lsda_rb_ex3_create_judge_vld   = lsda_ex3_inst_vld
                                      &&  !st_da_vector_nop
                                      &&  !st_da_expt_vld_cancel // Risc-V Debug zdb
                                      &&  !st_da_ecc_stall_already
                                      &&  (st_da_st_inst  
                                              &&  st_da_page_ca_dcache_en
                                              &&  st_da_rb_page_wa
                                          ||  lsda_ex3_sync_fence
                                              &&  !st_da_fence_nop_inst
                                              &&  !st_da_atomic);

assign st_da_rb_create_vld_unmask   = lsda_ex3_inst_vld
                                      &&  !st_da_vector_nop
                                      &&  !st_da_expt_vld_cancel // Risc-V Debug zdb
                                      &&  !st_da_ecc_stall_already
                                      &&  (st_da_st_inst  
                                              &&  st_da_page_ca_dcache_en
                                              &&  st_da_rb_page_wa
                                              &&  lsda_vb_ex3_dcache_miss
                                          ||  lsda_ex3_sync_fence
                                              &&  !st_da_fence_nop_inst
                                              &&  !st_da_atomic
                                              &&  !lsu_has_fence);

//------------------index hit/discard grnt signal-----------
//addr is used to compare index, so addr0 is enough
assign lsda_ex3_addr[`WK_PA_WIDTH-1:0]  = st_da_addr0[`WK_PA_WIDTH-1:0];

//------------------create read buffer info-----------------
// &Force("output","lsda_rb_ex3_create_vld"); @729
assign lsda_rb_ex3_create_vld          = st_da_rb_create_vld_unmask
                                      &&  !rtu_lsu_flush_fe
                                      &&  !(rtu_ck_flush && rtu_ck_flush_iid_older_than_ex3_iid)  //flush younger ex3_rb_create, ck_flush@LTL
                                      &&  !st_da_tag_ecc_stall
                                      &&  (!lda0_lsda_ex3_hit_idx //need consider lds0 and lda1, LTL@20241025
                                              && !(lsda_lsda_ex3_hit_idx && lsda_lsda_ex3_is_load) //lsda is load and hit_idx, no create, LTL@20241025
                                              && !(lsda_lsda_ex3_hit_idx && !lsda_lsda_ex3_is_load && self_iid_newer_than_other_lsda)//lsda is store and hit_idx, lsdc1, no create, LTL@20241025
                                              &&  !rb_lsda_ex3_hit_idx
                                              &&  !lfb_lsda_ex3_hit_idx
                                              &&  !lm_lsda_ex3_hit_idx
                                          ||  lsda_ex3_sync_fence
                                              &&  !st_da_atomic);
// &Force("output","lsda_rb_ex3_create_dp_vld"); @739
assign lsda_rb_ex3_create_dp_vld       = st_da_rb_create_vld_unmask;
// &Force("output","lsda_rb_ex3_create_gateclk_en"); @741
assign lsda_rb_ex3_create_gateclk_en   = st_da_rb_create_vld_unmask;

//-----------rb create signal-----------
//this inst will request lfb addr entry in rb
assign lsda_rb_ex3_create_lfb          = st_da_st_inst;

//==========================================================
//        Compare index
//==========================================================
//------------------compare pfu-----------------------------
assign st_da_cmp_pfu_biu_req_addr[`WK_PA_WIDTH-1:0]= pfu_biu_req_addr[`WK_PA_WIDTH-1:0];
assign lsda_pfu_ex3_biu_req_hit_idx  = st_da_rb_create_vld_unmask
                                    &&  (st_da_addr0[13:6]
                                        ==  st_da_cmp_pfu_biu_req_addr[13:6]);
assign st_da_cmp_lsda_ex3_addr[`WK_PA_WIDTH-1:0]   = lsda_selfda_ex3_addr[`WK_PA_WIDTH-1:0];                                 
assign selfda_lsda_ex3_hit_idx       = st_da_rb_create_vld_unmask
                                    &&  (st_da_addr0[13:6]
                                        ==  st_da_cmp_lsda_ex3_addr[13:6]);
//==========================================================
//        Restart signal
//==========================================================
assign st_da_rb_full_vld          = st_da_rb_create_vld_unmask
                                    &&  !st_da_ecc_stall
                                    &&  rb_lsda_ex3_full;
assign lsda_ex3_rb_full_gateclk_en   = lsda_rb_ex3_create_gateclk_en
                                    &&  rb_lsda_ex3_full;
assign st_da_wait_fence_vld       = lsda_ex3_inst_vld
                                    &&  (lsda_ex3_fence_inst && !st_da_fence_nop_inst ||  lsda_ex3_sync_inst)
                                    &&  lsu_has_fence;
assign lsda_ex3_wait_fence_gateclk_en  = st_da_wait_fence_vld;
assign st_da_restart_vld          = st_da_rb_full_vld ||  st_da_wait_fence_vld;

//==========================================================
//                    ECC handling
//==========================================================
assign st_dc_tag_inj_vld  = cp0_lsu_tag_ecc_inj 
                             && lsdc_lsda_ex2_tag_inj_dp 
                             && !lda0_lsda_ex3_tag_inj_mask   //1->2, 3 tag duplicate, must 2 0 and 1 1 mask, tag can inj, LTL@20241203
                             && !lsda_lsda_ex3_tag_inj_mask
                             && !lsu_lsda_tag_inj_cmplt; 

//for tag ecc_inj
assign dcache_st_tag_dout[`WK_LS_DCACHE_TAG_NOECC_WIDTH-1:0]   = st_dc_tag_inj_vld
                                    ? dcache_lsu_st_tag_dout[`WK_LS_DCACHE_TAG_NOECC_WIDTH-1:0] ^ {4{cp0_lsu_tag_random1[`WK_LS_DCACHE_SINGLE_TAG_WIDTH-1:0]}}   //double, L1D 2way->4way, LTL@20250321
                                    : dcache_lsu_st_tag_dout[`WK_LS_DCACHE_TAG_NOECC_WIDTH-1:0];

assign dcache_st_dirty_dout[`WK_LS_DCACHE_META_WIDTH-1:0] = st_dc_tag_inj_vld
                                    ? dcache_lsu_st_dirty_dout[`WK_LS_DCACHE_META_WIDTH-1:0] ^ {4{cp0_lsu_tag_random1[`WK_LS_DCAHCE_SINGLE_MATE_TAG_WIDTH-1:`WK_LS_DCACHE_SINGLE_TAG_WIDTH]}} //double, L1D 2way->4way, LTL@20250321
                                    : dcache_lsu_st_dirty_dout[`WK_LS_DCACHE_META_WIDTH-1:0];

//------------------tag ecc check------------
// &Force("bus","dcache_lsu_st_dirty_dout",22,0); @790
assign w0_tag_bf_ecc[`WK_LS_DCAHCE_SINGLE_MATE_TAG_WIDTH-1:0] = {dcache_st_dirty_dout[`WK_LS_DCACHE_SINGLE_META_WIDTH-1 :                              0], dcache_st_tag_dout[`WK_LS_DCACHE_SINGLE_TAG_WIDTH-1 :                             0]};
assign w1_tag_bf_ecc[`WK_LS_DCAHCE_SINGLE_MATE_TAG_WIDTH-1:0] = {dcache_st_dirty_dout[`WK_LS_DCACHE_DOUBLE_META_WIDTH-1 :`WK_LS_DCACHE_SINGLE_META_WIDTH], dcache_st_tag_dout[`WK_LS_DCACHE_DOUBLE_TAG_WIDTH-1 :`WK_LS_DCACHE_SINGLE_TAG_WIDTH]};
assign w2_tag_bf_ecc[`WK_LS_DCAHCE_SINGLE_MATE_TAG_WIDTH-1:0] = {dcache_st_dirty_dout[`WK_LS_DCACHE_TRIPLE_META_WIDTH-1 :`WK_LS_DCACHE_DOUBLE_META_WIDTH], dcache_st_tag_dout[`WK_LS_DCACHE_TRIPLE_TAG_WIDTH-1 :`WK_LS_DCACHE_DOUBLE_TAG_WIDTH]};
assign w3_tag_bf_ecc[`WK_LS_DCAHCE_SINGLE_MATE_TAG_WIDTH-1:0] = {dcache_st_dirty_dout[`WK_LS_DCACHE_META_WIDTH-1        :`WK_LS_DCACHE_TRIPLE_META_WIDTH], dcache_st_tag_dout[`WK_LS_DCACHE_TAG_NOECC_WIDTH-1  :`WK_LS_DCACHE_TRIPLE_TAG_WIDTH]};

assign tag_ecc_pipe_down = lsdc_ex2_inst_vld  ||  lsdc_ex2_borrow_vld;//dc_da_inst_vld->dc_inst_vld, lsu timing@LTL

`ifdef WK_PA_WIDTH_40
// &Instance("xx_lsu_30bit_2stage_ecc_decode","x_xx_lsu_30bit_2stage_ecc_decode_w0"); @798
xx_lsu_30bit_2stage_ecc_decode  x_xx_lsu_30bit_2stage_ecc_decode_w0 (
  .corrected_data         (w0_tag_corrected[`WK_LS_DCACHE_STTAG_BF_ECC_LENGTH-1:0]),
  .cpurst_b               (cpurst_b              ),
  .data_decode            (w0_tag_bf_ecc[`WK_LS_DATASRAM_ECC_WIDTH+`WK_LS_DCACHE_STTAG_BF_ECC_LENGTH:0]   ),
  .ecc_stage_vld          (tag_ecc_pipe_down     ),
  .ham_error              (w0_tag_ham_error      ),
  .parity_error           (w0_tag_parity_error   ),
  .stage_dp_clk           (st_da_clk             )
);
// &Instance("xx_lsu_30bit_2stage_ecc_decode","x_xx_lsu_30bit_2stage_ecc_decode_w1"); @807
xx_lsu_30bit_2stage_ecc_decode  x_xx_lsu_30bit_2stage_ecc_decode_w1 (
  .corrected_data         (w1_tag_corrected[`WK_LS_DCACHE_STTAG_BF_ECC_LENGTH-1:0]),
  .cpurst_b               (cpurst_b              ),
  .data_decode            (w1_tag_bf_ecc[`WK_LS_DATASRAM_ECC_WIDTH+`WK_LS_DCACHE_STTAG_BF_ECC_LENGTH:0]   ),
  .ecc_stage_vld          (tag_ecc_pipe_down     ),
  .ham_error              (w1_tag_ham_error      ),
  .parity_error           (w1_tag_parity_error   ),
  .stage_dp_clk           (st_da_clk             )
);
xx_lsu_30bit_2stage_ecc_decode  x_xx_lsu_30bit_2stage_ecc_decode_w2 (
  .corrected_data         (w2_tag_corrected[`WK_LS_DCACHE_STTAG_BF_ECC_LENGTH-1:0]),
  .cpurst_b               (cpurst_b              ),
  .data_decode            (w2_tag_bf_ecc[`WK_LS_DATASRAM_ECC_WIDTH+`WK_LS_DCACHE_STTAG_BF_ECC_LENGTH:0]   ),
  .ecc_stage_vld          (tag_ecc_pipe_down     ),
  .ham_error              (w2_tag_ham_error      ),
  .parity_error           (w2_tag_parity_error   ),
  .stage_dp_clk           (st_da_clk             )
);
xx_lsu_30bit_2stage_ecc_decode  x_xx_lsu_30bit_2stage_ecc_decode_w3 (
  .corrected_data         (w3_tag_corrected[`WK_LS_DCACHE_STTAG_BF_ECC_LENGTH-1:0]),
  .cpurst_b               (cpurst_b              ),
  .data_decode            (w3_tag_bf_ecc[`WK_LS_DATASRAM_ECC_WIDTH+`WK_LS_DCACHE_STTAG_BF_ECC_LENGTH:0]   ),
  .ecc_stage_vld          (tag_ecc_pipe_down     ),
  .ham_error              (w3_tag_ham_error      ),
  .parity_error           (w3_tag_parity_error   ),
  .stage_dp_clk           (st_da_clk             )
);
`endif

`ifdef WK_PA_WIDTH_48
// &Instance("xx_lsu_34bit_2stage_ecc_decode","x_xx_lsu_34bit_2stage_ecc_decode_w0"); @798
xx_lsu_38bit_2stage_ecc_decode  x_xx_lsu_38bit_2stage_ecc_decode_w0 (
  .corrected_data         (w0_tag_corrected[`WK_LS_DCACHE_STTAG_BF_ECC_LENGTH-1:0]),
  .cpurst_b               (cpurst_b              ),
  .data_decode            (w0_tag_bf_ecc[`WK_LS_DATASRAM_ECC_WIDTH+`WK_LS_DCACHE_STTAG_BF_ECC_LENGTH:0]   ),
  .ecc_stage_vld          (tag_ecc_pipe_down     ),
  .ham_error              (w0_tag_ham_error      ),
  .parity_error           (w0_tag_parity_error   ),
  .stage_dp_clk           (st_da_clk             )
);
// &Instance("xx_lsu_34bit_2stage_ecc_decode","x_xx_lsu_34bit_2stage_ecc_decode_w1"); @807
xx_lsu_38bit_2stage_ecc_decode  x_xx_lsu_38bit_2stage_ecc_decode_w1 (
  .corrected_data         (w1_tag_corrected[`WK_LS_DCACHE_STTAG_BF_ECC_LENGTH-1:0]),
  .cpurst_b               (cpurst_b              ),
  .data_decode            (w1_tag_bf_ecc[`WK_LS_DATASRAM_ECC_WIDTH+`WK_LS_DCACHE_STTAG_BF_ECC_LENGTH:0]   ),
  .ecc_stage_vld          (tag_ecc_pipe_down     ),
  .ham_error              (w1_tag_ham_error      ),
  .parity_error           (w1_tag_parity_error   ),
  .stage_dp_clk           (st_da_clk             )
);
xx_lsu_38bit_2stage_ecc_decode  x_xx_lsu_38bit_2stage_ecc_decode_w2 (
  .corrected_data         (w2_tag_corrected[`WK_LS_DCACHE_STTAG_BF_ECC_LENGTH-1:0]),
  .cpurst_b               (cpurst_b              ),
  .data_decode            (w2_tag_bf_ecc[`WK_LS_DATASRAM_ECC_WIDTH+`WK_LS_DCACHE_STTAG_BF_ECC_LENGTH:0]   ),
  .ecc_stage_vld          (tag_ecc_pipe_down     ),
  .ham_error              (w2_tag_ham_error      ),
  .parity_error           (w2_tag_parity_error   ),
  .stage_dp_clk           (st_da_clk             )
);
xx_lsu_38bit_2stage_ecc_decode  x_xx_lsu_38bit_2stage_ecc_decode_w3 (
  .corrected_data         (w3_tag_corrected[`WK_LS_DCACHE_STTAG_BF_ECC_LENGTH-1:0]),
  .cpurst_b               (cpurst_b              ),
  .data_decode            (w3_tag_bf_ecc[`WK_LS_DATASRAM_ECC_WIDTH+`WK_LS_DCACHE_STTAG_BF_ECC_LENGTH:0]   ),
  .ecc_stage_vld          (tag_ecc_pipe_down     ),
  .ham_error              (w3_tag_ham_error      ),
  .parity_error           (w3_tag_parity_error   ),
  .stage_dp_clk           (st_da_clk             )
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

assign st_da_tag_ecc_vld = st_da_dcache_info_vld
                           && cp0_lsu_dcache_en
                           && cp0_lsu_ecc_en
                           && (!w0_ecc_free || !w1_ecc_free || !w2_ecc_free || !w3_ecc_free);

assign st_da_tag_ecc_err = st_da_dcache_info_vld 
                           && cp0_lsu_dcache_en
                           && cp0_lsu_ecc_en
                           && (w0_ecc_fatal || w1_ecc_fatal || w2_ecc_fatal || w3_ecc_fatal);

//when 1-bit err,need to stall pipe to handle it
assign st_da_restart_no_cache = st_da_wait_fence_vld; 

assign st_da_tag_req_inst  = st_da_st_inst
                             || st_da_dcache_1line_inst
                             || st_da_atomic;
assign st_da_tag_ecc_stall = (lsda_ex3_inst_vld
                                   && !st_da_vector_nop
                                   && st_da_tag_req_inst
                                   && !st_da_expt_vld_cancel // Risc-V Debug zdb 
                                   && !st_da_restart_no_cache 
                                   && !rtu_lsu_flush_fe 
                                   && !(rtu_ck_flush && rtu_ck_flush_iid_older_than_ex3_iid)    //flush younger ecc_stall, ck_flush@LTL
//                                   && !st_da_dcwp_dc_hit_idx 
                                || lsda_ex3_borrow_vld
                                   && !st_da_borrow_icc)
                             && !st_da_ecc_stall_already
                             && st_da_tag_ecc_vld;

assign st_da_tag_ecc_stall_gate  = st_da_tag_ecc_stall;

//control singal
assign st_da_ecc_stall = st_da_tag_ecc_stall || ld_da_ecc_stall; //st_da_ecc_stall should contain ld_da_ecc_stall to process st borrow, LTL@20250213
assign st_da_ecc_fatal = st_da_tag_ecc_err
                         && !st_da_ecc_stall_already;

assign st_da_ecc_tag_way = st_da_tag_ecc_err
                           ? {w3_ecc_fatal,w2_ecc_fatal,w1_ecc_fatal,w0_ecc_fatal}
                           : {!w3_ecc_free,!w2_ecc_free,!w1_ecc_free,!w0_ecc_free};
//fix info
assign st_da_dcache_tag_corrected[`WK_LS_DCACHE_TAG_NOECC_WIDTH-1:0] = {w3_tag_corrected[`WK_LS_DCACHE_SINGLE_TAG_WIDTH-1:0],
                                                                        w2_tag_corrected[`WK_LS_DCACHE_SINGLE_TAG_WIDTH-1:0],
                                                                        w1_tag_corrected[`WK_LS_DCACHE_SINGLE_TAG_WIDTH-1:0],
                                                                        w0_tag_corrected[`WK_LS_DCACHE_SINGLE_TAG_WIDTH-1:0]};

assign st_da_dcache_dirty_corrected[15:0] = { w3_tag_corrected[`WK_LS_DCACHE_STTAG_BF_ECC_LENGTH-1:`WK_LS_DCACHE_SINGLE_TAG_WIDTH],
                                              w2_tag_corrected[`WK_LS_DCACHE_STTAG_BF_ECC_LENGTH-1:`WK_LS_DCACHE_SINGLE_TAG_WIDTH],
                                              w1_tag_corrected[`WK_LS_DCACHE_STTAG_BF_ECC_LENGTH-1:`WK_LS_DCACHE_SINGLE_TAG_WIDTH],
                                              w0_tag_corrected[`WK_LS_DCACHE_STTAG_BF_ECC_LENGTH-1:`WK_LS_DCACHE_SINGLE_TAG_WIDTH]};  //st_da_dcache_dirty_array[16] deleted, LTL@20250325

assign st_da_ecc_tag0_hit   = (st_da_addr0[`WK_PA_WIDTH-1:14] == w0_tag_corrected[`WK_LS_DCACHE_SINGLE_TAG_WIDTH-1:0]);
assign st_da_ecc_tag1_hit   = (st_da_addr0[`WK_PA_WIDTH-1:14] == w1_tag_corrected[`WK_LS_DCACHE_SINGLE_TAG_WIDTH-1:0]);
assign st_da_ecc_tag2_hit   = (st_da_addr0[`WK_PA_WIDTH-1:14] == w2_tag_corrected[`WK_LS_DCACHE_SINGLE_TAG_WIDTH-1:0]);
assign st_da_ecc_tag3_hit   = (st_da_addr0[`WK_PA_WIDTH-1:14] == w3_tag_corrected[`WK_LS_DCACHE_SINGLE_TAG_WIDTH-1:0]);
//for vb/snq tag reissue
// //&Force("output","st_da_snq_tag_reissue"); @869
assign lsda_vb_ex3_tag_reissue  = st_da_ecc_stall;
assign st_da_snq_tag_reissue = lsdc_ex2_borrow_vld
                               && lsdc_lsda_ex2_borrow_snq
                               && st_da_ecc_stall;

assign lsda_snq_ex3_entry_tag_reissue[SNQ_ENTRY-1:0] = {SNQ_ENTRY{st_da_snq_tag_reissue}} & lsdc_lsda_ex2_borrow_snq_id[SNQ_ENTRY-1:0];
//for vb/snq ecc error
assign lsda_vb_ex3_ecc_stall  = lsda_ex3_borrow_vld
                             && !st_da_borrow_snq 
                             && !st_da_borrow_icc 
                             && st_da_ecc_stall; 

assign lsda_vb_ex3_ecc_err  = lsda_ex3_borrow_vld
                           && !st_da_borrow_snq 
                           && !st_da_borrow_icc 
                           && st_da_ecc_stall_already 
                           && st_da_ecc_stall_fatal; 

assign lsda_snq_ex3_ecc_err = lsda_ex3_borrow_vld
                           && st_da_borrow_snq
                           && st_da_ecc_stall_already 
                           && st_da_ecc_stall_fatal; 
//for wakeup
assign lsda_ex3_ecc_wakeup[LSIQ_ENTRY-1:0] = {LSIQ_ENTRY{st_da_ecc_stall_already}} 
                                          & st_da_ecc_wakeup_queue[LSIQ_ENTRY-1:0];

//when da hit dcache idx and ecc err occurs,st_inst should replay
assign st_da_ecc_hit_idx_vld = lsda_ex3_inst_vld 
                               && dcache_dirty_gwen
                               && st_da_dcache_hit_idx;

//st da wakeup queue
assign st_da_wakeup_lsid[LSIQ_ENTRY-1:0] = {LSIQ_ENTRY{lsdc_lsda_ex2_inst_vld && !rtu_lsu_flush_fe}} & lsdc_lsda_ex2_lsid[LSIQ_ENTRY-1:0]
                                           | {LSIQ_ENTRY{st_da_ecc_hit_idx_vld}} & st_da_lsid[LSIQ_ENTRY-1:0];

//for lm
assign lsda_lm_ex3_ecc_err           = lsda_ex3_inst_vld
                                    && st_da_stamo_inst
                                    && st_da_ecc_stall_already 
                                    && st_da_ecc_stall_fatal;

//ECC info
assign ecc_info_update      = lsda_ex3_inst_vld
                                 && st_da_ecc_stall_already
//                                 && !st_da_restart_vld
                                 && !st_da_ecc_stall_dcache_update
                              || lsda_ex3_borrow_vld
                                 && !st_da_borrow_icc
                                 && st_da_ecc_stall_already;

//assign ecc_pa[WK_PA_WIDTH-1:0] = st_da_ecc_stall_tag_way
//                                  ? {st_da_dcache_tag_array[51:26],st_da_addr0[13:0]}
//                                  : {st_da_dcache_tag_array[25:0],st_da_addr0[13:0]};
always @(*)
begin
casez(st_da_ecc_stall_tag_way[3:0])
  4'b1???: begin
    ecc_pa[`WK_PA_WIDTH-1:0] = { st_da_dcache_tag_array[`WK_LS_DCACHE_TAG_NOECC_WIDTH-1 :`WK_LS_DCACHE_TRIPLE_TAG_WIDTH],
                                st_da_addr0[13:0]};  //way3
    st_da_ecc_stall_tag_way_2bit = 2'b11;
  end
  4'b01??: begin
    ecc_pa[`WK_PA_WIDTH-1:0] = { st_da_dcache_tag_array[`WK_LS_DCACHE_TRIPLE_TAG_WIDTH-1:`WK_LS_DCACHE_DOUBLE_TAG_WIDTH],
                                st_da_addr0[13:0]};  //way2
    st_da_ecc_stall_tag_way_2bit = 2'b10;
  end
  4'b001?: begin
    ecc_pa[`WK_PA_WIDTH-1:0] = { st_da_dcache_tag_array[`WK_LS_DCACHE_DOUBLE_TAG_WIDTH-1:`WK_LS_DCACHE_SINGLE_TAG_WIDTH],
                                st_da_addr0[13:0]};  //way1
    st_da_ecc_stall_tag_way_2bit = 2'b01;
  end
  4'b0001: begin
    ecc_pa[`WK_PA_WIDTH-1:0] = { st_da_dcache_tag_array[`WK_LS_DCACHE_SINGLE_TAG_WIDTH-1:0],
                                st_da_addr0[13:0]};  //way0
    st_da_ecc_stall_tag_way_2bit = 2'b00;
  end
  default: begin
    ecc_pa[`WK_PA_WIDTH-1:0] = {`WK_PA_WIDTH{1'b0}};
    st_da_ecc_stall_tag_way_2bit = 2'b00;
  end
endcase
end
assign ecc_info_index[16:0] = st_da_addr0[16:0];
assign ecc_info_way[1:0]    = st_da_ecc_stall_tag_way_2bit; //{1'b0,st_da_ecc_stall_tag_way}, 2bit for 4way, LTL@20250321
assign ecc_info_ramid[2:0]  = 3'b010;
assign ecc_info_fatal       = st_da_ecc_stall_fatal;

//interface
assign lsda_ex3_ecc_info_update_gate = st_da_ecc_stall_already;
assign lsda_ex3_ecc_info_update      = ecc_info_update; 
assign lsda_ex3_ecc_info[22:0]       = {ecc_info_fatal,ecc_info_ramid[2:0],ecc_info_way[1:0],ecc_info_index[16:0]};
assign lsda_ex3_ecc_pa[`WK_PA_WIDTH-1:0] = ecc_pa[`WK_PA_WIDTH-1:0];

//assign st_da_ecc_async_expt_vld   = lsda_ex3_borrow_vld
//                                    && ecc_info_fatal;

//st pipe inj cmplt
// &Force("output","lsu_lsda_tag_inj_cmplt"); @938
assign lsu_lsda_tag_inj_cmplt  = ecc_info_update
                               && st_da_tag_inj_vld;

//to avoid ld tag inj simultaneously,use st inj to mask
assign lsda_ex3_tag_inj_mask = (lsda_ex3_inst_vld || lsda_ex3_borrow_vld)
                               && st_da_tag_inj_vld;                                    
// &Force("nonport","st_da_stamo_inst"); @946

//==========================================================
//        Generage to SQ signal
//==========================================================
assign lsda_sq_ex3_ecc_stall         = st_da_ecc_stall || st_da_ecc_stall_dcache_update;
assign lsda_sq_ex3_no_restart        = lsda_ex3_inst_vld
                                    &&  !st_da_restart_vld;
//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
assign lsda_sq_ex3_expt_vld          =  st_da_expt_vld_cancel;
//==========================================================
//                  Risc-V Debug zdb End 
//==========================================================
assign lsda_sq_ex3_lm_fail           = st_da_ecc_stall_already
                                    && st_da_ecc_stall_fatal;
//==========================================================
//        Generage interface to prefetch buffer
//==========================================================
// &Force("output","lsda_pfu_ex3_pf_inst_vld"); @972
assign lsda_pfu_ex3_pf_inst_vld      = lsda_ex3_inst_vld
                                    &&  st_da_pf_inst
                                    &&  !st_da_ecc_stall_already
                                    &&  !st_da_already_da
                                    &&  !st_da_expt_vld;

assign st_da_boundary_cross_2k    = st_da_pfu_va[11]
                                    !=  st_da_addr0[11];
//if cache miss and not hit idx, then it can create pmb
assign lsda_pfu_ex3_awk_vld          = lsda_ex3_inst_vld
                                    &&  st_da_pf_inst
                                    &&  !st_da_expt_vld
                                    &&  (lsda_rb_ex3_create_vld || st_da_split_miss_ff)
                                    &&  st_da_rb_page_wa
                                    &&  lsda_vb_ex3_dcache_miss
                                    &&  !st_da_boundary_cross_2k;//cross 4k condition will get wrong ppn

assign lsda_pfu_ex3_awk_dp_vld       = lsda_ex3_inst_vld
                                    &&  st_da_pf_inst
                                    &&  !st_da_expt_vld
                                    &&  st_da_rb_page_wa
                                    &&  lsda_vb_ex3_dcache_miss
                                    &&  !st_da_boundary_cross_2k;//cross 4k condition will get wrong ppn

//for evict count
assign lsda_pfu_ex3_eviwk_cnt_vld    = lsda_pfu_ex3_pf_inst_vld;

//st prefetch does not support gpfb
assign lsda_pfu_ex3_ppfu_va[`WK_PA_WIDTH-1:0] = st_da_pfu_va[`WK_PA_WIDTH-1:0];
//==========================================================
//                Flop for st_da
//==========================================================
assign st_da_ff_clk_en  = lsda_ex3_inst_vld
                          && st_da_st_inst
                          && cp0_lsu_l2_st_pref_en;
// &Instance("gated_clk_cell", "x_lsu_st_da_ff_gated_clk"); @1008
gated_clk_cell  x_lsu_st_da_ff_gated_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (st_da_ff_clk      ),
  .external_en        (1'b0              ),
  .local_en           (st_da_ff_clk_en   ),
  .module_en          (cp0_lsu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect(.clk_in        (forever_cpuclk     ), @1009
//          .external_en   (1'b0               ), @1010
//          .module_en     (cp0_lsu_icg_en     ), @1011
//          .local_en      (st_da_ff_clk_en    ), @1012
//          .clk_out       (st_da_ff_clk       )); @1013

always @(posedge st_da_ff_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    lsda_pfu_ex3_ppn_ff[`WK_PA_WIDTH-13:0]  <=  {`WK_PA_WIDTH-12{1'b0}};
    lsda_ex3_page_sec_ff             <=  1'b0;
    lsda_ex3_page_share_ff           <=  1'b0;
  end
  else if(lsda_ex3_inst_vld && st_da_st_inst)
  begin
    lsda_pfu_ex3_ppn_ff[`WK_PA_WIDTH-13:0]  <=  st_da_addr0[`WK_PA_WIDTH-1:12];
    lsda_ex3_page_sec_ff             <=  lsda_ex3_page_sec;
    lsda_ex3_page_share_ff           <=  lsda_ex3_page_share;
  end
end

//for preload
//when split load cache miss,record
assign st_da_split_miss = lsda_ex3_inst_vld
                          && st_da_st_inst
                          && lsda_ex3_page_ca
                          && cp0_lsu_dcache_en
                          && st_da_split
                          && !lsda_sq_ex3_secd
                          && !st_da_expt_vld_cancel // Risc-V Debug zdb
                          && lsda_rb_ex3_create_vld;

assign st_da_split_last = lsda_ex3_inst_vld
                          && st_da_st_inst
                          && !st_da_split;

always @(posedge st_da_ff_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    st_da_split_miss_ff           <=  1'b0;
  else if(st_da_split_miss)
    st_da_split_miss_ff           <=  1'b1;
  else if(st_da_split_last)
    st_da_split_miss_ff           <=  1'b0;
end

//==========================================================
//        Generage to WB stage signal
//==========================================================
//------------------write back cmplt part request-----------
assign lsda_lswb_ex3_cmplt_req     = lsda_ex3_inst_vld
                                &&  !st_da_restart_vld
                                &&  !st_da_ecc_stall
                                &&  !st_da_ecc_stall_dcache_update
                                &&  !st_da_boundary_first
                                &&  (st_da_expt_vld_cancel
                                    ||  st_da_vector_nop
                                    ||  st_da_fence_nop_inst
                                    ||  (st_da_ctc_inst
                                        ||  st_da_dcache_1line_inst
                                        ||  st_da_l2cache_inst
                                        ||  st_da_st_inst && !lsda_ex3_page_so)); // Risc-V Debug zdb
//------------------other signal---------------------------
assign lsda_lswb_ex3_spec_fail     = st_da_spec_fail
                                &&  !st_da_split;

//==========================================================
//        Generate interface to borrow module
//==========================================================
assign st_da_borrow_snq_vld                 = lsda_ex3_borrow_vld
                                              &&  st_da_borrow_snq
                                              &&  !st_da_ecc_stall;
assign lsda_snq_ex3_borrow_snq[SNQ_ENTRY-1:0]  = {SNQ_ENTRY{st_da_borrow_snq_vld}}
                                              & st_da_borrow_snq_id[SNQ_ENTRY-1:0];

assign lsda_ex3_borrow_icc_vld                 = lsda_ex3_borrow_vld
                                              &&  st_da_borrow_icc;
//assign lsda_icc_ex3_dirty_info[3:0]            = st_da_dcache_sw_sel                //??? send to cp0, no need 2->4, LTL@20250321
//                                              ? st_da_dcache_dirty_array[7:4]
//                                              : st_da_dcache_dirty_array[3:0];
//assign lsda_icc_ex3_tag_info[25:0]             = st_da_dcache_sw_sel                //??? send to cp0, no need 2->4, LTL@20250321
//                                              ? st_da_dcache_tag_array[51:26]
//                                              : st_da_dcache_tag_array[25:0];
//assign lsda_icc_ex3_ecc_info[6:0]              = st_da_dcache_sw_sel                //??? send to cp0, no need 2->4, LTL@20250321
//                                              ? st_da_dcache_dirty_ecc[13:7]
//                                              : st_da_dcache_dirty_ecc[6:0]; 
always_comb begin
  case(st_da_dcache_sw_sel_2bit)
  2'b00: begin
    lsda_icc_ex3_dirty_info[3:0]                                      = st_da_dcache_dirty_array[3:0];
    lsda_icc_ex3_tag_info[`WK_LS_DCACHE_SINGLE_TAG_WIDTH-1:0]         = st_da_dcache_tag_array[`WK_LS_DCACHE_SINGLE_TAG_WIDTH-1:0];
    lsda_icc_ex3_ecc_info[`WK_LS_DCACHE_SINGLE_DIRTY_ECC_WIDTH-1:0]   = st_da_dcache_dirty_ecc[`WK_LS_DCACHE_SINGLE_DIRTY_ECC_WIDTH-1:0];
  end
  2'b01: begin
    lsda_icc_ex3_dirty_info[3:0]                                      = st_da_dcache_dirty_array[7:4];
    lsda_icc_ex3_tag_info[`WK_LS_DCACHE_SINGLE_TAG_WIDTH-1:0]         = st_da_dcache_tag_array[`WK_LS_DCACHE_DOUBLE_TAG_WIDTH-1:`WK_LS_DCACHE_SINGLE_TAG_WIDTH];
    lsda_icc_ex3_ecc_info[`WK_LS_DCACHE_SINGLE_DIRTY_ECC_WIDTH-1:0]   = st_da_dcache_dirty_ecc[`WK_LS_DCACHE_DOUBLE_DIRTY_ECC_WIDTH-1:`WK_LS_DCACHE_SINGLE_DIRTY_ECC_WIDTH];    
  end
  2'b10: begin
    lsda_icc_ex3_dirty_info[3:0]                                      = st_da_dcache_dirty_array[11:8];
    lsda_icc_ex3_tag_info[`WK_LS_DCACHE_SINGLE_TAG_WIDTH-1:0]         = st_da_dcache_tag_array[`WK_LS_DCACHE_TRIPLE_TAG_WIDTH-1:`WK_LS_DCACHE_DOUBLE_TAG_WIDTH];
    lsda_icc_ex3_ecc_info[`WK_LS_DCACHE_SINGLE_DIRTY_ECC_WIDTH-1:0]   = st_da_dcache_dirty_ecc[`WK_LS_DCACHE_TRIPLE_DIRTY_ECC_WIDTH-1:`WK_LS_DCACHE_DOUBLE_DIRTY_ECC_WIDTH];
  end
  2'b11: begin
    lsda_icc_ex3_dirty_info[3:0]                                      = st_da_dcache_dirty_array[15:12];
    lsda_icc_ex3_tag_info[`WK_LS_DCACHE_SINGLE_TAG_WIDTH-1:0]         = st_da_dcache_tag_array[`WK_LS_DCACHE_TAG_NOECC_WIDTH-1:`WK_LS_DCACHE_TRIPLE_TAG_WIDTH];
    lsda_icc_ex3_ecc_info[`WK_LS_DCACHE_SINGLE_DIRTY_ECC_WIDTH-1:0]   = st_da_dcache_dirty_ecc[`WK_LS_DCACHE_DIRTY_ECC_WIDTH-1:`WK_LS_DCACHE_TRIPLE_DIRTY_ECC_WIDTH];    
  end
  default: begin
    lsda_icc_ex3_dirty_info[3:0]                                      = '0;
    lsda_icc_ex3_tag_info[`WK_LS_DCACHE_SINGLE_TAG_WIDTH-1:0]         = '0;
    lsda_icc_ex3_ecc_info[`WK_LS_DCACHE_SINGLE_DIRTY_ECC_WIDTH-1:0]   = '0; 
  end
  endcase
end

//==========================================================
//        Generate lsiq signal
//==========================================================
assign st_da_mask_lsid[LSIQ_ENTRY-1:0]      = {LSIQ_ENTRY{lsda_ex3_inst_vld}}
                                              & st_da_lsid[LSIQ_ENTRY-1:0];

assign st_da_boundary_first                 = st_da_boundary
                                              &&  !st_da_wb_expt_vld_cancel
                                              &&  !lsda_sq_ex3_secd;
//-----------lsiq signal----------------
// &Force("output","lsda_ex3_ecc_wakeup"); @1109
//for avoid dc vector nop from wakeup sdiq multiple times.use already_da as
//symbol signal, here set already_da ahead for dc replay inst by da ecc stall
//
//note already_da is only used for performance in da stage,hence not accurate
//here is fine
assign lsda_idu_ex3_already_da[LSIQ_ENTRY-1:0] = st_da_mask_lsid[LSIQ_ENTRY-1:0]
                                              | lsda_ex3_ecc_wakeup[LSIQ_ENTRY-1:0] & {LSIQ_ENTRY{ecc_wakeup_dc_already_da}};

assign lsda_idu_ex3_rb_full[LSIQ_ENTRY-1:0]    = {LSIQ_ENTRY{st_da_rb_full_vld}}
                                              & st_da_mask_lsid[LSIQ_ENTRY-1:0];

assign lsda_idu_ex3_wait_fence[LSIQ_ENTRY-1:0]   = {LSIQ_ENTRY{st_da_wait_fence_vld}}
                                              & st_da_mask_lsid[LSIQ_ENTRY-1:0];

// &Force("output","lsda_idu_ex3_pop_vld"); @1124
assign lsda_idu_ex3_pop_vld                    = lsda_ex3_inst_vld
                                              &&  !st_da_boundary_first
                                              &&  !st_da_tag_ecc_stall
                                              &&  !st_da_ecc_stall_dcache_update
                                              &&  !st_da_restart_vld;
assign lsda_idu_ex3_pop_entry[LSIQ_ENTRY-1:0]  = {LSIQ_ENTRY{lsda_idu_ex3_pop_vld}}
                                              & st_da_mask_lsid[LSIQ_ENTRY-1:0];

assign lsda_idu_ex3_spec_fail[LSIQ_ENTRY-1:0]  = {LSIQ_ENTRY{st_da_spec_fail
                                                          &&  st_da_boundary_first }}
                                              & st_da_mask_lsid[LSIQ_ENTRY-1:0];
            
//---------boundary gateclk-------------
assign st_da_idu_boundary_gateclk_vld       = lsda_ex3_inst_vld
                                              &&  st_da_boundary_first;

assign lsda_idu_ex3_boundary_gateclk_en[LSIQ_ENTRY-1:0]  = 
                {LSIQ_ENTRY{st_da_idu_boundary_gateclk_vld}}
                & st_da_mask_lsid[LSIQ_ENTRY-1:0];

//-----------imme wakeup----------------
assign st_da_idu_secd_vld                   = lsda_ex3_inst_vld
                                              &&  st_da_boundary_first
                                              &&  !st_da_tag_ecc_stall
                                              &&  !st_da_ecc_stall_dcache_update
                                              &&  !st_da_restart_vld;

assign lsda_idu_ex3_secd[LSIQ_ENTRY-1:0]       = {LSIQ_ENTRY{st_da_idu_secd_vld}}
                                              & st_da_mask_lsid[LSIQ_ENTRY-1:0];
//==========================================================
//        interface for spec_fail prediction
//==========================================================
assign st_da_no_spec_target = (st_da_no_spec[1:0] == 2'b01);

assign st_da_no_spec_miss = lsda_ex3_inst_vld
                            && cp0_lsu_nsfe
                            && !st_da_atomic
                            && st_da_spec_fail; 

assign lsda_sf_ex3_no_spec_miss         = st_da_no_spec_miss
                                       && !st_da_restart_vld;
assign lsda_sf_ex3_no_spec_miss_gate    = st_da_no_spec_miss;
assign lsda_sf_ex3_iid[IID_WIDTH-1:0]   = lsda_ex3_iid[IID_WIDTH-1:0];  //parameterized, LTL@20241101

assign lsda_sf_ex3_addr_tto4[`WK_PA_WIDTH-5:0]  = st_da_addr0[`WK_PA_WIDTH-1:4];
assign lsda_sf_ex3_bytes_vld[15:0]              = st_da_bytes_vld[15:0];
// wjh@sfp
assign lsda_sf_ex3_spec_chk_req = lsda_ex3_inst_vld
                                  && st_da_st_inst
                                  && cp0_lsu_nsfe
                                  && !lsda_ex3_page_so
                                  && !st_da_expt_vld_except_access_err
                                  && !st_da_restart_vld;

assign st_da_no_spec_hit  = lsda_ex3_inst_vld
                            && cp0_lsu_nsfe
                            && st_da_no_spec_target 
                            && !st_da_spec_fail; 

assign st_da_no_spec_mispred = lsda_ex3_inst_vld
                               && cp0_lsu_nsfe
                               && st_da_no_spec_target 
                               && st_da_spec_fail; 

//wb_cmplt
assign lsda_lswb_ex3_no_spec_miss     = st_da_no_spec_miss && !st_da_no_spec_target;
assign lsda_lswb_ex3_no_spec_hit      = st_da_no_spec_hit;
assign lsda_lswb_ex3_no_spec_mispred  = st_da_no_spec_mispred;
assign lsda_lswb_ex3_no_spec_target   = 1'b1;

//==========================================================
//        Generate interface to rtu
//==========================================================
assign lsu_rtu_ex3_ssf_vld = lsda_ex3_inst_vld
                                              &&  !st_da_wb_expt_vld_cancel
                                              &&  st_da_split
                                              &&  st_da_spec_fail;
assign lsu_rtu_ex3_ssf_iid[IID_WIDTH-1:0]  = lsda_ex3_iid[IID_WIDTH-1:0];
//==========================================================
//        interface to hpcp
//==========================================================
assign lsu_hpcp_ls_cache_access = lsda_ex3_inst_vld
                                  &&  st_da_st_inst
                                  && st_da_page_ca_dcache_en
                                  && !st_da_already_da;
assign lsu_hpcp_ls_cache_miss   = lsda_ex3_inst_vld
                                  &&  st_da_st_inst
                                  &&  st_da_page_ca_dcache_en
                                  &&  lsda_vb_ex3_dcache_miss
                                  &&  !st_da_restart_vld
                                  &&  lsda_rb_ex3_create_vld;
assign lsu_hpcp_ls_unalign_inst = lsda_ex3_inst_vld
                                  &&  !st_da_already_da
                                  &&  lsda_sq_ex3_secd;
// &Force("nonport","st_da_already_da"); @1220
// &ModuleEnd; @1222

//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
assign st_da_expt_vld_cancel = st_da_expt_vld
                             | dtu_lsu_addr_halt_info[0];

assign st_da_wb_expt_vld_cancel = lsda_ex3_expt_vld
                             | dtu_lsu_addr_halt_info[0];                             

assign st_da_idu_halt_info_update_vld[LSIQ_ENTRY-1:0] = {LSIQ_ENTRY{st_da_idu_secd_vld}}
                                                      & st_da_mask_lsid[LSIQ_ENTRY-1:0];
assign st_da_idu_halt_info[`TDT_MP_HINFO_WIDTH-1:0]   = dtu_lsu_addr_halt_info[`TDT_MP_HINFO_WIDTH-1:0];

assign st_da_dtu_addr_halt_info_stall_vld             = st_da_ecc_stall;
//==========================================================
//                  Risc-V Debug zdb End
//==========================================================
endmodule


