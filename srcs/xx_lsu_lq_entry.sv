//-----------------------------------------------------------------------------
// File          : xx_lsu_lq_entry.sv
// Created       : 2024/10/14 (by Wen Jiahui)
// Last modified : 2024/10/14 (by Wen Jiahui)
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
// 2024/10/14 : Created
// 2024/XX/XX : 
//-----------------------------------------------------------------------------

//#
//# Module Declaration
//# ==================
//#
module xx_lsu_lq_entry #(
    parameter IID_WIDTH=10,
    parameter LQENTRY = 24
)(
input logic                             cp0_lsu_corr_dis,                 
input logic                             cp0_lsu_icg_en,                   
input logic                             cpurst_b,                         
input logic                             forever_cpuclk,                   
input logic                             lq_clk,                           
input logic [LQENTRY-1:0]               lq_entry_pop_v, // wjh@sfp
input logic                             lq_entry_agevec_updt_vld_x, // wjh@sfp
input logic [LQENTRY-1:0]               lsu0_create_vld_v, // wjh@sfp
input logic [LQENTRY-1:0]               lsu2_create_vld_v, // wjh@sfp
input logic [LQENTRY-1:0]               lsu3_create_vld_v, // wjh@sfp
input logic [LQENTRY-1:0]               lsu0_spec_fail_v,  // wjh@sfp
input logic [LQENTRY-1:0]               lsu2_spec_fail_v,  // wjh@sfp
input logic [LQENTRY-1:0]               lsu3_spec_fail_v,  // wjh@sfp
input logic                             lda0_ex3_lq_entry_pop_x,          
input logic [14:0]                      ldc0_ex2_pc,       // wjh@sfp
input logic [LQENTRY-1:0]               lq_create_agevec0, // wjh@sfp
input logic [`WK_PA_WIDTH-1:0]          ldc0_ex2_addr0,                   
input logic [`WK_PA_WIDTH-1:0]          ldc0_ex2_addr1,                   
input logic [15:0]                      ldc0_ex2_bytes_vld,               
input logic [15:0]                      ldc0_ex2_bytes_vld1,              
input logic                             ldc0_ex2_inst_us,
input logic                             ldc0_ex2_chk_atomic_inst_vld,     
input logic                             ldc0_ex2_chk_ld_addr1_vld,        
input logic [IID_WIDTH-1 :0]            ldc0_ex2_iid,                        
input logic                             ldc0_ex2_inst_chk_vld,            
input logic                             ldc0_ex2_secd,                    
input logic                             ldc0_ex2_snped, // wjh@mcores-rar
input logic                             ldc0_lq_ex2_create_dp_vld_x,      
input logic                             ldc0_lq_ex2_create_vld_x,         
input logic                             ldc0_lq_ex2_create_gateclk_en_x,
// input logic                  lda1_ex3_lq_entry_pop_x,          
// input logic [39:0]           ldc1_ex2_addr0,                   
// input logic [39:0]           ldc1_ex2_addr1,                   
// input logic [15:0]           ldc1_ex2_bytes_vld,               
// input logic [15:0]           ldc1_ex2_bytes_vld1,              
// input logic                  ldc1_ex2_chk_atomic_inst_vld,     
// input logic                  ldc1_ex2_chk_ld_addr1_vld,        
// input logic [IID_WIDTH-1 :0] ldc1_ex2_iid,                        
// input logic                  ldc1_ex2_inst_chk_vld,            
// input logic                  ldc1_ex2_secd,                    
// input logic                  ldc1_lq_ex2_create_dp_vld_x,      
// input logic                  ldc1_lq_ex2_create_vld_x,         
// input logic                  ldc1_lq_ex2_create_gateclk_en_x,  
input logic                             lsda0_ex3_lq_entry_pop_x,          
input logic [14:0]                      lsdc0_ex2_pc, // wjh@sfp
input logic [LQENTRY-1:0]               lq_create_agevec2, // wjh@sfp
input logic [`WK_PA_WIDTH-1:0]          lsdc0_ex2_addr0,                   
input logic [`WK_PA_WIDTH-1:0]          lsdc0_ex2_addr1,                   
input logic [15:0]                      lsdc0_ex2_bytes_vld,               
input logic [15:0]                      lsdc0_ex2_bytes_vld1,              
input logic                             lsdc0_ex2_inst_us,
input logic                             lsdc0_ex2_chk_atomic_inst_vld,     
input logic                             lsdc0_ex2_chk_ld_addr1_vld,        
input logic [IID_WIDTH-1 :0]            lsdc0_ex2_iid,                        
input logic [IID_WIDTH-1 :0]            lsdc0_ex2_ld_iid, //logic levels opt@LTL
input logic                             lsdc0_ex2_chk_st_inst_vld,            
input logic                             lsdc0_ex2_chk_ld_inst_vld,            
input logic                             lsdc0_ex2_ld_secd,                    
input logic                             lsdc0_ex2_snped, // wjh@mcores-rar
input logic                             lsdc0_lq_ex2_create_dp_vld_x,      
input logic                             lsdc0_lq_ex2_create_vld_x,         
input logic                             lsdc0_lq_ex2_create_gateclk_en_x,  
input logic                             lsda1_ex3_lq_entry_pop_x,          
input logic [14:0]                      lsdc1_ex2_pc, // wjh@sfp
input logic [LQENTRY-1:0]               lq_create_agevec3, // wjh@sfp
input logic [`WK_PA_WIDTH-1:0]          lsdc1_ex2_addr0,                   
input logic [`WK_PA_WIDTH-1:0]          lsdc1_ex2_addr1,                   
input logic [15:0]                      lsdc1_ex2_bytes_vld,               
input logic [15:0]                      lsdc1_ex2_bytes_vld1,              
input logic                             lsdc1_ex2_inst_us,
input logic                             lsdc1_ex2_chk_atomic_inst_vld,     
input logic                             lsdc1_ex2_chk_ld_addr1_vld,        
input logic [IID_WIDTH-1:0]             lsdc1_ex2_iid,                        
input logic [IID_WIDTH-1:0]             lsdc1_ex2_ld_iid, //logic levels opt@LTL 
input logic                             lsdc1_ex2_chk_st_inst_vld,            
input logic                             lsdc1_ex2_chk_ld_inst_vld,            
input logic                             lsdc1_ex2_ld_secd,                    
input logic                             lsdc1_ex2_snped, // wjh@mcores-rar
input logic                             lsdc1_lq_ex2_create_dp_vld_x,      
input logic                             lsdc1_lq_ex2_create_vld_x,         
input logic                             lsdc1_lq_ex2_create_gateclk_en_x,  
input logic                             pad_yy_icg_scan_en,           
input logic                             rtu_yy_xx_commit0,            
input logic   [IID_WIDTH-1:0]           rtu_yy_xx_commit0_iid,        
input logic                             rtu_yy_xx_commit1,            
input logic   [IID_WIDTH-1:0]           rtu_yy_xx_commit1_iid,        
input logic                             rtu_yy_xx_commit2,            
input logic   [IID_WIDTH-1:0]           rtu_yy_xx_commit2_iid,        
input logic                             rtu_yy_xx_commit3,            
input logic   [IID_WIDTH-1:0]           rtu_yy_xx_commit3_iid,        
input logic                             rtu_yy_xx_commit4,            
input logic   [IID_WIDTH-1:0]           rtu_yy_xx_commit4_iid,        
input logic                             rtu_yy_xx_commit5,            
input logic   [IID_WIDTH-1:0]           rtu_yy_xx_commit5_iid,        
input logic                             rtu_yy_xx_commit6,            
input logic   [IID_WIDTH-1:0]           rtu_yy_xx_commit6_iid,        
input logic                             rtu_yy_xx_commit7,            
input logic   [IID_WIDTH-1:0]           rtu_yy_xx_commit7_iid,        
input logic                             rtu_yy_xx_flush,              
input logic                             rtu_ck_flush,
input logic   [IID_WIDTH-1:0]           rtu_ck_flush_iid,
input logic                             snq_lq_inv_req, // wjh@mcores-rar
input logic [`WK_PA_WIDTH-7:0]          snq_lq_inv_addr, // wjh@mcores-rar
input logic                             vb_lq_inv_req,   // wjh@mcores-rar
input logic [`WK_PA_WIDTH-7:0]          vb_lq_inv_addr,  // wjh@mcores-rar
output logic                            lq_entry_older_than_lsu0_x, // wjh@sfp
output logic                            lq_entry_older_than_lsu2_x, // wjh@sfp
output logic                            lq_entry_older_than_lsu3_x, // wjh@sfp
output logic                            lq_entry_pop_vld_x,         // wjh@sfp
output logic                            lsu0_spec_fail_1hot_x,      // wjh@sfp
output logic                            lsu2_spec_fail_1hot_x,      // wjh@sfp
output logic                            lsu3_spec_fail_1hot_x,      // wjh@sfp
output logic [14:0]                     lq_entry_pc_v,              // wjh@sfp
output logic                            lq_entry_ldc0_inst_hit_x,
// output logic                            lq_entry_ldc1_inst_hit_x,
output logic                            lq_entry_lsdc0_inst_hit_x,
output logic                            lq_entry_lsdc1_inst_hit_x,
output logic                            lq_entry_ldc0_rar_spec_fail_x,
// output logic                            lq_entry_ldc1_rar_spec_fail_x,
output logic                            lq_entry_lsdc0_spec_fail_x,
output logic                            lq_entry_lsdc1_spec_fail_x,
output logic                            lq_entry_vld_x
);
// create
logic                                   lq_entry_create_clk_en;
logic                                   lq_entry_create_clk;
logic                                   lq_entry_pop_vld;


