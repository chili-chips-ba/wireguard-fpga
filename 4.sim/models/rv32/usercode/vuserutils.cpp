// SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
//
// SPDX-License-Identifier: BSD-3-Clause

//==========================================================================
// Description:
//   VUserMain utility functions for configuration and debug display
//==========================================================================

#include <stdio.h>
#include <stdlib.h>
#include <string>

#include "VUserMain0.h"
#include "rv32.h"

#if defined _WIN32 || defined _WIN64

extern "C" {

    extern int getopt(int nargc, char** nargv, const char* ostr);
    extern char* optarg;
}
#endif

static const int       strbufsize = 256;
static char            argstr[strbufsize];

// ---------------------------------------------
// Parse configuration file arguments
// ---------------------------------------------

int parseArgs(int argcIn, char** argvIn, rv32i_cfg_s &cfg, vusermain_cfg_t &vcfg, const int node)
{
    int    error = 0;
    int    c;
    int    argc = 0;
    char*  argvBuf[MAXARGS];
    char** argv = NULL;

    char   delim[2];
    char   vusermainname[16];
    FILE*  fp;
    
    std::string core;

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
    while ((c = getopt(argc, argv, "t:n:bA:rdHTeED:gp:S:Cahx:X:RcIl:w:s:j:J:P:V:BL:")) != EOF)
    {
        switch (c)
        {
        case 't':
            cfg.exec_fname = optarg;
            cfg.user_fname = true;
            break;
        case 'B':
            vcfg.load_binary = true;
            break;
        case 'L':
            vcfg.bin_load_addr = strtol(optarg, NULL, 0);
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
                error++;
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
            vcfg.ext_access_base_addr = strtol(optarg, NULL, 0);
            break;
        case 'X':
            vcfg.ext_access_top_addr  = strtol(optarg, NULL, 0);
            break;
        case 'R':
            cfg.dump_regs        = true;
            break;
        case 'c':
            cfg.dump_csrs        = true;
            break;
        case 'I':
            vcfg.enable_icache   = true;
            break;
        case 'l':
            vcfg.icache_line_bytes = strtol(optarg, NULL, 0);
            break;
        case 'w':
            vcfg.icache_ways = strtol(optarg, NULL, 0);
            break;
        case 's':
            vcfg.icache_sets = strtol(optarg, NULL, 0);
            break;
        case 'j':
            vcfg.icache_base_addr = strtol(optarg, NULL, 0);
            break;
        case 'J':
            vcfg.icache_base_addr = strtol(optarg, NULL, 0);
            break;
        case 'P':
            vcfg.penalty_slow_mem = strtol(optarg, NULL, 0);
            break;
        case 'V':
            core = optarg;
            if (core == "DEFAULT")
                vcfg.riscv_core = rv32_timing_config::risc_v_core_e::DEFAULT;
            else if (core == "PICORV32")
                vcfg.riscv_core = rv32_timing_config::risc_v_core_e::PICORV32;
            else if (core == "EDUBOS5STG2")
                vcfg.riscv_core = rv32_timing_config::risc_v_core_e::EDUBOS5STG2;
            else if (core == "EDUBOS5STG3")
                vcfg.riscv_core = rv32_timing_config::risc_v_core_e::EDUBOS5STG3;
            else if (core == "IBEXMULSGL")
                vcfg.riscv_core = rv32_timing_config::risc_v_core_e::IBEXMULSGL;
            else if (core == "IBEXMULFAST")
                vcfg.riscv_core = rv32_timing_config::risc_v_core_e::IBEXMULFAST;
            else if (core == "IBEXMULSLOW")
                vcfg.riscv_core = rv32_timing_config::risc_v_core_e::IBEXMULSLOW;
            else
            {
                fprintf(stderr, "parseArgs(): ***ERROR: unrecognised RISC-V core specification\n");
                error++;
            }
            break;
        case 'h':
        default:
            fprintf(stderr, "Usage: %s -t <test executable> [-hHebdrgxXRcI][-n <num instructions>]\n", argv[0]);
            fprintf(stderr, "      [-S <start addr>][-A <brk addr>][-D <debug o/p filename>][-p <port num>]\n");
            fprintf(stderr, "      [-l <line bytes>][-w <ways>][-s <sets>][-j <imem base addr>][-J <imem top addr>]\n");
            fprintf(stderr, "      [-P <cycles>][-x <base addr>][-X <top addr>][-V <core>]\n");
            fprintf(stderr, "   -t specify test executable/binary file (default test.exe)\n");
            fprintf(stderr, "   -B specify to load a raw binary file (default load ELF executable)\n");
            fprintf(stderr, "   -L specify address to load binary, if -B specified (default 0x00000000)\n");
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
            fprintf(stderr, "   -R Dump x0 to x31 on exit (default no dump)\n");
            fprintf(stderr, "   -c Dump CSR registers on exit (default no dump)\n");
            fprintf(stderr, "   -g Enable remote gdb mode (default disabled)\n");
            fprintf(stderr, "   -p Specify remote GDB port number (default 49152)\n");
            fprintf(stderr, "   -S Specify start address (default 0)\n");
            fprintf(stderr, "   -I Enable instruction cache timing model (default disabled)\n");
            fprintf(stderr, "   -l Specify number of bytes in icache line (default %d)\n", RV32_CACHE_DEFAULT_LINE);
            fprintf(stderr, "   -w Specify number of ways in icache (default %d)\n", RV32_CACHE_DEFAULT_WAYS);
            fprintf(stderr, "   -s Specify number of sets in icache (default %d)\n", RV32_CACHE_DEFAULT_SETS);
            fprintf(stderr, "   -j Specify cached IMEM base address (default 0x%08x)\n", RV32_CACHE_DEFAULT_BASE);
            fprintf(stderr, "   -J Specify cached IMEM top address (default 0x%08x)\n", RV32_CACHE_DEFAULT_ILIMIT);
            fprintf(stderr, "   -P Specify penalty, in cycles, of one slow mem access (default %d)\n", RV32_SLOW_MEM_PENALTY);
            fprintf(stderr, "   -x Specify base address of external access region (default 0x%08x)\n", EXT_ACCESS_BASE);
            fprintf(stderr, "   -X Specify top address of external access region (default 0x%08x)\n", EXT_ACCESS_TOP);
            fprintf(stderr, "   -V Specify RISC-V core timing model to use (default \"DEFAULT\")\n");
            fprintf(stderr, "   -h display this help message\n");
            error++;
            break;
        }
    }

    return error;
}

