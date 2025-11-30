
#include "uintN_t.h"
#include "intN_t.h"
uint1_t BIN_OP_GT_int33_t_int32_t(int33_t left, int32_t right)
{
    // Sign extend as needed
    uint1_t lsign = left(32,32);
    uint1_t rsign = right(31,31);
    int33_t lsigned = left;
    int33_t rsigned = right;

    uint2_t extra_sign_bits = lsigned >> 31;
    uint2_t sign_ext_like_zero = rsigned >> 31; // uint1_2(rsign);

    // unsigned at minimum width
    uint31_t lunsigned = left;
    uint31_t runsigned = right;
    
    uint1_t rv;
    if(extra_sign_bits==sign_ext_like_zero){
        // Do unsigned compare
        rv = lunsigned > runsigned;
    }else{
        
        // and or same sign left magnitude larger
        // -LEFT > -right false  (!lsign,!rsign)
        // LEFT > right true  (!lsign,!rsign)
        rv = ~lsign;
    }
    return rv;  
}