logic                                   ldc0_lq_ex2_create_dp_vld;
logic                                   ldc0_lq_ex2_create_vld;
// logic ldc1_lq_ex2_create_dp_vld;
// logic ldc1_lq_ex2_create_vld;
logic                                   lsdc0_lq_ex2_create_dp_vld;
logic                                   lsdc0_lq_ex2_create_vld;
logic                                   lsdc1_lq_ex2_create_dp_vld;
logic                                   lsdc1_lq_ex2_create_vld;
logic                                   ldc0_lq_ex2_create_gateclk_en;
// logic ldc1_lq_ex2_create_gateclk_en;
logic                                   lsdc0_lq_ex2_create_gateclk_en;
logic                                   lsdc1_lq_ex2_create_gateclk_en;
logic                                   lda0_ex3_lq_entry_restart_pop_vld;
// logic lda1_ex3_lq_entry_restart_pop_vld;
logic                                   lsda0_ex3_lq_entry_restart_pop_vld;
logic                                   lsda1_ex3_lq_entry_restart_pop_vld;
logic                                   lq_entry_ldc0_inst_hit;
// logic lq_entry_ldc1_inst_hit;
logic                                   lq_entry_lsdc0_inst_hit;
logic                                   lq_entry_lsdc1_inst_hit;
// spec-fail signals
logic                                   lq_entry_ldc0_rar_spec_fail0;
// logic lq_entry_ldc1_rar_spec_fail0;
logic                                   lq_entry_ldc0_rar_spec_fail1;
// logic lq_entry_ldc1_rar_spec_fail1;

