//-----------------------------------------------------------------------------
// File          : wk_cp0_iui.v
// Created       : 2024/10/01 (by David)
// Last modified : 2025/05/28 (by Qin Yubo)
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
// 2025/05/28 : Parameterized for pst_preg. (by Qin Yubo)
//-----------------------------------------------------------------------------

//#
//# Module Declaration
//# ==================
//#


// $Id: wk_cp0_iui.vp,v 1.129.10.2 2023/08/23 02:52:42 mingmin.tang Exp $
// *****************************************************************************


// &ModuleBeg; @25
module wk_cp0_iui#(
    parameter IID_WIDTH = 7,
    parameter PREG = 7//add parameter for parameterized pst_preg.@qyb20250528
)(
  biu_cp0_cmplt,
  biu_cp0_rdata,
`ifdef ADD_AIA
  aia_cp0_imsic_illegal_expt,        //for AIA by chenlili@20250521
  mip_raw,
  sip_raw,
  cp0_aia_wreg,  
`endif
  cp0_biu_op,
  cp0_biu_sel,
  cp0_biu_wdata,
  cp0_hpcp_op,
  cp0_hpcp_sel,
  cp0_hpcp_src0,
  cp0_ifu_rst_inv_done,
  cp0_iu_ex3_abnormal,
  cp0_iu_ex3_expt_vec,
  cp0_iu_ex3_expt_vld,
  cp0_iu_ex3_flush,
  cp0_iu_ex3_iid,
  cp0_iu_ex3_inst_vld,
  cp0_iu_ex3_mtval,
  cp0_iu_ex3_rslt_data,
  cp0_iu_ex3_rslt_preg,
  cp0_iu_ex3_rslt_vld,
  cp0_lsu_xx_int_b,
  cp0_mmu_tlb_all_inv,
  cp0_mret,
  cp0_rtu_xx_int_b,
  cp0_rtu_xx_vec,
  cp0_sret,
  cpurst_b,
  forever_cpuclk,
  hpcp_cp0_cmplt,
  hpcp_cp0_data,
  idu_cp0_rf_func,
  idu_cp0_rf_gateclk_sel,
  idu_cp0_rf_iid,
  idu_cp0_rf_opcode,
  idu_cp0_rf_preg,
  idu_cp0_rf_sel,
  idu_cp0_rf_src0,
  ifu_cp0_icache_inv_done,
  ifu_cp0_rst_inv_req,
  inst_lpmd_ex1_ex2,
  rtu_ck_flush_older_than_ex1,
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
  iui_top_cur_state,
  lpmd_cmplt,
  lsu_cp0_dcache_done,
  mmu_cp0_cmplt,
  mmu_cp0_tlb_done,
  pad_yy_icg_scan_en,
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
  regs_xx_icg_en,
  rtu_yy_xx_commit0,
  rtu_yy_xx_commit0_iid,
  rtu_yy_xx_dbgon,
  rtu_yy_xx_flush,
  rtu_ck_flush,
  rtu_ck_flush_iid,
//==========================================================
//                  Risc-V Debug zdb Begin
//==========================================================
  //input
  dtu_cp0_read_cmplt,
  dtu_cp0_write_cmplt,
  regs_iui_dtu_regs_sel,
  regs_iui_mmu_regs_sel,
  //output
  cp0_iu_ex3_mret,
  cp0_iu_ex3_sret,
  cp0_iu_ex3_dret,
  iui_regs_ex1_read_sel,
  iui_regs_ex2_write_sel,
  iui_regs_fsm_busy,
  iui_regs_wreg_for_dtu_hpcp
//==========================================================
//                  Risc-V Debug zdb End
//==========================================================
);

// &Ports; @26
input            biu_cp0_cmplt;          
input   [127:0]  biu_cp0_rdata;       
`ifdef ADD_AIA
input            aia_cp0_imsic_illegal_expt;        //for AIA by chenlili@20250521
input   [63 :0]  mip_raw;                           //for AIA by zhangdunbo@20260608
input   [63 :0]  sip_raw;                           //for AIA by zhangdunbo@20260608
input            cp0_aia_wreg;                      //for AIA by zhangdunbo@20260608
`endif    
input            cpurst_b;               
input            forever_cpuclk;         
input            hpcp_cp0_cmplt;         
input   [63 :0]  hpcp_cp0_data;          
input   [4  :0]  idu_cp0_rf_func;        
input            idu_cp0_rf_gateclk_sel; 
input   [IID_WIDTH - 1  :0]  idu_cp0_rf_iid;         
input   [31 :0]  idu_cp0_rf_opcode;      
input   [PREG - 1  :0]  idu_cp0_rf_preg;        
input            idu_cp0_rf_sel;         
input   [63 :0]  idu_cp0_rf_src0;        
input            ifu_cp0_icache_inv_done; 
input            ifu_cp0_rst_inv_req;    
input            lpmd_cmplt;             
input            lsu_cp0_dcache_done;    
input            mmu_cp0_cmplt;          
input            mmu_cp0_tlb_done;       
input            pad_yy_icg_scan_en;     
input            regs_iui_cfr_no_op;     
input            regs_iui_chk_vld;       
input            regs_iui_cindex_l2;     
input            regs_iui_cins_no_op;    
input            regs_iui_cskyee;        
input   [63 :0]  regs_iui_data_out;      
input            regs_iui_dca_sel;       
input            regs_iui_fs_off;        
input            regs_iui_hpcp_regs_sel; 
input            regs_iui_hpcp_scr_inv;  
input   [14 :0]  regs_iui_int_sel;       
input            regs_iui_l2_regs_sel;   
input            regs_iui_mcins;         
input   [1  :0]  regs_iui_pm;            
input   [3  :0]  regs_iui_reg_idx;       
input            regs_iui_scnt_inv;      
input            regs_iui_tee_ff;        
input            regs_iui_tee_vld;       
input            regs_iui_tsr;           
input            regs_iui_tvm;           
input            regs_iui_tw;            
input            regs_iui_ucnt_inv;      
input            regs_iui_v;             
input            regs_iui_vs_off;        
input   [63 :0]  regs_iui_wdata;         
input            regs_xx_icg_en;         
input            rtu_yy_xx_commit0;      
input   [IID_WIDTH - 1  :0]  rtu_yy_xx_commit0_iid;  
input            rtu_yy_xx_dbgon;        
input            rtu_yy_xx_flush;        
input            rtu_ck_flush;
input   [IID_WIDTH - 1  :0]  rtu_ck_flush_iid;
output  [15 :0]  cp0_biu_op;             
output           cp0_biu_sel;            
output  [63 :0]  cp0_biu_wdata;          
output  [3  :0]  cp0_hpcp_op;            
output           cp0_hpcp_sel;           
output  [63 :0]  cp0_hpcp_src0;          
output           cp0_ifu_rst_inv_done;   
output           cp0_iu_ex3_abnormal;    
output  [4  :0]  cp0_iu_ex3_expt_vec;    
output           cp0_iu_ex3_expt_vld;    
output           cp0_iu_ex3_flush;       
output  [IID_WIDTH - 1  :0]  cp0_iu_ex3_iid;         
output           cp0_iu_ex3_inst_vld;    
output  [31 :0]  cp0_iu_ex3_mtval;       
output  [63 :0]  cp0_iu_ex3_rslt_data;   
output  [PREG - 1  :0]  cp0_iu_ex3_rslt_preg;   
output           cp0_iu_ex3_rslt_vld;    
output           cp0_lsu_xx_int_b;       
output           cp0_mmu_tlb_all_inv;    
output           cp0_mret;               
output           cp0_rtu_xx_int_b;       
output  [4  :0]  cp0_rtu_xx_vec;         
output           cp0_sret;               
output           inst_lpmd_ex1_ex2;      
output           rtu_ck_flush_older_than_ex1;
output  [11 :0]  iui_regs_addr;          
output           iui_regs_csr_wr;        
output           iui_regs_csrw;          
output           iui_regs_ex3_inst_csr;  
output           iui_regs_inst_mret;     
output           iui_regs_inst_sret;     
output           iui_regs_inv_expt;      
output  [63 :0]  iui_regs_ori_src0;      
output           iui_regs_rst_inv_d;     
output           iui_regs_rst_inv_i;     
output           iui_regs_sel;           
output  [63 :0]  iui_regs_src0;          
output  [1  :0]  iui_top_cur_state;      

// &Regs; @27
reg              addr_inv;               
reg              cp0_expt_vld;           
reg              cp0_flush;              
reg     [63 :0]  cp0_rslt_reg;           
reg     [1  :0]  cur_state;              
reg              inst_csr_ex2;           
reg     [IID_WIDTH - 1  :0]  iui_ex1_iid;            
reg              iui_ex1_inst_csrrc;     
reg              iui_ex1_inst_csrrci;    
reg              iui_ex1_inst_csrrs;     
reg              iui_ex1_inst_csrrsi;    
reg              iui_ex1_inst_csrrw;     
reg              iui_ex1_inst_csrrwi;    
reg              iui_ex1_inst_mret;      
reg              iui_ex1_inst_sret;      
reg              iui_ex1_inst_wfi;       
reg     [31 :0]  iui_ex1_opcode;         
reg     [PREG - 1  :0]  iui_ex1_preg;           
reg     [63 :0]  iui_ex1_src0;           
reg              iui_flop_commit;        
reg     [4  :0]  iui_int_vec;            
reg              iui_int_vld_b;          
reg     [1  :0]  next_state;             
reg              rst_cache_inv;          
reg              rst_cache_inv_nxt;      
reg              rst_dcache_inv;         
reg              rst_dcache_inv_nxt;     
reg              rst_icache_inv;         
reg              rst_icache_inv_nxt;     
reg              rst_tlb_inv;            
reg              rst_tlb_inv_nxt;        
reg     [4  :0]  valid_int_vec;          

