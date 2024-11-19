module pl_reg_de(wreg,m2reg,wmem,call,aluc,rd,dpc4,da,db,dd,clk,clrn,
                ewreg,em2reg,ewmem,ecall,ealuc,erd,epc4,ea,eb,ed);
    input  [31:0] dpc4, da, db, dd;
    input  [4:0] rd;
    input  [4:0] aluc;
    input  wreg, m2reg, wmem, call, clk, clrn;
    output reg [31:0] epc4, ea, eb, ed;
    output reg [4:0] erd;
    output reg [4:0] ealuc;
    output reg ewreg, em2reg, ewmem, ecall;

    always @(posedge clk or negedge clrn)
        if(!clrn)
        begin
            epc4   <= 32'b0;
            ea     <= 32'b0;
            eb     <= 32'b0;
            ed     <= 32'b0;
            erd    <= 5'b0;
            ealuc  <= 4'b0;
            ewreg  <= 1'b0;
            em2reg <= 1'b0;
            ewmem  <= 1'b0;
            ecall  <= 1'b0;
        end

        else
        begin
            epc4   <= dpc4;
            ea     <= da;
            eb     <= db;
            ed     <= dd;
            erd    <= rd;
            ealuc  <= aluc;
            ewreg  <= wreg;
            em2reg <= m2reg;
            ewmem  <= wmem;
            ecall  <= call;  
        end
endmodule         
