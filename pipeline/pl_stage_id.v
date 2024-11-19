module pl_stage_id (mrd,mm2reg,mwreg,erd,em2reg,ewreg,dpc,inst,eal,mal,mm,
                    wrd,wres,wwreg,clk,clrn,bra,jalra,jala,pcsrc,wreg,
                    m2reg,wmem,call,aluc,da,db,dd,wpcir);
    input  [31:0] inst, dpc, wres;
    input         clk, clrn, wwreg;
    input  [4:0]  mrd;
    input         mm2reg;
    input         mwreg;
    input         em2reg;
    input  [4:0]  wrd;
    input  [4:0]  erd;
    input         ewreg;
    input  [31:0] eal;
    input  [31:0] mal;
    input  [31:0] mm;


    output [31:0] bra, jalra, jala, da, db, dd;
    output [4:0] aluc;
    output [1:0] pcsrc;
    output wreg, m2reg, wmem ,call;
    output wpcir;
    
    wire [4:0] rd= inst[11:7];
    wire [31:0] qa;
    wire [31:0] qb;
    regfile regfile(
        .qa   (qa          ), 
        .qb   (qb          ),
        .rna  (inst[19:15]),
        .rnb  (inst[24:20]),
        .wn   (wrd        ),
        .d    (wres        ), 
        .clk  (clk         ),
        .clrn (clrn        ),
        .we   (wwreg       )
    );

    branch_addr branch_addr(
        .pc   (dpc          ),
        .inst (inst         ),
        .addr (bra          ) 
    );

    jal_addr jal_addr(
        .pc   (dpc         ),
        .inst (inst        ),
        .addr (jala        ) 
    );

    jalr_addr jalr_addr(
        .rs1  (da          ),
        .inst (inst        ),
        .addr (jalra       ) 
    ); 
    
    wire z;
    equ equ(
        .qa   (da           ),
        .qb   (dd           ),
        .z    (z            )
    ); 

    wire [1:0] alui;
    wire [31:0] imm;
    imme imme(
        .inst (inst        ),
        .alui (alui        ),
        .imm  (imm         ) 
    );

    wire bimm;
    mux2x32 mux2x32(
        .a0   (dd          ),
        .a1   (imm         ),
        .s    (bimm        ),
        .y    (db          ) 
    );

    wire [1:0] fwda;
    wire [1:0] fwdb;
    pl_cu pl_cu(
        .opcode(inst[6:0]   ), 
        .func7 (inst[31:25] ), 
        .func3 (inst[14:12] ), 
        .z     (z           ),
        .aluc  (aluc        ), 
        .alui  (alui        ), 
        .pcsrc (pcsrc       ), 
        .m2reg (m2reg       ), 
        .bimm  (bimm        ),  
        .call  (call        ),
        .wreg  (wreg        ),
        .wmem  (wmem        ),
        .mrd   (mrd         ),
        .mm2reg(mm2reg      ),
        .mwreg (mwreg       ),
        .erd   (erd         ),
        .em2reg(em2reg      ),
        .ewreg (ewreg       ),
        .rs1   (inst[19:15] ),
        .rs2   (inst[24:20] ),
        .fwda  (fwda        ),
        .fwdb  (fwdb        ),
        .wpcir (wpcir       )
    );

    mux4x32 mux4x32_u1(
        .a0   (qa          ),
        .a1   (eal         ),
        .a2   (mal         ),
        .a3   (mm          ),
        .s    (fwda        ),
        .y    (da          ) 
    ); 

    mux4x32 mux4x32_u2(
        .a0   (qb          ),
        .a1   (eal         ),
        .a2   (mal         ),
        .a3   (mm          ),
        .s    (fwdb        ),
        .y    (dd          ) 
    ); 

endmodule
