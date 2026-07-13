//-----------------------------------------------------------------------------
// File          : xx_lsu_ld_wb.v
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


// $Id: xx_lsu_ld_wb.vp,v 1.48 2022/01/06 08:14:35 jizk Exp $
// *****************************************************************************

// &ModuleBeg; @27
module xx_lsu_ld_wb #(
//parameter LSIQENTRY    = 12,
parameter RBENTRY       = 16,
parameter SQ_ENTRY      = 12,
parameter VMB_ENTRY     = 8,
parameter IID_WIDTH     = 7,
parameter VREG          = 6,
parameter PREG          = 7,
parameter PREG_N        = 96
)(
// &Ports; @28
  cp0_lsu_icg_en,                     
  cpurst_b,                           
  ctrl_ld_clk,                        
  forever_cpuclk,                                         
  lda_ex3_addr,                                         
  lda_ex3_element_cnt,                  
  lda_ex3_iid,                          
  lda_ex3_inst_vfls,                    
  lda_ex3_inst_vld,                     
  lda_ex3_preg,                         
  lda_lwb_ex3_preg_sign_sel,                
  lda_ex3_reg_bytes_vld,                
  lda_ex3_reg_bytes_vld1,                
  lda_ex3_reg_bytes_vld2,                
  lda_ex3_reg_bytes_vld3,                
  lda_ex3_inst_us,
  lda_ex3_vmb_id,                       
  lda_ex3_vmb_merge_vld,                
  lda_ex3_vreg,                         
  lda_lwb_ex3_cmplt_req,                 
  lda_lwb_ex3_cmplt_req_gate,            
  lda_lwb_ex3_data,                      
  lda_lwb_ex3_data1,                      
  lda_lwb_ex3_data2,                      
  lda_lwb_ex3_data3,                      
  lda_lwb_ex3_vmew,
  lda_lwb_ex3_data_req,                  
  lda_lwb_ex3_data_req_dp,               
  lda_lwb_ex3_data_req_gateclk_en,       
  lda_lwb_ex3_expt_vec,                  
  lda_lwb_ex3_expt_vld,                  
  lda_lwb_ex3_inst_vls,                  
  lda_lwb_ex3_mtval,                  
  lda_lwb_ex3_no_spec_hit,               
  lda_lwb_ex3_no_spec_mispred,           
  lda_lwb_ex3_no_spec_miss,              
  lda_lwb_ex3_no_spec_target,            
  lda_ex3_spec_fail,                 
  lda_lwb_ex3_vreg_sign_sel,             
  lda_lwb_ex3_vsetvl,                    
  lda_lwb_ex3_vstart_vld,                
  mmu_lsu_mmu_en,                     
  pad_yy_icg_scan_en,                               
  rb_lwb_ex3_bus_err,                   
  rb_lwb_ex3_bus_err_addr,              
  rb_lwb_ex3_cmplt_req,                 
  rb_lwb_ex3_cmplt_vmb_id,              
  rb_lwb_ex3_cmplt_vmb_merge_vld,       
  rb_lwb_ex3_data,                      
  rb_lwb_ex3_data1,                      
  rb_lwb_ex3_data2,                      
  rb_lwb_ex3_data3,                      
  rb_lwb_ex3_data_element_cnt,          
  rb_lwb_ex3_data_iid,                  
  rb_lwb_ex3_data_req,                  
  rb_lwb_ex3_data_vmb_id,               
  rb_lwb_ex3_data_vmb_merge_vld,        
  rb_lwb_ex3_element_cnt,               
  rb_lwb_ex3_expt_gateclk,              
  rb_lwb_ex3_expt_vld,                  
  rb_lwb_ex3_iid,                       
  rb_lwb_ex3_inst_vfls,                 
  rb_lwb_ex3_inst_vls,                  
  rb_lwb_ex3_mtval,                  
  rb_lwb_ex3_preg,                      
  rb_lwb_ex3_preg_sign_sel,             
  rb_lwb_ex3_reg_bytes_vld,             
  rb_lwb_ex3_reg_bytes_vld1,
  rb_lwb_ex3_reg_bytes_vld2,
  rb_lwb_ex3_reg_bytes_vld3,
  rb_lwb_ex3_inst_us,
  rb_lwb_ex3_vmew,
  rb_lwb_ex3_spec_fail,                 
  rb_lwb_ex3_vreg,                      
  rb_lwb_ex3_vreg_sign_sel,             
  rb_lwb_ex3_vsetvl,                    
  rb_lwb_ex3_vstart_vld,                
  rtu_yy_xx_flush,
  rtu_ck_flush,
  rtu_ck_flush_iid,                    
  vmb_lwb_data,                     
  vmb_lwb_data_req,                 
  vmb_lwb_inst_vfls,                
  vmb_lwb_inst_vls, 
  vmb_lwb_vmb_merge_vld,                           
  vmb_lwb_vreg,                     
  vmb_lwb_vreg_sign_sel,            
  wmb_lwb_data,                     
  wmb_lwb_data_addr,                
  wmb_lwb_data_iid,                 
  wmb_lwb_data_req,                 
  wmb_lwb_inst_vfls,                
  wmb_lwb_inst_vls,                 
  wmb_lwb_preg,                     
  wmb_lwb_preg_sign_sel,            
  wmb_lwb_vmb_merge_vld,            
  wmb_lwb_vreg,                     
  wmb_lwb_vreg_sign_sel,            
  lwb_ex4_data_vld,                     
  lwb_ex4_inst_vld,                     
  lwb_rb_ex3_cmplt_grnt,                
  lwb_rb_ex3_data_grnt,                 
  ld_wb_vmb_bytes_vld,                
  ld_wb_vmb_cmplt_element_cnt,        
  ld_wb_vmb_cmplt_expt,               
  ld_wb_vmb_cmplt_vld,                
  ld_wb_vmb_cmplt_vmb_id,             
  ld_wb_vmb_cmplt_vsetvl,             
  ld_wb_vmb_cmplt_data,                     
  ld_wb_vmb_data_async_vld,           
  ld_wb_vmb_data_element_cnt,         
  ld_wb_vmb_data_grnt,                
  ld_wb_vmb_data_merge_vld,           
  ld_wb_vmb_data_vmb_id,              
  lwb_wmb_ex3_data_grnt,                                 
  lsu_idu_ex4_fwd_vreg,          
  lsu_idu_ex4_fwd_vreg_vld,      
  lsu_idu_ex4_preg,           
  lsu_idu_ex4_preg_data,           
  lsu_idu_ex4_preg_expand,    
  lsu_idu_ex4_preg_vld,       
  lsu_idu_ex4_vreg,           
  lsu_idu_ex4_vreg_fr_data,   
  lsu_idu_ex4_vreg_fr_expand, 
  lsu_idu_ex4_vreg_fr_vld,    
  lsu_idu_ex4_vreg_vld,  
  lsu_idu_ex4_vreg_vr0_data,  
  lsu_idu_ex4_vreg_vr0_expand, 
  lsu_idu_ex4_vreg_vr0_vld,   
  lsu_idu_ex4_vreg_vr1_data,  
  lsu_idu_ex4_vreg_vr1_expand, 
  lsu_idu_ex4_vreg_vr1_vld,   
  lsu_rtu_async_expt_addr,            
  lsu_rtu_async_expt_vld,             
  lsu_rtu_ex4_abnormal,                
  lsu_rtu_ex4_cmplt,             
  lsu_rtu_ex4_expt_vec,          
  lsu_rtu_ex4_expt_vld,          
  lsu_rtu_ex4_flush,             
  lsu_rtu_ex4_iid,               
  lsu_rtu_ex4_mtval,             
  lsu_rtu_ex4_no_spec_hit,       
  lsu_rtu_ex4_no_spec_mispred,   
  lsu_rtu_ex4_no_spec_miss,      
  lsu_rtu_ex4_no_spec_target,    
  lsu_rtu_ex4_spec_fail,         
  lsu_rtu_ex4_vsetvl,            
  lsu_rtu_ex4_vstart,            
  lsu_rtu_ex4_vstart_vld,        
  lsu_rtu_ex4_preg_expand,    
  lsu_rtu_ex4_preg_vld,       
  lsu_rtu_ex4_vreg_expand,    
  lsu_rtu_ex4_vreg_fr_vld,    
  lsu_rtu_ex4_vreg_vr_vld,
//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
  //input
  dtu_lsu_addr_halt_info,
  ld_da_halt_info_am,
  lsu_any_trig_en,
  rb_ld_wb_data_check,
  rb_ld_wb_data_halt_info,
  rb_ld_wb_data_ptr,
  rb_ld_wb_halt_info_am,
  rb_ld_wb_inst_size,
  //output
  lsu_dtu_data,          
  lsu_dtu_data_halt_info,
  lsu_dtu_data_size,
  lsu_dtu_data_type,     
  lsu_dtu_data_vld,
  rb_entry_data_halt_info_update_vld,
  lsu_rtu_ex4_lsupipe_halt_info
//==========================================================
//                  Risc-V Debug zdb End 
//==========================================================   
);
input                                   rtu_ck_flush;
input   [IID_WIDTH-1  :0]               rtu_ck_flush_iid;                    
input                                   cp0_lsu_icg_en;                     
input                                   cpurst_b;                           
input                                   ctrl_ld_clk;                        
input                                   forever_cpuclk;                                        
input   [`WK_PA_WIDTH-1:0]              lda_ex3_addr;                                       
input   [8  :0]                         lda_ex3_element_cnt;                  
input   [IID_WIDTH-1:0]                 lda_ex3_iid;                          
input                                   lda_ex3_inst_vfls;                    
input                                   lda_ex3_inst_vld;                     
input   [PREG-1:0]                      lda_ex3_preg;                         
input   [3  :0]                         lda_lwb_ex3_preg_sign_sel;                
input   [15 :0]                         lda_ex3_reg_bytes_vld;                
input   [15 :0]                         lda_ex3_reg_bytes_vld1;                
input   [15 :0]                         lda_ex3_reg_bytes_vld2;                
input   [15 :0]                         lda_ex3_reg_bytes_vld3;                
input                                   lda_ex3_inst_us;
input   [VMB_ENTRY-1  :0]               lda_ex3_vmb_id;                       
input                                   lda_ex3_vmb_merge_vld;                
input   [VREG-1:0]                      lda_ex3_vreg;                         
input                                   lda_lwb_ex3_cmplt_req;                 
input                                   lda_lwb_ex3_cmplt_req_gate;            
input   [127:0]                         lda_lwb_ex3_data;                      
input   [127:0]                         lda_lwb_ex3_data1;                      
input   [127:0]                         lda_lwb_ex3_data2;                      
input   [127:0]                         lda_lwb_ex3_data3;                      
input   [1  :0]                         lda_lwb_ex3_vmew;
input                                   lda_lwb_ex3_data_req;                  
input                                   lda_lwb_ex3_data_req_dp;               
input                                   lda_lwb_ex3_data_req_gateclk_en;       
input   [4  :0]                         lda_lwb_ex3_expt_vec;                  
input                                   lda_lwb_ex3_expt_vld;                  
input                                   lda_lwb_ex3_inst_vls;                  
input   [`WK_PA_WIDTH-1:0]              lda_lwb_ex3_mtval;                  
input                                   lda_lwb_ex3_no_spec_hit;               
input                                   lda_lwb_ex3_no_spec_mispred;           
input                                   lda_lwb_ex3_no_spec_miss;              
input                                   lda_lwb_ex3_no_spec_target;            
input                                   lda_ex3_spec_fail;                 
input   [14 :0]                         lda_lwb_ex3_vreg_sign_sel;             
input                                   lda_lwb_ex3_vsetvl;                    
input                                   lda_lwb_ex3_vstart_vld;                
input                                   mmu_lsu_mmu_en;                     
input                                   pad_yy_icg_scan_en;                              
input                                   rb_lwb_ex3_bus_err;                   
input   [`WK_PA_WIDTH-1:0]              rb_lwb_ex3_bus_err_addr;              
input                                   rb_lwb_ex3_cmplt_req;                 
input   [VMB_ENTRY-1  :0]               rb_lwb_ex3_cmplt_vmb_id;              
input                                   rb_lwb_ex3_cmplt_vmb_merge_vld;       
input   [127:0]                         rb_lwb_ex3_data;                      
input   [127:0]                         rb_lwb_ex3_data1;                      
input   [127:0]                         rb_lwb_ex3_data2;                      
input   [127:0]                         rb_lwb_ex3_data3;                      
input   [8  :0]                         rb_lwb_ex3_data_element_cnt;          
input   [IID_WIDTH-1:0]                 rb_lwb_ex3_data_iid;                  
input                                   rb_lwb_ex3_data_req;                  
input   [VMB_ENTRY-1  :0]               rb_lwb_ex3_data_vmb_id;               
input                                   rb_lwb_ex3_data_vmb_merge_vld;        
input   [8  :0]                         rb_lwb_ex3_element_cnt;               
input                                   rb_lwb_ex3_expt_gateclk;              
input                                   rb_lwb_ex3_expt_vld;                  
input   [IID_WIDTH-1:0]                 rb_lwb_ex3_iid;                       
input                                   rb_lwb_ex3_inst_vfls;                 
input                                   rb_lwb_ex3_inst_vls;                  
input   [`WK_PA_WIDTH-1:0]              rb_lwb_ex3_mtval;                  
input   [PREG-1:0]                      rb_lwb_ex3_preg;                      
input   [3  :0]                         rb_lwb_ex3_preg_sign_sel;             
input   [15 :0]                         rb_lwb_ex3_reg_bytes_vld;             
input   [15 :0]                         rb_lwb_ex3_reg_bytes_vld1;
input   [15 :0]                         rb_lwb_ex3_reg_bytes_vld2;
input   [15 :0]                         rb_lwb_ex3_reg_bytes_vld3;
input                                   rb_lwb_ex3_inst_us;
input   [1  :0]                         rb_lwb_ex3_vmew;
input                                   rb_lwb_ex3_spec_fail;                 
input   [VREG-1  :0]                    rb_lwb_ex3_vreg;                      
input   [14 :0]                         rb_lwb_ex3_vreg_sign_sel;             
input                                   rb_lwb_ex3_vsetvl;                    
input                                   rb_lwb_ex3_vstart_vld;                
input                                   rtu_yy_xx_flush;                    
input   [511:0]                         vmb_lwb_data;                     
input                                   vmb_lwb_data_req;                 
input                                   vmb_lwb_inst_vfls;                
input                                   vmb_lwb_inst_vls; 
input                                   vmb_lwb_vmb_merge_vld;                           
input   [VREG-1  :0]                    vmb_lwb_vreg;                     
input   [14 :0]                         vmb_lwb_vreg_sign_sel;            
input   [127:0]                         wmb_lwb_data;                     
input   [`WK_PA_WIDTH-1:0]              wmb_lwb_data_addr;                
input   [IID_WIDTH-1:0]                 wmb_lwb_data_iid;                 
input                                   wmb_lwb_data_req;                 
input                                   wmb_lwb_inst_vfls;                
input                                   wmb_lwb_inst_vls;                 
input   [PREG-1:0]                      wmb_lwb_preg;                     
input   [3  :0]                         wmb_lwb_preg_sign_sel;            
input                                   wmb_lwb_vmb_merge_vld;            
input   [VREG-1  :0]                    wmb_lwb_vreg;                     
input   [14 :0]                         wmb_lwb_vreg_sign_sel;            
output                                  lwb_ex4_data_vld;                     
output                                  lwb_ex4_inst_vld;                     
output                                  lwb_rb_ex3_cmplt_grnt;                
output                                  lwb_rb_ex3_data_grnt;                 
output  [63 :0]                         ld_wb_vmb_bytes_vld;                
output  [8  :0]                         ld_wb_vmb_cmplt_element_cnt;        
output                                  ld_wb_vmb_cmplt_expt;               
output                                  ld_wb_vmb_cmplt_vld;                
output  [VMB_ENTRY-1  :0]               ld_wb_vmb_cmplt_vmb_id;             
output                                  ld_wb_vmb_cmplt_vsetvl;             
output  [511:0]                         ld_wb_vmb_cmplt_data;                     
output                                  ld_wb_vmb_data_async_vld;           
output  [8  :0]                         ld_wb_vmb_data_element_cnt;         
output                                  ld_wb_vmb_data_grnt;                
output                                  ld_wb_vmb_data_merge_vld;           
output  [VMB_ENTRY-1  :0]               ld_wb_vmb_data_vmb_id;              
output                                  lwb_wmb_ex3_data_grnt;                                   
output  [VREG:0]                        lsu_idu_ex4_fwd_vreg;          
output                                  lsu_idu_ex4_fwd_vreg_vld;      
output  [PREG-1:0]                      lsu_idu_ex4_preg;           
output  [63 :0]                         lsu_idu_ex4_preg_data;           
output  [PREG_N - 1 :0]                 lsu_idu_ex4_preg_expand;    
output                                  lsu_idu_ex4_preg_vld;       
output  [VREG:0]                        lsu_idu_ex4_vreg;           
output  [63 :0]                         lsu_idu_ex4_vreg_fr_data;   
output  [63 :0]                         lsu_idu_ex4_vreg_fr_expand; 
output                                  lsu_idu_ex4_vreg_fr_vld;    
output                                  lsu_idu_ex4_vreg_vld;  
output  [255 :0]                        lsu_idu_ex4_vreg_vr0_data;  
output  [63 :0]                         lsu_idu_ex4_vreg_vr0_expand; 
output                                  lsu_idu_ex4_vreg_vr0_vld;   
output  [255 :0]                        lsu_idu_ex4_vreg_vr1_data;  
output  [63 :0]                         lsu_idu_ex4_vreg_vr1_expand; 
output                                  lsu_idu_ex4_vreg_vr1_vld;   
output  [`WK_PA_WIDTH-1:0]              lsu_rtu_async_expt_addr;            
output                                  lsu_rtu_async_expt_vld;             
output                                  lsu_rtu_ex4_abnormal;                
output                                  lsu_rtu_ex4_cmplt;             
output  [4  :0]                         lsu_rtu_ex4_expt_vec;          
output                                  lsu_rtu_ex4_expt_vld;          
output                                  lsu_rtu_ex4_flush;             
output  [IID_WIDTH-1:0]                 lsu_rtu_ex4_iid;               
output  [`WK_PA_WIDTH:0]                lsu_rtu_ex4_mtval;             
output                                  lsu_rtu_ex4_no_spec_hit;       
output                                  lsu_rtu_ex4_no_spec_mispred;   
output                                  lsu_rtu_ex4_no_spec_miss;      
output                                  lsu_rtu_ex4_no_spec_target;    
output                                  lsu_rtu_ex4_spec_fail;         
output                                  lsu_rtu_ex4_vsetvl;            
output  [`VSTART_WIDTH-1  :0]                         lsu_rtu_ex4_vstart;            
output                                  lsu_rtu_ex4_vstart_vld;        
output  [PREG_N - 1 :0]                 lsu_rtu_ex4_preg_expand;    
output                                  lsu_rtu_ex4_preg_vld;       
output  [63 :0]                         lsu_rtu_ex4_vreg_expand;    
output                                  lsu_rtu_ex4_vreg_fr_vld;    
output                                  lsu_rtu_ex4_vreg_vr_vld; 


