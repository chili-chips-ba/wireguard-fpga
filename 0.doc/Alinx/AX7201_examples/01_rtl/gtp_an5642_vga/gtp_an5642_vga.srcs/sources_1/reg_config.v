//camera中寄存器的配置程序
 module reg_config(     
		  input clk_25M,
		  input camera_rstn,
		  input initial_en,
		  output reg_conf_done,
		  output i2c_sclk,
		  inout i2c_sdat,
		  output reg clock_20k,
		  output reg [8:0]reg_index

	  );

    
     
     reg [15:0]clock_20k_cnt;
     reg [1:0]config_step;
	  
     reg [31:0]i2c_data;
     reg [23:0]reg_data;
     reg start;
	  reg reg_conf_done_reg;
	  
     i2c_com u1(.clock_i2c(clock_20k),
               .camera_rstn(camera_rstn),
               .ack(ack),
               .i2c_data(i2c_data),
               .start(start),
               .tr_end(tr_end),
               .i2c_sclk(i2c_sclk),
               .i2c_sdat(i2c_sdat));

assign reg_conf_done=reg_conf_done_reg;
//产生i2c控制时钟-20khz    
always@(posedge clk_25M or negedge camera_rstn)   
begin
   if(!camera_rstn) begin
        clock_20k<=0;
        clock_20k_cnt<=0;
   end
   else if(clock_20k_cnt<1249)
      clock_20k_cnt<=clock_20k_cnt+1'b1;
   else begin
         clock_20k<=!clock_20k;
         clock_20k_cnt<=0;
   end
end



