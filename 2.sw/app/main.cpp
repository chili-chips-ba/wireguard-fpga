// SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
//
// SPDX-License-Identifier: BSD-3-Clause

//========================================================================== 
// Wireguard-1GE FPGA * NLnet-sponsored open-source implementation   
//--------------------------------------------------------------------------
//                   Copyright (C) 2026 Chili.CHIPS*ba
// 
// Redistribution and use in source and binary forms, with or without 
// modification, are permitted provided that the following conditions 
// are met:
//
// 1. Redistributions of source code must retain the above copyright 
// notice, this list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright 
// notice, this list of conditions and the following disclaimer in the 
// documentation and/or other materials provided with the distribution.
//
// 3. Neither the name of the copyright holder nor the names of its 
// contributors may be used to endorse or promote products derived
// from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS 
// IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED 
// TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A 
// PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
// HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//              https://opensource.org/license/bsd-3-clause
//--------------------------------------------------------------------------
// Description:
//   Main program for WireGuard FPGA
//==========================================================================

#include <stdint.h>
#include "wireguard_libs.h"
#include "wireguard_regs.h"
#include "string_bare.h"
#include "uart.h"
#include "ethernet.h"
#include "network.h"
#include "chacha20poly1305.h"
#include "blake2s.h"
#include "curve25519.h"
#include "hkdf.h"
#include "random.h"
#include "timer.h"

// TEST CODE

static int test_chacha20poly1305(volatile csr_vp_t* csr) {
   // Test vectors
   uint8_t key[32] = {
      0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
      0x88, 0x89, 0x8a, 0x8b, 0x8c, 0x8d, 0x8e, 0x8f,
      0x90, 0x91, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97,
      0x98, 0x99, 0x9a, 0x9b, 0x9c, 0x9d, 0x9e, 0x9f};

   uint8_t nonce[12] = {
      0x07, 0x00, 0x00, 0x00, 0x40, 0x41, 0x42, 0x43,
      0x44, 0x45, 0x46, 0x47};

   const char *aad_str = "Additional authenticated data";
   uint8_t *aad = (uint8_t *)aad_str;
   size_t aad_len = strlen(aad_str);

   const char *plaintext_str = "Hello CHILIChips - Wireguard team, let's test this aead!";
   uint8_t *plaintext = (uint8_t *)plaintext_str;
   size_t plaintext_len = strlen(plaintext_str);

   // Use stack allocation instead of malloc
   uint8_t ciphertext[256]; // Buffer large enough for the plaintext
   uint8_t decrypted[256];  // Buffer large enough for the plaintext
   uint8_t auth_tag[16];
   // Encrypt
   int ret = chacha20poly1305_encrypt(
      ciphertext, auth_tag, key, nonce,
      plaintext, plaintext_len, aad, aad_len);

   if (ret != 0)
   {
      return -1;
   }
   // Decrypt
   ret = chacha20poly1305_decrypt(
      decrypted, key, nonce, ciphertext, plaintext_len,
      auth_tag, aad, aad_len);

   if (ret == 0)
   {
      uart_send(csr, "ChaCha20-Poly1305 test passed!\r\n");
   }
   else
   {
      uart_send(csr, "ChaCha20-Poly1305 test failed!\r\n");
      return -1;
   }

   return 0;
}

static int test_blake2s(volatile csr_vp_t* csr) {
   uint8_t out[32];
   int pass = 1;

   struct {
      const char *input;
      const uint8_t expected[32];
   } tests[] = {
      // RFC 7693 official test vectors (BLAKE2s-256)
      {
         "", // empty string
         {0x69, 0x21, 0x7a, 0x30, 0x79, 0x90, 0x80, 0x94,
         0xe1, 0x11, 0x21, 0xd0, 0x42, 0x35, 0x4a, 0x7c,
         0x1f, 0x55, 0xb6, 0x48, 0x2c, 0xa1, 0xa5, 0x1e,
         0x1b, 0x25, 0x0d, 0xfd, 0x1e, 0xd0, 0xee, 0xf9}
      },
      {
         "abc",
         {0x50, 0x8c, 0x5e, 0x8c, 0x32, 0x7c, 0x14, 0xe2,
         0xe1, 0xa7, 0x2b, 0xa3, 0x4e, 0xeb, 0x45, 0x2f,
         0x37, 0x45, 0x8b, 0x20, 0x9e, 0xd6, 0x3a, 0x29,
         0x4d, 0x99, 0x9b, 0x4c, 0x86, 0x67, 0x59, 0x82}
      }
   };

   size_t num_tests = sizeof(tests) / sizeof(tests[0]);

   for (size_t i = 0; i < num_tests; i++) {
      const char *msg = tests[i].input;
      const uint8_t *expected = tests[i].expected;

      // Compute hash
      hash(out, 32, NULL, 0, msg, strlen(msg));

      // Compare
      int ok = 1;
      for (int j = 0; j < 32; j++) {
         if (out[j] != expected[j]) {
               ok = 0;
               break;
         }
      }

      if (!ok) pass = 0;
   }

   if (pass) {
      uart_send(csr, "BLAKE2s test passed!\r\n");
   } else {
      uart_send(csr, "BLAKE2s test failed!\r\n");
      return -1;
   }

   return 0;
}

static void test_curve25519(volatile csr_vp_t* csr) {
   /* Simulate Alice and Bob doing a complete key exchange */
   uint8_t alice_private[32], bob_private[32];
   uint8_t alice_public[32], bob_public[32];
   uint8_t alice_shared[32], bob_shared[32];

   // Generate private keys
   random_32bytes(alice_private);
   random_32bytes(bob_private);

   // Generate public keys
   int alice_keygen = curve25519_generate_public_key(alice_public, alice_private);
   int bob_keygen = curve25519_generate_public_key(bob_public, bob_private);

   // Exchange public keys and compute shared secrets
   int alice_shared_result = curve25519_compute_shared_secret(alice_shared, alice_private, bob_public);
   int bob_shared_result = curve25519_compute_shared_secret(bob_shared, bob_private, alice_public);

   // Verify shared secrets match
   int secrets_match = memcmp(alice_shared, bob_shared, 32) == 0;

   if (secrets_match) {
      uart_send(csr, "Key exchange successful! Alice and Bob have the same shared secret\r\n");
   } else {
      uart_send(csr, "Key exchange failed! Shared secrets don't match.\r\n");
   }
}

