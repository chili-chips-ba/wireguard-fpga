//=============================================================
//
// Copyright (c) 2021 Simon Southwell. All rights reserved.
//
// Date: 5th August 2021
//
// This file is part of the rv32_cpu instruction set simulator.
//
// This is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// The code is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this code. If not, see <http://www.gnu.org/licenses/>.
//
//=============================================================

// -------------------------------------------------------------------------
// INCLUDES
// -------------------------------------------------------------------------

#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <errno.h>
#include <fcntl.h>

// For Windows, need to link with Ws2_32.lib
#if defined (_WIN32) || defined (_WIN64)
// -------------------------------------------------------------------------
// INCLUDES (windows)
// -------------------------------------------------------------------------

# undef   UNICODE
# define  WIN32_LEAN_AND_MEAN

# include <windows.h>
# include <winsock2.h>
# include <ws2tcpip.h>

extern "C" {
    extern int getopt(int nargc, char** nargv, const char* ostr);
    extern char* optarg;
}

#else
// -------------------------------------------------------------------------
// INCLUDES (Linux)
// -------------------------------------------------------------------------

# include <string.h>
# include <unistd.h>
# include <sys/types.h>
# include <sys/socket.h>
# include <netinet/in.h>
# include <termios.h>
#endif

#include "rv32_cpu_gdb.h"

// -------------------------------------------------------------------------
// DEFINES
// -------------------------------------------------------------------------

#define RV32I_GETOPT_ARG_STR               "hHdbrt:n:a:D:A:"

// -------------------------------------------------------------------------
// LOCAL CONSTANTS
// -------------------------------------------------------------------------

static char ack_char       = GDB_ACK_CHAR;
static char hexchars[]     = HEX_CHAR_MAP;

// -------------------------------------------------------------------------
// STATIC VARIABLES
// -------------------------------------------------------------------------

static char ip_buf[IP_BUFFER_SIZE];
static char op_buf[OP_BUFFER_SIZE];

static rv32i_cpu::rv32i_hart_state cpu_state;

// -------------------------------------------------------------------------
// rv32gdb_skt_init()
//
// Does any required socket initialisation, prior to opening a TCP socket.
// Current, only windows requires any handling.
//
// -------------------------------------------------------------------------

inline static int rv32gdb_skt_init(void)
{
#if defined (_WIN32) || defined (_WIN64)
    WSADATA wsaData;

    // Initialize Winsock (windows only). Use windows socket spec. verions up to 2.2.
    if (int status = WSAStartup(MAKEWORD(VER_MAJOR, VER_MINOR), &wsaData))
    {
        fprintf(stderr, "WSAStartup failed with error: %d\n", status);
        return RV32GDB_ERR;
    }
#endif

    return RV32GDB_OK;
}

// -------------------------------------------------------------------------
// rv32_skt_cleanup()
//
// Does any open TCP socket cleanup before exiting the program. Current,
// only windows requires any handling.
//
// -------------------------------------------------------------------------

inline static void rv32gdb_skt_cleanup(void)
{
#if defined (_WIN32) || defined (_WIN64)
    WSACleanup();
#endif
}

// -------------------------------------------------------------------------
// rv32gdb_read()
//
// Read a byte from the PTY (fd) and place in the buffer (buf). Return true
// on successful read, else return false. Compile dependent for windows
// (ReadFile) and linux (read)
//
// -------------------------------------------------------------------------

static inline bool rv32gdb_read (void* fdin, char* buf)
{
    int status = RV32GDB_OK;
    long long fd = (long long)fdin;


    // Read from the connection (up to 255 bytes plus null termination).
    if (recv((rv32gdb_skt_t)fd, buf, 1, 0) < 0)
    {
        fprintf(stderr, "ERROR reading from socket\n");
        rv32gdb_skt_cleanup();
        status = RV32GDB_ERR;
    }

    return status == RV32GDB_OK;
}

// -------------------------------------------------------------------------
// rv32gdb_write()
//
// Write a byte to the PTY (fd) from the buffer (buf). Return true
// on successful read, else return false. Compile dependent for windows
// (WriteFile) and linux (write)
//
// -------------------------------------------------------------------------

