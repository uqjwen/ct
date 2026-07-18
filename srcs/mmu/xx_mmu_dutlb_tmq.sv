//-----------------------------------------------------------------------------
// File          : xx_mmu_dutlb_tmq.sv
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
module xx_mmu_dutlb_tmq #(
    parameter LSIQENTRY = 12,
    parameter TMQ_NUM = 8,
    parameter IID_WIDTH = 7
)(
    input logic                  forever_cpuclk,
    input logic                  cpurst_b,
    input logic                  cp0_mmu_icg_en,
    input logic                  pad_yy_icg_scan_en,
    input logic                  dutlb_miss_vld0,
    input logic                  dutlb_miss_vld2,
    input logic                  dutlb_miss_vld3,
    input logic [`WK_VPN_WIDTH-1:0]           utlb_req_vpn0,
    input logic [`WK_VPN_WIDTH-1:0]           utlb_req_vpn2,
    input logic [`WK_VPN_WIDTH-1:0]           utlb_req_vpn3,
    input logic [LSIQENTRY-1:0]  lsu_mmu_lsid0,
    input logic [LSIQENTRY-1:0]  lsu_mmu_lsid2,
    input logic [LSIQENTRY-1:0]  lsu_mmu_lsid3,
    input logic [IID_WIDTH-1:0]  lsu_mmu_id0,
    input logic [IID_WIDTH-1:0]  lsu_mmu_id2,
    input logic [IID_WIDTH-1:0]  lsu_mmu_id3,
    input logic                  lsu_mmu_st_inst0,
    input logic                  lsu_mmu_st_inst2,
    input logic                  lsu_mmu_st_inst3,
    input logic                  lsu_mmu_old0,
    input logic                  lsu_mmu_old2,
    input logic                  lsu_mmu_old3,
    input logic                  dutlb_req_id02_older,
    input logic                  dutlb_req_id03_older,
    input logic                  dutlb_req_id23_older,
    input logic                  rtu_yy_xx_flush,
    input logic                  rtu_ck_flush,
    input logic [IID_WIDTH-1:0]  rtu_ck_flush_iid,    
    input logic                  arb_dutlb_grant, // the tmq_req_* is grant, and tmq_req_ptr will move to nxt
    input logic [TMQ_NUM-1:0]    arb_dutlb_cmplt_ptr,
    input logic [TMQ_NUM-1:0]    refill_tmq_ptr,
    input logic                  ptw_tmq_va_hit,
    output logic                 tmq_req_vld,
    output logic [TMQ_NUM-1:0]   tmq_req_ptr, // 
    output logic [`WK_VPN_WIDTH-1:0]          tmq_req_vpn,
    output logic [LSIQENTRY-1:0] tmq_req_lsid0, // used for early wakeup in the future
    output logic [LSIQENTRY-1:0] tmq_req_lsid2,
    output logic [LSIQENTRY-1:0] tmq_req_lsid3,
    output logic [IID_WIDTH-1:0] tmq_req_iid,
    output logic                 tmq_req_st,
    output logic [LSIQENTRY-1:0] tmq_lsu0_cmplt_wakeup,
    output logic [LSIQENTRY-1:0] tmq_lsu2_cmplt_wakeup,
    output logic [LSIQENTRY-1:0] tmq_lsu3_cmplt_wakeup,
    output logic [LSIQENTRY-1:0] tmq_lsu0_spec_wakeup,
    output logic [LSIQENTRY-1:0] tmq_lsu2_spec_wakeup,
    output logic [LSIQENTRY-1:0] tmq_lsu3_spec_wakeup,
    output logic [LSIQENTRY-1:0] tmq_lsu0_imme_wakeup,
    output logic [LSIQENTRY-1:0] tmq_lsu2_imme_wakeup,
    output logic [LSIQENTRY-1:0] tmq_lsu3_imme_wakeup,
    output logic [LSIQENTRY-1:0] rtu_ck_flush_wakeup_lsu0,
    output logic [LSIQENTRY-1:0] rtu_ck_flush_wakeup_lsu2,
    output logic [LSIQENTRY-1:0] rtu_ck_flush_wakeup_lsu3,   
    output logic [`WK_VPN_WIDTH-1:0]          tmq_refill_vpn
);

logic [TMQ_NUM-1:0] tmq_entry_vld;
logic [TMQ_NUM-1:0] tmq_global_grnt;
logic [TMQ_NUM-1:0] tmq_create0_ptr;
logic [TMQ_NUM-1:0] tmq_create2_ptr;
logic [TMQ_NUM-1:0] tmq_create3_ptr;
logic [TMQ_NUM-1:0] tmq_create3_tmp_ptr;
logic [TMQ_NUM-1:0] tmq_create0_vld;
logic [TMQ_NUM-1:0] tmq_create2_vld;
logic [TMQ_NUM-1:0] tmq_create3_vld;
logic               tmq_create0_success;
logic               tmq_create2_success;
logic               tmq_create3_success;
logic               tmq_entry_full;
logic               tmq_entry_empty;
logic               tmq_entry_less2;
logic               tmq_entry_less3;

logic               tmq_create0_unmask;
logic               tmq_create2_unmask;
logic               tmq_create3_unmask;
logic [TMQ_NUM-1:0] tmq_vpn_hit0;
logic [TMQ_NUM-1:0] tmq_vpn_hit2;
logic [TMQ_NUM-1:0] tmq_vpn_hit3;
logic [TMQ_NUM-1:0] tmq_merge0_vld;
logic [TMQ_NUM-1:0] tmq_merge2_vld;
logic [TMQ_NUM-1:0] tmq_merge3_vld;
logic               tmq_vpn_eq02;
logic               tmq_vpn_eq03;
logic               tmq_vpn_eq23;
logic               tmq_cmb_2to0;
logic               tmq_cmb_3to0;
logic               tmq_cmb_0to2;
logic               tmq_cmb_3to2;
logic               tmq_cmb_0to3;
logic               tmq_cmb_2to3;
logic               tmq_create0_set_lsid2;
logic               tmq_create0_set_lsid3;
logic               tmq_create2_set_lsid0;
logic               tmq_create2_set_lsid3;
logic               tmq_create3_set_lsid0;
logic               tmq_create3_set_lsid2;

logic                 tmq_req_unmask;
logic                 tmq_pe_req;
logic                 lsu_pe_req;
logic                 lsu0_pe_req;
logic                 lsu2_pe_req;
logic                 lsu3_pe_req;
logic                 tmq_req_udpt_pmit;
logic [TMQ_NUM-1:0]   tmq_pe_req_ptr;
logic [TMQ_NUM-1:0]   tmq_pe_req_ptr_1st;
logic [TMQ_NUM-1:0]   tmq_pe_req_ptr_msk;
logic [TMQ_NUM-1:0]   tmq_pe_req_ptr_msk_1st;

logic                 tmq_create0_wo_req;
logic                 tmq_create2_wo_req;
logic                 tmq_create3_wo_req;
logic                 tmq_create0_with_req;
logic                 tmq_create2_with_req;
logic                 tmq_create3_with_req;

logic                 tmq_lsu0_merge_pop;
logic                 tmq_lsu2_merge_pop;
logic                 tmq_lsu3_merge_pop;

logic [TMQ_NUM-1:0]   tmq_pe_grnt;
logic [TMQ_NUM-1:0]   tmq_arb_grnt;
logic [TMQ_NUM-1:0]   tmq_entry_pop_vld;      

logic [TMQ_NUM-1:0]                tmq_entry_req;
logic [TMQ_NUM-1:0][`WK_VPN_WIDTH-1:0]          tmq_entry_vpn;
logic [TMQ_NUM-1:0][LSIQENTRY-1:0] tmq_entry_lsid0;
logic [TMQ_NUM-1:0][LSIQENTRY-1:0] tmq_entry_lsid2;
logic [TMQ_NUM-1:0][LSIQENTRY-1:0] tmq_entry_lsid3;
logic [TMQ_NUM-1:0][IID_WIDTH-1:0] tmq_entry_iid;
logic [TMQ_NUM-1:0]                tmq_entry_st;

logic                              spec_wk_clk;
logic                              spec_wk_clk_en;
logic                              tmq_vpn_hit_vld0;
logic                              tmq_vpn_hit_vld2;
logic                              tmq_vpn_hit_vld3;
logic                              tmq_lsu0_full;
logic                              tmq_lsu2_full;
logic                              tmq_lsu3_full;
logic                              lsu_with_old0;
logic                              lsu_with_old2;
logic                              lsu_with_old3;
logic                              tmq_create0_nold;
logic                              tmq_create2_nold;
logic                              tmq_create3_nold;
logic [TMQ_NUM-1:0]                tmq_old_ptr;

assign lsu_with_old0 = lsu_mmu_old0 | (dutlb_miss_vld2 & tmq_vpn_eq02 & lsu_mmu_old2) | (dutlb_miss_vld3 & tmq_vpn_eq03 & lsu_mmu_old3);
assign lsu_with_old2 = lsu_mmu_old2 | (dutlb_miss_vld0 & tmq_vpn_eq02 & lsu_mmu_old0) | (dutlb_miss_vld3 & tmq_vpn_eq23 & lsu_mmu_old3);
assign lsu_with_old3 = lsu_mmu_old3 | (dutlb_miss_vld0 & tmq_vpn_eq03 & lsu_mmu_old0) | (dutlb_miss_vld2 & tmq_vpn_eq23 & lsu_mmu_old2);
assign tmq_create0_nold = tmq_create0_unmask & ~lsu_mmu_old0;
assign tmq_create2_nold = tmq_create2_unmask & ~lsu_mmu_old2;
assign tmq_create3_nold = tmq_create3_unmask & ~lsu_mmu_old3;

logic                              rtu_ck_flush_older_eq_tmp_req;//ck_flush@LTL
logic                              rtu_ck_flush_older_tmp_req;
logic                              rtu_ck_flush_older_create0;
logic                              rtu_ck_flush_older_create2;
logic                              rtu_ck_flush_older_create3;
assign tmq_vpn_eq02 = (utlb_req_vpn0 == utlb_req_vpn2); 
assign tmq_vpn_eq03 = (utlb_req_vpn0 == utlb_req_vpn3);
assign tmq_vpn_eq23 = (utlb_req_vpn2 == utlb_req_vpn3);

assign tmq_merge0_vld = {TMQ_NUM{dutlb_miss_vld0}} & tmq_vpn_hit0;
assign tmq_merge2_vld = {TMQ_NUM{dutlb_miss_vld2}} & tmq_vpn_hit2;
assign tmq_merge3_vld = {TMQ_NUM{dutlb_miss_vld3}} & tmq_vpn_hit3;
assign tmq_vpn_hit_vld0 = |tmq_vpn_hit0[TMQ_NUM-1:0];
assign tmq_vpn_hit_vld2 = |tmq_vpn_hit2[TMQ_NUM-1:0];
assign tmq_vpn_hit_vld3 = |tmq_vpn_hit3[TMQ_NUM-1:0];

assign tmq_create0_unmask =  dutlb_miss_vld0
                             && !tmq_vpn_hit_vld0
                             && !(dutlb_miss_vld2
                                  && tmq_vpn_eq02
                                  && !dutlb_req_id02_older)
                             && !(dutlb_miss_vld3
                                  && tmq_vpn_eq03
                                  && !dutlb_req_id03_older);
assign tmq_cmb_2to0 = tmq_vpn_eq02
                      && !tmq_vpn_hit_vld0 // means also !tmq_merge2_vld
                      && dutlb_req_id02_older
                      && (!dutlb_miss_vld3 // 2 is combined into 0 rather than 3
                          || !tmq_vpn_eq23
                          || dutlb_req_id03_older);
assign tmq_cmb_3to0 = tmq_vpn_eq03
                      && !tmq_vpn_hit_vld0
                      && dutlb_req_id03_older
                      && (!dutlb_miss_vld2
                          || !tmq_vpn_eq23
                          || dutlb_req_id02_older);

assign tmq_create2_unmask = dutlb_miss_vld2
                            && !tmq_vpn_hit_vld2
                            && !(dutlb_miss_vld0
                                 && tmq_vpn_eq02
                                 && dutlb_req_id02_older)
                            && !(dutlb_miss_vld3
                                 && tmq_vpn_eq23
                                 && !dutlb_req_id23_older);
assign tmq_cmb_0to2 = tmq_vpn_eq02
                      && !tmq_vpn_hit_vld2
                      && !dutlb_req_id02_older
                      && (!dutlb_miss_vld3
                          || !tmq_vpn_eq03
                          || dutlb_req_id23_older);
assign tmq_cmb_3to2 = tmq_vpn_eq23
                      && !tmq_vpn_hit_vld2
                      && dutlb_req_id23_older
                      && (!dutlb_miss_vld0
                          || !tmq_vpn_eq03
                          || !dutlb_req_id02_older);

assign tmq_create3_unmask = dutlb_miss_vld3
                            && !tmq_vpn_hit_vld3
                            && !(dutlb_miss_vld0
                                 && tmq_vpn_eq03
                                 && dutlb_req_id03_older)
                            && !(dutlb_miss_vld2
                                 && tmq_vpn_eq23
                                 && dutlb_req_id23_older);
assign tmq_cmb_0to3 = tmq_vpn_eq03
                      && !tmq_vpn_hit_vld3
                      && !dutlb_req_id03_older
                      && (!dutlb_miss_vld2
                          || !tmq_vpn_eq02
                          || !dutlb_req_id23_older);
assign tmq_cmb_2to3 = tmq_vpn_eq23
                      && !tmq_vpn_hit_vld3
                      && !dutlb_req_id23_older
                      && (!dutlb_miss_vld0
                          || !tmq_vpn_eq02
                          || !dutlb_req_id03_older);
//  TMQ PTR Created
assign tmq_old_ptr = {1'b1, {TMQ_NUM-1{1'b0}}};
assign tmq_create0_ptr[0] = ~tmq_entry_vld[0];
assign tmq_create0_ptr[TMQ_NUM-1] = 1'b0;
generate
    for(genvar i=1; i<TMQ_NUM-1; i++)
        assign tmq_create0_ptr[i] = ~tmq_entry_vld[i] & (&tmq_entry_vld[i-1:0]);
