//-----------------------------------------------------------------------------
// File          : xx_mmu_pfu.sv
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
module xx_mmu_pfu
(
    input logic          cpurst_b,
    input logic          forever_cpuclk,
    input logic          regs_mmu_en,
    input logic  [`WK_PPN_WIDTH-1:0]  lsu_mmu_va4,               // for pfu, origin: lsu_mmu_va2
    input logic  [1 :0]  lsu_mmu_va4_priv_mode,     // for pfu, origin: lsu_mmu_va2_priv_mode
    input logic          lsu_mmu_va4_vld,           // for pfu, origin: lsu_mmu_va2_vld
    input logic  [3:0]   lsu_mmu_pfu_req_id_q,

    input logic                       jtlb_pfu_cmplt,
    input logic [2:0]                 jtlb_pfu_ptr,
    input logic [`WK_PPN_WIDTH-1:0]   jtlb_pfu_pa,
    input logic                       jtlb_pfu_sec,
    input logic                       jtlb_pfu_share,
    input logic                       jtlb_pfu_acc_fault,

    input  logic          arb_pfu_grnt,
    output logic          pfu_arb_vld, // wire to lsu_mmu_va2_vld
    output logic [2:0]    pfu_arb_ptr,
    output logic [1:0]    pfu_xxx_priv_mode, // wire to arb's lsu_mmu_va2_priv_mode and jtlb's lsu_mmu_va2_priv_mode
    output logic [`WK_PPN_WIDTH-1:0]   pfu_jtlb_va, //wire to jtlb's lsu_mmu_va2
    input  logic          ptw_pfu_va_hit,

    input  logic [3:0]                 pmp_mmu_flg4, // from pmp
    output logic [`WK_PPN_WIDTH-1:0]   mmu_pmp_pa4, // to pmp
    
    output logic  [`WK_PPN_WIDTH-1:0]  mmu_lsu_pa4,                // for pfu, original: mmu_lsu_pa2
    output logic          mmu_lsu_pa4_err,            // for pfu, original: mmu_lsu_pa2_err
    output logic          mmu_lsu_pa4_vld,            // for pfu, original: mmu_lsu_pa2_vld
    output logic          mmu_lsu_sec4,               // for pfu, original mmu_lsu_sec2
    output logic          mmu_lsu_share4,             // for pfu, original: mmu_lsu_share2
    output logic          mmu_lsu_pfu_req_accepted,
    output logic [3:0]    mmu_lsu_pfu_req_accepted_id,
    output logic [3:0]    mmu_lsu_pfu_resp_id
);
    logic [7:0]       pfu_entry_vld;
    // logic [7:0]       pfu_read_ptr;
    // logic [7:0]       pfu_read_ptr_nxt;
    // logic [7:0]       pfu_read_ptr_msk;
    // logic [7:0]       pfu_read_ptr_msk_1st;
    logic [7:0]       pfu_read_ptr_1st;
    // logic             pfu_read_ptr_udpt_val;
    // logic             pfu_create_on_empty;
    logic [7:0]                    pfu_req_ptr;
    logic [7:0][`WK_PPN_WIDTH-1:0]              pfu_entry_va;
    logic [7:0][1:0]               pfu_entry_priv_mode;
    logic [7:0][`WK_PPN_WIDTH-1:0] pfu_entry_pa;
    logic [7:0]       pfu_entry_share;
    logic [7:0]       pfu_entry_sec;
    logic [7:0][3:0]  pfu_entry_resp_id;
    logic [7:0]       pfu_entry_cmplt_ff1;
    logic [7:0]       pfu_entry_req;
    logic [7:0]       pfu_entry_ack_vld;
    logic [7:0]       pfu_entry_err;
    logic             pfu_entry_full;
    logic             pfu_entry_empty;
    logic             pfu_create_success;
    logic [7:0]       pfu_create_vld;
    logic [7:0]       pfu_create_ptr;
    logic             pfu_create_with_req;
    // logic             pfu_req_byp_vld;
    // logic [27:0]      pfu_read_va;
    // logic [1:0]       pfu_read_priv_mode;
    logic [7:0]       pfu_entry_req_grnt;

    logic [7:0]       pfu_cmplt_ptr;
    logic [7:0]       pfu_entry_ack_grnt;
    logic [7:0]       pfu_entry_ack_ptr;
    logic             pfu_byp_grnt_mmu_off;

    logic             pfu_arb_req_unmask;
    logic             pfu_arb_req_udpt_permit;
    logic             pfu_arb_req_udpt_vld;
    // logic [7:0]       pfu_req_ptr;
    logic [1:0]       pfu_req_priv_mode;
    logic [`WK_PPN_WIDTH-1:0]      pfu_req_va;
    logic [7:0]       pfu_req_pre_ptr;
    logic [1:0]       pfu_req_pre_priv_mode;
    logic [`WK_PPN_WIDTH-1:0]      pfu_req_pre_va;    
    logic [7:0]       pfu_req_pre_ptr_msk;
    logic [7:0]       pfu_req_pre_ptr_msk_1st;
    logic             pfu_only_req_is_grnt;
    logic             pfu_has_pre_req;

    assign pfu_entry_full = &pfu_entry_vld[7:0];
    assign pfu_entry_empty = ~(|pfu_entry_vld[7:0]);

    assign mmu_lsu_pfu_req_accepted_id = lsu_mmu_pfu_req_id_q;
    assign mmu_lsu_pfu_req_accepted = lsu_mmu_va4_vld && !pfu_entry_full;
    // create logics
    // assign pfu_byp_grnt_mmu_off = pfu_req_byp_vld && (!regs_mmu_en || lsu_mmu_va4_priv_mode[1:0] == 'b11);
    assign pfu_create_success = lsu_mmu_va4_vld 
                                && !pfu_entry_full;

    assign pfu_create_ptr[0] = ~pfu_entry_vld[0];
    generate
        for(genvar i=1; i<8; i++)
            assign pfu_create_ptr[i] = ~pfu_entry_vld[i] & (&pfu_entry_vld[i-1:0]);
    endgenerate
    assign pfu_create_vld[7:0] = {8{pfu_create_success}} & pfu_create_ptr[7:0];

    // assign pfu_req_byp_vld = lsu_mmu_va4_vld 
    //                          && ~(|pfu_entry_req) 
    //                          && arb_pfu_grnt
    //                          && !pfu_entry_full;
    
    assign pfu_create_with_req   = !(pfu_arb_req_udpt_permit
                                     && !pfu_has_pre_req); // hidden condition is pfu_create_success, if permit update and no pre_req, than current created req is sent to pfu_arb_req_unmask
    // output req to arb logic
    always@(posedge forever_cpuclk, negedge cpurst_b)begin 
        if(!cpurst_b)
            pfu_arb_req_unmask <= 1'b0;
        else if(pfu_create_success || pfu_has_pre_req) // no matter the pfu_arb_req_unmask is granted or not
            pfu_arb_req_unmask <= 1'b1;
        else if(pfu_only_req_is_grnt)
            pfu_arb_req_unmask <= 1'b0;
    end
    assign pfu_has_pre_req = |(~pfu_req_ptr & pfu_entry_req); // pfu_entry_req excluding the current in pfu_arb_req_unmask

    assign pfu_only_req_is_grnt = pfu_arb_req_unmask
                                  && arb_pfu_grnt
                                  && !pfu_create_success
                                  && !pfu_has_pre_req;

    assign pfu_arb_req_udpt_permit = !pfu_arb_req_unmask
                                      || arb_pfu_grnt;

    assign pfu_arb_req_udpt_vld = pfu_arb_req_udpt_permit
                                  && (pfu_has_pre_req
                                      || pfu_create_success);
    
    always@(posedge forever_cpuclk, negedge cpurst_b)begin 
        if(!cpurst_b) begin 
            pfu_req_ptr       <= 8'b0;
            pfu_req_priv_mode <= 2'b0;
            pfu_req_va        <= {`WK_PPN_WIDTH{1'b0}};
        end
        else if(pfu_arb_req_udpt_vld && pfu_has_pre_req)begin 
            pfu_req_ptr       <= pfu_req_pre_ptr;
            pfu_req_priv_mode <= pfu_req_pre_priv_mode;
            pfu_req_va        <= pfu_req_pre_va;
        end
        else if(pfu_arb_req_udpt_vld && pfu_create_success)begin 
            pfu_req_ptr       <= pfu_create_ptr;
            pfu_req_priv_mode <= lsu_mmu_va4_priv_mode;
            pfu_req_va        <= lsu_mmu_va4;
        end
    end
    assign pfu_read_ptr_1st[0] = pfu_entry_req[0];
    generate
        for(genvar i=1; i<8; i++)
            assign pfu_read_ptr_1st[i] = pfu_entry_req[i] & ~(|pfu_entry_req[i-1:0]);
    endgenerate

    assign pfu_req_pre_ptr_msk = ~((pfu_req_ptr-8'b1) | pfu_req_ptr) & pfu_entry_req;
    assign pfu_req_pre_ptr_msk_1st[0] = pfu_req_pre_ptr_msk[0];
    generate
        for(genvar i=1; i<8; i++)
            assign pfu_req_pre_ptr_msk_1st[i] = pfu_req_pre_ptr_msk[i] & ~(|pfu_req_pre_ptr_msk[i-1:0]);
    endgenerate
    assign pfu_req_pre_ptr = |pfu_req_pre_ptr_msk
                             ? pfu_req_pre_ptr_msk_1st
                             : pfu_read_ptr_1st;
    always_comb begin 
        pfu_req_pre_priv_mode = 2'b0;
        pfu_req_pre_va = {`WK_PPN_WIDTH{1'b0}};
        for(int i=0; i<8; i++)
            if(pfu_req_pre_ptr[i] == 1'b1)begin 
                pfu_req_pre_priv_mode = pfu_entry_priv_mode[i];
                pfu_req_pre_va        = pfu_entry_va[i];
            end
    end
    assign pfu_arb_vld = pfu_arb_req_unmask
                         && !ptw_pfu_va_hit; // extend to support va_hit
    assign pfu_arb_ptr = {3{pfu_req_ptr[0]}} & 3'd0
                       | {3{pfu_req_ptr[1]}} & 3'd1
                       | {3{pfu_req_ptr[2]}} & 3'd2
                       | {3{pfu_req_ptr[3]}} & 3'd3
                       | {3{pfu_req_ptr[4]}} & 3'd4
                       | {3{pfu_req_ptr[5]}} & 3'd5
                       | {3{pfu_req_ptr[6]}} & 3'd6
                       | {3{pfu_req_ptr[7]}} & 3'd7;
    assign pfu_xxx_priv_mode = pfu_req_priv_mode;
    assign pfu_jtlb_va       = pfu_req_va;
    // assign pfu_arb_vld = |pfu_entry_req[7:0] || lsu_mmu_va4_vld;
    // assign pfu_read_ptr_1st[0] = pfu_entry_req[0];
    // generate
    //     for(genvar i=1; i<8; i++)
    //         assign pfu_read_ptr_1st[i] = pfu_entry_req[i] & ~(|pfu_entry_req[i-1:0]);
    // endgenerate
    // always@(posedge forever_cpuclk, negedge cpurst_b)begin
    //     if(!cpurst_b)
    //         pfu_read_ptr <= 8'b0;
    //     else if(pfu_create_on_empty)
    //         pfu_read_ptr <= pfu_create_ptr;
    //     else if(pfu_read_ptr_udpt_val)
    //         pfu_read_ptr <= pfu_read_ptr_nxt;
    // end

    // assign pfu_create_on_empty = lsu_mmu_va4_vld
    //                              && !pfu_entry_full
    //                              && ( !arb_pfu_grnt 
    //                                   && ~(|pfu_entry_req) // current no req, and the created req is not imme grnted
    //                                 || (pfu_read_ptr == pfu_entry_req)
    //                                    && arb_pfu_grnt     // the only 1 req is grnted, 
    //                              );

    // assign pfu_read_ptr_udpt_val = arb_pfu_grnt; // update the ptr whenever a 
                                //    && |(pfu_entry_req[7:0] & ~pfu_read_ptr[7:0]); // has other req, excluding current one

    // assign pfu_read_ptr_msk = (~((pfu_read_ptr - 8'b1) | pfu_read_ptr))
    //                           & pfu_entry_req; // pfu_read_ptr_msk only restore req bits high then pfu_read_ptr

    // assign pfu_read_ptr_msk_1st[0] = pfu_read_ptr_msk[0];

    // generate
    //     for(genvar i=1; i<8; i++)
    //         assign pfu_read_ptr_msk_1st[i] = pfu_read_ptr_msk[i] & ~(|pfu_read_ptr_msk[i-1:0]);
    // endgenerate

    // assign pfu_read_ptr_nxt = |pfu_read_ptr_msk
    //                           ? pfu_read_ptr_msk_1st
    //                           : pfu_read_ptr_1st;


    // assign pfu_req_ptr = pfu_req_byp_vld?pfu_create_ptr : pfu_read_ptr;
    // assign pfu_arb_ptr = {3{pfu_req_ptr[0]}} & 3'd0
    //                    | {3{pfu_req_ptr[1]}} & 3'd1
    //                    | {3{pfu_req_ptr[2]}} & 3'd2
    //                    | {3{pfu_req_ptr[3]}} & 3'd3
    //                    | {3{pfu_req_ptr[4]}} & 3'd4
    //                    | {3{pfu_req_ptr[5]}} & 3'd5
    //                    | {3{pfu_req_ptr[6]}} & 3'd6
    //                    | {3{pfu_req_ptr[7]}} & 3'd7;
    // always_comb begin
    //     pfu_read_va = {28{1'b0}};
    //     pfu_read_priv_mode = 2'b00;
    //     for(int i=0; i<8; i++) begin 
    //         if(pfu_req_ptr[i] == 1'b1) begin 
    //             pfu_read_va = pfu_entry_va[i];
    //             pfu_read_priv_mode = pfu_entry_priv_mode[i];
    //         end
    //     end
    // end
    // assign pfu_xxx_priv_mode = pfu_req_byp_vld? lsu_mmu_va4_priv_mode : pfu_read_priv_mode;
    // assign pfu_jtlb_va       = pfu_req_byp_vld? lsu_mmu_va4           : pfu_read_va;


    // grnt 
    assign pfu_entry_req_grnt = {8{arb_pfu_grnt}} & pfu_req_ptr[7:0];
    // cmplt
    generate
        for(genvar i=0; i<8; i++)
            assign pfu_cmplt_ptr[i] = (jtlb_pfu_ptr[2:0] == 3'(i)) & jtlb_pfu_cmplt; 
    endgenerate
    // pmp
    always_comb begin 
        mmu_pmp_pa4 = {`WK_PPN_WIDTH{1'b0}};
        for(int i=0; i<8; i++)
            if(pfu_entry_cmplt_ff1[i] == 1'b1)
                mmu_pmp_pa4 = pfu_entry_pa[i];
    end
    // output to lsu
    assign mmu_lsu_pa4_vld = |pfu_entry_ack_vld[7:0];
    assign pfu_entry_ack_ptr[0] = pfu_entry_ack_vld[0];
    generate
        for(genvar i=1; i<8; i++)
            assign pfu_entry_ack_ptr[i] = pfu_entry_ack_vld[i] & ~(|pfu_entry_ack_vld[i-1:0]);
    endgenerate
    always_comb begin 
        mmu_lsu_pa4         = {`WK_PPN_WIDTH{1'b0}};
        mmu_lsu_pa4_err     = 1'b0;
        mmu_lsu_sec4        = 1'b0;
        mmu_lsu_share4      = 1'b0;
        mmu_lsu_pfu_resp_id = 4'b0000;
        for(int i=0; i<8; i++)
            if(pfu_entry_ack_ptr[i] == 1'b1) begin 
                mmu_lsu_pa4         = pfu_entry_pa[i];
                mmu_lsu_pa4_err     = pfu_entry_err[i];
                mmu_lsu_sec4        = pfu_entry_sec[i];
                mmu_lsu_share4      = pfu_entry_share[i];
                mmu_lsu_pfu_resp_id = pfu_entry_resp_id[i];
            end
    end
    // instantiated entry
    generate
        for(genvar i=0; i<8; i++) begin 
            xx_mmu_pfu_entry i_xx_mmu_pfu_entry(
                .cpurst_b                   (cpurst_b                   ),
                .forever_cpuclk             (forever_cpuclk             ),
                .pfu_entry_create_vld       (pfu_create_vld[i]          ),
                // .pfu_entry_pop_vld          (pfu_entry_pop_vld          ),
                .pfu_entry_create_va        (lsu_mmu_va4                ),
                .pfu_entry_create_priv_mode (lsu_mmu_va4_priv_mode      ),
                .pfu_entry_create_resp_id   (lsu_mmu_pfu_req_id_q       ),
                .pfu_entry_req_grnt         (pfu_entry_req_grnt[i]      ),
                .pfu_entry_create_req       (pfu_create_with_req        ),
                .jtlb_pfu_cmplt             (pfu_cmplt_ptr[i]           ),
                .jtlb_pfu_acc_fault         (jtlb_pfu_acc_fault         ),
                .jtlb_pfu_pa                (jtlb_pfu_pa                ),
                .jtlb_pfu_sec               (jtlb_pfu_sec               ),
                .jtlb_pfu_share             (jtlb_pfu_share             ),
                .pmp_mmu_flg4               (pmp_mmu_flg4               ),
                .pfu_entry_ack_grnt         (pfu_entry_ack_ptr[i]       ),
                .pfu_entry_vld_x            (pfu_entry_vld[i]           ),
                .pfu_entry_req_x            (pfu_entry_req[i]           ),
                .pfu_entry_va_v             (pfu_entry_va[i]            ),
                .pfu_entry_pa_v             (pfu_entry_pa[i]            ),
                .pfu_entry_sec_x            (pfu_entry_sec[i]           ),
                .pfu_entry_share_x          (pfu_entry_share[i]         ),
                .pfu_entry_resp_id_v        (pfu_entry_resp_id[i]       ),
                .pfu_entry_priv_mode_v      (pfu_entry_priv_mode[i]     ),
                .pfu_entry_ack_vld_x        (pfu_entry_ack_vld[i]       ),
                .pfu_entry_err_x            (pfu_entry_err[i]           ),
                .pfu_entry_cmplt_ff1_x      (pfu_entry_cmplt_ff1[i]     )
            );
        end
    endgenerate


endmodule
