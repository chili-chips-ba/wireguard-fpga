# 0 "/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c"
# 1 "/home/tibrahimovic/projects/wireguard-fpga/3.build//"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c"
# 18 "/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c"
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
# 19 "/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c" 2
# 27 "/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c"
Rec_Pointer Ptr_Glob,
                Next_Ptr_Glob;
int Int_Glob;
Boolean Bool_Glob;
char Ch_1_Glob,
                Ch_2_Glob;
int Arr_1_Glob [50];
int Arr_2_Glob [50] [50];


Enumeration Func_1 ();



        Boolean Reg = 0;
# 69 "/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c"
long Begin_Time,
                End_Time,
                User_Time;
float Microseconds,
                Dhrystones_Per_Second;



char* strcpy(char* dest, const char* src) {
    char* original_dest = dest;
    while ((*dest++ = *src++) != '\0');
    return original_dest;
}
# 92 "/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c"
main ()




{
        One_Fifty Int_1_Loc;
  One_Fifty Int_2_Loc;
        One_Fifty Int_3_Loc;
  char Ch_Index;
        Enumeration Enum_Loc;
        Str_30 Str_1_Loc;
        Str_30 Str_2_Loc;
  int Run_Index;
  int Number_Of_Runs;





  Rec_Type Next_glob;
  Rec_Type Glob;

  Rec_Pointer Next_Ptr_Glob = & Next_glob;
  Rec_Pointer Ptr_Glob = & Glob;

  Ptr_Glob->Ptr_Comp = Next_Ptr_Glob;
  Ptr_Glob->Discr = Ident_1;
  Ptr_Glob->variant.var_1.Enum_Comp = Ident_3;
  Ptr_Glob->variant.var_1.Int_Comp = 40;
  strcpy (Ptr_Glob->variant.var_1.Str_Comp,
          "DHRYSTONE PROGRAM, SOME STRING");
  strcpy (Str_1_Loc, "DHRYSTONE PROGRAM, 1'ST STRING");

  Arr_2_Glob [8][7] = 10;
# 158 "/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c"
  Number_Of_Runs = 10;
# 176 "/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c"
  uart_send("s");
  for (Run_Index = 1; Run_Index <= Number_Of_Runs; ++Run_Index)
  {

    Proc_5();
    Proc_4();

    Int_1_Loc = 2;
    Int_2_Loc = 3;
    strcpy (Str_2_Loc, "DHRYSTONE PROGRAM, 2'ND STRING");
    Enum_Loc = Ident_2;
    Bool_Glob = ! Func_2 (Str_1_Loc, Str_2_Loc);

    while (Int_1_Loc < Int_2_Loc)
    {
      Int_3_Loc = 5 * Int_1_Loc - Int_2_Loc;

      Proc_7 (Int_1_Loc, Int_2_Loc, &Int_3_Loc);

      Int_1_Loc += 1;
    }

    Proc_8 (Arr_1_Glob, Arr_2_Glob, Int_1_Loc, Int_3_Loc);

    Proc_1 (Ptr_Glob);
    for (Ch_Index = 'A'; Ch_Index <= Ch_2_Glob; ++Ch_Index)

    {
      if (Enum_Loc == Func_1 (Ch_Index, 'C'))

        {
        Proc_6 (Ident_1, &Enum_Loc);
        strcpy (Str_2_Loc, "DHRYSTONE PROGRAM, 3'RD STRING");
        Int_2_Loc = Run_Index;
        Int_Glob = Run_Index;
        }
    }

    Int_2_Loc = Int_2_Loc * Int_1_Loc;
    Int_1_Loc = Int_2_Loc / Int_3_Loc;
    Int_2_Loc = 7 * (Int_2_Loc - Int_3_Loc) - Int_1_Loc;

    Proc_2 (&Int_1_Loc);


  }
  uart_send("e");
# 322 "/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c"
}

Proc_1 (Ptr_Val_Par)


 Rec_Pointer Ptr_Val_Par;

{
  Rec_Pointer Next_Record = Ptr_Val_Par->Ptr_Comp;




  *Ptr_Val_Par->Ptr_Comp = *Ptr_Glob;
  Ptr_Val_Par->variant.var_1.Int_Comp = 5;
  Next_Record->variant.var_1.Int_Comp
        = Ptr_Val_Par->variant.var_1.Int_Comp;
  Next_Record->Ptr_Comp = Ptr_Val_Par->Ptr_Comp;
  Proc_3 (&Next_Record->Ptr_Comp);


  if (Next_Record->Discr == Ident_1)

  {
    Next_Record->variant.var_1.Int_Comp = 6;
    Proc_6 (Ptr_Val_Par->variant.var_1.Enum_Comp,
           &Next_Record->variant.var_1.Enum_Comp);
    Next_Record->Ptr_Comp = Ptr_Glob->Ptr_Comp;
    Proc_7 (Next_Record->variant.var_1.Int_Comp, 10,
           &Next_Record->variant.var_1.Int_Comp);
  }
  else
    *Ptr_Val_Par = *Ptr_Val_Par->Ptr_Comp;
}


Proc_2 (Int_Par_Ref)




One_Fifty *Int_Par_Ref;
{
  One_Fifty Int_Loc;
  Enumeration Enum_Loc;

  Int_Loc = *Int_Par_Ref + 10;
  do
    if (Ch_1_Glob == 'A')

    {
      Int_Loc -= 1;
      *Int_Par_Ref = Int_Loc - Int_Glob;
      Enum_Loc = Ident_1;
    }
  while (Enum_Loc != Ident_1);
}


Proc_3 (Ptr_Ref_Par)




Rec_Pointer *Ptr_Ref_Par;

{
  if (Ptr_Glob != 0)

    *Ptr_Ref_Par = Ptr_Glob->Ptr_Comp;
  Proc_7 (10, Int_Glob, &Ptr_Glob->variant.var_1.Int_Comp);
}


Proc_4 ()


{
  Boolean Bool_Loc;

  Bool_Loc = Ch_1_Glob == 'A';
  Bool_Glob = Bool_Loc | Bool_Glob;
  Ch_2_Glob = 'B';
}


Proc_5 ()


{
  Ch_1_Glob = 'A';
  Bool_Glob = 0;
}
