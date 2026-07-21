# interaction 1.1.3
针对doc-1.1.2中xx_lsu_ld_ag_risk_review列出的风险点，有如下细节进行澄清：
***
1. 针对RR-02，no_spec是用于在ld_da栈产生nospec_miss/nospec_mispred，再输入到ifu模块的sfp模块来纠正打no_spec标签用的，现在sfp里面实现，并且no_spec标签在idu阶段访问sfp表项进行标记，因此可以认为no_spec在重发进入ag已经没有使用意义。另外element_cnt在helper中是根据ld_ag_split_cnt和ld_ag_vmew生成的，而这两者在replay时都是保存着的（非x），rot_sel驱动来源是reg_element_rot -> reg_element_cnt -> element_cnt -> ld_ag_split_cnt, lag_ldc_ex1_vsew，而ld_ag_split_cnt, lag_ldc_ex1_vsew都是在replay时就保存着的（非x）。
***
请基于以上部分澄清，继续检查潜在的设计bug。

# interaction 1.2
请仿照xx_lsu_ld_ag模块，针对其他模块也进行潜在的设计错误检查，并把结果放到相应的目录中，如xx_lsu_lrq/lrq_entry检查结果放入doc-lrq中，xx_lsu_rb/rb_entry检查结果放入doc-rb中，xx_lsu_dc检查结果放入doc-dc中，xx_lsu_da检查结果放入doc_da中。

