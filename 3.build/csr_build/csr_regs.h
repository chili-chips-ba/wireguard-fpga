// SPDX-FileCopyrightText: 2026 Chili.CHIPS
//
// SPDX-License-Identifier: BSD-3-Clause

//==========================================================================
// Description:
//   Firmware access to the CSR block: the accessors on top of the
//   PeakRDL-generated register layout. The same file in every Chili.CHIPS
//   SOC (openPCIE, openCologne-PCIE, WireGuard-FPGA); all that is project
//   specific comes from generated-files/ (make -f MakefileCSR).
//==========================================================================

#ifndef _CSR_REGS_H_
#define _CSR_REGS_H_

// csr.h:     register layout, field masks and positions ("peakrdl c-header"
//            from csr.rdl)
// csr_top.h: CSR_TOP_T, the struct of the SOC address map in csr.h
#include "csr.h"
#include "csr_top.h"

#include <stddef.h>
#include <stdint.h>

// Base address of the CSR block inside the SOC address map: where the
// address map in csr.rdl places its "csr" instance
#define CSR_BASE  ((uint32_t)(uintptr_t)&(((CSR_TOP_T *)0)->csr))

// Byte address of a register: CSR_ADDR(tx.header0), CSR_ADDR(table.entry[i].ip).
// The member's offset in the generated struct keeps csr.h the single source
// of truth for the layout. Not offsetof(): C++ wants a constant array index
// there, and register arrays may be indexed at run time.
#define CSR_ADDR(member)  (CSR_BASE + (uint32_t)(uintptr_t)&(((csr_t *)0)->member))

// Accessors
//
//   CSR_REG32(member)          the whole register, one 32-bit access:
//                                  CSR_REG32(tx.header0) = h0;
//                                  uint32_t s = CSR_REG32(status.phy);
//   CSR_GET(member, FLD)       one field, out of a 32-bit read
//   CSR_SET(member, FLD, v)    one field, written alone: a byte, half-word
//                              or word store of the bytes it occupies, the
//                              other bits in them written 0. For a field that
//                              owns its bytes
//   CSR_RMW(member, FLD, v)    one field, read-modify-write of the bytes it
//                              occupies. For a field that shares a byte with
//                              another field
//
// FLD is the generated field prefix, e.g. CSR__RX__HEADER_INFO__TAG.
//
// Do NOT dereference through the struct itself. "peakrdl c-header" marks every
// struct __attribute__((packed)), which tells the compiler the members may be
// unaligned. On a target without unaligned load/store -- rv32i, for one -- that
// turns a single register access into four byte accesses:
//
//     lbu a4,12(a5)  /  sb a4,12(a5)  /  lbu a4,13(a5)  ...
//
// which is wrong for a CSR: it writes a register in four steps, and a register
// whose write starts an action (a TLP, a FIFO push) starts it after the first
// byte, with the other three not yet written. Each macro here does exactly one
// bus write (and, for CSR_RMW, one read before it), as wide as the bytes it
// touches. Write such a register with CSR_REG32 only.
#define CSR_FLD_LO(FLD)      ((FLD##_bp) / 8)
#define CSR_FLD_N(FLD)       (((FLD##_bp) + (FLD##_bw) + 7) / 8 - (FLD##_bp) / 8)
#define CSR_FLD_VAL(FLD, v)  (((uint32_t)(v) << (FLD##_bp)) & (FLD##_bm))

#define CSR_GET(member, FLD)     RDL_FIELD((uint32_t)CSR_REG32(member), FLD)
// A field that one aligned store cannot cover -- 3 bytes, or 2 bytes at an
// odd byte -- fails to compile: on rv32i it would be a misaligned or too wide
// store, which the co-simulation's byte enables would not show
#define CSR_FLD_OK(FLD)      ((void)sizeof(char[(CSR_FLD_N(FLD) == 1 ||                             \
                                               (CSR_FLD_N(FLD) == 2 && CSR_FLD_LO(FLD) % 2 == 0) || \
                                               (CSR_FLD_N(FLD) == 4 && CSR_FLD_LO(FLD) == 0)) ? 1 : -1]))

