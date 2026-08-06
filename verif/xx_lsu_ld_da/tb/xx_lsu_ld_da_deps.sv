`timescale 1ns/1ps



// Standalone compatibility models; production replacement remains PENDING_FULL_CHIP.

module gated_clk_cell (
  input logic clk_in, input logic external_en, input logic local_en,
  input logic module_en, input logic pad_yy_icg_scan_en, output logic clk_out
);
  always_comb clk_out = clk_in & (pad_yy_icg_scan_en | (module_en & (external_en | local_en)));
endmodule

module xx_lsu_compare_iid #(parameter int IID_WIDTH = 7) (
  input logic [IID_WIDTH-1:0] x_iid0, input logic [IID_WIDTH-1:0] x_iid1,
  output logic x_iid0_older
);
  logic [IID_WIDTH-1:0] distance;
  always_comb begin distance = x_iid1 - x_iid0; x_iid0_older = (x_iid0 != x_iid1) && !distance[IID_WIDTH-1]; end
endmodule

module xx_lsu_rot_data (
  input logic [127:0] data_in, input logic [15:0] rot_sel,
  output logic [127:0] data_settle_out
);
  always_comb data_settle_out = data_in;
endmodule

module xx_lsu_27bit_2stage_ecc_decode (
  input logic cpurst_b, input logic [26:0] data_decode,
  input logic ecc_stage_vld, input logic stage_dp_clk,
  output logic [21:0] corrected_data, output logic ham_error,
  output logic parity_error
);
  always_comb begin corrected_data = data_decode[21:0]; ham_error = 1'b0; parity_error = 1'b0; end
endmodule

module xx_lsu_35bit_2stage_ecc_decode (
  input logic cpurst_b, input logic [34:0] data_decode,
  input logic ecc_stage_vld, input logic stage_dp_clk,
  output logic [28:0] corrected_data, output logic ham_error,
  output logic parity_error
);
  always_comb begin corrected_data = data_decode[28:0]; ham_error = 1'b0; parity_error = 1'b0; end
endmodule

module xx_lsu_32bit_ecc_decode (
  input logic [38:0] data_decode, output logic [31:0] corrected_data,
  output logic ham_error, output logic parity_error
);
  always_comb begin corrected_data = data_decode[31:0]; ham_error = 1'b0; parity_error = 1'b0; end
endmodule
