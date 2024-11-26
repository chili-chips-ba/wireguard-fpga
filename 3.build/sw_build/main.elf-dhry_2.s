	.file	"dhry_2.c"
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
	.file 0 "/home/tibrahimovic/projects/wireguard-fpga/3.build" "/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c"
	.align	2
	.globl	Proc_6
	.type	Proc_6, @function
Proc_6:
.LFB0:
	.file 1 "/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c"
	.loc 1 38 1
	.cfi_startproc
.LVL0:
	.loc 1 39 3
	.loc 1 40 3
.LBB7:
.LBB8:
.LBB9:
	.loc 1 184 3
	.loc 1 186 3
	.loc 1 187 3
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c:187:   if (Enum_Loc == Ident_3)
	.loc 1 187 6 is_stmt 0
	li	a5,2		# tmp138,
	beq	a0,a5,.L8	#, Enum_Val_Par, tmp138,
	.loc 1 191 5 is_stmt 1
.LVL1:
.LBE9:
.LBE8:
	.loc 1 42 5
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c:42:     *Enum_Ref_Par = Ident_4;
	.loc 1 42 19 is_stmt 0
	li	a4,3		# tmp140,
	sw	a4,0(a1)	# tmp140, *Enum_Ref_Par_5(D)
.LBE7:
	.loc 1 43 3 is_stmt 1
	li	a4,1		# tmp141,
	beq	a0,a4,.L4	#, Enum_Val_Par, tmp141,
	li	a4,4		# tmp142,
	beq	a0,a4,.L5	#, Enum_Val_Par, tmp142,
	beq	a0,zero,.L6	#, Enum_Val_Par,,
.L3:
.LVL2:
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c:62: } /* Proc_6 */
	.loc 1 62 1 is_stmt 0
	ret	
.LVL3:
.L4:
	.loc 1 49 7 is_stmt 1
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c:49:       if (Int_Glob > 100)
	.loc 1 49 20 is_stmt 0
	lui	a5,%hi(Int_Glob)	# tmp143,
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c:49:       if (Int_Glob > 100)
	.loc 1 49 10
	lw	a4,%lo(Int_Glob)(a5)		# Int_Glob, Int_Glob
	li	a5,100		# tmp145,
	ble	a4,a5,.L3	#, Int_Glob, tmp145,
.L6:
	.loc 1 51 7 is_stmt 1
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c:51:       *Enum_Ref_Par = Ident_1;
	.loc 1 51 21 is_stmt 0
	sw	zero,0(a1)	#, *Enum_Ref_Par_5(D)
	ret	
.LVL4:
.L8:
	.loc 1 43 3 is_stmt 1
	.loc 1 55 7
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c:55:       *Enum_Ref_Par = Ident_2;
	.loc 1 55 21 is_stmt 0
	li	a5,1		# tmp139,
	sw	a5,0(a1)	# tmp139, *Enum_Ref_Par_5(D)
	.loc 1 56 7 is_stmt 1
	ret	
.L5:
	.loc 1 59 7
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c:59:       *Enum_Ref_Par = Ident_3;
	.loc 1 59 21 is_stmt 0
	sw	a5,0(a1)	# tmp138, *Enum_Ref_Par_5(D)
	.loc 1 60 7 is_stmt 1
.LVL5:
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c:62: } /* Proc_6 */
	.loc 1 62 1 is_stmt 0
	ret	
	.cfi_endproc
.LFE0:
	.size	Proc_6, .-Proc_6
	.align	2
	.globl	Proc_7
	.type	Proc_7, @function
Proc_7:
.LFB1:
	.loc 1 77 1 is_stmt 1
	.cfi_startproc
.LVL6:
	.loc 1 78 3
	.loc 1 80 3
	.loc 1 81 3
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c:80:   Int_Loc = Int_1_Par_Val + 2;
	.loc 1 80 11 is_stmt 0
	addi	a0,a0,2	#, Int_Loc_3, tmp142
.LVL7:
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c:81:   *Int_Par_Ref = Int_2_Par_Val + Int_Loc;
	.loc 1 81 32
	add	a0,a0,a1	# tmp143, _1, Int_Loc_3
.LVL8:
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c:81:   *Int_Par_Ref = Int_2_Par_Val + Int_Loc;
	.loc 1 81 16
	sw	a0,0(a2)	# _1, *Int_Par_Ref_6(D)
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c:82: } /* Proc_7 */
	.loc 1 82 1
	ret	
	.cfi_endproc
.LFE1:
	.size	Proc_7, .-Proc_7
	.align	2
	.globl	Proc_8
	.type	Proc_8, @function
Proc_8:
.LFB2:
	.loc 1 94 1 is_stmt 1
	.cfi_startproc
.LVL9:
	.loc 1 95 3
	.loc 1 96 3
	.loc 1 98 3
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c:98:   Int_Loc = Int_1_Par_Val + 5;
	.loc 1 98 11 is_stmt 0
	addi	a4,a2,5	#, Int_Loc, Int_1_Par_Val
.LVL10:
	.loc 1 99 3 is_stmt 1
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c:103:     Arr_2_Par_Ref [Int_Loc] [Int_Index] = Int_Loc;
	.loc 1 103 19 is_stmt 0
	slli	a5,a4,1	#, tmp161, Int_Loc
	add	a5,a5,a4	# Int_Loc, tmp162, tmp161
	slli	a5,a5,3	#, tmp163, tmp162
	add	a5,a5,a4	# Int_Loc, _41, tmp163
	slli	a2,a2,2	#, _13, Int_1_Par_Val
