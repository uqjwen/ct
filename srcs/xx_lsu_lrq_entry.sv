//-----------------------------------------------------------------------------
// File          : xx_lsu_lrq_entry.v
// Created       : 2025/03/24 (by Wen Jiahui)
// Last modified : 2025/03/24 (by Wen Jiahui)
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
// 2024/03/24 : Created
// 2024/XX/XX : 
//-----------------------------------------------------------------------------

//#
//# Module Declaration
//# ==================
//#
module xx_lsu_lrq_entry #(
    parameter PREG = 7,
    parameter VREG = 6,
    parameter IID_WIDTH = 10,
    parameter VMBENTRY = 8,
    parameter LRQENTRY = 12,
    parameter PC_LEN = 15,
    parameter LRQ_WIDTH = 0,
    parameter SDIQENTRY = 12
)(
input logic                 cpurst_b,
input logic                 forever_cpuclk,
input logic                 lsu_special_clk,
input logic                 cp0_lsu_icg_en,
input logic                 pad_yy_icg_scan_en,
input logic                 rtu_lsu_flush_fe,
input logic                 rtu_ck_flush,
input logic [IID_WIDTH-1:0] rtu_ck_flush_iid,

input logic [63:0]              lrq_create_va,
// input logic                     lrq_create_frz,
input logic                     lrq_create_wait_old_chk,
input logic                     lrq_create_bar_chk,
input logic                     lrq_create_no_spec_chk,
input logic [3*LRQENTRY-1:0]    lrq_create_no_spec_target,
input logic [15:0]              lrq_create_bytes_vld,
input logic [15:0]              lrq_create_bytes_vld1,
input logic [15:0]              lrq_create_bytes_vld2,
input logic [15:0]              lrq_create_bytes_vld3,
input logic [15:0]              lrq_create_reg_bytes_vld,
input logic [15:0]              lrq_create_reg_bytes_vld1,
input logic [15:0]              lrq_create_reg_bytes_vld2,
input logic [15:0]              lrq_create_reg_bytes_vld3,
input logic                     lrq_create_boundary,
input logic                     lrq_create_atomic,
input logic [IID_WIDTH-1:0]     lrq_create_iid,
input logic                     lrq_create_fls,
input logic                     lrq_create_fof,
input logic [1:0]               lrq_create_size,
input logic [1:0]               lrq_create_type,
input logic                     lrq_create_vls,
input logic                     lrq_create_lsfifo,
input logic [PC_LEN-1:0]        lrq_create_pc,
input logic [PREG-1:0]          lrq_create_preg,
input logic                     lrq_create_sext,
input logic                     lrq_create_split,
input logic [8:0]               lrq_create_split_num,
input logic                     lrq_create_unit_stride,
// input logic [1:0]               lrq_create_vlmul,
input logic [2:0]               lrq_create_vlmul,  //pwh 1 for rvv1.0
input logic [3:0]               lrq_create_vls_size,
input logic [VMBENTRY-1:0]      lrq_create_vmb_id,
input logic                     lrq_create_vmb_merge_vld,
input logic [VREG-1:0]          lrq_create_vreg,
//input logic [1:0]               lrq_create_vsew,
input logic [1:0]               lrq_create_vmew,
input logic [1:0]               lrq_create_vmop,
input logic                     lrq_create_nf,
input logic                     lrq_create_4kstall,
input logic                     lrq_create_is_load,
input logic [3:0]               lrq_create_fence_mode,
input logic                     lrq_create_icc,
input logic                     lrq_create_idx_ord,
input logic                     lrq_create_inst_flush,
input logic [1:0]               lrq_create_inst_mode,
input logic                     lrq_create_inst_share,
input logic                     lrq_create_inst_str,
input logic                     lrq_create_mmu_req,
input logic [SDIQENTRY-1:0]     lrq_create_sdiq_entry,
input logic                     lrq_create_st,
input logic                     lrq_create_staddr,
input logic                     lrq_create_sync_fence,
input logic                      lsu_lrq_ex1_pa_set,
input logic [`WK_PA_WIDTH-13:0]  lsu_lrq_ex1_pa,
input logic [4:0]                lsu_lrq_ex1_attr,
input logic [IID_WIDTH-1:0]      lsu_lrq_ex1_iid,
input logic [IID_WIDTH-1:0]      idu_lrq_rf_iid,

// input logic                     lrq_ex1_pa_set, // to set the pa
// input logic [`WK_PA_WIDTH-13:0] lrq_ex1_pa, // 
// input logic [4:0]               lrq_ex1_attr,

input logic                      lsu_lrq_frz_clr,
input logic                      lrq_entry_create_vld,
input logic                      lrq_entry_create_frz,
// input logic                 lrq_create_vld0, // including other creations
// input logic                 lrq_create_vld2, // including other creations
// input logic                 lrq_create_vld3, // including other creations
input logic [IID_WIDTH-1:0]      lrq_create_iid0, // iid correspondings to the creating entry
input logic [IID_WIDTH-1:0]      lrq_create_iid2, // iid correspondings to the creating entry
input logic [IID_WIDTH-1:0]      lrq_create_iid3, // iid correspondings to the creating entry
input logic [LRQENTRY-1:0]       lrq_create_ptr0,
input logic [LRQENTRY-1:0]       lrq_create_ptr2,
input logic [LRQENTRY-1:0]       lrq_create_ptr3,
// input logic [IID_WIDTH-1:0]      lrq_create_iid, // iid correspondings to the creating entry
input logic [LRQENTRY-1:0]       lrq_create_ptr,
// input logic [LRQENTRY-1:0]  lrq_entry_create_agevec,
input logic [LRQENTRY-1:0]       lrq_entry_create_local_agevec,
input logic [3*LRQENTRY-1:0]     lrq_entry_create_global_agevec,
input logic                      lrq_local_agevec_updt_vld,
input logic                      lrq_global_agevec_updt_vld,
input logic                      lrq_entry_pop_vld, // pop current entry
input logic [LRQENTRY-1:0]       lrq_local_pop_vld_b, // pop entries vector
input logic [3*LRQENTRY-1:0]     lrq_global_pop_vld_b, // pop entries vector
input logic                      lrq_entry_issue_grnt,
// input logic                      lrq_create_bar_chk,
input logic                      lrq_bar_mode,
input logic [3*LRQENTRY-1:0]     lrq_oth_bar,
input logic [3*LRQENTRY-1:0]     lrq_oth_aft_load,
input logic [3*LRQENTRY-1:0]     lrq_oth_aft_store,
input logic [3*LRQENTRY-1:0]     lrq_oth_issued,
input logic [3*LRQENTRY-1:0]     lrq_oth_load,
input logic [3*LRQENTRY-1:0]     lrq_oth_store,
input logic                      lsu_lrq_ex2_lq_full, 
input logic                      lsu_lrq_ex2_lq_not_full,
input logic                      lsu_lrq_ex2_sq_full, 
input logic                      lsu_lrq_exx_sq_not_full,
input logic                      lsu_lrq_ex3_rb_full, 
input logic                      lsu_lrq_ex3_rb_not_full,
input logic                      lsu_lrq_ex1_wait_old, 
input logic                      lsu_lrq_ex3_wait_fence, 
input logic                      lsu_lrq_exx_no_fence,
input logic                      lsu_lrq_ex2_tlb_busy, 
input logic                      lsu_lrq_exx_tlb_wakeup,
input logic                      lsu_lrq_ex3_secd, 
input logic                      lsu_lrq_ex3_already_da, 
input logic                      lsu_lrq_ex3_spec_fail, 
input logic [LRQENTRY-1:0]       rdy_pre_vec,
input logic                      lrq_older_than_lsiq, // the oldest one is in lrq
input logic [PC_LEN-1:0]         sfp_lsu0_no_spec_dst_pc, // from sfp
input logic [PC_LEN-1:0]         sfp_lsu2_no_spec_dst_pc, // from sfp
input logic [PC_LEN-1:0]         sfp_lsu3_no_spec_dst_pc, // from sfp
output logic                     lrq_rdy_older_ex1, // wjh@timing
output logic                     lrq_rdy_older_idu,  // wjh@timing
output logic [LRQ_WIDTH-1:0]     lrq_read_data,

output logic                     lrq_entry_vld_x,
output logic                     lrq_entry_create_agevec0_x,
output logic                     lrq_entry_create_agevec2_x,
output logic                     lrq_entry_create_agevec3_x,
output logic                     lrq_entry_aft_load_x,
output logic                     lrq_entry_aft_store_x,
output logic                     lrq_entry_load_x,
output logic                     lrq_entry_store_x,
output logic                     lrq_entry_issued_x,
output logic                     lrq_old_vld_x,
output logic                     rdy_pre_x,
output logic                     lsu0_no_spec_target_x,
output logic                     lsu2_no_spec_target_x,
output logic                     lsu3_no_spec_target_x,
output logic                     rdy_x
);


