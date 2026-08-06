# `xx_lsu_rb` interaction 2.1 VCS验证入口

本环境包含12个父功能点和72个逐拍叶级场景。
本机只完成端口、场景、文档、SystemVerilog结构和依赖边界的静态preflight；
没有VCS/URG日志或VDB时，结果保持 `BLOCKED_NO_VCS`。

## 命令

```bash
make preflight
make compile
make run TEST=tc_rb_capacity
make regress
make coverage
```

`make compile` 需要有许可证的VCS主机，`make coverage` 需要URG。standalone中
gated_clk_cell, xx_lsu_compare_iid, xx_lsu_rb_data, xx_lsu_encode, xx_lsu_idfifo_32, xx_lsu_pend_addr_sel_32, xx_lsu_rot_data, xx_lsu_rot_us_data 为显式兼容模型，必须在full-chip用生产定义替换，
对应边界为 `PENDING_FULL_CHIP`。计划行是动态实现合同，不代表已获得仿真或覆盖率PASS。
