//-----------------------------------------------------------------------------
// File          : xx_mmu_top.v
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


// $Id: xx_mmu_top.vp,v 1.26 2022/01/06 08:14:36 jizk Exp $
// *****************************************************************************
// &Depend("cpu_cfig.h"); @26

// &ModuleBeg; @28
module xx_mmu_top #(
  parameter LSIQENTRY=12,
  parameter IID_WIDTH=7)(
  biu_mmu_smp_disable,
  cp0_mmu_cskyee,
  cp0_mmu_data_ecc_inj,
  cp0_mmu_data_random,
  cp0_mmu_ecc_en,
  cp0_mmu_icg_en,
  cp0_mmu_maee,
  cp0_mmu_mpp,
  cp0_mmu_mprv,
  cp0_mmu_mxr,
  cp0_mmu_no_op_req,
  cp0_mmu_pa_equal_va,
  cp0_mmu_ptw_en,
  cp0_mmu_reg_num,
  cp0_mmu_satp_sel,
  cp0_mmu_sum,
  cp0_mmu_tag_ecc_inj,
  cp0_mmu_tag_random,
  cp0_mmu_tlb_all_inv,
  cp0_mmu_wdata,
  cp0_mmu_wreg,
  cp0_yy_priv_mode,
  cpurst_b,
  forever_cpuclk,
  hpcp_mmu_cnt_en,
  ifu_mmu_abort,
  ifu_mmu_va,
  ifu_mmu_va_vld,
  lsag0_ex1_is_load,
  lsag1_ex1_is_load,
  lsu_mmu_abort0,

  lsu_mmu_abort2,
  lsu_mmu_abort3,
  lsu_mmu_bus_error,
  lsu_mmu_data,
  lsu_mmu_data_vld,
  lsu_mmu_id0,

  lsu_mmu_id2,
  lsu_mmu_id3,
  lsu_mmu_st_inst0,

  lsu_mmu_st_inst2,
  lsu_mmu_st_inst3,
  lsu_mmu_stamo_pa2, // 0-1 is tied 0 in dutlb_read0/1, so no need to send from outside
  lsu_mmu_stamo_vld2,
  lsu_mmu_stamo_pa3,
  lsu_mmu_stamo_vld3,
  lsu_mmu_tlb_all_inv,
  lsu_mmu_tlb_asid,
  lsu_mmu_tlb_asid_all_inv,
  lsu_mmu_tlb_va,
  lsu_mmu_tlb_va_all_inv,
  lsu_mmu_tlb_va_asid_inv,
  lsu_mmu_va0,
  lsu_mmu_va0_vld,

  lsu_mmu_va2,
  lsu_mmu_va2_vld,
  lsu_mmu_va3,
  lsu_mmu_va3_vld,
  lsu_mmu_va4, // for pfu
  lsu_mmu_va4_priv_mode, // for pfu
  lsu_mmu_va4_vld, // for pfu
  lsu_mmu_pfu_req_id_q, // wjh@pfu
  lsu_mmu_vabuf0,

  lsu_mmu_vabuf2,
  lsu_mmu_vabuf3,
  lsu_mmu_old0,
  lsu_mmu_old2,
  lsu_mmu_old3,
  mmu_cp0_cmplt,
  mmu_cp0_data,
  mmu_cp0_data_inj_cmplt,
  mmu_cp0_ecc_idx,
  mmu_cp0_ecc_ramid,
  mmu_cp0_ecc_vld,
  mmu_cp0_ecc_way,
  mmu_cp0_satp_data,
  mmu_cp0_tag_inj_cmplt,
  mmu_cp0_tlb_done,
  mmu_hpcp_dutlb_miss,
  mmu_hpcp_iutlb_miss,
  mmu_hpcp_jtlb_miss,
  mmu_ifu_buf,
  mmu_ifu_ca,
  mmu_ifu_deny,
  mmu_ifu_pa,
  mmu_ifu_pavld,
  mmu_ifu_pgflt,
  mmu_ifu_sec,
  mmu_ifu_sh,
  mmu_lsu_access_fault0,

  mmu_lsu_access_fault2,
  mmu_lsu_access_fault3,
  mmu_lsu_buf0,

  mmu_lsu_buf2,
  mmu_lsu_buf3,
  mmu_lsu_ca0,

  mmu_lsu_ca2,
  mmu_lsu_ca3,
  mmu_lsu_data_req,
  mmu_lsu_data_req_addr,
  mmu_lsu_data_req_size,
  mmu_lsu_mmu_en,
  mmu_lsu_pa0,
  mmu_lsu_pa0_vld,

  mmu_lsu_pa2,
  mmu_lsu_pa2_vld,
  mmu_lsu_pa3,
  mmu_lsu_pa3_vld,
  mmu_lsu_pa4, // for pfu
  mmu_lsu_pa4_err, // for pfu
  mmu_lsu_pa4_vld, // for pfu
  mmu_lsu_pfu_req_accepted,    // wjh@pfu
  mmu_lsu_pfu_req_accepted_id, // wjh@pfu
  mmu_lsu_pfu_resp_id,         // wjh@pfu
  mmu_l2c_pfu_regs_utlb_clr,
  mmu_lsu_page_fault0,

  mmu_lsu_page_fault2,
  mmu_lsu_page_fault3,
  mmu_lsu_sec0,

  mmu_lsu_sec2,
  mmu_lsu_sec3,
  mmu_lsu_sec4, // for pfu
  mmu_lsu_sh0,

  mmu_lsu_sh2,
  mmu_lsu_sh3,
  mmu_lsu_share4, // for pfu
  mmu_lsu_so0,

  mmu_lsu_so2,
  mmu_lsu_so3,
  mmu_lsu_stall0,

  mmu_lsu_stall2,
  mmu_lsu_stall3,
  mmu_lsu_tlb_busy,
  mmu_lsu_tlb_inv_done,
  mmu_lsu_tlb_wakeup,
  mmu_lsu_async_wakeup0, // wjh@tmq
  mmu_lsu_async_wakeup2, // wjh@tmq
  mmu_lsu_async_wakeup3, // wjh@tmq
  mmu_lsu_imme_wakeup0, // wjh@tmq
  mmu_lsu_imme_wakeup2, // wjh@tmq
  mmu_lsu_imme_wakeup3, // wjh@tmq
  lsu_mmu_lsid0,    // wjh@tmq
  lsu_mmu_lsid2,    // wjh@tmq
  lsu_mmu_lsid3,    // wjh@tmq
  mmu_pmp_fetch3,
  mmu_pmp_pa0,

  mmu_pmp_pa00,
  mmu_pmp_pa10,
  mmu_pmp_pa2,
  mmu_pmp_pa3,
  mmu_pmp_pa4,
  mmu_xx_mmu_en,
  mmu_yy_xx_no_op,
  pad_yy_icg_scan_en,
  pmp_mmu_flg0,
 
  pmp_mmu_flg00,
  pmp_mmu_flg10,
  pmp_mmu_flg2,
  pmp_mmu_flg3,
  pmp_mmu_flg4,
  rtu_mmu_bad_vpn,
  rtu_mmu_expt_vld,
  rtu_ck_flush,
  rtu_ck_flush_iid,
  rtu_yy_xx_flush,
  pad_sram_RME,
  pad_sram_RM,
//==========================================================
//                  Risc-V Debug zdb Begin
//==========================================================
  mmu_dtu_debug_info
//==========================================================
//                  Risc-V Debug zdb End
//==========================================================                       
);
// parameter LSIQENTRY = 12;
// parameter IID_WIDTH = 7;
// &Ports; @29
input                     pad_sram_RME;
input   [3   :0]          pad_sram_RM;
input           biu_mmu_smp_disable;        
input           cp0_mmu_cskyee;             
input           cp0_mmu_data_ecc_inj;       
input   [`MMU_DATA_WIDTH+1:0]  cp0_mmu_data_random;        
input           cp0_mmu_ecc_en;             
input           cp0_mmu_icg_en;             
input           cp0_mmu_maee;               
input   [1 :0]  cp0_mmu_mpp;                
input           cp0_mmu_mprv;               
input           cp0_mmu_mxr;                
input           cp0_mmu_no_op_req;          
input           cp0_mmu_pa_equal_va;        
input           cp0_mmu_ptw_en;             
input   [2 :0]  cp0_mmu_reg_num;            
input           cp0_mmu_satp_sel;           
input           cp0_mmu_sum;                
input           cp0_mmu_tag_ecc_inj;        
input   [50:0]  cp0_mmu_tag_random;         
input           cp0_mmu_tlb_all_inv;        
input   [63:0]  cp0_mmu_wdata;              
input           cp0_mmu_wreg;               
input   [1 :0]  cp0_yy_priv_mode;           
input           cpurst_b;                   
input           forever_cpuclk;             
input           hpcp_mmu_cnt_en;            
input           ifu_mmu_abort;              
input   [62:0]  ifu_mmu_va;                 
input           ifu_mmu_va_vld;             
input           lsag0_ex1_is_load;
input           lsag1_ex1_is_load;
input           lsu_mmu_abort0;             
             
input           lsu_mmu_abort2; // for another LD-AGU
input           lsu_mmu_abort3; // for another LS-AGU
input           lsu_mmu_bus_error;          
input   [63:0]  lsu_mmu_data;               
input           lsu_mmu_data_vld;           
input   [IID_WIDTH-1 :0]  lsu_mmu_id0;                
                
input   [IID_WIDTH-1 :0]  lsu_mmu_id2;                
input   [IID_WIDTH-1 :0]  lsu_mmu_id3;                
input           lsu_mmu_st_inst0;           
           
input           lsu_mmu_st_inst2;           
input           lsu_mmu_st_inst3;           
input   [`WK_PPN_WIDTH-1:0]  lsu_mmu_stamo_pa2;           
input                        lsu_mmu_stamo_vld2;          
input   [`WK_PPN_WIDTH-1:0]  lsu_mmu_stamo_pa3;           
input                        lsu_mmu_stamo_vld3;          
input           lsu_mmu_tlb_all_inv;        
input   [15:0]  lsu_mmu_tlb_asid;           
input           lsu_mmu_tlb_asid_all_inv;   
input   [`WK_VPN_WIDTH-1:0]  lsu_mmu_tlb_va;             
input           lsu_mmu_tlb_va_all_inv;     
input           lsu_mmu_tlb_va_asid_inv;    
input   [63:0]  lsu_mmu_va0;                
input           lsu_mmu_va0_vld;            
            