static inline bool rv32gdb_write (void* fd, char* buf)
{
    int status = RV32GDB_OK;

    if (send((rv32gdb_skt_t)fd, buf, 1, 0) < 0)
    {
        fprintf(stderr, "ERROR writing to socket\n");
        status = RV32GDB_ERR;
    }

    return status == RV32GDB_OK;
}

// -------------------------------------------------------------------------
// rv32gdb_gen_register_reply()
//
// Generate a register reply to a GDB command into buffer (buf). The format
// generated is either a stop reply type (for commands '?', 'c' or 's')
//
//   "T AA n1:r1;n2:r2;..."
//
// or an orders set reply (for command 'p')
//
//   "r1r2r3...."
//
// The checksum for the generated characters is calculated and returned in
// checksum.
//
// -------------------------------------------------------------------------

static int rv32gdb_gen_register_reply(rv32* cpu, const char* cmd, char *buf, unsigned char &checksum, const int sigval = SIGHUP)
{
    int      bdx    = 0;
    int      cdx    = 1;
    int      regnum;
    unsigned val;

    bool single_reg = cmd[0] == 'p';
    bool stop_reply = cmd[0] == '?' || cmd[0] == 'c' || cmd[0] == 's';

    // Retrieve the current CPU state
    cpu_state = cpu->rv32_get_cpu_state();

    // If retrieving a single register, get register number and skip the '=' character
    if (single_reg)
    {
        regnum  = CHAR2NIB(cmd[cdx]) << 4; cdx++;
        regnum |= CHAR2NIB(cmd[cdx]);      cdx++;

        // Skip '=' character
        cdx++;
    }

    // If a 'Stop' reply (e.g. from '?' command), format is "T AA n1:r1;n2:r2;...",
    // where AA is the signal value, nx is the register number, and rx is the register's
    // value. Otherwise it is just r1r2...
    if (stop_reply)
    {
        buf[bdx++] = 'T';
        BUFBYTE(buf, bdx, sigval);
    }

    // Run through all the registers...
    for (int idx = 0; idx < NUM_REGS; idx++)
    {
        if (idx < rv32i_consts::RV32I_NUM_OF_REGISTERS)
        {
            val = (uint32_t)cpu_state.x[idx];
        }
        else
        {
            switch (idx)
            {
               case RV32_REG_PC  : val = (uint32_t)cpu_state.pc;   break;
            }
        }

        if (stop_reply)
        {
            // Add the register number as a 2 character hex value
            BUFBYTE(buf, bdx, idx);
            buf[bdx++] = ':';
        }
        else if (single_reg)
        {
            if (idx != regnum)
            {
                continue;
            }
        }

        // Add the register 32 bit word value as hex characters
        BUFWORDLE(buf, bdx, val);

        if (stop_reply)
        {
            buf[bdx++] = ';';
        }
    }

    // Put a null terminating character at the end (in case we wish to
    // print the string for debug purposes)
    buf[bdx] = 0;

    // Calculate the checksum
    for (int idx = 0; idx < bdx; idx++)
    {
        checksum += buf[idx];
    }

    // Return number of characters placed in the buffer
    return bdx;
}

// -------------------------------------------------------------------------
// rv32gdb_set_registers()
//
// Sets one or more of the CPU's registers based on the command (cmd). If
// the command is 'P', a register number is extracted, and that register is
// updated with the command data. Otherwise the command data is treated as
// an ordered list ("r1r2r3...."),
//
// -------------------------------------------------------------------------

