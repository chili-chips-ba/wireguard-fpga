// Generated by PeakRDL-cheader - A free and open-source header generator
//  https://github.com/SystemRDL/PeakRDL-cheader

#ifndef CSR_H
#define CSR_H

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>
#include <assert.h>

// Mem - wireguard::imem
typedef struct __attribute__ ((__packed__)) {
    uint32_t mem[8192];
} wireguard__imem_t;

// Mem - wireguard::dmem
typedef struct __attribute__ ((__packed__)) {
    uint32_t mem[8192];
} wireguard__dmem_t;

// Reg - csr::cpu_fifo::rx::data_31_0
#define CSR__CPU_FIFO__RX__DATA_31_0__TDATA_bm 0xffffffff
#define CSR__CPU_FIFO__RX__DATA_31_0__TDATA_bp 0
#define CSR__CPU_FIFO__RX__DATA_31_0__TDATA_bw 32
#define CSR__CPU_FIFO__RX__DATA_31_0__TDATA_reset 0x0
typedef union {
    struct __attribute__ ((__packed__)) {
        uint32_t tdata :32;
    } f;
    uint32_t w;
} csr__cpu_fifo__rx__data_31_0_t;

// Reg - csr::cpu_fifo::rx::data_63_32
#define CSR__CPU_FIFO__RX__DATA_63_32__TDATA_bm 0xffffffff
#define CSR__CPU_FIFO__RX__DATA_63_32__TDATA_bp 0
#define CSR__CPU_FIFO__RX__DATA_63_32__TDATA_bw 32
#define CSR__CPU_FIFO__RX__DATA_63_32__TDATA_reset 0x0
typedef union {
    struct __attribute__ ((__packed__)) {
        uint32_t tdata :32;
    } f;
    uint32_t w;
} csr__cpu_fifo__rx__data_63_32_t;

// Reg - csr::cpu_fifo::rx::data_95_64
#define CSR__CPU_FIFO__RX__DATA_95_64__TDATA_bm 0xffffffff
#define CSR__CPU_FIFO__RX__DATA_95_64__TDATA_bp 0
#define CSR__CPU_FIFO__RX__DATA_95_64__TDATA_bw 32
#define CSR__CPU_FIFO__RX__DATA_95_64__TDATA_reset 0x0
typedef union {
    struct __attribute__ ((__packed__)) {
        uint32_t tdata :32;
    } f;
    uint32_t w;
} csr__cpu_fifo__rx__data_95_64_t;

// Reg - csr::cpu_fifo::rx::data_127_96
#define CSR__CPU_FIFO__RX__DATA_127_96__TDATA_bm 0xffffffff
#define CSR__CPU_FIFO__RX__DATA_127_96__TDATA_bp 0
#define CSR__CPU_FIFO__RX__DATA_127_96__TDATA_bw 32
#define CSR__CPU_FIFO__RX__DATA_127_96__TDATA_reset 0x0
typedef union {
    struct __attribute__ ((__packed__)) {
        uint32_t tdata :32;
    } f;
    uint32_t w;
} csr__cpu_fifo__rx__data_127_96_t;

