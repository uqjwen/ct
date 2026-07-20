//-----------------------------------------------------------------------------
// File          : wk_lsu_wb_arb.sv
// Created       : 2024/12/30 (by Wen Jiahui)
// Last modified : 2024/12/30 (by Wen Jiahui)
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
// 2024/12/30 : Created
// 2024/XX/XX : 
//-----------------------------------------------------------------------------

//#
//# Module Declaration
//# ==================
//#



// *****************************************************************************
module xx_lsu_wb_arbiter(
    input logic lda0_arb_data_req_dp,  // wire to lda_lwb_ex3_data_req_dp
    input logic lsda0_arb_data_req_dp, // wire to lsda0_lswb_ex3_data_req_dp
    input logic lsda1_arb_data_req_dp, // wire to lsda1_lswb_ex3_data_req_dp
    input logic wmb_ld_wb_data_req_pre, // now using wire wmb_lwb0_data_req
    input logic vmb_ld_wb_data_req_pre, // wire from vmb_ld_wb_data_req of wk_lsu_vmb
    input logic rb_ld_wb_data_req_pre,  // wire from rb_ld_wb_data_req of wk_lsu_rb

    input logic lda0_arb_cmplt_req, // wire from lda_lwb_ex3_cmplt_req
    input logic lsda0_arb_cmplt_req, // wire from lsda0_lswb_ex3_cmplt_req
    input logic lsda1_arb_cmplt_req, // wire from lsda1_lswb_ex3_cmplt_req
    input logic rb_ld_wb_cmplt_req_pre, // wire from rb_lwb_ex3_cmplt_req
    input logic wmb_lswb_cmplt_req_pre, // wire from wmb_lswb0_cmplt_req

    output logic arb_lwb0_rb_cmplt_req, // after arbiter, real rb cmplt req to lwb0, replace original rb_lwb_ex3_cmplt_req
    output logic arb_lswb0_rb_cmplt_req, // now wire to rb_lswb_ex3_cmplt_req port of wk_lsu_ls_wb_wrapper0
    output logic arb_lswb1_rb_cmplt_req, // now wire to rb_lswb_ex3_cmplt_req port of wk_lsu_ls_wb_wrapper1
    output logic arb_lswb0_wmb_cmplt_req, // replace wmb_lswb0_cmplt_req
    output logic arb_lswb1_wmb_cmplt_req, // replace wmb_lswb1_cmplt_req
    output logic arb_rb_cmplt_grnt, // replace original ld_wb_rb_cmplt_grnt from lwb to rb
    output logic arb_wmb_cmplt_grnt, // lswb1_wmb_ex3_cmplt_grnt

    output logic arb_lwb0_wmb_data_req, // after arbiter, real wmb data req to lwb0, replace original wmb_lwb0_data_req
    output logic arb_lswb0_wmb_data_req,  // now replacing wmb_lswb0_data_req
    output logic arb_lswb1_wmb_data_req, // now replacing wmb_lswb1_data_req
    output logic arb_lwb0_vmb_data_req, // after arbiter, real vmb data req to lwb0, replace original vmb_ld_wb_data_req
    output logic arb_lswb0_vmb_data_req, // now wire to vmb_lswb_ex3_data_req port of wk_lsu_ls_wb_wrapper0
    output logic arb_lswb1_vmb_data_req, // now wire to vmb_lswb_ex3_data_req port of wk_lsu_ls_wb_wrapper1
    output logic arb_lwb0_rb_data_req,  // after arbiter, real rb data req to lwb0, replace original rb_ld_wb_data_req
    output logic arb_lswb0_rb_data_req, // now wire to rb_lswb_ex3_data_req port of wk_lsu_ls_wb_wrapper0
    output logic arb_lswb1_rb_data_req, // now wire to rb_lswb_ex3_data_req port of wk_lsu_ls_wb_wrapper1
    output logic arb_wmb_data_grnt, // replace original ld_wb_wmb_data_grnt from lwb to wmb
    output logic arb_vmb_data_grnt, // replace original ld_wb_vmb_data_grnt from lwb to vmb
    output logic arb_rb_data_grnt  // replace original ld_wb_rb_data_grnt from lwb to rb
);
    
    
    // data_req arbiter for wmb
    assign arb_lwb0_wmb_data_req = !lda0_arb_data_req_dp
                                   && wmb_ld_wb_data_req_pre;
    assign arb_lswb0_wmb_data_req = lda0_arb_data_req_dp
                                 && !lsda0_arb_data_req_dp 
                                 && wmb_ld_wb_data_req_pre;
    assign arb_lswb1_wmb_data_req = lda0_arb_data_req_dp
                                 && lsda0_arb_data_req_dp
                                 && !lsda1_arb_data_req_dp 
                                 && wmb_ld_wb_data_req_pre;
    assign arb_wmb_data_grnt = arb_lwb0_wmb_data_req
                            || arb_lswb0_wmb_data_req
                            || arb_lswb1_wmb_data_req;
    // data_req arbiter for vmb
    assign arb_lwb0_vmb_data_req = !lda0_arb_data_req_dp
                                   && !wmb_ld_wb_data_req_pre
                                   && vmb_ld_wb_data_req_pre;
    
    assign arb_lswb0_vmb_data_req = vmb_ld_wb_data_req_pre
                                    && !lsda0_arb_data_req_dp 
                                    && (lda0_arb_data_req_dp ^ wmb_ld_wb_data_req_pre);
                                    // && (lda0_arb_data_req_dp && !wmb_ld_wb_data_req_pre
                                    //     || !lda0_arb_data_req_dp && wmb_ld_wb_data_req_pre);
    
    assign arb_lswb1_vmb_data_req = vmb_ld_wb_data_req_pre
                                    && !lsda1_arb_data_req_dp 
                                    && (lda0_arb_data_req_dp && (lsda0_arb_data_req_dp ) && !wmb_ld_wb_data_req_pre
                                        || lda0_arb_data_req_dp && !lsda0_arb_data_req_dp  && wmb_ld_wb_data_req_pre
                                        || !lda0_arb_data_req_dp && (lsda0_arb_data_req_dp ) && wmb_ld_wb_data_req_pre);

    assign arb_vmb_data_grnt = arb_lwb0_vmb_data_req
                            || arb_lswb0_vmb_data_req
                            || arb_lswb1_vmb_data_req;
    // data_req arbiter for rb
    assign arb_lwb0_rb_data_req = rb_ld_wb_data_req_pre
                                  && !lda0_arb_data_req_dp
                                  && !wmb_ld_wb_data_req_pre
                                  && !vmb_ld_wb_data_req_pre;
    
    assign arb_lswb0_rb_data_req = rb_ld_wb_data_req_pre
                                   && !lsda0_arb_data_req_dp 
                                   && (lda0_arb_data_req_dp && !wmb_ld_wb_data_req_pre && !vmb_ld_wb_data_req_pre
                                       || !lda0_arb_data_req_dp && wmb_ld_wb_data_req_pre && !vmb_ld_wb_data_req_pre
                                       || !lda0_arb_data_req_dp && !wmb_ld_wb_data_req_pre && vmb_ld_wb_data_req_pre);
    assign arb_lswb1_rb_data_req = rb_ld_wb_data_req_pre
                                   && !lsda1_arb_data_req_dp 
                                   && (lda0_arb_data_req_dp && (lsda0_arb_data_req_dp ) && !wmb_ld_wb_data_req_pre && !vmb_ld_wb_data_req_pre
                                       || lda0_arb_data_req_dp && !lsda0_arb_data_req_dp  && wmb_ld_wb_data_req_pre && !vmb_ld_wb_data_req_pre
                                       || lda0_arb_data_req_dp && !lsda0_arb_data_req_dp  && !wmb_ld_wb_data_req_pre && vmb_ld_wb_data_req_pre
                                       || !lda0_arb_data_req_dp && (lsda0_arb_data_req_dp ) && wmb_ld_wb_data_req_pre && !vmb_ld_wb_data_req_pre
                                       || !lda0_arb_data_req_dp && (lsda0_arb_data_req_dp ) && !wmb_ld_wb_data_req_pre && vmb_ld_wb_data_req_pre
                                       || !lda0_arb_data_req_dp && !lsda0_arb_data_req_dp  && wmb_ld_wb_data_req_pre && vmb_ld_wb_data_req_pre);

    assign arb_rb_data_grnt = arb_lwb0_rb_data_req
                           || arb_lswb0_rb_data_req
                           || arb_lswb1_rb_data_req;

    // cmplt arbiter
    assign arb_lswb0_wmb_cmplt_req = wmb_lswb_cmplt_req_pre
                                     && !lsda0_arb_cmplt_req;
    assign arb_lswb1_wmb_cmplt_req = wmb_lswb_cmplt_req_pre
                                     && !lsda1_arb_cmplt_req
                                     && (lsda0_arb_cmplt_req);
    assign arb_wmb_cmplt_grnt = wmb_lswb_cmplt_req_pre && !(lsda0_arb_cmplt_req && lsda1_arb_cmplt_req);

    
    // rb cmplt outputs
    assign arb_lwb0_rb_cmplt_req = rb_ld_wb_cmplt_req_pre && !lda0_arb_cmplt_req;
    assign arb_lswb0_rb_cmplt_req = rb_ld_wb_cmplt_req_pre 
                                    && !lsda0_arb_cmplt_req && !wmb_lswb_cmplt_req_pre
                                    && lda0_arb_cmplt_req;

    assign arb_lswb1_rb_cmplt_req = rb_ld_wb_cmplt_req_pre
                                    && !lsda1_arb_cmplt_req
                                    && lda0_arb_cmplt_req
                                    && (lsda0_arb_cmplt_req && !wmb_lswb_cmplt_req_pre
                                        || !lsda0_arb_cmplt_req && wmb_lswb_cmplt_req_pre);

    // assign arb_rb_cmplt_grnt = rb_ld_wb_cmplt_req_pre && !( lda0_arb_cmplt_req && lsda0_arb_cmplt_req && lsda1_arb_cmplt_req);
    assign arb_rb_cmplt_grnt = arb_lwb0_rb_cmplt_req
                            || arb_lswb0_rb_cmplt_req
                            || arb_lswb1_rb_cmplt_req;

endmodule