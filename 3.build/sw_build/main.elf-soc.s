	.file	"soc.c"
	.option nopic
	.attribute arch, "rv32i2p1"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
# GNU C17 (g04696df0963) version 14.2.0 (riscv64-unknown-elf)
#	compiled by GNU C version 11.4.0, GMP version 6.2.1, MPFR version 4.1.0, MPC version 1.2.1, isl version none
# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed: -mabi=ilp32 -mstrict-align -mcmodel=medlow -mrelax -mtune=rocket -misa-spec=20191213 -march=rv32i -g -O2 -ffreestanding -fno-builtin -fno-pic
	.text
.Ltext0:
	.cfi_sections	.debug_frame
	.file 0 "/home/tibrahimovic/projects/wireguard-fpga/3.build" "/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/soc.c"
	.align	2
	.globl	memcpy
	.type	memcpy, @function
memcpy:
.LFB0:
	.file 1 "/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/soc.c"
	.loc 1 34 50
	.cfi_startproc
.LVL0:
	.loc 1 35 4
.LBB2:
	.loc 1 35 9
	.loc 1 35 27 discriminator 1
	beq	a2,zero,.L2	#, n,,
	add	a2,a1,a2	# n, _23, ivtmp.8
.LVL1:
.L3:
	.loc 1 36 7
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/soc.c:36:       ((char*)dest)[i] = ((char*)src)[i];
	.loc 1 36 38 is_stmt 0
	lbu	a5,0(a1)	# _3, MEM[(char *)_20]
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/soc.c:35:    for (uint32_t i = 0; i < n; i++) {
	.loc 1 35 27 discriminator 1
	addi	a1,a1,1	#, ivtmp.8, ivtmp.8
.LVL2:
	addi	a0,a0,1	#, ivtmp.9, ivtmp.9
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/soc.c:36:       ((char*)dest)[i] = ((char*)src)[i];
	.loc 1 36 24
	sb	a5,-1(a0)	# _3, MEM[(char *)_21]
	.loc 1 35 33 is_stmt 1 discriminator 3
.LVL3:
	.loc 1 35 27 discriminator 1
	bne	a1,a2,.L3	#, ivtmp.8, _23,
.L2:
.LBE2:
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/soc.c:38: }
	.loc 1 38 1 is_stmt 0
	ret	
	.cfi_endproc
.LFE0:
	.size	memcpy, .-memcpy
	.align	2
	.globl	strcmp
	.type	strcmp, @function
strcmp:
.LFB1:
	.loc 1 43 44 is_stmt 1
	.cfi_startproc
.LVL4:
.L12:
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/soc.c:44:    while ((*s1 == *s2) && *s1) { ++s1; ++s2; }
	.loc 1 44 12 is_stmt 0 discriminator 1
	lbu	a5,0(a0)	# _1,* s1
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/soc.c:44:    while ((*s1 == *s2) && *s1) { ++s1; ++s2; }
	.loc 1 44 19 discriminator 1
	lbu	a4,0(a1)	# _2,* s2
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/soc.c:44:    while ((*s1 == *s2) && *s1) { ++s1; ++s2; }
	.loc 1 44 24 discriminator 1
	bne	a5,a4,.L11	#, _1, _2,
	.loc 1 44 34 is_stmt 1 discriminator 3
.LVL5:
	addi	a0,a0,1	#, s1, s1
.LVL6:
	.loc 1 44 40 discriminator 3
	addi	a1,a1,1	#, s2, s2
.LVL7:
	.loc 1 44 24 discriminator 1
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/soc.c:44:    while ((*s1 == *s2) && *s1) { ++s1; ++s2; }
	.loc 1 44 24 is_stmt 0 discriminator 2
	bne	a5,zero,.L12	#, _1,,
.L11:
	.loc 1 45 4 is_stmt 1
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/soc.c:46: }
	.loc 1 46 1 is_stmt 0
	sub	a0,a5,a4	#, _24, _2
.LVL8:
	ret	
	.cfi_endproc
.LFE1:
	.size	strcmp, .-strcmp
	.align	2
	.globl	mul3
	.type	mul3, @function
mul3:
.LFB2:
	.loc 1 52 28 is_stmt 1
	.cfi_startproc
.LVL9:
	.loc 1 53 4
	.loc 1 54 4
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/soc.c:54:    m = i << 2; //x4
	.loc 1 54 6 is_stmt 0
	slli	a5,a0,2	#, m, tmp138
