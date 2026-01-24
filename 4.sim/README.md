<!--
SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
SPDX-FileCopyrightText: 2026 Simon Southwell

SPDX-License-Identifier: BSD-3-Clause
-->

# Wireguard FPGA Simulation Test Bench

## Table of Contents

* [Introduction](#introduction)
* [Auto-selection of soc_cpu Component](#auto-selection-of-soc_cpu-component)
* [_VProc_ Software](#vproc-software)
  * [Other Software Use Cases](#other-software-use-cases)
    [Natively Compiled Application](#natively-compiled-application)
    [RISC-V Compiled Application](#risc-v-compiled-application)
* [Building and Running Code](#building-and-running-code)
  * [Configuring ISS timing model](#configuring-iss-timing-model)
  * [Running ISS code](#running-iss-code)
* [PicoRV32 RTL-Only Simulation Makefile](#picorv32-rtl-only-simulation-makefile)
* [Debugging Code](#debugging-code)
  * [Natively Compiled Code](#natively-compiled-code)
  * [ISS Software](#iss-software)
* [The mem_model Co-Simulation Sparse Memory Model](#the-mem_model-co-simulation-sparse-memory-model)
* [Driving the Wireguard Logic Ethernet Ports](#driving-the-wireguard-logic-ethernet-ports)
  * [_udpIpPg_ Software](#udpippg-software)
  + [System-Level Ethernet Simulation](#system-level-ethernet-simulation)
* [Co-simulation HAL](#co-simulation-hal)
* [Tool Versions](#tool-versions)
* [References](#references)

## Introduction

The Wireguard FPGA test bench aims to have a flexible approach to simulation which allows a common test envoironment to be used whilst selecting between alternative CPU components, one of which uses the [_VProc_ virtual processor](https://github.com/wyvernSemi/vproc) co-simulation element. This allows simulations to be fully HDL, with a RISC-V processor RTL implementation such as picoRV32, IBEX, or EDUBOS5, or to co-simulate software using the virtual processor, with a significant speed up in simulation times.

The _VProc_ component is wrapped up into an [`soc_cpu.VPROC`](4.sim/models/README.md#soc-cpu-vproc) component with identical interfaces to the RTL. Some conversion logic is added to this BFM to convert between _VProc_'s generic memory mapped interface and the <tt>soc_if</tt> defined interface. This is very lightweight logic, with less than ten combinatorial gates to match the control signals. In addition, the <tt>soc_cpu.VPROC</tt> component has a [<tt>mem_model</tt>](4.sim/models/cosim/README.md) component instantiated. This is a 'memory port' to the [<tt>mem_model</tt>](https://github.com/wyvernSemi/mem_model) C software implementation of a sparse memory model, allowing updates to the RISC-V program, if using the rv32 RISC-V ISS model ([see below](#risc-v-compiled-application)). The diagram below shows a block diagram of the test bench HDL.

<p align="center">
<img src="https://github.com/user-attachments/assets/98cb3a19-11c7-4470-a4e1-41c503429e14" width=800>
</p>

Shown in the diagram is the Wireguard FPGA top level component (<tt>top</tt>) with the <tt>soc_cpu.VPROC</tt> component instantiated in it as one of three possible selected devices for the soc_cpu. The IMEM write port is connected to the UART for program updates and the <tt>soc_if</tt> from  <tt>soc_cpu.VPROC</tt> is connected to the interconnect fabric (<tt>soc_fabric</tt>), just as for the two RTL components. The test bench around the top level Wireguard component has a driver for the UART (<tt>bfm_uart</tt>) and the four GMII/RGMII interfaces (including MDIO signals) coming from the Wireguard core to some verification IP (`bfm_ethernet`) to drive this signalling. This BFM implementation is based around the [_udpIpPg_](https://github.com/wyvernSemi/udpIpPg) GMII/RGMII VProc based VIP. In addtion there are MDIO slave models for reading and writing over the PHY MDIO signals from Wireguard, and these also read and write to allocated _VProc_ memory for access by _VProc_ `soc_cpu` code. MDIO registers access are displayed to the console as well, for logging purpose, displaying the name of the clause 22 register accessed. Finally the test bench generates clocks and key press resets that go to the top level's <tt>clk_rst_gen</tt> and <tt>debounce</tt> components.

## VerilatorSimCtrl (interactive run control)

What it does:
- Interactive CLI inside the simulation (node 15) for `run/for/until/finish` and forces `wave.fst` flush so GTKWave sees fresh samples without restarting.
- Opens GTKWave in a separate thread (see `GTKWAVEOPTS` and `WAVESAVEFILE` in `MakefileVProc.mk`).

- Reload GTKWave to view new samples: `File -> Reload Waveform` (or `Ctrl+Shift+R`), then zoom/end to the latest time.

How to enable:
- Pass `DISABLE_SIM_CTRL=0`, e.g.:  
  `make -f MakefileVProc.mk BUILD=ISS DISABLE_SIM_CTRL=0 rungui`
- `DISABLE_SIM_CTRL=1` disables it (default). Instance is in `tb.sv` (node 15).

Key commands at the `VerSimCtrl>` prompt:
- `run for <N> <units>` (e.g., `run for 100 ns`, `run for 500 cycles`)
- `run until <N> <units>` (e.g., `run until 5 us`)
- `continue`/`c` — same as `run`
- `finish`/`quit`/`exit` — ends simulation (`$finish`)
- Units: `ps | ns | us | ms | s | cycle(s)`; default is cycles if omitted.
- Each command flushes waves; in GTKWave hit reload + zoom-to-end to see the new range.

## Auto-selection of soc_cpu Component

The Wireguard's top level component has the required RTL files listed in <tt>1.hw/top.filelist</tt>. This includes files for the soc_cpu, under the directory <tt>ip.cpu</tt>. The simulation build make file ([see below](#building-and-running-code)) will process the <tt>top.filelist</tt> file to generate a new local copy, having removed all references to the files under the <tt>ip.cpu</tt> directory. Since the VProc <tt>soc_cpu</tt> component is a test model, the <tt>soc_cpu.VPROC.sv</tt> HDL file is placed in <tt>4.sim/models</tt> whilst the rest of the HDL files come from the VProc and mem_model repositories (auto-checked out by the make file, if necessary). These are referenced within the make file, along with the other test models that are used in the test bench. Thus the VProc device is selected for the simulation as the CPU component.

## VProc Software

The VProc software consists of DPI-C code for communication and sycnronisation with the simulation, for both the memory model and VProc itself. On top of this are the APIs for VProc and mem_model for use by the running code. In the case of VProc there is a low level C API) or, if preferred, a C++ API. In Wireguard, the VProc <tt>soc_cpu</tt> is node 0, and so the entry point for user software is <tt>VUserMain0</tt>, in place of <tt>main</tt>.

The _VProc_ software is compiled into libraries located in `4.sim/models/cosim/lib`, with the headers in `4.sim/models/cosim/include (see [here](models/cosim/README.md) for more details). The C++ API is defined in a class <tt>VProc</tt> (defined in <tt>VProcClass.h</tt>), and a constructor creates an API object, defining the node for which it is connected:

```c++
VProc (const uint32_t node);
```

For the C++ VProc API there are two basic word access methods:

```c++
    int  write (const unsigned   addr, const unsigned    data, const int delta=0);
    int  read  (const unsigned   addr,       unsigned   *data, const int delta=0);
```

For these methods, the address argument is agnostic to being a byte address or a word address, but for the Wireguard implementation these are **byte addresses**. The delta argument is unused in Wireguard, and should be left at its default value, with just the address and data arguments used in the call to these methods. Along with these basic methods is a method to advance simulation time without doing a read or write transaction.

```c++
int  tick (const unsigned ticks);
```
This method's units of the <tt>ticks</tt> argument are in clock cycles, as per the clock that the VProc HDL is connected to. A basic VProc program, then, is shown below:

```c++
#include "VProcClass.h"
extern "C" {
#include "mem.h"
}

static const int node    = 0;

extern "C" void VUserMain0(void)
{
    // Create VProc access object for this node
    VProc* vp0 = new VProc(node);

    // Wait a bit
    vp0->tick(100);

    uint32_t addr  = 0x10001000;
    uint32_t wdata = 0x900dc0de;

    vp0->write(addr, wdata);
    VPrint("Written   0x%08x  to  addr 0x%08x\n", wdata, addr);

    vp0->tick(3);

    uint32_t rdata;
    vp0->read(addr, &rdata);

    if (rdata == wdata)
    {
        VPrint("Read back 0x%08x from addr 0x%08x\n", rdata, addr);
    }
    else
    {   VPrint("***ERROR: data mis-match at addr = 0x%08x. Got 0x%08x, expected 0x%08x\n", addr, rdata, wdata);
    }

    // Sleep forever
    while(true)
        vp0->tick(GO_TO_SLEEP);
}
```
The above code is a slightly abbreviated version of the code in <tt>4.sim/usercode</tt>. Note that the <tt>VUserMain0</tt> function must have C linkage as the VProc software that calls it is in C (as all the programming logic interfaces, including DPI-C, are C). The API also has a set of other methods for finer access control which are listed below, and more details can be found in the [VProc manual](https://github.com/wyvernSemi/vproc/blob/master/doc/VProc.pdf).

```c++
    int  writeByte    (const unsigned   byteaddr, const unsigned    data, const int delta=0);
    int  writeHword   (const unsigned   byteaddr, const unsigned    data, const int delta=0);
    int  writeWord    (const unsigned   byteaddr, const unsigned    data, const int delta=0);
    int  readByte     (const unsigned   byteaddr,       unsigned   *data, const int delta=0);
    int  readHword    (const unsigned   byteaddr,       unsigned   *data, const int delta=0);
    int  readWord     (const unsigned   byteaddr,       unsigned   *data, const int delta=0);

```
The other methods is this class are not, at this point, used by Wireguard. These methods can now be used to write test code to drive the <tt>soc_if</tt> bus of the <tt>soc_cpu</tt> component, and is the basic method to write test code software. As well as the VProc API, the user software can have direct access to the sparse memory model API by including <tt>mem.h</tt>, which are a set of C methods (and <tt>mem.h</tt> must be included as <tt>extern "C"</tt> in C++ code). The functions relevant to Wireguard are shown below:

```c++
void     WriteRamByte  (const uint64_t addr, const uint32_t data, const uint32_t node);
void     WriteRamHWord (const uint64_t addr, const uint32_t data, const int little_endian, const uint32_t node);
void     WriteRamWord  (const uint64_t addr, const uint32_t data, const int little_endian, const uint32_t node);
uint32_t ReadRamByte   (const uint64_t addr, const uint32_t node);
uint32_t ReadRamHWord  (const uint64_t addr, const int little_endian, const uint32_t node);
uint32_t ReadRamWord   (const uint64_t addr, const int little_endian, const uint32_t node);
```

Note that, as C functions, there are no default parameters and the <tt>little_endian</tt> and <tt>node</tt> arguments must be passed in, even though they are constant. The <tt>little_endian</tt> argument is non-zero for little endian and zero for big endian. The <tt>node</tt> argument is **not** the same as for VProc, but allows multiple separate memory spaces to be modelled, just as for VProc multiple virtual processor instantiations. For Wireguard, this is always 0. All instantiated <tt>mem_model</tt> components in the HDL have (through the DPI) access to the same memory space model as the API, and so data can be exchanged from the simulation and the running code, such as the RISC-V programs over the IMEM write interface.

Compiling co-designed application code, either compiled for the native host machine, or to run on the <tt>rv32</tt> RISC-V ISS will need further layers on top of these APIs, which will be virtualised away by that point ([see the sections below](#co-simulation-hal)). The diagram below summarises the software layers that make up a program running on the VProc HDL component. The "native test code" use case, shown at the top left, is for the case just described above  that use the APIs directly.

<p align="center">
<img src="https://github.com/user-attachments/assets/373676ee-f7e2-4a1a-b9b9-079ccef90c37" width=800>
</p>

### Other Software Use Cases

#### Natively Compiled Application

As well as the native test code case seen in the previous section, the Wireguard application can be compiled natively for the host machine, including the hardware access layer (HAL), generated from SystemRDL. The HAL software output from this is processed to generate a version that makes accesses to the VProc and mem_model APIs in place of accesses with pointers to and from memory (see the [Co-simulation HAL](#co-simulation-hal) section below). The rest of the application software has these details hidden away in the HAL and sees the same API as presented by the auto-generated code. In both cases transactions happen on the <tt>soc_if bus</tt> port of the <tt>soc_cpu</tt> component. The <tt>main</tt> entry point is also swapped for <tt>VUserMain0</tt>.

#### RISC-V Compiled Application

To execute RISC-V compiled application code, the <tt>rv32</tt> instruction set simulator is used as the code running on the virtual processor. The <tt>VUserMain0</tt> program now becomes software to creates an ISS object and integrate with VProc. This uses the ISS's external memory access callback function to direct loads and stores either towards the sparse memory model, the VProc API for simulation transactions, or back to the ISS itself to handle. This ISS integration <tt>VUserMain0</tt> program is located in <tt>4.sim/models/rv32/usercode</tt>. When built the code here is compiled and uses the pre-built library in <tt>4.sim/models/rv32/lib/librv32lnx.a</tt> containing the ISS, with the headers for it in <tt>4.sim/models/rv32/include</tt>. More details of the integration code and methods can be found [here](models/rv32/README.md).

The ISS supports interrupts, but these are not currently used on Wireguard. The integration software can read a configuration file, if present in the <tt>4.sim/</tt> directory, called <tt>vusermain.cfg</tt>. This allows the ISS and other features to be configured at run-time. The configuration file is in lieu of command line options and the entries in the file are formatted as if they were such, with a command matching the VUserMain program:

```
vusermain0 [options]
```
One of the options is <tt>-h</tt> for a help message, which is as shown below:
```
Usage:vusermain0 -t <test executable> [-hHebdrgxXRcI][-n <num instructions>]
      [-S <start addr>][-A <brk addr>][-D <debug o/p filename>][-p <port num>]
      [-l <line bytes>][-w <ways>][-s <sets>][-j <imem base addr>][-J <imem top addr>]
      [-P <cycles>][-x <base addr>][-X <top addr>][-V <core>]
   -t specify test executable/binary file (default test.exe)
   -B specify to load a raw binary file (default load ELF executable)
   -L specify address to load binary, if -B specified (default 0x00000000)
   -n specify number of instructions to run (default 0, i.e. run until unimp)
   -d Enable disassemble mode (default off)
   -r Enable run-time disassemble mode (default off. Overridden by -d)
   -C Use cycle count for internal mtime timer (default real-time)
   -a display ABI register names when disassembling (default x names)
   -T Use external memory mapped timer model (default internal)
   -H Halt on unimplemented instructions (default trap)
   -e Halt on ecall instruction (default trap)
   -E Halt on ebreak instruction (default trap)
   -b Halt at a specific address (default off)
   -A Specify halt address if -b active (default 0x00000040)
   -D Specify file for debug output (default stdout)
   -R Dump x0 to x31 on exit (default no dump)
   -c Dump CSR registers on exit (default no dump)
   -g Enable remote gdb mode (default disabled)
   -p Specify remote GDB port number (default 49152)
   -S Specify start address (default 0)
   -I Enable instruction cache timing model (default disabled)
   -l Specify number of bytes in icache line (default 8)
   -w Specify number of ways in icache (default 2)
   -s Specify number of sets in icache (default 256)
   -j Specify cached IMEM base address (default 0x00000000)
   -J Specify cached IMEM top address (default 0x7fffffff)
   -P Specify penalty, in cycles, of one slow mem access (default 4)
   -x Specify base address of external access region (default 0xFFFFFFFF)
   -X Specify top address of external access region (default 0xFFFFFFFF)
   -V Specify RISC-V core timing model to use (default "DEFAULT")
   -h display this help message
```
With these options the model can load an elf executable to memory directly and be set up with some execution termination conditions. Disassembly output can also be switched on and registers dumped on exit. More details of all these features can be found in the <tt>rv32</tt> [ISS manual](https://github.com/wyvernSemi/riscV/blob/main/iss/doc/iss_manual.pdf).

Specific to the Wireguard project is the ability to specify the region where memory loads and stores will make external simulation transactions rather than use internal memory modelling or peripherals, using the <tt>-x</tt> and <tt>-X</tt> options. This is useful to allow access to the CSR registers in the HDL whilst mapping all of the memory internal using the sparse C memory model of <tt>mem_model</tt>. The cache model can be enabled with the <tt>-I</tt> option and the cache configured. The <tt>-l</tt> option specifies the number of bytes in a cache line, which can be 4, 8 or 16. The number of ways is set with <tt>-w</tt> and can be either 1 or 2, and the number of sets is specified with the <tt>-s</tt> options and can be 128, 256, 512 or 1024. The Wireguard project also has the option to load a raw binary file to memory in place of reading an ELF file. The <tt>-B</tt> selects this mode (with the <tt>-t</tt> still specifying the file name), and the load address can be changed from 0 with the <tt>-L</tt> option. A set of pre-configured timing models can be specified with the <tt>-V</tt> option. The argument must be one of the following:

* DEFAULT
* PICORV32
* EDUBOS5STG2
* EDUBOS5STG3
* IBEXMULSGL
* IBEXMULFAST
* IBEXMULSLOW

This reflects the available models as detailed in the _Configuring ISS timing model_ section below.

## Building and Running Code

A <tt>MakefileVProc.mk</tt> file is provided in the <tt>4.sim/</tt> directory to compile the user *VProc* software, for both the `soc_cpu` and _udpIpPg_ components, and to build and run the test bench HDL. The make file will compile all the user code or, where an ISS build is selected (see make file variables below) the provided `soc_cpu` user code that's the _rv32_ ISS integration software. By default, the make file will compile the <tt>VUserMain0.cpp</tt> user code for `soc_cpu` and `VUserMainUdp.cpp` for _udpIpPg_ located in <tt>4.sim/usercode</tt>, but the directory and list of files to compile can be specified on the command line (see below). The `VUserMainUdp.cpp` file contains the `VUserMain<n>` entry points for all four instantiated _udpIpPg_ modules (nodes 1 to 4). To alter which files to compile, the make file `USER_C` variable can be updated to list a set of C++ files for the `soc_cpu`. Similarly, the `UDP_C` variable can be updated with a list of files for the Ethernet components. The location of the source files is in the variable `USRCODEDIR`, which may also be altered. Any modifications can be done to the make file itself, or on the command line. E.g., to add additional files to the `soc_cpu` build:

```
make -f MakefileVProc.mk USER_C="VUserMain0.cpp MyTest1Class.cpp"
```

If many variants of software build are required then either scripts can be constructed with the various command line variable modification calls to `make` or other make files which set these varaiable and call the common make file. This is useful in managing source code for multiple tests located in different directories, compiling for ISS (perhaps also calling the RISC-V application build), or for compiling application code natively which will have a different set of source files.

The user software is compiled into a local static library, <tt>libuser.a</tt> which is linked to the simulation code within Verilator along with the precompiled <tt>libcosimlnx.a</tt> (or <tt>libcosimwin.a</tt> for MSYS2/mingw64 on Windows) located in <tt>4.sim/models/cosim/lib</tt> and containing the precompiled code for *VProc* and *mem_model*. The headers for the *VProc* and *mem_model* API software are in <tt>4.sim/models/cosim/include</tt>. The HDL required for these models' use in the Wireguard trest bench can be found in <tt>4.sim/models/cosim</tt>, and the make file picks these up from there to compile with the rest of the test bench HDL.

The <tt>MakefileVProc.mk</tt> make file has a target <tt>help</tt>, which produces the following output:

```
make -f MakefileVProc.mk help          Display this message
make -f MakefileVProc.mk               Build C/C++ and HDL code without running simulation
make -f MakefileVProc.mk run           Build and run batch simulation
make -f MakefileVProc.mk rungui/gui    Build and run GUI simulation
make -f MakefileVProc.mk clean         clean previous build artefacts

Command line configurable variables:
  USER_C:       list of user source code files (default VUserMain0.cpp)
  UDP_C:        list of user source code files (default VUserMainUdp.cpp)
  USRCODEDIR:   directory containing user source code (default $(CURDIR)/usercode)
  OPTFLAG:      Optimisation flag for user VProc code (default -g)
  TIMINGOPT:    Verilator timing flags (default --timing)
  TRACEOPTS:    Verilator trace flags (default --trace-fst --trace-structs)
  TOPFILELIST:  RTL file list name (default top.filelist)
  SOCCPUMATCH:  string to match for soc_cpu filtering in h/w file list (default ip.cpu)
  USRSIMOPTS:   additional Verilator flags, such as setting generics (default blank)
  WAVESAVEFILE: name of .gtkw file to use when displaying waveforms (default waves.gtkw)
  BUILD:        Select build type from DEFAULT or ISS (default DEFAULT)
  TIMEOUTUS:    Test bench timeout period in microseconds (default 15000)
```

By default, without a named target, the simulation executable will be built but not run. With a <tt>run</tt> target, the simulation executable is built and then executed in batch mode. To fire up waveforms after the run, a target of <tt>rungui</tt> or </tt>gui</tt> can be used. A target of <tt>clean</tt> removes all intermediate files of previous compilations.

The make file has a set of variables (with default settings) that can be overridden on running <tt>make</tt>. E.g. <tt>make VAR=NewVal</tt>. The help output shows these variables with brief decriptions. Entries with multiple values should be enclosed in double quotes. By default native test code is built, but if <tt>BUILD</tt> is set to <tt>ISS</tt>, then the rv32 ISS and VProc program is compiled and, in this case, the <tt>USER_C</tt> and <tt>USRCODEDIR</tt> are ignored as the make file compiles the supplied source code for the ISS.

The <tt>USER_C</tt> and <tt>USERCODEDIR</tt> make file variable allows different (and multiple) user source file names to override the defaults, and to change the location of where the user code is located (if not the ISS build). This allows different programs to be run by simply changing these variable, and to organise the different source code in different directories etc. By default, the VProc code is compiled for debugging (<tt>-g</tt>), but this can be overridden by changing <tt>OPTFLAG</tt>. The trace and timing options can also be overridden to allow a faster executable. The Wireguard <tt>top.filelist</tt> filename can be overridden to allow multiple configurations to be selected from, if required. The processing of this file to remove the listed <tt>soc_cpu</tt> HDL files is selected on a pattern (<tt>ip.cpu</tt>) but this can be changed using <tt>SOCCPUMATCH</tt>. If any additional options for Verilator are required, then these can be added to <tt>USRSIMOPTS</tt>. The GTKWave waveform file can be selected with <tt>WAVESAVEFILE</tt>.

Control of when the simulation exits can be specified with the <tt>TIMEOUTUS</tt> variable in units of microseconds. Some example commands using the make file are shown below:

```
make -f MakefileVProc.mk run                                                   # Build and run default VUserMain0.cpp code in usercode/
make -f MakefileVProc.mk                                                       # Build but don't run default code
make -f MakefileVProc.mk USER_C="test1.cpp subfuncs.cpp" USRCODEDIR=test1 run  # Build and run test1.cpp and subfuncs.cpp in test1/
make -f MakefileVProc.mk BUILD=ISS gui                                         # Build and run ISS simulation and show waves
make -f MakefileVProc.mk clean                                                 # Clean all intermediate files
```

### Configuring ISS timing model

Configuration of the timing model can done from the supplied integration code in <tt>VUserMain0.cpp</tt>. The main <tt>pre_run_setup()</tt> function, in <tt>VUserMain0.cpp</tt>, creates an <tt>rv32_timing_config</tt> object (<tt>rv32_time_cfg</tt>) which has an <tt>update_timing</tt> method that takes a pointer to the iss object and an enumerated type to select the model to use for the particular core timings required. This second argument is selected from one of the following:

* <tt>rv32_timing_config::risc_v_core_e::DEFAULT&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</tt> : Default timing values
* <tt>rv32_timing_config::risc_v_core_e::PICORV32&nbsp;&nbsp;&nbsp;&nbsp;</tt> : picoRV32 timings
* <tt>rv32_timing_config::risc_v_core_e::EDUBOS5STG2&nbsp;</tt> : 2 stage eduBOS5
* <tt>rv32_timing_config::risc_v_core_e::EDUBOS5STG3&nbsp;</tt> : 3 stage eduBOS5
* <tt>rv32_timing_config::risc_v_core_e::IBEXMULSGL&nbsp;&nbsp;</tt> : IBEX single cycle multipler
* <tt>rv32_timing_config::risc_v_core_e::IBEXMULFAST&nbsp;</tt> : IBEX fast multi-cycle multiplier
* <tt>rv32_timing_config::risc_v_core_e::IBEXMULSLOW&nbsp;</tt> : IBEX slow multi-cycle multiplier

As detailed in the _RISC-V Compiled Application_ section above, the ISS can be configured via the <tt>vusermain.cfg</tt> file using the <tt>-V</tt> option.

### Running ISS code

When the test bench is built for the rv32 ISS, the actual 'user' application code is run on the RISC-V ISS model itself, and is compiled using the normal RISC-V GNU toochain to produce a binary file that the ISS can load and run. As described above, the code that is run is slected with the </tt>vusermain.cfg</tt> file and the </tt>-t</tt> option. The various flags configure the ISS and determines when the ISS is halted (if at all). An example assembly file is provided in <tt>4.sw/models/rv32/riscvtest/main.s</tt> (as well as a recompiled <tt>main.bin</tt>). This assembly code reproduces the functionality of the example <tt>VuserMain0.cpp</tt> program discussed previously, writing to memory, reading back and comparing for a mismatch. The example assembly code is compiled with:

```
$riscv64-unknown-elf-as.exe -fpic -march=rv32imafdc -aghlms=main.list -o main.o main.s
$riscv64-unknown-elf-ld.exe main.o -Ttext 0 -Tdata 1000 -melf32lriscv -o main.bin
```
In this instance, the code is set to compile to use the MAFDC extensions (maths, atomic, float, double and compressed). To run this code the <tt>vusermain.cfg</tt> is set to:

```
vusermain0 -x 0x10000000 -X 0x20000000 -rEHRca -t ./models/rv32/riscvtest/main.bin
```
This sets the address region that will be sent to the HDL <tt>soc_cpu</tt> bus to be between byte addresses 0x10000000 and 0x1FFFFFFF. All other accesses will use the direct memory model's API, with no simulation transactions. The next set of options turn on run-time disassembly (<tt>-r</tt>), exit on <tt>ebreak</tt> (<tt>-E</tt>) or unimplemented instruction (<tt>-H</tt>), dump registers (<tt>-R</tt>) and CSR register (<tt>-c</tt>) and display the registers in ABI format (<tt>-a</tt>). The pre-compiled example program binary is then selected with the <tt>-t</tt> option. Of course, many of these options are not necessary and, for example, the output flags (<tt>-rRca</tt>) can be removed and the program will still run correctly. In the <tt>4.sim/</tt> directory, using <tt>make</tt> to build and run the code gives the following output:

```
$make -f MakefileVProc.mk BUILD=ISS run
- V e r i l a t i o n   R e p o r t: Verilator 5.024 2024-04-05 rev v5.024-42-gc561fe8ba
- Verilator: Built from 2.145 MB sources in 40 modules, into 0.556 MB in 20 C++ files needing 0.001 MB
- Verilator: Walltime 0.298 s (elab=0.020, cvt=0.087, bld=0.000); cpu 0.000 s on 1 threads; alloced 14.059 MB
Archive ar -rcs Vtb__ALL.a Vtb__ALL.o
VInit(0): initialising DPI-C interface
  VProc version 1.11.4. Copyright (c) 2004-2024 Simon Southwell.
                   0 TOP.tb.error_mon (0) - ERROR_CLEARED

  ******************************
  *   Wyvern Semiconductors    *
  * rv32 RISC-V ISS (on VProc) *
  *     Copyright (c) 2024     *
  ******************************

00000000: 0x00001197    auipc     gp, 0x00000001
00000004: 0x0101a183    lw        gp, 16(gp)
00000008: 0x0001a103    lw        sp, 0(gp)
0000000c: 0x10001237    lui       tp, 0x00010001
00000010: 0x00222023    sw        sp, 0(tp)
00000014: 0x00022283    lw        t0, 0(tp)
00000018: 0x00229663    bne       t0, sp, 12
0000001c: 0x00004505'   addi      a0, zero, 1
0000001e: 0x00004501'   addi      a0, zero, 0
00000020: 0x05d00893    addi      a7, zero, 93
00000024: 0x00009002'   ebreak
    *

Register state:

  zero = 0x00000000   ra = 0x00000000   sp = 0x900dc0de   gp = 0x00001000
    tp = 0x10001000   t0 = 0x900dc0de   t1 = 0x00000000   t2 = 0x00000000
    s0 = 0x00000000   s1 = 0x00000000   a0 = 0x00000000   a1 = 0x00000000
    a2 = 0x00000000   a3 = 0x00000000   a4 = 0x00000000   a5 = 0x00000000
    a6 = 0x00000000   a7 = 0x0000005d   s2 = 0x00000000   s3 = 0x00000000
    s4 = 0x00000000   s5 = 0x00000000   s6 = 0x00000000   s7 = 0x00000000
    s8 = 0x00000000   s9 = 0x00000000  s10 = 0x00000000  s11 = 0x00000000
    t3 = 0x00000000   t4 = 0x00000000   t5 = 0x00000000   t6 = 0x00000000

CSR state:

  mstatus    = 0x00003800
  mie        = 0x00000000
  mvtec      = 0x00000000
  mscratch   = 0x00000000
  mepc       = 0x00000000
  mcause     = 0x00000000
  mtval      = 0x00000000
  mip        = 0x00000000
  mcycle     = 0x0000000000000037
  minstret   = 0x000000000000000b
  mtime      = 0x0006263f2bfc6bcf
  mtimecmp   = 0xffffffffffffffff
Exited running ./models/rv32/riscvtest/main.bin
- /mnt/hgfs/winhome/simon/git/Wireguard-fpga/4.sim/tb.sv:44: Verilog $finish
```
Note that the disassembled output is a mixture of 32-bit and compressed 16-bit instructions, with the compressed instruction hexadecimal values shown followed by a <tt>'</tt> character and the instruction heximadecimal value in the lower 16-bits. Unlike for the native compiled code use cases, unless the HDL has changed, the test bench does not need to be re-built when the RISC-V source code is changed or a different binary is to be run, just the RISC-V code is re-compiled or the <tt>vusermain.cfg</tt> updated to point to a different binary file.

### PicoRV32 RTL-Only Simulation Makefile

A standalone Makefile (located in `4.sim/`) for cycle-accurate Verilator simulation using the real picoRV32 RTL core.
It:

- Drives the UDP/IPv4 BFMs (nodes 1–4) via `usercode/VUserMainUdp.cpp`, using VProc’s DPI-C engine for the Ethernet VIP.
- Generates C++ sources with:
  - `--cc -sv --timing --trace-fst --trace-structs`
  - `+define+SIM_ONLY` and `+define+VPROC_SV`
  - File lists `top.filelist` & `simple_tb.filelist` to pull in picoRV32 RTL.
- Compiles into `output/` and links against:
  - `libcosimlnx.a` (co-simulation)
  - `libudplnx.a` (UDP/IP VIP)
  - DPI headers in `models/cosim/include` and `models/udpIpPg/include`.
- Provides standard targets:
  - `compile` → generate & build
  - `sim`     → run `./output/Vtb` (logs to `sim.log`)
  - `wave`    → open `wave.fst` in GTKWave
  - `clean`   → remove `output/`, `tb.xml`, `tb.stems`

## Debugging Code

In each of the three usage cases of software, each can be debugged using <tt>gdb</tt>, either for the host computer or the gnu RISC-V toolchain's gdb.

### Natively Compiled code

For natively compiled code, whether test code or natively compiled application code, so long as each was compiled with the -g flag set ([see above](#building-and-running-code) for make file options) then the Verilator compiled simulation is an executable file (compiled into an <tt>output/</tt> directory) that contains the all the compiled user code. Therefore, to debug using <tt>gdb</tt>, this executable just needs to be run with the host computer's <tt>gdb</tt>. E.g., from the <tt>4.sim/</tt> directory:

```
gdb output/Vtb
```

Debugging then proceeds just as for any other executable.

### ISS Software
The ISS has a remote <tt>gdb</tt> interface (enable with the <tt>-g</tt> option in the <tt>vusermain.cfg</tt> file) allowing the loading of programs via this connection, and of doing all the normal debugging steps of the RISC-V code. The [ISS manual](https://github.com/wyvernSemi/riscV/blob/main/iss/doc/iss_manual.pdf) details how to use the <tt>gdb</tt> remote debug interface but, to summarise, when the ISS is run in GDB mode, it will create a TCP socket and advertise the port number to the screen (e.g. <tt>RV32GDB: Using TCP port number: 49152</tt>). The RISC-V <tt>gdb</tt> is then run and a remote connection is made with a command:

 ```
 (gdb) target remote :49152
 ```

A blank before the colon character in the port number indicates the connection is on the local host, but a remote host name can be used to do remote debugging from another machine on the network, or even over the internet, if sufficient access permissions. The program (if not done so by other means) can be loaded over this connection and then debugging commence as normal.

The [ISS manual](https://github.com/wyvernSemi/riscV/blob/main/iss/doc/iss_manual.pdf) has more details on this and also has an appendix showing how to setup an Eclipse IDE project to debug the code via <tt>gdb</tt>.

## The mem_model Co-Simulation Sparse Memory Model

The Wireguard FPGA test bench makes use of the [mem_model](https://github.com/wyvernSemi/mem_model) co-simulation component. This consists of a sparse memory model, written in C with a software API for read and write transactions. It can map a 64-bit address space, with pages allocated on demand to restrict the actual memory required. The API can be accessed from any _VProc_ running code to share this memory space. This model can also be accessed from the HDL using the `mem_model` HDL component, which may be instantiated any number of times, but always accesses the same memory. This allows multiple _VProc_ virtual processors and the simulated test bench logic to access a common memory space.

Currently, the `soc_cpu.VPROC` component has a `mem_model` instantiated for program writes via a UART, and the software running on the _VProc_ virtual processor can access the memory directly via the API. The software running on the  _VProc_ used in the [_udpIpPg_ modules](#driving-the-wireguard-logic-ethernet-ports) in the `bfm_ethernet` driver also has access to the same API and memory space, and the `bfm_phy_mdio` uses instantiated `mem_model` modules to access this space as well. Thus, the memory model becomes the common connection within the test bench, allowing end-to-end access and verification of results.

Details of the memory model can be found in the [README.md](models/cosim/README.md) in `4.sim/models/cosim`.

## Driving the Wireguard Logic Ethernet Ports

The Wireguard FPGA logic has interfaces for four Ethernet ports, transferring UDP/Ipv4 packets over GMII for 1GbE. Accompanying each Ethernet port is also an MDIO interface used for configuring the PHY with IEEE802.3 Clasue 22 registers. In order to drive these interfaces, the test bench has a [`bfm_ethernet`](models/README.md#the-bfm_ethernet-ethernet-driver-module) module based on the [udpIpPg VIP](https://github.com/wyvernSemi/udpIpPg) to generate packets over GMII, along with  [bfm_phy_mdio blocks](models/README.md#the-bfm_phy_mdio-mdio-slave-driver-module) to respond to the MDIO transactions and which map the registers to address ranges within in the [mem_model's](https://github.com/wyvernSemi/mem_model) memory space via instantiated mem_model HDL components.

<p align="center"><img width= "500" src="https://github.com/user-attachments/assets/5d441c97-9d9f-43d7-99da-d5156b7d106d"></p>

More details on the ethernet driver and udpIpPg can be found in the  [README.md](models/udpIpPg/README.md) file in 4.sim/models/udPgIp.

### _udpIpPg_ Software

Since the _udpIpPg_ bus functional model is based around a _VProc_ component, just as is the [`soc_cpu.VPROC`](#vproc-software), the basic structure usage the same, but with a different API suitable for UDP datagram generation and payload reception. For each of the four instantiated _udpIpPg_ blocks in the `bfm_ethernet` module, there is a `VUserMain<n>` entry point, where `<n>` ranges from 1 to 4 for these models. The basic API for the user code is fairly simple and is as follows:

```c++
class udpIpPg  : public udpVProc
{
public:
    // Constructor
    udpVProc(int nodeIn);

    // Function to register user callback function to receive packets
    void           registerUsrRxCbFunc (pUsrRxCbFunc_t pFunc, void* hdlIn);

    // Method to generate a UDP/IPv4 packet
    uint32_t       genUdpIpPkt         (udpConfig_t &cfg, uint32_t* frm_buf, uint32_t* payload, uint32_t payload_len);

    // Method to send a pre-prepared (raw) ethernet frame
    uint32_t       UdpVpSendRawEthFrame(uint32_t* frame, uint32_t len);

    // Method to idle for specified number of cycles
    uint32_t       UdpVpSendIdle(uint32_t ticks);

    // Method to set the halt output signal
    void           UdpVpSetHalt(uint32_t val);

}
```
Construction of the API object is just a matter of calling the constructor with the node numbeor associated with the _VProc_ for this instance. This shoul mathc the `VUserMain<n>` "main" enntry point. The `registerUsrRxCbFunc` method allows a user supplied callback function to be registered that will be called for each received packet. As well as the pointer to the callback function, and optional `hdl` handle void pointer can be specified which will be passed to the callback function when called. This can be used, for example, as a pointer to a buffer or queue in which to place received data. The callback function itelef has two parameters. The first is of type `rxInfo_t`, which is a structure containing certain information about the received packet.

```c++
    // Structure for received packet information
typedef struct {
    uint64_t mac_src_addr;
    uint32_t ipv4_src_addr;
    uint32_t udp_src_port;
    uint32_t udp_dst_port;
    uint8_t  rx_payload[ETH_MTU];
    uint32_t rx_len;
} rxInfo_t;
```

The callback strcuture parameter has information about the source MAC and PIv4 addresses, as well as the source and destination ports. The payload, if any, will be in the `rx_payload[]` buffer, with the length of this given in `rx_len`.

Generation and transmitting of packets is done in two stages. An ethernet packet, encoded with IPv4 and UDP, is constructed into a frame buffer using the `genUdpIpPkt` method. The first parameter is a simple configuration structure (see below), followed by a frame buffer pointer with sufficent space for the packet, which won't be more than 2Kbytes.

```c++
// Structure definition for transmit parameters
typedef class {
public:
    // UDP controls
    uint32_t dst_port;

    // IPV4 parameters
    uint32_t ip_dst_addr ;

    // MAC parameters
    uint64_t mac_dst_addr;
} udpConfig_t;
```

A pointer to a buffer with a payload followed by the length of the payload make up the last two parameters. Note that the type of the buffers are `uint32_t`, but each entry represents a byte or symbol since the encoding procesess internally can expand the byte data to more than 8 bits for cetain protocols, and consistency between all buffers in the encoding is maintained. The method returns the total length of the packet upon return.

Once the packet has been constructed it is sent over the GMII interface in the logic simulation, via _VProc_, with a call to the `UdpVpSendRawEthFrame`, which is provided with the frame buffer pointer and the length returned by `genUdpIpPkt`. When no packet is to be transmitted, the interface must send idle symbols, and the `UdpVpSendIdle` method does just this, specifying the number of clock cycles. This is comparable to the `tick` method for the `soc_cpu.VPROC` [software](#vproc-software).

### System-Level Ethernet Simulation

With the addition of the UdpIpPg Virtual Processor module and accompanying C++ driver, it is now possible to perform full end-to-end Ethernet packet tests directly from user code:

- **Frame generation**
  A C++ application (in `4.sim/usercode/VUserMainUdp.cpp`) uses the `udpIpPg` class to
  1. configure destination MAC/IP/UDP port,
  2. build a complete Ethernet + IPv4 + UDP frame via `genUdpIpPkt()`, and
  3. transmit it on GMII using `UdpVpSendRawEthFrame()`.
  Idle symbols are driven between frames with `UdpVpSendIdle()` to keep the link alive.

- **Frame reception**
  The same `udpIpPg` API supports a **user callback** registered by
  ```cpp
  pUdp.registerUsrRxCbFunc(rxCallback, nullptr);
  ```

- This mechanism now makes system-level testing of the Ethernet data path trivial—no manual RTL testbench tweaks are required. You can script packet streams, verify traffic, and log every received packet directly in your C++ test harness.

- Example Console Log:

```text
MAC src      = D89EF3887EC3
IPv4 src     = C0A81908
UDP src port = 0400
UDP dst port = 0401
Payload (64 bytes):
00 04 08 0C 10 14 18 1C 20 24 28 2C 30 34 38 3C ......
```

#### PCAP replay/record quickstart (VUserMainPcap)

- Generate a test PCAP (writes into `tools/`):
  `python tools/gen_udp_pcap.py --frames 5 --interval-us 500 --out ./tools/test_udp_rand.pcap`
- Build fresh and run the Ethernet replay/record simulation (uses `PCAP_IN_1` default `./tools/test_udp_rand.pcap`):
  `make -f MakefileVProc.mk clean`
  `make -f MakefileVProc.mk UDP_C=VUserMainPcap.cpp BUILD=ISS run`
  - Outputs of interest in `./output/`:
    - `node2_out.pcap`, `node4_out.pcap` – RX captures with corrected timestamps
    - `merge_node2.pcap`, `merge_node4.pcap` – TX+RX merged on a single timeline
  - In Wireshark: set Time Display to “Seconds Since Epoch” or “Date and Time of Day”. Start-to-start latency (TX→RX) should match what you measure in `wave.fst` via GTKWave.

## Co-simulation HAL

### Using the HAL

The HAL provides a hierarchical access to the registers via a set of pointer dereferencing and a final access method (for reads and writes of registers and their bit fields) that reflects the hierarchy of the RDL specification. The following shows some example accesses, based on the `3.build/csr_build/csr.rdl` (as at its first revision on 10/11/2024):

```
    #include "wireguard_regs.h"

    // Create a CSR register object. A base address can be specified
    // but defaults to the address specified in the RDL
    csr_vp_t* csr = new csr_vp_t();

    // Write to address field and read back.
    csr->ip_lookup_engine->table[0]->allowed_ip[0]->address(0x12345678);
    printf("address = 0x%08lx\n\n", csr->ip_lookup_engine->table[0]->allowed_ip[0]->address());

    // Write to whole endpoint register
    csr->ip_lookup_engine->table[3]->endpoint->full(0x5555555555555555ULL);

    // Write to bit field in endpoint register
    csr->ip_lookup_engine->table[3]->endpoint->interface(0x7);

    // Read back bit field in endpoint register
    printf("interface = 0x%1lx\n\n", csr->ip_lookup_engine->table[3]->endpoint->interface());
```
The above code will compile either natively for *VProc* or for the RISC-V hardware, with the appropriate header, as decribed above. Write accesses use a method with the final register bit field name with an appropriate argument (this is either a `uint64_t` or `uint32_t` as appropriate to the register's definition). A read access is done in the same manner bit without an argument and returns a value (either a `uint64_t` or `uint32_t` as appropriate).

A convention has been used where to access a whole register the 'bit field' access method is named `full`, with bit field accesses using their declared names, as normal. Some assumptions have been made with the script as it stands based on the current `csr.rdl` (but new features can be added). The main one currently is that arrays can't be multi-dimensional (hierarchy can be used to achieve the same thing) and an error is thrown if detected.

### Other Co-simulation considerations

The HAL software abstracts away the details of hardware and co-simulation register accesses but a couple of other consideration are needed to allow code to compile both for hardware and simulation. The first of these is the `main` entry point.

A normal application compiled for the target has a `main()` entry point function. In *VProc* co-simulation, this is not the case as the logic simulation itself has a `main()` function already defined and there can be multiple *VProc* node instantiations, each with their own entry point. These are named `VUserMain<n>`, where `<n>` is the node number. So, node 0 has an entry point function `VUserMain0`. The auto-generated HAL co-simulation headers include a `WGMAIN` definition that is either `main` for the hardware code or `VUserMain0` for *VProc* code (assuming node 0 for `soc_cpu`). This is then used in place of `main` at the top level application code.

```
#include "wireguard_regs.h"

// Application top level
void WGMAIN (void)
{
  // Top level source code here
}
```

The second consideration is the use of delay functions. This can be in the form of standard C functions, such as `usleep`, or application specific functions using instruction loops. In either case, these should be wrapped in a commonly named function&mdash;e.g., `wg_usleep(int time)`. The wrapper delay library function will then need to have `VPROC` selected code to either call the application specific target delay function, or to convert the specified time to clock cycles and call the *VProc* API function `VTick` (or its C++ API equivalent) to advance simulation time the appropriate amount. The co-simulation auto-generated HAL header has `SOC_CPU_CLK_PERIOD_PS` defined that can be configured on the `3.build/sysrdl_cosim.py` command line with `-C` or `--clk_period`, but defaults to the equivalent of 80MHz that the test bench uses for the `soc_cpu`. A `SOC_CPU_VPNODE` is also defined, defaulting to 0, for use when calling the *VProc* C API functions directly. The definition is affected by the `-v` or `--vp_node` command line options of `3.build/sysrdl_cosim.py`.

## Tool Versions
* _Verilator_ **v5.024**
* _VProc_ **v1.12.2**
* _Mem Model_ **v1.0.0**
* _rv32_ ISS **v1.1.4**
* _udpIpPg_ **v1.0.3**

Finally, the

## References:
- [VProc](https://github.com/wyvernSemi/vproc)
- [mem_model](https://github.com/wyvernSemi/mem_model)
- [UDP/IP Packet Generator](https://github.com/wyvernSemi/udpIpPg)
- [rv32 RISC-V ISS](https://github.com/wyvernSemi/riscV/tree/main/iss)
- [Surfer](https://gitlab.com/surfer-project/surfer)
- [Verilator](https://verilator.org/guide/latest/install.html)
- [SystemRDL](https://www.accellera.org/downloads/standards/systemrdl)
- [PeakRDL and SystemRDLcompiler](https://github.com/SystemRDL)
