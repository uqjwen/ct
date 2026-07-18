//-----------------------------------------------------------------------------
// File          : xx_mmu_pfu_entry.sv
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
module xx_mmu_pfu_entry
(
    input logic          cpurst_b,
    input logic          forever_cpuclk,
    input logic          pfu_entry_create_vld,
    // input logic          pfu_entry_pop_vld,
    input logic [`WK_PPN_WIDTH-1:0]   pfu_entry_create_va,
    input logic [1:0]    pfu_entry_create_priv_mode,
    input logic [3:0]    pfu_entry_create_resp_id,
    input logic          pfu_entry_create_req,

    input logic          pfu_entry_req_grnt,
    input logic          jtlb_pfu_cmplt,
    input logic          jtlb_pfu_acc_fault,
    // input logic          jtlb_pfu_deny,
    input logic [`WK_PPN_WIDTH-1:0]   jtlb_pfu_pa,
    input logic          jtlb_pfu_sec,
    input logic          jtlb_pfu_share,
    input logic [3:0]    pmp_mmu_flg4,

    input logic          pfu_entry_ack_grnt,
 
    output logic         pfu_entry_vld_x,
    output logic [`WK_PPN_WIDTH-1:0]  pfu_entry_va_v,
    output logic [`WK_PPN_WIDTH-1:0]  pfu_entry_pa_v,
    output logic         pfu_entry_sec_x,
    output logic         pfu_entry_share_x,
    output logic [3:0]   pfu_entry_resp_id_v,
    output logic         pfu_entry_req_x,
    output logic         pfu_entry_ack_vld_x,
    output logic         pfu_entry_err_x,
    output logic [1:0]   pfu_entry_priv_mode_v,
    output logic         pfu_entry_cmplt_ff1_x

);
parameter PFU_IDLE = 2'b00,
          PFU_CHK  = 2'b01,
          PFU_DENY = 2'b10,
          PFU_OK   = 2'b11;
logic [1:0]  pfu_cur_st;
logic [1:0]  pfu_nxt_st;
logic [`WK_PPN_WIDTH-1:0] pfu_entry_va;
logic [`WK_PPN_WIDTH-1:0] pfu_entry_pa;
logic        pfu_entry_vld;
logic [1:0]  pfu_entry_priv_mode;
logic [3:0]  pfu_entry_resp_id;
logic        pfu_entry_sec;
logic        pfu_entry_share;
logic        pfu_entry_deny;
logic        pfu_cmplt_ff1;
logic        pfu_entry_pop_vld;
logic        pfu_entry_req;
logic        pfu_ok_st;
logic        pfu_deny_st;

logic        pfu_entry_ack_vld;
logic        pfu_entry_ack_set1_vld;
logic        pfu_entry_ack_set0_vld;



always@(posedge forever_cpuclk, negedge cpurst_b)begin 
    if(!cpurst_b)
        pfu_entry_vld <= 1'b0;
    else if(pfu_entry_create_vld)
        pfu_entry_vld <= 1'b1;
    else if(pfu_entry_pop_vld)
        pfu_entry_vld <= 1'b0;
end

always@(posedge forever_cpuclk, negedge cpurst_b)begin 
    if(!cpurst_b)
        pfu_entry_req <= 1'b0;
    else if(pfu_entry_create_vld)
        pfu_entry_req <= pfu_entry_create_req;
    else if(pfu_entry_req_grnt && pfu_entry_req)
        pfu_entry_req <= 1'b0;
end

