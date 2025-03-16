
module top(
    input        clk_p,
    input        clk_n,
    input        rst_n,
    output [1:0] led
);

wire sys_clk;
wire sys_rst;
wire eth_gtx_clk;
wire eth_gtx_rst;

   fpga_plls u_fpga_plls (
      .clk_p(clk_p),
      .clk_n(clk_n),
      .rst_n(rst_n),
      .sys_clk(sys_clk),
      .sys_rst(sys_rst),
      .eth_gtx_clk(eth_gtx_clk),
      .eth_gtx_rst(eth_gtx_rst)
   );
    
    reg [7:0] reset_cnt = 0;
    wire resetn = &reset_cnt;
    always @(posedge sys_clk) begin
        if (!resetn)
            reset_cnt <= reset_cnt + 1;
    end

    wire dummy_tx;
    wire dummy_rx = 1'b0;

    wire         iomem_valid;
    wire         iomem_ready;
    wire [3:0]   iomem_wstrb;
    wire [31:0]  iomem_addr;
    wire [31:0]  iomem_wdata;
    wire [31:0]  iomem_rdata;

    parameter c_CNT_CLK_HZ = 50000000;
    reg [31:0] r_CNT_CLK_HZ = 0;
    reg r_CLK_1HZ       = 1'b0;
    always @(posedge sys_clk)  
    begin
        if (r_CNT_CLK_HZ == c_CNT_CLK_HZ-1) begin
            r_CLK_1HZ <= !r_CLK_1HZ;
            r_CNT_CLK_HZ <= 0;
        end else
            r_CNT_CLK_HZ <= r_CNT_CLK_HZ + 1;
    end 
    
    reg [31:0] gpio;
    assign led[0] = gpio[0];
    assign led[1] = r_CLK_1HZ;


    reg [31:0] gpio_iomem_rdata;
    reg        gpio_iomem_ready;
	 
    wire gpio_en = (iomem_addr[31:24] == 8'h03);

    assign iomem_ready = gpio_en ? gpio_iomem_ready : 1'b0;
    assign iomem_rdata = gpio_en ? gpio_iomem_rdata : 32'h00000000;

    always @(posedge sys_clk) begin
        if (!resetn)
            gpio <= 0;
        else begin
            gpio_iomem_ready <= 0;
            if (iomem_valid && !iomem_ready && gpio_en) begin
                gpio_iomem_ready <= 1;
                gpio_iomem_rdata <= gpio;
                if (iomem_wstrb[0]) gpio[7:0]  <= iomem_wdata[7:0];
                if (iomem_wstrb[1]) gpio[15:8] <= iomem_wdata[15:8];
            end
        end
    end

    wire        progmem_wen;
    wire [31:0] ram_addr;
    wire [31:0] ram_data;
    
    picosoc_noflash soc (
        .clk         (sys_clk),
        .resetn      (resetn),
        .ser_tx      (dummy_tx),
        .ser_rx      (dummy_rx),
        .iomem_valid (iomem_valid),
        .iomem_ready (iomem_ready),
        .iomem_wstrb (iomem_wstrb),
        .iomem_addr  (iomem_addr),
        .iomem_wdata (iomem_wdata),
        .iomem_rdata (iomem_rdata),
        .progmem_wen (progmem_wen),
        .progmem_waddr(ram_addr),
        .progmem_wdata(ram_data)
    );

endmodule