
// --------------------------------------------------------------------------------------
// Head files
#include <windows.h>
#include <nkintr.h>
#include <pm.h>
#include "pmplatform.h"
#include <ceddk.h>
#include <S3c6410.h>
#include <bsp.h>
#include "iic.h"
#include "ov3640.h"

#include "Module.h"

//#include "camera_video.h"
unsigned char g_ucSlaveID;	// 3640:0x78

// --------------------------------------------------------------------------------------
// Macros Definitions
#define OV3640_ERROR     1
#define OV3640_DEBUG	 0		// billy::default:0 

#define OV3640_PID       0x56
#define OV3640_VER       0x40	//0x40

#define OV3640_PID_REG	 0x300A
#define OV3640_VER_REG   0x300B

#define OV3640_SLAVE_ID  0x78	//0x60
#define CAMERA_WRITE    (OV3640_SLAVE_ID | 0x0)
#define CAMERA_READ     (OV3640_SLAVE_ID | 0x1)

#define DEFAULT_MODULE_ITUXXX        CAM_ITU601
#define DEFAULT_MODULE_YUVORDER      CAM_ORDER_YCBYCR
#define DEFAULT_MODULE_HSIZE          2048 //2592//800		// 640
#define DEFAULT_MODULE_VSIZE         1536//1944 //600	// 480
#define DEFAULT_MODULE_HOFFSET       0//0   256:¼´source_H=1536 Õý³£ÏÔÊ¾
#define DEFAULT_MODULE_VOFFSET       0//0
#define DEFAULT_MODULE_UVOFFSET      CAM_UVOFFSET_0
#define DEFAULT_MODULE_CLOCK         18000000 //6000000//6000000	// 24000000
#define DEFAULT_MODULE_CODEC         CAM_CODEC_422
#define DEFAULT_MODULE_HIGHRST       0	// billy::default:1
#define DEFAULT_MODULE_INVPCLK       0	// billy::default:1
#define DEFAULT_MODULE_INVVSYNC      0	// billy::default:0
#define DEFAULT_MODULE_INVHREF       0	// billy::default:0

// --------------------------------------------------------------------------------------
// Variables
static MODULE_DESCRIPTOR             gModuleDesc;
static HANDLE		hI2C;   // I2C Bus Driver

// --------------------------------------------------------------------------------------
// Functions 
int  ModuleWriteBlock();
/*
DWORD HW_WriteRegisters(HANDLE hDevice, PUCHAR pBuff, DWORD nRegs);
DWORD HW_ReadRegisters(HANDLE hDevice, PUCHAR pBuff, PUCHAR pStartReg, DWORD nRegs);
*/
DWORD HW_WriteRegisters(PUCHAR pBuff, DWORD nRegs);
DWORD HW_ReadRegisters(PUCHAR pBuff, PUCHAR pStartReg, DWORD nRegs);

BOOL IICInit()
{
	DWORD   dwErr = ERROR_SUCCESS,bytes;
	UINT32  IICClock = 3000;
	UINT32  uiIICDelay;
	// Initialize IIC1
	hI2C = CreateFile(_T("IIC0:"), GENERIC_READ|GENERIC_WRITE,
						FILE_SHARE_READ|FILE_SHARE_WRITE, NULL, OPEN_EXISTING, 0, 0);
	if(INVALID_HANDLE_VALUE == hI2C)
	{
		dwErr = GetLastError();
		RETAILMSG(OV3640_ERROR, (_T("Error %d opening device iic0!\r\n"), dwErr));
		return FALSE;
	}
	if (!DeviceIoControl(hI2C,
                          IOCTL_IIC_SET_CLOCK, 
                          &IICClock, sizeof(UINT32), 
                          NULL, 0,
                          &bytes, NULL) ) 
	{
		dwErr = GetLastError();
		RETAILMSG(OV3640_ERROR,(TEXT("IOCTL_IIC_SET_CLOCK ERROR: %u \r\n"), dwErr));
		return FALSE;
	}       
	uiIICDelay = Clk_0;
	if ( !DeviceIoControl(hI2C,
                      IOCTL_IIC_SET_DELAY, 
                      &uiIICDelay, sizeof(UINT32), 
                      NULL, 0,
                      &bytes, NULL) )
    	{
        	dwErr = GetLastError();
        	RETAILMSG(OV3640_ERROR,(TEXT("IOCTL_IIC_SET_DELAY ERROR: %u \r\n"), dwErr));
        	return FALSE;
    	}

}

