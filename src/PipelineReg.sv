module IfReg (
    ProcessorIntf.IfReg intf
);
    always_ff @(posedge intf.clk) begin
        if (intf.branch_flag) begin
            intf.if_pc <= 0;
            intf.if_inst <= 0;
        end else if (intf.stall_flag) begin
            // Do nothing.
        end else begin
            intf.if_pc <= intf.pc;
            intf.if_inst <= intf.inst;
        end
    end
endmodule

module IdReg (
    ProcessorIntf.IdReg intf
);
    always_ff @(posedge intf.clk) begin
        if (intf.branch_flag || intf.stall_flag) begin
            intf.id_pc <= 0;
            intf.id_reg_read_addr_1 <= 0;
            intf.id_reg_read_addr_2 <= 0;
            intf.id_reg_read_data_1 <= 0;
            intf.id_reg_read_data_2 <= 0;
            intf.id_reg_write_enable <= 0;
            intf.id_reg_write_addr <= 0;
            intf.id_data_write_enable <= 0;
            intf.id_data_read_addr <= 0;
            intf.id_data_write_addr <= 0;
            intf.id_alu_ctrl <= 0;
            intf.id_reg_write_select <= 0;
            intf.id_branch <= 0;
            intf.id_branch_direction <= 0;
            intf.id_branch_offset <= 0;
        end else begin
            intf.id_pc <= intf.if_pc;
            intf.id_reg_read_addr_1 <= intf.reg_read_addr_1;
            intf.id_reg_read_addr_2 <= intf.reg_read_addr_2;
            intf.id_reg_read_data_1 <= intf.reg_read_data_1;
            intf.id_reg_read_data_2 <= intf.reg_read_data_2;
            intf.id_reg_write_enable <= intf.reg_write_enable;
            intf.id_reg_write_addr <= intf.reg_write_addr;
            intf.id_data_write_enable <= intf.data_write_enable;
            intf.id_data_read_addr <= intf.data_read_addr;
            intf.id_data_write_addr <= intf.data_write_addr;
            intf.id_alu_ctrl <= intf.alu_ctrl;
            intf.id_reg_write_select <= intf.reg_write_select;
            intf.id_branch <= intf.branch;
            intf.id_branch_direction <= intf.branch_direction;
            intf.id_branch_offset <= intf.branch_offset;
        end
    end
endmodule

module ExReg (
    ProcessorIntf.ExReg intf
);
    always_ff @(posedge intf.clk) begin
        if (intf.branch_flag) begin
            intf.ex_reg_read_data_2 <= 0;
            intf.ex_reg_write_select <= 0;
            intf.ex_reg_write_enable <= 0;
            intf.ex_reg_write_addr <= 0;
            intf.ex_data_write_enable <= 0;
            intf.ex_data_read_addr <= 0;
            intf.ex_data_write_addr <= 0;
            intf.ex_alu_out <= 0;
            intf.ex_zero <= 0;
            intf.ex_pc <= 0;
            intf.ex_branch <= 0;
            intf.ex_branch_direction <= 0;
            intf.ex_branch_offset <= 0;
        end else begin
            intf.ex_reg_read_data_2 <= intf.alu_in_2_mux_out;
            intf.ex_reg_write_select <= intf.id_reg_write_select;
            intf.ex_reg_write_enable <= intf.id_reg_write_enable;
            intf.ex_reg_write_addr <= intf.id_reg_write_addr;
            intf.ex_data_write_enable <= intf.id_data_write_enable;
            intf.ex_data_read_addr <= intf.id_data_read_addr + intf.alu_in_1_mux_out;
            intf.ex_data_write_addr <= intf.id_data_write_addr + intf.alu_in_1_mux_out;
            intf.ex_alu_out <= intf.alu_out;
            intf.ex_zero <= intf.zero;
            intf.ex_pc <= intf.id_pc;
            intf.ex_branch <= intf.id_branch;
            intf.ex_branch_direction <= intf.id_branch_direction;
            intf.ex_branch_offset <= intf.id_branch_offset;
        end
    end
endmodule

module MemReg (
    ProcessorIntf.MemReg intf
);
    always_ff @(posedge intf.clk) begin
        intf.mem_reg_write_enable <= intf.ex_reg_write_enable;
        intf.mem_reg_write_addr <= intf.ex_reg_write_addr;
        intf.mem_reg_write_select <= intf.ex_reg_write_select;
        intf.mem_alu_out <= intf.ex_alu_out;
        intf.mem_data_read_data <= intf.data_read_data;
    end
endmodule

module WbReg (
    ProcessorIntf.WbReg intf
);
    always_ff @(posedge intf.clk) begin
        intf.wb_reg_write_mux_out <= intf.reg_write_mux_out;
        intf.wb_reg_write_enable <= intf.mem_reg_write_enable;
        intf.wb_reg_write_addr <= intf.mem_reg_write_addr;
    end
endmodule
