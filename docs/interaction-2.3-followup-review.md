# Interaction 2.3 CP0 交付闭环审查

## 结论与范围

`README.md` 中 Interaction 2.3 的“详细设计文档”交付由[CP0 系统、中断与异常详细设计](../doc-cp0/wk_cp0_system_interrupt_exception_detailed_design.md)闭环。本审查的源码基线是 `473b3c23794a7841f3c31fc667a4964fda9a28d4`；人工和机械审查的唯一 CP0 RTL 输入为 `cp0/wk_cp0_top.v`、`cp0/wk_cp0_iui.v`、`cp0/wk_cp0_regs.v` 与 `cp0/wk_cp0_lpmd.v`。

本分支没有修改生产 RTL、`srcs/` 或 `README.md`。这里的“闭环”是文档、静态合同和既有 preflight 的闭环，不是 CP0 的编译、仿真、回归、断言、代码覆盖率或功能覆盖率签核。

## 可复跑静态证据

以下命令于本分支仓库根目录重新执行；数字是本次执行的实际计数。

|检查|命令|本次结果|
|---|---|---|
|CP0 静态合同|`python3 tools/check_interaction_2_3_cp0_contract.py`|`CP0_CONTRACT_PASS modules=4 submodules=3 interrupt_sources=8 priority_slots=15 live_slots=13 delegable_exceptions=12 ack_consumers=0`|
|CP0 单元/变异测试|`python3 -m unittest tests.test_interaction_2_3_cp0_contract -v`|14 tests，0 failures，`OK`；覆盖 MCIP 两侧及 cause23 `vec_num` 新行、ACK 声明赋值/非消费者、CLI 与 WFI 定向变异。|
|全仓 Python 单元测试|`python3 -m unittest discover -s tests -v`|91 tests，0 failures，`OK`|
|既有 LSU preflight|`make -C verif/common preflight`|7 environments、85 features、534 scenarios；`LSU_PREFLIGHT_PASS` 与 `INTERACTION_2_1_PREFLIGHT_PASS`|
|全交付 whitespace 覆盖|`git diff --check 473b3c23794a7841f3c31fc667a4964fda9a28d4..HEAD`|最终提交后 exit 0、无输出；覆盖基线至最终 HEAD 的不可变已提交范围|
|生产范围|`git diff 473b3c2...HEAD -- cp0 srcs README.md`|exit 0，无输出（0 个 CP0/`srcs`/README 变更）|
|分支状态（创建本报告前）|`git status --short --branch`|`## review/interaction-2.3-v1`；clean baseline，无工作树条目|

合同 marker 证明检查器从当前四个 RTL 文件抽取并核对四模块/三子模块拓扑、八类中断源、15 个优先级槽（13 live）和 12 个有效异常委托 cause；JSON 还固定精确五项 `key_paths`，并给出结构事实 `mcip_delegation={cause:23, request_selects_supervisor:true, trap_classifies_supervisor:false}`。该 trap-side 值由与异常委托共用的实际 `vec_num` cause→one-hot-bit 映射及 `[18:0]` 相交范围计算，并额外强制 cause23 不得出现在映射中；因此 MCIP 可由 `mideleg_value[23]` 进入 delegated request 槽，但 RTU 回送 cause23 时由 `mideleg_vld` 分类为 M trap。

对 `ack_consumers=0`，证明范围仍很窄：检查器只扫描已解析的 `wk_cp0_regs` module body，忽略注释、字符串文本和无初始化声明，同时保留 `wire/reg ... = rtu_cp0_int_ack` 初始化右值和独立语句中的引用。它不证明另外三个文件没有语义消费者，也不证明顶层连通性；更广观察仍须由系统集成和动态测试确认。marker/JSON 也不证明外部宏、完整 CP0 filelist、上游/下游接口时序或动态行为。

本报告的后续微小文字修订不把尚未产生的自身提交 SHA 写入历史证据；每个新 HEAD 的 whitespace 由最终分支控制器执行 revision-range 检查，以避免自引用循环。

## 链接和源码锚点审计

对详细设计与本报告执行只读的 Python 标准库 Markdown-link 审计：逐个解析 `[]()` 中的仓库相对目标，并以仓库根目录归一化后检查存在性；每篇文档都必须至少含一个仓库相对链接，避免空集合误过。详细设计有 22 个、本报告有 5 个，合计 27/27 解析到现存仓库文件。

同时对详细设计每个一级章节至少抽样一个已列出的 RTL 锚点，并以当前文件行号读取：§1 `wk_cp0_top.v:1042`、§2 `wk_cp0_iui.v:1406`、§3 `wk_cp0_regs.v:2646`、§4 `wk_cp0_regs.v:2144`、§5 `wk_cp0_lpmd.v:161`、§6 `wk_cp0_iui.v:2004`、§7 `wk_cp0_regs.v:3207`、§8 `wk_cp0_regs.v:5597`。8/8 样本均在当前文件范围内且为非空 RTL 行；此审计只确认定位与源码可读，不能替代语义仿真。

