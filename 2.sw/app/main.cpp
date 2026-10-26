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
#include "csr_regs.h"
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

static int test_chacha20poly1305(void) {
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
      uart_send("ChaCha20-Poly1305 test passed!\r\n");
   }
   else
   {
      uart_send("ChaCha20-Poly1305 test failed!\r\n");
      return -1;
   }

   return 0;
}

static int test_blake2s(void) {
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
      uart_send("BLAKE2s test passed!\r\n");
   } else {
      uart_send("BLAKE2s test failed!\r\n");
      return -1;
   }

   return 0;
}

static void test_curve25519(void) {
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
      uart_send("Key exchange successful! Alice and Bob have the same shared secret\r\n");
   } else {
      uart_send("Key exchange failed! Shared secrets don't match.\r\n");
   }
}

static int test_rng(void)
{
   uint8_t random_bytes[32];
   uint32_t rand_num;

   for (uint8_t i = 0; i < 10; i++) {
      uart_send("Generating random 32 bytes: ");
      random_32bytes(random_bytes);
      uart_send_hex_bytes(random_bytes, 32);
      uart_send("\r\n");

      uart_send("Generating random number between 10 and 1000: ");
      rand_num = random_range(10, 1000);
      uart_send_dec(rand_num);
      uart_send("\r\n");
   }

   return 0;
}

static int test_timer(void)
{
   for (uint8_t i = 0; i < 10; i++) {
      delay_ms(1000u); // 1 second pause
      uart_send(".");
   }
   uart_send("\r\nTest passed!\r\n");

   return 0;
}

// APP CODE

eth_raw_packet_t  eth_packet_rx;
eth_raw_packet_t  eth_packet_tx;
net_config_t      net_config;
net_arp_cache_t   net_arp_cache = {0};