// parameter LRQ_WIDTH = LRQ_ALREADY_DA+1;
parameter LRQ_ATTR          = 5 - 1;
parameter LRQ_PA            = LRQ_ATTR + `WK_PA_PAGE_NUM_WIDTH;
parameter LRQ_PA_VLD        = LRQ_PA + 1;
parameter LRQ_SYNC_FENCE    = LRQ_PA_VLD + 1;
parameter LRQ_STADDR        = LRQ_SYNC_FENCE + 1;
parameter LRQ_ST            = LRQ_STADDR + 1;
parameter LRQ_SDIQ_ENTRY    = LRQ_ST + SDIQENTRY;
parameter LRQ_MMU_REQ       = LRQ_SDIQ_ENTRY + 1;
parameter LRQ_INST_STR      = LRQ_MMU_REQ + 1;
parameter LRQ_INST_SHARE    = LRQ_INST_STR + 1;
parameter LRQ_INST_MODE     = LRQ_INST_SHARE + 2;
parameter LRQ_INST_FLUSH    = LRQ_INST_MODE + 1;
parameter LRQ_IDX_ORD       = LRQ_INST_FLUSH + 1;
parameter LRQ_ICC           = LRQ_IDX_ORD + 1;
parameter LRQ_FENCE_MODE    = LRQ_ICC + 4;
parameter LRQ_IS_LOAD       = LRQ_FENCE_MODE + 1;
parameter LRQ_VMEW          = LRQ_IS_LOAD + 2;
parameter LRQ_VMOP          = LRQ_VMEW + 2;
parameter LRQ_NF          = LRQ_VMOP + 1;
parameter LRQ_VREG          = LRQ_NF + VREG;
parameter LRQ_VMB_MERGE_VLD = LRQ_VREG + 1;
parameter LRQ_VMB_ID        = LRQ_VMB_MERGE_VLD + VMBENTRY;
parameter LRQ_VLS_SIZE      = LRQ_VMB_ID + 4;
// parameter LRQ_VLMUL         = LRQ_VLS_SIZE + 2;
parameter LRQ_VLMUL         = LRQ_VLS_SIZE + 3;  //pwh 2 for rvv1.0
parameter LRQ_UNIT_STRIDE   = LRQ_VLMUL + 1;
parameter LRQ_UNAL2ND       = LRQ_UNIT_STRIDE + 1;
parameter LRQ_SPLIT_NUM     = LRQ_UNAL2ND + 9;
parameter LRQ_SPLIT         = LRQ_SPLIT_NUM + 1;
parameter LRQ_SPEC_FAIL     = LRQ_SPLIT + 1;
parameter LRQ_SEXT          = LRQ_SPEC_FAIL + 1;
parameter LRQ_PREG          = LRQ_SEXT + PREG;
parameter LRQ_PC            = LRQ_PREG + PC_LEN;
parameter LRQ_LSFIFO        = LRQ_PC + 1;
parameter LRQ_OLDEST        = LRQ_LSFIFO + 1;
parameter LRQ_INST_VLS      = LRQ_OLDEST + 1;
parameter LRQ_INST_TYPE     = LRQ_INST_VLS + 2;
parameter LRQ_INST_SIZE     = LRQ_INST_TYPE + 2;
parameter LRQ_INST_FOF      = LRQ_INST_SIZE + 1;
parameter LRQ_INST_FLS      = LRQ_INST_FOF + 1;
parameter LRQ_IID           = LRQ_INST_FLS + IID_WIDTH;
parameter LRQ_BKPTB_DATA    = LRQ_IID + 1;
parameter LRQ_BKPTA_DATA    = LRQ_BKPTB_DATA + 1;
parameter LRQ_ATOMIC        = LRQ_BKPTA_DATA + 1;
parameter LRQ_ALREADY_DA    = LRQ_ATOMIC + 1;
parameter LRQ_VA            = LRQ_ALREADY_DA + 64;
parameter LRQ_BOUNDARY      = LRQ_VA + 1;
parameter LRQ_REG_BYTES_VLD = LRQ_BOUNDARY + 16;
parameter LRQ_REG_BYTES_VLD1 = LRQ_REG_BYTES_VLD + 16;
parameter LRQ_REG_BYTES_VLD2 = LRQ_REG_BYTES_VLD1 + 16;
parameter LRQ_REG_BYTES_VLD3 = LRQ_REG_BYTES_VLD2 + 16;
parameter LRQ_BYTES_VLD      = LRQ_REG_BYTES_VLD3 + 16;
parameter LRQ_BYTES_VLD1     = LRQ_BYTES_VLD + 16;
parameter LRQ_BYTES_VLD2     = LRQ_BYTES_VLD1 + 16;
parameter LRQ_BYTES_VLD3     = LRQ_BYTES_VLD2 + 16;
parameter LRQ_NOSPEC_EXIST   = LRQ_BYTES_VLD3 + 1;
// logic [LRQ_WIDTH-1:0]     lrq_read_data;
logic [15:0]              lrq_entry_bytes_vld;
logic [15:0]              lrq_entry_bytes_vld1;
logic [15:0]              lrq_entry_bytes_vld2;
logic [15:0]              lrq_entry_bytes_vld3;
logic [15:0]              lrq_entry_reg_bytes_vld;
logic [15:0]              lrq_entry_reg_bytes_vld1;
logic [15:0]              lrq_entry_reg_bytes_vld2;
logic [15:0]              lrq_entry_reg_bytes_vld3;
logic                     lrq_entry_boundary;
logic [63:0]              lrq_entry_va;
logic                     lrq_entry_already_da;
logic                     lrq_entry_atomic;
logic [IID_WIDTH-1:0]     lrq_entry_iid;
logic                     lrq_entry_inst_fls;
logic                     lrq_entry_inst_fof;
logic [1:0]               lrq_entry_inst_size;
logic [1:0]               lrq_entry_inst_type;
logic                     lrq_entry_inst_vls;
logic                     lrq_entry_lsfifo;
logic [PC_LEN-1:0]        lrq_entry_pc;
logic [PREG-1:0]          lrq_entry_preg;
logic                     lrq_entry_sext;
logic                     lrq_entry_spec_fail;
logic                     lrq_entry_split;
logic [8:0]               lrq_entry_split_num;
logic                     lrq_entry_unal2nd;
logic                     lrq_entry_unit_stride;
// logic [1:0]               lrq_entry_vlmul;
logic [2:0]               lrq_entry_vlmul;  //pwh 3 for rvv1.0
logic [3:0]               lrq_entry_vls_size;
logic [VMBENTRY-1:0]      lrq_entry_vmb_id;
logic                     lrq_entry_vmb_merge_vld;
logic [VREG-1:0]          lrq_entry_vreg;
//logic [1:0]               lrq_entry_vsew;
logic [1:0]               lrq_entry_vmew;
logic [1:0]               lrq_entry_vmop;
logic                     lrq_entry_nf;
logic                     lrq_entry_is_load; // specialized for store inst
logic  [3:0]              lrq_entry_fence_mode;
logic                     lrq_entry_icc;
logic                     lrq_entry_idx_ord;
logic                     lrq_entry_inst_flush;
logic  [1:0]              lrq_entry_inst_mode;
logic                     lrq_entry_inst_share;
logic                     lrq_entry_inst_str;
logic                     lrq_entry_mmu_req;
logic  [SDIQENTRY-1:0]    lrq_entry_sdiq_entry;
logic                     lrq_entry_st;
logic                     lrq_entry_staddr;
logic                     lrq_entry_sync_fence;

logic                     lrq_entry_pa_vld;
logic [`WK_PA_WIDTH-13:0] lrq_entry_pa;
logic [4:0]               lrq_entry_attr;
logic                     lrq_entry_vld;
logic [LRQENTRY-1:0]      lrq_entry_local_agevec;
logic [3*LRQENTRY-1:0]    lrq_entry_global_agevec;
logic [LRQENTRY-1:0]      lrq_entry_local_agevec_next;
logic [3*LRQENTRY-1:0]    lrq_entry_global_agevec_next;
logic [3*LRQENTRY-1:0]    lrq_entry_no_spec_target;
// logic                 lrq_entry_agevec_updt;
logic                     lrq_entry_iid_newer_than_rf0;
logic                     lrq_entry_iid_newer_than_rf2;
logic                     lrq_entry_iid_newer_than_rf3;
logic                     lrq_entry_iid_newer_than_local_rf;
logic                     rdy_pre;
logic                     rdy;
logic                     old; // global old
logic                     lrq_local_old;
logic                     lrq_global_old;

