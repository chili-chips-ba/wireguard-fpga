<!--
SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba

SPDX-License-Identifier: BSD-3-Clause
-->

# eduBOS5

<p align="center">
  <a href="https://github.com/tarik-ibrahimovic/eduBOS5"><img alt="eduBOS5 logo" width="25%" src="../../../0.doc/artwork/eduBOS5.logo.png"></a>
</p>

[eduBOS5](https://github.com/tarik-ibrahimovic/eduBOS5) is Chili.CHIPS' compact RV32I RISC-V core, open source under BSD-3-Clause. The RTL here is a copy of [openPCIE's](https://github.com/chili-chips-ba/openPCIE/tree/main/2.rtl/0.common.opensource/src/CPU.eduBOS5), lint-clean and Verible-formatted. Its validation (riscv-formal, the multicycle proof, timing) is documented there.

| File | |
|---|---|
| `edubos5.sv` | the core: control FSM, decode, load/store |
| `edubos5_alu.sv` | ALU, registered output |
| `edubos5_rf.sv` | register file: 2 asynchronous read ports, 1 synchronous write port |
| `edubos5_pkg.sv` | common types and opcodes |

## In this SOC

eduBOS5 is the alternative CPU; PicoRV32 is the default until eduBOS5 waits for `dmem_rdy` on stores ([#61](https://github.com/chili-chips-ba/wireguard-fpga/issues/61), [openPCIE#40](https://github.com/chili-chips-ba/openPCIE/issues/40)). [`soc_cpu.EDUBOS5.sv`](../soc_cpu.EDUBOS5.sv) wraps it with the ports of [`soc_cpu.PICORV32.sv`](../soc_cpu.PICORV32.sv); [`1.hw/top.filelist`](../../top.filelist) picks one of the two.

- **Harvard.** Fetch uses the IMEM read port. Data loads from IMEM space (rodata, the `.data` image) use IMEM port B, which also takes the UART program writes while the CPU is held in reset. Loads and stores to DMEM and CSR go over `soc_if`.
- **Stores do not wait for ready.** A store issued while the UART holds the bus is lost: do not drive the bus from the UART (busw/busr) while a program runs.
- **Pure RV32I.** Any SYSTEM instruction (ecall, ebreak, csr*) halts the core. The firmware reads the `csr.cycle` counter instead of `rdcycle`. The firmware's two `ebreak`s (hardware-ID mismatch in `main.cpp`, heap overflow in `malloc()` in `wireguard_libs.cpp`) halt the core on purpose.
- **Reset.** The PC starts at 0. sp is not set by hardware: `2.sw/boot_crt.s` sets it.
- `` `define SOC_EDUBOS5_3STG `` selects the 3-stage pipeline (default 2-stage).

QA: `bash 3.build/hw_build.openXC7/run-lint.sh` lints the default CPU (PicoRV32), `CPU=edubos5 bash 3.build/hw_build.openXC7/run-lint.sh` eduBOS5.

-----------
#### End-of-Document
