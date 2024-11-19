`timescale 1ns/1ns
module sc_computer_tb;
    reg         clk,clrn;
    wire [31:0] inst,pc,aluout,memout;
    sc_computer cpu (.clk(clk),
					 .clrn(clrn),
					 .instr(inst),
					 .pc(pc),
					 .alu(aluout),
					 .mem(memout));
    initial begin
        #0    clrn = 0;
        #0    clk  = 1;
        #1    clrn = 1;
        #1399 $stop; // 1400 ns
    end
    always #10 clk = !clk;
endmodule
