// Generated by PeakRDL-regblock - A free and open-source SystemVerilog generator
//  https://github.com/SystemRDL/PeakRDL-regblock

package csr_pkg;

    localparam CSR_DATA_WIDTH = 32;
    localparam CSR_MIN_ADDR_WIDTH = 6;

    typedef struct {
        logic next;
    } csr__rx_fifo__status__tready__in_t;

    typedef struct {
        csr__rx_fifo__status__tready__in_t tready;
    } csr__rx_fifo__status__in_t;

    typedef struct {
        csr__rx_fifo__status__in_t status;
    } csr__rx_fifo__in_t;

    typedef struct {
        logic [31:0] next;
    } csr__tx_fifo__data_31_0__tdata__in_t;

    typedef struct {
        csr__tx_fifo__data_31_0__tdata__in_t tdata;
    } csr__tx_fifo__data_31_0__in_t;

    typedef struct {
        logic [31:0] next;
    } csr__tx_fifo__data_63_32__tdata__in_t;

    typedef struct {
        csr__tx_fifo__data_63_32__tdata__in_t tdata;
    } csr__tx_fifo__data_63_32__in_t;

    typedef struct {
        logic [31:0] next;
    } csr__tx_fifo__data_95_64__tdata__in_t;

    typedef struct {
        csr__tx_fifo__data_95_64__tdata__in_t tdata;
    } csr__tx_fifo__data_95_64__in_t;

    typedef struct {
        logic [31:0] next;
    } csr__tx_fifo__data_127_96__tdata__in_t;

    typedef struct {
        csr__tx_fifo__data_127_96__tdata__in_t tdata;
    } csr__tx_fifo__data_127_96__in_t;

    typedef struct {
        logic [2:0] next;
    } csr__tx_fifo__control__tuser_dst__in_t;

    typedef struct {
        logic [2:0] next;
    } csr__tx_fifo__control__tuser_src__in_t;

    typedef struct {
        logic next;
    } csr__tx_fifo__control__tuser_bypass_stage__in_t;

    typedef struct {
        logic next;
    } csr__tx_fifo__control__tuser_bypass_all__in_t;

    typedef struct {
        logic next;
    } csr__tx_fifo__control__tlast__in_t;

    typedef struct {
        logic [15:0] next;
    } csr__tx_fifo__control__tkeep__in_t;

    typedef struct {
        csr__tx_fifo__control__tuser_dst__in_t tuser_dst;
        csr__tx_fifo__control__tuser_src__in_t tuser_src;
        csr__tx_fifo__control__tuser_bypass_stage__in_t tuser_bypass_stage;
        csr__tx_fifo__control__tuser_bypass_all__in_t tuser_bypass_all;
        csr__tx_fifo__control__tlast__in_t tlast;
        csr__tx_fifo__control__tkeep__in_t tkeep;
    } csr__tx_fifo__control__in_t;

    typedef struct {
        logic next;
    } csr__tx_fifo__status__tvalid__in_t;

    typedef struct {
        csr__tx_fifo__status__tvalid__in_t tvalid;
    } csr__tx_fifo__status__in_t;

    typedef struct {
        csr__tx_fifo__data_31_0__in_t data_31_0;
        csr__tx_fifo__data_63_32__in_t data_63_32;
        csr__tx_fifo__data_95_64__in_t data_95_64;
        csr__tx_fifo__data_127_96__in_t data_127_96;
        csr__tx_fifo__control__in_t control;
        csr__tx_fifo__status__in_t status;
    } csr__tx_fifo__in_t;

    typedef struct {
        csr__rx_fifo__in_t rx_fifo;
        csr__tx_fifo__in_t tx_fifo;
    } csr__in_t;

    typedef struct {
        logic [31:0] value;
    } csr__rx_fifo__data_31_0__tdata__out_t;

    typedef struct {
        csr__rx_fifo__data_31_0__tdata__out_t tdata;
    } csr__rx_fifo__data_31_0__out_t;

    typedef struct {
        logic [31:0] value;
    } csr__rx_fifo__data_63_32__tdata__out_t;

    typedef struct {
        csr__rx_fifo__data_63_32__tdata__out_t tdata;
    } csr__rx_fifo__data_63_32__out_t;

    typedef struct {
        logic [31:0] value;
    } csr__rx_fifo__data_95_64__tdata__out_t;

    typedef struct {
        csr__rx_fifo__data_95_64__tdata__out_t tdata;
    } csr__rx_fifo__data_95_64__out_t;

    typedef struct {
        logic [31:0] value;
    } csr__rx_fifo__data_127_96__tdata__out_t;

    typedef struct {
        csr__rx_fifo__data_127_96__tdata__out_t tdata;
    } csr__rx_fifo__data_127_96__out_t;

    typedef struct {
        logic [2:0] value;
    } csr__rx_fifo__control__tuser_dst__out_t;

    typedef struct {
        logic [2:0] value;
    } csr__rx_fifo__control__tuser_src__out_t;

    typedef struct {
        logic value;
    } csr__rx_fifo__control__tuser_bypass_stage__out_t;

    typedef struct {
        logic value;
    } csr__rx_fifo__control__tuser_bypass_all__out_t;

    typedef struct {
        logic value;
    } csr__rx_fifo__control__tlast__out_t;

    typedef struct {
        logic [15:0] value;
    } csr__rx_fifo__control__tkeep__out_t;

    typedef struct {
        csr__rx_fifo__control__tuser_dst__out_t tuser_dst;
        csr__rx_fifo__control__tuser_src__out_t tuser_src;
        csr__rx_fifo__control__tuser_bypass_stage__out_t tuser_bypass_stage;
        csr__rx_fifo__control__tuser_bypass_all__out_t tuser_bypass_all;
        csr__rx_fifo__control__tlast__out_t tlast;
        csr__rx_fifo__control__tkeep__out_t tkeep;
    } csr__rx_fifo__control__out_t;

    typedef struct {
        logic value;
    } csr__rx_fifo__trigger__tvalid__out_t;

    typedef struct {
        csr__rx_fifo__trigger__tvalid__out_t tvalid;
    } csr__rx_fifo__trigger__out_t;

    typedef struct {
        csr__rx_fifo__data_31_0__out_t data_31_0;
        csr__rx_fifo__data_63_32__out_t data_63_32;
        csr__rx_fifo__data_95_64__out_t data_95_64;
        csr__rx_fifo__data_127_96__out_t data_127_96;
        csr__rx_fifo__control__out_t control;
        csr__rx_fifo__trigger__out_t trigger;
    } csr__rx_fifo__out_t;

    typedef struct {
        logic value;
    } csr__tx_fifo__trigger__tready__out_t;

    typedef struct {
        csr__tx_fifo__trigger__tready__out_t tready;
    } csr__tx_fifo__trigger__out_t;

    typedef struct {
        csr__tx_fifo__trigger__out_t trigger;
    } csr__tx_fifo__out_t;

    typedef struct {
        csr__rx_fifo__out_t rx_fifo;
        csr__tx_fifo__out_t tx_fifo;
    } csr__out_t;
endpackage
