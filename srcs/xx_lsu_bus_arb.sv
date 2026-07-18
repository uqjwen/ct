//-----------------------------------------------------------------------------
// File          : xx_lsu_bus_arb.v
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


// $Id: xx_lsu_bus_arb.vp,v 1.22 2022/01/06 08:14:34 jizk Exp $
// *****************************************************************************

// &ModuleBeg; @23
module xx_lsu_bus_arb(
  biu_lsu_ar_ready,
  biu_lsu_aw_vb_grnt,
  biu_lsu_aw_wmb_grnt,
  biu_lsu_w_vb_grnt,
  biu_lsu_w_wmb_grnt,
  bus_arb_pfu_ar_grnt,
  bus_arb_pfu_ar_ready,
  bus_arb_pfu_ar_sel,
  bus_arb_rb_ar_grnt,
  bus_arb_rb_ar_sel,
  bus_arb_vb_aw_grnt,
  bus_arb_vb_w_grnt,
  bus_arb_wmb_ar_grnt,
  bus_arb_wmb_aw_grnt,
  bus_arb_wmb_w_grnt,
  cp0_lsu_icg_en,
  cpurst_b,
  forever_cpuclk,
  lsu_biu_ar_addr,
  lsu_biu_ar_bar,
  lsu_biu_ar_burst,
  lsu_biu_ar_cache,
  lsu_biu_ar_domain,
  lsu_biu_ar_dp_req,
  lsu_biu_ar_id,
  lsu_biu_ar_len,
  lsu_biu_ar_lock,
  lsu_biu_ar_prot,
  lsu_biu_ar_req,
  lsu_biu_ar_req_gate,
  lsu_biu_ar_size,
  lsu_biu_ar_snoop,
  lsu_biu_ar_user,
  lsu_biu_aw_req_gate,
  lsu_biu_aw_st_addr,
  lsu_biu_aw_st_bar,
  lsu_biu_aw_st_burst,
  lsu_biu_aw_st_cache,
  lsu_biu_aw_st_domain,
  lsu_biu_aw_st_dp_req,
  lsu_biu_aw_st_id,
  lsu_biu_aw_st_len,
  lsu_biu_aw_st_lock,
  lsu_biu_aw_st_prot,
  lsu_biu_aw_st_req,
  lsu_biu_aw_st_size,
  lsu_biu_aw_st_snoop,
  lsu_biu_aw_st_unique,
  lsu_biu_aw_st_user,
  lsu_biu_aw_viwk_addr,
  lsu_biu_aw_viwk_bar,
  lsu_biu_aw_viwk_burst,
  lsu_biu_aw_viwk_cache,
  lsu_biu_aw_viwk_domain,
  lsu_biu_aw_viwk_dp_req,
  lsu_biu_aw_viwk_id,
  lsu_biu_aw_viwk_len,
  lsu_biu_aw_viwk_lock,
  lsu_biu_aw_viwk_prot,
  lsu_biu_aw_viwk_req,
  lsu_biu_aw_viwk_size,
  lsu_biu_aw_viwk_snoop,
  lsu_biu_aw_viwk_unique,
  lsu_biu_aw_viwk_user,
  lsu_biu_w_st_data,
  lsu_biu_w_st_err,
  lsu_biu_w_st_last,
  lsu_biu_w_st_strb,
  lsu_biu_w_st_vld,
  lsu_biu_w_st_wns,
  lsu_biu_w_viwk_data,
  lsu_biu_w_viwk_err,
  lsu_biu_w_viwk_last,
  lsu_biu_w_viwk_strb,
  lsu_biu_w_viwk_vld,
  lsu_biu_w_viwk_wns,
  pad_yy_icg_scan_en,
  pfu_biu_ar_addr,
  pfu_biu_ar_bar,
  pfu_biu_ar_burst,
  pfu_biu_ar_cache,
  pfu_biu_ar_domain,
  pfu_biu_ar_dp_req,
  pfu_biu_ar_id,
  pfu_biu_ar_len,
  pfu_biu_ar_lock,
  pfu_biu_ar_prot,
  pfu_biu_ar_req,
  pfu_biu_ar_req_gateclk_en,
  pfu_biu_ar_size,
  pfu_biu_ar_snoop,
  pfu_biu_ar_user,
  rb_biu_ar_addr,
  rb_biu_ar_bar,
  rb_biu_ar_burst,
  rb_biu_ar_cache,
  rb_biu_ar_domain,
  rb_biu_ar_dp_req,
  rb_biu_ar_id,
  rb_biu_ar_len,
  rb_biu_ar_lock,
  rb_biu_ar_prot,
  rb_biu_ar_req,
  rb_biu_ar_req_gateclk_en,
  rb_biu_ar_size,
  rb_biu_ar_snoop,
  rb_biu_ar_user,
  vb_biu_aw_addr,
  vb_biu_aw_bar,
  vb_biu_aw_burst,
  vb_biu_aw_cache,
  vb_biu_aw_domain,
  vb_biu_aw_dp_req,
  vb_biu_aw_id,
  vb_biu_aw_len,
  vb_biu_aw_lock,
  vb_biu_aw_prot,
  vb_biu_aw_req,
  vb_biu_aw_req_gateclk_en,
  vb_biu_aw_size,
  vb_biu_aw_snoop,
  vb_biu_aw_unique,
  vb_biu_aw_user,
  vb_biu_w_data,
  vb_biu_w_err,
  vb_biu_w_id,
  vb_biu_w_last,
  vb_biu_w_req,
  vb_biu_w_strb,
  vb_biu_w_vld,
  wmb_biu_ar_addr,
  wmb_biu_ar_bar,
  wmb_biu_ar_burst,
  wmb_biu_ar_cache,
  wmb_biu_ar_domain,
  wmb_biu_ar_dp_req,
  wmb_biu_ar_id,
  wmb_biu_ar_len,
  wmb_biu_ar_lock,
  wmb_biu_ar_prot,
  wmb_biu_ar_req,
  wmb_biu_ar_req_gateclk_en,
  wmb_biu_ar_size,
  wmb_biu_ar_snoop,
  wmb_biu_ar_user,
  wmb_biu_aw_addr,
  wmb_biu_aw_bar,
  wmb_biu_aw_burst,
  wmb_biu_aw_cache,
  wmb_biu_aw_domain,
  wmb_biu_aw_dp_req,
  wmb_biu_aw_id,
  wmb_biu_aw_len,
  wmb_biu_aw_lock,
  wmb_biu_aw_prot,
  wmb_biu_aw_req,
  wmb_biu_aw_req_gateclk_en,
  wmb_biu_aw_size,
  wmb_biu_aw_snoop,
  wmb_biu_aw_user,
  wmb_biu_w_data,
  wmb_biu_w_id,
  wmb_biu_w_last,
  wmb_biu_w_req,
  wmb_biu_w_strb,
  wmb_biu_w_vld,
  wmb_biu_w_wns
);

