
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

extern "C" {
    
#include "VUser.h"
}

#define CFGFILENAME                        "vusermain.cfg"
#define RV32I_GETOPT_ARG_STR               "ThHdbrget:n:D:A:p:S:"
#define MAXARGS                            100
#define MEM_SIZE                           (1024*1024)
#define MEM_OFFSET                         0

#define EXT_ACCESS_BASE                    0x10000000
//#define EXT_ACCESS_BASE                    0x20000000
#define EXT_ACCESS_TOP                     0x40000000

// Define a sleep forever macro
#define SLEEP_FOREVER {while(1)            VTick(0x7fffffff, node);}      

