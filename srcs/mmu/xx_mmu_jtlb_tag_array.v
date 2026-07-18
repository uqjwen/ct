//-----------------------------------------------------------------------------
// File          : xx_mmu_jtlb_tag_array.v
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


// $Id: xx_mmu_jtlb_tag_array.vp,v 1.7 2022/01/06 08:14:36 jizk Exp $
// *****************************************************************************

// &ModuleBeg; @23
module xx_mmu_jtlb_tag_array(
  cp0_mmu_icg_en,
  forever_cpuclk,
  jtlb_tag_cen,
  jtlb_tag_din,
  jtlb_tag_dout,
  jtlb_tag_idx,
  jtlb_tag_wen,
  pad_yy_icg_scan_en,
  pad_sram_RME,
  pad_sram_RM
);
input                     pad_sram_RME;
input   [3   :0]          pad_sram_RM;

// &Ports; @24
input            cp0_mmu_icg_en;    
input            forever_cpuclk;    
input            jtlb_tag_cen;      
input   [4*`MMU_TAG_WIDTH+11:0]  jtlb_tag_din;      
input   [7  :0]  jtlb_tag_idx;      
input   [4  :0]  jtlb_tag_wen;      
input            pad_yy_icg_scan_en; 
output  [4*`MMU_TAG_WIDTH+11:0]  jtlb_tag_dout;     

// &Regs; @25
wire             pad_sram_RME;
wire    [3   :0] pad_sram_RM;
 
// &Wires; @26
wire             cp0_mmu_icg_en;    
wire             forever_cpuclk;    
wire    [4*`MMU_TAG_WIDTH+11:0]  jtlb_tag_bwen;     
wire    [4*`MMU_TAG_WIDTH+11:0]  jtlb_tag_bwen_b;   
wire             jtlb_tag_cen;      
wire             jtlb_tag_cen_b;    
wire             jtlb_tag_clk;      
wire             jtlb_tag_clk_en;   
wire    [4*`MMU_TAG_WIDTH+11:0]  jtlb_tag_din;      
wire    [4*`MMU_TAG_WIDTH+11:0]  jtlb_tag_dout;     
wire             jtlb_tag_gwen;     
wire             jtlb_tag_gwen_b;   
wire    [7  :0]  jtlb_tag_idx;      
wire    [4  :0]  jtlb_tag_wen;      
wire             pad_yy_icg_scan_en; 



//==========================================================
//                  Gate Cell
//==========================================================
assign jtlb_tag_clk_en = jtlb_tag_cen;
// &Instance("gated_clk_cell", "x_jtlb_tag_gateclk"); @33
gated_clk_cell  x_jtlb_tag_gateclk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (jtlb_tag_clk      ),
  .external_en        (1'b0              ),
  .local_en           (jtlb_tag_clk_en   ),
  .module_en          (cp0_mmu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect( .clk_in     (forever_cpuclk  ), @34
//           .external_en(1'b0            ), @35
//           .module_en  (cp0_mmu_icg_en  ), @36
//           .local_en   (jtlb_tag_clk_en ), @37
//           .clk_out    (jtlb_tag_clk    ) @38
//          ); @39


assign jtlb_tag_gwen = |jtlb_tag_wen[4:0];
assign jtlb_tag_bwen[4*`MMU_TAG_WIDTH+3:0] = {
                               {4 {jtlb_tag_wen[4]}},  //fifo
                               {`MMU_TAG_WIDTH{jtlb_tag_wen[3]}},  //way3
                               {`MMU_TAG_WIDTH{jtlb_tag_wen[2]}},  //way2
                               {`MMU_TAG_WIDTH{jtlb_tag_wen[1]}},  //way1
                               {`MMU_TAG_WIDTH{jtlb_tag_wen[0]}}   //way0
                              };
assign jtlb_tag_cen_b  = !jtlb_tag_cen;
assign jtlb_tag_gwen_b = !jtlb_tag_gwen;
assign jtlb_tag_bwen_b[4*`MMU_TAG_WIDTH+3:0] = ~jtlb_tag_bwen[4*`MMU_TAG_WIDTH+3:0];


assign jtlb_tag_bwen[4*`MMU_TAG_WIDTH+11:4*`MMU_TAG_WIDTH+4] = {
                                 {2{jtlb_tag_wen[3]}},  //way3
                                 {2{jtlb_tag_wen[2]}},  //way2
                                 {2{jtlb_tag_wen[1]}},  //way1
                                 {2{jtlb_tag_wen[0]}}   //way0
                                };
assign jtlb_tag_bwen_b[4*`MMU_TAG_WIDTH+11:4*`MMU_TAG_WIDTH+4] = ~jtlb_tag_bwen[4*`MMU_TAG_WIDTH+11:4*`MMU_TAG_WIDTH+4];

// &Instance("wk_spsram_256x204","x_wk_spsram_256x204"); @65
wk_spsram_256x240  x_wk_spsram_256x240 (
  .A                 (jtlb_tag_idx[7:0]),
  .CEN               (jtlb_tag_cen_b   ),
  .CLK               (jtlb_tag_clk     ),
  .D                 (jtlb_tag_din     ),
  .GWEN              (jtlb_tag_gwen_b  ),
  .Q                 (jtlb_tag_dout    ),
  .WEN               (jtlb_tag_bwen_b  ),
  .RME               (pad_sram_RME     ),
  .RM                (pad_sram_RM      )
);

// &Connect( @66
//          .CLK    (jtlb_tag_clk     ), @67
//          .CEN    (jtlb_tag_cen_b   ), @68
//          .GWEN   (jtlb_tag_gwen_b  ), @69
//          .WEN    (jtlb_tag_bwen_b  ), @70
//          .A      (jtlb_tag_idx[7:0]), @71
//          .D      (jtlb_tag_din     ), @72
//          .Q      (jtlb_tag_dout    ) @73
//        ); @74

// &Instance("wk_spsram_512x204","x_wk_spsram_512x204"); @78
// &Connect( @79
//          .CLK    (jtlb_tag_clk     ), @80
//          .CEN    (jtlb_tag_cen_b   ), @81
//          .GWEN   (jtlb_tag_gwen_b  ), @82
//          .WEN    (jtlb_tag_bwen_b  ), @83
//          .A      (jtlb_tag_idx[8:0]), @84
//          .D      (jtlb_tag_din     ), @85
//          .Q      (jtlb_tag_dout    ) @86
//        ); @87

// &Instance("wk_spsram_256x196","x_wk_spsram_256x196"); @93
// &Connect( @94
//          .CLK    (jtlb_tag_clk     ), @95
//          .CEN    (jtlb_tag_cen_b   ), @96
//          .GWEN   (jtlb_tag_gwen_b  ), @97
//          .WEN    (jtlb_tag_bwen_b  ), @98
//          .A      (jtlb_tag_idx[7:0]), @99
//          .D      (jtlb_tag_din     ), @100
//          .Q      (jtlb_tag_dout    ) @101
//        ); @102
// &Instance("wk_spsram_512x196","x_wk_spsram_512x196"); @106
// &Connect( @107
//          .CLK    (jtlb_tag_clk     ), @108
//          .CEN    (jtlb_tag_cen_b   ), @109
//          .GWEN   (jtlb_tag_gwen_b  ), @110
//          .WEN    (jtlb_tag_bwen_b  ), @111
//          .A      (jtlb_tag_idx[8:0]), @112
//          .D      (jtlb_tag_din     ), @113
//          .Q      (jtlb_tag_dout    ) @114
//        ); @115

// &ModuleEnd; @120
endmodule



