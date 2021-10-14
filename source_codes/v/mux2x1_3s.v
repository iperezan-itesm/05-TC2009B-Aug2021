/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module mux2x1_3s (a0, a1, s, y);        // multiplexer using tri-state gates
    input  s, a0, a1;                   // inputs
    output y;                           // output
    // bufif0 (out, in,  ctl);          // tri-state buffer: ctl==0: out=in;
    bufif0 b0 (y,   a0,  s);            //   ctl == 1: out = high-impedance;
    // bufif1 (out, in,  ctl);          // tri-state buffer: ctl==1: out=in;
    bufif1 b1 (y,   a1,  s);            //   ctl == 0: out = high-impedance;
endmodule
