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
