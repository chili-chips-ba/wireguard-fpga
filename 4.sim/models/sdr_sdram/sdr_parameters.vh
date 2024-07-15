/****************************************************************************************
*
*   Disclaimer   This software code and all associated documentation, comments or other 
*  of Warranty:  information (collectively "Software") is provided "AS IS" without 
*                warranty of any kind. MICRON TECHNOLOGY, INC. ("MTI") EXPRESSLY 
*                DISCLAIMS ALL WARRANTIES EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED 
*                TO, NONINFRINGEMENT OF THIRD PARTY RIGHTS, AND ANY IMPLIED WARRANTIES 
*                OF MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE. MTI DOES NOT 
*                WARRANT THAT THE SOFTWARE WILL MEET YOUR REQUIREMENTS, OR THAT THE 
*                OPERATION OF THE SOFTWARE WILL BE UNINTERRUPTED OR ERROR-FREE. 
*                FURTHERMORE, MTI DOES NOT MAKE ANY REPRESENTATIONS REGARDING THE USE OR 
*                THE RESULTS OF THE USE OF THE SOFTWARE IN TERMS OF ITS CORRECTNESS, 
*                ACCURACY, RELIABILITY, OR OTHERWISE. THE ENTIRE RISK ARISING OUT OF USE 
*                OR PERFORMANCE OF THE SOFTWARE REMAINS WITH YOU. IN NO EVENT SHALL MTI, 
*                ITS AFFILIATED COMPANIES OR THEIR SUPPLIERS BE LIABLE FOR ANY DIRECT, 
*                INDIRECT, CONSEQUENTIAL, INCIDENTAL, OR SPECIAL DAMAGES (INCLUDING, 
*                WITHOUT LIMITATION, DAMAGES FOR LOSS OF PROFITS, BUSINESS INTERRUPTION, 
*                OR LOSS OF INFORMATION) ARISING OUT OF YOUR USE OF OR INABILITY TO USE 
*                THE SOFTWARE, EVEN IF MTI HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH 
*                DAMAGES. Because some jurisdictions prohibit the exclusion or 
*                limitation of liability for consequential or incidental damages, the 
*                above limitation may not apply to you.
*
*                Copyright 2005 Micron Technology, Inc. All rights reserved.
*
*	        	 bhoffman - 07/18/06
*
****************************************************************************************/

    // Timing parameters based on Speed Grade and part type (Y37M)

                                          // SYMBOL UNITS DESCRIPTION
                                          // ------ ----- -----------
`ifdef sg6a                               //              Timing Parameters for -6A (CL = 3)
    parameter tCK              =     6.0; // tCK    ns    Nominal Clock Cycle Time
    parameter tCK3_min         =     6.0; // tCK    ns    Nominal Clock Cycle Time
    parameter tCK2_min         =    10.0; // tCK    ns    Nominal Clock Cycle Time
    parameter tCK1_min         =    20.0; // tCK    ns    Nominal Clock Cycle Time
    parameter tAC3             =     5.4; // tAC3   ns    Access time from CLK (pos edge) CL = 3
    parameter tAC2             =     7.5; // tAC2   ns    Access time from CLK (pos edge) CL = 2
    parameter tAC1             =    17.0; // tAC1   ns    Parameter definition for compilation - CL = 1 illegal for sg75
    parameter tHZ3             =     5.4; // tHZ3   ns    Data Out High Z time - CL = 3
    parameter tHZ2             =     7.5; // tHZ2   ns    Data Out High Z time - CL = 2
    parameter tHZ1             =    17.0; // tHZ1   ns    Parameter definition for compilation - CL = 1 illegal for sg75
    parameter tOH              =     3.0; // tOH    ns    Data Out Hold time
    parameter tMRD             =     2.0; // tMRD   tCK   Load Mode Register command cycle time (2 * tCK)
    parameter tRAS             =    42.0; // tRAS   ns    Active to Precharge command time
    parameter tRC              =    60.0; // tRC    ns    Active to Active/Auto Refresh command time
    parameter tRFC             =    60.0; // tRFC   ns    Refresh to Refresh Command interval time
    parameter tRCD             =    18.0; // tRCD   ns    Active to Read/Write command time
    parameter tRP              =    18.0; // tRP    ns    Precharge command period
    parameter tRRD             =     2.0; // tRRD   tCK   Active bank a to Active bank b command time (2 * tCK)
    parameter tWRa             =     6.0; // tWR    ns    Write recovery time (auto-precharge mode - must add 1 CLK)
    parameter tWRm             =    12.0; // tWR    ns    Write recovery time
`elsif sg7e                               //              Timing Parameters for -7E (CL = 3)
    parameter tCK              =     7.0; // tCK    ns    Nominal Clock Cycle Time
    parameter tCK3_min         =     7.0; // tCK    ns    Nominal Clock Cycle Time
    parameter tCK2_min         =     7.5; // tCK    ns    Nominal Clock Cycle Time
    parameter tCK1_min         =     0.0; // tCK    ns    Nominal Clock Cycle Time
    parameter tAC3             =     5.4; // tAC3   ns    Access time from CLK (pos edge) CL = 3
    parameter tAC2             =     5.4; // tAC2   ns    Access time from CLK (pos edge) CL = 2
    parameter tAC1             =     0.0; // tAC1   ns    Parameter definition for compilation - CL = 1 illegal for sg75
    parameter tHZ3             =     5.4; // tHZ3   ns    Data Out High Z time - CL = 3
    parameter tHZ2             =     5.4; // tHZ2   ns    Data Out High Z time - CL = 2
    parameter tHZ1             =     0.0; // tHZ1   ns    Parameter definition for compilation - CL = 1 illegal for sg75
    parameter tOH              =     2.7; // tOH    ns    Data Out Hold time
    parameter tMRD             =     2.0; // tMRD   tCK   Load Mode Register command cycle time (2 * tCK)
    parameter tRAS             =    37.0; // tRAS   ns    Active to Precharge command time
    parameter tRC              =    60.0; // tRC    ns    Active to Active/Auto Refresh command time
    parameter tRFC             =    66.0; // tRFC   ns    Refresh to Refresh Command interval time
    parameter tRCD             =    15.0; // tRCD   ns    Active to Read/Write command time
    parameter tRP              =    15.0; // tRP    ns    Precharge command period
    parameter tRRD             =     2.0; // tRRD   tCK   Active bank a to Active bank b command time (2 * tCK)
    parameter tWRa             =     7.0; // tWR    ns    Write recovery time (auto-precharge mode - must add 1 CLK)
    parameter tWRm             =    14.0; // tWR    ns    Write recovery time
