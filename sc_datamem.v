module sc_datamem (addr,datain,we,clk,dataout); // data memory, ram
    input         clk;                   // clock
    input         we;                    // write enable
    input  [31:0] datain;                // data in (to memory)
    input  [31:0] addr;                  // ram address
    output [31:0] dataout;               // data out (from memory)
    reg    [31:0] ram [0:31];            // ram cells: 32 words * 32 bits
    assign dataout = ram[addr[6:2]];     // use word address to read ram
    always @ (posedge clk)
        if (we) ram[addr[6:2]] = datain; // use word address to write ram
    integer i;
    initial begin                        // initialize memory
        for (i = 0; i < 32; i = i + 1)
            ram[i] = 0;
        // ram[word_addr] = data         // (byte_addr) item in data array
        ram[5'h14] = 32'h000000f2;       // (50)  data[0]
        ram[5'h15] = 32'h0000000e;       // (54)  data[1]
        ram[5'h16] = 32'h00000200;       // (58)  data[2]
        ram[5'h17] = 32'hffffffff;       // (5c)  data[3]
        // ram[5'h18] the sum stored by sw instruction
    end
endmodule
