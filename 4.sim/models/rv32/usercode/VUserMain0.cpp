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

#include <stdio.h>
#include <stdlib.h>

#if !defined _WIN32 && !defined _WIN64
#include <unistd.h>
#include <termios.h>
#include <sys/time.h>

#define STRDUP strdup
#else
# undef   UNICODE
# define  WIN32_LEAN_AND_MEAN

# include <windows.h>
# include <winsock2.h>
# include <ws2tcpip.h>

#define STRDUP _strdup

extern "C" {

    extern int getopt(int nargc, char** nargv, const char* ostr);
    extern char* optarg;
}
#endif

#include "VUserMain0.h"
#include "mem_vproc_api.h"
#include "rv32.h"
#include "rv32_cpu_gdb.h"

// I'm node 0
int node = 0;

static uint32_t  irq                  = 0;

static const int strbufsize = 256;
static char      argstr[strbufsize];
static rv32*     pCpu;

static uint32_t  ext_access_base_addr = EXT_ACCESS_BASE;
static uint32_t  ext_access_top_addr  = EXT_ACCESS_TOP;

static double    tv_diff_usec;

#if (!(defined _WIN32) && !(defined _WIN64))
static struct timeval tv_start, tv_stop;
#else
LARGE_INTEGER freq, start, stop;
#endif

// ---------------------------------------------
// Set up actions prior to running CPU
// ---------------------------------------------

static void pre_run_setup()
{
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
static void post_run_actions()
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
}

// ---------------------------------------------
// External memory map access
// callback function
// ---------------------------------------------

int ext_mem_access(const uint32_t addr, uint32_t& data, const int type, const rv32i_time_t time)
{
    const int       write_wait_cycle      = 0;
    const int       read_data_wait_cycle  = 1;
    const int       read_instr_wait_cycle = 1;
    bool            access_sim            = false;
    int             processed;
    uint64_t        curr_cycles;
    uint32_t        cycle_diff;
    static uint64_t last_cycles           = 0;

    // Select whether making simulation or direct memory model access
    access_sim = addr >= ext_access_base_addr && addr < ext_access_top_addr;

    // Synchronise CPU time with simulation
    curr_cycles = pCpu->clk_cycles();
    cycle_diff  = (uint32_t)(curr_cycles - last_cycles);

    VTick(cycle_diff, node);
    last_cycles = curr_cycles;

    // Do access
    switch (type & MEM_NOT_DBG_MASK)
    {
    case MEM_RD_ACCESS_BYTE:
        data = read_byte(addr, access_sim);
        processed = read_data_wait_cycle;
        break;
    case MEM_RD_ACCESS_HWORD:
        data = read_hword(addr, access_sim);
        processed = read_data_wait_cycle;
        break;
    case MEM_RD_ACCESS_INSTR:
        data = read_instr(addr, access_sim);
        processed = read_instr_wait_cycle;
        break;
    case MEM_RD_ACCESS_WORD:
        data = read_word(addr, access_sim);
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
    case MEM_WR_ACCESS_WORD:
        write_word(addr, data, access_sim);
        processed = write_wait_cycle;
        break;
    default:
        processed = RV32I_EXT_MEM_NOT_PROCESSED;
        break;
    }

    return processed;
}

// ---------------------------------------------
// Parse configuration file arguments
// ---------------------------------------------

