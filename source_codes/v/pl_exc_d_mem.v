/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module pl_exc_d_mem (clk,dataout,datain,addr,we); // data memory, ram
    input         clk;                     // clock
    input         we;                      // write enable
    input  [31:0] datain;                  // data in (to memory)
    input  [31:0] addr;                    // ram address
    output [31:0] dataout;                 // data out (from memory)
    reg    [31:0] ram [0:31];              // ram cells: 32 words * 32 bits
    assign dataout = ram[addr[6:2]];       // use 6-bit word address
    always @ (posedge clk) begin
        if (we) ram[addr[6:2]] = datain;   // write ram
    end
    integer i;
    initial begin                          // ram initialization
        for (i = 0; i < 32; i = i + 1)
            ram[i] = 0;
        // ram[word_addr] = data           // (byte_addr) item in data array
        ram[5'h08] = 32'h00000030;         // (20) 0. int_entry
        ram[5'h09] = 32'h0000003c;         // (24) 1. sys_entry
        ram[5'h0a] = 32'h00000054;         // (28) 2. uni_entry
        ram[5'h0b] = 32'h00000068;         // (2c) 3. ovr_entry
        ram[5'h12] = 32'h00000002;         // (48) for testing overflow
        ram[5'h13] = 32'h7fffffff;         // (4c) 2 + max_int -> overflow
        ram[5'h14] = 32'h000000a3;         // (50) data[0]   0 +  a3 =  a3
        ram[5'h15] = 32'h00000027;         // (54) data[1]  a3 +  27 =  ca
        ram[5'h16] = 32'h00000079;         // (58) data[2]  ca +  79 = 143
        ram[5'h17] = 32'h00000115;         // (5c) data[3] 143 + 115 = 258
    end
endmodule
