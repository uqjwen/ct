`timescale 1ns/1ps

module xx_lsu_ld_da_assertions (
  input logic clk,
  input logic reset_n,
  input logic fp01_qualify,
  input logic [127:0] fp01_observe,
  input logic fp02_qualify,
  input logic [127:0] fp02_observe,
  input logic fp03_qualify,
  input logic fp03_observe,
  input logic fp04_qualify,
  input logic fp04_observe,
  input logic fp05_qualify,
  input logic [LQENTRY-1:0] fp05_observe,
  input logic fp06_qualify,
  input logic fp06_observe,
  input logic fp07_qualify,
  input logic fp07_observe,
  input logic fp08_qualify,
  input logic fp08_observe,
  input logic fp09_qualify,
  input logic fp09_observe,
  input logic fp10_qualify,
  input logic fp10_observe,
  input logic fp11_qualify,
  input logic [LSIQENTRY-1:0] fp11_observe,
  input logic fp12_qualify,
  input logic fp12_observe
);

  default clocking cb @(posedge clk); endclocking
  default disable iff (!reset_n);

  CHK_DA_FP01_DATA_SELECT:
    assert property ((|fp01_qualify) |-> !$isunknown(fp01_observe));
  COV_DA_FP01_DATA:
    cover property ((|fp01_qualify) ##1 !$isunknown(fp01_observe));

  CHK_DA_FP02_FORWARD:
    assert property ((|fp02_qualify) |-> !$isunknown(fp02_observe));
  COV_DA_FP02_FORWARD:
    cover property ((|fp02_qualify) ##1 !$isunknown(fp02_observe));

  CHK_DA_FP03_ECC:
    assert property ((|fp03_qualify) |-> !$isunknown(fp03_observe));
  COV_DA_FP03_ECC:
    cover property ((|fp03_qualify) ##1 !$isunknown(fp03_observe));

  CHK_DA_FP04_ACCESS_FAULT:
    assert property ((|fp04_qualify) |-> !$isunknown(fp04_observe));
  COV_DA_FP04_ACCESS_FAULT:
    cover property ((|fp04_qualify) ##1 !$isunknown(fp04_observe));

  CHK_DA_FP05_LQ_POP:
    assert property ((|fp05_qualify) |-> !$isunknown(fp05_observe));
  COV_DA_FP05_LQ_POP:
    cover property ((|fp05_qualify) ##1 !$isunknown(fp05_observe));

  CHK_DA_FP06_RB_OWNER:
    assert property ((|fp06_qualify) |-> !$isunknown(fp06_observe));
  COV_DA_FP06_RB:
    cover property ((|fp06_qualify) ##1 !$isunknown(fp06_observe));

  CHK_DA_FP07_COMPLETION:
    assert property ((|fp07_qualify) |-> !$isunknown(fp07_observe));
  COV_DA_FP07_COMPLETION:
    cover property ((|fp07_qualify) ##1 !$isunknown(fp07_observe));

  CHK_DA_FP08_DATA_REQ:
    assert property ((|fp08_qualify) |-> !$isunknown(fp08_observe));
  COV_DA_FP08_DATA:
    cover property ((|fp08_qualify) ##1 !$isunknown(fp08_observe));

  CHK_DA_FP09_TERMINAL:
    assert property ((|fp09_qualify) |-> !$isunknown(fp09_observe));
  COV_DA_FP09_TERMINAL:
    cover property ((|fp09_qualify) ##1 !$isunknown(fp09_observe));

  CHK_DA_FP10_WAKEUP:
    assert property ((|fp10_qualify) |-> !$isunknown(fp10_observe));
  COV_DA_FP10_WAKEUP:
    cover property ((|fp10_qualify) ##1 !$isunknown(fp10_observe));

  CHK_DA_FP11_DEBUG:
    assert property ((|fp11_qualify) |-> !$isunknown(fp11_observe));
  COV_DA_FP11_DEBUG:
    cover property ((|fp11_qualify) ##1 !$isunknown(fp11_observe));

  CHK_DA_FP12_FLUSH_CLOCK:
    assert property ((|fp12_qualify) |-> !$isunknown(fp12_observe));
  COV_DA_FP12_CLOCK:
    cover property ((|fp12_qualify) ##1 !$isunknown(fp12_observe));

endmodule
