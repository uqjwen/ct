# interaction 1.1.1
针对doc-1.1中xx_lsu_ld_ag_risk_review列出的风险点，有如下细节进行澄清：
***
1. 针对RR-08，如果在创建lrq时发生flush时，上游项也会被flush，因此对于上游的lsiq项，flush的优先级比pop的优先级高，也就是您说的"上游明确规定 flush 周期无条件忽略该 pop"
2. 针对RR-11，能够确保dcache读没有副作用，如果pa-vld等于0，表示tlb-miss，将在ldc栈进行重发，异常或者ca=0，即使读出的数据/tag也不会被使用，这个是原C910设计，没有动。
3. 针对RR-12，如果case出现x态，我们实际上是希望x态传播出来。
4. 针对RR-13，来自idu的fresh请求，如果创建lrq（lsu_lrq_create_vld=1）是发生dcache结构反压，同时tlbmiss且没有abort，并且rf栈有更老的请求；这种情况下，创建lrq是携带lrq_crate_frz=0，会满足重发条件，另外，此时lag_ex1_stall_restart_entry=12'b0，mmu不会记录该请求的lsid，不会重复对其进行唤醒。
5. 针对RR-14，设计上能够确保lrq的创建和mmu的唤醒不会同拍，如果lrq创建的时候，请求满足被mmu立即唤醒，唤醒信号会打一拍给lrq；
6. 针对4.2的最后一条，来自sq模块的sq未满唤醒型号对于lsu2和lsu3具有同样的意义，如果两个lane中lrq队列中存在lrq项等待sq有余项唤醒，那么lsu2_lrq_exx_sq_not_full需要唤醒两个lane中所有等待sq有余项的请求。
7. 针对5.1，mmu正式accept条件是发起mmu请求（lsu_mmu_va_vld）并没有abort(lsu_mmu_abort)，当拍记录mmu的miss队列，下一拍生效。
8. 针对5.2 lsu_mmu_abort不能追溯取消
9. 针对5.3 回答同针对RR-13的回答
10. 针对5.4 回答同针对RR-14的回答
11. 针对5.5 回答同针对RR-08的回答
12. 针对5.6 回答同针对RR-11的回答
13. 针对5.7 no_spec_exist在进入lsu流水线之后，我们确实把这个信号的语义挪为他用
14. 针对5.8 设计明确LRQENTRY==LSIQENTRY、PC_LEN==15、VMBENTRY==8 和 9-bit split number
15. 针对5.9 dcache_arb_lag_ex1_sel表示lag流水新没有被借用，lag请求可以访问dcache，即表示选择也表示接受；
16. 针对5.10 pfu_part_empty tie 0，不会恢复真是empty，应该是放松的钟控，不会有功能上的问题吧？
***
请基于以上部分澄清，继续检查潜在的设计bug。