endgenerate

assign tmq_create2_ptr[TMQ_NUM-1] = 1'b0;
assign tmq_create2_ptr[TMQ_NUM-2] = ~tmq_entry_vld[TMQ_NUM-2];
generate
    for(genvar i=TMQ_NUM-3; i>=0; i--)
        assign tmq_create2_ptr[i] = ~tmq_entry_vld[i] & (&tmq_entry_vld[TMQ_NUM-2:i+1]);
endgenerate

assign tmq_create3_tmp_ptr[TMQ_NUM-1] = 1'b0;
assign tmq_create3_tmp_ptr[TMQ_NUM-2] = 1'b0;
generate
    for(genvar i=TMQ_NUM-3; i>=0; i--)
        assign tmq_create3_tmp_ptr[i] = ~tmq_entry_vld[i] & (&(tmq_entry_vld[TMQ_NUM-2:i+1] | tmq_create2_ptr[TMQ_NUM-2:i+1])) & (|(tmq_create2_ptr[TMQ_NUM-2:i+1]));
endgenerate
// assign tmq_create3_ptr = tmq_create2_unmask? tmq_create3_tmp_ptr: tmq_create2_ptr;
assign tmq_create3_ptr = tmq_create2_nold ? tmq_create3_tmp_ptr: tmq_create2_ptr;

