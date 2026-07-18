//-----------------------------------------------------------------------------
// File          : xx_mmu_sysmap.v
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


// $Id: xx_mmu_sysmap.vp,v 1.5 2021/12/10 08:57:57 chenyc Exp $
// *****************************************************************************
// &Depend("sysmap.h"); @26

// &ModuleBeg; @28
module xx_mmu_sysmap(
  mmu_sysmap_pa_y,
  sys_regs_value,
  sysmap_mmu_flg_y,
  sysmap_mmu_hit_y
);

// &Ports; @29
input   [`WK_PPN_WIDTH-1:0]  mmu_sysmap_pa_y; 
input   [`WK_SYSMAP_NUM*`WK_SYSREG_WIDTH-1:0]              sys_regs_value;
output  [4 :0]               sysmap_mmu_flg_y; 
output  [`WK_SYSMAP_NUM-1 :0]              sysmap_mmu_hit_y; 

// &Regs; @30
reg     [4 :0]  sysmap_mmu_flg_y; 

// &Wires; @31
wire    [`WK_PPN_WIDTH-1:0]  mmu_sysmap_pa_y; 
wire   [`WK_SYSMAP_NUM*`WK_SYSREG_WIDTH-1:0]              sys_regs_value;
wire   [`WK_SYSMAP_NUM-1:0]               sys_pa_le;
wire   [`WK_SYSMAP_NUM-1:0]               sys_pa_fst_ptr;
wire   [4:0]                sys_pa_flg;
wire   [`WK_SYSREG_WIDTH-1:0]               sys_regs[`WK_SYSMAP_NUM-1:0];
parameter ADDR_WIDTH = `WK_PA_WIDTH-12;
parameter FLG_WIDTH  = 5;

generate
  for(genvar i=0; i<`WK_SYSMAP_NUM; i++)
    assign sys_regs[i] = sys_regs_value[i*`WK_SYSREG_WIDTH +:`WK_SYSREG_WIDTH];
endgenerate

generate
  for(genvar i=0; i<`WK_SYSMAP_NUM; i++)
    assign sys_pa_le[i] = mmu_sysmap_pa_y < sys_regs[i][`WK_SYSREG_WIDTH-1:5];
endgenerate
assign sys_pa_fst_ptr[0] = sys_pa_le[0];
generate 
  for(genvar i=1; i<`WK_SYSMAP_NUM; i++)
    assign sys_pa_fst_ptr[i] = sys_pa_le[i] & ~(|sys_pa_le[i-1:0]);
endgenerate

assign sysmap_mmu_hit_y = sys_pa_fst_ptr;

generate
  for(genvar i=0; i<FLG_WIDTH; i++)begin 
    wire [`WK_SYSMAP_NUM-1:0] sys_flg_tmp;
    for(genvar j=0; j<`WK_SYSMAP_NUM; j++)begin 
      assign sys_flg_tmp[j] = sys_pa_fst_ptr[j] & sys_regs[j][i];
    end
    assign sys_pa_flg[i] = |sys_flg_tmp[`WK_SYSMAP_NUM-1:0];
  end
endgenerate

assign sysmap_mmu_flg_y = (|sys_pa_fst_ptr)? sys_pa_flg: 5'b10011;

// &ModuleEnd; @112
endmodule


