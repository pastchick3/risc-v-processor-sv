interface InstMemIntf (
    input logic [4:0] addr
);
    logic [31:0] inst;
endinterface


interface RegMemIntf (
    input logic clk,
    input logic write_enable,
    input logic [4:0] read_addr_1,
    input logic [4:0] read_addr_2,
    input logic [4:0] write_addr,
    input logic [7:0] write_data
);
    logic [7:0] read_data_1;
    logic [7:0] read_data_2;
endinterface


interface DataMemIntf (
    input logic clk,
    input logic write_enable,
    input logic [4:0] read_addr,
    input logic [4:0] write_addr,
    input logic [7:0] write_data
);
    logic [7:0] read_data;
endinterface


interface DecoderIntf (
    input [31:0] inst
);
    logic reg_write_enable;
    logic [4:0] reg_read_addr_1;
    logic [4:0] reg_read_addr_2;
    logic [4:0] reg_write_addr;
    logic data_write_enable;
    logic [4:0] data_read_addr;
    logic [4:0] data_write_addr;
    logic [1:0] alu_ctrl;
    logic reg_write_select;
    logic [1:0] branch;
    logic branch_direction;
    logic [4:0] branch_offset;
endinterface


interface IfRegIntf (
    input logic clk,
    input logic branch_flag,
    input logic stall_flag,
    input logic [4:0] pc,
    input logic [31:0] inst
);
    logic [4:0] reg_pc;
    logic [31:0] reg_inst;
endinterface


interface IdRegIntf (
    input logic clk,
    input logic branch_flag,
    input logic stall_flag,
    input logic [4:0] pc,
    input logic [4:0] reg_read_addr_1,
    input logic [4:0] reg_read_addr_2,
    input logic [7:0] read_data_1,
    input logic [7:0] read_data_2,
    input logic reg_write_enable,
    input logic [4:0] reg_write_addr,
    input logic data_write_enable,
    input logic [4:0] data_read_addr,
    input logic [4:0] data_write_addr,
    input logic [1:0] alu_ctrl,
    input logic reg_write_select,
    input logic [1:0] branch,
    input logic branch_direction,
    input logic [4:0] branch_offset
);
    logic [4:0] reg_pc;
    logic [4:0] reg_reg_read_addr_1;
    logic [4:0] reg_reg_read_addr_2;
    logic [7:0] reg_reg_read_data_1;
    logic [7:0] reg_reg_read_data_2;
    logic reg_reg_write_enable;
    logic [4:0] reg_reg_write_addr;
    logic reg_data_write_enable;
    logic [4:0] reg_data_read_addr;
    logic [4:0] reg_data_write_addr;
    logic [1:0] reg_alu_ctrl;
    logic reg_reg_write_select;
    logic [1:0] reg_branch;
    logic reg_branch_direction;
    logic [4:0] reg_branch_offset;
endinterface


interface ExRegIntf (
    input logic clk,
    input logic branch_flag,
    input logic stall_flag,
    input logic [7:0] alu_in_1_mux_out,
    input logic [7:0] alu_in_2_mux_out,
    input logic reg_write_enable,
    input logic [4:0] reg_write_addr,
    input logic data_write_enable,
    input logic [4:0] data_read_addr,
    input logic [4:0] data_write_addr,
    input logic reg_write_select,
    input logic [7:0] alu_out,
    input logic zero,
    input logic [4:0] pc,
    input logic [1:0] branch,
    input logic branch_direction,
    input logic [4:0] branch_offset
);
    logic [7:0] reg_reg_read_data_2;
    logic reg_reg_write_enable;
    logic [4:0] reg_reg_write_addr;
    logic reg_data_write_enable;
    logic [4:0] reg_data_read_addr;
    logic [4:0] reg_data_write_addr;
    logic reg_reg_write_select;
    logic [7:0] reg_alu_out;
    logic reg_zero;
    logic [4:0] reg_pc;
    logic [1:0] reg_branch;
    logic reg_branch_direction;
    logic [4:0] reg_branch_offset;
endinterface


interface MemRegIntf (
    input logic clk,
    input logic reg_write_enable,
    input logic [4:0] reg_write_addr,
    input logic reg_write_select,
    input logic [7:0] alu_out,
    input logic [7:0] data_read_data
);
    logic reg_reg_write_enable;
    logic [4:0] reg_reg_write_addr;
    logic reg_reg_write_select;
    logic [7:0] reg_alu_out;
    logic [7:0] reg_data_read_data;
endinterface


interface WbRegIntf (
    input logic clk,
    input logic [7:0] reg_write_mux_out,
    input logic reg_write_enable,
    input logic [4:0] reg_write_addr
);
    logic [7:0] reg_reg_write_mux_out;
    logic reg_reg_write_enable;
    logic [4:0] reg_reg_write_addr;
endinterface
