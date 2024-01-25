module jalr_addr (rs1,inst,addr); // 32-bit jalr address
    input  [31:0] rs1,inst;
    output [31:0] addr;

    // bit 31:20      19:15  12    11:7     6     0
    // imm[11:0]        rs1 000     rd      1100111 | jalr   rd,  rs1, offset[11:0]

    //                            31:11         10:0
    wire   [31:0] s_imm  = {{21{inst[31]}},inst[30:20]}; // jalr
    wire   [31:0] targat = rs1 + s_imm;
    assign addr = {targat[31:1],1'b0}; // setting the least-significant bit of the result to zero
endmodule
