//-----------------------------------------------------------------------------
// File          : xx_mmu_ptw.v
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


// $Id: xx_mmu_ptw.vp,v 1.50.12.1 2023/07/07 09:22:52 sitong.zhu Exp $
// *****************************************************************************

// &ModuleBeg; @23
module xx_mmu_ptw(
  arb_ptw_grant,
  arb_ptw_mask,
  cp0_mmu_icg_en,
  cp0_mmu_maee,
  cp0_mmu_mpp,
  cp0_mmu_mprv,
  cp0_mmu_mxr,
  cp0_mmu_sum,
  cp0_yy_priv_mode,
  cpurst_b,
  dutlb_ptw_wfc,
  forever_cpuclk,
  hpcp_mmu_cnt_en,
  iutlb_ptw_wfc,
  jtlb_ptw_asid,
  jtlb_ptw_req,
  jtlb_ptw_type,
  jtlb_ptw_vpn,
  jtlb_ptw_ptr,       // wjh@pfu
  jtlb_ptw_has_cmplt, // wjh@pfu
  pfu_ptw_va,         // wjh@pfu
  tmq_ptw_va,         // wjh@tmq
  jtlb_xx_fifo,
  lsu_mmu_bus_error,
  lsu_mmu_data,
  lsu_mmu_data_vld,
  mmu_hpcp_jtlb_miss,
  mmu_lsu_data_req,
  mmu_lsu_data_req_addr,
  mmu_lsu_data_req_size,
  mmu_pmp_fetch3,
  mmu_pmp_pa3,
  mmu_sysmap_pa3,
  pad_yy_icg_scan_en,
  pmp_mmu_flg3,
  ptw_arb_bank_sel,
  ptw_arb_data_din,
  ptw_arb_fifo_din,
  ptw_arb_pgs,
  ptw_arb_req,
  ptw_arb_tag_din,
  ptw_arb_vpn,
  ptw_arb_mshr_full, // wjh@pfu
  ptw_pfu_va_hit, // wjh@pfu
  ptw_tmq_va_hit,
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
  ptw_refill_on,
  ptw_top_cur_st,
  ptw_top_imiss,
  regs_ptw_cur_asid,
  regs_ptw_satp_ppn,
  sysmap_mmu_flg3,
  sysmap_mmu_hit3,
  tlboper_ptw_abort,
  mmu_sv48_en
);

// &Ports; @24
input           arb_ptw_grant;        
input           arb_ptw_mask;         
input           cp0_mmu_icg_en;       
input           cp0_mmu_maee;         
input   [1 :0]  cp0_mmu_mpp;          
input           cp0_mmu_mprv;         
input           cp0_mmu_mxr;          
input           cp0_mmu_sum;          
input   [1 :0]  cp0_yy_priv_mode;     
input           cpurst_b;             
input           dutlb_ptw_wfc;        
input           forever_cpuclk;       
input           hpcp_mmu_cnt_en;      
input           iutlb_ptw_wfc;        
input   [15:0]  jtlb_ptw_asid;        
input           jtlb_ptw_req;         
input   [2 :0]  jtlb_ptw_type;        
input   [`WK_VPN_WIDTH-1:0]  jtlb_ptw_vpn;         
input   [2:0]   jtlb_ptw_ptr;       // wjh@pfu
input           jtlb_ptw_has_cmplt; // wjh@pfu
input   [`WK_VPN_WIDTH-1:0]  pfu_ptw_va;         // wjh@pfu
input   [`WK_VPN_WIDTH-1:0]  tmq_ptw_va;    
input   [11:0]  jtlb_xx_fifo;         
input           lsu_mmu_bus_error;    
input   [63:0]  lsu_mmu_data;         
input           lsu_mmu_data_vld;     
input           pad_yy_icg_scan_en;   
input   [3 :0]  pmp_mmu_flg3;         
input   [15:0]  regs_ptw_cur_asid;    
input   [`WK_PPN_WIDTH-1:0]  regs_ptw_satp_ppn;    
input   [4 :0]  sysmap_mmu_flg3;      
input   [`WK_SYSMAP_NUM-1 :0]  sysmap_mmu_hit3;      
input           tlboper_ptw_abort;   
input           mmu_sv48_en; 
output          mmu_hpcp_jtlb_miss;   
output          mmu_lsu_data_req;     
output  [`WK_PA_WIDTH-1:0]  mmu_lsu_data_req_addr; 
output          mmu_lsu_data_req_size; 
output          mmu_pmp_fetch3;       
output  [`WK_PPN_WIDTH-1:0]  mmu_pmp_pa3;          
output  [`WK_PPN_WIDTH-1:0]  mmu_sysmap_pa3;       
output  [3 :0]  ptw_arb_bank_sel;     
output  [`MMU_DATA_WIDTH-1:0]  ptw_arb_data_din;     
output  [3 :0]  ptw_arb_fifo_din;     
output  [2 :0]  ptw_arb_pgs;          
output          ptw_arb_req;          
output  [`MMU_TAG_WIDTH-1:0]  ptw_arb_tag_din;      
output  [`WK_VPN_WIDTH-1:0]  ptw_arb_vpn;          
output          ptw_arb_mshr_full;// wjh@pfu
output          ptw_pfu_va_hit;   // wjh@pfu
output          ptw_tmq_va_hit;
output          ptw_jtlb_dmiss;       
output          ptw_jtlb_imiss;       
output          ptw_jtlb_pmiss;       
output          ptw_jtlb_ref_acc_err; 
output          ptw_jtlb_ref_cmplt;   
output          ptw_jtlb_ref_data_vld; 
output  [13:0]  ptw_jtlb_ref_flg;     
output          ptw_jtlb_ref_pgflt;   
output  [2 :0]  ptw_jtlb_ref_pgs;     
output  [`WK_PPN_WIDTH-1:0]  ptw_jtlb_ref_ppn;     
output  [2:0]   ptw_jtlb_ref_ptr; // wjh@pfu
output          ptw_refill_on;        
output  [3 :0]  ptw_top_cur_st;       
output          ptw_top_imiss;        

