//-----------------------------------------------------------------------------
// File          : xx_lsu_ld_ag.v
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
module xx_lsu_ld_ag#(
parameter LSIQENTRY  = 12,
parameter VMBENTRY   = 8,
parameter PC_LEN      = 15,
parameter IID_WIDTH   = 7,
parameter VREG        = 6,
parameter PREG        = 7
)(
  lag_dcache_arb_ex1_data_gateclk_en,
  //lag_dcache_arb_ex1_data_high_idx,
  //lag_dcache_arb_ex1_data_low_idx,
  lag_dcache_arb_ex1_data_3_idx,  //2way->4way, LTL@20250319
  lag_dcache_arb_ex1_data_2_idx,
  lag_dcache_arb_ex1_data_1_idx,
  lag_dcache_arb_ex1_data_0_idx,
  lag_dcache_arb_ex1_data_req,
  lag_dcache_arb_ex1_ld_tag_gateclk_en,
  lag_dcache_arb_ex1_ld_tag_idx,
  lag_dcache_arb_ex1_ld_tag_req,
  // lag_dcache_arb_ex1_us_data_req, // wjh@us512
  cp0_lsu_cb_aclr_dis,
  cp0_lsu_da_fwd_dis,
  cp0_lsu_dcache_en,
  cp0_lsu_icg_en,
  cp0_lsu_mm,
  cp0_lsu_vstart,
  cp0_lsu_nsfe, // wjh@sfp
  cpurst_b,
  ctrl_ld_clk,
  dcache_arb_lag_ex1_bkcon,
  dcache_arb_lag_ex1_sel,
  dcache_arb_lag_ex1_addr,
  dcache_arb_lag_ex1_borrow_addr_vld,
  dcache_arb_ldc_borrow_vld_gate,
  dcache_lsu_ld_tag_dout,
  forever_cpuclk,
  idu_lsu_rf_already_da,
  idu_lsu_rf_atomic,
  idu_lsu_rf_gateclk_sel,
  idu_lsu_rf_iid,
  idu_lsu_rf_inst_fls,
  idu_lsu_rf_inst_fof,
  idu_lsu_rf_inst_ldr,
  idu_lsu_rf_inst_size,
  idu_lsu_rf_inst_type,
  idu_lsu_rf_inst_vls,
  idu_lsu_rf_lch_entry,
  idu_lsu_rf_lsfifo,
  //idu_lsu_rf_mlen , // not use in rvv1.0 @hcl
  idu_lsu_rf_no_spec ,
  idu_lsu_rf_no_spec_exist ,
  idu_lsu_rf_off_zext ,
  idu_lsu_rf_offset,
  idu_lsu_rf_offset_plus,
  idu_lsu_rf_oldest,
  idu_lsu_rf_pc,
  idu_lsu_rf_preg,
  idu_lsu_rf_sel,
  idu_lsu_rf_older_vld, // wjh@timing
  idu_lsu_rf_shift,
  idu_lsu_rf_sext,
  idu_lsu_rf_spec_fail,
  idu_lsu_rf_split,
  idu_lsu_rf_split_num,
  idu_lsu_rf_src0,
  idu_lsu_rf_src1,
  idu_lsu_rf_srcvm_vr0,
  idu_lsu_rf_srcvm_vr1,
  idu_lsu_rf_unal2nd,
  idu_lsu_rf_unit_stride,
  idu_lsu_rf_vl,
  idu_lsu_rf_vlmul,
  idu_lsu_rf_vls_size,
  idu_lsu_rf_vmask_vld,
  idu_lsu_rf_vmb_id,
  idu_lsu_rf_vmb_merge_vld,
  idu_lsu_rf_vreg,
  //idu_lsu_rf_vsew,  // not use in rvv1.0 @hcl
  idu_lsu_rf_vmew,
  idu_lsu_rf_vmop,
  idu_lsu_rf_nf,
  lrq_lsu_rf_replay_vld,    // wjh@lrq
  lrq_lsu_rf_va,            // wjh@lrq
  lrq_lsu_rf_bytes_vld,     // wjh@lrq
  lrq_lsu_rf_bytes_vld1,     // wjh@lrq
  lrq_lsu_rf_bytes_vld2,     // wjh@lrq
  lrq_lsu_rf_bytes_vld3,     // wjh@lrq
  lrq_lsu_rf_reg_bytes_vld, // wjh@lrq
  lrq_lsu_rf_reg_bytes_vld1, // wjh@lrq
  lrq_lsu_rf_reg_bytes_vld2, // wjh@lrq
  lrq_lsu_rf_reg_bytes_vld3, // wjh@lrq
  lrq_lsu_rf_boundary,      // wjh@lrq
  lrq_lsu_rf_pa_vld,        // wjh@lrq
  lrq_lsu_rf_pa,            // wjh@lrq
  lrq_lsu_rf_attr,          // wjh@lrq
  lrq_lsu_rf_sfp_dst_pc,
  lrq_lsu_rf_sfp_pc_hit,
  lrq_lsu_ex1_lrqid,        // wjh@lrq
  lrq_fence_aft_load,       // wjh@lrq
  lrq_hit_no_spec_tbl,      // wjh@lrq
  sfp_hit_no_spec_tbl,      // wjh@lrq
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
  lag_ldc_ex1_bytes_vld2,// wjh@us512
  lag_ldc_ex1_bytes_vld3,// wjh@us512
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
  lag_lm_ex1_init_vld,
  lag_ex1_lr_inst,
  lag_ldc_ex1_lsid,
  lag_ldc_ex1_lsiq_spec_fail,
  lag_ldc_ex1_no_spec,
  lag_ldc_ex1_no_spec_exist,
  lag_ldc_ex1_old,
  lag_ex1_pa,
  lag_ldc_ex1_page_buf,
  lag_ldc_ex1_page_ca,
  lag_ldc_ex1_page_sec,
  lag_ldc_ex1_page_share,
  lag_ldc_ex1_pf_inst,
  lag_ldc_ex1_preg,
  lag_ldc_ex1_raw0_new,
  lag_ldc_ex1_raw1_new,
  lag_ldc_ex1_reg_bytes_vld,
  lag_ldc_ex1_reg_bytes_vld1, // wjh@us512
  lag_ldc_ex1_reg_bytes_vld2, // wjh@us512
  lag_ldc_ex1_reg_bytes_vld3, // wjh@us512
  lag_ldc_ex1_us_way,
  lag_ldc_ex1_secd,
  lag_ldc_ex1_sext,
  lag_ldc_ex1_split,
  lag_ex1_stall_ori,
  lag_ex1_stall_restart_entry,
  lag_ldc_ex1_utlb_miss,
  lag_ldc_ex1_vlmul,
  lag_ldc_ex1_vmb_id,
  lag_ldc_ex1_vmb_merge_vld,
  lag_ldc_ex1_vpn,
  lag_ldc_ex1_vreg,
  //lag_ldc_ex1_vsew,
  lag_ldc_ex1_vmew,
  lag_ldc_ex1_vmop,  // special care    @hcl  rvv1.0
  lsu_hpcp_ld_stall_cross_4k,
  lsu_hpcp_ld_stall_other,
  lsu_idu_ex1_load_inst_vld,
  lsu_idu_ex1_preg,
  lsu_idu_ex1_vload_inst_vld,
  lsu_idu_ex1_vreg,
  lsu_idu_ex1_wait_old,
  lsu_idu_ex1_wait_old_gateclk_en,
  lsu_lrq_create_vld,            // wjh@lrq
  lsu_lrq_create_va,             // wjh@lrq
  lsu_lrq_create_frz,            // wjh@lrq
  lsu_lrq_create_wait_old_chk,   // wjh@lrq
  lsu_lrq_create_bar_chk,        // wjh@lrq
  lsu_lrq_create_no_spec_chk,    // wjh@lrq
  lsu_lrq_create_bytes_vld,      // wjh@lrq
  lsu_lrq_create_bytes_vld1,     // wjh@lrq
  lsu_lrq_create_bytes_vld2,     // wjh@lrq
  lsu_lrq_create_bytes_vld3,     // wjh@lrq
  lsu_lrq_create_reg_bytes_vld,  // wjh@lrq
  lsu_lrq_create_reg_bytes_vld1,  // wjh@lrq
  lsu_lrq_create_reg_bytes_vld2,  // wjh@lrq
  lsu_lrq_create_reg_bytes_vld3,  // wjh@lrq
  lsu_lrq_create_boundary,       // wjh@lrq
  lsu_lrq_create_atomic,         // wjh@lrq
  lsu_lrq_create_iid,            // wjh@lrq
  lsu_lrq_create_fls,            // wjh@lrq
  lsu_lrq_create_fof,            // wjh@lrq
  lsu_lrq_create_size,           // wjh@lrq
  lsu_lrq_create_type,           // wjh@lrq
  lsu_lrq_create_vls,            // wjh@lrq
  lsu_lrq_create_lsfifo,         // wjh@lrq
  lsu_lrq_create_pc,             // wjh@lrq
  lsu_lrq_create_preg,           // wjh@lrq
  lsu_lrq_create_sext,           // wjh@lrq
  lsu_lrq_create_split,          // wjh@lrq
  lsu_lrq_create_split_num,      // wjh@lrq
  lsu_lrq_create_unit_stride,    // wjh@lrq
  lsu_lrq_create_vlmul,          // wjh@lrq
  lsu_lrq_create_vls_size,       // wjh@lrq
  lsu_lrq_create_vmb_id,         // wjh@lrq
  lsu_lrq_create_vmb_merge_vld,  // wjh@lrq
  lsu_lrq_create_vreg,           // wjh@lrq
  //lsu_lrq_create_vsew,           // wjh@lrq
  lsu_lrq_create_vmew,
  lsu_lrq_create_vmop,
  lsu_lrq_create_nf,
  lsu_lrq_create_4kstall,        // wjh@lrq
  lsu_lrq_sfp_dst_pc,
  lsu_lrq_ex1_pa_set,            // wjh@lrq
  lsu_lrq_ex1_pa,                // wjh@lrq
  lsu_lrq_ex1_attr,              // wjh@lrq
  lsu_lrq_pop_entry,             // wjh@lrq
  // lsu_sfp_ex1_spec_chk,          // wjh@lrq
  lsu_mmu_abort,
  lsu_mmu_id,
  lsu_mmu_st_inst,
  lsu_mmu_va,
  lsu_mmu_va_vld,
  mmu_lsu_buf,
  mmu_lsu_ca,
  mmu_lsu_pa,
  mmu_lsu_pa_vld,
  mmu_lsu_page_fault,
  mmu_lsu_access_fault,
  mmu_lsu_sec,
  mmu_lsu_sh,
  mmu_lsu_so,
  mmu_lsu_stall,
  pad_yy_icg_scan_en,
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
  lag_dcache_arb_ex1_bank_idx,
  lsag0_ex1_iid,    
  lsag1_ex1_iid,
//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
  //intput
  dtu_lsu_addr_trig_en,
  dtu_lsu_data_trig_en,
  idu_lsu_rf_halt_info,      
  lsu_any_trig_en,
  //output
  ld_ag_boundary_unmask,
  ld_ag_dtu_access_size,
  ld_ag_dtu_last_check,     
  ld_ag_dtu_type,       
  ld_ag_dtu_va,         
  ld_ag_dtu_vld,        
  ld_ag_halt_info
//==========================================================
//                  Risc-V Debug zdb End 
//========================================================== 
);

//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
input                                         dtu_lsu_addr_trig_en; 
input                                         dtu_lsu_data_trig_en;
input   [`TDT_MP_HINFO_WIDTH-1:0]             idu_lsu_rf_halt_info;
input                                         lsu_any_trig_en;
output                                        ld_ag_boundary_unmask;
output  [2  :0]                               ld_ag_dtu_access_size;
output                                        ld_ag_dtu_last_check;
output  [1  :0]                               ld_ag_dtu_type;
output  [47 :0]                               ld_ag_dtu_va;
output                                        ld_ag_dtu_vld;
output  [`TDT_MP_HINFO_WIDTH-1:0]             ld_ag_halt_info;

//input
wire                                          dtu_lsu_addr_trig_en;  
wire                                          dtu_lsu_data_trig_en;
wire    [16 :0]                               idu_lsu_rf_halt_info;
wire                                          lsu_any_trig_en;
//output
wire                                          ld_ag_boundary_unmask;
wire                                          ld_ag_dtu_last_check;
wire    [1  :0]                               ld_ag_dtu_type;
wire    [47 :0]                               ld_ag_dtu_va;
wire                                          ld_ag_dtu_vld;
reg     [`TDT_MP_HINFO_WIDTH-1:0]             ld_ag_halt_info;
reg     [2  :0]                               ld_ag_dtu_access_size;
//==========================================================
//                  Risc-V Debug zdb End 
//==========================================================

// &Ports; @29
input                       rtu_ck_flush;
input   [IID_WIDTH-1  :0]   rtu_ck_flush_iid;

input                                       cp0_lsu_cb_aclr_dis;                
input                                       cp0_lsu_da_fwd_dis;                 
input                                       cp0_lsu_dcache_en;                  
input                                       cp0_lsu_icg_en;                     
input                                       cp0_lsu_mm;                         
input   [`VSTART_WIDTH-1  :0]                             cp0_lsu_vstart;                     
input                                       cp0_lsu_nsfe; // wjh@sfp
input                                       cpurst_b;                           
input                                       ctrl_ld_clk;                        
input                                       dcache_arb_lag_ex1_bkcon;
input                                       dcache_arb_lag_ex1_sel;               
input   [`WK_PA_WIDTH-1 :0]                 dcache_arb_lag_ex1_addr;              
input                                       dcache_arb_lag_ex1_borrow_addr_vld;   
input                                       dcache_arb_ldc_borrow_vld_gate;   
input   [`WK_LS_DCACHE_LDTAG_WIDTH-1:0]     dcache_lsu_ld_tag_dout; // wjh@us512
input                                       forever_cpuclk;                     
input                                       lrq_lsu_rf_replay_vld;    // wjh@lrq
input   [63:0]                              lrq_lsu_rf_va;            // wjh@lrq
input   [15:0]                              lrq_lsu_rf_bytes_vld;     // wjh@lrq
input   [15:0]                              lrq_lsu_rf_bytes_vld1;     // wjh@lrq
input   [15:0]                              lrq_lsu_rf_bytes_vld2;     // wjh@lrq
input   [15:0]                              lrq_lsu_rf_bytes_vld3;     // wjh@lrq
input   [15:0]                              lrq_lsu_rf_reg_bytes_vld; // wjh@lrq
input   [15:0]                              lrq_lsu_rf_reg_bytes_vld1; // wjh@lrq
input   [15:0]                              lrq_lsu_rf_reg_bytes_vld2; // wjh@lrq
input   [15:0]                              lrq_lsu_rf_reg_bytes_vld3; // wjh@lrq
input                                       lrq_lsu_rf_boundary;      // wjh@lrq
input                                       idu_lsu_rf_already_da;        
input                                       idu_lsu_rf_atomic;                 
input                                       idu_lsu_rf_gateclk_sel;       
input   [IID_WIDTH-1  :0]                   idu_lsu_rf_iid;               
input                                       idu_lsu_rf_inst_fls;          
input                                       idu_lsu_rf_inst_fof;          
input                                       idu_lsu_rf_inst_ldr;          
input   [1  :0]                             idu_lsu_rf_inst_size;         
input   [1  :0]                             idu_lsu_rf_inst_type;         
input                                       idu_lsu_rf_inst_vls;          
input   [LSIQENTRY-1 :0]                    idu_lsu_rf_lch_entry;         
input                                       idu_lsu_rf_lsfifo;            
//input   [2  :0]                             idu_lsu_rf_mlen ;    // not use in rvv1.0 @hcl           
input   [1  :0]                             idu_lsu_rf_no_spec ;           
input                                       idu_lsu_rf_no_spec_exist ;     
input                                       idu_lsu_rf_off_zext ;      
input   [11 :0]                             idu_lsu_rf_offset;            
input   [12 :0]                             idu_lsu_rf_offset_plus;       
input                                       idu_lsu_rf_oldest;            
input   [PC_LEN-1 :0]                       idu_lsu_rf_pc;                
input   [PREG-1  :0]                        idu_lsu_rf_preg;              
input                                       idu_lsu_rf_sel;               
input                                       idu_lsu_rf_older_vld; // wjh@timing
input   [3  :0]                             idu_lsu_rf_shift;             
input                                       idu_lsu_rf_sext;       
input                                       idu_lsu_rf_spec_fail;         
input                                       idu_lsu_rf_split;             
input   [8  :0]                             idu_lsu_rf_split_num;// wjh@us512
input   [63 :0]                             idu_lsu_rf_src0;              
input   [63 :0]                             idu_lsu_rf_src1;              
input   [255 :0]                            idu_lsu_rf_srcvm_vr0; // wjh@us512
input   [255 :0]                            idu_lsu_rf_srcvm_vr1; // wjh@us512
input                                       idu_lsu_rf_unal2nd;       
input                                       idu_lsu_rf_unit_stride;       
input   [`VL_WIDTH-1  :0]                             idu_lsu_rf_vl;                
// input   [1  :0]                             idu_lsu_rf_vlmul;  
input   [2  :0]             idu_lsu_rf_vlmul;  //pwh 1 for rvv1.0           
input   [3  :0]                             idu_lsu_rf_vls_size;          
input                                       idu_lsu_rf_vmask_vld;         
input   [VMBENTRY-1  :0]                    idu_lsu_rf_vmb_id;            
input                                       idu_lsu_rf_vmb_merge_vld;     
input   [VREG  :0]                          idu_lsu_rf_vreg;              
//input   [1  :0]                             idu_lsu_rf_vsew;     // not use in rvv1.0 @hcl
input   [1  :0]             idu_lsu_rf_vmew;
input   [1  :0]             idu_lsu_rf_vmop;      
input                       idu_lsu_rf_nf;             
input                                       lrq_lsu_rf_pa_vld;     // wjh@lrq
input   [`WK_PA_WIDTH-13:0]                 lrq_lsu_rf_pa;         // wjh@lrq
input   [4:0]                               lrq_lsu_rf_attr;       // wjh@lrq
input   [PC_LEN-1:0]                        lrq_lsu_rf_sfp_dst_pc;
input                                       lrq_lsu_rf_sfp_pc_hit;
input   [LSIQENTRY-1:0]                     lrq_lsu_ex1_lrqid;     // wjh@lrq
input                                       lrq_fence_aft_load;    // wjh@lrq
input                                       lrq_hit_no_spec_tbl;   // wjh@lrq
input                                       sfp_hit_no_spec_tbl;   // wjh@lrq
input                                       mmu_lsu_buf;                       
input                                       mmu_lsu_ca;                        
input   [`WK_PA_WIDTH-13:0]                 mmu_lsu_pa;                        
input                                       mmu_lsu_pa_vld;                    
input                                       mmu_lsu_page_fault;                
input                                       mmu_lsu_access_fault;
input                                       mmu_lsu_sec;                       
input                                       mmu_lsu_sh;                        
input                                       mmu_lsu_so;                        
input                                       mmu_lsu_stall;                     
input                                       pad_yy_icg_scan_en;                 
input                                       rtu_lsu_flush_fe;                   
input                                       rtu_yy_xx_commit0;                  
input   [IID_WIDTH-1  :0]                   rtu_yy_xx_commit0_iid;              
input                                       rtu_yy_xx_commit1;                  
input   [IID_WIDTH-1  :0]                   rtu_yy_xx_commit1_iid;              
input                                       rtu_yy_xx_commit2;                  
input   [IID_WIDTH-1  :0]                   rtu_yy_xx_commit2_iid;  
input                                       rtu_yy_xx_commit3;                  
input   [IID_WIDTH-1  :0]                   rtu_yy_xx_commit3_iid;              
input                                       rtu_yy_xx_commit4;                  
input   [IID_WIDTH-1  :0]                   rtu_yy_xx_commit4_iid;              
input                                       rtu_yy_xx_commit5;                  
input   [IID_WIDTH-1  :0]                   rtu_yy_xx_commit5_iid;             
input   [IID_WIDTH-1  :0]                   lsag0_ex1_iid;    
input   [IID_WIDTH-1  :0]                   lsag1_ex1_iid;                           
output  [15 :0]                             lag_dcache_arb_ex1_data_gateclk_en;   //7->15, L1D 2way->4way, LTL@20250319
//output  [9  :0]             lag_dcache_arb_ex1_data_high_idx;     //10->9, L1D 2way->4way, LTL@20250319
//output  [9  :0]             lag_dcache_arb_ex1_data_low_idx;      //10->9, L1D 2way->4way, LTL@20250319
output  [9  :0]                             lag_dcache_arb_ex1_data_3_idx;     //10->9, L1D 2way->4way, LTL@20250319
output  [9  :0]                             lag_dcache_arb_ex1_data_2_idx;     //10->9, L1D 2way->4way, LTL@20250319
output  [9  :0]                             lag_dcache_arb_ex1_data_1_idx;     //10->9, L1D 2way->4way, LTL@20250319
output  [9  :0]                             lag_dcache_arb_ex1_data_0_idx;     //10->9, L1D 2way->4way, LTL@20250319
output  [15 :0]                             lag_dcache_arb_ex1_data_req;          //7->15, L1D 2way->4way, LTL@20250319
output                                      lag_dcache_arb_ex1_ld_tag_gateclk_en;    
output  [7  :0]                             lag_dcache_arb_ex1_ld_tag_idx;        //8->7, L1D 2way->4way, LTL@20250319    
output                                      lag_dcache_arb_ex1_ld_tag_req;           
// output                                      lag_dcache_arb_ex1_us_data_req;
output  [`WK_PA_WIDTH-5:0]                  lag_ldc_ex1_addr1_to4;                    
output                                      lag_ldc_ex1_ahead_predict;                
output                                      lag_ldc_ex1_already_da;                   
output                                      lag_ldc_ex1_atomic;                       
output                                      lag_ldc_ex1_boundary;                     
output  [2  :0]                             lag_ex1_dc_access_size;               
output                                      lag_ldc_ex1_acclr_en;                  
output  [`WK_PA_WIDTH-1 :0]                 lag_ldc_ex1_addr0;                     
output  [15 :0]                             lag_ldc_ex1_bytes_vld;                 
output  [15 :0]                             lag_ldc_ex1_bytes_vld1;                
output  [15 :0]                             lag_ldc_ex1_bytes_vld2; // wjh@us512
output  [15 :0]                             lag_ldc_ex1_bytes_vld3; // wjh@us512
output                                      lag_ldc_ex1_inst_us;
output                                      lag_ldc_ex1_fwd_bypass_en;             
output                                      lag_ldc_ex1_inst_vld;                  
output                                      lag_ldc_ex1_load_ahead_inst_vld;       
output                                      lag_ldc_ex1_load_inst_vld;             
output                                      lag_ldc_ex1_mmu_req;                   
output                                      lag_ldc_ex1_page_so;                   
output  [3  :0]                             lag_ldc_ex1_rot_sel;                   
output                                      lag_ldc_ex1_vload_ahead_inst_vld;      
output                                      lag_ldc_ex1_vload_inst_vld;            
output                                      lag_ldc_ex1_dtcm_hit;                     
output  [8  :0]                             lag_ldc_ex1_element_cnt;// wjh@us512
output  [3  :0]                             lag_ldc_ex1_element_offset;               
output  [1  :0]                             lag_ldc_ex1_element_size;                 
output                                      lag_ldc_ex1_expt_access_fault_with_page;  
output                                      lag_ldc_ex1_expt_ldamo_not_ca;            
output                                      lag_ldc_ex1_expt_misalign_no_page;        
output                                      lag_ldc_ex1_expt_misalign_with_page;      
output                                      lag_ldc_ex1_expt_page_fault;              
output                                      lag_ldc_ex1_expt_vld;                     
output  [IID_WIDTH-1  :0]                   lag0_ex1_iid;                          
output                                      lag_ldc_ex1_inst_fof;                     
output  [1  :0]                             lag_ldc_ex1_inst_type;                    
output                                      lag_ldc_ex1_inst_vfls;                    
output                                      lag_ex1_inst_vld;                     
output                                      lag_ldc_ex1_inst_vls;                     
output                                      lag_ldc_ex1_itcm_hit;                     
output  [PC_LEN-1 :0]                       lag_ldc_ex1_ldfifo_pc;                    
output                                      lag_lm_ex1_init_vld;                  
output                                      lag_ex1_lr_inst;                      
output  [LSIQENTRY-1 :0]                    lag_ldc_ex1_lsid;                                   
output                                      lag_ldc_ex1_lsiq_spec_fail;               
output  [1  :0]                             lag_ldc_ex1_no_spec;                      
output                                      lag_ldc_ex1_no_spec_exist;                
output                                      lag_ldc_ex1_old;                          
output  [`WK_PA_WIDTH-1 :0]                 lag_ex1_pa;                           
output                                      lag_ldc_ex1_page_buf;                     
output                                      lag_ldc_ex1_page_ca;                      
output                                      lag_ldc_ex1_page_sec;                     
output                                      lag_ldc_ex1_page_share;                   
output                                      lag_ldc_ex1_pf_inst;                      
output  [PREG-1  :0]                        lag_ldc_ex1_preg;                         
output                                      lag_ldc_ex1_raw0_new; 
output                                      lag_ldc_ex1_raw1_new;                    
output  [15 :0]                             lag_ldc_ex1_reg_bytes_vld;                
output  [15 :0]                             lag_ldc_ex1_reg_bytes_vld1; // wjh@us512
output  [15 :0]                             lag_ldc_ex1_reg_bytes_vld2; // wjh@us512
output  [15 :0]                             lag_ldc_ex1_reg_bytes_vld3; // wjh@us512
output  [3  :0]                             lag_ldc_ex1_us_way;
output                                      lag_ldc_ex1_secd;                         
output                                      lag_ldc_ex1_sext;                  
output                                      lag_ldc_ex1_split;                        
output                                      lag_ex1_stall_ori;                    
output  [LSIQENTRY-1 :0]                    lag_ex1_stall_restart_entry;          
output                                      lag_ldc_ex1_utlb_miss;                    
// output  [1  :0]                             lag_ldc_ex1_vlmul;    
output  [2  :0]             lag_ldc_ex1_vlmul;  //pwh 2 for rvv1.0                   
output  [VMBENTRY-1  :0]                    lag_ldc_ex1_vmb_id;                       
output                                      lag_ldc_ex1_vmb_merge_vld;                
output  [`WK_PA_WIDTH-13:0]                 lag_ldc_ex1_vpn;                          
output  [VREG-1  :0]                        lag_ldc_ex1_vreg;                         
//output  [1  :0]                             lag_ldc_ex1_vsew;      // not use  in rvv1.0 @hcl
output  [1  :0]             lag_ldc_ex1_vmew;
output  [1  :0]             lag_ldc_ex1_vmop;      // special care    @hcl  rvv1.0           
output                                      lsu_hpcp_ld_stall_cross_4k;         
output                                      lsu_hpcp_ld_stall_other;            
output                                      lsu_idu_ex1_load_inst_vld;     
output  [PREG-1  :0]                        lsu_idu_ex1_preg;                
output                                      lsu_idu_ex1_vload_inst_vld;    
output  [VREG  :0]                          lsu_idu_ex1_vreg;               
output  [LSIQENTRY-1 :0]                    lsu_idu_ex1_wait_old;             
output                                      lsu_idu_ex1_wait_old_gateclk_en;  
output                                      lsu_lrq_create_vld;           // wjh@lrq
output [63:0]                               lsu_lrq_create_va;            // wjh@lrq
output                                      lsu_lrq_create_frz;           // wjh@lrq
output                                      lsu_lrq_create_wait_old_chk;  // wjh@lrq
output                                      lsu_lrq_create_bar_chk;       // wjh@lrq
output                                      lsu_lrq_create_no_spec_chk;   // wjh@lrq
output [15:0]                               lsu_lrq_create_bytes_vld;     // wjh@lrq
output [15:0]                               lsu_lrq_create_bytes_vld1;    // wjh@lrq
output [15:0]                               lsu_lrq_create_bytes_vld2;    // wjh@lrq
output [15:0]                               lsu_lrq_create_bytes_vld3;    // wjh@lrq
output [15:0]                               lsu_lrq_create_reg_bytes_vld; // wjh@lrq
output [15:0]                               lsu_lrq_create_reg_bytes_vld1; // wjh@lrq
output [15:0]                               lsu_lrq_create_reg_bytes_vld2; // wjh@lrq
output [15:0]                               lsu_lrq_create_reg_bytes_vld3; // wjh@lrq
output                                      lsu_lrq_create_boundary;      // wjh@lrq
output                                      lsu_lrq_create_atomic;        // wjh@lrq
output [IID_WIDTH-1:0]                      lsu_lrq_create_iid;           // wjh@lrq
output                                      lsu_lrq_create_fls;           // wjh@lrq
output                                      lsu_lrq_create_fof;           // wjh@lrq
output [1:0]                                lsu_lrq_create_size;          // wjh@lrq
output [1:0]                                lsu_lrq_create_type;          // wjh@lrq
output                                      lsu_lrq_create_vls;           // wjh@lrq
output                                      lsu_lrq_create_lsfifo;        // wjh@lrq
output [PC_LEN-1:0]                         lsu_lrq_create_pc;            // wjh@lrq
output [PREG-1:0]                           lsu_lrq_create_preg;          // wjh@lrq
output                                      lsu_lrq_create_sext;          // wjh@lrq
output                                      lsu_lrq_create_split;         // wjh@lrq
output [8:0]                                lsu_lrq_create_split_num;     // wjh@lrq
output                                      lsu_lrq_create_unit_stride;   // wjh@lrq
// output [1:0]                                lsu_lrq_create_vlmul;         // wjh@lrq
output [2:0]                lsu_lrq_create_vlmul;         // wjh@lrq  //pwh 3 for rvv1.0
output [3:0]                                lsu_lrq_create_vls_size;      // wjh@lrq
output [VMBENTRY-1:0]                       lsu_lrq_create_vmb_id;        // wjh@lrq
output                                      lsu_lrq_create_vmb_merge_vld; // wjh@lrq
output [VREG-1:0]                           lsu_lrq_create_vreg;          // wjh@lrq
//output [1:0]                                lsu_lrq_create_vsew;          // wjh@lrq
output [1:0]                lsu_lrq_create_vmew;//rvv1.0@hcl
output [1:0]                lsu_lrq_create_vmop;//rvv1.0@hcl
output                      lsu_lrq_create_nf;
output                                      lsu_lrq_create_4kstall;       // wjh@lrq
output                                      lsu_lrq_ex1_pa_set;           // wjh@lrq
output [PC_LEN-1:0]                         lsu_lrq_sfp_dst_pc;
output  [`WK_PA_WIDTH-13:0]                 lsu_lrq_ex1_pa;               // wjh@lrq
output  [4:0]                               lsu_lrq_ex1_attr;             // wjh@lrq
output  [LSIQENTRY-1:0]                     lsu_lrq_pop_entry;            // wjh@lrq
// output                      lsu_sfp_ex1_spec_chk;         // wjh@lrq
output                                      lsu_mmu_abort;                     
output  [IID_WIDTH-1:0]                     lsu_mmu_id;                        
output                                      lsu_mmu_st_inst;                   
output  [63 :0]                             lsu_mmu_va;                        
output                                      lsu_mmu_va_vld; 
output  [1  :0]                             lag_dcache_arb_ex1_bank_idx;  //2->1, L1D 2way->4way, LTL@20250319                   

