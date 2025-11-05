
module progmem (
    // Clock & reset
    input wire clk,
    input wire rstn,

    // PicoRV32 bus interface
    input  wire        valid,
    output wire        ready,
    input  wire [31:0] addr,
    output wire [31:0] rdata,
	// Rewrite firmware
    input  wire        wen,
	input  wire [31:0] waddr,
	input  wire [31:0] wdata
);

  // ============================================================================

  localparam MEM_SIZE_BITS = 13;  // In 32-bit words
  localparam MEM_SIZE = 1 << MEM_SIZE_BITS;
  localparam MEM_ADDR_MASK = 32'h0010_0000;

  // ============================================================================

  wire [MEM_SIZE_BITS-1:0] mem_addr;
  reg  [             31:0] mem_data;
  reg  [             31:0] mem      [0:MEM_SIZE];

  initial begin
    mem['h0000] <= 32'h00000093;
    mem['h0001] <= 32'h00000193;
    mem['h0002] <= 32'h00000213;
    mem['h0003] <= 32'h00000293;
    mem['h0004] <= 32'h00000313;
    mem['h0005] <= 32'h00000393;
    mem['h0006] <= 32'h00000413;
    mem['h0007] <= 32'h00000493;
    mem['h0008] <= 32'h00000513;
    mem['h0009] <= 32'h00000593;
    mem['h000A] <= 32'h00000613;
    mem['h000B] <= 32'h00000693;
    mem['h000C] <= 32'h00000713;
    mem['h000D] <= 32'h00000793;
    mem['h000E] <= 32'h00000813;
    mem['h000F] <= 32'h00000893;
    mem['h0010] <= 32'h00000913;
    mem['h0011] <= 32'h00000993;
    mem['h0012] <= 32'h00000A13;
    mem['h0013] <= 32'h00000A93;
    mem['h0014] <= 32'h00000B13;
    mem['h0015] <= 32'h00000B93;
    mem['h0016] <= 32'h00000C13;
    mem['h0017] <= 32'h00000C93;
    mem['h0018] <= 32'h00000D13;
    mem['h0019] <= 32'h00000D93;
    mem['h001A] <= 32'h00000E13;
    mem['h001B] <= 32'h00000E93;
    mem['h001C] <= 32'h00000F13;
    mem['h001D] <= 32'h00000F93;
    mem['h001E] <= 32'h00000513;
    mem['h001F] <= 32'h00000593;
    mem['h0020] <= 32'h00B52023;
    mem['h0021] <= 32'h00450513;
    mem['h0022] <= 32'hFE254CE3;
    mem['h0023] <= 32'h00000517;
    mem['h0024] <= 32'h45050513;
    mem['h0025] <= 32'h00000593;
    mem['h0026] <= 32'h00000613;
    mem['h0027] <= 32'h00C5DC63;
    mem['h0028] <= 32'h00052683;
    mem['h0029] <= 32'h00D5A023;
    mem['h002A] <= 32'h00450513;
    mem['h002B] <= 32'h00458593;
    mem['h002C] <= 32'hFEC5C8E3;
    mem['h002D] <= 32'h00000513;
    mem['h002E] <= 32'h00000593;
    mem['h002F] <= 32'h00B55863;
    mem['h0030] <= 32'h00052023;
    mem['h0031] <= 32'h00450513;
    mem['h0032] <= 32'hFEB54CE3;
    mem['h0033] <= 32'h008000EF;
    mem['h0034] <= 32'h0000006F;
    mem['h0035] <= 32'hFF010113;
    mem['h0036] <= 32'h00112623;
    mem['h0037] <= 32'h00812423;
    mem['h0038] <= 32'h01010413;
    mem['h0039] <= 32'h020007B7;
    mem['h003A] <= 32'h00478793;
    mem['h003B] <= 32'h2B600713;
    mem['h003C] <= 32'h00E7A023;
    mem['h003D] <= 32'h001007B7;
    mem['h003E] <= 32'h4BC78513;
    mem['h003F] <= 32'h138000EF;
    mem['h0040] <= 32'h3E800513;
    mem['h0041] <= 32'h098000EF;
    mem['h0042] <= 32'hFEDFF06F;
    mem['h0043] <= 32'hFE010113;
    mem['h0044] <= 32'h00812E23;
    mem['h0045] <= 32'h02010413;
    mem['h0046] <= 32'hC00027F3;
    mem['h0047] <= 32'hFEF42623;
    mem['h0048] <= 32'hFEC42783;
    mem['h0049] <= 32'h00078513;
    mem['h004A] <= 32'h01C12403;
    mem['h004B] <= 32'h02010113;
    mem['h004C] <= 32'h00008067;
    mem['h004D] <= 32'hFD010113;
    mem['h004E] <= 32'h02112623;
    mem['h004F] <= 32'h02812423;
    mem['h0050] <= 32'h03010413;
    mem['h0051] <= 32'hFCA42E23;
    mem['h0052] <= 32'hFC5FF0EF;
    mem['h0053] <= 32'hFEA42623;
    mem['h0054] <= 32'hFDC42703;
    mem['h0055] <= 32'h00070793;
    mem['h0056] <= 32'h00279793;
    mem['h0057] <= 32'h00E787B3;
    mem['h0058] <= 32'h00479793;
    mem['h0059] <= 32'hFEF42423;
    mem['h005A] <= 32'h0040006F;
    mem['h005B] <= 32'hFA1FF0EF;
    mem['h005C] <= 32'h00050713;
    mem['h005D] <= 32'hFEC42783;
    mem['h005E] <= 32'h40F707B3;
    mem['h005F] <= 32'hFE842703;
    mem['h0060] <= 32'hFEE7E6E3;
    mem['h0061] <= 32'h00000013;
    mem['h0062] <= 32'h00000013;
    mem['h0063] <= 32'h02C12083;
    mem['h0064] <= 32'h02812403;
    mem['h0065] <= 32'h03010113;
    mem['h0066] <= 32'h00008067;
    mem['h0067] <= 32'hFE010113;
    mem['h0068] <= 32'h00112E23;
    mem['h0069] <= 32'h00812C23;
    mem['h006A] <= 32'h02010413;
    mem['h006B] <= 32'hFEA42623;
    mem['h006C] <= 32'h00C0006F;
    mem['h006D] <= 32'h3E800513;
    mem['h006E] <= 32'hF7DFF0EF;
    mem['h006F] <= 32'hFEC42783;
    mem['h0070] <= 32'hFFF78713;
    mem['h0071] <= 32'hFEE42623;
    mem['h0072] <= 32'hFE0796E3;
    mem['h0073] <= 32'h00000013;
    mem['h0074] <= 32'h00000013;
    mem['h0075] <= 32'h01C12083;
    mem['h0076] <= 32'h01812403;
    mem['h0077] <= 32'h02010113;
    mem['h0078] <= 32'h00008067;
    mem['h0079] <= 32'hFE010113;
    mem['h007A] <= 32'h00112E23;
    mem['h007B] <= 32'h00812C23;
    mem['h007C] <= 32'h02010413;
    mem['h007D] <= 32'h00050793;
    mem['h007E] <= 32'hFEF407A3;
    mem['h007F] <= 32'hFEF44703;
    mem['h0080] <= 32'h00A00793;
    mem['h0081] <= 32'h00F71663;
    mem['h0082] <= 32'h00D00513;
    mem['h0083] <= 32'hFD9FF0EF;
    mem['h0084] <= 32'h020007B7;
    mem['h0085] <= 32'h00878793;
    mem['h0086] <= 32'hFEF44703;
    mem['h0087] <= 32'h00E7A023;
    mem['h0088] <= 32'h00000013;
    mem['h0089] <= 32'h01C12083;
    mem['h008A] <= 32'h01812403;
    mem['h008B] <= 32'h02010113;
    mem['h008C] <= 32'h00008067;
    mem['h008D] <= 32'hFE010113;
    mem['h008E] <= 32'h00112E23;
    mem['h008F] <= 32'h00812C23;
    mem['h0090] <= 32'h02010413;
    mem['h0091] <= 32'hFEA42623;
    mem['h0092] <= 32'h01C0006F;
    mem['h0093] <= 32'hFEC42783;
    mem['h0094] <= 32'h00178713;
    mem['h0095] <= 32'hFEE42623;
    mem['h0096] <= 32'h0007C783;
    mem['h0097] <= 32'h00078513;
    mem['h0098] <= 32'hF85FF0EF;
    mem['h0099] <= 32'hFEC42783;
    mem['h009A] <= 32'h0007C783;
    mem['h009B] <= 32'hFE0790E3;
    mem['h009C] <= 32'h00000013;
    mem['h009D] <= 32'h00000013;
    mem['h009E] <= 32'h01C12083;
    mem['h009F] <= 32'h01812403;
    mem['h00A0] <= 32'h02010113;
    mem['h00A1] <= 32'h00008067;
    mem['h00A2] <= 32'hFD010113;
    mem['h00A3] <= 32'h02812623;
    mem['h00A4] <= 32'h03010413;
    mem['h00A5] <= 32'hFCA42E23;
    mem['h00A6] <= 32'hFCB42C23;
    mem['h00A7] <= 32'hFD842783;
    mem['h00A8] <= 32'hFFF78793;
    mem['h00A9] <= 32'h00279793;
    mem['h00AA] <= 32'hFEF42623;
    mem['h00AB] <= 32'h03C0006F;
    mem['h00AC] <= 32'hFEC42783;
    mem['h00AD] <= 32'hFDC42703;
    mem['h00AE] <= 32'h00F757B3;
    mem['h00AF] <= 32'h00F7F793;
    mem['h00B0] <= 32'h00100737;
    mem['h00B1] <= 32'h4C870713;
    mem['h00B2] <= 32'h00F707B3;
    mem['h00B3] <= 32'h0007C703;
    mem['h00B4] <= 32'h020007B7;
    mem['h00B5] <= 32'h00878793;
    mem['h00B6] <= 32'h00E7A023;
    mem['h00B7] <= 32'hFEC42783;
    mem['h00B8] <= 32'hFFC78793;
    mem['h00B9] <= 32'hFEF42623;
    mem['h00BA] <= 32'hFEC42783;
    mem['h00BB] <= 32'hFC07D2E3;
    mem['h00BC] <= 32'h00000013;
    mem['h00BD] <= 32'h00000013;
    mem['h00BE] <= 32'h02C12403;
    mem['h00BF] <= 32'h03010113;
    mem['h00C0] <= 32'h00008067;
    mem['h00C1] <= 32'hFC010113;
    mem['h00C2] <= 32'h02812E23;
    mem['h00C3] <= 32'h04010413;
    mem['h00C4] <= 32'hFCA42623;
    mem['h00C5] <= 32'hFCB42423;
    mem['h00C6] <= 32'h001007B7;
    mem['h00C7] <= 32'h4C878793;
    mem['h00C8] <= 32'h0007A583;
    mem['h00C9] <= 32'h0047A603;
    mem['h00CA] <= 32'h0087A683;
    mem['h00CB] <= 32'h00C7A703;
    mem['h00CC] <= 32'hFCB42C23;
    mem['h00CD] <= 32'hFCC42E23;
    mem['h00CE] <= 32'hFED42023;
    mem['h00CF] <= 32'hFEE42223;
    mem['h00D0] <= 32'h0107C783;
    mem['h00D1] <= 32'hFEF40423;
    mem['h00D2] <= 32'hFE042623;
    mem['h00D3] <= 32'h0680006F;
    mem['h00D4] <= 32'hFEC42783;
    mem['h00D5] <= 32'hFCC42703;
    mem['h00D6] <= 32'h00F707B3;
    mem['h00D7] <= 32'h0007C783;
    mem['h00D8] <= 32'hFEF405A3;
    mem['h00D9] <= 32'hFEB44783;
    mem['h00DA] <= 32'h0047D793;
    mem['h00DB] <= 32'h0FF7F793;
    mem['h00DC] <= 32'hFF078793;
    mem['h00DD] <= 32'h008787B3;
    mem['h00DE] <= 32'hFE87C703;
    mem['h00DF] <= 32'h020007B7;
    mem['h00E0] <= 32'h00878793;
    mem['h00E1] <= 32'h00E7A023;
    mem['h00E2] <= 32'hFEB44783;
    mem['h00E3] <= 32'h00F7F793;
    mem['h00E4] <= 32'hFF078793;
    mem['h00E5] <= 32'h008787B3;
    mem['h00E6] <= 32'hFE87C703;
    mem['h00E7] <= 32'h020007B7;
    mem['h00E8] <= 32'h00878793;
    mem['h00E9] <= 32'h00E7A023;
    mem['h00EA] <= 32'hFEC42783;
    mem['h00EB] <= 32'h00178793;
    mem['h00EC] <= 32'hFEF42623;
    mem['h00ED] <= 32'hFEC42703;
    mem['h00EE] <= 32'hFC842783;
    mem['h00EF] <= 32'hF8F74AE3;
    mem['h00F0] <= 32'h020007B7;
    mem['h00F1] <= 32'h00878793;
    mem['h00F2] <= 32'h00D00713;
    mem['h00F3] <= 32'h00E7A023;
    mem['h00F4] <= 32'h020007B7;
    mem['h00F5] <= 32'h00878793;
    mem['h00F6] <= 32'h00A00713;
    mem['h00F7] <= 32'h00E7A023;
    mem['h00F8] <= 32'h00000013;
    mem['h00F9] <= 32'h03C12403;
    mem['h00FA] <= 32'h04010113;
    mem['h00FB] <= 32'h00008067;
    mem['h00FC] <= 32'hFD010113;
    mem['h00FD] <= 32'h02112623;
    mem['h00FE] <= 32'h02812423;
    mem['h00FF] <= 32'h03010413;
    mem['h0100] <= 32'hFCA42E23;
    mem['h0101] <= 32'h00A00793;
    mem['h0102] <= 32'hFEF42623;
    mem['h0103] <= 32'hFEC42783;
    mem['h0104] <= 32'hFF078793;
    mem['h0105] <= 32'h008787B3;
    mem['h0106] <= 32'hFE078823;
    mem['h0107] <= 32'hFDC42783;
    mem['h0108] <= 32'h06079663;
    mem['h0109] <= 32'hFEC42783;
    mem['h010A] <= 32'hFFF78793;
    mem['h010B] <= 32'hFEF42623;
    mem['h010C] <= 32'hFEC42783;
    mem['h010D] <= 32'hFF078793;
    mem['h010E] <= 32'h008787B3;
    mem['h010F] <= 32'h03000713;
    mem['h0110] <= 32'hFEE78823;
    mem['h0111] <= 32'h0500006F;
    mem['h0112] <= 32'hFDC42703;
    mem['h0113] <= 32'h00A00793;
    mem['h0114] <= 32'h02F777B3;
    mem['h0115] <= 32'h0FF7F793;
    mem['h0116] <= 32'hFEC42703;
    mem['h0117] <= 32'hFFF70713;
    mem['h0118] <= 32'hFEE42623;
    mem['h0119] <= 32'h03078793;
    mem['h011A] <= 32'h0FF7F713;
    mem['h011B] <= 32'hFEC42783;
    mem['h011C] <= 32'hFF078793;
    mem['h011D] <= 32'h008787B3;
    mem['h011E] <= 32'hFEE78823;
    mem['h011F] <= 32'hFDC42703;
    mem['h0120] <= 32'h00A00793;
    mem['h0121] <= 32'h02F757B3;
    mem['h0122] <= 32'hFCF42E23;
    mem['h0123] <= 32'hFDC42783;
    mem['h0124] <= 32'hFA079CE3;
    mem['h0125] <= 32'hFE040713;
    mem['h0126] <= 32'hFEC42783;
    mem['h0127] <= 32'h00F707B3;
    mem['h0128] <= 32'h00078513;
    mem['h0129] <= 32'hD91FF0EF;
    mem['h012A] <= 32'h00000013;
    mem['h012B] <= 32'h02C12083;
    mem['h012C] <= 32'h02812403;
    mem['h012D] <= 32'h03010113;
    mem['h012E] <= 32'h00008067;
    mem['h012F] <= 32'h70207331;
    mem['h0130] <= 32'h65737361;
    mem['h0131] <= 32'h000A2E64;
    mem['h0132] <= 32'h33323130;
    mem['h0133] <= 32'h37363534;
    mem['h0134] <= 32'h42413938;
    mem['h0135] <= 32'h46454443;
    mem['h0136] <= 32'h00000000;

  end

  always @(posedge clk) mem_data <= mem[mem_addr];

  // ============================================================================

  reg o_ready;

  always @(posedge clk or negedge rstn)
    if (!rstn) o_ready <= 1'd0;
    else o_ready <= valid && ((addr & MEM_ADDR_MASK) != 0);

  // Output connectins
  assign ready    = o_ready;
  assign rdata    = mem_data;
  assign mem_addr = addr[MEM_SIZE_BITS+1:2];

  always @(posedge clk) begin
    if (wen) mem[waddr] <= wdata;
  end

endmodule
