#!/usr/bin/env python3
"""Build reviewed interaction-2.1 LSU module plans and standalone harnesses."""

from __future__ import annotations

import argparse
import csv
import json
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Mapping


REPO_ROOT = Path(__file__).resolve().parents[3]
if str(REPO_ROOT) not in sys.path:
    sys.path.insert(0, str(REPO_ROOT))

from verif.common.tools.gen_env import generate
from verif.common.tools.rtl_ports import Port, parse_module_ports
from verif.common.tools.scenario_contract import DETAIL_COLUMNS


@dataclass(frozen=True)
class Feature:
    title: str
    testcase: str
    checker: str
    coverage: str
    priority: str
    drive: tuple[str, ...]
    observe: tuple[str, ...]
    trigger: str
    expected: str
    closure: str
    result: str = "BLOCKED_NO_VCS"


@dataclass(frozen=True)
class Environment:
    name: str
    prefix: str
    source: str
    feature_doc: str
    runbook: str
    clock: str
    reset: str
    flush: str
    parameters: Mapping[str, object]
    idle_overrides: Mapping[str, object]
    declared_stubs: tuple[str, ...]
    production_sources: tuple[str, ...]
    features: tuple[Feature, ...]
    doc_tokens: tuple[str, ...] = ()


DC_FEATURES = (
    Feature("EX1到EX2 owner锁存", "tc_dc_ex1_ex2_owner", "CHK_DC_FP01_OWNER", "COV_DC_FP01_OWNER", "P0", ("lag_ldc_ex1_inst_vld", "lag0_ex1_iid"), ("ldc_lda_ex2_inst_vld", "ldc_ex2_iid"), "当 `lag_ldc_ex1_inst_vld=1` 且无flush时", "则 C1 `ldc_lda_ex2_inst_vld=1` 且 `ldc_ex2_iid=lag0_ex1_iid`", "每个accept仅产生一个同IID的EX2 owner"),
    Feature("borrow valid与payload gate", "tc_dc_borrow_owner", "CHK_DC_FP02_BORROW_GATE", "COV_DC_FP02_BORROW", "P0", ("dcache_arb_ldc_borrow_vld", "dcache_arb_ldc_borrow_vld_gate"), ("ldc_ex2_borrow_vld", "ldc_lda_ex2_borrow_vb"), "当 `dcache_arb_ldc_borrow_vld=1` 且 `dcache_arb_ldc_borrow_vld_gate=1` 时", "则 C1 `ldc_ex2_borrow_vld=1` 且borrow payload来自同一请求", "valid-only负向注入必须触发gate合同检查"),
    Feature("四路D-cache tag命中", "tc_dc_tag_way", "CHK_DC_FP03_HIT_ONEHOT", "COV_DC_FP03_HIT_WAY", "P0", ("lag_ldc_ex1_inst_vld", "cp0_lsu_dcache_en", "dcache_lsu_ld_tag_dout"), ("ldc_hit_way", "ldc_lda_ex2_dcache_hit"), "当 `lag_ldc_ex1_inst_vld=1` 且 `cp0_lsu_dcache_en=1` 时", "则 C1 `ldc_hit_way` 必须满足onehot0且 `ldc_lda_ex2_dcache_hit` 等于其归约或", "0/1路命中合法，2至4路命中必须被检测"),
    Feature("unit-stride way保存", "tc_dc_unit_stride_way", "CHK_DC_FP04_US_WAY", "COV_DC_FP04_US_WAY", "P0", ("lag_ldc_ex1_inst_vld", "lag_ldc_ex1_inst_us", "lag_ldc_ex1_us_way"), ("ldc_lda_ex2_settle_way", "ldc_lda_ex2_inst_us"), "当 `lag_ldc_ex1_inst_us=1` 且 `lag_ldc_ex1_us_way` 为one-hot时", "则 C1 `ldc_lda_ex2_settle_way` 与输入way编码一致且 `ldc_lda_ex2_inst_us=1`", "四way后接scalar不得粘连旧way"),
    Feature("四区byte与reg-byte mask", "tc_dc_byte_masks", "CHK_DC_FP05_MASK_PASS", "COV_DC_FP05_MASK", "P1", ("lag_ldc_ex1_inst_vld", "lag_ldc_ex1_bytes_vld", "lag_ldc_ex1_bytes_vld1", "lag_ldc_ex1_bytes_vld2", "lag_ldc_ex1_bytes_vld3"), ("ldc_lda_ex2_bytes_vld", "ldc_lda_ex2_bytes_vld1", "ldc_lda_ex2_bytes_vld2", "ldc_lda_ex2_bytes_vld3"), "当 `lag_ldc_ex1_inst_vld=1` 且四区mask使用互异花纹时", "则 C1 `ldc_lda_ex2_bytes_vld` 至bytes_vld3逐区保持原花纹", "适用mask逐bit保真，非US不得消费高区旧值"),
    Feature("LQ create资格与指针", "tc_dc_lq_create", "CHK_DC_FP06_LQ_ACCEPT", "COV_DC_FP06_LQ", "P0", ("lag_ldc_ex1_inst_vld", "lq_ldc_ex2_full", "lq_ldc_create_entry"), ("ldc_lq_ex2_create_vld", "ldc_lda_ex2_lq_entry"), "当 `lag_ldc_ex1_inst_vld=1` 且 `lq_ldc_ex2_full=0` 时", "则 `ldc_lq_ex2_create_vld=1` 且 `ldc_lda_ex2_lq_entry=lq_ldc_create_entry`", "accept对应唯一entry，full或flush时不创建"),
    Feature("LQ full与TLB busy restart", "tc_dc_restart", "CHK_DC_FP07_RESTART_BLOCK", "COV_DC_FP07_RESTART", "P0", ("lag_ldc_ex1_inst_vld", "lq_ldc_ex2_full", "mmu_lsu_tlb_busy"), ("ldc_lda_ex2_inst_vld", "ldc_idu_ex2_lq_full", "ldc_idu_ex2_tlb_busy"), "当 `lq_ldc_ex2_full=1` 或 `mmu_lsu_tlb_busy=1` 命中live owner时", "则 `ldc_lda_ex2_inst_vld=0` 且对应restart原因输出为1", "每个原因及两两交叉均只产生一次restart"),
    Feature("异常mask与extra传递", "tc_dc_exception", "CHK_DC_FP08_EXCEPTION", "COV_DC_FP08_EXCEPTION", "P0", ("lag_ldc_ex1_inst_vld", "lag_ldc_ex1_expt_vld", "lag_ldc_ex1_expt_page_fault"), ("ldc_lda_ex2_expt_vld_except_access_err", "ldc_lda_ex2_expt_access_fault_extra"), "当 `lag_ldc_ex1_expt_vld=1` 随live owner进入DC时", "则 C1 `ldc_lda_ex2_expt_vld_except_access_err=1` 且异常owner不变", "PF/misalign/AF每个子类不丢失不重复"),
    Feature("SQ与WMB forward元数据", "tc_dc_forward", "CHK_DC_FP09_FWD_OWNER", "COV_DC_FP09_FWD", "P1", ("lag_ldc_ex1_inst_vld", "sq_ldc_ex2_fwd_req", "wmb_ldc_fwd_req"), ("ldc_lda_ex2_fwd_sq_vld", "ldc_lda_ex2_fwd_wmb_vld", "ldc_lda_ex2_fwd_bytes_vld"), "当 `sq_ldc_ex2_fwd_req=1` 且 `wmb_ldc_fwd_req=0` 时", "则 `ldc_lda_ex2_fwd_sq_vld=1`、`ldc_lda_ex2_fwd_wmb_vld=0` 且byte mask属于SQ owner", "SQ/WMB互异花纹不得串source"),
    Feature("DC到DA payload分流", "tc_dc_da_transfer", "CHK_DC_FP10_DA_PAYLOAD", "COV_DC_FP10_DA", "P0", ("lag_ldc_ex1_inst_vld", "lag0_ex1_iid", "lag_ldc_ex1_addr0"), ("ldc_lda_ex2_inst_vld", "ldc_ex2_iid", "ldc_ex2_addr0"), "当 `lag_ldc_ex1_inst_vld=1` 被DC接受时", "则 C1 `ldc_lda_ex2_inst_vld=1` 且IID、地址payload hash与原owner一致", "inst与borrow back-to-back时每次accept只转移一个owner"),
    Feature("debug地址采集脉冲", "tc_dc_debug_pulse", "CHK_DC_FP11_DTU_PULSE", "COV_DC_FP11_DTU", "P1", ("lag_ldc_ex1_inst_vld", "ld_ag_dtu_vld", "ld_ag_dtu_va"), ("ld_dc_dtu_addr_vld", "ld_dc_dtu_addr"), "当 `ld_ag_dtu_vld=1` 随live load进入时", "则 C1 `ld_dc_dtu_addr_vld=1` 且 `ld_dc_dtu_addr=ld_ag_dtu_va`，C2必须回到0", "debug/normal/debug只产生两个单拍有效脉冲"),
    Feature("clock reset与scan覆盖", "tc_dc_clock_reset", "CHK_DC_FP12_CLOCK_RESET", "COV_DC_FP12_CLOCK", "P1", ("lag_ldc_ex1_inst_vld", "cp0_lsu_icg_en", "pad_yy_icg_scan_en"), ("ldc_lda_ex2_inst_vld", "ldc_ex2_full_gateclk_en"), "当 `cp0_lsu_icg_en=0`、`pad_yy_icg_scan_en=1` 且owner有效时", "则scan路径允许状态捕获并使 `ldc_lda_ex2_inst_vld=1`，reset低时所有valid为0", "ICG on/off/scan/reset边界均无X或幽灵owner"),
)


