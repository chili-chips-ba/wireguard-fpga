#include <stdint.h>


#ifndef __UART_H__
#define __UART_H__

void putchar(char c);
void print(const char *p);
void print_hex(unsigned int val, int digits);

#endif

