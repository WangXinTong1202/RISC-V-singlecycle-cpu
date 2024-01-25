module branch_addr (pc,inst,addr); // 32-bit branch address
    input  [31:0] pc,inst;
    output [31:0] addr;

    // bit 31 30:25 24   15  12    11:8  7  6     0
    // imm[12|10:5] rs2 rs1 000 imm[4:1|11] 1100011 | beq rs1, rs2, offset[12:1]
    // imm[12|10:5] rs2 rs1 001 imm[4:1|11] 1100011 | bne rs1, rs2, offset[12:1]

    //                            31:12        11       10:5         4:1     0
    wire   [31:0]  offset = {{20{inst[31]}},inst[7],inst[30:25],inst[11:8],1'b0}; // beq, bne, blt, bge
    assign addr = pc + offset ;
endmodule
