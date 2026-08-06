# `xx_lsu_lfb` interaction 2.1 VCS验证入口

本环境包含13个父功能点和78个逐拍叶级场景。
本机只完成端口、场景、文档、SystemVerilog结构和依赖边界的静态preflight；
没有VCS/URG日志或VDB时，结果保持 `BLOCKED_NO_VCS`。

## 命令

```bash
make preflight
make compile
make run TEST=tc_lfb_allocate
make regress
make coverage
```

`make compile` 需要有许可证的VCS主机，`make coverage` 需要URG。standalone中
gated_clk_cell, xx_lsu_lfb_data_entry, xx_lsu_expand, xx_lsu_32bit_ecc_encode, xx_lsu_27bit_ecc_encode, xx_lsu_35bit_ecc_encode, xx_lsu_30bit_ecc_encode, xx_lsu_38bit_ecc_encode, xx_lsu_pend_addr_sel_sv 为显式兼容模型，必须在full-chip用生产定义替换，
对应边界为 `PENDING_FULL_CHIP`。计划行是动态实现合同，不代表已获得仿真或覆盖率PASS。

特别边界：仓库未提供 `srcs/xx_lsu_lfb_data_entry.sv`，本环境中的同名兼容模型保持 `PENDING_FULL_CHIP`。
