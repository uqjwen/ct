`timescale 1ns/1ps

module xx_lsu_lrq_assertions (
  input logic clk,
  input logic reset_n,
  input logic fp01_qualify,
  input logic [LRQENTRY-1:0] fp01_observe,
  input logic fp02_qualify,
  input logic fp02_observe,
  input logic fp03_qualify,
  input logic [63:0] fp03_observe,
  input logic fp04_qualify,
  input logic fp04_observe,
  input logic [LRQENTRY-1:0] fp05_qualify,
  input logic [LSIQENTRY-1:0] fp05_observe,
  input logic fp06_qualify,
  input logic fp06_observe,
  input logic fp07_qualify,
  input logic fp07_observe,
  input logic fp08_qualify,
  input logic fp08_observe,
  input logic [LRQENTRY-1:0] fp09_qualify,
  input logic fp09_observe,
  input logic fp10_qualify,
  input logic fp10_observe,
  input logic fp11_qualify,
  input logic fp11_observe,
  input logic fp12_qualify,
  input logic [LRQENTRY-1:0] fp12_observe
);

  default clocking cb @(posedge clk); endclocking
  default disable iff (!reset_n);

  CHK_LRQ_FP01_CAPACITY:
    assert property ((|fp01_qualify) |-> !$isunknown(fp01_observe));
  COV_LRQ_FP01_CAPACITY:
    cover property ((|fp01_qualify) ##1 !$isunknown(fp01_observe));

  CHK_LRQ_FP02_CREATE_ACCEPT:
    assert property ((|fp02_qualify) |-> !$isunknown(fp02_observe));
  COV_LRQ_FP02_CREATE:
    cover property ((|fp02_qualify) ##1 !$isunknown(fp02_observe));

  CHK_LRQ_FP03_PAYLOAD:
    assert property ((|fp03_qualify) |-> !$isunknown(fp03_observe));
  COV_LRQ_FP03_PAYLOAD:
    cover property ((|fp03_qualify) ##1 !$isunknown(fp03_observe));

  CHK_LRQ_FP04_FREEZE:
    assert property ((|fp04_qualify) |-> !$isunknown(fp04_observe));
  COV_LRQ_FP04_FREEZE:
    cover property ((|fp04_qualify) ##1 !$isunknown(fp04_observe));

  CHK_LRQ_FP05_WAKEUP_OWNER:
    assert property ((|fp05_qualify) |-> !$isunknown(fp05_observe));
  COV_LRQ_FP05_WAKEUP:
    cover property ((|fp05_qualify) ##1 !$isunknown(fp05_observe));

  CHK_LRQ_FP06_OLDEST:
    assert property ((|fp06_qualify) |-> !$isunknown(fp06_observe));
  COV_LRQ_FP06_OLDEST:
    cover property ((|fp06_qualify) ##1 !$isunknown(fp06_observe));

  CHK_LRQ_FP07_REPLAY:
    assert property ((|fp07_qualify) |-> !$isunknown(fp07_observe));
  COV_LRQ_FP07_REPLAY:
    cover property ((|fp07_qualify) ##1 !$isunknown(fp07_observe));

  CHK_LRQ_FP08_BARRIER:
    assert property ((|fp08_qualify) |-> !$isunknown(fp08_observe));
  COV_LRQ_FP08_BARRIER:
    cover property ((|fp08_qualify) ##1 !$isunknown(fp08_observe));

  CHK_LRQ_FP09_DA_FEEDBACK:
    assert property ((|fp09_qualify) |-> !$isunknown(fp09_observe));
  COV_LRQ_FP09_DA:
    cover property ((|fp09_qualify) ##1 !$isunknown(fp09_observe));

  CHK_LRQ_FP10_FLUSH:
    assert property ((|fp10_qualify) |-> !$isunknown(fp10_observe));
  COV_LRQ_FP10_FLUSH:
    cover property ((|fp10_qualify) ##1 !$isunknown(fp10_observe));

  CHK_LRQ_FP11_CLOCK_RESET:
    assert property ((|fp11_qualify) |-> !$isunknown(fp11_observe));
  COV_LRQ_FP11_CLOCK:
    cover property ((|fp11_qualify) ##1 !$isunknown(fp11_observe));

  CHK_LRQ_FP12_PARAMETER:
    assert property ((|fp12_qualify) |-> !$isunknown(fp12_observe));
  COV_LRQ_FP12_PARAMETER:
    cover property ((|fp12_qualify) ##1 !$isunknown(fp12_observe));

endmodule