always@(posedge forever_cpuclk, negedge cpurst_b)begin 
    if(!cpurst_b) begin
        pfu_entry_va        <= {`WK_PPN_WIDTH{1'b0}};
        pfu_entry_priv_mode <= 2'b0;
        pfu_entry_resp_id   <= 4'b0;
    end
    else if(pfu_entry_create_vld)begin 
        pfu_entry_va        <= pfu_entry_create_va;
        pfu_entry_priv_mode <= pfu_entry_create_priv_mode;
        pfu_entry_resp_id   <= pfu_entry_create_resp_id;
    end 
end

always@(posedge forever_cpuclk, negedge cpurst_b)begin 
    if(!cpurst_b) begin 
        pfu_entry_pa    <= {`WK_PPN_WIDTH{1'b0}};
        pfu_entry_sec   <= 1'b0;
        pfu_entry_share <= 1'b0;
    end
    else if(jtlb_pfu_cmplt)begin 
        pfu_entry_pa    <= jtlb_pfu_pa;
        pfu_entry_sec   <= jtlb_pfu_sec;
        pfu_entry_share <= jtlb_pfu_share;
    end
end

always@(posedge forever_cpuclk, negedge cpurst_b)begin 
    if(!cpurst_b)
        pfu_cmplt_ff1 <= 1'b0;
    else
        pfu_cmplt_ff1 <= jtlb_pfu_cmplt;
end
assign pfu_entry_cmplt_ff1_x = pfu_cmplt_ff1;

assign pfu_entry_deny = !pmp_mmu_flg4[0]
                         && !((pfu_entry_priv_mode == 2'b11) 
                               && !pmp_mmu_flg4[3]);  // L-bit for M-Mode

always@(posedge forever_cpuclk, negedge cpurst_b)begin 
    if(!cpurst_b)
        pfu_cur_st <= PFU_IDLE;
    else
        pfu_cur_st <= pfu_nxt_st;
end

always_comb begin 
    pfu_nxt_st = pfu_cur_st;
    case(pfu_cur_st[1:0])
        PFU_IDLE: begin 
            if(jtlb_pfu_cmplt)
                if(jtlb_pfu_acc_fault)
                    pfu_nxt_st[1:0] = PFU_DENY;
                else
                    pfu_nxt_st[1:0] = PFU_CHK;
            else
                pfu_nxt_st[1:0] = PFU_IDLE;
        end
        PFU_CHK: begin 
            if(pfu_entry_deny)
                pfu_nxt_st[1:0] = PFU_DENY;
            else
                pfu_nxt_st[1:0] = PFU_OK;
        end
        PFU_DENY: begin
            if(pfu_entry_ack_grnt)
                pfu_nxt_st[1:0] = PFU_IDLE;
            else
                pfu_nxt_st[1:0] = PFU_DENY;
        end 

        PFU_OK:   pfu_nxt_st[1:0] = PFU_IDLE;
        default:  pfu_nxt_st[1:0] = PFU_IDLE;
    endcase
end

always@(posedge forever_cpuclk, negedge cpurst_b)begin 
    if(!cpurst_b)
        pfu_entry_ack_vld <= 1'b0;
    else if(pfu_entry_create_vld)
        pfu_entry_ack_vld <= 1'b0;
    else if(pfu_entry_ack_set1_vld)
        pfu_entry_ack_vld <= 1'b1;
    else if(pfu_entry_ack_set0_vld)
        pfu_entry_ack_vld <= 1'b0;
end
assign pfu_entry_ack_set1_vld = pfu_deny_st || pfu_ok_st;
assign pfu_entry_ack_set0_vld = pfu_entry_ack_grnt;

assign pfu_deny_st = (pfu_cur_st == PFU_DENY);
assign pfu_ok_st   = (pfu_cur_st == PFU_OK);
// assign pfu_entry_pop_vld     = pfu_deny_st || pfu_ok_st;
assign pfu_entry_ack_vld_x   = pfu_entry_ack_vld;
assign pfu_entry_pop_vld     = pfu_entry_ack_vld && pfu_entry_ack_grnt;
assign pfu_entry_err_x       = pfu_deny_st;
assign pfu_entry_vld_x       = pfu_entry_vld;
assign pfu_entry_pa_v        = pfu_entry_pa;
assign pfu_entry_va_v        = pfu_entry_va;
assign pfu_entry_sec_x       = pfu_entry_sec;
assign pfu_entry_share_x     = pfu_entry_share;
assign pfu_entry_resp_id_v   = pfu_entry_resp_id;
assign pfu_entry_req_x       = pfu_entry_req;
assign pfu_entry_priv_mode_v = pfu_entry_priv_mode;
endmodule