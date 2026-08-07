//-----------------------------------------------------------------------------
// File          : wk_cp0_regs.v
// Created       : 2024/10/01 (by David)
// Last modified : 2024/10/01 (by David)
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


// $Id: wk_cp0_regs.vp,v 1.272.4.6 2023/08/23 02:34:12 mingmin.tang Exp $
// *****************************************************************************


// &ModuleBeg; @24
module wk_cp0_regs(
  biu_cp0_apb_base,
  biu_cp0_cmplt,
  biu_cp0_coreid,
  biu_cp0_me_int,
  biu_cp0_ms_int,
  biu_cp0_mt_int,
  biu_cp0_rdata,
  biu_cp0_rvba,
  biu_cp0_se_int,
  biu_cp0_ss_int,
  biu_cp0_st_int,
`ifdef ADD_AIA
  aia_cp0_data,    //input from AIA IMSIC by Chenlili@20250521  
  cp0_aia_wreg,    //output to AIA IMSIC by Chenlili@20250521
  mip_raw,         //output to iui by zhangdunbo@20260608
  sip_raw,         //output to iui by zhangdunbo@20260608    
`endif
  cp0_biu_icg_en,
  cp0_hpcp_icg_en,
  cp0_hpcp_index,
  cp0_hpcp_int_disable,
  cp0_hpcp_mcntwen,
  cp0_hpcp_pmdm,
  cp0_hpcp_pmds,
  cp0_hpcp_pmdu,
  cp0_hpcp_wdata,
  cp0_idu_cskyee,
  cp0_idu_dlb_disable,
  cp0_idu_frm,
  cp0_idu_fs,
  cp0_idu_icg_en,
  cp0_idu_iq_bypass_disable,
  cp0_idu_light_fence_en,
  cp0_idu_rob_fold_disable,
  cp0_idu_src2_fwd_disable,
  cp0_idu_srcv2_fwd_disable,
  cp0_idu_strong_atomic,
  cp0_idu_vill,
  cp0_idu_vs,
  cp0_idu_vstart,
  cp0_idu_zero_delay_move_disable,
  cp0_ifu_bht_en,
  cp0_ifu_bht_inv,
  cp0_ifu_btb_en,
  cp0_ifu_btb_inv,
  cp0_ifu_data_ecc_inj,
  cp0_ifu_data_random,
  cp0_ifu_ecc_en,
  cp0_ifu_icache_en,
  cp0_ifu_icache_inv,
  cp0_ifu_icache_pref_en,
  cp0_ifu_icache_read_index,
  cp0_ifu_icache_read_req,
  cp0_ifu_icache_read_type,
  cp0_ifu_icache_read_way,
  cp0_ifu_icg_en,
  cp0_ifu_ind_btb_en,
  cp0_ifu_ind_btb_inv,
  cp0_ifu_insde,
  cp0_ifu_iwpe,
  cp0_ifu_l0btb_en,
  cp0_ifu_lbuf_en,
  cp0_ifu_nsfe,
  cp0_ifu_ras_en,
  cp0_ifu_rvbr,
  cp0_ifu_tag_ecc_inj,
  cp0_ifu_tag_random,
  cp0_ifu_vbr,
  cp0_ifu_vl,
  cp0_ifu_vlmul,
  cp0_ifu_vsetvli_pred_disable,
  cp0_ifu_vsetvli_pred_mode,
  cp0_ifu_vsew,
  cp0_ifu_vma, // add by tmj @20251127
  cp0_ifu_vta, // add by tmj @20251127
  cp0_iu_div_entry_disable,
  cp0_iu_div_entry_disable_clr,
  cp0_iu_ex3_efpc,
  cp0_iu_ex3_efpc_vld,
  cp0_iu_icg_en,
  cp0_iu_vill,
  cp0_iu_vl,
  cp0_iu_vlmul, // add by tmj @20251218
  cp0_iu_vsew, // add by tmj @20251218
  cp0_iu_vsetvli_pre_decd_disable,
  cp0_iu_vstart,
  cp0_lsu_amr,
  cp0_lsu_amr2,
  cp0_lsu_cb_aclr_dis,
  cp0_lsu_corr_dis,
  cp0_lsu_ctc_flush_dis,
  cp0_lsu_da_fwd_dis,
  cp0_lsu_data_ecc_inj,
  cp0_lsu_data_random,
  cp0_lsu_dcache_clr,
  cp0_lsu_dcache_en,
  cp0_lsu_dcache_inv,
  cp0_lsu_dcache_pref_dist,
  cp0_lsu_dcache_pref_en,
  cp0_lsu_dcache_read_index,
  cp0_lsu_dcache_read_req,
  cp0_lsu_dcache_read_type,
  cp0_lsu_dcache_read_way,
  cp0_lsu_delay_mnt_dis,
  cp0_lsu_delay_mnt_force,
  cp0_lsu_delay_mnt_max,
  cp0_lsu_ecc_en,
  cp0_lsu_fencei_broad_dis,
  cp0_lsu_fencerw_broad_dis,
  cp0_lsu_icg_en,
  cp0_lsu_l2_pref_dist,
  cp0_lsu_l2_pref_en,
  cp0_lsu_l2_st_pref_en,
  cp0_lsu_ld_stride_cm_hw_pref_en,
  cp0_lsu_va_based_hw_pref_en,
  cp0_pf_aggr_range,
  cp0_region_pf_dynamic,
  cp0_region_pf_conservative,
  cp0_region_pf_very_conservative,
  cp0_region_pf_most_conservative,
  cp0_lsu_mm,
  cp0_lsu_nsfe,
  cp0_lsu_pfu_mmu_dis,
  cp0_lsu_tag_ecc_inj,
  cp0_lsu_tag_random0,
  cp0_lsu_tag_random1,
  cp0_lsu_timeout_cnt,
  cp0_lsu_tlb_broad_dis,
  cp0_lsu_tvm,
  cp0_lsu_ucme,
  cp0_lsu_vstart,
  cp0_lsu_wa,
  cp0_lsu_wr_burst_dis,
  cp0_mmu_cskyee,
  cp0_mmu_data_ecc_inj,
  cp0_mmu_data_random,
  cp0_mmu_ecc_en,
  cp0_mmu_icg_en,
  cp0_mmu_maee,
  cp0_mmu_mpp,
  cp0_mmu_mprv,
  cp0_mmu_mxr,
  cp0_mmu_pa_equal_va,
  cp0_mmu_ptw_en,
  cp0_mmu_reg_num,
  cp0_mmu_satp_sel,
  cp0_mmu_sum,
  cp0_mmu_tag_ecc_inj,
  cp0_mmu_tag_random,
  cp0_mmu_wdata,
  cp0_mmu_wreg,
  cp0_mret,
  cp0_pad_mstatus,
  cp0_pmp_icg_en,
  cp0_pmp_mpp,
  cp0_pmp_mprv,
  cp0_pmp_reg_num,
  cp0_pmp_wdata,
  cp0_pmp_wreg,
  cp0_rtu_icg_en,
  cp0_rtu_srt_en,
  cp0_sret,
  cp0_vfpu_fcsr,
  cp0_vfpu_fxcr,
  cp0_vfpu_icg_en,
  cp0_xx_core_icg_en,
  cp0_yy_dcache_pref_en,
  cp0_yy_hyper,
  cp0_yy_priv_mode,
  cp0_yy_virtual_mode,
  cpurst_b,
  forever_cpuclk,
  hpcp_cp0_data,
  hpcp_cp0_int_vld,
  hpcp_cp0_sce,
  idu_cp0_fesr_acc_updt_val,
  idu_cp0_fesr_acc_updt_vld,
  ifu_cp0_bht_inv_done,
  ifu_cp0_btb_inv_done,
  ifu_cp0_data_inj_cmplt,
  ifu_cp0_ecc_fatal,
  ifu_cp0_ecc_idx,
  ifu_cp0_ecc_ramid,
  ifu_cp0_ecc_vld,
  ifu_cp0_ecc_way,
  ifu_cp0_icache_inv_done,
  ifu_cp0_icache_read_data,
  ifu_cp0_icache_read_data_vld,
  ifu_cp0_ind_btb_inv_done,
  ifu_cp0_rst_inv_req,
  ifu_cp0_tag_inj_cmplt,
  iui_regs_addr,
  iui_regs_csr_wr,
  iui_regs_csrw,
  iui_regs_ex3_inst_csr,
  iui_regs_inst_mret,
  iui_regs_inst_sret,
  iui_regs_inv_expt,
  iui_regs_ori_src0,
  iui_regs_rst_inv_d,
  iui_regs_rst_inv_i,
  iui_regs_sel,
  iui_regs_src0,
  lsu_cp0_data_inj_cmplt,
  lsu_cp0_dcache_done,
  lsu_cp0_dcache_read_data,
  lsu_cp0_dcache_read_data_vld,
  lsu_cp0_ecc_fatal,
  lsu_cp0_ecc_idx,
  lsu_cp0_ecc_ramid,
  lsu_cp0_ecc_sbepa,
  lsu_cp0_ecc_vld,
  lsu_cp0_ecc_way,
  lsu_cp0_tag_inj_cmplt,
  mmu_cp0_data,
  mmu_cp0_data_inj_cmplt,
  mmu_cp0_ecc_idx,
  mmu_cp0_ecc_ramid,
  mmu_cp0_ecc_vld,
  mmu_cp0_ecc_way,
  mmu_cp0_satp_data,
  mmu_cp0_tag_inj_cmplt,
  pad_yy_icg_scan_en,
  pmp_cp0_data,
  regs_iui_cfr_no_op,
  regs_iui_chk_vld,
  regs_iui_cindex_l2,
  regs_iui_cins_no_op,
  regs_iui_cskyee,
  regs_iui_data_out,
  regs_iui_dca_sel,
  regs_iui_fs_off,
  regs_iui_hpcp_regs_sel,
  regs_iui_hpcp_scr_inv,
  regs_iui_int_sel,
  regs_iui_l2_regs_sel,
  regs_iui_mcins,
  regs_iui_pm,
  regs_iui_reg_idx,
  regs_iui_scnt_inv,
  regs_iui_tee_ff,
  regs_iui_tee_vld,
  regs_iui_tsr,
  regs_iui_tvm,
  regs_iui_tw,
  regs_iui_ucnt_inv,
  regs_iui_v,
  regs_iui_vs_off,
  regs_iui_wdata,
  regs_lpmd_int_vld,
  regs_xx_icg_en,
  rtu_cp0_epc,
  rtu_cp0_expt_gateclk_vld,
  rtu_cp0_expt_mtval,
  rtu_cp0_expt_vld,
  rtu_cp0_fp_dirty_vld,
  rtu_cp0_int_ack,
  rtu_cp0_vec_dirty_vld,
  rtu_cp0_vsetvl_vill,
  rtu_cp0_vsetvl_vl,
  rtu_cp0_vsetvl_vl_vld,
  rtu_cp0_vsetvl_vlmul,
  rtu_cp0_vsetvl_vsew,
  rtu_cp0_vsetvl_vta,
  rtu_cp0_vsetvl_vma,
  rtu_cp0_vsetvl_vtype_vld,
  rtu_cp0_vstart,
  rtu_cp0_vstart_vld,
  rtu_yy_xx_expt_ecc,
  rtu_yy_xx_expt_vec,
  rtu_yy_xx_flush,
//==========================================================
//                  Risc-V Debug zdb Begin
//==========================================================
  //input
  dtu_cp0_dcsr_mprven,
  dtu_cp0_rdata,
  dtu_yy_dcsr_prv,
  iui_regs_ex1_read_sel,
  iui_regs_ex2_write_sel,
  iui_regs_fsm_busy,
  iui_regs_wreg_for_dtu_hpcp,
  rtu_cp0_dbg_pm,
  rtu_cp0_enter_debug,
  rtu_cp0_exit_debug,
  rtu_yy_xx_dbgon,
  rtu_yy_xx_expt_vld, 
  //output
  cp0_dtu_addr,
  cp0_dtu_icg_en,
  cp0_dtu_mexpt_vld,
  cp0_dtu_pcfifo_frz,
  cp0_dtu_priv_mode,
  cp0_dtu_rreg,
  cp0_dtu_satp,
  cp0_dtu_sel,
  cp0_dtu_sel_gateclk,
  cp0_dtu_wdata,
  cp0_dtu_wreg,
  cp0_yy_mmu_en,
  regs_iui_dtu_regs_sel,
  regs_iui_mmu_regs_sel,
  cp0_yy_sv39_en,
  cp0_yy_sv48_en,
  cp0_yy_zoneid
//==========================================================
//                  Risc-V Debug zdb End
//==========================================================
);

