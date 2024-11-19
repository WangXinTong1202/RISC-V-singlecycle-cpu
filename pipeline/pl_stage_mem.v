module pl_stage_mem (mwmem,mal,md,clk,mm);
    input  [31:0] mal,md;
    input  mwmem, clk;
    output [31:0] mm;

    pl_datamem pl_datamem(
        .addr   (mal       ),
        .datain (md        ),
        .we     (mwmem     ),
        .clk    (clk       ),
        .dataout(mm        )
    );

endmodule