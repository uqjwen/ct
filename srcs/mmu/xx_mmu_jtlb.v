//-----------------------------------------------------------------------------
// File          : xx_mmu_jtlb.v
// Created       : 2024/10/01 (by Li Shuo)
// Last modified : 2024/10/01 (by Li Shuo)
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


// $Id: xx_mmu_jtlb.vp,v 1.61.12.1 2022/12/01 01:47:22 haozy Exp $
// *****************************************************************************

// &ModuleBeg; @26
module xx_mmu_jtlb(
  arb_jtlb_acc_type,
  arb_jtlb_asid,
  arb_jtlb_bank_sel,
  arb_jtlb_cmp_with_va,
  arb_jtlb_data_din,
  arb_jtlb_fifo_din,
  arb_jtlb_fifo_write,
  arb_jtlb_idx,
  arb_jtlb_pfu_grant,
  arb_jtlb_req,
  arb_jtlb_tag_din,
  arb_jtlb_vpn,
  arb_jtlb_write,
  arb_jtlb_ptr,        // wjh@pfu
  cp0_mmu_data_ecc_inj,
  cp0_mmu_data_random,
  cp0_mmu_ecc_en,
  cp0_mmu_icg_en,
  cp0_mmu_maee,
  cp0_mmu_mxr,
  cp0_mmu_ptw_en,
  cp0_mmu_sum,
  cp0_mmu_tag_ecc_inj,
  cp0_mmu_tag_random,
  cpurst_b,
  dutlb_xx_mmu_off,
  forever_cpuclk,
  jtlb_arb_asid,
  jtlb_arb_cmp_va,
  jtlb_arb_par_clr,
  jtlb_arb_pfu_cmplt,
  jtlb_arb_pfu_vpn,
  jtlb_arb_sel_1g,
  jtlb_arb_sel_2m,
  jtlb_arb_sel_4k,
  jtlb_arb_tc_miss,
  jtlb_arb_type,
  jtlb_arb_vpn,
  jtlb_dutlb_acc_err,
  jtlb_dutlb_pgflt,
  jtlb_dutlb_ref_cmplt,
  jtlb_dutlb_ref_pavld,
  jtlb_iutlb_acc_err,
  jtlb_iutlb_pgflt,
  jtlb_iutlb_ref_cmplt,
  jtlb_iutlb_ref_pavld,
  jtlb_ptw_asid,
  jtlb_ptw_req,
  jtlb_ptw_type,
  jtlb_ptw_vpn,
  jtlb_ptw_ptr,       // wjh@pfu
  jtlb_ptw_has_cmplt, // wjh@pfu
  jtlb_arb_ptr,       // wjh@pfu
  jtlb_pfu_cmplt,     // wjh@pfu
  jtlb_pfu_acc_fault, // wjh@pfu
  jtlb_pfu_pa,        // wjh@pfu
  jtlb_pfu_sec,       // wjh@pfu
  jtlb_pfu_share,     // wjh@pfu
  jtlb_pfu_ptr,       // wjh@pfu
  jtlb_regs_hit,
  jtlb_regs_hit_mult,
  jtlb_regs_tlbp_hit_index,
  jtlb_tlboper_asid_hit,
  jtlb_tlboper_cmplt,
  jtlb_tlboper_fifo,
  jtlb_tlboper_read_idle,
  jtlb_tlboper_sel,
  jtlb_tlboper_va_hit,
  jtlb_tlbr_asid,
  jtlb_tlbr_flg,
  jtlb_tlbr_g,
  jtlb_tlbr_pgs,
  jtlb_tlbr_ppn,
  jtlb_tlbr_vpn,
  jtlb_top_cur_st,
  jtlb_top_utlb_pavld,
  jtlb_utlb_ref_flg,
  jtlb_utlb_ref_pgs,
  jtlb_utlb_ref_ppn,
  jtlb_utlb_ref_vpn,
  jtlb_xx_fifo,
  jtlb_xx_tc_read,
  lsu_mmu_va2,
  lsu_mmu_va2_priv_mode,
  mmu_cp0_data_inj_cmplt,
  mmu_cp0_ecc_idx,
  mmu_cp0_ecc_ramid,
  mmu_cp0_ecc_vld,
  mmu_cp0_ecc_way,
  mmu_cp0_tag_inj_cmplt,
  mmu_sysmap_pa4,
  pad_yy_icg_scan_en,
  pmp_mmu_flg4,
  ptw_arb_vpn,
  ptw_jtlb_dmiss,
  ptw_jtlb_imiss,
  ptw_jtlb_pmiss,
  ptw_jtlb_ref_acc_err,
  ptw_jtlb_ref_cmplt,
  ptw_jtlb_ref_data_vld,
  ptw_jtlb_ref_flg,
  ptw_jtlb_ref_pgflt,
  ptw_jtlb_ref_pgs,
  ptw_jtlb_ref_ppn,
  ptw_jtlb_ref_ptr, // wjh@pfu
  regs_mmu_en,
  sysmap_mmu_flg4,
  tlboper_jtlb_asid,
  tlboper_jtlb_asid_sel,
  tlboper_jtlb_cmp_noasid,
  tlboper_jtlb_inv_asid,
  tlboper_jtlb_tlbwr_on,
  tlboper_xx_pgs,
  tlboper_xx_pgs_en,
  mmu_sv48_en,
  pad_sram_RME, 
  pad_sram_RM  
);