#define CSR_SET(member, FLD, v)  (CSR_FLD_OK(FLD), csr_wr_lanes(CSR_ADDR(member), CSR_FLD_LO(FLD), CSR_FLD_N(FLD), \
                                              CSR_FLD_VAL(FLD, v)))
#define CSR_RMW(member, FLD, v)  (CSR_FLD_OK(FLD), csr_wr_lanes(CSR_ADDR(member), CSR_FLD_LO(FLD), CSR_FLD_N(FLD), \
                                              ((uint32_t)CSR_REG32(member) & ~(uint32_t)(FLD##_bm)) | \
                                              CSR_FLD_VAL(FLD, v)))

// Extract a field out of a register value that has already been read, using
// the bit mask and bit position "peakrdl c-header" emits for that field:
//
//    uint32_t hdr = CSR_REG32(rx.header_info);       // one bus read
//    uint8_t  tag = RDL_FIELD(hdr, CSR__RX__HEADER_INFO__TAG);
//
// Reading a register once and picking the fields out of the copy matters when
// the hardware can change it between two reads.
#define RDL_FIELD(val, FLD)  (((val) & FLD##_bm) >> FLD##_bp)

#ifndef VPROC
// RISC-V: plain loads and stores
# define CSR_REG32(member)  (*(volatile uint32_t *)(uintptr_t)CSR_ADDR(member))

// Write n bytes (1, 2 or 4) of a register, from byte lo up. data holds the
// register value with the field in place; only bytes lo..lo+n-1 are stored.
static inline void csr_wr_lanes(uint32_t addr, uint32_t lo, uint32_t n, uint32_t data)
{
    uintptr_t a = addr + lo;
    uint32_t  d = data >> (8 * lo);

    if (n == 1)       *(volatile uint8_t  *)a = (uint8_t)d;
    else if (n == 2)  *(volatile uint16_t *)a = (uint16_t)d;
    else              *(volatile uint32_t *)a = d;
}
#endif

// Co-simulation: the firmware is compiled for the host as C++ with VPROC
// defined, and every access becomes one VProc bus cycle at the same address
// and with the same byte enables as on the RISC-V core: VRead where a value
// is used, VWrite / VWriteBE where one is stored. Each access is followed by
// CSR_VP_GAP idle cycles, about what a core spends on the instructions
// between two accesses; without them a polling loop costs one VProc round
// trip per cycle.
#ifdef VPROC
# ifndef __cplusplus
#  error "the co-simulation compiles the firmware as C++"
# endif

extern "C" {
# include "VUser.h"
}

# define NO_DELTA_UPDATE  0
# ifndef SOC_CPU_VPNODE
#  define SOC_CPU_VPNODE  0   // the VProc node of the SOC CPU
# endif
# ifndef CSR_VP_GAP
#  define CSR_VP_GAP  8       // SOC clock cycles after each register access
# endif

class csr_vp_reg32 {
public:
    explicit csr_vp_reg32(uint32_t addr) : addr(addr) {}

    operator uint32_t() const {
        uint32_t data;
        VRead(addr, &data, NO_DELTA_UPDATE, SOC_CPU_VPNODE);
        VTick(CSR_VP_GAP, SOC_CPU_VPNODE);
        return data;
    }
    csr_vp_reg32& operator=(uint32_t data) {
        VWrite(addr, data, NO_DELTA_UPDATE, SOC_CPU_VPNODE);
        VTick(CSR_VP_GAP, SOC_CPU_VPNODE);
        return *this;
    }
private:
    uint32_t addr;
};

# define CSR_REG32(member)  csr_vp_reg32(CSR_ADDR(member))

static inline void csr_wr_lanes(uint32_t addr, uint32_t lo, uint32_t n, uint32_t data)
{
    VWriteBE(addr, data, ((1u << n) - 1) << lo, NO_DELTA_UPDATE, SOC_CPU_VPNODE);
    VTick(CSR_VP_GAP, SOC_CPU_VPNODE);
}
#endif

#endif
