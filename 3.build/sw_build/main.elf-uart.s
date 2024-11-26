	.file	"uart.c"
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
	.file 0 "/home/tibrahimovic/projects/wireguard-fpga/3.build" "/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/uart.c"
	.align	2
	.globl	uart_send_char
	.type	uart_send_char, @function
uart_send_char:
.LFB0:
	.file 1 "/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/uart.c"
	.loc 1 38 30
	.cfi_startproc
.LVL0:
	.loc 1 40 4
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/uart.c:40:    while (CSR -> uart_tx.fld.busy); 
	.loc 1 40 57 is_stmt 0 discriminator 1
	li	a4,536870912		# tmp136,
.L2:
	.loc 1 40 11 is_stmt 1 discriminator 1
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/uart.c:40:    while (CSR -> uart_tx.fld.busy); 
	.loc 1 40 57 is_stmt 0 discriminator 1
	lw	a5,0(a4)		# MEM[(volatile struct csr_t *)536870912B], MEM[(volatile struct csr_t *)536870912B]
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/uart.c:40:    while (CSR -> uart_tx.fld.busy); 
	.loc 1 40 11 discriminator 1
	blt	a5,zero,.L2	#, MEM[(volatile struct csr_t *)536870912B],,
	.loc 1 41 4 is_stmt 1
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/uart.c:41:    CSR -> uart_tx.fld.data = c;
	.loc 1 41 56 is_stmt 0
	sb	a0,0(a4)	# c, MEM[(volatile struct csr_t *)536870912B].uart_tx.fld.data
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/uart.c:42: }
	.loc 1 42 1
	ret	
	.cfi_endproc
.LFE0:
	.size	uart_send_char, .-uart_send_char
	.section	.rodata.str1.4,"aMS",@progbits,1
	.align	2
.LC0:
	.string	"0123456789ABCDEF"
	.text
	.align	2
	.globl	uart_send_hex
	.type	uart_send_hex, @function
uart_send_hex:
.LFB1:
	.loc 1 52 51 is_stmt 1
	.cfi_startproc
.LVL1:
	.loc 1 53 4
.LBB7:
	.loc 1 53 9
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/uart.c:53:    for (int i = (4*digits) - 4; i >= 0; i -= 4)
	.loc 1 53 28 is_stmt 0
	addi	a3,a1,-1	#, _1, tmp157
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/uart.c:53:    for (int i = (4*digits) - 4; i >= 0; i -= 4)
	.loc 1 53 13
	slli	a3,a3,2	#, i, _1
.LVL2:
	.loc 1 53 35 is_stmt 1 discriminator 1
	blt	a3,zero,.L5	#, i,,
	lui	a1,%hi(.LC0)	# tmp153,
.LVL3:
	addi	a1,a1,%lo(.LC0)	# tmp154, tmp153,
.LBB8:
.LBB9:
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/uart.c:40:    while (CSR -> uart_tx.fld.busy); 
	.loc 1 40 57 is_stmt 0 discriminator 1
	li	a4,536870912		# tmp148,
.L8:
.LBE9:
.LBE8:
	.loc 1 54 7 is_stmt 1
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/uart.c:54:       uart_send_char("0123456789ABCDEF"[(val >> i) % 16]);
	.loc 1 54 46 is_stmt 0
	srl	a5,a0,a3	# i, _2, val
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/uart.c:54:       uart_send_char("0123456789ABCDEF"[(val >> i) % 16]);
	.loc 1 54 52
	andi	a5,a5,15	#, _3, _2
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/uart.c:54:       uart_send_char("0123456789ABCDEF"[(val >> i) % 16]);
	.loc 1 54 7
	add	a5,a1,a5	# _3, tmp147, tmp154
	lbu	a2,0(a5)	# _4, "0123456789ABCDEF"[_3]
.LVL4:
.LBB11:
.LBB10:
	.loc 1 40 4 is_stmt 1