// &Regs; @29                
reg                                     ld_wb_bus_err;                      
reg     [VMB_ENTRY-1  :0]               ld_wb_cmplt_vmb_id;                 
reg                                     ld_wb_cmplt_vmb_merge_vld;          
reg     [127:0]                         ld_wb_data;                         
reg     [127:0]                         ld_wb_data1;                         
reg     [127:0]                         ld_wb_data2;                         
reg     [127:0]                         ld_wb_data3;                         
reg     [`WK_PA_WIDTH-1:0]              ld_wb_data_addr;                    
reg     [8  :0]                         ld_wb_data_element_cnt;             
reg     [IID_WIDTH-1:0]                 ld_wb_data_iid;                     
reg     [PREG-1:0]                      ld_wb_data_preg;                                  
reg     [PREG_N - 1 :0]                 ld_wb_data_preg_expand;             
reg                                     lwb_ex4_data_vld;                     
reg     [VMB_ENTRY-1  :0]               ld_wb_data_vmb_id;                  
reg                                     ld_wb_data_vmb_merge_vld;           
reg     [VREG-1:0]                      ld_wb_data_vreg;                                  
reg     [63 :0]                         ld_wb_data_vreg_expand;             
reg     [8  :0]                         ld_wb_element_cnt;                  
reg     [4  :0]                         ld_wb_expt_vec;                     
reg                                     ld_wb_expt_vld;                     
reg                                     ld_wb_flush;                        
reg     [IID_WIDTH-1:0]                 ld_wb_iid;                          
reg                                     lwb_ex4_inst_vld;                     
reg                                     ld_wb_inst_vls;                                    
reg     [`WK_PA_WIDTH:0]                ld_wb_mt_value;                     
reg                                     ld_wb_no_spec_hit;                  
reg                                     ld_wb_no_spec_mispred;              
reg                                     ld_wb_no_spec_miss;                 
reg                                     ld_wb_no_spec_target;               
reg     [3  :0]                         ld_wb_preg_sign_sel;                
reg                                     ld_wb_preg_wb_vld;                             
reg     [15 :0]                         ld_wb_reg_bytes_vld;                
reg     [15 :0]                         ld_wb_reg_bytes_vld1;                
reg     [15 :0]                         ld_wb_reg_bytes_vld2;                
reg     [15 :0]                         ld_wb_reg_bytes_vld3;                
reg     [1  :0]                         ld_wb_vmew;
reg     [1  :0]                         ld_wb_128settle;
reg                                     ld_wb_inst_us;
reg                                     ld_wb_spec_fail;                    
reg     [127:0]                         ld_wb_vreg_data_sign_extend;        
reg     [14 :0]                         ld_wb_vreg_sign_sel;                
reg                                     ld_wb_vreg_wb_vld;                             
reg                                     ld_wb_vsetvl;                       
reg                                     ld_wb_vstart_vld;                   
reg     [`WK_PA_WIDTH-1:0]              wb_dbg_ld_addr_ff;                  
reg     [63 :0]                         wb_dbg_ld_data_ff;                  
reg     [IID_WIDTH-1:0]                 wb_dbg_ld_iid_ff;                   
reg                                     wb_dbg_ld_req_ff;                   

// &Wires; @30                 
wire                                    rtu_ck_flush;
wire    [IID_WIDTH-1:0]                 rtu_ck_flush_iid;
wire                                    rtu_ck_flush_iid_older_than_cmplt_iid;
//wire                        rtu_ck_flush_iid_older_than_data_iid;  //data_flush no need   
wire                                    cp0_lsu_icg_en;                     
wire                                    cpurst_b;                           
wire                                    ctrl_ld_clk;                        
wire                                    forever_cpuclk;                                        
wire    [`WK_PA_WIDTH-1:0]              lda_ex3_addr;                                         
wire    [8  :0]                         lda_ex3_element_cnt;                  
wire    [IID_WIDTH-1:0]                 lda_ex3_iid;                          
wire                                    lda_ex3_inst_vfls;                    
wire                                    lda_ex3_inst_vld;                     
wire    [PREG-1:0]                      lda_ex3_preg;                         
wire    [PREG_N - 1 :0]                 ld_da_preg_expand;                  
wire    [3  :0]                         lda_lwb_ex3_preg_sign_sel;                
wire    [15 :0]                         lda_ex3_reg_bytes_vld;                
wire    [15 :0]                         lda_ex3_reg_bytes_vld1;                
wire    [15 :0]                         lda_ex3_reg_bytes_vld2;                
wire    [15 :0]                         lda_ex3_reg_bytes_vld3;                
wire                                    lda_ex3_inst_us;
wire    [VMB_ENTRY-1  :0]               lda_ex3_vmb_id;                       
wire                                    lda_ex3_vmb_merge_vld;                
wire    [VREG-1:0]                      lda_ex3_vreg;                         
wire    [63 :0]                         ld_da_vreg_expand;                  
wire                                    lda_lwb_ex3_cmplt_req;                 
wire                                    lda_lwb_ex3_cmplt_req_gate;            
wire    [127:0]                         lda_lwb_ex3_data;                      
wire    [127:0]                         lda_lwb_ex3_data1;                      
wire    [127:0]                         lda_lwb_ex3_data2;                      
wire    [127:0]                         lda_lwb_ex3_data3;                      
wire    [1  :0]                         lda_lwb_ex3_vmew;
wire                                    lda_lwb_ex3_data_req;                  
wire                                    lda_lwb_ex3_data_req_dp;               
wire                                    lda_lwb_ex3_data_req_gateclk_en;       
wire    [4  :0]                         lda_lwb_ex3_expt_vec;                  
wire                                    lda_lwb_ex3_expt_vld;                  
wire                                    lda_lwb_ex3_inst_vls;                  
wire    [`WK_PA_WIDTH-1:0]              lda_lwb_ex3_mtval;                  
wire                                    lda_lwb_ex3_no_spec_hit;               
wire                                    lda_lwb_ex3_no_spec_mispred;           
wire                                    lda_lwb_ex3_no_spec_miss;              
wire                                    lda_lwb_ex3_no_spec_target;            
wire                                    lda_ex3_spec_fail;                 
wire    [14 :0]                         lda_lwb_ex3_vreg_sign_sel;             
wire                                    lda_lwb_ex3_vsetvl;                    
wire                                    lda_lwb_ex3_vstart_vld;                
wire                                    ld_wb_cmplt_clk;                    
wire                                    ld_wb_cmplt_clk_en;                 
wire                                    ld_wb_da_cmplt_grnt;                
wire                                    ld_wb_da_data_grnt;                 
wire                                    ld_wb_data_clk;                     
wire                                    ld_wb_data_clk_en;                  
wire                                    ld_wb_data_pre_vmb_merge_vld;       
wire    [63 :0]                         ld_wb_data_sign0;                   
wire    [63 :0]                         ld_wb_data_sign1;                   
wire    [63 :0]                         ld_wb_data_sign2;                   
wire    [63 :0]                         ld_wb_data_sign3;                   
wire                                    ld_wb_expt_clk;                     
wire                                    ld_wb_expt_clk_en;                              
wire                                    ld_wb_pre_bus_err;                  
wire    [VMB_ENTRY-1  :0]               ld_wb_pre_cmplt_vmb_id;             
wire                                    ld_wb_pre_cmplt_vmb_merge_vld;      
wire    [127:0]                         ld_wb_pre_data;                     
wire    [127:0]                         ld_wb_pre_data1;                     
wire    [127:0]                         ld_wb_pre_data2;                     
wire    [127:0]                         ld_wb_pre_data3;                     
wire    [1  :0]                         ld_wb_pre_vmew;
wire    [`WK_PA_WIDTH-1:0]              ld_wb_pre_data_addr;                
wire    [8  :0]                         ld_wb_pre_data_element_cnt;         
wire    [IID_WIDTH-1:0]                 ld_wb_pre_data_iid;                 
wire    [127:0]                         ld_wb_pre_data_no_da;               
wire    [127:0]                         ld_wb_pre_data_no_da1;               
wire    [127:0]                         ld_wb_pre_data_no_da2;               
wire    [127:0]                         ld_wb_pre_data_no_da3;               
wire                                    ld_wb_pre_data_vld;                 
wire    [VMB_ENTRY-1  :0]               ld_wb_pre_data_vmb_id;              
wire    [8  :0]                         ld_wb_pre_element_cnt;              
wire                                    ld_wb_pre_expt_gateclk;             
wire    [4  :0]                         ld_wb_pre_expt_vec;                 
wire                                    ld_wb_pre_expt_vld;                 
wire                                    ld_wb_pre_flush;                    
wire    [IID_WIDTH-1:0]                 ld_wb_pre_iid;                      
wire                                    ld_wb_pre_inst_vfls;                
wire                                    ld_wb_pre_inst_vld;                 
wire                                    ld_wb_pre_inst_vls;                 
wire    [`WK_PA_WIDTH-1:0]              ld_wb_pre_mt_value;                 
wire    [`WK_PA_WIDTH:0]                ld_wb_pre_mt_value_ext;             
wire                                    ld_wb_pre_no_spec_hit;              
wire                                    ld_wb_pre_no_spec_mispred;          
wire                                    ld_wb_pre_no_spec_miss;             
wire                                    ld_wb_pre_no_spec_target;           
wire    [PREG-1:0]                      ld_wb_pre_preg;                     
wire    [PREG_N - 1 :0]                 ld_wb_pre_preg_expand;              
wire    [3  :0]                         ld_wb_pre_preg_sign_sel;            
wire                                    ld_wb_pre_preg_wb_vld;              
wire    [15 :0]                         ld_wb_pre_reg_bytes_vld;            
wire    [15 :0]                         ld_wb_pre_reg_bytes_vld1;            
wire    [15 :0]                         ld_wb_pre_reg_bytes_vld2;            
wire    [15 :0]                         ld_wb_pre_reg_bytes_vld3;            
wire                                    ld_wb_pre_inst_us;
wire                                    ld_wb_pre_spec_fail;                
wire    [VREG-1:0]                      ld_wb_pre_vreg;                     
wire    [63 :0]                         ld_wb_pre_vreg_expand;              
wire    [14 :0]                         ld_wb_pre_vreg_sign_sel;            
wire                                    ld_wb_pre_vreg_wb_vld;              
wire                                    ld_wb_pre_vsetvl;                   
wire                                    ld_wb_pre_vstart_vld;               
wire                                    ld_wb_preg_clk;                     
wire                                    ld_wb_preg_clk_en;                  
wire    [63 :0]                         ld_wb_preg_data_sign_extend;        
wire                                    lwb_rb_ex3_cmplt_grnt;                
wire                                    lwb_rb_ex3_data_grnt;                 
wire    [63 :0]                         ld_wb_vmb_bytes_vld;                
wire    [8  :0]                         ld_wb_vmb_cmplt_element_cnt;        
wire                                    ld_wb_vmb_cmplt_expt;               
wire                                    ld_wb_vmb_cmplt_vld;                
wire    [VMB_ENTRY-1  :0]               ld_wb_vmb_cmplt_vmb_id;             
wire                                    ld_wb_vmb_cmplt_vsetvl;             
wire    [511:0]                         ld_wb_vmb_cmplt_data;                     
wire                                    ld_wb_vmb_data_async_vld;           
wire    [8  :0]                         ld_wb_vmb_data_element_cnt;         
wire                                    ld_wb_vmb_data_grnt;                
wire                                    ld_wb_vmb_data_merge_vld;           
wire    [VMB_ENTRY-1  :0]               ld_wb_vmb_data_vmb_id;              
wire                                    ld_wb_vreg_clk;                     
wire                                    ld_wb_vreg_clk_en;                  
wire                                    ld_wb_vreg512_clk;
wire                                    ld_wb_vreg512_clk_en;
wire                                    lwb_wmb_ex3_data_grnt;                                   
wire    [VREG:0]                        lsu_idu_ex4_fwd_vreg;          
wire                                    lsu_idu_ex4_fwd_vreg_vld;      
wire    [PREG-1:0]                      lsu_idu_ex4_preg;           
wire    [63 :0]                         lsu_idu_ex4_preg_data;         
wire    [PREG_N - 1 :0]                 lsu_idu_ex4_preg_expand;    
wire                                    lsu_idu_ex4_preg_vld;       
wire    [VREG:0]                        lsu_idu_ex4_vreg;           
wire    [63 :0]                         lsu_idu_ex4_vreg_fr_data;   
wire    [63 :0]                         lsu_idu_ex4_vreg_fr_expand; 
wire                                    lsu_idu_ex4_vreg_fr_vld;    
wire                                    lsu_idu_ex4_vreg_vld;  
wire    [255 :0]                        lsu_idu_ex4_vreg_vr0_data;  
wire    [63 :0]                         lsu_idu_ex4_vreg_vr0_expand; 
wire                                    lsu_idu_ex4_vreg_vr0_vld;   
wire    [255 :0]                        lsu_idu_ex4_vreg_vr1_data;  
wire    [63 :0]                         lsu_idu_ex4_vreg_vr1_expand; 
wire                                    lsu_idu_ex4_vreg_vr1_vld;   
wire    [`WK_PA_WIDTH-1:0]              lsu_rtu_async_expt_addr;            
wire                                    lsu_rtu_async_expt_vld;             
wire                                    lsu_rtu_ex4_abnormal;            
wire                                    lsu_rtu_ex4_cmplt;             
wire    [4  :0]                         lsu_rtu_ex4_expt_vec;          
wire                                    lsu_rtu_ex4_expt_vld;          
wire                                    lsu_rtu_ex4_flush;             
wire    [IID_WIDTH-1:0]                 su_rtu_ex4_iid;               
wire    [`WK_PA_WIDTH:0]                lsu_rtu_ex4_mtval;             
wire                                    lsu_rtu_ex4_no_spec_hit;       
wire                                    lsu_rtu_ex4_no_spec_mispred;   
wire                                    lsu_rtu_ex4_no_spec_miss;      
wire                                    lsu_rtu_ex4_no_spec_target;    
wire                                    lsu_rtu_ex4_spec_fail;         
wire                                    lsu_rtu_ex4_vsetvl;                   
reg     [`VSTART_WIDTH-1  :0]           lsu_rtu_ex4_vstart;            
wire                                    lsu_rtu_ex4_vstart_vld;        
wire    [PREG_N - 1 :0]                 lsu_rtu_ex4_preg_expand;    
wire                                    lsu_rtu_ex4_preg_vld;       
wire    [63 :0]                         lsu_rtu_ex4_vreg_expand;    
wire                                    lsu_rtu_ex4_vreg_fr_vld;    
wire                                    lsu_rtu_ex4_vreg_vr_vld;    
wire                                    mmu_lsu_mmu_en;                     
wire                                    pad_yy_icg_scan_en;                              
wire                                    rb_lwb_ex3_bus_err;                   
wire    [`WK_PA_WIDTH-1:0]              rb_lwb_ex3_bus_err_addr;              
wire                                    rb_lwb_ex3_cmplt_req;                 
wire    [VMB_ENTRY-1  :0]               rb_lwb_ex3_cmplt_vmb_id;              
wire                                    rb_lwb_ex3_cmplt_vmb_merge_vld;       
wire    [127:0]                         rb_lwb_ex3_data;                      
wire    [127:0]                         rb_lwb_ex3_data1;                      
wire    [127:0]                         rb_lwb_ex3_data2;                      
wire    [127:0]                         rb_lwb_ex3_data3;                      
wire    [8  :0]                         rb_lwb_ex3_data_element_cnt;          
wire    [IID_WIDTH-1:0]                 rb_lwb_ex3_data_iid;                  
wire                                    rb_lwb_ex3_data_req;                  
wire    [VMB_ENTRY-1  :0]               rb_lwb_ex3_data_vmb_id;               
wire                                    rb_lwb_ex3_data_vmb_merge_vld;        
wire    [8  :0]                         rb_lwb_ex3_element_cnt;               
wire                                    rb_lwb_ex3_expt_gateclk;              
wire                                    rb_lwb_ex3_expt_vld;                  
wire    [IID_WIDTH-1:0]                 rb_lwb_ex3_iid;                       
wire                                    rb_lwb_ex3_inst_vfls;                 
wire                                    rb_lwb_ex3_inst_vls;                  
wire    [`WK_PA_WIDTH-1:0]              rb_lwb_ex3_mtval;                  
wire    [PREG-1:0]                      rb_lwb_ex3_preg;                      
wire    [PREG_N - 1 :0]                 rb_ld_wb_preg_expand;               
wire    [3  :0]                         rb_lwb_ex3_preg_sign_sel;             
wire    [15 :0]                         rb_lwb_ex3_reg_bytes_vld;             
wire    [15 :0]                         rb_lwb_ex3_reg_bytes_vld1;
wire    [15 :0]                         rb_lwb_ex3_reg_bytes_vld2;
wire    [15 :0]                         rb_lwb_ex3_reg_bytes_vld3;
wire                                    rb_lwb_ex3_inst_us;
wire    [1  :0]                         rb_lwb_ex3_vmew;
wire                                    rb_lwb_ex3_spec_fail;                 
wire    [VREG-1:0]                      rb_lwb_ex3_vreg;                      
wire    [63 :0]                         rb_ld_wb_vreg_expand;               
wire    [14 :0]                         rb_lwb_ex3_vreg_sign_sel;             
wire                                    rb_lwb_ex3_vsetvl;                    
wire                                    rb_lwb_ex3_vstart_vld;                
wire                                    rtu_yy_xx_flush;                    
wire    [511:0]                         vmb_lwb_data;                     
wire                                    vmb_lwb_data_req;                 
wire                                    vmb_lwb_inst_vfls;                
wire                                    vmb_lwb_inst_vls;
wire                                    vmb_lwb_vmb_merge_vld;                             
wire    [VREG-1:0]                      vmb_lwb_vreg;                     
wire    [63 :0]                         vmb_ld_wb_vreg_expand;              
wire    [14 :0]                         vmb_lwb_vreg_sign_sel;            
wire    [`WK_PA_WIDTH-1:0]              wb_dbg_ar_addr;                     
wire    [1  :0]                         wb_dbg_ar_bar;                      
wire    [1  :0]                         wb_dbg_ar_burst;                    
wire    [3  :0]                         wb_dbg_ar_cache;                    
wire    [1  :0]                         wb_dbg_ar_domain;                   
wire    [7  :0]                         wb_dbg_ar_id;                       
wire    [7  :0]                         wb_dbg_ar_len;                      
wire                                    wb_dbg_ar_lock;                     
wire    [2  :0]                         wb_dbg_ar_prot;                     
wire                                    wb_dbg_ar_req_ff;                   
wire    [2  :0]                         wb_dbg_ar_size;                     
wire    [3  :0]                         wb_dbg_ar_snoop;                    
wire                                    wb_dbg_clk;                         
wire                                    wb_dbg_clk_en;                      
wire                                    wb_dbg_ld_req;                      
wire    [127:0]                         wmb_lwb_data;                     
wire    [`WK_PA_WIDTH-1:0]              wmb_lwb_data_addr;                
wire    [IID_WIDTH-1:0]                 wmb_lwb_data_iid;                 
wire                                    wmb_lwb_data_req;                 
wire                                    wmb_lwb_inst_vfls;                
wire                                    wmb_lwb_inst_vls;                 
wire    [PREG-1:0]                      wmb_lwb_preg;                     
wire    [PREG_N - 1 :0]                 wmb_ld_wb_preg_expand;              
wire    [3  :0]                         wmb_lwb_preg_sign_sel;            
wire                                    wmb_lwb_vmb_merge_vld;            
wire    [VREG-1:0]                      wmb_lwb_vreg;                     
wire    [63 :0]                         wmb_ld_wb_vreg_expand;              
wire    [14 :0]                         wmb_lwb_vreg_sign_sel;            

//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
input   [`TDT_MP_HINFO_WIDTH-1:0]       dtu_lsu_addr_halt_info;
input   [`TDT_MP_HINFO_WIDTH-1:0]       ld_da_halt_info_am;
input                                   lsu_any_trig_en;
input                                   rb_ld_wb_data_check;
input   [`TDT_MP_HINFO_WIDTH-1:0]       rb_ld_wb_data_halt_info;
input   [RBENTRY-1:0]                   rb_ld_wb_data_ptr;
input   [`TDT_MP_HINFO_WIDTH-1:0]       rb_ld_wb_halt_info_am;
input   [2  :0]                         rb_ld_wb_inst_size;

output  [63 :0]                         lsu_dtu_data;               
output  [`TDT_MP_HINFO_WIDTH-1:0]       lsu_dtu_data_halt_info;               
output  [2  :0]                         lsu_dtu_data_size;
output  [1  :0]                         lsu_dtu_data_type;               
output                                  lsu_dtu_data_vld;
output  [RBENTRY-1:0]                   rb_entry_data_halt_info_update_vld;
output  [`TDT_MP_HINFO_WIDTH-1:0]       lsu_rtu_ex4_lsupipe_halt_info; 

//input
wire    [`TDT_MP_HINFO_WIDTH-1:0]       dtu_lsu_addr_halt_info;
wire    [`TDT_MP_HINFO_WIDTH-1:0]       ld_da_halt_info_am;
wire                                    lsu_any_trig_en;
wire                                    rb_ld_wb_data_check;
wire    [`TDT_MP_HINFO_WIDTH-1:0]       rb_ld_wb_data_halt_info;
wire    [RBENTRY-1:0]                   rb_ld_wb_data_ptr;
wire    [`TDT_MP_HINFO_WIDTH-1:0]       rb_ld_wb_halt_info_am;
wire    [2  :0]                         rb_ld_wb_inst_size;
//output
reg     [63 :0]                         lsu_dtu_data;               
reg     [`TDT_MP_HINFO_WIDTH-1:0]       lsu_dtu_data_halt_info;               
reg     [2  :0]                         lsu_dtu_data_size;               
reg                                     lsu_dtu_data_vld;
wire    [1  :0]                         lsu_dtu_data_type;
wire    [RBENTRY-1:0]                   rb_entry_data_halt_info_update_vld;
wire    [`TDT_MP_HINFO_WIDTH-1:0]       lsu_rtu_ex4_lsupipe_halt_info; 

reg     [RBENTRY-1:0]                   ld_dtu1_rb_data_ptr;                   
reg     [RBENTRY-1:0]                   ld_dtu2_rb_data_ptr;    
reg                                     ld_dtu2_vld;
reg     [`TDT_MP_HINFO_WIDTH-1:0]       ld_wb_halt_info;
reg                                     ld_wb_inst_vfls;
reg     [`TDT_MP_HINFO_WIDTH-1:0]       ld_wb_dtu_data_halt_info;
reg     [2  :0]                         ld_wb_dtu_data_size;
reg                                     ld_wb_dtu_data_vld;
reg     [`VSTART_WIDTH-1:0]             ld_wb_element_cnt_next;
reg     [RBENTRY-1:0]                   ld_wb_rb_data_ptr;
reg                                     rb_data_halt_info_update_vld;

