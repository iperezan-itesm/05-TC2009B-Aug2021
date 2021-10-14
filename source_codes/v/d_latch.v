/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module d_latch (c,d,q,qn);                          // d latch
    input  c, d;                                    // inputs:  c, d
    output q, qn;                                   // outputs: q, qn
    wire   r, s;                                    // internal wires
    nand nand1 (s,  d, c);                          // nand (out, in1, in2);
    nand nand2 (r, ~d, c);                          // nand (out, in1, in2);
    rs_latch rs (s, r, q, qn);                      // use rs_latch module
endmodule