static int test_rng(volatile csr_vp_t* csr)
{
   uint8_t random_bytes[32];
   uint32_t rand_num;

   for (uint8_t i = 0; i < 10; i++) {
      uart_send(csr, "Generating random 32 bytes: ");
      random_32bytes(random_bytes);
      uart_send_hex_bytes(csr, random_bytes, 32);
      uart_send(csr, "\r\n");

      uart_send(csr, "Generating random number between 10 and 1000: ");
      rand_num = random_range(10, 1000);
      uart_send_dec(csr, rand_num);
      uart_send(csr, "\r\n");
   }

   return 0;
}

static int test_timer(volatile csr_vp_t* csr)
{
   for (uint8_t i = 0; i < 10; i++) {
      delay_ms(1000u); // 1 second pause
      uart_send(csr, ".");
   }
   uart_send(csr, "\r\nTest passed!\r\n");

   return 0;
}

// APP CODE

eth_raw_packet_t  eth_packet_rx;
eth_raw_packet_t  eth_packet_tx;
net_config_t      net_config;
net_arp_cache_t   net_arp_cache = {0};

void init_network(volatile csr_vp_t* csr, net_config_t* config) {
   if (config->ip[0] == 0 && config->ip[1] == 0 && config->ip[2] == 0 && config->ip[3] == 0) {
      config->ip[0] = 192;
      config->ip[1] = 168;
      config->ip[2] = 1;
      config->ip[3] = 98;

      config->sub_mask[0] = 255;
      config->sub_mask[1] = 255;
      config->sub_mask[2] = 255;
      config->sub_mask[3] = 0;

      config->mac[0] = 0xCC;
      config->mac[1] = 0xBA;
      config->mac[2] = 0xCA;
      config->mac[3] = 0xCA;
      config->mac[4] = 0x00;
      config->mac[5] = 0x01;

      config->def_gw[0] = 192;
      config->def_gw[1] = 168;
      config->def_gw[2] = 1;
      config->def_gw[3] = 254;

      config->def_if = 1;
   }
}

void show_network(volatile csr_vp_t* csr, net_config_t* config) {
   uart_send(csr, "Network configuration:\r\n");
   uart_send(csr, "  IP address:        ");
   uart_send_ip(csr, config->ip);
   uart_send(csr, "\r\n  Subnet mask:       ");
   uart_send_ip(csr, config->sub_mask);
   uart_send(csr, "\r\n  MAC address:       ");
   uart_send_mac(csr, config->mac);
   uart_send(csr, "\r\n  Default gateway:   ");
   uart_send_ip(csr, config->def_gw);
   uart_send(csr, "\r\n  Default interface: ");
   uart_send_dec(csr, config->def_if);
   switch (config->def_if) {
      case 0:
         uart_send(csr, " [0....]");
         break;
      case 1:
         uart_send(csr, " [.1...]");
         break;
      case 2:
         uart_send(csr, " [..2..]");
         break;
      case 3:
         uart_send(csr, " [...3.]");
         break;
      case 4:
         uart_send(csr, " [....4]");
         break;
      case 5:
         uart_send(csr, " [.1.3.]");
         break;
      case 6:
         uart_send(csr, " [..2.4]");
         break;
      case 7:
         uart_send(csr, " [.1234]");
         break;
   }
   uart_send(csr, "\r\n");
}

void config_network(volatile csr_vp_t* csr, net_config_t* config) {
   char uart_rx_data[UART_RXBUF_SIZE];

   uart_send(csr, "Enter new network configuration:\r\n");

   uart_send(csr, "  IP address [");
   uart_send_ip(csr, config->ip);
   uart_send(csr, "]: ");
   while (!uart_recv(csr, uart_rx_data));
   net_str_parse_ip(uart_rx_data, &config->ip);

   uart_send(csr, "  Subnet mask [");
   uart_send_ip(csr, config->sub_mask);
   uart_send(csr, "]: ");
   while (!uart_recv(csr, uart_rx_data));
   net_str_parse_ip(uart_rx_data, &config->sub_mask);

   uart_send(csr, "  Generate new MAC address? (y/n) [n]: ");
   while (!uart_recv(csr, uart_rx_data));
   if (uart_rx_data[0] == 'y' || uart_rx_data[0] == 'Y') {
      uint8_t random_bytes[2];
      random_32bytes(random_bytes);
      config->mac[4] = random_bytes[0]; // Use random byte for MAC suffix
      config->mac[5] = random_bytes[1]; // Use random byte for MAC suffix
   }

   uart_send(csr, "  Default gateway [");
   uart_send_ip(csr, config->def_gw);
   uart_send(csr, "]: ");
   while (!uart_recv(csr, uart_rx_data));
   net_str_parse_ip(uart_rx_data, &config->def_gw);

   uart_send(csr, "  Default interface (0-7) [");
   uart_send_dec(csr, config->def_if);
   uart_send(csr, "]: ");
   while (!uart_recv(csr, uart_rx_data));
   str_parse_uint8(uart_rx_data, &config->def_if, 0, 7);
   uart_send(csr, "Network configuration updated.\r\n");

   show_network(csr, config);
}