// Reg - csr::cpu_fifo::rx::control
#define CSR__CPU_FIFO__RX__CONTROL__TUSER_DST_bm 0x7
#define CSR__CPU_FIFO__RX__CONTROL__TUSER_DST_bp 0
#define CSR__CPU_FIFO__RX__CONTROL__TUSER_DST_bw 3
#define CSR__CPU_FIFO__RX__CONTROL__TUSER_DST_reset 0x0
#define CSR__CPU_FIFO__RX__CONTROL__TUSER_SRC_bm 0x38
#define CSR__CPU_FIFO__RX__CONTROL__TUSER_SRC_bp 3
#define CSR__CPU_FIFO__RX__CONTROL__TUSER_SRC_bw 3
#define CSR__CPU_FIFO__RX__CONTROL__TUSER_SRC_reset 0x0
#define CSR__CPU_FIFO__RX__CONTROL__TUSER_BYPASS_STAGE_bm 0x40
#define CSR__CPU_FIFO__RX__CONTROL__TUSER_BYPASS_STAGE_bp 6
#define CSR__CPU_FIFO__RX__CONTROL__TUSER_BYPASS_STAGE_bw 1
#define CSR__CPU_FIFO__RX__CONTROL__TUSER_BYPASS_STAGE_reset 0x0
#define CSR__CPU_FIFO__RX__CONTROL__TUSER_BYPASS_ALL_bm 0x80
#define CSR__CPU_FIFO__RX__CONTROL__TUSER_BYPASS_ALL_bp 7
#define CSR__CPU_FIFO__RX__CONTROL__TUSER_BYPASS_ALL_bw 1
#define CSR__CPU_FIFO__RX__CONTROL__TUSER_BYPASS_ALL_reset 0x0
#define CSR__CPU_FIFO__RX__CONTROL__TLAST_bm 0x8000
#define CSR__CPU_FIFO__RX__CONTROL__TLAST_bp 15
#define CSR__CPU_FIFO__RX__CONTROL__TLAST_bw 1
#define CSR__CPU_FIFO__RX__CONTROL__TLAST_reset 0x0
#define CSR__CPU_FIFO__RX__CONTROL__TKEEP_bm 0xffff0000
#define CSR__CPU_FIFO__RX__CONTROL__TKEEP_bp 16
#define CSR__CPU_FIFO__RX__CONTROL__TKEEP_bw 16
#define CSR__CPU_FIFO__RX__CONTROL__TKEEP_reset 0x0
typedef union {
    struct __attribute__ ((__packed__)) {
        uint32_t tuser_dst :3;
        uint32_t tuser_src :3;
        uint32_t tuser_bypass_stage :1;
        uint32_t tuser_bypass_all :1;
        uint32_t :7;
        uint32_t tlast :1;
        uint32_t tkeep :16;
    } f;
    uint32_t w;
} csr__cpu_fifo__rx__control_t;

// Reg - csr::cpu_fifo::rx::trigger
#define CSR__CPU_FIFO__RX__TRIGGER__TVALID_bm 0x1
#define CSR__CPU_FIFO__RX__TRIGGER__TVALID_bp 0
#define CSR__CPU_FIFO__RX__TRIGGER__TVALID_bw 1
#define CSR__CPU_FIFO__RX__TRIGGER__TVALID_reset 0x0
typedef union {
    struct __attribute__ ((__packed__)) {
        uint32_t tvalid :1;
        uint32_t :31;
    } f;
    uint32_t w;
} csr__cpu_fifo__rx__trigger_t;

// Reg - csr::cpu_fifo::rx::status
#define CSR__CPU_FIFO__RX__STATUS__TREADY_bm 0x1
#define CSR__CPU_FIFO__RX__STATUS__TREADY_bp 0
#define CSR__CPU_FIFO__RX__STATUS__TREADY_bw 1
#define CSR__CPU_FIFO__RX__STATUS__TREADY_reset 0x0
typedef union {
    struct __attribute__ ((__packed__)) {
        uint32_t tready :1;
        uint32_t :31;
    } f;
    uint32_t w;
} csr__cpu_fifo__rx__status_t;

// Regfile - csr::cpu_fifo::rx
typedef struct __attribute__ ((__packed__)) {
    csr__cpu_fifo__rx__data_31_0_t data_31_0;
    csr__cpu_fifo__rx__data_63_32_t data_63_32;
    csr__cpu_fifo__rx__data_95_64_t data_95_64;
    csr__cpu_fifo__rx__data_127_96_t data_127_96;
    csr__cpu_fifo__rx__control_t control;
    csr__cpu_fifo__rx__trigger_t trigger;
    csr__cpu_fifo__rx__status_t status;
} csr__cpu_fifo__rx_t;

// Reg - csr::cpu_fifo::tx::data_31_0
#define CSR__CPU_FIFO__TX__DATA_31_0__TDATA_bm 0xffffffff
#define CSR__CPU_FIFO__TX__DATA_31_0__TDATA_bp 0
#define CSR__CPU_FIFO__TX__DATA_31_0__TDATA_bw 32
#define CSR__CPU_FIFO__TX__DATA_31_0__TDATA_reset 0x0
typedef union {
    struct __attribute__ ((__packed__)) {
        uint32_t tdata :32;
    } f;
    uint32_t w;
} csr__cpu_fifo__tx__data_31_0_t;

