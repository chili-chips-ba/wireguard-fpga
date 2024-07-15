# See LICENSE for license details.

#include "riscv_test.h"
#undef RVTEST_RV64M
#define RVTEST_RV64M RVTEST_RV32M
#define __MACHINE_MODE

#include "test_macros.h"

RVTEST_RV64M
RVTEST_CODE_BEGIN

  TEST_LD_OP( 2, lh, 0x0201, 0,  tdat );
  TEST_LD_OP( 3, lh, 0x0302, 1,  tdat );

2:
  TEST_PASSFAIL

  .align 2
  .global mtvec_handler
mtvec_handler:
  MISALIGNED_LOAD_HANDLER

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

tdat:
    .byte 0x01, 0x02, 0x03, 0x04

RVTEST_DATA_END

