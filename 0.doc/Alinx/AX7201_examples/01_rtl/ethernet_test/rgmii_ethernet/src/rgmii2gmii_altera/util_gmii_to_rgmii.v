
module util_gmii_to_rgmii (
  reset,

  rgmii_td,
  rgmii_tx_ctl,
  rgmii_txc,
  rgmii_rd,
  rgmii_rx_ctl,
  rgmii_rxc,

  gmii_txd,
  gmii_tx_en,
  gmii_tx_er,
  gmii_tx_clk,
  gmii_crs,
  gmii_col,
  gmii_rxd,
  gmii_rx_dv,
  gmii_rx_er,
  gmii_rx_clk,
  speed_selection,
  duplex_mode);
  input           reset;

  output  [ 3:0]  rgmii_td;
  output          rgmii_tx_ctl;
  output          rgmii_txc;
  input   [ 3:0]  rgmii_rd;
  input           rgmii_rx_ctl;
  input           rgmii_rxc;

  input   [ 7:0]  gmii_txd;
  input           gmii_tx_en;
  input           gmii_tx_er;
  output          gmii_tx_clk;
  output          gmii_crs;
  output          gmii_col;
  output  [ 7:0]  gmii_rxd;
  output          gmii_rx_dv;
  output          gmii_rx_er;
  output          gmii_rx_clk;
  input  [ 1:0]   speed_selection; // 1x gigabit, 01 100Mbps, 00 10mbps
  input           duplex_mode;     // 1 full, 0 half
  
  // wires
  wire  [ 7:0]    gmii_rxd_s;
  wire            rgmii_rx_ctl_delay;
  wire            rgmii_rx_ctl_s;



  // registers
  reg             tx_reset_d1;
  reg             tx_reset_sync;
  reg             rx_reset_d1;
  reg   [ 7:0]    gmii_txd_r;
  reg             gmii_tx_en_r;
  reg             gmii_tx_er_r;
  reg   [ 7:0]    gmii_txd_r_d1;
  reg             gmii_tx_en_r_d1;
  reg             gmii_tx_er_r_d1;

  reg             rgmii_tx_ctl_r;
  reg   [ 3:0]    gmii_txd_low;
  reg             gmii_col;
  reg             gmii_crs;

  reg  [ 7:0]     gmii_rxd;
  reg             gmii_rx_dv;
  reg             gmii_rx_er;