// Reg - csr::cpu_fifo::tx::data_63_32
#define CSR__CPU_FIFO__TX__DATA_63_32__TDATA_bm 0xffffffff
#define CSR__CPU_FIFO__TX__DATA_63_32__TDATA_bp 0
#define CSR__CPU_FIFO__TX__DATA_63_32__TDATA_bw 32
#define CSR__CPU_FIFO__TX__DATA_63_32__TDATA_reset 0x0
typedef union {
    struct __attribute__ ((__packed__)) {
        uint32_t tdata :32;
    } f;
    uint32_t w;
} csr__cpu_fifo__tx__data_63_32_t;

// Reg - csr::cpu_fifo::tx::data_95_64
#define CSR__CPU_FIFO__TX__DATA_95_64__TDATA_bm 0xffffffff
#define CSR__CPU_FIFO__TX__DATA_95_64__TDATA_bp 0
#define CSR__CPU_FIFO__TX__DATA_95_64__TDATA_bw 32
#define CSR__CPU_FIFO__TX__DATA_95_64__TDATA_reset 0x0
typedef union {
    struct __attribute__ ((__packed__)) {
        uint32_t tdata :32;
    } f;
    uint32_t w;
} csr__cpu_fifo__tx__data_95_64_t;

// Reg - csr::cpu_fifo::tx::data_127_96
#define CSR__CPU_FIFO__TX__DATA_127_96__TDATA_bm 0xffffffff
#define CSR__CPU_FIFO__TX__DATA_127_96__TDATA_bp 0
#define CSR__CPU_FIFO__TX__DATA_127_96__TDATA_bw 32
#define CSR__CPU_FIFO__TX__DATA_127_96__TDATA_reset 0x0
typedef union {
    struct __attribute__ ((__packed__)) {
        uint32_t tdata :32;
    } f;
    uint32_t w;
} csr__cpu_fifo__tx__data_127_96_t;

// Reg - csr::cpu_fifo::tx::control
#define CSR__CPU_FIFO__TX__CONTROL__TUSER_DST_bm 0x7
#define CSR__CPU_FIFO__TX__CONTROL__TUSER_DST_bp 0
#define CSR__CPU_FIFO__TX__CONTROL__TUSER_DST_bw 3
#define CSR__CPU_FIFO__TX__CONTROL__TUSER_DST_reset 0x0
#define CSR__CPU_FIFO__TX__CONTROL__TUSER_SRC_bm 0x38
#define CSR__CPU_FIFO__TX__CONTROL__TUSER_SRC_bp 3
#define CSR__CPU_FIFO__TX__CONTROL__TUSER_SRC_bw 3
#define CSR__CPU_FIFO__TX__CONTROL__TUSER_SRC_reset 0x0
#define CSR__CPU_FIFO__TX__CONTROL__TUSER_BYPASS_STAGE_bm 0x40
#define CSR__CPU_FIFO__TX__CONTROL__TUSER_BYPASS_STAGE_bp 6
#define CSR__CPU_FIFO__TX__CONTROL__TUSER_BYPASS_STAGE_bw 1
#define CSR__CPU_FIFO__TX__CONTROL__TUSER_BYPASS_STAGE_reset 0x0
#define CSR__CPU_FIFO__TX__CONTROL__TUSER_BYPASS_ALL_bm 0x80
#define CSR__CPU_FIFO__TX__CONTROL__TUSER_BYPASS_ALL_bp 7
#define CSR__CPU_FIFO__TX__CONTROL__TUSER_BYPASS_ALL_bw 1
#define CSR__CPU_FIFO__TX__CONTROL__TUSER_BYPASS_ALL_reset 0x0
#define CSR__CPU_FIFO__TX__CONTROL__TLAST_bm 0x8000
#define CSR__CPU_FIFO__TX__CONTROL__TLAST_bp 15
#define CSR__CPU_FIFO__TX__CONTROL__TLAST_bw 1
#define CSR__CPU_FIFO__TX__CONTROL__TLAST_reset 0x0
#define CSR__CPU_FIFO__TX__CONTROL__TKEEP_bm 0xffff0000
#define CSR__CPU_FIFO__TX__CONTROL__TKEEP_bp 16
#define CSR__CPU_FIFO__TX__CONTROL__TKEEP_bw 16
#define CSR__CPU_FIFO__TX__CONTROL__TKEEP_reset 0x0
typedef union {
    struct __attribute__ ((__packed__)) {
        uint32_t tuser_dst :3;
        uint32_t tuser_src :3;
        uint32_t tuser_bypass_stage :1;
        uint32_t tuser_bypass_all :1;
        uint32_t :7;
        uint32_t tlast :1;
        uint32_t tkeep :16;
    } f;
    uint32_t w;
} csr__cpu_fifo__tx__control_t;