void show_routes_entry(volatile csr_vp_t* csr, int i) {
   uart_send(csr, "  (");
   uart_send_dec(csr, i);

   uint32_t uip = csr->routing_table->entry[i]->ip->ip();
   ip_t ip = {(uint8_t)((uip >> 24) & 0xFF), (uint8_t)((uip >> 16) & 0xFF), (uint8_t)((uip >> 8) & 0xFF), (uint8_t)(uip & 0xFF)};
   uart_send(csr, ") IP: ");
   uart_send_ip(csr, ip);

   uint32_t umask = csr->routing_table->entry[i]->mask->mask();
   ip_t mask = {(uint8_t)((umask >> 24) & 0xFF), (uint8_t)((umask >> 16) & 0xFF), (uint8_t)((umask >> 8) & 0xFF), (uint8_t)(umask & 0xFF)};
   uart_send(csr, ", Mask: ");
   uart_send_ip(csr, mask);

   uint32_t peer_idx = csr->routing_table->entry[i]->peer_idx->peer_idx();
   uart_send(csr, ", Peer index: ");
   uart_send_dec(csr, peer_idx);

   uint32_t dst = csr->routing_table->entry[i]->dst->dst();
   uart_send(csr, ", Destination interface: ");
   uart_send_dec(csr, dst);
   switch (dst) {
      case 0:
         uart_send(csr, " [0....]");
         break;
      case 1:
         uart_send(csr, " [.1...]");
         break;
      case 2:
         uart_send(csr, " [..2..]");
         break;
      case 3:
         uart_send(csr, " [...3.]");
         break;
      case 4:
         uart_send(csr, " [....4]");
         break;
      case 5:
         uart_send(csr, " [.1.3.]");
         break;
      case 6:
         uart_send(csr, " [..2.4]");
         break;
      case 7:
         uart_send(csr, " [.1234]");
         break;
   }

   uart_send(csr, "\r\n");
}

void show_routes(volatile csr_vp_t* csr) {
   csr->dpe->fcr->pause(1);
   while (!csr->dpe->fcr->idle());

   uart_send(csr, "Routing table:\r\n");
   for (int i = 0; i < 64; i++) {
      show_routes_entry(csr, i);
   }

   csr->dpe->fcr->pause(0);
}

void config_routes(volatile csr_vp_t* csr) {
   char uart_rx_data[UART_RXBUF_SIZE];

   csr->dpe->fcr->pause(1);
   while (!csr->dpe->fcr->idle());

   uart_send(csr, "Enter new routing table entry:\r\n");
   uart_send(csr, "  Entry index (0-63) [0]: ");
   while (!uart_recv(csr, uart_rx_data));
   uint32_t entry_idx = 0;
   str_parse_uint32(uart_rx_data, &entry_idx, 0, 63);

   uart_send(csr, "  Destination IP address [");
   uint32_t uip = csr->routing_table->entry[entry_idx]->ip->ip();
   ip_t ip = {(uint8_t)((uip >> 24) & 0xFF), (uint8_t)((uip >> 16) & 0xFF), (uint8_t)((uip >> 8) & 0xFF), (uint8_t)(uip & 0xFF)};
   uart_send_ip(csr, ip);
   uart_send(csr, "]: ");
   while (!uart_recv(csr, uart_rx_data));
   net_str_parse_ip(uart_rx_data, &ip);

   uart_send(csr, "  Subnet mask [");
   uint32_t umask = csr->routing_table->entry[entry_idx]->mask->mask();
   ip_t mask = {(uint8_t)((umask >> 24) & 0xFF), (uint8_t)((umask >> 16) & 0xFF), (uint8_t)((umask >> 8) & 0xFF), (uint8_t)(umask & 0xFF)};
   uart_send_ip(csr, mask);
   uart_send(csr, "]: ");
   while (!uart_recv(csr, uart_rx_data));
   net_str_parse_ip(uart_rx_data, &mask);

   uart_send(csr, "  Peer index (0-63) [");
   uint32_t peer_idx = csr->routing_table->entry[entry_idx]->peer_idx->peer_idx();
   uart_send_dec(csr, peer_idx);
   uart_send(csr, "]: ");
   while (!uart_recv(csr, uart_rx_data));
   str_parse_uint32(uart_rx_data, &peer_idx, 0, 63);

   uart_send(csr, "  Destination interface (0-7) [");
   uint32_t dst = csr->routing_table->entry[entry_idx]->dst->dst();
   uart_send_dec(csr, dst);
   uart_send(csr, "]: ");
   while (!uart_recv(csr, uart_rx_data));
   str_parse_uint32(uart_rx_data, &dst, 0, 7);

   // Update routing table entry
   uip = ((uint32_t)ip[0] << 24) | ((uint32_t)ip[1] << 16) | ((uint32_t)ip[2] << 8) | (uint32_t)ip[3];
   umask = ((uint32_t)mask[0] << 24) | ((uint32_t)mask[1] << 16) | ((uint32_t)mask[2] << 8) | (uint32_t)mask[3];
   csr->routing_table->entry[entry_idx]->ip->ip(uip);
   csr->routing_table->entry[entry_idx]->mask->mask(umask);
   csr->routing_table->entry[entry_idx]->peer_idx->peer_idx(peer_idx);
   csr->routing_table->entry[entry_idx]->dst->dst(dst);

   uart_send(csr, "Routing table entry updated.\r\n");

   show_routes_entry(csr, entry_idx);

   csr->dpe->fcr->pause(0);
}

