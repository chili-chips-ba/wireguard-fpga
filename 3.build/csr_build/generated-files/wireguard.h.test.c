#include <assert.h>
#include <stddef.h>
#include <stdio.h>

#include "wireguard.h"

static void test_offsets(void);
static void test_bitfields(void);

int main(void){
    test_offsets();
    test_bitfields();
    return 0;
}

static void test_offsets(void){
    assert(offsetof(csr_t, ip_lookup_engine.table[0].allowed_ip[0].w) == 0x0UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[0].allowed_ip[1].w) == 0x8UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[0].public_key.w) == 0x10UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[0].endpoint.w) == 0x18UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[1].allowed_ip[0].w) == 0x20UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[1].allowed_ip[1].w) == 0x28UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[1].public_key.w) == 0x30UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[1].endpoint.w) == 0x38UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[2].allowed_ip[0].w) == 0x40UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[2].allowed_ip[1].w) == 0x48UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[2].public_key.w) == 0x50UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[2].endpoint.w) == 0x58UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[3].allowed_ip[0].w) == 0x60UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[3].allowed_ip[1].w) == 0x68UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[3].public_key.w) == 0x70UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[3].endpoint.w) == 0x78UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[4].allowed_ip[0].w) == 0x80UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[4].allowed_ip[1].w) == 0x88UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[4].public_key.w) == 0x90UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[4].endpoint.w) == 0x98UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[5].allowed_ip[0].w) == 0xa0UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[5].allowed_ip[1].w) == 0xa8UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[5].public_key.w) == 0xb0UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[5].endpoint.w) == 0xb8UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[6].allowed_ip[0].w) == 0xc0UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[6].allowed_ip[1].w) == 0xc8UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[6].public_key.w) == 0xd0UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[6].endpoint.w) == 0xd8UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[7].allowed_ip[0].w) == 0xe0UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[7].allowed_ip[1].w) == 0xe8UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[7].public_key.w) == 0xf0UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[7].endpoint.w) == 0xf8UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[8].allowed_ip[0].w) == 0x100UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[8].allowed_ip[1].w) == 0x108UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[8].public_key.w) == 0x110UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[8].endpoint.w) == 0x118UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[9].allowed_ip[0].w) == 0x120UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[9].allowed_ip[1].w) == 0x128UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[9].public_key.w) == 0x130UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[9].endpoint.w) == 0x138UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[10].allowed_ip[0].w) == 0x140UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[10].allowed_ip[1].w) == 0x148UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[10].public_key.w) == 0x150UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[10].endpoint.w) == 0x158UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[11].allowed_ip[0].w) == 0x160UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[11].allowed_ip[1].w) == 0x168UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[11].public_key.w) == 0x170UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[11].endpoint.w) == 0x178UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[12].allowed_ip[0].w) == 0x180UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[12].allowed_ip[1].w) == 0x188UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[12].public_key.w) == 0x190UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[12].endpoint.w) == 0x198UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[13].allowed_ip[0].w) == 0x1a0UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[13].allowed_ip[1].w) == 0x1a8UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[13].public_key.w) == 0x1b0UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[13].endpoint.w) == 0x1b8UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[14].allowed_ip[0].w) == 0x1c0UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[14].allowed_ip[1].w) == 0x1c8UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[14].public_key.w) == 0x1d0UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[14].endpoint.w) == 0x1d8UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[15].allowed_ip[0].w) == 0x1e0UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[15].allowed_ip[1].w) == 0x1e8UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[15].public_key.w) == 0x1f0UL);
    assert(offsetof(csr_t, ip_lookup_engine.table[15].endpoint.w) == 0x1f8UL);
    assert(offsetof(csr_t, ip_lookup_engine.control.w) == 0x200UL);
}

static void test_bitfields(void){
    {
        csr__ip_lookup_engine__tablex__allowed_ipx_t reg;
        reg.w = 0;
        reg.f.address = 0xffffffff;
        assert(reg.w == CSR__IP_LOOKUP_ENGINE__TABLEX__ALLOWED_IPX__ADDRESS_bm);
        reg.w = 0;
        reg.f.mask = 0xffffffff;
        assert(reg.w == CSR__IP_LOOKUP_ENGINE__TABLEX__ALLOWED_IPX__MASK_bm);
    }
    {
        csr__ip_lookup_engine__tablex__public_key_t reg;
        reg.w = 0;
        reg.f.key = 0xffffffff;
        assert(reg.w == CSR__IP_LOOKUP_ENGINE__TABLEX__PUBLIC_KEY__KEY_bm);
    }
    {
        csr__ip_lookup_engine__tablex__endpoint_t reg;
        reg.w = 0;
        reg.f.address = 0xffffffff;
        assert(reg.w == CSR__IP_LOOKUP_ENGINE__TABLEX__ENDPOINT__ADDRESS_bm);
        reg.w = 0;
        reg.f.port = 0xffff;
        assert(reg.w == CSR__IP_LOOKUP_ENGINE__TABLEX__ENDPOINT__PORT_bm);
    }
    {
        csr__ip_lookup_engine__control_t reg;
        reg.w = 0;
        reg.f.update = 0x1;
        assert(reg.w == CSR__IP_LOOKUP_ENGINE__CONTROL__UPDATE_bm);
    }
}
