#include "uart.h"

#define reg_uart_data (*(volatile uint32_t*)0x02000008)

void putchar(char c)
{
	if (c == '\n')
		putchar('\r');
	reg_uart_data = c;
}

void print(const char *p)
{
	while (*p)
		putchar(*(p++));
}


void print_hex(unsigned int val, int digits)
{
	for (int i = (4*digits)-4; i >= 0; i -= 4)
		reg_uart_data = "0123456789ABCDEF"[(val >> i) % 16];
}