int parseArgs(int argcIn, char** argvIn, rv32i_cfg_s &cfg, const int node)
{
    int    error = 0;
    int    c;
    int    argc = 0;
    char*  argvBuf[MAXARGS];
    char** argv = NULL;

    char   delim[2];
    char   vusermainname[16];
    FILE*  fp;

    int returnVal  = 0;

    if (argcIn > 1)
    {
        argc = argcIn;
        argv = argvIn;
    }
    else
    {
        fp = fopen(CFGFILENAME, "r");
        if (fp == NULL)
        {
            printf("parseArgs: failed to open file %s\n", CFGFILENAME);
            returnVal = 1;
        }

        strcpy(delim, " ");
        sprintf(vusermainname, "vusermain%c", '0' + node);

        while (fgets(argstr, strbufsize, fp) != NULL)
        {
            char* name = strtok(argstr, delim);

            if (strcmp(name, vusermainname) == 0)
            {
                argvBuf[argc++] = name;
                break;
            }
        }

        fclose(fp);

        while((argvBuf[argc] = strtok(NULL, " ")) != NULL && argc < MAXARGS)
        {
            unsigned lastchar = argvBuf[argc][strlen(argvBuf[argc])-1];

            // If last character is CR or LF, delete it
            if (lastchar == '\r' || lastchar == '\n')
            {
                argvBuf[argc][strlen(argvBuf[argc])-1] = 0;
            }

            argc++;
        }

        argv = argvBuf;
    }

    // Parse the command line arguments and/or configuration file
    // Process the command line options *only* for the INI filename, as we
    // want the command line options to override the INI options
    while ((c = getopt(argc, argv, "t:n:bA:rdHTeED:gp:S:Cahx:X:")) != EOF)
    {
        switch (c)
        {
        case 't':
            cfg.exec_fname = optarg;
            cfg.user_fname = true;
            break;
        case 'n':
            cfg.num_instr = atoi(optarg);
            break;
        case 'b':
            cfg.en_brk_on_addr = true;
            break;
        case 'A':
            cfg.brk_addr = strtol(optarg, NULL, 0);
            break;
        case 'r':
            cfg.rt_dis = true;
            break;
        case 'd':
            cfg.dis_en = true;
            break;
        case 'H':
            cfg.hlt_on_inst_err = true;
            break;
        case 'T':
            cfg.use_external_timer = true;
            break;
        case 'e':
            cfg.hlt_on_ecall = true;
            break;
        case 'E':
            cfg.hlt_on_ebreak = true;
            break;
        case 'D':
            if ((cfg.dbg_fp = fopen(optarg, "wb")) == NULL)
            {
                fprintf(stderr, "**ERROR: unable to open specified debug file (%s) for writing.\n", optarg);
                error = 1;
            }
            break;
        case 'g':
            cfg.gdb_mode = true;
            break;
        case 'p':
            cfg.gdb_ip_portnum = strtol(optarg, NULL, 0);
            break;
        case 'S':
            cfg.update_rst_vec = true;
            cfg.new_rst_vec    = strtol(optarg, NULL, 0);
            break;
        case 'C':
            cfg.use_cycles_for_mtime = true;
            break;
        case 'a':
            cfg.abi_en = true;
            break;
        case 'x':
            ext_access_base_addr = strtol(optarg, NULL, 0);
            break;
        case 'X':
            ext_access_top_addr  = strtol(optarg, NULL, 0);
            break;
        case 'h':
        default:
            fprintf(stderr, "Usage: %s -t <test executable> [-hHebdrg][-n <num instructions>]\n      [-S <start addr>][-A <brk addr>][-D <debug o/p filename>][-p <port num>]\n", argv[0]);
            fprintf(stderr, "      [-x <base addr>][-X <top addr>]\n");
            fprintf(stderr, "   -t specify test executable (default test.exe)\n");
            fprintf(stderr, "   -n specify number of instructions to run (default 0, i.e. run until unimp)\n");
            fprintf(stderr, "   -d Enable disassemble mode (default off)\n");
            fprintf(stderr, "   -r Enable run-time disassemble mode (default off. Overridden by -d)\n");
            fprintf(stderr, "   -C Use cycle count for internal mtime timer (default real-time)\n");
            fprintf(stderr, "   -a display ABI register names when disassembling (default x names)\n");
            fprintf(stderr, "   -T Use external memory mapped timer model (default internal)\n");
            fprintf(stderr, "   -H Halt on unimplemented instructions (default trap)\n");
            fprintf(stderr, "   -e Halt on ecall instruction (default trap)\n");
            fprintf(stderr, "   -E Halt on ebreak instruction (default trap)\n");
            fprintf(stderr, "   -b Halt at a specific address (default off)\n");
            fprintf(stderr, "   -A Specify halt address if -b active (default 0x00000040)\n");
            fprintf(stderr, "   -D Specify file for debug output (default stdout)\n");
            fprintf(stderr, "   -g Enable remote gdb mode (default disabled)\n");
            fprintf(stderr, "   -p Specify remote GDB port number (default 49152)\n");
            fprintf(stderr, "   -S Specify start address (default 0)\n");
            fprintf(stderr, "   -x Specify base address of external access region (default 0x%08x)\n", EXT_ACCESS_BASE);
            fprintf(stderr, "   -X Specify top address of external access region (default 0x%08x)\n", EXT_ACCESS_TOP);
            fprintf(stderr, "   -h display this help message\n");
            error = 1;
            break;
        }
    }

    return error;
}

