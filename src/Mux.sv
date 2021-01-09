import Def::*;

module Mux2 (
    input logic select,
    input data_port in_1,
    input data_port in_2,
    output data_port out
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
    input data_port in_1,
    input data_port in_2,
    input data_port in_3,
    input data_port in_4,
    output data_port out
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
