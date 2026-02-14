# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
# 
# SPDX-License-Identifier: BSD-3-Clause

#==========================================================================
# Startup Assembly program, acting as a minimal CRT (C Run Time).
# Needed due to the 'bare-metal' (aka "freestanding") nature of our CPU 
# setup. It may also be used to copy program and/or initial data value 
# from external Flash to on-chip RAM. A getting-started sample of that
# is provided, as a seed for adaption to your particular use-case.
#       
# Here is the standard allocation of RISC-V registers, along with
#  their alternative (ABI*) names:
#
#  +----------+----------+------------------------+--------+
#  | Register | ABI_Name | Description            | Saver  |
#  +----------+----------+------------------------+--------+
#  | x0       | zero     | Zero constant          |        |
#  | x1       | ra       | ReturnAddress          | Callee |
#  | x2       | sp       | StackPointer           | Callee |
#  | x3       | gp       | GlobalPointer          |        |
#  | x4       | tp       | ThreadPointer          |        |
#  | x5-x7    | t0-t2    | Temporaries            | Caller |
#  | x8       | s0 / fp  | SavedStackRegister0    | Callee |
#  |          |          |  or stack FramePointer | Callee |
#  | x9       | s1       | SavedRegister1         | Callee |
#  | x10-x11  | a0-a1    | fn Arguments or        | Caller |
#  |          |          |  return values         | Caller |
#  | x12-x17  | a2-a7    | fn Arguments           | Caller |
#  | x18-x27  | s2-s11   | SavedStackRegisters2-11| Callee |
#  | x28-x31  | t3-t6    | Temporaries            | Caller |
#  +----------+----------+------------------------+--------+
#  (*) ABI = Application Binary Interface, is a collection of 
#            guidelines on how to use CPU machine resources
#
#--------------------------------------------------------------------------
# Note the uppercase .S in the file extension. That's a GCC convention to 
# first run this file through C preprocessor (for #ifdef support) and only
# then through the Assembler. On the other hand, .s (lowercase) files
# cannot contain any C preprocessor directives. Such code is fed directly
# to the Assembler. However, Assembler preprocessor (.ifdef syntax) is
# still available.
#
#  For more, see:
#    https://riscvasm.lucasteske.dev
#    https://marz.utk.edu/my-courses/cosc230/book/example-risc-v-assembly-programs
#    https://github.com/riscv-non-isa/riscv-elf-psabi-doc/blob/master/riscv-cc.adoc#register-convention
#    https://www.youtube.com/watch?v=iml0DBo5yqo
#==========================================================================

.section .text
.global  _boot_crt

#.option  pic 
#.option  nopic 
#-| 'pic, nopic' options enable/disable position-independent code generation. Unless you
#-| really know what you’re doing, this should only be at the top of a file, if at all
        
#.option  rvc
#.option  norvc
#-| 'rvc, norvc' options enable/disable the generation of compressed instructions.
#-| Instructions are opportunistically compressed by the RISC-V assembler when possible, 
#-| but sometimes this behavior is not desirable.
        
        
_boot_crt:

.ifdef FLASH_BOOT
# For Flash boot, we first need to copy Code and Data
# sections from Flash to on-chip RAM
        
   # zero-initialize register file
   # x0 is always 0, and used as 'zero' constant
    
   # x1 is typically used for return address       
   addi x1,  zero, 0
           
   # x2 (sp) is on PicoRV32 initialized by HW reset, from ADDR_STACK
   # RTL parameter, which must be set to the last DMEM address + 1.
   # However, it's better to explicitly initialize it with linker value
        
   # x3-to-x31     
   addi x3,  zero, 0
   addi x4,  zero, 0
   addi x5,  zero, 0
   addi x6,  zero, 0
   addi x7,  zero, 0
   addi x8,  zero, 0
   addi x9,  zero, 0
   addi x10, zero, 0
   addi x11, zero, 0
   addi x12, zero, 0
   addi x13, zero, 0
   addi x14, zero, 0
   addi x15, zero, 0
   addi x16, zero, 0
   addi x17, zero, 0
   addi x18, zero, 0
   addi x19, zero, 0
   addi x20, zero, 0
   addi x21, zero, 0
   addi x22, zero, 0
   addi x23, zero, 0
   addi x24, zero, 0
   addi x25, zero, 0
   addi x26, zero, 0
   addi x27, zero, 0
   addi x28, zero, 0
   addi x29, zero, 0
   addi x30, zero, 0
   addi x31, zero, 0
    
   #-NOT-NEEDED: # Zero-initialize entire DMEM.
   #-NOT-NEEDED: #   The larger the DMEM, the longer this will take,
   #-NOT-NEEDED: #   rendering simulation unusable.   
   #-NOT-NEEDED: #   It's progressing from addr=0 to StackPointer,
   #-NOT-NEEDED: #   incrementing by 4 bytes as our DMEM is 32-bit wide.
   #-NOT-NEEDED: li   a0, 0x00000000
   #-NOT-NEEDED: li   a1, 0x00000000
   #-NOT-NEEDED:  
   #-NOT-NEEDED: setmemloop:
   #-NOT-NEEDED: sw   a1, 0(a0)
   #-NOT-NEEDED: addi a0, a0, 4
   #-NOT-NEEDED: blt  a0, sp, setmemloop
	
   #-TODO      : # FLASH_BOOT: Copy 'Code' section from Flash to RAM.
   #-TODO      : #  Note that '_text_start_flash' as source address to copy from is
   #-TODO      : #  just an example, and may not be correct source address in your case
   #-TODO      : la   a0, _text_start_flash
   #-TODO      : la   a1, _text_start_ram
   #-TODO      : la   a2, _text_end_flash
   #-TODO      : bge  a1, a2, end_copy_text
   #-TODO      :      
   #-TODO      : loop_copy_text:
   #-TODO      : lw   a3, 0(a0)
   #-TODO      : sw   a3, 0(a1)
   #-TODO      : addi a0, a0, 4
   #-TODO      : addi a1, a1, 4
   #-TODO      : blt  a1, a2, loop_copy_text
   #-TODO      :  
   #-TODO      : end_copy_text:
   
.endif
    

#--COMMON: Copy 'Initialized Data' section from Flash.
#  Note that '_text_end' as source address to copy from is just
#  an example, and assumes that the Initialized Data starts right
#  after Code. This may not be correct source address in your case
la   a0, _idata_start  
la   a1, _data_start
la   a2, _data_end
bge  a1, a2, end_copy_idata
    
loop_copy_idata:
lw   a3, 0(a0)
sw   a3, 0(a1)
addi a0, a0, 4
addi a1, a1, 4
blt  a1, a2, loop_copy_idata
 
end_copy_idata:
	
    
#--COMMON: Initialize 'BSS' section with all zeros
la   a0, _bss_start
la   a1, _bss_end
bge  a0, a1, end_clear_bss
 
loop_clear_bss:
sw   zero, 0(a0)
addi a0, a0, 4
blt  a0, a1, loop_clear_bss
	
end_clear_bss:
	
	
#--COMMON: Initialize SP and registers needed for 'C'. Then
#          enter 'main' function and loop forever when done
.option  push
.option  norelax
	
la   sp, _stack_start	     
la   gp, __global_pointer$
     
xor  a0, a0, a0 /* argc = 0 */
xor  a1, a1, a1 /* argv = 0 */
xor  a2, a2, a2 /* envp = 0 */
	
.option pop    
	
#ifdef TESTCODE
   #call start_test
#else
   call main
#endif
loop_forever: j loop_forever


#==========================================================================
# End-of-File
#==========================================================================