.LVL11:
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c:99:   Arr_1_Par_Ref [Int_Loc] = Int_2_Par_Val;
	.loc 1 99 17
	slli	a6,a4,2	#, _2, Int_Loc
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c:103:     Arr_2_Par_Ref [Int_Loc] [Int_Index] = Int_Loc;
	.loc 1 103 19
	slli	a5,a5,3	#, tmp165, _41
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c:99:   Arr_1_Par_Ref [Int_Loc] = Int_2_Par_Val;
	.loc 1 99 17
	add	a0,a0,a6	# _2, _3, tmp175
.LVL12:
	add	a6,a2,a5	# tmp165, _14, _13
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c:99:   Arr_1_Par_Ref [Int_Loc] = Int_2_Par_Val;
	.loc 1 99 27
	sw	a3,0(a0)	# Int_2_Par_Val, *_3
	.loc 1 100 3 is_stmt 1
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c:100:   Arr_1_Par_Ref [Int_Loc+1] = Arr_1_Par_Ref [Int_Loc];
	.loc 1 100 29 is_stmt 0
	sw	a3,4(a0)	# Int_2_Par_Val, *_6
	.loc 1 101 3 is_stmt 1
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c:101:   Arr_1_Par_Ref [Int_Loc+30] = Int_Loc;
	.loc 1 101 30 is_stmt 0
	sw	a4,120(a0)	# Int_Loc, *_9
	.loc 1 102 3 is_stmt 1
.LVL13:
	.loc 1 102 39 discriminator 1
	.loc 1 103 5
	add	a3,a1,a6	# _14, _12, Arr_2_Par_Ref
.LVL14:
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c:104:   Arr_2_Par_Ref [Int_Loc] [Int_Loc-1] += 1;
	.loc 1 104 39 is_stmt 0
	lw	a6,16(a3)		# MEM <int> [(int[50] *)_12 + 16B], MEM <int> [(int[50] *)_12 + 16B]
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c:103:     Arr_2_Par_Ref [Int_Loc] [Int_Index] = Int_Loc;
	.loc 1 103 41
	sw	a4,20(a3)	# Int_Loc, MEM <int> [(int[50] *)_12 + 20B]
.LVL15:
	.loc 1 102 53 is_stmt 1 discriminator 3
	.loc 1 102 39 discriminator 1
	.loc 1 103 5
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c:103:     Arr_2_Par_Ref [Int_Loc] [Int_Index] = Int_Loc;
	.loc 1 103 41 is_stmt 0
	sw	a4,24(a3)	# Int_Loc, MEM <int> [(int[50] *)_12 + 24B]
	.loc 1 102 53 is_stmt 1 discriminator 3
.LVL16:
	.loc 1 102 39 discriminator 1
	.loc 1 104 3
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c:104:   Arr_2_Par_Ref [Int_Loc] [Int_Loc-1] += 1;
	.loc 1 104 39 is_stmt 0
	addi	a4,a6,1	#, _17, MEM <int> [(int[50] *)_12 + 16B]
.LVL17:
	sw	a4,16(a3)	# _17, MEM <int> [(int[50] *)_12 + 16B]
	.loc 1 105 3 is_stmt 1
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c:105:   Arr_2_Par_Ref [Int_Loc+20] [Int_Loc] = Arr_1_Par_Ref [Int_Loc];
	.loc 1 105 40 is_stmt 0
	add	a1,a1,a2	# _13, tmp170, Arr_2_Par_Ref
.LVL18:
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c:105:   Arr_2_Par_Ref [Int_Loc+20] [Int_Loc] = Arr_1_Par_Ref [Int_Loc];
	.loc 1 105 56
	lw	a2,0(a0)		# _20, *_3
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c:105:   Arr_2_Par_Ref [Int_Loc+20] [Int_Loc] = Arr_1_Par_Ref [Int_Loc];
	.loc 1 105 40
	add	a1,a1,a5	# tmp165, tmp169, tmp170
	li	a5,4096		# tmp171,
	add	a5,a5,a1	# tmp169, tmp172, tmp171
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c:106:   Int_Glob = 5;
	.loc 1 106 12
	lui	a4,%hi(Int_Glob)	# tmp173,
	li	a3,5		# tmp174,
.LVL19:
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c:105:   Arr_2_Par_Ref [Int_Loc+20] [Int_Loc] = Arr_1_Par_Ref [Int_Loc];
	.loc 1 105 40
	sw	a2,-76(a5)	# _20, MEM <int> [(int[50] *)_10 + 20B]
	.loc 1 106 3 is_stmt 1
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c:106:   Int_Glob = 5;
	.loc 1 106 12 is_stmt 0
	sw	a3,%lo(Int_Glob)(a4)	# tmp174, Int_Glob
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c:107: } /* Proc_8 */
	.loc 1 107 1
	ret	
	.cfi_endproc
.LFE2:
	.size	Proc_8, .-Proc_8
	.align	2
	.globl	Func_1
	.type	Func_1, @function
Func_1:
.LFB3:
	.loc 1 119 1 is_stmt 1
	.cfi_startproc
