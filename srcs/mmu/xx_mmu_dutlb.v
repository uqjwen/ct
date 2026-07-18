//-----------------------------------------------------------------------------
// File          : xx_mmu_dutlb.v
// Created       : 2024/10/01 (by Li Shuo)
// Last modified : 2024/11/19 (by Huang chenglong)
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
// 2024/11/19 : Added 3 LSU related requests and response
//-----------------------------------------------------------------------------

//#
//# Module Declaration
//# ==================
//#


// $Id: xx_mmu_dutlb.vp,v 1.49 2022/01/06 08:14:36 jizk Exp $
// *****************************************************************************

// &ModuleBeg; @29
module xx_mmu_dutlb #(
  parameter LSIQENTRY=12,
  parameter IID_WIDTH=7
)(
 arb_dutlb_grant,
  biu_mmu_smp_disable,
  cp0_mmu_icg_en,
  cp0_mmu_mpp,
  cp0_mmu_mprv,
  cp0_mmu_mxr,
  cp0_mmu_pa_equal_va,
  cp0_mmu_sum,
  cp0_yy_priv_mode,
  cpurst_b,
  dutlb_arb_cmplt,
  dutlb_arb_load,
  dutlb_arb_req,
  dutlb_arb_vpn,
  dutlb_ptw_wfc,
  dutlb_top_ref_cur_st,
  dutlb_top_ref_type,
  dutlb_top_scd_updt,
  dutlb_xx_mmu_off,
  forever_cpuclk,
  hpcp_mmu_cnt_en,
  jtlb_dutlb_acc_err,
  jtlb_dutlb_pgflt,
  jtlb_dutlb_ref_cmplt,
  jtlb_dutlb_ref_pavld,
  jtlb_utlb_ref_flg,
  jtlb_utlb_ref_pgs,
  jtlb_utlb_ref_ppn,
  jtlb_utlb_ref_vpn,
  ptw_tmq_va_hit,
  lsag0_ex1_is_load,
  lsag1_ex1_is_load,
  lsu_mmu_abort0,

  lsu_mmu_abort2,
  lsu_mmu_abort3,
  lsu_mmu_id0,

  lsu_mmu_id2,
  lsu_mmu_id3,
  lsu_mmu_st_inst0,

  lsu_mmu_st_inst2,
  lsu_mmu_st_inst3,
  // lsu_mmu_stamo_pa,
  // lsu_mmu_stamo_vld,
  lsu_mmu_stamo_pa2,
  lsu_mmu_stamo_vld2,
  lsu_mmu_stamo_pa3,
  lsu_mmu_stamo_vld3,
  lsu_mmu_tlb_va,
  lsu_mmu_va0,
  lsu_mmu_va0_vld,

  lsu_mmu_va2,
  lsu_mmu_va2_vld,
  lsu_mmu_va3,
  lsu_mmu_va3_vld,
  lsu_mmu_vabuf0,

  lsu_mmu_vabuf2,
  lsu_mmu_vabuf3,
  lsu_mmu_old0,
  lsu_mmu_old2,
  lsu_mmu_old3,
  mmu_hpcp_dutlb_miss,
  mmu_lsu_access_fault0,

  mmu_lsu_access_fault2,
  mmu_lsu_access_fault3,
  mmu_lsu_buf0,
 
  mmu_lsu_buf2,
  mmu_lsu_buf3,
  mmu_lsu_ca0,

  mmu_lsu_ca2,
  mmu_lsu_ca3,
  mmu_lsu_pa0,
  mmu_lsu_pa0_vld,

  mmu_lsu_pa2,
  mmu_lsu_pa2_vld,
  mmu_lsu_pa3,
  mmu_lsu_pa3_vld,
  mmu_lsu_page_fault0,

  mmu_lsu_page_fault2,
  mmu_lsu_page_fault3,
  mmu_lsu_sec0,

  mmu_lsu_sec2,
  mmu_lsu_sec3,
  mmu_lsu_sh0,

  mmu_lsu_sh2,
  mmu_lsu_sh3,
  mmu_lsu_so0,

  mmu_lsu_so2,
  mmu_lsu_so3,
  mmu_lsu_stall0,

  mmu_lsu_stall2,
  mmu_lsu_stall3,
  mmu_lsu_tlb_busy,
  mmu_lsu_tlb_wakeup,
  mmu_lsu_async_wakeup0, // wjh@tmq
  mmu_lsu_async_wakeup2, // wjh@tmq
  mmu_lsu_async_wakeup3, // wjh@tmq
  mmu_lsu_imme_wakeup0, // wjh@tmq
  mmu_lsu_imme_wakeup2, // wjh@tmq
  mmu_lsu_imme_wakeup3, // wjh@tmq
  lsu_mmu_lsid0, // wjh@tmq
  lsu_mmu_lsid2, // wjh@tmq
  lsu_mmu_lsid3, // wjh@tmq
  mmu_pmp_pa0,

  mmu_pmp_pa00,
  mmu_pmp_pa10,
  mmu_sysmap_pa0,

  mmu_sysmap_pa00,
  mmu_sysmap_pa10,
  pad_yy_icg_scan_en,
  pmp_mmu_flg0,

  pmp_mmu_flg00,
  pmp_mmu_flg10,
  regs_mmu_en,
  mmu_sv48_en,
  regs_utlb_clr,
  rtu_yy_xx_flush,
  rtu_ck_flush,
  rtu_ck_flush_iid,
  sysmap_mmu_flg0,

  sysmap_mmu_flg00,
  sysmap_mmu_flg10,
  tlboper_utlb_clr,
  tlboper_utlb_inv_va_req,
  utlb_clk
);
// parameter IID_WIDTH = 7;
parameter TMQ_NUM   = 8;
//parameter LSIQENTRY= 12;
// &Ports; @30
input           arb_dutlb_grant;         
input           biu_mmu_smp_disable;     
input           cp0_mmu_icg_en;          
input   [1 :0]  cp0_mmu_mpp;             
input           cp0_mmu_mprv;            
input           cp0_mmu_mxr;             
input           cp0_mmu_pa_equal_va;     
input           cp0_mmu_sum;             
input   [1 :0]  cp0_yy_priv_mode;        
input           cpurst_b;                
input           forever_cpuclk;          
input           hpcp_mmu_cnt_en;         
input           jtlb_dutlb_acc_err;      
input           jtlb_dutlb_pgflt;        
input           jtlb_dutlb_ref_cmplt;    
input           jtlb_dutlb_ref_pavld;    
input   [13:0]  jtlb_utlb_ref_flg;       
input   [2 :0]  jtlb_utlb_ref_pgs;       
input   [`WK_PPN_WIDTH-1:0]  jtlb_utlb_ref_ppn;       
input   [`WK_VPN_WIDTH-1:0]  jtlb_utlb_ref_vpn;       
input           ptw_tmq_va_hit;
input           lsag0_ex1_is_load;
input           lsag1_ex1_is_load;
input           lsu_mmu_abort0;          
          
input           lsu_mmu_abort2;          
input           lsu_mmu_abort3;          
input   [IID_WIDTH-1 :0]  lsu_mmu_id0;             
             
input   [IID_WIDTH-1 :0]  lsu_mmu_id2;             
input   [IID_WIDTH-1 :0]  lsu_mmu_id3;             
input           lsu_mmu_st_inst0;        
        
input           lsu_mmu_st_inst2;        
input           lsu_mmu_st_inst3;        
// input   [27:0]  lsu_mmu_stamo_pa;        
// input           lsu_mmu_stamo_vld;       
input   [`WK_PPN_WIDTH-1:0]  lsu_mmu_stamo_pa2;        // corresponding to ls0 signal
input                        lsu_mmu_stamo_vld2;       // corresponding to ls0 signal 
input   [`WK_PPN_WIDTH-1:0]  lsu_mmu_stamo_pa3;        // corresponding to ls1 signal
input           lsu_mmu_stamo_vld3;       // corresponding to ls1 signal
input   [`WK_VPN_WIDTH-1:0]  lsu_mmu_tlb_va;          
input   [63:0]  lsu_mmu_va0;             
input           lsu_mmu_va0_vld;         
        
input   [63:0]  lsu_mmu_va2;             
input           lsu_mmu_va2_vld;         
input   [63:0]  lsu_mmu_va3;             
input           lsu_mmu_va3_vld;         
input   [`WK_PPN_WIDTH-1:0]  lsu_mmu_vabuf0;          
         
input   [`WK_PPN_WIDTH-1:0]  lsu_mmu_vabuf2;          
input   [`WK_PPN_WIDTH-1:0]  lsu_mmu_vabuf3;          
input           lsu_mmu_old0;
input           lsu_mmu_old2;
input           lsu_mmu_old3;
input           pad_yy_icg_scan_en;      
input   [3 :0]  pmp_mmu_flg0;            
           
input   [3 :0]  pmp_mmu_flg00;            
input   [3 :0]  pmp_mmu_flg10;            
input           regs_mmu_en; 
input           mmu_sv48_en;            
input           regs_utlb_clr;           
input           rtu_yy_xx_flush;         
input           rtu_ck_flush;
input   [IID_WIDTH-1:0] rtu_ck_flush_iid;
input   [4 :0]  sysmap_mmu_flg0;         
         
input   [4 :0]  sysmap_mmu_flg00;         
input   [4 :0]  sysmap_mmu_flg10;         
input           tlboper_utlb_clr;        
input           tlboper_utlb_inv_va_req; 
input           utlb_clk;                
output          dutlb_arb_cmplt;         
output          dutlb_arb_load;          
output          dutlb_arb_req;           
output  [`WK_VPN_WIDTH-1:0]  dutlb_arb_vpn;           
output          dutlb_ptw_wfc;           
output  [2 :0]  dutlb_top_ref_cur_st;    
output          dutlb_top_ref_type;      
output          dutlb_top_scd_updt;      
output          dutlb_xx_mmu_off;        
output          mmu_hpcp_dutlb_miss;     
output          mmu_lsu_access_fault0;   
  
output          mmu_lsu_access_fault2;   
output          mmu_lsu_access_fault3;   
output          mmu_lsu_buf0;            
            
output          mmu_lsu_buf2;            
output          mmu_lsu_buf3;            
output          mmu_lsu_ca0;             
            
output          mmu_lsu_ca2;             
output          mmu_lsu_ca3;             
output  [`WK_PPN_WIDTH-1:0]  mmu_lsu_pa0;             
output                       mmu_lsu_pa0_vld;         
        
output  [`WK_PPN_WIDTH-1:0]  mmu_lsu_pa2;             
output                       mmu_lsu_pa2_vld;         
output  [`WK_PPN_WIDTH-1:0]  mmu_lsu_pa3;             
output                       mmu_lsu_pa3_vld;         
output          mmu_lsu_page_fault0;     
    
output          mmu_lsu_page_fault2;     
output          mmu_lsu_page_fault3;     
output          mmu_lsu_sec0;            
            
output          mmu_lsu_sec2;            
output          mmu_lsu_sec3;            
output          mmu_lsu_sh0;             
            
output          mmu_lsu_sh2;             
output          mmu_lsu_sh3;             
output          mmu_lsu_so0;             
             
output          mmu_lsu_so2;             
output          mmu_lsu_so3;             
output          mmu_lsu_stall0;          
         
output          mmu_lsu_stall2;          
output          mmu_lsu_stall3;          
output          mmu_lsu_tlb_busy;        
output  [LSIQENTRY-1:0]  mmu_lsu_tlb_wakeup;      
output  [LSIQENTRY-1:0] mmu_lsu_async_wakeup0; // wjh@tmq
output  [LSIQENTRY-1:0] mmu_lsu_async_wakeup2; // wjh@tmq
output  [LSIQENTRY-1:0] mmu_lsu_async_wakeup3; // wjh@tmq
output                   mmu_lsu_imme_wakeup0;  // wjh@tmq
output                   mmu_lsu_imme_wakeup2;  // wjh@tmq 
output                   mmu_lsu_imme_wakeup3;  // wjh@tmq 
input   [LSIQENTRY-1:0] lsu_mmu_lsid0;    // wjh@tmq
input   [LSIQENTRY-1:0] lsu_mmu_lsid2;    // wjh@tmq
input   [LSIQENTRY-1:0] lsu_mmu_lsid3;    // wjh@tmq
output  [`WK_PPN_WIDTH-1:0]  mmu_pmp_pa0;             
             
output  [`WK_PPN_WIDTH-1:0]  mmu_pmp_pa00;             
output  [`WK_PPN_WIDTH-1:0]  mmu_pmp_pa10;             
output  [`WK_PPN_WIDTH-1:0]  mmu_sysmap_pa0;          
          
output  [`WK_PPN_WIDTH-1:0]  mmu_sysmap_pa00;          
output  [`WK_PPN_WIDTH-1:0]  mmu_sysmap_pa10;          

// &Regs; @31
reg             dutlb_miss;              
reg     [2 :0]  ref_cur_st;              
reg     [2 :0]  ref_nxt_st;              
reg     [IID_WIDTH-1 :0]  refill_id_flop0;         
         
reg     [IID_WIDTH-1 :0]  refill_id_flop2;         
reg     [IID_WIDTH-1 :0]  refill_id_flop3;         
reg     refill_read;                          
reg     [`WK_VPN_WIDTH-1:0]  refill_va_flop0;         
         
reg     [`WK_VPN_WIDTH-1:0]  refill_va_flop2;         
reg     [`WK_VPN_WIDTH-1:0]  refill_va_flop3;         

// &Wires; @32
wire            arb_dutlb_grant;         
wire            biu_mmu_smp_disable;     
wire            cp0_mach_mode;           
wire            cp0_mmu_icg_en;          
wire    [1 :0]  cp0_mmu_mpp;             
wire            cp0_mmu_mprv;            
wire            cp0_mmu_mxr;             
wire            cp0_mmu_pa_equal_va;     
wire            cp0_mmu_sum;             
wire    [1 :0]  cp0_priv_mode;           
wire            cp0_supv_mode;           
wire            cp0_user_mode;           
wire    [1 :0]  cp0_yy_priv_mode;        
wire            cpurst_b;                
wire            dplru_clk;               
wire            dplru_clk_en;            
wire            dutlb_acc_flt0;          
          
wire            dutlb_acc_flt2;          
wire            dutlb_acc_flt3;          
wire            dutlb_arb_cmplt;         
wire            dutlb_arb_load;          
wire            dutlb_arb_req;           
wire    [`WK_VPN_WIDTH-1:0]  dutlb_arb_vpn;           
wire            dutlb_clk;               
wire            dutlb_clk_en;            
wire            dutlb_expt_for_taken;    
wire            dutlb_inst_vpn_match;     
wire            dutlb_inst_vpn_match0;    
    
wire            dutlb_inst_vpn_match2;    
wire            dutlb_inst_vpn_match3;    
wire            dutlb_inst_id_older;     
wire            dutlb_inst_id_older0;    
    
wire            dutlb_inst_id_older2;    
wire            dutlb_inst_id_older3;    
wire            dutlb_miss_cnt;          
wire            dutlb_miss_vld;          
wire            dutlb_miss_vld0;         
        
wire            dutlb_miss_vld2;         
wire            dutlb_miss_vld3;         
wire            dutlb_miss_vld_short0;   
  
wire            dutlb_miss_vld_short2;   
wire            dutlb_miss_vld_short3;   
wire            dutlb_off_hit;           
wire            dutlb_ori_read0;         
         
