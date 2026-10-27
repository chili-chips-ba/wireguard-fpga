// SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
//
// SPDX-License-Identifier: BSD-3-Clause

//==========================================================================
// Description:
//   VProc main program to instantiate and run the rv32 RISC-V instruction
//   set simulator, with configuration via vusermain.cfg file.
//==========================================================================

#include <cstdio>
#include <cstdlib>
#include <cstdint>

#include "VUserMain0.h"
#include "vuserutils.h"

// ---------------------------------------------
// CONSTANTS
// ---------------------------------------------

// I'm VProc node 0
const  int             node            = 0;

const  uint32_t        uart0_base_addr = 0x80000000;
const  uint32_t        sw_irq_addr     = 0xafffffff;
const  uint32_t        max_sync_diff   = 1000;

// Bus credit (from openPCIE), selected with RV32_BUS_CREDIT=1 (make
// ISS_BUS_CREDIT=1). A load or store to the simulation takes real clocks on
// the VProc bus. With credit on, these are taken off the following
// synchronisations, so that an access costs only its timing-model cycles, and
// fetches and loads get no wait states. With credit off (default), the
// original wireguard timing is kept: 1 wait state per fetch and load, and the
// bus clocks come on top.
#ifndef RV32_BUS_CREDIT
#define RV32_BUS_CREDIT 0
#endif

// Simulation clocks of one access over the VProc bus (soc_cpu.VPROC.sv:
// VProc samples the ack at a rising edge, the ack is bus.rdy sampled on the
// falling edge before it). Measured in wave.fst (WE/RD width): writes 1 clock
// (DMEM and CSR), CSR reads 1 clock, DMEM reads 2 clocks. See 4.sim/README.md.
const  uint32_t        sim_write_cycles     = 1;
const  uint32_t        sim_read_cycles      = 1;
const  uint32_t        sim_dmem_read_cycles = 2;
const  uint32_t        dmem_base_addr       = 0x10000000;
const  uint32_t        dmem_top_addr        = 0x20000000;

// ---------------------------------------------
// LOCAL STATICS
// ---------------------------------------------

static uint32_t        extirq          = 0;
static uint32_t        swirq           = 0;

// The CPU reset, VProc interrupt bit 3 (soc_cpu.VPROC.sv: bus.arst_n and
// imem_cpu_rstn, as for the RTL cores). Assumed asserted until the first
// interrupt callback says otherwise.
static volatile bool   in_reset        = true;

static rv32*           pCpu;

static vusermain_cfg_t vcfg;
static rv32_cache*     icache          = NULL;

static double          tv_diff_usec;

// openPCIE: the cores modelled here (eduBOS5, our PicoRV32) are plain RV32I,
// but the ISS decodes every extension it was built with (writing misa does
// not switch one off). With rv32i_core set from -V, a fetched word outside
// RV32I becomes an illegal instruction, so the ISS traps (halts with -H)
// instead of running code the RTL core cannot.
static bool            rv32i_core      = false;

#if (!(defined _WIN32) && !(defined _WIN64))
static struct          timeval tv_start, tv_stop;
#else
LARGE_INTEGER          freq, start, stop;
#endif

// ---------------------------------------------
// Forward declarations
// ---------------------------------------------

int      ext_mem_access     (const uint32_t addr, uint32_t& data, const int type, const rv32i_time_t time);
int      vproc_irq_callback (int val);
uint32_t iss_int_callback   (const rv32i_time_t time, rv32i_time_t *wakeup_time);

// ---------------------------------------------
// openPCIE: RV32I-only fetch filter
// ---------------------------------------------