DA_FEATURES = (
    Feature("D-cache 16 bank数据选择", "tc_da_cache_data", "CHK_DA_FP01_DATA_SELECT", "COV_DA_FP01_DATA", "P0", ("ldc_lda_ex2_inst_vld", "ldc_lda_ex2_get_dcache_data", "dcache_lsu_ld_data_bank0_dout", "dcache_lsu_ld_data_bank4_dout", "dcache_lsu_ld_data_bank8_dout", "dcache_lsu_ld_data_bank12_dout"), ("lda_rb_ex3_data_ori", "lda_rb_ex3_data_ori1", "lda_rb_ex3_data_ori2", "lda_rb_ex3_data_ori3"), "当 `ldc_lda_ex2_inst_vld=1` 且四个region选择位有效时", "则 `lda_rb_ex3_data_ori` 至data_ori3分别对应四块互异数据且owner一致", "16 bank至四个128-bit block的选择逐bit匹配"),
    Feature("SQ/WMB forward merge", "tc_da_forward_merge", "CHK_DA_FP02_FORWARD", "COV_DA_FP02_FORWARD", "P0", ("ldc_lda_ex2_inst_vld", "ldc_lda_ex2_fwd_sq_vld", "ldc_lda_ex2_fwd_wmb_vld", "sq_lda_ex2_fwd_data", "wmb_lda_fwd_data"), ("lda_rb_ex3_data_ori", "lda_ex3_fwd_ecc_stall"), "当 `ldc_lda_ex2_fwd_sq_vld=1` 或 `ldc_lda_ex2_fwd_wmb_vld=1` 时", "则 `lda_rb_ex3_data_ori` 按byte mask合并选定source且未覆盖byte保持cache数据", "SQ-only、WMB-only、冲突和无forward均使用互异花纹"),
    Feature("ECC检测与replay", "tc_da_ecc_replay", "CHK_DA_FP03_ECC", "COV_DA_FP03_ECC", "P0", ("ldc_lda_ex2_inst_vld", "cp0_lsu_ecc_en", "dcache_lsu_ld_data_bank0_dout"), ("lda_ex2_ecc_stall", "lda_ex3_ecc_wakeup", "lda_rb_ex3_ecc_mask"), "当 `cp0_lsu_ecc_en=1` 且选中bank注入单比特或双比特错误时", "则可纠错错误更新数据，fatal错误使 `lda_ex2_ecc_stall=1` 并产生唯一replay/wakeup", "无错、单错、双错和连续错误均有明确终态"),
    Feature("延迟MMU access fault", "tc_da_access_fault", "CHK_DA_FP04_ACCESS_FAULT", "COV_DA_FP04_ACCESS_FAULT", "P0", ("ldc_lda_ex2_inst_vld", "mmu_lsu_access_fault0", "ldc_lda_ex2_expt_access_fault_mask"), ("lda_lwb_ex3_expt_vld", "lda_rb_ex3_expt_vld"), "当live EX3 owner对应的 `mmu_lsu_access_fault0=1` 时", "则 `lda_lwb_ex3_expt_vld=1` 或RB异常路径有效，且mtval/IID仍属于原owner", "0/1/N拍fault不串到下一owner"),
    Feature("LQ entry pop", "tc_da_lq_pop", "CHK_DA_FP05_LQ_POP", "COV_DA_FP05_LQ_POP", "P0", ("ldc_lda_ex2_inst_vld", "ldc_lda_ex2_lq_entry", "ldc_lda_ex2_spec_fail"), ("lda_ex3_lq_entry_pop", "lda_idu_ex3_pop_vld", "lda_idu_ex3_pop_entry"), "当 `ldc_lda_ex2_inst_vld=1` 到达唯一终态且无需restart时", "则 `lda_ex3_lq_entry_pop` 只包含原LQ entry且 `lda_idu_ex3_pop_vld=1`", "LQ pop每个owner恰好一次，flush/restart为零次"),
    Feature("RB create与merge", "tc_da_rb_create_merge", "CHK_DA_FP06_RB_OWNER", "COV_DA_FP06_RB", "P0", ("ldc_lda_ex2_inst_vld", "rb_lda_ex3_full", "rb_lda_ex3_hit_idx"), ("lda_rb_ex3_create_vld", "lda_rb_ex3_merge_vld", "lda_rb_ex3_create_lfb"), "当 `ldc_lda_ex2_inst_vld=1` 且RB非full时", "则miss产生唯一 `lda_rb_ex3_create_vld=1`，命中产生 `lda_rb_ex3_merge_vld=1`，两者互斥", "RB create/merge winner与payload owner一致"),
    Feature("WB completion请求", "tc_da_completion", "CHK_DA_FP07_COMPLETION", "COV_DA_FP07_COMPLETION", "P0", ("ldc_lda_ex2_inst_vld", "ldc_lda_ex2_expt_vld_except_access_err", "rb_lda_ex3_full"), ("lda_lwb_ex3_cmplt_req", "lda_lwb_ex3_cmplt_req_gate"), "当 `ldc_lda_ex2_inst_vld=1` 的load在DA到达completion终态时", "则 `lda_lwb_ex3_cmplt_req=1` 必须伴随 `lda_lwb_ex3_cmplt_req_gate=1` 且只脉冲一次", "completion与RB create、restart终态互斥"),
    Feature("WB scalar/vector data请求", "tc_da_data_request", "CHK_DA_FP08_DATA_REQ", "COV_DA_FP08_DATA", "P0", ("ldc_lda_ex2_inst_vld", "ldc_lda_ex2_inst_vls", "ldc_lda_ex2_inst_us"), ("lda_lwb_ex3_data_req", "lda_lwb_ex3_data_req_dp", "lda_lwb_ex3_data", "lda_lwb_ex3_data1", "lda_lwb_ex3_data2", "lda_lwb_ex3_data3"), "当无异常且 `ldc_lda_ex2_inst_vld=1` 的owner命中数据时", "则 `lda_lwb_ex3_data_req=1` 蕴含DP/gate有效，scalar只用data0，US检查四块互异数据", "数据请求、mask和owner元数据同拍一致"),
    Feature("异常restart唯一终态", "tc_da_terminal_state", "CHK_DA_FP09_TERMINAL", "COV_DA_FP09_TERMINAL", "P0", ("ldc_lda_ex2_inst_vld", "ldc_lda_ex2_spec_fail", "rb_lda_ex3_full"), ("lda_lwb_ex3_expt_vld", "lda_idu_ex3_pop_vld", "lda_rb_ex3_create_vld"), "当 `ldc_lda_ex2_inst_vld=1` 且异常、spec-fail或RB full条件命中时", "则completion、RB create、LQ pop、restart中恰有一个唯一终态，`lda_lwb_ex3_expt_vld` 仅随异常owner", "所有两两交叉无双重副作用"),
    Feature("LFB/LRQ dependency wakeup", "tc_da_dependency", "CHK_DA_FP10_WAKEUP", "COV_DA_FP10_WAKEUP", "P0", ("ldc_lda_ex2_inst_vld", "ldc_lda_ex2_lsid", "ldc_lda_ex2_spec_fail"), ("lda_lfb_set_wakeup_queue", "lda_lfb_ex3_wakeup_queue_next", "lda_idu_ex3_already_da"), "当 `ldc_lda_ex2_inst_vld=1` 的owner产生LFB依赖或DA反馈时", "则 `lda_lfb_set_wakeup_queue` 和LRQ bitmap只包含保存LSID且每个事件一次", "flush后零次迟到wakeup，entry复用不串owner"),
    Feature("debug halt-info副作用", "tc_da_debug", "CHK_DA_FP11_DEBUG", "COV_DA_FP11_DEBUG", "P1", ("ldc_lda_ex2_inst_vld", "dtu_lsu_addr_halt_info", "dtu_lsu_data_trig_en"), ("ld_da_idu_halt_info_update_vld", "ld_da_idu_halt_info", "ld_da_dtu_addr_halt_info_stall_vld"), "当 `dtu_lsu_data_trig_en=1` 命中live owner时", "则 `ld_da_idu_halt_info_update_vld` 仅更新该owner，cancel/flush后不产生迟到副作用", "halt-info、IID和触发类型三者一致"),
    Feature("flush与clock边界", "tc_da_flush_clock", "CHK_DA_FP12_FLUSH_CLOCK", "COV_DA_FP12_CLOCK", "P1", ("ldc_lda_ex2_inst_vld", "rtu_lsu_flush_fe", "cp0_lsu_icg_en"), ("lda_ex3_inst_vld", "lda_ex3_special_gateclk_en"), "当 `rtu_lsu_flush_fe=1` 或reset命中live DA owner时", "则下一拍 `lda_ex3_inst_vld=0`，ICG/scan只改变clock可达性而不改变功能owner", "flush后completion/data/RB/LQ副作用均为零"),
)