.L7:
	.loc 1 40 11 discriminator 1
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/uart.c:40:    while (CSR -> uart_tx.fld.busy); 
	.loc 1 40 57 is_stmt 0 discriminator 1
	lw	a5,0(a4)		# MEM[(volatile struct csr_t *)536870912B], MEM[(volatile struct csr_t *)536870912B]
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/uart.c:40:    while (CSR -> uart_tx.fld.busy); 
	.loc 1 40 11 discriminator 1
	blt	a5,zero,.L7	#, MEM[(volatile struct csr_t *)536870912B],,
	.loc 1 41 4 is_stmt 1
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/uart.c:41:    CSR -> uart_tx.fld.data = c;
	.loc 1 41 56 is_stmt 0
	sb	a2,0(a4)	# _4, MEM[(volatile struct csr_t *)536870912B].uart_tx.fld.data
.LVL5:
.LBE10:
.LBE11:
	.loc 1 53 43 is_stmt 1 discriminator 3
	addi	a3,a3,-4	#, i, i
.LVL6:
	.loc 1 53 35 discriminator 1
	bge	a3,zero,.L8	#, i,,
.L5:
.LBE7:
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/uart.c:55: }
	.loc 1 55 1 is_stmt 0
	ret	
	.cfi_endproc
.LFE1:
	.size	uart_send_hex, .-uart_send_hex
	.align	2
	.globl	uart_send
	.type	uart_send, @function
uart_send:
.LFB2:
	.loc 1 64 32 is_stmt 1
	.cfi_startproc
.LVL7:
	.loc 1 65 4
	.loc 1 65 11 discriminator 1
	lbu	a3,0(a0)	# _1, *s_4(D)
	beq	a3,zero,.L11	#, _1,,
.LBB12:
.LBB13:
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/uart.c:40:    while (CSR -> uart_tx.fld.busy); 
	.loc 1 40 57 is_stmt 0 discriminator 1
	li	a4,536870912		# tmp137,
.L14:
.LBE13:
.LBE12:
	.loc 1 65 15 is_stmt 1 discriminator 2
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/uart.c:65:    while (*s) uart_send_char(*(s++));
	.loc 1 65 33 is_stmt 0 discriminator 2
	addi	a0,a0,1	#, s, s
.LVL8:
.LBB15:
.LBB14:
	.loc 1 40 4 is_stmt 1
.L13:
	.loc 1 40 11 discriminator 1
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/uart.c:40:    while (CSR -> uart_tx.fld.busy); 
	.loc 1 40 57 is_stmt 0 discriminator 1
	lw	a5,0(a4)		# MEM[(volatile struct csr_t *)536870912B], MEM[(volatile struct csr_t *)536870912B]
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/uart.c:40:    while (CSR -> uart_tx.fld.busy); 
	.loc 1 40 11 discriminator 1
	blt	a5,zero,.L13	#, MEM[(volatile struct csr_t *)536870912B],,
	.loc 1 41 4 is_stmt 1
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/uart.c:41:    CSR -> uart_tx.fld.data = c;
	.loc 1 41 56 is_stmt 0
	sb	a3,0(a4)	# _1, MEM[(volatile struct csr_t *)536870912B].uart_tx.fld.data
.LVL9:
.LBE14:
.LBE15:
	.loc 1 65 11 is_stmt 1 discriminator 1
	lbu	a3,0(a0)	# _1, MEM[(const char *)s_6]
	bne	a3,zero,.L14	#, _1,,
.L11:
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/uart.c:66: }
	.loc 1 66 1 is_stmt 0
	ret	
	.cfi_endproc
.LFE2:
	.size	uart_send, .-uart_send
