//-----------------------------------------------------------------------------
// File          : xx_lsu_lfb_addr_entry.sv
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

// &ModuleBeg; @26
module xx_lsu_lfb_addr_entry #(
)
(
  input  wire                                       cp0_lsu_icg_en,                         
  input  wire                                       cpurst_b,                               
  input  wire [`WK_PA_WIDTH-7: 0]                   ld_da_addr_tto6[0: `NUM_LD + `NUM_LS-1],                              
  input  wire                                       lda0_lfb_ex3_ldamo,  // wjh@amo lfb snq deadlock
  input  wire                                       lsda0_lfb_ex3_ldamo, // wjh@amo lfb snq deadlock
  input  wire                                       lsda1_lfb_ex3_ldamo, // wjh@amo lfb snq deadlock
  input  wire                                       ld_da_lfb_discard_grnt[0: `NUM_LD + `NUM_LS-1],                 
  input  wire                                       lfb_addr_entry_create_gateclk_en_x,     
  input  wire                                       lfb_addr_entry_pfu_create_dp_vld_x,     
  input  wire                                       lfb_addr_entry_pfu_create_vld_x,        
  input  wire                                       lfb_addr_entry_rb_create_dp_vld_x,      
  input  wire                                       lfb_addr_entry_rb_create_vld_x,         
  input  wire                                       lfb_addr_entry_resp_set_x,              
  input  wire                                       lfb_addr_entry_vb_pe_req_grnt_x,        
  input  wire                                       lfb_create_linefill_dp,                 
  input  wire                                       lfb_data_addr_pop_req_x,                
  input  wire                                       lfb_lf_sm_addr_pop_req_x,               
  input  wire                                       lfb_vb_pe_req,                          
  input  wire                                       lfb_vb_pe_req_permit,                   
  input  wire                                       lm_already_snoop,                       
  input  wire                                       lsu_special_clk,                        
  input  wire                                       pad_yy_icg_scan_en,                     
  input  wire [`WK_PA_WIDTH-1: 0]                   pfu_biu_req_addr,                       
  input  wire [`WK_VA_WIDTH-1: 12]                  pfu_lfb_full_va,                       
  input  wire [3 :0]                                pfu_lfb_id,                             
  input  wire                                       pfu_lfb_page_share,                     
  input  wire [1 :0]                                pfu_lfb_pf_type,                     
  input  wire [`WK_PA_WIDTH-1: 0]                   rb_biu_req_addr,                        
  input  wire [`WK_PA_WIDTH-5: 0]                   rb_lfb_addr_tto4,                       
  input  wire [`WK_VA_WIDTH-1: 12]                  rb_lfb_full_va,                       
  input  wire                                       rb_lfb_atomic,                          
  input  wire                                       rb_lfb_depd,                            
  input  wire                                       rb_lfb_ldamo,                           
  input  wire                                       rb_lfb_page_ca,                         
  input  wire                                       rb_lfb_page_share,                      
  input  wire [`WK_PA_WIDTH-7: 0]                   snq_bypass_addr_tto6,                   
  input  wire [`WK_PA_WIDTH-1: 0]                   st_da_addr[0 :`NUM_LS-1],
  input  wire                                       st_da_cache_miss[0 :`NUM_LS-1],                             
  input  wire                                       vb_lfb_addr_entry_rcl_done_x,           
  input  wire                                       vb_lfb_dcache_dirty,                    
  input  wire                                       vb_lfb_dcache_hit,                      
  input  wire [`WK_LS_DCACHE_WAYIDX_WIDTH-1: 0]     vb_lfb_dcache_way,                      
  input  wire [`WK_PA_WIDTH-1: 0]                   wmb_read_req_addr,                      
  input  wire [`WK_PA_WIDTH-1: 0]                   wmb_write_req_addr,                     
  output wire                                       lfb_addr_entry_pfu_create_x,
  output wire [3: 0]                                lfb_addr_entry_pfu_id_x,
  output wire                                       lfb_addr_entry_pfu_id_vld_x,
  output wire [1: 0]                                lfb_addr_entry_pf_type_x,
  output wire [`WK_VA_WIDTH-1: 12]                  lfb_addr_entry_full_va_x,
  output wire                                       lfb_addr_entry_pf_late_ld_x,
  output wire                                       lfb_addr_entry_pf_late_st_x,  
  output wire                                       ld_hit_prefetch_first_x,                
  output wire [`WK_PA_WIDTH-5: 0]                   lfb_addr_entry_addr_tto4_v,             
  output wire                                       lfb_addr_entry_dcache_hit_x,            
  output wire [`NUM_LD + `NUM_LS-1 :0]              lfb_addr_entry_depd_x,                  
  output wire [`NUM_LD + `NUM_LS-1 :0]              lfb_addr_entry_discard_vld_x,           
  output wire [`NUM_LD + `NUM_LS-1 :0]              lfb_addr_entry_ld_da_hit_idx_x,         
  output wire                                       lfb_addr_entry_ldamo_x,                 
  output wire                                       lfb_addr_entry_linefill_abort_x,        
  output wire                                       lfb_addr_entry_linefill_permit_x,       
  output wire                                       lfb_addr_entry_not_resp_x,              
  output wire                                       lfb_addr_entry_page_nc_x,               
  output wire                                       lfb_addr_entry_page_share_x,            
  output wire                                       lfb_addr_entry_pfu_biu_req_hit_idx_x,   
  output wire [8 :0]                                lfb_addr_entry_pfu_dcache_hit_v,        
  output wire [8 :0]                                lfb_addr_entry_pfu_dcache_miss_v,       
  output wire                                       lfb_addr_entry_pop_vld_x,               
  output wire                                       lfb_addr_entry_rb_biu_req_hit_idx_x,    
  output wire                                       lfb_addr_entry_rcl_done_x,              
  output wire  [`WK_LS_DCACHE_WAYIDX_WIDTH-1 :0]    lfb_addr_entry_refill_way_x,            
  output wire                                       lfb_addr_entry_snq_bypass_hit_x,        
  output wire  [`NUM_LS-1 :0]                       lfb_addr_entry_st_da_hit_idx_x,         
  output wire                                       lfb_addr_entry_vb_pe_req_x,             
  output wire                                       lfb_addr_entry_vld_x,                   
  output wire                                       lfb_addr_entry_wmb_read_req_hit_idx_x,  
  output wire                                       lfb_addr_entry_wmb_write_req_hit_idx_x
);

// &Regs; @28
reg     [`WK_PA_WIDTH-5: 0]                         lfb_addr_entry_addr_tto4;               
reg     [`WK_VA_WIDTH-1: 12]                        lfb_addr_entry_full_va;
reg                                                 lfb_addr_entry_already_reply;           
reg                                                 lfb_addr_entry_atomic;                  
reg                                                 lfb_addr_entry_dcache_dirty;            
reg                                                 lfb_addr_entry_dcache_hit;              
reg                                                 lfb_addr_entry_depd[0: `NUM_LD + `NUM_LS-1];                    
reg                                                 lfb_addr_entry_ldamo;                   
reg                                                 lfb_addr_entry_page_ca;                 
reg                                                 lfb_addr_entry_page_share;              
reg                                                 lfb_addr_entry_pfu_create;              
reg     [3: 0]                                      lfb_addr_entry_pfu_id;                  
reg                                                 lfb_addr_entry_pfu_id_vld;                  
reg                                                 lfb_addr_entry_rcl_done;                
reg     [`WK_LS_DCACHE_WAYIDX_WIDTH-1: 0]           lfb_addr_entry_refill_way;              
reg                                                 lfb_addr_entry_resp;                    
reg                                                 lfb_addr_entry_vb_pe_req_success;       
reg                                                 lfb_addr_entry_vld;                     
reg     [1 :0]                                      lfb_addr_entry_pf_type;
reg                                                 lfb_addr_entry_pf_late_ld;
reg                                                 lfb_addr_entry_pf_late_st;                     

// &Wires; @29
wire                                                ld_hit_prefetch_first;                  
wire                                                lfb_addr_entry_atomic_abort;            
wire                                                lfb_addr_entry_clk;                     
wire                                                lfb_addr_entry_clk_en;                  
wire    [`WK_PA_WIDTH-1: 0]                         lfb_addr_entry_cmp_pfu_biu_req_addr;    
wire    [`WK_PA_WIDTH-1: 0]                         lfb_addr_entry_cmp_rb_biu_req_addr;     
wire    [`WK_PA_WIDTH-7: 0]                         lfb_addr_entry_cmp_snq_bypass_addr_tto6; 
wire    [`WK_PA_WIDTH-1: 0]                         lfb_addr_entry_cmp_st_da_addr[0 :`NUM_LS-1];          
wire    [`WK_PA_WIDTH-1: 0]                         lfb_addr_entry_cmp_wmb_read_req_addr;   
wire    [`WK_PA_WIDTH-1: 0]                         lfb_addr_entry_cmp_wmb_write_req_addr;  
wire                                                lfb_addr_entry_create_clk;              
wire                                                lfb_addr_entry_create_clk_en;           
wire                                                lfb_addr_entry_create_dp_vld;           
wire                                                lfb_addr_entry_create_gateclk_en;       
wire                                                lfb_addr_entry_discard_vld[0: `NUM_LD + `NUM_LS-1];             
wire                                                lfb_addr_entry_ld_da_hit_idx[0: `NUM_LD + `NUM_LS-1];           
wire                                                lfb_addr_entry_st_da_hit_idx[0 :`NUM_LS-1];         
wire                                                lfb_addr_entry_ld_da_hit_cacheline[0: `NUM_LD + `NUM_LS-1];           
wire                                                lfb_addr_entry_st_da_hit_cacheline[0 :`NUM_LS-1];         
wire                                                lfb_addr_entry_pf_late_ld_vld[0: `NUM_LD + `NUM_LS-1];           
wire                                                lfb_addr_entry_pf_late_st_vld[0 :`NUM_LS-1];         
wire                                                lfb_addr_entry_linefill_abort;          
wire                                                lfb_addr_entry_linefill_permit;         
wire                                                lfb_addr_entry_not_resp;                
wire                                                lfb_addr_entry_pfu_biu_req_hit_idx;     
wire                                                lfb_addr_entry_pfu_create_dp_vld;       
wire                                                lfb_addr_entry_pfu_create_vld;          
wire    [8 :0]                                      lfb_addr_entry_pfu_dcache_hit;          
wire                                                lfb_addr_entry_pfu_dcache_hit_vld;      
wire    [8 :0]                                      lfb_addr_entry_pfu_dcache_miss;         
wire                                                lfb_addr_entry_pfu_dcache_miss_vld;     
wire    [8 :0]                                      lfb_addr_entry_pfu_id_oh;               
wire                                                lfb_addr_entry_pfu_reply_vld;           
wire                                                lfb_addr_entry_pop_vld;                 
wire                                                lfb_addr_entry_rb_biu_req_hit_idx;      
wire                                                lfb_addr_entry_rb_create_dp_vld;        
wire                                                lfb_addr_entry_rb_create_vld;           
wire                                                lfb_addr_entry_resp_set;                
wire                                                lfb_addr_entry_snq_bypass_hit;          
wire                                                lfb_addr_entry_vb_pe_req;               
wire                                                lfb_addr_entry_vb_pe_req_grnt;          
wire                                                lfb_addr_entry_vb_pe_req_success_set;   
wire                                                lfb_addr_entry_wmb_read_req_hit_idx;    
wire                                                lfb_addr_entry_wmb_write_req_hit_idx;   
wire                                                lfb_data_addr_pop_req;                  
wire                                                lfb_lf_sm_addr_pop_req;                 
wire                                                vb_lfb_addr_entry_rcl_done;             


//==========================================================
//                 Instance of Gated Cell  
//==========================================================
//-----------entry gateclk--------------
//normal gateclk ,open when create || entry_vld
assign lfb_addr_entry_clk_en  = lfb_addr_entry_vld
                                ||  lfb_addr_entry_create_clk_en;
// &Instance("gated_clk_cell", "x_lsu_lfb_addr_entry_gated_clk"); @39
gated_clk_cell  x_lsu_lfb_addr_entry_gated_clk (
  .clk_in                (lsu_special_clk      ),
  .clk_out               (lfb_addr_entry_clk   ),
  .external_en           (1'b0                 ),
  .local_en              (lfb_addr_entry_clk_en),
  .module_en             (cp0_lsu_icg_en       ),
  .pad_yy_icg_scan_en    (pad_yy_icg_scan_en   )
);

// &Connect(.clk_in        (lsu_special_clk     ), @40
//          .external_en   (1'b0               ), @41
//          .module_en     (cp0_lsu_icg_en     ), @42
//          .local_en      (lfb_addr_entry_clk_en), @43
//          .clk_out       (lfb_addr_entry_clk )); @44

//-----------create gateclk-------------
assign lfb_addr_entry_create_clk_en = lfb_addr_entry_create_gateclk_en;
// &Instance("gated_clk_cell", "x_lsu_lfb_addr_entry_create_gated_clk"); @48
gated_clk_cell  x_lsu_lfb_addr_entry_create_gated_clk (
  .clk_in                       (lsu_special_clk             ),
  .clk_out                      (lfb_addr_entry_create_clk   ),
  .external_en                  (1'b0                        ),
  .local_en                     (lfb_addr_entry_create_clk_en),
  .module_en                    (cp0_lsu_icg_en              ),
  .pad_yy_icg_scan_en           (pad_yy_icg_scan_en          )
);

// &Connect(.clk_in        (lsu_special_clk     ), @49
//          .external_en   (1'b0               ), @50
//          .module_en     (cp0_lsu_icg_en     ), @51
//          .local_en      (lfb_addr_entry_create_clk_en), @52
//          .clk_out       (lfb_addr_entry_create_clk)); @53

//==========================================================
//                 Register
//==========================================================
//+-----------+
//| entry_vld |
//+-----------+
always @(posedge lfb_addr_entry_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    lfb_addr_entry_vld              <=  1'b0;
  else if(lfb_addr_entry_pop_vld)
    lfb_addr_entry_vld              <=  1'b0;
  else if(lfb_addr_entry_rb_create_vld  ||  lfb_addr_entry_pfu_create_vld)
    lfb_addr_entry_vld              <=  1'b1;
end

//+------+--------+
//| addr | pfu_id |
//+------+--------+
always @(posedge lfb_addr_entry_create_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    lfb_addr_entry_pfu_create       <=  1'b0;
    lfb_addr_entry_pf_type          <=  2'b0;
    lfb_addr_entry_atomic           <=  1'b0;
    lfb_addr_entry_ldamo            <=  1'b0;
    lfb_addr_entry_page_ca          <=  1'b0;
    lfb_addr_entry_page_share       <=  1'b0;
    lfb_addr_entry_pfu_id[3:0]      <=  4'b0;
    lfb_addr_entry_pfu_id_vld       <=  1'b0;
    lfb_addr_entry_addr_tto4[`WK_PA_WIDTH-5:0]  <=  {`WK_PA_WIDTH-4{1'b0}};
    lfb_addr_entry_full_va          <= {(`WK_VA_WIDTH-12){1'b0}};
  end
  else if(lfb_addr_entry_rb_create_dp_vld)
  begin
    lfb_addr_entry_pfu_create       <=  1'b0;
    lfb_addr_entry_pf_type          <=  2'b0;
    lfb_addr_entry_atomic           <=  rb_lfb_atomic;
    lfb_addr_entry_ldamo            <=  rb_lfb_ldamo;
    lfb_addr_entry_page_ca          <=  rb_lfb_page_ca;
    lfb_addr_entry_page_share       <=  rb_lfb_page_share;
    lfb_addr_entry_pfu_id[3:0]      <=  4'b0;
    lfb_addr_entry_pfu_id_vld       <=  1'b0;
    lfb_addr_entry_addr_tto4[`WK_PA_WIDTH-5:0]  <=  rb_lfb_addr_tto4[`WK_PA_WIDTH-5:0];
    lfb_addr_entry_full_va          <= rb_lfb_full_va;
  end
  else if(lfb_addr_entry_pfu_create_dp_vld)
  begin
    lfb_addr_entry_pfu_create       <=  1'b1;
    lfb_addr_entry_pf_type          <=  pfu_lfb_pf_type;
    lfb_addr_entry_atomic           <=  1'b0;
    lfb_addr_entry_ldamo            <=  1'b0;
    lfb_addr_entry_page_ca          <=  1'b1;
    lfb_addr_entry_page_share       <=  pfu_lfb_page_share;
    lfb_addr_entry_pfu_id[3:0]      <=  pfu_lfb_id[3:0];
    lfb_addr_entry_pfu_id_vld       <=  1'b1;
    lfb_addr_entry_addr_tto4[`WK_PA_WIDTH-5:0]  <=  pfu_biu_req_addr[`WK_PA_WIDTH-1:4];
    lfb_addr_entry_full_va          <= pfu_lfb_full_va;
  end
end

//+--------------------+
//| vb_pe_req_success |
//+--------------------+
always @(posedge lfb_addr_entry_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    lfb_addr_entry_vb_pe_req_success    <=  1'b0;
  else if(lfb_addr_entry_vb_pe_req_success_set)
    lfb_addr_entry_vb_pe_req_success    <=  1'b1;
  else if(lfb_addr_entry_create_dp_vld)
    lfb_addr_entry_vb_pe_req_success    <=  !lfb_create_linefill_dp;
end

//+-----------------+
//| cache line info |
//+-----------------+
always @(posedge lfb_addr_entry_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
  begin
    lfb_addr_entry_rcl_done     <=  1'b0;
    lfb_addr_entry_refill_way   <=  {`WK_LS_DCACHE_WAYIDX_WIDTH{1'b0}};
    lfb_addr_entry_dcache_hit   <=  1'b0;
    lfb_addr_entry_dcache_dirty <=  1'b0;
  end
  else if(lfb_addr_entry_create_dp_vld)
  begin
    lfb_addr_entry_rcl_done     <=  !lfb_create_linefill_dp;
    lfb_addr_entry_refill_way   <=  {`WK_LS_DCACHE_WAYIDX_WIDTH{1'b0}};
    lfb_addr_entry_dcache_hit   <=  1'b0;
    lfb_addr_entry_dcache_dirty <=  1'b0;
  end
  else if(vb_lfb_addr_entry_rcl_done)
  begin
    lfb_addr_entry_rcl_done     <=  1'b1;
    lfb_addr_entry_refill_way   <=  vb_lfb_dcache_way;
    lfb_addr_entry_dcache_hit   <=  vb_lfb_dcache_hit;
    lfb_addr_entry_dcache_dirty <=  vb_lfb_dcache_dirty;
  end
end

//+---------------+
//| already_reply |
//+---------------+
//if pfu create dcache hit, then reply dcache hit signal to prb
always @(posedge lfb_addr_entry_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    lfb_addr_entry_already_reply  <=  1'b0;
  else if(lfb_addr_entry_create_dp_vld)
    lfb_addr_entry_already_reply  <=  1'b0;
  else if(lfb_addr_entry_rcl_done)
    lfb_addr_entry_already_reply  <=  1'b1;
end

//+------+
//| depd |
//+------+
genvar i;
generate
  for (i=0; i<`NUM_LD + `NUM_LS; i=i+1) begin
always @(posedge lfb_addr_entry_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    lfb_addr_entry_depd[i]         <=  1'b0;
  else if(lfb_addr_entry_rb_create_dp_vld)
    lfb_addr_entry_depd[i]         <=  rb_lfb_depd; //TODO
  else if(lfb_addr_entry_pfu_create_dp_vld)
    lfb_addr_entry_depd[i]         <=  1'b0;
  else if(lfb_addr_entry_discard_vld[i])
    lfb_addr_entry_depd[i]         <=  1'b1;
end

//------------------compare ld_da stage---------------------
// assign lfb_addr_entry_ld_da_hit_idx[i]   = lfb_addr_entry_vld
//                                         &&  (lfb_addr_entry_addr_tto4[35:2]
//                                             ==  ld_da_addr_tto6[i][33:0]);
//------------------depd_vld--------------------------------
assign lfb_addr_entry_discard_vld[i] = ld_da_lfb_discard_grnt[i]
                                    &&  lfb_addr_entry_ld_da_hit_idx[i];
//---------------cache miss load hit pfu entry---------------
assign lfb_addr_entry_ld_da_hit_cacheline[i]   = lfb_addr_entry_vld
                                        &&  (lfb_addr_entry_addr_tto4[`WK_PA_WIDTH-5:2]
                                            ==  ld_da_addr_tto6[i]); 
assign lfb_addr_entry_pf_late_ld_vld[i] = ld_da_lfb_discard_grnt[i]
                                    &&  lfb_addr_entry_ld_da_hit_cacheline[i];

  end
endgenerate
// wjh@deadlock if stamo hit lfb, while lfb req in L2 nead to snoop amo addr
assign lfb_addr_entry_ld_da_hit_idx[0]   = lfb_addr_entry_vld
                                        && (lfb_addr_entry_addr_tto4[9:2] == ld_da_addr_tto6[0][7:0] 
                                            && (lfb_addr_entry_addr_tto4[`WK_PA_WIDTH-5:10] ==  ld_da_addr_tto6[0][`WK_PA_WIDTH-7:8]
                                             || (lfb_addr_entry_ldamo | lda0_lfb_ex3_ldamo))); //lsu-timing@LTL

assign lfb_addr_entry_ld_da_hit_idx[1]   = lfb_addr_entry_vld
                                        &&  (lfb_addr_entry_addr_tto4[9:2] == ld_da_addr_tto6[1][7:0] 
                                            && (lfb_addr_entry_addr_tto4[`WK_PA_WIDTH-5:10] ==  ld_da_addr_tto6[1][`WK_PA_WIDTH-7:8]
                                             || (lfb_addr_entry_ldamo | lsda0_lfb_ex3_ldamo)));//lsu-timing@LTL

assign lfb_addr_entry_ld_da_hit_idx[2]   = lfb_addr_entry_vld
                                        &&  (lfb_addr_entry_addr_tto4[9:2] == ld_da_addr_tto6[2][7:0] 
                                            && (lfb_addr_entry_addr_tto4[`WK_PA_WIDTH-5:10] ==  ld_da_addr_tto6[2][`WK_PA_WIDTH-7:8]
                                             || (lfb_addr_entry_ldamo | lsda1_lfb_ex3_ldamo)));//lsu-timing@LTL

//+------------+
//| late_ld/st |
//+------------+
always @(posedge lfb_addr_entry_clk or negedge cpurst_b)
begin
  if (!cpurst_b) 
  begin
    lfb_addr_entry_pf_late_ld      <=  1'b0;
    lfb_addr_entry_pf_late_st      <=  1'b0;
  end
  else if(lfb_addr_entry_rb_create_dp_vld || lfb_addr_entry_pfu_create_dp_vld) 
  begin
    lfb_addr_entry_pf_late_ld      <=  1'b0;
    lfb_addr_entry_pf_late_st      <=  1'b0;
  end
  else if(lfb_addr_entry_pfu_create && (lfb_addr_entry_pf_late_ld_vld[2] || lfb_addr_entry_pf_late_ld_vld[1] || lfb_addr_entry_pf_late_ld_vld[0]))
    lfb_addr_entry_pf_late_ld      <=  1'b1;
  else if(lfb_addr_entry_pf_late_st_vld[1] || lfb_addr_entry_pf_late_st_vld[0])
    lfb_addr_entry_pf_late_st      <=  1'b1;

end

//+------+
//| resp |
//+------+
always @(posedge lfb_addr_entry_clk or negedge cpurst_b)
begin
  if (!cpurst_b)
    lfb_addr_entry_resp         <=  1'b0;
  else if(lfb_addr_entry_create_dp_vld)
    lfb_addr_entry_resp         <=  1'b0;
  else if(lfb_addr_entry_resp_set)
    lfb_addr_entry_resp         <=  1'b1;
end


//==========================================================
//                 Generate create signal
//==========================================================
assign lfb_addr_entry_create_dp_vld = lfb_addr_entry_rb_create_dp_vld
                                      ||  lfb_addr_entry_pfu_create_dp_vld;
//==========================================================
//                 Generate vb req siganl
//==========================================================
assign lfb_addr_entry_vb_pe_req    = lfb_addr_entry_vld
                                      &&  !lfb_addr_entry_vb_pe_req_success;

assign lfb_addr_entry_vb_pe_req_success_set   = lfb_addr_entry_create_dp_vld
                                                    &&  lfb_vb_pe_req_permit
                                                    &&  !lfb_vb_pe_req
                                                ||  lfb_addr_entry_vb_pe_req
                                                    &&  lfb_addr_entry_vb_pe_req_grnt;

//==========================================================
//            Linefill permit
//==========================================================
// &Force("nonport","lfb_addr_entry_dcache_dirty"); @212
assign lfb_addr_entry_atomic_abort  = !lm_already_snoop
                                      &&  lfb_addr_entry_dcache_hit;
//                                      &&  lfb_addr_entry_dcache_dirty;
assign lfb_addr_entry_linefill_permit = lfb_addr_entry_rcl_done
                                        &&  (!lfb_addr_entry_dcache_hit
                                            ||  lfb_addr_entry_atomic
                                                &&  !lfb_addr_entry_atomic_abort);
assign lfb_addr_entry_linefill_abort  = lfb_addr_entry_rcl_done
                                        &&  lfb_addr_entry_dcache_hit
                                        &&  (~lfb_addr_entry_atomic
                                            ||  lfb_addr_entry_atomic
                                                &&  lfb_addr_entry_atomic_abort);

//for rready
assign lfb_addr_entry_not_resp  = lfb_addr_entry_vld
                                  &&  !lfb_addr_entry_resp; 
//==========================================================
//            Reply dcache hit signal to pfu
//==========================================================
//decode
assign lfb_addr_entry_pfu_id_oh[0]  = lfb_addr_entry_pfu_id[3:0]  ==  4'd0;
assign lfb_addr_entry_pfu_id_oh[1]  = lfb_addr_entry_pfu_id[3:0]  ==  4'd1;
assign lfb_addr_entry_pfu_id_oh[2]  = lfb_addr_entry_pfu_id[3:0]  ==  4'd2;
assign lfb_addr_entry_pfu_id_oh[3]  = lfb_addr_entry_pfu_id[3:0]  ==  4'd3;
assign lfb_addr_entry_pfu_id_oh[4]  = lfb_addr_entry_pfu_id[3:0]  ==  4'd4;
assign lfb_addr_entry_pfu_id_oh[5]  = lfb_addr_entry_pfu_id[3:0]  ==  4'd5;
assign lfb_addr_entry_pfu_id_oh[6]  = lfb_addr_entry_pfu_id[3:0]  ==  4'd6;
assign lfb_addr_entry_pfu_id_oh[7]  = lfb_addr_entry_pfu_id[3:0]  ==  4'd7;
assign lfb_addr_entry_pfu_id_oh[8]  = lfb_addr_entry_pfu_id[3:0]  ==  4'd8;

assign lfb_addr_entry_pfu_reply_vld       = lfb_addr_entry_vld
                                            &&  lfb_addr_entry_pfu_create
                                            &&  lfb_addr_entry_rcl_done
                                            &&  !lfb_addr_entry_already_reply;

assign lfb_addr_entry_pfu_dcache_hit_vld  = lfb_addr_entry_pfu_reply_vld
                                            &&  lfb_addr_entry_dcache_hit;
assign lfb_addr_entry_pfu_dcache_miss_vld = lfb_addr_entry_pfu_reply_vld
                                            &&  !lfb_addr_entry_dcache_hit;

assign lfb_addr_entry_pfu_dcache_hit[8:0] = {9{lfb_addr_entry_pfu_dcache_hit_vld}}
                                            & lfb_addr_entry_pfu_id_oh[8:0];

assign lfb_addr_entry_pfu_dcache_miss[8:0]= {9{lfb_addr_entry_pfu_dcache_miss_vld}}
                                            & lfb_addr_entry_pfu_id_oh[8:0];

//==========================================================
//                 Generate pop signal
//==========================================================
assign lfb_addr_entry_pop_vld       = lfb_lf_sm_addr_pop_req
                                      ||  lfb_data_addr_pop_req;

//==========================================================
//                    Compare index
//==========================================================
//------------------compare ld_da stage---------------------
// assign lfb_addr_entry_ld_da_hit_idx   = lfb_addr_entry_vld
//                                         &&  lfb_addr_entry_page_ca
//                                         &&  (lfb_addr_entry_addr_tto4[9:2]
//                                             ==  ld_da_idx[7:0]);
//------------------compare st_da stage---------------------
generate
for (i = 0; i<`NUM_LS ; i++) begin
assign lfb_addr_entry_cmp_st_da_addr[i][`WK_PA_WIDTH-1:0]  = st_da_addr[i][`WK_PA_WIDTH-1:0];
assign lfb_addr_entry_st_da_hit_idx[i]   = lfb_addr_entry_vld
                                        &&  lfb_addr_entry_page_ca
                                        &&  (lfb_addr_entry_addr_tto4[`WK_PA_WIDTH-5:2]
                                            ==  lfb_addr_entry_cmp_st_da_addr[i][`WK_PA_WIDTH-1:6]);
//-----------------cache miss store hit pfu entry------------
assign lfb_addr_entry_st_da_hit_cacheline[i]   = lfb_addr_entry_vld
                                        &&  lfb_addr_entry_page_ca
                                        &&  (lfb_addr_entry_addr_tto4[`WK_PA_WIDTH-5:2]
                                            ==  lfb_addr_entry_cmp_st_da_addr[i][`WK_PA_WIDTH-1:6]);

assign lfb_addr_entry_pf_late_st_vld[i] = st_da_cache_miss[i] && lfb_addr_entry_st_da_hit_cacheline[i];
end
endgenerate
//------------------depd_vld--------------------------------
// assign lfb_addr_entry_discard_vld = ld_da_lfb_discard_grnt
                                    // &&  lfb_addr_entry_ld_da_hit_idx;

//----------------compare rb biu req entry------------------
assign lfb_addr_entry_cmp_rb_biu_req_addr[`WK_PA_WIDTH-1:0] = rb_biu_req_addr[`WK_PA_WIDTH-1:0];
assign lfb_addr_entry_rb_biu_req_hit_idx  = lfb_addr_entry_vld
                                            &&  lfb_addr_entry_page_ca
                                            &&  (lfb_addr_entry_addr_tto4[9:2]
                                                ==  lfb_addr_entry_cmp_rb_biu_req_addr[13:6]);
//------------------compare pfu pop entry-------------------
assign lfb_addr_entry_cmp_pfu_biu_req_addr[`WK_PA_WIDTH-1:0]  = pfu_biu_req_addr[`WK_PA_WIDTH-1:0];
assign lfb_addr_entry_pfu_biu_req_hit_idx = lfb_addr_entry_vld
                                            &&  lfb_addr_entry_page_ca
                                            &&  (lfb_addr_entry_addr_tto4[9:2]
                                                ==  lfb_addr_entry_cmp_pfu_biu_req_addr[13:6]);
//------------------compare wmb read req--------------------
assign lfb_addr_entry_cmp_wmb_read_req_addr[`WK_PA_WIDTH-1:0] = wmb_read_req_addr[`WK_PA_WIDTH-1:0];
assign lfb_addr_entry_wmb_read_req_hit_idx  = lfb_addr_entry_vld
                                              &&  lfb_addr_entry_page_ca
                                              &&  (lfb_addr_entry_addr_tto4[9:2]
                                                  ==  lfb_addr_entry_cmp_wmb_read_req_addr[13:6]);
//------------------compare wmb write req-------------------
assign lfb_addr_entry_cmp_wmb_write_req_addr[`WK_PA_WIDTH-1:0] = wmb_write_req_addr[`WK_PA_WIDTH-1:0];
assign lfb_addr_entry_wmb_write_req_hit_idx = lfb_addr_entry_vld
                                              &&  lfb_addr_entry_page_ca
                                              &&  (lfb_addr_entry_addr_tto4[9:2]
                                                  ==  lfb_addr_entry_cmp_wmb_write_req_addr[13:6]);
//------------------compare snq create port-----------------
//snq only compare with addr with already received response
//assign lfb_addr_entry_cmp_snq_create_addr[`WK_PA_WIDTH-1:0] = snq_create_addr[`WK_PA_WIDTH-1:0];
//assign lfb_addr_entry_snq_create_hit_idx    = lfb_addr_entry_vld
//                                              &&  lfb_addr_entry_resp
//                                              &&  (lfb_addr_entry_addr_tto4[9:2]
//                                                  ==  lfb_addr_entry_cmp_snq_create_addr[13:6]);
//---------------compare snq bypass req addr----------------
assign lfb_addr_entry_cmp_snq_bypass_addr_tto6[`WK_PA_WIDTH-7:0]  = snq_bypass_addr_tto6[`WK_PA_WIDTH-7:0];
assign lfb_addr_entry_snq_bypass_hit          = lfb_addr_entry_vld
                                                &&  lfb_addr_entry_page_ca
                                                &&  lfb_addr_entry_resp
                                                &&  !lfb_addr_entry_rcl_done
                                                &&  (lfb_addr_entry_addr_tto4[`WK_PA_WIDTH-5:2]
                                                    ==  lfb_addr_entry_cmp_snq_bypass_addr_tto6[`WK_PA_WIDTH-7:0]);
//==========================================================
//                 Generate interface
//==========================================================
//------------------input-----------------------------------
//-----------create signal--------------
assign lfb_addr_entry_rb_create_vld           = lfb_addr_entry_rb_create_vld_x;
assign lfb_addr_entry_rb_create_dp_vld        = lfb_addr_entry_rb_create_dp_vld_x;
assign lfb_addr_entry_pfu_create_vld          = lfb_addr_entry_pfu_create_vld_x;
assign lfb_addr_entry_pfu_create_dp_vld       = lfb_addr_entry_pfu_create_dp_vld_x;
assign lfb_addr_entry_create_gateclk_en       = lfb_addr_entry_create_gateclk_en_x;
//-----------grnt signal----------------
assign lfb_addr_entry_vb_pe_req_grnt         = lfb_addr_entry_vb_pe_req_grnt_x;
//-----------other signal---------------
assign vb_lfb_addr_entry_rcl_done             = vb_lfb_addr_entry_rcl_done_x;
assign lfb_data_addr_pop_req                  = lfb_data_addr_pop_req_x;
assign lfb_lf_sm_addr_pop_req                 = lfb_lf_sm_addr_pop_req_x;
assign lfb_addr_entry_resp_set                = lfb_addr_entry_resp_set_x;
//------------------output----------------------------------
//-----------entry signal---------------
assign lfb_addr_entry_vld_x                   = lfb_addr_entry_vld;
assign lfb_addr_entry_addr_tto4_v[`WK_PA_WIDTH-5:0]  = lfb_addr_entry_addr_tto4[`WK_PA_WIDTH-5:0];
assign lfb_addr_entry_refill_way_x            = lfb_addr_entry_refill_way;
assign lfb_addr_entry_depd_x                  = {lfb_addr_entry_depd[2],lfb_addr_entry_depd[1],lfb_addr_entry_depd[0]};
//assign lfb_addr_entry_resp_x                  = lfb_addr_entry_resp;
assign lfb_addr_entry_rcl_done_x              = lfb_addr_entry_rcl_done;
assign lfb_addr_entry_dcache_hit_x            = lfb_addr_entry_dcache_hit;
assign lfb_addr_entry_ldamo_x                 = lfb_addr_entry_ldamo;
assign lfb_addr_entry_not_resp_x              = lfb_addr_entry_not_resp;
assign lfb_addr_entry_page_nc_x               = !lfb_addr_entry_page_ca;
assign lfb_addr_entry_page_share_x            = lfb_addr_entry_page_share;
assign lfb_addr_entry_pfu_create_x            = lfb_addr_entry_pfu_create;
assign lfb_addr_entry_pfu_id_x                = lfb_addr_entry_pfu_id;
assign lfb_addr_entry_pfu_id_vld_x            = lfb_addr_entry_pfu_id_vld;
assign lfb_addr_entry_pf_type_x               = lfb_addr_entry_pf_type;
assign lfb_addr_entry_full_va_x               = lfb_addr_entry_full_va;
assign lfb_addr_entry_pf_late_ld_x            = lfb_addr_entry_pf_late_ld;
assign lfb_addr_entry_pf_late_st_x            = lfb_addr_entry_pf_late_st;
//-----------request--------------------
assign lfb_addr_entry_vb_pe_req_x             = lfb_addr_entry_vb_pe_req;
assign lfb_addr_entry_pop_vld_x               = lfb_addr_entry_pop_vld;
assign lfb_addr_entry_discard_vld_x           = {lfb_addr_entry_discard_vld[2],lfb_addr_entry_discard_vld[1],lfb_addr_entry_discard_vld[0]};
assign lfb_addr_entry_pfu_dcache_hit_v[8:0]   = lfb_addr_entry_pfu_dcache_hit[8:0];
assign lfb_addr_entry_pfu_dcache_miss_v[8:0]  = lfb_addr_entry_pfu_dcache_miss[8:0];
//---------linefill info----------------
assign lfb_addr_entry_linefill_permit_x       = lfb_addr_entry_linefill_permit;
assign lfb_addr_entry_linefill_abort_x        = lfb_addr_entry_linefill_abort;
//-----------hit idx--------------------
assign lfb_addr_entry_ld_da_hit_idx_x         = {lfb_addr_entry_ld_da_hit_idx[2],lfb_addr_entry_ld_da_hit_idx[1],lfb_addr_entry_ld_da_hit_idx[0]};
assign lfb_addr_entry_st_da_hit_idx_x         = {lfb_addr_entry_st_da_hit_idx[1],lfb_addr_entry_st_da_hit_idx[0]};
assign lfb_addr_entry_rb_biu_req_hit_idx_x    = lfb_addr_entry_rb_biu_req_hit_idx;
assign lfb_addr_entry_pfu_biu_req_hit_idx_x   = lfb_addr_entry_pfu_biu_req_hit_idx;
assign lfb_addr_entry_wmb_read_req_hit_idx_x  = lfb_addr_entry_wmb_read_req_hit_idx;
assign lfb_addr_entry_wmb_write_req_hit_idx_x = lfb_addr_entry_wmb_write_req_hit_idx;
//assign lfb_addr_entry_snq_create_hit_idx_x    = lfb_addr_entry_snq_create_hit_idx;
assign lfb_addr_entry_snq_bypass_hit_x        = lfb_addr_entry_snq_bypass_hit;

//==========================================================
//        interface to hpcp
//==========================================================
assign ld_hit_prefetch_first   = |lfb_addr_entry_ld_da_hit_idx_x //TODO
                                 && lfb_addr_entry_pfu_create 
                                 && !(|lfb_addr_entry_depd_x); //TODO

assign ld_hit_prefetch_first_x = ld_hit_prefetch_first;
// &ModuleEnd; @381
endmodule