WB_FEATURES = (
    Feature("DA/RB completion仲裁", "tc_wb_completion_arb", "CHK_WB_FP01_CMPLT_ARB", "COV_WB_FP01_CMPLT", "P0", ("lda_lwb_ex3_cmplt_req", "rb_lwb_ex3_cmplt_req", "lda_lwb_ex3_cmplt_req_gate"), ("lwb_rb_ex3_cmplt_grnt", "lsu_rtu_ex4_cmplt"), "当 `lda_lwb_ex3_cmplt_req=1` 与 `rb_lwb_ex3_cmplt_req=1` 同拍竞争时", "则completion winner唯一，`lwb_rb_ex3_cmplt_grnt` 仅在RB获胜时为1且loser保持", "固定优先级和持续请求均不会丢失completion"),
    Feature("DA/WMB/VMB/RB data仲裁", "tc_wb_data_arb", "CHK_WB_FP02_DATA_ARB", "COV_WB_FP02_DATA", "P0", ("lda_lwb_ex3_data_req", "wmb_lwb_data_req", "vmb_lwb_data_req", "rb_lwb_ex3_data_req"), ("lwb_ex4_data_vld", "lwb_rb_ex3_data_grnt", "lwb_wmb_ex3_data_grnt", "ld_wb_vmb_data_grnt"), "当 `lda_lwb_ex3_data_req`、WMB、VMB、RB请求任意组合且至少一个为1时", "则 `lwb_ex4_data_vld=1` 且三个显式grant至多一个，winner payload唯一", "四源互异数据、持续竞争和轮换空闲lane不会丢失"),
    Feature("req DP gate合同", "tc_wb_req_contract", "CHK_WB_FP03_REQ_DP_GATE", "COV_WB_FP03_REQ", "P0", ("lda_lwb_ex3_data_req", "lda_lwb_ex3_data_req_dp", "lda_lwb_ex3_data_req_gateclk_en"), ("lwb_ex4_data_vld", "lwb_ex4_inst_vld"), "当 `lda_lwb_ex3_data_req=1` 时必须同时满足DP和gate合同", "则req=1蕴含DP=1和gate=1；DP-only只可预开数据路径且 `lwb_ex4_data_vld=0`", "req-only、DP-only、gate-only及全部有效四种组合均覆盖"),
    Feature("scalar PREG格式化", "tc_wb_scalar", "CHK_WB_FP04_SCALAR", "COV_WB_FP04_SCALAR", "P0", ("lda_lwb_ex3_data_req", "lda_ex3_preg", "lda_lwb_ex3_data", "lda_lwb_ex3_preg_sign_sel"), ("lsu_idu_ex4_preg_vld", "lsu_idu_ex4_preg", "lsu_idu_ex4_preg_data"), "当scalar `lda_lwb_ex3_data_req=1` 被仲裁接受时", "则 `lsu_idu_ex4_preg_vld=1` 且PREG、符号扩展数据属于同一DA owner", "byte/half/word/dword和正负符号边界逐bit检查"),
    Feature("vector VR0/VR1/FR格式化", "tc_wb_vector", "CHK_WB_FP05_VECTOR", "COV_WB_FP05_VECTOR", "P0", ("lda_lwb_ex3_data_req", "lda_ex3_inst_vfls", "lda_ex3_vreg", "lda_lwb_ex3_vreg_sign_sel"), ("lsu_idu_ex4_vreg_vld", "lsu_idu_ex4_vreg_vr0_data", "lsu_idu_ex4_vreg_vr1_data", "lsu_idu_ex4_vreg_fr_data"), "当vector或FP `lda_lwb_ex3_data_req=1` 被接受时", "则VR0、VR1、FR中只有适用通道valid且 `lsu_idu_ex4_vreg_vld=1`", "vmew、split、FR/VR选择和互异数据花纹全部覆盖"),
    Feature("RTU completion与exception", "tc_wb_rtu", "CHK_WB_FP06_RTU", "COV_WB_FP06_RTU", "P0", ("lda_lwb_ex3_cmplt_req", "lda_ex3_iid", "lda_lwb_ex3_expt_vld"), ("lsu_rtu_ex4_cmplt", "lsu_rtu_ex4_iid", "lsu_rtu_ex4_expt_vld"), "当 `lda_lwb_ex3_cmplt_req=1` 携带IID和异常元数据时", "则 `lsu_rtu_ex4_cmplt=1`、IID精确匹配且exception只对异常owner有效", "completion每个owner一次且异常/正常元数据互斥"),
    Feature("bus error数据抑制", "tc_wb_bus_error", "CHK_WB_FP07_BUS_ERROR", "COV_WB_FP07_BUS_ERROR", "P0", ("rb_lwb_ex3_data_req", "rb_lwb_ex3_bus_err", "rb_lwb_ex3_bus_err_addr"), ("lsu_rtu_async_expt_vld", "lsu_rtu_async_expt_addr", "lsu_idu_ex4_preg_vld"), "当 `rb_lwb_ex3_bus_err=1` 随RB data request到达时", "则 `lsu_rtu_async_expt_vld=1` 且地址匹配，同时正常 `lsu_idu_ex4_preg_vld=0`", "错误数据零次进入架构寄存器"),
    Feature("VMB completion与merge", "tc_wb_vmb", "CHK_WB_FP08_VMB", "COV_WB_FP08_VMB", "P0", ("vmb_lwb_data_req", "vmb_lwb_vmb_merge_vld", "vmb_lwb_vreg", "vmb_lwb_data"), ("ld_wb_vmb_data_grnt", "ld_wb_vmb_data_merge_vld", "ld_wb_vmb_data_vmb_id", "ld_wb_vmb_cmplt_vld"), "当 `vmb_lwb_data_req=1` 或VMB completion被接受时", "则 `ld_wb_vmb_data_grnt`、merge、VMB ID和FOF/completion元数据来自同一owner", "merge/non-merge与data/completion交叉无ID串项"),
    Feature("debug halt-info自清", "tc_wb_debug", "CHK_WB_FP09_DEBUG", "COV_WB_FP09_DEBUG", "P1", ("rb_lwb_ex3_data_req", "rb_ld_wb_data_check", "rb_ld_wb_data_halt_info"), ("rb_entry_data_halt_info_update_vld", "lsu_dtu_data_vld", "lsu_dtu_data_halt_info"), "当 `rb_ld_wb_data_check=1` 随RB owner进入WB时", "则 `rb_entry_data_halt_info_update_vld` 只命中该entry且debug data valid为单拍", "更新后自清，下一owner不会继承旧halt-info"),
    Feature("EX4 forward winner", "tc_wb_forward", "CHK_WB_FP10_FORWARD", "COV_WB_FP10_FORWARD", "P1", ("lda_lwb_ex3_data_req", "wmb_lwb_data_req", "vmb_lwb_data_req", "rb_lwb_ex3_data_req"), ("lsu_idu_ex4_fwd_vreg_vld", "lsu_idu_ex4_fwd_vreg", "lwb_ex4_data_vld"), "当 `lda_lwb_ex3_data_req=1` 或其他data source赢得WB仲裁且目标为vector时", "则 `lsu_idu_ex4_fwd_vreg_vld=1` 且forward寄存器只来自实际winner", "loser payload变化不得影响EX4 bypass"),
    Feature("check flush取消年轻owner", "tc_wb_flush", "CHK_WB_FP11_FLUSH", "COV_WB_FP11_FLUSH", "P0", ("lda_lwb_ex3_cmplt_req", "rtu_ck_flush", "rtu_ck_flush_iid", "lda_ex3_iid"), ("lwb_ex4_inst_vld", "lsu_rtu_ex4_cmplt", "lwb_ex4_data_vld"), "当 `rtu_ck_flush=1` 且flush IID年龄命中当前owner时", "则 `lwb_ex4_inst_vld=0`、completion/data valid均不产生；未命中owner保留", "IID wrap和full/check flush边界均覆盖"),
    Feature("completion/data clock reset", "tc_wb_clock_reset", "CHK_WB_FP12_CLOCK_RESET", "COV_WB_FP12_CLOCK", "P1", ("lda_lwb_ex3_data_req", "cp0_lsu_icg_en", "pad_yy_icg_scan_en"), ("lwb_ex4_data_vld", "lwb_ex4_inst_vld"), "当 `cp0_lsu_icg_en=0`、scan=1且合法请求到达时", "则scan允许捕获，reset低时 `lwb_ex4_data_vld=0` 且所有架构valid为0", "ICG on/off/scan和reset释放首拍无幽灵写回"),
)