.LVL20:
	.loc 1 120 3
	.loc 1 121 3
	.loc 1 123 3
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c:119: {
	.loc 1 119 1 is_stmt 0
	andi	a0,a0,0xff	# Ch_1_Par_Val, tmp141
.LVL21:
	.loc 1 124 3 is_stmt 1
	.loc 1 125 3
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c:119: {
	.loc 1 119 1 is_stmt 0
	andi	a1,a1,0xff	# Ch_2_Par_Val, tmp142
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c:125:   if (Ch_2_Loc != Ch_2_Par_Val)
	.loc 1 125 6
	beq	a0,a1,.L14	#, Ch_1_Par_Val, Ch_2_Par_Val,
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c:127:     return (Ident_1);
	.loc 1 127 12
	li	a0,0		# <retval>,
.LVL22:
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c:133: } /* Func_1 */
	.loc 1 133 1
	ret	
.LVL23:
.L14:
	.loc 1 130 5 is_stmt 1
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c:130:     Ch_1_Glob = Ch_1_Loc;
	.loc 1 130 15 is_stmt 0
	lui	a5,%hi(Ch_1_Glob)	# tmp139,
	sb	a0,%lo(Ch_1_Glob)(a5)	# Ch_1_Par_Val, Ch_1_Glob
	.loc 1 131 5 is_stmt 1
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c:131:     return (Ident_2);
	.loc 1 131 12 is_stmt 0
	li	a0,1		# <retval>,
.LVL24:
	ret	
	.cfi_endproc
.LFE3:
	.size	Func_1, .-Func_1
	.align	2
	.globl	Func_2
	.type	Func_2, @function
Func_2:
.LFB4:
	.loc 1 144 1 is_stmt 1
	.cfi_startproc
.LVL25:
	.loc 1 145 3
	.loc 1 146 7
	.loc 1 148 3
	.loc 1 149 3
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c:144: {
	.loc 1 144 1 is_stmt 0
	addi	sp,sp,-16	#,,
	.cfi_def_cfa_offset 16
	sw	ra,12(sp)	#,
	.cfi_offset 1, -4
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c:150:     if (Func_1 (Str_1_Par_Ref[Int_Loc],
	.loc 1 150 30
	lbu	a4,2(a0)	# _2, MEM[(char *)Str_1_Par_Ref_12(D) + 2B]
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c:151:                 Str_2_Par_Ref[Int_Loc+1]) == Ident_1)
	.loc 1 151 30
	lbu	a5,3(a1)	# _5, MEM[(char *)Str_2_Par_Ref_13(D) + 3B]
.L16:
.LVL26:
	.loc 1 149 18 is_stmt 1
	.loc 1 150 5
.LBB10:
.LBB11:
	.loc 1 120 3
	.loc 1 121 3
	.loc 1 123 3
	.loc 1 124 3
	.loc 1 125 3
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c:125:   if (Ch_2_Loc != Ch_2_Par_Val)
	.loc 1 125 6 is_stmt 0
	beq	a4,a5,.L16	#, _2, _5,
.LVL27:
.LBE11:
.LBE10:
	.loc 1 149 18 is_stmt 1
	.loc 1 157 3
	.loc 1 160 3
	.loc 1 165 5
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c:165:     if (strcmp (Str_1_Par_Ref, Str_2_Par_Ref) > 0)
	.loc 1 165 9 is_stmt 0
	call	strcmp		#
.LVL28:
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c:173:       return (false);
	.loc 1 173 14
	li	a5,0		# <retval>,
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c:165:     if (strcmp (Str_1_Par_Ref, Str_2_Par_Ref) > 0)
	.loc 1 165 8 discriminator 1
	ble	a0,zero,.L15	#, tmp145,,
	.loc 1 168 7 is_stmt 1
.LVL29:
	.loc 1 169 7
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c:169:       Int_Glob = Int_Loc;
	.loc 1 169 16 is_stmt 0
	lui	a5,%hi(Int_Glob)	# tmp140,
	li	a4,10		# tmp141,
	sw	a4,%lo(Int_Glob)(a5)	# tmp141, Int_Glob
	.loc 1 170 7 is_stmt 1
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c:170:       return (true);
	.loc 1 170 14 is_stmt 0
	li	a5,1		# <retval>,
.LVL30:
.L15:
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c:175: } /* Func_2 */
	.loc 1 175 1
	lw	ra,12(sp)		#,
	.cfi_restore 1
	mv	a0,a5	#, <retval>
	addi	sp,sp,16	#,,
	.cfi_def_cfa_offset 0
	jr	ra		#
	.cfi_endproc
.LFE4:
	.size	Func_2, .-Func_2
	.align	2
	.globl	Func_3
	.type	Func_3, @function
Func_3:
.LFB5:
	.loc 1 183 1 is_stmt 1
	.cfi_startproc
.LVL31:
	.loc 1 184 3
	.loc 1 186 3
	.loc 1 187 3
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c:187:   if (Enum_Loc == Ident_3)
	.loc 1 187 6 is_stmt 0
	addi	a0,a0,-2	#, tmp140, tmp141
.LVL32:
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c:192: } /* Func_3 */
	.loc 1 192 1
	seqz	a0,a0	#, tmp140
.LVL33:
	ret	
	.cfi_endproc
.LFE5:
	.size	Func_3, .-Func_3
