// SPDX-License-Identifier: GPL-3.0-or-later

// ====================================================================
//
// SystemVerilog side Virtual Processor, for running host
// programs as control in simulation.
//
// Copyright (c) 2024 Simon Southwell.
//
// This file is part of VProc.
//
// VProc is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// VProc is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with VProc. If not, see <http://www.gnu.org/licenses/>.
//
// ====================================================================

`include "vprocdefs.vh"

`ifdef VPROC_SV
`include "vprocdpi.vh"
`endif

// ============================================================
// VProc module
// ============================================================

module VProc
#(parameter               INT_WIDTH       = 3,
                          NODE_WIDTH      = 4,
                          BURST_ADDR_INCR = 1,
                          DISABLE_DELTA   = 0
)
(
    // Clock
    input                  Clk,

    // Bus interface
    output reg [31:0]      Addr,
    
`ifdef VPROC_BYTE_ENABLE
    output reg  [3:0]      BE,
`endif
    output reg             WE,
    output reg             RD,
    output reg [31:0]      DataOut,
    input      [31:0]      DataIn,
    input                  WRAck,
    input                  RDAck,

    // Interrupt
    input [INT_WIDTH-1:0]  Interrupt,

    // Delta cycle control
    output reg             Update,
    input                  UpdateResponse,

`ifdef VPROC_BURST_IF
    // Burst count
    output reg [11:0]      Burst,
    output reg             BurstFirst,
    output reg             BurstLast,
`endif

    // Node number
    input [NODE_WIDTH-1:0] Node
);

// ------------------------------------------------------------
// Register definitions
// ------------------------------------------------------------

// VSched/VAccess outputs
integer               VPDataOut;
integer               VPAddr;
integer               VPRW;
integer               VPTicks;

// Sampled VProc inputs
integer               DataInSamp;
integer               IntSamp;
integer               IntSampLast;
integer               NodeI;
reg                   RdAckSamp;
reg                   WRAckSamp;

// Internal initialised flag (set after VInit called)
reg                   Initialised;

// Internal state
integer               TickCount;
integer               BlkCount;
integer               AccIdx;
integer               LBE;

`ifndef VPROC_BYTE_ENABLE
// When no byte enable define a local dummy register to
// replace the missing port
reg [3:0]             BE;
`endif

`ifndef VPROC_BURST_IF

// When no burst interface define some local dummy registers to
// replace the missing ports
reg [11:0]            Burst;
reg                   BurstFirst;
reg                   BurstLast;

task vdummy (input integer a, input integer b, input integer c, output integer d);
begin
end
endtask

// vaccess is not defined when no burst interface
`define vaccess vdummy

`else

// When a burst interface defined, use $vaccess/VAccess (for VPI or DPI-C)
`define vaccess `VAccess

`endif

// ------------------------------------------------------------
// Initial process
// ------------------------------------------------------------

initial
begin
    TickCount                           = 1;
    Initialised                         = 0;
    WE                                  = 0;
    RD                                  = 0;
    Update                              = 0;
    BlkCount                            = 0;
    IntSampLast                         = 0;

    // Don't remove delay! Needed to allow Node to be assigned
    // before the call to VInit
    `MINDELAY
    `VInit(Node);
    Initialised                         = 1;
end


// ------------------------------------------------------------
/// Main scheduler process
// ------------------------------------------------------------