// &Wires; @28
wire             biu_cp0_cmplt;          
wire    [127:0]  biu_cp0_rdata;   
`ifdef ADD_AIA
wire             aia_cp0_imsic_illegal_expt;        //for AIA by chenlili@20250521
wire    [63 :0]  mip_raw;                           //for AIA by zhangdunbo@20260608
wire    [63 :0]  sip_raw;                           //for AIA by zhangdunbo@20260608
wire             cp0_aia_wreg;                      //for AIA by zhangdunbo@20260608  
`endif             
wire    [15 :0]  cp0_biu_op;             
wire             cp0_biu_sel;            
wire    [63 :0]  cp0_biu_wdata;          
wire             cp0_ex1_select;         
wire             cp0_ex2_expt_vld;       
wire             cp0_ex2_select;         
wire             cp0_ex3_select;         
wire    [3  :0]  cp0_hpcp_op;            
wire             cp0_hpcp_sel;           
wire    [63 :0]  cp0_hpcp_src0;          
wire             cp0_ifu_rst_inv_done;   
wire             cp0_inst_cmplt;         
wire             cp0_iu_ex3_abnormal;    
wire    [4  :0]  cp0_iu_ex3_expt_vec;    
wire             cp0_iu_ex3_expt_vld;    
wire             cp0_iu_ex3_flush;       
wire    [IID_WIDTH - 1  :0]  cp0_iu_ex3_iid;         
wire             cp0_iu_ex3_inst_vld;    
wire    [31 :0]  cp0_iu_ex3_mtval;       
wire    [63 :0]  cp0_iu_ex3_rslt_data;   
wire    [PREG - 1  :0]  cp0_iu_ex3_rslt_preg;   
wire             cp0_iu_ex3_rslt_vld;    
wire             cp0_lsu_xx_int_b;       
wire             cp0_mmu_tlb_all_inv;    
wire             cp0_mret;               
wire             cp0_rtu_xx_int_b;       
wire    [4  :0]  cp0_rtu_xx_vec;         
wire             cp0_select;             
wire             cp0_sret;               
wire             cpuclk;                 
wire             cpurst_b;               
wire             csr_addr_inv;           
wire    [63 :0]  csrrc_src0;             
wire    [63 :0]  csrrci_src0;            
wire    [63 :0]  csrrs_src0;             
wire    [63 :0]  csrrsi_src0;            
wire    [63 :0]  csrrw_src0;             
wire    [63 :0]  csrrwi_src0;            
wire             forever_cpuclk;         
wire             hpcp_cp0_cmplt;         
wire    [63 :0]  hpcp_cp0_data;          
wire    [4  :0]  idu_cp0_rf_func;        
wire             idu_cp0_rf_gateclk_sel; 
wire    [IID_WIDTH - 1  :0]  idu_cp0_rf_iid;         
wire    [31 :0]  idu_cp0_rf_opcode;      
wire    [PREG - 1  :0]  idu_cp0_rf_preg;        
wire             idu_cp0_rf_sel;         
wire    [63 :0]  idu_cp0_rf_src0;        
wire             ifu_cp0_icache_inv_done; 
wire             ifu_cp0_rst_inv_req;    
wire             inst_csr_ex1;           
wire             inst_csr_wr;            
wire             inst_lpmd;              
wire             inst_lpmd_ex1_ex2;      
wire             rtu_ck_flush_older_than_ex1;
wire             inst_mret_ex2;          
wire             inst_sret_ex2;          
wire             int_vld;                
wire    [11 :0]  iui_addr;               
wire             iui_clk_en;             
wire             iui_csr_hpcp;           
wire             iui_csr_inst_imm;       
wire             iui_csr_l2regs;         
wire             iui_csr_mcir;           
wire             iui_ex2_commit;         
wire             iui_flush;              
wire             iui_fs_inv;             
wire             iui_hs_inv;             
wire             iui_inst_csr;           
wire             iui_inst_csrrc;         
wire             iui_inst_csrrci;        
wire             iui_inst_csrrs;         
wire             iui_inst_csrrsi;        
wire             iui_inst_csrrw;         
wire             iui_inst_csrrwi;        
wire             iui_inst_mret;          
wire             iui_inst_ro;            
wire             iui_inst_sret;          
wire             iui_inst_wfi;           
wire             iui_m_mode;             
wire    [31 :0]  iui_opcode;             
wire    [PREG - 1  :0]  iui_preg;               
wire             iui_privilege;          
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
wire             iui_s_inv;              
wire             iui_s_mode;             
wire    [63 :0]  iui_src0;               
wire             iui_tee_inv;            
wire    [1  :0]  iui_top_cur_state;      
wire             iui_u_inv;              
wire             iui_u_mode;             
wire    [63 :0]  iui_uimm;               
wire             iui_v_mode;             
wire             iui_vs_inv;             
wire             iui_w_inv;              
wire             lpmd_cmplt;             
wire             lsu_cp0_dcache_done;    
wire             mmu_cp0_cmplt;          
wire             mmu_cp0_tlb_done;       
wire             pad_yy_icg_scan_en;     
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
wire             regs_xx_icg_en;         
wire             rf_inst_csrrc;          
wire             rf_inst_csrrci;         
wire             rf_inst_csrrs;          
wire             rf_inst_csrrsi;         
wire             rf_inst_csrrw;          
wire             rf_inst_csrrwi;         
wire             rf_inst_mret;           
wire             rf_inst_sret;           
wire             rf_inst_wfi;            
wire             rst_dtcm_en;            
wire             rst_dtcm_inv;           
wire             rst_inv_done;           
wire             rst_itcm_en;            
wire             rst_itcm_inv;           
wire             rtu_yy_xx_commit0;      
wire    [IID_WIDTH - 1  :0]  rtu_yy_xx_commit0_iid;  
wire             rtu_yy_xx_dbgon;        
wire             rtu_yy_xx_flush;        
wire             rtu_ck_flush;
wire   [IID_WIDTH - 1  :0]  rtu_ck_flush_iid;
wire             rtu_ck_flush_iid_older_than_rf_iid;
wire             rtu_ck_flush_iid_older_than_ex1_iid;

reg     [63:0]   mip_raw_f;
reg     [63:0]   sip_raw_f;
reg     [63:0]   regs_csr_rdata_for_w;

wire             aia_regs_sel;
wire             aia_ren;
wire             iui_csr_aia;
wire             regs_iui_aia_sel;

//==========================================================
//                  Risc-V Debug zdb Begin
//==========================================================
input                                   dtu_cp0_read_cmplt;
input                                   dtu_cp0_write_cmplt;
input                                   regs_iui_dtu_regs_sel;
input                                   regs_iui_mmu_regs_sel;

output                                  cp0_iu_ex3_mret;
output                                  cp0_iu_ex3_sret;
output                                  cp0_iu_ex3_dret;
output                                  iui_regs_ex1_read_sel;
output                                  iui_regs_ex2_write_sel;
output                                  iui_regs_fsm_busy;
output                                  iui_regs_wreg_for_dtu_hpcp;

//input
wire                                    dtu_cp0_read_cmplt;
wire                                    dtu_cp0_write_cmplt;
wire                                    regs_iui_dtu_regs_sel;
wire                                    regs_iui_mmu_regs_sel;
//output
wire                                    cp0_iu_ex3_mret;
wire                                    cp0_iu_ex3_sret;
wire                                    cp0_iu_ex3_dret;
wire                                    iui_regs_ex1_read_sel;
wire                                    iui_regs_ex2_write_sel;
wire                                    iui_regs_fsm_busy;
wire                                    iui_regs_wreg_for_dtu_hpcp;

reg                                     iui_ex1_inst_dret;

wire                                    cp0_dret;
wire                                    cp0_read_cmplt;
wire                                    iui_inst_dret;
wire                                    iui_inst_wr;
wire                                    rf_inst_dret;

//-------------------------------------------
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
parameter MZONEID    = 12'h7F5;
parameter MHALTCAUSE = 12'hFE0; //new
parameter MDBGINFO   = 12'hFE1;
parameter MPCFIFO    = 12'hFE2;
parameter MDBGINFO2  = 12'hFE3;

//==========================================================
//                  Risc-V Debug zdb End
//==========================================================

parameter IDLE     = 2'b00;
parameter EX1      = 2'b01;
parameter EX2      = 2'b10;
parameter EX3      = 2'b11;

parameter RST_IDLE = 1'b0;
parameter RST_WFC  = 1'b1;

//==========================================================
//                 Instance of Gated Cell  
//==========================================================

assign iui_clk_en = idu_cp0_rf_gateclk_sel 
                 || cur_state[1:0] != IDLE
                 || ifu_cp0_rst_inv_req 
                 || rst_cache_inv
                 || rtu_yy_xx_flush
                 || rtu_ck_flush;

