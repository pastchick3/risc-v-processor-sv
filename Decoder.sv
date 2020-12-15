module Decoder (
    DecoderIntf intf
);
    always_comb begin
        casex ({intf.inst[31:25], intf.inst[14:12], intf.inst[6:0]})
            17'bXXXXXXX_011_0000011: begin // ld
                intf.reg_write_enable = 1'b1;
                intf.reg_read_addr_1 = intf.inst[19:15];
                intf.reg_read_addr_2 = 5'b00000;
                intf.reg_write_addr = intf.inst[11:7];
                intf.data_write_enable = 1'b0;
                intf.data_read_addr = intf.inst[24:20];
                intf.data_write_addr = 5'b00000;
                intf.alu_ctrl = 2'b00;
                intf.reg_write_select = 1'b0;
                intf.branch = 2'b00;
                intf.branch_direction = 1'b0;
                intf.branch_offset = 5'b00000;
            end
            17'bXXXXXXX_011_0100011: begin // sd
                intf.reg_write_enable = 1'b0;
                intf.reg_read_addr_1 = intf.inst[19:15];
                intf.reg_read_addr_2 = intf.inst[24:20];
                intf.reg_write_addr = 5'b00000;
                intf.data_write_enable = 1'b1;
                intf.data_read_addr = 5'b00000;
                intf.data_write_addr = intf.inst[11:7];
                intf.alu_ctrl = 2'b00;
                intf.reg_write_select = 1'b0;
                intf.branch = 2'b00;
                intf.branch_direction = 1'b0;
                intf.branch_offset = 5'b00000;
            end
            17'b0000000_111_0110011: begin // and
                intf.reg_write_enable = 1'b1;
                intf.reg_read_addr_1 = intf.inst[19:15];
                intf.reg_read_addr_2 = intf.inst[24:20];
                intf.reg_write_addr = intf.inst[11:7];
                intf.data_write_enable = 1'b0;
                intf.data_read_addr = 5'b00000;
                intf.data_write_addr = 5'b00000;
                intf.alu_ctrl = 2'b00;
                intf.reg_write_select = 1'b1;
                intf.branch = 2'b00;
                intf.branch_direction = 1'b0;
                intf.branch_offset = 5'b00000;
            end
            17'b0000000_110_0110011: begin // or
                intf.reg_write_enable = 1'b1;
                intf.reg_read_addr_1 = intf.inst[19:15];
                intf.reg_read_addr_2 = intf.inst[24:20];
                intf.reg_write_addr = intf.inst[11:7];
                intf.data_write_enable = 1'b0;
                intf.data_read_addr = 5'b00000;
                intf.data_write_addr = 5'b00000;
                intf.alu_ctrl = 2'b01;
                intf.reg_write_select = 1'b1;
                intf.branch = 2'b00;
                intf.branch_direction = 1'b0;
                intf.branch_offset = 5'b00000;
            end
            17'b0000000_000_0110011: begin // add
                intf.reg_write_enable = 1'b1;
                intf.reg_read_addr_1 = intf.inst[19:15];
                intf.reg_read_addr_2 = intf.inst[24:20];
                intf.reg_write_addr = intf.inst[11:7];
                intf.data_write_enable = 1'b0;
                intf.data_read_addr = 5'b00000;
                intf.data_write_addr = 5'b00000;
                intf.alu_ctrl = 2'b10;
                intf.reg_write_select = 1'b1;
                intf.branch = 2'b00;
                intf.branch_direction = 1'b0;
                intf.branch_offset = 5'b00000;
            end
            17'b0100000_000_0110011: begin // sub
                intf.reg_write_enable = 1'b1;
                intf.reg_read_addr_1 = intf.inst[19:15];
                intf.reg_read_addr_2 = intf.inst[24:20];
                intf.reg_write_addr = intf.inst[11:7];
                intf.data_write_enable = 1'b0;
                intf.data_read_addr = 5'b00000;
                intf.data_write_addr = 5'b00000;
                intf.alu_ctrl = 2'b11;
                intf.reg_write_select = 1'b1;
                intf.branch = 2'b00;
                intf.branch_direction = 1'b0;
                intf.branch_offset = 5'b00000;
            end
            17'bXXXXXXX_000_1100011: begin // beq
                intf.reg_write_enable = 1'b0;
                intf.reg_read_addr_1 = intf.inst[19:15];
                intf.reg_read_addr_2 = intf.inst[24:20];
                intf.reg_write_addr = 5'b00000;
                intf.data_write_enable = 1'b0;
                intf.data_read_addr = 5'b00000;
                intf.data_write_addr = 5'b00000;
                intf.alu_ctrl = 2'b11;
                intf.reg_write_select = 1'b0;
                intf.branch = 2'b01;
                intf.branch_direction = intf.inst[25];
                intf.branch_offset = intf.inst[11:7];
            end
            17'bXXXXXXX_100_1100011: begin // blt
                intf.reg_write_enable = 1'b0;
                intf.reg_read_addr_1 = intf.inst[19:15];
                intf.reg_read_addr_2 = intf.inst[24:20];
                intf.reg_write_addr = 5'b00000;
                intf.data_write_enable = 1'b0;
                intf.data_read_addr = 5'b00000;
                intf.data_write_addr = 5'b00000;
                intf.alu_ctrl = 2'b11;
                intf.reg_write_select = 1'b0;
                intf.branch = 2'b10;
                intf.branch_direction = intf.inst[25];
                intf.branch_offset = intf.inst[11:7];
            end
            default: begin
                intf.reg_write_enable = 1'b0;
                intf.reg_read_addr_1 = 5'b00000;
                intf.reg_read_addr_2 = 5'b00000;
                intf.reg_write_addr = 5'b00000;
                intf.data_write_enable = 1'b0;
                intf.data_read_addr = 5'b00000;
                intf.data_write_addr = 5'b00000;
                intf.alu_ctrl = 2'b00;
                intf.reg_write_select = 1'b0;
                intf.branch = 1'b0;
                intf.branch_direction = 1'b0;
                intf.branch_offset = 5'b00000;
            end
        endcase
    end
endmodule
