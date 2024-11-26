# 0 "/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c"
# 1 "/home/tibrahimovic/projects/wireguard-fpga/3.build//"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c"
# 18 "/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c"
# 1 "/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry.h" 1
# 389 "/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry.h"
  typedef enum {Ident_1, Ident_2, Ident_3, Ident_4, Ident_5}
                Enumeration;




# 1 "/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/uart.h" 1



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
# 5 "/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/uart.h" 2




# 8 "/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/uart.h"
void uart_send_char (char c);
void uart_send_hex (unsigned int val, int digits);
void uart_send (const char *s);
void uart_recv (char *s);
# 396 "/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry.h" 2
# 1 "/opt/riscv/lib/gcc/riscv64-unknown-elf/14.2.0/include/stdarg.h" 1 3 4
# 40 "/opt/riscv/lib/gcc/riscv64-unknown-elf/14.2.0/include/stdarg.h" 3 4

# 40 "/opt/riscv/lib/gcc/riscv64-unknown-elf/14.2.0/include/stdarg.h" 3 4
typedef __builtin_va_list __gnuc_va_list;
# 103 "/opt/riscv/lib/gcc/riscv64-unknown-elf/14.2.0/include/stdarg.h" 3 4
typedef __gnuc_va_list va_list;
# 397 "/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry.h" 2
# 405 "/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry.h"

# 405 "/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry.h"
typedef int One_Thirty;
typedef int One_Fifty;
typedef char Capital_Letter;
typedef int Boolean;
typedef char Str_30 [31];
typedef int Arr_1_Dim [50];
typedef int Arr_2_Dim [50] [50];

typedef struct record
    {
    struct record *Ptr_Comp;
    Enumeration Discr;
    union {
          struct {
                  Enumeration Enum_Comp;
                  int Int_Comp;
                  char Str_Comp [31];
                  } var_1;
          struct {
                  Enumeration E_Comp_2;
                  char Str_2_Comp [31];
                  } var_2;
          struct {
                  char Ch_1_Comp;
                  char Ch_2_Comp;
                  } var_3;
          } variant;
      } Rec_Type, *Rec_Pointer;
# 19 "/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c" 2
# 1 "/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/soc.h" 1




# 1 "/opt/riscv/lib/gcc/riscv64-unknown-elf/14.2.0/include/stddef.h" 1 3 4
# 145 "/opt/riscv/lib/gcc/riscv64-unknown-elf/14.2.0/include/stddef.h" 3 4

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
# 20 "/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c" 2







extern int Int_Glob;
extern char Ch_1_Glob;


Proc_6 (Enum_Val_Par, Enum_Ref_Par)




Enumeration Enum_Val_Par;
Enumeration *Enum_Ref_Par;
{
  *Enum_Ref_Par = Enum_Val_Par;
  if (! Func_3 (Enum_Val_Par))

    *Enum_Ref_Par = Ident_4;
  switch (Enum_Val_Par)
  {
    case Ident_1:
      *Enum_Ref_Par = Ident_1;
      break;
    case Ident_2:
      if (Int_Glob > 100)

      *Enum_Ref_Par = Ident_1;
      else *Enum_Ref_Par = Ident_4;
      break;
    case Ident_3:
      *Enum_Ref_Par = Ident_2;
      break;
    case Ident_4: break;
    case Ident_5:
      *Enum_Ref_Par = Ident_3;
      break;
  }
}


Proc_7 (Int_1_Par_Val, Int_2_Par_Val, Int_Par_Ref)
# 74 "/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c"
One_Fifty Int_1_Par_Val;
One_Fifty Int_2_Par_Val;
One_Fifty *Int_Par_Ref;
{
  One_Fifty Int_Loc;

  Int_Loc = Int_1_Par_Val + 2;
  *Int_Par_Ref = Int_2_Par_Val + Int_Loc;
}


Proc_8 (Arr_1_Par_Ref, Arr_2_Par_Ref, Int_1_Par_Val, Int_2_Par_Val)




Arr_1_Dim Arr_1_Par_Ref;
Arr_2_Dim Arr_2_Par_Ref;
int Int_1_Par_Val;
int Int_2_Par_Val;
{
  One_Fifty Int_Index;
  One_Fifty Int_Loc;

  Int_Loc = Int_1_Par_Val + 5;
  Arr_1_Par_Ref [Int_Loc] = Int_2_Par_Val;
  Arr_1_Par_Ref [Int_Loc+1] = Arr_1_Par_Ref [Int_Loc];
  Arr_1_Par_Ref [Int_Loc+30] = Int_Loc;
  for (Int_Index = Int_Loc; Int_Index <= Int_Loc+1; ++Int_Index)
    Arr_2_Par_Ref [Int_Loc] [Int_Index] = Int_Loc;
  Arr_2_Par_Ref [Int_Loc] [Int_Loc-1] += 1;
  Arr_2_Par_Ref [Int_Loc+20] [Int_Loc] = Arr_1_Par_Ref [Int_Loc];
  Int_Glob = 5;
}


Enumeration Func_1 (Ch_1_Par_Val, Ch_2_Par_Val)






Capital_Letter Ch_1_Par_Val;
Capital_Letter Ch_2_Par_Val;
{
  Capital_Letter Ch_1_Loc;
  Capital_Letter Ch_2_Loc;

  Ch_1_Loc = Ch_1_Par_Val;
  Ch_2_Loc = Ch_1_Loc;
  if (Ch_2_Loc != Ch_2_Par_Val)

    return (Ident_1);
  else
  {
    Ch_1_Glob = Ch_1_Loc;
    return (Ident_2);
   }
}


Boolean Func_2 (Str_1_Par_Ref, Str_2_Par_Ref)





Str_30 Str_1_Par_Ref;
Str_30 Str_2_Par_Ref;
{
  One_Thirty Int_Loc;
      Capital_Letter Ch_Loc;

  Int_Loc = 2;
  while (Int_Loc <= 2)
    if (Func_1 (Str_1_Par_Ref[Int_Loc],
                Str_2_Par_Ref[Int_Loc+1]) == Ident_1)

    {
      Ch_Loc = 'A';
      Int_Loc += 1;
    }
  if (Ch_Loc >= 'W' && Ch_Loc < 'Z')

    Int_Loc = 7;
  if (Ch_Loc == 'R')

    return (1);
  else
  {
    if (strcmp (Str_1_Par_Ref, Str_2_Par_Ref) > 0)

    {
      Int_Loc += 7;
      Int_Glob = Int_Loc;
      return (1);
    }
    else
      return (0);
  }
}


Boolean Func_3 (Enum_Par_Val)



Enumeration Enum_Par_Val;
{
  Enumeration Enum_Loc;

  Enum_Loc = Enum_Par_Val;
  if (Enum_Loc == Ident_3)

    return (1);
  else
    return (0);
}
