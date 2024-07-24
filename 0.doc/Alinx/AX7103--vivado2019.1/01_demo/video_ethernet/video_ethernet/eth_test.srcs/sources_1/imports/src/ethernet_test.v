`timescale 1ns / 1ps  
//////////////////////////////////////////////////////////////////////////////////
// Module Name:    ethernet_test 
//////////////////////////////////////////////////////////////////////////////////
module ethernet_test#(
    parameter IDELAY_VALUE = 0
)(
    input       sys_clk,
    input       key_in,
    input       rst_n,
    output      e_reset,
	output      e_mdc,
	inout       e_mdio,
	output[3:0] rgmii_txd,
	output      rgmii_txctl,
	output      rgmii_txc,
	input[3:0]  rgmii_rxd,
	input       rgmii_rxctl,
	input       rgmii_rxc,
	input       cmos_pclk,
    input        cmos_vsync,
    input        cmos_href,
    input       cmos_href_delay,
    input [7:0] cmos_data_delay
    );

wire            reset_n;
(* MARK_DEBUG="true" *)wire   [ 7:0]   gmii_txd;
(* MARK_DEBUG="true" *)wire            gmii_tx_en;
wire            gmii_tx_er;
wire            gmii_tx_clk;
wire            gmii_crs;
wire            gmii_col;
(* MARK_DEBUG="true" *)wire   [ 7:0]   gmii_rxd;
(* MARK_DEBUG="true" *)wire            gmii_rx_dv;
wire            gmii_rx_er;
wire            e_reset_n;
wire            gmii_rx_clk;
wire  [ 1:0]    speed_selection; // 1x gigabit, 01 100Mbps, 00 10mbps
wire            duplex_mode;     // 1 full, 0 half
wire            rgmii_rxcpll;
assign speed_selection = 2'b10;
assign duplex_mode = 1'b1;

 //MDIO config
smi_config  smi_config_inst
(
.clk         (sys_clk),
.rst_n       (e_reset    ),         
.mdc         (e_mdc      ),
.mdio        (e_mdio     )
);   
util_gmii_to_rgmii #(
   .IDELAY_VALUE(IDELAY_VALUE)
)util_gmii_to_rgmii_m0(
	.reset(1'b0),
	
	.rgmii_td(rgmii_txd),
	.rgmii_tx_ctl(rgmii_txctl),
	.rgmii_txc(rgmii_txc),
	.rgmii_rd(rgmii_rxd),
	.rgmii_rx_ctl(rgmii_rxctl),
	.gmii_rx_clk(gmii_rx_clk),
	.gmii_txd(gmii_txd),
	.gmii_tx_en(gmii_tx_en),
	.gmii_tx_er(1'b0),
	.gmii_tx_clk(gmii_tx_clk),
	.gmii_crs(gmii_crs),
	.gmii_col(gmii_col),
	.gmii_rxd(gmii_rxd),
    .rgmii_rxc(rgmii_rxc),//add
	.gmii_rx_dv(gmii_rx_dv),
	.gmii_rx_er(gmii_rx_er),
	.speed_selection(speed_selection),
	.duplex_mode(duplex_mode)
	);
	
wire [10 : 0] fifo_data_count;
wire [7:0] fifo_data;
wire fifo_rd_en;

camera_fifo camera_fifo_inst (
.rst                      (cmos_vsync     ),   // input rst
.wr_clk                   (cmos_pclk      ),                   // input wr_clk
.din                      (cmos_data_delay),                   // input [7 : 0] din
.wr_en                    (cmos_href_delay),                    // input wr_en

.rd_clk                   (gmii_rx_clk     ),                         // input rd_clk
.rd_en                    (fifo_rd_en      ),                    // input rd_en
.dout                     (fifo_data       ),                     // output [7 : 0] dout
.full                     (                ),                     // output full
.empty                    (                ),                    // output empty
.rd_data_count            (fifo_data_count)                // output [10 : 0] rd_data_count
);
//ethernet tranfer
mac_test mac_test0
(
.gmii_tx_clk            (gmii_tx_clk        ),
.gmii_rx_clk            (gmii_rx_clk        ) ,
.rst_n                  (rst_n              ),

.cmos_vsync              (cmos_vsync        ),
.cmos_href               (cmos_href         ),
.reg_conf_done           (1'b1              ),
.fifo_data               (fifo_data         ),           //FIFO读出�?8bit数据/
.fifo_data_count         (fifo_data_count   ),     //(fifo_rdusedw),     //FIFO中的数据数量
.fifo_rd_en              (fifo_rd_en        ),          //FIFO读使�? 


.udp_send_data_length   (16'd1024), 
.gmii_rx_dv             (gmii_rx_dv         ),
.gmii_rxd               (gmii_rxd           ),
.gmii_tx_en             (gmii_tx_en         ),
.gmii_txd               (gmii_txd           )
 );
 //reset ethernet
reset reset_m0
(
	.clk(sys_clk),
	.key1(rst_n),
	.rst_n(e_reset)
);
reset reset_m1
(
	.clk(sys_clk),
	.key1(e_reset),
	.rst_n(e_reset_n)
);
endmodule
