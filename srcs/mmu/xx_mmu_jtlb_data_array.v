//-----------------------------------------------------------------------------
// File          : xx_mmu_jtlb_data_array.v
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


// $Id: xx_mmu_jtlb_data_array.vp,v 1.9 2022/01/06 08:14:36 jizk Exp $
// *****************************************************************************

// &ModuleBeg; @23
module xx_mmu_jtlb_data_array(
  cp0_mmu_icg_en,
  forever_cpuclk,
  jtlb_data_cen0,
  jtlb_data_cen1,
  jtlb_data_din,
  jtlb_data_dout0,
  jtlb_data_dout1,
  jtlb_data_idx,
  jtlb_data_wen,
  pad_yy_icg_scan_en,
  pad_sram_RME,
  pad_sram_RM
);
input                     pad_sram_RME;
input   [3   :0]          pad_sram_RM;
 
// &Ports; @24
input           cp0_mmu_icg_en;    
input           forever_cpuclk;    
input           jtlb_data_cen0;    
input           jtlb_data_cen1;    
input   [2*(`MMU_DATA_WIDTH)+3:0]  jtlb_data_din;     
input   [7 :0]  jtlb_data_idx;     
input   [3 :0]  jtlb_data_wen;     
input           pad_yy_icg_scan_en; 
output  [2*(`MMU_DATA_WIDTH)+3:0]  jtlb_data_dout0;   
output  [2*(`MMU_DATA_WIDTH)+3:0]  jtlb_data_dout1;   

// &Regs; @25
wire             pad_sram_RME;
wire    [3   :0] pad_sram_RM;

// &Wires; @26
wire            cp0_mmu_icg_en;    
wire            forever_cpuclk;    
wire    [2*(`MMU_DATA_WIDTH)+3:0]  jtlb_data_bwen0;   
wire    [2*(`MMU_DATA_WIDTH)+3:0]  jtlb_data_bwen0_b; 
wire    [2*(`MMU_DATA_WIDTH)+3:0]  jtlb_data_bwen1;   
wire    [2*(`MMU_DATA_WIDTH)+3:0]  jtlb_data_bwen1_b; 
wire            jtlb_data_cen0;    
wire            jtlb_data_cen0_b;  
wire            jtlb_data_cen1;    
wire            jtlb_data_cen1_b;  
wire            jtlb_data_clk;     
wire            jtlb_data_clk_en;  
wire    [2*(`MMU_DATA_WIDTH)+3:0]  jtlb_data_din;     
wire    [2*(`MMU_DATA_WIDTH)+3:0]  jtlb_data_dout0;   
wire    [2*(`MMU_DATA_WIDTH)+3:0]  jtlb_data_dout1;   
wire            jtlb_data_gwen0;   
wire            jtlb_data_gwen0_b; 
wire            jtlb_data_gwen1;   
wire            jtlb_data_gwen1_b; 
wire    [7 :0]  jtlb_data_idx;     
wire    [3 :0]  jtlb_data_wen;     
wire            pad_yy_icg_scan_en; 



