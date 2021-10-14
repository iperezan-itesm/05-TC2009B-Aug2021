/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module cmosnor (f, a, b);               // cmos nor
    input   a, b;                       // inputs: a, b
    output  f;                          // output: f = ~(a | b)
    supply1 vdd;                        // logic 1 (power)
    supply0 gnd;                        // logic 0 (ground)
    wire    w_p;                        // wire: connects 2 pmos transistors
    // nmos (drain, source, gate);
    nmos n1 (f,     gnd,    a);
    nmos n2 (f,     gnd,    b);
    // pmos (drain, source, gate);
    pmos p1 (w_p,   vdd,    a);
    pmos p2 (f,     w_p,    b);
endmodule
