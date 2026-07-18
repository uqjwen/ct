//-----------------------------------------------------------------------------
// File          : xx_mmu_arb.v
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


// $Id: xx_mmu_arb.vp,v 1.31.12.2 2023/07/07 09:22:52 sitong.zhu Exp $
// *****************************************************************************

// &ModuleBeg; @28
module xx_mmu_arb(
  arb_dutlb_grant,
  arb_iutlb_grant,
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
  arb_jtlb_ptr, // wjh@pfu
  arb_ptw_grant,
  arb_ptw_mask,
  arb_tlboper_grant,
  arb_top_cur_st,
  arb_top_tlboper_on,
  cp0_mmu_icg_en,
  cp0_mmu_no_op_req,
  cpurst_b,
  dutlb_arb_cmplt,
  dutlb_arb_load,
  dutlb_arb_req,
  dutlb_arb_vpn,
  forever_cpuclk,
  iutlb_arb_cmplt,
  iutlb_arb_req,
  iutlb_arb_vpn,
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
  lsu_mmu_va2_priv_mode,
  lsu_mmu_va2_vld,
  pfu_arb_ptr, // wjh@pfu
  jtlb_arb_ptr, // wjh@pfu
  mmu_yy_xx_no_op,
  pad_yy_icg_scan_en,
  ptw_arb_bank_sel,
  ptw_arb_data_din,
  ptw_arb_fifo_din,
  ptw_arb_pgs,
  ptw_arb_req,
  ptw_arb_tag_din,
  ptw_arb_vpn,
  ptw_arb_mshr_full, // wjh@pfu
  ptw_arb_dmiss,     // wjh@pfu
  ptw_arb_imiss,     // wjh@pfu
  ptw_arb_pmiss,     // wjh@pfu
  ptw_refill_on,
  regs_jtlb_cur_asid,
  regs_mmu_en,
  tlb_sm_idle,
  tlboper_arb_bank_sel,
  tlboper_arb_cmp_va,
  tlboper_arb_data_din,
  tlboper_arb_fifo_din,
  tlboper_arb_fifo_write,
  tlboper_arb_idx,
  tlboper_arb_idx_not_va,
  tlboper_arb_req,
  tlboper_arb_tag_din,
  tlboper_arb_vpn,
  tlboper_arb_write,
  tlboper_xx_cmplt,
  tlboper_xx_pgs,
  tlboper_xx_pgs_en
);