.LVL10:
	.loc 1 55 4 is_stmt 1
	.loc 1 56 4
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/soc.c:57: }
	.loc 1 57 1 is_stmt 0
	sub	a0,a5,a0	#, m, tmp138
.LVL11:
	ret	
	.cfi_endproc
.LFE2:
	.size	mul3, .-mul3
.Letext0:
	.file 2 "/opt/riscv/lib/gcc/riscv64-unknown-elf/14.2.0/include/stdint-gcc.h"
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.4byte	0x157
	.2byte	0x5
	.byte	0x1
	.byte	0x4
	.4byte	.Ldebug_abbrev0
	.uleb128 0x5
	.4byte	.LASF17
	.byte	0x1d
	.4byte	.LASF0
	.4byte	.LASF1
	.4byte	.Ltext0
	.4byte	.Letext0-.Ltext0
	.4byte	.Ldebug_line0
	.uleb128 0x1
	.byte	0x8
	.byte	0x7
	.4byte	.LASF2
	.uleb128 0x1
	.byte	0x4
	.byte	0x7
	.4byte	.LASF3
	.uleb128 0x1
	.byte	0x1
	.byte	0x6
	.4byte	.LASF4
	.uleb128 0x1
	.byte	0x2
	.byte	0x5
	.4byte	.LASF5
	.uleb128 0x1
	.byte	0x4
	.byte	0x5
	.4byte	.LASF6
	.uleb128 0x1
	.byte	0x8
	.byte	0x5
	.4byte	.LASF7
	.uleb128 0x1
	.byte	0x1
	.byte	0x8
	.4byte	.LASF8
	.uleb128 0x1
	.byte	0x2
	.byte	0x7
	.4byte	.LASF9
	.uleb128 0x6
	.4byte	.LASF18
	.byte	0x2
	.byte	0x34
	.byte	0x1b
	.4byte	0x6a
	.uleb128 0x1
	.byte	0x4
	.byte	0x7
	.4byte	.LASF10
	.uleb128 0x7
	.byte	0x4
	.byte	0x5
	.string	"int"
	.uleb128 0x1
	.byte	0x10
	.byte	0x4
	.4byte	.LASF11
	.uleb128 0x3
	.4byte	.LASF12
	.byte	0x34
	.byte	0xa
	.4byte	0x5e
	.4byte	.LFB2
	.4byte	.LFE2-.LFB2
	.uleb128 0x1
	.byte	0x9c
	.4byte	0xb3
	.uleb128 0x2
	.string	"i"
	.byte	0x34
	.byte	0x19
	.4byte	0x5e
	.4byte	.LLST6
	.uleb128 0x4
	.string	"m"
	.byte	0x35
	.byte	0xd
	.4byte	0x5e
	.4byte	.LLST7
	.byte	0
	.uleb128 0x3
	.4byte	.LASF13
	.byte	0x2b
	.byte	0x5
	.4byte	0x71
	.4byte	.LFB1
	.4byte	.LFE1-.LFB1
	.uleb128 0x1
	.byte	0x9c
	.4byte	0xe9
	.uleb128 0x2
	.string	"s1"
	.byte	0x2b
	.byte	0x18
	.4byte	0xe9
	.4byte	.LLST4
	.uleb128 0x2
	.string	"s2"
	.byte	0x2b
	.byte	0x28
	.4byte	0xe9
	.4byte	.LLST5
	.byte	0
	.uleb128 0x8
	.byte	0x4
	.4byte	0xf6
	.uleb128 0x1
	.byte	0x1
	.byte	0x8
	.4byte	.LASF14
	.uleb128 0x9
	.4byte	0xef
	.uleb128 0x3
	.4byte	.LASF15
	.byte	0x22
	.byte	0x7
	.4byte	0x158
	.4byte	.LFB0
	.4byte	.LFE0-.LFB0
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x158
	.uleb128 0xa
	.4byte	.LASF16
	.byte	0x1
	.byte	0x22
	.byte	0x15
	.4byte	0x158
	.4byte	.LLST0
	.uleb128 0x2
	.string	"src"
	.byte	0x22
	.byte	0x21
	.4byte	0x158
	.4byte	.LLST1
	.uleb128 0x2
	.string	"n"
	.byte	0x22
	.byte	0x2f
	.4byte	0x5e
	.4byte	.LLST2
	.uleb128 0xb
	.4byte	.LBB2
	.4byte	.LBE2-.LBB2
	.uleb128 0x4
	.string	"i"
	.byte	0x23
	.byte	0x12
	.4byte	0x5e
	.4byte	.LLST3
	.byte	0
	.byte	0
	.uleb128 0xc
	.byte	0x4
	.byte	0
	.section	.debug_abbrev,"",@progbits
