module DataMem (
    input clk,
    input write_enable,
    input [4:0] read_addr,
    input [4:0] write_addr,
    input [7:0] write_data,
    output [7:0] read_data
);
    integer cycle = 0;
    reg [7:0] mem [0:31];
    initial $readmemb("utils/data.mem", mem);
    
    assign read_data = mem[read_addr];

    always @(posedge clk) begin
        if (write_enable) begin
            mem[write_addr] <= write_data;
        end
        $strobe(
            "DataMem 0-11 in Cycle %2d: %b %b %b %b %b %b %b %b %b %b %b %b",
            cycle, mem[0], mem[1], mem[2], mem[3],
            mem[4], mem[5], mem[6], mem[7], mem[8],
            mem[9], mem[10], mem[11]
        );
        $strobe(
            "DataMem 12-19 in Cycle %2d: %b %b %b %b %b %b %b %b",
            cycle, mem[12], mem[13], mem[14], mem[15],
            mem[16], mem[17], mem[18], mem[19]
        );
        cycle <= cycle + 1;
    end
endmodule
