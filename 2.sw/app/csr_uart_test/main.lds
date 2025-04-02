OUTPUT_FORMAT( "elf32-littleriscv" )
OUTPUT_ARCH( "riscv" )
_HEAP_SIZE = 0x400;
_STACK_SIZE = 0x200;
MEMORY {
       IMEM (xr!w) : ORIGIN = 0x00000000, LENGTH = 32K
       DMEM (rw!x) : ORIGIN = 0x10000000, LENGTH = 32K
}
SECTIONS {
   . = ORIGIN(IMEM);
   .text : {
      _text_start = .;
      *(.text .text.*)
      *(.rodata .rodata.*)
      *(.srodata .srodata.*)
      . = ALIGN(4);
      _text_end = .;
      _idata_start = _text_end;
   }
  .data : AT ( _text_end )
  {
      _data_start = .;
      *(.data .data.*)
      . = ALIGN(8);
      PROVIDE( __global_pointer$ = . + 0x800 );
      *(.sdata .sdata.*)
      . = ALIGN(4);
      _data_end = .;
  }
      > DMEM
   .bss : {
      _bss_start = .;
      *(.bss .bss.*)
      *(.sbss .sbss.*)
      *(COMMON)
      . = ALIGN(4);
      _bss_end = .;
   }
   . = ALIGN(16);
   .heap : {
     _heap_start = .;
     . = . + _HEAP_SIZE;
     . = ALIGN(16);
     _heap_end = .;
   }
   . = ALIGN(8);
   PROVIDE( _end = . );
   PROVIDE( end = . );
   PROVIDE(_stack_start = ORIGIN(DMEM) + LENGTH(DMEM));
   .stack (_stack_start - _STACK_SIZE) : {
     . = . + _STACK_SIZE;
   }
   _stack_end = _stack_start - SIZEOF(.stack);
}