static int rv32gdb_set_regs (rv32* cpu, const char* cmd, const int cmdlen, char* buf, unsigned char &checksum)
{
    int bdx        = 0;
    int cdx        = 1;
    int start_reg  = 0;
    int end_reg    = NUM_REGS;

    // Retrieve the current CPU state
    cpu_state = cpu->rv32_get_cpu_state();

    // If accessing a single register, get the register number and set
    // the loop for just this register
    if (cmd[0] == 'P')
    {
        start_reg  = CHAR2NIB(cmd[cdx]) << 4; cdx++;
        start_reg |= CHAR2NIB(cmd[cdx]);      cdx++;

        end_reg = start_reg;

        // Skip '=' character
        cdx++;
    }

    // Run through the registers in order until all done, or command
    // buffer run out of characters
    for (int rdx = start_reg; rdx < end_reg && cdx < cmdlen; rdx++)
    {
        int val = 0;

        // Convert the 8 character (for 32 bits) hex nibbles to a number
        for (int cdx = 0; cdx < 4*2; cdx++)
        {
            val  <<= 4;
            val |= CHAR2NIB(cmd[cdx]); cdx++;
        }

        // Update the general purpose registers in the retrieved state structure
        if (rdx < rv32i_consts::RV32I_NUM_OF_REGISTERS)
        {
            cpu_state.x[rdx] = val;
        }
        // Update the special registers n the retrieved state structure
        else
        {
            switch (rdx)
            {
               case RV32_REG_PC  : cpu_state.pc   = val; break;;
            }
        }
    }

    // Write back the updated CPU state
    cpu->rv32_set_cpu_state(cpu_state);

    // Acknowledge the command
    BUFOK(buf, bdx, checksum);

    return bdx;
}

// -------------------------------------------------------------------------
// rv32gdb_read_mem()
//
// Read from cpu memory in reply to a read type command (in cmd), and place
// reply in buf. Format of the command is
//
//   M addr,length
//
// Reply format is 'XX...', as set of hex character pairs for each byte, for
// as many as specified in length, starting from addr in memory. The
// checksum is calculated for the returned characters, and returned in
// checksum.
//
// -------------------------------------------------------------------------

static int rv32gdb_read_mem(rv32* cpu, const char* cmd, const int cmdlen, char *buf, unsigned char &checksum)
{
    int      bdx  = 0;
    int      cdx  = 0;
    unsigned addr = 0;
    unsigned len  = 0;

    // Skip command character
    cdx++;

    // Get address
    while (cdx < cmdlen && cmd[cdx] != ',')
    {
        addr <<= 4;
        addr  |= CHAR2NIB(cmd[cdx]);
        cdx++;
    }

    // Skip comma
    cdx++;

    // Get length
    while (cdx < cmdlen)
    {
        len <<= 4;
        len  |= CHAR2NIB(cmd[cdx]);
        cdx++;
    }

    // Get memory bytes and put values as hex characters in buffer
    for (unsigned idx = 0; idx < len; idx++)
    {
        bool fault;
        unsigned val = cpu->read_mem(addr++, MEM_RD_ACCESS_BYTE, fault);

        checksum += buf[bdx++] = HIHEXCHAR(val);
        checksum += buf[bdx++] = LOHEXCHAR(val);
    }

    return bdx;
}

// -------------------------------------------------------------------------
// rv32gdb_write_mem()
//
// Write to cpu memory in reply to a write type command (in cmd), and place
// a reply in buf. Format of the command is
//
//   M addr,length:XX...
//
// Where XX... is a set of hex character pairs for each byte to be written,
// for length bytes, starting at addr. The data may be in binary format
// (flagged by is_binary), in which case the XX data are single raw bytes,
// some of which are 'escaped' (see commants in function). As the memory
// write command's data can be large, the passed in cmd buffer does not
// contain the data after the ':' delimiter. This is read directly from
// the serial port and placed into the cpu's memory. A reply is placed in
// buf ("OK", or "EIO" if an error), with a calculated checksum returned
// in checksum.
//
// -------------------------------------------------------------------------