.Letext0:
	.file 2 "/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry.h"
	.file 3 "/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/soc.h"
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.4byte	0x3eb
	.2byte	0x5
	.byte	0x1
	.byte	0x4
	.4byte	.Ldebug_abbrev0
	.uleb128 0x11
	.4byte	.LASF49
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
	.byte	0x8
	.4byte	.LASF4
	.uleb128 0x12
	.byte	0x7
	.byte	0x4
	.4byte	0x2d
	.byte	0x2
	.2byte	0x185
	.byte	0x10
	.4byte	0x69
	.uleb128 0x5
	.4byte	.LASF5
	.byte	0
	.uleb128 0x5
	.4byte	.LASF6
	.byte	0x1
	.uleb128 0x5
	.4byte	.LASF7
	.byte	0x2
	.uleb128 0x5
	.4byte	.LASF8
	.byte	0x3
	.uleb128 0x5
	.4byte	.LASF9
	.byte	0x4
	.byte	0
	.uleb128 0x6
	.4byte	.LASF16
	.2byte	0x186
	.byte	0x11
	.4byte	0x3b
	.uleb128 0x1
	.byte	0x1
	.byte	0x6
	.4byte	.LASF10
	.uleb128 0x1
	.byte	0x2
	.byte	0x5
	.4byte	.LASF11
	.uleb128 0x1
	.byte	0x4
	.byte	0x5
	.4byte	.LASF12
	.uleb128 0x1
	.byte	0x8
	.byte	0x5
	.4byte	.LASF13
	.uleb128 0x1
	.byte	0x2
	.byte	0x7
	.4byte	.LASF14
	.uleb128 0x1
	.byte	0x4
	.byte	0x7
	.4byte	.LASF15
	.uleb128 0x13
	.byte	0x4
	.byte	0x5
	.string	"int"
	.uleb128 0x6
	.4byte	.LASF17
	.2byte	0x195
	.byte	0xd
	.4byte	0x9f
	.uleb128 0x6
	.4byte	.LASF18
	.2byte	0x196
	.byte	0xd
	.4byte	0x9f
	.uleb128 0x6
	.4byte	.LASF19
	.2byte	0x197
	.byte	0xe
	.4byte	0xca
	.uleb128 0x1
	.byte	0x1
	.byte	0x8
	.4byte	.LASF20
	.uleb128 0x14
	.4byte	0xca
	.uleb128 0x6
	.4byte	.LASF21
	.2byte	0x198
	.byte	0xd
	.4byte	0x9f
	.uleb128 0x15
	.4byte	0x9f
	.4byte	0xf2
	.uleb128 0x16
	.4byte	0x2d
	.byte	0x31
	.byte	0
	.uleb128 0x1
	.byte	0x10
	.byte	0x4
	.4byte	.LASF22
	.uleb128 0xd
	.4byte	.LASF23
	.byte	0x1b
	.byte	0xc
	.4byte	0x9f
	.uleb128 0xd
	.4byte	.LASF24
	.byte	0x1c
	.byte	0xd
	.4byte	0xca
	.uleb128 0x17
	.4byte	.LASF50
	.byte	0x3
	.byte	0x17
	.byte	0x5
	.4byte	0x9f
	.4byte	0x12a
	.uleb128 0xe
	.4byte	0x12a
	.uleb128 0xe
	.4byte	0x12a
	.byte	0
	.uleb128 0x3
	.4byte	0xd1
	.uleb128 0xf
	.4byte	.LASF29
	.byte	0xb2
	.byte	0x9
	.4byte	0xd6
	.4byte	0x155
	.uleb128 0xa
	.4byte	.LASF31
	.byte	0xb6
	.byte	0xd
	.4byte	0x69
	.uleb128 0xb
	.4byte	.LASF34
	.byte	0xb8
	.byte	0xf
	.4byte	0x69
	.byte	0
	.uleb128 0x8
	.4byte	.LASF37
	.byte	0x88
	.byte	0x9
	.4byte	0xd6
	.4byte	.LFB4
	.4byte	.LFE4-.LFB4
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x206
	.uleb128 0x2
	.4byte	.LASF25
	.byte	0x8e
	.byte	0x8
	.4byte	0x206
	.4byte	.LLST14
	.uleb128 0x2
	.4byte	.LASF26
	.byte	0x8f
	.byte	0x8
	.4byte	0x206
	.4byte	.LLST15
	.uleb128 0x9
	.4byte	.LASF27
	.byte	0x91
	.byte	0xe
	.4byte	0xa6
	.4byte	.LLST16
	.uleb128 0x18
	.4byte	.LASF28
	.byte	0x1
	.byte	0x92
	.byte	0x16
	.4byte	0xbe
	.byte	0x41
	.uleb128 0x19
	.4byte	0x20b
	.4byte	.LBB10
	.4byte	.LBE10-.LBB10
	.byte	0x1
	.byte	0x96
	.byte	0x9
	.4byte	0x1e1
	.uleb128 0x7
	.4byte	0x21a
	.4byte	.LLST17
	.uleb128 0x7
	.4byte	0x225
	.4byte	.LLST18
	.uleb128 0x4
	.4byte	0x230
	.4byte	.LLST19
	.uleb128 0x4
	.4byte	0x23b
	.4byte	.LLST19
	.byte	0
	.uleb128 0x1a
	.4byte	.LVL28
	.4byte	0x10f
	.uleb128 0x10
	.uleb128 0x1
	.byte	0x5a
	.uleb128 0x9
	.byte	0xa3
	.uleb128 0x3
	.byte	0xa5
	.uleb128 0xa
	.uleb128 0x26
	.byte	0xa8
	.uleb128 0x2d
	.byte	0xa8
	.uleb128 0
	.uleb128 0x10
	.uleb128 0x1
	.byte	0x5b
	.uleb128 0x9
	.byte	0xa3
	.uleb128 0x3
	.byte	0xa5
	.uleb128 0xb
	.uleb128 0x26
	.byte	0xa8
	.uleb128 0x2d
	.byte	0xa8
	.uleb128 0
	.byte	0
	.byte	0
	.uleb128 0x3
	.4byte	0xca
	.uleb128 0xf
	.4byte	.LASF30
	.byte	0x6e
	.byte	0xd
	.4byte	0x69
	.4byte	0x247
	.uleb128 0xa
	.4byte	.LASF32
	.byte	0x75
	.byte	0x10
	.4byte	0xbe
	.uleb128 0xa
	.4byte	.LASF33
	.byte	0x76
	.byte	0x10
	.4byte	0xbe
	.uleb128 0xb
	.4byte	.LASF35
	.byte	0x78
	.byte	0x12
	.4byte	0xbe
	.uleb128 0xb
	.4byte	.LASF36
	.byte	0x79
	.byte	0x12
	.4byte	0xbe
	.byte	0
	.uleb128 0x8
	.4byte	.LASF38
	.byte	0x55
	.byte	0x1
	.4byte	0x9f
	.4byte	.LFB2
	.4byte	.LFE2-.LFB2
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x2bb
	.uleb128 0x2
	.4byte	.LASF39
	.byte	0x5a
	.byte	0xb
	.4byte	0x2bb
	.4byte	.LLST5
	.uleb128 0x2
	.4byte	.LASF40
	.byte	0x5b
	.byte	0xb
	.4byte	0x2c0
	.4byte	.LLST6
	.uleb128 0x2
	.4byte	.LASF41
	.byte	0x5c
	.byte	0x5
	.4byte	0x9f
	.4byte	.LLST7
	.uleb128 0x2
	.4byte	.LASF42
	.byte	0x5d
	.byte	0x5
	.4byte	0x9f
	.4byte	.LLST8
	.uleb128 0x9
	.4byte	.LASF43
	.byte	0x5f
	.byte	0xd
	.4byte	0xb2
	.4byte	.LLST9
	.uleb128 0x9
	.4byte	.LASF27
	.byte	0x60
	.byte	0xd
	.4byte	0xb2
	.4byte	.LLST10
	.byte	0
	.uleb128 0x3
	.4byte	0x9f
	.uleb128 0x3
	.4byte	0xe2
	.uleb128 0x8
	.4byte	.LASF44
	.byte	0x41
	.byte	0x1
	.4byte	0x9f
	.4byte	.LFB1
	.4byte	.LFE1-.LFB1
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x317
	.uleb128 0x2
	.4byte	.LASF41
	.byte	0x4a
	.byte	0xb
	.4byte	0xb2
	.4byte	.LLST3
	.uleb128 0xc
	.4byte	.LASF42
	.byte	0x4b
	.byte	0xb
	.4byte	0xb2
	.uleb128 0x1
	.byte	0x5b
	.uleb128 0xc
	.4byte	.LASF45
	.byte	0x4c
	.byte	0xc
	.4byte	0x317
	.uleb128 0x1
	.byte	0x5c
	.uleb128 0x9
	.4byte	.LASF27
	.byte	0x4e
	.byte	0xd
	.4byte	0xb2
	.4byte	.LLST4
	.byte	0
	.uleb128 0x3
	.4byte	0xb2
	.uleb128 0x8
	.4byte	.LASF46
	.byte	0x1f
	.byte	0x1
	.4byte	0x9f
	.4byte	.LFB0
	.4byte	.LFE0-.LFB0
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x391
	.uleb128 0x2
	.4byte	.LASF47
	.byte	0x24
	.byte	0xd
	.4byte	0x69
	.4byte	.LLST0
	.uleb128 0xc
	.4byte	.LASF48
	.byte	0x25
	.byte	0xe
	.4byte	0x391
	.uleb128 0x1
	.byte	0x5b
	.uleb128 0x1b
	.4byte	.LBB7
	.4byte	.LBE7-.LBB7
	.uleb128 0x1c
	.4byte	.LASF29
	.byte	0x1
	.byte	0x28
	.byte	0x9
	.4byte	0x9f
	.4byte	0x36c
	.uleb128 0x1d
	.byte	0
	.uleb128 0x1e
	.4byte	0x12f
	.4byte	.LBB8
	.4byte	.LBE8-.LBB8
	.byte	0x1
	.byte	0x28
	.byte	0x9
	.uleb128 0x7
	.4byte	0x13e
	.4byte	.LLST1
	.uleb128 0x4
	.4byte	0x149
	.4byte	.LLST2
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x3
	.4byte	0x69
	.uleb128 0x1f
	.4byte	0x20b
	.4byte	.LFB3
	.4byte	.LFE3-.LFB3
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x3cc
	.uleb128 0x7
	.4byte	0x21a
	.4byte	.LLST11
	.uleb128 0x20
	.4byte	0x225
	.uleb128 0x1
	.byte	0x5b
	.uleb128 0x4
	.4byte	0x230
	.4byte	.LLST12
	.uleb128 0x4
	.4byte	0x23b
	.4byte	.LLST13
	.byte	0
	.uleb128 0x21
	.4byte	0x12f
	.4byte	.LFB5
	.4byte	.LFE5-.LFB5
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0x7
	.4byte	0x13e
	.4byte	.LLST21
	.uleb128 0x4
	.4byte	0x149
	.4byte	.LLST22
	.byte	0
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
	.uleb128 0xe
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
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0x21
	.sleb128 4
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x4
	.uleb128 0x34
	.byte	0
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x5
	.uleb128 0x28
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x1c
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x6
	.uleb128 0x16
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 2
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x7
	.uleb128 0x5
	.byte	0
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x8
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
	.uleb128 0x9
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
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
	.uleb128 0xa
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xb
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xc
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
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
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0xd
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3c
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0xe
	.uleb128 0x5
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xf
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
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x20
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x10
	.uleb128 0x49
	.byte	0
	.uleb128 0x2
	.uleb128 0x18
	.uleb128 0x7e
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x11
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
	.uleb128 0x12
	.uleb128 0x4
	.byte	0x1
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x13
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
	.uleb128 0x14
	.uleb128 0x26
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x15
	.uleb128 0x1
	.byte	0x1
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x16
	.uleb128 0x21
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2f
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x17
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
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3c
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x18
	.uleb128 0x34
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
	.uleb128 0x1c
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x19
	.uleb128 0x1d
	.byte	0x1
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x58
	.uleb128 0xb
	.uleb128 0x59
	.uleb128 0xb
	.uleb128 0x57
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x1a
	.uleb128 0x48
	.byte	0x1
	.uleb128 0x7d
	.uleb128 0x1
	.uleb128 0x7f
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x1b
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.byte	0
	.byte	0
	.uleb128 0x1c
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
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3c
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x1d
	.uleb128 0x18
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x1e
	.uleb128 0x1d
	.byte	0x1
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x58
	.uleb128 0xb
	.uleb128 0x59
	.uleb128 0xb
	.uleb128 0x57
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x1f
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
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x20
	.uleb128 0x5
	.byte	0
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x21
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
	.byte	0
	.section	.debug_loclists,"",@progbits
	.4byte	.Ldebug_loc3-.Ldebug_loc2
