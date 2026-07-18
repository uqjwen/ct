//-----------------------------------------------------------------------------
// File          : xx_lsu_dcache_arb.sv
// Created       : 2024/10/01 (by Wen Jiahui)
// Last modified : 2024/10/01 (by Li  Shuo)
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
// 2025/03/26 : modify to fit for 4 ways 
//-----------------------------------------------------------------------------

//#
//# Module Declaration
//# ==================
//#



// *****************************************************************************

// &ModuleBeg; @23
module xx_lsu_dcache_arb #(

)(
input  wire  [`WK_LS_DCACHE_DATA_WORDS_NUM-1 :0]  ag_dcache_arb_ld_data_req,         
input  wire  [`WK_LS_DCACHE_DATA_WORDS_NUM-1 :0]  ag_dcache_arb_ld_data_gateclk_en,  
input  wire  [`WK_LS_DCACHE_DATA_IDX_MSB     :0]  ag_dcache_arb_ld_data_1st_idx,     
input  wire  [`WK_LS_DCACHE_DATA_IDX_MSB     :0]  ag_dcache_arb_ld_data_2nd_idx,    
input  wire  [`WK_LS_DCACHE_DATA_IDX_MSB     :0]  ag_dcache_arb_ld_data_3rd_idx,     
input  wire  [`WK_LS_DCACHE_DATA_IDX_MSB     :0]  ag_dcache_arb_ld_data_4th_idx,    
input  wire                                       ag_dcache_arb_ld_tag_gateclk_en,   
input  wire                                       ag_dcache_arb_ld_tag_req,          
input  wire  [`WK_LS_DCACHE_LDTAG_IDX_MSB  :0]    ag_dcache_arb_ld_tag_idx,          
input  wire  [`WK_LS_DCACHE_META_IDX_MSB   :0]    ag_dcache_arb_st_dirty_idx,        
input  wire  [`WK_LS_DCACHE_LDTAG_IDX_MSB  :0]    ag_dcache_arb_st_tag_idx,          
input  wire                                       ag_dcache_arb_st_dirty_gateclk_en, 
input  wire                                       ag_dcache_arb_st_dirty_req,        
input  wire                                       ag_dcache_arb_st_tag_gateclk_en,   
input  wire                                       ag_dcache_arb_st_tag_req,          
input  wire                                       cp0_lsu_icg_en,                    
input  wire                                       cpurst_b,                          
input  wire                                       forever_cpuclk,                    
input  wire  [`WK_LS_DCACHE_WAYIDX_WIDTH-1 :0]    icc_dcache_arb_data_way,           
input  wire                                       icc_dcache_arb_ld_borrow_req,      
input  wire  [`WK_LS_DCACHE_DATA_WORDS_NUM-1 :0]  icc_dcache_arb_ld_data_gateclk_en, 
input  wire  [`WK_LS_DCACHE_DATA_WORDS_NUM-1 :0]  icc_dcache_arb_ld_data_req,        
input  wire  [`WK_LS_DCACHE_DATA_IDX_MSB     :0]  icc_dcache_arb_ld_data_1st_idx,    
input  wire  [`WK_LS_DCACHE_DATA_IDX_MSB     :0]  icc_dcache_arb_ld_data_2nd_idx,   
input  wire  [`WK_LS_DCACHE_DATA_IDX_MSB     :0]  icc_dcache_arb_ld_data_3rd_idx,    
input  wire  [`WK_LS_DCACHE_DATA_IDX_MSB     :0]  icc_dcache_arb_ld_data_4th_idx,   
input  wire                                       icc_dcache_arb_ld_req,             
input  wire                                       icc_dcache_arb_ld_tag_gateclk_en,  
input  wire                                       icc_dcache_arb_ld_tag_read,        
input  wire                                       icc_dcache_arb_ld_tag_req,         
input  wire  [`WK_LS_DCACHE_LDTAG_IDX_MSB     :0] icc_dcache_arb_ld_tag_idx,         
input  wire  [`WK_LS_DCACHE_LDTAG_IDX_MSB     :0] icc_dcache_arb_st_tag_idx,         
input  wire  [`WK_LS_DCACHE_META_NOECC_WIDTH-1:0] icc_dcache_arb_st_dirty_wen,       
input  wire  [`WK_LS_DCACHE_META_IDX_MSB      :0] icc_dcache_arb_st_dirty_idx,       
input  wire  [`WK_LS_DCACHE_META_WIDTH-1      :0] icc_dcache_arb_st_dirty_din,       
input  wire                                       icc_dcache_arb_st_borrow_req,      
input  wire                                       icc_dcache_arb_st_dirty_gateclk_en, 
input  wire                                       icc_dcache_arb_st_dirty_gwen,      
input  wire                                       icc_dcache_arb_st_dirty_req,       
input  wire                                       icc_dcache_arb_st_req,             
input  wire                                       icc_dcache_arb_st_tag_gateclk_en,  
input  wire                                       icc_dcache_arb_st_tag_req,         
input  wire  [`WK_LS_DCACHE_WAYIDX_WIDTH-1 :0]    icc_dcache_arb_way,                
input  wire  [`WK_LS_DCACHE_DATA_WORDS_NUM-1 :0]  lfb_dcache_arb_ld_data_gateclk_en, 
input  wire  [`WK_LS_DCACHE_DATA_WORDS_NUM-1 :0]  lfb_dcache_arb_ld_data_req,        
input  wire  [`WK_LS_DCACHE_DATA_IDX_MSB     :0]  lfb_dcache_arb_ld_data_idx,        
input  wire  [155:0]                              lfb_dcache_arb_ld_data_1st_din,    
input  wire  [155:0]                              lfb_dcache_arb_ld_data_2nd_din,   
input  wire  [155:0]                              lfb_dcache_arb_ld_data_3rd_din,    
input  wire  [155:0]                              lfb_dcache_arb_ld_data_4th_din,   
input  wire                                       lfb_dcache_arb_ld_req,             
input  wire                                       lfb_dcache_arb_ld_tag_gateclk_en,  
input  wire                                       lfb_dcache_arb_ld_tag_req,         
input  wire  [`WK_LS_DCACHE_WAYS_NUM-1        :0] lfb_dcache_arb_ld_tag_wen,         
input  wire  [`WK_LS_DCACHE_LDTAG_IDX_MSB     :0] lfb_dcache_arb_ld_tag_idx,         
input  wire  [`WK_LS_DCACHE_LDTAG_WIDTH-1     :0] lfb_dcache_arb_ld_tag_din,         
input  wire  [`WK_LS_DCACHE_META_NOECC_WIDTH-1:0] lfb_dcache_arb_st_dirty_wen,       
input  wire  [`WK_LS_DCACHE_META_IDX_MSB      :0] lfb_dcache_arb_st_dirty_idx,       
input  wire  [`WK_LS_DCACHE_META_WIDTH-1      :0] lfb_dcache_arb_st_dirty_din,       
input  wire  [`WK_LS_DCACHE_WAYS_NUM-1        :0] lfb_dcache_arb_st_tag_wen,         
input  wire  [`WK_LS_DCACHE_LDTAG_IDX_MSB     :0] lfb_dcache_arb_st_tag_idx,         
input  wire  [`WK_LS_DCACHE_TAG_NOECC_WIDTH-1 :0] lfb_dcache_arb_st_tag_din,         
input  wire                                       lfb_dcache_arb_serial_req,         
input  wire                                       lfb_dcache_arb_st_dirty_gateclk_en, 
input  wire                                       lfb_dcache_arb_st_dirty_req,       
input  wire                                       lfb_dcache_arb_st_req,             
input  wire                                       lfb_dcache_arb_st_tag_gateclk_en,  
input  wire                                       lfb_dcache_arb_st_tag_req,         
input  wire  [`WK_LS_DCACHE_DATA_WORDS_NUM-1 :0]  mcic_dcache_arb_ld_data_req,       
input  wire  [`WK_LS_DCACHE_DATA_WORDS_NUM-1 :0]  mcic_dcache_arb_ld_data_gateclk_en, 
input  wire  [`WK_LS_DCACHE_DATA_IDX_MSB     :0]  mcic_dcache_arb_ld_data_1st_idx,   
input  wire  [`WK_LS_DCACHE_DATA_IDX_MSB     :0]  mcic_dcache_arb_ld_data_2nd_idx,  
input  wire  [`WK_LS_DCACHE_DATA_IDX_MSB     :0]  mcic_dcache_arb_ld_data_3rd_idx,   
input  wire  [`WK_LS_DCACHE_DATA_IDX_MSB     :0]  mcic_dcache_arb_ld_data_4th_idx,  
input  wire  [`WK_LS_DCACHE_LDTAG_IDX_MSB    :0]  mcic_dcache_arb_ld_tag_idx,        
input  wire  [`WK_PA_WIDTH-1 :0]                  mcic_dcache_arb_req_addr,          
input  wire                                       mcic_dcache_arb_ld_req,            
input  wire                                       mcic_dcache_arb_ld_tag_gateclk_en, 
input  wire                                       pad_yy_icg_scan_en,                
input  wire  [`WK_LS_DCACHE_WAYIDX_WIDTH-1 :0]    snq_dcache_arb_data_way,           
input  wire                                       snq_dcache_arb_ld_borrow_req,      
input  wire                                       snq_dcache_arb_ld_borrow_req_gate, 
input  wire                                       snq_dcache_arb_ld_req,             
input  wire                                       snq_dcache_arb_ld_tag_gateclk_en,  
input  wire                                       snq_dcache_arb_ld_tag_req,         
input  wire  [`WK_PA_WIDTH-1 :0]                  snq_dcache_arb_borrow_addr,        
input  wire  [`WK_LS_DCACHE_DATA_WORDS_NUM-1  :0] snq_dcache_arb_ld_data_gateclk_en, 
input  wire  [`WK_LS_DCACHE_DATA_IDX_MSB      :0] snq_dcache_arb_ld_data_idx,        
input  wire  [`WK_LS_DCACHE_LDTAG_IDX_MSB     :0] snq_dcache_arb_ld_tag_idx,         
input  wire  [`WK_LS_DCACHE_WAYS_NUM-1        :0] snq_dcache_arb_ld_tag_wen,    
input  wire  [`WK_LS_DCACHE_LDTAG_WIDTH-1     :0] snq_dcache_arb_ld_tag_din,//added by xj@2025.02.20      
input  wire  [`WK_LS_DCACHE_META_WIDTH-1      :0] snq_dcache_arb_st_dirty_din,       
input  wire  [`WK_LS_DCACHE_META_IDX_MSB      :0] snq_dcache_arb_st_dirty_idx,       
input  wire  [`WK_LS_DCACHE_META_NOECC_WIDTH-1:0] snq_dcache_arb_st_dirty_wen,       
input  wire  [`WK_LS_DCACHE_LDTAG_IDX_MSB     :0] snq_dcache_arb_st_tag_idx,         
input  wire  [`WK_LS_VB_DATA_ENTRY-1          :0] snq_dcache_sdb_id,                 
input  wire  [`WK_LS_SNQ_ENTRY-1 :0]              snq_dcache_arb_st_id,             
input  wire                                       snq_dcache_arb_serial_req,         
input  wire                                       snq_dcache_arb_st_borrow_req,      
input  wire                                       snq_dcache_arb_st_dirty_gateclk_en, 
input  wire                                       snq_dcache_arb_st_dirty_gwen,      
input  wire                                       snq_dcache_arb_st_dirty_req,       
input  wire                                       snq_dcache_arb_st_req,             
input  wire                                       snq_dcache_arb_st_tag_gateclk_en,  
input  wire                                       snq_dcache_arb_st_tag_req,    

output wire                                       dcache_arb_prq_ld_grnt,
input  wire                                       prq_dcache_arb_ld_req,
input  wire                                       prq_dcache_arb_ld_tag_req,
input  wire                                       prq_dcache_arb_ld_tag_gateclk_en,
input  wire  [`WK_LS_DCACHE_LDTAG_IDX_MSB :0]     prq_dcache_arb_ld_tag_idx,
input  wire  [`WK_PA_WIDTH-7 :0]                  prq_dcache_arb_borrow_pa_tto6,

input  wire  [`WK_LS_DCACHE_WAYIDX_WIDTH-1 :0]    vb_dcache_arb_data_way,            
input  wire                                       vb_dcache_arb_dcache_replace,      
input  wire                                       vb_dcache_arb_ld_borrow_req,       
input  wire                                       vb_dcache_arb_ld_borrow_req_gate,  
input  wire                                       vb_dcache_arb_ld_req,              
input  wire                                       vb_dcache_arb_ld_tag_gateclk_en,   
input  wire                                       vb_dcache_arb_ld_tag_req,          
input  wire  [`WK_PA_WIDTH-1 :0]                  vb_dcache_arb_borrow_addr,         
input  wire  [`WK_LS_DCACHE_DATA_WORDS_NUM-1  :0] vb_dcache_arb_ld_data_gateclk_en,  
input  wire  [`WK_LS_DCACHE_DATA_IDX_MSB      :0] vb_dcache_arb_ld_data_idx,         
input  wire  [`WK_LS_DCACHE_LDTAG_IDX_MSB     :0] vb_dcache_arb_ld_tag_idx,          
input  wire  [`WK_LS_DCACHE_WAYS_NUM-1        :0] vb_dcache_arb_ld_tag_wen,          
input  wire  [`WK_LS_DCACHE_META_WIDTH-1      :0] vb_dcache_arb_st_dirty_din,        
input  wire  [`WK_LS_DCACHE_META_IDX_MSB      :0] vb_dcache_arb_st_dirty_idx,        
input  wire  [`WK_LS_DCACHE_META_NOECC_WIDTH-1:0] vb_dcache_arb_st_dirty_wen,        
input  wire  [`WK_LS_DCACHE_LDTAG_IDX_MSB     :0] vb_dcache_arb_st_tag_idx,          
input  wire  [`WK_LS_VB_DATA_ENTRY-1  :0]         vb_rcl_sm_data_id,                 
input  wire                                       vb_dcache_arb_serial_req,          
input  wire                                       vb_dcache_arb_set_way_mode,        
input  wire                                       vb_dcache_arb_st_borrow_req,       
input  wire                                       vb_dcache_arb_st_dirty_gateclk_en, 
input  wire                                       vb_dcache_arb_st_dirty_gwen,       
input  wire                                       vb_dcache_arb_st_dirty_req,        
input  wire                                       vb_dcache_arb_st_req,              
input  wire                                       vb_dcache_arb_st_tag_gateclk_en,   
input  wire                                       vb_dcache_arb_st_tag_req,          
input  wire  [`WK_LS_DCACHE_WAYIDX_WIDTH-1 :0]    wmb_dcache_arb_data_way,              
input  wire                                       wmb_dcache_arb_ld_borrow_req,      
input  wire  [`WK_PA_WIDTH-1 :0]                  wmb_dcache_arb_borrow_addr,        
input  wire  [155:0]                              wmb_dcache_arb_ld_data_1st_din,    
input  wire  [155:0]                              wmb_dcache_arb_ld_data_2nd_din,   
input  wire  [155:0]                              wmb_dcache_arb_ld_data_3rd_din,    
input  wire  [155:0]                              wmb_dcache_arb_ld_data_4th_din,   
input  wire                                       wmb_dcache_arb_ld_req,             
input  wire                                       wmb_dcache_arb_ld_tag_gateclk_en,  
input  wire                                       wmb_dcache_arb_ld_tag_req,         
input  wire  [`WK_LS_DCACHE_DATA_WORDS_NUM-1  :0] wmb_dcache_arb_ld_data_gateclk_en, 
input  wire  [`WK_LS_DCACHE_DATA_WORDS_NUM-1  :0] wmb_dcache_arb_ld_data_req,        
input  wire  [`WK_LS_DCACHE_DATA_WORDS_NUM-1  :0] wmb_dcache_arb_ld_data_gwen,       
input  wire  [`WK_LS_DCACHE_DATA_BYTES_NUM-1  :0] wmb_dcache_arb_ld_data_wen,        
input  wire  [`WK_LS_DCACHE_DATA_IDX_MSB      :0] wmb_dcache_arb_ld_data_idx,        
input  wire  [`WK_LS_DCACHE_LDTAG_IDX_MSB     :0] wmb_dcache_arb_ld_tag_idx,         
input  wire  [`WK_LS_DCACHE_WAYS_NUM-1        :0] wmb_dcache_arb_ld_tag_wen,         
input  wire  [`WK_LS_DCACHE_META_WIDTH-1      :0] wmb_dcache_arb_st_dirty_din,       
input  wire  [`WK_LS_DCACHE_META_IDX_MSB      :0] wmb_dcache_arb_st_dirty_idx,       
input  wire  [`WK_LS_DCACHE_META_NOECC_WIDTH-1:0] wmb_dcache_arb_st_dirty_wen,       
input  wire                                       wmb_dcache_arb_st_dirty_gateclk_en, 
input  wire                                       wmb_dcache_arb_st_dirty_req,       
input  wire                                       wmb_dcache_arb_st_icc_req,         
input  wire                                       wmb_dcache_arb_st_req,             
output wire                                       dcache_arb_ag_ld_sel,              
output wire                                       dcache_arb_ag_st_sel,              
output wire                                       dcache_arb_icc_ld_grnt,            
output wire  [`WK_PA_WIDTH-1 :0]                  dcache_arb_ld_ag_addr,             
output wire                                       dcache_arb_ld_ag_borrow_addr_vld,  
output wire  [`WK_LS_VB_DATA_ENTRY-1  :0]         dcache_arb_ld_dc_borrow_db,        
output wire                                       dcache_arb_ld_dc_borrow_icc,       
output wire  [1  :0]                              dcache_arb_ld_dc_borrow_idx_5to4,  
output wire                                       dcache_arb_ld_dc_borrow_mmu,       
output wire                                       dcache_arb_ld_dc_borrow_prq,       
output wire                                       dcache_arb_ld_dc_borrow_sndb,      
output wire                                       dcache_arb_ld_dc_borrow_vb,        
output wire                                       dcache_arb_ld_dc_borrow_vld,       
output wire                                       dcache_arb_ld_dc_borrow_vld_gate,  
output wire                                       dcache_arb_ld_dc_borrow_wmb,       
output wire   [`WK_LS_DCACHE_WAYIDX_WIDTH-1 :0]   dcache_arb_ld_dc_settle_way,       
output wire                                       dcache_arb_lfb_ld_grnt,            
output wire                                       dcache_arb_mcic_ld_grnt,           
output wire                                       dcache_arb_snq_ld_grnt,            
output wire                                       dcache_arb_snq_st_grnt,            
output wire  [`WK_PA_WIDTH-1 :0]                  dcache_arb_st_ag_addr,             
output wire                                       dcache_arb_st_ag_borrow_addr_vld,  
output wire                                       dcache_arb_st_dc_borrow_icc,       
output wire                                       dcache_arb_st_dc_borrow_snq,       
output wire  [`WK_LS_SNQ_ENTRY-1 :0]              dcache_arb_st_dc_borrow_snq_id,    
output wire                                       dcache_arb_st_dc_borrow_vld,       
output wire                                       dcache_arb_st_dc_borrow_vld_gate,  
output wire                                       dcache_arb_st_dc_dcache_replace,   
output wire  [`WK_LS_DCACHE_WAYIDX_WIDTH-1 :0]    dcache_arb_st_dc_dcache_sw,        
output wire                                       dcache_arb_vb_ld_grnt,             
output wire                                       dcache_arb_vb_st_grnt,             
output wire                                       dcache_arb_wmb_ld_grnt,            
output wire                                       dcache_dirty_gwen,                 
output reg   [`WK_LS_DCACHE_META_IDX_MSB      :0] dcache_idx,                        
output reg   [`WK_LS_DCACHE_META_NOECC_WIDTH-1:0] dcache_dirty_wen,                  
output reg   [`WK_LS_DCACHE_META_NOECC_WIDTH-1:0] dcache_dirty_din,                  
output wire  [`WK_LS_DCACHE_TAG_NOECC_WIDTH-1 :0] dcache_tag_din,                    
output wire  [`WK_LS_DCACHE_WAYS_NUM-1        :0] dcache_tag_wen,                    
output wire                                       dcache_snq_st_sel,                 
output wire                                       dcache_tag_gwen,                   
output wire                                       dcache_vb_snq_gwen,                
output wire                                       lsu_dcache_ld_data_borrow,
output wire  [`WK_LS_DCACHE_DATA_WORDS_NUM-1 :0]  lsu_dcache_ld_data_sel_b,          
output wire  [`WK_LS_DCACHE_DATA_WORDS_NUM-1 :0]  lsu_dcache_ld_data_gateclk_en,     
output wire  [`WK_LS_DCACHE_DATA_WORDS_NUM-1 :0]  lsu_dcache_ld_data_gwen_b,         
output wire  [`WK_LS_DCACHE_DATA_BYTES_NUM-1 :0]  lsu_dcache_ld_data_wen_b,          
output wire  [155:0]                              lsu_dcache_ld_data_1st_din,        
output wire  [155:0]                              lsu_dcache_ld_data_2nd_din,       
output wire  [155:0]                              lsu_dcache_ld_data_3rd_din,        
output wire  [155:0]                              lsu_dcache_ld_data_4th_din,       
output wire                                       lsu_dcache_ld_tag_gateclk_en,      
output wire                                       lsu_dcache_ld_tag_gwen_b,          
output wire                                       lsu_dcache_ld_tag_sel_b,           
output wire                                       lsu_dcache_ld_xx_gwen,             
output reg   [`WK_LS_DCACHE_DATA_IDX_MSB     :0]  lsu_dcache_ld_data_1st_idx,        
output reg   [`WK_LS_DCACHE_DATA_IDX_MSB     :0]  lsu_dcache_ld_data_2nd_idx,       
output reg   [`WK_LS_DCACHE_DATA_IDX_MSB     :0]  lsu_dcache_ld_data_3rd_idx,        
output reg   [`WK_LS_DCACHE_DATA_IDX_MSB     :0]  lsu_dcache_ld_data_4th_idx,       
output wire  [`WK_LS_DCACHE_WAYS_NUM-1       :0]  lsu_dcache_ld_tag_wen_b,           
output wire  [`WK_LS_DCACHE_LDTAG_WIDTH-1    :0]  lsu_dcache_ld_tag_din,             
output reg   [`WK_LS_DCACHE_LDTAG_IDX_MSB    :0]  lsu_dcache_ld_tag_idx,             
output wire  [`WK_LS_DCACHE_META_WIDTH-1     :0]  lsu_dcache_st_dirty_wen_b,         
output reg   [`WK_LS_DCACHE_META_IDX_MSB     :0]  lsu_dcache_st_dirty_idx,           
output wire  [`WK_LS_DCACHE_META_WIDTH-1     :0]  lsu_dcache_st_dirty_din,           
output wire  [`WK_LS_DCACHE_WAYS_NUM-1       :0]  lsu_dcache_st_tag_wen_b,           
output wire  [`WK_LS_DCACHE_TAG_NOECC_WIDTH-1:0]  lsu_dcache_st_tag_din,             
output reg   [`WK_LS_DCACHE_LDTAG_IDX_MSB    :0]  lsu_dcache_st_tag_idx,             
output wire                                       lsu_dcache_st_dirty_gateclk_en,    
output wire                                       lsu_dcache_st_dirty_gwen_b,        
output wire                                       lsu_dcache_st_dirty_sel_b,         
output wire                                       lsu_dcache_st_tag_gateclk_en,      
output wire                                       lsu_dcache_st_tag_gwen_b,          
output wire                                       lsu_dcache_st_tag_sel_b           
);
// &Regs; @25
reg     [10  :0]                                  dcache_arb_ld_sel;                 
reg     [6  :0]                                   dcache_arb_st_sel;                 
reg                                               dcache_arb_serial_lfb;             
reg                                               dcache_arb_serial_snq;             
reg                                               dcache_arb_serial_vb;              
reg                                               dcache_arb_serial_vld;             

