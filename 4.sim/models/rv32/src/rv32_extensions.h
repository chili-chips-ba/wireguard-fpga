
// *** AUTOMATICALLY GENERATED FILE. DO NOT EDIT! ***

#ifndef _RV32_EXTENSIONS_H_
#define _RV32_EXTENSIONS_H_

// Define the inheritance chain for adding new extensions.
// Currently this is setup to add Zicsr, M, A, F, and D
// in that order. If an extension were to be skipped,
// then the subsequent definition just uses the last
// active class to inherit from in place of the skipped
// class. Note, since the FENCE instruction is a NOP
// in this model, Zifencei is implicit in the rv32i_cpu
// base class.

#define RV32_I_INHERITANCE_CLASS         
#define RV32_ZICSR_INHERITANCE_CLASS     rv32i_cpu
#define RV32_M_INHERITANCE_CLASS         rv32csr_cpu
#define RV32_A_INHERITANCE_CLASS         rv32m_cpu
#define RV32_F_INHERITANCE_CLASS         rv32a_cpu
#define RV32_D_INHERITANCE_CLASS         rv32f_cpu
#define RV32_C_INHERITANCE_CLASS         rv32d_cpu
#define RV32_ZBA_INHERITANCE_CLASS       rv32c_cpu
#define RV32_ZBB_INHERITANCE_CLASS       rv32zba_cpu
#define RV32_ZBS_INHERITANCE_CLASS       rv32zbb_cpu
#define RV32_ZBC_INHERITANCE_CLASS       rv32zbs_cpu

// Uncomment the following to compile for RV32E base class,
// or define it when compiling rv32i_cpu.cpp

//#define RV32E_EXTENSION

// Define the class include file definitions used here. I.e. those needed
// for the target spec. Each one defines its predecessor, as including
// headers for later derived classes causes a compile error---even when
// using forward references (needs a completed class reference).

#define RV32CSR_INCLUDE                  "rv32i_cpu.h"
#define RV32M_INCLUDE                    "rv32csr_cpu.h"
#define RV32A_INCLUDE                    "rv32m_cpu.h"
#define RV32F_INCLUDE                    "rv32a_cpu.h"
#define RV32D_INCLUDE                    "rv32f_cpu.h"
#define RV32C_INCLUDE                    "rv32d_cpu.h"
#define RV32ZBA_INCLUDE                  "rv32c_cpu.h"
#define RV32ZBB_INCLUDE                  "rv32zba_cpu.h"
#define RV32ZBS_INCLUDE                  "rv32zbb_cpu.h"
#define RV32ZBC_INCLUDE                  "rv32zbs_cpu.h"

// Definition indictating presence of all B extensions, or not, for setting MISA
#define RV32CSR_EXT_B_CONFIG             RV32CSR_EXT_B

// Define the extension spec for the target model. Chose the
// highest order class that's needed.
#define RV32_TARGET_INHERITANCE_CLASS    rv32zbc_cpu

// Define target include: must match include of RV32_TARGET_INHERITANCE_CLASS
#define RV32_TARGET_INCLUDE             "rv32zbc_cpu.h"

#endif
