//      Author:lhj                                                              //
//                                                                              //
//          ALINX(shanghai) Technology Co.,Ltd                                  //
//          heijin                                                              //
//     WEB: http://www.alinx.com/                                               //
//     BBS: http://www.heijin.org/                                              //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////
//                                                                              //
// Copyright (c) 2017,ALINX(shanghai) Technology Co.,Ltd                        //
//                    All rights reserved                                       //
//                                                                              //
// This source file may be used and distributed without restriction provided    //
// that this copyright statement is not removed from the file and that any      //
// derivative work contains the original copyright notice and the associated    //
// disclaimer.                                                                  //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////

//================================================================================
//  Revision History:
//  Date          By            Revision    Change Description
//--------------------------------------------------------------------------------
//2019/08/26                   1.0          Original
//*******************************************************************************/
module top
(
// Inouts
inout [31:0]                       ddr3_dq,                     //ddr3 data
inout [3:0]                        ddr3_dqs_n,                  //ddr3 dqs negative
inout [3:0]                        ddr3_dqs_p,                  //ddr3 dqs positive
// Outputs
output [14:0]                     ddr3_addr,                    //ddr3 address
output [2:0]                      ddr3_ba,                      //ddr3 bank
output                            ddr3_ras_n,                   //ddr3 ras_n
output                            ddr3_cas_n,                   //ddr3 cas_n
output                            ddr3_we_n,                    //ddr3 write enable 
output                            ddr3_reset_n,                 //ddr3 reset,
output [0:0]                      ddr3_ck_p,                    //ddr3 clock negative
output [0:0]                      ddr3_ck_n,                    //ddr3 clock positive
output [0:0]                      ddr3_cke,                     //ddr3_cke,
output [0:0]                      ddr3_cs_n,                    //ddr3 chip select,
output [3:0]                      ddr3_dm,                      //ddr3_dm
output [0:0]                      ddr3_odt,                     //ddr3_odt
input                             sys_clk,                    //system clock positive on board

output                            error,                        //ddr3 test error high is active
input                             rst_n                         //reset ,low active
);
/*************************************************************************
ddr3 parameter definition
****************************************************************************/
localparam nCK_PER_CLK           = 4;
localparam DQ_WIDTH              = 32;
localparam ADDR_WIDTH            = 29;
localparam DATA_WIDTH            = 32;
localparam PAYLOAD_WIDTH         = 32;

localparam APP_DATA_WIDTH        = 2 * nCK_PER_CLK * PAYLOAD_WIDTH;
localparam APP_MASK_WIDTH        = APP_DATA_WIDTH / 8;
wire init_calib_complete;
// Wire declarations
wire                            sys_clk_200MHz;                 //MIG IP clock input
wire                            wr_burst_data_req;              // write burst data request
wire                            wr_burst_finish;                // write burst finish flag
wire                            rd_burst_finish;                //read burst finish flag
wire                            rd_burst_req;                   //read burst request
wire                            wr_burst_req;                   //write burst request
wire[9:0]                       rd_burst_len;                   //read burst length
wire[9:0]                       wr_burst_len;                   //write burst length
wire[28:0]                      rd_burst_addr;                  //read burst address
wire[28:0]                      wr_burst_addr;                  //write burst address
wire                            rd_burst_data_valid;            //read burst data valid
wire[48* 8 - 1 : 0]             rd_burst_data;                  //read burst data
wire[48* 8 - 1 : 0]             wr_burst_data;                  //write burst data
/*************************************************************************
// xilinx MIG IP application interface ports
****************************************************************************/
wire [ADDR_WIDTH-1:0]           app_addr;
wire [2:0]                      app_cmd;
wire                            app_en;
wire                            app_rdy;
wire [APP_DATA_WIDTH-1:0]       app_rd_data;
wire                            app_rd_data_end;
wire                            app_rd_data_valid;
wire [APP_DATA_WIDTH-1:0]       app_wdf_data;
wire                            app_wdf_end;
wire [APP_MASK_WIDTH-1:0]       app_wdf_mask;
wire                            app_wdf_rdy;
wire                            app_sr_active;
wire                            app_ref_ack;
wire                            app_zq_ack;
wire                            app_wdf_wren;

wire                            clk;
wire                            rst;


