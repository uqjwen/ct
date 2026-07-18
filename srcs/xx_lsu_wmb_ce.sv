//-----------------------------------------------------------------------------
// File          : xx_lsu_wmb_ce.v
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


// $Id: xx_lsu_wmb_ce.vp,v 1.18 2022/01/06 08:14:36 jizk Exp $
// *****************************************************************************

// &ModuleBeg; @24
module xx_lsu_wmb_ce #(
  parameter SQ_ENTRY    = 12,
  parameter WMB_ENTRY   = 8,
  parameter PREG        = 7
)(
// &Ports; @25
input logic                                     cp0_lsu_icg_en,                   
input logic                                     cpurst_b,                         
input logic                                     forever_cpuclk,                   
input logic                                     lm_sq_sc_fail,                    
input logic                                     pad_yy_icg_scan_en,               
input logic                                     rb_wmb_ce_hit_idx,                
input logic                                     rtu_lsu_async_flush,              
input logic   [`WK_PA_WIDTH-1:0]                sq_pop_addr,                      
input logic                                     sq_pop_atomic,                    
input logic   [15:0]                            sq_pop_bytes_vld,                 
input logic                                     sq_pop_dtcm_hit,                  
input logic                                     sq_pop_icc,                       
input logic   [PREG-1:0]                        sq_pop_preg,
input logic                                     sq_pop_inst_flush,                
input logic   [1 :0]                            sq_pop_inst_mode,                 
input logic   [2 :0]                            sq_pop_inst_size,                 
input logic   [1 :0]                            sq_pop_inst_type,                 
input logic                                     sq_pop_itcm_hit,                  
input logic                                     sq_pop_page_buf,                  
input logic                                     sq_pop_page_ca,                   
input logic                                     sq_pop_page_sec,                  
input logic                                     sq_pop_page_share,                
input logic                                     sq_pop_page_so,                   
input logic                                     sq_pop_page_wa,                   
input logic   [1 :0]                            sq_pop_priv_mode,                 
input logic   [SQ_ENTRY-1:0]                    sq_pop_ptr,                       
input logic                                     sq_pop_sync_fence,                
input logic                                     sq_pop_wo_st,                     
input logic   [WMB_ENTRY-1:0]                   wmb_ce_create_depd_val,           
input logic                                     wmb_ce_create_dp_vld,             
input logic                                     wmb_ce_create_gateclk_en,         
input logic                                     wmb_ce_create_hit_rb_idx,         
input logic                                     wmb_ce_create_merge,              
input logic   [WMB_ENTRY-1:0]                   wmb_ce_create_merge_ptr,          
input logic   [WMB_ENTRY-1:0]                   wmb_ce_create_same_dcache_line,   
input logic                                     wmb_ce_create_stall,              
input logic                                     wmb_ce_create_vld,                
input logic                                     wmb_ce_dcache_share,              
input logic                                     wmb_ce_dcache_valid,              
input logic                                     wmb_ce_lm_fail,                   
input logic                                     wmb_ce_pop_vld,                   
input logic                                     wmb_clk,                          
input logic   [WMB_ENTRY-1:0]                   wmb_entry_vld,                    
output logic  [`WK_PA_WIDTH-1:0]                wmb_ce_addr,                      
output logic                                    wmb_ce_atomic,                    
output logic  [15:0]                            wmb_ce_bytes_vld,                 
output logic                                    wmb_ce_bytes_vld_full,            
output logic                                    wmb_ce_ca_st_inst,                
output logic                                    wmb_ce_create_wmb_data_req,       
output logic                                    wmb_ce_create_wmb_dp_req,         
output logic                                    wmb_ce_create_wmb_gateclk_en,     
output logic                                    wmb_ce_create_wmb_req,            
output logic  [3 :0]                            wmb_ce_data_vld,                  
output logic                                    wmb_ce_dcache_1line_inst,         
output logic                                    wmb_ce_dcache_inst,               
output logic                                    wmb_ce_dcache_sw_inst,            
output logic                                    wmb_ce_dtcm_hit,                  
output logic                                    wmb_ce_hit_sq_pop_dcache_line,    
output logic                                    wmb_ce_icc,                       
output logic  [PREG-1:0]                        wmb_ce_preg,
output logic                                    wmb_ce_inst_flush,                
output logic  [1 :0]                            wmb_ce_inst_mode,                 
output logic  [2 :0]                            wmb_ce_inst_size,                 
output logic  [1 :0]                            wmb_ce_inst_type,                 
output logic                                    wmb_ce_itcm_hit,                  
output logic                                    wmb_ce_merge_data_addr_hit,       
output logic                                    wmb_ce_merge_data_stall,          
output logic                                    wmb_ce_merge_en,                  
output logic  [WMB_ENTRY-1:0]                   wmb_ce_merge_ptr,                 
output logic                                    wmb_ce_merge_wmb_req,             
output logic                                    wmb_ce_merge_wmb_wait_not_vld_req, 
output logic                                    wmb_ce_page_buf,                  
output logic                                    wmb_ce_page_ca,                   
output logic                                    wmb_ce_page_sec,                  
output logic                                    wmb_ce_page_share,                
output logic                                    wmb_ce_page_so,                   
output logic                                    wmb_ce_page_wa,                   
output logic  [1 :0]                            wmb_ce_priv_mode,                 
output logic                                    wmb_ce_read_dp_req,               
output logic  [WMB_ENTRY-1:0]                   wmb_ce_same_dcache_line,          
output logic                                    wmb_ce_sc_wb_vld,                 
output logic                                    wmb_ce_sq_pop_sameline_set,       
output logic  [SQ_ENTRY-1:0]                    wmb_ce_sq_ptr,                    
output logic                                    wmb_ce_st_inst,                   
output logic                                    wmb_ce_sync_fence,                
output logic                                    wmb_ce_vld,                       
output logic                                    wmb_ce_wb_cmplt_success,          
output logic                                    wmb_ce_wb_data_success,           
output logic                                    wmb_ce_write_biu_dp_req,          
output logic                                    wmb_ce_write_imme,
//==========================================================
//                  Risc-V Debug zdb Begin 
//==========================================================
input  logic                                    dtu_lsu_data_trig_en
//==========================================================
//                  Risc-V Debug zdb End 
//==========================================================    
);

             

