/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module addsub4 (a,b,ci,sub,s,co);            // 4-bit adder/subtracter
    input  [3:0] a, b;                       // inputs: a, b
    input        ci;                         // input:  carry_in
    input        sub;                        // input:  sub==1: s=a-b-ci
                                             // input:  sub==0: s=a+b+ci
    output [3:0] s;                          // output: sum
    output       co;                         // output: carry_out
    // sub==1, ci==0: a-b-ci = a+(-b)-0 = a+(~b+1)-0 = a+(b^sub)+(ci^sub)
    // sub==1, ci==1: a-b-ci = a+(-b)-1 = a+(~b+1)-1 = a+(b^sub)+(ci^sub)
    // sub==0, ci==0: a+b+ci = a+  b +0 = a+  b   +0 = a+(b^sub)+(ci^sub)
    // sub==0, ci==1: a+b+ci = a+  b +1 = a+  b   +1 = a+(b^sub)+(ci^sub)
    wire   [3:0] bx  = b  ^ {4{sub}};        // b  xor sub
    wire         cix = ci ^ sub;             // ci xor sub
    wire   [2:0] c;                          // internal carries
    // add1 (a,    b,     ci,   s,    co);
    add1 a0 (a[0], bx[0], cix,  s[0], c[0]); // b: bx[0], ci: cix;  co: c[0]
    add1 a1 (a[1], bx[1], c[0], s[1], c[1]); // b: bx[1], ci: c[0]; co: c[1]
    add1 a2 (a[2], bx[2], c[1], s[2], c[2]); // b: bx[2], ci: c[1]; co: c[2]
    add1 a3 (a[3], bx[3], c[2], s[3], co);   // b: bx[3], ci: c[2]; co: co
endmodule
