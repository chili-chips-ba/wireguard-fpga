`timescale 1ns / 1ps
/****************************************/
//      GMII UDP���ݰ�����ģ�顡������������//
/****************************************/
module iprecieve(
					 input clk,                                  //GMII����ʱ��
					 input [7:0] datain,                         //GMII��������
					 input e_rxdv,                               //GMII����������Ч�ź�
					 input clr,                                  //���/��λ�ź�
					 output reg [47:0]  board_mac,               //������˵�MAC
					 output reg [47:0]  pc_mac,	               //PC�˵�MAC 
					 output reg [15:0]  IP_Prtcl,                //IP ����
					 output reg         valid_ip_P,					 
					 output reg [159:0] IP_layer,                //IP��ͷ���� 
					 output reg [31:0]  pc_IP,                   //PC�˵�IP��ַ
					 output reg [31:0]  board_IP,                //������˵�IP��ַ	 
					 output reg [63:0]  UDP_layer,               //UDP��ͷ	 

					 output reg [31:0]  data_o,                  //UDP���յ�����            

					 output reg [15:0]  rx_total_length,         //UDP frame���ܳ���
					 output reg         data_o_valid,            //UDP������Ч�ź�// 
					 output reg [3:0]   rx_state,			         //����״̬��	 
					 output reg [15:0]  rx_data_length,          //���յ�UDP���ݰ��ĳ���
					 output reg [8:0]   ram_wr_addr,             //ram��д��ַ
					 output reg         data_receive             //���յ�UDP����־
									
		         );

reg [15:0] myIP_Prtcl;
reg [159:0] myIP_layer;
reg [63:0] myUDP_layer;
reg [31:0] mydata; 
reg [2:0] byte_counter;
reg [4:0] state_counter;
reg [95:0] mymac;
reg [15:0] data_counter;
	 
parameter idle=4'd0,six_55=4'd1,spd_d5=4'd2,rx_mac=4'd3,rx_IP_Protocol=4'd4,
	       rx_IP_layer=4'd5,rx_UDP_layer=4'd6,rx_data=4'd7,rx_finish=4'd8;
	 
initial
begin
	 rx_state<=idle;
end

//UDP���ݽ��ճ���	 	
always@(posedge clk)
	begin
	   if(!clr) begin
		    rx_state<=idle;
			 data_receive<=1'b0;
		end
		else
		case(rx_state)
		  idle: begin
			     valid_ip_P<=1'b0;
			     byte_counter<=3'd0;
              data_counter<=10'd0;
				  mydata<=32'd0;
			     state_counter<=5'd0;	
				  data_o_valid<=1'b0; 
				  ram_wr_addr<=0;
				  if(e_rxdv==1'b1) begin                           //����������ЧΪ�ߣ���ʼ��������
					  if(datain[7:0]==8'h55) begin                  //���յ���һ��55//
						  rx_state<=six_55;
						  mydata<={mydata[23:0],datain[7:0]};
					  end
					  else
						  rx_state<=idle;
				  end
		  end		
		  six_55: begin                                              //����6��0x55//
			   if ((datain[7:0]==8'h55)&&(e_rxdv==1'b1)) begin
                 if (state_counter==5) begin
					      state_counter<=0;
							rx_state<=spd_d5;
                 end
					  else
					  		state_counter<=state_counter+1'b1;
				end
				else			
				  rx_state<=idle;
		  end
		  spd_d5: begin                                              //����1��0xd5//
			   if((datain[7:0]==8'hd5)&&(e_rxdv==1'b1)) 
				  rx_state<=rx_mac;			
				else 
				  rx_state<=idle;
		  end	
		  rx_mac: begin                    //����Ŀ��mac address��Դmac address
				if(e_rxdv==1'b1)	begin
					if(state_counter<5'd11)	begin
						  mymac<={mymac[87:0],datain};
						  state_counter<=state_counter+1'b1;
					end
				   else begin
					   board_mac<=mymac[87:40];
					   pc_mac<={mymac[39:0],datain};
					   state_counter<=5'd0;
						if((mymac[87:72]==16'h000a)&&(mymac[71:56]==16'h3501)&&(mymac[55:40]==16'hfec0))   //�ж�Ŀ��MAC Address�Ƿ�Ϊ��FPGA
						   rx_state<=rx_IP_Protocol;
						else
						   rx_state<=idle;
				   end
				end
				else
				   rx_state<=idle;				
		  end
		  rx_IP_Protocol: begin                                              //����2���ֽڵ�IP TYPE//
			  if(e_rxdv==1'b1) begin
					if(state_counter<5'd1) begin
						 myIP_Prtcl<={myIP_Prtcl[7:0],datain[7:0]};
						 state_counter<=state_counter+1'b1;
					end
					else	begin
						 IP_Prtcl<={myIP_Prtcl[7:0],datain[7:0]};
						 valid_ip_P<=1'b1;
                   state_counter<=5'd0;
						 rx_state<=rx_IP_layer;
					end
				end
			   else 
				rx_state<=idle;
			end		  
		   rx_IP_layer: begin               //����20�ֽڵ�udp�����ͷ,ip address
				valid_ip_P<=1'b0;
				if(e_rxdv==1'b1) begin
					if(state_counter<5'd19)	begin
						myIP_layer<={myIP_layer[151:0],datain[7:0]};
						state_counter<=state_counter+1'b1;
					end
					else begin
						IP_layer<={myIP_layer[151:0],datain[7:0]};
						state_counter<=5'd0;
						rx_state<=rx_UDP_layer;
					end
				end
				else 
				   rx_state<=idle;
			end 					
			rx_UDP_layer: begin                //����8�ֽ�UDP�Ķ˿ںż�UDP���ݰ���	  
		      rx_total_length<=IP_layer[143:128];
				pc_IP<=IP_layer[63:32];
				board_IP<=IP_layer[31:0];
				if(e_rxdv==1'b1) begin
					if(state_counter<5'd7)	begin
						myUDP_layer<={myUDP_layer[55:0],datain[7:0]};
						state_counter<=state_counter+1'b1;
					end
					else begin
						UDP_layer<={myUDP_layer[55:0],datain[7:0]};
                  rx_data_length<= myUDP_layer[23:8];                //UDP���ݰ��ĳ���						
						state_counter<=5'd0;
						rx_state<=rx_data;
					end
				end
				else 
				   rx_state<=idle;
			end  
  		   rx_data: begin                                             //����UDP������       
					if(e_rxdv==1'b1) begin
					   if (data_counter==rx_data_length-9) begin         //����������,������UDP������Ҫ��ȥ8�ֽڵ�UDP��ͷ
						    data_counter<=0;
  					       rx_state<=rx_finish;
							 ram_wr_addr<=ram_wr_addr+1'b1;	
							 data_o_valid<=1'b1;               //дRAM 							 
						    if(byte_counter==3'd3) begin
								  data_o<={mydata[23:0],datain[7:0]};
								  byte_counter<=0;
							 end
						    else if(byte_counter==3'd2) begin
						        data_o<={mydata[15:0],datain[7:0],8'h00};       //����32bit,��0
								  byte_counter<=0;
							 end
						    else if(byte_counter==3'd1) begin
						        data_o<={mydata[7:0],datain[7:0],16'h0000};     //����32bit,��0
								  byte_counter<=0;
							 end
						    else if(byte_counter==3'd0) begin
						        data_o<={datain[7:0],24'h000000};              //����32bit,��0
								  byte_counter<=0;
							 end
						end
						else begin
							 data_counter<=data_counter+1'b1;
						    if(byte_counter<3'd3)	begin
								  mydata<={mydata[23:0],datain[7:0]};
								  byte_counter<=byte_counter+1'b1;
					           data_o_valid<=1'b0;  
							 end
							 else begin
						        data_o<={mydata[23:0],datain[7:0]};
						        byte_counter<=3'd0;
								  data_o_valid<=1'b1;                        //����4byes����,дram����
                          ram_wr_addr<=ram_wr_addr+1'b1;							  
                      end	
                  end							 
               end
					else
  					    rx_state<=idle;
			 end 
			 rx_finish: begin
   				 data_o_valid<=1'b0;           
					 data_receive<=1'b1;
                rx_state<=idle;
          end		
			 default:rx_state<=idle;    
		endcase
		end
endmodule