.Letext0:
	.file 2 "/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/soc.h"
	.file 3 "/opt/riscv/lib/gcc/riscv64-unknown-elf/14.2.0/include/stdint-gcc.h"
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.4byte	0x4a2
	.2byte	0x5
	.byte	0x1
	.byte	0x4
	.4byte	.Ldebug_abbrev0
	.uleb128 0xc
	.4byte	.LASF54
	.byte	0x1d
	.4byte	.LASF0
	.4byte	.LASF1
	.4byte	.Ltext0
	.4byte	.Letext0-.Ltext0
	.4byte	.Ldebug_line0
	.uleb128 0x3
	.byte	0x8
	.byte	0x7
	.4byte	.LASF2
	.uleb128 0x3
	.byte	0x4
	.byte	0x7
	.4byte	.LASF3
	.uleb128 0x3
	.byte	0x1
	.byte	0x6
	.4byte	.LASF4
	.uleb128 0x3
	.byte	0x2
	.byte	0x5
	.4byte	.LASF5
	.uleb128 0x3
	.byte	0x4
	.byte	0x5
	.4byte	.LASF6
	.uleb128 0x3
	.byte	0x8
	.byte	0x5
	.4byte	.LASF7
	.uleb128 0x3
	.byte	0x1
	.byte	0x8
	.4byte	.LASF8
	.uleb128 0x3
	.byte	0x2
	.byte	0x7
	.4byte	.LASF9
	.uleb128 0x4
	.4byte	.LASF15
	.byte	0x3
	.byte	0x34
	.byte	0x1b
	.4byte	0x6a
	.uleb128 0x3
	.byte	0x4
	.byte	0x7
	.4byte	.LASF10
	.uleb128 0xd
	.byte	0x4
	.byte	0x5
	.string	"int"
	.uleb128 0x3
	.byte	0x10
	.byte	0x4
	.4byte	.LASF11
	.uleb128 0x5
	.byte	0x4
	.byte	0x26
	.byte	0x4
	.4byte	0xac
	.uleb128 0x1
	.4byte	.LASF12
	.byte	0x27
	.4byte	0x5e
	.byte	0x8
	.byte	0
	.uleb128 0x1
	.4byte	.LASF13
	.byte	0x28
	.4byte	0x5e
	.byte	0x17
	.byte	0x8
	.uleb128 0x1
	.4byte	.LASF14
	.byte	0x29
	.4byte	0x5e
	.byte	0x1
	.byte	0x1f
	.byte	0
	.uleb128 0x7
	.byte	0x23
	.4byte	0xc9
	.uleb128 0x2
	.string	"all"
	.byte	0x24
	.byte	0xd
	.4byte	0x5e
	.uleb128 0x2
	.string	"fld"
	.byte	0x2a
	.byte	0x6
	.4byte	0x7f
	.byte	0
	.uleb128 0x4
	.4byte	.LASF16
	.byte	0x2
	.byte	0x2b
	.byte	0x3
	.4byte	0xac
	.uleb128 0x5
	.byte	0x4
	.byte	0x33
	.byte	0x4
	.4byte	0x10e
	.uleb128 0x1
	.4byte	.LASF12
	.byte	0x34
	.4byte	0x5e
	.byte	0x8
	.byte	0
	.uleb128 0x1
	.4byte	.LASF17
	.byte	0x35
	.4byte	0x5e
	.byte	0x16
	.byte	0x8
	.uleb128 0x1
	.4byte	.LASF18
	.byte	0x36
	.4byte	0x5e
	.byte	0x1
	.byte	0x1e
	.uleb128 0x1
	.4byte	.LASF19
	.byte	0x37
	.4byte	0x5e
	.byte	0x1
	.byte	0x1f
	.byte	0
	.uleb128 0x7
	.byte	0x30
	.4byte	0x12b
	.uleb128 0x2
	.string	"all"
	.byte	0x31
	.byte	0xd
	.4byte	0x5e
	.uleb128 0x2
	.string	"fld"
	.byte	0x38
	.byte	0x6
	.4byte	0xd5
	.byte	0
	.uleb128 0x4
	.4byte	.LASF20
	.byte	0x2
	.byte	0x58
	.byte	0x3
	.4byte	0x10e
	.uleb128 0x5
	.byte	0x4
	.byte	0x62
	.byte	0x4
	.4byte	0x170
	.uleb128 0x1
	.4byte	.LASF21
	.byte	0x63
	.4byte	0x5e
	.byte	0xf
	.byte	0
	.uleb128 0x1
	.4byte	.LASF22
	.byte	0x64
	.4byte	0x5e
	.byte	0x1
	.byte	0xf
	.uleb128 0x1
	.4byte	.LASF23
	.byte	0x65
	.4byte	0x5e
	.byte	0xf
	.byte	0x10
	.uleb128 0x1
	.4byte	.LASF14
	.byte	0x66
	.4byte	0x5e
	.byte	0x1
	.byte	0x1f
	.byte	0
	.uleb128 0x7
	.byte	0x5f
	.4byte	0x18d
	.uleb128 0x2
	.string	"all"
	.byte	0x60
	.byte	0xd
	.4byte	0x5e
	.uleb128 0x2
	.string	"fld"
	.byte	0x67
	.byte	0x6
	.4byte	0x137
	.byte	0
	.uleb128 0x4
	.4byte	.LASF24
	.byte	0x2
	.byte	0x68
	.byte	0x3
	.4byte	0x170
	.uleb128 0x5
	.byte	0x4
	.byte	0x82
	.byte	0x4
	.4byte	0x1ba
	.uleb128 0x1
	.4byte	.LASF25
	.byte	0x83
	.4byte	0x5e
	.byte	0x11
	.byte	0
	.uleb128 0x1
	.4byte	.LASF26
	.byte	0x84
	.4byte	0x5e
	.byte	0xf
	.byte	0x11
	.byte	0
	.uleb128 0x7
	.byte	0x7f
	.4byte	0x1d7
	.uleb128 0x2
	.string	"all"
	.byte	0x80
	.byte	0xd
	.4byte	0x5e
	.uleb128 0x2
	.string	"fld"
	.byte	0x85
	.byte	0x6
	.4byte	0x199
	.byte	0
	.uleb128 0x4
	.4byte	.LASF27
	.byte	0x2
	.byte	0x86
	.byte	0x3
	.4byte	0x1ba
	.uleb128 0x5
	.byte	0x4
	.byte	0x8f
	.byte	0x4
	.4byte	0x204
	.uleb128 0x1
	.4byte	.LASF28
	.byte	0x90
	.4byte	0x5e
	.byte	0x8
	.byte	0
	.uleb128 0x1
	.4byte	.LASF29
	.byte	0x91
	.4byte	0x5e
	.byte	0x18
	.byte	0x8
	.byte	0
	.uleb128 0x7
	.byte	0x8c
	.4byte	0x221
	.uleb128 0x2
	.string	"all"
	.byte	0x8d
	.byte	0xd
	.4byte	0x5e
	.uleb128 0x2
	.string	"fld"
	.byte	0x92
	.byte	0x6
	.4byte	0x1e3
	.byte	0
	.uleb128 0x4
	.4byte	.LASF30
	.byte	0x2
	.byte	0x93
	.byte	0x3
	.4byte	0x204
	.uleb128 0x5
	.byte	0x4
	.byte	0x99
	.byte	0x4
	.4byte	0x24e
	.uleb128 0x1
	.4byte	.LASF31
	.byte	0x9a
	.4byte	0x5e
	.byte	0x8
	.byte	0
	.uleb128 0x1
	.4byte	.LASF29
	.byte	0x9b
	.4byte	0x5e
	.byte	0x18
	.byte	0x8
	.byte	0
	.uleb128 0x7
	.byte	0x96
	.4byte	0x26b
	.uleb128 0x2
	.string	"all"
	.byte	0x97
	.byte	0xd
	.4byte	0x5e
	.uleb128 0x2
	.string	"fld"
	.byte	0x9c
	.byte	0x6
	.4byte	0x22d
	.byte	0
	.uleb128 0x4
	.4byte	.LASF32
	.byte	0x2
	.byte	0x9d
	.byte	0x3
	.4byte	0x24e
	.uleb128 0x5
	.byte	0x4
	.byte	0xa3
	.byte	0x4
	.4byte	0x2bc
	.uleb128 0x1
	.4byte	.LASF33
	.byte	0xa4
	.4byte	0x5e
	.byte	0xf
	.byte	0
	.uleb128 0x1
	.4byte	.LASF34
	.byte	0xa5
	.4byte	0x5e
	.byte	0x1
	.byte	0xf
	.uleb128 0x1
	.4byte	.LASF35
	.byte	0xa6
	.4byte	0x5e
	.byte	0xa
	.byte	0x10
	.uleb128 0x1
	.4byte	.LASF36
	.byte	0xa7
	.4byte	0x5e
	.byte	0x5
	.byte	0x1a
	.uleb128 0x1
	.4byte	.LASF14
	.byte	0xa8
	.4byte	0x5e
	.byte	0x1
	.byte	0x1f
	.byte	0
	.uleb128 0x7
	.byte	0xa0
	.4byte	0x2d9
	.uleb128 0x2
	.string	"all"
	.byte	0xa1
	.byte	0xd
	.4byte	0x5e
	.uleb128 0x2
	.string	"fld"
	.byte	0xa9
	.byte	0x6
	.4byte	0x277
	.byte	0
	.uleb128 0x4
	.4byte	.LASF37
	.byte	0x2
	.byte	0xaa
	.byte	0x3
	.4byte	0x2bc
	.uleb128 0x5
	.byte	0x4
	.byte	0xb3
	.byte	0x4
	.4byte	0x306
	.uleb128 0x1
	.4byte	.LASF38
	.byte	0xb4
	.4byte	0x5e
	.byte	0x8
	.byte	0
	.uleb128 0x1
	.4byte	.LASF29
	.byte	0xb5
	.4byte	0x5e
	.byte	0x18
	.byte	0x8
	.byte	0
	.uleb128 0x7
	.byte	0xb0
	.4byte	0x323
	.uleb128 0x2
	.string	"all"
	.byte	0xb1
	.byte	0xd
	.4byte	0x5e
	.uleb128 0x2
	.string	"fld"
	.byte	0xb6
	.byte	0x6
	.4byte	0x2e5
	.byte	0
	.uleb128 0x4
	.4byte	.LASF39
	.byte	0x2
	.byte	0xb7
	.byte	0x3
	.4byte	0x306
	.uleb128 0x5
	.byte	0x2c
	.byte	0xbb
	.byte	0x9
	.4byte	0x3ba
	.uleb128 0x6
	.4byte	.LASF40
	.byte	0xbc
	.byte	0xd
	.4byte	0xc9
	.byte	0
	.uleb128 0x6
	.4byte	.LASF41
	.byte	0xbd
	.byte	0xd
	.4byte	0x12b
	.byte	0x4
	.uleb128 0x6
	.4byte	.LASF42
	.byte	0xbf
	.byte	0xc
	.4byte	0x18d
	.byte	0x8
	.uleb128 0x6
	.4byte	.LASF43
	.byte	0xc0
	.byte	0xc
	.4byte	0x1d7
	.byte	0xc
	.uleb128 0x6
	.4byte	.LASF44
	.byte	0xc2
	.byte	0xc
	.4byte	0x18d
	.byte	0x10
	.uleb128 0x6
	.4byte	.LASF45
	.byte	0xc3
	.byte	0xc
	.4byte	0x1d7
	.byte	0x14
	.uleb128 0x8
	.string	"gpo"
	.byte	0xc5
	.4byte	0x221
	.byte	0x18
	.uleb128 0x8
	.string	"gpi"
	.byte	0xc6
	.4byte	0x26b
	.byte	0x1c
	.uleb128 0x6
	.4byte	.LASF46
	.byte	0xc8
	.byte	0xc
	.4byte	0x2d9
	.byte	0x20
	.uleb128 0x6
	.4byte	.LASF47
	.byte	0xc9
	.byte	0xc
	.4byte	0x2d9
	.byte	0x24
	.uleb128 0x6
	.4byte	.LASF48
	.byte	0xcb
	.byte	0xa
	.4byte	0x323
	.byte	0x28
	.byte	0
	.uleb128 0x4
	.4byte	.LASF49
	.byte	0x2
	.byte	0xcc
	.byte	0x3
	.4byte	0x32f
	.uleb128 0x9
	.4byte	.LASF51
	.byte	0x40
	.4byte	.LFB2
	.4byte	.LFE2-.LFB2
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x402
	.uleb128 0xe
	.string	"s"
	.byte	0x1
	.byte	0x40
	.byte	0x1d
	.4byte	0x402
	.4byte	.LLST3
	.uleb128 0xa
	.4byte	0x476
	.4byte	.LBB12
	.4byte	.LLRL4
	.byte	0x41
	.byte	0xf
	.uleb128 0xb
	.4byte	0x483
	.4byte	.LLST5
	.byte	0
	.byte	0
	.uleb128 0xf
	.byte	0x4
	.4byte	0x40f
	.uleb128 0x3
	.byte	0x1
	.byte	0x8
	.4byte	.LASF50
	.uleb128 0x10
	.4byte	0x408
	.uleb128 0x9
	.4byte	.LASF52
	.byte	0x34
	.4byte	.LFB1
	.4byte	.LFE1-.LFB1
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x476
	.uleb128 0x11
	.string	"val"
	.byte	0x1
	.byte	0x34
	.byte	0x22
	.4byte	0x2d
	.uleb128 0x1
	.byte	0x5a
	.uleb128 0x12
	.4byte	.LASF53
	.byte	0x1
	.byte	0x34
	.byte	0x2b
	.4byte	0x71
	.4byte	.LLST0
	.uleb128 0x13
	.4byte	.LBB7
	.4byte	.LBE7-.LBB7
	.uleb128 0x14
	.string	"i"
	.byte	0x1
	.byte	0x35
	.byte	0xd
	.4byte	0x71
	.uleb128 0x1
	.byte	0x5d
	.uleb128 0xa
	.4byte	0x476
	.4byte	.LBB8
	.4byte	.LLRL1
	.byte	0x36
	.byte	0x7
	.uleb128 0xb
	.4byte	0x483
	.4byte	.LLST2
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x15
	.4byte	.LASF55
	.byte	0x1
	.byte	0x26
	.byte	0x6
	.byte	0x1
	.4byte	0x48e
	.uleb128 0x16
	.string	"c"
	.byte	0x1
	.byte	0x26
	.byte	0x1b
	.4byte	0x408
	.byte	0
	.uleb128 0x17
	.4byte	0x476
	.4byte	.LFB0
	.4byte	.LFE0-.LFB0
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0x18
	.4byte	0x483
	.uleb128 0x1
	.byte	0x5a
	.byte	0
	.byte	0
	.section	.debug_abbrev,"",@progbits