// &Regs; @25
reg             jtlb_miss;            
reg     [63:0]  lsu_data_flop;        
reg     [15:0]  ptw_asid;             
reg     [4 :0]  ptw_cur_st;           
reg     [11:0]  ptw_fifo;             
reg     [`WK_SYSMAP_NUM-1 :0]  ptw_hit_num;          
reg     [4 :0]  ptw_nxt_abt_st;       
reg     [4 :0]  ptw_nxt_st;           
reg     [`WK_PA_WIDTH-1:0]  ptw_req_addr;         
reg     [2 :0]  ptw_type;             
reg     [`WK_VPN_WIDTH-1:0]  ptw_vpn;              
reg     [2 :0]  ref_pgs;              
reg     [2:0]   ptw_ptr;
// &Wires; @26
wire                    mmu_sv48_en; // sv48
wire                    ptw_hit_512g;
reg                    ptw_hit_512g_reg;
wire                    ptw_data_fth;
wire                    ptw_chk_fth;
wire                    ptw_crs1_512g;
wire                    ptw_crs2_512g;
wire                    ptw_addr_fth;
wire [`WK_PA_WIDTH-1:0] ptw_fth_addr;
wire            arb_ptw_grant;        
wire            arb_ptw_mask;         
wire            cp0_mach_mode;        
wire            cp0_mmu_icg_en;       
wire            cp0_mmu_maee;         
wire    [1 :0]  cp0_mmu_mpp;          
wire            cp0_mmu_mprv;         
wire            cp0_mmu_mxr;          
wire            cp0_mmu_sum;          
wire    [1 :0]  cp0_priv_mode;        
wire            cp0_supv_mode;        
wire            cp0_user_mode;        
wire    [1 :0]  cp0_yy_priv_mode;     
wire            cpurst_b;             
wire            dutlb_ptw_wfc;        
wire            forever_cpuclk;       
wire            hpcp_mmu_cnt_en;      
wire            iutlb_ptw_wfc;        
wire            jtlb_miss_cnt;        
wire    [15:0]  jtlb_ptw_asid;        
wire            jtlb_ptw_req;         
wire    [2 :0]  jtlb_ptw_type;        
wire    [`WK_VPN_WIDTH-1:0]  jtlb_ptw_vpn;         
wire    [11:0]  jtlb_xx_fifo;         
wire            lsu_mmu_bus_error;    
wire    [63:0]  lsu_mmu_data;         
wire            lsu_mmu_data_vld;     
wire            mmu_hpcp_jtlb_miss;   
wire            mmu_lsu_data_req;     
wire    [`WK_PA_WIDTH-1:0]  mmu_lsu_data_req_addr; 
wire            mmu_lsu_data_req_size; 
wire            mmu_pmp_fetch3;       
wire    [`WK_PPN_WIDTH-1:0]  mmu_pmp_pa3;          
wire    [`WK_PPN_WIDTH-1:0]  mmu_sysmap_pa3;       
wire            pad_yy_icg_scan_en;   
wire    [3 :0]  pmp_mmu_flg3;         
wire            ptw_addr_fst;         
wire            ptw_addr_scd;         
wire            ptw_addr_thd;         
wire    [3 :0]  ptw_arb_bank_sel;     
wire    [`MMU_DATA_WIDTH-1:0]  ptw_arb_data_din;     
wire    [3 :0]  ptw_arb_fifo_din;     
wire    [2 :0]  ptw_arb_pgs;          
wire            ptw_arb_req;          
wire    [`MMU_TAG_WIDTH-1:0]  ptw_arb_tag_din;      
wire    [`WK_VPN_WIDTH-1:0]  ptw_arb_vpn;          
wire            ptw_chk_cross;        
wire            ptw_chk_fst;          
wire            ptw_chk_scd;          
wire            ptw_chk_thd;          
wire            ptw_clk;              
wire            ptw_clk_en;           
wire            ptw_crs1_1g;          
wire            ptw_crs1_2m;          
wire            ptw_crs2_1g;          
wire            ptw_crs2_2m;          
wire            ptw_crs2_chk;         
wire            ptw_data_abt;         
wire            ptw_data_fst;         
wire            ptw_data_req;         
wire            ptw_data_scd;         
wire            ptw_data_thd;         
wire            ptw_fetch_type;       
wire    [8 :0]  ptw_flg;              
wire    [`WK_PA_WIDTH-1:0]  ptw_fst_addr;         
wire            ptw_hit_1g;           
wire            ptw_hit_2m;           
wire            ptw_jtlb_dmiss;       
wire            ptw_jtlb_imiss;       
wire            ptw_jtlb_pmiss;       
wire            ptw_jtlb_ref_acc_err; 
wire            ptw_jtlb_ref_cmplt;   
wire            ptw_jtlb_ref_data_vld; 
wire    [13:0]  ptw_jtlb_ref_flg;     
wire    [2:0]   ptw_jtlb_ref_ptr; // wjh@pfu
wire            ptw_jtlb_ref_pgflt;   
wire    [2 :0]  ptw_jtlb_ref_pgs;     
wire    [`WK_PPN_WIDTH-1:0]  ptw_jtlb_ref_ppn;     
wire            ptw_leaf_vld;         
wire            ptw_load_type;        
wire            ptw_page_flt;         
wire            ptw_pmp_deny;         
wire            ptw_pref_type;        
wire            ptw_ref_acc_err;      
wire            ptw_ref_cmplt;        
wire            ptw_ref_data_vld;     
wire    [3 :0]  ptw_ref_fifo;         
wire    [13:0]  ptw_ref_flg;          
wire            ptw_ref_g;            
wire            ptw_ref_pgflt;        
wire    [2 :0]  ptw_ref_pgs;          
wire    [4 :0]  ptw_ref_pma;          
wire    [`WK_PPN_WIDTH-1:0]  ptw_ref_ppn;          
wire    [`WK_VPN_WIDTH-1:0]  ptw_ref_vpn;          
wire            ptw_refill_on;        
wire    [`WK_PA_WIDTH-1:0]  ptw_req_addr_pre;     
wire    [`WK_PA_WIDTH-1:0]  ptw_scd_addr;         
wire            ptw_store_type;       
wire    [`WK_PA_WIDTH-1:0]  ptw_thd_addr;         
wire    [3 :0]  ptw_top_cur_st;       
wire            ptw_top_imiss;        
wire    [`WK_PPN_WIDTH-1:0]  regs_ptw_satp_ppn;    
wire    [4 :0]  sysmap_mmu_flg3;      
wire    [`WK_SYSMAP_NUM-1 :0]  sysmap_mmu_hit3;      
wire            tlboper_ptw_abort;    
wire            ptw_mshr_req;      // wjh@pfu
wire  [`WK_VPN_WIDTH-1:0]    ptw_mshr_vpn;      // wjh@pfu
wire  [15:0]    ptw_mshr_asid;     // wjh@pfu
wire  [11:0]    ptw_mshr_fifo;     // wjh@pfu
wire  [2:0]     ptw_mshr_type;     // wjh@pfu
wire  [2:0]     ptw_mshr_ptr;      // wjh@pfu
wire            ptw_arb_mshr_full; // wjh@pfu
wire            ptw_pfu_va_hit;    // wjh@pfu
wire            ptw_tmq_va_hit;
wire            ptw_mshr_pfu_va_hit; // wjh@pfu
wire            ptw_mshr_tmq_va_hit;

parameter VADDR_WIDTH = `WK_VA_WIDTH;              // VADDR
parameter PADDR_WIDTH = `WK_PA_WIDTH;              // PADDR
parameter VPN_WIDTH   = VADDR_WIDTH-12;  // VPN
parameter PPN_WIDTH   = PADDR_WIDTH-12;  // PPN
parameter FLG_WIDTH   = 14;              // PPN
parameter ASID_WIDTH  = 16;              // PPN
parameter PGS_WIDTH   = 3;               // Page Size
parameter PTE_LEVEL   = 4;               // Page Table Label
parameter LVL_WIDTH = 9;
// VPN width per level
parameter VPN_PERLEL = VPN_WIDTH/PTE_LEVEL;

// Valid + VPN + ASID + PageSize + Global
parameter TAG_WIDTH  = `MMU_TAG_WIDTH;  
parameter DATA_WIDTH = `MMU_DATA_WIDTH;

// current privlidged mode
assign cp0_priv_mode[1:0] = cp0_mmu_mprv ? cp0_mmu_mpp[1:0]
                                         : cp0_yy_priv_mode[1:0];

assign cp0_user_mode = ptw_fetch_type ? cp0_yy_priv_mode[1:0] == 2'b00 
                                      : cp0_priv_mode[1:0] == 2'b00;
assign cp0_supv_mode = ptw_fetch_type ? cp0_yy_priv_mode[1:0] == 2'b01 
                                      : cp0_priv_mode[1:0] == 2'b01;
assign cp0_mach_mode = ptw_fetch_type ? cp0_yy_priv_mode[1:0] == 2'b11
                                      : cp0_priv_mode[1:0] == 2'b11;

//==========================================================
//                  Gate Cell
//==========================================================
assign ptw_clk_en = ptw_mshr_req || ptw_refill_on || jtlb_miss; 
// &Instance("gated_clk_cell", "x_ptw_gateclk"); @59
gated_clk_cell  x_ptw_gateclk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (ptw_clk           ),
  .external_en        (1'b0              ),
  .local_en           (ptw_clk_en        ),
  .module_en          (cp0_mmu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect( .clk_in     (forever_cpuclk  ), @60
//           .external_en(1'b0            ), @61
//           .module_en  (cp0_mmu_icg_en  ), @62
//           .local_en   (ptw_clk_en      ), @63
//           .clk_out    (ptw_clk         ) @64
//          ); @65


//==============================================================================
//                  Control Path
//==============================================================================
//==========================================================
//                  PTW FSM
//==========================================================
parameter PTW_IDLE     = 5'b00000,
          PTW_FST_PMP  = 5'b00001,
          PTW_FST_DATA = 5'b00010,
          PTW_FST_CHK  = 5'b00011,
          PTW_SCD_PMP  = 5'b00100,
          PTW_SCD_DATA = 5'b00101,
          PTW_SCD_CHK  = 5'b00110,
          PTW_THD_PMP  = 5'b00111,
          PTW_THD_DATA = 5'b01000,
          PTW_THD_CHK  = 5'b01001,
          PTW_FTH_PMP  = 5'b10100, //sv48
          PTW_FTH_DATA = 5'b10101, //sv48
          PTW_FTH_CHK  = 5'b10110, //sv48
          PTW_ACC_FLT  = 5'b01010,
          PTW_PGE_FLT  = 5'b01011,
          PTW_DATA_VLD = 5'b01100,
          PTW_ABT_DATA = 5'b01101,
          PTW_ABT      = 5'b01110,
          PTW_MACH_PMP = 5'b01111,
          PTW_1G_CRS1  = 5'b10000,
          PTW_1G_CRS2  = 5'b10001,
          PTW_2M_CRS1  = 5'b10010,
          PTW_2M_CRS2  = 5'b10011,
          PTW_512G_CRS1 = 5'b10111,//sv48
          PTW_512G_CRS2 = 5'b11000;//sv48

always @(posedge ptw_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    ptw_cur_st[4:0] <= PTW_IDLE;
  else if(tlboper_ptw_abort)
    ptw_cur_st[4:0] <= ptw_nxt_abt_st[4:0];
  else
    ptw_cur_st[4:0] <= ptw_nxt_st[4:0];
end

// &CombBeg; @105
always @(*)
begin
case (ptw_cur_st)
  PTW_IDLE,
  PTW_FST_PMP,
  PTW_SCD_PMP,
  PTW_ACC_FLT,
  PTW_PGE_FLT,
  PTW_ABT,
  PTW_ABT_DATA:
  begin
    ptw_nxt_abt_st[4:0] = (mmu_sv48_en==1 && ptw_cur_st==PTW_SCD_PMP) ? PTW_ABT: ptw_nxt_st[4:0];
  end
  PTW_FST_DATA,
  PTW_SCD_DATA,
  PTW_THD_DATA,
  PTW_FTH_DATA:
  begin
    if(lsu_mmu_bus_error || lsu_mmu_data_vld)
      ptw_nxt_abt_st[4:0] = PTW_ABT;
    else
      ptw_nxt_abt_st[4:0] = PTW_ABT_DATA;
  end
  default:
  begin
    ptw_nxt_abt_st[4:0] = PTW_ABT;
  end
endcase
// &CombEnd; @130
end

// &CombBeg; @132
always @(*)
begin
case (ptw_cur_st)
PTW_IDLE:
begin
  if(ptw_mshr_req)
    ptw_nxt_st[4:0] = mmu_sv48_en?PTW_FST_PMP : PTW_SCD_PMP;
  else
    ptw_nxt_st[4:0] = PTW_IDLE;
end
PTW_FST_PMP:
begin
  if(ptw_pmp_deny)
    ptw_nxt_st[4:0] = PTW_ACC_FLT;
  else
    ptw_nxt_st[4:0] = PTW_FST_DATA;
end
PTW_FST_DATA:
begin
  if(lsu_mmu_bus_error)
    ptw_nxt_st[4:0] = PTW_ACC_FLT;
  else if(lsu_mmu_data_vld)
    ptw_nxt_st[4:0] = PTW_FST_CHK;
  else
    ptw_nxt_st[4:0] = PTW_FST_DATA;
end
PTW_FST_CHK:
begin
  if(ptw_page_flt)
    ptw_nxt_st[4:0] = PTW_PGE_FLT;
  else
    if(ptw_hit_512g)
      if(cp0_mmu_maee)
        ptw_nxt_st[4:0] = PTW_DATA_VLD;
      else
        ptw_nxt_st[4:0] = PTW_512G_CRS1;
    else
      ptw_nxt_st[4:0] = PTW_SCD_PMP;
end
PTW_SCD_PMP:
begin
  if(ptw_pmp_deny)
    ptw_nxt_st[4:0] = PTW_ACC_FLT;
  else
    ptw_nxt_st[4:0] = PTW_SCD_DATA;
end
PTW_SCD_DATA:
begin
  if(lsu_mmu_bus_error)
    ptw_nxt_st[4:0] = PTW_ACC_FLT;
  else if(lsu_mmu_data_vld)
    ptw_nxt_st[4:0] = PTW_SCD_CHK;
  else
    ptw_nxt_st[4:0] = PTW_SCD_DATA;
end
PTW_SCD_CHK:
begin
  if(ptw_page_flt)
    ptw_nxt_st[4:0] = PTW_PGE_FLT;
  else
    if(ptw_hit_1g)
      if(cp0_mmu_maee)
        ptw_nxt_st[4:0] = PTW_DATA_VLD;
      else
        ptw_nxt_st[4:0] = PTW_1G_CRS1;
    else
      ptw_nxt_st[4:0] = PTW_THD_PMP;
end
PTW_THD_PMP:
begin
  if(ptw_pmp_deny)
    ptw_nxt_st[4:0] = PTW_ACC_FLT;
  else
    ptw_nxt_st[4:0] = PTW_THD_DATA;
end
PTW_THD_DATA:
begin
  if(lsu_mmu_bus_error)
    ptw_nxt_st[4:0] = PTW_ACC_FLT;
  else if(lsu_mmu_data_vld)
    ptw_nxt_st[4:0] = PTW_THD_CHK;
  else
    ptw_nxt_st[4:0] = PTW_THD_DATA;
end
PTW_THD_CHK:
begin
  if(ptw_page_flt)
    ptw_nxt_st[4:0] = PTW_PGE_FLT;
  else
    if(ptw_hit_2m)
      if(cp0_mmu_maee)
        ptw_nxt_st[4:0] = PTW_DATA_VLD;
      else
        ptw_nxt_st[4:0] = PTW_2M_CRS1;
    else
      ptw_nxt_st[4:0] = PTW_FTH_PMP;
end
PTW_FTH_PMP:
begin 
  if(ptw_pmp_deny)
    ptw_nxt_st[4:0] = PTW_ACC_FLT;
  else
    ptw_nxt_st[4:0] = PTW_FTH_DATA;
end
PTW_FTH_DATA:
begin 
    if(lsu_mmu_bus_error)
      ptw_nxt_st[4:0] = PTW_ACC_FLT;
    else if(lsu_mmu_data_vld)
      ptw_nxt_st[4:0] = PTW_FTH_CHK;
    else
      ptw_nxt_st[4:0] = PTW_FTH_DATA;
end
PTW_FTH_CHK:
begin 
  if(ptw_page_flt)
    ptw_nxt_st[4:0] = PTW_PGE_FLT;
  else
    ptw_nxt_st[4:0] = PTW_DATA_VLD;
end
PTW_ACC_FLT:
begin
  if(!jtlb_ptw_has_cmplt) // keep in cmplt state
    ptw_nxt_st[4:0] = PTW_IDLE;
  else 
    ptw_nxt_st[4:0] = PTW_ACC_FLT;
end
PTW_PGE_FLT:
begin
  if(!jtlb_ptw_has_cmplt)
    ptw_nxt_st[4:0] = PTW_IDLE;
  else
    ptw_nxt_st[4:0] = PTW_PGE_FLT;
end
PTW_MACH_PMP:
begin
  ptw_nxt_st[4:0] = PTW_IDLE;
end
PTW_DATA_VLD:
begin
  if(arb_ptw_grant)
    ptw_nxt_st[4:0] = PTW_IDLE;
  else
    ptw_nxt_st[4:0] = PTW_DATA_VLD;
end
PTW_ABT_DATA:
begin
  if(lsu_mmu_bus_error)
    ptw_nxt_st[4:0] = mmu_sv48_en?PTW_FST_DATA:PTW_SCD_DATA;
  else if(lsu_mmu_data_vld)
    ptw_nxt_st[4:0] = mmu_sv48_en?PTW_FST_DATA:PTW_SCD_DATA;
  else
    ptw_nxt_st[4:0] = PTW_ABT_DATA;
end
PTW_ABT:
begin
  ptw_nxt_st[4:0] = mmu_sv48_en?PTW_FST_DATA:PTW_SCD_DATA;
end
PTW_512G_CRS1:
begin 
  ptw_nxt_st[4:0] = PTW_512G_CRS2;
end
PTW_512G_CRS2:
begin 
  if(ptw_chk_cross)
    ptw_nxt_st[4:0] = PTW_1G_CRS1;
  else
    ptw_nxt_st[4:0] = PTW_DATA_VLD;
end
PTW_1G_CRS1:
begin
  ptw_nxt_st[4:0] = PTW_1G_CRS2;
end
PTW_1G_CRS2:
begin
  if(ptw_chk_cross)
    ptw_nxt_st[4:0] = PTW_2M_CRS1;
  else
    ptw_nxt_st[4:0] = PTW_DATA_VLD;
end
PTW_2M_CRS1:
begin
  ptw_nxt_st[4:0] = PTW_2M_CRS2;
end
PTW_2M_CRS2:
begin
  ptw_nxt_st[4:0] = PTW_DATA_VLD;
end
default:
begin
  ptw_nxt_st[4:0] = PTW_IDLE;
end
endcase
// &CombEnd; @278
end

assign ptw_data_fst = (ptw_cur_st[4:0] == PTW_FST_DATA);
assign ptw_data_scd = (ptw_cur_st[4:0] == PTW_SCD_DATA);
assign ptw_data_thd = (ptw_cur_st[4:0] == PTW_THD_DATA);
assign ptw_data_fth = (ptw_cur_st[4:0] == PTW_FTH_DATA); //sv48
assign ptw_data_abt = (ptw_cur_st[4:0] == PTW_ABT_DATA);

assign ptw_chk_fst  = (ptw_cur_st[4:0] == PTW_FST_CHK);
assign ptw_chk_scd  = (ptw_cur_st[4:0] == PTW_SCD_CHK);
assign ptw_chk_thd  = (ptw_cur_st[4:0] == PTW_THD_CHK);
assign ptw_chk_fth  = (ptw_cur_st[4:0] == PTW_FTH_CHK); //sv48

assign ptw_crs1_512g = (ptw_cur_st[4:0] == PTW_512G_CRS1);
assign ptw_crs2_512g = (ptw_cur_st[4:0] == PTW_512G_CRS2);
assign ptw_crs1_1g  = (ptw_cur_st[4:0] == PTW_1G_CRS1);
assign ptw_crs2_1g  = (ptw_cur_st[4:0] == PTW_1G_CRS2);
assign ptw_crs1_2m  = (ptw_cur_st[4:0] == PTW_2M_CRS1);
assign ptw_crs2_2m  = (ptw_cur_st[4:0] == PTW_2M_CRS2);

assign ptw_crs2_chk = ptw_crs2_1g || ptw_crs2_2m || ptw_crs2_512g;


// &Force("output", "ptw_refill_on"); @297
assign ptw_refill_on = (ptw_cur_st[4:0] != PTW_IDLE);

assign ptw_data_req = ptw_data_fst || ptw_data_scd || ptw_data_thd || ptw_data_fth || ptw_data_abt;
assign ptw_addr_fst = ptw_cur_st[4:0] == PTW_IDLE && ptw_mshr_req
                   || ptw_cur_st[4:0] == PTW_ABT_DATA && lsu_mmu_data_vld
                   || ptw_cur_st[4:0] == PTW_ABT;
assign ptw_addr_scd = lsu_mmu_data_vld 
                      && (ptw_data_fst && mmu_sv48_en
                         || ptw_data_scd && !mmu_sv48_en);
assign ptw_addr_thd = lsu_mmu_data_vld
                      && (ptw_data_scd && mmu_sv48_en
                          || ptw_data_thd && !mmu_sv48_en);
assign ptw_addr_fth = lsu_mmu_data_vld
                      && (ptw_data_thd && mmu_sv48_en);

// flop vpn and fifo bit
// &Force("input", "regs_ptw_cur_asid"); @309
// &Force("bus", "regs_ptw_cur_asid", 15, 0); @310
always @(posedge ptw_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    ptw_vpn[VPN_WIDTH-1:0] <= {VPN_WIDTH{1'b0}};
    ptw_asid[ASID_WIDTH-1:0] <= {ASID_WIDTH{1'b0}};
    ptw_fifo[11:0]         <= 12'b0;
    ptw_type[2:0]          <= 3'b0;
    ptw_ptr[2:0]           <= 3'b0;
  end
  else if(ptw_mshr_req && !ptw_refill_on)
  begin
    ptw_vpn[VPN_WIDTH-1:0] <= ptw_mshr_vpn[VPN_WIDTH-1:0];
    ptw_asid[ASID_WIDTH-1:0] <= ptw_mshr_asid[ASID_WIDTH-1:0];
    ptw_fifo[11:0]         <= ptw_mshr_fifo[11:0];
    ptw_type[2:0]          <= ptw_mshr_type[2:0];
    ptw_ptr[2:0]           <= ptw_mshr_ptr[2:0];
  end
end

xx_mmu_ptw_mshr #(
  .MSHR_NUM(4),
  .VPN_WIDTH(VPN_WIDTH),
  .ASID_WIDTH(ASID_WIDTH)
) i_xx_mmu_ptw_mshr(
  .cpurst_b            (cpurst_b),
  .forever_cpuclk      (forever_cpuclk),
  .jtlb_ptw_req        (jtlb_ptw_req),
  .jtlb_ptw_vpn        (jtlb_ptw_vpn),
  .jtlb_ptw_asid       (jtlb_ptw_asid),
  .jtlb_ptw_fifo       (jtlb_xx_fifo),
  .jtlb_ptw_type       (jtlb_ptw_type),
  .jtlb_ptw_ptr        (jtlb_ptw_ptr),
  .pfu_ptw_va          (pfu_ptw_va),
  .tmq_ptw_va          (tmq_ptw_va),
  .ptw_mshr_pfu_va_hit (ptw_mshr_pfu_va_hit),
  .ptw_mshr_tmq_va_hit (ptw_mshr_tmq_va_hit),
  .ptw_refill_on       (ptw_refill_on),
  .ptw_mshr_req        (ptw_mshr_req),
  .ptw_mshr_vpn        (ptw_mshr_vpn),
  .ptw_mshr_asid       (ptw_mshr_asid),
  .ptw_mshr_fifo       (ptw_mshr_fifo),
  .ptw_mshr_type       (ptw_mshr_type),
  .ptw_mshr_ptr        (ptw_mshr_ptr),
  .ptw_mshr_full       (ptw_arb_mshr_full)
);

assign ptw_pfu_va_hit = ptw_mshr_pfu_va_hit
                        || ptw_refill_on
                           && (ptw_vpn[VPN_WIDTH-1:VPN_WIDTH-LVL_WIDTH] == pfu_ptw_va[VPN_WIDTH-1:VPN_WIDTH-LVL_WIDTH]);
assign ptw_tmq_va_hit = ptw_mshr_tmq_va_hit
                        || ptw_refill_on
                           && (ptw_vpn[VPN_WIDTH-1:VPN_WIDTH-LVL_WIDTH] == tmq_ptw_va[VPN_WIDTH-1:VPN_WIDTH-LVL_WIDTH]);
always @(posedge ptw_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    lsu_data_flop[58:0] <= 59'b0;
  else if(lsu_mmu_data_vld)
    lsu_data_flop[58:0] <= lsu_mmu_data[58:0];
  else if(ptw_crs2_512g && ptw_chk_cross)
    lsu_data_flop[58:0] <= {lsu_data_flop[58:37], ptw_vpn[26:18], lsu_data_flop[27:0]};
  else if(ptw_crs2_1g && ptw_chk_cross)
    lsu_data_flop[58:0] <= {lsu_data_flop[58:28], ptw_vpn[17:9], lsu_data_flop[18:0]};
  else if(ptw_crs2_2m && ptw_chk_cross)
    lsu_data_flop[58:0] <= {lsu_data_flop[58:19], ptw_vpn[8:0], lsu_data_flop[9:0]};
end

always @(posedge ptw_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    lsu_data_flop[63:59] <= 5'b0;
  else if(lsu_mmu_data_vld)
    lsu_data_flop[63:59] <= lsu_mmu_data[63:59];
end

always @(posedge ptw_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    ptw_req_addr[PADDR_WIDTH-1:0] <= {PADDR_WIDTH{1'b0}};
  else if(ptw_addr_fst || lsu_mmu_data_vld)
    ptw_req_addr[PADDR_WIDTH-1:0] <= ptw_req_addr_pre[PADDR_WIDTH-1:0];
  else if(ptw_leaf_vld)
    ptw_req_addr[PADDR_WIDTH-1:0] <= {lsu_data_flop[PPN_WIDTH+9:10], 12'b0};
  else if(ptw_crs1_512g)
    ptw_req_addr[PADDR_WIDTH-1:0] <= {lsu_data_flop[PPN_WIDTH+9:37], 27'h7ffffff, 12'b0};
  else if(ptw_crs2_512g && ptw_chk_cross)
    ptw_req_addr[PADDR_WIDTH-1:0] <= {lsu_data_flop[PPN_WIDTH+9:37], ptw_vpn[26:18], 30'b0};
  else if(ptw_crs1_1g)
    ptw_req_addr[PADDR_WIDTH-1:0] <= {lsu_data_flop[PPN_WIDTH+9:28], 18'h3ffff, 12'b0};
  else if(ptw_crs2_1g && ptw_chk_cross)
    ptw_req_addr[PADDR_WIDTH-1:0] <= {lsu_data_flop[PPN_WIDTH+9:28], ptw_vpn[17:9], 21'b0};
  else if(ptw_crs1_2m)
    ptw_req_addr[PADDR_WIDTH-1:0] <= {lsu_data_flop[PPN_WIDTH+9:19], 9'h1ff, 12'b0};
  else if(ptw_crs2_2m && ptw_chk_cross)
    ptw_req_addr[PADDR_WIDTH-1:0] <= {lsu_data_flop[PPN_WIDTH+9:19], ptw_vpn[8:0], 12'b0};
end

always @(posedge ptw_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    ref_pgs[PGS_WIDTH-1:0] <= {PGS_WIDTH{1'b0}};
  else if(ptw_leaf_vld)
    ref_pgs[PGS_WIDTH-1:0] <= {ptw_hit_1g | ptw_hit_512g, ptw_hit_2m, ptw_chk_fth};
  else if(ptw_crs2_512g && ptw_chk_cross)
    ref_pgs[PGS_WIDTH-1:0] <= 3'b100;
  else if(ptw_crs2_1g && ptw_chk_cross)
    ref_pgs[PGS_WIDTH-1:0] <= 3'b010;
  else if(ptw_crs2_2m && ptw_chk_cross)
    ref_pgs[PGS_WIDTH-1:0] <= 3'b001;
end

assign ptw_fst_addr[PADDR_WIDTH-1:0] = {regs_ptw_satp_ppn[PPN_WIDTH-1:0], 
                                 ptw_refill_on ? mmu_sv48_en? ptw_vpn[35:27]:ptw_vpn[26:18] :
                                 mmu_sv48_en?ptw_mshr_vpn[35:27]:ptw_mshr_vpn[26:18], 3'b0}; // jtlb_ptw_vpn-->ptw_mshr_vpn
assign ptw_scd_addr[PADDR_WIDTH-1:0] = {lsu_mmu_data[PPN_WIDTH+9:10], 
                                 mmu_sv48_en?ptw_vpn[26:18]:ptw_vpn[17:9], 3'b0};
assign ptw_thd_addr[PADDR_WIDTH-1:0] = {lsu_mmu_data[PPN_WIDTH+9:10], 
                                 mmu_sv48_en?ptw_vpn[17:9]:ptw_vpn[8:0], 3'b0};
assign ptw_fth_addr[PADDR_WIDTH-1:0] = {lsu_mmu_data[PPN_WIDTH+9:10], ptw_vpn[8:0], 3'b0};

assign ptw_req_addr_pre[PADDR_WIDTH-1:0] = 
                {PADDR_WIDTH{ptw_addr_fst}} & ptw_fst_addr[PADDR_WIDTH-1:0]
              | {PADDR_WIDTH{ptw_addr_scd}} & ptw_scd_addr[PADDR_WIDTH-1:0]
              | {PADDR_WIDTH{ptw_addr_thd}} & ptw_thd_addr[PADDR_WIDTH-1:0]
              | {PADDR_WIDTH{ptw_addr_fth}} & ptw_fth_addr[PADDR_WIDTH-1:0];

// ptw flag
assign ptw_flg[8:0] = {lsu_data_flop[9:6], lsu_data_flop[4:0]};
// judge if hit huge page
assign ptw_hit_512g = ptw_chk_fst && ptw_flg[0] && (ptw_flg[1] || ptw_flg[3]);
assign ptw_hit_1g = ptw_chk_scd && ptw_flg[0] && (ptw_flg[1] || ptw_flg[3]);
assign ptw_hit_2m = ptw_chk_thd && ptw_flg[0] && (ptw_flg[1] || ptw_flg[3]);

// judge if access fault
// access error when lsu bus error
// access error when pmp check deny
// &Force("bus", "pmp_mmu_flg3", 3, 0) @401
assign ptw_pmp_deny = (ptw_fetch_type && !pmp_mmu_flg3[2]
                    //|| ptw_load_type  && !pmp_mmu_flg3[0]
                    //|| ptw_store_type && !pmp_mmu_flg3[1]
                    || (ptw_load_type | ptw_store_type) && !(pmp_mmu_flg3[0] | pmp_mmu_flg3[1])
                    || ptw_pref_type  && !pmp_mmu_flg3[0])
                    // L-bit for M-Mode
                       && !(cp0_mach_mode && !pmp_mmu_flg3[3]);

assign ptw_leaf_vld = (ptw_hit_512g || ptw_hit_1g || ptw_hit_2m || ptw_chk_fth);
// judge if page fault
// page fault when PTE not valid
// page fault when PTE write only
// page fault when not match R/W/X
// page fault when supv access user region and vise versa
// page fault when A/D bit violation
// page fault when fetch meets strong order
// page fault when third request no R/X
// page fault when huge page misalign

assign ptw_fetch_type = ptw_type[2:0] == 3'b011;
assign ptw_load_type  = ptw_type[2:0] == 3'b010;
assign ptw_store_type = ptw_type[2:0] == 3'b110;
assign ptw_pref_type  = ptw_type[2:0] == 3'b100;

assign ptw_page_flt = ((!ptw_flg[0]                       // not valid
                   ||  !(ptw_flg[1] || cp0_mmu_mxr && ptw_flg[3]) 
                        && ptw_flg[2]         // write only
                  //  ||  (!ptw_flg[1] && ptw_load_type     // match R
                  //      && !(cp0_mmu_mxr && ptw_flg[3])  
                  //  || !ptw_flg[2] && ptw_store_type     // match W
                   || (!ptw_flg[3] && ptw_fetch_type     // match X
                   ||  ptw_flg[4] && cp0_supv_mode && !cp0_mmu_sum // S->U
                   || !ptw_flg[4] && cp0_user_mode      // U->S
                   || !ptw_flg[5]                       // A bit volation
                  //  || !ptw_flg[6] && ptw_store_type     // D bit volation
//                   ||  ptw_flg[13] && ptw_fetch_type    // fetch so
                   ||  ptw_hit_512g && lsu_data_flop[36:10] != 27'b0
                   ||  ptw_hit_1g && lsu_data_flop[27:10] != 18'b0 // 1g align
                   ||  ptw_hit_2m && lsu_data_flop[18:10] != 9'b0  // 2m align
                     ) && ptw_leaf_vld)
                   || !ptw_flg[1] && !ptw_flg[3]        // thd req no R/X
                       && ptw_chk_fth);

// access cross when:
// sysmap check 2 and hit num not match
always @(posedge ptw_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    ptw_hit_num[`WK_SYSMAP_NUM-1:0] <= 16'b0;
  else if(ptw_crs1_1g || ptw_crs1_2m || ptw_crs1_512g)
    ptw_hit_num[`WK_SYSMAP_NUM-1:0] <= sysmap_mmu_hit3[`WK_SYSMAP_NUM-1:0];