wire                                    ld_dtu_data_clk;
wire                                    ld_dtu_data_clk_en;
wire    [63 :0]                         ld_wb_data_for_check;
wire                                    ld_wb_halt_info_effect;
wire                                    ld_wb_pre_data_check;
wire                                    ld_wb_pre_data_vld_dp;
wire    [`TDT_MP_HINFO_WIDTH-1:0]       ld_wb_pre_data_halt_info;
wire    [`VSTART_WIDTH-1:0]             ld_wb_pre_element_cnt_next;
wire    [`TDT_MP_HINFO_WIDTH-1:0]       ld_wb_pre_halt_info;
wire    [2  :0]                         ld_wb_pre_inst_size;
wire    [RBENTRY-1:0]                   ld_wb_pre_rb_data_ptr;
//==========================================================
//                  Risc-V Debug zdb End 
//==========================================================

parameter S_BYTE  = 2'b00,
          HALF  = 2'b01,
          WORD  = 2'b10,
          DWORD = 2'b11;
//==========================================================
//                 arbitrate WB stage request
//==========================================================
//------------------complete part---------------------------
//-----------grant signal---------------
assign ld_wb_da_cmplt_grnt      = lda_lwb_ex3_cmplt_req;
// &Force("output","lwb_rb_ex3_cmplt_grnt"); @44
assign lwb_rb_ex3_cmplt_grnt      = !lda_lwb_ex3_cmplt_req
                                  &&  rb_lwb_ex3_cmplt_req;
//-----------signal select--------------
assign ld_wb_pre_inst_vld       = lda_lwb_ex3_cmplt_req
                                  ||  rb_lwb_ex3_cmplt_req;

assign ld_wb_pre_spec_fail      = ld_wb_da_cmplt_grnt &&  lda_ex3_spec_fail
                                  || lwb_rb_ex3_cmplt_grnt &&  rb_lwb_ex3_spec_fail;

assign ld_wb_pre_flush          = ld_wb_pre_spec_fail
                                  || ld_wb_pre_vstart_vld
                                     && !ld_wb_pre_expt_vld
                                  || ld_wb_pre_vsetvl;

assign ld_wb_pre_expt_vld       = ld_wb_da_cmplt_grnt &&  lda_lwb_ex3_expt_vld
                                  || lwb_rb_ex3_cmplt_grnt &&  rb_lwb_ex3_expt_vld;

assign ld_wb_pre_expt_gateclk   = lda_lwb_ex3_cmplt_req_gate &&  (lda_lwb_ex3_expt_vld || lda_lwb_ex3_vsetvl)
                                  || rb_lwb_ex3_cmplt_req &&  rb_lwb_ex3_expt_gateclk;

assign ld_wb_pre_expt_vec[4:0]  = {5{ld_wb_da_cmplt_grnt}} &  lda_lwb_ex3_expt_vec[4:0]
                                  | {5{lwb_rb_ex3_cmplt_grnt}} &  5'd5;

assign ld_wb_pre_iid[IID_WIDTH-1:0]        = {IID_WIDTH{ld_wb_da_cmplt_grnt}}  & lda_ex3_iid[IID_WIDTH-1:0] 
                                          | {IID_WIDTH{lwb_rb_ex3_cmplt_grnt}}  & rb_lwb_ex3_iid[IID_WIDTH-1:0] ;

assign ld_wb_pre_cmplt_vmb_id[VMB_ENTRY-1:0]= {VMB_ENTRY{ld_wb_da_cmplt_grnt}}  & lda_ex3_vmb_id[VMB_ENTRY-1:0]
                                              | {VMB_ENTRY{lwb_rb_ex3_cmplt_grnt}}  & rb_lwb_ex3_cmplt_vmb_id[VMB_ENTRY-1:0];
assign ld_wb_pre_cmplt_vmb_merge_vld        = ld_wb_da_cmplt_grnt & lda_ex3_vmb_merge_vld
                                              | lwb_rb_ex3_cmplt_grnt & rb_lwb_ex3_cmplt_vmb_merge_vld;
assign ld_wb_pre_element_cnt[8:0]           = {9{ld_wb_da_cmplt_grnt}}  & lda_ex3_element_cnt[8:0]
                                              | {9{lwb_rb_ex3_cmplt_grnt}}  & rb_lwb_ex3_element_cnt[8:0];
assign ld_wb_pre_vstart_vld                 = ld_wb_da_cmplt_grnt & lda_lwb_ex3_vstart_vld
                                              | lwb_rb_ex3_cmplt_grnt & rb_lwb_ex3_vstart_vld;
assign ld_wb_pre_vsetvl                     = ld_wb_da_cmplt_grnt & lda_lwb_ex3_vsetvl
                                              | lwb_rb_ex3_cmplt_grnt & rb_lwb_ex3_vsetvl;

assign ld_wb_pre_mt_value[`WK_PA_WIDTH-1:0]    = {`WK_PA_WIDTH{ld_wb_da_cmplt_grnt}} & lda_lwb_ex3_mtval[`WK_PA_WIDTH-1:0]
                                              | {`WK_PA_WIDTH{lwb_rb_ex3_cmplt_grnt}} & rb_lwb_ex3_mtval[`WK_PA_WIDTH-1:0];