.Ldebug_abbrev0:
	.uleb128 0x1
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 2
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0x21
	.sleb128 16
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0xd
	.uleb128 0xb
	.uleb128 0x6b
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x2
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 2
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x3
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
	.uleb128 0x4
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
	.uleb128 0x5
	.uleb128 0x13
	.byte	0x1
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 2
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x6
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 2
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x7
	.uleb128 0x17
	.byte	0x1
	.uleb128 0xb
	.uleb128 0x21
	.sleb128 4
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 2
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0x21
	.sleb128 9
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x8
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 2
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0x21
	.sleb128 9
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x9
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
	.uleb128 0x21
	.sleb128 6
	.uleb128 0x27
	.uleb128 0x19
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
	.uleb128 0xa
	.uleb128 0x1d
	.byte	0x1
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x52
	.uleb128 0x1
	.uleb128 0x55
	.uleb128 0x17
	.uleb128 0x58
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x59
	.uleb128 0xb
	.uleb128 0x57
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0xb
	.uleb128 0x5
	.byte	0
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0xc
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
	.uleb128 0xd
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
	.uleb128 0xe
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
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
	.uleb128 0xf
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x10
	.uleb128 0x26
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x11
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x12
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
	.uleb128 0x13
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.byte	0
	.byte	0
	.uleb128 0x14
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x15
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x20
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x16
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
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
	.uleb128 0x17
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x7a
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x18
	.uleb128 0x5
	.byte	0
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
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
.LLST3:
	.byte	0x4
	.uleb128 .LVL7-.Ltext0
	.uleb128 .LVL8-.Ltext0
	.uleb128 0x1
	.byte	0x5a
	.byte	0x4
	.uleb128 .LVL8-.Ltext0
	.uleb128 .LFE2-.Ltext0
	.uleb128 0x1
	.byte	0x5a
	.byte	0
