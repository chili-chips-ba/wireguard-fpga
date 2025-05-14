#ifndef UART_H
#define UART_H

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>
#include "wireguard_regs.h"
#include "string_bare.h"

#define UART_RXBUF_SIZE 32
#define UART_RX_VALID  0x80000000
#define UART_RX_OFLOW  0x40000000
#define UART_RX_DATA   0x000000FF

void uart_send_char  (volatile csr_vp_t* csr, char c);
void uart_send_hex   (volatile csr_vp_t* csr, unsigned int val, int digits);
void uart_send       (volatile csr_vp_t* csr, const char *s);
void uart_recv       (volatile csr_vp_t* csr, char *s);

#ifdef UART_TEST
void uart_test       (volatile csr_vp_t* csr);
#endif

#ifdef RISCV_TEST
void uart_tests_info (volatile csr_vp_t* csr, int cmd);
#endif

#ifdef __cplusplus
}
#endif

#endif // UART_H