.Ldebug_loc2:
	.2byte	0x5
	.byte	0x4
	.byte	0
	.4byte	0
.Ldebug_loc0:
.LLST14:
	.byte	0x4
	.uleb128 .LVL25-.Ltext0
	.uleb128 .LVL28-1-.Ltext0
	.uleb128 0x1
	.byte	0x5a
	.byte	0x4
	.uleb128 .LVL28-1-.Ltext0
	.uleb128 .LFE4-.Ltext0
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
.LLST15:
	.byte	0x4
	.uleb128 .LVL25-.Ltext0
	.uleb128 .LVL28-1-.Ltext0
	.uleb128 0x1
	.byte	0x5b
	.byte	0x4
	.uleb128 .LVL28-1-.Ltext0
	.uleb128 .LFE4-.Ltext0
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
.LLST16:
	.byte	0x4
	.uleb128 .LVL25-.Ltext0
	.uleb128 .LVL27-.Ltext0
	.uleb128 0x2
	.byte	0x32
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL27-.Ltext0
	.uleb128 .LVL29-.Ltext0
	.uleb128 0x2
	.byte	0x33
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL29-.Ltext0
	.uleb128 .LVL30-.Ltext0
	.uleb128 0x2
	.byte	0x3a
	.byte	0x9f
	.byte	0
