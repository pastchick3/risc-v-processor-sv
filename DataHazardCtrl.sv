module DataHazardCtrl (
    input clk,
    input ex_reg_write_enable,
    input [4:0] ex_reg_write_addr,
    input mem_reg_write_enable,
    input [4:0] mem_reg_write_addr,
    input wb_reg_write_enable,
    input [4:0] wb_reg_write_addr,
    input [4:0] id_reg_read_addr_1,
    input [4:0] id_reg_read_addr_2,
    input id_reg_write_enable,
    input id_reg_write_select,
    input [4:0] id_reg_write_addr,
    input [31:0] if_inst,
    output reg [1:0] forward_1,
    output reg [1:0] forward_2,
    output reg stall_flag
);
    always_comb begin
        // ALU input 1
        if (ex_reg_write_enable
            && (ex_reg_write_addr != 0)
            && (ex_reg_write_addr == id_reg_read_addr_1)) begin
            // EX hazard
            forward_1 = 1;
        end else if (mem_reg_write_enable
            && (mem_reg_write_addr != 0)
            && (mem_reg_write_addr == id_reg_read_addr_1)) begin
            // MEM hazard
            forward_1 = 2;
        end else if (wb_reg_write_enable
            && (wb_reg_write_addr != 0)
            && (wb_reg_write_addr == id_reg_read_addr_1)) begin
            // WB hazard
            forward_1 = 3;
        end else begin
            // No hazard
            forward_1 = 0;
        end

        // ALU input 2
        if (ex_reg_write_enable
            && (ex_reg_write_addr != 0)
            && (ex_reg_write_addr == id_reg_read_addr_2)) begin
            // EX hazard
            forward_2 = 1;
        end else if (mem_reg_write_enable
            && (mem_reg_write_addr != 0)
            && (mem_reg_write_addr == id_reg_read_addr_2)) begin
            // MEM hazard
            forward_2 = 2;
        end else if (wb_reg_write_enable
            && (wb_reg_write_addr != 0)
            && (wb_reg_write_addr == id_reg_read_addr_2)) begin
            // WB hazard
            forward_2 = 3;
        end else begin
            // No hazard
            forward_2 = 0;
        end

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
