`timescale 1ns / 1ps
/****************************************/
//      GMII UDP数据包发送模块　　　　　　　//
/****************************************/

module ipsend(
				  input              clk,                   //GMII发送的时钟信号
				  output reg         txen,                  //GMII数据使能信号
				  output reg         txer,                  //GMII发送错误信号
				  output reg [7:0]   dataout,               //GMII发送数据
				  input      [31:0]  crc,                   //CRC32校验码
				  input      [31:0]  datain,                //RAM中的数据	 
				  output reg         crcen,                 //CRC32 校验使能
				  output reg         crcre,                 //CRC32 校验清除

				  output reg [3:0]   tx_state,              //发送状态机    
				  input      [15:0]  tx_data_length,        //发送的数据包的长度
				  input      [15:0]  tx_total_length,       //发送包的长度
				  output reg [8:0]   ram_rd_addr            //ram读地址
				  
	  );


reg [31:0]  datain_reg;

reg [31:0] ip_header [6:0];                  //数据段为1K

reg [7:0] preamble [7:0];                    //preamble
reg [7:0] mac_addr [13:0];                   //mac address
reg [4:0] i,j;

reg [31:0] check_buffer;
reg [31:0] check_buffer_0;
reg [31:0] check_buffer_1;
reg [31:0] time_counter;
reg [15:0] tx_data_counter;

parameter idle=4'b0000,start=4'b0001,make=4'b0010,send55=4'b0011,sendmac=4'b0100,sendheader=4'b0101,
          senddata=4'b0110,sendcrc=4'b0111;



initial
  begin
	 tx_state<=idle;
	 //定义IP 包头
	 preamble[0]<=8'h55;                 //7个前导码55,一个帧开始符d5
	 preamble[1]<=8'h55;
	 preamble[2]<=8'h55;
	 preamble[3]<=8'h55;
	 preamble[4]<=8'h55;
	 preamble[5]<=8'h55;
	 preamble[6]<=8'h55;
	 preamble[7]<=8'hD5;
	 mac_addr[0]<=8'hFF;                 //目的MAC地址 ff-ff-ff-ff-ff-ff, 全ff为广播包
	 mac_addr[1]<=8'hFF;
	 mac_addr[2]<=8'hFF;
	 mac_addr[3]<=8'hFF;
	 mac_addr[4]<=8'hFF;
	 mac_addr[5]<=8'hFF;
	 mac_addr[6]<=8'h00;                 //源MAC地址 00-0A-35-01-FE-C0
	 mac_addr[7]<=8'h0A;
	 mac_addr[8]<=8'h35;
	 mac_addr[9]<=8'h01;
	 mac_addr[10]<=8'hFE;
	 mac_addr[11]<=8'hC0;
	 mac_addr[12]<=8'h08;                //0800: IP包类型
	 mac_addr[13]<=8'h00;
	 i<=0;
 end


//UDP数据发送程序	 
always@(negedge clk)
begin		
		case(tx_state)
		  idle:begin
				 txer<=1'b0;
				 txen<=1'b0;
				 crcen<=1'b0;
				 crcre<=1;
				 j<=0;
				 dataout<=0;
				 ram_rd_addr<=1;
				 tx_data_counter <= 0;
             if (time_counter >= 32'd125_000_000) begin     //等待延迟, 每隔一段时间发送一个数据包
				     tx_state<=start;  
                 time_counter<=0;
             end
             else
                 time_counter<=time_counter+1'b1;				
			end
		   start:begin        //IP header
					ip_header[0]<={16'h4500,tx_total_length};        //版本号：4； 包头长度：20；IP包总长
				   ip_header[1][31:16]<= ip_header[1][31:16]+1'b1;   //包序列号
					ip_header[1][15:0]<=16'h4000;                    //Fragment offset
				   ip_header[2]<=32'h80110000;                      //mema[2][15:0] 协议：17(UDP)
				   ip_header[3]<=32'hc0a80002;                      //192.168.0.2源地址
				   ip_header[4]<=32'hc0a80003;                      //192.168.0.3目的地址广播地址
					ip_header[5]<=32'h1f901f90;                      //2个字节的源端口号和2个字节的目的端口号
				   ip_header[6]<={tx_data_length,16'h0000};         //2个字节的数据长度和2个字节的校验和（无）
	   			tx_state<=make;
         end	
         make:begin            //生成包头的校验和
			    if(i==0) begin
					  check_buffer_0 <=ip_header[0][15:0]+ip_header[0][31:16]+ip_header[1][15:0]+ip_header[1][31:16]+ip_header[2][15:0];
					  check_buffer_1 <=ip_header[2][31:16]+ip_header[3][15:0]+ip_header[3][31:16]+ip_header[4][15:0]+ip_header[4][31:16];						
                 i<= 1;
				   end
             else if(i==1) begin
					   check_buffer <= check_buffer_0  + check_buffer_1;
					   i <= 2;
				 end				
             else if(i==2) begin
					   check_buffer[15:0]<=check_buffer[31:16]+check_buffer[15:0];
					   i <= 3;
				 end
			    else	begin
				      ip_header[2][15:0]<=~check_buffer[15:0];                 //header checksum
					   i<=0;
					   tx_state<=send55;
					end
		   end
			send55: begin                    //发送8个IP前导码:7个55, 1个d5                    
 				 txen<=1'b1;                             //GMII数据发送有效
				 crcre<=1'b1;                            //reset crc  
				 if(i==7) begin
               dataout[7:0]<=preamble[i][7:0];
					i<=0;
				   tx_state<=sendmac;
				 end
				 else begin                        
				    dataout[7:0]<=preamble[i][7:0];
				    i<=i+1;
				 end
			end	
			sendmac: begin                           //发送目标MAC address和源MAC address和IP包类型  
			 	 crcen<=1'b1;                            //crc校验使能，crc32数据校验从目标MAC开始		
				 crcre<=1'b0;                            			
             if(i==13) begin
               dataout[7:0]<=mac_addr[i][7:0];
					i<=0;
				   tx_state<=sendheader;
				 end
				 else begin                        
				    dataout[7:0]<=mac_addr[i][7:0];
				    i<=i+1'b1;
				 end
			end
			sendheader: begin                        //发送7个32bit的IP 包头
				datain_reg<=datain;                   //准备需要发送的数据	
			   if(j==6) begin                            
					  if(i==0) begin
						 dataout[7:0]<=ip_header[j][31:24];
						 i<=i+1'b1;
					  end
					  else if(i==1) begin
						 dataout[7:0]<=ip_header[j][23:16];
						 i<=i+1'b1;
					  end
					  else if(i==2) begin
						 dataout[7:0]<=ip_header[j][15:8];
						 i<=i+1'b1;
					  end
					  else if(i==3) begin
						 dataout[7:0]<=ip_header[j][7:0];
						 i<=0;
						 j<=0;
						 tx_state<=senddata;			 
					  end
					  else
						 txer<=1'b1;
				end		 
				else begin
					  if(i==0) begin
						 dataout[7:0]<=ip_header[j][31:24];
						 i<=i+1'b1;
					  end
					  else if(i==1) begin
						 dataout[7:0]<=ip_header[j][23:16];
						 i<=i+1'b1;
					  end
					  else if(i==2) begin
						 dataout[7:0]<=ip_header[j][15:8];
						 i<=i+1'b1;
					  end
					  else if(i==3) begin
						 dataout[7:0]<=ip_header[j][7:0];
						 i<=0;
						 j<=j+1'b1;
					  end					
					  else
						 txer<=1'b1;
				end
			 end
			 senddata:begin                                      //发送UDP数据包
			   if(tx_data_counter==tx_data_length-9) begin       //发送最后的数据
				   tx_state<=sendcrc;	
					if(i==0) begin    
					  dataout[7:0]<=datain_reg[31:24];
					  i<=0;
					end
					else if(i==1) begin
					  dataout[7:0]<=datain_reg[23:16];
					  i<=0;
					end
					else if(i==2) begin
					  dataout[7:0]<=datain_reg[15:8];
					  i<=0;
					end
					else if(i==3) begin
			        dataout[7:0]<=datain_reg[7:0];
					  datain_reg<=datain;                       //准备数据
					  i<=0;
					end
            end
            else begin                                     //发送其它的数据包
               tx_data_counter<=tx_data_counter+1'b1;			
					if(i==0) begin    
					  dataout[7:0]<=datain_reg[31:24];
					  i<=i+1'b1;
					  ram_rd_addr<=ram_rd_addr+1'b1;           //RAM地址加1, 提前让RAM输出数据	
					end
					else if(i==1) begin
					  dataout[7:0]<=datain_reg[23:16];
					  i<=i+1'b1;
					end
					else if(i==2) begin
					  dataout[7:0]<=datain_reg[15:8];
					  i<=i+1'b1;
					end
					else if(i==3) begin
			        dataout[7:0]<=datain_reg[7:0];
					  datain_reg<=datain;                       //准备数据					  
					  i<=0; 				  
					end
				end
			end	
			sendcrc: begin                              //发送32位的crc校验
				crcen<=1'b0;
				if(i==0)	begin
					  dataout[7:0] <= {~crc[24], ~crc[25], ~crc[26], ~crc[27], ~crc[28], ~crc[29], ~crc[30], ~crc[31]};
					  i<=i+1'b1;
					end
				else begin
				  if(i==1) begin
					   dataout[7:0]<={~crc[16], ~crc[17], ~crc[18], ~crc[19], ~crc[20], ~crc[21], ~crc[22], ~crc[23]};
						i<=i+1'b1;
				  end
				  else if(i==2) begin
					   dataout[7:0]<={~crc[8], ~crc[9], ~crc[10], ~crc[11], ~crc[12], ~crc[13], ~crc[14], ~crc[15]};
						i<=i+1'b1;
				  end
				  else if(i==3) begin
					   dataout[7:0]<={~crc[0], ~crc[1], ~crc[2], ~crc[3], ~crc[4], ~crc[5], ~crc[6], ~crc[7]};
						i<=0;
						tx_state<=idle;
				  end
				  else begin
                  txer<=1'b1;
				  end
				end
			end					
			default:tx_state<=idle;		
       endcase	  
 end
/*
wire [35:0]   CONTROL0;
wire [255:0]  TRIG0;
chipscope_icon icon_debug (
    .CONTROL0(CONTROL0) // INOUT BUS [35:0]
);

chipscope_ila ila_filter_debug (
    .CONTROL(CONTROL0), // INOUT BUS [35:0]
   // .CLK(dma_clk),      // IN
    .CLK(clk),      // IN
    .TRIG0(TRIG0)      // IN BUS [255:0]
    //.TRIG_OUT(TRIG_OUT0)
);                                                     

assign  TRIG0[15:0] = tx_data_counter;                                               
assign  TRIG0[31:16] = tx_data_length;
assign  TRIG0[35 :  32] = tx_state;
assign  TRIG0[67 :  36] = time_counter;

*/
endmodule