.LLST17:
	.byte	0x4
	.uleb128 .LVL26-.Ltext0
	.uleb128 .LVL27-.Ltext0
	.uleb128 0x2
	.byte	0x7a
	.sleb128 2
	.byte	0
.LLST18:
	.byte	0x4
	.uleb128 .LVL26-.Ltext0
	.uleb128 .LVL27-.Ltext0
	.uleb128 0x2
	.byte	0x7b
	.sleb128 3
	.byte	0
.LLST19:
	.byte	0x4
	.uleb128 .LVL26-.Ltext0
	.uleb128 .LVL28-1-.Ltext0
	.uleb128 0x2
	.byte	0x7a
	.sleb128 2
	.byte	0
.LLST5:
	.byte	0x4
	.uleb128 .LVL9-.Ltext0
	.uleb128 .LVL12-.Ltext0
	.uleb128 0x1
	.byte	0x5a
	.byte	0x4
	.uleb128 .LVL12-.Ltext0
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
.LLST6:
	.byte	0x4
	.uleb128 .LVL9-.Ltext0
	.uleb128 .LVL18-.Ltext0
	.uleb128 0x1
	.byte	0x5b
	.byte	0x4
	.uleb128 .LVL18-.Ltext0
	.uleb128 .LFE2-.Ltext0
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
.LLST7:
	.byte	0x4
	.uleb128 .LVL9-.Ltext0
	.uleb128 .LVL11-.Ltext0
	.uleb128 0x1
	.byte	0x5c
	.byte	0x4
	.uleb128 .LVL11-.Ltext0
	.uleb128 .LVL17-.Ltext0
	.uleb128 0x3
	.byte	0x7e
	.sleb128 -5
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL17-.Ltext0
	.uleb128 .LVL19-.Ltext0
	.uleb128 0x6
	.byte	0x7d
	.sleb128 20
	.byte	0x6
	.byte	0x35
	.byte	0x1c
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL19-.Ltext0
	.uleb128 .LFE2-.Ltext0
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
.LLST8:
	.byte	0x4
	.uleb128 .LVL9-.Ltext0
	.uleb128 .LVL14-.Ltext0
	.uleb128 0x1
	.byte	0x5d
	.byte	0x4
	.uleb128 .LVL14-.Ltext0
	.uleb128 .LVL15-.Ltext0
	.uleb128 0x2
	.byte	0x7a
	.sleb128 0
	.byte	0x4
	.uleb128 .LVL15-.Ltext0
	.uleb128 .LFE2-.Ltext0
	.uleb128 0xa
	.byte	0xa3
	.uleb128 0x3
	.byte	0xa5
	.uleb128 0xd
	.uleb128 0x26
	.byte	0xa8
	.uleb128 0x2d
	.byte	0xa8
	.uleb128 0
	.byte	0x9f
	.byte	0
