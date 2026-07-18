//-----------------------------------------------------------------------------
// File          : xx_lsu_lfb.v
// Created       : 2024/10/01 (by Wen Jiahui)
// Last modified : 2024/10/01 (by Wen Jiahui)
// Version       : s1.0 (##s means single file version, 
//                       to avoid conflicts with the whole project version)
//-----------------------------------------------------------------------------
// Description :
//  This block contains the TBD.
//-----------------------------------------------------------------------------
// Copyright (c) 2023 CHUXIN Team.  All rights reserved.
// This model is the confidential and proprietary property of CHUXIN team and the possession or use of this
// file requires a written license from CHUXIN team. This work may not be copied, modified, re-published, uploaded, executed,
// or distributed in any way, in any medium, whether in whole or in part, without prior written permission from CHUXIN Team.
//-----------------------------------------------------------------------------
// Modification history :
// 2024/10/01 : Created
// 2024/XX/XX : 
//-----------------------------------------------------------------------------

//#
//# Module Declaration
//# ==================
//#



// *****************************************************************************

// &ModuleBeg; @29
module xx_lsu_lfb #(
  parameter LSIQ_ENTRY      = 12,
  parameter LFB_ADDR_ENTRY  = 16,
  parameter LFB_DATA_ENTRY  = 2,
  parameter BIU_LFB_ID_T    = 1'b0,
  parameter OKAY            = 2'b00,
  parameter EXOKAY          = 2'b01,
  parameter SLVERR          = 2'b10,
  parameter DECERR          = 2'b11
)(  
  input  wire                                       rtu_ck_flush, 
  input  wire  [255:0]                              biu_lsu_r_data,                      
  input  wire  [4  :0]                              biu_lsu_r_id,                        
  input  wire                                       biu_lsu_r_last,                      
  input  wire  [3  :0]                              biu_lsu_r_resp,                      
  input  wire                                       biu_lsu_r_vld,                       
  input  wire  [1  :0]                              biu_lsu_r_user,                       
  input  wire                                       bus_arb_pfu_ar_sel,                  
  input  wire                                       bus_arb_rb_ar_sel,                   
  input  wire                                       cp0_lsu_dcache_en,                   
  input  wire                                       cp0_lsu_icg_en,                      
  input  wire                                       cpurst_b,                            
  input  wire                                       dcache_arb_lfb_ld_grnt,              
  input  wire                                       forever_cpuclk,                      
  input  wire  [`WK_PA_WIDTH-7 :0]                  ld_da_addr_tto6[0: `NUM_LD + `NUM_LS-1],                           
  input  wire                                       lda0_lfb_ex3_ldamo,  // wjh@amo lfb snq deadlock
  input  wire                                       lsda0_lfb_ex3_ldamo, // wjh@amo lfb snq deadlock
  input  wire                                       lsda1_lfb_ex3_ldamo, // wjh@amo lfb snq deadlock
  input  wire                                       ld_da_lfb_discard_grnt[0: `NUM_LD + `NUM_LS-1],              
  input  wire                                       ld_da_lfb_set_wakeup_queue[0: `NUM_LD + `NUM_LS-1],          
  input  wire                                       ld_da_lfb_set_wakeup_queue_gate[0: `NUM_LD + `NUM_LS-1],     
  input  wire  [LSIQ_ENTRY :0]                      ld_da_lfb_wakeup_queue_next[0: `NUM_LD + `NUM_LS-1],         
  input  wire                                       lm_already_snoop,                    
  input  wire                                       lm_lfb_depd_wakeup[0: `NUM_LD + `NUM_LS-1],                  
  input  wire                                       lm_state_is_amo_lock,                
  input  wire                                       lsu_special_clk,                     
  input  wire                                       pad_yy_icg_scan_en,                  
  input  wire  [`WK_PA_WIDTH-1 :0]                  pfu_biu_req_addr,                    
  input  wire  [`WK_VA_WIDTH-1 :12]                 pfu_lfb_full_va,                    
  input  wire                                       pfu_lfb_create_dp_vld,               
  input  wire                                       pfu_lfb_create_gateclk_en,           
  input  wire                                       pfu_lfb_create_req,                  
  input  wire                                       pfu_lfb_create_vld,                  
  input  wire  [3  :0]                              pfu_lfb_id,                          
  input  wire  [1  :0]                              pfu_lfb_pf_type,
  input  wire                                       pfu_lfb_page_share,                  
  input  wire  [`WK_PA_WIDTH-1 :0]                  rb_biu_req_addr,                     
  input  wire  [`WK_PA_WIDTH-5 :0]                  rb_lfb_addr_tto4,                    
  input  wire  [`WK_VA_WIDTH-1: 12]                 rb_lfb_full_va,                       
  input  wire                                       rb_lfb_atomic,                       
  input  wire                                       rb_lfb_create_dp_vld,                
  input  wire                                       rb_lfb_create_gateclk_en,            
  input  wire                                       rb_lfb_create_req,                   
  input  wire                                       rb_lfb_create_vld,                   
  input  wire                                       rb_lfb_depd,                         
  input  wire                                       rb_lfb_depd_wakeup[0: `NUM_LD + `NUM_LS-1],                  
  input  wire                                       rb_lfb_ldamo,                        
  input  wire                                       rb_lfb_page_ca,                      
  input  wire                                       rb_lfb_page_share,                   
  input  wire                                       rtu_yy_xx_flush,                     
  input  wire  [`WK_PA_WIDTH-7 :0]                  snq_bypass_addr_tto6,                
  input  wire                                       snq_create_lfb_vb_req_hit_idx,       
  input  wire  [1  :0]                              snq_lfb_bypass_chg_tag,              
  input  wire  [1  :0]                              snq_lfb_bypass_invalid,              
  input  wire                                       snq_lfb_vb_req_hit_idx,              
  input  wire  [`WK_PA_WIDTH-1 :0]                  st_da_addr[0 :`NUM_LS-1],                          
  input  wire                                       st_da_cache_miss [0 :`NUM_LS-1],                          
  input  wire  [LFB_ADDR_ENTRY-1  :0]               vb_lfb_addr_entry_rcl_done,          
  input  wire                                       vb_lfb_create_grnt,                  
  input  wire                                       vb_lfb_dcache_dirty,                 
  input  wire                                       vb_lfb_dcache_hit,                   
  input  wire  [`WK_LS_DCACHE_WAYIDX_WIDTH-1 :0]    vb_lfb_dcache_way,                   
  input  wire                                       vb_lfb_rcl_done,                     
  input  wire                                       vb_lfb_vb_req_hit_idx,               
  input  wire  [`WK_PA_WIDTH-1 :0]                  wmb_read_req_addr,                   
  input  wire  [`WK_PA_WIDTH-1 :0]                  wmb_write_req_addr,                  
  // full va for cmc/bop when cross page boundary
  input  wire                                       l2_ls_req_full_va,   
  input  wire  [`WK_LSL2_DID]                       l2_ls_req_full_va_id,            
  output wire                                       ls_l2_full_va_v,     
  output reg   [`WK_VA_WIDTH:12]               ls_l2_full_va,             
                 
  output wire                                       ld_hit_prefetch,                     
  output wire                                       lfb_addr_full,                       
  output wire                                       lfb_addr_less2,                      
  output wire  [`WK_LS_DCACHE_DATA_WORDS_NUM-1 :0]  lfb_dcache_arb_ld_data_gateclk_en,   
  output wire  [`WK_LS_DCACHE_DATA_IDX_MSB     :0]  lfb_dcache_arb_ld_data_idx,      
  output wire  [`WK_LS_DCACHE_DATA_WORDS_NUM-1 :0]  lfb_dcache_arb_ld_data_req,        
  output wire  [155:0]                              lfb_dcache_arb_ld_data_1st_din,      
  output wire  [155:0]                              lfb_dcache_arb_ld_data_2nd_din,     
  output wire  [155:0]                              lfb_dcache_arb_ld_data_3rd_din,      
  output wire  [155:0]                              lfb_dcache_arb_ld_data_4th_din,     
  output wire                                       lfb_dcache_arb_ld_req,               
  output wire                                       lfb_dcache_arb_ld_tag_gateclk_en,    
  output wire  [`WK_LS_DCACHE_WAYS_NUM-1        :0] lfb_dcache_arb_ld_tag_wen,           
  output wire  [`WK_LS_DCACHE_LDTAG_IDX_MSB     :0] lfb_dcache_arb_ld_tag_idx,           
  output wire  [`WK_LS_DCACHE_LDTAG_WIDTH-1     :0] lfb_dcache_arb_ld_tag_din,           
  output wire  [`WK_LS_DCACHE_META_NOECC_WIDTH-1:0] lfb_dcache_arb_st_dirty_wen,         
  output wire  [`WK_LS_DCACHE_META_IDX_MSB      :0] lfb_dcache_arb_st_dirty_idx,         
  output wire  [`WK_LS_DCACHE_META_WIDTH-1      :0] lfb_dcache_arb_st_dirty_din,         
  output wire  [`WK_LS_DCACHE_WAYS_NUM-1        :0] lfb_dcache_arb_st_tag_wen,           
  output wire  [`WK_LS_DCACHE_LDTAG_IDX_MSB     :0] lfb_dcache_arb_st_tag_idx,           
  output wire  [`WK_LS_DCACHE_TAG_NOECC_WIDTH-1 :0] lfb_dcache_arb_st_tag_din,           
  output wire                                       lfb_dcache_arb_ld_tag_req,           
  output wire                                       lfb_dcache_arb_serial_req,           
  output wire                                       lfb_dcache_arb_st_dirty_gateclk_en,  
  output wire                                       lfb_dcache_arb_st_dirty_req,         
  output wire                                       lfb_dcache_arb_st_req,               
  output wire                                       lfb_dcache_arb_st_tag_gateclk_en,    
  output wire                                       lfb_dcache_arb_st_tag_req,           
  output wire  [LSIQ_ENTRY-1 :0]                    lfb_depd_wakeup[0: `NUM_LD + `NUM_LS-1],                     
  output wire                                       lfb_empty,                           
  output wire                                       lfb_has_pend,                        
  output wire                                       lfb_ld_da_hit_idx[0: `NUM_LD + `NUM_LS-1],                   
  output wire                                       lfb_mcic_wakeup,                     
  output wire  [`WK_PA_WIDTH-1 :0]                  lfb_pend_addr_f,                     
  output wire                                       lfb_pend_page_ca_f,                  
  output wire                                       lfb_pend_page_so_f,                  
  output wire                                       lfb_pfu_biu_req_hit_idx,             
  output wire  [4  :0]                              lfb_pfu_create_id,                   
  output wire  [8  :0]                              lfb_pfu_dcache_hit,                  
  output wire  [8  :0]                              lfb_pfu_dcache_miss,                 
  output wire                                       lfb_pfu_rready_grnt,                 
  output wire                                       lfb_pfu_fill_not_pf,
  output wire                                       lfb_pfu_fill_late_ld,
  output wire                                       lfb_pfu_fill_late_st,
  output reg   [1  :0]                              lfb_pfu_fill_pf_type,
  output reg   [1  :0]                              lfb_pfu_fill_rsrc,
  output reg   [3  :0]                              lfb_pfu_fill_id,  
  output reg                                        lfb_pfu_fill_id_vld,  
  output reg                                        lfb_pfu_fill_pending,  
  output reg                                        lfb_pop_depd_ff[0: `NUM_LD + `NUM_LS-1],                     
  output wire                                       lfb_rb_biu_req_hit_idx,              
  output wire                                       lfb_rb_ca_rready_grnt,               
  output wire  [4  :0]                              lfb_rb_create_id,                    
  output wire                                       lfb_rb_nc_empty,                     
  output wire                                       lfb_rb_nc_rready_grnt,               
  output wire  [1  :0]                              lfb_snq_bypass_data_id,              
  output wire                                       lfb_snq_bypass_hit,                  
  output wire                                       lfb_snq_bypass_share,                
  output wire                                       lfb_st_da_hit_idx[0: `NUM_LS-1],                   
  output reg   [`WK_PA_WIDTH-7 :0]                  lfb_vb_addr_tto6,                    
  output wire                                       lfb_vb_create_dp_vld,                
  output wire                                       lfb_vb_create_gateclk_en,            
  output wire                                       lfb_vb_create_req,                   
  output wire                                       lfb_vb_create_vld,                   
  output wire  [$clog2(LFB_ADDR_ENTRY)-1  :0]       lfb_vb_id,                           
  output wire                                       lfb_wmb_read_req_hit_idx,            
  output wire                                       lfb_wmb_write_req_hit_idx,           
  output wire                                       lsu_biu_r_linefill_ready,            
  output wire  [7  :0]                              lsu_had_lfb_addr_entry_dcache_hit,   
  output wire  [7  :0]                              lsu_had_lfb_addr_entry_rcl_done,     
  output wire  [7  :0]                              lsu_had_lfb_addr_entry_vld,          
  output wire  [1  :0]                              lsu_had_lfb_data_entry_last,         
  output wire  [1  :0]                              lsu_had_lfb_data_entry_vld,          
  output wire                                       lsu_had_lfb_lf_sm_vld,               
  output wire  [LSIQ_ENTRY :0]                      lsu_had_lfb_wakeup_queue            
);


