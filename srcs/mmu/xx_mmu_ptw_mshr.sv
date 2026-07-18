//-----------------------------------------------------------------------------
// File          : xx_mmu_ptw_mshr.sv
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
module xx_mmu_ptw_mshr#(
    parameter MSHR_NUM = 4,
    parameter VPN_WIDTH = `WK_VPN_WIDTH,
    parameter ASID_WIDTH = 16
)(
    input logic                  cpurst_b,
    input logic                  forever_cpuclk,

    input logic                  jtlb_ptw_req,
    input logic [VPN_WIDTH-1:0]  jtlb_ptw_vpn,
    input logic [ASID_WIDTH-1:0] jtlb_ptw_asid,
    input logic [11:0]           jtlb_ptw_fifo,
    input logic [2:0]            jtlb_ptw_type,
    input logic [2:0]            jtlb_ptw_ptr,
    input logic [`WK_VPN_WIDTH-1:0]           pfu_ptw_va,
    input logic [`WK_VPN_WIDTH-1:0]           tmq_ptw_va,
    input logic                  ptw_refill_on,
    output logic                  ptw_mshr_pfu_va_hit,
    output logic                  ptw_mshr_tmq_va_hit,
    output logic                  ptw_mshr_req,
    output logic [VPN_WIDTH-1:0]  ptw_mshr_vpn,
    output logic [ASID_WIDTH-1:0] ptw_mshr_asid,
    output logic [11:0]           ptw_mshr_fifo,
    output logic [2:0]            ptw_mshr_type,
    output logic [2:0]            ptw_mshr_ptr,
    output logic                  ptw_mshr_full
);
    logic [MSHR_NUM-1:0] mshr_entry_vld;
    logic                mshr_has_req;
    logic [MSHR_NUM-1:0] mshr_req_ptr;
    logic [MSHR_NUM-1:0] mshr_req_ptr_1st;
    logic [MSHR_NUM-1:0] mshr_req_ptr_nxt;
    logic [MSHR_NUM-1:0] mshr_req_ptr_msk;
    logic [MSHR_NUM-1:0] mshr_req_ptr_msk_1st;
    logic                mshr_no_req_point2create;
    logic                mshr_req_ptr_updt_val;
    logic [MSHR_NUM-1:0] mshr_create_vld;
    logic [MSHR_NUM-1:0] mshr_pop_vld;
    logic [MSHR_NUM-1:0] mshr_create_ptr;
    logic                ptw_mshr_emtpy;
    logic                mshr_create_success;
    logic                ptw_req_byp_pmit;
    logic                mshr_req_grnt;
    logic                mshr_has_pre_req;

    logic [MSHR_NUM-1:0][VPN_WIDTH-1:0]  mshr_read_vpn;
    logic [MSHR_NUM-1:0][ASID_WIDTH-1:0] mshr_read_asid;
    logic [MSHR_NUM-1:0][11:0]           mshr_read_fifo;
    logic [MSHR_NUM-1:0][2:0]            mshr_read_type;
    logic [MSHR_NUM-1:0][2:0]            mshr_read_ptr;

    logic [VPN_WIDTH-1:0]  mshr_entry_vpn;
    logic [ASID_WIDTH-1:0] mshr_entry_asid;
    logic [11:0]           mshr_entry_fifo;
    logic [2:0]            mshr_entry_type;
    logic [2:0]            mshr_entry_ptr;
    logic [MSHR_NUM-1:0]   pfu_va_hit;
    logic [MSHR_NUM-1:0]   tmq_va_hit;

    assign ptw_mshr_pfu_va_hit = |pfu_va_hit[MSHR_NUM-1:0];
    assign ptw_mshr_tmq_va_hit = |tmq_va_hit[MSHR_NUM-1:0];
    generate 
        for(genvar i=0; i<MSHR_NUM; i++) begin 
            xx_mmu_ptw_mshr_entry #(
                .VPN_WIDTH(VPN_WIDTH),
                .ASID_WIDTH(ASID_WIDTH)
            )i_xx_mmu_ptw_mshr_entry(
                .forever_cpuclk         (forever_cpuclk),
                .cpurst_b               (cpurst_b),
                .mshr_entry_create_vld  (mshr_create_vld[i]),
                .mshr_entry_pop_vld     (mshr_pop_vld[i]),
                .mshr_entry_create_vpn  (jtlb_ptw_vpn),
                .mshr_entry_create_asid (jtlb_ptw_asid),
                .mshr_entry_create_fifo (jtlb_ptw_fifo),
                .mshr_entry_create_type (jtlb_ptw_type),
                .mshr_entry_create_ptr  (jtlb_ptw_ptr),
                .pfu_ptw_va             (pfu_ptw_va),
                .tmq_ptw_va             (tmq_ptw_va),
                .pfu_va_hit_x           (pfu_va_hit[i]),
                .tmq_va_hit_x           (tmq_va_hit[i]),
                .mshr_entry_vpn_v       (mshr_read_vpn[i]),
                .mshr_entry_asid_v      (mshr_read_asid[i]),
                .mshr_entry_fifo_v      (mshr_read_fifo[i]),
                .mshr_entry_type_v      (mshr_read_type[i]),
                .mshr_entry_ptr_v       (mshr_read_ptr[i]),
                .mshr_entry_vld_x       (mshr_entry_vld[i])
            );
        end
    endgenerate
    
    assign mshr_create_ptr[0] = ~mshr_entry_vld[0];
    generate 
        for(genvar i=1; i<MSHR_NUM; i++)
            assign mshr_create_ptr[i] = ~mshr_entry_vld[i] & (&(mshr_entry_vld[i-1:0]));
    endgenerate
    
    assign mshr_req_ptr_1st[0] = mshr_entry_vld[0];
    generate
        for(genvar i=1; i<MSHR_NUM; i++)
            assign mshr_req_ptr_1st[i] = mshr_entry_vld[i] & ~(|mshr_entry_vld[i-1:0]);
    endgenerate
    
    always@(posedge forever_cpuclk, negedge cpurst_b)begin 
        if(!cpurst_b)
            mshr_req_ptr <= {MSHR_NUM{1'b0}};
        else if(mshr_no_req_point2create)
            mshr_req_ptr <= mshr_create_ptr;
        else if(mshr_req_ptr_updt_val)
            mshr_req_ptr <= mshr_req_ptr_nxt;
    end
    // assign mshr_has_pre_req = |(~mshr_req_ptr & mshr_entry_vld);
    
    assign mshr_no_req_point2create = mshr_create_success
                                      && (ptw_mshr_emtpy // empty and create_success 's hidden condition is refill_on=1
                                          || mshr_req_ptr == mshr_entry_vld // only one req and it's not going to be grnted
                                             && !ptw_refill_on);

    assign mshr_req_ptr_updt_val = mshr_req_grnt; // now swit to next valid rea
    assign mshr_req_ptr_msk = ~((mshr_req_ptr-1'b1) | mshr_req_ptr) & mshr_entry_vld;
    assign mshr_req_ptr_msk_1st[0] = mshr_req_ptr_msk[0];
    generate
        for(genvar i=1; i<MSHR_NUM; i++)
            assign mshr_req_ptr_msk_1st[i] = mshr_req_ptr_msk[i] & ~(|mshr_req_ptr_msk[i-1:0]);
    endgenerate

    assign mshr_req_ptr_nxt = |mshr_req_ptr_msk
                              ? mshr_req_ptr_msk_1st
                              : mshr_req_ptr_1st;

    always_comb begin 
        mshr_entry_vpn  = {VPN_WIDTH{1'b0}};
        mshr_entry_asid = {ASID_WIDTH{1'b0}};
        mshr_entry_fifo = {12{1'b0}};
        mshr_entry_type = 3'b000;
        mshr_entry_ptr = 3'b000;
        for(int i=0; i<MSHR_NUM; i++)
            if(mshr_req_ptr[i] == 1'b1) begin 
                mshr_entry_vpn  = mshr_read_vpn[i]; 
                mshr_entry_asid = mshr_read_asid[i]; 
                mshr_entry_fifo = mshr_read_fifo[i]; 
                mshr_entry_type = mshr_read_type[i]; 
                mshr_entry_ptr  = mshr_read_ptr[i];
            end
    end
    assign ptw_mshr_vpn  = ptw_req_byp_pmit? jtlb_ptw_vpn:  mshr_entry_vpn;
    assign ptw_mshr_asid = ptw_req_byp_pmit? jtlb_ptw_asid: mshr_entry_asid;
    assign ptw_mshr_fifo = ptw_req_byp_pmit? jtlb_ptw_fifo: mshr_entry_fifo;
    assign ptw_mshr_type = ptw_req_byp_pmit? jtlb_ptw_type: mshr_entry_type;
    assign ptw_mshr_ptr  = ptw_req_byp_pmit? jtlb_ptw_ptr : mshr_entry_ptr;
    assign ptw_mshr_req  = ptw_req_byp_pmit? jtlb_ptw_req : mshr_has_req;

    assign ptw_mshr_full = &(mshr_entry_vld[MSHR_NUM-1:0]);
    assign ptw_mshr_emtpy = ~(|mshr_entry_vld[MSHR_NUM-1:0]);
    assign mshr_has_req   = |mshr_entry_vld[MSHR_NUM-1:0];

    assign ptw_req_byp_pmit = ptw_mshr_emtpy
                              && !ptw_refill_on;

    assign mshr_create_success = jtlb_ptw_req
                                 && !ptw_mshr_full // make sure would not happen
                                 && !ptw_req_byp_pmit;
    assign mshr_create_vld = {MSHR_NUM{mshr_create_success}} & mshr_create_ptr[MSHR_NUM-1:0];
    assign mshr_req_grnt   = mshr_has_req
                             && !ptw_refill_on;
                            //  && !ptw_req_byp_pmit;
    assign mshr_pop_vld    = {MSHR_NUM{mshr_req_grnt}} & mshr_req_ptr;

endmodule
