module pl_stage_exe(ea,eb,epc4,ealuc,ecall,eal);
    input  [31:0] ea, eb, epc4;
    input  [4:0] ealuc;
    input  ecall;
    output [31:0] eal;

    wire [31:0] ealu;
    alu u_alu(
        .a     (ea          ),
        .b     (eb          ),
        .aluc  (ealuc       ),
        .r     (ealu        )
    );

    mux2x32 mux2x32(
        .a0   (ealu        ),
        .a1   (epc4        ),
        .s    (ecall       ),
        .y    (eal         ) 
    );

endmodule