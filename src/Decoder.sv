`include "Def.svh"

module Decoder (
    ProcessorIntf.Decoder intf
);
    always_comb begin
        // Data signals.
        intf.reg_read_addr_1 = intf.if_inst[19:15]; // rs1
        intf.reg_read_addr_2 = intf.if_inst[24:20]; // rs2
        intf.reg_write_addr = intf.if_inst[11:7]; // rd
        intf.data_read_addr = intf.if_inst[24:20]; // imm part 1
        intf.data_write_addr = intf.if_inst[11:7]; // imm part 2
        intf.branch_direction = intf.if_inst[25]; // branch_direction
        intf.branch_offset = intf.if_inst[11:7]; // imm part 1

        // Control singals.
        intf.reg_write_enable = 0;
        intf.data_write_enable = 0;
        intf.alu_ctrl = `AND;
        intf.reg_write_select = 0;
        intf.branch = `NO_JUMP;

        // Decode an instruction based on { func7, func3, opcode }.
        casex ({ intf.if_inst[31:25], intf.if_inst[14:12], intf.if_inst[6:0] })
            17'bXXXXXXX_011_0000011: begin // ld
                intf.reg_write_enable = 1;
            end
            17'bXXXXXXX_011_0100011: begin // sd
                intf.data_write_enable = 1;
            end
            17'b0000000_111_0110011: begin // and
                intf.reg_write_enable = 1;
                intf.reg_write_select = 1;
            end
            17'b0000000_110_0110011: begin // or
                intf.reg_write_enable = 1;
                intf.alu_ctrl = `OR;
                intf.reg_write_select = 1;
            end
            17'b0000000_000_0110011: begin // add
                intf.reg_write_enable = 1;
                intf.alu_ctrl = `ADD;
                intf.reg_write_select = 1;
            end
            17'b0100000_000_0110011: begin // sub
                intf.reg_write_enable = 1;
                intf.alu_ctrl = `SUB;
                intf.reg_write_select = 1;
            end
            17'bXXXXXXX_000_1100011: begin // beq
                intf.alu_ctrl = 3;
                intf.branch = `BEQ;
            end
            17'bXXXXXXX_100_1100011: begin // blt
                intf.alu_ctrl = 3;
                intf.branch = `BLT;
            end
        endcase
    end
endmodule