// &Regs; @30           
reg     [15 :0]                             active_element_with_vl;             
reg     [15 :0]                             active_element_with_vstart;         
reg     [15 :0]                             active_with_vl;                     
reg     [15 :0]                             active_with_vstart;                 
reg     [3  :0]                             bank_en_low_ori;                    
reg     [6  :0]                             element_cnt;                        
reg     [15 :0]                             element_cnt_onehot;                 
reg     [3  :0]                             element_offset_for_secd;            
reg     [3  :0]                             ld_ag_access_size_ori;              
reg                                         ld_ag_align;                        
reg                                         ld_ag_already_cross_page_ldr_imme;  
reg                                         lag_ldc_ex1_already_da;                   
reg                                         lag_ldc_ex1_atomic;                       
reg     [63 :0]                             ld_ag_base;                         
reg                                         ld_ag_bypass_en;                    
reg     [2  :0]                             lag_ex1_dc_access_size;               
reg     [IID_WIDTH-1  :0]                   lag0_ex1_iid;                          
reg                                         ld_ag_inst_fls;                     
reg                                         lag_ldc_ex1_inst_fof;                     
reg                                         ld_ag_inst_ldr;                     
reg     [1  :0]                             ld_ag_inst_size;                    
reg     [1  :0]                             lag_ldc_ex1_inst_type;                    
reg                                         lag_ex1_inst_vld;                     
reg                                         lag_ldc_ex1_inst_vls;                     
reg     [PC_LEN-1 :0]                       lag_ldc_ex1_ldfifo_pc;                    
reg     [15 :0]                             ld_ag_le_bytes_vld_high_bits_full;  
reg     [15 :0]                             ld_ag_le_bytes_vld_low_bits_full;   
reg                                         ld_ag_lsfifo;                       
wire     [LSIQENTRY-1 :0]                   lag_ldc_ex1_lsid;                         
reg     [LSIQENTRY-1:0]                     lag_ex1_lsid;          
reg                                         lag_ldc_ex1_lsiq_spec_fail;               
//reg     [2  :0]                             ld_ag_mlen;  // not use in rvv1.0 @hcl                       
reg     [1  :0]                             lag_ldc_ex1_no_spec;                      
reg                                         lag_ldc_ex1_no_spec_exist;                
reg     [63 :0]                             ld_ag_offset;                       
reg     [12 :0]                             ld_ag_offset_plus;                  
reg     [3  :0]                             ld_ag_offset_shift;                 
reg                                         lag_ldc_ex1_old;                          
reg     [PREG-1  :0]                        lag_ldc_ex1_preg;                         
//reg     [6  :0]             ld_ag_preg_dup1;                    
//reg     [6  :0]             ld_ag_preg_dup2;                    
//reg     [6  :0]             ld_ag_preg_dup3;                    
//eg     [6  :0]             ld_ag_preg_dup4;                    
reg                                         lag_ldc_ex1_secd;                         
reg                                         lag_ldc_ex1_sext;                  
reg                                         lag_ldc_ex1_split;                        
reg     [8  :0]                             ld_ag_split_cnt; // wjh@us512
reg                                         ld_ag_unit_stride;                  
reg     [3  :0]                             ld_ag_va_round;                     
reg     [511:0]                             ld_ag_vector_mask;                  
reg     [`VL_WIDTH-1  :0]                             ld_ag_vl;                           
// reg     [1  :0]                             lag_ldc_ex1_vlmul;        
reg     [2  :0]             lag_ldc_ex1_vlmul;                
reg     [3  :0]                             ld_ag_vls_size;                     
reg                                         ld_ag_vmask_vld;                    
reg     [VMBENTRY-1  :0]                    lag_ldc_ex1_vmb_id;                       
reg                                         lag_ldc_ex1_vmb_merge_vld;                
reg     [VREG-1  :0]                        lag_ldc_ex1_vreg;                         
//reg     [VREG-1  :0]             ld_ag_vreg_dup1;                    
//reg     [VREG-1  :0]             ld_ag_vreg_dup2;                    
//reg     [VREG-1  :0]             ld_ag_vreg_dup3;                    
//reg     [1  :0]                             lag_ldc_ex1_vsew;  // not use in rvv1.0 @hcl
reg     [1  :0]             lag_ldc_ex1_vmew;
reg     [1  :0]             lag_ldc_ex1_vmop;  
reg                         lag_ldc_ex1_nf;                     
reg     [15 :0]                             reg_bytes_vld;                      
reg     [15 :0]                             reg_bytes_vld1; // wjh@us512                      
reg     [15 :0]                             reg_bytes_vld2; // wjh@us512                      
reg     [15 :0]                             reg_bytes_vld3; // wjh@us512                      
reg     [3  :0]                             reg_element_rot;                    
reg     [3  :0]                             reg_element_start;                  
reg     [15 :0]                             reg_element_vld;                    
reg     [15 :0]                             vector_byte_mask;                   
reg     [15 :0]                             vmask_16;                           
reg     [15 :0]                             vmask_16_aft_rot;                   
reg     [15 :0]                             vmask_byte_sel;                     
reg     [15 :0]                             vmask_byte_sel1; // wjh@us512
reg     [15 :0]                             vmask_byte_sel2; // wjh@us512
reg     [15 :0]                             vmask_byte_sel3; // wjh@us512
//reg     [15 :0]                             vmask_mlen1_16;// not use in rvv1.0 @hcl                     
//reg     [31 :0]                             vmask_mlen2_32;// not use in rvv1.0 @hcl                    
reg                                         lag_lrq_pa_vld;
reg     [`WK_PA_WIDTH-13:0]                 lag_lrq_pa;
reg     [4:0]                               lag_lrq_attr;
reg                                         lag_lrq_replay_vld;
reg     [63:0]                              lag_lrq_va;
reg     [15:0]                              lag_lrq_bytes_vld;
reg     [15:0]                              lag_lrq_bytes_vld1;
reg     [15:0]                              lag_lrq_bytes_vld2;
reg     [15:0]                              lag_lrq_bytes_vld3;
reg     [15:0]                              lag_lrq_reg_bytes_vld;
reg     [15:0]                              lag_lrq_reg_bytes_vld1;
reg     [15:0]                              lag_lrq_reg_bytes_vld2;
reg     [15:0]                              lag_lrq_reg_bytes_vld3;
reg                                         lag_lrq_boundary;
reg                                         lag_lrq_create_already;
reg     [LSIQENTRY-1:0]                     lag_lrq_lsid;
reg                                         lag_bkcon_tlbmiss;
reg                                         lag_bkcon_pgfault;
reg                                         lag_bkcon_acfault;
reg                                         lag_bkcon_stall_already;
wire                                        lag_mmu_acfault;
wire                                        lag_bkcon_stall_vld;
wire                                        ld_ag_bkcon_stall_req;
wire                                        ld_ag_data_req_mask;

// &Wires; @31 
wire    [1  :0]                             lag_dcache_arb_ex1_bank_idx;         //2->1, L1D 2way->4way, LTL@20250319 
wire    [15 :0]                             active_element;                     
wire    [15 :0]                             lag_dcache_arb_ex1_data_gateclk_en;   //7->15, L1D 2way->4way, LTL@20250319
//wire    [9  :0]             lag_dcache_arb_ex1_data_high_idx;     //10->9, L1D 2way->4way, LTL@20250319
//wire    [9  :0]             lag_dcache_arb_ex1_data_low_idx;      //10->9, L1D 2way->4way, LTL@20250319
wire    [9  :0]                             lag_dcache_arb_ex1_data_3_idx;      //10->9, L1D 2way->4way, LTL@20250319
wire    [9  :0]                             lag_dcache_arb_ex1_data_2_idx;      //10->9, L1D 2way->4way, LTL@20250319
wire    [9  :0]                             lag_dcache_arb_ex1_data_1_idx;      //10->9, L1D 2way->4way, LTL@20250319
wire    [9  :0]                             lag_dcache_arb_ex1_data_0_idx;      //10->9, L1D 2way->4way, LTL@20250319
wire    [15 :0]                             lag_dcache_arb_ex1_data_req;          //7->15, L1D 2way->4way, LTL@20250319
wire                                        ag_dcache_arb_ld_gateclk_en;        
wire                                        ag_dcache_arb_ld_req;               
wire                                        lag_dcache_arb_ex1_ld_tag_gateclk_en;    
wire    [7  :0]                             lag_dcache_arb_ex1_ld_tag_idx;        //8->7, L1D 2way->4way, LTL@20250319   
wire                                        lag_dcache_arb_ex1_ld_tag_req;           
wire                                        all_active_for_vl;                  
wire                                        all_active_for_vstart;              
wire                                        all_inactive_for_vl;                
wire                                        all_inactive_for_vstart;            
wire    [3  :0]                             bank_en_low;                        
wire    [3  :0]                             bank_en_low_gateclk;                
wire                                        cp0_lsu_cb_aclr_dis;                
wire                                        cp0_lsu_da_fwd_dis;                 
wire                                        cp0_lsu_dcache_en;                  
wire                                        cp0_lsu_icg_en;                     
wire                                        cp0_lsu_mm;                         
wire    [`VSTART_WIDTH-1  :0]                             cp0_lsu_vstart;                     
wire                                        cpurst_b;                           
wire                                        ctrl_ld_clk;                        
wire                                        dcache_arb_lag_ex1_sel;               
wire    [`WK_PA_WIDTH-1 :0]                 dcache_arb_lag_ex1_addr;              
wire                                        dcache_arb_lag_ex1_borrow_addr_vld;   
wire                                        dcache_arb_ldc_borrow_vld_gate;   
wire    [`WK_LS_DCACHE_LDTAG_WIDTH-1:0]     dcache_lsu_ld_tag_dout; // wjh@us512
wire                                        element_active;                     
wire    [15 :0]                             element_active_aft_mask;            
wire    [15 :0]                             element_vld_aft_mask;               
wire                                        forever_cpuclk;                     
wire                                        idu_lsu_rf_already_da;        
wire                                        idu_lsu_rf_atomic;                
wire                                        idu_lsu_rf_gateclk_sel;       
wire    [IID_WIDTH-1  :0]                   idu_lsu_rf_iid;               
wire                                        idu_lsu_rf_inst_fls;          
wire                                        idu_lsu_rf_inst_fof;          
wire                                        idu_lsu_rf_inst_ldr;          
wire    [1  :0]                             idu_lsu_rf_inst_size;         
wire    [1  :0]                             idu_lsu_rf_inst_type;         
wire                                        idu_lsu_rf_inst_vls;          
wire    [LSIQENTRY-1 :0]                    idu_lsu_rf_lch_entry;         
wire                                        idu_lsu_rf_lsfifo;            
//wire    [2  :0]                             idu_lsu_rf_mlen ;  // not use in rvv1.0 @hcl            
wire    [1  :0]                             idu_lsu_rf_no_spec ;           
wire                                        idu_lsu_rf_no_spec_exist ;     
wire                                        idu_lsu_rf_off_zext ;      
wire    [11 :0]                             idu_lsu_rf_offset;            
wire    [12 :0]                             idu_lsu_rf_offset_plus;       
wire                                        idu_lsu_rf_oldest;            
wire    [PC_LEN-1 :0]                       idu_lsu_rf_pc;                
wire    [PREG-1  :0]                        idu_lsu_rf_preg;              
wire                                        idu_lsu_rf_sel;               
wire                                        idu_lsu_rf_older_vld; // wjh@timing
wire    [3  :0]                             idu_lsu_rf_shift;             
wire                                        idu_lsu_rf_sext;       
wire                                        idu_lsu_rf_spec_fail;         
wire                                        idu_lsu_rf_split;             
wire    [8  :0]                             idu_lsu_rf_split_num;// wjh@us512, 6
wire    [63 :0]                             idu_lsu_rf_src0;              
wire    [63 :0]                             idu_lsu_rf_src1;              
wire    [255 :0]                            idu_lsu_rf_srcvm_vr0;         
wire    [255 :0]                            idu_lsu_rf_srcvm_vr1;         
wire                                        idu_lsu_rf_unal2nd;       
wire                                        idu_lsu_rf_unit_stride;       
wire    [`VL_WIDTH-1  :0]                             idu_lsu_rf_vl;                
// wire    [1  :0]                             idu_lsu_rf_vlmul;        
wire    [2  :0]             idu_lsu_rf_vlmul;    
wire    [3  :0]                             idu_lsu_rf_vls_size;          
wire                                        idu_lsu_rf_vmask_vld;         
wire    [VMBENTRY-1  :0]                    idu_lsu_rf_vmb_id;            
wire                                        idu_lsu_rf_vmb_merge_vld;     
wire    [VREG  :0]                          idu_lsu_rf_vreg;              
//wire    [1  :0]                             idu_lsu_rf_vsew; // not use in rvv1.0 @hcl 
wire    [1  :0]             idu_lsu_rf_vmew;
wire    [1  :0]             idu_lsu_rf_vmop; 
wire                        idu_lsu_rf_nf;            
wire                                        ld_ag_4k_sum_12;                    
wire    [12 :0]                             ld_ag_4k_sum_ori;                   
wire    [12 :0]                             ld_ag_4k_sum_plus;                  
wire    [3  :0]                             ld_ag_access_size;                  
wire                                        ld_ag_acclr_en;                     
wire    [`WK_PA_WIDTH-1:0]                  ld_ag_addr0;                        
wire    [`WK_PA_WIDTH-5:0]                  lag_ldc_ex1_addr1_to4;                    
wire                                        lag_ldc_ex1_ahead_predict;                
wire                                        ld_ag_atomic_no_cmit_restart_arb;   
wire                                        ld_ag_atomic_no_cmit_restart_req;   
wire                                        ld_ag_not_replay_bar_chk; // wjh@lrq
wire                                        ld_ag_not_replay_no_spec_chk; // wjh@lrq
wire                                        lag_ldc_ex1_boundary;                     
wire                                        ld_ag_boundary_first;               
wire                                        ld_ag_boundary_stall;                             
wire    [15 :0]                             ld_ag_bytes_vld;                    
wire    [15 :0]                             ld_ag_bytes_vld1;                   
wire    [15 :0]                             ld_ag_bytes_vld_high_bits;          
wire    [15 :0]                             ld_ag_bytes_vld_low_cross_bits;     
wire                                        ld_ag_clk;                          
wire                                        ld_ag_clk_en;                       
wire                                        ld_ag_cmit;                         
wire                                        ld_ag_cmit_hit0;                    
wire                                        ld_ag_cmit_hit1;                    
wire                                        ld_ag_cmit_hit2; 
wire                                        ld_ag_cmit_hit3;                    
wire                                        ld_ag_cmit_hit4;                    
wire                                        ld_ag_cmit_hit5;                    
wire                                        ld_ag_cross_4k;                     
wire                                        ld_ag_cross_page_ldr_imme_stall_arb; 
wire                                        ld_ag_cross_page_ldr_imme_stall_req; 
wire                                        lag_ldc_ex1_acclr_en;                  
wire    [`WK_PA_WIDTH-1 :0]                 lag_ldc_ex1_addr0;                     
reg     [15 :0]                             lag_ldc_ex1_bytes_vld;                 
reg     [15 :0]                             lag_ldc_ex1_bytes_vld1;                
wire    [15 :0]                             lag_ldc_ex1_bytes_vld2; // wjh@us512
wire    [15 :0]                             lag_ldc_ex1_bytes_vld3; // wjh@us512
wire                                        lag_ldc_ex1_inst_us;     // wjh@us512
wire                                        lag_ldc_ex1_fwd_bypass_en;             
wire                                        lag_ldc_ex1_inst_vld;                  
wire                                        lag_ldc_ex1_load_ahead_inst_vld;       
wire                                        lag_ldc_ex1_load_inst_vld;             
wire                                        lag_ldc_ex1_mmu_req;                   
wire                                        lag_ldc_ex1_page_so;                   
wire    [3  :0]                             lag_ldc_ex1_rot_sel;                   
wire                                        lag_ldc_ex1_vload_ahead_inst_vld;      
wire                                        lag_ldc_ex1_vload_inst_vld;            
wire                                        ld_ag_dcache_stall_req;             
wire                                        ld_ag_dcache_stall_unmask;          
wire                                        lag_ldc_ex1_dtcm_hit;                     
wire                                        ld_ag_dtcm_stall;                   
wire    [8  :0]                             lag_ldc_ex1_element_cnt; // wjh@us512, 6
wire    [3  :0]                             lag_ldc_ex1_element_offset;               
wire    [1  :0]                             lag_ldc_ex1_element_size;                 
wire                                        lag_ldc_ex1_expt_access_fault_with_page;  
wire                                        lag_ldc_ex1_expt_ldamo_not_ca;            
wire                                        lag_ldc_ex1_expt_misalign_no_page;        
wire                                        lag_ldc_ex1_expt_misalign_with_page;      
wire                                        lag_ldc_ex1_expt_page_fault;              
wire                                        lag_ldc_ex1_expt_vld;                     
wire                                        ld_ag_inst_stall_gateclk_en;        
wire                                        lag_ldc_ex1_inst_vfls;                    
wire                                        ld_ag_itcm_chk_stall;               
wire                                        lag_ldc_ex1_itcm_hit;                     
wire                                        ld_ag_itcm_stall;                   
wire                                        ld_ag_ld_inst;                      
wire                                        ld_ag_ldamo_inst;                   
wire    [15 :0]                             ld_ag_le_bytes_vld_cross;           
wire    [15 :0]                             ld_ag_le_bytes_vld_high_bits;       
wire    [15 :0]                             ld_ag_le_bytes_vld_low_cross_bits;  
wire                                        lag_lm_ex1_init_vld;                  
wire                                        lag_ex1_lr_inst;                      
wire    [LSIQENTRY-1 :0]                    ld_ag_mask_lsid;                    
wire                                        ld_ag_mmu_stall_req;                
wire                                        ld_ag_off_4k_high_bits_all_0_ori;   
wire                                        ld_ag_off_4k_high_bits_all_1_ori;   
wire                                        ld_ag_off_4k_high_bits_not_eq;      
wire    [63 :0]                             ld_ag_offset_aftershift;            
wire    [`WK_PA_WIDTH-1 :0]                 lag_ex1_pa;                           
wire                                        lag_ldc_ex1_page_buf;                     
wire                                        lag_ldc_ex1_page_ca;                      
wire                                        ld_ag_page_fault;                   
wire                                        lag_ldc_ex1_page_sec;                     
wire                                        lag_ldc_ex1_page_share;                   
wire                                        ld_ag_page_so;                      
wire                                        lag_ldc_ex1_pf_inst;                      
wire    [`WK_PA_WIDTH-13 :0]                ld_ag_pn;                           
//wire                        ld_ag_raw_new;
  wire                                      lag_ldc_ex1_raw0_new; 
  wire                                      lag_ldc_ex1_raw1_new;                        
wire    [15 :0]                             lag_ldc_ex1_reg_bytes_vld;                
wire    [15 :0]                             lag_ldc_ex1_reg_bytes_vld1; // wjh@us512
wire    [15 :0]                             lag_ldc_ex1_reg_bytes_vld2; // wjh@us512
wire    [15 :0]                             lag_ldc_ex1_reg_bytes_vld3; // wjh@us512
reg     [3  :0]                             lag_ldc_ex1_us_way;
reg     [3  :0]                             lag_ex1_us_way;
wire                                        ld_ag_secd_imme_stall;              
wire                                        ld_ag_stall_mask;                   
wire                                        lag_ex1_stall_ori;                    
wire                                        ld_ag_stall_restart;                
wire    [LSIQENTRY-1 :0]                    lag_ex1_stall_restart_entry;          
wire                                        ld_ag_stall_vld;                    
wire                                        ld_ag_struwk_stall_req;             
wire                                        ld_ag_struwk_stall4abort;
wire                                        ld_ag_tcm_hit;                      
wire                                        ld_ag_tcm_stall;                    
wire                                        ld_ag_unalign;                      
wire                                        ld_ag_unalign_so;                   
wire                                        lag_ldc_ex1_utlb_miss;                    
wire    [63 :0]                             ld_ag_va;                           
wire    [4  :0]                             ld_ag_va_add_access_size;           
wire    [63 :0]                             ld_ag_va_ori;                       
wire    [63 :0]                             ld_ag_va_plus;                      
wire                                        ld_ag_va_plus_sel;                  
wire    [`WK_PA_WIDTH-13:0]                 lag_ldc_ex1_vpn;                          
wire                                        ld_rf_inst_ldr;                     
wire                                        ld_rf_inst_vld;                     
wire                                        ld_rf_off_0_extend;                 
wire                                        lmul_sel2;                          
wire    [1  :0]                             lmul_sel4;                          
wire    [2  :0]                             lmul_sel8;                          
wire                                        lsu_hpcp_ld_stall_cross_4k;         
wire                                        lsu_hpcp_ld_stall_other;            
wire                                        lsu_idu_ex1_load_inst_vld;     
wire    [PREG-1  :0]                        lsu_idu_ex1_preg;         
//wire    [6  :0]             lsu_idu_ag_pipe3_preg_dup1;         
//wire    [6  :0]             lsu_idu_ag_pipe3_preg_dup2;         
//wire    [6  :0]             lsu_idu_ag_pipe3_preg_dup3;         
//wire    [6  :0]             lsu_idu_ag_pipe3_preg_dup4;         
wire                                        lsu_idu_ex1_vload_inst_vld;    
wire    [VREG  :0]                          lsu_idu_ex1_vreg;         
//wire    [VREG  :0]             lsu_idu_ag_pipe3_vreg_dup1;         
//wire    [VREG  :0]             lsu_idu_ag_pipe3_vreg_dup2;         
//wire    [VREG  :0]             lsu_idu_ag_pipe3_vreg_dup3;         