wire gigabit;
wire gmii_tx_clk_s;
wire gmii_rx_dv_s;
  assign gigabit        = speed_selection [1];
  assign gmii_tx_clk    = gmii_tx_clk_s;
  assign gmii_tx_clk_s  = gmii_rx_clk;
  
  always @(posedge gmii_rx_clk)
  begin
    gmii_rxd       = gmii_rxd_s;
    gmii_rx_dv     = gmii_rx_dv_s;
    gmii_rx_er     = gmii_rx_dv_s ^ rgmii_rx_ctl_s;
  end

  always @(posedge gmii_tx_clk_s) begin
    tx_reset_d1    <= reset;
    tx_reset_sync  <= tx_reset_d1;
  end

  always @(posedge gmii_tx_clk_s)
  begin
    rgmii_tx_ctl_r = gmii_tx_en_r ^ gmii_tx_er_r;
    gmii_txd_low   = gigabit ? gmii_txd_r[7:4] :  gmii_txd_r[3:0];
    gmii_col       = duplex_mode ? 1'b0 : (gmii_tx_en_r| gmii_tx_er_r) & ( gmii_rx_dv | gmii_rx_er) ;
    gmii_crs       = duplex_mode ? 1'b0 : (gmii_tx_en_r| gmii_tx_er_r| gmii_rx_dv | gmii_rx_er);
  end

  always @(posedge gmii_tx_clk_s) begin
    if (tx_reset_sync == 1'b1) begin
      gmii_txd_r   <= 8'h0;
      gmii_tx_en_r <= 1'b0;
      gmii_tx_er_r <= 1'b0;
    end
    else
    begin
      gmii_txd_r   <= gmii_txd;
      gmii_tx_en_r <= gmii_tx_en;
      gmii_tx_er_r <= gmii_tx_er;
      gmii_txd_r_d1   <= gmii_txd_r;
      gmii_tx_en_r_d1 <= gmii_tx_en_r;
      gmii_tx_er_r_d1 <= gmii_tx_er_r;
    end
  end
/*
  ODDR #(
    .DDR_CLK_EDGE("SAME_EDGE")
  ) rgmii_txc_out (
    .Q (rgmii_txc),
    .C (gmii_tx_clk_s),
    .CE(1),
    .D1(1),
    .D2(0),
    .R(tx_reset_sync),
    .S(0));
*/
/*
ODDR2 #(
		.DDR_ALIGNMENT("NONE"), // Sets output alignment to "NONE", "C0" or "C1" 
		.INIT(1'b0),    // Sets initial state of the Q output to 1'b0 or 1'b1
		.SRTYPE("SYNC") // Specifies "SYNC" or "ASYNC" set/reset
		) U_ODDR2
	(
		  .Q(rgmii_txc),   // 1-bit DDR output data
		  .C0(gmii_tx_clk_s),   // 1-bit clock input
		  .C1(~gmii_tx_clk_s),   // 1-bit clock input
		  .CE(1'b1), // 1-bit clock enable input
		  .D0(1'b1), // 1-bit data input (associated with C0)
		  .D1(1'b0), // 1-bit data input (associated with C1)
		  .R(tx_reset_sync),   // 1-bit reset input
		  .S(1'b0)    // 1-bit set input
	);
*/	

	altddio_out	ALTDDIO_OUT_component (
				.datain_h (1'b1),
				.datain_l (1'b0),
				.outclock (gmii_tx_clk_s),
				.dataout (rgmii_txc),
				.aclr (1'b0),
				.aset (1'b0),
				.oe (1'b1),
				.oe_out (),
				.outclocken (1'b1),
				.sclr (1'b0),
				.sset (1'b0));
	defparam
		ALTDDIO_OUT_component.extend_oe_disable = "OFF",
		ALTDDIO_OUT_component.intended_device_family = "Cyclone III",
		ALTDDIO_OUT_component.invert_output = "OFF",
		ALTDDIO_OUT_component.lpm_hint = "UNUSED",
		ALTDDIO_OUT_component.lpm_type = "altddio_out",
		ALTDDIO_OUT_component.oe_reg = "UNREGISTERED",
		ALTDDIO_OUT_component.power_up_high = "OFF",
		ALTDDIO_OUT_component.width = 1;
	/*
  generate
  genvar i;
  for (i = 0; i < 4; i = i + 1) begin : gen_tx_data
    ODDR #(
      .DDR_CLK_EDGE("SAME_EDGE")
    ) rgmii_td_out (
      .Q (rgmii_td[i]),
      .C (gmii_tx_clk_s),
      .CE(1),
      .D1(gmii_txd_r_d1[i]),
      .D2(gmii_txd_low[i]),
      .R(tx_reset_sync),
      .S(0));
  end
  endgenerate

  ODDR #(
    .DDR_CLK_EDGE("SAME_EDGE")
  ) rgmii_tx_ctl_out (
    .Q (rgmii_tx_ctl),
    .C (gmii_tx_clk_s),
    .CE(1),
    .D1(gmii_tx_en_r_d1),
    .D2(rgmii_tx_ctl_r),
    .R(tx_reset_sync),
    .S(0));

  generate
  genvar i;
  for (i = 0; i < 4; i = i + 1) begin : gen_tx_data
	ODDR2 #(
		.DDR_ALIGNMENT("NONE"), // Sets output alignment to "NONE", "C0" or "C1" 
		.INIT(1'b0),    // Sets initial state of the Q output to 1'b0 or 1'b1
		.SRTYPE("SYNC") // Specifies "SYNC" or "ASYNC" set/reset
		) U2_ODDR2
	(
		  .Q(rgmii_td[i]),   // 1-bit DDR output data
		  .C0(gmii_tx_clk_s),   // 1-bit clock input
		  .C1(~gmii_tx_clk_s),   // 1-bit clock input
		  .CE(1'b1), // 1-bit clock enable input
		  .D0(gmii_txd_r_d1[i]), // 1-bit data input (associated with C0)
		  .D1(gmii_txd_low[i]), // 1-bit data input (associated with C1)
		  .R(tx_reset_sync),   // 1-bit reset input
		  .S(1'b0)    // 1-bit set input
	);
  end
  endgenerate

	ODDR2 #(
		.DDR_ALIGNMENT("NONE"), // Sets output alignment to "NONE", "C0" or "C1" 
		.INIT(1'b0),    // Sets initial state of the Q output to 1'b0 or 1'b1
		.SRTYPE("SYNC") // Specifies "SYNC" or "ASYNC" set/reset
		) U3_ODDR2
	(
		  .Q(rgmii_tx_ctl),   // 1-bit DDR output data
		  .C0(gmii_tx_clk_s),   // 1-bit clock input
		  .C1(~gmii_tx_clk_s),   // 1-bit clock input
		  .CE(1'b1), // 1-bit clock enable input
		  .D0(gmii_tx_en_r_d1), // 1-bit data input (associated with C0)
		  .D1(rgmii_tx_ctl_r), // 1-bit data input (associated with C1)
		  .R(tx_reset_sync),   // 1-bit reset input
		  .S(1'b0)    // 1-bit set input
	);
	
	*/
	/*
  generate
  genvar i;
  for (i = 0; i < 4; i = i + 1) begin : gen_tx_data
	altddio_out	ALTDDIO_OUT_component2 (
				.datain_h (gmii_txd_r_d1[i]),
				.datain_l (gmii_txd_low[i]),
				.outclock (gmii_tx_clk_s),
				.dataout (rgmii_td[i]),
				.aclr (1'b0),
				.aset (1'b0),
				.oe (1'b1),
				.oe_out (),
				.outclocken (1'b1),
				.sclr (1'b0),
				.sset (1'b0));
	defparam
		ALTDDIO_OUT_component2.extend_oe_disable = "OFF",
		ALTDDIO_OUT_component2.intended_device_family = "Cyclone III",
		ALTDDIO_OUT_component2.invert_output = "OFF",
		ALTDDIO_OUT_component2.lpm_hint = "UNUSED",
		ALTDDIO_OUT_component2.lpm_type = "altddio_out",
		ALTDDIO_OUT_component2.oe_reg = "UNREGISTERED",
		ALTDDIO_OUT_component2.power_up_high = "OFF",
		ALTDDIO_OUT_component2.width = 1;
  end
  endgenerate
*/	
		altddio_out	ALTDDIO_OUT_component3 (
				.datain_h (gmii_tx_en_r_d1),
				.datain_l (rgmii_tx_ctl_r),
				.outclock (gmii_tx_clk_s),
				.dataout (rgmii_tx_ctl),
				.aclr (1'b0),
				.aset (1'b0),
				.oe (1'b1),
				.oe_out (),
				.outclocken (1'b1),
				.sclr (1'b0),
				.sset (1'b0));
	defparam
		ALTDDIO_OUT_component3.extend_oe_disable = "OFF",
		ALTDDIO_OUT_component3.intended_device_family = "Cyclone III",
		ALTDDIO_OUT_component3.invert_output = "OFF",
		ALTDDIO_OUT_component3.lpm_hint = "UNUSED",
		ALTDDIO_OUT_component3.lpm_type = "altddio_out",
		ALTDDIO_OUT_component3.oe_reg = "UNREGISTERED",
		ALTDDIO_OUT_component3.power_up_high = "OFF",
		ALTDDIO_OUT_component3.width = 1;
		
ddio_out_4bit ddio_out_4bit_m0(
	.datain_h(gmii_txd_r_d1[3:0]),
	.datain_l(gmii_txd_low),
	.outclock(gmii_tx_clk_s),
	.dataout(rgmii_td));
	
assign gmii_rx_clk = rgmii_rxc;
/*	
  BUFG bufmr_rgmii_rxc(
    .I(rgmii_rxc),
    .O(gmii_rx_clk));

  generate
  for (i = 0; i < 4; i = i + 1) begin
    IDDR #(
      .DDR_CLK_EDGE("SAME_EDGE_PIPELINED")
    ) rgmii_rx_iddr (
      .Q1(gmii_rxd_s[i]),
      .Q2(gmii_rxd_s[i+4]),
      .C(gmii_rx_clk),
      .CE(1),
      .D(rgmii_rd[i]),
      .R(0),
      .S(0));
  end
  endgenerate

  IDDR #(
    .DDR_CLK_EDGE("SAME_EDGE_PIPELINED")
  ) rgmii_rx_ctl_iddr (
    .Q1(gmii_rx_dv_s),
    .Q2(rgmii_rx_ctl_s),
    .C(gmii_rx_clk),
    .CE(1),
    .D(rgmii_rx_ctl),
    .R(0),
    .S(0));
*/
ddio_in_4bit ddio_in_4bit_m0(
	.datain(rgmii_rd[3:0]),
	.inclock(gmii_rx_clk),
	.dataout_h(gmii_rxd_s[7:4]),
	.dataout_l(gmii_rxd_s[3:0]));
/*	
  generate
  for (i = 0; i < 4; i = i + 1) begin	
	IDDR2 #(
   .DDR_ALIGNMENT("NONE"), // Sets output alignment to "NONE", "C0" or "C1"
   .INIT_Q0(1'b0), // Sets initial state of the Q0 output to 1'b0 or 1'b1
   .INIT_Q1(1'b0), // Sets initial state of the Q1 output to 1'b0 or 1'b1
   .SRTYPE("SYNC") // Specifies "SYNC" or "ASYNC" set/reset
	) rgmii_rx_iddr (
   .Q0(gmii_rxd_s[i]), // 1-bit output captured with C0 clock
   .Q1(gmii_rxd_s[i+4]), // 1-bit output captured with C1 clock
   .C0(gmii_rx_clk), // 1-bit clock input
   .C1(~gmii_rx_clk), // 1-bit clock input
   .CE(1), // 1-bit clock enable input
   .D(rgmii_rd[i]),   // 1-bit DDR data input
   .R(0),   // 1-bit reset input
   .S(0)    // 1-bit set input
	);
  end
  endgenerate
 */ 
 ddio_in_1bit ddio_in_1bit_m0(
	.datain(rgmii_rx_ctl),
	.inclock(gmii_rx_clk),
	.dataout_h(rgmii_rx_ctl_s),
	.dataout_l(gmii_rx_dv_s));
	/*
	IDDR2 #(
   .DDR_ALIGNMENT("NONE"), // Sets output alignment to "NONE", "C0" or "C1"
   .INIT_Q0(1'b0), // Sets initial state of the Q0 output to 1'b0 or 1'b1
   .INIT_Q1(1'b0), // Sets initial state of the Q1 output to 1'b0 or 1'b1
   .SRTYPE("SYNC") // Specifies "SYNC" or "ASYNC" set/reset
	) rgmii_rx_iddr (
   .Q0(gmii_rx_dv_s), // 1-bit output captured with C0 clock
   .Q1(rgmii_rx_ctl_s), // 1-bit output captured with C1 clock
   .C0(gmii_rx_clk), // 1-bit clock input
   .C1(~gmii_rx_clk), // 1-bit clock input
   .CE(1), // 1-bit clock enable input
   .D(rgmii_rx_ctl),   // 1-bit DDR data input
   .R(0),   // 1-bit reset input
   .S(0)    // 1-bit set input
	);	
*/	
endmodule
