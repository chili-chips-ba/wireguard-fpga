{%- if cpuif.is_interface -%}
`ifndef SYNTHESIS
    initial begin
        assert_bad_addr_width: assert($bits({{cpuif.signal("araddr")}}) >= {{ds.package_name}}::{{ds.module_name.upper()}}_MIN_ADDR_WIDTH)
            else $error("Interface address width of %0d is too small. Shall be at least %0d bits", $bits({{cpuif.signal("araddr")}}), {{ds.package_name}}::{{ds.module_name.upper()}}_MIN_ADDR_WIDTH);
        assert_bad_data_width: assert($bits({{cpuif.signal("wdata")}}) == {{ds.package_name}}::{{ds.module_name.upper()}}_DATA_WIDTH)
            else $error("Interface data width of %0d is incorrect. Shall be %0d bits", $bits({{cpuif.signal("wdata")}}), {{ds.package_name}}::{{ds.module_name.upper()}}_DATA_WIDTH);
    end
`endif

{% endif -%}

// Max Outstanding Transactions: {{cpuif.max_outstanding}}
logic [{{clog2(cpuif.max_outstanding+1)-1}}:0] axil_n_in_flight;
logic axil_prev_was_rd;
logic axil_arvalid;
logic [{{cpuif.addr_width-1}}:0] axil_araddr;
logic axil_ar_accept;
logic axil_awvalid;
logic [{{cpuif.addr_width-1}}:0] axil_awaddr;
logic axil_wvalid;
logic [{{cpuif.data_width-1}}:0] axil_wdata;
logic [{{cpuif.data_width_bytes-1}}:0] axil_wstrb;
logic axil_aw_accept;
logic axil_resp_acked;

// Transaction request acceptance
always_ff {{get_always_ff_event(cpuif.reset)}} begin
    if({{get_resetsignal(cpuif.reset)}}) begin
        axil_prev_was_rd <= '0;
        axil_arvalid <= '0;
        axil_araddr <= '0;
        axil_awvalid <= '0;
        axil_awaddr <= '0;
        axil_wvalid <= '0;
        axil_wdata <= '0;
        axil_wstrb <= '0;
        axil_n_in_flight <= '0;
    end else begin
        // AR* acceptance register
        if(axil_ar_accept) begin
            axil_prev_was_rd <= '1;
            axil_arvalid <= '0;
        end
        if({{cpuif.signal("arvalid")}} && {{cpuif.signal("arready")}}) begin
            axil_arvalid <= '1;
            axil_araddr <= {{cpuif.signal("araddr")}};
        end

        // AW* & W* acceptance registers
        if(axil_aw_accept) begin
            axil_prev_was_rd <= '0;
            axil_awvalid <= '0;
            axil_wvalid <= '0;
        end
        if({{cpuif.signal("awvalid")}} && {{cpuif.signal("awready")}}) begin
            axil_awvalid <= '1;
            axil_awaddr <= {{cpuif.signal("awaddr")}};
        end
        if({{cpuif.signal("wvalid")}} && {{cpuif.signal("wready")}}) begin
            axil_wvalid <= '1;
            axil_wdata <= {{cpuif.signal("wdata")}};
            axil_wstrb <= {{cpuif.signal("wstrb")}};
        end

        // Keep track of in-flight transactions
        if((axil_ar_accept || axil_aw_accept) && !axil_resp_acked) begin
            axil_n_in_flight <= axil_n_in_flight + 1'b1;
        end else if(!(axil_ar_accept || axil_aw_accept) && axil_resp_acked) begin
            axil_n_in_flight <= axil_n_in_flight - 1'b1;
        end
    end
end

always_comb begin
    {{cpuif.signal("arready")}} = (!axil_arvalid || axil_ar_accept);
    {{cpuif.signal("awready")}} = (!axil_awvalid || axil_aw_accept);
    {{cpuif.signal("wready")}} = (!axil_wvalid || axil_aw_accept);
end