input   [63:0]  lsu_mmu_va2;                
input           lsu_mmu_va2_vld;            
input   [63:0]  lsu_mmu_va3;                
input           lsu_mmu_va3_vld;            
input   [`WK_PPN_WIDTH-1:0]  lsu_mmu_va4;                // for pfu, origin: lsu_mmu_va2
input   [1 :0]  lsu_mmu_va4_priv_mode;      // for pfu, origin: lsu_mmu_va2_priv_mode
input           lsu_mmu_va4_vld;            // for pfu, origin: lsu_mmu_va2_vld
input   [3:0]   lsu_mmu_pfu_req_id_q; // wjh@pfu, 
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
input   [3 :0]  pmp_mmu_flg2;               
input   [3 :0]  pmp_mmu_flg3;               
input   [3 :0]  pmp_mmu_flg4;               
input   [`WK_VPN_WIDTH-1:0]  rtu_mmu_bad_vpn;            
input           rtu_mmu_expt_vld;           
input           rtu_yy_xx_flush;            
input           rtu_ck_flush;
input   [IID_WIDTH-1:0] rtu_ck_flush_iid;
output          mmu_cp0_cmplt;              
output  [63:0]  mmu_cp0_data;               
output          mmu_cp0_data_inj_cmplt;     
output  [8 :0]  mmu_cp0_ecc_idx;            
output  [2 :0]  mmu_cp0_ecc_ramid;          
output          mmu_cp0_ecc_vld;            
output  [1 :0]  mmu_cp0_ecc_way;            
output  [63:0]  mmu_cp0_satp_data;          
output          mmu_cp0_tag_inj_cmplt;      
output          mmu_cp0_tlb_done;                  
output          mmu_hpcp_dutlb_miss;        
output          mmu_hpcp_iutlb_miss;        
output          mmu_hpcp_jtlb_miss;         
output          mmu_ifu_buf;                
output          mmu_ifu_ca;                 
output          mmu_ifu_deny;               
output  [`WK_PPN_WIDTH-1:0]  mmu_ifu_pa;                 
output          mmu_ifu_pavld;              
output          mmu_ifu_pgflt;              
output          mmu_ifu_sec;                
output          mmu_ifu_sh;                 
output          mmu_lsu_access_fault0;      
     
output          mmu_lsu_access_fault2;      
output          mmu_lsu_access_fault3;      
output          mmu_lsu_buf0;               
               
output          mmu_lsu_buf2;               
output          mmu_lsu_buf3;               
output          mmu_lsu_ca0;                
                
output          mmu_lsu_ca2;                
output          mmu_lsu_ca3;                
output          mmu_lsu_data_req;           
output  [`WK_PA_WIDTH-1:0]  mmu_lsu_data_req_addr;      
output          mmu_lsu_data_req_size;      
output          mmu_lsu_mmu_en;             
output  [`WK_PPN_WIDTH-1:0]  mmu_lsu_pa0;                
output                       mmu_lsu_pa0_vld;            
            
output  [`WK_PPN_WIDTH-1:0]  mmu_lsu_pa2;                
output                       mmu_lsu_pa2_vld;            
output  [`WK_PPN_WIDTH-1:0]  mmu_lsu_pa3;                
output                       mmu_lsu_pa3_vld;            
output  [`WK_PPN_WIDTH-1:0]  mmu_lsu_pa4;                // for pfu, original: mmu_lsu_pa2
output          mmu_lsu_pa4_err;            // for pfu, original: mmu_lsu_pa2_err
output          mmu_lsu_pa4_vld;            // for pfu, original: mmu_lsu_pa2_vld
output          mmu_lsu_pfu_req_accepted;    // wjh@pfu
output [3:0]    mmu_lsu_pfu_req_accepted_id; // wjh@pfu
output [3:0]    mmu_lsu_pfu_resp_id;         // wjh@pfu
output          mmu_l2c_pfu_regs_utlb_clr;   // i.e. ls_l2_ctxt_change_v  lishuo@pfu
output          mmu_lsu_page_fault0;        
        
output          mmu_lsu_page_fault2;        
output          mmu_lsu_page_fault3;        
output          mmu_lsu_sec0;               
               
output          mmu_lsu_sec2;               
output          mmu_lsu_sec3;               
output          mmu_lsu_sec4;               // for pfu, original mmu_lsu_sec2
output          mmu_lsu_sh0;                
                
output          mmu_lsu_sh2;                
output          mmu_lsu_sh3;                
output          mmu_lsu_share4;             // for pfu, original: mmu_lsu_share2
output          mmu_lsu_so0;                
                
output          mmu_lsu_so2;                
output          mmu_lsu_so3;                
output          mmu_lsu_stall0;             
             
output          mmu_lsu_stall2;             
output          mmu_lsu_stall3;             
output          mmu_lsu_tlb_busy;           
output          mmu_lsu_tlb_inv_done;       
output  [LSIQENTRY-1:0]  mmu_lsu_tlb_wakeup;         
output  [LSIQENTRY-1:0]  mmu_lsu_async_wakeup0; // wjh@tmq
output  [LSIQENTRY-1:0]  mmu_lsu_async_wakeup2; // wjh@tmq
output  [LSIQENTRY-1:0]  mmu_lsu_async_wakeup3; // wjh@tmq
output                   mmu_lsu_imme_wakeup0; // wjh@tmq 
output                   mmu_lsu_imme_wakeup2; // wjh@tmq 
output                   mmu_lsu_imme_wakeup3; // wjh@tmq 
input   [LSIQENTRY-1:0]  lsu_mmu_lsid0;    // wjh@tmq
input   [LSIQENTRY-1:0]  lsu_mmu_lsid2;    // wjh@tmq
input   [LSIQENTRY-1:0]  lsu_mmu_lsid3;    // wjh@tmq
output          mmu_pmp_fetch3;             
output  [`WK_PPN_WIDTH-1:0]  mmu_pmp_pa0;                
                
output  [`WK_PPN_WIDTH-1:0]  mmu_pmp_pa00;                
output  [`WK_PPN_WIDTH-1:0]  mmu_pmp_pa10;                
output  [`WK_PPN_WIDTH-1:0]  mmu_pmp_pa2;                
output  [`WK_PPN_WIDTH-1:0]  mmu_pmp_pa3;                
output  [`WK_PPN_WIDTH-1:0]  mmu_pmp_pa4;                
output          mmu_xx_mmu_en;              
output          mmu_yy_xx_no_op;  

wire                    pad_sram_RME;
wire  [3   :0]          pad_sram_RM;

              

// &Regs; @30

// &Wires; @31
wire            arb_dutlb_grant;            
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
wire    [2:0]   arb_jtlb_ptr;// wjh@pfu
wire            arb_ptw_grant;              
wire            arb_ptw_mask;               
wire            arb_tlboper_grant;          
wire    [1 :0]  arb_top_cur_st;             
wire            arb_top_tlboper_on;         
wire            biu_mmu_smp_disable;        
wire            cp0_mmu_cskyee;             
wire            cp0_mmu_data_ecc_inj;       
wire    [`MMU_DATA_WIDTH+1:0]  cp0_mmu_data_random;        
wire            cp0_mmu_ecc_en;             
wire            cp0_mmu_icg_en;             
wire            cp0_mmu_maee;               
wire    [1 :0]  cp0_mmu_mpp;                
wire            cp0_mmu_mprv;               
wire            cp0_mmu_mxr;                
wire            cp0_mmu_no_op_req;          
wire            cp0_mmu_pa_equal_va;        
wire            cp0_mmu_ptw_en;             
wire    [2 :0]  cp0_mmu_reg_num;            
wire            cp0_mmu_satp_sel;           
wire            cp0_mmu_sum;                
wire            cp0_mmu_tag_ecc_inj;        
wire    [50:0]  cp0_mmu_tag_random;         
wire            cp0_mmu_tlb_all_inv;        
wire    [63:0]  cp0_mmu_wdata;              
wire            cp0_mmu_wreg;               
wire    [1 :0]  cp0_yy_priv_mode;           
wire            cpurst_b;                   
wire            dutlb_arb_cmplt;            
wire            dutlb_arb_load;             
wire            dutlb_arb_req;              
wire    [`WK_VPN_WIDTH-1:0]  dutlb_arb_vpn;              
wire            dutlb_ptw_wfc;              
wire    [2 :0]  dutlb_top_ref_cur_st;       
wire            dutlb_top_ref_type;         
wire            dutlb_top_scd_updt;         
wire            dutlb_xx_mmu_off;           
wire            forever_cpuclk;             
wire            hpcp_mmu_cnt_en;            
wire            ifu_mmu_abort;              
wire    [62:0]  ifu_mmu_va;                 
wire            ifu_mmu_va_vld;             
wire            iutlb_arb_cmplt;            
wire            iutlb_arb_req;              
wire    [`WK_VPN_WIDTH-1:0]  iutlb_arb_vpn;              
wire            iutlb_ptw_wfc;              
wire    [1 :0]  iutlb_top_ref_cur_st;       
wire            iutlb_top_scd_updt;         
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
wire            jtlb_dutlb_acc_err;         
wire            jtlb_dutlb_pgflt;           
wire            jtlb_dutlb_ref_cmplt;       
wire            jtlb_dutlb_ref_pavld;       
wire            jtlb_iutlb_acc_err;         
wire            jtlb_iutlb_pgflt;           
wire            jtlb_iutlb_ref_cmplt;       
wire            jtlb_iutlb_ref_pavld;       
wire    [15:0]  jtlb_ptw_asid;              
wire            jtlb_ptw_req;               
wire    [2 :0]  jtlb_ptw_type;              
wire    [`WK_VPN_WIDTH-1:0]  jtlb_ptw_vpn;               
wire    [2:0]   jtlb_ptw_ptr;       // wjh@pfu
wire            jtlb_ptw_has_cmplt; // wjh@pfu
wire    [2:0]   jtlb_arb_ptr;       // wjh@pfu
wire            jtlb_pfu_cmplt;     // wjh@pfu
wire            jtlb_pfu_acc_fault; // wjh@pfu
wire    [`WK_PPN_WIDTH-1:0]  jtlb_pfu_pa;        // wjh@pfu
wire            jtlb_pfu_sec;       // wjh@pfu
wire            jtlb_pfu_share;     // wjh@pfu
wire    [2:0]   jtlb_pfu_ptr;       // wjh@pfu
wire            pfu_arb_vld;        // wjh@pfu
wire    [2:0]   pfu_arb_ptr;        // wjh@pfu
wire    [1:0]   pfu_xxx_priv_mode;  // wjh@pfu
wire    [`WK_PPN_WIDTH-1:0]  pfu_jtlb_va;        // wjh@pfu
wire            ptw_pfu_va_hit;     // wjh@pfu
wire            ptw_tmq_va_hit;
wire            jtlb_regs_hit;              
wire            jtlb_regs_hit_mult;         
wire    [10:0]  jtlb_regs_tlbp_hit_index;   
wire            jtlb_tlboper_asid_hit;      
wire            jtlb_tlboper_cmplt;         
wire    [3 :0]  jtlb_tlboper_fifo;          
wire            jtlb_tlboper_read_idle;     
wire    [3 :0]  jtlb_tlboper_sel;           
wire            jtlb_tlboper_va_hit;        
wire    [15:0]  jtlb_tlbr_asid;             
wire    [13:0]  jtlb_tlbr_flg;              
wire            jtlb_tlbr_g;                
wire    [2 :0]  jtlb_tlbr_pgs;              
wire    [`WK_PPN_WIDTH-1:0]  jtlb_tlbr_ppn;              
wire    [`WK_VPN_WIDTH-1:0]  jtlb_tlbr_vpn;              
wire    [1 :0]  jtlb_top_cur_st;            
wire            jtlb_top_utlb_pavld;        
wire    [13:0]  jtlb_utlb_ref_flg;          
wire    [2 :0]  jtlb_utlb_ref_pgs;          
wire    [`WK_PPN_WIDTH-1:0]  jtlb_utlb_ref_ppn;          
wire    [`WK_VPN_WIDTH-1:0]  jtlb_utlb_ref_vpn;          
wire    [11:0]  jtlb_xx_fifo;               
wire            jtlb_xx_tc_read;            
wire            lsag0_ex1_is_load;
wire            lsag1_ex1_is_load;
wire            lsu_mmu_abort0;             
             
