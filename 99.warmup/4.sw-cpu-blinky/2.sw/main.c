#include <stdint.h>

#define reg_gpio (*(volatile uint32_t*)0x03000000)
#define LED0 (1 << 0)

void delay(uint32_t count) {
    volatile uint32_t i;
    for (i = 0; i < count; i++);
}

int main(void) {
    while (1) {
        reg_gpio |= LED0;
        delay(1000000);
        reg_gpio &= ~LED0;
        delay(1000000);
    }
    return 0;
}