always @(posedge Clk)
begin
    // Cleanly sample the inputs and make them integers
    RdAckSamp                           = RDAck;
    WRAckSamp                           = WRAck;
    IntSamp                             = {1'b0, Interrupt};
    NodeI                               = Node;
    VPTicks                             = `DELTACYCLE;

    // Wait until the VProc software is initialised for this node (VInit called)
    // before starting accesses
    if (Initialised == 1'b1)
    begin
        // If an interrupt active, call VSched with interrupt value
        if (IntSamp > 0)
        begin
            `VSched(NodeI, IntSamp, DataInSamp, VPDataOut, VPAddr, VPRW, VPTicks);

            // If interrupt routine returns non-zero tick, then override
            // current tick value. Otherwise, leave at present value.
            if (VPTicks > 0)
            begin
                TickCount               = VPTicks;
            end
        end

        // If vector IRQ enabled, call VIirq when interrupt value changes, passing in
        // new value
        if (IntSamp != IntSampLast)
        begin
          `VIrq(NodeI, IntSamp);
          IntSampLast                   <= IntSamp;
        end

        // If tick, write or a read has completed (or in last cycle)...
        if ((RD === 1'b0 && WE        === 1'b0 && TickCount === 0) ||
            (RD === 1'b1 && RdAckSamp === 1'b1)                    ||
            (WE === 1'b1 && WRAckSamp === 1'b1))
        begin
            BurstFirst                  <= 1'b0;
            BurstLast                   <= 1'b0;

            // Loop accessing new commands until VPTicks is not a delta cycle update
            while (VPTicks < 0)
            begin
                // Clear any interrupt (already dealt with)
                IntSamp                 = 0;

                // Sample the data in port
                DataInSamp              = DataIn;

                if (BlkCount <= 1)
                begin
                    // If this is the last transfer in a burst, call VAccess with
                    // the last data input sample.
                    if (BlkCount == 1)
                    begin
                        AccIdx          = AccIdx + 1;
                        BlkCount        = 0;
                        `vaccess(NodeI, AccIdx, DataInSamp, VPDataOut);
                    end

                    // Get new access command
                    `VSched(NodeI, IntSamp, DataInSamp, VPDataOut, VPAddr, VPRW, VPTicks);

                    // Update the outputs
                    Burst               <= VPRW[`BLKBITS];
                    WE                  <= VPRW[`WEBIT];
                    RD                  <= VPRW[`RDBIT];
                    BE                  <= VPRW[`BEBITS];
                    LBE                 <= VPRW[`LBEBITS];
                    Addr                <= VPAddr;

                    // If new BlkCount is non-zero, setup burst transfer
                    if (VPRW[`BLKBITS] !== 0)
                    begin
                        // Flag burst as first in block
                        BurstFirst      <= 1'b1;

                        // Initialise the burst block counter with count bits
                        BlkCount        = VPRW[`BLKBITS];
                        
                        // If a single word transfer, set the last flag
                        if (BlkCount == 1)
                        begin
                          BurstLast     <= 1'b1;
                        end

                        // On writes, override VPDataOut to get from burst access task VAccess at index 0
                        if (VPRW[`WEBIT])
                        begin
                            AccIdx      = 0;
                            `vaccess(NodeI, AccIdx, `DONTCARE, VPDataOut);
                        end
                        else
                        begin
                            // For reads, intialise index to -1, as it's pre-incremented at next VAccess call
                            AccIdx      = -1;
                        end
                    end

                    // Update DataOut port
                    DataOut             <= VPDataOut;
                end
                // If a block access is valid (BlkCount is non-zero), get the next data out/send back latest sample
                else
                begin
                    AccIdx              = AccIdx + 1;
                    `vaccess(NodeI, AccIdx, DataInSamp, VPDataOut);
                    BlkCount            = BlkCount - 1;

                    if (BlkCount == 1)
                    begin
                        BurstLast       <= 1'b1;
                        BE              <= LBE;
                    end
                    else
                    begin
                        BE              <= 4'hf;
                    end

                    // When bursting, reassert non-delta VPTicks value to break out of loop.
                    VPTicks             = 0;

                    // Update address and data outputs
                    DataOut             <= VPDataOut;
                    Addr                <= Addr + BURST_ADDR_INCR;
                end

                // Update current tick value with returned number (if not negative)
                if (VPTicks > 0)
                begin
                    TickCount           = VPTicks - 1;
                end

                // Flag to update externally and wait for response.
                // The `MINDELAY ensures it's not updated until other outputs
                // are updated.
                Update              <= `MINDELAY ~Update;
                if (DISABLE_DELTA == 0)
                begin
                    @(UpdateResponse);
                end
            end
        end
        else
        begin
            // Count down to zero and stop
            TickCount                   = (TickCount > 0) ? TickCount - 1 : 0;
        end
    end
end

endmodule
