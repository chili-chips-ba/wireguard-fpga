
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

extern "C" {
    
#include "VUser.h"
}

#define CFGFILENAME                        "vusermain.cfg"
#define MAXARGS                            100
#define MEM_SIZE                           (1024*1024)
#define MEM_OFFSET                         0

#ifndef EXT_ACCESS_BASE
#define EXT_ACCESS_BASE                    0x20000000
#endif

#ifndef EXT_ACCESS_TOP
#define EXT_ACCESS_TOP                     0x40000000
#endif

// Define a sleep forever macro
#define SLEEP_FOREVER {while(1)            VTick(0x7fffffff, node);}      

