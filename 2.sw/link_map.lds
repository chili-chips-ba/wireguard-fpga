//==========================================================================
// Copyright (C) 2024 Chili.CHIPS*ba
//==========================================================================
// Linker script. It instructs GCC where to place Code and Data sections, 
// or how to map them to the physical memory resources. It must be aligned
// with hardware design / RTL.
//
// Memory Architectures:
//
//  - HARVARD: Separate Instruction (IMEM) from Data (DMEM) space, making
//    it possible for IMEM to be Read-Only (ROM). In that way, the bugs in
//    the Code cannot destruct the Code. With dual-ported IMEM, it is in
//    this case possible to share the same Code between two cores.
//
//  - VON-NEUMANN: Unified Instruction and Data in a single memory element
//    (MEM). Dual-ported on-chip RAM (one for Instructions, another for Data)
//    makes it possible to still have concurrent accesses. However, larger
//    off-chip storage, such as SDRAM or Flash, typically don't offer dual-port
//    option. Code and Data can in this case be contiguous, without gaps,
//    allowing better memory utilization. However, due to lack of physical
//    separation, a Code bug can destroy both Data and Code. Admittedly,
//    there are those who view this property as a feature, and it allows
//    writing the self-modifying Code.
//
//
//     *(COMMON) /*common symbols*/
//
//     .text     /*CPU program, or Code*/
//     .rodata   /*Read-Only Data: Constants, strings, etc. used by Code*/
//     .data     /*Read-Write INITIALIZED Data*/
//     .bss      /*Read-Write ZERO-INITIALIZED Data*/
//
//     .srodata, .sdata, .sbss
//               /* these are ELF file format sections defined in the RISC-V ABI.
//                  (Application Binary Interface, which is a collection of 
//                   guidelines on how to use CPU machine resources). They are
//                  'Small data' versions of their parents. Compiler may decide
//                  to use them for small data blocks which, as an optimization, 
//                  can be accessed with a more efficient instruction sequence 
//                  than objects in the larger data sections */
//
//     .heap     /*Heap section*/
//     .stack    /*Stack section*/
//   
// For more, see:
//  http://en.ica123.com/risc-v-c-programming-1-%EF%BC%883%EF%BC%89linker-script
//  https://github.com/pulp-platform/pulp-riscv-gnu-toolchain/blob/master/riscv.ld
//  https://users.informatik.haw-hamburg.de/~krabat/FH-Labor/gnupro/5_GNUPro_Utilities/c_Using_LD/ldLinker_scripts.html
//==========================================================================

OUTPUT_FORMAT( "elf32-littleriscv" )
/*specify output as Executable-and-Linking-Format (ELF) in 32 bits Little-Endian*/

OUTPUT_ARCH( "riscv" )
/*specify the output architecture is RISCV*/

_HEAP_SIZE  = 0x400;  /*define a macro */
_STACK_SIZE = 0x200;  /*define a macro */


MEMORY {

//---------------------------------------------------
// Tightly-Coupled Memory (TCM) option, when on-chip 
//  BRAM is used for both Code and Data. SDRAM is not
//  directly visible to compiler
//---------------------------------------------------
#if TCM

    #if HARVARD
       IMEM (xr!w) : ORIGIN = 0x00000000, LENGTH = 32K /* Instruction space */
       /* Largest memory resources are external Flash (LENGTH=8M) and external
          SDRAM (LENGTH=8MB)*/

       DMEM (rw!x) : ORIGIN = 0x10000000, LENGTH = 32K /* Data space */
       /* ORIGIN=256MB */

    #else
    /* VON-NEUMANN: Common Instruction & Data space -- Not yet in RTL*/
        MEM (rwx)  : ORIGIN = 0x00000000, LENGTH = 64K 
    #endif   

//---------------------------------------------------
// 8MB off-chip SDRAM is made directly visible to compiler.
// SDRAM is in RTL mapped to start from 0x4000_0000
//---------------------------------------------------
#else
    #if HARVARD
    /* On-chip TCM is still used for Instructions (since better for performance).
       External 8M SDRAM is now used for compiler Data. 32KB on-chip RAM is still
       available in the 0x1000_0000-0x1FFF_FFFF data space, but it now won't be 
       automatically used for storing 'C' data structures */
       IMEM (xr!w) : ORIGIN = 0x00000000, LENGTH = 32K /* Instruction space */
       DMEM (rw!x) : ORIGIN = 0x40000000, LENGTH = 8M  /* Data space */
     
    #else
    /* VON-NEUMANN: 8MB off-chip SDRAM used for both Instructions & Data */
        MEM (rwx)  : ORIGIN = 0x40000000, LENGTH = 8M
    #endif  

#endif

//---------------------------------------------------
// For simplicity, the I/O section is not explicitly defined.
// The 'C' code can still access all I/O, but it won't automatically
// place variables there
//---------------------------------------------------
   /* IO  (rw!x) : ORIGIN = 0xFFFF0000, LENGTH = 0x20 */

}


