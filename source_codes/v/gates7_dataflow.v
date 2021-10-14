/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module gates7_dataflow (a,b,f_and,f_or,f_not,f_nand,f_nor,f_xor,f_xnor);
    input  a, b;                                                  // inputs
    output f_and, f_or, f_not, f_nand, f_nor, f_xor, f_xnor;      // outputs
    assign f_and  =   a & b;                          // and
    assign f_or   =   a | b;                          // or
    assign f_not  = ~ a;                              // not
    assign f_nand = ~(a & b);                         // nand = not(a and b)
    assign f_nor  = ~(a | b);                         // nor  = not(a or  b)
    assign f_xor  =   a ^ b;                          // xor
    assign f_xnor = ~(a ^ b);                         // xnor = not(a xor b)
endmodule
