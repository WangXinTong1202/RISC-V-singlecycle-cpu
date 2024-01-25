module jal_addr (pc,inst,addr); // 32-bit jal address
    input  [31:0] pc,inst;
    output [31:0] addr;

    // bit 31   30:21  20   19:12        11:7     6     0
    // imm[20 | 10:1 | 11 | 19:12]        rd      1101111 | jal    rd,  offset[20:1]

    //                            31:20         19:12       11       10:1      0
    wire   [31:0] offset = {{12{inst[31]}},inst[19:12],inst[20],inst[30:21],1'b0}; // jal
    assign addr = pc + offset;
endmodule