RB_FEATURES = (
    Feature("容量、保留项与create资格", "tc_rb_capacity", "CHK_RB_FP01_CAPACITY", "COV_RB_FP01_CAPACITY", "P0", ("lda0_rb_ex3_create_vld", "lda0_rb_ex3_create_judge_vld", "lda0_ex3_iid"), ("rb_lda0_ex3_full", "lsu0_idu_exx_rb_not_full", "rb_empty"), "当 `lda0_rb_ex3_create_vld=1` 且存在可用entry时", "则 `rb_lda0_ex3_full=0` 且create只占用一个entry", "scoreboard为每次分配记录entry、IID和generation，保留项不被普通create占用"),
    Feature("三路create仲裁与payload winner", "tc_rb_create_arb", "CHK_RB_FP02_CREATE_ARB", "COV_RB_FP02_CREATE", "P0", ("lda0_rb_ex3_create_vld", "lsda0_rb_ex3_create_vld", "lsda1_rb_ex3_create_vld"), ("rb_lda0_ex3_full", "rb_lsda0_ex3_full", "rb_lsda1_ex3_full"), "当LD0、LS0和LS1 create同拍竞争时", "则仲裁只接受可用entry数量允许的owner且每个payload保持原IID", "三路payload使用互异IID和地址，winner与entry映射唯一"),
    Feature("entry状态机与响应终态", "tc_rb_entry_lifecycle", "CHK_RB_FP03_LIFECYCLE", "COV_RB_FP03_LIFECYCLE", "P0", ("lda0_rb_ex3_create_vld", "bus_arb_rb_ar_grnt", "biu_lsu_r_vld"), ("rb_biu_ar_req", "rb_lwb_ex3_data_req", "rb_empty"), "当create被接受后BIU grant和R response依次到达时", "则entry按create、request、response、WB顺序推进且每个终态一次", "entry复用前generation递增，迟到响应不得命中新owner"),
    Feature("同line merge与boundary", "tc_rb_merge", "CHK_RB_FP04_MERGE", "COV_RB_FP04_MERGE", "P0", ("lda0_rb_ex3_merge_vld", "lda0_ex3_boundary_after_mask", "lda0_ex3_addr"), ("rb_lda0_ex3_hit_idx", "rb_lda0_ex3_merge_fail"), "当 `lda0_rb_ex3_merge_vld=1` 且地址命中已有cache line时", "则hit_idx有效；跨boundary或不兼容属性时merge_fail有效且不污染旧payload", "same-line、different-line、boundary-first和boundary-second全部交叉"),
    Feature("BIU AR请求属性与ID", "tc_rb_biu_ar", "CHK_RB_FP05_BIU_AR", "COV_RB_FP05_BIU_AR", "P0", ("lda0_rb_ex3_create_vld", "bus_arb_rb_ar_grnt", "lfb_addr_full"), ("rb_biu_ar_req", "rb_biu_ar_id", "rb_biu_ar_addr", "rb_biu_ar_len"), "当可请求entry成为BIU owner且LFB非full时", "则 `rb_biu_ar_req=1`，AR地址、长度、属性和BIU ID都属于同一entry", "grant前请求稳定，grant后每个entry只发一次AR"),
    Feature("LFB create与依赖ID", "tc_rb_lfb_create", "CHK_RB_FP06_LFB", "COV_RB_FP06_LFB", "P0", ("lda0_rb_ex3_create_vld", "lda0_rb_ex3_create_lfb", "lfb_rb_create_id"), ("rb_lfb_create_vld", "rb_lfb_create_req", "rb_lfb_addr_tto4"), "当RB owner要求linefill且LFB可接受时", "则LFB create valid、地址和BIU ID属于同一RB owner", "LFB full/hit/grant交叉不重复创建且依赖wakeup不串entry"),
    Feature("R response两拍与错误归属", "tc_rb_r_response", "CHK_RB_FP07_R_RESPONSE", "COV_RB_FP07_R", "P0", ("biu_lsu_r_vld", "biu_lsu_r_id", "biu_lsu_r_resp", "biu_lsu_r_data"), ("rb_lwb_ex3_data_req", "rb_lwb_ex3_bus_err", "rb_lwb_ex3_data_iid"), "当匹配BIU ID的unit-stride R response到达时", "则恰好两拍数据按同一entry组装；错误响应只标记原owner并抑制正常完成", "0/1/N拍响应、错误beat和entry立即复用均以BIU ID及generation判定"),
    Feature("B response与atomic owner", "tc_rb_b_response", "CHK_RB_FP08_B_RESPONSE", "COV_RB_FP08_B", "P0", ("biu_lsu_b_vld", "biu_lsu_b_id", "lda0_rb_ex3_atomic"), ("rb_lwb_ex3_cmplt_req", "rb_lwb_ex3_iid", "rb_lwb_ex3_expt_vld"), "当atomic或store相关entry收到匹配的B response时", "则completion、exception和IID只归属于原entry owner", "B response按BIU ID配对，迟到或重复B不得命中已复用entry"),
    Feature("SO ID FIFO与pending", "tc_rb_so_fifo", "CHK_RB_FP09_SO_FIFO", "COV_RB_FP09_SO", "P1", ("lda0_rb_ex3_create_vld", "lda0_ex3_page_so", "biu_lsu_r_vld"), ("rb_wmb_so_pending", "rb_has_pend", "rb_pend_addr_f"), "当strong-order entry创建并等待响应时", "则SO FIFO按请求顺序维护ID且pending地址属于队首owner", "FIFO empty/full、连续push/pop和response同拍不丢ID"),
    Feature("WB completion与data grant", "tc_rb_wb", "CHK_RB_FP10_WB", "COV_RB_FP10_WB", "P0", ("lwb_rb_ex3_cmplt_grnt", "lwb_rb_ex3_data_grnt", "biu_lsu_r_vld"), ("rb_lwb_ex3_cmplt_req", "rb_lwb_ex3_data_req", "rb_lwb_ex3_data"), "当响应完成的entry请求WB且grant到达时", "则completion/data请求保持到grant，winner数据和IID来自同一entry", "completion与data独立反压，任一grant不会清除另一未完成请求"),
    Feature("同步与异步flush", "tc_rb_flush", "CHK_RB_FP11_FLUSH", "COV_RB_FP11_FLUSH", "P0", ("lda0_rb_ex3_create_vld", "rtu_yy_xx_flush", "rtu_lsu_async_flush"), ("rb_biu_ar_req", "rb_lwb_ex3_cmplt_req", "rb_lfb_create_vld"), "当live entry遇到sync flush或async flush时", "则可取消owner不再发出新的BIU、LFB或WB副作用；不可取消事务仍按协议收尾", "sync flush、async flush与check flush分别验证，迟到响应不得复活已清entry"),
    Feature("entry门控时钟与reset", "tc_rb_clock_reset", "CHK_RB_FP12_CLOCK_RESET", "COV_RB_FP12_CLOCK", "P1", ("lda0_rb_ex3_create_vld", "cp0_lsu_icg_en", "pad_yy_icg_scan_en"), ("rb_empty", "rb_biu_ar_req", "rb_lwb_ex3_data_req"), "当ICG关闭、scan开启或reset施加在create边界时", "则scan允许状态捕获，reset后RB为空且所有请求为0", "所有entry gate、pointer gate和special clock边界无X或幽灵owner"),
)


