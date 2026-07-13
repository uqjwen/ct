//-----------------------------------------------------------------------------
// File          : xx_lsu_lq.sv
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
module xx_lsu_lq #(
    parameter IID_WIDTH = 10,
    parameter LQENTRY=8
)(
input logic                                     cp0_lsu_corr_dis,           
input logic                                     cp0_lsu_icg_en,             
input logic                                     cpurst_b,                   
input logic                                     forever_cpuclk,             
input logic [LQENTRY-1:0]                       lda0_ex3_lq_entry_pop,          
input logic [14:0]                              ldc0_ex2_pc,// wjh@sfp
input logic [`WK_PA_WIDTH-1:0]                  ldc0_ex2_addr0,                   
input logic [`WK_PA_WIDTH-1:0]                  ldc0_ex2_addr1,                   
input logic [15:0]                              ldc0_ex2_bytes_vld,               
input logic [15:0]                              ldc0_ex2_bytes_vld1,              
input logic                                     ldc0_ex2_inst_us,
input logic                                     ldc0_ex2_chk_atomic_inst_vld,     
input logic                                     ldc0_ex2_chk_ld_addr1_vld,        
input logic [IID_WIDTH-1 :0]                    ldc0_ex2_iid,                        
input logic                                     ldc0_ex2_inst_chk_vld,            
input logic                                     ldc0_lq_ex2_create_dp_vld,      
input logic                                     ldc0_lq_ex2_create_vld,         
input logic                                     ldc0_lq_ex2_create_gateclk_en,  
input logic                                     ldc0_ex2_secd,                    
// input logic [LQENTRY-1:0]    lda1_ex3_lq_entry_pop,          
// input logic [39:0]           ldc1_ex2_addr0,                   
// input logic [39:0]           ldc1_ex2_addr1,                   
// input logic [15:0]           ldc1_ex2_bytes_vld,               
// input logic [15:0]           ldc1_ex2_bytes_vld1,              
// input logic                  ldc1_ex2_chk_atomic_inst_vld,     
// input logic                  ldc1_ex2_chk_ld_addr1_vld,        
// input logic [IID_WIDTH-1 :0] ldc1_ex2_iid,                        
// input logic                  ldc1_ex2_inst_chk_vld,            
// input logic                  ldc1_lq_ex2_create_dp_vld,      
// input logic                  ldc1_lq_ex2_create_vld,         
// input logic                  ldc1_lq_ex2_create_gateclk_en,  
// input logic                  ldc1_ex2_secd,                    
input                                           rtu_ck_flush,
input   [IID_WIDTH-1  :0]                       rtu_ck_flush_iid,
input logic [LQENTRY-1:0]                       lsda0_ex3_lq_entry_pop,          
input logic [14:0]                              lsdc0_ex2_pc, // wjh@sfp
input logic [`WK_PA_WIDTH-1:0]                  lsdc0_ex2_addr0,                   
input logic [`WK_PA_WIDTH-1:0]                  lsdc0_ex2_addr1,                   
input logic [15:0]                              lsdc0_ex2_bytes_vld,               
input logic [15:0]                              lsdc0_ex2_bytes_vld1,              
input logic                                     lsdc0_ex2_inst_us,
input logic                                     lsdc0_ex2_chk_atomic_inst_vld,     
input logic                                     lsdc0_ex2_chk_ld_addr1_vld,        
input logic [IID_WIDTH-1 :0]                    lsdc0_ex2_iid,                        
input logic [IID_WIDTH-1 :0]                    lsdc0_ex2_ld_iid,//logic levels opt@LTL 
input logic                                     lsdc0_ex2_chk_ld_inst_vld,            
input logic                                     lsdc0_ex2_chk_st_inst_vld,            
input logic                                     lsdc0_lq_ex2_create_dp_vld,      
input logic                                     lsdc0_lq_ex2_create_vld,         
input logic                                     lsdc0_lq_ex2_create_gateclk_en,  
input logic                                     lsdc0_ex2_ld_secd,                    
input logic [LQENTRY-1:0]                       lsda1_ex3_lq_entry_pop,          
input logic [14:0]                              lsdc1_ex2_pc, // wjh@sfp
input logic [`WK_PA_WIDTH-1:0]                  lsdc1_ex2_addr0,                   
input logic [`WK_PA_WIDTH-1:0]                  lsdc1_ex2_addr1,                   
input logic [15:0]                              lsdc1_ex2_bytes_vld,               
input logic [15:0]                              lsdc1_ex2_bytes_vld1,              
input logic                                     lsdc1_ex2_inst_us,
input logic                                     lsdc1_ex2_chk_atomic_inst_vld,     
input logic                                     lsdc1_ex2_chk_ld_addr1_vld,        
input logic [IID_WIDTH-1 :0]                    lsdc1_ex2_iid,                        
input logic [IID_WIDTH-1 :0]                    lsdc1_ex2_ld_iid,//logic levels opt@LTL 
input logic                                     lsdc1_ex2_chk_ld_inst_vld,            
input logic                                     lsdc1_ex2_chk_st_inst_vld,            
input logic                                     lsdc1_lq_ex2_create_dp_vld,      
input logic                                     lsdc1_lq_ex2_create_vld,         
input logic                                     lsdc1_lq_ex2_create_gateclk_en,  
input logic                                     lsdc1_ex2_ld_secd,                    
input logic                                     pad_yy_icg_scan_en,         
input logic                                     rtu_lsu_flush_fe,           
input logic                                     rtu_yy_xx_commit0,            
input logic [IID_WIDTH-1:0]                     rtu_yy_xx_commit0_iid,        
input logic                                     rtu_yy_xx_commit1,            
input logic [IID_WIDTH-1:0]                     rtu_yy_xx_commit1_iid,        
input logic                                     rtu_yy_xx_commit2,            
input logic [IID_WIDTH-1:0]                     rtu_yy_xx_commit2_iid,        
input logic                                     rtu_yy_xx_commit3,            
input logic [IID_WIDTH-1:0]                     rtu_yy_xx_commit3_iid,        
input logic                                     rtu_yy_xx_commit4,            
input logic [IID_WIDTH-1:0]                     rtu_yy_xx_commit4_iid,        
input logic                                     rtu_yy_xx_commit5,            
input logic [IID_WIDTH-1:0]                     rtu_yy_xx_commit5_iid,        
input logic                                     rtu_yy_xx_commit6,            
input logic [IID_WIDTH-1:0]                     rtu_yy_xx_commit6_iid,        
input logic                                     rtu_yy_xx_commit7,            
input logic [IID_WIDTH-1:0]                     rtu_yy_xx_commit7_iid,    
input logic                                     rtu_yy_xx_flush,    
input logic                                     snq_lq_inv_req,  // wjh@mcores-rar
input logic [`WK_PA_WIDTH-7:0]                  snq_lq_inv_addr, // wjh@mcores-rar
input logic                                     vb_lq_inv_req,   // wjh@mcores-rar
input logic [`WK_PA_WIDTH-7:0]                  vb_lq_inv_addr,  // wjh@mcores-rar
output logic [LQENTRY-1:0]                      lq_ldc0_create_entry,
// output logic [LQENTRY-1:0]   lq_ldc1_create_entry,
output logic [LQENTRY-1:0]                      lq_lsdc0_create_entry,
output logic [LQENTRY-1:0]                      lq_lsdc1_create_entry,
output logic                                    lq_ldc0_ex2_full,
// output logic                 lq_ldc1_ex2_full,
output logic                                    lq_lsdc0_ex2_full,
output logic                                    lq_lsdc1_ex2_full,
output logic                                    lq_ldc0_ex2_inst_hit,
// output logic                 lq_ldc1_ex2_inst_hit,
output logic                                    lq_lsdc0_ex2_inst_hit,
output logic                                    lq_lsdc1_ex2_inst_hit,
output logic                                    lq_ldc0_ex2_less2,
// output logic                 lq_ldc1_ex2_less2,
output logic                                    lq_lsdc0_ex2_less2,
output logic                                    lq_lsdc1_ex2_less2,
output logic                                    lq_ldc0_ex2_rar_spec_fail,
// output logic                 lq_ldc1_ex2_rar_spec_fail,
output logic                                    lq_lsdc0_ex2_spec_fail,
output logic                                    lq_lsdc1_ex2_spec_fail,
output logic [14:0]                             lq_lsu0_ex2_spec_fail_pc,  // wjh@sfp
output logic [14:0]                             lq_lsu2_ex2_spec_fail_pc,  // wjh@sfp
output logic [14:0]                             lq_lsu3_ex2_spec_fail_pc,  // wjh@sfp
output logic                                    lsu0_idu_ex2_lq_not_full,
// output logic                 lsu1_idu_ex2_lq_not_full,
output logic                                    lsu2_idu_ex2_lq_not_full,
output logic                                    lsu3_idu_ex2_lq_not_full
);

