# interaction 1.1.2
针对doc-1.1.1中xx_lsu_ld_ag_risk_review列出的风险点，有如下细节进行澄清：
***
1. 针对RR-13，考虑场景为fresh创建lrq的当拍，产生tlbmiss，并且将要被更老的rf栈请求覆盖，通过lag_ldc_ex1_lsid（xx_lsu_ld_ag-2856）被mmu记录，同时由于lrq_create_frz=0，会被立即唤醒，mmu又唤醒一次，导致两次唤醒。按照您构造的场景对lsu_lrq_create_frz进行修改。添加了条件mmu_lsu_pa_vld或者lsu_mmu_abort，两者满足其一，请求都不会被mmu记录。
2. 针对RR-14，通过针对对RR-16的澄清，是否能够明确RR-14是否还有风险。
3. 针对RR-16，mmu_lsu_imme_wakeup在mmu中tie 0，mmu唤醒lsu的接口仅通过mmu_lsu_async_wakeup来唤醒。

4. 针对5.1，之前描述有误，将lsu_mmu_lsid0和stall-restart-entry等同，现在针对第1点，是否澄清？
5. 针对5.2，已经确保mmu_lsu_imme_wakeup在mmu中tie 0
6. 针对5.3，full/partial flush能够将mmu中pending的请求直接刷掉
7. 针对5.4，halt_info应该保留，其他用于地址计算，和字节有效位计算，这些在lrq中保留，replay的时候不需要重新计算，故其他信号对于replay的指令没有用了
8. 针对5.5，我们将进行修改
***
请基于以上部分澄清，继续检查潜在的设计bug。