LRQ_FEATURES = (
    Feature("三bank容量与no-space预检", "tc_lrq_capacity", "CHK_LRQ_FP01_CAPACITY", "COV_LRQ_FP01_CAPACITY", "P0", ("lsu0_lrq_create_vld", "lsu2_lrq_create_vld", "lsu3_lrq_create_vld"), ("lrq_lsu0_ex1_lrqid", "lrq_lsu2_ex1_lrqid", "lrq_lsu3_ex1_lrqid"), "当三bank `lsu0_lrq_create_vld=1` 等create请求到达时", "则每个被接受bank只选择一个one-hot LRQ entry，no-space bank不建立owner", "empty、one-left、full和同拍pop以{bank,entry,IID,generation}计数"),
    Feature("create资格与flush取消", "tc_lrq_create_accept", "CHK_LRQ_FP02_CREATE_ACCEPT", "COV_LRQ_FP02_CREATE", "P0", ("lsu0_lrq_create_vld", "rtu_lsu_flush_fe", "lsu0_lrq_create_iid"), ("lrq_lsu0_rf_replay_vld", "lrq_lsu0_ex1_lrqid"), "当 `lsu0_lrq_create_vld=1` 与full或flush边界交叉时", "则仅合格create建立entry；flush取消时create_success=0且不产生raw-pop副作用", "create_vld=1不等于成功，失败原因必须可归因于flush或no-space"),
    Feature("fresh payload保存", "tc_lrq_payload", "CHK_LRQ_FP03_PAYLOAD", "COV_LRQ_FP03_PAYLOAD", "P0", ("lsu0_lrq_create_vld", "lsu0_lrq_create_va", "lsu0_lrq_create_iid", "lsu0_lrq_create_bytes_vld"), ("lrq_lsu0_rf_va", "lrq_lsu0_rf_iid", "lrq_lsu0_rf_bytes_vld"), "当fresh `lsu0_lrq_create_vld=1` 被接受并等待N拍后replay时", "则VA、IID、mask及适用vector字段逐bit等于create payload", "所有字段使用互异花纹，等待期间owner payload稳定"),
    Feature("freeze原因集合", "tc_lrq_freeze", "CHK_LRQ_FP04_FREEZE", "COV_LRQ_FP04_FREEZE", "P0", ("lsu0_lrq_create_frz", "lsu0_lrq_create_wait_old_chk", "lsu0_lrq_exx_tlb_wakeup", "lsu0_lrq_ex3_rb_full"), ("lrq_lsu0_rf_replay_vld", "lrq_lsu0_rf_sel"), "当 `lsu0_lrq_create_frz=1` 或MMU、barrier、no-spec、LQ/SQ/RB原因仍有效时", "则entry不得issue；只有全部必要原因解除后 `lrq_lsu0_rf_replay_vld=1`", "每种freeze原因单独及两两组合，解除顺序不改变owner"),
    Feature("wakeup owner与generation", "tc_lrq_wakeup", "CHK_LRQ_FP05_WAKEUP_OWNER", "COV_LRQ_FP05_WAKEUP", "P0", ("lsu0_lrq_exx_tlb_wakeup", "lsu0_lrq_frz_clr", "lsu0_lrq_create_iid"), ("lrq0_idu_exx_wakeup", "lrq_lsu0_rf_replay_vld"), "当MMU/LFB/SQ/WMB wakeup bitmap命中LRQ bit时", "则wakeup只作用于仍valid且generation匹配的entry；旧 owner wakeup不得修改entry复用后的新owner", "live、killed、已释放和立即复用四类bit均覆盖"),
    Feature("oldest ready issue", "tc_lrq_oldest_issue", "CHK_LRQ_FP06_OLDEST", "COV_LRQ_FP06_OLDEST", "P0", ("idu_lsu_old_vld", "idu_lsu_old_iid", "lsu0_lrq_create_iid"), ("lrq_lsu0_rf_replay_vld", "lrq_lsu0_rf_iid", "lrq_lsu0_rf_older_vld"), "当多个ready entry竞争且 `idu_lsu_old_vld=1` 时", "则软件age模型认定的最老IID成为唯一replay winner", "普通排序、IID wrap、equal边界和三bank同拍ready均检查one-hot grant"),
    Feature("replay RF mux与零重建", "tc_lrq_replay", "CHK_LRQ_FP07_REPLAY", "COV_LRQ_FP07_REPLAY", "P0", ("lsu0_lrq_create_vld", "lsu0_lrq_create_boundary", "lsu0_lrq_create_unit_stride"), ("lrq_lsu0_rf_replay_vld", "lrq_lsu0_rf_boundary", "lrq_lsu0_rf_unit_stride"), "当保存的scalar、boundary、vector或US owner被选择replay时", "则RF mux payload属于该entry，replay拍不得再次建立LRQ create", "replay payload不受当前IDU互异输入污染且每个owner只issue一次"),
    Feature("no-spec与barrier释放", "tc_lrq_barrier", "CHK_LRQ_FP08_BARRIER", "COV_LRQ_FP08_BARRIER", "P1", ("lsu0_lrq_create_no_spec_chk", "lsu0_lrq_create_bar_chk", "idu_lsu0_rf_no_spec_exist"), ("lrq0_hit_no_spec_tbl", "lrq_lsu0_rf_no_spec_exist", "lrq_lsu0_rf_replay_vld"), "当entry带no-spec或barrier检查且前序条件仍存在时", "则不得过早replay；前序条件消失后唯一owner解除freeze", "多bank年龄交叉、逐拍释放和无永久freeze均覆盖"),
    Feature("DA反馈与entry复用", "tc_lrq_da_feedback", "CHK_LRQ_FP09_DA_FEEDBACK", "COV_LRQ_FP09_DA", "P0", ("lsu0_lrq_ex3_secd", "lsu0_lrq_ex3_already_da", "lsu0_lrq_ex3_spec_fail"), ("lrq_lsu0_rf_already_da", "lrq_lsu0_rf_spec_fail", "lrq0_idu_ex3_pop_vld"), "当DA的secd、already-DA、spec-fail或pop反馈命中live bit时", "则只更新匹配generation的owner；旧反馈零次修改entry复用后的新owner", "反馈与flush、pop、create同拍时按{bank,entry,IID,generation}判定"),
    Feature("full/check flush年龄清除", "tc_lrq_flush", "CHK_LRQ_FP10_FLUSH", "COV_LRQ_FP10_FLUSH", "P0", ("lsu0_lrq_create_vld", "rtu_lsu_flush_fe", "rtu_ck_flush", "rtu_ck_flush_iid"), ("lrq_lsu0_rf_replay_vld", "lrq_lsu0_ex1_lrqid", "lrq0_idu_exx_wakeup"), "当full flush或check flush命中live entry时", "则full flush清全部，check flush仅清更年轻未提交owner，killed entry不再replay或wakeup", "IID older/equal/newer及wrap与create/wakeup/issue边界交叉"),
    Feature("entry clock reset", "tc_lrq_clock_reset", "CHK_LRQ_FP11_CLOCK_RESET", "COV_LRQ_FP11_CLOCK", "P1", ("lsu0_lrq_create_vld", "cp0_lsu_icg_en", "pad_yy_icg_scan_en"), ("lrq_lsu0_rf_replay_vld", "lrq_lsu0_ex1_lrqid"), "当ICG关闭、scan开启或reset命中entry更新边界时", "则功能valid打开相应数据钟，reset后valid与replay为0", "valid gate与data gate一致，reset释放首拍无幽灵owner"),
    Feature("LRQENTRY与LSIQENTRY参数合同", "tc_lrq_parameter_contract", "CHK_LRQ_FP12_PARAMETER", "COV_LRQ_FP12_PARAMETER", "P2", ("lsu0_lrq_create_vld", "lsu0_lrq_pop_entry"), ("lrq_lsu0_ex1_lrqid", "lrq0_idu_exx_wakeup"), "当正式配置下 `lsu0_lrq_create_vld=1` 并使用LRQ/LSIQ bitmap时", "则 `LRQENTRY=LSIQENTRY` 的elaboration合同成立且bitmap无静默截断", "正式相等配置必须通过；故意不等宽配置要求静态assert明确失败"),
)