.LLST9:
	.byte	0x4
	.uleb128 .LVL13-.Ltext0
	.uleb128 .LVL15-.Ltext0
	.uleb128 0x1
	.byte	0x5e
	.byte	0x4
	.uleb128 .LVL15-.Ltext0
	.uleb128 .LVL16-.Ltext0
	.uleb128 0x3
	.byte	0x7e
	.sleb128 1
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL16-.Ltext0
	.uleb128 .LVL17-.Ltext0
	.uleb128 0x3
	.byte	0x7e
	.sleb128 2
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL17-.Ltext0
	.uleb128 .LVL19-.Ltext0
	.uleb128 0x6
	.byte	0x7d
	.sleb128 20
	.byte	0x6
	.byte	0x23
	.uleb128 0x2
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL19-.Ltext0
	.uleb128 .LFE2-.Ltext0
	.uleb128 0xc
	.byte	0xa3
	.uleb128 0x3
	.byte	0xa5
	.uleb128 0xc
	.uleb128 0x26
	.byte	0xa8
	.uleb128 0x2d
	.byte	0xa8
	.uleb128 0
	.byte	0x23
	.uleb128 0x7
	.byte	0x9f
	.byte	0
.LLST10:
	.byte	0x4
	.uleb128 .LVL10-.Ltext0
	.uleb128 .LVL17-.Ltext0
	.uleb128 0x1
	.byte	0x5e
	.byte	0x4
	.uleb128 .LVL17-.Ltext0
	.uleb128 .LVL19-.Ltext0
	.uleb128 0x2
	.byte	0x7d
	.sleb128 20
	.byte	0x4
	.uleb128 .LVL19-.Ltext0
	.uleb128 .LFE2-.Ltext0
	.uleb128 0xc
	.byte	0xa3
	.uleb128 0x3
	.byte	0xa5
	.uleb128 0xc
	.uleb128 0x26
	.byte	0xa8
	.uleb128 0x2d
	.byte	0xa8
	.uleb128 0
	.byte	0x23
	.uleb128 0x5
	.byte	0x9f
	.byte	0
.LLST3:
	.byte	0x4
	.uleb128 .LVL6-.Ltext0
	.uleb128 .LVL7-.Ltext0
	.uleb128 0x1
	.byte	0x5a
	.byte	0x4
	.uleb128 .LVL7-.Ltext0
	.uleb128 .LVL8-.Ltext0
	.uleb128 0x3
	.byte	0x7a
	.sleb128 -2
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL8-.Ltext0
	.uleb128 .LFE1-.Ltext0
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
.LLST4:
	.byte	0x4
	.uleb128 .LVL6-.Ltext0
	.uleb128 .LVL7-.Ltext0
	.uleb128 0x3
	.byte	0x7a
	.sleb128 2
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL7-.Ltext0
	.uleb128 .LVL8-.Ltext0
	.uleb128 0x1
	.byte	0x5a
	.byte	0x4
	.uleb128 .LVL8-.Ltext0
	.uleb128 .LFE1-.Ltext0
	.uleb128 0xc
	.byte	0xa3
	.uleb128 0x3
	.byte	0xa5
	.uleb128 0xa
	.uleb128 0x26
	.byte	0xa8
	.uleb128 0x2d
	.byte	0xa8
	.uleb128 0
	.byte	0x23
	.uleb128 0x2
	.byte	0x9f
	.byte	0
.LLST0:
	.byte	0x4
	.uleb128 .LVL0-.Ltext0
	.uleb128 .LVL2-.Ltext0
	.uleb128 0x1
	.byte	0x5a
	.byte	0x4
	.uleb128 .LVL2-.Ltext0
	.uleb128 .LVL3-.Ltext0
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
	.uleb128 .LVL3-.Ltext0
	.uleb128 .LVL5-.Ltext0
	.uleb128 0x1
	.byte	0x5a
	.byte	0x4
	.uleb128 .LVL5-.Ltext0
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
	.byte	0x5a
	.byte	0
.LLST2:
	.byte	0x4
	.uleb128 .LVL0-.Ltext0
	.uleb128 .LVL2-.Ltext0
	.uleb128 0x1
	.byte	0x5a
	.byte	0x4
	.uleb128 .LVL2-.Ltext0
	.uleb128 .LVL3-.Ltext0
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
	.uleb128 .LVL3-.Ltext0
	.uleb128 .LVL5-.Ltext0
	.uleb128 0x1
	.byte	0x5a
	.byte	0x4
	.uleb128 .LVL5-.Ltext0
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
.LLST11:
	.byte	0x4
	.uleb128 .LVL20-.Ltext0
	.uleb128 .LVL22-.Ltext0
	.uleb128 0x1
	.byte	0x5a
	.byte	0x4
	.uleb128 .LVL22-.Ltext0
	.uleb128 .LFE3-.Ltext0
	.uleb128 0xa
	.byte	0xa3
	.uleb128 0x3
	.byte	0xa5
	.uleb128 0xa
	.uleb128 0x26
	.byte	0xa8
	.uleb128 0x34
	.byte	0xa8
	.uleb128 0
	.byte	0x9f
	.byte	0