// &Ports; @29
input           cp0_mmu_icg_en;        
input           cp0_mmu_no_op_req;     
input           cpurst_b;              
input           dutlb_arb_cmplt;       
input           dutlb_arb_load;        
input           dutlb_arb_req;         
input   [`WK_VPN_WIDTH-1:0]  dutlb_arb_vpn;         
input           forever_cpuclk;        
input           iutlb_arb_cmplt;       
input           iutlb_arb_req;         
input   [`WK_VPN_WIDTH-1:0]  iutlb_arb_vpn;         
input   [15:0]  jtlb_arb_asid;         
input           jtlb_arb_cmp_va;       
input           jtlb_arb_par_clr;      
input           jtlb_arb_pfu_cmplt;    
input   [`WK_VPN_WIDTH-1:0]  jtlb_arb_pfu_vpn;      
input           jtlb_arb_sel_1g;       
input           jtlb_arb_sel_2m;       
input           jtlb_arb_sel_4k;       
input           jtlb_arb_tc_miss;      
input   [2 :0]  jtlb_arb_type;         
input   [`WK_VPN_WIDTH-1:0]  jtlb_arb_vpn;          
input   [1 :0]  lsu_mmu_va2_priv_mode; 
input           lsu_mmu_va2_vld;       
input   [2:0]   pfu_arb_ptr;       // wjh@pfu
input   [2:0]   jtlb_arb_ptr;      // wjh@pfu
input           ptw_arb_mshr_full; // wjh@pfu
input           ptw_arb_dmiss;     // wjh@pfu
input           ptw_arb_imiss;     // wjh@pfu
input           ptw_arb_pmiss;     // wjh@pfu
input           pad_yy_icg_scan_en;    
input   [3 :0]  ptw_arb_bank_sel;      
input   [`MMU_DATA_WIDTH-1:0]  ptw_arb_data_din;      
input   [3 :0]  ptw_arb_fifo_din;      
input   [2 :0]  ptw_arb_pgs;           
input           ptw_arb_req;           
input   [`MMU_TAG_WIDTH-1:0]  ptw_arb_tag_din;      
input   [`WK_VPN_WIDTH-1:0]  ptw_arb_vpn;           
input           ptw_refill_on;         
input   [15:0]  regs_jtlb_cur_asid;    
input           regs_mmu_en;           
input           tlb_sm_idle;           
input   [3 :0]  tlboper_arb_bank_sel;  
input           tlboper_arb_cmp_va;    
input   [`MMU_DATA_WIDTH-1:0]  tlboper_arb_data_din;  
input   [3 :0]  tlboper_arb_fifo_din;  
input           tlboper_arb_fifo_write; 
input   [8 :0]  tlboper_arb_idx;       
input           tlboper_arb_idx_not_va; 
input           tlboper_arb_req;       
input   [`MMU_TAG_WIDTH-1:0]  tlboper_arb_tag_din;   
input   [`WK_VPN_WIDTH-1:0]  tlboper_arb_vpn;       
input           tlboper_arb_write;     
input           tlboper_xx_cmplt;      
input   [2 :0]  tlboper_xx_pgs;        
input           tlboper_xx_pgs_en;     
output          arb_dutlb_grant;       
output          arb_iutlb_grant;       
output  [2 :0]  arb_jtlb_acc_type;     
output  [15:0]  arb_jtlb_asid;         
output  [2:0]   arb_jtlb_ptr; // wjh@pfu
output  [3 :0]  arb_jtlb_bank_sel;     
output          arb_jtlb_cmp_with_va;  
output  [`MMU_DATA_WIDTH-1:0]  arb_jtlb_data_din;     
output  [3 :0]  arb_jtlb_fifo_din;     
output          arb_jtlb_fifo_write;   
output  [8 :0]  arb_jtlb_idx;          
output          arb_jtlb_pfu_grant;    
output          arb_jtlb_req;          
output  [`MMU_TAG_WIDTH-1:0]  arb_jtlb_tag_din;      
output  [`WK_VPN_WIDTH-1:0]  arb_jtlb_vpn;          
output          arb_jtlb_write;        
output          arb_ptw_grant;         
output          arb_ptw_mask;          
output          arb_tlboper_grant;     
output  [1 :0]  arb_top_cur_st;        
output          arb_top_tlboper_on;    
output          mmu_yy_xx_no_op;       

// &Regs; @30
reg     [1 :0]  arb_cur_st;            
reg     [1 :0]  arb_nxt_st;            
reg             tlboper_on;            

// &Wires; @31
wire            arb_clk;               
wire            arb_clk_en;            
wire            arb_dutlb_grant;       
wire            arb_idx_sel_1g;        
wire            arb_idx_sel_2m;        
wire            arb_idx_sel_4k;        
wire            arb_in_op;             
wire            arb_iutlb_grant;       
wire    [2 :0]  arb_jtlb_acc_type;     
wire    [15:0]  arb_jtlb_asid;         
wire    [3 :0]  arb_jtlb_bank_sel;     
wire            arb_jtlb_cmp_with_va;  
wire    [`MMU_DATA_WIDTH-1:0]  arb_jtlb_data_din;     
wire    [3 :0]  arb_jtlb_fifo_din;     
wire            arb_jtlb_fifo_write;   
wire    [8 :0]  arb_jtlb_idx;          
wire            arb_jtlb_pfu_grant;    
wire            arb_jtlb_req;          
wire    [`MMU_TAG_WIDTH-1:0]  arb_jtlb_tag_din;      
wire    [`WK_VPN_WIDTH-1:0]  arb_jtlb_vpn;          
wire            arb_jtlb_write;        
wire            arb_load_grant;        
wire            arb_par_clr;           
wire            arb_pfu_grant;         
wire            arb_pfu_grant_pre;     
wire            arb_ptw_grant;         
wire            arb_ptw_mask;          
wire            arb_read_huge;         
wire            arb_store_grant;       
wire            arb_tlboper_grant;     
wire    [1 :0]  arb_top_cur_st;        
wire            arb_top_tlboper_on;    
wire    [8 :0]  arb_va_index;          
wire    [`WK_VPN_WIDTH-1:0]  arb_vpn;               
wire            cp0_mmu_icg_en;        
wire            cp0_mmu_no_op_req;     
wire            cpurst_b;              
wire            dutlb_arb_cmplt;       
wire            dutlb_arb_load;        
wire            dutlb_arb_req;         
wire    [`WK_VPN_WIDTH-1:0]  dutlb_arb_vpn;         
wire            forever_cpuclk;        
wire            iutlb_arb_cmplt;       
wire            iutlb_arb_req;         
wire    [`WK_VPN_WIDTH-1:0]  iutlb_arb_vpn;         
wire    [15:0]  jtlb_arb_asid;         
wire            jtlb_arb_cmp_va;       
wire            jtlb_arb_par_clr;      
wire            jtlb_arb_pfu_cmplt;    
wire    [`WK_VPN_WIDTH-1:0]  jtlb_arb_pfu_vpn;      
wire            jtlb_arb_sel_1g;       
wire            jtlb_arb_sel_2m;       
wire            jtlb_arb_sel_4k;       
wire            jtlb_arb_tc_miss;      
wire    [2 :0]  jtlb_arb_type;         
wire    [`WK_VPN_WIDTH-1:0]  jtlb_arb_vpn;          
wire    [1 :0]  lsu_mmu_va2_priv_mode; 
wire            lsu_mmu_va2_vld;       
wire    [2:0]   pfu_arb_ptr;       // wjh@pfu
wire    [2:0]   arb_jtlb_ptr;      // wjh@pfu
wire    [2:0]   jtlb_arb_ptr;      // wjh@pfu
wire            ptw_arb_mshr_full; // wjh@pfu
wire            ptw_arb_dmiss;     // wjh@pfu
wire            ptw_arb_imiss;     // wjh@pfu
wire            ptw_arb_pmiss;     // wjh@pfu
wire            mmu_yy_xx_no_op;       
wire            pad_yy_icg_scan_en;    
wire    [3 :0]  ptw_arb_bank_sel;      
wire    [`MMU_DATA_WIDTH-1:0]  ptw_arb_data_din;      
wire    [3 :0]  ptw_arb_fifo_din;      
wire    [2 :0]  ptw_arb_pgs;           
wire            ptw_arb_req;           
wire    [`MMU_TAG_WIDTH-1:0]  ptw_arb_tag_din;       
wire    [`WK_VPN_WIDTH-1:0]  ptw_arb_vpn;           
wire            ptw_refill_on;         
wire    [15:0]  regs_jtlb_cur_asid;    
wire            regs_mmu_en;           
wire            tlb_sm_idle;           
wire    [3 :0]  tlboper_arb_bank_sel;  
wire            tlboper_arb_cmp_va;    
wire    [`MMU_DATA_WIDTH-1:0]  tlboper_arb_data_din;  
wire    [3 :0]  tlboper_arb_fifo_din;  
wire            tlboper_arb_fifo_write; 
wire    [8 :0]  tlboper_arb_idx;       
wire            tlboper_arb_idx_not_va; 
wire            tlboper_arb_req;       
wire    [`MMU_TAG_WIDTH-1:0]  tlboper_arb_tag_din;   
wire    [`WK_VPN_WIDTH-1:0]  tlboper_arb_vpn;       
wire            tlboper_arb_write;     
wire            tlboper_fifo_wen;      
wire            tlboper_idx_not_va_sel; 
wire            tlboper_wen;           
wire            tlboper_xx_cmplt;      
wire    [2 :0]  tlboper_xx_pgs;        
wire            tlboper_xx_pgs_en;     
wire            utlb_mask;             
wire            utlb_refill_on;        


parameter VPN_WIDTH  = `WK_VPN_WIDTH;  // VPN
parameter PPN_WIDTH  = `WK_PPN_WIDTH;  // PPN
parameter FLG_WIDTH  = 14;     // Flags
parameter PGS_WIDTH  = 3;      // Page Size
parameter ASID_WIDTH = 16;     // Flags

// Valid + VPN + ASID + PageSize + Global
parameter TAG_WIDTH  = `MMU_TAG_WIDTH;  
parameter DATA_WIDTH = `MMU_DATA_WIDTH;

//==========================================================
//                  Gate Cell
//==========================================================
assign arb_clk_en = iutlb_arb_req 
                 || dutlb_arb_req
                 || tlboper_arb_req
                 || lsu_mmu_va2_vld
                 || utlb_mask;
// &Instance("gated_clk_cell", "x_jtlb_arb_gateclk"); @51
gated_clk_cell  x_jtlb_arb_gateclk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (arb_clk           ),
  .external_en        (1'b0              ),
  .local_en           (arb_clk_en        ),
  .module_en          (cp0_mmu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect( .clk_in     (forever_cpuclk  ), @52
//           .external_en(1'b0            ), @53
//           .module_en  (cp0_mmu_icg_en  ), @54
//           .local_en   (arb_clk_en      ), @55
//           .clk_out    (arb_clk         ) @56
//          ); @57


//==============================================================================
//                  Control Path
//==============================================================================
//==========================================================
//                  Grant Siangl
//==========================================================
// &Force("output","arb_iutlb_grant"); @66
// &Force("output","arb_dutlb_grant"); @67
// &Force("output","arb_tlboper_grant"); @68
// &Force("output","arb_ptw_grant"); @69

assign arb_pfu_grant_pre = lsu_mmu_va2_vld 
                     && !iutlb_arb_req
                     && !dutlb_arb_req
                     && !tlboper_arb_req
                     && !ptw_arb_req
                     && !ptw_arb_mshr_full // wjh@pfu
                     && !utlb_mask;
assign arb_pfu_grant = arb_pfu_grant_pre
                     && !(lsu_mmu_va2_priv_mode[1:0] == 2'b11 || !regs_mmu_en);

assign arb_iutlb_grant = iutlb_arb_req
                     && !dutlb_arb_req
                     && !tlboper_arb_req
                     && !ptw_arb_req
                     && !ptw_arb_mshr_full // wjh@pfu
                     && !utlb_mask;

assign arb_dutlb_grant = dutlb_arb_req
                     && !tlboper_arb_req
                     && !ptw_arb_req
                     && !ptw_arb_mshr_full // wjh@pfu
                     && !utlb_mask;

assign arb_tlboper_grant = tlboper_arb_req
                     && !ptw_arb_req
                     && jtlb_arb_sel_4k;

assign arb_ptw_grant = ptw_arb_req;

assign arb_jtlb_req  = arb_iutlb_grant
                    || arb_pfu_grant
                    || arb_dutlb_grant
                    || arb_tlboper_grant
                    || arb_ptw_grant
                    || arb_read_huge
                    || arb_par_clr;

// &Force("input", "ptw_refill_on"); @105
// &Force("input", "tlb_sm_idle"); @106
assign arb_in_op = lsu_mmu_va2_vld
                || iutlb_arb_req
                || dutlb_arb_req
                || ~tlb_sm_idle       //TLBOPER not in IDLE
                || ptw_refill_on;    //PTW FSM not in IDLE

//==========================================================
//                  Req Mask FSM
//==========================================================
parameter ARB_IDLE  = 2'b00,
          ARB_IUTLB = 2'b01,
          ARB_DUTLB = 2'b10,
          ARB_PFU   = 2'b11;

always @(posedge arb_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    arb_cur_st[1:0] <= ARB_IDLE;
  else
    arb_cur_st[1:0] <= arb_nxt_st[1:0];
end 

// &CombBeg; @129
always @( arb_cur_st
       or dutlb_arb_cmplt
       or arb_iutlb_grant
       or iutlb_arb_cmplt
       or jtlb_arb_pfu_cmplt
       or arb_pfu_grant
       or arb_dutlb_grant)
begin
case (arb_cur_st)
ARB_IDLE:
begin
  if(arb_pfu_grant)
    arb_nxt_st[1:0] = ARB_PFU;
  else if(arb_iutlb_grant)
    arb_nxt_st[1:0] = ARB_IUTLB;
  else if(arb_dutlb_grant)
    arb_nxt_st[1:0] = ARB_DUTLB;
  else
    arb_nxt_st[1:0] = ARB_IDLE;
end
ARB_IUTLB:
begin
  if(iutlb_arb_cmplt)
    arb_nxt_st[1:0] = ARB_IDLE;
  else
    arb_nxt_st[1:0] = ARB_IUTLB;
end
ARB_DUTLB:
begin
  if(dutlb_arb_cmplt)
    arb_nxt_st[1:0] = ARB_IDLE;
  else
    arb_nxt_st[1:0] = ARB_DUTLB;
end
ARB_PFU:
begin
  if(jtlb_arb_pfu_cmplt)
    arb_nxt_st[1:0] = ARB_IDLE;
  else
    arb_nxt_st[1:0] = ARB_PFU;
end
default:
begin
  arb_nxt_st[1:0] = ARB_IDLE;
end
endcase
// &CombEnd; @168
end

// 1. tlboper(including ctc oper) req  only masked by ptw refill req
// 2. when tlboper started, it will stall all other req
always @(posedge arb_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    tlboper_on <= 1'b0;
  else if(tlboper_on && tlboper_xx_cmplt)
    tlboper_on <= 1'b0;
  else if(arb_tlboper_grant)
    tlboper_on <= 1'b1;
end

assign utlb_mask      = (arb_cur_st[1:0] != ARB_IDLE)
                     || tlboper_on;

assign utlb_refill_on = (arb_cur_st[1:0] != ARB_IDLE);

// assign arb_ptw_mask   = tlboper_on; 
assign arb_ptw_mask   = tlboper_on
                        || (~jtlb_arb_sel_4k); // in this case, ptw_arb_req will not be 1 with arb_ptw_mask=1 , wjh@pfu

assign mmu_yy_xx_no_op = cp0_mmu_no_op_req
                      && !utlb_refill_on
                      && !arb_in_op;

assign arb_read_huge  = (jtlb_arb_sel_2m || jtlb_arb_sel_1g) && jtlb_arb_tc_miss;
assign arb_idx_sel_4k = tlboper_xx_pgs_en ? tlboper_xx_pgs[0] :
                        arb_ptw_grant ? ptw_arb_pgs[0] :
                        arb_par_clr ? jtlb_arb_sel_2m : jtlb_arb_sel_4k ;
assign arb_idx_sel_2m = tlboper_xx_pgs_en ? tlboper_xx_pgs[1] : 
                        arb_ptw_grant ? ptw_arb_pgs[1] :
                        arb_par_clr ? jtlb_arb_sel_1g : jtlb_arb_sel_2m ;
assign arb_idx_sel_1g = tlboper_xx_pgs_en ? tlboper_xx_pgs[2] : 
                        arb_ptw_grant ? ptw_arb_pgs[2] :
                        arb_par_clr ? !jtlb_arb_sel_1g && !jtlb_arb_sel_2m : jtlb_arb_sel_1g ;

// parity check fail invalid request
assign arb_par_clr = jtlb_arb_par_clr;

//==============================================================================
//                  Data Path
//==============================================================================
//==========================================================
//                  jTLB Index & VPN(tag for cmp)
//==========================================================
assign arb_vpn[VPN_WIDTH-1:0] =
                {VPN_WIDTH{arb_pfu_grant}}     & jtlb_arb_pfu_vpn[VPN_WIDTH-1:0]
              | {VPN_WIDTH{arb_iutlb_grant}}   & iutlb_arb_vpn[VPN_WIDTH-1:0]
              | {VPN_WIDTH{arb_read_huge}}     & jtlb_arb_vpn[VPN_WIDTH-1:0]
              | {VPN_WIDTH{arb_par_clr}}       & jtlb_arb_vpn[VPN_WIDTH-1:0]
              | {VPN_WIDTH{arb_dutlb_grant}}   & dutlb_arb_vpn[VPN_WIDTH-1:0]
              | {VPN_WIDTH{arb_tlboper_grant}} & tlboper_arb_vpn[VPN_WIDTH-1:0]
              | {VPN_WIDTH{arb_ptw_grant}}     & ptw_arb_vpn[VPN_WIDTH-1:0];
assign arb_jtlb_vpn[VPN_WIDTH-1:0] = arb_vpn[VPN_WIDTH-1:0];

assign arb_va_index[8:0] = {9{arb_idx_sel_4k}} & arb_vpn[8:0]
                         | {9{arb_idx_sel_2m}} & arb_vpn[17:9]
                         | {9{arb_idx_sel_1g}} & arb_vpn[26:18];

assign tlboper_idx_not_va_sel = arb_tlboper_grant && tlboper_arb_idx_not_va;
assign arb_jtlb_idx[8:0] = tlboper_idx_not_va_sel ? tlboper_arb_idx[8:0]
                                                  : arb_va_index[8:0];

assign arb_jtlb_bank_sel[3:0] = {4{arb_pfu_grant}}     & 4'b1111
                              | {4{arb_iutlb_grant}}   & 4'b1111
                              | {4{arb_read_huge}}     & 4'b1111
                              | {4{arb_par_clr}}       & 4'b1111
                              | {4{arb_dutlb_grant}}   & 4'b1111
                              | {4{arb_tlboper_grant}} & tlboper_arb_bank_sel[3:0]
                              | {4{arb_ptw_grant}}     & ptw_arb_bank_sel[3:0];

assign arb_jtlb_write = arb_tlboper_grant && tlboper_arb_write
                     || arb_ptw_grant     && 1'b1
                     || arb_par_clr;

assign arb_jtlb_fifo_write = arb_tlboper_grant && tlboper_arb_fifo_write
                          || arb_ptw_grant     && 1'b1 
                          || arb_par_clr;

assign arb_jtlb_cmp_with_va = arb_pfu_grant
                           || arb_iutlb_grant
                           || arb_dutlb_grant
                           || arb_read_huge && jtlb_arb_cmp_va
                           //|| arb_par_clr && jtlb_arb_cmp_va
                           || arb_tlboper_grant && tlboper_arb_cmp_va; 
assign arb_jtlb_pfu_grant = arb_pfu_grant_pre;

assign arb_load_grant  = arb_dutlb_grant && dutlb_arb_load;
assign arb_store_grant = arb_dutlb_grant && !dutlb_arb_load;
assign arb_jtlb_acc_type[2:0] = {3{arb_pfu_grant}}     & 3'b100
                              | {3{arb_iutlb_grant}}   & 3'b011
                              | {3{arb_read_huge}}     & jtlb_arb_type[2:0]
                              | {3{arb_load_grant}}    & 3'b010
                              | {3{arb_store_grant}}   & 3'b110
                              | {3{arb_tlboper_grant}} & 3'b001
                              | {3{arb_par_clr}}       & 3'b000
                              | {3{arb_ptw_grant}}     & 3'b000;
assign arb_jtlb_asid[ASID_WIDTH-1:0] = arb_read_huge ? jtlb_arb_asid[ASID_WIDTH-1:0] 
                                                     : regs_jtlb_cur_asid[ASID_WIDTH-1:0];
assign arb_jtlb_ptr = {3{arb_pfu_grant_pre}} & pfu_arb_ptr[2:0]
                     | {3{arb_read_huge}} & jtlb_arb_ptr[2:0];
//==========================================================
//                  jTLB Tag & Data Input
//==========================================================
assign tlboper_fifo_wen = arb_tlboper_grant && tlboper_arb_fifo_write;
assign arb_jtlb_fifo_din[3:0] = 
                            {4{tlboper_fifo_wen}} & tlboper_arb_fifo_din[3:0]
                          | {4{arb_ptw_grant}}    & ptw_arb_fifo_din[3:0];

assign tlboper_wen = arb_tlboper_grant && tlboper_arb_write;
assign arb_jtlb_tag_din[TAG_WIDTH-1:0]  = 
                {TAG_WIDTH{tlboper_wen}}   & tlboper_arb_tag_din[TAG_WIDTH-1:0]
              | {TAG_WIDTH{arb_ptw_grant}} & ptw_arb_tag_din[TAG_WIDTH-1:0];

assign arb_jtlb_data_din[DATA_WIDTH-1:0] = 
             {DATA_WIDTH{tlboper_wen}}   & tlboper_arb_data_din[DATA_WIDTH-1:0]
           | {DATA_WIDTH{arb_ptw_grant}} & ptw_arb_data_din[DATA_WIDTH-1:0];

// for dbg
assign arb_top_cur_st[1:0] = arb_cur_st[1:0];
assign arb_top_tlboper_on  = tlboper_on;


// &ModuleEnd; @290
endmodule


