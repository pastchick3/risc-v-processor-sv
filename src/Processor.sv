`include "Def.svh"

module Processor (
    input logic clk,
    output logic done
);
    // The program counter is 6 bit so we can check whether it exceeds
    // 32 (the size of the instruction memory), which indicates the
    // the program is finished.
    logic [`ADDR_SIZE:0] pc = 0;

    // Declare the pipeline control singals.`
    logic stall_flag = 0;
    logic branch_flag = 0;

    // -------------------- IF Stage --------------------

    // Instantiate the instruction memory.
    InstMemIntf inst_mem_intf (
        .addr(pc[`ADDR_SIZE-1:0])
    );
    InstMem inst_mem (inst_mem_intf);

    // Instantiate IF/ID pipeline registers.
    IfRegIntf if_reg_intf (
        .clk(clk),
        .branch_flag(branch_flag),
        .stall_flag(stall_flag),
        .pc(pc[`ADDR_SIZE-1:0]),
        .inst(inst_mem_intf.inst)
    );
    IfReg if_reg (if_reg_intf);

    // -------------------- ID Stage --------------------

    // Instantiate the instruction decoder.
    DecoderIntf decoder_intf (
        .inst(if_reg_intf.reg_inst)
    );
    Decoder decoder (decoder_intf);

    // Declare the write-back control signals.
    logic mem_reg_intf_reg_write_enable;
    logic [`ADDR_SIZE-1:0] mem_reg_intf_reg_write_addr;
    logic [`DATA_SIZE-1:0] reg_write_mux_out;

    // Instantiate the register file.
    RegMemIntf reg_mem_intf (
        .clk(clk),
        .write_enable(mem_reg_intf_reg_write_enable),
        .read_addr_1(decoder_intf.reg_read_addr_1),
        .read_addr_2(decoder_intf.reg_read_addr_2),
        .write_addr(mem_reg_intf_reg_write_addr),
        .write_data(reg_write_mux_out)
    );
    RegMem reg_mem (reg_mem_intf);

    // Instantiate ID/EX pipeline registers.
    IdRegIntf id_reg_intf (
        .clk(clk),
        .branch_flag(branch_flag),
        .stall_flag(stall_flag),
        .pc(if_reg_intf.reg_pc),
        .reg_read_addr_1(decoder_intf.reg_read_addr_1),
        .reg_read_addr_2(decoder_intf.reg_read_addr_2),
        .read_data_1(reg_mem_intf.read_data_1),
        .read_data_2(reg_mem_intf.read_data_2),
        .reg_write_enable(decoder_intf.reg_write_enable),
        .reg_write_addr(decoder_intf.reg_write_addr),
        .data_write_enable(decoder_intf.data_write_enable),
        .data_read_addr(decoder_intf.data_read_addr),
        .data_write_addr(decoder_intf.data_write_addr),
        .alu_ctrl(decoder_intf.alu_ctrl),
        .reg_write_select(decoder_intf.reg_write_select),
        .branch(decoder_intf.branch),
        .branch_direction(decoder_intf.branch_direction),
        .branch_offset(decoder_intf.branch_offset)
    );
    IdReg id_reg (id_reg_intf);

    // -------------------- EX Stage --------------------

    // Declare data forwarding control singals.
    logic [1:0] forward_1;
    logic [1:0] forward_2;
    logic [`DATA_SIZE-1:0] alu_in_1_mux_out;
    logic [`DATA_SIZE-1:0] alu_in_2_mux_out;
    logic [`DATA_SIZE-1:0] wb_reg_intf_reg_reg_write_mux_out;
    Mux4 alu_in_1_mux (
        .select(forward_1),
        .in_1(id_reg_intf.reg_reg_read_data_1),
        .in_2(ex_reg_intf.reg_alu_out),
        .in_3(reg_write_mux_out),
        .in_4(wb_reg_intf_reg_reg_write_mux_out),
        .out(alu_in_1_mux_out)
    );
    Mux4 alu_in_2_mux (
        .select(forward_2),
        .in_1(id_reg_intf.reg_reg_read_data_2),
        .in_2(ex_reg_intf.reg_alu_out),
        .in_3(reg_write_mux_out),
        .in_4(wb_reg_intf_reg_reg_write_mux_out),
        .out(alu_in_2_mux_out)
    );

    // Instantiate the ALU.
    logic [`DATA_SIZE-1:0] alu_out;
    logic zero;
    ALU alu (
        .ctrl(id_reg_intf.reg_alu_ctrl),
        .in_1(alu_in_1_mux_out),
        .in_2(alu_in_2_mux_out),
        .out(alu_out),
        .zero(zero)
    );

    // Instantiate EX/MEM pipeline registers.
    ExRegIntf ex_reg_intf (
        .clk(clk),
        .branch_flag(branch_flag),
        .stall_flag(stall_flag),
        .alu_in_1_mux_out(alu_in_1_mux_out),
        .alu_in_2_mux_out(alu_in_2_mux_out),
        .reg_write_enable(id_reg_intf.reg_reg_write_enable),
        .reg_write_addr(id_reg_intf.reg_reg_write_addr),
        .data_write_enable(id_reg_intf.reg_data_write_enable),
        .data_read_addr(id_reg_intf.reg_data_read_addr),
        .data_write_addr(id_reg_intf.reg_data_write_addr),
        .reg_write_select(id_reg_intf.reg_reg_write_select),
        .alu_out(alu_out),
        .zero(zero),
        .pc(id_reg_intf.reg_pc),
        .branch(id_reg_intf.reg_branch),
        .branch_direction(id_reg_intf.reg_branch_direction),
        .branch_offset(id_reg_intf.reg_branch_offset)
    );
    ExReg ex_reg (ex_reg_intf);

    // -------------------- MEM Stage --------------------

    // Instantiate the data memory.
    DataMemIntf data_mem_intf (
        .clk(clk),
        .write_enable(ex_reg_intf.reg_data_write_enable),
        .read_addr(ex_reg_intf.reg_data_read_addr),
        .write_addr(ex_reg_intf.reg_data_write_addr),
        .write_data(ex_reg_intf.reg_reg_read_data_2)
    );
    DataMem data_mem (data_mem_intf);

    // Instantiate MEM/WB pipeline registers.
    MemRegIntf mem_reg_intf (
        .clk(clk),
        .reg_write_enable(ex_reg_intf.reg_reg_write_enable),
        .reg_write_addr(ex_reg_intf.reg_reg_write_addr),
        .reg_write_select(ex_reg_intf.reg_reg_write_select),
        .alu_out(ex_reg_intf.reg_alu_out),
        .data_read_data(data_mem_intf.read_data)
    );
    MemReg mem_reg (mem_reg_intf);

    // Define 2 out of 3 write-back control signals.
    assign mem_reg_intf_reg_write_enable = mem_reg_intf.reg_reg_write_enable;
    assign mem_reg_intf_reg_write_addr = mem_reg_intf.reg_reg_write_addr;

    // -------------------- WB Stage --------------------

    // Define the last write-back control signal.
    Mux2 reg_write_mux (
        .select(mem_reg_intf.reg_reg_write_select),
        .in_1(mem_reg_intf.reg_data_read_data),
        .in_2(mem_reg_intf.reg_alu_out),
        .out(reg_write_mux_out)
    );

    // Instantiate WB pipeline registers.
    WbRegIntf wb_reg_intf (
        .clk(clk),
        .reg_write_mux_out(reg_write_mux_out),
        .reg_write_enable(mem_reg_intf.reg_reg_write_enable),
        .reg_write_addr(mem_reg_intf.reg_reg_write_addr)
    );
    WbReg wb_reg (wb_reg_intf);

    // Define one data forwarding control singal.
    assign wb_reg_intf_reg_reg_write_mux_out = wb_reg_intf.reg_reg_write_mux_out;

    // -------------------- Other Supporting Modules --------------------

    // Instantiate the data hazard control module.
    DataHazardCtrl data_hazard_ctrl (
        .clk(clk),
        .ex_reg_write_enable(ex_reg_intf.reg_reg_write_enable),
        .ex_reg_write_addr(ex_reg_intf.reg_reg_write_addr),
        .mem_reg_write_enable(mem_reg_intf.reg_reg_write_enable),
        .mem_reg_write_addr(mem_reg_intf.reg_reg_write_addr),
        .wb_reg_write_enable(wb_reg_intf.reg_reg_write_enable),
        .wb_reg_write_addr(wb_reg_intf.reg_reg_write_addr),
        .id_reg_read_addr_1(id_reg_intf.reg_reg_read_addr_1),
        .id_reg_read_addr_2(id_reg_intf.reg_reg_read_addr_2),
        .id_reg_write_enable(id_reg_intf.reg_reg_write_enable),
        .id_reg_write_select(id_reg_intf.reg_reg_write_select),
        .id_reg_write_addr(id_reg_intf.reg_reg_write_addr),
        .if_inst(if_reg_intf.reg_inst),
        .forward_1(forward_1),
        .forward_2(forward_2),
        .stall_flag(stall_flag)
    );

    // Compute the branch flag.
    always_comb begin
        if ((ex_reg_intf.reg_branch == `BEQ && ex_reg_intf.reg_zero)
            || (ex_reg_intf.reg_branch == `BLT && ex_reg_intf.reg_alu_out >= 2**(`DATA_SIZE-1))) begin
            branch_flag = 1;
        end else begin
            branch_flag = 0;
        end
    end

    // Compute the program counter.
    always_ff @(posedge clk) begin
        if (pc >= `MEM_LEN) begin
            done <= 1;
        end else begin
            done <= 0;
        end

        if (branch_flag) begin
            if (ex_reg_intf.reg_branch_direction) begin
                pc <= ex_reg_intf.reg_pc - ex_reg_intf.reg_branch_offset;
            end else begin
                pc <= ex_reg_intf.reg_pc + ex_reg_intf.reg_branch_offset;
            end
        end else if (stall_flag) begin
            // Do nothing.
        end else begin
            pc <= pc + 1;
        end
    end
endmodule