void show_cryptokeys_entry(volatile csr_vp_t* csr, int i) {
   uart_send(csr, "  (");
   uart_send_dec(csr, i);

   uart_send(csr, ") Local MAC: ");
   uart_send_hex(csr, csr->cryptokey_table->entry[i]->local_mac_47_32->mac(), 4);
   uart_send_hex(csr, csr->cryptokey_table->entry[i]->local_mac_31_0->mac(), 8);

   uart_send(csr, ", Local IP: ");
   uint32_t ulocal_ip = csr->cryptokey_table->entry[i]->local_ip->ip();
   ip_t local_ip = {(uint8_t)((ulocal_ip >> 24) & 0xFF), (uint8_t)((ulocal_ip >> 16) & 0xFF), (uint8_t)((ulocal_ip >> 8) & 0xFF), (uint8_t)(ulocal_ip & 0xFF)};
   uart_send_ip(csr, local_ip);

   uart_send(csr, ", Local port: ");
   uart_send_dec(csr, csr->cryptokey_table->entry[i]->local_port->port());

   uart_send(csr, ", Local ID: 0x");
   uart_send_hex(csr, csr->cryptokey_table->entry[i]->local_id->id(), 8);

   uart_send(csr, "\r\n    Remote MAC: ");
   uart_send_hex(csr, csr->cryptokey_table->entry[i]->remote_mac_47_32->mac(), 4);
   uart_send_hex(csr, csr->cryptokey_table->entry[i]->remote_mac_31_0->mac(), 8);

   uart_send(csr, ", Remote IP: ");
   uint32_t uremote_ip = csr->cryptokey_table->entry[i]->remote_ip->ip();
   ip_t remote_ip = {(uint8_t)((uremote_ip >> 24) & 0xFF), (uint8_t)((uremote_ip >> 16) & 0xFF), (uint8_t)((uremote_ip >> 8) & 0xFF), (uint8_t)(uremote_ip & 0xFF)};
   uart_send_ip(csr, remote_ip);

   uart_send(csr, ", Remote port: ");
   uart_send_dec(csr, csr->cryptokey_table->entry[i]->remote_port->port());

   uart_send(csr, ", Remote ID: 0x");
   uart_send_hex(csr, csr->cryptokey_table->entry[i]->remote_id->id(), 8);

   uart_send(csr, "\r\n    Encryption key: 0x");
   uart_send_hex(csr, csr->cryptokey_table->entry[i]->encrypt_key_255_224->key(), 8);
   uart_send_hex(csr, csr->cryptokey_table->entry[i]->encrypt_key_223_192->key(), 8);
   uart_send_hex(csr, csr->cryptokey_table->entry[i]->encrypt_key_191_160->key(), 8);
   uart_send_hex(csr, csr->cryptokey_table->entry[i]->encrypt_key_159_128->key(), 8);
   uart_send_hex(csr, csr->cryptokey_table->entry[i]->encrypt_key_127_96->key(), 8);
   uart_send_hex(csr, csr->cryptokey_table->entry[i]->encrypt_key_95_64->key(), 8);
   uart_send_hex(csr, csr->cryptokey_table->entry[i]->encrypt_key_63_32->key(), 8);
   uart_send_hex(csr, csr->cryptokey_table->entry[i]->encrypt_key_31_0->key(), 8);

   uart_send(csr, "\r\n    Decryption key: 0x");
   uart_send_hex(csr, csr->cryptokey_table->entry[i]->decrypt_key_255_224->key(), 8);
   uart_send_hex(csr, csr->cryptokey_table->entry[i]->decrypt_key_223_192->key(), 8);
   uart_send_hex(csr, csr->cryptokey_table->entry[i]->decrypt_key_191_160->key(), 8);
   uart_send_hex(csr, csr->cryptokey_table->entry[i]->decrypt_key_159_128->key(), 8);
   uart_send_hex(csr, csr->cryptokey_table->entry[i]->decrypt_key_127_96->key(), 8);
   uart_send_hex(csr, csr->cryptokey_table->entry[i]->decrypt_key_95_64->key(), 8);
   uart_send_hex(csr, csr->cryptokey_table->entry[i]->decrypt_key_63_32->key(), 8);
   uart_send_hex(csr, csr->cryptokey_table->entry[i]->decrypt_key_31_0->key(), 8);

   uart_send(csr, "\r\n    Send counter: 0x");
   uart_send_hex(csr, csr->cryptokey_table->entry[i]->send_cnt_63_32->cnt(), 8);
   uart_send_hex(csr, csr->cryptokey_table->entry[i]->send_cnt_31_0->cnt(), 8);

   uart_send(csr, "\r\n    Recv counter: 0x");
   uart_send_hex(csr, csr->cryptokey_table->entry[i]->recv_cnt_63_32->cnt(), 8);
   uart_send_hex(csr, csr->cryptokey_table->entry[i]->recv_cnt_31_0->cnt(), 8);

   uart_send(csr, "\r\n");
}

void show_cryptokeys(volatile csr_vp_t* csr) {
   csr->dpe->fcr->pause(1);
   while (!csr->dpe->fcr->idle());

   uart_send(csr, "Cryptokey table:\r\n");
   for (int i = 1; i < 64; i++) {
      show_cryptokeys_entry(csr, i);
   }

   csr->dpe->fcr->pause(0);
}