/*************************************************************************
call MIG IP
****************************************************************************/
ddr3 u_ddr3
(
// Memory interface ports
.ddr3_addr                      (ddr3_addr              ),
.ddr3_ba                        (ddr3_ba                ),
.ddr3_cas_n                     (ddr3_cas_n             ),
.ddr3_ck_n                      (ddr3_ck_n              ),
.ddr3_ck_p                      (ddr3_ck_p              ),
.ddr3_cke                       (ddr3_cke               ),
.ddr3_ras_n                     (ddr3_ras_n             ),
.ddr3_we_n                      (ddr3_we_n              ),
.ddr3_dq                        (ddr3_dq                ),
.ddr3_dqs_n                     (ddr3_dqs_n             ),
.ddr3_dqs_p                     (ddr3_dqs_p             ),
.ddr3_reset_n                   (ddr3_reset_n           ),
.init_calib_complete            (init_calib_complete    ),
.ddr3_cs_n                      (ddr3_cs_n              ),
.ddr3_dm                        (ddr3_dm                ),
.ddr3_odt                       (ddr3_odt               ),
// Application interface ports
.app_addr                       (app_addr               ),
.app_cmd                        (app_cmd                ),
.app_en                         (app_en                 ),
.app_wdf_data                   (app_wdf_data           ),
.app_wdf_end                    (app_wdf_end            ),
.app_wdf_wren                   (app_wdf_wren           ),
.app_rd_data                    (app_rd_data            ),
.app_rd_data_end                (app_rd_data_end        ),
.app_rd_data_valid              (app_rd_data_valid      ),
.app_rdy                        (app_rdy                ),
.app_wdf_rdy                    (app_wdf_rdy            ),
.app_sr_req                     (1'b0                   ),
.app_ref_req                    (1'b0                   ),
.app_zq_req                     (1'b0                   ),
.app_sr_active                  (app_sr_active          ),
.app_ref_ack                    (app_ref_ack            ),
.app_zq_ack                     (app_zq_ack             ),
.ui_clk                         (clk                    ),
.ui_clk_sync_rst                (rst                    ),

.app_wdf_mask                   (app_wdf_mask           ),

.sys_clk_i                      (sys_clk         ),      // System Clock Ports    
.sys_rst                        (rst_n                  )
);
/*************************************************************************
Burst mode read and write MIG IP module
****************************************************************************/
mem_burst
#(
.MEM_DATA_BITS                  (APP_DATA_WIDTH         ),
.ADDR_BITS                      (ADDR_WIDTH             )
)
mem_burst_m0
(
.rst                            (rst                    ),                                  
.mem_clk                        (clk                    ),                              
.rd_burst_req                   (rd_burst_req           ),                
.wr_burst_req                   (wr_burst_req           ),                
.rd_burst_len                   (rd_burst_len           ),                
.wr_burst_len                   (wr_burst_len           ),                 
.rd_burst_addr                  (rd_burst_addr          ),               
.wr_burst_addr                  (wr_burst_addr          ),               
.rd_burst_data_valid            (rd_burst_data_valid    ),   
.wr_burst_data_req              (wr_burst_data_req      ),       
.rd_burst_data                  (rd_burst_data          ),               
.wr_burst_data                  (wr_burst_data          ),               
.rd_burst_finish                (rd_burst_finish        ),           
.wr_burst_finish                (wr_burst_finish        ),           
.burst_finish                   (                       ),                             

.app_addr                       (app_addr               ),
.app_cmd                        (app_cmd                ),
.app_en                         (app_en                 ),
.app_wdf_data                   (app_wdf_data           ),
.app_wdf_end                    (app_wdf_end            ),
.app_wdf_mask                   (app_wdf_mask           ),
.app_wdf_wren                   (app_wdf_wren           ),
.app_rd_data                    (app_rd_data            ),
.app_rd_data_end                (app_rd_data_end        ),
.app_rd_data_valid              (app_rd_data_valid      ),
.app_rdy                        (app_rdy                ),
.app_wdf_rdy                    (app_wdf_rdy            ),
.ui_clk_sync_rst                (                       ),  
.init_calib_complete            (init_calib_complete    )
);
/*************************************************************************
Call memory test module
****************************************************************************/
mem_test
#(
.MEM_DATA_BITS                  (APP_DATA_WIDTH         ),
.ADDR_BITS                      (ADDR_WIDTH             )
)
mem_test_m0
(
.rst                            (rst                    ),                                 
.mem_clk                        (clk                    ),                               
.rd_burst_req                   (rd_burst_req           ),                         
.wr_burst_req                   (wr_burst_req           ),                         
.rd_burst_len                   (rd_burst_len           ),                     
.wr_burst_len                   (wr_burst_len           ),                    
.rd_burst_addr                  (rd_burst_addr          ),        
.wr_burst_addr                  (wr_burst_addr          ),        
.rd_burst_data_valid            (rd_burst_data_valid    ),                 
.wr_burst_data_req              (wr_burst_data_req      ),                   
.rd_burst_data                  (rd_burst_data          ),   
.wr_burst_data                  (wr_burst_data          ),    
.rd_burst_finish                (rd_burst_finish        ),                     
.wr_burst_finish                (wr_burst_finish        ),                      

.error                          (error                  )
);
/*************************************************************************
Probe define
****************************************************************************/
wire                            probe0;
wire                            probe1;
wire                            probe2;
wire                            probe3;
wire                            probe4;
wire                            probe5;
wire                            probe6;
wire                            probe7;
wire [255 : 0]                  probe8;
wire [255 : 0]                  probe9;
wire [28 : 0]                   probe10;
/*************************************************************************
Analyze data from user defined ports for the xilinx ila module
****************************************************************************/
ila_0 u_ila_0
(
.clk                            (clk                    ),
.probe0                         (probe0                 ),
.probe1                         (probe1                 ),
.probe2                         (probe2                 ),
.probe3                         (probe3                 ),
.probe4                         (probe4                 ),
.probe5                         (probe5                 ),
.probe6                         (probe6                 ),
.probe7                         (probe7                 ),
.probe8                         (probe8                 ),
.probe9                         (probe9                 ),
.probe10                        (probe10                )						
);
assign probe0 = rd_burst_req;
assign probe1 = wr_burst_req;
assign probe2 = rd_burst_data_valid;
assign probe3 = wr_burst_data_req;
assign probe4 = rd_burst_finish;
assign probe5 = wr_burst_finish;
assign probe6 = error;
assign probe7 = init_calib_complete;
assign probe8 = wr_burst_data[255:0];
assign probe9 = rd_burst_data[255:0];
assign probe10 = app_addr[28:0];
endmodule
