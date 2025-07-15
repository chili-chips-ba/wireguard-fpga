`timescale 1ns / 1ps
`define NULL 0

// Author: Amina Tankovic
// Based on pcapparser_10gb by Chris Shucksmith (https://github.com/shuckc/verilog-utils/blob/master/pcap/pcapparser_10gbmac.v)
// Description: Replay packets from a pcap file over Avalon-ST or AXIS bus of arbitrary width


module pcapreader#
(
    parameter PCAP_FILENAME = "none",
    parameter SIGNAL_TYPE = "avalon",                      //avalon or axis
    parameter DATA_WIDTH = 512,                            //in bits
    parameter CLOCK_PERIOD = 2560,                         //in picoseconds
    parameter EMPTY_WIDTH = DATA_WIDTH>8 ? $clog2(DATA_WIDTH/8) : 1,
    parameter KEEP_WIDTH = DATA_WIDTH/8
) (
    input logic           clk_out,
    input logic           reset,
    output logic          available = 0,

    avalon_if.out         from_reader_avalon,              //Avalon interface output
    axis_if.out           from_reader_axis,                //Axis interface output

    output logic [7:0]    pktcount = 0,
    output logic          newpkt = 0,
    output logic          pcapfinished = 0
);


    logic [7:0] global_header [0:23];   //24 bytes: magic number(4B) + version(2B for minor + 2B for major) + thiszone(4B) + sigfigs(4B) + snaplen(4B) + network(4B)
    logic [7:0] packet_header [0:15];   //16 bytes: timestamp sec(4B) + timestamp microsec/nanosec(4B) + captured length(4B) + original length(4B)

    integer swapped = 0;
    integer toNanos = 0;
    integer file = 0;
    integer r    = 0;
    integer eof  = 0;
    integer i    = 0;
    integer capLen = 0;     //captured length of a packet - third field in packet header
    integer actLen  = 0;    //length on wire (actual length) - fourth field in packet header
    integer bytes_data_out = DATA_WIDTH/8;     //number of bytes in data signal on output interface


    initial begin

        // open/check pcap file
	if (PCAP_FILENAME == "none") begin
	    $display("pcap filename parameter not set");
	    $finish;
	end

	file = $fopen(PCAP_FILENAME, "rb");
	if (file == `NULL) begin
	    $display("can't read pcap input %s", PCAP_FILENAME);
	    $finish;
	end

	// read global header
	r = $fread(global_header,file);

	// check magic number and determine formats (little/big endian, micro/nanoseconds)
	if (global_header[0] == 8'hD4 && global_header[1] == 8'hC3 && global_header[2] == 8'hB2) begin
	    $display(" pcap endian: swapped, ms");     //little endian
	    swapped = 1;
            toNanos = 0;
	end else if (global_header[0] == 8'hA1 && global_header[1] == 8'hB2 && global_header[2] == 8'hC3) begin
	    $display(" pcap endian: native, ms");     //big endian
	    swapped = 0;
	    //toNanos = 32'd1000000;
            toNanos = 0;
	end else if (global_header[0] == 8'h4D && global_header[1] == 8'h3C && global_header[2] == 8'hb2) begin
	    $display(" pcap endian: swapped, nanos");
	    swapped = 1;
	    toNanos = 1;
	end else if (global_header[0] == 8'hA1 && global_header[1] == 8'hB2 && global_header[2] == 8'h3c) begin
	    $display(" pcap endian: native, nanos");
	    swapped = 0;
            toNanos = 1;
	    //toNanos = 32'd1;
	end else begin
	    $display(" pcap endian: unrecognised format %02x%02x%02x%02x", global_header[0], global_header[1], global_header[2], global_header[3]);
	    $finish;
	end
    end


    longint cnt_clk = 64'd0;
    integer first = 1;               //mark the first packet in pcap file, in order to calculate new timestamps (shifted to zero)
    integer timestamp_sec = 0;
    integer timestamp_usec = 0;      //micro or nano seconds
    longint timestamp_usec_first = 64'd0;
    longint timestamp_sec_first = 64'd0;
    longint timestamp_usec_new = 64'd0;
    longint timestamp_sec_new = 64'd0;
    longint timestamp_new_ps = 64'd0;

    //timer in picoseconds
    always_ff @(posedge clk_out)
    begin
	if (reset == 1) begin
	    cnt_clk <= 64'd0;
        end else begin
     	    cnt_clk <= cnt_clk + CLOCK_PERIOD;
        end
    end

    /* verilator lint_off BLKSEQ */
    always @(posedge clk_out)
    begin

        if (eof != 0 || pcapfinished == 1) begin
            pcapfinished <= 1;
	    if(SIGNAL_TYPE == "avalon") begin
	        from_reader_avalon.eop <= 0;
		from_reader_avalon.sop <= 0;
		from_reader_avalon.valid <= 0;
                from_reader_avalon.data <= {DATA_WIDTH{1'b0}};
		from_reader_avalon.empty <= {EMPTY_WIDTH{1'b0}};
	    end else begin
		from_reader_axis.last <= 0;
                from_reader_axis.valid <= 0;
	        from_reader_axis.data <= {DATA_WIDTH{1'b0}};
	    end

        end else if (eof == 0 && actLen == 0 && reset == 0) begin
	    // read packet header
	    r = $fread(packet_header, file);
	    if (swapped == 1) begin
	        capLen <= {packet_header[11],packet_header[10],packet_header[9] ,packet_header[8] };
		actLen <= {packet_header[15],packet_header[14],packet_header[13],packet_header[12]};
                timestamp_usec = {packet_header[7],packet_header[6],packet_header[5],packet_header[4]};
                timestamp_sec = {packet_header[3],packet_header[2],packet_header[1],packet_header[0]};
	    end else begin
		capLen <= {packet_header[ 8],packet_header[ 9],packet_header[10],packet_header[11]};
		actLen <= {packet_header[12],packet_header[13],packet_header[14],packet_header[15]};
		timestamp_usec = {packet_header[4],packet_header[5],packet_header[6],packet_header[7]};
                timestamp_sec = {packet_header[0],packet_header[1],packet_header[2],packet_header[3]};
	    end

	    if(first == 1) begin                                                //remember timestamps for the first packet
	        timestamp_usec_first = longint'(timestamp_usec);
                timestamp_sec_first = longint'(timestamp_sec);
                first = 0;
            end
            timestamp_usec_new = longint'(timestamp_usec) - timestamp_usec_first;         //calculate shifted timestamp in micro/nanoseconds
            timestamp_sec_new = longint'(timestamp_sec) - timestamp_sec_first;            //calculate shifted timestamp in seconds

	    //new timestamp, calculated in picoseconds
	    if (toNanos ==1) begin
                timestamp_new_ps = timestamp_sec_new*longint'(1e12)+timestamp_usec_new*longint'(1e3);
            end else begin
    		timestamp_new_ps = timestamp_sec_new*longint'(1e12)+timestamp_usec_new*longint'(1e6);
            end

	    if (r!=0) begin
	        available <= 1;
	        newpkt <= 1;
	        pktcount <= pktcount + 1;
                if(SIGNAL_TYPE == "avalon") begin
	            from_reader_avalon.eop <= 0;
	            from_reader_avalon.sop <= 0;
	            from_reader_avalon.valid <= 0;
                    from_reader_avalon.data <= {DATA_WIDTH{1'b0}};
                    from_reader_avalon.empty <= {EMPTY_WIDTH{1'b0}};
                end else begin
		    from_reader_axis.last <= 0;
	            from_reader_axis.valid <= 0;
                    from_reader_axis.data <= {DATA_WIDTH{1'b0}};
                    from_reader_axis.keep <= {KEEP_WIDTH{1'b0}};
                end
	    end else begin
                pcapfinished <= 1;
                if(SIGNAL_TYPE == "avalon") begin
	            from_reader_avalon.eop <= 0;
	            from_reader_avalon.sop <= 0;
		    from_reader_avalon.valid <= 0;
                    from_reader_avalon.data <= {DATA_WIDTH{1'b0}};
                    from_reader_avalon.empty <= {EMPTY_WIDTH{1'b0}};
                end else begin
		    from_reader_axis.last <= 0;
	            from_reader_axis.valid <= 0;
                    from_reader_axis.data <= {DATA_WIDTH{1'b0}};
                    from_reader_axis.keep <= {KEEP_WIDTH{1'b0}};
                end
            end

	end else if (actLen > 0 && reset == 0) begin

	    if (cnt_clk<timestamp_new_ps) begin   //if current value of clock counter is not larger than precalculated timestamp, don't start with new packet
                if(SIGNAL_TYPE == "avalon") begin
	            from_reader_avalon.eop <= 0;
	            from_reader_avalon.sop <= 0;
		    from_reader_avalon.valid <= 0;
                    from_reader_avalon.data <= {DATA_WIDTH{1'b0}};
                    from_reader_avalon.empty <= {EMPTY_WIDTH{1'b0}};
                end else begin
	            from_reader_axis.last <= 0;
	            from_reader_axis.valid <= 0;
                    from_reader_axis.data <= {DATA_WIDTH{1'b0}};
                    from_reader_axis.keep <= {KEEP_WIDTH{1'b0}};
                end

	    end else if (cnt_clk>=timestamp_new_ps) begin  //start with new packet after clock counter became larger than the precalculated timestamp

	        if(from_reader_avalon.ready==1 || from_reader_axis.ready==1) begin   //check if ready signal is active; if ready is not active, there is backpressure
	            newpkt <= 0;
	            capLen <= (capLen > bytes_data_out-1) ? capLen - bytes_data_out : 0;
                    actLen <= (actLen > bytes_data_out-1) ? actLen - bytes_data_out : 0;

	            if(SIGNAL_TYPE == "avalon") begin                                 //check signal type and assign values to signals on the appropriate interface
	                from_reader_avalon.sop <= newpkt;
			from_reader_avalon.eop <= actLen <= bytes_data_out;
                    end else begin
			from_reader_axis.last <= actLen <= bytes_data_out;
                    end

                    if(capLen == actLen) begin                                   //case 1: captured and actual length (on wire) are equal; assign values for data and empty/keep signals
                        for (i=0; i< bytes_data_out; i = i+1) begin
		            if(SIGNAL_TYPE == "avalon") begin
                                from_reader_avalon.data[(bytes_data_out-1-i)*8+:8] <= capLen > i ? $fgetc(file) : 8'b0;
                            end else begin
				from_reader_axis.data[i*8+:8] <= capLen > i ? $fgetc(file) : 8'b0;
                            end
                        end

			if(SIGNAL_TYPE == "avalon") begin
                            from_reader_avalon.empty <= EMPTY_WIDTH'((capLen > bytes_data_out) ? 0 : bytes_data_out - capLen);
	                end else begin
                            if(capLen>bytes_data_out) begin
			        from_reader_axis.keep <= {KEEP_WIDTH{1'b1}};
                            end else begin
                                for (i=0; i<KEEP_WIDTH; i=i+1) begin
				    if(i<KEEP_WIDTH-(bytes_data_out-capLen)) begin
			                from_reader_axis.keep[i]<=1;
                                    end else begin
					from_reader_axis.keep[i]<=0;
                                    end
                                end
                            end
                        end

                    end else begin                                               //case2: captured and actual length (on wire) are not equal; assign values for data and empty/keep signals
                        if(capLen>0) begin                                       //capLen>0 means that there is still some real content in pcap file, so we can access it through "fgetc(file)"...
                            for (i=0; i<bytes_data_out; i = i+1) begin
                                if(SIGNAL_TYPE == "avalon") begin
                                    from_reader_avalon.data[(bytes_data_out-1-i)*8+:8] <= capLen > i ? $fgetc(file) : 8'b0;
                                end else begin
				    from_reader_axis.data[i*8+:8] <= capLen > i ? $fgetc(file) : 8'b0;
                                end
                            end

                            if(SIGNAL_TYPE == "avalon") begin
		                from_reader_avalon.empty <= EMPTY_WIDTH'((actLen > bytes_data_out) ? 0 : bytes_data_out - actLen);
                            end else begin
				if(actLen>bytes_data_out) begin
				    from_reader_axis.keep <= {KEEP_WIDTH{1'b1}};
                                end else begin
                                    for (i=0; i<KEEP_WIDTH; i=i+1) begin
				        if(i<KEEP_WIDTH-(bytes_data_out-actLen)) begin
				            from_reader_axis.keep[i]<=1;
                                        end else begin
					    from_reader_axis.keep[i]<=0;
                                        end
                                    end
                                end
                            end

		        end else begin                                        //...otherwise, we add zeros until we reach actLen
                            for (i=0; i<bytes_data_out; i = i+1) begin
                                if(SIGNAL_TYPE == "avalon") begin
                                    from_reader_avalon.data[(bytes_data_out-1-i)*8+:8] <= 8'b0;
                                end else begin
				    from_reader_axis.data[i*8+:8] <= 8'b0;
                                end
                            end

		            if(SIGNAL_TYPE == "avalon") begin
		                from_reader_avalon.empty <= EMPTY_WIDTH'((actLen > bytes_data_out) ? 0 : bytes_data_out - actLen);
		            end else begin
                                if(actLen>bytes_data_out) begin
				    from_reader_axis.keep <= {KEEP_WIDTH{1'b1}};
                                end else begin
                                    for (i=0; i<KEEP_WIDTH; i=i+1) begin
				        if(i<KEEP_WIDTH-(bytes_data_out-actLen)) begin
				            from_reader_axis.keep[i]<=1;
                                        end else begin
					    from_reader_axis.keep[i]<=0;
                                        end
                                    end
                                end
                            end
                        end
                    end
	        end	  //end of checking ready signal
	        eof = $feof(file);
	        if (eof != 0 || capLen == 1) begin
		    available <= 0;
		end else begin
                    if(SIGNAL_TYPE == "avalon") begin
		        from_reader_avalon.valid <= 1;
		    end else begin
                        from_reader_axis.valid <= 1;
		    end
		end
	    end else begin
	        if(SIGNAL_TYPE == "avalon") begin
		    from_reader_avalon.eop <= 0;
		    from_reader_avalon.sop <= 0;
		    from_reader_avalon.valid <= 0;
                    from_reader_avalon.data <= {DATA_WIDTH{1'b0}};
                    from_reader_avalon.empty <= {EMPTY_WIDTH{1'b0}};
                end else begin
                    from_reader_axis.last <= 0;
		    from_reader_axis.valid <= 0;
                    from_reader_axis.data <= {DATA_WIDTH{1'b0}};
                    from_reader_axis.keep <= {KEEP_WIDTH{1'b0}};
		end
	    end
        end
    end
    /* verilator lint_on BLKSEQ */

endmodule