end
assign ptw_chk_cross = ptw_crs2_chk && ptw_hit_num[`WK_SYSMAP_NUM-1:0] != sysmap_mmu_hit3[`WK_SYSMAP_NUM-1:0];

// response to jtlb refill
assign ptw_ref_cmplt    = (ptw_cur_st[4:0] == PTW_ACC_FLT) && !jtlb_ptw_has_cmplt
                       || (ptw_cur_st[4:0] == PTW_PGE_FLT) && !jtlb_ptw_has_cmplt
                       || (ptw_cur_st[4:0] == PTW_DATA_VLD) && arb_ptw_grant;

assign ptw_ref_data_vld = (ptw_cur_st[4:0] == PTW_DATA_VLD) && !tlboper_ptw_abort;
assign ptw_ref_acc_err  = (ptw_cur_st[4:0] == PTW_ACC_FLT);
assign ptw_ref_pgflt    = (ptw_cur_st[4:0] == PTW_PGE_FLT);

assign ptw_ref_pma[4:0] = cp0_mmu_maee ? lsu_data_flop[63:59]
                                       : sysmap_mmu_flg3[4:0];

assign ptw_ref_vpn[VPN_WIDTH-1:0] =  
                           {VPN_WIDTH{ref_pgs[2]}} & {ptw_vpn[VPN_WIDTH-1:18], 18'b0}
                         | {VPN_WIDTH{ref_pgs[1]}} & {ptw_vpn[VPN_WIDTH-1:9], 9'b0}
                         | {VPN_WIDTH{ref_pgs[0]}} &  ptw_vpn[VPN_WIDTH-1:0];
always @(posedge ptw_clk, negedge cpurst_b)begin 
  if(!cpurst_b)begin 
    ptw_hit_512g_reg <= 1'b0;
  end
  else if(ptw_leaf_vld)begin 
    ptw_hit_512g_reg <= ptw_hit_512g;
  end
end
assign ptw_ref_ppn[PPN_WIDTH-1:0] = (ref_pgs[2] && ptw_hit_512g_reg) ? {lsu_data_flop[PPN_WIDTH+9:37],ptw_vpn[26:18],lsu_data_flop[27:10]}: lsu_data_flop[PPN_WIDTH+9:10];
assign ptw_ref_flg[FLG_WIDTH-1:0] = {ptw_ref_pma[4:0], lsu_data_flop[9:6], 
                                                       lsu_data_flop[4:0]};
assign ptw_ref_pgs[PGS_WIDTH-1:0] = ref_pgs[PGS_WIDTH-1:0];
assign ptw_ref_g                  = lsu_data_flop[5];
assign ptw_ref_fifo[3:0] = {4{ref_pgs[0]}} & ptw_fifo[3:0]
                         | {4{ref_pgs[1]}} & ptw_fifo[7:4]
                         | {4{ref_pgs[2]}} & ptw_fifo[11:8];

// for hpcp
//assign jtlb_miss_cnt = (ptw_cur_st[3:0] == PTW_IDLE) && (ptw_nxt_st[3:0] != PTW_IDLE)
//                     && hpcp_mmu_cnt_en;
//assign jtlb_miss_cnt = ptw_ref_cmplt && hpcp_mmu_cnt_en;
assign jtlb_miss_cnt = ((ptw_load_type || ptw_store_type) && dutlb_ptw_wfc
                      || ptw_fetch_type && iutlb_ptw_wfc) 
                     &&  ptw_ref_data_vld && hpcp_mmu_cnt_en;

always @(posedge ptw_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    jtlb_miss <= 1'b0;
  else if(jtlb_miss_cnt)
    jtlb_miss <= 1'b1;
  else if(jtlb_miss)
    jtlb_miss <= 1'b0;
end

assign mmu_hpcp_jtlb_miss = jtlb_miss;


//==========================================================
//                  Interface to SysMap
//==========================================================
assign mmu_sysmap_pa3[PPN_WIDTH-1:0] = ptw_req_addr[PPN_WIDTH+11:12];

//==========================================================
//                  Interface to PMP
//==========================================================
assign mmu_pmp_pa3[PPN_WIDTH-1:0] = ptw_req_addr[PPN_WIDTH+11:12];
assign mmu_pmp_fetch3             = ptw_fetch_type;


//==========================================================
//                  Interface to LSU
//==========================================================
assign mmu_lsu_data_req = ptw_data_req;
assign mmu_lsu_data_req_addr[PADDR_WIDTH-1:0] = ptw_req_addr[PADDR_WIDTH-1:0];
assign mmu_lsu_data_req_size = 1'b1;


//==========================================================
//                  Interface to jTLB
//==========================================================
assign ptw_jtlb_ref_cmplt    = ptw_ref_cmplt; 
assign ptw_jtlb_imiss        = ptw_fetch_type;
assign ptw_jtlb_dmiss        = ptw_load_type || ptw_store_type;
assign ptw_jtlb_pmiss        = ptw_pref_type;
assign ptw_jtlb_ref_data_vld = ptw_ref_data_vld && arb_ptw_grant; 
assign ptw_jtlb_ref_acc_err  = ptw_ref_acc_err;
assign ptw_jtlb_ref_pgflt    = ptw_ref_pgflt;

assign ptw_jtlb_ref_ppn[PPN_WIDTH-1:0] = ptw_ref_ppn[PPN_WIDTH-1:0];
assign ptw_jtlb_ref_pgs[PGS_WIDTH-1:0] = ptw_ref_pgs[PGS_WIDTH-1:0];
assign ptw_jtlb_ref_flg[FLG_WIDTH-1:0] = ptw_ref_flg[FLG_WIDTH-1:0];
assign ptw_jtlb_ref_ptr[2:0]           = ptw_ptr[2:0]; // wjh@pfu

//==========================================================
//                  Interface to arb
//==========================================================
assign ptw_arb_req            = ptw_ref_data_vld && !arb_ptw_mask;
assign ptw_arb_bank_sel[3:0]  = ptw_ref_fifo[3:0];
assign ptw_arb_vpn[VPN_WIDTH-1:0] = ptw_ref_vpn[VPN_WIDTH-1:0];
assign ptw_arb_pgs[PGS_WIDTH-1:0] = ptw_ref_pgs[PGS_WIDTH-1:0];

assign ptw_arb_fifo_din[3:0]  = {ptw_ref_fifo[2:0], ptw_ref_fifo[3]};
assign ptw_arb_tag_din[TAG_WIDTH-1:0] = {1'b1, ptw_ref_vpn[VPN_WIDTH-1:0], 
                                               ptw_asid[ASID_WIDTH-1:0], 
                                   ptw_ref_pgs[PGS_WIDTH-1:0], ptw_ref_g};
assign ptw_arb_data_din[DATA_WIDTH-1:0] = {ptw_ref_ppn[PPN_WIDTH-1:0], 
                                           ptw_ref_flg[FLG_WIDTH-1:0]};

// for dbg
assign ptw_top_cur_st[3:0] = ptw_cur_st[3:0];
assign ptw_top_imiss       = ptw_fetch_type;


// &ModuleEnd; @559
endmodule