static int rv32gdb_write_mem (void* fd, rv32* cpu, const char* cmd, const int cmdlen, char *buf, unsigned char &checksum,
                              const bool is_binary)
{
    int      bdx          = 0;
    int      cdx          = 0;
    unsigned addr         = 0;
    unsigned len          = 0;
    bool     io_status_ok = true;

    // Skip command character
    cdx++;

    // Get address
    while (cdx < cmdlen && cmd[cdx] != ',')
    {
        addr <<= 4;
        addr  |= CHAR2NIB(cmd[cdx]);
        cdx++;
    }

    // Skip comma
    cdx++;

    // Get length
    while (cdx < cmdlen && cmd[cdx] != ':')
    {
        len <<= 4;
        len  |= CHAR2NIB(cmd[cdx]);
        cdx++;
    }

    // Skip colon
    cdx++;

    // Get hex characters byte values and put into memory
    for (unsigned int idx = 0; idx < len; idx++)
    {
        int val;
        char ipbyte[2];

        if (is_binary)
        {
            io_status_ok |= rv32gdb_read(fd, ipbyte);

            val = ipbyte[0];

            // Some binary data is escaped (with '}' character) and the following is the data
            // XORed with a pattern (0x20). '#', '$', and '}' are all escaped. Replies
            // containing '*' (0x2a) must be escaped. See 'Debugging with GDB' manual, Appendix E.1
            if (val == GDB_BIN_ESC)
            {
                io_status_ok |= rv32gdb_read(fd, ipbyte);

                val = ipbyte[0] ^ GDB_BIN_XOR_VAL;
            }
        }
        else
        {
            io_status_ok |= rv32gdb_read(fd, &ipbyte[0]);
            io_status_ok |= rv32gdb_read(fd, &ipbyte[1]);

            // Get byte value from hex
            val  = CHAR2NIB(ipbyte[0]) << 4;
            val |= CHAR2NIB(ipbyte[1]);
        }

        if (io_status_ok)
        {
            bool fault;

            // Write byte to memory
            cpu->write_mem(addr++, val, MEM_WR_ACCESS_BYTE, fault);
#ifdef RV32GDB_DEBUG
            fprintf(stderr, "%02X", val & 0xff);
#endif

        }
        else
        {
            // On an error, break out of the loop
            break;
        }
    }

    // Acknowledge the command
    if (io_status_ok)
    {
        BUFOK(buf, bdx, checksum);
    }
    else
    {
        BUFERR(EIO, buf, bdx, checksum);
    }

    return bdx;
}

// -------------------------------------------------------------------------
// rv32gdb_run_cpu()
//
// Executes the CPU dependent on the particular GDB command (cmd)---either
// continue (c) or single step (s). The default is to run from the current
// PC value, but the command can have an optional address which, if present
// updates the PC value before execution. The cpu's run()
// method is called with the relevant type, which executes until returning
// with a  termination 'reason' value. The RV32 reason is mapped to a
// signal type and, for break- and watchpoints, the interrupt flags cleared.
// The signal is then returned.
//
// Note that the CPU internal int_flags state for BPs and WPs is cleared
// here *before* the CPU can act upon it, allowing non-intrusive debugging,
// and obviating the need for handlers in the code being debugged.
//
// -------------------------------------------------------------------------

static int rv32gdb_run_cpu (rv32* cpu, rv32i_cfg_s &cfg, const char* cmd, const int cmdlen, const int type)
{
    int  reason      = SIGHUP;

    // If there's an address, fetch it and update PC
    if (cmdlen > 1)
    {
        int cdx = 1;

        // Retrieve the current CPU state
        cpu_state = cpu->rv32_get_cpu_state();
        cpu_state.pc = 0;

        // Get the address from the command buffer
        while (cdx < cmdlen)
        {
            cpu_state.pc <<= 4;
            cpu_state.pc |= CHAR2NIB(cmd[cdx]);
            cdx++;
        }
        // Write back the updated CPU state
        cpu->rv32_set_cpu_state(cpu_state);
    }

    // Continue execution
    reason = cpu->run(cfg);

    return reason;
}

// -------------------------------------------------------------------------
// rv32gdb_proc_gdb_cmd()
//
// Processes a single GDB command, as stored in cmd. The command is
// inspected and the appropriate local functions called. Generated replies
// are added to op_buf, with this function bracketing these with $ and #,
// followed by the two character checksum, returned by the functions (if
// any). An exception to a reply is for the kill (k) command which has
// no reply. Unsupported commands return a default reply of "$#00".
// The function sends the reply to the PTY (fd) and then return either
// true if a 'detach' command (D) was seen, otherwise false.
//
// -------------------------------------------------------------------------

