`include "Def.svh"

interface ProcessorIntf (
    input logic clk,
    input logic [`ADDR_SIZE-1:0] pc,
    input logic [`ADDR_SIZE-1:0] inst_addr,
    input logic branch_flag,
    input logic stall_flag,
    input logic [`DATA_SIZE-1:0] reg_write_mux_out, // Declare one out of three write-back control signals.
    input logic [`DATA_SIZE-1:0] alu_in_1_mux_out,
    input logic [`DATA_SIZE-1:0] alu_in_2_mux_out,
    input logic [`DATA_SIZE-1:0] alu_out,
    input logic zero
);
    logic [`INST_SIZE-1:0] inst;
    modport InstMem (
        input inst_addr,
        output inst
    );

    logic [`ADDR_SIZE-1:0] if_pc;
    logic [`INST_SIZE-1:0] if_inst;
    modport IfReg (
        input clk, branch_flag, stall_flag, pc, inst,
        output if_pc, if_inst
    );

    logic reg_write_enable;
    logic [`ADDR_SIZE-1:0] reg_read_addr_1;
    logic [`ADDR_SIZE-1:0] reg_read_addr_2;
    logic [`ADDR_SIZE-1:0] reg_write_addr;
    logic data_write_enable;
    logic [`ADDR_SIZE-1:0] data_read_addr;
    logic [`ADDR_SIZE-1:0] data_write_addr;
    logic [1:0] alu_ctrl;
    logic reg_write_select;
    logic [1:0] branch;
    logic branch_direction;
    logic [4:0] branch_offset;
    modport Decoder (
        input if_inst,
        output reg_write_enable, reg_read_addr_1, reg_read_addr_2, reg_write_addr,
            data_write_enable, data_read_addr, data_write_addr,
            alu_ctrl, reg_write_select, branch, branch_direction, branch_offset
    );

    // Declare another two write-back control signals.
    logic mem_reg_write_enable;
    logic [`ADDR_SIZE-1:0] mem_reg_write_addr;

    logic [`DATA_SIZE-1:0] reg_read_data_1;
    logic [`DATA_SIZE-1:0] reg_read_data_2;
    modport RegMem (
        input clk, mem_reg_write_enable, reg_read_addr_1, reg_read_addr_2,
            mem_reg_write_addr, reg_write_mux_out,
        output reg_read_data_1, reg_read_data_2
    );

    logic [`ADDR_SIZE-1:0] id_pc;
    logic [`ADDR_SIZE-1:0] id_reg_read_addr_1;
    logic [`ADDR_SIZE-1:0] id_reg_read_addr_2;
    logic [`DATA_SIZE-1:0] id_reg_read_data_1;
    logic [`DATA_SIZE-1:0] id_reg_read_data_2;
    logic id_reg_write_enable;
    logic [`ADDR_SIZE-1:0] id_reg_write_addr;
    logic id_data_write_enable;
    logic [`ADDR_SIZE-1:0] id_data_read_addr;
    logic [`ADDR_SIZE-1:0] id_data_write_addr;
    logic [1:0] id_alu_ctrl;
    logic id_reg_write_select;
    logic [1:0] id_branch;
    logic id_branch_direction;
    logic [4:0] id_branch_offset;
    modport IdReg (
        input clk, branch_flag, stall_flag, if_pc,
            reg_read_addr_1, reg_read_addr_2, reg_read_data_1, reg_read_data_2,
            reg_write_enable, reg_write_addr, data_write_enable, data_read_addr, data_write_addr,
            alu_ctrl, reg_write_select, branch, branch_direction, branch_offset,
        output id_pc, id_reg_read_addr_1, id_reg_read_addr_2, id_reg_read_data_1, id_reg_read_data_2,
            id_reg_write_enable, id_reg_write_addr, id_data_write_enable, id_data_read_addr, id_data_write_addr,
            id_alu_ctrl, id_reg_write_select, id_branch, id_branch_direction, id_branch_offset
    );

    logic [`DATA_SIZE-1:0] ex_reg_read_data_2;
    logic ex_reg_write_enable;
    logic [`ADDR_SIZE-1:0] ex_reg_write_addr;
    logic ex_data_write_enable;
    logic [`ADDR_SIZE-1:0] ex_data_read_addr;
    logic [`ADDR_SIZE-1:0] ex_data_write_addr;
    logic ex_reg_write_select;
    logic [`DATA_SIZE-1:0] ex_alu_out;
    logic ex_zero;
    logic [`ADDR_SIZE-1:0] ex_pc;
    logic [1:0] ex_branch;
    logic ex_branch_direction;
    logic [4:0] ex_branch_offset;
    modport ExReg (
        input clk, branch_flag, alu_in_1_mux_out, alu_in_2_mux_out, id_reg_write_select,
            id_reg_write_enable, id_reg_write_addr, id_data_write_enable, id_data_read_addr, id_data_write_addr,
            alu_out, zero, id_pc, id_branch, id_branch_direction, id_branch_offset,
        output ex_reg_read_data_2, ex_reg_write_enable, ex_reg_write_addr, ex_reg_write_select,
            ex_data_write_enable, ex_data_read_addr, ex_data_write_addr,
            ex_alu_out, ex_zero, ex_pc, ex_branch, ex_branch_direction, ex_branch_offset
    );

    logic [`DATA_SIZE-1:0] data_read_data;
    modport DataMem (
        input clk, ex_data_write_enable, ex_data_read_addr, ex_data_write_addr, ex_reg_read_data_2,
        output data_read_data
    );

    logic mem_reg_write_select;
    logic [`DATA_SIZE-1:0] mem_alu_out;
    logic [`DATA_SIZE-1:0] mem_data_read_data;
    modport MemReg (
        input clk, ex_reg_write_enable, ex_reg_write_addr, ex_reg_write_select, ex_alu_out, data_read_data,
        output mem_reg_write_enable, mem_reg_write_addr, mem_reg_write_select, mem_alu_out, mem_data_read_data
    );

    logic [`DATA_SIZE-1:0] wb_reg_write_mux_out;
    logic wb_reg_write_enable;
    logic [`ADDR_SIZE-1:0] wb_reg_write_addr;
    modport WbReg (
        input clk, reg_write_mux_out, mem_reg_write_enable, mem_reg_write_addr,
        output wb_reg_write_mux_out, wb_reg_write_enable, wb_reg_write_addr
    );
endinterface