`else `define sg75                        //              Timing Parameters for -75 (CL = 3)
    parameter tCK              =     7.5; // tCK    ns    Nominal Clock Cycle Time
    parameter tCK3_min         =     7.5; // tCK    ns    Nominal Clock Cycle Time
    parameter tCK2_min         =    10.0; // tCK    ns    Nominal Clock Cycle Time
    parameter tCK1_min         =     0.0; // tCK    ns    Nominal Clock Cycle Time
    parameter tAC3             =     5.4; // tAC3   ns    Access time from CLK (pos edge) CL = 3
    parameter tAC2             =     6.0; // tAC2   ns    Access time from CLK (pos edge) CL = 2
    parameter tAC1             =     0.0; // tAC1   ns    Parameter definition for compilation - CL = 1 illegal for sg75
    parameter tHZ3             =     5.4; // tHZ3   ns    Data Out High Z time - CL = 3
    parameter tHZ2             =     6.0; // tHZ2   ns    Data Out High Z time - CL = 2
    parameter tHZ1             =     0.0; // tHZ1   ns    Parameter definition for compilation - CL = 1 illegal for sg75
    parameter tOH              =     2.7; // tOH    ns    Data Out Hold time
    parameter tMRD             =     2.0; // tMRD   tCK   Load Mode Register command cycle time (2 * tCK)
    parameter tRAS             =    44.0; // tRAS   ns    Active to Precharge command time
    parameter tRC              =    66.0; // tRC    ns    Active to Active/Auto Refresh command time
    parameter tRFC             =    66.0; // tRFC   ns    Refresh to Refresh Command interval time
    parameter tRCD             =    20.0; // tRCD   ns    Active to Read/Write command time
    parameter tRP              =    20.0; // tRP    ns    Precharge command period
    parameter tRRD             =     2.0; // tRRD   tCK   Active bank a to Active bank b command time (2 * tCK)
    parameter tWRa             =     7.5; // tWR    ns    Write recovery time (auto-precharge mode - must add 1 CLK)
    parameter tWRm             =    15.0; // tWR    ns    Write recovery time
