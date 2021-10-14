/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module scdatamem_i2c_eeprom (clk,addr,dm_in,write,dm_out);
    input         clk;                              // clock
    input         write;                            // data memory write
    input  [31:0] addr;                             // data memory address
    input  [31:0] dm_in;                            // data memory data in
    output [31:0] dm_out;                           // data memory data out
    reg    [31:0] ram [63:0];                       // 256B, high end: stack
    assign dm_out = ram[addr[7:2]];
    always @(posedge clk)
        if (write) ram[addr[7:2]] <= dm_in;
    initial begin
        ram[4'h0] = 32'b01000011011011110110110101110000;
        ram[4'h1] = 32'b01110101011101000110010101110010;
        ram[4'h2] = 32'b00100000010100000111001001101001;
        ram[4'h3] = 32'b01101110011000110110100101110000;
        ram[4'h4] = 32'b01101100011001010111001100100000;
        ram[4'h5] = 32'b01100001011011100110010000100000;
        ram[4'h6] = 32'b01000100011001010111001101101001;
        ram[4'h7] = 32'b01100111011011100010000001101001;
        ram[4'h8] = 32'b01101110001000000101011001100101;
        ram[4'h9] = 32'b01110010011010010110110001101111;
        ram[4'ha] = 32'b01100111001000000100100001000100;
        ram[4'hb] = 32'b01001100000000000000000000000000;
        ram[4'hc] = 32'b00000000000000000000000000000000;
        ram[4'hd] = 32'b00000000000000000000000000000000;
        ram[4'he] = 32'b00000000000000000000000000000000;
        ram[4'hf] = 32'b00000000000000000000000000000000;
    end
endmodule
