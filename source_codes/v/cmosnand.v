/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module cmosnand (f, a, b);              // cmos nand
    input   a, b;                       // inputs: a, b
    output  f;                          // output: f = ~(a & b)
    supply1 vdd;                        // logic 1 (power)
    supply0 gnd;                        // logic 0 (ground)
    wire    w_n;                        // wire: connects 2 nmos transistors
    // pmos (drain, source, gate);
    pmos p1 (f,     vdd,    a);
    pmos p2 (f,     vdd,    b);
    // nmos (drain, source, gate);
    nmos n1 (f,     w_n,    a);
    nmos n2 (w_n,   gnd,    b);
endmodule
