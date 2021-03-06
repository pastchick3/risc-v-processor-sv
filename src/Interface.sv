import Def::*;

interface ProcessorIntf (
    input logic clk,
    input addr_port pc,
    input addr_port inst_addr,
    input logic branch_flag,
    input data_port reg_write_mux_out, // Declare one out of three write-back control signals.
    input data_port alu_in_1_mux_out,
    input data_port alu_in_2_mux_out,
    input data_port alu_out,
    input logic zero
);
    // The instruction memory.
    inst_port inst;
    modport InstMem (
        input inst_addr,
        output inst
    );

    // IF/ID pipeline registers.
    addr_port if_pc;
    inst_port if_inst;
    modport IfReg (
        input clk, branch_flag, stall_flag, pc, inst,
        output if_pc, if_inst
    );

    // The instruction decoder.
    logic reg_write_enable;
    addr_port reg_read_addr_1;
    addr_port reg_read_addr_2;
    addr_port reg_write_addr;
    logic data_write_enable;
    addr_port data_read_addr;
    addr_port data_write_addr;
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
    addr_port mem_reg_write_addr;

    // The register file.
    data_port reg_read_data_1;
    data_port reg_read_data_2;
    modport RegMem (
        input clk, mem_reg_write_enable, reg_read_addr_1, reg_read_addr_2,
            mem_reg_write_addr, reg_write_mux_out,
        output reg_read_data_1, reg_read_data_2
    );

    // ID/EX pipeline registers.
    addr_port id_pc;
    addr_port id_reg_read_addr_1;
    addr_port id_reg_read_addr_2;
    data_port id_reg_read_data_1;
    data_port id_reg_read_data_2;
    logic id_reg_write_enable;
    addr_port id_reg_write_addr;
    logic id_data_write_enable;
    addr_port id_data_read_addr;
    addr_port id_data_write_addr;
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

    // EX/MEM pipeline registers.
    data_port ex_reg_read_data_2;
    logic ex_reg_write_enable;
    addr_port ex_reg_write_addr;
    logic ex_data_write_enable;
    addr_port ex_data_read_addr;
    addr_port ex_data_write_addr;
    logic ex_reg_write_select;
    data_port ex_alu_out;
    logic ex_zero;
    addr_port ex_pc;
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

    // The data memory.
    data_port data_read_data;
    modport DataMem (
        input clk, ex_data_write_enable, ex_data_read_addr, ex_data_write_addr, ex_reg_read_data_2,
        output data_read_data
    );

    // MEM/WB pipeline registers.
    logic mem_reg_write_select;
    data_port mem_alu_out;
    data_port mem_data_read_data;
    modport MemReg (
        input clk, ex_reg_write_enable, ex_reg_write_addr, ex_reg_write_select, ex_alu_out, data_read_data,
        output mem_reg_write_enable, mem_reg_write_addr, mem_reg_write_select, mem_alu_out, mem_data_read_data
    );

    // WB pipeline registers.
    data_port wb_reg_write_mux_out;
    logic wb_reg_write_enable;
    addr_port wb_reg_write_addr;
    modport WbReg (
        input clk, reg_write_mux_out, mem_reg_write_enable, mem_reg_write_addr,
        output wb_reg_write_mux_out, wb_reg_write_enable, wb_reg_write_addr
    );

    // The data hazard control module.
    logic [1:0] forward_1;
    logic [1:0] forward_2;
    logic stall_flag;
    modport DataHazardCtrl (
        input clk, ex_reg_write_enable, ex_reg_write_addr, mem_reg_write_enable, mem_reg_write_addr,
            wb_reg_write_enable, wb_reg_write_addr, id_reg_read_addr_1, id_reg_read_addr_2,
            id_reg_write_enable, id_reg_write_select, id_reg_write_addr, if_inst,
        output forward_1, forward_2, stall_flag
    );
endinterface
