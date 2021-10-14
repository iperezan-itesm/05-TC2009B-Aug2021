/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module mux2x1_gate (a0, a1, s, y);      // multiplexer using ordinary gates
    input  s, a0, a1;                   // inputs
    output y;                           // output
    wire   sn, a0_sn, a1_s;             // internal wires
    not i0 (sn,    s);                  // not (out, in);
    and i1 (a0_sn, a0,    sn);          // and (out, in1, in2);
    and i2 (a1_s,  a1,    s );          // and (out, in1, in2);
    or  i3 (y,     a0_sn, a1_s);        // or  (out, in1, in2);
endmodule