从仓库根目录执行以下只读 Python 标准库命令，可重跑链接和锚点审计；它同时覆盖本文和详细设计，且不写入仓库文件：

```bash
python3 - <<'PY'
from pathlib import Path
import re

root = Path.cwd().resolve()
documents = [
    root / 'doc-cp0/wk_cp0_system_interrupt_exception_detailed_design.md',
    root / 'docs/interaction-2.3-followup-review.md',
]
links = []
for document in documents:
    document_links = []
    for target in re.findall(r'(?<!!)\[[^\]]*\]\(([^)]+)\)', document.read_text(encoding='utf-8')):
        target = target.strip().split(maxsplit=1)[0].strip('<>')
        if '://' in target or target.startswith('#'):
            continue
        resolved = (document.parent / target).resolve()
        if (root not in resolved.parents and resolved != root) or not resolved.exists():
            raise SystemExit(f'LINK_AUDIT_FAIL {document.relative_to(root)}:{target}')
        document_links.append(target)
    if not document_links:
        raise SystemExit(f'LINK_AUDIT_FAIL {document.relative_to(root)}:no repository-relative links')
    links.extend((document, target) for target in document_links)
anchors = [
    ('section1', 'cp0/wk_cp0_top.v', 1042),
    ('section2', 'cp0/wk_cp0_iui.v', 1406),
    ('section3', 'cp0/wk_cp0_regs.v', 2646),
    ('section4', 'cp0/wk_cp0_regs.v', 2144),
    ('section5', 'cp0/wk_cp0_lpmd.v', 161),
    ('section6', 'cp0/wk_cp0_iui.v', 2004),
    ('section7', 'cp0/wk_cp0_regs.v', 3207),
    ('section8', 'cp0/wk_cp0_regs.v', 5597),
]
for section, relpath, line in anchors:
    source_lines = (root / relpath).read_text(encoding='utf-8').splitlines()
    if line > len(source_lines) or not source_lines[line - 1].strip():
        raise SystemExit(f'ANCHOR_AUDIT_FAIL {section} {relpath}:{line}')
print(f'LINK_AUDIT_PASS documents={len(documents)} repository_relative_links={len(links)} resolved={len(links)}')
print(f'ANCHOR_AUDIT_PASS samples={len(anchors)} valid={len(anchors)}')
PY
```

## 动态签核边界与待集成问题

静态源码审查不能替代 CP0 compile/simulation/coverage signoff。仓库仍缺完整 CP0 filelist、外部模块和 `WK_MAJOR_*` 宏配置；因此以下九项保持“待集成确认”，直到系统 owner review 和动态测试关闭，且均不认定为已确认 bug：

1. `rtu_cp0_int_ack` 无消费者，request 撤销是否完全依赖 source/pending。
2. `cp0_mret/cp0_sret` 类型输出未直接带 `iui_privilege`，非法 xRET 是否避免 return-path 副作用。
3. `cp0_expt_vld` 在 flush 或后续 EX2 更新前保持，IU 消费端的 valid/flush 合同。
4. `medeleg` 的 bit 0 可写而 cause 0 无 one-hot decode，cause 0 不委托是否符合预期。
5. `mtvec/stvec` 的 mode[1] 在 CSR readback/VBR 被清零，非法 vector-mode 的 WARL 可见行为。
6. `rtu_cp0_expt_vld` 与 `rtu_yy_xx_expt_vld` 控制不同状态，dual-valid 周期一致性。
7. AIA/major-interrupt 集成：`ADD_AIA`、IMSIC 与仓库外 `WK_MAJOR_*` 宏的 filelist/configuration/function closure；同时确认 MCIP request 侧可走 delegated slot5、而 returned cause23 trap 侧固定分类 M 的不一致是否为系统预期并动态覆盖。
8. `cp0_ifu_vbr` 仅给 base/mode，IFU/下游 vector offset、对齐和采样时刻。
9. `biu_cp0_ss_int` 置位后的 `mvssip` sticky 行为，软件清除、重复置位和输入回落协议。

## 紧凑工件索引

|工件|用途|
|---|---|
|[详细设计](../doc-cp0/wk_cp0_system_interrupt_exception_detailed_design.md)|实现路径、验证合同、9 项集成问题和 RTL 锚点。|
|[静态检查器](../tools/check_interaction_2_3_cp0_contract.py)|从四个权威 CP0 RTL 文件提取并核对机械合同。|
|[检查器测试](../tests/test_interaction_2_3_cp0_contract.py)|真实 RTL 正例与 priority/topology/MCIP/ACK/WFI/CLI 定向变异拒绝。|
|[README](../README.md)|Interaction 2.3 的原始交付入口。|
