#define RVTEST_RV32U  
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