`timescale 1ns / 1ps 
module sc_cpu(clk,clrn,instr,mem,pc,alu,data,wmem);
    input  [31:0] instr, mem;
    input  clk, clrn;
    output [31:0] pc, alu, data;
    output wmem;
    
    wire [31:0] npc;
    dff32 dff32(
        .d    (npc ), 
        .clk  (clk ),
        .clrn (clrn),
        .q    (pc  )
    );
    
    wire [31:0] p4;
    pc4 pc4(
        .pc   (pc ),
        .p4   (p4 )
    );
    
    wire [31:0] d, a, data;
    wire wreg;
    regfile regfile(
        .qa   (a           ), 
        .qb   (data        ),
        .rna  (instr[19:15]),
        .rnb  (instr[24:20]),
        .wn   (instr[11:7 ]),
        .d    (d           ), 
        .clk  (clk         ),
        .clrn (clrn        ),
        .we   (wreg        )
    );
    
    wire [31:0] res;
    wire call;
    mux2x32 u1_mux2x32(
        .a0   (res         ),
        .a1   (p4          ),
        .s    (call        ),
        .y    (d           ) 
    );
    
    wire m2reg, bimm, wmem, z;
    wire [4:0] aluc;
    wire [1:0] alui, pcsrc;
    sc_cu sc_cu(
        .opcode(instr[6:0]  ), 
        .func7 (instr[31:25]), 
        .func3 (instr[14:12]), 
        .z     (z           ),
        .aluc  (aluc        ), 
        .alui  (alui        ), 
        .pcsrc (pcsrc       ), 
        .m2reg (m2reg       ), 
        .bimm  (bimm        ),  
        .call  (call        ),
        .wreg  (wreg        ),
        .wmem  (wmem        )
    );
    
    wire [31:0] alub;
    alu u_alu(
        .a     (a           ),
        .b     (alub        ),
        .aluc  (aluc        ),
        .r     (alu         ),
        .z     (z     ) 
    );
    
    wire [31:0] imm;
    mux2x32 u2_mux2x32(
        .a0   (data        ),
        .a1   (imm         ),
        .s    (bimm        ),
        .y    (alub        ) 
    );
    
    imme imme(
        .inst (instr       ),
        .alui (alui        ),
        .imm  (imm         ) 
    );
    
    mux2x32 u3_mux2x32(
        .a0   (alu         ),
        .a1   (mem         ),
        .s    (m2reg       ),
        .y    (res         ) 
    );
    
    wire [31:0] bra;
    branch_addr branch_addr(
        .pc   (pc          ),
        .inst (instr       ),
        .addr (bra         ) 
    );
    
    wire [31:0] jalra;
    jalr_addr jalr_addr(
        .rs1  (a           ),
        .inst (instr       ),
        .addr (jalra       ) 
    ); 
    
    wire [31:0] jala;  
    jal_addr jal_addr(
        .pc   (pc          ),
        .inst (instr       ),
        .addr (jala        ) 
    );
    
    mux4x32 mux4x32(
        .a0   (p4          ),
        .a1   (bra         ),
        .a2   (jalra       ),
        .a3   (jala        ),
        .s    (pcsrc       ),
        .y    (npc         ) 
    );    
    
endmodule
