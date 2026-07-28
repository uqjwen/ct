`ifndef XX_LSU_LD_AG_STANDALONE_DEFS_SVH
`define XX_LSU_LD_AG_STANDALONE_DEFS_SVH

// Standalone values reconstructed from the supplied RTL widths. A full-chip
// run should use the production project header and define USE_PROJECT_DEFS.
`ifndef USE_PROJECT_DEFS
  `ifndef TDT_MP_HINFO_WIDTH
    `define TDT_MP_HINFO_WIDTH 17
  `endif
  `ifndef VL_WIDTH
    `define VL_WIDTH 8
  `endif
  `ifndef VSTART_WIDTH
    `define VSTART_WIDTH 7
  `endif
  `ifndef WK_PA_WIDTH
    `define WK_PA_WIDTH 40
  `endif
  `ifndef WK_MA_WIDTH
    `define WK_MA_WIDTH 40
  `endif
  `ifndef WK_LS_DCACHE_SINGLE_TAG_WIDTH
    `define WK_LS_DCACHE_SINGLE_TAG_WIDTH 26
  `endif
  `ifndef WK_LS_DCACHE_SINGLE_LDTAG_WIDTH
    `define WK_LS_DCACHE_SINGLE_LDTAG_WIDTH 27
  `endif
  `ifndef WK_LS_DCACHE_DOUBLE_LDTAG_WIDTH
    `define WK_LS_DCACHE_DOUBLE_LDTAG_WIDTH 54
  `endif
  `ifndef WK_LS_DCACHE_TRIPLE_LDTAG_WIDTH
    `define WK_LS_DCACHE_TRIPLE_LDTAG_WIDTH 81
  `endif
  `ifndef WK_LS_DCACHE_LDTAG_WIDTH
    `define WK_LS_DCACHE_LDTAG_WIDTH 108
  `endif
`endif

`endif
