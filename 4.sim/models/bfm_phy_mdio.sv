//==========================================================================
// Copyright (C) 2025 Chili.CHIPS*ba
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
//  MDIO BFM test component
//==========================================================================

module bfm_phy_mdio
#(parameter             MDIO_BUFF_ADDR = 32'h50000000,
                        NODE           = 0)
(
  input                 clk,
  input                 arst_n,

`ifdef VERILATOR
   output               mdio_en,
   output               mdio_out,
`endif

  inout                 mdio
);

localparam MDIO_CMD_WR = 2'b01;
localparam MDIO_CMD_RD = 2'b10;

reg  [33:0]               shiftin;
reg  [16:0]               shiftout;
reg                       en;
reg                       memrd;
reg                       memwr;
reg  [31:0]               memaddr;
reg  [31:0]               memwdata;
int                       count;

wire [31:0]               memrdata;
wire                      memrdatavalid;

string regname [32] = {
                         "[Control]                                ",
                         "[Status]                                 ",
                         "[PHY ID(0)]                              ",
                         "[PHY ID(1)]                              ",
                         "[Auto-Neg Advert]                        ",
                         "[Auto-Neg Link Partner Base Page Ability]",
                         "[Auto-Neg Expansion]                     ",
                         "[Auto-Neg Next Page Transmit]            ",
                         "[Auto-Neg Link Partner Rcvd Next Page]   ",
                         "[MST-SLV Control]                        ",
                         "[MST-SLV Status]                         ",
                         "[PSE Control]                            ",
                         "[PSE Status]                             ",
                         "[MMD Access Control]                     ",
                         "[MMD Access Address Data]                ",
                         "[Extended Status]                        ",
                         "[Vendor(0)]                              ",
                         "[Vendor(1)]                              ",
                         "[Vendor(2)]                              ",
                         "[Vendor(3)]                              ",
                         "[Vendor(4)]                              ",
                         "[Vendor(5)]                              ",
                         "[Vendor(6)]                              ",
                         "[Vendor(7)]                              ",
                         "[Vendor(8)]                              ",
                         "[Vendor(9)]                              ",
                         "[Vendor(10)]                             ",
                         "[Vendor(11)]                             ",
                         "[Vendor(12)]                             ",
                         "[Vendor(13)]                             ",
                         "[Vendor(14)]                             ",
                         "[Vendor(15)]                             "
                      };

`ifdef VERILATOR
assign      mdio_out         = shiftout[16];
assign      mdio_en          = en;
`else
assign      mdio             = en ? shiftout[16] : 1'bz;
`endif

// Flag to start a transaction if 32 1s seen and the start sequence
wire        start            = &shiftin[33:2] & ~shiftin[1] & shiftin[0];

// Extract MDIO command and combined address at phase 19
wire  [1:0] cmd19            = shiftin[10:9];
wire  [9:0] addr19           = {shiftin[8:0], mdio};

// Extract MDIO command at last cycle
wire  [1:0] cmd1             = shiftin[28:27];

initial
begin
  $timeformat(-9, 2, " ns", 0);
  shiftin                    = 34'h0;
  count                      = 0;
  en                         = 1'b0;
  memrd                      = 1'b0;
  memwr                      = 1'b0;
end

//--------------------------------------------------------------------------
// Command, address and write process
//--------------------------------------------------------------------------
always @(posedge clk)
begin
  // Default values
  memrd                      <= 1'b0;

  // Continually shift in the MDIO bits
  shiftin                    <= {shiftin[32:0], mdio};

  // If start flagged set down counter, accounting for start bits already seen
  if (start)
  begin
    count                    <= 29; // remaining bits (next cycle)
  end
  else
  begin
    // Whilst counter non-zero, decrement
    if (count)
    begin
      count                  <= count - 1;
    end
  end

  // Phase 19 has last address bit on mdio
  if (count == 19)
  begin
    // On reads, set the mem_model memrd strobe and enable output on mdio
    if (cmd19 == MDIO_CMD_RD)
    begin
      memrd                  <= 1'b1;
      en                     <= 1'b1;
    end
    // Check that, if not a read command , then a valid write command
    else if (cmd19 != MDIO_CMD_WR)
    begin
      $display("bfm_phy_mdio: ***ERROR: Seen invalid command type...aborting @ %0t", $time);

      // Abort transaction
      count                  <= 0;
      shiftin                <= 34'h0;
    end

    // Generate a word address from supplied base address and port/register address,
    // aligning 16-bit address to a 32-bit word boundary
    memaddr                  <= {MDIO_BUFF_ADDR[31:14], 2'b00, addr19, 2'b00};
  end

  // At the end of a transaction, ensure not driving the MDIO bus
  if (count == 1)
  begin
    en                       <= 1'b0;
  end
end

//--------------------------------------------------------------------------
// Memory write access and read data process
//--------------------------------------------------------------------------

`ifdef VERILATOR
always @(negedge clk)
`else
always @(posedge clk)
`endif
begin
  // Default setting
  memwr                      <= 1'b0;

  // Constantly shift out
  shiftout                   <= {shiftout[15:0], 1'b0};

  // Last cycle
  if (count == 1)
  begin
    // If a write command pulse the mem_model write strobe and set data as a 32-bit word
    if (cmd1 == MDIO_CMD_WR)
    begin
      memwr                  <= 1'b1;
      memwdata               <= {16'h0, shiftin[14:0], mdio};
    end
  end

  // On a write to memory display formatted details to console
  if (memwr)
  begin
    $display("bfm_phy_mdio(%0d): Wrote DATA 0x%04x to   PORT 0x%h ADDR 0x%h %s @ %t",
              NODE, memwdata[15:0], memaddr[11:7], memaddr[6:2], regname[memaddr[6:2]], $time);
  end

  // When word read from memory, load to shiftout and display formatted details to console
  if (memrdatavalid)
  begin
    shiftout[15:0]           <= memrdata[15:0];
    $display("bfm_phy_mdio(%0d): Read  DATA 0x%04x from PORT 0x%h ADDR 0x%h %s @ %t",
              NODE, memrdata[15:0], memaddr[11:7], memaddr[6:2], regname[memaddr[6:2]], $time);
  end
end

// -----------------------------------------------------------
// Memory model instnatiation
// -----------------------------------------------------------

  mem_model mem (
     .clk               (clk),
     .rst_n             (arst_n),

     // Read/write port
     .address           (memaddr),
     .byteenable        (4'h3),                  // Only writing 16 bits to 32-bit word
     .write             (memwr),
     .writedata         (memwdata),
     .read              (memrd),
     .readdata          (memrdata),
     .readdatavalid     (memrdatavalid),

      // Unused write port
     .wr_port_valid     ('0),                     // (unused)
     .wr_port_data      ('0),                     // (unused)
     .wr_port_addr      ('0),                     // (unused)

      // Unused burst ports
     .rx_waitrequest    (),                       // (unused)
     .rx_burstcount     ('0),                     // (unused)
     .rx_address        ('0),                     // (unused)
     .rx_read           ('0),                     // (unused)
     .rx_readdata       (),                       // (unused)
     .rx_readdatavalid  (),                       // (unused)

     .tx_waitrequest    (),                       // (unused)
     .tx_burstcount     ('0),                     // (unused)
     .tx_address        ('0),                     // (unused)
     .tx_write          ('0),                     // (unused)
     .tx_writedata      ('0)                      // (unused)
  );


endmodule