.LLST5:
	.byte	0x4
	.uleb128 .LVL8-.Ltext0
	.uleb128 .LVL9-.Ltext0
	.uleb128 0x1
	.byte	0x5d
	.byte	0
.LLST0:
	.byte	0x4
	.uleb128 .LVL1-.Ltext0
	.uleb128 .LVL3-.Ltext0
	.uleb128 0x1
	.byte	0x5b
	.byte	0x4
	.uleb128 .LVL3-.Ltext0
	.uleb128 .LFE1-.Ltext0
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
	.uleb128 .LVL4-.Ltext0
	.uleb128 .LVL5-.Ltext0
	.uleb128 0x1
	.byte	0x5c
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
	.section	.debug_rnglists,"",@progbits
.Ldebug_ranges0:
	.4byte	.Ldebug_ranges3-.Ldebug_ranges2
.Ldebug_ranges2:
	.2byte	0x5
	.byte	0x4
	.byte	0
	.4byte	0
.LLRL1:
	.byte	0x4
	.uleb128 .LBB8-.Ltext0
	.uleb128 .LBE8-.Ltext0
	.byte	0x4
	.uleb128 .LBB11-.Ltext0
	.uleb128 .LBE11-.Ltext0
	.byte	0
.LLRL4:
	.byte	0x4
	.uleb128 .LBB12-.Ltext0
	.uleb128 .LBE12-.Ltext0
	.byte	0x4
	.uleb128 .LBB15-.Ltext0
	.uleb128 .LBE15-.Ltext0
	.byte	0