// &Regs; @26
              
logic     [WMB_ENTRY-1:0]                       wmb_ce_depd_val;                                
logic                                           wmb_ce_hit_rb_idx;                
logic                                           wmb_ce_hit_rb_idx_ff;                  
logic                                           wmb_ce_merge;                                      
logic                                           wmb_ce_stall;                                        
logic                                           wmb_ce_wo_st;                     

// &Wires; @27                  
logic                                           wmb_ce_create_clk;                
logic                                           wmb_ce_create_clk_en;                                       
logic                                           wmb_ce_ctc_inst;                       
logic                                           wmb_ce_dcache_addr_inst;          
logic                                           wmb_ce_dcache_addr_not_l1_inst;   
logic                                           wmb_ce_dcache_all_inst;                             
logic    [WMB_ENTRY-1:0]                        wmb_ce_depd_val_and_vld;          
logic                                           wmb_ce_depd_vld;                  
logic                                           wmb_ce_hit_rb_idx_set;            
logic                                           wmb_ce_hit_sq_pop_addr_5to4;      
logic                                           wmb_ce_hit_sq_pop_addr_tto4;      
logic                                           wmb_ce_hit_sq_pop_addr_tto6;      
logic                                           wmb_ce_hit_sq_pop_bytes_vld;            
logic                                           wmb_ce_merge_data_permit;                      
logic                                           wmb_ce_merge_not_vld;             
logic    [WMB_ENTRY-1:0]                        wmb_ce_merge_ptr_and_not_vld;         
logic                                           wmb_ce_sc_inst;                   
logic                                           wmb_ce_so_st_inst;                
logic                                           wmb_ce_stamo_inst;                
logic                                           wmb_ce_sync_fence_inst;           
logic                                           wmb_ce_tlbi_asid_inst;            
logic                                           wmb_ce_tlbi_inst;                       
logic                                           wmb_ce_wo_st_inst;                       
logic                                           wmb_ce_write_data_inst;                          


