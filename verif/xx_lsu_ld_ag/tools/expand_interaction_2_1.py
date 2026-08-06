#!/usr/bin/env python3
"""Generate the reviewed AG S05-S08 interaction-2.1 scenario supplement."""

from __future__ import annotations

import csv
from pathlib import Path


ENV_ROOT = Path(__file__).resolve().parents[1]
REPO_ROOT = ENV_ROOT.parents[1]
DETAIL_PATH = ENV_ROOT / "detailed_test_plan.csv"
MATRIX_PATH = ENV_ROOT / "coverage_matrix.csv"
PLAN_PATH = REPO_ROOT / "doc-ag/xx_lsu_ld_ag_feature_test_plan.md"
BEGIN = "<!-- INTERACTION-2.1-SUPPLEMENT-BEGIN -->"
END = "<!-- INTERACTION-2.1-SUPPLEMENT-END -->"


def leaf(
    feature: int,
    number: int,
    scenario: str,
    setup: str,
    drive: str,
    cycles: str,
    trigger: str,
    observe: str,
    expected: str,
    closure: str,
) -> dict[str, str]:
    return {
        "scenario_id": f"AG-FP-{feature:02d}-S{number:02d}",
        "feature_id": f"AG-FP-{feature:02d}",
        "scenario": scenario,
        "setup": setup,
        "drive_signals": drive,
        "cycle_sequence": cycles,
        "trigger_condition": trigger,
        "expected_signals": observe,
        "expected_result": expected,
        "closure": closure,
    }


