#define RVTEST_RV32M  
//revisit all of this after implementing, done by looking at official riscv-tests
#define MSTATUS_MIE 0x00000008 
#define MCONTROL_M (1<<(32-5)) //dmode?
#define MCONTROL_LOAD 1<<0
#define MCONTROL_EXECUTE 1<<2
#define MCONTROL_STORE 1<<1

#define CAUSE_ILLEGAL_INSTRUCTION 0
#define CAUSE_USER_ECALL 0
#define CAUSE_BREAKPOINT 0
#define CAUSE_MISALIGNED_LOAD 0 
#define CAUSE_LOAD_ACCESS 0
#define CAUSE_MISALIGNED_STORE 0
#define CAUSE_STORE_ACCESS 0
#define CAUSE_MISALIGNED_FETCH 0
#define CAUSE_MACHINE_ECALL 0 

#define MSTATUS_FS 0x00006000
#define MSTATUS_XS  0x00018000
#define MSTATUS_MPRV  0x00020000
#define MSTATUS_PUM  0x00040000
#define MSTATUS_MXR  0x00080000
#define MSTATUS_VM 0x1F000000
#define MSTATUS_MPP  0x00001800

#define PRV_S 0
#define MSTATUS_TVM 0 
#define MSTATUS_TSR 0 

#define SSTATUS_SPIE 0
#define SSTATUS_SUM 0
#define SSTATUS_MXR 0 

#define MIP_SSIP 0 



#define RVTEST_CODE_BEGIN .globl start_test; \
	start_test: \
	li a0, TESTCODE ; \
	call ra, uart_tests_info;
#define TESTNUM x28
#define RVTEST_PASS 		\
	la   sp, _stack_start; \
	li	a0, 0;	\
	call ra, uart_tests_info;		\
    ebreak;

#define RVTEST_FAIL			\
	la   sp, _stack_start;	\
	li	a0, 1;	\
	call ra, uart_tests_info;		\
    ebreak;
#define RVTEST_CODE_END
#define RVTEST_DATA_BEGIN .balign 4;
#define RVTEST_DATA_END