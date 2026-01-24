// SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
// SPDX-FileCopyrightText: 2026 Julian Kammerer
//
// SPDX-License-Identifier: GPL-3.0-or-later

// Both encrypt and decrypt side testbenches running at the same time
#define SIMULATION
#include "chacha20poly1305_encrypt_decrypt_shared.c"
#include "chacha20poly1305/encrypt_tb.c"
#include "chacha20poly1305/decrypt_tb.c"