`endif

    // Size Parameters based on Part Width

`ifdef den64Mb
    `ifdef x4
        parameter ADDR_BITS        =      12; // Set this parameter to control how many Address bits are used
        parameter ROW_BITS         =      12; // Set this parameter to control how many Row bits are used
        parameter COL_BITS         =      10; // Set this parameter to control how many Column bits are used
        parameter DQ_BITS          =       4; // Set this parameter to control how many Data bits are used
        parameter DM_BITS          =       1; // Set this parameter to control how many DM bits are used
        parameter BA_BITS          =       2; // Bank bits
    `elsif x8
        parameter ADDR_BITS        =      12; // Set this parameter to control how many Address bits are used
        parameter ROW_BITS         =      12; // Set this parameter to control how many Row bits are used
        parameter COL_BITS         =       9; // Set this parameter to control how many Column bits are used
        parameter DQ_BITS          =       8; // Set this parameter to control how many Data bits are used
        parameter DM_BITS          =       1; // Set this parameter to control how many DM bits are used
        parameter BA_BITS          =       2; // Bank bits
    `else `define x16
        parameter ADDR_BITS        =      12; // Set this parameter to control how many Address bits are used
        parameter ROW_BITS         =      12; // Set this parameter to control how many Row bits are used
        parameter COL_BITS         =       8; // Set this parameter to control how many Column bits are used
        parameter DQ_BITS          =      16; // Set this parameter to control how many Data bits are used
        parameter DM_BITS          =       2; // Set this parameter to control how many DM bits are used
        parameter BA_BITS          =       2; // Bank bits
    `endif
`elsif den128Mb
    `ifdef x4
        parameter ADDR_BITS        =      12; // Set this parameter to control how many Address bits are used
        parameter ROW_BITS         =      12; // Set this parameter to control how many Row bits are used
        parameter COL_BITS         =      11; // Set this parameter to control how many Column bits are used
        parameter DQ_BITS          =       4; // Set this parameter to control how many Data bits are used
        parameter DM_BITS          =       1; // Set this parameter to control how many DM bits are used
        parameter BA_BITS          =       2; // Bank bits
    `elsif x8
        parameter ADDR_BITS        =      12; // Set this parameter to control how many Address bits are used
        parameter ROW_BITS         =      12; // Set this parameter to control how many Row bits are used
        parameter COL_BITS         =      10; // Set this parameter to control how many Column bits are used
        parameter DQ_BITS          =       8; // Set this parameter to control how many Data bits are used
        parameter DM_BITS          =       1; // Set this parameter to control how many DM bits are used
        parameter BA_BITS          =       2; // Bank bits
    `else `define x16
        parameter ADDR_BITS        =      12; // Set this parameter to control how many Address bits are used
        parameter ROW_BITS         =      12; // Set this parameter to control how many Row bits are used
        parameter COL_BITS         =       9; // Set this parameter to control how many Column bits are used
        parameter DQ_BITS          =      16; // Set this parameter to control how many Data bits are used
        parameter DM_BITS          =       2; // Set this parameter to control how many DM bits are used
        parameter BA_BITS          =       2; // Bank bits
    `endif
`elsif den256Mb
    `ifdef x4
        parameter ADDR_BITS        =      13; // Set this parameter to control how many Address bits are used
        parameter ROW_BITS         =      13; // Set this parameter to control how many Row bits are used
        parameter COL_BITS         =      11; // Set this parameter to control how many Column bits are used
        parameter DQ_BITS          =       4; // Set this parameter to control how many Data bits are used
        parameter DM_BITS          =       1; // Set this parameter to control how many DM bits are used
        parameter BA_BITS          =       2; // Bank bits
    `elsif x8
        parameter ADDR_BITS        =      13; // Set this parameter to control how many Address bits are used
        parameter ROW_BITS         =      13; // Set this parameter to control how many Row bits are used
        parameter COL_BITS         =      10; // Set this parameter to control how many Column bits are used
        parameter DQ_BITS          =       8; // Set this parameter to control how many Data bits are used
        parameter DM_BITS          =       1; // Set this parameter to control how many DM bits are used
        parameter BA_BITS          =       2; // Bank bits
    `else `define x16
        parameter ADDR_BITS        =      13; // Set this parameter to control how many Address bits are used
        parameter ROW_BITS         =      13; // Set this parameter to control how many Row bits are used
        parameter COL_BITS         =       9; // Set this parameter to control how many Column bits are used
        parameter DQ_BITS          =      16; // Set this parameter to control how many Data bits are used
        parameter DM_BITS          =       2; // Set this parameter to control how many DM bits are used
        parameter BA_BITS          =       2; // Bank bits
    `endif
`else `define den512Mb
    `ifdef x4
        parameter ADDR_BITS        =      13; // Set this parameter to control how many Address bits are used
        parameter ROW_BITS         =      13; // Set this parameter to control how many Row bits are used
        parameter COL_BITS         =      12; // Set this parameter to control how many Column bits are used
        parameter DQ_BITS          =       4; // Set this parameter to control how many Data bits are used
        parameter DM_BITS          =       1; // Set this parameter to control how many DM bits are used
        parameter BA_BITS          =       2; // Bank bits
    `elsif x8
        parameter ADDR_BITS        =      13; // Set this parameter to control how many Address bits are used
        parameter ROW_BITS         =      13; // Set this parameter to control how many Row bits are used
        parameter COL_BITS         =      11; // Set this parameter to control how many Column bits are used
        parameter DQ_BITS          =       8; // Set this parameter to control how many Data bits are used
        parameter DM_BITS          =       1; // Set this parameter to control how many DM bits are used
        parameter BA_BITS          =       2; // Bank bits
    `else `define x16
        parameter ADDR_BITS        =      13; // Set this parameter to control how many Address bits are used
        parameter ROW_BITS         =      13; // Set this parameter to control how many Row bits are used
        parameter COL_BITS         =      10; // Set this parameter to control how many Column bits are used
        parameter DQ_BITS          =      16; // Set this parameter to control how many Data bits are used
        parameter DM_BITS          =       2; // Set this parameter to control how many DM bits are used
        parameter BA_BITS          =       2; // Bank bits
    `endif
`endif

    // Other Parameters
    parameter mem_sizes = 2**(ROW_BITS+COL_BITS) - 1;

