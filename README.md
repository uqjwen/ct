# interaction 1.1
针对doc-1.1中xx_lsu_ld_ag_risk_review列出的风险点，有如下细节补充：
***
1. 针对RR05，mmu返回的access-fault由于时序关系，是在发起mmu请求的下一篇返回结果，因此如果在lag_bkcon_stall_vld=1是发起mmu请求，access_fault是在lag_bkcon_stall_already=1返回结果，此时锁存access-fault恰好对拍；
2. 针对RR06，可以确定mmu_lsu_stall信号是tie 0的，因此不会出现所述的场景：mmu没有接收请求，但是寄存bkcon_tlbmiss导致不再发送请求；之前确实出现设计bug，原因是用lag_ldc_ex1_utlb_miss信号替代lag_stall_ori_tlbmiss_not_abort产生重发信号，设计初衷是，当有更老的rf栈请求B，需要覆盖停顿的更新的ag栈请求A，此时如果发生tlbmiss，则由mmu记录唤醒，否则直接用ag——controler重发；但是lag_ldc_ex1_utlb_mis并未考虑lsu_mmu_abort，此时如果发生lsu_mmu_abort，请求未被mmu记录，也未被ag唤醒，导致请求丢失；请检查类似bug（为此，我将controler模块补充）；
3. 针对RR07，mmu能够确保page_fault=1时，pa_vld=1，且同拍，即后者时前者的必要条件；设计初衷是在停顿期间如果出现页故障，则将其记录下来，并且不再访问mmu；
4. 针对RR08，对于非replay的请求（来自idu），详见xx_lsu_lrq:1635-1637的lrq0_no_space信号，确保新请求进入ag之前有空余项让其创建；
5. 针对RR09，这些信号原来是输入给IDU的（原始设计是从IDU进行replay），现在相应的输入到LRQ模块（现在从LRQ进行replay）
6. 针对RR12，lag_ldc_ex1_bytes_vld1的always语句的case已经囊括了所有情况000-111；
***
请基于以上部分澄清，继续检查潜在的设计bug。