localparam ENTRY4LD = 12;


logic                                           lq_clk_en;
logic                                           lq_empty;
logic                                           lq_clk;
logic [LQENTRY-1:0]                             lq_create_ptr0;
logic [LQENTRY-1:0]                             lq_entry_all1s_low0;
// logic [LQENTRY-1:0] lq_create_ptr1;
logic [LQENTRY-1:0]                             lq_entry_all1s_high0;
logic [LQENTRY-1:0]                             lq_create_ptr2;
logic [LQENTRY-1:0]                             lq_entry_all1s_low1;
logic [LQENTRY-1:0]                             lq_create_ptr3;
logic [LQENTRY-1:0]                             lq_create_ptr3_fix;
logic [LQENTRY-1:0]                             lq_entry_all1s_high1;
logic                                           lq_create0_success;
// logic               lq_create1_success;
logic                                           lq_create2_success;
logic                                           lq_create3_success;
logic [LQENTRY-1:0]                             lq_entry_create0_dp_vld;
logic [LQENTRY-1:0]                             lq_entry_create0_vld;
logic [LQENTRY-1:0]                             lq_entry_create0_gateclk_en;
// logic [LQENTRY-1:0] lq_entry_create1_dp_vld;
// logic [LQENTRY-1:0] lq_entry_create1_vld;
// logic [LQENTRY-1:0] lq_entry_create1_gateclk_en;
logic [LQENTRY-1:0]                             lq_entry_create2_dp_vld;
logic [LQENTRY-1:0]                             lq_entry_create2_vld;
logic [LQENTRY-1:0]                             lq_entry_create2_gateclk_en;
logic [LQENTRY-1:0]                             lq_entry_create3_dp_vld;
logic [LQENTRY-1:0]                             lq_entry_create3_vld;
logic [LQENTRY-1:0]                             lq_entry_create3_gateclk_en;
logic [LQENTRY-1:0]                             lq_entry_ldc0_inst_hit;
// logic [LQENTRY-1:0] lq_entry_ldc1_inst_hit;
logic [LQENTRY-1:0]                             lq_entry_lsdc0_inst_hit;
logic [LQENTRY-1:0]                             lq_entry_lsdc1_inst_hit;
logic [LQENTRY-1:0]                             lq_entry_ldc0_rar_spec_fail;
// logic [LQENTRY-1:0] lq_entry_ldc1_rar_spec_fail;
logic [LQENTRY-1:0]                             lq_entry_lsdc0_spec_fail;
logic [LQENTRY-1:0]                             lq_entry_lsdc1_spec_fail;
logic [LQENTRY-1:0]                             lq_entry_vld;
// logic               lq_full_low;
// logic               lq_full_high;
// logic               lq_less2_low;
// logic               lq_less2_high;
logic   rtu_ck_flush_iid_older_than_ldc0_iid;
logic   rtu_ck_flush_iid_older_than_lsdc0_iid;
logic   rtu_ck_flush_iid_older_than_lsdc1_iid;
logic                                           lq_full;
logic                                           lq_less2;
logic                                           lq_less3;
logic [LQENTRY-1:0]                             lq_create_agevec0;
logic [LQENTRY-1:0]                             lq_create_agevec2;
logic [LQENTRY-1:0]                             lq_create_agevec3;
logic [LQENTRY-1:0]                             lq_entry_older_than_lsu0;
logic [LQENTRY-1:0]                             lq_entry_older_than_lsu2;
logic [LQENTRY-1:0]                             lq_entry_older_than_lsu3;
logic                                           lq_create_old20;
logic                                           lq_create_old30;
logic                                           lq_create_old32;
logic [LQENTRY-1:0]                             lq_entry_pop_vld;
logic [LQENTRY-1:0]                             lsu0_spec_fail_1hot;
logic [LQENTRY-1:0]                             lsu2_spec_fail_1hot;
logic [LQENTRY-1:0]                             lsu3_spec_fail_1hot;
logic [LQENTRY-1:0][14:0]                       lq_entry_pc;
logic                                           lq_entry_agevec_updt_vld;
// wjh@mcores-rar                           
logic                                           ldc0_ex2_snped;
logic                                           lsdc0_ex2_snped;
logic                                           lsdc1_ex2_snped;
logic [LQENTRY-1:0]                             lsu0_spec_fail_1st_ptr;
logic [LQENTRY-1:0]                             lsu2_spec_fail_1st_ptr;
logic [LQENTRY-1:0]                             lsu3_spec_fail_1st_ptr;
//==========================================================
//                 Instance of Gated Cell  
//==========================================================
//if lq has entry or create lq, then this gateclk is on
//lq_clk is used for entry_vld
assign lq_clk_en  = !lq_empty
                    || ldc0_lq_ex2_create_gateclk_en
                    // || ldc1_lq_ex2_create_gateclk_en
                    || lsdc0_lq_ex2_create_gateclk_en
                    || lsdc1_lq_ex2_create_gateclk_en;