wire            lsu_mmu_abort2;             
wire            lsu_mmu_abort3;             
wire            lsu_mmu_bus_error;          
wire    [63:0]  lsu_mmu_data;               
wire            lsu_mmu_data_vld;           
wire    [IID_WIDTH-1 :0]  lsu_mmu_id0;                
                
wire    [IID_WIDTH-1 :0]  lsu_mmu_id2;                
wire    [IID_WIDTH-1 :0]  lsu_mmu_id3;                
wire            lsu_mmu_st_inst0;           
           
wire            lsu_mmu_st_inst2;           
wire            lsu_mmu_st_inst3;           
// wire    [27:0]  lsu_mmu_stamo_pa;           
// wire            lsu_mmu_stamo_vld;          
wire    [`WK_PPN_WIDTH-1:0]  lsu_mmu_stamo_pa2;           
wire            lsu_mmu_stamo_vld2;          
wire    [`WK_PPN_WIDTH-1:0]  lsu_mmu_stamo_pa3;           
wire            lsu_mmu_stamo_vld3;          
wire            lsu_mmu_tlb_all_inv;        
wire    [15:0]  lsu_mmu_tlb_asid;           
wire            lsu_mmu_tlb_asid_all_inv;   
wire    [`WK_VPN_WIDTH-1:0]  lsu_mmu_tlb_va;             
wire            lsu_mmu_tlb_va_all_inv;     
wire            lsu_mmu_tlb_va_asid_inv;    
wire    [63:0]  lsu_mmu_va0;                
wire            lsu_mmu_va0_vld;            
            
wire    [63:0]  lsu_mmu_va2;                
wire            lsu_mmu_va2_vld;            
wire    [63:0]  lsu_mmu_va3;                
wire            lsu_mmu_va3_vld;            
wire    [`WK_PPN_WIDTH-1:0]  lsu_mmu_va4;                // for pfu
wire    [1 :0]  lsu_mmu_va4_priv_mode;      // for pfu
wire            lsu_mmu_va4_vld;            // for pfu
wire    [3:0]   lsu_mmu_pfu_req_id_q; // wjh@pfu
wire    [`WK_PPN_WIDTH-1:0]  lsu_mmu_vabuf0;             
             
wire    [`WK_PPN_WIDTH-1:0]  lsu_mmu_vabuf2;             
wire    [`WK_PPN_WIDTH-1:0]  lsu_mmu_vabuf3;             
wire            lsu_mmu_old0;
wire            lsu_mmu_old2;
wire            lsu_mmu_old3;
wire            mmu_cp0_cmplt;              
wire    [63:0]  mmu_cp0_data;               
wire            mmu_cp0_data_inj_cmplt;     
wire    [8 :0]  mmu_cp0_ecc_idx;            
wire    [2 :0]  mmu_cp0_ecc_ramid;          
wire            mmu_cp0_ecc_vld;            
wire    [1 :0]  mmu_cp0_ecc_way;            
wire    [63:0]  mmu_cp0_satp_data;          
wire            mmu_cp0_tag_inj_cmplt;      
wire            mmu_cp0_tlb_done;                 
wire            mmu_hpcp_dutlb_miss;        
wire            mmu_hpcp_iutlb_miss;        
wire            mmu_hpcp_jtlb_miss;         
wire            mmu_ifu_buf;                
wire            mmu_ifu_ca;                 
wire            mmu_ifu_deny;               
wire    [`WK_PPN_WIDTH-1:0]  mmu_ifu_pa;                 
wire            mmu_ifu_pavld;              
wire            mmu_ifu_pgflt;              
wire            mmu_ifu_sec;                
wire            mmu_ifu_sh;                 
wire            mmu_lsu_access_fault0;      
     
wire            mmu_lsu_access_fault2;      
wire            mmu_lsu_access_fault3;      
wire            mmu_lsu_buf0;               
               
wire            mmu_lsu_buf2;               
wire            mmu_lsu_buf3;               
wire            mmu_lsu_ca0;                
                
wire            mmu_lsu_ca2;                
wire            mmu_lsu_ca3;                
wire            mmu_lsu_data_req;           
wire    [`WK_PA_WIDTH-1:0]  mmu_lsu_data_req_addr;      
wire            mmu_lsu_data_req_size;      
wire            mmu_lsu_mmu_en;             
wire    [`WK_PPN_WIDTH-1:0]  mmu_lsu_pa0;                
wire                         mmu_lsu_pa0_vld;            
            
wire    [`WK_PPN_WIDTH-1:0]  mmu_lsu_pa2;                
wire                         mmu_lsu_pa2_vld;            
wire    [`WK_PPN_WIDTH-1:0]  mmu_lsu_pa3;                
wire                         mmu_lsu_pa3_vld;            
wire    [`WK_PPN_WIDTH-1:0]  mmu_lsu_pa4;                // for pfu
wire            mmu_lsu_pa4_err;            // for pfu
wire            mmu_lsu_pa4_vld;            // for pfu
wire            mmu_lsu_pfu_req_accepted;    // wjh@pfu
wire    [3:0]   mmu_lsu_pfu_req_accepted_id; // wjh@pfu
wire    [3:0]   mmu_lsu_pfu_resp_id;         // wjh@pfu
wire            mmu_l2c_pfu_regs_utlb_clr;   // i.e. ls_l2_ctxt_change_v lishuo@pfu  
wire            mmu_lsu_page_fault0;        
       
wire            mmu_lsu_page_fault2;        
wire            mmu_lsu_page_fault3;        
wire            mmu_lsu_sec0;               
              
wire            mmu_lsu_sec2;               
wire            mmu_lsu_sec3;               
wire            mmu_lsu_sec4;               // for pfu
wire            mmu_lsu_sh0;                
                
wire            mmu_lsu_sh2;                
wire            mmu_lsu_sh3;                
wire            mmu_lsu_share4;             // for pfu
wire            mmu_lsu_so0;                
                
wire            mmu_lsu_so2;                
wire            mmu_lsu_so3;                
wire            mmu_lsu_stall0;             
             
wire            mmu_lsu_stall2;             
wire            mmu_lsu_stall3;             
wire            mmu_lsu_tlb_busy;           
wire            mmu_lsu_tlb_inv_done;       
wire    [LSIQENTRY-1:0]  mmu_lsu_tlb_wakeup;         
wire    [LSIQENTRY-1:0]  mmu_lsu_async_wakeup0; // wjh@tmq
wire    [LSIQENTRY-1:0]  mmu_lsu_async_wakeup2; // wjh@tmq
wire    [LSIQENTRY-1:0]  mmu_lsu_async_wakeup3; // wjh@tmq
wire                     mmu_lsu_imme_wakeup0; // wjh@tmq 
wire                     mmu_lsu_imme_wakeup2; // wjh@tmq 
wire                     mmu_lsu_imme_wakeup3; // wjh@tmq 
wire    [LSIQENTRY-1:0]  lsu_mmu_lsid0;    // wjh@tmq
wire    [LSIQENTRY-1:0]  lsu_mmu_lsid2;    // wjh@tmq
wire    [LSIQENTRY-1:0]  lsu_mmu_lsid3;    // wjh@tmq
wire            mmu_pmp_fetch3;             
wire    [`WK_PPN_WIDTH-1:0]  mmu_pmp_pa0;                
                
wire    [`WK_PPN_WIDTH-1:0]  mmu_pmp_pa00;                
wire    [`WK_PPN_WIDTH-1:0]  mmu_pmp_pa10;                
wire    [`WK_PPN_WIDTH-1:0]  mmu_pmp_pa2;                
wire    [`WK_PPN_WIDTH-1:0]  mmu_pmp_pa3;                
wire    [`WK_PPN_WIDTH-1:0]  mmu_pmp_pa4;                
wire    [`WK_PPN_WIDTH-1:0]  mmu_sysmap_pa0;             
            
wire    [`WK_PPN_WIDTH-1:0]  mmu_sysmap_pa00;             
wire    [`WK_PPN_WIDTH-1:0]  mmu_sysmap_pa10;             
wire    [`WK_PPN_WIDTH-1:0]  mmu_sysmap_pa2;             
wire    [`WK_PPN_WIDTH-1:0]  mmu_sysmap_pa3;             
wire    [`WK_PPN_WIDTH-1:0]  mmu_sysmap_pa4;             
wire            mmu_xx_mmu_en;              
wire            mmu_yy_xx_no_op;            
wire            pad_yy_icg_scan_en;         
wire    [3 :0]  pmp_mmu_flg0;               
               
wire    [3 :0]  pmp_mmu_flg00;               
wire    [3 :0]  pmp_mmu_flg10;               
wire    [3 :0]  pmp_mmu_flg2;               
wire    [3 :0]  pmp_mmu_flg3;               
wire    [3 :0]  pmp_mmu_flg4;               
wire    [3 :0]  ptw_arb_bank_sel;           
wire    [`MMU_DATA_WIDTH-1:0]  ptw_arb_data_din;           
wire    [3 :0]  ptw_arb_fifo_din;           
wire    [2 :0]  ptw_arb_pgs;                
wire            ptw_arb_req;                
wire    [`MMU_TAG_WIDTH-1:0]  ptw_arb_tag_din;            
wire    [`WK_VPN_WIDTH-1:0]  ptw_arb_vpn;                
wire            ptw_arb_mshr_full; // wjh@pfu
wire            ptw_jtlb_dmiss;             
wire            ptw_jtlb_imiss;             
wire            ptw_jtlb_pmiss;             
wire            ptw_jtlb_ref_acc_err;       
wire            ptw_jtlb_ref_cmplt;         
wire            ptw_jtlb_ref_data_vld;      
wire    [13:0]  ptw_jtlb_ref_flg;           
wire            ptw_jtlb_ref_pgflt;         
wire    [2 :0]  ptw_jtlb_ref_pgs;           
wire    [`WK_PPN_WIDTH-1:0]  ptw_jtlb_ref_ppn;           
wire    [2:0]   ptw_jtlb_ref_ptr; // wjh@pfu
wire            ptw_refill_on;              
wire    [3 :0]  ptw_top_cur_st;             
wire            ptw_top_imiss;              
wire    [15:0]  regs_jtlb_cur_asid;         
wire    [13:0]  regs_jtlb_cur_flg;          
wire            regs_jtlb_cur_g;            
wire    [`WK_PPN_WIDTH-1:0]  regs_jtlb_cur_ppn;          
wire            regs_mmu_en; 
wire            mmu_sv48_en; // added sv48 @hcl                
wire    [15:0]  regs_ptw_cur_asid;          
wire    [`WK_PPN_WIDTH-1:0]  regs_ptw_satp_ppn;          
wire    [15:0]  regs_tlboper_cur_asid;      
wire    [2 :0]  regs_tlboper_cur_pgs;       
wire    [`WK_VPN_WIDTH-1:0]  regs_tlboper_cur_vpn;       
wire    [15:0]  regs_tlboper_inv_asid;      
wire            regs_tlboper_invall;        
wire            regs_tlboper_invasid;       
wire    [11:0]  regs_tlboper_mir;           
wire            regs_tlboper_tlbp;          
wire            regs_tlboper_tlbr;          
wire            regs_tlboper_tlbwi;         
wire            regs_tlboper_tlbwr;         
wire            regs_utlb_clr;              
wire    [`WK_VPN_WIDTH-1:0]  rtu_mmu_bad_vpn;            
wire            rtu_mmu_expt_vld;           
wire            rtu_yy_xx_flush;            
wire            rtu_ck_flush;
wire   [IID_WIDTH-1:0] rtu_ck_flush_iid;
wire    [4 :0]  sysmap_mmu_flg0;            
          
wire    [4 :0]  sysmap_mmu_flg00;            
wire    [4 :0]  sysmap_mmu_flg10;            
wire    [4 :0]  sysmap_mmu_flg2;            
wire    [4 :0]  sysmap_mmu_flg3;            
wire    [4 :0]  sysmap_mmu_flg4;            
wire    [`WK_SYSMAP_NUM-1 :0]  sysmap_mmu_hit0;            
            