.Ldebug_abbrev0:
	.uleb128 0x1
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.byte	0
	.byte	0
	.uleb128 0x2
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x3
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x7a
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x4
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x5
	.uleb128 0x11
	.byte	0x1
	.uleb128 0x25
	.uleb128 0xe
	.uleb128 0x13
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0x1f
	.uleb128 0x1b
	.uleb128 0x1f
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x10
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x6
	.uleb128 0x16
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x7
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0x8
	.byte	0
	.byte	0
	.uleb128 0x8
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x9
	.uleb128 0x26
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xa
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.byte	0
	.byte	0
	.uleb128 0xc
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_loclists,"",@progbits
	.4byte	.Ldebug_loc3-.Ldebug_loc2
.Ldebug_loc2:
	.2byte	0x5
	.byte	0x4
	.byte	0
	.4byte	0
.Ldebug_loc0:
.LLST6:
	.byte	0x4
	.uleb128 .LVL9-.Ltext0
	.uleb128 .LVL11-.Ltext0
	.uleb128 0x1
	.byte	0x5a
	.byte	0x4
	.uleb128 .LVL11-.Ltext0
	.uleb128 .LFE2-.Ltext0
	.uleb128 0xa
	.byte	0xa3
	.uleb128 0x3
	.byte	0xa5
	.uleb128 0xa
	.uleb128 0x26
	.byte	0xa8
	.uleb128 0x2d
	.byte	0xa8
	.uleb128 0
	.byte	0x9f
	.byte	0
.LLST7:
	.byte	0x4
	.uleb128 .LVL10-.Ltext0
	.uleb128 .LVL11-.Ltext0
	.uleb128 0x8
	.byte	0x7a
	.sleb128 0
	.byte	0x32
	.byte	0x24
	.byte	0x7a
	.sleb128 0
	.byte	0x1c
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL11-.Ltext0
	.uleb128 .LFE2-.Ltext0
	.uleb128 0x1
	.byte	0x5a
	.byte	0
.LLST4:
	.byte	0x4
	.uleb128 .LVL4-.Ltext0
	.uleb128 .LVL5-.Ltext0
	.uleb128 0x1
	.byte	0x5a
	.byte	0x4
	.uleb128 .LVL5-.Ltext0
	.uleb128 .LVL6-.Ltext0
	.uleb128 0xa
	.byte	0xa3
	.uleb128 0x3
	.byte	0xa5
	.uleb128 0xa
	.uleb128 0x26
	.byte	0xa8
	.uleb128 0x2d
	.byte	0xa8
	.uleb128 0
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL6-.Ltext0
	.uleb128 .LVL8-.Ltext0
	.uleb128 0x1
	.byte	0x5a
	.byte	0
.LLST5:
	.byte	0x4
	.uleb128 .LVL4-.Ltext0
	.uleb128 .LVL5-.Ltext0
	.uleb128 0x1
	.byte	0x5b
	.byte	0x4
	.uleb128 .LVL5-.Ltext0
	.uleb128 .LVL7-.Ltext0
	.uleb128 0xa
	.byte	0xa3
	.uleb128 0x3
	.byte	0xa5
	.uleb128 0xb
	.uleb128 0x26
	.byte	0xa8
	.uleb128 0x2d
	.byte	0xa8
	.uleb128 0
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL7-.Ltext0
	.uleb128 .LFE1-.Ltext0
	.uleb128 0x1
	.byte	0x5b
	.byte	0
.LLST0:
	.byte	0x4
	.uleb128 .LVL0-.Ltext0
	.uleb128 .LVL1-.Ltext0
	.uleb128 0x1
	.byte	0x5a
	.byte	0x4
	.uleb128 .LVL1-.Ltext0
	.uleb128 .LFE0-.Ltext0
	.uleb128 0xa
	.byte	0xa3
	.uleb128 0x3
	.byte	0xa5
	.uleb128 0xa
	.uleb128 0x26
	.byte	0xa8
	.uleb128 0x2d
	.byte	0xa8
	.uleb128 0
	.byte	0x9f
	.byte	0