// &Instance("gated_clk_cell", "x_lsu_lq_gated_clk"); @39
gated_clk_cell  x_lsu_lq_gated_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (lq_clk            ),
  .external_en        (1'b0              ),
  .local_en           (lq_clk_en         ),
  .module_en          (cp0_lsu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);


generate
    for(genvar i=0; i< LQENTRY; i = i+1) begin 
        xx_lsu_lq_entry #(
            .IID_WIDTH(IID_WIDTH),
            .LQENTRY(LQENTRY)
        )
        i_xx_lsu_lq_entry(
        .cp0_lsu_corr_dis                 (cp0_lsu_corr_dis                 ),
        .cp0_lsu_icg_en                   (cp0_lsu_icg_en                   ),
        .cpurst_b                         (cpurst_b                         ),
        .forever_cpuclk                   (forever_cpuclk                   ),
        .lq_clk                           (lq_clk                           ),
        .lq_entry_pop_v                   (lq_entry_pop_vld                 ), // wjh@sfp
        .lq_entry_agevec_updt_vld_x       (lq_entry_agevec_updt_vld         ), // wjh@sfp
        .lsu0_create_vld_v                (lq_entry_create0_vld             ), // wjh@sfp
        .lsu2_create_vld_v                (lq_entry_create2_vld             ), // wjh@sfp
        .lsu3_create_vld_v                (lq_entry_create3_vld             ), // wjh@sfp
        .lsu0_spec_fail_v                 (lq_entry_ldc0_rar_spec_fail      ), // wjh@sfp
        .lsu2_spec_fail_v                 (lq_entry_lsdc0_spec_fail         ), // wjh@sfp
        .lsu3_spec_fail_v                 (lq_entry_lsdc1_spec_fail         ), // wjh@sfp
        .lda0_ex3_lq_entry_pop_x          (lda0_ex3_lq_entry_pop[i]         ),
        .ldc0_ex2_pc                      (ldc0_ex2_pc                      ), // wjh@sfp
        .lq_create_agevec0                (lq_create_agevec0                ), // wjh@sfp
        .ldc0_ex2_addr0                   (ldc0_ex2_addr0                   ),
        .ldc0_ex2_addr1                   (ldc0_ex2_addr1                   ),
        .ldc0_ex2_bytes_vld               (ldc0_ex2_bytes_vld               ),
        .ldc0_ex2_bytes_vld1              (ldc0_ex2_bytes_vld1              ),
        .ldc0_ex2_inst_us                 (ldc0_ex2_inst_us                 ),
        .ldc0_ex2_chk_atomic_inst_vld     (ldc0_ex2_chk_atomic_inst_vld     ),
        .ldc0_ex2_chk_ld_addr1_vld        (ldc0_ex2_chk_ld_addr1_vld        ),
        .ldc0_ex2_iid                     (ldc0_ex2_iid                     ),
        .ldc0_ex2_inst_chk_vld            (ldc0_ex2_inst_chk_vld            ),
        .ldc0_ex2_secd                    (ldc0_ex2_secd                    ),
        .ldc0_ex2_snped                   (ldc0_ex2_snped                   ), // wjh@mcores-rar
        .ldc0_lq_ex2_create_dp_vld_x      (lq_entry_create0_dp_vld[i]       ),
        .ldc0_lq_ex2_create_vld_x         (lq_entry_create0_vld[i]          ),
        .ldc0_lq_ex2_create_gateclk_en_x  (lq_entry_create0_gateclk_en[i]   ),
        // .lda1_ex3_lq_entry_pop_x          (lda1_ex3_lq_entry_pop[i]         ),
        // .ldc1_ex2_addr0                   (ldc1_ex2_addr0                   ),
        // .ldc1_ex2_addr1                   (ldc1_ex2_addr1                   ),
        // .ldc1_ex2_bytes_vld               (ldc1_ex2_bytes_vld               ),
        // .ldc1_ex2_bytes_vld1              (ldc1_ex2_bytes_vld1              ),
        // .ldc1_ex2_chk_atomic_inst_vld     (ldc1_ex2_chk_atomic_inst_vld     ),
        // .ldc1_ex2_chk_ld_addr1_vld        (ldc1_ex2_chk_ld_addr1_vld        ),
        // .ldc1_ex2_iid                     (ldc1_ex2_iid                     ),
        // .ldc1_ex2_inst_chk_vld            (ldc1_ex2_inst_chk_vld            ),
        // .ldc1_ex2_secd                    (ldc1_ex2_secd                    ),
        // .ldc1_lq_ex2_create_dp_vld_x      (lq_entry_create1_dp_vld[i]       ),
        // .ldc1_lq_ex2_create_vld_x         (lq_entry_create1_vld[i]          ),
        // .ldc1_lq_ex2_create_gateclk_en_x  (lq_entry_create1_gateclk_en[i]   ),
        .lsda0_ex3_lq_entry_pop_x         (lsda0_ex3_lq_entry_pop[i]        ),
        .lsdc0_ex2_pc                     (lsdc0_ex2_pc                     ), // wjh@sfp
        .lq_create_agevec2                (lq_create_agevec2                ), // wjh@sfp
        .lsdc0_ex2_addr0                  (lsdc0_ex2_addr0                  ),
        .lsdc0_ex2_addr1                  (lsdc0_ex2_addr1                  ),
        .lsdc0_ex2_bytes_vld              (lsdc0_ex2_bytes_vld              ),
        .lsdc0_ex2_bytes_vld1             (lsdc0_ex2_bytes_vld1             ),
        .lsdc0_ex2_inst_us                (lsdc0_ex2_inst_us                ),
        .lsdc0_ex2_chk_atomic_inst_vld    (lsdc0_ex2_chk_atomic_inst_vld    ),
        .lsdc0_ex2_chk_ld_addr1_vld       (lsdc0_ex2_chk_ld_addr1_vld       ),
        .lsdc0_ex2_iid                    (lsdc0_ex2_iid                    ),
        .lsdc0_ex2_ld_iid                 (lsdc0_ex2_ld_iid                 ),
        .lsdc0_ex2_chk_st_inst_vld        (lsdc0_ex2_chk_st_inst_vld        ),
        .lsdc0_ex2_chk_ld_inst_vld        (lsdc0_ex2_chk_ld_inst_vld        ),
        .lsdc0_ex2_ld_secd                (lsdc0_ex2_ld_secd                ),
        .lsdc0_ex2_snped                  (lsdc0_ex2_snped                  ), // wjh@mcores-rar
        .lsdc0_lq_ex2_create_dp_vld_x     (lq_entry_create2_dp_vld[i]       ),
        .lsdc0_lq_ex2_create_vld_x        (lq_entry_create2_vld[i]          ),
        .lsdc0_lq_ex2_create_gateclk_en_x (lq_entry_create2_gateclk_en[i]   ),
        .lsda1_ex3_lq_entry_pop_x         (lsda1_ex3_lq_entry_pop[i]        ),
        .lsdc1_ex2_pc                     (lsdc1_ex2_pc                     ), // wjh@sfp
        .lq_create_agevec3                (lq_create_agevec3                ), // wjh@sfp
        .lsdc1_ex2_addr0                  (lsdc1_ex2_addr0                  ),
        .lsdc1_ex2_addr1                  (lsdc1_ex2_addr1                  ),
        .lsdc1_ex2_bytes_vld              (lsdc1_ex2_bytes_vld              ),
        .lsdc1_ex2_bytes_vld1             (lsdc1_ex2_bytes_vld1             ),
        .lsdc1_ex2_inst_us                (lsdc1_ex2_inst_us                ),
        .lsdc1_ex2_chk_atomic_inst_vld    (lsdc1_ex2_chk_atomic_inst_vld    ),
        .lsdc1_ex2_chk_ld_addr1_vld       (lsdc1_ex2_chk_ld_addr1_vld       ),
        .lsdc1_ex2_iid                    (lsdc1_ex2_iid                    ),
        .lsdc1_ex2_ld_iid                 (lsdc1_ex2_ld_iid                 ),
        .lsdc1_ex2_chk_st_inst_vld        (lsdc1_ex2_chk_st_inst_vld        ),
        .lsdc1_ex2_chk_ld_inst_vld        (lsdc1_ex2_chk_ld_inst_vld        ),
        .lsdc1_ex2_ld_secd                (lsdc1_ex2_ld_secd                ),
        .lsdc1_ex2_snped                  (lsdc1_ex2_snped                  ), // wjh@mcores-rar
        .lsdc1_lq_ex2_create_dp_vld_x     (lq_entry_create3_dp_vld[i]     ),
        .lsdc1_lq_ex2_create_vld_x        (lq_entry_create3_vld[i]        ),
        .lsdc1_lq_ex2_create_gateclk_en_x (lq_entry_create3_gateclk_en[i] ),
        .pad_yy_icg_scan_en               (pad_yy_icg_scan_en               ),
        .rtu_yy_xx_commit0                (rtu_yy_xx_commit0                ),
        .rtu_yy_xx_commit0_iid            (rtu_yy_xx_commit0_iid            ),
        .rtu_yy_xx_commit1                (rtu_yy_xx_commit1                ),
        .rtu_yy_xx_commit1_iid            (rtu_yy_xx_commit1_iid            ),
        .rtu_yy_xx_commit2                (rtu_yy_xx_commit2                ),
        .rtu_yy_xx_commit2_iid            (rtu_yy_xx_commit2_iid            ),
        .rtu_yy_xx_commit3                (rtu_yy_xx_commit3                ),
        .rtu_yy_xx_commit3_iid            (rtu_yy_xx_commit3_iid            ),
        .rtu_yy_xx_commit4                (rtu_yy_xx_commit4                ),
        .rtu_yy_xx_commit4_iid            (rtu_yy_xx_commit4_iid            ),
        .rtu_yy_xx_commit5                (rtu_yy_xx_commit5                ),
        .rtu_yy_xx_commit5_iid            (rtu_yy_xx_commit5_iid            ),
        .rtu_yy_xx_commit6                (rtu_yy_xx_commit6                ),
        .rtu_yy_xx_commit6_iid            (rtu_yy_xx_commit6_iid            ),
        .rtu_yy_xx_commit7                (rtu_yy_xx_commit7                ),
        .rtu_yy_xx_commit7_iid            (rtu_yy_xx_commit7_iid            ),
        .rtu_yy_xx_flush                  (rtu_yy_xx_flush                  ),
        .rtu_ck_flush                     (rtu_ck_flush                     ),
        .rtu_ck_flush_iid                 (rtu_ck_flush_iid                 ),
        .snq_lq_inv_req                   (snq_lq_inv_req                   ), // wjh@mcores-rar
        .snq_lq_inv_addr                  (snq_lq_inv_addr                  ), // wjh@mcores-rar
        .vb_lq_inv_req                    (vb_lq_inv_req                    ),   // wjh@mcores-rar
        .vb_lq_inv_addr                   (vb_lq_inv_addr                   ),   // wjh@mcores-rar
        .lq_entry_pop_vld_x               (lq_entry_pop_vld[i]              ), // wjh@sfp
        .lq_entry_older_than_lsu0_x       (lq_entry_older_than_lsu0[i]      ), // wjh@sfp
        .lq_entry_older_than_lsu2_x       (lq_entry_older_than_lsu2[i]      ), // wjh@sfp
        .lq_entry_older_than_lsu3_x       (lq_entry_older_than_lsu3[i]      ), // wjh@sfp
        .lsu0_spec_fail_1hot_x            (lsu0_spec_fail_1hot[i]           ), // wjh@sfp
        .lsu2_spec_fail_1hot_x            (lsu2_spec_fail_1hot[i]           ), // wjh@sfp
        .lsu3_spec_fail_1hot_x            (lsu3_spec_fail_1hot[i]           ), // wjh@sfp
        .lq_entry_pc_v                    (lq_entry_pc[i]                   ), // wjh@sfp
        .lq_entry_ldc0_inst_hit_x         (lq_entry_ldc0_inst_hit[i]        ),
        // .lq_entry_ldc1_inst_hit_x         (lq_entry_ldc1_inst_hit[i]        ),
        .lq_entry_lsdc0_inst_hit_x        (lq_entry_lsdc0_inst_hit[i]       ),
        .lq_entry_lsdc1_inst_hit_x        (lq_entry_lsdc1_inst_hit[i]       ),
        .lq_entry_ldc0_rar_spec_fail_x    (lq_entry_ldc0_rar_spec_fail[i]   ),
        // .lq_entry_ldc1_rar_spec_fail_x    (lq_entry_ldc1_rar_spec_fail[i]   ),
        .lq_entry_lsdc0_spec_fail_x       (lq_entry_lsdc0_spec_fail[i]      ),
        .lq_entry_lsdc1_spec_fail_x       (lq_entry_lsdc1_spec_fail[i]      ),
        .lq_entry_vld_x                   (lq_entry_vld[i]                  )
        );
    end 
