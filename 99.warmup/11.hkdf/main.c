#include "hkdf.h"
#include "uart.h"

int main(void)
{
    reg_uart_clkdiv = 694; // 80 MHz / 115200 baud

    // todo: add hkdf tests
    
    return 0;
}