/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module pl_data_mem (clk,dataout,datain,addr,we); // data memory, ram
    input         clk;                     // clock
    input  [31:0] addr;                    // ram address
    input  [31:0] datain;                  // data in (to memory)
    input         we;                      // write enable
    output [31:0] dataout;                 // data out (from memory)
    reg    [31:0] ram [0:31];              // ram cells: 32 words * 32 bits
    assign dataout = ram[addr[6:2]];       // use 5-bit word address
    always @ (posedge clk) begin
        if (we) ram[addr[6:2]] = datain;   // write ram
    end
    integer i;
    initial begin                          // ram initialization
        for (i = 0; i < 32; i = i + 1)
            ram[i] = 0;
        // ram[word_addr] = data           // (byte_addr) item in data array
        ram[5'h14] = 32'h000000a3;         // (50) data[0]   0 +  a3 =  a3
        ram[5'h15] = 32'h00000027;         // (54) data[1]  a3 +  27 =  ca
        ram[5'h16] = 32'h00000079;         // (58) data[2]  ca +  79 = 143
        ram[5'h17] = 32'h00000115;         // (5c) data[3] 143 + 115 = 258
        // ram[5'h18] should be 0x00000258, the sum stored by sw instruction
    end
endmodule