static bool rv32gdb_proc_gdb_cmd (rv32* cpu, rv32i_cfg_s &cfg, const char* cmd, const int cmdlen, void* fd)
{
    int           op_idx    = 0;
    unsigned char checksum  = 0;
    bool          rcvd_kill = false;
    bool          detached  = false;
    static int    reason    = 0;

    // Packet start
    op_buf[op_idx++] = GDB_SOP_CHAR;

#ifdef RV32GDB_DEBUG
    fprintf(stderr, "CMD = %s\n", cmd);
#endif

    // Select on command character
    switch(cmd[0])
    {
    // Reason for halt
    case '?':
        op_idx += rv32gdb_gen_register_reply(cpu, cmd, &op_buf[op_idx], checksum, reason);
        break;

    // Read general purpose registers
    case 'g':
        op_idx += rv32gdb_gen_register_reply(cpu, cmd, &op_buf[op_idx], checksum);
        break;

    // Write general purpose registers
    case 'G':
        // Update registers from command
        op_idx += rv32gdb_set_regs(cpu, cmd, cmdlen, &op_buf[op_idx], checksum);
        break;

    // Read memory
    case 'm':
        op_idx += rv32gdb_read_mem(cpu, cmd, cmdlen, &op_buf[op_idx], checksum);
        break;

    // Write memory (binary)
    case 'X':
        op_idx += rv32gdb_write_mem(fd, cpu, cmd, cmdlen, &op_buf[op_idx], checksum, true);
        break;

    // Write memory
    case 'M':
        op_idx += rv32gdb_write_mem(fd, cpu, cmd, cmdlen, &op_buf[op_idx], checksum, false);
        break;

    // Continue
    case 'c':
        // Continue onwards
        cfg.num_instr = 0;
        reason = rv32gdb_run_cpu(cpu, cfg, cmd, cmdlen, RV32_RUN_CONTINUE);

        // On a break, return with a stop reply packet
        op_idx += rv32gdb_gen_register_reply(cpu, cmd, &op_buf[op_idx], checksum, reason);
        break;

    // Single step
    case 's':
        cfg.num_instr = 1;
        reason = rv32gdb_run_cpu(cpu, cfg, cmd, cmdlen, RV32_RUN_SINGLE_STEP);

        // On a break, return with a stop reply packet
        op_idx += rv32gdb_gen_register_reply(cpu, cmd, &op_buf[op_idx], checksum, reason);
        break;

    case 'D':
        detached = true;
        BUFOK(op_buf, op_idx, checksum);
        break;

    case 'p':
        op_idx += rv32gdb_gen_register_reply(cpu, cmd, &op_buf[op_idx], checksum, reason);
        break;

    case 'P':
        op_idx += rv32gdb_set_regs(cpu, cmd, cmdlen, &op_buf[op_idx], checksum);
        break;

    case 'k':
        rcvd_kill = true;
        detached  = true;
        break;
    }

    // Packet end
    op_buf[op_idx++] = GDB_EOP_CHAR;

    // Checksum
    op_buf[op_idx++] = HIHEXCHAR(checksum);
    op_buf[op_idx++] = LOHEXCHAR(checksum);

    // Terminate buffer with a NULL character in case we want to print for debug
    op_buf[op_idx]   = 0;

    // Send reply if not 'kill' command (which has no reply)
    if (!rcvd_kill)
    {
        // Output the response for the gdb command to the terminal
        for (int idx = 0; idx < op_idx; idx++)
        {
            if (!rv32gdb_write(fd, &op_buf[idx]))
            {
                fprintf(stderr, "RV32GDB: ERROR writing to host: terminating.\n");
                return true;
            }
        }

#ifdef RV32GDB_DEBUG
        fprintf(stderr, "\nREPLY: %s\n", op_buf);
#endif

    }

    // In debug node, need to detech on ecall
    if (cfg.hlt_on_ecall && reason == SIGTERM)
    {
        detached = true;
    }

    return detached;
}

// -------------------------------------------------------------------------
// rv32_connect_skt()
//
// Opens a TCP socket connection, suitable for GDB remote debugging, on the
// given port number (portno). It listens for a single connection, before
// returning the connection handle established. If any error occurs,
// RV32GDB_ERR is returned instead.
//
// -------------------------------------------------------------------------

