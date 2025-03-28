//--------------------------------------------------------------------------
// Improved by Chili.CHIPS (2023/24)
//------------------------------------------------------------------------

/**************************************************************************
*
*    File Name:  sdr.sv
*      Version:  2.2
*         Date:  October 12th, 2010
*        Model:  BUS Functional
*    Simulator:  Model Technology
*
* Dependencies:  None
*
*        Email:  modelsupport@micron.com
*      Company:  Micron Technology, Inc.
*
*  Description:  Micron SDRAM Verilog model
*
*   Limitation:  - Doesn't check for refresh timing
*
*         Note:  - Set simulator resolution to "ps" accuracy

*   Disclaimer:  THESE DESIGNS ARE PROVIDED "AS IS" WITH NO WARRANTY
*                WHATSOEVER AND MICRON SPECIFICALLY DISCLAIMS ANY
*                IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR
*                A PARTICULAR PURPOSE, OR AGAINST INFRINGEMENT.
*
*                Copyright � 2001 Micron Semiconductor Products, Inc.
*                All rights researved
*
* Rev  Author          Date        Changes
* ---  --------------------------  ---------------------------------------
* 2.3  SH              05/12/2016  - Update tAC, tHZ timing
*      Micron Technology Inc.
*
* 2.2  SH              10/12/2010  - Combine all parts into sdr_parameters.vh
*      Micron Technology Inc.
*
* 2.1  SH              06/06/2002  - Typo in bank multiplex
*      Micron Technology Inc.
*
* 2.0  SH              04/30/2002  - Second release
*      Micron Technology Inc.
*
**************************************************************************/

`timescale 1ps / 1ps
// Time delays need ps resolution

// verilator lint_off WIDTHTRUNC

module sdr
  import sdram_pkg::*;
(
  input  logic        Clk,
  input  logic        Cke,
  input  logic        Cs_n,
  input  logic        Ras_n,
  input  logic        Cas_n,
  input  logic        We_n,
  input  sdram_row_t  Addr,
  input  sdram_ba_t   Ba,
  input  sdram_dqm_t  Dqm,

//[JI] Hack: Verilator has problem digesting HiZ, esp.
//     when two INOUT ports are connected together
  //[JI] inout  wire [DATA_WIDTH-1:0] Dq,
  input  sdram_data_t Dq_in, //[JI]
  output sdram_data_t Dq_out //[JI]
);

//---------------------------------------------------------
// Micron -sg6a timing parameters: Fmax = 166.7MHz
// Elite M12L64322A(2S)-6 has the same Fmax, but is faster for other params
//---------------------------------------------------------
  localparam real tCK      =  6_000; // tCK    ps    Nominal Clock Cycle Time
  localparam real tCK3_min =  6_000; // tCK    ps    Nominal Clock Cycle Time CL = 3
  localparam real tCK2_min = 10_000; // tCK    ps    Nominal Clock Cycle Time CL = 2
  localparam real tCK1_min = 20_000; // tCK    ps    Nominal Clock Cycle Time CL = 1

  localparam real tAC3     =  5_400; // tAC3   ps    Access time from CLK (pos edge) CL = 3
  localparam real tAC2     =  7_500; // tAC2   ps    Access time from CLK (pos edge) CL = 2
  localparam real tAC1     = 17_000; // tAC1   ps    Access time from CLK (pos edge) CL = 1

  localparam real tHZ3     =  5_400; // tHZ3   ps    Data Out High Z time - CL = 3
  localparam real tHZ2     =  7_500; // tHZ2   ps    Data Out High Z time - CL = 2
  localparam real tHZ1     = 17_000; // tHZ1   ps    Data Out High Z time - CL = 1

  localparam real tOH      =  3_000; // tOH    ps    Data Out Hold time

  localparam real tRAS     = 42_000; // tRAS   ps    Active to Precharge command time
  localparam real tRC      = 60_000; // tRC    ps    Active to Active/Auto Refresh command time
  localparam real tRFC     = 60_000; // tRFC   ps    Refresh to Refresh Command interval time
  localparam real tRCD     = 18_000; // tRCD   ps    Active to Read/Write command time
  localparam real tRP      = 18_000; // tRP    ps    Precharge command period
  localparam real tWRa     =  6_000; // tWR    ps    Write recovery time (auto-precharge mode - must add 1 CLK)
  localparam real tWRm     = 12_000; // tWR    ps    Write recovery time

  localparam real tMRD     =      2; // tMRD   tCK   Load Mode Register command cycle time (2 * tCK)
  localparam real tRRD     =      2; // tRRD   tCK   Active bank a to Active bank b command time (2 * tCK)

//---------------------------------------------------------
  parameter int MEM_SIZES = 2**(ROW_WIDTH+COL_WIDTH) - 1;

  logic [3:0]   Command  [0 : 3];     // Command Operation Pipeline
  sdram_dqm_t   Dqm_pipe2, Dqm_pipe1; // DQM Operation Pipeline

  sdram_ba_t    Bank_addr[0 : 3];     // Bank Address Pipeline

  sdram_row_t   Row;
  sdram_row_t   Mode_reg;
  sdram_row_t   B0_row_addr, B1_row_addr, B2_row_addr, B3_row_addr;

  sdram_col_t   Col_addr [0 : 3];   // Column Address Pipeline
  sdram_col_t   Col, Col_brst;
  sdram_col_t   Col_temp, Burst_counter;

  sdram_data_t  /*[JI] Dq_reg, Dq_dqm*/ Dq_in_data, Dq_out_data, mem_data;
  sdram_data_t  Bank0[MEM_SIZES];
  sdram_data_t  Bank1[MEM_SIZES];
  sdram_data_t  Bank2[MEM_SIZES];
  sdram_data_t  Bank3[MEM_SIZES];

  reg           Act_b0, Act_b1, Act_b2, Act_b3; // Bank Activate
  reg           Pc_b0, Pc_b1, Pc_b2, Pc_b3;     // Bank Precharge

  reg   [1 : 0] Bank_precharge       [0 : 3];   // Precharge Command
  reg           A10_precharge        [0 : 3];   // Addr[10] = 1 (All banks)
  reg           Auto_precharge       [0 : 3];   // RW Auto Precharge (Bank)
  reg           Read_precharge       [0 : 3];   // R  Auto Precharge
  reg           Write_precharge      [0 : 3];   //  W Auto Precharge
  reg           RW_interrupt_read    [0 : 3];   // RW Interrupt Read with Auto Precharge
  reg           RW_interrupt_write   [0 : 3];   // RW Interrupt Write with Auto Precharge
  reg   [1 : 0] RW_interrupt_bank;              // RW Interrupt Bank
  int           RW_interrupt_counter [0 : 3];   // RW Interrupt Counter
  int           Count_precharge      [0 : 3];   // RW Auto Precharge Counter

  reg   [1 : 0] Bank, Prev_bank;

  //------------------------------------------------------
  // Commands Decode
  wire  Active_enable   = ~Cs_n & ~Ras_n &  Cas_n &  We_n;
  wire  Aref_enable     = ~Cs_n & ~Ras_n & ~Cas_n &  We_n;
  wire  Burst_term      = ~Cs_n &  Ras_n &  Cas_n & ~We_n;
  wire  Mode_reg_enable = ~Cs_n & ~Ras_n & ~Cas_n & ~We_n;
  wire  Prech_enable    = ~Cs_n & ~Ras_n &  Cas_n & ~We_n;
  wire  Read_enable     = ~Cs_n &  Ras_n & ~Cas_n &  We_n;
  wire  Write_enable    = ~Cs_n &  Ras_n & ~Cas_n & ~We_n;

  // Burst Length Decode
  wire  Burst_length_1  = ~Mode_reg[2] & ~Mode_reg[1] & ~Mode_reg[0];
  wire  Burst_length_2  = ~Mode_reg[2] & ~Mode_reg[1] &  Mode_reg[0];
  wire  Burst_length_4  = ~Mode_reg[2] &  Mode_reg[1] & ~Mode_reg[0];
  wire  Burst_length_8  = ~Mode_reg[2] &  Mode_reg[1] &  Mode_reg[0];
  wire  Burst_length_f  =  Mode_reg[2] &  Mode_reg[1] &  Mode_reg[0];

  // CAS Latency Decode
  wire [2:0] Cas_latency ={Mode_reg[6],   Mode_reg[5],   Mode_reg[4]};

  // Write Burst Mode
  wire  Write_burst_mode = Mode_reg[9];

  // DQ I/O buffer
  logic       Data_in_enable, Data_out_enable;
  sdram_dqm_t Data_out_enable2; //[JI]

  for (genvar i=0; i <$bits(sdram_dqm_t); i++) begin
     assign Dq_out[i*8 +: 8] = (Data_out_enable2[i] == 1'b1)
                             ? Dq_out_data[i*8 +: 8]
                             : 8'bz;
  end


  // Commands Operation
  typedef enum logic [3:0]{
     ACT   = 4'd0,
     NOP   = 4'd1,
     READ  = 4'd2,
     WRITE = 4'd3,
     PRECH = 4'd4,
     A_REF = 4'd5,
     BST   = 4'd6,
     LMR   = 4'd7
  } cmd_t;

  // These timing dynamically adjust based on CAS Latency
  realtime  tAC, tHZ;

  // Timing Check variable
`ifdef SDRAM_TIMINGCHK
  realtime  MRD_chk;
  realtime  WR_chkm [0 : 3];
  realtime  RFC_chk,  RRD_chk;
  realtime  RC_chk0,  RC_chk1,  RC_chk2,  RC_chk3;
  realtime  RCD_chk0, RCD_chk1, RCD_chk2, RCD_chk3;
  realtime  RP_chk0,  RP_chk1,  RP_chk2,  RP_chk3;