logic                                   lq_entry_ldc0_rar_spec_fail;
// logic lq_entry_ldc1_rar_spec_fail;

logic                                   lq_entry_lsdc0_rar_spec_fail0;
logic                                   lq_entry_lsdc0_rar_spec_fail1;
logic                                   lq_entry_lsdc1_rar_spec_fail0;
logic                                   lq_entry_lsdc1_rar_spec_fail1;

logic                                   lq_entry_lsdc0_rar_spec_fail;
logic                                   lq_entry_lsdc1_rar_spec_fail;

logic                                   lq_entry_lsdc0_raw_spec_fail;
logic                                   lq_entry_lsdc1_raw_spec_fail;

logic                                   lq_entry_lsdc0_spec_fail;
logic                                   lq_entry_lsdc1_spec_fail;

logic [7:0]                             lq_entry_cmit_hit;
// lq entry register
logic [IID_WIDTH-1:0]                   lq_entry_iid;
logic                                   lq_entry_vld;
logic                                   lq_entry_secd;
logic [`WK_PA_WIDTH-5:0]                lq_entry_addr0_tto4;
logic [15:0]                            lq_entry_bytes_vld;
// rar check
logic                                   lq_entry_iid_newer_than_ldc0;
// logic lq_entry_iid_newer_than_ldc1;
logic                                   lq_entry_iid_newer_than_lsdc0;
logic                                   lq_entry_iid_newer_than_lsdc1;
logic [LQENTRY-1:0]                     lq_entry_agevec;
logic [LQENTRY-1:0]                     lq_entry_agevec_next;
logic [14:0]                            lq_entry_pc;
logic                                   lq_entry_snped;
logic                                   lq_entry_snp_set;
logic                                   lq_entry_inst_us;
logic                                   rtu_ck_flush_iid_older_than_entry_iid;
//==========================================================
//                 Instance of Gated Cell  
//==========================================================
assign lq_entry_create_clk_en = ldc0_lq_ex2_create_gateclk_en
                                // || ldc1_lq_ex2_create_gateclk_en
                                || lsdc0_lq_ex2_create_gateclk_en
                                || lsdc1_lq_ex2_create_gateclk_en;
gated_clk_cell  x_lsu_lq_entry_create_gated_clk (
  .clk_in                 (forever_cpuclk        ),
  .clk_out                (lq_entry_create_clk   ),
  .external_en            (1'b0                  ),
  .local_en               (lq_entry_create_clk_en),
  .module_en              (cp0_lsu_icg_en        ),
  .pad_yy_icg_scan_en     (pad_yy_icg_scan_en    )
);


//==========================================================
//                 Register
//==========================================================
//+-----------+
//| entry_vld |
//+-----------+
xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH)) 
x_lsu_ck_flush_compare_ex1_iid (
  .x_iid0                    (rtu_ck_flush_iid[IID_WIDTH-1:0]),
  .x_iid0_older              (rtu_ck_flush_iid_older_than_entry_iid  ),
  .x_iid1                    (lq_entry_iid[IID_WIDTH-1:0]           )
);
always @(posedge lq_clk, negedge cpurst_b)
begin
  if (!cpurst_b)
    lq_entry_vld  <=  1'b0;
  else if(lq_entry_pop_vld  ||  rtu_yy_xx_flush)
    lq_entry_vld  <=  1'b0;
  else if(lq_entry_vld && rtu_ck_flush  && rtu_ck_flush_iid_older_than_entry_iid) //flush younger vld entry, ck_flush@LTL
    lq_entry_vld  <=  1'b0;  
  else if(ldc0_lq_ex2_create_vld
          // || ldc1_lq_ex2_create_vld
          || lsdc0_lq_ex2_create_vld
          || lsdc1_lq_ex2_create_vld)
    lq_entry_vld  <=  1'b1;
end
//+-----------+------------+-----+--------+------+
//| addr_tto2 | bytes_vld0 | iid | deform | secd |
//+-----------+------------+-----+--------+------+
always @(posedge lq_entry_create_clk, negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    lq_entry_addr0_tto4[`WK_PA_WIDTH-5:0]  <=  {`WK_PA_WIDTH-4{1'b0}};
    lq_entry_bytes_vld[15:0]  <=  16'b0;
    lq_entry_inst_us          <= 1'b0;
    lq_entry_iid              <=  {IID_WIDTH{1'b0}};
    lq_entry_secd             <=  1'b0;
    lq_entry_pc               <= {15{1'b0}};
  end
  else if(ldc0_lq_ex2_create_dp_vld)
  begin
    lq_entry_addr0_tto4[`WK_PA_WIDTH-5:0] <=  ldc0_ex2_addr0[`WK_PA_WIDTH-1:4];
    lq_entry_bytes_vld[15:0]  <=  ldc0_ex2_bytes_vld[15:0];
    lq_entry_iid              <=  ldc0_ex2_iid;
    lq_entry_secd             <=  ldc0_ex2_secd;
    lq_entry_pc               <=  ldc0_ex2_pc;
    lq_entry_inst_us          <=  ldc0_ex2_inst_us;
  end
  // else if(ldc1_lq_ex2_create_dp_vld)
  // begin
  //   lq_entry_addr0_tto4[`WK_PA_WIDTH-5:0] <=  ldc1_ex2_addr0[`WK_PA_WIDTH-1:4];
  //   lq_entry_bytes_vld[15:0]  <=  ldc1_ex2_bytes_vld[15:0];
  //   lq_entry_iid              <=  ldc1_ex2_iid;
  //   lq_entry_secd             <=  ldc1_ex2_secd;
  // end
  else if(lsdc0_lq_ex2_create_dp_vld)
  begin
    lq_entry_addr0_tto4[`WK_PA_WIDTH-5:0] <=  lsdc0_ex2_addr0[`WK_PA_WIDTH-1:4];
    lq_entry_bytes_vld[15:0]  <=  lsdc0_ex2_bytes_vld[15:0];
    lq_entry_iid              <=  lsdc0_ex2_ld_iid;//logic levels opt@LTL
    lq_entry_secd             <=  lsdc0_ex2_ld_secd;
    lq_entry_pc               <=  lsdc0_ex2_pc;
    lq_entry_inst_us          <=  lsdc0_ex2_inst_us;
  end
  else if(lsdc1_lq_ex2_create_dp_vld)
  begin
    lq_entry_addr0_tto4[`WK_PA_WIDTH-5:0] <=  lsdc1_ex2_addr0[`WK_PA_WIDTH-1:4];
    lq_entry_bytes_vld[15:0]  <=  lsdc1_ex2_bytes_vld[15:0];
    lq_entry_iid              <=  lsdc1_ex2_ld_iid;//logic levels opt@LTL 
    lq_entry_secd             <=  lsdc1_ex2_ld_secd;
    lq_entry_pc               <=  lsdc1_ex2_pc;
    lq_entry_inst_us          <=  lsdc1_ex2_inst_us;
  end
end

always @(posedge lq_clk, negedge cpurst_b) begin 
  if(!cpurst_b)
    lq_entry_agevec <= {LQENTRY{1'b0}};
  else if(ldc0_lq_ex2_create_dp_vld)
    lq_entry_agevec <= lq_create_agevec0;
  else if(lsdc0_lq_ex2_create_dp_vld)
    lq_entry_agevec <= lq_create_agevec2;
  else if(lsdc1_lq_ex2_create_dp_vld)
    lq_entry_agevec <= lq_create_agevec3;
  else if(lq_entry_agevec_updt_vld_x)
    lq_entry_agevec <= lq_entry_agevec_next;
end
// wjh@mcores-rar
always @(posedge lq_clk, negedge cpurst_b) begin 
  if(!cpurst_b)
    lq_entry_snped <= 1'b0;
  else if(ldc0_lq_ex2_create_dp_vld)
    lq_entry_snped <= ldc0_ex2_snped;
  else if(lsdc0_lq_ex2_create_dp_vld)
    lq_entry_snped <= lsdc0_ex2_snped;
  else if(lsdc1_lq_ex2_create_dp_vld)
    lq_entry_snped <= lsdc1_ex2_snped;
  else if(lq_entry_snp_set)
    lq_entry_snped <= 1'b1;
end
assign lq_entry_snp_set = lq_entry_vld
                          && !lq_entry_snped
                          && ( snq_lq_inv_req && snq_lq_inv_addr[`WK_PA_WIDTH-7:0] == lq_entry_addr0_tto4[`WK_PA_WIDTH-5:2]
                               || vb_lq_inv_req && vb_lq_inv_addr[`WK_PA_WIDTH-7:0] == lq_entry_addr0_tto4[`WK_PA_WIDTH-5:2]);
//==========================================================
//                 Generate pop signal
//==========================================================
assign lq_entry_cmit_hit[0] = rtu_yy_xx_commit0
                              &&  lq_entry_vld
                              &&  (rtu_yy_xx_commit0_iid  ==  lq_entry_iid);
assign lq_entry_cmit_hit[1] = rtu_yy_xx_commit1
                              &&  lq_entry_vld
                              &&  (rtu_yy_xx_commit1_iid  ==  lq_entry_iid);
assign lq_entry_cmit_hit[2] = rtu_yy_xx_commit2
                              &&  lq_entry_vld
                              &&  (rtu_yy_xx_commit2_iid  ==  lq_entry_iid);
assign lq_entry_cmit_hit[3] = rtu_yy_xx_commit3
                              &&  lq_entry_vld
                              &&  (rtu_yy_xx_commit3_iid  ==  lq_entry_iid);
assign lq_entry_cmit_hit[4] = rtu_yy_xx_commit4
                              &&  lq_entry_vld
                              &&  (rtu_yy_xx_commit4_iid  ==  lq_entry_iid);
assign lq_entry_cmit_hit[5] = rtu_yy_xx_commit5
                              &&  lq_entry_vld
                              &&  (rtu_yy_xx_commit5_iid  ==  lq_entry_iid);
assign lq_entry_cmit_hit[6] = rtu_yy_xx_commit6
                              &&  lq_entry_vld
                              &&  (rtu_yy_xx_commit6_iid  ==  lq_entry_iid);
assign lq_entry_cmit_hit[7] = rtu_yy_xx_commit7
                              &&  lq_entry_vld
                              &&  (rtu_yy_xx_commit7_iid  ==  lq_entry_iid);

assign lq_entry_pop_vld   = (lq_entry_vld
                             && (|lq_entry_cmit_hit))
                          || lda0_ex3_lq_entry_restart_pop_vld
                          // || lda1_ex3_lq_entry_restart_pop_vld
                          || lsda0_ex3_lq_entry_restart_pop_vld
                          || lsda1_ex3_lq_entry_restart_pop_vld;

//==========================================================
//                 lq iid check
//==========================================================
//check iid to judge whether to create lq
assign lq_entry_ldc0_inst_hit = lq_entry_vld
                                && (lq_entry_secd == ldc0_ex2_secd)
                                && (lq_entry_iid  == ldc0_ex2_iid);
// assign lq_entry_ldc1_inst_hit = lq_entry_vld
//                                 && (lq_entry_secd == ldc1_ex2_secd)
//                                 && (lq_entry_iid  == ldc1_ex2_iid);
assign lq_entry_lsdc0_inst_hit = lq_entry_vld
                                 && (lq_entry_secd == lsdc0_ex2_ld_secd)
                                 && (lq_entry_iid  == lsdc0_ex2_ld_iid);//logic levels opt@LTL
assign lq_entry_lsdc1_inst_hit = lq_entry_vld
                                 && (lq_entry_secd == lsdc1_ex2_ld_secd)
                                 && (lq_entry_iid  == lsdc1_ex2_ld_iid);//logic levels opt@LTL 
//==========================================================
//                 RAR speculation check
//==========================================================

// situat ld pipe             lq        addr      bytes_vld
// --------------------------------------------------------
// 0      ld/ldex             x         `WK_PA_WIDTH-1:2      cross
xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH))  
x_lsu_lq_entry_compare_ldc0_iid (
  .x_iid0                        (ldc0_ex2_iid                 ),
  .x_iid0_older                  (lq_entry_iid_newer_than_ldc0 ),
  .x_iid1                        (lq_entry_iid                 )
);

