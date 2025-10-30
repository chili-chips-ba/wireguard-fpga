#include "random.h"

int main(void)
{
    // Example usage of random functions
    uint8_t random_bytes[32];
    random_32bytes(random_bytes);

    uint32_t rand_num = random_range(10, 100);

    return 0;
}