// Reg - csr::cpu_fifo::tx::trigger
#define CSR__CPU_FIFO__TX__TRIGGER__TREADY_bm 0x1
#define CSR__CPU_FIFO__TX__TRIGGER__TREADY_bp 0
#define CSR__CPU_FIFO__TX__TRIGGER__TREADY_bw 1
#define CSR__CPU_FIFO__TX__TRIGGER__TREADY_reset 0x0
typedef union {
    struct __attribute__ ((__packed__)) {
        uint32_t tready :1;
        uint32_t :31;
    } f;
    uint32_t w;
} csr__cpu_fifo__tx__trigger_t;

// Reg - csr::cpu_fifo::tx::status
#define CSR__CPU_FIFO__TX__STATUS__TVALID_bm 0x1
#define CSR__CPU_FIFO__TX__STATUS__TVALID_bp 0
#define CSR__CPU_FIFO__TX__STATUS__TVALID_bw 1
#define CSR__CPU_FIFO__TX__STATUS__TVALID_reset 0x0
typedef union {
    struct __attribute__ ((__packed__)) {
        uint32_t tvalid :1;
        uint32_t :31;
    } f;
    uint32_t w;
} csr__cpu_fifo__tx__status_t;

// Regfile - csr::cpu_fifo::tx
typedef struct __attribute__ ((__packed__)) {
    csr__cpu_fifo__tx__data_31_0_t data_31_0;
    csr__cpu_fifo__tx__data_63_32_t data_63_32;
    csr__cpu_fifo__tx__data_95_64_t data_95_64;
    csr__cpu_fifo__tx__data_127_96_t data_127_96;
    csr__cpu_fifo__tx__control_t control;
    csr__cpu_fifo__tx__trigger_t trigger;
    csr__cpu_fifo__tx__status_t status;
} csr__cpu_fifo__tx_t;

// Regfile - csr::cpu_fifo
typedef struct __attribute__ ((__packed__)) {
    csr__cpu_fifo__rx_t rx;
    csr__cpu_fifo__tx_t tx;
} csr__cpu_fifo_t;

// Reg - csr::uart::rx
#define CSR__UART__RX__DATA_bm 0xff
#define CSR__UART__RX__DATA_bp 0
#define CSR__UART__RX__DATA_bw 8
#define CSR__UART__RX__DATA_reset 0x0
#define CSR__UART__RX__OFLOW_bm 0x40000000
#define CSR__UART__RX__OFLOW_bp 30
#define CSR__UART__RX__OFLOW_bw 1
#define CSR__UART__RX__OFLOW_reset 0x0
#define CSR__UART__RX__VALID_bm 0x80000000
#define CSR__UART__RX__VALID_bp 31
#define CSR__UART__RX__VALID_bw 1
#define CSR__UART__RX__VALID_reset 0x0
typedef union {
    struct __attribute__ ((__packed__)) {
        uint32_t data :8;
        uint32_t :22;
        uint32_t oflow :1;
        uint32_t valid :1;
    } f;
    uint32_t w;
} csr__uart__rx_t;

// Reg - csr::uart::rx_trigger_read_2925067f
#define CSR__UART__RX_TRIGGER_READ_2925067F__READ_bm 0x1
#define CSR__UART__RX_TRIGGER_READ_2925067F__READ_bp 0
#define CSR__UART__RX_TRIGGER_READ_2925067F__READ_bw 1
#define CSR__UART__RX_TRIGGER_READ_2925067F__READ_reset 0x0
typedef union {
    struct __attribute__ ((__packed__)) {
        uint32_t read :1;
        uint32_t :31;
    } f;
    uint32_t w;
} csr__uart__rx_trigger_read_2925067f_t;

