module dp_ram
#
(
	parameter DATA_WIDTH = 8,
	parameter MEM_SIZE = 720
)
(
	data,
	rdaddress,
	rdclock,
	wraddress,
	wrclock,
	wren,
	q
);

input	[DATA_WIDTH - 1:0]  data;
input	[log2ceil(MEM_SIZE) - 1 :0]  rdaddress;
input	  rdclock;
input	[log2ceil(MEM_SIZE) - 1 :0]  wraddress;
input	  wrclock;
input	  wren;
output	[DATA_WIDTH - 1:0]  q;

// --------------------------------------------------
// Calculates the log2ceil of the input value
// --------------------------------------------------
function integer log2ceil;
    input integer val;
    integer i;
    begin
        i = 1;
        log2ceil = 0;
        while (i < val) begin
            log2ceil = log2ceil + 1;
            i = i << 1;
        end
    end
endfunction

reg [log2ceil(MEM_SIZE) - 1 :0] read_addr;
reg[DATA_WIDTH - 1:0] mem [2**log2ceil(MEM_SIZE) - 1:0] /* synthesis syn_ramstyle="block_ram" */;
assign q = mem[read_addr];

// synthesis translate_off
reg [log2ceil(MEM_SIZE):0] j;
initial
begin
	if(MEM_SIZE < 2)
	begin
		$display("MEM_SIZE is must > 1(%m)");
		$stop();
	end
    $display("address width is %d(%m)\n",log2ceil(MEM_SIZE));
	for(j=0;j < 2**log2ceil(MEM_SIZE);j = j + 1)
		mem[j] <= {DATA_WIDTH{1'b0}};
end
// synthesis translate_on
always@(posedge rdclock)
begin
	read_addr <= rdaddress;
end
always@(posedge wrclock)
begin
	if(wren)
		mem[wraddress] <= data;
end
endmodule 