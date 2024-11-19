module pl_reg_ir(pc, p4, ins, clk, clrn, dpc, dpc4, inst, wpcir);
    input  [31:0] pc, p4, ins;
    input  clk, clrn;
    input  wpcir;
    output reg [31:0] inst, dpc, dpc4;

    always @(posedge clk or negedge clrn)
    begin
        if (!clrn)
        begin
            dpc4   <= 32'b0;
            dpc    <= 32'b0;
            inst   <= 32'b0;
        end
        else
        begin
            if(wpcir)
            begin
                inst   <= ins;
                dpc    <= pc;
                dpc4   <= p4;
            end
        end
    end
endmodule  