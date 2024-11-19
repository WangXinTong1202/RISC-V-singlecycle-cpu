module dff32 (d,clk,clrn,q);               // a 32-bit register
    input      [31:0] d;                   // input d
    input             clk, clrn;           // clock and reset
    output reg [31:0] q;                   // output q
    always @(negedge clrn or posedge clk)  // always statement
        if (!clrn) q <= 0;                 // q = 0 if reset
        else       q <= d;                 // save d
endmodule