# interaction 1.3
针对interaction-1.2的结果，一些疑问排查如下：
***
1. 针对RB-RR-01，所描述场景为lane2的lsda0_rb_ex3_create_dp_vld=1，lane3的创建指针会选通为rb_create_ptr3，如果只剩一项的情况下，rb_create_ptr3实际为0，但是rb_create_ls1_success=1导致请求创建丢失；该场景应该不会成立，因为判断rb_lsda1_ex3_full时，使用lsda0_rb_ex3_create_judge_vld进行判断（xx_lsu_rb.sv：1466-1474），从条件成立的严格角度来讲，从lsda0_rb_ex3_create_judge_vld到lsda0_rb_ex3_create_dp_vld到lsda0_rb_ex3_create_vld，条件成立的严格程度递增，也就是lsda0_rb_ex3_create_judge_vld是lsda0_rb_ex3_create_dp_vld、lsda0_rb_ex3_create_vld成立的前提必要条件，lsda0_rb_ex3_create_dp_vld是lsda0_rb_ex3_create_vld成立的必要条件。所以如果仅剩1项，且lsda0_rb_ex3_create_dp_vld=1（意味着lsda0_rb_ex3_create_judge_vld=1），lane3因为rb_lsda1_ex3_full是不会创建成功的。但是之前出现类似的bug，在entry是根据create_dp_vld来创建请求个字段的，且lane0的优先级高于lane1（通过if-else实现），此时两个lane的create_dp_vld都有效，由于某些原因，lane0没有成功创建项，lane1成功创建项，但是请求字段却是来自lane0的请求字段（因为lane0的create_dp_vld有效，且优先级高于line1）。请继续排查
2. 针对RB-RR-02，除了SO/SYNC/ATOMIC-NC之外的请求，rb的rid会根据申请到的lfb项的编号进行编码（xx_lsu_rb.sv 1829-1837），async产生flush时，rtu能够确保所有达到提交态请求的数据回来之后再产生flush，对于没有cmit的请求，仍然占据这lfb项，后续请求在前序请求释放lfb项之前，不会被分配相同的rid；对于so类型请求，需要等达到提交态才发送（rb-entry: line2017），atomic确保在ag达到提交态（ld-ag-2710）,sync_fence请求要求wmb_sync_fence_biu_req_success，sync-fence请求从sq进入wmb意味着以及达到提交态，后续sync-fence请求在其处理结束之前，在st-da栈通过wait-fence重发。
3. 针对RB-RR-03，设计上要求unit-stride数据响应必须2拍，如果在ca=0或者so=1的空间，将报错误，access_fault_with_page；BIU能够确保 ID严格返回恰好两拍、无重放/截断。
4. 针对RB-RR-04，b-resp主要用于sync-fence请求，wmb应该能够确保不存在共享 ID 的无关 B response 在本 entry 正式 request 前到达，这些逻辑沿用C910，请确认游戏啊。
5. 针对WB-RR-03，lda_lwb_ex3_data_req_dp成立条件更宽松，是lda_lwb_ex3_data_req的前提必要条件（ld_da: 4986-5015），因此不存在req=1&dp=0，而dp=1&req=0情况是存在的，但是对功能应该没有影响，而lda_lwb_ex3_data_req_gateclk_en更宽松，目的是只要有潜在的数据写回，打开钟控。
6. 针对WB-RR-04，应该不存在低优先级饿死的场景。如果rb无法写回，存在raw相关的请求无法下发，会渐渐占满发射队列，导致请求无法下发。而且通过xx_lsu_bus_arb模块可以申请在任意3个lane中空闲lane写回。
7. 针对DC-RR-02，dcache_arb_ldc_borrow_vld和dcache_arb_ldc_borrow_vld_gate都来自xx_lsu_dcache_arb模块，在这模块中，两者赋值是等价的。
8. 针对DC-RR-03，lfb等其他缓存一致性逻辑能够确保只命中一路，否则存在多个副本，这种错误将通过其他逻辑（缓存一致性测试数据对比）来检测
9. 针对LQ-RR-01如果考虑到年龄向量，时序很紧张，实测多个更年轻的pc违规情况不多见，对性能几乎无影响
10. 针对LQ-RR-02,所述场景是lsdc0_lq_ex2_create_vld=1，但是某种原因，lane2没有创建成功lq_create2_success=0，在仅剩1项的情况下，lane3的创建指针为lq_create_ptr3=0，导致创建请求丢失。但是如line-587所描述，在仅剩余1项的情况下且lsdc0_lq_ex2_create_vld=1成立的情况下，lane3是不会创建成功的（lq_create3_sucess=0），请排查是否还存在其他隐患。
11. 针对LQ-RR-03，所述场景是flush之后将lq_entry进行了无效化操作，后续又由于lq_entry_pop_vld指向的项和其他请求create指向同一该项，导致创建不成功。分析：考虑到lq_entry_pop_vld主要在da栈产生，且其必要条件是dc栈创建lq成功（xx_lsu_ld_da.sv- ld_da_lq_entry:4877 xx_lsu_ld_dc.sv-1608, xx_lsu_lq.sv-728），如果需要满足所述“若 flush 后出现迟到 restart-pop”，那么意味着在dc栈产生flush，但是如果dc栈产生flush，意味着请求不会创建lq项，且不会进入da栈，请排查是否存在其他隐患。
12. 针对LRQ-RR-02，fresh请求进入ag栈之前，通过lrq*_no_space判断是否足够余留项让其进入ag栈时创建lrq，如果没有是不会进入ag站的，所以在ag栈创建lrq时，已经通过上述确保不会出现full情况出现。create_success和create_vld之间条件差别是考虑到flush的情况，因此需要考虑的场景是，create_vld有效并且发生了flush，此时没有创建成功，但是通过create_vld将上游的项进行了弹出操作，针对这个问题，合同可以确保在上游，对应项也会被flush无效化。
13. 针对LRQ-RR-03，合共能够确保发生flsuh是，mmu不会重复去唤醒在lrq中被无效化的项。
14. 针对CTRL-RR-01，idu_lsu_vmb_create0_gateclk_en信号重复两次确实是笔误，该门控通过pfu_part_empty全部常开，不会造成功能上的问题。
15. 针对CTRL-RR-02，合同确保LSIQENTRY=LRQENTRY
16. 针对CTRL-RR-03，lrq-entry在请求没有cmplt之前（通过da栈没有被重发），唤醒信号的entry-bit对应唯一一个iid，因此只要存在重发或者请求丢弃，合同确保该请求不会被lrq释放，因此不存在所述“如果 MMU/LFB/SQ/WMB 的异步事件在 LSIQ/LRQ entry 释放并复用后迟到”，当然总体上设计思路是这样，不排除确实有些地方存在bug没有遵循这个守则，希望您帮忙找出来？
17. 怎么没有xx_lsu_ld_da的对应的分析。
***
请继续排查，是否需要提供其他额外信息以供决策

# interaction 1.4
***
1. 针对LRQ-RR-01，这个确实是个问题，我们将在后续修改版本。
2. 针对WB-RR-01，这个确实是个问题，添加ld_wb_cmplt_clk钟控使能ld_wb_cmplt_clk_en条件。
3. 针对DC-RR-01，这个确实是个问题，我们将在后续版本修改。
4. 针对DA-RR-01，这个确实是个问题，详见修改。
5. 针对WB-RR-02，来自dtu的halt-info一边都是最低两个bits同时为1，意味着ld_wb_halt_info[0]只会维持一个时钟周期的高电平。
6. 由于没有DA的报告，看不到DA-RR-02/04，请重新生成DA的详细报告放入doc-da目录。
7. 补充了需要的module，希望有助于解决interaction-1.3-followup-review第5点相关问题。
***

