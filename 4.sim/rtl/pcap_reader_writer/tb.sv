`timescale 1ps / 1ps
`define NULL 0

module tb;
    // Inputs
    logic CLOCK = 0;
    logic reset = 1;
    logic available;
    logic [7:0] pktcount;
    logic [7:0] pktcountw;
    logic newpkt;
    logic pcapfinished;
    parameter DATA_WIDTH = 128;
    parameter SIGNAL_TYPE = "axis00";
    localparam CLOCK_PERIOD = 12500;

    avalon_if #(.DATA_WIDTH(DATA_WIDTH)) avalon_int(.clk(CLOCK),.rst(reset));
    axis_if #(.DATA_WIDTH(DATA_WIDTH)) axis_int(.clk(CLOCK),.rst(reset));

    pcapreader #(
        .PCAP_FILENAME("../test1.pcap"),
        .SIGNAL_TYPE(SIGNAL_TYPE),
        .DATA_WIDTH(DATA_WIDTH)
    ) pcap (
	.clk_out(CLOCK),
        .reset(reset),
        .available(available),
        .pktcount(pktcount),
        .newpkt(newpkt),
	.pcapfinished(pcapfinished),

	.from_reader_avalon(avalon_int),
        .from_reader_axis(axis_int)
    );

    pcapwriter #(
	.PCAP_FILENAME("../test2.pcap"),
        .SIGNAL_TYPE(SIGNAL_TYPE),
        .DATA_WIDTH(DATA_WIDTH)
    ) pcapwr (
	.clk_in(CLOCK),
	.reset(reset),

	.to_writer_avalon(avalon_int),
        .to_writer_axis(axis_int),

        .pktcount(pktcountw)
    );

    always #(CLOCK_PERIOD/2) CLOCK <= ~CLOCK;

    integer i = 0;

    initial begin
        #(CLOCK_PERIOD);
        reset = 0;

        while (~pcapfinished) begin
	    #20
	    i = i+1;
	end

	#(2*CLOCK_PERIOD);

	$finish;
    end
endmodule