assign tmq_entry_less2 = &(tmq_entry_vld[TMQ_NUM-2:0] | tmq_create0_ptr[TMQ_NUM-2:0]);
assign tmq_entry_less3 = &(tmq_entry_vld[TMQ_NUM-2:0] | tmq_create0_ptr[TMQ_NUM-2:0] | tmq_create2_ptr[TMQ_NUM-2:0]);
assign tmq_entry_full  = &tmq_entry_vld[TMQ_NUM-2:0];
// assign tmq_entry_empty = ~(|tmq_entry_vld);
assign tmq_create0_success = tmq_create0_unmask
                             && !rtu_yy_xx_flush
                             && (!tmq_entry_full || lsu_mmu_old0)
                             && !(rtu_ck_flush && rtu_ck_flush_older_create0);       //flush younger create, ck_flush@LTL
assign tmq_create2_success = tmq_create2_unmask
                             && !rtu_yy_xx_flush
                             && !(rtu_ck_flush && rtu_ck_flush_older_create2)      //flush younger create, ck_flush@LTL
                             && (!tmq_entry_less2
                                 || !tmq_entry_full && !tmq_create0_nold
                                 || lsu_mmu_old2);
assign tmq_create3_success = tmq_create3_unmask
                             && !rtu_yy_xx_flush
                             && !(rtu_ck_flush && rtu_ck_flush_older_create3)   //flush younger create, ck_flush@LTL
                             && (!tmq_entry_less3
                                 || !tmq_entry_full  && !tmq_create0_nold && !tmq_create2_nold
                                 || !tmq_entry_less2 && !(tmq_create0_nold && tmq_create2_nold)
                                 || lsu_mmu_old3);