// &Instance("gated_clk_cell", "x_iui_gated_clk"); @48
gated_clk_cell  x_iui_gated_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (cpuclk            ),
  .external_en        (1'b0              ),
  .local_en           (iui_clk_en        ),
  .module_en          (regs_xx_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect(.clk_in      (forever_cpuclk), @49
//          .external_en (1'b0), @50
//          .module_en   (regs_xx_icg_en), @51
//          .local_en    (iui_clk_en), @52
//          .clk_out     (cpuclk)); @53

//==========================================================
//                Define the CSR ADDR
// 1. Machine Level CSRs
// 2. Supervisor Level CSRs
// 3. User Level CSRs
// 4. C-SKY Extension CSRs
//==========================================================
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

`ifdef ADD_AIA
parameter MISELECT  = 12'h350; //for AIA by chenlili@20250521
parameter MIREG     = 12'h351; //for AIA by chenlili@20250521
parameter MTOPEI    = 12'h35C; //for AIA by chenlili@20250521
parameter MTOPI     = 12'hFB0; //for AIA by zhangdunbo@20260623
parameter MVIEN     = 12'h308; //for AIA by zhangdunbo@20260605
parameter MVIP      = 12'h309; //for AIA by zhangdunbo@20260605
`endif         

// Machine Trap Handling
parameter MSCRATCH  = 12'h340;
parameter MEPC      = 12'h341;
parameter MCAUSE    = 12'h342;
parameter MTVAL     = 12'h343;
parameter MIP       = 12'h344;

// Machine Protection and Translation
parameter PMPCFG0   = 12'h3A0;
parameter PMPCFG2   = 12'h3A2;
parameter PMPCFG4   = 12'h3A4;
parameter PMPCFG6   = 12'h3A6;
parameter PMPCFG8   = 12'h3A8;
parameter PMPCFG10   = 12'h3AA;
parameter PMPCFG12   = 12'h3AC;
parameter PMPCFG14   = 12'h3AE;

parameter PMPADDR0 = 12'h3B0;
parameter PMPADDR1 = 12'h3B1;
parameter PMPADDR2 = 12'h3B2;
parameter PMPADDR3 = 12'h3B3;
parameter PMPADDR4 = 12'h3B4;
parameter PMPADDR5 = 12'h3B5;
parameter PMPADDR6 = 12'h3B6;
parameter PMPADDR7 = 12'h3B7;
parameter PMPADDR8 = 12'h3B8;
parameter PMPADDR9 = 12'h3B9;
parameter PMPADDR10 = 12'h3BA;
parameter PMPADDR11 = 12'h3BB;
parameter PMPADDR12 = 12'h3BC;
parameter PMPADDR13 = 12'h3BD;
parameter PMPADDR14 = 12'h3BE;
parameter PMPADDR15 = 12'h3BF;
parameter PMPADDR16 = 12'h3C0;
parameter PMPADDR17 = 12'h3C1;
parameter PMPADDR18 = 12'h3C2;
parameter PMPADDR19 = 12'h3C3;
parameter PMPADDR20 = 12'h3C4;
parameter PMPADDR21 = 12'h3C5;
parameter PMPADDR22 = 12'h3C6;
parameter PMPADDR23 = 12'h3C7;
parameter PMPADDR24 = 12'h3C8;
parameter PMPADDR25 = 12'h3C9;
parameter PMPADDR26 = 12'h3CA;
parameter PMPADDR27 = 12'h3CB;
parameter PMPADDR28 = 12'h3CC;
parameter PMPADDR29 = 12'h3CD;
parameter PMPADDR30 = 12'h3CE;
parameter PMPADDR31 = 12'h3CF;
parameter PMPADDR32 = 12'h3D0;
parameter PMPADDR33 = 12'h3D1;
parameter PMPADDR34 = 12'h3D2;
parameter PMPADDR35 = 12'h3D3;
parameter PMPADDR36 = 12'h3D4;
parameter PMPADDR37 = 12'h3D5;
parameter PMPADDR38 = 12'h3D6;
parameter PMPADDR39 = 12'h3D7;
parameter PMPADDR40 = 12'h3D8;
parameter PMPADDR41 = 12'h3D9;
parameter PMPADDR42 = 12'h3DA;
parameter PMPADDR43 = 12'h3DB;
parameter PMPADDR44 = 12'h3DC;
parameter PMPADDR45 = 12'h3DD;
parameter PMPADDR46 = 12'h3DE;
parameter PMPADDR47 = 12'h3DF;
parameter PMPADDR48 = 12'h3E0;
parameter PMPADDR49 = 12'h3E1;
parameter PMPADDR50 = 12'h3E2;
parameter PMPADDR51 = 12'h3E3;
parameter PMPADDR52 = 12'h3E4;
parameter PMPADDR53 = 12'h3E5;
parameter PMPADDR54 = 12'h3E6;
parameter PMPADDR55 = 12'h3E7;
parameter PMPADDR56 = 12'h3E8;
parameter PMPADDR57 = 12'h3E9;
parameter PMPADDR58 = 12'h3EA;
parameter PMPADDR59 = 12'h3EB;
parameter PMPADDR60 = 12'h3EC;
parameter PMPADDR61 = 12'h3ED;
parameter PMPADDR62 = 12'h3EE;
parameter PMPADDR63 = 12'h3EF;


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

`ifdef ADD_AIA
parameter SISELECT  = 12'h150; //for AIA by chenlili@20250521
parameter SIREG     = 12'h151; //for AIA by chenlili@20250521
parameter STOPEI    = 12'h15C; //for AIA by chenlili@20250521
parameter STOPI     = 12'hDB0; //for AIA by zhangdunbo@20260623
`endif   

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
parameter MCNTINTEN = 12'h7CA;
parameter MCNTOF    = 12'h7CB;
parameter MHINT2    = 12'h7CC;
parameter MHINT3    = 12'h7CD;
parameter MHINT4    = 12'h7CE;

parameter MSMPR     = 12'h7F3;
parameter MTEECFG   = 12'h7F4;

// Processor Data Extension; M-Mode
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

// Supervisor Counters/Timers
parameter SCYCLE    = 12'h5E0;
parameter SINSTRET  = 12'h5E2;
parameter SHPMCNT3  = 12'h5E3;
parameter SHPMCNT4  = 12'h5E4;
parameter SHPMCNT5  = 12'h5E5;
parameter SHPMCNT6  = 12'h5E6;
parameter SHPMCNT7  = 12'h5E7;
parameter SHPMCNT8  = 12'h5E8;
parameter SHPMCNT9  = 12'h5E9;
parameter SHPMCNT10 = 12'h5EA;
parameter SHPMCNT11 = 12'h5EB;
parameter SHPMCNT12 = 12'h5EC;
parameter SHPMCNT13 = 12'h5ED;
parameter SHPMCNT14 = 12'h5EE;
parameter SHPMCNT15 = 12'h5EF;
parameter SHPMCNT16 = 12'h5F0;
parameter SHPMCNT17 = 12'h5F1;
parameter SHPMCNT18 = 12'h5F2;
parameter SHPMCNT19 = 12'h5F3;
parameter SHPMCNT20 = 12'h5F4;
parameter SHPMCNT21 = 12'h5F5;
parameter SHPMCNT22 = 12'h5F6;
parameter SHPMCNT23 = 12'h5F7;
parameter SHPMCNT24 = 12'h5F8;
parameter SHPMCNT25 = 12'h5F9;
parameter SHPMCNT26 = 12'h5FA;
parameter SHPMCNT27 = 12'h5FB;
parameter SHPMCNT28 = 12'h5FC;
parameter SHPMCNT29 = 12'h5FD;
parameter SHPMCNT30 = 12'h5FE;
parameter SHPMCNT31 = 12'h5FF;

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
//                Handling the CP0 operations
//==========================================================
//CP0 need to flop insctuction type signals and source operands
//for use of both ex1 and ex2 stages
// CP0 funcs from idu rf stage
// WFI:    5'b01001
// SRET:   5'b01000
// MRET:   5'b01010
// DRET:   5'b01011
// CSRRW:  5'b10000
// CSRRS:  5'b10001
// CSRRC:  5'b10010
// CSRRWI: 5'b10011
// CSRRSI: 5'b10100
// CSRRCI: 5'b10101
//==========================================================
//                  Risc-V Debug zdb Begin
//==========================================================
assign rf_inst_wfi    = idu_cp0_rf_func[3:0] == 4'b1001 &  ~rtu_yy_xx_dbgon;
assign rf_inst_sret   = idu_cp0_rf_func[3:0] == 4'b1000 &  ~rtu_yy_xx_dbgon ;
assign rf_inst_mret   = idu_cp0_rf_func[3:0] == 4'b1010 &  ~rtu_yy_xx_dbgon;
assign rf_inst_dret   = idu_cp0_rf_func[3:0] == 4'b1011 &  rtu_yy_xx_dbgon;
//==========================================================
//                  Risc-V Debug zdb End
//==========================================================
assign rf_inst_csrrw  = idu_cp0_rf_func[4] &&  idu_cp0_rf_func[2:0] == 3'b000;
assign rf_inst_csrrs  = idu_cp0_rf_func[4] &&  idu_cp0_rf_func[2:0] == 3'b001;
assign rf_inst_csrrc  = idu_cp0_rf_func[4] &&  idu_cp0_rf_func[2:0] == 3'b010;
assign rf_inst_csrrwi = idu_cp0_rf_func[4] &&  idu_cp0_rf_func[2:0] == 3'b011;
assign rf_inst_csrrsi = idu_cp0_rf_func[4] &&  idu_cp0_rf_func[2:0] == 3'b100;
assign rf_inst_csrrci = idu_cp0_rf_func[4] &&  idu_cp0_rf_func[2:0] == 3'b101;

always @(posedge cpuclk or negedge cpurst_b)
begin
  if(!cpurst_b) begin
    iui_ex1_inst_wfi      <= 1'b0; 
    iui_ex1_inst_sret     <= 1'b0; 
    iui_ex1_inst_mret     <= 1'b0; 
    iui_ex1_inst_dret     <= 1'b0; // Risc-V Debug zdb
    iui_ex1_inst_csrrw    <= 1'b0; 
    iui_ex1_inst_csrrs    <= 1'b0; 
    iui_ex1_inst_csrrc    <= 1'b0; 
    iui_ex1_inst_csrrwi   <= 1'b0; 
    iui_ex1_inst_csrrsi   <= 1'b0; 
    iui_ex1_inst_csrrci   <= 1'b0; 
    iui_ex1_iid[IID_WIDTH - 1:0]      <= {(IID_WIDTH-1){1'b0}}; 
    iui_ex1_opcode[31:0]  <= 32'b0; 
    iui_ex1_src0[63:0]    <= 64'b0;
    iui_ex1_preg[PREG - 1:0]     <= {PREG{1'b0}}; 
  end
  else if(idu_cp0_rf_gateclk_sel) begin
    iui_ex1_inst_wfi      <= rf_inst_wfi; 
    iui_ex1_inst_sret     <= rf_inst_sret; 
    iui_ex1_inst_mret     <= rf_inst_mret;
    iui_ex1_inst_dret     <= rf_inst_dret; // Risc-V Debug zdb
    iui_ex1_inst_csrrw    <= rf_inst_csrrw; 
    iui_ex1_inst_csrrs    <= rf_inst_csrrs; 
    iui_ex1_inst_csrrc    <= rf_inst_csrrc; 
    iui_ex1_inst_csrrwi   <= rf_inst_csrrwi; 
    iui_ex1_inst_csrrsi   <= rf_inst_csrrsi; 
    iui_ex1_inst_csrrci   <= rf_inst_csrrci; 
    iui_ex1_iid[IID_WIDTH - 1:0]      <= idu_cp0_rf_iid[IID_WIDTH - 1:0]; 
    iui_ex1_opcode[31:0]  <= idu_cp0_rf_opcode[31:0]; 
    iui_ex1_src0[63:0]    <= idu_cp0_rf_src0[63:0];
    iui_ex1_preg[PREG - 1:0]     <= idu_cp0_rf_preg[PREG - 1:0]; 
  end
  else begin
    iui_ex1_inst_wfi      <= iui_ex1_inst_wfi; 
    iui_ex1_inst_sret     <= iui_ex1_inst_sret; 
    iui_ex1_inst_mret     <= iui_ex1_inst_mret;
    iui_ex1_inst_dret     <= iui_ex1_inst_dret; // Risc-V Debug zdb 
    iui_ex1_inst_csrrw    <= iui_ex1_inst_csrrw; 
    iui_ex1_inst_csrrs    <= iui_ex1_inst_csrrs; 
    iui_ex1_inst_csrrc    <= iui_ex1_inst_csrrc; 
    iui_ex1_inst_csrrwi   <= iui_ex1_inst_csrrwi; 
    iui_ex1_inst_csrrsi   <= iui_ex1_inst_csrrsi; 
    iui_ex1_inst_csrrci   <= iui_ex1_inst_csrrci; 
    iui_ex1_iid[IID_WIDTH - 1:0]      <= iui_ex1_iid[IID_WIDTH - 1:0]; 
    iui_ex1_opcode[31:0]  <= iui_ex1_opcode[31:0]; 
    iui_ex1_src0[63:0]    <= iui_ex1_src0[63:0];
    iui_ex1_preg[PREG - 1:0]     <= iui_ex1_preg[PREG - 1:0]; 
  end
end

assign iui_inst_wfi     = iui_ex1_inst_wfi; 
assign iui_inst_sret    = iui_ex1_inst_sret; 
assign iui_inst_mret    = iui_ex1_inst_mret;
assign iui_inst_dret    = iui_ex1_inst_dret; // Risc-V Debug zdb  
assign iui_inst_csrrw   = iui_ex1_inst_csrrw; 
assign iui_inst_csrrs   = iui_ex1_inst_csrrs; 
assign iui_inst_csrrc   = iui_ex1_inst_csrrc; 
assign iui_inst_csrrwi  = iui_ex1_inst_csrrwi; 
assign iui_inst_csrrsi  = iui_ex1_inst_csrrsi; 
assign iui_inst_csrrci  = iui_ex1_inst_csrrci; 
assign iui_opcode[31:0] = iui_ex1_opcode[31:0]; 
assign iui_preg[PREG - 1:0]    = iui_ex1_preg[PREG - 1:0]; 
assign iui_src0[63:0]   = iui_ex1_src0[63:0];
assign iui_addr[11:0]   = iui_ex1_opcode[31:20];
assign iui_uimm[63:0]   = {59'b0, iui_ex1_opcode[19:15]};

assign iui_inst_csr     = iui_inst_csrrw  || iui_inst_csrrs  || iui_inst_csrrc
                       || iui_inst_csrrwi || iui_inst_csrrsi || iui_inst_csrrci;
assign iui_inst_ro      = (iui_inst_csrrs  || iui_inst_csrrc 
                        || iui_inst_csrrsi || iui_inst_csrrci)
                        && iui_uimm[4:0] == 5'b0;

//==========================================================
//                Qualify CSR Addr
//==========================================================
// &CombBeg; @434
always @( iui_addr[11:0]
      or  rtu_yy_xx_dbgon)
begin
  addr_inv = 1'b1; 
  casez(iui_addr[11:0])
    MVENDORID : addr_inv = 1'b0; 
    MARCHID   : addr_inv = 1'b0; 
    MIMPID    : addr_inv = 1'b0; 
    MHARTID   : addr_inv = 1'b0;

    MSTATUS   : addr_inv = 1'b0; 
    MISA      : addr_inv = 1'b0; 
    MEDELEG   : addr_inv = 1'b0; 
    MIDELEG   : addr_inv = 1'b0; 
    MIE       : addr_inv = 1'b0; 
    MTVEC     : addr_inv = 1'b0; 
    MCNTEN    : addr_inv = 1'b0; 

    MSCRATCH  : addr_inv = 1'b0; 
    MEPC      : addr_inv = 1'b0; 
    MCAUSE    : addr_inv = 1'b0; 
    MTVAL     : addr_inv = 1'b0; 
    MIP       : addr_inv = 1'b0; 

    `ifdef ADD_AIA
    MISELECT  : addr_inv = 1'b0; //for AIA by chenlili@20250521
    MIREG     : addr_inv = 1'b0; //for AIA by chenlili@20250521
    MTOPEI    : addr_inv = 1'b0; //for AIA by chenlili@20250521
    MTOPI     : addr_inv = 1'b0; //for AIA by zhangdunbo@20260623
    MVIEN     : addr_inv = 1'b0; //for AIA by zhangdunbo@20260605
    MVIP      : addr_inv = 1'b0; //for AIA by zhangdunbo@20260605
    `endif   

    PMPCFG0   : addr_inv = 1'b0;
    PMPADDR0  : addr_inv = 1'b0;
    PMPADDR1  : addr_inv = 1'b0;
    PMPADDR2  : addr_inv = 1'b0;
    PMPADDR3  : addr_inv = 1'b0;
    PMPADDR4  : addr_inv = 1'b0;
    PMPADDR5  : addr_inv = 1'b0;
    PMPADDR6  : addr_inv = 1'b0;
    PMPADDR7  : addr_inv = 1'b0;
    PMPCFG2   : addr_inv = 1'b0;
    PMPADDR8  : addr_inv = 1'b0;
    PMPADDR9  : addr_inv = 1'b0;
    PMPADDR10 : addr_inv = 1'b0;
    PMPADDR11 : addr_inv = 1'b0;
    PMPADDR12 : addr_inv = 1'b0;
    PMPADDR13 : addr_inv = 1'b0;
    PMPADDR14 : addr_inv = 1'b0;
    PMPADDR15 : addr_inv = 1'b0;

    PMPCFG4   : addr_inv = 1'b0;
    PMPADDR16  : addr_inv = 1'b0;
    PMPADDR17  : addr_inv = 1'b0;
    PMPADDR18  : addr_inv = 1'b0;
    PMPADDR19  : addr_inv = 1'b0;
    PMPADDR20  : addr_inv = 1'b0;
    PMPADDR21  : addr_inv = 1'b0;
    PMPADDR22  : addr_inv = 1'b0;
    PMPADDR23  : addr_inv = 1'b0;
    PMPCFG6   : addr_inv = 1'b0;
    PMPADDR24  : addr_inv = 1'b0;
    PMPADDR25  : addr_inv = 1'b0;
    PMPADDR26 : addr_inv = 1'b0;
    PMPADDR27 : addr_inv = 1'b0;
    PMPADDR28 : addr_inv = 1'b0;
    PMPADDR29 : addr_inv = 1'b0;
    PMPADDR30 : addr_inv = 1'b0;
    PMPADDR31 : addr_inv = 1'b0;

    PMPCFG8   : addr_inv = 1'b0;
    PMPADDR32  : addr_inv = 1'b0;
    PMPADDR33  : addr_inv = 1'b0;
    PMPADDR34  : addr_inv = 1'b0;
    PMPADDR35  : addr_inv = 1'b0;
    PMPADDR36  : addr_inv = 1'b0;
    PMPADDR37  : addr_inv = 1'b0;
    PMPADDR38  : addr_inv = 1'b0;
    PMPADDR39  : addr_inv = 1'b0;
    PMPCFG10   : addr_inv = 1'b0;
    PMPADDR40  : addr_inv = 1'b0;
    PMPADDR41  : addr_inv = 1'b0;
    PMPADDR42 : addr_inv = 1'b0;
    PMPADDR43 : addr_inv = 1'b0;
    PMPADDR44 : addr_inv = 1'b0;
    PMPADDR45 : addr_inv = 1'b0;
    PMPADDR46 : addr_inv = 1'b0;
    PMPADDR47 : addr_inv = 1'b0;

    PMPCFG12   : addr_inv = 1'b0;
    PMPADDR48  : addr_inv = 1'b0;
    PMPADDR49  : addr_inv = 1'b0;
    PMPADDR50  : addr_inv = 1'b0;
    PMPADDR51  : addr_inv = 1'b0;
    PMPADDR52  : addr_inv = 1'b0;
    PMPADDR53  : addr_inv = 1'b0;
    PMPADDR54  : addr_inv = 1'b0;
    PMPADDR55  : addr_inv = 1'b0;
    PMPCFG14   : addr_inv = 1'b0;
    PMPADDR56  : addr_inv = 1'b0;
    PMPADDR57  : addr_inv = 1'b0;
    PMPADDR58 : addr_inv = 1'b0;
    PMPADDR59 : addr_inv = 1'b0;
    PMPADDR60 : addr_inv = 1'b0;
    PMPADDR61 : addr_inv = 1'b0;
    PMPADDR62 : addr_inv = 1'b0;
    PMPADDR63 : addr_inv = 1'b0;


    MCYCLE    : addr_inv = 1'b0;
    MINSTRET  : addr_inv = 1'b0;
    MHPMCNT3  : addr_inv = 1'b0;
    MHPMCNT4  : addr_inv = 1'b0;
    MHPMCNT5  : addr_inv = 1'b0;
    MHPMCNT6  : addr_inv = 1'b0;
    MHPMCNT7  : addr_inv = 1'b0;
    MHPMCNT8  : addr_inv = 1'b0;
    MHPMCNT9  : addr_inv = 1'b0;
    MHPMCNT10 : addr_inv = 1'b0;
    MHPMCNT11 : addr_inv = 1'b0;
    MHPMCNT12 : addr_inv = 1'b0;
    MHPMCNT13 : addr_inv = 1'b0;
    MHPMCNT14 : addr_inv = 1'b0;
    MHPMCNT15 : addr_inv = 1'b0;
    MHPMCNT16 : addr_inv = 1'b0;
    MHPMCNT17 : addr_inv = 1'b0;
    MHPMCNT18 : addr_inv = 1'b0;
    MHPMCNT19 : addr_inv = 1'b0;
    MHPMCNT20 : addr_inv = 1'b0;
    MHPMCNT21 : addr_inv = 1'b0;
    MHPMCNT22 : addr_inv = 1'b0;
    MHPMCNT23 : addr_inv = 1'b0;
    MHPMCNT24 : addr_inv = 1'b0;
    MHPMCNT25 : addr_inv = 1'b0;
    MHPMCNT26 : addr_inv = 1'b0;
    MHPMCNT27 : addr_inv = 1'b0;
    MHPMCNT28 : addr_inv = 1'b0;
    MHPMCNT29 : addr_inv = 1'b0;
    MHPMCNT30 : addr_inv = 1'b0;
    MHPMCNT31 : addr_inv = 1'b0;

    // M-mode Custom
    // 0x7C0-0x7FF
    12'b0111_11??_????: addr_inv = 1'b0;
    // 0xBC0-0xBFF
    12'b1011_11??_????: addr_inv = 1'b0;
    // 0xFC0-0xFFF
    12'b1111_11??_????: addr_inv = 1'b0;

    // S-mode Custom
    // 0x5C0-0x5FF
    12'b0101_11??_????: addr_inv = 1'b0;
    // 0x9C0-0x9FF
    12'b1001_11??_????: addr_inv = 1'b0;
    // 0xDC0-0xDFF
    12'b1101_11??_????: addr_inv = 1'b0;

    // U-mode Custom
    // 0x800-0x8FF
    12'b1000_????_????: addr_inv = 1'b0;
    // 0xCC0-0xCFF
    12'b1100_11??_????: addr_inv = 1'b0;

    //MHPMCR    : addr_inv = 1'b0;
    //MHPMSP    : addr_inv = 1'b0;
    //MHPMEP    : addr_inv = 1'b0;
    MCNTIHBT  : addr_inv = 1'b0;
    MHPMEVT3  : addr_inv = 1'b0;
    MHPMEVT4  : addr_inv = 1'b0;
    MHPMEVT5  : addr_inv = 1'b0;
    MHPMEVT6  : addr_inv = 1'b0;
    MHPMEVT7  : addr_inv = 1'b0;
    MHPMEVT8  : addr_inv = 1'b0;
    MHPMEVT9  : addr_inv = 1'b0;
    MHPMEVT10 : addr_inv = 1'b0;
    MHPMEVT11 : addr_inv = 1'b0;
    MHPMEVT12 : addr_inv = 1'b0;
    MHPMEVT13 : addr_inv = 1'b0;
    MHPMEVT14 : addr_inv = 1'b0;
    MHPMEVT15 : addr_inv = 1'b0;
    MHPMEVT16 : addr_inv = 1'b0;
    MHPMEVT17 : addr_inv = 1'b0;
    MHPMEVT18 : addr_inv = 1'b0;
    MHPMEVT19 : addr_inv = 1'b0;
    MHPMEVT20 : addr_inv = 1'b0;
    MHPMEVT21 : addr_inv = 1'b0;
    MHPMEVT22 : addr_inv = 1'b0;
    MHPMEVT23 : addr_inv = 1'b0;
    MHPMEVT24 : addr_inv = 1'b0;
    MHPMEVT25 : addr_inv = 1'b0;
    MHPMEVT26 : addr_inv = 1'b0;
    MHPMEVT27 : addr_inv = 1'b0;
    MHPMEVT28 : addr_inv = 1'b0;
    MHPMEVT29 : addr_inv = 1'b0;
    MHPMEVT30 : addr_inv = 1'b0;
    MHPMEVT31 : addr_inv = 1'b0;

    SSTATUS   : addr_inv = 1'b0;
    SIE       : addr_inv = 1'b0;
    STVEC     : addr_inv = 1'b0;
    SCNTEN    : addr_inv = 1'b0;

    //SCYCLE    : addr_inv = 1'b0;
    //SINSTRET  : addr_inv = 1'b0;
    //SHPMCNT3  : addr_inv = 1'b0;
    //SHPMCNT4  : addr_inv = 1'b0;
    //SHPMCNT5  : addr_inv = 1'b0;
    //SHPMCNT6  : addr_inv = 1'b0;
    //SHPMCNT7  : addr_inv = 1'b0;
    //SHPMCNT8  : addr_inv = 1'b0;
    //SHPMCNT9  : addr_inv = 1'b0;
    //SHPMCNT10 : addr_inv = 1'b0;
    //SHPMCNT11 : addr_inv = 1'b0;
    //SHPMCNT12 : addr_inv = 1'b0;
    //SHPMCNT13 : addr_inv = 1'b0;
    //SHPMCNT14 : addr_inv = 1'b0;
    //SHPMCNT15 : addr_inv = 1'b0;
    //SHPMCNT16 : addr_inv = 1'b0;
    //SHPMCNT17 : addr_inv = 1'b0;
    //SHPMCNT18 : addr_inv = 1'b0;
    //SHPMCNT19 : addr_inv = 1'b0;
    //SHPMCNT20 : addr_inv = 1'b0;
    //SHPMCNT21 : addr_inv = 1'b0;
    //SHPMCNT22 : addr_inv = 1'b0;
    //SHPMCNT23 : addr_inv = 1'b0;
    //SHPMCNT24 : addr_inv = 1'b0;
    //SHPMCNT25 : addr_inv = 1'b0;
    //SHPMCNT26 : addr_inv = 1'b0;
    //SHPMCNT27 : addr_inv = 1'b0;
    //SHPMCNT28 : addr_inv = 1'b0;
    //SHPMCNT29 : addr_inv = 1'b0;
    //SHPMCNT30 : addr_inv = 1'b0;
    //SHPMCNT31 : addr_inv = 1'b0;

    SSCRATCH  : addr_inv = 1'b0;
    SEPC      : addr_inv = 1'b0;
    SCAUSE    : addr_inv = 1'b0;
    STVAL     : addr_inv = 1'b0;
    SIP       : addr_inv = 1'b0;

    `ifdef ADD_AIA
    SISELECT  : addr_inv = 1'b0; //for AIA by chenlili@20250521
    SIREG     : addr_inv = 1'b0; //for AIA by chenlili@20250521
    STOPEI    : addr_inv = 1'b0; //for AIA by chenlili@20250521
    STOPI     : addr_inv = 1'b0; //for AIA by zhangdunbo@20260623
    `endif   

    SATP      : addr_inv = 1'b0;

    FFLAGS    : addr_inv = 1'b0;
    FRM       : addr_inv = 1'b0;
    FCSR      : addr_inv = 1'b0;
    VSTART    : addr_inv = 1'b0;
    VXSAT     : addr_inv = 1'b0;
    VXRM      : addr_inv = 1'b0;
    VCSR      : addr_inv = 1'b0;

    CYCLE     : addr_inv = 1'b0;
    TIME_CSR  : addr_inv = 1'b0;
    INSTRET   : addr_inv = 1'b0;
    HPMCNT3   : addr_inv = 1'b0;
    HPMCNT4   : addr_inv = 1'b0;
    HPMCNT5   : addr_inv = 1'b0;
    HPMCNT6   : addr_inv = 1'b0;
    HPMCNT7   : addr_inv = 1'b0;
    HPMCNT8   : addr_inv = 1'b0;
    HPMCNT9   : addr_inv = 1'b0;
    HPMCNT10  : addr_inv = 1'b0;
    HPMCNT11  : addr_inv = 1'b0;
    HPMCNT12  : addr_inv = 1'b0;
    HPMCNT13  : addr_inv = 1'b0;
    HPMCNT14  : addr_inv = 1'b0;
    HPMCNT15  : addr_inv = 1'b0;
    HPMCNT16  : addr_inv = 1'b0;
    HPMCNT17  : addr_inv = 1'b0;
    HPMCNT18  : addr_inv = 1'b0;
    HPMCNT19  : addr_inv = 1'b0;
    HPMCNT20  : addr_inv = 1'b0;
    HPMCNT21  : addr_inv = 1'b0;
    HPMCNT22  : addr_inv = 1'b0;
    HPMCNT23  : addr_inv = 1'b0;
    HPMCNT24  : addr_inv = 1'b0;
    HPMCNT25  : addr_inv = 1'b0;
    HPMCNT26  : addr_inv = 1'b0;
    HPMCNT27  : addr_inv = 1'b0;
    HPMCNT28  : addr_inv = 1'b0;
    HPMCNT29  : addr_inv = 1'b0;
    HPMCNT30  : addr_inv = 1'b0;
    HPMCNT31  : addr_inv = 1'b0;

    VL        : addr_inv = 1'b0;
    VTYPE     : addr_inv = 1'b0;
    VLENB     : addr_inv = 1'b0;

    //MXSTATUS  : addr_inv = 1'b0;
    //MHCR      : addr_inv = 1'b0;
    //MCOR      : addr_inv = 1'b0;
    //MCCR2     : addr_inv = 1'b0;
    //MCER2     : addr_inv = 1'b0;
    //MHINT     : addr_inv = 1'b0;
    //MRVBR     : addr_inv = 1'b0;
    //MCER      : addr_inv = 1'b0;
    //MCNTWEN   : addr_inv = 1'b0;
    //MCNTINTEN : addr_inv = 1'b0;
    //MCNTOF    : addr_inv = 1'b0;
    //MHINT2    : addr_inv = 1'b0;
    //MHINT3    : addr_inv = 1'b0;
    //MHINT4    : addr_inv = 1'b0;

    //MSMPR     : addr_inv = 1'b0;


    //MCINS     : addr_inv = 1'b0;
    //MCINDEX   : addr_inv = 1'b0;
    //MCDATA0   : addr_inv = 1'b0;
    //MCDATA1   : addr_inv = 1'b0;
    //MEICR     : addr_inv = 1'b0;
    //MEICR2    : addr_inv = 1'b0;

    //MCPUID    : addr_inv = 1'b0;
    //MAPBADDR  : addr_inv = 1'b0;


    //SXSTATUS  : addr_inv = 1'b0;
    //SHCR      : addr_inv = 1'b0;
    //SCER2     : addr_inv = 1'b0;
    //SCER      : addr_inv = 1'b0;
    //SCNTINTEN : addr_inv = 1'b0;
    //SCNTOF    : addr_inv = 1'b0;
    //SHINT     : addr_inv = 1'b0;
    //SHINT2    : addr_inv = 1'b0;
          
    //SCNTIHBT  : addr_inv = 1'b0;
    //SHPMCR    : addr_inv = 1'b0;
    //SHPMSP    : addr_inv = 1'b0;
    //SHPMEP    : addr_inv = 1'b0;

    //SMIR      : addr_inv = 1'b0;
    //SMEL      : addr_inv = 1'b0;
    //SMEH      : addr_inv = 1'b0;
    //SMCIR     : addr_inv = 1'b0;

    //FXCR      : addr_inv = 1'b0;
//==========================================================
//                  Risc-V Debug zdb Begin
//==========================================================
    SCONTEXT    : addr_inv = 1'b0;
    TSELECT     : addr_inv = 1'b0;
    TDATA1      : addr_inv = 1'b0;
    TDATA2      : addr_inv = 1'b0;
    TDATA3      : addr_inv = 1'b0;
    TINFO       : addr_inv = 1'b0;
    TCONTROL    : addr_inv = 1'b0;
    MCONTEXT    : addr_inv = 1'b0;
    MSCONTEXT   : addr_inv = 1'b0;

    DCSR        : addr_inv = ~rtu_yy_xx_dbgon;
    DPC         : addr_inv = ~rtu_yy_xx_dbgon;
    DSCRATCH0   : addr_inv = ~rtu_yy_xx_dbgon;
    DSCRATCH1   : addr_inv = ~rtu_yy_xx_dbgon;
//==========================================================
//                  Risc-V Debug zdb End
//==========================================================
    default   : addr_inv = 1'b1; 
  endcase
// &CombEnd; @720
end
assign csr_addr_inv = iui_inst_csr && addr_inv;

//==========================================================
//              Commit signal to select cp0
//==========================================================
assign iui_ex2_commit = rtu_yy_xx_commit0
                        && (rtu_yy_xx_commit0_iid[IID_WIDTH - 1:0]
                            == iui_ex1_iid[IID_WIDTH - 1:0]);

always @(posedge cpuclk or negedge cpurst_b)
begin
  if(!cpurst_b)
    iui_flop_commit <= 1'b0; 
  else if(cur_state[1:0] == EX2)
    iui_flop_commit <= iui_ex2_commit;
  else
    iui_flop_commit <= iui_flop_commit;
end

//==========================================================
//              FSM of CP0 iui control logic
//==========================================================
// State Description:
// IDLE : wait for cp0 insctuction
// EX1  : first cycle in which write value to psr and regs
// EX2  : wait for biu align or no operation (if possible)
//        complete cp0 insctuction
// EX3  : request cbus/rbus
wk_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH))
x_rtu_ck_flush_iid_compare_rf_iid (
  .x_iid0         (rtu_ck_flush_iid[IID_WIDTH-1:0]    ),
  .x_iid0_older   (rtu_ck_flush_iid_older_than_rf_iid ),
  .x_iid1         (idu_cp0_rf_iid[IID_WIDTH-1:0]      )
);
wk_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH))
x_rtu_ck_flush_iid_compare_ex1_iid (
  .x_iid0         (rtu_ck_flush_iid[IID_WIDTH-1:0]    ),
  .x_iid0_older   (rtu_ck_flush_iid_older_than_ex1_iid),
  .x_iid1         (iui_ex1_iid[IID_WIDTH-1:0]         )
);
assign  rtu_ck_flush_older_than_ex1 = rtu_ck_flush_iid_older_than_ex1_iid;
always @(posedge cpuclk or negedge cpurst_b)
begin
  if(!cpurst_b)
    cur_state[1:0] <= IDLE;
  else if(rtu_yy_xx_flush)
    cur_state[1:0] <= IDLE;
  else if(idu_cp0_rf_sel && rtu_ck_flush && rtu_ck_flush_iid_older_than_rf_iid)  //ck_flush younger rf->ex1, ck_flush@LTL
    cur_state[1:0] <= IDLE;
  else if(cur_state[1:0]==EX1 && rtu_ck_flush && rtu_ck_flush_iid_older_than_ex1_iid) //ck_flush younger ex1->ex2, ck_flush@LTL
    cur_state[1:0] <= IDLE;
  else if(cur_state[1:0]==EX2 && rtu_ck_flush && rtu_ck_flush_iid_older_than_ex1_iid) //ck_flush younger ex2->ex3, ck_flush@LTL
    cur_state[1:0] <= IDLE;    
  else
    cur_state[1:0] <= next_state[1:0];
end

// &CombBeg; @760
always @( cur_state[1:0]
       or idu_cp0_rf_sel
       or cp0_read_cmplt
       or cp0_inst_cmplt)
begin
  case(cur_state[1:0])
  IDLE  : if(idu_cp0_rf_sel)
            next_state[1:0] = EX1;
          else
            next_state[1:0] = IDLE;
//==========================================================
//                  Risc-V Debug zdb Begin
//==========================================================
  EX1   : if(cp0_read_cmplt)
            next_state[1:0] = EX2;
          else
            next_state[1:0] = EX1;
//==========================================================
//                  Risc-V Debug zdb End
//==========================================================
  EX2   : if(cp0_inst_cmplt)
            next_state[1:0] = EX3;
          else
            next_state[1:0] = EX2;
  EX3   :   next_state[1:0] = IDLE;
  default : next_state[1:0] = IDLE;
  endcase
// &CombEnd; @774
end

//-------------------control signal by iui FSM-------------
//EX1 stage select
assign cp0_ex1_select = (cur_state[1:0] == EX1) && !(rtu_ck_flush && rtu_ck_flush_iid_older_than_ex1_iid);// && iui_ex1_commit;
//EX2 stage select
assign cp0_ex2_select = (cur_state[1:0] == EX2) && iui_ex2_commit;
//EX3 stage select
assign cp0_ex3_select = (cur_state[1:0] == EX3) && !(rtu_ck_flush && rtu_ck_flush_iid_older_than_ex1_iid);  //ck_flush@LTL

assign iui_top_cur_state[1:0] = cur_state[1:0];
//cp0 select
// //&Force ("output", "cp0_select"); @786
assign cp0_select     = cp0_ex1_select
                     || cp0_ex2_select
                     || cp0_ex3_select && iui_flop_commit;
//cp0 rbus request:only request rbus when current instruction can
//                 be completed in EX2  state.
assign cp0_iu_ex3_inst_vld = cp0_ex3_select;
//complete signal to idu: release barriered insctuction
//assign iui_ex_cmplt        = cp0_ex3_select;

//==========================================================
//              FSM of reset cache inv cctl logic
//==========================================================
always @(posedge cpuclk or negedge cpurst_b)
begin
  if(!cpurst_b)
      rst_cache_inv <= RST_IDLE;
  else
      rst_cache_inv <= rst_cache_inv_nxt;
end

// &CombBeg; @807
always @( rst_cache_inv
       or rst_inv_done
       or ifu_cp0_rst_inv_req)
begin
case(rst_cache_inv)
  RST_IDLE:
  begin
    if(ifu_cp0_rst_inv_req)
      rst_cache_inv_nxt = RST_WFC;
    else
      rst_cache_inv_nxt = RST_IDLE;
  end
  RST_WFC:
  begin
    if(rst_inv_done)
      rst_cache_inv_nxt = RST_IDLE;
    else
      rst_cache_inv_nxt = RST_WFC;
  end
  default:
  begin
    rst_cache_inv_nxt = RST_IDLE;
  end
endcase
// &CombEnd; @828
end

always @(posedge cpuclk or negedge cpurst_b)
begin
  if(!cpurst_b)
    rst_icache_inv <= RST_IDLE;
  else
    rst_icache_inv <= rst_icache_inv_nxt;
end

// &CombBeg; @838
always @( rst_icache_inv
       or ifu_cp0_icache_inv_done
       or ifu_cp0_rst_inv_req)
begin
case(rst_icache_inv)
  RST_IDLE:
  begin
    if(ifu_cp0_rst_inv_req)
      rst_icache_inv_nxt = RST_WFC;
    else
      rst_icache_inv_nxt = RST_IDLE;
  end
  RST_WFC:
  begin
    if(ifu_cp0_icache_inv_done)
      rst_icache_inv_nxt = RST_IDLE;
    else
      rst_icache_inv_nxt = RST_WFC;
  end
  default:
  begin
    rst_icache_inv_nxt = RST_IDLE;
  end
endcase
// &CombEnd; @859
end

always @(posedge cpuclk or negedge cpurst_b)
begin
  if(!cpurst_b)
    rst_dcache_inv <= RST_IDLE;
  else
    rst_dcache_inv <= rst_dcache_inv_nxt;
end

// &CombBeg; @869
always @( rst_dcache_inv
       or ifu_cp0_rst_inv_req
       or lsu_cp0_dcache_done)
begin
case(rst_dcache_inv)
  RST_IDLE:
  begin
    if(ifu_cp0_rst_inv_req)
      rst_dcache_inv_nxt = RST_WFC;
    else
      rst_dcache_inv_nxt = RST_IDLE;
  end
  RST_WFC:
  begin
    if(lsu_cp0_dcache_done)
      rst_dcache_inv_nxt = RST_IDLE;
    else
      rst_dcache_inv_nxt = RST_WFC;
  end
  default:
  begin
    rst_dcache_inv_nxt = RST_IDLE;
  end
endcase
// &CombEnd; @890
end

// &CombBeg; @911
// &CombEnd; @932
assign rst_dtcm_en  = 1'b0;
assign rst_dtcm_inv = RST_IDLE;

// &CombBeg; @960
// &CombEnd; @981
assign rst_itcm_en  = 1'b0;
assign rst_itcm_inv = RST_IDLE;

always @(posedge cpuclk or negedge cpurst_b)
begin
  if(!cpurst_b)
    rst_tlb_inv <= RST_IDLE;
  else
    rst_tlb_inv <= rst_tlb_inv_nxt;
end

// &CombBeg; @998
always @( rst_tlb_inv
       or ifu_cp0_rst_inv_req
       or mmu_cp0_tlb_done)
begin
case(rst_tlb_inv)
  RST_IDLE:
  begin
    if(ifu_cp0_rst_inv_req)
      rst_tlb_inv_nxt = RST_WFC;
    else
      rst_tlb_inv_nxt = RST_IDLE;
  end
  RST_WFC:
  begin
    if(mmu_cp0_tlb_done)
      rst_tlb_inv_nxt = RST_IDLE;
    else
      rst_tlb_inv_nxt = RST_WFC;
  end
  default:
  begin
    rst_tlb_inv_nxt = RST_IDLE;
  end
endcase
// &CombEnd; @1019
end

assign rst_inv_done = rst_icache_inv == RST_IDLE && rst_dcache_inv == RST_IDLE
                   && rst_tlb_inv == RST_IDLE 
                   && (rst_dtcm_inv == RST_IDLE || rst_dtcm_inv == RST_WFC && !rst_dtcm_en)
                   && (rst_itcm_inv == RST_IDLE || rst_itcm_inv == RST_WFC && !rst_itcm_en);

assign iui_regs_rst_inv_i = rst_icache_inv == RST_WFC 
                         && !ifu_cp0_icache_inv_done;
assign iui_regs_rst_inv_d = rst_dcache_inv == RST_WFC;
assign cp0_mmu_tlb_all_inv = rst_tlb_inv == RST_IDLE && ifu_cp0_rst_inv_req;
assign cp0_ifu_rst_inv_done = rst_cache_inv == RST_WFC && rst_inv_done;

//==========================================================
//                Qualify CP0 insctuctions
//==========================================================
assign iui_m_mode = regs_iui_pm[1:0] == 2'b11;
assign iui_s_mode = regs_iui_pm[1:0] == 2'b01;
assign iui_u_mode = regs_iui_pm[1:0] == 2'b00;
assign iui_v_mode = regs_iui_v       == 1'b1;

// vs-mode access hs-mode csr or inst
assign iui_hs_inv = 1'b0;

// s-mode access m-mode csr or inst
assign iui_s_inv  = iui_s_mode  
                && (iui_inst_csr && iui_addr[9:8] == 2'b11
                    || iui_inst_mret
                    || iui_inst_sret && regs_iui_tsr
                    || iui_inst_wfi && regs_iui_tw
                    || iui_inst_csr && iui_addr[11:0] == SATP && regs_iui_tvm
                    || iui_inst_csr && regs_iui_scnt_inv
                    || iui_inst_csr && regs_iui_hpcp_scr_inv
                    );

// u-mode access m/s-mode csr or inst
assign iui_u_inv  = iui_u_mode  
                && (iui_inst_csr && iui_addr[9:8] != 2'b00
                    || iui_inst_mret
                    || iui_inst_sret
                    || iui_inst_wfi
                    || iui_inst_csr && regs_iui_ucnt_inv
                    );

// write read-only csr
assign iui_w_inv   = iui_inst_csr && iui_addr[11:10] == 2'b11 && !iui_inst_ro; 

// fs illegal 
//according to riscv-v-spec pull 135:
assign iui_fs_inv  = iui_inst_csr && regs_iui_fs_off
                     && ((iui_addr[11:0] == FXCR)
                      || (iui_addr[11:0] == FCSR)
                      || (iui_addr[11:0] == FFLAGS)
                      || (iui_addr[11:0] == FRM)
                        );

assign iui_vs_inv  = iui_inst_csr && regs_iui_vs_off
                     && ((iui_addr[11:0] == VL)
                      || (iui_addr[11:0] == VTYPE)
                      || (iui_addr[11:0] == VSTART)
                      || (iui_addr[11:0] == VLENB)
                      || (iui_addr[11:0] == VXSAT)
                      || (iui_addr[11:0] == VXRM)
                      || (iui_addr[11:0] == VCSR)
                        );
assign iui_tee_inv = iui_inst_csr && regs_iui_chk_vld
                  && !regs_iui_tee_vld && !iui_inst_ro
                  && ((iui_addr[11:0] == MTEECFG) && !regs_iui_tee_ff
                   || (iui_addr[11:0] == MCCR2)
                   || (iui_addr[11:0] == MHINT4)
                   || (iui_addr[11:0] == MCER2)
                   || (iui_addr[11:0] == MEICR2)
                   || (iui_addr[11:0] == MCINS) && regs_iui_cindex_l2
                    )
                  ;
//in debug mode or m-mode set, the cp0 insctuction
//execute with privilege
assign iui_privilege = (rtu_yy_xx_dbgon
                    || iui_m_mode
                    || iui_s_mode && !iui_v_mode && !iui_s_inv
                    || iui_s_mode && iui_v_mode  && !iui_s_inv && !iui_hs_inv
                    || iui_u_mode && !iui_u_inv
                       ) && !csr_addr_inv && !iui_w_inv && !iui_fs_inv
                       `ifdef ADD_AIA
                         && !aia_cp0_imsic_illegal_expt                          //for AIA by chenlili@20250521  
                       `endif   
                     && !iui_vs_inv && !iui_tee_inv;

//the instruction need write back into conctol register
//should be selected only when cp0 in EX1 state
//following singals are selected only when ex1 stage
assign inst_csr_ex1      = cp0_ex1_select && iui_privilege && iui_inst_csr;
assign inst_mret_ex2     = cp0_ex2_select && iui_privilege && iui_inst_mret;
assign inst_sret_ex2     = cp0_ex2_select && iui_privilege && iui_inst_sret;

//signal for lpmd enter into low power mode, not valid in ex3 stage
assign inst_lpmd_ex1_ex2 = (cp0_ex1_select || cp0_ex2_select) && iui_privilege
                           && iui_inst_wfi;

//signal for inst csr in EX3 stage, used to increase index of CPUID
assign iui_regs_ex3_inst_csr = cp0_ex3_select && iui_flop_commit
                            && iui_privilege && iui_inst_csr;

//csr write insctuction
assign inst_csr_wr = cp0_select && iui_privilege && iui_inst_csr 
                  && !iui_inst_ro;

//low power insctuction
assign inst_lpmd   = cp0_select && iui_privilege && iui_inst_wfi;

//instruction type singel for flush and iu special generation
//ignore psr s bit only indicate insctuction type information
//assign cp0_csr     = cp0_select && iui_inst_csr;
assign cp0_mret    = cp0_select && iui_inst_mret;
assign cp0_sret    = cp0_select && iui_inst_sret;
assign cp0_dret    = cp0_select && iui_inst_dret;
//assign cp0_wfi     = cp0_select && iui_inst_wfi;

//==========================================================
//          Generate select and data signals to regs
//==========================================================
// write valid in EX2
always @ (posedge cpuclk or negedge cpurst_b)
begin
  if(!cpurst_b)
    inst_csr_ex2 <= 1'b0;
  else if(cp0_ex1_select & cp0_read_cmplt) // Risc-V Debug zdb
    inst_csr_ex2 <= (inst_csr_ex1 && !iui_inst_ro);
  else
    inst_csr_ex2 <= 1'b0;
end

assign iui_regs_sel          = inst_csr_ex2 && cp0_ex2_select;
assign iui_regs_inst_mret    = inst_mret_ex2;
assign iui_regs_inst_sret    = inst_sret_ex2;
assign iui_regs_csr_wr       = iui_inst_csr && !iui_inst_ro;
assign iui_regs_addr[11:0]   = iui_addr[11:0];
assign iui_regs_inv_expt     = !iui_privilege && cp0_ex2_select;
//assign iui_regs_opcode[31:0] = {32{!iui_privilege}} & iui_opcode[31:0];
assign iui_regs_ori_src0[63:0] = (iui_inst_csrrs || iui_inst_csrrc) ? iui_src0[63:0]
                                                                    : iui_uimm[63:0];
assign iui_regs_csrw         = iui_inst_csrrw || iui_inst_csrrwi;

assign csrrw_src0[63:0]  = iui_src0[63:0];
assign csrrs_src0[63:0]  = regs_csr_rdata_for_w[63:0] |   iui_src0[63:0];
assign csrrc_src0[63:0]  = regs_csr_rdata_for_w[63:0] & (~iui_src0[63:0]);
assign csrrwi_src0[63:0] = iui_uimm[63:0];
assign csrrsi_src0[63:0] = regs_csr_rdata_for_w[63:0] |   iui_uimm[63:0];
assign csrrci_src0[63:0] = regs_csr_rdata_for_w[63:0] & (~iui_uimm[63:0]);

assign iui_regs_src0[63:0] = {64{iui_inst_csrrw}}  & csrrw_src0[63:0]
                           | {64{iui_inst_csrrs}}  & csrrs_src0[63:0]
                           | {64{iui_inst_csrrc}}  & csrrc_src0[63:0]
                           | {64{iui_inst_csrrwi}} & csrrwi_src0[63:0]
                           | {64{iui_inst_csrrsi}} & csrrsi_src0[63:0]
                           | {64{iui_inst_csrrci}} & csrrci_src0[63:0];

// for cut off cp0 - l2 write data path
assign iui_csr_inst_imm = iui_inst_csrrwi || iui_inst_csrrsi || iui_inst_csrrci;

assign cp0_biu_sel         = (cp0_ex1_select || cp0_ex2_select) 
                          && iui_inst_csr && regs_iui_l2_regs_sel && iui_privilege;
assign cp0_biu_wdata[63:0] = regs_iui_dca_sel ? regs_iui_wdata[63:0]
                             : iui_csr_inst_imm ? iui_uimm[63:0] : iui_src0[63:0];

assign cp0_biu_op[15:8]    = {regs_iui_dca_sel, 7'b0};
assign cp0_biu_op[7:4]     = regs_iui_reg_idx[3:0];
assign cp0_biu_op[3]       = !iui_inst_ro;
assign cp0_biu_op[2]       = iui_inst_csrrw || iui_inst_csrrwi;
assign cp0_biu_op[1]       = iui_inst_csrrs || iui_inst_csrrsi;
assign cp0_biu_op[0]       = iui_inst_csrrc || iui_inst_csrrci;

//assign cp0_biu_l2_csrw       = iui_inst_csrrw || iui_inst_csrrwi;
//assign cp0_biu_l2_csrs       = iui_inst_csrrs || iui_inst_csrrsi;
//assign cp0_biu_l2_csrc       = iui_inst_csrrc || iui_inst_csrrci;
//assign cp0_biu_l2_wdata[63:0] = iui_csr_inst_imm ? iui_uimm[63:0] : iui_src0[63:0];
//assign cp0_biu_l2_rd_vld     = inst_csr_ex1 && regs_iui_l2_regs_sel;
//assign cp0_biu_l2_wr_vld     = inst_csr_ex2 && (cur_state[1:0] == EX2) && regs_iui_l2_regs_sel;
//
// cp0-hpcp req-cmplt
assign cp0_hpcp_sel         = (cp0_ex1_select || cp0_ex2_select) 
                          && iui_inst_csr && regs_iui_hpcp_regs_sel && iui_privilege;
assign cp0_hpcp_op[3]       = !iui_inst_ro && cp0_ex2_select;
assign cp0_hpcp_op[2]       = iui_inst_csrrw || iui_inst_csrrwi;
assign cp0_hpcp_op[1]       = iui_inst_csrrs || iui_inst_csrrsi;
assign cp0_hpcp_op[0]       = iui_inst_csrrc || iui_inst_csrrci;
assign cp0_hpcp_src0[63:0]  = iui_csr_inst_imm ? iui_uimm[63:0] : iui_src0[63:0];

//mtcr mcir valid signal, used for complete signal
assign iui_csr_mcir = inst_csr_wr && regs_iui_cskyee && iui_addr[11:0] == SMCIR;

// L2 reg access inst should wait for cmplt
assign iui_csr_l2regs = cp0_select && iui_privilege && iui_inst_csr && regs_iui_l2_regs_sel;
assign iui_csr_hpcp   = cp0_select && iui_privilege && iui_inst_csr && regs_iui_hpcp_regs_sel;
assign iui_csr_aia    = cp0_select && iui_privilege && iui_inst_csr && regs_iui_aia_sel;

// AIA Regs select and write information
assign aia_regs_sel =     iui_addr[11:4] == 8'h35 //MISELECT/MIREG/MTOPEI
                      ||  iui_addr[11:4] == 8'h15 //SISELECT/SIREG/STOPEI
                      ||  iui_addr[11:0] == MIDELEG
                      ||  iui_addr[11:0] == MIE
                      ||  iui_addr[11:0] == MIP
                      ||  iui_addr[11:0] == SIE
                      ||  iui_addr[11:0] == SIP
                      ||  iui_addr[11:0] == MVIEN
                      ||  iui_addr[11:0] == MVIP
                      ||  iui_addr[11:0] == MTOPI
                      ||  iui_addr[11:0] == STOPI;

assign regs_iui_aia_sel  = aia_regs_sel;
assign aia_ren           = iui_csr_aia & cp0_ex1_select;
//==========================================================
//            Handling the CP0 complete signal
//==========================================================
//all cp0 insctuction can be completed when:
//1.if low power insctuction, IFU/LSU gets no operation
//2.if mtcr mcir, MMU acknowledge complete
//3.inv and clr bit in cfr is 0
// assign cp0_inst_cmplt = ( !(inst_lpmd || iui_csr_mcir || iui_csr_l2regs || iui_csr_hpcp)
//                          || lpmd_cmplt
//                          || mmu_cp0_cmplt
//                          || hpcp_cp0_cmplt
//                          || biu_cp0_cmplt)
//                         && regs_iui_cfr_no_op
//                         && regs_iui_cins_no_op;
//==========================================================
//                  Risc-V Debug zdb Begin (replace)
//==========================================================
assign cp0_inst_cmplt = ( ~(inst_lpmd | iui_csr_mcir | iui_csr_l2regs | iui_csr_hpcp)
                         | lpmd_cmplt
                         | mmu_cp0_cmplt & regs_iui_mmu_regs_sel
                         | hpcp_cp0_cmplt
                         | biu_cp0_cmplt
                         | dtu_cp0_write_cmplt & regs_iui_dtu_regs_sel)
                         & regs_iui_cfr_no_op
                         & regs_iui_cins_no_op;
//==========================================================
//                  Risc-V Debug zdb End   (replace)
//==========================================================

//==========================================================
//           Generate data valid signal to IU 
//==========================================================
//if there is a mfcr insctuction, data valid 
assign cp0_iu_ex3_rslt_vld        = iui_inst_csr
                                    && iui_privilege
                                    && cp0_ex3_select
                                    && iui_flop_commit;
assign cp0_iu_ex3_rslt_preg[PREG - 1:0]  = iui_preg[PREG - 1:0];

// &Force("bus", "biu_cp0_rdata", 127, 0); @1241
always @(posedge cpuclk or negedge cpurst_b)
begin
  if(!cpurst_b)
    cp0_rslt_reg[63:0] <= 64'b0;
  else if(biu_cp0_cmplt)
    cp0_rslt_reg[63:0] <= {64{~regs_iui_mcins}} & biu_cp0_rdata[63:0];
  else if(hpcp_cp0_cmplt)
    cp0_rslt_reg[63:0] <= hpcp_cp0_data[63:0];
  else if(inst_csr_ex1 & cp0_read_cmplt) // Risc-V Debug zdb
    cp0_rslt_reg[63:0] <= regs_iui_data_out[63:0];
  else
    cp0_rslt_reg[63:0] <= cp0_rslt_reg[63:0];
end

always @(posedge cpuclk or negedge cpurst_b)
begin
  if(!cpurst_b) begin
    mip_raw_f[63:0] <= 64'b0;
    sip_raw_f[63:0] <= 64'b0;
  end
  else if(aia_ren)begin
    mip_raw_f[63:0] <= mip_raw[63:0];
    sip_raw_f[63:0] <= sip_raw[63:0];
  end
end

always @( sip_raw_f[63:0]
       or mip_raw_f[63:0]
       or iui_addr[11:0]
       or cp0_rslt_reg[63:0])
begin
  case (iui_addr[11:0])
    MIP: regs_csr_rdata_for_w[63:0] = mip_raw_f[63:0];
    SIP: regs_csr_rdata_for_w[63:0] = sip_raw_f[63:0];
    default : regs_csr_rdata_for_w[63:0] = cp0_rslt_reg[63:0];
  endcase
// &CombEnd; @369
end

assign cp0_iu_ex3_rslt_data[63:0] = cp0_rslt_reg[63:0];

//==========================================================
//            Special insctuction result 
//==========================================================
assign cp0_iu_ex3_iid[IID_WIDTH - 1:0]  = iui_ex1_iid[IID_WIDTH - 1:0];
assign cp0_iu_ex3_abnormal  = 1'b1;
//assign cp0_iu_ex3_unctace   = cp0_mret
//                              || cp0_sret
//                              || cp0_wfi;
//assign cp0_iu_ex3_idly_clr  = 1'b0;

//==========================================================
//             Generate Exception to IU 
//==========================================================

//----------------------------------------------------------
//          Generate CP0 Exception Valid
//----------------------------------------------------------
// Generate privilege exception when the CP0 is selected 
// at EX1 stage in user mode.
assign cp0_ex2_expt_vld = !iui_privilege && cp0_ex2_select;

always @(posedge cpuclk or negedge cpurst_b)
begin
  if(!cpurst_b)
    cp0_expt_vld <= 1'b0;
  else if(rtu_yy_xx_flush)
    cp0_expt_vld <= 1'b0;
  else if(cp0_ex2_select)
    cp0_expt_vld <= cp0_ex2_expt_vld;
  else
    cp0_expt_vld <= cp0_expt_vld;
end

assign cp0_iu_ex3_expt_vld = cp0_expt_vld;
assign cp0_iu_ex3_mtval[31:0] = iui_opcode[31:0];
    
//----------------------------------------------------------
//         Generate CP0 Exception Vector 
//----------------------------------------------------------
assign cp0_iu_ex3_expt_vec[4:0] = 5'h2;

//==========================================================
//             Generate Interrupt to RTU 
//==========================================================
//----------------------------------------------------------
//          Generate iui int valid
//----------------------------------------------------------

assign int_vld = |regs_iui_int_sel[14:0];
always @ (posedge forever_cpuclk or negedge cpurst_b)
begin
  if(!cpurst_b)
    iui_int_vld_b <= 1'b1;
  else if(int_vld)
    iui_int_vld_b <= 1'b0;
  else 
    iui_int_vld_b <= 1'b1;
end

//----------------------------------------------------------
//         Generate iui int vector
//----------------------------------------------------------
// &CombBeg; @1319
always @( regs_iui_int_sel[14:0])
begin
casez(regs_iui_int_sel[14:0])
  15'b1?????????????? : valid_int_vec[4:0] = 5'd23; // mcip
  15'b01????????????? : valid_int_vec[4:0] = 5'd18; // mhip
  15'b001???????????? : valid_int_vec[4:0] = 5'd11; // meip
  15'b0001??????????? : valid_int_vec[4:0] = 5'd3;  // msip
  15'b00001?????????? : valid_int_vec[4:0] = 5'd7;  // mtip
  15'b000001????????? : valid_int_vec[4:0] = 5'd9;  // seip
  15'b0000001???????? : valid_int_vec[4:0] = 5'd1;  // ssip
  15'b00000001??????? : valid_int_vec[4:0] = 5'd5;  // stip
  15'b000000001?????? : valid_int_vec[4:0] = 5'd13; // moip
  15'b0000000001????? : valid_int_vec[4:0] = 5'd23; // mcip
  15'b00000000001???? : valid_int_vec[4:0] = 5'd18; // mhip
  15'b000000000001??? : valid_int_vec[4:0] = 5'd9;  // seip
  15'b0000000000001?? : valid_int_vec[4:0] = 5'd1;  // ssip
  15'b00000000000001? : valid_int_vec[4:0] = 5'd5;  // stip
  15'b000000000000001 : valid_int_vec[4:0] = 5'd13; // moip
  default      : valid_int_vec[4:0] = {5{1'bx}};
endcase
// &CombEnd; @1338
end

always @ (posedge forever_cpuclk or negedge cpurst_b)
begin
  if(!cpurst_b)
    iui_int_vec[4:0] <= 5'b0;
  else if(int_vld)
    iui_int_vec[4:0] <= valid_int_vec[4:0];
  else 
    iui_int_vec[4:0] <= iui_int_vec[4:0];
end

assign cp0_lsu_xx_int_b    = iui_int_vld_b;
assign cp0_rtu_xx_int_b    = iui_int_vld_b;
assign cp0_rtu_xx_vec[4:0] = iui_int_vec[4:0];


//==========================================================
//                 generate cp0 flush                   
//==========================================================
//cp0 will generate flush if
//1.mret/sret
//2.csr inst
//3.wfi
assign iui_flush = cp0_select;

//flop out for timing optimization
always @(posedge cpuclk or negedge cpurst_b)
begin
  if(!cpurst_b)
    cp0_flush <= 1'b0;
  else if(rtu_yy_xx_flush)
    cp0_flush <= 1'b0;
  else if(cp0_ex2_select)
    cp0_flush <= iui_flush;
  else
    cp0_flush <= cp0_flush;
end

assign  cp0_iu_ex3_flush = cp0_flush;

//==========================================================
//                  Risc-V Debug zdb Begin
//==========================================================
assign cp0_read_cmplt = regs_iui_dtu_regs_sel & dtu_cp0_read_cmplt  //read dtu regs need 2 cycle
                        | regs_iui_hpcp_regs_sel & hpcp_cp0_cmplt
                        | ~(regs_iui_dtu_regs_sel | regs_iui_hpcp_regs_sel) //other regs need 1 cycle
                        | ~(iui_privilege & iui_inst_csr); // if illeagal, set cmplt to 1

assign iui_inst_wr      = (iui_inst_csrrs  | iui_inst_csrrc 
                        |  iui_inst_csrrsi | iui_inst_csrrci)
                        & iui_uimm[4:0] == {5{1'b0}}
                        | (iui_inst_csrrw | iui_inst_csrrwi);

assign iui_regs_ex1_read_sel      = inst_csr_ex1;
assign iui_regs_ex2_write_sel     = inst_csr_ex2 & cp0_ex2_select;
assign iui_regs_wreg_for_dtu_hpcp = iui_inst_wr & cp0_ex2_select;

assign iui_regs_fsm_busy   = (cur_state[1:0] != IDLE);

assign cp0_iu_ex3_mret = cp0_mret;
assign cp0_iu_ex3_sret = cp0_sret;
assign cp0_iu_ex3_dret = cp0_dret;
//==========================================================
//                  Risc-V Debug zdb End
//==========================================================

// &ModuleEnd; @1379
endmodule