static rv32gdb_skt_t rv32gdb_connect_skt (const int portno)
{
    // Initialise socket environment
    if (rv32gdb_skt_init() < 0)
    {
        return RV32GDB_ERR;
    }

    // Create an IPv4 socket byte stream
    rv32gdb_skt_t svrskt;
    if ((svrskt = socket(AF_INET, SOCK_STREAM, IPPROTO_IP)) < 0)
    {
        fprintf(stderr, "ERROR opening socket\n");
        rv32gdb_skt_cleanup();
        return RV32GDB_ERR;
    }

    // Create and zero a server address structure
    struct sockaddr_in serv_addr;
    ZeroMemory((char *) &serv_addr, sizeof(serv_addr));

    // Configure the server address structure
    serv_addr.sin_family      = AF_INET;
    serv_addr.sin_addr.s_addr = INADDR_ANY;
    serv_addr.sin_port        = htons(portno);

    // Bind the socket to the address
    int status = bind(svrskt, (struct sockaddr *) &serv_addr, sizeof(serv_addr));
    if (status < 0)
    {
        fprintf(stderr, "ERROR on Binding: %d\n", status);
        rv32gdb_skt_cleanup();
        return RV32GDB_ERR;
    }

    // Advertise the port number
    fprintf(stderr, "RV32GDB: Using TCP port number: %d\n", portno);
    fflush(stderr);

    // Listen for connections (blocking)
    if (int status = listen(svrskt, MAXBACKLOG) < 0)
    {
        fprintf(stderr, "ERROR on listening: %d\n", status);
        rv32gdb_skt_cleanup();
        return RV32GDB_ERR;
    }

    // Get a client address structure, and length as has to be passed as a pointer to accept()
    struct sockaddr_in cli_addr;
    socklen_t clilen = sizeof(cli_addr);

    // Accept a connection, and get returned handle
    rv32gdb_skt_t cliskt;
    if ((cliskt = accept(svrskt, (struct sockaddr *) &cli_addr,  &clilen)) < 0)
    {
        fprintf(stderr, "ERROR on accept\n");
        rv32gdb_skt_cleanup();
        return RV32GDB_ERR;
    }

    // No longer need the server side (listening) socket
    closesocket(svrskt);

    // Return the handle to the connected socket. With this handle can
    // use recv()/send() to read and write (or, Linux only, read()/write()).
    return cliskt;
}

// -------------------------------------------------------------------------
// rv32gdb_process_gdb()
//
// Top level for the GDB interface of the rv32 CPU ISS. The function is
// called with a pointer to an rv32_cpu object, pre-configured if desired.
// It calls local functions to create a pseudo/virtual serial port for GDB
// connection, and starts reading characters for this port. It monitors
// for start and end of packets, placing packet contents in ip_buf. Once
// a whole packet is received, it calls rv32gdb_proc_gdb_cmd() to process
// it. This repeats until rv32gdb_proc_gdb_cmd() returns true, flagging
// that the GDB session has detached, when the function cleans up and
// returns. It will return RV32GDB_OK if all is well, else RV32GDB_ERR
// is returned.
//
// -------------------------------------------------------------------------

