`include "Def.svh"

module Mux2 (
    input logic select,
    input logic [`DATA_SIZE-1:0] in_1,
    input logic [`DATA_SIZE-1:0] in_2,
    output logic [`DATA_SIZE-1:0] out
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
    input logic [`DATA_SIZE-1:0] in_1,
    input logic [`DATA_SIZE-1:0] in_2,
    input logic [`DATA_SIZE-1:0] in_3,
    input logic [`DATA_SIZE-1:0] in_4,
    output logic [`DATA_SIZE-1:0] out
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
