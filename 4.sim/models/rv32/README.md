# RV32 ISS Model Integration for WireGuard

This directory contains the integration code for the [rv32](https://github.com/wyvernSemi/riscV/tree/main/iss) RISC-V instruction set simulator (ISS) into the WireGuard simulation test bench as a program running on the [VProc virtual processor](https://github.com/wyvernSemi/vproc). The ISS is provided as a pre-compiled static library in the `lib` directory (either `librv32lnx.a` for Linux or `librv32win.a` for Windows with MSYS2/mingw-w64). The `include` directory has all the required headers for the ISS, but only `rv32.h` needs to be included in the VProc code to access all the model's features.

## File Organisation

The code to integrate the ISS into the virtual processor is in the directory `usercode`. This contains the following files:

* `VUserMain0.cpp` and `VUserMain.h`
* `vuserutils.cpp` and `vuserutils.h`
* `rv32_timing_config.h`
* `rv32_cache.cpp` and `rv32_cache.h`
* `mem_vproc_api.cpp` and `mem_vproc_api.h`
* `uart.cpp` and `uart.h`

## Main Program

The `VUserMain0` files define the "main" entry point program for node 0 VProc, which is the node for the CPU in the test bench. In this code are also defined the user callback functions for the ISS memory accesses (`ext_mem_access`) and the ISS interrupts (`iss_int_callback`). In addition, there is also a callback for the VProc interrupts (`vproc_irq_callback`). Currently interrupts are not used by the test bench, but this code allows for future expansion.

The `VUserMain0` program flow is outlined below:

```
    Parse the vusermain.cfg file for integration and ISS configurations
    Create an rv32 ISS object
    Run pre-setup function to configure the model and the integration code (register callbacks, timings, cache, etc.)
    if GDB mode
        if specified, load an ELF executable program
        call the ISS GDB processing function to accept commands from an attached gdb until quit
    else
        load specified ELF executable program
        run the ISS until exit
    Run post run action function to display state and clean up
    clean up 
    Sleep program to allow simulation to continue
```

The configuration of the ISS's timing model is done with a class defined in `rv32_timing_config.h`. This class abstracts away the call to the ISS's timing update method by providing a set of pre-defined timing models for the seven categories that the ISS supports. The class supports timing models for the following core processors and variants:

* PICORV32  
* EDUBOS5 with 2 stage pipeline
* EDUBOS5 with 3 stage pipeline
* IBEX with single cycle mutiplier
* IBEX with fast multi-cycle multipler
* IBEX with slow multi-cycle multipler

If new cores are to be supported it is in this file where they must be added. The `parseArgs` function defined in `vuserutils.cpp` (more later) also allows configuration via the `vusermain.cfg` file, and this must be updated also to allow for any added core timing model.

## User Callback Functions

### External Memory Access Callback

The external memory access callback function is called by the ISS whenever the ISS does a memory access using loads, stores, atomic accesses etc. At each call the function is passed an access type, an address and a reference to a data word. It is also passed a "time" in units of cycles that the ISS has reckoned from its execution of instructions and its internal timing model. It will also include any wait states as returned by the callback (more shortly). The callback's flow is outlined below:

```
    // Synchronisation
    Calculate the difference in ISS time reckoning since last call.
    if not doing a mem access over simulation bus
        if (difference greater than a maximum)
            Call 'tick' VProc API call for the difference number of cycles
    else
        Call 'tick' VProc API call for the difference number of cycles

    // Software interrupt
    if addr in s/w interrupt range and writing
        set the software irq state to data[0]

    // Memory access
    Switch on type 
       For data reads:
            Do read access for appropriate size
            Set read wait state value
       For Instruction reads:
            read word
            if enabled, update cache and get hit/miss and update 
            Set wait state based on hit/miss
        For data writes:
            Do write access for appropriate size
            Set read wait state value
        For invalid type:
            Flag access not processed by callback

    Return processed wait states or not processed
```
The actual accesses are done with calls to the memory access functions as defined in `mem_vproc_api.cpp` and its header. The functions virtualise away the calls to either the VProc API or the mem_model API, depending whether the address of the access lies in the configured external memory access range or not. If it does, then a VProc API call is made and the transaction appears over the CPU's bus in the simulation. If not then a call to the memory model's direct access API is made, and there is no transaction over the bus. Any instantiated mem_model components in the test bench, however, will still see these memory updates, and if memory is updated from the HDL via an mem_model component, these will be seen by the processor using the mem_model direct API.

The cache model is defined in the `rv32_cache.cpp` file and its header. This does not actually cache memory data but just  models the addresses that are cached or not to calculate a hit or miss, an update the cache state for any new address that missed.

### Interrupt Callbacks

The two callbacks are used to fetch IRQ state from the HDL (`vproc_irq_callback`) and pass it on to the ISS via its interrupt callback (`iss_int_callback`). As discussed above, the software interrupt also updates state that is passed to the ISS via the ISS interrupt callback. The state expected by the ISS is a non-zero value for active interrupt. In this test bench, certain bits are allocated for certain functions

* bit 0: Connected to UART interrupt model
* bit 2: Software interrupt
* others: generic external interrupt

## Utility Functions

The `vuserutils.cpp` file and its header, provide three utility fuctions for the main integration code. As mentioned above, the ISS and the integration code can be configured with the `parseArgs` function. This takes and arc and argv arguments (as would be for a normal `main` C/C++ entry point) but, since the code is running on the virtual processor which does not have access to Verilator's command line arguments, these initial arguments are set to 0 and `NULL` when called from `VUserMain0`. Instead it will look for a `vusermain.cfg` file and process this. This has a format of `vusermain<X> [options]`, where X is the node number (0 for this test bench) followed by the options that would have been on the command line. The `README.md` file in the repository's top directory has more datils of what options are available. Two configuration structres are passed into `parseArgs` to configure for the ISS and to configure for the VProc integration code, which are updated by the `parseAgs` function.

If and when the ISS exits (and it may be configured to do so for a number of reasons) state may be dumped as part of the post run actions (`post_run_actions` defined in `VUserMain0.cpp`). These include dumping all the register state (`reg_dump`), including the CSR registers (`csr_dump`). 

If the ISS exited execution due to specifying a number of instructions to execute and then halt, the pre-run setup and post run actions will sample time and do a calculation of what the instruction exectution rate was for the run in units of MIPS.

## Test Example

A small RISC-V assembly test example is provide in the `riscvtest` directory as `main.s`. A shell script is provided to build is (`rv_asm.sh`), but a pre-compiled binary is also provide (`main.bin`). This simly write over the HDL bus to memory and reads it back and checks it is valid. The `vusermain.cfg` file can select this binary to run with the `-t` option.