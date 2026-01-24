// SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
// SPDX-FileCopyrightText: 2026 Julian Kammerer
//
// SPDX-License-Identifier: GPL-3.0-or-later

#pragma once
// Annoying fixed array sized single string printf funcs
// trying to match software print_hex
#define PRINT_32_BYTES(label, array) \
uint256_t PRINT_32_BYTES_uint = uint8_array32_be(array); \
printf(label \
    "%08X%08X%08X%08X%08X%08X%08X%08X\n", \
    PRINT_32_BYTES_uint >> (8*28), \
    PRINT_32_BYTES_uint >> (8*24), \
    PRINT_32_BYTES_uint >> (8*20), \
    PRINT_32_BYTES_uint >> (8*16), \
    PRINT_32_BYTES_uint >> (8*12), \
    PRINT_32_BYTES_uint >> (8*8), \
    PRINT_32_BYTES_uint >> (8*4), \
    PRINT_32_BYTES_uint >> (8*0) \
);

#define PRINT_16_BYTES(label, array) \
uint128_t PRINT_16_BYTES_uint = uint8_array16_be(array); \
printf(label \
    "%08X%08X%08X%08X\n", \
    PRINT_16_BYTES_uint >> (8*12), \
    PRINT_16_BYTES_uint >> (8*8), \
    PRINT_16_BYTES_uint >> (8*4), \
    PRINT_16_BYTES_uint >> (8*0) \
);

#define PRINT_12_BYTES(label, array) \
uint96_t PRINT_12_BYTES_uint = uint8_array12_be(array); \
printf(label \
    "%08X%08X%08X\n", \
    PRINT_12_BYTES_uint >> (8*8), \
    PRINT_12_BYTES_uint >> (8*4), \
    PRINT_12_BYTES_uint >> (8*0) \
);

void print_aad(uint8_t aad[AAD_MAX_LEN], uint32_t aad_len)
{
    // 32 chars
    printf("AAD (%u bytes): "
        "%c%c%c%c"
        "%c%c%c%c"
        "%c%c%c%c"
        "%c%c%c%c"
        "%c%c%c%c"
        "%c%c%c%c"
        "%c%c%c%c"
        "%c%c%c%c"
        "\n",
        aad_len,
        aad[0], aad[1], aad[2], aad[3],
        aad[4], aad[5], aad[6], aad[7],
        aad[8], aad[9], aad[10], aad[11],
        aad[12], aad[13], aad[14], aad[15],
        aad[16], aad[17], aad[18], aad[19],
        aad[20], aad[21], aad[22], aad[23],
        aad[24], aad[25], aad[26], aad[27],
        aad[28], aad[29], aad[30], aad[31]
    );
}
