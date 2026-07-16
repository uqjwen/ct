# interaction 1.1.3
针对doc-1.1.2中xx_lsu_ld_ag_risk_review列出的风险点，有如下细节进行澄清：
***
1. 针对RR-02，no_spec是用于在ld_da栈产生nospec_miss/nospec_mispred，再输入到ifu模块的sfp模块来纠正打no_spec标签用的，现在sfp里面实现，并且no_spec标签在idu阶段访问sfp表项进行标记，因此可以认为no_spec在重发进入ag已经没有使用意义。另外element_cnt在helper中是根据ld_ag_split_cnt和ld_ag_vmew生成的，而这两者在replay时都是保存着的，rot_sel驱动来源是reg_element_rot -> reg_element_cnt -> element_cnt -> ld_ag_split_cnt, lag_ldc_ex1_vsew，而ld_ag_split_cnt, lag_ldc_ex1_vsew都是在replay时就保存着的。
***
请基于以上部分澄清，继续检查潜在的设计bug。

# interaction 1.2
请仿照xx_lsu_ld_ag模块，针对其他模块也进行潜在的设计错误检查，并把结果放到相应的目录中，如xx_lsu_lrq/lrq_entry检查结果放入doc-lrq中，xx_lsu_rb/rb_entry检查结果放入doc-rb中，xx_lsu_dc检查结果放入doc-dc中，xx_lsu_da检查结果放入doc_da中。