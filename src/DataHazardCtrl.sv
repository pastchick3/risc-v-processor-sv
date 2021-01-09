module DataHazardCtrl (
    ProcessorIntf.DataHazardCtrl intf
);
    typedef enum logic [1:0] { NULL, EX, MEM, WB } FORWARD;
    FORWARD FORWARD_1, FORWARD_2;

    always_comb begin
        // Forward data.
        FORWARD_1 = NULL;
        FORWARD_2 = NULL;
        if (intf.wb_reg_write_enable && intf.wb_reg_write_addr) begin
            if (intf.wb_reg_write_addr == intf.id_reg_read_addr_1) FORWARD_1 = WB;
            if (intf.wb_reg_write_addr == intf.id_reg_read_addr_2) FORWARD_2 = WB;
        end
        if (intf.mem_reg_write_enable && intf.mem_reg_write_addr) begin
            if (intf.mem_reg_write_addr == intf.id_reg_read_addr_1) FORWARD_1 = MEM;
            if (intf.mem_reg_write_addr == intf.id_reg_read_addr_2) FORWARD_2 = MEM;
        end
        if (intf.ex_reg_write_enable && intf.ex_reg_write_addr) begin
            if (intf.ex_reg_write_addr == intf.id_reg_read_addr_1) FORWARD_1 = EX;
            if (intf.ex_reg_write_addr == intf.id_reg_read_addr_2) FORWARD_2 = EX;
        end
        intf.forward_1 = FORWARD_1;
        intf.forward_2 = FORWARD_2;

        // Stall the pipeline if there is an instruction that reads a
        // register following a load instruction that operates on the
        // same register.
        if ((intf.id_reg_write_enable && !intf.id_reg_write_select)
            && ((intf.id_reg_write_addr == intf.if_inst[19:15])
            || (intf.id_reg_write_addr == intf.if_inst[24:20]))) begin
            intf.stall_flag = 1;
        end else begin
            intf.stall_flag = 0;
        end
    end
endmodule