assign tmq_create0_set_lsid2 = tmq_create0_success && tmq_vpn_eq02 /*tmq_cmb_2to0*/ && dutlb_miss_vld2;
assign tmq_create0_set_lsid3 = tmq_create0_success && tmq_vpn_eq03 /*tmq_cmb_3to0*/ && dutlb_miss_vld3;
assign tmq_create2_set_lsid0 = tmq_create2_success && tmq_vpn_eq02 /*tmq_cmb_0to2*/ && dutlb_miss_vld0;
assign tmq_create2_set_lsid3 = tmq_create2_success && tmq_vpn_eq23 /*tmq_cmb_3to2*/ && dutlb_miss_vld3;
assign tmq_create3_set_lsid0 = tmq_create3_success && tmq_vpn_eq03 /*tmq_cmb_0to3*/ && dutlb_miss_vld0;
assign tmq_create3_set_lsid2 = tmq_create3_success && tmq_vpn_eq23 /*tmq_cmb_2to3*/ && dutlb_miss_vld2;

assign tmq_create0_vld = {TMQ_NUM{tmq_create0_success}} & (lsu_mmu_old0? tmq_old_ptr:tmq_create0_ptr);
assign tmq_create2_vld = {TMQ_NUM{tmq_create2_success}} & (lsu_mmu_old2? tmq_old_ptr:tmq_create2_ptr);
assign tmq_create3_vld = {TMQ_NUM{tmq_create3_success}} & (lsu_mmu_old3? tmq_old_ptr:tmq_create3_ptr);