// RV32I with FENCE, ECALL and EBREAK: no M/A/F/D/C/Zb*, no CSR instructions
// (rdcycle, rdinstret, rdtime), no FENCE.I
static bool is_rv32i(const uint32_t insn)
{
    const uint32_t opcode = insn & 0x7f;
    const uint32_t funct3 = (insn >> 12) & 0x7;
    const uint32_t funct7 = insn >> 25;

    switch (opcode)
    {
    case 0x37: case 0x17: case 0x6f: return true;                     // LUI, AUIPC, JAL
    case 0x67: return funct3 == 0;                                    // JALR
    case 0x63: return funct3 != 2 && funct3 != 3;                     // branches
    case 0x03: return funct3 <= 2 || funct3 == 4 || funct3 == 5;      // LB LH LW LBU LHU
    case 0x23: return funct3 <= 2;                                    // SB SH SW
    case 0x13: return funct3 == 1 ? funct7 == 0x00                    // SLLI
                    : funct3 == 5 ? funct7 == 0x00 || funct7 == 0x20  // SRLI, SRAI
                    : true;                                           // ADDI .. ANDI
    case 0x33: return funct7 == 0x00 ||                               // ADD .. AND
                      (funct7 == 0x20 && (funct3 == 0 || funct3 == 5)); // SUB, SRA
    case 0x0f: return funct3 == 0;                                    // FENCE
    case 0x73: return insn == 0x00000073 || insn == 0x00100073;       // ECALL, EBREAK
    default:   return false;                                          // incl. compressed
    }
}

// The fetched word, or an all-zero word (an illegal instruction) when the
// core lacks it
static uint32_t core_fetch_filter(const uint32_t addr, const uint32_t insn)
{
    static int reported = 0;

    if (!rv32i_core || is_rv32i(insn))
    {
        return insn;
    }
    if (reported++ < 4)
    {
        VPrint("rv32 ISS: 0x%08x at 0x%08x is not RV32I, which this core lacks: illegal instruction\n",
               insn, addr);
    }
    return 0x00000000;
}

// ---------------------------------------------
// Set up actions prior to running CPU
// ---------------------------------------------

static void pre_run_setup(rv32* pCpu)
{

    // Register the ISS external memory callback function
    pCpu->register_ext_mem_callback(ext_mem_access);

    // Register ISS interrupt callback
    pCpu->register_int_callback(iss_int_callback);

    // (The VProc IRQ callback is registered at the start of VUserMain0, so
    // that no reset edge is missed.)

    // Set up ICACHE if enabled
    if (vcfg.enable_icache)
    {
        icache = new rv32_cache(vcfg.icache_line_bytes,
                                vcfg.icache_ways,
                                vcfg.icache_sets,
                                vcfg.icache_base_addr,
                                vcfg.icache_top_addr);
    }

    // Configure the ISS timing model
    rv32_timing_config rv32_time_cfg;

    // Update the ISS with the selected core's timing. Choose one of:
    //    rv32_timing_config::risc_v_core_e::DEFAULT,
    //    rv32_timing_config::risc_v_core_e::PICORV32
    //    rv32_timing_config::risc_v_core_e::EDUBOS5STG2
    //    rv32_timing_config::risc_v_core_e::EDUBOS5STG3
    //    rv32_timing_config::risc_v_core_e::IBEXMULSGL
    //    rv32_timing_config::risc_v_core_e::IBEXMULFAST
    //    rv32_timing_config::risc_v_core_e::IBEXMULSLOW
    //
    // See rv32_timing_config.h for supported timing models
    //
    rv32_time_cfg.update_timing(pCpu, vcfg.riscv_core);

    // openPCIE: the RV32I-only cores get the fetch filter
    rv32i_core = vcfg.riscv_core == rv32_timing_config::risc_v_core_e::PICORV32    ||
                 vcfg.riscv_core == rv32_timing_config::risc_v_core_e::EDUBOS5STG2 ||
                 vcfg.riscv_core == rv32_timing_config::risc_v_core_e::EDUBOS5STG3;

    // Initialise time
#if (!(defined _WIN32) && !(defined _WIN64)) || defined __CYGWIN__
    // For non-windows systems, turn off echoing of input key presses
    struct termios t;

    tcgetattr(STDIN_FILENO, &t);
    t.c_lflag &= ~ECHO;
    tcsetattr(STDIN_FILENO, TCSANOW, &t);

    // Log time just before running (LINUX only)
    (void)gettimeofday(&tv_start, NULL);
#else

    QueryPerformanceFrequency(&freq);
    QueryPerformanceCounter(&start);
#endif
}