# interaction 1.5
***
1. 针对CTRL-RR-03，当前设计没有引入epoch的概念，本设计是在C910开源代码修改的，请继续确认是否存在设计风险
2. 针对DA-RR-01，这是设计bug，笔误，为啥不用P1优先级，而是用P2呢？
3. 针对DA-RR-03，同CTRL-RR-03，当前设计没有引入epoch的概念，本设计是在C910开源代码修改的，请继续确认是否存在设计风险。
4. 针对DC-RR-02，能够确保在snq模块中snq_dcache_arb_ld_borrow_req_gate和snq_dcache_arb_ld_borrow_req是等同的，在vb模块中vb_dcache_arb_ld_borrow_req_gate比vb_dcache_arb_ld_borrow_req成立要求更宽松，即，vb_dcache_arb_ld_borrow_req_gate=1成立是vb_dcache_arb_ld_borrow_req=1成立的必要条件，vb_dcache_arb_ld_borrow_req=1是vb_dcache_arb_ld_borrow_req_gate=1的充分条件。
5. 针对DC-RR-05，unite-stride是512bit数据位宽，对应64个字节有效位，普通标量/非unite-stride向量，128位数据位宽，对应16个字节有效位只用第一个bytes_vld/reg_bytes_vld。对应普通标量加载，其他字节有效位=1没有功能上的影响，这里对于普通加载没有置零是为了综合网表时形成门控，降低功耗。
6. 针对LRQ-RR-03，同CTRL-RR-03，当前设计没有引入epoch的概念，请继续确认是否存在设计风险。
7. 针对LRQ-RR-04，同DC-RR-05
8. 针对RB-RR-02，由于本设计继承玄铁C910， “RTU 对 async flush 的全局 response 取消规则与 BIU 的 outstanding ownership 仍不可见”请参考C910代码
9. RB-RR-04，由于本设计继承玄铁C910，“BIU 对固定 ID 的全局 outstanding/返回规则”，请参考C910代码
10. 针对WB-RR-01/02，请参考代码修改
11. 针对WB-RR-04，添加了xx_lsu_wb_arbiter代码
***
# interaction 1.6
***
1. 针对CTRL-RR-03，是否能提供断言wakeup[bit] -> entry_vld[bit] && producer_owner_iid == entry_iid、create_accept(bit) -> no old-owner producer pending的写法？在代码中实现并注释。
2. 针对DC-RR-03, 请直接在代码中实现断言，并注释。
3. 针对RB-RR-02，异步flush确实没有要求cmit态的请求数据响应。该异步flush是debug模块发起，对outstanding请求响应不做要求，应用场景是由于outstanding请求长期没有响应等原因导致处理器核卡死，通过异步flush进入debug模式查看处理器核状态。
4. 针对WB-RR-04，RB-RR-04都是继承C910设计，如果C910设计证明没有错误，则可以waive。
5. 在原本设计中，xx_lsu_ld_ag栈，如果发生dcache反压等原因发生lag_ex1_stall_ori，通过lsu_mmu_abort中断mmu访问；事实证明这样设计会导致该逻辑相关的时序逻辑级数过高。因此lag_ex1_stall_ori期间，仍允许访问mmu，如果发生tlbmiss，pagefault，access-fault，则将其记录下来（lag_bkcon_stall_vld，lag_bkcon_tlbmiss, lag_bkcon_pgfault，lag_mmu_acfault），如果是lag_bkcon_tlbmiss则通过将信号ld_ag_stall_vld置0，信号ld_ag_stall_restart置1，将ex1栈无效化；如果是page-fault或者ac-fault则通过lsu_mmu_abort不再发送mmu请求，并将相应的错误传递（lag_ldc_ex1_expt_page_fault，lag_ldc_ex1_expt_vld），请注意mmu_lsu_access_fault需要在发送mmu访问请求的下一拍知道结果；另外多余unite-stride，由于需要访问512位宽，因此需要在lag栈获得命中路信息，以便访问对应路的512数据，因此需要停顿2拍，第一拍停顿是为了访问tag（lag_us_tag_req_stall），第二拍将命中路信息（lag_us_tag_hit_way）打一拍（lag_us_tag_req_success_flop）。期间如果发生tlbmiss，pagefault，accessfault，处理方法和上面相同。请检查这么设计是否有功能上的设计错误。
***