EXTRA = (
    leaf(1, 5, "replay entry owner精确恢复", "复位释放，LRQ entry5保存VA和IID", "lrq_lsu_rf_replay_vld|lrq_lsu_ex1_lrqid|lrq_lsu_rf_va", "C0: 驱动replay entry5；C1: 采样AG owner", "当 `lrq_lsu_rf_replay_vld=1` 且entry5被发射时", "lag_ex1_inst_vld|lag0_ex1_iid", "则 C1 `lag_ex1_inst_vld=1` 且 `lag0_ex1_iid` 等于replay IID", "replay owner与entry5逐位一致"),
    leaf(1, 6, "replay后fresh无残留", "先完成一个replay，下一拍提供fresh IID 0x26", "lrq_lsu_rf_replay_vld|idu_lsu_rf_gateclk_sel|idu_lsu_rf_sel|idu_lsu_rf_iid", "C0: 完成replay；C1: 切换fresh；C2: 采样", "当 `lrq_lsu_rf_replay_vld=0` 且 `idu_lsu_rf_sel=1` 时", "lag_ex1_inst_vld|lag0_ex1_iid", "则 C2 `lag_ex1_inst_vld=1` 且 `lag0_ex1_iid=idu_lsu_rf_iid`", "fresh不得继承replay IID或payload"),
    leaf(1, 7, "未命中selective flush保持owner", "AG保存IID 0x27，flush IID年龄条件不命中", "rtu_ck_flush|rtu_ck_flush_iid|idu_lsu_rf_iid|dcache_arb_lag_ex1_bkcon", "C0: 建立stall owner；C1: 发未命中ck_flush；C2: 采样", "当 `rtu_ck_flush=1` 且 `rtu_ck_flush_iid_older_than_ex1_iid=0` 时", "lag_ex1_inst_vld|lag0_ex1_iid", "则 C2 `lag_ex1_inst_vld=1` 且 `lag0_ex1_iid` 保持0x27", "未命中flush不得清除或更换owner"),
    leaf(1, 8, "仅gateclk无select不捕获", "AG空闲且无replay", "idu_lsu_rf_gateclk_sel|idu_lsu_rf_sel|idu_lsu_rf_iid", "C0: gateclk_sel=1但sel=0；C1: 采样", "当 `idu_lsu_rf_gateclk_sel=1` 但 `idu_lsu_rf_sel=0` 时", "lag_ex1_inst_vld|lag0_ex1_iid", "则 C1 `lag_ex1_inst_vld=0` 且 `lag0_ex1_iid` 不得捕获输入IID", "门控提示不能单独创建owner"),

    leaf(2, 5, "零offset零shift", "base低位为0x8且MMU命中", "idu_lsu_rf_src0|idu_lsu_rf_offset|idu_lsu_rf_shift|idu_lsu_rf_inst_size", "C0: offset=0且shift=0；C1: 采样", "当 `idu_lsu_rf_offset=0` 且 `idu_lsu_rf_shift=0` 时", "ld_ag_va|lag_ldc_ex1_bytes_vld", "则 C1 `ld_ag_va=idu_lsu_rf_src0` 且 `lag_ldc_ex1_bytes_vld=16'hFF00`", "doubleword mask与base低位精确对应"),
    leaf(2, 6, "最大正offset移位", "base位于页内低地址，offset=0x7ff", "idu_lsu_rf_src0|idu_lsu_rf_offset|idu_lsu_rf_shift|idu_lsu_rf_off_zext", "C0: zext=1且shift=3；C1: 采样", "当 `idu_lsu_rf_off_zext=1`、`idu_lsu_rf_offset=12'h7ff` 且 `idu_lsu_rf_shift=3` 时", "ld_ag_va|ld_ag_cross_4k", "则 C1 `ld_ag_va` 等于base加零扩展offset左移值且 `ld_ag_cross_4k` 匹配参考模型", "最大正offset无符号扩展错误"),
    leaf(2, 7, "16-byte窗口末端mask", "地址低四位为8且size为doubleword", "idu_lsu_rf_src0|idu_lsu_rf_inst_size|idu_lsu_rf_offset", "C0: 发低位8的doubleword；C1: 采样mask", "当 `idu_lsu_rf_inst_size=2'b11` 且 `ld_ag_va[3:0]=4'h8` 时", "lag_ldc_ex1_bytes_vld|ld_ag_va", "则 C1 `lag_ldc_ex1_bytes_vld=16'hFF00` 且 `ld_ag_va[3:0]=4'h8`", "mask不越过16-byte窗口"),
    leaf(2, 8, "页内边界不误报cross", "base页内0x7f0且访问自然对齐", "idu_lsu_rf_src0|idu_lsu_rf_offset|idu_lsu_rf_inst_size", "C0: 发页内访问；C1: 采样cross", "当 `ld_ag_va[11:0]=12'h7f0` 且访问末字节仍在本页时", "ld_ag_cross_4k|lsu_hpcp_ld_stall_cross_4k", "则 C1 `ld_ag_cross_4k=0` 且 `lsu_hpcp_ld_stall_cross_4k=0`", "页内访问不得产生跨页stall"),

    leaf(3, 5, "MMU busy保持owner", "有效AG owner等待MMU", "mmu_lsu_stall|mmu_lsu_pa_vld|idu_lsu_rf_iid", "C0: 置mmu stall；C1: 采样；C2: 再采样；C3: 解除", "当 `mmu_lsu_stall=1` 且 `lag_ex1_inst_vld=1` 时", "lag_ex1_stall_ori|lag0_ex1_iid", "则 C1至C2 `lag_ex1_stall_ori=1` 且 `lag0_ex1_iid` 稳定", "MMU busy期间owner不漂移"),
    leaf(3, 6, "replay携带PA绕过VA请求", "LRQ replay包含有效PA和属性", "lrq_lsu_rf_replay_vld|lrq_lsu_rf_pa_vld|lrq_lsu_rf_pa|lrq_lsu_rf_attr", "C0: 发带PA replay；C1: 采样", "当 `lrq_lsu_rf_replay_vld=1` 且 `lrq_lsu_rf_pa_vld=1` 时", "lsu_mmu_va_vld|lag_ex1_pa", "则 C1 `lsu_mmu_va_vld=0` 且 `lag_ex1_pa` 使用LRQ保存PA", "带PA replay不重复请求MMU"),
    leaf(3, 7, "无owner的迟到AF隔离", "AG为空且fault保存状态已清", "mmu_lsu_access_fault|mmu_lsu_pa_vld|rtu_lsu_flush_fe", "C0: AG保持空；C1: 脉冲AF；C2: 采样", "当 `lag_ex1_inst_vld=0` 时迟到 `mmu_lsu_access_fault=1`", "lsu_mmu_abort|lag_ldc_ex1_expt_vld", "则 C2 `lsu_mmu_abort=0` 且 `lag_ldc_ex1_expt_vld=0`", "无owner响应不得制造异常"),
    leaf(3, 8, "PF与PA同拍归属", "有效owner IID 0x38且无结构stall", "mmu_lsu_pa_vld|mmu_lsu_page_fault|mmu_lsu_pa|idu_lsu_rf_iid", "C0: PA和PF同拍返回；C1: 采样", "当 `mmu_lsu_pa_vld=1` 与 `mmu_lsu_page_fault=1` 同拍命中owner时", "lag_ldc_ex1_expt_page_fault|lsu_mmu_abort|lag0_ex1_iid", "则 C1 `lag_ldc_ex1_expt_page_fault=1` 且 `lsu_mmu_abort=0` 保持当前IID归属", "PF进入DC异常而不串owner"),

    leaf(4, 5, "PF和AF同时到达优先级", "stall owner已建立并记录IID", "dcache_arb_lag_ex1_bkcon|mmu_lsu_page_fault|mmu_lsu_access_fault|mmu_lsu_pa_vld", "C0: 建立stall；C1: 同拍PF和AF；C2: 采样", "当 `lag_bkcon_stall_already=1` 且PF与 `mmu_lsu_access_fault=1` 同拍时", "lag_bkcon_pgfault|lag_bkcon_acfault|lag_ldc_ex1_expt_vld", "则 C2 `lag_bkcon_pgfault=1`、`lag_bkcon_acfault=1` 且 `lag_ldc_ex1_expt_vld=1`", "两个保存位均绑定同一owner"),
    leaf(4, 6, "PF输入撤销后继续保持", "PF已在stall周期捕获", "dcache_arb_lag_ex1_bkcon|mmu_lsu_page_fault|mmu_lsu_pa_vld", "C0: 捕获PF；C1: 撤PF保持stall；C2-C3: 采样", "当输入 `mmu_lsu_page_fault=0` 但原owner仍stall时", "lag_bkcon_pgfault|lag0_ex1_iid", "则 C2至C3 `lag_bkcon_pgfault=1` 且 `lag0_ex1_iid` 不变", "PF保存不依赖输入电平持续"),
    leaf(4, 7, "flush清除保存fault", "stall owner已保存PF和AF", "rtu_lsu_flush_fe|dcache_arb_lag_ex1_bkcon|mmu_lsu_page_fault|mmu_lsu_access_fault", "C0: 建立保存位；C1: full flush；C2: 采样", "当 `rtu_lsu_flush_fe=1` 清除fault owner时", "lag_bkcon_pgfault|lag_bkcon_acfault|lag_ex1_inst_vld", "则 C2 `lag_bkcon_pgfault=0`、`lag_bkcon_acfault=0` 且 `lag_ex1_inst_vld=0`", "flush后不残留fault状态"),
    leaf(4, 8, "新owner不继承旧AF", "旧AF事务完成后立即发新IID", "idu_lsu_rf_gateclk_sel|idu_lsu_rf_sel|idu_lsu_rf_iid|mmu_lsu_access_fault", "C0: 旧owner退出；C1: 发无fault fresh；C2: 采样", "当新的 `idu_lsu_rf_sel=1` 捕获且 `mmu_lsu_access_fault=0` 时", "lag_bkcon_acfault|lag_ldc_ex1_expt_vld|lag0_ex1_iid", "则 C2 `lag_bkcon_acfault=0`、`lag_ldc_ex1_expt_vld=0` 且IID为新owner", "back-to-back事务异常状态隔离"),

    leaf(5, 5, "older覆盖且PA命中", "fresh结构stall已创建LRQ entry", "dcache_arb_lag_ex1_sel|idu_lsu_rf_older_vld|mmu_lsu_pa_vld|lrq_lsu_ex1_lrqid", "C0: 建立stall；C1: older=1且PA有效；C1组合采样", "当 `lag_ex1_stall_ori=1`、`idu_lsu_rf_older_vld=1` 且 `mmu_lsu_pa_vld=1` 时", "lsu_lrq_create_frz|lag_ex1_stall_restart_entry", "则 `lsu_lrq_create_frz=0` 且已创建entry可由 `lag_ex1_stall_restart_entry` 唤醒", "PA命中覆盖路径不冻结owner"),
    leaf(5, 6, "older覆盖纯TLB miss等待", "fresh结构stall已创建LRQ且没有其他abort源", "dcache_arb_lag_ex1_sel|idu_lsu_rf_older_vld|mmu_lsu_pa_vld|mmu_lsu_access_fault", "C0: 建立stall；C1: older=1、PA无效且AF=0；C1组合采样", "当 `lag_ex1_stall_ori=1`、`idu_lsu_rf_older_vld=1`、`mmu_lsu_pa_vld=0` 且无abort时", "lsu_lrq_create_frz|lag_ex1_stall_restart_entry", "则 `lsu_lrq_create_frz=1` 且 `lag_ex1_stall_restart_entry` 保持全零等待MMU", "纯miss与aborted miss结果必须区分"),
    leaf(5, 7, "older覆盖aborted TLB miss立即重发", "结构stall已连续一拍并保存LRQ id，延迟AF作为独立abort源", "dcache_arb_lag_ex1_sel|idu_lsu_rf_older_vld|idu_lsu_rf_gateclk_sel|idu_lsu_rf_sel|mmu_lsu_pa_vld|mmu_lsu_access_fault|lrq_lsu_ex1_lrqid", "C0: 建立结构stall并创建LRQ；C1: 确认create_already；C1负沿驱动older=1、PA无效和延迟AF；C1组合采样；C2: 捕获", "当 `lag_ex1_stall_ori=1`、`idu_lsu_rf_older_vld=1`、`mmu_lsu_pa_vld=0` 且由延迟访问异常使 `lsu_mmu_abort=1` 时", "lag_ex1_stall_ori|idu_lsu_rf_older_vld|mmu_lsu_pa_vld|lsu_mmu_abort|lag_ex1_stall_restart_entry|lsu_lrq_create_frz|lag_lrq_create_already", "则 `lsu_lrq_create_frz=0` 且 `lag_ex1_stall_restart_entry` 立即指向已创建LRQ，`lag_lrq_create_already=1`", "同一组合观察点freeze为0且restart bitmap非零"),
    leaf(5, 8, "replay owner abort不重复create", "LRQ replay entry有效且结构stall", "lrq_lsu_rf_replay_vld|lrq_lsu_ex1_lrqid|dcache_arb_lag_ex1_sel|mmu_lsu_access_fault", "C0: 发replay并建立stall；C1: 注入AF；C2: 采样", "当 `lag_lrq_replay_vld=1` 的owner因 `mmu_lsu_access_fault=1` abort时", "lsu_lrq_create_vld|lag_ex1_stall_restart_entry|lsu_mmu_abort", "则 `lsu_lrq_create_vld=0` 且 `lag_ex1_stall_restart_entry` 只指向原replay entry", "replay abort不得分配第二个LRQ"),

    leaf(6, 5, "data request低高bank边界", "cacheable load且D-cache开启", "idu_lsu_rf_src0|mmu_lsu_pa|mmu_lsu_pa_vld|cp0_lsu_dcache_en", "C0: 依次驱动PA bank0和bank3；C1: 各采样", "当 `mmu_lsu_pa_vld=1` 且 `lag_ex1_pa[7:6]` 在00与11切换时", "lag_dcache_arb_ex1_data_req|lag_dcache_arb_ex1_bank_idx", "则 `lag_dcache_arb_ex1_bank_idx` 精确跟随PA且data request保持one-hot组", "首尾bank均被真实请求覆盖"),
    leaf(6, 6, "tag gateclock与request一致", "有效cacheable owner无异常", "cp0_lsu_dcache_en|mmu_lsu_ca|idu_lsu_rf_gateclk_sel|idu_lsu_rf_sel", "C0: 发有效load；C1: 采样gate与req", "当 `lag_dcache_arb_ex1_ld_tag_req=1` 时", "lag_dcache_arb_ex1_ld_tag_gateclk_en|lag_dcache_arb_ex1_ld_tag_req", "则 `lag_dcache_arb_ex1_ld_tag_gateclk_en=1` 且tag request仅持续所属周期", "请求不能脱离阵列门控"),
    leaf(6, 7, "backpressure期间PA变化隔离", "AG已保存cacheable owner和bank1", "dcache_arb_lag_ex1_bkcon|mmu_lsu_pa|mmu_lsu_pa_vld|idu_lsu_rf_iid", "C0: 建立bank1 owner；C1: bkcon并改变MMU PA；C2: 采样", "当 `dcache_arb_lag_ex1_bkcon=1` 且外部 `mmu_lsu_pa` 改变时", "lag_dcache_arb_ex1_bank_idx|lag0_ex1_iid", "则 `lag_dcache_arb_ex1_bank_idx` 与 `lag0_ex1_iid` 均保持原owner值", "stall期间不能采到下一事务PA"),
    leaf(6, 8, "cache关闭与NC组合", "D-cache关闭且MMU返回NC", "cp0_lsu_dcache_en|mmu_lsu_ca|mmu_lsu_pa_vld|idu_lsu_rf_sel", "C0: dcache_en=0、CA=0并发load；C1: 采样", "当 `cp0_lsu_dcache_en=0` 且 `mmu_lsu_ca=0` 时", "lag_dcache_arb_ex1_ld_tag_req|lag_dcache_arb_ex1_data_req|lag_ldc_ex1_page_ca", "则 `lag_dcache_arb_ex1_ld_tag_req=0`、data request为零且 `lag_ldc_ex1_page_ca=0`", "双重禁用不产生cache阵列访问"),

    leaf(7, 5, "unit-stride零命中way", "tag相位完成但四路均miss", "idu_lsu_rf_inst_vls|idu_lsu_rf_unit_stride|lag_us_tag_hit_way", "C0: 发unit-stride；C1: hit_way=0；C2: 采样", "当 `lag_us_tag_hit_way=4'b0000` 且unit-stride owner有效时", "lag_ex1_us_way|lag_us_tag_ack_stall", "则 `lag_ex1_us_way=4'b0000` 且 `lag_us_tag_ack_stall=1` 阻止错误data相位", "all-miss不选择任意way"),
    leaf(7, 6, "tag ack反压保持两相位", "tag请求已成功但仲裁未ack", "idu_lsu_rf_inst_vls|idu_lsu_rf_unit_stride|dcache_arb_lag_ex1_sel", "C0: 发请求；C1: tag成功后撤sel；C2: 采样", "当 `lag_us_tag_ack_stall=1` 时", "lag_ex1_stall_ori|lag_us_tag_req_success", "则 `lag_ex1_stall_ori=1` 且 `lag_us_tag_req_success=1` 保持已完成tag相位", "ack反压不能重复tag或提前data"),
    leaf(7, 7, "两相位中途flush", "unit-stride已完成tag尚未data", "rtu_lsu_flush_fe|idu_lsu_rf_inst_vls|idu_lsu_rf_unit_stride|lag_us_tag_hit_way", "C0: tag相位；C1: full flush；C2: 采样", "当unit-stride两相位之间 `rtu_lsu_flush_fe=1` 时", "lag_ex1_inst_vld|lag_dcache_arb_ex1_data_req", "则 C2 `lag_ex1_inst_vld=0` 且 `lag_dcache_arb_ex1_data_req=16'h0000`", "flush后不得发迟到data请求"),
    leaf(7, 8, "连续unit-stride way替换", "首owner命中way0，次owner命中way3", "idu_lsu_rf_inst_vls|idu_lsu_rf_unit_stride|idu_lsu_rf_iid|lag_us_tag_hit_way", "C0: 发way0 owner；C1: 完成首个tag；C2: 完成首个data；C3-C5: 完成way3并采样", "当两个 `idu_lsu_rf_unit_stride=1` owner背靠背且命中way不同时", "lag_ldc_ex1_us_way|lag0_ex1_iid", "则第二事务 `lag_ldc_ex1_us_way=4'b1000` 且IID属于第二owner", "保存way随owner更新且无旧值泄漏"),

    leaf(8, 5, "misalign与PF同拍优先级", "atomic doubleword为奇地址且MMU报告PF", "idu_lsu_rf_atomic|idu_lsu_rf_inst_size|idu_lsu_rf_src0|mmu_lsu_page_fault|mmu_lsu_pa_vld", "C0: 同拍建立misalign和PF；C1: 采样", "当 `ld_ag_unalign=1` 与 `mmu_lsu_page_fault=1` 同拍时", "lag_ldc_ex1_expt_misalign_no_page|lag_ldc_ex1_expt_page_fault|lag_ldc_ex1_expt_vld", "则异常子类按RTL优先级稳定且 `lag_ldc_ex1_expt_vld=1`", "组合异常不产生X或正常load副作用"),
    leaf(8, 6, "跨页misalign分类", "普通load跨页且访问宽度导致不对齐", "idu_lsu_rf_inst_size|idu_lsu_rf_src0|idu_lsu_rf_offset|mmu_lsu_pa_vld", "C0: 构造跨页misalign；C1: 采样", "当 `ld_ag_cross_4k=1` 且 `ld_ag_unalign=1` 时", "lag_ldc_ex1_expt_misalign_with_page|lag_ldc_ex1_expt_misalign_no_page", "则 `lag_ldc_ex1_expt_misalign_with_page=1` 且no-page分类不重复置位", "with-page与no-page分类互斥"),
    leaf(8, 7, "aligned atomic CA正常路径", "atomic已matching commit且地址对齐CA=1", "idu_lsu_rf_atomic|rtu_yy_xx_commit0|rtu_yy_xx_commit0_iid|mmu_lsu_ca|mmu_lsu_pa_vld", "C0: 建立atomic；C1: matching commit；C2: 采样", "当 `lag_ldc_ex1_atomic=1`、`mmu_lsu_ca=1` 且地址对齐时", "lag_ldc_ex1_expt_ldamo_not_ca|lag_ldc_ex1_expt_vld", "则 `lag_ldc_ex1_expt_ldamo_not_ca=0` 且无其他错误时 `lag_ldc_ex1_expt_vld=0`", "合法LDAMO不误报属性异常"),
    leaf(8, 8, "flush压制异常副作用", "有效owner与PF在flush同拍", "rtu_lsu_flush_fe|mmu_lsu_page_fault|mmu_lsu_pa_vld|idu_lsu_rf_iid", "C0: 建立owner；C1: flush和PF同拍；C2: 采样", "当 `rtu_lsu_flush_fe=1` 与 `mmu_lsu_page_fault=1` 同拍时", "lag_ex1_inst_vld|lag_ldc_ex1_inst_vld", "则 C2 `lag_ex1_inst_vld=0` 且 `lag_ldc_ex1_inst_vld=0`", "被flush异常不得进入正常DC事务"),

    leaf(9, 5, "older覆盖PA hit创建ready", "fresh结构stall尚未创建第二次", "idu_lsu_rf_older_vld|mmu_lsu_pa_vld|dcache_arb_lag_ex1_sel|lrq_lsu_ex1_lrqid", "C0: 建立fresh stall；C1: older=1且PA hit；C1组合采样", "当 `lag_ex1_stall_ori=1`、`idu_lsu_rf_older_vld=1` 且 `mmu_lsu_pa_vld=1` 时", "lsu_lrq_create_vld|lsu_lrq_create_frz|lsu_lrq_create_iid", "则首次 `lsu_lrq_create_vld=1` 且 `lsu_lrq_create_frz=0`、IID等于owner", "ready entry创建一次且不冻结"),
    leaf(9, 6, "older覆盖纯miss创建frozen", "fresh结构stall且PA尚未返回", "idu_lsu_rf_older_vld|mmu_lsu_pa_vld|dcache_arb_lag_ex1_sel|lrq_lsu_ex1_lrqid", "C0: 发fresh并stall；C1: older=1且PA miss；C1组合采样", "当首次create时 `idu_lsu_rf_older_vld=1` 且 `mmu_lsu_pa_vld=0`、abort为0", "lsu_lrq_create_vld|lsu_lrq_create_frz|lsu_lrq_create_iid", "则 `lsu_lrq_create_vld=1`、`lsu_lrq_create_frz=1` 且IID精确匹配", "未完成MMU的entry必须等待而非立即issue"),
    leaf(9, 7, "create_already抑制重复脉冲", "结构stall已持续一拍并记录LRQ id", "dcache_arb_lag_ex1_sel|lrq_lsu_ex1_lrqid|idu_lsu_rf_iid", "C0: 首次create；C1: 保持stall并计数；C2-C3: 继续计数", "当 `lag_lrq_create_already=1` 且owner继续stall时", "lsu_lrq_create_vld|lag_lrq_create_already", "则 C1至C3 `lsu_lrq_create_vld=0` 且 `lag_lrq_create_already=1`", "一个owner仅允许一个create脉冲"),
    leaf(9, 8, "check flush取消目标entry", "fresh待完成且ck_flush年龄命中", "rtu_ck_flush|rtu_ck_flush_iid|idu_lsu_rf_iid|dcache_arb_lag_ex1_bkcon", "C0: 建立owner；C1: 命中ck_flush；C2: 采样", "当 `rtu_ck_flush=1` 且 `rtu_ck_flush_iid_older_than_ex1_iid=1` 时", "lsu_lrq_create_vld|lag_ex1_inst_vld|lsu_mmu_abort", "则 C2 `lsu_lrq_create_vld=0`、`lag_ex1_inst_vld=0` 且abort只作用于目标owner", "selective flush无迟到LRQ分配"),

    leaf(10, 5, "commit slot1匹配atomic", "atomic owner等待且slot0空闲", "rtu_yy_xx_commit1|rtu_yy_xx_commit1_iid|idu_lsu_rf_atomic|idu_lsu_rf_iid", "C0: 建立atomic；C1: slot1 matching commit；C2: 采样", "当 `rtu_yy_xx_commit1=1` 且其IID等于atomic owner时", "lag_lm_ex1_init_vld|lag_ldc_ex1_atomic", "则 C2 `lag_lm_ex1_init_vld=1` 且 `lag_ldc_ex1_atomic=1`", "非slot0 commit同样可初始化monitor"),
    leaf(10, 6, "commit脉冲只初始化一次", "atomic owner等待matching commit", "rtu_yy_xx_commit0|rtu_yy_xx_commit0_iid|idu_lsu_rf_atomic|idu_lsu_rf_iid", "C0: 建立atomic；C1: 单拍commit；C2-C3: 撤销并采样", "当matching `rtu_yy_xx_commit0=1` 仅持续一拍时", "lag_lm_ex1_init_vld|ld_ag_stall_restart", "则 `lag_lm_ex1_init_vld` 仅在对应转移周期有效且 `ld_ag_stall_restart` 随后解除", "monitor初始化不重复"),
    leaf(10, 7, "atomic等待期间flush", "未commit atomic处于restart等待", "idu_lsu_rf_atomic|rtu_lsu_flush_fe|rtu_yy_xx_commit0", "C0: 建立未commit atomic；C1: full flush；C2: 采样", "当未commit atomic等待时 `rtu_lsu_flush_fe=1`", "lag_ex1_inst_vld|lag_lm_ex1_init_vld", "则 C2 `lag_ex1_inst_vld=0` 且 `lag_lm_ex1_init_vld=0`", "flush不能留下local monitor初始化"),
    leaf(10, 8, "非atomic匹配commit隔离", "普通load IID恰与commit IID相同", "idu_lsu_rf_atomic|idu_lsu_rf_iid|rtu_yy_xx_commit0|rtu_yy_xx_commit0_iid", "C0: 发普通load；C1: matching commit；C2: 采样", "当 `lag_ldc_ex1_atomic=0` 即使matching commit有效时", "lag_lm_ex1_init_vld|lag_ldc_ex1_atomic", "则 `lag_lm_ex1_init_vld=0` 且 `lag_ldc_ex1_atomic=0`", "普通load不得初始化atomic monitor"),

    leaf(11, 5, "vmask全零压制byte mask", "unit-stride split且vmask有效但数据全零", "idu_lsu_rf_inst_vls|idu_lsu_rf_unit_stride|idu_lsu_rf_vmask_vld|idu_lsu_rf_srcvm_vr0", "C0: vmask全零；C1: 采样", "当 `idu_lsu_rf_vmask_vld=1` 且 `idu_lsu_rf_srcvm_vr0=0` 时", "lag_ldc_ex1_bytes_vld|lag_ldc_ex1_reg_bytes_vld", "则 `lag_ldc_ex1_bytes_vld=0` 且 `lag_ldc_ex1_reg_bytes_vld=0`", "mask关闭的元素不产生byte有效位"),
    leaf(11, 6, "partial vmask稀疏映射", "vmew=1且vmask使用交替位", "idu_lsu_rf_inst_vls|idu_lsu_rf_vmew|idu_lsu_rf_vmask_vld|idu_lsu_rf_srcvm_vr0", "C0: 驱动交替vmask；C1: 采样四组mask", "当 `idu_lsu_rf_vmew=1` 且vmask为交替位图时", "lag_ldc_ex1_bytes_vld|lag_ldc_ex1_bytes_vld1|lag_ldc_ex1_reg_bytes_vld", "则 `lag_ldc_ex1_bytes_vld` 与 `lag_ldc_ex1_reg_bytes_vld` 按vmew1参考映射保持二态", "稀疏mask逐bit对比helper模型"),
    leaf(11, 7, "split_num边界轮转", "vmew=2且split_num取0和最大值", "idu_lsu_rf_inst_vls|idu_lsu_rf_split|idu_lsu_rf_split_num|idu_lsu_rf_vmew", "C0: split_num=0；C1: 采样；C2: 最大值；C3: 采样", "当 `idu_lsu_rf_split=1` 且 `idu_lsu_rf_split_num` 在边界值切换时", "lag_ldc_ex1_bytes_vld|lag_ldc_ex1_bytes_vld2", "则 `lag_ldc_ex1_bytes_vld2` 随split轮转且不含X，主 `lag_ldc_ex1_bytes_vld` 归属正确", "首尾split索引均覆盖"),
    leaf(11, 8, "背靠背vmew切换隔离", "连续两个vector owner分别vmew0和vmew3", "idu_lsu_rf_inst_vls|idu_lsu_rf_vmew|idu_lsu_rf_iid|idu_lsu_rf_srcvm_vr1", "C0: vmew0 owner；C1: 采样；C2: vmew3 owner；C3: 采样", "当连续owner的 `idu_lsu_rf_vmew` 从0切换到3时", "lag_ldc_ex1_bytes_vld|lag_ldc_ex1_bytes_vld3|lag0_ex1_iid", "则第二owner `lag_ldc_ex1_bytes_vld3` 使用vmew3映射且 `lag0_ex1_iid` 已更新", "vector模式状态不跨owner泄漏"),

    leaf(12, 5, "ICG关闭且scan关闭不捕获", "AG空闲，功能门控和scan均关闭", "cp0_lsu_icg_en|pad_yy_icg_scan_en|idu_lsu_rf_gateclk_sel|idu_lsu_rf_sel", "C0: icg=0、scan=0并给请求；C1: 采样", "当 `cp0_lsu_icg_en=0` 且 `pad_yy_icg_scan_en=0` 时", "lag_ex1_inst_vld|lag0_ex1_iid", "则 C1 `lag_ex1_inst_vld=0` 且 `lag0_ex1_iid` 不捕获新值", "关闭门控时状态保持"),
    leaf(12, 6, "reset期间输入脉冲隔离", "cpurst_b保持低且输入端口非零", "cpurst_b|idu_lsu_rf_gateclk_sel|idu_lsu_rf_sel|idu_lsu_rf_iid", "C0: reset低并脉冲fresh；C1: 采样；C2: 释放reset", "当 `cpurst_b=0` 时即使 `idu_lsu_rf_sel=1`", "lag_ex1_inst_vld|lsu_lrq_create_vld", "则 C1 `lag_ex1_inst_vld=0` 且 `lsu_lrq_create_vld=0`", "复位期间无owner或LRQ副作用"),
    leaf(12, 7, "selective flush未命中不abort", "AG owner IID比flush边界更老", "rtu_ck_flush|rtu_ck_flush_iid|idu_lsu_rf_iid|dcache_arb_lag_ex1_bkcon", "C0: 建立owner；C1: 发未命中flush；C2: 采样", "当 `rtu_ck_flush=1` 且 `rtu_ck_flush_iid_older_than_ex1_iid=0` 时", "lsu_mmu_abort|lag_ex1_inst_vld|lag0_ex1_iid", "则 `lsu_mmu_abort=0`、`lag_ex1_inst_vld=1` 且IID不变", "selective flush只清命中年龄窗口"),
    leaf(12, 8, "masked stall同拍full flush", "结构stall owner被older RF覆盖", "dcache_arb_lag_ex1_sel|idu_lsu_rf_older_vld|rtu_lsu_flush_fe|idu_lsu_rf_iid", "C0: 建立stall；C1: older和full flush同拍；C2: 采样", "当 `lag_ex1_stall_ori=1`、`idu_lsu_rf_older_vld=1` 与 `rtu_lsu_flush_fe=1` 同拍时", "lsu_mmu_abort|lag_ex1_inst_vld|lsu_lrq_create_vld", "则当拍 `lsu_mmu_abort=1`，C2 `lag_ex1_inst_vld=0` 且 `lsu_lrq_create_vld=0`", "flush优先于masked replay且无幽灵create"),
)


