//-----------------------------------------------------------------------------
// File          : xx_lsu_st_dc.v
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


// $Id: xx_lsu_st_dc.vp,v 1.70 2022/01/06 08:14:36 jizk Exp $
// *****************************************************************************

// &ModuleBeg; @25
module xx_lsu_ls_st_dc #(
  parameter LSIQ_ENTRY  = 12,
  parameter SDIQ_ENTRY  = 12,  
  parameter IID_WIDTH   = 7,
  parameter SDID_LEN    = 4,
  parameter SNQ_ENTRY   = 6,
  parameter PC_LEN      = 15,
  parameter PREG        = 7,
  parameter WK_PA_WIDTH = 40,
  parameter WK_VA_WIDTH = 39
)(
// &Ports; @26
input logic                                                 rtu_ck_flush,
input logic  [IID_WIDTH-1  :0]                              rtu_ck_flush_iid,
input logic                                                 cp0_lsu_dcache_en,               
input logic                                                 cp0_lsu_ecc_en,                  
input logic                                                 cp0_lsu_icg_en,                  
input logic                                                 cp0_lsu_l2_st_pref_en,           
input logic                                                 cpurst_b,                        
input logic                                                 ctrl_st_clk,                     
input logic                                                 dcache_arb_lsdc_borrow_icc,     
input logic                                                 dcache_arb_lsdc_borrow_snq,     
input logic   [SNQ_ENTRY-1:0]                               dcache_arb_lsdc_borrow_snq_id,  
input logic                                                 dcache_arb_lsdc_borrow_vld,     
input logic                                                 dcache_arb_lsdc_borrow_vld_gate,
input logic                                                 dcache_arb_lsdc_dcache_replace, 
input logic   [1 :0]                                        dcache_arb_lsdc_ex1_dcache_sw,      
input logic                                                 dcache_lsdc_dirty_gwen,               
input logic   [7 :0]                                        dcache_lsdc_idx,             //8->7, L1D 2way->4way, LTL@20250321         
input logic   [`WK_LS_DCACHE_META_WIDTH-1:0]                dcache_lsdc_dirty_dout,      //ask lishuo,  L1D 2way->4way, LTL@20250321   
input logic   [`WK_LS_DCACHE_TAG_NOECC_WIDTH-1:0]           dcache_lsdc_tag_dout,        //51->103, L1D 2way->4way, LTL@20250321    
input logic                                                 forever_cpuclk,                               
input logic                                                 lq_lsdc_ex2_spec_fail,              
input logic                                                 mmu_lsu_mmu_en,                  
input logic                                                 mmu_lsu_tlb_busy,                
input logic                                                 mmu_lsu_imme_wakeup, // wjh@tmq full, mrg-on-cmplt
input logic                                                 pad_yy_icg_scan_en,              
input logic   [IID_WIDTH-1:0]                               rtu_lsu_commit0_iid_updt_val,     
input logic   [IID_WIDTH-1:0]                               rtu_lsu_commit1_iid_updt_val,     
input logic   [IID_WIDTH-1:0]                               rtu_lsu_commit2_iid_updt_val,
input logic   [IID_WIDTH-1:0]                               rtu_lsu_commit3_iid_updt_val,     
input logic   [IID_WIDTH-1:0]                               rtu_lsu_commit4_iid_updt_val,     
input logic   [IID_WIDTH-1:0]                               rtu_lsu_commit5_iid_updt_val,     
input logic   [IID_WIDTH-1:0]                               rtu_lsu_commit6_iid_updt_val,     
input logic   [IID_WIDTH-1:0]                               rtu_lsu_commit7_iid_updt_val,    
input logic                                                 rtu_lsu_flush_fe,                
input logic   [SDID_LEN-1:0]                                std0_rf_sdid,         //should consider std0 and std1, LTL@20241123
input logic   [SDID_LEN-1:0]                                std1_rf_sdid,           
input logic                                                 sq_lsdc_ex2_full,                   
input logic                                                 sq_lsdc_ex2_inst_hit,  
input logic                                                 lsag_ex1_is_load,              
input logic                                                 lsag_lsdc_ex1_already_da,                
input logic                                                 lsag_lsdc_ex1_atomic,                    
input logic                                                 lsag_lsdc_ex1_boundary,                  
input logic   [2 :0]                                        lsag_ex1_access_size,            
input logic   [`WK_PA_WIDTH-1:0]                            lsag_lsdc_ex1_addr0,                  
input logic   [15:0]                                        lsag_lsdc_ex1_bytes_vld,              
input logic                                                 lsag_lsdc_ex1_inst_vld,               
input logic                                                 lsag_lsdc_ex1_mmu_req,                
input logic                                                 lsag_lsdc_ex1_page_share,             
input logic                                                 lsag_lsdc_ex1_page_so,                
input logic   [3 :0]                                        lsag_lsdc_ex1_rot_sel,                
input logic                                                 lsag_lsdc_ex1_dtcm_hit,                  
input logic   [8 :0]                                        lsag_lsdc_ex1_element_cnt,               
input logic   [1 :0]                                        lsag_lsdc_ex1_element_size,              
input logic                                                 lsag_lsdc_ex1_expt_access_fault_with_page,
input logic                                                 lsag_lsdc_ex1_expt_illegal_inst,         
input logic                                                 lsag_lsdc_ex1_expt_misalign_no_page,     
input logic                                                 lsag_lsdc_ex1_expt_misalign_with_page,   
input logic                                                 lsag_lsdc_ex1_expt_page_fault,           
input logic                                                 lsag_lsdc_ex1_expt_amo_not_ca,         
input logic                                                 lsag_lsdc_ex1_expt_vld,                  
input logic   [3 :0]                                        lsag_lsdc_ex1_fence_mode,                
input logic                                                 lsag_lsdc_ex1_icc,                       
input logic                                                 lsag_lsdc_ex1_idx_order,                 
input logic   [IID_WIDTH-1:0]                               lsag_ex1_iid,                       
input logic                                                 lsag_lsdc_ex1_inst_flush,                
input logic   [1 :0]                                        lsag_lsdc_ex1_inst_mode,                 
input logic   [1 :0]                                        lsag_lsdc_ex1_inst_type,                 
input logic                                                 lsag_ex1_inst_vld,                  
input logic                                                 lsag_lsdc_ex1_inst_vls,                  
input logic                                                 lsag_lsdc_ex1_itcm_hit,                  
input logic                                                 lsag_lsdc_ex1_lsfifo,                    
input logic   [LSIQ_ENTRY-1:0]                              lsag_lsdc_ex1_lsid,                               
input logic                                                 lsag_lsdc_ex1_lsiq_spec_fail,            
input logic   [`WK_PA_WIDTH-1:0]                            lsag_lsdc_ex1_mt_value,                  
input logic   [1 :0]                                        lsag_lsdc_ex1_no_spec,                   
input logic                                                 lsag_lsdc_ex1_old,                       
input logic                                                 lsag_lsdc_ex1_page_buf,                  
input logic                                                 lsag_lsdc_ex1_page_ca,                   
input logic                                                 lsag_lsdc_ex1_page_sec,                  
input logic                                                 lsag_lsdc_ex1_page_wa,                   
input logic   [PC_LEN-1:0]                                  lsag_lsdc_ex1_pc,                        
input logic   [PREG-1:0]                                    lsag_lsdc_ex1_preg,
input logic   [SDIQ_ENTRY-1:0]                              lsag_lsdc_ex1_sdiq_entry,                   
input logic                                                 lsag_lsdc_ex1_secd,                      
input logic                                                 lsag_lsdc_ex1_split,                     
input logic                                                 lsag_lsdc_ex1_st,                        
input logic                                                 lsag_lsdc_ex1_staddr,                    
input logic                                                 lsag_lsdc_ex1_sync_fence,                
input logic                                                 lsag_lsdc_ex1_utlb_miss,                 
input logic   [`WK_PA_WIDTH-13:0]                           lsag_lsdc_ex1_vpn,                       
//input logic   [1 :0]                                        lsag_lsdc_ex1_vsew,   //rvv1.0 @hcl    
input logic   [1 :0]  lsag_lsdc_ex1_vmew,   //rvv1.0 @hcl
input logic   [1 :0]  lsag_lsdc_ex1_vmop,   //rvv1.0 @hcl               
output logic  [SDIQ_ENTRY-1:0]                              lsu_idu_ex2_sdiq_entry,           
output logic                                                lsu_idu_ex2_staddr1_vld,          
output logic                                                lsu_idu_ex2_staddr_unalign,       
output logic                                                lsu_idu_ex2_staddr_vld,           
output logic  [`WK_PA_WIDTH-13:0]                           lsu_mmu_vabuf,
output logic                                                lsdc_ex2_is_load,                 
output logic  [`WK_PA_WIDTH-1:0]                            lsdc_ex2_addr0,                     
output logic                                                lsdc_lsda_ex2_already_da,                
output logic                                                lsdc_ex2_atomic,                                  
output logic                                                lsdc_lsda_ex2_borrow_dcache_replace,     
output logic  [1 :0]                                        lsdc_lsda_ex2_borrow_dcache_sw,          
output logic                                                lsdc_lsda_ex2_borrow_icc,                
output logic                                                lsdc_lsda_ex2_borrow_snq,                
output logic  [SNQ_ENTRY-1:0]                               lsdc_lsda_ex2_borrow_snq_id,             
output logic                                                lsdc_ex2_borrow_vld,                
output logic                                                lsdc_ex2_boundary,                  
output logic                                                lsdc_sq_ex2_boundary_first,            
output logic  [15:0]                                        lsdc_ex2_bytes_vld,                 
output logic                                                lsdc_ex2_chk_st_inst_vld,           
output logic                                                lsdc_ex2_chk_atomic_inst_vld,     
output logic                                                lsdc_sq_ex2_cmit0_iid_crt_hit,          
output logic                                                lsdc_sq_ex2_cmit1_iid_crt_hit,          
output logic                                                lsdc_sq_ex2_cmit2_iid_crt_hit,
output logic                                                lsdc_sq_ex2_cmit3_iid_crt_hit,          
output logic                                                lsdc_sq_ex2_cmit4_iid_crt_hit,          
output logic                                                lsdc_sq_ex2_cmit5_iid_crt_hit,
output logic                                                lsdc_sq_ex2_cmit6_iid_crt_hit,          
output logic                                                lsdc_sq_ex2_cmit7_iid_crt_hit,      
output logic  [15 :0]                                       lsdc_lsda_ex2_dcache_dirty_array,     //8->15 [16]deleted, L1D 2way->4way, LTL@20250321 
output logic  [`WK_LS_DCACHE_TAG_NOECC_WIDTH-1:0]           lsdc_lsda_ex2_dcache_tag_array,       //51->103, L1D 2way->4way, LTL@20250321 
output logic                                                lsdc_lsda_ex2_expt_vld_gate_en,       
output logic                                                lsdc_lsda_ex2_inst_vld,               
output logic                                                lsdc_ex2_page_buf,               
output logic                                                lsdc_ex2_page_ca,                
output logic                                                lsdc_ex2_page_sec,               
output logic                                                lsdc_ex2_page_share,             
output logic                                                lsdc_ex2_page_so,                
output logic                                                lsdc_ex2_page_wa,                
output logic                                                lsdc_lsda_ex2_staddr_vld,
output logic  [3 :0]                                        lsdc_ex2_hit_way, //newly add for rrip, LTL@20250401
output logic                                                lsdc_ex2_dcache_hit,    //newly add for rrip, LTL@20250401             
output logic                                                lsdc_lsda_ex2_tag0_hit,               
output logic                                                lsdc_lsda_ex2_tag1_hit,
output logic                                                lsdc_lsda_ex2_tag2_hit,   //L1D 2way->4way, LTL@20250321            
output logic                                                lsdc_lsda_ex2_tag3_hit,               
output logic                                                lsdc_lsda_ex2_dcwp_hit_idx,              
output logic                                                lsdc_sq_ex2_dtcm_hit,                  
output logic  [8 :0]                                        lsdc_lsda_ex2_element_cnt,               
output logic  [1 :0]                                        lsdc_sq_ex2_element_size,              
output logic                                                lsdc_lsda_ex2_expt_access_fault_extra,   
output logic                                                lsdc_lsda_ex2_expt_access_fault_mask,    
output logic  [4 :0]                                        lsdc_lsda_ex2_expt_vec,                  
output logic                                                lsdc_lsda_ex2_expt_vld_except_access_err,
output logic  [3 :0]                                        lsdc_ex2_fence_mode,                
output logic                                                lsdc_lsda_ex2_get_dcache_tag_dirty,      
output logic                                                lsdc_ex2_icc,                       
output logic  [LSIQ_ENTRY-1:0]                              lsdc_idu_ex2_sq_full,               
output logic  [LSIQ_ENTRY-1:0]                              lsdc_idu_ex2_tlb_busy,              
output logic                                                lsdc_sq_ex2_idx_order,                 
output logic  [IID_WIDTH-1:0]                               lsdc_ex2_iid,                       
output logic  [LSIQ_ENTRY-1:0]                              lsdc_ex2_imme_wakeup,               
output logic                                                lsdc_sq_ex2_inst_flush,                
output logic  [1 :0]                                        lsdc_ex2_inst_mode,                 
output logic  [2 :0]                                        lsdc_ex2_inst_size,                 
output logic  [1 :0]                                        lsdc_ex2_inst_type,                 
output logic                                                lsdc_ex2_inst_vld,                  
output logic                                                lsdc_ex2_inst_vls,                  
output logic                                                lsdc_sq_ex2_itcm_hit,                  
output logic  [LSIQ_ENTRY-1:0]                              lsdc_lsda_ex2_lsid,                      
output logic                                                lsdc_lsda_ex2_mmu_req,                   
output logic  [`WK_PA_WIDTH-1:0]                            lsdc_lsda_ex2_mt_value,                  
output logic  [1 :0]                                        lsdc_lsda_ex2_no_spec,                   
output logic                                                lsdc_ex2_old,                       
output logic  [PC_LEN-1:0]                                  lsdc_lsda_ex2_pc,         //parameterized by LTL@20241104                    
output logic  [PREG-1:0]                                    lsdc_ex2_preg,
output logic                                                lsdc_lsda_ex2_pf_inst,                   
output logic  [`WK_PA_WIDTH-1:0]                            lsdc_lsda_ex2_pfu_va,                    
output logic  [15:0]                                        lsdc_sq_ex2_rot_sel_rev,               
output logic  [SDID_LEN-1 :0]                               lsdc_sq_ex2_sdid,       //parameterized by LTL@20241021                
output logic                                                lsdc_sq_ex2_sdid_hit0,   //1->2, LTL@20241123
output logic                                                lsdc_sq_ex2_sdid_hit1,                   
output logic                                                lsdc_ex2_secd,                      
output logic                                                lsdc_lsda_ex2_spec_fail,                 
output logic                                                lsdc_lsda_ex2_split,                     
output logic                                                lsdc_sq_ex2_create_dp_vld,          
output logic                                                lsdc_sq_ex2_create_gateclk_en,      
output logic                                                lsdc_sq_ex2_create_vld,             
output logic                                                lsdc_sq_ex2_data_vld,               
output logic                                                lsdc_ex2_sq_full_gateclk_en,        
output logic                                                lsdc_lsda_ex2_st,                        
output logic                                                lsdc_ex2_sync_fence,                
output logic                                                lsdc_lsda_ex2_tag_inj_dp,                
output logic                                                lsdc_ex2_tlb_busy_gateclk_en,       
output logic                                                lsdc_lsda_ex2_vector_nop,                
//output logic  [1 :0]                                        lsdc_sq_ex2_vsew,     //rvv1.0@hcl  
output logic  [1 :0]  lsdc_sq_ex2_vmew,     //rvv1.0@hcl
output logic  [1 :0]  lsdc_sq_ex2_vmop,     //rvv1.0@hcl               
output logic                                                lsdc_sq_ex2_wo_st_inst,
//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
input  logic                                                dtu_lsu_addr_trig_en,
input  logic                                                dtu_lsu_data_trig_en,
output logic                                                st_dc_data_check
//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
);

               