// &Regs; @31
reg     [LFB_ADDR_ENTRY-1  :0]                      lfb_addr_create_ptr;                 
reg     [1  :0]                                     lfb_data_create_ptr;                 
reg     [1  :0]                                     lfb_first_pass_ptr;                  
reg     [LFB_ADDR_ENTRY-1  :0]                      lfb_lf_sm_addr_id;                   
reg     [`WK_PA_WIDTH-7 :0]                         lfb_lf_sm_addr_tto6;                 
reg                                                 lfb_lf_sm_cnt;                       
reg     [1  :0]                                     lfb_lf_sm_data_id;                   
reg                                                 lfb_lf_sm_dcache_share;              
reg                                                 lfb_lf_sm_page_share;                
reg     [`WK_LS_DCACHE_WAYIDX_WIDTH-1 :0]           lfb_lf_sm_refill_way;                
wire    [`WK_LS_DCACHE_WAYS_NUM-1     :0]           lfb_lf_sm_refill_way_expand;                
reg     [1  :0]                                     lfb_lf_sm_req_data_ptr;              
reg                                                 lfb_lf_sm_vld;                       
reg                                                 lfb_mcic_wakeup_queue;               
reg     [$clog2(LFB_ADDR_ENTRY):0]                  lfb_no_rcl_cnt;                      
reg     [LFB_ADDR_ENTRY-1  :0]                      lfb_r_id_hit_addr_ptr;               
reg     [LFB_ADDR_ENTRY-1  :0]                      lfb_vb_addr_ptr;                     
reg     [LFB_ADDR_ENTRY-1  :0]                      lfb_vb_pe_req_ptr;                   
reg                                                 lfb_vb_req_unmask;                   
reg     [LSIQ_ENTRY-1 :0]                           lfb_wakeup_queue[0: `NUM_LD + `NUM_LS-1];                    

// &Wires; @32
wire    [311:0]                                     data_aft_ecc;                        
wire    [38 :0]                                     data_aft_ecc_0;                      
wire    [38 :0]                                     data_aft_ecc_1;                      
wire    [38 :0]                                     data_aft_ecc_2;                      
wire    [38 :0]                                     data_aft_ecc_3;                      
wire    [38 :0]                                     data_aft_ecc_4;                      
wire    [38 :0]                                     data_aft_ecc_5;                      
wire    [38 :0]                                     data_aft_ecc_6;                      
wire    [38 :0]                                     data_aft_ecc_7;                      
wire    [31 :0]                                     data_bf_ecc_0;                       
wire    [31 :0]                                     data_bf_ecc_1;                       
wire    [31 :0]                                     data_bf_ecc_2;                       
wire    [31 :0]                                     data_bf_ecc_3;                       
wire    [31 :0]                                     data_bf_ecc_4;                       
wire    [31 :0]                                     data_bf_ecc_5;                       
wire    [31 :0]                                     data_bf_ecc_6;                       
wire    [31 :0]                                     data_bf_ecc_7;                       
wire    [`WK_LS_DATASRAM_ECC_WIDTH-1  :0]           data_ecc_0;                          
wire    [`WK_LS_DATASRAM_ECC_WIDTH-1  :0]           data_ecc_1;                          
wire    [`WK_LS_DATASRAM_ECC_WIDTH-1  :0]           data_ecc_2;                          
wire    [`WK_LS_DATASRAM_ECC_WIDTH-1  :0]           data_ecc_3;                          
wire    [`WK_LS_DATASRAM_ECC_WIDTH-1  :0]           data_ecc_4;                          
wire    [`WK_LS_DATASRAM_ECC_WIDTH-1  :0]           data_ecc_5;                          
wire    [`WK_LS_DATASRAM_ECC_WIDTH-1  :0]           data_ecc_6;                          
wire    [`WK_LS_DATASRAM_ECC_WIDTH-1  :0]           data_ecc_7;                          
wire                                                data_parity_0;                       
wire                                                data_parity_1;                       
wire                                                data_parity_2;                       
wire                                                data_parity_3;                       
wire                                                data_parity_4;                       
wire                                                data_parity_5;                       
wire                                                data_parity_6;                       
wire                                                data_parity_7;                       
wire    [LFB_ADDR_ENTRY-1  :0]                      ld_hit_prefetch_first;               
wire    [`WK_LS_DCACHE_LDTAG_AF_ECC_LENGTH-1 :0]    ld_tag_af_ecc;                       
wire    [`WK_LS_DCACHE_LDTAG_BF_ECC_LENGTH-1 :0]    ld_tag_bf_ecc;                       
wire    [`WK_LS_DATASRAM_ECC_WIDTH-1  :0]           ld_tag_ecc;                          
wire    [`WK_LS_DCACHE_LDTAG_WIDTH-1 :0]            ld_tag_ecc_din;                      
wire                                                ld_tag_parity;                       
wire                                                lfb_addr_all_resp;                   
wire                                                lfb_addr_empty;                      
wire    [`WK_PA_WIDTH-5 :0]                         lfb_addr_entry_addr_tto4 [LFB_ADDR_ENTRY-1 :0];          
wire    [LFB_ADDR_ENTRY-1  :0]                      lfb_addr_entry_create_gateclk_en;    
wire    [LFB_ADDR_ENTRY-1  :0]                      lfb_addr_entry_dcache_hit;           
// wire    [7  :0]  lfb_addr_entry_depd;                 
// wire    [7  :0]  lfb_addr_entry_discard_vld;          
// wire    [7  :0]  lfb_addr_entry_ld_da_hit_idx; 
wire    [`NUM_LD + `NUM_LS -1 :0]                   lfb_addr_entry_depd [0 :LFB_ADDR_ENTRY-1];
wire    [LFB_ADDR_ENTRY-1 :0]                       lfb_addr_entry_depd_trans [0: `NUM_LD + `NUM_LS -1];
wire    [`NUM_LD + `NUM_LS -1  :0]                  lfb_addr_entry_discard_vld [0: LFB_ADDR_ENTRY-1];          
wire    [LFB_ADDR_ENTRY-1  :0]                      lfb_addr_entry_discard_vld_trans [0: `NUM_LD + `NUM_LS -1];    
wire    [`NUM_LD + `NUM_LS -1  :0]                  lfb_addr_entry_ld_da_hit_idx [0: LFB_ADDR_ENTRY-1];        
wire    [LFB_ADDR_ENTRY-1  :0]                      lfb_addr_entry_ld_da_hit_idx_trans [0: `NUM_LD + `NUM_LS -1]; 
wire    [`NUM_LS-1 :0]                              lfb_addr_entry_st_da_hit_idx [0 :LFB_ADDR_ENTRY-1] ;   
wire    [LFB_ADDR_ENTRY-1  :0]                      lfb_addr_entry_st_da_hit_idx_trans [0 :`NUM_LS-1] ;      
genvar i,j;
`TRANS_ARRAY(3,16,lfb_addr_entry_depd,lfb_addr_entry_depd_trans);
`TRANS_ARRAY(3,16,lfb_addr_entry_discard_vld,lfb_addr_entry_discard_vld_trans);
`TRANS_ARRAY(3,16,lfb_addr_entry_ld_da_hit_idx,lfb_addr_entry_ld_da_hit_idx_trans);       
`TRANS_ARRAY(2,16,lfb_addr_entry_st_da_hit_idx,lfb_addr_entry_st_da_hit_idx_trans);       

wire    [LFB_ADDR_ENTRY-1  :0]                      lfb_addr_entry_ldamo;                
wire    [LFB_ADDR_ENTRY-1  :0]                      lfb_addr_entry_linefill_abort;       
wire    [LFB_ADDR_ENTRY-1  :0]                      lfb_addr_entry_linefill_permit;      
wire    [LFB_ADDR_ENTRY-1  :0]                      lfb_addr_entry_not_resp;             
wire    [LFB_ADDR_ENTRY-1  :0]                      lfb_addr_entry_page_nc;              
wire    [LFB_ADDR_ENTRY-1  :0]                      lfb_addr_entry_page_share;           
wire    [LFB_ADDR_ENTRY-1  :0]                      lfb_addr_entry_pfu_biu_req_hit_idx;  
wire    [LFB_ADDR_ENTRY-1  :0]                      lfb_addr_entry_pfu_create_dp_vld;    
wire    [LFB_ADDR_ENTRY-1  :0]                      lfb_addr_entry_pfu_create_vld;       
wire    [8  :0]                                     lfb_addr_entry_pfu_dcache_hit  [LFB_ADDR_ENTRY-1 :0]; 
wire    [8  :0]                                     lfb_addr_entry_pfu_dcache_miss [LFB_ADDR_ENTRY-1 :0];    
wire    [3  :0]                                     lfb_addr_entry_pfu_id  [LFB_ADDR_ENTRY-1  :0];
wire    [LFB_ADDR_ENTRY-1  :0]                      lfb_addr_entry_pfu_id_vld;
wire    [1  :0]                                     lfb_addr_entry_pf_type [LFB_ADDR_ENTRY-1  :0];
wire    [`WK_VA_WIDTH-1   :12]                      lfb_addr_entry_full_va [LFB_ADDR_ENTRY-1  :0];
wire    [LFB_ADDR_ENTRY-1  :0]                      lfb_addr_entry_pfu_create;
wire    [LFB_ADDR_ENTRY-1  :0]                      lfb_addr_entry_pf_late_ld;
wire    [LFB_ADDR_ENTRY-1  :0]                      lfb_addr_entry_pf_late_st; 
wire    [LFB_ADDR_ENTRY-1  :0]                      lfb_addr_entry_pop_vld;              
wire    [LFB_ADDR_ENTRY-1  :0]                      lfb_addr_entry_rb_biu_req_hit_idx;   
wire    [LFB_ADDR_ENTRY-1  :0]                      lfb_addr_entry_rb_create_dp_vld;     
wire    [LFB_ADDR_ENTRY-1  :0]                      lfb_addr_entry_rb_create_vld;        
wire    [LFB_ADDR_ENTRY-1  :0]                      lfb_addr_entry_rcl_done;             
wire    [`WK_LS_DCACHE_WAYIDX_WIDTH-1 :0]           lfb_addr_entry_refill_way [LFB_ADDR_ENTRY-1  :0];      
wire    [LFB_ADDR_ENTRY-1  :0]                      lfb_addr_entry_resp_set;             
wire    [LFB_ADDR_ENTRY-1  :0]                      lfb_addr_entry_snq_bypass_hit;       
wire    [LFB_ADDR_ENTRY-1  :0]                      lfb_addr_entry_vb_pe_req;            
wire    [LFB_ADDR_ENTRY-1  :0]                      lfb_addr_entry_vb_pe_req_grnt;       
wire    [LFB_ADDR_ENTRY-1  :0]                      lfb_addr_entry_vld;                  
wire    [LFB_ADDR_ENTRY-1  :0]                      lfb_addr_entry_wmb_read_req_hit_idx; 
wire    [LFB_ADDR_ENTRY-1  :0]                      lfb_addr_entry_wmb_write_req_hit_idx; 
wire                                                lfb_addr_pfu_create_dp_vld;          
wire                                                lfb_addr_pfu_create_vld;             
wire                                                lfb_addr_pop_depd[0: `NUM_LD + `NUM_LS-1];                   
wire                                                lfb_addr_pop_discard_vld[0: `NUM_LD + `NUM_LS-1];            
wire                                                lfb_addr_rb_create_dp_vld;           
wire                                                lfb_addr_rb_create_vld;              
wire    [$clog2(LFB_ADDR_ENTRY)-1  :0]              lfb_biu_id_2to0;                     
wire                                                lfb_biu_r_id_hit;                    
wire                                                lfb_ca_rready_grnt;                  
wire                                                lfb_clk;                             
wire                                                lfb_clk_en;                          
wire    [$clog2(LFB_ADDR_ENTRY)-1  :0]              lfb_create_id;                       
wire                                                lfb_create_linefill_dp;              
wire                                                lfb_create_linefill_vld;             
wire                                                lfb_create_vb_cancel;                
wire                                                lfb_create_vb_success;               
wire    [LFB_ADDR_ENTRY-1  :0]                      lfb_data_addr_pop_req;               
wire                                                lfb_data_create_dp_vld;              
wire                                                lfb_data_create_gateclk_en;          
wire                                                lfb_data_create_vld;                 
wire                                                lfb_data_empty;                      
wire    [LFB_ADDR_ENTRY-1  :0]                      lfb_data_entry_addr_id_0;            
wire    [LFB_ADDR_ENTRY-1  :0]                      lfb_data_entry_addr_id_1;            
wire    [LFB_ADDR_ENTRY-1  :0]                      lfb_data_entry_addr_pop_req_0;       
wire    [LFB_ADDR_ENTRY-1  :0]                      lfb_data_entry_addr_pop_req_1;       
wire    [1  :0]                                     lfb_data_entry_create_dp_vld;        
wire    [1  :0]                                     lfb_data_entry_create_gateclk_en;    
wire    [1  :0]                                     lfb_data_entry_create_vld;           
wire    [511:0]                                     lfb_data_entry_data_0;               
wire    [511:0]                                     lfb_data_entry_data_1;               
wire    [1  :0]                                     lfb_data_entry_dcache_share;         
wire    [1  :0]                                     lfb_data_entry_full;                 
wire    [1  :0] [1 :0]                              lfb_data_entry_rsrc;                 
wire    [1  :0]                                     lfb_data_entry_last;                 
wire    [1  :0]                                     lfb_data_entry_lf_sm_req;            
wire    [1  :0]                                     lfb_data_entry_vld;                  
wire    [1  :0]                                     lfb_data_entry_wait_surplus;         
wire                                                lfb_data_not_full;                   
wire                                                lfb_data_wait_surplus;               
wire    [LFB_ADDR_ENTRY-1 :0] [`WK_PA_WIDTH-1 :0]   lfb_entry_addr;                    
wire    [LFB_ADDR_ENTRY-1  :0]                      lfb_entry_page_ca;                   
wire    [LFB_ADDR_ENTRY-1  :0]                      lfb_entry_page_so;                   
wire    [LFB_ADDR_ENTRY-1  :0]                      lfb_lf_sm_addr_pop_req;              
wire                                                lfb_lf_sm_clk;                       
wire                                                lfb_lf_sm_clk_en;                    
wire                                                lfb_lf_sm_create_vld;                
wire    [255:0]                                     lfb_lf_sm_data256;                   
wire    [511:0]                                     lfb_lf_sm_data512;       
wire    [511:0]                                     lfb_lf_sm_data512_rot0;
wire    [511:0]                                     lfb_lf_sm_data512_rot1;
wire    [511:0]                                     lfb_lf_sm_data512_rot2;
wire    [511:0]                                     lfb_lf_sm_data512_rot3;
wire    [511:0]                                     lfb_lf_sm_data512_rot ;           
wire                                                lfb_lf_sm_data_dcache_share;         
wire    [1  :0]                                     lfb_lf_sm_data_grnt;                 
wire    [1  :0]                                     lfb_lf_sm_data_pop_req;              
wire    [255:0]                                     lfb_lf_sm_data_settle;               
wire    [311:0]                                     lfb_lf_sm_data_settle_ecc;           
wire                                                lfb_lf_sm_permit;                    
wire                                                lfb_lf_sm_refill_wakeup[0: `NUM_LD + `NUM_LS-1];             
wire                                                lfb_lf_sm_req;                       
wire    [LFB_ADDR_ENTRY-1  :0]                      lfb_lf_sm_req_addr_ptr;              
wire    [`WK_PA_WIDTH-7 :0]                         lfb_lf_sm_req_addr_tto6;             
wire                                                lfb_lf_sm_req_clk;                   
wire                                                lfb_lf_sm_req_clk_en;                
wire                                                lfb_lf_sm_req_depd[0: `NUM_LD + `NUM_LS-1];                  
wire                                                lfb_lf_sm_req_page_share;            
logic    [`WK_LS_DCACHE_WAYIDX_WIDTH-1 :0]          lfb_lf_sm_req_refill_way;            
wire                                                lfb_nc_rready_grnt;                  
wire    [$clog2(LFB_ADDR_ENTRY)  :0]                lfb_no_rcl_cnt_create;               
wire    [$clog2(LFB_ADDR_ENTRY)  :0]                lfb_no_rcl_cnt_pop;                  
wire    [$clog2(LFB_ADDR_ENTRY)  :0]                lfb_no_rcl_cnt_updt_val;             
wire                                                lfb_no_rcl_cnt_updt_vld;             
wire    [1  :0]                                     lfb_pass_addr_5to4;                  
wire                                                lfb_pend_busy;                       
wire    [LFB_ADDR_ENTRY-1  :0]                      lfb_pend_entry;                      
wire                                                lfb_pfu_create_grnt;                 
wire                                                lfb_r_resp_err;                      
wire                                                lfb_r_resp_share;                    
wire                                                lfb_rb_create_grnt;                  
wire                                                lfb_vb_pe_all_req;                   
wire                                                lfb_vb_pe_clk;                       
wire                                                lfb_vb_pe_clk_en;                    
wire                                                lfb_vb_pe_pfu_req;                   
wire                                                lfb_vb_pe_rb_req;                    
wire                                                lfb_vb_pe_req;                       
wire    [`WK_PA_WIDTH-7 :0]                         lfb_vb_pe_req_addr_tto6;             
wire                                                lfb_vb_pe_req_permit;                
wire                                                lfb_vb_req_entry_vld;                
wire                                                lfb_vb_req_hit_idx;                  
wire                                                lfb_vb_req_ldamo;                    
wire    [LSIQ_ENTRY :0]                             lfb_wakeup_queue_after_pop[0: `NUM_LD + `NUM_LS-1];          
wire                                                lfb_wakeup_queue_clk[0: `NUM_LD + `NUM_LS-1];                
wire                                                lfb_wakeup_queue_clk_en[0: `NUM_LD + `NUM_LS-1];             
wire    [LSIQ_ENTRY :0]                             lfb_wakeup_queue_next[0: `NUM_LD + `NUM_LS-1];               
wire    [`WK_LS_DCACHE_STTAG_AF_ECC_LENGTH-1 :0]    st_dirty_af_ecc;                     
wire    [`WK_LS_DCACHE_META_WIDTH-1 :0]             st_dirty_ecc_din;                    
wire    [`WK_LS_DCACHE_STTAG_BF_ECC_LENGTH-1 :0]    st_tag_bf_ecc;                       
wire    [`WK_LS_DATASRAM_ECC_WIDTH-1 :0]            st_tag_ecc;                          
wire                                                st_tag_parity;                       
wire                                                l2_ls_req_full_va_qual;
wire                                                l2_ls_req_full_va_en;
reg                                                 l2_ls_req_full_va_qual_dly1_q;
reg                                                 ls_l2_full_va_v_dly2_q;
reg   [LFB_ADDR_ENTRY-1 :0]                         l2_va_read_sel_lfb_entry;
reg   [LFB_ADDR_ENTRY-1 :0]                         l2_va_read_sel_lfb_entry_dly1_q;
reg   [`WK_VA_WIDTH-1  :12]                         l2_read_pf_va_dly1;
reg   [`WK_VA_WIDTH-1  :12]                         ls_l2_full_va_dly2_q;