// &Wires; @26
wire    [`WK_LS_DCACHE_DATA_WORDS_NUM-1   :0]     lsu_dcache_ld_data_gwen;           
wire    [`WK_LS_DCACHE_DATA_BYTES_NUM-1   :0]     lsu_dcache_ld_data_wen;            
wire    [`WK_LS_DCACHE_WAYS_NUM-1         :0]     lsu_dcache_ld_tag_wen;             
wire    [`WK_LS_DCACHE_WAYS_NUM-1         :0]     lsu_dcache_st_tag_wen;             
wire    [`WK_LS_DCACHE_META_NOECC_WIDTH-1 :0]     lsu_dcache_st_dirty_wen;           
wire    [`WK_LS_DCACHE_DATA_WORDS_NUM-1   :0]     dcache_arb_ld_data_req;            
wire                                              dcache_arb_ag_ld_dp_sel;           
wire                                              dcache_arb_ag_ld_sel_unmask;       
wire                                              dcache_arb_ag_st_dp_sel;           
wire                                              dcache_arb_ag_st_sel_unmask;       
wire                                              dcache_arb_icc_ld_dp_sel;          
wire                                              dcache_arb_icc_ld_sel;             
wire                                              dcache_arb_icc_ld_sel_unmask;      
wire                                              dcache_arb_icc_st_dp_sel;          
wire                                              dcache_arb_icc_st_sel;             
wire                                              dcache_arb_icc_st_sel_unmask;      
wire    [7  :0]                                   dcache_arb_ld_tag_sel_id;           
wire    [6  :0]                                   dcache_arb_ld_dp_sel_id;           
wire    [7  :0]                                   dcache_arb_ld_req;
wire                                              dcache_arb_ld_tag_req;             
wire                                              dcache_arb_lfb_ld_dp_sel;          
wire                                              dcache_arb_lfb_ld_sel;             
wire                                              dcache_arb_lfb_ld_sel_unmask;      
wire                                              dcache_arb_lfb_st_dp_sel;          
wire                                              dcache_arb_lfb_st_sel;             
wire                                              dcache_arb_lfb_st_sel_unmask;      
wire                                              dcache_arb_mcic_ld_dp_sel;         
wire                                              dcache_arb_mcic_ld_sel;            
wire                                              dcache_arb_mcic_ld_sel_unmask;     
wire                                              dcache_arb_serial_clk;             
wire                                              dcache_arb_serial_clk_en;          
wire                                              dcache_arb_serial_lfb_sel;         
wire                                              dcache_arb_serial_req;             
wire                                              dcache_arb_serial_snq_sel;         
wire                                              dcache_arb_serial_vb_sel;          
wire                                              dcache_arb_snq_ld_dp_sel;          
wire                                              dcache_arb_snq_ld_sel;             
wire                                              dcache_arb_snq_ld_sel_unmask;      
wire                                              dcache_arb_snq_st_dp_sel;          
wire                                              dcache_arb_snq_st_sel;             
wire                                              dcache_arb_snq_st_sel_unmask;      
wire                                              dcache_arb_st_dirty_req;           
wire    [5  :0]                                   dcache_arb_st_dp_sel_id;           
wire    [5  :0]                                   dcache_arb_st_req;                 
wire                                              dcache_arb_st_tag_req;             
wire                                              dcache_arb_vb_ld_dp_sel;           
wire                                              dcache_arb_vb_ld_sel;              
wire                                              dcache_arb_vb_ld_sel_unmask;       
wire                                              dcache_arb_vb_st_dp_sel;           
wire                                              dcache_arb_vb_st_sel;              
wire                                              dcache_arb_vb_st_sel_unmask;       
wire                                              dcache_arb_wmb_ld_dp_sel;          
wire                                              dcache_arb_wmb_ld_sel;             
wire                                              dcache_arb_wmb_ld_sel_unmask;      
wire                                              dcache_arb_wmb_st_dp_sel;          
wire                                              dcache_arb_wmb_st_sel;             
wire                                              dcache_arb_wmb_st_sel_unmask;      
wire                                              lsu_dcache_ld_tag_gwen;   // wjh@chkdsi
wire                                              lsu_dcache_st_tag_gwen;   // wjh@chkdsi
wire                                              lsu_dcache_st_dirty_gwen; // wjh@chkdsi
wire                                              dcache_arb_prq_ld_sel;
wire                                              dcache_arb_prq_ld_sel_unmask;
wire                                              dcache_arb_prq_ld_dp_sel;

