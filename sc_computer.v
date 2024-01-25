`timescale 1ns / 1ps
module sc_computer(clk, clrn, instr, pc, alu, mem);
    input clk, clrn;
    output [31:0] instr, pc, alu, mem;
    
    wire [31:0] data;
    wire wmem;
    sc_cpu sc_cpu(
        .instr(instr       ),
        .mem  (mem         ),
        .pc   (pc          ),
        .alu  (alu         ),
        .data (data        ),
        .clk  (clk         ),
        .clrn (clrn        ),
        .wmem (wmem        ) 
    );
    
    sc_instmem sc_instmem(
        .a    (pc           ),
        .inst (instr        ) 
    );
    
    sc_datamem sc_datamem(
        .addr   (alu       ),
        .datain (data      ),
        .we     (wmem      ),
        .clk    (clk       ),
        .dataout(mem       )
    );
    
    
endmodule
