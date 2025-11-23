
#include "uintN_t.h"
#include "intN_t.h"
uint1_t BIN_OP_GT_int17_t_int32_t(int17_t left, int32_t right)
{
    // Sign extend as needed
    uint1_t lsign = left(16,16);
    uint1_t rsign = right(31,31);
    int32_t lsigned = left;
    int32_t rsigned = right;

    uint16_t extra_sign_bits = rsigned >> 16;
    uint16_t sign_ext_like_zero = lsigned >> 16; // uint1_16(lsign);

    // unsigned at minimum width
    uint16_t lunsigned = left;
    uint16_t runsigned = right;
    
    uint1_t rv;
    if(extra_sign_bits==sign_ext_like_zero){
        // Do unsigned compare
        rv = lunsigned > runsigned;
    }else{
        
        // and or same sign right magnitude larger
        // -left > -RIGHT true (lsign, rsign)
        // left > RIGHT false (lsign, rsign)
        rv = rsign;
    }
    return rv;  
}