//==========================================================
//                 Instance of Gated Cell  
//==========================================================
//if lfb has entry or create lfb, then this gateclk is on
//lfb_clk is only used for depd_ff now
assign lfb_clk_en = !lfb_empty
                    ||  rb_lfb_create_gateclk_en
                    ||  pfu_lfb_create_gateclk_en
                    ||  rb_lfb_depd_wakeup[0]
                    ||  lfb_pop_depd_ff[0]
                    ||  lm_lfb_depd_wakeup[0]
                    ||  rb_lfb_depd_wakeup[1]
                    ||  lfb_pop_depd_ff[1]
                    ||  lm_lfb_depd_wakeup[1]
                    ||  rb_lfb_depd_wakeup[2]
                    ||  lfb_pop_depd_ff[2]
                    ||  lm_lfb_depd_wakeup[2];
// &Instance("gated_clk_cell", "x_lsu_lfb_gated_clk"); @55
gated_clk_cell  x_lsu_lfb_gated_clk (
  .clk_in             (lsu_special_clk   ),
  .clk_out            (lfb_clk           ),
  .external_en        (1'b0              ),
  .local_en           (lfb_clk_en        ),
  .module_en          (cp0_lsu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect(.clk_in        (lsu_special_clk     ), @56
//          .external_en   (1'b0               ), @57
//          .module_en     (cp0_lsu_icg_en     ), @58
//          .local_en      (lfb_clk_en         ), @59
//          .clk_out       (lfb_clk            )); @60

//req vb pop entry signal
assign lfb_vb_pe_clk_en   = !lfb_vb_req_unmask
                                &&  (lfb_vb_pe_req
                                    ||  rb_lfb_create_req
                                    ||  pfu_lfb_create_req)
                            ||  lfb_create_vb_cancel
                            ||  lfb_create_vb_success;
// &Instance("gated_clk_cell", "x_lsu_lfb_vb_pe_clk"); @69
gated_clk_cell  x_lsu_lfb_vb_pe_clk (
  .clk_in             (lsu_special_clk   ),
  .clk_out            (lfb_vb_pe_clk     ),
  .external_en        (1'b0              ),
  .local_en           (lfb_vb_pe_clk_en  ),
  .module_en          (cp0_lsu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect(.clk_in        (lsu_special_clk     ), @70
//          .external_en   (1'b0               ), @71
//          .module_en     (cp0_lsu_icg_en     ), @72
//          .local_en      (lfb_vb_pe_clk_en   ), @73
//          .clk_out       (lfb_vb_pe_clk      )); @74

//lf state machine
assign lfb_lf_sm_clk_en = lfb_lf_sm_req
                          ||  lfb_lf_sm_vld;
// &Instance("gated_clk_cell", "x_lsu_lfb_lf_sm_clk"); @79
gated_clk_cell  x_lsu_lfb_lf_sm_clk (
  .clk_in             (lsu_special_clk   ),
  .clk_out            (lfb_lf_sm_clk     ),
  .external_en        (1'b0              ),
  .local_en           (lfb_lf_sm_clk_en  ),
  .module_en          (cp0_lsu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect(.clk_in        (lsu_special_clk     ), @80
//          .external_en   (1'b0               ), @81
//          .module_en     (cp0_lsu_icg_en     ), @82
//          .local_en      (lfb_lf_sm_clk_en   ), @83
//          .clk_out       (lfb_lf_sm_clk      )); @84

assign lfb_lf_sm_req_clk_en = lfb_lf_sm_req
                              &&  lfb_lf_sm_permit;
// &Instance("gated_clk_cell", "x_lsu_lfb_lf_sm_req_clk"); @88
gated_clk_cell  x_lsu_lfb_lf_sm_req_clk (
  .clk_in               (lsu_special_clk     ),
  .clk_out              (lfb_lf_sm_req_clk   ),
  .external_en          (1'b0                ),
  .local_en             (lfb_lf_sm_req_clk_en),
  .module_en            (cp0_lsu_icg_en      ),
  .pad_yy_icg_scan_en   (pad_yy_icg_scan_en  )
);

// &Connect(.clk_in        (lsu_special_clk     ), @89
//          .external_en   (1'b0               ), @90
//          .module_en     (cp0_lsu_icg_en     ), @91
//          .local_en      (lfb_lf_sm_req_clk_en), @92
//          .clk_out       (lfb_lf_sm_req_clk  )); @93

generate
  for(i = 0; i < `NUM_LD + `NUM_LS; i = i+1) begin

assign lfb_wakeup_queue_clk_en[i]  = lfb_pop_depd_ff[i]
                                  ||  ld_da_lfb_set_wakeup_queue_gate[i]
                                  ||  rtu_yy_xx_flush
                                  ||  rtu_ck_flush;
// &Instance("gated_clk_cell", "x_lsu_lfb_wakeup_queue_gated_clk"); @99
gated_clk_cell  x_lsu_lfb_wakeup_queue_gated_clk (
  .clk_in                  (lsu_special_clk        ),
  .clk_out                 (lfb_wakeup_queue_clk[i]   ),
  .external_en             (1'b0                   ),
  .local_en                (lfb_wakeup_queue_clk_en[i]),
  .module_en               (cp0_lsu_icg_en         ),
  .pad_yy_icg_scan_en      (pad_yy_icg_scan_en     )
);
  end
endgenerate

// &Connect(.clk_in        (lsu_special_clk     ), @100
//          .external_en   (1'b0               ), @101
//          .module_en     (cp0_lsu_icg_en     ), @102
//          .local_en      (lfb_wakeup_queue_clk_en), @103
//          .clk_out       (lfb_wakeup_queue_clk)); @104

//==========================================================
//              Instance addr entry
//==========================================================
//8 addr entry
// &ConnRule(s/_x$/[0]/); @110
// &ConnRule(s/_v$/_0/); @111
// &Instance("xx_lsu_lfb_addr_entry","x_xx_lsu_lfb_addr_entry_0"); @112
generate
  for(i=0; i<LFB_ADDR_ENTRY; i=i+1) begin: lfb_addr_entry_gen
    xx_lsu_lfb_addr_entry  x_xx_lsu_lfb_addr_entry (
      .cp0_lsu_icg_en                          (cp0_lsu_icg_en                         ),
      .cpurst_b                                (cpurst_b                               ),
      .ld_da_addr_tto6                         (ld_da_addr_tto6                        ),
      .lda0_lfb_ex3_ldamo                      (lda0_lfb_ex3_ldamo                 ),// wjh@amo lfb snq deadlock
      .lsda0_lfb_ex3_ldamo                     (lsda0_lfb_ex3_ldamo                ),// wjh@amo lfb snq deadlock
      .lsda1_lfb_ex3_ldamo                     (lsda1_lfb_ex3_ldamo                ),// wjh@amo lfb snq deadlock
      .ld_da_lfb_discard_grnt                  (ld_da_lfb_discard_grnt                 ),
      .ld_hit_prefetch_first_x                 (ld_hit_prefetch_first[i]               ),
      .lfb_addr_entry_addr_tto4_v              (lfb_addr_entry_addr_tto4[i]            ),
      .lfb_addr_entry_create_gateclk_en_x      (lfb_addr_entry_create_gateclk_en[i]    ),
      .lfb_addr_entry_dcache_hit_x             (lfb_addr_entry_dcache_hit[i]           ),
      .lfb_addr_entry_depd_x                   (lfb_addr_entry_depd[i]                 ),
      .lfb_addr_entry_discard_vld_x            (lfb_addr_entry_discard_vld[i]          ),
      .lfb_addr_entry_ld_da_hit_idx_x          (lfb_addr_entry_ld_da_hit_idx[i]        ),
      .lfb_addr_entry_ldamo_x                  (lfb_addr_entry_ldamo[i]                ),
      .lfb_addr_entry_linefill_abort_x         (lfb_addr_entry_linefill_abort[i]       ),
      .lfb_addr_entry_linefill_permit_x        (lfb_addr_entry_linefill_permit[i]      ),
      .lfb_addr_entry_not_resp_x               (lfb_addr_entry_not_resp[i]             ),
      .lfb_addr_entry_page_nc_x                (lfb_addr_entry_page_nc[i]              ),
      .lfb_addr_entry_page_share_x             (lfb_addr_entry_page_share[i]           ),
      .lfb_addr_entry_pfu_biu_req_hit_idx_x    (lfb_addr_entry_pfu_biu_req_hit_idx[i]  ),
      .lfb_addr_entry_pfu_create_dp_vld_x      (lfb_addr_entry_pfu_create_dp_vld[i]    ),
      .lfb_addr_entry_pfu_create_vld_x         (lfb_addr_entry_pfu_create_vld[i]       ),
      .lfb_addr_entry_pfu_dcache_hit_v         (lfb_addr_entry_pfu_dcache_hit[i]       ),
      .lfb_addr_entry_pfu_dcache_miss_v        (lfb_addr_entry_pfu_dcache_miss[i]      ),
      .lfb_addr_entry_pfu_create_x             (lfb_addr_entry_pfu_create[i]           ),
      .lfb_addr_entry_pfu_id_x                 (lfb_addr_entry_pfu_id[i]               ),
      .lfb_addr_entry_pfu_id_vld_x             (lfb_addr_entry_pfu_id_vld[i]           ),
      .lfb_addr_entry_pf_type_x                (lfb_addr_entry_pf_type[i]              ),
      .lfb_addr_entry_pf_late_ld_x             (lfb_addr_entry_pf_late_ld[i]           ),
      .lfb_addr_entry_pf_late_st_x             (lfb_addr_entry_pf_late_st[i]           ),  
      .lfb_addr_entry_full_va_x                (lfb_addr_entry_full_va[i]              ),
      .lfb_addr_entry_pop_vld_x                (lfb_addr_entry_pop_vld[i]              ),
      .lfb_addr_entry_rb_biu_req_hit_idx_x     (lfb_addr_entry_rb_biu_req_hit_idx[i]   ),
      .lfb_addr_entry_rb_create_dp_vld_x       (lfb_addr_entry_rb_create_dp_vld[i]     ),
      .lfb_addr_entry_rb_create_vld_x          (lfb_addr_entry_rb_create_vld[i]        ),
      .lfb_addr_entry_rcl_done_x               (lfb_addr_entry_rcl_done[i]             ),
      .lfb_addr_entry_refill_way_x             (lfb_addr_entry_refill_way[i]           ),
      .lfb_addr_entry_resp_set_x               (lfb_addr_entry_resp_set[i]             ),
      .lfb_addr_entry_snq_bypass_hit_x         (lfb_addr_entry_snq_bypass_hit[i]       ),
      .lfb_addr_entry_st_da_hit_idx_x          (lfb_addr_entry_st_da_hit_idx[i]        ),
      .lfb_addr_entry_vb_pe_req_grnt_x         (lfb_addr_entry_vb_pe_req_grnt[i]       ),
      .lfb_addr_entry_vb_pe_req_x              (lfb_addr_entry_vb_pe_req[i]            ),
      .lfb_addr_entry_vld_x                    (lfb_addr_entry_vld[i]                  ),
      .lfb_addr_entry_wmb_read_req_hit_idx_x   (lfb_addr_entry_wmb_read_req_hit_idx[i] ),
      .lfb_addr_entry_wmb_write_req_hit_idx_x  (lfb_addr_entry_wmb_write_req_hit_idx[i]),
      .lfb_data_addr_pop_req_x                 (lfb_data_addr_pop_req[i]               ),
      .lfb_lf_sm_addr_pop_req_x                (lfb_lf_sm_addr_pop_req[i]              ),
      .lfb_create_linefill_dp                  (lfb_create_linefill_dp                 ),
      .lfb_vb_pe_req                           (lfb_vb_pe_req                          ),
      .lfb_vb_pe_req_permit                    (lfb_vb_pe_req_permit                   ),
      .lm_already_snoop                        (lm_already_snoop                       ),
      .lsu_special_clk                         (lsu_special_clk                        ),
      .pad_yy_icg_scan_en                      (pad_yy_icg_scan_en                     ),
      .pfu_biu_req_addr                        (pfu_biu_req_addr                       ),
      .pfu_lfb_full_va                         (pfu_lfb_full_va                        ),
      .pfu_lfb_id                              (pfu_lfb_id                             ),
      .pfu_lfb_pf_type                         (pfu_lfb_pf_type                        ),
      .pfu_lfb_page_share                      (pfu_lfb_page_share                     ),
      .rb_biu_req_addr                         (rb_biu_req_addr                        ),
      .rb_lfb_addr_tto4                        (rb_lfb_addr_tto4                       ),
      .rb_lfb_full_va                          (rb_lfb_full_va                         ),
      .rb_lfb_atomic                           (rb_lfb_atomic                          ),
      .rb_lfb_depd                             (rb_lfb_depd                            ),
      .rb_lfb_ldamo                            (rb_lfb_ldamo                           ),
      .rb_lfb_page_ca                          (rb_lfb_page_ca                         ),
      .rb_lfb_page_share                       (rb_lfb_page_share                      ),
      .snq_bypass_addr_tto6                    (snq_bypass_addr_tto6                   ),
      .st_da_addr                              (st_da_addr                             ),
      .st_da_cache_miss                        (st_da_cache_miss                       ),
      .vb_lfb_addr_entry_rcl_done_x            (vb_lfb_addr_entry_rcl_done[i]          ),
      .vb_lfb_dcache_dirty                     (vb_lfb_dcache_dirty                    ),
      .vb_lfb_dcache_hit                       (vb_lfb_dcache_hit                      ),
      .vb_lfb_dcache_way                       (vb_lfb_dcache_way                      ),
      .wmb_read_req_addr                       (wmb_read_req_addr                      ),
      .wmb_write_req_addr                      (wmb_write_req_addr                     )
    );
  end
endgenerate
//==========================================================
//              feedback fill info to pfu
//==========================================================
//feedback signals
assign lfb_pfu_fill_not_pf        = |(lfb_lf_sm_addr_pop_req[LFB_ADDR_ENTRY-1:0]
                                    & ~lfb_addr_entry_pfu_create[LFB_ADDR_ENTRY-1:0]);
assign lfb_pfu_fill_late_ld        = |(lfb_lf_sm_addr_pop_req[LFB_ADDR_ENTRY-1:0]
                                    & lfb_addr_entry_pf_late_ld[LFB_ADDR_ENTRY-1:0]);
assign lfb_pfu_fill_late_st        = |(lfb_lf_sm_addr_pop_req[LFB_ADDR_ENTRY-1:0]
                                    & lfb_addr_entry_pf_late_st[LFB_ADDR_ENTRY-1:0]);
always_comb begin
  lfb_pfu_fill_pf_type = 2'b0;
  lfb_pfu_fill_id = 4'b0;
  lfb_pfu_fill_id_vld = 1'b0;
  lfb_pfu_fill_pending = 1'b0;
  for (int i = 0;i < LFB_ADDR_ENTRY;i++ ) begin
    lfb_pfu_fill_pf_type        |= ({2{lfb_lf_sm_addr_pop_req[i]}}
                                    & lfb_addr_entry_pf_type[i]);
    lfb_pfu_fill_id             |= ({4{lfb_lf_sm_addr_pop_req[i]}}
                                    & lfb_addr_entry_pfu_id[i]);
    lfb_pfu_fill_id_vld         |= (lfb_lf_sm_addr_pop_req[i]
                                     & lfb_addr_entry_pfu_id_vld[i]);
    lfb_pfu_fill_pending        |= (lfb_addr_entry_vld[i] 
                                     & lfb_addr_entry_pfu_id_vld[i]);
  end
end

always_comb begin
  lfb_pfu_fill_rsrc = 2'b0;
  for (int i = 0; i < LFB_DATA_ENTRY; i++ ) begin
    lfb_pfu_fill_rsrc |= ({LFB_DATA_ENTRY{lfb_lf_sm_data_pop_req[i]}} & lfb_data_entry_rsrc[i]);
  end
end

// pass full_va to cmc/bop
assign l2_ls_req_full_va_qual = l2_ls_req_full_va & ~l2_ls_req_full_va_id[`WK_LS_DID_RST]; 
assign l2_ls_req_full_va_en   =    l2_ls_req_full_va_qual 
                                |  l2_ls_req_full_va_qual_dly1_q
                                |  ls_l2_full_va_v_dly2_q;
// full_va_v
always_ff @(posedge forever_cpuclk or negedge cpurst_b)
begin: u_l2_ls_req_full_va_qual_dly1_q
  if (!cpurst_b)
    l2_ls_req_full_va_qual_dly1_q <= {1{1'b0}};
  else if (l2_ls_req_full_va_en == 1'b1)
    l2_ls_req_full_va_qual_dly1_q <= l2_ls_req_full_va_qual;
end
always_ff @(posedge forever_cpuclk or negedge cpurst_b)
begin: u_ls_l2_full_va_v_dly2_q
  if (!cpurst_b)
    ls_l2_full_va_v_dly2_q <= {1{1'b0}};
  else if (l2_ls_req_full_va_en == 1'b1)
    ls_l2_full_va_v_dly2_q <= l2_ls_req_full_va_qual_dly1_q;
end

assign ls_l2_full_va_v = ls_l2_full_va_v_dly2_q;
// full_va
always_comb 
begin: u_l2_va_read_sel_lfb_entry_8_1_0
  l2_va_read_sel_lfb_entry[(LFB_ADDR_ENTRY-1):0] = {LFB_ADDR_ENTRY{1'b0}};
  for (integer macro_i=0; macro_i<=LFB_ADDR_ENTRY-1; macro_i=macro_i+1)
    l2_va_read_sel_lfb_entry[macro_i] = (l2_ls_req_full_va_id[(`WK_LS_DID_RST-1):0] == macro_i[`WK_LS_DID_RST-1:0]) & l2_ls_req_full_va_qual;
end
always_ff @(posedge forever_cpuclk or negedge cpurst_b)
begin: u_l2_va_read_sel_lfb_entry_dly1_q_8_1_0
  if (!cpurst_b)
    l2_va_read_sel_lfb_entry_dly1_q[(LFB_ADDR_ENTRY-1):0] <=  {LFB_ADDR_ENTRY{1'b0}};
  else if (l2_ls_req_full_va_en == 1'b1)
    l2_va_read_sel_lfb_entry_dly1_q[(LFB_ADDR_ENTRY-1):0] <=  l2_va_read_sel_lfb_entry[(LFB_ADDR_ENTRY-1):0];
end
always_comb 
begin: u_l2_read_pf_va_dly1
  l2_read_pf_va_dly1[`WK_VA_WIDTH-1:12] = {((`WK_VA_WIDTH-1)-(12)+1){1'b0}};
  for (integer macro_i=0; macro_i<=LFB_ADDR_ENTRY-1; macro_i=macro_i+1)
    l2_read_pf_va_dly1[`WK_VA_WIDTH-1:12] = l2_read_pf_va_dly1[`WK_VA_WIDTH-1:12] | ({((`WK_VA_WIDTH-1)-(12)+1){l2_va_read_sel_lfb_entry_dly1_q[macro_i]}} & lfb_addr_entry_full_va[macro_i][`WK_VA_WIDTH-1:12]);
end
always_ff @(posedge forever_cpuclk or negedge cpurst_b)
begin: u_ls_l2_full_va_dly2_q_39_12
  if (!cpurst_b)
    ls_l2_full_va_dly2_q[`WK_VA_WIDTH-1:12] <=  {`WK_VA_WIDTH-12{1'b0}};
  else if (l2_ls_req_full_va_en == 1'b1)
    ls_l2_full_va_dly2_q[`WK_VA_WIDTH-1:12] <=  l2_read_pf_va_dly1[`WK_VA_WIDTH-1:12];
end

assign ls_l2_full_va[`WK_VA_WIDTH-1:12] = ls_l2_full_va_dly2_q[`WK_VA_WIDTH-1:12]; 
assign ls_l2_full_va[`WK_VA_WIDTH] = 1'b0;
//==========================================================
//              Instance data entry
//==========================================================
//2 data entry
// &ConnRule(s/_x$/[0]/); @146
// &ConnRule(s/_v$/_0/); @147
// &Instance("xx_lsu_lfb_data_entry","x_xx_lsu_lfb_data_entry_0"); @148
xx_lsu_lfb_data_entry  x_xx_lsu_lfb_data_entry_0 (
  .biu_lsu_r_data                      (biu_lsu_r_data                     ),
  .biu_lsu_r_user                      (biu_lsu_r_user                     ),
  .biu_lsu_r_last                      (biu_lsu_r_last                     ),
  .biu_lsu_r_vld                       (biu_lsu_r_vld                      ),
  .cp0_lsu_dcache_en                   (cp0_lsu_dcache_en                  ),
  .cp0_lsu_icg_en                      (cp0_lsu_icg_en                     ),
  .cpurst_b                            (cpurst_b                           ),
  .lfb_addr_entry_linefill_abort       (lfb_addr_entry_linefill_abort      ),
  .lfb_addr_entry_linefill_permit      (lfb_addr_entry_linefill_permit     ),
  .lfb_biu_id_2to0                     (lfb_biu_id_2to0                    ),
  .lfb_biu_r_id_hit                    (lfb_biu_r_id_hit                   ),
  .lfb_data_entry_addr_id_v            (lfb_data_entry_addr_id_0           ),
  .lfb_data_entry_addr_pop_req_v       (lfb_data_entry_addr_pop_req_0      ),
  .lfb_data_entry_create_dp_vld_x      (lfb_data_entry_create_dp_vld[0]    ),
  .lfb_data_entry_create_gateclk_en_x  (lfb_data_entry_create_gateclk_en[0]),
  .lfb_data_entry_create_vld_x         (lfb_data_entry_create_vld[0]       ),
  .lfb_data_entry_data_v               (lfb_data_entry_data_0              ),
  .lfb_data_entry_dcache_share_x       (lfb_data_entry_dcache_share[0]     ),
  .lfb_data_entry_full_x               (lfb_data_entry_full[0]             ),
  .lfb_data_entry_rsrc_x               (lfb_data_entry_rsrc[0]             ),
  .lfb_data_entry_last_x               (lfb_data_entry_last[0]             ),
  .lfb_data_entry_lf_sm_req_x          (lfb_data_entry_lf_sm_req[0]        ),
  .lfb_data_entry_vld_x                (lfb_data_entry_vld[0]              ),
  .lfb_data_entry_wait_surplus_x       (lfb_data_entry_wait_surplus[0]     ),
  .lfb_first_pass_ptr                  (lfb_first_pass_ptr                 ),
  .lfb_lf_sm_data_grnt_x               (lfb_lf_sm_data_grnt[0]             ),
  .lfb_lf_sm_data_pop_req_x            (lfb_lf_sm_data_pop_req[0]          ),
  .lfb_r_resp_err                      (lfb_r_resp_err                     ),
  .lfb_r_resp_share                    (lfb_r_resp_share                   ),
  .lsu_special_clk                     (lsu_special_clk                    ),
  .pad_yy_icg_scan_en                  (pad_yy_icg_scan_en                 ),
  .snq_lfb_bypass_chg_tag_x            (snq_lfb_bypass_chg_tag[0]          ),
  .snq_lfb_bypass_invalid_x            (snq_lfb_bypass_invalid[0]          )
);


// &ConnRule(s/_x$/[1]/); @150
// &ConnRule(s/_v$/_1/); @151
// &Instance("xx_lsu_lfb_data_entry","x_xx_lsu_lfb_data_entry_1"); @152
xx_lsu_lfb_data_entry  x_xx_lsu_lfb_data_entry_1 (
  .biu_lsu_r_data                      (biu_lsu_r_data                     ),
  .biu_lsu_r_user                      (biu_lsu_r_user                     ),
  .biu_lsu_r_last                      (biu_lsu_r_last                     ),
  .biu_lsu_r_vld                       (biu_lsu_r_vld                      ),
  .cp0_lsu_dcache_en                   (cp0_lsu_dcache_en                  ),
  .cp0_lsu_icg_en                      (cp0_lsu_icg_en                     ),
  .cpurst_b                            (cpurst_b                           ),
  .lfb_addr_entry_linefill_abort       (lfb_addr_entry_linefill_abort      ),
  .lfb_addr_entry_linefill_permit      (lfb_addr_entry_linefill_permit     ),
  .lfb_biu_id_2to0                     (lfb_biu_id_2to0                    ),
  .lfb_biu_r_id_hit                    (lfb_biu_r_id_hit                   ),
  .lfb_data_entry_addr_id_v            (lfb_data_entry_addr_id_1           ),
  .lfb_data_entry_addr_pop_req_v       (lfb_data_entry_addr_pop_req_1      ),
  .lfb_data_entry_create_dp_vld_x      (lfb_data_entry_create_dp_vld[1]    ),
  .lfb_data_entry_create_gateclk_en_x  (lfb_data_entry_create_gateclk_en[1]),
  .lfb_data_entry_create_vld_x         (lfb_data_entry_create_vld[1]       ),
  .lfb_data_entry_data_v               (lfb_data_entry_data_1              ),
  .lfb_data_entry_dcache_share_x       (lfb_data_entry_dcache_share[1]     ),
  .lfb_data_entry_full_x               (lfb_data_entry_full[1]             ),
  .lfb_data_entry_rsrc_x               (lfb_data_entry_rsrc[1]             ),
  .lfb_data_entry_last_x               (lfb_data_entry_last[1]             ),
  .lfb_data_entry_lf_sm_req_x          (lfb_data_entry_lf_sm_req[1]        ),
  .lfb_data_entry_vld_x                (lfb_data_entry_vld[1]              ),
  .lfb_data_entry_wait_surplus_x       (lfb_data_entry_wait_surplus[1]     ),
  .lfb_first_pass_ptr                  (lfb_first_pass_ptr                 ),
  .lfb_lf_sm_data_grnt_x               (lfb_lf_sm_data_grnt[1]             ),
  .lfb_lf_sm_data_pop_req_x            (lfb_lf_sm_data_pop_req[1]          ),
  .lfb_r_resp_err                      (lfb_r_resp_err                     ),
  .lfb_r_resp_share                    (lfb_r_resp_share                   ),
  .lsu_special_clk                     (lsu_special_clk                    ),
  .pad_yy_icg_scan_en                  (pad_yy_icg_scan_en                 ),
  .snq_lfb_bypass_chg_tag_x            (snq_lfb_bypass_chg_tag[1]          ),
  .snq_lfb_bypass_invalid_x            (snq_lfb_bypass_invalid[1]          )
);



//==========================================================
//            Generate addr signal
//==========================================================
//------------------create ptr------------------------------
// &CombBeg; @159
// always @( lfb_addr_entry_vld[7:0])
// begin
// lfb_addr_create_ptr[LFB_ADDR_ENTRY-1:0]   = {LFB_ADDR_ENTRY{1'b0}};
// casez(lfb_addr_entry_vld[LFB_ADDR_ENTRY-1:0])
//   8'b????_???0:lfb_addr_create_ptr[0]  = 1'b1;
//   8'b????_??01:lfb_addr_create_ptr[1]  = 1'b1;
//   8'b????_?011:lfb_addr_create_ptr[2]  = 1'b1;
//   8'b????_0111:lfb_addr_create_ptr[3]  = 1'b1;
//   8'b???0_1111:lfb_addr_create_ptr[4]  = 1'b1;
//   8'b??01_1111:lfb_addr_create_ptr[5]  = 1'b1;
//   8'b?011_1111:lfb_addr_create_ptr[6]  = 1'b1;
//   8'b0111_1111:lfb_addr_create_ptr[7]  = 1'b1;
//   default:lfb_addr_create_ptr[LFB_ADDR_ENTRY-1:0]   = {LFB_ADDR_ENTRY{1'b0}};
// endcase
// // &CombEnd; @172
// end
assign lfb_addr_create_ptr[0] = ~lfb_addr_entry_vld[0];
generate
  for(i=1; i<LFB_ADDR_ENTRY; i++)
    assign lfb_addr_create_ptr[i] = ~lfb_addr_entry_vld[i] & (&lfb_addr_entry_vld[i-1:0]);
endgenerate

//------------------grnt signal to lfb/pfu------------------
assign lfb_rb_create_grnt   = bus_arb_rb_ar_sel &&  rb_lfb_create_req;
assign lfb_pfu_create_grnt  = bus_arb_pfu_ar_sel  &&  pfu_lfb_create_req;

// &Instance("wk_rtu_encode_8","x_lsu_lfb_create_ptr_encode"); @179
// wk_rtu_encode_8  x_lsu_lfb_create_ptr_encode (
//   .x_num                    (lfb_create_id[2:0]      ),
//   .x_num_expand             (lfb_addr_create_ptr[7:0])
// );
wk_rtu_encode #(.REG_N(LFB_ADDR_ENTRY), .REG($clog2(LFB_ADDR_ENTRY)))
x_lsu_lfb_create_ptr_encode(
  .x_num                    (lfb_create_id[$clog2(LFB_ADDR_ENTRY)-1:0]      ),
  .x_num_expand             (lfb_addr_create_ptr[LFB_ADDR_ENTRY-1:0])
);
// &Connect( .x_num          (lfb_create_id[2:0]   ), @180
//           .x_num_expand   (lfb_addr_create_ptr[7:0]   )); @181

assign lfb_rb_create_id[4:0]  = {BIU_LFB_ID_T,lfb_create_id[$clog2(LFB_ADDR_ENTRY)-1:0]};
assign lfb_pfu_create_id[4:0] = {BIU_LFB_ID_T,lfb_create_id[$clog2(LFB_ADDR_ENTRY)-1:0]};
//------------------create signal---------------------------
assign lfb_addr_rb_create_vld           = lfb_rb_create_grnt  &&  rb_lfb_create_vld;
assign lfb_addr_rb_create_dp_vld        = lfb_rb_create_grnt  &&  rb_lfb_create_dp_vld;
assign lfb_addr_pfu_create_vld          = lfb_pfu_create_grnt &&  pfu_lfb_create_vld;
assign lfb_addr_pfu_create_dp_vld       = lfb_pfu_create_grnt &&  pfu_lfb_create_dp_vld;

assign lfb_addr_entry_rb_create_vld[LFB_ADDR_ENTRY-1:0]         = {LFB_ADDR_ENTRY{lfb_addr_rb_create_vld}}
                                                                  & lfb_addr_create_ptr[LFB_ADDR_ENTRY-1:0];

assign lfb_addr_entry_rb_create_dp_vld[LFB_ADDR_ENTRY-1:0]      = {LFB_ADDR_ENTRY{lfb_addr_rb_create_dp_vld}}
                                                                  & lfb_addr_create_ptr[LFB_ADDR_ENTRY-1:0];

assign lfb_addr_entry_pfu_create_vld[LFB_ADDR_ENTRY-1:0]        = {LFB_ADDR_ENTRY{lfb_addr_pfu_create_vld}}
                                                                  & lfb_addr_create_ptr[LFB_ADDR_ENTRY-1:0];

assign lfb_addr_entry_pfu_create_dp_vld[LFB_ADDR_ENTRY-1:0]     = {LFB_ADDR_ENTRY{lfb_addr_pfu_create_dp_vld}}
                                                                  & lfb_addr_create_ptr[LFB_ADDR_ENTRY-1:0];

assign lfb_addr_entry_create_gateclk_en[LFB_ADDR_ENTRY-1:0]     = {LFB_ADDR_ENTRY{rb_lfb_create_gateclk_en
                                                                                  ||  pfu_lfb_create_gateclk_en}}
                                                                  & lfb_addr_create_ptr[LFB_ADDR_ENTRY-1:0];

//==========================================================
//                Request vb addr entry
//==========================================================
//-------------------pop entry------------------------------
always @(posedge lfb_vb_pe_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    lfb_vb_req_unmask       <=  1'b0;
  else if(lfb_vb_pe_all_req)
    lfb_vb_req_unmask       <=  1'b1;
  else if(lfb_create_vb_success || lfb_create_vb_cancel)
    lfb_vb_req_unmask       <=  1'b0;
end

always @(posedge lfb_vb_pe_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    lfb_vb_addr_ptr[LFB_ADDR_ENTRY-1:0] <= {LFB_ADDR_ENTRY{1'b0}};
    lfb_vb_addr_tto6[`WK_PA_WIDTH-7:0]     <=  {`WK_PA_WIDTH-6{1'b0}};
  end
  else if(lfb_vb_pe_req_permit &&  lfb_vb_pe_req)
  begin
    lfb_vb_addr_ptr[LFB_ADDR_ENTRY-1:0] <=  lfb_vb_pe_req_ptr[LFB_ADDR_ENTRY-1:0];
    lfb_vb_addr_tto6[`WK_PA_WIDTH-7:0]     <=  lfb_vb_pe_req_addr_tto6[`WK_PA_WIDTH-7:0];
  end
  else if(lfb_vb_pe_req_permit &&  lfb_vb_pe_rb_req)
  begin
    lfb_vb_addr_ptr[LFB_ADDR_ENTRY-1:0] <=  lfb_addr_create_ptr[LFB_ADDR_ENTRY-1:0];
    lfb_vb_addr_tto6[`WK_PA_WIDTH-7:0]     <=  rb_lfb_addr_tto4[`WK_PA_WIDTH-5:2];
  end
  else if(lfb_vb_pe_req_permit &&  lfb_vb_pe_pfu_req)
  begin
    lfb_vb_addr_ptr[LFB_ADDR_ENTRY-1:0] <=  lfb_addr_create_ptr[LFB_ADDR_ENTRY-1:0];
    lfb_vb_addr_tto6[`WK_PA_WIDTH-7:0]     <=  pfu_biu_req_addr[`WK_PA_WIDTH-1:6];
  end
end

//-----------------pop req signal---------------------------
assign lfb_vb_pe_rb_req      = cp0_lsu_dcache_en
                                &&  rb_lfb_page_ca
                                &&  lfb_addr_rb_create_vld;

assign lfb_vb_pe_pfu_req     = lfb_addr_pfu_create_vld;

assign lfb_vb_pe_req         = |lfb_addr_entry_vb_pe_req[LFB_ADDR_ENTRY-1:0];

assign lfb_vb_pe_all_req     = lfb_vb_pe_req
                                ||  lfb_vb_pe_rb_req
                                ||  lfb_vb_pe_pfu_req;

//------------------permit signal---------------------------
assign lfb_vb_pe_req_permit  = !lfb_vb_req_unmask
                                ||  lfb_create_vb_cancel
                                ||  lfb_create_vb_success;

//------------------request ptr-----------------------------

//use static arbitrate
// &CombBeg; @266
// always @( lfb_addr_entry_vb_pe_req[7:0])
// begin
// lfb_vb_pe_req_ptr[LFB_ADDR_ENTRY-1:0]  = {LFB_ADDR_ENTRY{1'b0}};
// casez(lfb_addr_entry_vb_pe_req[LFB_ADDR_ENTRY-1:0])
//   8'b????_???1:lfb_vb_pe_req_ptr[0]  = 1'b1;
//   8'b????_??10:lfb_vb_pe_req_ptr[1]  = 1'b1;
//   8'b????_?100:lfb_vb_pe_req_ptr[2]  = 1'b1;
//   8'b????_1000:lfb_vb_pe_req_ptr[3]  = 1'b1;
//   8'b???1_0000:lfb_vb_pe_req_ptr[4]  = 1'b1;
//   8'b??10_0000:lfb_vb_pe_req_ptr[5]  = 1'b1;
//   8'b?100_0000:lfb_vb_pe_req_ptr[6]  = 1'b1;
//   8'b1000_0000:lfb_vb_pe_req_ptr[7]  = 1'b1;
//   default:lfb_vb_pe_req_ptr[LFB_ADDR_ENTRY-1:0]  = {LFB_ADDR_ENTRY{1'b0}};
// endcase
// // &CombEnd; @279
// end
assign lfb_vb_pe_req_ptr[0] = lfb_addr_entry_vb_pe_req[0];
generate
  for(i=1; i<LFB_ADDR_ENTRY; i++)
    assign lfb_vb_pe_req_ptr[i] = lfb_addr_entry_vb_pe_req[i] & ~(|lfb_addr_entry_vb_pe_req[i-1:0]);
endgenerate

// assign lfb_vb_pe_req_addr_tto6[`WK_PA_WIDTH-7:0] = 
//                   {`WK_PA_WIDTH-6{lfb_vb_pe_req_ptr[0]}}  & lfb_addr_entry_addr_tto4[0][`WK_PA_WIDTH-5:2]
//                 | {`WK_PA_WIDTH-6{lfb_vb_pe_req_ptr[1]}}  & lfb_addr_entry_addr_tto4[1][`WK_PA_WIDTH-5:2]
//                 | {`WK_PA_WIDTH-6{lfb_vb_pe_req_ptr[2]}}  & lfb_addr_entry_addr_tto4[2][`WK_PA_WIDTH-5:2]
//                 | {`WK_PA_WIDTH-6{lfb_vb_pe_req_ptr[3]}}  & lfb_addr_entry_addr_tto4[3][`WK_PA_WIDTH-5:2]
//                 | {`WK_PA_WIDTH-6{lfb_vb_pe_req_ptr[4]}}  & lfb_addr_entry_addr_tto4[4][`WK_PA_WIDTH-5:2]
//                 | {`WK_PA_WIDTH-6{lfb_vb_pe_req_ptr[5]}}  & lfb_addr_entry_addr_tto4[5][`WK_PA_WIDTH-5:2]
//                 | {`WK_PA_WIDTH-6{lfb_vb_pe_req_ptr[6]}}  & lfb_addr_entry_addr_tto4[6][`WK_PA_WIDTH-5:2]
//                 | {`WK_PA_WIDTH-6{lfb_vb_pe_req_ptr[7]}}  & lfb_addr_entry_addr_tto4[7][`WK_PA_WIDTH-5:2];
generate
  for(i=0; i<`WK_PA_WIDTH-6; i++) begin 
    wire [LFB_ADDR_ENTRY-1:0] gen_tto4;
    for(j=0; j<LFB_ADDR_ENTRY; j++)begin 
      assign gen_tto4[j] = lfb_addr_entry_addr_tto4[j][i+2] & lfb_vb_pe_req_ptr[j];
    end
    assign lfb_vb_pe_req_addr_tto6[i] = |gen_tto4[LFB_ADDR_ENTRY-1:0];
  end
endgenerate
//-------------------pop grnt signal------------------------
assign lfb_addr_entry_vb_pe_req_grnt[LFB_ADDR_ENTRY-1:0] = {LFB_ADDR_ENTRY{lfb_vb_pe_req_permit}}
                                                            & lfb_vb_pe_req_ptr[LFB_ADDR_ENTRY-1:0];
//-------------------request signal-------------------------
//assign lfb_vb_req_biu_resp        = |(lfb_vb_addr_ptr[LFB_ADDR_ENTRY-1:0]  & lfb_addr_entry_resp[LFB_ADDR_ENTRY-1:0]);
assign lfb_vb_req_ldamo           = |(lfb_vb_addr_ptr[LFB_ADDR_ENTRY-1:0]  & lfb_addr_entry_ldamo[LFB_ADDR_ENTRY-1:0]);
assign lfb_vb_req_hit_idx         = vb_lfb_vb_req_hit_idx
                                    ||  snq_create_lfb_vb_req_hit_idx
                                        &&  !(lfb_vb_req_ldamo && lm_state_is_amo_lock)
                                    ||  snq_lfb_vb_req_hit_idx;
//req signal is for arbitration
assign lfb_vb_create_req          = lfb_vb_req_unmask;
// &Force("output","lfb_vb_create_vld"); @303
assign lfb_vb_create_vld          = lfb_vb_req_unmask
                                    &&  !lfb_vb_req_hit_idx;
assign lfb_vb_create_dp_vld       = lfb_vb_req_unmask;
assign lfb_vb_create_gateclk_en   = lfb_vb_req_unmask;

// &Instance("wk_rtu_encode_8","x_lsu_lfb_vb_pe_req_ptr_encode"); @309
// wk_rtu_encode_8  x_lsu_lfb_vb_pe_req_ptr_encode (
//   .x_num                (lfb_vb_id[2:0]      ),
//   .x_num_expand         (lfb_vb_addr_ptr[7:0])
// );
wk_rtu_encode #(.REG_N(LFB_ADDR_ENTRY), .REG($clog2(LFB_ADDR_ENTRY)))
x_lsu_lfb_vb_pe_req_ptr_encode(
  .x_num                (lfb_vb_id[$clog2(LFB_ADDR_ENTRY)-1:0]      ),
  .x_num_expand         (lfb_vb_addr_ptr[LFB_ADDR_ENTRY-1:0])
);
// &Connect( .x_num          (lfb_vb_id[2:0]       ), @310
//           .x_num_expand   (lfb_vb_addr_ptr[7:0] )); @311

assign lfb_create_vb_success    = lfb_vb_create_vld &&  vb_lfb_create_grnt;

//when snq invalid lfb,should cancel vb req
assign lfb_vb_req_entry_vld     = |(lfb_vb_addr_ptr[LFB_ADDR_ENTRY-1:0] & lfb_addr_entry_vld[LFB_ADDR_ENTRY-1:0]);
assign lfb_create_vb_cancel     = lfb_vb_req_unmask
                                  && !lfb_vb_req_entry_vld; 
//==========================================================
//            Reply dcache hit signal to pfu
//==========================================================
// &Force("output","lfb_pfu_dcache_hit"); @322
// assign lfb_pfu_dcache_hit[8:0]  =   lfb_addr_entry_pfu_dcache_hit[0][8:0]
//                                   | lfb_addr_entry_pfu_dcache_hit[1][8:0]
//                                   | lfb_addr_entry_pfu_dcache_hit[2][8:0]
//                                   | lfb_addr_entry_pfu_dcache_hit[3][8:0]
//                                   | lfb_addr_entry_pfu_dcache_hit[4][8:0]
//                                   | lfb_addr_entry_pfu_dcache_hit[5][8:0]
//                                   | lfb_addr_entry_pfu_dcache_hit[6][8:0]
//                                   | lfb_addr_entry_pfu_dcache_hit[7][8:0];

// // &Force("output","lfb_pfu_dcache_hit"); @332
// assign lfb_pfu_dcache_miss[8:0] =   lfb_addr_entry_pfu_dcache_miss[0][8:0]
//                                   | lfb_addr_entry_pfu_dcache_miss[1][8:0]
//                                   | lfb_addr_entry_pfu_dcache_miss[2][8:0]
//                                   | lfb_addr_entry_pfu_dcache_miss[3][8:0]
//                                   | lfb_addr_entry_pfu_dcache_miss[4][8:0]
//                                   | lfb_addr_entry_pfu_dcache_miss[5][8:0]
//                                   | lfb_addr_entry_pfu_dcache_miss[6][8:0]
//                                   | lfb_addr_entry_pfu_dcache_miss[7][8:0];
generate
  for(i=0; i<9; i++)begin 
    wire [LFB_ADDR_ENTRY-1:0] laepd_hit;
    for(j=0; j<LFB_ADDR_ENTRY; j++) 
      assign laepd_hit[j] = lfb_addr_entry_pfu_dcache_hit[j][i];
    assign lfb_pfu_dcache_hit[i] = |laepd_hit[LFB_ADDR_ENTRY-1:0];
  end
endgenerate

generate
  for(i=0; i<9; i++)begin 
    wire [LFB_ADDR_ENTRY-1:0] laepd_miss;
    for(j=0; j<LFB_ADDR_ENTRY; j++)
      assign laepd_miss[j] = lfb_addr_entry_pfu_dcache_miss[j][i];
    assign lfb_pfu_dcache_miss[i] = |laepd_miss[LFB_ADDR_ENTRY-1:0];
  end
endgenerate
//==========================================================
//                Pass data to data entry
//==========================================================
//------------------judge r signal--------------------------
//----------r id------------------------
assign lfb_biu_r_id_hit     = biu_lsu_r_vld
                              &&  (biu_lsu_r_id[4] ==  BIU_LFB_ID_T);
                              // &&  (biu_lsu_r_id[4:3] ==  BIU_LFB_ID_T);
assign lfb_biu_id_2to0[$clog2(LFB_ADDR_ENTRY)-1:0] = biu_lsu_r_id[$clog2(LFB_ADDR_ENTRY)-1:0];
// assign lfb_biu_id_2to0[2:0] = biu_lsu_r_id[2:0];

assign lfb_addr_entry_resp_set[LFB_ADDR_ENTRY-1:0]  = 
                {LFB_ADDR_ENTRY{lfb_biu_r_id_hit && lfb_data_not_full}}
                & lfb_r_id_hit_addr_ptr[LFB_ADDR_ENTRY-1:0];
//----------r resp----------------------
// &Force("bus","biu_lsu_r_resp",3,0); @355
assign lfb_r_resp_share     = biu_lsu_r_resp[3];
assign lfb_r_resp_err       = (biu_lsu_r_resp[1:0] ==  DECERR)
                              ||  (biu_lsu_r_resp[1:0] ==  SLVERR);

//------------------create ptr------------------------------
// &CombBeg; @361
always @( lfb_data_entry_vld[1:0])
begin
lfb_data_create_ptr[LFB_DATA_ENTRY-1:0]   = {LFB_DATA_ENTRY{1'b0}};
casez(lfb_data_entry_vld[LFB_DATA_ENTRY-1:0])
  2'b?0:lfb_data_create_ptr[0]  = 1'b1;
  2'b01:lfb_data_create_ptr[1]  = 1'b1;
  default:lfb_data_create_ptr[LFB_DATA_ENTRY-1:0]   = {LFB_DATA_ENTRY{1'b0}};
endcase
// &CombEnd; @368
end
//------------------create signal---------------------------
//if no vld, or only one vld and full, then create
assign lfb_data_wait_surplus  = |lfb_data_entry_wait_surplus[LFB_DATA_ENTRY-1:0];


assign lfb_data_create_vld          = lfb_biu_r_id_hit
                                      &&  !lfb_data_wait_surplus;
assign lfb_data_create_dp_vld       = lfb_data_create_vld;
assign lfb_data_create_gateclk_en   = lfb_data_create_vld;

assign lfb_data_entry_create_vld[LFB_DATA_ENTRY-1:0]        = {LFB_DATA_ENTRY{lfb_data_create_vld}}
                                                              & lfb_data_create_ptr[LFB_DATA_ENTRY-1:0];

assign lfb_data_entry_create_dp_vld[LFB_DATA_ENTRY-1:0]     = {LFB_DATA_ENTRY{lfb_data_create_dp_vld}}
                                                              & lfb_data_create_ptr[LFB_DATA_ENTRY-1:0];

assign lfb_data_entry_create_gateclk_en[LFB_DATA_ENTRY-1:0] = {LFB_DATA_ENTRY{lfb_data_create_gateclk_en}}
                                                                & lfb_data_create_ptr[LFB_DATA_ENTRY-1:0];

//------------------first pass ptr--------------------------
// &CombBeg; @389
// always @( lfb_biu_id_2to0[2:0])
// begin
// lfb_r_id_hit_addr_ptr[LFB_ADDR_ENTRY-1:0] = {LFB_ADDR_ENTRY{1'b0}};
// case(lfb_biu_id_2to0[2:0])
//   3'd0:lfb_r_id_hit_addr_ptr[0] = 1'b1;
//   3'd1:lfb_r_id_hit_addr_ptr[1] = 1'b1;
//   3'd2:lfb_r_id_hit_addr_ptr[2] = 1'b1;
//   3'd3:lfb_r_id_hit_addr_ptr[3] = 1'b1;
//   3'd4:lfb_r_id_hit_addr_ptr[4] = 1'b1;
//   3'd5:lfb_r_id_hit_addr_ptr[5] = 1'b1;
//   3'd6:lfb_r_id_hit_addr_ptr[6] = 1'b1;
//   3'd7:lfb_r_id_hit_addr_ptr[7] = 1'b1;
//   default:lfb_r_id_hit_addr_ptr[LFB_ADDR_ENTRY-1:0] = {LFB_ADDR_ENTRY{1'b0}};
// endcase
// // &CombEnd; @402
// end

wk_rtu_expand #(.DEPTH(LFB_ADDR_ENTRY), .WIDTH($clog2(LFB_ADDR_ENTRY)))
lfb_rid_expand(
  .x_num        (lfb_biu_id_2to0),
  .x_num_expand (lfb_r_id_hit_addr_ptr)
);

// assign lfb_pass_addr_5to4[1:0]  =   {2{lfb_r_id_hit_addr_ptr[0]}} & lfb_addr_entry_addr_tto4[0][1:0]
//                                   | {2{lfb_r_id_hit_addr_ptr[1]}} & lfb_addr_entry_addr_tto4[1][1:0]
//                                   | {2{lfb_r_id_hit_addr_ptr[2]}} & lfb_addr_entry_addr_tto4[2][1:0]
//                                   | {2{lfb_r_id_hit_addr_ptr[3]}} & lfb_addr_entry_addr_tto4[3][1:0]
//                                   | {2{lfb_r_id_hit_addr_ptr[4]}} & lfb_addr_entry_addr_tto4[4][1:0]
//                                   | {2{lfb_r_id_hit_addr_ptr[5]}} & lfb_addr_entry_addr_tto4[5][1:0]
//                                   | {2{lfb_r_id_hit_addr_ptr[6]}} & lfb_addr_entry_addr_tto4[6][1:0]
//                                   | {2{lfb_r_id_hit_addr_ptr[7]}} & lfb_addr_entry_addr_tto4[7][1:0];
generate
  for(i=0; i<2; i++)begin 
    wire [LFB_ADDR_ENTRY-1:0] gen_tto4;
    for(j=0; j<LFB_ADDR_ENTRY; j++)begin 
      assign gen_tto4[j] = lfb_addr_entry_addr_tto4[j][i] & lfb_r_id_hit_addr_ptr[j];
    end
    assign lfb_pass_addr_5to4[i] = |gen_tto4[LFB_ADDR_ENTRY-1:0];
  end
endgenerate
//lfb first pass ptr is used to assign data_entry pass_ptr
// &CombBeg; @414
always @( lfb_pass_addr_5to4[1:0])
begin
lfb_first_pass_ptr[1:0]  = 2'b0;
case(lfb_pass_addr_5to4[1])
  1'd0:lfb_first_pass_ptr[0]  = 1'b1;
  1'd1:lfb_first_pass_ptr[1]  = 1'b1;
  default:lfb_first_pass_ptr[1:0]  = 2'b0;
endcase
// &CombEnd; @423
end

//==========================================================
//                Linefill state machine
//==========================================================
//----------------------registers---------------------------
//+-----+
//| vld |
//+-----+
always @(posedge lfb_lf_sm_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    lfb_lf_sm_vld       <=  1'b0;
  else if(lfb_lf_sm_req)
    lfb_lf_sm_vld       <=  1'b1;
  else if(lfb_lf_sm_cnt)
    lfb_lf_sm_vld       <=  1'b0;
end

//+------------+---------+---------+------+
//| refill way | addr_id | data_id | addr |
//+------------+---------+---------+------+
always @(posedge lfb_lf_sm_req_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    lfb_lf_sm_dcache_share                <=  1'b0;
    lfb_lf_sm_page_share                  <=  1'b0;
    lfb_lf_sm_refill_way                  <=  {`WK_LS_DCACHE_WAYIDX_WIDTH{1'b0}};
    lfb_lf_sm_addr_id[LFB_ADDR_ENTRY-1:0] <=  {LFB_ADDR_ENTRY{1'b0}};
    lfb_lf_sm_data_id[LFB_DATA_ENTRY-1:0] <=  {LFB_DATA_ENTRY{1'b0}};
    lfb_lf_sm_addr_tto6[`WK_PA_WIDTH-7:0] <=  {`WK_PA_WIDTH-6{1'b0}};
  end
  else if(lfb_lf_sm_req  &&  lfb_lf_sm_permit)
  begin
    lfb_lf_sm_dcache_share                <=  lfb_lf_sm_data_dcache_share;
    lfb_lf_sm_page_share                  <=  lfb_lf_sm_req_page_share;
    lfb_lf_sm_refill_way                  <=  lfb_lf_sm_req_refill_way;
    lfb_lf_sm_addr_id[LFB_ADDR_ENTRY-1:0] <=  lfb_lf_sm_req_addr_ptr[LFB_ADDR_ENTRY-1:0];
    lfb_lf_sm_data_id[LFB_DATA_ENTRY-1:0] <=  lfb_lf_sm_req_data_ptr[LFB_DATA_ENTRY-1:0];
    lfb_lf_sm_addr_tto6[`WK_PA_WIDTH-7:0] <=  lfb_lf_sm_req_addr_tto6[`WK_PA_WIDTH-7:0];
  end
end

xx_lsu_expand #(.RBENTRY(`WK_LS_DCACHE_WAYS_NUM)) refill_way_expand (
  .x_num        (lfb_lf_sm_refill_way),
  .x_num_expand (lfb_lf_sm_refill_way_expand)
);
//+-----+------+
//| cnt | bias |
//+-----+------+
//cnt is used for control path, bias is used for data path
always @(posedge lfb_lf_sm_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    lfb_lf_sm_cnt                         <=  1'b0;
  else if(lfb_lf_sm_create_vld)
    lfb_lf_sm_cnt                         <=  1'b0;
  else if(dcache_arb_lfb_ld_grnt)
    lfb_lf_sm_cnt                         <=  !lfb_lf_sm_cnt;
end

//------------------create singal---------------------------
assign lfb_lf_sm_permit     = !lfb_lf_sm_vld ||  lfb_lf_sm_cnt;
assign lfb_lf_sm_req        = |lfb_data_entry_lf_sm_req[LFB_DATA_ENTRY-1:0];
assign lfb_lf_sm_create_vld = lfb_lf_sm_req
                              &&  lfb_lf_sm_permit;

//------------------create info-----------------------------
// &CombBeg; @488
always @( lfb_data_entry_lf_sm_req[1:0])
begin
lfb_lf_sm_req_data_ptr[LFB_DATA_ENTRY-1:0] = {LFB_DATA_ENTRY{1'b0}};
casez(lfb_data_entry_lf_sm_req[LFB_DATA_ENTRY-1:0])
  2'b?1:lfb_lf_sm_req_data_ptr[0] = 1'b1;
  2'b10:lfb_lf_sm_req_data_ptr[1] = 1'b1;
  default:lfb_lf_sm_req_data_ptr[LFB_DATA_ENTRY-1:0] = {LFB_DATA_ENTRY{1'b0}};
endcase
// &CombEnd; @495
end

assign lfb_lf_sm_data_grnt[LFB_DATA_ENTRY-1:0]  = {LFB_DATA_ENTRY{lfb_lf_sm_create_vld}}
                                                  & lfb_lf_sm_req_data_ptr[LFB_DATA_ENTRY-1:0];

assign lfb_lf_sm_req_addr_ptr[LFB_ADDR_ENTRY-1:0] = {LFB_ADDR_ENTRY{lfb_lf_sm_req_data_ptr[0]}}
                                                      & lfb_data_entry_addr_id_0[LFB_ADDR_ENTRY-1:0]
                                                    | {LFB_ADDR_ENTRY{lfb_lf_sm_req_data_ptr[1]}}
                                                      & lfb_data_entry_addr_id_1[LFB_ADDR_ENTRY-1:0];

// assign lfb_lf_sm_req_addr_tto6[`WK_PA_WIDTH-7:0]  =
//                   {`WK_PA_WIDTH-6{lfb_lf_sm_req_addr_ptr[0]}}  & lfb_addr_entry_addr_tto4[0][`WK_PA_WIDTH-5:2]
//                 | {`WK_PA_WIDTH-6{lfb_lf_sm_req_addr_ptr[1]}}  & lfb_addr_entry_addr_tto4[1][`WK_PA_WIDTH-5:2]
//                 | {`WK_PA_WIDTH-6{lfb_lf_sm_req_addr_ptr[2]}}  & lfb_addr_entry_addr_tto4[2][`WK_PA_WIDTH-5:2]
//                 | {`WK_PA_WIDTH-6{lfb_lf_sm_req_addr_ptr[3]}}  & lfb_addr_entry_addr_tto4[3][`WK_PA_WIDTH-5:2]
//                 | {`WK_PA_WIDTH-6{lfb_lf_sm_req_addr_ptr[4]}}  & lfb_addr_entry_addr_tto4[4][`WK_PA_WIDTH-5:2]
//                 | {`WK_PA_WIDTH-6{lfb_lf_sm_req_addr_ptr[5]}}  & lfb_addr_entry_addr_tto4[5][`WK_PA_WIDTH-5:2]
//                 | {`WK_PA_WIDTH-6{lfb_lf_sm_req_addr_ptr[6]}}  & lfb_addr_entry_addr_tto4[6][`WK_PA_WIDTH-5:2]
//                 | {`WK_PA_WIDTH-6{lfb_lf_sm_req_addr_ptr[7]}}  & lfb_addr_entry_addr_tto4[7][`WK_PA_WIDTH-5:2];
generate
  for(i=0; i<`WK_PA_WIDTH-6; i++)begin 
    wire [LFB_ADDR_ENTRY-1:0] gen_tto4;
    for(j=0; j<LFB_ADDR_ENTRY; j++)begin 
      assign gen_tto4[j] = lfb_addr_entry_addr_tto4[j][i+2] & lfb_lf_sm_req_addr_ptr[j];
    end
    assign lfb_lf_sm_req_addr_tto6[i] = |gen_tto4[LFB_ADDR_ENTRY-1:0];
  end
endgenerate

generate
  for(i=0; i<`NUM_LD+`NUM_LS; i=i+1) begin
  
assign lfb_lf_sm_req_depd[i]           = |(lfb_lf_sm_req_addr_ptr[LFB_ADDR_ENTRY-1:0]  & lfb_addr_entry_depd_trans[i][LFB_ADDR_ENTRY-1:0]);
//------------------refill wakeup req-----------------------
assign lfb_lf_sm_refill_wakeup[i]      = lfb_lf_sm_req_depd[i]
                                      &&  lfb_lf_sm_create_vld;
  end 
endgenerate

// assign lfb_lf_sm_req_depd           = |(lfb_lf_sm_req_addr_ptr[LFB_ADDR_ENTRY-1:0]  & lfb_addr_entry_depd[LFB_ADDR_ENTRY-1:0]);
always_comb begin 
  lfb_lf_sm_req_refill_way = {`WK_LS_DCACHE_WAYIDX_WIDTH{1'b0}};
  for(int i=0; i< LFB_ADDR_ENTRY; i++) begin
    lfb_lf_sm_req_refill_way    |= {`WK_LS_DCACHE_WAYIDX_WIDTH{lfb_lf_sm_req_addr_ptr[i]}}  & lfb_addr_entry_refill_way[i];
  end
end
assign lfb_lf_sm_req_page_share     = |(lfb_lf_sm_req_addr_ptr[LFB_ADDR_ENTRY-1:0]  & lfb_addr_entry_page_share[LFB_ADDR_ENTRY-1:0]);
assign lfb_lf_sm_data_dcache_share  = |(lfb_lf_sm_req_data_ptr[LFB_DATA_ENTRY-1:0]  & lfb_data_entry_dcache_share[LFB_DATA_ENTRY-1:0]);

//------------------refill wakeup req-----------------------
// assign lfb_lf_sm_refill_wakeup      = lfb_lf_sm_req_depd
                                      // &&  lfb_lf_sm_create_vld;
//----------------------settle addr-------------------------
//-----------------data-----------------
assign lfb_lf_sm_data512[511:0]     = {512{lfb_lf_sm_data_id[0]}} & lfb_data_entry_data_0[511:0]
                                      | {512{lfb_lf_sm_data_id[1]}} & lfb_data_entry_data_1[511:0]; 
assign lfb_lf_sm_data512_rot0 = lfb_lf_sm_data512[511:0];
assign lfb_lf_sm_data512_rot1 = {lfb_lf_sm_data512[383:256],lfb_lf_sm_data512[511:384],lfb_lf_sm_data512[127:0],lfb_lf_sm_data512[255:128]};
assign lfb_lf_sm_data512_rot2 = {lfb_lf_sm_data512[255:128],lfb_lf_sm_data512[127:0],  lfb_lf_sm_data512[511:384],lfb_lf_sm_data512[383:256]};
assign lfb_lf_sm_data512_rot3 = {lfb_lf_sm_data512[127:0], lfb_lf_sm_data512[255:128], lfb_lf_sm_data512[383:256], lfb_lf_sm_data512[511:384]};
assign lfb_lf_sm_data512_rot =  {`WK_LS_DCACHE_DATA_BITS_NUM{lfb_lf_sm_refill_way_expand[0]}} & lfb_lf_sm_data512_rot0
                              | {`WK_LS_DCACHE_DATA_BITS_NUM{lfb_lf_sm_refill_way_expand[1]}} & lfb_lf_sm_data512_rot1
                              | {`WK_LS_DCACHE_DATA_BITS_NUM{lfb_lf_sm_refill_way_expand[2]}} & lfb_lf_sm_data512_rot2
                              | {`WK_LS_DCACHE_DATA_BITS_NUM{lfb_lf_sm_refill_way_expand[3]}} & lfb_lf_sm_data512_rot3;

assign lfb_lf_sm_data_settle[255:0]     = lfb_lf_sm_cnt
                                      ? lfb_lf_sm_data512_rot[511:256]
                                      : lfb_lf_sm_data512_rot[255:0];

// assign lfb_lf_sm_data_settle[255:0] = lfb_lf_sm_refill_way
//                                       ? {lfb_lf_sm_data256[127:0],lfb_lf_sm_data256[255:128]}
//                                       : lfb_lf_sm_data256[255:0];
//-----------------for ecc-----------------
//data ecc
assign data_bf_ecc_0[31:0] = lfb_lf_sm_data_settle[31:0];
assign data_bf_ecc_1[31:0] = lfb_lf_sm_data_settle[63:32];
assign data_bf_ecc_2[31:0] = lfb_lf_sm_data_settle[95:64];
assign data_bf_ecc_3[31:0] = lfb_lf_sm_data_settle[127:96];
assign data_bf_ecc_4[31:0] = lfb_lf_sm_data_settle[159:128];
assign data_bf_ecc_5[31:0] = lfb_lf_sm_data_settle[191:160];
assign data_bf_ecc_6[31:0] = lfb_lf_sm_data_settle[223:192];
assign data_bf_ecc_7[31:0] = lfb_lf_sm_data_settle[255:224];

// &Instance("xx_lsu_32bit_ecc_encode", "x_wk_dcache_32bit_ecc_encode_0"); @548
xx_lsu_32bit_ecc_encode  x_wk_dcache_32bit_ecc_encode_0 (
  .data_encode         (data_bf_ecc_0[31:0]),
  .ecc_code            (data_ecc_0[5:0]    ),
  .parity_bit          (data_parity_0      )
);

// &Connect(.data_encode    (data_bf_ecc_0[31:0]   ),   @549
//          .ecc_code       (data_ecc_0[5:0]     ),  @550
//          .parity_bit     (data_parity_0       )  @551
//         ); @552

// &Instance("xx_lsu_32bit_ecc_encode", "x_wk_dcache_32bit_ecc_encode_1"); @554
xx_lsu_32bit_ecc_encode  x_wk_dcache_32bit_ecc_encode_1 (
  .data_encode         (data_bf_ecc_1[31:0]),
  .ecc_code            (data_ecc_1[5:0]    ),
  .parity_bit          (data_parity_1      )
);

// &Connect(.data_encode    (data_bf_ecc_1[31:0]   ),   @555
//          .ecc_code       (data_ecc_1[5:0]     ),  @556
//          .parity_bit     (data_parity_1       )  @557
//         ); @558

// &Instance("xx_lsu_32bit_ecc_encode", "x_wk_dcache_32bit_ecc_encode_2"); @560
xx_lsu_32bit_ecc_encode  x_wk_dcache_32bit_ecc_encode_2 (
  .data_encode         (data_bf_ecc_2[31:0]),
  .ecc_code            (data_ecc_2[5:0]    ),
  .parity_bit          (data_parity_2      )
);

// &Connect(.data_encode    (data_bf_ecc_2[31:0]   ),   @561
//          .ecc_code       (data_ecc_2[5:0]     ),  @562
//          .parity_bit     (data_parity_2       )  @563
//         ); @564

// &Instance("xx_lsu_32bit_ecc_encode", "x_wk_dcache_32bit_ecc_encode_3"); @566
xx_lsu_32bit_ecc_encode  x_wk_dcache_32bit_ecc_encode_3 (
  .data_encode         (data_bf_ecc_3[31:0]),
  .ecc_code            (data_ecc_3[5:0]    ),
  .parity_bit          (data_parity_3      )
);

// &Instance("xx_lsu_32bit_ecc_encode", "x_wk_dcache_32bit_ecc_encode_4"); @572
xx_lsu_32bit_ecc_encode  x_wk_dcache_32bit_ecc_encode_4 (
  .data_encode         (data_bf_ecc_4[31:0]),
  .ecc_code            (data_ecc_4[5:0]    ),
  .parity_bit          (data_parity_4      )
);

// &Connect(.data_encode    (data_bf_ecc_4[31:0]   ),   @573
//          .ecc_code       (data_ecc_4[5:0]     ),  @574
//          .parity_bit     (data_parity_4       )  @575
//         ); @576

// &Instance("xx_lsu_32bit_ecc_encode", "x_wk_dcache_32bit_ecc_encode_5"); @578
xx_lsu_32bit_ecc_encode  x_wk_dcache_32bit_ecc_encode_5 (
  .data_encode         (data_bf_ecc_5[31:0]),
  .ecc_code            (data_ecc_5[5:0]    ),
  .parity_bit          (data_parity_5      )
);

// &Connect(.data_encode    (data_bf_ecc_5[31:0]   ),   @579
//          .ecc_code       (data_ecc_5[5:0]     ),  @580
//          .parity_bit     (data_parity_5       )  @581
//         ); @582

// &Instance("xx_lsu_32bit_ecc_encode", "x_wk_dcache_32bit_ecc_encode_6"); @584
xx_lsu_32bit_ecc_encode  x_wk_dcache_32bit_ecc_encode_6 (
  .data_encode         (data_bf_ecc_6[31:0]),
  .ecc_code            (data_ecc_6[5:0]    ),
  .parity_bit          (data_parity_6      )
);

// &Connect(.data_encode    (data_bf_ecc_6[31:0]   ),   @585
//          .ecc_code       (data_ecc_6[5:0]     ),  @586
//          .parity_bit     (data_parity_6       )  @587
//         ); @588

// &Instance("xx_lsu_32bit_ecc_encode", "x_wk_dcache_32bit_ecc_encode_7"); @590
xx_lsu_32bit_ecc_encode  x_wk_dcache_32bit_ecc_encode_7 (
  .data_encode         (data_bf_ecc_7[31:0]),
  .ecc_code            (data_ecc_7[5:0]    ),
  .parity_bit          (data_parity_7      )
);

// &Connect(.data_encode    (data_bf_ecc_7[31:0]   ),   @591
//          .ecc_code       (data_ecc_7[5:0]     ),  @592
//          .parity_bit     (data_parity_7       )  @593
//         ); @594

assign data_aft_ecc_0[38:0] = {data_parity_0,data_ecc_0[5:0],data_bf_ecc_0[31:0]};
assign data_aft_ecc_1[38:0] = {data_parity_1,data_ecc_1[5:0],data_bf_ecc_1[31:0]};
assign data_aft_ecc_2[38:0] = {data_parity_2,data_ecc_2[5:0],data_bf_ecc_2[31:0]};
assign data_aft_ecc_3[38:0] = {data_parity_3,data_ecc_3[5:0],data_bf_ecc_3[31:0]};
assign data_aft_ecc_4[38:0] = {data_parity_4,data_ecc_4[5:0],data_bf_ecc_4[31:0]};
assign data_aft_ecc_5[38:0] = {data_parity_5,data_ecc_5[5:0],data_bf_ecc_5[31:0]};
assign data_aft_ecc_6[38:0] = {data_parity_6,data_ecc_6[5:0],data_bf_ecc_6[31:0]};
assign data_aft_ecc_7[38:0] = {data_parity_7,data_ecc_7[5:0],data_bf_ecc_7[31:0]};

assign data_aft_ecc[311:0]  = {data_aft_ecc_7[38:0],data_aft_ecc_6[38:0],
                               data_aft_ecc_5[38:0],data_aft_ecc_4[38:0],
                               data_aft_ecc_3[38:0],data_aft_ecc_2[38:0],
                               data_aft_ecc_1[38:0],data_aft_ecc_0[38:0]};

assign lfb_lf_sm_data_settle_ecc[311:0] = data_aft_ecc[311:0];

//ld tag ecc
assign ld_tag_bf_ecc[`WK_LS_DCACHE_LDTAG_BF_ECC_LENGTH-1:0] = {1'b1,lfb_lf_sm_addr_tto6[`WK_PA_WIDTH-7:8]};

`ifdef WK_PA_WIDTH_40
// &Instance("xx_lsu_27bit_ecc_encode", "x_wk_dcache_27bit_ecc_encode"); @615
xx_lsu_27bit_ecc_encode  x_wk_dcache_27bit_ecc_encode (
  .data_encode         (ld_tag_bf_ecc[`WK_LS_DCACHE_LDTAG_BF_ECC_LENGTH-1:0]),
  .ecc_code            (ld_tag_ecc[`WK_LS_DATASRAM_ECC_WIDTH-1:0]    ),
  .parity_bit          (ld_tag_parity      )
);
`endif

`ifdef WK_PA_WIDTH_48
// &Instance("xx_lsu_31bit_ecc_encode", "x_wk_dcache_31bit_ecc_encode"); @615
xx_lsu_35bit_ecc_encode  x_wk_dcache_35bit_ecc_encode (
  .data_encode         (ld_tag_bf_ecc[`WK_LS_DCACHE_LDTAG_BF_ECC_LENGTH-1:0]),
  .ecc_code            (ld_tag_ecc[`WK_LS_DATASRAM_ECC_WIDTH-1:0]    ),
  .parity_bit          (ld_tag_parity      )
);
`endif

// &Connect(.data_encode    (ld_tag_bf_ecc[26:0] ),   @616
//          .ecc_code       (ld_tag_ecc[5:0]     ),  @617
//          .parity_bit     (ld_tag_parity       )  @618
//         ); @619

assign ld_tag_af_ecc[`WK_LS_DCACHE_LDTAG_AF_ECC_LENGTH-1:0]  = {ld_tag_parity,ld_tag_ecc[`WK_LS_DATASRAM_ECC_WIDTH-1:0],ld_tag_bf_ecc[`WK_LS_DCACHE_LDTAG_BF_ECC_LENGTH-1:0]};
assign ld_tag_ecc_din = {`WK_LS_DCACHE_WAYS_NUM{ld_tag_af_ecc[`WK_LS_DCACHE_LDTAG_AF_ECC_LENGTH-1:0]}};

//st tag ecc(including dirty)
assign st_tag_bf_ecc[`WK_LS_DCACHE_STTAG_BF_ECC_LENGTH-1:0] = {lfb_lf_sm_page_share,1'b0,lfb_lf_sm_dcache_share,1'b1,lfb_lf_sm_addr_tto6[`WK_PA_WIDTH-7:8]};

`ifdef WK_PA_WIDTH_40
// &Instance("xx_lsu_30bit_ecc_encode", "x_wk_dcache_30bit_ecc_encode"); @627
xx_lsu_30bit_ecc_encode  x_wk_dcache_30bit_ecc_encode (
  .data_encode         (st_tag_bf_ecc[`WK_LS_DCACHE_STTAG_BF_ECC_LENGTH-1:0]),
  .ecc_code            (st_tag_ecc[`WK_LS_DATASRAM_ECC_WIDTH-1:0]    ),
  .parity_bit          (st_tag_parity      )
);
`endif

`ifdef WK_PA_WIDTH_48
// &Instance("xx_lsu_34bit_ecc_encode", "x_wk_dcache_34bit_ecc_encode"); @627
xx_lsu_38bit_ecc_encode  x_wk_dcache_38bit_ecc_encode (
  .data_encode         (st_tag_bf_ecc[`WK_LS_DCACHE_STTAG_BF_ECC_LENGTH-1:0]),
  .ecc_code            (st_tag_ecc[`WK_LS_DATASRAM_ECC_WIDTH-1:0]    ),
  .parity_bit          (st_tag_parity      )
);
`endif

// &Connect(.data_encode    (st_tag_bf_ecc[29:0] ),   @628
//          .ecc_code       (st_tag_ecc[5:0]     ),  @629
//          .parity_bit     (st_tag_parity       )  @630
//         ); @631

assign st_dirty_af_ecc[`WK_LS_DCACHE_STTAG_AF_ECC_LENGTH-1:0]  = {st_tag_parity,st_tag_ecc[`WK_LS_DATASRAM_ECC_WIDTH-1:0],st_tag_bf_ecc[`WK_LS_DCACHE_STTAG_BF_ECC_LENGTH-1:`WK_LS_DCACHE_SINGLE_TAG_WIDTH]};
//----------------------cache interface---------------------
assign lfb_dcache_arb_ld_req  = lfb_lf_sm_vld;
assign lfb_dcache_arb_st_req  = lfb_lf_sm_vld;
assign lfb_dcache_arb_serial_req  = lfb_lf_sm_vld &&  !lfb_lf_sm_cnt;

//---------------tag array--------------
assign lfb_dcache_arb_ld_tag_req        = lfb_lf_sm_vld &&  lfb_lf_sm_cnt;
assign lfb_dcache_arb_ld_tag_gateclk_en = lfb_dcache_arb_ld_tag_req;
assign lfb_dcache_arb_ld_tag_idx        = lfb_lf_sm_addr_tto6[`WK_LS_DCACHE_LDTAG_IDX_MSB:0];
assign lfb_dcache_arb_ld_tag_din        = ld_tag_ecc_din;
assign lfb_dcache_arb_ld_tag_wen        = lfb_lf_sm_cnt
                                          ? lfb_lf_sm_refill_way_expand
                                          : {`WK_LS_DCACHE_WAYS_NUM{1'b0}};

assign lfb_dcache_arb_st_tag_req        = lfb_dcache_arb_ld_tag_req;
assign lfb_dcache_arb_st_tag_gateclk_en = lfb_dcache_arb_ld_tag_req;
assign lfb_dcache_arb_st_tag_idx        = lfb_dcache_arb_ld_tag_idx;
assign lfb_dcache_arb_st_tag_din        = {`WK_LS_DCACHE_WAYS_NUM{lfb_lf_sm_addr_tto6[`WK_PA_WIDTH-7:8]}};
assign lfb_dcache_arb_st_tag_wen        = lfb_dcache_arb_ld_tag_wen;

//---------------dirty array------------
`ifdef WK_DCACHE_2WAY
  assign st_dirty_ecc_din            = {!lfb_lf_sm_refill_way,st_dirty_af_ecc[`WK_LS_DCACHE_STTAG_AF_ECC_LENGTH-1:0],st_dirty_af_ecc[`WK_LS_DCACHE_STTAG_AF_ECC_LENGTH-1:0]};
  assign lfb_dcache_arb_st_dirty_wen = {1'b1,{4{lfb_lf_sm_refill_way}},{4{!lfb_lf_sm_refill_way}}};
  assign lfb_dcache_arb_ld_data_req  = {{8{1'b1}}};  
  assign lfb_dcache_arb_ld_data_idx  = {lfb_lf_sm_addr_tto6[`WK_LS_DCACHE_LDTAG_IDX_MSB:0],lfb_lf_sm_cnt,lfb_lf_sm_refill_way};
`endif 
`ifdef WK_DCACHE_4WAY
  assign st_dirty_ecc_din            = {`WK_LS_DCACHE_WAYS_NUM{st_dirty_af_ecc[`WK_LS_DCACHE_STTAG_AF_ECC_LENGTH-1:0]}};  
  assign lfb_dcache_arb_st_dirty_wen = {{4{lfb_lf_sm_refill_way_expand[3]}},{4{lfb_lf_sm_refill_way_expand[2]}},{4{lfb_lf_sm_refill_way_expand[1]}},{4{lfb_lf_sm_refill_way_expand[0]}}};
  assign lfb_dcache_arb_ld_data_req  = {{8{lfb_lf_sm_cnt}},{8{!lfb_lf_sm_cnt}}};  
  assign lfb_dcache_arb_ld_data_idx  = {lfb_lf_sm_addr_tto6[`WK_LS_DCACHE_LDTAG_IDX_MSB:0],lfb_lf_sm_refill_way};
`endif
assign lfb_dcache_arb_st_dirty_req        = lfb_dcache_arb_ld_tag_req;
assign lfb_dcache_arb_st_dirty_gateclk_en = lfb_dcache_arb_ld_tag_req;
assign lfb_dcache_arb_st_dirty_idx        = lfb_lf_sm_addr_tto6[`WK_LS_DCACHE_LDTAG_IDX_MSB:0];
assign lfb_dcache_arb_st_dirty_din        = st_dirty_ecc_din;

//---------------data array-------------
assign lfb_dcache_arb_ld_data_gateclk_en     = {`WK_LS_DCACHE_DATA_WORDS_NUM{lfb_lf_sm_vld}};
assign lfb_dcache_arb_ld_data_1st_din[155:0] = lfb_lf_sm_data_settle_ecc[155:0];
assign lfb_dcache_arb_ld_data_2nd_din[155:0] = lfb_lf_sm_data_settle_ecc[311:156];
assign lfb_dcache_arb_ld_data_3rd_din[155:0] = lfb_lf_sm_data_settle_ecc[155:0];
assign lfb_dcache_arb_ld_data_4th_din[155:0] = lfb_lf_sm_data_settle_ecc[311:156];

//----------------------pop signal--------------------------
assign lfb_lf_sm_addr_pop_req[LFB_ADDR_ENTRY-1:0] = {LFB_ADDR_ENTRY{lfb_lf_sm_vld &&  lfb_lf_sm_cnt}}
                                                    & lfb_lf_sm_addr_id[LFB_ADDR_ENTRY-1:0];

assign lfb_lf_sm_data_pop_req[LFB_DATA_ENTRY-1:0] = {LFB_DATA_ENTRY{lfb_lf_sm_vld &&  lfb_lf_sm_cnt}}
                                                    & lfb_lf_sm_data_id[LFB_DATA_ENTRY-1:0];

assign lfb_data_addr_pop_req[LFB_ADDR_ENTRY-1:0]  = lfb_data_entry_addr_pop_req_0[LFB_ADDR_ENTRY-1:0]
                                                    | lfb_data_entry_addr_pop_req_1[LFB_ADDR_ENTRY-1:0];
//==========================================================
//                Maintain wakeup queue
//==========================================================
//the 12 bit of wakeup_queue is for mcic
always @(posedge lfb_wakeup_queue_clk[0] or negedge cpurst_b)
begin
  if (!cpurst_b)
    lfb_mcic_wakeup_queue  <=  1'b0;
  else if(rtu_ck_flush)         //ck_flush will send out all wakeup_queue at same cycle, next cycle set 0, ck_flush@LTL
    lfb_mcic_wakeup_queue  <=  1'b0;
  else if(ld_da_lfb_set_wakeup_queue[0] ||  lfb_pop_depd_ff[0])
    lfb_mcic_wakeup_queue  <=  lfb_wakeup_queue_next[0][LSIQ_ENTRY]; //TODO
end

generate
for(i = 0; i < `NUM_LD + `NUM_LS; i = i+1) 
begin 
//----------------------registers---------------------------
//+--------------+
//| wakeup_queue |
//+--------------+
//the queue stores the instructions waiting for wakeup
//the 12 bit of wakeup_queue is for mcic
always @(posedge lfb_wakeup_queue_clk[i] or negedge cpurst_b)
begin
  if (!cpurst_b)
    lfb_wakeup_queue[i][LSIQ_ENTRY-1:0]  <=  {LSIQ_ENTRY{1'b0}};
  else if(rtu_yy_xx_flush)
    lfb_wakeup_queue[i][LSIQ_ENTRY-1:0]  <=  {LSIQ_ENTRY{1'b0}};
  else if(rtu_ck_flush)                                             //ck_flush will send out all wakeup_queue at same cycle, next cycle set 0, ck_flush@LTL
    lfb_wakeup_queue[i][LSIQ_ENTRY-1:0]  <=  {LSIQ_ENTRY{1'b0}};    //ck_flush, all wakeup send out, @LTL
  else if(ld_da_lfb_set_wakeup_queue[i] ||  lfb_pop_depd_ff[i])
    lfb_wakeup_queue[i][LSIQ_ENTRY-1:0]  <=  lfb_wakeup_queue_next[i][LSIQ_ENTRY-1:0];
end

//+-------------+
//| depd_pop_ff |
//+-------------+
//if depd pop, this will set to 1, and clear wakeup_queue next cycle
// &Force("output","lfb_pop_depd_ff"); @727
always @(posedge lfb_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    lfb_pop_depd_ff[i]     <=  1'b0;
  else if(lfb_addr_pop_depd[i]
      ||  lfb_addr_pop_discard_vld[i]
      ||  rb_lfb_depd_wakeup[i]
      ||  lfb_lf_sm_refill_wakeup[i]
      ||  lm_lfb_depd_wakeup[i])
    lfb_pop_depd_ff[i]     <=  1'b1;
  else
    lfb_pop_depd_ff[i]     <=  1'b0;
end

//----------------forward to depd_pop_ff------------------
assign lfb_addr_pop_depd[i]        = |(lfb_addr_entry_pop_vld[LFB_ADDR_ENTRY-1:0]
                                    & lfb_addr_entry_depd_trans[i][LFB_ADDR_ENTRY-1:0]);
assign lfb_addr_pop_discard_vld[i] = |(lfb_addr_entry_pop_vld[LFB_ADDR_ENTRY-1:0]
                                    & lfb_addr_entry_discard_vld_trans[i][LFB_ADDR_ENTRY-1:0]);

//------------------update wakeup queue---------------------
assign lfb_wakeup_queue_after_pop[i][LSIQ_ENTRY:0] = lfb_pop_depd_ff[i] || rtu_ck_flush   //ck_flush will send out all wakeup_queue at same cycle, next cycle set 0, ck_flush@LTL
                                                  ? {LSIQ_ENTRY+1{1'b0}}
                                                  : {lfb_mcic_wakeup_queue,lfb_wakeup_queue[i][LSIQ_ENTRY-1:0]};

assign lfb_wakeup_queue_next[i][LSIQ_ENTRY:0]  = rtu_ck_flush                             //ck_flush will send out all wakeup_queue at same cycle, next cycle set 0, ck_flush@LTL
                                              ? {LSIQ_ENTRY+1{1'b0}}
                                              : lfb_wakeup_queue_after_pop[i][LSIQ_ENTRY:0]
                                                | {LSIQ_ENTRY+1{ld_da_lfb_set_wakeup_queue[i]}}
                                                  & ld_da_lfb_wakeup_queue_next[i][LSIQ_ENTRY:0];

//------------------------wakeup----------------------------
assign lfb_depd_wakeup[i][LSIQ_ENTRY-1:0]  = rtu_ck_flush                                   //ck_flush will send out all wakeup_queue at same cycle, next cycle set 0, ck_flush@LTL
                                          ? lfb_wakeup_queue[i][LSIQ_ENTRY-1:0] 
                                            | ({LSIQ_ENTRY{ld_da_lfb_set_wakeup_queue[i]}}
                                                & ld_da_lfb_wakeup_queue_next[i][LSIQ_ENTRY-1:0])
                                          : lfb_pop_depd_ff[i]
                                          ? lfb_wakeup_queue[i][LSIQ_ENTRY-1:0]
                                          : {LSIQ_ENTRY{1'b0}};

assign lfb_ld_da_hit_idx[i]        = |lfb_addr_entry_ld_da_hit_idx_trans[i][LFB_ADDR_ENTRY-1:0];
end
endgenerate                                          

assign lfb_mcic_wakeup                  = rtu_ck_flush      //ck_flush will send out all wakeup_queue at same cycle, next cycle set 0, ck_flush@LTL
                                          ? lfb_mcic_wakeup_queue || (ld_da_lfb_set_wakeup_queue[0] && ld_da_lfb_wakeup_queue_next[0][LSIQ_ENTRY])
                                          : lfb_pop_depd_ff[0]
                                          ? lfb_mcic_wakeup_queue
                                          : 1'b0;
//==========================================================
//                for avoid deadlock with no rready
//==========================================================
assign lfb_create_linefill_vld    =  cp0_lsu_dcache_en
                                     && (lfb_addr_rb_create_vld && rb_lfb_page_ca || lfb_addr_pfu_create_vld);
assign lfb_create_linefill_dp     = cp0_lsu_dcache_en
                                    && (lfb_addr_rb_create_dp_vld && rb_lfb_page_ca || lfb_addr_pfu_create_dp_vld);
// assign lfb_no_rcl_cnt_create[3:0] = {3'b0,lfb_create_linefill_vld};
// assign lfb_no_rcl_cnt_pop[3:0]    = {3'b0,vb_lfb_rcl_done} 
//                                     + {3'b0,snq_lfb_bypass_invalid[0]}
//                                     + {3'b0,snq_lfb_bypass_invalid[1]};
assign lfb_no_rcl_cnt_create = {{$clog2(LFB_ADDR_ENTRY){1'b0}},lfb_create_linefill_vld};
assign lfb_no_rcl_cnt_pop    = {{$clog2(LFB_ADDR_ENTRY){1'b0}},vb_lfb_rcl_done} 
                               + {{$clog2(LFB_ADDR_ENTRY){1'b0}},snq_lfb_bypass_invalid[0]}
                               + {{$clog2(LFB_ADDR_ENTRY){1'b0}},snq_lfb_bypass_invalid[1]};

assign lfb_no_rcl_cnt_updt_vld    = lfb_create_linefill_vld
                                    || vb_lfb_rcl_done 
                                    || |snq_lfb_bypass_invalid[1:0]; 

// assign lfb_no_rcl_cnt_updt_val[3:0] = lfb_no_rcl_cnt[3:0]
//                                       + lfb_no_rcl_cnt_create[3:0] 
//                                       - lfb_no_rcl_cnt_pop[3:0]; 
assign lfb_no_rcl_cnt_updt_val = lfb_no_rcl_cnt
                                 + lfb_no_rcl_cnt_create
                                 - lfb_no_rcl_cnt_pop; 

always @(posedge lfb_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    lfb_no_rcl_cnt   <= {$clog2(LFB_ADDR_ENTRY)+1{1'b0}};
  else if(lfb_no_rcl_cnt_updt_vld)
    lfb_no_rcl_cnt   <=  lfb_no_rcl_cnt_updt_val;
end

// assign lfb_nc_rready_grnt     = (lfb_no_rcl_cnt[3:0] <= 4'd1);
// assign lfb_ca_rready_grnt     = (lfb_no_rcl_cnt[3:0] <  4'd1);
assign lfb_nc_rready_grnt     = (lfb_no_rcl_cnt <= {{$clog2(LFB_ADDR_ENTRY){1'b0}}, 1'b1});
assign lfb_ca_rready_grnt     = (lfb_no_rcl_cnt <  {{$clog2(LFB_ADDR_ENTRY){1'b0}}, 1'b1});
assign lfb_rb_nc_rready_grnt  = lfb_nc_rready_grnt;
assign lfb_rb_ca_rready_grnt  = lfb_ca_rready_grnt;
assign lfb_pfu_rready_grnt    = lfb_ca_rready_grnt;

//for rready,if all addr entry has resp,then not deassert rready
assign lfb_addr_all_resp      = !(|lfb_addr_entry_not_resp[LFB_ADDR_ENTRY-1:0]);

//------------ nc not empty ------------
assign lfb_rb_nc_empty = !(|(lfb_addr_entry_vld[LFB_ADDR_ENTRY-1:0] & lfb_addr_entry_page_nc[LFB_ADDR_ENTRY-1:0]));

//==========================================================
//                        pend addr
//==========================================================
assign lfb_pend_entry[LFB_ADDR_ENTRY-1:0] = lfb_addr_entry_vld[LFB_ADDR_ENTRY-1:0];
// assign lfb_entry_addr[0][`WK_PA_WIDTH-1:0] = {lfb_addr_entry_addr_tto4[0][`WK_PA_WIDTH-5:0],{4{1'b0}}};
// assign lfb_entry_addr[1][`WK_PA_WIDTH-1:0] = {lfb_addr_entry_addr_tto4[1][`WK_PA_WIDTH-5:0],{4{1'b0}}};
// assign lfb_entry_addr[2][`WK_PA_WIDTH-1:0] = {lfb_addr_entry_addr_tto4[2][`WK_PA_WIDTH-5:0],{4{1'b0}}};
// assign lfb_entry_addr[3][`WK_PA_WIDTH-1:0] = {lfb_addr_entry_addr_tto4[3][`WK_PA_WIDTH-5:0],{4{1'b0}}};
// assign lfb_entry_addr[4][`WK_PA_WIDTH-1:0] = {lfb_addr_entry_addr_tto4[4][`WK_PA_WIDTH-5:0],{4{1'b0}}};
// assign lfb_entry_addr[5][`WK_PA_WIDTH-1:0] = {lfb_addr_entry_addr_tto4[5][`WK_PA_WIDTH-5:0],{4{1'b0}}};
// assign lfb_entry_addr[6][`WK_PA_WIDTH-1:0] = {lfb_addr_entry_addr_tto4[6][`WK_PA_WIDTH-5:0],{4{1'b0}}};
// assign lfb_entry_addr[7][`WK_PA_WIDTH-1:0] = {lfb_addr_entry_addr_tto4[7][`WK_PA_WIDTH-5:0],{4{1'b0}}};
generate
  for(i=0; i<LFB_ADDR_ENTRY; i++)
    assign lfb_entry_addr[i][`WK_PA_WIDTH-1:0] = {lfb_addr_entry_addr_tto4[i][`WK_PA_WIDTH-5:0],{4{1'b0}}};
endgenerate

assign lfb_entry_page_ca[LFB_ADDR_ENTRY-1:0]  = ~lfb_addr_entry_page_nc[LFB_ADDR_ENTRY-1:0];
assign lfb_entry_page_so[LFB_ADDR_ENTRY-1:0]  = {LFB_ADDR_ENTRY{1'b0}};

// &ConnRule(s/xxsource/lfb/); @820
// &Instance("xx_lsu_pend_addr_sel","x_xx_lsu_lfb_pend_addr_sel"); @821
xx_lsu_pend_addr_sel_sv #(.RBENTRY(LFB_ADDR_ENTRY)) x_xx_lsu_lfb_pend_addr_sel (
  .cp0_lsu_icg_en          (cp0_lsu_icg_en         ),
  .cpurst_b                (cpurst_b               ),
  .forever_cpuclk          (forever_cpuclk         ),
  .pad_yy_icg_scan_en      (pad_yy_icg_scan_en     ),
  .xxsource_entry_addr     (lfb_entry_addr       ),
  // .xxsource_entry_addr_0   (lfb_entry_addr_0       ),
  // .xxsource_entry_addr_1   (lfb_entry_addr_1       ),
  // .xxsource_entry_addr_2   (lfb_entry_addr_2       ),
  // .xxsource_entry_addr_3   (lfb_entry_addr_3       ),
  // .xxsource_entry_addr_4   (lfb_entry_addr_4       ),
  // .xxsource_entry_addr_5   (lfb_entry_addr_5       ),
  // .xxsource_entry_addr_6   (lfb_entry_addr_6       ),
  // .xxsource_entry_addr_7   (lfb_entry_addr_7       ),
  .xxsource_entry_page_ca  (lfb_entry_page_ca      ),
  .xxsource_entry_page_so  (lfb_entry_page_so      ),
  .xxsource_has_pend       (lfb_has_pend           ),
  .xxsource_pend_addr_f    (lfb_pend_addr_f        ),
  .xxsource_pend_busy      (lfb_pend_busy          ),
  .xxsource_pend_entry     (lfb_pend_entry         ),
  .xxsource_pend_page_ca_f (lfb_pend_page_ca_f     ),
  .xxsource_pend_page_so_f (lfb_pend_page_so_f     )
);


//==========================================================
//              Interface to other module
//==========================================================
//---------------------hit idx------------------------------
generate
  for (i = 0; i<`NUM_LS ; i++) begin
assign lfb_st_da_hit_idx[i]        = |lfb_addr_entry_st_da_hit_idx_trans[i][LFB_ADDR_ENTRY-1:0];
  end
endgenerate                                          
// assign lfb_ld_da_hit_idx        = |lfb_addr_entry_ld_da_hit_idx[LFB_ADDR_ENTRY-1:0];
// assign lfb_st_da_hit_idx        = |lfb_addr_entry_st_da_hit_idx[LFB_ADDR_ENTRY-1:0];
assign lfb_rb_biu_req_hit_idx   = |lfb_addr_entry_rb_biu_req_hit_idx[LFB_ADDR_ENTRY-1:0];
assign lfb_pfu_biu_req_hit_idx  = |lfb_addr_entry_pfu_biu_req_hit_idx[LFB_ADDR_ENTRY-1:0];
//assign lfb_snq_stall            = |lfb_addr_entry_snq_create_hit_idx[LFB_ADDR_ENTRY-1:0];
assign lfb_wmb_read_req_hit_idx = |lfb_addr_entry_wmb_read_req_hit_idx[LFB_ADDR_ENTRY-1:0];
assign lfb_wmb_write_req_hit_idx= |lfb_addr_entry_wmb_write_req_hit_idx[LFB_ADDR_ENTRY-1:0];

//for snq
// &Force("output","lfb_snq_bypass_data_id"); @836
assign lfb_snq_bypass_hit          = |lfb_addr_entry_snq_bypass_hit[LFB_ADDR_ENTRY-1:0];
assign lfb_snq_bypass_data_id[1:0] = lfb_data_entry_vld[LFB_DATA_ENTRY-1:0]
                                     & {lfb_addr_entry_snq_bypass_hit[LFB_ADDR_ENTRY-1:0] == lfb_data_entry_addr_id_1[LFB_ADDR_ENTRY-1:0],
                                        lfb_addr_entry_snq_bypass_hit[LFB_ADDR_ENTRY-1:0] == lfb_data_entry_addr_id_0[LFB_ADDR_ENTRY-1:0]};
assign lfb_snq_bypass_share        = |(lfb_snq_bypass_data_id[1:0] & lfb_data_entry_dcache_share[1:0]);
//----------------interface to biu--------------------------
assign lfb_data_not_full        = !(&lfb_data_entry_full[LFB_DATA_ENTRY-1:0]);
assign lsu_biu_r_linefill_ready = lfb_data_not_full || lfb_addr_all_resp;
//------------------full/empty signal-----------------------
assign lfb_addr_empty           = !(|lfb_addr_entry_vld[LFB_ADDR_ENTRY-1:0]);
assign lfb_data_empty           = !(|lfb_data_entry_vld[LFB_DATA_ENTRY-1:0]);
// &Force("output","lfb_empty"); @848
assign lfb_empty                = lfb_addr_empty  &&  lfb_data_empty  &&  !lfb_vb_req_unmask && !lfb_pend_busy;
// &Force("output","lfb_addr_full"); @850
assign lfb_addr_full            = &lfb_addr_entry_vld[LFB_ADDR_ENTRY-1:0];
assign lfb_addr_less2           = &(lfb_addr_entry_vld[LFB_ADDR_ENTRY-1:0]
                                    | lfb_addr_create_ptr[LFB_ADDR_ENTRY-1:0]);
assign lsu_had_lfb_addr_entry_vld[7:0] = lfb_addr_entry_vld[7:0];
assign lsu_had_lfb_addr_entry_rcl_done[7:0]  = lfb_addr_entry_rcl_done[7:0];
assign lsu_had_lfb_addr_entry_dcache_hit[7:0]= lfb_addr_entry_dcache_hit[7:0];
assign lsu_had_lfb_data_entry_vld[LFB_DATA_ENTRY-1:0] = lfb_data_entry_vld[LFB_DATA_ENTRY-1:0];
assign lsu_had_lfb_data_entry_last[LFB_DATA_ENTRY-1:0] = lfb_data_entry_last[LFB_DATA_ENTRY-1:0];
assign lsu_had_lfb_wakeup_queue[LSIQ_ENTRY:0] = {lfb_mcic_wakeup_queue,lfb_wakeup_queue[0][LSIQ_ENTRY-1:0]};//TODO
assign lsu_had_lfb_lf_sm_vld  = lfb_lf_sm_vld;

//==========================================================
//        interface to hpcp
//==========================================================
assign ld_hit_prefetch = |ld_hit_prefetch_first[LFB_ADDR_ENTRY-1:0]; 
// &ModuleEnd; @868
endmodule


