// SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
//
// SPDX-License-Identifier: BSD-3-Clause

#ifndef RANDOM_H
#define RANDOM_H

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>
#include "blake2s.h"
#include "string_bare.h"

// Fills 'out' with 32 random bytes
void random_32bytes(uint8_t *out);

// Returns a random integer in the range [min, max]
uint32_t random_range(uint32_t min, uint32_t max);

#ifdef __cplusplus
}
#endif

#endif // RANDOM_H