wire                                        rtu_ck_flush;
wire    [IID_WIDTH-1:0]                     rtu_ck_flush_iid;
wire                                        rtu_ck_flush_iid_older_than_rf_iid;
wire                                        rtu_ck_flush_iid_older_than_ex1_iid;
                
wire    [LSIQENTRY-1 :0]                    lsu_idu_ex1_wait_old;             
wire                                        lsu_idu_ex1_wait_old_gateclk_en;  
wire                                        lsu_mmu_abort;                     
wire    [IID_WIDTH-1:0]                     lsu_mmu_id;                        
wire                                        lsu_mmu_st_inst;                   
wire    [63 :0]                             lsu_mmu_va;                        
wire                                        lsu_mmu_va_vld;                    
wire                                        mmu_lsu_buf;                       
wire                                        mmu_lsu_ca;                        
wire    [`WK_PA_WIDTH-13:0]                 mmu_lsu_pa;                        
wire                                        mmu_lsu_pa_vld;                    
wire                                        mmu_lsu_page_fault;                
wire                                        mmu_lsu_access_fault;
wire                                        mmu_lsu_sec;                       
wire                                        mmu_lsu_sh;                        
wire                                        mmu_lsu_so;                        
wire                                        mmu_lsu_stall;                     
wire    [3  :0]                             offset_for_byte;                    
wire                                        offset_for_dword;                   
wire    [2  :0]                             offset_for_half;                    
wire    [1  :0]                             offset_for_word;                    
wire                                        pad_yy_icg_scan_en;                 
wire    [3  :0]                             reg_element_cnt;                    
wire                                        rf_iid_older_than_ld_ag;            
wire                                        rtu_lsu_flush_fe;                   
wire                                        rtu_yy_xx_commit0;                  
wire    [IID_WIDTH-1  :0]                   rtu_yy_xx_commit0_iid;              
wire                                        rtu_yy_xx_commit1;                  
wire    [IID_WIDTH-1  :0]                   rtu_yy_xx_commit1_iid;              
wire                                        rtu_yy_xx_commit2;                  
wire    [IID_WIDTH-1  :0]                   rtu_yy_xx_commit2_iid; 
wire                                        rtu_yy_xx_commit3;                  
wire   [IID_WIDTH-1  :0]                    rtu_yy_xx_commit3_iid;              
wire                                        rtu_yy_xx_commit4;                  
wire   [IID_WIDTH-1  :0]                    rtu_yy_xx_commit4_iid;              
wire                                        rtu_yy_xx_commit5;                  
wire   [IID_WIDTH-1  :0]                    rtu_yy_xx_commit5_iid;              
wire   [IID_WIDTH-1  :0]                    lsag0_ex1_iid;    
wire   [IID_WIDTH-1  :0]                    lsag1_ex1_iid;                           
wire    [511:0]                             vector_mask_full; // wjh@us512, 127
wire    [9  :0]                             vl;               // wjh@us512
wire    [9  :0]                             vl_dis;           // wjh@us512
wire    [15 :0]                             vmask_16_active;                    
wire    [15 :0]                             vmask_16_bf_rot;                    
wire    [15 :0]                             vmask_active_16;                    
//wire    [15 :0]                             vmask_mlen16_16;  // not use in rvv1.0 @hcl                  
//wire    [15 :0]                             vmask_mlen2_16;   // not use in rvv1.0 @hcl                  
//wire    [15 :0]                             vmask_mlen32_16;  // not use in rvv1.0 @hcl                  
//wire    [15 :0]                             vmask_mlen4_16;   // not use in rvv1.0 @hcl                  
//wire    [63 :0]                             vmask_mlen4_64;   // not use in rvv1.0 @hcl                  
//wire    [15 :0]                             vmask_mlen64_16;  // not use in rvv1.0 @hcl                  
//wire    [15 :0]                             vmask_mlen8_16;   // not use in rvv1.0 @hcl                  
wire    [15 :0]                             vmask_rot_sel;                      
wire    [`VSTART_WIDTH-1  :0]                             vstart;                             
wire    [`VSTART_WIDTH  :0]                             vstart_dis;                         
reg     [PC_LEN-1:0]                        lag_ex1_sfp_dst_pc;
reg                                         lag_ex1_sfp_pc_hit;
wire    [8  :0]                             ag_vmsk_elemnt_cnt; // wjh@us512
wire    [8  :0]                             ag_vmsk_reg_cnt;    // wjh@us512
// wjh@us512
reg                                         lag_us_tag_req_success;
wire                                        lag_us_tag_req;
wire                                        lag_us_tag_req_success_set;
reg                                         lag_us_tag_req_success_flop;
wire                                        lag_us_tag_req_stall;
wire                                        lag_us_tag_ack_stall;
// wire                                        lag_dcache_arb_ex1_us_data_req;
wire    [3  :0]                             lag_us_tag_hit_way;
wire    [1  :0]                             lag_us_settle_way;
wire                                        lag_us_misalign_no_page;
wire                                        lag_us_misalign_with_page;
wire                                        lag_stall_ori_tlbmiss_not_abort;

wire    [1  :0]             ld_ag_vmew;
wire    [1  :0]             ld_ag_vmop;
wire                        ld_ag_nf;
wire                        ld_ag_us;
wire                        ld_ag_vmew64;
wire    [63:0]              lag_us_bytes_vld;

//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
//==========================================================
//                  Risc-V Debug zdb End 
//==========================================================

parameter S_BYTE        = 2'b00,
          HALF        = 2'b01,
          WORD        = 2'b10,
          DWORD       = 2'b11;

//parameter LSIQENTRY  = 12;
//parameter VMBENTRY   = 8;
//parameter PC_LEN      = 15;

//==========================================================
//                        RF signal
//==========================================================
assign ld_rf_inst_vld         = idu_lsu_rf_gateclk_sel;
assign ld_rf_inst_ldr         = idu_lsu_rf_inst_ldr;
assign ld_rf_off_0_extend     = idu_lsu_rf_off_zext ;
//==========================================================
//                 Instance of Gated Cell  
//==========================================================
assign ld_ag_clk_en = idu_lsu_rf_gateclk_sel || ld_ag_inst_stall_gateclk_en || ld_ag_already_cross_page_ldr_imme;
// &Instance("gated_clk_cell", "x_lsu_ld_ag_gated_clk"); @52
gated_clk_cell  x_lsu_ld_ag_gated_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (ld_ag_clk         ),
  .external_en        (1'b0              ),
  .local_en           (ld_ag_clk_en      ),
  .module_en          (cp0_lsu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect(.clk_in        (forever_cpuclk     ), @53
//          .external_en   (1'b0               ), @54
//          .module_en     (cp0_lsu_icg_en     ), @55
//          .local_en      (ld_ag_clk_en       ), @56
//          .clk_out       (ld_ag_clk          )); @57

//==========================================================
//                 Pipeline Register
//==========================================================
//------------------control part----------------------------
//+----------+
//| inst_vld |
//+----------+
//if there is a stall in the AG stage ,the inst keep valid,
//elseif there is inst and no flush in RF stage,
//the inst goes to the AG stage next cycle

// &Force("output","lag_ex1_inst_vld"); @70
always @(posedge ctrl_ld_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    lag_ex1_inst_vld  <=  1'b0;
  else if(rtu_lsu_flush_fe)
    lag_ex1_inst_vld  <=  1'b0;
  else if(ld_ag_stall_vld)        //if stall_vld=1, ag older than rf
    lag_ex1_inst_vld  <=  ~(rtu_ck_flush && rtu_ck_flush_iid_older_than_ex1_iid);   //flush ex1->ex1 when stall, ck_flush@LTL
  else if(idu_lsu_rf_sel)
    lag_ex1_inst_vld  <=  ~(rtu_ck_flush && rtu_ck_flush_iid_older_than_rf_iid);    //flush rf->ex1 when stall, ck_flush@LTL
  //else if(ld_ag_stall_vld ||  idu_lsu_rf_sel)
  //  lag_ex1_inst_vld  <=  1'b1;
  else
    lag_ex1_inst_vld  <=  1'b0;
end

//------------------data part-------------------------------
//+-----------+-----------+------+------------+----------------+
//| inst_type | inst_size | secd | already_da | lsiq_spec_fail |
//+-----------+-----------+------+------------+----------------+
//+-------------+----+-----+------+-----+------+
//| sign_extend | ex | iid | lsid | old | preg |
//+-------------+----+-----+------+-----+------+
//+-----------+----------------+-------+
//| ldfifo_pc | unalign_permit | split |
//+-----------+----------------+-------+
//+-------+-------+
//| bkpta | bkptb |
//+-------+-------+
//if there is a stall in the AG stage ,the inst info keep unchanged,
//elseif there is inst in RF stage, the inst goes to the AG stage next cycle

// &Force("bus","idu_lsu_rf_vreg",6,0); @99
// &Force("output","lag_ldc_ex1_split"); @100
// &Force("output","lag_ldc_ex1_inst_type"); @101
// &Force("output","lag_ldc_ex1_secd"); @102
// &Force("output","lag_ldc_ex1_already_da"); @103
// &Force("output","lag_ldc_ex1_lsiq_spec_fail"); @104
// &Force("output","lag_ldc_ex1_lsiq_bkpta_data"); @105
// &Force("output","lag_ldc_ex1_lsiq_bkptb_data"); @106
// &Force("output","lag_ldc_ex1_sext"); @107
// &Force("output","lag_ldc_ex1_atomic"); @108
// &Force("output","lag0_ex1_iid"); @109
// &Force("output","lag_ldc_ex1_lsid"); @110
// &Force("output","lag_ldc_ex1_old"); @111
// &Force("output","lag_ldc_ex1_preg"); @112
// &Force("output","lag_ldc_ex1_vreg"); @113
// &Force("output","lag_ldc_ex1_ldfifo_pc"); @114
always @(posedge ld_ag_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    lag_ldc_ex1_split                 <=  1'b0;
    lag_ldc_ex1_inst_type[1:0]        <=  2'b0;
    ld_ag_inst_size[1:0]        <=  2'b0;
    //ld_ag_inst_code[31:0]       <=  32'b0;
    lag_ldc_ex1_secd                  <=  1'b0;
    lag_ldc_ex1_already_da            <=  1'b0;
    lag_ldc_ex1_lsiq_spec_fail        <=  1'b0;
    lag_ldc_ex1_sext           <=  1'b0;
    lag_ldc_ex1_atomic                <=  1'b0;
    lag0_ex1_iid[IID_WIDTH-1:0]              <=  {IID_WIDTH{1'b0}};
    // lag_ex1_lsid[LSIQENTRY-1:0]       <= idu_lsu_rf_lch_entry[LSIQENTRY-1:0];
    lag_ldc_ex1_old                   <=  1'b0;
    lag_ldc_ex1_preg[PREG-1:0]             <=  {PREG{1'b0}};
    lag_ldc_ex1_ldfifo_pc[PC_LEN-1:0] <=  {PC_LEN{1'b0}};
    lag_ldc_ex1_vreg[VREG-1:0]             <=  {VREG{1'b0}};
    ld_ag_inst_ldr              <=  1'b0;
    ld_ag_inst_fls              <=  1'b0;
    ld_ag_lsfifo                <=  1'b0;
    lag_ldc_ex1_no_spec[1:0]          <=  2'b0;
    lag_ldc_ex1_no_spec_exist         <=  1'b0;
    lag_ldc_ex1_inst_vls              <=  1'b0;
    ld_ag_vls_size[3:0]         <=  4'b0;
    ld_ag_vector_mask[511:0]    <=  512'b0; // wjh@us512, 127
    lag_ldc_ex1_inst_fof              <=  1'b0;
    lag_ldc_ex1_vmb_merge_vld         <=  1'b0;
    lag_ldc_ex1_vmb_id[VMBENTRY-1:0] <=  {VMBENTRY{1'b0}};
    //lag_ldc_ex1_vsew[1:0]             <=  2'b0;// not use in rvv1.0 @hcl 
    //ld_ag_mlen[2:0]             <=  3'b0; //// not use in rvv1.0 @hcl
    lag_ldc_ex1_vmew[1:0]             <=  2'b0;
    lag_ldc_ex1_vmop[1:0]             <=  2'b0;
    lag_ldc_ex1_nf                    <=  1'b0;
    // lag_ldc_ex1_vlmul[1:0]            <=  2'b0;
      lag_ldc_ex1_vlmul[2:0]            <=  3'b0; 
    ld_ag_split_cnt[8:0]        <=  9'b0; // wjh@us512
    ld_ag_unit_stride           <=  1'b0;
    ld_ag_vmask_vld             <=  1'b0;
    ld_ag_vl[`VL_WIDTH-1:0]               <=  {`VL_WIDTH{1'b0}};
    lag_ex1_lsid[LSIQENTRY-1:0]  <= {LSIQENTRY{1'b0}}; // wjh@lrq
    lag_lrq_pa_vld               <= 1'b0;                    // wjh@lrq
    lag_lrq_pa                   <= {`WK_PA_WIDTH-12{1'b0}}; // wjh@lrq
    lag_lrq_attr                 <= {5{1'b0}};               // wjh@lrq
    lag_lrq_replay_vld           <= 1'b0;                    // wjh@lrq
    lag_lrq_va                   <= {64{1'b0}};              // wjh@lrq
    lag_lrq_bytes_vld            <= {16{1'b0}};              // wjh@lrq
    lag_lrq_bytes_vld1           <= {16{1'b0}};              // wjh@lrq
    lag_lrq_bytes_vld2           <= {16{1'b0}};              // wjh@lrq
    lag_lrq_bytes_vld3           <= {16{1'b0}};              // wjh@lrq
    lag_lrq_reg_bytes_vld        <= {16{1'b0}};              // wjh@lrq
    lag_lrq_reg_bytes_vld1       <= {16{1'b0}};              // wjh@lrq
    lag_lrq_reg_bytes_vld2       <= {16{1'b0}};              // wjh@lrq
    lag_lrq_reg_bytes_vld3       <= {16{1'b0}};              // wjh@lrq
    lag_lrq_boundary             <= 1'b0;                    // wjh@lrq
    lag_ex1_sfp_dst_pc           <= {PC_LEN{1'b0}};
    lag_ex1_sfp_pc_hit           <= 1'b0;
  end
  else if(!ld_ag_stall_vld  &&  ld_rf_inst_vld)
  begin
    lag_ldc_ex1_split                 <=  idu_lsu_rf_split;
    lag_ldc_ex1_inst_type[1:0]        <=  idu_lsu_rf_inst_type[1:0];
    ld_ag_inst_size[1:0]        <=  idu_lsu_rf_inst_size[1:0];
    //ld_ag_inst_code[31:0]       <=  idu_lsu_rf_pipe3_inst_code[31:0];
    lag_ldc_ex1_secd                  <=  idu_lsu_rf_unal2nd;
    lag_ldc_ex1_already_da            <=  idu_lsu_rf_already_da;
    lag_ldc_ex1_lsiq_spec_fail        <=  idu_lsu_rf_spec_fail;
    lag_ldc_ex1_sext           <=  idu_lsu_rf_sext;
    lag_ldc_ex1_atomic                <=  idu_lsu_rf_atomic;
    lag0_ex1_iid[IID_WIDTH-1:0]              <=  idu_lsu_rf_iid[IID_WIDTH-1:0];
    lag_ex1_lsid[LSIQENTRY-1:0]  <=  idu_lsu_rf_lch_entry[LSIQENTRY-1:0]; // wjh@lrq
    lag_ldc_ex1_old                   <=  idu_lsu_rf_oldest;
    lag_ldc_ex1_preg[PREG-1:0]             <=  idu_lsu_rf_preg[PREG-1:0];
    lag_ldc_ex1_ldfifo_pc[PC_LEN-1:0] <=  idu_lsu_rf_pc[PC_LEN-1:0];
    lag_ldc_ex1_vreg[VREG-1:0]             <=  idu_lsu_rf_vreg[VREG-1:0];
    ld_ag_inst_ldr              <=  idu_lsu_rf_inst_ldr;
    ld_ag_inst_fls              <=  idu_lsu_rf_inst_fls;
    ld_ag_lsfifo                <=  idu_lsu_rf_lsfifo;
    lag_ldc_ex1_no_spec[1:0]          <=  idu_lsu_rf_no_spec [1:0];
    lag_ldc_ex1_no_spec_exist         <=  idu_lsu_rf_no_spec_exist ;
    lag_ldc_ex1_inst_vls              <=  idu_lsu_rf_inst_vls;
    ld_ag_vls_size[3:0]         <=  idu_lsu_rf_vls_size[3:0];
    ld_ag_vector_mask[511:0]    <=  {idu_lsu_rf_srcvm_vr1[255:0],idu_lsu_rf_srcvm_vr0[255:0]}; // wjh@us512, 127,63
    lag_ldc_ex1_inst_fof              <=  idu_lsu_rf_inst_fof;
    lag_ldc_ex1_vmb_merge_vld         <=  idu_lsu_rf_vmb_merge_vld;
    lag_ldc_ex1_vmb_id[VMBENTRY-1:0] <=  idu_lsu_rf_vmb_id[VMBENTRY-1:0];
    //lag_ldc_ex1_vsew[1:0]             <=  idu_lsu_rf_vsew[1:0]; // not use in rvv1.0 @hcl 
    //ld_ag_mlen[2:0]             <=  idu_lsu_rf_mlen [2:0];// not use in rvv1.0 @hcl
    lag_ldc_ex1_vmew[1:0]             <=  idu_lsu_rf_vmew[1:0];
    lag_ldc_ex1_vmop[1:0]             <=  idu_lsu_rf_vmop[1:0];
    lag_ldc_ex1_nf                    <=  idu_lsu_rf_nf;
    // lag_ldc_ex1_vlmul[1:0]            <=  idu_lsu_rf_vlmul[1:0];
    lag_ldc_ex1_vlmul[2:0]            <=  idu_lsu_rf_vlmul[2:0];  
    ld_ag_split_cnt[8:0]        <=  idu_lsu_rf_split_num[8:0]; // wjh@us512
    ld_ag_unit_stride           <=  idu_lsu_rf_unit_stride;
    ld_ag_vmask_vld             <=  idu_lsu_rf_vmask_vld;
    ld_ag_vl[`VL_WIDTH-1:0]               <=  idu_lsu_rf_vl[`VL_WIDTH-1:0];
    lag_lrq_pa_vld              <=  lrq_lsu_rf_pa_vld;        //wjh@lrq
    lag_lrq_pa                  <=  lrq_lsu_rf_pa;            //wjh@lrq
    lag_lrq_attr                <=  lrq_lsu_rf_attr;          //wjh@lrq
    lag_ex1_sfp_dst_pc          <=  lrq_lsu_rf_sfp_dst_pc;
    lag_ex1_sfp_pc_hit          <=  lrq_lsu_rf_sfp_pc_hit;
    lag_lrq_replay_vld          <=  lrq_lsu_rf_replay_vld;    //wjh@lrq
    lag_lrq_va                  <=  lrq_lsu_rf_va;            //wjh@lrq
    lag_lrq_bytes_vld           <=  lrq_lsu_rf_bytes_vld;     //wjh@lrq
    lag_lrq_bytes_vld1          <=  lrq_lsu_rf_bytes_vld1;     //wjh@lrq
    lag_lrq_bytes_vld2          <=  lrq_lsu_rf_bytes_vld2;     //wjh@lrq
    lag_lrq_bytes_vld3          <=  lrq_lsu_rf_bytes_vld3;     //wjh@lrq
    lag_lrq_reg_bytes_vld       <=  lrq_lsu_rf_reg_bytes_vld; //wjh@lrq
    lag_lrq_reg_bytes_vld1      <=  lrq_lsu_rf_reg_bytes_vld1; //wjh@lrq
    lag_lrq_reg_bytes_vld2      <=  lrq_lsu_rf_reg_bytes_vld2; //wjh@lrq
    lag_lrq_reg_bytes_vld3      <=  lrq_lsu_rf_reg_bytes_vld3; //wjh@lrq
    lag_lrq_boundary            <=  lrq_lsu_rf_boundary;      //wjh@lrq
  end
end
//+------------------+
//| rtu_ck_flush |
//+------------------+
xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH)) 
x_lsu_ck_flush_compare_ex1_iid (
  .x_iid0                    (rtu_ck_flush_iid[IID_WIDTH-1:0]),
  .x_iid0_older              (rtu_ck_flush_iid_older_than_ex1_iid  ),
  .x_iid1                    (lag0_ex1_iid[IID_WIDTH-1:0]           )
);
xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH)) 
x_lsu_ck_flush_compare_rf_iid (
  .x_iid0                    (rtu_ck_flush_iid[IID_WIDTH-1:0]),
  .x_iid0_older              (rtu_ck_flush_iid_older_than_rf_iid  ),
  .x_iid1                    (idu_lsu_rf_iid[IID_WIDTH-1:0]           )
);
//+------------------+
//| already_cross_4k |
//+------------------+
//already cross 4k means addr1 is wrong, and mustn't merge from cache buffer
always @(posedge ld_ag_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    ld_ag_already_cross_page_ldr_imme  <=  1'b0;
  else if (!ld_ag_stall_vld)
    ld_ag_already_cross_page_ldr_imme  <=  1'b0;
  else if(ld_ag_stall_vld &&  ld_ag_cross_page_ldr_imme_stall_req)
    ld_ag_already_cross_page_ldr_imme  <=  1'b1;
end

//+--------------+
//| offset_shift |
//+--------------+
//if there is a stall in the AG stage ,offset_shift is reset to 0
//cache stall will not change shift
always @(posedge ld_ag_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    ld_ag_offset_shift[3:0] <=  4'b1;
  else if (!ld_ag_stall_vld &&  idu_lsu_rf_sel)
    ld_ag_offset_shift[3:0] <=  idu_lsu_rf_shift[3:0];
  else if(ld_ag_stall_vld && ld_ag_cross_page_ldr_imme_stall_req)
    ld_ag_offset_shift[3:0] <=  4'b1;
end

//+--------+
//| offset |
//+--------+
//if the 1st time boundary 2nd instruction stall, the offset set 16 for bias, else
//if stall, it set to 0, cache stall will not change offset
always @(posedge ld_ag_clk)
begin
  if(ld_ag_cross_page_ldr_imme_stall_arb)
    ld_ag_offset[63:32]  <=  32'h0;
  else if (!ld_ag_stall_vld &&  ld_rf_inst_vld  &&  !ld_rf_inst_ldr)
    ld_ag_offset[63:32]  <=  {32{idu_lsu_rf_offset[11]}};
  else if (!ld_ag_stall_vld &&  ld_rf_inst_vld  &&  ld_rf_inst_ldr  &&  ld_rf_off_0_extend)
    ld_ag_offset[63:32]  <=  32'h0;
  else if (!ld_ag_stall_vld &&  ld_rf_inst_vld)
    ld_ag_offset[63:32]  <=  idu_lsu_rf_src1[63:32];
end


always @(posedge ld_ag_clk)
begin
  if(ld_ag_cross_page_ldr_imme_stall_arb  &&  ld_ag_secd_imme_stall)
    ld_ag_offset[31:0]  <=  32'h10;
  else if(ld_ag_cross_page_ldr_imme_stall_arb)
    ld_ag_offset[31:0]  <=  32'h0;
  else if (!ld_ag_stall_vld &&  ld_rf_inst_vld  &&  !ld_rf_inst_ldr)
    ld_ag_offset[31:0]  <=  {{20{idu_lsu_rf_offset[11]}},idu_lsu_rf_offset[11:0]};
  else if (!ld_ag_stall_vld &&  ld_rf_inst_vld)
    ld_ag_offset[31:0]  <=  idu_lsu_rf_src1[31:0];
end

//+-------------+
//| offset_plus |
//+-------------+
//use this imm as offset when the ld/st inst need split and !secd
always @(posedge ld_ag_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    ld_ag_offset_plus[12:0]  <=  13'h0;
  else if(ld_ag_cross_page_ldr_imme_stall_arb)
    ld_ag_offset_plus[12:0]  <=  13'h0;
  else if (!ld_ag_stall_vld &&  ld_rf_inst_vld)
    ld_ag_offset_plus[12:0]  <=  idu_lsu_rf_offset_plus[12:0];
end

//+------+
//| base |
//+------+
//the base addr, if stall, the base is set the result from the adder
always @(posedge ld_ag_clk)
begin
  if(ld_ag_cross_page_ldr_imme_stall_arb)
    ld_ag_base[63:0]  <=  ld_ag_va[63:0];
  else if (!ld_ag_stall_vld &&  ld_rf_inst_vld)
    ld_ag_base[63:0]  <=  idu_lsu_rf_src0[63:0];
end

always @(posedge ld_ag_clk, negedge cpurst_b)begin 
  if(!cpurst_b)
    lag_lrq_create_already <= 1'b0;
  else if(!ld_ag_stall_vld && ld_rf_inst_vld)
    lag_lrq_create_already <= 1'b0;
  else if(!lag_lrq_replay_vld && ld_ag_stall_vld && !lag_lrq_create_already)
    lag_lrq_create_already <= 1'b1;
end

always @(posedge ld_ag_clk)begin 
  if(ld_ag_stall_vld && !lag_lrq_replay_vld && !lag_lrq_create_already)
    lag_lrq_lsid <= lrq_lsu_ex1_lrqid;
end

always @(posedge ld_ag_clk, negedge cpurst_b)begin 
  if(!cpurst_b)
    lag_bkcon_stall_already <= 1'b0;
  else if(!ld_ag_stall_vld && ld_rf_inst_vld)
    lag_bkcon_stall_already <= 1'b0;
  else if(lag_bkcon_stall_vld && !lag_bkcon_stall_already)
    lag_bkcon_stall_already <= 1'b1;
end

always @(posedge ld_ag_clk, negedge cpurst_b)begin 
  if(!cpurst_b)
    lag_bkcon_acfault <= 1'b0;
  else if(!ld_ag_stall_vld && ld_rf_inst_vld)
    lag_bkcon_acfault <= 1'b0;
  else if(lag_bkcon_stall_already && ld_ag_stall_vld && mmu_lsu_access_fault)
    lag_bkcon_acfault <= 1'b1;
end
assign lag_mmu_acfault = lag_bkcon_acfault
                         | mmu_lsu_access_fault & lag_bkcon_stall_already;
always @(posedge ld_ag_clk, negedge cpurst_b)begin 
  if(!cpurst_b)
    lag_bkcon_pgfault <= 1'b0;
  else if(!ld_ag_stall_vld && ld_rf_inst_vld)
    lag_bkcon_pgfault <= 1'b0;
  else if(lag_bkcon_stall_vld)
    lag_bkcon_pgfault <= mmu_lsu_page_fault && mmu_lsu_pa_vld;
end

always @(posedge ld_ag_clk, negedge cpurst_b) begin 
  if(!cpurst_b)
    lag_bkcon_tlbmiss <= 1'b0;
  else if(!ld_ag_stall_vld && ld_rf_inst_vld)
    lag_bkcon_tlbmiss <= 1'b0;
  else if(lag_bkcon_stall_vld) // stall_vld means va_vld=1
    lag_bkcon_tlbmiss <= !mmu_lsu_pa_vld;
end

always @(posedge ld_ag_clk, negedge cpurst_b)begin 
  if(!cpurst_b)
    lag_us_tag_req_success <= 1'b0;
  else if(!ld_ag_stall_vld && ld_rf_inst_vld)
    lag_us_tag_req_success <= 1'b0;
  else if(lag_us_tag_req_success_set)
    lag_us_tag_req_success <= 1'b1;
end
assign lag_us_tag_req_success_set = lag_ex1_inst_vld & lag_ldc_ex1_inst_vls
                                    & ld_ag_unit_stride
                                    & ~lag_us_tag_req_success
                                    & ~ld_ag_cross_page_ldr_imme_stall_req
                                    & ~ld_ag_struwk_stall_req;

assign lag_us_tag_req_stall = lag_ex1_inst_vld & lag_ldc_ex1_inst_vls
                              & ld_ag_unit_stride
                              & ~lag_us_tag_req_success;
assign lag_us_tag_ack_stall = lag_us_tag_req_success_flop
                              & lag_ex1_inst_vld
                              & lag_ldc_ex1_inst_vls
                              & ld_ag_unit_stride;
always @(posedge ld_ag_clk, negedge cpurst_b)begin 
  if(!cpurst_b)
    lag_us_tag_req_success_flop <= 1'b0;
  else if(!ld_ag_stall_vld && ld_rf_inst_vld)
    lag_us_tag_req_success_flop <= 1'b0;
  else if(lag_ex1_inst_vld & lag_ldc_ex1_inst_vls & ld_ag_unit_stride)
    lag_us_tag_req_success_flop <= lag_us_tag_req_success_set;
end
always @(posedge ld_ag_clk, negedge cpurst_b)begin 
  if(!cpurst_b)
    lag_ex1_us_way <= {4{1'b0}};
  else if(!ld_ag_stall_vld && ld_rf_inst_vld)
    lag_ex1_us_way <= 4'b0;
  else if(lag_us_tag_req_success_flop)
    lag_ex1_us_way <= lag_us_tag_hit_way;
end
// assign lag_ldc_ex1_us_way = lag_us_tag_req_success_flop? lag_us_tag_hit_way : lag_ex1_us_way;
assign lag_ldc_ex1_us_way = lag_ex1_us_way;
// assign lag_dcache_arb_ex1_us_data_req = lag_ex1_inst_vld & lag_ldc_ex1_inst_vls
//                                         & ld_ag_unit_stride
//                                         & lag_us_tag_req_success;
//==========================================================
//                      AG gateclk
//==========================================================
assign ld_ag_inst_stall_gateclk_en  = lag_ex1_inst_vld;

//==========================================================
//               Generate virtual address
//==========================================================
// for first boundary inst, use addr+offset+128 as va instead of addr+offset
//for secd boundary,use addr+offset as va
assign ld_ag_offset_aftershift[63:0]  = {64{ld_ag_offset_shift[0]}} & ld_ag_offset[63:0]
                                        | {64{ld_ag_offset_shift[1]}} & {ld_ag_offset[62:0],1'b0}
                                        | {64{ld_ag_offset_shift[2]}} & {ld_ag_offset[61:0],2'b0}
                                        | {64{ld_ag_offset_shift[3]}} & {ld_ag_offset[60:0],3'b0};

// assign ld_ag_va_ori[63:0]           = ld_ag_base[63:0]
//                                       + ld_ag_offset_aftershift[63:0];

assign ld_ag_va_ori[63:0]           = lag_lrq_replay_vld
                                      ? lag_lrq_va  // only lower four bits
                                      : ld_ag_base[63:0]
                                        + ld_ag_offset_aftershift[63:0];

assign ld_ag_va_plus[63:0]          = ld_ag_base[63:0]
                                      + {{51{ld_ag_offset_plus[12]}},ld_ag_offset_plus[12:0]};

//if misalign without page, then select ori va
assign ld_ag_va_plus_sel            = ld_ag_boundary_unmask
                                      &&  ld_ag_ld_inst 
                                      &&  !lag_ldc_ex1_secd
                                      &&  !lag_ldc_ex1_inst_us
                                      &&  !ld_ag_inst_ldr;

// assign ld_ag_va[63:0]               = ld_ag_va_plus_sel
//                                       ? ld_ag_va_plus[63:0]
//                                       : ld_ag_va_ori[63:0]; 
assign ld_ag_va[63:0]               = lag_lrq_replay_vld
                                      ? lag_lrq_va
                                      : ld_ag_va_plus_sel
                                        ? ld_ag_va_plus[63:0]
                                        : ld_ag_va_ori[63:0]; 
assign lsu_lrq_create_va                = ld_ag_va_plus_sel
                                          ? ld_ag_va_plus[63:0]
                                          : ld_ag_va_ori[63:0];

assign lag_ldc_ex1_vpn[`WK_PA_WIDTH-13:0]    = ld_ag_va[`WK_PA_WIDTH-1:12];

//==========================================================
//                Generate inst type
//==========================================================
//ld/ldr/lrw/pop/lrs is treated as ld inst
assign ld_ag_ld_inst      = !lag_ldc_ex1_atomic
                            &&  (lag_ldc_ex1_inst_type[1:0]  == 2'b00);
// &Force("output","lag_ex1_lr_inst"); @343
assign lag_ex1_lr_inst      = lag_ldc_ex1_atomic
                            &&  (lag_ldc_ex1_inst_type[1:0]  == 2'b01);
assign ld_ag_ldamo_inst   = lag_ldc_ex1_atomic
                            &&  (lag_ldc_ex1_inst_type[1:0]  == 2'b00);

//-------------need to prefetch inst------------------------
assign lag_ldc_ex1_pf_inst  = ld_ag_ld_inst
                        &&  !lag_ldc_ex1_split
                        &&  ld_ag_lsfifo
                        &&  !lag_ldc_ex1_secd;          //only 1st inst

// &Force("output", "lag_ldc_ex1_vmb_merge_vld"); @356
// &Force("output", "lag_ldc_ex1_inst_fof"); @357
assign lag_ldc_ex1_inst_vfls  = ld_ag_inst_fls || lag_ldc_ex1_inst_vls;
//==========================================================
//            Generate unalign, bytes_vld
//==========================================================
//---------------inst access size---------------
// access size is used to select bytes_vld and boundary judge
// &CombBeg; @370
always @( ld_ag_inst_size[1:0])
begin
case(ld_ag_inst_size[1:0])
  S_BYTE: ld_ag_access_size_ori[3:0] = 4'b0000;
  HALF: ld_ag_access_size_ori[3:0] = 4'b0001;
  WORD: ld_ag_access_size_ori[3:0] = 4'b0011;
  DWORD:ld_ag_access_size_ori[3:0] = 4'b0111;
  default:ld_ag_access_size_ori[3:0] = 4'b0;
endcase
// &CombEnd; @378
end
assign ld_ag_access_size[3:0] = lag_ldc_ex1_inst_vls ? ld_ag_vls_size[3:0]
                                               : ld_ag_access_size_ori[3:0];

// access_size pipedown to dc, used for biu req_size(strong order)
// &CombBeg; @387
always @( ld_ag_access_size[3:0])
begin
case(ld_ag_access_size[3:0])
  4'b0000: lag_ex1_dc_access_size[2:0] = 3'b000;  //byte
  4'b0001: lag_ex1_dc_access_size[2:0] = 3'b001;  //half
  4'b0011: lag_ex1_dc_access_size[2:0] = 3'b010;  //word
  4'b0111: lag_ex1_dc_access_size[2:0] = 3'b011;  //dword
  4'b1111: lag_ex1_dc_access_size[2:0] = 3'b100;  //qword
  default: lag_ex1_dc_access_size[2:0] = 3'b0;
endcase
// &CombEnd; @396
end
//----------------generate unalign--------------------------
//-----------unalign--------------------
// &CombBeg; @399
always @( ld_ag_inst_size[1:0]
       or ld_ag_va_ori[2:0])
begin
casez({ld_ag_inst_size[1:0],ld_ag_va_ori[2:0]})
  {S_BYTE,3'b???}:ld_ag_align = 1'b1;
  {HALF,3'b??0}:ld_ag_align = 1'b1;
  {WORD,3'b?00}:ld_ag_align = 1'b1;
  {DWORD,3'b000}:ld_ag_align = 1'b1;//NOTE:in risc-v isa, double inst misalign is set
                                    //     when double not align,
                                    //     but in csky, double misalign is set
                                    //     when word not align
  default:ld_ag_align  = 1'b0;
endcase
// &CombEnd; @410
end
assign ld_ag_unalign = !ld_ag_align;

// for strong order,only support access size aligned address
//&CombBeg;
//casez({ld_ag_access_size[3:0],ld_ag_va_ori[3:0]})
//  {4'b0000,4'b????}:ld_ag_align_so = 1'b1;       //byte
//  {4'b0001,4'b???0}:ld_ag_align_so = 1'b1;       //half
//  {4'b0011,4'b??00}:ld_ag_align_so = 1'b1;       //word
//  {4'b0111,4'b?000}:ld_ag_align_so = 1'b1;       //dword
//  {4'b1111,4'b0000}:ld_ag_align_so = 1'b1;       //qword
//  default:ld_ag_align_so  = 1'b0;
//endcase
//&CombEnd;
assign ld_ag_unalign_so = !ld_ag_align;

//---------------boundary---------------
assign ld_ag_va_add_access_size[4:0]  = {1'b0,ld_ag_va_ori[3:0]} + {1'b0,ld_ag_access_size[3:0]};
assign ld_ag_boundary_unmask  = lag_lrq_replay_vld // wjh@lrq
                                ? lag_lrq_boundary
                                : lag_ldc_ex1_inst_us
                                  ? |ld_ag_va_ori[5:0]
                                  : ld_ag_va_add_access_size[4];

// &Force("output", "lag_ldc_ex1_boundary"); @430
assign lag_ldc_ex1_boundary = (ld_ag_boundary_unmask
                            ||  lag_ldc_ex1_secd)
                        &&  ld_ag_ld_inst;

//----------------generate bytes_vld------------------------
//-----------in le/bev2-----------------
//the 2nd half boundary inst will +128, so va[3:0] of 2nd inst will not change
// &CombBeg; @438
always @( ld_ag_va_ori[3:0])
begin
case(ld_ag_va_ori[3:0])
  4'b0000:ld_ag_le_bytes_vld_high_bits_full[15:0] = 16'hffff;
  4'b0001:ld_ag_le_bytes_vld_high_bits_full[15:0] = 16'hfffe;
  4'b0010:ld_ag_le_bytes_vld_high_bits_full[15:0] = 16'hfffc;
  4'b0011:ld_ag_le_bytes_vld_high_bits_full[15:0] = 16'hfff8;
  4'b0100:ld_ag_le_bytes_vld_high_bits_full[15:0] = 16'hfff0;
  4'b0101:ld_ag_le_bytes_vld_high_bits_full[15:0] = 16'hffe0;
  4'b0110:ld_ag_le_bytes_vld_high_bits_full[15:0] = 16'hffc0;
  4'b0111:ld_ag_le_bytes_vld_high_bits_full[15:0] = 16'hff80;
  4'b1000:ld_ag_le_bytes_vld_high_bits_full[15:0] = 16'hff00;
  4'b1001:ld_ag_le_bytes_vld_high_bits_full[15:0] = 16'hfe00;
  4'b1010:ld_ag_le_bytes_vld_high_bits_full[15:0] = 16'hfc00;
  4'b1011:ld_ag_le_bytes_vld_high_bits_full[15:0] = 16'hf800;
  4'b1100:ld_ag_le_bytes_vld_high_bits_full[15:0] = 16'hf000;
  4'b1101:ld_ag_le_bytes_vld_high_bits_full[15:0] = 16'he000;
  4'b1110:ld_ag_le_bytes_vld_high_bits_full[15:0] = 16'hc000;
  4'b1111:ld_ag_le_bytes_vld_high_bits_full[15:0] = 16'h8000;
  default:ld_ag_le_bytes_vld_high_bits_full[15:0] = {16{1'bx}};
endcase
// &CombEnd; @458
end

// &CombBeg; @460
always @( ld_ag_va_add_access_size[3:0])
begin
case(ld_ag_va_add_access_size[3:0])
  4'b0000:ld_ag_le_bytes_vld_low_bits_full[15:0] = 16'h0001;
  4'b0001:ld_ag_le_bytes_vld_low_bits_full[15:0] = 16'h0003;
  4'b0010:ld_ag_le_bytes_vld_low_bits_full[15:0] = 16'h0007;
  4'b0011:ld_ag_le_bytes_vld_low_bits_full[15:0] = 16'h000f;
  4'b0100:ld_ag_le_bytes_vld_low_bits_full[15:0] = 16'h001f;
  4'b0101:ld_ag_le_bytes_vld_low_bits_full[15:0] = 16'h003f;
  4'b0110:ld_ag_le_bytes_vld_low_bits_full[15:0] = 16'h007f;
  4'b0111:ld_ag_le_bytes_vld_low_bits_full[15:0] = 16'h00ff;
  4'b1000:ld_ag_le_bytes_vld_low_bits_full[15:0] = 16'h01ff;
  4'b1001:ld_ag_le_bytes_vld_low_bits_full[15:0] = 16'h03ff;
  4'b1010:ld_ag_le_bytes_vld_low_bits_full[15:0] = 16'h07ff;
  4'b1011:ld_ag_le_bytes_vld_low_bits_full[15:0] = 16'h0fff;
  4'b1100:ld_ag_le_bytes_vld_low_bits_full[15:0] = 16'h1fff;
  4'b1101:ld_ag_le_bytes_vld_low_bits_full[15:0] = 16'h3fff;
  4'b1110:ld_ag_le_bytes_vld_low_bits_full[15:0] = 16'h7fff;
  4'b1111:ld_ag_le_bytes_vld_low_bits_full[15:0] = 16'hffff;
  default:ld_ag_le_bytes_vld_low_bits_full[15:0] = {16{1'bx}};
endcase
// &CombEnd; @480
end

assign ld_ag_le_bytes_vld_cross[15:0]       = ld_ag_le_bytes_vld_high_bits_full[15:0]
                                                & ld_ag_le_bytes_vld_low_bits_full[15:0];

assign ld_ag_le_bytes_vld_low_cross_bits[15:0]  = ld_ag_boundary_unmask
                                                  ? ld_ag_le_bytes_vld_low_bits_full[15:0]
                                                  : ld_ag_le_bytes_vld_cross[15:0]; 

assign ld_ag_le_bytes_vld_high_bits[15:0]   = ld_ag_le_bytes_vld_high_bits_full[15:0];
//-----------select bytes_vld-----------
assign ld_ag_bytes_vld_low_cross_bits[15:0] = ld_ag_le_bytes_vld_low_cross_bits[15:0];

assign ld_ag_bytes_vld_high_bits[15:0]  = ld_ag_le_bytes_vld_high_bits[15:0];

//used for 
//1.lq create
//2.da data_merge when acclr_en
//bytes_vld1 is the bytes_vld of lower addr when there is a first(bigger) boundary ld inst
assign ld_ag_bytes_vld1[15:0] =  ld_ag_bytes_vld_high_bits[15:0];

assign ld_ag_bytes_vld[15:0]  =  lag_ldc_ex1_secd
                                 ? ld_ag_bytes_vld_high_bits[15:0]
                                 : ld_ag_bytes_vld_low_cross_bits[15:0];
//==========================================================
//        vector mask
//==========================================================
//narrow vmask first to 16 bits
//for unit stride,split_cnt means lmul_cnt
//for other inst,split_cnt means element_cnt
// for rvv1.0   related logic is realized in submodule @hcl 
// start rvv1.0 vector mask here !!!
// &CombBeg; @512
/*   // element logic is realized in xx_lsu_vmask_gen!!! @hcl
always @( ld_ag_unit_stride
       or ld_ag_split_cnt[6:0]
       or lag_ldc_ex1_vsew[1:0])
begin
case({ld_ag_unit_stride,lag_ldc_ex1_vsew[1:0]})
  {1'b1,S_BYTE}: element_cnt[6:0] = {ld_ag_split_cnt[2:0],4'd0};
  {1'b1,HALF}: element_cnt[6:0] = {1'b0,ld_ag_split_cnt[2:0],3'b0};
  {1'b1,WORD}: element_cnt[6:0] = {2'b0,ld_ag_split_cnt[2:0],2'b0};
  {1'b1,DWORD}:element_cnt[6:0] = {3'b0,ld_ag_split_cnt[2:0],1'b0};
  default:element_cnt[6:0] = ld_ag_split_cnt[6:0];
endcase
// &CombEnd; @520
end
*/







// add extra signal in rvv1.0 functions @hcl 
assign ld_ag_vmew[1:0] = lag_ldc_ex1_vmew[1:0];
assign ld_ag_vmop[1:0] = lag_ldc_ex1_vmop[1:0];
assign ld_ag_nf = lag_ldc_ex1_nf;
assign ld_ag_vmew64    = ld_ag_vmew[1:0] == 2'b11;
assign ld_ag_us = (ld_ag_vmop[1:0] == 2'b00) && (!ld_ag_nf);
// &Force("output","lag_ldc_ex1_element_cnt"); @522
assign lag_ldc_ex1_element_cnt[8:0]  = ag_vmsk_elemnt_cnt[8:0];// wjh@us512, 6
assign vector_mask_full[511:0] = ld_ag_vector_mask[511:0]; // wjh@us512, 127
// rvv1.0 function @hcl  temp logic; may update soon
xx_lsu_vmask_gen x_wk_ldag_vmask_gen_0 (
  .ag_nf                          (     3'b0            ),  // temp not use @hcl
  .ag_nf58                        (     1'b0            ),  // temp not use @hcl 
  .ag_split_cnt                   (ld_ag_split_cnt      ),  //             
  .ag_us                          (ld_ag_us             ),  // use mop @hcl     
  .ag_us_sel                      (2'b00                ),
  .ag_vl                          (ld_ag_vl             ),  // t     
  .ag_vmask_vld                   (ld_ag_vmask_vld      ),  // input    mask   !op[25]         
  .ag_vmew                        (ld_ag_vmew           ),  // input       
  .ag_vmew64                      (ld_ag_vmew64         ),  // input         
  .ag_vmsk_elemnt_cnt             (ag_vmsk_elemnt_cnt   ),  // input          
  .cp0_lsu_vstart                 (cp0_lsu_vstart       ),  // input      
  .vector_mask_full               (vector_mask_full     ),  // input        
  .vmask_byte_sel                 (vmask_byte_sel       )   // output      
);
xx_lsu_vmask_gen x_wk_ldag_vmask_gen_1 (
  .ag_nf                          (     3'b0            ),  // temp not use @hcl
  .ag_nf58                        (     1'b0            ),  // temp not use @hcl 
  .ag_split_cnt                   (ld_ag_split_cnt      ),  //             
  .ag_us                          (ld_ag_us             ),  // use mop @hcl     
  .ag_us_sel                      (2'b01                ),
  .ag_vl                          (ld_ag_vl             ),  // t     
  .ag_vmask_vld                   (ld_ag_vmask_vld      ),  // input    mask   !op[25]         
  .ag_vmew                        (ld_ag_vmew           ),  // input       
  .ag_vmew64                      (ld_ag_vmew64         ),  // input         
  .ag_vmsk_elemnt_cnt             (/*floating      */   ),  // input          
  .cp0_lsu_vstart                 (cp0_lsu_vstart       ),  // input      
  .vector_mask_full               (vector_mask_full     ),  // input        
  .vmask_byte_sel                 (vmask_byte_sel1      )   // output      
);

xx_lsu_vmask_gen x_wk_ldag_vmask_gen_2 (
  .ag_nf                          (     3'b0            ),  // temp not use @hcl
  .ag_nf58                        (     1'b0            ),  // temp not use @hcl 
  .ag_split_cnt                   (ld_ag_split_cnt      ),  //             
  .ag_us                          (ld_ag_us             ),  // use mop @hcl     
  .ag_us_sel                      (2'b10                ),
  .ag_vl                          (ld_ag_vl             ),  // t     
  .ag_vmask_vld                   (ld_ag_vmask_vld      ),  // input    mask   !op[25]         
  .ag_vmew                        (ld_ag_vmew           ),  // input       
  .ag_vmew64                      (ld_ag_vmew64         ),  // input         
  .ag_vmsk_elemnt_cnt             (/*floating      */   ),  // input          
  .cp0_lsu_vstart                 (cp0_lsu_vstart       ),  // input      
  .vector_mask_full               (vector_mask_full     ),  // input        
  .vmask_byte_sel                 (vmask_byte_sel2      )   // output      
);

xx_lsu_vmask_gen x_wk_ldag_vmask_gen_3 (
  .ag_nf                          (     3'b0            ),  // temp not use @hcl
  .ag_nf58                        (     1'b0            ),  // temp not use @hcl 
  .ag_split_cnt                   (ld_ag_split_cnt      ),  //             
  .ag_us                          (ld_ag_us             ),  // use mop @hcl     
  .ag_us_sel                      (2'b11                ),
  .ag_vl                          (ld_ag_vl             ),  // t     
  .ag_vmask_vld                   (ld_ag_vmask_vld      ),  // input    mask   !op[25]         
  .ag_vmew                        (ld_ag_vmew           ),  // input       
  .ag_vmew64                      (ld_ag_vmew64         ),  // input         
  .ag_vmsk_elemnt_cnt             (/*floating      */   ),  // input          
  .cp0_lsu_vstart                 (cp0_lsu_vstart       ),  // input      
  .vector_mask_full               (vector_mask_full     ),  // input        
  .vmask_byte_sel                 (vmask_byte_sel3      )   // output      
);

//when mlen=1
/*
//assign lmul_sel8[2:0] = element_cnt[6:4]; // not use in rvv1.0 @hcl
 
// &CombBeg; @529
always @( vector_mask_full[79:32]
       or vector_mask_full[31:0]
       or vector_mask_full[127:80]
       or lmul_sel8[2:0])
begin
case({lmul_sel8[2:0]})
  3'b000: vmask_mlen1_16[15:0] = vector_mask_full[15:0];
  3'b001: vmask_mlen1_16[15:0] = vector_mask_full[31:16];
  3'b010: vmask_mlen1_16[15:0] = vector_mask_full[47:32];
  3'b011: vmask_mlen1_16[15:0] = vector_mask_full[63:48];
  3'b100: vmask_mlen1_16[15:0] = vector_mask_full[79:64];
  3'b101: vmask_mlen1_16[15:0] = vector_mask_full[95:80];
  3'b110: vmask_mlen1_16[15:0] = vector_mask_full[111:96];
  3'b111: vmask_mlen1_16[15:0] = vector_mask_full[127:112];
  default:vmask_mlen1_16[15:0] = {16{1'bx}};
endcase
// &CombEnd; @541
end

//when mlen=2
assign lmul_sel4[1:0]      = element_cnt[5:4];
 
// &CombBeg; @546
always @( vector_mask_full[63:0]
       or vector_mask_full[127:64]
       or lmul_sel4[1:0])
begin
case({lmul_sel4[1:0]})
  2'b00: vmask_mlen2_32[31:0] = vector_mask_full[31:0];
  2'b01: vmask_mlen2_32[31:0] = vector_mask_full[63:32];
  2'b10: vmask_mlen2_32[31:0] = vector_mask_full[95:64];
  2'b11: vmask_mlen2_32[31:0] = vector_mask_full[127:96];
  default:vmask_mlen2_32[31:0] = {32{1'bx}};
endcase
// &CombEnd; @554
end

assign vmask_mlen2_16[15:0] = {vmask_mlen2_32[30],
                               vmask_mlen2_32[28],
                               vmask_mlen2_32[26],
                               vmask_mlen2_32[24],
                               vmask_mlen2_32[22],
                               vmask_mlen2_32[20],
                               vmask_mlen2_32[18],
                               vmask_mlen2_32[16],
                               vmask_mlen2_32[14],
                               vmask_mlen2_32[12],
                               vmask_mlen2_32[10],
                               vmask_mlen2_32[8],
                               vmask_mlen2_32[6],
                               vmask_mlen2_32[4],
                               vmask_mlen2_32[2],
                               vmask_mlen2_32[0]};

//when mlen=4
assign lmul_sel2 = element_cnt[4];
 
assign vmask_mlen4_64[63:0] = lmul_sel2 
                              ? vector_mask_full[127:64]
                              : vector_mask_full[63:0];

assign vmask_mlen4_16[15:0] = {vmask_mlen4_64[60],
                               vmask_mlen4_64[56],
                               vmask_mlen4_64[52],
                               vmask_mlen4_64[48],
                               vmask_mlen4_64[44],
                               vmask_mlen4_64[40],
                               vmask_mlen4_64[36],
                               vmask_mlen4_64[32],
                               vmask_mlen4_64[28],
                               vmask_mlen4_64[24],
                               vmask_mlen4_64[20],
                               vmask_mlen4_64[16],
                               vmask_mlen4_64[12],
                               vmask_mlen4_64[8],
                               vmask_mlen4_64[4],
                               vmask_mlen4_64[0]};

//when mlen=8
assign vmask_mlen8_16[15:0] = {vector_mask_full[120],
                               vector_mask_full[112],
                               vector_mask_full[104],
                               vector_mask_full[96],
                               vector_mask_full[88],
                               vector_mask_full[80],
                               vector_mask_full[72],
                               vector_mask_full[64],
                               vector_mask_full[56],
                               vector_mask_full[48],
                               vector_mask_full[40],
                               vector_mask_full[32],
                               vector_mask_full[24],
                               vector_mask_full[16],
                               vector_mask_full[8],
                               vector_mask_full[0]};

//when mlen=16
assign vmask_mlen16_16[15:0] = {8'b0,
                                vector_mask_full[112],
                                vector_mask_full[96],
                                vector_mask_full[80],
                                vector_mask_full[64],
                                vector_mask_full[48],
                                vector_mask_full[32],
                                vector_mask_full[16],
                                vector_mask_full[0]};

//when mlen=32
assign vmask_mlen32_16[15:0] = {12'b0,
                                vector_mask_full[96],
                                vector_mask_full[64],
                                vector_mask_full[32],
                                vector_mask_full[0]};

//when mlen=64
assign vmask_mlen64_16[15:0] = {14'b0,
                                vector_mask_full[64],
                                vector_mask_full[0]};

//mlen select
// &CombBeg; @639
always @( vmask_mlen64_16[15:0]
       or vmask_mlen2_16[15:0]
       or vmask_mlen16_16[15:0]
       or ld_ag_mlen[2:0]
       or vmask_mlen32_16[15:0]
       or vmask_mlen4_16[15:0]
       or vmask_mlen8_16[15:0]
       or vmask_mlen1_16[15:0])
begin
case(ld_ag_mlen[2:0])
  3'b000:vmask_16[15:0] = vmask_mlen1_16[15:0];
  3'b001:vmask_16[15:0] = vmask_mlen2_16[15:0];
  3'b010:vmask_16[15:0] = vmask_mlen4_16[15:0];
  3'b011:vmask_16[15:0] = vmask_mlen8_16[15:0];
  3'b100:vmask_16[15:0] = vmask_mlen16_16[15:0];
  3'b101:vmask_16[15:0] = vmask_mlen32_16[15:0];
  3'b110:vmask_16[15:0] = vmask_mlen64_16[15:0];
  default:vmask_16[15:0] = {16{1'bx}};
endcase
// &CombEnd; @650
end
*/
//----------------vmask rot---------------------------------
//rot_sel
// &CombBeg; @654
/*    realized in submodule   @hcl
always @( element_cnt[3:0])
begin
case(element_cnt[3:0])
  4'h0:element_cnt_onehot[15:0] = 16'h0001;
  4'h1:element_cnt_onehot[15:0] = 16'h0002;
  4'h2:element_cnt_onehot[15:0] = 16'h0004;
  4'h3:element_cnt_onehot[15:0] = 16'h0008;
  4'h4:element_cnt_onehot[15:0] = 16'h0010;
  4'h5:element_cnt_onehot[15:0] = 16'h0020;
  4'h6:element_cnt_onehot[15:0] = 16'h0040;
  4'h7:element_cnt_onehot[15:0] = 16'h0080;
  4'h8:element_cnt_onehot[15:0] = 16'h0100;
  4'h9:element_cnt_onehot[15:0] = 16'h0200;
  4'ha:element_cnt_onehot[15:0] = 16'h0400;
  4'hb:element_cnt_onehot[15:0] = 16'h0800;
  4'hc:element_cnt_onehot[15:0] = 16'h1000;
  4'hd:element_cnt_onehot[15:0] = 16'h2000;
  4'he:element_cnt_onehot[15:0] = 16'h4000;
  4'hf:element_cnt_onehot[15:0] = 16'h8000;
  default:element_cnt_onehot[15:0] = {16{1'bx}};
endcase
// &CombEnd; @674
end

assign vmask_16_active[15:0] = ld_ag_vmask_vld
                               ? vmask_16[15:0]
                               : 16'hffff;

assign vmask_rot_sel[15:0]   = element_cnt_onehot[15:0];
assign vmask_16_bf_rot[15:0] = vmask_16_active[15:0];

// &CombBeg; @683
always @( vmask_rot_sel[15:0]
       or vmask_16_bf_rot[15:0])
begin
case(vmask_rot_sel[15:0])
  16'h0001:vmask_16_aft_rot[15:0] = vmask_16_bf_rot[15:0];
  16'h0002:vmask_16_aft_rot[15:0] = {vmask_16_bf_rot[0],vmask_16_bf_rot[15:1]};
  16'h0004:vmask_16_aft_rot[15:0] = {vmask_16_bf_rot[1:0],vmask_16_bf_rot[15:2]};
  16'h0008:vmask_16_aft_rot[15:0] = {vmask_16_bf_rot[2:0],vmask_16_bf_rot[15:3]};
  16'h0010:vmask_16_aft_rot[15:0] = {vmask_16_bf_rot[3:0],vmask_16_bf_rot[15:4]};
  16'h0020:vmask_16_aft_rot[15:0] = {vmask_16_bf_rot[4:0],vmask_16_bf_rot[15:5]};
  16'h0040:vmask_16_aft_rot[15:0] = {vmask_16_bf_rot[5:0],vmask_16_bf_rot[15:6]};
  16'h0080:vmask_16_aft_rot[15:0] = {vmask_16_bf_rot[6:0],vmask_16_bf_rot[15:7]};
  16'h0100:vmask_16_aft_rot[15:0] = {vmask_16_bf_rot[7:0],vmask_16_bf_rot[15:8]};
  16'h0200:vmask_16_aft_rot[15:0] = {vmask_16_bf_rot[8:0],vmask_16_bf_rot[15:9]};
  16'h0400:vmask_16_aft_rot[15:0] = {vmask_16_bf_rot[9:0],vmask_16_bf_rot[15:10]};
  16'h0800:vmask_16_aft_rot[15:0] = {vmask_16_bf_rot[10:0],vmask_16_bf_rot[15:11]};
  16'h1000:vmask_16_aft_rot[15:0] = {vmask_16_bf_rot[11:0],vmask_16_bf_rot[15:12]};
  16'h2000:vmask_16_aft_rot[15:0] = {vmask_16_bf_rot[12:0],vmask_16_bf_rot[15:13]};
  16'h4000:vmask_16_aft_rot[15:0] = {vmask_16_bf_rot[13:0],vmask_16_bf_rot[15:14]};
  16'h8000:vmask_16_aft_rot[15:0] = {vmask_16_bf_rot[14:0],vmask_16_bf_rot[15]};
  default:vmask_16_aft_rot[15:0] = {16{1'bx}};
endcase
// &CombEnd; @703
end

//after rot,vstart and vl should also be considered
assign vstart[6:0] = cp0_lsu_vstart[6:0];
assign vl[7:0]     = ld_ag_vl[7:0];

assign vstart_dis[7:0] = {1'b0,vstart[6:0]} + {1'b0,~element_cnt[6:0]} + 1'b1;

assign vl_dis[7:0]  = {1'b0,vl[6:0]} + {1'b0,~element_cnt[6:0]}; //-1 for simplicity

assign all_active_for_vstart   = !vstart_dis[7];
assign all_active_for_vl       = vl_dis[7] && (|vl_dis[6:4])
                                 || vl[7];

assign all_inactive_for_vstart = vstart_dis[7] && (|vstart_dis[6:4]);
assign all_inactive_for_vl     = !vl_dis[7] && !vl[7];

// &CombBeg; @720
always @( vstart_dis[3:0])
begin
case(vstart_dis[3:0])
  4'b0000:active_with_vstart[15:0] = 16'hffff;
  4'b0001:active_with_vstart[15:0] = 16'hfffe;
  4'b0010:active_with_vstart[15:0] = 16'hfffc;
  4'b0011:active_with_vstart[15:0] = 16'hfff8;
  4'b0100:active_with_vstart[15:0] = 16'hfff0;
  4'b0101:active_with_vstart[15:0] = 16'hffe0;
  4'b0110:active_with_vstart[15:0] = 16'hffc0;
  4'b0111:active_with_vstart[15:0] = 16'hff80;
  4'b1000:active_with_vstart[15:0] = 16'hff00;
  4'b1001:active_with_vstart[15:0] = 16'hfe00;
  4'b1010:active_with_vstart[15:0] = 16'hfc00;
  4'b1011:active_with_vstart[15:0] = 16'hf800;
  4'b1100:active_with_vstart[15:0] = 16'hf000;
  4'b1101:active_with_vstart[15:0] = 16'he000;
  4'b1110:active_with_vstart[15:0] = 16'hc000;
  4'b1111:active_with_vstart[15:0] = 16'h8000;
  default:active_with_vstart[15:0] = {16{1'bx}};
endcase
// &CombEnd; @740
end

// &CombBeg; @742
always @( vl_dis[3:0])
begin
case(vl_dis[3:0])
  4'b0000:active_with_vl[15:0] = 16'h0001;
  4'b0001:active_with_vl[15:0] = 16'h0003;
  4'b0010:active_with_vl[15:0] = 16'h0007;
  4'b0011:active_with_vl[15:0] = 16'h000f;
  4'b0100:active_with_vl[15:0] = 16'h001f;
  4'b0101:active_with_vl[15:0] = 16'h003f;
  4'b0110:active_with_vl[15:0] = 16'h007f;
  4'b0111:active_with_vl[15:0] = 16'h00ff;
  4'b1000:active_with_vl[15:0] = 16'h01ff;
  4'b1001:active_with_vl[15:0] = 16'h03ff;
  4'b1010:active_with_vl[15:0] = 16'h07ff;
  4'b1011:active_with_vl[15:0] = 16'h0fff;
  4'b1100:active_with_vl[15:0] = 16'h1fff;
  4'b1101:active_with_vl[15:0] = 16'h3fff;
  4'b1110:active_with_vl[15:0] = 16'h7fff;
  4'b1111:active_with_vl[15:0] = 16'hffff;
  default:active_with_vl[15:0] = 16'b0;
endcase
// &CombEnd; @762
end

// &CombBeg; @764
always @( all_inactive_for_vstart
       or active_with_vstart[15:0]
       or all_active_for_vstart)
begin
case({all_active_for_vstart,all_inactive_for_vstart})
  2'b10:active_element_with_vstart[15:0] = 16'hffff;
  2'b01:active_element_with_vstart[15:0] = 16'h0000;
  default:active_element_with_vstart[15:0] = active_with_vstart[15:0];
endcase
// &CombEnd; @770
end

// &CombBeg; @772
always @( all_active_for_vl
       or all_inactive_for_vl
       or active_with_vl[15:0])
begin
case({all_active_for_vl,all_inactive_for_vl})
  2'b10:active_element_with_vl[15:0] = 16'hffff;
  2'b01:active_element_with_vl[15:0] = 16'h0000;
  default:active_element_with_vl[15:0] = active_with_vl[15:0];
endcase
// &CombEnd; @778
end

assign active_element[15:0] = active_element_with_vstart[15:0] & active_element_with_vl[15:0];

assign vmask_active_16[15:0] = vmask_16_aft_rot[15:0] & active_element[15:0];

//after rot,extend mask bit with memory element size for byte sel
// &CombBeg; @785
always @( ld_ag_inst_size[1:0]
       or vmask_active_16[15:0])
begin
case(ld_ag_inst_size[1:0])
  S_BYTE: vmask_byte_sel[15:0] = vmask_active_16[15:0];
  HALF: vmask_byte_sel[15:0] = {{2{vmask_active_16[7]}},
                                {2{vmask_active_16[6]}},
                                {2{vmask_active_16[5]}},
                                {2{vmask_active_16[4]}},
                                {2{vmask_active_16[3]}},
                                {2{vmask_active_16[2]}},
                                {2{vmask_active_16[1]}},
                                {2{vmask_active_16[0]}}};
  WORD: vmask_byte_sel[15:0] = {{4{vmask_active_16[3]}},
                                {4{vmask_active_16[2]}},
                                {4{vmask_active_16[1]}},
                                {4{vmask_active_16[0]}}}; 
  DWORD:vmask_byte_sel[15:0] = {{8{vmask_active_16[1]}},
                                {8{vmask_active_16[0]}}};
  default:vmask_byte_sel[15:0] = {16{1'bx}};
endcase
// &CombEnd; @804
end
*/
//rot again according to addr
// &CombBeg; @807
always @( vmask_byte_sel[15:0]
       or ld_ag_va_ori[3:0])
begin
case(ld_ag_va_ori[3:0])
  4'h0:vector_byte_mask[15:0] = vmask_byte_sel[15:0];
  4'h1:vector_byte_mask[15:0] = {vmask_byte_sel[14:0],vmask_byte_sel[15]};
  4'h2:vector_byte_mask[15:0] = {vmask_byte_sel[13:0],vmask_byte_sel[15:14]};
  4'h3:vector_byte_mask[15:0] = {vmask_byte_sel[12:0],vmask_byte_sel[15:13]};
  4'h4:vector_byte_mask[15:0] = {vmask_byte_sel[11:0],vmask_byte_sel[15:12]};
  4'h5:vector_byte_mask[15:0] = {vmask_byte_sel[10:0],vmask_byte_sel[15:11]};
  4'h6:vector_byte_mask[15:0] = {vmask_byte_sel[9:0],vmask_byte_sel[15:10]};
  4'h7:vector_byte_mask[15:0] = {vmask_byte_sel[8:0],vmask_byte_sel[15:9]};
  4'h8:vector_byte_mask[15:0] = {vmask_byte_sel[7:0],vmask_byte_sel[15:8]};
  4'h9:vector_byte_mask[15:0] = {vmask_byte_sel[6:0],vmask_byte_sel[15:7]};
  4'ha:vector_byte_mask[15:0] = {vmask_byte_sel[5:0],vmask_byte_sel[15:6]};
  4'hb:vector_byte_mask[15:0] = {vmask_byte_sel[4:0],vmask_byte_sel[15:5]};
  4'hc:vector_byte_mask[15:0] = {vmask_byte_sel[3:0],vmask_byte_sel[15:4]};
  4'hd:vector_byte_mask[15:0] = {vmask_byte_sel[2:0],vmask_byte_sel[15:3]};
  4'he:vector_byte_mask[15:0] = {vmask_byte_sel[1:0],vmask_byte_sel[15:2]};
  4'hf:vector_byte_mask[15:0] = {vmask_byte_sel[0],vmask_byte_sel[15:1]};
  default:vector_byte_mask[15:0] = {16{1'bx}};
endcase
// &CombEnd; @827
end

xx_lsu_us_bytes_gen x_xx_lsu_us_bytes_gen
(
  .ag_secd              (lag_ldc_ex1_secd),
  .ag_replay_vld        (lag_lrq_replay_vld),
  .ag_va_ori            (ld_ag_va_ori[5:0]),
  .vmask_byte_sel       (vmask_byte_sel),
  .vmask_byte_sel1      (vmask_byte_sel1),
  .vmask_byte_sel2      (vmask_byte_sel2),
  .vmask_byte_sel3      (vmask_byte_sel3),
  .lrq_bytes_vld        (lag_lrq_bytes_vld),
  .lrq_bytes_vld1       (lag_lrq_bytes_vld1),
  .lrq_bytes_vld2       (lag_lrq_bytes_vld2),
  .lrq_bytes_vld3       (lag_lrq_bytes_vld3),
  .lag_us_bytes_vld     (lag_us_bytes_vld)
);
// assign lag_ldc_ex1_bytes_vld[15:0]  = lag_lrq_replay_vld
//                                       ? lag_lrq_bytes_vld
//                                       : ~lag_ldc_ex1_inst_vls 
//                                         ? ld_ag_bytes_vld
//                                           : ld_ag_unit_stride
//                                             ? vmask_byte_sel
//                                             : ld_ag_bytes_vld[15:0]  & vector_byte_mask[15:0];
always @*
begin 
  casez({lag_lrq_replay_vld, lag_ldc_ex1_inst_vls, lag_ldc_ex1_inst_us})
  {1'b1, 1'b?, 1'b1}: lag_ldc_ex1_bytes_vld = lag_us_bytes_vld[15:0]; // replay us
  {1'b1, 1'b?, 1'b0}: lag_ldc_ex1_bytes_vld = lag_lrq_bytes_vld; // replay others
  {1'b0, 1'b1, 1'b0}: lag_ldc_ex1_bytes_vld = ld_ag_bytes_vld[15:0]  & vector_byte_mask[15:0]; // not-replay vls and not us
  {1'b0, 1'b1, 1'b1}: lag_ldc_ex1_bytes_vld = lag_us_bytes_vld[15:0]; // not-replay us
  {1'b0, 1'b0, 1'b?}: lag_ldc_ex1_bytes_vld = ld_ag_bytes_vld; // not replay not vls
  default:            lag_ldc_ex1_bytes_vld = {16{1'bx}};
  endcase
end
// assign lag_ldc_ex1_bytes_vld1[15:0] = lag_ldc_ex1_inst_vls ? ld_ag_bytes_vld1[15:0] & vector_byte_mask[15:0]
//                                                   : ld_ag_bytes_vld1[15:0] ;
// wjh@us512 todo may support cross-512-boundary
// assign lag_ldc_ex1_bytes_vld1[15:0] = lag_lrq_replay_vld
//                                       ? lag_lrq_bytes_vld1
//                                       : ~lag_ldc_ex1_inst_vls
//                                         ? ld_ag_bytes_vld1
//                                         : ld_ag_unit_stride
//                                           ? vmask_byte_sel1
//                                           : ld_ag_bytes_vld1 & vector_byte_mask;
always @*
begin
  casez({lag_lrq_replay_vld, lag_ldc_ex1_inst_vls, lag_ldc_ex1_inst_us})
  {1'b1, 1'b?, 1'b1}: lag_ldc_ex1_bytes_vld1 = lag_us_bytes_vld[31:16]; // replay us
  {1'b1, 1'b?, 1'b0}: lag_ldc_ex1_bytes_vld1 = lag_lrq_bytes_vld1; // replay others
  {1'b0, 1'b1, 1'b0}: lag_ldc_ex1_bytes_vld1 = ld_ag_bytes_vld1[15:0]  & vector_byte_mask[15:0]; // not-replay vls and not us
  {1'b0, 1'b1, 1'b1}: lag_ldc_ex1_bytes_vld1 = lag_us_bytes_vld[31:16]; // not-replay us
  {1'b0, 1'b0, 1'b?}: lag_ldc_ex1_bytes_vld1 = ld_ag_bytes_vld1; // not replay not vls
  default:            lag_ldc_ex1_bytes_vld1 = {16{1'bx}};
  endcase
end

// assign lag_ldc_ex1_bytes_vld2[15:0] = lag_lrq_replay_vld
//                                       ? lag_lrq_bytes_vld2
//                                       : vmask_byte_sel2;
assign lag_ldc_ex1_bytes_vld2 = lag_us_bytes_vld[47:32];
// assign lag_ldc_ex1_bytes_vld3[15:0] = lag_lrq_replay_vld
//                                       ? lag_lrq_bytes_vld3
//                                       : vmask_byte_sel3;
assign lag_ldc_ex1_bytes_vld3 = lag_us_bytes_vld[63:48];

assign lag_ldc_ex1_inst_us           = lag_ldc_ex1_inst_vls & ld_ag_unit_stride;
//------------------------------for vmb merge--------------------------------
//for vmb merge,reg bytes_vld is needed
//for not unit stride
// rvv1.0 @hcl 
//assign element_active = !(vstart_dis[7] && |vstart_dis[6:0]) 
//                        && (vl_dis[7] || vl[7]);
//
//assign element_active_aft_mask[15:0] = element_cnt_onehot[15:0] & vmask_16_active[15:0] & {16{element_active}};

// rvv1.0 @hcl 
xx_lsu_vreg_mask x_wk_ldag_vreg_mask(
  .ag_nf                          (      3'b0            ),// reserve, not use temp @hcl
  .ag_nf58                        (      1'b0            ),// reserve, not use temp @hcl  
  .ag_split_cnt                   (ld_ag_split_cnt      ),      // split num         
  .ag_us                          (ld_ag_us             ), // unit stride use rvv0.7  nf=0, temp not use  rvv1.0 mop=00 @hcl       
  .ag_us_sel                      (2'b00                ), // unit stride use rvv0.7  nf=0, temp not use  rvv1.0 mop=00 @hcl       
  .ag_vl                          (ld_ag_vl             ), // no modify @hcl     
  .ag_vmask_vld                   (ld_ag_vmask_vld      ), // no modify @hcl             
  .ag_vmew                        (ld_ag_vmew           ), // origin from idu_lspipe_rf                 
  .ag_vmsk_elemnt_cnt             (ag_vmsk_elemnt_cnt   ), // rvv1.0 function @hcl
  .ag_vmsk_reg_cnt                (ag_vmsk_reg_cnt      ), // output for rot            
  .cp0_lsu_vstart                 (cp0_lsu_vstart       ), 
  .reg_bytes_vld                  (reg_bytes_vld        ),       
  .vector_mask_full               (vector_mask_full     )              
);
xx_lsu_vreg_mask x_wk_ldag_vreg_mask_1(
  .ag_nf                          (      3'b0            ),// reserve, not use temp @hcl
  .ag_nf58                        (      1'b0            ),// reserve, not use temp @hcl  
  .ag_split_cnt                   (ld_ag_split_cnt      ),      // split num         
  .ag_us                          (ld_ag_us             ), // unit stride use rvv0.7  nf=0, temp not use  rvv1.0 mop=00 @hcl       
  .ag_us_sel                      (2'b01                ), // unit stride use rvv0.7  nf=0, temp not use  rvv1.0 mop=00 @hcl       
  .ag_vl                          (ld_ag_vl             ), // no modify @hcl     
  .ag_vmask_vld                   (ld_ag_vmask_vld      ), // no modify @hcl             
  .ag_vmew                        (ld_ag_vmew           ), // origin from idu_lspipe_rf                 
  .ag_vmsk_elemnt_cnt             (ag_vmsk_elemnt_cnt   ), // rvv1.0 function @hcl
  .ag_vmsk_reg_cnt                (/*floating*/         ), // output for rot            
  .cp0_lsu_vstart                 (cp0_lsu_vstart       ), 
  .reg_bytes_vld                  (reg_bytes_vld1        ),       
  .vector_mask_full               (vector_mask_full     )              
);
xx_lsu_vreg_mask x_wk_ldag_vreg_mask_2(
  .ag_nf                          (      3'b0            ),// reserve, not use temp @hcl
  .ag_nf58                        (      1'b0            ),// reserve, not use temp @hcl  
  .ag_split_cnt                   (ld_ag_split_cnt      ),      // split num         
  .ag_us                          (ld_ag_us             ), // unit stride use rvv0.7  nf=0, temp not use  rvv1.0 mop=00 @hcl       
  .ag_us_sel                      (2'b10                ), // unit stride use rvv0.7  nf=0, temp not use  rvv1.0 mop=00 @hcl       
  .ag_vl                          (ld_ag_vl             ), // no modify @hcl     
  .ag_vmask_vld                   (ld_ag_vmask_vld      ), // no modify @hcl             
  .ag_vmew                        (ld_ag_vmew           ), // origin from idu_lspipe_rf                 
  .ag_vmsk_elemnt_cnt             (ag_vmsk_elemnt_cnt   ), // rvv1.0 function @hcl
  .ag_vmsk_reg_cnt                (/*floating*/         ), // output for rot            
  .cp0_lsu_vstart                 (cp0_lsu_vstart       ), 
  .reg_bytes_vld                  (reg_bytes_vld2        ),       
  .vector_mask_full               (vector_mask_full     )              
);
xx_lsu_vreg_mask x_wk_ldag_vreg_mask_3(
  .ag_nf                          (      3'b0            ),// reserve, not use temp @hcl
  .ag_nf58                        (      1'b0            ),// reserve, not use temp @hcl  
  .ag_split_cnt                   (ld_ag_split_cnt      ),      // split num         
  .ag_us                          (ld_ag_us             ), // unit stride use rvv0.7  nf=0, temp not use  rvv1.0 mop=00 @hcl       
  .ag_us_sel                      (2'b11                ), // unit stride use rvv0.7  nf=0, temp not use  rvv1.0 mop=00 @hcl       
  .ag_vl                          (ld_ag_vl             ), // no modify @hcl     
  .ag_vmask_vld                   (ld_ag_vmask_vld      ), // no modify @hcl             
  .ag_vmew                        (ld_ag_vmew           ), // origin from idu_lspipe_rf                 
  .ag_vmsk_elemnt_cnt             (ag_vmsk_elemnt_cnt   ), // rvv1.0 function @hcl
  .ag_vmsk_reg_cnt                (/*floating*/         ), // output for rot            
  .cp0_lsu_vstart                 (cp0_lsu_vstart       ), 
  .reg_bytes_vld                  (reg_bytes_vld3        ),       
  .vector_mask_full               (vector_mask_full     )              
);

//rvv1.0 @hcl
xx_lsu_ld_vreg_rot x_wk_ldag_vreg_rot (
  .ag_nf                          (3'b0             ),
  .ag_nf58                        (1'b0             ),  
  .ag_split_cnt                   (ld_ag_split_cnt      ),            
  .ag_us                          (ld_ag_us             ),                       
  .ag_vmew                        (ld_ag_vmew           ),            
  .ag_vmsk_elemnt_cnt             (ag_vmsk_elemnt_cnt   ),  
  .ag_vmsk_reg_cnt                (ag_vmsk_reg_cnt      ),                 
  .reg_element_rot                (reg_element_rot      )             
);

/*
//change to reg element cnt
// &CombBeg; @843
always @( lag_ldc_ex1_vsew[1:0]
       or element_cnt[3:1])
begin
case(lag_ldc_ex1_vsew[1:0])
  S_BYTE: reg_element_start[3:0] = 4'b0;
  HALF: reg_element_start[3:0] = {element_cnt[3],3'b0};
  WORD: reg_element_start[3:0] = {element_cnt[3:2],2'b0};
  DWORD:reg_element_start[3:0] = {element_cnt[3:1],1'b0};
  default:reg_element_start[3:0] = {4{1'bx}};
endcase
// &CombEnd; @851
end

// &CombBeg; @853
always @( element_active_aft_mask[15:0]
       or reg_element_start[3:1])
begin
case(reg_element_start[3:1])
  3'd0:reg_element_vld[15:0] = element_active_aft_mask[15:0]; 
  3'd1:reg_element_vld[15:0] = {element_active_aft_mask[1:0],element_active_aft_mask[15:2]}; 
  3'd2:reg_element_vld[15:0] = {element_active_aft_mask[3:0],element_active_aft_mask[15:4]}; 
  3'd3:reg_element_vld[15:0] = {element_active_aft_mask[5:0],element_active_aft_mask[15:6]}; 
  3'd4:reg_element_vld[15:0] = {element_active_aft_mask[7:0],element_active_aft_mask[15:8]}; 
  3'd5:reg_element_vld[15:0] = {element_active_aft_mask[9:0],element_active_aft_mask[15:10]};
  3'd6:reg_element_vld[15:0] = {element_active_aft_mask[11:0],element_active_aft_mask[15:12]};
  3'd7:reg_element_vld[15:0] = {element_active_aft_mask[13:0],element_active_aft_mask[15:14]}; 
  default:reg_element_vld[15:0] = {16{1'bx}};
endcase
// &CombEnd; @865
end
*/
//element sel
/*   realized in xx_lsu_vreg_mask
assign element_vld_aft_mask[15:0] = ld_ag_unit_stride
                                    ? vmask_active_16[15:0]
                                    : reg_element_vld[15:0];
*/
//extend according to vsew
// &CombBeg; @873
/*   //VREG MASK instantiate RVV1.0 xx_lsu_vreg_mask @hcl 
always @( lag_ldc_ex1_vsew[1:0]
       or element_vld_aft_mask[15:0])
begin
case(lag_ldc_ex1_vsew[1:0])
  S_BYTE: reg_bytes_vld[15:0] = element_vld_aft_mask[15:0];
  HALF: reg_bytes_vld[15:0] = {{2{element_vld_aft_mask[7]}},
                                {2{element_vld_aft_mask[6]}},
                                {2{element_vld_aft_mask[5]}},
                                {2{element_vld_aft_mask[4]}},
                                {2{element_vld_aft_mask[3]}},
                                {2{element_vld_aft_mask[2]}},
                                {2{element_vld_aft_mask[1]}},
                                {2{element_vld_aft_mask[0]}}};
  WORD: reg_bytes_vld[15:0] = {{4{element_vld_aft_mask[3]}},
                                {4{element_vld_aft_mask[2]}},
                                {4{element_vld_aft_mask[1]}},
                                {4{element_vld_aft_mask[0]}}}; 
  DWORD:reg_bytes_vld[15:0] = {{8{element_vld_aft_mask[1]}},
                                {8{element_vld_aft_mask[0]}}};
  default:reg_bytes_vld[15:0] = {16{1'bx}};
endcase
// &CombEnd; @892
end
*/
//for element rot
/*
assign reg_element_cnt[3:0]  = element_cnt[3:0] - reg_element_start[3:0];

// &CombBeg; @897
always @( ld_ag_inst_size[1:0]
       or reg_element_cnt[3:0])
begin
case(ld_ag_inst_size[1:0])
  S_BYTE: reg_element_rot[3:0] = reg_element_cnt[3:0];
  HALF: reg_element_rot[3:0] = {reg_element_cnt[2:0],1'b0};
  WORD: reg_element_rot[3:0] = {reg_element_cnt[1:0],2'b0};
  DWORD:reg_element_rot[3:0] = {reg_element_cnt[0],3'b0};
  default:reg_element_rot[3:0] = {4{1'bx}};
endcase
// &CombEnd; @905
end
*/
//for fof vl change
//for unalign secd
//for misalign maintance
assign ld_ag_boundary_first = lag_ldc_ex1_boundary && !lag_ldc_ex1_secd; 

// &CombBeg; @912
always @( ld_ag_inst_size[1:0]
       or ld_ag_boundary_first
       or ld_ag_va_ori[3:0])
begin
case({ld_ag_boundary_first,ld_ag_inst_size[1:0]})
  {1'b1,HALF}:   ld_ag_va_round[3:0] = {ld_ag_va_ori[3:1],1'b0} + {2'b0,ld_ag_va_ori[0],1'b0}; 
  {1'b1,WORD}:   ld_ag_va_round[3:0] = {ld_ag_va_ori[3:2],2'b0} + {1'b0,|ld_ag_va_ori[1:0],2'b0}; 
  {1'b1,DWORD}:  ld_ag_va_round[3:0] = {ld_ag_va_ori[3],3'b0} + {|ld_ag_va_ori[2:0],3'b0};
  default:ld_ag_va_round[3:0] = ld_ag_va_ori[3:0];
endcase
// &CombEnd; @919
end

assign offset_for_byte[3:0] = ~ld_ag_va_round[3:0] + 4'h1; //16 - va
assign offset_for_half[2:0] = ~ld_ag_va_round[3:1] + 3'h1; //8 - va
assign offset_for_word[1:0] = ~ld_ag_va_round[3:2] + 2'h1; //4 - va
assign offset_for_dword     = ~ld_ag_va_round[3] + 1'h1;   //2 - va

// &CombBeg; @926
always @( ld_ag_inst_size[1:0]
       or offset_for_word[1:0]
       or offset_for_half[2:0]
       or offset_for_byte[3:0]
       or offset_for_dword)
begin
case(ld_ag_inst_size[1:0])
  S_BYTE:   element_offset_for_secd[3:0] = offset_for_byte[3:0]; 
  HALF:   element_offset_for_secd[3:0] = {1'b0,offset_for_half[2:0]}; 
  WORD:   element_offset_for_secd[3:0] = {2'b0,offset_for_word[1:0]}; 
  DWORD:  element_offset_for_secd[3:0] = {3'b0,offset_for_dword};
  default:element_offset_for_secd[3:0] = {4{1'bx}};
endcase
// &CombEnd; @934
end

//-------pipe to dc stage----------------------------------
// &Force("output","lag_ldc_ex1_vsew"); @937
// &Force("output","lag_ldc_ex1_inst_vls"); @938
assign lag_ldc_ex1_rot_sel[3:0] = lag_ldc_ex1_inst_vls && !ld_ag_unit_stride
                               ? ld_ag_va_ori[3:0] - reg_element_rot[3:0]
                               : ld_ag_va_ori[3:0];

assign lag_ldc_ex1_reg_bytes_vld[15:0] = lag_lrq_replay_vld // wjh@lrq
                                         ? lag_lrq_reg_bytes_vld[15:0]
                                         : reg_bytes_vld[15:0];
// wjh@us512
assign lag_ldc_ex1_reg_bytes_vld1[15:0] = lag_lrq_replay_vld // wjh@lrq
                                         ? lag_lrq_reg_bytes_vld1[15:0]
                                         : reg_bytes_vld1[15:0];
assign lag_ldc_ex1_reg_bytes_vld2[15:0] = lag_lrq_replay_vld // wjh@lrq
                                         ? lag_lrq_reg_bytes_vld2[15:0]
                                         : reg_bytes_vld2[15:0];
assign lag_ldc_ex1_reg_bytes_vld3[15:0] = lag_lrq_replay_vld // wjh@lrq
                                         ? lag_lrq_reg_bytes_vld3[15:0]
                                         : reg_bytes_vld3[15:0];
// end wjh@us512
assign lag_ldc_ex1_element_size[1:0]   = ld_ag_inst_size[1:0];

assign lag_ldc_ex1_element_offset[3:0] = element_offset_for_secd[3:0];

//==========================================================
//        MMU interface
//==========================================================
//-----------mmu input--------------------------------------
assign lsu_lrq_ex1_pa_set = 1'b0; // mmu_lsu_pa_vld 
                            // && !(lag_lrq_replay_vld && lag_lrq_pa_vld)
                            // && !mmu_lsu_page_fault
                            // && !lsu_mmu_abort; // the pa is not real pa in this case
assign lsu_lrq_ex1_pa     = mmu_lsu_pa[`WK_PA_WIDTH-13:0];
assign lsu_lrq_ex1_attr   = {mmu_lsu_sh, 
                             mmu_lsu_sec, 
                             mmu_lsu_buf, 
                             mmu_lsu_ca && mmu_lsu_pa_vld && !ld_ag_tcm_hit, 
                             mmu_lsu_so && mmu_lsu_pa_vld && !ld_ag_tcm_hit};
assign lsu_mmu_va_vld              = lag_ex1_inst_vld && !(lag_lrq_replay_vld && lag_lrq_pa_vld);
assign lsu_mmu_va[63:0]            = lag_lrq_replay_vld
                                     ? lag_lrq_va
                                     : ld_ag_base[63:0]; // wjh@lrq
// &Force("output","lsu_mmu_abort"); @959
assign lsu_mmu_abort               = ld_ag_cross_page_ldr_imme_stall_req
                                      ||  ld_ag_atomic_no_cmit_restart_req
                                      ||  ld_ag_not_replay_bar_chk // wjh@lrq
                                      ||  ld_ag_not_replay_no_spec_chk // wjh@lrq no_spec_chk need
                                      // ||  ld_ag_struwk_stall_req
                                      ||  lag_ldc_ex1_expt_misalign_no_page
                                      ||  rtu_ck_flush && rtu_ck_flush_iid_older_than_ex1_iid     //flush , abort mmu, ck_flush@LTL
                                      ||  lag_bkcon_tlbmiss // wjh@timing
                                      ||  lag_bkcon_pgfault // wjh@timing
                                      ||  lag_mmu_acfault
                                      ||  rtu_lsu_flush_fe;
assign lsu_mmu_id[IID_WIDTH-1:0]             = lag0_ex1_iid[IID_WIDTH-1:0];
assign lsu_mmu_st_inst             = ld_ag_ldamo_inst;

//-----------mmu output-------------------------------------
assign ld_ag_pn[`WK_PA_WIDTH-13:0]     = lag_lrq_replay_vld && lag_lrq_pa_vld
                                         ? lag_lrq_pa[`WK_PA_WIDTH-13:0]
                                         : mmu_lsu_pa[`WK_PA_WIDTH-13:0];
assign ld_ag_page_so        =  lag_lrq_replay_vld && lag_lrq_pa_vld
                               ? lag_lrq_attr[0]
                               : mmu_lsu_so && mmu_lsu_pa_vld;
assign lag_ldc_ex1_page_so     = ld_ag_page_so && !ld_ag_tcm_hit;
// &Force("output", "lag_ldc_ex1_page_ca"); @972
assign lag_ldc_ex1_page_ca        =  lag_lrq_replay_vld && lag_lrq_pa_vld
                                     ? lag_lrq_attr[1]
                                     : mmu_lsu_ca && mmu_lsu_pa_vld && !ld_ag_tcm_hit;
assign lag_ldc_ex1_page_buf       =  lag_lrq_replay_vld && lag_lrq_pa_vld
                                     ? lag_lrq_attr[2]
                                     : mmu_lsu_buf;
assign lag_ldc_ex1_page_sec       =  lag_lrq_replay_vld && lag_lrq_pa_vld
                                     ? lag_lrq_attr[3]
                                     : mmu_lsu_sec;
assign lag_ldc_ex1_page_share     =  lag_lrq_replay_vld && lag_lrq_pa_vld
                                     ? lag_lrq_attr[4]
                                     : mmu_lsu_sh;
// &Force("output","lag_ldc_ex1_utlb_miss"); @977
assign lag_ldc_ex1_utlb_miss      = !mmu_lsu_pa_vld && !(lag_lrq_replay_vld && lag_lrq_pa_vld)
                                    && !lag_bkcon_pgfault
                                    && !lag_mmu_acfault; // acflt/pgflt abort mmu access, hence make pa_vld=0, so mask them

assign ld_ag_page_fault     = mmu_lsu_page_fault;
//assign ld_ag_access_fault   = mmu_lsu_access_fault0;

//==========================================================
//        Generate physical address
//==========================================================
// &Force("output","lag_ex1_pa"); @986
assign lag_ex1_pa[`WK_PA_WIDTH-1:0]     = {ld_ag_pn[`WK_PA_WIDTH-13:0],ld_ag_va[11:0]};

//grs inst use va, rather than pa
assign ld_ag_addr0[`WK_PA_WIDTH-1:0]  = lag_ex1_pa[`WK_PA_WIDTH-1:0];

// used for boundary inst acceleration
assign lag_ldc_ex1_addr1_to4[`WK_PA_WIDTH-5:0] = ld_ag_va_ori[`WK_PA_WIDTH-1:4];
assign ld_ag_acclr_en         = lag_ldc_ex1_boundary
                                &&  !ld_ag_4k_sum_ori[12]
                                &&  !cp0_lsu_cb_aclr_dis
                                &&  !lag_ldc_ex1_secd
                                &&  !lag_ldc_ex1_inst_fof
                                &&  cp0_lsu_dcache_en
                                &&  !ld_ag_already_cross_page_ldr_imme
                                &&  !lsu_any_trig_en; // Risc-V Debug
//assign lag_acclr_en  =  1'b0;  //@wangyu
// &Force("output","lag_ldc_ex1_acclr_en");  @1002
assign lag_ldc_ex1_acclr_en     = ld_ag_acclr_en
                               && mmu_lsu_pa_vld
                               && lag_ldc_ex1_page_ca;

//fwd bypass is bypass data from pipe5 EX1 stage when ld is at AG stage
// used for ld fwd bypass what means
//only support byte,half,word,double word
// &CombBeg; @1010
always @( ld_ag_access_size[3:0])
begin
case(ld_ag_access_size[3:0])
  4'b0000: ld_ag_bypass_en = 1'b1;  //byte
  4'b0001: ld_ag_bypass_en = 1'b1;  //half
  4'b0011: ld_ag_bypass_en = 1'b1;  //word
  4'b0111: ld_ag_bypass_en = 1'b1;  //dword
  4'b1111: ld_ag_bypass_en = 1'b1;  //qword
  default: ld_ag_bypass_en = 1'b0;
endcase
// &CombEnd; @1019
end

assign lag_ldc_ex1_fwd_bypass_en = ld_ag_bypass_en
                                && !lag_ldc_ex1_inst_vls
                                && !lag_ldc_ex1_boundary;

//==========================================================
//        Generage commit signal
//==========================================================
assign ld_ag_cmit_hit0  = {rtu_yy_xx_commit0,rtu_yy_xx_commit0_iid[IID_WIDTH-1:0]}
                          ==  {1'b1,lag0_ex1_iid[IID_WIDTH-1:0]};
assign ld_ag_cmit_hit1  = {rtu_yy_xx_commit1,rtu_yy_xx_commit1_iid[IID_WIDTH-1:0]}
                          ==  {1'b1,lag0_ex1_iid[IID_WIDTH-1:0]};
assign ld_ag_cmit_hit2  = {rtu_yy_xx_commit2,rtu_yy_xx_commit2_iid[IID_WIDTH-1:0]}
                          ==  {1'b1,lag0_ex1_iid[IID_WIDTH-1:0]};
assign ld_ag_cmit_hit3  = {rtu_yy_xx_commit3,rtu_yy_xx_commit3_iid[IID_WIDTH-1:0]}
                          ==  {1'b1,lag0_ex1_iid[IID_WIDTH-1:0]};
assign ld_ag_cmit_hit4  = {rtu_yy_xx_commit4,rtu_yy_xx_commit4_iid[IID_WIDTH-1:0]}
                          ==  {1'b1,lag0_ex1_iid[IID_WIDTH-1:0]};
assign ld_ag_cmit_hit5  = {rtu_yy_xx_commit5,rtu_yy_xx_commit5_iid[IID_WIDTH-1:0]}
                          ==  {1'b1,lag0_ex1_iid[IID_WIDTH-1:0]};
// //&Force("output","ld_ag_cmit"); @1035
assign ld_ag_cmit       = ld_ag_cmit_hit0
                          ||  ld_ag_cmit_hit1
                          ||  ld_ag_cmit_hit2
                          ||  ld_ag_cmit_hit3
                          ||  ld_ag_cmit_hit4
                          ||  ld_ag_cmit_hit5;//@wangyu
                      

//==========================================================
//        Generage dcache request information
//==========================================================
assign ag_dcache_arb_ld_gateclk_en  = lag_ex1_inst_vld
                                      &&  cp0_lsu_dcache_en;

assign ld_ag_data_req_mask  = ld_ag_cross_page_ldr_imme_stall_req
                              | ld_ag_atomic_no_cmit_restart_req
                              | ld_ag_not_replay_bar_chk
                              | ld_ag_not_replay_no_spec_chk
                              | ld_ag_struwk_stall_req
                              | lag_bkcon_tlbmiss
                              | lag_bkcon_pgfault
                              | lag_ldc_ex1_expt_misalign_no_page
                              // | lag_mmu_acfault // for timing delete acfault
                              | rtu_lsu_flush_fe;
//for timing, delete mmu signal
assign ag_dcache_arb_ld_req = lag_ex1_inst_vld
                              &&  !ld_ag_tcm_hit
                              &&  !ld_ag_data_req_mask
                              &&  cp0_lsu_dcache_en;
//                              &&  !lag_ldc_ex1_expt_vld
//                              &&  !ld_ag_prior_stall_restart;
//                              &&  lag_ldc_ex1_page_ca
//                              &&  mmu_lsu_pa_vld;

//-----------tag array-------------------------------------
assign lag_dcache_arb_ex1_ld_tag_gateclk_en  = ag_dcache_arb_ld_gateclk_en;
assign lag_dcache_arb_ex1_ld_tag_req         = ag_dcache_arb_ld_req;
assign lag_dcache_arb_ex1_ld_tag_idx[7:0]    = lag_ex1_pa[13:6];  //8->7 14->13, L1D 2way->4way, LTL@20250319
assign lag_dcache_arb_ex1_bank_idx[1:0]      = ld_ag_va[7:6];          //2->1 8->7, L1D 2way->4way, LTL@20250319
//assign ag_dcache_arb_ld_tag_din[35:0] = 36'b0;
//assign ag_dcache_arb_ld_tag_wen[1:0]  = 2'b0;

//-----------data array------------------------------------
//------------data req signal-----------
// &CombBeg; @1064
always @( ld_ag_va_add_access_size[3:2]
       or ld_ag_va_ori[3:2]
       or lag_ldc_ex1_boundary
       or lag_ldc_ex1_secd)
begin
casez({lag_ldc_ex1_boundary,lag_ldc_ex1_secd,ld_ag_va_ori[3:2],ld_ag_va_add_access_size[3:2]})
  {1'b0,1'b?,2'b00,2'b00}:bank_en_low_ori[3:0] = 4'b0001;
  {1'b0,1'b?,2'b00,2'b01}:bank_en_low_ori[3:0] = 4'b0011;
  {1'b0,1'b?,2'b00,2'b10}:bank_en_low_ori[3:0] = 4'b0111;
  {1'b0,1'b?,2'b00,2'b11}:bank_en_low_ori[3:0] = 4'b1111;
  {1'b0,1'b?,2'b01,2'b01}:bank_en_low_ori[3:0] = 4'b0010;
  {1'b0,1'b?,2'b01,2'b10}:bank_en_low_ori[3:0] = 4'b0110;
  {1'b0,1'b?,2'b01,2'b11}:bank_en_low_ori[3:0] = 4'b1110;
  {1'b0,1'b?,2'b10,2'b10}:bank_en_low_ori[3:0] = 4'b0100;
  {1'b0,1'b?,2'b10,2'b11}:bank_en_low_ori[3:0] = 4'b1100;
  {1'b0,1'b?,2'b11,2'b11}:bank_en_low_ori[3:0] = 4'b1000;
  {1'b1,1'b0,2'b??,2'b00}:bank_en_low_ori[3:0] = 4'b0001;
  {1'b1,1'b0,2'b??,2'b01}:bank_en_low_ori[3:0] = 4'b0011;
  {1'b1,1'b0,2'b??,2'b10}:bank_en_low_ori[3:0] = 4'b0111;
  {1'b1,1'b0,2'b??,2'b11}:bank_en_low_ori[3:0] = 4'b1111;
  {1'b1,1'b1,2'b00,2'b??}:bank_en_low_ori[3:0] = 4'b1111;
  {1'b1,1'b1,2'b01,2'b??}:bank_en_low_ori[3:0] = 4'b1110;
  {1'b1,1'b1,2'b10,2'b??}:bank_en_low_ori[3:0] = 4'b1100;
  {1'b1,1'b1,2'b11,2'b??}:bank_en_low_ori[3:0] = 4'b1000;
  default:bank_en_low_ori[3:0]  = 4'b0;
endcase
// &CombEnd; @1086
end

//if unit-stride, it must access all banks for 128 bits
assign bank_en_low[3:0] = lag_ldc_ex1_inst_us ? 4'b1111: bank_en_low_ori[3:0];
//-------------for gateclk--------------

assign bank_en_low_gateclk[3:0]   = bank_en_low[3:0];

assign lag_dcache_arb_ex1_data_gateclk_en[15:0]  = {bank_en_low_gateclk[3:0],bank_en_low_gateclk[3:0],bank_en_low_gateclk[3:0],bank_en_low_gateclk[3:0]}  //L1D 2way->4way, LTL@20250319 
                                                & {16{ag_dcache_arb_ld_gateclk_en}}; //8->16, L1D 2way->4way, LTL@20250319  

//--------------for req-----------------
assign lag_dcache_arb_ex1_data_req[15:0] = {bank_en_low[3:0],bank_en_low[3:0],bank_en_low[3:0],bank_en_low[3:0]}  //L1D 2way->4way, LTL@20250319
                                        & {16{ag_dcache_arb_ld_req & ~lag_us_tag_req_stall & ~lag_us_tag_ack_stall}};  //8->16, L1D 2way->4way, LTL@20250319  

//-----------data idx-------------------
//assign lag_dcache_arb_ex1_data_low_idx[9:0]  = lag_ex1_pa[13:4];   //10->9 14->13, L1D 2way->4way, LTL@20250319
//assign lag_dcache_arb_ex1_data_high_idx[9:0] = {lag_ex1_pa[13:5],~lag_ex1_pa[4]};//10->9 14->13, L1D 2way->4way, LTL@20250319
assign lag_us_tag_hit_way[0] = dcache_lsu_ld_tag_dout[`WK_LS_DCACHE_SINGLE_TAG_WIDTH] &                                  (ld_ag_pn[`WK_PA_WIDTH-13:2] == dcache_lsu_ld_tag_dout[`WK_LS_DCACHE_SINGLE_TAG_WIDTH-1:0]);
assign lag_us_tag_hit_way[1] = dcache_lsu_ld_tag_dout[`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH+`WK_LS_DCACHE_SINGLE_TAG_WIDTH] & (ld_ag_pn[`WK_PA_WIDTH-13:2] == dcache_lsu_ld_tag_dout[`WK_LS_DCACHE_SINGLE_TAG_WIDTH+`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH]);
assign lag_us_tag_hit_way[2] = dcache_lsu_ld_tag_dout[`WK_LS_DCACHE_DOUBLE_LDTAG_WIDTH+`WK_LS_DCACHE_SINGLE_TAG_WIDTH] & (ld_ag_pn[`WK_PA_WIDTH-13:2] == dcache_lsu_ld_tag_dout[`WK_LS_DCACHE_SINGLE_TAG_WIDTH+`WK_LS_DCACHE_DOUBLE_LDTAG_WIDTH-1:`WK_LS_DCACHE_DOUBLE_LDTAG_WIDTH]);
assign lag_us_tag_hit_way[3] = dcache_lsu_ld_tag_dout[`WK_LS_DCACHE_TRIPLE_LDTAG_WIDTH+`WK_LS_DCACHE_SINGLE_TAG_WIDTH] & (ld_ag_pn[`WK_PA_WIDTH-13:2] == dcache_lsu_ld_tag_dout[`WK_LS_DCACHE_SINGLE_TAG_WIDTH+`WK_LS_DCACHE_TRIPLE_LDTAG_WIDTH-1:`WK_LS_DCACHE_TRIPLE_LDTAG_WIDTH]);
// assign lag_us_settle_way[0] = lag_us_tag_req_success_flop? (lag_us_tag_hit_way[3] | lag_us_tag_hit_way[1]) :(lag_ex1_us_way[3] | lag_ex1_us_way[1]);
// assign lag_us_settle_way[1] = lag_us_tag_req_success_flop? (lag_us_tag_hit_way[3] | lag_us_tag_hit_way[2]) :(lag_ex1_us_way[3] | lag_ex1_us_way[2]);
assign lag_us_settle_way[0] = (lag_ex1_us_way[3] | lag_ex1_us_way[1]);
assign lag_us_settle_way[1] = (lag_ex1_us_way[3] | lag_ex1_us_way[2]);
assign lag_dcache_arb_ex1_data_0_idx[9:0]  = (lag_ldc_ex1_inst_vls & ld_ag_unit_stride) ? {lag_ex1_pa[13:6], lag_us_settle_way[1:0]} : lag_ex1_pa[13:4];
assign lag_dcache_arb_ex1_data_1_idx[9:0]  = (lag_ldc_ex1_inst_vls & ld_ag_unit_stride) ? {lag_ex1_pa[13:6], lag_us_settle_way[1:0]} : {lag_ex1_pa[13:5],~lag_ex1_pa[4]};
assign lag_dcache_arb_ex1_data_2_idx[9:0]  = (lag_ldc_ex1_inst_vls & ld_ag_unit_stride) ? {lag_ex1_pa[13:6], lag_us_settle_way[1:0]} : {lag_ex1_pa[13:6],~lag_ex1_pa[5],lag_ex1_pa[4]};
assign lag_dcache_arb_ex1_data_3_idx[9:0]  = (lag_ldc_ex1_inst_vls & ld_ag_unit_stride) ? {lag_ex1_pa[13:6], lag_us_settle_way[1:0]} : {lag_ex1_pa[13:6],~lag_ex1_pa[5:4]};

//low/high din
//assign ag_dcache_arb_ld_data_low_din[127:0]   = 128'b0;
//assign ag_dcache_arb_ld_data_high_din[127:0]  = 128'b0;

//assign ag_dcache_arb_ld_data_wen[31:0] = 32'b0;

//==========================================================
//        Generage exception signal
//==========================================================
//if the 1st boundary instruction is weak order and 2nd is strong order, then treat
//this instruction as weak order
// &Force("output", "lag_ldc_ex1_expt_misalign_no_page"); @1117
// wjh@us512
// assign lag_us_misalign_no_page = lag_ldc_ex1_inst_vls
//                                  & ld_ag_unit_stride
//                                  & (~cp0_lsu_dcache_en);

// assign lag_us_misalign_with_page = lag_ldc_ex1_inst_vls
//                                    & ld_ag_unit_stride
//                                    & (mmu_lsu_pa_vld & ~lag_ldc_ex1_page_ca);

assign lag_ldc_ex1_expt_misalign_no_page  = ld_ag_unalign
                                            && (lag_ldc_ex1_atomic
                                                || lag_ldc_ex1_inst_vls && !ld_ag_unit_stride
                                                || ld_ag_ld_inst
                                                    && !lag_ldc_ex1_inst_us
                                                    && !cp0_lsu_mm);
                                        //  || lag_us_misalign_no_page;

// &Force("output","lag_ldc_ex1_expt_misalign_with_page"); @1124
assign lag_ldc_ex1_expt_misalign_with_page  = ld_ag_unalign_so
                                              && ld_ag_page_so
                                              && mmu_lsu_pa_vld
                                              && ld_ag_ld_inst;
                                          //  || lag_us_misalign_with_page;

// &Force("output", "lag_ldc_ex1_expt_page_fault"); @1130
assign lag_ldc_ex1_expt_page_fault       = mmu_lsu_pa_vld
                                    &&  ld_ag_page_fault
                                    ||  lag_bkcon_pgfault;

// &Force("output","lag_ldc_ex1_expt_ldamo_not_ca"); @1134
assign lag_ldc_ex1_expt_ldamo_not_ca    = mmu_lsu_pa_vld
                                    &&  ld_ag_ldamo_inst
                                    &&  !lag_ldc_ex1_page_ca;

// //&Force("output", "ld_ag_expt_access_fault"); @1139
//assign ld_ag_expt_access_fault    = mmu_lsu_pa_vld
//                                    &&  (ld_ag_access_fault
//                                        ||  ld_ag_ldamo_inst
//                                            &&  !lag_ldc_ex1_page_ca);

//for vector strong order
// &Force("output", "lag_ldc_ex1_expt_access_fault_with_page"); @1146
assign lag_ldc_ex1_expt_access_fault_with_page = mmu_lsu_pa_vld
                                           &&  ld_ag_page_so
                                           &&  ld_ag_ld_inst
                                           &&  lag_ldc_ex1_inst_vls;

assign lag_ldc_ex1_expt_vld         = lag_ldc_ex1_expt_misalign_no_page
                                ||  lag_ldc_ex1_expt_misalign_with_page
                                ||  lag_ldc_ex1_expt_access_fault_with_page
                                ||  lag_ldc_ex1_expt_page_fault
                                ||  lag_mmu_acfault;

//==========================================================
//        Generage stall/restart signal
//==========================================================
//-----------restart----------------------------------------
assign ld_ag_atomic_no_cmit_restart_req = lag_ex1_inst_vld
                                          &&  lag_ldc_ex1_atomic
                                          &&  !ld_ag_cmit;
assign ld_ag_not_replay_bar_chk     = lag_ex1_inst_vld              // wjh@lrq
                                      && lrq_fence_aft_load         // wjh@lrq
                                      && !lag_lrq_replay_vld        // wjh@lrq
                                      && !lag_lrq_create_already;
assign ld_ag_not_replay_no_spec_chk = lag_ex1_inst_vld              // wjh@lrq
                                      &&  !lag_lrq_replay_vld       // wjh@lrq
                                      &&  !lag_lrq_create_already
                                      &&  lag_ex1_sfp_pc_hit       // wjh@lrq
                                      &&  lrq_hit_no_spec_tbl;      // wjh@lrq
//-----------stall------------------------------------------
//get the stall signal if virtual address cross 4k address
//for timing, if there is a carry adding last 12 bits, or there is '1' in high
//bits, it will stall
//---------------------cross 4k-----------------------------
assign ld_ag_4k_sum_ori[12:0]   = {1'b0,ld_ag_base[11:0]} 
                                  + {ld_ag_offset_aftershift[63],ld_ag_offset_aftershift[11:0]};

assign ld_ag_4k_sum_plus[12:0]   = {1'b0,ld_ag_base[11:0]} 
                                  + ld_ag_offset_plus[12:0];

assign ld_ag_off_4k_high_bits_all_0_ori = !(|ld_ag_offset_aftershift[63:12]);
assign ld_ag_off_4k_high_bits_all_1_ori = &ld_ag_offset_aftershift[63:12];
assign ld_ag_off_4k_high_bits_not_eq    = !ld_ag_off_4k_high_bits_all_0_ori
                                          &&  !ld_ag_off_4k_high_bits_all_1_ori;

assign ld_ag_4k_sum_12  = ld_ag_va_plus_sel ? ld_ag_4k_sum_plus[12]
                                            : ld_ag_4k_sum_ori[12];

assign ld_ag_cross_4k   = ld_ag_4k_sum_12
                          ||  ld_ag_off_4k_high_bits_not_eq;

//only ldr will trigger secd stall, and will stall at the first split
assign ld_ag_boundary_stall = ld_ag_inst_ldr && lag_ldc_ex1_boundary && !lag_ldc_ex1_secd;
assign ld_ag_secd_imme_stall  = ld_ag_boundary_stall  &&  !ld_ag_already_cross_page_ldr_imme;

assign ld_ag_dcache_stall_unmask    = !dcache_arb_lag_ex1_sel && !ld_ag_tcm_hit
                                      || dcache_arb_ldc_borrow_vld_gate && ld_ag_tcm_hit;
//because corss_4k to mmu, so there doesn't exist prior stall
assign ld_ag_cross_page_ldr_imme_stall_req =  (ld_ag_cross_4k
                                                  ||  ld_ag_itcm_chk_stall
                                                  ||  ld_ag_secd_imme_stall)
                                              &&  !lag_ldc_ex1_expt_misalign_no_page
                                              &&  !lag_lrq_replay_vld // wjh@lrq
                                              &&  lag_ex1_inst_vld;
assign ld_ag_dcache_stall_req   = ld_ag_dcache_stall_unmask
                                  &&  lag_ex1_inst_vld;
assign ld_ag_struwk_stall_req   = ld_ag_dcache_stall_req | ld_ag_tcm_stall;
assign ld_ag_bkcon_stall_req    = dcache_arb_lag_ex1_bkcon & lag_ex1_inst_vld;

assign lag_bkcon_stall_vld      = (ld_ag_struwk_stall_req | ld_ag_bkcon_stall_req | lag_us_tag_req_stall | lag_us_tag_ack_stall) // wjh@us512
                                  && lsu_mmu_va_vld // excluding replay_vld with pa_vld
                                  && !lsu_mmu_abort; // excluding other types aborting mmu_req

assign ld_ag_mmu_stall_req      = mmu_lsu_stall;

//-----------arbiter----------------------------------------
//prioritize:
//  1. prior_restart  : ldex_no_cmit
//  2. cross_page_ldr_imme_stall    : cross_4k, secd_imme
//  3. dcache_stall    : cache
//  other restart flop to dc stage
//  other_restart  : utlb_miss, tlb_busy

//assign ld_ag_prior_stall_restart  = ld_ag_atomic_no_cmit_restart_req
//                                    ||  ld_ag_cross_page_ldr_imme_stall_req;
// ld_ag_not_replay_bar_chk

assign ld_ag_stall_restart        = ld_ag_atomic_no_cmit_restart_req
                                    ||  ld_ag_not_replay_bar_chk // wjh@lrq
                                    ||  ld_ag_not_replay_no_spec_chk // wjh@lrq
                                    ||  ld_ag_cross_page_ldr_imme_stall_req
                                    ||  ld_ag_struwk_stall_req
                                    ||  ld_ag_bkcon_stall_req
                                    ||  lag_us_tag_req_stall // @wjh@us512
                                    ||  lag_us_tag_ack_stall
                                    ||  lag_bkcon_tlbmiss // wjh@timing
                                    ||  ld_ag_mmu_stall_req;

assign ld_ag_atomic_no_cmit_restart_arb = ld_ag_atomic_no_cmit_restart_req;
assign ld_ag_cross_page_ldr_imme_stall_arb  = !ld_ag_atomic_no_cmit_restart_req
                                              &&  !ld_ag_not_replay_bar_chk // wjh@lrq
                                              &&  !ld_ag_not_replay_no_spec_chk // wjh@lrq
                                              &&  ld_ag_cross_page_ldr_imme_stall_req
                                              &&  !ld_ag_stall_mask;

//-----------generate total siangl--------------------------
// &Force("output","lag_ex1_stall_ori"); @1226
assign lag_ex1_stall_ori            = (ld_ag_cross_page_ldr_imme_stall_req
                                        ||  ld_ag_struwk_stall_req
                                        ||  ld_ag_bkcon_stall_req
                                        ||  lag_us_tag_req_stall // wjh@us512
                                        ||  lag_us_tag_ack_stall
                                        ||  ld_ag_mmu_stall_req)
                                    &&  !ld_ag_atomic_no_cmit_restart_req
                                    &&  !ld_ag_not_replay_bar_chk // wjh@lrq
                                    &&  !lag_bkcon_tlbmiss // wjh@timing
                                    &&  !ld_ag_not_replay_no_spec_chk; // wjh@lrq

assign ld_ag_stall_vld            = lag_ex1_stall_ori
                                    && !ld_ag_stall_mask;

//for performance,when ag stall,let oldest inst go

// &Instance("wk_rtu_compare_iid","x_lsu_rf_compare_ld_ag_iid"); @1237
xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH)) 
x_lsu_rf_compare_ld_ag_iid (
  .x_iid0                    (idu_lsu_rf_iid[IID_WIDTH-1:0]),
  .x_iid0_older              (rf_iid_older_than_ld_ag  ),
  .x_iid1                    (lag0_ex1_iid[IID_WIDTH-1:0]           )
);

// &Connect( .x_iid0         (idu_lsu_rf_iid[IID_WIDTH-1:0]), @1238
//           .x_iid1         (lag0_ex1_iid[IID_WIDTH-1:0]           ), @1239
//           .x_iid0_older   (rf_iid_older_than_ld_ag )); @1240

// assign ld_ag_stall_mask = idu_lsu_rf_sel;
assign ld_ag_stall_mask = idu_lsu_rf_older_vld; // wjh@timing
                          // && rf_iid_older_than_ld_ag; // wjh@timing
// assign ld_ag_stall_mask = 1'b0; // ag req won't be overridden by rf's older req,  for timing
// lrq will not issue newer req wjh@lrq, lag restarts rf req will never happen
// for idu req, lag_ex1_lsid is all 0s, it will not wake lrq's entry through ctrl's ld0_rf_imme_wakeup; if stall and overwite happen, it will create lrq entry with frz=0
// for idu req, if goto nexe stage, lag_ldc_ex1_lsid is selected to lrq_lsu_ex1_lrqid;
// for lrq rea, lag_ex1_lsid is the id of lrq
// wjh@lrq
// assign lag_ex1_stall_restart_entry[LSIQENTRY-1:0] = ld_ag_stall_mask && !lag_lrq_replay_vld // for not-replay signals, we will not wakeup from idu, but create lrq-entry with frz=0
//                                                    ? {LSIQENTRY{1'b0}}
//                                                    : lag_ex1_lsid[LSIQENTRY-1:0]; // wjh@lrq
                                                  //  : idu_lsu_rf_lch_entry[LSIQENTRY-1:0];
// assign lag_ex1_stall_restart_entry = ld_ag_stall_mask && lag_lrq_replay_vld && !lag_ldc_ex1_utlb_miss
//                                      ? lag_ex1_lsid
//                                      : ld_ag_stall_mask && !lag_lrq_replay_vld && lag_lrq_create_already && !lag_ldc_ex1_utlb_miss
//                                        ? lag_lrq_lsid
                                      //  : {LSIQENTRY{1'b0}};
// wjh@lrq, if idu req, select created lrq id as id for further wakeup
assign lag_stall_ori_tlbmiss_not_abort = !ld_ag_cross_page_ldr_imme_stall_req // stall_ori
                                         && !mmu_lsu_pa_vld // tlbmisss
                                         && !lsu_mmu_abort;

assign lag_ex1_stall_restart_entry = lag_lrq_replay_vld && !lag_stall_ori_tlbmiss_not_abort
                                     ? lag_ex1_lsid
                                     : !lag_lrq_replay_vld && lag_lrq_create_already && !lag_stall_ori_tlbmiss_not_abort
                                       ? lag_lrq_lsid
                                       : {LSIQENTRY{1'b0}};

assign lag_ldc_ex1_lsid = lag_lrq_replay_vld
                          ? lag_ex1_lsid
                          : lag_lrq_create_already
                            ? lag_lrq_lsid
                            : lrq_lsu_ex1_lrqid;
//==========================================================
//        Generage to DC stage signal
//==========================================================
// &Force("output", "lag_ldc_ex1_inst_vld"); @1252
assign lag_ldc_ex1_inst_vld          = lag_ex1_inst_vld
                                    &&  !ld_ag_stall_restart;

assign lag_ldc_ex1_mmu_req           = !lsu_mmu_abort;

//this logic may be redundant
assign lag_ldc_ex1_addr0[`WK_PA_WIDTH-1:0] = dcache_arb_lag_ex1_borrow_addr_vld
                                      ? dcache_arb_lag_ex1_addr[`WK_PA_WIDTH-1:0]
                                      : ld_ag_addr0[`WK_PA_WIDTH-1:0];

//for idu timing
// &Force("output","lag_ldc_ex1_inst_vfls");  @1264
// &Force("output","lag_ldc_ex1_load_inst_vld"); @1265
//lag_ldc_ex1_ahead_predict is the predict result for 3 write back
// &Force("output","lag_ldc_ex1_ahead_predict"); @1267
assign lag_ldc_ex1_ahead_predict        = 1'b1;
assign lag_ldc_ex1_load_inst_vld       = lag_ex1_inst_vld
                                      &&  !lag_ldc_ex1_inst_vfls
                                      &&  !(lag_ldc_ex1_boundary
                                          && !ld_ag_acclr_en);
//if boundary and acclr en, then set load_inst_vld and clr
//load_ahead_inst_vld, because boundary don't write back in 3 cycles
assign lag_ldc_ex1_load_ahead_inst_vld = lag_ex1_inst_vld
                                      &&  !lag_ldc_ex1_inst_vfls
                                  
                                      &&  !lag_ldc_ex1_boundary
                                      &&  !cp0_lsu_da_fwd_dis
                                      &&  lag_ldc_ex1_ahead_predict
                                      &&  !lag_ldc_ex1_dtcm_hit
                                      &&  !lag_ldc_ex1_itcm_hit;

// &Force("output","lag_ldc_ex1_vload_inst_vld"); @1283
assign lag_ldc_ex1_vload_inst_vld        = lag_ex1_inst_vld
                                        &&  lag_ldc_ex1_inst_vfls
                                        &&  !lag_ldc_ex1_vmb_merge_vld
                                        &&  !(lag_ldc_ex1_boundary
                                              && !ld_ag_acclr_en);
//assign lag_ldc_ex1_vload_ahead_inst_vld  = lag_ex1_inst_vld
//                                        &&  lag_ldc_ex1_inst_vfls
//                                        &&  !lag_ldc_ex1_inst_vls
//                                        &&  !lag_ldc_ex1_boundary
//                                        &&  !cp0_lsu_da_fwd_dis
//                                        &&  lag_ldc_ex1_ahead_predict;
assign lag_ldc_ex1_vload_ahead_inst_vld = 1'b0; 

//-----------for timing--------------------------
//compare iid ahead for dc restart timing
//compare the instruction in the entry is newer or older
// &Instance("wk_rtu_compare_iid","x_lsu_ld_ag_compare_st_ag_iid"); @1300
xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH))
x_lsu_ld_ag_compare_st_ag0_iid (
  .x_iid0         (lsag0_ex1_iid[IID_WIDTH-1:0]),
  .x_iid0_older   (lag_ldc_ex1_raw0_new ),
  .x_iid1         (lag0_ex1_iid[IID_WIDTH-1:0])
);
xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH))
x_lsu_ld_ag_compare_st_ag1_iid (
  .x_iid0         (lsag1_ex1_iid[IID_WIDTH-1:0]),
  .x_iid0_older   (lag_ldc_ex1_raw1_new ),
  .x_iid1         (lag0_ex1_iid[IID_WIDTH-1:0])
);
// &Connect( .x_iid0         (st_ag_iid[IID_WIDTH-1:0]         ), @1301
//           .x_iid1         (lag0_ex1_iid[IID_WIDTH-1:0]         ), @1302
//           .x_iid0_older   (ld_ag_raw_new          )); @1303

//==========================================================
//                       TCM access
//==========================================================
// &Force("output","lag_ldc_ex1_dtcm_hit"); @1308
// &Force("output","lag_ldc_ex1_itcm_hit"); @1309
//----------------------------------------------------------
//                           dtcm
//----------------------------------------------------------
// &Instance("xx_lsu_dtcm_sel", "x_lsu_ld_ag_dtcm_sel"); @1314
// &Connect(.lsu_chk_addr  (ld_ag_base[39:0] ), @1315
//          .chk_dtcm_sel  (ld_ag_dtcm_sel   )); @1316
//----------------------------------------------------------
//                           itcm
//----------------------------------------------------------
// &Instance("xx_lsu_itcm_sel", "x_lsu_ld_ag_itcm_sel"); @1328
// &Connect(.lsu_chk_addr  (ld_ag_base[39:0] ), @1329
//          .chk_itcm_sel  (ld_ag_itcm_sel   )); @1330
//----------------------------------------------------------
//                       tcm control
//----------------------------------------------------------
assign ld_ag_tcm_hit   = lag_ldc_ex1_dtcm_hit   | lag_ldc_ex1_itcm_hit;
assign ld_ag_tcm_stall = ld_ag_dtcm_stall | ld_ag_itcm_stall;
//==========================================================
//                    Interface to TCM
//==========================================================
//----------------------------------------------------------
//                           dtcm
//----------------------------------------------------------
assign lag_ldc_ex1_dtcm_hit   = 1'b0;
assign ld_ag_dtcm_stall = 1'b0;
//----------------------------------------------------------
//                           itcm
//----------------------------------------------------------
assign ld_ag_itcm_chk_stall = 1'b0;
assign lag_ldc_ex1_itcm_hit       = 1'b0;
assign ld_ag_itcm_stall     = 1'b0;
//==========================================================
//              Interface to other module
//==========================================================
//-----------interface to cmit monitor----------------------
//assign ld_ag_inst_wait_cmit_vld = lag_ex1_inst_vld
//                                  &&  lag_ldc_ex1_atomic;
//-----------interface to local monitor---------------------
assign lag_lm_ex1_init_vld  = lag_ex1_inst_vld
                            &&  lag_ldc_ex1_atomic
                            &&  ld_ag_cmit;

//==========================================================
//        Generate restart/lsiq signal
//==========================================================
//-----------lsiq signal----------------
assign ld_ag_mask_lsid[LSIQENTRY-1:0]    = {LSIQENTRY{lag_ex1_inst_vld}}
                                            &  lag_ex1_lsid[LSIQENTRY-1:0]; // wjh@lrq
// wjh@lrq
// not-replay req should not set wait-old of uncreated lrq-req
// not-replay req with wait-old valid will not set stall-ori and will create lrq entry with wait-old chk
assign lsu_idu_ex1_wait_old_gateclk_en = ld_ag_atomic_no_cmit_restart_arb
                                         && lag_lrq_replay_vld; // wjh@lrq
assign lsu_idu_ex1_wait_old[LSIQENTRY-1:0]  = ld_ag_mask_lsid[LSIQENTRY-1:0]
                                                 & {LSIQENTRY{ld_ag_atomic_no_cmit_restart_arb && lag_lrq_replay_vld}}; // wjh@lrq
//==========================================================
//        for idu timing
//==========================================================
assign lsu_idu_ex1_load_inst_vld  = lag_ex1_inst_vld
                                         && !lag_ldc_ex1_inst_vfls
                                         && !cp0_lsu_da_fwd_dis
                                         && lag_ldc_ex1_ahead_predict;

assign lsu_idu_ex1_preg[PREG-1:0] = lag_ldc_ex1_preg[PREG-1:0];
//assign lsu_idu_ag_pipe3_preg_dup1[6:0] = ld_ag_preg_dup1[6:0];
//assign lsu_idu_ag_pipe3_preg_dup2[6:0] = ld_ag_preg_dup2[6:0];
//assign lsu_idu_ag_pipe3_preg_dup3[6:0] = ld_ag_preg_dup3[6:0];
//assign lsu_idu_ag_pipe3_preg_dup4[6:0] = ld_ag_preg_dup4[6:0];

assign lsu_idu_ex1_vload_inst_vld = lag_ex1_inst_vld
                                         && lag_ldc_ex1_inst_vfls
                                         && !lag_ldc_ex1_inst_vls
                                         && !cp0_lsu_da_fwd_dis
                                         && lag_ldc_ex1_ahead_predict;

assign lsu_idu_ex1_vreg[VREG:0]      = {1'b0,lag_ldc_ex1_vreg[VREG-1:0]};
//assign lsu_idu_ag_pipe3_vreg_dup1[VREG:0]      = {1'b0,ld_ag_vreg_dup1[VREG-1:0]};
//assign lsu_idu_ag_pipe3_vreg_dup2[VREG:0]      = {1'b0,ld_ag_vreg_dup2[VREG-1:0]};
//assign lsu_idu_ag_pipe3_vreg_dup3[VREG:0]      = {1'b0,ld_ag_vreg_dup3[VREG-1:0]};
//==========================================================
//        interface to hpcp
//==========================================================
assign lsu_hpcp_ld_stall_cross_4k  = lag_ex1_inst_vld
                                     &&  ld_ag_already_cross_page_ldr_imme
                                     &&  !ld_ag_stall_vld
                                     &&  !lag_ldc_ex1_utlb_miss
                                     &&  !lag_ldc_ex1_already_da;
assign lsu_hpcp_ld_stall_other     = lag_ex1_inst_vld
                                     &&  !ld_ag_cross_4k
                                     &&  ld_ag_stall_vld
                                     &&  !lag_ldc_ex1_utlb_miss
                                     &&  !lag_ldc_ex1_already_da;
//==========================================================
//        interface to lrq wjh@lrq
//==========================================================
assign lsu_lrq_create_vld = lag_ex1_inst_vld
                            && !lag_lrq_replay_vld
                            && !lag_lrq_create_already;
                            // && !lag_ex1_stall_ori;
// assign lsu_lrq_create_va            = ld_ag_va[63:0];
assign lsu_lrq_create_frz           = !(lag_ex1_stall_ori && ld_ag_stall_mask && (mmu_lsu_pa_vld || lsu_mmu_abort));
assign lsu_lrq_create_wait_old_chk  = ld_ag_atomic_no_cmit_restart_arb;
assign lsu_lrq_create_bar_chk       = ld_ag_not_replay_bar_chk;// lsu has bar
assign lsu_lrq_create_no_spec_chk   = ld_ag_not_replay_no_spec_chk;
assign lsu_lrq_create_bytes_vld     = lag_ldc_ex1_inst_us
                                      ? vmask_byte_sel
                                      : lag_ldc_ex1_inst_vls
                                        ? ld_ag_bytes_vld[15:0]  & vector_byte_mask[15:0]
                                        : ld_ag_bytes_vld;
assign lsu_lrq_create_bytes_vld1    = lag_ldc_ex1_inst_us
                                      ? vmask_byte_sel1
                                      : lag_ldc_ex1_inst_vls
                                        ? ld_ag_bytes_vld1 & vector_byte_mask
                                        : ld_ag_bytes_vld1;
assign lsu_lrq_create_bytes_vld2    = vmask_byte_sel2;
assign lsu_lrq_create_bytes_vld3    = vmask_byte_sel3;
assign lsu_lrq_create_reg_bytes_vld = reg_bytes_vld[15:0];
assign lsu_lrq_create_reg_bytes_vld1 = reg_bytes_vld1[15:0];
assign lsu_lrq_create_reg_bytes_vld2 = reg_bytes_vld2[15:0];
assign lsu_lrq_create_reg_bytes_vld3 = reg_bytes_vld3[15:0];
assign lsu_lrq_create_boundary      = ld_ag_boundary_unmask;
assign lsu_lrq_create_atomic        = lag_ldc_ex1_atomic;
assign lsu_lrq_create_iid           = lag0_ex1_iid[IID_WIDTH-1:0];
assign lsu_lrq_create_fls           = ld_ag_inst_fls;
assign lsu_lrq_create_fof           = lag_ldc_ex1_inst_fof;
assign lsu_lrq_create_size          = ld_ag_inst_size[1:0];
assign lsu_lrq_create_type          = lag_ldc_ex1_inst_type[1:0];
assign lsu_lrq_create_vls           = lag_ldc_ex1_inst_vls;
assign lsu_lrq_create_lsfifo        = ld_ag_lsfifo;
assign lsu_lrq_create_pc            = lag_ldc_ex1_ldfifo_pc[PC_LEN-1:0];
assign lsu_lrq_create_preg          = lag_ldc_ex1_preg[PREG-1:0];
assign lsu_lrq_create_sext          = lag_ldc_ex1_sext;
assign lsu_lrq_create_split         = lag_ldc_ex1_split;
assign lsu_lrq_create_split_num     = ld_ag_split_cnt[8:0]; // wjh@us512
assign lsu_lrq_create_unit_stride   = ld_ag_unit_stride;
// assign lsu_lrq_create_vlmul         = lag_ldc_ex1_vlmul[1:0];
assign lsu_lrq_create_vlmul         = lag_ldc_ex1_vlmul[2:0];
assign lsu_lrq_create_vls_size      = ld_ag_vls_size;
assign lsu_lrq_create_vmb_id        = lag_ldc_ex1_vmb_id[VMBENTRY-1:0];
assign lsu_lrq_create_vmb_merge_vld = lag_ldc_ex1_vmb_merge_vld;
assign lsu_lrq_create_vreg          = lag_ldc_ex1_vreg[VREG-1:0];
//assign lsu_lrq_create_vsew          = lag_ldc_ex1_vsew[1:0];
assign lsu_lrq_create_vmew          = lag_ldc_ex1_vmew[1:0];
assign lsu_lrq_create_vmop          = lag_ldc_ex1_vmop[1:0];
assign lsu_lrq_create_nf            = lag_ldc_ex1_nf;
assign lsu_lrq_create_4kstall       = ld_ag_cross_page_ldr_imme_stall_req & ld_ag_secd_imme_stall;
assign lsu_lrq_pop_entry            = lag_ex1_lsid;
assign lsu_lrq_sfp_dst_pc           = lag_ex1_sfp_dst_pc;
// &ModuleEnd; @1459
//==========================================================
//        interface to sfp@wjh
//==========================================================
// assign lsu_sfp_ex1_spec_chk = lag_ex1_inst_vld
//                               && !lag_lrq_replay_vld
//                               && cp0_lsu_nsfe
//                               && ld_ag_ld_inst
//                               // && (mmu_lsu_pa_vld && !ld_ag_page_so)
//                               && !lag_ldc_ex1_expt_vld;
// return the result with lrq_hit_no_spec_tbl

//==========================================================
//                  Risc-V Debug zdb Begin
//==========================================================
assign ld_ag_dtu_va[`WK_MA_WIDTH-1:0]    = ld_ag_va[`WK_MA_WIDTH-1:0];

//
always @(posedge ld_ag_clk or negedge cpurst_b)
begin
  if (~cpurst_b)
    ld_ag_halt_info[`TDT_MP_HINFO_WIDTH-1:0] <= {`TDT_MP_HINFO_WIDTH{1'b0}};
  else if (~ld_ag_stall_vld & ld_rf_inst_vld & (lsu_any_trig_en | ld_ag_halt_info[1]))
    ld_ag_halt_info[`TDT_MP_HINFO_WIDTH-1:0] <= idu_lsu_rf_halt_info[`TDT_MP_HINFO_WIDTH-1:0];
end

always @( ld_ag_access_size[3:0])
begin
case(ld_ag_access_size[3:0])
  4'b0000: ld_ag_dtu_access_size[2:0] = 3'b000;  //byte
  4'b0001: ld_ag_dtu_access_size[2:0] = 3'b001;  //half
  4'b0011: ld_ag_dtu_access_size[2:0] = 3'b010;  //word
  4'b0111: ld_ag_dtu_access_size[2:0] = 3'b011;  //dword
  4'b1111: ld_ag_dtu_access_size[2:0] = 3'b100;  //qword
  default: ld_ag_dtu_access_size[2:0] = 3'b101;
endcase
// &CombEnd; @396
end


//==========================================================
//        Generage debug signal
//==========================================================
assign ld_ag_dtu_vld              = lag_ex1_inst_vld
                                    & dtu_lsu_addr_trig_en;
assign ld_ag_dtu_last_check       = ~dtu_lsu_data_trig_en
                                    & (lag_ldc_ex1_secd
                                    | ~ld_ag_boundary_unmask
                                    | lag_ldc_ex1_atomic)
                                    | lag_ldc_ex1_inst_vls
                                    | ld_ag_ldamo_inst;
assign ld_ag_dtu_type[1:0]        = {1'b1,ld_ag_ldamo_inst};
//==========================================================
//                  Risc-V Debug zdb End
//==========================================================

endmodule