// &Ports; @27
input                     pad_sram_RME;
input   [3   :0]          pad_sram_RM;
input   [2  :0]  arb_jtlb_acc_type;       
input   [15 :0]  arb_jtlb_asid;           
input   [3  :0]  arb_jtlb_bank_sel;       
input            arb_jtlb_cmp_with_va;    
input   [`MMU_DATA_WIDTH-1 :0]  arb_jtlb_data_din;       
input   [3  :0]  arb_jtlb_fifo_din;       
input            arb_jtlb_fifo_write;     
input   [8  :0]  arb_jtlb_idx;            
input            arb_jtlb_pfu_grant;      
input            arb_jtlb_req;            
input   [`MMU_TAG_WIDTH-1 :0]  arb_jtlb_tag_din;        
input   [`WK_VPN_WIDTH-1 :0]  arb_jtlb_vpn;            
input            arb_jtlb_write;          
input   [2:0]    arb_jtlb_ptr; // wjh@pfu
input            cp0_mmu_data_ecc_inj;    
input   [`MMU_DATA_WIDTH+1 :0]  cp0_mmu_data_random;     
input            cp0_mmu_ecc_en;          
input            cp0_mmu_icg_en;          
input            cp0_mmu_maee;            
input            cp0_mmu_mxr;             
input            cp0_mmu_ptw_en;          
input            cp0_mmu_sum;             
input            cp0_mmu_tag_ecc_inj;     
input   [59 :0]  cp0_mmu_tag_random;      
input            cpurst_b;                
input            dutlb_xx_mmu_off;        
input            forever_cpuclk;          
input   [`WK_PPN_WIDTH-1 :0]  lsu_mmu_va2;             
input   [1  :0]  lsu_mmu_va2_priv_mode;   
input            pad_yy_icg_scan_en;      
input   [3  :0]  pmp_mmu_flg4;            
input   [`WK_VPN_WIDTH-1 :0]  ptw_arb_vpn;             
input            ptw_jtlb_dmiss;          
input            ptw_jtlb_imiss;          
input            ptw_jtlb_pmiss;          
input            ptw_jtlb_ref_acc_err;    
input            ptw_jtlb_ref_cmplt;      
input            ptw_jtlb_ref_data_vld;   
input   [13 :0]  ptw_jtlb_ref_flg;        
input            ptw_jtlb_ref_pgflt;      
input   [2  :0]  ptw_jtlb_ref_pgs;        
input   [`WK_PPN_WIDTH-1 :0]  ptw_jtlb_ref_ppn;        
input   [2:0]    ptw_jtlb_ref_ptr; // wjh@pfu
input            regs_mmu_en;             
input   [4  :0]  sysmap_mmu_flg4;         
input   [15 :0]  tlboper_jtlb_asid;       
input            tlboper_jtlb_asid_sel;   
input            tlboper_jtlb_cmp_noasid; 
input   [15 :0]  tlboper_jtlb_inv_asid;   
input            tlboper_jtlb_tlbwr_on;   
input   [2  :0]  tlboper_xx_pgs;          
input            tlboper_xx_pgs_en;
input            mmu_sv48_en;       
output  [15 :0]  jtlb_arb_asid;           
output           jtlb_arb_cmp_va;         
output           jtlb_arb_par_clr;        
output           jtlb_arb_pfu_cmplt;      
output  [`WK_VPN_WIDTH-1 :0]  jtlb_arb_pfu_vpn;        
output           jtlb_arb_sel_1g;         
output           jtlb_arb_sel_2m;         
output           jtlb_arb_sel_4k;         
output           jtlb_arb_tc_miss;        
output  [2  :0]  jtlb_arb_type;           
output  [`WK_VPN_WIDTH-1 :0]  jtlb_arb_vpn;            
output           jtlb_dutlb_acc_err;      
output           jtlb_dutlb_pgflt;        
output           jtlb_dutlb_ref_cmplt;    
output           jtlb_dutlb_ref_pavld;    
output           jtlb_iutlb_acc_err;      
output           jtlb_iutlb_pgflt;        
output           jtlb_iutlb_ref_cmplt;    
output           jtlb_iutlb_ref_pavld;    
output  [15 :0]  jtlb_ptw_asid;           
output           jtlb_ptw_req;            
output  [2  :0]  jtlb_ptw_type;           
output  [`WK_VPN_WIDTH-1 :0]  jtlb_ptw_vpn;            
output  [2:0]    jtlb_ptw_ptr;       // wjh@pfu
output           jtlb_ptw_has_cmplt; // wjh@pfu
output  [2:0]    jtlb_arb_ptr;       // wjh@pfu
output           jtlb_pfu_cmplt;     // wjh@pfu
output           jtlb_pfu_acc_fault; // wjh@pfu
output [`WK_PPN_WIDTH-1:0]    jtlb_pfu_pa;        // wjh@pfu
output           jtlb_pfu_sec;       // wjh@pfu
output           jtlb_pfu_share;     // wjh@pfu
output [2:0]     jtlb_pfu_ptr;       // wjh@pfu
output           jtlb_regs_hit;           
output           jtlb_regs_hit_mult;      
output  [10 :0]  jtlb_regs_tlbp_hit_index; 
output           jtlb_tlboper_asid_hit;   
output           jtlb_tlboper_cmplt;      
output  [3  :0]  jtlb_tlboper_fifo;       
output           jtlb_tlboper_read_idle;  
output  [3  :0]  jtlb_tlboper_sel;        
output           jtlb_tlboper_va_hit;     
output  [15 :0]  jtlb_tlbr_asid;          
output  [13 :0]  jtlb_tlbr_flg;           
output           jtlb_tlbr_g;             
output  [2  :0]  jtlb_tlbr_pgs;           
output  [`WK_PPN_WIDTH-1 :0]  jtlb_tlbr_ppn;           
output  [`WK_VPN_WIDTH-1 :0]  jtlb_tlbr_vpn;           
output  [1  :0]  jtlb_top_cur_st;         
output           jtlb_top_utlb_pavld;     
output  [13 :0]  jtlb_utlb_ref_flg;       
output  [2  :0]  jtlb_utlb_ref_pgs;       
output  [`WK_PPN_WIDTH-1 :0]  jtlb_utlb_ref_ppn;       
output  [`WK_VPN_WIDTH-1 :0]  jtlb_utlb_ref_vpn;       
output  [11 :0]  jtlb_xx_fifo;            
output           jtlb_xx_tc_read;         
output           mmu_cp0_data_inj_cmplt;  
output  [8  :0]  mmu_cp0_ecc_idx;         
output  [2  :0]  mmu_cp0_ecc_ramid;       
output           mmu_cp0_ecc_vld;         
output  [1  :0]  mmu_cp0_ecc_way;         
output           mmu_cp0_tag_inj_cmplt;                         
output  [`WK_PPN_WIDTH-1 :0]  mmu_sysmap_pa4;          
wire             pad_sram_RME;
wire    [3   :0] pad_sram_RM;
// &Regs; @28
reg     [1  :0]  fail_way;                
reg     [1  :0]  pfu_cur_st;              
reg     [1  :0]  pfu_nxt_st;              
reg     [`WK_PPN_WIDTH-1 :0]  pfu_pa_buf;              
reg     [2  :0]  pfu_priv_mode;           
reg              pfu_sec_buf;             
reg              pfu_share_buf;           
reg     [2  :0]  read_cur_st;             
reg     [2  :0]  read_nxt_st;             
reg     [2  :0]  ta_acc_type;             
reg     [15 :0]  ta_asid;                 
reg              ta_cmp_va;               
reg     [11 :0]  ta_jtlb_fifo_upd;        
reg              ta_vld;                  
reg     [`WK_VPN_WIDTH-1 :0]  ta_vpn;                  
reg     [3  :0]  ta_way_sel;              
reg              ta_wen;                  
reg     [2:0]    ta_ptr; // wjh@pfu
reg     [2  :0]  tc_acc_type;             
reg     [15 :0]  tc_asid;                 
reg              tc_cmp_va;               
reg     [11 :0]  tc_jtlb_fifo;            
reg              tc_vld;                  
reg     [`WK_VPN_WIDTH-1 :0]  tc_vpn;                  
reg     [15 :0]  tc_way0_asid;            
reg              tc_way0_data_par_fail;   
reg     [13 :0]  tc_way0_flg;             
reg              tc_way0_g;               
reg              tc_way0_hit_kid0;        
reg              tc_way0_hit_kid1;        
reg              tc_way0_hit_kid2;        
reg              tc_way0_hit_kid3;        
reg              tc_way0_hit_kid4;        
reg              tc_way0_hit_kid5;      
reg              tc_way0_hit_kid6;   
reg     [2  :0]  tc_way0_pgs;             
reg     [`WK_PPN_WIDTH-1 :0]  tc_way0_ppn;             
reg              tc_way0_tag_par_fail;    
reg     [`WK_VPN_WIDTH-1 :0]  tc_way0_vpn;             
reg     [15 :0]  tc_way1_asid;            
reg              tc_way1_data_par_fail;   
reg     [13 :0]  tc_way1_flg;             
reg              tc_way1_g;               
reg              tc_way1_hit_kid0;        
reg              tc_way1_hit_kid1;        
reg              tc_way1_hit_kid2;        
reg              tc_way1_hit_kid3;        
reg              tc_way1_hit_kid4;        
reg              tc_way1_hit_kid5; 
reg              tc_way1_hit_kid6;       
reg     [2  :0]  tc_way1_pgs;             
reg     [`WK_PPN_WIDTH-1 :0]  tc_way1_ppn;             
reg              tc_way1_tag_par_fail;    
reg     [`WK_VPN_WIDTH-1 :0]  tc_way1_vpn;             
reg     [15 :0]  tc_way2_asid;            
reg              tc_way2_data_par_fail;   
reg     [13 :0]  tc_way2_flg;             
reg              tc_way2_g;               
reg              tc_way2_hit_kid0;        
reg              tc_way2_hit_kid1;        
reg              tc_way2_hit_kid2;        
reg              tc_way2_hit_kid3;        
reg              tc_way2_hit_kid4;        
reg              tc_way2_hit_kid5; 
reg              tc_way2_hit_kid6;       
reg     [2  :0]  tc_way2_pgs;             
reg     [`WK_PPN_WIDTH-1 :0]  tc_way2_ppn;             
reg              tc_way2_tag_par_fail;    
reg     [`WK_VPN_WIDTH-1 :0]  tc_way2_vpn;             
reg     [15 :0]  tc_way3_asid;            
reg              tc_way3_data_par_fail;   
reg     [13 :0]  tc_way3_flg;             
reg              tc_way3_g;               
reg              tc_way3_hit_kid0;        
reg              tc_way3_hit_kid1;        
reg              tc_way3_hit_kid2;        
reg              tc_way3_hit_kid3;        
reg              tc_way3_hit_kid4;        
reg              tc_way3_hit_kid5; 
reg              tc_way3_hit_kid6;        
reg     [2  :0]  tc_way3_pgs;             
reg     [`WK_PPN_WIDTH-1 :0]  tc_way3_ppn;             
reg              tc_way3_tag_par_fail;    
reg     [`WK_VPN_WIDTH-1 :0]  tc_way3_vpn;             
reg     [3  :0]  tc_way_sel;              
reg              tc_wen;                  
reg     [2:0]    tc_ptr; // wjh@pfu

// &Wires; @29
wire    [2  :0]  arb_jtlb_acc_type;       
wire    [15 :0]  arb_jtlb_asid;           
wire    [3  :0]  arb_jtlb_bank_sel;       
wire             arb_jtlb_cmp_with_va;    
wire    [`MMU_DATA_WIDTH-1 :0]  arb_jtlb_data_din;       
wire    [3  :0]  arb_jtlb_fifo_din;       
wire             arb_jtlb_fifo_write;     
wire    [8  :0]  arb_jtlb_idx;            
wire             arb_jtlb_pfu_grant;      
wire             arb_jtlb_req;            
wire    [`MMU_TAG_WIDTH-1 :0]  arb_jtlb_tag_din;        
wire    [`WK_VPN_WIDTH-1 :0]  arb_jtlb_vpn;            
wire             arb_jtlb_write;          
wire    [2:0]    arb_jtlb_ptr; // wjh@pfu
wire    [15 :0]  asid_for_va_hit;         
wire             cp0_mmu_data_ecc_inj;    
wire    [`MMU_DATA_WIDTH+1 :0]  cp0_mmu_data_random;     
wire             cp0_mmu_ecc_en;          
wire             cp0_mmu_icg_en;          
wire             cp0_mmu_maee;            
wire             cp0_mmu_mxr;             
wire             cp0_mmu_ptw_en;          
wire             cp0_mmu_sum;             
wire             cp0_mmu_tag_ecc_inj;     
wire    [59 :0]  cp0_mmu_tag_random;  //TODO    
wire             cpurst_b;                
wire             forever_cpuclk;          
wire    [15 :0]  jtlb_arb_asid;           
wire             jtlb_arb_cmp_va;         
wire             jtlb_arb_par_clr;        
wire             jtlb_arb_pfu_cmplt;      
wire    [`WK_VPN_WIDTH-1 :0]  jtlb_arb_pfu_vpn;        
wire             jtlb_arb_sel_1g;         
wire             jtlb_arb_sel_2m;         
wire             jtlb_arb_sel_4k;         
wire             jtlb_arb_tc_miss;        
wire    [2  :0]  jtlb_arb_type;           
wire    [`WK_VPN_WIDTH-1 :0]  jtlb_arb_vpn;            
wire             jtlb_clk;                
wire             jtlb_clk_en;             
wire    [2  :0]  jtlb_cur_pgs;            
wire             jtlb_data_cen0;          
wire             jtlb_data_cen1;          
wire    [2*(`MMU_DATA_WIDTH)+3 :0]  jtlb_data_din;           
wire    [1  :0]  jtlb_data_din_par;       
wire    [2*(`MMU_DATA_WIDTH)+3 :0]  jtlb_data_dout0;         
wire    [2*(`MMU_DATA_WIDTH)+3 :0]  jtlb_data_dout0_inj;     
wire    [2*(`MMU_DATA_WIDTH)+3 :0]  jtlb_data_dout1;         
wire    [2*(`MMU_DATA_WIDTH)+3 :0]  jtlb_data_dout1_inj;     
wire    [7  :0]  jtlb_data_idx;           
wire    [3  :0]  jtlb_data_wen;           
wire             jtlb_dutlb_acc_err;      
wire             jtlb_dutlb_pgflt;        
wire             jtlb_dutlb_ref_cmplt;    
wire             jtlb_dutlb_ref_pavld;    
wire             jtlb_iutlb_acc_err;      
wire             jtlb_iutlb_pgflt;        
wire             jtlb_iutlb_ref_cmplt;    
wire             jtlb_iutlb_ref_pavld;    
wire             jtlb_pfu_acc_fault;      
wire             jtlb_pfu_cmplt;          
wire             jtlb_pfu_deny;           
wire             jtlb_pfu_flag_fault;     
wire    [`WK_PPN_WIDTH-1 :0]  jtlb_pfu_pa;             
wire             jtlb_pfu_sec;            
wire             jtlb_pfu_share;          
wire    [2:0]    jtlb_pfu_ptr; // wjh@pfu
wire    [15 :0]  jtlb_ptw_asid;           
wire             jtlb_ptw_req;            
wire    [2  :0]  jtlb_ptw_type;           
wire    [`WK_VPN_WIDTH-1 :0]  jtlb_ptw_vpn;            
wire    [2:0]    jtlb_ptw_ptr;       // wjh@pfu
wire             jtlb_dutlb_cmplt;   // wjh@pfu
wire             jtlb_iutlb_cmplt;   // wjh@pfu
wire             jtlb_pfuhit_cmplt;  // wjh@pfu
wire             jtlb_ptw_has_cmplt; // wjh@pfu
wire             jtlb_regs_hit;           
wire             jtlb_regs_hit_mult;      
wire    [10 :0]  jtlb_regs_tlbp_hit_index; 
wire             jtlb_tag_cen;            
wire    [4*`MMU_TAG_WIDTH+11:0]  jtlb_tag_din;            
wire    [1  :0]  jtlb_tag_din_par;        
wire    [4*`MMU_TAG_WIDTH+11:0]  jtlb_tag_dout;           
wire    [4*`MMU_TAG_WIDTH+11:0]  jtlb_tag_dout_inj;       
wire    [7  :0]  jtlb_tag_idx;            
wire    [4  :0]  jtlb_tag_wen;            
wire             jtlb_tlboper_asid_hit;   
wire             jtlb_tlboper_cmplt;      
wire    [3  :0]  jtlb_tlboper_fifo;       
wire             jtlb_tlboper_read_idle;  
wire    [3  :0]  jtlb_tlboper_sel;        
wire             jtlb_tlboper_va_hit;     
wire    [15 :0]  jtlb_tlbr_asid;          
wire    [13 :0]  jtlb_tlbr_flg;           
wire             jtlb_tlbr_g;             
wire    [2  :0]  jtlb_tlbr_pgs;           
wire    [`WK_PPN_WIDTH-1 :0]  jtlb_tlbr_ppn;           
wire    [`WK_VPN_WIDTH-1 :0]  jtlb_tlbr_vpn;           
wire    [1  :0]  jtlb_top_cur_st;         
wire             jtlb_top_utlb_pavld;     
wire    [13 :0]  jtlb_utlb_ref_flg;       
wire    [2  :0]  jtlb_utlb_ref_pgs;       
wire    [`WK_PPN_WIDTH-1 :0]  jtlb_utlb_ref_ppn;       
wire    [`WK_VPN_WIDTH-1 :0]  jtlb_utlb_ref_vpn;       
wire    [11 :0]  jtlb_xx_fifo;            
wire             jtlb_xx_tc_read;         
wire    [`WK_PPN_WIDTH-1 :0]  lsu_mmu_va2;             
wire    [1  :0]  lsu_mmu_va2_priv_mode;   
wire             mmu_cp0_data_inj_cmplt;  
wire    [8  :0]  mmu_cp0_ecc_idx;         
wire    [2  :0]  mmu_cp0_ecc_ramid;       
wire             mmu_cp0_ecc_vld;         
wire    [1  :0]  mmu_cp0_ecc_way;         
wire             mmu_cp0_tag_inj_cmplt;             
wire    [`WK_PPN_WIDTH-1 :0]  mmu_sysmap_pa4;          
wire    [`WK_VPN_WIDTH-1 :0]  pa_offset;               
wire             pad_yy_icg_scan_en;      
wire             pfu_deny_st;             
wire             pfu_idle_st;             
wire             pfu_mach_mode;           
wire             pfu_mmu_off;             
wire             pfu_mmu_off_req;         
wire             pfu_ok_st;               
wire             pfu_supv_mode;           
wire             pfu_user_mode;           
wire    [3  :0]  pmp_mmu_flg4;            
wire    [`WK_VPN_WIDTH-1 :0]  ptw_arb_vpn;             
wire             ptw_jtlb_dmiss;          
wire             ptw_jtlb_imiss;          
wire             ptw_jtlb_pmiss;          
wire             ptw_jtlb_ref_acc_err;    
wire             ptw_jtlb_ref_cmplt;      
wire             ptw_jtlb_ref_data_vld;   
wire    [13 :0]  ptw_jtlb_ref_flg;        
wire             ptw_jtlb_ref_pgflt;      
wire    [2  :0]  ptw_jtlb_ref_pgs;        
wire    [`WK_PPN_WIDTH-1 :0]  ptw_jtlb_ref_ppn;        
wire    [2:0]    ptw_jtlb_ref_ptr; // wjh@pfu
wire    [`WK_PPN_WIDTH-1 :0]  ptw_pa2;                 
            
             
             
        
            
            
wire    [13 :0]  ref_flg;                 
wire    [2  :0]  ref_pgs;                 
wire    [`WK_PPN_WIDTH-1 :0]  ref_ppn;                 
wire    [`WK_VPN_WIDTH-1 :0]  ref_vpn;                 
wire    [2:0]    ref_ptr; // wjh@pfu
wire             regs_mmu_en;             
wire    [4  :0]  sysmap_mmu_flg4;         
wire    [1  :0]  ta_fifo_sum;             
wire    [3  :0]  ta_idx_sel;              
wire    [3  :0]  ta_jtlb_fifo;            
wire    [3  :0]  ta_jtlb_fifo_inj;        
wire    [`MMU_DATA_WIDTH-1 :0]  ta_jtlb_way0_data;       
wire    [`MMU_DATA_WIDTH-1 :0]  ta_jtlb_way0_data_inj;   
wire    [1  :0]  ta_jtlb_way0_data_par;   
wire    [`MMU_TAG_WIDTH-1 :0]  ta_jtlb_way0_tag;        
wire    [`MMU_TAG_WIDTH-1 :0]  ta_jtlb_way0_tag_inj;    
wire    [1  :0]  ta_jtlb_way0_tag_par;    
wire    [`MMU_DATA_WIDTH-1 :0]  ta_jtlb_way1_data;       
wire    [`MMU_DATA_WIDTH-1 :0]  ta_jtlb_way1_data_inj;   
wire    [1  :0]  ta_jtlb_way1_data_par;   
wire    [`MMU_TAG_WIDTH-1 :0]  ta_jtlb_way1_tag;        
wire    [`MMU_TAG_WIDTH-1 :0]  ta_jtlb_way1_tag_inj;    
wire    [1  :0]  ta_jtlb_way1_tag_par;    
wire    [`MMU_DATA_WIDTH-1 :0]  ta_jtlb_way2_data;       
wire    [`MMU_DATA_WIDTH-1 :0]  ta_jtlb_way2_data_inj;   
wire    [1  :0]  ta_jtlb_way2_data_par;   
wire    [`MMU_TAG_WIDTH-1 :0]  ta_jtlb_way2_tag;        
wire    [`MMU_TAG_WIDTH-1 :0]  ta_jtlb_way2_tag_inj;    
wire    [1  :0]  ta_jtlb_way2_tag_par;    
wire    [`MMU_DATA_WIDTH-1 :0]  ta_jtlb_way3_data;       
wire    [`MMU_DATA_WIDTH-1 :0]  ta_jtlb_way3_data_inj;   
wire    [1  :0]  ta_jtlb_way3_data_par;   
wire    [`MMU_TAG_WIDTH-1 :0]  ta_jtlb_way3_tag;        
wire    [`MMU_TAG_WIDTH-1 :0]  ta_jtlb_way3_tag_inj;    
wire    [1  :0]  ta_jtlb_way3_tag_par;    
wire    [`WK_VPN_WIDTH-1 :0]  ta_vpn_1g;               
wire    [`WK_VPN_WIDTH-1 :0]  ta_vpn_2m;               
wire    [`WK_VPN_WIDTH-1 :0]  ta_vpn_4k;               
wire    [`WK_VPN_WIDTH-1 :0]  ta_vpn_masked;           
wire    [15 :0]  ta_way0_asid;            
wire    [1  :0]  ta_way0_data_cal_par;    
wire             ta_way0_data_par_fail;   
wire             ta_way0_g;               
wire             ta_way0_hit_kid0;        
wire             ta_way0_hit_kid1;        
wire             ta_way0_hit_kid2;        
wire             ta_way0_hit_kid3;        
wire             ta_way0_hit_kid4;        
wire             ta_way0_hit_kid5; 
wire             ta_way0_hit_kid6;       
wire    [2  :0]  ta_way0_pgs;             
wire    [1  :0]  ta_way0_tag_cal_par;     
wire             ta_way0_tag_par_fail;    
wire             ta_way0_vld;             
wire    [`WK_VPN_WIDTH-1 :0]  ta_way0_vpn;             
wire    [15 :0]  ta_way1_asid;            
wire    [1  :0]  ta_way1_data_cal_par;    
wire             ta_way1_data_par_fail;   
wire             ta_way1_g;               
wire             ta_way1_hit_kid0;        
wire             ta_way1_hit_kid1;        
wire             ta_way1_hit_kid2;        
wire             ta_way1_hit_kid3;        
wire             ta_way1_hit_kid4;        
wire             ta_way1_hit_kid5;  
wire             ta_way1_hit_kid6;      
wire    [2  :0]  ta_way1_pgs;             
wire    [1  :0]  ta_way1_tag_cal_par;     
wire             ta_way1_tag_par_fail;    
wire             ta_way1_vld;             
wire    [`WK_VPN_WIDTH-1 :0]  ta_way1_vpn;             
wire    [15 :0]  ta_way2_asid;            
wire    [1  :0]  ta_way2_data_cal_par;    
wire             ta_way2_data_par_fail;   
wire             ta_way2_g;               
wire             ta_way2_hit_kid0;        
wire             ta_way2_hit_kid1;        
wire             ta_way2_hit_kid2;        
wire             ta_way2_hit_kid3;        
wire             ta_way2_hit_kid4;        
wire             ta_way2_hit_kid5;  
wire             ta_way2_hit_kid6;       
wire    [2  :0]  ta_way2_pgs;             
wire    [1  :0]  ta_way2_tag_cal_par;     
wire             ta_way2_tag_par_fail;    
wire             ta_way2_vld;             
wire    [`WK_VPN_WIDTH-1 :0]  ta_way2_vpn;             
wire    [15 :0]  ta_way3_asid;            
wire    [1  :0]  ta_way3_data_cal_par;    
wire             ta_way3_data_par_fail;   
wire             ta_way3_g;               
wire             ta_way3_hit_kid0;        
wire             ta_way3_hit_kid1;        
wire             ta_way3_hit_kid2;        
wire             ta_way3_hit_kid3;        
wire             ta_way3_hit_kid4;        
wire             ta_way3_hit_kid5;   
wire             ta_way3_hit_kid6;      
wire    [2  :0]  ta_way3_pgs;             
wire    [1  :0]  ta_way3_tag_cal_par;     
wire             ta_way3_tag_par_fail;    
wire             ta_way3_vld;             
wire    [`WK_VPN_WIDTH-1 :0]  ta_way3_vpn;             
wire             tag_fifo_wen;            
wire    [3  :0]  tag_way_wen;             
wire             tc_data_fail;            
wire    [13 :0]  tc_hit_flg;              
wire    [1  :0]  tc_hit_idx;              
wire    [`WK_PPN_WIDTH-1 :0]  tc_hit_ppn;              
wire    [2  :0]  tc_hit_sum;              
wire    [15 :0]  tc_idx_asid;             
wire             tc_idx_g;                
wire    [2  :0]  tc_idx_pgs;              
wire    [`WK_VPN_WIDTH-1 :0]  tc_idx_vpn;              
wire             tc_pa_vld;               
wire             tc_par_fail;             
wire             tc_tag_fail;             
wire             tc_tlb_hit;              
wire             tc_tlb_hit_mult;         
wire             tc_tlb_miss;             
wire             tc_tlb_miss_fin;         
wire             tc_utlb_cmplt;           
wire    [`WK_VPN_WIDTH-1 :0]  tc_vpn_1g;               
wire    [`WK_VPN_WIDTH-1 :0]  tc_vpn_2m;               
wire    [`WK_VPN_WIDTH-1 :0]  tc_vpn_4k;               
wire    [`WK_VPN_WIDTH-1 :0]  tc_vpn_masked;           
wire             tc_way0_hit;             
wire             tc_way0_sel;             
wire             tc_way1_hit;             
wire             tc_way1_sel;             
wire             tc_way2_hit;             
wire             tc_way2_sel;             
wire             tc_way3_hit;             
wire             tc_way3_sel;             
wire    [15 :0]  tlboper_jtlb_asid;       
wire             tlboper_jtlb_asid_sel;   
wire             tlboper_jtlb_cmp_noasid; 
wire    [15 :0]  tlboper_jtlb_inv_asid;   
wire             tlboper_jtlb_tlbwr_on;   
wire    [2  :0]  tlboper_xx_pgs;          
wire             tlboper_xx_pgs_en;       
wire             way0_fail;               
wire             way1_fail;               
wire             way2_fail;               
wire             way3_fail;               
reg [3:0]        stage_vld; // jtlb@pipe
wire             ta_set_vld;// jtlb@pipe


parameter VPN_WIDTH  = `WK_VPN_WIDTH;  // VPN
parameter PPN_WIDTH  = `WK_PPN_WIDTH;  // PPN
parameter FLG_WIDTH  = 14;     // Flags
parameter PGS_WIDTH  = 3;      // Page Size
parameter ASID_WIDTH = 16;     // Flags
parameter PTE_LEVEL  = 4;      // Page Table Label

// VPN width per level
parameter VPN_PERLEL = 9; 

// Valid + VPN + ASID + PageSize + Global
parameter TAG_WIDTH  = `MMU_TAG_WIDTH;  
parameter DATA_WIDTH = `MMU_DATA_WIDTH;  

//parameter WAY_NUM = 4;

//==========================================================
//                  Gate Cell
//==========================================================
// assign jtlb_clk_en = arb_jtlb_req || ta_vld || tc_vld || !read_cur_idle
//                   || !pfu_idle_st || ptw_jtlb_ref_cmplt
//                   || pfu_mmu_off_req; 
assign jtlb_clk_en = arb_jtlb_req || ta_vld || tc_vld 
                  || ptw_jtlb_ref_cmplt
                  || pfu_mmu_off_req; 
// &Instance("gated_clk_cell", "x_jtlb_gateclk"); @53
gated_clk_cell  x_jtlb_gateclk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (jtlb_clk          ),
  .external_en        (1'b0              ),
  .local_en           (jtlb_clk_en       ),
  .module_en          (cp0_mmu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect( .clk_in     (forever_cpuclk), @54
//           .external_en(1'b0          ), @55
//           .module_en  (cp0_mmu_icg_en), @56
//           .local_en   (jtlb_clk_en   ), @57
//           .clk_out    (jtlb_clk      ) @58
//          ); @59


//==============================================================================
//                  Input to Memory ---  RB stage (Arbiter)
//==============================================================================
//==========================================================
//                  CEN & WEN
//==========================================================
//tag cen
assign jtlb_tag_cen       = arb_jtlb_req || stage_vld[0] || stage_vld[1]; // jtlb@pipe

//tag wen
assign tag_fifo_wen       = arb_jtlb_fifo_write;
assign tag_way_wen[3:0]   = {4{arb_jtlb_write}} & arb_jtlb_bank_sel[3:0];
assign jtlb_tag_wen[4:0]  = {tag_fifo_wen, tag_way_wen[3:0]};

//data cen
assign jtlb_data_cen0     = (arb_jtlb_req && (|arb_jtlb_bank_sel[1:0])) || stage_vld[0] || stage_vld[1]; // jtlb@pipe
assign jtlb_data_cen1     = (arb_jtlb_req && (|arb_jtlb_bank_sel[3:2])) || stage_vld[0] || stage_vld[1]; // jtlb@pipe

//data wen
assign jtlb_data_wen[3:0] = {4{arb_jtlb_write}} & arb_jtlb_bank_sel[3:0]; 


//==========================================================
//                  Input Index
//==========================================================
// &Force("bus", "arb_jtlb_idx", 8, 0); @88
assign jtlb_tag_idx[7:0]  = arb_jtlb_req        // jtlb@pipe
                            ? arb_jtlb_idx[7:0] // jtlb@pipe
                            : stage_vld[0]      // jtlb@pipe
                              ? ta_vpn[16:9]    // jtlb@pipe
                              : ta_vpn[25:18];  // jtlb@pipe
assign jtlb_data_idx[7:0] = arb_jtlb_req        // jtlb@pipe
                            ? arb_jtlb_idx[7:0] // jtlb@pipe
                            : stage_vld[0]      // jtlb@pipe
                              ? ta_vpn[16:9]    // jtlb@pipe
                              : ta_vpn[25:18];  // jtlb@pipe



//==========================================================
//                  Input Data
//==========================================================
assign jtlb_tag_din_par[1:0] = {^(arb_jtlb_tag_din[TAG_WIDTH-1:32]),
                                ^(arb_jtlb_tag_din[31:0])};

assign jtlb_tag_din[(TAG_WIDTH*4)+11:(TAG_WIDTH*4)+4] = {jtlb_tag_din_par[1:0],
                                                         jtlb_tag_din_par[1:0],
                                                         jtlb_tag_din_par[1:0],
                                                         jtlb_tag_din_par[1:0]};

assign jtlb_tag_din[(TAG_WIDTH*4)+3:0] = {arb_jtlb_fifo_din[3:0],
                                          arb_jtlb_tag_din[TAG_WIDTH-1:0],
                                          arb_jtlb_tag_din[TAG_WIDTH-1:0],
                                          arb_jtlb_tag_din[TAG_WIDTH-1:0],
                                          arb_jtlb_tag_din[TAG_WIDTH-1:0]};

assign jtlb_data_din_par[1:0] = {^(arb_jtlb_data_din[DATA_WIDTH-1:32]),
                                 ^(arb_jtlb_data_din[31:0])};
assign jtlb_data_din[(DATA_WIDTH*2)+3:DATA_WIDTH*2] = {jtlb_data_din_par[1:0],
                                                       jtlb_data_din_par[1:0]};
assign jtlb_data_din[(DATA_WIDTH*2)-1:0] = {arb_jtlb_data_din[DATA_WIDTH-1:0],
                                            arb_jtlb_data_din[DATA_WIDTH-1:0]}; 


//==========================================================
//                  jTLB Memory Instance
//==========================================================
// &Instance("xx_mmu_jtlb_tag_array"); @138
xx_mmu_jtlb_tag_array  x_xx_mmu_jtlb_tag_array (
  .cp0_mmu_icg_en     (cp0_mmu_icg_en    ),
  .forever_cpuclk     (forever_cpuclk    ),
  .jtlb_tag_cen       (jtlb_tag_cen      ),
  .jtlb_tag_din       (jtlb_tag_din      ),
  .jtlb_tag_dout      (jtlb_tag_dout     ),
  .jtlb_tag_idx       (jtlb_tag_idx      ),
  .jtlb_tag_wen       (jtlb_tag_wen      ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en),
  .pad_sram_RME       (pad_sram_RME      ),
  .pad_sram_RM        (pad_sram_RM       )
);


// &Instance("xx_mmu_jtlb_data_array"); @140
xx_mmu_jtlb_data_array  x_xx_mmu_jtlb_data_array (
  .cp0_mmu_icg_en     (cp0_mmu_icg_en    ),
  .forever_cpuclk     (forever_cpuclk    ),
  .jtlb_data_cen0     (jtlb_data_cen0    ),
  .jtlb_data_cen1     (jtlb_data_cen1    ),
  .jtlb_data_din      (jtlb_data_din     ),
  .jtlb_data_dout0    (jtlb_data_dout0   ),
  .jtlb_data_dout1    (jtlb_data_dout1   ),
  .jtlb_data_idx      (jtlb_data_idx     ),
  .jtlb_data_wen      (jtlb_data_wen     ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en),
  .pad_sram_RME       (pad_sram_RME      ),
  .pad_sram_RM        (pad_sram_RM       )
);



//==============================================================================
//                  Output from Memory --- TA stage (TLB Access)
//==============================================================================
// req | req | req |
//     | ta  | ta  | ta  |
//     |     | tc  | tc  | tc  |
//       stg0  stg1  stg2  stg3
//  4r |  2r |  1r |     |
//           | 4h/m| 2h/m| 1h/m|
//tips xr: 4K/2M/1G req 
//tips xh/m: 4K hit/miss; 2M hit/miss; 1G hit/miss; 
always @(posedge jtlb_clk or negedge cpurst_b)begin 
  if(!cpurst_b)
    stage_vld[0] <= 1'b0;
  else if(arb_jtlb_cmp_with_va && arb_jtlb_acc_type != 3'b001)
    stage_vld[0] <= 1'b1;
  else
    stage_vld[0] <= 1'b0;
end

always @(posedge jtlb_clk or negedge cpurst_b)begin 
  if(!cpurst_b)
    stage_vld[1] <= 1'b0;
  else if(stage_vld[0])
    stage_vld[1] <= 1'b1;
  else  
    stage_vld[1] <= 1'b0;
end

always @(posedge jtlb_clk or negedge cpurst_b)begin 
  if(!cpurst_b)
    stage_vld[2] <= 1'b0;
  else if(stage_vld[1] && (tc_tlb_miss || tc_par_fail))  // 4K miss->2M
    stage_vld[2] <= 1'b1;
  else
    stage_vld[2] <= 1'b0;
end

always@(posedge jtlb_clk or negedge cpurst_b)begin 
  if(!cpurst_b)
    stage_vld[3] <= 1'b0;
  else if(stage_vld[2] && (tc_tlb_miss || tc_par_fail)) // 2M miss->1G  
    stage_vld[3] <= 1'b1;
  else
    stage_vld[3] <= 1'b0;
end
//==========================================================
//                  TA Valid
//==========================================================
always @(posedge jtlb_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    ta_vld <= 1'b0;
  // else if(arb_jtlb_req && arb_jtlb_acc_type[2:0] != 3'b0)
  else if(ta_set_vld) // jtlb@pipe
    ta_vld <= 1'b1;
  else
    ta_vld <= 1'b0;
end
assign ta_set_vld = (arb_jtlb_req && arb_jtlb_acc_type != 3'b0)       // jtlb@pipe
                    || stage_vld[0]                                   // jtlb@pipe
                    || stage_vld[1] && (tc_tlb_miss || tc_par_fail) ; // jtlb@pipe
//==========================================================
//                  Other Control Signal
//==========================================================
always @(posedge jtlb_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    ta_vpn[VPN_WIDTH-1:0] <= {VPN_WIDTH{1'b0}};
    ta_asid[ASID_WIDTH-1:0] <= {ASID_WIDTH{1'b0}};
    ta_ptr[2:0]           <= 3'b0;
    ta_cmp_va             <= 1'b0;
    ta_way_sel[3:0]       <= 4'b0;
    ta_acc_type[2:0]      <= 3'b0;
    ta_wen                <= 1'b0;
  end
  else if(arb_jtlb_req)
  begin
    ta_vpn[VPN_WIDTH-1:0] <= arb_jtlb_vpn[VPN_WIDTH-1:0];
    ta_asid[ASID_WIDTH-1:0] <= arb_jtlb_asid[ASID_WIDTH-1:0];
    ta_cmp_va             <= arb_jtlb_cmp_with_va;
    ta_way_sel[3:0]       <= arb_jtlb_bank_sel[3:0];
    ta_acc_type[2:0]      <= arb_jtlb_acc_type[2:0];
    ta_wen                <= arb_jtlb_write;
    ta_ptr[2:0]           <= arb_jtlb_ptr;
  end
end


//==========================================================
//                  TAG & DATA Output
//==========================================================
assign ta_jtlb_way3_tag[TAG_WIDTH-1:0] = jtlb_tag_dout[(TAG_WIDTH*4)-1:TAG_WIDTH*3];
assign ta_jtlb_way2_tag[TAG_WIDTH-1:0] = jtlb_tag_dout[(TAG_WIDTH*3)-1:TAG_WIDTH*2];
assign ta_jtlb_way1_tag[TAG_WIDTH-1:0] = jtlb_tag_dout[(TAG_WIDTH*2)-1:TAG_WIDTH*1];
assign ta_jtlb_way0_tag[TAG_WIDTH-1:0] = jtlb_tag_dout[(TAG_WIDTH*1)-1:TAG_WIDTH*0];

assign ta_jtlb_way3_data[DATA_WIDTH-1:0] = jtlb_data_dout1[(DATA_WIDTH*2)-1:DATA_WIDTH*1];
assign ta_jtlb_way2_data[DATA_WIDTH-1:0] = jtlb_data_dout1[(DATA_WIDTH*1)-1:DATA_WIDTH*0];
assign ta_jtlb_way1_data[DATA_WIDTH-1:0] = jtlb_data_dout0[(DATA_WIDTH*2)-1:DATA_WIDTH*1];
assign ta_jtlb_way0_data[DATA_WIDTH-1:0] = jtlb_data_dout0[(DATA_WIDTH*1)-1:DATA_WIDTH*0];

//==========================================================
//                  Parity Info
//==========================================================
// &Force("bus", "jtlb_tag_dout_inj", 203, 0); @202
// &Force("bus", "jtlb_data_dout1_inj", 87, 0); @203
// &Force("bus", "jtlb_data_dout0_inj", 87, 0); @204

assign jtlb_tag_dout_inj[(TAG_WIDTH*4)+11:0] = cp0_mmu_tag_ecc_inj
                                            ? {cp0_mmu_tag_random[59:0],
                                               cp0_mmu_tag_random[59:0],
                                               cp0_mmu_tag_random[59:0],
                                               cp0_mmu_tag_random[59:0]}
                                             : jtlb_tag_dout[(TAG_WIDTH*4)+11:0];
assign jtlb_data_dout1_inj[(DATA_WIDTH*2)+3:0] = cp0_mmu_data_ecc_inj
                                              ? {cp0_mmu_data_random[`MMU_DATA_WIDTH+1:0],
                                                 cp0_mmu_data_random[`MMU_DATA_WIDTH+1:0]}
                                               : jtlb_data_dout1[(DATA_WIDTH*2)+3:0];
assign jtlb_data_dout0_inj[(DATA_WIDTH*2)+3:0] = cp0_mmu_data_ecc_inj
                                              ? {cp0_mmu_data_random[`MMU_DATA_WIDTH+1:0],
                                                 cp0_mmu_data_random[`MMU_DATA_WIDTH+1:0]}
                                               : jtlb_data_dout0[(DATA_WIDTH*2)+3:0];

assign ta_jtlb_fifo_inj[3:0]               = jtlb_tag_dout_inj[(TAG_WIDTH*4)+3:TAG_WIDTH*4];
assign ta_jtlb_way3_tag_inj[TAG_WIDTH-1:0] = jtlb_tag_dout_inj[(TAG_WIDTH*4)-1:TAG_WIDTH*3];
assign ta_jtlb_way2_tag_inj[TAG_WIDTH-1:0] = jtlb_tag_dout_inj[(TAG_WIDTH*3)-1:TAG_WIDTH*2];
assign ta_jtlb_way1_tag_inj[TAG_WIDTH-1:0] = jtlb_tag_dout_inj[(TAG_WIDTH*2)-1:TAG_WIDTH*1];
assign ta_jtlb_way0_tag_inj[TAG_WIDTH-1:0] = jtlb_tag_dout_inj[(TAG_WIDTH*1)-1:TAG_WIDTH*0];

assign ta_jtlb_way3_data_inj[DATA_WIDTH-1:0] = jtlb_data_dout1_inj[(DATA_WIDTH*2)-1:DATA_WIDTH*1];
assign ta_jtlb_way2_data_inj[DATA_WIDTH-1:0] = jtlb_data_dout1_inj[(DATA_WIDTH*1)-1:DATA_WIDTH*0];
assign ta_jtlb_way1_data_inj[DATA_WIDTH-1:0] = jtlb_data_dout0_inj[(DATA_WIDTH*2)-1:DATA_WIDTH*1];
assign ta_jtlb_way0_data_inj[DATA_WIDTH-1:0] = jtlb_data_dout0_inj[(DATA_WIDTH*1)-1:DATA_WIDTH*0];

assign ta_jtlb_way3_tag_par[1:0] = jtlb_tag_dout_inj[(TAG_WIDTH*4)+11:TAG_WIDTH*4+10];
assign ta_jtlb_way2_tag_par[1:0] = jtlb_tag_dout_inj[(TAG_WIDTH*4)+9:TAG_WIDTH*4+8];
assign ta_jtlb_way1_tag_par[1:0] = jtlb_tag_dout_inj[(TAG_WIDTH*4)+7:TAG_WIDTH*4+6];
assign ta_jtlb_way0_tag_par[1:0] = jtlb_tag_dout_inj[(TAG_WIDTH*4)+5:TAG_WIDTH*4+4];
assign ta_jtlb_way3_data_par[1:0] = jtlb_data_dout1_inj[(DATA_WIDTH*2)+3:DATA_WIDTH*2+2];
assign ta_jtlb_way2_data_par[1:0] = jtlb_data_dout1_inj[(DATA_WIDTH*2)+1:DATA_WIDTH*2];
assign ta_jtlb_way1_data_par[1:0] = jtlb_data_dout0_inj[(DATA_WIDTH*2)+3:DATA_WIDTH*2+2];
assign ta_jtlb_way0_data_par[1:0] = jtlb_data_dout0_inj[(DATA_WIDTH*2)+1:DATA_WIDTH*2];

assign ta_fifo_sum[1:0] = {1'b0, ta_jtlb_fifo_inj[3]} + {1'b0, ta_jtlb_fifo_inj[2]}
                        + {1'b0, ta_jtlb_fifo_inj[1]} + {1'b0, ta_jtlb_fifo_inj[0]};
assign ta_jtlb_fifo[3:0]        = ta_fifo_sum[1:0] != 2'b1 ? 4'b0001
                                : jtlb_tag_dout[(TAG_WIDTH*4)+3:TAG_WIDTH*4];
assign ta_way3_tag_cal_par[1:0] = {^(ta_jtlb_way3_tag_inj[TAG_WIDTH-1:32]),
                                   ^(ta_jtlb_way3_tag_inj[31:0])};
assign ta_way2_tag_cal_par[1:0] = {^(ta_jtlb_way2_tag_inj[TAG_WIDTH-1:32]),
                                   ^(ta_jtlb_way2_tag_inj[31:0])};
assign ta_way1_tag_cal_par[1:0] = {^(ta_jtlb_way1_tag_inj[TAG_WIDTH-1:32]),
                                   ^(ta_jtlb_way1_tag_inj[31:0])};
assign ta_way0_tag_cal_par[1:0] = {^(ta_jtlb_way0_tag_inj[TAG_WIDTH-1:32]),
                                   ^(ta_jtlb_way0_tag_inj[31:0])};

assign ta_way3_data_cal_par[1:0] = {^(ta_jtlb_way3_data_inj[DATA_WIDTH-1:32]),
                                    ^(ta_jtlb_way3_data_inj[31:0])};
assign ta_way2_data_cal_par[1:0] = {^(ta_jtlb_way2_data_inj[DATA_WIDTH-1:32]),
                                    ^(ta_jtlb_way2_data_inj[31:0])};
assign ta_way1_data_cal_par[1:0] = {^(ta_jtlb_way1_data_inj[DATA_WIDTH-1:32]),
                                    ^(ta_jtlb_way1_data_inj[31:0])};
assign ta_way0_data_cal_par[1:0] = {^(ta_jtlb_way0_data_inj[DATA_WIDTH-1:32]),
                                    ^(ta_jtlb_way0_data_inj[31:0])};

assign ta_way3_tag_par_fail = ta_way3_tag_cal_par[1:0] != ta_jtlb_way3_tag_par[1:0];
assign ta_way2_tag_par_fail = ta_way2_tag_cal_par[1:0] != ta_jtlb_way2_tag_par[1:0];
assign ta_way1_tag_par_fail = ta_way1_tag_cal_par[1:0] != ta_jtlb_way1_tag_par[1:0];
assign ta_way0_tag_par_fail = ta_way0_tag_cal_par[1:0] != ta_jtlb_way0_tag_par[1:0];

assign ta_way3_data_par_fail = ta_way3_data_cal_par[1:0] != ta_jtlb_way3_data_par[1:0];
assign ta_way2_data_par_fail = ta_way2_data_cal_par[1:0] != ta_jtlb_way2_data_par[1:0];
assign ta_way1_data_par_fail = ta_way1_data_cal_par[1:0] != ta_jtlb_way1_data_par[1:0];
assign ta_way0_data_par_fail = ta_way0_data_cal_par[1:0] != ta_jtlb_way0_data_par[1:0];

//==========================================================
//                  Hit Info
//==========================================================
assign {ta_way3_vld, ta_way3_vpn[VPN_WIDTH-1:0], ta_way3_asid[ASID_WIDTH-1:0],
        ta_way3_pgs[PGS_WIDTH-1:0], ta_way3_g} = ta_jtlb_way3_tag[TAG_WIDTH-1:0];

assign {ta_way2_vld, ta_way2_vpn[VPN_WIDTH-1:0], ta_way2_asid[ASID_WIDTH-1:0],
        ta_way2_pgs[PGS_WIDTH-1:0], ta_way2_g} = ta_jtlb_way2_tag[TAG_WIDTH-1:0];

assign {ta_way1_vld, ta_way1_vpn[VPN_WIDTH-1:0], ta_way1_asid[ASID_WIDTH-1:0],
        ta_way1_pgs[PGS_WIDTH-1:0], ta_way1_g} = ta_jtlb_way1_tag[TAG_WIDTH-1:0];

assign {ta_way0_vld, ta_way0_vpn[VPN_WIDTH-1:0], ta_way0_asid[ASID_WIDTH-1:0],
        ta_way0_pgs[PGS_WIDTH-1:0], ta_way0_g} = ta_jtlb_way0_tag[TAG_WIDTH-1:0];

assign ta_vpn_4k[VPN_WIDTH-1:0] =  ta_vpn[VPN_WIDTH-1:0];
assign ta_vpn_2m[VPN_WIDTH-1:0] = {ta_vpn[VPN_WIDTH-1:VPN_PERLEL*1], {VPN_PERLEL*1{1'b0}}};
assign ta_vpn_1g[VPN_WIDTH-1:0] = {ta_vpn[VPN_WIDTH-1:VPN_PERLEL*2], {VPN_PERLEL*2{1'b0}}};
assign ta_vpn_masked[VPN_WIDTH-1:0] = {VPN_WIDTH{jtlb_cur_pgs[0]}} & ta_vpn_4k[VPN_WIDTH-1:0]
                                    | {VPN_WIDTH{jtlb_cur_pgs[1]}} & ta_vpn_2m[VPN_WIDTH-1:0]
                                    | {VPN_WIDTH{jtlb_cur_pgs[2]}} & ta_vpn_1g[VPN_WIDTH-1:0];
assign jtlb_cur_pgs[PGS_WIDTH-1:0] = tlboper_xx_pgs_en ? tlboper_xx_pgs[2:0]
                                                       : {stage_vld[2], stage_vld[1], stage_vld[0]}; // jtlb@pipe
assign asid_for_va_hit[ASID_WIDTH-1:0] = tlboper_jtlb_asid_sel   
                                       ? tlboper_jtlb_asid[ASID_WIDTH-1:0]
                                       : ta_asid[ASID_WIDTH-1:0];

// way3 hit for timing
assign ta_way3_hit_kid0 = (ta_way3_vpn[VPN_PERLEL*1-1:0]   == ta_vpn_masked[VPN_PERLEL*1-1:0]);
assign ta_way3_hit_kid1 = (ta_way3_vpn[VPN_PERLEL*2-1:VPN_PERLEL*1]  == ta_vpn_masked[VPN_PERLEL*2-1:VPN_PERLEL*1])
                               && jtlb_cur_pgs[PGS_WIDTH-1:0] == ta_way3_pgs[PGS_WIDTH-1:0];
assign ta_way3_hit_kid2 = (ta_way3_vpn[VPN_PERLEL*3-1:VPN_PERLEL*2] == ta_vpn_masked[VPN_PERLEL*3-1:VPN_PERLEL*2])
                               && ta_way3_vld && ta_cmp_va;
assign ta_way3_hit_kid3 = (ta_way3_asid[VPN_PERLEL*1-1:0]   == asid_for_va_hit[VPN_PERLEL*1-1:0]);
assign ta_way3_hit_kid4 = (ta_way3_asid[ASID_WIDTH-1:VPN_PERLEL*1]  == asid_for_va_hit[ASID_WIDTH-1:VPN_PERLEL*1]);
assign ta_way3_hit_kid5 =  ta_way3_g || tlboper_jtlb_cmp_noasid;
assign ta_way3_hit_kid6 = mmu_sv48_en ? (ta_way3_vpn[VPN_WIDTH-1:VPN_PERLEL*3]  == ta_vpn_masked[VPN_WIDTH-1:VPN_PERLEL*3]) : 1;

// way2 hit for timing
assign ta_way2_hit_kid0 = (ta_way2_vpn[VPN_PERLEL*1-1:0]   == ta_vpn_masked[VPN_PERLEL*1-1:0]);
assign ta_way2_hit_kid1 = (ta_way2_vpn[VPN_PERLEL*2-1:VPN_PERLEL*1]  == ta_vpn_masked[VPN_PERLEL*2-1:VPN_PERLEL*1])
                               && jtlb_cur_pgs[PGS_WIDTH-1:0] == ta_way2_pgs[PGS_WIDTH-1:0];
assign ta_way2_hit_kid2 = (ta_way2_vpn[VPN_PERLEL*3-1:VPN_PERLEL*2] == ta_vpn_masked[VPN_PERLEL*3-1:VPN_PERLEL*2])
                               && ta_way2_vld && ta_cmp_va;
assign ta_way2_hit_kid3 = (ta_way2_asid[VPN_PERLEL*1-1:0]   == asid_for_va_hit[VPN_PERLEL*1-1:0]);
assign ta_way2_hit_kid4 = (ta_way2_asid[ASID_WIDTH-1:VPN_PERLEL*1]  == asid_for_va_hit[ASID_WIDTH-1:VPN_PERLEL*1]);
assign ta_way2_hit_kid5 =  ta_way2_g || tlboper_jtlb_cmp_noasid;
assign ta_way2_hit_kid6 = mmu_sv48_en ? (ta_way2_vpn[VPN_WIDTH-1:VPN_PERLEL*3]  == ta_vpn_masked[VPN_WIDTH-1:VPN_PERLEL*3]) : 1;
// way1 hit for timing
assign ta_way1_hit_kid0 = (ta_way1_vpn[VPN_PERLEL*1-1:0]   == ta_vpn_masked[VPN_PERLEL*1-1:0]);
assign ta_way1_hit_kid1 = (ta_way1_vpn[VPN_PERLEL*2-1:VPN_PERLEL*1]  == ta_vpn_masked[VPN_PERLEL*2-1:VPN_PERLEL*1])
                               && jtlb_cur_pgs[PGS_WIDTH-1:0] == ta_way1_pgs[PGS_WIDTH-1:0];
assign ta_way1_hit_kid2 = (ta_way1_vpn[VPN_PERLEL*3-1:VPN_PERLEL*2] == ta_vpn_masked[VPN_PERLEL*3-1:VPN_PERLEL*2])
                               && ta_way1_vld && ta_cmp_va;
assign ta_way1_hit_kid3 = (ta_way1_asid[VPN_PERLEL*1-1:0]   == asid_for_va_hit[VPN_PERLEL*1-1:0]);
assign ta_way1_hit_kid4 = (ta_way1_asid[ASID_WIDTH-1:VPN_PERLEL*1]  == asid_for_va_hit[ASID_WIDTH-1:VPN_PERLEL*1]);
assign ta_way1_hit_kid5 =  ta_way1_g || tlboper_jtlb_cmp_noasid;
assign ta_way1_hit_kid6 = mmu_sv48_en ? (ta_way1_vpn[VPN_WIDTH-1:VPN_PERLEL*3]  == ta_vpn_masked[VPN_WIDTH-1:VPN_PERLEL*3]) : 1;
// way0 hit for timing
assign ta_way0_hit_kid0 = (ta_way0_vpn[VPN_PERLEL*1-1:0]   == ta_vpn_masked[VPN_PERLEL*1-1:0]);
assign ta_way0_hit_kid1 = (ta_way0_vpn[VPN_PERLEL*2-1:VPN_PERLEL*1]  == ta_vpn_masked[VPN_PERLEL*2-1:VPN_PERLEL*1])
                               && jtlb_cur_pgs[PGS_WIDTH-1:0] == ta_way0_pgs[PGS_WIDTH-1:0];
assign ta_way0_hit_kid2 = (ta_way0_vpn[VPN_PERLEL*3-1:VPN_PERLEL*2] == ta_vpn_masked[VPN_PERLEL*3-1:VPN_PERLEL*2])
                               && ta_way0_vld && ta_cmp_va;
assign ta_way0_hit_kid3 = (ta_way0_asid[VPN_PERLEL*1-1:0]   == asid_for_va_hit[VPN_PERLEL*1-1:0]);
assign ta_way0_hit_kid4 = (ta_way0_asid[ASID_WIDTH-1:VPN_PERLEL*1]  == asid_for_va_hit[ASID_WIDTH-1:VPN_PERLEL*1]);
assign ta_way0_hit_kid5 =  ta_way0_g || tlboper_jtlb_cmp_noasid;
assign ta_way0_hit_kid6 = mmu_sv48_en ? (ta_way0_vpn[VPN_WIDTH-1:VPN_PERLEL*3]  == ta_vpn_masked[VPN_WIDTH-1:VPN_PERLEL*3]) : 1;

assign ta_idx_sel[3:0]  = ta_way_sel[3:0] & {4{!ta_cmp_va}}; 

//==============================================================================
//                  Compare for Hit --- TC stage (TLB Compare)
//==============================================================================
//==========================================================
//                  TC Valid
//==========================================================
always @(posedge jtlb_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    tc_vld <= 1'b0;
  else if(ta_vld)
    tc_vld <= 1'b1;
  else
    tc_vld <= 1'b0;
end

//==========================================================
//                  Other Control Signal
//==========================================================
always @(posedge jtlb_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    tc_way3_tag_par_fail  <= 1'b0;
    tc_way2_tag_par_fail  <= 1'b0;
    tc_way1_tag_par_fail  <= 1'b0;
    tc_way0_tag_par_fail  <= 1'b0;
    tc_way3_data_par_fail <= 1'b0;
    tc_way2_data_par_fail <= 1'b0;
    tc_way1_data_par_fail <= 1'b0;
    tc_way0_data_par_fail <= 1'b0;
  end
  else if(ta_vld)
  begin
    tc_way3_tag_par_fail <= ta_way3_tag_par_fail;
    tc_way2_tag_par_fail <= ta_way2_tag_par_fail;
    tc_way1_tag_par_fail <= ta_way1_tag_par_fail;
    tc_way0_tag_par_fail <= ta_way0_tag_par_fail;
    tc_way3_data_par_fail <= ta_way3_data_par_fail;
    tc_way2_data_par_fail <= ta_way2_data_par_fail;
    tc_way1_data_par_fail <= ta_way1_data_par_fail;
    tc_way0_data_par_fail <= ta_way0_data_par_fail;
  end
end
assign way3_fail = tc_way3_tag_par_fail || tc_way3_data_par_fail;
assign way2_fail = tc_way2_tag_par_fail || tc_way2_data_par_fail;
assign way1_fail = tc_way1_tag_par_fail || tc_way1_data_par_fail;
assign way0_fail = tc_way0_tag_par_fail || tc_way0_data_par_fail;

// &CombBeg; @396
always @( way0_fail
       or way3_fail
       or way1_fail
       or way2_fail)
begin
casez({way3_fail, way2_fail, way1_fail, way0_fail})
  4'b???1: fail_way[1:0] = 2'b00;
  4'b??10: fail_way[1:0] = 2'b01;
  4'b?100: fail_way[1:0] = 2'b10;
  4'b1000: fail_way[1:0] = 2'b11;
  default: fail_way[1:0] = 2'bx;
endcase
// &CombEnd; @404
end

assign tc_tag_fail = tc_way3_tag_par_fail || tc_way2_tag_par_fail
                  || tc_way1_tag_par_fail || tc_way0_tag_par_fail;

assign tc_data_fail = tc_way3_data_par_fail || tc_way2_data_par_fail
                   || tc_way1_data_par_fail || tc_way0_data_par_fail;

assign tc_par_fail = (tc_tag_fail || tc_data_fail) && tc_vld && tc_cmp_va && cp0_mmu_ecc_en;

assign mmu_cp0_ecc_vld = tc_vld && tc_par_fail;
assign mmu_cp0_ecc_ramid[2:0] = tc_tag_fail ? 3'b100 : 3'b101;
assign mmu_cp0_ecc_way[1:0] = fail_way[1:0];
assign mmu_cp0_ecc_idx[8:0] = tc_vpn[8:0];
assign mmu_cp0_tag_inj_cmplt = tc_vld && tc_tag_fail && cp0_mmu_ecc_en && cp0_mmu_tag_ecc_inj;
assign mmu_cp0_data_inj_cmplt = tc_vld && tc_data_fail && cp0_mmu_ecc_en && cp0_mmu_data_ecc_inj;

always @(posedge jtlb_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    tc_way3_hit_kid0 <= 1'b0;
    tc_way3_hit_kid1 <= 1'b0;
    tc_way3_hit_kid2 <= 1'b0;
    tc_way3_hit_kid3 <= 1'b0;
    tc_way3_hit_kid4 <= 1'b0;
    tc_way3_hit_kid5 <= 1'b0;
    tc_way3_hit_kid6 <= 1'b0;
  end
  else if(ta_vld)
  begin
    tc_way3_hit_kid0 <= ta_way3_hit_kid0;
    tc_way3_hit_kid1 <= ta_way3_hit_kid1;
    tc_way3_hit_kid2 <= ta_way3_hit_kid2;
    tc_way3_hit_kid3 <= ta_way3_hit_kid3;
    tc_way3_hit_kid4 <= ta_way3_hit_kid4;
    tc_way3_hit_kid5 <= ta_way3_hit_kid5;
    tc_way3_hit_kid6 <= ta_way3_hit_kid6;
  end
end

always @(posedge jtlb_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    tc_way2_hit_kid0 <= 1'b0;
    tc_way2_hit_kid1 <= 1'b0;
    tc_way2_hit_kid2 <= 1'b0;
    tc_way2_hit_kid3 <= 1'b0;
    tc_way2_hit_kid4 <= 1'b0;
    tc_way2_hit_kid5 <= 1'b0;
    tc_way2_hit_kid6 <= 1'b0;
  end
  else if(ta_vld)
  begin
    tc_way2_hit_kid0 <= ta_way2_hit_kid0;
    tc_way2_hit_kid1 <= ta_way2_hit_kid1;
    tc_way2_hit_kid2 <= ta_way2_hit_kid2;
    tc_way2_hit_kid3 <= ta_way2_hit_kid3;
    tc_way2_hit_kid4 <= ta_way2_hit_kid4;
    tc_way2_hit_kid5 <= ta_way2_hit_kid5;
    tc_way2_hit_kid6 <= ta_way2_hit_kid6;
  end
end

always @(posedge jtlb_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    tc_way1_hit_kid0 <= 1'b0;
    tc_way1_hit_kid1 <= 1'b0;
    tc_way1_hit_kid2 <= 1'b0;
    tc_way1_hit_kid3 <= 1'b0;
    tc_way1_hit_kid4 <= 1'b0;
    tc_way1_hit_kid5 <= 1'b0;
    tc_way1_hit_kid6 <= 1'b0;
  end
  else if(ta_vld)
  begin
    tc_way1_hit_kid0 <= ta_way1_hit_kid0;
    tc_way1_hit_kid1 <= ta_way1_hit_kid1;
    tc_way1_hit_kid2 <= ta_way1_hit_kid2;
    tc_way1_hit_kid3 <= ta_way1_hit_kid3;
    tc_way1_hit_kid4 <= ta_way1_hit_kid4;
    tc_way1_hit_kid5 <= ta_way1_hit_kid5;
    tc_way1_hit_kid6 <= ta_way1_hit_kid6;
  end
end

always @(posedge jtlb_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    tc_way0_hit_kid0 <= 1'b0;
    tc_way0_hit_kid1 <= 1'b0;
    tc_way0_hit_kid2 <= 1'b0;
    tc_way0_hit_kid3 <= 1'b0;
    tc_way0_hit_kid4 <= 1'b0;
    tc_way0_hit_kid5 <= 1'b0;
    tc_way0_hit_kid6 <= 1'b0;
  end
  else if(ta_vld)
  begin
    tc_way0_hit_kid0 <= ta_way0_hit_kid0;
    tc_way0_hit_kid1 <= ta_way0_hit_kid1;
    tc_way0_hit_kid2 <= ta_way0_hit_kid2;
    tc_way0_hit_kid3 <= ta_way0_hit_kid3;
    tc_way0_hit_kid4 <= ta_way0_hit_kid4;
    tc_way0_hit_kid5 <= ta_way0_hit_kid5;
    tc_way0_hit_kid6 <= ta_way0_hit_kid6;
  end
end

assign tc_way3_hit = tc_way3_hit_kid0 && tc_way3_hit_kid1 && tc_way3_hit_kid2 && tc_way3_hit_kid6
                 && (tc_way3_hit_kid3 && tc_way3_hit_kid4 || tc_way3_hit_kid5);

assign tc_way2_hit = tc_way2_hit_kid0 && tc_way2_hit_kid1 && tc_way2_hit_kid2 && tc_way2_hit_kid6
                 && (tc_way2_hit_kid3 && tc_way2_hit_kid4 || tc_way2_hit_kid5);

assign tc_way1_hit = tc_way1_hit_kid0 && tc_way1_hit_kid1 && tc_way1_hit_kid2 && tc_way1_hit_kid6
                 && (tc_way1_hit_kid3 && tc_way1_hit_kid4 || tc_way1_hit_kid5);

assign tc_way0_hit = tc_way0_hit_kid0 && tc_way0_hit_kid1 && tc_way0_hit_kid2 && tc_way0_hit_kid6
                 && (tc_way0_hit_kid3 && tc_way0_hit_kid4 || tc_way0_hit_kid5);

// &CombBeg; @524
always @( ta_jtlb_fifo[3:0]
       or tc_jtlb_fifo[11:0]
       or stage_vld[0] // jtlb@pipe
       or stage_vld[1] // jtlb@pipe
       or stage_vld[2])// jtlb@pipe
begin
case({stage_vld[2], stage_vld[1], stage_vld[0]}) // jtlb@pipe
  3'b001:  ta_jtlb_fifo_upd[11:0] = {tc_jtlb_fifo[11:4], ta_jtlb_fifo[3:0]};
  3'b010:  ta_jtlb_fifo_upd[11:0] = {tc_jtlb_fifo[11:8], ta_jtlb_fifo[3:0], tc_jtlb_fifo[3:0]};
  3'b100:  ta_jtlb_fifo_upd[11:0] = {ta_jtlb_fifo[3:0], tc_jtlb_fifo[7:0]};
  default: ta_jtlb_fifo_upd[11:0] = {tc_jtlb_fifo[11:4], ta_jtlb_fifo[3:0]};
endcase
// &CombEnd; @531
end

always @(posedge jtlb_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    tc_vpn[VPN_WIDTH-1:0] <= {VPN_WIDTH{1'b0}};
    tc_asid[ASID_WIDTH-1:0] <= {ASID_WIDTH{1'b0}};
    tc_way_sel[3:0]       <= 4'b0;
    tc_jtlb_fifo[11:0]    <= 12'b0;
    tc_acc_type[2:0]      <= 3'b0;
    tc_wen                <= 1'b0;
    tc_cmp_va             <= 1'b0;
    tc_ptr[2:0]           <= 3'b0; // wjh@pfu
  end
  else if(ta_vld)
  begin
    tc_vpn[VPN_WIDTH-1:0] <= ta_vpn[VPN_WIDTH-1:0];
    tc_asid[ASID_WIDTH-1:0] <= ta_asid[ASID_WIDTH-1:0];
    tc_way_sel[3:0]       <= ta_idx_sel[3:0];
    tc_jtlb_fifo[11:0]    <= ta_jtlb_fifo_upd[11:0];
    tc_acc_type[2:0]      <= ta_acc_type[2:0];
    tc_wen                <= ta_wen;
    tc_cmp_va             <= ta_cmp_va;
    tc_ptr[2:0]           <= ta_ptr[2:0]; // wjh@pfu
  end
end

assign tc_hit_idx[1:0] = {2{tc_way3_hit}} & 2'b11
                       | {2{tc_way2_hit}} & 2'b10
                       | {2{tc_way1_hit}} & 2'b01
                       | {2{tc_way0_hit}} & 2'b00;

// 1. for ptw record fifo
// 2. for tlb_wr
assign jtlb_xx_fifo[11:0] = tc_jtlb_fifo[11:0];

//==========================================================
//                  PFN & Flag
//==========================================================
always @(posedge jtlb_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    tc_way3_vpn[VPN_WIDTH-1:0]   <= {VPN_WIDTH{1'b0}};
    tc_way3_pgs[PGS_WIDTH-1:0]   <= {PGS_WIDTH{1'b0}};
    tc_way3_asid[ASID_WIDTH-1:0] <= {ASID_WIDTH{1'b0}};
    tc_way3_g                    <= 1'b0;
    tc_way3_ppn[PPN_WIDTH-1:0]   <= {PPN_WIDTH{1'b0}};
    tc_way3_flg[FLG_WIDTH-1:0]   <= {FLG_WIDTH{1'b0}};
  end
  else if(ta_vld)
  begin
    tc_way3_vpn[VPN_WIDTH-1:0]   <= ta_way3_vpn[VPN_WIDTH-1:0];
    tc_way3_pgs[PGS_WIDTH-1:0]   <= ta_way3_pgs[PGS_WIDTH-1:0];
    tc_way3_asid[ASID_WIDTH-1:0] <= ta_way3_asid[ASID_WIDTH-1:0];
    tc_way3_g                    <= ta_way3_g;
    tc_way3_ppn[PPN_WIDTH-1:0]   <= ta_jtlb_way3_data[DATA_WIDTH-1:FLG_WIDTH];
    tc_way3_flg[FLG_WIDTH-1:0]   <= ta_jtlb_way3_data[FLG_WIDTH-1:0];
  end
end

always @(posedge jtlb_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    tc_way2_vpn[VPN_WIDTH-1:0]   <= {VPN_WIDTH{1'b0}};
    tc_way2_pgs[PGS_WIDTH-1:0]   <= {PGS_WIDTH{1'b0}};
    tc_way2_asid[ASID_WIDTH-1:0] <= {ASID_WIDTH{1'b0}};
    tc_way2_g                    <= 1'b0;
    tc_way2_ppn[PPN_WIDTH-1:0]   <= {PPN_WIDTH{1'b0}};
    tc_way2_flg[FLG_WIDTH-1:0]   <= {FLG_WIDTH{1'b0}};
  end
  else if(ta_vld)
  begin
    tc_way2_vpn[VPN_WIDTH-1:0]   <= ta_way2_vpn[VPN_WIDTH-1:0];
    tc_way2_pgs[PGS_WIDTH-1:0]   <= ta_way2_pgs[PGS_WIDTH-1:0];
    tc_way2_asid[ASID_WIDTH-1:0] <= ta_way2_asid[ASID_WIDTH-1:0];
    tc_way2_g                    <= ta_way2_g;
    tc_way2_ppn[PPN_WIDTH-1:0]   <= ta_jtlb_way2_data[DATA_WIDTH-1:FLG_WIDTH];
    tc_way2_flg[FLG_WIDTH-1:0]   <= ta_jtlb_way2_data[FLG_WIDTH-1:0];
  end
end

always @(posedge jtlb_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    tc_way1_vpn[VPN_WIDTH-1:0]   <= {VPN_WIDTH{1'b0}};
    tc_way1_pgs[PGS_WIDTH-1:0]   <= {PGS_WIDTH{1'b0}};
    tc_way1_asid[ASID_WIDTH-1:0] <= {ASID_WIDTH{1'b0}};
    tc_way1_g                    <= 1'b0;
    tc_way1_ppn[PPN_WIDTH-1:0]   <= {PPN_WIDTH{1'b0}};
    tc_way1_flg[FLG_WIDTH-1:0]   <= {FLG_WIDTH{1'b0}};
  end
  else if(ta_vld)
  begin
    tc_way1_vpn[VPN_WIDTH-1:0]   <= ta_way1_vpn[VPN_WIDTH-1:0];
    tc_way1_pgs[PGS_WIDTH-1:0]   <= ta_way1_pgs[PGS_WIDTH-1:0];
    tc_way1_asid[ASID_WIDTH-1:0] <= ta_way1_asid[ASID_WIDTH-1:0];
    tc_way1_g                    <= ta_way1_g;
    tc_way1_ppn[PPN_WIDTH-1:0]   <= ta_jtlb_way1_data[DATA_WIDTH-1:FLG_WIDTH];
    tc_way1_flg[FLG_WIDTH-1:0]   <= ta_jtlb_way1_data[FLG_WIDTH-1:0];
  end
end

always @(posedge jtlb_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    tc_way0_vpn[VPN_WIDTH-1:0]   <= {VPN_WIDTH{1'b0}};
    tc_way0_pgs[PGS_WIDTH-1:0]   <= {PGS_WIDTH{1'b0}};
    tc_way0_asid[ASID_WIDTH-1:0] <= {ASID_WIDTH{1'b0}};
    tc_way0_g                    <= 1'b0;
    tc_way0_ppn[PPN_WIDTH-1:0]   <= {PPN_WIDTH{1'b0}};
    tc_way0_flg[FLG_WIDTH-1:0]   <= {FLG_WIDTH{1'b0}};
  end
  else if(ta_vld)
  begin
    tc_way0_vpn[VPN_WIDTH-1:0]   <= ta_way0_vpn[VPN_WIDTH-1:0];
    tc_way0_pgs[PGS_WIDTH-1:0]   <= ta_way0_pgs[PGS_WIDTH-1:0];
    tc_way0_asid[ASID_WIDTH-1:0] <= ta_way0_asid[ASID_WIDTH-1:0];
    tc_way0_g                    <= ta_way0_g;
    tc_way0_ppn[PPN_WIDTH-1:0]   <= ta_jtlb_way0_data[DATA_WIDTH-1:FLG_WIDTH];
    tc_way0_flg[FLG_WIDTH-1:0]   <= ta_jtlb_way0_data[FLG_WIDTH-1:0];
  end
end

//==========================================================
// PTEs with different page sizes are mixed in JTLB.
// So the read of JTLB is split into three step:
// 1. Assume the requesting entry is 4K size
// 2. Assume the requesting entry is 2M size
// 3. Assume the requesting entry is 1G size
// After three steps, if still miss, there is a JTLB miss.
//==========================================================
//                  Read FSM
//==========================================================
parameter READ_IDLE    = 3'b000,
          READ_4K      = 3'b001,
          READ_4K_FAIL = 3'b101,
          READ_2M      = 3'b010,
          READ_2M_FAIL = 3'b110,
          READ_1G      = 3'b011;

// always @(posedge jtlb_clk or negedge cpurst_b)
// begin
//   if (!cpurst_b)
//     read_cur_st[2:0] <= READ_IDLE;
//   else
//     read_cur_st[2:0] <= read_nxt_st[2:0];
// end 

// &CombBeg; @682
// always @( read_cur_st
//        or arb_jtlb_cmp_with_va
//        or tc_vld
//        or tc_cmp_va
//        or tc_par_fail
//        or tc_tlb_miss
//        or arb_jtlb_acc_type[2:0])
// begin
// case (read_cur_st)
//   READ_IDLE:
//   begin
//     if(arb_jtlb_cmp_with_va && arb_jtlb_acc_type[2:0] != 3'b001)
//       read_nxt_st[2:0] = READ_4K;
//     else
//       read_nxt_st[2:0] = READ_IDLE;
//   end
//   READ_4K:
//   begin
//     if(tc_vld && tc_cmp_va)
//       if(tc_tlb_miss && !tc_par_fail)
//         read_nxt_st[2:0] = READ_2M;
//       else if(tc_par_fail)
//         read_nxt_st[2:0] = READ_4K_FAIL;
//       else
//         read_nxt_st[2:0] = READ_IDLE;
//     else
//       read_nxt_st[2:0] = READ_4K;
//   end
//   READ_2M:
//   begin
//     if(tc_vld && tc_cmp_va)
//       if(tc_tlb_miss && !tc_par_fail)
//         read_nxt_st[2:0] = READ_1G;
//       else if(tc_par_fail)
//         read_nxt_st[2:0] = READ_2M_FAIL;
//       else
//         read_nxt_st[2:0] = READ_IDLE;
//     else
//       read_nxt_st[2:0] = READ_2M;
//   end
//   READ_1G:
//   begin
//     if(tc_vld && tc_cmp_va)
//       read_nxt_st[2:0] = READ_IDLE;
//     else
//       read_nxt_st[2:0] = READ_1G;
//   end
//   READ_4K_FAIL: 
//     read_nxt_st[2:0] = READ_2M;
//   READ_2M_FAIL: 
//     read_nxt_st[2:0] = READ_1G;
//   default: 
//     read_nxt_st[2:0] = READ_IDLE;
// endcase
// // &CombEnd @729
// end

// assign read_cur_idle = read_cur_st[2:0] == READ_IDLE;
// assign read_cur_4k   = read_cur_st[2:0] == READ_4K;
// assign read_cur_2m   = read_cur_st[2:0] == READ_2M;
// assign read_cur_1g   = read_cur_st[2:0] == READ_1G;
// assign read_fail_4k  = read_cur_st[2:0] == READ_4K_FAIL;
// assign read_fail_2m  = read_cur_st[2:0] == READ_2M_FAIL;

// assign jtlb_arb_sel_4k = read_cur_idle;
// assign jtlb_arb_sel_2m = read_cur_4k && tc_vld && tc_cmp_va || read_fail_4k;
// assign jtlb_arb_sel_1g = read_cur_2m && tc_vld && tc_cmp_va || read_fail_2m;
// assign jtlb_arb_cmp_va = tc_cmp_va && !tc_par_fail || read_fail_4k || read_fail_2m;
// assign jtlb_arb_tc_miss = tc_tlb_miss || read_fail_4k || read_fail_2m;

// assign jtlb_arb_vpn[VPN_WIDTH-1:0] = tc_vpn[VPN_WIDTH-1:0];
// assign jtlb_arb_type[2:0]          = tc_acc_type[2:0];
// assign jtlb_arb_asid[15:0]         = tc_asid[15:0];
// assign jtlb_arb_ptr[2:0]           = tc_ptr[2:0]; // wjh@pfu
assign jtlb_arb_sel_4k  = !(|stage_vld);// jtlb@pipe
assign jtlb_arb_sel_2m  = 1'b0;         // jtlb@pipe // now only used for par_clr, 
assign jtlb_arb_sel_1g  = 1'b0;         // jtlb@pipe // now only used for par_clr, 
assign jtlb_arb_cmp_va  = 1'b0;         // jtlb@pipe
assign jtlb_arb_tc_miss = 1'b0;         // jtlb@pipe

assign jtlb_arb_vpn[VPN_WIDTH-1:0] = {VPN_WIDTH{1'b0}};// jtlb@pipe // for par_clr
assign jtlb_arb_type[2:0]          = 3'b0;             // jtlb@pipe
assign jtlb_arb_asid[15:0]         = 16'b0;            // jtlb@pipe
assign jtlb_arb_ptr[2:0]           = 3'b0;             // jtlb@pipe

//==========================================================
//                  Result Generation
//==========================================================
assign tc_hit_sum[2:0] = {2'b0,tc_way3_hit} + {2'b0,tc_way2_hit}
                       + {2'b0,tc_way1_hit} + {2'b0,tc_way0_hit}; 

assign tc_tlb_miss     = (tc_hit_sum[2:0] == 3'b000);
//assign tc_tlb_hit_raw  = (tc_hit_sum[2:0] == 3'b001);
assign tc_tlb_hit      = (tc_hit_sum[2:0] == 3'b001) && !tc_par_fail;
assign tc_tlb_hit_mult = !tc_tlb_miss && !tc_tlb_hit && !tc_par_fail;

// assign tc_tlb_miss_fin = (tc_vld && tc_cmp_va && tc_tlb_miss || tc_par_fail) && read_cur_1g;
assign tc_tlb_miss_fin = (tc_vld && tc_cmp_va && tc_tlb_miss || tc_par_fail) && stage_vld[3]; // jtlb@pipe
                       //|| tc_vld && tc_cmp_va && !tc_tlb_miss && tc_par_fail;

assign jtlb_xx_tc_read = !tc_wen;

// tc pa vld signal
assign tc_pa_vld = tc_vld && tc_tlb_hit;


assign tc_way3_sel = tc_way3_hit || tc_way_sel[3];
assign tc_way2_sel = tc_way2_hit || tc_way_sel[2];
assign tc_way1_sel = tc_way1_hit || tc_way_sel[1];
assign tc_way0_sel = tc_way0_hit || tc_way_sel[0];

// for tlbr
assign tc_idx_vpn[VPN_WIDTH-1:0] = {VPN_WIDTH{tc_way_sel[3]}} & tc_way3_vpn[VPN_WIDTH-1:0]
                                 | {VPN_WIDTH{tc_way_sel[2]}} & tc_way2_vpn[VPN_WIDTH-1:0]
                                 | {VPN_WIDTH{tc_way_sel[1]}} & tc_way1_vpn[VPN_WIDTH-1:0]
                                 | {VPN_WIDTH{tc_way_sel[0]}} & tc_way0_vpn[VPN_WIDTH-1:0];
assign tc_idx_pgs[PGS_WIDTH-1:0] = {PGS_WIDTH{tc_way_sel[3]}} & tc_way3_pgs[PGS_WIDTH-1:0]
                                 | {PGS_WIDTH{tc_way_sel[2]}} & tc_way2_pgs[PGS_WIDTH-1:0]
                                 | {PGS_WIDTH{tc_way_sel[1]}} & tc_way1_pgs[PGS_WIDTH-1:0]
                                 | {PGS_WIDTH{tc_way_sel[0]}} & tc_way0_pgs[PGS_WIDTH-1:0];
assign tc_idx_asid[ASID_WIDTH-1:0] = {ASID_WIDTH{tc_way_sel[3]}} & tc_way3_asid[ASID_WIDTH-1:0]
                                   | {ASID_WIDTH{tc_way_sel[2]}} & tc_way2_asid[ASID_WIDTH-1:0]
                                   | {ASID_WIDTH{tc_way_sel[1]}} & tc_way1_asid[ASID_WIDTH-1:0]
                                   | {ASID_WIDTH{tc_way_sel[0]}} & tc_way0_asid[ASID_WIDTH-1:0];
assign tc_idx_g          =     tc_way_sel[3]   & tc_way3_g
                         |     tc_way_sel[2]   & tc_way2_g 
                         |     tc_way_sel[1]   & tc_way1_g 
                         |     tc_way_sel[0]   & tc_way0_g;

assign tc_hit_ppn[PPN_WIDTH-1:0] = {PPN_WIDTH{tc_way3_sel}} & tc_way3_ppn[PPN_WIDTH-1:0]
                                 | {PPN_WIDTH{tc_way2_sel}} & tc_way2_ppn[PPN_WIDTH-1:0]
                                 | {PPN_WIDTH{tc_way1_sel}} & tc_way1_ppn[PPN_WIDTH-1:0]
                                 | {PPN_WIDTH{tc_way0_sel}} & tc_way0_ppn[PPN_WIDTH-1:0];
assign tc_hit_flg[FLG_WIDTH-1:0]  = {FLG_WIDTH{tc_way3_sel}} & tc_way3_flg[FLG_WIDTH-1:0]
                                  | {FLG_WIDTH{tc_way2_sel}} & tc_way2_flg[FLG_WIDTH-1:0]
                                  | {FLG_WIDTH{tc_way1_sel}} & tc_way1_flg[FLG_WIDTH-1:0]
                                  | {FLG_WIDTH{tc_way0_sel}} & tc_way0_flg[FLG_WIDTH-1:0];

//----------------------------------------------------------
//                  Req to ARB to invalid Parity Fail entry
//----------------------------------------------------------
assign jtlb_arb_par_clr = 1'b0; // jtlb@pipe

//----------------------------------------------------------
//                  Req to PTW 
//----------------------------------------------------------
assign jtlb_ptw_req = tc_vld && cp0_mmu_ptw_en && tc_tlb_miss_fin 
                   && {tc_acc_type[1] || tc_acc_type[2]};
assign jtlb_ptw_vpn[VPN_WIDTH-1:0] = tc_vpn[VPN_WIDTH-1:0];
assign jtlb_ptw_asid[ASID_WIDTH-1:0] = tc_asid[ASID_WIDTH-1:0];
assign jtlb_ptw_type[2:0] = tc_acc_type[2:0];
assign jtlb_ptw_ptr[2:0]  = tc_ptr[2:0];
assign jtlb_iutlb_cmplt = tc_utlb_cmplt && (tc_acc_type[2:0] == 3'b011);
assign jtlb_dutlb_cmplt = tc_utlb_cmplt && (tc_acc_type[1:0] == 2'b10);
assign jtlb_pfuhit_cmplt   = tc_vld && (tc_tlb_hit
                                       || tc_tlb_hit_mult 
                                       || !cp0_mmu_ptw_en && tc_tlb_miss_fin)
                                   && (tc_acc_type[2:0] == 3'b100);
assign jtlb_ptw_has_cmplt = jtlb_iutlb_cmplt
                            || jtlb_dutlb_cmplt
                            || jtlb_pfuhit_cmplt
                            || pfu_mmu_off_req;
                                          
//----------------------------------------------------------
//                  Result to TLB oper
//----------------------------------------------------------
// cmplt
assign jtlb_tlboper_cmplt = tc_vld && (tc_acc_type[2:0] == 3'b001);

// tlb read idle
// assign jtlb_tlboper_read_idle = read_cur_idle;
assign jtlb_tlboper_read_idle = !(|stage_vld); // jtlb@pipe

// for tlbp
assign jtlb_regs_hit                 = tc_tlb_hit; 
assign jtlb_regs_hit_mult            = tc_tlb_hit_mult;

assign tc_vpn_4k[VPN_WIDTH-1:0] =  tc_vpn[VPN_WIDTH-1:0];
assign tc_vpn_2m[VPN_WIDTH-1:0] = {{VPN_PERLEL*1{1'b0}}, tc_vpn[VPN_WIDTH-1:VPN_PERLEL*1]};
assign tc_vpn_1g[VPN_WIDTH-1:0] = {{VPN_PERLEL*2{1'b0}}, tc_vpn[VPN_WIDTH-1:VPN_PERLEL*2]};
assign tc_vpn_masked[VPN_WIDTH-1:0] = {VPN_WIDTH{tlboper_xx_pgs[0]}} & tc_vpn_4k[VPN_WIDTH-1:0]
                                    | {VPN_WIDTH{tlboper_xx_pgs[1]}} & tc_vpn_2m[VPN_WIDTH-1:0]
                                    | {VPN_WIDTH{tlboper_xx_pgs[2]}} & tc_vpn_1g[VPN_WIDTH-1:0];
assign jtlb_regs_tlbp_hit_index[10:0] = {1'b0, tc_hit_idx[1:0], tc_vpn_masked[7:0]};

// for tlbr
assign jtlb_tlbr_vpn[VPN_WIDTH-1:0]   = tc_idx_vpn[VPN_WIDTH-1:0];
assign jtlb_tlbr_pgs[PGS_WIDTH-1:0]   = tc_idx_pgs[PGS_WIDTH-1:0];
assign jtlb_tlbr_asid[ASID_WIDTH-1:0] = tc_idx_asid[ASID_WIDTH-1:0];
assign jtlb_tlbr_ppn[PPN_WIDTH-1:0]   = tc_hit_ppn[PPN_WIDTH-1:0];
assign jtlb_tlbr_flg[FLG_WIDTH-1:0]   = tc_hit_flg[FLG_WIDTH-1:0];
assign jtlb_tlbr_g                    = tc_idx_g;

//for inv asid
assign jtlb_tlboper_asid_hit = (tc_idx_asid[ASID_WIDTH-1:0] == tlboper_jtlb_inv_asid[ASID_WIDTH-1:0]) && !tc_idx_g;
// wen sel for tlbwr and invva
assign jtlb_tlboper_fifo[3:0] = tc_jtlb_fifo[3:0];
assign jtlb_tlboper_sel[3:0] = tlboper_jtlb_tlbwr_on ? tc_jtlb_fifo[3:0]
                                                     : {tc_way3_hit,
                                                        tc_way2_hit,
                                                        tc_way1_hit,
                                                        tc_way0_hit};
assign jtlb_tlboper_va_hit = tc_way3_hit || tc_way2_hit || tc_way1_hit || tc_way0_hit;

//----------------------------------------------------------
//                  Result to uTLB
//----------------------------------------------------------
assign tc_utlb_cmplt        = tc_vld && !tc_par_fail
                           && (!cp0_mmu_ptw_en && stage_vld[3] // jtlb@pipe //read_cur_1g
                              || !tc_tlb_miss);
assign jtlb_iutlb_ref_cmplt = tc_utlb_cmplt     
                                 && (tc_acc_type[2:0] == 3'b011)
                           || ptw_jtlb_ref_cmplt
                                 && ptw_jtlb_imiss; 

assign jtlb_iutlb_ref_pavld = tc_pa_vld
                                 && (tc_acc_type[2:0] == 3'b011)
                           || ptw_jtlb_ref_data_vld
                                 && ptw_jtlb_imiss;

assign jtlb_iutlb_acc_err   = ptw_jtlb_ref_acc_err
                                 && ptw_jtlb_imiss;

assign jtlb_iutlb_pgflt     = ptw_jtlb_ref_pgflt
                                 && ptw_jtlb_imiss
                           || tc_vld && tc_tlb_hit_mult
                                 && (tc_acc_type[2:0] == 3'b011)
                           || tc_vld && !cp0_mmu_ptw_en && tc_tlb_miss_fin
                                 && (tc_acc_type[2:0] == 3'b011);


assign jtlb_dutlb_ref_cmplt = tc_utlb_cmplt 
                                 && (tc_acc_type[1:0] == 2'b10)
                           || ptw_jtlb_ref_cmplt
                                 && ptw_jtlb_dmiss;

assign jtlb_dutlb_ref_pavld = tc_pa_vld
                                 && (tc_acc_type[1:0] == 2'b10)
                           || ptw_jtlb_ref_data_vld
                                 && ptw_jtlb_dmiss;

assign jtlb_dutlb_pgflt     = ptw_jtlb_ref_pgflt
                                 && ptw_jtlb_dmiss
                           || tc_vld && tc_tlb_hit_mult 
                                 && (tc_acc_type[1:0] == 2'b10)
                           || tc_vld && !cp0_mmu_ptw_en && tc_tlb_miss_fin
                                 && (tc_acc_type[1:0] == 2'b10);

assign jtlb_dutlb_acc_err   = ptw_jtlb_ref_acc_err
                                 && ptw_jtlb_dmiss;


//==========================================================
//                  Read FSM
//==========================================================
// the following logics now goto pfu
// parameter PFU_IDLE = 2'b00,
//           PFU_CHK  = 2'b01,
//           PFU_DENY = 2'b10,
//           PFU_OK   = 2'b11;

// always @(posedge jtlb_clk or negedge cpurst_b)
// begin
//   if (!cpurst_b)
//     pfu_cur_st[1:0] <= PFU_IDLE;
//   else
//     pfu_cur_st[1:0] <= pfu_nxt_st[1:0];
// end 

// // &CombBeg; @923
// always @( jtlb_pfu_acc_fault
//        or jtlb_pfu_cmplt
//        or jtlb_pfu_deny
//        or pfu_cur_st[1:0])
// begin
// case (pfu_cur_st[1:0])
//   PFU_IDLE:
//   begin
//     if(jtlb_pfu_cmplt)
//       if(jtlb_pfu_acc_fault)
//         pfu_nxt_st[1:0] = PFU_DENY;
//       else
//         pfu_nxt_st[1:0] = PFU_CHK;
//     else
//       pfu_nxt_st[1:0] = PFU_IDLE;
//   end
//   PFU_CHK:
//   begin
//     if(jtlb_pfu_deny)
//       pfu_nxt_st[1:0] = PFU_DENY;
//     else
//       pfu_nxt_st[1:0] = PFU_OK;
//   end
//   PFU_DENY:
//   begin
//     pfu_nxt_st[1:0] = PFU_IDLE;
//   end
//   PFU_OK:
//   begin
//     pfu_nxt_st[1:0] = PFU_IDLE;
//   end
//   default:
//   begin
//     pfu_nxt_st[1:0] = PFU_IDLE;
//   end
// endcase
// // &CombEnd; @955
// end

// &Force("input", "dutlb_xx_mmu_off"); @957
assign pfu_mmu_off_req = arb_jtlb_pfu_grant && (lsu_mmu_va2_priv_mode[1:0] == 2'b11 || !regs_mmu_en);
assign pfu_mmu_off = !pfu_priv_mode[2] || pfu_priv_mode[1:0] == 2'b11;

always @(posedge jtlb_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    pfu_priv_mode[2:0] <= 3'b000;
  else if(arb_jtlb_pfu_grant)
    pfu_priv_mode[2:0] <= {regs_mmu_en, lsu_mmu_va2_priv_mode[1:0]};
end 
// the following now goto pfu-entry
// assign pfu_idle_st = pfu_cur_st[1:0] == PFU_IDLE;
// assign pfu_deny_st = pfu_cur_st[1:0] == PFU_DENY;
// assign pfu_ok_st   = pfu_cur_st[1:0] == PFU_OK;

assign jtlb_pfu_cmplt     = tc_vld && (tc_tlb_hit
                                    || tc_tlb_hit_mult 
                                    || !cp0_mmu_ptw_en && tc_tlb_miss_fin)
                                 && (tc_acc_type[2:0] == 3'b100)
                           || ptw_jtlb_ref_cmplt && ptw_jtlb_pmiss
                           || pfu_mmu_off_req;

assign jtlb_pfu_flag_fault =  !tc_hit_flg[0]
                           || !tc_hit_flg[1] && tc_hit_flg[2]
                           || !tc_hit_flg[1] && !(cp0_mmu_mxr && tc_hit_flg[3])
                           ||  tc_hit_flg[4] && pfu_supv_mode && !cp0_mmu_sum
                           || !tc_hit_flg[4] && pfu_user_mode
                           || !tc_hit_flg[5]
                           || (cp0_mmu_maee ? (tc_hit_flg[13] || !tc_hit_flg[12])
                                            : (sysmap_mmu_flg4[4] || !sysmap_mmu_flg4[3]));

assign jtlb_pfu_acc_fault = tc_vld && (tc_tlb_hit_mult 
                                       || !cp0_mmu_ptw_en && tc_tlb_miss_fin)
                                 && (tc_acc_type[2:0] == 3'b100)
                           || tc_pa_vld && (tc_acc_type[2:0] == 3'b100)
                              && jtlb_pfu_flag_fault
                           || pfu_mmu_off_req
                              && (sysmap_mmu_flg4[4] || !sysmap_mmu_flg4[3])
                           || ptw_jtlb_ref_cmplt && ptw_jtlb_pmiss
                              && (ptw_jtlb_ref_flg[13] || !ptw_jtlb_ref_flg[12] 
                                 || ptw_jtlb_ref_pgflt || ptw_jtlb_ref_acc_err);


// &Force("bus", "sysmap_mmu_flg4", 4, 0); @1001
assign pa_offset[VPN_WIDTH-1:0]   = lsu_mmu_va2[VPN_WIDTH-1:0];
assign ptw_pa2[PPN_WIDTH-1:0]     = 
     {PPN_WIDTH{ref_pgs[2]}} & {ref_ppn[PPN_WIDTH-1:VPN_PERLEL*2], pa_offset[VPN_PERLEL*2-1:0]}
   | {PPN_WIDTH{ref_pgs[1]}} & {ref_ppn[PPN_WIDTH-1:VPN_PERLEL*1], pa_offset[VPN_PERLEL*1-1:0]}
   | {PPN_WIDTH{ref_pgs[0]}} &  ref_ppn[PPN_WIDTH-1:0];

assign jtlb_pfu_pa[PPN_WIDTH-1:0] =  pfu_mmu_off_req ? lsu_mmu_va2[PPN_WIDTH-1:0] 
                                                 : ptw_pa2[PPN_WIDTH-1:0];
assign jtlb_pfu_sec               = (pfu_mmu_off_req || !cp0_mmu_maee) ? sysmap_mmu_flg4[0] : ref_flg[9];
assign jtlb_pfu_share             = (pfu_mmu_off_req || !cp0_mmu_maee) ? sysmap_mmu_flg4[1] : ref_flg[10];
assign jtlb_pfu_ptr               = (pfu_mmu_off_req ) ? arb_jtlb_ptr[2:0]  : ref_ptr[2:0]; // wjh@pfu
// the following logics goto pfu_entry
// flop pa for pmp check
// always @(posedge jtlb_clk or negedge cpurst_b)
// begin
//   if(!cpurst_b)
//   begin
//     pfu_pa_buf[PPN_WIDTH-1:0] <= {PPN_WIDTH{1'b0}};
//     pfu_sec_buf               <= 1'b0;
//     pfu_share_buf             <= 1'b0;
//   end
//   else if(pfu_idle_st && jtlb_pfu_cmplt)
//   begin
//     pfu_pa_buf[PPN_WIDTH-1:0] <= jtlb_pfu_pa[PPN_WIDTH-1:0];
//     pfu_sec_buf               <= jtlb_pfu_sec;
//     pfu_share_buf             <= jtlb_pfu_share;
//   end
// end

// result to arb
// assign jtlb_arb_pfu_cmplt = (pfu_ok_st || pfu_deny_st) && !pfu_mmu_off;
assign jtlb_arb_pfu_cmplt = tc_vld && (tc_tlb_hit
                                       || tc_tlb_hit_mult
                                       || tc_tlb_miss_fin)
                                   && (tc_acc_type[2:0] == 3'b100); // now arb's arb_nxt_st will be IDLE if arb_cur_st=ARB_PFU and jtlb process is ended
assign jtlb_arb_pfu_vpn[VPN_WIDTH-1:0] = lsu_mmu_va2[VPN_WIDTH-1:0];

// addr to pmp, now the following is given by pfu
// assign mmu_pmp_pa4[PPN_WIDTH-1:0] = pfu_pa_buf[PPN_WIDTH-1:0];

// addr to sysmap
assign mmu_sysmap_pa4[PPN_WIDTH-1:0] = lsu_mmu_va2[PPN_WIDTH-1:0];

// pmp result
assign pfu_user_mode = pfu_priv_mode[1:0] == 2'b00;
assign pfu_supv_mode = pfu_priv_mode[1:0] == 2'b01;
assign pfu_mach_mode = pfu_priv_mode[1:0] == 2'b11;

// &Force("bus", "pmp_mmu_flg4", 3, 0); @1045
// now the following logics goto pfu-entry, wjh@pfu
// assign jtlb_pfu_deny = !pmp_mmu_flg4[0]
//                      && !(pfu_mach_mode && !pmp_mmu_flg4[3]);  // L-bit for M-Mode

// result to lsu pfu
// the following logics not goto pfu wjh@pfu
// assign mmu_lsu_pa2_vld    = pfu_ok_st || pfu_deny_st;
// assign mmu_lsu_pa2_err    = pfu_deny_st;
// assign mmu_lsu_pa2[PPN_WIDTH-1:0] = pfu_pa_buf[PPN_WIDTH-1:0];
// assign mmu_lsu_sec2   = pfu_sec_buf;
// assign mmu_lsu_share2 = pfu_share_buf;

//vpn & ppn & flag
assign ref_vpn[VPN_WIDTH-1:0] = ptw_jtlb_ref_cmplt ? ptw_arb_vpn[VPN_WIDTH-1:0]
                                          : tc_vpn[VPN_WIDTH-1:0];
assign ref_pgs[PGS_WIDTH-1:0] = ptw_jtlb_ref_cmplt ? ptw_jtlb_ref_pgs[PGS_WIDTH-1:0]
                                          : {stage_vld[3], stage_vld[2], stage_vld[1]}; // // jtlb@pipe jtlb_cur_pgs[PGS_WIDTH-1:0];
assign ref_ppn[PPN_WIDTH-1:0] = ptw_jtlb_ref_cmplt ? ptw_jtlb_ref_ppn[PPN_WIDTH-1:0]
                                          : tc_hit_ppn[PPN_WIDTH-1:0];
assign ref_flg[FLG_WIDTH-1:0] = ptw_jtlb_ref_cmplt ? ptw_jtlb_ref_flg[FLG_WIDTH-1:0]
                                               : tc_hit_flg[FLG_WIDTH-1:0];
assign ref_ptr[2:0]           = ptw_jtlb_ref_cmplt ? ptw_jtlb_ref_ptr[2:0] : tc_ptr[2:0]; // wjh@pfu
assign jtlb_utlb_ref_vpn[VPN_WIDTH-1:0] = ref_vpn[VPN_WIDTH-1:0]; 
assign jtlb_utlb_ref_pgs[PGS_WIDTH-1:0] = ref_pgs[PGS_WIDTH-1:0]; 

assign jtlb_utlb_ref_ppn[PPN_WIDTH-1:0] = ref_ppn[PPN_WIDTH-1:0];
assign jtlb_utlb_ref_flg[FLG_WIDTH-1:0] = ref_flg[FLG_WIDTH-1:0];

assign jtlb_top_cur_st[1:0] = 2'b0; //read_cur_st[1:0];

assign jtlb_top_utlb_pavld = tc_pa_vld || ptw_jtlb_ref_data_vld;


// &ModuleEnd; @1084
endmodule