.LLST1:
	.byte	0x4
	.uleb128 .LVL0-.Ltext0
	.uleb128 .LVL1-.Ltext0
	.uleb128 0x1
	.byte	0x5b
	.byte	0x4
	.uleb128 .LVL1-.Ltext0
	.uleb128 .LFE0-.Ltext0
	.uleb128 0xa
	.byte	0xa3
	.uleb128 0x3
	.byte	0xa5
	.uleb128 0xb
	.uleb128 0x26
	.byte	0xa8
	.uleb128 0x2d
	.byte	0xa8
	.uleb128 0
	.byte	0x9f
	.byte	0
.LLST2:
	.byte	0x4
	.uleb128 .LVL0-.Ltext0
	.uleb128 .LVL1-.Ltext0
	.uleb128 0x1
	.byte	0x5c
	.byte	0x4
	.uleb128 .LVL1-.Ltext0
	.uleb128 .LFE0-.Ltext0
	.uleb128 0xa
	.byte	0xa3
	.uleb128 0x3
	.byte	0xa5
	.uleb128 0xc
	.uleb128 0x26
	.byte	0xa8
	.uleb128 0x2d
	.byte	0xa8
	.uleb128 0
	.byte	0x9f
	.byte	0
.LLST3:
	.byte	0x4
	.uleb128 .LVL0-.Ltext0
	.uleb128 .LVL1-.Ltext0
	.uleb128 0x2
	.byte	0x30
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL1-.Ltext0
	.uleb128 .LVL2-.Ltext0
	.uleb128 0xd
	.byte	0x7b
	.sleb128 0
	.byte	0xa3
	.uleb128 0x3
	.byte	0xa5
	.uleb128 0xb
	.uleb128 0x26
	.byte	0xa8
	.uleb128 0x2d
	.byte	0xa8
	.uleb128 0
	.byte	0x1c
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL2-.Ltext0
	.uleb128 .LVL3-.Ltext0
	.uleb128 0xe
	.byte	0xa3
	.uleb128 0x3
	.byte	0xa5
	.uleb128 0xb
	.uleb128 0x26
	.byte	0xa8
	.uleb128 0x2d
	.byte	0xa8
	.uleb128 0
	.byte	0x20
	.byte	0x7b
	.sleb128 0
	.byte	0x22
	.byte	0x9f
	.byte	0
.Ldebug_loc3:
	.section	.debug_aranges,"",@progbits
	.4byte	0x1c
	.2byte	0x2
	.4byte	.Ldebug_info0
	.byte	0x4
	.byte	0
	.2byte	0
	.2byte	0
	.4byte	.Ltext0
	.4byte	.Letext0-.Ltext0
	.4byte	0
	.4byte	0
	.section	.debug_line,"",@progbits
.Ldebug_line0:
	.section	.debug_str,"MS",@progbits,1
.LASF7:
	.string	"long long int"
.LASF3:
	.string	"unsigned int"
.LASF16:
	.string	"dest"
.LASF10:
	.string	"long unsigned int"
.LASF2:
	.string	"long long unsigned int"
.LASF17:
	.string	"GNU C17 14.2.0 -mabi=ilp32 -mstrict-align -mcmodel=medlow -mrelax -mtune=rocket -misa-spec=20191213 -march=rv32i -g -O2 -ffreestanding -fno-builtin -fno-pic"
.LASF12:
	.string	"mul3"
.LASF8:
	.string	"unsigned char"
.LASF14:
	.string	"char"
.LASF18:
	.string	"uint32_t"
.LASF6:
	.string	"long int"
.LASF13:
	.string	"strcmp"
.LASF15:
	.string	"memcpy"
.LASF9:
	.string	"short unsigned int"
.LASF4:
	.string	"signed char"
.LASF11:
	.string	"long double"
.LASF5:
	.string	"short int"
	.section	.debug_line_str,"MS",@progbits,1
.LASF0:
	.string	"/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/soc.c"
.LASF1:
	.string	"/home/tibrahimovic/projects/wireguard-fpga/3.build"
	.ident	"GCC: (g04696df0963) 14.2.0"
	.section	.note.GNU-stack,"",@progbits