//==========================================================
//                 Instance of Gated Cell  
//==========================================================
assign dcache_arb_serial_clk_en = dcache_arb_serial_vld
                                  ||  dcache_arb_serial_req;
// &Instance("gated_clk_cell", "x_lsu_dcache_serial_clk_en"); @36
gated_clk_cell  x_lsu_dcache_serial_clk_en (
  .clk_in                   (forever_cpuclk          ),
  .clk_out                  (dcache_arb_serial_clk   ),
  .external_en              (1'b0                    ),
  .local_en                 (dcache_arb_serial_clk_en),
  .module_en                (cp0_lsu_icg_en          ),
  .pad_yy_icg_scan_en       (pad_yy_icg_scan_en      )
);

//==========================================================
//                 Serial request registers
//==========================================================
always @(posedge dcache_arb_serial_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    dcache_arb_serial_vld   <=  1'b0;
    dcache_arb_serial_lfb   <=  1'b0;
    dcache_arb_serial_vb    <=  1'b0;
    dcache_arb_serial_snq   <=  1'b0;
  end
  else if(dcache_arb_serial_req)
  begin
    dcache_arb_serial_vld   <=  1'b1;
    dcache_arb_serial_lfb   <=  dcache_arb_serial_lfb_sel;
    dcache_arb_serial_vb    <=  dcache_arb_serial_vb_sel;
    dcache_arb_serial_snq   <=  dcache_arb_serial_snq_sel;
  end
  else
  begin
    dcache_arb_serial_vld   <=  1'b0;
    dcache_arb_serial_lfb   <=  1'b0;
    dcache_arb_serial_vb    <=  1'b0;
    dcache_arb_serial_snq   <=  1'b0;
  end
end

//==========================================================
//                 Serial wires
//==========================================================
assign dcache_arb_serial_req      = dcache_arb_serial_lfb_sel
                                    ||  dcache_arb_serial_vb_sel
                                    ||  dcache_arb_serial_snq_sel;

assign dcache_arb_serial_lfb_sel  = dcache_arb_lfb_ld_sel &&  lfb_dcache_arb_serial_req;
assign dcache_arb_serial_vb_sel   = dcache_arb_vb_ld_sel &&  vb_dcache_arb_serial_req;
assign dcache_arb_serial_snq_sel  = dcache_arb_snq_ld_sel &&  snq_dcache_arb_serial_req;

//==========================================================
//              Sel/Grnt signal for LD part
//==========================================================
//1. lfb state machine
//2. vb state machine
//3. snq/sndb req
//4. mmu dcache issue controller
//5. wmb
//6. icc
//7. prq
//8. ld ag stage

//------------------unmask signal---------------------------

assign dcache_arb_ld_req[7:0] = {dcache_arb_serial_vld,
                                lfb_dcache_arb_ld_req,
                                vb_dcache_arb_ld_req,
                                snq_dcache_arb_ld_req,
                                icc_dcache_arb_ld_req,
                                wmb_dcache_arb_ld_req,
                                mcic_dcache_arb_ld_req,
                                prq_dcache_arb_ld_req};

//select signal send back to the source
// &CombBeg; @104
always @( dcache_arb_ld_req[7:0])
begin
dcache_arb_ld_sel[7:0] = 8'b0;
casez(dcache_arb_ld_req[7:0])
  8'b01??_????:dcache_arb_ld_sel[7]  = 1'b1;
  8'b001?_????:dcache_arb_ld_sel[6]  = 1'b1;
  8'b0001_????:dcache_arb_ld_sel[5]  = 1'b1;
  8'b0000_1???:dcache_arb_ld_sel[4]  = 1'b1;
  8'b0000_01??:dcache_arb_ld_sel[3]  = 1'b1;
  8'b0000_001?:dcache_arb_ld_sel[2]  = 1'b1;
  8'b0000_0001:dcache_arb_ld_sel[1]  = 1'b1;
  8'b0000_0000:dcache_arb_ld_sel[0]  = 1'b1;
  default:dcache_arb_ld_sel[7:0] = 8'b0;
endcase
// &CombEnd; @116
end

assign dcache_arb_lfb_ld_sel_unmask   = dcache_arb_ld_sel[7];
assign dcache_arb_vb_ld_sel_unmask    = dcache_arb_ld_sel[6];
assign dcache_arb_snq_ld_sel_unmask   = dcache_arb_ld_sel[5];
assign dcache_arb_icc_ld_sel_unmask   = dcache_arb_ld_sel[4];
assign dcache_arb_wmb_ld_sel_unmask   = dcache_arb_ld_sel[3];
assign dcache_arb_mcic_ld_sel_unmask  = dcache_arb_ld_sel[2];
assign dcache_arb_prq_ld_sel_unmask   = dcache_arb_ld_sel[1]; // mark 4->1
assign dcache_arb_ag_ld_sel_unmask    = dcache_arb_ld_sel[0];

//------------------masked signal---------------------------
//because lfb/vb/snq/icc may request ld and st pipeline once a time,
//to insure that they can get both sel signal simultaneously,
//if they request 2 pipeline and get 1 sel, then it must be clr to 0.
assign dcache_arb_lfb_ld_sel  = dcache_arb_lfb_ld_sel_unmask
                                    &&  (!lfb_dcache_arb_st_req
                                        ||  dcache_arb_lfb_st_sel_unmask)
                                ||  dcache_arb_serial_lfb;
assign dcache_arb_vb_ld_sel   = dcache_arb_vb_ld_sel_unmask
                                    &&  (!vb_dcache_arb_st_req
                                        ||  dcache_arb_vb_st_sel_unmask)
                                ||  dcache_arb_serial_vb;
assign dcache_arb_prq_ld_sel  = dcache_arb_prq_ld_sel_unmask;
assign dcache_arb_snq_ld_sel  = dcache_arb_snq_ld_sel_unmask
                                    &&  (!snq_dcache_arb_st_req
                                        ||  dcache_arb_snq_st_sel_unmask)
                                ||  dcache_arb_serial_snq;
assign dcache_arb_wmb_ld_sel  = dcache_arb_wmb_ld_sel_unmask
                                &&  dcache_arb_wmb_st_sel_unmask;
assign dcache_arb_icc_ld_sel  = dcache_arb_icc_ld_sel_unmask
                                &&  dcache_arb_icc_st_sel_unmask;
assign dcache_arb_mcic_ld_sel = dcache_arb_mcic_ld_sel_unmask;
// &Force("output", "dcache_arb_ag_ld_sel"); @147
assign dcache_arb_ag_ld_sel   = dcache_arb_ag_ld_sel_unmask;

//----------shorten signal to select signal-----------------
assign dcache_arb_lfb_ld_dp_sel  = dcache_arb_lfb_ld_sel_unmask  ||  dcache_arb_serial_lfb;
assign dcache_arb_vb_ld_dp_sel   = dcache_arb_vb_ld_sel_unmask   ||  dcache_arb_serial_vb;
assign dcache_arb_prq_ld_dp_sel  = dcache_arb_prq_ld_sel_unmask;
assign dcache_arb_snq_ld_dp_sel  = dcache_arb_snq_ld_sel_unmask  ||  dcache_arb_serial_snq;
assign dcache_arb_wmb_ld_dp_sel  = dcache_arb_wmb_ld_sel_unmask;
assign dcache_arb_icc_ld_dp_sel  = dcache_arb_icc_ld_sel_unmask;
assign dcache_arb_mcic_ld_dp_sel = dcache_arb_mcic_ld_sel_unmask;
assign dcache_arb_ag_ld_dp_sel   = dcache_arb_ag_ld_sel_unmask;

assign dcache_arb_ld_dp_sel_id[6:0] = {dcache_arb_lfb_ld_dp_sel,  //prq do not read data
                                      dcache_arb_vb_ld_dp_sel,
                                      dcache_arb_snq_ld_dp_sel,
                                      dcache_arb_wmb_ld_dp_sel,
                                      dcache_arb_icc_ld_dp_sel,
                                      dcache_arb_mcic_ld_dp_sel,
                                      dcache_arb_ag_ld_dp_sel};

assign dcache_arb_ld_tag_sel_id[7:0] = {dcache_arb_lfb_ld_dp_sel,  //prq do not read data
                                      dcache_arb_vb_ld_dp_sel,
                                      dcache_arb_snq_ld_dp_sel,
                                      dcache_arb_wmb_ld_dp_sel,
                                      dcache_arb_icc_ld_dp_sel,
                                      dcache_arb_mcic_ld_dp_sel,
                                      dcache_arb_prq_ld_dp_sel,
                                      dcache_arb_ag_ld_dp_sel};

//------------------grnt   signal---------------------------
assign dcache_arb_lfb_ld_grnt = dcache_arb_lfb_ld_sel;
assign dcache_arb_vb_ld_grnt  = dcache_arb_vb_ld_sel;
assign dcache_arb_snq_ld_grnt = dcache_arb_snq_ld_sel;
assign dcache_arb_wmb_ld_grnt = dcache_arb_wmb_ld_sel;
assign dcache_arb_icc_ld_grnt = dcache_arb_icc_ld_sel;
assign dcache_arb_mcic_ld_grnt= dcache_arb_mcic_ld_sel;
assign dcache_arb_prq_ld_grnt = dcache_arb_prq_ld_sel;
//assign dcache_arb_ag_ld_grnt  = dcache_arb_ag_ld_sel  &&  ag_dcache_arb_ld_req;

//==========================================================
//        Borrow signal for LD part to DC stage
//==========================================================
//if vb request data, mmu request data, they will borrow ld dc/da stage
//-----------------------borrow addr------------------------
assign dcache_arb_ld_ag_borrow_addr_vld = dcache_arb_mcic_ld_sel || dcache_arb_prq_ld_sel
                                          || dcache_arb_wmb_ld_sel  &&  wmb_dcache_arb_ld_borrow_req
                                          || dcache_arb_vb_ld_sel && vb_dcache_arb_ld_borrow_req_gate
                                          || dcache_arb_snq_ld_sel && snq_dcache_arb_ld_borrow_req_gate;

assign dcache_arb_ld_ag_addr[`WK_PA_WIDTH-1:0]      = {`WK_PA_WIDTH{dcache_arb_mcic_ld_sel}}
                                                        & mcic_dcache_arb_req_addr[`WK_PA_WIDTH-1:0]
                                                      | {`WK_PA_WIDTH{dcache_arb_prq_ld_sel}}
                                                        & {prq_dcache_arb_borrow_pa_tto6, {6{1'b0}}}
                                                      | {`WK_PA_WIDTH{dcache_arb_wmb_ld_sel}}
                                                        & wmb_dcache_arb_borrow_addr[`WK_PA_WIDTH-1:0]
                                                      | {`WK_PA_WIDTH{dcache_arb_vb_ld_sel}}
                                                        & vb_dcache_arb_borrow_addr[`WK_PA_WIDTH-1:0]
                                                      | {`WK_PA_WIDTH{dcache_arb_snq_ld_sel}}
                                                        & snq_dcache_arb_borrow_addr[`WK_PA_WIDTH-1:0];

//---------------------borrow signal------------------------
assign dcache_arb_ld_dc_borrow_vld  = dcache_arb_vb_ld_sel  &&  vb_dcache_arb_ld_borrow_req
                                      ||  dcache_arb_snq_ld_sel  &&  snq_dcache_arb_ld_borrow_req
                                      ||  dcache_arb_icc_ld_sel  &&  icc_dcache_arb_ld_borrow_req
                                      ||  dcache_arb_wmb_ld_sel  &&  wmb_dcache_arb_ld_borrow_req
                                      ||  dcache_arb_mcic_ld_sel || dcache_arb_prq_ld_sel;

assign dcache_arb_ld_dc_borrow_vld_gate  = dcache_arb_vb_ld_sel  &&  vb_dcache_arb_ld_borrow_req_gate
                                           ||  dcache_arb_snq_ld_sel  &&  snq_dcache_arb_ld_borrow_req_gate
                                           ||  dcache_arb_icc_ld_sel  &&  icc_dcache_arb_ld_borrow_req
                                           ||  dcache_arb_wmb_ld_sel  &&  wmb_dcache_arb_ld_borrow_req
                                           ||  dcache_arb_mcic_ld_sel || dcache_arb_prq_ld_sel;

assign dcache_arb_ld_dc_borrow_db[`WK_LS_VB_DATA_ENTRY-1:0]  = dcache_arb_vb_ld_sel
                                                        ? vb_rcl_sm_data_id[`WK_LS_VB_DATA_ENTRY-1:0]
                                                        : snq_dcache_sdb_id[`WK_LS_VB_DATA_ENTRY-1:0];
assign dcache_arb_ld_dc_borrow_vb   = dcache_arb_vb_ld_sel;
assign dcache_arb_ld_dc_borrow_sndb = dcache_arb_snq_ld_sel;
assign dcache_arb_ld_dc_borrow_mmu  = dcache_arb_mcic_ld_sel;
assign dcache_arb_ld_dc_borrow_icc  = dcache_arb_icc_ld_sel;
assign dcache_arb_ld_dc_borrow_wmb  = dcache_arb_wmb_ld_sel;
assign dcache_arb_ld_dc_borrow_prq  = dcache_arb_prq_ld_sel;

//borrow way is used
assign dcache_arb_ld_dc_settle_way  =    {`WK_LS_DCACHE_WAYIDX_WIDTH{dcache_arb_vb_ld_sel }}  &  vb_dcache_arb_data_way
                                      |  {`WK_LS_DCACHE_WAYIDX_WIDTH{dcache_arb_snq_ld_sel}}  &  snq_dcache_arb_data_way
                                      |  {`WK_LS_DCACHE_WAYIDX_WIDTH{dcache_arb_icc_ld_sel}}  &  icc_dcache_arb_data_way
                                      |  {`WK_LS_DCACHE_WAYIDX_WIDTH{dcache_arb_wmb_ld_sel}}  &  wmb_dcache_arb_data_way;

//==========================================================
//        Input select for LD part
//==========================================================
//------------------tag   array-----------------------------
//-----------gateclk--------------------
assign lsu_dcache_ld_tag_gateclk_en = lfb_dcache_arb_ld_tag_gateclk_en
                                      ||  vb_dcache_arb_ld_tag_gateclk_en
                                      ||  snq_dcache_arb_ld_tag_gateclk_en
                                      ||  prq_dcache_arb_ld_tag_gateclk_en
                                      ||  wmb_dcache_arb_ld_tag_gateclk_en
                                      ||  icc_dcache_arb_ld_tag_gateclk_en
                                      ||  mcic_dcache_arb_ld_tag_gateclk_en
                                      ||  ag_dcache_arb_ld_tag_gateclk_en;

//-----------interface------------------
assign dcache_arb_ld_tag_req  = dcache_arb_lfb_ld_sel  &&  lfb_dcache_arb_ld_tag_req
                                ||  dcache_arb_vb_ld_sel    &&  vb_dcache_arb_ld_tag_req
                                ||  dcache_arb_snq_ld_sel   &&  snq_dcache_arb_ld_tag_req
                                ||  dcache_arb_wmb_ld_sel   &&  wmb_dcache_arb_ld_tag_req
                                ||  dcache_arb_icc_ld_sel   &&  icc_dcache_arb_ld_tag_req
                                ||  dcache_arb_mcic_ld_sel
                                ||  dcache_arb_prq_ld_sel   &&  prq_dcache_arb_ld_tag_req
                                ||  dcache_arb_ag_ld_sel    &&  ag_dcache_arb_ld_tag_req;

assign lsu_dcache_ld_tag_sel_b    = !dcache_arb_ld_tag_req;

// &CombBeg; @249
always @( icc_dcache_arb_ld_tag_idx
       or wmb_dcache_arb_ld_tag_idx
       or ag_dcache_arb_ld_tag_idx
       or prq_dcache_arb_ld_tag_idx
       or snq_dcache_arb_ld_tag_idx
       or vb_dcache_arb_ld_tag_idx
       or lfb_dcache_arb_ld_tag_idx
       or mcic_dcache_arb_ld_tag_idx
       or dcache_arb_ld_tag_sel_id[7:0])
begin
case(dcache_arb_ld_tag_sel_id[7:0])
  8'b1000_0000:lsu_dcache_ld_tag_idx  = lfb_dcache_arb_ld_tag_idx;
  8'b0100_0000:lsu_dcache_ld_tag_idx  =  vb_dcache_arb_ld_tag_idx;
  8'b0010_0000:lsu_dcache_ld_tag_idx  = snq_dcache_arb_ld_tag_idx;
  8'b0001_0000:lsu_dcache_ld_tag_idx  = wmb_dcache_arb_ld_tag_idx;
  8'b0000_1000:lsu_dcache_ld_tag_idx  = icc_dcache_arb_ld_tag_idx;
  8'b0000_0100:lsu_dcache_ld_tag_idx  = mcic_dcache_arb_ld_tag_idx;
  8'b0000_0010:lsu_dcache_ld_tag_idx  = prq_dcache_arb_ld_tag_idx;
  8'b0000_0001:lsu_dcache_ld_tag_idx  = ag_dcache_arb_ld_tag_idx;
  default:    lsu_dcache_ld_tag_idx  = {`WK_LS_DCACHE_LDTAG_IDX_MSB+1{1'bx}};
endcase
// &CombEnd; @260
end

//only lfb can write tag array, while vb/snq/wmb/icc can clear tag and valid bit.
// &Force("output","lsu_dcache_ld_tag_din"); @270
assign lsu_dcache_ld_tag_din  = {`WK_LS_DCACHE_LDTAG_WIDTH{dcache_arb_lfb_ld_dp_sel}} & lfb_dcache_arb_ld_tag_din
                                    | {`WK_LS_DCACHE_LDTAG_WIDTH{dcache_arb_snq_ld_dp_sel}} & snq_dcache_arb_ld_tag_din; //added by xj@2025.02.20 

assign lsu_dcache_ld_tag_gwen     = dcache_arb_lfb_ld_dp_sel
                                    | dcache_arb_vb_ld_dp_sel
                                    | dcache_arb_snq_ld_dp_sel
                                    | dcache_arb_wmb_ld_dp_sel
                                    | dcache_arb_icc_ld_dp_sel && !icc_dcache_arb_ld_tag_read;
assign lsu_dcache_ld_tag_gwen_b   = !lsu_dcache_ld_tag_gwen;

assign lsu_dcache_ld_tag_wen = {`WK_LS_DCACHE_WAYS_NUM{dcache_arb_lfb_ld_dp_sel}} & lfb_dcache_arb_ld_tag_wen
                             | {`WK_LS_DCACHE_WAYS_NUM{dcache_arb_vb_ld_dp_sel}}  &  vb_dcache_arb_ld_tag_wen
                             | {`WK_LS_DCACHE_WAYS_NUM{dcache_arb_snq_ld_dp_sel}} & snq_dcache_arb_ld_tag_wen
                             | {`WK_LS_DCACHE_WAYS_NUM{dcache_arb_wmb_ld_dp_sel}} & wmb_dcache_arb_ld_tag_wen
                             | {`WK_LS_DCACHE_WAYS_NUM{dcache_arb_icc_ld_dp_sel}} & {`WK_LS_DCACHE_WAYS_NUM{1'b1}};
assign lsu_dcache_ld_tag_wen_b = ~lsu_dcache_ld_tag_wen;

//------------------for cache buffer-----------------------------
assign lsu_dcache_ld_xx_gwen        = lsu_dcache_ld_tag_gwen;
//assign lsu_dcache_ld_xx_gwen_short  = dcache_arb_lfb_ld_dp_sel
//                                      ||  dcache_arb_vb_ld_dp_sel
//                                      ||  dcache_arb_snq_ld_dp_sel;

//------------------data  array-----------------------------
//-----------gateclk--------------------
assign lsu_dcache_ld_data_gateclk_en =   lfb_dcache_arb_ld_data_gateclk_en
                                            | vb_dcache_arb_ld_data_gateclk_en
                                            | snq_dcache_arb_ld_data_gateclk_en
                                            | wmb_dcache_arb_ld_data_gateclk_en
                                            | mcic_dcache_arb_ld_data_gateclk_en
                                            | icc_dcache_arb_ld_data_gateclk_en
                                            | ag_dcache_arb_ld_data_gateclk_en;

//-----------interface------------------
assign dcache_arb_ld_data_req  =        {`WK_LS_DCACHE_DATA_WORDS_NUM{dcache_arb_lfb_ld_sel}} & lfb_dcache_arb_ld_data_req
                                      | {`WK_LS_DCACHE_DATA_WORDS_NUM{dcache_arb_vb_ld_sel}}
                                      | {`WK_LS_DCACHE_DATA_WORDS_NUM{dcache_arb_snq_ld_sel}}
                                      | {`WK_LS_DCACHE_DATA_WORDS_NUM{dcache_arb_wmb_ld_sel}} & wmb_dcache_arb_ld_data_req
                                      | {`WK_LS_DCACHE_DATA_WORDS_NUM{dcache_arb_mcic_ld_sel}}& mcic_dcache_arb_ld_data_req
                                      | {`WK_LS_DCACHE_DATA_WORDS_NUM{dcache_arb_ag_ld_sel}}  & ag_dcache_arb_ld_data_req
                                      | {`WK_LS_DCACHE_DATA_WORDS_NUM{dcache_arb_icc_ld_sel}} & icc_dcache_arb_ld_data_req;

assign lsu_dcache_ld_data_sel_b  = ~dcache_arb_ld_data_req;
assign lsu_dcache_ld_data_borrow = dcache_arb_lfb_ld_sel  & |lfb_dcache_arb_ld_data_req
                                 | dcache_arb_vb_ld_sel
                                 | dcache_arb_snq_ld_sel
                                 | dcache_arb_wmb_ld_sel  & |wmb_dcache_arb_ld_data_req
                                 | dcache_arb_mcic_ld_sel & |mcic_dcache_arb_ld_data_req
                                 | dcache_arb_icc_ld_sel  & |icc_dcache_arb_ld_data_req; // release
// &CombBeg; @318
always @( snq_dcache_arb_ld_data_idx
       or vb_dcache_arb_ld_data_idx
       or icc_dcache_arb_ld_data_1st_idx
       or mcic_dcache_arb_ld_data_1st_idx
       or lfb_dcache_arb_ld_data_idx
       or ag_dcache_arb_ld_data_1st_idx
       or wmb_dcache_arb_ld_data_idx
       or dcache_arb_ld_dp_sel_id)
begin
case(dcache_arb_ld_dp_sel_id[6:0])
  7'b100_0000:lsu_dcache_ld_data_1st_idx  = lfb_dcache_arb_ld_data_idx;
  7'b010_0000:lsu_dcache_ld_data_1st_idx  = vb_dcache_arb_ld_data_idx;
  7'b001_0000:lsu_dcache_ld_data_1st_idx  = snq_dcache_arb_ld_data_idx;
  7'b000_1000:lsu_dcache_ld_data_1st_idx  = wmb_dcache_arb_ld_data_idx;
  7'b000_0100:lsu_dcache_ld_data_1st_idx  = icc_dcache_arb_ld_data_1st_idx;
  7'b000_0010:lsu_dcache_ld_data_1st_idx  = mcic_dcache_arb_ld_data_1st_idx;
  7'b000_0001:lsu_dcache_ld_data_1st_idx  = ag_dcache_arb_ld_data_1st_idx;
  default:lsu_dcache_ld_data_1st_idx  = {(`WK_LS_DCACHE_DATA_IDX_MSB+1){1'bx}};
endcase
// &CombEnd; @329
end
// &CombBeg; @338
always @( snq_dcache_arb_ld_data_idx
       or vb_dcache_arb_ld_data_idx
       or lfb_dcache_arb_ld_data_idx
       or mcic_dcache_arb_ld_data_2nd_idx
       or wmb_dcache_arb_ld_data_idx
       or ag_dcache_arb_ld_data_2nd_idx
       or dcache_arb_ld_dp_sel_id
       or icc_dcache_arb_ld_data_2nd_idx)
begin
case(dcache_arb_ld_dp_sel_id[6:0])
  7'b100_0000:lsu_dcache_ld_data_2nd_idx  = lfb_dcache_arb_ld_data_idx;
  7'b010_0000:lsu_dcache_ld_data_2nd_idx  = vb_dcache_arb_ld_data_idx;
  7'b001_0000:lsu_dcache_ld_data_2nd_idx  = snq_dcache_arb_ld_data_idx;
  7'b000_1000:lsu_dcache_ld_data_2nd_idx  = wmb_dcache_arb_ld_data_idx;
  7'b000_0100:lsu_dcache_ld_data_2nd_idx  = icc_dcache_arb_ld_data_2nd_idx;
  7'b000_0010:lsu_dcache_ld_data_2nd_idx  = mcic_dcache_arb_ld_data_2nd_idx;
  7'b000_0001:lsu_dcache_ld_data_2nd_idx  = ag_dcache_arb_ld_data_2nd_idx;
  default:lsu_dcache_ld_data_2nd_idx  = {{`WK_LS_DCACHE_DATA_IDX_MSB+1}{1'bx}};
endcase
end

always @( snq_dcache_arb_ld_data_idx
       or vb_dcache_arb_ld_data_idx
       or lfb_dcache_arb_ld_data_idx
       or mcic_dcache_arb_ld_data_3rd_idx
       or wmb_dcache_arb_ld_data_idx
       or ag_dcache_arb_ld_data_3rd_idx
       or dcache_arb_ld_dp_sel_id
       or icc_dcache_arb_ld_data_3rd_idx)
begin
case(dcache_arb_ld_dp_sel_id[6:0])
  7'b100_0000:lsu_dcache_ld_data_3rd_idx  = lfb_dcache_arb_ld_data_idx;
  7'b010_0000:lsu_dcache_ld_data_3rd_idx  = vb_dcache_arb_ld_data_idx;
  7'b001_0000:lsu_dcache_ld_data_3rd_idx  = snq_dcache_arb_ld_data_idx;
  7'b000_1000:lsu_dcache_ld_data_3rd_idx  = wmb_dcache_arb_ld_data_idx;
  7'b000_0100:lsu_dcache_ld_data_3rd_idx  = icc_dcache_arb_ld_data_3rd_idx;
  7'b000_0010:lsu_dcache_ld_data_3rd_idx  = mcic_dcache_arb_ld_data_3rd_idx;
  7'b000_0001:lsu_dcache_ld_data_3rd_idx  = ag_dcache_arb_ld_data_3rd_idx;
  default:    lsu_dcache_ld_data_3rd_idx  = {{`WK_LS_DCACHE_DATA_IDX_MSB+1}{1'bx}};
endcase
end

always @( snq_dcache_arb_ld_data_idx
       or vb_dcache_arb_ld_data_idx
       or lfb_dcache_arb_ld_data_idx
       or mcic_dcache_arb_ld_data_4th_idx
       or wmb_dcache_arb_ld_data_idx
       or ag_dcache_arb_ld_data_4th_idx
       or dcache_arb_ld_dp_sel_id
       or icc_dcache_arb_ld_data_4th_idx)
begin
case(dcache_arb_ld_dp_sel_id[6:0])
  7'b100_0000:lsu_dcache_ld_data_4th_idx  = lfb_dcache_arb_ld_data_idx;
  7'b010_0000:lsu_dcache_ld_data_4th_idx  = vb_dcache_arb_ld_data_idx;
  7'b001_0000:lsu_dcache_ld_data_4th_idx  = snq_dcache_arb_ld_data_idx;
  7'b000_1000:lsu_dcache_ld_data_4th_idx  = wmb_dcache_arb_ld_data_idx;
  7'b000_0100:lsu_dcache_ld_data_4th_idx  = icc_dcache_arb_ld_data_4th_idx;
  7'b000_0010:lsu_dcache_ld_data_4th_idx  = mcic_dcache_arb_ld_data_4th_idx;
  7'b000_0001:lsu_dcache_ld_data_4th_idx  = ag_dcache_arb_ld_data_4th_idx;
  default:    lsu_dcache_ld_data_4th_idx  = {{`WK_LS_DCACHE_DATA_IDX_MSB+1}{1'bx}};
endcase
end


assign dcache_arb_ld_dc_borrow_idx_5to4[1:0]  = {2{dcache_arb_lfb_ld_sel}} & lfb_dcache_arb_ld_data_idx[1:0]
                                                | {2{dcache_arb_vb_ld_sel}} & vb_dcache_arb_ld_data_idx[1:0]
                                                | {2{dcache_arb_snq_ld_sel}} & snq_dcache_arb_ld_data_idx[1:0]
                                                | {2{dcache_arb_wmb_ld_sel}}  & wmb_dcache_arb_ld_data_idx[1:0];

assign lsu_dcache_ld_data_1st_din[155:0]  = dcache_arb_lfb_ld_dp_sel
                                            ? lfb_dcache_arb_ld_data_1st_din[155:0]
                                            : wmb_dcache_arb_ld_data_1st_din[155:0];

assign lsu_dcache_ld_data_2nd_din[155:0] = dcache_arb_lfb_ld_dp_sel
                                            ? lfb_dcache_arb_ld_data_2nd_din[155:0]
                                            : wmb_dcache_arb_ld_data_2nd_din[155:0];

assign lsu_dcache_ld_data_3rd_din[155:0]  = dcache_arb_lfb_ld_dp_sel
                                            ? lfb_dcache_arb_ld_data_3rd_din[155:0]
                                            : wmb_dcache_arb_ld_data_3rd_din[155:0];

assign lsu_dcache_ld_data_4th_din[155:0] = dcache_arb_lfb_ld_dp_sel
                                            ? lfb_dcache_arb_ld_data_4th_din[155:0]
                                            : wmb_dcache_arb_ld_data_4th_din[155:0];

assign lsu_dcache_ld_data_gwen   =   {`WK_LS_DCACHE_DATA_WORDS_NUM{dcache_arb_lfb_ld_dp_sel}} & {{`WK_LS_DCACHE_DATA_WORDS_NUM/2{lfb_dcache_arb_ld_data_req[8]}},{`WK_LS_DCACHE_DATA_WORDS_NUM/2{lfb_dcache_arb_ld_data_req[0]}}}
                                   | {`WK_LS_DCACHE_DATA_WORDS_NUM{dcache_arb_wmb_ld_dp_sel}} & wmb_dcache_arb_ld_data_gwen;
assign lsu_dcache_ld_data_gwen_b = ~lsu_dcache_ld_data_gwen;

assign lsu_dcache_ld_data_wen    =  {`WK_LS_DCACHE_DATA_BYTES_NUM{dcache_arb_lfb_ld_dp_sel}} & {{`WK_LS_DCACHE_DATA_BYTES_NUM/2{lfb_dcache_arb_ld_data_req[8]}},{`WK_LS_DCACHE_DATA_BYTES_NUM/2{lfb_dcache_arb_ld_data_req[0]}}}
                                   | {`WK_LS_DCACHE_DATA_BYTES_NUM{dcache_arb_wmb_ld_dp_sel}} & wmb_dcache_arb_ld_data_wen;
assign lsu_dcache_ld_data_wen_b  = ~lsu_dcache_ld_data_wen;

//==========================================================
//        Sel/Grnt signal for ST part
//==========================================================
//1. lfb state machine
//2. vb state machine
//3. snq
//4. wmb
//5. icc
//6. st ag stage

//------------------unmask signal---------------------------

assign dcache_arb_st_req[5:0] = {dcache_arb_serial_vld,
                                lfb_dcache_arb_st_req,
                                vb_dcache_arb_st_req,
                                snq_dcache_arb_st_req,
                                icc_dcache_arb_st_req,
                                wmb_dcache_arb_st_req};

//sel signal send back to the source
// &CombBeg; @410
always @( dcache_arb_st_req[5:0])
begin
dcache_arb_st_sel[5:0] = 6'b0;
casez(dcache_arb_st_req[5:0])
  // 7'b01?_????:dcache_arb_st_sel[6]  = 1'b1;
  6'b01_????:dcache_arb_st_sel[5]  = 1'b1;
  6'b00_1???:dcache_arb_st_sel[4]  = 1'b1;
  6'b00_01??:dcache_arb_st_sel[3]  = 1'b1;
  6'b00_001?:dcache_arb_st_sel[2]  = 1'b1;
  6'b00_0001:dcache_arb_st_sel[1]  = 1'b1;
  6'b00_0000:dcache_arb_st_sel[0]  = 1'b1;
  default:dcache_arb_st_sel[5:0] = 6'b0;
endcase
// &CombEnd; @421
end

assign dcache_arb_lfb_st_sel_unmask   = dcache_arb_st_sel[5];
assign dcache_arb_vb_st_sel_unmask    = dcache_arb_st_sel[4];
assign dcache_arb_snq_st_sel_unmask   = dcache_arb_st_sel[3];
assign dcache_arb_icc_st_sel_unmask   = dcache_arb_st_sel[2];
assign dcache_arb_wmb_st_sel_unmask   = dcache_arb_st_sel[1];
assign dcache_arb_ag_st_sel_unmask    = dcache_arb_st_sel[0];

//------------------masked signal---------------------------
//because lfb/vb/snq/icc may request ld and st pipeline once a time,
//to insure that they can get both sel signal simultaneously,
//if they request 2 pipeline and get 1 sel, then it must be clr to 0.
assign dcache_arb_lfb_st_sel  = dcache_arb_lfb_st_sel_unmask
                                    &&  (!lfb_dcache_arb_ld_req
                                        ||  dcache_arb_lfb_ld_sel_unmask)
                                ||  dcache_arb_serial_lfb;
assign dcache_arb_vb_st_sel   = dcache_arb_vb_st_sel_unmask
                                    &&  (!vb_dcache_arb_ld_req
                                        ||  dcache_arb_vb_ld_sel_unmask)
                                ||  dcache_arb_serial_vb;
assign dcache_arb_snq_st_sel  = dcache_arb_snq_st_sel_unmask
                                    &&  (!snq_dcache_arb_ld_req
                                        ||  dcache_arb_snq_ld_sel_unmask)
                                ||  dcache_arb_serial_snq;
assign dcache_arb_wmb_st_sel  = dcache_arb_wmb_st_sel_unmask
                                &&  dcache_arb_wmb_ld_sel_unmask;
assign dcache_arb_icc_st_sel  = dcache_arb_icc_st_sel_unmask
                                &&  dcache_arb_icc_ld_sel_unmask;
// &Force("output", "dcache_arb_ag_st_sel"); @450
assign dcache_arb_ag_st_sel   = dcache_arb_ag_st_sel_unmask;

//----------shorten signal to select signal-----------------
assign dcache_arb_lfb_st_dp_sel  = dcache_arb_lfb_st_sel_unmask  ||  dcache_arb_serial_lfb;
assign dcache_arb_vb_st_dp_sel   = dcache_arb_vb_st_sel_unmask   ||  dcache_arb_serial_vb;
assign dcache_arb_snq_st_dp_sel  = dcache_arb_snq_st_sel_unmask  ||  dcache_arb_serial_snq;
assign dcache_arb_wmb_st_dp_sel  = dcache_arb_wmb_st_sel_unmask;
assign dcache_arb_icc_st_dp_sel  = dcache_arb_icc_st_sel_unmask;
assign dcache_arb_ag_st_dp_sel   = dcache_arb_ag_st_sel_unmask;

assign dcache_arb_st_dp_sel_id[5:0] = {dcache_arb_lfb_st_dp_sel,
                                      dcache_arb_vb_st_dp_sel,
                                      dcache_arb_snq_st_dp_sel,
                                      dcache_arb_wmb_st_dp_sel,
                                      dcache_arb_icc_st_dp_sel,
                                      dcache_arb_ag_st_dp_sel};
//------------------grnt   signal---------------------------
assign dcache_arb_vb_st_grnt  = dcache_arb_vb_st_sel;
assign dcache_arb_snq_st_grnt = dcache_arb_snq_st_sel;
//assign dcache_arb_ag_st_grnt  = dcache_arb_ag_st_sel  &&  ag_dcache_arb_st_req;

//==========================================================
//        Borrow signal for ST part to DC stage
//==========================================================
//if vb request tag/dirty, mmu request tag/dirty, they will borrow st dc/da stage
//---------------------borrow addr--------------------------
// &Force("output","dcache_arb_st_ag_borrow_addr_vld"); @477
assign dcache_arb_st_ag_borrow_addr_vld = dcache_arb_vb_st_sel  &&  vb_dcache_arb_st_borrow_req
                                          ||  dcache_arb_snq_st_sel  &&  snq_dcache_arb_st_borrow_req;
assign dcache_arb_st_ag_addr[`WK_PA_WIDTH-1:0]  = {`WK_PA_WIDTH{dcache_arb_vb_st_sel}}
                                                & vb_dcache_arb_borrow_addr[`WK_PA_WIDTH-1:0]
                                              | {`WK_PA_WIDTH{dcache_arb_snq_st_sel}}
                                                & snq_dcache_arb_borrow_addr[`WK_PA_WIDTH-1:0];
//---------------------borrow signal------------------------
// &Force("output", "dcache_arb_st_dc_borrow_vld"); @485
assign dcache_arb_st_dc_borrow_vld_gate = dcache_arb_st_ag_borrow_addr_vld
                                          || dcache_arb_icc_st_sel  &&  icc_dcache_arb_st_borrow_req;
assign dcache_arb_st_dc_borrow_vld      = dcache_arb_st_ag_borrow_addr_vld
                                          || dcache_arb_icc_st_sel  &&  icc_dcache_arb_st_borrow_req;
assign dcache_arb_st_dc_borrow_snq    = dcache_arb_snq_st_sel  &&  snq_dcache_arb_st_borrow_req;
assign dcache_arb_st_dc_borrow_snq_id[`WK_LS_SNQ_ENTRY-1:0]  = snq_dcache_arb_st_id[`WK_LS_SNQ_ENTRY-1:0];
assign dcache_arb_st_dc_borrow_icc    = dcache_arb_icc_st_sel  &&  icc_dcache_arb_st_borrow_req;
//------------------borrow other signal---------------------
assign dcache_arb_st_dc_dcache_replace  = dcache_arb_vb_st_sel  &&  vb_dcache_arb_dcache_replace;
assign dcache_arb_st_dc_dcache_sw       = ({2{dcache_arb_vb_st_sel}}  &  {1'b0,vb_dcache_arb_set_way_mode})
                                          | ({2{dcache_arb_icc_st_sel}}  &  icc_dcache_arb_way);

//==========================================================
//        Input select for ST part
//==========================================================
//------------------tag   array-----------------------------
//-----------gateclk--------------------
assign lsu_dcache_st_tag_gateclk_en = lfb_dcache_arb_st_tag_gateclk_en
                                      ||  vb_dcache_arb_st_tag_gateclk_en
                                      ||  snq_dcache_arb_st_tag_gateclk_en
                                      ||  icc_dcache_arb_st_tag_gateclk_en
                                      ||  wmb_dcache_arb_ld_tag_gateclk_en
                                      ||  ag_dcache_arb_st_tag_gateclk_en;

//-----------interface------------------
assign dcache_arb_st_tag_req  = dcache_arb_lfb_st_sel  &&  lfb_dcache_arb_st_tag_req
                                ||  dcache_arb_vb_st_sel  &&  vb_dcache_arb_st_tag_req
                                ||  dcache_arb_snq_st_sel &&  snq_dcache_arb_st_tag_req
                                ||  dcache_arb_icc_st_sel &&  icc_dcache_arb_st_tag_req
                                ||  dcache_arb_wmb_st_sel  &&  wmb_dcache_arb_st_icc_req
                                ||  dcache_arb_ag_st_sel  &&  ag_dcache_arb_st_tag_req;

assign lsu_dcache_st_tag_sel_b  = !dcache_arb_st_tag_req;

// &CombBeg; @536
always @( lfb_dcache_arb_st_tag_idx
       or dcache_arb_st_dp_sel_id[5:0]
       or wmb_dcache_arb_ld_tag_idx
       or icc_dcache_arb_st_tag_idx
       or vb_dcache_arb_st_tag_idx
       or ag_dcache_arb_st_tag_idx
       or snq_dcache_arb_st_tag_idx)
begin
case(dcache_arb_st_dp_sel_id[5:0])
  6'b10_0000:lsu_dcache_st_tag_idx  = lfb_dcache_arb_st_tag_idx;
  6'b01_0000:lsu_dcache_st_tag_idx  =  vb_dcache_arb_st_tag_idx;
  6'b00_1000:lsu_dcache_st_tag_idx  = snq_dcache_arb_st_tag_idx;
  6'b00_0100:lsu_dcache_st_tag_idx  = wmb_dcache_arb_ld_tag_idx;
  6'b00_0010:lsu_dcache_st_tag_idx  = icc_dcache_arb_st_tag_idx;
  6'b00_0001:lsu_dcache_st_tag_idx  =  ag_dcache_arb_st_tag_idx;
  default:   lsu_dcache_st_tag_idx  = {`WK_LS_DCACHE_LDTAG_IDX_MSB+1{1'bx}};
endcase
// &CombEnd; @548
end

//only lfb can write tag array
// &Force("output","lsu_dcache_st_tag_din"); @557
//when inv line,should set all tag to 0 for ecc check
assign lsu_dcache_st_tag_din = {`WK_LS_DCACHE_TAG_NOECC_WIDTH{dcache_arb_lfb_st_dp_sel}} & lfb_dcache_arb_st_tag_din;
assign lsu_dcache_st_tag_gwen      = dcache_arb_lfb_st_sel 
                                     || dcache_arb_wmb_st_sel && wmb_dcache_arb_st_icc_req
                                     || dcache_arb_snq_ld_sel //added by xj@2025.02.19
                                     || dcache_arb_vb_st_sel && vb_dcache_arb_st_dirty_gwen
                                     || dcache_arb_icc_st_sel && icc_dcache_arb_st_dirty_gwen;
assign lsu_dcache_st_tag_wen  =   {`WK_LS_DCACHE_WAYS_NUM{dcache_arb_lfb_st_dp_sel}} & lfb_dcache_arb_st_tag_wen
                                | {`WK_LS_DCACHE_WAYS_NUM{dcache_arb_wmb_st_dp_sel}} & wmb_dcache_arb_ld_tag_wen
                                | {`WK_LS_DCACHE_WAYS_NUM{dcache_arb_snq_ld_sel}}    & snq_dcache_arb_ld_tag_wen //added by xj@2025.02.19
                                | {`WK_LS_DCACHE_WAYS_NUM{dcache_arb_vb_st_dp_sel}}  &  vb_dcache_arb_ld_tag_wen
                                | {`WK_LS_DCACHE_WAYS_NUM{dcache_arb_icc_st_dp_sel}} & {`WK_LS_DCACHE_WAYS_NUM{1'b1}};

assign lsu_dcache_st_tag_gwen_b   = !lsu_dcache_st_tag_gwen;

assign lsu_dcache_st_tag_wen_b = ~lsu_dcache_st_tag_wen;

//------------------dirty array-----------------------------
//-----------gateclk--------------------
assign lsu_dcache_st_dirty_gateclk_en = lfb_dcache_arb_st_dirty_gateclk_en
                                        ||  vb_dcache_arb_st_dirty_gateclk_en
                                        ||  snq_dcache_arb_st_dirty_gateclk_en
                                        ||  wmb_dcache_arb_st_dirty_gateclk_en
                                        ||  icc_dcache_arb_st_dirty_gateclk_en
                                        ||  ag_dcache_arb_st_dirty_gateclk_en;

//-----------interface------------------
assign dcache_arb_st_dirty_req  = dcache_arb_lfb_st_sel  &&  lfb_dcache_arb_st_dirty_req
                                  ||  dcache_arb_vb_st_sel  &&  vb_dcache_arb_st_dirty_req
                                  ||  dcache_arb_snq_st_sel &&  snq_dcache_arb_st_dirty_req
                                  ||  dcache_arb_wmb_st_sel &&  wmb_dcache_arb_st_dirty_req
                                  ||  dcache_arb_icc_st_sel &&  icc_dcache_arb_st_dirty_req
                                  ||  dcache_arb_ag_st_sel  &&  ag_dcache_arb_st_dirty_req;

assign lsu_dcache_st_dirty_sel_b  = !dcache_arb_st_dirty_req;

// &CombBeg; @598
always @(  ag_dcache_arb_st_dirty_idx
       or wmb_dcache_arb_st_dirty_idx
       or icc_dcache_arb_st_dirty_idx
       or dcache_arb_st_dp_sel_id[5:0]
       or lfb_dcache_arb_st_dirty_idx
       or snq_dcache_arb_st_dirty_idx
       or  vb_dcache_arb_st_dirty_idx)
begin
case(dcache_arb_st_dp_sel_id[5:0])
  6'b10_0000:lsu_dcache_st_dirty_idx  = lfb_dcache_arb_st_dirty_idx;
  6'b01_0000:lsu_dcache_st_dirty_idx  =  vb_dcache_arb_st_dirty_idx;
  6'b00_1000:lsu_dcache_st_dirty_idx  = snq_dcache_arb_st_dirty_idx;
  6'b00_0100:lsu_dcache_st_dirty_idx  = wmb_dcache_arb_st_dirty_idx;
  6'b00_0010:lsu_dcache_st_dirty_idx  = icc_dcache_arb_st_dirty_idx;
  6'b00_0001:lsu_dcache_st_dirty_idx  =  ag_dcache_arb_st_dirty_idx;
  default:   lsu_dcache_st_dirty_idx  = {`WK_LS_DCACHE_META_IDX_MSB+1{1'bx}};
endcase
// &CombEnd; @608
end

assign lsu_dcache_st_dirty_din = {`WK_LS_DCACHE_META_WIDTH{dcache_arb_lfb_st_dp_sel}}  & lfb_dcache_arb_st_dirty_din
                               | {`WK_LS_DCACHE_META_WIDTH{dcache_arb_vb_st_dp_sel}}   &  vb_dcache_arb_st_dirty_din
                               | {`WK_LS_DCACHE_META_WIDTH{dcache_arb_snq_st_dp_sel}}  & snq_dcache_arb_st_dirty_din
                               | {`WK_LS_DCACHE_META_WIDTH{dcache_arb_wmb_st_dp_sel}}  & wmb_dcache_arb_st_dirty_din
                               | {`WK_LS_DCACHE_META_WIDTH{dcache_arb_icc_st_dp_sel}}  & icc_dcache_arb_st_dirty_din;

assign lsu_dcache_st_dirty_gwen     = dcache_arb_lfb_st_dp_sel
                                      ||  dcache_arb_vb_st_dp_sel    &&  vb_dcache_arb_st_dirty_gwen
                                      ||  dcache_arb_snq_st_dp_sel   &&  snq_dcache_arb_st_dirty_gwen
                                      ||  dcache_arb_wmb_st_dp_sel
                                      ||  dcache_arb_icc_st_dp_sel   &&  icc_dcache_arb_st_dirty_gwen;
assign lsu_dcache_st_dirty_gwen_b   = !lsu_dcache_st_dirty_gwen;

assign lsu_dcache_st_dirty_wen = {`WK_LS_DCACHE_META_NOECC_WIDTH{dcache_arb_lfb_st_dp_sel}} & lfb_dcache_arb_st_dirty_wen
                               | {`WK_LS_DCACHE_META_NOECC_WIDTH{dcache_arb_vb_st_dp_sel}}  &  vb_dcache_arb_st_dirty_wen
                               | {`WK_LS_DCACHE_META_NOECC_WIDTH{dcache_arb_snq_st_dp_sel}} & snq_dcache_arb_st_dirty_wen
                               | {`WK_LS_DCACHE_META_NOECC_WIDTH{dcache_arb_wmb_st_dp_sel}} & wmb_dcache_arb_st_dirty_wen
                               | {`WK_LS_DCACHE_META_NOECC_WIDTH{dcache_arb_icc_st_dp_sel}} & icc_dcache_arb_st_dirty_wen;

`ifdef WK_DCACHE_2WAY                               
assign lsu_dcache_st_dirty_wen_b = ~{lsu_dcache_st_dirty_wen[8],{7{lsu_dcache_st_dirty_wen[6]}},
                                     lsu_dcache_st_dirty_wen[7:4],{7{lsu_dcache_st_dirty_wen[2]}},
                                     lsu_dcache_st_dirty_wen[3:0]};
`endif       

`ifdef WK_DCACHE_4WAY                               
assign lsu_dcache_st_dirty_wen_b = ~{{`WK_LS_DCACHE_SINGLE_META_WIDTH-4{lsu_dcache_st_dirty_wen[14]}}, lsu_dcache_st_dirty_wen[15:12],
                                     {`WK_LS_DCACHE_SINGLE_META_WIDTH-4{lsu_dcache_st_dirty_wen[10]}}, lsu_dcache_st_dirty_wen[11:8],
                                     {`WK_LS_DCACHE_SINGLE_META_WIDTH-4{lsu_dcache_st_dirty_wen[6]}}, lsu_dcache_st_dirty_wen[7:4],
                                     {`WK_LS_DCACHE_SINGLE_META_WIDTH-4{lsu_dcache_st_dirty_wen[2]}}, lsu_dcache_st_dirty_wen[3:0]};
`endif                                     
//==========================================================
//        Dcache write port information
//==========================================================
assign dcache_dirty_gwen        = dcache_arb_lfb_st_sel
                                      &&  lfb_dcache_arb_st_dirty_req
                                  ||  dcache_arb_vb_st_sel
                                      &&  vb_dcache_arb_st_dirty_req
                                      &&  vb_dcache_arb_st_dirty_gwen
                                  ||  dcache_arb_snq_st_sel
                                      &&  snq_dcache_arb_st_dirty_req
                                      &&  snq_dcache_arb_st_dirty_gwen
                                  ||  dcache_arb_wmb_st_sel
                                      &&  wmb_dcache_arb_st_dirty_req;

assign dcache_snq_st_sel        = dcache_arb_snq_st_sel;

assign dcache_vb_snq_gwen       = dcache_arb_vb_st_sel
                                      &&  vb_dcache_arb_st_dirty_req
                                      &&  vb_dcache_arb_st_dirty_gwen
                                  ||  dcache_arb_snq_st_sel
                                      &&  snq_dcache_arb_st_dirty_req
                                      &&  snq_dcache_arb_st_dirty_gwen;

assign dcache_tag_gwen          = dcache_arb_lfb_st_sel
                                  &&  lfb_dcache_arb_st_tag_req;

//ATTENTION:there are 9 bits idx in dcache 32K, for dcwp(dcache write port) hit, it must compare
//only 8 bits in 32K and 9 bits in 64K
// outputs for dcache_info_update
always @( dcache_arb_lfb_st_dp_sel
       or dcache_arb_snq_st_dp_sel
       or  dcache_arb_vb_st_dp_sel
    `ifdef WK_DCACHE_4WAY
       or lfb_dcache_arb_st_dirty_din[`WK_LS_DCACHE_TRIPLE_META_WIDTH+3:`WK_LS_DCACHE_TRIPLE_META_WIDTH]
       or  vb_dcache_arb_st_dirty_din[`WK_LS_DCACHE_TRIPLE_META_WIDTH+3:`WK_LS_DCACHE_TRIPLE_META_WIDTH]
       or snq_dcache_arb_st_dirty_din[`WK_LS_DCACHE_TRIPLE_META_WIDTH+3:`WK_LS_DCACHE_TRIPLE_META_WIDTH]
       or wmb_dcache_arb_st_dirty_din[`WK_LS_DCACHE_TRIPLE_META_WIDTH+3:`WK_LS_DCACHE_TRIPLE_META_WIDTH]
       or lfb_dcache_arb_st_dirty_din[`WK_LS_DCACHE_DOUBLE_META_WIDTH+3:`WK_LS_DCACHE_DOUBLE_META_WIDTH]
       or  vb_dcache_arb_st_dirty_din[`WK_LS_DCACHE_DOUBLE_META_WIDTH+3:`WK_LS_DCACHE_DOUBLE_META_WIDTH]
       or snq_dcache_arb_st_dirty_din[`WK_LS_DCACHE_DOUBLE_META_WIDTH+3:`WK_LS_DCACHE_DOUBLE_META_WIDTH]
       or wmb_dcache_arb_st_dirty_din[`WK_LS_DCACHE_DOUBLE_META_WIDTH+3:`WK_LS_DCACHE_DOUBLE_META_WIDTH]
    `endif
    `ifdef WK_DCACHE_2WAY
       or lfb_dcache_arb_st_dirty_din[`WK_LS_DCACHE_META_WIDTH-1]
       or  vb_dcache_arb_st_dirty_din[`WK_LS_DCACHE_META_WIDTH-1]
       or snq_dcache_arb_st_dirty_din[`WK_LS_DCACHE_META_WIDTH-1]
       or wmb_dcache_arb_st_dirty_din[`WK_LS_DCACHE_META_WIDTH-1]
    `endif
       or lfb_dcache_arb_st_dirty_din[`WK_LS_DCACHE_SINGLE_META_WIDTH+3:`WK_LS_DCACHE_SINGLE_META_WIDTH]
       or  vb_dcache_arb_st_dirty_din[`WK_LS_DCACHE_SINGLE_META_WIDTH+3:`WK_LS_DCACHE_SINGLE_META_WIDTH]
       or snq_dcache_arb_st_dirty_din[`WK_LS_DCACHE_SINGLE_META_WIDTH+3:`WK_LS_DCACHE_SINGLE_META_WIDTH]
       or wmb_dcache_arb_st_dirty_din[`WK_LS_DCACHE_SINGLE_META_WIDTH+3:`WK_LS_DCACHE_SINGLE_META_WIDTH]
       or lfb_dcache_arb_st_dirty_din[3:0]
       or  vb_dcache_arb_st_dirty_din[3:0]
       or snq_dcache_arb_st_dirty_din[3:0]
       or wmb_dcache_arb_st_dirty_din[3:0]
       or lfb_dcache_arb_st_dirty_wen
       or  vb_dcache_arb_st_dirty_wen
       or snq_dcache_arb_st_dirty_wen
       or wmb_dcache_arb_st_dirty_wen
       or lfb_dcache_arb_st_dirty_idx
       or snq_dcache_arb_st_dirty_idx
       or wmb_dcache_arb_st_dirty_idx
       or  vb_dcache_arb_st_dirty_idx)
begin
casez({dcache_arb_lfb_st_dp_sel,dcache_arb_vb_st_dp_sel,dcache_arb_snq_st_dp_sel})
  3'b1??:
  begin
    dcache_idx       = lfb_dcache_arb_st_dirty_idx;
    `ifdef WK_DCACHE_2WAY
      dcache_dirty_din = {lfb_dcache_arb_st_dirty_din[`WK_LS_DCACHE_META_WIDTH-1],lfb_dcache_arb_st_dirty_din[`WK_LS_DCACHE_SINGLE_META_WIDTH+3:`WK_LS_DCACHE_SINGLE_META_WIDTH],lfb_dcache_arb_st_dirty_din[3:0]};
    `endif
    `ifdef WK_DCACHE_4WAY
      dcache_dirty_din = {lfb_dcache_arb_st_dirty_din[`WK_LS_DCACHE_TRIPLE_META_WIDTH+3:`WK_LS_DCACHE_TRIPLE_META_WIDTH], lfb_dcache_arb_st_dirty_din[`WK_LS_DCACHE_DOUBLE_META_WIDTH+3:`WK_LS_DCACHE_DOUBLE_META_WIDTH],lfb_dcache_arb_st_dirty_din[`WK_LS_DCACHE_SINGLE_META_WIDTH+3:`WK_LS_DCACHE_SINGLE_META_WIDTH],lfb_dcache_arb_st_dirty_din[3:0]};
    `endif
    dcache_dirty_wen = lfb_dcache_arb_st_dirty_wen;
  end
  3'b01?:
  begin
    dcache_idx       = vb_dcache_arb_st_dirty_idx;
    `ifdef WK_DCACHE_2WAY
      dcache_dirty_din = {vb_dcache_arb_st_dirty_din[`WK_LS_DCACHE_META_WIDTH-1],vb_dcache_arb_st_dirty_din[`WK_LS_DCACHE_SINGLE_META_WIDTH+3:`WK_LS_DCACHE_SINGLE_META_WIDTH],vb_dcache_arb_st_dirty_din[3:0]};
    `endif
    `ifdef WK_DCACHE_4WAY
      dcache_dirty_din = {vb_dcache_arb_st_dirty_din[`WK_LS_DCACHE_TRIPLE_META_WIDTH+3:`WK_LS_DCACHE_TRIPLE_META_WIDTH], vb_dcache_arb_st_dirty_din[`WK_LS_DCACHE_DOUBLE_META_WIDTH+3:`WK_LS_DCACHE_DOUBLE_META_WIDTH],vb_dcache_arb_st_dirty_din[`WK_LS_DCACHE_SINGLE_META_WIDTH+3:`WK_LS_DCACHE_SINGLE_META_WIDTH],vb_dcache_arb_st_dirty_din[3:0]};
    `endif
    dcache_dirty_wen = vb_dcache_arb_st_dirty_wen;
  end
  3'b001:
  begin
    dcache_idx       = snq_dcache_arb_st_dirty_idx;
    `ifdef WK_DCACHE_2WAY
      dcache_dirty_din = {snq_dcache_arb_st_dirty_din[`WK_LS_DCACHE_META_WIDTH-1],snq_dcache_arb_st_dirty_din[`WK_LS_DCACHE_SINGLE_META_WIDTH+3:`WK_LS_DCACHE_SINGLE_META_WIDTH],snq_dcache_arb_st_dirty_din[3:0]};
    `endif
    `ifdef WK_DCACHE_4WAY
      dcache_dirty_din = {snq_dcache_arb_st_dirty_din[`WK_LS_DCACHE_TRIPLE_META_WIDTH+3:`WK_LS_DCACHE_TRIPLE_META_WIDTH], snq_dcache_arb_st_dirty_din[`WK_LS_DCACHE_DOUBLE_META_WIDTH+3:`WK_LS_DCACHE_DOUBLE_META_WIDTH],snq_dcache_arb_st_dirty_din[`WK_LS_DCACHE_SINGLE_META_WIDTH+3:`WK_LS_DCACHE_SINGLE_META_WIDTH],snq_dcache_arb_st_dirty_din[3:0]};
    `endif
    dcache_dirty_wen = snq_dcache_arb_st_dirty_wen;
  end
  default:
  begin
    dcache_idx       = wmb_dcache_arb_st_dirty_idx;
    `ifdef WK_DCACHE_2WAY
      dcache_dirty_din = {wmb_dcache_arb_st_dirty_din[`WK_LS_DCACHE_META_WIDTH-1],wmb_dcache_arb_st_dirty_din[`WK_LS_DCACHE_SINGLE_META_WIDTH+3:`WK_LS_DCACHE_SINGLE_META_WIDTH],wmb_dcache_arb_st_dirty_din[3:0]};
    `endif
    `ifdef WK_DCACHE_4WAY
      dcache_dirty_din = {wmb_dcache_arb_st_dirty_din[`WK_LS_DCACHE_TRIPLE_META_WIDTH+3:`WK_LS_DCACHE_TRIPLE_META_WIDTH], wmb_dcache_arb_st_dirty_din[`WK_LS_DCACHE_DOUBLE_META_WIDTH+3:`WK_LS_DCACHE_DOUBLE_META_WIDTH],wmb_dcache_arb_st_dirty_din[`WK_LS_DCACHE_SINGLE_META_WIDTH+3:`WK_LS_DCACHE_SINGLE_META_WIDTH],wmb_dcache_arb_st_dirty_din[3:0]};
    `endif
    dcache_dirty_wen = wmb_dcache_arb_st_dirty_wen;
  end
endcase
// &CombEnd; @720
end
assign dcache_tag_din    = lsu_dcache_st_tag_din;
assign dcache_tag_wen    = lsu_dcache_st_tag_wen;

// &ModuleEnd; @724
endmodule