// &Ports; @24
input                           biu_lsu_ar_ready;          
input                           biu_lsu_aw_vb_grnt;        
input                           biu_lsu_aw_wmb_grnt;       
input                           biu_lsu_w_vb_grnt;         
input                           biu_lsu_w_wmb_grnt;        
input                           cp0_lsu_icg_en;            
input                           cpurst_b;                  
input                           forever_cpuclk;            
input                           pad_yy_icg_scan_en;        
input   [`WK_PA_WIDTH-1:0]      pfu_biu_ar_addr;           
input   [1  :0]                 pfu_biu_ar_bar;            
input   [1  :0]                 pfu_biu_ar_burst;          
input   [3  :0]                 pfu_biu_ar_cache;          
input   [1  :0]                 pfu_biu_ar_domain;         
input                           pfu_biu_ar_dp_req;         
input   [4  :0]                 pfu_biu_ar_id;             
input   [1  :0]                 pfu_biu_ar_len;            
input                           pfu_biu_ar_lock;           
input   [2  :0]                 pfu_biu_ar_prot;           
input                           pfu_biu_ar_req;            
input                           pfu_biu_ar_req_gateclk_en; 
input   [2  :0]                 pfu_biu_ar_size;           
input   [3  :0]                 pfu_biu_ar_snoop;          
input   [8  :0]                 pfu_biu_ar_user;           
input   [`WK_PA_WIDTH-1:0]      rb_biu_ar_addr;            
input   [1  :0]                 rb_biu_ar_bar;             
input   [1  :0]                 rb_biu_ar_burst;           
input   [3  :0]                 rb_biu_ar_cache;           
input   [1  :0]                 rb_biu_ar_domain;          
input                           rb_biu_ar_dp_req;          
input   [4  :0]                 rb_biu_ar_id;              
input   [1  :0]                 rb_biu_ar_len;             
input                           rb_biu_ar_lock;            
input   [2  :0]                 rb_biu_ar_prot;            
input                           rb_biu_ar_req;             
input                           rb_biu_ar_req_gateclk_en;  
input   [2  :0]                 rb_biu_ar_size;            
input   [3  :0]                 rb_biu_ar_snoop;           
input   [3  :0]                 rb_biu_ar_user;            
input   [`WK_PA_WIDTH-1:0]      vb_biu_aw_addr;            
input   [1  :0]                 vb_biu_aw_bar;             
input   [1  :0]                 vb_biu_aw_burst;           
input   [3  :0]                 vb_biu_aw_cache;           
input   [1  :0]                 vb_biu_aw_domain;          
input                           vb_biu_aw_dp_req;          
input   [4  :0]                 vb_biu_aw_id;              
input   [1  :0]                 vb_biu_aw_len;             
input                           vb_biu_aw_lock;            
input   [2  :0]                 vb_biu_aw_prot;            
input                           vb_biu_aw_req;             
input                           vb_biu_aw_req_gateclk_en;  
input   [2  :0]                 vb_biu_aw_size;            
input   [2  :0]                 vb_biu_aw_snoop;           
input                           vb_biu_aw_unique;          
input   [1  :0]                 vb_biu_aw_user;            
input   [127:0]                 vb_biu_w_data;             
input                           vb_biu_w_err;              
input   [4  :0]                 vb_biu_w_id;               
input                           vb_biu_w_last;             
input                           vb_biu_w_req;              
input   [15 :0]                 vb_biu_w_strb;             
input                           vb_biu_w_vld;              
input   [`WK_PA_WIDTH-1:0]      wmb_biu_ar_addr;           
input   [1  :0]                 wmb_biu_ar_bar;            
input   [1  :0]                 wmb_biu_ar_burst;          
input   [3  :0]                 wmb_biu_ar_cache;          
input   [1  :0]                 wmb_biu_ar_domain;         
input                           wmb_biu_ar_dp_req;         
input   [4  :0]                 wmb_biu_ar_id;             
input   [1  :0]                 wmb_biu_ar_len;            
input                           wmb_biu_ar_lock;           
input   [2  :0]                 wmb_biu_ar_prot;           
input                           wmb_biu_ar_req;            
input                           wmb_biu_ar_req_gateclk_en; 
input   [2  :0]                 wmb_biu_ar_size;           
input   [3  :0]                 wmb_biu_ar_snoop;          
input   [3  :0]                 wmb_biu_ar_user;           
input   [`WK_PA_WIDTH-1:0]      wmb_biu_aw_addr;           
input   [1  :0]                 wmb_biu_aw_bar;            
input   [1  :0]                 wmb_biu_aw_burst;          
input   [3  :0]                 wmb_biu_aw_cache;          
input   [1  :0]                 wmb_biu_aw_domain;         
input                           wmb_biu_aw_dp_req;         
input   [4  :0]                 wmb_biu_aw_id;             
input   [1  :0]                 wmb_biu_aw_len;            
input                           wmb_biu_aw_lock;           
input   [2  :0]                 wmb_biu_aw_prot;           
input                           wmb_biu_aw_req;            
input                           wmb_biu_aw_req_gateclk_en; 
input   [2  :0]                 wmb_biu_aw_size;           
input   [2  :0]                 wmb_biu_aw_snoop;          
input   [1  :0]                 wmb_biu_aw_user;           
input   [127:0]                 wmb_biu_w_data;            
input   [4  :0]                 wmb_biu_w_id;              
input                           wmb_biu_w_last;            
input                           wmb_biu_w_req;             
input   [15 :0]                 wmb_biu_w_strb;            
input                           wmb_biu_w_vld;             
input                           wmb_biu_w_wns;             
output                          bus_arb_pfu_ar_grnt;       
output                          bus_arb_pfu_ar_ready;      
output                          bus_arb_pfu_ar_sel;        
output                          bus_arb_rb_ar_grnt;        
output                          bus_arb_rb_ar_sel;         
output                          bus_arb_vb_aw_grnt;        
output                          bus_arb_vb_w_grnt;         
output                          bus_arb_wmb_ar_grnt;       
output                          bus_arb_wmb_aw_grnt;       
output                          bus_arb_wmb_w_grnt;        
output  [`WK_PA_WIDTH-1:0]      lsu_biu_ar_addr;           
output  [1  :0]                 lsu_biu_ar_bar;            
output  [1  :0]                 lsu_biu_ar_burst;          
output  [3  :0]                 lsu_biu_ar_cache;          
output  [1  :0]                 lsu_biu_ar_domain;         
output                          lsu_biu_ar_dp_req;         
output  [4  :0]                 lsu_biu_ar_id;             
output  [1  :0]                 lsu_biu_ar_len;            
output                          lsu_biu_ar_lock;           
output  [2  :0]                 lsu_biu_ar_prot;           
output                          lsu_biu_ar_req;            
output                          lsu_biu_ar_req_gate;       
output  [2  :0]                 lsu_biu_ar_size;           
output  [3  :0]                 lsu_biu_ar_snoop;          
output  [8  :0]                 lsu_biu_ar_user;           
output                          lsu_biu_aw_req_gate;       
output  [`WK_PA_WIDTH-1:0]      lsu_biu_aw_st_addr;        
output  [1  :0]                 lsu_biu_aw_st_bar;         
output  [1  :0]                 lsu_biu_aw_st_burst;       
output  [3  :0]                 lsu_biu_aw_st_cache;       
output  [1  :0]                 lsu_biu_aw_st_domain;      
output                          lsu_biu_aw_st_dp_req;      
output  [4  :0]                 lsu_biu_aw_st_id;          
output  [1  :0]                 lsu_biu_aw_st_len;         
output                          lsu_biu_aw_st_lock;        
output  [2  :0]                 lsu_biu_aw_st_prot;        
output                          lsu_biu_aw_st_req;         
output  [2  :0]                 lsu_biu_aw_st_size;        
output  [2  :0]                 lsu_biu_aw_st_snoop;       
output                          lsu_biu_aw_st_unique;      
output  [1  :0]                 lsu_biu_aw_st_user;        
output  [`WK_PA_WIDTH-1:0]      lsu_biu_aw_viwk_addr;      
output  [1  :0]                 lsu_biu_aw_viwk_bar;       
output  [1  :0]                 lsu_biu_aw_viwk_burst;     
output  [3  :0]                 lsu_biu_aw_viwk_cache;     
output  [1  :0]                 lsu_biu_aw_viwk_domain;    
output                          lsu_biu_aw_viwk_dp_req;    
output  [4  :0]                 lsu_biu_aw_viwk_id;        
output  [1  :0]                 lsu_biu_aw_viwk_len;       
output                          lsu_biu_aw_viwk_lock;      
output  [2  :0]                 lsu_biu_aw_viwk_prot;      
output                          lsu_biu_aw_viwk_req;       
output  [2  :0]                 lsu_biu_aw_viwk_size;      
output  [2  :0]                 lsu_biu_aw_viwk_snoop;     
output                          lsu_biu_aw_viwk_unique;    
output  [1  :0]                 lsu_biu_aw_viwk_user;      
output  [127:0]                 lsu_biu_w_st_data;         
output                          lsu_biu_w_st_err;          
output                          lsu_biu_w_st_last;         
output  [15 :0]                 lsu_biu_w_st_strb;         
output                          lsu_biu_w_st_vld;          
output                          lsu_biu_w_st_wns;          
output  [127:0]                 lsu_biu_w_viwk_data;       
output                          lsu_biu_w_viwk_err;        
output                          lsu_biu_w_viwk_last;       
output  [15 :0]                 lsu_biu_w_viwk_strb;       
output                          lsu_biu_w_viwk_vld;        
output                          lsu_biu_w_viwk_wns;        

