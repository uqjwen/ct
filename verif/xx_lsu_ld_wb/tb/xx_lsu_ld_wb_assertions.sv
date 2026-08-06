`timescale 1ns/1ps

module xx_lsu_ld_wb_assertions (
  input logic clk,
  input logic reset_n,
  input logic fp01_qualify,
  input logic fp01_observe,
  input logic fp02_qualify,
  input logic fp02_observe,
  input logic fp03_qualify,
  input logic fp03_observe,
  input logic fp04_qualify,
  input logic fp04_observe,
  input logic fp05_qualify,
  input logic fp05_observe,
  input logic fp06_qualify,
  input logic fp06_observe,
  input logic fp07_qualify,
  input logic fp07_observe,
  input logic fp08_qualify,
  input logic fp08_observe,
  input logic fp09_qualify,
  input logic [RBENTRY-1:0] fp09_observe,
  input logic fp10_qualify,
  input logic fp10_observe,
  input logic fp11_qualify,
  input logic fp11_observe,
  input logic fp12_qualify,
  input logic fp12_observe
);

  default clocking cb @(posedge clk); endclocking
  default disable iff (!reset_n);

  CHK_WB_FP01_CMPLT_ARB:
    assert property ((|fp01_qualify) |-> !$isunknown(fp01_observe));
  COV_WB_FP01_CMPLT:
    cover property ((|fp01_qualify) ##1 !$isunknown(fp01_observe));

  CHK_WB_FP02_DATA_ARB:
    assert property ((|fp02_qualify) |-> !$isunknown(fp02_observe));
  COV_WB_FP02_DATA:
    cover property ((|fp02_qualify) ##1 !$isunknown(fp02_observe));

  CHK_WB_FP03_REQ_DP_GATE:
    assert property ((|fp03_qualify) |-> !$isunknown(fp03_observe));
  COV_WB_FP03_REQ:
    cover property ((|fp03_qualify) ##1 !$isunknown(fp03_observe));

  CHK_WB_FP04_SCALAR:
    assert property ((|fp04_qualify) |-> !$isunknown(fp04_observe));
  COV_WB_FP04_SCALAR:
    cover property ((|fp04_qualify) ##1 !$isunknown(fp04_observe));

  CHK_WB_FP05_VECTOR:
    assert property ((|fp05_qualify) |-> !$isunknown(fp05_observe));
  COV_WB_FP05_VECTOR:
    cover property ((|fp05_qualify) ##1 !$isunknown(fp05_observe));

  CHK_WB_FP06_RTU:
    assert property ((|fp06_qualify) |-> !$isunknown(fp06_observe));
  COV_WB_FP06_RTU:
    cover property ((|fp06_qualify) ##1 !$isunknown(fp06_observe));

  CHK_WB_FP07_BUS_ERROR:
    assert property ((|fp07_qualify) |-> !$isunknown(fp07_observe));
  COV_WB_FP07_BUS_ERROR:
    cover property ((|fp07_qualify) ##1 !$isunknown(fp07_observe));

  CHK_WB_FP08_VMB:
    assert property ((|fp08_qualify) |-> !$isunknown(fp08_observe));
  COV_WB_FP08_VMB:
    cover property ((|fp08_qualify) ##1 !$isunknown(fp08_observe));

  CHK_WB_FP09_DEBUG:
    assert property ((|fp09_qualify) |-> !$isunknown(fp09_observe));
  COV_WB_FP09_DEBUG:
    cover property ((|fp09_qualify) ##1 !$isunknown(fp09_observe));

  CHK_WB_FP10_FORWARD:
    assert property ((|fp10_qualify) |-> !$isunknown(fp10_observe));
  COV_WB_FP10_FORWARD:
    cover property ((|fp10_qualify) ##1 !$isunknown(fp10_observe));

  CHK_WB_FP11_FLUSH:
    assert property ((|fp11_qualify) |-> !$isunknown(fp11_observe));
  COV_WB_FP11_FLUSH:
    cover property ((|fp11_qualify) ##1 !$isunknown(fp11_observe));

  CHK_WB_FP12_CLOCK_RESET:
    assert property ((|fp12_qualify) |-> !$isunknown(fp12_observe));
  COV_WB_FP12_CLOCK:
    cover property ((|fp12_qualify) ##1 !$isunknown(fp12_observe));

endmodule
