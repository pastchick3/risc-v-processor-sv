import Def::*;

module ALU (
    input logic [1:0] ctrl,
    input data_port in_1,
    input data_port in_2,
    output data_port out,
    output logic zero
);
    assign zero = (out == 0);

    always_comb begin
        case (ctrl)
            AND: out = in_1 & in_2;
            OR: out = in_1 | in_2;
            ADD: out = in_1 + in_2;
            SUB: out = in_1 - in_2;
        endcase
    end
endmodule