def read_rows(path: Path) -> tuple[tuple[str, ...], list[dict[str, str]]]:
    with path.open(encoding="utf-8", newline="") as stream:
        reader = csv.DictReader(stream)
        return tuple(reader.fieldnames or ()), list(reader)


def build_rows() -> tuple[tuple[str, ...], list[dict[str, str]]]:
    columns, current = read_rows(DETAIL_PATH)
    _, parents = read_rows(MATRIX_PATH)
    parent_map = {row["feature_id"]: row for row in parents}
    rows = [row for row in current if int(row["scenario_id"].rsplit("S", 1)[1]) <= 4]
    for extra in EXTRA:
        parent = parent_map[extra["feature_id"]]
        rows.append(
            {
                "scenario_id": extra["scenario_id"],
                "feature_id": extra["feature_id"],
                "scenario": extra["scenario"],
                "testcase": parent["testcase"],
                "priority": parent["priority"],
                "setup": extra["setup"],
                "drive_signals": extra["drive_signals"],
                "cycle_sequence": extra["cycle_sequence"],
                "trigger_condition": extra["trigger_condition"],
                "expected_signals": extra["expected_signals"],
                "expected_result": extra["expected_result"],
                "checker": parent["checker"],
                "coverage": parent["coverage"],
                "closure": extra["closure"],
                "result": parent["result"],
            }
        )
    rows.sort(key=lambda row: row["scenario_id"])
    return columns, rows


