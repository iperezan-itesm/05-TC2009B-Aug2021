/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module gates7_structural (a,b,f_and,f_or,f_not,f_nand,f_nor,f_xor,f_xnor);
    input  a, b;                                                  // inputs
    output f_and, f_or, f_not, f_nand, f_nor, f_xor, f_xnor;      // outputs
    and    i1 (f_and,  a, b);                        // and  (out, in1, in2)
    or     i2 (f_or,   a, b);                        // or   (out, in2, in2)
    not    i3 (f_not,  a);                           // not  (out, in)
    nand   i4 (f_nand, a, b);                        // nand (out, in1, in2)
    nor    i5 (f_nor,  a, b);                        // nor  (out, in1, in2)
    xor    i6 (f_xor,  a, b);                        // xor  (out, in1, in2)
    xnor   i7 (f_xnor, a, b);                        // xnor (out, in1, in2)
endmodule