assign ld_wb_pre_mt_value_ext[`WK_PA_WIDTH:0] = mmu_lsu_mmu_en
                                             ? {ld_wb_pre_mt_value[`WK_PA_WIDTH-1],ld_wb_pre_mt_value[`WK_PA_WIDTH-1:0]}
                                             : {1'b0,ld_wb_pre_mt_value[`WK_PA_WIDTH-1:0]};

//------------------data part-------------------------------
//-----------grant signal---------------
assign ld_wb_da_data_grnt    = lda_lwb_ex3_data_req_dp;
// &Force("output","lwb_wmb_ex3_data_grnt"); @105
assign lwb_wmb_ex3_data_grnt      = !lda_lwb_ex3_data_req_dp
                                  &&  wmb_lwb_data_req;
// &Force("output","lwb_rb_ex3_data_grnt"); @108
// &Force("output","ld_wb_vmb_data_grnt"); @110
assign ld_wb_vmb_data_grnt      = !lda_lwb_ex3_data_req_dp
                                  &&  !wmb_lwb_data_req
                                  &&  vmb_lwb_data_req;
assign lwb_rb_ex3_data_grnt       = !lda_lwb_ex3_data_req_dp
                                  &&  !wmb_lwb_data_req
                                  &&  !vmb_lwb_data_req
                                  &&  rb_lwb_ex3_data_req;
//-----------signal select--------------
assign ld_wb_pre_data_vld       = lda_lwb_ex3_data_req
                                  ||  !lda_lwb_ex3_data_req_dp
                                      &&  (wmb_lwb_data_req
                                           ||  vmb_lwb_data_req
                                           ||  rb_lwb_ex3_data_req);

assign ld_wb_pre_bus_err        = lwb_rb_ex3_data_grnt &&  rb_lwb_ex3_bus_err;