def write_csv(columns: tuple[str, ...], rows: list[dict[str, str]]) -> None:
    with DETAIL_PATH.open("w", encoding="utf-8", newline="") as stream:
        writer = csv.DictWriter(
            stream,
            fieldnames=columns,
            quoting=csv.QUOTE_ALL,
            lineterminator="\n",
        )
        writer.writeheader()
        writer.writerows(rows)


def supplement_markdown(rows: list[dict[str, str]]) -> str:
    lines = [
        BEGIN,
        "## 4. interaction 2.1 补充叶级场景（S05～S08）",
        "",
        "下表补齐每个功能点的反例、边界、owner切换和flush/反压组合。",
        "所有行与CSV逐字对应；其中AG-FP-05-S05～S08形成PA/abort/replay真值表。",
        "",
        "|场景|前置与逐拍驱动|当|则|检查与关闭|",
        "|---|---|---|---|---|",
    ]
    for row in rows:
        if int(row["scenario_id"].rsplit("S", 1)[1]) <= 4:
            continue
        cells = (
            f"`{row['scenario_id']}`",
            f"{row['setup']}；{row['cycle_sequence']}",
            row["trigger_condition"],
            row["expected_result"],
            f"`{row['checker']}` / `{row['coverage']}`；{row['closure']}",
        )
        lines.append("|" + "|".join(cell.replace("|", "\\|") for cell in cells) + "|")
    lines.extend((END, ""))
    return "\n".join(lines)


