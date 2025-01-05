# VProc and mem_model integration into WireGuard

This directory contains library code for the *VProc* virtual processor and *mem_model* sparse memory model co-simulation verification IP, suitable for the Verilator logic simulation environment (other simulators are not supported at this time). This directory contains the HDL modules for the two components, with the HDL top level modules being `f_VProc.sv` and `mem_model.sv`, which reference the sub-modules (`f_VProc.v` and `mem_model.v`) along with the Verilog header files, with `` `include`` inclusions. Thus only these top level files need to be compiled in Verilator and this directory included in the search path, though this is all taken care of in the `MakefileVProc.mk` make file in the `4.sim/` directory.

The DPI software for both the models is pre-compiled into a static library as `lib/libcosimlnx.a` (with a `lib/libcosimwin.a` version for use with the MSYS2/mingw64 environment on Windows). The headers for the models are placed in the `include/` directory. To use the  models' APIs, the user code must include either the  `VProcClass.h` header for the *VProc* C++ API, or `VUser.h` for the *VProc* C API, and the `mem.h` header for the memory model C API. Note that the `VUser.h` and `mem.h` inclusions must be wrapped as C linkage if included in code that will be compiled as C++. E.g.:

```
extern "C" {
#include "VUser.h"
#include "mem.h"
}
```

This is only applicable when writing natively compiled simulation test code. When compiling the application code natively for *VProc*, the headers will be included correctly by the co-simulation hardware abstraction layer (HAL).

More information on using these co-simulation models can be found in the [*VProc* manual](https://github.com/wyvernSemi/vproc/blob/master/doc/VProc.pdf) and [*mem_model* manual](https://github.com/wyvernSemi/mem_model/blob/main/doc/mem_model_manual.pdf).