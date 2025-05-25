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

The `csr_cosim.hdl` is a filtered version of `3.build/csr_build/csr.rdl` that removes buffer write commands that are not understood by `systemrdl-compiler` and are not used for `c-header` generation. Other than that, the RDL is identical.

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

The main options used are to specify the RDL file (`-r` or `--rd_file`) and to specify the output file (`-o` or `-output_file`). To select generation of the co-simulation header the `-c` or `--cosim` option is used, otherwise the hardware header is generated. By default the co-simulation header assumes it is running on a *VProc* node numbered 0, matching the current WireGuard test bench. However, this can be changed by using the `-v` or `--vp_node` option, should the need arise. Code running on a *VProc* virtual processor runs infinitely fast with respect to simulation time when not doing a read or write transaction to the logic. In order to emulate processing time, after each read or write access, a random delay is inserted to advance the simulation a number of ticks. The maximum number of ticks can be specified using the `-d` or `--delay_range` option meaning the delay can range from 0 to `DELAY` clock cycles. The default for this is 32 clock cycles. The `-v` and `-d` options have no affect if the `-c` option is not used. Finally the *VProc* test bench `soc_cpu` module's clock period in picoseconds can be specified for use in co-simulation abstraction of delay and timing functions. It defaults to 12500 to match the `tb.sv` `HALF_PERIOD_PS` definition for the base 80MHz clock used by internal logic.

To generate all the required HAL headers and RTL a make file is provided as `3.build/MakefileCSR` to wrap app the script calls. Running this make file (`make -f MakefileCSR`) produces the following files in `3.build/csr_build/generated-files`:

  * `csr_cosim.rdl` : The intermediate filtered RDL specification
  * `csr.sv`        : The RTL for hardware target
  * `csr_pkg.sv`    : The structured RTL interface for hardware target
  * `csr.h`         : The `peakrdl c-header` output file used by the target header
  * `csr_hw.h`      : The HAL for the RISC-V hardware target (and for the *rv32* ISS), which uses `csr.h`
  * `csr_cosim.h`   : The HAL for the *VProc* based WireGuard logic simulation test bench

The `csr_hw.h` and `csr_cosim.h` files present the same API to the application and can be appropriately selected at compile time using something like the following:

```
ifdef VPROC
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

## HW Compilation

Hardware synthesis is currently supported through the Vivado GUI, using the prepared [project file](/3.build/hw_build.Vivado/wireguard.xpr) located at `3.build/hw_build.Vivado`.

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

The second consideration is the use of delay functions. This can be in the form of standard C functions, such as `usleep`, or application specific functions using instruction loops. In either case, these should be wrapped in a commonly named function&mdash;e.g., `wg_usleep(int time)`. The wrapper delay library function will then need to have `VPROC` selected code to either call the application specific target delay function, or to convert the specified time to clock cycles and call the *VProc* API function `VTick` (or its C++ API equivalent) to advance simulation time the appropriate amount. The co-simulation auto-generated HAL header has `SOC_CPU_CLK_PERIOD_PS` defined that can be configured on the `sysrdl_cosim.py` command line with `-C` or `--clk_period`, but defaults to the equivalent of 80MHz that the test bench uses for the `soc_cpu`. A `SOC_CPU_VPNODE` is also defined, defaulting to 0, for use when calling the *VProc* C API functions directly. The definition is affected by the `-v` or `--vp_node` command line options of `sysrdl_cosim.py`. 