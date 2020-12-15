module ALU (
    input logic [1:0] ctrl,
    input logic [7:0] in_1,
    input logic [7:0] in_2,
    output logic [7:0] out,
    output logic zero
);
    assign zero = (out == 0);

    always_comb begin
        case (ctrl)
            0: out = in_1 & in_2;
            1: out = in_1 | in_2;
            2: out = in_1 + in_2;
            3: out = in_1 - in_2;
        endcase
    end
endmodule
