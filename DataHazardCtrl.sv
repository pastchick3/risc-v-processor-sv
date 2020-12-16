`include "Def.svh"

module DataHazardCtrl (
    input logic clk,
    input logic ex_reg_write_enable,
    input logic [`ADDR_SIZE-1:0] ex_reg_write_addr,
    input logic mem_reg_write_enable,
    input logic [`ADDR_SIZE-1:0] mem_reg_write_addr,
    input logic wb_reg_write_enable,
    input logic [`ADDR_SIZE-1:0] wb_reg_write_addr,
    input logic [`ADDR_SIZE-1:0] id_reg_read_addr_1,
    input logic [`ADDR_SIZE-1:0] id_reg_read_addr_2,
    input logic id_reg_write_enable,
    input logic id_reg_write_select,
    input logic [`ADDR_SIZE-1:0] id_reg_write_addr,
    input logic [`INST_SIZE-1:0] if_inst,
    output logic [1:0] forward_1,
    output logic [1:0] forward_2,
    output logic stall_flag
);
    typedef enum logic [1:0] { NULL, EX, MEM, WB } FORWARD;
    FORWARD FORWARD_1, FORWARD_2;

    always_comb begin
        // Forward data.
        FORWARD_1 = NULL;
        FORWARD_2 = NULL;
        if (wb_reg_write_enable && wb_reg_write_addr) begin
            if (wb_reg_write_addr == id_reg_read_addr_1) FORWARD_1 = WB;
            if (wb_reg_write_addr == id_reg_read_addr_2) FORWARD_2 = WB;
        end
        if (mem_reg_write_enable && mem_reg_write_addr) begin
            if (mem_reg_write_addr == id_reg_read_addr_1) FORWARD_1 = MEM;
            if (mem_reg_write_addr == id_reg_read_addr_2) FORWARD_2 = MEM;
        end
        if (ex_reg_write_enable && ex_reg_write_addr) begin
            if (ex_reg_write_addr == id_reg_read_addr_1) FORWARD_1 = EX;
            if (ex_reg_write_addr == id_reg_read_addr_2) FORWARD_2 = EX;
        end
        forward_1 = FORWARD_1;
        forward_2 = FORWARD_2;

        // Stall the pipeline if there is an instruction that reads a
        // register following a load instruction that operates on the
        // same register.
        if ((id_reg_write_enable && !id_reg_write_select)
            && ((id_reg_write_addr == if_inst[19:15])
            || (id_reg_write_addr == if_inst[24:20]))) begin
            stall_flag = 1;
        end else begin
            stall_flag = 0;
        end
    end
endmodule
