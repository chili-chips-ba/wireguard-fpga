//==========================================================================
// Copyright (C) 2024 Chili.CHIPS*ba
//--------------------------------------------------------------------------
//                      PROPRIETARY INFORMATION
//
// The information contained in this file is the property of CHILI CHIPS LLC.
// Except as specifically authorized in writing by CHILI CHIPS LLC, the holder
// of this file: (1) shall keep all information contained herein confidential;
// and (2) shall protect the same in whole or in part from disclosure and
// dissemination to all third parties; and (3) shall use the same for operation
// and maintenance purposes only.
//--------------------------------------------------------------------------
// Description:
//   VProc main program to instantiate and run the rv32 RISC-V instruction
//   set simulator, with configuration via vusermain.cfg file.
//
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

// ---------------------------------------------
// LOCAL STATICS
// ---------------------------------------------

static uint32_t        extirq          = 0;
static uint32_t        swirq           = 0;

static rv32*           pCpu;

static vusermain_cfg_t vcfg;
static rv32_cache*     icache          = NULL;

static double          tv_diff_usec;

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
// Set up actions prior to running CPU
// ---------------------------------------------

static void pre_run_setup(rv32* pCpu)
{

    // Register the ISS external memory callback function
    pCpu->register_ext_mem_callback(ext_mem_access);

    // Register ISS interrupt callback
    pCpu->register_int_callback(iss_int_callback);

    // Register the VProc IRQ callback, used to update irq status from HDL
    VRegIrq(vproc_irq_callback, node);

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
    const int       write_wait_cycle      = 0;
    const int       read_data_wait_cycle  = 1;
    const int       read_instr_wait_cycle = 1;
    bool            access_sim            = false;
    int             processed             = RV32I_EXT_MEM_NOT_PROCESSED;
    uint64_t        curr_cycles;
    uint32_t        cycle_diff;
    static uint64_t last_cycles           = 0;

    // Select whether making simulation or direct memory model access
    access_sim  = addr >= vcfg.ext_access_base_addr && addr < vcfg.ext_access_top_addr;

    // -------------------------------------------
    // Synchronise ISS time and simulation time
    // -------------------------------------------
    curr_cycles = pCpu->clk_cycles();
    cycle_diff  = (uint32_t)(curr_cycles - last_cycles);

    // Force synchronisation of simulation when reading instructions and the
    // ISS/sim skew reaches a limit to minimise simulation interaction when
    // no load/stores for a while.
    if (!access_sim)
    {
        if ((type & MEM_NOT_DBG_MASK) == MEM_RD_ACCESS_INSTR && cycle_diff >= max_sync_diff)
        {
            VTick(cycle_diff, node);
            last_cycles = curr_cycles;
        }
    }
    // Synchronise CPU time with simulation at simulation access load or store
    else
    {
        VTick(cycle_diff, node);
        last_cycles = curr_cycles;
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
    extirq = val;

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

