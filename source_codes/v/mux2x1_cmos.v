/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module mux2x1_cmos (a0, a1, s, y);     // multiplexer using cmos transistors
    input  s, a0, a1;                  // inputs
    output y;                          // output
    wire   sn;                         // internal wire, output of cmosnot
    // cmosnot  (f,  a);               // a cmos invert: (out, in)
    cmosnot inv (sn, s);
    // cmoscmos (drain, source, n_gate, p_gate);
    cmoscmos c0 (y,     a0,     sn,     s);
    cmoscmos c1 (y,     a1,     s,      sn);
endmodule
