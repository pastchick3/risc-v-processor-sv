`timescale 1ns/1ns

module Driver ();
    logic clk;
    logic done;

    Processor processor (
        .clk(clk),
        .done(done)
    );

    initial begin
        clk <= 1;
        forever begin
            #5 clk <= ~clk;
            if (done) begin
                break;
            end
        end
    end
endmodule