int ModuleInit()
{
	RETAILMSG(OV3640_DEBUG,(TEXT("ModuleInit++\r\n")));

	IICInit();
    
	g_ucSlaveID = OV3640_SLAVE_ID;
	gModuleDesc.Order422 = DEFAULT_MODULE_YUVORDER;
	gModuleDesc.ITUXXX = DEFAULT_MODULE_ITUXXX;
	gModuleDesc.SourceHSize = DEFAULT_MODULE_HSIZE;
	gModuleDesc.SourceVSize = DEFAULT_MODULE_VSIZE;
	gModuleDesc.SourceHOffset = DEFAULT_MODULE_HOFFSET;
	gModuleDesc.SourceVOffset = DEFAULT_MODULE_VOFFSET;
	gModuleDesc.UVOffset = DEFAULT_MODULE_UVOFFSET;
	gModuleDesc.Clock = DEFAULT_MODULE_CLOCK;
	gModuleDesc.Codec = DEFAULT_MODULE_CODEC;
	gModuleDesc.HighRst = DEFAULT_MODULE_HIGHRST;
	gModuleDesc.InvPCLK = DEFAULT_MODULE_INVPCLK;
	gModuleDesc.InvVSYNC = DEFAULT_MODULE_INVVSYNC;
	gModuleDesc.InvHREF = DEFAULT_MODULE_INVHREF;
    

	RETAILMSG(OV3640_DEBUG,(TEXT("ModuleInit--\r\n")));
	return TRUE;
}


void IICDeinit()
{
	CloseHandle(hI2C);
}

void ModuleDeinit()
{    
    CloseHandle(hI2C);
}

int  ModuleWriteBlock()
{
    int i;
    UCHAR BUF=0;
    UCHAR version[2];

	UCHAR tem[3];

//	UCHAR pidAddr,vidAddr;
	
    RETAILMSG(OV3640_DEBUG,(TEXT("ModuleWriteBlock++ \r\n")));

	RETAILMSG(1, (TEXT("%x,%x\r\n"),IOCTL_IIC_READ,IOCTL_IIC_WRITE));
	
		 // Read OV3640 PID
	version[0] = (OV3640_PID_REG & 0xff00)>>8;
	version[1] = OV3640_PID_REG & 0xff;
//	pidAddr = 0x0a;
	HW_ReadRegisters(&BUF, version, 2);
	Sleep(2);
	RETAILMSG(1, (TEXT("IIC read pid %x\r\n"),BUF));
	if (OV3640_PID == BUF)
		RETAILMSG(1,(TEXT("Read OV3640_PID: 0x%x successfully! \r\n"), BUF));
	else
		RETAILMSG(OV3640_ERROR,(TEXT("Read OV3640_PID: 0x%x failed! \r\n"), BUF));
	
	// Read OV3640 VID
	version[0] = (OV3640_VER_REG & 0xff00)>>8;
	version[1] = OV3640_VER_REG & 0xff;
//	vidAddr = 0x0b;
	HW_ReadRegisters(&BUF, version, 2);
	Sleep(2);
	RETAILMSG(1, (TEXT("IIC read vid %x\r\n"),BUF));
	if (OV3640_VER == BUF)
		RETAILMSG(1,(TEXT("Read OV3640_VER_REG: 0x%x successfully! \r\n"), BUF));
	else
		RETAILMSG(OV3640_ERROR,(TEXT("Read OV3640_VER_REG: 0x%x failed! \r\n"), BUF));
		
	
	HW_WriteRegisters(&OV3640_reg[0][0], 3);
	Sleep(10);	// delay 10ms

    for ( i=0;i < sensor_init_Num;i++)
    {
		HW_WriteRegisters(&sensor_init_data[i][0], 3);
		RETAILMSG(1, (TEXT(".")));

		//RETAILMSG(1,(TEXT(" {0x%x ,0x%02X ,0x%02X},  \r\n"), tem[0],tem[1],tem[2]));

    }
	RETAILMSG(1,(TEXT("sensor_init_Num   \r\n")));
                

	for ( i=0;i < sensor_720p_Num;i++)
	{
		HW_WriteRegisters(&sensor_720p[i][0], 3);
		RETAILMSG(1, (TEXT(".")));

		//RETAILMSG(1,(TEXT(" {0x%x ,0x%02X ,0x%02X},  \r\n"), tem[0],tem[1],tem[2]));

	}
	RETAILMSG(1,(TEXT("sensor_720p_Num  \r\n")));


	for ( i=0;i < sensor_svga_Num;i++)
	{
		HW_WriteRegisters(&sensor_svga[i][0], 3);
		RETAILMSG(1, (TEXT(".")));
		//RETAILMSG(1,(TEXT(" {0x%x ,0x%02X ,0x%02X},  \r\n"), tem[0],tem[1],tem[2]));

	}
	RETAILMSG(1,(TEXT("sensor_svga_Num  \r\n")));
	/*  ////add mao 20121225
	for(i=1; i<OV3640_REGS; i++)
	{
		HW_WriteRegisters(&OV3640_reg[i][0], 3);
		RETAILMSG(1, (TEXT(".")));
		Sleep(1);
		//	RETAILMSG(OV3640_DEBUG,(TEXT("HW_WriteRegisters: Reg[0x%x] = 0x%x, i = %d.\r\n"), OV3640_reg[i][0], OV3640_reg[i][1], i));
	}
	*/
	//    RETAILMSG(1, (_T("\npreview!\r\n")));
/*	
	// preview
	    for(i=0; i<OV3640_REGS_PREVIEW; i++)
	    {
	    	HW_WriteRegisters(&OV3640_reg_preview[i][0], 3);
	    }
*/
		
	// capture
	/* //add mao 20121225
	for(i=0; i<OV3640_REGS_CAPTURE; i++)
	{
		HW_WriteRegisters(&OV3640_reg_capture[i][0], 3);
		RETAILMSG(1, (TEXT(".")));
		Sleep(1);
	}
	*/

/*
	for(i=0; i<OV3640_REGS_PREVIEW; i++)
	    {
	    		HW_WriteRegisters(&OV3640_reg_preview[i][0], 3);
			RETAILMSG(1, (TEXT(".")));
			Sleep(1);		
	    }
*/

	version[0] = (0x3073 & 0xff00)>>8;
	version[1] = 0x3073 & 0xff;
	HW_ReadRegisters(&BUF, version, 2);
	Sleep(20);
	RETAILMSG(1, (TEXT("\r\nIIC read 0x3073 0x%x\r\n"),BUF));
	
  RETAILMSG(OV3640_DEBUG,(TEXT("ModuleWriteBloc-- \r\n")));
  return TRUE;
}

