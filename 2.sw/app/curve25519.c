//==========================================================================
// Copyright (C) 2024-2026 Chili.CHIPS*ba
//--------------------------------------------------------------------------
//                      PROPRIETARY INFORMATION
//
// The information contained in this file is the property of CHILI CHIPS LLC.
// Except as specifically authorized in writing by CHILI CHIPS LLC, the holder
// of this file: (1) shall keep all information contained herein confidential;
// and (2) shall protect the same in whole or in part from disclosure and
// dissemination to all third parties; and (3) shall use the same for operation
// and maintenance purposes only.
//--------------------------------------------------------------------------
// Description:
//   Curve25519 library (uses TweetNaCl X25519 implementation)
//==========================================================================

#include "curve25519.h"
#include "tweetnacl_x25519.h"

int curve25519_generate_public_key(uint8_t public_key[32], const uint8_t private_key[32])
{
    if (!public_key || !private_key)
    {
        return -1;
    }

    /* Generate public key using scalar multiplication with base point */
    return x25519_scalarmult_base(public_key, private_key);
}

int curve25519_compute_shared_secret(uint8_t shared_secret[32], const uint8_t private_key[32], const uint8_t public_key[32])
{
    if (!shared_secret || !private_key || !public_key)
    {
        return -1; /* Invalid parameters */
    }

    /* Compute shared secret using scalar multiplication */
    return x25519_scalarmult(shared_secret, private_key, public_key);
}