.Ldebug_ranges3:
	.section	.debug_line,"",@progbits
.Ldebug_line0:
	.section	.debug_str,"MS",@progbits,1
.LASF19:
	.string	"valid"
.LASF18:
	.string	"oflow"
.LASF33:
	.string	"sin_tune"
.LASF16:
	.string	"uart_tx_t"
.LASF45:
	.string	"adc2_rx"
.LASF5:
	.string	"short int"
.LASF30:
	.string	"gpo_t"
.LASF49:
	.string	"csr_t"
.LASF26:
	.string	"rsvd_31_18"
.LASF13:
	.string	"rsvd_8_30"
.LASF29:
	.string	"rsvd_8_31"
.LASF41:
	.string	"uart_rx"
.LASF25:
	.string	"sample_cnt"
.LASF23:
	.string	"rsvd_16_30"
.LASF42:
	.string	"adc1_tx"
.LASF7:
	.string	"long long int"
.LASF6:
	.string	"long int"
.LASF24:
	.string	"adc_tx_t"
.LASF55:
	.string	"uart_send_char"
.LASF53:
	.string	"digits"
.LASF31:
	.string	"key_on"
.LASF11:
	.string	"long double"
.LASF46:
	.string	"dac1_tx"
.LASF8:
	.string	"unsigned char"
