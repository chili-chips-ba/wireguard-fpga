interface dpe_if #(
    parameter TDATA_WIDTH = 128,
    parameter TUSER_WIDTH = 5
) ();
    logic                               tready;
    logic                               tvalid;
    logic [TDATA_WIDTH-1:0]             tdata;
    logic                               tlast;
    logic [((TDATA_WIDTH+7)/8)-1:0]     tkeep;
    logic [TUSER_WIDTH-1:0]             tuser;
    
    modport m_axis (
        input     tready,
        output    tvalid,
        output    tdata,
        output    tlast,
        output    tkeep,
        output    tuser
    );
    
    modport s_axis (
        output    tready,
        input     tvalid,
        input     tdata,
        input     tlast,
        input     tkeep,
        input     tuser
    );
endinterface