/*
DWORD
HW_WriteRegisters(HANDLE hDevice, 
    PUCHAR pBuff,   // Optional buffer
    DWORD nRegs     // number of registers
    )
{
    DWORD dwErr=0;
    DWORD bytes;
    IIC_IO_DESC IIC_Data;
    
    RETAILMSG(OV3640_DEBUG,(TEXT("HW_WriteRegisters++ \r\n")));    
    
    IIC_Data.SlaveAddress = g_ucSlaveID;	// CAMERA_WRITE;
    IIC_Data.Count    = nRegs;
    IIC_Data.Data = pBuff;
    
    // use iocontrol to write
    if ( !DeviceIoControl(hDevice,
                          IOCTL_IIC_WRITE, 
                          &IIC_Data, sizeof(IIC_IO_DESC), 
                          NULL, 0,
                          &bytes, NULL) ) 
    {
        dwErr = GetLastError();
        RETAILMSG(OV3640_ERROR,(TEXT("IOCTL_IIC_WRITE ERROR: %u \r\n"), dwErr));
    }   

    if ( dwErr ) {
        RETAILMSG(OV3640_ERROR, (TEXT("I2CWrite ERROR: %u \r\n"), dwErr));
    }            
    RETAILMSG(OV3640_DEBUG,(TEXT("HW_WriteRegisters-- \r\n")));    
	Sleep(1);
    return dwErr;
}

DWORD
HW_ReadRegisters(HANDLE hDevice, 
    PUCHAR pBuff,       // Optional buffer
    PUCHAR pStartReg,     // Start Register
    DWORD nRegs         // Number of Registers
    )
{
    DWORD dwErr=0;
    DWORD bytes;
    IIC_IO_DESC IIC_AddressData, IIC_Data;

	RETAILMSG(OV3640_DEBUG,(TEXT("HW_ReadRegisters++ \r\n"))); 
	
    IIC_AddressData.SlaveAddress = g_ucSlaveID;	// CAMERA_WRITE;
    IIC_AddressData.Data = pStartReg;
    IIC_AddressData.Count = nRegs;
    
    IIC_Data.SlaveAddress = (g_ucSlaveID | 0x1);	// CAMERA_READ;
    IIC_Data.Data = pBuff;
    IIC_Data.Count = 1;
    
    // use iocontrol to read    
    if ( !DeviceIoControl(hDevice,
                          IOCTL_IIC_READ, 
                          &IIC_AddressData, sizeof(IIC_IO_DESC), 
                          &IIC_Data, sizeof(IIC_IO_DESC),
                          &bytes, NULL) ) 
    {
        dwErr = GetLastError();
        RETAILMSG(OV3640_ERROR,(TEXT("IOCTL_IIC_WRITE ERROR: %u \r\n"), dwErr));
    }   

    
    if ( !dwErr ) {


    } else {        
        RETAILMSG(OV3640_ERROR,(TEXT("I2CRead ERROR: %u \r\n"), dwErr));
    }            

	RETAILMSG(OV3640_DEBUG,(TEXT("HW_ReadRegisters-- \r\n"))); 
	Sleep(1);
    return dwErr;
}
*/
DWORD
HW_WriteRegisters(
    PUCHAR pBuff,   // Optional buffer
    DWORD nRegs     // number of registers
    )
{
    DWORD dwErr=0;
    DWORD bytes;
    IIC_IO_DESC IIC_Data;
    
    RETAILMSG(0,(TEXT("HW_WriteRegisters++ \r\n")));    
    
    IIC_Data.SlaveAddress = CAMERA_WRITE;
    IIC_Data.Count    = nRegs;
    IIC_Data.Data = pBuff;
    
    // use iocontrol to write
    if ( !DeviceIoControl(hI2C,
                          IOCTL_IIC_WRITE, 
                          &IIC_Data, sizeof(IIC_IO_DESC), 
                          NULL, 0,
                          &bytes, NULL) ) 
    {
        dwErr = GetLastError();
        RETAILMSG(0,(TEXT("IOCTL_IIC_WRITE ERROR: %u \r\n"), dwErr));
    }   

    if ( dwErr ) {
        RETAILMSG(0, (TEXT("I2CWrite ERROR: %u \r\n"), dwErr));
    }            
    RETAILMSG(0,(TEXT("HW_WriteRegisters-- \r\n")));    

Sleep(2);
    return dwErr;
}

