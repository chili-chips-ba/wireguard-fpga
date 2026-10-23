<!--
SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba

SPDX-License-Identifier: BSD-3-Clause
-->

# Wireguard FPGA Build

The build process for the WireGuard project consists of three steps:
- Compilation of WireGuard control and status registers (CSR) from RDL specification into RTL for hardware design and harware abstraction layer (HAL) for software application
- Compilation of the software application for the RISC-V hardware target
- Compilation of SystemVerilog designs into bitstream for the hardware target

## CSR HAL Compilation

The WireGuard CSR HAL is auto-generated, as is the CSR RTL, using `peakrdl`. For co-simulation purposes an additional layer is auto-generated from the same SystemRDL specification using `systemrdl-compiler` that accompanies the `peakrdl` tools. This produces two header files that define a common API to the application layer for both the RISC-V platform and the *VProc* based co-simulation verification environment. The platform targetted header uses the `peakrdl c-header` output directly and unmodified. The `peakrdl` output is produced using the following command:

```
    peakrdl c-header csr_cosim.rdl -b ltoh -o csr.h
```

The `csr_cosim.rdl` is a filtered version of `3.build/csr_build/csr.rdl` that removes buffer write commands that are not understood by `systemrdl-compiler` and are not used for `c-header` generation. Other than that, the RDL is identical.

The wrapper HAL headers are generated with a Python script `sysrdl_cosim.py` which has some command line options:

```
usage: sysrdl_cosim.py [-h] [-r RDLFILE] [-o OUTFILE] [-c] [-v VPNODE] [-d DELAY] [-C CLKPERIOD]

Process command line options.

options:
  -h, --help            show this help message and exit
  -r RDLFILE, --rdl_file RDLFILE
                        Specify the RDL file for processing
  -o OUTFILE, --output_file OUTFILE
                        Specify an ouput header file
  -c, --cosim           Generate cosim header
  -v VPNODE, --vp_node VPNODE
                        Specify VProc node number for soc_cpu (cosim only)
  -d DELAY, --delay_range DELAY
                        Specify maximum delay between transactions (cosim only)
  -C CLKPERIOD, --clk_period CLKPERIOD
                        Specify the VProc soc_cpu clock period in ps (cosim only)
```

The main options used are to specify the RDL file (`-r` or `--rdl_file`) and to specify the output file (`-o` or `--output_file`). To select generation of the co-simulation header the `-c` or `--cosim` option is used, otherwise the hardware header is generated. By default the co-simulation header assumes it is running on a *VProc* node numbered 0, matching the current WireGuard test bench. However, this can be changed by using the `-v` or `--vp_node` option, should the need arise. Code running on a *VProc* virtual processor runs infinitely fast with respect to simulation time when not doing a read or write transaction to the logic. In order to emulate processing time, after each read or write access, a random delay is inserted to advance the simulation a number of ticks. The maximum number of ticks can be specified using the `-d` or `--delay_range` option meaning the delay can range from 0 to `DELAY` clock cycles. The default for this is 32 clock cycles. The `-v` and `-d` options have no affect if the `-c` option is not used. Finally the *VProc* test bench `soc_cpu` module's clock period in picoseconds can be specified for use in co-simulation abstraction of delay and timing functions. It defaults to 18518 (54 MHz), not the 12500 of the 80 MHz system clock (`4.sim/tb.sv`, `HALF_PERIOD_OTHER_BFMS_PS` = 6250); see [#64](https://github.com/chili-chips-ba/wireguard-fpga/issues/64).

To generate all the required HAL headers and RTL a make file is provided as `3.build/MakefileCSR` to wrap app the script calls. Running this make file (`make -f MakefileCSR`) produces the following files in `3.build/csr_build/generated-files`:

  * `csr_cosim.rdl` : The intermediate filtered RDL specification
  * `csr.sv`        : The RTL for hardware target
  * `csr_pkg.sv`    : The structured RTL interface for hardware target
  * `csr.h`         : The `peakrdl c-header` output file used by the target header
  * `csr_hw.h`      : The HAL for the RISC-V hardware target (and for the *rv32* ISS), which uses `csr.h`
  * `csr_cosim.h`   : The HAL for the *VProc* based WireGuard logic simulation test bench

