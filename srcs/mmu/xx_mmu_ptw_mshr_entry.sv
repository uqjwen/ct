//-----------------------------------------------------------------------------
// File          : xx_mmu_ptw_mshr_entry.sv
// Created       : 2024/10/01 (by wenck)
// Last modified : 2024/10/01 (by wenck)
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


// $Id: xx_mmu_ptw.vp,v 1.50.12.1 2023/07/07 09:22:52 sitong.zhu Exp $
// *****************************************************************************
module xx_mmu_ptw_mshr_entry#(
    parameter VPN_WIDTH = `WK_VPN_WIDTH,
    parameter ASID_WIDTH = 16
)(
    input logic                   forever_cpuclk,
    input logic                   cpurst_b,
    input logic                   mshr_entry_create_vld,
    input logic                   mshr_entry_pop_vld,
    input logic [VPN_WIDTH-1:0]   mshr_entry_create_vpn,
    input logic [ASID_WIDTH-1:0]  mshr_entry_create_asid,
    input logic [11:0]            mshr_entry_create_fifo,
    input logic [2:0]             mshr_entry_create_type,
    input logic [2:0]             mshr_entry_create_ptr,
    input logic [`WK_VPN_WIDTH-1:0]            pfu_ptw_va,
    input logic [`WK_VPN_WIDTH-1:0]            tmq_ptw_va,
    output logic                  pfu_va_hit_x,
    output logic                  tmq_va_hit_x,
    output logic [VPN_WIDTH-1:0]  mshr_entry_vpn_v,
    output logic [ASID_WIDTH-1:0] mshr_entry_asid_v,
    output logic [11:0]           mshr_entry_fifo_v,
    output logic [2:0]            mshr_entry_type_v,
    output logic [2:0]            mshr_entry_ptr_v,
    output logic                  mshr_entry_vld_x
);
    parameter LVL_WIDTH = 9;
    logic [VPN_WIDTH-1:0]  mshr_entry_vpn;
    logic [ASID_WIDTH-1:0] mshr_entry_asid;
    logic [11:0]           mshr_entry_fifo;
    logic [2:0]            mshr_entry_type;
    logic [2:0]            mshr_entry_ptr;
    logic                  mshr_entry_vld;

    always@(posedge forever_cpuclk, negedge cpurst_b)begin 
        if(!cpurst_b)
            mshr_entry_vld <= 1'b0;
        else if(mshr_entry_create_vld)
            mshr_entry_vld <= 1'b1;
        else if(mshr_entry_pop_vld)
            mshr_entry_vld <= 1'b0;
    end

    always@(posedge forever_cpuclk, negedge cpurst_b)begin 
        if(!cpurst_b) begin 
            mshr_entry_vpn  <= {VPN_WIDTH{1'b0}};
            mshr_entry_asid <= {ASID_WIDTH{1'b0}};
            mshr_entry_fifo <= {12{1'b0}};
            mshr_entry_type <= 3'b000;
            mshr_entry_ptr  <= 3'b000;
        end
        else if(mshr_entry_create_vld) begin 
            mshr_entry_vpn  <= mshr_entry_create_vpn;
            mshr_entry_asid <= mshr_entry_create_asid;
            mshr_entry_fifo <= mshr_entry_create_fifo;
            mshr_entry_type <= mshr_entry_create_type;
            mshr_entry_ptr  <= mshr_entry_create_ptr;
        end
    end
    assign pfu_va_hit_x      = mshr_entry_vld && (mshr_entry_vpn[VPN_WIDTH-1:VPN_WIDTH-LVL_WIDTH] == pfu_ptw_va[VPN_WIDTH-1:VPN_WIDTH-LVL_WIDTH]);
    assign tmq_va_hit_x      = mshr_entry_vld && (mshr_entry_vpn[VPN_WIDTH-1:VPN_WIDTH-LVL_WIDTH] == tmq_ptw_va[VPN_WIDTH-1:VPN_WIDTH-LVL_WIDTH]);
    assign mshr_entry_vld_x  = mshr_entry_vld;
    assign mshr_entry_vpn_v  = mshr_entry_vpn;
    assign mshr_entry_asid_v = mshr_entry_asid;
    assign mshr_entry_fifo_v = mshr_entry_fifo;
    assign mshr_entry_type_v = mshr_entry_type;
    assign mshr_entry_ptr_v  = mshr_entry_ptr;
endmodule
