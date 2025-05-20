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
