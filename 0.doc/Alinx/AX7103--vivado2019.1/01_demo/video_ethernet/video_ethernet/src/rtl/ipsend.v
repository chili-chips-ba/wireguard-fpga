`timescale 1ns / 1ps
/****************************************/
//      GMII UDP���ݰ�����ģ�顡������������//
/****************************************/

module ipsend(
				  input              clk,                   //GMII���͵�ʱ���ź�
				  output reg         txen,                  //GMII����ʹ���ź�
				  output reg         txer,                  //GMII���ʹ����ź�
				  output reg [7:0]   dataout,               //GMII��������
				  input      [31:0]  crc,                   //CRC32У����
				  input      [31:0]  datain,                //RAM�е�����	 
				  output reg         crcen,                 //CRC32 У��ʹ��
				  output reg         crcre,                 //CRC32 У�����

				  output reg [3:0]   tx_state,              //����״̬��    
				  input      [15:0]  tx_data_length,        //���͵����ݰ��ĳ���
				  input      [15:0]  tx_total_length,       //���Ͱ��ĳ���
				  output reg [8:0]   ram_rd_addr            //ram����ַ
				  
	  );


reg [31:0]  datain_reg;

reg [31:0] ip_header [6:0];                  //���ݶ�Ϊ1K

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
	 //����IP ��ͷ
	 preamble[0]<=8'h55;                 //7��ǰ����55,һ��֡��ʼ��d5
	 preamble[1]<=8'h55;
	 preamble[2]<=8'h55;
	 preamble[3]<=8'h55;
	 preamble[4]<=8'h55;
	 preamble[5]<=8'h55;
	 preamble[6]<=8'h55;
	 preamble[7]<=8'hD5;
	 mac_addr[0]<=8'hFF;                 //Ŀ��MAC��ַ ff-ff-ff-ff-ff-ff, ȫffΪ�㲥��
	 mac_addr[1]<=8'hFF;
	 mac_addr[2]<=8'hFF;
	 mac_addr[3]<=8'hFF;
	 mac_addr[4]<=8'hFF;
	 mac_addr[5]<=8'hFF;
	 mac_addr[6]<=8'h00;                 //ԴMAC��ַ 00-0A-35-01-FE-C0
	 mac_addr[7]<=8'h0A;
	 mac_addr[8]<=8'h35;
	 mac_addr[9]<=8'h01;
	 mac_addr[10]<=8'hFE;
	 mac_addr[11]<=8'hC0;
	 mac_addr[12]<=8'h08;                //0800: IP������
	 mac_addr[13]<=8'h00;
	 i<=0;
 end


//UDP���ݷ��ͳ���	 
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
             if (time_counter >= 32'd125_000_000) begin     //�ȴ��ӳ�, ÿ��һ��ʱ�䷢��һ�����ݰ�
				     tx_state<=start;  
                 time_counter<=0;
             end
             else
                 time_counter<=time_counter+1'b1;				
			end
		   start:begin        //IP header
					ip_header[0]<={16'h4500,tx_total_length};        //�汾�ţ�4�� ��ͷ���ȣ�20��IP���ܳ�
				   ip_header[1][31:16]<= ip_header[1][31:16]+1'b1;   //�����к�
					ip_header[1][15:0]<=16'h4000;                    //Fragment offset
				   ip_header[2]<=32'h80110000;                      //mema[2][15:0] Э�飺17(UDP)
				   ip_header[3]<=32'hc0a80002;                      //192.168.0.2Դ��ַ
				   ip_header[4]<=32'hc0a80003;                      //192.168.0.3Ŀ�ĵ�ַ�㲥��ַ
					ip_header[5]<=32'h1f901f90;                      //2���ֽڵ�Դ�˿ںź�2���ֽڵ�Ŀ�Ķ˿ں�
				   ip_header[6]<={tx_data_length,16'h0000};         //2���ֽڵ����ݳ��Ⱥ�2���ֽڵ�У��ͣ��ޣ�
	   			tx_state<=make;
         end	
         make:begin            //���ɰ�ͷ��У���
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
			send55: begin                    //����8��IPǰ����:7��55, 1��d5                    
 				 txen<=1'b1;                             //GMII���ݷ�����Ч
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
			sendmac: begin                           //����Ŀ��MAC address��ԴMAC address��IP������  
			 	 crcen<=1'b1;                            //crcУ��ʹ�ܣ�crc32����У���Ŀ��MAC��ʼ		
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
			sendheader: begin                        //����7��32bit��IP ��ͷ
				datain_reg<=datain;                   //׼����Ҫ���͵�����	
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
			 senddata:begin                                      //����UDP���ݰ�
			   if(tx_data_counter==tx_data_length-9) begin       //������������
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
					  datain_reg<=datain;                       //׼������
					  i<=0;
					end
            end
            else begin                                     //�������������ݰ�
               tx_data_counter<=tx_data_counter+1'b1;			
					if(i==0) begin    
					  dataout[7:0]<=datain_reg[31:24];
					  i<=i+1'b1;
					  ram_rd_addr<=ram_rd_addr+1'b1;           //RAM��ַ��1, ��ǰ��RAM�������	
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
					  datain_reg<=datain;                       //׼������					  
					  i<=0; 				  
					end
				end
			end	
			sendcrc: begin                              //����32λ��crcУ��
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