assign lq_entry_ldc0_rar_spec_fail0 = lq_entry_vld
                                      && lq_entry_iid_newer_than_ldc0
                                      && (ldc0_ex2_inst_chk_vld
                                          || ldc0_ex2_chk_atomic_inst_vld)
                                      && ((lq_entry_addr0_tto4[`WK_PA_WIDTH-5:0] == ldc0_ex2_addr0[`WK_PA_WIDTH-1:4]) && (|(lq_entry_bytes_vld[15:0] & ldc0_ex2_bytes_vld[15:0]))
                                        || lq_entry_addr0_tto4[`WK_PA_WIDTH-5:2] == ldc0_ex2_addr0[`WK_PA_WIDTH-1:6]  && (lq_entry_inst_us || ldc0_ex2_inst_us));

assign lq_entry_ldc0_rar_spec_fail1 = lq_entry_vld
                                      && lq_entry_iid_newer_than_ldc0
                                      && ldc0_ex2_chk_ld_addr1_vld
                                      && (lq_entry_addr0_tto4[`WK_PA_WIDTH-5:0]
                                          == ldc0_ex2_addr1[`WK_PA_WIDTH-1:4])
                                      && (|(lq_entry_bytes_vld[15:0] & ldc0_ex2_bytes_vld1[15:0]));

