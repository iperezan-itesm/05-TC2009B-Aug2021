/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module rand3 (clk,clrn,q);                          // a 3-bit random number
    input        clk, clrn;                         // clock and reset
    output [2:0] q;                                 // output q
    reg    [2:0] q;                                 // register
    always @ (posedge clk or negedge clrn)
        if (!clrn) q <= 0;                          // q = 0 if reset
        else       q <= q + 3'd1;                   // q++
endmodule