void init_network(net_config_t* config) {
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

void show_network(net_config_t* config) {
   uart_send("Network configuration:\r\n");
   uart_send("  IP address:        ");
   uart_send_ip(config->ip);
   uart_send("\r\n  Subnet mask:       ");
   uart_send_ip(config->sub_mask);
   uart_send("\r\n  MAC address:       ");
   uart_send_mac(config->mac);
   uart_send("\r\n  Default gateway:   ");
   uart_send_ip(config->def_gw);
   uart_send("\r\n  Default interface: ");
   uart_send_dec(config->def_if);
   switch (config->def_if) {
      case 0:
         uart_send(" [0....]");
         break;
      case 1:
         uart_send(" [.1...]");
         break;
      case 2:
         uart_send(" [..2..]");
         break;
      case 3:
         uart_send(" [...3.]");
         break;
      case 4:
         uart_send(" [....4]");
         break;
      case 5:
         uart_send(" [.1.3.]");
         break;
      case 6:
         uart_send(" [..2.4]");
         break;
      case 7:
         uart_send(" [.1234]");
         break;
   }
   uart_send("\r\n");
}

void config_network(net_config_t* config) {
   char uart_rx_data[UART_RXBUF_SIZE];

   uart_send("Enter new network configuration:\r\n");

   uart_send("  IP address [");
   uart_send_ip(config->ip);
   uart_send("]: ");
   while (!uart_recv(uart_rx_data));
   net_str_parse_ip(uart_rx_data, &config->ip);

   uart_send("  Subnet mask [");
   uart_send_ip(config->sub_mask);
   uart_send("]: ");
   while (!uart_recv(uart_rx_data));
   net_str_parse_ip(uart_rx_data, &config->sub_mask);

   uart_send("  Generate new MAC address? (y/n) [n]: ");
   while (!uart_recv(uart_rx_data));
   if (uart_rx_data[0] == 'y' || uart_rx_data[0] == 'Y') {
      uint8_t random_bytes[2];
      random_32bytes(random_bytes);
      config->mac[4] = random_bytes[0]; // Use random byte for MAC suffix
      config->mac[5] = random_bytes[1]; // Use random byte for MAC suffix
   }

   uart_send("  Default gateway [");
   uart_send_ip(config->def_gw);
   uart_send("]: ");
   while (!uart_recv(uart_rx_data));
   net_str_parse_ip(uart_rx_data, &config->def_gw);

   uart_send("  Default interface (0-7) [");
   uart_send_dec(config->def_if);
   uart_send("]: ");
   while (!uart_recv(uart_rx_data));
   str_parse_uint8(uart_rx_data, &config->def_if, 0, 7);
   uart_send("Network configuration updated.\r\n");

   show_network(config);
}

void show_routes_entry(int i) {
   uart_send("  (");
   uart_send_dec(i);

   uint32_t uip = CSR_REG32(routing_table.entry[i].ip);
   ip_t ip = {(uint8_t)((uip >> 24) & 0xFF), (uint8_t)((uip >> 16) & 0xFF), (uint8_t)((uip >> 8) & 0xFF), (uint8_t)(uip & 0xFF)};
   uart_send(") IP: ");
   uart_send_ip(ip);

   uint32_t umask = CSR_REG32(routing_table.entry[i].mask);
   ip_t mask = {(uint8_t)((umask >> 24) & 0xFF), (uint8_t)((umask >> 16) & 0xFF), (uint8_t)((umask >> 8) & 0xFF), (uint8_t)(umask & 0xFF)};
   uart_send(", Mask: ");
   uart_send_ip(mask);

   uint32_t peer_idx = CSR_GET(routing_table.entry[i].peer_idx, CSR__ROUTING_TABLE__ENTRY__PEER_IDX__PEER_IDX);
   uart_send(", Peer index: ");
   uart_send_dec(peer_idx);

   uint32_t dst = CSR_GET(routing_table.entry[i].dst, CSR__ROUTING_TABLE__ENTRY__DST__DST);
   uart_send(", Destination interface: ");
   uart_send_dec(dst);
   switch (dst) {
      case 0:
         uart_send(" [0....]");
         break;
      case 1:
         uart_send(" [.1...]");
         break;
      case 2:
         uart_send(" [..2..]");
         break;
      case 3:
         uart_send(" [...3.]");
         break;
      case 4:
         uart_send(" [....4]");
         break;
      case 5:
         uart_send(" [.1.3.]");
         break;
      case 6:
         uart_send(" [..2.4]");
         break;
      case 7:
         uart_send(" [.1234]");
         break;
   }

   uart_send("\r\n");
}

void show_routes(void) {
   CSR_RMW(dpe.fcr, CSR__DPE__FCR__PAUSE, 1);
   while (!CSR_GET(dpe.fcr, CSR__DPE__FCR__IDLE));

   uart_send("Routing table:\r\n");
   for (int i = 0; i < 64; i++) {
      show_routes_entry(i);
   }

   CSR_RMW(dpe.fcr, CSR__DPE__FCR__PAUSE, 0);
}

void config_routes(void) {
   char uart_rx_data[UART_RXBUF_SIZE];

   CSR_RMW(dpe.fcr, CSR__DPE__FCR__PAUSE, 1);
   while (!CSR_GET(dpe.fcr, CSR__DPE__FCR__IDLE));

   uart_send("Enter new routing table entry:\r\n");
   uart_send("  Entry index (0-63) [0]: ");
   while (!uart_recv(uart_rx_data));
   uint32_t entry_idx = 0;
   str_parse_uint32(uart_rx_data, &entry_idx, 0, 63);

   uart_send("  Destination IP address [");
   uint32_t uip = CSR_REG32(routing_table.entry[entry_idx].ip);
   ip_t ip = {(uint8_t)((uip >> 24) & 0xFF), (uint8_t)((uip >> 16) & 0xFF), (uint8_t)((uip >> 8) & 0xFF), (uint8_t)(uip & 0xFF)};
   uart_send_ip(ip);
   uart_send("]: ");
   while (!uart_recv(uart_rx_data));
   net_str_parse_ip(uart_rx_data, &ip);

   uart_send("  Subnet mask [");
   uint32_t umask = CSR_REG32(routing_table.entry[entry_idx].mask);
   ip_t mask = {(uint8_t)((umask >> 24) & 0xFF), (uint8_t)((umask >> 16) & 0xFF), (uint8_t)((umask >> 8) & 0xFF), (uint8_t)(umask & 0xFF)};
   uart_send_ip(mask);
   uart_send("]: ");
   while (!uart_recv(uart_rx_data));
   net_str_parse_ip(uart_rx_data, &mask);

   uart_send("  Peer index (0-63) [");
   uint32_t peer_idx = CSR_GET(routing_table.entry[entry_idx].peer_idx, CSR__ROUTING_TABLE__ENTRY__PEER_IDX__PEER_IDX);
   uart_send_dec(peer_idx);
   uart_send("]: ");
   while (!uart_recv(uart_rx_data));
   str_parse_uint32(uart_rx_data, &peer_idx, 0, 63);

   uart_send("  Destination interface (0-7) [");
   uint32_t dst = CSR_GET(routing_table.entry[entry_idx].dst, CSR__ROUTING_TABLE__ENTRY__DST__DST);
   uart_send_dec(dst);
   uart_send("]: ");
   while (!uart_recv(uart_rx_data));
   str_parse_uint32(uart_rx_data, &dst, 0, 7);

   // Update routing table entry
   uip = ((uint32_t)ip[0] << 24) | ((uint32_t)ip[1] << 16) | ((uint32_t)ip[2] << 8) | (uint32_t)ip[3];
   umask = ((uint32_t)mask[0] << 24) | ((uint32_t)mask[1] << 16) | ((uint32_t)mask[2] << 8) | (uint32_t)mask[3];
   CSR_REG32(routing_table.entry[entry_idx].ip) = uip;
   CSR_REG32(routing_table.entry[entry_idx].mask) = umask;
   CSR_SET(routing_table.entry[entry_idx].peer_idx, CSR__ROUTING_TABLE__ENTRY__PEER_IDX__PEER_IDX, peer_idx);
   CSR_SET(routing_table.entry[entry_idx].dst, CSR__ROUTING_TABLE__ENTRY__DST__DST, dst);

   uart_send("Routing table entry updated.\r\n");

   show_routes_entry(entry_idx);

   CSR_RMW(dpe.fcr, CSR__DPE__FCR__PAUSE, 0);
}

void show_cryptokeys_entry(int i) {
   uart_send("  (");
   uart_send_dec(i);

   uart_send(") Local MAC: ");
   uart_send_hex(CSR_GET(cryptokey_table.entry[i].local_mac_47_32, CSR__CRYPTOKEY_TABLE__ENTRY__LOCAL_MAC_47_32__MAC), 4);
   uart_send_hex(CSR_REG32(cryptokey_table.entry[i].local_mac_31_0), 8);

   uart_send(", Local IP: ");
   uint32_t ulocal_ip = CSR_REG32(cryptokey_table.entry[i].local_ip);
   ip_t local_ip = {(uint8_t)((ulocal_ip >> 24) & 0xFF), (uint8_t)((ulocal_ip >> 16) & 0xFF), (uint8_t)((ulocal_ip >> 8) & 0xFF), (uint8_t)(ulocal_ip & 0xFF)};
   uart_send_ip(local_ip);

   uart_send(", Local port: ");
   uart_send_dec(CSR_GET(cryptokey_table.entry[i].local_port, CSR__CRYPTOKEY_TABLE__ENTRY__LOCAL_PORT__PORT));

   uart_send(", Local ID: 0x");
   uart_send_hex(CSR_REG32(cryptokey_table.entry[i].local_id), 8);

   uart_send("\r\n    Remote MAC: ");
   uart_send_hex(CSR_GET(cryptokey_table.entry[i].remote_mac_47_32, CSR__CRYPTOKEY_TABLE__ENTRY__REMOTE_MAC_47_32__MAC), 4);
   uart_send_hex(CSR_REG32(cryptokey_table.entry[i].remote_mac_31_0), 8);

   uart_send(", Remote IP: ");
   uint32_t uremote_ip = CSR_REG32(cryptokey_table.entry[i].remote_ip);
   ip_t remote_ip = {(uint8_t)((uremote_ip >> 24) & 0xFF), (uint8_t)((uremote_ip >> 16) & 0xFF), (uint8_t)((uremote_ip >> 8) & 0xFF), (uint8_t)(uremote_ip & 0xFF)};
   uart_send_ip(remote_ip);

   uart_send(", Remote port: ");
   uart_send_dec(CSR_GET(cryptokey_table.entry[i].remote_port, CSR__CRYPTOKEY_TABLE__ENTRY__REMOTE_PORT__PORT));

   uart_send(", Remote ID: 0x");
   uart_send_hex(CSR_REG32(cryptokey_table.entry[i].remote_id), 8);

   uart_send("\r\n    Encryption key: 0x");
   uart_send_hex(CSR_REG32(cryptokey_table.entry[i].encrypt_key_255_224), 8);
   uart_send_hex(CSR_REG32(cryptokey_table.entry[i].encrypt_key_223_192), 8);
   uart_send_hex(CSR_REG32(cryptokey_table.entry[i].encrypt_key_191_160), 8);
   uart_send_hex(CSR_REG32(cryptokey_table.entry[i].encrypt_key_159_128), 8);
   uart_send_hex(CSR_REG32(cryptokey_table.entry[i].encrypt_key_127_96), 8);
   uart_send_hex(CSR_REG32(cryptokey_table.entry[i].encrypt_key_95_64), 8);
   uart_send_hex(CSR_REG32(cryptokey_table.entry[i].encrypt_key_63_32), 8);
   uart_send_hex(CSR_REG32(cryptokey_table.entry[i].encrypt_key_31_0), 8);

   uart_send("\r\n    Decryption key: 0x");
   uart_send_hex(CSR_REG32(cryptokey_table.entry[i].decrypt_key_255_224), 8);
   uart_send_hex(CSR_REG32(cryptokey_table.entry[i].decrypt_key_223_192), 8);
   uart_send_hex(CSR_REG32(cryptokey_table.entry[i].decrypt_key_191_160), 8);
   uart_send_hex(CSR_REG32(cryptokey_table.entry[i].decrypt_key_159_128), 8);
   uart_send_hex(CSR_REG32(cryptokey_table.entry[i].decrypt_key_127_96), 8);
   uart_send_hex(CSR_REG32(cryptokey_table.entry[i].decrypt_key_95_64), 8);
   uart_send_hex(CSR_REG32(cryptokey_table.entry[i].decrypt_key_63_32), 8);
   uart_send_hex(CSR_REG32(cryptokey_table.entry[i].decrypt_key_31_0), 8);

   uart_send("\r\n    Send counter: 0x");
   uart_send_hex(CSR_REG32(cryptokey_table.entry[i].send_cnt_63_32), 8);
   uart_send_hex(CSR_REG32(cryptokey_table.entry[i].send_cnt_31_0), 8);

   uart_send("\r\n    Recv counter: 0x");
   uart_send_hex(CSR_REG32(cryptokey_table.entry[i].recv_cnt_63_32), 8);
   uart_send_hex(CSR_REG32(cryptokey_table.entry[i].recv_cnt_31_0), 8);

   uart_send("\r\n");
}

void show_cryptokeys(void) {
   CSR_RMW(dpe.fcr, CSR__DPE__FCR__PAUSE, 1);
   while (!CSR_GET(dpe.fcr, CSR__DPE__FCR__IDLE));

   uart_send("Cryptokey table:\r\n");
   for (int i = 1; i < 64; i++) {
      show_cryptokeys_entry(i);
   }

   CSR_RMW(dpe.fcr, CSR__DPE__FCR__PAUSE, 0);
}

void config_cryptokeys(void) {
   char uart_rx_data[UART_RXBUF_SIZE];

   CSR_RMW(dpe.fcr, CSR__DPE__FCR__PAUSE, 1);
   while (!CSR_GET(dpe.fcr, CSR__DPE__FCR__IDLE));

   uart_send("Enter new cryptokey table entry:\r\n");
   uart_send("  Entry index (1-63) [1]: ");
   while (!uart_recv(uart_rx_data));
   uint32_t entry_idx = 1;
   str_parse_uint32(uart_rx_data, &entry_idx, 1, 63);

   uart_send("  Local MAC address [");
   uint32_t local_mac_47_32 = CSR_GET(cryptokey_table.entry[entry_idx].local_mac_47_32, CSR__CRYPTOKEY_TABLE__ENTRY__LOCAL_MAC_47_32__MAC);
   uart_send_hex(local_mac_47_32, 4);
   uint32_t local_mac_31_0 = CSR_REG32(cryptokey_table.entry[entry_idx].local_mac_31_0);
   uart_send_hex(local_mac_31_0, 8);
   uart_send("]: ");
   while (!uart_recv(uart_rx_data));
   if (strlen(uart_rx_data) == 13) {
      str_parse_hex(uart_rx_data + 4, &local_mac_31_0, 0, 0xFFFFFFFF);
      uart_rx_data[4] = '\n';
      str_parse_hex(uart_rx_data, &local_mac_47_32, 0, 0xFFFF);
   }

   uart_send("  Local IP address [");
   uint32_t ulocal_ip = CSR_REG32(cryptokey_table.entry[entry_idx].local_ip);
   ip_t local_ip = {(uint8_t)((ulocal_ip >> 24) & 0xFF), (uint8_t)((ulocal_ip >> 16) & 0xFF), (uint8_t)((ulocal_ip >> 8) & 0xFF), (uint8_t)(ulocal_ip & 0xFF)};
   uart_send_ip(local_ip);
   uart_send("]: ");
   while (!uart_recv(uart_rx_data));
   net_str_parse_ip(uart_rx_data, &local_ip);
   ulocal_ip = ((uint32_t)local_ip[0] << 24) | ((uint32_t)local_ip[1] << 16) | ((uint32_t)local_ip[2] << 8) | (uint32_t)local_ip[3];

   uart_send("  Local port (0-65535) [");
   uint32_t local_port = CSR_GET(cryptokey_table.entry[entry_idx].local_port, CSR__CRYPTOKEY_TABLE__ENTRY__LOCAL_PORT__PORT);
   uart_send_dec(local_port);
   uart_send("]: ");
   while (!uart_recv(uart_rx_data));
   str_parse_uint32(uart_rx_data, &local_port, 0, 65535);

   uart_send("  Local ID (8 hex digits) [");
   uint32_t local_id = CSR_REG32(cryptokey_table.entry[entry_idx].local_id);
   uart_send_hex(local_id, 8);
   uart_send("]: ");
   while (!uart_recv(uart_rx_data));
   str_parse_hex(uart_rx_data, &local_id, 0, 0xFFFFFFFF);

   uart_send("  Remote MAC address [");
   uint32_t remote_mac_47_32 = CSR_GET(cryptokey_table.entry[entry_idx].remote_mac_47_32, CSR__CRYPTOKEY_TABLE__ENTRY__REMOTE_MAC_47_32__MAC);
   uart_send_hex(remote_mac_47_32, 4);
   uint32_t remote_mac_31_0 = CSR_REG32(cryptokey_table.entry[entry_idx].remote_mac_31_0);
   uart_send_hex(remote_mac_31_0, 8);
   uart_send("]: ");
   while (!uart_recv(uart_rx_data));
   if (strlen(uart_rx_data) == 13) {
      str_parse_hex(uart_rx_data + 4, &remote_mac_31_0, 0, 0xFFFFFFFF);
      uart_rx_data[4] = '\n';
      str_parse_hex(uart_rx_data, &remote_mac_47_32, 0, 0xFFFF);
   }

   uart_send("  Remote IP address [");
   uint32_t uremote_ip = CSR_REG32(cryptokey_table.entry[entry_idx].remote_ip);
   ip_t remote_ip = {(uint8_t)((uremote_ip >> 24) & 0xFF), (uint8_t)((uremote_ip >> 16) & 0xFF), (uint8_t)((uremote_ip >> 8) & 0xFF), (uint8_t)(uremote_ip & 0xFF)};
   uart_send_ip(remote_ip);
   uart_send("]: ");
   while (!uart_recv(uart_rx_data));
   net_str_parse_ip(uart_rx_data, &remote_ip);
   uremote_ip = ((uint32_t)remote_ip[0] << 24) | ((uint32_t)remote_ip[1] << 16) | ((uint32_t)remote_ip[2] << 8) | (uint32_t)remote_ip[3];

   uart_send("  Remote port (0-65535) [");
   uint32_t remote_port = CSR_GET(cryptokey_table.entry[entry_idx].remote_port, CSR__CRYPTOKEY_TABLE__ENTRY__REMOTE_PORT__PORT);
   uart_send_dec(remote_port);
   uart_send("]: ");
   while (!uart_recv(uart_rx_data));
   str_parse_uint32(uart_rx_data, &remote_port, 0, 65535);

   uart_send("  Remote ID (8 hex digits) [");
   uint32_t remote_id = CSR_REG32(cryptokey_table.entry[entry_idx].remote_id);
   uart_send_hex(remote_id, 8);
   uart_send("]: ");
   while (!uart_recv(uart_rx_data));
   str_parse_hex(uart_rx_data, &remote_id, 0, 0xFFFFFFFF);

   uart_send("  Encryption key (1st 8 hex digits) [");
   uint32_t encrypt_key_255_224 = CSR_REG32(cryptokey_table.entry[entry_idx].encrypt_key_255_224);
   uart_send_hex(encrypt_key_255_224, 8);
   uart_send("]: ");
   while (!uart_recv(uart_rx_data));
   str_parse_hex(uart_rx_data, &encrypt_key_255_224, 0, 0xFFFFFFFF);

   uart_send("  Encryption key (2nd 8 hex digits) [");
   uint32_t encrypt_key_223_192 = CSR_REG32(cryptokey_table.entry[entry_idx].encrypt_key_223_192);
   uart_send_hex(encrypt_key_223_192, 8);
   uart_send("]: ");
   while (!uart_recv(uart_rx_data));
   str_parse_hex(uart_rx_data, &encrypt_key_223_192, 0, 0xFFFFFFFF);

   uart_send("  Encryption key (3rd 8 hex digits) [");
   uint32_t encrypt_key_191_160 = CSR_REG32(cryptokey_table.entry[entry_idx].encrypt_key_191_160);
   uart_send_hex(encrypt_key_191_160, 8);
   uart_send("]: ");
   while (!uart_recv(uart_rx_data));
   str_parse_hex(uart_rx_data, &encrypt_key_191_160, 0, 0xFFFFFFFF);

   uart_send("  Encryption key (4th 8 hex digits) [");
   uint32_t encrypt_key_159_128 = CSR_REG32(cryptokey_table.entry[entry_idx].encrypt_key_159_128);
   uart_send_hex(encrypt_key_159_128, 8);
   uart_send("]: ");
   while (!uart_recv(uart_rx_data));
   str_parse_hex(uart_rx_data, &encrypt_key_159_128, 0, 0xFFFFFFFF);

   uart_send("  Encryption key (5th 8 hex digits) [");
   uint32_t encrypt_key_127_96 = CSR_REG32(cryptokey_table.entry[entry_idx].encrypt_key_127_96);
   uart_send_hex(encrypt_key_127_96, 8);
   uart_send("]: ");
   while (!uart_recv(uart_rx_data));
   str_parse_hex(uart_rx_data, &encrypt_key_127_96, 0, 0xFFFFFFFF);

   uart_send("  Encryption key (6th 8 hex digits) [");
   uint32_t encrypt_key_95_64 = CSR_REG32(cryptokey_table.entry[entry_idx].encrypt_key_95_64);
   uart_send_hex(encrypt_key_95_64, 8);
   uart_send("]: ");
   while (!uart_recv(uart_rx_data));
   str_parse_hex(uart_rx_data, &encrypt_key_95_64, 0, 0xFFFFFFFF);

   uart_send("  Encryption key (7th 8 hex digits) [");
   uint32_t encrypt_key_63_32 = CSR_REG32(cryptokey_table.entry[entry_idx].encrypt_key_63_32);
   uart_send_hex(encrypt_key_63_32, 8);
   uart_send("]: ");
   while (!uart_recv(uart_rx_data));
   str_parse_hex(uart_rx_data, &encrypt_key_63_32, 0, 0xFFFFFFFF);

   uart_send("  Encryption key (8th 8 hex digits) [");
   uint32_t encrypt_key_31_0 = CSR_REG32(cryptokey_table.entry[entry_idx].encrypt_key_31_0);
   uart_send_hex(encrypt_key_31_0, 8);
   uart_send("]: ");
   while (!uart_recv(uart_rx_data));
   str_parse_hex(uart_rx_data, &encrypt_key_31_0, 0, 0xFFFFFFFF);

   uart_send("  Decryption key (1st 8 hex digits) [");
   uint32_t decrypt_key_255_224 = CSR_REG32(cryptokey_table.entry[entry_idx].decrypt_key_255_224);
   uart_send_hex(decrypt_key_255_224, 8);
   uart_send("]: ");
   while (!uart_recv(uart_rx_data));
   str_parse_hex(uart_rx_data, &decrypt_key_255_224, 0, 0xFFFFFFFF);

   uart_send("  Decryption key (2nd 8 hex digits) [");
   uint32_t decrypt_key_223_192 = CSR_REG32(cryptokey_table.entry[entry_idx].decrypt_key_223_192);
   uart_send_hex(decrypt_key_223_192, 8);
   uart_send("]: ");
   while (!uart_recv(uart_rx_data));
   str_parse_hex(uart_rx_data, &decrypt_key_223_192, 0, 0xFFFFFFFF);

   uart_send("  Decryption key (3rd 8 hex digits) [");
   uint32_t decrypt_key_191_160 = CSR_REG32(cryptokey_table.entry[entry_idx].decrypt_key_191_160);
   uart_send_hex(decrypt_key_191_160, 8);
   uart_send("]: ");
   while (!uart_recv(uart_rx_data));
   str_parse_hex(uart_rx_data, &decrypt_key_191_160, 0, 0xFFFFFFFF);

   uart_send("  Decryption key (4th 8 hex digits) [");
   uint32_t decrypt_key_159_128 = CSR_REG32(cryptokey_table.entry[entry_idx].decrypt_key_159_128);
   uart_send_hex(decrypt_key_159_128, 8);
   uart_send("]: ");
   while (!uart_recv(uart_rx_data));
   str_parse_hex(uart_rx_data, &decrypt_key_159_128, 0, 0xFFFFFFFF);

   uart_send("  Decryption key (5th 8 hex digits) [");
   uint32_t decrypt_key_127_96 = CSR_REG32(cryptokey_table.entry[entry_idx].decrypt_key_127_96);
   uart_send_hex(decrypt_key_127_96, 8);
   uart_send("]: ");
   while (!uart_recv(uart_rx_data));
   str_parse_hex(uart_rx_data, &decrypt_key_127_96, 0, 0xFFFFFFFF);

   uart_send("  Decryption key (6th 8 hex digits) [");
   uint32_t decrypt_key_95_64 = CSR_REG32(cryptokey_table.entry[entry_idx].decrypt_key_95_64);
   uart_send_hex(decrypt_key_95_64, 8);
   uart_send("]: ");
   while (!uart_recv(uart_rx_data));
   str_parse_hex(uart_rx_data, &decrypt_key_95_64, 0, 0xFFFFFFFF);

   uart_send("  Decryption key (7th 8 hex digits) [");
   uint32_t decrypt_key_63_32 = CSR_REG32(cryptokey_table.entry[entry_idx].decrypt_key_63_32);
   uart_send_hex(decrypt_key_63_32, 8);
   uart_send("]: ");
   while (!uart_recv(uart_rx_data));
   str_parse_hex(uart_rx_data, &decrypt_key_63_32, 0, 0xFFFFFFFF);

   uart_send("  Decryption key (8th 8 hex digits) [");
   uint32_t decrypt_key_31_0 = CSR_REG32(cryptokey_table.entry[entry_idx].decrypt_key_31_0);
   uart_send_hex(decrypt_key_31_0, 8);
   uart_send("]: ");
   while (!uart_recv(uart_rx_data));
   str_parse_hex(uart_rx_data, &decrypt_key_31_0, 0, 0xFFFFFFFF);

   // Update cryptokeys table entry
   CSR_SET(cryptokey_table.entry[entry_idx].local_mac_47_32, CSR__CRYPTOKEY_TABLE__ENTRY__LOCAL_MAC_47_32__MAC, local_mac_47_32);
   CSR_REG32(cryptokey_table.entry[entry_idx].local_mac_31_0) = local_mac_31_0;
   CSR_REG32(cryptokey_table.entry[entry_idx].local_ip) = ulocal_ip;
   CSR_SET(cryptokey_table.entry[entry_idx].local_port, CSR__CRYPTOKEY_TABLE__ENTRY__LOCAL_PORT__PORT, local_port);
   CSR_REG32(cryptokey_table.entry[entry_idx].local_id) = local_id;
   CSR_SET(cryptokey_table.entry[entry_idx].remote_mac_47_32, CSR__CRYPTOKEY_TABLE__ENTRY__REMOTE_MAC_47_32__MAC, remote_mac_47_32);
   CSR_REG32(cryptokey_table.entry[entry_idx].remote_mac_31_0) = remote_mac_31_0;
   CSR_REG32(cryptokey_table.entry[entry_idx].remote_ip) = uremote_ip;
   CSR_SET(cryptokey_table.entry[entry_idx].remote_port, CSR__CRYPTOKEY_TABLE__ENTRY__REMOTE_PORT__PORT, remote_port);
   CSR_REG32(cryptokey_table.entry[entry_idx].remote_id) = remote_id;
   CSR_REG32(cryptokey_table.entry[entry_idx].encrypt_key_255_224) = encrypt_key_255_224;
   CSR_REG32(cryptokey_table.entry[entry_idx].encrypt_key_223_192) = encrypt_key_223_192;
   CSR_REG32(cryptokey_table.entry[entry_idx].encrypt_key_191_160) = encrypt_key_191_160;
   CSR_REG32(cryptokey_table.entry[entry_idx].encrypt_key_159_128) = encrypt_key_159_128;
   CSR_REG32(cryptokey_table.entry[entry_idx].encrypt_key_127_96) = encrypt_key_127_96;
   CSR_REG32(cryptokey_table.entry[entry_idx].encrypt_key_95_64) = encrypt_key_95_64;
   CSR_REG32(cryptokey_table.entry[entry_idx].encrypt_key_63_32) = encrypt_key_63_32;
   CSR_REG32(cryptokey_table.entry[entry_idx].encrypt_key_31_0) = encrypt_key_31_0;
   CSR_REG32(cryptokey_table.entry[entry_idx].decrypt_key_255_224) = decrypt_key_255_224;
   CSR_REG32(cryptokey_table.entry[entry_idx].decrypt_key_223_192) = decrypt_key_223_192;
   CSR_REG32(cryptokey_table.entry[entry_idx].decrypt_key_191_160) = decrypt_key_191_160;
   CSR_REG32(cryptokey_table.entry[entry_idx].decrypt_key_159_128) = decrypt_key_159_128;
   CSR_REG32(cryptokey_table.entry[entry_idx].decrypt_key_127_96) = decrypt_key_127_96;
   CSR_REG32(cryptokey_table.entry[entry_idx].decrypt_key_95_64) = decrypt_key_95_64;
   CSR_REG32(cryptokey_table.entry[entry_idx].decrypt_key_63_32) = decrypt_key_63_32;
   CSR_REG32(cryptokey_table.entry[entry_idx].decrypt_key_31_0) = decrypt_key_31_0;

   uart_send("  Reset send/recv counters? (y/n) [n]: ");
   while (!uart_recv(uart_rx_data));
   if (uart_rx_data[0] == 'y' || uart_rx_data[0] == 'Y') {
      CSR_REG32(cryptokey_table.entry[entry_idx].send_cnt_63_32) = 0;
      CSR_REG32(cryptokey_table.entry[entry_idx].send_cnt_31_0) = 0;
      CSR_REG32(cryptokey_table.entry[entry_idx].recv_cnt_63_32) = 0;
      CSR_REG32(cryptokey_table.entry[entry_idx].recv_cnt_31_0) = 0;
   }

   uart_send("Cryptokey table entry updated.\r\n");

   show_cryptokeys_entry(entry_idx);

   CSR_RMW(dpe.fcr, CSR__DPE__FCR__PAUSE, 0);
}

void reboot() {
#ifdef VPROC
   // Co-simulation: no restart, park the VProc node
   while (1) VTick(10000, SOC_CPU_VPNODE);
#else
   asm volatile ("jr zero" ::: "memory");
#endif
}

int main(void) {
   char uart_rx_data[UART_RXBUF_SIZE];
   uint8_t uart_rx_len;
   uint8_t debug_enabled = 0;

   // Check hardware ID
   if (CSR_GET(hw_id, CSR__HW_ID__VENDOR) != 0xCCBA ||
       CSR_GET(hw_id, CSR__HW_ID__PRODUCT) != 0xCACA) {
      uart_send("\r\nHardware ID mismatch! Halting...\r\n");
#ifdef VPROC
      while (1) VTick(10000, SOC_CPU_VPNODE);
#else
      asm volatile ("ebreak");
#endif
   }

   // Display banner
   uart_send("\r\n==========================================\r\n");
   uart_send("          WireGuard FPGA v");
   uart_send_dec(CSR_GET(hw_version, CSR__HW_VERSION__MAJOR));
   uart_send_char('.');
   uart_send_dec(CSR_GET(hw_version, CSR__HW_VERSION__MINOR));
   uart_send_char('.');
   uart_send_dec(CSR_GET(hw_version, CSR__HW_VERSION__PATCH));
   uart_send("\r\n   Copyright \u00A9 2024-2026 Chili.CHIPS*ba\r\n");
   uart_send("==========================================\r\n");

   // Boot sequence
   uart_send("Booting up...\r\n");
   init_network(&net_config);
   show_network(&net_config);

   // CLI prompt
   uart_send("\r\nType 'help' to display commands.\r\n");
   uart_send("(wireguard-fpga)# ");

   while (1) {
      // Receive Ethernet packet for CPU FIFO
      if (eth_receive_packet(&eth_packet_rx)) {
         CSR_RMW(gpio, CSR__GPIO__LED2, 1);
         // Parse packet header
         net_protocol_t protocol = net_parse_packet_header(&eth_packet_rx);
         switch (protocol) {
            case NET_PROTO_UNKNOWN:
               if (debug_enabled) {
                  uart_send("<< NET_PROTO_UNKNOWN: ");
                  uart_send_dec(eth_packet_rx.len);
                  uart_send("\r\n");
               }
               break;
            case NET_PROTO_ARP:
               if (debug_enabled) {
                  uart_send("<< NET_PROTO_ARP: ");
                  uart_send_dec(eth_packet_rx.len);
                  uart_send("\r\n");
               }
               if (net_process_arp(&net_config, &net_arp_cache, &eth_packet_rx, &eth_packet_tx)) {
                  eth_send_packet(&eth_packet_tx);
                  if (debug_enabled) {
                     uart_send(">> NET_PROTO_ARP: ");
                     uart_send_dec(eth_packet_tx.len);
                     uart_send("\r\n");
                  }
               }
               break;
            case NET_PROTO_ICMP:
               if (debug_enabled) {
                  uart_send("<< NET_PROTO_ICMP: ");
                  uart_send_dec(eth_packet_rx.len);
                  uart_send("\r\n");
               }
               if (net_process_icmp(&net_config, &eth_packet_rx, &eth_packet_tx)) {
                  eth_send_packet(&eth_packet_tx);
                  if (debug_enabled) {
                     uart_send(">> NET_PROTO_ICMP: ");
                     uart_send_dec(eth_packet_tx.len);
                     uart_send("\r\n");
                  }
               }
               break;
            case NET_PROTO_UDP:
               if (debug_enabled) {
                  uart_send("<< NET_PROTO_UDP: ");
                  uart_send_dec(eth_packet_rx.len);
                  uart_send("\r\n");
               }
               break;
         }

         if (eth_packet_rx.src == DPE_ADDR_ETH_1) {
            eth_packet_rx.dst = DPE_ADDR_ETH_2;
            eth_packet_rx.bypass_all = 1;
            eth_send_packet(&eth_packet_rx);
         } else if (eth_packet_rx.src == DPE_ADDR_ETH_2) {
            eth_packet_rx.dst = DPE_ADDR_ETH_1;
            eth_packet_rx.bypass_all = 1;
            eth_send_packet(&eth_packet_rx);
         }
      } else {
         CSR_RMW(gpio, CSR__GPIO__LED2, 0);
      }

      // Receive and process CLI command
      uart_rx_len = uart_recv(uart_rx_data);
      if (uart_rx_len) {
         if (strcmp(uart_rx_data, "test chacha20poly1305\n") == 0) {
            test_chacha20poly1305();
         } else if (strcmp(uart_rx_data, "test blake2s\n") == 0) {
            test_blake2s();
         } else if (strcmp(uart_rx_data, "test curve25519\n") == 0) {
            test_curve25519();
         } else if (strcmp(uart_rx_data, "test rng\n") == 0) {
            test_rng();
         } else if (strcmp(uart_rx_data, "test timer\n") == 0) {
            test_timer();
         } else if (strcmp(uart_rx_data, "show network\n") == 0) {
            show_network(&net_config);
         } else if (strcmp(uart_rx_data, "config network\n") == 0) {
            config_network(&net_config);
         } else if (strcmp(uart_rx_data, "show routes\n") == 0) {
            show_routes();
         } else if (strcmp(uart_rx_data, "config routes\n") == 0) {
            config_routes();
         } else if (strcmp(uart_rx_data, "show cryptokeys\n") == 0) {
            show_cryptokeys();
         } else if (strcmp(uart_rx_data, "config cryptokeys\n") == 0) {
            config_cryptokeys();
         } else if (strcmp(uart_rx_data, "debug\n") == 0) {
            debug_enabled = !debug_enabled;
            uart_send("Debug mode ");;
            if (debug_enabled) {
               uart_send("enabled.\r\n");
            } else {
               uart_send("disabled.\r\n");
            }
         } else if (strcmp(uart_rx_data, "reboot\n") == 0) {
            reboot();
         } else if (strcmp(uart_rx_data, "help\n") == 0) {
            uart_send("Available commands:\r\n");
            uart_send("  test chacha20poly1305  - Test ChaCha20-Poly1305 AEAD\r\n");
            uart_send("  test blake2s           - Test BLAKE2s hash function\r\n");
            uart_send("  test curve25519        - Test Curve25519 key exchange\r\n");
            uart_send("  test rng               - Test random number generator\r\n");
            uart_send("  test timer             - Test timer functionality\r\n");
            uart_send("  show network           - Show network configuration\r\n");
            uart_send("  config network         - Configure network settings\r\n");
            uart_send("  show routes            - Show routing table\r\n");
            uart_send("  config routes          - Configure routing table entry\r\n");
            uart_send("  show cryptokeys        - Show cryptokey table\r\n");
            uart_send("  config cryptokeys      - Configure cryptokey table entry\r\n");
            uart_send("  debug                  - Toggle debug mode\r\n");
            uart_send("  reboot                 - Reboot the system\r\n");
            uart_send("  help                   - Show this help message\r\n");
         } else if (uart_rx_len > 1) {
            uart_send("Unknown command\r\n");
         }
         uart_send("(wireguard-fpga)# ");
      }
   }

   return 0;
}
