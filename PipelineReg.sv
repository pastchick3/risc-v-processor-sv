module IfReg (
    IfRegIntf intf
);
    always_ff @(posedge intf.clk) begin
        if (intf.branch_flag) begin      
            intf.reg_pc <= 0;
            intf.reg_inst <= 0;
        end else if (intf.stall_flag) begin
            intf.reg_pc <= intf.reg_pc;
            intf.reg_inst <= intf.reg_inst;
        end else begin
            intf.reg_pc <= intf.pc;
            intf.reg_inst <= intf.inst;
        end
    end
endmodule


module IdReg (
    IdRegIntf intf
);
    always_ff @(posedge intf.clk) begin
        if (intf.branch_flag) begin
            intf.reg_pc <= 0;
            intf.reg_reg_read_addr_1 <= 0;
            intf.reg_reg_read_addr_2 <= 0;
            intf.reg_reg_read_data_1 <= 0;
            intf.reg_reg_read_data_2 <= 0;
            intf.reg_reg_write_enable <= 0;
            intf.reg_reg_write_addr <= 0;
            intf.reg_data_write_enable <= 0;
            intf.reg_data_read_addr <= 0;
            intf.reg_data_write_addr <= 0;
            intf.reg_alu_ctrl <= 0;
            intf.reg_reg_write_select <= 0;
            intf.reg_branch <= 0;
            intf.reg_branch_direction <= 0;
            intf.reg_branch_offset <= 0;
        end else if (intf.stall_flag) begin
            intf.reg_pc <= 0;
            intf.reg_reg_read_addr_1 <= 0;
            intf.reg_reg_read_addr_2 <= 0;
            intf.reg_reg_read_data_1 <= 0;
            intf.reg_reg_read_data_2 <= 0;
            intf.reg_reg_write_enable <= 0;
            intf.reg_reg_write_addr <= 0;
            intf.reg_data_write_enable <= 0;
            intf.reg_data_read_addr <= 0;
            intf.reg_data_write_addr <= 0;
            intf.reg_alu_ctrl <= 0;
            intf.reg_reg_write_select <= 0;
            intf.reg_branch <= 0;
            intf.reg_branch_direction <= 0;
            intf.reg_branch_offset <= 0;
        end else begin
            intf.reg_pc <= if_reg_intf.reg_pc;
            intf.reg_reg_read_addr_1 <= intf.reg_read_addr_1;
            intf.reg_reg_read_addr_2 <= intf.reg_read_addr_2;
            intf.reg_reg_read_data_1 <= intf.read_data_1;
            intf.reg_reg_read_data_2 <= intf.read_data_2;
            intf.reg_reg_write_enable <= intf.reg_write_enable;
            intf.reg_reg_write_addr <= intf.reg_write_addr;
            intf.reg_data_write_enable <= intf.data_write_enable;
            intf.reg_data_read_addr <= intf.data_read_addr;
            intf.reg_data_write_addr <= intf.data_write_addr;
            intf.reg_alu_ctrl <= intf.alu_ctrl;
            intf.reg_reg_write_select <= intf.reg_write_select;
            intf.reg_branch <= intf.branch;
            intf.reg_branch_direction <= intf.branch_direction;
            intf.reg_branch_offset <= intf.branch_offset;
        end
    end
endmodule


module ExReg (
    ExRegIntf intf
);
    always_ff @(posedge intf.clk) begin
        if (intf.branch_flag) begin
            intf.reg_reg_read_data_2 <= 0;
            intf.reg_reg_write_enable <= 0;
            intf.reg_reg_write_addr <= 0;
            intf.reg_data_write_enable <= 0;
            intf.reg_data_read_addr <= 0;
            intf.reg_data_write_addr <= 0;
            intf.reg_reg_write_select <= 0;
            intf.reg_alu_out <= 0;
            intf.reg_zero <= 0;
            intf.reg_pc <= 0;
            intf.reg_branch <= 0;
            intf.reg_branch_direction <= 0;
            intf.reg_branch_offset <= 0;
        end else if (intf.stall_flag) begin
            intf.reg_reg_read_data_2 <= intf.alu_in_2_mux_out;
            intf.reg_reg_write_enable <= intf.reg_write_enable;
            intf.reg_reg_write_addr <= intf.reg_write_addr;
            intf.reg_data_write_enable <= intf.data_write_enable;
            intf.reg_data_read_addr <= intf.data_read_addr + intf.alu_in_1_mux_out;
            intf.reg_data_write_addr <= intf.data_write_addr + intf.alu_in_1_mux_out;
            intf.reg_reg_write_select <= intf.reg_write_select;
            intf.reg_alu_out <= intf.alu_out;
            intf.reg_zero <= intf.zero;
            intf.reg_pc <= intf.pc;
            intf.reg_branch <= intf.branch;
            intf.reg_branch_direction <= intf.branch_direction;
            intf.reg_branch_offset <= intf.branch_offset;
        end else begin
            intf.reg_reg_read_data_2 <= intf.alu_in_2_mux_out;
            intf.reg_reg_write_enable <= intf.reg_write_enable;
            intf.reg_reg_write_addr <= intf.reg_write_addr;
            intf.reg_data_write_enable <= intf.data_write_enable;
            intf.reg_data_read_addr <= intf.data_read_addr + intf.alu_in_1_mux_out;
            intf.reg_data_write_addr <= intf.data_write_addr + intf.alu_in_1_mux_out;
            intf.reg_reg_write_select <= intf.reg_write_select;
            intf.reg_alu_out <= intf.alu_out;
            intf.reg_zero <= intf.zero;
            intf.reg_pc <= intf.pc;
            intf.reg_branch <= intf.branch;
            intf.reg_branch_direction <= intf.branch_direction;
            intf.reg_branch_offset <= intf.branch_offset;
        end
    end
endmodule


module MemReg (
    MemRegIntf intf
);
    always_ff @(posedge intf.clk) begin
        intf.reg_reg_write_enable <= intf.reg_write_enable;
        intf.reg_reg_write_addr <= intf.reg_write_addr;
        intf.reg_reg_write_select <= intf.reg_write_select;
        intf.reg_alu_out <= intf.alu_out;
        intf.reg_data_read_data <= intf.data_read_data;
    end
endmodule


module WbReg (
    WbRegIntf intf
);
    always_ff @(posedge intf.clk) begin
        intf.reg_reg_write_mux_out <= intf.reg_write_mux_out;
        intf.reg_reg_write_enable <= intf.reg_write_enable;
        intf.reg_reg_write_addr <= intf.reg_write_addr;
    end
endmodule
