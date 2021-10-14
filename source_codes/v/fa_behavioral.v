/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module fa_behavioral (a,b,ci,s,co);          // full adder, behavioral style
    input  a, b, ci;                         // inputs:  a, b, carry_in
    output s, co;                            // outputs: sum, carry_out
    assign {co,s} = a + b + ci;              // two-bit {co,s} output
endmodule