// ---------------------------------------------
// Dump registers
// ---------------------------------------------

void reg_dump(rv32* pCpu, FILE* dfp, bool abi_en)
{
    fprintf(dfp, "\nRegister state:\n\n  ");

    // Loop through all the registers
    for (int idx = 0; idx < rv32i_consts::RV32I_NUM_OF_REGISTERS; idx++)
    {
        // Get the appropriate mapped register name (ABI or x)
        const char* map_str = abi_en ? pCpu->rmap_str[idx] : pCpu->xmap_str[idx];

        // Get the length of the register name string
        size_t  slen = strlen(map_str);

        // Fetch the value of the register indexed
        uint32_t rval = pCpu->regi_val(idx);

        // Print out the register name (right justified) followed by the value
        fprintf(dfp, "%s%s = 0x%08x ", (slen == 2) ? "  " : (slen == 3) ? " ": "",
                                         map_str,
                                         rval);

        // After every fourth value, output a new line
        if ((idx % 4) == 3)
        {
            fprintf(dfp, "\n  ");
        }
    }

    // Add a final new line
    fprintf(dfp, "\n");
}

// ---------------------------------------------
// Dump CSRs
// ---------------------------------------------

void csr_dump(rv32* pCpu, FILE* dfp)
{
    fprintf(dfp, "CSR state:\n\n");
    fprintf(dfp, "  mstatus    = 0x%08x\n",     pCpu->csr_val(rv32csr_consts::RV32CSR_ADDR_MSTATUS));
    fprintf(dfp, "  mie        = 0x%08x\n",     pCpu->csr_val(rv32csr_consts::RV32CSR_ADDR_MIE));
    fprintf(dfp, "  mvtec      = 0x%08x\n",     pCpu->csr_val(rv32csr_consts::RV32CSR_ADDR_MTVEC));
    fprintf(dfp, "  mscratch   = 0x%08x\n",     pCpu->csr_val(rv32csr_consts::RV32CSR_ADDR_MSCRATCH));
    fprintf(dfp, "  mepc       = 0x%08x\n",     pCpu->csr_val(rv32csr_consts::RV32CSR_ADDR_MEPC));
    fprintf(dfp, "  mcause     = 0x%08x\n",     pCpu->csr_val(rv32csr_consts::RV32CSR_ADDR_MCAUSE));
    fprintf(dfp, "  mtval      = 0x%08x\n",     pCpu->csr_val(rv32csr_consts::RV32CSR_ADDR_MTVAL));
    fprintf(dfp, "  mip        = 0x%08x\n",     pCpu->csr_val(rv32csr_consts::RV32CSR_ADDR_MIP));
    fprintf(dfp, "  mcycle     = 0x%08x%08x\n", pCpu->csr_val(rv32csr_consts::RV32CSR_ADDR_MCYCLEH),   pCpu->csr_val(rv32csr_consts::RV32CSR_ADDR_MCYCLE));
    fprintf(dfp, "  minstret   = 0x%08x%08x\n", pCpu->csr_val(rv32csr_consts::RV32CSR_ADDR_MINSTRETH), pCpu->csr_val(rv32csr_consts::RV32CSR_ADDR_MINSTRET));

    bool fault;
    uint32_t mtimel = pCpu->read_mem(rv32i_consts::RV32I_RTCLOCK_ADDRESS,   rv32i_consts::RV32I_MEM_RD_ACCESS_WORD, fault);
    uint32_t mtimeh = pCpu->read_mem(rv32i_consts::RV32I_RTCLOCK_ADDRESS+4, rv32i_consts::RV32I_MEM_RD_ACCESS_WORD, fault);
    fprintf(dfp, "  mtime      = 0x%08x%08x\n", mtimeh, mtimel);

    mtimel = pCpu->read_mem(rv32i_consts::RV32I_RTCLOCK_CMP_ADDRESS,   rv32i_consts::RV32I_MEM_RD_ACCESS_WORD, fault);
    mtimeh = pCpu->read_mem(rv32i_consts::RV32I_RTCLOCK_CMP_ADDRESS+4, rv32i_consts::RV32I_MEM_RD_ACCESS_WORD, fault);
    fprintf(dfp, "  mtimecmp   = 0x%08x%08x\n", mtimeh, mtimel);

}
