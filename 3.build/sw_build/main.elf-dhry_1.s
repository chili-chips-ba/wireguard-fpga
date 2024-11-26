	.file	"dhry_1.c"
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
	.file 0 "/home/tibrahimovic/projects/wireguard-fpga/3.build" "/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c"
	.align	2
	.globl	strcpy
	.type	strcpy, @function
strcpy:
.LFB0:
	.file 1 "/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c"
	.loc 1 77 43
	.cfi_startproc
.LVL0:
	.loc 1 78 5
	.loc 1 79 5
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:79:     while ((*dest++ = *src++) != '\0');
	.loc 1 79 11 is_stmt 0
	mv	a5,a0	# dest, dest
.LVL1:
.L2:
	.loc 1 79 31 is_stmt 1 discriminator 1
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:79:     while ((*dest++ = *src++) != '\0');
	.loc 1 79 23 is_stmt 0 discriminator 1
	lbu	a4,0(a1)	# _1, MEM[(const char *)src_8 + 4294967295B]
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:79:     while ((*dest++ = *src++) != '\0');
	.loc 1 79 27 discriminator 1
	addi	a1,a1,1	#, src, src
.LVL2:
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:79:     while ((*dest++ = *src++) != '\0');
	.loc 1 79 18 discriminator 1
	addi	a5,a5,1	#, dest, dest
.LVL3:
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:79:     while ((*dest++ = *src++) != '\0');
	.loc 1 79 21 discriminator 1
	sb	a4,-1(a5)	# _1, MEM[(char *)dest_9 + 4294967295B]
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:79:     while ((*dest++ = *src++) != '\0');
	.loc 1 79 31 discriminator 1
	bne	a4,zero,.L2	#, _1,,
	.loc 1 80 5 is_stmt 1
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:81: }
	.loc 1 81 1 is_stmt 0
	ret	
	.cfi_endproc
.LFE0:
	.size	strcpy, .-strcpy
	.align	2
	.globl	Proc_1
	.type	Proc_1, @function
Proc_1:
.LFB2:
	.loc 1 329 1 is_stmt 1
	.cfi_startproc