assign lq_entry_ldc0_rar_spec_fail = (lq_entry_ldc0_rar_spec_fail0 || lq_entry_ldc0_rar_spec_fail1)
                                   && (!cp0_lsu_corr_dis || lq_entry_snped);// wjh@mcores-rar
// ------------------------ ldc1 ------------------------
// xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH)) 
// x_lsu_lq_entry_compare_ldc1_iid (
//   .x_iid0                        (ldc1_ex2_iid                 ),
//   .x_iid0_older                  (lq_entry_iid_newer_than_ldc1 ),
//   .x_iid1                        (lq_entry_iid                 )
// );

// assign lq_entry_ldc1_rar_spec_fail0 = lq_entry_vld
//                                       && lq_entry_iid_newer_than_ldc1
//                                       && (ldc1_ex2_inst_chk_vld
//                                           || ldc1_ex2_chk_atomic_inst_vld)
//                                       && (lq_entry_addr0_tto4[`WK_PA_WIDTH-5:0]
//                                           == ldc1_ex2_addr0[`WK_PA_WIDTH-1:4])
//                                       && (|(lq_entry_bytes_vld[15:0] & ldc1_ex2_bytes_vld[15:0]));

// assign lq_entry_ldc1_rar_spec_fail1 = lq_entry_vld
//                                       && lq_entry_iid_newer_than_ldc1
//                                       && ldc1_ex2_chk_ld_addr1_vld
//                                       && (lq_entry_addr0_tto4[`WK_PA_WIDTH-5:0]
//                                           == ldc1_ex2_addr1[`WK_PA_WIDTH-1:4])
//                                       && (|(lq_entry_bytes_vld[15:0] & ldc1_ex2_bytes_vld1[15:0]));