// Reg - csr::uart::tx
#define CSR__UART__TX__DATA_bm 0xff
#define CSR__UART__TX__DATA_bp 0
#define CSR__UART__TX__DATA_bw 8
#define CSR__UART__TX__DATA_reset 0x0
#define CSR__UART__TX__BUSY_bm 0x80000000
#define CSR__UART__TX__BUSY_bp 31
#define CSR__UART__TX__BUSY_bw 1
#define CSR__UART__TX__BUSY_reset 0x0
typedef union {
    struct __attribute__ ((__packed__)) {
        uint32_t data :8;
        uint32_t :23;
        uint32_t busy :1;
    } f;
    uint32_t w;
} csr__uart__tx_t;

// Reg - csr::uart::tx_trigger_write_d2a2fe0e
#define CSR__UART__TX_TRIGGER_WRITE_D2A2FE0E__WRITE_bm 0x1
#define CSR__UART__TX_TRIGGER_WRITE_D2A2FE0E__WRITE_bp 0
#define CSR__UART__TX_TRIGGER_WRITE_D2A2FE0E__WRITE_bw 1
#define CSR__UART__TX_TRIGGER_WRITE_D2A2FE0E__WRITE_reset 0x0
typedef union {
    struct __attribute__ ((__packed__)) {
        uint32_t write :1;
        uint32_t :31;
    } f;
    uint32_t w;
} csr__uart__tx_trigger_write_d2a2fe0e_t;

// Regfile - csr::uart
typedef struct __attribute__ ((__packed__)) {
    csr__uart__rx_t rx;
    csr__uart__rx_trigger_read_2925067f_t rx_trigger;
    csr__uart__tx_t tx;
    csr__uart__tx_trigger_write_d2a2fe0e_t tx_trigger;
} csr__uart_t;

// Reg - csr::gpio
#define CSR__GPIO__KEY1_bm 0x1
#define CSR__GPIO__KEY1_bp 0
#define CSR__GPIO__KEY1_bw 1
#define CSR__GPIO__KEY1_reset 0x0
#define CSR__GPIO__KEY2_bm 0x2
#define CSR__GPIO__KEY2_bp 1
#define CSR__GPIO__KEY2_bw 1
#define CSR__GPIO__KEY2_reset 0x0
#define CSR__GPIO__LED1_bm 0x100
#define CSR__GPIO__LED1_bp 8
#define CSR__GPIO__LED1_bw 1
#define CSR__GPIO__LED1_reset 0x0
#define CSR__GPIO__LED2_bm 0x200
#define CSR__GPIO__LED2_bp 9
#define CSR__GPIO__LED2_bw 1
#define CSR__GPIO__LED2_reset 0x0
typedef union {
    struct __attribute__ ((__packed__)) {
        uint32_t key1 :1;
        uint32_t key2 :1;
        uint32_t :6;
        uint32_t led1 :1;
        uint32_t led2 :1;
        uint32_t :22;
    } f;
    uint32_t w;
} csr__gpio_t;

// Reg - csr::ethernet::status
#define CSR__ETHERNET__STATUS__SPEED_bm 0x3
#define CSR__ETHERNET__STATUS__SPEED_bp 0
#define CSR__ETHERNET__STATUS__SPEED_bw 2
#define CSR__ETHERNET__STATUS__SPEED_reset 0x0
typedef union {
    struct __attribute__ ((__packed__)) {
        uint32_t speed :2;
        uint32_t :30;
    } f;
    uint32_t w;
} csr__ethernet__status_t;

// Reg - csr::ethernet::mac_47_32
#define CSR__ETHERNET__MAC_47_32__MAC_bm 0xffff
#define CSR__ETHERNET__MAC_47_32__MAC_bp 0
#define CSR__ETHERNET__MAC_47_32__MAC_bw 16
#define CSR__ETHERNET__MAC_47_32__MAC_reset 0x0
typedef union {
    struct __attribute__ ((__packed__)) {
        uint32_t mac :16;
        uint32_t :16;
    } f;
    uint32_t w;
} csr__ethernet__mac_47_32_t;

