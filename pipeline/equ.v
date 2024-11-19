module equ (qa, qb, z);
    input [31:0] qa, qb;
    output z;

    assign z = (qa == qb);


endmodule

