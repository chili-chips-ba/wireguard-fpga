`timescale 1ns / 1ps  
//////////////////////////////////////////////////////////////////////////////////
// Module Name:    ethernet_test 
//////////////////////////////////////////////////////////////////////////////////
module ethernet_test#(
    parameter IDELAY_VALUE = 0
) (
    input        sys_clk_50m,
    input       sys_clk,
    input       key_in,
    input       rst_n,
    output[3:0] led,
    output      e_reset,
	output      e_mdc,
	inout       e_mdio,
	output[3:0] rgmii_txd,
	output      rgmii_txctl,
	output      rgmii_txc,
	input[3:0]  rgmii_rxd,
	input       rgmii_rxctl,
	input       rgmii_rxc
    );

wire            reset_n;
wire            mdio_rstn;
(* MARK_DEBUG="true" *)wire   [ 7:0]   gmii_txd;
(* MARK_DEBUG="true" *)wire            gmii_tx_en;
wire            gmii_tx_er;
wire            gmii_tx_clk;
wire            gmii_crs;
wire            gmii_col;
(* MARK_DEBUG="true" *)wire   [ 7:0]   gmii_rxd;
(* MARK_DEBUG="true" *)wire            gmii_rx_dv;
wire            gmii_rx_er;
wire            gmii_rx_clk;
wire  [ 1:0]    speed_selection; // 1x gigabit, 01 100Mbps, 00 10mbps
wire            duplex_mode;     // 1 full, 0 half
wire            rgmii_rxcpll;

wire  [31:0]    pack_total_len ;

wire [1:0]      speed      ;
wire            link       ;
wire            e_rx_dv    ;
wire [7:0]      e_rxd      ;
wire            e_tx_en    ;
wire [7:0]      e_txd      ;
wire            e_rst_n    ; 
assign speed_selection = 2'b10;
assign duplex_mode = 1'b1;
 //MDIO config

smi_config  smi_config_inst
(
.clk         (sys_clk_50m),
.rst_n       (mdio_rstn    ),         
.mdc         (e_mdc      ),
.mdio        (e_mdio     ),
.speed       (speed      ),
.link        (link       )
);   

util_gmii_to_rgmii #(
    .IDELAY_VALUE(IDELAY_VALUE)
) util_gmii_to_rgmii_m0(
.reset(1'b0),

.rgmii_td(rgmii_txd),
.rgmii_tx_ctl(rgmii_txctl),
.rgmii_txc(rgmii_txc),
.rgmii_rd(rgmii_rxd),
.rgmii_rx_ctl(rgmii_rxctl),
.gmii_rx_clk(gmii_rx_clk),
.gmii_txd(e_txd),
.gmii_tx_en(e_tx_en),
.gmii_tx_er(1'b0),
.gmii_tx_clk(gmii_tx_clk),
.gmii_crs(gmii_crs),
.gmii_col(gmii_col),
.gmii_rxd(gmii_rxd),
.rgmii_rxc(rgmii_rxc),//add
.gmii_rx_dv(gmii_rx_dv),
.gmii_rx_er(gmii_rx_er),
.speed_selection(speed),
.duplex_mode(duplex_mode)
);
gmii_arbi arbi_inst
(
.clk                (gmii_tx_clk      ),
.rst_n              (rst_n            ),
.speed              (speed            ),  
.link               (link             ), 
.pack_total_len     (pack_total_len   ), 
.e_rst_n            (e_rst_n          ),
.gmii_rx_dv         (gmii_rx_dv       ),
.gmii_rxd           (gmii_rxd         ),
.gmii_tx_en         (gmii_tx_en       ),
.gmii_txd           (gmii_txd         ), 
.e_rx_dv            (e_rx_dv          ),
.e_rxd              (e_rxd            ),
.e_tx_en            (e_tx_en          ),
.e_txd              (e_txd            ) 
);
mac_test mac_test0
(
.gmii_tx_clk            (gmii_tx_clk     ),
.gmii_rx_clk            (gmii_rx_clk     ) ,
.rst_n                  (e_rst_n         ),
.push_button            (key_in          ),
.pack_total_len         (pack_total_len  ),
.gmii_rx_dv             (e_rx_dv         ),
.gmii_rxd               (e_rxd           ),
.gmii_tx_en             (gmii_tx_en      ),
.gmii_txd               (gmii_txd        )
 
); 
reset reset_m0
(
.clk(sys_clk),
.key1(rst_n),
.rst_n(e_reset)
);

reset reset_mdio_inst
(
.clk(sys_clk),
.key1(e_reset),
.rst_n(mdio_rstn)
);
endmodule
