module mux4x32 (a0,a1,a2,a3,s,y);
    input  [31:0] a0, a1, a2, a3;
    input   [1:0] s;
    output [31:0] y;
    assign y  = s[1] ? (s[0] ? a3 : a2) : (s[0] ? a1 : a0);
    //     s[1:0]:              11   10            01   00
    //                        jala   jalra        bra   p4
endmodule
