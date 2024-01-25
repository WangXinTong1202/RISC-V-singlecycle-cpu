module sc_cu (opcode,func7,func3,aluc,alui,pcsrc,m2reg,bimm,call,wreg,wmem,z);
    input  [6:0] opcode;
    input  [6:0] func7;
    input  [2:0] func3;
    input        z;
   
    output [4:0] aluc;
    output [1:0] alui;
    output [1:0] pcsrc;
    output       m2reg;
    output       bimm;
    output       call;
    output       wreg;
    output       wmem;

    // instruction decode
    //RV32I
    wire i_lui   = (opcode == 7'b0110111);
    wire i_jal   = (opcode == 7'b1101111); 
    wire i_jalr  = (opcode == 7'b1100111) & (func3 == 3'b000);
    wire i_beq   = (opcode == 7'b1100011) & (func3 == 3'b000); 
    wire i_bne   = (opcode == 7'b1100011) & (func3 == 3'b001); 
    wire i_lw    = (opcode == 7'b0000011); 
    wire i_sw    = (opcode == 7'b0100011); 
    wire i_addi  = (opcode == 7'b0010011) & (func3 == 3'b000); 
    wire i_xori  = (opcode == 7'b0010011) & (func3 == 3'b100); 
    wire i_ori   = (opcode == 7'b0010011) & (func3 == 3'b110); 
    wire i_andi  = (opcode == 7'b0010011) & (func3 == 3'b111); 
    wire i_slli  = (opcode == 7'b0010011) & (func3 == 3'b001) & (func7 == 7'b0000000);
    wire i_srli  = (opcode == 7'b0010011) & (func3 == 3'b101) & (func7 == 7'b0000000); 
    wire i_srai  = (opcode == 7'b0010011) & (func3 == 3'b101) & (func7 == 7'b0100000); 
    wire i_add   = (opcode == 7'b0110011) & (func3 == 3'b000) & (func7 == 7'b0000000); 
    wire i_sub   = (opcode == 7'b0110011) & (func3 == 3'b000) & (func7 == 7'b0100000); 
    wire i_slt   = (opcode == 7'b0110011) & (func3 == 3'b010) & (func7 == 7'b0000000); 
    wire i_xor   = (opcode == 7'b0110011) & (func3 == 3'b100) & (func7 == 7'b0000000); 
    wire i_or    = (opcode == 7'b0110011) & (func3 == 3'b110) & (func7 == 7'b0000000); 
    wire i_and   = (opcode == 7'b0110011) & (func3 == 3'b111) & (func7 == 7'b0000000); 
   //RV32M
    wire i_mul     = (opcode == 7'b0110011) & (func3 == 3'b000) & (func7 == 7'b0000001);
    wire i_mulh    = (opcode == 7'b0110011) & (func3 == 3'b001) & (func7 == 7'b0000001);
    wire i_mulhsu  = (opcode == 7'b0110011) & (func3 == 3'b010) & (func7 == 7'b0000001);
    wire i_mulhu   = (opcode == 7'b0110011) & (func3 == 3'b011) & (func7 == 7'b0000001);
    wire i_div     = (opcode == 7'b0110011) & (func3 == 3'b100) & (func7 == 7'b0000001);
    wire i_divu    = (opcode == 7'b0110011) & (func3 == 3'b101) & (func7 == 7'b0000001);
    wire i_rem     = (opcode == 7'b0110011) & (func3 == 3'b110) & (func7 == 7'b0000001);
    wire i_remu    = (opcode == 7'b0110011) & (func3 == 3'b111) & (func7 == 7'b0000001);
           
   // control signals
    assign aluc[0]  = (i_jal  | i_jalr) ? 1'bx : (i_sub  | i_xori | i_xor  | i_andi | i_slli | i_srli | i_srai |
                                                  i_and  | i_beq | i_rem | i_remu | i_mulhsu); 
    assign aluc[1]  = (i_jal  | i_jalr) ? 1'bx : (i_slt  | i_xori | i_xor  | i_slli | i_srli | i_srai | i_lui  | 
                                                  i_bne | i_mulhu); 
    assign aluc[2]  = (i_jal  | i_jalr) ? 1'bx : (i_ori  | i_or   | i_and  | i_andi | i_srli | i_srai | i_lui | 
                                                  i_div | i_rem | i_remu) ; 
    assign aluc[3]  = (i_jal  | i_jalr) ? 1'bx : (i_xori | i_xor  | i_srai | i_bne  | i_beq | 
                                                  i_mul | i_div | i_rem | i_divu | i_remu) ;
    assign aluc[4]  = (i_jal  | i_jalr | i_lui | i_xori | i_ori | i_andi | i_slli | i_srli | i_srai | i_xor |
                       i_or | i_and | i_div) ? 1'bx : (i_divu | i_remu | i_mulh | i_mulhsu | i_mulhu);
    assign m2reg    = i_lw;
    assign wmem     = i_sw;
    assign wreg     = i_lui  | i_jal  | i_jalr | i_lw   | i_addi | i_xori | i_ori  | i_andi | i_slli | i_srli | 
                      i_srai | i_add  | i_sub  | i_slt  | i_xor  | i_or   | i_and  | i_divu | i_remu | i_mulh | 
                      i_mulhsu | i_mulhu | i_div | i_rem;                                                                                                        
    assign call     = i_jal  | i_jalr;
    assign alui[0]  = i_slli | i_srli | i_srai | i_lui; 
    assign alui[1]  = i_lui  | i_sw ;
    assign bimm     = i_addi | i_xori | i_ori  | i_andi | i_slli | i_srli | i_srai | i_lw | i_sw | i_lui; 
    assign pcsrc[0] = i_jal | (i_beq && z) | (i_bne && ~z);
    assign pcsrc[1] = i_jal | i_jalr;

endmodule