`endif
  realtime  RAS_chk0, RAS_chk1, RAS_chk2, RAS_chk3;

 //------------------------------------------------------
  initial begin: _init
     //Dq_reg = {DATA_WIDTH{1'bz}}; //[JI]
     Data_in_enable   = 1'b0;
     Data_out_enable  = 1'b0;
     Data_out_enable2 = '0; //[JI]

     Act_b0 = 1; Act_b1 = 1; Act_b2 = 1; Act_b3 = 1;
     Pc_b0  = 0; Pc_b1  = 0; Pc_b2  = 0; Pc_b3  = 0;

     RW_interrupt_read [0] = 0;
     RW_interrupt_read [1] = 0;
     RW_interrupt_read [2] = 0;
     RW_interrupt_read [3] = 0;

     RW_interrupt_write[0] = 0;
     RW_interrupt_write[1] = 0;
     RW_interrupt_write[2] = 0;
     RW_interrupt_write[3] = 0;

  `ifdef SDRAM_TIMINGCHK
     WR_chkm[0] = 0; WR_chkm[1] = 0; WR_chkm[2] = 0; WR_chkm[3] = 0;
     MRD_chk    = 0; RFC_chk    = 0; RRD_chk    = 0;
     RCD_chk0   = 0; RCD_chk1   = 0; RCD_chk2   = 0; RCD_chk3   = 0;
     RC_chk0    = 0; RC_chk1    = 0; RC_chk2    = 0; RC_chk3    = 0;
     RP_chk0    = 0; RP_chk1    = 0; RP_chk2    = 0; RP_chk3    = 0;
  `endif
     RAS_chk0   = 0; RAS_chk1   = 0; RAS_chk2   = 0; RAS_chk3   = 0;

    //$timeformat (-9, 1, "ns", 12); //[JI]
    $timeformat (-9, 0, "ns", 12);
  end: _init

  //------------------------------------------------------
  // Internal system clock generator
  reg   CkeZ, Sys_clk;

`ifdef SDRAM_TIMINGCHK
  wire  Dq_chk = Sys_clk & Data_in_enable; // Check setup/hold time for DQ_In
