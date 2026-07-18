//-----------------------------------------------------------------------------
// File          : xx_mmu_sysmap_hit.v
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


// $Id: xx_mmu_sysmap_hit.vp,v 1.1 2019/01/02 12:39:52 haozy Exp $
// *****************************************************************************
// &ModuleBeg; @26
module xx_mmu_sysmap_hit(
  addr_ge_bottom_x,
  addr_ge_upaddr_x,
  sysmap_comp_hit_x,
  sysmap_mmu_hit_x
);

// &Ports; @27
input        addr_ge_bottom_x; 
input        sysmap_comp_hit_x; 
output       addr_ge_upaddr_x; 
output       sysmap_mmu_hit_x; 

// &Regs; @28

// &Wires; @29
wire         addr_ge_bottom_x; 
wire         addr_ge_upaddr_x; 
wire         addr_ls_top;      
wire         sysmap_comp_hit_x; 
wire         sysmap_mmu_hit_x; 



assign addr_ls_top      = sysmap_comp_hit_x;

assign addr_ge_upaddr_x = !addr_ls_top;
assign sysmap_mmu_hit_x = addr_ge_bottom_x && addr_ls_top;

// &ModuleEnd; @37
endmodule