wire    [`WK_SYSMAP_NUM-1 :0]  sysmap_mmu_hit00;            
wire    [`WK_SYSMAP_NUM-1 :0]  sysmap_mmu_hit10;            
wire    [`WK_SYSMAP_NUM-1 :0]  sysmap_mmu_hit2;            
wire    [`WK_SYSMAP_NUM-1 :0]  sysmap_mmu_hit3;            
wire    [`WK_SYSMAP_NUM-1 :0]  sysmap_mmu_hit4;            
wire    [`WK_SYSMAP_NUM*`WK_SYSREG_WIDTH-1:0]  sys_regs_value; // 655 = 41*16-1
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
wire    [15:0]  tlboper_jtlb_asid;          
wire            tlboper_jtlb_asid_sel;      
wire            tlboper_jtlb_cmp_noasid;    
wire    [15:0]  tlboper_jtlb_inv_asid;      
wire            tlboper_jtlb_tlbwr_on;      
wire            tlboper_ptw_abort;          
wire            tlboper_regs_cmplt;         
wire            tlboper_regs_tlbp_cmplt;    
wire            tlboper_regs_tlbr_cmplt;    
wire            tlboper_top_lsu_cmplt;      
wire            tlboper_top_lsu_oper;       
wire            tlboper_top_tlbiall_cur_st; 
wire    [2 :0]  tlboper_top_tlbiasid_cur_st; 
wire    [3 :0]  tlboper_top_tlbiva_cur_st;  
wire    [1 :0]  tlboper_top_tlbp_cur_st;    
wire    [1 :0]  tlboper_top_tlbr_cur_st;    
wire    [1 :0]  tlboper_top_tlbwi_cur_st;   
wire    [1 :0]  tlboper_top_tlbwr_cur_st;   
wire            tlboper_utlb_clr;           
wire            tlboper_utlb_inv_va_req;    
wire            tlboper_xx_cmplt;           
wire    [2 :0]  tlboper_xx_pgs;             
wire            tlboper_xx_pgs_en;          
wire            utlb_clk;                   
wire            utlb_clk_en;                

//==========================================================
//                  Risc-V Debug zdb Begin
//==========================================================
output  [`MMU_DEBUG_INFO_WIDTH-1:0] mmu_dtu_debug_info;