endgenerate

assign ldc0_ex2_snped = snq_lq_inv_req
                        && (ldc0_ex2_addr0[`WK_PA_WIDTH-1:6] == snq_lq_inv_addr[`WK_PA_WIDTH-7:0])
                      || vb_lq_inv_req && (ldc0_ex2_addr0[`WK_PA_WIDTH-1:6] == vb_lq_inv_addr[`WK_PA_WIDTH-7:0]);
assign lsdc0_ex2_snped = snq_lq_inv_req
                         && (lsdc0_ex2_addr0[`WK_PA_WIDTH-1:6] == snq_lq_inv_addr[`WK_PA_WIDTH-7:0])
                      || vb_lq_inv_req && (lsdc0_ex2_addr0[`WK_PA_WIDTH-1:6] == vb_lq_inv_addr[`WK_PA_WIDTH-7:0]);
assign lsdc1_ex2_snped = snq_lq_inv_req
                         && (lsdc1_ex2_addr0[`WK_PA_WIDTH-1:6] == snq_lq_inv_addr[`WK_PA_WIDTH-7:0])
                      || vb_lq_inv_req && (lsdc1_ex2_addr0[`WK_PA_WIDTH-1:6] == vb_lq_inv_addr[`WK_PA_WIDTH-7:0]);
// always_comb begin 
//     lq_create_ptr0[LQENTRY-1:1] = '0;
//     lq_create_ptr0[0]           = !lq_entry_vld[0];
//     lq_entry_all1s_low0         = '1;
//     for(int i=1; i< ENTRY4LD; i++) begin 
//         for(int j=0; j<i; j++) begin 
//             lq_entry_all1s_low0[i] = lq_entry_all1s_low0[i] & lq_entry_vld[j];
//         end 
//         lq_create_ptr0[i] = (lq_entry_vld[i]==1'b0) && (lq_entry_all1s_low0[i] == 1'b1);
//     end 
// end 