`endif

  always begin
      @ (posedge Clk) begin
          Sys_clk = CkeZ;
          CkeZ    = Cke;
      end
      @ (negedge Clk) begin
          Sys_clk = 1'b0;
      end
  end

  //------------------------------------------------------
  // Adjust tAC, tHZ based on CAS Latency
  always @ (Cas_latency) begin
     case (Cas_latency)
        1 : begin tAC = tAC1; tHZ = tHZ1; end
        2 : begin tAC = tAC2; tHZ = tHZ2; end
        3 : begin tAC = tAC3; tHZ = tHZ3; end
     endcase
  end

  always @ (posedge Sys_clk) begin

      if (|Data_out_enable2 == 1'b1) begin
         Data_out_enable2 <= #tOH {4{Data_out_enable}}; //[JI]
      end

      //------------------------------------------------------
      // Internal Command Pipelines
      Command[0]        = Command[1];
      Command[1]        = Command[2];
      Command[2]        = Command[3];
      Command[3]        = NOP;

      Col_addr[0]       = Col_addr[1];
      Col_addr[1]       = Col_addr[2];
      Col_addr[2]       = Col_addr[3];
      Col_addr[3]       = '0;

      Bank_addr[0]      = Bank_addr[1];
      Bank_addr[1]      = Bank_addr[2];
      Bank_addr[2]      = Bank_addr[3];
      Bank_addr[3]      = 2'b0;

      Bank_precharge[0] = Bank_precharge[1];
      Bank_precharge[1] = Bank_precharge[2];
      Bank_precharge[2] = Bank_precharge[3];
      Bank_precharge[3] = 2'b0;

      A10_precharge[0]  = A10_precharge[1];
      A10_precharge[1]  = A10_precharge[2];
      A10_precharge[2]  = A10_precharge[3];
      A10_precharge[3]  = 1'b0;

      // Dqm pipeline for Read
      Dqm_pipe2 = Dqm_pipe1;
      Dqm_pipe1 = Dqm;

      //------------------------------------------------------
      // Read or Write with Auto Precharge Counter
      if (Auto_precharge[0] === 1'b1) begin
          Count_precharge[0] = Count_precharge[0] + 1;
      end
      if (Auto_precharge[1] === 1'b1) begin
          Count_precharge[1] = Count_precharge[1] + 1;
      end
      if (Auto_precharge[2] === 1'b1) begin
          Count_precharge[2] = Count_precharge[2] + 1;
      end
      if (Auto_precharge[3] === 1'b1) begin
          Count_precharge[3] = Count_precharge[3] + 1;
      end

      //------------------------------------------------------
      // Read or Write Interrupt Counter
      if (RW_interrupt_write[0] === 1'b1) begin
          RW_interrupt_counter[0] = RW_interrupt_counter[0] + 1;
      end
      if (RW_interrupt_write[1] === 1'b1) begin
          RW_interrupt_counter[1] = RW_interrupt_counter[1] + 1;
      end
      if (RW_interrupt_write[2] === 1'b1) begin
          RW_interrupt_counter[2] = RW_interrupt_counter[2] + 1;
      end
      if (RW_interrupt_write[3] === 1'b1) begin
          RW_interrupt_counter[3] = RW_interrupt_counter[3] + 1;
      end

      // tMRD Counter
 `ifdef SDRAM_TIMINGCHK
      MRD_chk = MRD_chk + 1;
 `endif

      //------------------------------------------------------
      // Auto Refresh
      if (Aref_enable === 1'b1) begin
          `ifdef SDRAM_DEBUGNOTE
              $display ("%t %m AREF : Auto Refresh", $time);
          `endif

          // Precharge to Refresh
          if (Pc_b0 === 1'b0 || Pc_b1 === 1'b0 || Pc_b2 === 1'b0 || Pc_b3 === 1'b0) begin
              $display ("%m : at time %t ERROR: All banks must be Precharge before Auto Refresh", $time);
          end


        `ifdef SDRAM_TIMINGCHK
          // Auto Refresh to Auto Refresh
          if ($time - RFC_chk < tRFC) begin
              $display ("%m : at time %t ERROR: tRFC violation during Auto Refresh", $time);
          end

          // Precharge to Auto Refresh
          if (    ($time - RP_chk0 < tRP)
               || ($time - RP_chk1 < tRP)
               || ($time - RP_chk2 < tRP)
               || ($time - RP_chk3 < tRP)
          ) begin
              $display ("%m : at time %t ERROR: tRP violation during Auto Refresh", $time);
          end

          // Load Mode Register to Auto Refresh
          if (MRD_chk < tMRD) begin
              $display ("%m : at time %t ERROR: tMRD violation during Auto Refresh", $time);
          end

          // Record Current tRFC time
          RFC_chk = $time;
        `endif // SDRAM_TIMINGCHK
      end

      //------------------------------------------------------
      // Load Mode Register
      if (Mode_reg_enable === 1'b1) begin
          // Register Mode
          Mode_reg = Addr;

          // Decode CAS Latency, Burst Length, Burst Type, and Write Burst Mode
          $display ("%t %m LMR  : Load Mode Register", $time);

          // CAS Latency
          case (Addr[6:4])
             3'b010  : $display ("\t\tCAS Latency = 2");
             3'b011  : $display ("\t\tCAS Latency = 3");
             default : $display ("\t\tCAS Latency = Reserved");
          endcase

          // Burst Length
          case (Addr[2:0])
             3'b000  : $display ("\t\tBurst Length = 1");
             3'b001  : $display ("\t\tBurst Length = 2");
             3'b010  : $display ("\t\tBurst Length = 4");
             3'b011  : $display ("\t\tBurst Length = 8");
             3'b111  : $display ("\t\tBurst Length = Full");
             default : $display ("\t\tBurst Length = Reserved");
          endcase

          // Burst Type
          if (Addr[3] === 1'b0) begin
             $display ("\t\tBurst Type = Sequential");
          end
          else if (Addr[3] === 1'b1) begin
             $display ("\t\tBurst Type = Interleaved");
          end
          else begin
             $display ("\t\tBurst Type = Reserved");
          end

          // Write Burst Mode
          if (Addr[9] === 1'b0) begin
             $display ("\t\tWrite Burst Mode = Programmed Burst Length");
          end
          else if (Addr[9] === 1'b1) begin
             $display ("\t\tWrite Burst Mode = Single Location Access");
          end
          else begin
             $display ("\t\tWrite Burst Mode = Reserved");
          end

          // Precharge to Load Mode Register
          if ({Pc_b0, Pc_b1, Pc_b2, Pc_b3} === 4'b0000) begin
              $display ("%m : at time %t ERROR: all banks must be Precharge before Load Mode Register", $time);
          end

       `ifdef SDRAM_TIMINGCHK
          // Precharge to Load Mode Register
          if (    ($time - RP_chk0 < tRP)
               || ($time - RP_chk1 < tRP)
               || ($time - RP_chk2 < tRP)
               || ($time - RP_chk3 < tRP)
          ) begin
              $display ("%m : at time %t ERROR: tRP violation during Load Mode Register", $time);
          end

          // Auto Refresh to Load Mode Register
          if ($time - RFC_chk < tRFC) begin
              $display ("%m : at time %t ERROR: tRFC violation during Load Mode Register", $time);
          end

          // Load Mode Register to Load Mode Register
          if (MRD_chk < tMRD) begin
              $display ("%m : at time %t ERROR: tMRD violation during Load Mode Register", $time);
          end

          // Reset MRD Counter
          MRD_chk = 0;
       `endif
      end

      //------------------------------------------------------
      // Active Block (Latch Bank Address and Row Address)
      if (Active_enable === 1'b1) begin
          // Activate an open bank can corrupt data
          if ((Ba === 2'b00 && Act_b0 === 1'b1) || (Ba === 2'b01 && Act_b1 === 1'b1) ||
              (Ba === 2'b10 && Act_b2 === 1'b1) || (Ba === 2'b11 && Act_b3 === 1'b1)) begin
              $display ("%m : at time %t ERROR: Bank already activated -- data can be corrupted", $time);
          end

          // Activate Bank 0
          if (Ba === 2'b00 && Pc_b0 === 1'b1) begin
             `ifdef SDRAM_DEBUGNOTE
                 $display ("%t %m ACT  : Bank = 0 Row = %d", $time, Addr);
             `endif

             `ifdef SDRAM_TIMINGCHK
              // ACTIVE to ACTIVE command period
              if ($time - RC_chk0 < tRC) begin
                  $display ("%m : at time %t ERROR: tRC violation during Activate bank 0", $time);
              end

              // Precharge to Activate Bank 0
              if ($time - RP_chk0 < tRP) begin
                  $display ("%m : at time %t ERROR: tRP violation during Activate bank 0", $time);
              end

              // Record variables
              RC_chk0     = $time;
              RCD_chk0    = $time;
             `endif
              RAS_chk0    = $time;

              Act_b0      = 1'b1;
              Pc_b0       = 1'b0;
              B0_row_addr = Addr [ROW_WIDTH - 1 : 0];
          end

          if (Ba == 2'b01 && Pc_b1 == 1'b1) begin
             `ifdef SDRAM_DEBUGNOTE
                 $display ("%t %m ACT  : Bank = 1 Row = %d", $time, Addr);
             `endif

             `ifdef SDRAM_TIMINGCHK
              // ACTIVE to ACTIVE command period
              if ($time - RC_chk1 < tRC) begin
                  $display ("%m : at time %t ERROR: tRC violation during Activate bank 1", $time);
              end

              // Precharge to Activate Bank 1
              if ($time - RP_chk1 < tRP) begin
                  $display ("%m : at time %t ERROR: tRP violation during Activate bank 1", $time);
              end

              // Record variables
              RC_chk1     = $time;
              RCD_chk1    = $time;
             `endif
              RAS_chk1    = $time;

              Act_b1      = 1'b1;
              Pc_b1       = 1'b0;
              B1_row_addr = Addr [ROW_WIDTH - 1 : 0];
          end

          if (Ba == 2'b10 && Pc_b2 == 1'b1) begin
             `ifdef SDRAM_DEBUGNOTE
                 $display ("%t %m ACT  : Bank = 2 Row = %d", $time, Addr);
             `endif

            `ifdef SDRAM_TIMINGCHK
              // ACTIVE to ACTIVE command period
              if ($time - RC_chk2 < tRC) begin
                  $display ("%m : at time %t ERROR: tRC violation during Activate bank 2", $time);
              end

              // Precharge to Activate Bank 2
              if ($time - RP_chk2 < tRP) begin
                  $display ("%m : at time %t ERROR: tRP violation during Activate bank 2", $time);
              end

              // Record variables
              RC_chk2     = $time;
              RCD_chk2    = $time;
             `endif
              RAS_chk2    = $time;

              Act_b2      = 1'b1;
              Pc_b2       = 1'b0;
              B2_row_addr = Addr [ROW_WIDTH - 1 : 0];
          end

          if (Ba == 2'b11 && Pc_b3 == 1'b1) begin
             `ifdef SDRAM_DEBUGNOTE
                 $display ("%t %m ACT  : Bank = 3 Row = %d", $time, Addr);
             `endif

             `ifdef SDRAM_TIMINGCHK
              // ACTIVE to ACTIVE command period
              if ($time - RC_chk3 < tRC) begin
                  $display ("%m : at time %t ERROR: tRC violation during Activate bank 3", $time);
              end

              // Precharge to Activate Bank 3
              if ($time - RP_chk3 < tRP) begin
                  $display ("%m : at time %t ERROR: tRP violation during Activate bank 3", $time);
              end

              // Record variables
              RC_chk3     = $time;
              RCD_chk3    = $time;
             `endif
              RAS_chk3    = $time;

              Act_b3      = 1'b1;
              Pc_b3       = 1'b0;
              B3_row_addr = Addr [ROW_WIDTH - 1 : 0];
          end

        `ifdef SDRAM_TIMINGCHK
          // Active Bank A to Active Bank B
          if ((Prev_bank != Ba) && ($time - RRD_chk < tRRD)) begin
              $display ("%m : at time %t ERROR: tRRD violation during Activate bank = %d", $time, Ba);
          end

          // Auto Refresh to Activate
          if ($time - RFC_chk < tRFC) begin
              $display ("%m : at time %t ERROR: tRFC violation during Activate bank = %d", $time, Ba);
          end

          // Load Mode Register to Active
          if (MRD_chk < tMRD ) begin
              $display ("%m : at time %t ERROR: tMRD violation during Activate bank = %d", $time, Ba);
          end

          // Record variables for checking violation
          RRD_chk   = $time;
         `endif

          Prev_bank = Ba;
      end

      //------------------------------------------------------
      // Precharge Block
      if (Prech_enable == 1'b1) begin

         `ifdef SDRAM_TIMINGCHK
          // Load Mode Register to Precharge
          if ($time - MRD_chk < tMRD) begin
              $display ("%m : at time %t ERROR: tMRD violation during Precharge", $time);
          end
         `endif

          // Precharge Bank 0
          if ((Addr[10] === 1'b1 || (Addr[10] === 1'b0 && Ba === 2'b00)) && Act_b0 === 1'b1) begin
              Act_b0  = 1'b0;
              Pc_b0   = 1'b1;

            `ifdef SDRAM_TIMINGCHK
              RP_chk0 = $time;

              // Activate to Precharge
              if ($time - RAS_chk0 < tRAS) begin
                  $display ("%m : at time %t ERROR: tRAS violation during Precharge", $time);
              end

              // tWR violation check for write
              if ($time - WR_chkm[0] < tWRm) begin
                  $display ("%m : at time %t ERROR: tWR violation during Precharge", $time);
              end
             `endif
          end

          // Precharge Bank 1
          if ((Addr[10] === 1'b1 || (Addr[10] === 1'b0 && Ba === 2'b01)) && Act_b1 === 1'b1) begin
              Act_b1  = 1'b0;
              Pc_b1   = 1'b1;

            `ifdef SDRAM_TIMINGCHK
              RP_chk1 = $time;

              // Activate to Precharge
              if ($time - RAS_chk1 < tRAS) begin
                  $display ("%m : at time %t ERROR: tRAS violation during Precharge", $time);
              end

              // tWR violation check for write
              if ($time - WR_chkm[1] < tWRm) begin
                  $display ("%m : at time %t ERROR: tWR violation during Precharge", $time);
              end
             `endif
          end

          // Precharge Bank 2
          if ((Addr[10] === 1'b1 || (Addr[10] === 1'b0 && Ba === 2'b10)) && Act_b2 === 1'b1) begin
              Act_b2  = 1'b0;
              Pc_b2   = 1'b1;

            `ifdef SDRAM_TIMINGCHK
              RP_chk2 = $time;

              // Activate to Precharge
              if ($time - RAS_chk2 < tRAS) begin
                  $display ("%m : at time %t ERROR: tRAS violation during Precharge", $time);
              end

              // tWR violation check for write
              if ($time - WR_chkm[2] < tWRm) begin
                  $display ("%m : at time %t ERROR: tWR violation during Precharge", $time);
              end
             `endif
          end

          // Precharge Bank 3
          if ((Addr[10] === 1'b1 || (Addr[10] === 1'b0 && Ba === 2'b11)) && Act_b3 === 1'b1) begin
              Act_b3  = 1'b0;
              Pc_b3   = 1'b1;

            `ifdef SDRAM_TIMINGCHK
              RP_chk3 = $time;

              // Activate to Precharge
              if ($time - RAS_chk3 < tRAS) begin
                  $display ("%m : at time %t ERROR: tRAS violation during Precharge", $time);
              end

              // tWR violation check for write
              if ($time - WR_chkm[3] < tWRm) begin
                  $display ("%m : at time %t ERROR: tWR violation during Precharge", $time);
              end
             `endif
          end

          if (Data_in_enable == 1'b1) begin
             // Precharge truncation with DQM set
             if (Dqm != '1) begin
                 $display ("%m : at time %t ERROR: DQM not inactive during Precharge truncation", $time);
             end

             // Terminate the Write Immediately (if same bank or all banks)
             if ((Bank === Ba) || (Addr[10] === 1'b1)) begin
                 Data_in_enable = 1'b0;
             end
          end

          // Precharge Command Pipeline for Read
          Command       [Cas_latency - 1] = PRECH;
          Bank_precharge[Cas_latency - 1] = Ba;
          A10_precharge [Cas_latency - 1] = Addr[10];
      end

      //------------------------------------------------------
      // Burst terminate
      if (Burst_term === 1'b1) begin
          // Terminate a Write Immediately
          if (Data_in_enable == 1'b1) begin
              Data_in_enable = 1'b0;
          end

          // Terminate a Read Depend on CAS Latency
          Command[Cas_latency - 1] = BST;

         `ifdef SDRAM_DEBUG
             $display ("%t %m BST  : Burst Terminate",$time);
         `endif
      end

      //------------------------------------------------------
      // Read, Write, Column Latch
      if (Read_enable === 1'b1) begin
          // Check to see if bank is open (ACT)
          if ((Ba == 2'b00 && Pc_b0 == 1'b1) || (Ba == 2'b01 && Pc_b1 == 1'b1) ||
              (Ba == 2'b10 && Pc_b2 == 1'b1) || (Ba == 2'b11 && Pc_b3 == 1'b1)) begin
              $display("%m : at time %t ERROR: Bank is not Activated for Read", $time);
          end

         `ifdef SDRAM_TIMINGCHK
          // Activate to Read or Write
          if ((Ba == 2'b00) && ($time - RCD_chk0 < tRCD) ||
              (Ba == 2'b01) && ($time - RCD_chk1 < tRCD) ||
              (Ba == 2'b10) && ($time - RCD_chk2 < tRCD) ||
              (Ba == 2'b11) && ($time - RCD_chk3 < tRCD)) begin
              $display("%m : at time %t ERROR: tRCD violation during Read", $time);
          end
         `endif

          // CAS Latency pipeline
          Command  [Cas_latency - 1] = READ;
          Col_addr [Cas_latency - 1] = Addr[COL_WIDTH-1:0];
          Bank_addr[Cas_latency - 1] = Ba;

          // Read interrupt Write (terminate Write immediately)
          if (Data_in_enable == 1'b1) begin
              Data_in_enable = 1'b0;

              // Interrupting a Write with Autoprecharge
              if (    (Auto_precharge [RW_interrupt_bank] == 1'b1)
                   && (Write_precharge[RW_interrupt_bank] == 1'b1)
              ) begin
                  RW_interrupt_write  [RW_interrupt_bank] = 1'b1;
                  RW_interrupt_counter[RW_interrupt_bank] = 0;

                  $display ("%t %m WARNING : Read interrupt Write with Autoprecharge", $time);
              end
          end

          // Read with Auto Precharge
          if (Addr[10] == 1'b1) begin
              Auto_precharge [Ba] = 1'b1;
              Count_precharge[Ba] = 0;
              RW_interrupt_bank   = Ba;
              Read_precharge [Ba] = 1'b1;
          end
      end

      //------------------------------------------------------
      // Write Command
      if (Write_enable == 1'b1) begin
          // Activate to Write
          if (    (Ba == 2'b00 && Pc_b0 == 1'b1) || (Ba == 2'b01 && Pc_b1 == 1'b1)
               || (Ba == 2'b10 && Pc_b2 == 1'b1) || (Ba == 2'b11 && Pc_b3 == 1'b1)
          ) begin
              $display("%m : at time %t ERROR: Bank is not Activated for Write", $time);
          end

         `ifdef SDRAM_TIMINGCHK
          // Activate to Read or Write
          if (   (Ba == 2'b00) && ($time - RCD_chk0 < tRCD)
              || (Ba == 2'b01) && ($time - RCD_chk1 < tRCD)
              || (Ba == 2'b10) && ($time - RCD_chk2 < tRCD)
              || (Ba == 2'b11) && ($time - RCD_chk3 < tRCD)
          ) begin
              $display("%m : at time %t ERROR: tRCD violation during Read", $time);
          end
         `endif

          // Latch Write command, Bank, and Column
          Command  [0] = WRITE;
          Col_addr [0] = Addr[COL_WIDTH-1:0];
          Bank_addr[0] = Ba;

          // Write interrupt Write (terminate Write immediately)
          if (Data_in_enable == 1'b1) begin
              Data_in_enable = 1'b0;

              // Interrupting a Write with Autoprecharge
              if (    (Auto_precharge [RW_interrupt_bank] == 1'b1)
                   && (Write_precharge[RW_interrupt_bank] == 1'b1)
                 ) begin
                  RW_interrupt_write[RW_interrupt_bank] = 1'b1;

                  // Display debug message
                  $display ("%t %m WARNING : Read Bank %d interrupt Write Bank %d with Autoprecharge", $time, Ba, RW_interrupt_bank);
              end
          end

          // Write interrupt Read (terminate Read immediately)
          if (Data_out_enable == 1'b1) begin
              Data_out_enable = 1'b0;

              // Interrupting a Read with Autoprecharge
              if (  (Auto_precharge[RW_interrupt_bank] == 1'b1)
                  &&(Read_precharge[RW_interrupt_bank] == 1'b1)
              ) begin
                  RW_interrupt_read[RW_interrupt_bank] = 1'b1;

                  $display ("%t %m WARNING : Write Bank %d interrupt Read Bank %d with Autoprecharge", $time, Ba, RW_interrupt_bank);
              end
          end

          // Write with Auto Precharge
          if (Addr[10] == 1'b1) begin
              Auto_precharge [Ba] = 1'b1;
              Count_precharge[Ba] = 0;
              RW_interrupt_bank   = Ba;
              Write_precharge[Ba] = 1'b1;
          end
      end

      //------------------------------------------------------
      /*
          Write with Auto Precharge Calculation
              The device start internal precharge when:
                  1.  Meet minimum tRAS requirement
              and 2.  tWR cycle(s) after last valid data
               or 3.  Interrupt by a Read or Write (with or without Auto Precharge)

          Note: Model is starting the internal precharge 1 cycle after they meet all the
                requirement but tRP will be compensate for the time after the 1 cycle.
      */
      if ((Auto_precharge[0] == 1'b1) && (Write_precharge[0] == 1'b1)) begin
          if ((($time - RAS_chk0 >= tRAS) &&                                                          // Case 1
             (((Burst_length_1 == 1'b1 || Write_burst_mode == 1'b1) && Count_precharge [0] >= 1) ||   // Case 2
               (Burst_length_2 == 1'b1                              && Count_precharge [0] >= 2) ||
               (Burst_length_4 == 1'b1                              && Count_precharge [0] >= 4) ||
               (Burst_length_8 == 1'b1                              && Count_precharge [0] >= 8))) ||
               (RW_interrupt_write[0] == 1'b1 && RW_interrupt_counter[0] >= 1)) begin                 // Case 3
                  Auto_precharge[0]     = 1'b0;
                  Write_precharge[0]    = 1'b0;
                  RW_interrupt_write[0] = 1'b0;
                  Pc_b0                 = 1'b1;
                  Act_b0                = 1'b0;
                `ifdef SDRAM_TIMINGCHK
                  RP_chk0               = $time + tWRa;
                `endif

                `ifdef SDRAM_DEBUGNOTE
                    $display ("%t %m NOTE : Start Internal Auto Precharge for Bank 0", $time);
                `endif
          end
      end
      if ((Auto_precharge[1] == 1'b1) && (Write_precharge[1] == 1'b1)) begin
          if ((($time - RAS_chk1 >= tRAS) &&                                                          // Case 1
             (((Burst_length_1 == 1'b1 || Write_burst_mode == 1'b1) && Count_precharge [1] >= 1) ||   // Case 2
               (Burst_length_2 == 1'b1                              && Count_precharge [1] >= 2) ||
               (Burst_length_4 == 1'b1                              && Count_precharge [1] >= 4) ||
               (Burst_length_8 == 1'b1                              && Count_precharge [1] >= 8))) ||
               (RW_interrupt_write[1] == 1'b1 && RW_interrupt_counter[1] >= 1)) begin                 // Case 3
                  Auto_precharge[1] = 1'b0;
                  Write_precharge[1] = 1'b0;
                  RW_interrupt_write[1] = 1'b0;
                  Pc_b1 = 1'b1;
                  Act_b1 = 1'b0;
                 `ifdef SDRAM_TIMINGCHK
                  RP_chk1 = $time + tWRa;
                 `endif

                 `ifdef SDRAM_DEBUGNOTE
                     $display ("%t %m NOTE : Start Internal Auto Precharge for Bank 1", $time);
                 `endif
          end
      end
      if ((Auto_precharge[2] == 1'b1) && (Write_precharge[2] == 1'b1)) begin
          if ((($time - RAS_chk2 >= tRAS) &&                                                          // Case 1
             (((Burst_length_1 == 1'b1 || Write_burst_mode == 1'b1) && Count_precharge [2] >= 1) ||   // Case 2
               (Burst_length_2 == 1'b1                              && Count_precharge [2] >= 2) ||
               (Burst_length_4 == 1'b1                              && Count_precharge [2] >= 4) ||
               (Burst_length_8 == 1'b1                              && Count_precharge [2] >= 8))) ||
               (RW_interrupt_write[2] == 1'b1 && RW_interrupt_counter[2] >= 1)) begin                 // Case 3
                  Auto_precharge[2] = 1'b0;
                  Write_precharge[2] = 1'b0;
                  RW_interrupt_write[2] = 1'b0;
                  Pc_b2 = 1'b1;
                  Act_b2 = 1'b0;
                `ifdef SDRAM_TIMINGCHK
                  RP_chk2 = $time + tWRa;
                `endif

                `ifdef SDRAM_DEBUGNOTE
                    $display ("%t %m NOTE : Start Internal Auto Precharge for Bank 2", $time);
                `endif
          end
      end
      if ((Auto_precharge[3] == 1'b1) && (Write_precharge[3] == 1'b1)) begin
          if ((($time - RAS_chk3 >= tRAS) &&                                                          // Case 1
             (((Burst_length_1 == 1'b1 || Write_burst_mode == 1'b1) && Count_precharge [3] >= 1) ||   // Case 2
               (Burst_length_2 == 1'b1                              && Count_precharge [3] >= 2) ||
               (Burst_length_4 == 1'b1                              && Count_precharge [3] >= 4) ||
               (Burst_length_8 == 1'b1                              && Count_precharge [3] >= 8))) ||
               (RW_interrupt_write[3] == 1'b1 && RW_interrupt_counter[3] >= 1)) begin                 // Case 3
                  Auto_precharge[3]     = 1'b0;
                  Write_precharge[3]    = 1'b0;
                  RW_interrupt_write[3] = 1'b0;
                  Pc_b3   = 1'b1;
                  Act_b3  = 1'b0;
                 `ifdef SDRAM_TIMINGCHK
                  RP_chk3 = $time + tWRa;
                 `endif

                 `ifdef SDRAM_DEBUGNOTE
                     $display ("%t %m NOTE : Start Internal Auto Precharge for Bank 3", $time);
                 `endif
          end
      end

      //------------------------------------------------------
      //  Read with Auto Precharge Calculation
      //      The device start internal precharge:
      //          1.  Meet minimum tRAS requirement
      //      and 2.  CAS Latency - 1 cycles before last burst
      //       or 3.  Interrupt by a Read or Write (with or without AutoPrecharge)
      if ((Auto_precharge[0] == 1'b1) && (Read_precharge[0] == 1'b1)) begin
          if (( ($time - RAS_chk0 >= tRAS) &&
               (    (Burst_length_1 == 1'b1 && Count_precharge[0] >= 1)
                 || (Burst_length_2 == 1'b1 && Count_precharge[0] >= 2)
                 || (Burst_length_4 == 1'b1 && Count_precharge[0] >= 4)
                 || (Burst_length_8 == 1'b1 && Count_precharge[0] >= 8)
               )
             ) || (RW_interrupt_read[0] == 1'b1)
          ) begin // Case 3
              Pc_b0                = 1'b1;
              Act_b0               = 1'b0;
              Auto_precharge[0]    = 1'b0;
              Read_precharge[0]    = 1'b0;
              RW_interrupt_read[0] = 1'b0;
             `ifdef SDRAM_TIMINGCHK
              RP_chk0              = $time;
             `endif

             `ifdef SDRAM_DEBUGNOTE
                $display ("%t %m NOTE : Start Internal Auto Precharge for Bank 0", $time);
             `endif
          end
      end
      if ((Auto_precharge[1] == 1'b1) && (Read_precharge[1] == 1'b1)) begin
          if ((($time - RAS_chk1 >= tRAS) &&
              (    (Burst_length_1 == 1'b1 && Count_precharge[1] >= 1)
                || (Burst_length_2 == 1'b1 && Count_precharge[1] >= 2)
                || (Burst_length_4 == 1'b1 && Count_precharge[1] >= 4)
                || (Burst_length_8 == 1'b1 && Count_precharge[1] >= 8)
              )
              ) || (RW_interrupt_read[1] == 1'b1)
          ) begin
              Pc_b1                = 1'b1;
              Act_b1               = 1'b0;
              Auto_precharge[1]    = 1'b0;
              Read_precharge[1]    = 1'b0;
              RW_interrupt_read[1] = 1'b0;
             `ifdef SDRAM_TIMINGCHK
              RP_chk1              = $time;
             `endif

             `ifdef SDRAM_DEBUGNOTE
                $display ("%t %m NOTE : Start Internal Auto Precharge for Bank 1", $time);
             `endif
          end
      end
      if ((Auto_precharge[2] == 1'b1) && (Read_precharge[2] == 1'b1)) begin
          if ((($time - RAS_chk2 >= tRAS) &&
              (    (Burst_length_1 == 1'b1 && Count_precharge[2] >= 1)
                || (Burst_length_2 == 1'b1 && Count_precharge[2] >= 2)
                || (Burst_length_4 == 1'b1 && Count_precharge[2] >= 4)
                || (Burst_length_8 == 1'b1 && Count_precharge[2] >= 8)
              )
              ) || (RW_interrupt_read[2] == 1'b1)
          ) begin
              Pc_b2                = 1'b1;
              Act_b2               = 1'b0;
              Auto_precharge[2]    = 1'b0;
              Read_precharge[2]    = 1'b0;
              RW_interrupt_read[2] = 1'b0;
             `ifdef SDRAM_TIMINGCHK
              RP_chk2              = $time;
             `endif

             `ifdef SDRAM_DEBUGNOTE
                 $display ("%t %m NOTE : Start Internal Auto Precharge for Bank 2", $time);
             `endif
          end
      end
      if ((Auto_precharge[3] == 1'b1) && (Read_precharge[3] == 1'b1)) begin
          if ((($time - RAS_chk3 >= tRAS) &&
              (    (Burst_length_1 == 1'b1 && Count_precharge[3] >= 1)
                || (Burst_length_2 == 1'b1 && Count_precharge[3] >= 2)
                || (Burst_length_4 == 1'b1 && Count_precharge[3] >= 4)
                || (Burst_length_8 == 1'b1 && Count_precharge[3] >= 8)
              )
              ) || (RW_interrupt_read[3] == 1'b1)
          ) begin
              Pc_b3                = 1'b1;
              Act_b3               = 1'b0;
              Auto_precharge[3]    = 1'b0;
              Read_precharge[3]    = 1'b0;
              RW_interrupt_read[3] = 1'b0;
             `ifdef SDRAM_TIMINGCHK
              RP_chk3              = $time;
             `endif

             `ifdef SDRAM_DEBUGNOTE
                 $display("%t %m NOTE : Start Internal Auto Precharge for Bank 3", $time);
             `endif
          end
      end

      //------------------------------------------------------
      // Internal Precharge or Bst
      if (Command[0] == PRECH) begin // Precharge terminate a read with same bank or all banks
          if (Bank_precharge[0] == Bank || A10_precharge[0] == 1'b1) begin
              if (Data_out_enable == 1'b1) begin
                  Data_out_enable = 1'b0;
              end
          end
      end
      else if (Command[0] == BST) begin // BST terminate a read to current bank
          if (Data_out_enable == 1'b1) begin
              Data_out_enable = 1'b0;
          end
      end

      //[JI] if (Data_out_enable == 1'b0) begin
      //[JI]   //%Error-UNSUPPORTED: Unsupported tristate construct: ASSIGNDLY
      //[JI]   //Dq_reg <= #tOH {DATA_WIDTH{1'bz}};
      //[JI] end

      //------------------------------------------------------
      // Detect Read command
      if (Command[0] == READ) begin
          Bank     = Bank_addr[0];
          Col      = Col_addr[0];
          Col_brst = Col_addr[0];

          case (Bank_addr[0])
              2'b00 : Row = B0_row_addr;
              2'b01 : Row = B1_row_addr;
              2'b10 : Row = B2_row_addr;
              2'b11 : Row = B3_row_addr;
          endcase

          Burst_counter   = 0;
          Data_in_enable  = 1'b0;
          Data_out_enable = 1'b1;
      end // if (Command[0] == READ)

      //------------------------------------------------------
      // Detect Write command
      else if (Command[0] == WRITE) begin
          Bank     = Bank_addr[0];
          Col      = Col_addr[0];
          Col_brst = Col_addr[0];
          case (Bank_addr[0])
              2'b00 : Row = B0_row_addr;
              2'b01 : Row = B1_row_addr;
              2'b10 : Row = B2_row_addr;
              2'b11 : Row = B3_row_addr;
          endcase

          Burst_counter   = 0;
          Data_in_enable  = 1'b1;
          Data_out_enable = 1'b0;
      end // if (Command[0] == WRITE)


     //-------------------------------------------------------
     // DQ Receiver: WRITE'ing Data to Memory
     //-------------------------------------------------------
      if (Data_in_enable == 1'b1) begin
          // 1) First retrieve the currently stored value, to apply mask
          case (Bank)
              2'b00 : mem_data = Bank0 [{Row, Col}];
              2'b01 : mem_data = Bank1 [{Row, Col}];
              2'b10 : mem_data = Bank2 [{Row, Col}];
              2'b11 : mem_data = Bank3 [{Row, Col}];
          endcase

          // 2) Then override unmasked positions with new input data
          //for (int i=0; i < $bits(sdram_dqm_t); i++) begin
          //   Dq_in_data[i*8 +: 8] = (Dqm[i] == 1'b1)
          //                        ? mem_data[i*8 +: 8]
          //                        : Dq_in   [i*8 +: 8];
          //end

          Dq_in_data[ 7: 0] = (Dqm[0] == 1'b1) ? mem_data[ 7: 0] : Dq_in[ 7: 0];
          Dq_in_data[15: 8] = (Dqm[1] == 1'b1) ? mem_data[15: 8] : Dq_in[15: 8];
          Dq_in_data[23:16] = (Dqm[2] == 1'b1) ? mem_data[23:16] : Dq_in[23:16];
          Dq_in_data[31:24] = (Dqm[3] == 1'b1) ? mem_data[31:24] : Dq_in[31:24];

          //`ifdef x4
          //   if (Dqm[0] == 1'b0) begin
          //      Dq_dqm [ 3 : 0] = Dq [ 3 : 0];
          //   end
          //`elsif x8
          //   if (Dqm[0] == 1'b0) begin
          //      Dq_dqm [ 7 : 0] = Dq [ 7 : 0];
          //   end
          //`elsif x16
          //   if (Dqm[0] == 1'b0) begin
          //      Dq_dqm [ 7 : 0] = Dq [ 7 : 0];
          //   end
          //   if (Dqm[1] == 1'b0) begin
          //      Dq_dqm [15 : 8] = Dq [15 : 8];
          //   end
          //`endif

          // 3) Write the result back to memory
          case (Bank)
              2'b00 : Bank0 [{Row, Col}] = Dq_in_data;
              2'b01 : Bank1 [{Row, Col}] = Dq_in_data;
              2'b10 : Bank2 [{Row, Col}] = Dq_in_data;
              2'b11 : Bank3 [{Row, Col}] = Dq_in_data;
          endcase

          // 4) Display debug message
          if (Dqm === '1) begin
             `ifdef SDRAM_DEBUG
                 $display("%t %m WRITE [%08x]<=NONE since DQM='1 (Bank=%0d Row=%0d Col=%0d)",
                           $time, {Bank, Row, Col}, Bank, Row, Col);
             `endif
          end
          else begin
              // Record tWR for manual precharge
             `ifdef SDRAM_TIMINGCHK
              WR_chkm [Bank] = $time;
             `endif

             `ifdef SDRAM_DEBUG
                 $display("%t %m WRITE [%08x]<=%08x (Dqm=%b)", $time,
                           {Bank, Row, Col, 2'd0}, Dq_in_data, Dqm);
             `endif
          end

          // 5) Advance burst counter subroutine
          //#tHZ Burst_decode;
         #tHZ;         //[JI]
         Burst_decode; //[JI]
      end // if (Data_in_enable == 1'b1)


      //-------------------------------------------------------
      // DQ Driver: READ'ing Data from Memory
      //-------------------------------------------------------
      else if (Data_out_enable == 1'b1) begin
          // 1) First retrieve the currently stored value
          case (Bank)
              2'b00 : mem_data = Bank0[{Row, Col}];
              2'b01 : mem_data = Bank1[{Row, Col}];
              2'b10 : mem_data = Bank2[{Row, Col}];
              2'b11 : mem_data = Bank3[{Row, Col}];
          endcase

          //// 2) Then apply the masking
          //// we use '1 in lieu of 'Z
          //if (Dqm_pipe2[0] == 1'b1) mem_data[ 7 : 0] = '1;
          //if (Dqm_pipe2[1] == 1'b1) mem_data[15 : 8] = '1;
          //if (Dqm_pipe2[2] == 1'b1) mem_data[23 :16] = '1;
          //if (Dqm_pipe2[3] == 1'b1) mem_data[31 :24] = '1;

          //`ifdef x4
          //   if (Dqm_pipe2 [0] == 1'b1) begin
          //       Dq_dqm [ 3 : 0] = 4'bz;
          //   end
          //`elsif x8
          //   if (Dqm_pipe2 [0] == 1'b1) begin
          //       Dq_dqm [ 7 : 0] = 8'bz;
          //   end
          //`elsif x16
          //   if (Dqm_pipe2 [0] == 1'b1) begin
          //       Dq_dqm [ 7 : 0] = 8'bz;
          //   end
          //   if (Dqm_pipe2 [1] == 1'b1) begin
          //       Dq_dqm [15 : 8] = 8'bz;
          //   end
          //`endif


          // 3) Apply tAC delay and report the completion of read access
          //[JI] Dq_reg = #tAC Dq_dqm;
          #tAC;
          Data_out_enable2 = ~Dqm_pipe2; // we apply masking here, like actual HW does it
          Dq_out_data      = mem_data;

         `ifdef SDRAM_DEBUG
             $display("%t %m READ  [%08x]=>%08x (Dqm=%b)", $time,
                       {Bank, Row, Col, 2'd0}, Dq_out_data, Dqm_pipe2);
         `endif

          // 4) Advance burst counter subroutine
          Burst_decode;

      end // if (Data_out_enable == 1'b1)
    end


//==================================================
// Decode Burst counter
//==================================================
    task Burst_decode;
       begin
          // Advance Burst Counter
          Burst_counter = Burst_counter + 1;

          // Burst Type
          if (Mode_reg[3] == 1'b0) begin      // Sequential Burst
             Col_temp = Col + 1;
          end
          else if (Mode_reg[3] == 1'b1) begin // Interleaved Burst
             Col_temp[2] = Burst_counter[2] ^ Col_brst[2];
             Col_temp[1] = Burst_counter[1] ^ Col_brst[1];
             Col_temp[0] = Burst_counter[0] ^ Col_brst[0];
          end

          // Burst Length
          if (Burst_length_2) begin      // Burst Length = 2
             Col [0]     = Col_temp [0];
          end
          else if (Burst_length_4) begin // Burst Length = 4
             Col [1 : 0] = Col_temp [1 : 0];
          end
          else if (Burst_length_8) begin // Burst Length = 8
             Col [2 : 0] = Col_temp [2 : 0];
          end
          else begin                     // Burst Length = FULL
             Col         = Col_temp;
          end

          // Burst Read Single Write
          if (Write_burst_mode == 1'b1) begin
             Data_in_enable = 1'b0;
          end

          // Data Counter
          if (Burst_length_1 == 1'b1) begin
             if (Burst_counter >= 1) begin
                 Data_in_enable  = 1'b0;
                 Data_out_enable = 1'b0;
             end
          end
          else if (Burst_length_2 == 1'b1) begin
             if (Burst_counter >= 2) begin
                 Data_in_enable  = 1'b0;
                 Data_out_enable = 1'b0;
             end
          end
          else if (Burst_length_4 == 1'b1) begin
             if (Burst_counter >= 4) begin
                 Data_in_enable  = 1'b0;
                 Data_out_enable = 1'b0;
             end
          end
          else if (Burst_length_8 == 1'b1) begin
             if (Burst_counter >= 8) begin
                 Data_in_enable  = 1'b0;
                 Data_out_enable = 1'b0;
             end
          end
       end
    endtask


//==================================================
// Timing Parameters for -75 (133 MHz @ CL3)
//  Our device is faster
//==================================================
 `ifdef SDRAM_TIMINGCHK
    specify
       specparam
          tCK3 =  7_500, // Clock period
          tCH  =  2_500, // Clock High-Level Width
          tCL  =  2_500, // Clock Low-Level Width

          tCKS =  1_500, // CKE Setup Time
          tCKH =  0_800, // CKE Hold  Time

          tCMS =  1_500, // CS#, RAS#, CAS#, WE#, DQM# Setup Time
          tCMH =  0_800, // CS#, RAS#, CAS#, WE#, DQM# Hold  Time

          tAS  =  1_500, // Addr, Ba Setup Time
          tAH  =  0_800, // Addr, Ba Hold Time

          tDS  =  1_500, // Data-in Setup Time
          tDH  =  0_800; // Data-in Hold Time

       $period    (negedge Clk,           tCK3);
       $period    (posedge Clk,           tCK3);
       $width     (posedge Clk,           tCH);
       $width     (negedge Clk,           tCL);

       $setuphold (posedge Clk,    Cke,   tCKS, tCKH);

       $setuphold (posedge Clk,    Cs_n,  tCMS, tCMH);
       $setuphold (posedge Clk,    Ras_n, tCMS, tCMH);
       $setuphold (posedge Clk,    Cas_n, tCMS, tCMH);
       $setuphold (posedge Clk,    We_n,  tCMS, tCMH);
       $setuphold (posedge Clk,    Dqm,   tCMS, tCMH);

       $setuphold (posedge Clk,    Addr,  tAS,  tAH);
       $setuphold (posedge Clk,    Ba,    tAS,  tAH);

     //$setuphold (posedge Dq_chk, Dq,    tDS,  tDH); //[JI]
       $setuphold (posedge Dq_chk, Dq_in, tDS,  tDH); //[JI]
    endspecify
 `endif

endmodule: sdr

// verilator lint_on WIDTHTRUNC

//--------------------------------------------------------------------------
// End-of-File
//------------------------------------------------------------------------
