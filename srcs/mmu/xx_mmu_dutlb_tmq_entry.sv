//-----------------------------------------------------------------------------
// File          : xx_mmu_dutlb_tmq_entry.sv
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


// $Id: xx_mmu_dutlb_mshr.vp,v 1.50.12.1 2023/07/07 09:22:52 sitong.zhu Exp $
// *****************************************************************************
module xx_mmu_dutlb_tmq_entry #(
    parameter LSIQENTRY = 12,
    parameter IID_WIDTH = 7,
    parameter TMQ_NUM = 8
)(
    input logic                 forever_cpuclk,
    input logic                 cpurst_b,
    input logic                 rtu_yy_xx_flush,
    input logic                 rtu_ck_flush,
    input logic [IID_WIDTH-1:0] rtu_ck_flush_iid,
    input logic                 tmq_create0_vld,
    input logic                 tmq_create0_set_lsid2,
    input logic                 tmq_create0_set_lsid3,
    input logic                 tmq_create0_with_req,
    // input logic [TMQ_NUM-1:0]   tmq_create0_agevec,
    input logic [LSIQENTRY-1:0] tmq_lsu0_lsid,
    input logic [IID_WIDTH-1:0] tmq_lsu0_iid,
    input logic                 tmq_lsu0_st,
    input logic [`WK_VPN_WIDTH-1:0]          tmq_lsu0_vpn,

    input logic                 tmq_create2_vld,
    input logic                 tmq_create2_set_lsid0,
    input logic                 tmq_create2_set_lsid3,
    input logic                 tmq_create2_with_req,
    // input logic [TMQ_NUM-1:0]   tmq_create2_agevec,
    input logic [LSIQENTRY-1:0] tmq_lsu2_lsid,
    input logic [IID_WIDTH-1:0] tmq_lsu2_iid,
    input logic                 tmq_lsu2_st,
    input logic [`WK_VPN_WIDTH-1:0]          tmq_lsu2_vpn,

    input logic                 tmq_create3_vld,
    input logic                 tmq_create3_set_lsid0,
    input logic                 tmq_create3_set_lsid2,
    input logic                 tmq_create3_with_req,
    // input logic [TMQ_NUM-1:0]   tmq_create3_agevec,
    input logic [LSIQENTRY-1:0] tmq_lsu3_lsid,
    input logic [IID_WIDTH-1:0] tmq_lsu3_iid,
    input logic                 tmq_lsu3_st,
    input logic [`WK_VPN_WIDTH-1:0]          tmq_lsu3_vpn,

    // input logic                 tmq_req_older20,
    // input logic                 tmq_req_older30,
    // input logic                 tmq_req_older32,

    input logic                 tmq_entry_pop_vld,

    input logic                 tmq_merge0_vld,
    input logic                 tmq_merge2_vld,
    input logic                 tmq_merge3_vld,

    // input logic [TMQ_NUM-1:0]   tmq_global_grnt, // for update agevec
    input logic                 tmq_pe_grnt,
    input logic                 tmq_arb_grnt, // used for early wakup update lsiq
    // input logic                 tmq_arb_grnt,
    // input logic                 tmq_udpt_agevec_vld,

    output logic                tmq_vpn_hit0_x,
    output logic                tmq_vpn_hit2_x,
    output logic                tmq_vpn_hit3_x,
    // output logic                tmp_updt0_succes_x,
    // output logic                tmp_updt2_succes_x,
    // output logic                tmp_updt3_succes_x,
    output logic                 tmq_entry_vld_x,
    output logic [LSIQENTRY-1:0] tmq_entry_lsid0_v,
    output logic [LSIQENTRY-1:0] tmq_entry_lsid2_v,
    output logic [LSIQENTRY-1:0] tmq_entry_lsid3_v,
    output logic [`WK_VPN_WIDTH-1:0]          tmq_entry_vpn_v,
    output logic [IID_WIDTH-1:0] tmq_entry_iid_v,
    output logic                 tmq_entry_st_x,
    output logic                 tmq_entry_req_x
    // output logic                 tmq_entry_olderthan_lsu0_x,
    // output logic                 tmq_entry_olderthan_lsu2_x,
    // output logic                 tmq_entry_olderthan_lsu3_x
    
);