def update_markdown(rows: list[dict[str, str]]) -> None:
    text = PLAN_PATH.read_text(encoding="utf-8")
    if BEGIN in text:
        prefix, remainder = text.split(BEGIN, 1)
        _, suffix = remainder.split(END, 1)
        text = prefix.rstrip() + "\n\n" + suffix.lstrip("\n")
    text = text.replace("展开为 48 个", "展开为 96 个")
    text = text.replace("- 48表示", "- 96表示")
    text = text.replace("不是48个场景", "不是96个场景")
    text = text.replace("证明48行计划", "证明96行计划")
    text = text.replace("S01～S04", "S01～S08")
    text = text.replace("## 4. 关闭与执行边界", "## 5. 关闭与执行边界")
    marker = "## 5. 关闭与执行边界"
    if marker not in text:
        raise RuntimeError("closing section marker not found")
    text = text.replace(marker, supplement_markdown(rows) + marker, 1)
    PLAN_PATH.write_text(text, encoding="utf-8")


def main() -> int:
    columns, rows = build_rows()
    if len(EXTRA) != 48 or len(rows) != 96:
        raise RuntimeError(f"expected 48 extras and 96 total, got {len(EXTRA)} / {len(rows)}")
    write_csv(columns, rows)
    update_markdown(rows)
    print("AG_INTERACTION_2_1_EXPANSION_PASS scenarios=96 per_feature=8")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
