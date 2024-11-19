module regfile (rna,rnb,d,wn,we,clk,clrn,qa,qb); // 32x32 regfile
    input  [31:0] d;                             // data of write port
    input   [4:0] rna;                           // reg # of read port A
    input   [4:0] rnb;                           // reg # of read port B
    input   [4:0] wn;                            // reg # of write port
    input         we;                            // write enable
    input         clk, clrn;                     // clock and reset
    output [31:0] qa, qb;                        // read ports A and B
    reg    [31:0] register [0:31];               // 32 32-bit registers
    assign qa = (rna == 0)? 0 : register[rna];   // read port A
    assign qb = (rnb == 0)? 0 : register[rnb];   // read port B
    always @(negedge clk or negedge clrn)        // write port
        if (!clrn) begin
            register[00]  <= 0;                  // reset
            register[01]  <= 0;                  // reset
            register[02]  <= 0;                  // reset
            register[03]  <= 0;                  // reset
            register[04]  <= 0;                  // reset
            register[05]  <= 0;                  // reset
            register[06]  <= 0;                  // reset
            register[07]  <= 0;                  // reset
            register[08]  <= 0;                  // reset
            register[09]  <= 0;                  // reset
            register[10]  <= 0;                  // reset
            register[11]  <= 0;                  // reset
            register[12]  <= 0;                  // reset
            register[13]  <= 0;                  // reset
            register[14]  <= 0;                  // reset
            register[15]  <= 0;                  // reset
            register[16]  <= 0;                  // reset
            register[17]  <= 0;                  // reset
            register[18]  <= 0;                  // reset
            register[19]  <= 0;                  // reset
            register[20]  <= 0;                  // reset
            register[21]  <= 0;                  // reset
            register[22]  <= 0;                  // reset
            register[23]  <= 0;                  // reset
            register[24]  <= 0;                  // reset
            register[25]  <= 0;                  // reset
            register[26]  <= 0;                  // reset
            register[27]  <= 0;                  // reset
            register[28]  <= 0;                  // reset
            register[29]  <= 0;                  // reset
            register[30]  <= 0;                  // reset
            register[31]  <= 0;                  // reset
        end else begin
            if ((wn != 0) && we)                 // not reg[0] & enabled
                register[wn] <= d;               // write d to reg[wn]
                register[00] <= 0;               // x0 = 0
        end
endmodule
