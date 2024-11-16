module camera_delay
(
   input                cmos_pclk,              //cmos pxiel clock
   input                cmos_href,              //cmos hsync refrence
	input                cmos_vsync,             //cmos vsync
	input     [7:0]      cmos_data,              //cmos data

   output               cmos_href_delay,              //cmos hsync refrence
	output               cmos_vsync_delay,             //cmos vsync
	output     [7:0]     cmos_data_delay              //cmos data
) ;

reg [2:0] cmos_href_buf ;
reg [2:0] cmos_vsync_buf ;
reg [7:0] cmos_data_d0 ;
reg [7:0] cmos_data_d1 ;
reg [7:0] cmos_data_d2 ;


always @(posedge cmos_pclk)
begin 
  cmos_href_buf <= {cmos_href_buf[1:0], cmos_href} ;
end

always @(posedge cmos_pclk)
begin 
  cmos_vsync_buf <= {cmos_vsync_buf[1:0], cmos_vsync} ;
end

always @(posedge cmos_pclk)
begin 
  cmos_data_d0 <= cmos_data ;
  cmos_data_d1 <= cmos_data_d0 ;
  cmos_data_d2 <= cmos_data_d1 ;
end

assign cmos_href_delay = cmos_href_buf[2] ;
assign cmos_vsync_delay = cmos_vsync_buf[2] ;
assign cmos_data_delay = cmos_data_d2 ;



endmodule