//==========================================================
//                  Gate Cell
//==========================================================
assign jtlb_data_clk_en = jtlb_data_cen1 || jtlb_data_cen0; 
// &Instance("gated_clk_cell", "x_jtlb_data_gateclk"); @33
gated_clk_cell  x_jtlb_data_gateclk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (jtlb_data_clk     ),
  .external_en        (1'b0              ),
  .local_en           (jtlb_data_clk_en  ),
  .module_en          (cp0_mmu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect( .clk_in     (forever_cpuclk  ), @34
//           .external_en(1'b0            ), @35
//           .module_en  (cp0_mmu_icg_en  ), @36
//           .local_en   (jtlb_data_clk_en), @37
//           .clk_out    (jtlb_data_clk   ) @38
//          ); @39


assign jtlb_data_gwen1        = |jtlb_data_wen[3:2];
assign jtlb_data_bwen1[2*(`MMU_DATA_WIDTH)-1:0] = {
                                                 {`MMU_DATA_WIDTH{jtlb_data_wen[3]}},
                                                 {`MMU_DATA_WIDTH{jtlb_data_wen[2]}}
                                                };


assign jtlb_data_gwen0        = |jtlb_data_wen[1:0];
assign jtlb_data_bwen0[2*(`MMU_DATA_WIDTH)-1:0] = {
                                                 {`MMU_DATA_WIDTH{jtlb_data_wen[1]}},
                                                 {`MMU_DATA_WIDTH{jtlb_data_wen[0]}}
                                                };

assign jtlb_data_cen1_b = !jtlb_data_cen1;
assign jtlb_data_cen0_b = !jtlb_data_cen0;

assign jtlb_data_gwen1_b = !jtlb_data_gwen1;
assign jtlb_data_gwen0_b = !jtlb_data_gwen0;

assign jtlb_data_bwen1_b[2*(`MMU_DATA_WIDTH)-1:0] = ~jtlb_data_bwen1[2*(`MMU_DATA_WIDTH)-1:0];
assign jtlb_data_bwen0_b[2*(`MMU_DATA_WIDTH)-1:0] = ~jtlb_data_bwen0[2*(`MMU_DATA_WIDTH)-1:0];


assign jtlb_data_bwen1[2*(`MMU_DATA_WIDTH)+3:2*(`MMU_DATA_WIDTH)] = {
                                                                 {2{jtlb_data_wen[3]}},
                                                                 {2{jtlb_data_wen[2]}}
                                                                };
assign jtlb_data_bwen0[2*(`MMU_DATA_WIDTH)+3:2*(`MMU_DATA_WIDTH)] = {
                                                                 {2{jtlb_data_wen[1]}},
                                                                 {2{jtlb_data_wen[0]}}
                                                                };

assign jtlb_data_bwen1_b[2*(`MMU_DATA_WIDTH)+3:2*(`MMU_DATA_WIDTH)] = ~jtlb_data_bwen1[2*(`MMU_DATA_WIDTH)+3:2*(`MMU_DATA_WIDTH)];
assign jtlb_data_bwen0_b[2*(`MMU_DATA_WIDTH)+3:2*(`MMU_DATA_WIDTH)] = ~jtlb_data_bwen0[2*(`MMU_DATA_WIDTH)+3:2*(`MMU_DATA_WIDTH)];
`ifdef WK_PA_WIDTH_40
// &Instance("wk_spsram_256x88","x_wk_spsram_256x88_bank1"); @79
wk_spsram_256x88  x_wk_spsram_256x88_bank1 (
  .A                  (jtlb_data_idx[7:0]),
  .CEN                (jtlb_data_cen1_b  ),
  .CLK                (jtlb_data_clk     ),
  .D                  (jtlb_data_din     ),
  .GWEN               (jtlb_data_gwen1_b ),
  .Q                  (jtlb_data_dout1   ),
  .WEN                (jtlb_data_bwen1_b )
);

// &Connect( @80
//          .CLK    (jtlb_data_clk     ), @81
//          .CEN    (jtlb_data_cen1_b  ), @82
//          .GWEN   (jtlb_data_gwen1_b ), @83
//          .WEN    (jtlb_data_bwen1_b ), @84
//          .A      (jtlb_data_idx[7:0]), @85
//          .D      (jtlb_data_din     ), @86
//          .Q      (jtlb_data_dout1   ) @87
//        ); @88

// &Instance("wk_spsram_256x88","x_wk_spsram_256x88_bank0"); @90
wk_spsram_256x88  x_wk_spsram_256x88_bank0 (
  .A                  (jtlb_data_idx[7:0]),
  .CEN                (jtlb_data_cen0_b  ),
  .CLK                (jtlb_data_clk     ),
  .D                  (jtlb_data_din     ),
  .GWEN               (jtlb_data_gwen0_b ),
  .Q                  (jtlb_data_dout0   ),
  .WEN                (jtlb_data_bwen0_b )
);
`endif

`ifdef WK_PA_WIDTH_48
wk_spsram_256x104  x_wk_spsram_256x104_bank1 (
  .A                  (jtlb_data_idx[7:0]        ),
  .CEN                (jtlb_data_cen1_b          ),
  .CLK                (jtlb_data_clk             ),
  .D                  (jtlb_data_din     ),
  .GWEN               (jtlb_data_gwen1_b         ),
  .Q                  (jtlb_data_dout1           ),
  .WEN                (jtlb_data_bwen1_b ),
  .RME                (pad_sram_RME     ),
  .RM                 (pad_sram_RM      )
);
wk_spsram_256x104  x_wk_spsram_256x104_bank0 (
  .A                  (jtlb_data_idx[7:0]        ),
  .CEN                (jtlb_data_cen0_b          ),
  .CLK                (jtlb_data_clk             ),
  .D                  (jtlb_data_din     ),
  .GWEN               (jtlb_data_gwen0_b         ),
  .Q                  (jtlb_data_dout0           ),
  .WEN                (jtlb_data_bwen0_b ),
  .RME                (pad_sram_RME     ),
  .RM                 (pad_sram_RM      )
);
`endif 
// &Connect( @91
//          .CLK    (jtlb_data_clk     ), @92
//          .CEN    (jtlb_data_cen0_b  ), @93
//          .GWEN   (jtlb_data_gwen0_b ), @94
//          .WEN    (jtlb_data_bwen0_b ), @95
//          .A      (jtlb_data_idx[7:0]), @96
//          .D      (jtlb_data_din     ), @97
//          .Q      (jtlb_data_dout0   ) @98
//        ); @99


// &Instance("wk_spsram_512x88","x_wk_spsram_512x88_bank1"); @104
// &Connect( @105
//          .CLK    (jtlb_data_clk     ), @106
//          .CEN    (jtlb_data_cen1_b  ), @107
//          .GWEN   (jtlb_data_gwen1_b ), @108
//          .WEN    (jtlb_data_bwen1_b ), @109
//          .A      (jtlb_data_idx[8:0]), @110
//          .D      (jtlb_data_din     ), @111
//          .Q      (jtlb_data_dout1   ) @112
//        ); @113
// &Instance("wk_spsram_512x88","x_wk_spsram_512x88_bank0"); @115
// &Connect( @116
//          .CLK    (jtlb_data_clk     ), @117
//          .CEN    (jtlb_data_cen0_b  ), @118
//          .GWEN   (jtlb_data_gwen0_b ), @119
//          .WEN    (jtlb_data_bwen0_b ), @120
//          .A      (jtlb_data_idx[8:0]), @121
//          .D      (jtlb_data_din     ), @122
//          .Q      (jtlb_data_dout0   ) @123
//        ); @124

// &Instance("wk_spsram_256x84","x_wk_spsram_256x84_bank1"); @130
// &Connect( @131
//          .CLK    (jtlb_data_clk     ), @132
//          .CEN    (jtlb_data_cen1_b  ), @133
//          .GWEN   (jtlb_data_gwen1_b ), @134
//          .WEN    (jtlb_data_bwen1_b ), @135
//          .A      (jtlb_data_idx[7:0]), @136
//          .D      (jtlb_data_din     ), @137
//          .Q      (jtlb_data_dout1   ) @138
//        ); @139
// &Instance("wk_spsram_256x84","x_wk_spsram_256x84_bank0"); @141
// &Connect( @142
//          .CLK    (jtlb_data_clk     ), @143
//          .CEN    (jtlb_data_cen0_b  ), @144
//          .GWEN   (jtlb_data_gwen0_b ), @145
//          .WEN    (jtlb_data_bwen0_b ), @146
//          .A      (jtlb_data_idx[7:0]), @147
//          .D      (jtlb_data_din     ), @148
//          .Q      (jtlb_data_dout0   ) @149
//        ); @150
// &Instance("wk_spsram_512x84","x_wk_spsram_512x84_bank1"); @154
// &Connect( @155
//          .CLK    (jtlb_data_clk     ), @156
//          .CEN    (jtlb_data_cen1_b  ), @157
//          .GWEN   (jtlb_data_gwen1_b ), @158
//          .WEN    (jtlb_data_bwen1_b ), @159
//          .A      (jtlb_data_idx[8:0]), @160
//          .D      (jtlb_data_din     ), @161
//          .Q      (jtlb_data_dout1   ) @162
//        ); @163
// &Instance("wk_spsram_512x84","x_wk_spsram_512x84_bank0"); @165
// &Connect( @166
//          .CLK    (jtlb_data_clk     ), @167
//          .CEN    (jtlb_data_cen0_b  ), @168
//          .GWEN   (jtlb_data_gwen0_b ), @169
//          .WEN    (jtlb_data_bwen0_b ), @170
//          .A      (jtlb_data_idx[8:0]), @171
//          .D      (jtlb_data_din     ), @172
//          .Q      (jtlb_data_dout0   ) @173
//        ); @174

// &ModuleEnd; @179
endmodule