// &Ports; @25
input   [`WK_PA_WIDTH-1 :0]  biu_cp0_apb_base;               
input            biu_cp0_cmplt;                  
input   [63  :0] biu_cp0_coreid;                 
input            biu_cp0_me_int;                 
input            biu_cp0_ms_int;                 
input            biu_cp0_mt_int;                 
input   [127:0]  biu_cp0_rdata;                  
input   [`WK_PC_WIDTH-1 :0]  biu_cp0_rvba;                   
input            biu_cp0_se_int;                 
input            biu_cp0_ss_int;                 
input            biu_cp0_st_int;  
`ifdef ADD_AIA
input   [63 :0]  aia_cp0_data;    //for AIA by Chenlili@20250521       
`endif               
input            cp0_mret;                       
input            cp0_sret;                       
input            cpurst_b;                       
input            forever_cpuclk;                 
input   [63 :0]  hpcp_cp0_data;                  
input            hpcp_cp0_int_vld;               
input            hpcp_cp0_sce;                   
input   [6  :0]  idu_cp0_fesr_acc_updt_val;      
input            idu_cp0_fesr_acc_updt_vld;      
input            ifu_cp0_bht_inv_done;           
input            ifu_cp0_btb_inv_done;           
input            ifu_cp0_data_inj_cmplt;         
input            ifu_cp0_ecc_fatal;              
input   [16 :0]  ifu_cp0_ecc_idx;                
input   [2  :0]  ifu_cp0_ecc_ramid;              
input            ifu_cp0_ecc_vld;                
input   [1  :0]  ifu_cp0_ecc_way;                
input            ifu_cp0_icache_inv_done;        
input   [127:0]  ifu_cp0_icache_read_data;       
input            ifu_cp0_icache_read_data_vld;   
input            ifu_cp0_ind_btb_inv_done;       
input            ifu_cp0_rst_inv_req;            
input            ifu_cp0_tag_inj_cmplt;          
input   [11 :0]  iui_regs_addr;                  
input            iui_regs_csr_wr;                
input            iui_regs_csrw;                  
input            iui_regs_ex3_inst_csr;          
input            iui_regs_inst_mret;             
input            iui_regs_inst_sret;             
input            iui_regs_inv_expt;              
input   [63 :0]  iui_regs_ori_src0;              
input            iui_regs_rst_inv_d;             
input            iui_regs_rst_inv_i;             
input            iui_regs_sel;                   
input   [63 :0]  iui_regs_src0;                  
input            lsu_cp0_data_inj_cmplt;         
input            lsu_cp0_dcache_done;            
input   [127:0]  lsu_cp0_dcache_read_data;       
input            lsu_cp0_dcache_read_data_vld;   
input            lsu_cp0_ecc_fatal;              
input   [16 :0]  lsu_cp0_ecc_idx;                
input   [2  :0]  lsu_cp0_ecc_ramid;              
input   [`WK_PA_WIDTH-1 :0]  lsu_cp0_ecc_sbepa;              
input            lsu_cp0_ecc_vld;                
input   [1  :0]  lsu_cp0_ecc_way;                
input            lsu_cp0_tag_inj_cmplt;          
input   [63 :0]  mmu_cp0_data;                   
input            mmu_cp0_data_inj_cmplt;         
input   [8  :0]  mmu_cp0_ecc_idx;                
input   [2  :0]  mmu_cp0_ecc_ramid;              
input            mmu_cp0_ecc_vld;                
input   [1  :0]  mmu_cp0_ecc_way;                
input   [63 :0]  mmu_cp0_satp_data;              
input            mmu_cp0_tag_inj_cmplt;          
input            pad_yy_icg_scan_en;             
input   [63 :0]  pmp_cp0_data;                   
input   [63 :0]  rtu_cp0_epc;                    
input            rtu_cp0_expt_gateclk_vld;       
input   [63 :0]  rtu_cp0_expt_mtval;             
input            rtu_cp0_expt_vld;               
input            rtu_cp0_fp_dirty_vld;           
input            rtu_cp0_int_ack;                
input            rtu_cp0_vec_dirty_vld;          
input            rtu_cp0_vsetvl_vill;            
input   [`VL_WIDTH-1 :0]  rtu_cp0_vsetvl_vl;              
input            rtu_cp0_vsetvl_vl_vld;          
input   [2  :0]  rtu_cp0_vsetvl_vlmul;           // add by tmj @20251023 
input   [2  :0]  rtu_cp0_vsetvl_vsew;            
input            rtu_cp0_vsetvl_vta;           
input            rtu_cp0_vsetvl_vma;           
input            rtu_cp0_vsetvl_vtype_vld;       
input   [`VSTART_WIDTH-1  :0]  rtu_cp0_vstart;                 
input            rtu_cp0_vstart_vld;             
input            rtu_yy_xx_expt_ecc;             
input   [5  :0]  rtu_yy_xx_expt_vec;             
input            rtu_yy_xx_flush;      
`ifdef ADD_AIA  
output           cp0_aia_wreg;  //output to AIA by chenlili@20251203        
`endif                         
output           cp0_biu_icg_en;                         
output           cp0_hpcp_icg_en;                
output  [11 :0]  cp0_hpcp_index;                 
output           cp0_hpcp_int_disable;           
output  [31 :0]  cp0_hpcp_mcntwen;               
output           cp0_hpcp_pmdm;                  
output           cp0_hpcp_pmds;                  
output           cp0_hpcp_pmdu;                  
output  [63 :0]  cp0_hpcp_wdata;                 
output           cp0_idu_cskyee;                 
output           cp0_idu_dlb_disable;            
output  [2  :0]  cp0_idu_frm;                    
output  [1  :0]  cp0_idu_fs;                     
output           cp0_idu_icg_en;                 
output           cp0_idu_iq_bypass_disable;      
output           cp0_idu_light_fence_en;         
output           cp0_idu_rob_fold_disable;       
output           cp0_idu_src2_fwd_disable;       
output           cp0_idu_srcv2_fwd_disable;      
output           cp0_idu_strong_atomic;          
output           cp0_idu_vill;                   
output  [1  :0]  cp0_idu_vs;                     
output  [`VSTART_WIDTH-1  :0]  cp0_idu_vstart;                 
output           cp0_idu_zero_delay_move_disable; 
output           cp0_ifu_bht_en;                 
output           cp0_ifu_bht_inv;                
output           cp0_ifu_btb_en;                 
output           cp0_ifu_btb_inv;                
output           cp0_ifu_data_ecc_inj;           
output  [32 :0]  cp0_ifu_data_random;            
output           cp0_ifu_ecc_en;                 
output           cp0_ifu_icache_en;              
output           cp0_ifu_icache_inv;             
output           cp0_ifu_icache_pref_en;         
output  [16 :0]  cp0_ifu_icache_read_index;      
output           cp0_ifu_icache_read_req;        
output  [4  :0]  cp0_ifu_icache_read_type;       
output           cp0_ifu_icache_read_way;        
output           cp0_ifu_icg_en;                 
output           cp0_ifu_ind_btb_en;             
output           cp0_ifu_ind_btb_inv;            
output           cp0_ifu_insde;                  
output           cp0_ifu_iwpe;                   
output           cp0_ifu_l0btb_en;               
output           cp0_ifu_lbuf_en;                
output           cp0_ifu_nsfe;                   
output           cp0_ifu_ras_en;                 
output  [`WK_PC_WIDTH-1 :0]  cp0_ifu_rvbr;                   
output           cp0_ifu_tag_ecc_inj;            
output  [`WK_PPN_WIDTH+1 :0]  cp0_ifu_tag_random;             
output  [`WK_PC_WIDTH-1 :0]  cp0_ifu_vbr;                    
output  [`VL_WIDTH-1 :0]  cp0_ifu_vl;                     
output  [2  :0]  cp0_ifu_vlmul;                  
output           cp0_ifu_vsetvli_pred_disable;   
output           cp0_ifu_vsetvli_pred_mode;      
output  [2  :0]  cp0_ifu_vsew;                   
output           cp0_ifu_vma;  // add by tmj @20251127                 
output           cp0_ifu_vta;  // add by tmj @20251127                 
output           cp0_iu_div_entry_disable;       
output           cp0_iu_div_entry_disable_clr;   
output  [`WK_PC_WIDTH-2 :0]  cp0_iu_ex3_efpc;                
output           cp0_iu_ex3_efpc_vld;            
output           cp0_iu_icg_en;                  
output           cp0_iu_vill;                    
output  [`VL_WIDTH-1 :0]  cp0_iu_vl;                  
output  [2  :0]  cp0_iu_vlmul; // add by tmj @20251218                     
output  [2  :0]  cp0_iu_vsew;  // add by tmj @20251218        
output           cp0_iu_vsetvli_pre_decd_disable; 
output  [`VSTART_WIDTH-1  :0]  cp0_iu_vstart;                  
output           cp0_lsu_amr;                    
output           cp0_lsu_amr2;                   
output           cp0_lsu_cb_aclr_dis;            
output           cp0_lsu_corr_dis;               
output           cp0_lsu_ctc_flush_dis;          
output           cp0_lsu_da_fwd_dis;             
output           cp0_lsu_data_ecc_inj;           
output  [38 :0]  cp0_lsu_data_random;            
output           cp0_lsu_dcache_clr;             
output           cp0_lsu_dcache_en;              
output           cp0_lsu_dcache_inv;             
output  [1  :0]  cp0_lsu_dcache_pref_dist;       
output           cp0_lsu_dcache_pref_en;         
output  [16 :0]  cp0_lsu_dcache_read_index;      
output           cp0_lsu_dcache_read_req;        
output  [3  :0]  cp0_lsu_dcache_read_type;       
output  [1  :0]  cp0_lsu_dcache_read_way;        
output           cp0_lsu_delay_mnt_dis;          
output           cp0_lsu_delay_mnt_force;        
output  [1  :0]  cp0_lsu_delay_mnt_max;          
output           cp0_lsu_ecc_en;                 
output           cp0_lsu_fencei_broad_dis;       
output           cp0_lsu_fencerw_broad_dis;      
output           cp0_lsu_icg_en;                 
output  [1  :0]  cp0_lsu_l2_pref_dist;           
output           cp0_lsu_l2_pref_en;             
output           cp0_lsu_l2_st_pref_en;
output           cp0_lsu_ld_stride_cm_hw_pref_en;
output           cp0_lsu_va_based_hw_pref_en;
output  [3  :0]  cp0_pf_aggr_range;
output           cp0_region_pf_dynamic;
output           cp0_region_pf_conservative;
output           cp0_region_pf_very_conservative;
output           cp0_region_pf_most_conservative;          
output           cp0_lsu_mm;                     
output           cp0_lsu_nsfe;                   
output           cp0_lsu_pfu_mmu_dis;            
output           cp0_lsu_tag_ecc_inj;            
output  [`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0]        cp0_lsu_tag_random0;            
output  [`WK_LS_DCAHCE_SINGLE_MATE_TAG_WIDTH-1:0]     cp0_lsu_tag_random1;            
output  [29 :0]  cp0_lsu_timeout_cnt;            
output           cp0_lsu_tlb_broad_dis;          
output           cp0_lsu_tvm;                    
output           cp0_lsu_ucme;                   
output  [`VSTART_WIDTH-1  :0]  cp0_lsu_vstart;                 
output           cp0_lsu_wa;                     
output           cp0_lsu_wr_burst_dis;           
output           cp0_mmu_cskyee;                 
output           cp0_mmu_data_ecc_inj;           
output  [`MMU_DATA_WIDTH+1 :0]  cp0_mmu_data_random;            
output           cp0_mmu_ecc_en;                 
output           cp0_mmu_icg_en;                 
output           cp0_mmu_maee;                   
output  [1  :0]  cp0_mmu_mpp;                    
output           cp0_mmu_mprv;                   
output           cp0_mmu_mxr;                    
output           cp0_mmu_pa_equal_va;            
output           cp0_mmu_ptw_en;                 
output  [2  :0]  cp0_mmu_reg_num;                
output           cp0_mmu_satp_sel;               
output           cp0_mmu_sum;                    
output           cp0_mmu_tag_ecc_inj;            
output  [50 :0]  cp0_mmu_tag_random;             
output  [63 :0]  cp0_mmu_wdata;                  
output           cp0_mmu_wreg;                   
output  [63 :0]  cp0_pad_mstatus;                
output           cp0_pmp_icg_en;                 
output  [1  :0]  cp0_pmp_mpp;                    
output           cp0_pmp_mprv;                   
output  [11  :0]  cp0_pmp_reg_num;                
output  [63 :0]  cp0_pmp_wdata;                  
output           cp0_pmp_wreg;                   
output           cp0_rtu_icg_en;                 
output           cp0_rtu_srt_en;                 
output  [63 :0]  cp0_vfpu_fcsr;                  
output  [31 :0]  cp0_vfpu_fxcr;                  
output           cp0_vfpu_icg_en;                
output           cp0_xx_core_icg_en;             
output           cp0_yy_dcache_pref_en;          
output           cp0_yy_hyper;                   
output  [1  :0]  cp0_yy_priv_mode;               
output           cp0_yy_virtual_mode;            
output           regs_iui_cfr_no_op;             
output           regs_iui_chk_vld;               
output           regs_iui_cindex_l2;             
output           regs_iui_cins_no_op;            
output           regs_iui_cskyee;                
output  [63 :0]  regs_iui_data_out;              
output           regs_iui_dca_sel;               
output           regs_iui_fs_off;                
output           regs_iui_hpcp_regs_sel;         
output           regs_iui_hpcp_scr_inv;          
output  [14 :0]  regs_iui_int_sel;               
output           regs_iui_l2_regs_sel;           
output           regs_iui_mcins;                 
output  [1  :0]  regs_iui_pm;                    
output  [3  :0]  regs_iui_reg_idx;               
output           regs_iui_scnt_inv;              
output           regs_iui_tee_ff;                
output           regs_iui_tee_vld;               
output           regs_iui_tsr;                   
output           regs_iui_tvm;                   
output           regs_iui_tw;                    
output           regs_iui_ucnt_inv;              
output           regs_iui_v;                     
output           regs_iui_vs_off;                
output  [63 :0]  regs_iui_wdata;                 
output           regs_lpmd_int_vld;              
output           regs_xx_icg_en;                 

// &Regs; @26
reg              amr;                            
reg              amr2;                           
reg              bht_inv;                        
reg              bpe;                            
reg              btb_inv;                        
reg              btbe;                           
reg              cb_aclr_dis;                    
reg     [63 :0]  cdata0;                         
reg     [63 :0]  cdata1;                         
reg     [127:0]  cdata_read_data;                
reg     [20 :0]  cindex_index;                   
reg     [4  :0]  cindex_rid;                     
reg     [3  :0]  cindex_way;                     
reg              cins_ff;                        
reg              cins_r;                         
reg              clintee;                        
reg              clr;                            
reg     [31 :0]  cnt_sel;                        
reg              corr_dis;                       
reg              cskyisaee;                      
reg              ctc_flush_dis;                  
reg              da_fwd_dis;                     
reg     [63 :0]  data_out;                       
reg              dcache_inv;                     
reg     [1  :0]  dcache_pref_dist;               
reg              dcache_pref_en;
reg              lsu_ld_stride_cm_hw_pref_en;
reg              lsu_va_based_hw_pref_en; 
reg     [3  :0]  pf_aggr_range;
reg              region_pf_dynamic;
reg              region_pf_conservative;
reg              region_pf_very_conservative;
reg              region_pf_most_conservative;                 
reg              de;                             
reg              delay_mnt_dis;                  
reg              delay_mnt_force;                
reg     [1  :0]  delay_mnt_max;                  
reg              div_entry_dis;                  
reg              dlb_dis;                        
reg              ecc_en;                         
reg     [51 :0]  ecc_random_0;                   
reg     [38 :0]  ecc_random_1_fatal;             
reg              ecc_vld;                        
reg     [15 :0]  edeleg;                         
reg              err_fatal;                      
reg     [16 :0]  err_index;                      
reg     [1  :0]  err_way;                        
reg              fatal_inj;                      
reg              fcsr_dz;                        
reg     [2  :0]  fcsr_frm;                       
reg              fcsr_nv;                        
reg              fcsr_nx;                        
reg              fcsr_of;                        
reg     [1  :0]  vcsr_raw_vxrm;                  
reg              vcsr_raw_vxsat;                 
reg              fcsr_uf;                        
reg              fencei_broad_dis;               
reg              fencerw_broad_dis;              
reg     [5  :0]  fix_cnt;                        
reg     [1  :0]  fs;                             
reg              fxcr_dqnan;                     
reg              fxcr_fe;                        
reg              ibp_inv;                        
reg              ibpe;                           
reg              icache_inv;                     
reg              icache_pref_en;                 
reg              ie;                             
reg     [2  :0]  index;                          
reg              inj_en;                         
reg     [2  :0]  inj_ramid;                      
reg              insde;                          
reg              iq_bypass_dis;                  
reg              iwpe;                           
reg              l0btbe;                         
reg     [1  :0]  l2_pref_dist;                   
reg     [3  :0]  l2_regs_idx;                    
reg              l2pld;                          
reg              l2stpld;                        
reg     [8  :0]  local_icg_en;                   
reg              lpe;                            
reg              m_intr;                         
reg     [4  :0]  m_vector;                       
reg              maee;                                               
reg     [31 :0]  mcnten_reg;                     
reg     [31 :0]  mcntwen_reg;                    
reg     [31 :0]  mcpuid_value;                   
reg              meie;                           
reg     [62 :0]  mepc_reg;                       
reg              mhrd;                           
reg              mie_bit;                        
reg              mm;                                                
reg              mpie;                           
reg     [1  :0]  mpp;                            
reg              mprv;                           
reg     [`WK_PC_WIDTH-2 :0]  mrvbr_reg;                      
reg     [63 :0]  mscratch_value;                 
reg              msie;                           
reg              mtie;                           
reg     [63 :0]  mtval_data;                     
reg     [61 :0]  mtvec_base;                     
reg     [1  :0]  mtvec_mode;                     
reg              mxr;                            
reg              nsfe;                           
reg     [3  :0]  par_dis;                        
reg              pfu_mmu_dis;                    
reg     [1  :0]  pm;                             
reg     [1  :0]  pm_wdata;                       
reg              pmdm;                           
reg              pmds;                           
reg              pmdu;                           
reg     [2  :0]  ramid;                          
reg              rob_fold_dis;                   
reg              rse;                            
reg              rst_sample;                     
reg              s_intr;                         
reg     [4  :0]  s_vector;                       
reg     [`WK_PA_WIDTH-1 :0]  sbepa;                          
reg     [31 :0]  scnten_reg;                     
reg              seie;                           
reg              seie_deleg;                                         
reg     [1  :0]  sel;                            
reg     [62 :0]  sepc_reg;                       
reg              sie_bit;                        
reg              spie;                           
reg              spp;                            
reg              src2_fwd_dis;                   
reg              srcv2_fwd_dis;                  
reg              sre;                            
reg     [63 :0]  sscratch_value;                 
reg              ssie;                           
reg              ssie_deleg;                                           
reg              stie;                           
reg              stie_deleg;                                           
reg              strong_atomic;                  
reg     [63 :0]  stval_data;                     
reg     [61 :0]  stvec_base;                     
reg     [1  :0]  stvec_mode;                     
reg              sum;                            
reg     [29 :0]  timeout_cnt;                    
reg              tlb_broad_dis;                  
reg              tsr;                            
reg              tvm;                            
reg              tw;                             
reg              ucme;                           
reg     [18 :0]  vec_num;                        
reg     [`VL_WIDTH-1 :0]  vl_raw_vl;                      
reg     [1  :0]  vs_raw;                         
reg              vsetvli_dis;                    
reg              vsetvli_pred;                   
reg     [`VSTART_WIDTH-1  :0]  vstart_raw_vstart;              
reg              vtype_raw_vill;                 
reg     [2  :0]  vtype_raw_vlmul;                
reg     [2  :0]  vtype_raw_vsew;   
reg              vtype_raw_vta;
reg              vtype_raw_vma;
reg              wa;                             
reg              wr_burst_dis;                   
reg              zero_move_dis;                  

// &Wires; @27
wire    [`WK_PA_WIDTH-1 :0]  biu_cp0_apb_base;               
wire             biu_cp0_cmplt;                  
wire    [63  :0] biu_cp0_coreid;                 
wire             biu_cp0_me_int;                 
wire             biu_cp0_ms_int;                 
wire             biu_cp0_mt_int;                 
wire    [127:0]  biu_cp0_rdata;                  
wire    [`WK_PC_WIDTH-1 :0]  biu_cp0_rvba;                   
wire             biu_cp0_se_int;                 
wire             biu_cp0_ss_int;                 
wire             biu_cp0_st_int;        
`ifdef ADD_AIA  
wire             cp0_aia_wreg;  //output to AIA by chenlili@20251203   
wire    [63 :0]  aia_cp0_data;    //for AIA by Chenlili@20250521               
wire             aia_regs_sel;    //for AIA by Chenlili@20250521
reg     [63 :0]  aia_regs_data;  //for AIA by zhangdunbo@20260606   
wire             aia_mvregs_sel;  //for AIA by zhangdunbo@20260606
wire             aia_tpoiregs_sel;  //for AIA by zhangdunbo@20260606         
`endif                                      
wire             cdata_clk;                      
wire             cdata_data_vld;                 
wire             cfr_bits_done;                  
wire             cindex_rid_dcache_data;         
wire             cindex_rid_dcache_data_ecc;     
wire             cindex_rid_dcache_ld_tag;       
wire             cindex_rid_dcache_ld_tag_ecc;   
wire             cindex_rid_dcache_st_tag;       
wire             cindex_rid_dcache_st_tag_ecc;   
wire             cindex_rid_dtcm;                
wire             cindex_rid_dtcm_ecc;            
wire             cindex_rid_icache_data;         
wire             cindex_rid_icache_data_ecc;     
wire             cindex_rid_icache_predecode;    
wire             cindex_rid_icache_tag;          
wire             cindex_rid_icache_tag_ecc;      
wire             cindex_rid_itcm;                
wire             cindex_rid_itcm_ecc;            
wire             cindex_rid_itcm_predecode;      
wire             cindex_rid_l2cache_data;        
wire             cindex_rid_l2cache_data_ecc;    
wire             cindex_rid_l2cache_tag;         
wire             cindex_rid_l2cache_tag_ecc;     
wire             cins_no_op_data_vld;            
wire             cins_read_data_vld;             
wire             clr_done;                       
wire             cp0_biu_icg_en;                 
wire             cp0_ecc_fatal;                  
wire    [16 :0]  cp0_ecc_idx;                    
wire    [`WK_PA_WIDTH-1 :0]  cp0_ecc_pa;                     
wire    [2  :0]  cp0_ecc_ramid;                  
wire             cp0_ecc_vld;                    
wire    [1  :0]  cp0_ecc_way;                             
wire             cp0_hpcp_icg_en;                
wire    [11 :0]  cp0_hpcp_index;                 
wire             cp0_hpcp_int_disable;           
wire    [31 :0]  cp0_hpcp_mcntwen;               
wire             cp0_hpcp_pmdm;                  
wire             cp0_hpcp_pmds;                  
wire             cp0_hpcp_pmdu;                  
wire    [63 :0]  cp0_hpcp_wdata;                 
wire             cp0_idu_cskyee;                 
wire             cp0_idu_dlb_disable;            
wire    [2  :0]  cp0_idu_frm;                    
wire    [1  :0]  cp0_idu_fs;                     
wire             cp0_idu_icg_en;                 
wire             cp0_idu_iq_bypass_disable;      
wire             cp0_idu_light_fence_en;         
wire             cp0_idu_rob_fold_disable;       
wire             cp0_idu_src2_fwd_disable;       
wire             cp0_idu_srcv2_fwd_disable;      
wire             cp0_idu_strong_atomic;          
wire             cp0_idu_vill;                   
wire    [1  :0]  cp0_idu_vs;                     
wire    [`VSTART_WIDTH-1  :0]  cp0_idu_vstart;                 
wire             cp0_idu_zero_delay_move_disable; 
wire             cp0_ifu_bht_en;                 
wire             cp0_ifu_bht_inv;                
wire             cp0_ifu_btb_en;                 
wire             cp0_ifu_btb_inv;                
wire             cp0_ifu_data_ecc_inj;           
wire    [32 :0]  cp0_ifu_data_random;            
wire             cp0_ifu_ecc_en;                 
wire             cp0_ifu_icache_en;              
wire             cp0_ifu_icache_inv;             
wire             cp0_ifu_icache_pref_en;         
wire    [16 :0]  cp0_ifu_icache_read_index;      
wire             cp0_ifu_icache_read_req;        
wire    [4  :0]  cp0_ifu_icache_read_type;       
wire             cp0_ifu_icache_read_way;        
wire             cp0_ifu_icg_en;                 
wire             cp0_ifu_ind_btb_en;             
wire             cp0_ifu_ind_btb_inv;            
wire             cp0_ifu_insde;                  
wire             cp0_ifu_iwpe;                   
wire             cp0_ifu_l0btb_en;               
wire             cp0_ifu_lbuf_en;                
wire             cp0_ifu_nsfe;                   
wire             cp0_ifu_ras_en;                 
wire    [`WK_PC_WIDTH-1 :0]  cp0_ifu_rvbr;                   
wire             cp0_ifu_tag_ecc_inj;            
wire    [`WK_PPN_WIDTH+1 :0]  cp0_ifu_tag_random;             
wire    [`WK_PC_WIDTH-1 :0]  cp0_ifu_vbr;                    
wire    [`VL_WIDTH-1 :0]  cp0_ifu_vl;                     
wire    [2  :0]  cp0_ifu_vlmul;                  
wire             cp0_ifu_vsetvli_pred_disable;   
wire             cp0_ifu_vsetvli_pred_mode;      
wire    [2  :0]  cp0_ifu_vsew;                   
wire             cp0_ifu_vma;   // add by tmj @20251127                
wire             cp0_ifu_vta;   // add by tmj @20251127                
wire             cp0_iu_div_entry_disable;       
wire             cp0_iu_div_entry_disable_clr;   
wire    [`WK_PC_WIDTH-2 :0]  cp0_iu_ex3_efpc;                
wire             cp0_iu_ex3_efpc_vld;            
wire             cp0_iu_icg_en;                  
wire             cp0_iu_vill;                    
wire    [`VL_WIDTH-1 :0]  cp0_iu_vl;          
wire    [2  :0]  cp0_iu_vlmul; // add by tmj @20251218                     
wire    [2  :0]  cp0_iu_vsew;  // add by tmj @20251218                
wire             cp0_iu_vsetvli_pre_decd_disable; 
wire    [`VSTART_WIDTH-1  :0]  cp0_iu_vstart;                  
wire             cp0_lsu_amr;                    
wire             cp0_lsu_amr2;                   
wire             cp0_lsu_cb_aclr_dis;            
wire             cp0_lsu_corr_dis;               
wire             cp0_lsu_ctc_flush_dis;          
wire             cp0_lsu_da_fwd_dis;             
wire             cp0_lsu_data_ecc_inj;           
wire    [38 :0]  cp0_lsu_data_random;            
wire             cp0_lsu_dcache_clr;             
wire             cp0_lsu_dcache_en;              
wire             cp0_lsu_dcache_inv;             
wire    [1  :0]  cp0_lsu_dcache_pref_dist;       
wire             cp0_lsu_dcache_pref_en;         
wire    [16 :0]  cp0_lsu_dcache_read_index;      
wire             cp0_lsu_dcache_read_req;        
wire    [3  :0]  cp0_lsu_dcache_read_type;       
wire    [1  :0]  cp0_lsu_dcache_read_way;        
wire             cp0_lsu_delay_mnt_dis;          
wire             cp0_lsu_delay_mnt_force;        
wire    [1  :0]  cp0_lsu_delay_mnt_max;          
wire             cp0_lsu_ecc_en;                 
wire             cp0_lsu_fencei_broad_dis;       
wire             cp0_lsu_fencerw_broad_dis;      
wire             cp0_lsu_icg_en;                 
wire    [1  :0]  cp0_lsu_l2_pref_dist;           
wire             cp0_lsu_l2_pref_en;             
wire             cp0_lsu_l2_st_pref_en;
wire             cp0_lsu_ld_stride_cm_hw_pref_en;
wire             cp0_lsu_va_based_hw_pref_en;
wire  [3  :0]    cp0_pf_aggr_range;
wire             cp0_region_pf_dynamic;
wire             cp0_region_pf_conservative;
wire             cp0_region_pf_very_conservative;
wire             cp0_region_pf_most_conservative;           
wire             cp0_lsu_mm;                     
wire             cp0_lsu_nsfe;                   
wire             cp0_lsu_pfu_mmu_dis;            
wire             cp0_lsu_tag_ecc_inj;            
wire    [`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0]        cp0_lsu_tag_random0;            
wire    [`WK_LS_DCAHCE_SINGLE_MATE_TAG_WIDTH-1:0]     cp0_lsu_tag_random1;            
wire    [29 :0]  cp0_lsu_timeout_cnt;            
wire             cp0_lsu_tlb_broad_dis;          
wire             cp0_lsu_tvm;                    
wire             cp0_lsu_ucme;                   
wire    [`VSTART_WIDTH-1  :0]  cp0_lsu_vstart;                 
wire             cp0_lsu_wa;                     
wire             cp0_lsu_wr_burst_dis;           
wire             cp0_mmu_cskyee;                 
wire             cp0_mmu_data_ecc_inj;           
wire    [`MMU_DATA_WIDTH+1 :0]  cp0_mmu_data_random;            
wire             cp0_mmu_ecc_en;                 
wire             cp0_mmu_icg_en;                 
wire             cp0_mmu_maee;                   
wire    [1  :0]  cp0_mmu_mpp;                    
wire             cp0_mmu_mprv;                   
wire             cp0_mmu_mxr;                    
wire             cp0_mmu_pa_equal_va;            
wire             cp0_mmu_ptw_en;                 
wire    [2  :0]  cp0_mmu_reg_num;                
wire             cp0_mmu_satp_sel;               
wire             cp0_mmu_sum;                    
wire             cp0_mmu_tag_ecc_inj;            
wire    [50 :0]  cp0_mmu_tag_random;             
wire    [63 :0]  cp0_mmu_wdata;                  
wire             cp0_mmu_wreg;                   
wire             cp0_mret;                       
wire    [63 :0]  cp0_pad_mstatus;                
wire             cp0_pmp_icg_en;                 
wire    [1  :0]  cp0_pmp_mpp;                    
wire             cp0_pmp_mprv;                   
wire    [11  :0]  cp0_pmp_reg_num;                
wire    [63 :0]  cp0_pmp_wdata;                  
wire             cp0_pmp_wreg;                   
wire             cp0_regs_sel;                   
wire             cp0_rtu_icg_en;                 
wire             cp0_rtu_srt_en;                 
wire             cp0_sret;                       
wire    [63 :0]  cp0_vfpu_fcsr;                  
wire    [31 :0]  cp0_vfpu_fxcr;                  
wire             cp0_vfpu_icg_en;                
wire             cp0_xx_core_icg_en;             
wire             cp0_yy_dcache_pref_en;          
wire             cp0_yy_hyper;                   
wire    [1  :0]  cp0_yy_priv_mode;               
wire             cp0_yy_virtual_mode;            
wire    [31 :0]  cpuid_index0_value;             
wire    [31 :0]  cpuid_index1_value;             
wire    [31 :0]  cpuid_index2_value;             
wire    [31 :0]  cpuid_index3_value;             
wire    [31 :0]  cpuid_index4_value;             
wire             cpuid_index5_core_num_1;        
wire             cpuid_index5_core_num_2;        
wire             cpuid_index5_core_num_3;        
wire    [31 :0]  cpuid_index5_value;             
wire    [31 :0]  cpuid_index6_value;             
wire             cpurst_b;                       
wire             dcache_ecc_vld;                 
wire             dtcm_icg_en;                    
wire             ecc_clk;                        
wire             ecc_clk_en;                     
wire             ecc_err_clr;                    
wire             ecc_int_vld;                    
wire    [51 :0]  ecc_random_0_updt;              
wire    [38 :0]  ecc_random_1;                   
wire    [38 :0]  ecc_random_1_fatal_updt;        
wire    [15 :0]  edeleg_upd_val;                 
wire    [25 :0]  extensions;                     
wire             fccee;                          
wire             fcsr_local_en;                  
wire    [63 :0]  fcsr_value;                                       
wire             fflags_local_en;                
wire    [63 :0]  fflags_value;                   
wire             forever_cpuclk;                 
wire             frm_local_en;                   
wire    [63 :0]  frm_value;                      
wire             fs_dirty_upd;                   
wire             fs_dirty_upd_gate;              
wire             fxcr_local_en;                  
wire    [63 :0]  fxcr_value;                     
wire    [63 :0]  hedeleg_value;                  
wire    [63 :0]  hpcp_cp0_data;                  
wire             hpcp_cp0_int_vld;               
wire             hpcp_cp0_sce;                   
wire             hpm_regs_sel;                   
wire    [63 :0]  hstatus_value;                  
wire    [6  :0]  idu_cp0_fesr_acc_updt_val;      
wire             idu_cp0_fesr_acc_updt_vld;      
wire             ifu_cp0_bht_inv_done;           
wire             ifu_cp0_btb_inv_done;           
wire             ifu_cp0_data_inj_cmplt;         
wire             ifu_cp0_ecc_fatal;              
wire    [16 :0]  ifu_cp0_ecc_idx;                
wire    [2  :0]  ifu_cp0_ecc_ramid;              
wire             ifu_cp0_ecc_vld;                
wire    [1  :0]  ifu_cp0_ecc_way;                
wire             ifu_cp0_icache_inv_done;        
wire    [127:0]  ifu_cp0_icache_read_data;       
wire             ifu_cp0_icache_read_data_vld;   
wire             ifu_cp0_ind_btb_inv_done;       
wire             ifu_cp0_rst_inv_req;            
wire             ifu_cp0_tag_inj_cmplt;          
wire             ifu_sel;                        
wire             index_max;                      
wire    [2  :0]  index_next_val;                 
wire             inj_done;                       
wire    [14 :0]  int_sel;                        
wire             inv;                            
wire             itcm_icg_en;                    
wire    [11 :0]  iui_regs_addr;                  
wire             iui_regs_csr_wr;                
wire             iui_regs_csrw;                  
wire             iui_regs_ex3_inst_csr;          
wire             iui_regs_inst_mret;             
wire             iui_regs_inst_sret;             
wire             iui_regs_inv_expt;              
wire    [63 :0]  iui_regs_ori_src0;              
wire             iui_regs_rst_inv_d;             
wire             iui_regs_rst_inv_i;             
wire             iui_regs_sel;                   
wire    [63 :0]  iui_regs_src0;                  
wire             l2_regs_sel;                    
wire             light_fence_en;                 
wire             lsu_cp0_data_inj_cmplt;         
wire             lsu_cp0_dcache_done;            
wire    [127:0]  lsu_cp0_dcache_read_data;       
wire             lsu_cp0_dcache_read_data_vld;   
wire             lsu_cp0_ecc_fatal;              
wire    [16 :0]  lsu_cp0_ecc_idx;                
wire    [2  :0]  lsu_cp0_ecc_ramid;              
wire    [`WK_PA_WIDTH-1 :0]  lsu_cp0_ecc_sbepa;              
wire             lsu_cp0_ecc_vld;                
wire    [1  :0]  lsu_cp0_ecc_way;                
wire             lsu_cp0_tag_inj_cmplt;          
wire             lsu_sel;                        
wire    [63 :0]  mapbaddr_value;                 
wire    [63 :0]  marchid_value;                  
wire             mcause_local_en;                
wire    [63 :0]  mcause_value;                   
wire             mccr2_local_en;                 
wire    [63 :0]  mcdata0_value;                  
wire    [63 :0]  mcdata1_value;                  
wire             mcer2_local_en;                 
wire             mcer_local_en;                  
wire    [63 :0]  mcer_value;                     
wire             mcindex_local_en;               
wire    [63 :0]  mcindex_value;                  
wire             mcins_local_en;                 
wire    [63 :0]  mcins_value;                                                                                                                        
wire             mcnten_hit;                     
wire             mcnten_local_en;                
wire    [63 :0]  mcnten_value;                   
wire             mcntwen_hit;                    
wire             mcntwen_local_en;               
wire    [63 :0]  mcntwen_value;                  
wire             mcor_local_en;                  
wire    [63 :0]  mcor_value;                     
wire             mcpuid_local_en;                
wire             mdeleg_vld;                     
wire    [63 :0]  mdtcmcr_value;                  
wire             medeleg_local_en;               
wire    [63 :0]  medeleg_value;                  
wire             medeleg_vld;                    
wire             meicr2_local_en;                
wire             meicr_local_en;                 
wire    [63 :0]  meicr_value;                    
wire             meip;                           
wire             meip_en;                        
wire             meip_vld;                       
wire             mepc_local_en;                  
wire    [63 :0]  mepc_value;                     
wire    [63 :0]  mhartid_value;                  
wire             mhcr_local_en;                  
wire    [63 :0]  mhcr_value;                                        
wire             mhint2_local_en;                
wire    [63 :0]  mhint2_value;                   
wire             mhint3_local_en;                
wire    [63 :0]  mhint3_value;                   
wire             mhint4_local_en;                
wire             mhint_local_en;                 
wire    [63 :0]  mhint_value;                                  
wire             mhpmcr_local_en;                
wire             mideleg_local_en;               
wire    [63 :0]  mideleg_value;                  
wire             mideleg_vld;                    
wire             mie_local_en;                   
wire    [63 :0]  mie_value;                      
wire    [63 :0]  miesr_value;                    
wire    [63 :0]  mimpid_value;                   
wire             mip_local_en;                                 
wire    [63 :0]  mip_value;                      
wire             misa_hypervisor;                
wire             misa_local_en;                  
wire    [63 :0]  misa_value;                     
wire             misa_vector;                    
wire    [63 :0]  mitcmcr_value;                  
wire    [63 :0]  mmu_cp0_data;                   
wire             mmu_cp0_data_inj_cmplt;         
wire    [8  :0]  mmu_cp0_ecc_idx;                
wire    [2  :0]  mmu_cp0_ecc_ramid;              
wire             mmu_cp0_ecc_vld;                
wire    [1  :0]  mmu_cp0_ecc_way;                
wire    [63 :0]  mmu_cp0_satp_data;              
wire             mmu_cp0_tag_inj_cmplt;          
wire             mmu_regs_sel;                                 
wire             mpv;                            
wire    [63 :0]  mrvbr_value;                    
wire             msbepa2_local_en;               
wire             msbepa_local_en;                
wire    [63 :0]  msbepa_value;                   
wire             mscratch_local_en;              
wire             msip;                           
wire             msip_en;                        
wire             msip_vld;                       
wire             msmpr_local_en;                 
wire             mstatus_local_en;               
wire    [63 :0]  mstatus_value;                  
wire             mteecfg_local_en;               
wire    [63 :0]  mteecfg_value;                  
wire             mtip;                           
wire             mtip_en;                        
wire             mtip_vld;                       
wire             mtval_local_en;                 
wire    [63 :0]  mtval_upd_data;                 
wire    [63 :0]  mtval_value;                    
wire             mtvec_local_en;                 
wire    [63 :0]  mtvec_value;                    
wire    [63 :0]  mvendorid_value;                
wire    [63 :0]  mwmsr_value;                    
wire    [1  :0]  mxl;                            
wire             mxstatus_local_en;              
wire    [63 :0]  mxstatus_value;                 
wire             pa_equal_va;                    
wire             pad_yy_icg_scan_en;             
wire             pm_wen;                         
wire    [63 :0]  pmp_cp0_data;                   
wire             pmp_regs_sel;                   
wire    [`WK_PPN_WIDTH+1 :0]  random_30_bit;                  
wire    [32 :0]  random_33_bit;                  
wire    [33 :0]  random_34_bit;                  
wire    [36 :0]  random_37_bit;
wire    [37 :0]  random_38_bit;                 
wire    [38 :0]  random_39_bit;
wire    [40 :0]  random_41_bit;                  
wire    [41 :0]  random_42_bit;
wire    [43 :0]  random_44_bit;                  
wire    [44 :0]  random_45_bit;
wire    [50 :0]  random_51_bit;                  
wire    [51 :0]  random_52_bit;
wire             regs_cindex_sel_l2;             
wire             regs_clk;                       
wire             regs_clk_en;                    
wire             regs_dca_sel;                   
wire             regs_flush_clk;                 
wire             regs_flush_clk_en;              
wire             regs_iui_cfr_no_op;             
wire             regs_iui_chk_vld;               
wire             regs_iui_cindex_l2;             
wire             regs_iui_cins_no_op;            
wire             regs_iui_cskyee;                
wire    [63 :0]  regs_iui_data_out;              
wire             regs_iui_dca_sel;               
wire             regs_iui_fs_off;                
wire             regs_iui_hpcp_regs_sel;         
wire             regs_iui_hpcp_scr_inv;          
wire    [14 :0]  regs_iui_int_sel;               
wire             regs_iui_l2_regs_sel;           
wire             regs_iui_mcins;                 
wire    [1  :0]  regs_iui_pm;                    
wire    [3  :0]  regs_iui_reg_idx;               
wire             regs_iui_scnt_inv;              
wire             regs_iui_tee_ff;                
wire             regs_iui_tee_vld;               
wire             regs_iui_tsr;                   
wire             regs_iui_tvm;                   
wire             regs_iui_tw;                    
wire             regs_iui_ucnt_inv;              
wire             regs_iui_v;                     
wire             regs_iui_vs_off;                
wire    [63 :0]  regs_iui_wdata;                 
wire             regs_lpmd_int_vld;              
wire             regs_xx_icg_en;                 
wire    [63 :0]  rtu_cp0_epc;                    
wire             rtu_cp0_expt_gateclk_vld;       
wire    [63 :0]  rtu_cp0_expt_mtval;             
wire             rtu_cp0_expt_vld;               
wire             rtu_cp0_fp_dirty_vld;           
wire             rtu_cp0_vec_dirty_vld;          
wire             rtu_cp0_vsetvl_vill;            
wire    [`VL_WIDTH-1 :0]  rtu_cp0_vsetvl_vl;              
wire             rtu_cp0_vsetvl_vl_vld;          
wire    [2  :0]  rtu_cp0_vsetvl_vlmul;           
wire    [2  :0]  rtu_cp0_vsetvl_vsew;            
wire             rtu_cp0_vsetvl_vta;           
wire             rtu_cp0_vsetvl_vma;  
wire             rtu_cp0_vsetvl_vtype_vld;       
wire    [`VSTART_WIDTH-1  :0]  rtu_cp0_vstart;                 
wire             rtu_cp0_vstart_vld;             
wire    [5  :0]  rtu_yy_xx_expt_vec;             
wire             rtu_yy_xx_flush;                
wire             satp_local_en;                  
wire             scause_local_en;                
wire    [63 :0]  scause_value;                   
wire             scer2_local_en;                 
wire             scer_local_en;                  
wire    [63 :0]  scer_value;                     
wire    [2  :0]  sck;                            
wire             scnt_addr_hit;                  
wire             scnten_hit;                     
wire             scnten_local_en;                
wire    [63 :0]  scnten_value;                   
wire             sd;                             
wire             seip;                           
wire             seip_acc_en;                    
wire             seip_deleg_vld;                 
wire             seip_en;                        
wire             seip_nodeleg_vld;                                  
wire             sepc_local_en;                  
wire    [63 :0]  sepc_value;                     
wire    [63 :0]  shcr_value;                     
wire             shpmcr_local_en;                
wire             sie_local_en;                   
wire    [63 :0]  sie_value;                      
wire    [63 :0]  siesr_value;                    
wire             sip_local_en;                   
wire    [63 :0]  sip_value;                      
wire             ssbepa2_local_en;               
wire             ssbepa_local_en;                
wire    [63 :0]  ssbepa_value;                   
wire             sscratch_local_en;              
wire             ssip;                           
wire             ssip_acc_en;                    
wire             ssip_deleg_vld;                 
wire             ssip_en;                        
wire             ssip_nodeleg_vld;                               
wire             sstatus_local_en;               
wire             sstatus_spp;                    
wire    [63 :0]  sstatus_value;                  
wire             stip;                           
wire             stip_acc_en;                    
wire             stip_deleg_vld;                 
wire             stip_en;                        
wire             stip_nodeleg_vld;                                 
wire             stval_local_en;                 
wire    [63 :0]  stval_upd_data;                 
wire    [63 :0]  stval_value;                    
wire             stvec_local_en;                 
wire    [63 :0]  stvec_value;                    
wire    [1  :0]  sxl;                            
wire             sxstatus_local_en;              
wire    [63 :0]  sxstatus_value;                 
wire             tee_ff;                         
wire             tee_lock;                       
wire             ucnt_addr_hit;                  
wire    [1  :0]  uxl;                            
wire             v;                              
wire             ve;                             
wire             vec_clk;                        
wire             vec_clk_en;                     
wire    [63 :0]  vl_value;                       
wire    [`VL_WIDTH-1 :0]  vl_vl;                          
wire    [63 :0]  vlenb_value;                    
wire    [1  :0]  vs;                             
wire             vs_dirty_upd;                   
wire             vs_dirty_upd_gate;              
wire    [63 :0]  vsstatus_value;                 
wire             vstart_local_en;                
wire    [63 :0]  vstart_value;                   
wire    [`VSTART_WIDTH-1  :0]  vstart_vstart;                  
wire    [63 :0]  vtype_value;                    
wire             vtype_vill;                     
wire    [2  :0]  vtype_vlmul;                    
wire    [2  :0]  vtype_vsew;      
wire             vtype_vma;
wire             vtype_vta;               
wire             vxrm_local_en;                  
wire    [63 :0]  vxrm_value;                     
wire             vxsat_local_en;                 
wire    [63 :0]  vxsat_value;                    
wire             vcsr_local_en;                 
wire    [63 :0]  vcsr_value;                    
wire             wb;                             
wire             wbr;                            
wire    [1  :0]  xs;                             
wire             xtcm_1bit_wb_dis;               

//==========================================================
//                  Risc-V Debug zdb Begin
//==========================================================
input                         dtu_cp0_dcsr_mprven;
input   [63 :0]               dtu_cp0_rdata;
input   [1  :0]               dtu_yy_dcsr_prv;
input                         iui_regs_ex1_read_sel;
input                         iui_regs_ex2_write_sel;
input                         iui_regs_fsm_busy;
input                         iui_regs_wreg_for_dtu_hpcp;
input   [1  :0]               rtu_cp0_dbg_pm;
input                         rtu_cp0_enter_debug;
input                         rtu_cp0_exit_debug;
input                         rtu_yy_xx_dbgon;
input                         rtu_yy_xx_expt_vld;

output  [11 :0]               cp0_dtu_addr;
output                        cp0_dtu_icg_en;
output                        cp0_dtu_mexpt_vld;
output                        cp0_dtu_pcfifo_frz;
output  [1  :0]               cp0_dtu_priv_mode;
output                        cp0_dtu_rreg;
output  [63 :0]               cp0_dtu_satp;
output                        cp0_dtu_sel;
output                        cp0_dtu_sel_gateclk;
output  [63 :0]               cp0_dtu_wdata;
output                        cp0_dtu_wreg;
output                        cp0_yy_mmu_en;
output                        cp0_yy_sv39_en;
output                        cp0_yy_sv48_en;
output  [3  :0]               cp0_yy_zoneid;
output                        regs_iui_dtu_regs_sel;
output                        regs_iui_mmu_regs_sel;

//input
wire                          dtu_cp0_dcsr_mprven;
wire    [63 :0]               dtu_cp0_rdata;
wire    [1  :0]               dtu_yy_dcsr_prv;
wire                          iui_regs_ex1_read_sel;
wire                          iui_regs_ex2_write_sel;
wire                          iui_regs_fsm_busy;
wire                          iui_regs_wreg_for_dtu_hpcp;
wire    [1  :0]               rtu_cp0_dbg_pm;
wire                          rtu_cp0_enter_debug;
wire                          rtu_cp0_exit_debug;
wire                          rtu_yy_xx_dbgon;
wire                          rtu_yy_xx_expt_vld;
//output
wire    [11 :0]               cp0_dtu_addr;
wire                          cp0_dtu_icg_en;
wire                          cp0_dtu_mexpt_vld;
wire                          cp0_dtu_pcfifo_frz;
wire    [1  :0]               cp0_dtu_priv_mode;
wire                          cp0_dtu_rreg;
wire    [63 :0]               cp0_dtu_satp;
wire                          cp0_dtu_sel;
wire                          cp0_dtu_sel_gateclk;
wire    [63 :0]               cp0_dtu_wdata;
wire                          cp0_dtu_wreg;
wire                          cp0_yy_mmu_en;
wire                          cp0_yy_sv39_en;
wire                          cp0_yy_sv48_en;
wire    [3  :0]               cp0_yy_zoneid;
wire                          regs_iui_dtu_regs_sel;
wire                          regs_iui_mmu_regs_sel;

