`include "Def.svh"

module InstMem (
    InstMemIntf intf
);
    logic [`INST_SIZE-1:0] mem [0:`MEM_LEN-1];
    initial $readmemb(`PROGRAM, mem);
    assign intf.inst = mem[intf.addr];
endmodule

module RegMem (
    RegMemIntf intf
);
    logic [`DATA_SIZE-1:0] mem [0:`MEM_LEN-1];
    initial mem <= '{ default: '0 };
    assign intf.read_data_1 = mem[intf.read_addr_1];
    assign intf.read_data_2 = mem[intf.read_addr_2];

    // To enable the initialization, we cannot use `always_ff` here.
    always @(posedge intf.clk) begin
        if (intf.write_enable) mem[intf.write_addr] <= intf.write_data;
    end
endmodule

module DataMem (
    DataMemIntf intf
);
    logic [`DATA_SIZE-1:0] mem [0:`MEM_LEN-1];
    initial $readmemb(`DATA, mem);
    assign intf.read_data = mem[intf.read_addr];

    always_ff @(posedge intf.clk) begin
        if (intf.write_enable) mem[intf.write_addr] <= intf.write_data;
    end
endmodule