// ---------------------------------------------
// Actions to run after CPU returns from
// executing
// ---------------------------------------------

static void post_run_actions(rv32i_cfg_s cfg)
{
    // Calculate time difference, in microseconds, from now
    // to previously saved time stamp
#if (!(defined _WIN32) && !(defined _WIN64))
    // For non-windows systems, turn off echoing of input key presses
    struct termios t;

    tcgetattr(STDIN_FILENO, &t);
    t.c_lflag |= ECHO;
    tcsetattr(STDIN_FILENO, TCSANOW, &t);

    // Get time just after running, and calculate run time (LINUX only)
    (void)gettimeofday(&tv_stop, NULL);
    tv_diff_usec = ((float)(tv_stop.tv_sec - tv_start.tv_sec)*1e6) + ((float)(tv_stop.tv_usec - tv_start.tv_usec));
#else
    QueryPerformanceCounter(&stop);
    tv_diff_usec = (double)(stop.QuadPart - start.QuadPart)*1e6/(double)freq.QuadPart;
#endif

    if (cfg.dump_regs)
    {
        reg_dump(pCpu, cfg.dbg_fp, cfg.abi_en);
    }

    if (cfg.dump_csrs)
    {
        csr_dump(pCpu, cfg.dbg_fp);
    }

    if (cfg.num_instr != 0)
    {
        VPrint("\nNumber of executed instructions = %.1f million (%.0f IPS)\n\n",
               (float)cfg.num_instr/1e6, (float)cfg.num_instr/(tv_diff_usec/1e6));
    }
}

// ---------------------------------------------
// External memory map access callback function
// ---------------------------------------------