.LLST12:
	.byte	0x4
	.uleb128 .LVL21-.Ltext0
	.uleb128 .LVL22-.Ltext0
	.uleb128 0x1
	.byte	0x5a
	.byte	0x4
	.uleb128 .LVL22-.Ltext0
	.uleb128 .LVL23-.Ltext0
	.uleb128 0xa
	.byte	0xa3
	.uleb128 0x3
	.byte	0xa5
	.uleb128 0xa
	.uleb128 0x26
	.byte	0xa8
	.uleb128 0x34
	.byte	0xa8
	.uleb128 0
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL23-.Ltext0
	.uleb128 .LVL24-.Ltext0
	.uleb128 0x1
	.byte	0x5a
	.byte	0
.LLST13:
	.byte	0x4
	.uleb128 .LVL21-.Ltext0
	.uleb128 .LVL22-.Ltext0
	.uleb128 0x1
	.byte	0x5a
	.byte	0x4
	.uleb128 .LVL22-.Ltext0
	.uleb128 .LVL23-.Ltext0
	.uleb128 0xa
	.byte	0xa3
	.uleb128 0x3
	.byte	0xa5
	.uleb128 0xa
	.uleb128 0x26
	.byte	0xa8
	.uleb128 0x34
	.byte	0xa8
	.uleb128 0
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL23-.Ltext0
	.uleb128 .LVL24-.Ltext0
	.uleb128 0x1
	.byte	0x5a
	.byte	0
.LLST21:
	.byte	0x4
	.uleb128 .LVL31-.Ltext0
	.uleb128 .LVL32-.Ltext0
	.uleb128 0x1
	.byte	0x5a
	.byte	0x4
	.uleb128 .LVL32-.Ltext0
	.uleb128 .LVL33-.Ltext0
	.uleb128 0x3
	.byte	0x7a
	.sleb128 2
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL33-.Ltext0
	.uleb128 .LFE5-.Ltext0
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
.LLST22:
	.byte	0x4
	.uleb128 .LVL31-.Ltext0
	.uleb128 .LVL32-.Ltext0
	.uleb128 0x1
	.byte	0x5a
	.byte	0x4
	.uleb128 .LVL32-.Ltext0
	.uleb128 .LVL33-.Ltext0
	.uleb128 0x3
	.byte	0x7a
	.sleb128 2
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL33-.Ltext0
	.uleb128 .LFE5-.Ltext0
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
.LASF6:
	.string	"Ident_2"
.LASF7:
	.string	"Ident_3"
.LASF8:
	.string	"Ident_4"
.LASF9:
	.string	"Ident_5"
.LASF25:
	.string	"Str_1_Par_Ref"
.LASF17:
	.string	"One_Thirty"
.LASF26:
	.string	"Str_2_Par_Ref"
.LASF11:
	.string	"short int"
.LASF39:
	.string	"Arr_1_Par_Ref"
.LASF40:
	.string	"Arr_2_Par_Ref"
.LASF24:
	.string	"Ch_1_Glob"
.LASF32:
	.string	"Ch_1_Par_Val"
.LASF13:
	.string	"long long int"
.LASF33:
	.string	"Ch_2_Par_Val"
.LASF12:
	.string	"long int"
.LASF23:
	.string	"Int_Glob"
.LASF41:
	.string	"Int_1_Par_Val"
.LASF22:
	.string	"long double"
.LASF4:
	.string	"unsigned char"
.LASF42:
	.string	"Int_2_Par_Val"
.LASF35:
	.string	"Ch_1_Loc"
.LASF10:
	.string	"signed char"
.LASF2:
	.string	"long long unsigned int"
.LASF3:
	.string	"unsigned int"
.LASF38:
	.string	"Proc_8"
.LASF19:
	.string	"Capital_Letter"
.LASF14:
	.string	"short unsigned int"
.LASF21:
	.string	"Boolean"
.LASF46:
	.string	"Proc_6"
.LASF44:
	.string	"Proc_7"
.LASF20:
	.string	"char"
.LASF47:
	.string	"Enum_Val_Par"
.LASF28:
	.string	"Ch_Loc"
.LASF34:
	.string	"Enum_Loc"
.LASF15:
	.string	"long unsigned int"
.LASF49:
	.string	"GNU C17 14.2.0 -mabi=ilp32 -mstrict-align -mcmodel=medlow -mrelax -mtune=rocket -misa-spec=20191213 -march=rv32i -g -O2 -ffreestanding -fno-builtin -fno-pic"
.LASF31:
	.string	"Enum_Par_Val"
.LASF45:
	.string	"Int_Par_Ref"
.LASF43:
	.string	"Int_Index"
.LASF18:
	.string	"One_Fifty"
.LASF16:
	.string	"Enumeration"
.LASF50:
	.string	"strcmp"
.LASF36:
	.string	"Ch_2_Loc"
.LASF48:
	.string	"Enum_Ref_Par"
.LASF27:
	.string	"Int_Loc"
.LASF30:
	.string	"Func_1"
.LASF37:
	.string	"Func_2"
.LASF29:
	.string	"Func_3"
.LASF5:
	.string	"Ident_1"
	.section	.debug_line_str,"MS",@progbits,1
.LASF0:
	.string	"/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_2.c"
.LASF1:
	.string	"/home/tibrahimovic/projects/wireguard-fpga/3.build"
	.ident	"GCC: (g04696df0963) 14.2.0"
	.section	.note.GNU-stack,"",@progbits
