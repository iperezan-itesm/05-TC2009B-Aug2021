/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module demux1to8 (s,y,a);                 // 1-to-8 demultiplexer
    input  [2:0] s;                       // inputs:  s, dispatch control
    input        y;                       // input:   y, to be dispatched
    output [7:0] a;                       // outputs: only 1 bit's value = y
    assign a = (1 << s) & {8{y}};         // the value of (2^s)th bit = y
endmodule