//parameter SQ_ENTRY    = 12,  //defined in front, LTL@20241023
//          WMB_ENTRY   = 8;

//==========================================================
//                 Instance of Gated Cell  
//==========================================================
//--------create update gateclk---------
assign wmb_ce_create_clk_en  = wmb_ce_create_gateclk_en;
// &Instance("gated_clk_cell", "x_lsu_wmb_ce_create_gated_clk"); @37
gated_clk_cell  x_lsu_wmb_ce_create_gated_clk (
  .clk_in               (forever_cpuclk      ),
  .clk_out              (wmb_ce_create_clk   ),
  .external_en          (1'b0                ),
  .local_en             (wmb_ce_create_clk_en),
  .module_en            (cp0_lsu_icg_en      ),
  .pad_yy_icg_scan_en   (pad_yy_icg_scan_en  )
);

// &Connect(.clk_in        (forever_cpuclk     ), @38
//          .external_en   (1'b0               ), @39
//          .module_en     (cp0_lsu_icg_en     ), @40
//          .local_en      (wmb_ce_create_clk_en), @41
//          .clk_out       (wmb_ce_create_clk)); @42

//==========================================================
//                 Register
//==========================================================
//+-----+
//| vld |
//+-----+
// &Force("output","wmb_ce_vld"); @50
always @(posedge wmb_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    wmb_ce_vld              <=  1'b0;
  else if(rtu_lsu_async_flush)
    wmb_ce_vld              <=  1'b0;
  else if(wmb_ce_create_vld)
    wmb_ce_vld              <=  1'b1;
  else if(wmb_ce_pop_vld)
    wmb_ce_vld              <=  1'b0;
end

//+------------+
//| hit rb idx |
//+------------+
always @(posedge wmb_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    wmb_ce_hit_rb_idx       <=  1'b0;
  else if(wmb_ce_create_dp_vld)
    wmb_ce_hit_rb_idx       <=  wmb_ce_create_hit_rb_idx;
  else if(wmb_ce_vld)
    wmb_ce_hit_rb_idx       <=  wmb_ce_hit_rb_idx_set;
end

//+---------------+
//| hit rb idx ff |
//+---------------+
always @(posedge wmb_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    wmb_ce_hit_rb_idx_ff    <=  1'b0;
  else if(wmb_ce_create_dp_vld)
    wmb_ce_hit_rb_idx_ff    <=  wmb_ce_create_hit_rb_idx;
  else if(wmb_ce_vld)
    wmb_ce_hit_rb_idx_ff    <=  wmb_ce_hit_rb_idx;
end

//+-------------------------+
//| instruction information |
//+-------------------------+
// &Force("output","wmb_ce_addr"); @92
// &Force("output","wmb_ce_page_ca"); @93
// &Force("output","wmb_ce_page_so"); @94
// &Force("output","wmb_ce_page_share"); @95
// &Force("output","wmb_ce_atomic"); @96
// &Force("output","wmb_ce_sync_fence"); @97
// &Force("output","wmb_ce_icc"); @98
// &Force("output","wmb_ce_inst_type"); @99
// &Force("output","wmb_ce_inst_size"); @100
// &Force("output","wmb_ce_inst_mode"); @101
// &Force("output","wmb_ce_bytes_vld"); @102
// &Force("output","wmb_ce_priv_mode"); @103
always @(posedge wmb_ce_create_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    wmb_ce_addr[`WK_PA_WIDTH-1:0]  <=  {`WK_PA_WIDTH{1'b0}};
    wmb_ce_page_ca              <=  1'b0;
    wmb_ce_page_wa              <=  1'b0;
    wmb_ce_page_so              <=  1'b0;
    wmb_ce_page_sec             <=  1'b0;
    wmb_ce_page_buf             <=  1'b0;
    wmb_ce_page_share           <=  1'b0;
    wmb_ce_atomic               <=  1'b0;
    wmb_ce_icc                  <=  1'b0;
    wmb_ce_preg[PREG-1:0]       <=  {PREG{1'b0}};
    wmb_ce_wo_st                <=  1'b0;
    wmb_ce_sync_fence           <=  1'b0;
    wmb_ce_inst_flush           <=  1'b0;
    wmb_ce_inst_type[1:0]       <=  2'b0;
    wmb_ce_inst_size[2:0]       <=  3'b0;
    wmb_ce_inst_mode[1:0]       <=  2'b0;
    wmb_ce_bytes_vld[15:0]      <=  16'b0;
    wmb_ce_priv_mode[1:0]       <=  2'b0;
    wmb_ce_sq_ptr[SQ_ENTRY-1:0] <=  {SQ_ENTRY{1'b0}};
    wmb_ce_dtcm_hit             <=  1'b0;
    wmb_ce_itcm_hit             <=  1'b0;
  end
  else if(wmb_ce_create_dp_vld)
  begin
    wmb_ce_addr[`WK_PA_WIDTH-1:0]  <=  sq_pop_addr[`WK_PA_WIDTH-1:0];
    wmb_ce_page_ca              <=  sq_pop_page_ca;
    wmb_ce_page_wa              <=  sq_pop_page_wa;
    wmb_ce_page_so              <=  sq_pop_page_so;
    wmb_ce_page_sec             <=  sq_pop_page_sec;
    wmb_ce_page_buf             <=  sq_pop_page_buf;
    wmb_ce_page_share           <=  sq_pop_page_share;
    wmb_ce_atomic               <=  sq_pop_atomic;
    wmb_ce_icc                  <=  sq_pop_icc;
    wmb_ce_preg[PREG-1:0]       <=  sq_pop_preg[PREG-1:0];
    wmb_ce_wo_st                <=  sq_pop_wo_st;
    wmb_ce_sync_fence           <=  sq_pop_sync_fence;
    wmb_ce_inst_flush           <=  sq_pop_inst_flush;
    wmb_ce_inst_type[1:0]       <=  sq_pop_inst_type[1:0];
    wmb_ce_inst_size[2:0]       <=  sq_pop_inst_size[2:0];
    wmb_ce_inst_mode[1:0]       <=  sq_pop_inst_mode[1:0];
    wmb_ce_bytes_vld[15:0]      <=  sq_pop_bytes_vld[15:0];
    wmb_ce_priv_mode[1:0]       <=  sq_pop_priv_mode[1:0];
    wmb_ce_sq_ptr[SQ_ENTRY-1:0] <=  sq_pop_ptr[SQ_ENTRY-1:0];
    wmb_ce_dtcm_hit             <=  sq_pop_dtcm_hit;
    wmb_ce_itcm_hit             <=  sq_pop_itcm_hit;
  end
end

//+---------------------------+
//| create/merge/stall signal |
//+---------------------------+
// &Force("output","wmb_ce_merge_ptr"); @157
//stall means merge stall
always @(posedge wmb_ce_create_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    wmb_ce_merge                    <=  1'b0;
    wmb_ce_stall                    <=  1'b0;
    wmb_ce_merge_ptr[WMB_ENTRY-1:0] <=  {WMB_ENTRY{1'b0}};
    wmb_ce_depd_val[WMB_ENTRY-1:0]  <=  {WMB_ENTRY{1'b0}};
  end
  else if(wmb_ce_create_dp_vld)
  begin
    wmb_ce_merge                    <=  wmb_ce_create_merge;
    wmb_ce_stall                    <=  wmb_ce_create_stall;
    wmb_ce_merge_ptr[WMB_ENTRY-1:0] <=  wmb_ce_create_merge_ptr[WMB_ENTRY-1:0];
    wmb_ce_depd_val[WMB_ENTRY-1:0]  <=  wmb_ce_create_depd_val[WMB_ENTRY-1:0];
  end
end

always @(posedge wmb_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    wmb_ce_same_dcache_line[WMB_ENTRY-1:0] <=  {WMB_ENTRY{1'b0}};
  else if(wmb_ce_create_dp_vld)
    wmb_ce_same_dcache_line[WMB_ENTRY-1:0] <=  wmb_ce_create_same_dcache_line[WMB_ENTRY-1:0];
end
//==========================================================
//                      Set Wires
//==========================================================
assign wmb_ce_hit_rb_idx_set  = wmb_ce_hit_rb_idx
                                &&  rb_wmb_ce_hit_idx
                                &&  (wmb_ce_wo_st
                                    ||  wmb_ce_atomic
                                    ||  wmb_ce_dcache_1line_inst);

//==========================================================
//                    Request Wires
//==========================================================
//-----------------------pop req wires----------------------
assign wmb_ce_depd_val_and_vld[WMB_ENTRY-1:0]  =
                wmb_ce_depd_val[WMB_ENTRY-1:0]
                & wmb_entry_vld[WMB_ENTRY-1:0];
assign wmb_ce_depd_vld  = |wmb_ce_depd_val_and_vld[WMB_ENTRY-1:0];

assign wmb_ce_merge_ptr_and_not_vld[WMB_ENTRY-1:0]  =
                wmb_ce_merge_ptr[WMB_ENTRY-1:0]
                & wmb_entry_vld[WMB_ENTRY-1:0];
assign wmb_ce_merge_not_vld = !(|wmb_ce_merge_ptr_and_not_vld[WMB_ENTRY-1:0]);

//if not stall, then not hit rb idx
assign wmb_ce_merge_wmb_req       = wmb_ce_vld
                                    &&  wmb_ce_merge
                                    &&  !wmb_ce_stall;

assign wmb_ce_merge_wmb_wait_not_vld_req  = wmb_ce_vld
                                            &&  wmb_ce_merge
                                            &&  wmb_ce_stall;

// &Force("output","wmb_ce_create_wmb_req"); @216
assign wmb_ce_create_wmb_req      = wmb_ce_vld
                                    &&  !wmb_ce_hit_rb_idx_ff
                                    &&  !wmb_ce_depd_vld
                                    &&  (!wmb_ce_merge
                                        ||  wmb_ce_merge_not_vld);

// &Force("output","wmb_ce_create_wmb_dp_req"); @223
assign wmb_ce_create_wmb_dp_req   = wmb_ce_vld
                                    &&  (!wmb_ce_merge
                                        ||  wmb_ce_stall);
assign wmb_ce_create_wmb_data_req = wmb_ce_create_wmb_dp_req
                                    &&  wmb_ce_write_data_inst;
assign wmb_ce_create_wmb_gateclk_en = wmb_ce_create_wmb_dp_req;

//==========================================================
//                    Data Wires
//==========================================================
//------------------inst type-------------------------------
assign wmb_ce_write_data_inst   = wmb_ce_atomic
                                  ||  wmb_ce_st_inst
                                  ||  wmb_ce_tlbi_asid_inst;

// &Force("output", "wmb_ce_st_inst"); @239
assign wmb_ce_st_inst           = !wmb_ce_atomic
                                  &&  !wmb_ce_icc
                                  &&  !wmb_ce_sync_fence;
assign wmb_ce_stamo_inst        = wmb_ce_atomic
                                  &&  (wmb_ce_inst_type[1:0] ==  2'b00);
assign wmb_ce_sc_inst           = wmb_ce_atomic
                                  &&  (wmb_ce_inst_type[1:0] ==  2'b01);
assign wmb_ce_ca_st_inst        = wmb_ce_st_inst
                                  &&  wmb_ce_page_ca;
assign wmb_ce_so_st_inst        = wmb_ce_st_inst
                                  &&  wmb_ce_page_so;
assign wmb_ce_wo_st_inst        = wmb_ce_st_inst
                                  &&  !wmb_ce_page_so;
assign wmb_ce_sync_fence_inst   = !wmb_ce_atomic
                                  &&  wmb_ce_sync_fence;
assign wmb_ce_tlbi_inst         = !wmb_ce_atomic
                                  &&  wmb_ce_icc
                                  &&  (wmb_ce_inst_type[1:0] ==  2'b00);
assign wmb_ce_tlbi_asid_inst    = wmb_ce_tlbi_inst
                                  &&  wmb_ce_inst_mode[0];
// &Force("output","wmb_ce_dcache_inst"); @260
assign wmb_ce_dcache_inst       = !wmb_ce_atomic
                                  &&  wmb_ce_icc
                                  &&  (wmb_ce_inst_type[1:0] ==  2'b10);

// &Force("output", "wmb_ce_dcache_1line_inst"); @265
assign wmb_ce_dcache_1line_inst = wmb_ce_dcache_inst
                                  &&  (wmb_ce_inst_mode[1:0] !=  2'b00);

assign wmb_ce_dcache_sw_inst    = wmb_ce_dcache_inst
                                  &&  (wmb_ce_inst_mode[1:0] ==  2'b10);
assign wmb_ce_dcache_addr_inst  = wmb_ce_dcache_inst
                                  &&  wmb_ce_inst_mode[0];
assign wmb_ce_dcache_addr_not_l1_inst = wmb_ce_dcache_addr_inst
                                        &&  (wmb_ce_inst_size[1:0] !=  2'b00);
                                  
assign wmb_ce_ctc_inst          = !wmb_ce_atomic
                                  &&  wmb_ce_icc
                                  &&  (wmb_ce_inst_type[1:0] !=  2'b10);
//dcache all request pass to icc for gate_clk
assign wmb_ce_dcache_all_inst   = wmb_ce_dcache_inst
                                  &&  (wmb_ce_inst_mode[1:0] ==  2'b00);

//------------------pop info for wmb------------------------
// &Force("output","wmb_ce_merge_en"); @284
// &Force("output","wmb_ce_dtcm_hit"); @285
// &Force("output","wmb_ce_itcm_hit"); @286
assign wmb_ce_merge_en  = wmb_ce_wo_st;
assign wmb_ce_wb_cmplt_success  = wmb_ce_wo_st
                                  ||  wmb_ce_ctc_inst
                                  ||  wmb_ce_dcache_inst  &&  !wmb_ce_dcache_all_inst;
assign wmb_ce_wb_data_success   = !wmb_ce_sc_inst;
//------------------data request----------------------------
//----------get data_vld signal---------
//data_vld is used for wmb data gateclk
assign wmb_ce_data_vld[0] = |wmb_ce_bytes_vld[3:0];
assign wmb_ce_data_vld[1] = |wmb_ce_bytes_vld[7:4];
assign wmb_ce_data_vld[2] = |wmb_ce_bytes_vld[11:8];
assign wmb_ce_data_vld[3] = |wmb_ce_bytes_vld[15:12];
assign wmb_ce_bytes_vld_full = &wmb_ce_bytes_vld[15:0];

//-----------sc signal----------------
// &Force("output","wmb_ce_sc_wb_vld"); @302
assign wmb_ce_sc_wb_vld             = lm_sq_sc_fail || wmb_ce_lm_fail;

//-------------------wmb status signal----------------------
assign wmb_ce_write_imme  = !wmb_ce_wo_st || wmb_ce_dtcm_hit || dtu_lsu_data_trig_en; // Risc-V Debug zdb

assign wmb_ce_read_dp_req         = wmb_ce_st_inst
                                          &&  wmb_ce_page_ca
                                          &&  wmb_ce_page_share
                                          &&  (wmb_ce_dcache_share
                                              ||  !wmb_ce_dcache_valid)
                                    ||  wmb_ce_ctc_inst
                                    ||  wmb_ce_dcache_addr_inst
                                        &&  wmb_ce_page_ca
                                        &&  (wmb_ce_dcache_addr_not_l1_inst
                                            ||  wmb_ce_page_share)
                                        &&  wmb_ce_page_ca
                                    ||  wmb_ce_sc_inst
                                        &&  wmb_ce_page_ca
                                        &&  wmb_ce_page_share;

//for write gateclk
assign wmb_ce_write_biu_dp_req    = wmb_ce_so_st_inst
                                    ||  wmb_ce_wo_st_inst
                                        &&  !(wmb_ce_page_ca
                                              &&  wmb_ce_dcache_valid)
                                    ||  wmb_ce_sync_fence_inst
                                    ||  wmb_ce_stamo_inst
                                        &&  !(wmb_ce_page_ca
                                              &&  wmb_ce_dcache_valid)
                                    ||  wmb_ce_sc_inst
                                        &&  !(wmb_ce_page_ca
                                              &&  wmb_ce_dcache_valid)
                                        &&  !wmb_ce_sc_wb_vld;

//==========================================================
//                  Compare with sq pop
//==========================================================
//wmb_ce_hit_sq_pop_cache_line is used for same_dcache_line
// &Force("bus","sq_pop_addr","39","0"); @341
assign wmb_ce_hit_sq_pop_addr_tto6    = wmb_ce_addr[`WK_PA_WIDTH-1:6]  ==  sq_pop_addr[`WK_PA_WIDTH-1:6];
assign wmb_ce_hit_sq_pop_addr_5to4    = wmb_ce_addr[5:4]   ==  sq_pop_addr[5:4];
assign wmb_ce_hit_sq_pop_addr_tto4    = wmb_ce_hit_sq_pop_addr_tto6
                                        &&  wmb_ce_hit_sq_pop_addr_5to4;
assign wmb_ce_hit_sq_pop_bytes_vld    = |(wmb_ce_bytes_vld[15:0] & sq_pop_bytes_vld[15:0]);

assign wmb_ce_sq_pop_sameline_set     = wmb_ce_hit_sq_pop_addr_tto6
                                        &&  wmb_ce_st_inst
                                        &&  wmb_ce_vld;
assign wmb_ce_hit_sq_pop_dcache_line    = wmb_ce_hit_sq_pop_addr_tto6
                                        &&  wmb_ce_vld;

//if supv mode or page info is not hit, then set write_imme and donot grnt
//signal to sq
// &Force("output","wmb_ce_merge_data_addr_hit"); @356
assign wmb_ce_merge_data_addr_hit     = wmb_ce_hit_sq_pop_addr_tto4
                                        &&  (!wmb_ce_dtcm_hit || wmb_ce_hit_sq_pop_bytes_vld)
                                        &&  wmb_ce_merge_en
                                        &&  wmb_ce_vld;

assign wmb_ce_merge_data_permit       = (wmb_ce_priv_mode[1:0]  ==  sq_pop_priv_mode[1:0])
                                        && !wmb_ce_dtcm_hit
                                        && !dtu_lsu_data_trig_en; // Risc-V Debug zdb

assign wmb_ce_merge_data_stall        = wmb_ce_merge_data_addr_hit
                                        &&  !wmb_ce_merge_data_permit;
// &ModuleEnd; @368
endmodule


