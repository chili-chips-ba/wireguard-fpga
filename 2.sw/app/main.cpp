/**
 * @file main.cpp
 * @brief Main program for WireGuard FPGA
 */

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

static int test_chacha20poly1305(volatile csr_vp_t* csr)
{
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

static int test_blake2s(volatile csr_vp_t* csr)
{
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

   for (size_t i = 0; i < num_tests; i++) 
   {
      const char *msg = tests[i].input;
      const uint8_t *expected = tests[i].expected;

      // Compute hash
      hash(out, 32, NULL, 0, msg, strlen(msg)); 

      // Compare
      int ok = 1;
      for (int j = 0; j < 32; j++) 
      {
         if (out[j] != expected[j]) 
         {
               ok = 0;
               break;
         }
      }

      if (!ok) pass = 0;
   }

   if (pass)
   {
      uart_send(csr, "BLAKE2s test passed!\r\n");
   }
   else
   {
      uart_send(csr, "BLAKE2s test failed!\r\n");
      return -1;
   }
   
   return 0;
}

static void test_curve25519(volatile csr_vp_t* csr)
{
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

   if (secrets_match)
   {
      uart_send(csr, "Key exchange successful! Alice and Bob have the same shared secret\r\n");
   }
   else
   {
      uart_send(csr, "Key exchange failed! Shared secrets don't match.\r\n");
   }
}

static int test_rng(volatile csr_vp_t* csr)
{
   uint8_t random_bytes[32];
   uint32_t rand_num;
   
   for (uint8_t i = 0; i < 20; i++)
   {
      uart_send(csr, "\nGenerating random 32 bytes: ");
      random_32bytes(random_bytes);
      uart_send_hex_bytes(csr, random_bytes, 32);

      uart_send(csr, "\nGenerating random number between 10 and 1000: ");
      rand_num = random_range(10, 1000);
      uart_send_dec(csr, rand_num);
   }

   return 0;
}

static int test_timer(volatile csr_vp_t* csr)
{
   for (uint8_t i = 0; i < 20; i++)
   {
      delay_ms(1000u); // 1 second pause
      uart_send(csr, "1s passed.\r\n");
   }

   return 0;
}

// APP CODE

eth_raw_packet_t  eth_packet_rx;
eth_raw_packet_t  eth_packet_tx;
net_config_t      net_config = { 
                     .ip = {192, 168, 1, 99},
                     .sub_mask = {255, 255, 255, 0},
                     .mac = {0xCA, 0xCA, 0xCC, 0xAE, 0x00, 0x01},
                     .def_gw = {192, 168, 1, 254},
                     .def_if = 1
                  };
net_arp_cache_t   net_arp_cache = {0};

int main(void)
{
   volatile csr_vp_t* csr = new csr_vp_t();
   char uart_rx_data[UART_RXBUF_SIZE];
   uint8_t uart_rx_len;

   // Show default network configuration
   uart_send(csr, "==========================================\r\n");
   uart_send(csr, "       WireGuard FPGA by ChiliChips       \r\n");
   uart_send(csr, "==========================================\r\n");
   uart_send(csr, "Network configuration\r\n");
   uart_send(csr, "-- IP address:        ");
   uart_send_ip(csr, net_config.ip);
   uart_send(csr, "\r\n-- Subnet mask:       ");
   uart_send_ip(csr, net_config.sub_mask);
   uart_send(csr, "\r\n-- MAC address:       ");
   uart_send_mac(csr, net_config.mac);
   uart_send(csr, "\r\n-- Default gateway:   ");
   uart_send_ip(csr, net_config.def_gw);
   uart_send(csr, "\r\n-- Default interface: ");
   uart_send_dec(csr, net_config.def_if);
   uart_send(csr, "\r\n");
   uart_send(csr, "------------------------------------------\r\n");

   while (1) {
      // Receive Ethernet packet for CPU FIFO
      if (eth_receive_packet(csr, &eth_packet_rx)) {
         csr->gpio->led2(1);
         // Parse packet header
         net_protocol_t protocol = net_parse_packet_header(&eth_packet_rx);
         switch (protocol) {
            case NET_PROTO_UNKNOWN:
               /*uart_send(csr, "NET_PROTO_UNKNOWN: ");
               uart_send_hex(csr, eth_packet_rx.len, 4);
               uart_send(csr, "\r\n");*/
               break;
            case NET_PROTO_ARP:
               uart_send(csr, "<< NET_PROTO_ARP: ");
               uart_send_dec(csr, eth_packet_rx.len);
               uart_send(csr, "\r\n");
               if (net_process_arp(&net_config, &net_arp_cache, &eth_packet_rx, &eth_packet_tx)) {
                  eth_send_packet(csr, &eth_packet_tx);
                  uart_send(csr, ">> NET_PROTO_ARP: ");
                  uart_send_dec(csr, eth_packet_tx.len);
                  uart_send(csr, "\r\n");
               }
               break;
            case NET_PROTO_ICMP:
               uart_send(csr, "<< NET_PROTO_ICMP: ");
               uart_send_dec(csr, eth_packet_rx.len);
               uart_send(csr, "\r\n");
               if (net_process_icmp(&net_config, &eth_packet_rx, &eth_packet_tx)) {
                  eth_send_packet(csr, &eth_packet_tx);
                  uart_send(csr, ">> NET_PROTO_ICMP: ");
                  uart_send_dec(csr, eth_packet_rx.len);
                  uart_send(csr, "\r\n");
               }
               break;
            case NET_PROTO_UDP:
               /*uart_send(csr, "NET_PROTO_UDP: ");
               uart_send_hex(csr, eth_packet_rx.len, 4);
               uart_send(csr, "\r\n");*/
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
         uart_send(csr, "Received: ");
         uart_send(csr, uart_rx_data);
         uart_send(csr, "\r\n");
         uart_send(csr, "Received length: ");
         uart_send_dec(csr, uart_rx_len);
         uart_send(csr, "\r\n");
         uart_send_hex(csr, uart_rx_data[0], 2);
         uart_send(csr, "\r\n");
      }
   }

   return 0;
}