int rv32gdb_process_gdb (rv32* cpu, int port_num, rv32i_cfg_s &cfg)
{
    int   idx      = 0;
    bool  active   = false;
    bool  detached = false;
    bool  waiting  = true;
    char  ipbyte;
    void* pty_fd;

    // Create a TCP/IP socket
    rv32gdb_skt_t hdl = rv32gdb_connect_skt(port_num);
    if (hdl < 0)
    {
        return PTY_ERROR;
    }
    
    pty_fd = (void *)hdl;

    while (!detached && rv32gdb_read(pty_fd, &ipbyte))
    {
        // If waiting for first communication, flag that attachment has happened.
        if (waiting)
        {
            waiting = false;
            fprintf(stderr, "RV32GDB: host attached.\n");
            fflush(stderr);
        }

        // If receiving a packet end character (or delimiter for mem writes), process the command an go idle
        if (active && (ipbyte  == GDB_EOP_CHAR     ||
                       idx     == IP_BUFFER_SIZE-1 ||
                       (ipbyte == GDB_MEM_DELIM_CHAR && (ip_buf[0] == 'X' || ip_buf[0] == 'M'))))
        {
            // Acknowledge the packet
            if (!rv32gdb_write(pty_fd, &ack_char))
            {
                return RV32GDB_ERR;
            }

            // Terminate the buffer string, for ease of debug
            ip_buf[idx] = 0;

            // Process the command
            detached = rv32gdb_proc_gdb_cmd(cpu, cfg, ip_buf, idx, pty_fd);

            // Flag state as inactive
            active = false;

            // Reset input buffer index
            idx    = 0;

#ifdef RV32GDB_DEBUG
            // At termination echo newline char to stdout
            putchar('\n');
            fflush(stdout);
#endif
        }
        // Wait for a packet start character
        else if (!active && ipbyte == GDB_SOP_CHAR)
        {
            active = true;
        }
        // Get command packet characters, store in buffer [and echo to screen].
        else if (active)
        {
            ip_buf[idx++] = ipbyte;

#ifdef RV32GDB_DEBUG
            // Echo packet data to stdout
            putchar(ipbyte);
            fflush(stdout);
#endif
        }
    }

    if (detached)
    {
        fprintf(stderr, "RV32GDB: host detached or received 'kill' from target: terminating.\n");
    }
    else
    {
        fprintf(stderr, "RV32GDB: connection lost to host: terminating.\n");
    }

    // Close socket of TCP connection
    closesocket((rv32gdb_skt_t)pty_fd);

    return RV32GDB_OK;
}

#ifdef RV32GDB_EXE
// -------------------------------
// Parse command line arguments
//
int parse_args(int argc, char** argv, rv32i_cfg_s &cfg)
{
    int    option;

    int error = 0;


    // Parse the command line arguments and/or configuration file
    // Process the command line options *only* for the INI filename, as we
    // want the command line options to override the INI options
    while ((option = getopt(argc, argv, RV32I_GETOPT_ARG_STR)) != EOF)
    {
        switch (option)
        {
        case 't':
            cfg.exec_fname = optarg;
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
        case 'D':
            if ((cfg.dbg_fp = fopen(optarg, "wb")) == NULL)
            {
                fprintf(stderr, "**ERROR: unable to open specified debug file (%s) for writing.\n", optarg);
                error = 1;
            }
            break;
        case 'a':
            cfg.start_addr = atoi(optarg);
            break;
        case 'h':
        default:
            fprintf(stderr, "Usage: %s -t <test executable> [-hHbdrv][-n <num instructions>]\n      [-a <start addr>][-A <brk addr>][-D <debug o/p filename>]\n", argv[0]);
            fprintf(stderr, "   -t specify test executable (default test.exe)\n");
            fprintf(stderr, "   -n specify number of instructions to run (default 0, i.e. run until unimp)\n");
            fprintf(stderr, "   -a specify  address to start executing (default 0x00000000)\n");
            fprintf(stderr, "   -d Enable disassemble mode (default off)\n");
            fprintf(stderr, "   -r Enable run-time disassemble mode (default off. Overridden by -d)\n");
            fprintf(stderr, "   -H Halt on unimplemented instructions (default trap)\n");
            fprintf(stderr, "   -b Halt at a specific address (default off)\n");
            fprintf(stderr, "   -A Specify halt address if -b active (default 0x00000040)\n");
            fprintf(stderr, "   -D Specify file for debug output (default stdout)\n");
            fprintf(stderr, "   -h display this help message\n");
            error = 1;
            break;
        }
    }

    return error;
}

// -------------------------------------------------------------------------
// MAIN
// -------------------------------------------------------------------------

int main(int argc, char** argv)
{
    rv32i_cfg_s   cfg;

    if (!parse_args(argc, argv, cfg))
    {
        // Create a new cpu object
        rv32* local_cpu = new rv32(cfg.dbg_fp);

        // Start processing commands from GDB
        if (rv32gdb_process_gdb(local_cpu, RV32_DEFAULT_TCP_PORT, cfg))
        {
            fprintf(stderr, "***ERROR in opening PTY\n");
            return PTY_ERROR;
        }
    }

    return 0;
}

#endif
