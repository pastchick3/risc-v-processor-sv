module Mux2 (
    input logic select,
    input logic [7:0] in_1,
    input logic [7:0] in_2,
    output logic [7:0] out
);
    always_comb begin
        case (select)
            0: out = in_1;
            1: out = in_2;
        endcase
    end
endmodule


module Mux4 (
    input logic [1:0] select,
    input logic [7:0] in_1,
    input logic [7:0] in_2,
    input logic [7:0] in_3,
    input logic [7:0] in_4,
    output logic [7:0] out
);
    always_comb begin
        case (select)
            0: out = in_1;
            1: out = in_2;
            2: out = in_3;
            3: out = in_4;
        endcase
    end
endmodule
