module pl_stage_wb (wal,wm,wm2reg,wres);
    input  [31:0] wal, wm;
    input  wm2reg;
    output [31:0] wres;

    mux2x32 mux2x32(
        .a0   (wal         ),
        .a1   (wm          ),
        .s    (wm2reg      ),
        .y    (wres        ) 
    );

endmodule