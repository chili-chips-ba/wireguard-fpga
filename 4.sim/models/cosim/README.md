<!--
SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
SPDX-FileCopyrightText: 2026 Simon Southwell

SPDX-License-Identifier: BSD-3-Clause
-->

# _VProc_ and _mem_model_ Co-simulation Components

The _VProc_ virtual processor and the _mem_model_ sparse memory mode components form the heart of the co-simulation for the Wireguard FPGA top level simulation test bench. The `soc_cpu.VProc` is based on the virtual processor and the memory used by the running programs has access to the memory model's space. Logic can also access the memeory model's address space with an provide HDl component. This component is also used in the ethernet interface driver block, and the code running on the _udpIpPg_ VIP's _VProc_ also has access to the same memory via the API. Thus, these components are tied together tightly.

## _VProc_

The _VProc_ virtual processor is a VIP co-simulation component that allows a natively compiled user program to be “run” on an HDL processor component instantiated in the logic. C/C++ APIs are provided to initiate read and write transactions on the _VProc_ HDL bus, and for the
advancing simulation time.

<p align="center"><img width=450 src="https://github.com/user-attachments/assets/b272d61c-fa97-4ba2-a609-307ed4d0840c"></p>

_VProc_ has a generic memory mapped bus and this would normally be wrapped in a module to convert this to a standard bus or interconnect protocol, such as AXI or Avalon but, for Wireguard FPGA, the bus is converted to the local `soc_if` interface with some simple logic. Multiple _VProc_ test programs components can be instantiated, each with a unique “node” number.

Since the simulator is _Verilator_, the connection between software and HDL is done using the SystemVerilog DPI-C interface. The details of connection between the HDL and running user code won’t be discussed here but suffice it to say that the user program is running in its own thread and the _VPro_c layer software provides both the API and the means to synchronise the user program with the simulation, keeping both in lock-step but allowing the user program to be free flowing code. For each instantiated VProc node the user code has a specific “main” entry point of the form `VUserMain<n>`, where `<n>` is the _VProc_’s node number: e.g. `VUserMain0`, which must have C linkage for DPI requirements. The user programs are compiled into a library and, along with a _VProc_ code library, are linked with the Verilator C++ code. There are both C and C++ APIs available to user programs and abbreviated versions are shown below.

<p align="center"><img width=700 src="https://github.com/user-attachments/assets/f8dd88fe-ed63-4a6c-a0eb-55a13d0f845d"></p>

As well as basic read and write transactions methods, there is also a “tick” method. User programs run infinitely fast with respect to simulation time, so simulation time is advanced when a transaction method is called but can also be advanced with the `tick` method without a memory access transaction. Using these APIs directly gives the means to construct pure test programs that can run on the `soc_cpu.VPROC` component to drive the CSR registers in the core logic and instigate operations. A very simple program of this nature is shown below.

<p align="center"><img width=600 src="https://github.com/user-attachments/assets/a5b03827-e882-42d5-8765-c9cc3128b31a"></p>


## _mem_model_

The Wireguard FPGA test bench makes use of the [mem_model](https://github.com/wyvernSemi/mem_model) co-simulation component. This consists of a sparse memory model , written in C, with co-simulation capabilities via a `mem_model` HDL component with various Avalon style ports for memory mapped, burst and write functions. Code running in _VProc_ can access the C model directly via an API, with an abbreviated version shown below.

<p align="center"><img width=400 src="https://github.com/user-attachments/assets/06278e89-e718-4396-9a05-d8c9cbb51efa"></p>

The write functions take `address` and `data` parameters and, for wider words, a little-endian flag (`le`) to select between endian
modes. The read functions take an `address` and (where appropriate) an `le` parameter and return the read value. All functions have a node parameter. Note that the “node” in the API functions is not the same as for _VProc_ but refers to individual address spaces. In almost all use cases this will be the same and is 0.

This model can also be accessed from the HDL using the `mem_model` HDL component, which may be instantiated any number of times, but always accesses the same memory. This allows multiple _VProc_ virtual processors and the simulated test bench logic to access a common memory space.

<p align="center"><img width=400 src="https://github.com/user-attachments/assets/e991b49b-8b50-4e8f-bf7d-caa96992a680"></p>


## VProc and mem_model integration into WireGuard

This directory contains library code for the *VProc* virtual processor and *mem_model* sparse memory model co-simulation verification IP, suitable for the Verilator logic simulation environment (other simulators are not supported at this time). This directory contains the HDL modules for the two components, with the HDL top level modules being `f_VProc.sv` and `mem_model.sv`, which reference the sub-modules (`f_VProc.v` and `mem_model.v`) along with the Verilog header files, with `` `include`` inclusions. Thus only these top level files need to be compiled in Verilator and this directory included in the search path, though this is all taken care of in the `MakefileVProc.mk` make file in the `4.sim/` directory.

The DPI software for both the models is pre-compiled into a static library as `lib/libcosimlnx.a` (with a `lib/libcosimwin.a` version for use with the MSYS2/mingw64 environment on Windows). The headers for the models are placed in the `include/` directory. To use the  models' APIs, the user code must include either the  `VProcClass.h` header for the *VProc* C++ API, or `VUser.h` for the *VProc* C API, and the `mem.h` header for the memory model C API. Note that the `VUser.h` and `mem.h` inclusions must be wrapped as C linkage if included in code that will be compiled as C++. E.g.:

```
extern "C" {
#include "VUser.h"
#include "mem.h"
}
```

This is only applicable when writing natively compiled simulation test code. When compiling the application code natively for *VProc*, the headers will be included correctly by the co-simulation hardware abstraction layer (HAL).


## More Information

More information on using these co-simulation models can be found in the [*VProc* manual](https://github.com/wyvernSemi/vproc/blob/master/doc/VProc.pdf) and [*mem_model* manual](https://github.com/wyvernSemi/mem_model/blob/main/doc/mem_model_manual.pdf).
