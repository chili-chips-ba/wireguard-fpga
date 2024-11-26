# 0 "/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dac.c"
# 1 "/home/tibrahimovic/projects/wireguard-fpga/3.build//"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dac.c"
# 28 "/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dac.c"
# 1 "/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/soc.h" 1



# 1 "/opt/riscv/lib/gcc/riscv64-unknown-elf/14.2.0/include/stdint.h" 1 3 4
# 11 "/opt/riscv/lib/gcc/riscv64-unknown-elf/14.2.0/include/stdint.h" 3 4
# 1 "/opt/riscv/lib/gcc/riscv64-unknown-elf/14.2.0/include/stdint-gcc.h" 1 3 4
# 34 "/opt/riscv/lib/gcc/riscv64-unknown-elf/14.2.0/include/stdint-gcc.h" 3 4

# 34 "/opt/riscv/lib/gcc/riscv64-unknown-elf/14.2.0/include/stdint-gcc.h" 3 4
typedef signed char int8_t;


typedef short int int16_t;


typedef long int int32_t;


typedef long long int int64_t;


typedef unsigned char uint8_t;


typedef short unsigned int uint16_t;


typedef long unsigned int uint32_t;


typedef long long unsigned int uint64_t;




typedef signed char int_least8_t;
typedef short int int_least16_t;
typedef long int int_least32_t;
typedef long long int int_least64_t;
typedef unsigned char uint_least8_t;
typedef short unsigned int uint_least16_t;
typedef long unsigned int uint_least32_t;
typedef long long unsigned int uint_least64_t;



typedef int int_fast8_t;
typedef int int_fast16_t;
typedef int int_fast32_t;
typedef long long int int_fast64_t;
typedef unsigned int uint_fast8_t;
typedef unsigned int uint_fast16_t;
typedef unsigned int uint_fast32_t;
typedef long long unsigned int uint_fast64_t;




typedef int intptr_t;


typedef unsigned int uintptr_t;




typedef long long int intmax_t;
typedef long long unsigned int uintmax_t;
# 12 "/opt/riscv/lib/gcc/riscv64-unknown-elf/14.2.0/include/stdint.h" 2 3 4
# 5 "/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/soc.h" 2
# 1 "/opt/riscv/lib/gcc/riscv64-unknown-elf/14.2.0/include/stddef.h" 1 3 4
# 145 "/opt/riscv/lib/gcc/riscv64-unknown-elf/14.2.0/include/stddef.h" 3 4
typedef int ptrdiff_t;
# 214 "/opt/riscv/lib/gcc/riscv64-unknown-elf/14.2.0/include/stddef.h" 3 4
typedef unsigned int size_t;
# 329 "/opt/riscv/lib/gcc/riscv64-unknown-elf/14.2.0/include/stddef.h" 3 4
typedef int wchar_t;
# 425 "/opt/riscv/lib/gcc/riscv64-unknown-elf/14.2.0/include/stddef.h" 3 4
typedef struct {
  long long __max_align_ll __attribute__((__aligned__(__alignof__(long long))));
  long double __max_align_ld __attribute__((__aligned__(__alignof__(long double))));
# 436 "/opt/riscv/lib/gcc/riscv64-unknown-elf/14.2.0/include/stddef.h" 3 4
} max_align_t;
# 6 "/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/soc.h" 2
# 22 "/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/soc.h"

# 22 "/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/soc.h"
void *memcpy (void *dest, void *src, uint32_t n);
int strcmp (const char *s1, const char *s2);




uint32_t mul3 (uint32_t i);






typedef union {
   uint32_t all;

   struct {
      uint32_t data : 8;
      uint32_t rsvd_8_30 : 23;
      uint32_t busy : 1;
   } fld;
} uart_tx_t;




typedef union {
   uint32_t all;

   struct {
      uint32_t data : 8;
      uint32_t rsvd_8_29 : 22;
      uint32_t oflow : 1;
      uint32_t valid : 1;
   } fld;
# 88 "/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/soc.h"
} uart_rx_t;






typedef union {
   uint32_t all;

   struct {
      uint32_t time_us : 15;
      uint32_t test : 1;
      uint32_t rsvd_16_30 : 15;
      uint32_t busy : 1;
   } fld;
} adc_tx_t;
# 127 "/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/soc.h"
typedef union {
   uint32_t all;

   struct {
      uint32_t sample_cnt : 17;
      uint32_t rsvd_31_18 : 15;
   } fld;
} adc_rx_t;





typedef union {
   uint32_t all;

   struct {
      uint32_t led_off : 8;
      uint32_t rsvd_8_31 : 24;
   } fld;
} gpo_t;


typedef union {
   uint32_t all;

   struct {
      uint32_t key_on : 8;
      uint32_t rsvd_8_31 : 24;
   } fld;
} gpi_t;


typedef union {
   uint32_t all;

   struct {
      uint32_t sin_tune : 15;
      uint32_t rsvd_15_15 : 1;
      uint32_t hann_step : 10;
      uint32_t rsvd_26_30 : 5;
      uint32_t busy : 1;
   } fld;
} dac_tx_t;





typedef union {
   uint32_t all;

   struct {
      uint32_t error : 8;
      uint32_t rsvd_8_31 : 24;
   } fld;
} misc_t;



typedef struct {
  uart_tx_t uart_tx;
  uart_rx_t uart_rx;

  adc_tx_t adc1_tx;
  adc_rx_t adc1_rx;

  adc_tx_t adc2_tx;
  adc_rx_t adc2_rx;

  gpo_t gpo;
  gpi_t gpi;

  dac_tx_t dac1_tx;
  dac_tx_t dac2_tx;

  misc_t misc;
} csr_t;
# 216 "/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/soc.h"
typedef struct {
   uint32_t id :8;
   uint32_t anum :8;
   uint32_t rsvd :16;

   uint32_t arg1;
   uint32_t arg2;
   uint32_t arg3;
} cmd_t;


typedef struct {
   uint32_t active :8;
   uint32_t rdy :8;
   uint32_t rsvd :16;
} cmd_flag_t;






typedef union {
   uint32_t all;
# 253 "/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/soc.h"
   struct {
     uint16_t adc_started;
     uint16_t adc_uarting;
   } hal;

   struct {
      uint8_t adc1_started;
      uint8_t adc2_started;
      uint8_t adc1_uarting;
      uint8_t adc2_uarting;
   } fld;

} task_t;



typedef union {
   uint32_t all;

   struct {
      uint32_t b0 : 8;
      uint32_t b1 : 8;
      uint32_t b2 : 8;
      uint32_t b3 : 8;
   } fld;
} byte4_t;
# 29 "/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dac.c" 2
# 1 "/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dac.h" 1





void dac_start (volatile dac_tx_t *dac_ptr, uint16_t hann_step, uint16_t sin_tune);
# 30 "/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dac.c" 2
