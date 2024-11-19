module sc_instmem (a,inst);
    input  [31:0] a;
    output [31:0] inst;
    wire   [31:0] rom [0:31];                                 // (pc)
    assign rom[5'h00] = 32'b00000000000000000000000010110111; // (00) main:   lui  x1, 0         # x1 <- 0
    assign rom[5'h01] = 32'b00000101000000001110001000010011; // (04)         ori  x4, x1, 80    # x1 <- 80
    assign rom[5'h02] = 32'b00000000010000000000001010010011; // (08)         addi x5, x0,  4    # x5 <- 4
    assign rom[5'h03] = 32'b00000101100000000000000011101111; // (0c) call:   jal  x1, sum       # x1 <- 0x10 (return address), call sum
    assign rom[5'h04] = 32'b00000000011000100010000000100011; // (10)         sw   x6, 0(x4)     # memory[x4+0] <- x6
    assign rom[5'h05] = 32'b00000000000000100010010010000011; // (14)         lw   x9, 0(x4)     # x6 <- memory[x4+0]
    assign rom[5'h06] = 32'b01000000010001001000010000110011; // (18)         sub  x8, x9, x4    # x8 <- x9 - x4
    assign rom[5'h07] = 32'b00000000001100000000001010010011; // (1c)         addi x5, x0,  3    # x5 <- 3
    assign rom[5'h08] = 32'b11111111111100101000001010010011; // (20) loop2:  addi x5, x5, -1    # x5 <- x5 - 1
    assign rom[5'h09] = 32'b11111111111100101110010000010011; // (24)         ori  x8, x5, 0xfff # x8 <- x5 | 0xffffffff = 0xffffffff
    assign rom[5'h0a] = 32'b01010101010101000100010000010011; // (28)         xori x8, x8, 0x555 # x8 <- x8 ^ 0x00000555 = 0xfffffaaa
    assign rom[5'h0b] = 32'b11111111111100000000010010010011; // (2c)         addi x9, x0, -1    # x9 <- 0xffffffff
    assign rom[5'h0c] = 32'b11111111111101001111010100010011; // (30)         andi x10,x9, 0xfff # x10<- x9 & 0xffffffff = 0xffffffff
    assign rom[5'h0d] = 32'b00000000100101010110001000110011; // (34)         or   x4, x10, x9   # x4 <- x10 | x9 = 0xffffffff
    assign rom[5'h0e] = 32'b00000000100101010100010000110011; // (38)         xor  x8, x10, x9   # x8 <- x10 ^ x9 = 0x00000000
    assign rom[5'h0f] = 32'b00000000010001010111001110110011; // (3c)         and  x7, x10, x4   # x7 <- x10 & x4 = 0xffffffff
    assign rom[5'h10] = 32'b00000000000000101000010001100011; // (40)         beq  x5, x0, shift # if x5 = 0, goto shift
    assign rom[5'h11] = 32'b11111101110111111111000001101111; // (44)         jal  x0, loop2     # jump loop2
    assign rom[5'h12] = 32'b11111111111100000000001010010011; // (48) shift:  addi x5, x0, -1    # x5 <- 0xffffffff
    assign rom[5'h13] = 32'b00000000111100101001010000010011; // (4c)         slli x8, x5, 15    # x8 <- 0xffffffff <<  15 = 0xffff8000
    assign rom[5'h14] = 32'b00000001000001000001010000010011; // (50)         slli x8, x8, 16    # x8 <- 0xffff8000 <<  16 = 0x80000000
    assign rom[5'h15] = 32'b01000001000001000101010000010011; // (54)         srai x8, x8, 16    # x8 <- 0x80000000 >>> 16 = 0xffff8000
    assign rom[5'h16] = 32'b00000000111101000101010000010011; // (58)         srli x8, x8, 15    # x8 <- 0xffff8000 >>  15 = 0x0001ffff
    assign rom[5'h17] = 32'b00000000011000100010000110110011; // (5c)         slt  x3, x4, x6    # x3 <- 0xffffffff < 0x000002ff = 1
    assign rom[5'h18] = 32'b00000000000000000000000001101111; // (60) finish: jal  x0, finish    # dead loop
    assign rom[5'h19] = 32'b00000000000000000000001100110011; // (64) sum:    add  x6, x0, x0    # x6 <- 0 (subroutine entry)
    assign rom[5'h1a] = 32'b00000000000000100010010010000011; // (68) loop:   lw   x9, 0(x4)     # x9 <- memory[x4+0]
    assign rom[5'h1b] = 32'b00000000010000100000001000010011; // (6c)         addi x4, x4,  4    # x4 <- x4 + 4 (address+4)
    assign rom[5'h1c] = 32'b00000000100100110000001100110011; // (70)         add  x6, x6, x9    # x6 <- x6 + x9 (sum)
    assign rom[5'h1d] = 32'b11111111111100101000001010010011; // (74)         addi x5, x5, -1    # x5 <- x5 - 1 (counter--)
    assign rom[5'h1e] = 32'b11111110000000101001100011100011; // (78)         bne  x5, x0, loop  # if x5 != 0, goto loop
    assign rom[5'h1f] = 32'b00000000000000001000000001100111; // (7c)         ret  x1            # return from subroutine
    assign inst = rom[a[6:2]];
endmodule