// always_comb begin 
//     lq_create_ptr1[LQENTRY-1:ENTRY4LD] = '0;
//     lq_create_ptr1[ENTRY4LD-1]         = !lq_entry_vld[ENTRY4LD-1];
//     lq_create_ptr1[ENTRY4LD-2:0]       = '0;
//     lq_entry_all1s_high0               = '1;
//     for(int i=ENTRY4LD-2; i>=0; i--) begin 
//         for(int j = ENTRY4LD-1; j>i; j--) begin 
//             lq_entry_all1s_high0[i] = lq_entry_all1s_high0[i] & lq_entry_vld[j];
//         end 
//         lq_create_ptr1[i] = (lq_entry_vld[i]==1'b0) && (lq_entry_all1s_high0[i] == 1'b1);
//     end 
// end 

// always_comb begin 
//     lq_create_ptr2[ENTRY4LD-1:0] = '0;
//     lq_create_ptr2[LQENTRY-1:ENTRY4LD+1] = '0;
//     lq_create_ptr2[ENTRY4LD] = !lq_entry_vld[ENTRY4LD];
//     lq_entry_all1s_low1      = '1;
//     for(int i=ENTRY4LD+1; i<LQENTRY; i++) begin 
//         for(int j=ENTRY4LD; j< i; j++) begin 
//             lq_entry_all1s_low1[i] = lq_entry_all1s_low1[i] & lq_entry_vld[j];
//         end 
//         lq_create_ptr2[i] = (lq_entry_vld[i] == 1'b0) && (lq_entry_all1s_low1[i] == 1'b1);
//     end 
// end 

// always_comb begin 
//     lq_create_ptr3[LQENTRY-1] = !lq_entry_vld[LQENTRY-1];
//     lq_create_ptr3[LQENTRY-2:0] = '0;
//     lq_entry_all1s_high1 = '1;
//     for(int i=LQENTRY-2; i>= ENTRY4LD; i--) begin 
//         for(int j=LQENTRY-1; j>i; j--) begin 
//             lq_entry_all1s_high1[i] = lq_entry_all1s_high1[i] & lq_entry_vld[j];
//         end 
//         lq_create_ptr3[i] = (lq_entry_vld[i] == 1'b0) && (lq_entry_all1s_high1[i] == 1'b1);
//     end 
// end 

assign lq_create_ptr0[0] = ~lq_entry_vld[0];
generate
    for(genvar i=1; i<LQENTRY; i++)
        assign lq_create_ptr0[i] = ~lq_entry_vld[i] & (&(lq_entry_vld[i-1:0]));
endgenerate
// assign lq_create_ptr0[1] = ~lq_entry_vld[1] && lq_entry_vld[0];
// assign lq_create_ptr0[2] = ~lq_entry_vld[2] && &(lq_entry_vld[1:0]);
// assign lq_create_ptr0[3] = ~lq_entry_vld[3] && &(lq_entry_vld[2:0]);
// assign lq_create_ptr0[4] = ~lq_entry_vld[4] && &(lq_entry_vld[3:0]);
// assign lq_create_ptr0[5] = ~lq_entry_vld[5] && &(lq_entry_vld[4:0]);
// assign lq_create_ptr0[6] = ~lq_entry_vld[6] && &(lq_entry_vld[5:0]);
// assign lq_create_ptr0[7] = ~lq_entry_vld[7] && &(lq_entry_vld[6:0]);
// assign lq_create_ptr0[8] = ~lq_entry_vld[8] && &(lq_entry_vld[7:0]);
// assign lq_create_ptr0[9] = ~lq_entry_vld[9] && &(lq_entry_vld[8:0]);
// assign lq_create_ptr0[10] = ~lq_entry_vld[10] && &(lq_entry_vld[9:0]);
// assign lq_create_ptr0[11] = ~lq_entry_vld[11] && &(lq_entry_vld[10:0]);
// assign lq_create_ptr0[12] = ~lq_entry_vld[12] && &(lq_entry_vld[11:0]);
// assign lq_create_ptr0[13] = ~lq_entry_vld[13] && &(lq_entry_vld[12:0]);
// assign lq_create_ptr0[14] = ~lq_entry_vld[14] && &(lq_entry_vld[13:0]);
// assign lq_create_ptr0[15] = ~lq_entry_vld[15] && &(lq_entry_vld[14:0]);
// assign lq_create_ptr0[16] = ~lq_entry_vld[16] && &(lq_entry_vld[15:0]);
// assign lq_create_ptr0[17] = ~lq_entry_vld[17] && &(lq_entry_vld[16:0]);
// assign lq_create_ptr0[18] = ~lq_entry_vld[18] && &(lq_entry_vld[17:0]);
// assign lq_create_ptr0[19] = ~lq_entry_vld[19] && &(lq_entry_vld[18:0]);
// assign lq_create_ptr0[20] = ~lq_entry_vld[20] && &(lq_entry_vld[19:0]);
// assign lq_create_ptr0[21] = ~lq_entry_vld[21] && &(lq_entry_vld[20:0]);
// assign lq_create_ptr0[22] = ~lq_entry_vld[22] && &(lq_entry_vld[21:0]);
// assign lq_create_ptr0[23] = ~lq_entry_vld[23] && &(lq_entry_vld[22:0]);

assign lq_create_ptr2[LQENTRY-1] = ~lq_entry_vld[LQENTRY-1];
generate 
    for(genvar i=LQENTRY-2; i>=0; i--)
        assign lq_create_ptr2[i] = ~lq_entry_vld[i] & (&(lq_entry_vld[LQENTRY-1:i+1]));
endgenerate
// assign lq_create_ptr2[22] = ~lq_entry_vld[22] && lq_entry_vld[23];
// assign lq_create_ptr2[21] = ~lq_entry_vld[21] && &(lq_entry_vld[23:22]);
// assign lq_create_ptr2[20] = ~lq_entry_vld[20] && &(lq_entry_vld[23:21]);
// assign lq_create_ptr2[19] = ~lq_entry_vld[19] && &(lq_entry_vld[23:20]);
// assign lq_create_ptr2[18] = ~lq_entry_vld[18] && &(lq_entry_vld[23:19]);
// assign lq_create_ptr2[17] = ~lq_entry_vld[17] && &(lq_entry_vld[23:18]);
// assign lq_create_ptr2[16] = ~lq_entry_vld[16] && &(lq_entry_vld[23:17]);
// assign lq_create_ptr2[15] = ~lq_entry_vld[15] && &(lq_entry_vld[23:16]);
// assign lq_create_ptr2[14] = ~lq_entry_vld[14] && &(lq_entry_vld[23:15]);
// assign lq_create_ptr2[13] = ~lq_entry_vld[13] && &(lq_entry_vld[23:14]);
// assign lq_create_ptr2[12] = ~lq_entry_vld[12] && &(lq_entry_vld[23:13]);
// assign lq_create_ptr2[11] = ~lq_entry_vld[11] && &(lq_entry_vld[23:12]);
// assign lq_create_ptr2[10] = ~lq_entry_vld[10] && &(lq_entry_vld[23:11]);
// assign lq_create_ptr2[9] = ~lq_entry_vld[9] && &(lq_entry_vld[23:10]);
// assign lq_create_ptr2[8] = ~lq_entry_vld[8] && &(lq_entry_vld[23:9]);
// assign lq_create_ptr2[7] = ~lq_entry_vld[7] && &(lq_entry_vld[23:8]);
// assign lq_create_ptr2[6] = ~lq_entry_vld[6] && &(lq_entry_vld[23:7]);
// assign lq_create_ptr2[5] = ~lq_entry_vld[5] && &(lq_entry_vld[23:6]);
// assign lq_create_ptr2[4] = ~lq_entry_vld[4] && &(lq_entry_vld[23:5]);
// assign lq_create_ptr2[3] = ~lq_entry_vld[3] && &(lq_entry_vld[23:4]);
// assign lq_create_ptr2[2] = ~lq_entry_vld[2] && &(lq_entry_vld[23:3]);
// assign lq_create_ptr2[1] = ~lq_entry_vld[1] && &(lq_entry_vld[23:2]);
// assign lq_create_ptr2[0] = ~lq_entry_vld[0] && &(lq_entry_vld[23:1]);