// assign lq_entry_ldc1_rar_spec_fail = (lq_entry_ldc1_rar_spec_fail0 || lq_entry_ldc1_rar_spec_fail1)
//                                    && !cp0_lsu_corr_dis;

// ------------------------ lsdc0 ------------------------
xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH)) 
x_lsu_lq_entry_compare_lsdc0_iid (
  .x_iid0                        (lsdc0_ex2_iid                 ),
  .x_iid0_older                  (lq_entry_iid_newer_than_lsdc0 ),
  .x_iid1                        (lq_entry_iid                  )
);

assign lq_entry_lsdc0_rar_spec_fail0 = lq_entry_vld
                                       && lq_entry_iid_newer_than_lsdc0
                                       && (lsdc0_ex2_chk_ld_inst_vld
                                           || lsdc0_ex2_chk_atomic_inst_vld)
                                       && ((lq_entry_addr0_tto4[`WK_PA_WIDTH-5:0] == lsdc0_ex2_addr0[`WK_PA_WIDTH-1:4]) && (|(lq_entry_bytes_vld[15:0] & lsdc0_ex2_bytes_vld[15:0]))
                                         || lq_entry_addr0_tto4[`WK_PA_WIDTH-5:2] == lsdc0_ex2_addr0[`WK_PA_WIDTH-1:6]  && (lq_entry_inst_us || lsdc0_ex2_inst_us));

assign lq_entry_lsdc0_rar_spec_fail1 = lq_entry_vld
                                       && lq_entry_iid_newer_than_lsdc0
                                       && lsdc0_ex2_chk_ld_addr1_vld
                                       && (lq_entry_addr0_tto4[`WK_PA_WIDTH-5:0]
                                           == lsdc0_ex2_addr1[`WK_PA_WIDTH-1:4])
                                       && (|(lq_entry_bytes_vld[15:0] & lsdc0_ex2_bytes_vld1[15:0]));

