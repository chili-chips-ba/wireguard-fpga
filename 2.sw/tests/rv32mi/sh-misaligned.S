# See LICENSE for license details.

#include "riscv_test.h"
#undef RVTEST_RV64M
#define RVTEST_RV64M RVTEST_RV32M
#define __MACHINE_MODE

#include "test_macros.h"

RVTEST_RV64M
RVTEST_CODE_BEGIN

  TEST_ST_OP( 2, lh, sh, 0x1234, 0, tdat );
  TEST_ST_OP( 3, lh, sh, 0x5678, 1, tdat );

2:
  TEST_PASSFAIL

  .align 2
  .global mtvec_handler
mtvec_handler:
  MISALIGNED_STORE_HANDLER

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

tdat:
    .zero 4

RVTEST_DATA_END

