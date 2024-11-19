module pl_cu (opcode,func7,func3,aluc,alui,pcsrc,m2reg,bimm,call,wreg,wmem,z,mrd,mm2reg,mwreg,erd,em2reg,ewreg,rs1,rs2,fwda,fwdb,wpcir); // sc control unit
    input  [6:0] opcode;
    input  [6:0] func7;
    input  [4:0] mrd;
    input  [4:0] erd;
    input  [2:0] func3;
    input  [4:0] rs1;
    input  [4:0] rs2;
    input        z;
    input        mm2reg;
    input        mwreg;
    input        em2reg;
    input        ewreg;
   
    output [4:0] aluc;
    output [1:0] alui;
    output [1:0] pcsrc;
    output reg [1:0] fwda;
    output reg [1:0] fwdb;
    output       m2reg;
    output       bimm;
    output       call;
    output       wreg;
    output       wmem;
    output       wpcir;

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
    assign aluc[0]  = wpcir&((i_jal  | i_jalr) ? 1'bx : (i_sub  | i_xori | i_xor  | i_andi | i_slli | i_srli | i_srai | i_and  | i_beq | i_rem | i_remu | i_mulhsu)); 
    assign aluc[1]  = wpcir&((i_jal  | i_jalr) ? 1'bx : (i_slt  | i_xori | i_xor  | i_slli | i_srli | i_srai | i_lui  | i_bne | i_mulhu)); 
    assign aluc[2]  = wpcir&((i_jal  | i_jalr) ? 1'bx : (i_ori  | i_or   | i_and  | i_andi | i_srli | i_srai | i_lui | i_div | i_rem | i_remu)) ; 
    assign aluc[3]  = wpcir&((i_jal  | i_jalr) ? 1'bx : (i_xori | i_xor  | i_srai | i_bne  | i_beq | i_mul | i_div | i_rem | i_divu | i_remu)) ;
    assign aluc[4]  = wpcir&((i_jal  | i_jalr) ? 1'bx : (i_divu | i_remu | i_mulh |i_mulhsu | i_mulhu));
    assign m2reg    = wpcir&i_lw;
    assign wmem     = wpcir&i_sw;
    assign wreg     = wpcir&(i_lui  | i_jal  | i_jalr | i_lw   | i_addi | i_xori | i_ori  | i_andi | i_slli | i_srli | i_srai | i_add  | i_sub  | i_slt  | i_xor  | i_or   | i_and) ;                                                                                                        
    assign call     = wpcir&(i_jal  | i_jalr );
    assign alui[0]  = i_slli | i_srli | i_srai | i_lui ; 
    assign alui[1]  = i_lui  | i_sw  ; 
    assign bimm     = i_addi | i_xori | i_ori  | i_andi | i_slli | i_srli | i_srai; 
    assign pcsrc[0] = i_jal | (i_beq && z) | (i_bne && ~z);
    assign pcsrc[1] = i_jal | i_jalr;
    assign wpcir    = ~(em2reg&((erd==rs1)|(erd==rs2)));

	always @(*)
	begin
	fwda <= 2'b00; 
	if(ewreg & ~em2reg &(erd!=0) & (erd==rs1)) 
		begin
			fwda <= 2'b01; //select exe_alu : ealu
		end
	else
		begin
		if(mwreg & (mrd!=0) & (mrd==rs1) &~mm2reg) 
			fwda <= 2'b10; //select mem_alu : malu
		else 
			begin 
				if(mwreg & (mrd!=0) & (mrd ==rs1)& mm2reg) 
					fwda <= 2'b11; //select mem_lw : mmo
			end
		end
	end
	
	always @(*)
	begin
	fwdb <= 2'b00; 
	if(ewreg & ~em2reg &(erd!=0) & (erd==rs2))
		begin
			fwdb <= 2'b01; //select exe_alu : ealu
		end
	else
		begin
		if(mwreg & (mrd!=0) & (mrd==rs2) &~mm2reg)
			fwdb <= 2'b10; //select mem_alu : malu
		else 
			begin
				if(mwreg & (mrd!=0) & (mrd ==rs2)& mm2reg)
					fwdb <= 2'b11; //select mem_lw : mmo
			end
		end
	end

endmodule