assign lq_entry_lsdc0_rar_spec_fail = (lq_entry_lsdc0_rar_spec_fail0 || lq_entry_lsdc0_rar_spec_fail1)
                                   && (!cp0_lsu_corr_dis || lq_entry_snped); // @wjh@mcores-rar
// ------------------------ lsdc1 ------------------------
xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH)) 
x_lsu_lq_entry_compare_lsdc1_iid (
  .x_iid0                        (lsdc1_ex2_iid                 ),
  .x_iid0_older                  (lq_entry_iid_newer_than_lsdc1 ),
  .x_iid1                        (lq_entry_iid                  )
);

assign lq_entry_lsdc1_rar_spec_fail0 = lq_entry_vld
                                       && lq_entry_iid_newer_than_lsdc1
                                       && (lsdc1_ex2_chk_ld_inst_vld
                                           || lsdc1_ex2_chk_atomic_inst_vld)
                                       && ((lq_entry_addr0_tto4[`WK_PA_WIDTH-5:0]== lsdc1_ex2_addr0[`WK_PA_WIDTH-1:4]) && (|(lq_entry_bytes_vld[15:0] & lsdc1_ex2_bytes_vld[15:0]))
                                           || (lq_entry_addr0_tto4[`WK_PA_WIDTH-5:2]==lsdc1_ex2_addr0[`WK_PA_WIDTH-1:6]) && (lq_entry_inst_us || lsdc1_ex2_inst_us));

assign lq_entry_lsdc1_rar_spec_fail1 = lq_entry_vld
                                       && lq_entry_iid_newer_than_lsdc1
                                       && lsdc1_ex2_chk_ld_addr1_vld
                                       && ((lq_entry_addr0_tto4[`WK_PA_WIDTH-5:0]== lsdc1_ex2_addr1[`WK_PA_WIDTH-1:4]) && (|(lq_entry_bytes_vld[15:0] & lsdc1_ex2_bytes_vld1[15:0]))
                                         || lq_entry_addr0_tto4[`WK_PA_WIDTH-5:2]== lsdc1_ex2_addr1[`WK_PA_WIDTH-1:6] && (lq_entry_inst_us || lsdc1_ex2_inst_us));

assign lq_entry_lsdc1_rar_spec_fail = (lq_entry_lsdc1_rar_spec_fail0 || lq_entry_lsdc1_rar_spec_fail1)
                                   && (!cp0_lsu_corr_dis || lq_entry_snped); // wjh@mcores-rar


//==========================================================
//                 RAW speculation check
//==========================================================

assign lq_entry_lsdc0_raw_spec_fail = lq_entry_vld
                                      && lq_entry_iid_newer_than_lsdc0
                                      && (lsdc0_ex2_chk_st_inst_vld
                                          || lsdc0_ex2_chk_atomic_inst_vld)
                                      && ((lq_entry_addr0_tto4[`WK_PA_WIDTH-5:0] == lsdc0_ex2_addr0[`WK_PA_WIDTH-1:4]) && (|(lq_entry_bytes_vld[15:0] & lsdc0_ex2_bytes_vld[15:0]))
                                          || (lq_entry_addr0_tto4[`WK_PA_WIDTH-5:2] == lsdc0_ex2_addr0[`WK_PA_WIDTH-1:6]) && (lq_entry_inst_us || lsdc0_ex2_inst_us));

assign lq_entry_lsdc1_raw_spec_fail = lq_entry_vld
                                      && lq_entry_iid_newer_than_lsdc1
                                      && (lsdc1_ex2_chk_st_inst_vld
                                          || lsdc1_ex2_chk_atomic_inst_vld)
                                      && ((lq_entry_addr0_tto4[`WK_PA_WIDTH-5:0]== lsdc1_ex2_addr0[`WK_PA_WIDTH-1:4]) && (|(lq_entry_bytes_vld[15:0] & lsdc1_ex2_bytes_vld[15:0]))
                                          || (lq_entry_addr0_tto4[`WK_PA_WIDTH-5:2] == lsdc1_ex2_addr0[`WK_PA_WIDTH-1:6] && (lq_entry_inst_us || lsdc1_ex2_inst_us)));

assign lq_entry_lsdc0_spec_fail = lq_entry_lsdc0_rar_spec_fail || lq_entry_lsdc0_raw_spec_fail;
assign lq_entry_lsdc1_spec_fail = lq_entry_lsdc1_rar_spec_fail || lq_entry_lsdc1_raw_spec_fail;
//==========================================================
//                 sfp
//==========================================================
assign lq_entry_older_than_lsu0_x = lq_entry_vld
                                    && !lq_entry_iid_newer_than_ldc0
                                    && !lq_entry_pop_vld;

