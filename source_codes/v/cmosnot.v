/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module cmosnot (f, a);                                   // cmos inverter
    input   a;                                           // input  a
    output  f;                                           // output f = ~a
    supply1 vdd;                                         // logic 1 (power)
    supply0 gnd;                                         // logic 0 (ground)
    // pmos (drain, source, gate);
    pmos p1 (f,     vdd,    a);
    // nmos (drain, source, gate);
    nmos n1 (f,     gnd,    a);
endmodule
