`timescale 1ns/1ps

// Verification-only dependency models. They are sufficient to isolate AG
// control/data selection, but they are not substitutes for production helper
// verification.

module gated_clk_cell (
  input  logic clk_in,
  input  logic external_en,
  input  logic local_en,
  input  logic module_en,
  input  logic pad_yy_icg_scan_en,
  output logic clk_out
);
  always_comb begin
    clk_out = clk_in
            & (pad_yy_icg_scan_en | (module_en & (external_en | local_en)));
  end
endmodule

module xx_lsu_compare_iid #(
  parameter int IID_WIDTH = 7
) (
  input  logic [IID_WIDTH-1:0] x_iid0,
  input  logic [IID_WIDTH-1:0] x_iid1,
  output logic                 x_iid0_older
);
  logic [IID_WIDTH-1:0] distance;
  always_comb begin
    distance = x_iid1 - x_iid0;
    x_iid0_older = (x_iid0 != x_iid1) && !distance[IID_WIDTH-1];
  end
endmodule

module xx_lsu_vmask_gen (
  input  logic [2:0]   ag_nf,
  input  logic         ag_nf58,
  input  logic [8:0]   ag_split_cnt,
  input  logic         ag_us,
  input  logic [1:0]   ag_us_sel,
  input  logic [7:0]   ag_vl,
  input  logic         ag_vmask_vld,
  input  logic [1:0]   ag_vmew,
  input  logic         ag_vmew64,
  output logic [8:0]   ag_vmsk_elemnt_cnt,
  input  logic [6:0]   cp0_lsu_vstart,
  input  logic [511:0] vector_mask_full,
  output logic [15:0]  vmask_byte_sel
);
  integer index;
  integer element_bytes;
  integer first_element;
  integer global_element;
  logic mask_bit;
  always_comb begin
    element_bytes = 1 << ag_vmew;
    ag_vmsk_elemnt_cnt = ag_us
                       ? (ag_split_cnt << (4 - ag_vmew))
                       : ag_split_cnt;
    first_element = ag_us_sel * (16 / element_bytes);
    vmask_byte_sel = '0;
    for (index = 0; index < 16; index = index + 1) begin
      global_element = first_element + (index / element_bytes);
      mask_bit = !ag_vmask_vld || vector_mask_full[global_element];
      if ((global_element >= cp0_lsu_vstart)
          && (global_element < ag_vl)
          && mask_bit)
        vmask_byte_sel[index] = 1'b1;
    end
  end
endmodule

module xx_lsu_vreg_mask (
  input  logic [2:0]   ag_nf,
  input  logic         ag_nf58,
  input  logic [8:0]   ag_split_cnt,
  input  logic         ag_us,
  input  logic [1:0]   ag_us_sel,
  input  logic [7:0]   ag_vl,
  input  logic         ag_vmask_vld,
  input  logic [1:0]   ag_vmew,
  input  logic [8:0]   ag_vmsk_elemnt_cnt,
  output logic [8:0]   ag_vmsk_reg_cnt,
  input  logic [6:0]   cp0_lsu_vstart,
  output logic [15:0]  reg_bytes_vld,
  input  logic [511:0] vector_mask_full
);
  integer index;
  always_comb begin
    ag_vmsk_reg_cnt = ag_vmsk_elemnt_cnt + ag_us_sel;
    reg_bytes_vld = '0;
    for (index = 0; index < 16; index = index + 1)
      if ((index + ag_us_sel * 16) < ag_vl)
        reg_bytes_vld[index] = !ag_vmask_vld
                             || vector_mask_full[index + ag_us_sel * 16];
  end
endmodule

module xx_lsu_us_bytes_gen (
  input  logic        ag_secd,
  input  logic        ag_replay_vld,
  input  logic [5:0]  ag_va_ori,
  input  logic [15:0] vmask_byte_sel,
  input  logic [15:0] vmask_byte_sel1,
  input  logic [15:0] vmask_byte_sel2,
  input  logic [15:0] vmask_byte_sel3,
  input  logic [15:0] lrq_bytes_vld,
  input  logic [15:0] lrq_bytes_vld1,
  input  logic [15:0] lrq_bytes_vld2,
  input  logic [15:0] lrq_bytes_vld3,
  output logic [63:0] lag_us_bytes_vld
);
  logic [63:0] selected;
  always_comb begin
    selected = ag_replay_vld
             ? {lrq_bytes_vld3, lrq_bytes_vld2,
                lrq_bytes_vld1, lrq_bytes_vld}
             : {vmask_byte_sel3, vmask_byte_sel2,
                vmask_byte_sel1, vmask_byte_sel};
    if (ag_secd)
      lag_us_bytes_vld = selected >> (64 - ag_va_ori);
    else
      lag_us_bytes_vld = selected << ag_va_ori;
  end
endmodule

module xx_lsu_ld_vreg_rot (
  input  logic [2:0] ag_nf,
  input  logic       ag_nf58,
  input  logic [8:0] ag_split_cnt,
  input  logic       ag_us,
  input  logic [1:0] ag_vmew,
  input  logic [8:0] ag_vmsk_elemnt_cnt,
  input  logic [8:0] ag_vmsk_reg_cnt,
  output logic [3:0] reg_element_rot
);
  always_comb begin
    reg_element_rot = ag_vmsk_reg_cnt[3:0];
  end
endmodule
