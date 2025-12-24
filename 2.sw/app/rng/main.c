#include "random.h"
#include "uart.h"

int main(void)
{
    reg_uart_clkdiv = 694; // 80 MHz / 115200 baud

    uint8_t random_bytes[32];
    uint32_t rand_num;
    while(1)
    {
        print("\nGenerating random 32 bytes: ");
        random_32bytes(random_bytes);
        print_hex_bytes(random_bytes, 32);


        print("\nGenerating random number between 10 and 1000: ");
        rand_num = random_range(10, 1000);
        print_uint32(rand_num);
    }

    return 0;
}