wire            dutlb_ori_read2;         
wire            dutlb_ori_read3;         
wire    [15:0]  dutlb_plru_read_hit0;    
    
wire    [15:0]  dutlb_plru_read_hit2;    
wire    [15:0]  dutlb_plru_read_hit3;    
wire            dutlb_plru_read_hit_vld0; 

wire            dutlb_plru_read_hit_vld2; 
wire            dutlb_plru_read_hit_vld3; 
wire            dutlb_plru_refill_on;    
wire            dutlb_plru_refill_vld;   
wire            dutlb_ptw_wfc;           
wire            dutlb_read_type0;        
        
wire            dutlb_read_type2;        
wire            dutlb_read_type3;        
wire            dutlb_ref_acflt;         
wire            dutlb_ref_pgflt;         
wire            dutlb_refill_idle;       
wire            dutlb_refill_on;         
wire            dutlb_refill_on0;        
        
wire            dutlb_refill_on2;        
wire            dutlb_refill_on3;        
wire            dutlb_refill_upd0;       
       
wire            dutlb_refill_upd2;       
wire            dutlb_refill_upd3;       
wire            dutlb_refill_vld;        
     
wire            dutlb_req_id02_older;     
wire            dutlb_req_id03_older;     
     
wire            dutlb_req_id23_older;     
wire    [2 :0]  dutlb_top_ref_cur_st;    
wire            dutlb_top_ref_type;      
wire            dutlb_top_scd_updt;      
wire            dutlb_va_chg0;           
          
wire            dutlb_va_chg2;           
wire            dutlb_va_chg3;           
wire            dutlb_wfc;               
wire            dutlb_xx_mmu_off;        
wire    [13:0]  entry0_flg;              
wire            entry0_hit0;             
            
wire            entry0_hit2;             
wire            entry0_hit3;             
wire    [`WK_PPN_WIDTH-1:0]  entry0_ppn;              
wire            entry0_upd;              
wire            entry0_vld;              
wire    [13:0]  entry10_flg;             
wire            entry10_hit0;            
            
wire            entry10_hit2;            
wire            entry10_hit3;            
wire    [`WK_PPN_WIDTH-1:0]  entry10_ppn;             
wire            entry10_upd;             
wire            entry10_vld;             
wire    [13:0]  entry11_flg;             
wire            entry11_hit0;            
           
wire            entry11_hit2;            
wire            entry11_hit3;            
wire    [`WK_PPN_WIDTH-1:0]  entry11_ppn;             
wire            entry11_upd;             
wire            entry11_vld;             
wire    [13:0]  entry12_flg;             
wire            entry12_hit0;            
           
wire            entry12_hit2;            
wire            entry12_hit3;            
wire    [`WK_PPN_WIDTH-1:0]  entry12_ppn;             
wire            entry12_upd;             
wire            entry12_vld;             
wire    [13:0]  entry13_flg;             
wire            entry13_hit0;            
            
wire            entry13_hit2;            
wire            entry13_hit3;            
wire    [`WK_PPN_WIDTH-1:0]  entry13_ppn;             
wire            entry13_upd;             
wire            entry13_vld;             
wire    [13:0]  entry14_flg;             
wire            entry14_hit0;            
            
wire            entry14_hit2;            
wire            entry14_hit3;            
wire    [`WK_PPN_WIDTH-1:0]  entry14_ppn;             
wire            entry14_upd;             
wire            entry14_vld;             
wire    [13:0]  entry15_flg;             
wire            entry15_hit0;            
            
wire            entry15_hit2;            
wire            entry15_hit3;            
wire    [`WK_PPN_WIDTH-1:0]  entry15_ppn;             
wire            entry15_upd;             
wire            entry15_vld;             
wire    [13:0]  entry16_flg;             
wire            entry16_hit0;            
          
wire            entry16_hit2;            
wire            entry16_hit3;            
wire    [`WK_PPN_WIDTH-1:0]  entry16_ppn;             
wire            entry16_vld;             
wire    [13:0]  entry1_flg;              
wire            entry1_hit0;             
            
wire            entry1_hit2;             
wire            entry1_hit3;             
wire    [`WK_PPN_WIDTH-1:0]  entry1_ppn;              
wire            entry1_upd;              
wire            entry1_vld;              
wire    [13:0]  entry2_flg;              
wire            entry2_hit0;             
            
wire            entry2_hit2;             
wire            entry2_hit3;             
wire    [`WK_PPN_WIDTH-1:0]  entry2_ppn;              
wire            entry2_upd;              
wire            entry2_vld;              
wire    [13:0]  entry3_flg;              
wire            entry3_hit0;             
            
wire            entry3_hit2;             
wire            entry3_hit3;             
wire    [`WK_PPN_WIDTH-1:0]  entry3_ppn;              
wire            entry3_upd;              
wire            entry3_vld;              
wire    [13:0]  entry4_flg;              
wire            entry4_hit0;             
             
wire            entry4_hit2;             
wire            entry4_hit3;             
wire    [`WK_PPN_WIDTH-1:0]  entry4_ppn;              
wire            entry4_upd;              
wire            entry4_vld;              
wire    [13:0]  entry5_flg;              
wire            entry5_hit0;             
            
wire            entry5_hit2;             
wire            entry5_hit3;             
wire    [`WK_PPN_WIDTH-1:0]  entry5_ppn;              
wire            entry5_upd;              
wire            entry5_vld;              
wire    [13:0]  entry6_flg;              
wire            entry6_hit0;             
            
wire            entry6_hit2;             
wire            entry6_hit3;             
wire    [`WK_PPN_WIDTH-1:0]  entry6_ppn;              
wire            entry6_upd;              
wire            entry6_vld;              
wire    [13:0]  entry7_flg;              
wire            entry7_hit0;             
             
wire            entry7_hit2;             
wire            entry7_hit3;             
wire    [`WK_PPN_WIDTH-1:0]  entry7_ppn;              
wire            entry7_upd;              
wire            entry7_vld;              
wire    [13:0]  entry8_flg;              
wire            entry8_hit0;             
            
wire            entry8_hit2;             
wire            entry8_hit3;             
wire    [`WK_PPN_WIDTH-1:0]  entry8_ppn;              
wire            entry8_upd;              
wire            entry8_vld;              
wire    [13:0]  entry9_flg;              
wire            entry9_hit0;             
             
wire            entry9_hit2;             
wire            entry9_hit3;             
wire    [`WK_PPN_WIDTH-1:0]  entry9_ppn;              
wire            entry9_upd;              
wire            entry9_vld;              
wire            forever_cpuclk;          
wire            hpcp_mmu_cnt_en;         
wire            jtlb_dutlb_acc_err;      
wire            jtlb_dutlb_pgflt;        
wire            jtlb_dutlb_ref_cmplt;    
wire            jtlb_dutlb_ref_pavld;    
wire    [13:0]  jtlb_utlb_ref_flg;       
wire    [2 :0]  jtlb_utlb_ref_pgs;       
wire    [`WK_PPN_WIDTH-1:0]  jtlb_utlb_ref_ppn;       
wire    [`WK_VPN_WIDTH-1:0]  jtlb_utlb_ref_vpn;       
wire            lsag0_ex1_is_load;
wire            lsag1_ex1_is_load;
wire            lsu_mmu_abort0;          
          
wire            lsu_mmu_abort2;          
wire            lsu_mmu_abort3;          
wire    [IID_WIDTH-1 :0]  lsu_mmu_id0;             
             
wire    [IID_WIDTH-1 :0]  lsu_mmu_id2;             
wire    [IID_WIDTH-1 :0]  lsu_mmu_id3;             
wire            lsu_mmu_st_inst0;        
       
wire            lsu_mmu_st_inst2;        
wire            lsu_mmu_st_inst3;        
wire    [`WK_PPN_WIDTH-1:0]  lsu_mmu_stamo_pa;        
wire    [`WK_PPN_WIDTH-1:0]  lsu_mmu_stamo_read_pa0;       
       
wire    [`WK_PPN_WIDTH-1:0]  lsu_mmu_stamo_read_pa2;       
wire    [`WK_PPN_WIDTH-1:0]  lsu_mmu_stamo_read_pa3;       
wire    [`WK_PPN_WIDTH-1:0]  lsu_mmu_stamo_pa0;       
       
wire    [`WK_PPN_WIDTH-1:0]  lsu_mmu_stamo_pa2;       
wire    [`WK_PPN_WIDTH-1:0]  lsu_mmu_stamo_pa3;       
wire            lsu_mmu_stamo_vld;       
wire            lsu_mmu_stamo_read_vld0;      
     
wire            lsu_mmu_stamo_read_vld2;      
wire            lsu_mmu_stamo_read_vld3;      
wire            lsu_mmu_stamo_vld0;      
      
wire            lsu_mmu_stamo_vld2;      
wire            lsu_mmu_stamo_vld3;      
wire    [`WK_VPN_WIDTH-1:0]  lsu_mmu_tlb_va;          
wire    [63:0]  lsu_mmu_va0;             
wire            lsu_mmu_va0_vld;         
        
wire    [63:0]  lsu_mmu_va2;             
wire            lsu_mmu_va2_vld;         
wire    [63:0]  lsu_mmu_va3;             
wire            lsu_mmu_va3_vld;         
wire            lsu_mmu_va_vld0;         
         
wire            lsu_mmu_va_vld2;         
wire            lsu_mmu_va_vld3;         
wire    [`WK_PPN_WIDTH-1:0]  lsu_mmu_vabuf0;          
          
wire    [`WK_PPN_WIDTH-1:0]  lsu_mmu_vabuf2;          
wire    [`WK_PPN_WIDTH-1:0]  lsu_mmu_vabuf3;          
wire            lsu_mmu_old0;
wire            lsu_mmu_old2;
wire            lsu_mmu_old3;
wire            mmu_hpcp_dutlb_miss;     
wire            mmu_lsu_access_fault0;   
   
wire            mmu_lsu_access_fault2;   
wire            mmu_lsu_access_fault3;   
wire            mmu_lsu_buf0;            
           
wire            mmu_lsu_buf2;            
wire            mmu_lsu_buf3;            
wire            mmu_lsu_ca0;             
            
wire            mmu_lsu_ca2;             
wire            mmu_lsu_ca3;             
wire    [`WK_PPN_WIDTH-1:0]  mmu_lsu_pa0;             
wire                         mmu_lsu_pa0_vld;         
        
wire    [`WK_PPN_WIDTH-1:0]  mmu_lsu_pa2;             
wire                         mmu_lsu_pa2_vld;         
wire    [`WK_PPN_WIDTH-1:0]  mmu_lsu_pa3;             
wire                         mmu_lsu_pa3_vld;         
wire            mmu_lsu_pa_vld0;         
         
wire            mmu_lsu_pa_vld2;         
wire            mmu_lsu_pa_vld3;         
wire            mmu_lsu_page_fault0;     
     
wire            mmu_lsu_page_fault2;     
wire            mmu_lsu_page_fault3;     
wire            mmu_lsu_sec0;            
           
wire            mmu_lsu_sec2;            
wire            mmu_lsu_sec3;            
wire            mmu_lsu_sh0;             
             
wire            mmu_lsu_sh2;             
wire            mmu_lsu_sh3;             
wire            mmu_lsu_so0;             
            
wire            mmu_lsu_so2;             
wire            mmu_lsu_so3;             
wire            mmu_lsu_stall0;          
          
wire            mmu_lsu_stall2;          
wire            mmu_lsu_stall3;          
wire            mmu_lsu_tlb_busy;        
wire    [LSIQENTRY-1:0]  mmu_lsu_tlb_wakeup;      
wire    [`WK_PPN_WIDTH-1:0]  mmu_pmp_pa0;             
            
wire    [`WK_PPN_WIDTH-1:0]  mmu_pmp_pa00;             
wire    [`WK_PPN_WIDTH-1:0]  mmu_pmp_pa10;   
wire    [`WK_PPN_WIDTH-1:0]  mmu_sysmap_pa0;          
wire    [`WK_PPN_WIDTH-1:0]  mmu_sysmap_pa00;          
wire    [`WK_PPN_WIDTH-1:0]  mmu_sysmap_pa10;          
wire            pad_yy_icg_scan_en;      
wire    [15:0]  plru_dutlb_ref_num;      
wire    [3 :0]  pmp_mmu_flg0;            
            
wire    [3 :0]  pmp_mmu_flg00;            
wire    [3 :0]  pmp_mmu_flg10;            
// wire    [IID_WIDTH-1 :0]  refill_id_flop;          
reg    [IID_WIDTH-1 :0]  refill_id_flop;          
wire            regs_mmu_en; 
wire            mmu_sv48_en;            
wire            regs_utlb_clr;           
wire            rtu_yy_xx_flush;         
wire            rtu_ck_flush;
wire   [IID_WIDTH-1:0] rtu_ck_flush_iid;
wire            rtu_ck_flush_older_tmp_req;
wire            rtu_ck_flush_older_eq_tmp_req;
wire            rtu_ck_flush_older_refill_flop;
wire            rtu_ck_flush_older_eq_refill_flop;
wire            rtu_ck_flush_older_eq_dutlb_expt;
wire            rtu_ck_flush_older_dutlb_expt;
wire [LSIQENTRY-1:0] rtu_ck_flush_wakeup_lsu0;
wire [LSIQENTRY-1:0] rtu_ck_flush_wakeup_lsu2;
wire [LSIQENTRY-1:0] rtu_ck_flush_wakeup_lsu3; 
wire    [4 :0]  sysmap_mmu_flg0;         
       
wire    [4 :0]  sysmap_mmu_flg00;         
wire    [4 :0]  sysmap_mmu_flg10;         
wire            tlboper_utlb_clr;        
wire            tlboper_utlb_inv_va_req; 
wire            utlb_clk;                
wire            utlb_huge_entry_upd;     
wire    [`WK_VPN_WIDTH-1:0]  utlb_req_vpn0;           
          