// &Regs; @25               
reg                             bus_arb_pfu_mask;          
reg                             bus_arb_rb_mask;           
reg                             bus_arb_wmb_mask;          

// &Wires; @26                
wire                            biu_lsu_ar_ready;          
wire                            biu_lsu_aw_vb_grnt;        
wire                            biu_lsu_aw_wmb_grnt;       
wire                            biu_lsu_w_vb_grnt;         
wire                            biu_lsu_w_wmb_grnt;        
wire                            bus_arb_mask_clk;          
wire                            bus_arb_mask_clk_en;       
wire                            bus_arb_pfu_ar_dp_req_real; 
wire                            bus_arb_pfu_ar_grnt;       
wire                            bus_arb_pfu_ar_ready;      
wire                            bus_arb_pfu_ar_sel;        
wire                            bus_arb_rb_ar_dp_req_real; 
wire                            bus_arb_rb_ar_grnt;        
wire                            bus_arb_rb_ar_sel;         
wire                            bus_arb_vb_aw_grnt;        
wire                            bus_arb_vb_w_grnt;         
wire                            bus_arb_wmb_ar_dp_req_real; 
wire                            bus_arb_wmb_ar_grnt;       
wire                            bus_arb_wmb_ar_sel;        
wire                            bus_arb_wmb_aw_grnt;       
wire                            bus_arb_wmb_w_grnt;        
wire                            cp0_lsu_icg_en;            
wire                            cpurst_b;                  
wire                            forever_cpuclk;            
wire    [`WK_PA_WIDTH-1:0]      lsu_biu_ar_addr;           
wire    [1  :0]                 lsu_biu_ar_bar;            
wire    [1  :0]                 lsu_biu_ar_burst;          
wire    [3  :0]                 lsu_biu_ar_cache;          
wire    [1  :0]                 lsu_biu_ar_domain;         
wire                            lsu_biu_ar_dp_req;         
wire    [4  :0]                 lsu_biu_ar_id;             
wire    [1  :0]                 lsu_biu_ar_len;            
wire                            lsu_biu_ar_lock;           
wire    [2  :0]                 lsu_biu_ar_prot;           
wire                            lsu_biu_ar_req;            
wire                            lsu_biu_ar_req_gate;       
wire    [2  :0]                 lsu_biu_ar_size;           
wire    [3  :0]                 lsu_biu_ar_snoop;          
wire    [8  :0]                 lsu_biu_ar_user;           
wire                            lsu_biu_aw_req_gate;       
wire    [`WK_PA_WIDTH-1:0]      lsu_biu_aw_st_addr;        
wire    [1  :0]                 lsu_biu_aw_st_bar;         
wire    [1  :0]                 lsu_biu_aw_st_burst;       
wire    [3  :0]                 lsu_biu_aw_st_cache;       
wire    [1  :0]                 lsu_biu_aw_st_domain;      
wire                            lsu_biu_aw_st_dp_req;      
wire    [4  :0]                 lsu_biu_aw_st_id;          
wire    [1  :0]                 lsu_biu_aw_st_len;         
wire                            lsu_biu_aw_st_lock;        
wire    [2  :0]                 lsu_biu_aw_st_prot;        
wire                            lsu_biu_aw_st_req;         
wire    [2  :0]                 lsu_biu_aw_st_size;        
wire    [2  :0]                 lsu_biu_aw_st_snoop;       
wire                            lsu_biu_aw_st_unique;      
wire    [1  :0]                 lsu_biu_aw_st_user;        
wire    [`WK_PA_WIDTH-1:0]      lsu_biu_aw_viwk_addr;      
wire    [1  :0]                 lsu_biu_aw_viwk_bar;       
wire    [1  :0]                 lsu_biu_aw_viwk_burst;     
wire    [3  :0]                 lsu_biu_aw_viwk_cache;     
wire    [1  :0]                 lsu_biu_aw_viwk_domain;    
wire                            lsu_biu_aw_viwk_dp_req;    
wire    [4  :0]                 lsu_biu_aw_viwk_id;        
wire    [1  :0]                 lsu_biu_aw_viwk_len;       
wire                            lsu_biu_aw_viwk_lock;      
wire    [2  :0]                 lsu_biu_aw_viwk_prot;      
wire                            lsu_biu_aw_viwk_req;       
wire    [2  :0]                 lsu_biu_aw_viwk_size;      
wire    [2  :0]                 lsu_biu_aw_viwk_snoop;     
wire                            lsu_biu_aw_viwk_unique;    
wire    [1  :0]                 lsu_biu_aw_viwk_user;      
wire    [127:0]                 lsu_biu_w_st_data;         
wire                            lsu_biu_w_st_err;          
wire                            lsu_biu_w_st_last;         
wire    [15 :0]                 lsu_biu_w_st_strb;         
wire                            lsu_biu_w_st_vld;          
wire                            lsu_biu_w_st_wns;          
wire    [127:0]                 lsu_biu_w_viwk_data;       
wire                            lsu_biu_w_viwk_err;        
wire                            lsu_biu_w_viwk_last;       
wire    [15 :0]                 lsu_biu_w_viwk_strb;       
wire                            lsu_biu_w_viwk_vld;        
wire                            lsu_biu_w_viwk_wns;        
wire                            pad_yy_icg_scan_en;        
wire    [`WK_PA_WIDTH-1:0]      pfu_biu_ar_addr;           
wire    [1  :0]                 pfu_biu_ar_bar;            
wire    [1  :0]                 pfu_biu_ar_burst;          
wire    [3  :0]                 pfu_biu_ar_cache;          
wire    [1  :0]                 pfu_biu_ar_domain;         
wire                            pfu_biu_ar_dp_req;         
wire    [4  :0]                 pfu_biu_ar_id;             
wire    [1  :0]                 pfu_biu_ar_len;            
wire                            pfu_biu_ar_lock;           
wire    [2  :0]                 pfu_biu_ar_prot;           
wire                            pfu_biu_ar_req;            
wire                            pfu_biu_ar_req_gateclk_en; 
wire    [2  :0]                 pfu_biu_ar_size;           
wire    [3  :0]                 pfu_biu_ar_snoop;          
wire    [8  :0]                 pfu_biu_ar_user;           
wire    [`WK_PA_WIDTH-1:0]      rb_biu_ar_addr;            
wire    [1  :0]                 rb_biu_ar_bar;             
wire    [1  :0]                 rb_biu_ar_burst;           
wire    [3  :0]                 rb_biu_ar_cache;           
wire    [1  :0]                 rb_biu_ar_domain;          
wire                            rb_biu_ar_dp_req;          
wire    [4  :0]                 rb_biu_ar_id;              
wire    [1  :0]                 rb_biu_ar_len;             
wire                            rb_biu_ar_lock;            
wire    [2  :0]                 rb_biu_ar_prot;            
wire                            rb_biu_ar_req;             
wire                            rb_biu_ar_req_gateclk_en;  
wire    [2  :0]                 rb_biu_ar_size;            
wire    [3  :0]                 rb_biu_ar_snoop;           
wire    [3  :0]                 rb_biu_ar_user;            
wire    [`WK_PA_WIDTH-1:0]      vb_biu_aw_addr;            
wire    [1  :0]                 vb_biu_aw_bar;             
wire    [1  :0]                 vb_biu_aw_burst;           
wire    [3  :0]                 vb_biu_aw_cache;           
wire    [1  :0]                 vb_biu_aw_domain;          
wire                            vb_biu_aw_dp_req;          
wire    [4  :0]                 vb_biu_aw_id;              
wire    [1  :0]                 vb_biu_aw_len;             
wire                            vb_biu_aw_lock;            
wire    [2  :0]                 vb_biu_aw_prot;            
wire                            vb_biu_aw_req;             
wire                            vb_biu_aw_req_gateclk_en;  
wire    [2  :0]                 vb_biu_aw_size;            
wire    [2  :0]                 vb_biu_aw_snoop;           
wire                            vb_biu_aw_unique;          
wire    [1  :0]                 vb_biu_aw_user;            
wire    [127:0]                 vb_biu_w_data;             
wire                            vb_biu_w_err;              
wire                            vb_biu_w_last;             
wire                            vb_biu_w_req;              
wire    [15 :0]                 vb_biu_w_strb;             
wire                            vb_biu_w_vld;              
wire    [`WK_PA_WIDTH-1:0]      wmb_biu_ar_addr;           
wire    [1  :0]                 wmb_biu_ar_bar;            
wire    [1  :0]                 wmb_biu_ar_burst;          
wire    [3  :0]                 wmb_biu_ar_cache;          
wire    [1  :0]                 wmb_biu_ar_domain;         
wire                            wmb_biu_ar_dp_req;         
wire    [4  :0]                 wmb_biu_ar_id;             
wire    [1  :0]                 wmb_biu_ar_len;            
wire                            wmb_biu_ar_lock;           
wire    [2  :0]                 wmb_biu_ar_prot;           
wire                            wmb_biu_ar_req;            
wire                            wmb_biu_ar_req_gateclk_en; 
wire    [2  :0]                 wmb_biu_ar_size;           
wire    [3  :0]                 wmb_biu_ar_snoop;          
wire    [3  :0]                 wmb_biu_ar_user;           
wire    [`WK_PA_WIDTH-1:0]      wmb_biu_aw_addr;           
wire    [1  :0]                 wmb_biu_aw_bar;            
wire    [1  :0]                 wmb_biu_aw_burst;          
wire    [3  :0]                 wmb_biu_aw_cache;          
wire    [1  :0]                 wmb_biu_aw_domain;         
wire                            wmb_biu_aw_dp_req;         
wire    [4  :0]                 wmb_biu_aw_id;             
wire    [1  :0]                 wmb_biu_aw_len;            
wire                            wmb_biu_aw_lock;           
wire    [2  :0]                 wmb_biu_aw_prot;           
wire                            wmb_biu_aw_req;            
wire                            wmb_biu_aw_req_gateclk_en; 
wire    [2  :0]                 wmb_biu_aw_size;           
wire    [2  :0]                 wmb_biu_aw_snoop;          
wire    [1  :0]                 wmb_biu_aw_user;           
wire    [127:0]                 wmb_biu_w_data;            
wire                            wmb_biu_w_last;            
wire                            wmb_biu_w_req;             
wire    [15 :0]                 wmb_biu_w_strb;            
wire                            wmb_biu_w_vld;             
wire                            wmb_biu_w_wns;             


