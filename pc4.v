module pc4 (pc,p4); 
    input  [31:0] pc;
    output [31:0] p4;
    assign p4 = pc + 32'h4;
endmodule