// &Regs; @27
           
logic     [15:0]                                            st_dc_data_rot_sel;               
logic                                                       st_dc_expt_access_fault_with_page; 
logic                                                       st_dc_expt_illegal_inst;          
logic                                                       st_dc_expt_misalign_no_page;      
logic                                                       st_dc_expt_misalign_with_page;    
logic                                                       st_dc_expt_page_fault;            
logic                                                       st_dc_expt_stamo_not_ca;                                               
logic                                                       st_dc_lsfifo;                                               
logic                                                       st_dc_lsiq_spec_fail;                             
logic     [`WK_PA_WIDTH-1:0]                                st_dc_mt_value_ori;                                       
logic                                                       st_dc_page_buf;                   
logic                                                       st_dc_page_ca;                    
logic                                                       st_dc_page_sec;                   
logic                                                       st_dc_page_share;                 
logic                                                       st_dc_page_so;                    
logic                                                       st_dc_page_wa;                    
logic     [3 :0]                                            st_dc_rot_sel;                    
logic     [SDIQ_ENTRY-1:0]                                  st_dc_sdid_oh;                    
logic                                                       st_dc_staddr;                     
logic                                                       st_dc_tlb_busy;                   
logic                                                       st_dc_tlb_imme_wakeup; // wjh@tmq full, mrg-on-cmplt
logic                                                       st_dc_utlb_miss;                  
logic     [`WK_PA_WIDTH-12:0]                               st_dc_vpn;                        
// &Wires; @28              
logic                                                       rtu_ck_flush_iid_older_than_ex1_iid;
logic                                                       rtu_ck_flush_iid_older_than_ex2_iid;                
logic                                                       st_dc_borrow_clk;                 
logic                                                       st_dc_borrow_clk_en;              
logic                                                       st_dc_clk;                        
logic                                                       st_dc_clk_en;                           
logic                                                       st_dc_dcache_1line_inst;          
logic                                                       st_dc_dcache_all_inst;            
logic                                                       st_dc_dcache_inst;                
logic                                                       st_dc_dcache_pa_sw_inst;          
logic                                                       st_dc_dcache_pa_sw_page_ca;       
logic                                                       st_dc_default_page;               
logic                                                       st_dc_expt_access_fault_short;    
logic                                                       st_dc_expt_illegal_inst_clk;      
logic                                                       st_dc_expt_illegal_inst_clk_en;   
logic                                                       st_dc_fence_inst;                 
logic                                                       st_dc_fence_nop_inst;                       
logic                                                       st_dc_icache_all_inst;            
logic                                                       st_dc_icache_inst;                
logic                                                       st_dc_icc_inst;                   
logic                                                       st_dc_imme_restart_vld;                       
logic                                                       st_dc_inst_clk;                   
logic                                                       st_dc_inst_clk_en;                
logic                                                       st_dc_l2cache_inst;               
logic    [LSIQ_ENTRY-1:0]                                   st_dc_mask_lsid;       //para  LTL@20241021                  
logic    [7 :0]                                             st_dc_pfu_va_11to4;                           
logic                                                       st_dc_restart_vld;                    
logic                                                       st_dc_sq_full_vld; 
logic                                                       st_dc_st_inst;
logic                                                       st_dc_sync_inst;
logic                                                       st_dc_tlb_busy_restart_vld;       
logic                                                       st_dc_tlbi_inst;
logic                                                       st_dc_utlb_miss_vld;
logic    [`WK_PA_WIDTH-1:0]                                 st_dc_va;      

//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
logic                                                       st_dc_sc_inst;
//==========================================================
//                  Risc-V Debug zdb End 
//==========================================================

parameter S_BYTE        = 3'b000,
          HALF        = 3'b001,
          WORD        = 3'b010,
          DWORD       = 3'b011;

//parameter LSIQ_ENTRY  = 12;   //defined in front, 
//parameter SNQ_ENTRY   = 6;  
//parameter PC_LEN      = 15;

//==========================================================
//                 Instance of Gated Cell  
//==========================================================
assign st_dc_clk_en = lsag_ex1_inst_vld
                      ||  dcache_arb_lsdc_borrow_vld_gate;
// &Instance("gated_clk_cell", "x_lsu_st_dc_gated_clk"); @44
gated_clk_cell  x_lsu_st_dc_gated_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (st_dc_clk         ),
  .external_en        (1'b0              ),
  .local_en           (st_dc_clk_en      ),
  .module_en          (cp0_lsu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect(.clk_in        (forever_cpuclk     ), @45
//          .external_en   (1'b0               ), @46
//          .module_en     (cp0_lsu_icg_en     ), @47
//          .local_en      (st_dc_clk_en       ), @48
//          .clk_out       (st_dc_clk          )); @49

assign st_dc_inst_clk_en = lsag_ex1_inst_vld;
// &Instance("gated_clk_cell", "x_lsu_st_dc_inst_gated_clk"); @52
gated_clk_cell  x_lsu_st_dc_inst_gated_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (st_dc_inst_clk    ),
  .external_en        (1'b0              ),
  .local_en           (st_dc_inst_clk_en ),
  .module_en          (cp0_lsu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect(.clk_in        (forever_cpuclk     ), @53
//          .external_en   (1'b0               ), @54
//          .module_en     (cp0_lsu_icg_en     ), @55
//          .local_en      (st_dc_inst_clk_en  ), @56
//          .clk_out       (st_dc_inst_clk     )); @57

//-----------------------borrow clk-------------------------
assign st_dc_borrow_clk_en = dcache_arb_lsdc_borrow_vld_gate;
// &Instance("gated_clk_cell", "x_lsu_st_dc_borrow_gated_clk"); @61
gated_clk_cell  x_lsu_st_dc_borrow_gated_clk (
  .clk_in              (forever_cpuclk     ),
  .clk_out             (st_dc_borrow_clk   ),
  .external_en         (1'b0               ),
  .local_en            (st_dc_borrow_clk_en),
  .module_en           (cp0_lsu_icg_en     ),
  .pad_yy_icg_scan_en  (pad_yy_icg_scan_en )
);

// &Connect(.clk_in        (forever_cpuclk     ), @62
//          .external_en   (1'b0               ), @63
//          .module_en     (cp0_lsu_icg_en     ), @64
//          .local_en      (st_dc_borrow_clk_en), @65
//          .clk_out       (st_dc_borrow_clk   )); @66

//-----------------------expt clk---------------------------
//for saving register,misalign and illegal have been selected in ag stage
assign st_dc_expt_illegal_inst_clk_en = lsag_ex1_inst_vld
                                        &&  (lsag_lsdc_ex1_expt_illegal_inst
                                             || lsag_lsdc_ex1_expt_misalign_no_page);
// &Instance("gated_clk_cell", "x_lsu_st_dc_expt_illegal_inst_gated_clk"); @73
gated_clk_cell  x_lsu_st_dc_expt_illegal_inst_gated_clk (
  .clk_in                         (forever_cpuclk                ),
  .clk_out                        (st_dc_expt_illegal_inst_clk   ),
  .external_en                    (1'b0                          ),
  .local_en                       (st_dc_expt_illegal_inst_clk_en),
  .module_en                      (cp0_lsu_icg_en                ),
  .pad_yy_icg_scan_en             (pad_yy_icg_scan_en            )
);

// &Connect(.clk_in        (forever_cpuclk     ), @74
//          .external_en   (1'b0               ), @75
//          .module_en     (cp0_lsu_icg_en     ), @76
//          .local_en      (st_dc_expt_illegal_inst_clk_en), @77
//          .clk_out       (st_dc_expt_illegal_inst_clk)); @78

//==========================================================
//                 Pipeline Register
//==========================================================
//------------------control part----------------------------
//+----------+------------+
//| inst_vld | borrow_vld |
//+----------+------------+
//inst vld is used for sq_entry pop sel signal
// &Force("output","lsdc_ex2_inst_vld"); @88
always @(posedge ctrl_st_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    lsdc_ex2_inst_vld        <=  1'b0;
  else if(rtu_lsu_flush_fe)
    lsdc_ex2_inst_vld        <=  1'b0;
  else if(rtu_ck_flush && rtu_ck_flush_iid_older_than_ex1_iid)    //flush younger ex1->ex2 inst_vld, ck_flush@LTL
  begin
    lsdc_ex2_inst_vld        <=  1'b0;
  end  
  else if(lsag_lsdc_ex1_inst_vld)
    lsdc_ex2_inst_vld        <=  1'b1;
  else
    lsdc_ex2_inst_vld        <=  1'b0;
end

// &Force("output","lsdc_ex2_borrow_vld"); @101
always @(posedge ctrl_st_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    lsdc_ex2_borrow_vld      <=  1'b0;
  else if(dcache_arb_lsdc_borrow_vld)
    lsdc_ex2_borrow_vld      <=  1'b1;
  else
    lsdc_ex2_borrow_vld      <=  1'b0;
end

//------------------expt part-------------------------------
//+--------------+-------+----------+--------+------+------+---------+-----+
//| illegal_inst | tmiss | misalign | tfatal | tmod | deny | rd_tinv | vpn |
//+--------------+-------+----------+--------+------+------+---------+-----+
// &Force("output","lsdc_lsda_ex2_mmu_req"); @116
always @(posedge st_dc_inst_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    lsdc_lsda_ex2_mmu_req             <=  1'b0;
    st_dc_expt_illegal_inst           <=  1'b0;
    st_dc_expt_misalign_no_page       <=  1'b0;
    //st_dc_expt_access_fault         <=  1'b0;
    st_dc_expt_page_fault             <=  1'b0;
    st_dc_expt_misalign_with_page     <=  1'b0;
    st_dc_expt_access_fault_with_page <=  1'b0;
    st_dc_expt_stamo_not_ca           <=  1'b0;
  end
  else if(lsag_ex1_inst_vld)
  begin
    lsdc_lsda_ex2_mmu_req             <=  lsag_lsdc_ex1_mmu_req;
    st_dc_expt_illegal_inst           <=  lsag_lsdc_ex1_expt_illegal_inst;
    st_dc_expt_misalign_no_page       <=  lsag_lsdc_ex1_expt_misalign_no_page;
    //st_dc_expt_access_fault         <=  st_ag_expt_access_fault;
    st_dc_expt_page_fault             <=  lsag_lsdc_ex1_expt_page_fault;
    st_dc_expt_misalign_with_page     <=  lsag_lsdc_ex1_expt_misalign_with_page;
    st_dc_expt_access_fault_with_page <=  lsag_lsdc_ex1_expt_access_fault_with_page;
    st_dc_expt_stamo_not_ca           <=  lsag_lsdc_ex1_expt_amo_not_ca;
  end
end

always @(posedge st_dc_expt_illegal_inst_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    st_dc_mt_value_ori[`WK_PA_WIDTH-1:0]   <= {`WK_PA_WIDTH{1'b0}};
  else if(lsag_ex1_inst_vld  &&  (lsag_lsdc_ex1_expt_illegal_inst || lsag_lsdc_ex1_expt_misalign_no_page))
    st_dc_mt_value_ori[`WK_PA_WIDTH-1:0]   <= lsag_lsdc_ex1_mt_value[`WK_PA_WIDTH-1:0];
end

//------------------borrow part-----------------------------
//+-----+------+-----+
//| rcl | sndb | mmu |
//+-----+------+-----+
always @(posedge st_dc_borrow_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    lsdc_lsda_ex2_borrow_dcache_replace         <=  1'b0;
    lsdc_lsda_ex2_borrow_dcache_sw              <=  2'b0;
    lsdc_lsda_ex2_borrow_snq                    <=  1'b0;
    lsdc_lsda_ex2_borrow_icc                    <=  1'b0;
    lsdc_lsda_ex2_borrow_snq_id[SNQ_ENTRY-1:0]  <=  {SNQ_ENTRY{1'b0}};
  end
  else if(dcache_arb_lsdc_borrow_vld)
  begin
    lsdc_lsda_ex2_borrow_dcache_replace         <=  dcache_arb_lsdc_dcache_replace;
    lsdc_lsda_ex2_borrow_dcache_sw              <=  dcache_arb_lsdc_ex1_dcache_sw;
    lsdc_lsda_ex2_borrow_snq                    <=  dcache_arb_lsdc_borrow_snq;
    lsdc_lsda_ex2_borrow_icc                    <=  dcache_arb_lsdc_borrow_icc;
    lsdc_lsda_ex2_borrow_snq_id[SNQ_ENTRY-1:0]  <=  dcache_arb_lsdc_borrow_snq_id[SNQ_ENTRY-1:0];
  end
end

//------------------inst part----------------------------
//+----------+-----+----+-----------+-----------+-----------+
//| sync_fence | icc | ex | inst_type | inst_size | inst_mode |
//+----------+-----+----+-----------+-----------+-----------+
//+------+------------+----------+-------+-------+------------+
//| secd | already_da | spec_fail| bkpta | bkptb | inst_flush |
//+------+------------+----------+-------+-------+------------+
//+----+-----+------+-----+------------+------------+
//| ex | iid | lsid | old | bytes_vld0 | bytes_vld1 |
//+----+-----+------+-----+------------+------------+
//+--------+----------+-------+
//| deform | boundary | split |
//+--------+----------+-------+
//+----+----+----+-----+-----+-------+
//| so | ca | wa | buf | sec | share |
//+----+----+----+-----+-----+-------+
// &Force("output","lsdc_ex2_sync_fence"); @191
// &Force("output","lsdc_ex2_icc"); @192
// &Force("output","lsdc_ex2_inst_type"); @193
// &Force("output","lsdc_ex2_inst_size"); @194
// &Force("output","lsdc_ex2_inst_mode"); @195
// &Force("output","lsdc_ex2_secd"); @196
// &Force("output","lsdc_lsda_ex2_already_da"); @197
// &Force("output","lsdc_ex2_atomic"); @198
// &Force("output","lsdc_ex2_iid"); @199
// &Force("output","lsdc_lsda_ex2_lsid"); @200
// &Force("output","lsdc_ex2_bytes_vld"); @201
// &Force("output","lsdc_lsda_ex2_st"); @202
// &Force("output","lsdc_ex2_boundary"); @203
// &Force("output","lsdc_lsda_ex2_expt_vld_except_access_err"); @204
// &Force("output","lsdc_lsda_ex2_split"); @205
// &Force("output","lsdc_lsda_ex2_pc"); @206
// &Force("output","lsdc_ex2_fence_mode"); @207
//boundary signal is not accurate if there is an exception
always @(posedge st_dc_inst_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    lsdc_ex2_is_load                              <=  1'b0;
    lsdc_lsda_ex2_expt_vld_except_access_err      <=  1'b0;
    st_dc_vpn[`WK_PA_WIDTH-13:0]                   <=  {`WK_PA_WIDTH-12{1'b0}};
    lsdc_lsda_ex2_split                           <=  1'b0;
    lsdc_ex2_sync_fence                           <=  1'b0;
    lsdc_ex2_fence_mode[3:0]                      <=  4'b0;
    lsdc_ex2_icc                                  <=  1'b0;
    lsdc_sq_ex2_inst_flush                        <=  1'b0;
    lsdc_ex2_inst_type[1:0]                       <=  2'b0;
    lsdc_ex2_inst_size[2:0]                       <=  3'b0;
    lsdc_ex2_inst_mode[1:0]                       <=  2'b0;
    lsdc_lsda_ex2_st                              <=  1'b0;
    lsdc_ex2_secd                                 <=  1'b0;
    lsdc_lsda_ex2_already_da                      <=  1'b0;
    st_dc_lsiq_spec_fail                          <=  1'b0;
    lsdc_ex2_atomic                               <=  1'b0;
    lsdc_ex2_iid[IID_WIDTH-1:0]                   <=  {IID_WIDTH{1'b0}};  //parameterized, LTL@20241101
    lsdc_lsda_ex2_lsid[LSIQ_ENTRY-1:0]            <=  {LSIQ_ENTRY{1'b0}};
    st_dc_sdid_oh[SDIQ_ENTRY-1:0]                 <=  {SDIQ_ENTRY{1'b0}};
    lsdc_ex2_old                                  <=  1'b0;
    lsdc_ex2_bytes_vld[15:0]                      <=  16'b0;
    st_dc_rot_sel[3:0]                            <=  4'b0;
    lsdc_ex2_boundary                             <=  1'b0;
    st_dc_page_so                                 <=  1'b0;
    st_dc_page_ca                                 <=  1'b0;
    st_dc_page_wa                                 <=  1'b0;
    st_dc_page_buf                                <=  1'b0;
    st_dc_page_sec                                <=  1'b0;
    st_dc_page_share                              <=  1'b0;
    st_dc_utlb_miss                               <=  1'b0;
    st_dc_tlb_busy                                <=  1'b0;
    st_dc_tlb_imme_wakeup                         <=  1'b0; // wjh@tmq full, mrg-on-cmplt
    lsdc_lsda_ex2_no_spec[1:0]                    <=  2'b0;
    st_dc_staddr                                  <=  1'b0;
    lsdc_lsda_ex2_pc[PC_LEN-1:0]                  <=  {PC_LEN{1'b0}};
    lsdc_ex2_preg[PREG-1:0]                       <=  {PREG{1'b0}};
    st_dc_lsfifo                                  <=  1'b0;
    lsdc_ex2_inst_vls                             <=  1'b0;
    lsdc_lsda_ex2_element_cnt[8:0]                <=  9'b0;
    lsdc_sq_ex2_element_size[1:0]                 <=  2'b0;
    //lsdc_sq_ex2_vsew[1:0]                         <=  2'b0;//rvv1.0@hcl
    lsdc_sq_ex2_vmew[1:0]                         <=  2'b0;//rvv1.0@hcl
    lsdc_sq_ex2_vmop[1:0]                         <=  2'b0;//rvv1.0@hcl
    lsdc_sq_ex2_idx_order                         <=  1'b0;
    lsdc_sq_ex2_dtcm_hit                          <=  1'b0;
    lsdc_sq_ex2_itcm_hit                          <=  1'b0;
  end
  else if(lsag_ex1_inst_vld)
  begin
    lsdc_ex2_is_load                              <=  lsag_ex1_is_load;
    lsdc_lsda_ex2_expt_vld_except_access_err      <=  lsag_lsdc_ex1_expt_vld;
    st_dc_vpn[`WK_PA_WIDTH-13:0]                   <=  lsag_lsdc_ex1_vpn[`WK_PA_WIDTH-13:0];
    lsdc_lsda_ex2_split                           <=  lsag_lsdc_ex1_split;
    lsdc_ex2_sync_fence                           <=  lsag_lsdc_ex1_sync_fence;
    lsdc_ex2_fence_mode[3:0]                      <=  lsag_lsdc_ex1_fence_mode[3:0];
    lsdc_ex2_icc                                  <=  lsag_lsdc_ex1_icc;
    lsdc_sq_ex2_inst_flush                        <=  lsag_lsdc_ex1_inst_flush;
    lsdc_ex2_inst_type[1:0]                       <=  lsag_lsdc_ex1_inst_type[1:0];
    lsdc_ex2_inst_size[2:0]                       <=  lsag_ex1_access_size[2:0];
    lsdc_ex2_inst_mode[1:0]                       <=  lsag_lsdc_ex1_inst_mode[1:0];
    lsdc_lsda_ex2_st                              <=  lsag_lsdc_ex1_st;
    lsdc_ex2_secd                                 <=  lsag_lsdc_ex1_secd;
    lsdc_lsda_ex2_already_da                      <=  lsag_lsdc_ex1_already_da;
    st_dc_lsiq_spec_fail                          <=  lsag_lsdc_ex1_lsiq_spec_fail;
    lsdc_ex2_atomic                               <=  lsag_lsdc_ex1_atomic;
    lsdc_ex2_iid[IID_WIDTH-1:0]                   <=  lsag_ex1_iid[IID_WIDTH-1:0];
    lsdc_lsda_ex2_lsid[LSIQ_ENTRY-1:0]            <=  lsag_lsdc_ex1_lsid[LSIQ_ENTRY-1:0];
    st_dc_sdid_oh[SDIQ_ENTRY-1:0]                 <=  lsag_lsdc_ex1_sdiq_entry[SDIQ_ENTRY-1:0];
    lsdc_ex2_old                                  <=  lsag_lsdc_ex1_old;
    lsdc_ex2_bytes_vld[15:0]                      <=  lsag_lsdc_ex1_bytes_vld[15:0];
    st_dc_rot_sel[3:0]                            <=  lsag_lsdc_ex1_rot_sel[3:0];
    lsdc_ex2_boundary                             <=  lsag_lsdc_ex1_boundary;
    st_dc_page_so                                 <=  lsag_lsdc_ex1_page_so;
    st_dc_page_ca                                 <=  lsag_lsdc_ex1_page_ca;
    st_dc_page_wa                                 <=  lsag_lsdc_ex1_page_wa;
    st_dc_page_buf                                <=  lsag_lsdc_ex1_page_buf;
    st_dc_page_sec                                <=  lsag_lsdc_ex1_page_sec;
    st_dc_page_share                              <=  lsag_lsdc_ex1_page_share;
    st_dc_utlb_miss                               <=  lsag_lsdc_ex1_utlb_miss;
    st_dc_tlb_busy                                <=  mmu_lsu_tlb_busy;
    st_dc_tlb_imme_wakeup                         <=  mmu_lsu_imme_wakeup; // wjh@tmq full, mrg-on-cmplt
    lsdc_lsda_ex2_no_spec[1:0]                    <=  lsag_lsdc_ex1_no_spec[1:0];
    st_dc_staddr                                  <=  lsag_lsdc_ex1_staddr;
    lsdc_lsda_ex2_pc[PC_LEN-1:0]                  <=  lsag_lsdc_ex1_pc[PC_LEN-1:0];
    lsdc_ex2_preg[PREG-1:0]                       <=  lsag_lsdc_ex1_preg[PREG-1:0];
    st_dc_lsfifo                                  <=  lsag_lsdc_ex1_lsfifo;
    lsdc_ex2_inst_vls                             <=  lsag_lsdc_ex1_inst_vls;
    lsdc_lsda_ex2_element_cnt[8:0]                <=  lsag_lsdc_ex1_element_cnt[8:0];
    lsdc_sq_ex2_element_size[1:0]                 <=  lsag_lsdc_ex1_element_size[1:0];
    //lsdc_sq_ex2_vsew[1:0]                         <=  lsag_lsdc_ex1_vsew[1:0];//rvv1.0 @hcl
    lsdc_sq_ex2_vmew[1:0]                         <=  lsag_lsdc_ex1_vmew[1:0];//rvv1.0 @hcl
    lsdc_sq_ex2_vmop[1:0]                         <=  lsag_lsdc_ex1_vmop[1:0];//rvv1.0 @hcl
    lsdc_sq_ex2_idx_order                         <=  lsag_lsdc_ex1_idx_order;
    lsdc_sq_ex2_dtcm_hit                          <=  lsag_lsdc_ex1_dtcm_hit;
    lsdc_sq_ex2_itcm_hit                          <=  lsag_lsdc_ex1_itcm_hit;
  end
end
xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH)) 
x_lsu_ck_flush_compare_ex1_iid (
  .x_iid0                    (rtu_ck_flush_iid[IID_WIDTH-1:0]),
  .x_iid0_older              (rtu_ck_flush_iid_older_than_ex1_iid  ),
  .x_iid1                    (lsag_ex1_iid[IID_WIDTH-1:0]           )
);
xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH)) 
x_lsu_ck_flush_compare_ex2_iid (
  .x_iid0                    (rtu_ck_flush_iid[IID_WIDTH-1:0]),
  .x_iid0_older              (rtu_ck_flush_iid_older_than_ex2_iid  ),
  .x_iid1                    (lsdc_ex2_iid[IID_WIDTH-1:0]           )
);
//------------------inst/borrow share part------------------
//+-------+
//| addr0 |
//+-------+
// &Force("output","lsdc_ex2_addr0"); @319
always @(posedge st_dc_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    lsdc_ex2_addr0[`WK_PA_WIDTH-1:0]     <=  {`WK_PA_WIDTH{1'b0}};
  else if(lsag_ex1_inst_vld  ||  dcache_arb_lsdc_borrow_vld)
    lsdc_ex2_addr0[`WK_PA_WIDTH-1:0]     <=  lsag_lsdc_ex1_addr0[`WK_PA_WIDTH-1:0];
end

//==========================================================
//        Generate  va
//==========================================================
assign st_dc_va[`WK_PA_WIDTH-1:12] = st_dc_vpn[`WK_PA_WIDTH-13:0];
assign st_dc_va[11:4]           = lsdc_ex2_addr0[11:4];
assign st_dc_va[3:0]            = lsdc_ex2_secd
                                  ? 4'b0
                                  : lsdc_ex2_addr0[3:0];

// for preload addr check
//assign st_dc_pfu_va_11to4[7:0]      = lsdc_ex2_boundary  &&  !lsdc_ex2_secd
//                                      ? st_dc_addr1_11to4[7:0]
//                                      : lsdc_ex2_addr0[11:4];
//first unalign st inst use small addr                                      
assign st_dc_pfu_va_11to4[7:0]      = lsdc_ex2_addr0[11:4];                                      
//if this inst cross 4k, this va is not accurate
assign lsdc_lsda_ex2_pfu_va[`WK_PA_WIDTH-1:0]  = {st_dc_vpn[`WK_PA_WIDTH-13:0],
                                      st_dc_pfu_va_11to4[7:0],
                                      lsdc_ex2_addr0[3:0]};

//Generage pfu signal
assign lsdc_lsda_ex2_pf_inst = lsdc_ex2_inst_vld
                       && st_dc_st_inst
                       && !lsdc_lsda_ex2_vector_nop
                       && st_dc_lsfifo
                       && st_dc_page_ca
                       && cp0_lsu_l2_st_pref_en
                       && !lsdc_lsda_ex2_split
                       && !lsdc_ex2_secd;
//==========================================================
//        Exception generate
//==========================================================
assign lsdc_lsda_ex2_expt_access_fault_mask   = st_dc_expt_misalign_no_page
                                        ||  st_dc_expt_page_fault
                                        ||  st_dc_expt_illegal_inst
                                        ||  st_dc_icc_inst;

assign lsdc_lsda_ex2_expt_access_fault_extra  = lsdc_lsda_ex2_mmu_req
                                        &&  st_dc_expt_stamo_not_ca;

assign st_dc_expt_access_fault_short  = lsdc_lsda_ex2_mmu_req;
//if utlb_miss and dmmu expt,
//then lsdc_lsda_ex2_expt_vld_except_access_err is 0,
//but st_dc_da_expt_vld is not certain
assign lsdc_lsda_ex2_expt_vld_gate_en  = lsdc_lsda_ex2_expt_vld_except_access_err
                                    ||  st_dc_expt_access_fault_short
//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
                                    ||  dtu_lsu_addr_trig_en
                                    ||  st_dc_tlbi_inst;
//==========================================================
//                  Risc-V Debug zdb End 
//==========================================================

// &CombBeg; @375
always @( st_dc_expt_misalign_with_page
       or st_dc_expt_access_fault_with_page
       or st_dc_mt_value_ori[`WK_PA_WIDTH-1:0]
       or st_dc_expt_page_fault
       or lsdc_lsda_ex2_st
       or st_dc_expt_misalign_no_page
       or st_dc_va[`WK_PA_WIDTH-1:0]
       or lsdc_lsda_ex2_expt_vld_except_access_err
       or st_dc_expt_illegal_inst)
begin
lsdc_lsda_ex2_expt_vec[4:0]   = 5'b0;
lsdc_lsda_ex2_mt_value[`WK_PA_WIDTH-1:0]  = {`WK_PA_WIDTH{1'b0}};
if(st_dc_expt_illegal_inst)
begin
  lsdc_lsda_ex2_expt_vec[4:0]   = 5'd2;
  lsdc_lsda_ex2_mt_value[`WK_PA_WIDTH-1:0]  = st_dc_mt_value_ori[`WK_PA_WIDTH-1:0];
end
else if(st_dc_expt_misalign_no_page)
begin
  lsdc_lsda_ex2_expt_vec[4:0]   = 5'd6;
  lsdc_lsda_ex2_mt_value[`WK_PA_WIDTH-1:0]  = st_dc_mt_value_ori[`WK_PA_WIDTH-1:0];
end
else if(st_dc_expt_page_fault &&  !lsdc_lsda_ex2_st)
begin
  lsdc_lsda_ex2_expt_vec[4:0]   = 5'd13;
  lsdc_lsda_ex2_mt_value[`WK_PA_WIDTH-1:0]  = st_dc_va[`WK_PA_WIDTH-1:0];
end
else if(st_dc_expt_page_fault &&  lsdc_lsda_ex2_st)
begin
  lsdc_lsda_ex2_expt_vec[4:0] = 5'd15;
  lsdc_lsda_ex2_mt_value[`WK_PA_WIDTH-1:0]  = st_dc_va[`WK_PA_WIDTH-1:0];
end
else if(st_dc_expt_misalign_with_page)
begin
  lsdc_lsda_ex2_expt_vec[4:0] = 5'd6;
  lsdc_lsda_ex2_mt_value[`WK_PA_WIDTH-1:0]  = st_dc_va[`WK_PA_WIDTH-1:0];
end
else if(st_dc_expt_access_fault_with_page)
begin
  lsdc_lsda_ex2_expt_vec[4:0] = 5'd7;
  lsdc_lsda_ex2_mt_value[`WK_PA_WIDTH-1:0]  = {`WK_PA_WIDTH{1'b0}};
end
else if(lsdc_lsda_ex2_expt_vld_except_access_err && !lsdc_lsda_ex2_st)begin 
  lsdc_lsda_ex2_expt_vec[4:0] = 5'd5;
  lsdc_lsda_ex2_mt_value[WK_PA_WIDTH-1:0]  = {WK_PA_WIDTH{1'b0}};
end
else if(lsdc_lsda_ex2_expt_vld_except_access_err && lsdc_lsda_ex2_st)begin 
  lsdc_lsda_ex2_expt_vec[4:0] = 5'd7;
  lsdc_lsda_ex2_mt_value[WK_PA_WIDTH-1:0]  = {WK_PA_WIDTH{1'b0}};
end
// &CombEnd @408
end

//==========================================================
//                  get commit hit signal
//==========================================================
assign lsdc_sq_ex2_cmit0_iid_crt_hit  = rtu_lsu_commit0_iid_updt_val[IID_WIDTH-1:0] == lsdc_ex2_iid[IID_WIDTH-1:0];
assign lsdc_sq_ex2_cmit1_iid_crt_hit  = rtu_lsu_commit1_iid_updt_val[IID_WIDTH-1:0] == lsdc_ex2_iid[IID_WIDTH-1:0];
assign lsdc_sq_ex2_cmit2_iid_crt_hit  = rtu_lsu_commit2_iid_updt_val[IID_WIDTH-1:0] == lsdc_ex2_iid[IID_WIDTH-1:0];
assign lsdc_sq_ex2_cmit3_iid_crt_hit  = rtu_lsu_commit3_iid_updt_val[IID_WIDTH-1:0] == lsdc_ex2_iid[IID_WIDTH-1:0];
assign lsdc_sq_ex2_cmit4_iid_crt_hit  = rtu_lsu_commit4_iid_updt_val[IID_WIDTH-1:0] == lsdc_ex2_iid[IID_WIDTH-1:0];
assign lsdc_sq_ex2_cmit5_iid_crt_hit  = rtu_lsu_commit5_iid_updt_val[IID_WIDTH-1:0] == lsdc_ex2_iid[IID_WIDTH-1:0];
assign lsdc_sq_ex2_cmit6_iid_crt_hit  = rtu_lsu_commit6_iid_updt_val[IID_WIDTH-1:0] == lsdc_ex2_iid[IID_WIDTH-1:0];
assign lsdc_sq_ex2_cmit7_iid_crt_hit  = rtu_lsu_commit7_iid_updt_val[IID_WIDTH-1:0] == lsdc_ex2_iid[IID_WIDTH-1:0];
//==========================================================
//                      encode sdid
//==========================================================
//encode sdid to create lq signal
// &Force("output","lsdc_sq_ex2_sdid"); @421
//assign lsdc_sq_ex2_sdid[SDID_LEN-1:0]  = {4{st_dc_sdid_oh[0]}} & 4'd0
//                          | {4{st_dc_sdid_oh[1]}} & 4'd1
//                          | {4{st_dc_sdid_oh[2]}} & 4'd2
//                          | {4{st_dc_sdid_oh[3]}} & 4'd3
//                          | {4{st_dc_sdid_oh[4]}} & 4'd4
//                          | {4{st_dc_sdid_oh[5]}} & 4'd5
//                          | {4{st_dc_sdid_oh[6]}} & 4'd6
//                          | {4{st_dc_sdid_oh[7]}} & 4'd7
//                          | {4{st_dc_sdid_oh[8]}} & 4'd8
//                          | {4{st_dc_sdid_oh[9]}} & 4'd9
//                          | {4{st_dc_sdid_oh[10]}} & 4'd10
//                          | {4{st_dc_sdid_oh[11]}} & 4'd11;

always_comb begin                             //parameterized by LTL@20241021
    lsdc_sq_ex2_sdid[SDID_LEN-1:0] = {SDID_LEN{1'b0}};  
    for(int i=1; i<SDIQ_ENTRY; i++) begin   //0=0000, begin from 1 is also okay, LTL@20241101
        if(st_dc_sdid_oh[i] == 1'b1) begin
          lsdc_sq_ex2_sdid[SDID_LEN-1:0] = i;
        end
    end 
end 

assign lsdc_sq_ex2_sdid_hit0   = (lsdc_sq_ex2_sdid[SDID_LEN-1:0] ==  std0_rf_sdid[SDID_LEN-1:0]);  //1->2, for lsdc and std0 and std 1, parameterized by LTL@20241021
assign lsdc_sq_ex2_sdid_hit1   = (lsdc_sq_ex2_sdid[SDID_LEN-1:0] ==  std1_rf_sdid[SDID_LEN-1:0]);
//==========================================================
//        Generate inst type
//==========================================================
// &Force("output","lsdc_lsda_ex2_vector_nop"); @439
//for masked element,treat it as nop
assign lsdc_lsda_ex2_vector_nop = (st_dc_st_inst || lsdc_ex2_atomic)
                          && !(|lsdc_ex2_bytes_vld[15:0]); 

//st/str/push/srs is treated as st inst
assign st_dc_sync_inst          = lsdc_ex2_sync_fence
                                  &&  !lsdc_ex2_atomic
                                  &&  (lsdc_ex2_inst_type[1:0]  ==  2'b00);
assign st_dc_fence_inst         = lsdc_ex2_sync_fence
                                  &&  !lsdc_ex2_atomic
                                  &&  (lsdc_ex2_inst_type[1:0]  ==  2'b01);
assign st_dc_icc_inst           = lsdc_ex2_icc
                                  &&  !lsdc_ex2_atomic;
assign st_dc_tlbi_inst          = st_dc_icc_inst
                                  &&  (lsdc_ex2_inst_type[1:0]  ==  2'b00);
//assign st_dc_tlbi_has_asid_inst = st_dc_tlbi_inst
//                                  &&  lsdc_ex2_inst_mode[0];
assign st_dc_icache_inst        = st_dc_icc_inst
                                  &&  (lsdc_ex2_inst_type[1:0]  ==  2'b01);
assign st_dc_dcache_inst        = st_dc_icc_inst
                                  &&  (lsdc_ex2_inst_type[1:0]  ==  2'b10);
assign st_dc_l2cache_inst       = st_dc_icc_inst
                                  &&  (lsdc_ex2_inst_type[1:0]  ==  2'b11);
assign st_dc_st_inst            = !lsdc_ex2_icc
                                  &&  !lsdc_ex2_atomic
                                  &&  !lsdc_ex2_sync_fence
                                  &&  (lsdc_ex2_inst_type[1:0]  ==  2'b00);
assign lsdc_sq_ex2_wo_st_inst         = st_dc_st_inst
                                  &&  !st_dc_page_so;

assign st_dc_dcache_all_inst    = st_dc_dcache_inst
                                  &&  (lsdc_ex2_inst_mode[1:0]  ==  2'b00);

assign st_dc_dcache_1line_inst  = st_dc_dcache_inst
                                  &&  (lsdc_ex2_inst_mode[1:0]  !=  2'b00);

assign st_dc_dcache_pa_sw_inst  = st_dc_dcache_inst
                                  &&  lsdc_ex2_inst_mode[1];

assign st_dc_icache_all_inst    = st_dc_icache_inst
                                  &&  (lsdc_ex2_inst_mode[1:0]  ==  2'b00);

//lignt fence inst, treated as nop
assign st_dc_fence_nop_inst = st_dc_fence_inst
                              && (lsdc_ex2_fence_mode[3:0] == 4'b0011);
//==========================================================
//                 Create load queue
//==========================================================
//lq_create_vld is not accurate, comparing iid is a must precedure to create lq
//----------------create signal-----------------------------
// &Force("output","lsdc_sq_ex2_create_vld"); @494
assign lsdc_sq_ex2_create_vld          = lsdc_ex2_inst_vld
                                      &&  !lsdc_lsda_ex2_vector_nop
                                      &&  !st_dc_fence_nop_inst
                                      &&  !sq_lsdc_ex2_inst_hit
                                      &&  !st_dc_utlb_miss
                                      &&  !lsdc_lsda_ex2_expt_vld_except_access_err;
// &Force("output","lsdc_sq_ex2_create_dp_vld"); @501
assign lsdc_sq_ex2_create_dp_vld       = lsdc_sq_ex2_create_vld;
// &Force("output","lsdc_sq_ex2_create_gateclk_en"); @503
assign lsdc_sq_ex2_create_gateclk_en   = lsdc_sq_ex2_create_dp_vld;


// &Force("output","lsdc_sq_ex2_data_vld"); @507
assign lsdc_sq_ex2_data_vld            = lsdc_ex2_inst_vld
                                      &&  !st_dc_staddr;
//----------------success signal----------------------------
// &Force("output","lsdc_sq_ex2_boundary_first"); @511
assign lsdc_sq_ex2_boundary_first         = lsdc_ex2_boundary  &&  !lsdc_ex2_secd;
//==========================================================
//        Generate check signal to lq/ld_dc stage
//==========================================================
assign lsdc_ex2_chk_st_inst_vld        = lsdc_ex2_inst_vld
                                      &&  st_dc_st_inst
                                      &&  !lsdc_lsda_ex2_vector_nop
                                      &&  !lsdc_lsda_ex2_expt_vld_except_access_err
                                      &&  !st_dc_utlb_miss
                                      &&  !st_dc_page_so;
assign lsdc_ex2_chk_atomic_inst_vld  = lsdc_ex2_inst_vld
                                      &&  lsdc_ex2_atomic
                                      &&  !lsdc_lsda_ex2_vector_nop
                                      &&  !lsdc_lsda_ex2_expt_vld_except_access_err
                                      &&  !st_dc_utlb_miss
                                      &&  !st_dc_page_so;

//------------------data pre_select----------------
// &CombBeg;    @531
always @( st_dc_rot_sel[3:0])
begin
casez(st_dc_rot_sel[3:0])                                 //casez cannot ->case, LTL@20241021
  4'h0:st_dc_data_rot_sel[15:0]  = 16'b0000000000000001;
  4'h1:st_dc_data_rot_sel[15:0]  = 16'b0000000000000010;
  4'h2:st_dc_data_rot_sel[15:0]  = 16'b0000000000000100;
  4'h3:st_dc_data_rot_sel[15:0]  = 16'b0000000000001000;
  4'h4:st_dc_data_rot_sel[15:0]  = 16'b0000000000010000;
  4'h5:st_dc_data_rot_sel[15:0]  = 16'b0000000000100000;
  4'h6:st_dc_data_rot_sel[15:0]  = 16'b0000000001000000;
  4'h7:st_dc_data_rot_sel[15:0]  = 16'b0000000010000000;
  4'h8:st_dc_data_rot_sel[15:0]  = 16'b0000000100000000;
  4'h9:st_dc_data_rot_sel[15:0]  = 16'b0000001000000000;
  4'ha:st_dc_data_rot_sel[15:0]  = 16'b0000010000000000;
  4'hb:st_dc_data_rot_sel[15:0]  = 16'b0000100000000000;
  4'hc:st_dc_data_rot_sel[15:0]  = 16'b0001000000000000;
  4'hd:st_dc_data_rot_sel[15:0]  = 16'b0010000000000000;
  4'he:st_dc_data_rot_sel[15:0]  = 16'b0100000000000000;
  4'hf:st_dc_data_rot_sel[15:0]  = 16'b1000000000000000;
  default:st_dc_data_rot_sel[15:0]  = {16{1'bx}};
endcase
// &CombEnd; @551
end
assign lsdc_sq_ex2_rot_sel_rev[15:0]  = {st_dc_data_rot_sel[1],
                                   st_dc_data_rot_sel[2],
                                   st_dc_data_rot_sel[3],
                                   st_dc_data_rot_sel[4],
                                   st_dc_data_rot_sel[5],
                                   st_dc_data_rot_sel[6],
                                   st_dc_data_rot_sel[7],
                                   st_dc_data_rot_sel[8],
                                   st_dc_data_rot_sel[9],
                                   st_dc_data_rot_sel[10],
                                   st_dc_data_rot_sel[11],
                                   st_dc_data_rot_sel[12],
                                   st_dc_data_rot_sel[13],
                                   st_dc_data_rot_sel[14],
                                   st_dc_data_rot_sel[15],
                                   st_dc_data_rot_sel[0]};
// &CombBeg;    @569
// &CombEnd; @581

//==========================================================
//        Compare cache write port
//==========================================================
// &Force("output","lsdc_lsda_ex2_dcwp_hit_idx"); @596
// &Force("input","dcache_lsdc_idx"); @597
// &Force("bus","dcache_lsdc_idx","8","0"); @598
// &Force("input","dcache_lsdc_dirty_gwen"); @599
//csky vperl_off
`ifdef WK_DCACHE_32K
assign lsdc_lsda_ex2_dcwp_hit_idx = dcache_lsdc_dirty_gwen
                            &&  (lsdc_ex2_addr0[13:6]  ==  dcache_lsdc_idx[7:0]);
`endif //DCACHE_32K
`ifdef WK_DCACHE_64K
assign lsdc_lsda_ex2_dcwp_hit_idx = dcache_lsdc_dirty_gwen
                            &&  (lsdc_ex2_addr0[13:6]  ==  dcache_lsdc_idx[7:0]);  //8->7  14->13, L1D 2way->4way, LTL@20250321 
`endif //DCACHE_64K
//csky vperl_on

//==========================================================
//                 Restart signal
//==========================================================
//-----------arbiter----------------------------------------
//prioritize:
//1. utlb_miss(include tlb_busy)
//2. sq_full

assign st_dc_utlb_miss_vld    = lsdc_ex2_inst_vld
                                &&  !lsdc_lsda_ex2_expt_vld_except_access_err
                                &&  st_dc_utlb_miss;
assign st_dc_sq_full_vld      = !st_dc_utlb_miss
                                &&  lsdc_sq_ex2_create_dp_vld &&  sq_lsdc_ex2_full;
assign lsdc_ex2_sq_full_gateclk_en = lsdc_sq_ex2_create_gateclk_en
                                  &&  sq_lsdc_ex2_full;

assign st_dc_restart_vld      = st_dc_sq_full_vld
                                ||  st_dc_utlb_miss_vld;

//---------------------restart kinds------------------------
// assign st_dc_imme_restart_vld = st_dc_utlb_miss_vld
//                                 &&  !st_dc_tlb_busy;

// assign st_dc_tlb_busy_restart_vld = st_dc_utlb_miss_vld
//                                     &&  st_dc_tlb_busy;
assign st_dc_imme_restart_vld = st_dc_tlb_imme_wakeup; // wjh@tmq full, mrg-on-cmplt, hidden condition is utlb-miss
assign st_dc_tlb_busy_restart_vld = 1'b0;// wjh@tmq
assign lsdc_ex2_tlb_busy_gateclk_en  = st_dc_tlb_busy_restart_vld;

//==========================================================
//        Combine signal of spec_fail
//==========================================================
assign lsdc_lsda_ex2_spec_fail            = lq_lsdc_ex2_spec_fail
                                    ||  st_dc_lsiq_spec_fail;

//==========================================================
//            Generage get dcache signal
//==========================================================
assign lsdc_lsda_ex2_get_dcache_tag_dirty = lsdc_ex2_inst_vld
                                        &&  !lsdc_lsda_ex2_vector_nop
                                        &&  !st_dc_utlb_miss
                                        &&  (st_dc_st_inst
                                            ||  lsdc_ex2_atomic
                                            ||  st_dc_dcache_1line_inst)
                                        &&  (st_dc_page_ca
                                            ||  st_dc_dcache_pa_sw_inst)
                                        &&  cp0_lsu_dcache_en
                                        &&  !lsdc_lsda_ex2_expt_vld_except_access_err
                                    ||  lsdc_ex2_borrow_vld;
//==========================================================
//                 Forward to st_data
//==========================================================
assign lsu_idu_ex2_staddr_vld      = (lsdc_sq_ex2_create_dp_vld
                                       && !sq_lsdc_ex2_full
                                    || lsdc_ex2_inst_vld
                                       && lsdc_lsda_ex2_vector_nop
                                       && !st_dc_utlb_miss_vld)
                                    &&  !lsdc_lsda_ex2_already_da
                                    &&  st_dc_staddr;
assign lsu_idu_ex2_staddr_unalign  = lsdc_sq_ex2_boundary_first;
assign lsu_idu_ex2_staddr1_vld     = lsdc_ex2_secd;
assign lsu_idu_ex2_sdiq_entry[SDIQ_ENTRY-1:0]  = st_dc_sdid_oh[SDIQ_ENTRY-1:0];  //parameterized, LTL@20241022

//==========================================================
//        Generage to DA stage signal
//==========================================================
assign lsdc_lsda_ex2_inst_vld          = lsdc_ex2_inst_vld
                                    &&  !st_dc_restart_vld;
//------------------page info sel if sync/bar req----------
assign st_dc_default_page         = st_dc_sync_inst
                                    ||  st_dc_fence_inst
                                    ||  st_dc_dcache_all_inst
                                    ||  st_dc_icache_all_inst
                                    ||  st_dc_tlbi_inst
                                    ||  st_dc_st_inst && !st_dc_staddr   //illege inst
                                    ||  st_dc_l2cache_inst;

assign lsdc_ex2_page_so           = st_dc_default_page
                                    ? 1'b0
                                    : st_dc_page_so;
assign st_dc_dcache_pa_sw_page_ca = st_dc_dcache_pa_sw_inst
                                    ? 1'b1
                                    : st_dc_page_ca;
assign lsdc_ex2_page_ca           = st_dc_default_page
                                    ? 1'b0
                                    : st_dc_dcache_pa_sw_page_ca;
assign lsdc_ex2_page_wa           = st_dc_default_page
                                    ? 1'b0
                                    : st_dc_page_wa;
assign lsdc_ex2_page_buf          = st_dc_default_page
                                    ? 1'b1
                                    : st_dc_page_buf;
assign lsdc_ex2_page_sec          = st_dc_default_page
                                    ? 1'b0
                                    : st_dc_page_sec;
assign lsdc_ex2_page_share        = st_dc_dcache_pa_sw_inst
                                    ? 1'b1
                                    : st_dc_page_share;

//------------------dcache tag pre_compare----------------
// assign lsdc_lsda_ex2_dcache_tag_array[103:0]  = dcache_lsdc_tag_dout[103:0];  //51->103, L1D 2way->4way, LTL@20250321
assign lsdc_lsda_ex2_dcache_tag_array[`WK_LS_DCACHE_TAG_NOECC_WIDTH-1:0]  = dcache_lsdc_tag_dout[`WK_LS_DCACHE_TAG_NOECC_WIDTH-1:0];  //51->103, L1D 2way->4way, LTL@20250321

//for ecc inj prepare
// &Force("output","lsdc_lsda_ex2_inst_vld"); @763
// &Force("output","lsdc_ex2_page_ca"); @764
// &Force("output","lsdc_lsda_ex2_borrow_icc"); @765
// &Force("output","lsu_idu_ex2_staddr_vld"); @766
assign lsdc_lsda_ex2_tag_inj_dp = lsdc_lsda_ex2_inst_vld
                             && lsdc_ex2_page_ca
                             && cp0_lsu_dcache_en
                             && cp0_lsu_ecc_en
                             && !lsdc_lsda_ex2_expt_vld_except_access_err
                             && !st_dc_utlb_miss_vld
                          || lsdc_ex2_borrow_vld
                             && !lsdc_lsda_ex2_borrow_icc;

assign lsdc_lsda_ex2_dcache_dirty_array[15:0] = { dcache_lsdc_dirty_dout[`WK_LS_DCACHE_TRIPLE_META_WIDTH+3:`WK_LS_DCACHE_TRIPLE_META_WIDTH],
                                                  dcache_lsdc_dirty_dout[`WK_LS_DCACHE_DOUBLE_META_WIDTH+3:`WK_LS_DCACHE_DOUBLE_META_WIDTH], 
                                                  dcache_lsdc_dirty_dout[`WK_LS_DCACHE_SINGLE_META_WIDTH+3:`WK_LS_DCACHE_SINGLE_META_WIDTH],
                                                  dcache_lsdc_dirty_dout[3:0]};  //dcache_lsdc_dirty_dout[44] deleted,L1D 2->4way, LTL@20250321

//for already_da set
assign lsdc_lsda_ex2_staddr_vld = lsu_idu_ex2_staddr_vld && !rtu_lsu_flush_fe && !(rtu_ck_flush && rtu_ck_flush_iid_older_than_ex2_iid);    //flush younger ex2_staddr_vld, ck_flush@LTL


assign lsdc_lsda_ex2_tag0_hit  = dcache_lsdc_dirty_dout[0]  && (lsdc_ex2_addr0[`WK_PA_WIDTH-1:14] == dcache_lsdc_tag_dout[`WK_LS_DCACHE_SINGLE_TAG_WIDTH-1:0]);
assign lsdc_lsda_ex2_tag1_hit  = dcache_lsdc_dirty_dout[11] && (lsdc_ex2_addr0[`WK_PA_WIDTH-1:14] == dcache_lsdc_tag_dout[`WK_LS_DCACHE_DOUBLE_TAG_WIDTH-1:`WK_LS_DCACHE_SINGLE_TAG_WIDTH]);
assign lsdc_lsda_ex2_tag2_hit  = dcache_lsdc_dirty_dout[22] && (lsdc_ex2_addr0[`WK_PA_WIDTH-1:14] == dcache_lsdc_tag_dout[`WK_LS_DCACHE_TRIPLE_TAG_WIDTH-1:`WK_LS_DCACHE_DOUBLE_TAG_WIDTH]);//51->103, L1D 2way->4way, LTL@20250321
assign lsdc_lsda_ex2_tag3_hit  = dcache_lsdc_dirty_dout[33] && (lsdc_ex2_addr0[`WK_PA_WIDTH-1:14] == dcache_lsdc_tag_dout[`WK_LS_DCACHE_TAG_NOECC_WIDTH-1 :`WK_LS_DCACHE_TRIPLE_TAG_WIDTH]);
assign lsdc_ex2_dcache_hit     = lsdc_lsda_ex2_tag0_hit || lsdc_lsda_ex2_tag1_hit || lsdc_lsda_ex2_tag2_hit || lsdc_lsda_ex2_tag3_hit;