logic                   tmq_entry_vld;
logic                   tmq_entry_lsid0_set;
logic                   tmq_entry_lsid2_set;
logic                   tmq_entry_lsid3_set;
logic [LSIQENTRY-1:0]   tmq_entry_lsid0;
logic [LSIQENTRY-1:0]   tmq_entry_lsid2;
logic [LSIQENTRY-1:0]   tmq_entry_lsid3;
logic [IID_WIDTH-1:0]   tmq_entry_iid; // if grnted, will not update iid
logic [TMQ_NUM-1:0]     tmq_entry_agevec;
logic [TMQ_NUM-1:0]     tmq_entry_agevec_nxt;
logic                   tmq_entry_req;
logic [2:0]             tmq_entry_type;
logic [`WK_VPN_WIDTH-1:0]            tmq_entry_vpn;
logic                   tmq_entry_st;

// logic                   tmq_entry_olderthan_lsu0;
// logic                   tmq_entry_olderthan_lsu2;
// logic                   tmq_entry_olderthan_lsu3;
// logic                   tmq_info_udpt_permit;
// logic                   tmq_info_merge0_udpt;
// logic                   tmq_info_merge2_udpt;
// logic                   tmq_info_merge3_udpt;
// for grnted or ready to grnt - entry, will not update its agevec, iid, st, 
logic                   tmq_entry_create;
logic                   rtu_ck_flush_iid_older_entry;
logic                   rtu_ck_flush_iid_older_eq_entry;

assign rtu_ck_flush_iid_older_eq_entry = rtu_ck_flush_iid_older_entry || (rtu_ck_flush_iid == tmq_entry_iid);

assign tmq_entry_create = tmq_create0_vld || tmq_create2_vld || tmq_create3_vld;

wk_rtu_compare_iid #(.IID_WIDTH(IID_WIDTH))  x_rtu_ck_flush_compare_tmq_entry (
  .x_iid0              (rtu_ck_flush_iid[IID_WIDTH-1:0]   ),
  .x_iid0_older        (rtu_ck_flush_iid_older_entry      ),
  .x_iid1              (tmq_entry_iid[IID_WIDTH-1:0]      )
);
always@(posedge forever_cpuclk, negedge cpurst_b)begin 
    if(!cpurst_b)
        tmq_entry_vld <= 1'b0;
    else if(tmq_entry_create)
        tmq_entry_vld <= 1'b1;
    else if(tmq_entry_pop_vld || rtu_yy_xx_flush)
        tmq_entry_vld <= 1'b0;
    else if(tmq_entry_vld && rtu_ck_flush && rtu_ck_flush_iid_older_eq_entry)  //flush younger vld entry, ck_flush@LTL
        tmq_entry_vld <= 1'b0;
end

always@(posedge forever_cpuclk, negedge cpurst_b)begin
    if(!cpurst_b)
        tmq_entry_req <= 1'b0;
    else if(tmq_create0_vld)
        tmq_entry_req <= tmq_create0_with_req;
    else if(tmq_create2_vld)
        tmq_entry_req <= tmq_create2_with_req;
    else if(tmq_create3_vld)
        tmq_entry_req <= tmq_create3_with_req;
    else if(tmq_pe_grnt && tmq_entry_req || rtu_yy_xx_flush)
        tmq_entry_req <= 1'b0;
    else if(rtu_ck_flush && rtu_ck_flush_iid_older_eq_entry)        //flush younger vld entry, ck_flush@LTL
        tmq_entry_req <= 1'b0;
end

assign tmq_entry_lsid0_set = tmq_create0_vld
                             || tmq_create2_vld
                                && tmq_create2_set_lsid0
                             || tmq_create3_vld
                                && tmq_create3_set_lsid0;
always@(posedge forever_cpuclk, negedge cpurst_b)begin
    if(!cpurst_b)
        tmq_entry_lsid0 <= {LSIQENTRY{1'b0}};
    else if(rtu_ck_flush)       //send out all wakeup queue, ck_flush@LTL
        tmq_entry_lsid0 <= {LSIQENTRY{1'b0}};
    else if(tmq_entry_lsid0_set)
        tmq_entry_lsid0 <= tmq_lsu0_lsid;
    else if(tmq_entry_create)
        tmq_entry_lsid0 <= {LSIQENTRY{1'b0}};
    else if(tmq_arb_grnt && !tmq_merge0_vld)
        tmq_entry_lsid0 <= {LSIQENTRY{1'b0}};
    else if(tmq_arb_grnt && tmq_merge0_vld)
        tmq_entry_lsid0 <= tmq_lsu0_lsid;
    else if(tmq_merge0_vld)
        tmq_entry_lsid0 <= tmq_entry_lsid0 | tmq_lsu0_lsid;
end
assign tmq_entry_lsid2_set = tmq_create2_vld
                             || tmq_create0_vld
                                && tmq_create0_set_lsid2
                             || tmq_create3_vld
                                && tmq_create3_set_lsid2;
always@(posedge forever_cpuclk, negedge cpurst_b)begin 
    if(!cpurst_b)
        tmq_entry_lsid2 <= {LSIQENTRY{1'b0}};
    else if(rtu_ck_flush)            //send out all wakeup queue, ck_flush@LTL
        tmq_entry_lsid2 <= {LSIQENTRY{1'b0}};
    else if(tmq_entry_lsid2_set)
        tmq_entry_lsid2 <= tmq_lsu2_lsid;
    else if(tmq_entry_create)
        tmq_entry_lsid2 <= {LSIQENTRY{1'b0}};
    else if(tmq_arb_grnt && !tmq_merge2_vld)
        tmq_entry_lsid2 <= {LSIQENTRY{1'b0}};
    else if(tmq_arb_grnt && tmq_merge2_vld)
        tmq_entry_lsid2 <= tmq_lsu2_lsid;
    else if(tmq_merge2_vld)
        tmq_entry_lsid2 <= tmq_entry_lsid2 | tmq_lsu2_lsid;
end
assign tmq_entry_lsid3_set = tmq_create3_vld
                             || tmq_create0_vld
                                && tmq_create0_set_lsid3
                             || tmq_create2_vld
                                && tmq_create2_set_lsid3;
always@(posedge forever_cpuclk, negedge cpurst_b)begin 
    if(!cpurst_b)
        tmq_entry_lsid3 <= {LSIQENTRY{1'b0}};
    else if(rtu_ck_flush)                //send out all wakeup queue, ck_flush@LTL
        tmq_entry_lsid3 <= {LSIQENTRY{1'b0}};
    else if(tmq_entry_lsid3_set)
        tmq_entry_lsid3 <= tmq_lsu3_lsid;
    else if(tmq_entry_create)
        tmq_entry_lsid3 <= {LSIQENTRY{1'b0}};
    else if(tmq_arb_grnt && !tmq_merge3_vld)
        tmq_entry_lsid3 <= {LSIQENTRY{1'b0}};
    else if(tmq_arb_grnt && tmq_merge3_vld)
        tmq_entry_lsid3 <= tmq_lsu3_lsid;
    else if(tmq_merge3_vld)
        tmq_entry_lsid3 <= tmq_entry_lsid3 | tmq_lsu3_lsid;
end

always@(posedge forever_cpuclk, negedge cpurst_b)begin 
    if(!cpurst_b)
        tmq_entry_vpn <= {`WK_VPN_WIDTH{1'b0}};
    else if(tmq_create0_vld)
        tmq_entry_vpn <= tmq_lsu0_vpn;
    else if(tmq_create2_vld)
        tmq_entry_vpn <= tmq_lsu2_vpn;
    else if(tmq_create3_vld)
        tmq_entry_vpn <= tmq_lsu3_vpn;
end

// merge update iid, st, agevec
// assign tmq_info_udpt_permit = tmq_entry_req
//                               && !tmq_local_grnt
//                               && !rtu_yy_xx_flush;

// assign tmq_info_merge0_udpt <= tmq_info_udpt_permit
//                                && tmq_merge0_vld
//                                && !tmq_entry_olderthan_lsu0
//                                && (!tmq_merge2_vld
//                                    || !tmq_req_older20)
//                                && (!tmq_merge3_vld
//                                    || !tmq_req_older30);
// assign tmq_info_merge2_udpt <= tmq_info_udpt_permit
//                                && tmq_merge2_vld
//                                && !tmq_entry_olderthan_lsu2
//                                && (!tmq_merge0_vld
//                                    || tmq_req_older20)
//                                && (!tmq_merge3_vld
//                                    || !tmq_req_older32);
// assign tmq_info_merge2_udpt <= tmq_info_udpt_permit
//                                && tmq_merge3_vld
//                                && !tmq_entry_olderthan_lsu3
//                                && (!tmq_merge0_vld
//                                    || tmq_req_older30)
//                                && (!tmq_merge2_vld
//                                    || tmq_req_older32);

always@(posedge forever_cpuclk, negedge cpurst_b)begin
    if(!cpurst_b)
        tmq_entry_iid <= {IID_WIDTH{1'b0}};
    else if(tmq_create0_vld )
        tmq_entry_iid <= tmq_lsu0_iid;
    else if(tmq_create2_vld )
        tmq_entry_iid <= tmq_lsu2_iid;
    else if(tmq_create3_vld )
        tmq_entry_iid <= tmq_lsu3_iid;
end

always@(posedge forever_cpuclk, negedge cpurst_b)begin 
    if(!cpurst_b)
        tmq_entry_st <= 1'b0;
    else if(tmq_create0_vld )
        tmq_entry_st <= tmq_lsu0_st;
    else if(tmq_create2_vld )
        tmq_entry_st <= tmq_lsu2_st;
    else if(tmq_create3_vld )
        tmq_entry_st <= tmq_lsu3_st;
end

// always@(posedge forever_cpuclk, negedge cpurst_b)begin 
//     if(!cpurst_b)
//         tmq_entry_agevec <= {TMQ_NUM{1'b0}};
//     else if(tmq_create0_vld )
//         tmq_entry_agevec <= tmq_lsu0_agevec;
//     else if(tmq_create2_vld )
//         tmq_entry_agevec <= tmq_lsu2_agevec;
//     else if(tmq_create3_vld )
//         tmq_entry_agevec <= tmq_lsu3_agevec;
//     else if(tmq_udpt_agevec_vld)
//         tmq_entry_agevec <= tmq_entry_agevec_nxt;
// end

// assign tmq_entry_agevec_nxt = tmq_entry_agevec
//                               & ~tmq_global_grnt // 
//                               | tmq_udpt0_vld // with if grnt happens with merge,
//                               | tmq_udpt2_vld
//                               | tmq_udpt3_vld;

// assign tmq_entry_olderthan_lsu0_x = tmq_entry_olderthan_lsu0
//                                     && tmq_entry_req
//                                     && !tmq_local_grnt
//                                     && !rtu_yy_xx_flush;
// assign tmq_entry_olderthan_lsu2_x = tmq_entry_olderthan_lsu2
//                                     && tmq_entry_req
//                                     && !tmq_local_grnt
//                                     && !rtu_yy_xx_flush;
// assign tmq_entry_olderthan_lsu3_x = tmq_entry_olderthan_lsu3;
//                                     && tmq_entry_req
//                                     && !tmq_local_grnt
//                                     && !rtu_yy_xx_flush;
assign tmq_entry_req_x = tmq_entry_req && !rtu_yy_xx_flush && !(rtu_ck_flush && rtu_ck_flush_iid_older_eq_entry);// && ~(|tmq_entry_agevec);  //flush younger tmq_entry_req, ck_flush@LTL
assign tmq_entry_st_x  = tmq_entry_st;
assign tmq_entry_vpn_v = tmq_entry_vpn;
assign tmq_vpn_hit0_x  = tmq_entry_vld && (tmq_lsu0_vpn == tmq_entry_vpn);
assign tmq_vpn_hit2_x  = tmq_entry_vld && (tmq_lsu2_vpn == tmq_entry_vpn);
assign tmq_vpn_hit3_x  = tmq_entry_vld && (tmq_lsu3_vpn == tmq_entry_vpn);
assign tmq_entry_vld_x = tmq_entry_vld;
assign tmq_entry_lsid0_v = tmq_entry_lsid0;
assign tmq_entry_lsid2_v = tmq_entry_lsid2;
assign tmq_entry_lsid3_v = tmq_entry_lsid3;
assign tmq_entry_iid_v   = tmq_entry_iid;
// assign tmq_agevec_udpt_permit_x = tmq_info_udpt_permit;
// assign tmp_updt0_succes_x = tmq_info_merge0_udpt;
// assign tmp_updt2_succes_x = tmqinfo
endmodule