void config_cryptokeys(volatile csr_vp_t* csr) {
   char uart_rx_data[UART_RXBUF_SIZE];

   csr->dpe->fcr->pause(1);
   while (!csr->dpe->fcr->idle());

   uart_send(csr, "Enter new cryptokey table entry:\r\n");
   uart_send(csr, "  Entry index (1-63) [1]: ");
   while (!uart_recv(csr, uart_rx_data));
   uint32_t entry_idx = 1;
   str_parse_uint32(uart_rx_data, &entry_idx, 1, 63);

   uart_send(csr, "  Local MAC address [");
   uint32_t local_mac_47_32 = csr->cryptokey_table->entry[entry_idx]->local_mac_47_32->mac();
   uart_send_hex(csr, local_mac_47_32, 4);
   uint32_t local_mac_31_0 = csr->cryptokey_table->entry[entry_idx]->local_mac_31_0->mac();
   uart_send_hex(csr, local_mac_31_0, 8);
   uart_send(csr, "]: ");
   while (!uart_recv(csr, uart_rx_data));
   if (strlen(uart_rx_data) == 13) {
      str_parse_hex(uart_rx_data + 4, &local_mac_31_0, 0, 0xFFFFFFFF);
      uart_rx_data[4] = '\n';
      str_parse_hex(uart_rx_data, &local_mac_47_32, 0, 0xFFFF);
   }

   uart_send(csr, "  Local IP address [");
   uint32_t ulocal_ip = csr->cryptokey_table->entry[entry_idx]->local_ip->ip();
   ip_t local_ip = {(uint8_t)((ulocal_ip >> 24) & 0xFF), (uint8_t)((ulocal_ip >> 16) & 0xFF), (uint8_t)((ulocal_ip >> 8) & 0xFF), (uint8_t)(ulocal_ip & 0xFF)};
   uart_send_ip(csr, local_ip);
   uart_send(csr, "]: ");
   while (!uart_recv(csr, uart_rx_data));
   net_str_parse_ip(uart_rx_data, &local_ip);
   ulocal_ip = ((uint32_t)local_ip[0] << 24) | ((uint32_t)local_ip[1] << 16) | ((uint32_t)local_ip[2] << 8) | (uint32_t)local_ip[3];

   uart_send(csr, "  Local port (0-65535) [");
   uint32_t local_port = csr->cryptokey_table->entry[entry_idx]->local_port->port();
   uart_send_dec(csr, local_port);
   uart_send(csr, "]: ");
   while (!uart_recv(csr, uart_rx_data));
   str_parse_uint32(uart_rx_data, &local_port, 0, 65535);

   uart_send(csr, "  Local ID (8 hex digits) [");
   uint32_t local_id = csr->cryptokey_table->entry[entry_idx]->local_id->id();
   uart_send_hex(csr, local_id, 8);
   uart_send(csr, "]: ");
   while (!uart_recv(csr, uart_rx_data));
   str_parse_hex(uart_rx_data, &local_id, 0, 0xFFFFFFFF);

   uart_send(csr, "  Remote MAC address [");
   uint32_t remote_mac_47_32 = csr->cryptokey_table->entry[entry_idx]->remote_mac_47_32->mac();
   uart_send_hex(csr, remote_mac_47_32, 4);
   uint32_t remote_mac_31_0 = csr->cryptokey_table->entry[entry_idx]->remote_mac_31_0->mac();
   uart_send_hex(csr, remote_mac_31_0, 8);
   uart_send(csr, "]: ");
   while (!uart_recv(csr, uart_rx_data));
   if (strlen(uart_rx_data) == 13) {
      str_parse_hex(uart_rx_data + 4, &remote_mac_31_0, 0, 0xFFFFFFFF);
      uart_rx_data[4] = '\n';
      str_parse_hex(uart_rx_data, &remote_mac_47_32, 0, 0xFFFF);
   }

   uart_send(csr, "  Remote IP address [");
   uint32_t uremote_ip = csr->cryptokey_table->entry[entry_idx]->remote_ip->ip();
   ip_t remote_ip = {(uint8_t)((uremote_ip >> 24) & 0xFF), (uint8_t)((uremote_ip >> 16) & 0xFF), (uint8_t)((uremote_ip >> 8) & 0xFF), (uint8_t)(uremote_ip & 0xFF)};
   uart_send_ip(csr, remote_ip);
   uart_send(csr, "]: ");
   while (!uart_recv(csr, uart_rx_data));
   net_str_parse_ip(uart_rx_data, &remote_ip);
   uremote_ip = ((uint32_t)remote_ip[0] << 24) | ((uint32_t)remote_ip[1] << 16) | ((uint32_t)remote_ip[2] << 8) | (uint32_t)remote_ip[3];

   uart_send(csr, "  Remote port (0-65535) [");
   uint32_t remote_port = csr->cryptokey_table->entry[entry_idx]->remote_port->port();
   uart_send_dec(csr, remote_port);
   uart_send(csr, "]: ");
   while (!uart_recv(csr, uart_rx_data));
   str_parse_uint32(uart_rx_data, &remote_port, 0, 65535);

   uart_send(csr, "  Remote ID (8 hex digits) [");
   uint32_t remote_id = csr->cryptokey_table->entry[entry_idx]->remote_id->id();
   uart_send_hex(csr, remote_id, 8);
   uart_send(csr, "]: ");
   while (!uart_recv(csr, uart_rx_data));
   str_parse_hex(uart_rx_data, &remote_id, 0, 0xFFFFFFFF);

   uart_send(csr, "  Encryption key (1st 8 hex digits) [");
   uint32_t encrypt_key_255_224 = csr->cryptokey_table->entry[entry_idx]->encrypt_key_255_224->key();
   uart_send_hex(csr, encrypt_key_255_224, 8);
   uart_send(csr, "]: ");
   while (!uart_recv(csr, uart_rx_data));
   str_parse_hex(uart_rx_data, &encrypt_key_255_224, 0, 0xFFFFFFFF);

   uart_send(csr, "  Encryption key (2nd 8 hex digits) [");
   uint32_t encrypt_key_223_192 = csr->cryptokey_table->entry[entry_idx]->encrypt_key_223_192->key();
   uart_send_hex(csr, encrypt_key_223_192, 8);
   uart_send(csr, "]: ");
   while (!uart_recv(csr, uart_rx_data));
   str_parse_hex(uart_rx_data, &encrypt_key_223_192, 0, 0xFFFFFFFF);

   uart_send(csr, "  Encryption key (3rd 8 hex digits) [");
   uint32_t encrypt_key_191_160 = csr->cryptokey_table->entry[entry_idx]->encrypt_key_191_160->key();
   uart_send_hex(csr, encrypt_key_191_160, 8);
   uart_send(csr, "]: ");
   while (!uart_recv(csr, uart_rx_data));
   str_parse_hex(uart_rx_data, &encrypt_key_191_160, 0, 0xFFFFFFFF);

   uart_send(csr, "  Encryption key (4th 8 hex digits) [");
   uint32_t encrypt_key_159_128 = csr->cryptokey_table->entry[entry_idx]->encrypt_key_159_128->key();
   uart_send_hex(csr, encrypt_key_159_128, 8);
   uart_send(csr, "]: ");
   while (!uart_recv(csr, uart_rx_data));
   str_parse_hex(uart_rx_data, &encrypt_key_159_128, 0, 0xFFFFFFFF);

   uart_send(csr, "  Encryption key (5th 8 hex digits) [");
   uint32_t encrypt_key_127_96 = csr->cryptokey_table->entry[entry_idx]->encrypt_key_127_96->key();
   uart_send_hex(csr, encrypt_key_127_96, 8);
   uart_send(csr, "]: ");
   while (!uart_recv(csr, uart_rx_data));
   str_parse_hex(uart_rx_data, &encrypt_key_127_96, 0, 0xFFFFFFFF);

   uart_send(csr, "  Encryption key (6th 8 hex digits) [");
   uint32_t encrypt_key_95_64 = csr->cryptokey_table->entry[entry_idx]->encrypt_key_95_64->key();
   uart_send_hex(csr, encrypt_key_95_64, 8);
   uart_send(csr, "]: ");
   while (!uart_recv(csr, uart_rx_data));
   str_parse_hex(uart_rx_data, &encrypt_key_95_64, 0, 0xFFFFFFFF);

   uart_send(csr, "  Encryption key (7th 8 hex digits) [");
   uint32_t encrypt_key_63_32 = csr->cryptokey_table->entry[entry_idx]->encrypt_key_63_32->key();
   uart_send_hex(csr, encrypt_key_63_32, 8);
   uart_send(csr, "]: ");
   while (!uart_recv(csr, uart_rx_data));
   str_parse_hex(uart_rx_data, &encrypt_key_63_32, 0, 0xFFFFFFFF);

   uart_send(csr, "  Encryption key (8th 8 hex digits) [");
   uint32_t encrypt_key_31_0 = csr->cryptokey_table->entry[entry_idx]->encrypt_key_31_0->key();
   uart_send_hex(csr, encrypt_key_31_0, 8);
   uart_send(csr, "]: ");
   while (!uart_recv(csr, uart_rx_data));
   str_parse_hex(uart_rx_data, &encrypt_key_31_0, 0, 0xFFFFFFFF);

   uart_send(csr, "  Decryption key (1st 8 hex digits) [");
   uint32_t decrypt_key_255_224 = csr->cryptokey_table->entry[entry_idx]->decrypt_key_255_224->key();
   uart_send_hex(csr, decrypt_key_255_224, 8);
   uart_send(csr, "]: ");
   while (!uart_recv(csr, uart_rx_data));
   str_parse_hex(uart_rx_data, &decrypt_key_255_224, 0, 0xFFFFFFFF);

   uart_send(csr, "  Decryption key (2nd 8 hex digits) [");
   uint32_t decrypt_key_223_192 = csr->cryptokey_table->entry[entry_idx]->decrypt_key_223_192->key();
   uart_send_hex(csr, decrypt_key_223_192, 8);
   uart_send(csr, "]: ");
   while (!uart_recv(csr, uart_rx_data));
   str_parse_hex(uart_rx_data, &decrypt_key_223_192, 0, 0xFFFFFFFF);

   uart_send(csr, "  Decryption key (3rd 8 hex digits) [");
   uint32_t decrypt_key_191_160 = csr->cryptokey_table->entry[entry_idx]->decrypt_key_191_160->key();
   uart_send_hex(csr, decrypt_key_191_160, 8);
   uart_send(csr, "]: ");
   while (!uart_recv(csr, uart_rx_data));
   str_parse_hex(uart_rx_data, &decrypt_key_191_160, 0, 0xFFFFFFFF);

   uart_send(csr, "  Decryption key (4th 8 hex digits) [");
   uint32_t decrypt_key_159_128 = csr->cryptokey_table->entry[entry_idx]->decrypt_key_159_128->key();
   uart_send_hex(csr, decrypt_key_159_128, 8);
   uart_send(csr, "]: ");
   while (!uart_recv(csr, uart_rx_data));
   str_parse_hex(uart_rx_data, &decrypt_key_159_128, 0, 0xFFFFFFFF);

   uart_send(csr, "  Decryption key (5th 8 hex digits) [");
   uint32_t decrypt_key_127_96 = csr->cryptokey_table->entry[entry_idx]->decrypt_key_127_96->key();
   uart_send_hex(csr, decrypt_key_127_96, 8);
   uart_send(csr, "]: ");
   while (!uart_recv(csr, uart_rx_data));
   str_parse_hex(uart_rx_data, &decrypt_key_127_96, 0, 0xFFFFFFFF);

   uart_send(csr, "  Decryption key (6th 8 hex digits) [");
   uint32_t decrypt_key_95_64 = csr->cryptokey_table->entry[entry_idx]->decrypt_key_95_64->key();
   uart_send_hex(csr, decrypt_key_95_64, 8);
   uart_send(csr, "]: ");
   while (!uart_recv(csr, uart_rx_data));
   str_parse_hex(uart_rx_data, &decrypt_key_95_64, 0, 0xFFFFFFFF);

   uart_send(csr, "  Decryption key (7th 8 hex digits) [");
   uint32_t decrypt_key_63_32 = csr->cryptokey_table->entry[entry_idx]->decrypt_key_63_32->key();
   uart_send_hex(csr, decrypt_key_63_32, 8);
   uart_send(csr, "]: ");
   while (!uart_recv(csr, uart_rx_data));
   str_parse_hex(uart_rx_data, &decrypt_key_63_32, 0, 0xFFFFFFFF);

   uart_send(csr, "  Decryption key (8th 8 hex digits) [");
   uint32_t decrypt_key_31_0 = csr->cryptokey_table->entry[entry_idx]->decrypt_key_31_0->key();
   uart_send_hex(csr, decrypt_key_31_0, 8);
   uart_send(csr, "]: ");
   while (!uart_recv(csr, uart_rx_data));
   str_parse_hex(uart_rx_data, &decrypt_key_31_0, 0, 0xFFFFFFFF);

   // Update cryptokeys table entry
   csr->cryptokey_table->entry[entry_idx]->local_mac_47_32->mac(local_mac_47_32);
   csr->cryptokey_table->entry[entry_idx]->local_mac_31_0->mac(local_mac_31_0);
   csr->cryptokey_table->entry[entry_idx]->local_ip->ip(ulocal_ip);
   csr->cryptokey_table->entry[entry_idx]->local_port->port(local_port);
   csr->cryptokey_table->entry[entry_idx]->local_id->id(local_id);
   csr->cryptokey_table->entry[entry_idx]->remote_mac_47_32->mac(remote_mac_47_32);
   csr->cryptokey_table->entry[entry_idx]->remote_mac_31_0->mac(remote_mac_31_0);
   csr->cryptokey_table->entry[entry_idx]->remote_ip->ip(uremote_ip);
   csr->cryptokey_table->entry[entry_idx]->remote_port->port(remote_port);
   csr->cryptokey_table->entry[entry_idx]->remote_id->id(remote_id);
   csr->cryptokey_table->entry[entry_idx]->encrypt_key_255_224->key(encrypt_key_255_224);
   csr->cryptokey_table->entry[entry_idx]->encrypt_key_223_192->key(encrypt_key_223_192);
   csr->cryptokey_table->entry[entry_idx]->encrypt_key_191_160->key(encrypt_key_191_160);
   csr->cryptokey_table->entry[entry_idx]->encrypt_key_159_128->key(encrypt_key_159_128);
   csr->cryptokey_table->entry[entry_idx]->encrypt_key_127_96->key(encrypt_key_127_96);
   csr->cryptokey_table->entry[entry_idx]->encrypt_key_95_64->key(encrypt_key_95_64);
   csr->cryptokey_table->entry[entry_idx]->encrypt_key_63_32->key(encrypt_key_63_32);
   csr->cryptokey_table->entry[entry_idx]->encrypt_key_31_0->key(encrypt_key_31_0);
   csr->cryptokey_table->entry[entry_idx]->decrypt_key_255_224->key(decrypt_key_255_224);
   csr->cryptokey_table->entry[entry_idx]->decrypt_key_223_192->key(decrypt_key_223_192);
   csr->cryptokey_table->entry[entry_idx]->decrypt_key_191_160->key(decrypt_key_191_160);
   csr->cryptokey_table->entry[entry_idx]->decrypt_key_159_128->key(decrypt_key_159_128);
   csr->cryptokey_table->entry[entry_idx]->decrypt_key_127_96->key(decrypt_key_127_96);
   csr->cryptokey_table->entry[entry_idx]->decrypt_key_95_64->key(decrypt_key_95_64);
   csr->cryptokey_table->entry[entry_idx]->decrypt_key_63_32->key(decrypt_key_63_32);
   csr->cryptokey_table->entry[entry_idx]->decrypt_key_31_0->key(decrypt_key_31_0);

   uart_send(csr, "  Reset send/recv counters? (y/n) [n]: ");
   while (!uart_recv(csr, uart_rx_data));
   if (uart_rx_data[0] == 'y' || uart_rx_data[0] == 'Y') {
      csr->cryptokey_table->entry[entry_idx]->send_cnt_63_32->cnt(0);
      csr->cryptokey_table->entry[entry_idx]->send_cnt_31_0->cnt(0);
      csr->cryptokey_table->entry[entry_idx]->recv_cnt_63_32->cnt(0);
      csr->cryptokey_table->entry[entry_idx]->recv_cnt_31_0->cnt(0);
   }

   uart_send(csr, "Cryptokey table entry updated.\r\n");

   show_cryptokeys_entry(csr, entry_idx);

   csr->dpe->fcr->pause(0);
}

