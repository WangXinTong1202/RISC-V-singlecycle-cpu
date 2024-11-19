module pl_reg_mw (mwreg,mm2reg,mm,mal,mrd,clk,clrn,
                  wwreg,wm2reg,wm,wal,wrd);
    input  [31:0] mm, mal;
    input  [4:0] mrd;
    input  mwreg, mm2reg, clk, clrn;
    output reg [31:0] wm, wal;
    output reg [4:0] wrd;
    output reg wwreg, wm2reg;

    always @(posedge clk or negedge clrn)
    begin
        if(!clrn)
        begin
            wm      <= 32'b0;
            wal     <= 32'b0;
            wrd     <= 5'b0;
            wwreg   <= 1'b0;
            wm2reg  <= 1'b0;
        end

        else
        begin
            wm      <= mm;
            wal     <= mal;
            wrd     <= mrd;
            wwreg   <= mwreg;
            wm2reg  <= mm2reg;
        end 
    end
endmodule           