assign lq_create_ptr3[LQENTRY-1] = 1'b0;
generate
    for(genvar i=LQENTRY-2; i>=0; i--)
        assign lq_create_ptr3[i] = ~lq_entry_vld[i] & (&(lq_entry_vld[LQENTRY-1:i+1] | lq_create_ptr2[LQENTRY-1:i+1])) & (|(lq_create_ptr2[LQENTRY-1:i+1]));
endgenerate
// assign lq_create_ptr3[22] = ~lq_entry_vld[22] && &(lq_entry_vld[23]    | lq_create_ptr2[23])    && |(lq_create_ptr2[23]);
// assign lq_create_ptr3[21] = ~lq_entry_vld[21] && &(lq_entry_vld[23:22] | lq_create_ptr2[23:22]) && |(lq_create_ptr2[23:22]);
// assign lq_create_ptr3[20] = ~lq_entry_vld[20] && &(lq_entry_vld[23:21] | lq_create_ptr2[23:21]) && |(lq_create_ptr2[23:21]);
// assign lq_create_ptr3[19] = ~lq_entry_vld[19] && &(lq_entry_vld[23:20] | lq_create_ptr2[23:20]) && |(lq_create_ptr2[23:20]);
// assign lq_create_ptr3[18] = ~lq_entry_vld[18] && &(lq_entry_vld[23:19] | lq_create_ptr2[23:19]) && |(lq_create_ptr2[23:19]);
// assign lq_create_ptr3[17] = ~lq_entry_vld[17] && &(lq_entry_vld[23:18] | lq_create_ptr2[23:18]) && |(lq_create_ptr2[23:18]);
// assign lq_create_ptr3[16] = ~lq_entry_vld[16] && &(lq_entry_vld[23:17] | lq_create_ptr2[23:17]) && |(lq_create_ptr2[23:17]);
// assign lq_create_ptr3[15] = ~lq_entry_vld[15] && &(lq_entry_vld[23:16] | lq_create_ptr2[23:16]) && |(lq_create_ptr2[23:16]);
// assign lq_create_ptr3[14] = ~lq_entry_vld[14] && &(lq_entry_vld[23:15] | lq_create_ptr2[23:15]) && |(lq_create_ptr2[23:15]);
// assign lq_create_ptr3[13] = ~lq_entry_vld[13] && &(lq_entry_vld[23:14] | lq_create_ptr2[23:14]) && |(lq_create_ptr2[23:14]);
// assign lq_create_ptr3[12] = ~lq_entry_vld[12] && &(lq_entry_vld[23:13] | lq_create_ptr2[23:13]) && |(lq_create_ptr2[23:13]);
// assign lq_create_ptr3[11] = ~lq_entry_vld[11] && &(lq_entry_vld[23:12] | lq_create_ptr2[23:12]) && |(lq_create_ptr2[23:12]);
// assign lq_create_ptr3[10] = ~lq_entry_vld[10] && &(lq_entry_vld[23:11] | lq_create_ptr2[23:11]) && |(lq_create_ptr2[23:11]);
// assign lq_create_ptr3[9] = ~lq_entry_vld[9] && &(lq_entry_vld[23:10] | lq_create_ptr2[23:10]) && |(lq_create_ptr2[23:10]);
// assign lq_create_ptr3[8] = ~lq_entry_vld[8] && &(lq_entry_vld[23:9] | lq_create_ptr2[23:9]) && |(lq_create_ptr2[23:9]);
// assign lq_create_ptr3[7] = ~lq_entry_vld[7] && &(lq_entry_vld[23:8] | lq_create_ptr2[23:8]) && |(lq_create_ptr2[23:8]);
// assign lq_create_ptr3[6] = ~lq_entry_vld[6] && &(lq_entry_vld[23:7] | lq_create_ptr2[23:7]) && |(lq_create_ptr2[23:7]);
// assign lq_create_ptr3[5] = ~lq_entry_vld[5] && &(lq_entry_vld[23:6] | lq_create_ptr2[23:6]) && |(lq_create_ptr2[23:6]);
// assign lq_create_ptr3[4] = ~lq_entry_vld[4] && &(lq_entry_vld[23:5] | lq_create_ptr2[23:5]) && |(lq_create_ptr2[23:5]);
// assign lq_create_ptr3[3] = ~lq_entry_vld[3] && &(lq_entry_vld[23:4] | lq_create_ptr2[23:4]) && |(lq_create_ptr2[23:4]);
// assign lq_create_ptr3[2] = ~lq_entry_vld[2] && &(lq_entry_vld[23:3] | lq_create_ptr2[23:3]) && |(lq_create_ptr2[23:3]);
// assign lq_create_ptr3[1] = ~lq_entry_vld[1] && &(lq_entry_vld[23:2] | lq_create_ptr2[23:2]) && |(lq_create_ptr2[23:2]);
// assign lq_create_ptr3[0] = ~lq_entry_vld[0] && &(lq_entry_vld[23:1] | lq_create_ptr2[23:1]) && |(lq_create_ptr2[23:1]);



assign lq_empty     = !(|lq_entry_vld[LQENTRY-1:0]);
// assign lq_full_low  = &lq_entry_vld[ENTRY4LD-1:0];
// assign lq_full_high = &lq_entry_vld[LQENTRY-1:ENTRY4LD];
assign lq_full      = &lq_entry_vld[LQENTRY-1:0];
// 1. when 2 holes left, ptr2=ptr0
// 2. when 1 hole left, ptr1=ptr0, ptr2=0
// 3. when no hole left, ptr0=ptr1=ptr2=0
assign lq_less2 = &(lq_entry_vld[LQENTRY-1:0] 
                    | lq_create_ptr0[LQENTRY-1:0]);
assign lq_less3 = &(lq_entry_vld[LQENTRY-1:0] 
                    | lq_create_ptr0[LQENTRY-1:0] 
                    | lq_create_ptr2[LQENTRY-1:0]);


