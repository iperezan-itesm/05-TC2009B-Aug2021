/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module clas16 (sub,a,b,ci,s);     // 16-bit carry lookahead adder/subtracter
    input         sub;                                 // 1: sub; 0: add
    input  [15:0] a, b;                                // inputs: a, b
    input         ci;                                  // active low for sub
    output [15:0] s;                                   // output: sum
    wire          g_out, p_out;                        // internal wires
    // cla_16  (a,b,          c_in,g_out,p_out,s);
    cla_16 cla (a,b^{16{sub}},ci,  g_out,p_out,s);     // use cla_16 module
endmodule