// Reg - csr::ethernet::mac_31_0
#define CSR__ETHERNET__MAC_31_0__MAC_bm 0xffffffff
#define CSR__ETHERNET__MAC_31_0__MAC_bp 0
#define CSR__ETHERNET__MAC_31_0__MAC_bw 32
#define CSR__ETHERNET__MAC_31_0__MAC_reset 0x0
typedef union {
    struct __attribute__ ((__packed__)) {
        uint32_t mac :32;
    } f;
    uint32_t w;
} csr__ethernet__mac_31_0_t;

// Regfile - csr::ethernet
typedef struct __attribute__ ((__packed__)) {
    csr__ethernet__status_t status;
    csr__ethernet__mac_47_32_t mac_47_32;
    csr__ethernet__mac_31_0_t mac_31_0;
} csr__ethernet_t;

// Reg - csr::dpe::fcr
#define CSR__DPE__FCR__IDLE_bm 0x1
#define CSR__DPE__FCR__IDLE_bp 0
#define CSR__DPE__FCR__IDLE_bw 1
#define CSR__DPE__FCR__IDLE_reset 0x0
#define CSR__DPE__FCR__PAUSE_bm 0x2
#define CSR__DPE__FCR__PAUSE_bp 1
#define CSR__DPE__FCR__PAUSE_bw 1
#define CSR__DPE__FCR__PAUSE_reset 0x0
typedef union {
    struct __attribute__ ((__packed__)) {
        uint32_t idle :1;
        uint32_t pause :1;
        uint32_t :30;
    } f;
    uint32_t w;
} csr__dpe__fcr_t;

// Regfile - csr::dpe
typedef struct __attribute__ ((__packed__)) {
    csr__dpe__fcr_t fcr;
} csr__dpe_t;

// Reg - csr::hw_id
#define CSR__HW_ID__PRODUCT_bm 0xffff
#define CSR__HW_ID__PRODUCT_bp 0
#define CSR__HW_ID__PRODUCT_bw 16
#define CSR__HW_ID__PRODUCT_reset 0xcaca
#define CSR__HW_ID__VENDOR_bm 0xffff0000
#define CSR__HW_ID__VENDOR_bp 16
#define CSR__HW_ID__VENDOR_bw 16
#define CSR__HW_ID__VENDOR_reset 0xccae
typedef union {
    struct __attribute__ ((__packed__)) {
        uint32_t PRODUCT :16;
        uint32_t VENDOR :16;
    } f;
    uint32_t w;
} csr__hw_id_t;

// Reg - csr::hw_version
#define CSR__HW_VERSION__PATCH_bm 0xffff
#define CSR__HW_VERSION__PATCH_bp 0
#define CSR__HW_VERSION__PATCH_bw 16
#define CSR__HW_VERSION__PATCH_reset 0x0
#define CSR__HW_VERSION__MINOR_bm 0xff0000
#define CSR__HW_VERSION__MINOR_bp 16
#define CSR__HW_VERSION__MINOR_bw 8
#define CSR__HW_VERSION__MINOR_reset 0x2
#define CSR__HW_VERSION__MAJOR_bm 0xff000000
#define CSR__HW_VERSION__MAJOR_bp 24
#define CSR__HW_VERSION__MAJOR_bw 8
#define CSR__HW_VERSION__MAJOR_reset 0x0
typedef union {
    struct __attribute__ ((__packed__)) {
        uint32_t PATCH :16;
        uint32_t MINOR :8;
        uint32_t MAJOR :8;
    } f;
    uint32_t w;
} csr__hw_version_t;

// Addrmap - csr
typedef struct __attribute__ ((__packed__)) {
    csr__cpu_fifo_t cpu_fifo;
    csr__uart_t uart;
    csr__gpio_t gpio;
    csr__ethernet_t ethernet[4];
    csr__dpe_t dpe;
    csr__hw_id_t hw_id;
    csr__hw_version_t hw_version;
} csr_t;

// Addrmap - wireguard
typedef struct __attribute__ ((__packed__)) {
    wireguard__imem_t imem;
    uint8_t RESERVED_8000_fffffff[0xfff8000];
    wireguard__dmem_t dmem;
    uint8_t RESERVED_10008000_1fffffff[0xfff8000];
    csr_t csr;
} wireguard_t;


static_assert(sizeof(wireguard_t) == 0x20000088, "Packing error");

#ifdef __cplusplus
}
#endif

#endif /* CSR_H */