DWORD
HW_ReadRegisters(
    PUCHAR pBuff,       // Optional buffer
    PUCHAR pStartReg,     // Start Register
    DWORD nRegs         // Number of Registers
    )
{
    DWORD dwErr=0;
    DWORD bytes;
    IIC_IO_DESC IIC_AddressData, IIC_Data;

	RETAILMSG(0,(TEXT("HW_ReadRegisters++ \r\n"))); 
	
    IIC_AddressData.SlaveAddress = CAMERA_WRITE;
    IIC_AddressData.Data = pStartReg;
    IIC_AddressData.Count = 2;
    
    IIC_Data.SlaveAddress = CAMERA_READ;
    IIC_Data.Data = pBuff;
    IIC_Data.Count = 1;
    
    // use iocontrol to read    
    if ( !DeviceIoControl(hI2C,
                          IOCTL_IIC_READ, 
                          &IIC_AddressData, sizeof(IIC_IO_DESC), 
                          &IIC_Data, sizeof(IIC_IO_DESC),
                          &bytes, NULL) ) 
    {
        dwErr = GetLastError();
        RETAILMSG(0,(TEXT("IOCTL_IIC_WRITE ERROR: %u \r\n"), dwErr));
    }   

    
    if ( !dwErr ) {


    } else {        
        RETAILMSG(0,(TEXT("I2CRead ERROR: %u \r\n"), dwErr));
    }            

	RETAILMSG(0,(TEXT("HW_ReadRegisters-- \r\n"))); 

	Sleep(2);
    return dwErr;
}

// copy module data to output buffer
void ModuleGetFormat(MODULE_DESCRIPTOR &outModuleDesc)
{
    memcpy(&outModuleDesc, &gModuleDesc, sizeof(MODULE_DESCRIPTOR));
}

int     ModuleSetImageSize(int imageSize)
{

    return TRUE;
}