////iic寄存器配置过程控制    
always@(posedge clock_20k or negedge camera_rstn)    
begin
   if(!camera_rstn) begin
       config_step<=0;
       start<=0;
       reg_index<=0;
		 reg_conf_done_reg<=0;
   end
   else begin
      if(reg_conf_done_reg==1'b0) begin          //如果camera初始化未完成
			  if(reg_index<304) begin               //配置前302个寄存器
					 case(config_step)
					 0:begin
						i2c_data<={8'h78,reg_data};       //OV5640 IIC Device address is 0x78   
						start<=1;                         //i2c写开始
						config_step<=1;                  
					 end
					 1:begin
						if(tr_end) begin                  //i2c写结束               					
							 start<=0;
							 config_step<=2;
						end
					 end
					 2:begin
						  reg_index<=reg_index+1'b1;       //配置下一个寄存器
						  config_step<=0;
					 end
					 endcase
				end
			 else 
				reg_conf_done_reg<=1'b1;                //OV5640寄存器初始化完成
      end
   end
 end
			
////iic需要配置的寄存器值  			
always@(reg_index)   
 begin
    case(reg_index)
	 //15fps VGA YUV output  // 24MHz input clock, 24MHz PCLK
	 0:reg_data<=24'h310311;// system clock from pad, bit[1]
	 1:reg_data<=24'h300882;// software reset, bit[7]// delay 5ms 
	 2:reg_data<=24'h300842;// software power down, bit[6]
	 3:reg_data<=24'h310303;// system clock from PLL, bit[1]
	 4:reg_data<=24'h3017ff;// FREX, Vsync, HREF, PCLK, D[9:6] output enable
	 5:reg_data<=24'h3018ff;// D[5:0], GPIO[1:0] output enable
	 6:reg_data<=24'h30341A;// MIPI 10-bit
	 7:reg_data<=24'h303713;// PLL root divider, bit[4], PLL pre-divider, bit[3:0]
	 8:reg_data<=24'h310801;// PCLK root divider, bit[5:4], SCLK2x root divider, bit[3:2] // SCLK root divider, bit[1:0] 
	 9:reg_data<=24'h363036;
	 10:reg_data<=24'h36310e;
	 11:reg_data<=24'h3632e2;
	 12:reg_data<=24'h363312;
	 13:reg_data<=24'h3621e0;
	 14:reg_data<=24'h3704a0;
	 15:reg_data<=24'h37035a;
	 16:reg_data<=24'h371578;
	 17:reg_data<=24'h371701;
	 18:reg_data<=24'h370b60;
	 19:reg_data<=24'h37051a;
	 20:reg_data<=24'h390502;
	 21:reg_data<=24'h390610;
	 22:reg_data<=24'h39010a;
	 23:reg_data<=24'h373112;
	 24:reg_data<=24'h360008;// VCM control
	 25:reg_data<=24'h360133;// VCM control
	 26:reg_data<=24'h302d60;// system control
	 27:reg_data<=24'h362052;
	 28:reg_data<=24'h371b20;
	 29:reg_data<=24'h471c50;
	 30:reg_data<=24'h3a1343;// pre-gain = 1.047x
	 31:reg_data<=24'h3a1800;// gain ceiling
	 32:reg_data<=24'h3a19f8;// gain ceiling = 15.5x
	 33:reg_data<=24'h363513;
	 34:reg_data<=24'h363603;
	 35:reg_data<=24'h363440;
	 36:reg_data<=24'h362201; // 50/60Hz detection     50/60Hz 灯光条纹过滤
	 37:reg_data<=24'h3c0134;// Band auto, bit[7]
	 38:reg_data<=24'h3c0428;// threshold low sum	 
	 39:reg_data<=24'h3c0598;// threshold high sum
	 40:reg_data<=24'h3c0600;// light meter 1 threshold[15:8]
	 41:reg_data<=24'h3c0708;// light meter 1 threshold[7:0]
	 42:reg_data<=24'h3c0800;// light meter 2 threshold[15:8]
	 43:reg_data<=24'h3c091c;// light meter 2 threshold[7:0]
	 44:reg_data<=24'h3c0a9c;// sample number[15:8]
	 45:reg_data<=24'h3c0b40;// sample number[7:0]
	 46:reg_data<=24'h381000;// Timing Hoffset[11:8]
	 47:reg_data<=24'h381110;// Timing Hoffset[7:0]
	 48:reg_data<=24'h381200;// Timing Voffset[10:8] 
	 49:reg_data<=24'h370864;
	 50:reg_data<=24'h400102;// BLC start from line 2
	 51:reg_data<=24'h40051a;// BLC always update
	 52:reg_data<=24'h300000;// enable blocks
	 53:reg_data<=24'h3004ff;// enable clocks 
	 54:reg_data<=24'h300e58;// MIPI power down, DVP enable
	 55:reg_data<=24'h302e00;
	 56:reg_data<=24'h430060;// RGB565
	 57:reg_data<=24'h501f01;// ISP RGB 
	 58:reg_data<=24'h440e00;
	 59:reg_data<=24'h5000a7; // Lenc on, raw gamma on, BPC on, WPC on, CIP on // AEC target    自动曝光控制
	 60:reg_data<=24'h3a0f30;// stable range in high
	 61:reg_data<=24'h3a1028;// stable range in low
	 62:reg_data<=24'h3a1b30;// stable range out high
	 63:reg_data<=24'h3a1e26;// stable range out low
	 64:reg_data<=24'h3a1160;// fast zone high
	 65:reg_data<=24'h3a1f14;// fast zone low// Lens correction for ?   镜头补偿
	 66:reg_data<=24'h580023;
	 67:reg_data<=24'h580114;
	 68:reg_data<=24'h58020f;
	 69:reg_data<=24'h58030f;
	 70:reg_data<=24'h580412;
	 71:reg_data<=24'h580526;
	 72:reg_data<=24'h58060c;
	 73:reg_data<=24'h580708;
	 74:reg_data<=24'h580805;
	 75:reg_data<=24'h580905;
	 76:reg_data<=24'h580a08;
	 77:reg_data<=24'h580b0d;
	 78:reg_data<=24'h580c08;
	 79:reg_data<=24'h580d03;
	 80:reg_data<=24'h580e00;
	 81:reg_data<=24'h580f00;
	 82:reg_data<=24'h581003;
	 83:reg_data<=24'h581109;
	 84:reg_data<=24'h581207;
	 85:reg_data<=24'h581303;
	 86:reg_data<=24'h581400;
	 87:reg_data<=24'h581501;
	 88:reg_data<=24'h581603;
	 89:reg_data<=24'h581708;
	 90:reg_data<=24'h58180d;
	 91:reg_data<=24'h581908;
	 92:reg_data<=24'h581a05;
	 93:reg_data<=24'h581b06;
	 94:reg_data<=24'h581c08;
	 95:reg_data<=24'h581d0e;
	 96:reg_data<=24'h581e29;
	 97:reg_data<=24'h581f17;
	 98:reg_data<=24'h582011;
	 99:reg_data<=24'h582111;
	 100:reg_data<=24'h582215;
	 101:reg_data<=24'h582328;
	 102:reg_data<=24'h582446;
	 103:reg_data<=24'h582526;
	 104:reg_data<=24'h582608;
	 105:reg_data<=24'h582726;
	 106:reg_data<=24'h582864;
	 107:reg_data<=24'h582926;
	 108:reg_data<=24'h582a24;
	 109:reg_data<=24'h582b22;
	 110:reg_data<=24'h582c24;
	 111:reg_data<=24'h582d24;
	 112:reg_data<=24'h582e06;
	 113:reg_data<=24'h582f22;
	 114:reg_data<=24'h583040;
	 115:reg_data<=24'h583142;
	 116:reg_data<=24'h583224;
	 117:reg_data<=24'h583326;
	 118:reg_data<=24'h583424;
	 119:reg_data<=24'h583522;
	 120:reg_data<=24'h583622;
	 121:reg_data<=24'h583726;
	 122:reg_data<=24'h583844;
	 123:reg_data<=24'h583924;
	 124:reg_data<=24'h583a26;
	 125:reg_data<=24'h583b28;
	 126:reg_data<=24'h583c42;
	 127:reg_data<=24'h583dce;// lenc BR offset // AWB   自动白平衡
	 128:reg_data<=24'h5180ff;// AWB B block
	 129:reg_data<=24'h5181f2;// AWB control 
	 130:reg_data<=24'h518200;// [7:4] max local counter, [3:0] max fast counter
	 131:reg_data<=24'h518314;// AWB advanced 
	 132:reg_data<=24'h518425;
	 133:reg_data<=24'h518524;
	 134:reg_data<=24'h518609;
	 135:reg_data<=24'h518709;
	 136:reg_data<=24'h518809;
	 137:reg_data<=24'h518975;
	 138:reg_data<=24'h518a54;
	 139:reg_data<=24'h518be0;
	 140:reg_data<=24'h518cb2;
	 141:reg_data<=24'h518d42;
	 142:reg_data<=24'h518e3d;
	 143:reg_data<=24'h518f56;
	 144:reg_data<=24'h519046;
	 145:reg_data<=24'h5191f8;// AWB top limit
	 146:reg_data<=24'h519204;// AWB bottom limit
	 147:reg_data<=24'h519370;// red limit
	 148:reg_data<=24'h5194f0;// green limit
	 149:reg_data<=24'h5195f0;// blue limit
	 150:reg_data<=24'h519603;// AWB control
	 151:reg_data<=24'h519701;// local limit 
	 152:reg_data<=24'h519804;
	 153:reg_data<=24'h519912;
	 154:reg_data<=24'h519a04;
	 155:reg_data<=24'h519b00;
	 156:reg_data<=24'h519c06;
	 157:reg_data<=24'h519d82;
	 158:reg_data<=24'h519e38;// AWB control // Gamma    伽玛曲线
	 159:reg_data<=24'h548001;// Gamma bias plus on, bit[0] 
	 160:reg_data<=24'h548108;
	 161:reg_data<=24'h548214;
	 162:reg_data<=24'h548328;
	 163:reg_data<=24'h548451;
	 164:reg_data<=24'h548565;
	 165:reg_data<=24'h548671;
	 166:reg_data<=24'h54877d;
	 167:reg_data<=24'h548887;
	 168:reg_data<=24'h548991;
	 169:reg_data<=24'h548a9a;
	 170:reg_data<=24'h548baa;
	 171:reg_data<=24'h548cb8;
	 172:reg_data<=24'h548dcd;
	 173:reg_data<=24'h548edd;
	 174:reg_data<=24'h548fea;
	 175:reg_data<=24'h54901d;// color matrix   色彩矩阵
	 176:reg_data<=24'h53811e;// CMX1 for Y
	 177:reg_data<=24'h53825b;// CMX2 for Y
	 178:reg_data<=24'h538308;// CMX3 for Y
	 179:reg_data<=24'h53840a;// CMX4 for U
	 180:reg_data<=24'h53857e;// CMX5 for U
	 181:reg_data<=24'h538688;// CMX6 for U
	 182:reg_data<=24'h53877c;// CMX7 for V
	 183:reg_data<=24'h53886c;// CMX8 for V
	 184:reg_data<=24'h538910;// CMX9 for V
	 185:reg_data<=24'h538a01;// sign[9]
	 186:reg_data<=24'h538b98; // sign[8:1] // UV adjust   UV色彩饱和度调整
	 187:reg_data<=24'h558006;// saturation on, bit[1]
	 188:reg_data<=24'h558340;
	 189:reg_data<=24'h558410;
	 190:reg_data<=24'h558910;
	 191:reg_data<=24'h558a00;
	 192:reg_data<=24'h558bf8;
	 193:reg_data<=24'h501d40;// enable manual offset of contrast// CIP  锐化和降噪 
	 194:reg_data<=24'h530008;// CIP sharpen MT threshold 1
	 195:reg_data<=24'h530130;// CIP sharpen MT threshold 2
	 196:reg_data<=24'h530210;// CIP sharpen MT offset 1
	 197:reg_data<=24'h530300;// CIP sharpen MT offset 2
	 198:reg_data<=24'h530408;// CIP DNS threshold 1
	 199:reg_data<=24'h530530;// CIP DNS threshold 2
	 200:reg_data<=24'h530608;// CIP DNS offset 1
	 201:reg_data<=24'h530716;// CIP DNS offset 2 
	 202:reg_data<=24'h530908;// CIP sharpen TH threshold 1
	 203:reg_data<=24'h530a30;// CIP sharpen TH threshold 2
	 204:reg_data<=24'h530b04;// CIP sharpen TH offset 1
	 205:reg_data<=24'h530c06;// CIP sharpen TH offset 2
	 206:reg_data<=24'h502500;
	 207:reg_data<=24'h300802; // wake up from standby, bit[6]
	 //640x480 30帧/秒, night mode 5fps, input clock =24Mhz, PCLK =56Mhz
	 208:reg_data<=24'h303511;// PLL
	 209:reg_data<=24'h303646;// PLL
	 210:reg_data<=24'h3c0708;// light meter 1 threshold [7:0]
	 211:reg_data<=24'h382041;// Sensor flip off, ISP flip on
	 212:reg_data<=24'h382100;// Sensor mirror on, ISP mirror on, H binning on
	 213:reg_data<=24'h381431;// X INC 
	 214:reg_data<=24'h381531;// Y INC
	 215:reg_data<=24'h380000;// HS: X address start high byte
	 216:reg_data<=24'h380100;// HS: X address start low byte
	 217:reg_data<=24'h380200;// VS: Y address start high byte
	 218:reg_data<=24'h380304;// VS: Y address start high byte 
	 219:reg_data<=24'h38040a;// HW (HE)         
	 220:reg_data<=24'h38053f;// HW (HE)
	 221:reg_data<=24'h380607;// VH (VE)         
	 222:reg_data<=24'h38079b;// VH (VE)      
	 223:reg_data<=24'h380803;// DVPHO  
	 224:reg_data<=24'h380920;// DVPHO
	 225:reg_data<=24'h380a02;// DVPVO
	 226:reg_data<=24'h380b58;// DVPVO
	 227:reg_data<=24'h380c07;// HTS            //Total horizontal size 1896
	 228:reg_data<=24'h380d68;// HTS
	 229:reg_data<=24'h380e03;// VTS            //total vertical size 984
	 230:reg_data<=24'h380fd8;// VTS 
	 231:reg_data<=24'h381306;// Timing Voffset 
	 232:reg_data<=24'h361800;
	 233:reg_data<=24'h361229;
	 234:reg_data<=24'h370952;
	 235:reg_data<=24'h370c03; 
	 236:reg_data<=24'h3a0217;// 60Hz max exposure, night mode 5fps
	 237:reg_data<=24'h3a0310;// 60Hz max exposure // banding filters are calculated automatically in camera driver
	 //reg_data<=24'h3a0801;// B50 step
	 //reg_data<=24'h3a0927;// B50 step
	 //reg_data<=24'h3a0a00;// B60 step
	 //reg_data<=24'h3a0bf6;// B60 step
	 //reg_data<=24'h3a0e03;// 50Hz max band
	 //reg_data<=24'h3a0d04;// 60Hz max band
	 238:reg_data<=24'h3a1417;// 50Hz max exposure, night mode 5fps
	 239:reg_data<=24'h3a1510;// 50Hz max exposure     
	 240:reg_data<=24'h400402;// BLC 2 lines 
	 241:reg_data<=24'h30021c;// reset JFIFO, SFIFO, JPEG
	 242:reg_data<=24'h3006c3;// disable clock of JPEG2x, JPEG
	 243:reg_data<=24'h471303;// JPEG mode 3
	 244:reg_data<=24'h440704;// Quantization scale 
	 245:reg_data<=24'h460b35;
	 246:reg_data<=24'h460c22;
	 247:reg_data<=24'h483722; // DVP CLK divider
	 248:reg_data<=24'h382402; // DVP CLK divider 
	 249:reg_data<=24'h5001a3; // SDE on, scale on, UV average off, color matrix on, AWB on
	 250:reg_data<=24'h350300; // AEC/AGC on 
	 
	 //set OV5640 to video mode 720p 
	 251:reg_data<=24'h303521;// PLL     input clock =24Mhz, PCLK =84Mhz
	 252:reg_data<=24'h303669;// PLL
	 253:reg_data<=24'h3c0707; // lightmeter 1 threshold[7:0]
	 254:reg_data<=24'h382047; // flip
	 255:reg_data<=24'h382100; // mirror
	 256:reg_data<=24'h381431; // timing X inc
	 257:reg_data<=24'h381531; // timing Y inc
	 258:reg_data<=24'h380000; // HS
	 259:reg_data<=24'h380100; // HS
	 260:reg_data<=24'h380200; // VS
	 261:reg_data<=24'h3803fa; // VS
	 262:reg_data<=24'h38040a; // HW (HE)
	 263:reg_data<=24'h38053f; // HW (HE)
	 264:reg_data<=24'h380606; // VH (VE)
	 265:reg_data<=24'h3807a9; // VH (VE)
	 266:reg_data<=24'h380805; // DVPHO     (1280)
	 267:reg_data<=24'h380900; // DVPHO     (1280)
	 268:reg_data<=24'h380a02; // DVPVO     (720)->
	 269:reg_data<=24'h380bd0; // DVPVO     (720)->
	 270:reg_data<=24'h380c07; // HTS
	 271:reg_data<=24'h380d64; // HTS
	 272:reg_data<=24'h380e02; // VTS
	 273:reg_data<=24'h380fe4; // VTS
	 274:reg_data<=24'h381304; // timing V offset
	 275:reg_data<=24'h361800;
	 276:reg_data<=24'h361229;
	 277:reg_data<=24'h370952;
	 278:reg_data<=24'h370c03;
	 279:reg_data<=24'h3a0202; // 60Hz max exposure
	 280:reg_data<=24'h3a03e0; // 60Hz max exposure
	 281:reg_data<=24'h3a0800; // B50 step
	 282:reg_data<=24'h3a096f; // B50 step
	 283:reg_data<=24'h3a0a00; // B60 step
	 284:reg_data<=24'h3a0b5c; // B60 step
	 285:reg_data<=24'h3a0e06; // 50Hz max band
	 286:reg_data<=24'h3a0d08; // 60Hz max band
	 287:reg_data<=24'h3a1402; // 50Hz max exposure
	 288:reg_data<=24'h3a15e0; // 50Hz max exposure
	 289:reg_data<=24'h400402; // BLC line number
	 290:reg_data<=24'h30021c; // reset JFIFO, SFIFO, JPG
	 291:reg_data<=24'h3006c3; // disable clock of JPEG2x, JPEG
	 292:reg_data<=24'h471303; // JPEG mode 3
	 293:reg_data<=24'h440704; // Quantization sacle
	 294:reg_data<=24'h460b37;
	 295:reg_data<=24'h460c20;
	 296:reg_data<=24'h483716; // MIPI global timing
	 297:reg_data<=24'h382404; // PCLK manual divider
	 298:reg_data<=24'h5001a3; // SDE on, CMX on, AWB on, scale on
	 299:reg_data<=24'h350300; // AEC/AGC on 
	 300:reg_data<=24'h301602; //Strobe output enable
	 301:reg_data<=24'h3b070a; //FREX strobe mode1	
	 //strobe flash and frame exposure 	 
	 302:reg_data<=24'h3b0083;              //STROBE CTRL: strobe request ON, Strobe mode: LED3 
	 303:reg_data<=24'h3b0000;              //STROBE CTRL: strobe request OFF 
	 
	 //302:reg_data<=24'h503d80;            //reg_data<=24'h503d80; test pattern selection control, 80:color bar,00: test disable
	 //303:reg_data<=24'h474101;            //reg_data<=24'h47401; test pattern enable, Test pattern 8-bit	 
	 default:reg_data<=24'h000000;
    endcase      
end	 



endmodule

