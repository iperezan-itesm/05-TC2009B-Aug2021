/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module rs_latch (s,r,q,qn);                         // rs latch
    input  s, r;                                    // inputs:  set, reset
    output q, qn;                                   // outputs: q, qn
    nand nand1 (q,  s, qn);                         // nand (out, in1, in2);
    nand nand2 (qn, r, q);                          // nand (out, in1, in2);
endmodule