void reboot() {
   asm volatile ("jr zero" ::: "memory");
}

int main(void) {
   volatile csr_vp_t* csr = new csr_vp_t();
   char uart_rx_data[UART_RXBUF_SIZE];
   uint8_t uart_rx_len;
   uint8_t debug_enabled = 0;

   // Check hardware ID
   if (csr->hw_id->VENDOR() != 0xCCBA ||
       csr->hw_id->PRODUCT() != 0xCACA) {
      uart_send(csr, "\r\nHardware ID mismatch! Halting...\r\n");
      asm volatile ("ebreak");
   }

   // Display banner
   uart_send(csr, "\r\n==========================================\r\n");
   uart_send(csr, "          WireGuard FPGA v");
   uart_send_dec(csr, csr->hw_version->MAJOR());
   uart_send_char(csr, '.');
   uart_send_dec(csr, csr->hw_version->MINOR());
   uart_send_char(csr, '.');
   uart_send_dec(csr, csr->hw_version->PATCH());
   uart_send(csr, "\r\n   Copyright \u00A9 2024-2026 Chili.CHIPS*ba\r\n");
   uart_send(csr, "==========================================\r\n");

   // Boot sequence
   uart_send(csr, "Booting up...\r\n");
   init_network(csr, &net_config);
   show_network(csr, &net_config);

   // CLI prompt
   uart_send(csr, "\r\nType 'help' to display commands.\r\n");
   uart_send(csr, "(wireguard-fpga)# ");

   while (1) {
      // Receive Ethernet packet for CPU FIFO
      if (eth_receive_packet(csr, &eth_packet_rx)) {
         csr->gpio->led2(1);
         // Parse packet header
         net_protocol_t protocol = net_parse_packet_header(&eth_packet_rx);
         switch (protocol) {
            case NET_PROTO_UNKNOWN:
               if (debug_enabled) {
                  uart_send(csr, "<< NET_PROTO_UNKNOWN: ");
                  uart_send_dec(csr, eth_packet_rx.len);
                  uart_send(csr, "\r\n");
               }
               break;
            case NET_PROTO_ARP:
               if (debug_enabled) {
                  uart_send(csr, "<< NET_PROTO_ARP: ");
                  uart_send_dec(csr, eth_packet_rx.len);
                  uart_send(csr, "\r\n");
               }
               if (net_process_arp(&net_config, &net_arp_cache, &eth_packet_rx, &eth_packet_tx)) {
                  eth_send_packet(csr, &eth_packet_tx);
                  if (debug_enabled) {
                     uart_send(csr, ">> NET_PROTO_ARP: ");
                     uart_send_dec(csr, eth_packet_tx.len);
                     uart_send(csr, "\r\n");
                  }
               }
               break;
            case NET_PROTO_ICMP:
               if (debug_enabled) {
                  uart_send(csr, "<< NET_PROTO_ICMP: ");
                  uart_send_dec(csr, eth_packet_rx.len);
                  uart_send(csr, "\r\n");
               }
               if (net_process_icmp(&net_config, &eth_packet_rx, &eth_packet_tx)) {
                  eth_send_packet(csr, &eth_packet_tx);
                  if (debug_enabled) {
                     uart_send(csr, ">> NET_PROTO_ICMP: ");
                     uart_send_dec(csr, eth_packet_tx.len);
                     uart_send(csr, "\r\n");
                  }
               }
               break;
            case NET_PROTO_UDP:
               if (debug_enabled) {
                  uart_send(csr, "<< NET_PROTO_UDP: ");
                  uart_send_dec(csr, eth_packet_rx.len);
                  uart_send(csr, "\r\n");
               }
               break;
         }

         if (eth_packet_rx.src == DPE_ADDR_ETH_1) {
            eth_packet_rx.dst = DPE_ADDR_ETH_2;
            eth_packet_rx.bypass_all = 1;
            eth_send_packet(csr, &eth_packet_rx);
         } else if (eth_packet_rx.src == DPE_ADDR_ETH_2) {
            eth_packet_rx.dst = DPE_ADDR_ETH_1;
            eth_packet_rx.bypass_all = 1;
            eth_send_packet(csr, &eth_packet_rx);
         }
      } else {
         csr->gpio->led2(0);
      }

      // Receive and process CLI command
      uart_rx_len = uart_recv(csr, uart_rx_data);
      if (uart_rx_len) {
         if (strcmp(uart_rx_data, "test chacha20poly1305\n") == 0) {
            test_chacha20poly1305(csr);
         } else if (strcmp(uart_rx_data, "test blake2s\n") == 0) {
            test_blake2s(csr);
         } else if (strcmp(uart_rx_data, "test curve25519\n") == 0) {
            test_curve25519(csr);
         } else if (strcmp(uart_rx_data, "test rng\n") == 0) {
            test_rng(csr);
         } else if (strcmp(uart_rx_data, "test timer\n") == 0) {
            test_timer(csr);
         } else if (strcmp(uart_rx_data, "show network\n") == 0) {
            show_network(csr, &net_config);
         } else if (strcmp(uart_rx_data, "config network\n") == 0) {
            config_network(csr, &net_config);
         } else if (strcmp(uart_rx_data, "show routes\n") == 0) {
            show_routes(csr);
         } else if (strcmp(uart_rx_data, "config routes\n") == 0) {
            config_routes(csr);
         } else if (strcmp(uart_rx_data, "show cryptokeys\n") == 0) {
            show_cryptokeys(csr);
         } else if (strcmp(uart_rx_data, "config cryptokeys\n") == 0) {
            config_cryptokeys(csr);
         } else if (strcmp(uart_rx_data, "debug\n") == 0) {
            debug_enabled = !debug_enabled;
            uart_send(csr, "Debug mode ");;
            if (debug_enabled) {
               uart_send(csr, "enabled.\r\n");
            } else {
               uart_send(csr, "disabled.\r\n");
            }
         } else if (strcmp(uart_rx_data, "reboot\n") == 0) {
            reboot();
         } else if (strcmp(uart_rx_data, "help\n") == 0) {
            uart_send(csr, "Available commands:\r\n");
            uart_send(csr, "  test chacha20poly1305  - Test ChaCha20-Poly1305 AEAD\r\n");
            uart_send(csr, "  test blake2s           - Test BLAKE2s hash function\r\n");
            uart_send(csr, "  test curve25519        - Test Curve25519 key exchange\r\n");
            uart_send(csr, "  test rng               - Test random number generator\r\n");
            uart_send(csr, "  test timer             - Test timer functionality\r\n");
            uart_send(csr, "  show network           - Show network configuration\r\n");
            uart_send(csr, "  config network         - Configure network settings\r\n");
            uart_send(csr, "  show routes            - Show routing table\r\n");
            uart_send(csr, "  config routes          - Configure routing table entry\r\n");
            uart_send(csr, "  show cryptokeys        - Show cryptokey table\r\n");
            uart_send(csr, "  config cryptokeys      - Configure cryptokey table entry\r\n");
            uart_send(csr, "  debug                  - Toggle debug mode\r\n");
            uart_send(csr, "  reboot                 - Reboot the system\r\n");
            uart_send(csr, "  help                   - Show this help message\r\n");
         } else if (uart_rx_len > 1) {
            uart_send(csr, "Unknown command\r\n");
         }
         uart_send(csr, "(wireguard-fpga)# ");
      }
   }

   return 0;
}
