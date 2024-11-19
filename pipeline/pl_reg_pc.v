module pl_reg_pc(npc, clk, clrn, pc, wpcir);
    input  [31:0] npc;
    input  clk, clrn;
    input  wpcir;
    output reg [31:0] pc;

    always @(posedge clk or negedge clrn)
    begin
        if (!clrn)
        begin
            pc <= 32'b0;
        end
        else
        begin
            if(wpcir)
                begin
                pc <=npc;
                end
        end
    end

endmodule