.LVL4:
	.loc 1 330 3
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:329: {
	.loc 1 329 1 is_stmt 0
	addi	sp,sp,-16	#,,
	.cfi_def_cfa_offset 16
	sw	s2,0(sp)	#,
	.cfi_offset 18, -16
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:335:   structassign (*Ptr_Val_Par->Ptr_Comp, *Ptr_Glob); 
	.loc 1 335 28
	lui	s2,%hi(Ptr_Glob)	# tmp151,
	lw	a5,%lo(Ptr_Glob)(s2)		# Ptr_Glob.14_1, Ptr_Glob
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:329: {
	.loc 1 329 1
	sw	s0,8(sp)	#,
	.cfi_offset 8, -8
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:330:   REG Rec_Pointer Next_Record = Ptr_Val_Par->Ptr_Comp;  
	.loc 1 330 15
	lw	s0,0(a0)		# Next_Record, Ptr_Val_Par_14(D)->Ptr_Comp
.LVL5:
	.loc 1 335 3 is_stmt 1
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:335:   structassign (*Ptr_Val_Par->Ptr_Comp, *Ptr_Glob); 
	.loc 1 335 26 is_stmt 0
	lw	a3,0(a5)		# *Ptr_Glob.14_1, *Ptr_Glob.14_1
	lw	t5,4(a5)		# *Ptr_Glob.14_1, *Ptr_Glob.14_1
	lw	t4,8(a5)		# *Ptr_Glob.14_1, *Ptr_Glob.14_1
	lw	t3,16(a5)		# *Ptr_Glob.14_1, *Ptr_Glob.14_1
	lw	t1,20(a5)		# *Ptr_Glob.14_1, *Ptr_Glob.14_1
	lw	a7,24(a5)		# *Ptr_Glob.14_1, *Ptr_Glob.14_1
	lw	a6,28(a5)		# *Ptr_Glob.14_1, *Ptr_Glob.14_1
	lw	a1,36(a5)		# *Ptr_Glob.14_1, *Ptr_Glob.14_1
	lw	a2,40(a5)		# *Ptr_Glob.14_1, *Ptr_Glob.14_1
	lw	a4,44(a5)		# *Ptr_Glob.14_1, *Ptr_Glob.14_1
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:329: {
	.loc 1 329 1
	sw	ra,12(sp)	#,
	sw	s1,4(sp)	#,
	.cfi_offset 1, -4
	.cfi_offset 9, -12
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:329: {
	.loc 1 329 1
	mv	s1,a0	# Ptr_Val_Par, tmp191
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:335:   structassign (*Ptr_Val_Par->Ptr_Comp, *Ptr_Glob); 
	.loc 1 335 26
	lw	a0,32(a5)		# *Ptr_Glob.14_1, *Ptr_Glob.14_1
.LVL6:
	sw	a3,0(s0)	# *Ptr_Glob.14_1, *Next_Record_15
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:339:   Next_Record->Ptr_Comp = Ptr_Val_Par->Ptr_Comp;
	.loc 1 339 38
	lw	a3,0(s1)		# _2, Ptr_Val_Par_14(D)->Ptr_Comp
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:335:   structassign (*Ptr_Val_Par->Ptr_Comp, *Ptr_Glob); 
	.loc 1 335 26
	sw	t5,4(s0)	# *Ptr_Glob.14_1, *Next_Record_15
	sw	t4,8(s0)	# *Ptr_Glob.14_1, *Next_Record_15
	sw	t3,16(s0)	# *Ptr_Glob.14_1, *Next_Record_15
	sw	t1,20(s0)	# *Ptr_Glob.14_1, *Next_Record_15
	sw	a7,24(s0)	# *Ptr_Glob.14_1, *Next_Record_15
	sw	a6,28(s0)	# *Ptr_Glob.14_1, *Next_Record_15
	sw	a0,32(s0)	# *Ptr_Glob.14_1, *Next_Record_15
	sw	a1,36(s0)	# *Ptr_Glob.14_1, *Next_Record_15
	sw	a2,40(s0)	# *Ptr_Glob.14_1, *Next_Record_15
	sw	a4,44(s0)	# *Ptr_Glob.14_1, *Next_Record_15
	.loc 1 336 3 is_stmt 1
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:336:   Ptr_Val_Par->variant.var_1.Int_Comp = 5;
	.loc 1 336 39 is_stmt 0
	li	a4,5		# tmp164,
	sw	a4,12(s1)	# tmp164, Ptr_Val_Par_14(D)->variant.var_1.Int_Comp
	.loc 1 337 3 is_stmt 1
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:339:   Next_Record->Ptr_Comp = Ptr_Val_Par->Ptr_Comp;
	.loc 1 339 25 is_stmt 0
	sw	a3,0(s0)	# _2, Next_Record_15->Ptr_Comp
.LBB22:
.LBB23:
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:391:     *Ptr_Ref_Par = Ptr_Glob->Ptr_Comp;
	.loc 1 391 28
	lw	a5,0(a5)		# _27, Ptr_Glob.14_1->Ptr_Comp
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:392:   Proc_7 (10, Int_Glob, &Ptr_Glob->variant.var_1.Int_Comp);
	.loc 1 392 3
	lui	a3,%hi(Int_Glob)	# tmp169,
	lw	a1,%lo(Int_Glob)(a3)		#, Int_Glob
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:391:     *Ptr_Ref_Par = Ptr_Glob->Ptr_Comp;
	.loc 1 391 18
	sw	a5,0(s0)	# _27, MEM[(struct record * *)Next_Record_15]
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:392:   Proc_7 (10, Int_Glob, &Ptr_Glob->variant.var_1.Int_Comp);
	.loc 1 392 3
	lw	a2,%lo(Ptr_Glob)(s2)		# Ptr_Glob, Ptr_Glob
.LBE23:
.LBE22:
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:338:         = Ptr_Val_Par->variant.var_1.Int_Comp;
	.loc 1 338 9
	sw	a4,12(s0)	# tmp164, Next_Record_15->variant.var_1.Int_Comp
	.loc 1 339 3 is_stmt 1
	.loc 1 340 3
.LVL7:
.LBB25:
.LBB24:
	.loc 1 389 3
	.loc 1 391 5
	.loc 1 392 3
	li	a0,10		#,
	addi	a2,a2,12	#,, Ptr_Glob
	call	Proc_7		#
.LVL8:
.LBE24:
.LBE25:
	.loc 1 343 3
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:343:   if (Next_Record->Discr == Ident_1)
	.loc 1 343 6 is_stmt 0
	lw	a5,4(s0)		# Next_Record_15->Discr, Next_Record_15->Discr
	beq	a5,zero,.L8	#, Next_Record_15->Discr,,
	.loc 1 354 5 is_stmt 1
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:354:     structassign (*Ptr_Val_Par, *Ptr_Val_Par->Ptr_Comp);
	.loc 1 354 32 is_stmt 0
	lw	a5,0(s1)		# _11, Ptr_Val_Par_14(D)->Ptr_Comp
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:355: } /* Proc_1 */
	.loc 1 355 1
	lw	ra,12(sp)		#,
	.cfi_remember_state
	.cfi_restore 1
	lw	s0,8(sp)		#,
	.cfi_restore 8
.LVL9:
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:354:     structassign (*Ptr_Val_Par, *Ptr_Val_Par->Ptr_Comp);
	.loc 1 354 18
	lw	t6,0(a5)		# *_11, *_11
	lw	t5,4(a5)		# *_11, *_11
	lw	t4,8(a5)		# *_11, *_11
	lw	t3,12(a5)		# *_11, *_11
	lw	t1,16(a5)		# *_11, *_11
	lw	a7,20(a5)		# *_11, *_11
	lw	a6,24(a5)		# *_11, *_11
	lw	a1,28(a5)		# *_11, *_11
	lw	a2,32(a5)		# *_11, *_11
	lw	a3,36(a5)		# *_11, *_11
	lw	a4,40(a5)		# *_11, *_11
	lw	a5,44(a5)		# *_11, *_11
	sw	t6,0(s1)	# *_11, *Ptr_Val_Par_14(D)
	sw	t5,4(s1)	# *_11, *Ptr_Val_Par_14(D)
	sw	t4,8(s1)	# *_11, *Ptr_Val_Par_14(D)
	sw	t3,12(s1)	# *_11, *Ptr_Val_Par_14(D)
	sw	t1,16(s1)	# *_11, *Ptr_Val_Par_14(D)
	sw	a7,20(s1)	# *_11, *Ptr_Val_Par_14(D)
	sw	a6,24(s1)	# *_11, *Ptr_Val_Par_14(D)
	sw	a1,28(s1)	# *_11, *Ptr_Val_Par_14(D)
	sw	a2,32(s1)	# *_11, *Ptr_Val_Par_14(D)
	sw	a3,36(s1)	# *_11, *Ptr_Val_Par_14(D)
	sw	a4,40(s1)	# *_11, *Ptr_Val_Par_14(D)
	sw	a5,44(s1)	# *_11, *Ptr_Val_Par_14(D)
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:355: } /* Proc_1 */
	.loc 1 355 1
	lw	s2,0(sp)		#,
	.cfi_restore 18
	lw	s1,4(sp)		#,
	.cfi_restore 9
.LVL10:
	addi	sp,sp,16	#,,
	.cfi_def_cfa_offset 0
	jr	ra		#
.LVL11:
.L8:
	.cfi_restore_state
.LBB26:
	.loc 1 346 5 is_stmt 1
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:347:     Proc_6 (Ptr_Val_Par->variant.var_1.Enum_Comp, 
	.loc 1 347 5 is_stmt 0
	lw	a0,8(s1)		#, Ptr_Val_Par_14(D)->variant.var_1.Enum_Comp
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:346:     Next_Record->variant.var_1.Int_Comp = 6;
	.loc 1 346 41
	li	a5,6		# tmp172,
	sw	a5,12(s0)	# tmp172, Next_Record_15->variant.var_1.Int_Comp
	.loc 1 347 5 is_stmt 1
	addi	a1,s0,8	#,, Next_Record
	call	Proc_6		#
.LVL12:
	.loc 1 349 5
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:349:     Next_Record->Ptr_Comp = Ptr_Glob->Ptr_Comp;
	.loc 1 349 37 is_stmt 0
	lw	a5,%lo(Ptr_Glob)(s2)		# Ptr_Glob, Ptr_Glob
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:350:     Proc_7 (Next_Record->variant.var_1.Int_Comp, 10, 
	.loc 1 350 5
	lw	a0,12(s0)		#, Next_Record_15->variant.var_1.Int_Comp
	addi	a2,s0,12	#,, Next_Record
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:349:     Next_Record->Ptr_Comp = Ptr_Glob->Ptr_Comp;
	.loc 1 349 37
	lw	a5,0(a5)		# _8, Ptr_Glob.15_7->Ptr_Comp
.LBE26:
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:355: } /* Proc_1 */
	.loc 1 355 1
	lw	ra,12(sp)		#,
	.cfi_restore 1
	lw	s1,4(sp)		#,
	.cfi_restore 9
.LVL13:
.LBB27:
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:349:     Next_Record->Ptr_Comp = Ptr_Glob->Ptr_Comp;
	.loc 1 349 27
	sw	a5,0(s0)	# _8, Next_Record_15->Ptr_Comp
	.loc 1 350 5 is_stmt 1
.LBE27:
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:355: } /* Proc_1 */
	.loc 1 355 1 is_stmt 0
	lw	s0,8(sp)		#,
	.cfi_restore 8
.LVL14:
	lw	s2,0(sp)		#,
	.cfi_restore 18
.LBB28:
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:350:     Proc_7 (Next_Record->variant.var_1.Int_Comp, 10, 
	.loc 1 350 5
	li	a1,10		#,
.LBE28:
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:355: } /* Proc_1 */
	.loc 1 355 1
	addi	sp,sp,16	#,,
	.cfi_def_cfa_offset 0
.LBB29:
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:350:     Proc_7 (Next_Record->variant.var_1.Int_Comp, 10, 
	.loc 1 350 5
	tail	Proc_7		#
.LVL15:
.LBE29:
	.cfi_endproc
.LFE2:
	.size	Proc_1, .-Proc_1
	.section	.rodata.str1.4,"aMS",@progbits,1
	.align	2
.LC0:
	.string	"DHRYSTONE PROGRAM, SOME STRING"
	.align	2
.LC1:
	.string	"DHRYSTONE PROGRAM, 1'ST STRING"
	.align	2
.LC2:
	.string	"DHRYSTONE PROGRAM, 2'ND STRING"
	.align	2
.LC3:
	.string	"DHRYSTONE PROGRAM, 3'RD STRING"
	.align	2
.LC4:
	.string	"s"
	.align	2
.LC5:
	.string	"e"
	.section	.text.startup,"ax",@progbits
	.align	2
	.globl	main
	.type	main, @function
main:
.LFB1:
	.loc 1 97 1 is_stmt 1
	.cfi_startproc
	.loc 1 98 9
	.loc 1 99 3
	.loc 1 100 9
	.loc 1 101 3
	.loc 1 102 9
	.loc 1 103 9
	.loc 1 104 9
	.loc 1 105 3
	.loc 1 106 3
	.loc 1 112 3
	.loc 1 113 3
	.loc 1 115 3
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:97: {
	.loc 1 97 1 is_stmt 0
	addi	sp,sp,-240	#,,
	.cfi_def_cfa_offset 240
.LVL16:
	.loc 1 116 3 is_stmt 1
	.loc 1 118 3
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:121:   Ptr_Glob->variant.var_1.Int_Comp      = 40;
	.loc 1 121 36 is_stmt 0
	li	a4,40		# tmp165,
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:118:   Ptr_Glob->Ptr_Comp                    = Next_Ptr_Glob;
	.loc 1 118 22
	addi	a2,sp,80	#, tmp163,
.LVL17:
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:120:   Ptr_Glob->variant.var_1.Enum_Comp     = Ident_3;
	.loc 1 120 37
	li	a3,2		# tmp164,
.LBB30:
.LBB31:
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:79:     while ((*dest++ = *src++) != '\0');
	.loc 1 79 11
	lui	a5,%hi(.LC0)	# tmp158,
.LBE31:
.LBE30:
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:121:   Ptr_Glob->variant.var_1.Int_Comp      = 40;
	.loc 1 121 36
	sw	a4,140(sp)	# tmp165, Glob.variant.var_1.Int_Comp
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:97: {
	.loc 1 97 1
	sw	ra,236(sp)	#,
	sw	s0,232(sp)	#,
	sw	s1,228(sp)	#,
	sw	s2,224(sp)	#,
	sw	s3,220(sp)	#,
	sw	s4,216(sp)	#,
	sw	s5,212(sp)	#,
	sw	s6,208(sp)	#,
	sw	s7,204(sp)	#,
	sw	s8,200(sp)	#,
	sw	s9,196(sp)	#,
	sw	s10,192(sp)	#,
	sw	s11,188(sp)	#,
	.cfi_offset 1, -4
	.cfi_offset 8, -8
	.cfi_offset 9, -12
	.cfi_offset 18, -16
	.cfi_offset 19, -20
	.cfi_offset 20, -24
	.cfi_offset 21, -28
	.cfi_offset 22, -32
	.cfi_offset 23, -36
	.cfi_offset 24, -40
	.cfi_offset 25, -44
	.cfi_offset 26, -48
	.cfi_offset 27, -52
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:119:   Ptr_Glob->Discr                       = Ident_1;
	.loc 1 119 19
	sw	zero,132(sp)	#, Glob.Discr
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:118:   Ptr_Glob->Ptr_Comp                    = Next_Ptr_Glob;
	.loc 1 118 22
	sw	a2,128(sp)	# tmp163, Glob.Ptr_Comp
	.loc 1 119 3 is_stmt 1
	.loc 1 120 3
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:120:   Ptr_Glob->variant.var_1.Enum_Comp     = Ident_3;
	.loc 1 120 37 is_stmt 0
	sw	a3,136(sp)	# tmp164, Glob.variant.var_1.Enum_Comp
	.loc 1 121 3 is_stmt 1
	.loc 1 122 3
.LVL18:
.LBB33:
.LBB32:
	.loc 1 78 5
	.loc 1 79 5
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:79:     while ((*dest++ = *src++) != '\0');
	.loc 1 79 11 is_stmt 0
	addi	a5,a5,%lo(.LC0)	# src, tmp158,
	addi	a4,sp,144	#, dest,
.LVL19:
.L10:
	.loc 1 79 31 is_stmt 1 discriminator 1
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:79:     while ((*dest++ = *src++) != '\0');
	.loc 1 79 23 is_stmt 0 discriminator 1
	lbu	a3,0(a5)	# _50, MEM[(const char *)src_47 + 4294967295B]
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:79:     while ((*dest++ = *src++) != '\0');
	.loc 1 79 27 discriminator 1
	addi	a5,a5,1	#, src, src
.LVL20:
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:79:     while ((*dest++ = *src++) != '\0');
	.loc 1 79 18 discriminator 1
	addi	a4,a4,1	#, dest, dest
.LVL21:
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:79:     while ((*dest++ = *src++) != '\0');
	.loc 1 79 21 discriminator 1
	sb	a3,-1(a4)	# _50, MEM[(char *)dest_49 + 4294967295B]
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:79:     while ((*dest++ = *src++) != '\0');
	.loc 1 79 31 discriminator 1
	bne	a3,zero,.L10	#, _50,,
	lui	a5,%hi(.LC1)	# tmp160,
.LVL22:
	addi	a5,a5,%lo(.LC1)	# src, tmp160,
	addi	a4,sp,16	#, tmp219,
.LVL23:
.L11:
.LBE32:
.LBE33:
.LBB34:
.LBB35:
	.loc 1 79 31 is_stmt 1 discriminator 1
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:79:     while ((*dest++ = *src++) != '\0');
	.loc 1 79 23 is_stmt 0 discriminator 1
	lbu	a3,0(a5)	# _45, MEM[(const char *)src_42 + 4294967295B]
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:79:     while ((*dest++ = *src++) != '\0');
	.loc 1 79 27 discriminator 1
	addi	a5,a5,1	#, src, src
.LVL24:
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:79:     while ((*dest++ = *src++) != '\0');
	.loc 1 79 18 discriminator 1
	addi	a4,a4,1	#, dest, dest
.LVL25:
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:79:     while ((*dest++ = *src++) != '\0');
	.loc 1 79 21 discriminator 1
	sb	a3,-1(a4)	# _45, MEM[(char *)dest_44 + 4294967295B]
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:79:     while ((*dest++ = *src++) != '\0');
	.loc 1 79 31 discriminator 1
	bne	a3,zero,.L11	#, _45,,
	.loc 1 80 5 is_stmt 1
.LVL26:
.LBE35:
.LBE34:
	.loc 1 126 3
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:126:   Arr_2_Glob [8][7] = 10;
	.loc 1 126 21 is_stmt 0
	lui	s5,%hi(Arr_2_Glob)	# tmp210,
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:176:   uart_send("s"); //added
	.loc 1 176 3
	lui	a0,%hi(.LC4)	# tmp169,
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:126:   Arr_2_Glob [8][7] = 10;
	.loc 1 126 21
	addi	a5,s5,%lo(Arr_2_Glob)	# tmp167, tmp210,
	li	a4,10		# tmp168,
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:176:   uart_send("s"); //added
	.loc 1 176 3
	addi	a0,a0,%lo(.LC4)	#, tmp169,
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:177:   for (Run_Index = 1; Run_Index <= Number_Of_Runs; ++Run_Index)
	.loc 1 177 18
	li	s1,1		# Run_Index,
	lui	s4,%hi(.LC2)	# tmp202,
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:126:   Arr_2_Glob [8][7] = 10;
	.loc 1 126 21
	sw	a4,1628(a5)	# tmp168, Arr_2_Glob[8][7]
	.loc 1 158 3 is_stmt 1
.LVL27:
	.loc 1 176 3
.LBB36:
.LBB37:
.LBB38:
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:403:   Bool_Glob = Bool_Loc | Bool_Glob;
	.loc 1 403 13 is_stmt 0
	mv	s3,s1	# tmp173, Run_Index
.LBE38:
.LBE37:
.LBE36:
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:176:   uart_send("s"); //added
	.loc 1 176 3
	call	uart_send		#
.LVL28:
	.loc 1 177 3 is_stmt 1
	.loc 1 177 33 discriminator 1
	addi	s4,s4,%lo(.LC2)	# src, tmp202,
	lui	s11,%hi(Ch_1_Glob)	# tmp206,
	lui	s2,%hi(Bool_Glob)	# tmp211,
	lui	s0,%hi(Ch_2_Glob)	# tmp201,
	lui	s10,%hi(.LANCHOR0)	# tmp208,
.LBB59:
.LBB42:
.LBB43:
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:412:   Ch_1_Glob = 'A';
	.loc 1 412 13 is_stmt 0
	li	s9,65		# tmp171,
.LBE43:
.LBE42:
.LBB45:
.LBB39:
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:404:   Ch_2_Glob = 'B';
	.loc 1 404 13
	li	s8,66		# tmp175,
.LBE39:
.LBE45:
.LBB46:
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:191:       Int_3_Loc = 5 * Int_1_Loc - Int_2_Loc;
	.loc 1 191 17
	li	s7,7		# tmp182,
.LVL29:
.L17:
.LBE46:
	.loc 1 180 5 is_stmt 1
.LBB47:
.LBB44:
	.loc 1 412 3
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:412:   Ch_1_Glob = 'A';
	.loc 1 412 13 is_stmt 0
	sb	s9,%lo(Ch_1_Glob)(s11)	# tmp171, Ch_1_Glob
	.loc 1 413 3 is_stmt 1
.LBE44:
.LBE47:
	.loc 1 181 5
.LBB48:
.LBB40:
	.loc 1 400 3
	.loc 1 402 3
.LVL30:
	.loc 1 403 3
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:403:   Bool_Glob = Bool_Loc | Bool_Glob;
	.loc 1 403 13 is_stmt 0
	sw	s3,%lo(Bool_Glob)(s2)	# tmp173, Bool_Glob
	.loc 1 404 3 is_stmt 1
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:404:   Ch_2_Glob = 'B';
	.loc 1 404 13 is_stmt 0
	sb	s8,%lo(Ch_2_Glob)(s0)	# tmp175, Ch_2_Glob
.LVL31:
.LBE40:
.LBE48:
	.loc 1 183 5 is_stmt 1
	.loc 1 184 5
	.loc 1 185 5
.LBB49:
.LBB50:
	.loc 1 78 5
	.loc 1 79 5
.LBE50:
.LBE49:
.LBB52:
.LBB41:
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:404:   Ch_2_Glob = 'B';
	.loc 1 404 13 is_stmt 0
	mv	a4,s4	# src, src
	addi	a5,sp,48	#, tmp220,
.LVL32:
.L12:
.LBE41:
.LBE52:
.LBB53:
.LBB51:
	.loc 1 79 31 is_stmt 1 discriminator 1
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:79:     while ((*dest++ = *src++) != '\0');
	.loc 1 79 23 is_stmt 0 discriminator 1
	lbu	a3,0(a4)	# _55, MEM[(const char *)src_52 + 4294967295B]
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:79:     while ((*dest++ = *src++) != '\0');
	.loc 1 79 27 discriminator 1
	addi	a4,a4,1	#, src, src
.LVL33:
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:79:     while ((*dest++ = *src++) != '\0');
	.loc 1 79 18 discriminator 1
	addi	a5,a5,1	#, dest, dest
.LVL34:
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:79:     while ((*dest++ = *src++) != '\0');
	.loc 1 79 21 discriminator 1
	sb	a3,-1(a5)	# _55, MEM[(char *)dest_54 + 4294967295B]
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:79:     while ((*dest++ = *src++) != '\0');
	.loc 1 79 31 discriminator 1
	bne	a3,zero,.L12	#, _55,,
	.loc 1 80 5 is_stmt 1
.LVL35:
.LBE51:
.LBE53:
	.loc 1 186 5
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:187:     Bool_Glob = ! Func_2 (Str_1_Loc, Str_2_Loc);
	.loc 1 187 19 is_stmt 0
	addi	a1,sp,48	#, tmp221,
.LVL36:
	addi	a0,sp,16	#, tmp222,
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:186:     Enum_Loc = Ident_2;
	.loc 1 186 14
	sw	s3,12(sp)	# tmp173, Enum_Loc
	.loc 1 187 5 is_stmt 1
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:187:     Bool_Glob = ! Func_2 (Str_1_Loc, Str_2_Loc);
	.loc 1 187 19 is_stmt 0
	call	Func_2		#
.LVL37:
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:187:     Bool_Glob = ! Func_2 (Str_1_Loc, Str_2_Loc);
	.loc 1 187 17 discriminator 1
	seqz	a5,a0	# _2, tmp216
.LBB54:
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:193:       Proc_7 (Int_1_Loc, Int_2_Loc, &Int_3_Loc);
	.loc 1 193 7
	addi	a2,sp,8	#, tmp223,
	li	a1,3		#,
	li	a0,2		#,
.LBE54:
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:187:     Bool_Glob = ! Func_2 (Str_1_Loc, Str_2_Loc);
	.loc 1 187 15 discriminator 1
	sw	a5,%lo(Bool_Glob)(s2)	# _2, Bool_Glob
	.loc 1 189 5 is_stmt 1
	.loc 1 189 22
.LBB55:
	.loc 1 191 7
	.loc 1 193 7
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:191:       Int_3_Loc = 5 * Int_1_Loc - Int_2_Loc;
	.loc 1 191 17 is_stmt 0
	sw	s7,8(sp)	# tmp182, Int_3_Loc
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:193:       Proc_7 (Int_1_Loc, Int_2_Loc, &Int_3_Loc);
	.loc 1 193 7
	call	Proc_7		#
.LVL38:
	.loc 1 195 7 is_stmt 1
.LBE55:
	.loc 1 189 22
	.loc 1 198 5
	lw	a3,8(sp)		#, Int_3_Loc
	addi	a1,s5,%lo(Arr_2_Glob)	#, tmp210,
	li	a2,3		#,
	addi	a0,s10,%lo(.LANCHOR0)	#, tmp208,
	call	Proc_8		#
.LVL39:
	.loc 1 200 5
	addi	a0,sp,128	#, tmp224,
.LVL40:
	call	Proc_1		#
.LVL41:
	.loc 1 201 5
	.loc 1 201 35 discriminator 1
	lbu	a5,%lo(Ch_2_Glob)(s0)	# Ch_2_Glob, Ch_2_Glob
	li	a4,64		# tmp225,
	bleu	a5,a4,.L13	#, Ch_2_Glob, tmp225,
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:201:     for (Ch_Index = 'A'; Ch_Index <= Ch_2_Glob; ++Ch_Index)
	.loc 1 201 19 is_stmt 0
	li	s6,65		# Ch_Index,
.LVL42:
.L16:
	.loc 1 204 7 is_stmt 1
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:204:       if (Enum_Loc == Func_1 (Ch_Index, 'C'))
	.loc 1 204 23 is_stmt 0
	li	a1,67		#,
	mv	a0,s6	#, Ch_Index
	call	Func_1		#
.LVL43:
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:204:       if (Enum_Loc == Func_1 (Ch_Index, 'C'))
	.loc 1 204 10 discriminator 1
	lw	a4,12(sp)		# Enum_Loc, Enum_Loc
	beq	a0,a4,.L25	#, tmp217, Enum_Loc,
.L14:
	.loc 1 201 49 is_stmt 1 discriminator 2
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:201:     for (Ch_Index = 'A'; Ch_Index <= Ch_2_Glob; ++Ch_Index)
	.loc 1 201 35 is_stmt 0 discriminator 1
	lbu	a4,%lo(Ch_2_Glob)(s0)	# Ch_2_Glob, Ch_2_Glob
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:201:     for (Ch_Index = 'A'; Ch_Index <= Ch_2_Glob; ++Ch_Index)
	.loc 1 201 49 discriminator 2
	addi	a5,s6,1	#, tmp195, Ch_Index
	andi	s6,a5,0xff	# Ch_Index, tmp195
.LVL44:
	.loc 1 201 35 is_stmt 1 discriminator 1
	bgeu	a4,s6,.L16	#, Ch_2_Glob, Ch_Index,
.LVL45:
.L13:
	.loc 1 214 5
	.loc 1 215 5
	.loc 1 216 5
	.loc 1 218 5
.LBE59:
	.loc 1 177 52 discriminator 2
	addi	s1,s1,1	#, Run_Index, Run_Index
.LVL46:
	.loc 1 177 33 discriminator 1
	li	a5,11		# tmp198,
	bne	s1,a5,.L17	#, Run_Index, tmp198,
	.loc 1 222 3
	lui	a0,%hi(.LC5)	# tmp199,
	addi	a0,a0,%lo(.LC5)	#, tmp199,
	call	uart_send		#
.LVL47:
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:322: }
	.loc 1 322 1 is_stmt 0
	lw	ra,236(sp)		#,
	.cfi_remember_state
	.cfi_restore 1
	lw	s0,232(sp)		#,
	.cfi_restore 8
	lw	s1,228(sp)		#,
	.cfi_restore 9
.LVL48:
	lw	s2,224(sp)		#,
	.cfi_restore 18
	lw	s3,220(sp)		#,
	.cfi_restore 19
	lw	s4,216(sp)		#,
	.cfi_restore 20
	lw	s5,212(sp)		#,
	.cfi_restore 21
	lw	s6,208(sp)		#,
	.cfi_restore 22
	lw	s7,204(sp)		#,
	.cfi_restore 23
	lw	s8,200(sp)		#,
	.cfi_restore 24
	lw	s9,196(sp)		#,
	.cfi_restore 25
	lw	s10,192(sp)		#,
	.cfi_restore 26
	lw	s11,188(sp)		#,
	.cfi_restore 27
	li	a0,0		#,
	addi	sp,sp,240	#,,
	.cfi_def_cfa_offset 0
.LVL49:
	jr	ra		#
.LVL50:
.L25:
	.cfi_restore_state
.LBB60:
.LBB56:
	.loc 1 207 9 is_stmt 1
	addi	a1,sp,12	#,,
	li	a0,0		#,
	call	Proc_6		#
.LVL51:
	.loc 1 208 9
.LBB57:
.LBB58:
	.loc 1 78 5
	.loc 1 79 5
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:79:     while ((*dest++ = *src++) != '\0');
	.loc 1 79 11 is_stmt 0
	lui	a4,%hi(.LC3)	# tmp162,
	addi	a3,sp,48	#, tmp226,
.LVL52:
	addi	a4,a4,%lo(.LC3)	# src, tmp162,
.LVL53:
.L15:
	.loc 1 79 31 is_stmt 1 discriminator 1
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:79:     while ((*dest++ = *src++) != '\0');
	.loc 1 79 23 is_stmt 0 discriminator 1
	lbu	a2,0(a4)	# _60, MEM[(const char *)src_57 + 4294967295B]
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:79:     while ((*dest++ = *src++) != '\0');
	.loc 1 79 27 discriminator 1
	addi	a4,a4,1	#, src, src
.LVL54:
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:79:     while ((*dest++ = *src++) != '\0');
	.loc 1 79 18 discriminator 1
	addi	a3,a3,1	#, dest, dest
.LVL55:
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:79:     while ((*dest++ = *src++) != '\0');
	.loc 1 79 21 discriminator 1
	sb	a2,-1(a3)	# _60, MEM[(char *)dest_59 + 4294967295B]
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:79:     while ((*dest++ = *src++) != '\0');
	.loc 1 79 31 discriminator 1
	bne	a2,zero,.L15	#, _60,,
	.loc 1 80 5 is_stmt 1
.LVL56:
.LBE58:
.LBE57:
	.loc 1 209 9
	.loc 1 210 9
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:210:         Int_Glob = Run_Index;
	.loc 1 210 18 is_stmt 0
	lui	a4,%hi(Int_Glob)	# tmp194,
	sw	s1,%lo(Int_Glob)(a4)	# Run_Index, Int_Glob
	j	.L14		#
.LBE56:
.LBE60:
	.cfi_endproc
.LFE1:
	.size	main, .-main
	.text
	.align	2
	.globl	Proc_2
	.type	Proc_2, @function
Proc_2:
.LFB3:
	.loc 1 364 1 is_stmt 1
	.cfi_startproc
.LVL57:
	.loc 1 365 3
	.loc 1 366 3
	.loc 1 368 3
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:370:     if (Ch_1_Glob == 'A')
	.loc 1 370 19 is_stmt 0
	lui	a5,%hi(Ch_1_Glob)	# tmp141,
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:370:     if (Ch_1_Glob == 'A')
	.loc 1 370 8
	lbu	a4,%lo(Ch_1_Glob)(a5)	# Ch_1_Glob, Ch_1_Glob
	li	a5,65		# tmp143,
.LVL58:
	.loc 1 369 3 is_stmt 1
	.loc 1 370 5
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:370:     if (Ch_1_Glob == 'A')
	.loc 1 370 8 is_stmt 0
	beq	a4,a5,.L28	#, Ch_1_Glob, tmp143,
.LVL59:
	.loc 1 377 19 is_stmt 1
.LVL60:
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:378: } /* Proc_2 */
	.loc 1 378 1 is_stmt 0
	ret	
.LVL61:
.L28:
	.loc 1 373 7 is_stmt 1
	.loc 1 374 7
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:373:       Int_Loc -= 1;
	.loc 1 373 15 is_stmt 0
	lw	a5,0(a0)		# *Int_Par_Ref_7(D), *Int_Par_Ref_7(D)
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:374:       *Int_Par_Ref = Int_Loc - Int_Glob;
	.loc 1 374 30
	lui	a4,%hi(Int_Glob)	# tmp146,
	lw	a4,%lo(Int_Glob)(a4)		# Int_Glob, Int_Glob
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:373:       Int_Loc -= 1;
	.loc 1 373 15
	addi	a5,a5,9	#, Int_Loc_8, *Int_Par_Ref_7(D)
.LVL62:
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:374:       *Int_Par_Ref = Int_Loc - Int_Glob;
	.loc 1 374 30
	sub	a5,a5,a4	# _4, Int_Loc_8, Int_Glob
.LVL63:
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:374:       *Int_Par_Ref = Int_Loc - Int_Glob;
	.loc 1 374 20
	sw	a5,0(a0)	# _4, *Int_Par_Ref_7(D)
.LVL64:
	.loc 1 375 7 is_stmt 1
	.loc 1 377 19
.LVL65:
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:378: } /* Proc_2 */
	.loc 1 378 1 is_stmt 0
	ret	
	.cfi_endproc
.LFE3:
	.size	Proc_2, .-Proc_2
	.align	2
	.globl	Proc_3
	.type	Proc_3, @function
Proc_3:
.LFB4:
	.loc 1 388 1 is_stmt 1
	.cfi_startproc
.LVL66:
	.loc 1 389 3
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:389:   if (Ptr_Glob != Null)
	.loc 1 389 16 is_stmt 0
	lui	a5,%hi(Ptr_Glob)	# tmp140,
	lw	a2,%lo(Ptr_Glob)(a5)		# pretmp_11, Ptr_Glob
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:389:   if (Ptr_Glob != Null)
	.loc 1 389 6
	beq	a2,zero,.L30	#, pretmp_11,,
	.loc 1 391 5 is_stmt 1
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:391:     *Ptr_Ref_Par = Ptr_Glob->Ptr_Comp;
	.loc 1 391 28 is_stmt 0
	lw	a4,0(a2)		# _2, Ptr_Glob.18_1->Ptr_Comp
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:391:     *Ptr_Ref_Par = Ptr_Glob->Ptr_Comp;
	.loc 1 391 18
	sw	a4,0(a0)	# _2, *Ptr_Ref_Par_8(D)
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:392:   Proc_7 (10, Int_Glob, &Ptr_Glob->variant.var_1.Int_Comp);
	.loc 1 392 34
	lw	a2,%lo(Ptr_Glob)(a5)		# pretmp_11, Ptr_Glob
.L30:
	.loc 1 392 3 is_stmt 1
	lui	a5,%hi(Int_Glob)	# tmp143,
	lw	a1,%lo(Int_Glob)(a5)		#, Int_Glob
	addi	a2,a2,12	#,, pretmp_11
	li	a0,10		#,
.LVL67:
	tail	Proc_7		#
.LVL68:
	.cfi_endproc
.LFE4:
	.size	Proc_3, .-Proc_3
	.align	2
	.globl	Proc_4
	.type	Proc_4, @function
Proc_4:
.LFB5:
	.loc 1 399 1
	.cfi_startproc
	.loc 1 400 3
	.loc 1 402 3
.LVL69:
	.loc 1 403 3
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:402:   Bool_Loc = Ch_1_Glob == 'A';
	.loc 1 402 24 is_stmt 0
	lui	a5,%hi(Ch_1_Glob)	# tmp141,
	lbu	a5,%lo(Ch_1_Glob)(a5)	# Ch_1_Glob, Ch_1_Glob
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:403:   Bool_Glob = Bool_Loc | Bool_Glob;
	.loc 1 403 13
	lui	a4,%hi(Bool_Glob)	# tmp140,
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:403:   Bool_Glob = Bool_Loc | Bool_Glob;
	.loc 1 403 24
	lw	a3,%lo(Bool_Glob)(a4)		# Bool_Glob, Bool_Glob
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:402:   Bool_Loc = Ch_1_Glob == 'A';
	.loc 1 402 24
	addi	a5,a5,-65	#, tmp145, Ch_1_Glob
	seqz	a5,a5	# _2, tmp145
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:403:   Bool_Glob = Bool_Loc | Bool_Glob;
	.loc 1 403 24
	or	a5,a5,a3	# Bool_Glob, _4, _2
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:404:   Ch_2_Glob = 'B';
	.loc 1 404 13
	li	a2,66		# tmp150,
	lui	a3,%hi(Ch_2_Glob)	# tmp149,
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:403:   Bool_Glob = Bool_Loc | Bool_Glob;
	.loc 1 403 13
	sw	a5,%lo(Bool_Glob)(a4)	# _4, Bool_Glob
	.loc 1 404 3 is_stmt 1
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:404:   Ch_2_Glob = 'B';
	.loc 1 404 13 is_stmt 0
	sb	a2,%lo(Ch_2_Glob)(a3)	# tmp150, Ch_2_Glob
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:405: } /* Proc_4 */
	.loc 1 405 1
	ret	
	.cfi_endproc
.LFE5:
	.size	Proc_4, .-Proc_4
	.align	2
	.globl	Proc_5
	.type	Proc_5, @function
Proc_5:
.LFB6:
	.loc 1 411 1 is_stmt 1
	.cfi_startproc
	.loc 1 412 3
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:412:   Ch_1_Glob = 'A';
	.loc 1 412 13 is_stmt 0
	lui	a4,%hi(Ch_1_Glob)	# tmp135,
	li	a3,65		# tmp136,
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:413:   Bool_Glob = false;
	.loc 1 413 13
	lui	a5,%hi(Bool_Glob)	# tmp137,
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:412:   Ch_1_Glob = 'A';
	.loc 1 412 13
	sb	a3,%lo(Ch_1_Glob)(a4)	# tmp136, Ch_1_Glob
	.loc 1 413 3 is_stmt 1
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:413:   Bool_Glob = false;
	.loc 1 413 13 is_stmt 0
	sw	zero,%lo(Bool_Glob)(a5)	#, Bool_Glob
# /home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c:414: } /* Proc_5 */
	.loc 1 414 1
	ret	
	.cfi_endproc
.LFE6:
	.size	Proc_5, .-Proc_5
	.globl	Dhrystones_Per_Second
	.globl	Microseconds
	.globl	User_Time
	.globl	End_Time
	.globl	Begin_Time
	.globl	Reg
	.globl	Arr_2_Glob
	.globl	Arr_1_Glob
	.globl	Ch_2_Glob
	.globl	Ch_1_Glob
	.globl	Bool_Glob
	.globl	Int_Glob
	.globl	Next_Ptr_Glob
	.globl	Ptr_Glob
	.bss
	.align	2
	.set	.LANCHOR0,. + 0
	.type	Arr_1_Glob, @object
	.size	Arr_1_Glob, 200
Arr_1_Glob:
	.zero	200
	.type	Arr_2_Glob, @object
	.size	Arr_2_Glob, 10000
Arr_2_Glob:
	.zero	10000
	.section	.sbss,"aw",@nobits
	.align	2
	.type	Dhrystones_Per_Second, @object
	.size	Dhrystones_Per_Second, 4
Dhrystones_Per_Second:
	.zero	4
	.type	Microseconds, @object
	.size	Microseconds, 4
Microseconds:
	.zero	4
	.type	User_Time, @object
	.size	User_Time, 4
User_Time:
	.zero	4
	.type	End_Time, @object
	.size	End_Time, 4
End_Time:
	.zero	4
	.type	Begin_Time, @object
	.size	Begin_Time, 4
Begin_Time:
	.zero	4
	.type	Reg, @object
	.size	Reg, 4
Reg:
	.zero	4
	.type	Ch_2_Glob, @object
	.size	Ch_2_Glob, 1
Ch_2_Glob:
	.zero	1
	.type	Ch_1_Glob, @object
	.size	Ch_1_Glob, 1
Ch_1_Glob:
	.zero	1
	.zero	2
	.type	Bool_Glob, @object
	.size	Bool_Glob, 4
Bool_Glob:
	.zero	4
	.type	Int_Glob, @object
	.size	Int_Glob, 4
Int_Glob:
	.zero	4
	.type	Next_Ptr_Glob, @object
	.size	Next_Ptr_Glob, 4
Next_Ptr_Glob:
	.zero	4
	.type	Ptr_Glob, @object
	.size	Ptr_Glob, 4
Ptr_Glob:
	.zero	4
	.text
.Letext0:
	.file 2 "/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry.h"
	.file 3 "/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/uart.h"
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.4byte	0x900
	.2byte	0x5
	.byte	0x1
	.byte	0x4
	.4byte	.Ldebug_abbrev0
	.uleb128 0x1e
	.4byte	.LASF80
	.byte	0x1d
	.4byte	.LASF0
	.4byte	.LASF1
	.4byte	.LLRL35
	.4byte	0
	.4byte	.Ldebug_line0
	.uleb128 0x6
	.byte	0x8
	.byte	0x7
	.4byte	.LASF2
	.uleb128 0x6
	.byte	0x4
	.byte	0x7
	.4byte	.LASF3
	.uleb128 0x1f
	.byte	0x7
	.byte	0x4
	.4byte	0x2d
	.byte	0x2
	.2byte	0x185
	.byte	0x10
	.4byte	0x62
	.uleb128 0xc
	.4byte	.LASF4
	.byte	0
	.uleb128 0xc
	.4byte	.LASF5
	.byte	0x1
	.uleb128 0xc
	.4byte	.LASF6
	.byte	0x2
	.uleb128 0xc
	.4byte	.LASF7
	.byte	0x3
	.uleb128 0xc
	.4byte	.LASF8
	.byte	0x4
	.byte	0
	.uleb128 0x8
	.4byte	.LASF16
	.2byte	0x186
	.byte	0x11
	.4byte	0x34
	.uleb128 0x6
	.byte	0x1
	.byte	0x6
	.4byte	.LASF9
	.uleb128 0x6
	.byte	0x2
	.byte	0x5
	.4byte	.LASF10
	.uleb128 0x6
	.byte	0x4
	.byte	0x5
	.4byte	.LASF11
	.uleb128 0x6
	.byte	0x8
	.byte	0x5
	.4byte	.LASF12
	.uleb128 0x6
	.byte	0x1
	.byte	0x8
	.4byte	.LASF13
	.uleb128 0x6
	.byte	0x2
	.byte	0x7
	.4byte	.LASF14
	.uleb128 0x6
	.byte	0x4
	.byte	0x7
	.4byte	.LASF15
	.uleb128 0x20
	.byte	0x4
	.byte	0x5
	.string	"int"
	.uleb128 0x8
	.4byte	.LASF17
	.2byte	0x196
	.byte	0xd
	.4byte	0x9f
	.uleb128 0x6
	.byte	0x1
	.byte	0x8
	.4byte	.LASF18
	.uleb128 0x21
	.4byte	0xb2
	.uleb128 0x8
	.4byte	.LASF19
	.2byte	0x198
	.byte	0xd
	.4byte	0x9f
	.uleb128 0x8
	.4byte	.LASF20
	.2byte	0x199
	.byte	0xe
	.4byte	0xd6
	.uleb128 0x13
	.4byte	0xb2
	.4byte	0xe6
	.uleb128 0x10
	.4byte	0x2d
	.byte	0x1e
	.byte	0
	.uleb128 0x13
	.4byte	0x9f
	.4byte	0xf6
	.uleb128 0x10
	.4byte	0x2d
	.byte	0x31
	.byte	0
	.uleb128 0x13
	.4byte	0x9f
	.4byte	0x10c
	.uleb128 0x10
	.4byte	0x2d
	.byte	0x31
	.uleb128 0x10
	.4byte	0x2d
	.byte	0x31
	.byte	0
	.uleb128 0x14
	.byte	0x28
	.2byte	0x1a2
	.4byte	0x13c
	.uleb128 0x7
	.4byte	.LASF21
	.2byte	0x1a3
	.byte	0x1f
	.4byte	0x62
	.byte	0
	.uleb128 0x7
	.4byte	.LASF22
	.2byte	0x1a4
	.byte	0x17
	.4byte	0x9f
	.byte	0x4
	.uleb128 0x7
	.4byte	.LASF23
	.2byte	0x1a5
	.byte	0x18
	.4byte	0xd6
	.byte	0x8
	.byte	0
	.uleb128 0x14
	.byte	0x24
	.2byte	0x1a7
	.4byte	0x15f
	.uleb128 0x7
	.4byte	.LASF24
	.2byte	0x1a8
	.byte	0x1f
	.4byte	0x62
	.byte	0
	.uleb128 0x7
	.4byte	.LASF25
	.2byte	0x1a9
	.byte	0x18
	.4byte	0xd6
	.byte	0x4
	.byte	0
	.uleb128 0x14
	.byte	0x2
	.2byte	0x1ab
	.4byte	0x182
	.uleb128 0x7
	.4byte	.LASF26
	.2byte	0x1ac
	.byte	0x18
	.4byte	0xb2
	.byte	0
	.uleb128 0x7
	.4byte	.LASF27
	.2byte	0x1ad
	.byte	0x18
	.4byte	0xb2
	.byte	0x1
	.byte	0
	.uleb128 0x22
	.byte	0x28
	.byte	0x2
	.2byte	0x1a1
	.byte	0x5
	.4byte	0x1ae
	.uleb128 0x15
	.4byte	.LASF28
	.2byte	0x1a6
	.4byte	0x10c
	.uleb128 0x15
	.4byte	.LASF29
	.2byte	0x1aa
	.4byte	0x13c
	.uleb128 0x15
	.4byte	.LASF30
	.2byte	0x1ae
	.4byte	0x15f
	.byte	0
	.uleb128 0x23
	.4byte	.LASF81
	.byte	0x30
	.byte	0x2
	.2byte	0x19d
	.byte	0x10
	.4byte	0x1e4
	.uleb128 0x7
	.4byte	.LASF31
	.2byte	0x19f
	.byte	0x14
	.4byte	0x1e4
	.byte	0
	.uleb128 0x7
	.4byte	.LASF32
	.2byte	0x1a0
	.byte	0x11
	.4byte	0x62
	.byte	0x4
	.uleb128 0x7
	.4byte	.LASF33
	.2byte	0x1af
	.byte	0xd
	.4byte	0x182
	.byte	0x8
	.byte	0
	.uleb128 0xd
	.4byte	0x1ae
	.uleb128 0x8
	.4byte	.LASF34
	.2byte	0x1b0
	.byte	0x9
	.4byte	0x1ae
	.uleb128 0x8
	.4byte	.LASF35
	.2byte	0x1b0
	.byte	0x14
	.4byte	0x1e4
	.uleb128 0x4
	.4byte	.LASF36
	.byte	0x1b
	.byte	0xd
	.4byte	0x1f5
	.uleb128 0x5
	.byte	0x3
	.4byte	Ptr_Glob
	.uleb128 0x4
	.4byte	.LASF37
	.byte	0x1c
	.byte	0x11
	.4byte	0x1f5
	.uleb128 0x5
	.byte	0x3
	.4byte	Next_Ptr_Glob
	.uleb128 0x4
	.4byte	.LASF38
	.byte	0x1d
	.byte	0x5
	.4byte	0x9f
	.uleb128 0x5
	.byte	0x3
	.4byte	Int_Glob
	.uleb128 0x4
	.4byte	.LASF39
	.byte	0x1e
	.byte	0x9
	.4byte	0xbe
	.uleb128 0x5
	.byte	0x3
	.4byte	Bool_Glob
	.uleb128 0x4
	.4byte	.LASF40
	.byte	0x1f
	.byte	0x6
	.4byte	0xb2
	.uleb128 0x5
	.byte	0x3
	.4byte	Ch_1_Glob
	.uleb128 0x4
	.4byte	.LASF41
	.byte	0x20
	.byte	0x11
	.4byte	0xb2
	.uleb128 0x5
	.byte	0x3
	.4byte	Ch_2_Glob
	.uleb128 0x4
	.4byte	.LASF42
	.byte	0x21
	.byte	0x5
	.4byte	0xe6
	.uleb128 0x5
	.byte	0x3
	.4byte	Arr_1_Glob
	.uleb128 0x4
	.4byte	.LASF43
	.byte	0x22
	.byte	0x5
	.4byte	0xf6
	.uleb128 0x5
	.byte	0x3
	.4byte	Arr_2_Glob
	.uleb128 0x24
	.string	"Reg"
	.byte	0x1
	.byte	0x29
	.byte	0x11
	.4byte	0xbe
	.uleb128 0x5
	.byte	0x3
	.4byte	Reg
	.uleb128 0x4
	.4byte	.LASF44
	.byte	0x45
	.byte	0x6
	.4byte	0x7c
	.uleb128 0x5
	.byte	0x3
	.4byte	Begin_Time
	.uleb128 0x4
	.4byte	.LASF45
	.byte	0x46
	.byte	0x11
	.4byte	0x7c
	.uleb128 0x5
	.byte	0x3
	.4byte	End_Time
	.uleb128 0x4
	.4byte	.LASF46
	.byte	0x47
	.byte	0x11
	.4byte	0x7c
	.uleb128 0x5
	.byte	0x3
	.4byte	User_Time
	.uleb128 0x4
	.4byte	.LASF47
	.byte	0x48
	.byte	0x7
	.4byte	0x2df
	.uleb128 0x5
	.byte	0x3
	.4byte	Microseconds
	.uleb128 0x6
	.byte	0x4
	.byte	0x4
	.4byte	.LASF48
	.uleb128 0x4
	.4byte	.LASF49
	.byte	0x49
	.byte	0x11
	.4byte	0x2df
	.uleb128 0x5
	.byte	0x3
	.4byte	Dhrystones_Per_Second
	.uleb128 0x3
	.4byte	.LASF50
	.byte	0xcf
	.byte	0x9
	.4byte	0x9f
	.4byte	0x308
	.uleb128 0x2
	.byte	0
	.uleb128 0x3
	.4byte	.LASF51
	.byte	0x25
	.byte	0xd
	.4byte	0x62
	.4byte	0x319
	.uleb128 0x2
	.byte	0
	.uleb128 0x3
	.4byte	.LASF52
	.byte	0xc6
	.byte	0x5
	.4byte	0x9f
	.4byte	0x32a
	.uleb128 0x2
	.byte	0
	.uleb128 0x3
	.4byte	.LASF53
	.byte	0xc1
	.byte	0x7
	.4byte	0x9f
	.4byte	0x33b
	.uleb128 0x2
	.byte	0
	.uleb128 0x3
	.4byte	.LASF54
	.byte	0xbb
	.byte	0x13
	.4byte	0x9f
	.4byte	0x34c
	.uleb128 0x2
	.byte	0
	.uleb128 0x25
	.4byte	.LASF55
	.byte	0x3
	.byte	0xa
	.byte	0x6
	.4byte	0x35e
	.uleb128 0x26
	.4byte	0x35e
	.byte	0
	.uleb128 0xd
	.4byte	0xb9
	.uleb128 0x27
	.4byte	.LASF77
	.byte	0x1
	.2byte	0x198
	.byte	0x1
	.4byte	0x9f
	.byte	0x1
	.uleb128 0x16
	.4byte	.LASF56
	.2byte	0x18c
	.4byte	0x9f
	.4byte	0x38d
	.uleb128 0x17
	.4byte	.LASF61
	.2byte	0x190
	.byte	0xb
	.4byte	0xbe
	.byte	0
	.uleb128 0x16
	.4byte	.LASF57
	.2byte	0x17d
	.4byte	0x9f
	.4byte	0x3b7
	.uleb128 0x1a
	.4byte	.LASF59
	.2byte	0x182
	.byte	0xe
	.4byte	0x3b7
	.uleb128 0x28
	.4byte	.LASF53
	.byte	0x1
	.byte	0xc1
	.byte	0x7
	.4byte	0x9f
	.uleb128 0x2
	.byte	0
	.byte	0
	.uleb128 0xd
	.4byte	0x1f5
	.uleb128 0x16
	.4byte	.LASF58
	.2byte	0x166
	.4byte	0x9f
	.4byte	0x3f0
	.uleb128 0x1a
	.4byte	.LASF60
	.2byte	0x16b
	.byte	0xc
	.4byte	0x3f0
	.uleb128 0x17
	.4byte	.LASF62
	.2byte	0x16d
	.byte	0xd
	.4byte	0xa6
	.uleb128 0x17
	.4byte	.LASF63
	.2byte	0x16e
	.byte	0xf
	.4byte	0x62
	.byte	0
	.uleb128 0xd
	.4byte	0xa6
	.uleb128 0x29
	.4byte	.LASF64
	.byte	0x1
	.2byte	0x144
	.byte	0x1
	.4byte	0x9f
	.4byte	.LFB2
	.4byte	.LFE2-.LFB2
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x4c5
	.uleb128 0x2a
	.4byte	.LASF82
	.byte	0x1
	.2byte	0x147
	.byte	0xe
	.4byte	0x1f5
	.4byte	.LLST2
	.uleb128 0x2b
	.4byte	.LASF66
	.byte	0x1
	.2byte	0x14a
	.byte	0xf
	.4byte	0x1f5
	.4byte	.LLST3
	.uleb128 0x2c
	.4byte	.LASF57
	.byte	0x1
	.2byte	0x154
	.byte	0x3
	.4byte	0x9f
	.4byte	0x445
	.uleb128 0x2
	.byte	0
	.uleb128 0x18
	.4byte	.LLRL6
	.4byte	0x494
	.uleb128 0x3
	.4byte	.LASF50
	.byte	0xcf
	.byte	0x9
	.4byte	0x9f
	.4byte	0x45f
	.uleb128 0x2
	.byte	0
	.uleb128 0x3
	.4byte	.LASF53
	.byte	0xc1
	.byte	0x7
	.4byte	0x9f
	.4byte	0x470
	.uleb128 0x2
	.byte	0
	.uleb128 0xe
	.4byte	.LVL12
	.4byte	0x2f7
	.4byte	0x484
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x5b
	.uleb128 0x2
	.byte	0x78
	.sleb128 8
	.byte	0
	.uleb128 0x1b
	.4byte	.LVL15
	.4byte	0x32a
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x5b
	.uleb128 0x1
	.byte	0x3a
	.byte	0
	.byte	0
	.uleb128 0x2d
	.4byte	0x38d
	.4byte	.LBB22
	.4byte	.LLRL4
	.byte	0x1
	.2byte	0x154
	.byte	0x3
	.uleb128 0x5
	.4byte	0x39c
	.4byte	.LLST5
	.uleb128 0x11
	.4byte	.LLRL4
	.uleb128 0xf
	.4byte	.LVL8
	.4byte	0x32a
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x5a
	.uleb128 0x1
	.byte	0x3a
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x2e
	.4byte	.LASF65
	.byte	0x1
	.byte	0x5c
	.byte	0x1
	.4byte	0x9f
	.4byte	.LFB1
	.4byte	.LFE1-.LFB1
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x809
	.uleb128 0x9
	.4byte	.LASF67
	.byte	0x62
	.byte	0x13
	.4byte	0xa6
	.4byte	.LLST7
	.uleb128 0x9
	.4byte	.LASF68
	.byte	0x63
	.byte	0xd
	.4byte	0xa6
	.4byte	.LLST8
	.uleb128 0xa
	.4byte	.LASF69
	.byte	0x64
	.byte	0x13
	.4byte	0xa6
	.uleb128 0x3
	.byte	0x91
	.sleb128 -232
	.uleb128 0x9
	.4byte	.LASF70
	.byte	0x65
	.byte	0x8
	.4byte	0xb2
	.4byte	.LLST9
	.uleb128 0xa
	.4byte	.LASF63
	.byte	0x66
	.byte	0x15
	.4byte	0x62
	.uleb128 0x3
	.byte	0x91
	.sleb128 -228
	.uleb128 0xa
	.4byte	.LASF71
	.byte	0x67
	.byte	0x10
	.4byte	0xca
	.uleb128 0x3
	.byte	0x91
	.sleb128 -224
	.uleb128 0xa
	.4byte	.LASF72
	.byte	0x68
	.byte	0x10
	.4byte	0xca
	.uleb128 0x3
	.byte	0x91
	.sleb128 -192
	.uleb128 0x9
	.4byte	.LASF73
	.byte	0x69
	.byte	0x7
	.4byte	0x9f
	.4byte	.LLST10
	.uleb128 0x2f
	.4byte	.LASF74
	.byte	0x1
	.byte	0x6a
	.byte	0x7
	.4byte	0x9f
	.byte	0xa
	.uleb128 0xa
	.4byte	.LASF75
	.byte	0x70
	.byte	0xc
	.4byte	0x1e9
	.uleb128 0x3
	.byte	0x91
	.sleb128 -160
	.uleb128 0xa
	.4byte	.LASF76
	.byte	0x71
	.byte	0xc
	.4byte	0x1e9
	.uleb128 0x3
	.byte	0x91
	.sleb128 -112
	.uleb128 0x9
	.4byte	.LASF37
	.byte	0x73
	.byte	0xf
	.4byte	0x1f5
	.4byte	.LLST11
	.uleb128 0x9
	.4byte	.LASF36
	.byte	0x74
	.byte	0xf
	.4byte	0x1f5
	.4byte	.LLST12
	.uleb128 0x18
	.4byte	.LLRL19
	.4byte	0x77e
	.uleb128 0x3
	.4byte	.LASF77
	.byte	0xb4
	.byte	0x5
	.4byte	0x9f
	.4byte	0x5ba
	.uleb128 0x2
	.byte	0
	.uleb128 0x3
	.4byte	.LASF56
	.byte	0xb5
	.byte	0x5
	.4byte	0x9f
	.4byte	0x5cb
	.uleb128 0x2
	.byte	0
	.uleb128 0x3
	.4byte	.LASF54
	.byte	0xbb
	.byte	0x13
	.4byte	0x9f
	.4byte	0x5dc
	.uleb128 0x2
	.byte	0
	.uleb128 0x3
	.4byte	.LASF52
	.byte	0xc6
	.byte	0x5
	.4byte	0x9f
	.4byte	0x5ed
	.uleb128 0x2
	.byte	0
	.uleb128 0x3
	.4byte	.LASF64
	.byte	0xc8
	.byte	0x5
	.4byte	0x9f
	.4byte	0x5fe
	.uleb128 0x2
	.byte	0
	.uleb128 0x3
	.4byte	.LASF58
	.byte	0xda
	.byte	0x5
	.4byte	0x9f
	.4byte	0x60f
	.uleb128 0x2
	.byte	0
	.uleb128 0x18
	.4byte	.LLRL23
	.4byte	0x645
	.uleb128 0x3
	.4byte	.LASF53
	.byte	0xc1
	.byte	0x7
	.4byte	0x9f
	.4byte	0x629
	.uleb128 0x2
	.byte	0
	.uleb128 0xf
	.4byte	.LVL38
	.4byte	0x32a
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x5a
	.uleb128 0x1
	.byte	0x32
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x5b
	.uleb128 0x1
	.byte	0x33
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x5c
	.uleb128 0x3
	.byte	0x91
	.sleb128 -232
	.byte	0
	.byte	0
	.uleb128 0x30
	.4byte	.LBB56
	.4byte	.LBE56-.LBB56
	.4byte	0x6a9
	.uleb128 0x3
	.4byte	.LASF50
	.byte	0xcf
	.byte	0x9
	.4byte	0x9f
	.4byte	0x663
	.uleb128 0x2
	.byte	0
	.uleb128 0x1c
	.4byte	0x809
	.4byte	.LBB57
	.4byte	.LBE57-.LBB57
	.byte	0xd0
	.byte	0x9
	.4byte	0x692
	.uleb128 0x5
	.4byte	0x81a
	.4byte	.LLST28
	.uleb128 0x5
	.4byte	0x826
	.4byte	.LLST29
	.uleb128 0xb
	.4byte	0x832
	.4byte	.LLST30
	.byte	0
	.uleb128 0xf
	.4byte	.LVL51
	.4byte	0x2f7
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x5a
	.uleb128 0x1
	.byte	0x30
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x5b
	.uleb128 0x3
	.byte	0x91
	.sleb128 -228
	.byte	0
	.byte	0
	.uleb128 0x19
	.4byte	0x371
	.4byte	.LBB37
	.4byte	.LLRL20
	.byte	0xb5
	.byte	0x5
	.4byte	0x6cc
	.uleb128 0x11
	.4byte	.LLRL20
	.uleb128 0xb
	.4byte	0x380
	.4byte	.LLST21
	.byte	0
	.byte	0
	.uleb128 0x31
	.4byte	0x363
	.4byte	.LBB42
	.4byte	.LLRL22
	.byte	0x1
	.byte	0xb4
	.byte	0x5
	.uleb128 0x19
	.4byte	0x809
	.4byte	.LBB49
	.4byte	.LLRL24
	.byte	0xb9
	.byte	0x5
	.4byte	0x711
	.uleb128 0x5
	.4byte	0x81a
	.4byte	.LLST25
	.uleb128 0x5
	.4byte	0x826
	.4byte	.LLST26
	.uleb128 0x11
	.4byte	.LLRL24
	.uleb128 0xb
	.4byte	0x832
	.4byte	.LLST27
	.byte	0
	.byte	0
	.uleb128 0xe
	.4byte	.LVL37
	.4byte	0x33b
	.4byte	0x72d
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x5a
	.uleb128 0x3
	.byte	0x91
	.sleb128 -224
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x5b
	.uleb128 0x3
	.byte	0x91
	.sleb128 -192
	.byte	0
	.uleb128 0xe
	.4byte	.LVL39
	.4byte	0x319
	.4byte	0x752
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x5a
	.uleb128 0x5
	.byte	0x3
	.4byte	.LANCHOR0
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x5b
	.uleb128 0x5
	.byte	0x3
	.4byte	Arr_2_Glob
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x5c
	.uleb128 0x1
	.byte	0x33
	.byte	0
	.uleb128 0xe
	.4byte	.LVL41
	.4byte	0x3f5
	.4byte	0x767
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x5a
	.uleb128 0x3
	.byte	0x91
	.sleb128 -112
	.byte	0
	.uleb128 0xf
	.4byte	.LVL43
	.4byte	0x308
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x5a
	.uleb128 0x2
	.byte	0x86
	.sleb128 0
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x5b
	.uleb128 0x2
	.byte	0x8
	.byte	0x43
	.byte	0
	.byte	0
	.uleb128 0x19
	.4byte	0x809
	.4byte	.LBB30
	.4byte	.LLRL13
	.byte	0x7a
	.byte	0x3
	.4byte	0x7b3
	.uleb128 0x5
	.4byte	0x81a
	.4byte	.LLST14
	.uleb128 0x5
	.4byte	0x826
	.4byte	.LLST15
	.uleb128 0x11
	.4byte	.LLRL13
	.uleb128 0xb
	.4byte	0x832
	.4byte	.LLST16
	.byte	0
	.byte	0
	.uleb128 0x1c
	.4byte	0x809
	.4byte	.LBB34
	.4byte	.LBE34-.LBB34
	.byte	0x7c
	.byte	0x3
	.4byte	0x7de
	.uleb128 0x5
	.4byte	0x81a
	.4byte	.LLST17
	.uleb128 0x5
	.4byte	0x826
	.4byte	.LLST18
	.uleb128 0x32
	.4byte	0x832
	.byte	0
	.uleb128 0xe
	.4byte	.LVL28
	.4byte	0x34c
	.4byte	0x7f5
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x5a
	.uleb128 0x5
	.byte	0x3
	.4byte	.LC4
	.byte	0
	.uleb128 0xf
	.4byte	.LVL47
	.4byte	0x34c
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x5a
	.uleb128 0x5
	.byte	0x3
	.4byte	.LC5
	.byte	0
	.byte	0
	.uleb128 0x33
	.4byte	.LASF83
	.byte	0x1
	.byte	0x4d
	.byte	0x7
	.4byte	0x83f
	.byte	0x1
	.4byte	0x83f
	.uleb128 0x34
	.4byte	.LASF78
	.byte	0x1
	.byte	0x4d
	.byte	0x14
	.4byte	0x83f
	.uleb128 0x35
	.string	"src"
	.byte	0x1
	.byte	0x4d
	.byte	0x26
	.4byte	0x35e
	.uleb128 0x36
	.4byte	.LASF79
	.byte	0x1
	.byte	0x4e
	.byte	0xb
	.4byte	0x83f
	.byte	0
	.uleb128 0xd
	.4byte	0xb2
	.uleb128 0x12
	.4byte	0x809
	.4byte	.LFB0
	.4byte	.LFE0-.LFB0
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x871
	.uleb128 0x5
	.4byte	0x81a
	.4byte	.LLST0
	.uleb128 0x5
	.4byte	0x826
	.4byte	.LLST1
	.uleb128 0x1d
	.4byte	0x832
	.uleb128 0x1
	.byte	0x5a
	.byte	0
	.uleb128 0x12
	.4byte	0x3bc
	.4byte	.LFB3
	.4byte	.LFE3-.LFB3
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x8a0
	.uleb128 0x5
	.4byte	0x3cb
	.4byte	.LLST31
	.uleb128 0xb
	.4byte	0x3d7
	.4byte	.LLST32
	.uleb128 0xb
	.4byte	0x3e3
	.4byte	.LLST33
	.byte	0
	.uleb128 0x12
	.4byte	0x38d
	.4byte	.LFB4
	.4byte	.LFE4-.LFB4
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x8cc
	.uleb128 0x5
	.4byte	0x39c
	.4byte	.LLST34
	.uleb128 0x1b
	.4byte	.LVL68
	.4byte	0x32a
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x5a
	.uleb128 0x1
	.byte	0x3a
	.byte	0
	.byte	0
	.uleb128 0x12
	.4byte	0x371
	.4byte	.LFB5
	.4byte	.LFE5-.LFB5
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x8f4
	.uleb128 0x1d
	.4byte	0x380
	.uleb128 0xe
	.byte	0x3
	.4byte	Ch_1_Glob
	.byte	0x94
	.byte	0x1
	.byte	0x8
	.byte	0x41
	.byte	0x29
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x9f
	.byte	0
	.uleb128 0x37
	.4byte	0x363
	.4byte	.LFB6
	.4byte	.LFE6-.LFB6
	.uleb128 0x1
	.byte	0x9c
	.byte	0
	.section	.debug_abbrev,"",@progbits
.Ldebug_abbrev0:
	.uleb128 0x1
	.uleb128 0x49
	.byte	0
	.uleb128 0x2
	.uleb128 0x18
	.uleb128 0x7e
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
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
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3c
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x4
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
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x5
	.uleb128 0x5
	.byte	0
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x6
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
	.uleb128 0x7
	.uleb128 0xd
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
	.uleb128 0x38
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x8
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
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0xb
	.uleb128 0x34
	.byte	0
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0xc
	.uleb128 0x28
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x1c
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0xd
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0x21
	.sleb128 4
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xe
	.uleb128 0x48
	.byte	0x1
	.uleb128 0x7d
	.uleb128 0x1
	.uleb128 0x7f
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xf
	.uleb128 0x48
	.byte	0x1
	.uleb128 0x7d
	.uleb128 0x1
	.uleb128 0x7f
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x10
	.uleb128 0x21
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2f
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x11
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x55
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x12
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
	.uleb128 0x13
	.uleb128 0x1
	.byte	0x1
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x14
	.uleb128 0x13
	.byte	0x1
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 2
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0x21
	.sleb128 11
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x15
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 2
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0x21
	.sleb128 21
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x16
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
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x20
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x17
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x18
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x55
	.uleb128 0x17
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x19
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
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x1a
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x1b
	.uleb128 0x48
	.byte	0x1
	.uleb128 0x7d
	.uleb128 0x1
	.uleb128 0x82
	.uleb128 0x19
	.uleb128 0x7f
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x1c
	.uleb128 0x1d
	.byte	0x1
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x58
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x59
	.uleb128 0xb
	.uleb128 0x57
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x1d
	.uleb128 0x34
	.byte	0
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x1e
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
	.uleb128 0x55
	.uleb128 0x17
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x10
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x1f
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
	.uleb128 0x20
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
	.uleb128 0x21
	.uleb128 0x26
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x22
	.uleb128 0x17
	.byte	0x1
	.uleb128 0xb
	.uleb128 0xb
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
	.uleb128 0x23
	.uleb128 0x13
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0xb
	.uleb128 0xb
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
	.uleb128 0x24
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
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x25
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
	.uleb128 0x3c
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x26
	.uleb128 0x5
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x27
	.uleb128 0x2e
	.byte	0
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x20
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x28
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
	.byte	0
	.byte	0
	.uleb128 0x29
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
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
	.uleb128 0x2a
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x2b
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x2c
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
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
	.uleb128 0x2d
	.uleb128 0x1d
	.byte	0x1
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x52
	.uleb128 0x1
	.uleb128 0x55
	.uleb128 0x17
	.uleb128 0x58
	.uleb128 0xb
	.uleb128 0x59
	.uleb128 0x5
	.uleb128 0x57
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x2e
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
	.uleb128 0x2f
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
	.uleb128 0x30
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x31
	.uleb128 0x1d
	.byte	0
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x52
	.uleb128 0x1
	.uleb128 0x55
	.uleb128 0x17
	.uleb128 0x58
	.uleb128 0xb
	.uleb128 0x59
	.uleb128 0xb
	.uleb128 0x57
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x32
	.uleb128 0x34
	.byte	0
	.uleb128 0x31
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x33
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
	.uleb128 0x20
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x34
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
	.byte	0
	.byte	0
	.uleb128 0x35
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
	.uleb128 0x36
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
	.byte	0
	.byte	0
	.uleb128 0x37
	.uleb128 0x2e
	.byte	0
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
.LLST2:
	.byte	0x6
	.4byte	.LVL4
	.byte	0x4
	.uleb128 .LVL4-.LVL4
	.uleb128 .LVL6-.LVL4
	.uleb128 0x1
	.byte	0x5a
	.byte	0x4
	.uleb128 .LVL6-.LVL4
	.uleb128 .LVL10-.LVL4
	.uleb128 0x1
	.byte	0x59
	.byte	0x4
	.uleb128 .LVL10-.LVL4
	.uleb128 .LVL11-.LVL4
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
	.uleb128 .LVL11-.LVL4
	.uleb128 .LVL13-.LVL4
	.uleb128 0x1
	.byte	0x59
	.byte	0x4
	.uleb128 .LVL13-.LVL4
	.uleb128 .LFE2-.LVL4
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
.LLST3:
	.byte	0x6
	.4byte	.LVL5
	.byte	0x4
	.uleb128 .LVL5-.LVL5
	.uleb128 .LVL9-.LVL5
	.uleb128 0x1
	.byte	0x58
	.byte	0x4
	.uleb128 .LVL11-.LVL5
	.uleb128 .LVL14-.LVL5
	.uleb128 0x1
	.byte	0x58
	.byte	0x4
	.uleb128 .LVL14-.LVL5
	.uleb128 .LVL15-1-.LVL5
	.uleb128 0x3
	.byte	0x7c
	.sleb128 -12
	.byte	0x9f
	.byte	0
.LLST5:
	.byte	0x8
	.4byte	.LVL7
	.uleb128 .LVL8-.LVL7
	.uleb128 0x1
	.byte	0x58
	.byte	0
.LLST7:
	.byte	0x6
	.4byte	.LVL31
	.byte	0x4
	.uleb128 .LVL31-.LVL31
	.uleb128 .LVL38-.LVL31
	.uleb128 0x2
	.byte	0x32
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL38-.LVL31
	.uleb128 .LVL45-.LVL31
	.uleb128 0x2
	.byte	0x33
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL50-.LVL31
	.uleb128 .LFE1-.LVL31
	.uleb128 0x2
	.byte	0x33
	.byte	0x9f
	.byte	0
.LLST8:
	.byte	0x6
	.4byte	.LVL31
	.byte	0x4
	.uleb128 .LVL31-.LVL31
	.uleb128 .LVL41-.LVL31
	.uleb128 0x2
	.byte	0x33
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL56-.LVL31
	.uleb128 .LFE1-.LVL31
	.uleb128 0x1
	.byte	0x59
	.byte	0
.LLST9:
	.byte	0x6
	.4byte	.LVL41
	.byte	0x4
	.uleb128 .LVL41-.LVL41
	.uleb128 .LVL42-.LVL41
	.uleb128 0x3
	.byte	0x8
	.byte	0x41
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL42-.LVL41
	.uleb128 .LVL45-.LVL41
	.uleb128 0x1
	.byte	0x66
	.byte	0x4
	.uleb128 .LVL50-.LVL41
	.uleb128 .LFE1-.LVL41
	.uleb128 0x1
	.byte	0x66
	.byte	0
.LLST10:
	.byte	0x6
	.4byte	.LVL28
	.byte	0x4
	.uleb128 .LVL28-.LVL28
	.uleb128 .LVL29-.LVL28
	.uleb128 0x2
	.byte	0x31
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL29-.LVL28
	.uleb128 .LVL48-.LVL28
	.uleb128 0x1
	.byte	0x59
	.byte	0x4
	.uleb128 .LVL50-.LVL28
	.uleb128 .LFE1-.LVL28
	.uleb128 0x1
	.byte	0x59
	.byte	0
.LLST11:
	.byte	0x6
	.4byte	.LVL16
	.byte	0x4
	.uleb128 .LVL16-.LVL16
	.uleb128 .LVL17-.LVL16
	.uleb128 0x4
	.byte	0x91
	.sleb128 -160
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL17-.LVL16
	.uleb128 .LVL28-1-.LVL16
	.uleb128 0x1
	.byte	0x5c
	.byte	0x4
	.uleb128 .LVL28-1-.LVL16
	.uleb128 .LVL49-.LVL16
	.uleb128 0x4
	.byte	0x91
	.sleb128 -160
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL49-.LVL16
	.uleb128 .LVL50-.LVL16
	.uleb128 0x4
	.byte	0x72
	.sleb128 -160
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL50-.LVL16
	.uleb128 .LFE1-.LVL16
	.uleb128 0x4
	.byte	0x91
	.sleb128 -160
	.byte	0x9f
	.byte	0
.LLST12:
	.byte	0x6
	.4byte	.LVL16
	.byte	0x4
	.uleb128 .LVL16-.LVL16
	.uleb128 .LVL40-.LVL16
	.uleb128 0x4
	.byte	0x91
	.sleb128 -112
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL40-.LVL16
	.uleb128 .LVL41-1-.LVL16
	.uleb128 0x1
	.byte	0x5a
	.byte	0x4
	.uleb128 .LVL41-1-.LVL16
	.uleb128 .LVL49-.LVL16
	.uleb128 0x4
	.byte	0x91
	.sleb128 -112
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL49-.LVL16
	.uleb128 .LVL50-.LVL16
	.uleb128 0x4
	.byte	0x72
	.sleb128 -112
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL50-.LVL16
	.uleb128 .LFE1-.LVL16
	.uleb128 0x4
	.byte	0x91
	.sleb128 -112
	.byte	0x9f
	.byte	0
.LLST28:
	.byte	0x6
	.4byte	.LVL51
	.byte	0x4
	.uleb128 .LVL51-.LVL51
	.uleb128 .LVL52-.LVL51
	.uleb128 0x4
	.byte	0x91
	.sleb128 -192
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL52-.LVL51
	.uleb128 .LVL56-.LVL51
	.uleb128 0x1
	.byte	0x5d
	.byte	0
.LLST29:
	.byte	0x6
	.4byte	.LVL51
	.byte	0x4
	.uleb128 .LVL51-.LVL51
	.uleb128 .LVL53-.LVL51
	.uleb128 0x6
	.byte	0x3
	.4byte	.LC3
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL53-.LVL51
	.uleb128 .LVL56-.LVL51
	.uleb128 0x1
	.byte	0x5e
	.byte	0
.LLST30:
	.byte	0x6
	.4byte	.LVL51
	.byte	0x4
	.uleb128 .LVL51-.LVL51
	.uleb128 .LVL52-.LVL51
	.uleb128 0x4
	.byte	0x91
	.sleb128 -192
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL52-.LVL51
	.uleb128 .LVL53-.LVL51
	.uleb128 0x1
	.byte	0x5d
	.byte	0x4
	.uleb128 .LVL53-.LVL51
	.uleb128 .LFE1-.LVL51
	.uleb128 0x4
	.byte	0x91
	.sleb128 -192
	.byte	0x9f
	.byte	0
.LLST21:
	.byte	0x8
	.4byte	.LVL30
	.uleb128 .LVL31-.LVL30
	.uleb128 0x2
	.byte	0x31
	.byte	0x9f
	.byte	0
.LLST25:
	.byte	0x6
	.4byte	.LVL31
	.byte	0x4
	.uleb128 .LVL31-.LVL31
	.uleb128 .LVL32-.LVL31
	.uleb128 0x4
	.byte	0x91
	.sleb128 -192
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL32-.LVL31
	.uleb128 .LVL35-.LVL31
	.uleb128 0x1
	.byte	0x5f
	.byte	0
.LLST26:
	.byte	0x6
	.4byte	.LVL31
	.byte	0x4
	.uleb128 .LVL31-.LVL31
	.uleb128 .LVL32-.LVL31
	.uleb128 0x6
	.byte	0x3
	.4byte	.LC2
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL32-.LVL31
	.uleb128 .LVL35-.LVL31
	.uleb128 0x1
	.byte	0x5e
	.byte	0
.LLST27:
	.byte	0x6
	.4byte	.LVL31
	.byte	0x4
	.uleb128 .LVL31-.LVL31
	.uleb128 .LVL36-.LVL31
	.uleb128 0x4
	.byte	0x91
	.sleb128 -192
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL36-.LVL31
	.uleb128 .LVL37-1-.LVL31
	.uleb128 0x1
	.byte	0x5b
	.byte	0x4
	.uleb128 .LVL37-1-.LVL31
	.uleb128 .LVL49-.LVL31
	.uleb128 0x4
	.byte	0x91
	.sleb128 -192
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL49-.LVL31
	.uleb128 .LVL50-.LVL31
	.uleb128 0x4
	.byte	0x72
	.sleb128 -192
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL50-.LVL31
	.uleb128 .LVL52-.LVL31
	.uleb128 0x4
	.byte	0x91
	.sleb128 -192
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL52-.LVL31
	.uleb128 .LVL53-.LVL31
	.uleb128 0x1
	.byte	0x5d
	.byte	0x4
	.uleb128 .LVL53-.LVL31
	.uleb128 .LFE1-.LVL31
	.uleb128 0x4
	.byte	0x91
	.sleb128 -192
	.byte	0x9f
	.byte	0
.LLST14:
	.byte	0x6
	.4byte	.LVL18
	.byte	0x4
	.uleb128 .LVL18-.LVL18
	.uleb128 .LVL19-.LVL18
	.uleb128 0x4
	.byte	0x91
	.sleb128 -96
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL19-.LVL18
	.uleb128 .LVL23-.LVL18
	.uleb128 0x1
	.byte	0x5e
	.byte	0
.LLST15:
	.byte	0x6
	.4byte	.LVL18
	.byte	0x4
	.uleb128 .LVL18-.LVL18
	.uleb128 .LVL19-.LVL18
	.uleb128 0x6
	.byte	0x3
	.4byte	.LC0
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL19-.LVL18
	.uleb128 .LVL22-.LVL18
	.uleb128 0x1
	.byte	0x5f
	.byte	0
.LLST16:
	.byte	0x6
	.4byte	.LVL18
	.byte	0x4
	.uleb128 .LVL18-.LVL18
	.uleb128 .LVL49-.LVL18
	.uleb128 0x4
	.byte	0x91
	.sleb128 -96
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL49-.LVL18
	.uleb128 .LVL50-.LVL18
	.uleb128 0x4
	.byte	0x72
	.sleb128 -96
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL50-.LVL18
	.uleb128 .LFE1-.LVL18
	.uleb128 0x4
	.byte	0x91
	.sleb128 -96
	.byte	0x9f
	.byte	0
.LLST17:
	.byte	0x8
	.4byte	.LVL23
	.uleb128 .LVL26-.LVL23
	.uleb128 0x1
	.byte	0x5e
	.byte	0
.LLST18:
	.byte	0x8
	.4byte	.LVL23
	.uleb128 .LVL26-.LVL23
	.uleb128 0x1
	.byte	0x5f
	.byte	0
.LLST0:
	.byte	0x6
	.4byte	.LVL0
	.byte	0x4
	.uleb128 .LVL0-.LVL0
	.uleb128 .LVL1-.LVL0
	.uleb128 0x1
	.byte	0x5a
	.byte	0x4
	.uleb128 .LVL1-.LVL0
	.uleb128 .LFE0-.LVL0
	.uleb128 0x1
	.byte	0x5f
	.byte	0
.LLST1:
	.byte	0x6
	.4byte	.LVL0
	.byte	0x4
	.uleb128 .LVL0-.LVL0
	.uleb128 .LVL2-.LVL0
	.uleb128 0x1
	.byte	0x5b
	.byte	0x4
	.uleb128 .LVL2-.LVL0
	.uleb128 .LFE0-.LVL0
	.uleb128 0x1
	.byte	0x5b
	.byte	0
.LLST31:
	.byte	0x6
	.4byte	.LVL57
	.byte	0x4
	.uleb128 .LVL57-.LVL57
	.uleb128 .LVL60-.LVL57
	.uleb128 0x1
	.byte	0x5a
	.byte	0x4
	.uleb128 .LVL60-.LVL57
	.uleb128 .LVL61-.LVL57
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
	.uleb128 .LVL61-.LVL57
	.uleb128 .LVL65-.LVL57
	.uleb128 0x1
	.byte	0x5a
	.byte	0x4
	.uleb128 .LVL65-.LVL57
	.uleb128 .LFE3-.LVL57
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
.LLST32:
	.byte	0x6
	.4byte	.LVL58
	.byte	0x4
	.uleb128 .LVL58-.LVL58
	.uleb128 .LVL59-.LVL58
	.uleb128 0x6
	.byte	0x7a
	.sleb128 0
	.byte	0x6
	.byte	0x23
	.uleb128 0xa
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL61-.LVL58
	.uleb128 .LVL62-.LVL58
	.uleb128 0x6
	.byte	0x7a
	.sleb128 0
	.byte	0x6
	.byte	0x23
	.uleb128 0x9
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL62-.LVL58
	.uleb128 .LVL63-.LVL58
	.uleb128 0x1
	.byte	0x5f
	.byte	0x4
	.uleb128 .LVL63-.LVL58
	.uleb128 .LVL64-.LVL58
	.uleb128 0x6
	.byte	0x7a
	.sleb128 0
	.byte	0x6
	.byte	0x23
	.uleb128 0x9
	.byte	0x9f
	.byte	0
.LLST33:
	.byte	0x6
	.4byte	.LVL59
	.byte	0x4
	.uleb128 .LVL59-.LVL59
	.uleb128 .LVL61-.LVL59
	.uleb128 0x2
	.byte	0x30
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL64-.LVL59
	.uleb128 .LFE3-.LVL59
	.uleb128 0x2
	.byte	0x30
	.byte	0x9f
	.byte	0
.LLST34:
	.byte	0x6
	.4byte	.LVL66
	.byte	0x4
	.uleb128 .LVL66-.LVL66
	.uleb128 .LVL67-.LVL66
	.uleb128 0x1
	.byte	0x5a
	.byte	0x4
	.uleb128 .LVL67-.LVL66
	.uleb128 .LFE4-.LVL66
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
	.4byte	0x24
	.2byte	0x2
	.4byte	.Ldebug_info0
	.byte	0x4
	.byte	0
	.2byte	0
	.2byte	0
	.4byte	.Ltext0
	.4byte	.Letext0-.Ltext0
	.4byte	.LFB1
	.4byte	.LFE1-.LFB1
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
.LLRL4:
	.byte	0x5
	.4byte	.LBB22
	.byte	0x4
	.uleb128 .LBB22-.LBB22
	.uleb128 .LBE22-.LBB22
	.byte	0x4
	.uleb128 .LBB25-.LBB22
	.uleb128 .LBE25-.LBB22
	.byte	0
.LLRL6:
	.byte	0x5
	.4byte	.LBB26
	.byte	0x4
	.uleb128 .LBB26-.LBB26
	.uleb128 .LBE26-.LBB26
	.byte	0x4
	.uleb128 .LBB27-.LBB26
	.uleb128 .LBE27-.LBB26
	.byte	0x4
	.uleb128 .LBB28-.LBB26
	.uleb128 .LBE28-.LBB26
	.byte	0x4
	.uleb128 .LBB29-.LBB26
	.uleb128 .LBE29-.LBB26
	.byte	0
.LLRL13:
	.byte	0x5
	.4byte	.LBB30
	.byte	0x4
	.uleb128 .LBB30-.LBB30
	.uleb128 .LBE30-.LBB30
	.byte	0x4
	.uleb128 .LBB33-.LBB30
	.uleb128 .LBE33-.LBB30
	.byte	0
.LLRL19:
	.byte	0x5
	.4byte	.LBB36
	.byte	0x4
	.uleb128 .LBB36-.LBB36
	.uleb128 .LBE36-.LBB36
	.byte	0x4
	.uleb128 .LBB59-.LBB36
	.uleb128 .LBE59-.LBB36
	.byte	0x4
	.uleb128 .LBB60-.LBB36
	.uleb128 .LBE60-.LBB36
	.byte	0
.LLRL20:
	.byte	0x5
	.4byte	.LBB37
	.byte	0x4
	.uleb128 .LBB37-.LBB37
	.uleb128 .LBE37-.LBB37
	.byte	0x4
	.uleb128 .LBB45-.LBB37
	.uleb128 .LBE45-.LBB37
	.byte	0x4
	.uleb128 .LBB48-.LBB37
	.uleb128 .LBE48-.LBB37
	.byte	0x4
	.uleb128 .LBB52-.LBB37
	.uleb128 .LBE52-.LBB37
	.byte	0
.LLRL22:
	.byte	0x5
	.4byte	.LBB42
	.byte	0x4
	.uleb128 .LBB42-.LBB42
	.uleb128 .LBE42-.LBB42
	.byte	0x4
	.uleb128 .LBB47-.LBB42
	.uleb128 .LBE47-.LBB42
	.byte	0
.LLRL23:
	.byte	0x5
	.4byte	.LBB46
	.byte	0x4
	.uleb128 .LBB46-.LBB46
	.uleb128 .LBE46-.LBB46
	.byte	0x4
	.uleb128 .LBB54-.LBB46
	.uleb128 .LBE54-.LBB46
	.byte	0x4
	.uleb128 .LBB55-.LBB46
	.uleb128 .LBE55-.LBB46
	.byte	0
.LLRL24:
	.byte	0x5
	.4byte	.LBB49
	.byte	0x4
	.uleb128 .LBB49-.LBB49
	.uleb128 .LBE49-.LBB49
	.byte	0x4
	.uleb128 .LBB53-.LBB49
	.uleb128 .LBE53-.LBB49
	.byte	0
.LLRL35:
	.byte	0x7
	.4byte	.Ltext0
	.uleb128 .Letext0-.Ltext0
	.byte	0x7
	.4byte	.LFB1
	.uleb128 .LFE1-.LFB1
	.byte	0
.Ldebug_ranges3:
	.section	.debug_line,"",@progbits
.Ldebug_line0:
	.section	.debug_str,"MS",@progbits,1
.LASF5:
	.string	"Ident_2"
.LASF6:
	.string	"Ident_3"
.LASF7:
	.string	"Ident_4"
.LASF8:
	.string	"Ident_5"
.LASF42:
	.string	"Arr_1_Glob"
.LASF59:
	.string	"Ptr_Ref_Par"
.LASF79:
	.string	"original_dest"
.LASF78:
	.string	"dest"
.LASF69:
	.string	"Int_3_Loc"
.LASF10:
	.string	"short int"
.LASF81:
	.string	"record"
.LASF45:
	.string	"End_Time"
.LASF46:
	.string	"User_Time"
.LASF65:
	.string	"main"
.LASF71:
	.string	"Str_1_Loc"
.LASF40:
	.string	"Ch_1_Glob"
.LASF30:
	.string	"var_3"
.LASF24:
	.string	"E_Comp_2"
.LASF34:
	.string	"Rec_Type"
.LASF68:
	.string	"Int_2_Loc"
.LASF48:
	.string	"float"
.LASF12:
	.string	"long long int"
.LASF26:
	.string	"Ch_1_Comp"
.LASF11:
	.string	"long int"
.LASF38:
	.string	"Int_Glob"
.LASF28:
	.string	"var_1"
.LASF29:
	.string	"var_2"
.LASF25:
	.string	"Str_2_Comp"
.LASF72:
	.string	"Str_2_Loc"
.LASF35:
	.string	"Rec_Pointer"
.LASF75:
	.string	"Next_glob"
.LASF13:
	.string	"unsigned char"
.LASF64:
	.string	"Proc_1"
.LASF21:
	.string	"Enum_Comp"
.LASF9:
	.string	"signed char"
.LASF22:
	.string	"Int_Comp"
.LASF2:
	.string	"long long unsigned int"
.LASF61:
	.string	"Bool_Loc"
.LASF56:
	.string	"Proc_4"
.LASF77:
	.string	"Proc_5"
.LASF3:
	.string	"unsigned int"
.LASF67:
	.string	"Int_1_Loc"
.LASF43:
	.string	"Arr_2_Glob"
.LASF36:
	.string	"Ptr_Glob"
.LASF52:
	.string	"Proc_8"
.LASF76:
	.string	"Glob"
.LASF14:
	.string	"short unsigned int"
.LASF58:
	.string	"Proc_2"
.LASF57:
	.string	"Proc_3"
.LASF19:
	.string	"Boolean"
.LASF50:
	.string	"Proc_6"
.LASF53:
	.string	"Proc_7"
.LASF18:
	.string	"char"
.LASF33:
	.string	"variant"
.LASF83:
	.string	"strcpy"
.LASF32:
	.string	"Discr"
.LASF73:
	.string	"Run_Index"
.LASF31:
	.string	"Ptr_Comp"
.LASF41:
	.string	"Ch_2_Glob"
.LASF37:
	.string	"Next_Ptr_Glob"
.LASF23:
	.string	"Str_Comp"
.LASF63:
	.string	"Enum_Loc"
.LASF15:
	.string	"long unsigned int"
.LASF55:
	.string	"uart_send"
.LASF20:
	.string	"Str_30"
.LASF80:
	.string	"GNU C17 14.2.0 -mabi=ilp32 -mstrict-align -mcmodel=medlow -mrelax -mtune=rocket -misa-spec=20191213 -march=rv32i -g -O2 -ffreestanding -fno-builtin -fno-pic"
.LASF60:
	.string	"Int_Par_Ref"
.LASF74:
	.string	"Number_Of_Runs"
.LASF17:
	.string	"One_Fifty"
.LASF82:
	.string	"Ptr_Val_Par"
.LASF16:
	.string	"Enumeration"
.LASF27:
	.string	"Ch_2_Comp"
.LASF49:
	.string	"Dhrystones_Per_Second"
.LASF39:
	.string	"Bool_Glob"
.LASF62:
	.string	"Int_Loc"
.LASF66:
	.string	"Next_Record"
.LASF47:
	.string	"Microseconds"
.LASF44:
	.string	"Begin_Time"
.LASF70:
	.string	"Ch_Index"
.LASF51:
	.string	"Func_1"
.LASF54:
	.string	"Func_2"
.LASF4:
	.string	"Ident_1"
	.section	.debug_line_str,"MS",@progbits,1
.LASF1:
	.string	"/home/tibrahimovic/projects/wireguard-fpga/3.build"
.LASF0:
	.string	"/home/tibrahimovic/projects/wireguard-fpga/3.build/../2.sw/app/dhry_1.c"
	.ident	"GCC: (g04696df0963) 14.2.0"
	.section	.note.GNU-stack,"",@progbits
