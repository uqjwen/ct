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

module xx_lsu_rot_us_data (
  input logic [127:0] data_in0, input logic [127:0] data_in1,
  input logic [127:0] data_in2, input logic [127:0] data_in3,
  input logic [5:0] rot_sel, output logic [127:0] data_out0,
  output logic [127:0] data_out1, output logic [127:0] data_out2,
  output logic [127:0] data_out3
);
  always_comb begin data_out0 = data_in0; data_out1 = data_in1; data_out2 = data_in2; data_out3 = data_in3; end
endmodule

module xx_lsu_encode #(parameter int RBENTRY = 32) (
  output logic [4:0] x_num, input logic [RBENTRY-1:0] x_num_expand
);
  integer i;
  always_comb begin x_num = '0; for (i = 0; i < RBENTRY; i = i + 1) if (x_num_expand[i]) x_num = i[4:0]; end
endmodule

module xx_lsu_idfifo_32 #(parameter int IDFIFO_ENTRY = 32) (
  input logic cp0_lsu_icg_en, input logic cpurst_b, input logic forever_cpuclk,
  input logic idfifo_clk_en, input logic [4:0] idfifo_create_id,
  input logic [IDFIFO_ENTRY-1:0] idfifo_create_id_oh, input logic idfifo_create_vld,
  output logic idfifo_empty, output logic [IDFIFO_ENTRY-1:0] idfifo_pop_id_oh,
  input logic idfifo_pop_vld, input logic pad_yy_icg_scan_en
);
  always_comb begin idfifo_empty = !idfifo_create_vld; idfifo_pop_id_oh = idfifo_create_id_oh; end
endmodule

module xx_lsu_pend_addr_sel_32 #(parameter int RBENTRY = 32) (
  input logic cp0_lsu_icg_en, input logic cpurst_b, input logic forever_cpuclk,
  input logic pad_yy_icg_scan_en, input logic [RBENTRY-1:0][`WK_PA_WIDTH-1:0] xxsource_entry_addr,
  input logic [RBENTRY-1:0] xxsource_entry_page_ca, input logic [RBENTRY-1:0] xxsource_entry_page_so,
  output logic xxsource_has_pend, output logic [`WK_PA_WIDTH-1:0] xxsource_pend_addr_f,
  output logic xxsource_pend_busy, input logic [RBENTRY-1:0] xxsource_pend_entry,
  output logic xxsource_pend_page_ca_f, output logic xxsource_pend_page_so_f
);
  always_comb begin xxsource_has_pend = |xxsource_pend_entry; xxsource_pend_busy = |xxsource_pend_entry; xxsource_pend_addr_f = '0; xxsource_pend_page_ca_f = 1'b0; xxsource_pend_page_so_f = 1'b0; end
endmodule

module xx_lsu_rb_data (
  input logic [127:0] entry_data, input logic [15:0] entry_bytes_vld,
  input logic entry_inst_us, input logic entry_boundary, input logic entry_wait_data_ff,
  input logic ld0_create_vld_ff, input logic ld0_merge_vld_ff, input logic ld0_boundary_ff,
  input logic ls0_create_vld_ff, input logic ls0_merge_vld_ff, input logic ls0_boundary_ff,
  input logic ls1_create_vld_ff, input logic ls1_merge_vld_ff, input logic ls1_boundary_ff,
  input logic [127:0] ld0_data_ori, input logic [127:0] ls0_data_ori,
  input logic [127:0] ls1_data_ori, input logic [127:0] biu_data_ori,
  output logic [127:0] merge_data, output logic [127:0] data_aft_rev,
  output logic [127:0] biu_data_updt
);
  always_comb begin merge_data = ld0_data_ori | ls0_data_ori | ls1_data_ori; data_aft_rev = entry_data; biu_data_updt = biu_data_ori; end
endmodule