int ext_mem_access (const uint32_t addr, uint32_t& data, const int type, const rv32i_time_t time)
{
#if RV32_BUS_CREDIT
    // No wait states: the timing model already counts the fetch and the load
    const int       write_wait_cycle      = 0;
    const int       read_data_wait_cycle  = 0;
    const int       read_instr_wait_cycle = 0;
#else
    const int       write_wait_cycle      = 0;
    const int       read_data_wait_cycle  = 1;
    const int       read_instr_wait_cycle = 1;
#endif
    bool            access_sim            = false;
    int             processed             = RV32I_EXT_MEM_NOT_PROCESSED;
    uint64_t        curr_cycles;
    uint64_t        cycle_diff;
    static uint64_t last_cycles           = 0;
    static uint64_t sim_ahead             = 0;  // bus clocks not yet taken off

    // Reset asserted while running (seen at the latest sync, so up to
    // max_sync_diff cycles late): hold until it is released, then restart at
    // the reset vector, as the RTL core does
    if ((type & MEM_NOT_DBG_MASK) == MEM_RD_ACCESS_INSTR && in_reset)
    {
        while (in_reset)
        {
            VTick(1, node);
        }
        pCpu->reset_cpu();
        last_cycles = pCpu->clk_cycles();
        sim_ahead   = 0;
        data        = core_fetch_filter(pCpu->pc_val(), read_instr(pCpu->pc_val(), false));
        return read_instr_wait_cycle;
    }

    // Select whether making simulation or direct memory model access
    access_sim  = addr >= vcfg.ext_access_base_addr && addr < vcfg.ext_access_top_addr;

    // -------------------------------------------
    // Synchronise ISS time and simulation time
    // -------------------------------------------
    curr_cycles = pCpu->clk_cycles();
    cycle_diff  = curr_cycles - last_cycles;

    // Advance the simulation by the ISS cycles since the last synchronisation,
    // less the bus clocks the simulation already spent (sim_ahead, always 0
    // without bus credit)
    auto sync = [&]()
    {
        if (cycle_diff > sim_ahead)
        {
            VTick((uint32_t)(cycle_diff - sim_ahead), node);
            sim_ahead = 0;
        }
        else
        {
            sim_ahead -= cycle_diff;
        }
        last_cycles = curr_cycles;
    };

    // Force synchronisation of simulation when reading instructions and the
    // ISS/sim skew reaches a limit to minimise simulation interaction when
    // no load/stores for a while.
    if (!access_sim)
    {
        if ((type & MEM_NOT_DBG_MASK) == MEM_RD_ACCESS_INSTR && cycle_diff >= max_sync_diff)
        {
            sync();
        }
    }
    // Synchronise CPU time with simulation at simulation access load or store
    else
    {
        sync();
#if RV32_BUS_CREDIT
        if ((type & MEM_NOT_DBG_MASK) <= MEM_WR_ACCESS_INSTR)
            sim_ahead += sim_write_cycles;
        else
            sim_ahead += (addr >= dmem_base_addr && addr < dmem_top_addr) ? sim_dmem_read_cycles : sim_read_cycles;
#endif
    }

    // -------------------------------------------
    // Make memory access
    // -------------------------------------------

    // Accessing the software interrupt
    if (addr == sw_irq_addr)
    {
        swirq     = (data & 0x1) << 2;
        processed = write_wait_cycle;
    }
    else if ((processed = uart_reg_access(addr, data, type, uart0_base_addr)) == RV32I_EXT_MEM_NOT_PROCESSED)
    {
        // Do access
        switch (type & MEM_NOT_DBG_MASK)
        {
        case MEM_RD_ACCESS_BYTE:
            data      = read_byte(addr, access_sim);
            processed = read_data_wait_cycle;
            break;
        case MEM_RD_ACCESS_HWORD:
            data      = read_hword(addr, access_sim);
            processed = read_data_wait_cycle;
            break;
        case MEM_RD_ACCESS_INSTR:
            data      = read_instr(addr, access_sim);
            if (!(type & MEM_DBG_MASK))
            {
                data  = core_fetch_filter(addr, data);
            }
            processed = read_instr_wait_cycle;

            // Process caching if enabled
            if (vcfg.enable_icache)
            {
                // Add wait states for icache miss
                if (icache->rv32_cache_access(addr) == RV32_CACHE_MISS)
                {
                    // Additional wait states is the access time to slow memory times the number
                    // of words fetched to fill the line.
                    processed += vcfg.penalty_slow_mem * icache->get_line_width()/4;
                }
            }
            break;
        case MEM_RD_ACCESS_WORD:
            data      = read_word(addr, access_sim);
            processed = read_data_wait_cycle;
            break;
        case MEM_WR_ACCESS_BYTE:
            write_byte(addr, data, access_sim);
            processed = write_wait_cycle;
            break;
        case MEM_WR_ACCESS_HWORD:
            write_hword(addr, data, access_sim);
            processed = write_wait_cycle;
            break;
        case MEM_WR_ACCESS_INSTR:
            // When loading instructions, always use direct memory API
            write_word(addr, data, 0);
            processed = 0;
            break;
        case MEM_WR_ACCESS_WORD:
            write_word(addr, data, access_sim);
            processed = write_wait_cycle;
            break;
        default:
            processed = RV32I_EXT_MEM_NOT_PROCESSED;
            break;
        }
    }

    return processed;
}

// ---------------------------------------------
// VProc interrupt callback function
// ---------------------------------------------

// Note: the VProc CB function can only be active when the main thread
// is stalled on a read, write or tick, so it is safe to modify shared
// variables. Also, it is not valid to make further VProc calls from
// this CB, but updating state here should instigate required functionality
// in the main program flow.
int vproc_irq_callback(int val)
{
    extirq   = val & 0x7;
    in_reset = (val >> 3) & 1;

    return 0;
}

// ---------------------------------------------
// Load binary file to memory
// ---------------------------------------------

static int read_binary(const char *exec_fname, uint32_t load_addr)
{
    int         error = 0;
    FILE*       bin_fp;
    char        buf[4];
    int         c;
    uint32_t*   word = (uint32_t*)buf;
    bool        fault;

    // Open program file ready for loading
    if ((bin_fp = fopen(exec_fname, "rb")) == NULL)
    {
        fprintf(stderr, "*** read_binary(): Unable to open file %s for reading\n", exec_fname);
        return 1;
    }

    for (int idx = 0; 1; idx++)
    {
        if ((c = fgetc(bin_fp)) != EOF)
        {
            buf[idx & 0x3] = c;
            if ((idx & 0x3) == 3)
            {
                pCpu->write_mem(load_addr + (idx & ~0x3U), *word, MEM_WR_ACCESS_INSTR, fault);
            }
        }
        else
        {
            // Flush partial words
            if (idx & 0x3)
            {
                pCpu->write_mem(load_addr + (idx & ~0x3U), *word & ((1 << (load_addr & 0x3)*8)-1), MEM_WR_ACCESS_INSTR, fault);
            }

            // Exit loop
            break;
        }
    }

    return 0;
}