// ---------------------------------------------
// Interrupt callback functions
// ---------------------------------------------

// Note: the VProc CB function can only be active when the main thread
// is stalled on a read, write or tick, so it is safe to modify shared
// variables. Also, it is not valid to make further VProc calls from
// this CB, but updating state here should instigate required functionality
// in the main program flow.
int vproc_irq_callback(int val)
{
    irq = val;

    return 0;
}

// The ISS interrupt callback will return an interrupt when irq
// is non-zero, else it returns 0. The wakeup time in this model is always the next
// cycle.
uint32_t iss_int_callback(const rv32i_time_t time, rv32i_time_t *wakeup_time)
{
    *wakeup_time = time + 1;

    return irq;
}

// ---------------------------------------------
// Main entry point for node 0 VPRoc
// ---------------------------------------------

extern "C" void VUserMain0()
{
    rv32i_cfg_s   cfg;

    VPrint("\n*****************************\n");
    VPrint(  "*   Wyvern Semiconductors   *\n");
    VPrint(  "*  rv32_cpu ISS (on VProc)  *\n");
    VPrint(  "*     Copyright (c) 2024    *\n");
    VPrint(  "*****************************\n\n");

    VTick(20, node);

    // Parse arguments. As no argc and argv, pass in these as null, and it will look for
    // vusermain.cfg, which should have a single line with the command line options. If this
    // doesn't exist, no parsing is done.
    if (parseArgs(0, NULL, cfg, node))
    {
        VPrint("Error in parsing args\n");
    }
    else
    {
        // Create and configure the top level rv32 ISS cpu object
        pCpu = new rv32(cfg.dbg_fp);

        // Register the ISS external memory callback function
        pCpu->register_ext_mem_callback(ext_mem_access);

        // Register ISS interrupt callback
        pCpu->register_int_callback(iss_int_callback);

        // Register the VProc IRQ callback, used to update irq status from HDL
        VRegIrq(vproc_irq_callback, node);

        // If GDB mode selected, pass execution to the remote GDB interface
        if (cfg.gdb_mode)
        {
#ifdef __WIN32__
            WORD versionWanted = MAKEWORD(1, 1);
            WSADATA wsaData;
            WSAStartup(versionWanted, &wsaData);
#endif
            int error = 0;

            // Load an executable if specified on the command line
            if (cfg.user_fname)
            {
                if (pCpu->read_elf(cfg.exec_fname))
                {
                    error = 1;
                }
            }

            if (!error)
            {
                // Start procssing commands from GDB
                if (rv32gdb_process_gdb(pCpu, cfg.gdb_ip_portnum, cfg))
                {
                    fprintf(stderr, "***ERROR in opening PTY\n");
                }
            }

#ifdef __WIN32__
            WSACleanup;
#endif
        }
        // Normal execution mode (not gdb debugging)
        else
        {
            // Load the specified executable to memory
            if (!pCpu->read_elf(cfg.exec_fname))
            {
                pre_run_setup();

                // Run the processor
                pCpu->run(cfg);

                post_run_actions();

                // If the break from the program was for specified number of instructions...
                if (cfg.num_instr != 0)
                {
                    // Display statistics about executoin time.
                    VPrint("\nNumber of executed instructions = %.1f million (%.0f IPS)\n\n",
                                 (float)cfg.num_instr/1e6, (float)cfg.num_instr/(tv_diff_usec/1e6));
                }
                else
                {
                    VPrint("Exited running %s\n", cfg.exec_fname);
                }
            }
        }

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

