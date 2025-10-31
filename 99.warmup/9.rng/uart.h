#include <stdint.h>

#ifndef __UART_H__
#define __UART_H__

#define reg_uart_clkdiv (*(volatile uint32_t*)0x02000004)
#define reg_uart_data   (*(volatile uint32_t*)0x02000008)

void putchar(char c);
void print(const char *p);
void print_hex(unsigned int val, int digits);
void print_hex_bytes(const uint8_t *data, int len);
void print_uint32(uint32_t val);

#endif