The `csr_hw.h` and `csr_cosim.h` files present the same API to the application and can be appropriately selected at compile time using something like the following:

```
#ifdef VPROC
#include "csr_cosim.h"
#else
#include "csr_hw.h"
#endif
```
This has been done in the `wireguard_regs.h` header in the `3.build/csr_build/generated-files/` directory, and including this header in the application code makes available the register HAL.

## SW Compilation

To generate binaries (elf, bin, hex) and instruction memory (IMEM) Verilog configuration file (imem.INIT.vh) a make file is provided as `3.build/MakefileSW`. Running this make file (`make -f MakefileSW`) produces the following files in `3.build/sw_build`:

  * `main.lds`      : The compiled Linker/MemoryMapper script
  * `main.map`      : The memory map for debugging
  * `main.elf`      : The ELF file for RISC-V hardware target
  * `main.hex`      : The HEX programming file for RISC-V hardware target
  * `main.bin`      : The raw binary file
  * `main.dump`     : The disassembly of the ELF file
  * `imem.INIT.vh`  : The IMEM Verilog configuration file
  
Additionally, `MakefileSW` supports running a Python script `imem.UART.py` to program the IMEM on a hardware target that is already configured (using the bitstream resulting from the HW compilation) and running. This script uses UART to transfer the generated binary/hex file (as described in the [UART Data Flow](/1.hw/README.md#uart-data-flow)) and facilitates software testing without the need for resynthesis and FPGA reconfiguration. It is launched as follows:

```
make -f MakefileSW program
```

## HW Compilation - Vivado

The main hardware synthesis/PnR tool is Vivado Design Suite, using the prepared [project file](/3.build/hw_build.Vivado/wireguard.xpr) project located at `3.build/hw_build.Vivado`.

To run synthesis, place-and-route (PnR), and generate the FPGA bitfile, execute:

```
make -f MakefileHW
```

After the bitfile has been successfully generated, the FPGA device can be programmed using:

```
make -f MakefileHW program
```

## HW Compilation - openXC7

Ported to openXC7 v1.0.0 (Yosys 0.69 + nextpnr-himbaechel) on 2026-10-21. The older nextpnr-xilinx flow follows below as the [legacy flow](#legacy-flow-pre-v100-nextpnr-xilinx-toolchainold).

### openXC7 v1.0.0 (default)

**Toolchain:** openXC7 v1.0.0, built with [`toolchain-installer`](https://github.com/openXC7/toolchain-installer): Yosys 0.69 with `read_slang`, nextpnr-himbaechel (called through openXC7's `nextpnr-xilinx` shim), prjxray-db and `fpga-as`. Point `NEXTPNR_XILINX_DIR` at its install prefix, or put its `bin` on `PATH`.

**Build:**
```bash
cd wireguard-fpga/3.build
make -f MakefileSW               # firmware first: hw_build needs sw_build/imem.INIT.vh
cd hw_build.openXC7
make check-env check-sources     # tools and sources present
make                             # -> build_artifacts.slang/top.bit
```

- The frontend is `read_slang`: Yosys reads the SystemVerilog directly. `make FRONTEND=sv2v` converts it with sv2v first.
- The sources come from `1.hw/top.filelist`, the list Vivado, `4.sim` and `run-lint.sh` use. The CPU is the one it lists: PicoRV32 by default, eduBOS5 as the alternative.
- The chipdb (`chipdb.new/xc7a200tfbg484-2.bin`) is generated on the first run. It is per die, so a chipdb built for another `xc7a200t` part can be copied under this name.
- nextpnr reads only the port constraints of `1.hw/constraints/top.xdc` (#51), plus `top.openxc7.xdc` with the `clk_n` pin (#52). A Yosys techmap, `bufgmux_map.v`, builds each `BUFGMUX` from a `BUFGCTRL` (#50); openXC7 `main` maps `BUFGMUX` itself (nextpnr#132), so the techmap goes with the next release.
- Place and route uses `--tmg-ripup --placer-heap-timingweight 30` (`NEXTPNR_OPTS`). With nextpnr's defaults the Ethernet RX clocks land at 102-128 MHz, depending on the seed.

**Result (2026-10-21):** about 9.5 minutes, 3 GB RAM; every clock meets its constraint with PicoRV32, the default CPU, at `SEED=3` (the Makefile default), and with eduBOS5 at `SEED=1`. The table is the eduBOS5 run. Seed sweep for PicoRV32 ([#48](https://github.com/chili-chips-ba/wireguard-fpga/issues/48)): seed 1 misses `u_eth_2` RX (108.7 MHz), seed 2 misses `u_eth_1` RX (121.0 MHz) and `sys_clk` (69.8 MHz), seed 3 passes all (`sys_clk` 83.1 MHz, RX 125.6-131.8 MHz), seed 4 misses `sys_clk` (77.3 MHz). **Rechecked 2026-10-23 at `40c8664`:** seed 3 now misses `sys_clk` (74.4 MHz) and `u_eth_3` RX (108.1 MHz); a new seed sweep is pending (#48).

| Clock | Max frequency | Constraint |
|---|---|---|
| `sys_clk` (CPU, SoC) | 82.6 MHz | 80 MHz |
| Ethernet RX, 4 ports | 127.2-136.5 MHz | 125 MHz |
| Ethernet TX, 4 ports | 171.8-201.2 MHz | 125 MHz |
| `eth_gtx_clk` | 158.3 MHz | 125 MHz |

Use: 17,700 LUTs (6%), 9,347 FFs (3%), 34 RAMB36 + 1 RAMB18, 10 of 32 BUFGCTRL, 2 PLLs. The RX margins are thin, and nextpnr's timing analysis is simpler than Vivado's ([openXC7/nextpnr#42](https://github.com/openXC7/nextpnr/issues/42)): not yet tried on the board.

### Legacy flow: pre-v1.0.0 nextpnr-xilinx (`TOOLCHAIN=old`)

The instructions below are for the earlier flow (2025-12): the nextpnr-xilinx toolchain, sv2v and `build_artifacts/top.bit`. With the current Makefile run it as `make TOOLCHAIN=old PREFIX=<that installation>`.

#### openXC7 Installation

Complete installation instructions for the openXC7 toolchain are available here:
https://github.com/chili-chips-ba/openeye-CamSI/blob/main/3.build/openXC7/README.md

The openXC7 toolchain provides open-source FPGA synthesis and place-and-route tools for Xilinx 7-series FPGAs, including:
- **Yosys** - RTL synthesis
- **nextpnr-xilinx** - Place and route
- **Project X-Ray** - FPGA bitstream generation tools

Make sure to source the environment setup script before building:
```bash
source /opt/openxc7/setup_env.sh
```

#### sv2v Installation

The SystemVerilog to Verilog converter (`sv2v`) is required to convert the project's SystemVerilog files to pure Verilog.

**Automated installation:**
```bash
cd wireguard-fpga/3.build/hw_build.openXC7
make install-sv2v
```

This will:
1. Install Stack (Haskell build tool)
2. Clone the sv2v repository
3. Build sv2v from source
4. Install to `~/.local/bin/`
5. Configure your PATH

After installation, reload your environment:
```bash
source ~/.bashrc
sv2v --version
```

Manual verification:
```bash
make check-sv2v
```

---

#### Build Process

##### Step 1: Build Software (Firmware)

**IMPORTANT:** The software must be built first to generate the `imem.INIT.vh` file required by the hardware build.

##### Step 2: Convert SystemVerilog to Verilog

Navigate to the hardware build directory:
```bash
cd wireguard-fpga/3.build/hw_build.openXC7
```

Run the conversion:
```bash
make convert
```

This performs two operations:
1. **Batch conversion** - All SystemVerilog files are processed together (preserves dependencies)
2. **Module extraction** - The unified output is split into individual Verilog module files

Output is generated in:
- `converted/all_converted.v` - Unified Verilog output
- `converted/extracted/*.v` - Individual module files

**Verify conversion:**
```bash
make show-converted
```

---

##### Step 3: Build Bitstream

**Full build (synthesis → place & route → bitstream):**
```bash
make all
```

This executes the complete FPGA build flow:
1. **Yosys synthesis** - Converts RTL to gate-level netlist
2. **Chipdb generation** - Creates device database (first run only)
3. **nextpnr-xilinx** - Place and route
4. **Bitstream generation** - Creates `build_artifacts/top.bit`

**Output:**
```
build_artifacts/top.bit
```

---

##### Additional Commands

The Makefile provides many utility targets. View all available options:

```bash
make help
```

---

##### Troubleshooting

##### Environment not set up
```
ERROR: Please run: source /opt/openxc7/setup_env.sh
```
**Solution:** Source the environment script before running make.

##### sv2v not found
```
ERROR: sv2v not found!
```
**Solution:** Run `make install-sv2v` or install manually.

##### Missing imem.INIT.vh
```
ERROR: imem.INIT.vh not found
```
**Solution:** Build the software first (`make -f MakefileSW` from `3.build/`).

##### Quick Start Summary

```bash
# 1. Install openXC7 toolchain
# (See: https://github.com/chili-chips-ba/openeye-CamSI/blob/main/3.build/openXC7/README.md)

# 2. Install sv2v
cd wireguard-fpga/3.build/hw_build.openXC7
make install-sv2v
source ~/.bashrc

# 3. Build software
cd ../
make -f MakefileSW

# 4. Build hardware
cd hw_build.openXC7
source /opt/openxc7/setup_env.sh
make all

# Result: build_artifacts/top.bit
```

---

##### Notes

- **First build** will take longer due to chipdb generation for the xc7a200tfbg484-2 device
- **Chipdb is cached** and reused for subsequent builds
- **Conversion is incremental** - only re-runs if source files change
- The build uses **~24 SystemVerilog modules** converted to Verilog plus **~14 pure Verilog modules** from external libraries
- **Total source files:** ~38 modules + packages/interfaces

---

For openXC7 toolchain issues, refer to the main installation guide:
https://github.com/chili-chips-ba/openeye-CamSI/blob/main/3.build/openXC7/README.md

### openXC7 issues

Each issue is filed with us and upstream, each pointing to the other.

| Issue | Toolchain | Status | Ours | Upstream | Workaround |
|---|---|---|---|---|---|
| No mapping for `BUFGMUX` | v1.0.0 | fixed in `main` ([nextpnr#132](https://github.com/openXC7/nextpnr/pull/132)), not released | [#50](https://github.com/chili-chips-ba/wireguard-fpga/issues/50) | [nextpnr#125](https://github.com/openXC7/nextpnr/issues/125) | `hw_build.openXC7/bufgmux_map.v`: a `BUFGCTRL` after synthesis. On v1.0.0 its `IGNORE` bits come out inverted, so the mux switches asynchronously |
| XDC targets other than `get_ports`/`get_cells` abort | v1.0.0 | open | [#51](https://github.com/chili-chips-ba/wireguard-fpga/issues/51) | [nextpnr#126](https://github.com/openXC7/nextpnr/issues/126) | the Makefile passes nextpnr only the `get_ports` lines of `top.xdc` |
| Differential input needs its N pin constrained | v1.0.0 | open | [#52](https://github.com/chili-chips-ba/wireguard-fpga/issues/52) | [nextpnr#127](https://github.com/openXC7/nextpnr/issues/127) | `hw_build.openXC7/top.openxc7.xdc`: `clk_n` on T4 |
| Port to v1.0.0; sv2v fails on `picorv32_pcpi_*.sv` | v1.0.0 | open | [#48](https://github.com/chili-chips-ba/wireguard-fpga/issues/48) | - | `read_slang` frontend; unused PCPI files out of the build |
| `BUFGMUX` not supported | legacy | closed | [#35](https://github.com/chili-chips-ba/wireguard-fpga/issues/35) | [nextpnr-xilinx#75](https://github.com/openXC7/nextpnr-xilinx/issues/75) | fixed upstream (nextpnr-xilinx#81) |
| `IBUFGDS` not supported | legacy | closed | [#36](https://github.com/chili-chips-ba/wireguard-fpga/issues/36) | [nextpnr-xilinx#74](https://github.com/openXC7/nextpnr-xilinx/issues/74) | `IBUFDS` + `BUFG` |
| `IOBUFGDS`, `PLLE2_BASE` not supported | legacy | closed | [#34](https://github.com/chili-chips-ba/wireguard-fpga/issues/34) | [nextpnr-xilinx#73](https://github.com/openXC7/nextpnr-xilinx/issues/73) | Yosys 0.38 -> 0.60 |

### Test example

Results with the legacy toolchain (nextpnr-xilinx, 2025-12). With v1.0.0, `BUFGMUX` stays in the design, mapped to `BUFGCTRL` (#50).

In this section, we present a simple test example to illustrate the differences between two FPGA toolchains. First, the design is synthesized and routed using Vivado, serving as a reference implementation. The same example is then processed using the openXC7 toolchain, allowing a direct comparison of synthesis and place-and-route results, as well as highlighting key differences in workflow and outputs.

Note: Complete hardware is synthesised and routed, but [application](https://github.com/chili-chips-ba/wireguard-fpga/blob/main/2.sw/app/main.cpp) running on the processor is simply testing ICMP and ARP.

#### Vivado
Build duration (synthesis + PnR): 8 minutes

##### Test result:
<img width="1401" height="556" alt="image" src="https://github.com/user-attachments/assets/4ddf11f0-bbcc-4d05-a056-c4bd6afb5585" />

- Putty: App is running, ICMP and ARP logs can be seen.
- PowerShell: All 4 messages are received successfully - no faulty packets.
- Wireshark: Ping request/replies can be seen.

#### openXC7
Build duration (synthesis + PnR): 1 minute

To support openXC7, besides multiple minor changes, 2 main Xilinx primitives needed to be adapted/removed:

- IBUFGDS (adapted: IBUFDS + BUFG): [(openXC7/nextpnr-xilinx) Missing primitive support - IBUFGDS](https://github.com/chili-chips-ba/wireguard-fpga/issues/36)
- BUFGMUX (removed): [(openXC7/nextpnr-xilinx) Missing primitive support - BUFGMUX](https://github.com/chili-chips-ba/wireguard-fpga/issues/35)

##### Test result 1:
<img width="1537" height="675" alt="image" src="https://github.com/user-attachments/assets/474b38a8-311e-43b2-84ff-cf4a3f8ab31e" />

- Putty: App is running, ICMP and ARP logs can be seen.
- PowerShell: All 4 messages are received successfully - no faulty packets.
- Wireshark: Ping request/replies can be seen.

##### Test result 2:
<img width="1188" height="635" alt="image" src="https://github.com/user-attachments/assets/cb022fef-55d3-4513-b416-ee52fdef2085" />

- Putty: App is running, ICMP and ARP logs can be seen.
- PowerShell: No messages are received successfully - all packets are faulty.
- Wireshark: Ping request can be seen - no replies.

##### Test result 3:
<img width="1544" height="473" alt="image" src="https://github.com/user-attachments/assets/c9d5c51f-b2b0-43ce-899f-45b7df54d6b6" />

- Putty: App is running, ICMP and ARP logs can be seen.
- PowerShell: Only 1 message is received successfully - 3 faulty packets.
- Wireshark: Ping request/replies can be seen.
 
#### Key difference
The main reason for this behaviour difference is the missing BUFGMUX primitive. This can be really problematic in many cases, because for the clock selection LUT would have to be used instead of BUFGMUX (clock doesn't go through clock network), which will certainly lead to delays.

The delays can be seen in the examples above, which is the reason why some requests don't have adequate replies!
