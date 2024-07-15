#ifndef SOC_H
#define SOC_H

#include <stdint.h>
#include <stddef.h>

//-----------------------------------------------------------------------
// Base addreses
//-----------------------------------------------------------------------
#define DMEM_BASE_ADDRESS  (volatile uint32_t *) 0x10000000
#define CSR_BASE_ADDRESS                         0x20000000
#define SDRAM_BASE_ADDRESS (volatile uint32_t *) 0x40000000

// SDRAM regions used to store ADC1 and 2 samples
// Total SDRAM capacity is 8MB
#define SDRAM_ADC1_ADDRESS (volatile uint32_t *) 0x40000000 // lower 4MB
#define SDRAM_ADC2_ADDRESS (volatile uint32_t *) 0x40400000 // upper 4MB 

//-----------------------------------------------------------------------
// Standard functions
//-----------------------------------------------------------------------
void *memcpy (void *dest, void *src, uint32_t n);
int   strcmp (const char *s1, const char *s2);

//-----------------------------------------------------------------------
// Custom functions
//-----------------------------------------------------------------------
uint32_t mul3 (uint32_t i);

//-----------------------------------------------------------------------
// CSR Resources
//-----------------------------------------------------------------------

//--------------UART_TX
typedef union {
   uint32_t all;                //[31:0]
                           
   struct {                
      uint32_t data       : 8;  //[ 7:0] 
      uint32_t rsvd_8_30  : 23; //[30:8] 
      uint32_t busy       : 1;  //[31] 
   } fld;
} uart_tx_t;

#define UART_TX_BUSY  0x80000000

//--------------UART_RX
typedef union {
   uint32_t all;                //[31:0]

   struct {
      uint32_t data       :  8; //[ 7:0] 
      uint32_t rsvd_8_29  : 22; //[29:8] 
      uint32_t oflow      :  1; //[30] 
      uint32_t valid      :  1; //[31] 
   } fld;                  

   // if (!uart_rx.fld.valid) return;
   //    lui       a5,0x10000
   //    mv        a5,a5
   //    bgez      a4,1d4 <main+0x6c>
   // if (uart_rx.fld.oflow) {
   //    lui       a3,0x40000
   //    and       a3,a4,a3
   //    beqz      a3,1e0 <main+0x78>

  /*
   struct {
      uint8_t data;       //[ 7:0] 
      uint8_t rsvd_1;     //[15:8] 
      uint8_t rsvd_2;     //[23:16] 
      uint8_t rsvd_3 : 6; //[29:24] 
      uint8_t oflow  : 1; //[30] 
      uint8_t valid  : 1; //[31] 
   } fld;                  

   if (!uart_rx.fld.valid) return;
       lui      a5,0x10000
       srli     a3,a4,0x18
       mv       a5,a5
       bgez     a4,1d4 <main+0x6c>

   if (uart_rx.fld.oflow) {
       andi     a3,a3,64
       beqz     a3,1e0 <main+0x78>
  */

} uart_rx_t;               

#define UART_RX_VALID  0x80000000
#define UART_RX_OFLOW  0x40000000
#define UART_RX_DATA   0x000000FF
                           
//--------------ADC_TX
typedef union {            
   uint32_t all;                //[31:0]
                           
   struct {                
      uint32_t time_us    : 15; //[14:0] 
      uint32_t test       :  1; //[15] 
      uint32_t rsvd_16_30 : 15; //[30:16] 
      uint32_t busy       :  1; //[31] 
   } fld;
} adc_tx_t;

#define ADC_TX_BUSY  0x80000000

//--------------ADC_RX
/* OLD
typedef union {
   uint32_t all;                //[31:0]

   struct {
      uint32_t data       : 24; //[23:0] 
      uint32_t rsvd_24_28 :  5; //[28:24] 
      uint32_t last       :  1; //[29] 
      uint32_t oflow      :  1; //[30] 
      uint32_t valid      :  1; //[31] 
   } fld;                  
} adc_rx_t;                
                           
#define ADC_RX_VALID  0x80000000
#define ADC_RX_OFLOW  0x40000000
#define ADC_RX_DATA   0x00FFFFFF
*/

typedef union {
   uint32_t all;                //[31:0]

   struct {
      uint32_t sample_cnt : 17; //[16:0] 
      uint32_t rsvd_31_18 : 15; //[31:17] 
   } fld;                  
} adc_rx_t;                
                           
#define ADC_RX_SAMPLE_CNT 0x0001FFFF


//--------------GPO
typedef union {            
   uint32_t all;                //[31:0]
                           
   struct {                
      uint32_t led_off    :  8; //[7:0] Only bit[1]=LED4 and bit[0]=LED3 are used
      uint32_t rsvd_8_31  : 24; //[31:8] 
   } fld;
} gpo_t;