.LASF20:
	.string	"uart_rx_t"
.LASF4:
	.string	"signed char"
.LASF2:
	.string	"long long unsigned int"
.LASF34:
	.string	"rsvd_15_15"
.LASF15:
	.string	"uint32_t"
.LASF3:
	.string	"unsigned int"
.LASF39:
	.string	"misc_t"
.LASF22:
	.string	"test"
.LASF44:
	.string	"adc2_tx"
.LASF48:
	.string	"misc"
.LASF9:
	.string	"short unsigned int"
.LASF50:
	.string	"char"
.LASF36:
	.string	"rsvd_26_30"
.LASF12:
	.string	"data"
.LASF35:
	.string	"hann_step"
.LASF47:
	.string	"dac2_tx"
.LASF10:
	.string	"long unsigned int"
.LASF54:
	.string	"GNU C17 14.2.0 -mabi=ilp32 -mstrict-align -mcmodel=medlow -mrelax -mtune=rocket -misa-spec=20191213 -march=rv32i -g -O2 -ffreestanding -fno-builtin -fno-pic"
.LASF43:
	.string	"adc1_rx"
.LASF37:
	.string	"dac_tx_t"
.LASF40:
	.string	"uart_tx"
.LASF21:
	.string	"time_us"
.LASF52:
	.string	"uart_send_hex"
.LASF32:
	.string	"gpi_t"
.LASF14:
	.string	"busy"
.LASF27:
	.string	"adc_rx_t"
.LASF28:
	.string	"led_off"
.LASF38:
	.string	"error"
.LASF51:
	.string	"uart_send"
.LASF17:
	.string	"rsvd_8_29"
	.section	.debug_line_str,"MS",@progbits,1
.LASF0:
	.string	"/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/uart.c"
.LASF1:
	.string	"/home/tibrahimovic/projects/wireguard-fpga/3.build"
	.ident	"GCC: (g04696df0963) 14.2.0"
	.section	.note.GNU-stack,"",@progbits
