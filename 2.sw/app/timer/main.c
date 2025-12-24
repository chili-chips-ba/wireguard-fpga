#include "timer.h"
#include "uart.h"

int main(void)
{
    reg_uart_clkdiv = 694; // 80 MHz / 115200 baud
    
    while (1)
    {
        print("1s passed.\n");
        delay_ms(1000u); // 1 second pause
    }
}