// assign tmq_create0_agevec = tmq_entry_olderthan_lsu0[TMQ_NUM-1:0]
//                           | tmq_create2_vld & {TMQ_NUM{~dutlb_req_id02_older}}
//                           | tmq_create3_vld & {TMQ_NUM{~dutlb_req_id03_older}}; // merge success
// assign tmq_create2_agevec = tmq_entry_olderthan_lsu2
//                           | tmq_create0_vld & {TMQ_NUM{dutlb_req_id02_older}}
//                           | tmq_create3_vld & {TMQ_NUM{~dutlb_req_id23_older}};
// assign tmq_create3_agevec = tmq_entry_olderthan_lsu3
//                           | tmq_create0_vld & {TMQ_NUM{dutlb_req_id03_older}}
//                           | tmq_create2_vld & {TMQ_NUM{dutlb_req_id23_older}};

// assign tmq_lsu0_full = dutlb_miss_vld0 
//                        && (!tmq_vpn_hit_vld0 && tmq_entry_full
//                            || tmq_entry_less2
//                               && tmq_create2_unmask
//                               && tmq_create3_unmask
//                               && tmq_cmb_0to3); // hidden condition is !tmq_vpn_hit_vld0
assign tmq_lsu0_full = dutlb_miss_vld0 & ~tmq_vpn_hit_vld0 & ~lsu_with_old0
                       & (tmq_entry_full
                          || tmq_entry_less2
                             & tmq_create2_nold
                             & tmq_create3_nold
                             & tmq_vpn_eq03);

assign tmq_lsu2_full = dutlb_miss_vld2 
                       && !tmq_vpn_hit_vld2
                       && !lsu_with_old2
                       &&(tmq_entry_full
                          || tmq_entry_less2
                             && tmq_create0_nold
                             && !tmq_vpn_eq02);

assign tmq_lsu3_full = dutlb_miss_vld3 
                       && !tmq_vpn_hit_vld3
                       && !lsu_with_old3
                       &&(tmq_entry_full
                          || tmq_entry_less2
                             && (tmq_create0_nold && !tmq_vpn_eq03
                                 || tmq_create2_nold && !tmq_create0_nold && !tmq_vpn_eq23)
                          || tmq_entry_less3
                             && tmq_create0_nold
                             && tmq_create2_nold
                             && !(tmq_vpn_eq03 || tmq_vpn_eq23));

assign tmq_lsu0_merge_pop = |(tmq_merge0_vld & arb_dutlb_cmplt_ptr);
assign tmq_lsu2_merge_pop = |(tmq_merge2_vld & arb_dutlb_cmplt_ptr);
assign tmq_lsu3_merge_pop = |(tmq_merge3_vld & arb_dutlb_cmplt_ptr);

assign tmq_lsu0_imme_wakeup = {LSIQENTRY{(tmq_lsu0_full || tmq_lsu0_merge_pop) && ~rtu_ck_flush}} & lsu_mmu_lsid0;  //ck_flush avoid repeat wakeup , ck_flush@LTL
assign tmq_lsu2_imme_wakeup = {LSIQENTRY{(tmq_lsu2_full || tmq_lsu2_merge_pop) && ~rtu_ck_flush}} & lsu_mmu_lsid2;
assign tmq_lsu3_imme_wakeup = {LSIQENTRY{(tmq_lsu3_full || tmq_lsu3_merge_pop) && ~rtu_ck_flush}} & lsu_mmu_lsid3;
// tmq_req
assign tmq_pe_req_ptr_1st[0] = tmq_entry_req[0];
generate
    for(genvar i=1; i<TMQ_NUM; i++)
        assign tmq_pe_req_ptr_1st[i] = tmq_entry_req[i] & ~(|tmq_entry_req[i-1:0]);
