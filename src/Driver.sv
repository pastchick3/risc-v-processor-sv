`timescale 1ns/1ns

module Driver ();
    logic clk = 1;
    logic done;

    Processor processor (
        .clk(clk),
        .done(done)
    );

    initial begin
        forever begin
            #5 clk <= ~clk;
            if (done) break;
        end
    end
endmodule
