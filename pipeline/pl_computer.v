module pl_computer(clk,clrn,pc,inst,eal,mal,wres);
    input         clk;
    input         clrn;
    output [31:0] pc;
    output [31:0] inst;
    output [31:0] eal;
    output [31:0] mal;
    output [31:0] wres;

// IF stage
    wire [31:0] bra;
    wire [31:0] jalra;
    wire [31:0] jala;
    wire [1:0]  pcsrc; 
    wire [31:0] npc;
    wire [31:0] p4;
    wire [31:0] dpc4;
    wire [31:0] ins;

// ID stage
    wire [31:0] dpc;
    wire wwreg;
    wire [31:0] da;
    wire [31:0] db;
    wire [31:0] dd;
    wire [4:0] aluc;
    wire [4:0] rd = inst[11:7]; 
    wire wreg;
    wire m2reg;
    wire wmem;
    wire call;
    wire wpcir;

// EXE stage
    wire [31:0] ea;
    wire [31:0] eb;
    wire [31:0] ed;
    wire [31:0] epc4;
    wire [4:0] ealuc;
    wire ecall;
    wire [31:0] eal;
    wire [4:0] erd;

// MEM stage
    wire [31:0] md;
    wire mwmem;
    wire [31:0] mm;
    wire [4:0] mrd;

// WB stage
    wire [31:0] wm;
    wire [31:0] wal;
    wire wm2reg;
    wire [4:0] wrd;

    pl_reg_pc prog_cnt (npc, clk, clrn, pc, wpcir);
    pl_stage_if if_stage (pcsrc, pc, bra, jalra, jala, npc, p4, ins);
    pl_reg_ir fd_reg (pc, p4, ins, clk, clrn, dpc, dpc4, inst, wpcir);
    pl_stage_id id_stage (mrd,mm2reg,mwreg,erd,em2reg,ewreg,dpc,inst,eal,mal,mm,
                          wrd,wres,wwreg,clk,clrn,bra,jalra,jala,pcsrc,wreg,
                          m2reg,wmem,call,aluc,da,db,dd,wpcir);
    pl_reg_de de_reg (wreg,m2reg,wmem,call,aluc,rd,dpc4,da,db,dd,clk,clrn,
                    ewreg,em2reg,ewmem,ecall,ealuc,erd,epc4,ea,eb,ed);
    pl_stage_exe exe_stage(ea,eb,epc4,ealuc,ecall,eal);
    pl_reg_em em_reg (ewreg,em2reg,ewmem,eal,ed,erd,clk,clrn,
                    mwreg,mm2reg,mwmem,mal,md,mrd);
    pl_stage_mem mem_stage (mwmem,mal,md,clk,mm);
    pl_reg_mw mw_reg (mwreg,mm2reg,mm,mal,mrd,clk,clrn,
                      wwreg,wm2reg,wm,wal,wrd);
    pl_stage_wb wb_stage (wal,wm,wm2reg,wres);
endmodule