// Request dispatch
always_comb begin
    cpuif_wr_data = axil_wdata;
    for(int i=0; i<{{cpuif.data_width_bytes}}; i++) begin
        cpuif_wr_biten[i*8 +: 8] = {8{axil_wstrb[i]}};
    end
    cpuif_req = '0;
    cpuif_req_is_wr = '0;
    cpuif_addr = '0;
    axil_ar_accept = '0;
    axil_aw_accept = '0;

    if(axil_n_in_flight < {{clog2(cpuif.max_outstanding+1)}}'d{{cpuif.max_outstanding}}) begin
        // Can safely issue more transactions without overwhelming response buffer
        if(axil_arvalid && !axil_prev_was_rd) begin
            cpuif_req = '1;
            cpuif_req_is_wr = '0;
            {%- if cpuif.data_width_bytes == 1 %}
            cpuif_addr = axil_araddr;
            {%- else %}
            cpuif_addr = {axil_araddr[{{cpuif.addr_width-1}}:{{clog2(cpuif.data_width_bytes)}}], {{clog2(cpuif.data_width_bytes)}}'b0};
            {%- endif %}
            if(!cpuif_req_stall_rd) axil_ar_accept = '1;
        end else if(axil_awvalid && axil_wvalid) begin
            cpuif_req = '1;
            cpuif_req_is_wr = '1;
            {%- if cpuif.data_width_bytes == 1 %}
            cpuif_addr = axil_awaddr;
            {%- else %}
            cpuif_addr = {axil_awaddr[{{cpuif.addr_width-1}}:{{clog2(cpuif.data_width_bytes)}}], {{clog2(cpuif.data_width_bytes)}}'b0};
            {%- endif %}
            if(!cpuif_req_stall_wr) axil_aw_accept = '1;
        end else if(axil_arvalid) begin
            cpuif_req = '1;
            cpuif_req_is_wr = '0;
            {%- if cpuif.data_width_bytes == 1 %}
            cpuif_addr = axil_araddr;
            {%- else %}
            cpuif_addr = {axil_araddr[{{cpuif.addr_width-1}}:{{clog2(cpuif.data_width_bytes)}}], {{clog2(cpuif.data_width_bytes)}}'b0};
            {%- endif %}
            if(!cpuif_req_stall_rd) axil_ar_accept = '1;
        end
    end
end


// AXI4-Lite Response Logic
{%- if cpuif.resp_buffer_size == 1 %}
always_ff {{get_always_ff_event(cpuif.reset)}} begin
    if({{get_resetsignal(cpuif.reset)}}) begin
        {{cpuif.signal("rvalid")}} <= '0;
        {{cpuif.signal("rresp")}} <= '0;
        {{cpuif.signal("rdata")}} <= '0;
        {{cpuif.signal("bvalid")}} <= '0;
        {{cpuif.signal("bresp")}} <= '0;
    end else begin
        if({{cpuif.signal("rvalid")}} && {{cpuif.signal("rready")}}) begin
            {{cpuif.signal("rvalid")}} <= '0;
        end

        if({{cpuif.signal("bvalid")}} && {{cpuif.signal("bready")}}) begin
            {{cpuif.signal("bvalid")}} <= '0;
        end

        if(cpuif_rd_ack) begin
            {{cpuif.signal("rvalid")}} <= '1;
            {{cpuif.signal("rdata")}} <= cpuif_rd_data;
            if(cpuif_rd_err) {{cpuif.signal("rresp")}} <= 2'b10; // SLVERR
            else {{cpuif.signal("rresp")}} <= 2'b00; // OKAY
        end

        if(cpuif_wr_ack) begin
            {{cpuif.signal("bvalid")}} <= '1;
            if(cpuif_wr_err) {{cpuif.signal("bresp")}} <= 2'b10; // SLVERR
            else {{cpuif.signal("bresp")}} <= 2'b00; // OKAY
        end
    end
end

always_comb begin
    axil_resp_acked = '0;
    if({{cpuif.signal("rvalid")}} && {{cpuif.signal("rready")}}) axil_resp_acked = '1;
    if({{cpuif.signal("bvalid")}} && {{cpuif.signal("bready")}}) axil_resp_acked = '1;
end

{%- else %}
struct {
    logic is_wr;
    logic err;
    logic [{{cpuif.data_width-1}}:0] rdata;
} axil_resp_buffer[{{roundup_pow2(cpuif.resp_buffer_size)}}];
{%- if not is_pow2(cpuif.resp_buffer_size) %}
// axil_resp_buffer is intentionally padded to the next power of two despite
// only requiring {{cpuif.resp_buffer_size}} entries.
// This is to avoid quirks in some tools that cannot handle indexing into a non-power-of-2 array.
// Unused entries are expected to be optimized away
{% endif %}

logic [{{clog2(cpuif.resp_buffer_size)}}:0] axil_resp_wptr;
logic [{{clog2(cpuif.resp_buffer_size)}}:0] axil_resp_rptr;

always_ff {{get_always_ff_event(cpuif.reset)}} begin
    if({{get_resetsignal(cpuif.reset)}}) begin
        for(int i=0; i<{{cpuif.resp_buffer_size}}; i++) begin
            axil_resp_buffer[i].is_wr <= '0;
            axil_resp_buffer[i].err <= '0;
            axil_resp_buffer[i].rdata <= '0;
        end
        axil_resp_wptr <= '0;
        axil_resp_rptr <= '0;
    end else begin
        // Store responses in buffer until AXI response channel accepts them
        if(cpuif_rd_ack || cpuif_wr_ack) begin
            if(cpuif_rd_ack) begin
                axil_resp_buffer[axil_resp_wptr[{{clog2(cpuif.resp_buffer_size)-1}}:0]].is_wr <= '0;
                axil_resp_buffer[axil_resp_wptr[{{clog2(cpuif.resp_buffer_size)-1}}:0]].err <= cpuif_rd_err;
                axil_resp_buffer[axil_resp_wptr[{{clog2(cpuif.resp_buffer_size)-1}}:0]].rdata <= cpuif_rd_data;

            end else if(cpuif_wr_ack) begin
                axil_resp_buffer[axil_resp_wptr[{{clog2(cpuif.resp_buffer_size)-1}}:0]].is_wr <= '1;
                axil_resp_buffer[axil_resp_wptr[{{clog2(cpuif.resp_buffer_size)-1}}:0]].err <= cpuif_wr_err;
            end
            {%- if is_pow2(cpuif.resp_buffer_size) %}
            axil_resp_wptr <= axil_resp_wptr + 1'b1;
            {%- else %}
            if(axil_resp_wptr[{{clog2(cpuif.resp_buffer_size)-1}}:0] == {{cpuif.resp_buffer_size-1}}) begin
                axil_resp_wptr[{{clog2(cpuif.resp_buffer_size)-1}}:0] <= '0;
                axil_resp_wptr[{{clog2(cpuif.resp_buffer_size)}}] <= ~axil_resp_wptr[{{clog2(cpuif.resp_buffer_size)}}];
            end else begin
                axil_resp_wptr[{{clog2(cpuif.resp_buffer_size)-1}}:0] <= axil_resp_wptr[{{clog2(cpuif.resp_buffer_size)-1}}:0] + 1'b1;
            end
            {%- endif %}
        end

        // Advance read pointer when acknowledged
        if(axil_resp_acked) begin
            {%- if is_pow2(cpuif.resp_buffer_size) %}
            axil_resp_rptr <= axil_resp_rptr + 1'b1;
            {%- else %}
            if(axil_resp_rptr[{{clog2(cpuif.resp_buffer_size)-1}}:0] == {{cpuif.resp_buffer_size-1}}) begin
                axil_resp_rptr[{{clog2(cpuif.resp_buffer_size)-1}}:0] <= '0;
                axil_resp_rptr[{{clog2(cpuif.resp_buffer_size)}}] <= ~axil_resp_rptr[{{clog2(cpuif.resp_buffer_size)}}];
            end else begin
                axil_resp_rptr[{{clog2(cpuif.resp_buffer_size)-1}}:0] <= axil_resp_rptr[{{clog2(cpuif.resp_buffer_size)-1}}:0] + 1'b1;
            end
            {%- endif %}
        end
    end
end

always_comb begin
    axil_resp_acked = '0;
    {{cpuif.signal("bvalid")}} = '0;
    {{cpuif.signal("rvalid")}} = '0;
    if(axil_resp_rptr != axil_resp_wptr) begin
        if(axil_resp_buffer[axil_resp_rptr[{{clog2(cpuif.resp_buffer_size)-1}}:0]].is_wr) begin
            {{cpuif.signal("bvalid")}} = '1;
            if({{cpuif.signal("bready")}}) axil_resp_acked = '1;
        end else begin
            {{cpuif.signal("rvalid")}} = '1;
            if({{cpuif.signal("rready")}}) axil_resp_acked = '1;
        end
    end

    {{cpuif.signal("rdata")}} = axil_resp_buffer[axil_resp_rptr[{{clog2(cpuif.resp_buffer_size)-1}}:0]].rdata;
    if(axil_resp_buffer[axil_resp_rptr[{{clog2(cpuif.resp_buffer_size)-1}}:0]].err) begin
        {{cpuif.signal("bresp")}} = 2'b10;
        {{cpuif.signal("rresp")}} = 2'b10;
    end else begin
        {{cpuif.signal("bresp")}} = 2'b00;
        {{cpuif.signal("rresp")}} = 2'b00;
    end
end
{%- endif %}
