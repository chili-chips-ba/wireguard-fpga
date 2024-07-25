//////////////////////////////////////////////////////////////////////////////////
//                                                                              //
//                                                                              //
//  Author: meisq                                                               //
//          msq@qq.com                                                          //
//          ALINX(shanghai) Technology Co.,Ltd                                  //
//          heijin                                                              //
//     WEB: http://www.alinx.cn/                                                //
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
//  2017/7/19     meisq          1.0         Original
//*******************************************************************************/

module lut_ov5640_rgb565_1024_768(
	input[9:0]             lut_index,   //Look-up table address
	output reg[31:0]       lut_data     //Device address (8bit I2C address), register address, register data
);

always@(*)
begin
	case(lut_index)			  
		10'd  0: lut_data <= {8'h78 , 24'h310311};// system clock from pad, bit[1]
		10'd  1: lut_data <= {8'h78 , 24'h300882};// software reset, bit[7]// delay 5ms 
		10'd  2: lut_data <= {8'h78 , 24'h300842};// software power down, bit[6]
		10'd  3: lut_data <= {8'h78 , 24'h310303};// system clock from PLL, bit[1]
		10'd  4: lut_data <= {8'h78 , 24'h3017ff};// FREX, Vsync, HREF, PCLK, D[9:6] output enable
		10'd  5: lut_data <= {8'h78 , 24'h3018ff};// D[5:0], GPIO[1:0] output enable
		10'd  6: lut_data <= {8'h78 , 24'h30341A};// MIPI 10-bit
		10'd  7: lut_data <= {8'h78 , 24'h303713};// PLL root divider, bit[4], PLL pre-divider, bit[3:0]
		10'd  8: lut_data <= {8'h78 , 24'h310801};// PCLK root divider, bit[5:4], SCLK2x root divider, bit[3:2] // SCLK root divider, bit[1:0] 
		10'd  9: lut_data <= {8'h78 , 24'h363036};
		10'd 10: lut_data <= {8'h78 , 24'h36310e};
		10'd 11: lut_data <= {8'h78 , 24'h3632e2};
		10'd 12: lut_data <= {8'h78 , 24'h363312};
		10'd 13: lut_data <= {8'h78 , 24'h3621e0};
		10'd 14: lut_data <= {8'h78 , 24'h3704a0};
		10'd 15: lut_data <= {8'h78 , 24'h37035a};
		10'd 16: lut_data <= {8'h78 , 24'h371578};
		10'd 17: lut_data <= {8'h78 , 24'h371701};
		10'd 18: lut_data <= {8'h78 , 24'h370b60};
		10'd 19: lut_data <= {8'h78 , 24'h37051a};
		10'd 20: lut_data <= {8'h78 , 24'h390502};
		10'd 21: lut_data <= {8'h78 , 24'h390610};
		10'd 22: lut_data <= {8'h78 , 24'h39010a};
		10'd 23: lut_data <= {8'h78 , 24'h373112};
		10'd 24: lut_data <= {8'h78 , 24'h360008};// VCM control
		10'd 25: lut_data <= {8'h78 , 24'h360133};// VCM control
		10'd 26: lut_data <= {8'h78 , 24'h302d60};// system control
		10'd 27: lut_data <= {8'h78 , 24'h362052};
		10'd 28: lut_data <= {8'h78 , 24'h371b20};
		10'd 29: lut_data <= {8'h78 , 24'h471c50};
		10'd 30: lut_data <= {8'h78 , 24'h3a1343};// pre-gain = 1.047x
		10'd 31: lut_data <= {8'h78 , 24'h3a1800};// gain ceiling
		10'd 32: lut_data <= {8'h78 , 24'h3a19f8};// gain ceiling = 15.5x
		10'd 33: lut_data <= {8'h78 , 24'h363513};
		10'd 34: lut_data <= {8'h78 , 24'h363603};
		10'd 35: lut_data <= {8'h78 , 24'h363440};
		10'd 36: lut_data <= {8'h78 , 24'h362201}; // 50/60Hz detection     50/60Hz 灯光条纹过滤
		10'd 37: lut_data <= {8'h78 , 24'h3c0134};// Band auto, bit[7]
		10'd 38: lut_data <= {8'h78 , 24'h3c0428};// threshold low sum	 
		10'd 39: lut_data <= {8'h78 , 24'h3c0598};// threshold high sum
		10'd 40: lut_data <= {8'h78 , 24'h3c0600};// light meter 1 threshold[15:8]
		10'd 41: lut_data <= {8'h78 , 24'h3c0708};// light meter 1 threshold[7:0]
		10'd 42: lut_data <= {8'h78 , 24'h3c0800};// light meter 2 threshold[15:8]
		10'd 43: lut_data <= {8'h78 , 24'h3c091c};// light meter 2 threshold[7:0]
		10'd 44: lut_data <= {8'h78 , 24'h3c0a9c};// sample number[15:8]
		10'd 45: lut_data <= {8'h78 , 24'h3c0b40};// sample number[7:0]
		10'd 46: lut_data <= {8'h78 , 24'h381000};// Timing Hoffset[11:8]
		10'd 47: lut_data <= {8'h78 , 24'h381110};// Timing Hoffset[7:0]
		10'd 48: lut_data <= {8'h78 , 24'h381200};// Timing Voffset[10:8] 
		10'd 49: lut_data <= {8'h78 , 24'h370864};
		10'd 50: lut_data <= {8'h78 , 24'h400102};// BLC start from line 2
		10'd 51: lut_data <= {8'h78 , 24'h40051a};// BLC always update
		10'd 52: lut_data <= {8'h78 , 24'h300000};// enable blocks
		10'd 53: lut_data <= {8'h78 , 24'h3004ff};// enable clocks 
		10'd 54: lut_data <= {8'h78 , 24'h300e58};// MIPI power down, DVP enable
		10'd 55: lut_data <= {8'h78 , 24'h302e00};
		10'd 56: lut_data <= {8'h78 , 24'h430060};// RGB565
		10'd 57: lut_data <= {8'h78 , 24'h501f01};// ISP RGB 
		10'd 58: lut_data <= {8'h78 , 24'h440e00};
		10'd 59: lut_data <= {8'h78 , 24'h5000a7}; // Lenc on, raw gamma on, BPC on, WPC on, CIP on // AEC target    自动曝光控制
		10'd 60: lut_data <= {8'h78 , 24'h3a0f30};// stable range in high
		10'd 61: lut_data <= {8'h78 , 24'h3a1028};// stable range in low
		10'd 62: lut_data <= {8'h78 , 24'h3a1b30};// stable range out high
		10'd 63: lut_data <= {8'h78 , 24'h3a1e26};// stable range out low
		10'd 64: lut_data <= {8'h78 , 24'h3a1160};// fast zone high
		10'd 65: lut_data <= {8'h78 , 24'h3a1f14};// fast zone low// Lens correction for ?   镜头补偿
		10'd 66: lut_data <= {8'h78 , 24'h580023};
		10'd 67: lut_data <= {8'h78 , 24'h580114};
		10'd 68: lut_data <= {8'h78 , 24'h58020f};
		10'd 69: lut_data <= {8'h78 , 24'h58030f};
		10'd 70: lut_data <= {8'h78 , 24'h580412};
		10'd 71: lut_data <= {8'h78 , 24'h580526};
		10'd 72: lut_data <= {8'h78 , 24'h58060c};
		10'd 73: lut_data <= {8'h78 , 24'h580708};
		10'd 74: lut_data <= {8'h78 , 24'h580805};
		10'd 75: lut_data <= {8'h78 , 24'h580905};
		10'd 76: lut_data <= {8'h78 , 24'h580a08};
		10'd 77: lut_data <= {8'h78 , 24'h580b0d};
		10'd 78: lut_data <= {8'h78 , 24'h580c08};
		10'd 79: lut_data <= {8'h78 , 24'h580d03};
		10'd 80: lut_data <= {8'h78 , 24'h580e00};
		10'd 81: lut_data <= {8'h78 , 24'h580f00};
		10'd 82: lut_data <= {8'h78 , 24'h581003};
		10'd 83: lut_data <= {8'h78 , 24'h581109};
		10'd 84: lut_data <= {8'h78 , 24'h581207};
		10'd 85: lut_data <= {8'h78 , 24'h581303};
		10'd 86: lut_data <= {8'h78 , 24'h581400};
		10'd 87: lut_data <= {8'h78 , 24'h581501};
		10'd 88: lut_data <= {8'h78 , 24'h581603};
		10'd 89: lut_data <= {8'h78 , 24'h581708};
		10'd 90: lut_data <= {8'h78 , 24'h58180d};
		10'd 91: lut_data <= {8'h78 , 24'h581908};
		10'd 92: lut_data <= {8'h78 , 24'h581a05};
		10'd 93: lut_data <= {8'h78 , 24'h581b06};
		10'd 94: lut_data <= {8'h78 , 24'h581c08};
		10'd 95: lut_data <= {8'h78 , 24'h581d0e};
		10'd 96: lut_data <= {8'h78 , 24'h581e29};
		10'd 97: lut_data <= {8'h78 , 24'h581f17};
		10'd 98: lut_data <= {8'h78 , 24'h582011};
		10'd 99: lut_data <= {8'h78 , 24'h582111};
		10'd100: lut_data <= {8'h78 , 24'h582215};
		10'd101: lut_data <= {8'h78 , 24'h582328};
		10'd102: lut_data <= {8'h78 , 24'h582446};
		10'd103: lut_data <= {8'h78 , 24'h582526};
		10'd104: lut_data <= {8'h78 , 24'h582608};
		10'd105: lut_data <= {8'h78 , 24'h582726};
		10'd106: lut_data <= {8'h78 , 24'h582864};
		10'd107: lut_data <= {8'h78 , 24'h582926};
		10'd108: lut_data <= {8'h78 , 24'h582a24};
		10'd109: lut_data <= {8'h78 , 24'h582b22};
		10'd110: lut_data <= {8'h78 , 24'h582c24};
		10'd111: lut_data <= {8'h78 , 24'h582d24};
		10'd112: lut_data <= {8'h78 , 24'h582e06};
		10'd113: lut_data <= {8'h78 , 24'h582f22};
		10'd114: lut_data <= {8'h78 , 24'h583040};
		10'd115: lut_data <= {8'h78 , 24'h583142};
		10'd116: lut_data <= {8'h78 , 24'h583224};
		10'd117: lut_data <= {8'h78 , 24'h583326};
		10'd118: lut_data <= {8'h78 , 24'h583424};
		10'd119: lut_data <= {8'h78 , 24'h583522};
		10'd120: lut_data <= {8'h78 , 24'h583622};
		10'd121: lut_data <= {8'h78 , 24'h583726};
		10'd122: lut_data <= {8'h78 , 24'h583844};
		10'd123: lut_data <= {8'h78 , 24'h583924};
		10'd124: lut_data <= {8'h78 , 24'h583a26};
		10'd125: lut_data <= {8'h78 , 24'h583b28};
		10'd126: lut_data <= {8'h78 , 24'h583c42};
		10'd127: lut_data <= {8'h78 , 24'h583dce};// lenc BR offset // AWB   自动白平衡
		10'd128: lut_data <= {8'h78 , 24'h5180ff};// AWB B block
		10'd129: lut_data <= {8'h78 , 24'h5181f2};// AWB control 
		10'd130: lut_data <= {8'h78 , 24'h518200};// [7:4] max local counter, [3:0] max fast counter
		10'd131: lut_data <= {8'h78 , 24'h518314};// AWB advanced 
		10'd132: lut_data <= {8'h78 , 24'h518425};
		10'd133: lut_data <= {8'h78 , 24'h518524};
		10'd134: lut_data <= {8'h78 , 24'h518609};
		10'd135: lut_data <= {8'h78 , 24'h518709};
		10'd136: lut_data <= {8'h78 , 24'h518809};
		10'd137: lut_data <= {8'h78 , 24'h518975};
		10'd138: lut_data <= {8'h78 , 24'h518a54};
		10'd139: lut_data <= {8'h78 , 24'h518be0};
		10'd140: lut_data <= {8'h78 , 24'h518cb2};
		10'd141: lut_data <= {8'h78 , 24'h518d42};
		10'd142: lut_data <= {8'h78 , 24'h518e3d};
		10'd143: lut_data <= {8'h78 , 24'h518f56};
		10'd144: lut_data <= {8'h78 , 24'h519046};
		10'd145: lut_data <= {8'h78 , 24'h5191f8};// AWB top limit
		10'd146: lut_data <= {8'h78 , 24'h519204};// AWB bottom limit
		10'd147: lut_data <= {8'h78 , 24'h519370};// red limit
		10'd148: lut_data <= {8'h78 , 24'h5194f0};// green limit
		10'd149: lut_data <= {8'h78 , 24'h5195f0};// blue limit
		10'd150: lut_data <= {8'h78 , 24'h519603};// AWB control
		10'd151: lut_data <= {8'h78 , 24'h519701};// local limit 
		10'd152: lut_data <= {8'h78 , 24'h519804};
		10'd153: lut_data <= {8'h78 , 24'h519912};
		10'd154: lut_data <= {8'h78 , 24'h519a04};
		10'd155: lut_data <= {8'h78 , 24'h519b00};
		10'd156: lut_data <= {8'h78 , 24'h519c06};
		10'd157: lut_data <= {8'h78 , 24'h519d82};
		10'd158: lut_data <= {8'h78 , 24'h519e38};// AWB control // Gamma    伽玛曲线
		10'd159: lut_data <= {8'h78 , 24'h548001};// Gamma bias plus on, bit[0] 
		10'd160: lut_data <= {8'h78 , 24'h548108};
		10'd161: lut_data <= {8'h78 , 24'h548214};
		10'd162: lut_data <= {8'h78 , 24'h548328};
		10'd163: lut_data <= {8'h78 , 24'h548451};
		10'd164: lut_data <= {8'h78 , 24'h548565};
		10'd165: lut_data <= {8'h78 , 24'h548671};
		10'd166: lut_data <= {8'h78 , 24'h54877d};
		10'd167: lut_data <= {8'h78 , 24'h548887};
		10'd168: lut_data <= {8'h78 , 24'h548991};
		10'd169: lut_data <= {8'h78 , 24'h548a9a};
		10'd170: lut_data <= {8'h78 , 24'h548baa};
		10'd171: lut_data <= {8'h78 , 24'h548cb8};
		10'd172: lut_data <= {8'h78 , 24'h548dcd};
		10'd173: lut_data <= {8'h78 , 24'h548edd};
		10'd174: lut_data <= {8'h78 , 24'h548fea};
		10'd175: lut_data <= {8'h78 , 24'h54901d};// color matrix   色彩矩阵
		10'd176: lut_data <= {8'h78 , 24'h53811e};// CMX1 for Y
		10'd177: lut_data <= {8'h78 , 24'h53825b};// CMX2 for Y
		10'd178: lut_data <= {8'h78 , 24'h538308};// CMX3 for Y
		10'd179: lut_data <= {8'h78 , 24'h53840a};// CMX4 for U
		10'd180: lut_data <= {8'h78 , 24'h53857e};// CMX5 for U
		10'd181: lut_data <= {8'h78 , 24'h538688};// CMX6 for U
		10'd182: lut_data <= {8'h78 , 24'h53877c};// CMX7 for V
		10'd183: lut_data <= {8'h78 , 24'h53886c};// CMX8 for V
		10'd184: lut_data <= {8'h78 , 24'h538910};// CMX9 for V
		10'd185: lut_data <= {8'h78 , 24'h538a01};// sign[9]
		10'd186: lut_data <= {8'h78 , 24'h538b98}; // sign[8:1] // UV adjust   UV色彩饱和度调整
		10'd187: lut_data <= {8'h78 , 24'h558006};// saturation on, bit[1]
		10'd188: lut_data <= {8'h78 , 24'h558340};
		10'd189: lut_data <= {8'h78 , 24'h558410};
		10'd190: lut_data <= {8'h78 , 24'h558910};
		10'd191: lut_data <= {8'h78 , 24'h558a00};
		10'd192: lut_data <= {8'h78 , 24'h558bf8};
		10'd193: lut_data <= {8'h78 , 24'h501d40};// enable manual offset of contrast// CIP  锐化和降噪 
		10'd194: lut_data <= {8'h78 , 24'h530008};// CIP sharpen MT threshold 1
		10'd195: lut_data <= {8'h78 , 24'h530130};// CIP sharpen MT threshold 2
		10'd196: lut_data <= {8'h78 , 24'h530210};// CIP sharpen MT offset 1
		10'd197: lut_data <= {8'h78 , 24'h530300};// CIP sharpen MT offset 2
		10'd198: lut_data <= {8'h78 , 24'h530408};// CIP DNS threshold 1
		10'd199: lut_data <= {8'h78 , 24'h530530};// CIP DNS threshold 2
		10'd200: lut_data <= {8'h78 , 24'h530608};// CIP DNS offset 1
		10'd201: lut_data <= {8'h78 , 24'h530716};// CIP DNS offset 2 
		10'd202: lut_data <= {8'h78 , 24'h530908};// CIP sharpen TH threshold 1
		10'd203: lut_data <= {8'h78 , 24'h530a30};// CIP sharpen TH threshold 2
		10'd204: lut_data <= {8'h78 , 24'h530b04};// CIP sharpen TH offset 1
		10'd205: lut_data <= {8'h78 , 24'h530c06};// CIP sharpen TH offset 2
		10'd206: lut_data <= {8'h78 , 24'h502500};
		10'd207: lut_data <= {8'h78 , 24'h300802}; // wake up from standby, bit[6]
		10'd208: lut_data <= {8'h78 , 24'h303511};// PLL
		10'd209: lut_data <= {8'h78 , 24'h303669};// PLL
		10'd210: lut_data <= {8'h78 , 24'h3c0708};// light meter 1 threshold [7:0]
		10'd211: lut_data <= {8'h78 , 24'h382041};// Sensor flip off, ISP flip on
		10'd212: lut_data <= {8'h78 , 24'h382101};// Sensor mirror on, ISP mirror on, H binning on
		10'd213: lut_data <= {8'h78 , 24'h381431};// X INC 
		10'd214: lut_data <= {8'h78 , 24'h381531};// Y INC
		10'd215: lut_data <= {8'h78 , 24'h380000};// HS: X address start high byte
		10'd216: lut_data <= {8'h78 , 24'h380100};// HS: X address start low byte
		10'd217: lut_data <= {8'h78 , 24'h380200};// VS: Y address start high byte
		10'd218: lut_data <= {8'h78 , 24'h380304};// VS: Y address start high byte 
		10'd219: lut_data <= {8'h78 , 24'h38040a};// HW (HE)         
		10'd220: lut_data <= {8'h78 , 24'h38053f};// HW (HE)
		10'd221: lut_data <= {8'h78 , 24'h380607};// VH (VE)         
		10'd222: lut_data <= {8'h78 , 24'h38079b};// VH (VE)      
		10'd223: lut_data <= {8'h78 , 24'h380803};// DVPHO  
		10'd224: lut_data <= {8'h78 , 24'h380920};// DVPHO
		10'd225: lut_data <= {8'h78 , 24'h380a02};// DVPVO
		10'd226: lut_data <= {8'h78 , 24'h380b58};// DVPVO
		10'd227: lut_data <= {8'h78 , 24'h380c07};// HTS            //Total horizontal size 800
		10'd228: lut_data <= {8'h78 , 24'h380d68};// HTS
		10'd229: lut_data <= {8'h78 , 24'h380e03};// VTS            //total vertical size 500
		10'd230: lut_data <= {8'h78 , 24'h380fd8};// VTS 
		10'd231: lut_data <= {8'h78 , 24'h381306};// Timing Voffset 
		10'd232: lut_data <= {8'h78 , 24'h361800};
		10'd233: lut_data <= {8'h78 , 24'h361229};
		10'd234: lut_data <= {8'h78 , 24'h370952};
		10'd235: lut_data <= {8'h78 , 24'h370c03}; 
		10'd236: lut_data <= {8'h78 , 24'h3a0217};// 60Hz max exposure, night mode 5fps
		10'd237: lut_data <= {8'h78 , 24'h3a0310};// 60Hz max exposure // banding filters are calculated automatically in camera driver
		10'd238: lut_data <= {8'h78 , 24'h3a1417};// 50Hz max exposure, night mode 5fps
		10'd239: lut_data <= {8'h78 , 24'h3a1510};// 50Hz max exposure     
		10'd240: lut_data <= {8'h78 , 24'h400402};// BLC 2 lines 
		10'd241: lut_data <= {8'h78 , 24'h30021c};// reset JFIFO, SFIFO, JPEG
		10'd242: lut_data <= {8'h78 , 24'h3006c3};// disable clock of JPEG2x, JPEG
		10'd243: lut_data <= {8'h78 , 24'h471303};// JPEG mode 3
		10'd244: lut_data <= {8'h78 , 24'h440704};// Quantization scale 
		10'd245: lut_data <= {8'h78 , 24'h460b35};
		10'd246: lut_data <= {8'h78 , 24'h460c22};
		10'd247: lut_data <= {8'h78 , 24'h483722}; // DVP CLK divider
		10'd248: lut_data <= {8'h78 , 24'h382402}; // DVP CLK divider 
		10'd249: lut_data <= {8'h78 , 24'h5001a3}; // SDE on, scale on, UV average off, color matrix on, AWB on
		10'd250: lut_data <= {8'h78 , 24'h350300}; // AEC/AGC on 
		10'd251: lut_data <= {8'h78 , 24'h303521};// PLL     input clock =24Mhz, PCLK =84Mhz
		10'd252: lut_data <= {8'h78 , 24'h303669};// PLL
		10'd253: lut_data <= {8'h78 , 24'h3c0707}; // lightmeter 1 threshold[7:0]
		10'd254: lut_data <= {8'h78 , 24'h382047}; // flip
		10'd255: lut_data <= {8'h78 , 24'h382101}; // mirror
		10'd256: lut_data <= {8'h78 , 24'h381431}; // timing X inc
		10'd257: lut_data <= {8'h78 , 24'h381531}; // timing Y inc
		10'd258: lut_data <= {8'h78 , 24'h380000}; // HS
		10'd259: lut_data <= {8'h78 , 24'h380100}; // HS
		10'd260: lut_data <= {8'h78 , 24'h380200}; // VS
		10'd261: lut_data <= {8'h78 , 24'h380304}; // VS
		10'd262: lut_data <= {8'h78 , 24'h38040a}; // HW (HE)
		10'd263: lut_data <= {8'h78 , 24'h38053f}; // HW (HE)
		10'd264: lut_data <= {8'h78 , 24'h380607}; // VH (VE)
		10'd265: lut_data <= {8'h78 , 24'h38079f}; // VH (VE)
		10'd266: lut_data <= {8'h78 , 24'h380804}; // DVPHO     (1280)->1024
		10'd267: lut_data <= {8'h78 , 24'h380900}; // DVPHO     (1280)->1024
		10'd268: lut_data <= {8'h78 , 24'h380a03}; // DVPVO     (720)->
		10'd269: lut_data <= {8'h78 , 24'h380b00}; // DVPVO     (720)->
		10'd270: lut_data <= {8'h78 , 24'h380c07}; // HTS
		10'd271: lut_data <= {8'h78 , 24'h380d68}; // HTS
		10'd272: lut_data <= {8'h78 , 24'h380e03}; // VTS
		10'd273: lut_data <= {8'h78 , 24'h380fd8}; // VTS
		10'd274: lut_data <= {8'h78 , 24'h381304}; // timing V offset
		10'd275: lut_data <= {8'h78 , 24'h361800};
		10'd276: lut_data <= {8'h78 , 24'h361229};
		10'd277: lut_data <= {8'h78 , 24'h370952};
		10'd278: lut_data <= {8'h78 , 24'h370c03};
		10'd279: lut_data <= {8'h78 , 24'h3a0202}; // 60Hz max exposure
		10'd280: lut_data <= {8'h78 , 24'h3a03e0}; // 60Hz max exposure
		10'd281: lut_data <= {8'h78 , 24'h3a0800}; // B50 step
		10'd282: lut_data <= {8'h78 , 24'h3a096f}; // B50 step
		10'd283: lut_data <= {8'h78 , 24'h3a0a00}; // B60 step
		10'd284: lut_data <= {8'h78 , 24'h3a0b5c}; // B60 step
		10'd285: lut_data <= {8'h78 , 24'h3a0e06}; // 50Hz max band
		10'd286: lut_data <= {8'h78 , 24'h3a0d08}; // 60Hz max band
		10'd287: lut_data <= {8'h78 , 24'h3a1402}; // 50Hz max exposure
		10'd288: lut_data <= {8'h78 , 24'h3a15e0}; // 50Hz max exposure
		10'd289: lut_data <= {8'h78 , 24'h400402}; // BLC line number
		10'd290: lut_data <= {8'h78 , 24'h30021c}; // reset JFIFO, SFIFO, JPG
		10'd291: lut_data <= {8'h78 , 24'h3006c3}; // disable clock of JPEG2x, JPEG
		10'd292: lut_data <= {8'h78 , 24'h471303}; // JPEG mode 3
		10'd293: lut_data <= {8'h78 , 24'h440704}; // Quantization sacle
		10'd294: lut_data <= {8'h78 , 24'h460b37};
		10'd295: lut_data <= {8'h78 , 24'h460c20};
		10'd296: lut_data <= {8'h78 , 24'h483716}; // MIPI global timing
		10'd297: lut_data <= {8'h78 , 24'h382404}; // PCLK manual divider
		10'd298: lut_data <= {8'h78 , 24'h350300}; // AEC/AGC on 
		10'd299: lut_data <= {8'h78 , 24'h301602}; //Strobe output enable
		10'd300: lut_data <= {8'h78 , 24'h3b070a}; //FREX strobe mode1	
		10'd301: lut_data <= {8'h78 , 24'h3b0083}; //STROBE CTRL: strobe request ON, Strobe mode: LED3 
		10'd302: lut_data <= {8'h78 , 24'h3b0000}; //STROBE CTRL: strobe request OFF 
		default:lut_data <= {8'hff,16'hffff,8'hff};
	endcase
end


endmodule 