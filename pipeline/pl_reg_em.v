module pl_reg_em(ewreg,em2reg,ewmem,eal,ed,erd,clk,clrn,
                 mwreg,mm2reg,mwmem,mal,md,mrd);
    input  [31:0] eal, ed;
    input  [4:0] erd;
    input  ewreg, em2reg, ewmem, clk, clrn;
    output reg [31:0] md, mal;
    output reg [4:0] mrd;
    output reg mwreg, mm2reg, mwmem;

    always @(posedge clk or negedge clrn)
    begin
        if(!clrn)
        begin
            md     <= 32'b0;
            mal    <= 32'b0;
            mrd    <= 5'b0;
            mwreg  <= 1'b0;
            mm2reg <= 1'b0;
            mwmem  <= 1'b0;
        end

        else
        begin 
            md     <= ed;
            mal    <= eal;
            mrd    <= erd;
            mwreg  <= ewreg;
            mm2reg <= em2reg;
            mwmem  <= ewmem;
        end
    end
endmodule            

    