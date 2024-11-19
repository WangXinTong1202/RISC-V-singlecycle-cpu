`timescale 1ns/1ns

module pl_computer_tb;
    reg         clk, clrn;
    wire [31:0] inst, pc, eal, mal, wres;
    
    pl_computer cpu (
        .clk(clk),
        .clrn(clrn),
        .inst(inst),
        .pc(pc),
        .eal(eal),
        .mal(mal),
        .wres(wres)
    );

    initial begin
        #0 clrn = 0;
        #0 clk  = 1;
        #1 clrn = 1;
        #1399 $stop; // 1400 ns
    end

    always #10 clk = ~clk;
endmodule
