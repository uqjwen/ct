`timescale 1ns/1ps



// Standalone compatibility models; production replacement remains PENDING_FULL_CHIP.

module gated_clk_cell (
  input logic clk_in, input logic external_en, input logic local_en,
  input logic module_en, input logic pad_yy_icg_scan_en, output logic clk_out
);
  always_comb clk_out = clk_in & (pad_yy_icg_scan_en | (module_en & (external_en | local_en)));
endmodule

module xx_lsu_lfb_data_entry (
  input logic [255:0] biu_lsu_r_data, input logic [1:0] biu_lsu_r_user,
  input logic biu_lsu_r_last, input logic biu_lsu_r_vld,
  input logic cp0_lsu_dcache_en, input logic cp0_lsu_icg_en, input logic cpurst_b,
  input logic [15:0] lfb_addr_entry_linefill_abort,
  input logic [15:0] lfb_addr_entry_linefill_permit,
  input logic [3:0] lfb_biu_id_2to0, input logic lfb_biu_r_id_hit,
  output logic [15:0] lfb_data_entry_addr_id_v,
  output logic [15:0] lfb_data_entry_addr_pop_req_v,
  input logic lfb_data_entry_create_dp_vld_x,
  input logic lfb_data_entry_create_gateclk_en_x,
  input logic lfb_data_entry_create_vld_x,
  output logic [511:0] lfb_data_entry_data_v,
  output logic lfb_data_entry_dcache_share_x,
  output logic lfb_data_entry_full_x, output logic [1:0] lfb_data_entry_rsrc_x,
  output logic lfb_data_entry_last_x, output logic lfb_data_entry_lf_sm_req_x,
  output logic lfb_data_entry_vld_x, output logic lfb_data_entry_wait_surplus_x,
  input logic [1:0] lfb_first_pass_ptr, input logic lfb_lf_sm_data_grnt_x,
  input logic lfb_lf_sm_data_pop_req_x, input logic lfb_r_resp_err,
  input logic lfb_r_resp_share, input logic lsu_special_clk,
  input logic pad_yy_icg_scan_en, input logic snq_lfb_bypass_chg_tag_x,
  input logic snq_lfb_bypass_invalid_x
);
  always_comb begin
    lfb_data_entry_addr_id_v = '0; lfb_data_entry_addr_pop_req_v = '0;
    lfb_data_entry_data_v = {biu_lsu_r_data, biu_lsu_r_data};
    lfb_data_entry_dcache_share_x = lfb_r_resp_share;
    lfb_data_entry_full_x = lfb_data_entry_create_vld_x;
    lfb_data_entry_rsrc_x = biu_lsu_r_user; lfb_data_entry_last_x = biu_lsu_r_last;
    lfb_data_entry_lf_sm_req_x = biu_lsu_r_last & biu_lsu_r_vld;
    lfb_data_entry_vld_x = lfb_data_entry_create_vld_x;
    lfb_data_entry_wait_surplus_x = 1'b0;
  end
endmodule

module xx_lsu_expand #(parameter int RBENTRY = 4) (
  input logic [$clog2(RBENTRY)-1:0] x_num, output logic [RBENTRY-1:0] x_num_expand
);
  always_comb begin x_num_expand = '0; x_num_expand[x_num] = 1'b1; end
endmodule

module xx_lsu_32bit_ecc_encode (
  input logic [31:0] data_encode,
  output logic [5:0] ecc_code, output logic parity_bit
);
  always_comb begin ecc_code = '0; parity_bit = ^data_encode; end
endmodule

module xx_lsu_27bit_ecc_encode (
  input logic [26:0] data_encode,
  output logic [5:0] ecc_code, output logic parity_bit
);
  always_comb begin ecc_code = '0; parity_bit = ^data_encode; end
endmodule

module xx_lsu_35bit_ecc_encode (
  input logic [34:0] data_encode,
  output logic [5:0] ecc_code, output logic parity_bit
);
  always_comb begin ecc_code = '0; parity_bit = ^data_encode; end
endmodule

module xx_lsu_30bit_ecc_encode (
  input logic [29:0] data_encode,
  output logic [5:0] ecc_code, output logic parity_bit
);
  always_comb begin ecc_code = '0; parity_bit = ^data_encode; end
endmodule

module xx_lsu_38bit_ecc_encode (
  input logic [37:0] data_encode,
  output logic [5:0] ecc_code, output logic parity_bit
);
  always_comb begin ecc_code = '0; parity_bit = ^data_encode; end
endmodule

module xx_lsu_pend_addr_sel_sv #(parameter int RBENTRY = 16) (
  input logic cp0_lsu_icg_en, input logic cpurst_b, input logic forever_cpuclk,
  input logic pad_yy_icg_scan_en, input logic [RBENTRY-1:0][`WK_PA_WIDTH-1:0] xxsource_entry_addr,
  input logic [RBENTRY-1:0] xxsource_entry_page_ca, input logic [RBENTRY-1:0] xxsource_entry_page_so,
  output logic xxsource_has_pend, output logic [`WK_PA_WIDTH-1:0] xxsource_pend_addr_f,
  output logic xxsource_pend_busy, input logic [RBENTRY-1:0] xxsource_pend_entry,
  output logic xxsource_pend_page_ca_f, output logic xxsource_pend_page_so_f
);
  always_comb begin xxsource_has_pend = |xxsource_pend_entry; xxsource_pend_busy = |xxsource_pend_entry; xxsource_pend_addr_f = '0; xxsource_pend_page_ca_f = 1'b0; xxsource_pend_page_so_f = 1'b0; end
endmodule
