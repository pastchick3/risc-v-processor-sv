module InstMem (
    InstMemIntf intf
);
    logic [31:0] mem [0:31];
    initial $readmemb("utils/program.obj", mem);

    assign intf.inst = mem[intf.addr];
endmodule


module RegMem (
    RegMemIntf intf
);
    logic [7:0] mem [0:31];
    initial mem <= '{ default: '0 };

    assign intf.read_data_1 = mem[intf.read_addr_1];
    assign intf.read_data_2 = mem[intf.read_addr_2];

    always @(posedge intf.clk) begin
        if (intf.write_enable) begin
            mem[intf.write_addr] <= intf.write_data;
        end
    end
endmodule


module DataMem (
    DataMemIntf intf
);
    logic [7:0] mem [0:31];
    initial $readmemb("utils/data.mem", mem);
    
    assign intf.read_data = mem[intf.read_addr];

    always_ff @(posedge intf.clk) begin
        if (intf.write_enable) begin
            mem[intf.write_addr] <= intf.write_data;
        end
    end
endmodule