assign ld_wb_pre_data_addr[`WK_PA_WIDTH-1:0]= {`WK_PA_WIDTH{ld_wb_da_data_grnt}} & lda_ex3_addr[`WK_PA_WIDTH-1:0]
                                           | {`WK_PA_WIDTH{lwb_wmb_ex3_data_grnt}}  & wmb_lwb_data_addr[`WK_PA_WIDTH-1:0]
                                           | {`WK_PA_WIDTH{lwb_rb_ex3_data_grnt}} & rb_lwb_ex3_bus_err_addr[`WK_PA_WIDTH-1:0];

//for had debug
assign ld_wb_pre_data_iid[IID_WIDTH-1:0]   = {IID_WIDTH{ld_wb_da_data_grnt}} & lda_ex3_iid[IID_WIDTH-1:0] 
                                  | {IID_WIDTH{lwb_wmb_ex3_data_grnt}}  & wmb_lwb_data_iid[IID_WIDTH-1:0] 
                                  | {IID_WIDTH{lwb_rb_ex3_data_grnt}} & rb_lwb_ex3_data_iid[IID_WIDTH-1:0] ;

assign ld_wb_pre_preg[PREG-1:0]       = {PREG{ld_wb_da_data_grnt}} & lda_ex3_preg[PREG-1:0]
                                  | {PREG{lwb_wmb_ex3_data_grnt}}  & wmb_lwb_preg[PREG-1:0]
                                  | {PREG{lwb_rb_ex3_data_grnt}} & rb_lwb_ex3_preg[PREG-1:0];

assign ld_wb_pre_vreg[VREG-1:0]       = {VREG{ld_wb_da_data_grnt}} & lda_ex3_vreg[VREG-1:0] 
                                      | {VREG{lwb_wmb_ex3_data_grnt}}  & wmb_lwb_vreg[VREG-1:0] 
                                      | {VREG{ld_wb_vmb_data_grnt}}  & vmb_lwb_vreg[VREG-1:0] 
                                      | {VREG{lwb_rb_ex3_data_grnt}} & rb_lwb_ex3_vreg[VREG-1:0] ;
//preg expand to 96 bits
//do 3 times for timing
//&Instance("wk_rtu_expand_96","x_lsu_ld_wb_pre_preg_expand");
// //&Connect( .x_num          (ld_wb_pre_preg[PREG-1:0]          ), @154
// //          .x_num_expand   (ld_wb_pre_preg_expand[PREG_N - 1:0]  )); @155

assign ld_wb_pre_preg_expand[PREG_N - 1:0]  = {PREG_N{ld_wb_da_data_grnt}} & ld_da_preg_expand[PREG_N - 1:0]
                                      | {PREG_N{lwb_wmb_ex3_data_grnt}}  & wmb_ld_wb_preg_expand[PREG_N - 1:0]
                                      | {PREG_N{lwb_rb_ex3_data_grnt}} & rb_ld_wb_preg_expand[PREG_N - 1:0];

assign ld_wb_pre_vreg_expand[63:0]  = {64{ld_wb_da_data_grnt}} & ld_da_vreg_expand[63:0]
                                      | {64{lwb_wmb_ex3_data_grnt}}  & wmb_ld_wb_vreg_expand[63:0]
                                      | {64{ld_wb_vmb_data_grnt}}  & vmb_ld_wb_vreg_expand[63:0]
                                      | {64{lwb_rb_ex3_data_grnt}} & rb_ld_wb_vreg_expand[63:0];

// &Instance("wk_rtu_expand_96","x_lsu_ld_da_preg_expand"); @172
wk_rtu_expand  #(.DEPTH(PREG_N), .WIDTH(PREG))x_lsu_ld_da_preg_expand (
  .x_num                   (lda_ex3_preg[PREG-1:0]         ),
  .x_num_expand            (ld_da_preg_expand[PREG_N - 1:0])
);

// &Connect( .x_num          (lda_ex3_preg[6:0]          ), @173
//           .x_num_expand   (ld_da_preg_expand[PREG_N - 1:0]  )); @174

// &Instance("wk_rtu_expand_96","x_lsu_wmb_ld_wb_preg_expand"); @176
wk_rtu_expand  #(.DEPTH(PREG_N), .WIDTH(PREG))x_lsu_wmb_ld_wb_preg_expand (
  .x_num                       (wmb_lwb_preg[PREG-1:0]         ),
  .x_num_expand                (wmb_ld_wb_preg_expand[PREG_N - 1:0])
);

// &Connect( .x_num          (wmb_lwb_preg[6:0]          ), @177
//           .x_num_expand   (wmb_ld_wb_preg_expand[PREG_N - 1:0]  )); @178

// &Instance("wk_rtu_expand_96","x_lsu_rb_ld_wb_preg_expand"); @180
wk_rtu_expand  #(.DEPTH(PREG_N), .WIDTH(PREG))x_lsu_rb_ld_wb_preg_expand (
  .x_num                      (rb_lwb_ex3_preg[PREG-1:0] ),
  .x_num_expand               (rb_ld_wb_preg_expand[PREG_N - 1:0])
);

// &Connect( .x_num          (rb_lwb_ex3_preg[6:0]          ), @181
//           .x_num_expand   (rb_ld_wb_preg_expand[PREG_N - 1:0]  )); @182

// &Instance("wk_rtu_expand_64","x_lsu_ld_da_vreg_expand"); @184
wk_rtu_expand_64  x_lsu_ld_da_vreg_expand (
  .x_num                   (lda_ex3_vreg[VREG-1:0] ),
  .x_num_expand            (ld_da_vreg_expand[63:0])
);

// &Connect( .x_num          (lda_ex3_vreg[VREG-1:0]           ), @185
//           .x_num_expand   (ld_da_vreg_expand[63:0]  )); @186

// &Instance("wk_rtu_expand_64","x_lsu_wmb_ld_wb_vreg_expand"); @188
wk_rtu_expand_64  x_lsu_wmb_ld_wb_vreg_expand (
  .x_num                       (wmb_lwb_vreg[VREG-1:0]     ),
  .x_num_expand                (wmb_ld_wb_vreg_expand[63:0])
);

// &Connect( .x_num          (wmb_lwb_vreg[VREG-1:0]           ), @189
//           .x_num_expand   (wmb_ld_wb_vreg_expand[63:0]  )); @190

// &Instance("wk_rtu_expand_64","x_lsu_rb_ld_wb_vreg_expand"); @192
wk_rtu_expand_64  x_lsu_rb_ld_wb_vreg_expand (
  .x_num                      (rb_lwb_ex3_vreg[VREG-1:0]        ),
  .x_num_expand               (rb_ld_wb_vreg_expand[63:0])
);

// &Connect( .x_num          (rb_lwb_ex3_vreg[VREG-1:0]           ), @193
//           .x_num_expand   (rb_ld_wb_vreg_expand[63:0]  )); @194

// &Instance("wk_rtu_expand_64","x_lsu_vmb_ld_wb_vreg_expand"); @197
wk_rtu_expand_64  x_lsu_vmb_ld_wb_vreg_expand (
  .x_num                       (vmb_lwb_vreg[VREG-1:0]        ),
  .x_num_expand                (vmb_ld_wb_vreg_expand[63:0])
);

// &Connect( .x_num          (vmb_lwb_vreg[VREG-1:0]          ), @198
//           .x_num_expand   (vmb_ld_wb_vreg_expand[63:0]  )); @199

assign ld_wb_pre_data_no_da[127:0] = wmb_lwb_data_req 
                                     ? wmb_lwb_data[127:0]
                                     : (vmb_lwb_data_req
                                        ? vmb_lwb_data[127:0]
                                        : rb_lwb_ex3_data[127:0]);
assign ld_wb_pre_data_no_da1[127:0] = vmb_lwb_data_req
                                      ? vmb_lwb_data[255:128]
                                      : rb_lwb_ex3_data1[127:0];

assign ld_wb_pre_data_no_da2[127:0] = vmb_lwb_data_req
                                      ? vmb_lwb_data[383:256]
                                      : rb_lwb_ex3_data2[127:0];

assign ld_wb_pre_data_no_da3[127:0] = vmb_lwb_data_req
                                      ? vmb_lwb_data[511:384]
                                      : rb_lwb_ex3_data3[127:0];

assign ld_wb_pre_data[127:0]       = ld_wb_da_data_grnt
                                     ? lda_lwb_ex3_data[127:0]
                                     : ld_wb_pre_data_no_da[127:0];
assign ld_wb_pre_data1[127:0]       = ld_wb_da_data_grnt
                                     ? lda_lwb_ex3_data1[127:0]
                                     : ld_wb_pre_data_no_da1[127:0];
assign ld_wb_pre_data2[127:0]       = ld_wb_da_data_grnt
                                     ? lda_lwb_ex3_data2[127:0]
                                     : ld_wb_pre_data_no_da2[127:0];
assign ld_wb_pre_data3[127:0]       = ld_wb_da_data_grnt
                                     ? lda_lwb_ex3_data3[127:0]
                                     : ld_wb_pre_data_no_da3[127:0];

assign ld_wb_pre_inst_vfls    = ld_wb_da_data_grnt  & lda_ex3_inst_vfls
                                | lwb_wmb_ex3_data_grnt  & wmb_lwb_inst_vfls
                                | ld_wb_vmb_data_grnt  & vmb_lwb_inst_vfls
                                | lwb_rb_ex3_data_grnt  & rb_lwb_ex3_inst_vfls;

assign ld_wb_pre_preg_wb_vld  = ld_wb_pre_data_vld
                                && !ld_wb_pre_inst_vfls;

assign ld_wb_pre_vreg_wb_vld   = ld_wb_pre_data_vld
                                 && ld_wb_pre_inst_vfls;
//because the timing in ld_da is not enough, so some of the sign extend
//precedure is done in wb stage
assign ld_wb_pre_preg_sign_sel[3:0] = {4{ld_wb_da_data_grnt}} & lda_lwb_ex3_preg_sign_sel[3:0]
                                      | {4{lwb_wmb_ex3_data_grnt}}  & wmb_lwb_preg_sign_sel[3:0]
                                      | {4{lwb_rb_ex3_data_grnt}} & rb_lwb_ex3_preg_sign_sel[3:0];

assign ld_wb_pre_vreg_sign_sel[14:0]= {15{ld_wb_da_data_grnt}}  & lda_lwb_ex3_vreg_sign_sel[14:0]
                                      | {15{lwb_wmb_ex3_data_grnt}}  & wmb_lwb_vreg_sign_sel[14:0]
                                      | {15{ld_wb_vmb_data_grnt}}  & vmb_lwb_vreg_sign_sel[14:0]
                                      | {15{lwb_rb_ex3_data_grnt}}  & rb_lwb_ex3_vreg_sign_sel[14:0];

assign ld_wb_pre_inst_vls           = ld_wb_da_data_grnt  & lda_lwb_ex3_inst_vls
                                      | lwb_wmb_ex3_data_grnt  & wmb_lwb_inst_vls
                                      | ld_wb_vmb_data_grnt  & vmb_lwb_inst_vls
                                      | lwb_rb_ex3_data_grnt  & rb_lwb_ex3_inst_vls;

assign ld_wb_pre_reg_bytes_vld[15:0]= {16{ld_wb_da_data_grnt}}  & lda_ex3_reg_bytes_vld[15:0]
                                      | {16{lwb_rb_ex3_data_grnt}}  & rb_lwb_ex3_reg_bytes_vld[15:0];
assign ld_wb_pre_reg_bytes_vld1     = {16{ld_wb_da_data_grnt}}  & lda_ex3_reg_bytes_vld1[15:0]
                                      | {16{lwb_rb_ex3_data_grnt}}  & rb_lwb_ex3_reg_bytes_vld1[15:0];

assign ld_wb_pre_reg_bytes_vld2     = {16{ld_wb_da_data_grnt}}  & lda_ex3_reg_bytes_vld2[15:0]
                                      | {16{lwb_rb_ex3_data_grnt}}  & rb_lwb_ex3_reg_bytes_vld2[15:0];

assign ld_wb_pre_reg_bytes_vld3     = {16{ld_wb_da_data_grnt}}  & lda_ex3_reg_bytes_vld3[15:0]
                                      | {16{lwb_rb_ex3_data_grnt}}  & rb_lwb_ex3_reg_bytes_vld3[15:0];

assign ld_wb_pre_inst_us            = ld_wb_da_data_grnt & lda_ex3_inst_us
                                      | lwb_rb_ex3_data_grnt & rb_lwb_ex3_inst_us
                                      | ld_wb_vmb_data_grnt; // this has different semantic from previous two, but vmb-data-req need to write 512 bits data
assign ld_wb_pre_vmew               = {2{ld_wb_da_data_grnt}} & lda_lwb_ex3_vmew
                                      | {2{lwb_rb_ex3_data_grnt}} & rb_lwb_ex3_vmew;

assign ld_wb_pre_data_vmb_id[VMB_ENTRY-1:0]= {VMB_ENTRY{ld_wb_da_data_grnt}}  & lda_ex3_vmb_id[VMB_ENTRY-1:0]
                                             | {VMB_ENTRY{lwb_rb_ex3_data_grnt}}  & rb_lwb_ex3_data_vmb_id[VMB_ENTRY-1:0];

assign ld_wb_pre_data_element_cnt[8:0]= {9{ld_wb_da_data_grnt}}  & lda_ex3_element_cnt[8:0]
                                        | {9{lwb_rb_ex3_data_grnt}}  & rb_lwb_ex3_data_element_cnt[8:0];

assign ld_wb_data_pre_vmb_merge_vld = ld_wb_da_data_grnt  & lda_ex3_vmb_merge_vld
                                      | lwb_wmb_ex3_data_grnt  & wmb_lwb_vmb_merge_vld
                                      | ld_wb_vmb_data_grnt  & vmb_lwb_vmb_merge_vld
                                      | lwb_rb_ex3_data_grnt  & rb_lwb_ex3_data_vmb_merge_vld;


//for spec fail prediction
assign ld_wb_pre_no_spec_miss    = ld_wb_da_cmplt_grnt &&  lda_lwb_ex3_no_spec_miss; 
assign ld_wb_pre_no_spec_hit     = ld_wb_da_cmplt_grnt &&  lda_lwb_ex3_no_spec_hit; 
assign ld_wb_pre_no_spec_mispred = ld_wb_da_cmplt_grnt &&  lda_lwb_ex3_no_spec_mispred;
assign ld_wb_pre_no_spec_target  = ld_wb_da_cmplt_grnt &&  lda_lwb_ex3_no_spec_target;
//==========================================================
//                 Instance of Gated Cell  
//==========================================================
//------------------cmplt part gateclk----------------------
assign ld_wb_cmplt_clk_en =   lda_ex3_inst_vld
                              ||  rb_lwb_ex3_cmplt_req;
// &Instance("gated_clk_cell", "x_lsu_ld_wb_cmplt_gated_clk"); @296
gated_clk_cell  x_lsu_ld_wb_cmplt_gated_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (ld_wb_cmplt_clk   ),
  .external_en        (1'b0              ),
  .local_en           (ld_wb_cmplt_clk_en),
  .module_en          (cp0_lsu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect(.clk_in        (forever_cpuclk     ), @297
//          .external_en   (1'b0               ), @298
//          .module_en     (cp0_lsu_icg_en     ), @299
//          .local_en      (ld_wb_cmplt_clk_en ), @300
//          .clk_out       (ld_wb_cmplt_clk    )); @301

assign ld_wb_expt_clk_en  =    ld_wb_pre_expt_gateclk
                            || rb_lwb_ex3_cmplt_req & lsu_any_trig_en; // Risc-V Debug zdb
// &Instance("gated_clk_cell", "x_lsu_ld_wb_expt_gated_clk"); @304
gated_clk_cell  x_lsu_ld_wb_expt_gated_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (ld_wb_expt_clk    ),
  .external_en        (1'b0              ),
  .local_en           (ld_wb_expt_clk_en ),
  .module_en          (cp0_lsu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect(.clk_in        (forever_cpuclk     ), @305
//          .external_en   (1'b0               ), @306
//          .module_en     (cp0_lsu_icg_en     ), @307
//          .local_en      (ld_wb_expt_clk_en  ), @308
//          .clk_out       (ld_wb_expt_clk     )); @309

//------------------data part gateclk-----------------------

assign ld_wb_data_clk_en =  lda_lwb_ex3_data_req_gateclk_en
                            || rb_lwb_ex3_data_req
                            || vmb_lwb_data_req
                            || wmb_lwb_data_req;  
// &Instance("gated_clk_cell", "x_lsu_ld_wb_data_gated_clk"); @317
gated_clk_cell  x_lsu_ld_wb_data_gated_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (ld_wb_data_clk    ),
  .external_en        (1'b0              ),
  .local_en           (ld_wb_data_clk_en ),
  .module_en          (cp0_lsu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect(.clk_in        (forever_cpuclk     ), @318
//          .external_en   (1'b0               ), @319
//          .module_en     (cp0_lsu_icg_en     ), @320
//          .local_en      (ld_wb_data_clk_en  ), @321
//          .clk_out       (ld_wb_data_clk     )); @322

assign ld_wb_preg_clk_en =  lda_lwb_ex3_data_req_gateclk_en
                                &&  !lda_ex3_inst_vfls
                            ||  rb_lwb_ex3_data_req
                                &&  !rb_lwb_ex3_inst_vfls
                            ||  wmb_lwb_data_req
                                &&  !wmb_lwb_inst_vfls;
// &Instance("gated_clk_cell", "x_lsu_ld_wb_preg_gated_clk"); @330
gated_clk_cell  x_lsu_ld_wb_preg_gated_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (ld_wb_preg_clk    ),
  .external_en        (1'b0              ),
  .local_en           (ld_wb_preg_clk_en ),
  .module_en          (cp0_lsu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect(.clk_in        (forever_cpuclk     ), @331
//          .external_en   (1'b0               ), @332
//          .module_en     (cp0_lsu_icg_en     ), @333
//          .local_en      (ld_wb_preg_clk_en  ), @334
//          .clk_out       (ld_wb_preg_clk     )); @335

assign ld_wb_vreg_clk_en =  lda_lwb_ex3_data_req_gateclk_en
                                &&  lda_ex3_inst_vfls
                            ||  rb_lwb_ex3_data_req
                                &&  rb_lwb_ex3_inst_vfls
                            ||  wmb_lwb_data_req
                                &&  wmb_lwb_inst_vfls
                            ||  vmb_lwb_data_req
                                &&  vmb_lwb_inst_vfls;

// &Instance("gated_clk_cell", "x_lsu_ld_wb_vreg_gated_clk"); @355
gated_clk_cell  x_lsu_ld_wb_vreg_gated_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (ld_wb_vreg_clk    ),
  .external_en        (1'b0              ),
  .local_en           (ld_wb_vreg_clk_en ),
  .module_en          (cp0_lsu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

assign ld_wb_vreg512_clk_en = lda_lwb_ex3_data_req_gateclk_en
                              & lda_ex3_inst_vfls & lda_ex3_inst_us
                            | rb_lwb_ex3_data_req
                              & rb_lwb_ex3_inst_vls & rb_lwb_ex3_inst_us
                            | vmb_lwb_data_req;

gated_clk_cell  x_lsu_ld_wb_vreg512_gated_clk (
  .clk_in             (forever_cpuclk       ),
  .clk_out            (ld_wb_vreg512_clk    ),
  .external_en        (1'b0                 ),
  .local_en           (ld_wb_vreg512_clk_en ),
  .module_en          (cp0_lsu_icg_en       ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en   )
);

// &Connect(.clk_in        (forever_cpuclk     ), @356
//          .external_en   (1'b0               ), @357
//          .module_en     (cp0_lsu_icg_en     ), @358
//          .local_en      (ld_wb_vreg_clk_en  ), @359
//          .clk_out       (ld_wb_vreg_clk     )); @360

//assign ld_wb_bus_err_info_clk_en  = rb_lwb_ex3_data_req
//                                    &&  rb_lwb_ex3_bus_err;
//&Instance("gated_clk_cell", "x_lsu_ld_wb_bus_err_info_gated_clk");
// //&Connect(.clk_in        (forever_cpuclk     ), @365
// //         .external_en   (1'b0               ), @366
// //         .module_en     (cp0_lsu_icg_en     ), @367
// //         .local_en      (ld_wb_bus_err_info_clk_en), @368
// //         .clk_out       (ld_wb_bus_err_info_clk)); @369

//==========================================================
//                 Pipeline Register
//==========================================================
//------------------complete part---------------------------
//+----------+----------+
//| inst_vld | expt_vld |
//+----------+----------+
// &Force("output","lwb_ex4_inst_vld"); @378
xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH)) 
x_lsu_ck_flush_compare_cmplt_iid (
  .x_iid0                    (rtu_ck_flush_iid[IID_WIDTH-1:0]      ),
  .x_iid0_older              (rtu_ck_flush_iid_older_than_cmplt_iid),
  .x_iid1                    (ld_wb_pre_iid[IID_WIDTH-1:0]    )      //should use ld_wb_pre_data_iid
);
//xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH)) 
//x_lsu_ck_flush_compare_data_iid (
//  .x_iid0                    (rtu_ck_flush_iid[IID_WIDTH-1:0]      ),
//  .x_iid0_older              (rtu_ck_flush_iid_older_than_data_iid ),
//  .x_iid1                    (ld_wb_pre_data_iid[IID_WIDTH-1:0]    )      //should use ld_wb_pre_data_iid
//);
always @(posedge ctrl_ld_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    lwb_ex4_inst_vld      <=  1'b0;
  else if(rtu_yy_xx_flush)
    lwb_ex4_inst_vld      <=  1'b0;
  else if(rtu_ck_flush && rtu_ck_flush_iid_older_than_cmplt_iid)    //flush younger ex3->ex4 inst_vld, ck_flush@LTL
    lwb_ex4_inst_vld      <=  1'b0;
  else if(ld_wb_pre_inst_vld)
    lwb_ex4_inst_vld      <=  1'b1;
  else
    lwb_ex4_inst_vld      <=  1'b0;
end

//+-----+---------------+-------+-------+
//| iid | rar_spec_fail | bkpta | bkptb |
//+-----+---------------+-------+-------+
always @(posedge ld_wb_cmplt_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    ld_wb_expt_vld        <=  1'b0;
    ld_wb_iid[IID_WIDTH-1:0]        <=  {IID_WIDTH{1'b0}};
    ld_wb_spec_fail       <=  1'b0;
    ld_wb_flush           <=  1'b0;
    ld_wb_no_spec_miss    <=  1'b0;
    ld_wb_no_spec_hit     <=  1'b0;
    ld_wb_no_spec_mispred <=  1'b0;
    ld_wb_no_spec_target  <=  1'b0;
    ld_wb_element_cnt[8:0]<=  9'b0;
    ld_wb_vstart_vld      <=  1'b0;
    ld_wb_vsetvl          <=  1'b0;
    ld_wb_cmplt_vmb_id[VMB_ENTRY-1:0] <= {VMB_ENTRY{1'b0}}; 
    ld_wb_cmplt_vmb_merge_vld         <= 1'b0;
    ld_wb_element_cnt_next[`VSTART_WIDTH-1:0]       <= `VSTART_WIDTH'b0; // Risc-V Debug zdb 
  end
  else if(ld_wb_pre_inst_vld)
  begin
    ld_wb_expt_vld        <=  ld_wb_pre_expt_vld;
    ld_wb_iid[IID_WIDTH-1:0]         <=  ld_wb_pre_iid[IID_WIDTH-1:0] ;
    ld_wb_spec_fail       <=  ld_wb_pre_spec_fail;
    ld_wb_flush           <=  ld_wb_pre_flush;
    ld_wb_no_spec_miss    <=  ld_wb_pre_no_spec_miss;
    ld_wb_no_spec_hit     <=  ld_wb_pre_no_spec_hit;
    ld_wb_no_spec_mispred <=  ld_wb_pre_no_spec_mispred;
    ld_wb_no_spec_target  <=  ld_wb_pre_no_spec_target;
    ld_wb_element_cnt[8:0]<=  ld_wb_pre_element_cnt[8:0];
    ld_wb_vstart_vld      <=  ld_wb_pre_vstart_vld;
    ld_wb_vsetvl          <=  ld_wb_pre_vsetvl;
    ld_wb_cmplt_vmb_id[VMB_ENTRY-1:0] <= ld_wb_pre_cmplt_vmb_id[VMB_ENTRY-1:0]; 
    ld_wb_cmplt_vmb_merge_vld         <= ld_wb_pre_cmplt_vmb_merge_vld;
    ld_wb_element_cnt_next[`VSTART_WIDTH-1:0]       <= ld_wb_pre_element_cnt_next[`VSTART_WIDTH-1:0]; // Risc-V Debug zdb
  end
end

//+----------+---------+-----------+
//| expt_vec | bad_vpn | dmmu_expt |
//+----------+---------+-----------+
always @(posedge ld_wb_expt_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    ld_wb_expt_vec[4:0]           <=  5'b0;
    ld_wb_mt_value[`WK_PA_WIDTH:0]   <=  {`WK_PA_WIDTH+1{1'b0}};
  end
  else if(ld_wb_pre_expt_vld || ld_wb_pre_vsetvl || lsu_any_trig_en & ld_wb_pre_halt_info[1]) // Risc-V Debug zdb
  begin
    ld_wb_expt_vec[4:0]           <=  ld_wb_pre_expt_vec[4:0];
    ld_wb_mt_value[`WK_PA_WIDTH:0]   <=  ld_wb_pre_mt_value_ext[`WK_PA_WIDTH:0];
  end
  else if(lsu_any_trig_en && rb_ld_wb_data_halt_info[0])
  begin
    ld_wb_expt_vec[4:0]           <=  5'b11;
    ld_wb_mt_value[`WK_PA_WIDTH:0]   <=  ld_wb_mt_value[`WK_PA_WIDTH:0];
  end
end

//------------------data part-------------------------------
//+----------+---------+
//| data_vld | bus_err |
//+----------+---------+
// &Force("output","lwb_ex4_data_vld"); @459
always @(posedge ctrl_ld_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    lwb_ex4_data_vld        <=  1'b0;
    ld_wb_preg_wb_vld       <=  1'b0;
    ld_wb_vreg_wb_vld       <=  1'b0;
  end
  else if(rtu_yy_xx_flush)
  begin
    lwb_ex4_data_vld        <=  1'b0;
    ld_wb_preg_wb_vld       <=  1'b0;
    ld_wb_vreg_wb_vld       <=  1'b0;
  end
  //else if(rtu_ck_flush && rtu_ck_flush_iid_older_than_data_iid) //when data req from rb, iid may be 0, RAW will starvation, so rtu_ck_flush no use here, ck_flush@LTL 
  //begin
  //  lwb_ex4_data_vld        <=  1'b0;
  //  ld_wb_preg_wb_vld       <=  1'b0;
  //  ld_wb_vreg_wb_vld       <=  1'b0;
  //
  //end
  else if(ld_wb_pre_data_vld)
  begin
    lwb_ex4_data_vld        <=  1'b1;
    ld_wb_preg_wb_vld       <=  ld_wb_pre_preg_wb_vld;
    ld_wb_vreg_wb_vld       <=  ld_wb_pre_vreg_wb_vld && !ld_wb_data_pre_vmb_merge_vld;
  end
  else
  begin
    lwb_ex4_data_vld        <=  1'b0;
    ld_wb_preg_wb_vld       <=  1'b0;
    ld_wb_vreg_wb_vld       <=  1'b0;
  end
end

always @(posedge ctrl_ld_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    ld_wb_data_vmb_merge_vld      <=  1'b0;
  end
  else if(rtu_yy_xx_flush)
  begin
    ld_wb_data_vmb_merge_vld      <=  1'b0;
  end
  //else if(rtu_ck_flush && rtu_ck_flush_iid_older_than_data_iid)
  //begin
  //  ld_wb_data_vmb_merge_vld      <=  1'b0;
  //end
  else if(ld_wb_pre_data_vld)
  begin
    ld_wb_data_vmb_merge_vld      <=  ld_wb_data_pre_vmb_merge_vld;
  end
  else
  begin
    ld_wb_data_vmb_merge_vld      <=  1'b0;
  end
end

always @(posedge ctrl_ld_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    ld_wb_bus_err       <=  1'b0;
  else if(rtu_yy_xx_flush)
    ld_wb_bus_err       <=  1'b0;
//  else if(rtu_ck_flush && rtu_ck_flush_iid_older_than_data_iid)
//    ld_wb_bus_err       <=  1'b0;
  else if(ld_wb_pre_data_vld)
    ld_wb_bus_err       <=  ld_wb_pre_bus_err;
  else
    ld_wb_bus_err       <=  1'b0;
end

always @(posedge ld_wb_data_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    ld_wb_data_addr[`WK_PA_WIDTH-1:0] <=  {`WK_PA_WIDTH{1'b0}};
    ld_wb_data_iid[IID_WIDTH-1:0]            <=  {IID_WIDTH{1'b0}};
  end
  else if(ld_wb_pre_data_vld)
  begin
    ld_wb_data_addr[`WK_PA_WIDTH-1:0] <=  ld_wb_pre_data_addr[`WK_PA_WIDTH-1:0];
    ld_wb_data_iid[IID_WIDTH-1:0]     <=  ld_wb_pre_data_iid[IID_WIDTH-1:0];
  end
end

// &Force("nonport", "ld_wb_dtcm_hit_fwd_sq_vld"); @573
// &Force("nonport", "ld_wb_fwd_sq_iid"); @574

//+------+----------+------+
//| data | sign_sel | sign |
//+------+----------+------+
always @(posedge ld_wb_data_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    ld_wb_data[63:0]              <=  64'b0;
  end
  else if(ld_wb_pre_data_vld)
  begin
    ld_wb_data[63:0]              <=  ld_wb_pre_data[63:0];
  end
end

always @(posedge ld_wb_vreg_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    ld_wb_data[127:64]            <=  64'b0;
  else if(ld_wb_pre_vreg_wb_vld)
    ld_wb_data[127:64]            <=  ld_wb_pre_data[127:64];
end

always @(posedge ld_wb_vreg512_clk or negedge cpurst_b)
begin
  if (!cpurst_b) begin 
    ld_wb_data1[127:0]            <=  128'b0;
    ld_wb_data2[127:0]            <=  128'b0;
    ld_wb_data3[127:0]            <=  128'b0;
  end
  else if(ld_wb_pre_vreg_wb_vld & ld_wb_pre_inst_us)
  begin
    ld_wb_data1[127:0]            <=  ld_wb_pre_data1[127:0];
    ld_wb_data2[127:0]            <=  ld_wb_pre_data2[127:0];
    ld_wb_data3[127:0]            <=  ld_wb_pre_data3[127:0];
  end 
end


//+------+
//| preg |
//+------+
always @(posedge ld_wb_preg_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    ld_wb_data_preg[PREG-1:0]          <= {PREG{1'b0}};
    ld_wb_data_preg_expand[PREG_N - 1:0]  <=  {PREG_N{1'b0}};
    ld_wb_preg_sign_sel[3:0]      <=  4'b0;
  end
  else if(ld_wb_pre_preg_wb_vld)
  begin
    ld_wb_data_preg[PREG-1:0]          <=  ld_wb_pre_preg[PREG-1:0];
    ld_wb_data_preg_expand[PREG_N - 1:0]  <=  ld_wb_pre_preg_expand[PREG_N - 1:0];
    ld_wb_preg_sign_sel[3:0]      <=  ld_wb_pre_preg_sign_sel[3:0];
  end
end

//+------+
//| vreg |
//+------+
always @(posedge ld_wb_vreg_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    ld_wb_data_vreg[VREG-1:0]     <=  {VREG{1'b0}};
    ld_wb_data_vreg_expand[63:0]  <=  64'b0;
    ld_wb_vreg_sign_sel[14:0]     <=  15'b0;
    ld_wb_inst_vls                <=  1'b0;
    ld_wb_reg_bytes_vld[15:0]     <=  16'b0;
    ld_wb_inst_us                 <=  1'b0;
    ld_wb_data_vmb_id[VMB_ENTRY-1:0] <= {VMB_ENTRY{1'b0}};
    ld_wb_data_element_cnt[8:0]   <=  9'b0;
    ld_wb_vmew[1:0]               <=  2'b0;
  end
  else if(ld_wb_pre_vreg_wb_vld)
  begin
    ld_wb_data_vreg[VREG-1:0]     <=  ld_wb_pre_vreg[VREG-1:0];
    ld_wb_data_vreg_expand[63:0]  <=  ld_wb_pre_vreg_expand[63:0];
    ld_wb_vreg_sign_sel[14:0]     <=  ld_wb_pre_vreg_sign_sel[14:0];
    ld_wb_inst_vls                <=  ld_wb_pre_inst_vls;
    ld_wb_reg_bytes_vld[15:0]     <=  ld_wb_pre_reg_bytes_vld[15:0];
    ld_wb_inst_us                 <=  ld_wb_pre_inst_us;
    ld_wb_data_vmb_id[VMB_ENTRY-1:0] <= ld_wb_pre_data_vmb_id[VMB_ENTRY-1:0];
    ld_wb_data_element_cnt[8:0]   <=  ld_wb_pre_data_element_cnt[8:0];
    ld_wb_vmew[1:0]               <=  ld_wb_pre_vmew[1:0];
  end
end

always @(posedge ld_wb_vreg512_clk or negedge cpurst_b)begin 
  if(!cpurst_b)begin
    ld_wb_reg_bytes_vld1[15:0]    <=  16'b0;
    ld_wb_reg_bytes_vld2[15:0]    <=  16'b0;
    ld_wb_reg_bytes_vld3[15:0]    <=  16'b0;
  end
  else if(ld_wb_pre_vreg_wb_vld & ld_wb_pre_inst_us)begin 
    ld_wb_reg_bytes_vld1[15:0]    <=  ld_wb_pre_reg_bytes_vld1[15:0];
    ld_wb_reg_bytes_vld2[15:0]    <=  ld_wb_pre_reg_bytes_vld2[15:0];
    ld_wb_reg_bytes_vld3[15:0]    <=  ld_wb_pre_reg_bytes_vld3[15:0];
  end
end
//==========================================================
//            Data settle and Sign extend
//==========================================================
//sign extend
assign ld_wb_data_sign0[63:0]       = ld_wb_data[63:0];
assign ld_wb_data_sign1[63:0]       = {{56{ld_wb_data[7]}},ld_wb_data[7:0]};
assign ld_wb_data_sign2[63:0]       = {{48{ld_wb_data[15]}},ld_wb_data[15:0]};
assign ld_wb_data_sign3[63:0]       = {{32{ld_wb_data[31]}},ld_wb_data[31:0]};

assign ld_wb_preg_data_sign_extend[63:0]  = {64{ld_wb_preg_sign_sel[3]}} & ld_wb_data_sign3[63:0]
                                            | {64{ld_wb_preg_sign_sel[2]}} & ld_wb_data_sign2[63:0]
                                            | {64{ld_wb_preg_sign_sel[1]}} & ld_wb_data_sign1[63:0]
                                            | {64{ld_wb_preg_sign_sel[0]}} & ld_wb_data_sign0[63:0];

//vector data
// &CombBeg; @719
always @( ld_wb_data[127:0]
       or ld_wb_vreg_sign_sel[14:0])
begin
case(ld_wb_vreg_sign_sel[14:0])
  15'h0001:ld_wb_vreg_data_sign_extend[127:0] = ld_wb_data[127:0];
  15'h0002:ld_wb_vreg_data_sign_extend[127:0] = {{8'b0,ld_wb_data[63:56]},
                                                 {8'b0,ld_wb_data[55:48]},
                                                 {8'b0,ld_wb_data[47:40]},
                                                 {8'b0,ld_wb_data[39:32]},
                                                 {8'b0,ld_wb_data[31:24]},
                                                 {8'b0,ld_wb_data[23:16]},
                                                 {8'b0,ld_wb_data[15:8]},
                                                 {8'b0,ld_wb_data[7:0]}};
  15'h0004:ld_wb_vreg_data_sign_extend[127:0] = {{{8{ld_wb_data[63]}},ld_wb_data[63:56]},
                                                 {{8{ld_wb_data[55]}},ld_wb_data[55:48]},
                                                 {{8{ld_wb_data[47]}},ld_wb_data[47:40]},
                                                 {{8{ld_wb_data[39]}},ld_wb_data[39:32]},
                                                 {{8{ld_wb_data[31]}},ld_wb_data[31:24]},
                                                 {{8{ld_wb_data[23]}},ld_wb_data[23:16]},
                                                 {{8{ld_wb_data[15]}},ld_wb_data[15:8]},
                                                 {{8{ld_wb_data[7]}},ld_wb_data[7:0]}};
  15'h0008:ld_wb_vreg_data_sign_extend[127:0] = {{24'b0,ld_wb_data[31:24]},
                                                 {24'b0,ld_wb_data[23:16]},
                                                 {24'b0,ld_wb_data[15:8]},
                                                 {24'b0,ld_wb_data[7:0]}};
  15'h0010:ld_wb_vreg_data_sign_extend[127:0] = {{{24{ld_wb_data[31]}},ld_wb_data[31:24]},
                                                 {{24{ld_wb_data[23]}},ld_wb_data[23:16]},
                                                 {{24{ld_wb_data[15]}},ld_wb_data[15:8]},
                                                 {{24{ld_wb_data[7] }},ld_wb_data[7:0]}};
  15'h0020:ld_wb_vreg_data_sign_extend[127:0] = {{56'b0,ld_wb_data[15:8]},
                                                 {56'b0,ld_wb_data[7:0]}};
  15'h0040:ld_wb_vreg_data_sign_extend[127:0] = {{{56{ld_wb_data[15]}},ld_wb_data[15:8]},
                                                 {{56{ld_wb_data[7] }},ld_wb_data[7:0]}};
  15'h0080:ld_wb_vreg_data_sign_extend[127:0] = {{16'b0,ld_wb_data[63:48]},
                                                 {16'b0,ld_wb_data[47:32]},
                                                 {16'b0,ld_wb_data[31:16]},
                                                 {16'b0,ld_wb_data[15:0]}};
  15'h0100:ld_wb_vreg_data_sign_extend[127:0] = {{{16{ld_wb_data[63]}},ld_wb_data[63:48]},
                                                 {{16{ld_wb_data[47]}},ld_wb_data[47:32]},
                                                 {{16{ld_wb_data[31]}},ld_wb_data[31:16]},
                                                 {{16{ld_wb_data[15]}},ld_wb_data[15:0]}};
  15'h0200:ld_wb_vreg_data_sign_extend[127:0] = {{48'b0,ld_wb_data[31:16]},
                                                 {48'b0,ld_wb_data[15:0]}};
  15'h0400:ld_wb_vreg_data_sign_extend[127:0] = {{{48{ld_wb_data[31]}},ld_wb_data[31:16]},
                                                 {{48{ld_wb_data[15]}},ld_wb_data[15:0]}};
  15'h0800:ld_wb_vreg_data_sign_extend[127:0] = {{32'b0,ld_wb_data[63:32]},
                                                 {32'b0,ld_wb_data[31:0]}};
  15'h1000:ld_wb_vreg_data_sign_extend[127:0] = {{{32{ld_wb_data[63]}},ld_wb_data[63:32]},
                                                 {{32{ld_wb_data[31]}},ld_wb_data[31:0]}};
  15'h2000:ld_wb_vreg_data_sign_extend[127:0] = {{112{1'b1}},ld_wb_data[15:0]};
  15'h4000:ld_wb_vreg_data_sign_extend[127:0] = {{96{1'b1}},ld_wb_data[31:0]};
  default:ld_wb_vreg_data_sign_extend[127:0]  = {128{1'bx}};
endcase
// &CombEnd; @770
end
// &CombBeg; @772
// &CombEnd; @778
always @*
begin 
  case(ld_wb_vmew)
  2'b00: ld_wb_128settle = ld_wb_data_element_cnt[5:4];
  2'b01: ld_wb_128settle = ld_wb_data_element_cnt[4:3];
  2'b10: ld_wb_128settle = ld_wb_data_element_cnt[3:2];
  2'b11: ld_wb_128settle = ld_wb_data_element_cnt[2:1];
  default: ld_wb_128settle = 2'bxx;
  endcase
end
//==========================================================
//                 Generate interface to vmb
//==========================================================
//cmplt part
assign ld_wb_vmb_cmplt_vld        = lwb_ex4_inst_vld
                                    && ld_wb_cmplt_vmb_merge_vld;
assign ld_wb_vmb_cmplt_expt       = ld_wb_expt_vld;
assign ld_wb_vmb_cmplt_vsetvl     = ld_wb_vsetvl;

assign ld_wb_vmb_cmplt_vmb_id[VMB_ENTRY-1:0] = ld_wb_cmplt_vmb_id[VMB_ENTRY-1:0];
assign ld_wb_vmb_cmplt_element_cnt[8:0]      = ld_wb_expt_vld
                                               ? ld_wb_element_cnt[8:0]
                                              //  : ld_wb_mt_value[13:5];  //for fof
                                               : ld_wb_mt_value[14:6];  //for fof   //pwh@260403                                              

//data part
assign ld_wb_vmb_data_merge_vld = ld_wb_data_vmb_merge_vld
                                  && !ld_wb_bus_err; 
// assign ld_wb_vmb_cmplt_data[127:0]    = ld_wb_vreg_data_sign_extend[127:0]; 
assign ld_wb_vmb_cmplt_data[127:0] = ld_wb_inst_us
                                     ? ld_wb_data[127:0]
                                     : (ld_wb_128settle == 2'b00)
                                       ? ld_wb_data[127:0]
                                       : 128'b0;
assign ld_wb_vmb_cmplt_data[255:128] = ld_wb_inst_us
                                       ? ld_wb_data1
                                       : (ld_wb_128settle == 2'b01)
                                         ? ld_wb_data
                                         : 128'b0;
assign ld_wb_vmb_cmplt_data[383:256] = ld_wb_inst_us
                                       ? ld_wb_data2
                                       : (ld_wb_128settle == 2'b10)
                                         ? ld_wb_data
                                         : 128'b0;
assign ld_wb_vmb_cmplt_data[511:384] = ld_wb_inst_us
                                       ? ld_wb_data3
                                       : (ld_wb_128settle == 2'b11)
                                         ? ld_wb_data
                                         : 128'b0;
assign ld_wb_vmb_bytes_vld[15:0]= ld_wb_inst_us
                                  ? ld_wb_reg_bytes_vld[15:0]
                                  : (ld_wb_128settle == 2'b00)
                                    ? ld_wb_reg_bytes_vld[15:0]
                                    : 16'b0;
assign ld_wb_vmb_bytes_vld[31:16] = ld_wb_inst_us
                                  ? ld_wb_reg_bytes_vld1[15:0]
                                  : (ld_wb_128settle == 2'b01)
                                    ? ld_wb_reg_bytes_vld[15:0]
                                    : 16'b0;
assign ld_wb_vmb_bytes_vld[47:32] = ld_wb_inst_us
                                  ? ld_wb_reg_bytes_vld2[15:0]
                                  : (ld_wb_128settle == 2'b10)
                                    ? ld_wb_reg_bytes_vld[15:0]
                                    : 16'b0;
assign ld_wb_vmb_bytes_vld[63:48] = ld_wb_inst_us
                                  ? ld_wb_reg_bytes_vld3[15:0]
                                  : (ld_wb_128settle == 2'b11)
                                    ? ld_wb_reg_bytes_vld[15:0]
                                    : 16'b0;

assign ld_wb_vmb_data_vmb_id[VMB_ENTRY-1:0] = ld_wb_data_vmb_id[VMB_ENTRY-1:0];

assign ld_wb_vmb_data_element_cnt[8:0] = ld_wb_data_element_cnt[8:0];

//for async expt,should not deadlock
assign ld_wb_vmb_data_async_vld = ld_wb_data_vmb_merge_vld
                                  && ld_wb_bus_err; 

//==========================================================
//                 Generate interface to rtu
//==========================================================
//------------------complete part---------------------------
assign lsu_rtu_ex4_cmplt         = ld_wb_halt_info[0]? 1'b1 : lwb_ex4_inst_vld;
assign lsu_rtu_ex4_iid[IID_WIDTH-1:0]       = ld_wb_iid[IID_WIDTH-1:0] ; 
assign lsu_rtu_ex4_expt_vld      = ld_wb_expt_vld;
assign lsu_rtu_ex4_expt_vec[4:0] = ld_wb_expt_vec[4:0];
assign lsu_rtu_ex4_mtval[`WK_PA_WIDTH:0]  = ld_wb_mt_value[`WK_PA_WIDTH:0];
assign lsu_rtu_ex4_spec_fail     = ld_wb_spec_fail;
assign lsu_rtu_ex4_flush         = ld_wb_flush;
assign lsu_rtu_ex4_abnormal      = ld_wb_expt_vld
                                        ||  ld_wb_flush
                                        ||  ld_wb_halt_info[0]; // Risc-V Debug zdb

assign lsu_rtu_ex4_no_spec_miss    = ld_wb_no_spec_miss;
assign lsu_rtu_ex4_no_spec_hit     = ld_wb_no_spec_hit;
assign lsu_rtu_ex4_no_spec_mispred = ld_wb_no_spec_mispred;
assign lsu_rtu_ex4_no_spec_target  = ld_wb_no_spec_target;

//for vstart
assign lsu_rtu_ex4_vstart_vld    = ld_wb_vstart_vld; 

// assign lsu_rtu_ex4_vstart[6:0]   = ld_wb_expt_vld
//                                         ? ld_wb_element_cnt[6:0]
//                                         : 7'b0;
//==========================================================
//                  Risc-V Debug zdb Begin (replace)
//==========================================================
always @*
begin
  if(ld_wb_expt_vld | ld_wb_halt_info[0])
    lsu_rtu_ex4_vstart[`VSTART_WIDTH-1:0]   = ld_wb_element_cnt[`VSTART_WIDTH-1:0];
  else if(ld_wb_halt_info[1])
    lsu_rtu_ex4_vstart[`VSTART_WIDTH-1:0]   = ld_wb_element_cnt_next[`VSTART_WIDTH-1:0];                                     
  else
    lsu_rtu_ex4_vstart[`VSTART_WIDTH-1:0]   = {`VSTART_WIDTH{1'b0}};   
//
end     
//==========================================================
//                  Risc-V Debug zdb End   (replace)
//==========================================================

//for vl
assign lsu_rtu_ex4_vsetvl        = ld_wb_vsetvl;
//------------------data part-------------------------------
assign lsu_rtu_ex4_preg_vld           = ld_wb_preg_wb_vld;
assign lsu_rtu_ex4_preg_expand[PREG_N - 1:0]  = ld_wb_data_preg_expand[PREG_N - 1:0];

assign lsu_rtu_async_expt_vld                 = lwb_ex4_data_vld
                                                    &&  ld_wb_bus_err;

assign lsu_rtu_async_expt_addr[`WK_PA_WIDTH-1:0] = (lwb_ex4_data_vld  &&  ld_wb_bus_err)
                                                ? ld_wb_data_addr[`WK_PA_WIDTH-1:0]
                                                : {`WK_PA_WIDTH{1'b0}};

assign lsu_idu_ex4_preg_vld           = ld_wb_preg_wb_vld;
assign lsu_idu_ex4_preg[PREG-1:0]          = ld_wb_data_preg[PREG-1:0];
assign lsu_idu_ex4_preg_expand[PREG_N - 1:0]  = ld_wb_data_preg_expand[PREG_N - 1:0];
assign lsu_idu_ex4_preg_data[63:0]    = ld_wb_preg_data_sign_extend[63:0];

//------------------for vector------------------------
assign lsu_rtu_ex4_vreg_fr_vld       = ld_wb_vreg_wb_vld && !ld_wb_inst_vls;
assign lsu_rtu_ex4_vreg_vr_vld       = ld_wb_vreg_wb_vld && ld_wb_inst_vls;
assign lsu_rtu_ex4_vreg_expand[63:0] = ld_wb_data_vreg_expand[63:0];

assign lsu_idu_ex4_vreg_vr0_vld          = ld_wb_vreg_wb_vld && ld_wb_inst_vls;
assign lsu_idu_ex4_vreg_vr0_expand[63:0] = ld_wb_data_vreg_expand[63:0];
assign lsu_idu_ex4_vreg_vr0_data[255:0]  = {ld_wb_data1[127:0], ld_wb_data[127:0]};
assign lsu_idu_ex4_vreg_vr1_vld          = ld_wb_vreg_wb_vld && ld_wb_inst_vls;
assign lsu_idu_ex4_vreg_vr1_expand[63:0] = ld_wb_data_vreg_expand[63:0];
assign lsu_idu_ex4_vreg_vr1_data[255:0]  = {ld_wb_data3[127:0], ld_wb_data2[127:0]};

assign lsu_idu_ex4_vreg_vld              = ld_wb_vreg_wb_vld;
assign lsu_idu_ex4_vreg[VREG:0]          = {ld_wb_inst_vls,ld_wb_data_vreg[VREG-1:0]};
assign lsu_idu_ex4_vreg_fr_vld           = ld_wb_vreg_wb_vld && !ld_wb_inst_vls;
assign lsu_idu_ex4_vreg_fr_expand[63:0]  = ld_wb_data_vreg_expand[63:0];
assign lsu_idu_ex4_vreg_fr_data[63:0]    = ld_wb_vreg_data_sign_extend[63:0];
assign lsu_idu_ex4_fwd_vreg_vld  = ld_wb_vreg_wb_vld;
assign lsu_idu_ex4_fwd_vreg[VREG:0] = {ld_wb_inst_vls,ld_wb_data_vreg[VREG-1:0]};

//==========================================================
//                 Generate interface to rtu
//==========================================================

//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
assign ld_wb_pre_element_cnt_next[`VSTART_WIDTH-1:0] = ld_wb_pre_element_cnt[`VSTART_WIDTH-1:0] + {{(`VSTART_WIDTH-1){1'b0}},1'b1};

assign lsu_rtu_ex4_lsupipe_halt_info[`TDT_MP_HINFO_WIDTH-1:0]      = ld_wb_halt_info[`TDT_MP_HINFO_WIDTH-1:0];

assign ld_wb_pre_halt_info[`TDT_MP_HINFO_WIDTH-1:0] = 
                       {`TDT_MP_HINFO_WIDTH{~lwb_rb_ex3_cmplt_grnt}} & ld_da_halt_info_am[`TDT_MP_HINFO_WIDTH-1:0]
                       | {`TDT_MP_HINFO_WIDTH{lwb_rb_ex3_cmplt_grnt}} & rb_ld_wb_halt_info_am[`TDT_MP_HINFO_WIDTH-1:0];

always @(posedge ld_wb_cmplt_clk or negedge cpurst_b)
begin
  if(~cpurst_b)
    ld_wb_halt_info[`TDT_MP_HINFO_WIDTH-1:0]  <= {`TDT_MP_HINFO_WIDTH{1'b0}};
  else if(ld_wb_pre_inst_vld & lsu_any_trig_en)
    ld_wb_halt_info[`TDT_MP_HINFO_WIDTH-1:0]  <= ld_wb_pre_halt_info[`TDT_MP_HINFO_WIDTH-1:0];
  else if(rb_data_halt_info_update_vld)
    ld_wb_halt_info[`TDT_MP_HINFO_WIDTH-1:0]  <= rb_ld_wb_data_halt_info[`TDT_MP_HINFO_WIDTH-1:0];
  else if(ld_wb_halt_info_effect)
    ld_wb_halt_info[`TDT_MP_HINFO_WIDTH-1:0]  <= {`TDT_MP_HINFO_WIDTH{1'b0}};
end
assign ld_wb_halt_info_effect = ld_wb_halt_info[1];

//-----------signal select--------------
assign ld_wb_pre_data_vld_dp       = lda_lwb_ex3_data_req_dp
                                    |  wmb_lwb_data_req
                                    |  vmb_lwb_data_req
                                    |  rb_lwb_ex3_data_req;
assign ld_wb_pre_data_check                               = lwb_rb_ex3_data_grnt & rb_ld_wb_data_check;
assign ld_wb_pre_data_halt_info[`TDT_MP_HINFO_WIDTH-1:0]  = rb_ld_wb_data_halt_info[`TDT_MP_HINFO_WIDTH-1:0];
assign ld_wb_pre_inst_size[2:0]                           = rb_ld_wb_inst_size[2:0];
assign ld_wb_pre_rb_data_ptr[RBENTRY-1:0]                = rb_ld_wb_data_ptr[RBENTRY-1:0];

always @(posedge ctrl_ld_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    ld_wb_dtu_data_vld    <=  1'b0;
  else if(rtu_yy_xx_flush)
    ld_wb_dtu_data_vld    <=  1'b0;
  else if(ld_wb_pre_data_vld)
    ld_wb_dtu_data_vld    <=  ld_wb_pre_data_check;
  else
    ld_wb_dtu_data_vld    <=  1'b0;
end

always @(posedge ld_wb_data_clk or negedge cpurst_b)
begin
  if (~cpurst_b)
  begin
    ld_wb_rb_data_ptr[RBENTRY-1:0]      <= {RBENTRY{1'b0}};
    ld_wb_dtu_data_size[2:0]    <= {3{1'b0}};
    ld_wb_inst_vfls             <=  1'b0;
    ld_wb_dtu_data_halt_info[`TDT_MP_HINFO_WIDTH-1:0] <= {`TDT_MP_HINFO_WIDTH{1'b0}};
  end
  else if(ld_wb_pre_data_vld_dp)
  begin 
    ld_wb_rb_data_ptr[RBENTRY-1:0]      <= ld_wb_pre_rb_data_ptr[RBENTRY-1:0];
    ld_wb_dtu_data_size[2:0]    <= ld_wb_pre_inst_size[2:0];
    ld_wb_inst_vfls             <=  ld_wb_pre_inst_vfls;
    ld_wb_dtu_data_halt_info[`TDT_MP_HINFO_WIDTH-1:0] <= ld_wb_pre_data_halt_info[`TDT_MP_HINFO_WIDTH-1:0];
  end
end

//----------------------------------------------------------
//                 Generate interface to rtu
//----------------------------------------------------------
assign ld_dtu_data_clk_en  = ld_wb_dtu_data_vld
                          |  lsu_dtu_data_vld
                            |  ld_dtu2_vld;
// &Instance("gated_clk_cell", "x_lsu_wb_dbg_gated_clk"); @963
com_root_gated_clk_cell  x_lsu_dtu_data_gated_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (ld_dtu_data_clk   ),
  .external_en        (1'b0              ),
  .local_en           (ld_dtu_data_clk_en),
  .module_en          (cp0_lsu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect(.clk_in        (forever_cpuclk     ), @964
//          .external_en   (1'b0               ), @965
//          .module_en     (cp0_lsu_icg_en     ), @966
//          .local_en      (wb_dbg_clk_en      ), @967
//          .clk_out       (wb_dbg_clk         )); @968
 
//
//
//
always @(posedge ld_dtu_data_clk or negedge cpurst_b)
begin
  if (~cpurst_b)
    lsu_dtu_data_vld  <=  1'b0;
  else if(rtu_yy_xx_flush)
    lsu_dtu_data_vld  <=  1'b0;
  else if(ld_wb_dtu_data_vld)
    lsu_dtu_data_vld  <=  1'b1;
  else
    lsu_dtu_data_vld  <=  1'b0;
end

assign ld_wb_data_for_check[63:0] = ld_wb_inst_vfls
                                    ? ld_wb_vreg_data_sign_extend[63:0]  // Risc-V Debug zdb check
                                    : ld_wb_preg_data_sign_extend[63:0];
//                                    
always @(posedge ld_dtu_data_clk or negedge cpurst_b)
begin
  if (~cpurst_b)
  begin
    ld_dtu1_rb_data_ptr[RBENTRY-1:0]  <=  {RBENTRY{1'b0}};
    lsu_dtu_data_size[2:0]   <=  {3{1'b0}};
    lsu_dtu_data_halt_info[`TDT_MP_HINFO_WIDTH-1:0]   <=  {`TDT_MP_HINFO_WIDTH{1'b0}};
    lsu_dtu_data[63:0]       <=  {64{1'b0}};
  end
  else if(ld_wb_dtu_data_vld)
  begin
    ld_dtu1_rb_data_ptr[RBENTRY-1:0]  <=  ld_wb_rb_data_ptr[RBENTRY-1:0] ;
    lsu_dtu_data_size[2:0]   <=  ld_wb_dtu_data_size[2:0];
    lsu_dtu_data_halt_info[`TDT_MP_HINFO_WIDTH-1:0]   <=  ld_wb_dtu_data_halt_info[`TDT_MP_HINFO_WIDTH-1:0];
    lsu_dtu_data[63:0]       <=  ld_wb_data_for_check[63:0];
  end
end
assign lsu_dtu_data_type[1:0] = 2'b10;

//
//
always @(posedge ld_dtu_data_clk or negedge cpurst_b)
begin
  if (~cpurst_b)
    ld_dtu2_vld <= 1'b0;
  else if(rtu_yy_xx_flush)
    ld_dtu2_vld <= 1'b0;
  else if(lsu_dtu_data_vld)
    ld_dtu2_vld <= 1'b1;
  else
    ld_dtu2_vld <= 1'b0; 
end

always @(posedge ld_dtu_data_clk or negedge cpurst_b)
begin
  if (~cpurst_b)
    ld_dtu2_rb_data_ptr[RBENTRY-1:0] <= {RBENTRY{1'b0}};
  else if(lsu_dtu_data_vld)
    ld_dtu2_rb_data_ptr[RBENTRY-1:0] <= ld_dtu1_rb_data_ptr[RBENTRY-1:0];
end

assign rb_entry_data_halt_info_update_vld[RBENTRY-1:0] = {RBENTRY{ld_dtu2_vld}}
                                                 & ld_dtu2_rb_data_ptr[RBENTRY-1:0];

always @(posedge ld_wb_data_clk or negedge cpurst_b)
begin
  if (~cpurst_b)
    rb_data_halt_info_update_vld <= 1'b0;
  else if(|rb_entry_data_halt_info_update_vld[RBENTRY-1:0])
    rb_data_halt_info_update_vld <= 1'b1;
  else
    rb_data_halt_info_update_vld <= 1'b0;
end

//==========================================================
//                  Risc-V Debug zdb End
//==========================================================                                                 
// &ModuleEnd; @1094
endmodule


