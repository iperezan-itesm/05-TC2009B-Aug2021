/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module fa_structural (a,b,ci,s,co);          // full adder, structural style
    input  a, b, ci;                         // inputs:  a, b, carry_in
    output s, co;                            // outputs: sum, carry_out
    wire   ab, bc, ca;                       // wires, outputs of and gates
    xor i1 (s,  a,  b,  ci);                 // xor (out, in1, in2, in3);
    and i2 (ab, a,  b);                      // and (out, in1, in2);
    and i3 (bc, b,  ci);                     // and (out, in1, in2);
    and i4 (ca, ci, a);                      // and (out, in1, in2);
    or  i5 (co, ab, bc, ca);                 // or  (out, in1, in2, in3);
endmodule