endgenerate
assign tmq_pe_req_ptr = |tmq_pe_req_ptr_msk ? tmq_pe_req_ptr_msk_1st : tmq_pe_req_ptr_1st;
assign tmq_pe_req_ptr_msk = ~((tmq_req_ptr-1'b1) | tmq_req_ptr) & tmq_entry_req;  //ck_flush@LTL, entry_vld -> entry_req
assign tmq_pe_req_ptr_msk_1st[0] = tmq_pe_req_ptr_msk[0];
generate
    for(genvar i=1; i<TMQ_NUM; i++)
        assign tmq_pe_req_ptr_msk_1st[i] = tmq_pe_req_ptr_msk[i] & ~(|tmq_pe_req_ptr_msk[i-1:0]);
endgenerate
always_comb begin 
    tmq_req_vpn   = {`WK_VPN_WIDTH{1'b0}};
    tmq_req_lsid0 = {LSIQENTRY{1'b0}};
    tmq_req_lsid2 = {LSIQENTRY{1'b0}};
    tmq_req_lsid3 = {LSIQENTRY{1'b0}};
    tmq_req_iid   = {IID_WIDTH{1'b0}};
    tmq_req_st    = 1'b0;
    for(int i=0; i<TMQ_NUM; i++)
        if(tmq_req_ptr[i] == 1'b1)begin 
            tmq_req_vpn   = tmq_entry_vpn[i];
            tmq_req_lsid0 = tmq_entry_lsid0[i];
            tmq_req_lsid2 = tmq_entry_lsid2[i];
            tmq_req_lsid3 = tmq_entry_lsid3[i];
            tmq_req_iid   = tmq_entry_iid[i];
            tmq_req_st    = tmq_entry_st[i];
        end
end
always_comb begin 
    tmq_refill_vpn   = {`WK_VPN_WIDTH{1'b0}};
    for(int i=0; i<TMQ_NUM; i++)
        if(refill_tmq_ptr[i] == 1'b1)begin 
            tmq_refill_vpn   = tmq_entry_vpn[i];
        end
end
always@(posedge forever_cpuclk, negedge cpurst_b)begin 
    if(!cpurst_b)
        tmq_req_unmask <= 1'b0;
    else if(tmq_pe_req || lsu_pe_req)
        tmq_req_unmask <= 1'b1;
    else if(arb_dutlb_grant || rtu_yy_xx_flush || (rtu_ck_flush &&rtu_ck_flush_older_eq_tmp_req))  //ck_flush younger req_unmask , ck_flush@LTL
        tmq_req_unmask <= 1'b0;
end

assign rtu_ck_flush_older_eq_tmp_req = rtu_ck_flush_older_tmp_req || (rtu_ck_flush_iid == tmq_req_iid);
wk_rtu_compare_iid #(.IID_WIDTH(IID_WIDTH))  x_rtu_ck_flush_compare_tmp_req_iid (
  .x_iid0              (rtu_ck_flush_iid[IID_WIDTH-1:0]   ),
  .x_iid0_older        (rtu_ck_flush_older_tmp_req        ),
  .x_iid1              (tmq_req_iid[IID_WIDTH-1:0]      )
);
wk_rtu_compare_iid #(.IID_WIDTH(IID_WIDTH))  x_rtu_ck_flush_compare_create0_iid (
  .x_iid0              (rtu_ck_flush_iid[IID_WIDTH-1:0]   ),
  .x_iid0_older        (rtu_ck_flush_older_create0        ),
  .x_iid1              (lsu_mmu_id0[IID_WIDTH-1:0]      )
);
wk_rtu_compare_iid #(.IID_WIDTH(IID_WIDTH))  x_rtu_ck_flush_compare_create2_iid (
  .x_iid0              (rtu_ck_flush_iid[IID_WIDTH-1:0]   ),
  .x_iid0_older        (rtu_ck_flush_older_create2        ),
  .x_iid1              (lsu_mmu_id2[IID_WIDTH-1:0]      )
);
wk_rtu_compare_iid #(.IID_WIDTH(IID_WIDTH))  x_rtu_ck_flush_compare_create3_iid (
  .x_iid0              (rtu_ck_flush_iid[IID_WIDTH-1:0]   ),
  .x_iid0_older        (rtu_ck_flush_older_create3        ),
  .x_iid1              (lsu_mmu_id3[IID_WIDTH-1:0]      )
);
assign tmq_req_vld = tmq_req_unmask && !rtu_yy_xx_flush && !ptw_tmq_va_hit && !(rtu_ck_flush &&rtu_ck_flush_older_eq_tmp_req); // should mask hit vpn in ptw in the future, //ck_flush younger req_vld , ck_flush@LTL

assign tmq_pe_req = |tmq_entry_req[TMQ_NUM-1:0];

assign lsu_pe_req = tmq_create0_success
                    || tmq_create2_success
                    || tmq_create3_success;

assign lsu0_pe_req = tmq_create0_success
                     && (!tmq_create2_success
                         || dutlb_req_id02_older)
                     && (!tmq_create3_success
                         || dutlb_req_id03_older);

assign lsu2_pe_req = tmq_create2_success
                     && (!tmq_create0_success
                         || !dutlb_req_id02_older)
                     && (!tmq_create3_success
                         || dutlb_req_id23_older);
assign lsu3_pe_req = tmq_create3_success
                     && (!tmq_create0_success
                         || !dutlb_req_id03_older)
                     && (!tmq_create2_success
                         || !dutlb_req_id23_older);

assign tmq_req_udpt_pmit = !tmq_req_unmask || arb_dutlb_grant || (rtu_ck_flush && rtu_ck_flush_older_eq_tmp_req);   //allow update when flush younger req, ck_flush@LTL
assign tmq_pe_grnt       = {TMQ_NUM{tmq_req_udpt_pmit & tmq_pe_req}} & tmq_pe_req_ptr;
assign tmq_arb_grnt      = {TMQ_NUM{arb_dutlb_grant}}   & tmq_req_ptr;
assign tmq_entry_pop_vld = arb_dutlb_cmplt_ptr;
always@(posedge forever_cpuclk, negedge cpurst_b)begin 
    if(!cpurst_b)
        tmq_req_ptr <= {TMQ_NUM{1'b0}};
    else if(tmq_req_udpt_pmit && tmq_pe_req)
        tmq_req_ptr <= tmq_pe_req_ptr;
    else if(tmq_req_udpt_pmit && !tmq_pe_req && lsu0_pe_req)
        tmq_req_ptr <= lsu_mmu_old0? tmq_old_ptr:tmq_create0_ptr;
    else if(tmq_req_udpt_pmit && !tmq_pe_req && lsu2_pe_req)
        tmq_req_ptr <= lsu_mmu_old2? tmq_old_ptr: tmq_create2_ptr;
    else if(tmq_req_udpt_pmit && !tmq_pe_req && lsu3_pe_req)
        tmq_req_ptr <= lsu_mmu_old3? tmq_old_ptr: tmq_create3_ptr;
end
assign tmq_create0_wo_req = tmq_req_udpt_pmit
                            && !tmq_pe_req
                            && lsu0_pe_req; // hidden condition is tmq_create0_success
assign tmq_create2_wo_req = tmq_req_udpt_pmit
                            && !tmq_pe_req
                            && lsu2_pe_req;
assign tmq_create3_wo_req = tmq_req_udpt_pmit
                            && !tmq_pe_req
                            && lsu3_pe_req;
assign tmq_create0_with_req = !tmq_create0_wo_req;
assign tmq_create2_with_req = !tmq_create2_wo_req;
assign tmq_create3_with_req = !tmq_create3_wo_req;

always_comb begin 
    tmq_lsu0_cmplt_wakeup = {LSIQENTRY{1'b0}};
    tmq_lsu2_cmplt_wakeup = {LSIQENTRY{1'b0}};
    tmq_lsu3_cmplt_wakeup = {LSIQENTRY{1'b0}};
    for(int i=0; i<TMQ_NUM; i++)
        if(arb_dutlb_cmplt_ptr[i] == 1'b1)begin 
            tmq_lsu0_cmplt_wakeup = tmq_entry_lsid0[i];
            tmq_lsu2_cmplt_wakeup = tmq_entry_lsid2[i];
            tmq_lsu3_cmplt_wakeup = tmq_entry_lsid3[i];
        end
end
assign spec_wk_clk_en = dutlb_miss_vld0
                        || dutlb_miss_vld2
                        || dutlb_miss_vld3
                        || |tmq_entry_vld;
gated_clk_cell x_spec_wk_gateclk(
    .clk_in             (forever_cpuclk),
    .clk_out            (spec_wk_clk),
    .external_en        (1'b0),
    .local_en           (spec_wk_clk_en),
    .module_en          (cp0_mmu_icg_en),
    .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);
always @(posedge spec_wk_clk, negedge cpurst_b)begin 
    if(!cpurst_b) begin 
        tmq_lsu0_spec_wakeup <= {LSIQENTRY{1'b0}};
        tmq_lsu2_spec_wakeup <= {LSIQENTRY{1'b0}};
        tmq_lsu3_spec_wakeup <= {LSIQENTRY{1'b0}};
    end
    else if(arb_dutlb_grant) begin 
        tmq_lsu0_spec_wakeup <= tmq_req_lsid0 & {LSIQENTRY{~rtu_ck_flush}}; //when ck_flush=1,all wakeup send out, then set to 0 next cycle, ck_flush@LTL
        tmq_lsu2_spec_wakeup <= tmq_req_lsid2 & {LSIQENTRY{~rtu_ck_flush}};
        tmq_lsu3_spec_wakeup <= tmq_req_lsid3 & {LSIQENTRY{~rtu_ck_flush}};
    end
    else begin 
        tmq_lsu0_spec_wakeup <= {LSIQENTRY{1'b0}};
        tmq_lsu2_spec_wakeup <= {LSIQENTRY{1'b0}};
        tmq_lsu3_spec_wakeup <= {LSIQENTRY{1'b0}};
    end
end

generate 
    for(genvar i=0; i<TMQ_NUM; i++) begin 
        xx_mmu_dutlb_tmq_entry #(
            .LSIQENTRY(LSIQENTRY),
            .IID_WIDTH(IID_WIDTH),
            .TMQ_NUM(TMQ_NUM)
        )i_xx_mmu_dutlb_tmq_entry(
            .forever_cpuclk        (forever_cpuclk),
            .cpurst_b              (cpurst_b),
            .rtu_yy_xx_flush       (rtu_yy_xx_flush),
            .rtu_ck_flush          (rtu_ck_flush),
            .rtu_ck_flush_iid      (rtu_ck_flush_iid),
            .tmq_create0_vld       (tmq_create0_vld[i]),
            .tmq_create0_set_lsid2 (tmq_create0_set_lsid2),
            .tmq_create0_set_lsid3 (tmq_create0_set_lsid3),
            .tmq_create0_with_req  (tmq_create0_with_req),
            .tmq_lsu0_lsid         (lsu_mmu_lsid0),
            .tmq_lsu0_iid          (lsu_mmu_id0),
            .tmq_lsu0_st           (lsu_mmu_st_inst0),
            .tmq_lsu0_vpn          (utlb_req_vpn0),
            .tmq_create2_vld       (tmq_create2_vld[i]),
            .tmq_create2_set_lsid0 (tmq_create2_set_lsid0),
            .tmq_create2_set_lsid3 (tmq_create2_set_lsid3),
            .tmq_create2_with_req  (tmq_create2_with_req),
            .tmq_lsu2_lsid         (lsu_mmu_lsid2),
            .tmq_lsu2_iid          (lsu_mmu_id2),
            .tmq_lsu2_st           (lsu_mmu_st_inst2),
            .tmq_lsu2_vpn          (utlb_req_vpn2),
            .tmq_create3_vld       (tmq_create3_vld[i]),
            .tmq_create3_set_lsid0 (tmq_create3_set_lsid0),
            .tmq_create3_set_lsid2 (tmq_create3_set_lsid2),
            .tmq_create3_with_req  (tmq_create3_with_req),
            .tmq_lsu3_lsid         (lsu_mmu_lsid3),
            .tmq_lsu3_iid          (lsu_mmu_id3),
            .tmq_lsu3_st           (lsu_mmu_st_inst3),
            .tmq_lsu3_vpn          (utlb_req_vpn3),
            .tmq_entry_pop_vld     (tmq_entry_pop_vld[i]),
            .tmq_merge0_vld        (tmq_merge0_vld[i]),
            .tmq_merge2_vld        (tmq_merge2_vld[i]),
            .tmq_merge3_vld        (tmq_merge3_vld[i]),
            .tmq_pe_grnt           (tmq_pe_grnt[i]),
            .tmq_arb_grnt          (tmq_arb_grnt[i]),
            .tmq_vpn_hit0_x        (tmq_vpn_hit0[i]),
            .tmq_vpn_hit2_x        (tmq_vpn_hit2[i]),
            .tmq_vpn_hit3_x        (tmq_vpn_hit3[i]),
            .tmq_entry_vld_x       (tmq_entry_vld[i]),
            .tmq_entry_lsid0_v     (tmq_entry_lsid0[i]),
            .tmq_entry_lsid2_v     (tmq_entry_lsid2[i]),
            .tmq_entry_lsid3_v     (tmq_entry_lsid3[i]),
            .tmq_entry_vpn_v       (tmq_entry_vpn[i]),
            .tmq_entry_iid_v       (tmq_entry_iid[i]),
            .tmq_entry_st_x        (tmq_entry_st[i]),
            .tmq_entry_req_x       (tmq_entry_req[i])
        );
    end
endgenerate
always_comb begin
    rtu_ck_flush_wakeup_lsu0 = '0;
    rtu_ck_flush_wakeup_lsu2 = '0;
    rtu_ck_flush_wakeup_lsu3 = '0;
    for(int i=0; i<TMQ_NUM; i++) begin
        rtu_ck_flush_wakeup_lsu0 =  rtu_ck_flush_wakeup_lsu0 | ({LSIQENTRY{tmq_entry_vld[i]}} & tmq_entry_lsid0[i]);        //ck_flush send out all wakeup, ck_flush@LTL
        rtu_ck_flush_wakeup_lsu2 =  rtu_ck_flush_wakeup_lsu2 | ({LSIQENTRY{tmq_entry_vld[i]}} & tmq_entry_lsid2[i]);
        rtu_ck_flush_wakeup_lsu3 =  rtu_ck_flush_wakeup_lsu3 | ({LSIQENTRY{tmq_entry_vld[i]}} & tmq_entry_lsid3[i]);
    end
end

endmodule