//--------------GPI
typedef union {            
   uint32_t all;                //[31:0]
                           
   struct {                
      uint32_t key_on     :  8; //[7:0] Only bit[0] is used
      uint32_t rsvd_8_31  : 24; //[31:8] 
   } fld;
} gpi_t;

//--------------DAC_TX
typedef union {            
   uint32_t all;                //[31:0]
                           
   struct {                
      uint32_t sin_tune   : 15; //[14:0] 
      uint32_t rsvd_15_15 :  1; //[15:15]
      uint32_t hann_step  : 10; //[25:16] 
      uint32_t rsvd_26_30 :  5; //[30:26] 
      uint32_t busy       :  1; //[31] 
   } fld;
} dac_tx_t;

#define DAC_TX_BUSY  0x80000000


//--------------MISC
typedef union {            
   uint32_t all;                //[31:0]
                           
   struct {                
      uint32_t error      :  8; //[7:0] Only bit[3:0] are used
      uint32_t rsvd_8_31  : 24; //[31:8] 
   } fld;
} misc_t;


//==============Complete CSR
typedef struct {     // Offset:
  uart_tx_t uart_tx; //  0x0 * 4  0x2000_0000
  uart_rx_t uart_rx; //  0x1 * 4  0x2000_0004

  adc_tx_t  adc1_tx; //  0x2 * 4  0x2000_0008
  adc_rx_t  adc1_rx; //  0x3 * 4  0x2000_000C

  adc_tx_t  adc2_tx; //  0x4 * 4  0x2000_0010
  adc_rx_t  adc2_rx; //  0x5 * 4  0x2000_0014

  gpo_t     gpo;     //  0x6 * 4  0x2000_0018
  gpi_t     gpi;     //  0x7 * 4  0x2000_001C
  
  dac_tx_t  dac1_tx; //  0x8 * 4  0x2000_0020
  dac_tx_t  dac2_tx; //  0x9 * 4  0x2000_0024

  misc_t    misc;    //  0xA * 4  0x2000_0028
} csr_t;

#define CSR ((volatile csr_t *) CSR_BASE_ADDRESS)


//-----------------------------------------------------------------------
// Parser of Commands that arrive from UART
//-----------------------------------------------------------------------

#define CRX_ASC_SIZE 8 // command elements cannot have more than 8 ASCII
                       // characters (representing one decimal number).
                       // Max decimal value of an element is 99_999_999
typedef struct {
   uint32_t id   :8;   // [7:0] 1st and only mandatory element: Command ID
   uint32_t anum :8;   // [15:8] number of active command elements. Up to 4
   uint32_t rsvd :16;  // [31:16]
 //--------------------//
   uint32_t arg1;      //   2nd element (optional): Command argument1
   uint32_t arg2;      //   3rd element (optional): Command argument2
   uint32_t arg3;      //   4th element (optional): Command argument3
} cmd_t;


typedef struct {
   uint32_t active :8; // [7:0]  flag=1 when new cmd is being assembled
   uint32_t rdy    :8; // [15:8] flag=1 when new cmd is ready
   uint32_t rsvd   :16;
} cmd_flag_t;


//-----------------------------------------------------------------------
// Support of rudimentary multi-tasking, in the absence of a full RTOS
//-----------------------------------------------------------------------

typedef union {
   uint32_t all;                  //[31:0]
                           
   //struct {                
   //   uint32_t adc1_started :  1; //[0]
   //   uint32_t adc2_started :  1; //[1]
   //   uint32_t adc1_uarting :  1; //[2]
   //   uint32_t adc1_uarting :  1; //[3]
   // 
   //   uint32_t rsvd_4_31    : 28; //[31:4]
   //} fld;

   // since we don't need too many flags, it's faster for
   // CPU to extract and operate them when alligned to byte
   // as opposed to bit boundaries
   struct {
     uint16_t adc_started;  //[15:0]
     uint16_t adc_uarting;  //[31:16]
   } hal;

   struct {                
      uint8_t adc1_started; //[7:0]
      uint8_t adc2_started; //[15:8]
      uint8_t adc1_uarting; //[23:16]
      uint8_t adc2_uarting; //[31:24]
   } fld;

} task_t;


// for ease of access to individual bytes of a 32-bit word
typedef union {
   uint32_t all;       //[31:0]
                           
   struct {
      uint32_t b0 : 8; //[7:0]
      uint32_t b1 : 8; //[15:0]
      uint32_t b2 : 8; //[23:16]
      uint32_t b3 : 8; //[31:24]
   } fld;
} byte4_t;

#endif // SOC_H
