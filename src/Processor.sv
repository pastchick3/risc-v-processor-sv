`include "Def.svh"

module Processor (
    input logic clk,
    output logic done
);
    // The program counter is 6 bit so we can check whether it exceeds
    // 32 (the size of the instruction memory), which indicates the
    // the program is finished.
    logic [`ADDR_SIZE:0] pc = 0;

    // Declare the pipeline control singals.
    logic branch_flag;
    logic stall_flag;

    // Declare one out of three write-back control signals.
    // The other two are declared and defined in  `Interface.sv`.
    logic [`DATA_SIZE-1:0] reg_write_mux_out;

    // Declare data forwarding control singals.
    logic [1:0] forward_1;
    logic [1:0] forward_2;
    logic [`DATA_SIZE-1:0] alu_in_1_mux_out;
    logic [`DATA_SIZE-1:0] alu_in_2_mux_out;
    logic [`DATA_SIZE-1:0] wb_reg_write_mux_out;

    // Declare ALU output signals.
    logic [`DATA_SIZE-1:0] alu_out;
    logic zero;

    // Instantiate the main interface.
    ProcessorIntf processor_intf (
        .clk(clk),
        .pc(pc[`ADDR_SIZE-1:0]),
        .branch_flag(branch_flag),
        .inst_addr(pc[`ADDR_SIZE-1:0]),
        .reg_write_mux_out(reg_write_mux_out),
        .alu_in_1_mux_out(alu_in_1_mux_out),
        .alu_in_2_mux_out(alu_in_2_mux_out),
        .alu_out(alu_out),
        .zero(zero)
    );

    // -------------------- IF Stage --------------------

    // Instantiate the instruction memory.
    InstMem inst_mem (processor_intf.InstMem);

    // Instantiate IF/ID pipeline registers.
    IfReg if_reg (processor_intf.IfReg);

    // -------------------- ID Stage --------------------

    // Instantiate the instruction decoder.
    Decoder decoder (processor_intf.Decoder);

    // Instantiate the register file.
    RegMem reg_mem (processor_intf.RegMem);

    // Instantiate ID/EX pipeline registers.
    IdReg id_reg (processor_intf.IdReg);

    // -------------------- EX Stage --------------------

    Mux4 alu_in_1_mux (
        .select(forward_1),
        .in_1(processor_intf.id_reg_read_data_1),
        .in_2(processor_intf.ex_alu_out),
        .in_3(reg_write_mux_out),
        .in_4(wb_reg_write_mux_out),
        .out(alu_in_1_mux_out)
    );

    Mux4 alu_in_2_mux (
        .select(forward_2),
        .in_1(processor_intf.id_reg_read_data_2),
        .in_2(processor_intf.ex_alu_out),
        .in_3(reg_write_mux_out),
        .in_4(wb_reg_write_mux_out),
        .out(alu_in_2_mux_out)
    );

    // Instantiate the ALU.
    ALU alu (
        .ctrl(processor_intf.id_alu_ctrl),
        .in_1(alu_in_1_mux_out),
        .in_2(alu_in_2_mux_out),
        .out(alu_out),
        .zero(zero)
    );

    // Instantiate EX/MEM pipeline registers.
    ExReg ex_reg (processor_intf.ExReg);

    // -------------------- MEM Stage --------------------

    // Instantiate the data memory.
    DataMem data_mem (processor_intf.DataMem);

    // Instantiate MEM/WB pipeline registers.
    MemReg mem_reg (processor_intf.MemReg);

    // -------------------- WB Stage --------------------

    // Define one write-back control signal.
    Mux2 reg_write_mux (
        .select(processor_intf.mem_reg_write_select),
        .in_1(processor_intf.mem_data_read_data),
        .in_2(processor_intf.mem_alu_out),
        .out(reg_write_mux_out)
    );

    // Instantiate WB pipeline registers.
    WbReg wb_reg (processor_intf.WbReg);

    // Define one data forwarding control singal.
    assign wb_reg_write_mux_out = processor_intf.wb_reg_write_mux_out;

    // -------------------- Other Supporting Modules --------------------

    // Instantiate the data hazard control module.
    DataHazardCtrl data_hazard_ctrl (processor_intf.DataHazardCtrl);
    assign forward_1 = processor_intf.forward_1;
    assign forward_2 = processor_intf.forward_2;
    assign stall_flag = processor_intf.stall_flag;

    // Compute the branch flag.
    always_comb begin
        if ((processor_intf.ex_branch == `BEQ && processor_intf.ex_zero)
            || (processor_intf.ex_branch == `BLT
            && processor_intf.ex_alu_out >= 2**(`DATA_SIZE-1))) begin
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
            if (processor_intf.ex_branch_direction) begin
                pc <= processor_intf.ex_pc - processor_intf.ex_branch_offset;
            end else begin
                pc <= processor_intf.ex_pc + processor_intf.ex_branch_offset;
            end
        end else if (stall_flag) begin
            // Do nothing.
        end else begin
            pc <= pc + 1;
        end
    end
endmodule