wire    [`MMU_DEBUG_INFO_WIDTH-1:0] mmu_dtu_debug_info;
//==========================================================
//                  Risc-V Debug zdb End
//==========================================================

assign utlb_clk_en = regs_utlb_clr
                  || tlboper_utlb_clr
                  || tlboper_utlb_inv_va_req
                  || !regs_mmu_en
                  || jtlb_top_utlb_pavld
                  || dutlb_top_scd_updt
                  || iutlb_top_scd_updt;

// &Instance("gated_clk_cell", "x_utlb_gateclk"); @41
gated_clk_cell  x_utlb_gateclk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (utlb_clk          ),
  .external_en        (1'b0              ),
  .local_en           (utlb_clk_en       ),
  .module_en          (cp0_mmu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect( .clk_in     (forever_cpuclk), @42
//           .external_en(1'b0          ), @43
//           .module_en  (cp0_mmu_icg_en), @44
//           .local_en   (utlb_clk_en  ), @45
//           .clk_out    (utlb_clk     ) @46
//          ); @47

//==========================================================
// Instance utlbs
//==========================================================
// &Instance("xx_mmu_iutlb","x_xx_mmu_iutlb"); @52
xx_mmu_iutlb  x_xx_mmu_iutlb (
  .arb_iutlb_grant         (arb_iutlb_grant        ),
  .biu_mmu_smp_disable     (biu_mmu_smp_disable    ),
  .cp0_mmu_icg_en          (cp0_mmu_icg_en         ),
  .cp0_mmu_no_op_req       (cp0_mmu_no_op_req      ),
  .cp0_mmu_pa_equal_va     (cp0_mmu_pa_equal_va    ),
  .cp0_mmu_sum             (cp0_mmu_sum            ),
  .cp0_yy_priv_mode        (cp0_yy_priv_mode       ),
  .cpurst_b                (cpurst_b               ),
  .forever_cpuclk          (forever_cpuclk         ),
  .hpcp_mmu_cnt_en         (hpcp_mmu_cnt_en        ),
  .ifu_mmu_abort           (ifu_mmu_abort          ),
  .ifu_mmu_va              (ifu_mmu_va             ),
  .ifu_mmu_va_vld          (ifu_mmu_va_vld         ),
  .iutlb_arb_cmplt         (iutlb_arb_cmplt        ),
  .iutlb_arb_req           (iutlb_arb_req          ),
  .iutlb_arb_vpn           (iutlb_arb_vpn          ),
  .iutlb_ptw_wfc           (iutlb_ptw_wfc          ),
  .iutlb_top_ref_cur_st    (iutlb_top_ref_cur_st   ),
  .iutlb_top_scd_updt      (iutlb_top_scd_updt     ),
  .jtlb_iutlb_acc_err      (jtlb_iutlb_acc_err     ),
  .jtlb_iutlb_pgflt        (jtlb_iutlb_pgflt       ),
  .jtlb_iutlb_ref_cmplt    (jtlb_iutlb_ref_cmplt   ),
  .jtlb_iutlb_ref_pavld    (jtlb_iutlb_ref_pavld   ),
  .jtlb_utlb_ref_flg       (jtlb_utlb_ref_flg      ),
  .jtlb_utlb_ref_pgs       (jtlb_utlb_ref_pgs      ),
  .jtlb_utlb_ref_ppn       (jtlb_utlb_ref_ppn      ),
  .jtlb_utlb_ref_vpn       (jtlb_utlb_ref_vpn      ),
  .lsu_mmu_tlb_va          (lsu_mmu_tlb_va         ),
  .mmu_hpcp_iutlb_miss     (mmu_hpcp_iutlb_miss    ),
  .mmu_ifu_buf             (mmu_ifu_buf            ),
  .mmu_ifu_ca              (mmu_ifu_ca             ),
  .mmu_ifu_deny            (mmu_ifu_deny           ),
  .mmu_ifu_pa              (mmu_ifu_pa             ),
  .mmu_ifu_pavld           (mmu_ifu_pavld          ),
  .mmu_ifu_pgflt           (mmu_ifu_pgflt          ),
  .mmu_ifu_sec             (mmu_ifu_sec            ),
  .mmu_ifu_sh              (mmu_ifu_sh             ),
  .mmu_pmp_pa2             (mmu_pmp_pa2            ),
  .mmu_sysmap_pa2          (mmu_sysmap_pa2         ),
  .pad_yy_icg_scan_en      (pad_yy_icg_scan_en     ),
  .pmp_mmu_flg2            (pmp_mmu_flg2           ),
  .regs_mmu_en             (regs_mmu_en            ),
  .mmu_sv48_en             (mmu_sv48_en            ),//added sv48 @hcl 
  .regs_utlb_clr           (regs_utlb_clr          ),
  .sysmap_mmu_flg2         (sysmap_mmu_flg2        ),
  .tlboper_utlb_clr        (tlboper_utlb_clr       ),
  .tlboper_utlb_inv_va_req (tlboper_utlb_inv_va_req),
  .utlb_clk                (utlb_clk               )
);

// &Instance("xx_mmu_dutlb","x_xx_mmu_dutlb"); @53
xx_mmu_dutlb #(
  .LSIQENTRY(LSIQENTRY),
  .IID_WIDTH(IID_WIDTH)
  ) x_xx_mmu_dutlb (
  .arb_dutlb_grant         (arb_dutlb_grant        ),
  .biu_mmu_smp_disable     (biu_mmu_smp_disable    ),
  .cp0_mmu_icg_en          (cp0_mmu_icg_en         ),
  .cp0_mmu_mpp             (cp0_mmu_mpp            ),
  .cp0_mmu_mprv            (cp0_mmu_mprv           ),
  .cp0_mmu_mxr             (cp0_mmu_mxr            ),
  .cp0_mmu_pa_equal_va     (cp0_mmu_pa_equal_va    ),
  .cp0_mmu_sum             (cp0_mmu_sum            ),
  .cp0_yy_priv_mode        (cp0_yy_priv_mode       ),
  .cpurst_b                (cpurst_b               ),
  .dutlb_arb_cmplt         (dutlb_arb_cmplt        ),
  .dutlb_arb_load          (dutlb_arb_load         ),
  .dutlb_arb_req           (dutlb_arb_req          ),
  .dutlb_arb_vpn           (dutlb_arb_vpn          ),
  .dutlb_ptw_wfc           (dutlb_ptw_wfc          ),
  .dutlb_top_ref_cur_st    (dutlb_top_ref_cur_st   ),
  .dutlb_top_ref_type      (dutlb_top_ref_type     ),
  .dutlb_top_scd_updt      (dutlb_top_scd_updt     ),
  .dutlb_xx_mmu_off        (dutlb_xx_mmu_off       ),
  .forever_cpuclk          (forever_cpuclk         ),
  .hpcp_mmu_cnt_en         (hpcp_mmu_cnt_en        ),
  .jtlb_dutlb_acc_err      (jtlb_dutlb_acc_err     ),
  .jtlb_dutlb_pgflt        (jtlb_dutlb_pgflt       ),
  .jtlb_dutlb_ref_cmplt    (jtlb_dutlb_ref_cmplt   ),
  .jtlb_dutlb_ref_pavld    (jtlb_dutlb_ref_pavld   ),
  .jtlb_utlb_ref_flg       (jtlb_utlb_ref_flg      ),
  .jtlb_utlb_ref_pgs       (jtlb_utlb_ref_pgs      ),
  .jtlb_utlb_ref_ppn       (jtlb_utlb_ref_ppn      ),
  .jtlb_utlb_ref_vpn       (jtlb_utlb_ref_vpn      ),
  .ptw_tmq_va_hit          (ptw_tmq_va_hit),
  .lsag0_ex1_is_load       (lsag0_ex1_is_load      ),
  .lsag1_ex1_is_load       (lsag1_ex1_is_load      ),
  .lsu_mmu_abort0          (lsu_mmu_abort0         ),
  .lsu_mmu_abort2          (lsu_mmu_abort2         ),
  .lsu_mmu_abort3          (lsu_mmu_abort3         ),
  .lsu_mmu_id0             (lsu_mmu_id0            ),
  .lsu_mmu_id2             (lsu_mmu_id2            ),
  .lsu_mmu_id3             (lsu_mmu_id3            ),
  .lsu_mmu_st_inst0        (lsu_mmu_st_inst0       ),
  .lsu_mmu_st_inst2        (lsu_mmu_st_inst2       ),
  .lsu_mmu_st_inst3        (lsu_mmu_st_inst3       ),
  .lsu_mmu_stamo_pa2        (lsu_mmu_stamo_pa2      ),
  .lsu_mmu_stamo_vld2       (lsu_mmu_stamo_vld2     ),
  .lsu_mmu_stamo_pa3        (lsu_mmu_stamo_pa3      ),
  .lsu_mmu_stamo_vld3       (lsu_mmu_stamo_vld3     ),
  .lsu_mmu_tlb_va          (lsu_mmu_tlb_va         ),
  .lsu_mmu_va0             (lsu_mmu_va0            ),
  .lsu_mmu_va0_vld         (lsu_mmu_va0_vld        ),
  .lsu_mmu_va2             (lsu_mmu_va2            ),
  .lsu_mmu_va2_vld         (lsu_mmu_va2_vld        ),
  .lsu_mmu_va3             (lsu_mmu_va3            ),
  .lsu_mmu_va3_vld         (lsu_mmu_va3_vld        ),
  .lsu_mmu_vabuf0          (lsu_mmu_vabuf0         ),
  .lsu_mmu_vabuf2          (lsu_mmu_vabuf2         ),
  .lsu_mmu_vabuf3          (lsu_mmu_vabuf3         ),
  .lsu_mmu_old0            (lsu_mmu_old0           ),
  .lsu_mmu_old2            (lsu_mmu_old2           ),
  .lsu_mmu_old3            (lsu_mmu_old3           ),
  .mmu_hpcp_dutlb_miss     (mmu_hpcp_dutlb_miss    ),
  .mmu_lsu_access_fault0   (mmu_lsu_access_fault0  ),
  .mmu_lsu_access_fault2   (mmu_lsu_access_fault2  ),
  .mmu_lsu_access_fault3   (mmu_lsu_access_fault3  ),
  .mmu_lsu_buf0            (mmu_lsu_buf0           ),
  .mmu_lsu_buf2            (mmu_lsu_buf2           ),
  .mmu_lsu_buf3            (mmu_lsu_buf3           ),
  .mmu_lsu_ca0             (mmu_lsu_ca0            ),
  .mmu_lsu_ca2             (mmu_lsu_ca2            ),
  .mmu_lsu_ca3             (mmu_lsu_ca3            ),
  .mmu_lsu_pa0             (mmu_lsu_pa0            ),
  .mmu_lsu_pa0_vld         (mmu_lsu_pa0_vld        ),
  .mmu_lsu_pa2             (mmu_lsu_pa2            ),
  .mmu_lsu_pa2_vld         (mmu_lsu_pa2_vld        ),
  .mmu_lsu_pa3             (mmu_lsu_pa3            ),
  .mmu_lsu_pa3_vld         (mmu_lsu_pa3_vld        ),
  .mmu_lsu_page_fault0     (mmu_lsu_page_fault0    ),
  .mmu_lsu_page_fault2     (mmu_lsu_page_fault2    ),
  .mmu_lsu_page_fault3     (mmu_lsu_page_fault3    ),
  .mmu_lsu_sec0            (mmu_lsu_sec0           ),
  .mmu_lsu_sec2            (mmu_lsu_sec2           ),
  .mmu_lsu_sec3            (mmu_lsu_sec3           ),
  .mmu_lsu_sh0             (mmu_lsu_sh0            ),
  .mmu_lsu_sh2             (mmu_lsu_sh2            ),
  .mmu_lsu_sh3             (mmu_lsu_sh3            ),
  .mmu_lsu_so0             (mmu_lsu_so0            ),
  .mmu_lsu_so2             (mmu_lsu_so2            ),
  .mmu_lsu_so3             (mmu_lsu_so3            ),
  .mmu_lsu_stall0          (mmu_lsu_stall0         ),
  .mmu_lsu_stall2          (mmu_lsu_stall2         ),
  .mmu_lsu_stall3          (mmu_lsu_stall3         ),
  .mmu_lsu_tlb_busy        (mmu_lsu_tlb_busy       ),
  .mmu_lsu_tlb_wakeup      (mmu_lsu_tlb_wakeup     ),
  .mmu_lsu_async_wakeup0   (mmu_lsu_async_wakeup0), // wjh@tmq
  .mmu_lsu_async_wakeup2   (mmu_lsu_async_wakeup2), // wjh@tmq
  .mmu_lsu_async_wakeup3   (mmu_lsu_async_wakeup3), // wjh@tmq
  .mmu_lsu_imme_wakeup0    (mmu_lsu_imme_wakeup0), // wjh@tmq
  .mmu_lsu_imme_wakeup2    (mmu_lsu_imme_wakeup2), // wjh@tmq
  .mmu_lsu_imme_wakeup3    (mmu_lsu_imme_wakeup3), // wjh@tmq
  .lsu_mmu_lsid0           (lsu_mmu_lsid0),    // wjh@tmq
  .lsu_mmu_lsid2           (lsu_mmu_lsid2),    // wjh@tmq
  .lsu_mmu_lsid3           (lsu_mmu_lsid3),    // wjh@tmq
  .mmu_pmp_pa0             (mmu_pmp_pa0            ),
  .mmu_pmp_pa00            (mmu_pmp_pa00           ),
  .mmu_pmp_pa10            (mmu_pmp_pa10           ),
  .mmu_sysmap_pa0          (mmu_sysmap_pa0         ),
  .mmu_sysmap_pa00         (mmu_sysmap_pa00        ),
  .mmu_sysmap_pa10         (mmu_sysmap_pa10        ),
  .pad_yy_icg_scan_en      (pad_yy_icg_scan_en     ),
  .pmp_mmu_flg0            (pmp_mmu_flg0           ),
  .pmp_mmu_flg00           (pmp_mmu_flg00          ),
  .pmp_mmu_flg10           (pmp_mmu_flg10          ),
  .regs_mmu_en             (regs_mmu_en            ),
  .mmu_sv48_en             (mmu_sv48_en            ),//added sv48 @hcl 
  .regs_utlb_clr           (regs_utlb_clr          ),
  .rtu_yy_xx_flush         (rtu_yy_xx_flush        ),
  .rtu_ck_flush            (rtu_ck_flush           ),
  .rtu_ck_flush_iid        (rtu_ck_flush_iid       ),
  .sysmap_mmu_flg0         (sysmap_mmu_flg0        ),
  .sysmap_mmu_flg00        (sysmap_mmu_flg00       ),
  .sysmap_mmu_flg10        (sysmap_mmu_flg10       ),
  .tlboper_utlb_clr        (tlboper_utlb_clr       ),
  .tlboper_utlb_inv_va_req (tlboper_utlb_inv_va_req),
  .utlb_clk                (utlb_clk               )
);


//==========================================================
// Instance mmu regs
//==========================================================
// &Instance("xx_mmu_regs", "x_xx_mmu_regs"); @58
xx_mmu_regs  x_xx_mmu_regs (
  .cp0_mmu_cskyee           (cp0_mmu_cskyee          ),
  .cp0_mmu_icg_en           (cp0_mmu_icg_en          ),
  .cp0_mmu_mpp              (cp0_mmu_mpp             ),
  .cp0_mmu_mprv             (cp0_mmu_mprv            ),
  .cp0_mmu_reg_num          (cp0_mmu_reg_num         ),
  .cp0_mmu_satp_sel         (cp0_mmu_satp_sel        ),
  .cp0_mmu_wdata            (cp0_mmu_wdata           ),
  .cp0_mmu_wreg             (cp0_mmu_wreg            ),
  .cp0_yy_priv_mode         (cp0_yy_priv_mode        ),
  .cpurst_b                 (cpurst_b                ),
  .forever_cpuclk           (forever_cpuclk          ),
  .jtlb_regs_hit            (jtlb_regs_hit           ),
  .jtlb_regs_hit_mult       (jtlb_regs_hit_mult      ),
  .jtlb_regs_tlbp_hit_index (jtlb_regs_tlbp_hit_index),
  .jtlb_tlbr_asid           (jtlb_tlbr_asid          ),
  .jtlb_tlbr_flg            (jtlb_tlbr_flg           ),
  .jtlb_tlbr_g              (jtlb_tlbr_g             ),
  .jtlb_tlbr_pgs            (jtlb_tlbr_pgs           ),
  .jtlb_tlbr_ppn            (jtlb_tlbr_ppn           ),
  .jtlb_tlbr_vpn            (jtlb_tlbr_vpn           ),
  .mmu_cp0_cmplt            (mmu_cp0_cmplt           ),
  .mmu_cp0_data             (mmu_cp0_data            ),
  .mmu_cp0_satp_data        (mmu_cp0_satp_data       ),
  .mmu_lsu_mmu_en           (mmu_lsu_mmu_en          ),
  .mmu_xx_mmu_en            (mmu_xx_mmu_en           ),
  .sys_regs_value           (sys_regs_value          ),
  .pad_yy_icg_scan_en       (pad_yy_icg_scan_en      ),
  .regs_jtlb_cur_asid       (regs_jtlb_cur_asid      ),
  .regs_jtlb_cur_flg        (regs_jtlb_cur_flg       ),
  .regs_jtlb_cur_g          (regs_jtlb_cur_g         ),
  .regs_jtlb_cur_ppn        (regs_jtlb_cur_ppn       ),
  .regs_mmu_en              (regs_mmu_en             ),
  .mmu_sv48_en              (mmu_sv48_en             ),//added sv48 @hcl 
  .regs_ptw_cur_asid        (regs_ptw_cur_asid       ),
  .regs_ptw_satp_ppn        (regs_ptw_satp_ppn       ),
  .regs_tlboper_cur_asid    (regs_tlboper_cur_asid   ),
  .regs_tlboper_cur_pgs     (regs_tlboper_cur_pgs    ),
  .regs_tlboper_cur_vpn     (regs_tlboper_cur_vpn    ),
  .regs_tlboper_inv_asid    (regs_tlboper_inv_asid   ),
  .regs_tlboper_invall      (regs_tlboper_invall     ),
  .regs_tlboper_invasid     (regs_tlboper_invasid    ),
  .regs_tlboper_mir         (regs_tlboper_mir        ),
  .regs_tlboper_tlbp        (regs_tlboper_tlbp       ),
  .regs_tlboper_tlbr        (regs_tlboper_tlbr       ),
  .regs_tlboper_tlbwi       (regs_tlboper_tlbwi      ),
  .regs_tlboper_tlbwr       (regs_tlboper_tlbwr      ),
  .regs_utlb_clr            (regs_utlb_clr           ),
  .rtu_mmu_bad_vpn          (rtu_mmu_bad_vpn         ),
  .rtu_mmu_expt_vld         (rtu_mmu_expt_vld        ),
  .tlboper_regs_cmplt       (tlboper_regs_cmplt      ),
  .tlboper_regs_tlbp_cmplt  (tlboper_regs_tlbp_cmplt ),
  .tlboper_regs_tlbr_cmplt  (tlboper_regs_tlbr_cmplt )
);


//==========================================================
// Instance cp0 & ctc request module
//==========================================================
// &Instance("xx_mmu_tlboper", "x_xx_mmu_tlboper"); @63
xx_mmu_tlboper  x_xx_mmu_tlboper (
  .arb_tlboper_grant           (arb_tlboper_grant          ),
  .cp0_mmu_icg_en              (cp0_mmu_icg_en             ),
  .cp0_mmu_tlb_all_inv         (cp0_mmu_tlb_all_inv        ),
  .cpurst_b                    (cpurst_b                   ),
  .forever_cpuclk              (forever_cpuclk             ),
  .jtlb_tlboper_asid_hit       (jtlb_tlboper_asid_hit      ),
  .jtlb_tlboper_cmplt          (jtlb_tlboper_cmplt         ),
  .jtlb_tlboper_fifo           (jtlb_tlboper_fifo          ),
  .jtlb_tlboper_read_idle      (jtlb_tlboper_read_idle     ),
  .jtlb_tlboper_sel            (jtlb_tlboper_sel           ),
  .jtlb_tlboper_va_hit         (jtlb_tlboper_va_hit        ),
  .jtlb_xx_tc_read             (jtlb_xx_tc_read            ),
  .lsu_mmu_tlb_all_inv         (lsu_mmu_tlb_all_inv        ),
  .lsu_mmu_tlb_asid            (lsu_mmu_tlb_asid           ),
  .lsu_mmu_tlb_asid_all_inv    (lsu_mmu_tlb_asid_all_inv   ),
  .lsu_mmu_tlb_va              (lsu_mmu_tlb_va             ),
  .lsu_mmu_tlb_va_all_inv      (lsu_mmu_tlb_va_all_inv     ),
  .lsu_mmu_tlb_va_asid_inv     (lsu_mmu_tlb_va_asid_inv    ),
  .mmu_cp0_tlb_done            (mmu_cp0_tlb_done           ),
  .mmu_lsu_tlb_inv_done        (mmu_lsu_tlb_inv_done       ),
  .pad_yy_icg_scan_en          (pad_yy_icg_scan_en         ),
  .regs_jtlb_cur_flg           (regs_jtlb_cur_flg          ),
  .regs_jtlb_cur_g             (regs_jtlb_cur_g            ),
  .regs_jtlb_cur_ppn           (regs_jtlb_cur_ppn          ),
  .regs_tlboper_cur_asid       (regs_tlboper_cur_asid      ),
  .regs_tlboper_cur_pgs        (regs_tlboper_cur_pgs       ),
  .regs_tlboper_cur_vpn        (regs_tlboper_cur_vpn       ),
  .regs_tlboper_inv_asid       (regs_tlboper_inv_asid      ),
  .regs_tlboper_invall         (regs_tlboper_invall        ),
  .regs_tlboper_invasid        (regs_tlboper_invasid       ),
  .regs_tlboper_mir            (regs_tlboper_mir           ),
  .regs_tlboper_tlbp           (regs_tlboper_tlbp          ),
  .regs_tlboper_tlbr           (regs_tlboper_tlbr          ),
  .regs_tlboper_tlbwi          (regs_tlboper_tlbwi         ),
  .regs_tlboper_tlbwr          (regs_tlboper_tlbwr         ),
  .tlb_sm_idle                 (tlb_sm_idle                ),
  .tlboper_arb_bank_sel        (tlboper_arb_bank_sel       ),
  .tlboper_arb_cmp_va          (tlboper_arb_cmp_va         ),
  .tlboper_arb_data_din        (tlboper_arb_data_din       ),
  .tlboper_arb_fifo_din        (tlboper_arb_fifo_din       ),
  .tlboper_arb_fifo_write      (tlboper_arb_fifo_write     ),
  .tlboper_arb_idx             (tlboper_arb_idx            ),
  .tlboper_arb_idx_not_va      (tlboper_arb_idx_not_va     ),
  .tlboper_arb_req             (tlboper_arb_req            ),
  .tlboper_arb_tag_din         (tlboper_arb_tag_din        ),
  .tlboper_arb_vpn             (tlboper_arb_vpn            ),
  .tlboper_arb_write           (tlboper_arb_write          ),
  .tlboper_jtlb_asid           (tlboper_jtlb_asid          ),
  .tlboper_jtlb_asid_sel       (tlboper_jtlb_asid_sel      ),
  .tlboper_jtlb_cmp_noasid     (tlboper_jtlb_cmp_noasid    ),
  .tlboper_jtlb_inv_asid       (tlboper_jtlb_inv_asid      ),
  .tlboper_jtlb_tlbwr_on       (tlboper_jtlb_tlbwr_on      ),
  .tlboper_ptw_abort           (tlboper_ptw_abort          ),
  .tlboper_regs_cmplt          (tlboper_regs_cmplt         ),
  .tlboper_regs_tlbp_cmplt     (tlboper_regs_tlbp_cmplt    ),
  .tlboper_regs_tlbr_cmplt     (tlboper_regs_tlbr_cmplt    ),
  .tlboper_top_lsu_cmplt       (tlboper_top_lsu_cmplt      ),
  .tlboper_top_lsu_oper        (tlboper_top_lsu_oper       ),
  .tlboper_top_tlbiall_cur_st  (tlboper_top_tlbiall_cur_st ),
  .tlboper_top_tlbiasid_cur_st (tlboper_top_tlbiasid_cur_st),
  .tlboper_top_tlbiva_cur_st   (tlboper_top_tlbiva_cur_st  ),
  .tlboper_top_tlbp_cur_st     (tlboper_top_tlbp_cur_st    ),
  .tlboper_top_tlbr_cur_st     (tlboper_top_tlbr_cur_st    ),
  .tlboper_top_tlbwi_cur_st    (tlboper_top_tlbwi_cur_st   ),
  .tlboper_top_tlbwr_cur_st    (tlboper_top_tlbwr_cur_st   ),
  .tlboper_utlb_clr            (tlboper_utlb_clr           ),
  .tlboper_utlb_inv_va_req     (tlboper_utlb_inv_va_req    ),
  .tlboper_xx_cmplt            (tlboper_xx_cmplt           ),
  .tlboper_xx_pgs              (tlboper_xx_pgs             ),
  .tlboper_xx_pgs_en           (tlboper_xx_pgs_en          )
);


//==========================================================
// Instance jTLB request arbiter
//==========================================================
// &Instance("xx_mmu_arb", "x_xx_mmu_arb"); @68
xx_mmu_arb  x_xx_mmu_arb (
  .arb_dutlb_grant        (arb_dutlb_grant       ),
  .arb_iutlb_grant        (arb_iutlb_grant       ),
  .arb_jtlb_acc_type      (arb_jtlb_acc_type     ),
  .arb_jtlb_asid          (arb_jtlb_asid         ),
  .arb_jtlb_bank_sel      (arb_jtlb_bank_sel     ),
  .arb_jtlb_cmp_with_va   (arb_jtlb_cmp_with_va  ),
  .arb_jtlb_data_din      (arb_jtlb_data_din     ),
  .arb_jtlb_fifo_din      (arb_jtlb_fifo_din     ),
  .arb_jtlb_fifo_write    (arb_jtlb_fifo_write   ),
  .arb_jtlb_idx           (arb_jtlb_idx          ),
  .arb_jtlb_pfu_grant     (arb_jtlb_pfu_grant    ),
  .arb_jtlb_req           (arb_jtlb_req          ),
  .arb_jtlb_tag_din       (arb_jtlb_tag_din      ),
  .arb_jtlb_vpn           (arb_jtlb_vpn          ),
  .arb_jtlb_write         (arb_jtlb_write        ),
  .arb_jtlb_ptr           (arb_jtlb_ptr), // wjh@pfu
  .arb_ptw_grant          (arb_ptw_grant         ),
  .arb_ptw_mask           (arb_ptw_mask          ),
  .arb_tlboper_grant      (arb_tlboper_grant     ),
  .arb_top_cur_st         (arb_top_cur_st        ),
  .arb_top_tlboper_on     (arb_top_tlboper_on    ),
  .cp0_mmu_icg_en         (cp0_mmu_icg_en        ),
  .cp0_mmu_no_op_req      (cp0_mmu_no_op_req     ),
  .cpurst_b               (cpurst_b              ),
  .dutlb_arb_cmplt        (dutlb_arb_cmplt       ),
  .dutlb_arb_load         (dutlb_arb_load        ),
  .dutlb_arb_req          (dutlb_arb_req         ),
  .dutlb_arb_vpn          (dutlb_arb_vpn         ),
  .forever_cpuclk         (forever_cpuclk        ),
  .iutlb_arb_cmplt        (iutlb_arb_cmplt       ),
  .iutlb_arb_req          (iutlb_arb_req         ),
  .iutlb_arb_vpn          (iutlb_arb_vpn         ),
  .jtlb_arb_asid          (jtlb_arb_asid         ),
  .jtlb_arb_cmp_va        (jtlb_arb_cmp_va       ),
  .jtlb_arb_par_clr       (jtlb_arb_par_clr      ),
  .jtlb_arb_pfu_cmplt     (jtlb_arb_pfu_cmplt    ),
  .jtlb_arb_pfu_vpn       (jtlb_arb_pfu_vpn      ),
  .jtlb_arb_sel_1g        (jtlb_arb_sel_1g       ),
  .jtlb_arb_sel_2m        (jtlb_arb_sel_2m       ),
  .jtlb_arb_sel_4k        (jtlb_arb_sel_4k       ),
  .jtlb_arb_tc_miss       (jtlb_arb_tc_miss      ),
  .jtlb_arb_type          (jtlb_arb_type         ),
  .jtlb_arb_vpn           (jtlb_arb_vpn          ),
  .lsu_mmu_va2_priv_mode  (pfu_xxx_priv_mode ),// for pfu, wjh@pfu, signals now from pfu
  .lsu_mmu_va2_vld        (pfu_arb_vld ),      // for pfu, wjh@pfu, signals now from pfu
  .pfu_arb_ptr            (pfu_arb_ptr),       // wjh@pfu
  .jtlb_arb_ptr           (jtlb_arb_ptr),      // wjh@pfu
  .mmu_yy_xx_no_op        (mmu_yy_xx_no_op       ),
  .pad_yy_icg_scan_en     (pad_yy_icg_scan_en    ),
  .ptw_arb_bank_sel       (ptw_arb_bank_sel      ),
  .ptw_arb_data_din       (ptw_arb_data_din      ),
  .ptw_arb_fifo_din       (ptw_arb_fifo_din      ),
  .ptw_arb_pgs            (ptw_arb_pgs           ),
  .ptw_arb_req            (ptw_arb_req           ),
  .ptw_arb_tag_din        (ptw_arb_tag_din       ),
  .ptw_arb_vpn            (ptw_arb_vpn           ),
  .ptw_arb_mshr_full      (ptw_arb_mshr_full), // wjh@pfu
  .ptw_arb_dmiss          (ptw_jtlb_dmiss),    // wjh@pfu
  .ptw_arb_imiss          (ptw_jtlb_imiss),    // wjh@pfu
  .ptw_arb_pmiss          (ptw_jtlb_pmiss),    // wjh@pfu
  .ptw_refill_on          (ptw_refill_on         ),
  .regs_jtlb_cur_asid     (regs_jtlb_cur_asid    ),
  .regs_mmu_en            (regs_mmu_en           ),
  .tlb_sm_idle            (tlb_sm_idle           ),
  .tlboper_arb_bank_sel   (tlboper_arb_bank_sel  ),
  .tlboper_arb_cmp_va     (tlboper_arb_cmp_va    ),
  .tlboper_arb_data_din   (tlboper_arb_data_din  ),
  .tlboper_arb_fifo_din   (tlboper_arb_fifo_din  ),
  .tlboper_arb_fifo_write (tlboper_arb_fifo_write),
  .tlboper_arb_idx        (tlboper_arb_idx       ),
  .tlboper_arb_idx_not_va (tlboper_arb_idx_not_va),
  .tlboper_arb_req        (tlboper_arb_req       ),
  .tlboper_arb_tag_din    (tlboper_arb_tag_din   ),
  .tlboper_arb_vpn        (tlboper_arb_vpn       ),
  .tlboper_arb_write      (tlboper_arb_write     ),
  .tlboper_xx_cmplt       (tlboper_xx_cmplt      ),
  .tlboper_xx_pgs         (tlboper_xx_pgs        ),
  .tlboper_xx_pgs_en      (tlboper_xx_pgs_en     )
);
// wjh@pfu begin 
xx_mmu_pfu i_xx_mmu_pfu(
  .cpurst_b                    (cpurst_b),
  .forever_cpuclk              (forever_cpuclk),
  .regs_mmu_en                 (regs_mmu_en),
  .lsu_mmu_va4                 (lsu_mmu_va4),
  .lsu_mmu_va4_priv_mode       (lsu_mmu_va4_priv_mode),
  .lsu_mmu_va4_vld             (lsu_mmu_va4_vld),
  .lsu_mmu_pfu_req_id_q        (lsu_mmu_pfu_req_id_q),
  .jtlb_pfu_cmplt              (jtlb_pfu_cmplt),
  .jtlb_pfu_ptr                (jtlb_pfu_ptr),
  .jtlb_pfu_pa                 (jtlb_pfu_pa),
  .jtlb_pfu_sec                (jtlb_pfu_sec),
  .jtlb_pfu_acc_fault          (jtlb_pfu_acc_fault),
  .jtlb_pfu_share              (jtlb_pfu_share),
  .arb_pfu_grnt                (arb_jtlb_pfu_grant),
  .pfu_arb_vld                 (pfu_arb_vld), // to arb, replace lsu_mmu_pa4_vld
  .pfu_arb_ptr                 (pfu_arb_ptr),
  .pfu_xxx_priv_mode           (pfu_xxx_priv_mode),
  .pfu_jtlb_va                 (pfu_jtlb_va),
  .ptw_pfu_va_hit              (ptw_pfu_va_hit),
  .pmp_mmu_flg4                (pmp_mmu_flg4),
  .mmu_pmp_pa4                 (mmu_pmp_pa4),
  .mmu_lsu_pa4                 (mmu_lsu_pa4),
  .mmu_lsu_pa4_err             (mmu_lsu_pa4_err),
  .mmu_lsu_pa4_vld             (mmu_lsu_pa4_vld),
  .mmu_lsu_sec4                (mmu_lsu_sec4),
  .mmu_lsu_share4              (mmu_lsu_share4),
  .mmu_lsu_pfu_req_accepted    (mmu_lsu_pfu_req_accepted),
  .mmu_lsu_pfu_req_accepted_id (mmu_lsu_pfu_req_accepted_id),
  .mmu_lsu_pfu_resp_id         (mmu_lsu_pfu_resp_id)
);
// wjh@pfu end
//==========================================================
// Instance jTLB pipeline module
//==========================================================
// &Instance("xx_mmu_jtlb", "x_xx_mmu_jtlb"); @73
xx_mmu_jtlb  x_xx_mmu_jtlb (
  .arb_jtlb_acc_type        (arb_jtlb_acc_type       ),
  .arb_jtlb_asid            (arb_jtlb_asid           ),
  .arb_jtlb_bank_sel        (arb_jtlb_bank_sel       ),
  .arb_jtlb_cmp_with_va     (arb_jtlb_cmp_with_va    ),
  .arb_jtlb_data_din        (arb_jtlb_data_din       ),
  .arb_jtlb_fifo_din        (arb_jtlb_fifo_din       ),
  .arb_jtlb_fifo_write      (arb_jtlb_fifo_write     ),
  .arb_jtlb_idx             (arb_jtlb_idx            ),
  .arb_jtlb_pfu_grant       (arb_jtlb_pfu_grant      ),
  .arb_jtlb_req             (arb_jtlb_req            ),
  .arb_jtlb_tag_din         (arb_jtlb_tag_din        ),
  .arb_jtlb_vpn             (arb_jtlb_vpn            ),
  .arb_jtlb_write           (arb_jtlb_write          ),
  .arb_jtlb_ptr             (arb_jtlb_ptr), // wjh@pfu
  .cp0_mmu_data_ecc_inj     (cp0_mmu_data_ecc_inj    ),
  .cp0_mmu_data_random      (cp0_mmu_data_random     ),
  .cp0_mmu_ecc_en           (cp0_mmu_ecc_en          ),
  .cp0_mmu_icg_en           (cp0_mmu_icg_en          ),
  .cp0_mmu_maee             (cp0_mmu_maee            ),
  .cp0_mmu_mxr              (cp0_mmu_mxr             ),
  .cp0_mmu_ptw_en           (cp0_mmu_ptw_en          ),
  .cp0_mmu_sum              (cp0_mmu_sum             ),
  .cp0_mmu_tag_ecc_inj      (cp0_mmu_tag_ecc_inj     ),
  .cp0_mmu_tag_random       ({9'b0,cp0_mmu_tag_random}),
  .cpurst_b                 (cpurst_b                ),
  .dutlb_xx_mmu_off         (dutlb_xx_mmu_off        ),
  .forever_cpuclk           (forever_cpuclk          ),
  .jtlb_arb_asid            (jtlb_arb_asid           ),
  .jtlb_arb_cmp_va          (jtlb_arb_cmp_va         ),
  .jtlb_arb_par_clr         (jtlb_arb_par_clr        ),
  .jtlb_arb_pfu_cmplt       (jtlb_arb_pfu_cmplt      ),
  .jtlb_arb_pfu_vpn         (jtlb_arb_pfu_vpn        ),
  .jtlb_arb_sel_1g          (jtlb_arb_sel_1g         ),
  .jtlb_arb_sel_2m          (jtlb_arb_sel_2m         ),
  .jtlb_arb_sel_4k          (jtlb_arb_sel_4k         ),
  .jtlb_arb_tc_miss         (jtlb_arb_tc_miss        ),
  .jtlb_arb_type            (jtlb_arb_type           ),
  .jtlb_arb_vpn             (jtlb_arb_vpn            ),
  .jtlb_arb_ptr             (jtlb_arb_ptr), // wjh@pfu
  .jtlb_dutlb_acc_err       (jtlb_dutlb_acc_err      ),
  .jtlb_dutlb_pgflt         (jtlb_dutlb_pgflt        ),
  .jtlb_dutlb_ref_cmplt     (jtlb_dutlb_ref_cmplt    ),
  .jtlb_dutlb_ref_pavld     (jtlb_dutlb_ref_pavld    ),
  .jtlb_iutlb_acc_err       (jtlb_iutlb_acc_err      ),
  .jtlb_iutlb_pgflt         (jtlb_iutlb_pgflt        ),
  .jtlb_iutlb_ref_cmplt     (jtlb_iutlb_ref_cmplt    ),
  .jtlb_iutlb_ref_pavld     (jtlb_iutlb_ref_pavld    ),
  .jtlb_ptw_asid            (jtlb_ptw_asid           ),
  .jtlb_ptw_req             (jtlb_ptw_req            ),
  .jtlb_ptw_type            (jtlb_ptw_type           ),
  .jtlb_ptw_vpn             (jtlb_ptw_vpn            ),
  .jtlb_ptw_ptr             (jtlb_ptw_ptr),       // wjh@pfu
  .jtlb_ptw_has_cmplt       (jtlb_ptw_has_cmplt), // wjh@pfu
  .jtlb_pfu_cmplt           (jtlb_pfu_cmplt),     // wjh@pfu
  .jtlb_pfu_acc_fault       (jtlb_pfu_acc_fault), // wjh@pfu
  .jtlb_pfu_pa              (jtlb_pfu_pa),        // wjh@pfu
  .jtlb_pfu_sec             (jtlb_pfu_sec),       // wjh@pfu
  .jtlb_pfu_share           (jtlb_pfu_share),     // wjh@pfu
  .jtlb_pfu_ptr             (jtlb_pfu_ptr),       // wjh@pfu
  .jtlb_regs_hit            (jtlb_regs_hit           ),
  .jtlb_regs_hit_mult       (jtlb_regs_hit_mult      ),
  .jtlb_regs_tlbp_hit_index (jtlb_regs_tlbp_hit_index),
  .jtlb_tlboper_asid_hit    (jtlb_tlboper_asid_hit   ),
  .jtlb_tlboper_cmplt       (jtlb_tlboper_cmplt      ),
  .jtlb_tlboper_fifo        (jtlb_tlboper_fifo       ),
  .jtlb_tlboper_read_idle   (jtlb_tlboper_read_idle  ),
  .jtlb_tlboper_sel         (jtlb_tlboper_sel        ),
  .jtlb_tlboper_va_hit      (jtlb_tlboper_va_hit     ),
  .jtlb_tlbr_asid           (jtlb_tlbr_asid          ),
  .jtlb_tlbr_flg            (jtlb_tlbr_flg           ),
  .jtlb_tlbr_g              (jtlb_tlbr_g             ),
  .jtlb_tlbr_pgs            (jtlb_tlbr_pgs           ),
  .jtlb_tlbr_ppn            (jtlb_tlbr_ppn           ),
  .jtlb_tlbr_vpn            (jtlb_tlbr_vpn           ),
  .jtlb_top_cur_st          (jtlb_top_cur_st         ),
  .jtlb_top_utlb_pavld      (jtlb_top_utlb_pavld     ),
  .jtlb_utlb_ref_flg        (jtlb_utlb_ref_flg       ),
  .jtlb_utlb_ref_pgs        (jtlb_utlb_ref_pgs       ),
  .jtlb_utlb_ref_ppn        (jtlb_utlb_ref_ppn       ),
  .jtlb_utlb_ref_vpn        (jtlb_utlb_ref_vpn       ),
  .jtlb_xx_fifo             (jtlb_xx_fifo            ),
  .jtlb_xx_tc_read          (jtlb_xx_tc_read         ),
  .lsu_mmu_va2              ( pfu_jtlb_va),      // wjh@pfu signals now from pfu
  .lsu_mmu_va2_priv_mode    ( pfu_xxx_priv_mode), // wjh@pfu signals now from pfu
  .mmu_cp0_data_inj_cmplt   (mmu_cp0_data_inj_cmplt  ),
  .mmu_cp0_ecc_idx          (mmu_cp0_ecc_idx         ),
  .mmu_cp0_ecc_ramid        (mmu_cp0_ecc_ramid       ),
  .mmu_cp0_ecc_vld          (mmu_cp0_ecc_vld         ),
  .mmu_cp0_ecc_way          (mmu_cp0_ecc_way         ),
  .mmu_cp0_tag_inj_cmplt    (mmu_cp0_tag_inj_cmplt   ),
  .mmu_sysmap_pa4           (mmu_sysmap_pa4          ),
  .pad_yy_icg_scan_en       (pad_yy_icg_scan_en      ),
  .pmp_mmu_flg4             (pmp_mmu_flg4            ),
  .ptw_arb_vpn              (ptw_arb_vpn             ),
  .ptw_jtlb_dmiss           (ptw_jtlb_dmiss          ),
  .ptw_jtlb_imiss           (ptw_jtlb_imiss          ),
  .ptw_jtlb_pmiss           (ptw_jtlb_pmiss          ),
  .ptw_jtlb_ref_acc_err     (ptw_jtlb_ref_acc_err    ),
  .ptw_jtlb_ref_cmplt       (ptw_jtlb_ref_cmplt      ),
  .ptw_jtlb_ref_data_vld    (ptw_jtlb_ref_data_vld   ),
  .ptw_jtlb_ref_flg         (ptw_jtlb_ref_flg        ),
  .ptw_jtlb_ref_pgflt       (ptw_jtlb_ref_pgflt      ),
  .ptw_jtlb_ref_pgs         (ptw_jtlb_ref_pgs        ),
  .ptw_jtlb_ref_ppn         (ptw_jtlb_ref_ppn        ),
  .ptw_jtlb_ref_ptr         (ptw_jtlb_ref_ptr), // wjh@pfu
  .regs_mmu_en              (regs_mmu_en             ),
  .sysmap_mmu_flg4          (sysmap_mmu_flg4         ),
  .tlboper_jtlb_asid        (tlboper_jtlb_asid       ),
  .tlboper_jtlb_asid_sel    (tlboper_jtlb_asid_sel   ),
  .tlboper_jtlb_cmp_noasid  (tlboper_jtlb_cmp_noasid ),
  .tlboper_jtlb_inv_asid    (tlboper_jtlb_inv_asid   ),
  .tlboper_jtlb_tlbwr_on    (tlboper_jtlb_tlbwr_on   ),
  .tlboper_xx_pgs           (tlboper_xx_pgs          ),
  .tlboper_xx_pgs_en        (tlboper_xx_pgs_en       ),
  .pad_sram_RME             ( pad_sram_RME           ),
  .pad_sram_RM              ( pad_sram_RM            ),
  .mmu_sv48_en              ( mmu_sv48_en            )
);


//==========================================================
// Instance PTW
//==========================================================
// &Instance("xx_mmu_ptw", "x_xx_mmu_ptw"); @78
xx_mmu_ptw  x_xx_mmu_ptw (
  .arb_ptw_grant         (arb_ptw_grant        ),
  .arb_ptw_mask          (arb_ptw_mask         ),
  .cp0_mmu_icg_en        (cp0_mmu_icg_en       ),
  .cp0_mmu_maee          (cp0_mmu_maee         ),
  .cp0_mmu_mpp           (cp0_mmu_mpp          ),
  .cp0_mmu_mprv          (cp0_mmu_mprv         ),
  .cp0_mmu_mxr           (cp0_mmu_mxr          ),
  .cp0_mmu_sum           (cp0_mmu_sum          ),
  .cp0_yy_priv_mode      (cp0_yy_priv_mode     ),
  .cpurst_b              (cpurst_b             ),
  .dutlb_ptw_wfc         (dutlb_ptw_wfc        ),
  .forever_cpuclk        (forever_cpuclk       ),
  .hpcp_mmu_cnt_en       (hpcp_mmu_cnt_en      ),
  .iutlb_ptw_wfc         (iutlb_ptw_wfc        ),
  .jtlb_ptw_asid         (jtlb_ptw_asid        ),
  .jtlb_ptw_req          (jtlb_ptw_req         ),
  .jtlb_ptw_type         (jtlb_ptw_type        ),
  .jtlb_ptw_vpn          (jtlb_ptw_vpn         ),
  .jtlb_ptw_ptr          (jtlb_ptw_ptr),       // wjh@pfu
  .jtlb_ptw_has_cmplt    (jtlb_ptw_has_cmplt), // wjh@pfu
  .pfu_ptw_va            (pfu_jtlb_va[`WK_VPN_WIDTH-1:0]),        // for va_hit wjh@pfu
  .tmq_ptw_va            (dutlb_arb_vpn[`WK_VPN_WIDTH-1:0]),
  .jtlb_xx_fifo          (jtlb_xx_fifo         ),
  .lsu_mmu_bus_error     (lsu_mmu_bus_error    ),
  .lsu_mmu_data          (lsu_mmu_data         ),
  .lsu_mmu_data_vld      (lsu_mmu_data_vld     ),
  .mmu_hpcp_jtlb_miss    (mmu_hpcp_jtlb_miss   ),
  .mmu_lsu_data_req      (mmu_lsu_data_req     ),
  .mmu_lsu_data_req_addr (mmu_lsu_data_req_addr),
  .mmu_lsu_data_req_size (mmu_lsu_data_req_size),
  .mmu_pmp_fetch3        (mmu_pmp_fetch3       ),
  .mmu_pmp_pa3           (mmu_pmp_pa3          ),
  .mmu_sysmap_pa3        (mmu_sysmap_pa3       ),
  .pad_yy_icg_scan_en    (pad_yy_icg_scan_en   ),
  .pmp_mmu_flg3          (pmp_mmu_flg3         ),
  .ptw_arb_bank_sel      (ptw_arb_bank_sel     ),
  .ptw_arb_data_din      (ptw_arb_data_din     ),
  .ptw_arb_fifo_din      (ptw_arb_fifo_din     ),
  .ptw_arb_pgs           (ptw_arb_pgs          ),
  .ptw_arb_req           (ptw_arb_req          ),
  .ptw_arb_tag_din       (ptw_arb_tag_din      ),
  .ptw_arb_vpn           (ptw_arb_vpn          ),
  .ptw_arb_mshr_full     (ptw_arb_mshr_full), // wjh@pfu
  .ptw_pfu_va_hit        (ptw_pfu_va_hit),    // wjh@pfu
  .ptw_tmq_va_hit        (ptw_tmq_va_hit),
  .ptw_jtlb_dmiss        (ptw_jtlb_dmiss       ),
  .ptw_jtlb_imiss        (ptw_jtlb_imiss       ),
  .ptw_jtlb_pmiss        (ptw_jtlb_pmiss       ),
  .ptw_jtlb_ref_acc_err  (ptw_jtlb_ref_acc_err ),
  .ptw_jtlb_ref_cmplt    (ptw_jtlb_ref_cmplt   ),
  .ptw_jtlb_ref_data_vld (ptw_jtlb_ref_data_vld),
  .ptw_jtlb_ref_flg      (ptw_jtlb_ref_flg     ),
  .ptw_jtlb_ref_pgflt    (ptw_jtlb_ref_pgflt   ),
  .ptw_jtlb_ref_pgs      (ptw_jtlb_ref_pgs     ),
  .ptw_jtlb_ref_ppn      (ptw_jtlb_ref_ppn     ),
  .ptw_jtlb_ref_ptr      (ptw_jtlb_ref_ptr), // wjh@pfu
  .ptw_refill_on         (ptw_refill_on        ),
  .ptw_top_cur_st        (ptw_top_cur_st       ),
  .ptw_top_imiss         (ptw_top_imiss        ),
  .regs_ptw_cur_asid     (regs_ptw_cur_asid    ),
  .regs_ptw_satp_ppn     (regs_ptw_satp_ppn    ),
  .sysmap_mmu_flg3       (sysmap_mmu_flg3      ),
  .sysmap_mmu_hit3       (sysmap_mmu_hit3      ),
  .tlboper_ptw_abort     (tlboper_ptw_abort    ),
  .mmu_sv48_en           (mmu_sv48_en          )
);


//==========================================================
// Instance System Map
//==========================================================
// &Force("nonport", "sysmap_mmu_hit0"); @83
// &Force("nonport", "sysmap_mmu_hit1"); @84
// &Force("nonport", "sysmap_mmu_hit2"); @85
// &Force("nonport", "sysmap_mmu_hit4"); @86

// &ConnRule(s/_y/0/); @88
// &Instance("xx_mmu_sysmap", "x_xx_mmu_sysmap_0"); @89
xx_mmu_sysmap  x_xx_mmu_sysmap_0 (
  .mmu_sysmap_pa_y  (mmu_sysmap_pa0  ),
  .sys_regs_value   (sys_regs_value  ),
  .sysmap_mmu_flg_y (sysmap_mmu_flg0 ),
  .sysmap_mmu_hit_y (sysmap_mmu_hit0 )
);

xx_mmu_sysmap  x_xx_mmu_sysmap_00 (
  .mmu_sysmap_pa_y  (mmu_sysmap_pa00  ),
  .sys_regs_value   (sys_regs_value  ),
  .sysmap_mmu_flg_y (sysmap_mmu_flg00 ),
  .sysmap_mmu_hit_y (sysmap_mmu_hit00 )
);


xx_mmu_sysmap  x_xx_mmu_sysmap_10 (
  .mmu_sysmap_pa_y  (mmu_sysmap_pa10  ),
  .sys_regs_value   (sys_regs_value  ),
  .sysmap_mmu_flg_y (sysmap_mmu_flg10 ),
  .sysmap_mmu_hit_y (sysmap_mmu_hit10 )
);

// &ConnRule(s/_y/2/); @94
// &Instance("xx_mmu_sysmap", "x_xx_mmu_sysmap_2"); @95
xx_mmu_sysmap  x_xx_mmu_sysmap_2 (
  .mmu_sysmap_pa_y  (mmu_sysmap_pa2  ),
  .sys_regs_value   (sys_regs_value  ),
  .sysmap_mmu_flg_y (sysmap_mmu_flg2 ),
  .sysmap_mmu_hit_y (sysmap_mmu_hit2 )
);


// &ConnRule(s/_y/3/); @97
// &Instance("xx_mmu_sysmap", "x_xx_mmu_sysmap_3"); @98
xx_mmu_sysmap  x_xx_mmu_sysmap_3 (
  .mmu_sysmap_pa_y  (mmu_sysmap_pa3  ),
  .sys_regs_value   (sys_regs_value  ),
  .sysmap_mmu_flg_y (sysmap_mmu_flg3 ),
  .sysmap_mmu_hit_y (sysmap_mmu_hit3 )
);


// &ConnRule(s/_y/4/); @100
// &Instance("xx_mmu_sysmap", "x_xx_mmu_sysmap_4"); @101
xx_mmu_sysmap  x_xx_mmu_sysmap_4 (
  .mmu_sysmap_pa_y  (mmu_sysmap_pa4  ),
  .sys_regs_value   (sys_regs_value  ),
  .sysmap_mmu_flg_y (sysmap_mmu_flg4 ),
  .sysmap_mmu_hit_y (sysmap_mmu_hit4 )
);

// i.e. ls_l2_ctxt_change_v lishuo@pfu
assign mmu_l2c_pfu_regs_utlb_clr = regs_utlb_clr;

// for coverage
//==========================================================
//                  Risc-V Debug zdb Begin
//==========================================================
assign mmu_dtu_debug_info[`MMU_DEBUG_INFO_WIDTH-1:0] = {iutlb_top_ref_cur_st[1:0],
                                                        dutlb_top_ref_cur_st[2:0], dutlb_top_ref_type,
                                                        tlboper_top_tlbp_cur_st[1:0], tlboper_top_tlbr_cur_st[1:0],
                                                        tlboper_top_tlbwi_cur_st[1:0], tlboper_top_tlbwr_cur_st[1:0],
                                                        tlboper_top_tlbiasid_cur_st[2:0], tlboper_top_tlbiall_cur_st,
                                                        tlboper_top_tlbiva_cur_st[3:0], tlboper_top_lsu_oper, tlboper_top_lsu_cmplt,
                                                        arb_top_cur_st[1:0], arb_top_tlboper_on, jtlb_top_cur_st[1:0],
                                                        ptw_top_cur_st[3:0], ptw_top_imiss};
//==========================================================
//                  Risc-V Debug zdb End
//==========================================================
// &ModuleEnd; @190
endmodule



