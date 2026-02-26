// SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
// SPDX-FileCopyrightText: 2026 Julian Kammerer
//
// SPDX-License-Identifier: GPL-3.0-or-later

// Top level of encrypt and decrypt design that shares components
#pragma PART "xc7a200tffg1156-2" // Artix 7 200T

// The shared parts between encrypt and decrypt
// the two big compute pipelines
#include "chacha20/chacha20_pipeline_shared.c"
// Actually Poly1305 isnt that big, better to not-share pipeline resources
// and get throughput improvement from MCP instead
//#include "poly1305/poly1305_pipeline_shared.c"

// The encrypt and decrypt specifics part of the shared design
#include "chacha20poly1305/encrypt_shared.c"
#include "chacha20poly1305/decrypt_shared.c"