parameter W_FIFO_ENTRY  = 12;
parameter WU            = 3'b000;
parameter WLU           = 3'b001;
//==========================================================
//                 Instance of Gated Cell  
//==========================================================
assign bus_arb_mask_clk_en  = rb_biu_ar_req_gateclk_en
                              ||  wmb_biu_ar_req_gateclk_en
															||	pfu_biu_ar_req_gateclk_en
                              ||  bus_arb_wmb_mask
                              ||  bus_arb_rb_mask
                              ||  bus_arb_pfu_mask;
// &Instance("gated_clk_cell", "x_lsu_bus_arb_mask_gated_clk"); @40
gated_clk_cell  x_lsu_bus_arb_mask_gated_clk (
  .clk_in              (forever_cpuclk     ),
  .clk_out             (bus_arb_mask_clk   ),
  .external_en         (1'b0               ),
  .local_en            (bus_arb_mask_clk_en),
  .module_en           (cp0_lsu_icg_en     ),
  .pad_yy_icg_scan_en  (pad_yy_icg_scan_en )
);

// &Connect(.clk_in        (forever_cpuclk     ), @41
//          .external_en   (1'b0               ), @42
//          .module_en     (cp0_lsu_icg_en     ), @43
//          .local_en      (bus_arb_mask_clk_en), @44
//          .clk_out       (bus_arb_mask_clk   )); @45

//==========================================================
//                    Mask Register
//==========================================================
always @(posedge bus_arb_mask_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    bus_arb_wmb_mask    <=  1'b0;
  else if(wmb_biu_ar_dp_req &&  !wmb_biu_ar_req)
    bus_arb_wmb_mask    <=  1'b1;
  else
    bus_arb_wmb_mask    <=  1'b0;
end

always @(posedge bus_arb_mask_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    bus_arb_rb_mask    <=  1'b0;
  else if(rb_biu_ar_dp_req &&  !rb_biu_ar_req)
    bus_arb_rb_mask    <=  1'b1;
  else
    bus_arb_rb_mask    <=  1'b0;
end

always @(posedge bus_arb_mask_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    bus_arb_pfu_mask    <=  1'b0;
  else if(pfu_biu_ar_dp_req &&  !pfu_biu_ar_req)
    bus_arb_pfu_mask    <=  1'b1;
  else
    bus_arb_pfu_mask    <=  1'b0;
end

//==========================================================
//                      AR channel
//==========================================================
//priority: WMB > RB > pfu
//-----------------generate grnt signal---------------------
assign bus_arb_wmb_ar_dp_req_real = wmb_biu_ar_dp_req
                                    &&  !bus_arb_wmb_mask;
assign bus_arb_rb_ar_dp_req_real  = rb_biu_ar_dp_req
                                    &&  !bus_arb_rb_mask;
assign bus_arb_pfu_ar_dp_req_real = pfu_biu_ar_dp_req
                                    &&  !bus_arb_pfu_mask;

assign bus_arb_wmb_ar_sel   = bus_arb_wmb_ar_dp_req_real;
assign bus_arb_wmb_ar_grnt  = biu_lsu_ar_ready
                              &&  bus_arb_wmb_ar_sel
                              &&  wmb_biu_ar_req;

// &Force("output","bus_arb_rb_ar_sel"); @97
assign bus_arb_rb_ar_sel    = !bus_arb_wmb_ar_dp_req_real
                              &&  bus_arb_rb_ar_dp_req_real;
assign bus_arb_rb_ar_grnt   = biu_lsu_ar_ready
                              &&  bus_arb_rb_ar_sel
                              &&  rb_biu_ar_req;

// &Force("output","bus_arb_pfu_ar_sel"); @104
assign bus_arb_pfu_ar_sel   = !bus_arb_wmb_ar_dp_req_real
                              &&  !bus_arb_rb_ar_dp_req_real
                              &&  bus_arb_pfu_ar_dp_req_real;
assign bus_arb_pfu_ar_grnt  = biu_lsu_ar_ready
                              &&  bus_arb_pfu_ar_sel
                              &&  pfu_biu_ar_req;
assign bus_arb_pfu_ar_ready = biu_lsu_ar_ready
                              &&  bus_arb_pfu_ar_sel;
//-----------------biu ar signal----------------------------
assign lsu_biu_ar_id[4:0]     = {5{bus_arb_wmb_ar_sel}}     & wmb_biu_ar_id[4:0]
                                | {5{bus_arb_rb_ar_sel}}    & rb_biu_ar_id[4:0]
                                | {5{bus_arb_pfu_ar_sel}}   & pfu_biu_ar_id[4:0];

assign lsu_biu_ar_addr[`WK_PA_WIDTH-1:0]  = {`WK_PA_WIDTH{bus_arb_wmb_ar_sel}}    & wmb_biu_ar_addr[`WK_PA_WIDTH-1:0]
                                | {`WK_PA_WIDTH{bus_arb_rb_ar_sel}}   & rb_biu_ar_addr[`WK_PA_WIDTH-1:0]
                                | {`WK_PA_WIDTH{bus_arb_pfu_ar_sel}}  & pfu_biu_ar_addr[`WK_PA_WIDTH-1:0];

assign lsu_biu_ar_len[1:0]    = {2{bus_arb_wmb_ar_sel}}     & wmb_biu_ar_len[1:0]
                                | {2{bus_arb_rb_ar_sel}}    & rb_biu_ar_len[1:0]
                                | {2{bus_arb_pfu_ar_sel}}   & pfu_biu_ar_len[1:0];

assign lsu_biu_ar_size[2:0]   = {3{bus_arb_wmb_ar_sel}}     & wmb_biu_ar_size[2:0]
                                | {3{bus_arb_rb_ar_sel}}    & rb_biu_ar_size[2:0]
                                | {3{bus_arb_pfu_ar_sel}}   & pfu_biu_ar_size[2:0];

assign lsu_biu_ar_burst[1:0]  = {2{bus_arb_wmb_ar_sel}}     & wmb_biu_ar_burst[1:0]
                                | {2{bus_arb_rb_ar_sel}}    & rb_biu_ar_burst[1:0]
                                | {2{bus_arb_pfu_ar_sel}}   & pfu_biu_ar_burst[1:0];

assign lsu_biu_ar_lock        = bus_arb_wmb_ar_sel        &&  wmb_biu_ar_lock
                                ||  bus_arb_rb_ar_sel     &&  rb_biu_ar_lock
                                ||  bus_arb_pfu_ar_sel    &&  pfu_biu_ar_lock;

assign lsu_biu_ar_cache[3:0]  = {4{bus_arb_wmb_ar_sel}}     & wmb_biu_ar_cache[3:0]
                                | {4{bus_arb_rb_ar_sel}}    & rb_biu_ar_cache[3:0]
                                | {4{bus_arb_pfu_ar_sel}}   & pfu_biu_ar_cache[3:0];

assign lsu_biu_ar_prot[2:0]   = {3{bus_arb_wmb_ar_sel}}     & wmb_biu_ar_prot[2:0]
                                | {3{bus_arb_rb_ar_sel}}    & rb_biu_ar_prot[2:0]
                                | {3{bus_arb_pfu_ar_sel}}   & pfu_biu_ar_prot[2:0];

assign lsu_biu_ar_req         = bus_arb_wmb_ar_sel  &&  wmb_biu_ar_req
                                ||  bus_arb_rb_ar_sel &&  rb_biu_ar_req
                                ||  bus_arb_pfu_ar_sel  &&  pfu_biu_ar_req;

assign lsu_biu_ar_dp_req      = bus_arb_wmb_ar_dp_req_real
                                ||  bus_arb_rb_ar_dp_req_real
                                ||  bus_arb_pfu_ar_dp_req_real;

assign lsu_biu_ar_req_gate    = wmb_biu_ar_req_gateclk_en
                                ||  rb_biu_ar_req_gateclk_en
                                ||  pfu_biu_ar_req_gateclk_en;

assign lsu_biu_ar_user[8:0]   = {9{bus_arb_wmb_ar_sel}}  & {5'b0, wmb_biu_ar_user[3:0]}
                                | {9{bus_arb_rb_ar_sel}}  & {5'b0, rb_biu_ar_user[3:0]}
                                | {9{bus_arb_pfu_ar_sel}}  & pfu_biu_ar_user[8:0];

assign lsu_biu_ar_snoop[3:0]  = {4{bus_arb_wmb_ar_sel}}     & wmb_biu_ar_snoop[3:0]
                                | {4{bus_arb_rb_ar_sel}}    & rb_biu_ar_snoop[3:0]
                                | {4{bus_arb_pfu_ar_sel}}   & pfu_biu_ar_snoop[3:0];

assign lsu_biu_ar_domain[1:0] = {2{bus_arb_wmb_ar_sel}}     &  wmb_biu_ar_domain[1:0]
                                | {2{bus_arb_rb_ar_sel}}    &  rb_biu_ar_domain[1:0]
                                | {2{bus_arb_pfu_ar_sel}}   &  pfu_biu_ar_domain[1:0];

assign lsu_biu_ar_bar[1:0]    = {2{bus_arb_wmb_ar_sel}}     &  wmb_biu_ar_bar[1:0]
                                | {2{bus_arb_rb_ar_sel}}    &  rb_biu_ar_bar[1:0]
                                | {2{bus_arb_pfu_ar_sel}}   &  pfu_biu_ar_bar[1:0];

//==========================================================
//                      AW channel
//==========================================================
//priority: VB>WMB
//-----------------generate grnt signal---------------------
//for timing,generate total grnt here
//assign aw_ws = bus_arb_wmb_aw_sel
//               && (((wmb_biu_aw_snoop[2:0] == WU)
//                        || (wmb_biu_aw_snoop[2:0] == WLU))
//                     && (wmb_biu_aw_domain[1:0] == 2'b01)
//                   || wmb_biu_aw_bar[0]);

//assign biu_lsu_aw_grnt      = aw_ws & pad_biu_ws_awready | !aw_ws & pad_biu_wns_awready;

//assign bus_arb_vb_aw_sel    = vb_biu_aw_dp_req;
// &Force("output","bus_arb_vb_aw_grnt"); @189
assign bus_arb_vb_aw_grnt   = biu_lsu_aw_vb_grnt
                              &&  vb_biu_aw_req;

//assign bus_arb_wmb_aw_sel   = !vb_biu_aw_dp_req
//                              &&  wmb_biu_aw_dp_req;
// &Force("output","bus_arb_wmb_aw_grnt"); @195
assign bus_arb_wmb_aw_grnt  = biu_lsu_aw_wmb_grnt
                              &&  wmb_biu_aw_req;
//-----------------biu aw signal----------------------------
assign lsu_biu_aw_viwk_req                 = vb_biu_aw_req;
assign lsu_biu_aw_viwk_dp_req              = vb_biu_aw_dp_req;
assign lsu_biu_aw_viwk_id[4:0]             = vb_biu_aw_id[4:0];
assign lsu_biu_aw_viwk_addr[`WK_PA_WIDTH-1:0] = vb_biu_aw_addr[`WK_PA_WIDTH-1:0]; 
assign lsu_biu_aw_viwk_len[1:0]            = vb_biu_aw_len[1:0];
assign lsu_biu_aw_viwk_size[2:0]           = vb_biu_aw_size[2:0];
assign lsu_biu_aw_viwk_burst[1:0]          = vb_biu_aw_burst[1:0];
assign lsu_biu_aw_viwk_lock                = vb_biu_aw_lock;
assign lsu_biu_aw_viwk_cache[3:0]          = vb_biu_aw_cache[3:0];
assign lsu_biu_aw_viwk_prot[2:0]           = vb_biu_aw_prot[2:0];
assign lsu_biu_aw_viwk_user[1:0]           = vb_biu_aw_user[1:0];
assign lsu_biu_aw_viwk_snoop[2:0]          = vb_biu_aw_snoop[2:0];
assign lsu_biu_aw_viwk_domain[1:0]         = vb_biu_aw_domain[1:0];
assign lsu_biu_aw_viwk_bar[1:0]            = vb_biu_aw_bar[1:0];
assign lsu_biu_aw_viwk_unique              = vb_biu_aw_unique;

assign lsu_biu_aw_st_req                   = wmb_biu_aw_req;
assign lsu_biu_aw_st_dp_req                = wmb_biu_aw_dp_req;
assign lsu_biu_aw_st_id[4:0]               = wmb_biu_aw_id[4:0];
assign lsu_biu_aw_st_addr[`WK_PA_WIDTH-1:0]   = wmb_biu_aw_addr[`WK_PA_WIDTH-1:0]; 
assign lsu_biu_aw_st_len[1:0]              = wmb_biu_aw_len[1:0];
assign lsu_biu_aw_st_size[2:0]             = wmb_biu_aw_size[2:0];
assign lsu_biu_aw_st_burst[1:0]            = wmb_biu_aw_burst[1:0];
assign lsu_biu_aw_st_lock                  = wmb_biu_aw_lock;
assign lsu_biu_aw_st_cache[3:0]            = wmb_biu_aw_cache[3:0];
assign lsu_biu_aw_st_prot[2:0]             = wmb_biu_aw_prot[2:0];
assign lsu_biu_aw_st_user[1:0]             = wmb_biu_aw_user[1:0];
assign lsu_biu_aw_st_snoop[2:0]            = wmb_biu_aw_snoop[2:0];
assign lsu_biu_aw_st_domain[1:0]           = wmb_biu_aw_domain[1:0];
assign lsu_biu_aw_st_bar[1:0]              = wmb_biu_aw_bar[1:0];
assign lsu_biu_aw_st_unique                = 1'b0;


assign lsu_biu_aw_req_gate    = vb_biu_aw_req_gateclk_en
                                ||  wmb_biu_aw_req_gateclk_en;

//==========================================================
//                        W channel
//==========================================================
//assign bus_arb_vb_w_sel   = bus_arb_w_fifo[0]
//                            &&  !bus_arb_w_fifo_empty;
//assign bus_arb_wmb_w_sel  = !bus_arb_w_fifo[0]
//                            &&  !bus_arb_w_fifo_empty;

assign bus_arb_vb_w_grnt  = biu_lsu_w_vb_grnt
                            &&  vb_biu_w_req;
assign bus_arb_wmb_w_grnt = biu_lsu_w_wmb_grnt
                            &&  wmb_biu_w_req;

assign lsu_biu_w_viwk_vld         = vb_biu_w_vld;
assign lsu_biu_w_viwk_data[127:0] = vb_biu_w_data[127:0];
assign lsu_biu_w_viwk_strb[15:0]  = vb_biu_w_strb[15:0];
assign lsu_biu_w_viwk_last        = vb_biu_w_last;
assign lsu_biu_w_viwk_wns         = 1'b1;

assign lsu_biu_w_st_vld           = wmb_biu_w_vld;
assign lsu_biu_w_st_data[127:0]   = wmb_biu_w_data[127:0];
assign lsu_biu_w_st_strb[15:0]    = wmb_biu_w_strb[15:0];
assign lsu_biu_w_st_last          = wmb_biu_w_last;
assign lsu_biu_w_st_wns           = wmb_biu_w_wns;

assign lsu_biu_w_viwk_err         = vb_biu_w_err;
assign lsu_biu_w_st_err           = 1'b0;

// &Force("input","vb_biu_w_id"); @265
// &Force("input","wmb_biu_w_id"); @266
// &Force("bus","vb_biu_w_id",4,0); @267
// &Force("bus","wmb_biu_w_id",4,0); @268


// &Force("output","lsu_biu_ar_dp_req"); @272

//==========================================================
//                        assertion
//==========================================================
// &Force("output", "lsu_biu_ar_addr"); @281
// &Force("nonport", "ar_addr_hit_dtcm"); @282
// &Instance("xx_lsu_dtcm_sel", "x_lsu_ar_addr_dtcm_compare"); @283
// &Connect(.lsu_chk_addr  (lsu_biu_ar_addr), @284
//          .chk_dtcm_sel  (ar_addr_hit_dtcm)); @285
// &Force("output", "lsu_biu_aw_st_addr"); @287
// &Force("nonport", "aw_st_addr_hit_dtcm"); @288
// &Instance("xx_lsu_dtcm_sel", "x_lsu_aw_st_addr_dtcm_compare"); @289
// &Connect(.lsu_chk_addr  (lsu_biu_aw_st_addr), @290
//          .chk_dtcm_sel  (aw_st_addr_hit_dtcm)); @291
// &Force("output", "lsu_biu_aw_viwk_addr"); @293
// &Force("nonport", "aw_viwk_addr_hit_dtcm"); @294
// &Instance("xx_lsu_dtcm_sel", "x_lsu_aw_viwk_addr_dtcm_compare"); @295
// &Connect(.lsu_chk_addr  (lsu_biu_aw_viwk_addr), @296
//          .chk_dtcm_sel  (aw_viwk_addr_hit_dtcm)); @297

// &ModuleEnd; @300
endmodule