//==========================================================
//                 Generate create pointer
//==========================================================
xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH)) 
x_lsu_ck_flush_compare_ldc0_iid (
  .x_iid0                    (rtu_ck_flush_iid[IID_WIDTH-1:0]),
  .x_iid0_older              (rtu_ck_flush_iid_older_than_ldc0_iid  ),
  .x_iid1                    (ldc0_ex2_iid[IID_WIDTH-1:0]           )
);
xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH)) 
x_lsu_ck_flush_compare_lsdc0_iid (
  .x_iid0                    (rtu_ck_flush_iid[IID_WIDTH-1:0]),
  .x_iid0_older              (rtu_ck_flush_iid_older_than_lsdc0_iid  ),
  .x_iid1                    (lsdc0_ex2_ld_iid[IID_WIDTH-1:0]        )
);
xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH)) 
x_lsu_ck_flush_compare_lsdc1_iid (
  .x_iid0                    (rtu_ck_flush_iid[IID_WIDTH-1:0]),
  .x_iid0_older              (rtu_ck_flush_iid_older_than_lsdc1_iid  ),
  .x_iid1                    (lsdc1_ex2_ld_iid[IID_WIDTH-1:0]        )
);
assign lq_create0_success = ldc0_lq_ex2_create_vld
                            && !rtu_lsu_flush_fe
                            && !(rtu_ck_flush && rtu_ck_flush_iid_older_than_ldc0_iid)    //flush younger entry create, ck_flush@LTL
                            && !lq_full;

// assign lq_create1_success = ldc1_lq_ex2_create_vld
//                             && !rtu_lsu_flush_fe
//                             && (!lq_less2_low
//                                 || !lq_full_low && !ldc0_lq_ex2_create_vld);

// assign lq_create2_success = lsdc0_lq_ex2_create_vld
//                             && !rtu_lsu_flush_fe
//                             && !lq_full_high;
assign lq_create2_success = lsdc0_lq_ex2_create_vld
                            && !rtu_lsu_flush_fe
                            && !(rtu_ck_flush && rtu_ck_flush_iid_older_than_lsdc0_iid)   //flush younger entry create, ck_flush@LTL
                            && (!lq_less2 // >=2 holes: creation success
                                || !lq_full && !ldc0_lq_ex2_create_vld); // ==1 hole, creation success on !ldc0_lq_ex2_create_vld

// assign lq_create3_success = lsdc1_lq_ex2_create_vld
//                             && !rtu_lsu_flush_fe
//                             && (!lq_less2_high
//                                 || !lq_full_high && !lsdc0_lq_ex2_create_vld);
assign lq_create3_success = lsdc1_lq_ex2_create_vld
                            && !rtu_lsu_flush_fe
                            && !(rtu_ck_flush && rtu_ck_flush_iid_older_than_lsdc1_iid)   //flush younger entry create, ck_flush@LTL
                            && (!lq_less3 // >=3 holes: creation success
                                || !lq_less2 && (!ldc0_lq_ex2_create_vld || !lsdc0_lq_ex2_create_vld)
                                || !lq_full  && (!ldc0_lq_ex2_create_vld && !lsdc0_lq_ex2_create_vld)); // ==2 hole,

// ldc0
assign lq_entry_create0_vld        = {LQENTRY{lq_create0_success}}
                                     & lq_create_ptr0[LQENTRY-1:0];

assign lq_entry_create0_dp_vld     = {LQENTRY{ldc0_lq_ex2_create_dp_vld}}
                                     & lq_create_ptr0[LQENTRY-1:0];

assign lq_entry_create0_gateclk_en = {LQENTRY{ldc0_lq_ex2_create_gateclk_en}}
                                     & lq_create_ptr0[LQENTRY-1:0];
// ldc1
// assign lq_entry_create1_vld        = {LQENTRY{lq_create1_success}}
//                                      & lq_create_ptr1[LQENTRY-1:0];

// assign lq_entry_create1_dp_vld     = {LQENTRY{ldc1_lq_ex2_create_dp_vld}}
//                                      & lq_create_ptr1[LQENTRY-1:0];

// assign lq_entry_create1_gateclk_en = {LQENTRY{ldc1_lq_ex2_create_gateclk_en}}
                                    //  & lq_create_ptr1[LQENTRY-1:0];
// lsdc0
assign lq_entry_create2_vld        = {LQENTRY{lq_create2_success}}
                                     & lq_create_ptr2[LQENTRY-1:0];

assign lq_entry_create2_dp_vld     = {LQENTRY{lsdc0_lq_ex2_create_dp_vld}}
                                     & lq_create_ptr2[LQENTRY-1:0];

assign lq_entry_create2_gateclk_en = {LQENTRY{lsdc0_lq_ex2_create_gateclk_en}}
                                     & lq_create_ptr2[LQENTRY-1:0];
// lsdc1
assign lq_create_ptr3_fix = lsdc0_lq_ex2_create_vld? lq_create_ptr3: lq_create_ptr2;

assign lq_entry_create3_vld        = {LQENTRY{lq_create3_success}}
                                     & lq_create_ptr3_fix[LQENTRY-1:0];

assign lq_entry_create3_dp_vld     = {LQENTRY{lsdc1_lq_ex2_create_dp_vld}}
                                     & lq_create_ptr3_fix[LQENTRY-1:0];

assign lq_entry_create3_gateclk_en = {LQENTRY{lsdc1_lq_ex2_create_gateclk_en}}
                                     & lq_create_ptr3_fix[LQENTRY-1:0];

// wjh@sfp begin 
xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH))  
x_lsu_lq_create_old20 (
  .x_iid0                        (lsdc0_ex2_ld_iid),
  .x_iid0_older                  (lq_create_old20 ),
  .x_iid1                        (ldc0_ex2_iid    )
);
xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH))  
x_lsu_lq_create_old30 (
  .x_iid0                        (lsdc1_ex2_ld_iid),
  .x_iid0_older                  (lq_create_old30 ),
  .x_iid1                        (ldc0_ex2_iid    )
);
xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH))  
x_lsu_lq_create_old32 (
  .x_iid0                        (lsdc1_ex2_ld_iid),
  .x_iid0_older                  (lq_create_old32 ),
  .x_iid1                        (lsdc0_ex2_ld_iid)
);
assign lq_create_agevec0 = lq_entry_older_than_lsu0[LQENTRY-1:0]
                           | ({LQENTRY{lq_create_old20}} & lq_entry_create2_vld[LQENTRY-1:0])
                           | ({LQENTRY{lq_create_old30}} & lq_entry_create3_vld[LQENTRY-1:0]);
assign lq_create_agevec2 = lq_entry_older_than_lsu2[LQENTRY-1:0]
                           | ({LQENTRY{lq_create_old32}}  & lq_entry_create3_vld[LQENTRY-1:0])
                           | ({LQENTRY{~lq_create_old20}} & lq_entry_create0_vld[LQENTRY-1:0]);
assign lq_create_agevec3 = lq_entry_older_than_lsu3[LQENTRY-1:0]
                           | ({LQENTRY{~lq_create_old30}} & lq_entry_create0_vld[LQENTRY-1:0])
                           | ({LQENTRY{~lq_create_old32}} & lq_entry_create2_vld[LQENTRY-1:0]);
assign lq_entry_agevec_updt_vld   = lq_create0_success
                                    || lq_create2_success
                                    || lq_create3_success
                                    || |(lq_entry_pop_vld[LQENTRY-1:0]);
