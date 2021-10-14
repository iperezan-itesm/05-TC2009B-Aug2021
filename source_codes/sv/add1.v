/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module add1 (a,b,ci,s,co);                   // full adder, dataflow style
    input  a, b, ci;                         // inputs:  a, b, carry_in
    output s, co;                            // outputs: sum, carry_out
    assign s  = a ^ b ^ ci;                  // sum of inputs
    assign co = a & b | b & ci | ci & a;     // carry_out
endmodule