// ---------------------------------------------
// ISS interrupt callback function
// ---------------------------------------------

// The ISS interrupt callback will return an interrupt when IRQs
// non-zero, else it returns 0. The wakeup time in this model is always the next
// cycle.
uint32_t iss_int_callback(const rv32i_time_t time, rv32i_time_t *wakeup_time)
{
    bool terminate;

    *wakeup_time = time + 1;

    bool uart_irq = uart_tick(time, terminate);

    return extirq | swirq | (uart_irq ? 1 : 0);
}

// =============================================
// Main entry point for VProc node 0
// =============================================

extern "C" void VUserMain0()
{
    rv32i_cfg_s   cfg;
    int error = 0;

    VPrint("\n  ******************************\n");
    VPrint(  "  *   Wyvern Semiconductors    *\n");
    VPrint(  "  * rv32 RISC-V ISS (on VProc) *\n");
    VPrint(  "  *     Copyright (c) 2025     *\n");
    VPrint(  "  ******************************\n\n");

    // Register the VProc IRQ callback, used to update irq and reset status
    // from HDL, before the first tick, so that the reset release is seen
    VRegIrq(vproc_irq_callback, node);

    VTick(20, node);

    // Parse arguments. As no argc and argv, pass in these as null, and it will look for
    // vusermain.cfg, which should have a single line with the command line options. If this
    // doesn't exist, no parsing is done.
    if (parseArgs(0, NULL, cfg, vcfg, node))
    {
        VPrint("***Error in parsing args. ISS not run.\n");
    }
    else
    {
        // Create the top level rv32 ISS cpu object
        pCpu = new rv32(cfg.dbg_fp);

        // Configure the ISS and other setups before running
        pre_run_setup(pCpu);

        // If GDB mode selected, pass execution to the remote GDB interface
        if (cfg.gdb_mode)
        {

            // Set to halt on ebreak when in gdb mode
            cfg.hlt_on_ebreak = true;

            // Load an executable if specified on the command line
            if (cfg.user_fname)
            {
                if (!vcfg.load_binary)
                {
                    if (pCpu->read_elf(cfg.exec_fname))
                    {
                        error++;
                    }
                }
                else
                {
                    // Load the specified binary to memory
                    if (read_binary(cfg.exec_fname, vcfg.bin_load_addr))
                    {
                        error++;
                    }
                }
            }

            if (!error)
            {
                // Start processing commands from GDB
                if (rv32gdb_process_gdb(pCpu, cfg.gdb_ip_portnum, cfg))
                {
                    fprintf(stderr, "***ERROR in opening PTY\n");
                    error++;
                }
            }
        }
        // Normal execution mode (not gdb debugging)
        else
        {
            if (!vcfg.load_binary)
            {
                // Load the specified executable to memory
                if (pCpu->read_elf(cfg.exec_fname))
                {
                    error++;
                }
            }
            else
            {
                // Load the specified binary to memory
                if (read_binary(cfg.exec_fname, vcfg.bin_load_addr))
                {
                    error++;
                }
            }

            if (!error)
            {
                // Start at reset release, as the RTL core does
                while (in_reset)
                {
                    VTick(1, node);
                }

                // Run the processor
                pCpu->run(cfg);

                VPrint("Exited running %s\n", cfg.exec_fname);
            }
        }

        // Run any actions after ISS exits
        post_run_actions(cfg);

        // Clean up
        if (cfg.dbg_fp != stdout)
        {
            fclose(cfg.dbg_fp);
        }
        delete pCpu;
    }

    // Allow the simulation to continue indefinitely.
    SLEEP_FOREVER;
}

