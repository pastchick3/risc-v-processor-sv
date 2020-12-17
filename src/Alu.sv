`include "Def.svh"

module ALU (
    input logic [1:0] ctrl,
    input logic [`DATA_SIZE-1:0] in_1,
    input logic [`DATA_SIZE-1:0] in_2,
    output logic [`DATA_SIZE-1:0] out,
    output logic zero
);
    assign zero = (out == 0);

    always_comb begin
        case (ctrl)
            `AND: out = in_1 & in_2;
            `OR: out = in_1 | in_2;
            `ADD: out = in_1 + in_2;
            `SUB: out = in_1 - in_2;
        endcase
    end
endmodule