logic                     lq_full;
logic                     lq_full_wakeup;
logic                     sq_full;
logic                     sq_full_wakeup;
logic                     rb_full;
logic                     rb_full_wakeup;
logic                     wait_old;
logic                     wait_old_wakeup;
logic                     tlb_busy;
logic                     wait_fence;
logic                     lrq_frz_clr;
logic                     lrq_entry_frz;
logic                     bar_chk;
logic                     bar_chk_wakeup;
logic                     lrq_entry_load;
logic                     lrq_entry_store;
logic                     lrq_entry_bar;
logic                     lrq_entry_bef_store;
logic                     lrq_entry_bef_load;
logic                     no_spec_chk;
logic                     no_spec_wakeup;
logic                     lrq_entry_ldr_imme_stall;
logic                     no_spec_exist;
logic                     lrq_older_ex1; // wjh@timing
logic                     lrq_older_idu;  // wjh@timing
// logic                 lrq_entry_pipe0;
// logic                 lrq_entry_pipe2;
// logic                 lrq_entry_pipe3;
logic                     rtu_ck_flush_iid_older_entry_iid;
logic                     lrq_entry_clk;
logic                     lrq_entry_clk_en;
logic                     lrq_entry_create_clk;
logic                     lrq_entry_create_clk_en;
//==========================================================
//                 Instance of Gated Cell  
//==========================================================
//-----------entry gateclk--------------
//normal gateclk ,open when create || entry_vld
assign lrq_entry_clk_en = lrq_entry_vld | lrq_entry_create_vld;
gated_clk_cell  x_lsu_lrq_entry_gated_clk (
  .clk_in             (lsu_special_clk   ),
  .clk_out            (lrq_entry_clk     ),
  .external_en        (1'b0              ),
  .local_en           (lrq_entry_clk_en  ),
  .module_en          (cp0_lsu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

assign lrq_entry_create_clk_en = lrq_entry_create_vld;
gated_clk_cell  x_lsu_lrq_entry_gated_clk_1 (
  .clk_in             (lsu_special_clk         ),
  .clk_out            (lrq_entry_create_clk    ),
  .external_en        (1'b0                    ),
  .local_en           (lrq_entry_create_clk_en ),
  .module_en          (cp0_lsu_icg_en          ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en      )
);

always @(posedge lrq_entry_create_clk or negedge cpurst_b)
begin 
    if(!cpurst_b) begin 
        // lrq_entry_va            <= {64{1'b0}};
        lrq_entry_bytes_vld     <= {16{1'b0}};
        lrq_entry_bytes_vld1    <= {16{1'b0}};
        lrq_entry_reg_bytes_vld <= {16{1'b0}};
        lrq_entry_boundary      <= 1'b0;
        lrq_entry_atomic        <= 1'b0;
        lrq_entry_iid           <= {IID_WIDTH{1'b0}};
        lrq_entry_inst_fls      <= 1'b0;
        lrq_entry_inst_fof      <= 1'b0;
        lrq_entry_inst_size     <= 2'b00;
        lrq_entry_inst_type     <= 2'b00;
        lrq_entry_inst_vls      <= 1'b0;
        lrq_entry_lsfifo        <= 1'b0;
        lrq_entry_pc            <= {PC_LEN{1'b0}};
        lrq_entry_preg          <= {PREG{1'b0}};
        lrq_entry_sext          <= 1'b0;
        lrq_entry_split         <= 1'b0;
        lrq_entry_split_num     <= {9{1'b0}};
        lrq_entry_unit_stride   <= 1'b0;
        // lrq_entry_vlmul         <= {2{1'b0}};
        lrq_entry_vlmul         <= {3{1'b0}};        
        lrq_entry_vls_size      <= {4{1'b0}};
        lrq_entry_vmb_id        <= {VMBENTRY{1'b0}};
        lrq_entry_vmb_merge_vld <= 1'b0;
        lrq_entry_vreg          <= {VREG{1'b0}};
        //lrq_entry_vsew          <= {2{1'b0}};
        lrq_entry_vmew          <= {2{1'b0}};
        lrq_entry_vmop          <= {2{1'b0}};
        lrq_entry_nf            <=  1'b0;
        lrq_entry_is_load       <= 1'b0;
        lrq_entry_fence_mode    <= {4{1'b0}};
        lrq_entry_icc           <= 1'b0;
        lrq_entry_idx_ord       <= 1'b0;
        lrq_entry_inst_flush    <= 1'b0;
        lrq_entry_inst_mode     <= {2{1'b0}};
        lrq_entry_inst_share    <= 1'b0;
        lrq_entry_inst_str      <= 1'b0;
        lrq_entry_mmu_req       <= 1'b0;
        lrq_entry_sdiq_entry    <= {SDIQENTRY{1'b0}};
        lrq_entry_st            <= 1'b0;
        lrq_entry_staddr        <= 1'b0;
        lrq_entry_sync_fence    <= 1'b0;
        lrq_entry_no_spec_target<= {3*LRQENTRY{1'b0}};
        // lrq_entry_pipe0         <= 1'b0;
        // lrq_entry_pipe2         <= 1'b0;
        // lrq_entry_pipe3         <= 1'b0;
    end 

    else if(lrq_entry_create_vld)begin 
        // lrq_entry_va            <= lrq_create_va;
        lrq_entry_bytes_vld     <= lrq_create_bytes_vld;
        lrq_entry_bytes_vld1    <= lrq_create_bytes_vld1;
        lrq_entry_reg_bytes_vld <= lrq_create_reg_bytes_vld;
        lrq_entry_boundary      <= lrq_create_boundary;
        lrq_entry_atomic        <= lrq_create_atomic;
        lrq_entry_iid           <= lrq_create_iid;
        lrq_entry_inst_fls      <= lrq_create_fls;
        lrq_entry_inst_fof      <= lrq_create_fof;
        lrq_entry_inst_size     <= lrq_create_size;
        lrq_entry_inst_type     <= lrq_create_type;
        lrq_entry_inst_vls      <= lrq_create_vls;
        lrq_entry_lsfifo        <= lrq_create_lsfifo;
        lrq_entry_pc            <= lrq_create_pc;
        lrq_entry_preg          <= lrq_create_preg;
        lrq_entry_sext          <= lrq_create_sext;
        lrq_entry_split         <= lrq_create_split;
        lrq_entry_split_num     <= lrq_create_split_num;
        lrq_entry_unit_stride   <= lrq_create_unit_stride;
        lrq_entry_vlmul         <= lrq_create_vlmul;
        lrq_entry_vls_size      <= lrq_create_vls_size;
        lrq_entry_vmb_id        <= lrq_create_vmb_id;
        lrq_entry_vmb_merge_vld <= lrq_create_vmb_merge_vld;
        lrq_entry_vreg          <= lrq_create_vreg;
        //lrq_entry_vsew          <= lrq_create_vsew;
        lrq_entry_vmew          <= lrq_create_vmew;
        lrq_entry_vmop          <= lrq_create_vmop;
        lrq_entry_nf            <= lrq_create_nf;
        lrq_entry_is_load       <= lrq_create_is_load;                    
        lrq_entry_fence_mode    <= lrq_create_fence_mode;                       
        lrq_entry_icc           <= lrq_create_icc;                
        lrq_entry_idx_ord       <= lrq_create_idx_ord;                    
        lrq_entry_inst_flush    <= lrq_create_inst_flush;                       
        lrq_entry_inst_mode     <= lrq_create_inst_mode;                      
        lrq_entry_inst_share    <= lrq_create_inst_share;                       
        lrq_entry_inst_str      <= lrq_create_inst_str;                     
        lrq_entry_mmu_req       <= lrq_create_mmu_req;                    
        lrq_entry_sdiq_entry    <= lrq_create_sdiq_entry;                       
        lrq_entry_st            <= lrq_create_st;               
        lrq_entry_staddr        <= lrq_create_staddr;                   
        lrq_entry_sync_fence    <= lrq_create_sync_fence;                       
        lrq_entry_no_spec_target<= lrq_create_no_spec_target;
        // lrq_entry_pipe0         <= 1'b0;
        // lrq_entry_pipe2         <= 1'b1;
        // lrq_entry_pipe3         <= 1'b0;
    end 

end 

always @(posedge lrq_entry_create_clk or negedge cpurst_b)begin 
    if(!cpurst_b)begin 
        lrq_entry_bytes_vld2    <= {16{1'b0}};
        lrq_entry_bytes_vld3    <= {16{1'b0}};
        lrq_entry_reg_bytes_vld1<= {16{1'b0}};
        lrq_entry_reg_bytes_vld2<= {16{1'b0}};
        lrq_entry_reg_bytes_vld3<= {16{1'b0}};
    end
    else if(lrq_entry_create_vld & lrq_create_unit_stride & lrq_create_vls)begin 
        lrq_entry_bytes_vld2    <= lrq_create_bytes_vld2;
        lrq_entry_bytes_vld3    <= lrq_create_bytes_vld3;
        lrq_entry_reg_bytes_vld1<= lrq_create_reg_bytes_vld1;
        lrq_entry_reg_bytes_vld2<= lrq_create_reg_bytes_vld2;
        lrq_entry_reg_bytes_vld3<= lrq_create_reg_bytes_vld3;
    end
end
// sequential logic
// vld
always @(posedge forever_cpuclk or negedge cpurst_b)begin 
    if(!cpurst_b)
        lrq_entry_vld <= 1'b0;
    else if(rtu_lsu_flush_fe)
        lrq_entry_vld <= 1'b0;
    else if(lrq_entry_vld && rtu_ck_flush && rtu_ck_flush_iid_older_entry_iid)   //flush younger vld entry, ck_flush@LTL
        lrq_entry_vld <= 1'b0;
    else if(lrq_entry_create_vld)
        lrq_entry_vld <= 1'b1;
    else if(lrq_entry_pop_vld)
        lrq_entry_vld <= 1'b0;
end 
// va
always @(posedge forever_cpuclk or negedge cpurst_b)begin 
    if(!cpurst_b)
        lrq_entry_va <= {64{1'b0}};
//    else if(lrq_entry_create_vld && lrq_create_4kstall)
//        lrq_entry_va <= lrq_create_va + 64'd16;
    else if(lrq_entry_create_vld)
        lrq_entry_va <= lrq_create_va;
    else if(lrq_entry_ldr_imme_stall)
        lrq_entry_va <= lrq_entry_va + 64'd16;
    else if(lsu_lrq_ex3_secd && lrq_entry_is_load && !lrq_entry_unit_stride)
        lrq_entry_va <= {lrq_entry_va[63:4] - 1'b1, lrq_entry_va[3:0]};
    else if(lsu_lrq_ex3_secd && lrq_entry_is_load && lrq_entry_unit_stride)
        lrq_entry_va <= lrq_entry_va + 64'd64;
    else if(lsu_lrq_ex3_secd && !lrq_entry_is_load)
        lrq_entry_va <= lrq_entry_va + 64'd16;
end 

// ldr_imme_stall 
always @(posedge forever_cpuclk or negedge cpurst_b)begin 
    if(!cpurst_b)
        lrq_entry_ldr_imme_stall <= 1'b0;
    else if(lrq_entry_create_vld)
        lrq_entry_ldr_imme_stall <= lrq_create_4kstall;
    else if(lrq_entry_vld)
        lrq_entry_ldr_imme_stall <= 1'b0;
end
// agevec
always @(posedge forever_cpuclk or negedge cpurst_b) begin 
    if(!cpurst_b)
        lrq_entry_local_agevec <= {LRQENTRY{1'b0}};
    else if(lrq_entry_create_vld)
        lrq_entry_local_agevec <= lrq_entry_create_local_agevec; 
    else if(lrq_local_agevec_updt_vld)
        lrq_entry_local_agevec <= lrq_entry_local_agevec_next;
end 

always @(posedge forever_cpuclk or negedge cpurst_b) begin 
    if(!cpurst_b)
        lrq_entry_global_agevec <= {3*LRQENTRY{1'b0}};
    else if(lrq_entry_create_vld)
        lrq_entry_global_agevec <= lrq_entry_create_global_agevec;
    else if(lrq_global_agevec_updt_vld && lrq_entry_vld)
        lrq_entry_global_agevec <= lrq_entry_global_agevec_next;
end 

xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH))
x_lsu_lrq_entry_compare_flush_iid(
    .x_iid0       ( rtu_ck_flush_iid              ),
    .x_iid0_older ( rtu_ck_flush_iid_older_entry_iid        ),
    .x_iid1       ( lrq_entry_iid                 )
);
xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH))
x_lsu_lrq_entry_compare_iid0(
    .x_iid0       ( lrq_create_iid0               ),
    .x_iid0_older ( lrq_entry_iid_newer_than_rf0  ),
    .x_iid1       ( lrq_entry_iid                 )
);

xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH))
x_lsu_lrq_entry_compare_iid2(
    .x_iid0       ( lrq_create_iid2               ),
    .x_iid0_older ( lrq_entry_iid_newer_than_rf2  ),
    .x_iid1       ( lrq_entry_iid                 )
);

xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH))
x_lsu_lrq_entry_compare_iid3(
    .x_iid0       ( lrq_create_iid3               ),
    .x_iid0_older ( lrq_entry_iid_newer_than_rf3  ),
    .x_iid1       ( lrq_entry_iid                 )
);

xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH))
x_lsu_lrq_entry_compare_local_iid0(
    .x_iid0       ( lrq_create_iid               ),
    .x_iid0_older ( lrq_entry_iid_newer_than_local_rf  ),
    .x_iid1       ( lrq_entry_iid                 )
);
// wjh@timing
xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH))
x_lsu_lrq_entry_compare_ex1(
    .x_iid0       ( lrq_entry_iid  ),
    .x_iid0_older ( lrq_older_ex1  ),
    .x_iid1       ( lsu_lrq_ex1_iid)
);
xx_lsu_compare_iid #(.IID_WIDTH(IID_WIDTH))
x_lsu_lrq_entry_compare_rf(
    .x_iid0       ( lrq_entry_iid ),
    .x_iid0_older ( lrq_older_idu ),
    .x_iid1       ( idu_lrq_rf_iid)
);
assign lrq_rdy_older_ex1 = lrq_entry_vld && lrq_older_ex1 && !lrq_entry_frz;
assign lrq_rdy_older_idu = lrq_entry_vld && lrq_older_idu && !lrq_entry_frz;
// extend here to support three pipe lines
assign lrq_entry_local_agevec_next = (lrq_entry_local_agevec
                                  | ({LRQENTRY{lrq_entry_iid_newer_than_local_rf}} & lrq_create_ptr))
                                  & lrq_local_pop_vld_b
                                  ; // unmask the poping entry

assign lrq_entry_global_agevec_next = (lrq_entry_global_agevec
                               | ({{2*LRQENTRY{1'b0}}, {LRQENTRY{lrq_entry_iid_newer_than_rf0}} & lrq_create_ptr0})
                               | ({{LRQENTRY{1'b0}}, {LRQENTRY{lrq_entry_iid_newer_than_rf2}} & lrq_create_ptr2, {LRQENTRY{1'b0}}})
                               | ({{LRQENTRY{lrq_entry_iid_newer_than_rf3}} & lrq_create_ptr3, {2*LRQENTRY{1'b0}}})
                               )
                               & lrq_global_pop_vld_b
                               ; // unmask the poping entry

assign lrq_entry_create_agevec0_x = lrq_entry_vld
                                    && !lrq_entry_iid_newer_than_rf0
                                    && !lrq_entry_pop_vld;
assign lrq_entry_create_agevec2_x = lrq_entry_vld
                                    && !lrq_entry_iid_newer_than_rf2
                                    && !lrq_entry_pop_vld;
assign lrq_entry_create_agevec3_x = lrq_entry_vld
                                    && !lrq_entry_iid_newer_than_rf3
                                    && !lrq_entry_pop_vld;

// old
assign lrq_local_old = !(|lrq_entry_local_agevec);
assign lrq_global_old = !(|lrq_entry_global_agevec);
// assign lrq_entry_oldest_x = lrq_global_old;
assign old = lrq_older_than_lsiq && lrq_global_old;
// lq_full
always @(posedge forever_cpuclk or negedge cpurst_b) begin 
    if(!cpurst_b)
        lq_full <= 1'b0;
    else if(rtu_lsu_flush_fe)
        lq_full <= 1'b0;
    else if(lrq_entry_vld && rtu_ck_flush && rtu_ck_flush_iid_older_entry_iid)  //flush younger vld entry, ck_flush@LTL
        lq_full <= 1'b0;
    else if(lsu_lrq_ex2_lq_full && lrq_entry_vld)
        lq_full <= 1'b1;
    else if(lq_full_wakeup)
        lq_full <= 1'b0;
end 
assign lq_full_wakeup = lsu_lrq_ex2_lq_not_full || old;
// sq_full
always @(posedge forever_cpuclk or negedge cpurst_b) begin 
    if(!cpurst_b)
        sq_full <= 1'b0;
    else if(rtu_lsu_flush_fe)
        sq_full <= 1'b0;
    else if(lrq_entry_vld && rtu_ck_flush && rtu_ck_flush_iid_older_entry_iid)  //flush younger vld entry, ck_flush@LTL
        sq_full <= 1'b0;
    else if(lsu_lrq_ex2_sq_full && lrq_entry_vld)
        sq_full <= 1'b1;
    else if(sq_full_wakeup)
        sq_full <= 1'b0;
end 
assign sq_full_wakeup = lsu_lrq_exx_sq_not_full || old;
// rb_full
always @(posedge forever_cpuclk or negedge cpurst_b) begin 
    if(!cpurst_b)
        rb_full <= 1'b0;
    else if(rtu_lsu_flush_fe)
        rb_full <= 1'b0;
    else if(lrq_entry_vld && rtu_ck_flush && rtu_ck_flush_iid_older_entry_iid)  //flush younger vld entry, ck_flush@LTL
        rb_full <= 1'b0;
    else if(lsu_lrq_ex3_rb_full && lrq_entry_vld)
        rb_full <= 1'b1;
    else if(rb_full_wakeup)
        rb_full <= 1'b0;
end 
assign rb_full_wakeup = lsu_lrq_ex3_rb_not_full || old;
// wait_old
always @(posedge forever_cpuclk or negedge cpurst_b) begin 
    if(!cpurst_b)
        wait_old <= 1'b0;
    else if(rtu_lsu_flush_fe)
        wait_old <= 1'b0;
    else if(lrq_entry_vld && rtu_ck_flush && rtu_ck_flush_iid_older_entry_iid)  //flush younger vld entry, ck_flush@LTL
        wait_old <= 1'b0;
    else if(lrq_entry_create_vld)
        wait_old <= lrq_create_wait_old_chk;
    else if(lsu_lrq_ex1_wait_old && lrq_entry_vld)
        wait_old <= 1'b1;
    else if(wait_old_wakeup)
        wait_old <= 1'b0;
end 
assign wait_old_wakeup = old;

//
// wait fence
always @(posedge forever_cpuclk or negedge cpurst_b) begin 
    if(!cpurst_b)
        wait_fence <= 1'b0;
    else if(rtu_lsu_flush_fe)
        wait_fence <= 1'b0;
    else if(lrq_entry_vld && rtu_ck_flush && rtu_ck_flush_iid_older_entry_iid)  //flush younger vld entry, ck_flush@LTL
        wait_fence <= 1'b0;
    else if(lsu_lrq_ex3_wait_fence && lrq_entry_vld)
        wait_fence <= 1'b1;
    else if(lsu_lrq_exx_no_fence)
        wait_fence <= 1'b0;
end 

// tlb_busy
always @(posedge forever_cpuclk or negedge cpurst_b) begin 
    if(!cpurst_b)
        tlb_busy <= 1'b0;
    else if(rtu_lsu_flush_fe)
        tlb_busy <= 1'b0;
    else if(lrq_entry_vld && rtu_ck_flush && rtu_ck_flush_iid_older_entry_iid)  //flush younger vld entry, ck_flush@LTL
        tlb_busy <= 1'b0;
    else if(lsu_lrq_ex2_tlb_busy && lrq_entry_vld)
        tlb_busy <= 1'b1;
    else if(lsu_lrq_exx_tlb_wakeup)
        tlb_busy <= 1'b0;
end

always @(posedge forever_cpuclk or negedge cpurst_b) begin 
    if(!cpurst_b)
        bar_chk <= 1'b0;
    else if(rtu_lsu_flush_fe)
        bar_chk <= 1'b0;
    else if(lrq_entry_vld && rtu_ck_flush && rtu_ck_flush_iid_older_entry_iid)  //flush younger vld entry, ck_flush@LTL
        bar_chk <= 1'b0;
    else if(lrq_entry_create_vld)
        bar_chk <= lrq_create_bar_chk;
    else if(bar_chk_wakeup && lrq_entry_vld)
        bar_chk <= 1'b0;
end

always @(posedge forever_cpuclk or negedge cpurst_b)begin 
    if(!cpurst_b)
        no_spec_exist <= 1'b0;
    else if(rtu_lsu_flush_fe)
        no_spec_exist <= 1'b0;
    else if(lrq_entry_vld && rtu_ck_flush && rtu_ck_flush_iid_older_entry_iid)  //flush younger vld entry, ck_flush@LTL
        no_spec_exist <= 1'b0;
    else if(lrq_entry_create_vld)
        no_spec_exist <= lrq_create_no_spec_chk;
end

always @(posedge forever_cpuclk or negedge cpurst_b) begin 
    if(!cpurst_b)
        no_spec_chk <= 1'b0;
    else if(rtu_lsu_flush_fe)
        no_spec_chk <= 1'b0;
    else if(lrq_entry_vld && rtu_ck_flush && rtu_ck_flush_iid_older_entry_iid)  //flush younger vld entry, ck_flush@LTL
        no_spec_chk <= 1'b0;
    else if(lrq_entry_create_vld)
        no_spec_chk <= lrq_create_no_spec_chk;
    else if(no_spec_wakeup && lrq_entry_vld)
        no_spec_chk <= 1'b0;
end
// assign no_spec_chk = 1'b0;
// bar logic
// fence mode has different decoding from bar_type
assign lrq_entry_aft_store_x = lrq_entry_fence_mode[3];
assign lrq_entry_aft_load_x  = lrq_entry_fence_mode[1];
assign lrq_entry_bef_store   = lrq_entry_fence_mode[2];
assign lrq_entry_bef_load    = lrq_entry_fence_mode[0];
assign lrq_entry_load  = lrq_entry_is_load;
assign lrq_entry_store = !lrq_entry_is_load && !lrq_entry_sync_fence;
assign lrq_entry_load_x = lrq_entry_load;
assign lrq_entry_store_x = lrq_entry_store;
assign lrq_entry_bar   = !lrq_entry_is_load && lrq_entry_sync_fence;

assign bar_chk_wakeup = !lrq_bar_mode
                        || lrq_entry_load  && !(|(lrq_oth_bar    & lrq_entry_global_agevec    & lrq_oth_aft_load & ( ~lrq_oth_issued | lrq_oth_aft_store)))
                        || lrq_entry_store && !(|(lrq_oth_bar    & lrq_entry_global_agevec    & lrq_oth_aft_store))
                        || lrq_entry_bar   && (!(|(lrq_oth_load  & lrq_entry_global_agevec)) && lrq_entry_bef_load  || !lrq_entry_bef_load)
                                           && (!(|(lrq_oth_store & lrq_entry_global_agevec)) && lrq_entry_bef_store || !lrq_entry_bef_store )
                                           && !(|(lrq_oth_bar    & lrq_entry_global_agevec));

assign no_spec_wakeup = lrq_entry_load && !(|(lrq_entry_no_spec_target 
                                              & lrq_entry_global_agevec));

assign lrq_entry_issued_x = lrq_entry_frz && !bar_chk && !no_spec_chk;

assign lrq_frz_clr = (lq_full || sq_full || rb_full || tlb_busy
                   || wait_old|| wait_fence || bar_chk || no_spec_chk)
                   && (!lq_full     || lq_full     && lq_full_wakeup)
                   && (!sq_full     || sq_full     && sq_full_wakeup)
                   && (!rb_full     || rb_full     && rb_full_wakeup)
                   && (!wait_old    || wait_old    && wait_old_wakeup)
                   && (!wait_fence  || wait_fence  && lsu_lrq_exx_no_fence)
                   && (!tlb_busy    || tlb_busy    && lsu_lrq_exx_tlb_wakeup)
                   && (!bar_chk     || bar_chk     && bar_chk_wakeup)
                   && (!no_spec_chk || no_spec_chk && no_spec_wakeup);

always @(posedge forever_cpuclk or negedge cpurst_b)begin 
    if(!cpurst_b)
        lrq_entry_already_da             <= 1'b0;
    else if(lrq_entry_create_vld)
        lrq_entry_already_da             <= 1'b0;
    else if(lsu_lrq_ex3_secd)
        lrq_entry_already_da             <= 1'b0;
    else if(lsu_lrq_ex3_already_da)
        lrq_entry_already_da             <= 1'b1;
end 

always @(posedge forever_cpuclk or negedge cpurst_b)begin 
    if(!cpurst_b)
        lrq_entry_unal2nd <= 1'b0;
    else if(lrq_entry_create_vld)
        lrq_entry_unal2nd <= 1'b0;
    else if(lsu_lrq_ex3_secd)
        lrq_entry_unal2nd <= 1'b1;
end 

always @(posedge forever_cpuclk or negedge cpurst_b)begin 
    if(!cpurst_b)
        lrq_entry_spec_fail <= 1'b0;
    else if(lrq_entry_create_vld)
        lrq_entry_spec_fail <= 1'b0;
    else if(lsu_lrq_ex3_spec_fail)
        lrq_entry_spec_fail <= 1'b1;
end 

// freeze
always @(posedge forever_cpuclk or negedge cpurst_b)begin 
    if(!cpurst_b)
        lrq_entry_frz <= 1'b0;
    else if(lrq_entry_frz && rtu_ck_flush && lsu_lrq_frz_clr)            //when ck_flush and frz_clr same cycle, crz <= 0@LTL
        lrq_entry_frz <= 1'b0;
    else if(lrq_entry_create_vld && rtu_ck_flush && lsu_lrq_frz_clr)            //when ck_flush and create_vld same cycle, @LTL
        lrq_entry_frz <= 1'b0;
    else if(lrq_entry_create_vld)
        lrq_entry_frz <= lrq_entry_create_frz;
    else if(lrq_entry_issue_grnt)
        lrq_entry_frz <= 1'b1;
    else if(lrq_frz_clr || lsu_lrq_frz_clr)
        lrq_entry_frz <= 1'b0;
end 

// always @(posedge forever_cpuclk or negedge cpurst_b)begin 
//     if(!cpurst_b)
//         lrq_entry_pa_vld <= 1'b0;
//     else if(lrq_entry_create_vld && lsu_lrq_ex1_pa_set)
//         lrq_entry_pa_vld <= 1'b1;
//     else if(lrq_entry_create_vld)
//         lrq_entry_pa_vld <= 1'b0;
//     else if(lsu_lrq_ex1_pa_set)
//         lrq_entry_pa_vld <= 1'b1;
//     else if(lsu_lrq_ex3_secd)
//         lrq_entry_pa_vld <= 1'b0;
// end 

// always @(posedge forever_cpuclk or negedge cpurst_b)begin 
//     if(!cpurst_b)
//         lrq_entry_pa <= {`WK_PA_WIDTH-12{1'b0}};
//     else if(lsu_lrq_ex1_pa_set)
//         lrq_entry_pa <= lsu_lrq_ex1_pa;
// end 

// always @(posedge forever_cpuclk or negedge cpurst_b)begin 
//     if(!cpurst_b)
//         lrq_entry_attr <= {5{1'b0}};
//     else if(lsu_lrq_ex1_pa_set)
//         lrq_entry_attr <= lsu_lrq_ex1_attr;
// end 


assign rdy_pre_x = lrq_entry_vld && !lrq_entry_frz;

// assign rdy_pre0_x = lrq_entry_vld && !lrq_entry_frz && lrq_entry_pipe0;
// assign rdy_pre2_x = lrq_entry_vld && !lrq_entry_frz && lrq_entry_pipe2;
// assign rdy_pre3_x = lrq_entry_vld && !lrq_entry_frz && lrq_entry_pipe3;

assign rdy_x = rdy_pre_x && !(|(lrq_entry_local_agevec & rdy_pre_vec));


assign lsu0_no_spec_target_x = (lrq_entry_pc == sfp_lsu0_no_spec_dst_pc) 
                               && lrq_entry_vld;
                            //    && !lrq_entry_pop_vld; // exclude lrq_entry_pop_vld for timing, as it has a long history
assign lsu2_no_spec_target_x = (lrq_entry_pc == sfp_lsu2_no_spec_dst_pc)
                               && lrq_entry_vld; 
                            //    && !lrq_entry_pop_vld;
assign lsu3_no_spec_target_x = (lrq_entry_pc == sfp_lsu3_no_spec_dst_pc)
                               && lrq_entry_vld; 
                            //    && !lrq_entry_pop_vld;
assign lrq_read_data[LRQ_NOSPEC_EXIST] =                         no_spec_exist;
assign lrq_read_data[LRQ_BYTES_VLD3:LRQ_BYTES_VLD3-16+1] =       lrq_entry_bytes_vld3;
assign lrq_read_data[LRQ_BYTES_VLD2:LRQ_BYTES_VLD2-16+1] =       lrq_entry_bytes_vld2;
assign lrq_read_data[LRQ_BYTES_VLD1:LRQ_BYTES_VLD1-16+1] =       lrq_entry_bytes_vld1;
assign lrq_read_data[LRQ_BYTES_VLD:LRQ_BYTES_VLD-16+1] =         lrq_entry_unal2nd & ~(lrq_entry_unit_stride & lrq_entry_is_load)?lrq_entry_bytes_vld1:lrq_entry_bytes_vld;
assign lrq_read_data[LRQ_REG_BYTES_VLD3:LRQ_REG_BYTES_VLD3-16+1] = lrq_entry_reg_bytes_vld3;
assign lrq_read_data[LRQ_REG_BYTES_VLD2:LRQ_REG_BYTES_VLD2-16+1] = lrq_entry_reg_bytes_vld2;
assign lrq_read_data[LRQ_REG_BYTES_VLD1:LRQ_REG_BYTES_VLD1-16+1] = lrq_entry_reg_bytes_vld1;
assign lrq_read_data[LRQ_REG_BYTES_VLD:LRQ_REG_BYTES_VLD-16+1] = lrq_entry_reg_bytes_vld;
assign lrq_read_data[LRQ_BOUNDARY] =                             lrq_entry_boundary;
assign lrq_read_data[LRQ_VA:LRQ_VA-64+1] =                       lrq_entry_ldr_imme_stall
                                                                 ? lrq_entry_va+64'd16 
                                                                 : lrq_entry_va;
assign lrq_read_data[LRQ_ALREADY_DA] =                           lrq_entry_already_da;
assign lrq_read_data[LRQ_ATOMIC] =                               lrq_entry_atomic;
assign lrq_read_data[LRQ_BKPTA_DATA] =                           1'b0;
assign lrq_read_data[LRQ_BKPTB_DATA] =                           1'b0;
assign lrq_read_data[LRQ_IID:LRQ_IID-IID_WIDTH+1] =              lrq_entry_iid;
assign lrq_read_data[LRQ_INST_FLS] =                             lrq_entry_inst_fls;
assign lrq_read_data[LRQ_INST_FOF] =                             lrq_entry_inst_fof;
assign lrq_read_data[LRQ_INST_SIZE:LRQ_INST_SIZE-2+1] =          lrq_entry_inst_size;
assign lrq_read_data[LRQ_INST_TYPE:LRQ_INST_TYPE-2+1] =          lrq_entry_inst_type;
assign lrq_read_data[LRQ_INST_VLS] =                             lrq_entry_inst_vls;
assign lrq_read_data[LRQ_LSFIFO] =                               lrq_entry_lsfifo;
assign lrq_read_data[LRQ_OLDEST] =                               old;
assign lrq_read_data[LRQ_PC:LRQ_PC-PC_LEN+1] =                   lrq_entry_pc;
assign lrq_read_data[LRQ_PREG:LRQ_PREG-PREG+1] =                 lrq_entry_preg;
assign lrq_read_data[LRQ_SEXT] =                                 lrq_entry_sext;
assign lrq_read_data[LRQ_SPEC_FAIL] =                            lrq_entry_spec_fail;
assign lrq_read_data[LRQ_SPLIT] =                                lrq_entry_split;
assign lrq_read_data[LRQ_SPLIT_NUM:LRQ_SPLIT_NUM-9+1] =          lrq_entry_split_num;
assign lrq_read_data[LRQ_UNAL2ND] =                              lrq_entry_unal2nd;
assign lrq_read_data[LRQ_UNIT_STRIDE] =                          lrq_entry_unit_stride;
// assign lrq_read_data[LRQ_VLMUL:LRQ_VLMUL-2+1] =                  lrq_entry_vlmul;
assign lrq_read_data[LRQ_VLMUL:LRQ_VLMUL-2] =                    lrq_entry_vlmul;
assign lrq_read_data[LRQ_VLS_SIZE:LRQ_VLS_SIZE-4+1] =            lrq_entry_vls_size;
assign lrq_read_data[LRQ_VMB_ID:LRQ_VMB_ID-VMBENTRY+1] =         lrq_entry_vmb_id;
assign lrq_read_data[LRQ_VMB_MERGE_VLD] =                        lrq_entry_vmb_merge_vld;
assign lrq_read_data[LRQ_VREG:LRQ_VREG-VREG+1] =                  lrq_entry_vreg;                               
//assign lrq_read_data[LRQ_VSEW:LRQ_VSEW-2+1] =                     lrq_entry_vsew;   
assign lrq_read_data[LRQ_VMEW:LRQ_VMEW-2+1] =                     lrq_entry_vmew; 
assign lrq_read_data[LRQ_VMOP:LRQ_VMOP-2+1] =                     lrq_entry_vmop;  
assign lrq_read_data[LRQ_NF]                =                     lrq_entry_nf;                        
assign lrq_read_data[LRQ_IS_LOAD] =                               lrq_entry_is_load;                  
assign lrq_read_data[LRQ_FENCE_MODE:LRQ_FENCE_MODE-4+1] =         lrq_entry_fence_mode;                                        
assign lrq_read_data[LRQ_ICC] =                                   lrq_entry_icc;              
assign lrq_read_data[LRQ_IDX_ORD] =                               lrq_entry_idx_ord;                  
assign lrq_read_data[LRQ_INST_FLUSH] =                            lrq_entry_inst_flush;                     
assign lrq_read_data[LRQ_INST_MODE:LRQ_INST_MODE-2+1] =           lrq_entry_inst_mode;                                      
assign lrq_read_data[LRQ_INST_SHARE] =                            lrq_entry_inst_share;                     
assign lrq_read_data[LRQ_INST_STR] =                              lrq_entry_inst_str;                   
assign lrq_read_data[LRQ_MMU_REQ] =                               lrq_entry_mmu_req;                  
assign lrq_read_data[LRQ_SDIQ_ENTRY:LRQ_SDIQ_ENTRY-SDIQENTRY+1] = lrq_entry_sdiq_entry;                                                
assign lrq_read_data[LRQ_ST] =                                    lrq_entry_st;             
assign lrq_read_data[LRQ_STADDR] =                                lrq_entry_staddr;                 
assign lrq_read_data[LRQ_SYNC_FENCE] =                            lrq_entry_sync_fence;                     
assign lrq_read_data[LRQ_PA_VLD] =                                1'b0;
assign lrq_read_data[LRQ_PA:LRQ_PA-`WK_PA_PAGE_NUM_WIDTH+1] =     {`WK_PPN_WIDTH{1'b0}};
assign lrq_read_data[LRQ_ATTR:LRQ_ATTR-5+1] =                     5'b0;


assign lrq_entry_vld_x           = lrq_entry_vld;
assign lrq_old_vld_x             = lrq_entry_vld && lrq_global_old;

endmodule
