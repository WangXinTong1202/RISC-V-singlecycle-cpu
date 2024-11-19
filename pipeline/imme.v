module imme (inst,alui,imm); // 32-bit immediate
    input   [1:0] alui;
    input  [31:0] inst;
    output [31:0] imm;

    // alui[1:0]:
    //      0 0 : imm[11:0]         : addi, xori, ori, andi, lw
    //      0 1 : shamt             : slli, srli, srai
    //      1 0 : imm[11:5],imm[4:0]: sw
    //      1 1 : imm[31:12]        : lui

    //            31::::25 24:20 19:15 14:12 11:7    6:::::0
    //      0 0 : imm[11:::::::0] rs1   000   rd     0010011
    //      0 1 : 0000000  shamt  rs1   001   rd     0010011
    //      1 0 : imm[11:5] rs2   rs1   010 imm[4:0] 0100011
    //      1 1 : imm[31::::::::::::::::::12] rd     0110111

    function [31:0] get_imm;
        input [31:0] inst;
        input  [1:0] alui;
        case(alui)
            2'b00: get_imm = {{21{inst[31]}},inst[30:20]};            // addi, xori, ori, andi, lw
            2'b01: get_imm = {27'b0,         inst[24:20]};            // slli, srli, srai
            2'b10: get_imm = {{21{inst[31]}},inst[30:25],inst[11:7]}; // sw
            2'b11: get_imm = {inst[31:12],12'b0};                     // lui
        endcase
    endfunction

    assign imm = get_imm(inst,alui);

endmodule
