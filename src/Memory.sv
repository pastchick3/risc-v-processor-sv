`include "Def.svh"

module InstMem (
    ProcessorIntf.InstMem intf
);
    logic [`INST_SIZE-1:0] mem [0:`MEM_LEN-1];
    initial $readmemb(`PROGRAM, mem);
    assign intf.inst = mem[intf.inst_addr];
endmodule

module RegMem (
    ProcessorIntf.RegMem intf
);
    logic [`DATA_SIZE-1:0] mem [0:`MEM_LEN-1];
    initial mem <= '{ default: '0 };
    assign intf.reg_read_data_1 = mem[intf.reg_read_addr_1];
    assign intf.reg_read_data_2 = mem[intf.reg_read_addr_2];

    // To enable the initialization, we cannot use `always_ff` here.
    always @(posedge intf.clk) begin
        if (intf.mem_reg_write_enable) begin
            mem[intf.mem_reg_write_addr] <= intf.reg_write_mux_out;
        end
    end
endmodule

module DataMem (
    ProcessorIntf.DataMem intf
);
    logic [`DATA_SIZE-1:0] mem [0:`MEM_LEN-1];
    initial $readmemb(`DATA, mem);
    assign intf.data_read_data = mem[intf.ex_data_read_addr];

    always_ff @(posedge intf.clk) begin
        if (intf.ex_data_write_enable) begin
            mem[intf.ex_data_write_addr] <= intf.ex_reg_read_data_2;
        end
    end
endmodule
