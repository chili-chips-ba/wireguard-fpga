#ifndef UART_H
#define UART_H

#include <stdint.h>

#define UART_RXBUF_SIZE 32

void uart_send_char  (char c);
void uart_send_hex   (unsigned int val, int digits);
void uart_send       (const char *s);
void uart_recv       (char *s);

#ifdef UART_TEST
void uart_test       (void);
#endif

#ifdef RISCV_TEST
void uart_tests_info (int cmd);
#endif

#endif // UART_H