wire    [`WK_VPN_WIDTH-1:0]  utlb_req_vpn2;           
wire    [`WK_VPN_WIDTH-1:0]  utlb_req_vpn3;           
wire    [13:0]  utlb_upd_flg;            
wire    [`WK_PPN_WIDTH-1:0]  utlb_upd_ppn;            
wire    [`WK_VPN_WIDTH-1:0]  utlb_upd_vpn;            
reg     [TMQ_NUM-1:0]   refill_tmq_ptr;        // wjh@tmq
wire [TMQ_NUM-1:0]      arb_dutlb_cmplt_ptr;   // wjh@tmq
wire [LSIQENTRY-1:0]   tmq_lsu0_imme_wakeup;  // wjh@tmq
wire [LSIQENTRY-1:0]   tmq_lsu2_imme_wakeup;  // wjh@tmq
wire [LSIQENTRY-1:0]   tmq_lsu3_imme_wakeup;  // wjh@tmq
wire [LSIQENTRY-1:0]   tmq_lsu0_cmplt_wakeup; // wjh@tmq
wire [LSIQENTRY-1:0]   tmq_lsu2_cmplt_wakeup; // wjh@tmq
wire [LSIQENTRY-1:0]   tmq_lsu3_cmplt_wakeup; // wjh@tmq
wire [LSIQENTRY-1:0]   tmq_lsu0_spec_wakeup;  // wjh@tmq
wire [LSIQENTRY-1:0]   tmq_lsu2_spec_wakeup;  // wjh@tmq
wire [LSIQENTRY-1:0]   tmq_lsu3_spec_wakeup;  // wjh@tmq
wire [LSIQENTRY-1:0]   mmu_lsu_async_wakeup0; // wjh@tmq
wire [LSIQENTRY-1:0]   mmu_lsu_async_wakeup2; // wjh@tmq
wire [LSIQENTRY-1:0]   mmu_lsu_async_wakeup3; // wjh@tmq
wire                    mmu_lsu_imme_wakeup0;  // wjh@tmq
wire                    mmu_lsu_imme_wakeup2;  // wjh@tmq
wire                    mmu_lsu_imme_wakeup3;  // wjh@tmq
wire                    tmq_req_vld;           // wjh@tmq
wire [TMQ_NUM-1:0]      tmq_req_ptr;           // wjh@tmq
wire [`WK_VPN_WIDTH-1:0]             tmq_req_vpn;           // wjh@tmq
wire [LSIQENTRY-1:0]   tmq_req_lsid0;         // wjh@tmq
wire [LSIQENTRY-1:0]   tmq_req_lsid2;         // wjh@tmq
wire [LSIQENTRY-1:0]   tmq_req_lsid3;         // wjh@tmq
wire [IID_WIDTH-1:0]    tmq_req_iid;           // wjh@tmq
wire                    tmq_req_st;            // wjh@tmq
wire [`WK_VPN_WIDTH-1:0]             tmq_refill_vpn;
reg  [LSIQENTRY-1:0]    mmu_lsu0_imme_wakeup;
reg  [LSIQENTRY-1:0]    mmu_lsu2_imme_wakeup;
reg  [LSIQENTRY-1:0]    mmu_lsu3_imme_wakeup;
reg                     dutlb_expt_vld;
reg                     dutlb_expt_pgflt;
reg                     dutlb_expt_acflt;
reg  [IID_WIDTH-1:0]    dutlb_expt_iid;
wire                    dutlb_expt_set;
wire                    dutlb_expt_iid_older;
reg  [2 :0]             refill_pgs;
reg  [`WK_VPN_WIDTH-1:0]             refill_vpn;//tmq fixed @hcl 20251022
//==========================================================
// parameters for value width
//==========================================================
parameter VPN_WIDTH = `WK_VPN_WIDTH;  // VPN
// parameter PPN_WIDTH = 40-12;  // PPN
parameter PPN_WIDTH = `WK_PPN_WIDTH;
parameter FLG_WIDTH = 14;     // Flags
parameter PGS_WIDTH = 3;      // Page Size
// parameter LSIQENTRY= 12;
// parameter IID_WIDTH = 7;
parameter LVL_WIDTH = 9;


//==============================================================================
//                  Control Path
//==============================================================================
//==========================================================
//                  Gate Cell
//==========================================================
assign dutlb_clk_en = dutlb_miss_vld_short0
                   || dutlb_miss_vld_short2
                   || dutlb_miss_vld_short3
                   || dutlb_acc_flt0
                   || dutlb_acc_flt2
                   || dutlb_acc_flt3
                   || dutlb_refill_on
                   || dutlb_miss;
// &Instance("gated_clk_cell", "x_dutlb_gateclk"); @58
gated_clk_cell  x_dutlb_gateclk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (dutlb_clk         ),
  .external_en        (1'b0              ),
  .local_en           (dutlb_clk_en      ),
  .module_en          (cp0_mmu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect( .clk_in     (forever_cpuclk), @59
//           .external_en(1'b0          ), @60
//           .module_en  (cp0_mmu_icg_en), @61
//           .local_en   (dutlb_clk_en  ), @62
//           .clk_out    (dutlb_clk     ) @63
//          ); @64

// current privlidged mode
assign cp0_priv_mode[1:0] = cp0_mmu_mprv ? cp0_mmu_mpp[1:0]
                                         : cp0_yy_priv_mode[1:0];
assign cp0_user_mode = cp0_priv_mode[1:0] == 2'b00;
assign cp0_supv_mode = cp0_priv_mode[1:0] == 2'b01;
assign cp0_mach_mode = cp0_priv_mode[1:0] == 2'b11;

//----------------------------------------------------------
//                  Interface to LSU
//----------------------------------------------------------
// assign mmu_lsu_tlb_busy = dutlb_refill_on;
// assign mmu_lsu_tlb_wakeup[LSIQENTRY-1:0] = 
//             {LSIQENTRY{dutlb_refill_idle}}    & {LSIQENTRY{1'b1}}
//           | {LSIQENTRY{dutlb_expt_for_taken}} & {LSIQENTRY{1'b1}};
assign mmu_lsu_tlb_busy = 1'b0;
assign mmu_lsu_tlb_wakeup = {LSIQENTRY{1'b0}};
assign mmu_lsu_async_wakeup0 = rtu_ck_flush     //ck_flush send out all wakeup, ck_flush@LTL
                               ? rtu_ck_flush_wakeup_lsu0 | tmq_lsu0_spec_wakeup | mmu_lsu0_imme_wakeup | {LSIQENTRY{~mmu_lsu_pa_vld0}} & lsu_mmu_lsid0
                               : tmq_lsu0_cmplt_wakeup | tmq_lsu0_spec_wakeup | mmu_lsu0_imme_wakeup;
assign mmu_lsu_async_wakeup2 = rtu_ck_flush     //ck_flush send out all wakeup, ck_flush@LTL
                               ? rtu_ck_flush_wakeup_lsu2 | tmq_lsu2_spec_wakeup | mmu_lsu2_imme_wakeup | {LSIQENTRY{~mmu_lsu_pa_vld2}} & lsu_mmu_lsid2
                               : tmq_lsu2_cmplt_wakeup | tmq_lsu2_spec_wakeup | mmu_lsu2_imme_wakeup;
assign mmu_lsu_async_wakeup3 = rtu_ck_flush     //ck_flush send out all wakeup, ck_flush@LTL
                               ? rtu_ck_flush_wakeup_lsu3 | tmq_lsu3_spec_wakeup | mmu_lsu3_imme_wakeup | {LSIQENTRY{~mmu_lsu_pa_vld3}} & lsu_mmu_lsid3
                               : tmq_lsu3_cmplt_wakeup | tmq_lsu3_spec_wakeup | mmu_lsu3_imme_wakeup;
assign mmu_lsu_imme_wakeup0 = 1'b0;// tmq_lsu0_imme_wakeup;
assign mmu_lsu_imme_wakeup2 = 1'b0;// tmq_lsu2_imme_wakeup;
assign mmu_lsu_imme_wakeup3 = 1'b0;// tmq_lsu3_imme_wakeup;

always @(posedge dutlb_clk, negedge cpurst_b)begin 
  if(!cpurst_b)begin 
    mmu_lsu0_imme_wakeup <= {LSIQENTRY{1'b0}};
    mmu_lsu2_imme_wakeup <= {LSIQENTRY{1'b0}};
    mmu_lsu3_imme_wakeup <= {LSIQENTRY{1'b0}};
  end
  else begin 
    mmu_lsu0_imme_wakeup <= tmq_lsu0_imme_wakeup;    
    mmu_lsu2_imme_wakeup <= tmq_lsu2_imme_wakeup;
    mmu_lsu3_imme_wakeup <= tmq_lsu3_imme_wakeup;
  end
end
//==========================================================
//                  uTLB Replacement Logic
//==========================================================
//----------------------------------------------------------
//                  uTLB Replacement Algorithm
//----------------------------------------------------------
// 1. when there is empty entry avaleble, use empty entry
// 2. when there is no empry entry, use PLRU
// &ConnRule(s/^utlb/dutlb/); @89
// &Instance("xx_mmu_dplru","x_xx_mmu_dplru"); @90
xx_mmu_dplru  x_xx_mmu_dplru (
  .cp0_mmu_icg_en           (cp0_mmu_icg_en          ),
  .cpurst_b                 (cpurst_b                ),
  .entry0_vld               (entry0_vld              ),
  .entry10_vld              (entry10_vld             ),
  .entry11_vld              (entry11_vld             ),
  .entry12_vld              (entry12_vld             ),
  .entry13_vld              (entry13_vld             ),
  .entry14_vld              (entry14_vld             ),
  .entry15_vld              (entry15_vld             ),
  .entry1_vld               (entry1_vld              ),
  .entry2_vld               (entry2_vld              ),
  .entry3_vld               (entry3_vld              ),
  .entry4_vld               (entry4_vld              ),
  .entry5_vld               (entry5_vld              ),
  .entry6_vld               (entry6_vld              ),
  .entry7_vld               (entry7_vld              ),
  .entry8_vld               (entry8_vld              ),
  .entry9_vld               (entry9_vld              ),
  .forever_cpuclk           (forever_cpuclk          ),
  .pad_yy_icg_scan_en       (pad_yy_icg_scan_en      ),
  .plru_dutlb_ref_num       (plru_dutlb_ref_num      ),
  .utlb_plru_read_hit0      (dutlb_plru_read_hit0    ),
  .utlb_plru_read_hit2      (dutlb_plru_read_hit2    ),
  .utlb_plru_read_hit3      (dutlb_plru_read_hit3    ),
  .utlb_plru_read_hit_vld0  (dutlb_plru_read_hit_vld0),
  .utlb_plru_read_hit_vld2  (dutlb_plru_read_hit_vld2),
  .utlb_plru_read_hit_vld3  (dutlb_plru_read_hit_vld3),
  .utlb_plru_refill_on      (dutlb_plru_refill_on    ),
  .utlb_plru_refill_vld     (dutlb_plru_refill_vld   )
);


assign dutlb_plru_refill_on  = dutlb_wfc;
assign dutlb_plru_refill_vld = dutlb_refill_vld;

//for plru read hit updt
//assign dplru_clk_en = lsu_mmu_va0_vld && (dutlb_plru_read_hit0[15:0] != dutlb_entry_hit0[15:0]) 
//                   || lsu_mmu_va1_vld && (dutlb_plru_read_hit1[15:0] != dutlb_entry_hit1[15:0]);
assign dplru_clk_en = dutlb_va_chg0 || dutlb_va_chg2 || dutlb_va_chg3;
//assign dplru_clk_en = dutlb_acc_vld;
// &Instance("gated_clk_cell", "x_dutlb_plru_gateclk"); @100
gated_clk_cell  x_dutlb_plru_gateclk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (dplru_clk         ),
  .external_en        (1'b0              ),
  .local_en           (dplru_clk_en      ),
  .module_en          (cp0_mmu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect( .clk_in     (forever_cpuclk), @101
//           .external_en(1'b0          ), @102
//           .module_en  (cp0_mmu_icg_en), @103
//           .local_en   (dplru_clk_en  ), @104
//           .clk_out    (dplru_clk     ) @105
//          ); @106

//==========================================================
//                  uTLB Refill SM
//==========================================================
//----------------------------------------------------------
//                  SM State
//----------------------------------------------------------
// 1. IDLE: default state; wait grant when utlb miss
// 2. WFC : wait utlb refill cmplt to refill utlb
// 3. ABT : wait utlb refill cmplt when abort happened
parameter IDLE  = 3'b000, 
          WFG   = 3'b001,
          WFC   = 3'b011,
          PGFLT = 3'b010,
          ACFLT = 3'b100,
          ABT   = 3'b101;

assign dutlb_miss_vld = dutlb_miss_vld0 || dutlb_miss_vld2 || dutlb_miss_vld3;

always @(posedge dutlb_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    ref_cur_st[2:0] <= 3'b000;
  else
    ref_cur_st[2:0] <= ref_nxt_st[2:0];
end

// &CombBeg; @134
always @( ref_cur_st
       or dutlb_inst_id_older
       or jtlb_dutlb_acc_err
       or jtlb_dutlb_pgflt
       or arb_dutlb_grant
       or dutlb_miss_vld
       or jtlb_dutlb_ref_cmplt
       or rtu_yy_xx_flush
       or rtu_ck_flush
       or rtu_ck_flush_older_eq_tmp_req
       or rtu_ck_flush_older_eq_refill_flop
       or dutlb_inst_vpn_match)
begin
case (ref_cur_st)
// IDLE:
// begin
//   if(rtu_yy_xx_flush)
//     ref_nxt_st[2:0] = IDLE;
//   else if(dutlb_miss_vld)
//     ref_nxt_st[2:0] = WFG;
//   else
//     ref_nxt_st[2:0] = IDLE;
// end
IDLE:
begin
  if(rtu_yy_xx_flush && arb_dutlb_grant)
    ref_nxt_st[2:0] = ABT;
  else if(rtu_ck_flush && rtu_ck_flush_older_eq_tmp_req && arb_dutlb_grant) //ck_flush younger grant, ck_flush@LTL
    ref_nxt_st[2:0] = ABT;
  else if(rtu_yy_xx_flush)
    ref_nxt_st[2:0] = IDLE;
  else if(arb_dutlb_grant)
    ref_nxt_st[2:0] = WFC;
  else
    ref_nxt_st[2:0] = IDLE;
end
WFC:
begin
  if((rtu_yy_xx_flush || rtu_ck_flush && rtu_ck_flush_older_eq_refill_flop) && jtlb_dutlb_ref_cmplt)  //ck_flush younger state, ck_flush@LTL
    ref_nxt_st[2:0] = IDLE;
  else if(rtu_yy_xx_flush || rtu_ck_flush && rtu_ck_flush_older_eq_refill_flop)     //ck_flush younger state, ck_flush@LTL
    ref_nxt_st[2:0] = ABT;
  // else if(jtlb_dutlb_ref_cmplt && jtlb_dutlb_pgflt)
  //   ref_nxt_st[2:0] = PGFLT;
  // else if(jtlb_dutlb_ref_cmplt && jtlb_dutlb_acc_err)
  //   ref_nxt_st[2:0] = ACFLT;
  else if(jtlb_dutlb_ref_cmplt)
    ref_nxt_st[2:0] = IDLE;
  else
    ref_nxt_st[2:0] = WFC;
end
PGFLT:
begin
  if(rtu_yy_xx_flush || rtu_ck_flush && rtu_ck_flush_older_eq_refill_flop)    //ck_flush younger grant, ck_flush@LTL
    ref_nxt_st[2:0] = IDLE;
  else if(dutlb_inst_vpn_match)
    ref_nxt_st[2:0] = IDLE;
  else if(dutlb_inst_id_older)
    ref_nxt_st[2:0] = IDLE;
    // if(dutlb_miss_vld)
    //   ref_nxt_st[2:0] = WFG;
    // else 
    //   ref_nxt_st[2:0] = IDLE;
  else
    ref_nxt_st[2:0] = PGFLT;
end
ACFLT:
begin
  if(rtu_yy_xx_flush || rtu_ck_flush && rtu_ck_flush_older_eq_refill_flop)  //ck_flush younger grant, ck_flush@LTL
    ref_nxt_st[2:0] = IDLE;
  else if(dutlb_inst_vpn_match)
    ref_nxt_st[2:0] = IDLE;
  else if(dutlb_inst_id_older)
    ref_nxt_st[2:0] = IDLE;
    // if(dutlb_miss_vld)
    //   ref_nxt_st[2:0] = WFG;
    // else 
    //   ref_nxt_st[2:0] = IDLE;
  else
    ref_nxt_st[2:0] = ACFLT;
end
ABT:
begin
  if(jtlb_dutlb_ref_cmplt)
    ref_nxt_st[2:0] = IDLE;
  else
    ref_nxt_st[2:0] = ABT;
end
default:
begin
   ref_nxt_st[2:0] = IDLE;
end
endcase
// &CombEnd; @211
end


//----------------------------------------------------------
//                  SM Control Signal
//----------------------------------------------------------
// Req jtlb when utlb miss
// 1. req only in IDLE, so utlb refill is blocking
// &Force("output", "dutlb_arb_vpn"); @219
// assign dutlb_arb_req       = (ref_cur_st[2:0] == WFG);
// assign dutlb_arb_vpn[VPN_WIDTH-1:0] = {VPN_WIDTH{refill_type[0]}} & refill_va_flop0[VPN_WIDTH-1:0]
//                                     | {VPN_WIDTH{refill_type[1]}} & refill_va_flop2[VPN_WIDTH-1:0]
//                                     | {VPN_WIDTH{refill_type[2]}} & refill_va_flop3[VPN_WIDTH-1:0];
                                                 
assign dutlb_arb_req = tmq_req_vld && !dutlb_refill_on;
assign dutlb_arb_vpn = tmq_req_vpn;
assign dutlb_arb_load = !tmq_req_st;

// assign dutlb_arb_load = refill_read;

// always @(posedge dutlb_clk or negedge cpurst_b)
// begin
//   if (!cpurst_b)
//     refill_va_flop0[VPN_WIDTH-1:0] <= {VPN_WIDTH{1'b0}};
//   else if(dutlb_miss_vld_short0 && dutlb_refill_upd0)
//     refill_va_flop0[VPN_WIDTH-1:0] <= utlb_req_vpn0[VPN_WIDTH-1:0];
// end

// always @(posedge dutlb_clk or negedge cpurst_b)
// begin
//   if (!cpurst_b)
//     refill_va_flop2[VPN_WIDTH-1:0] <= {VPN_WIDTH{1'b0}};
//   else if(dutlb_miss_vld_short2 && dutlb_refill_upd2)
//     refill_va_flop2[VPN_WIDTH-1:0] <= utlb_req_vpn2[VPN_WIDTH-1:0];
// end

// always @(posedge dutlb_clk or negedge cpurst_b)
// begin
//   if (!cpurst_b)
//     refill_va_flop3[VPN_WIDTH-1:0] <= {VPN_WIDTH{1'b0}};
//   else if(dutlb_miss_vld_short3 && dutlb_refill_upd3)
//     refill_va_flop3[VPN_WIDTH-1:0] <= utlb_req_vpn3[VPN_WIDTH-1:0];
// end

// &Instance("wk_rtu_compare_iid","x_mmu_dutlb_compare_req_iid"); @241

wk_rtu_compare_iid #(.IID_WIDTH(IID_WIDTH))  x_mmu_dutlb_compare_req_iid02 (
  .x_iid0              (lsu_mmu_id0[IID_WIDTH-1:0]   ),
  .x_iid0_older        (dutlb_req_id02_older),
  .x_iid1              (lsu_mmu_id2[IID_WIDTH-1:0]   )
);
wk_rtu_compare_iid #(.IID_WIDTH(IID_WIDTH))  x_mmu_dutlb_compare_req_iid03 (
  .x_iid0              (lsu_mmu_id0[IID_WIDTH-1:0]   ),
  .x_iid0_older        (dutlb_req_id03_older),
  .x_iid1              (lsu_mmu_id3[IID_WIDTH-1:0]   )
);

wk_rtu_compare_iid #(.IID_WIDTH(IID_WIDTH))  x_mmu_dutlb_compare_req_iid23 (
  .x_iid0              (lsu_mmu_id2[IID_WIDTH-1:0]   ),
  .x_iid0_older        (dutlb_req_id23_older),
  .x_iid1              (lsu_mmu_id3[IID_WIDTH-1:0]   )
);
wk_rtu_compare_iid #(.IID_WIDTH(IID_WIDTH))  x_rtu_ck_flush_compare_tmp_req_iid (
  .x_iid0              (rtu_ck_flush_iid[IID_WIDTH-1:0]   ),
  .x_iid0_older        (rtu_ck_flush_older_tmp_req        ),
  .x_iid1              (tmq_req_iid[IID_WIDTH-1:0]      )
);
wk_rtu_compare_iid #(.IID_WIDTH(IID_WIDTH))  x_rtu_ck_flush_compare_refill_iid (
  .x_iid0              (rtu_ck_flush_iid[IID_WIDTH-1:0]   ),
  .x_iid0_older        (rtu_ck_flush_older_refill_flop    ),
  .x_iid1              (refill_id_flop[IID_WIDTH-1:0]    )
);
assign rtu_ck_flush_older_eq_tmp_req = rtu_ck_flush_older_tmp_req || (rtu_ck_flush_iid == tmq_req_iid);
assign rtu_ck_flush_older_eq_refill_flop = rtu_ck_flush_older_refill_flop || (rtu_ck_flush_iid == refill_id_flop);
// &Connect( .x_iid0         (lsu_mmu_id0[6:0]), @242
//           .x_iid1         (lsu_mmu_id1[6:0]), @243
//           .x_iid0_older   (dutlb_req_id0_older)); @244

// always @(posedge dutlb_clk or negedge cpurst_b)
// begin
//   if (!cpurst_b)
//     refill_type <= 3'b000;
//   else if(dutlb_miss_vld0 && dutlb_refill_upd0 
//           && (dutlb_req_id02_older || !dutlb_miss_vld2)
//           && (dutlb_req_id03_older || !dutlb_miss_vld3))
//     refill_type <= 3'b001;
//   else if(dutlb_miss_vld2 && dutlb_refill_upd2
//           && (dutlb_req_id23_older || !dutlb_miss_vld3))
//     refill_type <= 3'b010;
//   else if(dutlb_miss_vld3 && dutlb_refill_upd3)
//     refill_type <= 3'b100;
// end

// always @(posedge dutlb_clk or negedge cpurst_b)
// begin
//   if (!cpurst_b)
//     refill_read <= 1'b0;
//   else if(dutlb_miss_vld0 && dutlb_refill_upd0 
//           && (dutlb_req_id02_older || !dutlb_miss_vld2)
//           && (dutlb_req_id03_older || !dutlb_miss_vld3))
//     refill_read <= !lsu_mmu_st_inst0;
//   else if(dutlb_miss_vld2 && dutlb_refill_upd2
//           && (dutlb_req_id23_older || !dutlb_miss_vld3))
//     refill_read <= !lsu_mmu_st_inst2;      
//   else if(dutlb_miss_vld3 && dutlb_refill_upd3)
//     refill_read <= !lsu_mmu_st_inst3;        
// end
// assign dutlb_refill_on0 = (ref_cur_st[2:0] != IDLE); // &&  (refill_type == 3'b001);
// assign dutlb_refill_on2 = (ref_cur_st[2:0] != IDLE); // &&  (refill_type == 3'b010);
// assign dutlb_refill_on3 = (ref_cur_st[2:0] != IDLE); // &&  (refill_type == 3'b100);
assign dutlb_refill_on0 = dutlb_expt_vld;
assign dutlb_refill_on2 = dutlb_expt_vld;
assign dutlb_refill_on3 = dutlb_expt_vld;
// uTLB refill cmplt
// 1. jtlb hit
// 2. ptw cmplt, either data vld or acc err
// 3. refill utlb only when ptw cmplt with data vld
assign dutlb_wfc = (ref_cur_st[2:0] == WFC);
//assign dutlb_refill_cmplt = dutlb_wfc && jtlb_dutlb_ref_cmplt;
assign dutlb_refill_vld   = dutlb_wfc && jtlb_dutlb_ref_pavld && !(rtu_ck_flush && rtu_ck_flush_older_eq_refill_flop);  //ck_flush younger refill, ck_flush@LTL

// assign dutlb_ref_pgflt    = (ref_cur_st[2:0] == PGFLT);
// assign dutlb_ref_acflt    = (ref_cur_st[2:0] == ACFLT);
assign dutlb_ref_pgflt = dutlb_expt_pgflt & dutlb_expt_vld;
assign dutlb_ref_acflt = dutlb_expt_acflt & dutlb_expt_vld;

assign dutlb_refill_idle  = (ref_cur_st[2:0] == IDLE);
assign dutlb_refill_on    = !dutlb_refill_idle;
// assign dutlb_refill_upd0  = dutlb_refill_idle || (dutlb_ref_pgflt || dutlb_ref_acflt) && dutlb_inst_id_older0;
// assign dutlb_refill_upd2  = dutlb_refill_idle || (dutlb_ref_pgflt || dutlb_ref_acflt) && dutlb_inst_id_older2;
// assign dutlb_refill_upd3  = dutlb_refill_idle || (dutlb_ref_pgflt || dutlb_ref_acflt) && dutlb_inst_id_older3;

//assign dutlb_arb_cmplt    = (ref_cur_st[2:0] != IDLE) && (ref_nxt_st[2:0] == IDLE);
assign dutlb_arb_cmplt    = (ref_cur_st[2:0] == WFC) && jtlb_dutlb_ref_cmplt
                         || (ref_cur_st[2:0] == ABT) && jtlb_dutlb_ref_cmplt;

// always @(posedge dutlb_clk or negedge cpurst_b)
// begin
//   if (!cpurst_b)
//     refill_id_flop0[IID_WIDTH-1:0] <= {IID_WIDTH{1'b0}};
//   else if(dutlb_miss_vld_short0 && dutlb_refill_upd0)
//     refill_id_flop0[IID_WIDTH-1:0] <= lsu_mmu_id0[IID_WIDTH-1:0];
// end

// always @(posedge dutlb_clk or negedge cpurst_b)
// begin
//   if (!cpurst_b)
//     refill_id_flop2[IID_WIDTH-1:0] <= {IID_WIDTH{1'b0}};
//   else if(dutlb_miss_vld_short2 && dutlb_refill_upd2)
//     refill_id_flop2[IID_WIDTH-1:0] <= lsu_mmu_id2[IID_WIDTH-1:0];
// end 
// always @(posedge dutlb_clk or negedge cpurst_b)
// begin
//   if (!cpurst_b)
//     refill_id_flop3[IID_WIDTH-1:0] <= {IID_WIDTH{1'b0}};
//   else if(dutlb_miss_vld_short3 && dutlb_refill_upd3)
//     refill_id_flop3[IID_WIDTH-1:0] <= lsu_mmu_id3[IID_WIDTH-1:0];
// end 
// assign refill_id_flop[IID_WIDTH-1:0] = refill_type ? refill_id_flop0[IID_WIDTH-1:0]
//                                                    : refill_id_flop1[IID_WIDTH-1:0];
// assign refill_id_flop[IID_WIDTH-1:0] = {IID_WIDTH{refill_type[0]}} & refill_id_flop0[IID_WIDTH-1:0]
//                                       |{IID_WIDTH{refill_type[1]}} & refill_id_flop2[IID_WIDTH-1:0]
//                                       |{IID_WIDTH{refill_type[2]}} & refill_id_flop3[IID_WIDTH-1:0];
//==============================================================================
//                  TMQ logic by wjh@tmq
//==============================================================================
wk_rtu_compare_iid  #(.IID_WIDTH(IID_WIDTH)) x_mmu_dutlb_expt_iid_older (
  .x_iid0              (refill_id_flop),
  .x_iid0_older        (dutlb_expt_iid_older),
  .x_iid1              (dutlb_expt_iid)
);
wk_rtu_compare_iid #(.IID_WIDTH(IID_WIDTH))  x_rtu_ck_flush_compare_expt_iid (
  .x_iid0              (rtu_ck_flush_iid[IID_WIDTH-1:0]  ),
  .x_iid0_older        (rtu_ck_flush_older_dutlb_expt    ),
  .x_iid1              (dutlb_expt_iid[IID_WIDTH-1:0]    )
);

assign rtu_ck_flush_older_eq_dutlb_expt = rtu_ck_flush_older_dutlb_expt || (rtu_ck_flush_iid == dutlb_expt_iid);

assign dutlb_expt_set = jtlb_dutlb_ref_cmplt
                        && (jtlb_dutlb_acc_err || jtlb_dutlb_pgflt)
                        && (!dutlb_expt_vld
                            || dutlb_expt_iid_older
                            || dutlb_inst_vpn_match)
                        && dutlb_wfc
                        && !rtu_yy_xx_flush
                        && !(rtu_ck_flush && rtu_ck_flush_older_eq_refill_flop);

always @(posedge dutlb_clk, negedge cpurst_b)begin 
  if(!cpurst_b)
    dutlb_expt_vld <= 1'b0;
  else if(dutlb_expt_set)
    dutlb_expt_vld <= 1'b1;
  else if(dutlb_inst_vpn_match || rtu_yy_xx_flush || (rtu_ck_flush && rtu_ck_flush_older_eq_dutlb_expt))
    dutlb_expt_vld <= 1'b0;
end

always @(posedge dutlb_clk, negedge cpurst_b)begin 
  if(!cpurst_b)begin 
    dutlb_expt_iid   <= {IID_WIDTH{1'b0}};
    dutlb_expt_acflt <= 1'b0;
    dutlb_expt_pgflt <= 1'b0;
    refill_pgs       <= 3'b0;
    refill_vpn       <= {VPN_WIDTH{1'b0}};
  end
  else if(dutlb_expt_set)begin 
    dutlb_expt_iid   <= refill_id_flop;
    dutlb_expt_acflt <= jtlb_dutlb_acc_err;
    dutlb_expt_pgflt <= jtlb_dutlb_pgflt;
    refill_pgs       <= jtlb_utlb_ref_pgs;
    refill_vpn       <= tmq_refill_vpn;
  end
end

always @(posedge forever_cpuclk or negedge cpurst_b)begin 
  if(!cpurst_b)
    refill_id_flop <= {IID_WIDTH{1'b0}};
  else if(arb_dutlb_grant && !(rtu_ck_flush && rtu_ck_flush_older_eq_tmp_req))  //ck_flush younger id, ck_flush@LTL
    refill_id_flop <= tmq_req_iid;
end

always @(posedge forever_cpuclk or negedge cpurst_b)begin 
  if(!cpurst_b)
    refill_tmq_ptr <= {TMQ_NUM{1'b0}};
  else if(arb_dutlb_grant)
    refill_tmq_ptr <= tmq_req_ptr;
end

// always @(posedge forever_cpuclk or negedge cpurst_b)begin 
//   if(!cpurst_b)
//     refill_pgs <= 3'b0;
//   else if(jtlb_dutlb_ref_cmplt)
//     refill_pgs <= jtlb_utlb_ref_pgs;
// end

// always @(posedge forever_cpuclk or negedge cpurst_b)begin 
//   if(!cpurst_b)
//     refill_vpn <= 27'b0;
//   else if(jtlb_dutlb_ref_cmplt)
//     refill_vpn <= tmq_refill_vpn;
// end
assign arb_dutlb_cmplt_ptr = {TMQ_NUM{jtlb_dutlb_ref_cmplt & dutlb_wfc}} & refill_tmq_ptr;

xx_mmu_dutlb_tmq #(
  .LSIQENTRY(LSIQENTRY),
  .TMQ_NUM(TMQ_NUM),
  .IID_WIDTH(IID_WIDTH)
)i_xx_mmu_dutlb_tmq(
  .forever_cpuclk       (forever_cpuclk),
  .cpurst_b             (cpurst_b),
  .cp0_mmu_icg_en       (cp0_mmu_icg_en),
  .pad_yy_icg_scan_en   (pad_yy_icg_scan_en),
  .dutlb_miss_vld0      (dutlb_miss_vld0),
  .dutlb_miss_vld2      (dutlb_miss_vld2),
  .dutlb_miss_vld3      (dutlb_miss_vld3),
  .utlb_req_vpn0        (utlb_req_vpn0),
  .utlb_req_vpn2        (utlb_req_vpn2),
  .utlb_req_vpn3        (utlb_req_vpn3),
  .lsu_mmu_lsid0        (lsu_mmu_lsid0),
  .lsu_mmu_lsid2        (lsu_mmu_lsid2),
  .lsu_mmu_lsid3        (lsu_mmu_lsid3),
  .lsu_mmu_id0          (lsu_mmu_id0),
  .lsu_mmu_id2          (lsu_mmu_id2),
  .lsu_mmu_id3          (lsu_mmu_id3),
  .lsu_mmu_st_inst0     (lsu_mmu_st_inst0),
  .lsu_mmu_st_inst2     (lsu_mmu_st_inst2),
  .lsu_mmu_st_inst3     (lsu_mmu_st_inst3),
  .lsu_mmu_old0         (lsu_mmu_old0),
  .lsu_mmu_old2         (lsu_mmu_old2),
  .lsu_mmu_old3         (lsu_mmu_old3),
  .dutlb_req_id02_older (dutlb_req_id02_older),
  .dutlb_req_id03_older (dutlb_req_id03_older),
  .dutlb_req_id23_older (dutlb_req_id23_older),
  .rtu_yy_xx_flush      (rtu_yy_xx_flush),
  .rtu_ck_flush         (rtu_ck_flush),
  .rtu_ck_flush_iid     (rtu_ck_flush_iid),
  .arb_dutlb_grant      (arb_dutlb_grant),
  .arb_dutlb_cmplt_ptr  (arb_dutlb_cmplt_ptr),
  .refill_tmq_ptr       (refill_tmq_ptr),
  .ptw_tmq_va_hit       (ptw_tmq_va_hit),
  .tmq_req_vld          (tmq_req_vld),
  .tmq_req_ptr          (tmq_req_ptr),
  .tmq_req_vpn          (tmq_req_vpn),
  .tmq_req_lsid0        (tmq_req_lsid0), // used for eraly wakup in the future
  .tmq_req_lsid2        (tmq_req_lsid2),
  .tmq_req_lsid3        (tmq_req_lsid3),
  .tmq_req_iid          (tmq_req_iid),
  .tmq_req_st           (tmq_req_st),
  .tmq_lsu0_cmplt_wakeup(tmq_lsu0_cmplt_wakeup),
  .tmq_lsu2_cmplt_wakeup(tmq_lsu2_cmplt_wakeup),
  .tmq_lsu3_cmplt_wakeup(tmq_lsu3_cmplt_wakeup),  
  .tmq_lsu0_spec_wakeup (tmq_lsu0_spec_wakeup),
  .tmq_lsu2_spec_wakeup (tmq_lsu2_spec_wakeup),
  .tmq_lsu3_spec_wakeup (tmq_lsu3_spec_wakeup),
  .tmq_lsu0_imme_wakeup (tmq_lsu0_imme_wakeup),
  .tmq_lsu2_imme_wakeup (tmq_lsu2_imme_wakeup),
  .tmq_lsu3_imme_wakeup (tmq_lsu3_imme_wakeup),
  .rtu_ck_flush_wakeup_lsu0 (rtu_ck_flush_wakeup_lsu0),
  .rtu_ck_flush_wakeup_lsu2 (rtu_ck_flush_wakeup_lsu2),
  .rtu_ck_flush_wakeup_lsu3 (rtu_ck_flush_wakeup_lsu3),
  .tmq_refill_vpn       (tmq_refill_vpn)
);
//==============================================================================
//                  TMQ logic end
//==============================================================================

assign dutlb_inst_vpn_match  = dutlb_inst_vpn_match0 || dutlb_inst_vpn_match2 || dutlb_inst_vpn_match3;
assign dutlb_inst_id_older  = dutlb_inst_id_older0 || dutlb_inst_id_older2 || dutlb_inst_id_older3;

// assign dutlb_expt_for_taken = (dutlb_ref_pgflt || dutlb_ref_acflt);
assign dutlb_expt_for_taken = dutlb_expt_vld;

// for hpcp
assign dutlb_miss_cnt = dutlb_refill_vld && hpcp_mmu_cnt_en; 

always @(posedge dutlb_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    dutlb_miss <= 1'b0;
  else if(dutlb_miss_cnt)
    dutlb_miss <= 1'b1;
  else if(dutlb_miss)
    dutlb_miss <= 1'b0;
end

assign mmu_hpcp_dutlb_miss = dutlb_miss;

//==============================================================================
//                  Data Path
//==============================================================================
//==========================================================
//                  uTLB Entry
//==========================================================
// &ConnRule(s/utlb_entry/entry0/); @336
// &Instance("xx_mmu_dutlb_entry","x_xx_mmu_dutlb_entry0"); @337
xx_mmu_dutlb_entry  x_xx_mmu_dutlb_entry0 (
  .cp0_mmu_icg_en          (cp0_mmu_icg_en         ),
  .cpurst_b                (cpurst_b               ),
  .lsu_mmu_tlb_va          (lsu_mmu_tlb_va         ),
  .pad_yy_icg_scan_en      (pad_yy_icg_scan_en     ),
  .regs_utlb_clr           (regs_utlb_clr          ),
  .tlboper_utlb_clr        (tlboper_utlb_clr       ),
  .tlboper_utlb_inv_va_req (tlboper_utlb_inv_va_req),
  .utlb_clk                (utlb_clk               ),
  .utlb_entry_flg          (entry0_flg             ),
  .utlb_entry_hit0         (entry0_hit0            ),
  .utlb_entry_hit2         (entry0_hit2            ),
  .utlb_entry_hit3         (entry0_hit3            ),
  .utlb_entry_ppn          (entry0_ppn             ),
  .utlb_entry_upd          (entry0_upd             ),
  .utlb_entry_vld          (entry0_vld             ),
  .utlb_req_vpn0           (utlb_req_vpn0          ),
  .utlb_req_vpn2           (utlb_req_vpn2          ),
  .utlb_req_vpn3           (utlb_req_vpn3          ),
  .utlb_upd_flg            (utlb_upd_flg           ),
  .utlb_upd_ppn            (utlb_upd_ppn           ),
  .utlb_upd_vpn            (utlb_upd_vpn           ),
  .mmu_sv48_en             (mmu_sv48_en            )
);


// &ConnRule(s/utlb_entry/entry1/); @339
// &Instance("xx_mmu_dutlb_entry","x_xx_mmu_dutlb_entry1"); @340
xx_mmu_dutlb_entry  x_xx_mmu_dutlb_entry1 (
  .cp0_mmu_icg_en          (cp0_mmu_icg_en         ),
  .cpurst_b                (cpurst_b               ),
  .lsu_mmu_tlb_va          (lsu_mmu_tlb_va         ),
  .pad_yy_icg_scan_en      (pad_yy_icg_scan_en     ),
  .regs_utlb_clr           (regs_utlb_clr          ),
  .tlboper_utlb_clr        (tlboper_utlb_clr       ),
  .tlboper_utlb_inv_va_req (tlboper_utlb_inv_va_req),
  .utlb_clk                (utlb_clk               ),
  .utlb_entry_flg          (entry1_flg             ),
  .utlb_entry_hit0         (entry1_hit0            ),
  .utlb_entry_hit2         (entry1_hit2            ),
  .utlb_entry_hit3         (entry1_hit3            ),
  .utlb_entry_ppn          (entry1_ppn             ),
  .utlb_entry_upd          (entry1_upd             ),
  .utlb_entry_vld          (entry1_vld             ),
  .utlb_req_vpn0           (utlb_req_vpn0          ),
  .utlb_req_vpn2           (utlb_req_vpn2          ),
  .utlb_req_vpn3           (utlb_req_vpn3          ),
  .utlb_upd_flg            (utlb_upd_flg           ),
  .utlb_upd_ppn            (utlb_upd_ppn           ),
  .utlb_upd_vpn            (utlb_upd_vpn           ),
  .mmu_sv48_en             (mmu_sv48_en            )
);


// &ConnRule(s/utlb_entry/entry2/); @342
// &Instance("xx_mmu_dutlb_entry","x_xx_mmu_dutlb_entry2"); @343
xx_mmu_dutlb_entry  x_xx_mmu_dutlb_entry2 (
  .cp0_mmu_icg_en          (cp0_mmu_icg_en         ),
  .cpurst_b                (cpurst_b               ),
  .lsu_mmu_tlb_va          (lsu_mmu_tlb_va         ),
  .pad_yy_icg_scan_en      (pad_yy_icg_scan_en     ),
  .regs_utlb_clr           (regs_utlb_clr          ),
  .tlboper_utlb_clr        (tlboper_utlb_clr       ),
  .tlboper_utlb_inv_va_req (tlboper_utlb_inv_va_req),
  .utlb_clk                (utlb_clk               ),
  .utlb_entry_flg          (entry2_flg             ),
  .utlb_entry_hit0         (entry2_hit0            ),
  .utlb_entry_hit2         (entry2_hit2            ),
  .utlb_entry_hit3         (entry2_hit3            ),
  .utlb_entry_ppn          (entry2_ppn             ),
  .utlb_entry_upd          (entry2_upd             ),
  .utlb_entry_vld          (entry2_vld             ),
  .utlb_req_vpn0           (utlb_req_vpn0          ),
  .utlb_req_vpn2           (utlb_req_vpn2          ),
  .utlb_req_vpn3           (utlb_req_vpn3          ),
  .utlb_upd_flg            (utlb_upd_flg           ),
  .utlb_upd_ppn            (utlb_upd_ppn           ),
  .utlb_upd_vpn            (utlb_upd_vpn           ),
  .mmu_sv48_en             (mmu_sv48_en            )
);


// &ConnRule(s/utlb_entry/entry3/); @345
// &Instance("xx_mmu_dutlb_entry","x_xx_mmu_dutlb_entry3"); @346
xx_mmu_dutlb_entry  x_xx_mmu_dutlb_entry3 (
  .cp0_mmu_icg_en          (cp0_mmu_icg_en         ),
  .cpurst_b                (cpurst_b               ),
  .lsu_mmu_tlb_va          (lsu_mmu_tlb_va         ),
  .pad_yy_icg_scan_en      (pad_yy_icg_scan_en     ),
  .regs_utlb_clr           (regs_utlb_clr          ),
  .tlboper_utlb_clr        (tlboper_utlb_clr       ),
  .tlboper_utlb_inv_va_req (tlboper_utlb_inv_va_req),
  .utlb_clk                (utlb_clk               ),
  .utlb_entry_flg          (entry3_flg             ),
  .utlb_entry_hit0         (entry3_hit0            ),
  .utlb_entry_hit2         (entry3_hit2            ),
  .utlb_entry_hit3         (entry3_hit3            ),
  .utlb_entry_ppn          (entry3_ppn             ),
  .utlb_entry_upd          (entry3_upd             ),
  .utlb_entry_vld          (entry3_vld             ),
  .utlb_req_vpn0           (utlb_req_vpn0          ),
  .utlb_req_vpn2           (utlb_req_vpn2          ),
  .utlb_req_vpn3           (utlb_req_vpn3          ),
  .utlb_upd_flg            (utlb_upd_flg           ),
  .utlb_upd_ppn            (utlb_upd_ppn           ),
  .utlb_upd_vpn            (utlb_upd_vpn           ),
  .mmu_sv48_en             (mmu_sv48_en            )
);


// &ConnRule(s/utlb_entry/entry4/); @348
// &Instance("xx_mmu_dutlb_entry","x_xx_mmu_dutlb_entry4"); @349
xx_mmu_dutlb_entry  x_xx_mmu_dutlb_entry4 (
  .cp0_mmu_icg_en          (cp0_mmu_icg_en         ),
  .cpurst_b                (cpurst_b               ),
  .lsu_mmu_tlb_va          (lsu_mmu_tlb_va         ),
  .pad_yy_icg_scan_en      (pad_yy_icg_scan_en     ),
  .regs_utlb_clr           (regs_utlb_clr          ),
  .tlboper_utlb_clr        (tlboper_utlb_clr       ),
  .tlboper_utlb_inv_va_req (tlboper_utlb_inv_va_req),
  .utlb_clk                (utlb_clk               ),
  .utlb_entry_flg          (entry4_flg             ),
  .utlb_entry_hit0         (entry4_hit0            ),
  .utlb_entry_hit2         (entry4_hit2            ),
  .utlb_entry_hit3         (entry4_hit3            ),
  .utlb_entry_ppn          (entry4_ppn             ),
  .utlb_entry_upd          (entry4_upd             ),
  .utlb_entry_vld          (entry4_vld             ),
  .utlb_req_vpn0           (utlb_req_vpn0          ),
  .utlb_req_vpn2           (utlb_req_vpn2          ),
  .utlb_req_vpn3           (utlb_req_vpn3          ),
  .utlb_upd_flg            (utlb_upd_flg           ),
  .utlb_upd_ppn            (utlb_upd_ppn           ),
  .utlb_upd_vpn            (utlb_upd_vpn           ),
  .mmu_sv48_en             (mmu_sv48_en            )
);


// &ConnRule(s/utlb_entry/entry5/); @351
// &Instance("xx_mmu_dutlb_entry","x_xx_mmu_dutlb_entry5"); @352
xx_mmu_dutlb_entry  x_xx_mmu_dutlb_entry5 (
  .cp0_mmu_icg_en          (cp0_mmu_icg_en         ),
  .cpurst_b                (cpurst_b               ),
  .lsu_mmu_tlb_va          (lsu_mmu_tlb_va         ),
  .pad_yy_icg_scan_en      (pad_yy_icg_scan_en     ),
  .regs_utlb_clr           (regs_utlb_clr          ),
  .tlboper_utlb_clr        (tlboper_utlb_clr       ),
  .tlboper_utlb_inv_va_req (tlboper_utlb_inv_va_req),
  .utlb_clk                (utlb_clk               ),
  .utlb_entry_flg          (entry5_flg             ),
  .utlb_entry_hit0         (entry5_hit0            ),
  .utlb_entry_hit2         (entry5_hit2            ),
  .utlb_entry_hit3         (entry5_hit3            ),
  .utlb_entry_ppn          (entry5_ppn             ),
  .utlb_entry_upd          (entry5_upd             ),
  .utlb_entry_vld          (entry5_vld             ),
  .utlb_req_vpn0           (utlb_req_vpn0          ),
  .utlb_req_vpn2           (utlb_req_vpn2          ),
  .utlb_req_vpn3           (utlb_req_vpn3          ),
  .utlb_upd_flg            (utlb_upd_flg           ),
  .utlb_upd_ppn            (utlb_upd_ppn           ),
  .utlb_upd_vpn            (utlb_upd_vpn           ),
  .mmu_sv48_en             (mmu_sv48_en            )
);


// &ConnRule(s/utlb_entry/entry6/); @354
// &Instance("xx_mmu_dutlb_entry","x_xx_mmu_dutlb_entry6"); @355
xx_mmu_dutlb_entry  x_xx_mmu_dutlb_entry6 (
  .cp0_mmu_icg_en          (cp0_mmu_icg_en         ),
  .cpurst_b                (cpurst_b               ),
  .lsu_mmu_tlb_va          (lsu_mmu_tlb_va         ),
  .pad_yy_icg_scan_en      (pad_yy_icg_scan_en     ),
  .regs_utlb_clr           (regs_utlb_clr          ),
  .tlboper_utlb_clr        (tlboper_utlb_clr       ),
  .tlboper_utlb_inv_va_req (tlboper_utlb_inv_va_req),
  .utlb_clk                (utlb_clk               ),
  .utlb_entry_flg          (entry6_flg             ),
  .utlb_entry_hit0         (entry6_hit0            ),
  .utlb_entry_hit2         (entry6_hit2            ),
  .utlb_entry_hit3         (entry6_hit3            ),
  .utlb_entry_ppn          (entry6_ppn             ),
  .utlb_entry_upd          (entry6_upd             ),
  .utlb_entry_vld          (entry6_vld             ),
  .utlb_req_vpn0           (utlb_req_vpn0          ),
  .utlb_req_vpn2           (utlb_req_vpn2          ),
  .utlb_req_vpn3           (utlb_req_vpn3          ),
  .utlb_upd_flg            (utlb_upd_flg           ),
  .utlb_upd_ppn            (utlb_upd_ppn           ),
  .utlb_upd_vpn            (utlb_upd_vpn           ),
  .mmu_sv48_en             (mmu_sv48_en            )
);


// &ConnRule(s/utlb_entry/entry7/); @357
// &Instance("xx_mmu_dutlb_entry","x_xx_mmu_dutlb_entry7"); @358
xx_mmu_dutlb_entry  x_xx_mmu_dutlb_entry7 (
  .cp0_mmu_icg_en          (cp0_mmu_icg_en         ),
  .cpurst_b                (cpurst_b               ),
  .lsu_mmu_tlb_va          (lsu_mmu_tlb_va         ),
  .pad_yy_icg_scan_en      (pad_yy_icg_scan_en     ),
  .regs_utlb_clr           (regs_utlb_clr          ),
  .tlboper_utlb_clr        (tlboper_utlb_clr       ),
  .tlboper_utlb_inv_va_req (tlboper_utlb_inv_va_req),
  .utlb_clk                (utlb_clk               ),
  .utlb_entry_flg          (entry7_flg             ),
  .utlb_entry_hit0         (entry7_hit0            ),
  .utlb_entry_hit2         (entry7_hit2            ),
  .utlb_entry_hit3         (entry7_hit3            ),
  .utlb_entry_ppn          (entry7_ppn             ),
  .utlb_entry_upd          (entry7_upd             ),
  .utlb_entry_vld          (entry7_vld             ),
  .utlb_req_vpn0           (utlb_req_vpn0          ),
  .utlb_req_vpn2           (utlb_req_vpn2          ),
  .utlb_req_vpn3           (utlb_req_vpn3          ),
  .utlb_upd_flg            (utlb_upd_flg           ),
  .utlb_upd_ppn            (utlb_upd_ppn           ),
  .utlb_upd_vpn            (utlb_upd_vpn           ),
  .mmu_sv48_en             (mmu_sv48_en            )
);


// &ConnRule(s/utlb_entry/entry8/); @360
// &Instance("xx_mmu_dutlb_entry","x_xx_mmu_dutlb_entry8"); @361
xx_mmu_dutlb_entry  x_xx_mmu_dutlb_entry8 (
  .cp0_mmu_icg_en          (cp0_mmu_icg_en         ),
  .cpurst_b                (cpurst_b               ),
  .lsu_mmu_tlb_va          (lsu_mmu_tlb_va         ),
  .pad_yy_icg_scan_en      (pad_yy_icg_scan_en     ),
  .regs_utlb_clr           (regs_utlb_clr          ),
  .tlboper_utlb_clr        (tlboper_utlb_clr       ),
  .tlboper_utlb_inv_va_req (tlboper_utlb_inv_va_req),
  .utlb_clk                (utlb_clk               ),
  .utlb_entry_flg          (entry8_flg             ),
  .utlb_entry_hit0         (entry8_hit0            ),
  .utlb_entry_hit2         (entry8_hit2            ),
  .utlb_entry_hit3         (entry8_hit3            ),
  .utlb_entry_ppn          (entry8_ppn             ),
  .utlb_entry_upd          (entry8_upd             ),
  .utlb_entry_vld          (entry8_vld             ),
  .utlb_req_vpn0           (utlb_req_vpn0          ),
  .utlb_req_vpn2           (utlb_req_vpn2          ),
  .utlb_req_vpn3           (utlb_req_vpn3          ),
  .utlb_upd_flg            (utlb_upd_flg           ),
  .utlb_upd_ppn            (utlb_upd_ppn           ),
  .utlb_upd_vpn            (utlb_upd_vpn           ),
  .mmu_sv48_en             (mmu_sv48_en            )
);


// &ConnRule(s/utlb_entry/entry9/); @363
// &Instance("xx_mmu_dutlb_entry","x_xx_mmu_dutlb_entry9"); @364
xx_mmu_dutlb_entry  x_xx_mmu_dutlb_entry9 (
  .cp0_mmu_icg_en          (cp0_mmu_icg_en         ),
  .cpurst_b                (cpurst_b               ),
  .lsu_mmu_tlb_va          (lsu_mmu_tlb_va         ),
  .pad_yy_icg_scan_en      (pad_yy_icg_scan_en     ),
  .regs_utlb_clr           (regs_utlb_clr          ),
  .tlboper_utlb_clr        (tlboper_utlb_clr       ),
  .tlboper_utlb_inv_va_req (tlboper_utlb_inv_va_req),
  .utlb_clk                (utlb_clk               ),
  .utlb_entry_flg          (entry9_flg             ),
  .utlb_entry_hit0         (entry9_hit0            ),
  .utlb_entry_hit2         (entry9_hit2            ),
  .utlb_entry_hit3         (entry9_hit3            ),
  .utlb_entry_ppn          (entry9_ppn             ),
  .utlb_entry_upd          (entry9_upd             ),
  .utlb_entry_vld          (entry9_vld             ),
  .utlb_req_vpn0           (utlb_req_vpn0          ),
  .utlb_req_vpn2           (utlb_req_vpn2          ),
  .utlb_req_vpn3           (utlb_req_vpn3          ),
  .utlb_upd_flg            (utlb_upd_flg           ),
  .utlb_upd_ppn            (utlb_upd_ppn           ),
  .utlb_upd_vpn            (utlb_upd_vpn           ),
  .mmu_sv48_en             (mmu_sv48_en            )
);


// &ConnRule(s/utlb_entry/entry10/); @366
// &Instance("xx_mmu_dutlb_entry","x_xx_mmu_dutlb_entry10"); @367
xx_mmu_dutlb_entry  x_xx_mmu_dutlb_entry10 (
  .cp0_mmu_icg_en          (cp0_mmu_icg_en         ),
  .cpurst_b                (cpurst_b               ),
  .lsu_mmu_tlb_va          (lsu_mmu_tlb_va         ),
  .pad_yy_icg_scan_en      (pad_yy_icg_scan_en     ),
  .regs_utlb_clr           (regs_utlb_clr          ),
  .tlboper_utlb_clr        (tlboper_utlb_clr       ),
  .tlboper_utlb_inv_va_req (tlboper_utlb_inv_va_req),
  .utlb_clk                (utlb_clk               ),
  .utlb_entry_flg          (entry10_flg            ),
  .utlb_entry_hit0         (entry10_hit0           ),
  .utlb_entry_hit2         (entry10_hit2           ),
  .utlb_entry_hit3         (entry10_hit3           ),
  .utlb_entry_ppn          (entry10_ppn            ),
  .utlb_entry_upd          (entry10_upd            ),
  .utlb_entry_vld          (entry10_vld            ),
  .utlb_req_vpn0           (utlb_req_vpn0          ),
  .utlb_req_vpn2           (utlb_req_vpn2          ),
  .utlb_req_vpn3           (utlb_req_vpn3          ),
  .utlb_upd_flg            (utlb_upd_flg           ),
  .utlb_upd_ppn            (utlb_upd_ppn           ),
  .utlb_upd_vpn            (utlb_upd_vpn           ),
  .mmu_sv48_en             (mmu_sv48_en            )
);


// &ConnRule(s/utlb_entry/entry11/); @369
// &Instance("xx_mmu_dutlb_entry","x_xx_mmu_dutlb_entry11"); @370
xx_mmu_dutlb_entry  x_xx_mmu_dutlb_entry11 (
  .cp0_mmu_icg_en          (cp0_mmu_icg_en         ),
  .cpurst_b                (cpurst_b               ),
  .lsu_mmu_tlb_va          (lsu_mmu_tlb_va         ),
  .pad_yy_icg_scan_en      (pad_yy_icg_scan_en     ),
  .regs_utlb_clr           (regs_utlb_clr          ),
  .tlboper_utlb_clr        (tlboper_utlb_clr       ),
  .tlboper_utlb_inv_va_req (tlboper_utlb_inv_va_req),
  .utlb_clk                (utlb_clk               ),
  .utlb_entry_flg          (entry11_flg            ),
  .utlb_entry_hit0         (entry11_hit0           ),
  .utlb_entry_hit2         (entry11_hit2           ),
  .utlb_entry_hit3         (entry11_hit3           ),
  .utlb_entry_ppn          (entry11_ppn            ),
  .utlb_entry_upd          (entry11_upd            ),
  .utlb_entry_vld          (entry11_vld            ),
  .utlb_req_vpn0           (utlb_req_vpn0          ),
  .utlb_req_vpn2           (utlb_req_vpn2          ),
  .utlb_req_vpn3           (utlb_req_vpn3          ),
  .utlb_upd_flg            (utlb_upd_flg           ),
  .utlb_upd_ppn            (utlb_upd_ppn           ),
  .utlb_upd_vpn            (utlb_upd_vpn           ),
  .mmu_sv48_en             (mmu_sv48_en            )
);


// &ConnRule(s/utlb_entry/entry12/); @372
// &Instance("xx_mmu_dutlb_entry","x_xx_mmu_dutlb_entry12"); @373
xx_mmu_dutlb_entry  x_xx_mmu_dutlb_entry12 (
  .cp0_mmu_icg_en          (cp0_mmu_icg_en         ),
  .cpurst_b                (cpurst_b               ),
  .lsu_mmu_tlb_va          (lsu_mmu_tlb_va         ),
  .pad_yy_icg_scan_en      (pad_yy_icg_scan_en     ),
  .regs_utlb_clr           (regs_utlb_clr          ),
  .tlboper_utlb_clr        (tlboper_utlb_clr       ),
  .tlboper_utlb_inv_va_req (tlboper_utlb_inv_va_req),
  .utlb_clk                (utlb_clk               ),
  .utlb_entry_flg          (entry12_flg            ),
  .utlb_entry_hit0         (entry12_hit0           ),
  .utlb_entry_hit2         (entry12_hit2           ),
  .utlb_entry_hit3         (entry12_hit3           ),
  .utlb_entry_ppn          (entry12_ppn            ),
  .utlb_entry_upd          (entry12_upd            ),
  .utlb_entry_vld          (entry12_vld            ),
  .utlb_req_vpn0           (utlb_req_vpn0          ),
  .utlb_req_vpn2           (utlb_req_vpn2          ),
  .utlb_req_vpn3           (utlb_req_vpn3          ),
  .utlb_upd_flg            (utlb_upd_flg           ),
  .utlb_upd_ppn            (utlb_upd_ppn           ),
  .utlb_upd_vpn            (utlb_upd_vpn           ),
  .mmu_sv48_en             (mmu_sv48_en            )
);


// &ConnRule(s/utlb_entry/entry13/); @375
// &Instance("xx_mmu_dutlb_entry","x_xx_mmu_dutlb_entry13"); @376
xx_mmu_dutlb_entry  x_xx_mmu_dutlb_entry13 (
  .cp0_mmu_icg_en          (cp0_mmu_icg_en         ),
  .cpurst_b                (cpurst_b               ),
  .lsu_mmu_tlb_va          (lsu_mmu_tlb_va         ),
  .pad_yy_icg_scan_en      (pad_yy_icg_scan_en     ),
  .regs_utlb_clr           (regs_utlb_clr          ),
  .tlboper_utlb_clr        (tlboper_utlb_clr       ),
  .tlboper_utlb_inv_va_req (tlboper_utlb_inv_va_req),
  .utlb_clk                (utlb_clk               ),
  .utlb_entry_flg          (entry13_flg            ),
  .utlb_entry_hit0         (entry13_hit0           ),
  .utlb_entry_hit2         (entry13_hit2           ),
  .utlb_entry_hit3         (entry13_hit3           ),
  .utlb_entry_ppn          (entry13_ppn            ),
  .utlb_entry_upd          (entry13_upd            ),
  .utlb_entry_vld          (entry13_vld            ),
  .utlb_req_vpn0           (utlb_req_vpn0          ),
  .utlb_req_vpn2           (utlb_req_vpn2          ),
  .utlb_req_vpn3           (utlb_req_vpn3          ),
  .utlb_upd_flg            (utlb_upd_flg           ),
  .utlb_upd_ppn            (utlb_upd_ppn           ),
  .utlb_upd_vpn            (utlb_upd_vpn           ),
  .mmu_sv48_en             (mmu_sv48_en            )
);


// &ConnRule(s/utlb_entry/entry14/); @378
// &Instance("xx_mmu_dutlb_entry","x_xx_mmu_dutlb_entry14"); @379
xx_mmu_dutlb_entry  x_xx_mmu_dutlb_entry14 (
  .cp0_mmu_icg_en          (cp0_mmu_icg_en         ),
  .cpurst_b                (cpurst_b               ),
  .lsu_mmu_tlb_va          (lsu_mmu_tlb_va         ),
  .pad_yy_icg_scan_en      (pad_yy_icg_scan_en     ),
  .regs_utlb_clr           (regs_utlb_clr          ),
  .tlboper_utlb_clr        (tlboper_utlb_clr       ),
  .tlboper_utlb_inv_va_req (tlboper_utlb_inv_va_req),
  .utlb_clk                (utlb_clk               ),
  .utlb_entry_flg          (entry14_flg            ),
  .utlb_entry_hit0         (entry14_hit0           ),
  .utlb_entry_hit2         (entry14_hit2           ),
  .utlb_entry_hit3         (entry14_hit3           ),
  .utlb_entry_ppn          (entry14_ppn            ),
  .utlb_entry_upd          (entry14_upd            ),
  .utlb_entry_vld          (entry14_vld            ),
  .utlb_req_vpn0           (utlb_req_vpn0          ),
  .utlb_req_vpn2           (utlb_req_vpn2          ),
  .utlb_req_vpn3           (utlb_req_vpn3          ),
  .utlb_upd_flg            (utlb_upd_flg           ),
  .utlb_upd_ppn            (utlb_upd_ppn           ),
  .utlb_upd_vpn            (utlb_upd_vpn           ),
  .mmu_sv48_en             (mmu_sv48_en            )
);


// &ConnRule(s/utlb_entry/entry15/); @381
// &Instance("xx_mmu_dutlb_entry","x_xx_mmu_dutlb_entry15"); @382
xx_mmu_dutlb_entry  x_xx_mmu_dutlb_entry15 (
  .cp0_mmu_icg_en          (cp0_mmu_icg_en         ),
  .cpurst_b                (cpurst_b               ),
  .lsu_mmu_tlb_va          (lsu_mmu_tlb_va         ),
  .pad_yy_icg_scan_en      (pad_yy_icg_scan_en     ),
  .regs_utlb_clr           (regs_utlb_clr          ),
  .tlboper_utlb_clr        (tlboper_utlb_clr       ),
  .tlboper_utlb_inv_va_req (tlboper_utlb_inv_va_req),
  .utlb_clk                (utlb_clk               ),
  .utlb_entry_flg          (entry15_flg            ),
  .utlb_entry_hit0         (entry15_hit0           ),
  .utlb_entry_hit2         (entry15_hit2           ),
  .utlb_entry_hit3         (entry15_hit3           ),
  .utlb_entry_ppn          (entry15_ppn            ),
  .utlb_entry_upd          (entry15_upd            ),
  .utlb_entry_vld          (entry15_vld            ),
  .utlb_req_vpn0           (utlb_req_vpn0          ),
  .utlb_req_vpn2           (utlb_req_vpn2          ),
  .utlb_req_vpn3           (utlb_req_vpn3          ),
  .utlb_upd_flg            (utlb_upd_flg           ),
  .utlb_upd_ppn            (utlb_upd_ppn           ),
  .utlb_upd_vpn            (utlb_upd_vpn           ),
  .mmu_sv48_en             (mmu_sv48_en            )
);


// &ConnRule(s/utlb_entry/entry16/); @384
// &Instance("xx_mmu_dutlb_huge_entry","x_xx_mmu_dutlb_entry16"); @385
xx_mmu_dutlb_huge_entry  x_xx_mmu_dutlb_entry16 (
  .cp0_mmu_icg_en          (cp0_mmu_icg_en         ),
  .cpurst_b                (cpurst_b               ),
  .lsu_mmu_tlb_va          (lsu_mmu_tlb_va         ),
  .pad_yy_icg_scan_en      (pad_yy_icg_scan_en     ),
  .regs_utlb_clr           (regs_utlb_clr          ),
  .tlboper_utlb_clr        (tlboper_utlb_clr       ),
  .tlboper_utlb_inv_va_req (tlboper_utlb_inv_va_req),
  .utlb_clk                (utlb_clk               ),
  .utlb_entry_flg          (entry16_flg            ),
  .utlb_entry_hit0         (entry16_hit0           ),
  .utlb_entry_hit2         (entry16_hit2           ),
  .utlb_entry_hit3         (entry16_hit3           ),
  .utlb_entry_ppn          (entry16_ppn            ),
  .utlb_entry_upd          (utlb_huge_entry_upd    ),
  .utlb_entry_vld          (entry16_vld            ),
  .utlb_req_vpn0           (utlb_req_vpn0          ),
  .utlb_req_vpn2           (utlb_req_vpn2          ),
  .utlb_req_vpn3           (utlb_req_vpn3          ),
  .utlb_upd_flg            (utlb_upd_flg           ),
  .utlb_upd_ppn            (utlb_upd_ppn           ),
  .utlb_upd_vpn            (utlb_upd_vpn           ),
  .mmu_sv48_en             (mmu_sv48_en            )
);

// &Connect( .utlb_entry_upd     (utlb_huge_entry_upd)); @386


//----------------------------------------------------------
//                  uTLB Entry read
//----------------------------------------------------------
assign dutlb_off_hit     = !regs_mmu_en || cp0_mach_mode;
assign dutlb_xx_mmu_off  = dutlb_off_hit;

// Instance the two read ports for LSU read and write
// &ConnRule(s/_x/0/); @396
// &Instance("xx_mmu_dutlb_read","x_xx_mmu_dutlb_read0"); @397
xx_mmu_dutlb_read #(.IID_WIDTH(IID_WIDTH)) x_xx_mmu_dutlb_read0 (
  .biu_mmu_smp_disable       (biu_mmu_smp_disable      ),
  .cp0_mach_mode             (cp0_mach_mode            ),
  .cp0_mmu_icg_en            (cp0_mmu_icg_en           ),
  .cp0_mmu_mxr               (cp0_mmu_mxr              ),
  .cp0_mmu_sum               (cp0_mmu_sum              ),
  .mmu_sv48_en               (mmu_sv48_en              ),
  .cp0_supv_mode             (cp0_supv_mode            ),
  .cp0_user_mode             (cp0_user_mode            ),
  .cpurst_b                  (cpurst_b                 ),
  .dplru_clk                 (dplru_clk                ),
  .dutlb_acc_flt_x           (dutlb_acc_flt0           ),
  .dutlb_clk                 (dutlb_clk                ),
  .dutlb_expt_for_taken      (dutlb_expt_for_taken     ),
  .dutlb_inst_vpn_match_x     (dutlb_inst_vpn_match0     ),
  .dutlb_inst_id_older_x     (dutlb_inst_id_older0     ),
  .dutlb_miss_vld_short_x    (dutlb_miss_vld_short0    ),
  .dutlb_miss_vld_x          (dutlb_miss_vld0          ),
  .dutlb_off_hit             (dutlb_off_hit            ),
  .dutlb_ori_read_x          (dutlb_ori_read0          ),
  .dutlb_plru_read_hit_vld_x (dutlb_plru_read_hit_vld0 ),
  .dutlb_plru_read_hit_x     (dutlb_plru_read_hit0     ),
  .dutlb_read_type_x         (dutlb_read_type0         ),
  .dutlb_ref_acflt           (dutlb_ref_acflt          ),
  .dutlb_ref_pgflt           (dutlb_ref_pgflt          ),
  .dutlb_refill_on_x         (dutlb_refill_on0         ),
  .dutlb_va_chg_x            (dutlb_va_chg0            ),
  .entry0_flg                (entry0_flg               ),
  .entry0_hit_x              (entry0_hit0              ),
  .entry0_ppn                (entry0_ppn               ),
  .entry0_vld                (entry0_vld               ),
  .entry10_flg               (entry10_flg              ),
  .entry10_hit_x             (entry10_hit0             ),
  .entry10_ppn               (entry10_ppn              ),
  .entry10_vld               (entry10_vld              ),
  .entry11_flg               (entry11_flg              ),
  .entry11_hit_x             (entry11_hit0             ),
  .entry11_ppn               (entry11_ppn              ),
  .entry11_vld               (entry11_vld              ),
  .entry12_flg               (entry12_flg              ),
  .entry12_hit_x             (entry12_hit0             ),
  .entry12_ppn               (entry12_ppn              ),
  .entry12_vld               (entry12_vld              ),
  .entry13_flg               (entry13_flg              ),
  .entry13_hit_x             (entry13_hit0             ),
  .entry13_ppn               (entry13_ppn              ),
  .entry13_vld               (entry13_vld              ),
  .entry14_flg               (entry14_flg              ),
  .entry14_hit_x             (entry14_hit0             ),
  .entry14_ppn               (entry14_ppn              ),
  .entry14_vld               (entry14_vld              ),
  .entry15_flg               (entry15_flg              ),
  .entry15_hit_x             (entry15_hit0             ),
  .entry15_ppn               (entry15_ppn              ),
  .entry15_vld               (entry15_vld              ),
  .entry16_flg               (entry16_flg              ),
  .entry16_hit_x             (entry16_hit0             ),
  .entry16_ppn               (entry16_ppn              ),
  .entry16_vld               (entry16_vld              ),
  .entry1_flg                (entry1_flg               ),
  .entry1_hit_x              (entry1_hit0              ),
  .entry1_ppn                (entry1_ppn               ),
  .entry1_vld                (entry1_vld               ),
  .entry2_flg                (entry2_flg               ),
  .entry2_hit_x              (entry2_hit0              ),
  .entry2_ppn                (entry2_ppn               ),
  .entry2_vld                (entry2_vld               ),
  .entry3_flg                (entry3_flg               ),
  .entry3_hit_x              (entry3_hit0              ),
  .entry3_ppn                (entry3_ppn               ),
  .entry3_vld                (entry3_vld               ),
  .entry4_flg                (entry4_flg               ),
  .entry4_hit_x              (entry4_hit0              ),
  .entry4_ppn                (entry4_ppn               ),
  .entry4_vld                (entry4_vld               ),
  .entry5_flg                (entry5_flg               ),
  .entry5_hit_x              (entry5_hit0              ),
  .entry5_ppn                (entry5_ppn               ),
  .entry5_vld                (entry5_vld               ),
  .entry6_flg                (entry6_flg               ),
  .entry6_hit_x              (entry6_hit0              ),
  .entry6_ppn                (entry6_ppn               ),
  .entry6_vld                (entry6_vld               ),
  .entry7_flg                (entry7_flg               ),
  .entry7_hit_x              (entry7_hit0              ),
  .entry7_ppn                (entry7_ppn               ),
  .entry7_vld                (entry7_vld               ),
  .entry8_flg                (entry8_flg               ),
  .entry8_hit_x              (entry8_hit0              ),
  .entry8_ppn                (entry8_ppn               ),
  .entry8_vld                (entry8_vld               ),
  .entry9_flg                (entry9_flg               ),
  .entry9_hit_x              (entry9_hit0              ),
  .entry9_ppn                (entry9_ppn               ),
  .entry9_vld                (entry9_vld               ),
  .forever_cpuclk            (forever_cpuclk           ),
  .lsu_mmu_abort_x           (lsu_mmu_abort0           ),
  .lsu_mmu_id_x              (lsu_mmu_id0              ),
  .lsu_mmu_stamo_pa_x        (lsu_mmu_stamo_read_pa0        ),
  .lsu_mmu_stamo_vld_x       (lsu_mmu_stamo_read_vld0       ),
  .lsu_mmu_va_vld_x          (lsu_mmu_va_vld0          ),
  .lsu_mmu_va_x              (lsu_mmu_va0              ),
  .lsu_mmu_vabuf_x           (lsu_mmu_vabuf0           ),
  .mmu_lsu_access_fault_x    (mmu_lsu_access_fault0    ),
  .mmu_lsu_buf_x             (mmu_lsu_buf0             ),
  .mmu_lsu_ca_x              (mmu_lsu_ca0              ),
  .mmu_lsu_pa_vld_x          (mmu_lsu_pa_vld0          ),
  .mmu_lsu_pa_x              (mmu_lsu_pa0              ),
  .mmu_lsu_page_fault_x      (mmu_lsu_page_fault0      ),
  .mmu_lsu_sec_x             (mmu_lsu_sec0             ),
  .mmu_lsu_sh_x              (mmu_lsu_sh0              ),
  .mmu_lsu_so_x              (mmu_lsu_so0              ),
  .mmu_lsu_stall_x           (mmu_lsu_stall0           ),
  .mmu_pmp_pa_x              (mmu_pmp_pa0              ),
  .mmu_sysmap_pa_x           (mmu_sysmap_pa0           ),
  .pad_yy_icg_scan_en        (pad_yy_icg_scan_en       ),
  .pmp_mmu_flg_x             (pmp_mmu_flg0             ),
  .refill_id_flop            (refill_id_flop           ),
  .sysmap_mmu_flg_x          (sysmap_mmu_flg0          ),
  .utlb_req_vpn_x            (utlb_req_vpn0            ),
  .refill_vpn                (refill_vpn               ),  // tmq fixed@hcl   20251021
  .refill_pgs                (refill_pgs               )   // tmq fixed@hcl   20251021
);

assign lsu_mmu_va_vld0 = lsu_mmu_va0_vld;
assign mmu_lsu_pa0_vld = mmu_lsu_pa_vld0;
assign dutlb_read_type0 = !lsu_mmu_st_inst0;
assign dutlb_ori_read0 = 1'b1;
assign lsu_mmu_stamo_read_vld0 = 1'b0;
assign lsu_mmu_stamo_read_pa0[PPN_WIDTH-1:0] = {PPN_WIDTH{1'b0}};

// ------------------------- add new dutlb here -------------------------
xx_mmu_dutlb_read #(.IID_WIDTH(IID_WIDTH)) x_xx_mmu_dutlb_read2 (
  .biu_mmu_smp_disable       (biu_mmu_smp_disable      ),
  .cp0_mach_mode             (cp0_mach_mode            ),
  .cp0_mmu_icg_en            (cp0_mmu_icg_en           ),
  .cp0_mmu_mxr               (cp0_mmu_mxr              ),
  .cp0_mmu_sum               (cp0_mmu_sum              ),
  .mmu_sv48_en               (mmu_sv48_en              ),
  .cp0_supv_mode             (cp0_supv_mode            ),
  .cp0_user_mode             (cp0_user_mode            ),
  .cpurst_b                  (cpurst_b                 ),
  .dplru_clk                 (dplru_clk                ),
  .dutlb_acc_flt_x           (dutlb_acc_flt2           ),
  .dutlb_clk                 (dutlb_clk                ),
  .dutlb_expt_for_taken      (dutlb_expt_for_taken     ),
  .dutlb_inst_vpn_match_x     (dutlb_inst_vpn_match2     ),
  .dutlb_inst_id_older_x     (dutlb_inst_id_older2     ),
  .dutlb_miss_vld_short_x    (dutlb_miss_vld_short2    ),
  .dutlb_miss_vld_x          (dutlb_miss_vld2          ),
  .dutlb_off_hit             (dutlb_off_hit            ),
  .dutlb_ori_read_x          (dutlb_ori_read2          ),
  .dutlb_plru_read_hit_vld_x (dutlb_plru_read_hit_vld2 ),
  .dutlb_plru_read_hit_x     (dutlb_plru_read_hit2     ),
  .dutlb_read_type_x         (dutlb_read_type2         ),
  .dutlb_ref_acflt           (dutlb_ref_acflt          ),
  .dutlb_ref_pgflt           (dutlb_ref_pgflt          ),
  .dutlb_refill_on_x         (dutlb_refill_on2         ),
  .dutlb_va_chg_x            (dutlb_va_chg2            ),
  .entry0_flg                (entry0_flg               ),
  .entry0_hit_x              (entry0_hit2              ),
  .entry0_ppn                (entry0_ppn               ),
  .entry0_vld                (entry0_vld               ),
  .entry10_flg               (entry10_flg              ),
  .entry10_hit_x             (entry10_hit2             ),
  .entry10_ppn               (entry10_ppn              ),
  .entry10_vld               (entry10_vld              ),
  .entry11_flg               (entry11_flg              ),
  .entry11_hit_x             (entry11_hit2             ),
  .entry11_ppn               (entry11_ppn              ),
  .entry11_vld               (entry11_vld              ),
  .entry12_flg               (entry12_flg              ),
  .entry12_hit_x             (entry12_hit2             ),
  .entry12_ppn               (entry12_ppn              ),
  .entry12_vld               (entry12_vld              ),
  .entry13_flg               (entry13_flg              ),
  .entry13_hit_x             (entry13_hit2             ),
  .entry13_ppn               (entry13_ppn              ),
  .entry13_vld               (entry13_vld              ),
  .entry14_flg               (entry14_flg              ),
  .entry14_hit_x             (entry14_hit2             ),
  .entry14_ppn               (entry14_ppn              ),
  .entry14_vld               (entry14_vld              ),
  .entry15_flg               (entry15_flg              ),
  .entry15_hit_x             (entry15_hit2             ),
  .entry15_ppn               (entry15_ppn              ),
  .entry15_vld               (entry15_vld              ),
  .entry16_flg               (entry16_flg              ),
  .entry16_hit_x             (entry16_hit2             ),
  .entry16_ppn               (entry16_ppn              ),
  .entry16_vld               (entry16_vld              ),
  .entry1_flg                (entry1_flg               ),
  .entry1_hit_x              (entry1_hit2              ),
  .entry1_ppn                (entry1_ppn               ),
  .entry1_vld                (entry1_vld               ),
  .entry2_flg                (entry2_flg               ),
  .entry2_hit_x              (entry2_hit2              ),
  .entry2_ppn                (entry2_ppn               ),
  .entry2_vld                (entry2_vld               ),
  .entry3_flg                (entry3_flg               ),
  .entry3_hit_x              (entry3_hit2              ),
  .entry3_ppn                (entry3_ppn               ),
  .entry3_vld                (entry3_vld               ),
  .entry4_flg                (entry4_flg               ),
  .entry4_hit_x              (entry4_hit2              ),
  .entry4_ppn                (entry4_ppn               ),
  .entry4_vld                (entry4_vld               ),
  .entry5_flg                (entry5_flg               ),
  .entry5_hit_x              (entry5_hit2              ),
  .entry5_ppn                (entry5_ppn               ),
  .entry5_vld                (entry5_vld               ),
  .entry6_flg                (entry6_flg               ),
  .entry6_hit_x              (entry6_hit2              ),
  .entry6_ppn                (entry6_ppn               ),
  .entry6_vld                (entry6_vld               ),
  .entry7_flg                (entry7_flg               ),
  .entry7_hit_x              (entry7_hit2              ),
  .entry7_ppn                (entry7_ppn               ),
  .entry7_vld                (entry7_vld               ),
  .entry8_flg                (entry8_flg               ),
  .entry8_hit_x              (entry8_hit2              ),
  .entry8_ppn                (entry8_ppn               ),
  .entry8_vld                (entry8_vld               ),
  .entry9_flg                (entry9_flg               ),
  .entry9_hit_x              (entry9_hit2              ),
  .entry9_ppn                (entry9_ppn               ),
  .entry9_vld                (entry9_vld               ),
  .forever_cpuclk            (forever_cpuclk           ),
  .lsu_mmu_abort_x           (lsu_mmu_abort2           ),
  .lsu_mmu_id_x              (lsu_mmu_id2              ),
  .lsu_mmu_stamo_pa_x        (lsu_mmu_stamo_read_pa2        ),
  .lsu_mmu_stamo_vld_x       (lsu_mmu_stamo_read_vld2       ),
  .lsu_mmu_va_vld_x          (lsu_mmu_va_vld2          ),
  .lsu_mmu_va_x              (lsu_mmu_va2              ),
  .lsu_mmu_vabuf_x           (lsu_mmu_vabuf2           ),
  .mmu_lsu_access_fault_x    (mmu_lsu_access_fault2    ),
  .mmu_lsu_buf_x             (mmu_lsu_buf2             ),
  .mmu_lsu_ca_x              (mmu_lsu_ca2              ),
  .mmu_lsu_pa_vld_x          (mmu_lsu_pa_vld2          ),
  .mmu_lsu_pa_x              (mmu_lsu_pa2              ),
  .mmu_lsu_page_fault_x      (mmu_lsu_page_fault2      ),
  .mmu_lsu_sec_x             (mmu_lsu_sec2             ),
  .mmu_lsu_sh_x              (mmu_lsu_sh2              ),
  .mmu_lsu_so_x              (mmu_lsu_so2              ),
  .mmu_lsu_stall_x           (mmu_lsu_stall2           ),
  .mmu_pmp_pa_x              (mmu_pmp_pa00              ),
  .mmu_sysmap_pa_x           (mmu_sysmap_pa00           ),
  .pad_yy_icg_scan_en        (pad_yy_icg_scan_en       ),
  .pmp_mmu_flg_x             (pmp_mmu_flg00             ),
  .refill_id_flop            (refill_id_flop           ),
  .sysmap_mmu_flg_x          (sysmap_mmu_flg00          ),
  .utlb_req_vpn_x            (utlb_req_vpn2            ),
  .refill_vpn                (refill_vpn               ),  // tmq fixed@hcl   20251021
  .refill_pgs                (refill_pgs               )   // tmq fixed@hcl   20251021
);

assign lsu_mmu_va_vld2 = lsu_mmu_va2_vld;
assign mmu_lsu_pa2_vld = mmu_lsu_pa_vld2;
assign dutlb_read_type2 = !lsu_mmu_st_inst2;
assign dutlb_ori_read2 = lsag0_ex1_is_load?1'b1:1'b0;
assign lsu_mmu_stamo_read_vld2 = lsag0_ex1_is_load? 1'b0: lsu_mmu_stamo_vld2;
assign lsu_mmu_stamo_read_pa2[PPN_WIDTH-1:0] = lsag0_ex1_is_load?{PPN_WIDTH{1'b0}}: lsu_mmu_stamo_pa2[PPN_WIDTH-1:0];

xx_mmu_dutlb_read #(.IID_WIDTH(IID_WIDTH)) x_xx_mmu_dutlb_read3 (
  .biu_mmu_smp_disable       (biu_mmu_smp_disable      ),
  .cp0_mach_mode             (cp0_mach_mode            ),
  .cp0_mmu_icg_en            (cp0_mmu_icg_en           ),
  .cp0_mmu_mxr               (cp0_mmu_mxr              ),
  .cp0_mmu_sum               (cp0_mmu_sum              ),
  .mmu_sv48_en               (mmu_sv48_en              ),
  .cp0_supv_mode             (cp0_supv_mode            ),
  .cp0_user_mode             (cp0_user_mode            ),
  .cpurst_b                  (cpurst_b                 ),
  .dplru_clk                 (dplru_clk                ),
  .dutlb_acc_flt_x           (dutlb_acc_flt3           ),
  .dutlb_clk                 (dutlb_clk                ),
  .dutlb_expt_for_taken      (dutlb_expt_for_taken     ),
  .dutlb_inst_vpn_match_x     (dutlb_inst_vpn_match3     ),
  .dutlb_inst_id_older_x     (dutlb_inst_id_older3     ),
  .dutlb_miss_vld_short_x    (dutlb_miss_vld_short3    ),
  .dutlb_miss_vld_x          (dutlb_miss_vld3          ),
  .dutlb_off_hit             (dutlb_off_hit            ),
  .dutlb_ori_read_x          (dutlb_ori_read3          ),
  .dutlb_plru_read_hit_vld_x (dutlb_plru_read_hit_vld3 ),
  .dutlb_plru_read_hit_x     (dutlb_plru_read_hit3     ),
  .dutlb_read_type_x         (dutlb_read_type3         ),
  .dutlb_ref_acflt           (dutlb_ref_acflt          ),
  .dutlb_ref_pgflt           (dutlb_ref_pgflt          ),
  .dutlb_refill_on_x         (dutlb_refill_on3         ),
  .dutlb_va_chg_x            (dutlb_va_chg3            ),
  .entry0_flg                (entry0_flg               ),
  .entry0_hit_x              (entry0_hit3              ),
  .entry0_ppn                (entry0_ppn               ),
  .entry0_vld                (entry0_vld               ),
  .entry10_flg               (entry10_flg              ),
  .entry10_hit_x             (entry10_hit3             ),
  .entry10_ppn               (entry10_ppn              ),
  .entry10_vld               (entry10_vld              ),
  .entry11_flg               (entry11_flg              ),
  .entry11_hit_x             (entry11_hit3             ),
  .entry11_ppn               (entry11_ppn              ),
  .entry11_vld               (entry11_vld              ),
  .entry12_flg               (entry12_flg              ),
  .entry12_hit_x             (entry12_hit3             ),
  .entry12_ppn               (entry12_ppn              ),
  .entry12_vld               (entry12_vld              ),
  .entry13_flg               (entry13_flg              ),
  .entry13_hit_x             (entry13_hit3             ),
  .entry13_ppn               (entry13_ppn              ),
  .entry13_vld               (entry13_vld              ),
  .entry14_flg               (entry14_flg              ),
  .entry14_hit_x             (entry14_hit3             ),
  .entry14_ppn               (entry14_ppn              ),
  .entry14_vld               (entry14_vld              ),
  .entry15_flg               (entry15_flg              ),
  .entry15_hit_x             (entry15_hit3             ),
  .entry15_ppn               (entry15_ppn              ),
  .entry15_vld               (entry15_vld              ),
  .entry16_flg               (entry16_flg              ),
  .entry16_hit_x             (entry16_hit3             ),
  .entry16_ppn               (entry16_ppn              ),
  .entry16_vld               (entry16_vld              ),
  .entry1_flg                (entry1_flg               ),
  .entry1_hit_x              (entry1_hit3              ),
  .entry1_ppn                (entry1_ppn               ),
  .entry1_vld                (entry1_vld               ),
  .entry2_flg                (entry2_flg               ),
  .entry2_hit_x              (entry2_hit3              ),
  .entry2_ppn                (entry2_ppn               ),
  .entry2_vld                (entry2_vld               ),
  .entry3_flg                (entry3_flg               ),
  .entry3_hit_x              (entry3_hit3              ),
  .entry3_ppn                (entry3_ppn               ),
  .entry3_vld                (entry3_vld               ),
  .entry4_flg                (entry4_flg               ),
  .entry4_hit_x              (entry4_hit3              ),
  .entry4_ppn                (entry4_ppn               ),
  .entry4_vld                (entry4_vld               ),
  .entry5_flg                (entry5_flg               ),
  .entry5_hit_x              (entry5_hit3              ),
  .entry5_ppn                (entry5_ppn               ),
  .entry5_vld                (entry5_vld               ),
  .entry6_flg                (entry6_flg               ),
  .entry6_hit_x              (entry6_hit3              ),
  .entry6_ppn                (entry6_ppn               ),
  .entry6_vld                (entry6_vld               ),
  .entry7_flg                (entry7_flg               ),
  .entry7_hit_x              (entry7_hit3              ),
  .entry7_ppn                (entry7_ppn               ),
  .entry7_vld                (entry7_vld               ),
  .entry8_flg                (entry8_flg               ),
  .entry8_hit_x              (entry8_hit3              ),
  .entry8_ppn                (entry8_ppn               ),
  .entry8_vld                (entry8_vld               ),
  .entry9_flg                (entry9_flg               ),
  .entry9_hit_x              (entry9_hit3              ),
  .entry9_ppn                (entry9_ppn               ),
  .entry9_vld                (entry9_vld               ),
  .forever_cpuclk            (forever_cpuclk           ),
  .lsu_mmu_abort_x           (lsu_mmu_abort3           ),
  .lsu_mmu_id_x              (lsu_mmu_id3              ),
  .lsu_mmu_stamo_pa_x        (lsu_mmu_stamo_read_pa3        ),
  .lsu_mmu_stamo_vld_x       (lsu_mmu_stamo_read_vld3       ),
  .lsu_mmu_va_vld_x          (lsu_mmu_va_vld3          ),
  .lsu_mmu_va_x              (lsu_mmu_va3              ),
  .lsu_mmu_vabuf_x           (lsu_mmu_vabuf3           ),
  .mmu_lsu_access_fault_x    (mmu_lsu_access_fault3    ),
  .mmu_lsu_buf_x             (mmu_lsu_buf3             ),
  .mmu_lsu_ca_x              (mmu_lsu_ca3              ),
  .mmu_lsu_pa_vld_x          (mmu_lsu_pa_vld3          ),
  .mmu_lsu_pa_x              (mmu_lsu_pa3              ),
  .mmu_lsu_page_fault_x      (mmu_lsu_page_fault3      ),
  .mmu_lsu_sec_x             (mmu_lsu_sec3             ),
  .mmu_lsu_sh_x              (mmu_lsu_sh3              ),
  .mmu_lsu_so_x              (mmu_lsu_so3              ),
  .mmu_lsu_stall_x           (mmu_lsu_stall3           ),
  .mmu_pmp_pa_x              (mmu_pmp_pa10             ),
  .mmu_sysmap_pa_x           (mmu_sysmap_pa10          ),
  .pad_yy_icg_scan_en        (pad_yy_icg_scan_en       ),
  .pmp_mmu_flg_x             (pmp_mmu_flg10            ),
  .refill_id_flop            (refill_id_flop           ),
  .sysmap_mmu_flg_x          (sysmap_mmu_flg10         ),
  .utlb_req_vpn_x            (utlb_req_vpn3            ),
  .refill_vpn                (refill_vpn               ),  // tmq fixed@hcl   20251021
  .refill_pgs                (refill_pgs               )   // tmq fixed@hcl   20251021
);

assign lsu_mmu_va_vld3 = lsu_mmu_va3_vld;
assign mmu_lsu_pa3_vld = mmu_lsu_pa_vld3;
assign dutlb_read_type3 = !lsu_mmu_st_inst3;
assign dutlb_ori_read3 = lsag1_ex1_is_load? 1'b1: 1'b0;
assign lsu_mmu_stamo_read_vld3 = lsag1_ex1_is_load? 1'b0: lsu_mmu_stamo_vld3;
assign lsu_mmu_stamo_read_pa3  = lsag1_ex1_is_load? {PPN_WIDTH{1'b0}} : lsu_mmu_stamo_pa3;
// assign lsu_mmu_stamo_vld1 = lsu_mmu_stamo_vld; // since how lsu_mmu_stamo_vld1 is not input
// assign lsu_mmu_stamo_pa1[PPN_WIDTH-1:0] = lsu_mmu_stamo_pa[PPN_WIDTH-1:0]; // since now lsu_mmu_stamo_pa1 is now input
//assign dutlb_acc_vld = lsu_mmu_va0_vld || lsu_mmu_va1_vld;

//----------------------------------------------------------
//                  uTLB Entry Write
//----------------------------------------------------------
// refill utlb entry when refill cmplt with no expt
// &Force("bus", "jtlb_utlb_ref_pgs", 2, 0); @420
assign utlb_huge_entry_upd = dutlb_refill_vld && jtlb_utlb_ref_pgs[2];
assign {entry15_upd, entry14_upd, entry13_upd, entry12_upd,
        entry11_upd, entry10_upd, entry9_upd,  entry8_upd,
        entry7_upd,  entry6_upd,  entry5_upd,  entry4_upd,
        entry3_upd,  entry2_upd,  entry1_upd,  entry0_upd}
                           = plru_dutlb_ref_num[15:0] & {16{dutlb_refill_vld
                                                     && !jtlb_utlb_ref_pgs[2]}};

// entry updt info
// 1. from jtlb if hit
// 2. from memory through dcache if hit in jtlb
assign utlb_upd_vpn[VPN_WIDTH-1:0] = {jtlb_utlb_ref_vpn[VPN_WIDTH-1:LVL_WIDTH],
                                      jtlb_utlb_ref_pgs[0] ? 
                                      jtlb_utlb_ref_vpn[LVL_WIDTH-1:0]:
                                      tmq_refill_vpn[LVL_WIDTH-1:0]};
assign utlb_upd_ppn[PPN_WIDTH-1:0] = cp0_mmu_pa_equal_va ?  utlb_upd_vpn[VPN_WIDTH-1:0]
                                   : {jtlb_utlb_ref_ppn[PPN_WIDTH-1:LVL_WIDTH],
                                      jtlb_utlb_ref_pgs[0] ? 
                                      jtlb_utlb_ref_ppn[LVL_WIDTH-1:0]:
                                      tmq_refill_vpn[LVL_WIDTH-1:0]};
assign utlb_upd_flg[FLG_WIDTH-1:0] = jtlb_utlb_ref_flg[FLG_WIDTH-1:0];

assign dutlb_top_scd_updt = 1'b0;

// for dbg
assign dutlb_top_ref_cur_st[2:0] = ref_cur_st[2:0];
assign dutlb_top_ref_type        = 1'b0;
assign dutlb_ptw_wfc             = dutlb_wfc;

// &ModuleEnd; @450
endmodule



