// aluc[4:0]:
// 0 0 0 0 0  ADD 
// 0 0 0 0 1  SUB 
// 0 1 0 0 1  BEQ 
// 0 1 0 1 0  BNE
// 1 1 0 0 1  BLT
// 1 1 0 1 0  BGE
// 0 0 0 1 0  SLT 
// x 1 0 1 1  XOR
// x 0 1 0 0  OR 
// x 0 1 0 1  AND 
// x 0 0 1 1  SLL
// x 0 1 1 1  SRL 
// x 1 1 1 1  SRA 
// x 0 1 1 0  LUI 
// 0 1 0 0 0  MUL
// 1 0 0 0 0  MULH
// 1 0 0 0 1  MULHSU
// 1 0 0 1 0  MULHU
// x 1 1 0 0  DIV
// 0 1 1 0 1  REM
// 1 1 0 0 0  DIVU
// 1 1 1 0 1  REMU

// no operation:      jalr, jal

module alu (a, b, aluc, r, z);
    input  [31:0] a, b;
    input   [4:0] aluc;
    output [31:0] r;
    output        z;

    assign r = calc(a, b, aluc);
    assign z = ~|r; 

    function [31:0] calc;
        input [31:0] a, b;
        input [4:0] aluc;
        reg [31:0] sub;

        begin
            sub = a - b;
            casex(aluc)
                5'b00000: calc = a + b;                // ADD
                5'bx0001: calc = sub;                  // SUB
                5'b01001: if (a == b) calc = 32'b1;
                           else calc = 0;               // BEQ
                5'b01010: if (a != b) calc = 32'b1;
                           else calc = 0;               // BNE
                5'b11001: if (a < b) calc = 32'b1;
                           else calc = 0;               // BLT
                5'b11010: if (a > b) calc = 32'b1;
                           else calc = 0;               // BGE
                5'bx0010: calc = {31'b0, sub[31]};     // SLT
                5'bx1011: calc = a ^ b;                // XOR
                5'bx0100: calc = a | b;                // OR
                5'bx0101: calc = a & b;                // AND
                5'bx0011: calc = a << b[4:0];          // SLL
                5'bx0111: calc = a >> b[4:0];          // SRL
                5'bx1111: calc = $signed(a) >>> b[4:0]; // SRA
                5'bx0110: calc = b;                    // LUI
                5'b01000: calc = $signed(a) * $signed(b);  // MUL
                5'bx1100: calc = $signed($signed(a) / $signed(b));  // DIV
                5'b01101: calc = $signed($signed(a) % $signed(b));  // REM
                5'b10000: calc = $signed($signed(a) * $signed(b)) >>> 32;  // MULH
                5'b10001: calc = $signed($signed(a) * $signed({1'b0, b})) >>> 32;  // MULHSU
                5'b10010: calc = (a * b) >> 32;  // MULHU
                5'b11000: calc = a / b;                // DIVU
                5'b11101: calc = a % b;                // REMU
            endcase
        end
    endfunction
endmodule


