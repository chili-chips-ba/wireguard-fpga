module dpram
       #(
         parameter WIDTH = 8,
         parameter DEPTH = 10
       )
       ( input                   clock,
         input    [WIDTH-1:0]    data,
         input    [DEPTH-1:0]    wraddress,
         input    [DEPTH-1:0]    rdaddress,
         input                   wren,
         output   [WIDTH-1:0]    q
       );
       
reg [WIDTH-1:0] ram[2**DEPTH-1:0];   //declare ram
reg [DEPTH-1:0] raddr_reg ;

always @ (posedge clock)
  begin
    if (wren)                //write
      ram[wraddress] <= data;
      raddr_reg <= rdaddress ;
  end
  
assign q = ram[raddr_reg] ;

endmodule
