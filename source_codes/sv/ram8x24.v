/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module ram8x24 (address,data,clk,we,q);     // ram for tlb
    input   [2:0] address;                  // address
    input  [23:0] data;                     // data in
    input         clk;                      // clock
    input         we;                       // write enable
    output [23:0] q;                        // data out
    reg    [23:0] ram [0:7];                // ram cells: 8 words * 24 bits
    always @(posedge clk) begin
        if (we) ram[address] <= data;       // write ram
    end
    assign q = ram[address];                // read ram
    integer i;
    initial begin
        for (i = 0; i < 8; i = i + 1)
            ram[i] = 24'h0;                 // initialization
    end
endmodule