reg                           dtu_local_icg_en;
reg     [9  :0]               icg_module_en;
reg     [1  :0]               mprv_pm_out;
reg                           pcfifo_frz;
reg     [1  :0]               pm_out;
reg     [15 :0]               satp_asid;
reg     [3  :0]               satp_mode;
reg     [`WK_PPN_WIDTH-1:0]   satp_ppn;
reg     [3  :0]               zoneid;

wire                          dtu_regs_sel;
wire                          effective_mprv;
wire    [9  :0]               icg_module_en_d;  
wire                          mdbginfo2_local_en;                                                              
wire    [1  :0]               mprv_pm;
wire                          mzoneid_local_en;
wire    [63 :0]               mzoneid_value;
wire                          pm_info_flop_out_enable;  
wire                          satp_mode_legal_sv39;
wire                          satp_mode_legal_sxl64; 
wire    [63 :0]               satp_value;
wire                          xret_leave_m_mode; 
//==========================================================
//                  Risc-V Debug zdb End
//==========================================================

//==========================================================
//                  AIA Support Begin
//==========================================================
output  [63:0]  mip_raw;
output  [63:0]  sip_raw;

wire    [63:0]  mip_raw;
wire    [63:0]  sip_raw;

reg             mcie;
reg             moie;
reg      [50:0] mideleg_reg;
reg      [50:0] mie_reg;
reg      [11:0] mtopi_int_vec;
reg      [11:0] stopi_int_vec;
reg      [50:0] mvie_reg;
reg      [50:0] mvien_reg;
reg      [50:0] mvip_reg;
reg      [50:0] mvipn_reg;             
reg             mvseien;             
reg             mvseip;              
reg             mvseipn;                         
reg             mvssien;             
reg             mvssip;              
reg             mvssipn;
reg             mvstip;   

wire    [50:0]  aia_m_ints;
wire            mcip;
wire            mcip_acc_en;
wire            mcip_deleg_vld;
wire            mcip_en;
wire            mcip_nodeleg_vld;   
wire    [50:0]  mideleg;
wire            moip;
wire            moip_acc_en;
wire            moip_deleg_vld;
wire            moip_en; 
wire            moip_nodeleg_vld;   
wire    [7 :0]  mtopi_sel;
wire    [63:0]  mtopi_value;
wire    [50:0]  mvie; 
wire    [50:0]  mvien;               
wire            mvien_local_en;      
wire    [63:0]  mvien_value;         
wire    [50:0]  mvip;                
wire            mvip_local_en;       
wire    [63:0]  mvip_value;   
wire    [50:0]  mvipn;
wire            mvstien;
wire            mvstipn;
wire            seip_s;
wire            stip_s;
wire    [4 :0]  stopi_sel; 
wire    [63:0]  stopi_value;

wire    [50:0]  mie; 
wire    [50:0]  mip;  
wire    [50:0]  sie;   
wire    [50:0]  sip;   

wire            zero_reg;    
assign zero_reg = 1'b0;
//==========================================================
//                  AIA Support End
//==========================================================

//==========================================================
//                 Instance of Gated Cell  
//==========================================================
assign regs_clk_en = iui_regs_sel
                  || idu_cp0_fesr_acc_updt_vld;
// &Instance("gated_clk_cell", "x_regs_gated_clk"); @34
gated_clk_cell  x_regs_gated_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (regs_clk          ),
  .external_en        (1'b0              ),
  .local_en           (regs_clk_en       ),
  .module_en          (regs_xx_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect(.clk_in      (forever_cpuclk), @35
//          .external_en (1'b0), @36
//          .module_en   (regs_xx_icg_en), @37
//          .local_en    (regs_clk_en), @38
//          .clk_out     (regs_clk)); @39

assign vec_clk_en = vstart_local_en
                 || rtu_cp0_vstart_vld
                 || rtu_cp0_vsetvl_vl_vld
                 || rtu_cp0_vsetvl_vtype_vld;
// &Instance("gated_clk_cell", "x_vec_gated_clk"); @45
gated_clk_cell  x_vec_gated_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (vec_clk           ),
  .external_en        (1'b0              ),
  .local_en           (vec_clk_en        ),
  .module_en          (regs_xx_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect(.clk_in      (forever_cpuclk), @46
//          .external_en (1'b0), @47
//          .module_en   (regs_xx_icg_en), @48
//          .local_en    (vec_clk_en), @49
//          .clk_out     (vec_clk)); @50

//assign status_clk_en = iui_regs_sel
//                    || rtu_cp0_expt_gateclk_vld
//                    || iui_regs_inst_mret
//                    || iui_regs_inst_sret;
//
//assign epc_cause_clk_en = iui_regs_sel
//                       || rtu_cp0_expt_gateclk_vld;
//
//assign tval_clk_en = iui_regs_sel
//                  || rtu_cp0_expt_gateclk_vld
//                  || iui_regs_inv_expt;
//
//assign cfr_cins_clk_en = iui_regs_sel
//                      || rtu_yy_xx_flush
//                      || cfr_bits_done
//                      || cins_r
//                      || iui_regs_ex3_inst_csr;
//
//assign mrvbr_clk_en = rst_sample;


assign regs_flush_clk_en = rtu_yy_xx_flush || iui_regs_sel
                        || rtu_cp0_expt_gateclk_vld
                        || cins_r
                        || cfr_bits_done
                        || iui_regs_inst_mret
                        || iui_regs_inst_sret
                        || iui_regs_inv_expt
                        || iui_regs_ex3_inst_csr
                        || fs_dirty_upd_gate
                        || vs_dirty_upd_gate
                        || rst_sample
                        || ifu_cp0_rst_inv_req
                        || tee_ff
                          ;
// &Instance("gated_clk_cell", "x_regs_flush_gated_clk"); @87
gated_clk_cell  x_regs_flush_gated_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (regs_flush_clk    ),
  .external_en        (1'b0              ),
  .local_en           (regs_flush_clk_en ),
  .module_en          (regs_xx_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect(.clk_in      (forever_cpuclk), @88
//          .external_en (1'b0), @89
//          .module_en   (regs_xx_icg_en), @90
//          .local_en    (regs_flush_clk_en), @91
//          .clk_out     (regs_flush_clk)); @92

// &Instance("gated_clk_cell", "x_cp0_cdata_gated_clk"); @94
gated_clk_cell  x_cp0_cdata_gated_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (cdata_clk         ),
  .external_en        (1'b0              ),
  .local_en           (cins_r            ),
  .module_en          (regs_xx_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect(.clk_in(forever_cpuclk), @95
//          .module_en   (regs_xx_icg_en), @96
//          .local_en(cins_r), @97
//          .external_en(1'b0), @98
//          .clk_out(cdata_clk)); @99

// CSR list in C960
// 1. Machine Level CSRs
// Machine Information Registers
parameter MVENDORID = 12'hF11;
parameter MARCHID   = 12'hF12;
parameter MIMPID    = 12'hF13;
parameter MHARTID   = 12'hF14;

// Machine Trap Setup
parameter MSTATUS   = 12'h300;
parameter MISA      = 12'h301;
parameter MEDELEG   = 12'h302;
parameter MIDELEG   = 12'h303;
parameter MIE       = 12'h304;
parameter MTVEC     = 12'h305;
parameter MCNTEN    = 12'h306;
parameter MTOPI     = 12'hFB0;

// Machine Trap Handling
parameter MSCRATCH  = 12'h340;
parameter MEPC      = 12'h341;
parameter MCAUSE    = 12'h342;
parameter MTVAL     = 12'h343;
parameter MIP       = 12'h344;
parameter MVIEN     = 12'h308; //for AIA by zhangdunbo@20260605
parameter MVIP      = 12'h309; //for AIA by zhangdunbo@20260605

// Machine Protection and Translation
parameter PMPCFG0   = 12'h3A0;
parameter PMPADDR0  = 12'h3B0;
parameter PMPADDR1  = 12'h3B1;
parameter PMPADDR2  = 12'h3B2;
parameter PMPADDR3  = 12'h3B3;
parameter PMPADDR4  = 12'h3B4;
parameter PMPADDR5  = 12'h3B5;
parameter PMPADDR6  = 12'h3B6;
parameter PMPADDR7  = 12'h3B7;

// Machine Counters/Timers
parameter MCYCLE    = 12'hB00;
parameter MINSTRET  = 12'hB02;
parameter MHPMCNT3  = 12'hB03;
parameter MHPMCNT4  = 12'hB04;
parameter MHPMCNT5  = 12'hB05;
parameter MHPMCNT6  = 12'hB06;
parameter MHPMCNT7  = 12'hB07;
parameter MHPMCNT8  = 12'hB08;
parameter MHPMCNT9  = 12'hB09;
parameter MHPMCNT10 = 12'hB0A;
parameter MHPMCNT11 = 12'hB0B;
parameter MHPMCNT12 = 12'hB0C;
parameter MHPMCNT13 = 12'hB0D;
parameter MHPMCNT14 = 12'hB0E;
parameter MHPMCNT15 = 12'hB0F;
parameter MHPMCNT16 = 12'hB10;
parameter MHPMCNT17 = 12'hB11;
parameter MHPMCNT18 = 12'hB12;
parameter MHPMCNT19 = 12'hB13;
parameter MHPMCNT20 = 12'hB14;
parameter MHPMCNT21 = 12'hB15;
parameter MHPMCNT22 = 12'hB16;
parameter MHPMCNT23 = 12'hB17;
parameter MHPMCNT24 = 12'hB18;
parameter MHPMCNT25 = 12'hB19;
parameter MHPMCNT26 = 12'hB1A;
parameter MHPMCNT27 = 12'hB1B;
parameter MHPMCNT28 = 12'hB1C;
parameter MHPMCNT29 = 12'hB1D;
parameter MHPMCNT30 = 12'hB1E;
parameter MHPMCNT31 = 12'hB1F;

// Machine Counter Setup
parameter MHPMCR    = 12'h7F0;
parameter MHPMSP    = 12'h7F1;
parameter MHPMEP    = 12'h7F2;
parameter MCNTIHBT  = 12'h320;
parameter MHPMEVT3  = 12'h323;
parameter MHPMEVT4  = 12'h324;
parameter MHPMEVT5  = 12'h325;
parameter MHPMEVT6  = 12'h326;
parameter MHPMEVT7  = 12'h327;
parameter MHPMEVT8  = 12'h328;
parameter MHPMEVT9  = 12'h329;
parameter MHPMEVT10 = 12'h32A;
parameter MHPMEVT11 = 12'h32B;
parameter MHPMEVT12 = 12'h32C;
parameter MHPMEVT13 = 12'h32D;
parameter MHPMEVT14 = 12'h32E;
parameter MHPMEVT15 = 12'h32F;
parameter MHPMEVT16 = 12'h330;
parameter MHPMEVT17 = 12'h331;
parameter MHPMEVT18 = 12'h332;
parameter MHPMEVT19 = 12'h333;
parameter MHPMEVT20 = 12'h334;
parameter MHPMEVT21 = 12'h335;
parameter MHPMEVT22 = 12'h336;
parameter MHPMEVT23 = 12'h337;
parameter MHPMEVT24 = 12'h338;
parameter MHPMEVT25 = 12'h339;
parameter MHPMEVT26 = 12'h33A;
parameter MHPMEVT27 = 12'h33B;
parameter MHPMEVT28 = 12'h33C;
parameter MHPMEVT29 = 12'h33D;
parameter MHPMEVT30 = 12'h33E;
parameter MHPMEVT31 = 12'h33F;


// 2. Supervisor Level CSRs
// Supervisor Trap Setup
parameter SSTATUS   = 12'h100;
parameter SIE       = 12'h104;
parameter STVEC     = 12'h105;
parameter SCNTEN    = 12'h106;

// Supervisor Trap Handling
parameter SSCRATCH  = 12'h140;
parameter SEPC      = 12'h141;
parameter SCAUSE    = 12'h142;
parameter STVAL     = 12'h143;
parameter SIP       = 12'h144;
parameter STOPI     = 12'hDB0;

// Supervisor Protection and Translation
parameter SATP      = 12'h180;


// 3. User Level CSRs
// User Floating-Point CSRs
parameter FFLAGS    = 12'h001;
parameter FRM       = 12'h002;
parameter FCSR      = 12'h003;
parameter VSTART    = 12'h008;
parameter VXSAT     = 12'h009;
parameter VXRM      = 12'h00A;
parameter VCSR      = 12'h00F;

// User Counter/Timers
parameter CYCLE    = 12'hC00;
parameter TIME_CSR = 12'hC01;
parameter INSTRET  = 12'hC02;
parameter HPMCNT3  = 12'hC03;
parameter HPMCNT4  = 12'hC04;
parameter HPMCNT5  = 12'hC05;
parameter HPMCNT6  = 12'hC06;
parameter HPMCNT7  = 12'hC07;
parameter HPMCNT8  = 12'hC08;
parameter HPMCNT9  = 12'hC09;
parameter HPMCNT10 = 12'hC0A;
parameter HPMCNT11 = 12'hC0B;
parameter HPMCNT12 = 12'hC0C;
parameter HPMCNT13 = 12'hC0D;
parameter HPMCNT14 = 12'hC0E;
parameter HPMCNT15 = 12'hC0F;
parameter HPMCNT16 = 12'hC10;
parameter HPMCNT17 = 12'hC11;
parameter HPMCNT18 = 12'hC12;
parameter HPMCNT19 = 12'hC13;
parameter HPMCNT20 = 12'hC14;
parameter HPMCNT21 = 12'hC15;
parameter HPMCNT22 = 12'hC16;
parameter HPMCNT23 = 12'hC17;
parameter HPMCNT24 = 12'hC18;
parameter HPMCNT25 = 12'hC19;
parameter HPMCNT26 = 12'hC1A;
parameter HPMCNT27 = 12'hC1B;
parameter HPMCNT28 = 12'hC1C;
parameter HPMCNT29 = 12'hC1D;
parameter HPMCNT30 = 12'hC1E;
parameter HPMCNT31 = 12'hC1F;

parameter VL       = 12'hC20;
parameter VTYPE    = 12'hC21;
parameter VLENB    = 12'hC22;

//==========================================================
//                  Risc-V Debug zdb Begin
//==========================================================

//---------------------------------------------
//                Trigger CSRs
//------------------------------------------
parameter SCONTEXT     = 12'h5A8; //new
parameter TSELECT      = 12'h7A0;
parameter TDATA1       = 12'h7A1;
parameter TDATA2       = 12'h7A2;
parameter TDATA3       = 12'h7A3;
parameter TINFO        = 12'h7A4;
parameter TCONTROL     = 12'h7A5;
parameter MCONTEXT     = 12'h7A8;
parameter MSCONTEXT    = 12'h7AA;

//--------------------------------------
//              Debug CSRs
//-----------------------------------------
parameter DCSR         = 12'h7B0;
parameter DPC          = 12'h7B1;
parameter DSCRATCH0    = 12'h7B2;
parameter DSCRATCH1    = 12'h7B3;

//Debug Extension
parameter MZONEID    = 12'h7F5; // Risc-V Debug zdb
parameter MHALTCAUSE = 12'hFE0; //new
parameter MDBGINFO   = 12'hFE1;
parameter MPCFIFO    = 12'hFE2;
parameter MDBGINFO2  = 12'hFE3;
//==========================================================
//                  Risc-V Debug zdb End
//==========================================================

// 4. C-SKY Extension CSRs
// Processor Control and Status Extension; M-Mode
parameter MXSTATUS  = 12'h7C0;
parameter MHCR      = 12'h7C1;
parameter MCOR      = 12'h7C2;
parameter MCCR2     = 12'h7C3;
parameter MCER2     = 12'h7C4;
parameter MHINT     = 12'h7C5;
parameter MRMR      = 12'h7C6;
parameter MRVBR     = 12'h7C7;
parameter MCER      = 12'h7C8;
parameter MCNTWEN   = 12'h7C9;
parameter MHINT2    = 12'h7CC;
parameter MHINT3    = 12'h7CD;
parameter MHINT4    = 12'h7CE;

parameter MSMPR     = 12'h7F3;
parameter MTEECFG   = 12'h7F4;
parameter MDTCMCR   = 12'h7F8;
parameter MITCMCR   = 12'h7F9;
parameter MIESR     = 12'h7FA;
parameter MSBEPA    = 12'h7FB;
parameter MSBEPA2   = 12'h7FC;

// Processor Control and Status Extension; M-Mode
parameter MCINS     = 12'h7D2;
parameter MCINDEX   = 12'h7D3;
parameter MCDATA0   = 12'h7D4;
parameter MCDATA1   = 12'h7D5;
parameter MEICR     = 12'h7D6;
parameter MEICR2    = 12'h7D7;

// Processor ID Extension; M-Mode
parameter MCPUID    = 12'hFC0;
parameter MAPBADDR  = 12'hFC1;
parameter MWMSR     = 12'hFC2;

// Processor Control and Status Extension; S-Mode
parameter SXSTATUS  = 12'h5C0;
parameter SHCR      = 12'h5C1;
parameter SCER2     = 12'h5C2;
parameter SCER      = 12'h5C3;
parameter SCNTINTEN = 12'h5C4;
parameter SCNTOF    = 12'h5C5;
parameter SHINT     = 12'h5C6;
parameter SHINT2    = 12'h5C7;
parameter SCNTIHBT  = 12'h5C8;
parameter SHPMCR    = 12'h5C9;
parameter SHPMSP    = 12'h5CA;
parameter SHPMEP    = 12'h5CB;
parameter SIESR     = 12'h5CE;
parameter SSBEPA    = 12'h5D1;
parameter SSBEPA2   = 12'h5D2;

// TLB Operation Extension; S-Mode
parameter SMIR      = 12'h9C0;
parameter SMEL      = 12'h9C1;
parameter SMEH      = 12'h9C2;
parameter SMCIR     = 12'h9C3;

// Float Point Register Extension; U-Mode
parameter FXCR      = 12'h800;

// 5. Hypervisor Extension CSRs
parameter HSTATUS   = 12'h600;
parameter HEDELEG   = 12'h602;

parameter VSSTATUS  = 12'h200;

//==========================================================
//              Generate Local Signal to CSRs
//==========================================================
assign mstatus_local_en  = iui_regs_sel && iui_regs_addr[11:0] == MSTATUS;   
assign misa_local_en     = iui_regs_sel && iui_regs_addr[11:0] == MCAUSE;
assign medeleg_local_en  = iui_regs_sel && iui_regs_addr[11:0] == MEDELEG;
assign mideleg_local_en  = iui_regs_sel && iui_regs_addr[11:0] == MIDELEG;
assign mie_local_en      = iui_regs_sel && iui_regs_addr[11:0] == MIE;       
assign mtvec_local_en    = iui_regs_sel && iui_regs_addr[11:0] == MTVEC;  
assign mcnten_local_en   = iui_regs_sel && iui_regs_addr[11:0] == MCNTEN;  

assign mscratch_local_en = iui_regs_sel && iui_regs_addr[11:0] == MSCRATCH;
assign mepc_local_en     = iui_regs_sel && iui_regs_addr[11:0] == MEPC;      
assign mcause_local_en   = iui_regs_sel && iui_regs_addr[11:0] == MCAUSE;
assign mtval_local_en    = iui_regs_sel && iui_regs_addr[11:0] == MTVAL;     
assign mip_local_en      = iui_regs_sel && iui_regs_addr[11:0] == MIP;    
assign mvien_local_en    = iui_regs_sel && iui_regs_addr[11:0] == MVIEN; //for AIA by zhangdunbo@20260605
assign mvip_local_en     = iui_regs_sel && iui_regs_addr[11:0] == MVIP;  //for AIA by zhangdunbo@20260605

assign sstatus_local_en  = iui_regs_sel && iui_regs_addr[11:0] == SSTATUS;   
assign sie_local_en      = iui_regs_sel && iui_regs_addr[11:0] == SIE;       
assign stvec_local_en    = iui_regs_sel && iui_regs_addr[11:0] == STVEC;  
assign scnten_local_en   = iui_regs_sel && iui_regs_addr[11:0] == SCNTEN;  

assign sscratch_local_en = iui_regs_sel && iui_regs_addr[11:0] == SSCRATCH;
assign sepc_local_en     = iui_regs_sel && iui_regs_addr[11:0] == SEPC;      
assign scause_local_en   = iui_regs_sel && iui_regs_addr[11:0] == SCAUSE;
assign stval_local_en    = iui_regs_sel && iui_regs_addr[11:0] == STVAL;     
assign sip_local_en      = iui_regs_sel && iui_regs_addr[11:0] == SIP;       

assign fflags_local_en   = iui_regs_sel && iui_regs_addr[11:0] == FFLAGS;       
assign frm_local_en      = iui_regs_sel && iui_regs_addr[11:0] == FRM;  
assign fcsr_local_en     = iui_regs_sel && iui_regs_addr[11:0] == FCSR;  
assign vstart_local_en   = iui_regs_sel && iui_regs_addr[11:0] == VSTART;  
assign vxsat_local_en    = iui_regs_sel && iui_regs_addr[11:0] == VXSAT;  
assign vxrm_local_en     = iui_regs_sel && iui_regs_addr[11:0] == VXRM;  
assign vcsr_local_en     = iui_regs_sel && iui_regs_addr[11:0] == VCSR;  

assign mxstatus_local_en = iui_regs_sel && iui_regs_addr[11:0] == MXSTATUS;
assign mhcr_local_en     = iui_regs_sel && iui_regs_addr[11:0] == MHCR;       
assign mcor_local_en     = iui_regs_sel && iui_regs_addr[11:0] == MCOR;     
assign mhint_local_en    = iui_regs_sel && iui_regs_addr[11:0] == MHINT;
assign mhint2_local_en   = iui_regs_sel && iui_regs_addr[11:0] == MHINT2;
assign mhint3_local_en   = iui_regs_sel && iui_regs_addr[11:0] == MHINT3;
assign mhint4_local_en   = iui_regs_addr[11:0] == MHINT4;
assign mhpmcr_local_en   = iui_regs_sel && iui_regs_addr[11:0] == MHPMCR;
assign msmpr_local_en    = iui_regs_addr[11:0] == MSMPR;  
assign mteecfg_local_en  = 1'b0;


assign mcer_local_en    = iui_regs_sel && iui_regs_addr[11:0] == MCER;
assign scer_local_en    = iui_regs_sel && iui_regs_addr[11:0] == SCER;
assign meicr_local_en   = iui_regs_sel && iui_regs_addr[11:0] == MEICR;
assign msbepa_local_en  = iui_regs_sel && iui_regs_addr[11:0] == MSBEPA;
assign ssbepa_local_en  = iui_regs_sel && iui_regs_addr[11:0] == SSBEPA;

assign mcntwen_local_en  = iui_regs_sel && iui_regs_addr[11:0] == MCNTWEN;

assign mccr2_local_en    = iui_regs_addr[11:0] == MCCR2;      
assign mcer2_local_en    = iui_regs_addr[11:0] == MCER2;     
//assign mrmr_local_en     = iui_regs_addr[11:0] == MRMR;
//assign mrvbr_local_en    = iui_regs_addr[11:0] == MRVBR;
assign mdbginfo2_local_en = iui_regs_addr[11:0] == MDBGINFO2;
assign meicr2_local_en   = iui_regs_addr[11:0] == MEICR2;
assign msbepa2_local_en  = iui_regs_addr[11:0] == MSBEPA2;

assign mcins_local_en    = iui_regs_sel && iui_regs_addr[11:0] == MCINS;       
assign mcindex_local_en  = iui_regs_sel && iui_regs_addr[11:0] == MCINDEX;     
//assign mcdata0_local_en  = iui_regs_sel && iui_regs_addr[11:0] == MCDATA0;
//assign mcdata1_local_en  = iui_regs_sel && iui_regs_addr[11:0] == MCDATA1;
assign mcpuid_local_en   = iui_regs_addr[11:0] == MCPUID;

assign sxstatus_local_en = iui_regs_sel && iui_regs_addr[11:0] == SXSTATUS;
//assign shcr_local_en     = iui_regs_sel && iui_regs_addr[11:0] == SHCR;       
assign scer2_local_en    = iui_regs_addr[11:0] == SCER2;     
assign ssbepa2_local_en  = iui_regs_addr[11:0] == SSBEPA2;

assign satp_local_en     = iui_regs_addr[11:0] == SATP;

assign fxcr_local_en     = iui_regs_sel && iui_regs_addr[11:0] == FXCR;  

assign shpmcr_local_en   = iui_regs_sel && iui_regs_addr[11:0] == SHPMCR;

//==========================================================
//                 1. Machine Level CSRs
//==========================================================

//==========================================================
//               Machine Information Registers
//==========================================================

//==========================================================
//               Define the MVENDORID Register
//==========================================================
//  Machine Vendor ID Register
//  64-bit readonly
//  Providing the JEDEC ID of C-SKY
//  *Currently not implemented
//==========================================================
assign mvendorid_value[63:0] = 64'h5B7;


//==========================================================
//               Define the MARCHID Register
//==========================================================
//  Machine Architecture ID Register
//  64-bit readonly
//  Providing the CPUID of C-SKY C960 Core
//  *Currently not implemented, need to be defined
//==========================================================
assign marchid_value[63:0] = 64'b0;


//==========================================================
//               Define the MIMPID Register
//==========================================================
//  Machine Implementation ID Register
//  64-bit readonly
//  Providing the implementation ID of the version of core
//  *Currently not implemented, need to be defined
//==========================================================
assign mimpid_value[63:0] = 64'b0;


//==========================================================
//               Define the MHARTID Register
//==========================================================
//  Machine Hart ID Register
//  64-bit readonly
//  Providing the Hart ID of the current core
//==========================================================
// assign mhartid_value[63:0] = {61'b0, biu_cp0_coreid[2:0]};
assign mhartid_value[63:0] = biu_cp0_coreid[63:0];


//==========================================================
//               Machine Trap Setup Registers
//==========================================================

//==========================================================
//               Define the MSTATUS register
//==========================================================
//  Machine Status Register
//  64-bit Machine Mode Read/Write
//  Providing the CPU Status
//  the definiton for MSTATUS register is listed as follows
//  ===============================================================
//  |63|62 40| 39|38 36|35 34|33 32|31 25|24 23| 22|21| 20| 19| 18|
//  +--+-----+---+-----+-----+-----+-----+-----+---+--+---+---+---+
//  |SD| Res |MPV| Res | SXL | UXL | Res | VS  |TSR|TM|TVM|MXR|SUM|
//  ===============================================================
//  ===================================================================
//  | 17 |16 15|14 13|12 11|10 9| 8 |  7 | 6 |  5 | 4 | 3 | 2 | 1 | 0 |
//  +----+-----+-----+-----+----+---+----+---+----+---+---+---+---+---+
//  |MPRV| Res | FS  | MPP | Res|SPP|MPIE|Res|SPIE|Res|MIE|Res|SIE|Res|
//  ===================================================================
assign sd       = vs[1:0] == 2'b11 || fs[1:0] == 2'b11 || xs[1:0] == 2'b11;

assign mpv = 1'b0;

assign sxl[1:0] = mxl[1:0];

assign uxl[1:0] = mxl[1:0];

assign vs_dirty_upd_gate = vs[1:0] == 2'b01 || vs[1:0] == 2'b10;

assign vs_dirty_upd = (vs[1:0] == 2'b01 || vs[1:0] == 2'b10)
                      && (vstart_local_en
                       || rtu_cp0_vec_dirty_vld
                       || rtu_cp0_vsetvl_vl_vld
                       || rtu_cp0_vsetvl_vtype_vld
                       || rtu_cp0_vstart_vld);

always @(posedge regs_flush_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    vs_raw[1:0] <= 2'b0;
  else if(mstatus_local_en)
    // vs_raw[1:0] <= iui_regs_src0[24:23];
    vs_raw[1:0] <= iui_regs_src0[10:9];  // add by tmj @20251117
  else if(sstatus_local_en)
    // vs_raw[1:0] <= iui_regs_src0[24:23];
    vs_raw[1:0] <= iui_regs_src0[10:9]; // add by tmj @20251117
  else if(vs_dirty_upd)
    vs_raw[1:0] <= 2'b11;
  else
    vs_raw[1:0] <= vs_raw[1:0];
end

assign vs[1:0] = vs_raw[1:0];

always @(posedge regs_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
  begin
    tsr  <= 1'b0;
    tw   <= 1'b0;
    tvm  <= 1'b0;
    mprv <= 1'b0;
  end
  else if(mstatus_local_en)
  begin
    tsr  <= iui_regs_src0[22];
    tw   <= iui_regs_src0[21];
    tvm  <= iui_regs_src0[20];
    mprv <= iui_regs_src0[17];
  end
//==========================================================
//                  Risc-V Debug zdb Begin (insert)
//==========================================================
  else if(xret_leave_m_mode)
  begin
    mprv <= 1'b0;
  end
//==========================================================
//                  Risc-V Debug zdb End   (insert)
//==========================================================
  else
  begin
    tsr  <= tsr;
    tw   <= tw;
    tvm  <= tvm;
    mprv <= mprv;
  end
end

always @(posedge regs_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
  begin
    mxr  <= 1'b0;
    sum  <= 1'b0;
  end
  else if(mstatus_local_en)
  begin
    mxr  <= iui_regs_src0[19];
    sum  <= iui_regs_src0[18];
  end
  else if(sstatus_local_en)
  begin
    mxr  <= iui_regs_src0[19];
    sum  <= iui_regs_src0[18];
  end
  else
  begin
    mxr  <= mxr;
    sum  <= sum;
  end
end

assign xs[1:0] = 2'b00;

assign fs_dirty_upd_gate = fs[1:0] == 2'b01 || fs[1:0] == 2'b10;

assign fs_dirty_upd = (fs[1:0] == 2'b01 || fs[1:0] == 2'b10)
                      && (fcsr_local_en
                       || frm_local_en
                       || fflags_local_en
                       || fxcr_local_en
                      //  || vxrm_local_en
                      //  || vxsat_local_en
                       || rtu_cp0_fp_dirty_vld);
                                           
always @(posedge regs_flush_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    fs[1:0] <= 2'b0;
  else if(mstatus_local_en)
    fs[1:0] <= iui_regs_src0[14:13];
  else if(sstatus_local_en)
    fs[1:0] <= iui_regs_src0[14:13];
  else if(fs_dirty_upd)
    fs[1:0] <= 2'b11;
  else
    fs[1:0] <= fs[1:0];
end

always @(posedge regs_flush_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    mpp[1:0] <= 2'b11;
  else if(rtu_cp0_expt_vld && !mdeleg_vld)
    mpp[1:0] <= pm[1:0];
  else if(iui_regs_inst_mret)
    mpp[1:0] <= 2'b00;
  else if(mstatus_local_en)
    mpp[1:0] <= iui_regs_src0[12:11];
  else
    mpp[1:0] <= mpp[1:0];
end


always @(posedge regs_flush_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    spp <= 1'b1;
  else if(rtu_cp0_expt_vld && mdeleg_vld)
    spp <= pm[0];
  else if(iui_regs_inst_sret)
    spp <= 1'b0;
  else if(mstatus_local_en)
    spp <= iui_regs_src0[8];
  else if(sstatus_local_en)
    spp <= iui_regs_src0[8];
  else
    spp <= spp;
end

assign sstatus_spp = spp;


// &Force("input", "rtu_cp0_int_ack"); @702
always @(posedge regs_flush_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    mpie <= 1'b0;
  else if(rtu_cp0_expt_vld && !mdeleg_vld)
    mpie <= mie_bit;
  else if(iui_regs_inst_mret)
    mpie <= 1'b1;
  else if(mstatus_local_en)
    mpie <= iui_regs_src0[7];
  else
    mpie <= mpie;
end

always @(posedge regs_flush_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    spie <= 1'b0;
  else if(rtu_cp0_expt_vld && mdeleg_vld)
    spie <= sie_bit;
  else if(iui_regs_inst_sret)
    spie <= 1'b1;
  else if(mstatus_local_en)
    spie <= iui_regs_src0[5];
  else if(sstatus_local_en)
    spie <= iui_regs_src0[5];
  else
    spie <= spie;
end

always @(posedge regs_flush_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    mie_bit <= 1'b0;
  else if(rtu_cp0_expt_vld && !mdeleg_vld)
    mie_bit <= 1'b0;
  else if(iui_regs_inst_mret)
    mie_bit <= mpie;
  else if(mstatus_local_en)
    mie_bit <= iui_regs_src0[3];
  else
    mie_bit <= mie_bit;
end

always @(posedge regs_flush_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    sie_bit <= 1'b0;
  else if(rtu_cp0_expt_vld && mdeleg_vld)
    sie_bit <= 1'b0;
  else if(iui_regs_inst_sret)
    sie_bit <= spie;
  else if(mstatus_local_en)
    sie_bit <= iui_regs_src0[1];
  else if(sstatus_local_en)
    sie_bit <= iui_regs_src0[1];
  else
    sie_bit <= sie_bit;
end


// assign mstatus_value[63:0]  = {sd, 23'b0, mpv, 3'b0, sxl[1:0], uxl[1:0], 7'b0, vs[1:0],
//                                tsr, tw, tvm, mxr, sum, mprv, 
//                                xs[1:0], fs[1:0], mpp[1:0], 2'b0, spp,
//                                mpie, 1'b0, spie, 1'b0, mie_bit, 1'b0, sie_bit, 1'b0};
assign mstatus_value[63:0]  = {sd, 23'b0, mpv, 3'b0, sxl[1:0], uxl[1:0], 7'b0, 2'b0, // add by tmj @20251117
                               tsr, tw, tvm, mxr, sum, mprv, 
                               xs[1:0], fs[1:0], mpp[1:0], vs[1:0], spp,
                               mpie, 1'b0, spie, 1'b0, mie_bit, 1'b0, sie_bit, 1'b0};

//==========================================================
//               Define the MISA register
//  Machine Status Register
//  64-bit Machine Mode Read/Write
//  Providing the ISA extension infor of the current core
//  the definiton for MISA register is listed as follows
//==========================================================
// &Force("nonport", "misa_local_en"); @830
// [63:62]     [61:26]     [25:0]
//   MXL       Reserved  Extensions
// RV64, MXL is 2.
assign mxl[1:0] = 2'b10;

//  RV64 IMAFDC (G) + S Mode + U mode + Non-Standard Ex
//  + Vector (Configurable)
// [23] [21] [20] [18] [12] [8] [7] [5] [3] [2] [0]
//  X    V    U    S    M    I   H   F   D   C   A
assign misa_vector = 1'b1;
assign misa_hypervisor = 1'b0;
assign extensions[25:0] = {2'b0, 2'b10, misa_vector, 1'b1, 4'b0100,
                                4'b0001, 4'b0001, misa_hypervisor, 3'b010, 4'b1101};
assign misa_value[63:0] = {mxl[1:0], 36'b0, extensions[25:0]};


//==========================================================
//               Define the MEDELEG register
//  Machine Exception Delegation Register
//  64-bit Machine Mode Read/Write
//  Providing the CPU Status
//  the definiton for MEDELEG register is listed as follows
//==========================================================
assign edeleg_upd_val[15:0] = {iui_regs_src0[15], 1'b0, 
                               iui_regs_src0[13:12], 2'b0,
                               iui_regs_src0[9:0]};

always @(posedge regs_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    edeleg[15:0] <= 16'b0;
  else if(medeleg_local_en)
    edeleg[15:0] <= edeleg_upd_val[15:0];
  else
    edeleg[15:0] <= edeleg[15:0];
end
assign medeleg_value[63:0] = {48'b0, edeleg[15:0]};

// decode the vector value
// &CombBeg; @890
always @( rtu_yy_xx_expt_vec[4:0])
begin
case(rtu_yy_xx_expt_vec[4:0])
  5'd1:    vec_num[18:0] = 19'h0002;
  5'd2:    vec_num[18:0] = 19'h0004;
  5'd3:    vec_num[18:0] = 19'h0008;
  5'd4:    vec_num[18:0] = 19'h0010;
  5'd5:    vec_num[18:0] = 19'h0020;
  5'd6:    vec_num[18:0] = 19'h0040;
  5'd7:    vec_num[18:0] = 19'h0080;
  5'd8:    vec_num[18:0] = 19'h0100;
  5'd9:    vec_num[18:0] = 19'h0200;
  5'd11:   vec_num[18:0] = 19'h0800;
  5'd12:   vec_num[18:0] = 19'h1000;
  5'd13:   vec_num[18:0] = 19'h2000;
  5'd15:   vec_num[18:0] = 19'h8000;
  5'd16:   vec_num[18:0] = 19'h10000;
  5'd17:   vec_num[18:0] = 19'h20000;
  5'd18:   vec_num[18:0] = 19'h40000;
  default: vec_num[18:0] = 19'h0;
endcase
// &CombEnd; @910
end

// medeleg valid when cpu in s-mode and vector hit
assign medeleg_vld = (pm[1] == 1'b0) && !rtu_yy_xx_expt_vec[5]
                 && |(vec_num[15:0] & edeleg[15:0]);


//==========================================================
//               Define the MIDELEG register
//  Machine Interrupt Delegation Register
//  64-bit Machine Mode Read/Write
//  Providing the CPU Status
//  the definiton for MIDELEG register is listed as follows
//==========================================================

always @(posedge regs_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
  begin
    seie_deleg <= 1'b0;
    stie_deleg <= 1'b0;
    ssie_deleg <= 1'b0;
  end
  else if(mideleg_local_en)
  begin
    seie_deleg <= iui_regs_src0[9];
    stie_deleg <= iui_regs_src0[5];
    ssie_deleg <= iui_regs_src0[1];
  end
  else
  begin
    seie_deleg <= seie_deleg;
    stie_deleg <= stie_deleg;
    ssie_deleg <= ssie_deleg;
  end
end

// assign mideleg_value[63:0] = {45'b0, mhie_deleg, moie_deleg, mcie_deleg,
//                                6'b0, seie_deleg, 1'b0,
//                                2'b0, stie_deleg, 1'b0,
//                                2'b0, ssie_deleg, 1'b0};

assign mideleg_value[63:0] = {mideleg[50:0],
                              1'b0,
                              2'b0, seie_deleg, 1'b0,
                              2'b0, stie_deleg, 1'b0,
                              2'b0, ssie_deleg, 1'b0};

// mideleg valid when cpu in s-mode/u-mode and vector hit
assign mideleg_vld = (pm[1] == 1'b0) && rtu_yy_xx_expt_vec[5]
                 && |(vec_num[18:0] & mideleg_value[18:0]);

assign mdeleg_vld = medeleg_vld || mideleg_vld;


//==========================================================
//               Define the MIE register
//  Machine Interrupt Enable Register
//  64-bit Machine Mode Read/Write
//  Providing the Interrupt Local Enable of the current core
//  the definiton for MIE register is listed as follows
//==========================================================

always @(posedge regs_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
  begin
    mcie <= 1'b0;
    moie <= 1'b0;
    meie <= 1'b0;
    seie <= 1'b0;
    mtie <= 1'b0;
    stie <= 1'b0;
    msie <= 1'b0;
    ssie <= 1'b0;
  end
  else if(mie_local_en)
  begin
    mcie <= iui_regs_src0[23];
    moie <= iui_regs_src0[13];
    meie <= iui_regs_src0[11];
    seie <= iui_regs_src0[9];
    mtie <= iui_regs_src0[7];
    stie <= iui_regs_src0[5];
    msie <= iui_regs_src0[3];
    ssie <= iui_regs_src0[1];
  end
  else if(sie_local_en)
  begin
    mcie <= mcip_acc_en ? iui_regs_src0[23] : mcie;
    moie <= moip_acc_en ? iui_regs_src0[13] : moie;
    meie <= meie;
    seie <= seip_acc_en ? iui_regs_src0[9] : seie;
    mtie <= mtie;
    stie <= stip_acc_en ? iui_regs_src0[5] : stie;
    msie <= msie;
    ssie <= ssip_acc_en ? iui_regs_src0[1] : ssie;
  end
  else
  begin
    mcie <= mcie;
    moie <= moie;
    meie <= meie;
    seie <= seie;
    mtie <= mtie;
    stie <= stie;
    msie <= msie;
    ssie <= ssie;
  end
end

// assign mie_value[63:0] =  {45'b0, mhie, moie, mcie, 4'b0, 
//                                   meie, 1'b0, seie, 1'b0, 
//                                   mtie, 1'b0, stie, 1'b0, 
//                                   msie, 1'b0, ssie, 1'b0}; 

assign mie_value[63:0] = {mie[50:0],
                          1'b0,
                          meie, 1'b0, seie, 1'b0,
                          mtie, 1'b0, stie, 1'b0,
                          msie, 1'b0, ssie, 1'b0};

//assign ie_bus_raw[5:0] = {meie,mtie,msie,seie,stie,ssie};
//assign ie_bus_wen = |(ie_bus_raw[5:0] ^ ie_bus[5:0]);
//
//always @(posedge forever_cpuclk or negedge cpurst_b)
//begin
//  if(!cpurst_b)
//    ie_bus[5:0] <= 6'b0;
//  else if (ie_bus_wen)
//    ie_bus[5:0] <= ie_bus_raw[5:0];
//end
//
//assign cp0_biu_ie_bus[5:0] = ie_bus[5:0];

//==========================================================
//               Define the MTVEC register
//  Machine Trap Vector Register
//  64-bit Machine Mode Read/Write
//  Providing the Trap Vector Base and Mode 
//  the definiton for MTVEC register is listed as follows
//==========================================================
always @(posedge regs_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    mtvec_mode[1:0] <= 2'b0;
  else if(mtvec_local_en)
    mtvec_mode[1:0] <= iui_regs_src0[1:0];
  else
    mtvec_mode[1:0] <= mtvec_mode[1:0];
end

always @(posedge regs_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    mtvec_base[61:0] <= 62'b0;
  else if(mtvec_local_en)
    mtvec_base[61:0] <= iui_regs_src0[63:2];
  else
    mtvec_base[61:0] <= mtvec_base[61:0];
end

assign mtvec_value[63:0] = {mtvec_base[61:0], 1'b0, mtvec_mode[0]};


//==========================================================
//               Define the MCNTEN register
//  Machine Trap Vector Register
//  64-bit Machine Mode Read/Write
//  Providing the Trap Vector Base and Mode 
//  the definiton for MTVEC register is listed as follows
//  HPM31...HPM3, IR, TM, CY
//==========================================================
always @(posedge regs_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    mcnten_reg[31:0] <= 32'b0;
  else if(mcnten_local_en)
    mcnten_reg[31:0] <= iui_regs_src0[31:0];
  else
    mcnten_reg[31:0] <= mcnten_reg[31:0];
end

assign mcnten_value[63:0] = {32'b0, mcnten_reg[31:0]};


//==========================================================
//               Define the MSCRATCH register
//  Machine Scratch Register
//  64-bit Machine Mode Read/Write
//  Providing the Software Scratch register
//  the definiton for MSCRATCH register is listed as follows
//==========================================================
always @(posedge regs_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    mscratch_value[63:0] <= 64'b0;
  else if(mscratch_local_en)
    mscratch_value[63:0] <= iui_regs_src0[63:0];
  else
    mscratch_value[63:0] <= mscratch_value[63:0];
end


//==========================================================
//               Define the MEPC register
//  Machine Exception PC Register
//  64-bit Machine Mode Read/Write
//  Providing the Machine Exception PC Register
//  the definiton for MEPC register is listed as follows
//==========================================================
// &Force("bus", "rtu_cp0_epc", 63, 0); @1306
always @(posedge regs_flush_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    mepc_reg[62:0] <= 63'b0;
  else if(rtu_cp0_expt_vld && !mdeleg_vld)
    mepc_reg[62:0] <= rtu_cp0_epc[63:1];
  else if(mepc_local_en)
    mepc_reg[62:0] <= iui_regs_src0[63:1];
  else
    mepc_reg[62:0] <= mepc_reg[62:0];
end

assign mepc_value[63:0] = {mepc_reg[62:0], 1'b0};


//==========================================================
//               Define the MCAUSE register
//  Machine CAUSE Register
//  64-bit Machine Mode Read/Write
//  Providing the Machine Trap Cause register
//  the definiton for MCAUSE register is listed as follows
//==========================================================
always @(posedge regs_flush_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    m_intr <= 1'b0;
  else if(rtu_cp0_expt_vld && !mdeleg_vld)
    m_intr <= rtu_yy_xx_expt_vec[5];
  else if(mcause_local_en)
    m_intr <= iui_regs_src0[63];
  else
    m_intr <= m_intr;
end

always @(posedge regs_flush_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    m_vector[4:0] <= 5'b0;
  else if(rtu_cp0_expt_vld && !mdeleg_vld)
    m_vector[4:0] <= rtu_yy_xx_expt_vec[4:0];
  else if(mcause_local_en)
    m_vector[4:0] <= iui_regs_src0[4:0];
  else
    m_vector[4:0] <= m_vector[4:0];
end

assign mcause_value[63:0]  = {m_intr, 58'b0, m_vector[4:0]};


//==========================================================
//               Define the MTVAL register
//  Machine Trap value Register
//  64-bit Machine Mode Read/Write
//  Providing the trap value register
//  the definiton for MTVAL register is listed as follows
//==========================================================
assign mtval_upd_data[63:0] = rtu_cp0_expt_mtval[63:0];

always @(posedge regs_flush_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    mtval_data[63:0] <= 64'b0;
  else if(rtu_cp0_expt_vld && !mdeleg_vld) 
    mtval_data[63:0] <= mtval_upd_data[63:0];
  else if(mtval_local_en)
    mtval_data[63:0] <= iui_regs_src0[63:0];
  else
    mtval_data[63:0] <= mtval_data[63:0];
end
assign mtval_value[63:0] = mtval_data[63:0];


//==========================================================
//               Define the MIP register
//  Machine Interrupt Pending Register
//  64-bit Machine Mode Read/Write
//  Providing the Interrupt Pending of the current core
//  the definiton for MIP register is listed as follows
//==========================================================
assign mcip_acc_en = mideleg_value[23];
assign moip_acc_en = mideleg_value[13];
assign seip_acc_en = mideleg_value[9];
assign stip_acc_en = mideleg_value[5];
assign ssip_acc_en = mideleg_value[1];
  
assign mcip = ecc_int_vld;
assign moip = hpcp_cp0_int_vld;
assign meip = biu_cp0_me_int;
assign mtip = biu_cp0_mt_int;
assign msip = biu_cp0_ms_int;

assign seip_s = mvseip & ~mvseien;
assign stip_s = mvstip;

assign seip = seip_s | biu_cp0_se_int;
assign stip = stip_s | biu_cp0_st_int;
assign ssip = mvssip;

// assign mip_value[63:0] =  {45'b0, mhip, moip, mcip, 4'b0,
//                                   meip, 1'b0, seip, 1'b0, 
//                                   mtip, 1'b0, stip, 1'b0, 
//                                   msip, 1'b0, ssip, 1'b0}; 

assign mip_value[63:0] = {mip[50:0],
                          1'b0,
                          meip, 1'b0, seip, 1'b0,
                          mtip, 1'b0, stip, 1'b0,
                          msip, 1'b0, ssip, 1'b0};

assign mip_raw[63:0]   = {mvip[50:0],
                          1'b0,
                          meip, 1'b0, seip_s, 1'b0,
                          mtip, 1'b0, stip_s, 1'b0,
                          msip, 1'b0, ssip,   1'b0};                          

assign mcip_en = mcie && mcip;
assign moip_en = moie && moip;
assign meip_en = meie && meip;
assign mtip_en = mtie && mtip;
assign msip_en = msie && msip;

assign seip_en = seie && seip;
assign stip_en = stie && stip;
assign ssip_en = ssie && ssip;

// For MEI, MTI, MSI: 
assign meip_vld = (pm[1:0] != 2'b11 || mie_bit) && meip_en;
assign mtip_vld = (pm[1:0] != 2'b11 || mie_bit) && mtip_en;
assign msip_vld = (pm[1:0] != 2'b11 || mie_bit) && msip_en;

// For SEI, STI, SSI: 
// M-Mode -> MIE Controlled when non-delegation;
// S-Mode -> SIE Controlled
// U-Mode -> Global always on
assign seip_nodeleg_vld = (pm[1:0] == 2'b11 && mie_bit 
                          || pm[1:0] == 2'b01
                          || pm[1:0] == 2'b00)
                        && seip_en && !mideleg_value[9];
assign stip_nodeleg_vld = (pm[1:0] == 2'b11 && mie_bit 
                          || pm[1:0] == 2'b01
                          || pm[1:0] == 2'b00)
                        && stip_en && !mideleg_value[5];
assign ssip_nodeleg_vld = (pm[1:0] == 2'b11 && mie_bit
                          || pm[1:0] == 2'b01
                          || pm[1:0] == 2'b00)
                        && ssip_en && !mideleg_value[1];
assign moip_nodeleg_vld = (pm[1:0] == 2'b11 && mie_bit 
                          || pm[1:0] == 2'b01
                          || pm[1:0] == 2'b00)
                        && moip_en && !mideleg_value[13];
assign mcip_nodeleg_vld = (pm[1:0] == 2'b11 && mie_bit 
                          || pm[1:0] == 2'b01
                          || pm[1:0] == 2'b00)
                        && mcip_en && !mideleg_value[23];

assign seip_deleg_vld = (pm[1:0] == 2'b01 && sie_bit
                        || pm[1:0] == 2'b00)
                      && seip_en && mideleg_value[9];
assign stip_deleg_vld = (pm[1:0] == 2'b01 && sie_bit
                        || pm[1:0] == 2'b00)
                      && stip_en && mideleg_value[5];
assign ssip_deleg_vld = (pm[1:0] == 2'b01 && sie_bit
                        || pm[1:0] == 2'b00)
                      && ssip_en && mideleg_value[1];
assign moip_deleg_vld = (pm[1:0] == 2'b01 && sie_bit
                        || pm[1:0] == 2'b00)
                      && moip_en && mideleg_value[13];
assign mcip_deleg_vld = (pm[1:0] == 2'b01 && sie_bit
                        || pm[1:0] == 2'b00)
                      && mcip_en && mideleg_value[23];


assign int_sel[14:0] = {mcip_nodeleg_vld,
                       1'b0,
                       meip_vld, msip_vld, mtip_vld,
                       seip_nodeleg_vld, ssip_nodeleg_vld, stip_nodeleg_vld,
                       moip_nodeleg_vld,
                       mcip_deleg_vld,
                       1'b0,
                       seip_deleg_vld, ssip_deleg_vld, stip_deleg_vld,
                       moip_deleg_vld};

assign cp0_hpcp_int_disable = ((pm[1:0] == 2'b11) && !mie_bit)
                           || ((pm[1:0] == 2'b01) && !sie_bit);

//==========================================================
// 2. Supervisor Level CSRs
//==========================================================

//==========================================================
//              Supervisor Trap Setup Registers
//==========================================================

//==========================================================
//               Define the SSTATUS register
//  Supervisor Status Register
//  64-bit Supervisor Mode Read/Write
//  Providing the CPU Status
//  the definiton for SSTATUS register is listed as follows
//==========================================================
// assign sstatus_value[63:0]  = {sd, 29'b0, uxl[1:0], 7'b0, vs[1:0], 3'b0,
//                                mxr, sum, 1'b0, xs[1:0], fs[1:0],
//                                4'b0, sstatus_spp, 2'b0, spie, 1'b0,
//                                2'b0, sie_bit, 1'b0};
assign sstatus_value[63:0]  = {sd, 29'b0, uxl[1:0], 7'b0, 2'b0, 3'b0,  // add by tmj @20251117
                               mxr, sum, 1'b0, xs[1:0], fs[1:0],
                               2'b0, vs[1:0], sstatus_spp, 2'b0, spie, 1'b0,
                               2'b0, sie_bit, 1'b0};


//==========================================================
//               Define the SIE register
//  Supervisor Interrupt Enable Register
//  64-bit Supervisor Mode Read/Write
//  Providing the Interrupt Local Enable of the current core
//  the definiton for SIE register is listed as follows
//==========================================================
// assign sie_value[63:0] =  {45'b0, mhie && mhip_acc_en,
//                             moie && moip_acc_en, mcie && mcip_acc_en,
//                             6'b0, seie && seip_acc_en, 1'b0, 
//                             2'b0, stie && stip_acc_en, 1'b0, 
//                             2'b0, ssie && ssip_acc_en, 1'b0}; 

// RISC-V Privileged
// 3.1.9 Machine Interrupt Registers (mip and mie)
// Otherwise, the corresponding bits in sip and sie are read-only zero.
assign sie_value[63:0] = {( mideleg[50:0] &  sie[50:0]) |
                          (~mideleg[50:0] & mvie[50:0]),
                          1'b0,
                          2'b0, seie_deleg ? seie : (mvseien & seie), 1'b0,
                          2'b0, stie_deleg ? stie : (mvstien & stie), 1'b0,
                          2'b0, ssie_deleg ? ssie : (mvssien & ssie), 1'b0};                            


//==========================================================
//               Define the STVEC register
//  Supervisor Trap Vector Register
//  64-bit Supervisor Mode Read/Write
//  Providing the Trap Vector Base and Mode 
//  the definiton for STVEC register is listed as follows
//==========================================================
always @(posedge regs_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    stvec_mode[1:0] <= 2'b0;
  else if(stvec_local_en)
    stvec_mode[1:0] <= iui_regs_src0[1:0];
  else
    stvec_mode[1:0] <= stvec_mode[1:0];
end

always @(posedge regs_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    stvec_base[61:0] <= 62'b0;
  else if(stvec_local_en)
    stvec_base[61:0] <= iui_regs_src0[63:2];
  else
    stvec_base[61:0] <= stvec_base[61:0];
end

assign stvec_value[63:0] = {stvec_base[61:0], 1'b0, stvec_mode[0]};


//==========================================================
//               Define the SCNTEN register
//==========================================================
//  Supervisor Trap Vector Register
//  64-bit Supervisor Mode Read/Write
//  Providing the Trap Vector Base and Mode 
//  the definiton for STVEC register is listed as follows
//  HPM31...HPM3, IR, TM, CY
//==========================================================
always @(posedge regs_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    scnten_reg[31:0] <= 32'b0;
  else if(scnten_local_en)
    scnten_reg[31:0] <= iui_regs_src0[31:0];
  else
    scnten_reg[31:0] <= scnten_reg[31:0];
end

assign scnten_value[63:0] = {32'b0, scnten_reg[31:0]};


//==========================================================
//              Supervisor Trap Handling Registers
//==========================================================

//==========================================================
//               Define the SSCRATCH register
//  Supervisor Scratch Register
//  64-bit Supervisor Mode Read/Write
//  Providing the Software Scratch register
//  the definiton for SSCRATCH register is listed as follows
//==========================================================
always @(posedge regs_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    sscratch_value[63:0] <= 64'b0;
  else if(sscratch_local_en)
    sscratch_value[63:0] <= iui_regs_src0[63:0];
  else
    sscratch_value[63:0] <= sscratch_value[63:0];
end


//==========================================================
//               Define the SEPC register
//  Supervisor Exception PC Register
//  64-bit Supervisor Mode Read/Write
//  Providing the Supervisor Exception PC Register
//  the definiton for MEPC register is listed as follows
//==========================================================
always @(posedge regs_flush_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    sepc_reg[62:0] <= 63'b0;
  else if(rtu_cp0_expt_vld && mdeleg_vld)
    sepc_reg[62:0] <= rtu_cp0_epc[63:1];
  else if(sepc_local_en)
    sepc_reg[62:0] <= iui_regs_src0[63:1];
  else
    sepc_reg[62:0] <= sepc_reg[62:0];
end

assign sepc_value[63:0] = {sepc_reg[62:0], 1'b0};


//==========================================================
//               Define the SCAUSE register
//  Supervisor CAUSE Register
//  64-bit Supervisor Mode Read/Write
//  Providing the Supervisor Trap Cause register
//  the definiton for SCAUSE register is listed as follows
//==========================================================
always @(posedge regs_flush_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    s_intr <= 1'b0;
  else if(rtu_cp0_expt_vld && mdeleg_vld)
    s_intr <= rtu_yy_xx_expt_vec[5];
  else if(scause_local_en)
    s_intr <= iui_regs_src0[63];
  else
    s_intr <= s_intr;
end

always @(posedge regs_flush_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    s_vector[4:0] <= 5'b0;
  else if(rtu_cp0_expt_vld && mdeleg_vld)
    s_vector[4:0] <= rtu_yy_xx_expt_vec[4:0];
  else if(scause_local_en)
    s_vector[4:0] <= iui_regs_src0[4:0];
  else
    s_vector[4:0] <= s_vector[4:0];
end

assign scause_value[63:0] = {s_intr, 58'b0, s_vector[4:0]};


//==========================================================
//               Define the STVAL register
//  Supervisor Trap value Register
//  64-bit Supervisor Mode Read/Write
//  Providing the trap value register
//  the definiton for STVAL register is listed as follows
//==========================================================
assign stval_upd_data[63:0] = rtu_cp0_expt_mtval[63:0];

always @(posedge regs_flush_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    stval_data[63:0] <= 64'b0;
  else if(rtu_cp0_expt_vld && mdeleg_vld) 
    stval_data[63:0] <= stval_upd_data[63:0];
  else if(stval_local_en)
    stval_data[63:0] <= iui_regs_src0[63:0];
  else
    stval_data[63:0] <= stval_data[63:0];
end

assign stval_value[63:0] = stval_data[63:0];


//==========================================================
//               Define the SIP register
//  Supervisor Interrupt Pending Register
//  64-bit Supervisor Mode Read/Write
//  Providing the Interrupt Pending of the current core
//  the definiton for SIP register is listed as follows
//==========================================================
// assign sip_value[63:0] =  {45'b0, mhip && mhip_acc_en,
//                             moip && moip_acc_en, mcip && mcip_acc_en,
//                             6'b0, seip && seip_acc_en, 1'b0, 
//                             2'b0, stip && stip_acc_en, 1'b0, 
//                             2'b0, ssip && ssip_acc_en, 1'b0}; 

assign sip_value[63:0] = {( mideleg[50:0] &   sip[50:0]) |
                          (~mideleg[50:0] & mvipn[50:0]),
                          1'b0,
                          2'b0, seie_deleg ? seip : (mvseien & mvseipn), 1'b0,
                          2'b0, stie_deleg ? stip : (mvstien & mvstipn), 1'b0,
                          2'b0, ssie_deleg ? ssip : (mvssien & mvssipn), 1'b0};

assign sip_raw[63:0]   = {( mideleg[50:0] &   sip[50:0]) |
                          (~mideleg[50:0] & mvipn[50:0]),
                          1'b0,
                          2'b0, seie_deleg ? seip_s : (mvseien & mvseipn), 1'b0,
                          2'b0, stie_deleg ? stip_s : (mvstien & mvstipn), 1'b0,
                          2'b0, ssie_deleg ? ssip   : (mvssien & mvssipn), 1'b0};
//==========================================================
//               Define the FRM register
//==========================================================
// 3. Define User Floating-Point CSRs
//==========================================================

//==========================================================
//               Define the FFLAGS register
//==========================================================
assign fflags_value[63:0] = {59'b0, fcsr_value[4:0]};

//==========================================================
//               Define the FRM register
//==========================================================
assign frm_value[63:0] = {61'b0, fcsr_value[7:5]};

//==========================================================
//               Define the FCSR register
//==========================================================
always @(posedge regs_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    fcsr_frm[2:0]      <= 3'b0;
    fcsr_nv            <= 1'b0;
    fcsr_dz            <= 1'b0;
    fcsr_of            <= 1'b0;
    fcsr_uf            <= 1'b0;
    fcsr_nx            <= 1'b0;
  end
  else if(fcsr_local_en)
  begin
    fcsr_frm[2:0]      <= iui_regs_src0[7:5];
    fcsr_nv            <= iui_regs_src0[4];
    fcsr_dz            <= iui_regs_src0[3];
    fcsr_of            <= iui_regs_src0[2];
    fcsr_uf            <= iui_regs_src0[1];
    fcsr_nx            <= iui_regs_src0[0];
  end
  else if(frm_local_en)
  begin
    fcsr_frm[2:0]      <= iui_regs_src0[2:0];
    fcsr_nv            <= fcsr_nv;
    fcsr_dz            <= fcsr_dz;
    fcsr_of            <= fcsr_of;
    fcsr_uf            <= fcsr_uf;
    fcsr_nx            <= fcsr_nx;
  end
  else if(fflags_local_en)
  begin
    fcsr_frm[2:0]      <= fcsr_frm[2:0];
    fcsr_nv            <= iui_regs_src0[4];
    fcsr_dz            <= iui_regs_src0[3];
    fcsr_of            <= iui_regs_src0[2];
    fcsr_uf            <= iui_regs_src0[1];
    fcsr_nx            <= iui_regs_src0[0];
  end
  else if(fxcr_local_en)
  begin
    fcsr_frm[2:0]      <= iui_regs_src0[26:24];
    fcsr_nv            <= iui_regs_src0[4];
    fcsr_dz            <= iui_regs_src0[3];
    fcsr_of            <= iui_regs_src0[2];
    fcsr_uf            <= iui_regs_src0[1];
    fcsr_nx            <= iui_regs_src0[0];
  end
  else if (idu_cp0_fesr_acc_updt_vld) begin
    fcsr_frm[2:0]      <= fcsr_frm[2:0];
    fcsr_nv            <= fcsr_nv || idu_cp0_fesr_acc_updt_val[4];
    fcsr_dz            <= fcsr_dz || idu_cp0_fesr_acc_updt_val[3];
    fcsr_of            <= fcsr_of || idu_cp0_fesr_acc_updt_val[2];
    fcsr_uf            <= fcsr_uf || idu_cp0_fesr_acc_updt_val[1];
    fcsr_nx            <= fcsr_nx || idu_cp0_fesr_acc_updt_val[0];
  end
  else
  begin
    fcsr_frm[2:0]      <= fcsr_frm[2:0];
    fcsr_nv            <= fcsr_nv;
    fcsr_dz            <= fcsr_dz;
    fcsr_of            <= fcsr_of;
    fcsr_uf            <= fcsr_uf;
    fcsr_nx            <= fcsr_nx;
  end
end

//==========================================================
//               Define the VCSR register
//==========================================================
always @(posedge regs_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    vcsr_raw_vxrm[1:0] <= 2'b0;
    vcsr_raw_vxsat     <= 1'b0;
  end
  else if(vcsr_local_en)
  begin
    vcsr_raw_vxrm[1:0] <= iui_regs_src0[2:1];
    vcsr_raw_vxsat     <= iui_regs_src0[0];
  end
  else if(vxrm_local_en)
  begin
    vcsr_raw_vxrm[1:0] <= iui_regs_src0[1:0];
    vcsr_raw_vxsat     <= vcsr_raw_vxsat;
  end
  else if(vxsat_local_en)
  begin
    vcsr_raw_vxrm[1:0] <= vcsr_raw_vxrm[1:0];
    vcsr_raw_vxsat     <= iui_regs_src0[0];
  end  
  else if(idu_cp0_fesr_acc_updt_vld) 
  begin
    vcsr_raw_vxrm[1:0] <= vcsr_raw_vxrm[1:0];
    vcsr_raw_vxsat     <= vcsr_raw_vxsat || idu_cp0_fesr_acc_updt_val[6];
  end
  else begin
    vcsr_raw_vxrm[1:0] <= vcsr_raw_vxrm[1:0];
    vcsr_raw_vxsat     <= vcsr_raw_vxsat;
  end
end


assign fcsr_value[63:0] = {32'b0, 21'b0, 2'b0, 1'b0, 
                           fcsr_frm[2:0], fcsr_nv, fcsr_dz, fcsr_of,
                           fcsr_uf, fcsr_nx};

assign cp0_vfpu_fcsr[63:0] = fcsr_value[63:0] | {vcsr_raw_vxrm[1:0],9'b0};

//==========================================================
//               Define the VSTART register
//==========================================================
always @(posedge vec_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    vstart_raw_vstart[`VSTART_WIDTH-1:0]   <= `VSTART_WIDTH'b0;
  else if(vstart_local_en)
    vstart_raw_vstart[`VSTART_WIDTH-1:0]   <= iui_regs_src0[`VSTART_WIDTH-1:0];
  else if (rtu_cp0_vstart_vld)
    vstart_raw_vstart[`VSTART_WIDTH-1:0]   <= rtu_cp0_vstart[`VSTART_WIDTH-1:0];
  else
    vstart_raw_vstart[`VSTART_WIDTH-1:0]   <= vstart_raw_vstart[`VSTART_WIDTH-1:0];
end

assign vstart_vstart[`VSTART_WIDTH-1:0] = vstart_raw_vstart[`VSTART_WIDTH-1:0];

assign vstart_value[63:0] = {{(64-`VSTART_WIDTH){1'b0}}, vstart_vstart[`VSTART_WIDTH-1:0]};

assign cp0_idu_vstart[`VSTART_WIDTH-1:0]  = vstart_vstart[`VSTART_WIDTH-1:0];
assign cp0_iu_vstart[`VSTART_WIDTH-1:0]   = vstart_vstart[`VSTART_WIDTH-1:0];
assign cp0_lsu_vstart[`VSTART_WIDTH-1:0]  = vstart_vstart[`VSTART_WIDTH-1:0];

//==========================================================
//               Define the VXSAT register
//==========================================================
assign vxsat_value[63:0] = {63'b0, vcsr_raw_vxsat};

//==========================================================
//               Define the VXRM register
//==========================================================
assign vxrm_value[63:0] = {62'b0, vcsr_raw_vxrm[1:0]};

//==========================================================
//               Define the VCSR register
//==========================================================
assign vcsr_value[63:0] = {61'b0, vcsr_raw_vxrm[1:0], vcsr_raw_vxsat};

//==========================================================
//                Define the VL register
//==========================================================
always @(posedge vec_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    vtype_raw_vill       <= 1'b1;
    vtype_raw_vsew[2:0]  <= 3'b0;
    vtype_raw_vlmul[2:0] <= 3'b0;
    vtype_raw_vta        <= 1'b0;
    vtype_raw_vma        <= 1'b0;
  end
  else if (rtu_cp0_vsetvl_vtype_vld)
  begin
    vtype_raw_vill       <= rtu_cp0_vsetvl_vill;
    vtype_raw_vsew[2:0]  <= rtu_cp0_vsetvl_vsew[2:0];
    vtype_raw_vlmul[2:0] <= rtu_cp0_vsetvl_vlmul[2:0]; // add by tmj @20251022
    vtype_raw_vta        <= rtu_cp0_vsetvl_vta;
    vtype_raw_vma        <= rtu_cp0_vsetvl_vma;
  end
  else
  begin
    vtype_raw_vill       <= vtype_raw_vill;
    vtype_raw_vsew[2:0]  <= vtype_raw_vsew[2:0];
    vtype_raw_vlmul[2:0] <= vtype_raw_vlmul[2:0]; // add by tmj @20251022
    vtype_raw_vta        <= vtype_raw_vta;
    vtype_raw_vma        <= vtype_raw_vma;
  end
end

assign vtype_vill       = vtype_raw_vill;
assign vtype_vsew[2:0]  = vtype_raw_vsew[2:0];
assign vtype_vlmul[2:0] = vtype_raw_vlmul[2:0];
assign vtype_vma        = vtype_raw_vma;
assign vtype_vta        = vtype_raw_vta;

assign vtype_value[63:0] = {vtype_vill, 55'b0, vtype_vma, vtype_vta, 
                            // vtype_vsew[2:0], 1'b0, vtype_vlmul[1:0]}; 
                            vtype_vsew[2:0], vtype_vlmul[2:0]}; // add by tmj @20251022

assign cp0_idu_vill       = vtype_vill;
assign cp0_iu_vill        = vtype_vill;
assign cp0_ifu_vsew[2:0]  = vtype_vsew[2:0];
assign cp0_ifu_vlmul[2:0] = vtype_vlmul[2:0];
assign cp0_ifu_vma        = vtype_vma; // add by tmj @20251127
assign cp0_ifu_vta        = vtype_vta; // add by tmj @20251127
assign cp0_iu_vsew[2:0]   = vtype_vsew[2:0]; // add by tmj @20251218
assign cp0_iu_vlmul[2:0]  = vtype_vlmul[2:0];// add by tmj @20251218

//==========================================================
//                Define the VL register
//==========================================================
always @(posedge vec_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    vl_raw_vl[`VL_WIDTH-1:0]   <= `VL_WIDTH'b0;
  else if (rtu_cp0_vsetvl_vl_vld)
    vl_raw_vl[`VL_WIDTH-1:0]   <= rtu_cp0_vsetvl_vl[`VL_WIDTH-1:0];
  else
    vl_raw_vl[`VL_WIDTH-1:0]   <= vl_raw_vl[`VL_WIDTH-1:0];
end

assign vl_vl[`VL_WIDTH-1:0] = vl_raw_vl[`VL_WIDTH-1:0];

assign vl_value[63:0] = {{(64-`VL_WIDTH){1'b0}}, vl_vl[`VL_WIDTH-1:0]};

//assign cp0_vfpu_vl[`VL_WIDTH-1:0] = vl_vl[`VL_WIDTH-1:0];
assign cp0_ifu_vl[`VL_WIDTH-1:0]  = vl_vl[`VL_WIDTH-1:0];
//assign cp0_idu_vl[`VL_WIDTH-1:0]  = vl_vl[`VL_WIDTH-1:0];
assign cp0_iu_vl[`VL_WIDTH-1:0]   = vl_vl[`VL_WIDTH-1:0];
//assign cp0_lsu_vl[`VL_WIDTH-1:0]  = vl_vl[`VL_WIDTH-1:0];

//==========================================================
//               Define the VLENB register
// ==========================================================
// assign vlenb_value[63:0] = 64'd16; //VLEN 128 bit
assign vlenb_value[63:0] = 64'(`VECTOR_VLEN >> 3); //VLEN 128 bit

//==========================================================
// 4. C-SKY Extension CSRs
//==========================================================

//==========================================================
//               Define the MXSTATUS register
//  Machine Extension Status register
//  64-bit Machine Mode Read/Write
//  Providing the C-SKY Extension Status of the current core
//  the definiton for MXSTATUS register is listed as follows
//==========================================================
// assign pm_wen = rtu_cp0_expt_vld
//                 || iui_regs_inst_mret
//                 || iui_regs_inst_sret;
//==========================================================
//                  Risc-V Debug zdb Begin (replace)
//==========================================================
assign pm_wen = rtu_yy_xx_expt_vld
                | iui_regs_inst_mret
                | iui_regs_inst_sret
                | rtu_cp0_enter_debug
                | rtu_cp0_exit_debug;
//==========================================================
//                  Risc-V Debug zdb End   (replace)
//==========================================================
// &CombBeg; @1991
// always @( rtu_cp0_expt_vld
//        or pm[1:0]
//        or sstatus_spp
//        or mpp[1:0]
//        or iui_regs_inst_sret
//        or mdeleg_vld
//        or iui_regs_inst_mret)
// begin
//   if(rtu_cp0_expt_vld && !mdeleg_vld)
//     pm_wdata[1:0] = 2'b11;
//   else if(rtu_cp0_expt_vld && mdeleg_vld)
//     pm_wdata[1:0] = 2'b01;
//   else if(iui_regs_inst_mret)
//     pm_wdata[1:0] = mpp[1:0];
//   else if(iui_regs_inst_sret)
//     pm_wdata[1:0] = {1'b0, sstatus_spp};
//   else
//     pm_wdata[1:0] = pm[1:0];
// // &CombEnd; @2002
// end
//==========================================================
//                  Risc-V Debug zdb Begin (replace)
//==========================================================
always @*
begin
  if(rtu_cp0_exit_debug)
    pm_wdata[1:0] = dtu_yy_dcsr_prv[1:0];
  else if(rtu_cp0_enter_debug)
    pm_wdata[1:0] = rtu_cp0_dbg_pm;
  else if(iui_regs_inst_mret)
    pm_wdata[1:0] = mpp[1:0];
  else if(iui_regs_inst_sret)
    pm_wdata[1:0] = {1'b0, spp};
  else if(~mdeleg_vld)
    pm_wdata[1:0] = 2'b11;
  else if(mdeleg_vld)
    pm_wdata[1:0] = 2'b01;
  else
    pm_wdata[1:0] = pm[1:0];
// &CombEnd; @1502
end
//==========================================================
//                  Risc-V Debug zdb End   (replace)
//==========================================================

always @(posedge regs_flush_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    pm[1:0] <= 2'b11;
  else if(pm_wen)
    pm[1:0] <= pm_wdata[1:0];
  else 
    pm[1:0] <= pm[1:0];
end

always @(posedge regs_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    mm    <= 1'b1;
    pmds  <= 1'b0;
    pmdu  <= 1'b0;
  end
  else if(mxstatus_local_en)
  begin
    mm    <= iui_regs_src0[15];
    pmds  <= iui_regs_src0[11];
    pmdu  <= iui_regs_src0[10];
  end
  else if(sxstatus_local_en)
  begin
    mm    <= iui_regs_src0[15];
    pmds  <= iui_regs_src0[11];
    pmdu  <= iui_regs_src0[10];
  end
  else if(mhpmcr_local_en)
  begin
    mm    <= mm;
    pmds  <= iui_regs_src0[11];
    pmdu  <= iui_regs_src0[10];
  end
  else if(shpmcr_local_en)
  begin
    mm    <= mm;
    pmds  <= iui_regs_src0[11];
    pmdu  <= iui_regs_src0[10];
  end
  else
  begin
    mm    <= mm;
    pmds  <= pmds;
    pmdu  <= pmdu;
  end
end
assign fccee = 1'b0;

always @(posedge regs_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    cskyisaee <= 1'b1;
    maee      <= 1'b1;
    insde     <= 1'b0;
    mhrd      <= 1'b0;
    clintee   <= 1'b1;
    ucme      <= 1'b0;
    pmdm      <= 1'b0;
  end
  else if(mxstatus_local_en)
  begin
    cskyisaee <= iui_regs_src0[22];
    maee      <= iui_regs_src0[21];
    insde     <= iui_regs_src0[19];
    mhrd      <= iui_regs_src0[18];
    clintee   <= iui_regs_src0[17];
    ucme      <= iui_regs_src0[16];
    pmdm      <= iui_regs_src0[13];
  end
  else if(mhpmcr_local_en)
  begin
    cskyisaee <= cskyisaee;
    maee      <= maee;
    insde     <= insde;
    mhrd      <= mhrd;
    clintee   <= clintee;
    ucme      <= ucme;
    pmdm      <= iui_regs_src0[13];
  end
  else
  begin
    cskyisaee <= cskyisaee;
    maee      <= maee;
    insde     <= insde;
    mhrd      <= mhrd;
    clintee   <= clintee;
    ucme      <= ucme;
    pmdm      <= pmdm;
  end
end


assign ve = 1'b0;
assign v  = 1'b0;

assign mxstatus_value[63:0]  = {32'b0, pm[1:0], 7'b0, cskyisaee, maee,
                                fccee, insde, mhrd, clintee, ucme, mm,
                                1'b0, pmdm, 1'b0, pmds, pmdu, v, ve, 
                                8'b0};

//==========================================================
//               Define the MHCR register
//  Machine Hardware Config register
//  64-bit Machine Mode Read/Write
//  Providing the C-SKY Hardware Config of the current core
//  the definiton for MHCR register is listed as follows
//==========================================================
assign sck[2:0] = 3'b0;//biu_cp0_clkratio[2:0];

assign wbr = 1'b1;

always @(posedge regs_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    ibpe <= 1'b0;
  else if(mhcr_local_en)
    ibpe <= iui_regs_src0[7];
  else
    ibpe <= ibpe;
end

always @(posedge regs_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
  begin
    l0btbe <= 1'b0;
    btbe   <= 1'b0;
  end
  else if(mhcr_local_en)
  begin
    l0btbe <= iui_regs_src0[12];
    btbe   <= iui_regs_src0[6];
  end
  else
  begin
    l0btbe <= l0btbe;
    btbe   <= btbe;
  end
end

assign wb = 1'b1;

always @(posedge regs_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
  begin
    bpe <= 1'b0;
    rse <= 1'b0;
    wa  <= 1'b0;
    de  <= 1'b0;
    ie  <= 1'b0;
  end
  else if(mhcr_local_en)
  begin
    bpe <= iui_regs_src0[5];
    rse <= iui_regs_src0[4];
    wa  <= iui_regs_src0[2];
    de  <= iui_regs_src0[1];
    ie  <= iui_regs_src0[0];
  end
  else
  begin
    bpe <= bpe;
    rse <= rse;
    wa  <= wa;
    de  <= de;
    ie  <= ie;
  end
end

assign mhcr_value[63:0] = {45'b0, sck[2:0], 3'b0, l0btbe, 3'b0, wbr, ibpe,
                           btbe, bpe, rse, wb, wa, de, ie};

//==========================================================
//               Define the MCOR register
//  Machine Cache Operation register
//  64-bit Machine Mode Read/Write
//  Providing the C-SKY Cache Operation Interface
//  the definiton for MCOR register is listed as follows
//==========================================================
always @(posedge regs_flush_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
      ibp_inv <= 1'b0;
  else if(rtu_yy_xx_flush)
      ibp_inv <= 1'b0;
  else if(mcor_local_en) 
      ibp_inv <= iui_regs_src0[18];
  else if(ifu_cp0_ind_btb_inv_done)
      ibp_inv <= 1'b0;
  else
      ibp_inv <= ibp_inv;
end

always @(posedge regs_flush_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    btb_inv <= 1'b0;
  else if(rtu_yy_xx_flush)
    btb_inv <= 1'b0;
  else if(mcor_local_en) 
    btb_inv <= iui_regs_src0[17];
  else if(ifu_cp0_btb_inv_done)
    btb_inv <= 1'b0;
  else
    btb_inv <= btb_inv;
end

always @(posedge regs_flush_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    bht_inv <= 1'b0;
  else if(rtu_yy_xx_flush)
    bht_inv <= 1'b0;
  else if(mcor_local_en) 
    bht_inv <= iui_regs_src0[16];
  else if(ifu_cp0_bht_inv_done)
    bht_inv <= 1'b0;
  else
    bht_inv <= bht_inv;
end

//if sel dcache bit is set, wait lsu dcache done
//else always done
assign clr_done = !sel[1] || lsu_cp0_dcache_done;

always @(posedge regs_flush_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
   clr <= 1'b0;
  else if(rtu_yy_xx_flush)
   clr <= 1'b0;
  else if(mcor_local_en) 
   clr <= iui_regs_src0[5];
  else if(clr && clr_done)
   clr <= 1'b0;
  else
   clr <= clr;
end

// 1.when inv and clr complete, clear the inv and clr bit.
// 2.mtcr cfr will update inv and clr bit
always @(posedge regs_flush_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
      icache_inv <= 1'b0;
  else if(rtu_yy_xx_flush)
      icache_inv <= 1'b0;
  else if(mcor_local_en) 
      icache_inv <= iui_regs_src0[4];
  else if(icache_inv && (ifu_cp0_icache_inv_done || !sel[0]))
      icache_inv <= 1'b0;
  else
      icache_inv <= icache_inv;
end

always @(posedge regs_flush_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
      dcache_inv <= 1'b0;
  else if(rtu_yy_xx_flush)
      dcache_inv <= 1'b0;
  else if(mcor_local_en) 
      dcache_inv <= iui_regs_src0[4];
  else if(dcache_inv && (lsu_cp0_dcache_done || !sel[1]))
      dcache_inv <= 1'b0;
  else
      dcache_inv <= dcache_inv;
end

assign inv = icache_inv || dcache_inv;

always @(posedge regs_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    sel[1:0] <= 2'b0;
  else if(mcor_local_en) 
    sel[1:0] <= iui_regs_src0[1:0];
  else
    sel[1:0] <= sel[1:0];
end

assign mcor_value[63:0] = {45'b0, ibp_inv, btb_inv, bht_inv, 10'b0,
                           clr, inv, 2'b0, sel[1:0]};
assign cfr_bits_done = ifu_cp0_ind_btb_inv_done || ifu_cp0_btb_inv_done
                    || ifu_cp0_bht_inv_done || clr && clr_done
                    || icache_inv && (ifu_cp0_icache_inv_done || !sel[0])
                    || dcache_inv && (lsu_cp0_dcache_done || !sel[1]);

//==========================================================
//               Define the MHINT register
//  Machine Hint register
//  64-bit Machine Mode Read/Write
//  Providing the hint register
//  the definiton for MHINT register is listed as follows
//  BIU burst enable
//  LSU read weak order enable
//  PLB preload enable
//==========================================================
always @(posedge regs_clk or negedge cpurst_b)
begin
  if(!cpurst_b) begin
    ecc_en <= 1'b0;
  end
  else if(mhint_local_en) begin
    ecc_en <= iui_regs_src0[19];
  end
  else begin
    ecc_en <= ecc_en; 
  end
end

always @(posedge regs_clk or negedge cpurst_b)
begin
  if(!cpurst_b) begin
    lsu_ld_stride_cm_hw_pref_en <= 1'b0;
    lsu_va_based_hw_pref_en     <= 1'b0;
    pf_aggr_range               <= 4'b0;
    region_pf_dynamic           <= 1'b0;
    region_pf_conservative      <= 1'b0;
    region_pf_very_conservative <= 1'b0;
    region_pf_most_conservative <= 1'b0;
    corr_dis              <= 1'b1;
    fencei_broad_dis      <= 1'b0;
    fencerw_broad_dis     <= 1'b0;
    tlb_broad_dis         <= 1'b0;
    l2stpld               <= 1'b0;
    nsfe                  <= 1'b0;
    l2_pref_dist[1:0]     <= 2'b00;
    l2pld                 <= 1'b0;
    dcache_pref_dist[1:0] <= 2'b00;
    sre                   <= 1'b0;
    iwpe                  <= 1'b0;
    lpe                   <= 1'b0;
    icache_pref_en        <= 1'b0;
    amr2                  <= 1'b0;
    amr                   <= 1'b0;
    dcache_pref_en        <= 1'b0;
    pcfifo_frz            <= 1'b0;  // Risc-V Debug zdb insert
  end
  else if(mhint_local_en) begin
    region_pf_most_conservative <= iui_regs_src0[35];
    region_pf_very_conservative <= iui_regs_src0[34];
    region_pf_conservative      <= iui_regs_src0[33];
    region_pf_dynamic           <= iui_regs_src0[32];
    pf_aggr_range               <= iui_regs_src0[31:28];
    lsu_va_based_hw_pref_en     <= iui_regs_src0[27];
    pcfifo_frz            <= iui_regs_src0[26]; // Risc-V Debug zdb insert
    lsu_ld_stride_cm_hw_pref_en <= iui_regs_src0[25];
    corr_dis              <= iui_regs_src0[24];
    fencei_broad_dis      <= iui_regs_src0[23];
    fencerw_broad_dis     <= iui_regs_src0[22];
    tlb_broad_dis         <= iui_regs_src0[21];
    l2stpld               <= iui_regs_src0[20];
    nsfe                  <= iui_regs_src0[18];
    l2_pref_dist[1:0]     <= iui_regs_src0[17:16]; 
    l2pld                 <= iui_regs_src0[15];
    dcache_pref_dist[1:0] <= iui_regs_src0[14:13];
    sre                   <= iui_regs_src0[11];
    iwpe                  <= iui_regs_src0[10];
    lpe                   <= iui_regs_src0[9];
    icache_pref_en        <= iui_regs_src0[8];
    amr2                  <= iui_regs_src0[5];
    amr                   <= iui_regs_src0[3];
    dcache_pref_en        <= iui_regs_src0[2];
  end
  else begin
    lsu_ld_stride_cm_hw_pref_en <= lsu_ld_stride_cm_hw_pref_en;
    lsu_va_based_hw_pref_en     <= lsu_va_based_hw_pref_en    ;
    pf_aggr_range               <= pf_aggr_range              ;
    region_pf_dynamic           <= region_pf_dynamic          ;
    region_pf_conservative      <= region_pf_conservative     ;
    region_pf_very_conservative <= region_pf_very_conservative;
    region_pf_most_conservative <= region_pf_most_conservative;
    corr_dis              <= corr_dis;
    fencei_broad_dis      <= fencei_broad_dis;
    fencerw_broad_dis     <= fencerw_broad_dis;
    tlb_broad_dis         <= tlb_broad_dis;
    l2stpld               <= l2stpld;
    nsfe                  <= nsfe;
    l2_pref_dist[1:0]     <= l2_pref_dist[1:0];
    l2pld                 <= l2pld;
    dcache_pref_dist[1:0] <= dcache_pref_dist[1:0];
    sre                   <= sre;
    iwpe                  <= iwpe;
    lpe                   <= lpe;
    icache_pref_en        <= icache_pref_en;
    amr2                  <= amr2;
    amr                   <= amr;
    dcache_pref_en        <= dcache_pref_en;
    pcfifo_frz            <= pcfifo_frz;  // Risc-V Debug zdb insert
  end
end

// assign mhint_value[63:0] = {28'b0, region_pf_most_conservative, region_pf_very_conservative,
//                             region_pf_conservative, region_pf_dynamic, pf_aggr_range[3:0],
//                             lsu_va_based_hw_pref_en,1'b0, lsu_ld_stride_cm_hw_pref_en,
//                             corr_dis, fencei_broad_dis, fencerw_broad_dis,
//                             tlb_broad_dis, l2stpld, ecc_en,
//                             nsfe, l2_pref_dist[1:0], l2pld, 
//                             dcache_pref_dist[1:0], 1'b0, sre,
//                             iwpe, lpe, icache_pref_en, 2'b0, amr2,
//                             1'b0, amr, dcache_pref_en, 2'b0};
//==========================================================
//                  Risc-V Debug zdb Begin (replace)
//==========================================================
assign mhint_value[63:0] = {28'b0, region_pf_most_conservative, region_pf_very_conservative,
                            region_pf_conservative, region_pf_dynamic, pf_aggr_range[3:0],
                            lsu_va_based_hw_pref_en,pcfifo_frz, lsu_ld_stride_cm_hw_pref_en,
                            corr_dis, fencei_broad_dis, fencerw_broad_dis,
                            tlb_broad_dis, l2stpld, ecc_en,
                            nsfe, l2_pref_dist[1:0], l2pld, 
                            dcache_pref_dist[1:0], 1'b0, sre,
                            iwpe, lpe, icache_pref_en, 2'b0, amr2,
                            1'b0, amr, dcache_pref_en, 2'b0};
//==========================================================
//                  Risc-V Debug zdb End   (replace)
//==========================================================

//==========================================================
//               Define the MRVBR register
//  Machine Reset VBR register
//  64-bit Machine Mode Read Only
//  Providing the RVBR register
//==========================================================
// &Force("bus", "biu_cp0_rvba", 39, 0); @2502
always @(posedge forever_cpuclk or negedge cpurst_b)
begin
  if(!cpurst_b)
    rst_sample <= 1'b0;
  else if(ifu_cp0_rst_inv_req)
    rst_sample <= 1'b1;
  else
    rst_sample <= 1'b0;
end
always @(posedge regs_flush_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    mrvbr_reg[`WK_PC_WIDTH-2:0] <= {`WK_PC_WIDTH-1{1'b0}}; 
  else if(rst_sample)
    mrvbr_reg[`WK_PC_WIDTH-2:0] <= biu_cp0_rvba[`WK_PC_WIDTH-1:1];
  else
    mrvbr_reg[`WK_PC_WIDTH-2:0] <= mrvbr_reg[`WK_PC_WIDTH-2:0];
end

assign mrvbr_value[63:0] = {15'b0, mrvbr_reg[`WK_PC_WIDTH-2:0], 1'b0};

//==========================================================
//               Define the MHINT2 register
//  Machine Hint 2 register
//  64-bit Machine Mode Read/Write
//  Providing the hint2 register
//  the definiton for MHINT2 register is listed as follows
//==========================================================
always @(posedge regs_clk or negedge cpurst_b)
begin
  if(!cpurst_b) begin
    dtu_local_icg_en    <= 1'b0; // Risc-V Debug zdb insert
    strong_atomic <= 1'b0;
    vsetvli_pred  <= 1'b0;
    ctc_flush_dis <= 1'b0;
    par_dis[3:0]  <= 4'b0;
    pfu_mmu_dis   <= 1'b0;
    vsetvli_dis   <= 1'b0;
    local_icg_en[8:0] <= 9'b0;
    da_fwd_dis    <= 1'b0;
    src2_fwd_dis  <= 1'b0;
    div_entry_dis <= 1'b0;
    cb_aclr_dis   <= 1'b0;
    wr_burst_dis  <= 1'b0;
    delay_mnt_max[1:0]  <= 2'b0;
    delay_mnt_force     <= 1'b0;
    delay_mnt_dis       <= 1'b0;
    zero_move_dis <= 1'b0;
    dlb_dis       <= 1'b0;
    rob_fold_dis  <= 1'b0;
    iq_bypass_dis <= 1'b0;
    srcv2_fwd_dis <= 1'b0;
  end
  else if(mhint2_local_en) begin
    dtu_local_icg_en    <= iui_regs_src0[43]; // Risc-V Debug zdb insert
    strong_atomic <= iui_regs_src0[42];
    vsetvli_pred  <= iui_regs_src0[33];
    ctc_flush_dis <= iui_regs_src0[32];
    par_dis[3:0]  <= iui_regs_src0[31:28];
    pfu_mmu_dis   <= iui_regs_src0[27];
    vsetvli_dis   <= iui_regs_src0[26];
    local_icg_en[8:0] <= iui_regs_src0[22:14];
    da_fwd_dis    <= iui_regs_src0[13];
    src2_fwd_dis  <= iui_regs_src0[12];
    div_entry_dis <= iui_regs_src0[11];
    cb_aclr_dis   <= iui_regs_src0[10];
    wr_burst_dis  <= iui_regs_src0[9];
    delay_mnt_max[1:0]  <= iui_regs_src0[8:7];
    delay_mnt_force     <= iui_regs_src0[6];
    delay_mnt_dis       <= iui_regs_src0[5];
    zero_move_dis <= iui_regs_src0[4];
    dlb_dis       <= iui_regs_src0[3];
    rob_fold_dis  <= iui_regs_src0[2];
    iq_bypass_dis <= iui_regs_src0[1];
    srcv2_fwd_dis <= iui_regs_src0[0];
  end
  else begin
    dtu_local_icg_en <= dtu_local_icg_en; // Risc-V Debug zdb insert
    strong_atomic <= strong_atomic;
    vsetvli_pred  <= vsetvli_pred;
    ctc_flush_dis <= ctc_flush_dis;
    par_dis[3:0]  <= par_dis[3:0];
    pfu_mmu_dis   <= pfu_mmu_dis;
    vsetvli_dis   <= vsetvli_dis;
    local_icg_en[8:0] <= local_icg_en[8:0];
    da_fwd_dis    <= da_fwd_dis;
    src2_fwd_dis  <= src2_fwd_dis;
    div_entry_dis <= div_entry_dis;
    cb_aclr_dis   <= cb_aclr_dis;
    wr_burst_dis  <= wr_burst_dis;
    delay_mnt_max[1:0]  <= delay_mnt_max[1:0];
    delay_mnt_force     <= delay_mnt_force;
    delay_mnt_dis       <= delay_mnt_dis;
    zero_move_dis <= zero_move_dis;
    dlb_dis       <= dlb_dis;
    rob_fold_dis  <= rob_fold_dis;
    iq_bypass_dis <= iq_bypass_dis;
    srcv2_fwd_dis <= srcv2_fwd_dis;
  end
end

assign xtcm_1bit_wb_dis = 1'b0;
assign pa_equal_va = 1'b0;
assign dtcm_icg_en = 1'b0;
assign itcm_icg_en = 1'b0;
assign light_fence_en = 1'b0;

// assign mhint2_value[63:0] = {21'b0,strong_atomic,5'b0,
//                             light_fence_en,pa_equal_va,xtcm_1bit_wb_dis,vsetvli_pred,ctc_flush_dis,
//                             par_dis[3:0], pfu_mmu_dis, vsetvli_dis, 1'b0, itcm_icg_en, dtcm_icg_en,
//                             local_icg_en[8:0], da_fwd_dis, src2_fwd_dis, div_entry_dis, cb_aclr_dis,
//                             wr_burst_dis,delay_mnt_max[1:0],delay_mnt_force,delay_mnt_dis,zero_move_dis, 
//                             dlb_dis, rob_fold_dis, iq_bypass_dis, srcv2_fwd_dis};
//==========================================================
//                  Risc-V Debug zdb Begin (replace)
//==========================================================
assign mhint2_value[63:0] = { 20'b0,                                  // 63-44
                              dtu_local_icg_en,                       // 43
                              strong_atomic,                          // 42
                              5'b0,                                   // 41-37
                              light_fence_en,                         // 36
                              pa_equal_va,                            // 35
                              xtcm_1bit_wb_dis,                       // 34
                              vsetvli_pred,                           // 33
                              ctc_flush_dis,                          // 32
                              par_dis[3:0],                           // 31-28
                              pfu_mmu_dis,                            // 27
                              vsetvli_dis,                            // 26
                              1'b0,                                   // 25
                              itcm_icg_en,                            // 24
                              dtcm_icg_en,                            // 23
                              local_icg_en[8:0],                      // 22-14
                              da_fwd_dis,                             // 13
                              src2_fwd_dis,                           // 12
                              div_entry_dis,                          // 11
                              cb_aclr_dis,                            // 10
                              wr_burst_dis,                           // 9
                              delay_mnt_max[1:0],                     // 8-7
                              delay_mnt_force,                        // 6
                              delay_mnt_dis,                          // 5
                              zero_move_dis,                          // 4
                              dlb_dis,                                // 3
                              rob_fold_dis,                           // 2
                              iq_bypass_dis,                          // 1
                              srcv2_fwd_dis                           // 0
                            };
//==========================================================
//                  Risc-V Debug zdb Begin (replace)
//==========================================================

//==========================================================
//               Define the MHINT3 register
//  Machine Hint 3 register
//  64-bit Machine Mode Read/Write
//  Providing the hint3 register
//  the definiton for MHINT3 register is listed as follows
//==========================================================
//rst value
//timeout_cnt = 64,no_req_cnt = 16
always @(posedge regs_clk or negedge cpurst_b)
begin
  if(!cpurst_b) begin
    timeout_cnt[29:0] <= 30'h10404040; 
  end
  else if(mhint3_local_en) begin
    timeout_cnt[29:0] <= iui_regs_src0[29:0];
  end
  else begin
    timeout_cnt[29:0] <= timeout_cnt[29:0];
  end
end

assign mhint3_value[63:0] = {32'b0, 2'b0, timeout_cnt[29:0]};

//==========================================================
//               Define the MCNTWEN register
//  Machine Counter Write Enable Register
//  64-bit Machine Mode Read/Write
//  Providing the Write Enable info for S-Mode Interface to
//  Mode Counters
//  the definiton for MCNTWEN register is listed as follows
//  HPM31...HPM3, IR, TM, CY
//==========================================================
always @(posedge regs_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    mcntwen_reg[31:0] <= 32'b0;
  else if(mcntwen_local_en)
    mcntwen_reg[31:0] <= {iui_regs_src0[31:2], 1'b0, iui_regs_src0[0]};
  else
    mcntwen_reg[31:0] <= mcntwen_reg[31:0];
end

assign mcntwen_value[63:0] = {32'b0, mcntwen_reg[31:0]};

assign mteecfg_value[63:0]   = 64'b0;
assign tee_lock              = 1'b0;
assign tee_ff                = 1'b0;

assign regs_iui_tee_vld      = 1'b1;
assign regs_iui_chk_vld      = 1'b0;
assign regs_iui_tee_ff       = 1'b1;


assign cp0_idu_light_fence_en = light_fence_en;

assign mdtcmcr_value[63:0] = 64'b0;

assign mitcmcr_value[63:0] = 64'b0;

//==========================================================
//               Define the MIESR register
//  Machine Instruction Error Status Register
//  64-bit Machine mode Read/Write
//  Providing the Machine Instruction Error Exception status
//  the definition for MIESR register is listed as follows
//==========================================================
// &Force("input","rtu_yy_xx_expt_ecc"); @2880

assign miesr_value[63:0] = 64'b0;

//==========================================================
//               Define the SIESR register
//  Supervisor Instruction Error Status Register
//  64-bit Supervisor mode Read/Write
//  Providing the Supervisor Instruction Error Exception status
//  the definition for SIESR register is listed as follows
//==========================================================
assign siesr_value[63:0] = 64'b0;

//==========================================================
//               Define the MSBEPA register
//  Machine single bit ecc error physical address Register
//  64-bit Machine mode Read/Write
//  Providing the Machine physical address of SBE 
//  the definition for MSBEPA register is listed as follows
//==========================================================
always @(posedge ecc_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    sbepa[`WK_PA_WIDTH-1:0] <= {`WK_PA_WIDTH{1'b0}};
  else if (cp0_ecc_vld && !err_fatal && !dcache_ecc_vld)
    sbepa[`WK_PA_WIDTH-1:0] <= cp0_ecc_pa[`WK_PA_WIDTH-1:0];
  else if (msbepa_local_en || ssbepa_local_en)
    sbepa[`WK_PA_WIDTH-1:0] <= iui_regs_src0[`WK_PA_WIDTH-1:0];
end
    
assign msbepa_value[63:0] = {{64-`WK_PA_WIDTH{1'b0}},sbepa[`WK_PA_WIDTH-1:0]};

//==========================================================
//               Define the MCER register
//  Machine Cache Error Register
//  64-bit Machine Mode Read/Write
//  Providing the Cache Error Information
//  the definiton for MCER register is listed as follows
//==========================================================
// &Instance("gated_clk_cell", "x_ecc_gated_clk"); @2956
gated_clk_cell  x_ecc_gated_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (ecc_clk           ),
  .external_en        (1'b0              ),
  .local_en           (ecc_clk_en        ),
  .module_en          (regs_xx_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect(.clk_in      (forever_cpuclk), @2957
//          .external_en (1'b0), @2958
//          .module_en   (regs_xx_icg_en), @2959
//          .local_en    (ecc_clk_en), @2960
//          .clk_out     (ecc_clk)); @2961
assign ecc_clk_en  = mcer_local_en || scer_local_en || cp0_ecc_vld 
                  || meicr_local_en || inj_en
                  || msbepa_local_en || ssbepa_local_en;

assign lsu_sel = lsu_cp0_ecc_vld & (lsu_cp0_ecc_fatal | !(ifu_cp0_ecc_vld & ifu_cp0_ecc_fatal));
assign ifu_sel = ifu_cp0_ecc_vld;

assign cp0_ecc_vld   = ifu_cp0_ecc_vld || lsu_cp0_ecc_vld || mmu_cp0_ecc_vld;
assign cp0_ecc_fatal = lsu_sel ? lsu_cp0_ecc_fatal
                     : ifu_sel ? ifu_cp0_ecc_fatal
                               : 1'b0;
assign cp0_ecc_ramid[2:0] = lsu_sel ? lsu_cp0_ecc_ramid[2:0]
                          : ifu_sel ? ifu_cp0_ecc_ramid[2:0]
                                    : mmu_cp0_ecc_ramid[2:0];
assign cp0_ecc_way[1:0]   = lsu_sel ? lsu_cp0_ecc_way[1:0]
                          : ifu_sel ? ifu_cp0_ecc_way[1:0]
                                    : mmu_cp0_ecc_way[1:0];
assign cp0_ecc_idx[16:0]  = lsu_sel ? lsu_cp0_ecc_idx[16:0]
                          : ifu_sel ? ifu_cp0_ecc_idx[16:0]
                                    : {8'b0, mmu_cp0_ecc_idx[8:0]};
assign cp0_ecc_pa[`WK_PA_WIDTH-1:0]   = {`WK_PA_WIDTH{lsu_sel}} & lsu_cp0_ecc_sbepa[`WK_PA_WIDTH-1:0];

assign ecc_err_clr = (mcer_local_en || scer_local_en) && !iui_regs_src0[31];

always @(posedge ecc_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    ecc_vld <= 1'b0;
  else if (cp0_ecc_vld)
    ecc_vld <= 1'b1;
  else if (ecc_err_clr)
    ecc_vld <= 1'b0;
end

assign dcache_ecc_vld = 1'b0;

always @(posedge ecc_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    err_fatal <= 1'b0;
  else if (cp0_ecc_vld && cp0_ecc_fatal && !dcache_ecc_vld)
    err_fatal <= 1'b1;
  else if (ecc_err_clr)
    err_fatal <= 1'b0;
end

always @(posedge ecc_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    fix_cnt[5:0] <= 6'b0;
  else if (ecc_err_clr)
    fix_cnt[5:0] <= cp0_ecc_vld && !cp0_ecc_fatal ? 6'b1 : 6'b0;
  else if (cp0_ecc_vld && !cp0_ecc_fatal && !(fix_cnt[5:0]==6'b111111))
    fix_cnt[5:0] <= fix_cnt[5:0] + 6'b1;
end

always @(posedge ecc_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
  begin
    ramid[2:0]      <= 3'b0;
    err_way[1:0]    <= 2'b0;
    err_index[16:0] <= 17'b0;
  end
  else if (cp0_ecc_vld && !err_fatal && !dcache_ecc_vld)
  begin
    ramid[2:0]      <= cp0_ecc_ramid[2:0];
    err_way[1:0]    <= cp0_ecc_way[1:0];
    err_index[16:0] <= cp0_ecc_idx[16:0];
  end
end

assign mcer_value[63:0] = {32'b0, ecc_vld, err_fatal, fix_cnt[5:0],
                           ramid[2:0], 2'b0, err_way[1:0], err_index[16:0]};
assign ecc_int_vld = ecc_vld && (dcache_ecc_vld || err_fatal);


//==========================================================
//               Define the MEICR register
//  Machine Error Injection Control Register
//  64-bit Machine Mode Read/Write
//  Providing the Cache Error Injection function
//  the definiton for MEICR register is listed as follows
//==========================================================
always @(posedge ecc_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    inj_en     <= 1'b0;
  else if(meicr_local_en)
    inj_en     <= iui_regs_src0[0];
  else if(inj_done)
    inj_en     <= 1'b0;
  else
    inj_en     <= inj_en;
end

always @(posedge ecc_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
  begin
    inj_ramid[2:0] <= 3'b0;
    fatal_inj      <= 1'b0;
  end
  else if(meicr_local_en)
  begin
    inj_ramid[2:0] <= iui_regs_src0[31:29];
    fatal_inj      <= iui_regs_src0[1];
  end
  else
  begin
    inj_ramid[2:0] <= inj_ramid[2:0];
    fatal_inj      <= fatal_inj;
  end
end
assign meicr_value[63:0] = {32'b0, inj_ramid[2:0], 27'b0, fatal_inj, inj_en};

always @(posedge ecc_clk or negedge cpurst_b)
begin
  if(!cpurst_b) begin 
    ecc_random_0[51:0]  <= 52'b1;
  end
  else if(meicr_local_en && iui_regs_src0[0]) begin 
    ecc_random_0[51:0]  <= ecc_random_0_updt[51:0];
  end
end
assign ecc_random_0_updt[51:0] = ecc_random_0[51] ? 52'b1 : (ecc_random_0[51:0] << 1'b1);

always @(posedge ecc_clk or negedge cpurst_b)
begin
  if(!cpurst_b) begin 
    ecc_random_1_fatal[38:0]  <= 39'b11;
  end
  else if(meicr_local_en && iui_regs_src0[0]) begin 
    if (ecc_random_1_fatal[38:37] == 2'b11)
      ecc_random_1_fatal[38:0]  <= {ecc_random_1_fatal_updt[38:1],1'b1};
    else if (ecc_random_1_fatal[38:37] == 2'b10)
      ecc_random_1_fatal[38:0]  <= 39'b11;
    else
      ecc_random_1_fatal[38:0]  <= ecc_random_1_fatal_updt[38:0];
  end
end

assign ecc_random_1_fatal_updt[38:0]  = ecc_random_1_fatal[38:0] << 1'b1;

assign ecc_random_1[38:0] = fatal_inj ? ecc_random_1_fatal[38:0]
                                      : ecc_random_0[38:0] | {26'b0, ecc_random_0[51:39]};

assign random_30_bit[`WK_PPN_WIDTH+1:0] = ecc_random_0[`WK_PPN_WIDTH+1: 0]| 
                       {{(`WK_PPN_WIDTH*2-48){1'b0}},ecc_random_0[51:`WK_PPN_WIDTH+2]};

assign random_33_bit[32:0] = ecc_random_0[32: 0]| 
                      {14'b0,ecc_random_0[51:33]};

assign random_34_bit[33:0] = ecc_random_1[33: 0]| 
                      {29'b0,ecc_random_1[38:34]};

assign random_37_bit[36:0] = ecc_random_1[36: 0]| 
                      {35'b0,ecc_random_1[38:37]};

assign random_38_bit[37:0] = ecc_random_1[37: 0]| 
                      {37'b0,ecc_random_1[38]};

assign random_39_bit[38:0] = ecc_random_1[38: 0];

assign random_41_bit[40:0] = ecc_random_0[40: 0]|
                      {30'b0,ecc_random_0[51:41]};

assign random_42_bit[41:0] = ecc_random_0[41:0]|
                      {32'b0,ecc_random_0[51:42]};

assign random_44_bit[43:0] = ecc_random_0[43: 0]|
                      {37'b0,ecc_random_0[51:44]};

assign random_45_bit[44:0] = ecc_random_0[44:0]|
                      {38'b0, ecc_random_0[51:45]};

assign random_51_bit[50:0] = ecc_random_0[50: 0]|
                      {50'b0, ecc_random_0[51]};

assign random_52_bit[51:0] = ecc_random_0[51:0];

assign inj_done = ifu_cp0_tag_inj_cmplt || ifu_cp0_data_inj_cmplt ||
                  lsu_cp0_tag_inj_cmplt || lsu_cp0_data_inj_cmplt ||
                  mmu_cp0_tag_inj_cmplt || mmu_cp0_data_inj_cmplt;



//==========================================================
//               Define the MCINS register
//  Machine Cache Instruction register
//  64-bit Machine Mode Read/Write
//  Providing the C-SKY Cache Read Line Instruction
//  the definiton for MCINS register is listed as follows
//==========================================================
always @(posedge regs_flush_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    cins_r <= 1'b0;
  else if(rtu_yy_xx_flush)
    cins_r <= 1'b0;
  else if(mcins_local_en)
    cins_r <= iui_regs_src0[0];
  else if(cins_read_data_vld)
    cins_r <= 1'b0;
  else
    cins_r <= cins_r;
end
always @(posedge regs_flush_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    cins_ff <= 1'b0;
  else if(rtu_yy_xx_flush)
    cins_ff <= 1'b0;
  else if(mcins_local_en)
    cins_ff <= iui_regs_src0[0];
  else if(cins_ff && (!regs_dca_sel || biu_cp0_cmplt))
    cins_ff <= 1'b0;
  else
    cins_ff <= cins_ff;
end

//write only register
assign mcins_value[63:0] = 64'd0;

//==========================================================
//               Define the MCINDEX register
//  Machine Cache Read Line Index register
//  64-bit Machine Mode Read/Write
//  Providing the C-SKY Cache Read Line Index
//  the definiton for MCINDEX register is listed as follows
//==========================================================
always @(posedge regs_clk or negedge cpurst_b)
begin
  if (!cpurst_b) begin
    cindex_rid[4:0]    <= 5'b0;
    cindex_way[3:0]    <= 4'b0;
    cindex_index[20:0] <= 21'b0;
  end
  else if (mcindex_local_en) begin
    cindex_rid[4:0]    <= iui_regs_src0[32:28];
    cindex_way[3:0]    <= iui_regs_src0[24:21];
    cindex_index[20:0] <= iui_regs_src0[20:0];
  end
  else begin
    cindex_rid[4:0]    <= cindex_rid[4:0];
    cindex_way[3:0]    <= cindex_way[3:0];
    cindex_index[20:0] <= cindex_index[20:0];
  end
end

assign mcindex_value[63:0] = {31'b0, cindex_rid[4:0], 3'b0,
                              cindex_way[3:0], cindex_index[20:0]};

//ram select
assign cindex_rid_icache_tag           = (cindex_rid[4:0] == 5'd0);
assign cindex_rid_icache_data          = (cindex_rid[4:0] == 5'd1);
assign cindex_rid_dcache_st_tag        = (cindex_rid[4:0] == 5'd2);
assign cindex_rid_dcache_data          = (cindex_rid[4:0] == 5'd3);
assign cindex_rid_l2cache_tag          = (cindex_rid[4:0] == 5'd4);
assign cindex_rid_l2cache_data         = (cindex_rid[4:0] == 5'd5);

assign cindex_rid_dcache_ld_tag        = (cindex_rid[4:0] == 5'd12);
assign cindex_rid_icache_predecode     = (cindex_rid[4:0] == 5'd19);

assign cindex_rid_dtcm                 = 1'b0;

assign cindex_rid_itcm                 = 1'b0;
assign cindex_rid_itcm_predecode       = 1'b0;

assign cindex_rid_icache_tag_ecc       = (cindex_rid[4:0] == 5'd6);
assign cindex_rid_icache_data_ecc      = (cindex_rid[4:0] == 5'd7);
assign cindex_rid_dcache_st_tag_ecc    = (cindex_rid[4:0] == 5'd8);
assign cindex_rid_dcache_data_ecc      = (cindex_rid[4:0] == 5'd9);
assign cindex_rid_dcache_ld_tag_ecc    = (cindex_rid[4:0] == 5'd13);
assign cindex_rid_dtcm_ecc             = 1'b0;
assign cindex_rid_itcm_ecc             = 1'b0;

assign cindex_rid_l2cache_tag_ecc      = (cindex_rid[4:0] == 5'd10);
assign cindex_rid_l2cache_data_ecc     = (cindex_rid[4:0] == 5'd11);


//==========================================================
//               Define the MCDATA0/1 register
//  Machine Cache Read Line Data register
//  64-bit Machine Mode Read/Write
//  Providing the C-SKY Cache Read Line Data Register
//  the definiton for MCDATA0/1 register is listed as follows
//==========================================================
assign cdata_data_vld = ifu_cp0_icache_read_data_vld
                      | lsu_cp0_dcache_read_data_vld
                      | biu_cp0_cmplt & cins_r;
// &CombBeg; @3299
always @( lsu_cp0_dcache_read_data_vld
       or biu_cp0_rdata[127:0]
       or ifu_cp0_icache_read_data[127:0]
       or ifu_cp0_icache_read_data_vld
       or biu_cp0_cmplt
       or lsu_cp0_dcache_read_data[127:0])
begin
  case({biu_cp0_cmplt,
        lsu_cp0_dcache_read_data_vld,
        ifu_cp0_icache_read_data_vld})
    3'b001 : cdata_read_data[127:0] = ifu_cp0_icache_read_data[127:0];
    3'b010 : cdata_read_data[127:0] = lsu_cp0_dcache_read_data[127:0];
    3'b100 : cdata_read_data[127:0] = biu_cp0_rdata[127:0];
    default: cdata_read_data[127:0] = {128{1'bx}};
  endcase
// &CombEnd; @3308
end

always @(posedge cdata_clk or negedge cpurst_b)
begin
  if (!cpurst_b) begin
    cdata0[63:0] <= 64'b0;
    cdata1[63:0] <= 64'b0;
  end
  else if (cdata_data_vld) begin
    cdata0[63:0] <= cdata_read_data[63:0];
    cdata1[63:0] <= cdata_read_data[127:64];
  end
  else begin
    cdata0[63:0] <= cdata0[63:0];
    cdata1[63:0] <= cdata1[63:0];
  end
end

assign mcdata0_value[63:0] = cdata0[63:0];
assign mcdata1_value[63:0] = cdata1[63:0];

assign cins_no_op_data_vld = cins_r
                             && !(cindex_rid_icache_tag
                               || cindex_rid_icache_data
                               || cindex_rid_dcache_st_tag
                               || cindex_rid_dcache_data
                               || cindex_rid_l2cache_tag
                               || cindex_rid_l2cache_data
                               || cindex_rid_icache_tag_ecc
                               || cindex_rid_icache_data_ecc
                               || cindex_rid_dcache_st_tag_ecc
                               || cindex_rid_dcache_data_ecc
                               || cindex_rid_l2cache_tag_ecc
                               || cindex_rid_l2cache_data_ecc
                               || cindex_rid_dcache_ld_tag
                               || cindex_rid_dcache_ld_tag_ecc
                               || cindex_rid_dtcm
                               || cindex_rid_dtcm_ecc
                               || cindex_rid_itcm
                               || cindex_rid_itcm_ecc
                               || cindex_rid_itcm_predecode
                               || cindex_rid_icache_predecode
                               );

assign cins_read_data_vld  = cdata_data_vld || cins_no_op_data_vld;


//==========================================================
//               Define the MCPUID register
//  Machine CPUID register
//  64-bit Machine Mode Read/Write
//  Providing the C-SKY CPUID Register
//  the definiton for MCPUID register is listed as follows
//==========================================================
//----------------------------------------------------------
//                    Index Register
//----------------------------------------------------------
assign index_max = (index[2:0] == 3'd6);
assign index_next_val[2:0] = (index_max) ? 3'd0
                                         : index[2:0] + 3'd1;

always @(posedge regs_flush_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    index[2:0] <= 3'b0;
  else if(iui_regs_ex3_inst_csr && mcpuid_local_en)
    index[2:0] <= index_next_val[2:0];
  else
    index[2:0] <= index[2:0];
end

//----------------------------------------------------------
//                Inplement of cpuid register
//----------------------------------------------------------
// &CombBeg; @3382
always @( cpuid_index1_value[31:0]
       or cpuid_index2_value[31:0]
       or cpuid_index5_value[31:0]
       or index[2:0]
       or cpuid_index6_value[31:0]
       or cpuid_index0_value[31:0]
       or cpuid_index4_value[31:0]
       or cpuid_index3_value[31:0])
begin
  case(index[2:0])
  3'b000   : mcpuid_value[31:0] = cpuid_index0_value[31:0];
  3'b001   : mcpuid_value[31:0] = cpuid_index1_value[31:0];
  3'b010   : mcpuid_value[31:0] = cpuid_index2_value[31:0];
  3'b011   : mcpuid_value[31:0] = cpuid_index3_value[31:0];
  3'b100   : mcpuid_value[31:0] = cpuid_index4_value[31:0];
  3'b101   : mcpuid_value[31:0] = cpuid_index5_value[31:0];
  3'b110   : mcpuid_value[31:0] = cpuid_index6_value[31:0];
  default  : mcpuid_value[31:0] = 32'b0;
  endcase
// &CombEnd; @3393
end

//---------------------------------------------------------
//                    Index 0
//---------------------------------------------------------
    assign cpuid_index0_value[31:28] = 4'b0000;

//------------------------------------------------
//                     Arch  
//------------------------------------------------
    assign cpuid_index0_value[27:26] = 2'b10;   // CSKY V3 ISA Arch

//------------------------------------------------
//                     Family
//------------------------------------------------
    assign cpuid_index0_value[25:22] = 4'b0100; // C Series Family

//------------------------------------------------
//                     Class 
//------------------------------------------------
    assign cpuid_index0_value[21:18] = 4'b0011; // C960 Class

//------------------------------------------------
//                     Model 
//------------------------------------------------
    assign cpuid_index0_value[17:12] = 6'b0; 
    assign cpuid_index0_value[11] = 1'b1;
    assign cpuid_index0_value[10] = 1'b0;  
    assign cpuid_index0_value[9] = 1'b0;
    assign cpuid_index0_value[8] = 1'b1;  //FPU

//------------------------------------------------
//                    ISA Revision
//------------------------------------------------
//Revision 0:
//  Initial revision
    assign cpuid_index0_value[7:3] = 5'b00001; 

//------------------------------------------------
//                     Version
//------------------------------------------------
    assign cpuid_index0_value[2:0] = 3'b101; //CPID Rev.5.0

//---------------------------------------------------------
//                    Index 1
//---------------------------------------------------------
    assign cpuid_index1_value[31:28] = 4'b0001;

//------------------------------------------------
//                    Revision
//------------------------------------------------
    assign cpuid_index1_value[27:24] = `WK_REVISION;

//------------------------------------------------
//                  Sub Version
//------------------------------------------------
    assign cpuid_index1_value[23:18] = `WK_SUB_VERSION;

//------------------------------------------------
//                     Patch
//------------------------------------------------
    assign cpuid_index1_value[17:12] = `WK_PATCH;

//------------------------------------------------
//                    PRODUCT ID
//------------------------------------------------
    assign cpuid_index1_value[11:0] = `WK_PRODUWK_ID;

//---------------------------------------------------------
//                    Index 2
//---------------------------------------------------------
    assign cpuid_index2_value[31:28] = 4'b0010;

//---------------------------------------------------------
//                    BUS0 
//---------------------------------------------------------
    assign cpuid_index2_value[27:24] = 4'b0110; //AXI128

//---------------------------------------------------------
//                    BUS1
//---------------------------------------------------------
    assign cpuid_index2_value[23:20] = 4'b0000;

//---------------------------------------------------------
//                    PLIC
//---------------------------------------------------------
    assign cpuid_index2_value[19] = 1'b1;

//---------------------------------------------------------
//                    CLINT
//---------------------------------------------------------
    assign cpuid_index2_value[18] = 1'b1;

//------------------------------------------------
//                    Reserved 
//------------------------------------------------
    assign cpuid_index2_value[17:16] = 2'b0;

//---------------------------------------------------------
//                    COPROCESSOR
//---------------------------------------------------------
    assign cpuid_index2_value[15:1] = 15'b0;

    assign cpuid_index2_value[0]     = 1'b1;

//---------------------------------------------------------
//                    Index 3
//---------------------------------------------------------
    assign cpuid_index3_value[31:28] = 4'b0011;

//------------------------------------------------
//                    Reserved 
//------------------------------------------------
    assign cpuid_index3_value[27:25] = 3'b0;


//------------------------------------------------
//                    IBP 
//------------------------------------------------
    assign cpuid_index3_value[24:22] = 3'b001;

//------------------------------------------------
//                      BTB
//------------------------------------------------
    assign cpuid_index3_value[21:19] = 3'b010; 

//------------------------------------------------
//                      BHT   
//------------------------------------------------
    assign cpuid_index3_value[18:16] = 3'b011; //8K BHT 

//------------------------------------------------
//                      DSPM 
//------------------------------------------------

    assign cpuid_index3_value[15:12] = 4'b0000; 

//------------------------------------------------
//                      ISPM 
//------------------------------------------------

    assign cpuid_index3_value[11:8] = 4'b0000; 

//------------------------------------------------
//                     DCACHE
//------------------------------------------------
    assign cpuid_index3_value[7:4]   = 4'b0111;

//------------------------------------------------
//                     ICACHE
//------------------------------------------------
    assign cpuid_index3_value[3:0]   = 4'b0111;
//---------------------------------------------------------
//                    Index 4
//---------------------------------------------------------
    assign cpuid_index4_value[31:28] = 4'b0100;

//------------------------------------------------
//                 ICache Way Info
//------------------------------------------------
    assign cpuid_index4_value[27:26] = 2'b0; // 2-Way

//------------------------------------------------
//                ICache Line Size
//------------------------------------------------
    assign cpuid_index4_value[25:24] = 2'b10; // 64-Bytes

//------------------------------------------------
//                   ICache ECC
//------------------------------------------------
    assign cpuid_index4_value[23:22] = 2'b1; // With ECC

//------------------------------------------------
//                 DCache Way Info
//------------------------------------------------
    assign cpuid_index4_value[21:20] = 2'b0; // 2-Way

//------------------------------------------------
//                DCache Line Size
//------------------------------------------------
    assign cpuid_index4_value[19:18] = 2'b10; // 64-Bytes

//------------------------------------------------
//                   DCache ECC
//------------------------------------------------
    assign cpuid_index4_value[17:16] = 2'b1; // With ECC

//------------------------------------------------
//                    Reserved
//------------------------------------------------
    assign cpuid_index4_value[15:12] = 4'b0;

//------------------------------------------------
//                    WAY
//------------------------------------------------
    assign cpuid_index4_value[11:8] = 4'b0100;

//------------------------------------------------
//                    Reserved
//------------------------------------------------
    assign cpuid_index4_value[7:6] = 2'b0;

//------------------------------------------------
//                    ECC
//------------------------------------------------
    assign cpuid_index4_value[5:4] = 2'b1;

//------------------------------------------------
//                  L2 CACHE
//------------------------------------------------
    assign cpuid_index4_value[3:0] = 4'b0110;

//---------------------------------------------------------
//                    Index 5
//---------------------------------------------------------
    assign cpuid_index5_value[31:28] = 4'b0101;

//------------------------------------------------
//                    Reserved
//------------------------------------------------
    assign cpuid_index5_value[27:4] = 24'b0;

//------------------------------------------------
//                    SLAVEIF
//------------------------------------------------
    assign cpuid_index5_value[3] = 1'b1;

//------------------------------------------------
//                    CORENUM
//------------------------------------------------
    assign cpuid_index5_core_num_1 = 1'b0;
    assign cpuid_index5_core_num_2 = 1'b0;
    assign cpuid_index5_core_num_3 = 1'b0;
    assign cpuid_index5_value[2:0] = {2'b0, cpuid_index5_core_num_1}
                                   + {2'b0, cpuid_index5_core_num_2}
                                   + {2'b0, cpuid_index5_core_num_3};
  
//---------------------------------------------------------
//                    Index 6
//---------------------------------------------------------
    assign cpuid_index6_value[31:28] = 4'b0110;

//------------------------------------------------
//                    Reserved
//------------------------------------------------
    assign cpuid_index6_value[27:12] = 16'b0;

//------------------------------------------------
//                    MMU_TLB
//------------------------------------------------
    assign cpuid_index6_value[11:8] = 4'b1010;

//------------------------------------------------
//                    MGU ZONE SIZE
//------------------------------------------------
    assign cpuid_index6_value[7:4] = 4'b0101; // PMP 4K

//------------------------------------------------
//                    MGU ZONE NUM
//------------------------------------------------
    assign cpuid_index6_value[3:0] = 4'b0011; 

//==========================================================
//               Define the MAPBADDR register
//==========================================================
assign mapbaddr_value[63:0] = {{64-`WK_PA_WIDTH{biu_cp0_apb_base[`WK_PA_WIDTH-1]}}, biu_cp0_apb_base};

//==========================================================
//               Define the MWMSR register
//==========================================================
assign mwmsr_value[63:0] = 64'b0;

//==========================================================
//               Define the SXSTATUS register
//  Supervisor Extension Status Register
//  64-bit Supervisor Mode Read/Write
//  Providing the C-SKY Extension Status Register
//  the definiton for SXSTATUS register is listed as follows
//==========================================================
assign sxstatus_value[63:0]  = {32'b0, pm[1:0], 7'b0, cskyisaee, maee,
                                fccee, insde, mhrd, clintee, ucme, mm,
                                1'b0, pmdm, 1'b0, pmds, pmdu, 10'b0};


//==========================================================
//               Define the SHCR register
//  Supervisor Hardware Config register
//  64-bit Supervisor Mode Read Only
//  Providing the C-SKY Hardware Config of the current core
//  the definiton for SHCR register is listed as follows
//==========================================================
assign shcr_value[63:0] = {45'b0, sck[2:0], 3'b0, l0btbe, 3'b0, wbr, ibpe,
                           btbe, bpe, rse, wb, wa, de, ie};


//==========================================================
//               Define the SCER register
//  Supervisor Cache Error Register
//  64-bit Supervisor Mode Read Only
//  Providing the Cache Error Information
//  the definiton for MCER register is listed as follows
//==========================================================
assign scer_value[63:0] = {32'b0, ecc_vld, err_fatal, fix_cnt[5:0],
                           ramid[2:0], 2'b0, err_way[1:0], err_index[16:0]};


//==========================================================
//               Define the SSBEPA register
//  supervisor single bit ecc error physical address Register
//  64-bit Supervisor mode Read/Write
//  Providing the physical address of SBE 
//  the definition for SSBEPA register is listed as follows
//==========================================================
assign ssbepa_value[63:0] = {{64-`WK_PA_WIDTH{1'b0}}, sbepa[`WK_PA_WIDTH-1:0]};


//==========================================================
//               Define the FXCR register
//  Float Point Extension Control Register
//  64-bit User Mode Read/Write
//  Providing the C-SKY Float Point Register
//  the definiton for FXCR register is listed as follows
//==========================================================
always @(posedge regs_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
  begin
    fxcr_dqnan   <= 1'b0;
    fxcr_fe      <= 1'b0;
  end
  else if (fxcr_local_en)
  begin
    fxcr_dqnan   <= iui_regs_src0[23];
    fxcr_fe      <= iui_regs_src0[5];
  end
  else if (idu_cp0_fesr_acc_updt_vld)
  begin
    fxcr_dqnan   <= fxcr_dqnan;
    fxcr_fe      <= fxcr_fe || idu_cp0_fesr_acc_updt_val[5];
  end
  else
  begin
    fxcr_dqnan   <= fxcr_dqnan;
    fxcr_fe      <= fxcr_fe;
  end
end

assign fxcr_value[63:0]    = {37'b0, fcsr_frm[2:0], fxcr_dqnan, 
                              17'b0, fxcr_fe, fcsr_nv,
                              fcsr_dz, fcsr_of, fcsr_uf, fcsr_nx};

assign cp0_vfpu_fxcr[31:0] = fxcr_value[31:0];

//==========================================================
//               Define the HSTATUS register
//  Hypervisor Status Register
//  64-bit hypervisor Mode Read/Write
//  Providing the CPU Status
//  the definiton for HSTATUS register is listed as follows
//==========================================================
assign hstatus_value[63:0] = 64'b0;

//==========================================================
//               Define the HEDELEG register
//  Hypervisor Exception Delegation Register
//  64-bit Machine Mode Read/Write
//  Providing the CPU Status
//  the definiton for HEDELEG register is listed as follows
//==========================================================
assign hedeleg_value[63:0] = 64'b0;

//==========================================================
//               Define the VSTATUS register
//  Virtial Supervisor Status Register
//  64-bit hypervisor Mode Read/Write
//  Providing the CPU Status
//  the definiton for VSSTATUS register is listed as follows
//==========================================================
assign vsstatus_value[63:0] = 64'b0;



//==========================================================
// select regs depending on the implementation location
//==========================================================
assign cp0_regs_sel = iui_regs_addr[11:8] == 4'hF  && !dtu_regs_sel // M-Infor
                   || iui_regs_addr[11:4] == 8'h30 // M-Trap Setup
                   || iui_regs_addr[11:4] == 8'h34 // M-Trap Handling
                   || iui_regs_addr[11:4] == 8'h10 // S-Trap Setup
                   || iui_regs_addr[11:4] == 8'h14 // S-Trap Handling
                   || iui_regs_addr[11:4] == 8'h7C && !l2_regs_sel 
                      && iui_regs_addr[3:1] != 3'b101 // Extension CSR 
                   || iui_regs_addr[11:4] == 8'h7D // Extension Cache Read
                   || iui_regs_addr[11:4] == 8'h5C && !scer2_local_en
                      && iui_regs_addr[3:2] == 2'b00 // S-Extension CSR 
                   || mteecfg_local_en
                   || iui_regs_addr[11:8] == 4'h0  // User F-CSR
                   || iui_regs_addr[11:8] == 4'h8  // FXCR
                   || iui_regs_addr[11:8] == 4'h6  // Hypervisor CSR
                   || iui_regs_addr[11:8] == 4'h2  // VS CSR
                   || iui_regs_addr[11:4] == 8'hC2 // Vector
                   || iui_regs_addr[11:0] == MDTCMCR // DTCMCR
                   || iui_regs_addr[11:0] == MITCMCR // ITCMCR
                   || iui_regs_addr[11:0] == MIESR   // MIESR
                   || iui_regs_addr[11:0] == SIESR   // SIESR
                   || iui_regs_addr[11:0] == MSBEPA  // MSBEPA
                   || iui_regs_addr[11:0] == MZONEID // MZONEID // Risc-V Debug zdb
                   || iui_regs_addr[11:0] == SSBEPA; // SSBEPA

assign pmp_regs_sel = iui_regs_addr[11:4] == 8'h3A
                   || iui_regs_addr[11:4] == 8'h3B
                   || iui_regs_addr[11:4] == 8'h3C
                   || iui_regs_addr[11:4] == 8'h3D
                   || iui_regs_addr[11:4] == 8'h3E;
    
`ifdef ADD_AIA  
assign aia_regs_sel =  iui_regs_addr[11:4] == 8'h35   // M-AIA interrupt by Chenlili@20250521
                   || iui_regs_addr[11:4] == 8'h15;   // S-AIA interrupt by Chenlili@20250521

assign aia_mvregs_sel = iui_regs_addr[11:0] == 12'h308  // MV-AIA interrupt by zhangdunbo@20260605
                   || iui_regs_addr[11:0] == 12'h309;   // MV-AIA interrupt by zhangdunbo@20260605  

assign aia_tpoiregs_sel = iui_regs_addr[11:0] == 12'hFB0  // MV-AIA interrupt by zhangdunbo@20260608
                   || iui_regs_addr[11:0] == 12'hDB0;   // MV-AIA interrupt by zhangdunbo@20260608     
`endif 

assign hpm_regs_sel = iui_regs_addr[11:8] == 4'hB  // Machine Counters/Timers
                   || iui_regs_addr[11:4] == 8'h32 // Machine Counter Setup
                   || iui_regs_addr[11:4] == 8'h33 // Machine Counter Setup
                   || iui_regs_addr[11:4] == 8'h7C 
                     && iui_regs_addr[3:1] == 3'b101 // Machine Counter Control
                   || iui_regs_addr[11:2] == 10'h1FC 
                     && iui_regs_addr[1:0] != 2'b11 // Machine HPM Extension
                   || iui_regs_addr[11:4] == 8'h5C 
                      && (iui_regs_addr[3:2] == 2'b10 || iui_regs_addr[3:1] == 3'b010) // Supervisor Counter Control
                   || iui_regs_addr[11:4] == 8'h5E // Supervisor Counter/Timers
                   || iui_regs_addr[11:4] == 8'h5F // Supervisor Counter/Timers
                   || iui_regs_addr[11:4] == 8'hC0 // User Counter/Timers
                   || iui_regs_addr[11:4] == 8'hC1;// User Counter/Timers

assign l2_regs_sel  = mccr2_local_en || mcer2_local_en || mdbginfo2_local_en
//                   || mrmr_local_en  || mrvbr_local_en
                   || regs_dca_sel
                   || msmpr_local_en  || mteecfg_local_en && !(tee_lock && iui_regs_csr_wr)
                   || meicr2_local_en || scer2_local_en || mhint4_local_en
                   || msbepa2_local_en || ssbepa2_local_en;

assign mmu_regs_sel = iui_regs_addr[11:8] == 4'h9;


//==========================================================
// select read data from all regs in cp0
//==========================================================
// &CombBeg; @4086
always @( hedeleg_value[63:0]
       or mhint3_value[63:0]
       or miesr_value[63:0]
       or mxstatus_value[63:0]
       or sepc_value[63:0]
       or mrvbr_value[63:0]
       or vxrm_value[63:0]
       or sip_value[63:0]
       or mip_value[63:0]
       or stvec_value[63:0]
       or mhartid_value[63:0]
       or mtvec_value[63:0]
       or vsstatus_value[63:0]
       or mhint_value[63:0]
       or vxsat_value[63:0]
       or vcsr_value[63:0]
       or mcindex_value[63:0]
       or mvendorid_value[63:0]
       or sxstatus_value[63:0]
       or frm_value[63:0]
       or scause_value[63:0]
       or mcpuid_value[31:0]
       or mcause_value[63:0]
       or mcntwen_value[63:0]
       or sstatus_value[63:0]
       or scer_value[63:0]
       or mtval_value[63:0]
       or scnten_value[63:0]
       or iui_regs_addr[11:0]
       or mimpid_value[63:0]
       or marchid_value[63:0]
       or vl_value[63:0]
       or fxcr_value[63:0]
       or siesr_value[63:0]
       or mwmsr_value[63:0]
       or vlenb_value[63:0]
       or mepc_value[63:0]
       or mideleg_value[63:0]
       or meicr_value[63:0]
       or mcdata1_value[63:0]
       or sie_value[63:0]
       or fflags_value[63:0]
       or mhcr_value[63:0]
       or fcsr_value[63:0]
       or mcer_value[63:0]
       or mscratch_value[63:0]
       or mcins_value[63:0]
       or mstatus_value[63:0]
       or medeleg_value[63:0]
       or misa_value[63:0]
       or sscratch_value[63:0]
       or mie_value[63:0]
       or hstatus_value[63:0]
       or stval_value[63:0]
       or mcdata0_value[63:0]
       or mcnten_value[63:0]
       or mapbaddr_value[63:0]
       or msbepa_value[63:0]
       or mdtcmcr_value[63:0]
       or shcr_value[63:0]
       or mhint2_value[63:0]
       or ssbepa_value[63:0]
       or vtype_value[63:0]
       or mteecfg_value[63:0]
       or mcor_value[63:0]
       or vstart_value[63:0]
       or mitcmcr_value[63:0]
       or mzoneid_value[63:0])
begin
  case(iui_regs_addr[11:0])
    MVENDORID : data_out[63:0] = mvendorid_value[63:0];
    MARCHID   : data_out[63:0] = marchid_value[63:0];
    MIMPID    : data_out[63:0] = mimpid_value[63:0];
    MHARTID   : data_out[63:0] = mhartid_value[63:0];

    MSTATUS   : data_out[63:0] = mstatus_value[63:0];
    MISA      : data_out[63:0] = misa_value[63:0];
    MEDELEG   : data_out[63:0] = medeleg_value[63:0];
    MIDELEG   : data_out[63:0] = mideleg_value[63:0];
    MIE       : data_out[63:0] = mie_value[63:0];
    MTVEC     : data_out[63:0] = mtvec_value[63:0];
    MCNTEN    : data_out[63:0] = mcnten_value[63:0];

    MSCRATCH  : data_out[63:0] = mscratch_value[63:0];
    MEPC      : data_out[63:0] = mepc_value[63:0];
    MCAUSE    : data_out[63:0] = mcause_value[63:0];
    MTVAL     : data_out[63:0] = mtval_value[63:0];
    MIP       : data_out[63:0] = mip_value[63:0];

    SSTATUS   : data_out[63:0] = sstatus_value[63:0];
    SIE       : data_out[63:0] = sie_value[63:0];
    STVEC     : data_out[63:0] = stvec_value[63:0];
    SCNTEN    : data_out[63:0] = scnten_value[63:0];
    
    SSCRATCH  : data_out[63:0] = sscratch_value[63:0];
    SEPC      : data_out[63:0] = sepc_value[63:0];
    SCAUSE    : data_out[63:0] = scause_value[63:0];
    STVAL     : data_out[63:0] = stval_value[63:0];
    SIP       : data_out[63:0] = sip_value[63:0];

    FFLAGS    : data_out[63:0] = fflags_value[63:0];
    FRM       : data_out[63:0] = frm_value[63:0];
    FCSR      : data_out[63:0] = fcsr_value[63:0];
    VSTART    : data_out[63:0] = vstart_value[63:0];
    VXSAT     : data_out[63:0] = vxsat_value[63:0];
    VXRM      : data_out[63:0] = vxrm_value[63:0];
    VCSR      : data_out[63:0] = vcsr_value[63:0];
    VL        : data_out[63:0] = vl_value[63:0];
    VTYPE     : data_out[63:0] = vtype_value[63:0];
    VLENB     : data_out[63:0] = vlenb_value[63:0];

    MXSTATUS  : data_out[63:0] = mxstatus_value[63:0];
    MHCR      : data_out[63:0] = mhcr_value[63:0];
    MCOR      : data_out[63:0] = mcor_value[63:0];
    MHINT     : data_out[63:0] = mhint_value[63:0];
    MRVBR     : data_out[63:0] = mrvbr_value[63:0];
    MCER      : data_out[63:0] = mcer_value[63:0];
    MCNTWEN   : data_out[63:0] = mcntwen_value[63:0];
    MHINT2    : data_out[63:0] = mhint2_value[63:0];
    MHINT3    : data_out[63:0] = mhint3_value[63:0];

    MZONEID   : data_out[63:0] = mzoneid_value[63:0]; // Risc-V Debug zdb
    MTEECFG   : data_out[63:0] = mteecfg_value[63:0];
    MDTCMCR   : data_out[63:0] = mdtcmcr_value[63:0];
    MITCMCR   : data_out[63:0] = mitcmcr_value[63:0];
    MIESR     : data_out[63:0] = miesr_value[63:0];
    MSBEPA    : data_out[63:0] = msbepa_value[63:0];

    MCINS     : data_out[63:0] = mcins_value[63:0];
    MCINDEX   : data_out[63:0] = mcindex_value[63:0];
    MCDATA0   : data_out[63:0] = mcdata0_value[63:0];
    MCDATA1   : data_out[63:0] = mcdata1_value[63:0];
    MEICR     : data_out[63:0] = meicr_value[63:0];

    MCPUID    : data_out[63:0] = {32'b0, mcpuid_value[31:0]};
    MAPBADDR  : data_out[63:0] = mapbaddr_value[63:0];
    MWMSR     : data_out[63:0] = mwmsr_value[63:0];

    SXSTATUS  : data_out[63:0] = sxstatus_value[63:0];
    SHCR      : data_out[63:0] = shcr_value[63:0];
    SCER      : data_out[63:0] = scer_value[63:0];
    SIESR     : data_out[63:0] = siesr_value[63:0];
    SSBEPA    : data_out[63:0] = ssbepa_value[63:0];

    FXCR      : data_out[63:0] = fxcr_value[63:0];

    HSTATUS   : data_out[63:0] = hstatus_value[63:0];
    HEDELEG   : data_out[63:0] = hedeleg_value[63:0];

    VSSTATUS  : data_out[63:0] = vsstatus_value[63:0];

    default   : data_out[63:0] = 64'b0; 
  endcase
// &CombEnd; @4169
end

//==========================================================
//                 Generate output to IUI
//==========================================================
// control signals
assign regs_iui_tsr     = tsr;
assign regs_iui_tw      = tw;
assign regs_iui_tvm     = tvm;
assign regs_iui_pm[1:0] = pm[1:0];
assign regs_iui_v       = v;
assign regs_iui_cskyee  = cskyisaee;

// //&Force("output", "regs_iui_cfr_no_op"); @4185
// //&Force("output", "regs_iui_cins_no_op"); @4186
assign regs_iui_cfr_no_op  = !(ibp_inv || btb_inv || bht_inv || inv || clr || mcor_local_en);
assign regs_iui_cins_no_op = !(cins_r || mcins_local_en);

// data signals
assign regs_iui_data_out[63:0] = {64{cp0_regs_sel}}  & data_out[63:0] 
                               | {64{pmp_regs_sel}}  & pmp_cp0_data[63:0]
                               //| {64{l2_regs_sel}}   & biu_cp0_l2_data[63:0]
                               | {64{hpm_regs_sel}}  & hpcp_cp0_data[63:0]
                               | {64{satp_local_en}} & mmu_cp0_satp_data[63:0]
                               | {64{dtu_regs_sel}}  & dtu_cp0_rdata[63:0] // Risc-V Debug zdb
`ifdef ADD_AIA  
                               | {64{aia_regs_sel}}  & aia_cp0_data[63:0]  //for AIA IMNSIC  add by chenlili@20251203 
                               | {64{aia_mvregs_sel | aia_tpoiregs_sel}}  & aia_regs_data[63:0]  //for AIA IMNSIC  add by zhangdunbo@20260606
`endif 
                               | {64{mmu_regs_sel}}  & mmu_cp0_data[63:0];
assign regs_iui_l2_regs_sel    = l2_regs_sel;

// interrupt select
assign regs_iui_int_sel[14:0] = int_sel[14:0];

// status invalid exception
assign regs_iui_fs_off = (fs[1:0] == 2'b0);
assign regs_iui_vs_off = (vs[1:0] == 2'b0);

// int valid for low power mode
assign regs_lpmd_int_vld = meip_en || mtip_en || msip_en || seip_en || stip_en || ssip_en ||
                           mcip_en || moip_en;

// counter read enable generation
// address decode
// &CombBeg; @4212
always @( iui_regs_addr[4:0])
begin
case(iui_regs_addr[4:0])
  5'h00:   cnt_sel[31:0] = 32'h00000001;
  5'h01:   cnt_sel[31:0] = 32'h00000002;
  5'h02:   cnt_sel[31:0] = 32'h00000004;
  5'h03:   cnt_sel[31:0] = 32'h00000008;
  5'h04:   cnt_sel[31:0] = 32'h00000010;
  5'h05:   cnt_sel[31:0] = 32'h00000020;
  5'h06:   cnt_sel[31:0] = 32'h00000040;
  5'h07:   cnt_sel[31:0] = 32'h00000080;
  5'h08:   cnt_sel[31:0] = 32'h00000100;
  5'h09:   cnt_sel[31:0] = 32'h00000200;
  5'h0A:   cnt_sel[31:0] = 32'h00000400;
  5'h0B:   cnt_sel[31:0] = 32'h00000800;
  5'h0C:   cnt_sel[31:0] = 32'h00001000;
  5'h0D:   cnt_sel[31:0] = 32'h00002000;
  5'h0E:   cnt_sel[31:0] = 32'h00004000;
  5'h0F:   cnt_sel[31:0] = 32'h00008000;
  5'h10:   cnt_sel[31:0] = 32'h00010000;
  5'h11:   cnt_sel[31:0] = 32'h00020000;
  5'h12:   cnt_sel[31:0] = 32'h00040000;
  5'h13:   cnt_sel[31:0] = 32'h00080000;
  5'h14:   cnt_sel[31:0] = 32'h00100000;
  5'h15:   cnt_sel[31:0] = 32'h00200000;
  5'h16:   cnt_sel[31:0] = 32'h00400000;
  5'h17:   cnt_sel[31:0] = 32'h00800000;
  5'h18:   cnt_sel[31:0] = 32'h01000000;
  5'h19:   cnt_sel[31:0] = 32'h02000000;
  5'h1A:   cnt_sel[31:0] = 32'h04000000;
  5'h1B:   cnt_sel[31:0] = 32'h08000000;
  5'h1C:   cnt_sel[31:0] = 32'h10000000;
  5'h1D:   cnt_sel[31:0] = 32'h20000000;
  5'h1E:   cnt_sel[31:0] = 32'h40000000;
  5'h1F:   cnt_sel[31:0] = 32'h80000000;
  default: cnt_sel[31:0] = {32{1'bx}};
endcase
// &CombEnd; @4248
end

assign ucnt_addr_hit = iui_regs_addr[11:5] == 7'h60;
assign mcnten_hit = |(mcnten_reg[31:0] & cnt_sel[31:0]);
assign scnten_hit = |(scnten_reg[31:0] & cnt_sel[31:0]);

assign scnt_addr_hit = iui_regs_addr[11:5] == 7'h2F;
assign mcntwen_hit = |(mcntwen_reg[31:0] & cnt_sel[31:0]);

assign regs_iui_scnt_inv = ucnt_addr_hit && !mcnten_hit
                        || scnt_addr_hit && !mcnten_hit
                        || scnt_addr_hit && !mcntwen_hit && iui_regs_csr_wr;
assign regs_iui_ucnt_inv = ucnt_addr_hit && !(mcnten_hit && scnten_hit);

assign regs_iui_hpcp_scr_inv = (iui_regs_addr[11:0] == SHPMCR 
                                || iui_regs_addr[11:0] == SHPMSP
                                || iui_regs_addr[11:0] == SHPMEP)
                            && !hpcp_cp0_sce;
// &Force("output", "regs_xx_icg_en"); @4266
assign regs_xx_icg_en = local_icg_en[2];

assign regs_iui_mcins = iui_regs_addr[11:0] == MCINS;

//==========================================================
//                 Generate output to other modules
//==========================================================
// Global, IFU, IDU, LSU, MMU, PMP, HPCP, RTU, L2, HAD, PAD
//==========================================================

//==========================================================
//   Generate Global signals
//==========================================================
// endian mode
//assign endian_mode = 1'b0;
//assign endian_v2   = biu_cp0_endian_v2;
//assign cp0_yy_be   = endian_mode;
//assign cp0_yy_be_v1 = endian_mode && !endian_v2;
//assign cp0_yy_be_v2 = endian_mode && endian_v2;

// priviledge mode
assign cp0_yy_priv_mode[1:0] = pm[1:0];
assign cp0_yy_virtual_mode   = v;
assign cp0_yy_hyper          = misa_hypervisor;

// dcache prefetch enable, l2 cache prefetch enalbe included
assign cp0_yy_dcache_pref_en = dcache_pref_en || l2pld;


//==========================================================
//                 Generate output to IFU
//==========================================================
// IFU function modules enable
assign cp0_ifu_bht_en         = bpe;
assign cp0_ifu_btb_en         = btbe;
assign cp0_ifu_l0btb_en       = l0btbe;
assign cp0_ifu_icache_en      = ie;
assign cp0_ifu_icache_pref_en = icache_pref_en;
assign cp0_ifu_ind_btb_en     = ibpe;
assign cp0_ifu_insde          = insde;
assign cp0_ifu_iwpe           = iwpe;
assign cp0_ifu_lbuf_en        = lpe;
assign cp0_ifu_ras_en         = rse;
assign cp0_ifu_nsfe           = nsfe;
assign cp0_ifu_ecc_en            = ecc_en;
assign cp0_ifu_tag_ecc_inj       = inj_en && inj_ramid[2:0] == 3'b000;
assign cp0_ifu_data_ecc_inj      = inj_en && inj_ramid[2:0] == 3'b001;
assign cp0_ifu_tag_random[`WK_PPN_WIDTH+1:0]  = random_30_bit[`WK_PPN_WIDTH+1:0];
assign cp0_ifu_data_random[32:0] = random_33_bit[32:0];

// IFU Cache modules invalid
assign cp0_ifu_bht_inv        = bht_inv;
assign cp0_ifu_btb_inv        = btb_inv;
assign cp0_ifu_icache_inv     = icache_inv && sel[0] || iui_regs_rst_inv_i;
assign cp0_ifu_ind_btb_inv    = ibp_inv;

// I-Cache Read
assign cp0_ifu_icache_read_req         = cins_r && (cindex_rid_icache_tag
                                         || cindex_rid_icache_data
                                         || cindex_rid_icache_tag_ecc
                                         || cindex_rid_icache_data_ecc
                                         || cindex_rid_icache_predecode 
                                         || cindex_rid_itcm
                                         || cindex_rid_itcm_ecc
                                         || cindex_rid_itcm_predecode);
assign cp0_ifu_icache_read_type[4:0]   = cindex_rid[4:0]; 
assign cp0_ifu_icache_read_way         = cindex_way[0];
assign cp0_ifu_icache_read_index[16:0] = cindex_index[16:0];

// Vector Base Reg
assign cp0_ifu_vbr[`WK_PC_WIDTH-1:0] = pm[1:0] == 2'b11 ? {mtvec_base[`WK_PC_WIDTH-3:0],1'b0,mtvec_mode[0]}
                                            : {stvec_base[`WK_PC_WIDTH-3:0],1'b0,stvec_mode[0]};

assign cp0_ifu_rvbr[`WK_PC_WIDTH-1:0] = mrvbr_value[`WK_PC_WIDTH-1:0];

// Local ICG Enable
assign cp0_ifu_icg_en = local_icg_en[0];


//==========================================================
//                 Generate output to IDU
//==========================================================
// Float Point Status
//assign cp0_idu_fcr[5:0] = {fxcr_id, fcsr_value[4:0]};
assign cp0_idu_frm[2:0] = fcsr_value[7:5];
assign cp0_idu_fs[1:0]  = fs[1:0];
assign cp0_idu_vs[1:0]  = vs[1:0];

// Hint2 Control Signals
assign cp0_idu_zero_delay_move_disable = zero_move_dis;
assign cp0_idu_dlb_disable             = dlb_dis;
assign cp0_idu_rob_fold_disable        = rob_fold_dis;
assign cp0_idu_iq_bypass_disable       = iq_bypass_dis;
assign cp0_idu_srcv2_fwd_disable       = srcv2_fwd_dis;
assign cp0_idu_src2_fwd_disable        = src2_fwd_dis;
assign cp0_idu_strong_atomic           = strong_atomic;

// C-Sky Extension Enable
assign cp0_idu_cskyee   = cskyisaee;

// Local ICG Enable
assign cp0_idu_icg_en = local_icg_en[1];


//==========================================================
//              Generate output to IU
//==========================================================
// Exception Related Information
assign cp0_iu_ex3_efpc[`WK_PC_WIDTH-2:0]  = cp0_mret ? mepc_value[`WK_PC_WIDTH-1:1]
                                         : sepc_value[`WK_PC_WIDTH-1:1];
assign cp0_iu_ex3_efpc_vld    = cp0_mret || cp0_sret;

assign cp0_iu_div_entry_disable = div_entry_dis;
assign cp0_iu_div_entry_disable_clr = div_entry_dis && mhint2_local_en && !iui_regs_src0[11];

// Local ICG Enable
assign cp0_iu_icg_en                    = local_icg_en[2];
assign cp0_iu_vsetvli_pre_decd_disable  = vsetvli_dis;
assign cp0_ifu_vsetvli_pred_disable     = vsetvli_dis;
assign cp0_ifu_vsetvli_pred_mode        = vsetvli_pred;

//==========================================================
//                 Generate output to LSU
//==========================================================
// LSU function modules enable
assign cp0_lsu_dcache_en             = de;
assign cp0_lsu_dcache_pref_en        = dcache_pref_en;
assign cp0_lsu_dcache_pref_dist[1:0] = dcache_pref_dist[1:0];
assign cp0_lsu_l2_pref_en            = l2pld;
assign cp0_lsu_l2_pref_dist[1:0]     = l2_pref_dist[1:0];
assign cp0_lsu_l2_st_pref_en         = l2stpld;
assign cp0_lsu_ld_stride_cm_hw_pref_en = lsu_ld_stride_cm_hw_pref_en;     
assign cp0_lsu_va_based_hw_pref_en     = lsu_va_based_hw_pref_en; 
assign cp0_pf_aggr_range               = pf_aggr_range;
assign cp0_region_pf_dynamic           = region_pf_dynamic;
assign cp0_region_pf_conservative      = region_pf_conservative;
assign cp0_region_pf_very_conservative = region_pf_very_conservative;     
assign cp0_region_pf_most_conservative = region_pf_most_conservative;       


assign cp0_lsu_ecc_en            = ecc_en;
assign cp0_lsu_tag_ecc_inj       = inj_en && inj_ramid[2:0] == 3'b010;
assign cp0_lsu_data_ecc_inj      = inj_en && inj_ramid[2:0] == 3'b011;

`ifdef WK_PA_WIDTH_40
  assign cp0_lsu_tag_random0[`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0] = random_34_bit[33:0];
`endif
`ifdef WK_PA_WIDTH_48
  assign cp0_lsu_tag_random0[`WK_LS_DCACHE_SINGLE_LDTAG_WIDTH-1:0] = random_42_bit[41:0];
`endif

`ifdef WK_PA_WIDTH_40
assign cp0_lsu_tag_random1[`WK_LS_DCAHCE_SINGLE_MATE_TAG_WIDTH-1:0] = random_37_bit[36:0];
`endif
`ifdef WK_PA_WIDTH_48
assign cp0_lsu_tag_random1[`WK_LS_DCAHCE_SINGLE_MATE_TAG_WIDTH-1:0] = random_45_bit[44:0];
`endif

assign cp0_lsu_data_random[38:0] = random_39_bit[38:0];

// LSU related control flags
assign cp0_lsu_tvm                   = tvm;
assign cp0_lsu_ucme                  = ucme;
assign cp0_lsu_wa                    = wa;
assign cp0_lsu_mm                    = mm;
assign cp0_lsu_nsfe                  = nsfe;

// Hint functions
assign cp0_lsu_amr2                  = amr2;
assign cp0_lsu_amr                   = amr;
//assign cp0_lsu_exclusive_wb          = exclusive_wb;
assign cp0_lsu_wr_burst_dis          = wr_burst_dis;
assign cp0_lsu_cb_aclr_dis           = cb_aclr_dis;
assign cp0_lsu_da_fwd_dis            = da_fwd_dis;
assign cp0_lsu_pfu_mmu_dis           = pfu_mmu_dis;
assign cp0_lsu_fencei_broad_dis      = fencei_broad_dis;
assign cp0_lsu_fencerw_broad_dis     = fencerw_broad_dis;
assign cp0_lsu_tlb_broad_dis         = tlb_broad_dis;
assign cp0_lsu_corr_dis              = corr_dis;
assign cp0_lsu_ctc_flush_dis         = ctc_flush_dis;
assign cp0_lsu_delay_mnt_dis         = delay_mnt_dis;
assign cp0_lsu_delay_mnt_force       = delay_mnt_force;
assign cp0_lsu_delay_mnt_max[1:0]    = delay_mnt_max[1:0];

// Dcache Clear and Invalid
assign cp0_lsu_dcache_clr            = clr && sel[1];
assign cp0_lsu_dcache_inv            = dcache_inv && sel[1] || iui_regs_rst_inv_d;

// Dcache Read Cache Line Request
assign cp0_lsu_dcache_read_req         = cins_r && (cindex_rid_dcache_st_tag
                                         || cindex_rid_dcache_ld_tag
                                         || cindex_rid_dcache_data
                                         || cindex_rid_dcache_st_tag_ecc
                                         || cindex_rid_dcache_ld_tag_ecc
                                         || cindex_rid_dcache_data_ecc
                                         || cindex_rid_dtcm 
                                         || cindex_rid_dtcm_ecc
                                         );
assign cp0_lsu_dcache_read_type[3:0]   = cindex_rid[3:0];
assign cp0_lsu_dcache_read_way         = cindex_way[1:0];  //L1D 2->4way, LTL@20250327
assign cp0_lsu_dcache_read_index[16:0] = cindex_index[16:0];

// Local ICG Enable
assign cp0_lsu_icg_en                  = local_icg_en[3];

assign cp0_lsu_timeout_cnt[29:0]       = timeout_cnt[29:0];

//==========================================================
//                 Generate output to MMU
//==========================================================
// MMU Regs select and write information
assign cp0_mmu_wreg         = iui_regs_sel && mmu_regs_sel;
assign cp0_mmu_satp_sel     = iui_regs_sel && satp_local_en;
assign cp0_mmu_reg_num[2:0] = iui_regs_addr[2:0];
assign cp0_mmu_wdata[63:0]  = iui_regs_src0[63:0];

// MMU related control flags
assign cp0_mmu_mxr          = mxr;
assign cp0_mmu_sum          = sum;
assign cp0_mmu_mprv         = mprv;
assign cp0_mmu_mpp[1:0]     = mpp[1:0];
assign cp0_mmu_cskyee       = cskyisaee;
assign cp0_mmu_maee         = maee;
assign cp0_mmu_ptw_en       = !mhrd;

assign cp0_mmu_ecc_en            = ecc_en;
assign cp0_mmu_tag_ecc_inj       = inj_en && inj_ramid[2:0] == 3'b100;
assign cp0_mmu_data_ecc_inj      = inj_en && inj_ramid[2:0] == 3'b101;
assign cp0_mmu_tag_random[50:0]  = random_51_bit[50:0];
`ifdef WK_PA_WIDTH_40
assign cp0_mmu_data_random[43:0] = random_44_bit[43:0];
`endif
`ifdef WK_PA_WIDTH_48
assign cp0_mmu_data_random[51:0] = random_52_bit[51:0];
`endif 
// Local ICG Enable
assign cp0_mmu_icg_en = local_icg_en[4];

assign cp0_mmu_pa_equal_va = pa_equal_va;

`ifdef ADD_AIA  
//==========================================================
//                 Generate output to AIA by chenlili@20251203
//==========================================================
// AIA IMSIC Regs select and write information
assign cp0_aia_wreg         = iui_regs_sel && aia_regs_sel;
`endif 

//==========================================================
//                 Generate output to PMP
//==========================================================
// PMP Regs select and write information
assign cp0_pmp_wreg         = iui_regs_sel && pmp_regs_sel;
assign cp0_pmp_reg_num[11:0] = iui_regs_addr[11:0];
assign cp0_pmp_wdata[63:0]  = iui_regs_src0[63:0];

// MPRV Judgement
assign cp0_pmp_mprv         = mprv;
assign cp0_pmp_mpp[1:0]     = mpp[1:0];

// Local ICG Enable
assign cp0_pmp_icg_en       = local_icg_en[4];


//==========================================================
//                 Generate output to HPCP
//==========================================================
// HPCP Regs select and write information
//assign cp0_hpcp_wreg        = iui_regs_sel && hpm_regs_sel;
assign regs_iui_hpcp_regs_sel = hpm_regs_sel;
assign cp0_hpcp_index[11:0]   = iui_regs_addr[11:0];
assign cp0_hpcp_wdata[63:0]   = iui_regs_src0[63:0];

assign cp0_hpcp_pmdm          = pmdm;
assign cp0_hpcp_pmds          = pmds;
assign cp0_hpcp_pmdu          = pmdu;
assign cp0_hpcp_mcntwen[31:0] = mcntwen_reg[31:0];

// Local ICG Enable
assign cp0_hpcp_icg_en = local_icg_en[2];

//==========================================================
//                 Generate output to L2
//==========================================================
// L2 Regs select and write information
//assign cp0_biu_l2_wreg         = iui_regs_sel 
//                             && (mccr2_local_en || mcer2_local_en 
//                              || mrmr_local_en  || mrvbr_local_en
//                              || meicr2_local_en || mhint4_local_en);
//assign cp0_biu_l2_reg_sel[5:0] = {mhint4_local_en, meicr2_local_en, mrmr_local_en,
//                                  mrvbr_local_en, mcer2_local_en || scer2_local_en,
//                                  mccr2_local_en};
//assign cp0_biu_l2_wdata[63:0]  = iui_regs_src0[63:0];

// Mhint select and write information
//assign cp0_biu_l2_chr2_wen         = mhint2_local_en;
//assign cp0_biu_l2_chr2_wdata[`VL_WIDTH-1:0] = {iui_regs_src0[25:22], iui_regs_src0[8:5]};

// L2cache Read Cache Line Request
// &CombBeg; @4570
always @( ssbepa2_local_en
       or mteecfg_local_en
       or mhint4_local_en
       or mcer2_local_en
       or msbepa2_local_en
       or mccr2_local_en
       or msmpr_local_en
       or meicr2_local_en
       or scer2_local_en
       or mdbginfo2_local_en)
begin
case({mccr2_local_en, mhint4_local_en, mcer2_local_en || scer2_local_en,
      meicr2_local_en, msmpr_local_en, mteecfg_local_en, msbepa2_local_en || ssbepa2_local_en, mdbginfo2_local_en})
  8'b10000000: l2_regs_idx[3:0] = 4'b0000;
  8'b01000000: l2_regs_idx[3:0] = 4'b0001;
  8'b00100000: l2_regs_idx[3:0] = 4'b0010;
  8'b00010000: l2_regs_idx[3:0] = 4'b0011;
  8'b00001000: l2_regs_idx[3:0] = 4'b0100;
  8'b00000100: l2_regs_idx[3:0] = 4'b0101;
  8'b00000010: l2_regs_idx[3:0] = 4'b0110;
  8'b00000001: l2_regs_idx[3:0] = 4'b0111;
  default   : l2_regs_idx[3:0] = {4{1'b0}};
endcase
// &CombEnd; @4582
end
assign regs_iui_reg_idx[3:0] = l2_regs_idx[3:0];

assign regs_iui_dca_sel      = regs_dca_sel;
assign regs_iui_cindex_l2    = regs_cindex_sel_l2;
assign regs_dca_sel          = cins_ff && regs_cindex_sel_l2;
assign regs_cindex_sel_l2    = (cindex_rid_l2cache_tag
                                             || cindex_rid_l2cache_data
                                             || cindex_rid_l2cache_tag_ecc
                                             || cindex_rid_l2cache_data_ecc
                                             );
assign regs_iui_wdata[63:0] = {32'b0, cindex_rid[3:0], 3'b0, cindex_way[3:0], cindex_index[20:0]};

//assign cp0_biu_l2_read_req         = cins_ff && (cindex_rid_l2cache_tag
//                                             || cindex_rid_l2cache_data
//                                             || cindex_rid_l2cache_tag_ecc
//                                             || cindex_rid_l2cache_data_ecc
//                                             );
//assign cp0_biu_l2_read_tag         = cindex_rid_l2cache_tag;
//assign cp0_biu_l2_read_data        = cindex_rid_l2cache_data;
//assign cp0_biu_l2_read_tag_ecc     = cindex_rid_l2cache_tag_ecc;
//assign cp0_biu_l2_read_data_ecc    = cindex_rid_l2cache_data_ecc;
//assign cp0_biu_l2_read_way[3:0]    = cindex_way[3:0];
//assign cp0_biu_l2_read_index[20:0] = cindex_index[20:0];

// Local ICG Enable
assign cp0_biu_icg_en     = local_icg_en[5];
assign cp0_xx_core_icg_en = local_icg_en[8];

//==========================================================
//              Generate output to RTU
//==========================================================
// Single Retire Enable
assign cp0_rtu_srt_en                 = sre;

// Local ICG Enable
assign cp0_rtu_icg_en                 = local_icg_en[6];

//==========================================================
//              Generate output to VFPU
//==========================================================
// Local ICG Enable
assign cp0_vfpu_icg_en                = local_icg_en[7];

//==========================================================
//              Generate output to PAD
//==========================================================
assign cp0_pad_mstatus[63:0] = mstatus_value[63:0];

//==========================================================
//                  Risc-V Debug zdb Begin
//==========================================================
assign dtu_regs_sel = iui_regs_addr[11:4] == 8'h7A  //Trigger CSRs
                    | iui_regs_addr[11:4] == 8'h5A  //SCONTEXT
                    | iui_regs_addr[11:4] == 8'h7B  //Core Bebug CSRs
                    | iui_regs_addr[11:4] == 8'hFE  & iui_regs_addr[3:0] != 8'h3;  // Debug Extension, not no mdbginfo2
assign regs_iui_dtu_regs_sel = dtu_regs_sel;
assign regs_iui_mmu_regs_sel = mmu_regs_sel | pmp_regs_sel;

assign effective_mprv           = rtu_yy_xx_dbgon ? dtu_cp0_dcsr_mprven & mprv : mprv;
assign mprv_pm[1:0]             = effective_mprv ? mpp[1:0] : pm[1:0];
assign pm_info_flop_out_enable  = pm_out[1:0] != pm[1:0]
                                | mprv_pm_out[1:0] != mprv_pm[1:0] ;

always @(posedge forever_cpuclk or negedge cpurst_b)
begin
  if(~cpurst_b) begin
    pm_out[1:0]      <= 2'b11;
    mprv_pm_out[1:0] <= 2'b11;
  end
  else if(pm_info_flop_out_enable)begin
    pm_out[1:0]      <= pm[1:0];
    mprv_pm_out[1:0] <= mprv_pm[1:0];
  end
end

//satp
//========================================================================
//              Define of SATP
//=========================================================================
// the definition for STAP register is listed as follows
//=========================================================================
// |63  60 |59        44|43                28|27                  0|
// |Mode   |ASID        |Reserved            |PPN                  |
//=========================================================================
//=========================================================================
// |31  |30             22|21                 0|
// |Mode|ASID             | PPN                |
//=========================================================================


parameter PPN_WIDTH  = `WK_PA_WIDTH-12; //pph
parameter ASID_WIDTH = 16;             //Flags 

assign satp_mode_legal_sv39 = iui_regs_src0[63:60] == 4'b0000
                             | iui_regs_src0[63:60] == 4'b1000;

assign satp_mode_legal_sxl64 = satp_mode_legal_sv39
                             | iui_regs_src0[63:60] == 4'b1001;

always @(posedge regs_clk or negedge cpurst_b)
begin
  if (~cpurst_b)
    satp_mode[3:0]       <= {4{1'b0}};
  else if (satp_local_en & satp_mode_legal_sxl64)
    satp_mode[3:0]       <= iui_regs_src0[63:60];
end

//assign regs_iui_satp_bare = ~satp_mode[3] & ~satp_mode[0];

always @(posedge regs_clk or negedge cpurst_b)
begin
  if (~cpurst_b)
  begin
    satp_asid[ASID_WIDTH-1:0]       <= {ASID_WIDTH{1'b0}};
    satp_ppn[`WK_PPN_WIDTH-1:0]     <= {`WK_PPN_WIDTH{1'b0}};
  end
  else if (satp_local_en & satp_mode_legal_sxl64) 
  begin
    satp_asid[ASID_WIDTH-1:0]       <= iui_regs_src0[ASID_WIDTH+43:44];
    satp_ppn[`WK_PPN_WIDTH-1:0]     <= iui_regs_src0[`WK_PPN_WIDTH-1:0];
  end
end

assign satp_value[63:0] = {satp_mode[3:0], satp_asid[ASID_WIDTH-1:0], {8{1'b0}}, satp_ppn[`WK_PPN_WIDTH-1:0]};

assign cp0_dtu_priv_mode[1:0] = pm[1:0];

assign cp0_yy_mmu_en = (pm_out[1:0] != 2'b11)
                     & (satp_mode[3] | satp_mode[0]); //4'b0001,4'b1000,4'b1001

assign cp0_yy_sv39_en = (pm_out[1:0] != 2'b11)
                      & (satp_mode[3] & ~satp_mode[0]); //4'b1000

assign cp0_yy_sv48_en = (pm_out[1:0] != 2'b11)
                      & (satp_mode[3] & satp_mode[0]); //4'b1001

assign mzoneid_local_en  = iui_regs_ex2_write_sel & iui_regs_addr[11:0] == MZONEID;

always @(posedge regs_clk or negedge cpurst_b)
begin
  if (~cpurst_b) begin
   zoneid[3:0] <= 4'b0000;
  end
  else if (mzoneid_local_en) begin
   zoneid[3:0] <= iui_regs_src0[3:0];
  end
end

assign cp0_yy_zoneid[3:0] = zoneid[3:0];

assign mzoneid_value[63:0] = {{60{1'b0}}, zoneid[3:0]};
//==========================================================
//                 Generate output to DTU
//==========================================================
// DTU Regs select, read ,write information
assign cp0_dtu_sel = (iui_regs_ex1_read_sel | iui_regs_ex2_write_sel)
                      & dtu_regs_sel;
assign cp0_dtu_sel_gateclk     = iui_regs_fsm_busy & dtu_regs_sel;
assign cp0_dtu_rreg            = iui_regs_ex1_read_sel;
assign cp0_dtu_wreg            = iui_regs_wreg_for_dtu_hpcp;

assign cp0_dtu_addr[11:0]      = iui_regs_addr[11:0];
assign cp0_dtu_wdata[63:0]     = iui_regs_src0[63:0];

//local icg enable
assign cp0_dtu_icg_en = icg_module_en[9];

//pcfifo frz
assign cp0_dtu_pcfifo_frz = pcfifo_frz;

//satp for dtu
assign cp0_dtu_satp[63:0] = satp_value[63:0];

//m mode trap vld
assign cp0_dtu_mexpt_vld = rtu_yy_xx_expt_vld & ~mdeleg_vld;

assign xret_leave_m_mode = iui_regs_inst_mret & (mpp[1:0] != 2'b11)
                         | iui_regs_inst_sret & (pm[1:0] == 2'b11)
                         | rtu_cp0_exit_debug & (pm[1:0] == 2'b11) & (dtu_yy_dcsr_prv[1:0] != 2'b11);

assign icg_module_en_d[9:0] = {dtu_local_icg_en, local_icg_en[8:0]};
always @(posedge forever_cpuclk or negedge cpurst_b)
begin
  if(~cpurst_b) begin
   icg_module_en[9:0] <= 10'd0;
  end
  else if(icg_module_en[9:0] != icg_module_en_d[9:0]) begin
   icg_module_en[9:0] <= icg_module_en_d[9:0];
  end
end

//==========================================================
//                  Risc-V Debug zdb End
//==========================================================

//==========================================================
//                  AIA Support Begin
//==========================================================

genvar i;
// RISC-V AIA

// RISC-V AIA
// 5.3 Interrupt filtering and virtual interrupts for supervisor level
// When an interrupt is delegated by mideleg/midelegh, the writable bit in
// sie/sieh is an alias of the corresponding bit in mie/mieh; else it is an
// independent writable bit. As usual, bits that are not writable in
// sie/sieh must be read-only zeros.
generate
  for (i = 0; i < `WK_MAJOR_INT_NUM; i = i+1)
  begin
    if (|(`WK_MAJOR_SUPER_INT_MASK & (64'b1 << (i + `WK_MAJOR_INT_MIN))))
    begin
      always @(posedge forever_cpuclk or negedge cpurst_b)
      begin
        if (~cpurst_b)
          mie_reg[i] <= 1'b0;
        else if (mie_local_en)
          mie_reg[i] <= iui_regs_src0[i+`WK_MAJOR_INT_MIN];
        else if (sie_local_en)
          mie_reg[i] <= mideleg[i] ? iui_regs_src0[i+`WK_MAJOR_INT_MIN] : mie_reg[i];
      end
      assign sie[i] = mie_reg[i];
      assign mie[i] = sie[i];
    end
    else if (|(`WK_MAJOR_HYPER_INT_MASK & (64'b1 << (i + `WK_MAJOR_INT_MIN))))
    begin
      always @(*)
        mie_reg[i] = zero_reg;
      assign sie[i] = 1'b0;
      assign mie[i] = 1'b0;
    end
    else
    begin
      always @(*)
        mie_reg[i] = zero_reg;
      assign sie[i] = 1'b0;
      assign mie[i] = 1'b0;
    end
  end
endgenerate
//spacet vperl_on
// &Force("nonport","mie"); @410
// &Force("nonport","sie"); @411

// 5.3 Interrupt filtering and virtual interrupts for supervisor level
// A bit in sie/sieh is writable if and only if the corresponding bit is
// set in either mideleg/midelegh or mvien/mvienh. When an interrupt is
// delegated by mideleg/midelegh, the writable bit in sie/sieh is an alias
// of the corresponding bit in mie/mieh; else it is an independent
// writable bit. As usual, bits that are not writable in sie/sieh must be
// read-only zeros.
generate
  for (i = 0; i < `WK_MAJOR_INT_NUM; i = i+1)
  begin
    if (|(`WK_MAJOR_VIRT_INT_MASK & (64'b1 << (i + `WK_MAJOR_INT_MIN))))
    begin
      always @(posedge forever_cpuclk or negedge cpurst_b)
      begin
        if (~cpurst_b)
          mvie_reg[i] <= 1'b0;
        else if (sie_local_en)
          mvie_reg[i] <= mvien[i] & iui_regs_src0[i+`WK_MAJOR_INT_MIN];
      end
      assign mvie[i] = mvien[i] & mvie_reg[i];
    end
    else
    begin
      always @(*)
        mvie_reg[i] = zero_reg;
      assign mvie[i] = 1'b0;
    end
  end
endgenerate
//spacet vperl_on
// &Force("nonport","mvie"); @1366

generate
  for (i = 0; i < `WK_MAJOR_INT_NUM; i = i+1)
  begin
    // RISC-V AIA
    // 5.2 Interrupts at machine level
    // For whichever standard local interrupts are implemented, the
    // corresponding bits in mideleg/midelegh (if those CSRs exist because
    // supervisor mode is implemented) must each either be writable or be
    // hardwired to zero.
    if (|(`WK_MAJOR_SUPER_INT_MASK & (64'b1 << (i + `WK_MAJOR_INT_MIN))))
    begin
      always @(posedge forever_cpuclk or negedge cpurst_b)
      begin
        if (~cpurst_b)
          mideleg_reg[i] <= 1'b0;
        else if (mideleg_local_en)
          mideleg_reg[i] <= iui_regs_src0[i+`WK_MAJOR_INT_MIN];
      end
      assign mideleg[i] = mideleg_reg[i];
    end
    else if (|(`WK_MAJOR_HYPER_INT_MASK & (64'b1 << (i + `WK_MAJOR_INT_MIN))))
    begin
      always @(*)
        mideleg_reg[i] = zero_reg;
      // RISC-V Privileged
      // 8.4.2 Machine Interrupt Delegation Register
      // VS-level interrupts and guest external interrupts are always
      // delegated past M-mode to HS-mode.
      assign mideleg[i] = cp0_yy_hyper;
    end
    else
    begin
      always @(*)
        mideleg_reg[i] = zero_reg;
        assign mideleg[i] = 1'b0;
    end
  end
endgenerate

// Collect other major interrupt source here.
assign aia_m_ints[`WK_MAJOR_INT_NUM-1:0] = { 40'b0,               
                                             ecc_int_vld,       //cp0_aia_bus_err_int 23
                                             5'b0,              // 18-22
                                             1'b0,              // Debug/trace int 17
                                             3'b0,              // 14-16
                                             hpcp_cp0_int_vld   // hpcp_aia_int 13
                                           };

// RISC-V Privileged
// 3.1.9 Machine Interrupt Registers (mip and mie)
// Each individual bit in register mip may be writable or may be
// read-only. When bit i in mip is writable, a pending interrupt i can be
// cleared by writing 0 to this bit. If interrupt i can become pending but
// bit i in mip is read-only, the implementation must provide some other
// mechanism for clearing the pending interrupt.
// AN:
// MIP is W0C, thus CP0 should take the responsibility of converting csrrc
// into all-ones but zero for the clearing bit.
// For major interrupts, they are supposed to be level triggered
// (read-only) or edge triggered (writable of W0C).
generate
  for (i = 0; i < `WK_MAJOR_INT_NUM; i = i+1)
  begin
    if (|(`WK_MAJOR_SUPER_INT_MASK & (64'b1 << (i + `WK_MAJOR_INT_MIN))))
    begin
      always @(posedge forever_cpuclk or negedge cpurst_b)
      begin
        if (~cpurst_b)
          mvip_reg[i] <= 1'b0;
        else if (mip_local_en)
          mvip_reg[i] <= iui_regs_src0[i+`WK_MAJOR_INT_MIN];
        else if (sip_local_en)
          mvip_reg[i] <= mideleg[i] ? iui_regs_src0[i+`WK_MAJOR_INT_MIN] : mvip_reg[i];
        else if (mvip_local_en)
          mvip_reg[i] <=  ~mvien[i] ? iui_regs_src0[i+`WK_MAJOR_INT_MIN] : mvip_reg[i];
      end
      assign mvip[i] = mvip_reg[i];
      assign sip[i] = mvip[i] | aia_m_ints[i];
      assign mip[i] = sip[i];
    end
    else if (|(`WK_MAJOR_HYPER_INT_MASK & (64'b1 << (i + `WK_MAJOR_INT_MIN))))
    begin
      always @(*)
        mvip_reg[i] = zero_reg;
        assign mvip[i] = 1'b0;
        assign sip[i] = 1'b0;
        assign mip[i] = 1'b0;
    end
    else
    begin
      always @(*)
        mvip_reg[i] = zero_reg;
        assign mvip[i] = 1'b0;
        assign sip[i] = 1'b0;
        assign mip[i] = 1'b0;
    end
  end
endgenerate
//spacet vperl_on
// &Force("nonport","mvip"); @647
// &Force("nonport","mip"); @648
// &Force("nonport","sip"); @649

//spacet vperl_off
// RISC-V AIA
// 5.3 Interrupt filtering and virtual interrupts for supervisor level
// If such a bit (13-63) in mvien/mvienh is read-only zero (preventing
// the virtual interrupt from being enabled), the same bit should be
// read-only zero in mvip/mviph.
// AN:
// The design uses WK_MAJOR_VIRT_INT_MASK (virtualizable major interrupts)
// to control whether a major interrupt can be enabled as virtual
// interrupt (writable) or read-only zero.
generate
  for (i = 0; i < `WK_MAJOR_INT_NUM; i = i+1)
  begin
    if (|(`WK_MAJOR_VIRT_INT_MASK & (64'b1 << (i + `WK_MAJOR_INT_MIN))))
    begin
      always @(posedge forever_cpuclk or negedge cpurst_b)
      begin
        if (~cpurst_b)
          mvipn_reg[i] <= 1'b0;
        else if (mvip_local_en)
          mvipn_reg[i] <= mvien[i] & iui_regs_src0[i+`WK_MAJOR_INT_MIN];
        else if (sip_local_en)
          mvipn_reg[i] <= mvien[i] & iui_regs_src0[i+`WK_MAJOR_INT_MIN];
      end
      assign mvipn[i] = mvien[i] & mvipn_reg[i];
    end
    else
    begin
      always @(*)
        mvipn_reg[i] = zero_reg;
      assign mvipn[i] = 1'b0;
    end
  end
endgenerate
//spacet vperl_on
// &Force("nonport","mvipn"); @1453

//==========================================================
//               Define the MVIEN register
//  Machine Virtual Interrupt Enable Register
//  64-bit Machine Mode Read/Write
//  AIA only controls major interrupts 1, 9, and 13-63.
//==========================================================
// RISC-V AIA
// 5.3 Interrupt filtering and virtual interrupts for supervisor level
// The bits of mvien for supervisor software interrupts (code 1) and
// supervisor external interrupts (code 9) are each either writable or
// read-only zero; they cannot be read-only ones.
// It is strongly recommended that bit 9 of mvien be writable.
// Furthermore, if bit 1 (SSIP) of mip can be set automatically by an
// interrupt controller and not just by explicit writes to mip or sip, it
// is strongly recommended that bit 1 of mvien also be writable.
// AN:
// Since it's strongly recommended that the bit 9 and bit 1 be writable,
// the design choose to make them writable unconditionally for simplicity.
always @(posedge forever_cpuclk or negedge cpurst_b)
begin
  if (~cpurst_b)
  begin
    mvseien <= 1'b0;
    mvssien <= 1'b0;
  end
  else if (mvien_local_en)
  begin
    mvseien <= iui_regs_src0[9];
    mvssien <= iui_regs_src0[1];
  end
end
// RISC-V AIA
// 5.3 Interrupt filtering and virtual interrupts for supervisor level
// When STIP is not writable in mip (such as when menvcfg.STCE = 1), bit
// 5 of mvip is read-only zero.
// AN:
// The svti has a special handling to accommodate to the original SBI's
// MTI selective delegation usage model:
//   mti --clr mtie, set stip--> sti
// Thus, it seems AIA only allows original interrupt filtering working for
// mip.sti.
assign mvstien = 1'b0;

// RISC-V AIA
// 5.3 Interrupt filtering and virtual interrupts for supervisor level
// The other bits of mvien for interrupts 0-12 are reserved and must be
// read-only zeros.
//spacet vperl_off
// RISC-V AIA
// 5.3 Interrupt filtering and virtual interrupts for supervisor level
// For interrupt numbers 13-63, implementations may freely choose which
// bits of mvien/mvienh are writable and which bits are read-only zero or
// one.
// AN:
// The design uses WK_MAJOR_VIRT_INT_MASK (virtualizable major interrupts)
// to control whether a major interrupt can be enabled as virtual
// interrupt (writable) or read-only zero.
generate
  for (i = 0; i < `WK_MAJOR_INT_NUM; i = i+1)
  begin
    if (|(`WK_MAJOR_VIRT_INT_MASK & (64'b1 << (i + `WK_MAJOR_INT_MIN))))
    begin
      if (|(`WK_MAJOR_HYPER_INT_MASK & (64'b1 << (i + `WK_MAJOR_INT_MIN))))
      begin
        always @(posedge forever_cpuclk or negedge cpurst_b)
        begin
          if (~cpurst_b)
            mvien_reg[i] <= 1'b0;
          else if (mvien_local_en)
            mvien_reg[i] <= iui_regs_src0[i+`WK_MAJOR_INT_MIN];
        end
        assign mvien[i] = mvien_reg[i];
      end
      else if (|(`WK_MAJOR_SUPER_INT_MASK & (64'b1 << (i + `WK_MAJOR_INT_MIN))))
      begin
        always @(posedge forever_cpuclk or negedge cpurst_b)
        begin
          if (~cpurst_b)
            mvien_reg[i] <= 1'b0;
          else if (mvien_local_en)
            mvien_reg[i] <= iui_regs_src0[i+`WK_MAJOR_INT_MIN];
        end
        assign mvien[i] = mvien_reg[i];
      end
      else
      begin
        always @(*)
          mvien_reg[i] = zero_reg;
        assign mvien[i] = 1'b0;
      end
    end
    else
    begin
      always @(*)
        mvien_reg[i] = zero_reg;
      assign mvien[i] = 1'b0;
    end
  end
endgenerate
//spacet vperl_on


// &Force("nonport","mvien"); @285

assign mvien_value[63:0] = {mvien[50:0],
                            1'b0,
                            2'b0, mvseien, 1'b0,
                            2'b0, mvstien, 1'b0,
                            2'b0, mvssien, 1'b0};

always @(posedge forever_cpuclk or negedge cpurst_b)
begin
  if (~cpurst_b)
  begin
    mvseip <= 1'b0;
  end
  else if (mip_local_en)
  begin
    mvseip <= mvseien ? mvseip : iui_regs_src0[9];
  end
  else if (mvip_local_en)
  begin
    mvseip <=  ~mvseien ? iui_regs_src0[9] : mvseip;
  end
end

always @(posedge forever_cpuclk or negedge cpurst_b)
begin
  if (~cpurst_b)
    mvstip <= 1'b0;
  else
  begin
    if (mip_local_en)
      mvstip <= iui_regs_src0[5];
    else if (sip_local_en)
      mvstip <= mvstip;
    else if (mvip_local_en)
      mvstip <=  ~mvstien ? iui_regs_src0[5] : mvstip;
  end
end

always @(posedge forever_cpuclk or negedge cpurst_b)
begin
  if (~cpurst_b)
  begin
    mvssip <= 1'b0;
  end
  else if (biu_cp0_ss_int)
  begin
    mvssip <= biu_cp0_ss_int;
  end
  else if (mip_local_en)
  begin
    mvssip <= iui_regs_src0[1];
  end
  else if (sip_local_en)
  begin
    mvssip <= ssie_deleg ? iui_regs_src0[1] : mvssip;
  end
  else if (mvip_local_en)
  begin
    mvssip <=  ~mvssien ? iui_regs_src0[1] : mvssip;
  end
end

always @(posedge forever_cpuclk or negedge cpurst_b)
begin
  if (~cpurst_b)
  begin
    mvseipn <= 1'b0;
    mvssipn <= 1'b0;
  end
  else if (mvip_local_en)
  begin
    mvseipn <= mvseien & iui_regs_src0[9];
    mvssipn <= mvssien & iui_regs_src0[1];
  end
  else if (sip_local_en)
  begin
    mvseipn <= mvseien & iui_regs_src0[9];
    mvssipn <= mvssien & iui_regs_src0[1];
  end
end
// AN
// And since mvstien is wired to 0, thus mvstipn is read-only. Which means
// there is no virtual interrupt working on mvip.sti.
assign mvstipn = 1'b0;

//==========================================================
//               Define the MVIP register
//  Machine Virtual Interrupt Pending Register
//  64-bit Machine Mode Read/Write
//  AIA only controls major interrupts 1, 9 and 13-63.
//==========================================================
assign mvip_value[63:0] = {( mvien[50:0] & mvipn[50:0]) |
                           (~mvien[50:0] &  mvip[50:0]),
                           1'b0,
                           2'b0, mvseien ? mvseipn : mvseip, 1'b0,
                           2'b0, mvstien ? mvstipn : mvstip, 1'b0,
                           2'b0, mvssien ? mvssipn : mvssip, 1'b0};

// RISC-V Privileged
// 8.4.2 Machine Interrupt Delegation Register (mideleg)
// For bits of mideleg that are zero, the corresponding bits in hideleg,
// hip, and hie are read-only zeros.
// RISC-V AIA
// 5.3 Interrupt filtering and virtual interrupts for supervisor level
// When the hypervisor extension is implemented, if a bit is zero in the
// same position in both mideleg/midelegh and mvien/mvienh, then that bit
// is read-only zero in hideleg/hidelegh (in addition to being read-only
// zero in sip/siph, sie/sieh, hip, and hie).
// +---------+-------+------+-----+
// | mideleg | mvien | sip  | sie |
// +---------+-------+------+-----+
// | 0       | 0     | RO0  | RO0 |
// +---------+-------+------+-----+
// | 0       | 1     | mvip | RW  |
// +---------+-------+------+-----+
// | 1       | -     | mip  | mie |
// +---------+-------+------+-----+
// Table 5.4 The effects of mideleg and mvien on sip and sie (except for
// the hypervisor extension's VS-level interrupts, which appear in hip and
// hie instead of sip and sie).

assign mtopi_sel[7:0] = { mcie && mip_value[23] && !mideleg_value[23],
                          meie && mip_value[11],
                          msie && mip_value[3],
                          mtie && mip_value[7],
                          seie && mip_value[9]  && !mideleg_value[9],
                          ssie && mip_value[1]  && !mideleg_value[1],
                          stie && mip_value[5]  && !mideleg_value[5],
                          moie && mip_value[13] && !mideleg_value[13]};

assign stopi_sel[4:0] = { mcie && sip_value[23],
                          seie && sip_value[9],
                          ssie && sip_value[1],
                          stie && sip_value[5],
                          moie && sip_value[13]};

always @(mtopi_sel[7:0]) begin
casez(mtopi_sel[7:0])
  8'b1???????   : mtopi_int_vec[11:0] = 12'd23; // bus_err
  8'b01??????   : mtopi_int_vec[11:0] = 12'd11; // meip
  8'b001?????   : mtopi_int_vec[11:0] = 12'd3;  // msip
  8'b0001????   : mtopi_int_vec[11:0] = 12'd7;  // mtip
  8'b00001???   : mtopi_int_vec[11:0] = 12'd9;  // seip
  8'b000001??   : mtopi_int_vec[11:0] = 12'd1;  // ssip
  8'b0000001?   : mtopi_int_vec[11:0] = 12'd5;  // stip
  8'b00000001   : mtopi_int_vec[11:0] = 12'd13; // hpcp_int
  default       : mtopi_int_vec[11:0] = {12{1'b0}};
endcase
end

always @(stopi_sel[4:0]) begin
casez(stopi_sel[4:0])
  5'b1????      : stopi_int_vec[11:0] = 12'd23; // bus_err
  5'b01???      : stopi_int_vec[11:0] = 12'd9;  // seip
  5'b001??      : stopi_int_vec[11:0] = 12'd1;  // ssip
  5'b0001?      : stopi_int_vec[11:0] = 12'd5;  // stip
  5'b00001      : stopi_int_vec[11:0] = 12'd13; // hpcp_int
  default       : stopi_int_vec[11:0] = {12{1'b0}};
endcase
end

assign mtopi_value[63:0] = {36'b0, mtopi_int_vec[11:0], 15'b0, |(mtopi_int_vec[11:0])};
assign stopi_value[63:0] = {36'b0, stopi_int_vec[11:0], 15'b0, |(stopi_int_vec[11:0])};

//==========================================================
// select read data from aia regs in cp0
//==========================================================
always @( mvien_value[63:0]
       or mvip_value[63:0]
       or mtopi_value[63:0]
       or stopi_value[63:0]
       or iui_regs_addr[11:0])
begin
  case(iui_regs_addr[11:0])
    MVIEN         : aia_regs_data[63:0] = mvien_value[63:0];
    MVIP          : aia_regs_data[63:0] = mvip_value[63:0];
    MTOPI         : aia_regs_data[63:0] = mtopi_value[63:0];
    STOPI         : aia_regs_data[63:0] = stopi_value[63:0];
    default       : aia_regs_data[63:0] = 64'b0;
  endcase
// &CombEnd; @228
end       
//==========================================================
//                  AIA Support End
//==========================================================
// &ModuleEnd; @4642
endmodule


