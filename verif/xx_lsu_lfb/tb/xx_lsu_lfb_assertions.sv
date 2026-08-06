`timescale 1ns/1ps

module xx_lsu_lfb_assertions (
  input logic clk,
  input logic reset_n,
  input logic fp01_qualify,
  input logic [4  :0] fp01_observe,
  input logic fp02_qualify,
  input logic [7  :0] fp02_observe,
  input logic fp03_qualify,
  input logic fp03_observe,
  input logic fp04_qualify,
  input logic [1  :0] fp04_observe,
  input logic fp05_qualify,
  input logic fp05_observe,
  input logic fp06_qualify,
  input logic fp06_observe,
  input logic fp07_qualify,
  input logic [`WK_LS_DCACHE_DATA_WORDS_NUM-1 :0] fp07_observe,
  input logic fp08_qualify,
  input logic fp08_observe,
  input logic fp09_qualify,
  input logic fp09_observe,
  input logic fp10_qualify,
  input logic fp10_observe,
  input logic fp11_qualify,
  input logic fp11_observe,
  input logic fp12_qualify,
  input logic fp12_observe,
  input logic fp13_qualify,
  input logic fp13_observe
);

  default clocking cb @(posedge clk); endclocking
  default disable iff (!reset_n);

  CHK_LFB_FP01_ALLOCATE:
    assert property ((|fp01_qualify) |-> !$isunknown(fp01_observe));
  COV_LFB_FP01_ALLOCATE:
    cover property ((|fp01_qualify) ##1 !$isunknown(fp01_observe));

  CHK_LFB_FP02_ADDR_LIFECYCLE:
    assert property ((|fp02_qualify) |-> !$isunknown(fp02_observe));
  COV_LFB_FP02_ADDR:
    cover property ((|fp02_qualify) ##1 !$isunknown(fp02_observe));

  CHK_LFB_FP03_ADDRESS_HIT:
    assert property ((|fp03_qualify) |-> !$isunknown(fp03_observe));
  COV_LFB_FP03_HIT:
    cover property ((|fp03_qualify) ##1 !$isunknown(fp03_observe));

  CHK_LFB_FP04_DATA_BINDING:
    assert property ((|fp04_qualify) |-> !$isunknown(fp04_observe));
  COV_LFB_FP04_DATA:
    cover property ((|fp04_qualify) ##1 !$isunknown(fp04_observe));

  CHK_LFB_FP05_BIU_RESPONSE:
    assert property ((|fp05_qualify) |-> !$isunknown(fp05_observe));
  COV_LFB_FP05_BIU:
    cover property ((|fp05_qualify) ##1 !$isunknown(fp05_observe));

  CHK_LFB_FP06_VB:
    assert property ((|fp06_qualify) |-> !$isunknown(fp06_observe));
  COV_LFB_FP06_VB:
    cover property ((|fp06_qualify) ##1 !$isunknown(fp06_observe));

  CHK_LFB_FP07_REFILL:
    assert property ((|fp07_qualify) |-> !$isunknown(fp07_observe));
  COV_LFB_FP07_REFILL:
    cover property ((|fp07_qualify) ##1 !$isunknown(fp07_observe));

  CHK_LFB_FP08_ALL_RESPONSE:
    assert property ((|fp08_qualify) |-> !$isunknown(fp08_observe));
  COV_LFB_FP08_ALL:
    cover property ((|fp08_qualify) ##1 !$isunknown(fp08_observe));

  CHK_LFB_FP09_DEPENDENCY:
    assert property ((|fp09_qualify) |-> !$isunknown(fp09_observe));
  COV_LFB_FP09_WAKEUP:
    cover property ((|fp09_qualify) ##1 !$isunknown(fp09_observe));

  CHK_LFB_FP10_SNQ_BYPASS:
    assert property ((|fp10_qualify) |-> !$isunknown(fp10_observe));
  COV_LFB_FP10_SNQ:
    cover property ((|fp10_qualify) ##1 !$isunknown(fp10_observe));

  CHK_LFB_FP11_FLUSH:
    assert property ((|fp11_qualify) |-> !$isunknown(fp11_observe));
  COV_LFB_FP11_FLUSH:
    cover property ((|fp11_qualify) ##1 !$isunknown(fp11_observe));

  CHK_LFB_FP12_CAPACITY:
    assert property ((|fp12_qualify) |-> !$isunknown(fp12_observe));
  COV_LFB_FP12_CAPACITY:
    cover property ((|fp12_qualify) ##1 !$isunknown(fp12_observe));

  CHK_LFB_FP13_CLOCK_RESET:
    assert property ((|fp13_qualify) |-> !$isunknown(fp13_observe));
  COV_LFB_FP13_CLOCK:
    cover property ((|fp13_qualify) ##1 !$isunknown(fp13_observe));

endmodule
