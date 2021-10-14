/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module add4 (a,b,ci,s,co);                   // 4-bit adder using four add1
    input  [3:0] a, b;                       // inputs: a and b
    input        ci;                         // input:  carry_in
    output [3:0] s;                          // output: sum
    output       co;                         // output: carry_out
    wire   [2:0] c;                          // internal carries
    // add1 (a,    b,    ci,   s,    co);
    add1 a0 (a[0], b[0], ci,   s[0], c[0]);  // ci: ci;   s: s[0]; co: c[0]
    add1 a1 (a[1], b[1], c[0], s[1], c[1]);  // ci: c[0]; s: s[1]; co: c[1]
    add1 a2 (a[2], b[2], c[1], s[2], c[2]);  // ci: c[1]; s: s[2]; co: c[2]
    add1 a3 (a[3], b[3], c[2], s[3], co);    // ci: c[2]; s: s[3]; co: co
endmodule