CONFIGS = {
    "xx_lsu_ld_dc": Environment(
        name="xx_lsu_ld_dc",
        prefix="DC",
        source="srcs/xx_lsu_ld_dc.sv",
        feature_doc="doc-dc/xx_lsu_ld_dc_feature_test_plan.md",
        runbook="doc-dc/xx_lsu_ld_dc_vcs_verification.md",
        clock="forever_cpuclk",
        reset="cpurst_b",
        flush="rtu_lsu_flush_fe",
        parameters={"VB_DATA_ENTRY": 3, "LQENTRY": 48, "LSIQENTRY": 12, "VMBENTRY": 8, "PC_LEN": 15, "IID_WIDTH": 7, "VREG": 6, "PREG": 7},
        idle_overrides={"ctrl_ld_clk": None, "cp0_lsu_icg_en": "1'b1", "cp0_lsu_dcache_en": "1'b1", "lsu_dcache_ld_xx_gwen": "'1"},
        declared_stubs=("gated_clk_cell", "xx_lsu_compare_iid"),
        production_sources=(),
        features=DC_FEATURES,
    ),
    "xx_lsu_ld_da": Environment(
        name="xx_lsu_ld_da",
        prefix="DA",
        source="srcs/xx_lsu_ld_da.sv",
        feature_doc="doc-da/xx_lsu_ld_da_feature_test_plan.md",
        runbook="doc-da/xx_lsu_ld_da_vcs_verification.md",
        clock="forever_cpuclk",
        reset="cpurst_b",
        flush="rtu_lsu_flush_fe",
        parameters={"VB_DATA_ENTRY": 3, "LQENTRY": 48, "LSIQENTRY": 12, "SQ_ENTRY": 12, "WMB_ENTRY": 8, "VMB_ENTRY": 8, "PC_LEN": 15, "IID_WIDTH": 7, "VREG": 6, "PREG": 7},
        idle_overrides={"ctrl_ld_clk": None, "lsu_special_clk": None, "cp0_lsu_icg_en": "1'b1", "cp0_lsu_dcache_en": "1'b1", "cp0_lsu_ecc_en": "1'b1"},
        declared_stubs=("gated_clk_cell", "xx_lsu_compare_iid", "xx_lsu_rot_data", "xx_lsu_27bit_2stage_ecc_decode", "xx_lsu_32bit_ecc_decode", "xx_lsu_35bit_2stage_ecc_decode"),
        production_sources=(),
        features=DA_FEATURES,
        doc_tokens=("- 四块互异数据用于验证data0/data1/data2/data3不串区。", "- completion、RB create、LQ pop、restart必须形成唯一终态。"),
    ),
    "xx_lsu_ld_wb": Environment(
        name="xx_lsu_ld_wb",
        prefix="WB",
        source="srcs/xx_lsu_ld_wb.sv",
        feature_doc="doc-wb/xx_lsu_ld_wb_feature_test_plan.md",
        runbook="doc-wb/xx_lsu_ld_wb_vcs_verification.md",
        clock="forever_cpuclk",
        reset="cpurst_b",
        flush="rtu_yy_xx_flush",
        parameters={"RBENTRY": 16, "SQ_ENTRY": 12, "VMB_ENTRY": 8, "IID_WIDTH": 7, "VREG": 6, "PREG": 7, "PREG_N": 96},
        idle_overrides={"ctrl_ld_clk": None, "cp0_lsu_icg_en": "1'b1"},
        declared_stubs=("gated_clk_cell", "xx_lsu_compare_iid"),
        production_sources=(),
        features=WB_FEATURES,
        doc_tokens=("- 请求蕴含链：req=1 时必须 DP=1 且 gate=1；DP-only只允许预开数据路径。", "- 持续请求可在任意空闲lane获得服务，完成和数据不会丢失。"),
    ),
    "xx_lsu_rb": Environment(
        name="xx_lsu_rb",
        prefix="RB",
        source="srcs/xx_lsu_rb.sv",
        feature_doc="doc-rb/xx_lsu_rb_feature_test_plan.md",
        runbook="doc-rb/xx_lsu_rb_vcs_verification.md",
        clock="forever_cpuclk",
        reset="cpurst_b",
        flush="rtu_yy_xx_flush",
        parameters={"IID_WIDTH": 7, "PREG": 7, "VREG": 7, "VMBENTRY": 8, "RBENTRY": 32},
        idle_overrides={"lsu_special_clk": None, "cp0_lsu_icg_en": "1'b1", "cp0_lsu_dcache_en": "1'b1"},
        declared_stubs=("gated_clk_cell", "xx_lsu_compare_iid", "xx_lsu_rb_data", "xx_lsu_encode", "xx_lsu_idfifo_32", "xx_lsu_pend_addr_sel_32", "xx_lsu_rot_data", "xx_lsu_rot_us_data"),
        production_sources=("srcs/xx_lsu_rb_entry.sv",),
        features=RB_FEATURES,
        doc_tokens=("- Scoreboard键为 `{entry, IID, generation, BIU ID, owner}`，entry复用必须递增generation。", "- unit-stride R response必须恰好两拍；B response必须按BIU ID与原owner配对。", "- sync flush、check flush与async flush分别验证，不把不可取消的总线事务误报为新副作用。"),
    ),
    "xx_lsu_lrq": Environment(
        name="xx_lsu_lrq",
        prefix="LRQ",
        source="srcs/xx_lsu_lrq.sv",
        feature_doc="doc-lrq/xx_lsu_lrq_feature_test_plan.md",
        runbook="doc-lrq/xx_lsu_lrq_vcs_verification.md",
        clock="forever_cpuclk",
        reset="cpurst_b",
        flush="rtu_lsu_flush_fe",
        parameters={"PREG": 7, "VREG": 6, "IID_WIDTH": 10, "VMBENTRY": 8, "LRQENTRY": 12, "PC_LEN": 15, "LSIQENTRY": 12, "SDIQENTRY": 12},
        idle_overrides={"lsu_special_clk": None, "cp0_lsu_icg_en": "1'b1"},
        declared_stubs=("gated_clk_cell", "xx_lsu_compare_iid"),
        production_sources=("srcs/xx_lsu_lrq_entry.sv",),
        features=LRQ_FEATURES,
        doc_tokens=("- create_vld=1只表示raw请求；与flush交叉时必须记录create_success=0。", "- Scoreboard按 `{bank, entry, IID, generation}` 跟踪旧 owner、entry复用和所有wakeup来源。"),
    ),
}


FEATURE_COLUMNS = (
    "feature_id", "feature", "testcase", "checker", "coverage", "priority", "closure", "result"
)


def _write(path: Path, text: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text.rstrip() + "\n", encoding="utf-8")


