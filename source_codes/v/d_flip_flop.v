/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module d_flip_flop (clk,d,q,qn);                    // dff using 2 d latches
    input  clk, d;                                  // inputs:  clk, d
    output q,  qn;                                  // outputs: q, qn
    wire   q0, qn0;                                 // internal wires
    wire   clkn, clknn;                             // internal wires
    not inv1 (clkn,  clk);                          // inverse of clk
    not inv2 (clknn, clkn);                         // inverse of clkn
    d_latch dlatch1 (clkn,  d,  q0, qn0);           // master d latch
    d_latch dlatch2 (clknn, q0, q,  qn);            // slave  d latch
endmodule
