module pl_stage_if(pcsrc, pc, bra, jalra, jala, npc, p4, ins);
    input  [31:0] pc, bra, jalra, jala;
    input  [1:0] pcsrc; 
    output [31:0] npc, p4, ins;

    pc4 pc4(
        .pc   (pc ),
        .p4   (p4 )
    );

    mux4x32 mux4x32(
        .a0   (p4         ),
        .a1   (bra         ),
        .a2   (jalra       ),
        .a3   (jala        ),
        .s    (pcsrc       ),
        .y    (npc         ) 
    ); 

    pl_instmem pl_instmem(
        .a    (pc           ),
        .inst (ins          ) 
    );
    
endmodule