assign lq_entry_older_than_lsu2_x = lq_entry_vld
                                    && !lq_entry_iid_newer_than_lsdc0
                                    && !lq_entry_pop_vld;

assign lq_entry_older_than_lsu3_x = lq_entry_vld
                                    && !lq_entry_iid_newer_than_lsdc1
                                    && !lq_entry_pop_vld;
assign lq_entry_pop_vld_x = lq_entry_pop_vld;
assign lq_entry_agevec_next = (lq_entry_agevec[LQENTRY-1:0]
                               | ({LQENTRY{lq_entry_iid_newer_than_ldc0}}  & lsu0_create_vld_v[LQENTRY-1:0])
                               | ({LQENTRY{lq_entry_iid_newer_than_lsdc0}} & lsu2_create_vld_v[LQENTRY-1:0])
                               | ({LQENTRY{lq_entry_iid_newer_than_lsdc1}} & lsu3_create_vld_v[LQENTRY-1:0]))
                             & ~lq_entry_pop_v[LQENTRY-1:0];
assign lsu0_spec_fail_1hot_x = lq_entry_ldc0_rar_spec_fail; // wjh@timing
                              //  && !(|(lsu0_spec_fail_v[LQENTRY-1:0] & lq_entry_agevec[LQENTRY-1:0]));
assign lsu2_spec_fail_1hot_x = lq_entry_lsdc0_spec_fail; // wjh@timing
                              //  && !(|(lsu2_spec_fail_v[LQENTRY-1:0] & lq_entry_agevec[LQENTRY-1:0]));
assign lsu3_spec_fail_1hot_x = lq_entry_lsdc1_spec_fail; // wjh@timing
                              //  && !(|(lsu3_spec_fail_v[LQENTRY-1:0] & lq_entry_agevec[LQENTRY-1:0]));
assign lq_entry_pc_v = lq_entry_pc;
//==========================================================
//                 Generate interface
//==========================================================
//------------------input-----------------------------------
assign ldc0_lq_ex2_create_dp_vld      = ldc0_lq_ex2_create_dp_vld_x;
assign ldc0_lq_ex2_create_vld         = ldc0_lq_ex2_create_vld_x;
// assign ldc1_lq_ex2_create_dp_vld      = ldc1_lq_ex2_create_dp_vld_x;
// assign ldc1_lq_ex2_create_vld         = ldc1_lq_ex2_create_vld_x;

assign lsdc0_lq_ex2_create_dp_vld     = lsdc0_lq_ex2_create_dp_vld_x;
assign lsdc0_lq_ex2_create_vld        = lsdc0_lq_ex2_create_vld_x;
assign lsdc1_lq_ex2_create_dp_vld     = lsdc1_lq_ex2_create_dp_vld_x;
assign lsdc1_lq_ex2_create_vld        = lsdc1_lq_ex2_create_vld_x;

assign ldc0_lq_ex2_create_gateclk_en  = ldc0_lq_ex2_create_gateclk_en_x;
// assign ldc1_lq_ex2_create_gateclk_en  = ldc1_lq_ex2_create_gateclk_en_x;
assign lsdc0_lq_ex2_create_gateclk_en = lsdc0_lq_ex2_create_gateclk_en_x;
assign lsdc1_lq_ex2_create_gateclk_en = lsdc1_lq_ex2_create_gateclk_en_x;

assign lda0_ex3_lq_entry_restart_pop_vld  = lda0_ex3_lq_entry_pop_x;
// assign lda1_ex3_lq_entry_restart_pop_vld  = lda1_ex3_lq_entry_pop_x;
assign lsda0_ex3_lq_entry_restart_pop_vld = lsda0_ex3_lq_entry_pop_x;
assign lsda1_ex3_lq_entry_restart_pop_vld = lsda1_ex3_lq_entry_pop_x;
//------------------output----------------------------------
assign lq_entry_vld_x                = lq_entry_vld;
assign lq_entry_ldc0_inst_hit_x      = lq_entry_ldc0_inst_hit;
// assign lq_entry_ldc1_inst_hit_x      = lq_entry_ldc1_inst_hit;
assign lq_entry_lsdc0_inst_hit_x     = lq_entry_lsdc0_inst_hit;
assign lq_entry_lsdc1_inst_hit_x     = lq_entry_lsdc1_inst_hit;

assign lq_entry_ldc0_rar_spec_fail_x = lq_entry_ldc0_rar_spec_fail;
// assign lq_entry_ldc1_rar_spec_fail_x = lq_entry_ldc1_rar_spec_fail;
assign lq_entry_lsdc0_spec_fail_x    = lq_entry_lsdc0_spec_fail;
assign lq_entry_lsdc1_spec_fail_x    = lq_entry_lsdc1_spec_fail;

endmodule
