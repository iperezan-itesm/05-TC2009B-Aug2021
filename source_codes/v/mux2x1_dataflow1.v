/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module mux2x1_dataflow1 (a0, a1, s, y);       // multiplexer, dataflow style
    input  s, a0, a1;                         // inputs
    output y;                                 // output
    assign y = ~s & a0 | s & a1;              // logic expression
endmodule
