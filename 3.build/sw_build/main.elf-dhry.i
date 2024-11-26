# 0 "/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry.h"
# 1 "/home/tibrahimovic/projects/wireguard-fpga/3.build//"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry.h"
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