assign lsdc_ex2_hit_way        = {lsdc_lsda_ex2_tag3_hit, lsdc_lsda_ex2_tag2_hit, lsdc_lsda_ex2_tag1_hit, lsdc_lsda_ex2_tag0_hit};
//==========================================================
//        Generage lsiq signal
//==========================================================
assign st_dc_mask_lsid[LSIQ_ENTRY-1:0]    = {LSIQ_ENTRY{lsdc_ex2_inst_vld}}
                                            & lsdc_lsda_ex2_lsid[LSIQ_ENTRY-1:0];

assign lsdc_idu_ex2_sq_full[LSIQ_ENTRY-1:0]  = {LSIQ_ENTRY{st_dc_sq_full_vld}}
                                            & st_dc_mask_lsid[LSIQ_ENTRY-1:0];

assign lsdc_ex2_imme_wakeup[LSIQ_ENTRY-1:0]  = {LSIQ_ENTRY{st_dc_imme_restart_vld}}
                                            & st_dc_mask_lsid[LSIQ_ENTRY-1:0];

assign lsdc_idu_ex2_tlb_busy[LSIQ_ENTRY-1:0] = {LSIQ_ENTRY{st_dc_tlb_busy_restart_vld}}
                                            & st_dc_mask_lsid[LSIQ_ENTRY-1:0];
//==========================================================
//        for mmu power
//==========================================================
assign lsu_mmu_vabuf[`WK_PA_WIDTH-13:0] = st_dc_vpn[`WK_PA_WIDTH-13:0];

//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
assign st_dc_sc_inst    = lsdc_ex2_atomic
                        & (lsdc_ex2_inst_type[1:0] == 2'b01); 

assign st_dc_data_check = dtu_lsu_data_trig_en
                        & (st_dc_st_inst
                          | st_dc_sc_inst)
                        & ~lsdc_ex2_inst_vls;   
//==========================================================
//                  Risc-V Debug zdb End 
//==========================================================                                    
// &ModuleEnd; @806
endmodule


