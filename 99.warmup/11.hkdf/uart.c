#include "uart.h"

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

void print_hex_bytes(const uint8_t *data, int len)
{
    const char hex[] = "0123456789ABCDEF";
    for (int i = 0; i < len; i++)
    {
        uint8_t b = data[i];
        reg_uart_data = hex[b >> 4];    // high nibble
        reg_uart_data = hex[b & 0xF];   // low nibble
    }
    reg_uart_data = '\r';
    reg_uart_data = '\n';
}

void print_uint32(uint32_t val)
{
    char buf[11]; // max 10 digits + null
    int i = 10;
    buf[i] = '\0';
    if (val == 0) {
        buf[--i] = '0';
    } else {
        while (val > 0) {
            buf[--i] = '0' + (val % 10);
            val /= 10;
        }
    }
    print(&buf[i]);
}