def _write_csv(path: Path, columns: tuple[str, ...], rows: list[dict[str, str]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="") as stream:
        writer = csv.DictWriter(stream, fieldnames=columns, quoting=csv.QUOTE_ALL, lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def _feature_rows(config: Environment) -> list[dict[str, str]]:
    return [
        {
            "feature_id": f"{config.prefix}-FP-{index:02d}",
            "feature": feature.title,
            "testcase": feature.testcase,
            "checker": feature.checker,
            "coverage": feature.coverage,
            "priority": feature.priority,
            "closure": feature.closure,
            "result": feature.result,
        }
        for index, feature in enumerate(config.features, 1)
    ]


def _scenario_variants(config: Environment, index: int, feature: Feature) -> list[dict[str, str]]:
    feature_id = f"{config.prefix}-FP-{index:02d}"
    primary_drive = feature.drive[0]
    primary_observe = feature.observe[0]
    common_observe = {
        "DC": "ldc_lda_ex2_inst_vld",
        "DA": "lda_ex3_inst_vld",
        "WB": "lwb_ex4_inst_vld",
        "RB": "rb_biu_ar_req",
        "LRQ": "lrq_lsu0_rf_replay_vld",
    }.get(config.prefix, primary_observe)
    templates = (
        ("名义accept", "复位释放、无flush且所有非目标输入idle", feature.drive, "C0: 驱动名义输入；C1: 采样目标输出", f"{feature.trigger}；触发信号 `{primary_drive}`", feature.observe, f"{feature.expected}；交付信号 `{primary_observe}`", feature.closure),
        ("连续两拍保持", "先建立同一owner并施加两拍合法反压", feature.drive, "C0: 建立owner；C1: 首次采样；C2: 保持输入再次采样", f"当 `{primary_drive}=1` 且同一owner连续保持两拍时", feature.observe, f"则 C1至C2 `{primary_observe}` 保持二态且只归属于同一owner", "两拍保持期间payload hash和owner均不漂移"),
        ("竞争与优先级", "目标请求与次级来源同拍，二者payload使用互异花纹", feature.drive, "C0: 同拍驱动竞争来源；C1: 采样winner；C2: 检查loser未被消费", f"当 `{primary_drive}=1` 与同级竞争条件同拍成立时", feature.observe, f"则 C1 `{primary_observe}` 只反映文档定义的winner且不含X", "winner唯一，loser payload零次误消费"),
        ("full flush交叉", "先建立live owner，再在转移边界施加full flush", tuple(dict.fromkeys((*feature.drive, config.flush))), "C0: 建立owner；C1: full flush=1；C2: 撤销后采样", f"当 `{primary_drive}=1` 与 `{config.flush}=1` 在owner窗口交叉时", tuple(dict.fromkeys((*feature.observe, common_observe))), f"则 C2 `{common_observe}=0` 且 `{primary_observe}` 不得产生被flush owner的新副作用", "flush后的completion/create/forward计数均不增加"),
        ("边界和延迟响应", "目标字段取全零、全一和边界花纹，响应分别延迟0/1/N拍", feature.drive, "C0: 驱动边界花纹；C1: 0拍采样；C2: 1拍采样；C3: N拍后采样", f"当 `{primary_drive}=1` 且目标payload取边界值时", feature.observe, f"则 C1至C3 `{primary_observe}` 仅在所属accept窗口有效且 `$isunknown({primary_observe})=0`", "0/1/N延迟与零/最大值交叉全部命中"),
        ("owner立即复用", "完成owner A后下一合法拍复用资源给互异owner B", tuple(dict.fromkeys((*feature.drive, "lag0_ex1_iid"))) if config.prefix == "DC" else feature.drive, "C0: 驱动owner A；C1: accept；C2: 驱动owner B；C3: 采样", f"当 `{primary_drive}=1` 的资源在下一合法拍被新owner复用时", feature.observe, f"则 C3 `{primary_observe}` 只对应owner B，旧owner不得迟到修改", "scoreboard generation递增且旧响应零次命中新owner"),
    )
    rows = []
    for scenario_index, item in enumerate(templates, 1):
        name, setup, drive, cycles, trigger, observe, expected, closure = item
        rows.append(
            {
                "scenario_id": f"{feature_id}-S{scenario_index:02d}",
                "feature_id": feature_id,
                "scenario": name,
                "testcase": feature.testcase,
                "priority": feature.priority,
                "setup": setup,
                "drive_signals": "|".join(drive),
                "cycle_sequence": cycles,
                "trigger_condition": trigger,
                "expected_signals": "|".join(observe),
                "expected_result": expected,
                "checker": feature.checker,
                "coverage": feature.coverage,
                "closure": closure,
                "result": feature.result,
            }
        )
    return rows


def _detail_rows(config: Environment) -> list[dict[str, str]]:
    return [
        row
        for index, feature in enumerate(config.features, 1)
        for row in _scenario_variants(config, index, feature)
    ]


def _manifest(config: Environment) -> dict[str, object]:
    return {
        "env_name": config.name,
        "dut_module": config.name,
        "dut_source": config.source,
        "feature_doc": config.feature_doc,
        "runbook": config.runbook,
        "feature_prefix": config.prefix,
        "expected_features": len(config.features),
        "min_scenarios_per_feature": 6,
        "clock": config.clock,
        "reset": config.reset,
        "parameters": dict(config.parameters),
        "idle_overrides": dict(config.idle_overrides),
        "production_sources": list(config.production_sources),
        "declared_stubs": list(config.declared_stubs),
        "stub_results": {name: "PENDING_FULL_CHIP" for name in config.declared_stubs},
    }


def _width(port: Port) -> str:
    return f" {port.width}" if port.width else ""


def _assertions(config: Environment, port_map: Mapping[str, Port]) -> str:
    header = [
        "`timescale 1ns/1ps",
        "",
        f"module {config.name}_assertions (",
        "  input logic clk,",
        "  input logic reset_n,",
    ]
    declarations = []
    connections = []
    for index, feature in enumerate(config.features, 1):
        qualify = port_map[feature.drive[0]]
        observe = port_map[feature.observe[0]]
        comma = "," if index < len(config.features) else ""
        declarations.extend(
            (
                f"  input logic{_width(qualify)} fp{index:02d}_qualify,",
                f"  input logic{_width(observe)} fp{index:02d}_observe{comma}",
            )
        )
        connections.append((index, feature))
    lines = header + declarations + [");", "", "  default clocking cb @(posedge clk); endclocking", "  default disable iff (!reset_n);", ""]
    for index, feature in connections:
        lines.extend(
            (
                f"  {feature.checker}:",
                f"    assert property ((|fp{index:02d}_qualify) |-> !$isunknown(fp{index:02d}_observe));",
                f"  {feature.coverage}:",
                f"    cover property ((|fp{index:02d}_qualify) ##1 !$isunknown(fp{index:02d}_observe));",
                "",
            )
        )
    lines.append("endmodule")
    return "\n".join(lines)


def _testbench(config: Environment, port_map: Mapping[str, Port]) -> str:
    parameter_lines = [
        f"    .{name} ({name})" for name in config.parameters
    ]
    parameter_connections = ",\n".join(parameter_lines)
    lines = [
        "`timescale 1ns/1ps",
        f"`include \"{config.name}_if.sv\"",
        "",
        f"module {config.name}_tb;",
    ]
    for name, value in config.parameters.items():
        lines.append(f"  localparam int {name} = {value};")
    lines.extend(("", f"  {config.name}_if #(\n{parameter_connections}\n  ) bus();", "", f"  {config.name} #(\n{parameter_connections}\n  ) dut (", f"`include \"{config.name}_connect.svh\"", "  );", "", f"  {config.name}_assertions checks (", f"    .clk (bus.{config.clock}),", f"    .reset_n (bus.{config.reset}),"))
    assertion_connections = []
    for index, feature in enumerate(config.features, 1):
        assertion_connections.extend(
            (
                f"    .fp{index:02d}_qualify (bus.{feature.drive[0]})",
                f"    .fp{index:02d}_observe (bus.{feature.observe[0]})",
            )
        )
    for index, connection in enumerate(assertion_connections):
        comma = "," if index + 1 < len(assertion_connections) else ""
        lines.append(connection + comma)
    lines.append("  );")
    for alias, value in config.idle_overrides.items():
        if value is None and alias in port_map and alias != config.clock and "clk" in alias:
            lines.append(f"  assign bus.{alias} = bus.{config.clock};")
    lines.extend(("", f"  initial bus.{config.clock} = 1'b0;", f"  always #5 bus.{config.clock} = ~bus.{config.clock};", "", "  task automatic tick(input int cycles = 1);", f"    repeat (cycles) begin @(posedge bus.{config.clock}); #1; end", "  endtask", "", "  task automatic expect_known(input logic value, input string label);", "    if ($isunknown(value)) $fatal(1, \"CHECK_FAIL: %s\", label);", "  endtask", "", "  task automatic apply_reset();", "    bus.drive_idle();", f"    bus.{config.reset} = 1'b0;", "    tick(3);", f"    bus.{config.reset} = 1'b1;", "    tick(1);", "  endtask", ""))
    for feature in config.features:
        lines.extend((f"  task automatic {feature.testcase}();", "    apply_reset();", f"    @(negedge bus.{config.clock});"))
        for signal in feature.drive:
            if signal in port_map and port_map[signal].direction == "input" and signal not in {config.clock, config.reset, "ctrl_ld_clk"}:
                lines.append(f"    bus.{signal} = '1;")
        lines.extend(("    tick(1);", f"    expect_known(^bus.{feature.observe[0]}, \"{feature.testcase}\");", "  endtask", ""))
    lines.extend(("  string selected_test;", "  initial begin", "    if (!$value$plusargs(\"TEST=%s\", selected_test)) selected_test = \"" + config.features[0].testcase + "\";", "    case (selected_test)"))
    for feature in config.features:
        lines.append(f"      \"{feature.testcase}\": {feature.testcase}();")
    lines.extend(("      default: $fatal(1, \"unknown TEST=%s\", selected_test);", "    endcase", "    $display(\"TEST_PASS %s static-harness execution\", selected_test);", "    $finish;", "  end", "", "endmodule"))
    return "\n".join(line for line in lines if line != "")


def _deps(config: Environment) -> str:
    blocks = ["`timescale 1ns/1ps", "", "// Standalone compatibility models; production replacement remains PENDING_FULL_CHIP."]
    if "gated_clk_cell" in config.declared_stubs:
        blocks.append("""module gated_clk_cell (
  input logic clk_in, input logic external_en, input logic local_en,
  input logic module_en, input logic pad_yy_icg_scan_en, output logic clk_out
);
  always_comb clk_out = clk_in & (pad_yy_icg_scan_en | (module_en & (external_en | local_en)));
endmodule""")
    if "xx_lsu_compare_iid" in config.declared_stubs:
        blocks.append("""module xx_lsu_compare_iid #(parameter int IID_WIDTH = 7) (
  input logic [IID_WIDTH-1:0] x_iid0, input logic [IID_WIDTH-1:0] x_iid1,
  output logic x_iid0_older
);
  logic [IID_WIDTH-1:0] distance;
  always_comb begin distance = x_iid1 - x_iid0; x_iid0_older = (x_iid0 != x_iid1) && !distance[IID_WIDTH-1]; end
endmodule""")
    if "xx_lsu_rot_data" in config.declared_stubs:
        blocks.append("""module xx_lsu_rot_data (
  input logic [127:0] data_in, input logic [15:0] rot_sel,
  output logic [127:0] data_settle_out
);
  always_comb data_settle_out = data_in;
endmodule""")
    if "xx_lsu_rot_us_data" in config.declared_stubs:
        blocks.append("""module xx_lsu_rot_us_data (
  input logic [127:0] data_in0, input logic [127:0] data_in1,
  input logic [127:0] data_in2, input logic [127:0] data_in3,
  input logic [5:0] rot_sel, output logic [127:0] data_out0,
  output logic [127:0] data_out1, output logic [127:0] data_out2,
  output logic [127:0] data_out3
);
  always_comb begin data_out0 = data_in0; data_out1 = data_in1; data_out2 = data_in2; data_out3 = data_in3; end
endmodule""")
    if "xx_lsu_encode" in config.declared_stubs:
        blocks.append("""module xx_lsu_encode #(parameter int RBENTRY = 32) (
  output logic [4:0] x_num, input logic [RBENTRY-1:0] x_num_expand
);
  integer i;
  always_comb begin x_num = '0; for (i = 0; i < RBENTRY; i = i + 1) if (x_num_expand[i]) x_num = i[4:0]; end
endmodule""")
    if "xx_lsu_idfifo_32" in config.declared_stubs:
        blocks.append("""module xx_lsu_idfifo_32 #(parameter int IDFIFO_ENTRY = 32) (
  input logic cp0_lsu_icg_en, input logic cpurst_b, input logic forever_cpuclk,
  input logic idfifo_clk_en, input logic [4:0] idfifo_create_id,
  input logic [IDFIFO_ENTRY-1:0] idfifo_create_id_oh, input logic idfifo_create_vld,
  output logic idfifo_empty, output logic [IDFIFO_ENTRY-1:0] idfifo_pop_id_oh,
  input logic idfifo_pop_vld, input logic pad_yy_icg_scan_en
);
  always_comb begin idfifo_empty = !idfifo_create_vld; idfifo_pop_id_oh = idfifo_create_id_oh; end
endmodule""")
    if "xx_lsu_pend_addr_sel_32" in config.declared_stubs:
        blocks.append("""module xx_lsu_pend_addr_sel_32 #(parameter int RBENTRY = 32) (
  input logic cp0_lsu_icg_en, input logic cpurst_b, input logic forever_cpuclk,
  input logic pad_yy_icg_scan_en, input logic [RBENTRY-1:0][`WK_PA_WIDTH-1:0] xxsource_entry_addr,
  input logic [RBENTRY-1:0] xxsource_entry_page_ca, input logic [RBENTRY-1:0] xxsource_entry_page_so,
  output logic xxsource_has_pend, output logic [`WK_PA_WIDTH-1:0] xxsource_pend_addr_f,
  output logic xxsource_pend_busy, input logic [RBENTRY-1:0] xxsource_pend_entry,
  output logic xxsource_pend_page_ca_f, output logic xxsource_pend_page_so_f
);
  always_comb begin xxsource_has_pend = |xxsource_pend_entry; xxsource_pend_busy = |xxsource_pend_entry; xxsource_pend_addr_f = '0; xxsource_pend_page_ca_f = 1'b0; xxsource_pend_page_so_f = 1'b0; end
endmodule""")
    if "xx_lsu_rb_data" in config.declared_stubs:
        blocks.append("""module xx_lsu_rb_data (
  input logic [127:0] entry_data, input logic [15:0] entry_bytes_vld,
  input logic entry_inst_us, input logic entry_boundary, input logic entry_wait_data_ff,
  input logic ld0_create_vld_ff, input logic ld0_merge_vld_ff, input logic ld0_boundary_ff,
  input logic ls0_create_vld_ff, input logic ls0_merge_vld_ff, input logic ls0_boundary_ff,
  input logic ls1_create_vld_ff, input logic ls1_merge_vld_ff, input logic ls1_boundary_ff,
  input logic [127:0] ld0_data_ori, input logic [127:0] ls0_data_ori,
  input logic [127:0] ls1_data_ori, input logic [127:0] biu_data_ori,
  output logic [127:0] merge_data, output logic [127:0] data_aft_rev,
  output logic [127:0] biu_data_updt
);
  always_comb begin merge_data = ld0_data_ori | ls0_data_ori | ls1_data_ori; data_aft_rev = entry_data; biu_data_updt = biu_data_ori; end
endmodule""")
    if "xx_lsu_27bit_2stage_ecc_decode" in config.declared_stubs:
        blocks.append("""module xx_lsu_27bit_2stage_ecc_decode (
  input logic cpurst_b, input logic [26:0] data_decode,
  input logic ecc_stage_vld, input logic stage_dp_clk,
  output logic [21:0] corrected_data, output logic ham_error,
  output logic parity_error
);
  always_comb begin corrected_data = data_decode[21:0]; ham_error = 1'b0; parity_error = 1'b0; end
endmodule""")
    if "xx_lsu_35bit_2stage_ecc_decode" in config.declared_stubs:
        blocks.append("""module xx_lsu_35bit_2stage_ecc_decode (
  input logic cpurst_b, input logic [34:0] data_decode,
  input logic ecc_stage_vld, input logic stage_dp_clk,
  output logic [28:0] corrected_data, output logic ham_error,
  output logic parity_error
);
  always_comb begin corrected_data = data_decode[28:0]; ham_error = 1'b0; parity_error = 1'b0; end
endmodule""")
    if "xx_lsu_32bit_ecc_decode" in config.declared_stubs:
        blocks.append("""module xx_lsu_32bit_ecc_decode (
  input logic [38:0] data_decode, output logic [31:0] corrected_data,
  output logic ham_error, output logic parity_error
);
  always_comb begin corrected_data = data_decode[31:0]; ham_error = 1'b0; parity_error = 1'b0; end
endmodule""")
    return "\n\n".join(blocks)


def _filelist(config: Environment) -> str:
    defines = (
        "TDT_MP_HINFO_WIDTH=17", "VL_WIDTH=8", "VSTART_WIDTH=7", "WK_PA_WIDTH=40", "WK_PA_WIDTH_40", "WK_VA_WIDTH=48", "WK_MA_WIDTH=40",
        "WK_LS_DCACHE_SINGLE_TAG_WIDTH=26", "WK_LS_DCACHE_SINGLE_LDTAG_WIDTH=27", "WK_LS_DCACHE_DOUBLE_LDTAG_WIDTH=54", "WK_LS_DCACHE_TRIPLE_LDTAG_WIDTH=81", "WK_LS_DCACHE_LDTAG_WIDTH=108",
        "WK_LS_DCACHE_LDTAG_BF_ECC_LENGTH=22", "WK_LS_DCACHE_LDTAG_DOUBLE_BF_ECC_LENGTH=44", "WK_LS_DCACHE_LDTAG_TRIPLE_BF_ECC_LENGTH=66", "WK_LS_DCACHE_LDTAG_QUADRUPLE_BF_ECC_LENGTH=88",
    )
    lines = [f"+incdir+verif/{config.name}/tb", *(f"+define+{item}" for item in defines), f"verif/{config.name}/tb/{config.name}_deps.sv", *config.production_sources, config.source, f"verif/{config.name}/tb/{config.name}_assertions.sv", f"verif/{config.name}/tb/{config.name}_tb.sv"]
    return "\n".join(lines)


def _runbook(config: Environment) -> str:
    return f"""# `{config.name}` interaction 2.1 VCS验证入口

本环境包含{len(config.features)}个父功能点和{len(config.features) * 6}个逐拍叶级场景。
本机只完成端口、场景、文档、SystemVerilog结构和依赖边界的静态preflight；
没有VCS/URG日志或VDB时，结果保持 `BLOCKED_NO_VCS`。

## 命令

```bash
make preflight
make compile
make run TEST={config.features[0].testcase}
make regress
make coverage
```

`make compile` 需要有许可证的VCS主机，`make coverage` 需要URG。standalone中
{', '.join(config.declared_stubs)} 为显式兼容模型，必须在full-chip用生产定义替换，
对应边界为 `PENDING_FULL_CHIP`。计划行是动态实现合同，不代表已获得仿真或覆盖率PASS。
"""


def _doc_block(config: Environment, rows: list[dict[str, str]]) -> str:
    begin = f"<!-- {config.prefix}-INTERACTION-2.1-BEGIN -->"
    lines = [begin, "", "## Interaction 2.1 叶级场景与执行合同", "", f"共{len(rows)}行；每个父功能点6行。状态只允许 `BLOCKED_NO_VCS` 或 `PENDING_FULL_CHIP`。", *config.doc_tokens, "", "|场景|setup/周期|当|则|checker/coverage/关闭|", "|---|---|---|---|---|"]
    for row in rows:
        cells = (f"`{row['scenario_id']}`", f"{row['setup']}；{row['cycle_sequence']}", row["trigger_condition"], row["expected_result"], f"`{row['checker']}` / `{row['coverage']}`；{row['closure']}")
        lines.append("|" + "|".join(cell.replace("|", "\\|") for cell in cells) + "|")
    lines.extend(("", f"<!-- {config.prefix}-INTERACTION-2.1-END -->"))
    return "\n".join(lines)


def _update_feature_doc(config: Environment, rows: list[dict[str, str]]) -> None:
    path = REPO_ROOT / config.feature_doc
    text = path.read_text(encoding="utf-8").rstrip()
    begin = f"<!-- {config.prefix}-INTERACTION-2.1-BEGIN -->"
    end = f"<!-- {config.prefix}-INTERACTION-2.1-END -->"
    if begin in text:
        before, rest = text.split(begin, 1)
        _, after = rest.split(end, 1)
        text = before.rstrip() + after.rstrip()
    _write(path, text + "\n\n" + _doc_block(config, rows))


def build(config: Environment) -> None:
    env = REPO_ROOT / "verif" / config.name
    source_text = (REPO_ROOT / config.source).read_text(encoding="utf-8")
    ports = parse_module_ports(source_text, config.name)
    port_map = {port.name: port for port in ports}
    for feature in config.features:
        for signal in (*feature.drive, *feature.observe):
            if signal not in port_map:
                raise RuntimeError(f"{config.name}: feature signal is not a DUT port: {signal}")
    rows = _detail_rows(config)
    _write(env / "module.json", json.dumps(_manifest(config), ensure_ascii=False, indent=2))
    _write_csv(env / "coverage_matrix.csv", FEATURE_COLUMNS, _feature_rows(config))
    _write_csv(env / "detailed_test_plan.csv", DETAIL_COLUMNS, rows)
    _write(env / "tests.list", "\n".join(feature.testcase for feature in config.features))
    _write(env / "filelist.f", _filelist(config))
    makefile = (REPO_ROOT / "verif/common/templates/Makefile.in").read_text(encoding="utf-8")
    makefile = makefile.replace("@@DEFAULT_TEST@@", config.features[0].testcase).replace("@@ENV_NAME@@", config.name).replace("@@DUT_MODULE@@", config.name)
    _write(env / "Makefile", makefile)
    _write(env / "tb" / f"{config.name}_deps.sv", _deps(config))
    _write(env / "tb" / f"{config.name}_assertions.sv", _assertions(config, port_map))
    _write(env / "tb" / f"{config.name}_tb.sv", _testbench(config, port_map))
    _write(REPO_ROOT / config.runbook, _runbook(config))
    _update_feature_doc(config, rows)
    if not generate(env / "module.json", check=False):
        raise RuntimeError(f"failed to generate port artifacts for {config.name}")
    print(f"{config.prefix}_ENV_BUILD_PASS features={len(config.features)} scenarios={len(rows)} ports={len(ports)}")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--env", choices=sorted(CONFIGS), required=True)
    args = parser.parse_args()
    build(CONFIGS[args.env])
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