SECTIONS {

//--------------------------------------------------------------------
// For  HARVARD, program code and constants go into separate IMEM.
// For !HARVARD, program code and constants go into common MEM.
//
// We keep constants together with code for simpler updating of CPU
// program, be it via INIT or UART method. Had they been placed into
// separate memories, we'd for HARVARD memory model need to update
// two different memory blocks, which is not as straightforward.
//
// In the case of FLASH_BOOT, the JTAG programer puts them in the
// Flash. 'boot_crt.S' Assembly then comes to rescue, and copies
// them from Flash to IMEM or MEM. The compiler is not aware of it,
// and 'C' program executes assuming that everything is in the places
// as specified by this linker script. Global symbols sprinkled
// througout the linker script are used by 'boot_crt.S' Assembly
// to transfer them from Flash to RAM before giving control to 'C'.
//--------------------------------------------------------------------
#if HARVARD
   . = ORIGIN(IMEM);
#else
   . = ORIGIN(MEM); /* for !TCM, CPU Reset address must much (x4000_0000) */
#endif

   .text : {
    /*Program Code*/
      _text_start = .; /*global symbol*/
      *(.text    .text.*) 

    /*Read-Only Data: Constants, strings, etc. used by Code*/
      *(.rodata  .rodata.*)
      *(.srodata .srodata.*)

      . = ALIGN(4);    /*align with 4 bytes*/
      _text_end = .;   /*global symbol. Accounts for ORIGIN+OFFSET*/
      _idata_start = _text_end;
   }
//#if HARVARD
//   > IMEM
//#else
//   > MEM
//#endif


//--------------------------------------------------------------------
// For  HARVARD, data goes into DMEM, starting from DMEM ORIGIN.
// For !HARVARD, data goes into common MEM, continuing from End-of-Code.
//--------------------------------------------------------------------

//Tarik
  .data : AT ( _text_end )
  {
      /* Read-Write Initialized Data */
      _data_start = .; /* Global symbol */
      *(.data .data.*)
      . = ALIGN(8);
      PROVIDE( __global_pointer$ = . + 0x800 );
   
      *(.sdata .sdata.*)
      . = ALIGN(4);
      _data_end = .; /* Global symbol */
  } 
  #if HARVARD
      > DMEM
  #endif


//ORIGINAL--|  #if HARVARD
//ORIGINAL--|     .data : AT (ORIGIN(DMEM)) {
//ORIGINAL--|  #else
//ORIGINAL--|     .data : AT (_text_end) {
//ORIGINAL--|  #endif
//ORIGINAL--|   
//ORIGINAL--|    /*Read-Write Initialized Data*/
//ORIGINAL--|      _data_start = .; /*global symbol*/
//ORIGINAL--|      *(.data   .data.*)
//ORIGINAL--|      . = ALIGN(8);
//ORIGINAL--|      PROVIDE( __global_pointer$ = . + 0x800 );
//ORIGINAL--|   
//ORIGINAL--|      *(.sdata  .sdata.*)
//ORIGINAL--|      . = ALIGN(4);
//ORIGINAL--|      _data_end = .;   /*global symbol*/
//ORIGINAL--|   }


   /* GlobalPointer: When --relax GCC option is used, global variable are 
      accessed via a relative immediate offset from the global pointer.
      For that they need to be within imm12 (+/-2048 bytes) reach from 
      the GlobalPointer. We therefore try to place it in the middle of 
      the global memory space. For more, see:
        https://www.five-embeddev.com//quickref/global_pointer.html */

   .bss : {
    /*Read-Write Zero-Initialized Data*/
      _bss_start = .;  /*global symbol*/
      *(.bss   .bss.*)
      *(.sbss  .sbss.*)    
      *(COMMON)
      . = ALIGN(4);
      _bss_end = .;    /*global symbol*/
   }

//--------------------------------------------------------------------
// Define the Heap.
//  Ensure that we have enough RAM left for the specified size
//  See: https://www.baeldung.com/cs/memory-stack-vs-heap
//--------------------------------------------------------------------
   . = ALIGN(16);      /*align with 16 bytes for easier Heap management*/

   .heap : {
     _heap_start = .;  /*global symbol*/
     //KEEP(*(.heap*))
     . = . + _HEAP_SIZE; /* allocate HEAP_SIZE worth of space*/
     . = ALIGN(16);
     _heap_end = .;    /*global symbol*/
   }

   /*PROVIDE is to define a symbol only if it's referenced 
      and not defined by any included object*/
   . = ALIGN(8);

   PROVIDE( _end = . ); /*define _end address*/
   PROVIDE(  end = . ); /*define  end address*/
 
//--------------------------------------------------------------------
// Stack goes to the end od Data space.
//  Ensure we have enough RAM left for the specified size
//--------------------------------------------------------------------
#if HARVARD
   PROVIDE(_stack_start = ORIGIN(DMEM) + LENGTH(DMEM));
#else 
   PROVIDE(_stack_start = ORIGIN(MEM) + LENGTH(MEM));
#endif

   //. = ALIGN(16); /*RISC-V GCC wants to allocate stack in 16-byte units*/

   .stack (_stack_start - _STACK_SIZE) : {
     //KEEP(*(.stack*))
     . = . + _STACK_SIZE;
   } 

   _stack_end = _stack_start - SIZEOF(.stack);
 
   //ASSERT (_stack_end <= _heap_end, "Error: Stack overflow. RAM is too small for this program")


//--------------------------------------------------------------------
// I/O section: Not Used
//--------------------------------------------------------------------
  /*
    .io : { * /io.o(COMMON) } > IO
  */

}

//==========================================================================
// End-of-File
//==========================================================================