always_comb begin 
    lq_lsu0_ex2_spec_fail_pc = {15{1'b0}};
    for(int i=0; i<LQENTRY; i++)
        if(lsu0_spec_fail_1st_ptr[i] == 1'b1)
            lq_lsu0_ex2_spec_fail_pc = lq_entry_pc[i];
end 
always_comb begin 
    lq_lsu2_ex2_spec_fail_pc = {15{1'b0}};
    for(int i=0; i<LQENTRY; i++)
        if(lsu2_spec_fail_1st_ptr[i] == 1'b1)
            lq_lsu2_ex2_spec_fail_pc = lq_entry_pc[i];
end 
always_comb begin 
    lq_lsu3_ex2_spec_fail_pc = {15{1'b0}};
    for(int i=0; i<LQENTRY; i++)
        if(lsu3_spec_fail_1st_ptr[i] == 1'b1)
            lq_lsu3_ex2_spec_fail_pc = lq_entry_pc[i];
end 
assign lsu0_spec_fail_1st_ptr[0] = lsu0_spec_fail_1hot[0];
assign lsu2_spec_fail_1st_ptr[0] = lsu2_spec_fail_1hot[0];
assign lsu3_spec_fail_1st_ptr[0] = lsu3_spec_fail_1hot[0];
generate
    for(genvar i=1; i<LQENTRY; i++)begin 
        assign lsu0_spec_fail_1st_ptr[i] = lsu0_spec_fail_1hot[i] & ~(|lsu0_spec_fail_1hot[i-1:0]);
        assign lsu2_spec_fail_1st_ptr[i] = lsu2_spec_fail_1hot[i] & ~(|lsu2_spec_fail_1hot[i-1:0]);
        assign lsu3_spec_fail_1st_ptr[i] = lsu3_spec_fail_1hot[i] & ~(|lsu3_spec_fail_1hot[i-1:0]);
    end
endgenerate
// wjh@sfp end

//==========================================================
//                 Generate interface
//==========================================================
// &Force("output", "lq_ld_dc_full"); @180
// &Force("output", "lq_ld_dc_less2"); @181
// assign lq_less2_low  = &(lq_create_ptr0[ENTRY4LD-1:0] | lq_entry_vld[ENTRY4LD-1:0]);
// assign lq_less2_high = &(lq_create_ptr2[LQENTRY-1:ENTRY4LD] | lq_entry_vld[LQENTRY-1:ENTRY4LD]);

// assign lq_ldc0_ex2_full   = lq_full_low;
assign lq_ldc0_ex2_full   = lq_full;
// assign lq_ldc1_ex2_full   = lq_full_low;
// assign lq_lsdc0_ex2_full  = lq_full_high;
assign lq_lsdc0_ex2_full  = lq_full
                            || lq_less2 && ldc0_lq_ex2_create_vld;
// assign lq_lsdc1_ex2_full  = lq_full_high
//                             || lq_less2_high && lsdc0_lq_ex2_create_vld;
assign lq_lsdc1_ex2_full  = lq_full
                            || lq_less2 && (ldc0_lq_ex2_create_vld || lsdc0_lq_ex2_create_vld) // <=1 hole, ptr2 = 0
                            || lq_less3 && (ldc0_lq_ex2_create_vld && lsdc0_lq_ex2_create_vld); // <=2 hole, ptr2 = ptr0
assign lq_ldc0_ex2_less2  = lq_less2; // useless, for unalign load
// assign lq_ldc1_ex2_less2  = lq_less2_low;
assign lq_lsdc0_ex2_less2 = lq_less2; // useless, for unalign cb accelerate
assign lq_lsdc1_ex2_less2 = lq_less2
                            || lq_less3 && (ldc0_lq_ex2_create_vld && lsdc0_lq_ex2_create_vld); 

assign lq_ldc0_ex2_inst_hit      = |lq_entry_ldc0_inst_hit;
// assign lq_ldc1_ex2_inst_hit      = |lq_entry_ldc1_inst_hit;
assign lq_lsdc0_ex2_inst_hit     = |lq_entry_lsdc0_inst_hit;
assign lq_lsdc1_ex2_inst_hit     = |lq_entry_lsdc1_inst_hit;
assign lq_ldc0_ex2_rar_spec_fail = |lq_entry_ldc0_rar_spec_fail;
// assign lq_ldc1_ex2_rar_spec_fail = |lq_entry_ldc1_rar_spec_fail;
assign lq_lsdc0_ex2_spec_fail    = |lq_entry_lsdc0_spec_fail;
assign lq_lsdc1_ex2_spec_fail    = |lq_entry_lsdc1_spec_fail;

assign lsu0_idu_ex2_lq_not_full = !lq_full;
// assign lsu1_idu_ex2_lq_not_full = !lq_full_low;
assign lsu2_idu_ex2_lq_not_full = !lq_full;
assign lsu3_idu_ex2_lq_not_full = !lq_full;
assign lq_ldc0_create_entry     = lq_entry_create0_vld;
// assign lq_ldc1_create_entry     = lq_entry_create1_vld;
assign lq_lsdc0_create_entry    = lq_entry_create2_vld;
assign lq_lsdc1_create_entry    = lq_entry_create3_vld;
endmodule
// def print_3create(entry, reserve):
//     print("\\\\print_3create")
//     for i in range(entry):
//         if i==0:
//             print("assign lq_create_ptr0[0] = ~lq_entry_vld[0];")
//         elif i==1:
//             print("assign lq_create_ptr0[1] = ~lq_entry_vld[1] && lq_entry_vld[0];")
//         else:
//             print("assign lq_create_ptr0["+str(i)+"] = ~lq_entry_vld["+str(i)+"] && &(lq_entry_vld["+str(i-1)+":0]);")
//     print("")
//     for i in range(reserve):
//         print("assign lq_create_ptr2["+str(entry-i-1)+"] = 1'b0;")
//     for i in range(entry-reserve-1,-1,-1):
//         if(i == entry-reserve-1):
//             print("assign lq_create_ptr2["+str(i)+"] = ~lq_entry_vld["+str(i)+"];")
//         elif(i == entry-reserve-2):
//             print("assign lq_create_ptr2["+str(i)+"] = ~lq_entry_vld["+str(i)+"] && lq_entry_vld["+str(i+1)+"];")
//         else:
//             print("assign lq_create_ptr2["+str(i)+"] = ~lq_entry_vld["+str(i)+"] && &(lq_entry_vld["+str(entry-1-reserve)+":"+str(i+1)+"]);")
//     print("")
//     for i in range(reserve):
//         print("assign lq_create_ptr3["+str(entry-i-1)+"] = 1'b0;")
//     
//     for i in range(entry-reserve-1,-1,-1):
//         if(i == entry-reserve-1):
//             print("assign lq_create_ptr3["+str(i)+"] = 1'b0;")
//         elif(i == entry-reserve-2):
//             print("assign lq_create_ptr3["+str(i)+"] = ~lq_entry_vld["+str(i)+"] && &(lq_entry_vld["+str(i+1)+"]    | lq_create_ptr2["+str(i+1)+"])    && |(lq_create_ptr2["+str(i+1)+"]);")
//         else:
//             print("assign lq_create_ptr3["+str(i)+"] = ~lq_entry_vld["+str(i)+"] && &(lq_entry_vld["+str(entry-reserve-1)+":"+str(i+1)+"] | lq_create_ptr2["+str(entry-reserve-1)+":"+str(i+1)+"]) && |(lq_create_ptr2["+str(entry-reserve-1)+":"+str(i+1)+"]);")
